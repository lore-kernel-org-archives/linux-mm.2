Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4499CA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 19:35:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7C108E0102; Tue, 26 Aug 2025 15:35:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2CB48E00FB; Tue, 26 Aug 2025 15:35:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C69B28E0102; Tue, 26 Aug 2025 15:35:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B46558E00FB
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:35:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 81A2613914B
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:35:13 +0000 (UTC)
X-FDA: 83819912106.14.B6A28E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id BCE9940006
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:35:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf04.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756236912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FrT6fWaydhPGhOboMRkcmdWPYPAgiXGPSbIYcSJKONM=;
	b=NQ9GteQVCQOUD1ESjtzl37f3AJxI1SKjn2pf27B/B7NFDyxqIUO/KtzBcn6WnUyNBURcLT
	tpTYyGEMijwUQM5QchAWAdAehZwfRUhgC50jQaQcmHawmTe4aGhiBaFYkHVssDioe3HAaQ
	B4JK6rUbbDcLQd7sUzUxsL6eLLJcbI8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf04.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756236912; a=rsa-sha256;
	cv=none;
	b=hW54CN8CmtgiJjg34eXTiw8CXMoURjOcpAbRKgDun+4RbhPkpAbOi/KvnWznkMY4wwuVrt
	Zuj1eivfl/CzpYjOs19/u+NcptioCzDMBWjXwWt3jJxs7jYwUuo3HSr6BPaJWNklLvxrQx
	VbvUsoOGdsjhyajv0Pj5z/lqFwf2yN8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 68941437BD;
	Tue, 26 Aug 2025 19:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D065C4CEF1;
	Tue, 26 Aug 2025 19:34:57 +0000 (UTC)
Date: Tue, 26 Aug 2025 20:35:00 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: sohil.mehta@intel.com, baohua@kernel.org, david@redhat.com,
	kbingham@kernel.org, weixugc@google.com, Liam.Howlett@oracle.com,
	alexandre.chartre@oracle.com, kas@kernel.org, mark.rutland@arm.com,
	trintaeoitogc@gmail.com, axelrasmussen@google.com,
	yuanchu@google.com, joey.gouly@arm.com, samitolvanen@google.com,
	joel.granados@kernel.org, graf@amazon.com,
	vincenzo.frascino@arm.com, kees@kernel.org, ardb@kernel.org,
	thiago.bauermann@linaro.org, glider@google.com, thuth@redhat.com,
	kuan-ying.lee@canonical.com, pasha.tatashin@soleen.com,
	nick.desaulniers+lkml@gmail.com, vbabka@suse.cz,
	kaleshsingh@google.com, justinstitt@google.com,
	alexander.shishkin@linux.intel.com, samuel.holland@sifive.com,
	dave.hansen@linux.intel.com, corbet@lwn.net, xin@zytor.com,
	dvyukov@google.com, tglx@linutronix.de,
	scott@os.amperecomputing.com, jason.andryuk@amd.com,
	morbo@google.com, nathan@kernel.org, lorenzo.stoakes@oracle.com,
	mingo@redhat.com, brgerst@gmail.com, kristina.martsenko@arm.com,
	bigeasy@linutronix.de, luto@kernel.org, jgross@suse.com,
	jpoimboe@kernel.org, urezki@gmail.com, mhocko@suse.com,
	ada.coupriediaz@arm.com, hpa@zytor.com, leitao@debian.org,
	peterz@infradead.org, wangkefeng.wang@huawei.com, surenb@google.com,
	ziy@nvidia.com, smostafa@google.com, ryabinin.a.a@gmail.com,
	ubizjak@gmail.com, jbohac@suse.cz, broonie@kernel.org,
	akpm@linux-foundation.org, guoweikang.kernel@gmail.com,
	rppt@kernel.org, pcc@google.com, jan.kiszka@siemens.com,
	nicolas.schier@linux.dev, will@kernel.org, andreyknvl@gmail.com,
	jhubbard@nvidia.com, bp@alien8.de, x86@kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev,
	linux-kbuild@vger.kernel.org, kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 14/19] arm64: Unify software tag-based KASAN inline
 recovery path
Message-ID: <aK4MZGzTvJ8bBQvn@arm.com>
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
 <eb073b008b547cf87722390cc94fe6e9d21c514e.1756151769.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb073b008b547cf87722390cc94fe6e9d21c514e.1756151769.git.maciej.wieczor-retman@intel.com>
X-Stat-Signature: obdgpxqyyosjggqa591b1riefw5mjhxm
X-Rspam-User: 
X-Rspamd-Queue-Id: BCE9940006
X-Rspamd-Server: rspam05
X-HE-Tag: 1756236911-912173
X-HE-Meta: U2FsdGVkX1+twvCXSF3oruXdVQUi5i+kKKFKXKPPxDw9waJmOSGQN5f0S4z/JuT7oI3q8DKT4OfyRZB7KBIXqSyCEInaK2AiE2DgazIbGWKvz1ES7wh4zP0lGe5CzczCAIrUo8f1IR79iSCwLcWCvgx8YayHUORKKb6uG4R8mMt1L4+bE+ldtisrX+NdRPUF9OC/nc4x3figMLm5TyvcrigwvLOpCwVwKCT+CDhoLyxKzUm/0f81295nELP7YCVumJvB8PuaL532ErjlSF8F5gBuknPjJhPlUrlSk1cex12EOTfdKhMUlNTkxQaUqP/BVHufmALjEe3Sbsb77ktJANAfknTQtsxA8rj2DOuoCYgew/+5DIyJ3j5wdhThMqaVK5Pq6b4NuYPIe7kNSBoahqcbFH8baBWYJdmN8+0+GzDVYmHcCLIVBp/YPW+jTOoOMwMPufIcwf9zteiHd7LPmVplWuB3rOjg/qpSFNKStZHWX+CoYPpqh/b6nM+lGcUpNi54mm4HeKL38VdsOcbMvXjrQAW4GeRtkSJ0HDpRTBERQjZSJsW4xctpIARCCBVz8h9Xyz4OLIOki7tqrwJtpWsJdT/4pbPjHLVOmfayZqvRELN9F15yPIR38PURvctszQsbh/ZXlL2Af0t98q2z4/ZpxUg6dnv94oQtZ0391SG/3pyiaz8vqqnG+0v7kGY1y9RAvSdxkop19ZP1MFJJrGtiqseHi8BfMjCJ8WLP9NZPysbhchrVR1zNCzxU2MtDbt3A7mMaTIbFyTquFNAhprly+md/Sx7m9jADXns06D/DLps8MOyKpUvpcZOS0NQwbVZRjtYUZQYYUO5Jt/M9cCa1PrLn+D0vnJ5EAWcgYPFDkGdVndjH/CPieC1EZPfVGMjFAfDklo2zXB7r2UWAk1srD+znrcP7qNypntNt8hFR1PS1Qg3oNdpiHnhVJe/UTF1j6PW3pKi7nM/pZBB
 QxbGiC2d
 sPSTyKAEJd8UNVxvD6d0CvYGrpHmhJE04VnLQet5iwTFIbu9HSWhnB2p6KEYxEARN2S0XE/gtCSAz0xLuS3S/nN8vUequwZv/TKYB/7BBTuob9k6r56jX1tX8btGs88CfUsjEtWBU2jxADi/2hQddPdBcaDgX1tfQIU18WQKwl67pyZRMCTK0v22AuBF6AbaNS3DMLnhW4V9QorZIe9gKbHHDrCsgic3HBDjj+N8vOiYecBtCuz2A21d/jrM08r8dbiQQ7OqG0NEVOMPQk9l2NLdAQsJRCeJcrDvq5CvAwvMYSSrMFSyeOiNMsOentbNKSeycRFrVKSsmZpRxJ/NMZnQhvczM3W3uPP9LiKh55GumPlQ+HQxbkrFu0dITmeTaOvxCd0F7oHUfvt5yUxAmf/iQBACqcD3Q6eE1DfBK0yaeMxzc3x4dsjKQBbjafXgo+nVCZNo9X6yshuqt5ntKt0qB3ZoDxJ7Mjnf9fituyYqUsOecKRVgDayVHIHhHgCNJqPe7wvIjh7pxC9lIDch4d9JDQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 25, 2025 at 10:24:39PM +0200, Maciej Wieczor-Retman wrote:
> To avoid having a copy of a long comment explaining the intricacies of
> the inline KASAN recovery system and issues for every architecture that
> uses the software tag-based mode, a unified kasan_inline_recover()
> function was added.
> 
> Use kasan_inline_recover() in the kasan brk handler to cleanup the long
> comment, that's kept in the non-arch KASAN code.
> 
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

