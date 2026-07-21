Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42162C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 17:19:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 385DE6B009D; Tue, 21 Jul 2026 13:18:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35D0D6B00A2; Tue, 21 Jul 2026 13:18:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 226056B00A3; Tue, 21 Jul 2026 13:18:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EFA7A6B009D
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:18:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 75C51C0253
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 17:18:58 +0000 (UTC)
X-FDA: 85013443956.26.2C451A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id C7840A0009
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 17:18:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hxoJfeET;
	spf=pass (imf15.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784654336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W5lsuJ2TK8ReKuQv41colmY0kKFrt517EXbX/U4o4CA=;
	b=KgtIlGfUAsnwNjevxX5vIHIRNci78dnGmiX2yDrpt6jBwlRtT25v4zwvBkXEznbFI/Tu/m
	0WmaYSxtj6bHYRtREsffqV0cYy4lIqhMIHNPS7U5mLWSnSms0IOHDA7hr36iU/gKTu2rW/
	vPaZKvw2Hiv+aGGk3RtUr1cRcgKMfy0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784654336;
	b=s/PrLB08+qoAHZY5mAsDn3pF+Ki0tZqIWbv/WMBa0+2dY/p7CRrHMVXpzfFCjl+tWxpfu7
	4pl7POJ39IjQyAUElL7jFEKz7bBBb8YoCBxaAZLdeTlF0C47vHNN1B1V1k9Ot/QODkHtE5
	Cpgdweqpl8HIBlsxn8mZsUtaNwJsZN0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hxoJfeET;
	spf=pass (imf15.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 024274035E;
	Tue, 21 Jul 2026 17:18:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5CC1F000E9;
	Tue, 21 Jul 2026 17:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784654335;
	bh=W5lsuJ2TK8ReKuQv41colmY0kKFrt517EXbX/U4o4CA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hxoJfeET3T526QXp00quUEwQiOevzo6VUuI3w8NS/NxwUVkTvuDLoG1eHp50Dde/9
	 /IXu72DL1bn1EWLcboCW5yYfKmHJHvFkEmiTKSD50e5FPZDLYl01J7xvScImtnjYsD
	 JjCFTV9E18oVmDRk6//jVQnQPSKBVwQkz+JZAznrV59NxrElBd+JMBafczgRMx7oLC
	 Xk+QhdT3awjgGop2C8uqzN9chBVanihxeMqzT09p6ffF6d1usfV2yA5oGV6cvQhTGg
	 ijzCa3QHEPFfay0pbdy6BGom8WqI5JNIb1VR1ldOAP+yYr9WQIG3Qp3fDWX6Fy6n4l
	 JLEjIFNb1CxiQ==
From: Will Deacon <will@kernel.org>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	david@kernel.org,
	liam@infradead.org,
	Dev Jain <dev.jain@arm.com>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	riel@surriel.com,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	kas@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	apopple@nvidia.com,
	rcampbell@nvidia.com,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	ak@linux.intel.com,
	nao.horiguchi@gmail.com,
	mel@csn.ul.ie,
	j-nomura@ce.jp.nec.com,
	pfalcato@suse.de,
	tglx@kernel.org,
	dave.hansen@intel.com,
	jpoimboe@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: Re: [PATCH v3 0/6] Fix incorrect access of hugetlb pte entries
Date: Tue, 21 Jul 2026 18:18:38 +0100
Message-ID: <178464737122.1305746.12295190523058911270.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260703114202.365553-1-dev.jain@arm.com>
References: <20260703114202.365553-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6kwyaa6abdroge4b49dda4qe98doptd8
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C7840A0009
X-HE-Tag: 1784654336-977818
X-HE-Meta: U2FsdGVkX19GayTTWHFoDDMJq/j3H3XYStmJ54RrngVvqdCQi7nhFliq3YmJblBzI4uAHZ4lOUVI6Dtix4fQgPaWcAwgvmgatFRkAI3G9pfJZpnWPtsOzJEAyBLfEQsgQDDw/iGDgU1Xnhz47foHM1Qoxy3lTdgEnKCWyEEVJzdrZWhiYtV7hhNfFcsvu/GryXVEoW7ZCtn2hc/+my5sJJ/i1sqOkDCPy5wkBMlSH1gfEBMtJ6QaxUPoJ3tDM2TShll6eBT9ucT/hxABN6Mud066luGS1bWq+rkkwxosByngN4AMCq5LqNBMWM+H7YNtKNSLgoWyWvk+PmbbKe7quqY7XMmmEDZ0/+Tce/pYI2w2WFTXMu7yEcntmURSwGW4vTXUIx8isKsnpTMnaKaj2xMWP744arLo0MzLbkAMtW5X06MPP+Jk+1rEMVi95AJmI2mBSABqt3WbIHhYqTXTlnPBXiPXLGRyWsbbNiV7dkFkSj7iBtsOLPKEl/4chh85n89dG/FBLTuETf2jvJWEMLkCDHmysELNJr9QZ8GJtPIlIAkyKqoAUSeNIkWRq+ZeF54h33E/hgLJALwetol8C6+Zo2cqVZ7vYdW9MNvVMtHZWAOP2WT7aRoFgyoD3H3mjxuLR5RxUKYRafY//B1tKiv6CD6ScmBBPqT54qFtyw/e4J1k7Ozij74hkeVXRzvJzTythLGGagrfNilZ6qC7R/Zkl1BqlXCmXAP4fT9x89Kx8S/J4dDavXI2G1BzPT8UJG/0ons0PtAggac9Lssljs+/fmO4cA5W0aoED4qAUklGzpR5xt0PFWm9mLlIdyOoXg5OXb97rBqAshNz6JN1u1GM7nxJj3MITJk1u2IJ5KCKtSg5HIIBXyYVrav9iZ9i3dXzDCJgjimxRqEUqL6CsRHuRxE7Y6cs85UlSbZUROzkXJ13AhZ92HZdZnWi8o0YjK8e7n4ZuJP2Gp1lUXs
 CDGY60E6
 XSczLaaWqWDNLGED9sWMNrgefmdMUytvxSbdI9yNvu2l19I5Rx9O/pHs0fySlcsn+W/SPtyuxH1rv0E0XR5w8APIbESZPEOj46RBdHvH/eeJYwLsuqYzIUknBH2IInDfzcFxcdpkWjUTOMjO+F+KjqHM8V0FBqCKyLlxr0zz12NnZBdAqoD+i7W1YwqBr8B2dMcTCxvEUylBpd2BTMYwFxaxEk59VWL+HECJ8i6GJG78qZhd29t/zDn/2+iCtHS4YijL+Lj7xoW7cnXm0ri2lKoh5V7jFt3ybAJeeYfk3vCN6CLMKaU9mjs6vPF4i8mWOpSyH/xwDJP3jzHpjdWT8WxDov9fKExh1+PEdkDQ4eo6xjEBsdfFfSWVAYp45hOGUDMfiCKBTRLQhhRE2YHGc8nZRLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 03 Jul 2026 11:41:53 +0000, Dev Jain wrote:
> There are various places which use ptep_get() to get the pte entry
> corresponding to a hugetlb folio. Some arches (like s390) have special
> handling to compute the pteval, so they provide huge_ptep_get(). Use this
> helper consistently.
> 
> Additionally, some code paths may provide huge_ptep_get with an unaligned
> address. This is a problem on arm64 (I checked other arches and it looks
> fine for them), which is fixed in patch 1. The fix is made to be
> to huge_ptep_get() - that is wider churn and we can do that later.
> 
> [...]

Applied first patch to arm64 (for-next/fixes), thanks!

[1/6] arm64: make huge_ptep_get handled unaligned addresses
      https://git.kernel.org/arm64/c/9175a8c7cfe88

I'm hoping Andrew can drop this from the mm tree to avoid a duplicate,
but I didn't hear back yet and I'd like to land the fix.

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

