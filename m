Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53E18C87FCE
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 07:53:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEA608E0002; Mon, 28 Jul 2025 03:53:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9D0B8E0001; Mon, 28 Jul 2025 03:53:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3C918E0002; Mon, 28 Jul 2025 03:53:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B18088E0001
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 03:53:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7BCCAC0120
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 07:53:56 +0000 (UTC)
X-FDA: 83712909672.30.CBA0E4C
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7AFB6140006
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 07:53:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GcaLqqHY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753689234; a=rsa-sha256;
	cv=none;
	b=JRIFpoM9awwcWsnGFO7cTxSAlv6AEk4h0ujufAZx6bCfj3e9yGW/2rJtpeg0QQ8LfNSxeI
	uTOyyuY7J3Yt/sBmRhZGJRVHiYfhlPt0KPsYzyj+57kQx3Remhwhn418iBraLCW0yYcP5G
	5LTfIRda1Ys4lmvriIQwYvEnnl87VLU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GcaLqqHY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753689234;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NRCznFcp7ajBKMuky7QQKQFuElaZNk3oJWmbVbFTaP8=;
	b=d3Wem2CJyqqQlfy3spIL3PHmfX72RxTEzK8cP53O8w3v+MTR0bQQofrf8EKk9+U13YpPmn
	GB0/dEGiddfwN3P/5XklsAenEBamjX7B2bt+SNLLNiay70oif2nqHFp+WyUaEFb8gRnowI
	iHZ/pWD+L4g/6PmnA4alfgRnaA2rvmc=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2363616a1a6so32453465ad.3
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 00:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753689233; x=1754294033; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NRCznFcp7ajBKMuky7QQKQFuElaZNk3oJWmbVbFTaP8=;
        b=GcaLqqHY1DQ4EW4RJp+Vv0/dupVevIlVJ/t+bm/+bK5a3dSW3IdDlrb6q/GVmTmkZa
         t+Mka7/LdHV0r1hmmKIZOLULLp1FrHH2lTYMuK6lBUoMC5h4hz9ih+aXIDCRp4lV20Jr
         puUx/5OylhCpz0kFq9jSwKmc/La4itTcfO7sCug4tPR1EKfjK0hXRq8wAyic1RRp5gUZ
         e6KWbqWqHjkm9lk6bPl8hXCI/fNz70LyeXy2sI7uSFhTmAymqRR0YNHKtgSmUw4x3s/c
         D+vQrx/nHtPhZ7Ka7dUViv3HAEuMVBRIaj2mOY7yke1Im2xsvQIO2Y0m2hQVC6KVeQ0p
         zrCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753689233; x=1754294033;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NRCznFcp7ajBKMuky7QQKQFuElaZNk3oJWmbVbFTaP8=;
        b=xK/kOcRQHrzjwYVIsDY+1Dvrkpk8SUzOgOcKAeaUq7D//MDabB1kWnE7GadsYCd8n5
         T/nIj8We5RCDVQlAFG9akhtXwq4LJiJzI7G1ShGvS5XSYKjDH+ToLMmgl/nJjc5j7lpR
         FUmdrAEsiQJZFViSRUQW4+zkUDnzeU8QamegGAZdXFyrr614iywY4phqC8vA37L9tcgp
         Y37VacbQs98UOhdJ6wwOBZkVkpuIYyBVXX174GITyZNYHPASidTX+nUCtINtGGT8ltaO
         rsRxdLuigHEhfz9jV8a4vJ4cTfPk1qXEtMPX3rg+PBXbmW9SCuZwaKrc9ASyhXS3uwvo
         3hPA==
X-Gm-Message-State: AOJu0YyXrzLg8h/jM/NBHWuzXcoSRnZrwsC5pASkKqB8LJpJn6GKaAwQ
	0odWVK3ULIoyhvOkefd29qEH+Kww1TGvrOq5z1xj+KfCsZdJTl8qVjYLavF0BAF3Gbg=
X-Gm-Gg: ASbGncuHCU290lq9zMbxJI70Fz5Tyly4cq4t5pyfWKGsAbvvTPvtC5mmubAZoAyLMZ7
	jW8vHl/swWnF0E6eN6o9DUfohRlrBRQ3xKAb6/c324oW+8JUy0vnUlw/CUN4QPYrVbl0LOuSs+c
	VmGkQ0xxnF5sOuLiuTd13sP5HpWgbndUNSv3DCjWbl+rv5LIax0ozEX3ukqcvaEYZAnwVHso4BG
	VzpB+5FOt2//zImMnz4V7zdJ6s8Dgmm6Elbt6vbmcExB9qPMBBMPK5HqXpuf8PLbvzImRSnH1G0
	Vkw+aL2AgOpsTJvYMFfBpI151h+LKJzCpKT2Y0rh+qsyglQorW0k/oypw7DRBkgpGGVjTZTExy6
	+mb1KhGSPgXn+/qbkrRQT+xr1i9f70oV5EAwQ
X-Google-Smtp-Source: AGHT+IGiECmYwQYBMKW+4rvl77EBjR2Rh1tffl26z0E8srbfzcXh6dA6NKxkvHgnif+njR7LnfGVPw==
X-Received: by 2002:a17:902:d504:b0:240:3f3d:fd37 with SMTP id d9443c01a7336-2403f3dfffemr12207345ad.27.1753689232485;
        Mon, 28 Jul 2025 00:53:52 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2401866c2a1sm20272305ad.4.2025.07.28.00.53.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 28 Jul 2025 00:53:51 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Matthew Wilcox <willy@infradead.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH v6 5/8] mm/shmem, swap: never use swap cache and readahead for SWP_SYNCHRONOUS_IO
Date: Mon, 28 Jul 2025 15:53:03 +0800
Message-ID: <20250728075306.12704-6-ryncsn@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250728075306.12704-1-ryncsn@gmail.com>
References: <20250728075306.12704-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7AFB6140006
X-Stat-Signature: xdfiiyffupijx6w8ps6ggw1gh8qbir66
X-Rspam-User: 
X-HE-Tag: 1753689234-139705
X-HE-Meta: U2FsdGVkX1/sTKLQzELMRIxghaNQ0yb26r+trTiuWBhgZU0iI/tnlHFVD/Mz3hDi6xiUkWQSapY+MZRf4miDRiuX2KyVlhYNauxMTsPPTEUIOni7EQR41GAFMAbykiUYZ1M4024WLIBHly4+I0DaiHJkUMCciHcZC/WleIqd09hFuSkyOzPiL1x+1HIa4PU6JYo5NU2OMFb+Hj45m92S4N/RFVnoa84ctw45b9n20HwR4y7kUZY0wbB3W7DzIuvMf8zV/Xi7r5LfCiDfklfNVb9YCJmxdFXNba1lWWDI2EAVNH1dlazvBe6FUOdYuSeKe87DCvZFcoPeMirU1QOO8+FvC9QepXfgsEOl5XWvxLgI9AiSEkPZcf1cntaxPsH1Gm/6iw/ngEbroTDCrSkMrLF19kHyO1rAcQ6Lc4TP1RH+Cd9VDWS6Ao44ZzMBKwWtBhwpP1oF7Ka7ZaJf7L8LeecyTdvTyH3Vsbes8LkNoHzoj3jnR6/qLdqLWbBzD62Tq1iO0cxtvCq+PPriNGPCDM4mh41AJWnlp7LJ9ETZ0xkBRMunbckjNc0UIroWbp3qvp8IoDRChfac41pn+z3dkqm14zJw05lZv/0GrPaLaJfIy/nCPkGXjJPOnEqMOMQ1R5zT4eIVN7Ts6TBdJC8IpdGhX0madGd+a4LtkzsDZ5OR8NSTH8sl9HHhiEgRYWCuXYPH1HdwI7dEPY75CWPpMms9cpgIAfQucKcQ84GmDfni27rjZTaNTV1L7E6j44K07uKcbwVrAWXn8uIy9Ntnw/1ULPTw30QWNLPS0udDmBTq7pUgK5AgPALxdQouaxnOJbonIEj++p+FMekB03BwdGM0PVUm77v/NhvXzDTjht9U//mPugY3OuThV6mDmwn1owjEMXp/OJflmnyaJrv915JQnI6/bh198PMXGpuo0x4rFpGprKV1Q2SCyP/iqUL5jInyNscDLhY+0jj7i33
 X8JZm6JM
 l7cJ7hShTtArMtSRgkjtom4WBtpxiWSAWXps9gU+TcEDB4dpqcxioINq6y2cyoIKzg1CYUjoZXP/GjUiOV6LR/JJb8MfBwhBtEm1Ya0Hj2Gd2zVusLbfoReBMNKCaY2hIOJskqGJQUGxKnggMGILxLnhbPf1HjJZp0NP9we1NJyk4MYwFuBpbJiShNYmy3BywSFo4kXyn1ptq6REi9ceDVvvA8C8fp+lycjyt/fBI3qfCc3CrPkdwL+hV7xUg7YgGun0GiWpg56Ah5wZyR2qocZTQxVwBim3iScwLqnSC3TN5qQuPhj0RNfZ5ccFy7kAOhJQzdCtsoBQUHkbZY8DbOAiDLL7n7uM2/wDS0DVVkniPMYnYEFrtzET8pNK/JOHgtBfQCA93gnwL07o/dnq9WNhYMLx0Wb5ArWlXANyZ6av8lsOvcr0FB7jd1CIjBqMGzDUBKNelaSHX71bq/B+VozhPVYfrQKXeJpUDLsWagYAt9rBdTuguyMcVWS6LIJDpXKiKOlpFUjIm8twP4bSv9HEvSrwrVKNPYt1MrYpoVqRdLQaEQYqRGEFfakQkH8g9pmP/wjKxtSMhg9s3S1qelXomIeQ/fJxJe7wJfwt2Rj737iRPlzvBpsZ3gYQsCFGq7hMF72v9s33t6V4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

For SWP_SYNCHRONOUS_IO devices, if a cache bypassing THP swapin failed due
to reasons like memory pressure, partially conflicting swap cache or ZSWAP
enabled, shmem will fallback to cached order 0 swapin.

Right now the swap cache still has a non-trivial overhead, and readahead
is not helpful for SWP_SYNCHRONOUS_IO devices, so we should always skip
the readahead and swap cache even if the swapin falls back to order 0.

So handle the fallback logic without falling back to the cached read.

Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/shmem.c | 41 ++++++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 13 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index e089de25cf6a..6bcca287e173 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2019,6 +2019,7 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	int nr_pages = 1 << order;
 	struct folio *new;
+	gfp_t alloc_gfp;
 	void *shadow;
 
 	/*
@@ -2026,6 +2027,7 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
 	 * limit chance of success with further cpuset and node constraints.
 	 */
 	gfp &= ~GFP_CONSTRAINT_MASK;
+	alloc_gfp = gfp;
 	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 		if (WARN_ON_ONCE(order))
 			return ERR_PTR(-EINVAL);
@@ -2040,19 +2042,22 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
 		if ((vma && unlikely(userfaultfd_armed(vma))) ||
 		     !zswap_never_enabled() ||
 		     non_swapcache_batch(entry, nr_pages) != nr_pages)
-			return ERR_PTR(-EINVAL);
+			goto fallback;
 
-		gfp = limit_gfp_mask(vma_thp_gfp_mask(vma), gfp);
+		alloc_gfp = limit_gfp_mask(vma_thp_gfp_mask(vma), gfp);
+	}
+retry:
+	new = shmem_alloc_folio(alloc_gfp, order, info, index);
+	if (!new) {
+		new = ERR_PTR(-ENOMEM);
+		goto fallback;
 	}
-
-	new = shmem_alloc_folio(gfp, order, info, index);
-	if (!new)
-		return ERR_PTR(-ENOMEM);
 
 	if (mem_cgroup_swapin_charge_folio(new, vma ? vma->vm_mm : NULL,
-					   gfp, entry)) {
+					   alloc_gfp, entry)) {
 		folio_put(new);
-		return ERR_PTR(-ENOMEM);
+		new = ERR_PTR(-ENOMEM);
+		goto fallback;
 	}
 
 	/*
@@ -2067,7 +2072,9 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
 	 */
 	if (swapcache_prepare(entry, nr_pages)) {
 		folio_put(new);
-		return ERR_PTR(-EEXIST);
+		new = ERR_PTR(-EEXIST);
+		/* Try smaller folio to avoid cache conflict */
+		goto fallback;
 	}
 
 	__folio_set_locked(new);
@@ -2081,6 +2088,15 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
 	folio_add_lru(new);
 	swap_read_folio(new, NULL);
 	return new;
+fallback:
+	/* Order 0 swapin failed, nothing to fallback to, abort */
+	if (!order)
+		return new;
+	entry.val += index - round_down(index, nr_pages);
+	alloc_gfp = gfp;
+	nr_pages = 1;
+	order = 0;
+	goto retry;
 }
 
 /*
@@ -2350,13 +2366,12 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 			}
 
 			/*
-			 * Fallback to swapin order-0 folio unless the swap entry
-			 * already exists.
+			 * Direct swapin handled order 0 fallback already,
+			 * if it failed, abort.
 			 */
 			error = PTR_ERR(folio);
 			folio = NULL;
-			if (error == -EEXIST)
-				goto failed;
+			goto failed;
 		}
 
 		/*
-- 
2.50.1


