Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31B07CA6011
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 18:29:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF6BE6B009D; Thu,  8 Oct 2026 14:28:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA88F6B009E; Thu,  8 Oct 2026 14:28:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A96846B009F; Thu,  8 Oct 2026 14:28:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 806266B009D
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 14:28:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 05EBB120532
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 18:28:41 +0000 (UTC)
X-FDA: 85300294842.03.5007A1F
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3EC754000C
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 18:28:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LD3FhP29;
	spf=pass (imf17.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791484119;
	b=XianuZlUbp8j4RmlZK/dvEsfZeHzvDhaLZ1CYSRNeLp9fmXLNEsY53eMLknnTwalZkQ8z6
	BfPkZKjbPkuzpGMtOHOgILdkN3s2uf7EMt7tkTJ/2R/RSCrIZJ+ZajBeWFXE25nfWUV14Z
	SEArV2OfltqszbHFVF9D+Y0MJWzID/c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LD3FhP29;
	spf=pass (imf17.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791484119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rVjA49YbHPrrArJOEmGKyCCKQKJO7CIf1JAShxUw9ic=;
	b=G381jgi0O1tELd4KI99j1bGV4FBb9gDRzvjTK/6y4LO2v+OWe254KWmYuwQ57ZoxLpZyyJ
	6xsPyyLacm9ZUoHU8Fp4MtvtSJf1IINbJdWB8s0xSsiVaMPndYgv8AQgLbyU/bad8GGIsX
	7v2J4kkFYlSfwMhDQwSC1YFKlMcv7z0=
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-3514e7cbbbaso6877679eec.1
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 11:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791484118; x=1792088918; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rVjA49YbHPrrArJOEmGKyCCKQKJO7CIf1JAShxUw9ic=;
        b=LD3FhP296/wNjLwDRGFAce16pofm+LETqGNZY3huIDR3gfV+kaXu7kZHSBX9pPQNEU
         mNVqcZh4dZE5OueaK1iQ4fIUX6rVckpfRjT/huBbT0WvPLOBXgu8pNEnf81vfOMusMU7
         5mpL88735bep485R3D5wEqxc5BCyY6oBnEbUftpfP6HaAg2NNNhcaZNNvbLwshOQHKjo
         P6sMkTIp6U68rhQu09kFMgQrQ6YuLpLmf7gutvEfdXz+HqtORN+AJdWktu8DPVzsmIID
         +Z/StVe57h15lOfXH04YIhBXV48/vS8WAy9klFQWNKCUqDoXqqd/FUX2jXoqFyJ069K5
         9qmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791484118; x=1792088918;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rVjA49YbHPrrArJOEmGKyCCKQKJO7CIf1JAShxUw9ic=;
        b=Hz89iRoi2zv17hj9A+GA8KNgyBAcoPYbZxMNkpJ40j1TuZWx2pU6kIK+nUYB2/G/8i
         xIsLmQaZBq36ZoFb607nxYfsgO9KG7MidFqgOGGdrcu44SjjapkyE7G/qmV9LCTkrbvW
         Xh99xecKfifnm4QlR8ExQ4hu/hDEyQu2JZ3Ml0g0R0P91Y88qrhZi8O7U3+1cy3V72nG
         fK2GHWwo/ChWqH4vc61RxjtwEwdR9w/gHJBtTlDSbXkrtPmQjvWvhHXO9vvd/8Ng6ry4
         +LeQCmoq1mO42A3W6gSt5udkTo6aEb1qe1kuKa+BSdE7+szFxBRcD6uVvIdhDRUWzDZc
         i5gA==
X-Forwarded-Encrypted: i=1; AKwUvBwFxIfy0vm2unCEkQNSY7Zuq2fXjSzIih2ccXzQVfn5i4/sh+leUpjpZLqpSeNcRer+leFewq/XvQ==@kvack.org
X-Gm-Message-State: AFuF++mgcNWucwp8EchRMtXzrUXdNjvX+eyquLsKI1/h4qlb6NSmxEUb
	u0MrxUs2L8lg9Onl4FIqjVfJSBeIaNCtyhrYhAYSHiha8wZK9vXukGej
X-Gm-Gg: AYBFou1TxILd0w3zf9QnoCi9BeXAv8n/6Nl1hx6LEn1R+54/XtG0CNgB94EeHEIJapO
	lTWnnaPgy7fylGIRU41FlXCwgwwB8CGIWRV+TWwRJel855Z9PMcstZMLGnm32/B1XNIO3XVeOi6
	xXC+QlrHs4FruJ8+HrzxdXPVzd+diNMzDikrEhbplA4cbgmX5+mzh5R/lEhyjnUhtnPWi4Honrc
	yVMatp4NZpkbseFgYiDqqg7URK5gpNTLfZ+TsUwKCoajxCv++1ZUh87B8KJyy78Nsad7RggNFtE
	6NyIgAKJbQuWn9bpEvZwbi/mbdmrKmZcH7dFk+qnG48QKxhjd8hfGQ5vanSJJ2fsftXcDQoiqm/
	HeSQNdXlEmO1ojZi62r/1aM/uTpD9sRurHU9ihx08H8mJcX+b0AxKs7FoYvYz+0zCvzD1zfPsaZ
	+XsNUUyIncCPkYiUyuc8AB9Lwd9H/IXHMH15XSBS4JgSsreF7EfjkMyQcTzMOiavPHBvHqnthna
	FYE3fd0jNpoJfCBZsfgTQ==
X-Received: by 2002:a05:701b:2912:b0:144:fb31:a597 with SMTP id a92af1059eb24-16208fb33a6mr7919513c88.47.1791484117710;
        Thu, 08 Oct 2026 11:28:37 -0700 (PDT)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a2d2db98sm57236c88.10.2026.10.08.11.28.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 11:28:37 -0700 (PDT)
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
To: hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	kanchanapsridhar2026@gmail.com,
	linux-kernel@vger.kernel.org
Cc: rientjes@google.com,
	willy@infradead.org,
	senozhatsky@chromium.org
Subject: [PATCH v1 7/8] mm: zswap: Optimally place members of struct zswap_pool, struct zswap_entry.
Date: Thu,  8 Oct 2026 11:28:13 -0700
Message-Id: <20261008182814.27450-8-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ktt33bg33b9mhof59jgeok8zyb8r41j9
X-Rspamd-Queue-Id: 3EC754000C
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791484119-94026
X-HE-Meta: U2FsdGVkX19NVcGgC6dGCgJm8ICD48AhoWI8YM5Hr7p4PCal+TzsNpy6v4yQYwqNiQ+qLAWlThjRcriSSad/qoHGtXW8bs3qth+4PdDEzjHpKl8+nA6OozrT3r3odt5VihVf/4fptDiXePewsQfwT2o+btJ3v9sbCvQO1fpu2Dh8mBUf3caUdE3C8+OSrpPxiRIcb26oszmdYUB1xzBYGVGNPpu8Q0ubdjqgz9EMplfYr1aswgt3sayOuBOvAaQSl+ftyT9QONv0qoq4GFE7hulSgSpIzBe+/lBsoLn2wyv4/tVzDBr1dEoktOcXtHm6xQwLEdHD6KYcmRwlJlsJV3ag3AhYni3668aIJSw8OGQKRJUtnWy2/qqz8j5jtNpEzCLh5uEbTwFdr1w2I8VWmy+MXnqji+VULNeNL3pCQwy00wS/FSsUcnhRYJiV+tfQkYF6IHbl22FMbSGlw+X6HtCoykFnDtm+KoHUTAADdtEgPreTeZ6CGL6ekXhHQJgDxXXWfKB6Zp50Jjk4UseQpwuxmWom6bpiDL8hVnr8wu+9dCNqcfDa6zr2LYE/DgUk82EPfdHHkBEpwNhRhjOi5g3E+3x+j3M587JM/d8uoAayXBPQHB8G+4jC6/eUexe6akIUfMl71Q5dSp544JFgFjzxvEM98LI/m+8wmFOYeks0xJSXFL3i+ycE7NDt/J3PKs8XIFldWVBE761BylfPAAwlyyFXtz9z2ePdmCaZYArD+CEig7uJRJZ+gvmmxFiCGKa9fCleacgcVCVpWSAutidmUIHmUTxmYd0poqAGDI7nh0XAfHI4ZHuzvlNh/R3SAdHlrsQArsrb2UMBUTy9dLDqQ5JCP3hZjMrhVQinfhCN2frPtqigZzMZWRTunx1vDrVHZ4/QwXiOGnTB1V78Bwr4fgUiRITDHZjex7zh2CvwJyviUvQ2sF8WiXudqZTWWUJ0ypAiw3OjESztcoE
 HohUMfLF
 PEdBhQMcQvYva0Bn8jT/7QBMqSK+i/9YlxunNuYTWkEsG/hI1jd6NzXyu84k3dh1zGiuSFDUlRoNxDbnaVXEYy1T2y7HicOzyyImbAhEHEX7UlRIVevfJQDBQs32f2KM75VHggPXIsFHDd0PaKfEqSPM/PLlAhNgSg6UdcXGZuhruyKtWnx1AbsV9Oxmopft1cjdtY8yw//2JKl1dc4UZcLO64BvK1cpM8CJgM6+hEj4MNZsmDlfmiMmnhQQIGFFlh3PHNQI50BbCObfZR5hh05dIVXr1xyviqysuGgUl2hGart9YNZqosk9bCf3K967ZuOgcvr1zuQNuz+n1kd6pqLFWUfAlTSxKgoIa5gZYQ4R+6wZA8VxFYaeSFFYdaWT1mOdd/CGdWxPqfj7fOuHsYPNyV2sp6ITSdnmagwstreZTKSwsZXZAl6RgZNLeKVafahh2R/kaTvBU5rY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Place and align the members of struct zswap_pool and struct zswap_entry
such that members used together in compress/decompress hot paths are
able to share the same cacheline. Minimize holes within these structs
while doing so.

Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 mm/zswap.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 8ae67fd10522..ade84ac4076e 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -160,11 +160,11 @@ struct crypto_acomp_ctx {
 struct zswap_pool {
 	struct zs_pool *zs_pool;
 	struct crypto_acomp_ctx __percpu *acomp_ctx;
-	u8 compr_batch_size;
 	struct percpu_ref ref;
-	struct rcu_work release_rwork;
-	struct hlist_node node;
 	u8 idx;
+	u8 compr_batch_size;
+	struct hlist_node node;
+	struct rcu_work release_rwork;
 	char tfm_name[CRYPTO_MAX_ALG_NAME];
 };
 
@@ -202,10 +202,10 @@ static struct shrinker *zswap_shrinker;
  *              logic if referenced is unset. See comments in the shrinker
  *              section for context.
  * nid - NUMA node id of the page for which this is the zswap entry.
- * pool_idx - id of the zswap_pool that the entry's data is in.
  * handle - zsmalloc allocation handle that stores the compressed page data
  * objcg - the obj_cgroup that the compressed memory is charged to
  * lru - handle to the pool's lru used to evict pages.
+ * pool_idx - id of the zswap_pool that the entry's data is in.
  */
 struct zswap_entry {
 	swp_entry_t swpentry;
@@ -214,10 +214,10 @@ struct zswap_entry {
 		bool referenced:1;
 	};
 	int nid;
-	u8 pool_idx;
 	unsigned long handle;
 	struct obj_cgroup *objcg;
 	struct list_head lru;
+	u8 pool_idx;
 };
 
 /*
-- 
2.39.5


