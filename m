Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF0F2D6AAF9
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 19:09:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 106806B0005; Thu,  2 Apr 2026 15:09:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B74A6B008A; Thu,  2 Apr 2026 15:09:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE7C76B0095; Thu,  2 Apr 2026 15:09:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E19776B0005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 15:09:24 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8A4EC8C7AB
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 19:09:24 +0000 (UTC)
X-FDA: 84614554248.09.70A3BD4
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8458512000A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 19:09:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jLOFBMmp;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of elver@google.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775156962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=26jnDOH9sfu0NBZTRbOR7+Wdjzvvt/AkBoHu3e7kTgM=;
	b=RpNM0npZR9epHwQp9carCQDJGDgiYN1TFVSFcNrNLPm5G5XbtxrhQgyj7yWVFF3bQarivS
	ZpkRCUFHcqzvKT8ljyyrL4yHjnQAeqO7hA77RCXpB7i6p6mfS8ODMoyMpIzlG/VGTFZCyR
	NUCLajKWtYYwFGMh4jhqbwKXGaIO4xM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775156962; a=rsa-sha256;
	cv=pass;
	b=sZP2/x/Alwt5SCpqkrmGJsN/5xme4lRB+RBqRFvE8gpnl5ZKxWgDgWa1/PlixCrXsMNLNr
	HvpvOF+t94Ng4IioFHLmnIh8avEJ5RatthYl939LMb/x1svGCYnUDkaBBPFWbHga057PFR
	r6SL+fTA+7xMn2wSmyyE7mL3/NBbYMs=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jLOFBMmp;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of elver@google.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-12732165d1eso1884860c88.1
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 12:09:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775156961; cv=none;
        d=google.com; s=arc-20240605;
        b=CdwU+HvEiZMsPo0H+VWvIGlxEy05v/qsG17KuH/KpcNTFw2vIJhqtHIXjkbthPQCB3
         AbTBaz21K6Pp1/jS45pT8S6iS0lEzYtbonxBmgcDI/qfqQTCLlwHXKs5ZkYEDFcPpDcR
         OXNKX4KYi/G14iI4rSZubppcnlLHQuccWdQ69NNMmgCKCJup8SCQz/O2O5ytHX0hEMAl
         Pcr4PQ16sT/aalkmv1lmNQNbEE1sp1Vdc9rVFY3qtgglvtw809M4mdRPRTlnAGFrXbrX
         oRm0yyAzKqViwaRqiX0e5HwHKC11NDcCP1CNr7j1XvD6OVWZShxvHT3rHDo5396gXGdq
         QeZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=26jnDOH9sfu0NBZTRbOR7+Wdjzvvt/AkBoHu3e7kTgM=;
        fh=QnMYgJ7GQ5S0j0gjxumrLz+aBhF9bhCEvBloKoEx3xI=;
        b=NEzY1l5yUAVzvZMxQg5ttsvXTW6En2TABT2a/aywkpxHSHKeyHOU2XrW7XFCtcP18O
         apDcq+inyHAVmiepBpj/7oaOScy6zWwzwQ4boyKioGUWHTkhorAFdSZgSOceRWJIk+PB
         ZinTBt+3GK0Sol5tXvhhr8rAStMq5/edhn5cJrWQxma+IGc93LdZ9FTtAusD9qBZlFRh
         ae2V1tBmgpZpQyvrw8uAoMwDw1a8eTlHKQ2TZEoM56AdKnAljfAMhoqLuwwFlIqQBb+4
         E2gtq8QoLH1Kp4RiGQvbGoCrn5jtswpa4ECz3ZKrxDXbkBXwLdJwCK7+71N6lbHkIpGr
         jNIg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775156961; x=1775761761; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=26jnDOH9sfu0NBZTRbOR7+Wdjzvvt/AkBoHu3e7kTgM=;
        b=jLOFBMmpnXJb46r2YTbl1Q0CNyBJrY7pk+0dKGmum4bAofFFXsF3MIyf6tg5qrj11O
         EqBNHb/6dzyv4Hj7Im923umLU4/kWgDGhbFTppPNN+r8LE4lPVURgKrOBYSVrY1oRghn
         OxtkZZHMg/PFxN+FmVeStcrLvlPjZJMxlSecSB+CONOtj1LaEa15/My/0nXiyvo2BtRM
         uo8vo0BIDuGpx+CXIvewAn9RyIEQRLXhhQ/NnHGsI8B+sYhzYt/Jgh/OhHaf1BB1PZ0l
         hOaVOC1VT3uKRmp2exO322wiJ/jicS8TtMFY+AlIrm+a+XHSdcpH4JV55JsfFI2sEGOA
         r+XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775156961; x=1775761761;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=26jnDOH9sfu0NBZTRbOR7+Wdjzvvt/AkBoHu3e7kTgM=;
        b=UWzVo67iGdWbpR5wWDTCyQ49UOo2lQqMmjI8NLhQg1/yagDCkM2fFWPaVOo6/FtNFV
         fbLSD4fghsWhiFk5WNPaoCuz3NrfNG+KLgGlzgXV+0Oqk4T5XC920B1YlPxspZrvHpPe
         eh63TimxuURx79FHy+XP85Y+np5rip3NxNiA/5eMlsvE4YLOyaVVl+tXPD7QCxUC25iP
         /YzI5AMKX0bcR265+CK+HDiCdawkBYC2p9pQ16NI043J/QrTLVdHNxgIshKscWNYzqPG
         oSK++D6HEa/28HFEMFiCsZeLbAM1dE43mPLq9D6vuO+mAXV/v4SRiyz+jzmWARfBzCbg
         13CQ==
X-Forwarded-Encrypted: i=1; AJvYcCVRPP7FCV2+Lzuu8F2pDwCxlQgB04sTiGEkFTSVscjDHL2JnD1MxheQXVd6auC26sDrVA7kGUmWLQ==@kvack.org
X-Gm-Message-State: AOJu0Yz3TpF5It9vqGdrlGlusJ5/fUhjp5as3fuywLM2ZsjszPeDSfW4
	mtH4X4ifsMy9ElvHhqOFeedJAwg49xgjBi60phRbdODo8aQ6mu5HWnhju04K+aU2K4rPIbD62tt
	dLSgAFPD70db6yAxwCJIevpWT602MBKjglIuBcSom
X-Gm-Gg: ATEYQzz5Pozk+5UIzjA+HQia5dALXe1Ra1HDJt6VGMSbzJy6s72AmlFR6Z3Oe7AXybs
	PI6joyWlH4qWb3cOUX1GHjz6R1sy4OdSjXCC/2wZ4/vwXSRJVGg3Azj7HqAJy64WIQfEDaRH3Gz
	t54Xnf0rpwoOZNgNImYQj/wpRwKs1PjBlU86N4WeHSQKBVYsbIXaSMw4nikIh2K9vizkwVz67Hm
	ZrKNZ71sOA0T97CKVFn3GH3QqbaujGWzLxegYNWKA6u4QzEYI9Czg7A+qCpXUCRQXZRrVk3b1dm
	2MaKGZhC8bOtkG0qUvucvk51WGwWG8C/i2E/f8wOShLe3ZJAOA==
X-Received: by 2002:a05:7022:ec17:b0:12b:ebb8:e518 with SMTP id
 a92af1059eb24-12bfb779d53mr79037c88.35.1775156960783; Thu, 02 Apr 2026
 12:09:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260331111240.153913-1-elver@google.com> <202604020400.jEq32K95-lkp@intel.com>
 <CANpmjNOsM1e8jMvRKtEizMmZgPCCZ9YqpuZKad61Zg7PAGW7RA@mail.gmail.com> <ac6h2jF-KJ5pm1WM@stanley.mountain>
In-Reply-To: <ac6h2jF-KJ5pm1WM@stanley.mountain>
From: Marco Elver <elver@google.com>
Date: Thu, 2 Apr 2026 21:08:44 +0200
X-Gm-Features: AQROBzAm7ykm8zO9ipWjQHBso2-gdwz4n-a0cr85SYjLzctukNDeZ0kKGTltKIc
Message-ID: <CANpmjNPME07RK+jKnw233BYHX7wVMqCzFYpB2cSN4+DMgTSpuQ@mail.gmail.com>
Subject: Re: [PATCH v1] slab: support for compiler-assisted type-based slab
 cache partitioning
To: Dan Carpenter <error27@gmail.com>
Cc: oe-kbuild@lists.linux.dev, Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, lkp@intel.com, oe-kbuild-all@lists.linux.dev, 
	Linux Memory Management List <linux-mm@kvack.org>, Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@linux-foundation.org>, Harry Yoo <harry.yoo@oracle.com>, 
	Hao Li <hao.li@linux.dev>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, 
	kasan-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 8458512000A
X-Stat-Signature: cp73dizuekk8tfm6gg9z18grbeds9855
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775156962-583907
X-HE-Meta: U2FsdGVkX1/m6UZaIdb8/0s0VclfxptIyNr03BcxzAlFyoFjITxDUW3cPvi3Oj7vS6j+3noyDjHXVOb4fereT/7n4fZB5TMhEUt9D4y5oQa0QfMfV1aY4nU+KA5Ek5jycHRQKTCWKcEfcle6nS+IBvN9dS70hZXtJ4AuCFFu6rQgqq1/e6Mhw/fT5AeV4tKHoPET8zeruW8BLYaz+74oS/td8aZPbDkdBZp8jiiJ0RbckzHch/6bTCFOcA/wfCHuX+y0dprxufQN4CKr1J7gYYnBinkFrbWeIBmE/e/kG3D/nTGC9WpBe7mmBTf+a2KfgEUcjWyyzp/ZBVtKXV0Faiwxh9uVtisIlfINFuuubDpnrlo5cOWUpcEM0OG0tQUS8PKYDugGOmmI6ppFjT4IxokWLxpSBjz0SwURZwl7adTwsSz6FsCKoz7AKZYEzqDlicytJpfsfxTgEm1yQpEGSNxo83trY1DVCdOYQy5mQmErvxWJlwKGgQaGjxlqA6bHJKyIkRNfd17n64JgmuaCGpJ+dsQhk5vmEYPxZQJwlGs9i0S4WpYCIPwEMoN/GBqxnQwfL2o99VNpLF+fj9jwOI5vTUgzK0uUEd/TDIyptRQ8ioqaWsCWarEvJPgamIISZdf2f7uRidBZJbRg8f+LPdJ1h9TE9w1fzQyluFdbeMzYdrlfIT3wwjP1fAhXCujZKl6wAqz2qwm9KPIzXpnJz2mA1wj/umfl8fOQ7pQJOv1pxDiLu2KYqyJ7C6/7TfRD3/lqp50pSM1/4KzobPpBCYIJbfqmyqwdl27dHnu9tdHijF/QiPDHfTvS383EKfkNweAiG8gG16PdQXcbqTlAbWM4eIpU8lZr+zmlRbHG118RuAceDnomEpcNzleToLtBb8OHCAhlydwfVj1OuQMZ/jENNru2fUg5Dm4xvSS+yotZRvxVRXPsMA93AoQB3EbsWVhxt/SNoYU03APNlRh
 zeYtfXr2
 tyDmS6bKD2QrtUOdHXLM8wU/tpSxgs8vsKGN/nRJQ4ry2uZ4Af5dXODlvAS9FcIFHQpJSl4INiOjPmuQThqsgTls0+GxeHNi40zf6XTxUVqcfdm9BCQokeZ8YGOTWA7Ra/dD1L4BbrLz52icZY4Y0TjUQ16hJRafeL86lpHFIqYp1R7kpM68Un/+dy7oigLCto0pyKg3Mem/kCqIHh0JmV3IMvPx14cNQ1pzMIB1RmFbHmRMBd01kng0rQ914efyB5W0qBCtpb8WBNdfuQPoYEEvWT4Vk15YG0gs0kqnaZ8Lyegg0c0/yhKvOhCCSaAbK3xmuD7g/p0xsw5La+vv4SvvU4qSIUA5X0DoFUES/KP/nWNsZ41i3T4bR6+iFl0VUUrHMRyy3V+zKZbBbBnmuzNPK5MgppCeSFbyaqOs7oboisxaw/0jK6ifELosswonhxYnRm2UrmfyfSWc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2 Apr 2026 at 19:05, Dan Carpenter <error27@gmail.com> wrote:
>
> On Thu, Apr 02, 2026 at 03:48:20PM +0200, Marco Elver wrote:
> > On Thu, 2 Apr 2026 at 15:33, Dan Carpenter <error27@gmail.com> wrote:
> > >
> > > Hi Marco,
> > >
> > > kernel test robot noticed the following build warnings:
> > >
> > > https://git-scm.com/docs/git-format-patch#_base_tree_information]
> > >
> > > url:    https://github.com/intel-lab-lkp/linux/commits/Marco-Elver/slab-support-for-compiler-assisted-type-based-slab-cache-partitioning/20260401-035608
> > > base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> > > patch link:    https://lore.kernel.org/r/20260331111240.153913-1-elver%40google.com
> > > patch subject: [PATCH v1] slab: support for compiler-assisted type-based slab cache partitioning
> > > config: um-randconfig-r072-20260401
> > > compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
> > > smatch: v0.5.0-9004-gb810ac53
> > >
> > > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > > the same patch/commit), kindly add following tags
> > > | Reported-by: kernel test robot <lkp@intel.com>
> > > | Reported-by: Dan Carpenter <error27@gmail.com>
> > > | Closes: https://lore.kernel.org/r/202604020400.jEq32K95-lkp@intel.com/
> > >
> > > New smatch warnings:
> > > drivers/misc/lkdtm/heap.c:118 lkdtm_READ_AFTER_FREE() warn: potential pointer math issue ('base' is a 32 bit pointer)
> > > drivers/misc/lkdtm/heap.c:169 lkdtm_KFENCE_READ_AFTER_FREE() warn: potential pointer math issue ('base' is a 32 bit pointer)
> >
> > How is this related to the patch I sent? Did the <linux/slab.h> change
> > force rechecking of all these files and it found latent issues?
> >
>
> Oh, crud.  It turns out that for this check Smatch allows
> integer_array[sizeof()]so long as we know that the index is within
> bounds.  What happened is that your patch renamed the kmalloc()
> function so Smatch stopped knowing the size of the buffer.

Oh, I see. Smatch doesn't respect the __alloc_size attribute then?

> For these zero day bot warnings, the emails are automatically generated
> so I don't have any context outside what's in the email.  I saw that
> Kees wrote the code, but I figured maybe you forwarded it or something.
> Sorry about that.

No worries and thanks!

