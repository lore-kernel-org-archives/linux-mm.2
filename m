Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FB5DD31A0E
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 06:19:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C48B76B0089; Wed, 14 Jan 2026 01:19:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF6496B008C; Wed, 14 Jan 2026 01:19:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF5256B0092; Wed, 14 Jan 2026 01:19:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9B0D36B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 01:19:07 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2AC04C19DB
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:19:07 +0000 (UTC)
X-FDA: 84329566734.24.58FC416
Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id 011534000D
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:19:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=none (imf01.hostedemail.com: domain of macro@orcam.me.uk has no SPF policy when checking 78.133.224.34) smtp.mailfrom=macro@orcam.me.uk;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768371545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yaBUQH6VotuDw0xa0VH4bBKRLI+wRtCej0AtnQAvIc0=;
	b=qOO6D/61pUeE7Mcj6ahwpUj39PCxRzRvRVcSDR8OggGE/D4/UjA9e9nyt3kxBntdijhkVa
	WAxTFdYdEpJUTAFFgBywy8wxxdKUyNW9yUwZTTeAv3sn+AFA8jE+gdEg+ekANAgBNwiKFL
	Pr32s6ZjBRa5rbRC77fuJo7eSftUPqs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=none (imf01.hostedemail.com: domain of macro@orcam.me.uk has no SPF policy when checking 78.133.224.34) smtp.mailfrom=macro@orcam.me.uk;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768371545; a=rsa-sha256;
	cv=none;
	b=loTbmcLkQSCvwboat8PCnokHnRJ7v+NDtzqJH5Qq58PhjUkiwh9+UVvP9CHZ/VNaHD9LyT
	PTb9lvkSd4YIKhgitTEb0unXgiU1uequJrftNG4D+Rh3umCSgk84/Iyoj7w6e54Q2f9I47
	L8nozchTTQ9Z39BnTC5zpr4GE1GLKno=
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id 3824192009D; Wed, 14 Jan 2026 07:19:02 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id 361CE92009C;
	Wed, 14 Jan 2026 06:19:02 +0000 (GMT)
Date: Wed, 14 Jan 2026 06:19:02 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: David Laight <david.laight.linux@gmail.com>
cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
    linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
    Linux Memory Management List <linux-mm@kvack.org>, 
    Nicolas Pitre <npitre@baylibre.com>, linux-mips@vger.kernel.org, 
    Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: Re: mips64-linux-ld: div64.c:undefined reference to `__multi3'
In-Reply-To: <20260113200455.3dffe121@pumpkin>
Message-ID: <alpine.DEB.2.21.2601140453090.6421@angie.orcam.me.uk>
References: <202601140146.hMLODc6v-lkp@intel.com> <20260113200455.3dffe121@pumpkin>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Stat-Signature: 4zx66hfo5tr7aassf994r1qd7ey73cyi
X-Rspamd-Queue-Id: 011534000D
X-Rspamd-Server: rspam04
X-HE-Tag: 1768371544-939792
X-HE-Meta: U2FsdGVkX1/YcfqTbrJL3ZIYJqOJPTd7nE/QTB3huANcBJ1jjQZnZCCKhTWq2B3SsSwY5T4lTOXgorp2TmkTJ3xbMHa7poAVaCb7ASKsk/n/zq/pabxvx1n119mCaRiNlslo4aT97chKoVzTRsjYc8KRyBNtMIrp4pFk/e5bRBXpNKKrtSdaC0rRBhUcfjOV6E4/wZjFErggwqb0+DXxPgnvfZVGIiGiEY29B5Q2rf7rQhrm5mQiNxV6oqtTZAsZiYIcX0P79qlGpvQR19Qk8vRTShQaUHpxn8i13dfCLh20Lr5WmGplKv1uMDuSsqLTLApylFw6Sb2QR7Zup8BkEbH62kbT+ew1Phd63LQsl1TIZKBzgGrMNxVpuy70myHyGe/PJXTusqXBpASLqUUUz9JK2zXJNiILzwxcs8nnqoqbkXZhNGVaiXfYQp7ezEUPoRg7LMZL2ecFZJcJGxqtcKAeG3asG2EMM3/ImZKueAokyO1heeCrSdf/xk5v0rZNjW7uvFDkG5TpGhUkbd3uMLzL7xL1CFiXOLmWUZB7ua7ewbAmS0OdimmtlYc8Xws7EUDpV2dGxwsLlhZoBJiwXEV3Vi1GibDHnySg4eNT9KA0VOT9yrFB8D6lxvfpPx56FwGyA8SWbGaLRwmRbuvFjkmLwqaUJUEFqjib7lmZlmnVilxEBYyCAkSPFSMnRboQpi5tVVfW5MP7y6mIshTP/2zKViG6Q9S+WzZ+LVItItpvBk/uP5Cy36U7XxR5uuT9srTnff3pf4purWjICeOMDjycuuoEWcWQNsEi+9v9W+eJWklfQ+PI3L2rXnAyNIDX9CaoCDiEHWy6ht27zK2+TwA1dujXyAno/iml5iyyYyVu6wEWK5YQmSIc+rE2OBwL6n/B7WSvCbnfFNti4NaK8QkLGuPGtk8n1MH2gcTPF0uku64Q1Pr9MBtCFflBdWNroKVF3OSIFnEQetDKctR
 bfq+re0B
 nVj16jjb/6FM3qPeq2WSKGwstQ1htbZrdvi5WLhUebwVsAfUTfgZA8a9Yz7RC2nhpwGcP1E3ZN/7Qi3v44e/Rv6Xxm0lMOahCjQqgKYmRDUPgDW0y1tfW+1x1vbtYV59fmRcyvaqjrH/WtnzR3VqHjU3FAPWQedpU/Qq3wEmAOBUYbI60K9OcfQofZD+hm10ra1Oeg/SrFdltWx54Pmb4hrVwriIHH39acV+HgkuRfVjHlu8FRSpjLiis1xwyBiX9vLa9wHsAi6/doXVkc+aKpI6aIhJDx+ZzVX5OZmP6IvD2Vbs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 13 Jan 2026, David Laight wrote:

> > All errors (new ones prefixed by >>):
> > 
> >    mips64-linux-ld: lib/math/div64.o: in function `mul_u64_add_u64_div_u64':
> >    div64.c:(.text+0x84): undefined reference to `__multi3'
> > >> mips64-linux-ld: div64.c:(.text+0x11c): undefined reference to `__multi3'  
> > 
> 
> This looks like a bug in the mips 'port'.
> arch/mips/lib/multi3.c has the comment:
> 
> /*
>  * GCC 7 & older can suboptimally generate __multi3 calls for mips64r6, so for
>  * that specific case only we implement that intrinsic here.
>  *
>  * See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=82981
>  */
> #if defined(CONFIG_64BIT) && defined(CONFIG_CPU_MIPSR6) && (__GNUC__ < 8)
> 
> So this code is excluded for gcc 8.5 but the compiler is generating the call.
> 
> Looking at the git log for that file there is a comment that includes:
> 	"we wouldn't expect any calls to __multi3 to be generated from
> 	 kernel code".
> Not true....
> Not sure why the link didn't fail before though, something subtle must
> have changed.
> 
> I think the fix is just to remove the gcc version check.

 Or rather fix the version check.  The GCC fix went in with GCC 10:

$ git log -1 --pretty=oneline 48b2123f6336
48b2123f6336ba6c06846d7c8b60bd14eaeae7ec re PR target/82981 (unnecessary __multi3 call for mips64r6 linux kernel)
$ git show 48b2123f6336:gcc/BASE-VER
10.0.0
$ 

I don't know why the PR got it all wrong; I've fixed it now.

  Maciej

