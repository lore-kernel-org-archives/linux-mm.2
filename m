Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FC28606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 01:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=lGVBkJvh
Received: by kanga.kvack.org (Postfix)
	id BE9486B0729; Thu, 19 Nov 2026 20:07:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC12C6B072A; Thu, 19 Nov 2026 20:07:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3B4B6B072B; Thu, 19 Nov 2026 20:07:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6A4986B0729
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:07:20 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C2359C0CB3
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:07:19 +0000 (UTC)
X-FDA: 85453708998.02.7C4E4A9
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0E8091A0003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:07:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=lGVBkJvh;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3RJ3_agYKCNsIOFWWLDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--lrizzo.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3RJ3_agYKCNsIOFWWLDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--lrizzo.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795136838;
	b=yxyjCFjkLnvCxyL4tPQKXPfRIqlKHueinjf4GwSblhkfN44VL8PYrikIKrKf0RUT9AOEJD
	gaBMjlWpM2CW+qENNJS1yKNTdXWr+ZwhOt3H7aAbia87xdtpSYRCGBj2UDztOy4Qbw21hv
	K3OcEnK4y3VaYHQD34L56QxyHEqP25U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795136838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+NFTm4L2VhbLUpPdiBhNTRzw8j2BUIljmUbg5vzbrRk=;
	b=XXIM2x+1C2bcNn1t3sKQU5nGOfgmcNk0g1tO6ffUg2vOI6WC+ubnokM4OJwJcn2orqOmi5
	mjrGAQXon/h6No5tzi6Yg7gyLx6PpoaYjzKswWEc2qPdt41YuDprjwsGKcgB8Pmi5KeRDI
	lvahYaljup6XPtkTFIBlSf/iuQkSTwo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=lGVBkJvh;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3RJ3_agYKCNsIOFWWLDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--lrizzo.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3RJ3_agYKCNsIOFWWLDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--lrizzo.bounces.google.com
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c50549f6cf1so22010866b.3
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:07:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795136837; x=1795741637; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+NFTm4L2VhbLUpPdiBhNTRzw8j2BUIljmUbg5vzbrRk=;
        b=lGVBkJvh191CGYr+1kYQqcx/U5xhUz7cv+WngfppLuQankfaodIrDC84bmMO9BrUYD
         gGgRfWfI00Gy5Xq2PBla5bYTmpqYGYhBo8bP2cExxqKvSO3Bp5d8V6RbBAyH912b3l17
         obRz773Z6aT9JAEzU+2pfmk5fXaf3oZBAqjcA/tgCQ1hsrU0ntOqKJYWkbjMvlUjYyhu
         2SFaPK+77c5+lqizl7mx+bNt/WOgm1CpUk+6MZ55nllKmUl0C//PvjF2yzfR2SAGTsBq
         0X785avL2lDlZVqJ3uq2s7hzz2YYOx3tMpfxOSq/B73o/qNPFbV50I8P32ODbcwCel2/
         9jMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795136837; x=1795741637;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+NFTm4L2VhbLUpPdiBhNTRzw8j2BUIljmUbg5vzbrRk=;
        b=oxSrB4wO3zQ+B5i9NnwNOkhbBU31cEu4D5wwVFMwKr81shayd99kZJulbQ+CRD46Ih
         0AkX3oBXOUCpLEpSmlCvyf7W+yWGCQ7l9ToOIpMEpROHnUYqprSMvqK+36YA3Mz4oJ7a
         xLuHX4K4KQ36dJD610+huQnLY+6YJkzhrHnNx1uICMI2hBfCLjmmgjbwpBzi2LbxEwa+
         T5TQtUSpzAF87ixGnzfMuqx6LAEOwRMngdy+d6gwd174Q/b783FF4uz9g+oDd08bI7Um
         ECEmwuK0X4EyNyQM9FOEMnyRwT6kqu2F2/2nAPhEcy0SnMe7ehVra220LnlzfkZBbpB3
         H9eA==
X-Forwarded-Encrypted: i=1; AL+hErHytqpPILI9Q6HemN4zOgMXhCpLDfeDbGNnitYFBxGAcLmp9Zif1SIuLwPga089328SsUJcquzAxw==@kvack.org
X-Gm-Message-State: APuU4Z9bgH50ugpG9njxMgUFoQYeC8N7PlRmH72jRU/6eS1UV4mY7Top
	v9Tg3Qu6KIySJJqjYh9t7LCsPHJRX/4UMc1RRu+/Nbr+3OSh6FxJcbuRzQpU3UN3fGAzH50UohK
	UTmgUww==
X-Received: from ejzb4.prod.google.com ([2002:a17:906:d104:b0:c50:fe53:c3ad])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:b02d:b0:c34:1ed:54d9
 with SMTP id a640c23a62f3a-c513a52b544mr118213766b.4.1795136836226; Thu, 19
 Nov 2026 17:07:16 -0800 (PST)
Date: Fri, 20 Nov 2026 01:06:44 +0000
In-Reply-To: <20261120010655.467825-1-lrizzo@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261109182533.3594984-1-lrizzo@google.com> <20261120010655.467825-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261120010655.467825-15-lrizzo@google.com>
Subject: [RFC PATCH v3 14/25] net: Use per-node PISA allocators for skb_page_frag_refill()
From: Luigi Rizzo <lrizzo@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@kernel.org>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Jens Axboe <axboe@kernel.dk>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Luigi Rizzo <rizzo.unipi@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Harry Yoo <harry@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Simon Horman <horms@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Willem de Bruijn <willemb@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Joshua Washington <joshwash@google.com>, 
	Harshitha Ramamurthy <hramamurthy@google.com>, Alexander Lobakin <aleksander.lobakin@intel.com>, 
	Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>, Dragos Tatulea <dtatulea@nvidia.com>, 
	Naman Gulati <namangulati@google.com>, Pranjal Shrivastava <praan@google.com>, 
	Mostafa Saleh <smostafa@google.com>, Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, 
	iommu@lists.linux.dev, netdev@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspam-User:
X-Spam-Status: No, score=-22.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0E8091A0003
X-Stat-Signature: e67u79pejdp6pejjfyjka8rbnnyi5rq4
X-HE-Tag: 1795136837-704250
X-HE-Meta: U2FsdGVkX1/y3izoFkBGeiciwWxle7Ox+HLCFsMN8+cA03OhFlMluEHDZJS/GOteC+b8NuBKPCSiYt8TWOJ4CoInoIO6sPMVZv7X3E/sPt14rwYsbisWM/HJMGQIdo3NJBBDlACi8PecVQ6TDWQ5W1rEoLrUTZDoQM7+GjXlAZgjwRBupuNvtW7lH+k0dil9bqqdi5VLCp58TQfSCuH+PNxu1Q6M4/SOLCD6VmVJYRYacfpy+c8ubYl9HB7NoYVHH1QJ6vhqgQIrX1orVyEzJ5WcRqCcCpRribOJyldjwJj2dSOKqTyRuB52rClXD1C+TJMfz0Vw9RcSvDa2ACkDEcISHMWTAOejlSd7e3Vxzs4NRLJadpNy+R3x2OyWvga6v6muY525Uid333hUaxO7mIZeXspggQls1wZrwOzANLQvL1Gp6PF6qg3owhG3pmBu2XS/sHytuweCFWDZsIo+ClJNIxSIZoPU9Lb44AxXNulXvL53n0/0fvTaeXYY+r/9RB6c7RnIb5fNdi88XYMTAd3FBbmFjB2simuZdqJWW4BCaf0ju0M94noDCaa8kehXij9hVBn3GsBn+CLtlT/4bA318oix4sBf6o98jmG+s41OwVa/kkT/276/uHrRZh/X41VVCzHImCH7n2/3un7BbsTX49d/agqfCsli4FGmjB1Iv5Qk0O/pqQSLJ/k0CU5jB3B7dSa7/mbotjMscy64suYioAu6d2ZbHpYuUJoSWw+B6SwkVLgh8thBC4TG8tRAmURJ9ddqMlAIkB88AiQbP6HDFciUq3yisJMvaMPEYmp+KDTsYfR8IbWno0bsueZYff4cKqG/0bJjgec3kompJARSy+ibO/DsF0n9MFmCpyzLQj3G5up7GYJlo4DtdJAOcbH8vcKe9goLyfvx9emmLgwZ3zqWlxcERAoVKwJtxdMw2Uf+RUrkQ18noqDLGJBI+Xb7nhfrG+JaiXeNyR8
 dGPWUOXg
 s5ywY7f1Py/cp4dWT6BocsqX0IuHhHiOckignA8F+m3tGglXlKjrSgyw6EY1WUR5VM2MKVDVxy+Z8W/cLGzfWxdRwEw8WA/xhG6DBFzKyOs7mpqqYNvWR46frzm7Hw1wd2RH0kuNAft5S37E1sw3NeimogQk6f+2aHqMg9XkdXoywk/xQe82ctavesswIQfQoPGA2Oe9UICW851mIpQxniUJ9s5gwRK4F8CRt3Lo3RZoX3CTy/iv2iDCh4i8DmphMpJq9c/A+ouLUMb+dJVxsD6j4bX+8zSsUdHb8dpQf9ATAsY3QjDeaafss4yjMn3gYDoR2x4yrE6OgohcKBG5khb3IQCIse2s08yRLpWcXJZPpkNS71FvS6PEL79e92Vc7xr7goyqEmbggF3uvGY/oSVxjPYpEHbijQDlSPq2mdHZlVRquFnS6HIpghDTVjwf8JsYPHGbmRoLzz18vEwHeA7vUU2lyF6DZP5Zd0D21kh0piLvLFL4xvo59YWSCJ2CzphnSF//PzG/0yDn8kuh1ZVk1PMt/VPLIer1ZhYt6WfV+GbVGzs+qVmGRkslVseZO70xp7MMLLD+cQqTG8UFN+PErD0uOjEtCIH93J33R76oyePodLikK3K/VuVx/7bhvfuFe9NMYlFvy9m3tJedPtSz+XER/Sc9T6MQQImOykxTuIWt576B0aq6ucPeIfBS8vEY948FlncLI/5jQNMMp/xJ644EXK/YsL30/41LczwCuIAlU48nKq/zN3b6iGvRVp9ntBmwv28yY/k6C97N1jI8uAr/koJHWsJK0Q1qcX5PTMaC06RhjwIsOrRckD8XYmgtS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Transmit socket buffers use memory coming from skb_page_frag_refill().
Sockets whose leaf device has enabled pisa_tx_bufs should use PISA
memory.

Add a dedicated per-task page_frag, current->task_frag_pisa, populated
with read-only PISA blocks via __GFP_PISA, and select it on TX when
the socket's (or cork's) route goes out in the clear through a PISA-enabled
device.

Special paths that hold plaintext before encryption (IPsec, kTLS) or
do not use a DMA device keep using regular pages; ESP output uses
pisa_tx_bufs_gfp() to opt in when the egress device has pisa_tx_bufs
enabled.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 include/linux/pisa.h  | 15 +++++++++++++++
 include/linux/sched.h |  4 ++++
 include/net/pisa.h    | 33 +++++++++++++++++++++++++++++++++
 kernel/exit.c         |  2 ++
 kernel/fork.c         |  2 ++
 net/core/sock.c       | 10 ++++++++++
 net/ipv4/esp4.c       |  7 +++++--
 net/ipv4/ip_output.c  | 12 ++++++++----
 net/ipv4/tcp.c        |  3 ++-
 net/ipv6/esp6.c       |  7 +++++--
 net/ipv6/ip6_output.c | 12 ++++++++----
 11 files changed, 94 insertions(+), 13 deletions(-)

diff --git a/include/linux/pisa.h b/include/linux/pisa.h
index 6d184e393e297..84692852299f1 100644
--- a/include/linux/pisa.h
+++ b/include/linux/pisa.h
@@ -202,6 +202,18 @@ static inline bool pisa_page_can_recycle(const struct page *page)
 	       __pisa_page_can_recycle(page);
 }
 
+/* Hooks for dup_task_struct() and do_exit() (guarded by @pisa_key on release). */
+static inline void pisa_task_frag_init(struct task_struct *tsk)
+{
+	tsk->task_frag_pisa.page = NULL;
+}
+
+static inline void pisa_task_frag_release(struct task_struct *tsk)
+{
+	if (pisa_enabled() && tsk->task_frag_pisa.page)
+		put_page(tsk->task_frag_pisa.page);
+}
+
 #else /* !CONFIG_PISA */
 
 static inline int pisa_meta_init(void) { return -EOPNOTSUPP; }
@@ -240,6 +252,9 @@ static inline bool pisa_page_can_recycle(const struct page *page)
 	return true;
 }
 
+static inline void pisa_task_frag_init(struct task_struct *tsk) {}
+static inline void pisa_task_frag_release(struct task_struct *tsk) {}
+
 static inline bool pisa_upgrade_user_pages(struct iov_iter *iter,
 					   struct page **pages, size_t size,
 					   size_t offset,
diff --git a/include/linux/sched.h b/include/linux/sched.h
index e4f6323d78555..a8edeeb2661f4 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1455,6 +1455,10 @@ struct task_struct {
 	struct pipe_inode_info		*splice_pipe;
 
 	struct page_frag		task_frag;
+#ifdef CONFIG_PISA
+	/* TX frag that may hold PISA pages, see sk_page_frag_dst(). */
+	struct page_frag		task_frag_pisa;
+#endif
 
 #ifdef CONFIG_ARCH_HAS_LAZY_MMU_MODE
 	struct lazy_mmu_state		lazy_mmu_state;
diff --git a/include/net/pisa.h b/include/net/pisa.h
index 1f95e67e99bf8..8e23d8b01e73d 100644
--- a/include/net/pisa.h
+++ b/include/net/pisa.h
@@ -4,6 +4,7 @@
 #define _NET_PISA_H
 
 #include <linux/pisa.h>
+#include <linux/tcp.h>
 #include <net/sock.h>
 
 /*
@@ -72,10 +73,42 @@ static inline gfp_t pisa_tx_bufs_gfp(const struct sk_buff *skb)
 	       __pisa_tx_gfp(skb_dst(skb), PISA_TX_FLAG_BUFS | PISA_TX_XFRM_OK) : 0;
 }
 
+/* Hook for skb_page_frag_refill() and __ip*_append_data() (@net_pisa_tx_bufs_key). */
+static inline bool is_pisa_pfrag(const struct page_frag *pfrag)
+{
+	return static_branch_unlikely(&net_pisa_tx_bufs_key) &&
+	       pfrag == &current->task_frag_pisa;
+}
+
+/* Hook for task/socket TX page_frag selection (@net_pisa_tx_bufs_key). */
+static inline struct page_frag *task_page_frag(const struct dst_entry *dst)
+{
+	return use_pisa_tx_bufs(dst) ? &current->task_frag_pisa : &current->task_frag;
+}
+
+static inline struct page_frag *sk_page_frag_dst(struct sock *sk,
+						 const struct dst_entry *dst)
+{
+	return static_branch_unlikely(&net_pisa_tx_bufs_key) &&
+	       sk->sk_use_task_frag ? task_page_frag(dst) : sk_page_frag(sk);
+}
+
 #else /* !CONFIG_PISA */
 
 static inline bool use_pisa_tx_bufs(const struct dst_entry *dst) { return false; }
 static inline gfp_t pisa_tx_bufs_gfp(const struct sk_buff *skb) { return 0; }
+static inline bool is_pisa_pfrag(const struct page_frag *pfrag) { return false; }
+
+static inline struct page_frag *task_page_frag(const struct dst_entry *dst)
+{
+	return &current->task_frag;
+}
+
+static inline struct page_frag *sk_page_frag_dst(struct sock *sk,
+						 const struct dst_entry *dst)
+{
+	return sk_page_frag(sk);
+}
 
 #endif /* CONFIG_PISA */
 #endif /* _NET_PISA_H */
diff --git a/kernel/exit.c b/kernel/exit.c
index d5e7bc2af804a..ac7ca1fb180c3 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/mm.h>
+#include <linux/pisa.h>
 #include <linux/slab.h>
 #include <linux/sched/autogroup.h>
 #include <linux/sched/mm.h>
@@ -1009,6 +1010,7 @@ void __noreturn do_exit(long code)
 
 	if (tsk->task_frag.page)
 		put_page(tsk->task_frag.page);
+	pisa_task_frag_release(tsk);
 
 	exit_task_stack_account(tsk);
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 5efceb8d58a78..d235d7ab04687 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -44,6 +44,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include <linux/pisa.h>
 #include <linux/mm_inline.h>
 #include <linux/memblock.h>
 #include <linux/nsproxy.h>
@@ -982,6 +983,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 #endif
 	tsk->splice_pipe = NULL;
 	tsk->task_frag.page = NULL;
+	pisa_task_frag_init(tsk);
 	tsk->wake_q.next = NULL;
 	tsk->worker_private = NULL;
 
diff --git a/net/core/sock.c b/net/core/sock.c
index ad414878dc5ba..56dea49baaec2 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -115,6 +115,7 @@
 #include <linux/memcontrol.h>
 #include <linux/prefetch.h>
 #include <linux/compat.h>
+#include <linux/pisa.h>
 #include <linux/mroute.h>
 #include <linux/mroute6.h>
 #include <linux/icmpv6.h>
@@ -147,6 +148,7 @@
 #include <net/tcp.h>
 #include <net/busy_poll.h>
 #include <net/phonet/phonet.h>
+#include <net/pisa.h>
 
 #include <linux/ethtool.h>
 
@@ -3257,13 +3259,21 @@ DEFINE_STATIC_KEY_FALSE(net_high_order_alloc_disable_key);
  */
 bool skb_page_frag_refill(unsigned int sz, struct page_frag *pfrag, gfp_t gfp)
 {
+	/* PISA pages only go into current->task_frag_pisa, see sk_page_frag_dst(). */
+	if (is_pisa_pfrag(pfrag))
+		gfp |= __GFP_PISA;
+
 	if (pfrag->page) {
 		if (page_ref_count(pfrag->page) == 1) {
+			if (!!(gfp & __GFP_PISA) != is_pisa_page(pfrag->page) ||
+			    ((gfp & __GFP_PISA) && !pisa_page_can_recycle(pfrag->page)))
+				goto drop_page;
 			pfrag->offset = 0;
 			return true;
 		}
 		if (pfrag->offset + sz <= pfrag->size)
 			return true;
+drop_page:
 		put_page(pfrag->page);
 	}
 
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index ae701561d9f12..8ed713772e4ee 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -20,6 +20,7 @@
 #include <net/udp.h>
 #include <net/tcp.h>
 #include <net/espintcp.h>
+#include <net/pisa.h>
 #include <linux/skbuff_ref.h>
 
 #include <linux/highmem.h>
@@ -451,7 +452,8 @@ int esp_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *
 
 			spin_lock_bh(&x->lock);
 
-			if (unlikely(!skb_page_frag_refill(allocsize, pfrag, GFP_ATOMIC))) {
+			if (unlikely(!skb_page_frag_refill(allocsize, pfrag,
+							   GFP_ATOMIC | pisa_tx_bufs_gfp(skb)))) {
 				spin_unlock_bh(&x->lock);
 				goto cow;
 			}
@@ -560,7 +562,8 @@ int esp_output_tail(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *
 		allocsize = ALIGN(skb->data_len, L1_CACHE_BYTES);
 
 		spin_lock_bh(&x->lock);
-		if (unlikely(!skb_page_frag_refill(allocsize, pfrag, GFP_ATOMIC))) {
+		if (unlikely(!skb_page_frag_refill(allocsize, pfrag,
+						   GFP_ATOMIC | pisa_tx_bufs_gfp(skb)))) {
 			spin_unlock_bh(&x->lock);
 			goto error_free;
 		}
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index d42d776af273e..50b8c92c3cd5e 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -71,6 +71,7 @@
 #include <net/xfrm.h>
 #include <linux/skbuff.h>
 #include <net/sock.h>
+#include <net/pisa.h>
 #include <net/arp.h>
 #include <net/icmp.h>
 #include <net/checksum.h>
@@ -986,7 +987,10 @@ static int __ip_append_data(struct sock *sk,
 
 	exthdrlen = !skb ? rt->dst.header_len : 0;
 	mtu = cork->gso_size ? IP_MAX_MTU : cork->fragsize;
-	paged = !!cork->gso_size;
+	paged = !!cork->gso_size ||
+		(getfrag == ip_generic_getfrag &&
+		 (rt->dst.dev->features & NETIF_F_SG) &&
+		 is_pisa_pfrag(pfrag));
 
 	hh_len = LL_RESERVED_SPACE(rt->dst.dev);
 
@@ -1383,8 +1387,8 @@ int ip_append_data(struct sock *sk, struct flowi4 *fl4,
 	}
 
 	return __ip_append_data(sk, fl4, &sk->sk_write_queue, &inet->cork.base,
-				sk_page_frag(sk), getfrag,
-				from, length, transhdrlen, flags);
+				sk_page_frag_dst(sk, inet->cork.base.dst),
+				getfrag, from, length, transhdrlen, flags);
 }
 
 static void ip_cork_release(struct inet_cork *cork)
@@ -1592,7 +1596,7 @@ struct sk_buff *ip_make_skb(struct sock *sk,
 		return ERR_PTR(err);
 
 	err = __ip_append_data(sk, fl4, &queue, cork,
-			       &current->task_frag, getfrag,
+			       sk_page_frag_dst(sk, cork->dst), getfrag,
 			       from, length, transhdrlen, flags);
 	if (err) {
 		__ip_flush_pending_frames(sk, &queue, cork);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 832b25ddd3c2e..3c3edc48705d7 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -273,6 +273,7 @@
 #include <net/inet_common.h>
 #include <net/inet_ecn.h>
 #include <net/tcp.h>
+#include <net/pisa.h>
 #include <net/tcp_ecn.h>
 #include <net/mptcp.h>
 #include <net/proto_memory.h>
@@ -1295,7 +1296,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 		if (zc == 0) {
 			bool merge = true;
 			int i = skb_shinfo(skb)->nr_frags;
-			struct page_frag *pfrag = sk_page_frag(sk);
+			struct page_frag *pfrag = sk_page_frag_dst(sk, __sk_dst_get(sk));
 
 			if (!sk_page_frag_refill(sk, pfrag))
 				goto wait_for_space;
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index d654f0f442388..98ed9120ae7b4 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -36,6 +36,7 @@
 #include <net/tcp.h>
 #include <net/espintcp.h>
 #include <net/inet6_hashtables.h>
+#include <net/pisa.h>
 #include <linux/skbuff_ref.h>
 
 #include <linux/highmem.h>
@@ -481,7 +482,8 @@ int esp6_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info
 
 			spin_lock_bh(&x->lock);
 
-			if (unlikely(!skb_page_frag_refill(allocsize, pfrag, GFP_ATOMIC))) {
+			if (unlikely(!skb_page_frag_refill(allocsize, pfrag,
+							   GFP_ATOMIC | pisa_tx_bufs_gfp(skb)))) {
 				spin_unlock_bh(&x->lock);
 				goto cow;
 			}
@@ -592,7 +594,8 @@ int esp6_output_tail(struct xfrm_state *x, struct sk_buff *skb, struct esp_info
 		allocsize = ALIGN(skb->data_len, L1_CACHE_BYTES);
 
 		spin_lock_bh(&x->lock);
-		if (unlikely(!skb_page_frag_refill(allocsize, pfrag, GFP_ATOMIC))) {
+		if (unlikely(!skb_page_frag_refill(allocsize, pfrag,
+						   GFP_ATOMIC | pisa_tx_bufs_gfp(skb)))) {
 			spin_unlock_bh(&x->lock);
 			goto error_free;
 		}
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index cb648c8394310..8f6f0bed15499 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -40,6 +40,7 @@
 #include <linux/netfilter_ipv6.h>
 
 #include <net/sock.h>
+#include <net/pisa.h>
 #include <net/snmp.h>
 
 #include <net/gso.h>
@@ -1489,7 +1490,10 @@ static int __ip6_append_data(struct sock *sk,
 		dst_exthdrlen = rt->dst.header_len - rt->rt6i_nfheader_len;
 	}
 
-	paged = !!cork->gso_size;
+	paged = !!cork->gso_size ||
+		(getfrag == ip_generic_getfrag &&
+		 (rt->dst.dev->features & NETIF_F_SG) &&
+		 is_pisa_pfrag(pfrag));
 	mtu = cork->gso_size ? IP6_MAX_MTU : cork->fragsize;
 	orig_mtu = mtu;
 
@@ -1892,8 +1896,8 @@ int ip6_append_data(struct sock *sk,
 	}
 
 	return __ip6_append_data(sk, &sk->sk_write_queue, &inet->cork,
-				 sk_page_frag(sk), getfrag,
-				 from, length, transhdrlen, flags);
+				 sk_page_frag_dst(sk, inet->cork.base.dst),
+				 getfrag, from, length, transhdrlen, flags);
 }
 EXPORT_SYMBOL_GPL(ip6_append_data);
 
@@ -2095,7 +2099,7 @@ struct sk_buff *ip6_make_skb(struct sock *sk,
 	}
 
 	err = __ip6_append_data(sk, &queue, cork,
-				&current->task_frag, getfrag, from,
+				sk_page_frag_dst(sk, cork->base.dst), getfrag, from,
 				length + exthdrlen, transhdrlen + exthdrlen,
 				flags);
 	if (err) {
-- 
2.56.1.809.ga0b61035b5-goog


