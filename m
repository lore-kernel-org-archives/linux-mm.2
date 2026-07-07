Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20296C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 19:16:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB44B6B009D; Tue,  7 Jul 2026 15:16:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A652D6B009E; Tue,  7 Jul 2026 15:16:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97A836B009F; Tue,  7 Jul 2026 15:16:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 64DC56B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:16:06 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E93E6168F79
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:16:05 +0000 (UTC)
X-FDA: 84962935890.03.F1D5335
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 658C520006
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:16:04 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S+MYElig;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783451764;
	b=SlWBniVlTndPgjgGnsyiAWeGvZNHKTdnqTKwZ/sRr3rUl/MylwFSHO2LxHGXzDXPYmAen0
	SS9gxCzFvlBuWB275hutWxbjJJOrfJtx7Qg06nwW3jnsEbGprpXm6sro5Rf6KBuVFEX4Ta
	qJ4A8dVsDRN7aoC2GR3Dr3CWVW9wvuI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S+MYElig;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783451764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LurUoFlksu0iHTOZFjUCHWNI5YLKr1ommwx8975HPUY=;
	b=ShF6L1+mB3OwEyYkuuzfALeyTd60Jlw+/QQjdpTBUG7s5eAaJvxo8a3Eq6XYvprPVJXi9u
	gaEe2d5dlC9I8j29dD5BNuFnWBwq5ExD8LfUtj6POD3MEvle1VoO/2kuz2EJCciSpUZozy
	MUcn0eVNiNWvtulbGil1aZ1U19BUDWk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EDF2760018;
	Tue,  7 Jul 2026 19:16:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2111F000E9;
	Tue,  7 Jul 2026 19:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783451763;
	bh=LurUoFlksu0iHTOZFjUCHWNI5YLKr1ommwx8975HPUY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=S+MYEligJcni74qa/hJeahb0ju+jbDQeyYLcJBszHm2orBDAup/lw9IOwqk5Gct24
	 /GNnUgxLlQ5Tqj8aHLX7fdyAlDX31heB5XlSfZk7aHvNhP+8Me2UJpPKSgNtymlWE8
	 Bc1YQsy7+lAX7g++4GO7UUhfp4FnZvslok7AXZoV2PNIFQfGL/YxCMWFY4XCbJKBlL
	 DF+KzU0tbBM0Jr/jpXhuqCgefyQ3MCpljit8Ff3lHDXab6pGHEQ944HjGX43Wy+9G8
	 fikcykz8DqsP/cn0DeOIY1JPCY0pU0IjynsLyWCbX0jo1Jo1DWOraEXfzezhmGmUef
	 +1r320RTv8Ylg==
Date: Tue, 7 Jul 2026 20:15:53 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Hajime Tazaki <thehajime@gmail.com>
Cc: geert@linux-m68k.org, akpm@linux-foundation.org, willy@infradead.org, 
	liam@infradead.org, vbabka@kernel.org, jannh@google.com, pfalcato@suse.de, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, gerg@uclinux.org
Subject: Re: [PATCH] mm: nommu: point to the write iterator upon split_vma
Message-ID: <ak1PTRH3Ee7XyMAF@lucifer>
References: <20260702012546.665383-1-thehajime@gmail.com>
 <20260705152708.582fd8d87561f600da23c0a7@linux-foundation.org>
 <aksn5J8Nr0JIsVpQ@casper.infradead.org>
 <20260705222343.5d5c78cbb54839c5efcaabf5@linux-foundation.org>
 <CAMuHMdU36O2UqfQkbbgOVSH5KFU-MZ_WO3jRsLumkUu22iC7vQ@mail.gmail.com>
 <akuS-6zegY2XBa3f@lucifer>
 <m2o6gktgvk.wl-thehajime@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2o6gktgvk.wl-thehajime@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 658C520006
X-Stat-Signature: 9srgxmbr7ygxssk1rxqz8fdsb14zpfoy
X-HE-Tag: 1783451764-39057
X-HE-Meta: U2FsdGVkX1+lvxIr+vRHJP6RjhH4oUemstGBhUDTR181+kVGjjfkMiXeXelDLORgPca1PDHn/VGFfVFbdqqZUXaMnJ3mdF1rBj5NXqtBekgpNO/60fFsh7KpCuEDtvKRyYH4+5LKdDtmBCsxyKhx8Rz+lswmF2ow9sRbW6jgGDo09YpG/k5FUlR4G1cB02k7ZzorKcGwgaHVFMtPBJH92+xnavUS6G8pXJuYmu0Gsntua9UMrEqJxYT8mkedv0ETTAJaVSd8gGK5BLQIrGEtww75vuqaAH7oMQnDP8ZMCxDpAV1RnSm82UEtj0w40gP3yhDVx9ne80EnrLMB3MMXxptF0NbYlEA0euq+fHLefHx4yCkUy26C1lrZu484HC8YgBtpBq/zbkejmRZpzNqvq6yRzo+ivVxpMZpm2wZ6V6lMEiZZ9zFoVd0o2D6SdZFdRW3bD3FMPmQV2ilH59bSTwYODeAOPmmoGiiAj88C/atNvAPA/EOApNlss7L1Q9FCF3+cMcYN4WDuiA33fBnTba3JBc1+H/yssxL0ulTQ02LMMvmHTytwL+aQ6Vpbv/hNxGYRFC319J4ER7MYOAcGOVTqG88YLvq0A6lk9Pj38v6sig/juuaYhRZN05tJnB5YthJQvmr2DQNTx8RPWL3ZHsmkpZcVhx7EFonnQKA1fPO9DhdqfYQaOVFJ+W5VYlmb3VaznJNqY0m9rL+TfBummj0/qrRLeLv7LBmhmL2MZoaSJ+LHl8WBH1DDr5P5pxa9pBEgxqLNgaPrEVFlfVe8B9lotSAZQyG5gfh/cmslP1AQAjmi8cXtrIFuswR43XPKtJw2ed/qGW8qApTN/2MEiohnSzxBBYYGaPwCoW3+p/eXkFKOhOM5r5191CxEAzVU1wuMJ/M0WhTrtEqMDowN0vcpH9OBOrWWSiicgihy0Rl9TtVdgRj3pn9UzAAx5aMOAbeE7VjE0fUFJvhAJY4
 HcWmyUlH
 FOjRsaOKEheb2T4OgTkB4HM1O+13yVEIFZ3sMQuayxO0bZ3/vRQeYm/DSczre+skk2ZHBJEyR3V3Mpas8SNtKuDxOYQITfGPM/5e4wDw/qAqpORsyVtAHQTugXHocOCurPR7Pk/OSiCbgtB/8r9+UDk/bIIipphhen8Qhf0xd5QEhY/KT81iEGK0q2tOMhyukXf1tn5ocORyhsWxuGojZHyOk/KsnfFO7WaS6HHTkfcrKu8f4NvuZrH0+5ildaQdeHh3lt61sq81aLodP+mmujS8fY8SpUbXBTo7ec0Vs8xthCkxk1XU59CA/IV5fVVkG+DhJdqyXo0LxchLGdlpJuQsvHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 06, 2026 at 09:57:51PM +0900, Hajime Tazaki wrote:
> On Mon, 06 Jul 2026 20:51:36 +0900,
> Lorenzo Stoakes wrote:
> > This crops up now and again and people point to uses, but fails to address the
> > real issue here.
> >
> > Nobody (aside from Hajime - thank you!) who uses nommu maintains or contributes
> > to it, or _even tests_ it as far as I can tell.
> >
> > We broken nommu for a year I think it was? And there wasn't one report.
> >
> > The last time I raised this, I was admonished and told there are critical arm32
> > nommu devices that absolutely _must_ have the latest kernel and this is
> > perfectly working code.
> >
> > And riscv also introduced (and I'm so very surprised Linus allowed it) a brand
> > new nommu architecture (!!)
> >
> > And yet...
> >
> > If this is really so important, can those who care perhaps help out a bit? At
> > least with testing?
> >
> > I'm a bit fed up of it really.
> >
> > As far as hobbyist retro stuff and upstream goes, I am sympathetic, I came from
> > being a hobbyist (though not retro), and would be one again if I couldn't do it
> > as a job.
> >
> > But retro people do NOT need the latest kernel. As far as I'm concerned, museum
> > piece support should be ripped out, and those who care run downstream kernels.
> >
> > As for the 'critical products' that must use nommu - PLEASE start
> > contributing. Please start testing. Anything.
> >
> > Again thank you Hajime for doing the one thing that really counts here -
> > contributing to the nommu code.
> >
> > Anyway, as to what Matthew said - 100% I am for us ripping it out.
> >
> > But it's not up to me, and unfortunately I think we'll get a clammer of voices
> > saying how important it is, and silence again when it comes to do any of the
> > work.
>
> as nommu started for embedded devices which are not easy to test, I
> agree that it is also not easy (in my opinion) to maintain.

Indeed.

>
> indeed, buildroot images for nommu targets (with qemu) are available,
> but running/testing each of commit to the kernel tree give me more
> than 1 hour to rebuild the images (including userspace build with long
> flat binary conversion, etc) (which I'm playing under github actions
> with riscv-nommu).

I've struggled to even get the buildroot images to work in any way. Right now I
don't have a clear nommu test setup other than building nommu_virt_defconfig for
riscv.

>
> # yes, should use ccache :)

:))

>
> one of the goal which I am with nommu UML (*1) is to provide an
> environment which can be tested in a simple way; runs on x86
> machines.  An extension to UML means that you can also use KUnit
> infrastructure.

Yeah.

Well indeed my raising the 'please let us pull this out' was initially a push
back on that, because if we were going to pull it then that work would work
against it, but then it became clear that that dream wasn't possible.

And that makes your work on that REALLY REALLY USEFUL :) so do cc me and ping me
on any respin and I'll try to find time to help.

>
> LTP (Linux Test Project) dropped the nommu tests 2 years ago (*2)
> (which is pity), but the reason is similar: no maintainers appeared
> when the project asked.

Yeah and it's just the same thing overall with all of this.

The companies who are apparently dependent on this need to _actually pay people
to do some even rudimentary testing_.

nommu.c is co-maintained by me and Liam simply because we have done more to fix
issues with it than nearly anybody else recently. It's just a burden that we
took on.

I'd far rather see an invested mm person take over if we do indeed have to live
with it :)

I also wonder if we couldn't find a way to implement it in a more maintainable
way, perhaps as a 'virtual' mmu system somehow?

I simply don't have the bandwidth for that myself, unfortunately.

>
> I wish to be here to improve this situation, both mm/nommu subsystem
> and LTP, as well as any !CONFIG_MMU code in kernel tree.  This patch
> is actually discovered during LTP (re-)integration with nommu kernel,
> which I'm going to propose to LTP.

Your work is appreciated and welcome, thank you! :)

>
> I hope this helps a bit.

You're definitely helping here and again, much appreciated!

>
>
> *1 https://lore.kernel.org/all/cover.1770170302.git.thehajime@gmail.com/
> *2 https://lore.kernel.org/ltp/20240105131135.GA1484621@pevik/
>
> -- Hajime

Cheers, Lorenzo

