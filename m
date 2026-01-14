Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96BEAD38FF2
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 17:34:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BAD96B0005; Wed, 14 Jan 2026 12:34:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 051F16B0088; Wed, 14 Jan 2026 12:34:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA0276B0089; Wed, 14 Jan 2026 12:34:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D44CC6B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:34:40 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8A75DC219C
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:34:40 +0000 (UTC)
X-FDA: 84331269120.19.01C69ED
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf08.hostedemail.com (Postfix) with ESMTP id 95F68160012
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:34:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jZbXVKiv;
	spf=pass (imf08.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768412078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WJ7m2Kae0rt7KDMZbiJnTHcyU/qgip1RiScuagqlCWo=;
	b=s5ROrIO35eZDQqzzzEP+qNhgkqLpGu2Yu4sIn1z6QeLy76dz1Rf6e4cb+970kETxs8Fk59
	S9SbGED+GCOo8R+gd+qo6+sVIrOMaP7lID5HYvfYrLemwhEbP6AZ5YaR0wYahkfrmAl00v
	uVg+Y8Xs3U3CvemTnZEIwzI+HgxjCVc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jZbXVKiv;
	spf=pass (imf08.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768412078; a=rsa-sha256;
	cv=none;
	b=7mkzlegtl5SfK92Pr7nEKr5XbNemUezIKL0shKGIoTWA57weUlotPwSkR4m2tFFWXGI41v
	7VlxphyGrnGz56n2dJCzQG1CrS7qXA8hZxa7Kb+Fz6yJCgX7gZ+6OYMcbWr6/Qh2rYq3gU
	GvSquesIVyb+RHhMkEupxcppkYKBd+E=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-47ee974e230so846175e9.2
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:34:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768412077; x=1769016877; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WJ7m2Kae0rt7KDMZbiJnTHcyU/qgip1RiScuagqlCWo=;
        b=jZbXVKivrmKgzUTUrEAhzpcUfTzJHw19iWPEaPCxlQsxw4n3cfwRdN2biNia1ec/dS
         B2+p95fLvW+0bl4bojVNRmZn/nIL9mz9+md/wuy7vnej6WYydq9Sr8esv1v+/Ra+WRMq
         Mzw46yMI8szgxU0fujLsPHezMQsFsy33orJEgZJwvvSk2byg9jdsmfhkbeI9UBdlj9yI
         6niOzRRm7aJvx2qNXRCrB4erHJKPG7Lrs6UZeq2o9qK2UgVMe/CKfNGva4hn7ojKDnpZ
         mmVJkhvL129rYUlCv1ro4CUC6Vn3KD2TPrh7b62uu+0u777zbkJ/sa6MrQxCkpu+JLx0
         PJwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768412077; x=1769016877;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WJ7m2Kae0rt7KDMZbiJnTHcyU/qgip1RiScuagqlCWo=;
        b=QpTGZS7jBRYNm3kxpk3+cjkjwzuetwHpbgkFsRY4oC/yCUvkKf1c5cTIPRK0uKeREd
         DYsEadQqwAksGRbGRIBoQqjKejZJk7Jl1bVjkft1iyZ0ixklKqJm1b09PEkd4rDJsZYx
         dXzVuiJpLBJwX6kMf2M1FRDgxGLeuM4xWMAZ+VSddFXSjIfmEOesVXm2tLwXLQSp8F1l
         7ojJ6nh5A8udov7/O/C9DPgbsC1qJFE0rQdn36wWuqky5rhu+USFJpZ20lnen9UOTVAp
         zE+aOM0BPigpfmU/bfLMEVCyWEziq9mUebE/kzYO0B/WgDXKjOG+/rQh0qdGGYZfpBbo
         bq5A==
X-Forwarded-Encrypted: i=1; AJvYcCV0cNEMvTlDrtvQ8bu6zFzlwCccNWpM9WZpM36tDvjgiuLKgAOS8zoDiVNto9vg9OmacOc7ZhMyiA==@kvack.org
X-Gm-Message-State: AOJu0YwRtf+BUfoZ2ESQeZnlAaDmDlymJyo2TEuXqPyPzHB5hP4IGU3G
	gS7Y27WswTKEj1iB//Mfyv0ZUPh2ky+w4w4yY9+CwLLarRBcHEyJiSLSRDmEuA==
X-Gm-Gg: AY/fxX5n/9KsHDLYajTohXJXIPUmfGNCPUV1EWPSZsmrxDfGpMlBAGRAYHWK4kpi0JW
	gYVwl02An/Y2JQppKxAPYAxxh82KoWV3z1kKfccHJkeFa2gl32FrXfzeYSaSLggGDZ7LLM+/5B2
	xuXfYn3MavZWgkA0MWLwTteDnnvWHKzmZWoucZzb0WlCkdVcUmfv6GSorVH14ycHkrwv1a89yKI
	W1phOUj6tWWAI7RioYvmQahWAfRRVdwO4tt1/pgQ/ycV+bGZP8D6/LHyzZsoayvKpPOoUBaBkaP
	H+JX5ESnGbE/c55hl+D07H+1Jqo2QAtU7dYiwHw/5AMSVSjHPx5A50YFaynqak/j18j4JNEaYdR
	FDw1xBv+zW+KKHMp+RQSq/mH9SNGndXh8eMvxNxAYMEtXbqYKQXIhhFB7jfP2GB7tjM47hXMrp+
	WdvRrD8T7PatIlo0WszyqfK/gkMAtwbShWwrRNlomnr8VR6R9IqneJ
X-Received: by 2002:a05:600c:a46:b0:477:73e9:dc17 with SMTP id 5b1f17b1804b1-47ee338c00cmr46093135e9.35.1768412076765;
        Wed, 14 Jan 2026 09:34:36 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47ee2725b54sm27307345e9.1.2026.01.14.09.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 09:34:36 -0800 (PST)
Date: Wed, 14 Jan 2026 17:34:35 +0000
From: David Laight <david.laight.linux@gmail.com>
To: "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>, Nicolas Pitre
 <npitre@baylibre.com>, linux-mips@vger.kernel.org, Thomas Bogendoerfer
 <tsbogend@alpha.franken.de>
Subject: Re: mips64-linux-ld: div64.c:undefined reference to `__multi3'
Message-ID: <20260114173435.51cf556d@pumpkin>
In-Reply-To: <alpine.DEB.2.21.2601141530510.6421@angie.orcam.me.uk>
References: <202601140146.hMLODc6v-lkp@intel.com>
	<20260113200455.3dffe121@pumpkin>
	<alpine.DEB.2.21.2601140453090.6421@angie.orcam.me.uk>
	<20260114103103.216aa122@pumpkin>
	<alpine.DEB.2.21.2601141530510.6421@angie.orcam.me.uk>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: tj8c1prgnghmwhf1ks18sgqxhfrkzf7h
X-Rspamd-Queue-Id: 95F68160012
X-Rspamd-Server: rspam04
X-HE-Tag: 1768412078-2695
X-HE-Meta: U2FsdGVkX1+HhQbAY30AAc8SMP1KupmcRngYGOyosmK+5ouMvlL1EY0Pzlfl1+EEkVkigUSSCgSL9lijDLyxT3JN7PV5eMIqTdPwNI6JMwMR89Q6UH++vrMatrTLPb3oTQhP0KOZ4diCnakFRdZiep6HtuGv/vuKx74quasnCyqOOJptFliGyc9KkKWdi646xLefWvFdUSH56IXahzFur8fNr+PCXdI0kiOxE1Z1n3dh/Z10VrB2hUSN9CmzLABwdf/JxK2nZl+jDmkF8RKSeQ4tyniLpnO9G2+SSrJWxMoMAuCux/8Z5v8YoX/UjtXhJR2+xdmlJOFNQV5HRnoE5VhJzlqqSBnMhqlbRv7PhhMtjaMXZgOz8JJE4ljyRdwtFgml9M1hjOFCmEuL6TDlVcTMl/CM/LseEs3CE4eB2ag8tDbVEWtRJN9rvh18La54nkceXYLkYTGqVng8G+14tNLw+mQ3/vRcGQPObrnJNbMzevF0wEsMhqgyMfwztdtIw2V7/ZEb6U9GcT2G5vHP08wXl6BzllvwE/EVhVwwRNCEqdATb8pFT3dsMBw2fQDOknj7EFCEMrvgMepzpYviwRJmFaJoOS6lug9mMopZvIVhDCoCtWh98b/2HGAv+CEVL7tNzVKXrwq8VTy3FkCVspn1ZYu2a/2Fk8EyDy0sVUrPouTtbc2GuG4JR1EA/d8UPgT26yGp5SXeficggRPXkyZ38vehSu5rXW//St5sjTkEjlRtuMCq+vXqssMTyEOpFlHfBjklErej1ODFcQ1e38boG2GHUb2+uc2D8WlORKwPlNbrTXQwcK7ZcAPGBKasTjIEV1+OAaOa5lT6YtY9xwsp+b7dav28IluGL78l8Yt9XtFVx6jvKr2jRicedrpDrLn9moZg//kJEkoz7Gt2av8j6ynsXfNiLy6zpyNCNcQ1O/zmC5ze5W98/3JXuWNtfIkuTwXdIm+vJfFK8IO
 ekrKZoaA
 NYQdl2CzI9kUmwZGnGiAAUjOCv/YyfP+DH5g8/vYarfaY8dqmbeYY0f6QzSf/Y2I0rzoAMFMddrlIP3MRB+Rp0XLK50oM3LFO0eO3AmtAc5HvZMDs2ORqWLMXDrEQJEwKNhKlVfZm4k4fErHHXJ1khwrQHNKQnCn02/GZqcGe19zr4AzggkIKIqV4bMpQL6oL5wSRwLi49adbBXj21WqjjPWu5tIL+duX4+5hHvdXG994ndnsunxLKgZjhmlacQpEvxkF/XynKeMhNRt9uadYGrwkKzEUnz5YqaTFS477VKvt51Jr4rEDacTaAvqrIcQSmplahyBebL5y2P7SYKWvgGXvYR7C3+8+Gj5ypeRGm/r9NiOlmU6tLTn3pmTjOcfeNS8KU2mJovd2adgK0undOgPw/FMqSOBqR65k5/ajxiRlKkId3kIc75t9coDFP1zttcSC/KlutJOVC3XvzCnv9fD40QjgG0lzVSLQk3H4aEnEXprUSnPlcj0QVwAUpvlb87n92IBP4KaXgZxEyqbl/qVmSQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Jan 2026 15:50:09 +0000 (GMT)
"Maciej W. Rozycki" <macro@orcam.me.uk> wrote:

> On Wed, 14 Jan 2026, David Laight wrote:
> 
> > > > Looking at the git log for that file there is a comment that includes:
> > > > 	"we wouldn't expect any calls to __multi3 to be generated from
> > > > 	 kernel code".
> > > > Not true....
> > > > Not sure why the link didn't fail before though, something subtle must
> > > > have changed.
> > > > 
> > > > I think the fix is just to remove the gcc version check.    
> > > 
> > >  Or rather fix the version check.  The GCC fix went in with GCC 10:  
> > 
> > Does that mean the GCC 10 generates the multiply instructions and never calls
> > __multi3?
> > (Rather than just not using __multi3() for that specific example.)  
> 
>  Of course it still does call `__multi3' for 128x128bit multiplication.  
> It doesn't for widening 64x64bit one though, which was a missed case for 
> MIPS64r6 only, having been supported by GCC ever since MIPS III ISA.  I 
> think we do want to fail link in the 128x128bit case.

That's fine by me.
I only get blamed for the widening one :-)

...
>  Distinct RTL insns are produced, so all the usual RTL optimisations 
> apply (in addition to any tree optimisations already made):
> 
> mul_u64_u64_add_u64:
> 	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
> 	.mask	0x00000000,0
> 	.fmask	0x00000000,0
> 	.set	noreorder
> 	.set	nomacro
> 	dmul	$2,$5,$6	 # 9	[c=20 l=4]  muldi3_mul3_nohilo
> 	dmuhu	$5,$5,$6	 # 10	[c=44 l=4]  umuldi3_highpart_r6
> 	daddu	$7,$2,$7	 # 14	[c=4 l=4]  *adddi3/1
> 	sltu	$2,$7,$2	 # 16	[c=4 l=4]  *sltu_didi
> 	sd	$7,0($4)	 # 21	[c=4 l=4]  *movdi_64bit/4
> 	jr	$31	 # 44	[c=0 l=4]  *simple_return
> 	daddu	$2,$2,$5	 # 29	[c=4 l=4]  *adddi3/1
> 
> (hmm, I wonder why the cost for the high-part RTX is over twice that for 
> the low-part one; this seems outright wrong, also taking the possibility 
> of fusing into account).

They might be different, if the wide multiply is implemented with multiple
narrow ones then the high result bits don't need to be generated if only
the low result bits are needed.
If the data is clocked through a single multiplier that might be significant,
but probably not double (I think you need 3/4 of the products).
If the results of separate narrow multipliers have to be added together
then the carry-ripple of all the adds might make a small difference, but I'd
only expect 1 (perhaps 2) clocks for that.
If those are gcc's costs I suspect they may not match reality, after all they
usually only have to be 'good enough' or 'reasonable'.

I nearly got the 32x32 multiply to run in a single clock on my Nios-II
re-implementation, but the 64bit ripple carry delayed things too much for
the other logic that needed to happen to feed the product back into the ALU.
The product itself could be latched - so it wasn't far off.
I think I could have fed back the low bits, but that would have been
complicated. Detecting 'short' (18bit by 18bit) unsigned multiplies
would have been more use - they are common for array indexes.
(That was a 'fun' project... Nios-II is, AFICT, basically MIPS 32.)

	David

> 
>   Maciej
> 


