Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77A67D116E2
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 17:02:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C10E06B0023; Fri, 28 Nov 2025 12:02:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE8AF6B002B; Fri, 28 Nov 2025 12:02:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD75C6B002C; Fri, 28 Nov 2025 12:02:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 986F06B0023
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 12:02:40 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 215B6131F90
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 17:02:40 +0000 (UTC)
X-FDA: 84160634880.25.7AD6DF4
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	by imf14.hostedemail.com (Postfix) with ESMTP id EC93F100025
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 17:02:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=armlinux.org.uk header.s=pandora-2019 header.b="Du0ZlL/y";
	spf=none (imf14.hostedemail.com: domain of "linux+linux-mm=kvack.org@armlinux.org.uk" has no SPF policy when checking 78.32.30.218) smtp.mailfrom="linux+linux-mm=kvack.org@armlinux.org.uk";
	dmarc=pass (policy=none) header.from=armlinux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764349358;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XVRJvm/lygEstYwV/cxa35RATnYQMUHVa5blksxqM90=;
	b=Lw0QfxSl99HRE0kQcXbwp5r+l7/zatN2bHqWhX6OAhtmk00z7vNvx7EJ7dt7lUokvALABR
	/lhOiLS1bam6tpA94nEQApBjyxAtIPlPprr57sYQUo1dU8sRuIn6dlZDsDzsNizxwfeHxB
	NhTe+ycOyjEZEf49B070NK8xHcTPOSg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764349358; a=rsa-sha256;
	cv=none;
	b=D4ShMx7kvdF8a9zU0hp4MPUsAh/an9B+qF9I1msl38k1dxeVO85Bc+BDyGkoCPKHx7yqCw
	G69xVl8UkqnJJSAru9nQ7otojc5pt0qy/Vet9HMKJ8eafvFa7Joh/4Fn551vBt5HvlJGPY
	31cd+WrXblPcTLub7vGUick+KgOtqrM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=armlinux.org.uk header.s=pandora-2019 header.b="Du0ZlL/y";
	spf=none (imf14.hostedemail.com: domain of "linux+linux-mm=kvack.org@armlinux.org.uk" has no SPF policy when checking 78.32.30.218) smtp.mailfrom="linux+linux-mm=kvack.org@armlinux.org.uk";
	dmarc=pass (policy=none) header.from=armlinux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=XVRJvm/lygEstYwV/cxa35RATnYQMUHVa5blksxqM90=; b=Du0ZlL/yTuJ7tgAK2/eya2Msv0
	m1hqJ1fknLG5/2gAaZraPTBi4xu5lbdIohbe+V2jihr4tRyNEtbSORjNW/LjDwo9S5Nas1NhX0U+X
	vO1ED5Q3H05FJRXQJm28JEFlS6JVro50OVs0uhPUT8l7bea10AB3nG06YNtCYyGUuTmfhMa75P4Oh
	/dhkFNrWOrM0yYp2pq9f5ZW2TG5aKT5L0OnEgk/qi8Al+krHe1/xBvr+aQSYMZAya472w82YALFwu
	5Q2rA7atA436DTMf/r7uTyS/8+zDwF2MuzRB9woLnX+Wm6oeApu9ixX4s8wLJ7MiB7MKf8PvS9g9L
	mYnjWg5A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52158)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1vP1qZ-0000000071m-1bEl;
	Fri, 28 Nov 2025 17:01:27 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.98.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1vP1qR-000000003mj-01ZK;
	Fri, 28 Nov 2025 17:01:19 +0000
Date: Fri, 28 Nov 2025 17:01:18 +0000
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Xie Yuanbin <xieyuanbin1@huawei.com>, akpm@linux-foundation.org,
	arnd@arndb.de, brauner@kernel.org, david.laight@runbox.com,
	hch@lst.de, jack@suse.com, kuninori.morimoto.gx@renesas.com,
	liaohua4@huawei.com, lilinjie8@huawei.com,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, marc.zyngier@arm.com, nico@fluxnic.net,
	pangliyuan1@huawei.com, pfalcato@suse.de, punitagrawal@gmail.com,
	rjw@rjwysocki.net, rppt@kernel.org, tony@atomide.com,
	vbabka@suse.cz, viro@zeniv.linux.org.uk, wangkefeng.wang@huawei.com,
	will@kernel.org, wozizhi@huaweicloud.com
Subject: Re: [RFC PATCH v2 1/2] ARM/mm/fault: always goto bad_area when
 handling with page faults of kernel address
Message-ID: <aSnVXrnuY9QKjTKg@shell.armlinux.org.uk>
References: <20251127145127.qUXs_UAE@linutronix.de>
 <20251128022756.9973-1-xieyuanbin1@huawei.com>
 <20251128120359.Xc09qn1W@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251128120359.Xc09qn1W@linutronix.de>
X-Rspamd-Queue-Id: EC93F100025
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: zoskmjhaxamspmkj76iggru81ssi7uz1
X-HE-Tag: 1764349357-363801
X-HE-Meta: U2FsdGVkX19/ezu7sXRUGjce3MZCYcuaZmA407QPl8JCi48FFE86E+4N7HHUqEHK9mfeVcoXYDa31aFH8fEXUL9BJgU2SoiLK2KDDUB2Egmrf+Jj5zNV28uE/5wAAxVS2QJjc0KcNsvqaOyPiCWl4+sGzaXjLsAOgJu52NV9rozkh4se0muzqFKpzvD3z8FcKZZcIz2tOZs1Imn2NaShpXJ7VA966IuXHCkPInqVeyJEUBmsFSOiVN8+aokg8iwhi3xiGfu7Y73vPL+Wb7lunNX/6dtjeWLwh9uqTG/1varS5yAvkhiNBqOmHAGCk1myf6Q3oj4DWI+eNGDI1/AaljKuZH4kDJ2S6WOX2UETt1LsEA85Mv4G6whpR1kFISIKNyDQ6rKKuCoHBCUlR/MrfbdXtfZptAM+Y75faTDEnvUFpyQZIfuE6EKDgpsWYBvJUBW/tFehI8MuN7MrYxvj8vXlQVMRg1Gvakc8tkwe/FXdwdD5OIANk2m0DTTWWJr4ORKPMAsCLRie8E+qJAJmm3pO8A7+60s03OJmHJ2WgZZUXsULE4o0Gmk7+fK3ghVlw3N/M+zzAezwy5F/E0NXXs5cESGsXygeRJ4oiKa42htsUUgkRxLb0EbkfSkPDQwzXpB0C2nEHRHIOZxH/vyfCEat9Vfw8bTmxLEU3LaNotUwdfbN/TmG4rxPFri8Sxa9A1SqQHjFq8op/pyFwRvk2SlwAGkCvqrggjwgY7ftnz7dMd+zattgQdSSE0EiRh9xln8LSwubG+2b0r5lhoC6znHg8iBpJob1fYXjzHcy3CbZ+FjluTvHIap9K4AbORT61Pxkx0BULk1X+zdh19t8levFrPj5/KDd+NkdqCnB3Hwq2lhCEuHFzF3lLY8OCWCGED7HXaAxdTnLrSnvPKG5XBZgVcwgJ7b92A9J2Tq07CFBNpHCN1R4C388UTbkMmVxRwAVlORhuPpA865bZ/O
 /OKJmu6f
 UuihxrLxrG5Qr45l+IDDmqXlg+SarD6+FxsvHls6BnR0rB7Fqb2DGbnvshomftutep3cUC+ATxGBRv60CaxV4JezVvH1pqJvMuC14yANN4pL9QRn5OYK/yeSbmjc17NYQtSCyqxbPE1vF9lEFLQ5pkidc4eMbYHb5a9GWY5SMn+6KdBOaktehbNisBc5PHTy7VwNwiWaafXTVagNv6lpYDXh8xJN1y19TOnhSAPsokn+WjCRHh/lcS5714KG8XkN2y+D7mFqHVBPw3EqWOkgh/BZ/Av2Gz7HXuDH864Tyrn+I0rj0SBF6nMyNWXVVUimTxc/MTJ1u02KgU15iWC4Up7Zmvf6+al/TtfxdsEsvJ1OQemn8c+9hu4uE8PH0sMcNP5coPl+hh4NqiTkQw95svPmXUTqY6AGdu21ZOYhCoS4Nixt9IZbWiq+JLTnpJIsJZaA5LMDm0EiUD3CYoXGlal4ivPfJK3R1G61sYES4xcrubWF11V27jQPu+SvMa7cDvA4AtxryFklbxmjTiCoUUIcnvCH66S0VP36JOpN4k6OnlRpnUzrmauE+PAkcOPiOLQ6qUncDLb0/uJzr4ntQ+CplxVrfwHUaq0iA7iBX6jvysd8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 28, 2025 at 01:03:59PM +0100, Sebastian Andrzej Siewior wrote:
> On 2025-11-28 10:27:56 [+0800], Xie Yuanbin wrote:
> > According to the discussion, it might be better to handle the kernel
> > address fault directly, just like what x86 does, instead of finding VMA.
> 
> the kernel fault shouldn't have a VMA
> 
> > Link: https://elixir.bootlin.com/linux/v6.18-rc7/source/arch/x86/mm/fault.c#L1473
> > ```c
> > 	if (unlikely(fault_in_kernel_space(address)))
> > 		do_kern_addr_fault(regs, error_code, address);
> > 	else
> > 		do_user_addr_fault(regs, error_code, address);
> > ```
> > 
> > It seems your patches hasn't been merged into the linux-next branch yet.
> 
> I hope Russell will add them once he gets to it. They got reviewed, I
> added them to the patch system.

I'm not sure which patches you're talking about, but discussion is
still ongoing, so it would be greatly premature to merge anything.

https://lore.kernel.org/r/aSmUnZZATTn3JD7m@willie-the-truck

There are now many threads each with their own discussion, which
makes it more difficult to work out which is the implementation that
should be merged. Clearly, not everyone knows about the other
discussion threads.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

