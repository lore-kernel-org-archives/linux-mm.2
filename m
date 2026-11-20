Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0493A606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 01:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=g2Dmu+wq
Received: by kanga.kvack.org (Postfix)
	id 0ECDD6B06B8; Thu, 19 Nov 2026 20:07:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0281D6B071A; Thu, 19 Nov 2026 20:07:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E80C86B072E; Thu, 19 Nov 2026 20:07:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8967E6B06B8
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:07:24 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C0791C0CB8
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:07:23 +0000 (UTC)
X-FDA: 85453709166.18.603A9C7
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0F11D40003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:07:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=g2Dmu+wq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3SJ3_agYKCN8MSJaaPHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--lrizzo.bounces.google.com designates 209.85.208.70 as permitted sender) smtp.mailfrom=3SJ3_agYKCN8MSJaaPHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--lrizzo.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795136842;
	b=wL5ubp4LMZG5WDeHeak2JZiZzRkwW7rH1MWiz7ZSdi4/ZdGvz5x0Sz0Hv+2sH0ykd92uI0
	iWDmrvBhUBrf0OrVfvzCRCE7CsH5REcg0qwVT2IUu77G0XDCP7SP/L0sjxj9LZ37n7Wptw
	v3PSQ+Nj16sYwCW4UvQvcAXqljgnKF0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795136842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5SEs/blsCReRT4hCMThOeNKTJAt5emco8Ap+aYEQIPY=;
	b=dNkvYjLQ+8fpWz8kc0I/13Doae08FfFePLqZEr/YZKWCBPAdO55qgu0J6Rcu3XMip7xvrG
	JolkcwPSG7tEk4tUPdqE/peU91W6LQYoQTuD7v6zjQCmEt1U2iizQLCbEVWPA8DewBBQZ2
	mYVnWxIQky+aGJqOWYt1Mbj1vN4voTQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=g2Dmu+wq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3SJ3_agYKCN8MSJaaPHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--lrizzo.bounces.google.com designates 209.85.208.70 as permitted sender) smtp.mailfrom=3SJ3_agYKCN8MSJaaPHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--lrizzo.bounces.google.com
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-6b706aec674so339804a12.2
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:07:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795136841; x=1795741641; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5SEs/blsCReRT4hCMThOeNKTJAt5emco8Ap+aYEQIPY=;
        b=g2Dmu+wqEdPNemGNjsjGD7cHUGJ3JEAiuDVC4mHLmiW3rLFGU1sEZYWj2qUVUhk2bk
         N4+HCuu/4reP1UHz4mdh3IXZmoXXc7J0i6b080bz3acQkxxgqpZexb8j+7RT/2rlQxYQ
         e6QRqztWHljS2W6EgR/V4+EjsZNsxiOOU+LOOw00fq4Z0sIf1SNmun1BmK/iz2p1IaNO
         DQaDKXDp1Uc2N83Me4YWuLuSEBsX8oMqyvQrb4OWMp3nx0DIC7Nk+vBoE8K9oDk4Sggf
         pNm4nezd91/+BnpVkDyqXDZYOM2uaj5Devm8/N9IXILFZGqZZJgI9bevMVw/gDi7VitE
         aTjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795136841; x=1795741641;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5SEs/blsCReRT4hCMThOeNKTJAt5emco8Ap+aYEQIPY=;
        b=O8WUTtbipu/NV0f6/UlD9cmoR6JmAS4SbvWoIx4QY1rHHkDJ9A67ibtfhUQizBHkjD
         0vmoKdJ4lAXlwYVVdwQeRkKWIkWUoRiothOQDIlinenCfBQ0sUxWW/lFuBUS2veZMzOr
         ekm/V3/rco9pIydZNERpnJFsbEltcAvfXjOTAzAysIPN/R9Wy7YBdfSmmXYHJoXDSBw7
         tNIX28rBVNxEkH3Ie6fXlRHaN6pSNafJw/bxmavWaR4uwkbPDh+WvtZ0PAYXgfMggzPM
         4Vg++h/SZ9JRc0/UEJXKNx8Rj8MZw5+zH8u0+/Tbxaa9fvYmlVfHd+olvP404EQB2ytO
         Wk1Q==
X-Forwarded-Encrypted: i=1; AL+hErG0g++T3buLeFkB5WLOFpgNNqOrGw6FL1jrPpT36xbW04Bg274f4ZufB5UUcmyEV5XGC640j+iPBg==@kvack.org
X-Gm-Message-State: APuU4Z8RI3vkGftOGPmTKHRMUzNysUnNrdIEuIfDvF1cEvyD/WVg//Cx
	rS/Jrje8h5BIWpaVGXAbsElSRy7eZBJb63Gpc0CHc47CUzzGOidm4n8QD6/HZ/Rb2fAgiu6UFs1
	YUHMbPA==
X-Received: from edcnu5-n1.prod.google.com ([2002:a05:6402:c505:10b0:6ba:2090:b8e7])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:a210:20b0:6b8:81fb:aebc
 with SMTP id 4fb4d7f45d1cf-6ba37e7e94fmr649614a12.19.1795136840334; Thu, 19
 Nov 2026 17:07:20 -0800 (PST)
Date: Fri, 20 Nov 2026 01:06:48 +0000
In-Reply-To: <20261120010655.467825-1-lrizzo@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261109182533.3594984-1-lrizzo@google.com> <20261120010655.467825-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261120010655.467825-19-lrizzo@google.com>
Subject: [RFC PATCH v3 18/25] net: Migrate user pages into PISA for MSG_ZEROCOPY
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
X-Rspamd-Queue-Id: 0F11D40003
X-Stat-Signature: iy6zb9j5px9d7ih4mjo1wiizju7ytokj
X-Rspam-User:
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam01
X-HE-Tag: 1795136841-427428
X-HE-Meta: U2FsdGVkX19lXrxiymsinuU5iv/IJ1jOlpI7nFtS9a9PGrWtVt0RAC/xV8ZMqU/gshtVVWKb8h4NQKwKYm8f610UUcr/+a+Nk25dHux1K6wqX2seO69nir3PCG80DnYmrSs4bd1FzGKBxZT5s13rGscORDW/H0ZqCEdQGtZg4v+dbDJ0NdLSRC+d7UIIA18U+FA+x7I1TD/lYjhIyy8bdEmAOHOsuGbhRvm3WR/Sqpb8JkLJDzsB8lNR0s9LhPqr6wrx7T6KUc+hUdcRFMu5SyzVUXzy3aa0HPn5XHbphOsgze7tCiPuyl5flX9viBjWnvDXyzrmuX7OBw+EfvPfkIOKm86q2U2r8/ykXNSaGZ1uuaByOoxHUajFbTg2dI+FR9LW2GmaQZaICPPhT19t383FyrytM4MuT4D1dUimsfIKF53iw/qWVYVG+505Ebnkl5tzhT6mXlECH02qDolxWZDEqtD/KWGMCkgmANpL3RjFyKqnu1N0o2F/ug0RPrDSWYCfpXWGfjckwQZyskXp3jVrjDC2Tul86JPlefC3c6+hyWPFltyI6IrBdQQJVst1HsxYiSGwmcqXPuNHEhw033+snFkTGl3XDc71LhO1RYvs5a2QasyOoBCfSwUTSwxYFVDPnqobXhjhluqFw7aYjnATktlIssMxPOx0srU/pn/HCqpcz0OAubu17uxw6Tmm3RuM8L8YMyRuD3jdIB6T8pAeWXlXXMRNSpN/41KsAM7f7a2c8Kgsddy4pG5J0YjGtpPvyLeflayYcMEVrBCrjPPJUOBKazneOpeXTMVPbd2Dl/kq1Ll9WzjjLqV2h+iHAuUJEpxZeFu4oCq8LfNirbQbnp2Khou006uM2sLokWmDhkg3e/g6zTXvMMS1ODhW2ErywVnmDjPJHt6DxhmiN5fFninQYT//bx352tAZpv+4DMMoUHkflU21d/2CGKvmHB8r8ngn2ruJn61LXH8
 iCBnPXDL
 5gXrgzLtTM1X5mjtKg/lqyqGvjpkeJf0A3ni2r9/NMn2tKjHjYAa+vhhlZsrkcXyIeIRY+/L8DXB9Uz0RgVu2BimYLf2B6Qd65W7vCFYZRXB3VtprdMPWcq/SxhR9GLemUdb4lGHuMLajz+FtDNoQchUakH9/Dezx+ryMyZ30MdXURPPvMICGEPh/6yKk3DUzHKsAS0PMzJ5mQSzxHuNfeFvIHyEFLjdfxoDVXishoq5EUyfAEKyMiV9SU4ZfPznHOL7gkorCAsTqkqaeE+ZagGC2jgkde6n8HGNHc9x7KTOPcsiyqVrSAmkqxY8rpc37Ne7Wj4Tk0cT13trQspw0Dx4J9H84p97ysQutHW4JuChv1k0WxG6yCjYfVlLtHh6ecTIncuU7oXprgdYDMGlg7+Y8ixydqCgXG92stgrfQvJrCZoK7tm8VtifasbIVzW18RwkwCID3zcdz8XW391RsoL2WlhZe4pyG5eJd7DFu4+0t69Sn5nCYLwNJbcgUrxDhDItfSIbFSki93FaxNZE9+FK7bsq6/AqFYQvtnk7TGMS9Fa2vlVXNEsPdAMpjwJR8p7E7OIrfD+/SzR6rDrhBk+/3qnbDmjnWccgnkHpCpSNF6jYZR7gGj8v3g1B+v+Sv6EhOudGKHbiOUr35RYMC0Cpi/oQh+s7UxB0Y6aDcQxPGYfNYW2w/zdb+lDG1NSZTfyv9kySVktXcc1h23ag1XSlxH3Zir+iNzWpiQ82eGg3QKxdPCa2SZwIwGtZb2U4oKf00QZCIzvuhMqf2UHm3mV/WHxIis8SoUT76JwVOfEKnlfuFjy8TXp3kY3aSstPT8but8Q3iZT3j8AMJVT7zD42uDy0DAqDOD/ln5Mnz3ED8gudNMmSWwuRLpKog/5nC1HkkpOCpMKZgic=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Perform best-effort migration of user pages into PISA memory on
MSG_ZEROCOPY sends in zerocopy_fill_skb_from_iter() when the egress
device has the per-device attribute pisa_tx_zerocopy enabled. For TCP
over a device that also has pisa_tx_bufs enabled, pages that cannot be
migrated fall back to the regular copy path into PISA TX page_frags
without reporting SO_EE_CODE_ZEROCOPY_COPIED.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 include/linux/pisa.h |  3 ++
 include/net/pisa.h   | 32 +++++++++++++--
 mm/pisa-user.c       |  8 ++++
 net/core/datagram.c  | 17 ++++++--
 net/core/pisa-net.c  | 95 ++++++++++++++++++++++++++++++++++++++++++--
 net/core/skbuff.c    |  3 +-
 net/ipv4/tcp.c       | 12 +++++-
 7 files changed, 158 insertions(+), 12 deletions(-)

diff --git a/include/linux/pisa.h b/include/linux/pisa.h
index 84692852299f1..11e3ea9eb263d 100644
--- a/include/linux/pisa.h
+++ b/include/linux/pisa.h
@@ -95,6 +95,7 @@ bool __pisa_page_can_recycle(const struct page *page);
 bool pisa_upgrade_user_pages(struct iov_iter *iter, struct page **pages,
 			     size_t size, size_t offset,
 			     enum dma_data_direction dir, bool pinned);
+bool pisa_page_tx_ok(const struct page *page);
 
 static inline bool pisa_enabled(void)
 {
@@ -264,6 +265,8 @@ static inline bool pisa_upgrade_user_pages(struct iov_iter *iter,
 	return false;
 }
 
+static inline bool pisa_page_tx_ok(const struct page *page) { return false; }
+
 #endif /* CONFIG_PISA */
 
 #if defined(CONFIG_PISA) && defined(CONFIG_IOMMU_DMA)
diff --git a/include/net/pisa.h b/include/net/pisa.h
index 7fe2e7d5aa97e..c95e4ab1f344f 100644
--- a/include/net/pisa.h
+++ b/include/net/pisa.h
@@ -13,9 +13,9 @@ struct sk_buff *__sock_alloc_send_pskb(struct sock *sk, unsigned long header_len
 				       gfp_t gfp);
 
 /*
- * struct net_device caches the PISA enable flags for tx_bufs and tx_heads used
- * by the leaf device, refreshed every 256 jiffies. The helpers below decide
- * whether to use PISA memory for a given dst, sk, skb.
+ * struct net_device caches the PISA enable flags for tx_bufs, tx_heads and
+ * tx_zerocopy used by the leaf device, refreshed every 256 jiffies. The helpers
+ * below decide whether to use PISA memory for a given dst, sk, skb.
  */
 #ifdef CONFIG_PISA
 
@@ -23,6 +23,7 @@ enum pisa_tx_flags {
 	PISA_TX_FLAG_BUFS	= BIT(0),
 	PISA_TX_FLAG_HEADS	= BIT(1),
 	PISA_TX_XFRM_OK		= BIT(2),
+	PISA_TX_FLAG_ZC		= BIT(3),
 	PISA_TX_TSTAMP_MASK	= ~0xffU,
 };
 
@@ -36,6 +37,10 @@ DECLARE_STATIC_KEY_FALSE(net_pisa_tx_skb_heads_key);
 
 u32 pisa_tx_flags_refresh(struct net_device *dev, u32 now);
 void *__pisa_skb_head_alloc_node(gfp_t flags, int node);
+bool __pisa_zc_iter_stop(struct sk_buff *skb, struct iov_iter *from,
+			 size_t *length, const struct sock *sk,
+			 struct page **pages, int max_pages,
+			 unsigned int orig_len, size_t *start, ssize_t *copied);
 
 /*
  * May TX data routed through @dst use PISA pages? Those pages stay readable by
@@ -144,6 +149,18 @@ static inline struct page_frag *sk_page_frag_dst(struct sock *sk,
 	       sk->sk_use_task_frag ? task_page_frag(dst) : sk_page_frag(sk);
 }
 
+/* Hook for __zerocopy_fill_skb_from_iter() MSG_ZEROCOPY upgrade (@pisa_user_key). */
+static inline bool pisa_zc_iter_stop(struct sk_buff *skb, struct iov_iter *from,
+				     size_t *length, const struct sock *sk,
+				     struct page **pages, int max_pages,
+				     unsigned int orig_len, size_t *start,
+				     ssize_t *copied)
+{
+	return pisa_user_enabled() &&
+	       __pisa_zc_iter_stop(skb, from, length, sk, pages, max_pages,
+				   orig_len, start, copied);
+}
+
 #else /* !CONFIG_PISA */
 
 static inline void *pisa_skb_head_alloc_node(gfp_t flags, int node) { return NULL; }
@@ -174,5 +191,14 @@ static inline struct page_frag *sk_page_frag_dst(struct sock *sk,
 	return sk_page_frag(sk);
 }
 
+static inline bool pisa_zc_iter_stop(struct sk_buff *skb, struct iov_iter *from,
+				     size_t *length, const struct sock *sk,
+				     struct page **pages, int max_pages,
+				     unsigned int orig_len, size_t *start,
+				     ssize_t *copied)
+{
+	return false;
+}
+
 #endif /* CONFIG_PISA */
 #endif /* _NET_PISA_H */
diff --git a/mm/pisa-user.c b/mm/pisa-user.c
index 5fb1ec7c45204..e4a4e1a606b24 100644
--- a/mm/pisa-user.c
+++ b/mm/pisa-user.c
@@ -439,6 +439,14 @@ bool pisa_upgrade_user_pages(struct iov_iter *iter, struct page **pages,
 	return true;
 }
 
+/* Is @page, referenced by the caller, PISA memory that devices can read (usable for TX)? */
+bool pisa_page_tx_ok(const struct page *page)
+{
+	unsigned long pfn = page_to_pfn(page);
+
+	return is_pisa_pfn(pfn) && (READ_ONCE(pisa_meta_of_pfn(pfn)->prot) & IOMMU_READ);
+}
+
 /* Migrate the single-page segments already added to @bio; the caller then extracts them again. */
 bool __pisa_bio_migrate_pages(struct bio *bio, struct iov_iter *iter,
 			      enum dma_data_direction dir)
diff --git a/net/core/datagram.c b/net/core/datagram.c
index ecc30a6f83023..c589a543c3166 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -62,6 +62,7 @@
 #include <net/tcp_states.h>
 #include <trace/events/skb.h>
 #include <net/busy_poll.h>
+#include <net/pisa.h>
 
 #include "devmem.h"
 
@@ -632,10 +633,11 @@ int skb_copy_datagram_from_iter_full(struct sk_buff *skb, int offset,
 }
 EXPORT_SYMBOL(skb_copy_datagram_from_iter_full);
 
-int zerocopy_fill_skb_from_iter(struct sk_buff *skb,
-				struct iov_iter *from, size_t length)
+static int __zerocopy_fill_skb_from_iter(struct sk_buff *skb, struct iov_iter *from,
+					 size_t length, const struct sock *sk)
 {
 	int frag = skb_shinfo(skb)->nr_frags;
+	unsigned int orig_len = skb->len;
 
 	if (!skb_frags_readable(skb))
 		return -EFAULT;
@@ -654,6 +656,9 @@ int zerocopy_fill_skb_from_iter(struct sk_buff *skb,
 					    MAX_SKB_FRAGS - frag, &start);
 		if (copied < 0)
 			return -EFAULT;
+		if (pisa_zc_iter_stop(skb, from, &length, sk, pages,
+				      MAX_SKB_FRAGS - frag, orig_len, &start, &copied))
+			return copied;
 
 		length -= copied;
 
@@ -703,6 +708,12 @@ int zerocopy_fill_skb_from_iter(struct sk_buff *skb,
 	return 0;
 }
 
+int zerocopy_fill_skb_from_iter(struct sk_buff *skb,
+				struct iov_iter *from, size_t length)
+{
+	return __zerocopy_fill_skb_from_iter(skb, from, length, NULL);
+}
+
 static int
 zerocopy_fill_skb_from_devmem(struct sk_buff *skb, struct iov_iter *from,
 			      int length,
@@ -760,7 +771,7 @@ int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
 	else if (binding)
 		ret = zerocopy_fill_skb_from_devmem(skb, from, length, binding);
 	else
-		ret = zerocopy_fill_skb_from_iter(skb, from, length);
+		ret = __zerocopy_fill_skb_from_iter(skb, from, length, sk);
 
 	truesize = skb->truesize - orig_size;
 	if (sk && sk->sk_type == SOCK_STREAM) {
diff --git a/net/core/pisa-net.c b/net/core/pisa-net.c
index d0a2c94419187..6422c472029a1 100644
--- a/net/core/pisa-net.c
+++ b/net/core/pisa-net.c
@@ -12,6 +12,8 @@
 #include <linux/pisa.h>
 #include <linux/skbuff.h>
 #include <linux/slab.h>
+#include <linux/mm.h>
+#include <linux/uio.h>
 #include <net/hotdata.h>
 #include <net/pisa.h>
 
@@ -98,9 +100,10 @@ void *__pisa_skb_head_alloc_node(gfp_t flags, int node)
 }
 
 /*
- * The sysfs attributes pisa_tx_bufs and pisa_tx_skb_heads live on the
- * device that does DMA: the closest ancestor of a leaf net_device that has a
- * dma_mask (dev->dev.parent, or further up behind bus glue such as virtio).
+ * The sysfs attributes pisa_tx_bufs, pisa_tx_skb_heads and pisa_tx_zerocopy
+ * live on the device that does DMA: the closest ancestor of a leaf net_device
+ * that has a dma_mask (dev->dev.parent, or further up behind bus glue such as
+ * virtio).
  * A socket route (dst->dev) may instead point to an upper virtual net_device
  * (bond, VLAN, ipvlan, etc.), whose leaves are its lower devices.
  * Walking lower devices via netdev_walk_all_lower_dev_rcu() on every TX
@@ -108,6 +111,7 @@ void *__pisa_skb_head_alloc_node(gfp_t flags, int node)
  * result on the net_device and refreshes it at most once every 256 jiffies:
  *   bit 0 (PISA_TX_FLAG_BUFS):       pisa_tx_bufs enabled on lower device(s)
  *   bit 1 (PISA_TX_FLAG_HEADS):      pisa_tx_skb_heads enabled on lower device(s)
+ *   bit 3 (PISA_TX_FLAG_ZC):         pisa_tx_zerocopy enabled on lower device(s)
  *   bits 31..8 (PISA_TX_TSTAMP_MASK):  upper 24 bits of (u32)jiffies
  */
 static u32 pisa_tx_flags(const struct net_device *dev)
@@ -122,6 +126,8 @@ static u32 pisa_tx_flags(const struct net_device *dev)
 			flags |= PISA_TX_FLAG_BUFS;
 		if (READ_ONCE(parent->pisa_tx_skb_heads))
 			flags |= PISA_TX_FLAG_HEADS;
+		if (READ_ONCE(parent->pisa_tx_zerocopy))
+			flags |= PISA_TX_FLAG_ZC;
 	}
 	return flags;
 }
@@ -160,7 +166,8 @@ u32 pisa_tx_flags_refresh(struct net_device *dev, u32 now)
 		now |= pisa_tx_flags(dev);
 	} else {
 		struct netdev_nested_priv priv = {
-			.data = (void *)(uintptr_t)(PISA_TX_FLAG_BUFS | PISA_TX_FLAG_HEADS),
+			.data = (void *)(uintptr_t)(PISA_TX_FLAG_BUFS | PISA_TX_FLAG_HEADS |
+						    PISA_TX_FLAG_ZC),
 		};
 
 		rcu_read_lock();
@@ -173,3 +180,83 @@ u32 pisa_tx_flags_refresh(struct net_device *dev, u32 now)
 	return now;
 }
 EXPORT_SYMBOL(pisa_tx_flags_refresh);
+
+/*
+ * Upgrade user @pages to PISA memory and, for TCP over a pisa_tx_bufs device,
+ * trim non-PISA trailing pages from the batch.
+ *
+ * MSG_ZEROCOPY sends of @sk may migrate user pages into PISA memory when the
+ * egress device has pisa_tx_zerocopy set. *@tx_bufs tells whether it also has
+ * pisa_tx_bufs set, i.e. whether a copy would land in PISA memory.
+ */
+static bool pisa_zc_enabled(const struct sock *sk, bool *tx_bufs)
+{
+	const struct dst_entry *dst;
+
+	if (!sk || !sk->sk_use_task_frag)
+		return false;
+	guard(rcu)();
+	dst = rcu_dereference(sk->sk_dst_cache);
+	if (!__pisa_tx_gfp(dst, PISA_TX_FLAG_ZC))
+		return false;
+	*tx_bufs = use_pisa_tx_bufs(dst);
+	return true;
+}
+
+bool __pisa_zc_iter_stop(struct sk_buff *skb, struct iov_iter *from,
+			 size_t *length, const struct sock *sk,
+			 struct page **pages, int max_pages,
+			 unsigned int orig_len, size_t *start, ssize_t *copied)
+{
+	unsigned int i, nr;
+	bool tx_bufs;
+	ssize_t keep;
+
+	if (!user_backed_iter(from) || !pisa_zc_enabled(sk, &tx_bufs))
+		return false;
+
+	/* Move user pages into PISA memory, then look them up again. */
+	if (pisa_upgrade_user_pages(from, pages, *copied, *start,
+				    DMA_TO_DEVICE, false)) {
+		*copied = iov_iter_get_pages2(from, pages, *length, max_pages, start);
+		if (*copied <= 0) {
+			if (*copied < 0)
+				*copied = -EFAULT;
+			return true;
+		}
+	}
+
+	/*
+	 * Only TCP plain MSG_ZEROCOPY ubufs can fall back to copy, and the copy
+	 * only helps if it goes into PISA memory.
+	 */
+	if (!tx_bufs || skb->sk ||
+	    (skb_zcopy(skb) && skb_zcopy(skb)->ops != &msg_zerocopy_ubuf_ops))
+		return false;
+
+	/*
+	 * Trim @from to the leading pages that are in PISA memory devices can
+	 * read (an RX-only page would not be mapped for TX): drop the
+	 * references to the others, give their bytes back to @from, and cap
+	 * *@length so that the caller ends after attaching what is left.
+	 */
+	nr = DIV_ROUND_UP(*start + *copied, PAGE_SIZE);
+	for (i = 0; i < nr && pisa_page_tx_ok(pages[i]); i++)
+		;
+	if (i == nr)
+		return false;
+
+	keep = i ? i * PAGE_SIZE - *start : 0;
+	while (nr > i)
+		put_page(pages[--nr]);
+	iov_iter_revert(from, *copied - keep);
+	*length = keep;
+	if (keep) {
+		*copied = keep;
+		return false;
+	}
+
+	/* -EXDEV tells tcp_sendmsg_locked() to copy this chunk instead of zerocopy. */
+	*copied = (skb->len != orig_len) ? 0 : -EXDEV;
+	return true;
+}
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 4f487e0450d4b..be6b6f42ee77e 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1942,7 +1942,8 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
 
 	err = __zerocopy_sg_from_iter(msg, sk, skb, &msg->msg_iter, len,
 				      binding);
-	if (err == -EFAULT || (err == -EMSGSIZE && skb->len == orig_len)) {
+	if (err == -EFAULT ||
+	    ((err == -EMSGSIZE || err == -EXDEV) && skb->len == orig_len)) {
 		u32 delta_truesize = skb->truesize - orig_truesize;
 		struct sock *save_sk = skb->sk;
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 83f8ed2aa9a7e..411714edb90bd 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1132,6 +1132,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 	int process_backlog = 0;
 	int sockc_err = 0;
 	int zc = 0;
+	bool must_copy = false;	/* copy the next chunk of a MSG_ZEROCOPY send */
 	long timeo;
 
 	flags = msg->msg_flags;
@@ -1293,7 +1294,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 		if (copy > msg_data_left(msg))
 			copy = msg_data_left(msg);
 
-		if (zc == 0) {
+		if (zc == 0 || unlikely(must_copy)) {
 			bool merge = true;
 			int i = skb_shinfo(skb)->nr_frags;
 			struct page_frag *pfrag = sk_page_frag_dst(sk, __sk_dst_get(sk));
@@ -1338,6 +1339,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 				page_ref_inc(pfrag->page);
 			}
 			pfrag->offset += copy;
+			must_copy = false;
 		} else if (zc == MSG_ZEROCOPY)  {
 			/* First append to a fragless skb builds initial
 			 * pure zerocopy skb
@@ -1357,6 +1359,14 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 				tcp_mark_push(tp, skb);
 				goto new_segment;
 			}
+			/*
+			 * The next user page is not in PISA memory: copy this
+			 * chunk, without reporting SO_EE_CODE_ZEROCOPY_COPIED.
+			 */
+			if (unlikely(err == -EXDEV)) {
+				must_copy = true;
+				continue;
+			}
 			if (err < 0)
 				goto do_error;
 			copy = err;
-- 
2.56.1.809.ga0b61035b5-goog


