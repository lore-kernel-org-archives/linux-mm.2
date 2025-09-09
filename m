Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2351BCAC582
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 21:39:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 549CE8E000B; Tue,  9 Sep 2025 17:39:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F96F8E0002; Tue,  9 Sep 2025 17:39:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E8788E000B; Tue,  9 Sep 2025 17:39:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 25A6A8E0002
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 17:39:25 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CDED7C06FB
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 21:39:24 +0000 (UTC)
X-FDA: 83871028248.05.D9948A8
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf07.hostedemail.com (Postfix) with ESMTP id 70F4640005
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 21:39:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025082201 header.b=iLlu0zmi;
	spf=pass (imf07.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757453963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d35wP3Cgy69ResBPuaBSz/HcVF3uFe2H17r48V0f8EM=;
	b=GUADjnZ5t2Yu4HhUrJ/Zz3+7U5Dkr8WnW15QwQ44hgPoeVaiQCuzGjrbRTfy4odg0QSWY/
	g1O49Fdeuk/R58F7gP/kgpJr4Owx/8NuSp86OmSDAItboNJawJH6Vc8zDjyPN+VsZ8NdMk
	d5NVktVzQ0PmZy/Wurr8pU+WgpVrl0o=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025082201 header.b=iLlu0zmi;
	spf=pass (imf07.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757453963; a=rsa-sha256;
	cv=none;
	b=b9o4uS5rvzHWTPKOxVjwFVIFoBZaPC+3Pk9CLlzwqsAfaudEG5V+HY9b99Fh67pz8SJyll
	Lp1NM9s2j9vs/+i99M+6/lICI2uitsnz5dijatvimehhIOT2rmF64r7m7LPRFnlkP/Lqfm
	UWkl3UgoCPeHLWoVFxKBpQUFijfT0o0=
Received: from ehlo.thunderbird.net ([172.59.161.83])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 589LcmAf1745963
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 9 Sep 2025 14:38:49 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 589LcmAf1745963
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025082201; t=1757453930;
	bh=d35wP3Cgy69ResBPuaBSz/HcVF3uFe2H17r48V0f8EM=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=iLlu0zmirgiX0pTGzUb54KHRqrVLR14BLuI3IIHYMRvzodvhGUHYQJxvyBBAh2zMx
	 rJBg+/ijGWNS/iiRIuOVMWtzyVDp3uwwlXjZaePALbSCZp3Wm1SYLf+o9+e0KkreG8
	 60rBPVI4lfP9py1MvyVLbRZ1g3lqUK9nt7ZB6NARfDrOLqb0DXfiKPD/egwa7b1RAq
	 pJ7ckPFsMlrho0F6vzsw7uXIktWTJ6vQddjyYxOLtu56BAN2NGZD8QxYpYTODUg9ld
	 26t/cf2rSkp4iVMPrhAZ5a1JTSRZhKsilx9oNgR/W76XC/iyYNDjoLDkTj1H+wnX+K
	 NncRWZvJVVp7Q==
Date: Tue, 09 Sep 2025 14:38:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Arnd Bergmann <arnd@arndb.de>, ksummit@lists.linux.dev
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org,
        linux-mm@kvack.org, imx@lists.linux.dev,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Richard Weinberger <richard@nod.at>,
        Lucas Stach <l.stach@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        David Hildenbrand <david@redhat.com>, Mike Rapoport <rppt@kernel.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>,
        Ira Weiny <ira.weiny@intel.com>, Nishanth Menon <nm@ti.com>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Alexander Sverdlin <alexander.sverdlin@gmail.com>,
        "Chester A. Unal" <chester.a.unal@arinc9.com>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Andreas Larsson <andreas@gaisler.com>
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
User-Agent: K-9 Mail for Android
In-Reply-To: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com>
References: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com>
Message-ID: <C85C32F4-BD58-460B-ACCF-F0569ED0941A@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 70F4640005
X-Stat-Signature: gtmuwgyn9q5yk31stz9hq11bjh9kbbb9
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757453962-611675
X-HE-Meta: U2FsdGVkX1+I34MreDtoH+6Vs/tStVxBuTpIb00mHYS5kSWu5+oh56Mzs5hyZC84Jtg92LtiUlLerXjsNd1oepKmWdbjFxkH9x+/jQECv6Mm2Q1oHDfW4i6EGjEE2NSaG8R4yv7Pzrm5rYxkYmgP+5B8vjUpeW0h6qzemcvEuKA4crl/VA931+lT3EnkCLvi0zQyXICyKFbbZyQnENXfALw0JeDieyzlNxYqzz8aRF9hpRKhczfq4ObVPFR2BoCl4MVKOPFLr1W864Y4XV8FNa8+O3Ms3Y+mOzEGMMKmeOobbtSexG8MRLHWQAds0Ax/vRO8bKK8MeIuseM23BSR9DRc+8pTaR11dmWaXDRvNr/32SXewWmVhcx91dcmVyV6cNkvHpPSjZLhWSUWgum01EICRRT1J3V6s/sfxwtWAduPytWD2j6JWoFdicpoGc+MMldheOOsXRUotUQq0urM+0KmgGlYjSl7K4/iO1gl2dU/HVWNEJmq8fBZufjpTxVtXd+9NIgIPXIUkOvIfCp3ZctULF4qs/zN/erXrz6R2IyV08/WYOsT9/2Xzgozu5qcthD70tdbd6ccYCvGBT3F3BZoN24Jwa9pkpuT7f3MkyMX0Xnfy/9ULXemfWUlKktYGLKyy7q78TY4phkZvqT3cboKsMYvckuX9x28mJQV6Xkc5PyhgedX4bZkaenUMU/LXVODbvLZjmwzBtRTbgJFeYM8SMh4KVlhADV8n1+qIygL6IDRP5AG+gav8rSTFg3WbVOYjiN6UoPWt+QoX9HZNG0UwJLeI6U2OBjuqYyymxkvrFg6gnhEi+ALyWTiShW+Aj9Xoyyyn7EjGPeIh6C/Hyu6qThp9FqB2qlZOxmXwqqG0vNdl408zw2BvTwzEkVNsJttSDr9j0Gf6iPPfyB6S8ZqeC0eqVHB6yq8fvW0t3XYrE27fZ/DjjfB97a3mkGcCYEB3Gkq2+cTWnk+F2X
 3BmGKoET
 iIFvhO5VASv3nHqoAxQQ5w6Rfd3V9CdkLYaxIIEJeLNTVFu2J40EIvry4rx34PbVGEmq1pqG+Pw8EeKNosMBczf9/Y6slhDy/cFptAbuhls7H0YWT94c2mnQOqnF2tW7upwSV/2bXPD20uY+CvPbDUphPRhc6UFHFgVvWI8EY8nJnV5Ps+1yS8IKfPraU9Ug+K35acuX8X1gyamNM29ivLFslH0miQdeTJfIhBJhjLaVOyPCMbaT/LwCDMEiL8wAWVbe4NFAe9/IzpMgQrnjMOJEuJY6VBktwNvd28ftTexbLFg0g/ELl5Y6QIMRIBFiJCDYK0Vbm2BTLbRNGdDN62YoCvwMrDN12dX6IMLFP7C/VMwxJD7O5K6AqoTiFXTwikAf44c0JRt9OvIo9ZpKgSGZHNHZqA2si74MNCpmIy1giQAMdnJawkKrpdJRs8df8ddNWRe9TweVYQJj2pVVvSnwynJFSDaTydGHMfxmNI1luFgd2XjEs9nLn2MHMDbt7+SPcbfJFL9vn/lc2yWb80PZGz74RQ2O2e5eGEfjEWSa2blUtMHfsx8Iebr3qNCjVjbV4gcycg0xWWvgQFWgQH6E2ladeRaUrr9ZPn2ziff4OZtx9Wx8K/0twu0G8q8+upBwmGhxfKo8JzudeQ0b2c+gbGDMwmqgxHpb2x3tBxYgsr+KYkBypIocbbVpGOSQnEfba/lbunA0LxUE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On September 9, 2025 2:23:37 PM PDT, Arnd Bergmann <arnd@arndb=2Ede> wrote:
>High memory is one of the least popular features of the Linux kernel=2E
>Added in 1999 for linux-2=2E3=2E16 to support large x86 machines, there
>are very few systems that still need it=2E I talked about about this
>recently at the Embedded Linux Conference on 32-bit systems [1][2][3]
>and there were a few older discussions before[4][5][6]=2E
>
>While removing a feature that is actively used is clearly a regression
>and not normally done, I expect removing highmem is going to happen
>at some point anyway when there are few enough users, but the question
>is when that time will be=2E
>
>I'm still collecting information about which of the remaining highmem
>users plan to keep updating their kernels and for what reason=2E Some
>users obviously are alarmed about potentially losing this ability,
>so I hope to get a broad consensus on a specific timeline for how long
>we plan to support highmem in the page cache and to give every user
>sufficient time to migrate to a well-tested alternative setup if that
>is possible, or stay on a highmem-enabled LTS kernel for as long
>as necessary=2E
>
>These are the assumptions I'm making, based on both what I have
>presented in my talk and feedback I have received so far, let me
>know if something is missing here:
>
>- Highmem in new kernels is almost exclusively an embedded Linux
>  topic=2E While there were a few late 32-bit desktop and laptop
>  systems that had more than 2GB of RAM, these were fairly short
>  lived and have long been unsupported by both the originally
>  shipping operating systems and most Linux distros=2E Notable
>  Examples include Pentium 4 "Northwood" desktops (sold 2003-2004),
>  Core Duo laptops (2006-2007), and Arm Chromebooks (rk3288,
>  Tegra k1, Exynos 5800, sold 2014-2017)=2E Some PowerPC G4 Macs
>  and Atom Netbooks could be upgraded to 2GB=2E
>  There are a small number of users, but they really love these
>  devices and want to keep them alive, especially since they
>  mark the peak of the respective 32-bit product lines=2E
>
>- Within the embedded market, highmem is mostly used on ARMv7
>  based SoCs, but a few others also need it and still get kernel
>  updates:
>  PowerPC 85xx, 86xx and QoriQ P1/P2/P3/P4 (produced 2003-2021)
>  were used in some long-lived embedded systems with 2GB of RAM
>  or more=2E Mediatek MT7621 (MIPS32r3, introduced 2014 but still
>  sold) needs highmem to reach the upper 64MB of the 512MB physical
>  memory=2E Ingenic JZ4780 (MIPS32, released 2012) was used in the
>  short-lived MIPS Creator CI20 with 1GB of RAM (256MB lowmem)
>  and probably othes=2E Sparc32/LEON seems to be limited to 192MB of
>  lowmem as a kernel design choice=2E Vortex86DX3 supports 2GB
>  DDR3 memory=2E
>  The kernel also supports highmem on ARMv4, ARMv5, ARMv6,
>  PPC4xx, PPC82xx, PPC83xx, ARC, CSKY, Microblaze and Xtensa,
>  as well as additional MIPS SoCs,  but so far I could not find
>  any indication of any such machine with more than 1GB that
>  keeps getting kernel updates=2E
>
>- The vast majority of new embedded ARMv7 machines have 1GB of
>  RAM or less, which on many SoCs is a physical limitation
>  a narrow DDR3 memory interface, as well as a cost tradeoff=2E
>  The 1GB case is interesting because that usually means having
>  only 768MB of lowmem plus 256MB of highmem, as well as 3GB
>  of virtual addressing=2E I expect that almost all applications
>  on these work just as well with CONFIG_VMSPLIT_3G_OPT, changing
>  the limit to 1GB of lowmem and 2816MB of user address space=2E
>  The same thing should work on x86 and powerpc (CONFIG_LOWMEM_SIZE)
>  but not on mips and sparc where the limit is not configurable=2E
>
>- A few Arm SoCs have sparse physical address ranges for
>  their RAM, e=2Eg=2E range per memory controllers like the Renesas
>  R-Car Gen 2 or Broadcom BCM4708=2E These currently require highmem
>  even on configurations with less than 1GB RAM, until we change
>  the way that sparsemem is handled to support rearranging the
>  linear map to fill all of lowmem=2E This still needs more work=2E
>
>- ARMv7 machines with 2GB remain in production, in particular
>  with the popular i=2EMX6Dual/Quad chip that has a 64-bit wide DDR3
>  interface and guaranteed manufacturer support until 2035=2E
>  This is the configuration I expect to see struggle the most=2E
>  Setting CONFIG_VMSPLIT_2G or CONFIG_VMSPLIT_2G_OPT should work
>  for most of the users but can break if an application runs out
>  of virtual address space, so this does require extensive testing,
>  and possibly user space changes=2E An example of possibly affected
>  userspace is Firefox, which needs more address space than other
>  applications but can perhaps be replaced with another embedded
>  browser=2E
> =20
>- ARMv7 machines with 4GB and more exist and keep getting
>  kernel upgrades, but to my knowledge are not in production any
>  more=2E These are mainly 2010-2015 era chips based on rare
>  out-of-order cores like A15, A17 or PJ4 that were designed for
>  low-end servers, chromebooks and network equipment but replaced
>  with 64-bit chips shortly after=2E We had planned to bring a
>  CONFIG_VMSPLIT_4G_4G option to ARMv7VE to keep supporting the full
>  memory at a performance penalty, but currently have no plan to
>  finish this (volunteers welcome)=2E
>  There is still some hope to keep them working with a combination
>  of CONFIG_VMSPLIT_2G and a modified ZRAM that can use high
>  pages without CONFIG_HIGHMEM, but whether this works depends
>  a lot on the application=2E I expect most of these products to
>  stop getting kernel updates in the next few years due to aging
>  hardware and increasing cost for updating out-of-tree patches
>  on platforms that are not fully upstream=2E I do not remember any
>  such devices with official support beyond 2030=2E
>
>My proposal based on the above assumptions is to gradually phase
>out highmem over the next 2 years for mainline kernels, obviously
>both the individual items and the timeline are completely up for
>debate:
>
>1=2E mark CONFIG_HIGHMEM as 'depends on EXPERT', updating the
>   Kconfig description to point to the kernel summit discussion
>   any any decisions made here=2E
>
>2=2E Change the ARMv7 Kconfig defaults to CONFIG_VMSPLIT_3G_OPT
>   and HIGHMEM=3Dn, to make it more likely to find possible
>   regressions with that, without changing much for users=2E
>   Possibly do the same for x86 and powerpc=2E
>
>3=2E Start removing __GFP_HIGHMEM from in-kernel allocations
>   other than the page cache, in particular from individual
>   device drivers and filesystem metadata where there is
>   already little benefit=2E
>
>4=2E Remove HIGHMEM as an option from platforms that are thought
>   to no longer need it (arc, armv5, ppc4xx, ppc82xx, ppc83xx,
>   csky, microblaze, xtensa), mainly to validate the
>   assertion that these use only lowmem=2E
>
>5=2E Split highmem on zram out into a separate Kconfig option
>   that can be enabled without CONFIG_HIGHMEM or CONFIG_EXPERT
>
>6=2E Finish the "densemem" replacement for sparsemem, ideally
>   allowing both very sparse lowmem areas and a boot-time
>   vmsplit selection instead of the compile-time one=2E
>
>7=2E Finally, remove the highmem pagecache option, leaving only
>   zram and custom device drivers as a way to access high
>   pages=2E
>
>That last step should wait for an LTS kernel, ideally a version
>that the CIP project's SLTS kernel is planning to keep supporting
>for 10 years=2E The newest SLTS kernel was 6=2E12 last year, and the
>phb-crytal-ball suggests that the next one in December 2026 may
>be linux-7=2E4, the one after that in December 2028 (linux-7=2E15?)
>seems too far out to plan for but would be another option=2E
>
>Unless there is an easy consensus on this on the mailing list,
>I would like to lead a discussion session at the kernel summit
>in order to get closer to a decision=2E
>
>     Arnd=20
>
>[1] https://osseu2025=2Esched=2Ecom/event/25VmZ/32-bit-linux-support-now-=
and-in-the-future-arnd-bergmann-linaro
>[2] https://www=2Eyoutube=2Ecom/watch?v=3DQiOMiyGCoTw
>[3] https://lwn=2Enet/Articles/1035727/
>[4] https://lore=2Ekernel=2Eorg/all/0047f565-ada4-491a-b157-f2d8dfde0ac0@=
app=2Efastmail=2Ecom/
>[5] https://lwn=2Enet/Articles/813201/
>[6] https://lpc=2Eevents/event/16/contributions/1183/attachments/1062/202=
8/highmem-api-2022-09-12=2Epdf
>

1 GB systems used highmem too, sadly=2E And 1 GB was the norm for a big ch=
uck of the late 32-bit era=2E

