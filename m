Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03FF1FCC9AF
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 03:13:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 488D46B0092; Mon,  9 Mar 2026 23:13:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4329B6B0093; Mon,  9 Mar 2026 23:13:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32EB36B0095; Mon,  9 Mar 2026 23:13:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 245156B0092
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 23:13:08 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F25ED1B6EF4
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:13:07 +0000 (UTC)
X-FDA: 84528682014.26.67AF83B
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf20.hostedemail.com (Postfix) with ESMTP id 18D0E1C000A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:13:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=jiSDDlHl;
	spf=pass (imf20.hostedemail.com: domain of haifeng.xu@shopee.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=haifeng.xu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773112386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+OzUwreO0Fx04kzL8hUKy9/smwpH8GzkcqgpiyONa3A=;
	b=Ph5qOhO7Tq92rS077S/cxzviWxZPiusQMLl3A2UbFhRMYGbdclnbt01FTR+kIz7rGMN3+z
	cno7y4rvj83+Rum+a+UYVuamHVjuQEjY1Be2D9cTMJZ1WunZ9G8xJzFWrmXVgRV1EDNjcP
	WfepTib9ubEojHp4AcQnlqHTp+ddtCo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773112386; a=rsa-sha256;
	cv=none;
	b=H3Onb7d00owSpv3/kVAbeSPPRsjqNHmP3XjyewMPM+arxGr/9VRF+Nb/LYogn2LM2DF5b5
	2Dmh4pb9N6WvOuPwC7/GCJK1TuADAdnsJpEFTwh+qahfFr0fmuBTdih86JPyrB79Vd4uaT
	WBNNR1iw4CdtSnLYteCDfPbX2z3cVMM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=jiSDDlHl;
	spf=pass (imf20.hostedemail.com: domain of haifeng.xu@shopee.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=haifeng.xu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3598cab697eso5638425a91.1
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 20:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1773112385; x=1773717185; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+OzUwreO0Fx04kzL8hUKy9/smwpH8GzkcqgpiyONa3A=;
        b=jiSDDlHldr07bcG5wGHXlOEEwm4LK+PBf4H/4ao7m9nE5VgUSqIPDhmeIFn5eCeAKn
         Zi8zt9h87MyD8vO8JqHRVEZbKn6CRPe0RyvDzkH0n1+b9/Qm77E0pKv4hX4KkuEwGmFl
         ElimqaDs4yD0Gjyr9Vc3CJlnuc5o/WHKwKtGOlQ2SDC11sDbR8RuAgYCsXxHuGivx1Eh
         RDTTl6Mg4TiD1JiFbJ3ELpzz1AS/bZzc5Q5fguzz0Xvin5Wph/8E9Ny5Ahoruo/mJZGC
         3W/91qbOyeTQlMNc5Q+DwclchMl3Fu6kLUxEjCY1QSjRuTunfR58W6SXIaCw8E7mQ4uN
         ZpEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773112385; x=1773717185;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+OzUwreO0Fx04kzL8hUKy9/smwpH8GzkcqgpiyONa3A=;
        b=ZQrXWYYljLplLXFEhJQeHSmYi9J6bZNSLv2z/8qUSUbuI8txAZSknwa88qeAZsbSmB
         9IRN4krmlk7i5KzwNIY13NPtfg9Qqkz/CvEeafqnk6/l5RVAsgE803NFjynaI6fXgw6E
         y7IUsCjPeUbGTfJGQ37f9ZAGSCUktba0DGZZ04cG4IJ5AihW2Qa0K6vJik1ZdwnDeI7U
         7TqPwHENl0Yw8AnAAxPsuXdBfUp1avEjQ3UhuhhF1agVLCxN2TGJe1qcE4gFsJL1vb9i
         FgKKvoZwSzHE8PHevWQhQdWZBUAKl9Qvb5iUHKJKWb8+dPKZ2kzeVV+8HbEfRK0w96AC
         +PkA==
X-Forwarded-Encrypted: i=1; AJvYcCXjZJYP6X7S0JCP6Rcpr4uAcrRHvAGucV7eX8PZPX0OjXssB0aSIUiQLQDvPWmpWZts7HqkLoifaA==@kvack.org
X-Gm-Message-State: AOJu0Ywnp1G4Jcqd1PxOCUUEIwiKYneDr1NYzwwBvbmlCUEZEDobHJ+U
	aCzTX/l/xJnrIczwW2oqpv4e1rH+UU4pZpp6XXh0VsvUgqs16QSIZ2ejyXJhoCW910E=
X-Gm-Gg: ATEYQzzGUbA9eLfWsL5aH8eeeuh2GRja1Hv+s60ejJYDa3hnsv4MIenLrCpx0bkh5Nm
	/vbgsoRzpUwJhhGIeDOuicWeXf/0xXkTAtQgNDl91tacMEsXTP25D53U5fk+JFBLyhv/EyG7aUi
	VJ2FYO47TsUH7IbcuTf1o7nUkyoZV6ZrxP9XMZmWmYgkUHKM5hKiy/nf9rxGKVYr7Suvm+0ngOe
	dqpl/rqCN/TAv2lwtw3Vp+cGLItV6lKp+LTlmnCL0i4KehfW5enNIstZFKECsqWTPG7zzJBZn4N
	1b65ZgakD0XduquAtMm3Ev7PL/sYsLzXFisOvj/3O8xCzFyhA+2LCXADBOylpZTudxf9ZEktjwY
	DjuYevoemV50gSkEPE3Q3RXHOoI6MeAoYJNz/loWKeYhxVZOw3Q8+ayWGahtXDjXYU+upAcaFFW
	TFYRnrAlV/qPZsRzA/XiqI7P9j+3vztF8BFPo8ow==
X-Received: by 2002:a17:90b:1b4d:b0:359:8df1:8553 with SMTP id 98e67ed59e1d1-359f0286267mr1489731a91.9.1773112384931;
        Mon, 09 Mar 2026 20:13:04 -0700 (PDT)
Received: from localhost.localdomain ([147.136.157.0])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-359bcc28f0fsm5169284a91.13.2026.03.09.20.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 20:13:03 -0700 (PDT)
From: Haifeng Xu <haifeng.xu@shopee.com>
To: akpm@linux-foundation.org,
	david@fromorbit.com,
	roman.gushchin@linux.dev
Cc: zhengqi.arch@bytedance.com,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Haifeng Xu <haifeng.xu@shopee.com>
Subject: [PATCH V2 2/4] mm: shrinker: move shrinker_id() code block below memcg_kmem_online()
Date: Tue, 10 Mar 2026 11:12:48 +0800
Message-ID: <20260310031250.289851-3-haifeng.xu@shopee.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260310031250.289851-1-haifeng.xu@shopee.com>
References: <20260310031250.289851-1-haifeng.xu@shopee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 18D0E1C000A
X-Stat-Signature: 7hbmnyfoztoz6bcd1u3af1hmrng1g4ak
X-HE-Tag: 1773112385-818042
X-HE-Meta: U2FsdGVkX1/wi42SoPrBrLsdJlj14fToF1qTBKLToeXaXyewsnw78EQTXVKbg3srH5GWsrrprLj3U/RudC2mjDKOhTjdHp4T0YH55++Tv4fBr+1+heknM+U6V3cS95l8M23XDG6OpvDZAnrik4otqvXMcBCIFmfeV7Ckbt6PJptj4txAry1UIuZhagC9xKJownQLlM5UahHTjCKb1nxHfiDJ5HFSFwonvUhytgplByuH2GqeSeG0CKoSCkMN2bjw6PlQ8O9329Ba/dSo6qbT9smfBvVVpcf+vscOwnvPlHvxRaf/Bg+TBbUcGFg1exOiSvYwwkxA7/+OnEBakNZs4IMDTpiiHjmhMx0j3ImwHKUc5F+EsBcGiak7THha6/62YpLCOCBSWIkUm9hxtOo2jXEKjllnGkG2eOeVD13IaXgotXxjHVhFDFG8u8nTwsd6ftX9KN6KESN2bOmtVSIc+d4O2VZ8BwL1EK9UdUXT8mpuaJomnAFLA9RhI+Q4KdtJ/586d3ZPwuH6fK4gY/4CQBWOF6f8bA2A7kWAMcT2qDrw+XT6KouAi4qUT9b82B5rPyLjsPq6zOFx0bmjhp9Shsp+3G6kDvh2/QKMl1KDh/pvmT9I6bymUXb6rrlM1tWCd4vpuPSkhJPL7R1kRYTVX5BSSgtLcq7hSJyg2XxHX4Vrsb2fTKdJ17YfdbxNvtLAz3bbT7oSFNSQl3H83txVs4B+cGpJeIO/BaL3rw8agoQufDKV2suZpZnhKTI5EZ1zDs1+WjMfHXOW+A0RDJCemCTCJ/jna0hNj/6eeUCZGF9HQlDXtIU4NzI8/VKPp+KRTxmM8FwE7+pWKd0gv8x0wMyVcijshLcVxeGiTp+ZlSSPRv2XFC8BjPrdcxrxfrEs6+cwPiB/vffx6yKImxGLnKZ+S4pwLUwLsIvn3kBeSlUgkbfP6JkgpbD/Jn8yA70m8bxAEiDvMyxGy2s8B0x
 Bgg3SYB7
 CI8xLKcOT4dGfn6q3g47B/PJt84akr7rovtuaXiPDXgiocTTzfTeaNaG4dmjB2wmNBbp0SFtywW4VSongyKY12HaibNyzrpV+JmNfA+1VFUzAIYI=
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


