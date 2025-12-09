Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9742DD1CDC6
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 14:44:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4A706B0005; Tue,  9 Dec 2025 09:44:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C21706B0007; Tue,  9 Dec 2025 09:44:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0FD26B0008; Tue,  9 Dec 2025 09:44:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A16586B0005
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 09:44:44 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4FCF756215
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 14:44:44 +0000 (UTC)
X-FDA: 84200204088.04.08A396E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3284D1C0004
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 14:44:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j9c7IGBo;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765291482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vbk9Fq0lsey0t1c9eLYujtKWsOp4fBKz35AXyB8rct0=;
	b=17Okobsyek6iPidVfvxqPKMoyvbfcuOS+ncVAfElgNAyvn90H8EOyQjKXc+xCLJ9z8hisQ
	8fsj4DQynhZ/cVqt/FvawkqDdbGCsCyti4Qzhnm8QGB2c1PInpWHwYbkb/iIMf9v00L30T
	3jhfHoEbphiavsPslaw6mfCaRvtGNEw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765291482; a=rsa-sha256;
	cv=none;
	b=niCL7N28os0nHYYrMTN+O0Xz7ptlUaZAX2nw/zneMxB4ykTFcTq/E/YCTbfs5H2viay28W
	Y35mdphbGpeElxEMt9jgj6bDoEKhMvzx2tqoH9x+moC+zshNN2TdlruGNwh82wpYCZ1WSj
	B491hZqE9a6mdUIEhckX58kNUlsAnCU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j9c7IGBo;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 028D843D9A;
	Tue,  9 Dec 2025 14:44:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39EE4C116B1;
	Tue,  9 Dec 2025 14:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765291480;
	bh=VTkEB67vNJl4jBEZ977996DZLecFTS+eqS0a9xgLCD8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j9c7IGBoyktX+xbTR6CzkKO2z0V0yG3/FN6rjF1acrb3W9Z2b5RSHW1aiGIPuG9h0
	 HIYOMy7HT2zD+rPBP1JAplxpvUC7XKAwiLRuxMnR12qW9L00XSNGTBPiMvIxWopAuh
	 TEn946NMSJ9J1ZYOFIXxgoZd+dInq7CjgjYqmIcgJk2IySv83in2rMKhPD1RN2j9h1
	 w8pS0PdET1KDJUI1LhK1PyoGwKTDKzAhTH/8ZhHVuNnh7qRxiyO+BuYTso9CAee8L8
	 sasCl+fa/vWL32abvKF+AV9C2qVOnFVxmzkN1MXshyxGkSYd95WQzePzpVZY4QTX6A
	 AzHiJKHR0aqyg==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 76E1CF40076;
	Tue,  9 Dec 2025 09:44:39 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Tue, 09 Dec 2025 09:44:39 -0500
X-ME-Sender: <xms:1zU4abX-QIkzYNQcD4U4EdQbb129TwqQlLkd7ckjVMoilhLCLZkrQQ>
    <xme:1zU4aaZ2fz64E__-RTs5JkkQe-Y0DE1BYbnuveUT97cyK9OYTQR-P63NgaCNrrUIq
    uSiefi1STNHgH2D0puvc5bQt2Xzwd0r_9LSwF_3GoCI3j6Uvir43Wg>
X-ME-Received: <xmr:1zU4aQU_dFNJCnokgtBwn5fwYHowBS45bQADtcm1L4G9XRGFE3dJGX4GmQsuNg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduleekgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeehieekueevudehvedtvdffkefhueefhfevtdduheehkedthfdtheejveelueffgeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopeefiedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepmhhutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopegrkhhpmh
    eslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepuggrvhhiuges
    khgvrhhnvghlrdhorhhgpdhrtghpthhtohepohhsrghlvhgrughorhesshhushgvrdguvg
    dprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepvhgsrggs
    khgrsehsuhhsvgdrtgiipdhrtghpthhtoheplhhorhgvnhiiohdrshhtohgrkhgvshesoh
    hrrggtlhgvrdgtohhmpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdrohhr
    ghdprhgtphhtthhopeiiihihsehnvhhiughirgdrtghomh
X-ME-Proxy: <xmx:1zU4aZIeu39viFsSVcaTW8Nt7q9c1y61GMBcMsZMyrxJ7RCq0QcZkQ>
    <xmx:1zU4aZ2za2rklFWt_Qi60_t3GwIakolsNeoyCGCiVRayJrhTP93VQQ>
    <xmx:1zU4aR_w5DBtp-WEbjShmjK3t7X89fnLgpoGy-JfQd1TGUZTGQl-Dg>
    <xmx:1zU4aehTisoj-UFcfX-dY3ES3hrojIZbHBmymfJPbVT2CbGD2yfVLQ>
    <xmx:1zU4aVVykaFaGBYbhB-Ox_4Np8-1g6hseOf39OEiUIvvMaKdEt9zbegx>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 9 Dec 2025 09:44:38 -0500 (EST)
Date: Tue, 9 Dec 2025 14:44:37 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Matthew Wilcox <willy@infradead.org>, Zi Yan <ziy@nvidia.com>, 
	Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, 
	Usama Arif <usamaarif642@gmail.com>, kernel-team@meta.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 00/11] mm/hugetlb: Eliminate fake head pages from vmemmap
 optimization
Message-ID: <m63ub6lxljw7m2mmc3ovbsyfurl7hp4cvx27tmwelcxxrra5m3@eva5tqcdjxtn>
References: <20251205194351.1646318-1-kas@kernel.org>
 <4F9E5F2F-4B4D-4CE2-929D-1D12B1DB44F8@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9E5F2F-4B4D-4CE2-929D-1D12B1DB44F8@linux.dev>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3284D1C0004
X-Stat-Signature: zpiqkswtne66xqr5jr6fbhcesytkxw5r
X-Rspam-User: 
X-HE-Tag: 1765291482-2876
X-HE-Meta: U2FsdGVkX19SlfH0w0hZUPbBkOKyyWiyAMkHkW8MoXFlYhjoBAgKGbG+rookPdtEsk9XFfAUfQCJ9eVlsH1l2xh789AfdLqWQnSK1XzaOJvit62l5mbt0xBLa4alANFrlmlb/BixLoyc13ixfuCShYepiP8pGDXukypMhqXCYLEfB1UWAva6HjIPXudElRKqw1qWp4QPv8zRqd5bhb/aYtnicHXHKKXndVduIgX/6VjMWUY1s7is2fezVFNAEvptwO/TAYvv7JB0o0OcajYIGEVMaW12CJihaf8r1tjg/EIj0l6TIh/QGlktxr9IBXfIgwdX5lsBVArNvfzeGLraqHn0u5gjMLnJtogxe2vgLnG/BzL66d7eotRojYcWg1QpYQofZcxsNPcKACEm2tF09mnT2SoPkWkbvNYzDHlKR6riVW6qHBHWMPdldlkQ0vbTZurkv1QpijTeCKEXgeKhKIFJVH5aQjKdPCg/bIIH/0EMM/YWZk9GbhQraSbzxELxIHeOzBhQ5SWL2ER+jbjq0mqws3Na+CvBpDpiR3vBHN7BKELzqLOW8sam71rnet9ynq0gKc5PL7TTKAAG6TBjkNq9CvXpzwHveMx02teDexAkPUgF/FSi+1JBcwh3DiVm6swfSDRWg40gsZaWuC4/h38llx1zk0ReYHR0cTP7aSsx5m93xY1Iflwpqd54t8BLh7ztEqIUNFnFFvh4geElm2gjdNMB5x+PQa9lI+53pbMHaWmZzj8N8XvfThW8VYhG/UfXAIAcjssoXU2Lcjq8pBdHnAhYVfTC7zop4AfJ/XwqmRrYOcC2QNOKNYmKPvOD+RgcXtjz+OWRPtqk0aZZ0KXxB26bmioRZ0YSDFt0f+5mAAB20LLXF8KMKpHXdVZxaCqldfwRc4/48xp+cvAiyF/rNv3wCHYDnml2IFO/MTsO5ex4KnVGWfKAt0+Bb7ZQC25Tav5aDvc7SbJBRvk
 hgVgAK5Q
 ScZxAW+u11bRChH7jy4v6oGDqyLgWgfD4uMHPMI8a17+EJsZxzYPl/W2vAPN7aGLN5W7z0IyNLU93INqRpy1wpWAUiI3cIVA/TCDPg4ZNDrqtZre8gKrDYmySPvLutPk+2AfHus9mc7WsrFjAW34kd8uYlaKmuVCrJSujWTZHWx1rP4wGem0iVr/psuDUfGgwb8vina9pYHka3qEW+o6usuPlhWTy6ffFhHXQVbY1Stom06JkgySdb/omiXATjurf66rIYqccUrbZEFU0w3rXSApFSQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 09, 2025 at 02:22:28PM +0800, Muchun Song wrote:
> The prerequisite is that the starting address of vmemmap must be aligned to
> 16MB boundaries (for 1GB huge pages). Right? We should add some checks
> somewhere to guarantee this (not compile time but at runtime like for KASLR).

I have hard time finding the right spot to put the check.

I considered something like the patch below, but it is probably too late
if we boot preallocating huge pages.

I will dig more later, but if you have any suggestions, I would
appreciate.

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 04a211a146a0..971558184587 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -886,6 +886,14 @@ static int __init hugetlb_vmemmap_init(void)
 	BUILD_BUG_ON(__NR_USED_SUBPAGE > HUGETLB_VMEMMAP_RESERVE_PAGES);
 
 	for_each_hstate(h) {
+		unsigned long size = huge_page_size(h) / sizeof(struct page);
+
+		/* vmemmap is expected to be naturally aligned to page size */
+		if (WARN_ON_ONCE(!IS_ALIGNED((unsigned long)vmemmap, size))) {
+			vmemmap_optimize_enabled = false;
+			continue;
+		}
+
 		if (hugetlb_vmemmap_optimizable(h)) {
 			register_sysctl_init("vm", hugetlb_vmemmap_sysctls);
 			break;
-- 
  Kiryl Shutsemau / Kirill A. Shutemov

