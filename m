Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6967EE8FDB1
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 05:52:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D06616B0096; Mon, 29 Dec 2025 00:52:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC6AB6B0098; Mon, 29 Dec 2025 00:52:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1DC16B0099; Mon, 29 Dec 2025 00:52:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD6856B0096
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 00:52:26 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4187DC3CE3
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 05:52:26 +0000 (UTC)
X-FDA: 84271438692.21.E2C4751
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf18.hostedemail.com (Postfix) with ESMTP id 598AD1C0002
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 05:52:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Lbi5TN7L;
	spf=pass (imf18.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766987544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G+YV981o5ya8+p67zEySvWRoO1hxPee1KmoTUwsGb3A=;
	b=aBeIjf4Ctf8M8VaJQbvNGmeyYSGhStnxwqRKqTe3BI+/DZhBloEFiqFZ33Pa9fpjdR70Zf
	dg2HOn3h4qkGpwhnpS3yO6QIAsIUwlxaQBEJ+2J14UjR+DXJG8ZVnZE+9OuPcA8OywifJZ
	1mqe97HDdQeivcGrg/UJnhFowTHWYO8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Lbi5TN7L;
	spf=pass (imf18.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766987544; a=rsa-sha256;
	cv=none;
	b=z9gIfEmwyoQzAFMqVi0KHhbpUjQM342yK8Fyz1wXB/IeT+dvo4leQjbYFlSMZecsUHAv3K
	+/KA91LNo+9qJxSzIqCh/dzbRAhmuyarPyLLDiQqWt/hQJqNyHA+ygxkOBlC4R5DycCvvC
	QFlGst36aHeUR7msHss23NL4xlJ8UoE=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-34ccb7ad166so8137944a91.2
        for <linux-mm@kvack.org>; Sun, 28 Dec 2025 21:52:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766987543; x=1767592343; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G+YV981o5ya8+p67zEySvWRoO1hxPee1KmoTUwsGb3A=;
        b=Lbi5TN7LA+H/vnVcdqpE4sRgPm6/svbz2iOkM0vzkBNGuL8Vmg/eKX+lPR+1BWMsbZ
         6w0hCYJu3rCppOrGFPg/5zUXiG1428f46IvW1XTi6sio9xtomKcGaOnThGpq06c86wxg
         T2+m3fPlZWVgKyFAI6NdcetDxuO0Aa2x8fpsi8cnFnNKytfVHAoYhKG1jzWWyNlpcLSX
         S17xsYJQ8Ya/wwrIUOwpWfAPzhVblx60EUqaSg9F0MbKpW8ScMkhyeoRUjZxRO6r1jx3
         RkJ1N2fdu97qI5ISmKBMJi8SS6U0j3B2rymahC9xNLCrSqdhyV3WLtuZfHnUOm8/55uB
         PCIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766987543; x=1767592343;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=G+YV981o5ya8+p67zEySvWRoO1hxPee1KmoTUwsGb3A=;
        b=TZ9hgT82uzc57T3H9EoWaQIqGt0qgGllhc8/4vP0tdPB0J25Bv/m8gqQ/8TUk5zgTa
         pJjeOEra+DXkgC+U79tIycqDn0aZfn8FaHjAd+ZpV320Eo1PZ4s0qjPLZvSwTH5GaXR7
         DSTzGYj9W8J6LHXNtthvdgY2br0WoRwHT+AygdVpajwIbDCXVJDh9Zr1eT87CbSctoG5
         VEzdn2yxAxwb7JV4anzdKDina1vC8kBgj9LwX209aPCkKHL139YHqPPXfHdZMCO3XpmY
         506mdbA1ENbeoGFtnp8sqxW/ybx779753gocglOFJ2io0HzU96iwob49nwlm5ITE2Utd
         i1mw==
X-Forwarded-Encrypted: i=1; AJvYcCV4haLX6Dj0tCr/gXijPNgc2iq4uvlu1dF2g8nP4gYVzekzNgdMupbmjZOxg4kSplx50PRMMBVBUQ==@kvack.org
X-Gm-Message-State: AOJu0YwSroaaUXyX+1Qbt19VsHacW6TBb1BfQI2IywBt6e5LFvJEWu7I
	eppUk4gbDdZgidfyt+e7W3vTE9913EJEMF3zuatevJhw7gulH0H71Bpj
X-Gm-Gg: AY/fxX6X7QmSGRD4D44h/RlqV+r/qE5u7GBLXaRciJsiBuWZLbZn7og4J5MnjyMKIwC
	cwXq/5ivJZKniPrx7e22tqnbork7I9q194uYPVvqsDpzB/J4ZU0xQSlmFwDHm/URqjzucW7JBAM
	dHR7GZQATzpYbWc7ArNVF49fM/1c/3+99DlqjwOSPdtif+g3UswC8dVHyE+urPQe6F33Bm4KJhA
	5mqZwGDtXSAZITYLgm+ygdQ6Gx6C072FO2qBM7qVytfG/KcOow5eQR3mdFCwZRrEHXr+Fns+6c7
	5+a7kf4pSXDqJw4vqmSVbgTHSYZ4HLrJGI9KRKd54w1Bcy36j4GS/gAhQPyCRw3YvKedAeRHFiN
	VbyYP4z08PdLCzHMhCE7mLQUyNo1Im0trKdzk8HqqhpLpT2X6iBMqptwDRCJWAUC3psRUlSVmFN
	amRi2+v+eFV2KZxYtlb+2JXS3zSiJD
X-Google-Smtp-Source: AGHT+IElx6QVmh8bkNAdqI996CICA7RGsTegEhzBCgArsJpY8uIeyJ+BEZslcnT19OkVzRSeb+gp8g==
X-Received: by 2002:a17:90b:1c12:b0:340:2a3a:71b7 with SMTP id 98e67ed59e1d1-34e9214bebcmr31415353a91.12.1766987543189;
        Sun, 28 Dec 2025 21:52:23 -0800 (PST)
Received: from localhost.localdomain ([121.232.80.251])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e920c9a7csm26164019a91.0.2025.12.28.21.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Dec 2025 21:52:22 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
X-Google-Original-From: Vernon Yang <yanglincheng@kylinos.cn>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	richard.weiyang@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH v2 3/4] mm: khugepaged: set VM_NOHUGEPAGE flag when MADV_COLD/MADV_FREE
Date: Mon, 29 Dec 2025 13:51:50 +0800
Message-ID: <20251229055151.54887-4-yanglincheng@kylinos.cn>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251229055151.54887-1-yanglincheng@kylinos.cn>
References: <20251229055151.54887-1-yanglincheng@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 598AD1C0002
X-Stat-Signature: jjd9ecwgpzex7kmg3pz6iw395zwexsaw
X-Rspam-User: 
X-HE-Tag: 1766987544-154606
X-HE-Meta: U2FsdGVkX1+7bsd3citWwWgsed7sQLQ61pWo2zpmiypghuoDsralv0myjP7Q4sTpo5kNbtRibvbYZSJJ7jCz7DZQkfEd8s4KE9wMtG4Vx//N9/NSjrNI99q0cUJlRMhj3tFbfdb9AY722EEXmMFM6FUDXf8P7op0VVD+PbSMMXQwz+/Vy09e4oGGzoccH2XVjvvCGth4/8C9NnV+QULzJEpl+7OD6kCG/ZgTyWgw+KBAude3BnYg/50NJErMDnNquVgIHPSl3lS1Lj9OZ30PNinKlkxbMhN+soQJqnzeWot5kx9kTwcmtwVeOQbFnDBc8EkWI1pC+ovaAB0x/A3YHG8jy5OS/S1ulFFwiNnauR79u7RHpSFF3ixI20i759yeQry3V2hdF2Pqpgq6xJz9/ld3nF7MCZODQpUsGl+AnvRTO92HNp9IFwV0tti/GiWiDQm6/ywJpKvR3EoNkdWUuNYEy+3eIb3Nc2cgvvFns8hCOsglI3GWBLWKnBRqfyGcWHXfch5d5qGiuM/alkxRTrzpW+LQgwrhNYXQF+GNUFZCfdnqXM3xSnV4ugDytnoU+hsN8nfHDA9CPWvM3u7q26Dvp4bdzgprOxVRpbCUDEjlzeS0CXEyvX7bFpDxIfdYeO/P1DUKaruRRV97J8rgoPYTrYNHHfL+E9LuCLkp2Tjy7Rwm5gZmpXj46vj6rvt54laPwmAM0H0p6RYQDp/yslZxwEZGzi4HTn1XSUvtRtodNVe0Gs7KOTmE4tSmfnTiSi5oKl3HVlgqEmCjZaUE6zbrrYfh5UVqZbr01BwwaHGhm2DtzWyaXBR3dZuFSHak+5tbl8h4l39+zN15aJId7AJSLWuvV9M6i6RFJABVGNU3NAUol4sqdC7qePFKH0vBwFAyrEekUs1z+w2kwItsZUf7iJ1CDbcb3KFJzNg6rGb9d2o6mEGEoZQTAPW7uYLhV3F3Z3Uv2TysVjNZPzk
 Je9k+GpT
 y6WVTnlNv6FiKWW2VYUUCcXG3wUccS4joFJfObOYY5n+RKAcPDqE2WXfZkGCYZnjSs7jkYut+W6Kq0Qzz8NLEBdLdhkSzALZIvHRR08BLG5FlmL0cZUqY9rhnLd0X7yQNeBUx8bGocCU8fYJBxxZUZo2/ryLW1JPyv7hKkFpET5ZEf2Ss6OWQAtpoitExyuqD0UFOstKXtsCYPD+YaUi0NRAiVET1Ro9QiFUnmk0ySlEZT3EHCLZfo9hFLSqw2S3zac683TJNyvd01ZovVwv+x//IrhYq1PjNwXvZrAQZs6yhCLJJe2NXE19yaPlLCMnzvsQIqFnZpEwu/g7qI5s9LCTelxjyfsoTQJPkiRIS0csuc6oh5zPQp8QOKhmlNQ9MeGrZh3t5w52UzsbkocNLB1AX1bZOhwRdfy7LgidEVeq1p2sO3K8UZDLGPiglV3fxYJs0OJPcJ+QHjtL1IM+LXPuLxg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For example, create three task: hot1 -> cold -> hot2. After all three
task are created, each allocate memory 128MB. the hot1/hot2 task
continuously access 128 MB memory, while the cold task only accesses
its memory briefly andthen call madvise(MADV_COLD). However, khugepaged
still prioritizes scanning the cold task and only scans the hot2 task
after completing the scan of the cold task.

So if the user has explicitly informed us via MADV_COLD/FREE that this
memory is cold or will be freed, it is appropriate for khugepaged to
skip it only, thereby avoiding unnecessary scan and collapse operations
to reducing CPU wastage.

Here are the performance test results:
(Throughput bigger is better, other smaller is better)

Testing on x86_64 machine:

| task hot2           | without patch | with patch    |  delta  |
|---------------------|---------------|---------------|---------|
| total accesses time |  3.14 sec     |  2.93 sec     | -6.69%  |
| cycles per access   |  4.96         |  2.21         | -55.44% |
| Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19%  |
| dTLB-load-misses    |  284814532    |  69597236     | -75.56% |

Testing on qemu-system-x86_64 -enable-kvm:

| task hot2           | without patch | with patch    |  delta  |
|---------------------|---------------|---------------|---------|
| total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
| cycles per access   |  7.29         |  2.07         | -71.60% |
| Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.41% |
| dTLB-load-misses    |  241600871    |  3216108      | -98.67% |

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 mm/madvise.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index b617b1be0f53..3a48d725a3fc 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1360,11 +1360,8 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
 		return madvise_remove(madv_behavior);
 	case MADV_WILLNEED:
 		return madvise_willneed(madv_behavior);
-	case MADV_COLD:
-		return madvise_cold(madv_behavior);
 	case MADV_PAGEOUT:
 		return madvise_pageout(madv_behavior);
-	case MADV_FREE:
 	case MADV_DONTNEED:
 	case MADV_DONTNEED_LOCKED:
 		return madvise_dontneed_free(madv_behavior);
@@ -1378,6 +1375,18 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
 
 	/* The below behaviours update VMAs via madvise_update_vma(). */
 
+	case MADV_COLD:
+		error = madvise_cold(madv_behavior);
+		if (error)
+			goto out;
+		new_flags = (new_flags & ~VM_HUGEPAGE) | VM_NOHUGEPAGE;
+		break;
+	case MADV_FREE:
+		error = madvise_dontneed_free(madv_behavior);
+		if (error)
+			goto out;
+		new_flags = (new_flags & ~VM_HUGEPAGE) | VM_NOHUGEPAGE;
+		break;
 	case MADV_NORMAL:
 		new_flags = new_flags & ~VM_RAND_READ & ~VM_SEQ_READ;
 		break;
@@ -1756,7 +1765,6 @@ static enum madvise_lock_mode get_lock_mode(struct madvise_behavior *madv_behavi
 	switch (madv_behavior->behavior) {
 	case MADV_REMOVE:
 	case MADV_WILLNEED:
-	case MADV_COLD:
 	case MADV_PAGEOUT:
 	case MADV_POPULATE_READ:
 	case MADV_POPULATE_WRITE:
@@ -1766,7 +1774,6 @@ static enum madvise_lock_mode get_lock_mode(struct madvise_behavior *madv_behavi
 	case MADV_GUARD_REMOVE:
 	case MADV_DONTNEED:
 	case MADV_DONTNEED_LOCKED:
-	case MADV_FREE:
 		return MADVISE_VMA_READ_LOCK;
 	default:
 		return MADVISE_MMAP_WRITE_LOCK;
-- 
2.51.0


