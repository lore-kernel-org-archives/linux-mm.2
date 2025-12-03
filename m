Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF563D12D6D
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 14:46:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38B1E6B000E; Wed,  3 Dec 2025 09:46:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 362DA6B0022; Wed,  3 Dec 2025 09:46:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 251886B0023; Wed,  3 Dec 2025 09:46:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 102196B000E
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:46:30 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A58F2C04E5
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 14:46:29 +0000 (UTC)
X-FDA: 84178435698.12.EA310BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 90A9E14000A
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 14:46:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=meskB6cU;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764773187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WEFfvb/y82nxmbudkZ/4gYREH2nnmtIg5g8bcae0O9Y=;
	b=UNzdQlX/uGonZkvkw6aiK6a2sPR9JXmUryTiHcNwsaYsIUsmUyNjjJv4M0P8Mb+HK9ziMw
	oGxF0KOi4CJDmWkAd/UOsdskLNMxpusYT2ciz2aCk42tVNScXaBi6HXcE9ZOknmyBUhMxI
	K9AyENi2lN11TQDeSAThOgA4Elp35/0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=meskB6cU;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764773187; a=rsa-sha256;
	cv=none;
	b=Wevo4BExsqrvE3WrTp8rGsr7zefTD28TVVSO36bxFo6MsR1ytF1g7UFKF0Ff39eXk8KGUW
	37sxyQEd79h2gkhIw6WYgJQk3jXJOeSGYXtSDSpQD4T9RytpRjiacXOBi2s8PG+AZ43Wl4
	rhdIrbLyVq/K+t2uJ29uJYnlS4DPVe8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 52387438C0;
	Wed,  3 Dec 2025 14:46:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C72D4C4AF09;
	Wed,  3 Dec 2025 14:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764773186;
	bh=jM/ow1A9leA7Y9bLZ+XmYp9O4P74p8od6dKc69m+yVg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=meskB6cU1n1VE+PIMLR/sLS4SpNTq+aY/SdiWd8UYCXrunUwa+UTSrlkDIOxgBk/I
	 73HFYFwmmOc8vU51t9m8vQj+rwyd0/mBCvBWdKJyjPKGyYbZHYOTDyfokJhQCdVg83
	 Oj9VcE640ATvCXvFehLWfejcg+RIQfcdCPvQrw1vY9LRhgm6pxWjnRXjeawrjQ7Jhp
	 o3z2wFWRSfcF0Abor1FKS7h2YxwB6l8Uq4X8at8QUfxiqcgrR0BjWxlmC4hqHNw56w
	 U1X6yf9NQ2MB7WRZjCnFBU/PI+4WeL0E3EO8LeGuKgL/vf2qiUcbogv9H9PQFrv4sW
	 mg2hTNL2EDLmg==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id E87B2F4006A;
	Wed,  3 Dec 2025 09:46:24 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Wed, 03 Dec 2025 09:46:24 -0500
X-ME-Sender: <xms:QE0waS_3NGTJK-w6vURM7E1_c0oPRA2gEmQAkQzacNL0DC18I7dDjg>
    <xme:QE0waQFwdThNb4Pe9tNpgJCKk7VoecODKSOpsY5fNZ-F5IvEIghG6yPsqzuVCYEbG
    sM9kCYH1Cw0HRK4s5uRIFWTJ7KHvA5zp48VelPhfUWyj6YkKOiUiW8k>
X-ME-Received: <xmr:QE0waUCLb4CS2A7weFkB0y6cMGB78HKPFOyqZ3u_WCfpax7Au_p1iTLPVaUo7g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeftdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcuufhh
    uhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvghrnh
    epheeikeeuveduheevtddvffekhfeufefhvedtudehheektdfhtdehjeevleeuffegnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilh
    hlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheehqddv
    keeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrg
    hmvgdpnhgspghrtghpthhtohepfeegpdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    pegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopegrrhgusgeskhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepsghpsegrlhhivghnkedruggvpdhrtghpthhtohepphhr
    shgrmhhprghtsegrmhgurdgtohhmpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtg
    hkrdhorhhgpdhrtghpthhtoheplhhinhhugidqtghotghosehlihhsthhsrdhlihhnuhig
    rdguvghvpdhrtghpthhtoheplhhinhhugidqvghfihesvhhgvghrrdhkvghrnhgvlhdroh
    hrghdprhgtphhtthhopeigkeeisehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhn
    uhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:QE0waeJMZGc9bkDKe62Qoo9fBpsyqxxPkzUp4WeqJtR4ada39767Lw>
    <xmx:QE0waSwUvDspi7RHZn2deYxPPwH6dDnPAhqKzCq8XNK32YFfDkdy6w>
    <xmx:QE0waVGE5M2S2aPwbYJuJ-x21zAawCQQqesCN0No31Z8PhrMhShurw>
    <xmx:QE0wadSyZg_sWFO8lEFq-k1f-C8JJ_0pd70qS0rbx-WXJvbFew_LMQ>
    <xmx:QE0wabVn1p6LrnsP3Lzve-NVE9Y11l5XvZ3uzU3D6dliGMsA8mXyXqhA>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 3 Dec 2025 09:46:24 -0500 (EST)
Date: Wed, 3 Dec 2025 14:46:23 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, ardb@kernel.org
Cc: Borislav Petkov <bp@alien8.de>, "Pratik R. Sampat" <prsampat@amd.com>, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev, linux-efi@vger.kernel.org, 
	x86@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de, 
	mingo@redhat.com, dave.hansen@linux.intel.com, akpm@linux-foundation.org, 
	osalvador@suse.de, thomas.lendacky@amd.com, michael.roth@amd.com, 
	torvalds@linux-foundation.org
Subject: Re: [RFC PATCH 2/4] mm: Add support for unaccepted memory hotplug
Message-ID: <etd7r45wmnuoftpckrzkzithr443ru6akgwqjgzw2vgmzqi7cs@camfecdmef74>
References: <20251127181233.GBaSiUkaLzwANS_6WT@fat_crate.local>
 <beec5651-5c23-4f5e-a0a3-d1cc01a8490a@kernel.org>
 <20251128113411.GAaSmIs0kSWGhCYkaA@fat_crate.local>
 <47927c25-a317-488a-823f-ac0588f4eee4@kernel.org>
 <20251201111201.GAaS14AX18qeHN20xf@fat_crate.local>
 <052d7f47-edb6-4978-bc9a-c7eae469720f@kernel.org>
 <20251201191036.GEaS3oLBY8PEuE91Ap@fat_crate.local>
 <dcccdc4b-b7d7-47c4-b1b1-a6c70edb20fa@kernel.org>
 <20251201202507.GFaS35o7WtLJOM0_jh@fat_crate.local>
 <420865fb-34cc-43a8-820c-b15b5f24a27c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <420865fb-34cc-43a8-820c-b15b5f24a27c@kernel.org>
X-Rspamd-Queue-Id: 90A9E14000A
X-Rspamd-Server: rspam02
X-Stat-Signature: qa7hbs9dimjp8udcx96eydy8arq4emqs
X-Rspam-User: 
X-HE-Tag: 1764773187-591419
X-HE-Meta: U2FsdGVkX19RHMmi7BQXRO9EV6ZXS420Ebf+1WkLypH9MlSX75fRJlxU4Eve+anY/FZWcjQQQCyeJWh5mSEuTq/GTXsKa31TithEQEKhp/BHLT/+mwFGrB4vaQdHJ3+EZnzqNX1qX13mSCFzwaiUGYvkE8xggp+CaQhLwgX8lokjttkaBf7X+klNdTRfT0weod8BJw4AGHad9i6ZEd1yJIgrKjkSj/lJ4GwrmWopV2cxWev7O5xKoWiLRhVYvalHo4l0ueoWPc6ZZMJoO/USH4HodTiTu9mwtR6K1UPBWuVB5fGqVpRo6F1Jg0vPH/WyMPUHeSP9S5ecfvEWGBMf5d1T3ylWVkyYsPKmvSesAJJ4tS0KY1MMnBjc9uCwm+pyCAjMf4EN7eHiPmgr3QBClbfrIM90bR0IY+VBIM/eeq62WWIyNNd9gp/gqG4oT3o3YAyEI3j4pW1MbALaMhhFryeJNWTYPJQK/AWTgciAvU/cb8CsAI1DpqBjMdrZCUYiP3ZQ5T++07PQZlDGuEjp7svaeh/xjrqA/2FaQuuxsTBOK1cYs9OXntk38fS/L7ujhiRBHVXyFaVfI++KNr6YOixgR/4v3NhnwkjLzdKtJRa6vbPuWUbZ3OWgThZ2YTinlXgydwvq/fdj14cVWUz+Rp6/kLDTIMd1Eltarbjc0cIKbpOolNodK2hbvHyOZtXaxYbpbZOD7xaCbhxLtiLUwYkQO2PbVb3/U0WqGa1yJRVt8AqSMClWKBf5PBc4YAGDnrffFd8rBFBggyVWr/sfr34akp14+S0ZG5LPI9ND6MwVLrthO3oR9WO/qDf1lOCQYQA4ONGtjgnXTuJFCN1G2wXDEx0NODj5jk2U4rMV+Z7R5c1N3mWgKvrHQvESposIFXLKmHY47faxePDWHQBDPdNjm8EzR90pvf0HOXjkUrUVonCAjePHA0wVGVgyvpXVt7UaQoxHXxr18gZGPPA
 sGQ67lD2
 n9dVUG9iGwo8AWb3hdBCbEvFtdv+7YUVO7z7jyTXtIP0+FlFTZ9QSuTaLR2F6GXlYx5fCBE4jxFwqEY1h35gpvuo38b7tA5a6OTtwjqPBC7AibSw16iTra0d8MmwMkgDdzn+KsOCOQsgt8KgVagmt92NflCtUiE5YzI6s6mwN65uBKGc+JY0G8X9k9sEa/ul1Tb+20pWZHMaymFFfhK2ZWrE0FNlSY7M2CkARJevZHE0FKTszz4wtWmEwQ9HfQHAmoXt13afXYyVNFLhG+geErgyKNw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 01, 2025 at 09:36:58PM +0100, David Hildenbrand (Red Hat) wrote:
> On 12/1/25 21:25, Borislav Petkov wrote:
> > On Mon, Dec 01, 2025 at 09:10:26PM +0100, David Hildenbrand (Red Hat) wrote:
> > > Just to be clear, I don't think it exist and also I don't think that it
> > > should exist.
> > 
> > By that logic if it doesn't exist and someone sends a patch, I should simply
> > ignore a review comment about that patch breaking some non-existent ABI and
> > simply take it.
> 
> Well, we can always discuss and see if there is a way to not break a
> specific use case, independent of any ABI stability guarantees.

There is also the #1 Kernel Rule: "we do not break users."

Booting a different version of the kernel is a core functionality of
kexec. It is widely used to deploy new kernels or revert to older ones.
Breaking this functionality is a show-stopper for most, if not all,
hyperscalers.

This specific change may not be a show-stopper as CoCo deployment is not
widespread enough to be noticed yet.

The notion that nobody promised that you can kexec into a different kernel
is absurd. It is used everywhere.

> > 
> > Well, it certainly works for me.
> > 
> > Unless you folks come-a-runnin' later screaming it broke some use case of
> > yours.
> 
> Heh, not me, but likely some of the CoCo folks regarding this specific use
> case (kexec in a confidential VM).
> 
> > And then we're back to what I've been preaching on this thread from the
> > very beginning: having a common agreement on what ABI Linux enforces.
> 
> Right. Maybe Kiryl knows more about this specific case as he brought up that
> these structures are versioned.

I am not involved in the deployment of CoCo VMs, but I don't believe it
is specifically about CoCo or the kexec ABI. I think it is more about
the boot protocol. Kexec is one way to boot the kernel.

Should we consider the EFI configuration tables format as part of the
boot protocol? I believe the answer is "yes," at least for some of them,
like LINUX_EFI_INITRD_MEDIA_GUID.

I also think LINUX_EFI_UNACCEPTED_MEM_TABLE_GUID should be considered in
the same way.

Ard, do you have any comments on this?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

