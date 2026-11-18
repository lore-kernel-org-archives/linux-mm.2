Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9009F606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 13:06:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF7B96B00EF; Wed, 18 Nov 2026 08:06:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A80806B05B0; Wed, 18 Nov 2026 08:06:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 948476B05B1; Wed, 18 Nov 2026 08:06:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 68E466B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:06:14 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0936E1A0746
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:06:14 +0000 (UTC)
X-FDA: 85448263068.28.D330B41
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0C2BA180006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:06:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of yumiao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=yumiao@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795007172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rKaTjTFeBLCTJ4hjz/H9hyLaFlLhjnai2pRctEyKKYk=;
	b=qIJhXLEt1jBDF5oxVgNcSiNJz75eg4BRyqXciCEq5lc/uLLLwXV8q2aGkShZ2aOVlXWs0X
	zXLAt9JjC1pimsodEl9BsgQncqWlMDvk43TBoTo4bj96nSRbTSwRDtWq+9Y5avcntI+99N
	om9zscKh4gw/dTslYtYwmF8FAPgQWmU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of yumiao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=yumiao@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795007172;
	b=M1CAtTbKYrPOGDV/TUnhNWZNx1EhGPz/+piDWeijZU+uAK4DPDe0Z7Cee350l4ucgcntQ4
	C5DAECTiY8imu+lhhkr0Jt5K+4k5P3DyL9LFFfTW8V4si98KLIMgLXZ+8jTQx9GyuP0Oe7
	6Th0vdlixsg909Yeb7jxGSJtEU79e9U=
X-UUID: cb91cdbce35011f19a56ed5b684f684d-20261118
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, SA_UNTRUSTED, SA_LOWREP
	SA_EXISTED, SN_UNTRUSTED, SN_LOWREP, SN_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:eb10f8cb-6cb6-4f11-91a6-58294a490a92,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.19,REQID:eb10f8cb-6cb6-4f11-91a6-58294a490a92,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:7db8b62,CLOUDID:34c319f315fd5a0be9fdc1968f548338,BulkI
	D:26111821060005H9O1QJ,BulkQuantity:0,SF:17|19|38|66|78|81|82|102|127|153|
	865|898,TC:nil,Content:0|15|50|99,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:n
	il,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BR
	E:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: cb91cdbce35011f19a56ed5b684f684d-20261118
X-User: yumiao@kylinos.cn
Received: from kylinos.cn [(39.156.73.11)] by mailgw.kylinos.cn
	(envelope-from <yumiao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 102452584; Wed, 18 Nov 2026 21:05:57 +0800
From: Yu Miao <yumiao@kylinos.cn>
To: cgroups@vger.kernel.org,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	jiayuan.chen@shopee.com,
	nphamcs@gmail.com,
	Yu Miao <yumiao@kylinos.cn>
Subject: [PATCH v2] Docs/admin-guide/cgroup-v2: fix npn tags in memory.stat
Date: Wed, 18 Nov 2026 21:05:37 +0800
Message-ID: <20261118130537.750211-1-yumiao@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117062620.346767-1-yumiao@kylinos.cn>
References: <20261117062620.346767-1-yumiao@kylinos.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0C2BA180006
X-Stat-Signature: u17no3ke7up7ztp69asw99m37i3zombr
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795007167-800760
X-HE-Meta: U2FsdGVkX1/MI2LsuFqwfMTIfVyINLkFYWtdUXUHo60uejSJ+LwMd9nM+VK1By0I0GJak/GK6EGp1ygWQQt7GYcECfB5WgREv5xOIAvQGtVzHChPakTHJJGuWPIfpLweRx3YTqNF8l3IxEqZDCMA0/OC+c4UBxSyzRg4OnJePh7CblwugQrwhXD2L1PSHxRV30KG5SctOMWctwwIJi7IDbK4EaperOfqOAbpWudu8l+MQID4Oj4o3l+bgF/eWWjn73IQSsqZPqtMiJ9u5qSSzyek7lsYLUxVa8ZdHf39umb0lhza5yNEEWkiAUQNiIw0WcB/SSExPKDSSTfeVHhl4cMij6yLf7vLToiomV81B61AxvU8TiKHLaLl605QXeKeGYKEX8EjdGNuEgwe5Oy3Wh6uEWV/wzE3kdJZUIG2KORf/r7XiaHR/sR9Yqzase7rniOtDNlinv5A2ErgIJv3Bmek0mVUKLwinMN5Bl14mA1hvya9paRaSH972YGFwsecV4uwfcXgKGGZKoS+WNFeMOWFG9lTp+YJAS4IXE+d5+qaiOOzx9xqZ7rP4O71Uz2HEJUoyJtCAh9cABE7+Jor6rGgEdDRHbN6NVlwO1cCCP2qf96YFz+ny4FnHqKmATIkPgwI6vDCgpWphe5YhCalyC0jODsWwZ94rWMZLlKoGffy6WlTAWs//Rh62ybmmK6CAsQCF5gTJ/mJCrlTpohf8xX8H9Bd5QxFTPLhY8d18jumrFJyV2mA1he6NVzC3MZG8BcPZbxGnYowEUjNCSuy5/u46BIESD6DcbAT6kY//54RndWQOj1XTpw16i+7TtBtAcPdkKunYeCilpDYim4iyTOhkmMVgDqq6la/8Bm09ATDJgId84KrJSTl6wsc2cm765vma3mk4pBSSpOLI7f5HsaqTxhfdMn/vtLEmO2kTv9PiQhMyq8mOVTAIoSW91uW3hi7Vnx8sO71+cI7MXH
 oSl4rXs7
 dJ44upRHbv5wZYBfodc31M11jexpI1hRMZMZ3N2EvYUhqzd6rY+m2WRg4kCysy+tmRBYO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The zswap, zswapped, zswap_incomp, swpin_zero, swpout_zero, zswpin,
zswpout and zswpwb entries never show up in memory.numa_stat, so add
the 'npn' tag to them.  The pgscan_kswapd, pgscan_direct,
pgscan_khugepaged, pgscan_proactive, pgsteal_kswapd, pgsteal_direct,
pgsteal_khugepaged, pgsteal_proactive and pgrefill entries do show up
in memory.numa_stat since commit e4f4fc7aa8b7 ("mm: move pgscan,
pgsteal, pgrefill to node stats"), so remove their 'npn' tag.
Also move zswap_incomp, currently listed between the zswpwb and
thp_fault_alloc counters, next to the zswap and zswapped entries
it belongs with.

Signed-off-by: Yu Miao <yumiao@kylinos.cn>
---

Changes in v2 (per Tejun's review):
- Add the tag to swpin_zero, swpout_zero, zswpin, zswpout and zswpwb.
- Remove the tag from pgscan_kswapd, pgscan_direct, pgscan_khugepaged,
  pgscan_proactive, pgsteal_kswapd, pgsteal_direct, pgsteal_khugepaged,
  pgsteal_proactive and pgrefill, which have been in memory.numa_stat
  since commit e4f4fc7aa8b7 ("mm: move pgscan, pgsteal, pgrefill to
  node stats").
- Repost via -mm with Andrew Morton and linux-mm@kvack.org cc'ed.

 Documentation/admin-guide/cgroup-v2.rst | 43 +++++++++++++------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 9e3c67b02ae2..a50ce3c833c0 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1608,12 +1608,18 @@ The following nested keys are defined.
 		Amount of cached filesystem data that is swap-backed,
 		such as tmpfs, shm segments, shared anonymous mmap()s
 
-	  zswap
+	  zswap (npn)
 		Amount of memory consumed by the zswap compression backend.
 
-	  zswapped
+	  zswapped (npn)
 		Amount of application memory swapped out to zswap.
 
+	  zswap_incomp (npn)
+		Amount of memory used by incompressible pages currently
+		stored in zswap without compression. These pages could not
+		be compressed to a size smaller than PAGE_SIZE, so they are
+		stored as-is.
+
 	  file_mapped
 		Amount of cached filesystem data mapped with mmap(). Note
 		that some kernel configurations might account complete
@@ -1702,28 +1708,28 @@ The following nested keys are defined.
 	  pgsteal (npn)
 		Amount of reclaimed pages
 
-	  pgscan_kswapd (npn)
+	  pgscan_kswapd
 		Amount of scanned pages by kswapd (in an inactive LRU list)
 
-	  pgscan_direct (npn)
+	  pgscan_direct
 		Amount of scanned pages directly  (in an inactive LRU list)
 
-	  pgscan_khugepaged (npn)
+	  pgscan_khugepaged
 		Amount of scanned pages by khugepaged  (in an inactive LRU list)
 
-	  pgscan_proactive (npn)
+	  pgscan_proactive
 		Amount of scanned pages proactively (in an inactive LRU list)
 
-	  pgsteal_kswapd (npn)
+	  pgsteal_kswapd
 		Amount of reclaimed pages by kswapd
 
-	  pgsteal_direct (npn)
+	  pgsteal_direct
 		Amount of reclaimed pages directly
 
-	  pgsteal_khugepaged (npn)
+	  pgsteal_khugepaged
 		Amount of reclaimed pages by khugepaged
 
-	  pgsteal_proactive (npn)
+	  pgsteal_proactive
 		Amount of reclaimed pages proactively
 
 	  pgfault (npn)
@@ -1732,7 +1738,7 @@ The following nested keys are defined.
 	  pgmajfault (npn)
 		Number of major page faults incurred
 
-	  pgrefill (npn)
+	  pgrefill
 		Amount of scanned pages (in an active LRU list)
 
 	  pgactivate (npn)
@@ -1747,29 +1753,24 @@ The following nested keys are defined.
 	  pglazyfreed (npn)
 		Amount of reclaimed lazyfree pages
 
-	  swpin_zero
+	  swpin_zero (npn)
 		Number of pages swapped into memory and filled with zero, where I/O
 		was optimized out because the page content was detected to be zero
 		during swapout.
 
-	  swpout_zero
+	  swpout_zero (npn)
 		Number of zero-filled pages swapped out with I/O skipped due to the
 		content being detected as zero.
 
-	  zswpin
+	  zswpin (npn)
 		Number of pages moved in to memory from zswap.
 
-	  zswpout
+	  zswpout (npn)
 		Number of pages moved out of memory to zswap.
 
-	  zswpwb
+	  zswpwb (npn)
 		Number of pages written from zswap to swap.
 
-	  zswap_incomp
-		Amount of memory used by incompressible pages currently stored in zswap
-		without compression. These pages could not be compressed to
-		a size smaller than PAGE_SIZE, so they are stored as-is.
-
 	  thp_fault_alloc (npn)
 		Number of transparent hugepages which were allocated to satisfy
 		a page fault. This counter is not present when CONFIG_TRANSPARENT_HUGEPAGE
-- 
2.43.0


