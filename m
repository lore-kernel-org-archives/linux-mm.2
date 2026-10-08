Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42A5BCA6011
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 18:29:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1E0E6B009E; Thu,  8 Oct 2026 14:28:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B81866B009F; Thu,  8 Oct 2026 14:28:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FA516B00A0; Thu,  8 Oct 2026 14:28:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 725196B009E
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 14:28:43 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5F82340491
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 18:28:42 +0000 (UTC)
X-FDA: 85300294884.12.C2A580C
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	by imf23.hostedemail.com (Postfix) with ESMTP id 94757140006
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 18:28:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fQwRiR9K;
	spf=pass (imf23.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791484120;
	b=Ziuxi0U+PVM8TwkNB5Id0cPhtjz/aRIGye+wkxXJHEBXyVtrd8W7ooXaCSLNeYAcOr1PUU
	/y/8aHR/hZV/W2atydnEIW/Sj6AunnA6a30D90pzOiSeJCQcQhyY9v3X6+JrUn2G8DIt1s
	ZJ/v/t2ZHUDtt4aOH+tWPYwysiwVvZw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fQwRiR9K;
	spf=pass (imf23.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791484120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u2OI/ckXOKrTLzy1Cin641QZA3UIenqp9jT2sv5HRIg=;
	b=M9XeZzUscNtTy8QFx/edIyefcBRuTXJq2ihwXnjrEQs4ILfkNasUvBOkmfuDSaUxKs7rrk
	sbiaw7Iy/BZUHWHHOl3d8bS1PHx8KysNfC72FXayyAViRzwSf8pzE9fXhW0sFhEpjTopP9
	zf+lq7BdZ5083rjfiMGEvLtaLjmPkQw=
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-15dd124bbe7so4562641c88.1
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 11:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791484119; x=1792088919; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u2OI/ckXOKrTLzy1Cin641QZA3UIenqp9jT2sv5HRIg=;
        b=fQwRiR9KCzBZAynE0cBfZ5iQhoF1JbtT4wlRH5nnu1rNDuAgWVIaFSjM8KrJG2nVFD
         qqyM5PsTc8tz9vRwC3wsEo23wrZ6Eq4Uv8u/akKkOw3nGUTOytQ+lAAF7B7zJ9Sc5N8O
         XarIY2dJaF00Q+J1Swxs3rVUwLd3/TpM7Y1H7b/t7QclXHQAdLQeMK37Lz9aeT38Ohtn
         2odrR3SuIvCzNfCtLz5kthaQq/JWQHK1Rn5aCJ2nqEyFferWJwuR9/ONfTH2VX6LEnh8
         iBVac4iubo4YD0D1dckE6Z5c/YCXtXq1Jj+BIGkafp5LRfAORgNO2OlegwXeDipQu+hF
         u1kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791484119; x=1792088919;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=u2OI/ckXOKrTLzy1Cin641QZA3UIenqp9jT2sv5HRIg=;
        b=oGh+rEyItFdWeq0FZwacoaT/EHPzjaZ7pA5SfMnRUxYo8ladm1Ugv2UBwsofF69rjJ
         Kl1VOLIqPBowQE9wD0UHVfXOaCjyVawNLd3fjyCSe42PeHU2rAHlIBhvrIgJLbe7e/t0
         C2nXYa88AE+WlvTr74H5sGVESFo3Xjc6jcWw4R8r5cc9DHETwlD+87YZazz9gVSUDb7M
         tnlRysagKnW8VLaEBjGdSqjVJM5+vbvblQDvk19QXeU0rBprSh0u08ZjSUamh0WMdHPw
         +EJ36MOT/s9r2cNcHH5GA4PCTpcquSEjAsbQrv1n1bFqcaXZ1Fva1o35YMjI1k0eHDb2
         AXrQ==
X-Forwarded-Encrypted: i=1; AKwUvByALJxIh2CZRJ+NzCI0NvqDWbM/D9LkituOeEYD3mWwMHpUnORKymezGx6Adff4RIPi3VT3dskrxw==@kvack.org
X-Gm-Message-State: AFuF++lPUxUQMA9grXGgBC0+ZD8/gIFoYY2NebzHVeu90XH3c8lxsXrW
	XTKdeHWPrlvsAoF9s238zEUVB4KL+2pOxgaeO9q5W3jOerBqmAtYubfr
X-Gm-Gg: AYBFou19gCcSVTT8W5tOEWPefYft90UbuhJB5w/d32bm/sS7kPxHSzvfwuYXrOBvbh9
	0LcJp7Mij4q5vMIBj02Vfcvdw+3ZPHUm7XAYWUwbcp1TFlQx32KjjSPhjRcku5kHhZ+tWnnpbJd
	TF7U4LEIeTH/L5z8AwT6OWn+0aUBF8j0ZuYqUbSTueKottKgxWY/jhXLCU0fYCsBzP7gbjPQUzc
	o1MHO3gjU508HNWMqN64Gac6m4d9aROyOd4s2gHIU7QFUfjKIVbvr9DDdkmay53zZTareRtkbZ4
	51Sd9VYmV8zbjBej04+rDeVqY6LklJNx6+SVtZsk1mFJo1QEseMAM68//Ev3m+T4hznQ709fBr1
	FRXzqqDtosL/jxPtPnua75zeHTxek1LsR3/oG+TaqZbCQLNQmt1jw0oYWnQ7iYshDdBqDvLGAD4
	RgxxsP8PbIUdk8lb1Ug4S1xB/mb0ybdq616AlfePncMcRwt5ywx0052qGPLFuqxlLhLTajIXIsL
	fyCn343sR8=
X-Received: by 2002:a05:701b:2910:b0:14a:fe37:cdf0 with SMTP id a92af1059eb24-16209f0e977mr6962414c88.45.1791484118889;
        Thu, 08 Oct 2026 11:28:38 -0700 (PDT)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a2d2db98sm57236c88.10.2026.10.08.11.28.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 11:28:38 -0700 (PDT)
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
Subject: [PATCH v1 8/8] mm: zswap: Batched zswap_compress() for storing large folios in batches.
Date: Thu,  8 Oct 2026 11:28:14 -0700
Message-Id: <20261008182814.27450-9-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 94757140006
X-Stat-Signature: 9fjmdwtozjt4udx37fow73xg4x1b1juq
X-HE-Tag: 1791484120-817435
X-HE-Meta: U2FsdGVkX18C3en46hidCnQWe9Mfbn7Oy6VlwI3z+mIrTMS314QIgu1pNRWCq1ysoeC9kpQjbQLMgXHISl7/ryQ9ZTlMCLPI5EqEJwZwqlews2969ij+cGP2/d3J7V9SrLmDU7oGWkDu76Xp2VlBr1z+FL5caWeQ/EaUEEHbwasR18ryXjdCWK6DMZHXqF9q571EOumtU0WxsWj78gddLpmXtwrNWB47pGRA5pSuOobPlZA8t4AdZqmYMEcYAFOCdqwAffzaiz8kDmUPNEetw9a4+j9AhDxF1wUFvZlenGRlSqpaswIAAG4/YT1E1DFsl+2j3ppIexDqmPx6SwCxz3ShtsoXgIogH2AJFPePdsskXidt19gmkcXSyhJGXf+nf5kDSoY+xIgxu3oCgR2tG98Xd/WA4Cqw9M5IJYm6p1UISbFBRT3G/rwCkJ5PEJOGIPGKw5he3PPVJLEwhLSXexpaLEvq/Whhsu1ifJsvNGEBxtAHFxaVda3cP/v1FD/oO1/x40edQ8CORCqWhzcJLh1a5qR6EVOM1bJtgcrUDENvwO+kM96opiEPigAuba5BkbwG6dBSGH60Zg/26blimdrMXuPfFQH8YgIzF5ODHWGqaI8dUFVY+ZHZL9NGofIquD+ca3pdnrnDyyZ/+/CokoKDP/DTXakcXni84/WoIgr7Nws/ayeVDEHubhxmm/qxJM2f+ls/gTg+mtr0j2pGrD9KCf/7q6v68INujWlR6VZPKmzCNP2OsrbwMvxdEd0TwD6mc+pX2s6+RBGgvsV53tBac8gWaJwX/bVRNIRopKKMZNPyPuQ3BKK19D3lDrtINVvBznAUcUC4RLXsxcBX5qne6e0aOJujGn3Ujw/nJ5n/pm2fUC3Sj2eAD6rntdCDWL3LGDCm5tL2lndZFvuHs3KFU9IppEZ/LebqlYq0zC3G2PsPQPJL0/viiREx6guwJOV0/NqY47wGqei099o
 ddhlt9/1
 oVzIJYqY5FnOGbmqovBtNnkNf9KU3GJu8gTRJMctPmrLFuXEgau5lTdNyDR1hFT9VNEQAocDVjY9oysO3DL6cCTnQdwAnete5gRNlOvoF+ZHC7HmE5yfcyuGBbBtpMkgVSRmt7WUi6RMX/YorxIIX6/r9ddL6VjIQ1nwZ/pLtkxfzmEoLPW+c5QMS35N3eFWcQHU94F/WiWCMwgq1dDhQizoQ1Kd7aQBo5WBjdhssIIbAE3sGQ9XhpELdLvyynQPg351mdgIZIEHiKbleGrOSn1jpfypSLo4fj8L7kK545o33FUu9pwTyOlp+cYP9rWcBXqm0SWD74SPCGOgUQxEYCZ0apqQLIYhzXaZv5AF/FQ0lKRZ19BpWaWtY5d50+2Ka9afW9MHt8L313HocWHDR+cR8FIsJ6C07unhUOBhnRw6QUiNpDJGpe0ld4QMsThsYGAvE2fbMhkU7fxdBWnTcoKn7DaJJPka66QdmNn4n8oKOSs8UqHzaUudrqdrYyGDwn3k02REcvOye5yrg0IAb4vQMydr4o/THi45YaA+JzK9aofGNwWg20pKs3VLykOVI2Bx7C0MPytgZaE5oAy35mfJLm+OkKK7atNytaH3jcX7RLfq15I2l+k5HAPW3296VWW9Gzj2RHYYm41OF0f4v1stNyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A new batching implementation of zswap_compress() is provided for
compressors that do and do not support batching. This eliminates code
duplication and facilitates code maintainability with the introduction
of compress batching.

The vectorized implementation of calling the earlier zswap_compress()
sequentially, one page at a time in zswap_store_pages(), is replaced
with this new version of zswap_compress() that accepts multiple pages to
compress as a batch.

If the compressor does not support batching, each page in the batch is
compressed and stored sequentially.

If the batch is compressed without errors, the compressed buffers for
the batch are stored in zsmalloc. In case of compression errors, the
current behavior based on whether the folio is enabled for zswap
writeback, is preserved.

The batched zswap_compress() incorporates Herbert's suggestion for
SG lists to represent the batch's inputs/outputs to interface with the
crypto API [1].

Performance data: usemem with 60% over-commit:
==============================================
This patch series was tested on a Chromebook with a QEMU "vng" VM
running in Crostini.

Chromebook Diagnostics reports:
  Intel(R) Core(TM) Ultra 5 115U (10 CPUs, 4.200GHz)
  RAM: 16GB

vng setup:
         Memory: 7G
           Swap: 3G
    Pinned CPUs: 4 (E-Cores: 4,5,6,7)

zswap compressor:
  ZSTD

mTHP enabled:
  64kB

vm-scalability/usemem setup:
  cgroup memory.high: 3G
  4 usemem processes, each allocates 1200M anonymous memory, reads the
  Silesia dataset [2] from a pre-fork-allocated buffer into the 1200M,
  writes to each unsigned long in the 1200M, sleeps for 10 sec, then
  exits.

 usemem metrics averaged across 10 iterations*:
 ================================================

 --------------------------------------------------------------------------
                                          Baseline       Patch     Change
                                       mm-unstable      series       with
                                         10-3-2026          v1         v1
 --------------------------------------------------------------------------
 Average Throughput (KB/s)                  11,794      17,810    +51.00%
 Total Throughput (KB/s)                    47,179      71,242    +51.00%
 Average Time to Free Memory (usecs)       490,973     294,920    -39.93%
 Total Time to Free Memory (usecs)       1,963,892   1,179,682    -39.93%
 --------------------------------------------------------------------------
 * vmstats are as reported at the end of the 10th iteration:
 64kB-alloc                                834,567     828,199     -0.76%
 64kB-zswpout                              700,138     743,697      6.22%
 64kB-swpout-fallback                       35,342      17,978    -49.13%
 64kB-swpout                                     0           0
 --------------------------------------------------------------------------

 The speedup with zswap store batching of large folios has a propelling effect
 on other parts of mm, especially, by enabling large folios to be swapped out
 without splitting, as the data shows. This enables other mm components that are
 optimized for large folios, such as munmap(), folio refcounts/mapcounts
 updates, PTE invalidation upon freeing memory, zswap_invalidate(); which
 benefit from xarray offsets/range continuity. As a result, subsequent large
 folio swapouts are more likely to find contiguous swap slots, there are fewer
 large folio splits during reclaim, more mTHP zswpouts and the cycle
 continues. As the data demonstrates, this directly contributes to more memory
 over-commit opportunity.

Architectural considerations for the zswap batching framework:
==============================================================
The zswap batching framework is designed to be hardware-agnostic.
It can be leveraged by any hardware accelerator or software-based
compressor.

Potential future clients of the batching framework:
===================================================
This patch-series demonstrates the performance benefits of compression
batching when used in zswap_store() of large folios. Compression
batching can be used for other use cases such as batching compression in
zram, batch compression of different folios during reclaim, kcompressd,
file systems, etc. Decompression batching can be used to improve
efficiency of zswap writeback (Thanks Nhat for this idea), batching
decompressions in zram, etc.

[1]: https://lore.kernel.org/all/aJ7Fk6RpNc815Ivd@gondor.apana.org.au/T/#m99aea2ce3d284e6c5a3253061d97b08c4752a798
[2]: https://wanos.co/assets/silesia.tar

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 mm/zswap.c | 250 +++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 187 insertions(+), 63 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index ade84ac4076e..68748349c3ae 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -145,6 +145,7 @@ struct crypto_acomp_ctx {
 	struct acomp_req *req;
 	struct crypto_wait wait;
 	u8 **buffers;
+	struct sg_table *sg_table;
 	struct mutex mutex;
 };
 
@@ -308,6 +309,12 @@ static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx, u8 nr_buffers)
 		kfree(acomp_ctx->buffers);
 	}
 	acomp_ctx->buffers = NULL;
+
+	if (acomp_ctx->sg_table) {
+		sg_free_table(acomp_ctx->sg_table);
+		kfree(acomp_ctx->sg_table);
+	}
+	acomp_ctx->sg_table = NULL;
 }
 
 static struct zswap_pool *zswap_pool_create(char *compressor)
@@ -849,6 +856,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
 	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
 	int nid = cpu_to_node(cpu);
+	struct scatterlist *sg;
 	int ret = -ENOMEM;
 	u8 i;
 
@@ -899,6 +907,21 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 			goto fail;
 	}
 
+	acomp_ctx->sg_table = kmalloc(sizeof(*acomp_ctx->sg_table), GFP_KERNEL);
+	if (!acomp_ctx->sg_table)
+		goto fail;
+
+	if (sg_alloc_table(acomp_ctx->sg_table, pool->compr_batch_size,
+			   GFP_KERNEL))
+		goto fail;
+
+	/*
+	 * Statically map the per-CPU destination buffers to the per-CPU
+	 * SG lists; crucial for performance.
+	 */
+	for_each_sg(acomp_ctx->sg_table->sgl, sg, pool->compr_batch_size, i)
+		sg_set_buf(sg, acomp_ctx->buffers[i], PAGE_SIZE);
+
 	crypto_init_wait(&acomp_ctx->wait);
 
 	/*
@@ -923,85 +946,184 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	return ret;
 }
 
-static bool zswap_compress(struct folio *folio, long index,
-			   struct zswap_entry *entry, struct zswap_pool *pool,
-			   bool wb_enabled)
+/*
+ * The inner compress batching and pool storage function.
+ */
+static bool __zswap_compress(struct folio *folio,
+			     long folio_start,
+			     u8 batch_start,
+			     u8 nr_batch_pages,
+			     struct crypto_acomp_ctx *acomp_ctx,
+			     struct zswap_entry *entries[],
+			     struct zswap_pool *pool,
+			     int nid,
+			     bool wb_enabled)
 {
-	struct crypto_acomp_ctx *acomp_ctx;
-	struct scatterlist input, output;
-	int comp_ret = 0, alloc_ret = 0;
-	unsigned int dlen = PAGE_SIZE;
+	gfp_t gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
+	unsigned int slen = nr_batch_pages * PAGE_SIZE;
+	u8 batch_iter, comp_batch_iter;
+	struct scatterlist *sg;
 	unsigned long handle;
-	gfp_t gfp;
+	int err, dlen;
 	u8 *dst;
-	bool mapped = false;
 
-	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
-	mutex_lock(&acomp_ctx->mutex);
+	/*
+	 * @slen indicates the total source length bytes for
+	 * @nr_batch_pages.
+	 *
+	 * The source folio pages in the batch are directly submitted to
+	 * crypto_acomp via acomp_request_set_src_folio().
+	 *
+	 * The pool's compressor batch size is at least @nr_batch_pages,
+	 * hence the acomp_ctx has at least @nr_batch_pages dst @buffers.
+	 */
+	acomp_request_set_src_folio(acomp_ctx->req, folio,
+				    (folio_start + batch_start) * PAGE_SIZE,
+				    slen);
+
+	acomp_ctx->sg_table->sgl->length = slen;
 
-	dst = acomp_ctx->buffers[0];
-	sg_init_table(&input, 1);
-	sg_set_folio(&input, folio, PAGE_SIZE, index * PAGE_SIZE);
+	/*
+	 * The per-CPU @acomp_ctx->sg_table scatterlists are statically
+	 * mapped to the per-CPU dst @buffers at pool creation time.
+	 */
+	acomp_request_set_dst_sg(acomp_ctx->req,
+				 acomp_ctx->sg_table->sgl,
+				 slen);
 
-	sg_init_one(&output, dst, PAGE_SIZE);
-	acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SIZE, dlen);
+	err = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req),
+			      &acomp_ctx->wait);
 
 	/*
-	 * it maybe looks a little bit silly that we send an asynchronous request,
-	 * then wait for its completion synchronously. This makes the process look
-	 * synchronous in fact.
-	 * Theoretically, acomp supports users send multiple acomp requests in one
-	 * acomp instance, then get those requests done simultaneously. but in this
-	 * case, zswap actually does store and load page by page, there is no
-	 * existing method to send the second page before the first page is done
-	 * in one thread doing zswap.
-	 * but in different threads running on different cpu, we have different
-	 * acomp instance, so multiple threads can do (de)compression in parallel.
+	 * If a page cannot be compressed into a size smaller than
+	 * PAGE_SIZE, save the content as is without a compression, to
+	 * keep the LRU order of writebacks.  If writeback is disabled,
+	 * reject the page since it only adds metadata overhead.
+	 * swap_writeout() will put the page back to the active LRU list
+	 * in the case.
+	 *
+	 * It is assumed that any compressor that sets the output length
+	 * to 0 or a value >= PAGE_SIZE will also return a negative
+	 * error status in @err; i.e, will not return a successful
+	 * compression status in @err in this case.
 	 */
-	comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_ctx->wait);
-	dlen = acomp_ctx->req->dlen;
+	if (unlikely(err && !wb_enabled))
+		goto compress_error;
 
 	/*
-	 * If a page cannot be compressed into a size smaller than PAGE_SIZE,
-	 * save the content as is without a compression, to keep the LRU order
-	 * of writebacks.  If writeback is disabled, reject the page since it
-	 * only adds metadata overhead.  swap_writeout() will put the page back
-	 * to the active LRU list in the case.
+	 * For each output SG list in @acomp_ctx->req->sg_table->sgl,
+	 * the @sg->length should be set to either the page's compressed
+	 * length (success), or it's negative value compression error.
 	 */
-	if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
-		if (!wb_enabled) {
-			comp_ret = comp_ret ? comp_ret : -EINVAL;
-			goto unlock;
+	for_each_sg(acomp_ctx->sg_table->sgl, sg, nr_batch_pages,
+		    comp_batch_iter) {
+		batch_iter = batch_start + comp_batch_iter;
+		dst = acomp_ctx->buffers[comp_batch_iter];
+		dlen = sg->length;
+
+		if (unlikely(dlen <= 0 || dlen >= PAGE_SIZE)) {
+			dlen = PAGE_SIZE;
+			dst = kmap_local_folio(folio,
+					(folio_start + batch_iter) * PAGE_SIZE);
 		}
-		comp_ret = 0;
-		dlen = PAGE_SIZE;
-		dst = kmap_local_folio(folio, index * PAGE_SIZE);
-		mapped = true;
+
+		handle = zs_malloc(pool->zs_pool, dlen, gfp, nid);
+
+		if (unlikely(IS_ERR_VALUE(handle))) {
+			if (PTR_ERR((void *)handle) == -ENOSPC)
+				zswap_reject_compress_poor++;
+			else
+				zswap_reject_alloc_fail++;
+
+			if (dst != acomp_ctx->buffers[comp_batch_iter])
+				kunmap_local(dst);
+
+			return false;
+		}
+
+		zs_obj_write(pool->zs_pool, handle, dst, dlen);
+		entries[batch_iter]->handle = handle;
+		entries[batch_iter]->length = dlen;
+		if (dst != acomp_ctx->buffers[comp_batch_iter])
+			kunmap_local(dst);
 	}
 
-	gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
-	handle = zs_malloc(pool->zs_pool, dlen, gfp, folio_nid(folio));
-	if (IS_ERR_VALUE(handle)) {
-		alloc_ret = PTR_ERR((void *)handle);
-		goto unlock;
+	return true;
+
+compress_error:
+	for_each_sg(acomp_ctx->sg_table->sgl, sg, nr_batch_pages,
+		    comp_batch_iter) {
+		if ((int)sg->length < 0) {
+			if ((int)sg->length == -ENOSPC)
+				zswap_reject_compress_poor++;
+			else
+				zswap_reject_compress_fail++;
+		}
 	}
 
-	zs_obj_write(pool->zs_pool, handle, dst, dlen);
-	entry->handle = handle;
-	entry->length = dlen;
+	return false;
+}
 
-unlock:
-	if (mapped)
-		kunmap_local(dst);
-	if (comp_ret == -ENOSPC || alloc_ret == -ENOSPC)
-		zswap_reject_compress_poor++;
-	else if (comp_ret)
-		zswap_reject_compress_fail++;
-	else if (alloc_ret)
-		zswap_reject_alloc_fail++;
+/*
+ * zswap_compress() batching implementation for sequential and batching
+ * compressors.
+ *
+ * Description:
+ * ============
+ * Compress multiple @nr_pages in @folio starting from the @folio_start index
+ * in batches of @nr_batch_pages; the latter representing the lesser of the
+ * @nr_pages to be batch compressed and the compressor's batch size.
+ *
+ * @nr_pages can be in (1, ZSWAP_MAX_BATCH_SIZE] even if the compressor does not
+ * support batching.
+ *
+ * If @nr_batch_pages is 1, each page is processed sequentially.
+ *
+ * If @nr_batch_pages is > 1, the compressor may use batching to optimize
+ * compression.
+ */
+static bool zswap_compress(struct folio *folio,
+			   long folio_start,
+			   u8 nr_pages,
+			   u8 nr_batch_pages,
+			   struct zswap_entry *entries[],
+			   struct zswap_pool *pool,
+			   int nid,
+			   bool wb_enabled)
+{
+	struct crypto_acomp_ctx *acomp_ctx;
+	bool ret = true;
+	u8 batch_start;
+
+	/*
+	 * Locking the acomp_ctx mutex once per store batch results in better
+	 * performance as compared to locking per compress batch.
+	 */
+	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
+	mutex_lock(&acomp_ctx->mutex);
+
+	/*
+	 * Compress the @nr_pages in @folio starting at index @folio_start
+	 * in batches of @nr_batch_pages.
+	 */
+	for (batch_start = 0; batch_start < nr_pages;
+	     batch_start += nr_batch_pages) {
+		/*
+		 * Send @nr_batch_pages to crypto_acomp for compression:
+		 *
+		 * These pages are in @folio's range of indices in the interval
+		 *     [@folio_start + @batch_start,
+		 *      @folio_start + @batch_start + @nr_batch_pages).
+		 */
+		ret = __zswap_compress(folio, folio_start, batch_start,
+				       nr_batch_pages, acomp_ctx, entries,
+				       pool, nid, wb_enabled);
+		if (unlikely(!ret))
+			break;
+	}
 
 	mutex_unlock(&acomp_ctx->mutex);
-	return comp_ret == 0 && alloc_ret == 0;
+	return ret;
 }
 
 static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
@@ -1519,6 +1641,7 @@ static bool zswap_store_pages(struct folio *folio,
 {
 	struct zswap_entry *entries[ZSWAP_MAX_BATCH_SIZE];
 	u8 i, store_fail_idx = 0, nr_pages = end - start;
+	bool ret;
 
 	VM_WARN_ON_ONCE(nr_pages <= 0 || nr_pages > ZSWAP_MAX_BATCH_SIZE);
 
@@ -1545,10 +1668,11 @@ static bool zswap_store_pages(struct folio *folio,
 		INIT_LIST_HEAD(&entries[i]->lru);
 	}
 
-	for (i = 0; i < nr_pages; ++i) {
-		if (!zswap_compress(folio, start + i, entries[i], pool, wb_enabled))
-			goto store_pages_failed;
-	}
+	ret = zswap_compress(folio, start, nr_pages,
+			     min(nr_pages, pool->compr_batch_size),
+			     entries, pool, nid, wb_enabled);
+	if (unlikely(!ret))
+		goto store_pages_failed;
 
 	for (i = 0; i < nr_pages; ++i) {
 		struct zswap_entry *old, *entry = entries[i];
-- 
2.39.5


