Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDF6ED37E5C
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 15:50:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 351F26B0005; Wed, 14 Jan 2026 10:50:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 300136B0088; Wed, 14 Jan 2026 10:50:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FE846B0089; Wed, 14 Jan 2026 10:50:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0902C6B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 10:50:16 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AA2B41BD91
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 15:50:15 +0000 (UTC)
X-FDA: 84331005990.04.958AEFC
Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7A93E180005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 15:50:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=none (imf16.hostedemail.com: domain of macro@orcam.me.uk has no SPF policy when checking 78.133.224.34) smtp.mailfrom=macro@orcam.me.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768405813; a=rsa-sha256;
	cv=none;
	b=akjW+LyqpCordw/WdJQkD4TBmOXjkJmCcm7QR5+talrlsP3nSXBhQZHBiVbejLUs9fyki2
	SxZLbinLc/U8o5VOeW0PzvDGlq8JD4zh0OYSLK8GIIhqcaYzdJ9z52oQNijaMMVk73Nk4s
	71HvsqOdYpkHXRrp+zPFDyvFcjDiJiY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=none (imf16.hostedemail.com: domain of macro@orcam.me.uk has no SPF policy when checking 78.133.224.34) smtp.mailfrom=macro@orcam.me.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768405813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nyulLFqulO0YWD9WsKqiLO9KzGpHnZrWaDlkGucoWwk=;
	b=SL2+fJj8l0uQxewe8zC6Td6PtH97TD6Lbrg9dKaJ+LwKB01RjNnQsK+35h3UgZJp+1bNME
	rX47HwTJSwoqXUw4jSn6kLftqOJNo9ZAnQCa/Xdsco6zw+5T7afqrcBXf3njP/eMSQKDWt
	7iQqKPyWudQnotQ2DTfy6mr3A2/zC48=
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id 0168592009C; Wed, 14 Jan 2026 16:50:09 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id EE58392009B;
	Wed, 14 Jan 2026 15:50:09 +0000 (GMT)
Date: Wed, 14 Jan 2026 15:50:09 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: David Laight <david.laight.linux@gmail.com>
cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
    linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
    Linux Memory Management List <linux-mm@kvack.org>, 
    Nicolas Pitre <npitre@baylibre.com>, linux-mips@vger.kernel.org, 
    Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: Re: mips64-linux-ld: div64.c:undefined reference to `__multi3'
In-Reply-To: <20260114103103.216aa122@pumpkin>
Message-ID: <alpine.DEB.2.21.2601141530510.6421@angie.orcam.me.uk>
References: <202601140146.hMLODc6v-lkp@intel.com> <20260113200455.3dffe121@pumpkin> <alpine.DEB.2.21.2601140453090.6421@angie.orcam.me.uk> <20260114103103.216aa122@pumpkin>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 7A93E180005
X-Rspamd-Server: rspam06
X-Stat-Signature: tydh8ctnfiw7chg7oaz86egakymyyqzf
X-Rspam-User: 
X-HE-Tag: 1768405813-234061
X-HE-Meta: U2FsdGVkX1/uQ9IdYDoGu2Zbe54W32yC/8U1ia5JRgEPvKvlcelwBIh2qLnA4lWfGDq0LjDObAEwIl0/IKR1dVQbBwLsAzcXH45bl4N5cW5y6/RegufbUC4013nP7Eruz0KzHCYveD9GUAdkmp/mSW7/JB9ebFziIxSEnlFJudL4juegfqJevfYChNG480nKEIodQUEPZhmjjT3sScg+/QEr2VvjoR18uKTNj1iXlE3WJ6tCGyqZf2pqqcBOv3kWa40KuaXkdStu7BQ/LI6Qz59PcYnO9GC/NTL+77S9HdMM3OvNLa4a9Xj4zABUmKZC51AH7uIywyNJri4k5vp7FJ+EgoabsRa7dL+BhRVaKWhsoqlhQUQGeYsZGCtIKgp7OJHb3Rzvp0SxfuRn9O2/fl6QDkAOHiyiDDBxKhsxM1M/fUH62pmrUIddta/EXWti6j1jav/WcgnovOwAU2WZYWQ5OeuW9P13OvYZe6441WB/MtIFPR5A/kVE0+qdxJV8dkhkI0dH1nnMvFhnvR4sOXvNJUzCTxssUDAacXqpHdduYGjGQVul3VGWJDmr6bbE/bwX/69DkEk4JVMGyI2jhgdm2PY4FWnlCoWflvRiQYgWL0/zRclR5Ybyxmn4BWMgXdDU+uep2CFp6nn0gxCZ4Bjhzs52Q299DBmGWhhHiw1rbyqSxqLUUpk7CaPeCfRj7XV/4KaLZuNdUre+FbJXPp7DF7tC2pJv5by/lingk1b10KXbQb+XgOXigBowj0E4+kSYvqoAjWk/187m38inHR4bIDx6nUi3rE0fHeOGJuK8A4YFD+EVKZFyG63mcnFJ2k221Y/82Y58JIQKW2fRwx8daLcZDeniLqcz2PqT4ETM2gbH5RSnwDoW7IFbgZTE8z3TguOiZSYeVjFUu1x7JmakvP4pojg9VONQLmeWsMFh/rbb55Aa9bxF8PKHxlNfGMZMMDEDWeQbrupVQ+L
 dzbYkYZ2
 7/m25K6wcRTQhQXHUoExGrVazuNGE6MuRRIwiQh3OIHQlxHW01Hy2HKkkLPOHzu/3RdsYy4n7Tkz9LOv7+KuDCK01Hji6bNYLNpF1s4AKg75lCFVexfFx/UIZngDJg8ctuvUEzoAGMnA0iyMR4r8Q4jRHoYvSQ7r0L2qv3fhOMo8MbmGcMOJSQQC2VL0Zss/ZRSt5LrR1h1b+ECQE1JRYFx+Akwt0p3X/HeM/9FfMxh3fCWlGxcy0E8pbHAu2A62wCNl9u9/tNP8GUwlqU23JMKycOw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Jan 2026, David Laight wrote:

> > > Looking at the git log for that file there is a comment that includes:
> > > 	"we wouldn't expect any calls to __multi3 to be generated from
> > > 	 kernel code".
> > > Not true....
> > > Not sure why the link didn't fail before though, something subtle must
> > > have changed.
> > > 
> > > I think the fix is just to remove the gcc version check.  
> > 
> >  Or rather fix the version check.  The GCC fix went in with GCC 10:
> 
> Does that mean the GCC 10 generates the multiply instructions and never calls
> __multi3?
> (Rather than just not using __multi3() for that specific example.)

 Of course it still does call `__multi3' for 128x128bit multiplication.  
It doesn't for widening 64x64bit one though, which was a missed case for 
MIPS64r6 only, having been supported by GCC ever since MIPS III ISA.  I 
think we do want to fail link in the 128x128bit case.

> In this case gcc knows the high bits are all zero - so just needs the two
> instructions to generate the high and low parts.

 Distinct RTL insns are produced, so all the usual RTL optimisations 
apply (in addition to any tree optimisations already made):

mul_u64_u64_add_u64:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	dmul	$2,$5,$6	 # 9	[c=20 l=4]  muldi3_mul3_nohilo
	dmuhu	$5,$5,$6	 # 10	[c=44 l=4]  umuldi3_highpart_r6
	daddu	$7,$2,$7	 # 14	[c=4 l=4]  *adddi3/1
	sltu	$2,$7,$2	 # 16	[c=4 l=4]  *sltu_didi
	sd	$7,0($4)	 # 21	[c=4 l=4]  *movdi_64bit/4
	jr	$31	 # 44	[c=0 l=4]  *simple_return
	daddu	$2,$2,$5	 # 29	[c=4 l=4]  *adddi3/1

(hmm, I wonder why the cost for the high-part RTX is over twice that for 
the low-part one; this seems outright wrong, also taking the possibility 
of fusing into account).

  Maciej

