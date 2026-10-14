Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C7B6CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 17:12:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C67796B00A2; Wed, 14 Oct 2026 13:12:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3FB56B00A3; Wed, 14 Oct 2026 13:12:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2E8B6B00A4; Wed, 14 Oct 2026 13:12:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 975976B00A2
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:12:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 233EF1A06DC
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:12:20 +0000 (UTC)
X-FDA: 85321875240.16.6BCB275
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0E9E140010
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:12:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XaM75o3m;
	spf=pass (imf07.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791997938;
	b=BVji+JtV9YzHrbjHN+4khJxqg1lDHwWI3P8uf80aaaGsULoYKMHYbKyZNFB54Z6Vq7aOUQ
	7TEHS93HHWn0Fnq/WD+xjZel2XQJwAhVhobmd/BhU6QjjKS0iKaudVCA16FX42xSaKq7Su
	aCRq08luWF45cFFtn0OnFiDPBXweyAg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XaM75o3m;
	spf=pass (imf07.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791997938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tE4Nouxbe18VqCAKs0hRv8AZoWoMV1442HL0oYf55VE=;
	b=Jcup7IyVNrYITd8nsEjaBfGaMd2Y/Or2xRkHloKvlIPMf6Fd+zrIg0o7FuUtGQ0RZ4TnRu
	pVRzPIjM4s//dRWJz2V+5w1pS3+ABo4i5k6A6GqltvCvXE3lXlmhS6sBK+Ulb3dc1jI+Dc
	2ginxg9U4K+ZkwM6cxKMxPIESkopLeI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 65AD743D4E;
	Wed, 14 Oct 2026 17:12:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B59B21F000C6;
	Wed, 14 Oct 2026 17:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791997937;
	bh=tE4Nouxbe18VqCAKs0hRv8AZoWoMV1442HL0oYf55VE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XaM75o3mI6pelfaHhRT1T+bhFcI6CyaObGxu7udvQRvXbDw7bIRh/7JnbA1bJOR1R
	 KQK2IkCTo0OoQMJoH87iAdkmQwq2yFcKqWR/7twPIdxVnjNMY6TtBk6el7v99BFBXO
	 v20UHUCdO8GgLx82qrAk8fC/VHILw0oJ5LoIqJLn/l6dfbfybcvPuNOKebItTgMkSW
	 tX5ycMey7upLQDWSRv+9++61k/c+WoBdWjE12ENJAU+BtRS3M9vG4DAxGgnAXfTand
	 z/jjEsl/D9XRXqDt0spTeBy90r0scFRkHVNIidDggke68/6IbhsqbHsA0Ssp8Y+TNB
	 /F9+mxvUfgZDQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id A1BC4198003A;
	Wed, 14 Oct 2026 13:12:12 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 14 Oct 2026 13:12:14 -0400
X-ME-Sender: <xms:7LfPai_gUs5IOIXCUK-7z9qedLXJppntMdsbedFi7nWLGftJCLNwOA>
    <xme:7LfPaupsTAWyyrMkhzqgwPlrji8-org4ExE61KhKIiwhkERWGWbft9faS2TTFGq54
    P_YvWLOe6yXIDBTRXJzd9kx8uF4hoQCfkUf_kgfE1YxrGtUn_lQNOg>
X-ME-Received: <xmr:7LfPauI3_gEaUg6qwhhUtSATsxSAhmh1USIrYQJcuq6tWnfvgK41s-NQvSc>
X-ME-Proxy-Cause: dmFkZTGg3k0TVKsEP7CfoR57WWB+3h574BO5vjP4iWax6f9GidZ8szHobtaOvLAEbPCZ2m
    mw+y4/PWP+fl/ZrEvowyJM606Aqux2KjdkbOrs1qTyDsxUDjHhZTWksnA7am7MGg9VukjB
    qcXL+mBtcoMF0nKIYV1Ko0CB5fx2IplfPHhSynDMYzb+URxJm2HhB9bzqvrzy4Cvkw3z4+
    1ufb70dVHftr+eFTK65fTPkzZfMFIkT+fPjngxsm3eiPLOeyYT2uqJ47ZuQsB+0l7i804Q
    fk/9VtLe5apNPJHA5iwMfFjFMaiWANNYkGgKJdhqeFkBwi3mvIJ1y0E25HLDGDGvYAjfPO
    wgKlVGgK06TLK4ylVIU/L9XTKnWUJcbcnc2+drc5n1QpsX/5627QWFoL7ReBqhtFkREkdI
    0ZC6+V7VkKZG0Ajp4ZVbry5+s0NEKfTl2Zqv4lw1iWNasW/jcNQC5hgvhBCt11ByTR4aU6
    4m9rrItXQm8A6Javh/PpVIJBqcTZvcbON86/czwQTnHiaD4aKMtYGyTf/LqjB6Scuy8md2
    ko+GGwUQ/NLnTmLmtiTs7mKdghSzBwiQ3uPhA9oub98EiDiYqXrtVa5iQCicjUGzZaSS2R
    1I2vq1oMkBeEzA5COg09mxpi4FM2I9ao0gc5bpeUZksMuGenm6t9X/6hTNWg
X-ME-Proxy: <xmx:7LfPag2wcOI5BGFPL4YWAuHaUKtwIjdyeVA900oUin4qZ233-_vCng>
    <xmx:7LfPalVW4kaDPJJgqz7sbq4f7ycEFDcP2x4BrylT00NBDy4AJyXmyA>
    <xmx:7LfPauW7c3GHXpVZHOxy7PkkLMiGR8usB7_BGkFvAov1Kw8NuuFRaQ>
    <xmx:7LfPagHe0WBHi9qTJzrXeP8ATNwnFN7NzY2lq9DW0puGE7jpAGa4xA>
    <xmx:7LfPaqsD16_Sbg9QDybvbNpihxQamfOEqvVtDgRmn-j_JAY2BZkurqfA>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 14 Oct 2026 13:12:11 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH v5 6/9] mm/collapse: drop the collapse_possible() wrapper
Date: Wed, 14 Oct 2026 18:11:39 +0100
Message-ID: <20261014171145.3292736-7-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261014171145.3292736-1-kas@kernel.org>
References: <20261014171145.3292736-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0E9E140010
X-Stat-Signature: ia9u8y9zzcphyybtwyzi8sjxpbriyn41
X-HE-Tag: 1791997937-390662
X-HE-Meta: U2FsdGVkX1+5cWgN2zQFzVpw2ViMxIN/GaIteLFQtpGrItbxi2IVIuTUV6nnDa0z9242rhP0MJ7hs5MpG19t5fqlYtBE2ZcFEXJkHojY5PpcqzhijXyPIjeE8pNiAiNCpXasid9reSxV3AxkBcz5pU7Qq8BptS0c4mlcfi6VFDIYHYsG7Ql2H3L2SFLwXbQKOHcd+7ssm8Z45XR3L7XTG2unmiwTMofm5TfyiizvFjUhVN8GTVcdBhnA8uWlUkA1G3Rty10uOERv78gIh/ob5pChuQK87YrrbvVhkM5B/gdbtCjLGyUwm+JawtjBTpEPkiifp4foc/hm0vyMSp6G7CIkrHT4WhnrKwLZVgWS5wtohEnL+pszmlD/dnuJlIO7B95clresm4w6uAZH16NWqXlgXpCE+Ge7YO+eFLBWTF4PLLvMKTNZb/e0CSWqp1dRH2Ldo9InTiyyqTrwPcv2/waoyBBE0t5kCm1kEqEUZ91vhDPekMUMwTYmdMIULcevzh8ule3meJ75JJmkaHTyw00JNecb00oC7KtiQkPPVRL3dpAcr2qmlHOwEe/ha0eNqw9B7r4hVLiWOM2Skr3t3oL1QuYcayQYC7wFXRH5sSmV5Trc7VlTXKfY7Pq8wcCeeWJxoz0M01o+UM2IYj/vb4K0Luiola6D9S0h/+5wJ5Kz2Ob2w5iY/dajLSCia5O8LZKjNzYmrsYQ10uPDlGJHT+92MPw6oubYdryDhOW/t4/ejiuS5hwK2sRtiPUB70xTFNj8QHxGFY8+tPtFgJ4RTMRGEyXJKQay2BqRe3XJSLkYII9qrInLKUH/ftg4RrLVZe3uvczGDC90tNOdvVOZcLvYTRw3HlfDF9JQQWVlDi4Gg5RiEA40GHodgC3U1e3M933loYhXJJsY0IkXtHF1j01exeRSFv4XXwpm7BAXLuTUVTX6cMkwJFy10OJh1ksENisMbEvPxJYmjsm5b6
 VvwTzQa0
 BrO/dl07FEmNwqi5NJShpvd8WqxcB1v2F+De+hYFrK+eTrvCqKGuEganI6M9Uq+vA6IV882gUHv6HPWk+tKFxwe/jP2I3+GgBjqw6h0tHewZdqC0+t0/yLnCGc+s6kLEfIx0kgjD+M7OO8oboFus52oV3AXMt/Dbxmv9xfph+Rwb7Bl4jZ16prd+2csWlZq35KIaSpftUnq7x82VRmW87783LNGclz2piCIc7EytqlaXvzKyHshrRiswfKArbki2vitLhEGZPK9Tc3mFkKpbFHhQbJCCR878td3e0Vio91ws9cqWBL4ecakFd0yFQHpwF69+BNN+AHzFd+zHBJ2JujX8eZUxlU+DLEP7P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

collapse_possible() only forwards to collapse_possible_orders() and turns
its mask into a bool.  Its three callers can test the mask themselves.

No functional change.

Assisted-by: LLM
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/khugepaged.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 667216ae15dd..cc69281c542f 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -494,17 +494,11 @@ static unsigned long collapse_possible_orders(struct vm_area_struct *vma,
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
 
@@ -2855,7 +2849,8 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 			cc->progress++;
 			break;
 		}
-		if (!collapse_possible(vma, vma->vm_flags, TVA_KHUGEPAGED)) {
+		if (!collapse_possible_orders(vma, vma->vm_flags,
+					      TVA_KHUGEPAGED)) {
 			cc->progress++;
 			continue;
 		}
@@ -3167,7 +3162,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
 
-	if (!collapse_possible(vma, vma->vm_flags, TVA_FORCED_COLLAPSE))
+	if (!collapse_possible_orders(vma, vma->vm_flags, TVA_FORCED_COLLAPSE))
 		return -EINVAL;
 
 	hstart = ALIGN(start, HPAGE_PMD_SIZE);
-- 
2.54.0


