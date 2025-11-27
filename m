Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFBDAD11183
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 10:58:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E6F16B0023; Thu, 27 Nov 2025 05:58:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BE886B002D; Thu, 27 Nov 2025 05:58:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FB0D6B002E; Thu, 27 Nov 2025 05:58:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0F0A56B0023
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 05:58:18 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ADAE5504FC
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 10:58:17 +0000 (UTC)
X-FDA: 84156087834.20.777CE63
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7CD174000F
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 10:58:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=armlinux.org.uk header.s=pandora-2019 header.b="B2/lGneY";
	spf=none (imf01.hostedemail.com: domain of "linux+linux-mm=kvack.org@armlinux.org.uk" has no SPF policy when checking 78.32.30.218) smtp.mailfrom="linux+linux-mm=kvack.org@armlinux.org.uk";
	dmarc=pass (policy=none) header.from=armlinux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764241095;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rwaD6e3iO7FBswKwqbiTF+sng1XMVLA9gDzbmcM5PHM=;
	b=JazvKyWjcRph/BjrrH6vonBPulffKSUihcRxv8wJYQFmBU4o/Y25v0ve0LkNQ9SNmGU0tg
	eTZc28xwvtUvhNyNeynCSJQSgXqV0LrFuxm00fN+gVL+Jx5csqFKsoAycJyN+Oxi1AkzUc
	X1h1u2y/zWcrhtLWA8vW7E/z1nB0oSk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=armlinux.org.uk header.s=pandora-2019 header.b="B2/lGneY";
	spf=none (imf01.hostedemail.com: domain of "linux+linux-mm=kvack.org@armlinux.org.uk" has no SPF policy when checking 78.32.30.218) smtp.mailfrom="linux+linux-mm=kvack.org@armlinux.org.uk";
	dmarc=pass (policy=none) header.from=armlinux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764241095; a=rsa-sha256;
	cv=none;
	b=ODaxQJKSHSYV4+LJV0sMSYRNPdHvZ+EgIOY/PdusN4ptNeiAtzV9lQ4MU0++sAOYJmro0M
	Akm6+TMsFwsWbB8mDUwVo+UPC0yUWAbWWKfyN8mnLjEzr0LmNQ9fIZ1onTHk3xucA1ejyz
	fgwM9wJp032YByC81Pch66cPyO0v5Hc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=rwaD6e3iO7FBswKwqbiTF+sng1XMVLA9gDzbmcM5PHM=; b=B2/lGneYs6pnScUNtyjG5fu88K
	S9+aReYiXYJTutEJBS5f97T5J5MZrDROL1VEzgpFlfs8j3y+bS501SkJES8IWxiycOAy0t95qRaeH
	amDDj2epiA9f/aFZLEGgNb8spmyhmFUp4APCVQH6+aCByPg72BD60fXcz+KYCsAktSKAGpGFzlpZZ
	Tja95pCyi8u48LDgytl9k+kcHYcY6uAKQyy40CoI8OC1418+VtkN1t2gybnHazlGHODW/+QZnzKzK
	5UsiiICDEJoHLQ0bHx7brGk6gacCnnB3nNT9ocSQ7FGKsyyMY6yAIQpRv9c7ObQarzVFarrC6m5+p
	g/9m4ITg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55668)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1vOZhM-0000000059B-0iXv;
	Thu, 27 Nov 2025 10:58:04 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.98.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1vOZhH-000000002cD-2eoj;
	Thu, 27 Nov 2025 10:57:59 +0000
Date: Thu, 27 Nov 2025 10:57:59 +0000
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Zizhi Wo <wozizhi@huaweicloud.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, jack@suse.com, brauner@kernel.org,
	hch@lst.de, akpm@linux-foundation.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
	yangerkun@huawei.com, wangkefeng.wang@huawei.com,
	pangliyuan1@huawei.com, xieyuanbin1@huawei.com
Subject: Re: [Bug report] hash_name() may cross page boundary and trigger
 sleep in RCU context
Message-ID: <aSgut4QcBsbXDEo9@shell.armlinux.org.uk>
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
 <33ab4aef-020e-49e7-8539-31bf78dac61a@huaweicloud.com>
 <CAHk-=wh1Wfwt9OFB4AfBbjyeu4JVZuSWQ4A8OoT3W6x9btddfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHk-=wh1Wfwt9OFB4AfBbjyeu4JVZuSWQ4A8OoT3W6x9btddfw@mail.gmail.com>
X-Rspamd-Queue-Id: 7CD174000F
X-Rspamd-Server: rspam02
X-Stat-Signature: 7h9n8zssemqpu9rtac7yhiuzjiz4ydh3
X-Rspam-User: 
X-HE-Tag: 1764241095-750800
X-HE-Meta: U2FsdGVkX1815PtIp8a5RvJ8kDnXuMFoHY+2RyD64YBQ0zrH6uezj41PZ+QFExh4EVVw9QRltnoaS6j8Y+Sbxd5LGPCW3CH0Rw1+p7xZ/GGund7eLc/n//G5U3zz+WzYq/K0Z262031WSefcZVgzhhP6Z/YCGVws5U2ms65dMXhU1raMQAYyXzEwYppmkajk14t4kZdPyiDkvRnaTLYSOUdAq1jmkUfEtjkB1W0swOIuICC1U4kYX1qnta2Q5o1OGQ6eWyDDlnI63mrRZVRXThxDN6tj+u+KU8SMFF3eibIQ2pkQwjqFqwBVi0eWLTcbQWkVnjeswU/IYT/UqTLUV/7Mn9MdMjbgauzaI4sWjTo/feAGOQ68E0OewfDaPuDTnxVgZjAorfJsfOxhM4NB5RbxBV0iaTFAyor2O5r0tSCnnUWjGQHsXejbG/Rf0FjoFB5biP46IKAF5seguQT1s8PydG+sTHlaocp8/ZUTca1rljwXOzPtMnO0hE1f6fpXD+wAgTsGTJKC8Z6B1iXuc26ogJcpmtLsz3NJ36S14J404QSWMCcCvcIRezIagk1ixVeW55bsafglf0UlrhW7kOs9rMuMUAzufhp6rRbroRXJdaK+GcsQCSF9qfKM88PYsI2UBn8CAcugE858GORJ9tjTTmEW+bDi9xc18qS3oqw32cSso0TFDNewkZlLjcb4aq3qlQD5DyvvuyjYio0QOURRvrYHw12svdwX/CVbywXzhLMUItthlG0VGlxTc1384/sW0b9hQjgvccFiZEzCAk1K/+J1sPRGq4+YtIrzf9opFAT/hVV0pmQKVvp1HAyPDjkbSDAcNUgfxxP1ZSbSCqkmuAxin/AdiY8h3rdM/Xonkm1d2axiOt+vVVZT4i2Mei3lm+few2smVarh18vasCQLm3sXrAnV5xxOWu0fauDEjOlUFD74nmF5+Lu6V0cVCLsISMtX+VARljhaKQx
 42XMIZAv
 vUC2Emp2+y/aryvj4KfHZGEWmtrep+YDUn37udeufPnf29cyQFCUub1f8xy/qWPndQrdfKcCNE0sNiQW1tLLjf43293wphbxe/uivzq6bhFh4tobWyCn0WSidssZn54NNAAyF3jFt2xtMxLA61BkoT5jtVeOpgrm2JQEIpxUPj4/Wd35/8FAb1VVDWNvO3aonygnx2BmTpnB4F7Yh74ePWYDp8vGN1ZG0mXKOUIyYplMoJbBj4vBrQ4UPJVXREPGwFVcHIPfJbQ/GA375HirPBXAmb/e1xuu+crwhqBowMGZczGkU98ZfXbd9c25UgNBbtyd5NISHXvzT5vjoNQrobYS4ZPPdzldJNHRm0SKcpwv2EKhXqL3kLqEGVLg9UCC3cC8bu0MgMsqnFJZovBcAX4oxcnPhuc/ie21zagRTG7TGOXM3ObAurgAfvSrquz5pQOakovRl9fy3l81YQ2jigh0pBVI7HiARRRlfWAYDIuVM/8ZnPKEclind6/sqETSVhmHceQLJOSwMaP4meTJ28xV4QWFgh1CCgGyQKZ0VYQu2SiMQYqKA5f80Ra6BA43UC3Ra
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 01:12:38PM -0800, Linus Torvalds wrote:
> On Wed, 26 Nov 2025 at 02:27, Zizhi Wo <wozizhi@huaweicloud.com> wrote:
> >
> > 在 2025/11/26 17:05, Zizhi Wo 写道:
> > > We're running into the following issue on an ARM32 platform with the linux
> > > 5.10 kernel:
> > >
> > > During the execution of hash_name()->load_unaligned_zeropad(), a potential
> > > memory access beyond the PAGE boundary may occur.
> 
> That is correct.
> 
> However:
> 
> > >                This triggers a page fault,
> > > which leads to a call to do_page_fault()->mmap_read_trylock().
> 
> That should *not* happen.  For kernel addresses, mmap_read_trylock()
> should never trigger, much less the full mmap_read_lock().
> 
> See for example the x86 fault handling in  handle_page_fault():
> 
>         if (unlikely(fault_in_kernel_space(address))) {
>                 do_kern_addr_fault(regs, error_code, address);
> 
> and the kernel address case never triggers the mmap lock, because
> while faults on kernel addresses can happen for various reasons, they
> are never memory mappings.
> 
> I'm seeing similar logic in the arm tree, although the check is
> different. do_translation_fault() checks for TASK_SIZE.
> 
>         if (addr < TASK_SIZE)
>                 return do_page_fault(addr, fsr, regs);
> 
> but it appears that there are paths to do_page_fault() that do not
> have this check, ie that do_DataAbort() function does
> 
>         if (!inf->fn(addr, fsr & ~FSR_LNX_PF, regs))
>                 return;
> 
> 
> and It's not immediately obvious, but that can call do_page_fault()
> too though the fsr_info[] and ifsr_info[] arrays in
> arch/arm/mm/fsr-2level.c.
> 
> The arm64 case looks like it might have similar issues, but while I'm
> more familiar with arm than I _used_ to be, I do not know the
> low-level exception handling code at all, so I'm just adding Russell,
> Catalin and Will to the participants.
> 
> Catalin, Will - the arm64 case uses
> 
>         if (is_ttbr0_addr(addr))
>                 return do_page_fault(far, esr, regs);
> 
> instead, but like the 32-bit code that is only triggered for
> do_translation_fault().  That may all be ok, because the other cases
> seem to be "there is a TLB entry, but we lack privileges", so maybe
> will never trigger for a kernel access to a kernel area because they
> either do not exist, or we have permissions?
> 
> Anyway, possibly a few of those 'do_page_fault' entries should be
> 'do_translation_fault'? It certainly seems that way at least on 32-bit
> arm.
> 
> Over to more competent people. Russell?

Ha!

As said elsewhere, it looks like 32-bit ARM has been missing updates to
the fault handler since pre-git history - this was modelled in the dim
and distant i386 handling, and it just hasn't kept up.

I'm debating whether an entire rewrite would be appropriate, but I'm in
no position to do that at the moment for several reasons:

1. I've now very little knowledge of the Linux MM, there's been many
   changes over the last decade that I'm not aware of, and my knowledge
   of modern things like RCU, kfence, etc is practically zero.

2. I don't have a 32-bit ARM platform to hand to test on.

3. I've not touched these parts of 32-bit ARM for a very long time, so
   my knowledge there has severely bitrotted - E.g. I need to review the
   FSR codes and what they mean, because that knowledge has now
   evaporated as I've not had to use it for getting on for two decades.

4. The arm32 code has been modified by others in ways I don't yet
   understand.

I'm wondering whether Al's solution would be a reasonable stop-gap, but
I can't say whether it would have any side effects, so I've asked for it
to be tested so we get some idea whether it's a possible solution.

Basically, I'm afraid it's going to be a steep learning curve, and thus
won't be a quick exercise - expect it to take a month or more as there
is Christmas, and then I likely have medical stuff at the beginning of
next year.

The reason I'm suggesting a rewrite to something closer to x86 is that
we then have a familiar code pattern that's much more likely to be
correct going forward for the Linux MM requirements, which should also
make it easier for MM folk to understand.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

