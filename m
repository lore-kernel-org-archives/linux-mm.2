Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2970C9833F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 10:07:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BD6E6B009B; Mon, 28 Sep 2026 06:06:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 294A16B009D; Mon, 28 Sep 2026 06:06:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1837A6B009E; Mon, 28 Sep 2026 06:06:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D7F806B009B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:06:48 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3AEAF14017C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:06:48 +0000 (UTC)
X-FDA: 85262742096.14.2EB6064
Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	by imf25.hostedemail.com (Postfix) with ESMTP id 47DB7A0005
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:06:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="s TTGQT6";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=SVnqndZ+;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790590006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JtRYOCEnMOR95o5EOlNDKC9VUn5wRBd2gubmY5dv2n0=;
	b=ZstneXWQOU/6EjZ0qgHbyUn8oorlCeN6H1GVKubgmnVo5CjbmfhnXPnFkodsb9B5e3jyV9
	Q9pY1XoBHBKZUtf8zMtPjY2J2nqATHQvXjrbx1AAO6D7WEAjOmF45qx5ogavzHJNowiTiz
	WfC3ocMYI+GA6rwuIXtaa+QDnNazq34=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="s TTGQT6";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=SVnqndZ+;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790590006;
	b=vCYgkToOfbR6pJp4RdkAmdHDxgyiXKjhpX89ODbTOtI6mCR/kEF5KwAKMPCgmHNghpMsoF
	OuRO6XNHWJQ5mP61JZeYsX9LdScGHHwwm+027cUDo0CjIWaTKdcfmRDO/9PDudfedgEudG
	AS2p5yYQfag4pQzLhRVdK4Z8UAAdlis=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id B997214000DF;
	Mon, 28 Sep 2026 06:06:45 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Mon, 28 Sep 2026 06:06:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1790590005; x=
	1790676405; bh=JtRYOCEnMOR95o5EOlNDKC9VUn5wRBd2gubmY5dv2n0=; b=s
	TTGQT63Pntq2LjwZvtXgxR/xDhXIYeK0+4FYAt44PykRKNm0DBNfPJ7HITIWZmHw
	cX+MzMFq24p1ymeQx+RQCf1YsH/ckM+Qi8/nLS0IdMpDBwJl2mxdDQbyna7+ySj6
	o589TBE7mC3yOCCcMW7qNpYg/iMDnAsccTcqkdGYDwySytPVx2/vhkexkeT0GDbD
	YsUGY3+6fVGnbqGMXPb5VAqKQ8yf5BxdJaakhi9Whlvf7oaVCGIHg7P/TYzXuUeX
	fKVfaFhFBZRDHmpsx3/MsokTd+Tf/uTSL/ziHIsOR7GQj1jnJl7o9czi666rP9cY
	sms+uMGy+e+jKmWEOpBnQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1790590005; x=1790676405; bh=J
	tRYOCEnMOR95o5EOlNDKC9VUn5wRBd2gubmY5dv2n0=; b=SVnqndZ+hQl9iKX29
	8yko6F1vCw2fNVoXNX19aFHB0mKr6f9tSHPlLpT7X+R08A0tGv4wnSDsWC5CpL7a
	Ym8Tp9FREHYC3XKKFa/pXcS3+LdATSZ9tXVi7P+U+hfM6qTHJTIZAPP9WEmd2MjS
	/ZpwyoHmPvT/QUZpNKTvSaGQXSh5e29E0qyyIhqLQYXo0DYlxwchsg2f0I59b6KP
	CeblV/+XW0zzt5ie2lA/RPrT2qNu9rYFkxwHoJsGr8Af3mxkWJc25R56iqOxMkMh
	ZupRuKVLZURa8bKuog8fQYpCbYsoqZuUQCal953x0u5lTe5HXM1R5cNiitXhh/h3
	qs+VQ==
X-ME-Sender: <xms:NTy6ahPhNi5hUpaeytRCxtbUB2LcDJwhty4uxsPdHDFobl4dYw_uXw>
    <xme:NTy6av6lXTy2AbMqs9NWUfqZgTeoozv6pi7ZeJNSkai_JS8QNPEJATxKZ7wPsU-AW
    cMhPpL2G2H5C6X12SUKNpH1dpsdy24vcWiHqTOYHFvYnxsb04-L29I>
X-ME-Received: <xmr:NTy6amZ9C-Rmn3tjU15lZf0et0Pk6Q3ia_vx7xkXIWsGXa3aoYahLXQl0e0>
X-ME-Proxy-Cause: dmFkZTF8+FzWl2kPFFw+2+MUnNndpG3Es29zlM3W8MqBD0QW9993JqL27RjsdWHL5iQTuv
    8LHkef+10EFcRNyu6aMfBJblGtUMhigK1wvWUg5pa/T2F4HZOycwBRl+2S+z7tqw2cJfHU
    gdsF/P6BOMqpKS9LZRm0d8oBtyKEEqCXwj8zji6pXjSixGW9yMDmevXCSXRhMug+RBOuj6
    H/TPGEbj0UBxBpkklI8Q2dk1KPN1FfxQ05T6kAzB+fcPQyWzSSafNh6004OlOqdREfhbRG
    BHI+j7BDMASDclZuapGmxVrXolh8JlQnm8Hn+THchpsYHB/1yAmWKg/yew9Ltzw86nEqGg
    5CaI4vvICvPsPX0fZK03646dpkM5SROv5HPUP8HzHWCxTTJegvna8VrPPV2CmUUeRKsiYq
    AMwqMgP0CeJCuiVyMShDxnH8OI7MKJGUAbs9J1LSIi6jTukZ89VTi3NhABd0EXisMYHMZE
    jrfCbdSfZXeuniByVvV3ViP5JNxVUuVMyUo7J5elZOlOAEDl4ygxA9nRCbKtHjU+N+Gt4Q
    cGj1NUiSWqIWysHshIZluHad2T6ng7y7JqvLwrB4WyKoPztAxLZj1RrmmI7aunSFwGdT7m
    YPnGq4qdvvyekejuBi+ApTALvjKXD3KR7cpiHk5kWh1nPE8SHYW5CZ4Zk5wA
X-ME-Proxy: <xmx:NTy6akHhO5ygwfV7s7j_UNm5zPiEsg7Lx9PFoc1JURyhYakOzsyJWQ>
    <xmx:NTy6ankBi2Q9TXkef4Z3V8OnBaD9IgZMKY9VulcbpRnjeGE5FTh_vQ>
    <xmx:NTy6ajnyNpnQdqBOmHxiTlCNUk7qFRfmvclv5K4t6I_9ZLXprv0YxQ>
    <xmx:NTy6asV3L5-cx0eh-tGh3krJD8ii5_BptCDxCGu-DeXH_N-Y1mcF4w>
    <xmx:NTy6aku5uK1iRXvyVJfDx8mGGqu1qNMMgT3xrFjIAHdGEBdiUapXFiBA>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 06:06:45 -0400 (EDT)
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
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH v4 06/13] mm/collapse: drop the collapse_possible() wrapper
Date: Mon, 28 Sep 2026 11:06:20 +0100
Message-ID: <20260928100630.21870-7-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260928100630.21870-1-kirill@shutemov.name>
References: <20260928100630.21870-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: xkk9743ei5cisbnjmb97dp6t7ynqskg6
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 47DB7A0005
X-HE-Tag: 1790590006-648545
X-HE-Meta: U2FsdGVkX1/U+PVc97pr4nCk57XtN4k2pWflrV9/FBSLCKIWr6z8P2LbRqGYhkWMtANczYWkWNusZZIuiKrvIucqQxrPmA+zeAfn6p9Vkf7N08ZjovKqjOu8ifZWv+ScT9TN7PA/kPJPbTXhPmTBkVE+j7MH4uCzwyp995z8TGcgkUwbRQW2bYnaIXKe05nVILRckbRCKHY1XBryi04Y9zvagNDK4qNALSJFHfqDdZrcSMm+DPl/B7oLuf1LvnELUmwsf4MPXLDPpMEPlZRf2U8sOS9iLgCJCkmLJOkwTmBAEDgRVh318IwgwFccthiZp3FLbLrx9zxv5AwGGcJOZgjKVhFI+1I2rRNCMvIc3sE++uUJLTD4szx/42m66ZDj6O0uqJUd/C/TducbsafzqbmP0gr54McOy1qn3vOCRdzzrVRHouDu4bA3i3Q+T+4JjwETwdFP3z5isrvY+Ro4uCJIzK0c53C5VWe+of12CBP6ozi3ulGwz6TZ3VtJkYucjbXr/fUdN0c/hXMqMZUmRThOJs+nvlm9WXLIiYscn/gxGJZXz23O0NWMyv3XdUBgm9rIyhZxMK/Gi5Tlr/K6q7bwHRIzcjXmzWpy1roZt+2jLHKwbY3HSdkollsc4Zu6k7hzTIHQxEytutn08grYKUiEbq/5JRPXmZasIVHgh0Gz6rSUPc7p4P8xnTK03cVyTg9p9FT5T2unpOnGvT0LukpQ+tk6qphH7iWQiAyzkoTS9QUAPjgn02NHcGtQAiyQnTUAWSw404CGy//NhRZTsGQfsR/hK617PUOb7r+XeE4i0B69eFKWJ54XGsucAtG9jlbYcyMFa9tOLflPGs0wHN1KZ7exP6l9W4n9CON+T4SOZ20vq4pEERNLRlCHKpmyjpVyNix9gOhS65IJoOwwGB4WaXDJ+bDl9+RrSf0B/n0qL0MQ+ZxFLientUp/7o54ip430rUsbWhBeOFbwxb
 TaBRzouJ
 GwU56OYjmF9OE+DV2WeeTicYJsZMJSp6yT9ho3AdcYLrUz5etJflnW/24lpKh4KzE8bA5e09y7v+hU/e82pBkMq2Obc4mmBYi36bbI61xgdoFAX6F2cnYQWHGUOup9ZeolTcSQy3uuq34BKy6xDXEx8VgDUOawy+Um/7TI/gDBPUQnp1MMpzx6d+t5DZ0ufr2B171QKgXaAG8P1xS3Iws1qrLuhd0keGtSMFClb3+Ph7x9q9j9pM/jZu0YWO0IuwazIOlvPXw60HUo2oOE8fLoAcksm8gtA8fLtUw+ACA8SkdsWGlJenQOaS4uS6Hj7ZjSMQ2thUE8DY7YmEVAIRvNSQ9CBCqGeVrKj2/gCULnPYivrltINqIGnZVU1d3qcSkq0RlW7HQo5eJLLKihXDfwH6S5XSBpnI2qDWUijVUE4LALzJxrZ13H+1WQLEEo6w5JhNxcZCzJXIRFkwosXuMKmQV+mIO8540jStiXd3GTWfCXqQzBxDaSu2HRiRcjhOSLuZMvqFP90VR9BqvE6XSoQolb0IFTrw7fiBf
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


