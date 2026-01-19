Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4067ED2ECE6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 20:39:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72B3F6B02C4; Mon, 19 Jan 2026 15:39:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 702836B02C6; Mon, 19 Jan 2026 15:39:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 406C46B02C7; Mon, 19 Jan 2026 15:39:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 182696B02C4
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 15:39:47 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C566CD1B80
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 20:39:46 +0000 (UTC)
X-FDA: 84349879572.07.6ADA764
Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8EE17160004
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 20:39:44 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm1 header.b=Cd1jzcLw;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="K b0Ld9o";
	spf=pass (imf08.hostedemail.com: domain of alex@shazbot.org designates 103.168.172.145 as permitted sender) smtp.mailfrom=alex@shazbot.org;
	dmarc=pass (policy=none) header.from=shazbot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768855184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UBFgguEuXiAHVZI06QHGYrq2GluVufoWEpXqZX/5BGw=;
	b=3t1AOj6/8iXPXqD57yYn18c1dbWPJGqGP6DdmzyUGfYs3DV+XjSEGLxNXaM3KbhwpPnbSg
	cd/ktyC+MnasoP+IMG3WlKfe3y8QbpRr0fnhknKF69MauJhBXzwAoGKX5kse08amnqxhKW
	KjLp3FdHl3FtdMfAWgdhxE854Q+gfuo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm1 header.b=Cd1jzcLw;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="K b0Ld9o";
	spf=pass (imf08.hostedemail.com: domain of alex@shazbot.org designates 103.168.172.145 as permitted sender) smtp.mailfrom=alex@shazbot.org;
	dmarc=pass (policy=none) header.from=shazbot.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768855184; a=rsa-sha256;
	cv=none;
	b=vJEh+qe99sm48KORusGvV8gPbk+9HHg01cg8jkHeiwsXQk+K2hsYtAS5ppHh9GZu2ndoMV
	k43QmtIhT5vrz9Tk38PYMGNzFvTRkPXs7HxtEfnMuqTuTIJ9RVbAWf/TEFqPmp6mkr8WgI
	Uez+vW/aADOnwFJbihaDaB+boBWc3nw=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id BBC81EC00D2;
	Mon, 19 Jan 2026 15:39:43 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Mon, 19 Jan 2026 15:39:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1768855183;
	 x=1768941583; bh=UBFgguEuXiAHVZI06QHGYrq2GluVufoWEpXqZX/5BGw=; b=
	Cd1jzcLwauvaWODb3MNLsIt3bGPpRu8WF0tEav7iVgnDSxJerMHdrhZi1N6LTDhA
	MsmBGNi9cpjP6EafG6D5/gnKadl3tjiRaPmw6gZVTv7ar4erOOVbGr2EEcT7clNS
	rvY5/TLOp7cdbac1S9eW52Djsw7MD5cdx1YgTRLQ+2FB6KvKCZKMORC02PP8ygf5
	T+Gm1NZxKBoW1i+cJCvYk+GBeHZRpj6SYK+sX3fZlociK9SVNXrOZCXnLdHACjIG
	WeST+8hDEWRVd1b9KJ5kqriJVmVPaAY6lab/hrFp5+AV5R13FIZzeFamfcG3CLz1
	5vpV6689riyT+51FHhv18Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1768855183; x=
	1768941583; bh=UBFgguEuXiAHVZI06QHGYrq2GluVufoWEpXqZX/5BGw=; b=K
	b0Ld9oV9fmzNNJMwWM4Q1L8cTWI1esUrKqF8PAMOgSjIfHGOHhweIlZiR2FPI1Q9
	MCN/FvYo9Ry+u8N9qg3sQgHQgMvrqH4JVPKrcE+YuRWF7Vr3M7j0TM+3EE21DgEE
	/QuAa2jdLLERIEA0uj3Ug9RfnOI5x9CJ5QeemBEwvbB2jrC+VXXdyQTxO9YwI/TF
	JenGVZjiBNXsh35hNOAD7fyoltPoJsTKhj47QwRceFV7cZwo4yvPRlfT6G/HWnCJ
	0nnXq4TE0m5wqUr3hjfxuA7viH983cVAEOo2nJ16dE1IWYAgyD4ud1z7NLgRSaZR
	kHjeE3/tzzNxzTAdamDEg==
X-ME-Sender: <xms:j5ZuaXYJUNrcG1rQtT-PfoFgRKp-j_yvHK1mNRL9vvAdsskJVI-D_Q>
    <xme:j5Zuad_a7T9c7zWxhvAxMjvjp5HUotOzXFKJKBIaSQ7ih4tIb1NwxVSbt8yLQqow-
    4EdwvDD0FdeDnwfgNwcSoB4PwvXd_lN8NOk-35KR5llVEsBGhx7WA>
X-ME-Received: <xmr:j5ZuaZmVKS2NeRw48sYVE4sFqNxgIp5nTcHE2zgqvxQQ2ig1f9v2-_Kfp_c>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddufeekheegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfgjfhfogggtgfesthejre
    dtredtvdenucfhrhhomheptehlvgigucghihhllhhirghmshhonhcuoegrlhgvgiesshhh
    rgiisghothdrohhrgheqnecuggftrfgrthhtvghrnhepkeehjeeitefffeeuieetjedtje
    ffvdelledvuedvffdvfeetgefhveekuedvfedvnecuffhomhgrihhnpehkvghrnhgvlhdr
    ohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grlhgvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohepudeipdhmohguvgep
    shhmthhpohhuthdprhgtphhtthhopegrnhhkihhtrgesnhhvihguihgrrdgtohhmpdhrtg
    hpthhtohepvhhsvghthhhisehnvhhiughirgdrtghomhdprhgtphhtthhopehjghhgsehn
    vhhiughirgdrtghomhdprhgtphhtthhopehmohgthhhssehnvhhiughirgdrtghomhdprh
    gtphhtthhopehjghhgseiiihgvphgvrdgtrgdprhgtphhtthhopehskhholhhothhhuhhm
    thhhohesnhhvihguihgrrdgtohhmpdhrtghpthhtoheplhhinhhmihgrohhhvgeshhhurg
    ifvghirdgtohhmpdhrtghpthhtohepnhgrohdrhhhorhhighhutghhihesghhmrghilhdr
    tghomhdprhgtphhtthhopegtjhhirgesnhhvihguihgrrdgtohhm
X-ME-Proxy: <xmx:j5ZuaaaH2-EYtGccQOU5pCexBS3btzV5-lo1KS4RXPOXb4adVCUI4g>
    <xmx:j5ZuaZNtsXvaGJFPVMMee9RjL5jrvF_RRvNyAGjwc20ITC9RhYFsnQ>
    <xmx:j5Zuaaf3B3COk8iQhvdI7qxgIu3hjTNaS4yD7PcXnezl7rI44g0sxw>
    <xmx:j5ZuafGX1HESnLYPUSKpweccZugsneCmqoGGdpCEd9KwzbqK3dPYEA>
    <xmx:j5ZuaYFTv_0-XeoJCgj-mm3XuFt9-A1a2at6kUn8uaSyckgHFdt8EjPf>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Jan 2026 15:39:42 -0500 (EST)
Date: Mon, 19 Jan 2026 13:38:05 -0700
From: Alex Williamson <alex@shazbot.org>
To: <ankita@nvidia.com>
Cc: <vsethi@nvidia.com>, <jgg@nvidia.com>, <mochs@nvidia.com>,
 <jgg@ziepe.ca>, <skolothumtho@nvidia.com>, <linmiaohe@huawei.com>,
 <nao.horiguchi@gmail.com>, <cjia@nvidia.com>, <zhiw@nvidia.com>,
 <kjaju@nvidia.com>, <yishaih@nvidia.com>, <kevin.tian@intel.com>,
 <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH v2 0/2] Register device memory for poison handling
Message-ID: <20260119133805.49fa7b8d@shazbot.org>
In-Reply-To: <20260115202849.2921-1-ankita@nvidia.com>
References: <20260115202849.2921-1-ankita@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8EE17160004
X-Stat-Signature: srjzb9mokeczugkrm5xp3gcb4fdm3r3g
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768855184-799936
X-HE-Meta: U2FsdGVkX1+ngn0AOlOworl8XauuSSS5nzSAgr8ScO3gDS2wvzJvFFsW73sVBb9Zglxbos4WXIdN9sy1FqiqpsxgkGCrGv2y7TNBjesMIrTWWnxfkAqQWm2hcoZ3cH9+FUWntQ15FqEIJ9YNqANcC6KAbY3s6ME1QJ7vVUPJe49ORgrxkI21/g2mbiN31UNKOJzgoJhK26823JazkAH11fg76sMEXxkSDgsRZMQjnPRJL4Wrys9e/1OdLv0VXx1zZeKarLp33UNNX4Vr5sL7wisKo0wYOunPJFhw0EqTssSTh7Labnql5F9r88XIprbQ53hL1s1PgMZhqfiv+X5ndLMfoZlN2kwuoT58eIXBLd3BKTS3tQTfVRjtfpp0gwVIOs6ReZZe2aloJqlb47T5RjZdg48r8KMLTRT0yAUDPDSUhrIgt8BLThiTa1zsf7Vnr6bL1dDt4eQQfiunm5sCjE653+MnP8YtIZdVxwCLIKgjiZgoMXqZYvbEPiLOw+tLJTGCwURTqhYAZCrz9vwO14U2JxwpET5VqkA3Wbv5Uvdv627I/RDiEZyq2/lAqqeBXp8RfcV6VvYSExkyyKyJpKLwOOP4R8dig8bp8RyNqBzJwaBRdaSE9Wn9cDfXagsO3fB5mRnLxQniOABFiSAVI+NHamFqQnmnXC3+weB/hlJp/BAwnuNJvlOllhTydUIwNemJ6nC2f9X0wLXH1PdxUdxoMWJW/ax6MaYUUojV6Idn0VXF0UoWfA9gRYRLgwibq/4a/XAsXQHcty70T4n0hbtRlqP72iVy+C+n8Uz8x7YGRRZQiO7IS/oSyOzM6cport73751/slpTgPU+O0lBsROKKOY/LarNx/9hjgmuQtWMnTOyocjjeMxAocT87VjkyQwjoZPv7kR0ftRiOTSOjCQKXfSfyKxX3TL8OCUR8sm252q/9e8LZ6+b6Q2LhTgxZueF739aAap99sFWh04
 3u+c1Sh+
 k/C43CwNhwg0gC34B2+IuT1gzOhLa+hM5a905GfRCg84URkYstJODxj2NUWyl0yREEYvzWNT9FoErN1fhfGDecI4fK1oIQR5MR53D2wb6bggDDYODB5FS0dC39tUIXPoKVwPt85SfQzXDaOOX/TTUZp0S0bal+xJdAHLQtNbPmJgSYVDNB9N7bVnvniN1E9qsRgQdbmVPYwfIWMwGXtfjmbrGmCArRBYsQAwnGxxPqxBIIcDE4fLQmoQcREsPKvoMVuasryTZnWrfqlGheQ72kMM6ixGm2foUuKc/mz4B5YLUkNQVr1XyHejCwFcFhfLVKvUJeh7CwTECZTrxT3pXu+ZBx5F232Xluml4R08nxgaMlQEljw+PvVBKjZ+s/lzxINxIvQXWwM7y9Zr/7IHoqnSteHW+Zi0wg2jQXlPfpimg46U8hEXi0W66mBKLW0LHNc5ktgpio0mSGDEwUQiEzNCiGJlfjvjShBbei7awJlBIobmOCuC3re+WOAZby+3xsW1J
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Jan 2026 20:28:47 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Linux MM provides interfaces to allow a driver to [un]register device
> memory not backed by struct page for poison handling through
> memory_failure.
> 
> The device memory on NVIDIA Grace based systems are not added to the
> kernel and are not backed by struct pages. So nvgrace-gpu module
> which manages the device memory can make use of these interfaces to
> get the benefit of poison handling. Make nvgrace-gpu register the device
> memory with the MM on open.
> 
> Moreover, the stubs are added to accommodate for CONFIG_MEMORY_FAILURE
> being disabled.
> 
> Patch 1/2 introduces stubs for CONFIG_MEMORY_FAILURE disabled.
> Patch 2/2 registers the device memory at the time of open instead of mmap.
> 
> Note that this is a reposting of an earlier series [1] which is partly
> (patch 1/3) merged to v6.19-rc4. This one addresses the leftover patching.
> Many thanks to Jason Gunthorpe (jgg@nvidia.com) and Alex Williamson
> (alex@shazbot.org) for valuable suggestions.
> 
> Link: https://lore.kernel.org/all/20251213044708.3610-1-ankita@nvidia.com/ [1]
> 
> Changelog:
> v2:
> - Fixed nit to cleanup nvgrace_gpu_vfio_pci_register_pfn_range
>   (Thanks Jiaqi Yan)
> Link: https://lore.kernel.org/all/20260108153548.7386-1-ankita@nvidia.com/ [v1]
> 
> Ankit Agrawal (2):
>   mm: add stubs for PFNMAP memory failure registration functions
>   vfio/nvgrace-gpu: register device memory for poison handling
> 
>  drivers/vfio/pci/nvgrace-gpu/main.c | 113 +++++++++++++++++++++++++++-
>  include/linux/memory-failure.h      |  13 +++-
>  2 files changed, 120 insertions(+), 6 deletions(-)
> 

Applied to vfio next branch for v6.20/7.0.  Thanks,

Alex

