Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE667C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 12:51:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BEEA6B0093; Tue,  8 Sep 2026 08:51:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 097806B0095; Tue,  8 Sep 2026 08:51:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E531B6B009D; Tue,  8 Sep 2026 08:51:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C219B6B0093
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:51:18 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5C78EA067F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:51:18 +0000 (UTC)
X-FDA: 85190580636.16.3918166
Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5851C1A0007
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:51:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="o bd9qnw";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="m7jwhF/m";
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788871876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iwxMgzeRWfdCSv6NSO8Zrqvha9AMlvjv8LhyEme61lQ=;
	b=08gMSUwsVCHLvJzfTsdRdAo0oK7R0yVMIIO2BE4+jsHdNgUimbcfW6DUlY48XJkB1c22Xp
	HxUmPrWspTahwy9FVWKEjy+fBsZ5MhXiEFsgCxWeiJvj90gi70J2EiZxgDPs3fKLcB0vNp
	xEEljVorYVmnfnW+Q1H6bNR9cwW9DC8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="o bd9qnw";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="m7jwhF/m";
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788871876;
	b=Ft9sRCzDOmGJZr60M7D2y7Rnp7OJjbjNR2zHxXXElWa6is6HcWZZAGxjKEDOFBuypeR1uM
	6Ysf3K6CH+GPIXma+xB2LnDBNLFD/Z+hhx+deb5KOGL6LPrQwYGvruXCGs7goMidhcWQz1
	6c080f8XwzbB4rQNRBkOB6OmMevH3aQ=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id D796C14000A1;
	Tue,  8 Sep 2026 08:51:15 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Tue, 08 Sep 2026 08:51:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788871875; x=
	1788958275; bh=iwxMgzeRWfdCSv6NSO8Zrqvha9AMlvjv8LhyEme61lQ=; b=o
	bd9qnwGe0nuhKHPDfRr4hBq3btiviPT7kiJwKHW/Na3lP4/RAhwuiSwAhZhH5sCi
	3P4Zaj+i177qex+EhoCwv0RaOaOa1ZO/BqUfTapihfLpk9n9ZTP56ueGQdv2gQSy
	5pUM57wp3w+dCmBwPWzRAZBnSMO4wnoXzZUUPchFrIIVln7apBrPU9x708iZZPxX
	lp6T2Y22OR68pw1dOOyWQE2TeRZW9riMXuZkeSzvBRgOkgrK+BsM+AYmkuzbSI3n
	4EmLe+2L/QI6NvEKeaosO4bMCdSIPBeABIaBMrt+YLaGrmfxvd0R/ZiF4KFUeeST
	j/rUzaQNGO0+FuvofNRMA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1788871875; x=1788958275; bh=i
	wxMgzeRWfdCSv6NSO8Zrqvha9AMlvjv8LhyEme61lQ=; b=m7jwhF/mSf/e8bYVw
	p3U8nCNtyIsPudps1FYdop7nvFYLnCMU/RwarpMCdvYuAztIh7GGeYzyPRbunifY
	1RweJVoMAcr88IzxF5bI4Qv2RDKefXaRFTJ7MLuWn6B+fjRL+zvrL0dcGTSjbG28
	yVW6w/ckbttMUK2V9TRl42YwtyN/Df/BJvPi6Z1TuS867/30eSS0fT3ji2bRr/gw
	hss0uNAhgvkE8pLpGNlOm+E0ueNmldZWmgIhwqVl3TNxYyA7IbKB+SRtc6FaZM2Y
	4SFvxB1D8mhE0fA0aRFnQIK+y4Nma2+UTujrpjOt2c0hlHspT1rzgysrbU4fEb54
	FvAwQ==
X-ME-Sender: <xms:wwSgapTRoE1N4N1J76ulCElSXI9QHhbQVGxOpSUbSqCDthKJ9Qb8qA>
    <xme:wwSgarLMeIDL3MVkaIimjvlrl7eZ0tlfzQ44AImJucKSnMOXkEhIU4RCWWLLE2Syn
    sWsq6eM_ZvWpJ2xpeQ_Yyxgw-X2z-lglakeqayyqbUZHDSuxX57740>
X-ME-Received: <xmr:wwSgahBsM3YLcFubpUpFsSILvHY9seBmg-VQ7OFCuJ_8EktP8xrsQrRjses>
X-ME-Proxy-Cause: dmFkZTGuvEMc9jYu2f0uyTmUF7l0J7NybVdULRlrJFmokmmiolg4yH1+7h97U05D2w+OYm
    AZhWoHmMPT2EsIB4AC7PxRFoqN+CF4x8etMK41ayTMd5Tw55ZxqvSYpb69cNUy0p/dfOGv
    05P0JRk7g5kt5eTL1k2cO9e1oUb7lrROdNyUSbigYjG7Zs/tNKx+L8+9HHw+CSw5cJpWIQ
    j2DrX13NeCZvnLN36sWkEk/U0EX1Q1izKAtzdjMuXhus4PGMhEw3kJKafKZkgCRsnWRxXR
    Wv8osDa5aTh9mnjCTFnYcP83hQ8y7tmPYrDENim+Q79mFJR5sJUGN5QsCu80CUB5y6e4dK
    Z0E9GGivkeHG4X0HLGLbvvZrC5bnJqafe3JtujJDyZU0RMBh78hGImZdsp2+xaQaiezMm1
    W/GxYA/8X81H1QVXDnrm7G9MmdnWthDp4bwQE5/Q0EdSY92qYkIEBt67B1nXGULa9l92XT
    H9EdurnNFjSVs+D0N5mfI+L0uLvVkI49ArxXJw6fWpDpyme1CL+vBTCCQ8iRE8baVUUqIG
    5Q4v7N+9OtQl4udFlDE23Stsl524Vf+c3e0rJWn2aMdBmjTlm24pCumW9GZtDQTrD2kADC
    eCu+eSd4I4se6UGU1Y5GZn8BXiAdR+e8UnPIWACsfZMNOO+zGh7eufrimloA
X-ME-Proxy: <xmx:wwSgao2UGfeBbO7a6xhbv6_qQRFrp9dphat8jjHN1QPOsS87oPuf7A>
    <xmx:wwSgaklXKLNWOjhQ5cP1m0ItR_SkQ-4ZmMBn0TNJeIZLPKpYyjgHZw>
    <xmx:wwSgalcf9I8l46X-jfpmlcT5FUcy6hDZUkjA2ezxoRVjDUPTWT5y9w>
    <xmx:wwSgahUsP5nozBw5atULOe4tqYRZYDW40OI1CC2CyNy_mkJ6CZoThg>
    <xmx:wwSgagQyrwQRyF-WTkkhrfx1VZ0CmjQtPsQnw20xlwA5GZ6EpnOpkaEN>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Sep 2026 08:51:14 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	rppt@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	usama.anjum@arm.com,
	usama.arif@linux.dev,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ziy@nvidia.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	agordeev@linux.ibm.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v5 02/19] selftests/mm: skip collapse_compound_extreme() where the PMD is too large
Date: Tue,  8 Sep 2026 13:50:48 +0100
Message-ID: <20260908125105.1510704-3-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908125105.1510704-1-kirill@shutemov.name>
References: <20260908125105.1510704-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: csz576mqjspn7c6nsa64mndmrbreotqd
X-Rspamd-Queue-Id: 5851C1A0007
X-Rspamd-Server: rspam07
X-HE-Tag: 1788871876-789704
X-HE-Meta: U2FsdGVkX18oautz9nu/4f1Ry9L3uhsET1a41JAaix2Hmg0QE1auNkHDlO/Rt+WIR3stjiSjuL+zOhELS8NxMvhJGEk6a5XezZdi0fmsGwveuU8VkvymbOylZTq3PjV6GxNlSkNeyWzAHxSIdnhsZd+ekCzZ7EZQ2XQ5D1HbXgbbTSnxpv6tVpZlPCEwJ9C2SzC60lZVwKFr5LJidWewy0I5EdZyvp9tu9cml9cFgJmPtSy7PtUU+rqdahmfo7UVvLxMvir0I3ABMjusG8iyflTqHXyVj8d6jE/7DcjFKfOqCF2s/KSkPk0VSN20IT1CLIF5Cja4DWNAN+kB6rtYERmr1KxkXg30VKD83tLpf9OPfwTC31iZGkmNUeMr2BJl5ig7u8Qk++dYlEk1OjxO6E60SX1pHMWaiinWfTd+cxJnc2QqVrxQSsPr2ymK5GKl3E3fHZStuBOA/vHdBFDZXMe4hLO5Mj4DBtOwuN8kx/BB6S0PglUaSyHjuKqbnfiNSMnUbTWdm9gsLbmKIGg67gzr03sJl67aE2AZb33+nMv0MGsX9epN/SgY0UhGCK9AGzigGDgTpA5zqIoKmmfqcfMmYm37orD1qxfbt/EJAUUyQtygYl4nR2mKsoyw2VV9OLueDFvzqc2+0yKQxSKfo8w+aqXvobfcg6/N/acITozw1k7azc+Z49kmd2yQjMlcVgahKySwX1fm/u72ni6gTMdZG5J92v5x6LZrIAggQlelQE8G3X2cVTr2KIOP1az/agZLTwXPJIaJvx+ixCWGfT5LAbwfwk2PCxIRI2BZ+sSXNDKqxPNzzksDjV/7LYWI5k3E3dODsGM8o7OsGQhouCzZrgG0zlLnWjyQXXpLV/FyY+McQZqhJoypDLj57LqhHXGHdM1VXTQ74h/WdOSdtTcs67TaCQj/wxjshr2rB+FmshUE0SmZm6F1lY38BFNNDGylF2uPTfz70lTTyZ8
 jpIzU66g
 S3gVqN201WUNmrXxCmTxa6WqJYTyQFDqO5fh7teyupfPTd3ZgtSWJ6uQrzVj9soECu9t2xV+Z3USyc3IFzMoQrV3V9eRmgjsqHz8IoXB0xRDNYWGmvSb+JEZ/B7Cg8aeenXpKFuMXb2KnKowM1o/FrEb7XDVXqO8AojHUm9B2s9Ap9m6PCusuGI/d3XugfzPDXCMiZkf8k90g+vydLS4tro3Fdq/4ozx8PjUrcA4RMNoy7JZFhBXI8B21t+yBYHk97A2Mw+2vs4VqpMzXoac3dV0mbVINIgenCp7iZ7U7LlyNO7T+E7Mv2JOgauAaXfh0BXlJ+v/qDImeC0V5AZQKJrcPV3f9bzZG8xvFbKBCQa2hTVYsPCKITBGK+a83ko2gcon0dVnNJj5ds7BztGZW6BJ8QvsMVT7g8v+cp6WK1LPLlD+cMIqqIk5RHPoxAGvCnULTbRZRCtNZMbpnPDn4NBmutUoMfxcvURVHOzQpzc42f+so6Y/3v0NERNwu9Mt9jjg6pn5oAOcu+CCBpZh2mesNngiDoZRIDMOta1J9lDtkvP8ZAMQEAFL8dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

collapse_compound_extreme() builds a PTE table full of distinct PTE-mapped
compound pages by cycling hpage_pmd_nr fault-time THPs through mremap.  It
therefore needs hpage_pmd_nr PMD-order allocations in a row.  That is fine
at a 2M PMD (4K base pages) or a 32M one (16K).  A 512M PMD -- arm64 with
64K base pages -- makes each of those an order-13 allocation, which the
allocator cannot reliably hand out even once, let alone 8192 times.

The failure is not a quiet one: the case calls ksft_exit_fail_msg(), so the
whole binary stops and every case after it is lost.

Skip the case where the PMD is larger than 32M.  The MADV_COLLAPSE cases
still cover PMD-order collapse on those configurations, and 4K and 16K
PMDs are unaffected.

Assisted-by: LLM
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index e57016bd96fb..1ca7c6978571 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -935,6 +935,16 @@ static void collapse_compound_extreme(struct collapse_context *c, struct mem_ops
 	void *p;
 	int i;
 
+	/*
+	 * This needs hpage_pmd_nr PMD-order allocations in a row, which the
+	 * allocator will not supply if the PMD is very large.
+	 */
+	if (hpage_pmd_size > (32UL << 20)) {
+		ksft_test_result_skip("%s: PMD too large for fault-time THP construction\n",
+				      __func__);
+		return;
+	}
+
 	p = ops->setup_area(1);
 	ksft_print_msg("Construct PTE page table full of different PTE-mapped compound pages\n");
 	for (i = 0; i < hpage_pmd_nr; i++) {
-- 
2.54.0


