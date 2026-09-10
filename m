Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ACEBC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 12:03:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34CD26B00A4; Thu, 10 Sep 2026 08:03:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FD836B00A5; Thu, 10 Sep 2026 08:03:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 214F86B00A6; Thu, 10 Sep 2026 08:03:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D7E646B00A4
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:03:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 346C11404D6
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:03:04 +0000 (UTC)
X-FDA: 85197716688.10.B06F4A0
Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	by imf20.hostedemail.com (Postfix) with ESMTP id 123D41C0017
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:03:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="e 3XMao9";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=h6WSVLIR;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789041782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i+eq01ZyefSmr6d5OlM3Mqwv3cqLqDcRLOfX9U2ttRU=;
	b=XPdbBZj3kgUSYK+tsU7T8Q68XtH19t6406rSmFYAssqe7v4yarxHP4gjcHQBgcoUfM2gBQ
	WvcR7DZLbBX7qPLZVCQOIFTyo9Yh8YdmE0kmeNfy81M6j/TZdnyME/e6LMZukGTxYswmUB
	E0Tu4YIUqBYeyb2QWJM9qOftSxNZfU8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789041782;
	b=2f9YpzefW3Z9ODxKU5pQECLIR/+mNmVJohEo6RUckH5QxhXB8RyW3KxJqXHgSSb8Ofbv9b
	MHexxtmV8nqGSaGM8vu0Ywk4jwDz1x+PY7JFVWnjK9vGH/o5xkBt804FYVgxG+VHtDwU9P
	iIp50LUWHxIj1JgcEqYs9hQMqQG/x8o=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="e 3XMao9";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=h6WSVLIR;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 07FD67A0041;
	Thu, 10 Sep 2026 08:03:01 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Thu, 10 Sep 2026 08:03:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789041780; x=
	1789128180; bh=i+eq01ZyefSmr6d5OlM3Mqwv3cqLqDcRLOfX9U2ttRU=; b=e
	3XMao9Jtt5cKGQR2StPFOHxjNhnlH+KM78Bk9e8qphJaAiwsiIq/tqXzAzLJcJon
	R890L+n6Z9KJfRq1GCfBsPFlg41OKgxvTSFB3LvW7h/aZDnGmfPRaRHK8R8MntoL
	JLx/gPgn1Vy3bGoVtLteJA6XG2lwchbglZ5GEKqtN/W2oqCCHQsgoOaKL0/AAkWW
	gR+MgNsdMClvl/S4AoUio0Fm6FfqY6ulrPM7DCO5Q9QrwidrmkSEdDjNpG4QQ8D0
	t5hHwbKKzyNOQSrfhUM9K05TMYNWDmYO6w3iyUbUHayG0AF17YXc4673mrbJ+5oS
	Qky2ae+BEq/UBddnqLa6w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789041780; x=1789128180; bh=i
	+eq01ZyefSmr6d5OlM3Mqwv3cqLqDcRLOfX9U2ttRU=; b=h6WSVLIRkvudhqu7s
	I1uLv247vGEPvst/A5i2Q+4GDwVl6bFTMpdjvweqShRNzhVPX5c1ALy9eh3oeO/z
	j+vHCt6eRwcUquM7hxKnFaVXRmYvJ7rwl0vgoWLdvFuqn2GvlMo6obMjwh9P/CcP
	u2DFYJ7IrXP1TQ8G2xF3eU/yTV7jb2ECP/eaZY/E/NtfJrLWlHxQG59O3HyqO2M7
	EvvcC5HNsjEhOpAS55r+ZZybEz8tzeQkZGydfgUwByRe0018zNbiqP5EhtK06k+n
	mOEl7AmJG7k08qTBvpLGnilACvMnNI5Nh+olzKOYwl1MD1WdUwUWNKjx7eICY0C8
	osWcA==
X-ME-Sender: <xms:dJyiao-AK8wOl_1c_TcHuFNiiE1r_ruK_nzN8vTKBrjCGKdlvsg_2w>
    <xme:dJyiasr1HtNzgGdBVoIJgdUOi-DPqaYGqEiBWl1F_sTiTQblZ2Qc2rToecOBgJec0
    zqvoKTPqFq_B8MEkgtvNEcxwajj4taNxPL5Vv83nUmEghs-BsWSNgCW>
X-ME-Received: <xmr:dJyiakK_GzoCT-4Szo2TpqHKg8t-r4LZxpjfjTQ3B-t5mG2EHgxRdljPDZs>
X-ME-Proxy-Cause: dmFkZTGH8GFWwEUBtPxKJ67Rq2x/vdej+Q6nUCGcsDIesBFp0X3hc4jYyZuxmlnDOcFOMj
    pjMT1hhilwwz+XztIrpfsk+jOgPg51Zko9HtX5FOXtwZM/xuJUIPYajGOB/mCLABcXoBUN
    tOK7IZxc0LQBxYWwS3D6Gb3+L6Rzatr9ZhNURjEQibWJdyHQU+pHQvTtQJMa086Ym+yd6R
    IInk1eh8W3seorGmDJU/iV1zGzfJwWvedZT0VKJsUgZ7fACBrQNd9k3L4EzTZNF344phSI
    j6ov0R0Vo2eJRufAS9ocD/WtRYG80u0cUfKpHkiyow/cp96ftI+MA3MvYDL4cDgvN+YPPG
    fRRoz69BGBlITkK/LSke5bri0wWGJeuTSXrBdqgFR2AmcTn0QklmXi9hR9ckuC2cEN5St4
    ua3Gjf98LYsRIRagxKu1OvxBNeGrAncStQm1puanRFRCh5145vT6aJEB8yRYFEePWZjpFC
    2Wd2atVP/y/YgyZ1OHjajTW+iVe2fwHNhT/VTjz4FTkVYWvS6OAYE8Pkjsr1r2zZ/FP1f8
    QEMd++23RwdcOAZEcqBM8kCUcL7jhZDY3s1C6V0em9DHt9GTrEYwhZVexEuOWHMZchUEfg
    ZUZCLGM30ZvYpJLotneYsm3cxOOLa318xExILXQQQjz2+hBAu7jn5zdj105A
X-ME-Proxy: <xmx:dJyiau2TI1v9IgexJUGpt4RqCsYRPgG-lO_YnBeSdT9ARZkIMFN_ig>
    <xmx:dJyiarWcSLZHSTNBTZzfdCiY7ZamHxOAUntEpY9tyBrVIb7g6olRPw>
    <xmx:dJyiasXyueNGyRB8bn0e7-I1E4s3b_BCVo2hcHgEdpmJTBT9FMyMSw>
    <xmx:dJyiamF7hPQxTzu_v15x_L7XkJWMeCXNGYluObt0jzEJVtun2BMVNg>
    <xmx:dJyiakXdwYCQl2DMT76s5ZM7hKTwilAIQ1Dwty-NmlxRWt5noylLE4mC>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Sep 2026 08:02:59 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH v2 06/12] mm/collapse: drop the collapse_possible() wrapper
Date: Thu, 10 Sep 2026 13:02:26 +0100
Message-ID: <20260910120238.2529819-7-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910120238.2529819-1-kirill@shutemov.name>
References: <20260910120238.2529819-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 123D41C0017
X-Stat-Signature: qa9om88bksc4hgog4q17c3w8sd1c4mcw
X-HE-Tag: 1789041781-467556
X-HE-Meta: U2FsdGVkX19v/Ls8NT65/ew6RJz0/gB++oJ2533FvjcTz1CY8i48ZSjAUo4p8EJBi1LC8MYXyo+zgOXKZhH+/zby+Wi5QXeExBAlrRPrp7gi4F4Y8Ojk+WTszODCcHTvS+4NN89XYQ2tghgzB205zJw3/i67Jmxchd3cdF8+c1eVpQ9eQEsoDpSPEzUF0gGDqXtNDKC4y3r7gY/w8G4ffVqkbORc+7Bj2sNy62+AHuXQa3uD98dBYL2/u0hcAbkR5ao/+4F+NbOr7IuACpUNyxH/62Zzue6t7azLoQQl4C/5bbD2xWhiUXm/aNWtGAFf1bpt8f+8cIpCcJsOvQACTDzV/Y/pqeenXUoXo9hX+5BiekeBjv+7oPlKfxIDklysCnPZdOLvHMsv3Ry0ouG3U9Q7Ue680+Vz1+if+jirrYv1b7TsOW2iDw/eNPtKMKY/rAbEf22YHkl0psZamqRLRXxyrV5XOmGhl961eg1b7OY+fxCSixkwkCTSpNYvbrgWxKNgnzglClnr/O6J3Mi3NWFRsNUgdS/cQh2SCQm/k983mpUXEBfMcWUuRKcTiXLe7qscqLQDnCAyXmz5UEsYY+UykdOINHeO+Ip3VcGTuhhpeTh1h4TyrazmrAaAzCDrDRnlGoe/Np0Z2ylwbva7EKCNAYCagYlF7w4r9HTt8HJ+dVOc6X/fF1ri9GfBRKgqmpqj70JsawMzbc3yDRS07IAeQJXw9neW2gMD+/XR3U7mCN7ST4gQcY2s42/7UDNMoqXpjUhzHzEySUET0n+X2qbFfAAON0uLaNKYlgr72rFxhI0AWkqHyEM6jLkkz1umhV8CL9I6ZZPkRzq61UX9e+Nas3hWIqaLTVYpDX+rG9p6UUWU5lvaf+SSs4VcIKAuNzfXD7rVVc7OinRNDt3Nr+OWGfEKW9Q5CPXkJsY4yu/r+jpDhi0jNTtNMWUMcaRQm7LQc+wa3/I0LCh2gWh
 bCDqvSC/
 MBPeRty18PcazSU+7No0fJNWftYIvcPBKmA3xEElb6byA9ao9dp9aRZXkbKZSf5vktPezNKxn8WKjtiYpjapYaJnDu0/mBg97hD34qOnR+ZsxVkUZPU2hN7DxbUe0WeTSjTyom3RT28Y/fXJ71YS45VJ/Rwc72T7or1IFtf7k7CF8Bui0PCNvrDvhjUZ5dotYp2sut4D7Fwk7RRxbvRzauLwXDCuIpbGXZeKL8BcykyB9usc+HK8UXfqjfeftUzSEqFO0Pp24Jqd3gpt4Anew1NkuZX2asyxa2odS8gZ46YJ2iFp7y1ythpe5bs0f8I21LcjGH8/7QbjzJvy26XvQyoWhStFN9WWxgFDr+3AyXTMmCNSubHYP2eoeVQvJP8CTH/FQI1ppU0wvRcDIAboVKHVMGplcfV5KNXIq8CgSBumQXiU/wktgUZqDY8YToJhEKBymWFxR9+tZvfuQHYzuNCfIYoc1Zu4baP5UHW65eE7JX1fDgz7ezNJv5DS/e9o49iPLYiEyrtMbttB3jb9DM55Nips3WlxN0BEE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

collapse_possible() only forwards to collapse_possible_orders() and turns
its mask into a bool.  Its three callers can test the mask themselves.

No functional change.

Assisted-by: LLM
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/khugepaged.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 16cb94ea3455..2a9f6d8d6695 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -512,17 +512,11 @@ static unsigned long collapse_possible_orders(struct vm_area_struct *vma,
 	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
 }
 
-static bool collapse_possible(struct vm_area_struct *vma,
-		vm_flags_t vm_flags, enum tva_type tva_flags)
-{
-	return collapse_possible_orders(vma, vm_flags, tva_flags);
-}
-
 void khugepaged_enter_vma(struct vm_area_struct *vma,
 			  vm_flags_t vm_flags)
 {
-	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) && hugepage_enabled()
-	    && collapse_possible(vma, vm_flags, TVA_KHUGEPAGED))
+	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) && hugepage_enabled() &&
+	    collapse_possible_orders(vma, vm_flags, TVA_KHUGEPAGED))
 		__khugepaged_enter(vma->vm_mm);
 }
 
@@ -2857,7 +2851,8 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 			cc->progress++;
 			break;
 		}
-		if (!collapse_possible(vma, vma->vm_flags, TVA_KHUGEPAGED)) {
+		if (!collapse_possible_orders(vma, vma->vm_flags,
+					      TVA_KHUGEPAGED)) {
 			cc->progress++;
 			continue;
 		}
@@ -3170,7 +3165,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
 
-	if (!collapse_possible(vma, vma->vm_flags, TVA_FORCED_COLLAPSE))
+	if (!collapse_possible_orders(vma, vma->vm_flags, TVA_FORCED_COLLAPSE))
 		return -EINVAL;
 
 	hstart = ALIGN(start, HPAGE_PMD_SIZE);
-- 
2.54.0


