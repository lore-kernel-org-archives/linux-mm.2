Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8FC4606C96E
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 16:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=CuXdWaus
Received: by kanga.kvack.org (Postfix)
	id C557E6B02F0; Mon, 19 Oct 2026 12:28:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDF2A6B02F2; Mon, 19 Oct 2026 12:28:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA7876B02F3; Mon, 19 Oct 2026 12:28:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 839C46B02F0
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:28:07 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 13DE8A07B8
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:28:07 +0000 (UTC)
X-FDA: 85339907814.20.95739A9
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5152B20011
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:28:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CuXdWaus;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.52 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792427285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=MPCaT6OOOqUW7TTHp3t+eRxmMncThW2Jrb7agn7Vd5c=;
	b=s5d1q7vsr7ftIfiCNmq3FmS7lxBR1xLCbbtjHr/Dqmkb+tBz7tk/tyBELU/OtKoPwQ6QwR
	NaQEBiNVHGJ58Nt5wMRoF1MElmk57J//+u9jA9i2vDfSVVZFUiVgZJz9RrX4mRIlAYNS2g
	i4gloC8XWsG9w3S6hOVubld7d/vrCSQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CuXdWaus;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.52 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792427285;
	b=bNi4bk+pPAXH+6CeBUUKfzxvHlPMCCGlizOWRm/R9xCj/PE/1HqY4gYndwKWNEWh3LPBO2
	VjNwcLw51jxbeCRDYXFDxH9nL/A5zlItGSagpUZgrwJcdiqtaviNsboQ0AmI/pCPC67uwK
	mE8pgmbWFgMmGcCjO3f9LFfXL5WDq4Y=
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-6d00d120b28so1818283eaf.1
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792427284; x=1793032084; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=MPCaT6OOOqUW7TTHp3t+eRxmMncThW2Jrb7agn7Vd5c=;
        b=CuXdWausNh1pZUZWtqvMDsoLuGo5Z1cAktr8/Jf6B7xjta6FhHDqJUuGp8Ui8O/b1m
         lX6UGJkdAvsS6az1GVr2GMPd6hE6Po2Rh3HwosKy8fYd/WddaKRiDkog73KJRulMMrUQ
         ss6OXY2Z65X6psQR0SuUTSVoyHZmBm0YdpS/ixdqMAY46wcFqbGYC06byp0igJiXcDEe
         yVvty4s4StrJnK22M1BZxP9rwlERET2E7sp7BaYJQ/vXJ+4Z5d6ilAesyxU6SIEVA7Or
         cyMJsKsVXWs1+PLctdw+57AiS+auWag5gFLy1rHzQ0pdWMcjWGr2KLYsIpnKT4KzOX54
         2nxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792427284; x=1793032084;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MPCaT6OOOqUW7TTHp3t+eRxmMncThW2Jrb7agn7Vd5c=;
        b=fa/TzFWaoJhc/MCuGilBlNfSrtPYDjlPrJsF2TZix3bcjY2ED3wi+xW/kTVcOrr8xd
         Fefs7wAZ2q+q9xmgftL4sd2M4pvnxYMNICmDfbduNPMjhl/e0K/aOwOZtqTzRnp7QVD4
         VCH61MzUaARvSqqJ3Z4r0E1/FQRO9It0GMxKDs+GF92xxegCe04aOzLuh6PCtaXYvqIW
         KcMpE6O5/AaHku8hRIux5DOnW7XcC25Kf9BQS3y0jpp1kI7DZElCF8AIiIH2CrfeNCeq
         ZhHXyuPThbYeXMttob7Wv6WgBG5hqq5NfcfRvXlfEK8j8xYCgazFF1iaFGOqEudV2Eau
         tTbA==
X-Forwarded-Encrypted: i=1; AKwUvBylT5tVoTHPdiSV+6SGDcQCqDeqzAMnZn6rtQlm5TADa8dgU32RmJ4Z2SvxhLcXuFNBXsWZlmHyqw==@kvack.org
X-Gm-Message-State: AFq9FYKNJQf9232IB7gX2J6ifiOb6S9ZG2gI+NObVJGqMnpb8onFhU36
	UN5XVaTz/ifOYOBmIafjAITd6ykKybi3+Nl9sG7THJuVShUNApjpNvzk/u9nzw==
X-Gm-Gg: AYBFou1/HztDFLNXjGjJD79eto2gnMmOBQH2rH1ff03PNe4Bm/19WjCM4DBhQeW+7pS
	XV93kY9lkuf52HMiLPMSS4sThgdQ83wRBXs7D+iRMsqDOTlY/u11XUdIN5IxUUkf1lTjvL0r1cK
	zMru6ronnrFwB5/kUNElhPPa0dxYXdlWgySNbXEpV8UTCU5n7LLlQ4a/BnqNSksX5h7wxZs82eI
	VgmFIL5bJS0MXjMVcjSzGF7U3LXKAEhnTWj77XQeRyznGsUcML5FCv9bIPdyQyblXqoPhupLXNy
	+QLlOCfTJfmaqH45zexaYDpxrT8H5cmJQ1R2FOk8IwIJq8L7FPP7ulaslHvbAyz11W+ua5LwlZw
	5I1JTGYIqFvWRFnNwA10c6Bn/97WFkWgzHVswe3lzVBWKnDRLKOu0SgHD/KXJHQDsjCUzYiu2Oz
	T+ALknDAEsCNVJMq7d5aVtQlmonklimuWZyIZsuq4WbMe9qvdAr5jDNmd17USU+1d4MBIvMy5ks
	z6dMDczwMu51AiEI/L1QXxVNg==
X-Received: by 2002:a05:6820:560b:b0:6c9:80d8:a201 with SMTP id 006d021491bc7-70357496035mr3645829eaf.62.1792427284118;
        Mon, 19 Oct 2026 09:28:04 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-849859184easm2998661a34.23.2026.10.19.09.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 09:28:03 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Harry Yoo <harry@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH] mm/percpu: clean up callers of pcpu_obj_full_size()
Date: Mon, 19 Oct 2026 09:28:02 -0700
Message-ID: <20261019162803.281810-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5152B20011
X-Stat-Signature: jafsfwfyisphprzt3n8tmqtzbb7fzni3
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792427285-69884
X-HE-Meta: U2FsdGVkX19YpS1X+2LPqgKTyI2jfZGluQs3tlXgklnsiZl/3sefeEButuOrFweu644pdjN7VpJO8LtN5fHBTm97fI2YlynVbvoy9EqnxjAk9N+kkH/cx78JSv/tgHIbm80XtNcC+ynd7vN8BAg/wF03J8H5drc9guKqymvYH7mq7dZ070i2LuXYGEmwmPiTqYu8JuqDOdG4SvYSFviUVkgfvjBGHpWnsfJWiTGlQuHelat4KT+h1dM/etiLkZD5ItbQTNSxBuTPjbd+sbHbDnRCkNKvi+MqpLwu1uM1LIzdts+iGVQBLgINox/V9vZMo4mycM7ajYkt7KtFWmb78GcvLOglk0JDl4n58jSKgAEt1TH+KBuLTe3AwE6qGHlEq2J/UjpV2Qdm5PFcg+i+PzXiycwZV10pS/f9+GMGg8Yo0mlTy3CAdsqQ+/7AsAOdNGgPda/CfVxHpLydcPBPotKo3eG5ozOcvVt7t6dPmwniUumfn61CdheaUlWJCaEhYKnNNf6jo3rS+HB1D+Nl5RKSh6axFXL5JVxliVWjViBNEgW5mW/vJeN97x5mRxN9mGgNt5uY/euKrLoh0SnilAlEEwGeunOKrrPSRdQe3e+W+eoFyX9hUmm7+naa4bRX8jWbkemKtuhK0oE2sE6tIb+o5GBcthJx4Ax3oKnW4KgGUkOdQ5bv1b1pzxfUrVZpsJjlox6libzsg4p1jqTxN41ZcZUgka/UK4ErMIh34B7ibBanjktN3vCEVgjZCpSmfeUSHTG2YEaB/CbF8+H5Vr8e8zW0AZH4ur/lXGnKOi6+0i/pRL9M0shAGh0Wh7Cm1CeneAWjQ7spYcAVB3qYA8dZhFeMApBx+PoCADsrMjJian1zICR3105n7urQlqrbSh+d9eRQcO8y2txNYBqlTParnBjPZQ8lPCGv0Z8y0tj3HUVVRKpFjfD1klJtjG1MqlNNvr+7n+XxiMwFPwr
 t8JBg5Ii
 nEQEeLZru9DbBJF/IDFZ8nK15MDpfI22jLrE7c5Aayd31HYalFxK37JwJsOVagI8qeOWO1KQpN+G5Bxf1+GCG7oJvrqg0jHXZAoYULzEZCiFQqdgt9x2Nk1ErGSYEIVeXj/92z6vNM55qPTmUsi84UWvjvwh8aZjXSF6I4pDxSNROtMUoUN04A5HDV22YAp1F/7YKL6MSGtfwkr7EdHXtk/b7FjjTlcpejj/uAsKVKpXFJHdFEwmAevc7icvAweqbEOxPikOeA/P8dMIJsCUaZaxUHjRf9WOgoEtUdHejr6GfYqaHXdONfcx9/l7cIZaUdHYtVbmlImJlpoxXFrQV9ESlgXcATTRIj41mYBo+4uLbahok5HRWlsr9uDVzd5UjSZRVEqkIEi/Tjr4w5px9H9iTRpthO9OCtqGFuTnSBLBZDWhbaRaFe5wuFnJd4LYJJYsSiVbkVmbq9YNfXZc2x7zS9SenuHzfdjYhUX3xzJSDtpKflDxABnYZvJ8fn/qNhZkuqOceFUFV/AKd301V/VZr9vraix6qeAvfnj4opcnR3BQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The size of a pcpu allocation can be interpreted in two ways:
1. The size of the allocation attributable to a single CPU.
2. The total size of the allocation across all CPUs, including the
   allocation overhead (for obj_cgroup membership).

In most accounting paths for percpu memory, we need the second
definition (total size). Make this more obvious by coalescing the
callers of pcpu_obj_full_size().

No functional changes intended.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/percpu.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index d7883507dc151..76848e096caee 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1623,7 +1623,7 @@ static bool pcpu_memcg_pre_alloc_hook(size_t size, gfp_t gfp,
 	if (!objcg || obj_cgroup_is_root(objcg))
 		return true;
 
-	if (obj_cgroup_charge(objcg, gfp, pcpu_obj_full_size(size)))
+	if (obj_cgroup_charge(objcg, gfp, size))
 		return false;
 
 	*objcgp = objcg;
@@ -1642,11 +1642,10 @@ static void pcpu_memcg_post_alloc_hook(struct obj_cgroup *objcg,
 		chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].cgroup = objcg;
 
 		rcu_read_lock();
-		mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
-				pcpu_obj_full_size(size));
+		mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B, size);
 		rcu_read_unlock();
 	} else {
-		obj_cgroup_uncharge(objcg, pcpu_obj_full_size(size));
+		obj_cgroup_uncharge(objcg, size);
 	}
 }
 
@@ -1662,11 +1661,10 @@ static void pcpu_memcg_free_hook(struct pcpu_chunk *chunk, int off, size_t size)
 		return;
 	chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].cgroup = NULL;
 
-	obj_cgroup_uncharge(objcg, pcpu_obj_full_size(size));
+	obj_cgroup_uncharge(objcg, size);
 
 	rcu_read_lock();
-	mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
-			-pcpu_obj_full_size(size));
+	mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B, -size);
 	rcu_read_unlock();
 
 	obj_cgroup_put(objcg);
@@ -1696,15 +1694,14 @@ static void pcpu_alloc_tag_alloc_hook(struct pcpu_chunk *chunk, int off,
 {
 	if (mem_alloc_profiling_enabled() && likely(chunk->obj_exts)) {
 		alloc_tag_add(&chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].tag,
-			      current->alloc_tag, pcpu_obj_full_size(size));
+			      current->alloc_tag, size);
 	}
 }
 
 static void pcpu_alloc_tag_free_hook(struct pcpu_chunk *chunk, int off, size_t size)
 {
 	if (mem_alloc_profiling_enabled() && likely(chunk->obj_exts))
-		alloc_tag_sub(&chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].tag,
-			      pcpu_obj_full_size(size));
+		alloc_tag_sub(&chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].tag, size);
 }
 #else
 static void pcpu_alloc_tag_alloc_hook(struct pcpu_chunk *chunk, int off,
@@ -1744,7 +1741,7 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
 	int slot, off, cpu, ret;
 	unsigned long flags;
 	void __percpu *ptr;
-	size_t bits, bit_align;
+	size_t bits, bit_align, full_size;
 
 	gfp = current_gfp_context(gfp);
 	/*
@@ -1773,6 +1770,7 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
 	size = ALIGN(size, PCPU_MIN_ALLOC_SIZE);
 	bits = size >> PCPU_MIN_ALLOC_SHIFT;
 	bit_align = align >> PCPU_MIN_ALLOC_SHIFT;
+	full_size = pcpu_obj_full_size(size);
 
 	if (unlikely(!size || size > PCPU_MIN_UNIT_SIZE || align > PAGE_SIZE ||
 		     !is_power_of_2(align))) {
@@ -1781,7 +1779,7 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
 		return NULL;
 	}
 
-	if (unlikely(!pcpu_memcg_pre_alloc_hook(size, gfp, &objcg)))
+	if (unlikely(!pcpu_memcg_pre_alloc_hook(full_size, gfp, &objcg)))
 		return NULL;
 
 	if (!is_atomic) {
@@ -1793,7 +1791,7 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
 		if (gfp & __GFP_NOFAIL) {
 			mutex_lock(&pcpu_alloc_mutex);
 		} else if (mutex_lock_killable(&pcpu_alloc_mutex)) {
-			pcpu_memcg_post_alloc_hook(objcg, NULL, 0, size);
+			pcpu_memcg_post_alloc_hook(objcg, NULL, 0, full_size);
 			return NULL;
 		}
 	}
@@ -1903,12 +1901,11 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
 	kmemleak_alloc_percpu(ptr, size, gfp);
 
 	trace_percpu_alloc_percpu(_RET_IP_, reserved, is_atomic, size, align,
-				  chunk->base_addr, off, ptr,
-				  pcpu_obj_full_size(size), gfp);
+				  chunk->base_addr, off, ptr, full_size, gfp);
 
-	pcpu_memcg_post_alloc_hook(objcg, chunk, off, size);
+	pcpu_memcg_post_alloc_hook(objcg, chunk, off, full_size);
 
-	pcpu_alloc_tag_alloc_hook(chunk, off, size);
+	pcpu_alloc_tag_alloc_hook(chunk, off, full_size);
 
 	return ptr;
 
@@ -1938,7 +1935,7 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
 		mutex_unlock(&pcpu_alloc_mutex);
 	}
 
-	pcpu_memcg_post_alloc_hook(objcg, NULL, 0, size);
+	pcpu_memcg_post_alloc_hook(objcg, NULL, 0, full_size);
 
 	return NULL;
 }
@@ -2242,6 +2239,7 @@ void free_percpu(void __percpu *ptr)
 	struct pcpu_chunk *chunk;
 	unsigned long flags;
 	int size, off;
+	size_t full_size;
 	bool need_balance = false;
 
 	if (!ptr)
@@ -2262,10 +2260,11 @@ void free_percpu(void __percpu *ptr)
 		WARN_ON_ONCE(1);
 		return;
 	}
+	full_size = pcpu_obj_full_size(size);
 
-	pcpu_alloc_tag_free_hook(chunk, off, size);
+	pcpu_alloc_tag_free_hook(chunk, off, full_size);
 
-	pcpu_memcg_free_hook(chunk, off, size);
+	pcpu_memcg_free_hook(chunk, off, full_size);
 
 	/*
 	 * If there are more than one fully free chunks, wake up grim reaper.

base-commit: 2887e63d2e8e0cf55402612d8996ce955a2c3e55
-- 
2.53.0-Meta


