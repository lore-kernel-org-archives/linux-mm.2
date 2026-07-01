Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E64E8C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 05:35:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD6826B00A9; Wed,  1 Jul 2026 01:35:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B86BA6B00AB; Wed,  1 Jul 2026 01:35:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9CE16B00AC; Wed,  1 Jul 2026 01:35:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 88C236B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:35:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0439C1C18F4
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:35:39 +0000 (UTC)
X-FDA: 84939095640.05.4504913
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3C40D140002
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:35:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=WNy9FH8x;
	spf=pass (imf23.hostedemail.com: domain of guanwentao@uniontech.com designates 18.194.254.142 as permitted sender) smtp.mailfrom=guanwentao@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782884138;
	b=cf25KlogWwomuHyV1K7KKMheQ8d84dzw4nd5225X+BfMTw5T9++clTxED6i6vq75V5pEn2
	JEblMrZ0i/Y/fwA6DOSLYhCyn8jhYUoB4Fs2U9534FNaV3v/ngjaOTQlEMZw/8pi6OXf8y
	NRJzcoMsZmSeLEjF/X6skKyFuq5nVs4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782884138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dcEZBfhi/lVczIlH9+rq8JLNvaqYqBvl5cH/6FKnFvU=;
	b=KIDVxWyMzNYO7gjofCufmVQSq4XaRpyVcAeneEW4oMSldHH3tScWWvLinwffNPxdG5BEzs
	/YQ+de6lnOehT7zWNcJnlWKUh3FS2ohPUL28CWJ14knMHu9K5gWMENVrdgloFInJ2zYFLw
	lZqjFgUx+PBwu9ysFainnVTheirk/As=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=WNy9FH8x;
	spf=pass (imf23.hostedemail.com: domain of guanwentao@uniontech.com designates 18.194.254.142 as permitted sender) smtp.mailfrom=guanwentao@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1782884116;
	bh=dcEZBfhi/lVczIlH9+rq8JLNvaqYqBvl5cH/6FKnFvU=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=WNy9FH8xeat6joSpspA7CvBSrOk0hkxy4mrs6vYKRCRFXSenH4gbnNHThuRwodifJ
	 bCrDnTRN9Xc2uw0FIcydPbfAz1ToOx7qhoEPCNBc5DAv1MrmXjM/P0Kwcsl88bjicn
	 djBXJLD9OBLWnCpfwcbWbL/2EknKaiO5lHZVflD8=
X-QQ-mid: esmtpgz10t1782884109ta4ae9f15
X-QQ-Originating-IP: bSSLJF3+nkFUZF09WlUg+1CG3vnlErsn/WOeq+KOQuU=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 01 Jul 2026 13:35:08 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 451476006295476125
EX-QQ-RecipientCnt: 8
From: Wentao Guan <guanwentao@uniontech.com>
To: akpm@linux-foundation.org,
	muchun.song@linux.dev
Cc: david@kernel.org,
	guanwentao@uniontech.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	osalvador@suse.de,
	mm-commits@vger.kernel.org
Subject: [PATCH v2] mm/hugetlb: avoid unnecessary TLB flush for empty folio list in vmemmap optimize
Date: Wed,  1 Jul 2026 13:34:23 +0800
Message-Id: <20260701053422.3664813-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260630231657.4A6E41F000E9@smtp.kernel.org>
References: <20260630231657.4A6E41F000E9@smtp.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: MUT6q7+aWLkM0L5f+qiXVJGCuGuAR+Hmg/OWm6/au65U2fdGDNBjPJII
	ZUNsK3p+/Nahe+kcR5mS4nrIGP502oeqKxVo7S9TTHtjvUF/9uuQ/f9VJBsl+qIdY1tNqPd
	a3G/hjiCVBl8TRYWNA52CP4mEQR867BvvmYrkTkK4BW6LmUdqCmZlQY0jNEXeBOj71+S/9P
	ERIRoGVbtq8Maf10R2sfWqnciZ2JoXG2zvYBJ4KreS62d6rLgx/Mgq52jfTECBeAzpQc7+i
	UdJQu6zfWt9F5GekjB5Sq9J+BBATw4CNHByS43/TqMe6NKh3X4dFSOvpVnn2rA2zFBP7qwL
	E5lUCKOp7QVnPZ4yk5ILFvVGB5ohkUXDoIpHsdcjsSwaCL0bmMjtT4lm3674ezo2gqmax35
	XjEy2WNmNElVPcj3ydMVoh4QT3lJ07BCRMUzufYzoNwIVS1KI764Xzl4BBPD9rbFHGvcap2
	pj/mUvzKk14LnK45l6vaCRCuZFajcKqQDv3Ise/eG8oIIc/IBoIpBIiln3WMOrON6AqjLTh
	m+5mn+CSh/tWeHrppeZLVOlofRhbdELMH+Ll00GPFVKkBzm0xcrwB6gugrJBbPMHcKWz3y0
	3/hmIg6xG3+6yIxxQrYRlGLhrL/JnpN+L48OdU6uCS2pYGeg2DEy4BG0dQyUiIXkYcGdRM3
	SMcDNz42uBt3EfpFGWedVdKHd+m+JJcHcNeK81QczEXIX6odRRxEnlY//VJbwAmgUbRmMYf
	tjwN8yOC5mmrt/+1YRHKver5IJbWP3w8H6azv8G946iVSmQ8Dwp+aZJAGXoU3L3SANkTtSK
	AxADHR6Zn3Y3QZWBnQtu7foL+VgYLvuVsiRKTUjis4ZwoT69mzr65guXi62HJ9dzEeO6Ufs
	UQX0ydu1tVHrK64VuAmJpJx0LFq9taXDsdiBEw+whWn6wmyMO9gpbwSdu1DRnMAD1ol9+5f
	p9EVp0qGlFVZsLpaAzPSVzcHi+nRXmI0F0DiMEFF4o9w9hpzQk/BUd4whrAsEHYEacYIi9u
	ZbR96HBUUF0WAT6gA1tIj81IG1LBYtC68ncwuR39C4iSrukqs5whQvLJh4DjMH/02L3OmVq
	tX6lX8BF9IE6p++TvjLitj7fGpAJdfipiyk2RWQRB9/o7awVcS8ANs=
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3C40D140002
X-Stat-Signature: 68tubpopxznyjdtc6s6njs4rar613dt5
X-HE-Tag: 1782884135-56135
X-HE-Meta: U2FsdGVkX19qpgxqEFaPrlree7lQbSoDT+tPsL3A8EOTEVEBP9/gtgp9HjHW51g/21Tr77BsFeZUKJ4LFo85b0uMWaEWtjMoc3ze4OrDU54HpOMGB9mI6+280NaejUxcWKK/sDxtbt2nQ4pMzIC2EC5jjTKDd580TBV+yi5YeMUT3rvjZjULgjy6kDfB7LS2Uf6jFVMH6Eub/8idr7+nME+LbFb4CSETE9Od7L1tNcvPhE0nWZ9t4e6YY+/BRO5RDxFhRROWg5qGuOZ2TzeauZ+9WB8kRsmGYvJZF7FMFq8j6SbUekdfxXy1GTLXUUlMwAKZ0L6hb0jiwqErmz+GxNNV0F6pWa20SzxGfOrywB6b62FLQRs0DnsJtJ/NlrVTp7NvlayfHF2AFOrSDwahkiV3xgs97dtprgkrqJbrZnJWiTRWhJAJZ8xKBH5APqLz6qXmlaN9MxH5uOyOGWecR6mO6BBSnrtpXRJI86rOMfS6zIwvHL0D0BgbZ6s1C39PaRQ6d5EvedgKnzrVQe5URDahbobY1YGO/q8oiL6ZprwvSuXhe6NrxiMAskMqLZe+bCXiCn6zD28kXqBAhq5ZXK/Ew6zBpqP2Kas0j5btCx/rD+CU6uFMltZdI6c95pH2UZci5nqvfvbg0NOUU/FgxqcTABbONGjfSKWGy4LmZK4MFnAzIL60XJS36/iOG/a3YPHpmC2qF9alE1SE+hYjkv4zYf3gyifEDWMylhb3r75yvoLc/QXxSanYac8u/w3uaqwdoBl4ztQLj3D9o0Xy+x4VIPlnj2tsO+gwqcKo8OpfoKhRYDWFlGEdEJX2rRjasniMl9Z5l6dhx78n8mB3VH9XBLj1wSUCTRV+/nXw5VVnlM8wqRGAfM62qMaGxgTZEpK4hVdRkt+nNesoKnpcwXL0WqY9y9/ztRu/KqDoAbJ1KxDJmkYa0E6bk8NmDvnU20vCGUZD/a48keJyaX4
 rAiXqoNH
 MaGeEJg99Z58E2G9yYbzozLCAYQy+ATxcOwd8rk/oTWfNqPPioiogRsnW2GhH9TXzH8lMrhW+ZmlR+JJcMlm8WC8LA4cI6R2OkAXYRw9Yw2e3u3t4NppE4J7R9v4ls509L16QK6bp/fMMRaquDyvmVWdX8uEM1b4pVvHH9vDw8A5AAhjqyAipWmdT4xYsnat/p3CTW0MGG3WViNHEY+gGHy2TyHq2/OVnQiKtIsezRuCPc3KlU/MOFocFO9SZGgepRZ1aqeTsoFTV1WU/PwI+ZVv5hAuC52+EMPQxSzn1fTFARTZPZRp7hinZk8TuKbWta/8ESO91Nu/6gSi/FvuhefXks4Q6vRp4A68YY4P8CLMc4M4c+yD1fABfvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since 79359d6d24df ("hugetlb: perform vmemmap optimization on a list of pages")
__hugetlb_vmemmap_optimize_folios() unconditionally issues a final
flush_tlb_all() in its out path.  However, a TLB flush must be paired
with an actual page table modification.

When the input folio list is empty, neither PMD splitting nor PTE
remapping takes place, so no page tables are modified and the flush is
pure overhead.  An empty list is reached in common paths such as
gather_bootmem_prealloc_node() on nodes without bootmem gigantic pages,
hugetlb_pages_alloc_boot_node() when no pages were allocated, and
runtime allocation failure paths in set_max_huge_pages().

Add an early return for empty lists.  This restores the basic invariant
that TLB flushes are only issued when page tables have been modified,
and it also makes the NULL hstate passed by gather_bootmem_prealloc_node()
on an empty list harmless.

Assisted-by: kimi-cli:kimi-k2.7 code
Assisted-by: Github Copilot:gpt-5.2 #Reported-by
Link: https://lore.kernel.org/20260630113857.3319612-1-guanwentao@uniontech.com
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
---
changelog v2:
add reviewed-by and link to v1, and convert fixes to first line note.
---
---
 mm/hugetlb_vmemmap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 133b46dfb09f5..d45d5355d1af1 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -624,6 +624,9 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 	LIST_HEAD(vmemmap_pages);
 	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH;
 
+	if (list_empty(folio_list))
+		return;
+
 	nr_to_optimize = 0;
 	list_for_each_entry(folio, folio_list, lru) {
 		int ret;
-- 
2.30.2


