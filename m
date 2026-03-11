Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17685FD88DF
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 03:02:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51AD46B0092; Tue, 10 Mar 2026 23:02:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F8976B0093; Tue, 10 Mar 2026 23:02:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DE2B6B0095; Tue, 10 Mar 2026 23:02:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1A7206B0092
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 23:02:55 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BD6A18B91E
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 03:02:54 +0000 (UTC)
X-FDA: 84532285068.08.0F3753B
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf13.hostedemail.com (Postfix) with ESMTP id EE1B720008
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 03:02:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=SuEB6uUm;
	spf=pass (imf13.hostedemail.com: domain of haifeng.xu@shopee.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=haifeng.xu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773198173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+OzUwreO0Fx04kzL8hUKy9/smwpH8GzkcqgpiyONa3A=;
	b=NaiKjLZ0mYSLFq0zjxn20rgSkm4YgVEWNfAyqroCeaoknjs4zmM/AkDNzirE3KGbGeYsyT
	tKjyen9BVXqyatXDUxj+T9NLXi1UEiKoUBu2faSjcTWK+a/SYGd6JQOewJ31kIqLSPp48G
	q/0vdhjAJZLl3Ybd6b7Gepl/9RNGozE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773198173; a=rsa-sha256;
	cv=none;
	b=5BLWZqpPQn4ulnepl3wRMvS8pzl0o7R6qznCMNXOGaSc8azvuKND0zygZ2dEIB/M7bpkOy
	AaoEqrLysGo5ceG3ROBl0+8UddipZfAxgCEAuvil5HnjXzc9m/KQ6o16r4vx4mjXwjk03D
	UI7o3+d57Rt4ZaSB6RDEJvEsHvYkipo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=SuEB6uUm;
	spf=pass (imf13.hostedemail.com: domain of haifeng.xu@shopee.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=haifeng.xu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ae50a33ff8so72229595ad.3
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1773198172; x=1773802972; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+OzUwreO0Fx04kzL8hUKy9/smwpH8GzkcqgpiyONa3A=;
        b=SuEB6uUmLbibaAS+8puTf1RZv5cEvFhhxbOO9vClZii0LyHotd1eEp6s+MORHM+TPg
         oYqQPe9qp2qGmmiF/p6EU0nDvX+o7xfgcMWSQcAtbiyFPepqk334Dek/QApzctbJg3UM
         hjqhSZEHpzGJXvbvPQOPWzQq9ycyhahBluXojzSmntC7l1tlNElfhPhJZfv/O09zoPnQ
         +khYXRqindIPfYqfPyVrpJKMlr2cMI1RE+QcuDNLpUFQa5iiD6SBapy7ghsxWTX0a+MC
         TzGgcvI55RU/2PB9y87f/dXVjmMLs+t30UYaVwELGW373391Kd2hbSsxHNFvsbEv0WpK
         P7nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773198172; x=1773802972;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+OzUwreO0Fx04kzL8hUKy9/smwpH8GzkcqgpiyONa3A=;
        b=t7C+wHsAMyXfJvbeKEsTsgZjhfr514yQDaqzjkoNgtG1Kw/ZEJT8tLGGxQbNXdPdXn
         y7HtZT65Z5bWob+WFXMgOwc6o6m1mO6jDeOPaO0rb6+t267zWGlGOA3a4gh/57M47xQX
         uzrKCvc05bs43GA+I6PCJHR28p2Zh8dm3gQL9r7PFnmQWpE24lyxaNXzKzWkpFlxA/Xy
         xJPXv2isbeQcIz+HElTxgpRrE+rq5q/TvkPuWsBFEkDUBRSlaPaGX/JK/znIPi6nBz4C
         QJRlfJfvAtZpK8PP+nj6sgnfqX/5qMyXFXONLcKzse8el+UfmSNAq245hau948CzXEh+
         NXDA==
X-Forwarded-Encrypted: i=1; AJvYcCUw/IQ1SLhT0x5kfMOyplOpjJ3oGr0RGyZIMelIG7b51loBk1www7RI90ZL2XJ2OnuJcwDwhuMnFQ==@kvack.org
X-Gm-Message-State: AOJu0YyVcLC8NmEDVioOpdGqRiVDJ0YNpq55EPWqaXaJK8KYjsus6AVx
	8gAZQDSCxghICEsZzuTA+CVq+cmVK8bdVFaK+Nqf4M7bbIw08/8as4YouMS15vumHrc=
X-Gm-Gg: ATEYQzz4iZkpXCrPGXWioWSfo+Mjavk3VD2SCqELlAXvmAl6gdov7tBba7dYvSGBsqh
	PqYoZQqUGP+QhQoeQfaXOiVkcyR7fca7bhtCqr09PPnw42ptPcI+uQcRtBRUOh3rTLFgVMSxDfe
	Bym3BPMO+qGFmw6g1BLHbdzeaw3erRNyg8eDBpVYrfDowXus/tCpvmgUCsG33wSKKK2wrx0Mnpw
	AePGlRhiAQUWjHb7A8OiuI8oov6oSS63WVM/eZGrea5gvFson/H3/Y9g3MwqH7KGHiqO9yLVPbr
	5P4v/nNPJnOxrSAbmphKnbWBOPaF60SadNlZQ1FjTisDnQNHmvW8pu8yDCiIQR6VyCTLoaawUXw
	y7mLMVkcho4wLz21pZR31ibwBZsd1K8rpBWet7MUsx5dAq2KkrDaNS6rm5J9+IW9IHC2RofqWQ4
	xwfT3LpVM/sDZCfZBZoy5mR6YS8ak6bgjpuudv6Q==
X-Received: by 2002:a17:903:3c2d:b0:2ae:46b9:c653 with SMTP id d9443c01a7336-2aeae8945b1mr11721805ad.33.1773198171778;
        Tue, 10 Mar 2026 20:02:51 -0700 (PDT)
Received: from localhost.localdomain ([147.136.157.1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aeae378974sm6251555ad.82.2026.03.10.20.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 20:02:51 -0700 (PDT)
From: Haifeng Xu <haifeng.xu@shopee.com>
To: akpm@linux-foundation.org,
	david@fromorbit.com,
	roman.gushchin@linux.dev,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	shakeel.butt@linux.dev
Cc: zhengqi.arch@bytedance.com,
	muchun.song@linux.dev,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Haifeng Xu <haifeng.xu@shopee.com>
Subject: [PATCH V3 2/4] mm: shrinker: move shrinker_id() code block below memcg_kmem_online()
Date: Wed, 11 Mar 2026 11:02:33 +0800
Message-ID: <20260311030235.240953-3-haifeng.xu@shopee.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260311030235.240953-1-haifeng.xu@shopee.com>
References: <20260311030235.240953-1-haifeng.xu@shopee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: b9mmh77wptpqnty6wsjrgp3cgjribuy8
X-Rspam-User: 
X-Rspamd-Queue-Id: EE1B720008
X-Rspamd-Server: rspam12
X-HE-Tag: 1773198172-894674
X-HE-Meta: U2FsdGVkX1/tU7XDF8vbfqYMQcUKn2SM9BSvcY3MlP8sLu4IGFZqYljNELKnHN4JlzlKoNihX8WnxfWzV52Lhk3PD6R7JdrV30SPChIvkm+6pOMTO4Dkd/upmgw30FNkiCHGgjv13si/GTHCCg2Sh3qVAO0h7qYyHuGN4Nlbv4++id26fcZOPDRf2er7W3TMUcJCJ8DSkvpmUxCYE7D3R0BMiHyprko4Ek2WCkJ9OS9jjBjNl/gkwTk+ONDF01/Jx7nTVmvPxH7I4hifyzoqzLgHkkv8JVLvQ3+gfcL0YoZ8nWi0MZLbynWAnsOF4KFlmGyEG8gOqWqrqiQ2sakfEYSWqxubDge+yqEXHGQPOEN5RRKKWMyy39xGr0DuPT5Y32WI8hKa0QnI8LMSDT06o0Hl0AaFtB2EFWmkRNq4iBInVY1pK3DIlEoYf032l4FjslJPN50R3fL3FYP9BPjgfk2mNBT0LtHutzUZWl+CczdG3NNv8Q7dYewcBqPLYlZsLGPt7SnDiNkQB81qsApe9OZ64d/blI83vLFjxivdqwF/KHk9r8tfZw6mkR8wrNS6PsNnL2IQJ9WJjewQNlcKg5pfaLw+WXlEBPgdU/6yAuRzFA9Q0FH2yIln2yUQr7thNnUu4D37WLa95WjCMvI2R36BxPWzMhlVQUOIqKSrdhlHkY6wKU0HL4IhW8CjRhFiMkPOPfW9SnALuPtBdR5rXGieOCRKfNG0PutHAxwrubyJQAiBV0HUSGAUem0VLg5YcI6OmgjYll0HmPWtLhOvzytW/XS61uIj0kSnBIt74+9ZQ+5MFDI5xJPt7QXWR1PmI7vaf3fdVckuRZ3M/D6OwajtVWXjvgr7EhC0+kxKv1V5KlgFphp7AdZgB5jlVidEj7xA+5+jZLmSLlcR73fSKsVoxBs5T2v+2+PIkTLZF1KmS5aZm80s8Nsxdsy4K8jCb9Npkx4B11x6QdXkmUD
 8m9LlrqG
 T3PhFmBbIBonBxaDeGPalySK2m29vsQwgnP2yB2vAhCYNKXpODYvA7GAxJM+3lYRh+JeMNl88P/O2M1WlwtgveJm21Lx5baoKpf3hk0Rej6fpWAB8zZYaGKcszj8bPBr1IJ63mqVOtGlaDjX9zYSW8tN0xhx3DP1SWmGbgpjqdP0kWlowoOMth35fcQV0jrKY1fnnapZSV1W6MhXfDm7w8iiOALuk6hIwR/x1rkU19BtYpQpu6yoNVr0oEh8TbSN1PFZnzz9du9nH1W2eSTXFM98JEAG8HSHFg3PY1pFRxVdrf0KrW1zxLetdlZj1O6muIcsAN6n7DRxnOrIe8OdnEx9IFxHBrgWE8kya5ZQZpw2D3S/wgN4TXb6NSGujfL/UvKbBDN2R5NFYA35ZmT+Q8aHaSyYYOV9RsLRY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The following patch will use memcg_kmem_online() to decide the id
of shrinker, so move the code block down to reduce the diff noise
in the following patch.

No functional change here.

Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
---
 include/linux/memcontrol.h | 188 ++++++++++++++++++-------------------
 1 file changed, 94 insertions(+), 94 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index a583dbc0adcc..ce7b5101bc02 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1582,100 +1582,6 @@ static inline void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
 
 #endif	/* CONFIG_CGROUP_WRITEBACK */
 
-struct sock;
-#ifdef CONFIG_MEMCG
-extern struct static_key_false memcg_sockets_enabled_key;
-#define mem_cgroup_sockets_enabled static_branch_unlikely(&memcg_sockets_enabled_key)
-
-void mem_cgroup_sk_alloc(struct sock *sk);
-void mem_cgroup_sk_free(struct sock *sk);
-void mem_cgroup_sk_inherit(const struct sock *sk, struct sock *newsk);
-bool mem_cgroup_sk_charge(const struct sock *sk, unsigned int nr_pages,
-			  gfp_t gfp_mask);
-void mem_cgroup_sk_uncharge(const struct sock *sk, unsigned int nr_pages);
-
-#if BITS_PER_LONG < 64
-static inline void mem_cgroup_set_socket_pressure(struct mem_cgroup *memcg)
-{
-	u64 val = get_jiffies_64() + HZ;
-	unsigned long flags;
-
-	write_seqlock_irqsave(&memcg->socket_pressure_seqlock, flags);
-	memcg->socket_pressure = val;
-	write_sequnlock_irqrestore(&memcg->socket_pressure_seqlock, flags);
-}
-
-static inline u64 mem_cgroup_get_socket_pressure(struct mem_cgroup *memcg)
-{
-	unsigned int seq;
-	u64 val;
-
-	do {
-		seq = read_seqbegin(&memcg->socket_pressure_seqlock);
-		val = memcg->socket_pressure;
-	} while (read_seqretry(&memcg->socket_pressure_seqlock, seq));
-
-	return val;
-}
-#else
-static inline void mem_cgroup_set_socket_pressure(struct mem_cgroup *memcg)
-{
-	WRITE_ONCE(memcg->socket_pressure, jiffies + HZ);
-}
-
-static inline u64 mem_cgroup_get_socket_pressure(struct mem_cgroup *memcg)
-{
-	return READ_ONCE(memcg->socket_pressure);
-}
-#endif
-
-int alloc_shrinker_info(struct mem_cgroup *memcg);
-void free_shrinker_info(struct mem_cgroup *memcg);
-void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id);
-void reparent_shrinker_deferred(struct mem_cgroup *memcg);
-
-static inline int shrinker_id(struct mem_cgroup *memcg, struct shrinker *shrinker)
-{
-	return shrinker->id;
-}
-#else
-#define mem_cgroup_sockets_enabled 0
-
-static inline void mem_cgroup_sk_alloc(struct sock *sk)
-{
-}
-
-static inline void mem_cgroup_sk_free(struct sock *sk)
-{
-}
-
-static inline void mem_cgroup_sk_inherit(const struct sock *sk, struct sock *newsk)
-{
-}
-
-static inline bool mem_cgroup_sk_charge(const struct sock *sk,
-					unsigned int nr_pages,
-					gfp_t gfp_mask)
-{
-	return false;
-}
-
-static inline void mem_cgroup_sk_uncharge(const struct sock *sk,
-					  unsigned int nr_pages)
-{
-}
-
-static inline void set_shrinker_bit(struct mem_cgroup *memcg,
-				    int nid, int shrinker_id)
-{
-}
-
-static inline int shrinker_id(struct mem_cgroup *memcg, struct shrinker *shrinker)
-{
-	return -1;
-}
-#endif
-
 #ifdef CONFIG_MEMCG
 bool mem_cgroup_kmem_disabled(void);
 int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order);
@@ -1844,6 +1750,100 @@ static inline bool memcg_is_dying(struct mem_cgroup *memcg)
 }
 #endif /* CONFIG_MEMCG */
 
+struct sock;
+#ifdef CONFIG_MEMCG
+extern struct static_key_false memcg_sockets_enabled_key;
+#define mem_cgroup_sockets_enabled static_branch_unlikely(&memcg_sockets_enabled_key)
+
+void mem_cgroup_sk_alloc(struct sock *sk);
+void mem_cgroup_sk_free(struct sock *sk);
+void mem_cgroup_sk_inherit(const struct sock *sk, struct sock *newsk);
+bool mem_cgroup_sk_charge(const struct sock *sk, unsigned int nr_pages,
+			  gfp_t gfp_mask);
+void mem_cgroup_sk_uncharge(const struct sock *sk, unsigned int nr_pages);
+
+#if BITS_PER_LONG < 64
+static inline void mem_cgroup_set_socket_pressure(struct mem_cgroup *memcg)
+{
+	u64 val = get_jiffies_64() + HZ;
+	unsigned long flags;
+
+	write_seqlock_irqsave(&memcg->socket_pressure_seqlock, flags);
+	memcg->socket_pressure = val;
+	write_sequnlock_irqrestore(&memcg->socket_pressure_seqlock, flags);
+}
+
+static inline u64 mem_cgroup_get_socket_pressure(struct mem_cgroup *memcg)
+{
+	unsigned int seq;
+	u64 val;
+
+	do {
+		seq = read_seqbegin(&memcg->socket_pressure_seqlock);
+		val = memcg->socket_pressure;
+	} while (read_seqretry(&memcg->socket_pressure_seqlock, seq));
+
+	return val;
+}
+#else
+static inline void mem_cgroup_set_socket_pressure(struct mem_cgroup *memcg)
+{
+	WRITE_ONCE(memcg->socket_pressure, jiffies + HZ);
+}
+
+static inline u64 mem_cgroup_get_socket_pressure(struct mem_cgroup *memcg)
+{
+	return READ_ONCE(memcg->socket_pressure);
+}
+#endif
+
+int alloc_shrinker_info(struct mem_cgroup *memcg);
+void free_shrinker_info(struct mem_cgroup *memcg);
+void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id);
+void reparent_shrinker_deferred(struct mem_cgroup *memcg);
+
+static inline int shrinker_id(struct mem_cgroup *memcg, struct shrinker *shrinker)
+{
+	return shrinker->id;
+}
+#else
+#define mem_cgroup_sockets_enabled 0
+
+static inline void mem_cgroup_sk_alloc(struct sock *sk)
+{
+}
+
+static inline void mem_cgroup_sk_free(struct sock *sk)
+{
+}
+
+static inline void mem_cgroup_sk_inherit(const struct sock *sk, struct sock *newsk)
+{
+}
+
+static inline bool mem_cgroup_sk_charge(const struct sock *sk,
+					unsigned int nr_pages,
+					gfp_t gfp_mask)
+{
+	return false;
+}
+
+static inline void mem_cgroup_sk_uncharge(const struct sock *sk,
+					  unsigned int nr_pages)
+{
+}
+
+static inline void set_shrinker_bit(struct mem_cgroup *memcg,
+				    int nid, int shrinker_id)
+{
+}
+
+static inline int shrinker_id(struct mem_cgroup *memcg, struct shrinker *shrinker)
+{
+	return -1;
+}
+#endif
+
 #if defined(CONFIG_MEMCG) && defined(CONFIG_ZSWAP)
 bool obj_cgroup_may_zswap(struct obj_cgroup *objcg);
 void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size);
-- 
2.43.0


