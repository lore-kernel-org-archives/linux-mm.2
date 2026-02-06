Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8372DEE2084
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 12:03:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4FF56B0088; Fri,  6 Feb 2026 07:03:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E102A6B0092; Fri,  6 Feb 2026 07:03:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1FFD6B0093; Fri,  6 Feb 2026 07:03:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BFC666B0088
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:03:51 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 88B2314015C
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 12:03:51 +0000 (UTC)
X-FDA: 84413897862.15.7A1774A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 71367180004
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 12:03:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G5xOzC7m;
	spf=pass (imf16.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770379429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E0XNAH/NyqCZ35w94HdR4TuMyBVGAQNA+L5GFAQUXYI=;
	b=t5HGCWmQ6zU8Cs+cOf0Jhw58oclsUftNmH+kHYKhk6XfZ7ll4USmTxjZIsEQJokt+ryPmA
	U3pxrCrnKddHnhuvnNjxXwGThkvO7Kv4BdoZtQthfHamu7acbhKWsKLfkJAaw1kPpg4X/7
	ibfRK3/JuNS3TGKN3eRo55sxbMMUF2o=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G5xOzC7m;
	spf=pass (imf16.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770379429; a=rsa-sha256;
	cv=none;
	b=TA2IegRevWRj5CwVsaDFiUCyRJjYPCDB4FCS7OOHycyaaXyXIFO6ZHEwDIo9NVO/MY2BUT
	55Od1/uuEPHSoAaJnpv9PNIZXErioTK9WzKvXGc+c+z0Z0SJFxqN8svibK0K8XEI/0DKRt
	Cu/rfRg8HH3FN5Ytkh7SgOYmgVxf0F8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4895E435D3;
	Fri,  6 Feb 2026 12:03:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBBCFC116C6;
	Fri,  6 Feb 2026 12:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770379428;
	bh=uMgj70N3216PC7d5PJlZUPfJ7trqCmQKoi+TPeLlEEE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G5xOzC7maqyE3zF8h9xz38W1B0DbQ/4VL4h7f81ggg03ALi8dY4hUXfRTG4xVp5JS
	 zAAFAWIq4P9bFkf54YoooUlreZfnjDfcYfRzZyEKypEhsN2udu10tYUz4jWHWZUpks
	 8jsnmHhIvZE+Ekv5hFcwHeit7UjYFBRRtCiu42/r+8IAwNFs+VW+xd8BBefXY8595X
	 OPqDPMJoPbEVcBaoKMEI74Fj3RMhWbPGriiDy84QTQLAGrt3ROiTI4YdFV88NtLRHi
	 DlEbDtWFazMbi4lxwPHLG0b7PLr24msjpq7EA53A4x6wjn3CxmcCC7G7wJXInLlq6J
	 9Hq55Vco8IKQg==
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfauth.phl.internal (Postfix) with ESMTP id C9422F40068;
	Fri,  6 Feb 2026 07:03:46 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Fri, 06 Feb 2026 07:03:46 -0500
X-ME-Sender: <xms:otiFaQEULD47vLfzOd_fg0E58Uo__xNLzoPHwEHRsGax1e3oTRp-hw>
    <xme:otiFaaFzHKN9407YmjK3-rMpIUflrQYprQS_a3KWLaM065Qu1GRxkPCPbDOwMO8oS
    lI9-xtOUz_jtzi7t5tSBuDabkWB1aMyMyGVYeWcOwywwbw5ujdiD6uQ>
X-ME-Received: <xmr:otiFaTARMWepb3L38GBwiin7VOSdMlU8QBqWHQ84zyqzpqtNdaWj6nvoQO-jRg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddukeekuddvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfedtpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopehprhhsrghmphgrth
    esrghmugdrtghomhdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdp
    rhgtphhtthhopehlihhnuhigqdgtohgtoheslhhishhtshdrlhhinhhugidruggvvhdprh
    gtphhtthhopeigkeeisehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhk
    vghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehtghhlgieslh
    hinhhuthhrohhnihigrdguvgdprhgtphhtthhopehmihhnghhosehrvgguhhgrthdrtgho
    mhdprhgtphhtthhopegsphesrghlihgvnhekrdguvg
X-ME-Proxy: <xmx:otiFaZ8HNMMN3klfCbCKXshOKBsujGwRe1l6sKcNWOpkyEcNDSFgKg>
    <xmx:otiFaVdbZp9Tz7qLQmG4P6TDG6tLok3czcT7evMAsN3wHNPfTcov-g>
    <xmx:otiFacB97NFEo_X5WtU3UtB_XW0eZP5NVGx-t8J8bDzFSDtj3V9UKw>
    <xmx:otiFaVfFgEnrfojQBQkd31IsDKYRbhHd_vgG0mQdJzjb79vPFXqoUQ>
    <xmx:otiFaYhlxyVV5_mDe4Ex59CQpQkvQnEPkK5rjFhtC3nMHVXA802RUePi>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Feb 2026 07:03:44 -0500 (EST)
Date: Fri, 6 Feb 2026 12:03:39 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Pratik R. Sampat" <prsampat@amd.com>, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, x86@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, ardb@kernel.org, 
	akpm@linux-foundation.org, osalvador@suse.de, thomas.lendacky@amd.com, michael.roth@amd.com
Subject: Re: [PATCH v4 1/2] mm/memory_hotplug: Add support to accept memory
 during hot-add
Message-ID: <aYXYRf4lxm_iQwjE@thinkstation>
References: <20260203174946.1198053-1-prsampat@amd.com>
 <20260203174946.1198053-2-prsampat@amd.com>
 <d07cbb96-ba30-4dcf-ad14-0479d6a989f2@kernel.org>
 <70be936e-e49d-4485-8d1e-416fdf8f40a4@amd.com>
 <aYR0vqwyFPo3EKAi@thinkstation>
 <ce4334f8-5e54-4dbf-9be0-059279ef1962@kernel.org>
 <aYS8O0phOE41IuEF@thinkstation>
 <fc60cc71-80eb-4058-8d0a-dbd19a5c10ef@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc60cc71-80eb-4058-8d0a-dbd19a5c10ef@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 71367180004
X-Stat-Signature: xaq4gfqrqqe9cc46ymg1c34j1opjgjad
X-Rspam-User: 
X-HE-Tag: 1770379429-507969
X-HE-Meta: U2FsdGVkX186amq7CmvYYTHUiGV6EqzxJ0TJ37JUyxu8bnIzppCoi4g1taSguDriK4WNcf5N0m0qFxxzrhCGU44u5MIiVM9TkuCaQciCgDexoAOgnphx+7tj7CPDPk42M1PrMl0Ae+G0wfQKmueRIbWdSOt189KiNfAibCzHW3UD1LSPEJmG0v6RbsPjm3/CtbJ1pXhmJ+HxpBBdgOr/dHO+0d5rKumnhPcaRpXkp/vcyOzaMi2RrVHn7Fb66rrdq+idZysX8HOgRQVTB1X2bYR6i8/XxUJ/ofGxCIj1cWUzs9cgzUT2LKkLnL6i26xi4JtPtYKKGRtov45lBqX4FnMiOyc/47+0+IJSHMQnDwP+kt3snd16QDnE4ZNRvJK9uJpydOuAP509mlmLLmRM8jI+GYJq7AL7SGMxCRf9nrlggx2YgrHhwNzIG0Mu3rZBuZ5/sZz+hSixGp84RSDvZMmUuCa0cSpYCWQ4Xq/7QBdt05UvYNFRbSPA6y0bcMetQo3bfzZI1knVOwGnoONem/Ra069DKys2yNj635gcb3LjowIeFAe6xk8x3mjRjlULFSKj67/DIeXGMUGGTuUhpiEv1jRBp4jjeyVCKGsyvtgOUqVXj6Dcsl2i03o2yaUdF2cF/gk4fGOLYGBip/BVJ8pqMnY9KomzM7lD9L80TY632k++0JoCyKQ/63oTY3ZmAMb6IqhFhNQDOWEQbFUbfxpCx6l5w9oNH4Iqsa4K9czh5Dt5/32OizNd2PUb+TbKGEf7WZVmsjwus0cF+WAvSkElpp4XYGMvKRMh047pBzkMvtaHkPt3ZaIthjuDljnCgtQ55AENiinu2Yh/hdkpTI7C8Kqh9WU8W+2I0axrG1P14tfZeSh5Rkf7dVuJRuualQySgHCUUl6ejYskOcjhJO5f8eF22UzjKHAnLe/H7ZlxfgqKZGcy57FZeGLy0js/5ZyWl/8mkWLNCYKrp77
 U/F0oVnh
 o/FPVhGOt+lw7qs6Ct1ZleVySwFsK2LOF66EM1IHy4k6f5FK8q6xBh/P/cPVgfHgtYNb2G3t2YlfgqOy0Rhxj2qm9zb5btqONlnDKmIi6LbvAkxF9y7tCVfYEhuHD4BdlC5PkR++s5AVRWhm4kMk536EK15NO7vlrqrSTO5vQw+nC41ngCWROUNcQHzpT6oofvDHZTyOYbUBJbZuiEjiadRKXHRMNgUX25pGeZwAADEObqw6nKh+qP89HLn8Gh4dQa8SymRWVSCCno4JamQ5AhMVZ+yS5yWY4lvAOVogJGB9aWgL5y3GgV8TxFEiAH2Db3aPtEeFFYTI92n4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 06:29:08PM +0100, David Hildenbrand (Arm) wrote:
> > Ideally, we want to know on boot:
> > 
> >   - what memory ranges are unaccepted - we have it;
> >   - what memory range can be removed or added after boot - we don't have it
> 
> The SRAT describes memory ranges where we can see hotplug memory. Is that
> too late? We calculate max_possible_pfn based on that.

The cleanest way would be to declare the ranges in EFI memory map, not
SRAT. It should be doable.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

