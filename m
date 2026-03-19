Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4864A107527B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 08:54:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 832BB6B0444; Thu, 19 Mar 2026 04:54:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F2476B0446; Thu, 19 Mar 2026 04:54:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72FAE6B0447; Thu, 19 Mar 2026 04:54:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 64D4A6B0444
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 04:54:55 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E61548AEB2
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:54:54 +0000 (UTC)
X-FDA: 84562202508.19.716139A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3553A120002
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:54:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O6U2cjkk;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773910493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6z+I6483OhcYwZxA/naeEXIuM929SDkNzN2rugXmY0Q=;
	b=t/5WI5hf1J5ul8quyYlwOLaJr5PTURHgh9sdQFlXttynYqtnkSHI/1tXD60A+f8Iy5pjdg
	ho9smGqPdWP4ZYPqD7zSCqWwqVQxxVeCffKGOGr1mbDFVguNaDV/RiEJmeTxopLD+R7mJd
	lfbRMsaEEEIsV7JrFoAoQjYlvJPDXxU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O6U2cjkk;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773910493; a=rsa-sha256;
	cv=none;
	b=5x1YlsOURb8kqPi6/pQdurXhtzjd28vW13i3MCeeamTzPaDksg8xIcZJZfo9fVGPBpemzA
	nBgjHgy4K957Xa+dH67FDy4LZq98uQLoJYH6y3M7+hhn1+8Zz1KBILsA+Wsc1dvNnSPVbW
	3ZerlleWdGxdgyIXByI0YxuxnleZpqg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 500B0439CC;
	Thu, 19 Mar 2026 08:54:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96360C2BC87;
	Thu, 19 Mar 2026 08:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773910492;
	bh=AMMk6ZlxyqbYCyt4WjwUDqMkax6dZO8ndEuU0L5kld0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O6U2cjkkjqvvzVRgPI7mrb0SH0cTEBRklGrtxT8bPJlXDT1ofkanb0tWhzziK1w1s
	 4PA3i9hCLjN90SI0AMW2vOezl1grzFPt3T9asDtPfVkTwjDfax6AJa87BFV1vS+oRn
	 LEvxnIuoSxl1jfswYEsMI6Q2KDiF7qhOJhfu5GhttIogXWJJ9FlFbKTuFB0J8r/BAb
	 d8yX2NusOr+tZZ+cT7qcndPQhwrmWmvWIkTN2jxi1pQyuEzeDF4DDbb/BnNBiLeRlr
	 SOuTDx1+L+/97EavxJIdrA17e4LY93LeGKAjpNE1AotqIvwyavO+UbZlb2pgmSUa/C
	 mJXkq8tQraGGQ==
Date: Thu, 19 Mar 2026 08:54:45 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: syzbot <syzbot+de14f7701c22477db718@syzkaller.appspotmail.com>, 
	Liam.Howlett@oracle.com, akpm@linux-foundation.org, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, david@kernel.org, dev.jain@arm.com, lance.yang@linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, npache@redhat.com, ryan.roberts@arm.com, 
	syzkaller-bugs@googlegroups.com, ziy@nvidia.com, Harry Yoo <harry.yoo@oracle.com>
Subject: Re: [syzbot] [mm?] general protection fault in zap_huge_pmd
Message-ID: <2355172e-d696-47e5-839e-16f1ae5373ba@lucifer.local>
References: <69babeba.050a0220.1b2d94.0003.GAE@google.com>
 <6b3d7ad7-49e1-407a-903d-3103704160d8@lucifer.local>
 <abuNkfv8c1IrGk0E@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abuNkfv8c1IrGk0E@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 3553A120002
X-Rspamd-Server: rspam08
X-Stat-Signature: z4uirgb8t3id5m48m75x9go7i345n7zc
X-HE-Tag: 1773910493-850495
X-HE-Meta: U2FsdGVkX1/r+TeziOMW7+neiD/ZuCmq0KkzeQ8j6X7NOXqR2Jo75YbTCoM4LpwM4EdaGvMhb+2pvqRm/Rhx/aOWQpwdmJEJE+Ua/gwUQxGKV4EpPYK+WlVTQVx6yCpMaU4JNljpbFUWzXkDDNG+gOEs6x3NKjC7+OmzAXc54hXGARwVbFkDGExZGyBABUgKYWYmG4ipbRxhYFgEUa3GPcZ/JV6fyqkCP1xcQfeD7le/ugwDXyPXbdUubLt+tvaVnO+RX/YpK91qdkwubRPBbFQwW0rqQPwBrKamUfRA4606yOen5+eL4L/835toK2X6QzXfMpXISE2EXhlqHPnR5ASh0QE1c5bmLBQygiYTKoOfZ6tp6wtkV31aTWUCH9G0oYpnMGNBnGLVZCKe8bkrkItqj9chfr95MRggaO8hsQyObZkfSjizqs5FfLiwTWMWEL2d/9lv4hkAGRCsW9Ub2D1DpWNNxzvTklFyCU4PJqfdod85iCSLcB8Hpv2L2wmgE5hv8YzZSi/jYKIdNdvE1UHHbYsnk0yxUq4KOty9a++W64v6wBC766M91FZE18YliKpzz+u5/FKz6rtNyfBgFWNqERzUVcuT7n7vcB3X5FA9V02JpI1MTX4NdeYCmvfoYCboi2Szy/MtBAYpBRcYDsbCf97pzHzDj0NvyamPKinusye5zuPobecLDidiMhJO2VDKTEx6aJmxtPRn7lsad/2lkViz/hoLxjtYq6xDPSujp3s8g0HM9D3mn45XY6l9MtoQGn3QKo5jdMQPk1yUdx+ks0LXwFHYcmolxdA/S7Y1Xkof8Uapxnh2iOe+Hizyf3HgKD4obnXdZpQbdzZE4Qt+T4WnkpKxz7ss9vy0M8MIbwulyvD0YLSIb2JfVlHipaeTiyczobhcBaW89CGTsiJ/lWyut7giXfGDDhqNx19VjyHg31ksc0VmmDQEAPzWXZhgR3onzY+W3HJhFv3
 xQjVF/x0
 BVZmvAXol6Up/Qe52GpZm+eF41FawDaRPCxAYAOmFSMVNnFOfay2pfiyAaeEenuRuLegesIyEY2UBRAvXFLaL1FQzZ+vqAkl01zyjc4e9TgHjvfamfUZ6ggklcZdfPz91/QkPE1F7tJ1e1awsAAI23QK7BxK1dOhrqFut+4/cbha22KQtKhKDqo6TGMfwPPLkdqdXeb0C2Tpn3NbfubmqlVCe9E4m17N4XwWBDF+K0K2pN36WujgGHN733Rs5HlJqXp5Nz/GUZerw1BaaXPTLGAW4BpDP126r+9FyWOSqUno7D99pJjbtWG+7wYttEGnRR9CcUBMdQf4o9D/ZpButprupepdxoEievibnxccXe45X5knf7OEVPiENhb8b3Yfk4XIXBjwJf83cn2C7i9AzIxFiLq3L+iXjaF73cB0Yj8F8w9QRdd/5tq/lFsk+GtkKO+fpL4tKy2kyfTSAQYZ3ES73UD/nsdV5NlHzrWEcZ9W8HxWnYRv9Ibqqln1xAwDsZRFbHqkHUUO5TUf2BlcqBcgUT6UgRHJLUyRcaRj+nfCN8Tcd76BZ9JBY8dAD2hWPlY+G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 07:45:53AM +0200, Mike Rapoport wrote:
> On Wed, Mar 18, 2026 at 05:26:32PM +0000, Lorenzo Stoakes (Oracle) wrote:
> > +cc Mike for uffd, Harry for fix that also resolves this, see below
> >
> > On Wed, Mar 18, 2026 at 08:03:22AM -0700, syzbot wrote:
> > > Hello,
> > >
> > > syzbot found the following issue on:
> > >
> > > HEAD commit:    b84a0ebe421c Add linux-next specific files for 20260313
> >
> > For some reason I have to git pull --tags to get this... commit hash locally?
> > Strange.
> >
> > > git tree:       linux-next
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=119ddd52580000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=e7280ad1f68b2dce
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=de14f7701c22477db718
> > > compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=173b44da580000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1537b8da580000
> >
> > @SYZKALLER guys:
> >
> > Note: the repro is incorrectly labelling;
> >
> >   //  ioctl$UFFDIO_CONTINUE arguments: [
> >   //    fd: fd_uffd (resource)
> >   //    cmd: const = 0xc020aa08 (4 bytes)
> >
> > as UFFDIO_CONTINUE (0x7), it's actually UFFDIO_POISION (0x8) as you can see
> > from least-significant byte.
> >
> > It's also stating things like mmap flags wrong e.g.:
> >
> >       /*flags=MAP_UNINITIALIZED|MAP_POPULATE|MAP_NORESERVE|MAP_NONBLOCK|MAP_HUGETLB|0x8c4b815a506002b2*/
> >       0x8c4b815a5465c2b2ul,
>
> As Andrey Vagin pointed off-list, you can run strace repro and see the
> syscall arguments quite nicely :-)

Yeah, but we really shouldn't need to have to :)

>
> > So Harry's fix resolves this,
>
> and that's the important bit ;-P

Yep

>
> > but we should handle this case better in zap_huge_pmd(), I will send a
> > patch for that.

And already did this ^ :)

>
> > Cheers, Lorenzo
>
> --
> Sincerely yours,
> Mike.

Cheers, Lorenzo

