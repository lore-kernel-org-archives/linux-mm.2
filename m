Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 717A9CA1013
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 02:40:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99DF16B000C; Sun,  7 Sep 2025 22:40:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94E956B000D; Sun,  7 Sep 2025 22:40:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 864706B000E; Sun,  7 Sep 2025 22:40:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 75FCD6B000C
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 22:40:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D1B3E11B02C
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 02:40:23 +0000 (UTC)
X-FDA: 83864529126.02.1EE3ADB
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf02.hostedemail.com (Postfix) with ESMTP id 06CC880009
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 02:40:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fr5iBAS3;
	spf=pass (imf02.hostedemail.com: domain of liu.yun@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=liu.yun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757299222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=F05Pyb/PPuwSrMwUArE1DpgL89Fb2LA8TTTDyvg9QlU=;
	b=Nl5TjDFX5Wob2z3e3xt/37QzCPkzqjZvsj5ry2XoCEiDREBLxYm61IQRozQbCVRMz41gvF
	BV9rzExbSlLrXVSB9yt1cDks4CotuJtW6UbNdhsT+Si2Ey+sgfIW/Lr9myvafHO8rzlLbJ
	UpIIPbp2EZ8mp2TSoUizQnZ+K8Me0Jc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fr5iBAS3;
	spf=pass (imf02.hostedemail.com: domain of liu.yun@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=liu.yun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757299222; a=rsa-sha256;
	cv=none;
	b=PD6hsoaPc2B0Bu6+jMSEUwzy2kDaRFoPRlegpi6hqocqCMacm8M+/Vcz+N871HO7H3q+r2
	zIJ7alkodSCHyYUnI7eN7XfGl48M8J49btqrv8TmN1blffWWGz4/VzfVkFcDw80R/fyVDQ
	0GLvckqLKRiWFkDDcWOSRMJzYF/W/Lk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757299219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=F05Pyb/PPuwSrMwUArE1DpgL89Fb2LA8TTTDyvg9QlU=;
	b=fr5iBAS3xtbxwNClTulvrLmfA/JJvTJAT3KtveSe2z0hFXo0yVj/1fda3i1QlaIrleXhtc
	GvHsxEiPkHMJL4jWlf6qJIn16bJzkjbF99An9Fae6Y7VFq3By5N1+KRgGRVcNxfCiM5t19
	CEZLoeOWf8pOwgkXp9az3AYNQqiBg9c=
From: Jackie Liu <liu.yun@linux.dev>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org
Cc: hughd@google.com,
	baolin.wang@linux.alibaba.com,
	liu.yun@linux.dev,
	liuyun01@kylinos.cn
Subject: [PATCH] mm/shmem: remove redundant entry_order variable in shmem_split_large_entry()
Date: Mon,  8 Sep 2025 10:39:14 +0800
Message-ID: <20250908023915.28907-1-liu.yun@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: x478nrrhasbngqbbxwgq4ki7iasg8m4u
X-Rspam-User: 
X-Rspamd-Queue-Id: 06CC880009
X-Rspamd-Server: rspam01
X-HE-Tag: 1757299221-314863
X-HE-Meta: U2FsdGVkX19qdWBBTDb/j1TRcQqiju+PP/LTPx7lEEhx7u4hrx8V1S4V320N8IZHEfn5KjEKCbNS/TxdUp+FLk2Lz2PaS/XqxEh9QFuGmcsvduVb2Ab4aDTiizDYAwxrYXZO6VhmXyxNGogd0kR0ba0Gvh67HT/GGiRukPe7SfYSLqMzHRybRMi4j3JNBmWVbqA/S3TGHd/79VgHu5FuLL4Quoo3xqThDOtd0s7DAVRrno+IdjiamUnqQw/fSdDGqWUa4wEYJPUCQhrcYRU7QtYpGt1/NdtULBGAGKZqm0poPdrL0eiSZWlGyA71h2VQs8ITS/LHXvKV/aEqDo5p2LCJnT1sKZpNiAGSo5qDNznKHW3ugAzHiGq6InwnhidVHELxS5NbODwWMWH35+kTHC++8203Iul3mwnXoFKtmhl9QmhEifl8YR8wsrcT68xjmkDKCPUJE3flIH/rVKB8uLYiS2YmAjNfWbVWTKt0M2zgrfm8UcjAj7kZZiqBm49vMQitxLtgCBIRA/FU17wMR+yJKjeYV7nG1IVVc02p24akRuYBZbTAH9MqXbYmWAz6neWwPJgjcjhV0vJOHfedFcuLCcTqJdiWvCPWd1TB662v7bbd7IPvg8asRcHw+qmQuTjQnQ2kerxwebcAjQKYQiuYp7ENs9KE6t/r5BA28VT7C/Fvh+Zt7VdFOFMmRzFc80l3abqfmhBNL1fYfU6d1rNz64UomTVhE4pyFQE/fVvW4DIVPg9uxN+6jU/g4FLKQ4TYXLjzGkddo9hP0Yiu+9AE9c8bKAZNbCqSg0FFy9nHRRF9n9of9kFoATO+//UK8UEfpoOUqZ5LiYDNUzug+ZzvefIIvS0AxbNDNLuAhRfvjirfs1eLGSNgdlTu/ekgmzOMpQJbTNloTC3YI23sCQYUwuxJ2J1HK9Ed+rRp8K9K2KC/EMeCXlO8rQAjSC4h7E9BM7CAtDjouoA9x7V
 58UR4k1m
 wLhonp2xKalSTtywR7MVoLiJVSj+5ha31y2YQSEqyU4HN0UMbqCKjX8JvOZzRV1zKmKT5e9zppVunpusYuC2Y7TuPiI7U5es3muxvWKxWlziH2OCWX6cT72hkT1MIY2rzFAWY7nRQ7k6BUbN9TxiGIF0zkPlm46WZ4B+F7f6BguE62IQaJG0oHLrkbsUaTcTUp4oI8lkQX3DhuwxtdMiHuYLFlnSrrrFGT5C6Pw27/r1/pBQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jackie Liu <liuyun01@kylinos.cn>

Commit d53c78fffe7a ("mm/shmem: use xas_try_split() in shmem_split_large_entry()")
reworked shmem_split_large_entry() to use xas_try_split() and simplified
the splitting logic. After that change, the local variable `entry_order`
became redundant since its value was always immediately copied to `cur_order`.
Remove `entry_order` and use `cur_order` directly to simplify the code.

No functional change intended.

Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
---
 mm/shmem.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index e2c76a30802b..53d28ea6e52b 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2235,7 +2235,7 @@ static int shmem_split_large_entry(struct inode *inode, pgoff_t index,
 {
 	struct address_space *mapping = inode->i_mapping;
 	XA_STATE_ORDER(xas, &mapping->i_pages, index, 0);
-	int split_order = 0, entry_order;
+	int split_order = 0;
 	int i;
 
 	/* Convert user data gfp flags to xarray node gfp flags */
@@ -2253,15 +2253,12 @@ static int shmem_split_large_entry(struct inode *inode, pgoff_t index,
 			goto unlock;
 		}
 
-		entry_order = xas_get_order(&xas);
-
-		if (!entry_order)
+		cur_order = xas_get_order(&xas);
+		if (!cur_order)
 			goto unlock;
 
 		/* Try to split large swap entry in pagecache */
-		cur_order = entry_order;
-		swap_index = round_down(index, 1 << entry_order);
-
+		swap_index = round_down(index, 1 << cur_order);
 		split_order = xas_try_split_min_order(cur_order);
 
 		while (cur_order > 0) {
-- 
2.51.0


