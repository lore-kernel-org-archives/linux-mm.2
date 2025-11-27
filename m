Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D86B6CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 17:29:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3057E6B0093; Thu, 27 Nov 2025 12:29:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B53E6B0095; Thu, 27 Nov 2025 12:29:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 092B26B0098; Thu, 27 Nov 2025 12:29:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E73476B0093
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 12:29:45 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AE7D1140218
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 17:29:45 +0000 (UTC)
X-FDA: 84157074330.17.46FC1FB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id B4EBF1C000A
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 17:29:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M5DsguCG;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764264583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bGPkY5GyhjBNFnVPgzjBj/fJDLdTy8lOV4FUFCeETQA=;
	b=nO19cBRjGv56wAyoqvRLLfSPRBkWOmUWOl25+VNfxIo5NvXrntKk3QK7nAbHsPwUt6jLh2
	37dhaNsvXlt1PgvDc14Y87jP1JNa+HMdPhvD6ak22boj4BFNTUjow8AqdZNlR33e34G2sL
	jbbG+gncn2gOwNjK/aH2KXGLB3J1kEI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764264583; a=rsa-sha256;
	cv=none;
	b=SFq1ANMsLZbk67QWrIbsQ3loo+mTnJRyGOYyLDxaPxrLWv5n0lr7LfgG+vcCYQYpF/h4mh
	L6qzT/VnpsoZuvE4mLDry1j+qiu7qSyTYTPoqOTjuSI+hjWxKShSnJ9Lt8hIeNTvX/tbSu
	1UpnBQ8dmD/MtxjQNdxfRRMefIjpmgk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M5DsguCG;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E12760242;
	Thu, 27 Nov 2025 17:29:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43863C4AF09;
	Thu, 27 Nov 2025 17:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764264582;
	bh=nB4fj1qSwqt+nXUD6T8fItX7qNQnaNO9Nn1wmWp2EB4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M5DsguCGSx6lJRFcfXOOkiUMxXVeq2+FKS9DGpaSe+2ii8+ftz3gDSYEY0LXNJ+p7
	 uFlLnNB641IAaAHPyX0RoWoJIbHvIxMeQJOm+epTUxeE6bCNO/5OuREbRugrrT7GmI
	 jgEVv7ylwxJj9eNzp3pGABTQYUFRzwmLEZeUR+EcGH0cFxiiAzpryuewilZiJo0dBx
	 NQwPRpb7fMu1X4Zmiu+sQGVi1IOHMauD3BIYnOUPOUwTAdzKJlwUY6S2eADsXgdAPD
	 NSK94NVaxinaCaZapap2Q/beSQI6/cJak04qaKRuPfRbA7t4RWeBqJYu60t88nUJLj
	 mxBt0ow+zwILQ==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id 63FBAF40073;
	Thu, 27 Nov 2025 12:29:41 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 27 Nov 2025 12:29:41 -0500
X-ME-Sender: <xms:hYooaU2MFXml_ayJbmvN4vHCHF4bFDekthdZJpyqJx03xE515b-8wQ>
    <xme:hYooacmaBTcw4nNPaj1JlCq0IijnTPptoEBGTuKV8ZKCCWIiLVnvbbq8Ig-yaFzy9
    RgDvRzMjDUtTAX9YxfA2jIl9weCz0Lmsc6LaLWs9NdHaWbuSczENrw>
X-ME-Received: <xmr:hYooaY-TNIC5q5wZ6eDFjViaCpW6ruv03skSm-hivJ6RmV2DkZvMG2e5hpvheA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvgeejkedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepheeikeeuveduheevtddvffekhfeufefhvedtudehheektdfhtdehjeevleeuffeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfedvpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehprhhsrghmphgrthesrghmugdrtghomhdprhgtphhtthhopehlihhnuhigqdhmmh
    eskhhvrggtkhdrohhrghdprhgtphhtthhopehlihhnuhigqdgtohgtoheslhhishhtshdr
    lhhinhhugidruggvvhdprhgtphhtthhopehlihhnuhigqdgvfhhisehvghgvrhdrkhgvrh
    hnvghlrdhorhhgpdhrtghpthhtohepgiekieeskhgvrhhnvghlrdhorhhgpdhrtghpthht
    oheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpth
    htohepthhglhigsehlihhnuhhtrhhonhhigidruggvpdhrtghpthhtohepmhhinhhgohes
    rhgvughhrghtrdgtohhmpdhrtghpthhtohepsghpsegrlhhivghnkedruggv
X-ME-Proxy: <xmx:hYooabE1OnuULuM3qMb_acv78iF0fEDkV85Cx00gDbBgQS02Y1D07w>
    <xmx:hYooaZljC10kOgd7iTK6RIGmZ6CdYN46iHFJ4cd0vqm3g97L6dTr6A>
    <xmx:hYooaSeZAKaBZ58tMU3dfBYzeUZSrKWGjgJoaq-2Syq9sFXB8EWbag>
    <xmx:hYooaXDRBgnAKBlFE4tnCp83QaXK8pRvx5UyrwTMUrcGYefMASP2_Q>
    <xmx:hYooaRyZef22Bk-p78L4jLx0tuaaVdfTXC5kFGuadh7s3SiXfmv4YQ1V>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Nov 2025 12:29:40 -0500 (EST)
Date: Thu, 27 Nov 2025 17:29:39 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "Pratik R. Sampat" <prsampat@amd.com>
Cc: linux-mm@kvack.org, linux-coco@lists.linux.dev, 
	linux-efi@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, ardb@kernel.org, 
	akpm@linux-foundation.org, david@redhat.com, osalvador@suse.de, thomas.lendacky@amd.com, 
	michael.roth@amd.com
Subject: Re: [RFC PATCH 1/4] efi/libstub: Decouple memory bitmap from the
 unaccepted table
Message-ID: <v7ocifp2adtdptkbzjmvrhqgjjbzug3a5dqspw54kmfmpauwdz@fuwlvrnjhpcm>
References: <20251125175753.1428857-1-prsampat@amd.com>
 <20251125175753.1428857-2-prsampat@amd.com>
 <phywn74ghpsqncoqsgdqjoxeqdxskibzt3yltn6bmtc25sm46g@emad5n6wp5l2>
 <e66ef586-0e19-4e53-af34-129ed28675c7@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e66ef586-0e19-4e53-af34-129ed28675c7@amd.com>
X-Rspamd-Queue-Id: B4EBF1C000A
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: p4zx1jkkb3d6eccgwn6wkwayk4c9b1xg
X-HE-Tag: 1764264583-924595
X-HE-Meta: U2FsdGVkX1+oUZhST4QSBHJvJ8JuPCD9FzQNZFqKFo83n0352bcrkd7ZvyoVurMyj8vCROfMTRakeJdUYCCyQ/JmpGHCR0GdXc7vcD62lBuUoJ576tLCYu+QbIk1coryksFh1Zg8eAXbsibMfalGchDzmA3DYhlzViyTN3rt1V/dN63GX7899n+9xo4sCbKME++YohtZowXjCBtJnzPa3+jQzP1J3KcyA1ikC4Y8IN3CzqIV2JJxJHyC5oTvydC9glRwmnqgHVEWOxZOd4FPsPOVWo2t3lCyLjgpa85Jrw57NSci9oF3LqXvpeq74XyO/qSoNhbT915xvNQALNEmoCunHG6xDM/PfZEAjT+6/kJuXKzbyv5dp6J7Tt3vqw5icfbu/cyZLLMDFOGKE9qVxAppv/ni2qhhhSp7QB2dRKFdHJAJT5OmPf8njR/HxENGsnlEOwa89OaWE7ZGFcdyk5YuGGpvZBOdilNcjExDO6Te/XzCZn0UgjzPYE3SWD2zcqhS+mlTg0OYtYV+SUkmXofGdyjRQdqH3nU9sFVqeNJbmLFq3NZMGOz1kIRU4XY6DF1qU7xtsujhelGaXhDJspfeJpIsCKg7PZqPQVj2iyqJb6WVVxQzETHQV753pDnRtr6F2UmCvrnrJaB+6WF147m8igOqDpKvxekUq0qv+X6s1Fl21WA0IdOTUnN8JdxYt0l2c+jfF4wF2TCRHiEqiiDAKMnhjxK3+AZjl2yDZrKIz/aqHwShsZKou55ZAH3YU0MorNW1Bsw7y4xWHPPfsJQ3YGOTX5J/HDdp/eMu3V8ea6YerkywKmuGl2dOqxV+kJm0+nPv9b35nPgvavikvdDjSbwIj22sSZwg+Eycrv7yqTq0/lPGklmyOKUmSg+rIEoDYpn0sh8UPW9ZS0BuOcP2lPdLNOJkKfMhmisRVvwAeuiaMvSqAfZiHZ8Rb8wAO0N5Y17BgK9sFlXcnUJ
 QmmWE96M
 1RUBJuQBkMNpXe+1Y1gq4Kl1gVbIU5WuK/P6RWvnbIXf6zMtiXPclbYid7KncRcFoUxlPuZR4Xj+ELtp2suolqxFithIyoRUsHxFbzlx3pOT+yETpPOm2qO9h1VoP45B2ssknk/7k/dxXap7+OJwng6SK5TabACkXaTBcNcdTTZYLrOoslovKHKohYrIYndgNd6n6qGloD3jZh7qocVlEMGdiUSLr/TvGYGLKD0xk9agnVCOGIl+8e1WTezO1yM6oUdJsgCcekXlf3tQgYcdBP8Gl2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 04:27:19PM -0600, Pratik R. Sampat wrote:
> Hi Kiryl,
> 
> Thanks for you comments.
> 
> On 11/26/25 5:08 AM, Kiryl Shutsemau wrote:
> > On Tue, Nov 25, 2025 at 11:57:50AM -0600, Pratik R. Sampat wrote:
> >> Memory hotplug in secure environments requires the unaccepted memory
> >> bitmap to grow as new memory is added. Currently, the bitmap is
> >> implemented as a flexible array member at the end of struct
> >> efi_unaccepted_memory, which is reserved by memblock at boot and cannot
> >> be resized without reallocating the entire structure.
> >>
> >> Replace the flexible array member with a pointer.
> > 
> > Well, it break interoperability between kernel before and after the
> > patch. Consider kexec from kernel without the patch to the kernel with
> > the patch and then back to older kernel. It is ABI break.
> > 
> > Is re-allocating the entire structure such a big pain?
> > 
> 
> We could do that. My concern is that we would then need to protect the
> entire table instead of just the bitmap, which may add an additional
> overhead?

What additional overhead? The main contention is going to be on binmap
anyway.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

