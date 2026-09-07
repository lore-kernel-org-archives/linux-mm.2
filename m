Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90CECC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 13:21:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38A426B009B; Mon,  7 Sep 2026 09:21:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33B206B009D; Mon,  7 Sep 2026 09:21:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 204306B009E; Mon,  7 Sep 2026 09:21:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D4C8B6B009B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:21:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 51F6A140180
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:21:41 +0000 (UTC)
X-FDA: 85187028402.27.6A7CB1B
Received: from mail-oa2-f10.google.com (mail-oa2-f10.google.com [74.125.231.74])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8333E18000C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:21:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VqyOgBnF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of jinmengzhou22@gmail.com designates 74.125.231.74 as permitted sender) smtp.mailfrom=jinmengzhou22@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788787299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QSUCkb2IsxXPufzfD2+/6w1ZlHPJoyK0t/kGTCdaAqA=;
	b=iixMgZSIrE8HTBPCn6gDOD+WYppSUfdBXMBeFZKLAn3kyO6D2Tq4Xvr+gefn21uYbBNm2V
	27HCXWSb41qtvOUtNIT/FmK1N/ZL6qZmaCaXRYxxiJaAyWf6j9Y/5tBtP4ivI1GP7JhFp3
	ozwTtagiV6KUUqtvWpP/FryUA8kyTIk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VqyOgBnF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of jinmengzhou22@gmail.com designates 74.125.231.74 as permitted sender) smtp.mailfrom=jinmengzhou22@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788787299;
	b=HhoXHHfMrUMpm64h4QncVQpaHLZo/YdvmPBryhHuhQeH28cvbixbxzpqjWquZ+fAtoH2HB
	bBYCwFqFdzGe9X2sEIhyzk+rXhtFiAF9I0s/rBQB4/wVUc8DBsqEP3GoBegvLKdJFdb3Ia
	UJW4qMtdDMYiSnHMLCpTci8cuvj31Os=
Received: by mail-oa2-f10.google.com with SMTP id 586e51a60fabf-46adea418f3so1200765fac.1
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 06:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788787298; x=1789392098; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QSUCkb2IsxXPufzfD2+/6w1ZlHPJoyK0t/kGTCdaAqA=;
        b=VqyOgBnFdMzv2++nFOSF9DmXNdjpaDBAia0nUlUMj9cUfEjHO1eK0jEV1dbGt6lQL4
         4lIe1dZUXiJp57YY01XADsdp9ftNE484pJEqh2ZW0PWJ7TgV0l81t3DljXkVpvE1b8au
         VTLbMXh2PdfT7wOkFegNHh1E+kisQy7A30gujEJAUKsGStM4TehYEWgzOSToiEuJ6Lyh
         8+hMhLmnRo833qKvxUAqfTMcfxh6aI8J7FOgg7wvugjtnmiYoZsEkT6o2A0Q+J9JJtUN
         pxPcyxvQ4d6bAPKFqh1IhJKfE2hr9vfzieV6XdqIS8aF/bXyRZefYCHKXqWh8jHAcJIp
         kkNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788787298; x=1789392098;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QSUCkb2IsxXPufzfD2+/6w1ZlHPJoyK0t/kGTCdaAqA=;
        b=PuKC3pNMQMvcHTI3i4PerBpW9DCc+tEPTD+1/n+uIol6Mkk9WREdE6qj1veCLALRYu
         r4ThXzMQx5ydm+xA5/MFxRu/FNR6GmKuv2UrBbhWkpLeTK3aW+Jni0jvALxiqP1cbsQH
         DfW9JTOJuGQFJvUQeTHveGCuaf+nHlBNM843U78vL1IvKqdhxgBLqrojVrfKVuniDKzZ
         ocax2E5JfIpg72wPSnul+fEPFslSaZGcXy3/yvTiQpM7859pP80qNH5EzJbc36ey6zTX
         MVIhalBwj9yDd80ciRgKdQ4iKA85UnPQvZ6OJMYoecAD2kUPMueS4P6Z/6vFNCLvsTLs
         PJcA==
X-Gm-Message-State: AFuF++lLHZCH+mr12lWvwohgIFTx0lNg7BuUq/C2P0wud2hBRAElW9AM
	b70Y744i5IG8nSREUV7guI1CfILAE7LPLQQsk4uEBo7GNd5QXDeY+pVU
X-Gm-Gg: AYBFou3ju9Ll3ALTQO+S0YD3/4TbOnc9O/o3AtHXTxrgbFRwWDlVt1o4eQGZFDES0kO
	H2vPHGwQWcQFLf5Ma7MdVW4ZjmJUBiS73IHl8XUiU/fma3JMAH1bZ8sYLBMmkH/Uffp8FDxOfFG
	NlOozvovZnh1LPo6ox+UskeXK1+aKxNfbLGyzgFjXlKr+PJqHfL4X1ipX8WoMomnpU1Fgm2czgB
	/4IYo2txk+wCUg6zXLW71nnlwHQOIOjaPP1p8JOFOY8vaIpknm5Vi2559GFuKFERiD6w2SDc63E
	l4IFaRM4wf5t/8JX48HinnKsz3tT9wLvSw5HiJH0VIEeUMZD15XBuwuEn/ndGnUHmKRGDzG7jGg
	7j50BY7hTKG3NiMOGmodvCBlnPhU9ZSZzF6FOrttKiwwtDEKYayBzNhxRrgPEHfPmZTfwN3RBqB
	YMe1slJvWFSgLnAOJY+8zdEKhkLo1I74EPW5EkzsU3lhFRCCog0T+pOfHkJKSi1Pt92k3j3RBbj
	KPOm5LxHa5pXD07v/G8W34p93WFud54+LZjFbGN
X-Received: by 2002:a05:6820:2004:b0:6b9:2d62:960c with SMTP id 006d021491bc7-6b92d629902mr6339050eaf.68.1788787298260;
        Mon, 07 Sep 2026 06:21:38 -0700 (PDT)
Received: from HXDQXTDYHN.bytedance.net ([139.177.225.231])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339bbf1feesm28284062eec.26.2026.09.07.06.21.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 07 Sep 2026 06:21:37 -0700 (PDT)
From: Jinmeng Zhou <jinmengzhou22@gmail.com>
X-Google-Original-From: Jinmeng Zhou <zhoujinmeng@bytedance.com>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Wupeng Ma <mawupeng1@huawei.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Jinmeng Zhou <zhoujinmeng@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm/hugetlb: fix subpool minimum reservation rollback
Date: Mon,  7 Sep 2026 21:20:55 +0800
Message-Id: <20260907132055.26696-1-zhoujinmeng@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fgsx5ms3f8fqdphg8d3je5z89sobzhgi
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8333E18000C
X-Rspam-User: 
X-HE-Tag: 1788787299-916288
X-HE-Meta: U2FsdGVkX18aP27RTBilcZAYpLFc17FMLCeiSWGNp77271LmNVSEb7PiebeDPU2Br4hGG9yPCcfMnILVFif2oeWu13MZO4AH11UeT1tyIfva4UoxYMNQw5Teumn4S5ZvUl2itOhsN8Z9v7WORV/F/pgSTJmeZyCBCKSGTJW3jMkoXjK5yFa2v16uqSTaeiW9hTF+n8GHDj0N9SyudJoiNbeou4Mo4gNeTBqzTQQv8xuWZpBK/LCeitNP4SyGsei7WJ13mgjh1Sbo70+fdCh8hoZtzskP4nxhM4BphHa8isPMwskZTYJZTg9F/07MFZ+oS89cjMND7XC4Pe+jdV8F3m9akwl6l0vQup4uj7NHWJnlOS5FJqj2t7Q5EScPV5uwoTUmx8EZFj1AQEYota1bT6KzfepGS8bMS04aFfCbvfhk13HsW13uiwtC9u8HvGvEVcQPLRwaIpCSHcUzmOQQGprNetqafY3oyfZpcEM8YO4vjR4CnD8gXiPE2/m9WLlKdAkAnTX7PeZXYI6ao3dIJAOcm442hOn+/Y8e9871KszRBvqiT4IZkon9HvmHro7Yd70qSECEmn6+jOZypUgwIrsQCwqqSb/Ma/fPM8Cv0WxT+OSes58zZT8omqq+rQMscDdcIraKgEF2McclapOVFe7wHnAeB0BKIuoSEW3U6nmn+SvmYWdmgdZza/jSVJ0iXSO3FEktLXkjzmKbUeLMXtBnsMhA/M8JQwO9dtrX4pRm8sz30EiCDehEO3I+sAa5xEu3Fw36pVA6N1BW4Wzvn8VhWx4AHTFrvD9vCScSFZISqpa1o7DVNNGth/6KpoDVEPDejP8jinBWRqLBmAXL08hlwMlf+037ikiiPtwkkMmaw7wDXuEUT/u5JssjUng0uBW6okKPLp66EdIVaALDsq/OsoqkTEpxR2cpnI/+Ho3tpGzLpR8gHfT6EAO3y7d6feh12kzUvx6FnNUx0xx
 C23jWYaZ
 TzPFDRIKVdIZH+ipyg6HYZhdlpoVOexAfc6VwWziJM7Vp8d/pMTSMWXDWTvYda2blxyWdlQ4U66pb6XBYDm5g7vTxRg1QPOipQenS6By7bzY9A+YI6dDmcDIom9gG955kp1bpjFve+3AdAxeu7RNevJt6YIyaHK49AQogsiJpmVQck5zmVKXv6zG34daiM+UquSueest9SxCZ3KcXrg7L1+rBWdz8szzfsRT0rtGxxqsezapEOJ82/piycEntwTeBW+Mj5d3czwDPXGzDwhTDN1kGw3ulWdhrVgXVCvYbvDHG3hs+ePuf2G25t4fpRSBYVwiWvxJ8DAQ6Zhi3/XYk0XIIyfsWojKQs7Zblb8UJS2d39CbQRiwj4iOxDiegiZMWjMiZzfRPZf3v1A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a reservation request is partially covered by a subpool minimum and
the remaining global reservation fails, the error path first calls
hugepage_subpool_put_pages() for the subpool-backed portion. It removes the
failed global portion from used_hpages only afterwards.

hugepage_subpool_put_pages() uses used_hpages to decide whether rsv_hpages
should be restored. Since used_hpages still includes the global portion, it
can remain at or above min_hpages and prevent that restoration. It then
reports the subpool reservation as releasable, causing
hugetlb_acct_memory() to incorrectly decrement h->resv_huge_pages.

This was reproduced with four 2 MB huge pages and a hugetlbfs mount with
size=10M,min_size=8M. After a successful three-page reservation, a two-page
reservation which needed one subpool page and one global page failed with
-ENOMEM. HugePages_Rsvd incorrectly dropped from four to three even though
the subpool minimum was still four pages.

Roll back the failed global portion from used_hpages first, so that
hugepage_subpool_put_pages() evaluates the minimum reservation against the
current usage and returns the correct global adjustment.

Fixes: a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
Cc: stable@vger.kernel.org
Signed-off-by: Jinmeng Zhou <zhoujinmeng@bytedance.com>
---
 mm/hugetlb.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 785772845795..3e3cda181e72 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6808,15 +6808,6 @@ long hugetlb_reserve_pages(struct inode *inode,
 
 out_put_pages:
 	spool_resv = chg - gbl_reserve;
-	if (spool_resv) {
-		/* put sub pool's reservation back, chg - gbl_reserve */
-		gbl_resv = hugepage_subpool_put_pages(spool, spool_resv);
-		/*
-		 * subpool's reserved pages can not be put back due to race,
-		 * return to hstate.
-		 */
-		hugetlb_acct_memory(h, -gbl_resv);
-	}
 	/* Restore used_hpages for pages that failed global reservation */
 	if (gbl_reserve && spool) {
 		unsigned long flags;
@@ -6826,6 +6817,15 @@ long hugetlb_reserve_pages(struct inode *inode,
 			spool->used_hpages -= gbl_reserve;
 		unlock_or_release_subpool(spool, flags);
 	}
+	if (spool_resv) {
+		/* put sub pool's reservation back, chg - gbl_reserve */
+		gbl_resv = hugepage_subpool_put_pages(spool, spool_resv);
+		/*
+		 * subpool's reserved pages can not be put back due to race,
+		 * return to hstate.
+		 */
+		hugetlb_acct_memory(h, -gbl_resv);
+	}
 out_uncharge_cgroup:
 	hugetlb_cgroup_uncharge_cgroup_rsvd(hstate_index(h),
 					    chg * pages_per_huge_page(h), h_cg);
-- 
2.39.5


