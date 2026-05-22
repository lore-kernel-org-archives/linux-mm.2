Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E8DBCD5BAC
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 10:54:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E5436B0096; Fri, 22 May 2026 06:54:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 597C76B0098; Fri, 22 May 2026 06:54:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45E5B6B0099; Fri, 22 May 2026 06:54:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 35A876B0096
	for <linux-mm@kvack.org>; Fri, 22 May 2026 06:54:49 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 08B2391ABF
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:54:49 +0000 (UTC)
X-FDA: 84794747898.02.50CCD7D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0629F40007
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:54:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k2Btgv02;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779447287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I485ulN9sXiuaxr3hxPza2zN7Bv6l4bsoi/xIZYLS2w=;
	b=pWZeYRHB0sqFdBJEqBU1nzaZWK6qaZ+CM+OwWlqbYS3GfLIzBTZbxElZVMzLAieXvjaqie
	r4wU+VaNb2pB5YoHfPbbGAyiJMLrq6UHkrnuB0B6ggWepx04hWjiX0YQTnOi6aAT6+aDVJ
	cLsspAtR2su6NaFQte5gv3P44f4Y090=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k2Btgv02;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779447287; a=rsa-sha256;
	cv=none;
	b=1l/sVEEdYOvs90npFZK430EDM2yNJ1sf4uCe5nhrmJ90LzHk0IBC51rJPaH2mdjVduWD6+
	vAyAUPYT+pnn03VoUVR2KOqrWX72/asHu2XjfKnbINL20sbYFGpJpeS232kPpTD3ArptSe
	diCuWkBPekPENETOgbM7OZu0wUfPSdI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B28543CB9;
	Fri, 22 May 2026 10:54:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63DE71F000E9;
	Fri, 22 May 2026 10:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779447285;
	bh=I485ulN9sXiuaxr3hxPza2zN7Bv6l4bsoi/xIZYLS2w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=k2Btgv02Ssad7yxOLqwOuzAGd9Nm6n+f33MO8sLqWzk5wtpxP99zdw5uuTHGJGcjY
	 OQ2sKvX+N6i5jd7gSlLhEpMsg/oKuVv76xq26CBjs36q+PYBZ8sTTHwkpxT1mEwuHG
	 lDaYJyZQem2KZOWp/GaXpSjMlXkKDe/TLfmmk0t/Q2yfJQsdmqAEtDdUWgLltsJTER
	 zqZz5Ltkn3HqZyLnMjhGLvCgFKSr0SxBVReF8DvkmkNDYXiqvNyKUcgqqs+X6fFyeJ
	 ddRyIRFpaCEdRdKwlmNVez+1bJ7X3jjfhpaL943Pzg5Yl+RzWaqVfCKPlBUEM8lIrc
	 7OPw8j9/NVAAQ==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id BAAF0F4007C;
	Fri, 22 May 2026 06:54:44 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Fri, 22 May 2026 06:54:44 -0400
X-ME-Sender: <xms:9DUQatKIw8pHtuL_uqOaivYUQcb6w8lDWDXW4u2T4qRJnm98l2gfiQ>
    <xme:9DUQaiKzPJe6e9bA5ywcoJ5ZRy-ppHZ2O5X-CHMV23TgVx94H6cZSLVahiyeltw2R
    IhajtMUfA0Hs3m8RqK1WuIusqANdavHKiMZPeSLe8TzWkcoazhAIw>
X-ME-Received: <xmr:9DUQavbk_UOPlqFSDOiCbSnF83Zth4S2PpnwOncelc7CbcknO2le0z71kCk3CA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddugeelleekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfhfgggtuggjsehttdertd
    dttddvnecuhfhrohhmpefmihhrhihlucfuhhhuthhsvghmrghuuceokhgrsheskhgvrhhn
    vghlrdhorhhgqeenucggtffrrghtthgvrhhnpeeuieejieffkeehfeffffdtkeelfeelhe
    fhfefhudehjeehvdffleeuvddufefgkeenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgvrhhsoh
    hnrghlihhthidqudeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhn
    vghlrdhorhhgsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeegiedpmh
    houggvpehsmhhtphhouhhtpdhrtghpthhtohepshhjsehkvghrnhgvlhdrohhrghdprhgt
    phhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpth
    htoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehpvghtvghrgiesrhgv
    ughhrghtrdgtohhmpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtoheplhhjsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepshhurhgvnhgssehg
    ohhoghhlvgdrtghomhdprhgtphhtthhopehvsggrsghkrgeskhgvrhhnvghlrdhorhhgpd
    hrtghpthhtoheplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomh
X-ME-Proxy: <xmx:9DUQalXQ45nNeLCORY2mKnQqw6SnE982YJ4qYQ2t6SoOeMI2y0BbBg>
    <xmx:9DUQanEuT7mr9cBWathBzxbeRi39QSnTdc0DqsHOhyvnzvLZtl0uyA>
    <xmx:9DUQaqDatI1DSjaKH9-vRnSfjvKFSWa1lGXfYaszChiPPIrjcIbqnQ>
    <xmx:9DUQaqXoRWOs6Pe2jV5X2u3ECEO_XG2VZUU8UrJ5LBmWlfWPZQSSHg>
    <xmx:9DUQai6GZOnuhag9McN737qpIDRxxOugkk-glWd-hou_D78sncHzieP5>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 22 May 2026 06:54:43 -0400 (EDT)
Date: Fri, 22 May 2026 11:54:41 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, 
	david@kernel.org, ljs@kernel.org, surenb@google.com, vbabka@kernel.org, 
	Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	seanjc@google.com, pbonzini@redhat.com, jthoughton@google.com, aarcange@redhat.com, 
	usama.arif@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 04/14] mm: add VM_UFFD_RWP VMA flag
Message-ID: <ahAzY0CKNzE-SOd2@thinkstation>
References: <b47d8d5681fd8730f6090ebfdb72f219a8edef1e.1778254670.git.kas@kernel.org>
 <20260515002932.124892-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260515002932.124892-1-sj@kernel.org>
X-Stat-Signature: bufpnadhuodps5a5o633n5zop8qjwzou
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0629F40007
X-HE-Tag: 1779447286-196608
X-HE-Meta: U2FsdGVkX18hgMcrNTpikEspcoia395+pNX4W3r0NZOGIWozz3jc9CvsDDR30ItDJOC6Kjcf9DP6lBHe7zjRi/zJ+bLgV+3f4J3IVh0D2JhXHyHyAirUGGfxitQL6He/vVrZVimDTJ8jydeCGm3nsZ8Mbt/qQYoZWk0Nw/zXIBD1pkJRt6GZHJODLrscHK7t1gNkBFxql+Jf1IwPuoaw5BM0kF4wJPzZ7olgKAZRkeDNS0OEWZp4vByVBTP56LjgMQrbE2tbYCObUqONOFR21VyBULsFtNWPn1kC1Qh1fEsh3UsyNDQa037qdVhdCQp+lxvLhxhqIAakIQ2AIv6qxiPRYuslOkL30uMYg6bOaE/qxb0Upz3p6V3jpzP7MzimLjtdoLtvWAJDTbyVTeat4kemiVOSZm6IbZXSUoN4Wl2ff96b+fvxoSdQUeKV3w5UafFksNwOyNGoX+YhUEbi7JBgv1K3jngOGrzmneAMVa9N0PuOS+Fe3mttVqNanL1TVioIJ5pmb3z9TLhSRH/zC2oBIU4tnNsiGgjhCA2Dg8sM1khq6nvMyAYdvBpWKWhEeCl+sQ9g31ml5FV3CSL00PzCAOLsUWCLaQhJGH8vTwlxkdAuU+BofkAavBnR4QVd1PBxLhejT7nVq3qHp++JMzqEpJY225HWFvmJjKNRMq0cyw5hT3jtWhuAFwpcpbqYjI+c40wftvmxWU2ZPihv9K2WmhjG435Ojj8n10osn8a2Nzy2Drgir2QinOeM0GYzRpo6ORZMBIqHKBdn6EP5Ahw3f5Bwv5lS6oKpPrlIwEn9a5TgONbaT+Pwk3WaMn+UjTh34JxtC6HaRRZXE6oefDMVa2PIHT3pqoRlk4KjW6CU2X82Zfn1ETKqwpBN9Kj/tKvqnKnD9E5XSaB9XV+62OAEQu0lssjPs87wD1A1pfzjUNRM35YOZsMTkMKBNhWEP8QAq0NLybC1bdxeKSC
 WIyIVwQh
 vec9p/p/HDyglqj4ttiElETgd5BViA/3uQXjrtwRZZcNJDTG/PX51SrbNdmCid7jWGoOTFe/VUGJT9PxjlxTzGB9hpYQu9+fagdFCF9jSAy6M6eoA2T0HJRdU7JpuJhtWDi3HNOfFIAs5DD1vO2ObcBXT+M5DlSQ/2+1GWbqfkIHg/aXPlY1mjDckVPNclcsfWTLzhQJLjDsEbOABS9ssx/NQnnF28PwNUokdgydd5x2HLY8xw55hTuFYopgM5xfXvzKCe/AsDvJF4Cehht7exLcLMz+RE+BzWj0YSkGYP2N3GBMViGKFaWHTeJ2lIY46povIwz1NH3o4TT52ngXKOXuGPiEtEnAPHgKu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 05:29:31PM -0700, SeongJae Park wrote:
> On Fri,  8 May 2026 16:55:16 +0100 "Kiryl Shutsemau (Meta)" <kas@kernel.org> wrote:
> 
> > Preparatory patch for userfaultfd read-write protection (RWP). RWP
> > extends userfaultfd protection from plain write-protection (WP) to
> > full read-write protection: accesses to an RWP-protected range --
> > reads as well as writes -- trap through userfaultfd.
> > 
> > RWP marks ranges by combining PAGE_NONE with the uffd PTE bit, so
> > the flag is only meaningful when both primitives exist. A new
> > CONFIG_USERFAULTFD_RWP Kconfig symbol auto-selects when CONFIG_64BIT,
> > CONFIG_ARCH_HAS_PTE_PROTNONE, and CONFIG_HAVE_ARCH_USERFAULTFD_WP
> > are all set; call sites that gate on the flag depend on the symbol.
> > Elsewhere VM_UFFD_RWP aliases VM_NONE and every downstream check
> > folds to dead code.
> > 
> > Nothing sets the flag yet.
> > 
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > Assisted-by: Claude:claude-opus-4-6
> 
> A silly but loud thought.  Would it make more sense to put Signed-off-by: after
> Assisted-by: ?

I am not sure. I see it both ways in git log. And I don't have strong
opinion on the order here. Keeping as is.

> > ---
> >  Documentation/filesystems/proc.rst |  1 +
> >  fs/proc/task_mmu.c                 |  3 +++
> >  include/linux/mm.h                 | 28 +++++++++++++++++----------
> >  include/linux/userfaultfd_k.h      | 31 +++++++++++++++++++++++++-----
> >  include/trace/events/mmflags.h     |  7 +++++++
> >  mm/Kconfig                         |  9 +++++++++
> >  6 files changed, 64 insertions(+), 15 deletions(-)
> > 
> > diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> > index db6167befb7b..db28207c5290 100644
> > --- a/Documentation/filesystems/proc.rst
> > +++ b/Documentation/filesystems/proc.rst
> > @@ -607,6 +607,7 @@ encoded manner. The codes are the following:
> >      um    userfaultfd missing tracking
> >      uw    userfaultfd wr-protect tracking
> >      ui    userfaultfd minor fault
> > +    ur    userfaultfd read-write-protect tracking
> 
> Yet another silly but loud thought.  My first feeling on this was that this
> reads like 'u'serfaultfd 'r'ead-protect.  And was further thinking 'uf' for
> just 'u'seffaultfd 'f'ault or 'up' for 'u'serfault-'p'rotect might make sense.
> But ended up thinking this is too trivial and ain't really matter.

I will keep it. It's "u" + the first distinguishing letter of the mode
name. r distinguishes RWP from WP cleanly.

> [...]
> > diff --git a/mm/Kconfig b/mm/Kconfig
> > index e8bf1e9e6ad9..ccf534a8cbc9 100644
> > --- a/mm/Kconfig
> > +++ b/mm/Kconfig
> > @@ -1347,6 +1347,15 @@ config HAVE_ARCH_USERFAULTFD_MINOR
> >  	help
> >  	  Arch has userfaultfd minor fault support
> >  
> > +config USERFAULTFD_RWP
> > +	def_bool y
> > +	depends on 64BIT && ARCH_HAS_PTE_PROTNONE && HAVE_ARCH_USERFAULTFD_WP
> > +	help
> > +	  Userfaultfd read-write protection (UFFDIO_RWPROTECT) delivers a
> 
> Seems UFFDIO_RWPROTECT will be introduced later.  Would it make more sense to
> add this config together with the patch?


Okay, I will move later in the patchset.

> > +	  userfaultfd notification on every access -- read or write -- to a
> > +	  protected range, letting userspace observe the working set of a
> > +	  process.
> > +
> >  menuconfig USERFAULTFD
> >  	bool "Enable userfaultfd() system call"
> >  	depends on MMU
> > -- 
> > 2.51.2
> > 
> > 
> 
> None of my comments is a blocker.
> 
> Reviewed-by: SeongJae Park <sj@kernel.org>

Thanks!

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

