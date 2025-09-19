Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FA20CAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 12:40:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99AE48E0007; Fri, 19 Sep 2025 08:40:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FE4C8E0001; Fri, 19 Sep 2025 08:40:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 777918E0007; Fri, 19 Sep 2025 08:40:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C8468E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 08:40:54 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EB4DE11AB17
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 12:40:53 +0000 (UTC)
X-FDA: 83905959186.06.3CF9669
Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	by imf10.hostedemail.com (Postfix) with ESMTP id EBA85C0005
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 12:40:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="g YaoqNU";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=oBRMyPX6;
	spf=pass (imf10.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758285652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TC0qa4dJ8ZfxpD8eOHAvcq6Kh4/gpC+GYroIRc1A+zs=;
	b=oateDWh7/07v15qskNoEA4+BUfqEdaHTTs5FjR9/61lMXRWL+TE8cZD+qlr1dWNQrss9tk
	lBGMlAl3SDEyBopoBtp177ZFF6A03hBzASKB4+6KYefs9aeJPYXMHMKhTT4KtNcxReWhya
	WTmGtxllLjF+0dDXJRczMsSXvfeBWok=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758285652; a=rsa-sha256;
	cv=none;
	b=pe+LVztcnOWFP4j1wO+nJmyC6qwUs2t1feLX2wmZucwNZDfI/8NJvdqkcbG2uuleHkkSbR
	ZJ5kY7tGYBn+nCHx0PujqnUxRzvytvRsxptoZ8zZ0y2wXjbcUSnLwZ1RHGbkTZc4SuSRN5
	pnr9GlabhKwupO+t+LeBgUWYNhOxMAc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="g YaoqNU";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=oBRMyPX6;
	spf=pass (imf10.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id 63487EC02D6;
	Fri, 19 Sep 2025 08:40:51 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Fri, 19 Sep 2025 08:40:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1758285651; x=
	1758372051; bh=TC0qa4dJ8ZfxpD8eOHAvcq6Kh4/gpC+GYroIRc1A+zs=; b=g
	YaoqNUWaKHhvv3Ed4xHBXRktxSLULfs/iAAuYrd7j55EZwLmi18d89+j4kySwA12
	5SyZ2uYXjdwz3FmJ82Kk4p3w2wCOYWDmriHFwCmlw88SQYiMNg73I3OUH5FsYGKo
	4qxeC+AqeN71HV3IX9QR7a0wyomCVQhvXau8Gu5fldftzhhA6CetYZelZH8BPMGq
	EBIYmWRo7FDIkuy8YcbteuqPik/hKtWxRdlsqyYUQ5fNRkfn6uW2wB8K4RWowICL
	9WJTQUpVnMwtHUz71tcKCab4m/huYVrtpsMV8gX9HISY15uJj+C+rfv0sCire3yv
	oiZy9DUWJOjm7E8AwETOQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1758285651; x=1758372051; bh=T
	C0qa4dJ8ZfxpD8eOHAvcq6Kh4/gpC+GYroIRc1A+zs=; b=oBRMyPX6XhIiUnMzG
	jhA/GKeWruN58gwnj9eQuLD1ahHUAjCToZnr7lsMkryuiYuOpTuc9m1Fq+WwJa66
	W2cj6gXLpeu7xZofG855foOYmB0A6U8K8JfoAycT77K2kRM6Go1BJtF3nF7BwbNb
	VKGPFVhKqORsZS2Q9HVK6JTfeH8ahXLvp5vR3WDi7YDdAKruMYWLUC4M/8EWt/2m
	/c8bJZkh2BeKd3FwPtK+ox3Vd2Qg6rDhK23e3j29qceVo3pvPArS9yEljfsqnW7F
	Hmx/b5TA/PrQPyLNmizITnISEmUhEcTrCaodCVpfFnx8oiUscKm8DZ2/ORunpIFc
	kTCKQ==
X-ME-Sender: <xms:Uk_NaLx12g527lLRr8ab-q6rf-lKXdZuTxxXWpfNE8yPF5UW2YMfKA>
    <xme:Uk_NaEyl_Oy6W_x6mvM0J1N73IRP2w7r3qUeXqsQaqGjZiytZj_B76Vz_IqMQHLuv
    Gxk60CB3zfLDyDMLSg>
X-ME-Received: <xmr:Uk_NaC-CylDn64zzxcQxRKKQdlEkIt3fdkL46R-qcdfIhZoKbryy27MuFoJ86A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdegledvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeegveehtdfgvdfhudegffeuuddvgeevjefhveevgefhvdevieevteei
    vdehjefhjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepudek
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouh
    hnuggrthhiohhnrdhorhhgpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrdgtohhm
    pdhrtghpthhtohephhhughhhugesghhoohhglhgvrdgtohhmpdhrtghpthhtohepfihilh
    hlhiesihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehlohhrvghniihordhsthho
    rghkvghssehorhgrtghlvgdrtghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtth
    esohhrrggtlhgvrdgtohhmpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgiipdhr
    tghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehsuhhrvghnsg
    esghhoohhglhgvrdgtohhm
X-ME-Proxy: <xmx:Uk_NaM9aQynDmY3IwdeGcxb53N8zxhLiirYpR6A7lyklttLAT8VDOw>
    <xmx:Uk_NaNc_QOusRX8iTHqFu5nOg3grSXPV-BxstZC-g7kNgPMDWlHE7Q>
    <xmx:Uk_NaAt4iXraghTT5OqP1wQbj7wIJJN16LGeS8VbH_FQwu4cwCuUAg>
    <xmx:Uk_NaO2VoEST3kgdDy3gJLyoDqyy8mThO4_NNydG4kpeJreF4L8-OA>
    <xmx:U0_NaA4E8_qKm_qZyNl8qUs8iUVmPJ9bPMLHUl2T310RpggJiqjCgrIZ>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 19 Sep 2025 08:40:50 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Matthew Wilcox <willy@infradead.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv2 4/5] mm/fault: Try to map the entire file folio in finish_fault()
Date: Fri, 19 Sep 2025 13:40:35 +0100
Message-ID: <20250919124036.455709-5-kirill@shutemov.name>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250919124036.455709-1-kirill@shutemov.name>
References: <20250919124036.455709-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EBA85C0005
X-Stat-Signature: 7tfw3uht139jg1ztjythccn1f9u9mqnk
X-Rspam-User: 
X-HE-Tag: 1758285651-109492
X-HE-Meta: U2FsdGVkX19UIS/DldsjK7g0XZbdtBWAWykzuqOFS6X70cUZqW4sJL8S0VBXTqaqaVHI5GkvbR2RTN3+MlPaFQ8C2RsNrpzwykTsfUrebfNVD/dBn7dXBEIvARA+j9r6sGooaiRhZdE6R/IomNVkxdKTQ2+xtK5J1tb+Vk1lS2qrc6RE7HLbCn8PGSCMu5xhXfeEFzHcSBoXdgrBtc1PzhfHeLxRobl6u6kAR1bzknarfHpypoLCP+9eZ+Jb9yLR1HFXG6ggaagqMNIQj9mYFK0wnIcx9wc/JWKRuJg39ufc/T5RZtgjhSw/96gr+fBWt5ycStxz47w5paAXD7R8KFC3430l6QoQfwTm2Picvyd0leKiA3QY7cvGdi6+CK8Ui3uFM8dLHjdia73WxQDQbAHR5b0XLTelea8hepMZJyIkfKcPiUwBpDOK49V0LapHbqRxd4PMQQLNCDuDh2OBPaYHf4+//pCF440xeQzMg/soe1C37XYv+XW7LemxFEbewoSkmXi+eqU3CDYnytCHVjdCV5Ly0Puob9K2anT6J7yc+mDzK1/5uyFYqlh66MTNwsVpaLxS3voUakeeBR5H0731VXMVOOd6yrnLCkVPJoF3aFdsT0gBEV5JJOhk+yx1giHOsDkBXkZLbFFCFx0bm1f8n/nHtTiBW/KLgXtPwz+tOyzRk0DA9mmxLbCbsBxWzULyFRgLIpepfSkA0xoP69vK915nUS7HgtIQy3TewwJJKSigGp++bAzhH0+jQizNtO/yY3oz06bjSJB6fs/yz7VDVO2rl8J1KNctLn/9KbZbxLslVcAoviw2DM0JABJ9KgwXk6co/8fpJYoTHifgOG1eMGqtuzFUafUUDwDmUMM1Dyq8c9fAKR/JbTWinNyr047TF+6cGdhyaIqc8F9KNHrUB6XDpENvLlwqo4TYv7WRZ3iW7Q255RoepsepDto23KVwYxOhndjti0sIYsd
 LiH9llur
 10mQBNa/fQjuURXhm1SKntBQI4EuzWYH31GCPpppoWcfqnR+seOKULW5w1OAXvqu2kD4mJmxPstBNDsVMQsDtlksnRQfEwPlIxNUhESNtQ4FPwt7qmM/A25+zepGvpiJcRhfmQ5M5QP0Kc+7udJ4LWcV/Uz38/fG6dBl2oWJfO7WalLxlYyNtBy9Z2DL0lb8YoAFO2fn3jtrlwTQtBhg48GU5U+vKwlUgF3jMwslzRArvx/T+7PkWJ15PShs+EIMy2pS15zX5GUFZm81Ud54075orfXLySdNoMlW1RIN5rLjVEtp15rGM0X5IDGaRSMwFygReLC83DxDtLukwI3pLlT/zfAfULDAj5G9a+FO/shZ+LyYYW2gkWnXcz8EagbQslWONJK34KCizSiujs+7raszLj7dCf6R2emyQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

The finish_fault() function uses per-page fault for file folios. This
only occurs for file folios smaller than PMD_SIZE.

The comment suggests that this approach prevents RSS inflation.
However, it only prevents RSS accounting. The folio is still mapped to
the process, and the fact that it is mapped by a single PTE does not
affect memory pressure. Additionally, the kernel's ability to map
large folios as PMD if they are large enough does not support this
argument.

When possible, map large folios in one shot. This reduces the number of
minor page faults and allows for TLB coalescing.

Mapping large folios at once will allow the rmap code to mlock it on
add, as it will recognize that it is fully mapped and mlocking is safe.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 mm/memory.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 0ba4f6b71847..812a7d9f6531 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5386,13 +5386,8 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
 
 	nr_pages = folio_nr_pages(folio);
 
-	/*
-	 * Using per-page fault to maintain the uffd semantics, and same
-	 * approach also applies to non shmem/tmpfs faults to avoid
-	 * inflating the RSS of the process.
-	 */
-	if (!vma_is_shmem(vma) || unlikely(userfaultfd_armed(vma)) ||
-	    unlikely(needs_fallback)) {
+	/* Using per-page fault to maintain the uffd semantics */
+	if (unlikely(userfaultfd_armed(vma)) || unlikely(needs_fallback)) {
 		nr_pages = 1;
 	} else if (nr_pages > 1) {
 		pgoff_t idx = folio_page_idx(folio, page);
-- 
2.50.1


