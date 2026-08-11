Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEEDBC5B574
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 08:34:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 078D66B007B; Tue, 11 Aug 2026 04:34:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0028C6B008A; Tue, 11 Aug 2026 04:34:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0C4C6B008C; Tue, 11 Aug 2026 04:34:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BBDE66B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:34:38 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 616A3A2603
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 08:34:38 +0000 (UTC)
X-FDA: 85088327436.13.F38306D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8FBA7A000F
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 08:34:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ILvmNn+1;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786437276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FpB3+FkrG1uWOg00/UfBQNwp9iXrIA9AhO2Rb76OdaI=;
	b=prGhx7ZyZYxB29jsZ6IWsQ2k5OqGEskKU7ByBbVJ2qVaEMTOT9ajeCao1gR6IiI+bqtBWC
	IBIGNTgYRDgi5SL7/jIMSf2vgwr3XsKmtcJaulTrJ5FZZ/1grenVzEgKsjOs2djSR/P57J
	VpMM31pfEzHLvYkRlgWHWic5aSj8mS0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ILvmNn+1;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786437276;
	b=0TCrdlQ9hC5l3KI8JxnNhHsUvr4S4ajSfDMq4QXQxq6D/GfdFZLvpeV0Jo87OHigZPW5Uj
	dGxgKyVYn6l5Q//5aDz1dpzWfI+xgaK1i/lV1Wp++ELD5xo+qcROdJMrdUmLJA3OjTsAgN
	gpfwH+86qpK4ahEqU17ct7iXoygwn98=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B295E1516;
	Tue, 11 Aug 2026 01:34:31 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EA58F3F673;
	Tue, 11 Aug 2026 01:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786437275; bh=ZT08f1GiOgKpD31g66zZnUhmuNu7zNORWfMHkMNA+MM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ILvmNn+1uP0GCjTeWxHAARq3POjelk/zkkggHRqr669N5vBlnXQv9Yg8uShAHAWPV
	 r+uFJpIr4Ahch5mMzxC2ouczYWRZPMGrkwVkFNIVMPn+HCacIXd33isOumG+cExtcS
	 egAiyy/T4cf+1AQQkz3B427/hIS4SjOBaBYGwt8M=
Date: Tue, 11 Aug 2026 14:04:32 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, david@kernel.org, 
	Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, linux-alpha@vger.kernel.org, linux-snps-arc@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
	linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-um@lists.infradead.org, linux-arch@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC V2 6/6] mm: Drop pxd_ERROR()
Message-ID: <ijjadks7zjpwqlw4nbcawr3tva2r4y6gn3weuc73vbec46petn@ovlf52m2kugw>
References: <20260811042119.3652929-1-anshuman.khandual@arm.com>
 <20260811042119.3652929-7-anshuman.khandual@arm.com>
 <CAMuHMdXfpkpYzZWGVb0fQrdn3uYHU3pyCkyAX9o2ux_Jj=2ByA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdXfpkpYzZWGVb0fQrdn3uYHU3pyCkyAX9o2ux_Jj=2ByA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: x7fgsmiueifo9n3z5jpwapg4swbnkxh8
X-Rspamd-Queue-Id: 8FBA7A000F
X-HE-Tag: 1786437276-490550
X-HE-Meta: U2FsdGVkX1/79e45ThBKqorFmgxXACgAy12uQU9V84L9tER/1ZSjLMc/3wr8oabNQT8/4oPSEXnoOqcwCFwf8FOlP/logqdDMpdi4SALiYohpOPqsDL4BisvNyShb/AINFDpRvO8Mk5sEym11bKhFNeYtUafkfaGA9Y7el+v+c2N3i4fii02Tu1bR59FHQ5FP/E2C5dMnGE9WpM7Gw8/3LCEWRDJCQyQTPcjIzNrdBFcf5K/5ygg4u2nmr6YNBW3nt5dFQe/TatRTK97TwdYnPdroIAp7pUZ+FrzNdQsbXCmr+JGRnrWo/nq2tsm7meuBS/zuTLc7r6+U2+fKf5fI+3ooZ9a14SctrRw9wA3iJSRkico9vD8U15Dcp9fj2livZBcdwnh0863ZYEDK9W5n2a9JHM3PpbgWjZ1KTCqPfbmA8AGJaNDqUyBeReMIu3PW3KRqdoE0DxLfY1fKiAodMdrLFEFvhwVipByWG58oLv08SXr5SCFOrTyF44cyn5WHlq0tGnHV+v5I/VJrfz+A/upMWoPtbpuGSqVnkcv8v9BS5OgXWsJ4Fba5a8WC1po7G/mMmEnAv8+af2N7e3PKbH5SQjoBGHduRBFVxbmAZQzfBKLIlz94OQJFQ7EZZt19F6h+WzL3hu+Y7WML3E9rzr+/LLRJ9TZkA4jES6Rf7GLoDhV8S4BsO4jfNSykIv0TOaqvisyxzxlfv1ao9leNt9GTsV5ENAzEkmNkyvN8Opl0qjnO+8zYkw9SUrq7W3NRJR44dzGtpAE+nxpKBs8TscvxawZcKuw6Ry90yenFIJrSZShcq49prqD8kSvRplSrBCCpFklEiFoNhIzjt9Ker223xd+oC4XrsLcoDlPY9R7e3hfQfGu7zo6aHSajnT4w1h+nSTnokp1U7L9ZQcfyDjdANc8KC8X7DnrUc9yHiqiXPDW/fGDQnKdu+xu7j/w+ODepsI+YccocMCvZgB
 PvbQdZk9
 iKznE9yJCInISncWOvf+fgfiQMB67jorI5fRcef5c0DK6O37WzipaRysJAvz6ZYNAxK2gCfSccb9xXIuVcM7hU8TBnwhZNvGB6t2O07DcHFh/Uc/M7Qrsu/oL89gRboZuUcumHJGDJvDOQiIMKh5B12cGPFqqc83bexg0zcXeYX0hurFQcKvVYcwvRuhVOuzIiExZRhifhJDl689OCTeuw+fI/ymeC0N5gnt+MZOV0ndt+7Lw41P1Pe0yowl+aZQzsPXS4+gSjpnSz5G84cKjZZqczVRSBRqIZrlCYuKI7Jp3hdqAOzvB24FVj7wYQeBXoPl45IYjx0XogzzhjTCYwBLKmFfZ3AzwnZv5oZ7IDk6ZWzKrxHur4/4zDmfQlAxxLk7i1OPK05mJzmJqDuSvBWhHf0Eb+GnDRBblufob9hcAJ/fiDxzVuPRv1VZbzlwNSd3tMbAAIjZySGhu3y9mZ2TFmEm3QskynbVkBy6CB3VmrNcm4KgEBLnTOuMysnQyLXQX1Bm3GPaESJI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 08:49:43AM +0200, Geert Uytterhoeven wrote:
> Hi Anshuman,
> 
> Thanks for your patch!
> 
> On Tue, 11 Aug 2026 at 06:22, Anshuman Khandual
> <anshuman.khandual@arm.com> wrote:
> > pxd_ERROR() has been used in generic mm just to print the page table entry
> > in pxd_clear_bad() before clearing those out with pxd_clear() later. These
> > pxd_ERROR() macros have been provided by all platforms which basically did
> > the same thing.
> >
> > Make pxd_clear_bad() use recently added ptval_to_str() instead for printing
> > page table entries thus completely dropping dependency on platform provided
> > pxd_ERROR() macros which can then be dropped off. First move all required
> > helpers in core MM into a header file which could then be used else where.
> 
> Oh, the "x" in "pxd" is a wildcard?
> Except that is not, as it does not match "pte" ;-)

Unfortunately that's the odd one but "pxd" was the closest possible :)

> 
> > Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> 
> >  arch/m68k/include/asm/mcf_pgtable.h           |  6 ---
> >  arch/m68k/include/asm/motorola_pgtable.h      |  8 ----
> >  arch/m68k/include/asm/sun3_pgtable.h          |  7 ----
> 
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> # m68k

Thanks !

> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> -- 
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds

