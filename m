Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DDE6C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 12:24:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D7976B00A2; Tue, 14 Jul 2026 08:24:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 161CF6B00A3; Tue, 14 Jul 2026 08:24:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 029036B00A4; Tue, 14 Jul 2026 08:24:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CEED06B00A2
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:24:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 681591C0274
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:24:01 +0000 (UTC)
X-FDA: 84987299082.03.D399AC2
Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	by imf25.hostedemail.com (Postfix) with ESMTP id 88C2AA0007
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:23:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="h dlnm5p";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=A8JnJvmL;
	spf=pass (imf25.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784031839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RlyQ/1sYUn+kGDyqGS8qP1M9HTBHhDiPAEwXerbSews=;
	b=CIxj9DpO5FI28aFmKYbzClkd3zLpgmwwoPQjQPvScsvRxtZp1jZ2oeCkzNW1AOBeUDvdRU
	4ZoLzqZsAAwjWZu7vqrtIKfHuhAvGDBwKwWd59E4nBn8J9WimwPFeRGkHbNXjEdliljQIu
	RnC4daDWh6pcyBAzGxmrqPyR3Wxnbz0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784031839;
	b=nb9uhC0WDGyyvJCn2L8a4ono41RRr98Jyukah5QOdevD5T5YsU9w1qG4UkingPYxIjQEjI
	JLXkWvchaaUs78OhWe++g+ecOWGfzIJIT4qiNUoot2rmUno1zvTJCZqP/j2aFf570GMetd
	EsF47UynGwWNqgqU/XxSg7KOaUzFfNM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="h dlnm5p";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=A8JnJvmL;
	spf=pass (imf25.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 865307A00CB;
	Tue, 14 Jul 2026 08:23:58 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Tue, 14 Jul 2026 08:23:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1784031838; x=
	1784118238; bh=RlyQ/1sYUn+kGDyqGS8qP1M9HTBHhDiPAEwXerbSews=; b=h
	dlnm5p2GCBYXBj2MUTrjwn+EJl5ONzDA5mrRG8cV8vtEGMkFMRWfybDfMHuWtdZV
	6CF7+Rp/ydiQH6P2gKLoxTkrwOJZ3Q6y4Nhu0NjCgXrFlQ1r2oVa8tGpK/lLO0xa
	yydeId7vsj2wCzYBDz8oNnxa/zL7UjDPWheKmnNlAauMgb0VOVw49HLpgCfWY3IB
	2/GExERlAD5RVprYpbq4DAbroN8nFKTCMWowUKrn6DyKNEz3GxgrEqfCrAx/zCop
	In2eT8Hsr0Tm+7tvqEjbHmbcG7QWUc9iGLka90CTVt9CEIE4ihKhNR0W3H0gM0vA
	VVAicLmAmDi/WS1NblrWg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1784031838; x=1784118238; bh=R
	lyQ/1sYUn+kGDyqGS8qP1M9HTBHhDiPAEwXerbSews=; b=A8JnJvmL8Ik+1yiXB
	cvM9XiJL+MMze96eFyFb6rzhQSqE8+5QvLB4SOzzE8nexiOuFreMHORoFmUWfUbk
	AekZa+RwPD0NJT/v03l3ypGr/a6yrEm8gymfAKF4/QRZ9cp4UQb7+TnbjTBLsrB7
	lagM2TjXuOmrqajRR9vTlwn5NBq0cDdVuoEN3dHJ/+EHvuFSWQOaB2Opj9MOXs/7
	tOjKRsLq7EvSozv9lij7RUX7/GVP8L9G/H3E+FHc00QqB3tn0uou0PqoHDi60aYv
	K0/qnC8Ik0uq3DD4huFJTk2CHWssfRb8aQvioO7SsdeThojiVNqiyLHbtVOcmR4L
	jOUbw==
X-ME-Sender: <xms:XipWai85tPX2eCXh-QZBkibLHBom0ZNOB-vkmKv0s9RDJrWApe0hqA>
    <xme:XipWakEqi2QqxaMWap_pP5YfGPAUovDolQ5aqBmmd874d7GXY1nc37xuo9SBzM6nD
    2Rc1qYJKVWk5blDlG1bOZTf3079bvowunccX3LdiNN5K7BaSOGv2PA>
X-ME-Received: <xmr:XipWahQj2sTArGSoQW-aZmQ_yFQGKG8U6IzP69lQBTUxuWyPyi6fumFIEnlLmA>
X-ME-Proxy-Cause: dmFkZTFMICEClsb7Ov+fedgnp0pMqXO1FfBD0xvZZ/V6P433GtqExWJyu3GARbG0/r6UJr
    Vf8nlq0lv2eCRUGCgAvBzEv5gE9KqzX1y7uFCtcvkB+wk1F+H1pzvrmeq3ImlGsBni87oI
    /YJqxi0JFt3vGMbm+u361lX7c8CBMgJ1ybWe2KN/ei2Wm5Kh7AGZP5ET8MkAeVDldf1ZFf
    llAd1ziCU3FyBV8QCjXQzkJyi8QMxgwqv8RzxuHH/6PIE1w8t3MzGVjuBE4OT1E4WpjGBL
    sxvt+r+K97QKtnJqN3sNNbSNEnM+m+h8tV+Tsxrhb/vhMT9muSuzm8yJyy59nX9YgO4xor
    30JfFSD2t1CmF9NejP09k1EANtNrmkL5jIxnKNv9Su/ZvmS0oYeNEf4Er6eS6d1YV/xp/P
    osI62xrqjlkfFMMGca338uhwOb0jZzvqJoSbkg1z4E0M/pUvMzD7RZpEJxKS1GulDvAQFG
    NQImhYk2+kjR0uZy2CMdRPLufHd5rh4nOTjPrRaG9L8nhngV+OSGAXMEXTWcHGj7PkYasC
    8kHbPAFSyTwt+dQrLruETvdDYFt8zz6XdkTGEhW3i73z49yGUH/HwDi5LiIWTdbteTfp03
    NT06J+5zqw+wYRdBcyFuRiYGKCCGDtqz6dXz/loeY8f0kZgdRW5UHQOk8ihw
X-ME-Proxy: <xmx:XipWaiuey36U_RcywldP4UYpel7Pt1ylFhuz1aIIMauwdCd55cT0iQ>
    <xmx:XipWauADFxw0MPf_7J5LxZsKkWe_M37lC4YTMVF9sngtsgJCOSwRlw>
    <xmx:XipWavdDq4p_ZPpq5B_SyoK3lQkxb_Bu3PqtZh25J71L4fgrWDUeXg>
    <xmx:XipWamosn3V6VD56vX6jkhfuVu2np29may-dR8FDM4PUgj_FfCd0Ng>
    <xmx:XipWateW68lWMvTZhlBjCDZ17m1c0Dn7PSOE_2jDhTQgwHrt8njSWyif>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Jul 2026 08:23:57 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Hao Zhang <zhanghao1@kylinos.cn>,
	Hao Zhang <hao_zhang_kdev@163.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v2 4/5] mm/huge_memory: remove unused can_split_folio()
Date: Tue, 14 Jul 2026 13:23:43 +0100
Message-ID: <20260714122344.351895-5-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260714122344.351895-1-kirill@shutemov.name>
References: <20260714122344.351895-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 88C2AA0007
X-Stat-Signature: jao87566nwjbrnkyy5cranqun513zbyo
X-HE-Tag: 1784031839-309284
X-HE-Meta: U2FsdGVkX1/1fo7+qk+ns5v+5ewvNHydwS2bjIvsB1QnjOlNCT1ICLkgT/zORAuaFuY2PdL76t8GGVYVJ6IccwtjgqYp4tlsGzZLcqe/iKNR7Bprq/lM4qZz08xGWMRx8C0Ge4VpS0yf1A5uFE+0zaI+xhlCFmc0pXARdo4UpLEZhlKDdxhJubjkggSBLh+O8SHAaxI+gxY/+g9N+DygMUS6Y2IeBLKNJWrYhN0jMBpChR/t/Y6H+W/+QBVMiurRWd+g45oAstxVge08eV9uDO7I4Ve5WJEMvSuiQBgBfy4uAwnDkIVtdqMuwsgm4SR/Zf+SBcEpnsFlqOUY5eH6zGC+8YpzRncKOvtLaKwSP47hyIj1K7j/WBYhDjaM4/U6IDM9zzI7+erfQ5dG9xquBCCkEIqPoypGQxPEQhscnvDaWp8xmvw5GeaykxFQlAqxQMMYZk7nicfrsJ5di/CN2/n/zEJGeAqb1AICHYPGukvpI1lBmMfDMTzUYH8w3tppRFNMPect6MPhIwRDrZDhNgppjcPEInAoV6TMRa/SpE971HINLVosFvW/9px9DVDp1RAgdBd0r+PIwRkMapHk7/7Jfxaj6ihun542f4uiY/Z8tReReYqO9TVXYJDnO45ULfneMwp3R1uSBWqTBatD+r6yQIo35sZlqkl76z04IHy2LOU2chl73Cyfb/wkMbdhQ010Rqntj+7CDtQZF1ojN1R6VpNGmav7g+qS1pyCsLE9JjXFGsfUv2NpybJfOytRNfdyB57fFknwxnEPa33Vm0vsv1W5/TWsz7wu/oDPVm7A8UBOjWIedfOKiYLIl4TD+gylV3wi+ILkRo4o5DHSko7x30JtHleeKm4SZJ1ZJn96X/oJ+5s+DYRJxWkt4zNqVvaG09lkeFmpHN45VA5N/Seq3pX3kvX/ThH6dXdqHBb5iumX5VA85Qi8lzX8cpqm7j1TEBvtK89YNV5Hi8f
 2LkwV6E7
 t3cAHBHydNgIw5aoPxMXnrnbt+wfZ628eJkpPVPdxhL0cvwpc+nSbY+j1ZNx3tYzfofFMHrHcPR/V3KcjIiPyfwJclICT0Jin0rTzrufobOWhP6sDhuNlhDh1WSkf0zPk9EZgYFfYRyECEia/R5ZykMgGZa9qW/cmen41VmMNLwFLtAEDVWZ5nd+THoecJ4/yZGWItT3niMcv+ZCVLvcUh1CUGkDaNzq+gIas9yVf+PgcKDp5JNumBnBU3VqzHqhjfzs6gG9Xh46EV4QKYVHg4PO8I3LT3m89KFPsc+TEQQP9Jnvc2iPQd+/fM21FREjDrWk8V+i0E9wK+oKFFi03RTSVGXwfpEhCFLjcp7Y8a4le7bfi9Z5IiUnhyk4ho2y3d6t8pZxmCAQCWdZwQ6Ms8S9/GD1P7Q1G/g7KusOhbTqFf7FPDFnuESU09kWWjwvRtSzlIUhmMH+32XAlIpY7AGg2MrTtFvhSIvteN3gS1um+HokzC7E/ePqwcisUPQ2h9RZj6OGlqEOrzNq6EnW8MEMlhi0YubZcD0OJb6z3I1P7k551lrTaNVktaOHQ3dYveH/5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

can_split_folio() has no callers and no definition under
CONFIG_TRANSPARENT_HUGEPAGE; only the !THP stub remains, left behind by an
earlier cleanup.  Remove it.

No functional change.

Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 include/linux/huge_mm.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 77483c613f84..a38db095b5bd 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -617,11 +617,6 @@ thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
 	return 0;
 }
 
-static inline bool
-can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
-{
-	return false;
-}
 static inline int
 split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 		unsigned int new_order)
-- 
2.54.0


