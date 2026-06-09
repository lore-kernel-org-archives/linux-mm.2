Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC640CD98C5
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 15:33:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E76D76B0088; Tue,  9 Jun 2026 11:33:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E27A26B008A; Tue,  9 Jun 2026 11:33:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3E086B008C; Tue,  9 Jun 2026 11:33:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C74DD6B0088
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:33:26 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5E47EA0609
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:33:26 +0000 (UTC)
X-FDA: 84860768412.18.792E478
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7915B180008
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:33:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="XVSTOPs/";
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781019204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b6BCUZOSGcGQwGTjfIKiafZBTm2kPzDMfyKQlIS2Xtg=;
	b=58W1clojSLelx2yaLw1jrKykYUgiT0Zdrumg8HK/+bWVTfpaFeRSmHmaU0VKVGJ6HJiBtO
	nKaYG0gnqoP4t/OfWmJn0ydpZHXuPaEykpYlkK6uxLmnHDRA3FmioQdtPqjGeg0vG/ab7P
	UEAZFiTgRJhcJMWC4otxLcrKrY1h1pE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="XVSTOPs/";
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781019204;
	b=0SgzMOVyIuxM8EHD5ecyQjLUq+hgtTdNhPY+ZDJbr1kTwMpov/rLhmVYXEsGBSnzOm3TgE
	s1juEwzu/FWR4CeFHnQgprZZUBNjR6+mcbE8fcRDeN+kK0fscBFm52RTKjZNdu+7VsvzFs
	3SM03E7mSKEInlg309HFyjJXV6YAfvc=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5177945a279so60892911cf.0
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 08:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781019203; x=1781624003; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=b6BCUZOSGcGQwGTjfIKiafZBTm2kPzDMfyKQlIS2Xtg=;
        b=XVSTOPs/aJBIjJJTgJt6L/55rRJgug/oYzprhVGM7FpldWxYHJ0vky5QLBCvfkHLQy
         rT0yG+uh5hkvAraiMCd55xxbPzX5VoOAc9mC311z4twdVw+9mcC0RKE5BT59nMXCb5aa
         +kbClLtTie53HWTFL661G24AMcb3/Tq4jgaVFOnpE//dqGEY/kRvhbqA6xMwJJ6BHS8I
         fV8x3lEeClsIP9Hu2D8JHNTJi8GqIcJo7HCMftIaSpBoGOzf1xldyMmbpvMD9h2RR554
         osRfnnyQ4/u2ckf0ku3rwctZaWG7j9PERMr3MqjYKwyqq+JR/77Cbkvm0pAMcXpwvGS7
         yIrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781019203; x=1781624003;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b6BCUZOSGcGQwGTjfIKiafZBTm2kPzDMfyKQlIS2Xtg=;
        b=HgPGy9RQnqTIK0RY6E9Y+JbEH498tFaUDChbcoAX7ulhFsGiVvRaof6+vKtFpNUmKR
         yosGaD+cv1CISBVrrFwRPDQQGnhSjJbY2VFSLPrHhCWPD2jAsXERZn/tKB5V58zIba94
         Pt5B5bkFB4XIr31vWTpB6juCx1+Mh2gP1PSYXuAJ+i0NGJiemj1r1qWpR6vi4MUY88vI
         VOu2vgf8DuXbjlbY1DHXU3hn/yOdPdxoNLNZB0pxZ9UbxvJUZsNR+hLJVAYgyCCcYDKf
         8u7SPpmm/PLhJysRuMG6IlfWAlEQ4S2X7/b35PyxP7oO97+mVlFQXg38dQRwxUH9ulI4
         XGUw==
X-Forwarded-Encrypted: i=1; AFNElJ8oytig9xLjJVT72AeVuR57AaNsgld9gV0RgnE8BDKGEV86U77stZO+yctuOx8jv7aO19uSk1xSkw==@kvack.org
X-Gm-Message-State: AOJu0YwkW9uzWYdzIsyOZp0QA969ACH7yuqx3lFBLE3yQYYaOspxekZh
	3N5ekC0e3GIKz+5UazSTvhd/hOKhZ48s5r9+VirHv4/yg62HtWWQBF0gk64M/AjYH2JIgQ7PAFJ
	4tEy0
X-Gm-Gg: Acq92OE0bQBj59wo2kjrlQ2wvD42gIS03Eb9K+7gp+Ddbe3KE68WBByy5MTwBs5oHZv
	4kHsvBijLCTVqoqrWq/82hNu9WOaj72l7jnrue09SEf79Qcg3SrzhrSvgIkqLmdTO4SgtO+Ws9v
	5xMdf1I1Ingl80t8eSxJ2u5AP11DYFp2pCo0BcSV0fmqCfMW8jJcuWb1g74jcNrwZOUU0gstn/O
	GE3MG58nRwUdfmXwCsT+ntyT7QyOAoC+BClsOnEye5oywtdXPkowvmePb3k4p+NJMFUkXZvFYDS
	CVeeIh4W5BHnzO/MNW5/3fmd5nDht2CatBmr4uDxIP6FzaGb9TiSGXluDEpeueWvQNH4+daa7xs
	PyOikOafJNilhToOpNdoKLHLAaBvUMQZKh/avi0kw+BgJloZn2jjcKg0f7/Om6Ddt8ANcbB5QwG
	CLbVTZLuZn/Lm4VX9qMzQvOjXJ3je9gcNBQEaoJZrscF6TzWaA7u1Gdrszf9wprz3A/mOzOqWmE
	virViDHIblCTYtvCA==
X-Received: by 2002:a05:622a:1451:b0:516:e10f:b1fa with SMTP id d75a77b69052e-51795b0cfa8mr290431301cf.2.1781019203248;
        Tue, 09 Jun 2026 08:33:23 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51775dffb14sm193985651cf.28.2026.06.09.08.33.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 08:33:22 -0700 (PDT)
Date: Tue, 9 Jun 2026 11:33:21 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH v4 6/9] dax: plumb hotplug online_type through dax
Message-ID: <aigyQcBH3HRrOn23@gourry-fedora-PF4VCD3F>
References: <20260605211911.2160954-7-gourry@gourry.net>
 <20260605213143.A18F01F00893@smtp.kernel.org>
 <aiNFezMarbvIZNa0@gourry-fedora-PF4VCD3F>
 <878faef6-bbd3-43ec-af82-6da675a5f8fe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878faef6-bbd3-43ec-af82-6da675a5f8fe@kernel.org>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: pzbq3jnza4qirfzsoqq37fgdnduajce7
X-Rspamd-Queue-Id: 7915B180008
X-HE-Tag: 1781019204-138389
X-HE-Meta: U2FsdGVkX1+RU4X0CKB7FOLP7aEII1ls5JKVCMrLFxsa2Ti/kWkX9pB5O7Fm6zZLMNVRQ4WL0JhAZ9KUjHMLLofB6a4UF/6pc8l5inElOp2XzwAR55TYRQfIfxGrd1M0dX+j/Ao630JBDivBCC/TdzTkIhxWdv5cy+70Oc/s9W3RnRpkRisGQZTijmJBLyT1TutS8SoUBR3ajNHYqCGlTyCzmaF6Ut8r/gdf1gTw6MEjMaOVF8cTPJy24thnkxJFIw5hbi/q7rcuff4Rtvsqiguj5zB7pmyHFeG8LJ6ImegAcEp19OQ0qR5VDD2NKJ7FTdNKXIYn26flEMtggDO62Xy8RXZLZ2IMtQ86QYB1NpguLLNy+GnQVC7s/31TKyjlAMIdn/dOdQNrm+FOeI2XiL35wXZzqe6bjlQacmzzb/7j7F7z8oAeDqp/tZrSLHk3s4zmgqnSPebjWs/bKGzWCDHk1RbmsubEy9woIekkkZw8TH5qVxePF4aGc+7B0CvIfDb2J7RW8yfU2SQFcmCUyGx6gHN5SmTOrmsrR3ahrHAbymRfjG8EK3NUFaN8NiCfHQG5a0rrXT45RFf9yvhV1xNRkkGZloGjgwJAvekSBnIuZCsC+a5YWb6bmBPVIMbq8nBdRJEDvKC2BQF7yTkj+RWDkqtxwQTO4pF6mPOmoK5yPWopJ07TtAsIT36rCEocEeZNp6fB5VsZymwdtkiSIBFk1KlB4StkLzRo0sjA9zvs12rl7e3LShEvwtoJ6fPV8oNlkQC5YGTc1fz7vp+cW9G+Y6cztIZpjnG0YLEzBjwt1DM1AYfcZe0zI1usq0TWDiz0Q7r3XhQV6eNDV4NyLoPBVB67gq/eIrtacSfmSusL2NM6cDmWzmxc8wqMS0Cq6yqi2LMSZS/K/mN5DFyBEj/OFapMwZueNHSPnjAUF8uctnS3ZwUvPXLqJXc2HAsjORmkCFvo7uJDaaGjuZ6
 stSgNRQr
 syzbMgFyiCC0iSK1Z3mDBqz872hIWnMijmiL5NIxOjSJz2G1qSu+ZxO+9WxH9uQ27oew1vyZJMEW6yq3CIv7azaDWA9UWUl0xWBdLgAG/krdXGWfNt3Vj09fHHIeiT8bOElNeRyslEEg7V/6m95z99JbVkIyVh9netFwvNSAA4orbdb/oZJyUvb1jHIC8czFuTtkLQgwkL5BF2FymOJhSDs+v3g2piEfUMgGcnu6cOldVi640B47nF54Nhwfi4sMlgkq1NQjnt89If4ITELliJVJReoyDsukrvNDT8QPckPcst0jWkFUrVWxB7TQSD81IX6GBMIaoRqytKGsKU56VzHVYwE16LaeTXzxL4VQJO+yT+vdcNxKvr5WcImFXgPk+M0QAYuYSO9NMI19qABK5pRv458xmM29WLcOH/aACeMlfWM9XP2M1z/gLGXg5O5RHmZKOHDRUYLdq+4Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 12:21:34PM +0200, David Hildenbrand (Arm) wrote:
> On 6/5/26 23:54, Gregory Price wrote:
> >>
> >> [Severity: High]
> >> Does capturing the auto-online policy at device creation time break dynamic
> >> sysfs policy changes?
> >>
> > 
> > @David - we talked about this ~6+ mo ago at this point, i originally
> > proposed something like MMOP_SYSTEM_DEFAULT
> > 
> > https://lore.kernel.org/linux-mm/20260114085201.3222597-3-gourry@gourry.net/
> > 
> > https://lore.kernel.org/linux-mm/c4ed9675-269c-4764-86d5-87f4f83fc74d@kernel.org/
> > 
> > '''
> >    I don't like having fake options as part of this interface.
> > 
> >    Why can't we let selected users use mhp_get_default_online_type() 
> >    instead? Like add_memory_resource(). We can export that function.
> > '''
> > 
> > I guess the argument here is that the value can't be cached?
> > 
> > But we can't really enforce that.
> > 
> > This is a behavioral change we have to agree on (either we change it or
> > carry something like MMOP_SYSTEM_DEFAULT for this).
> 
> I don't think we'd need a generic MMOP_* for that purpose (the core cannot
> really do a lot with that AFAIKS, and the scenario "unspecified" doesn't really
> occur in memory hotplug core).
> 
> I guess you could have some indication whether the user already configured it
> manually (bool online_type_specified), and handle that in the handful of places.
> 
> if (dev_dax->online_type_specified)
> 	online_type = dev_dax->online_type;
> else
> 	online_type = mhp_get_default_online_type();
>

Hm, I suppose this would do it.

I'm using -1 as "DAX_UNPLUGGED" at the moment, but I could actually just
add MMOP_UNPLUGGED as an explicit mode which only has relevance to callers
of hotplug (the state of the hotplug region they currently control is
MMOP_UNPLUGGED) - but not to hotplug itself (memory_hotplug.c doesn't
use it / rejects it).

Then i could use (dev_dax->online_type == -1) to mean "use system
default"

I'll bring this up in the mmop/str patch whether we should add
MMOP_UNPLUGGED.

> Of course, you could also just call the old interface when adding without a
> preference.
>

This is essentially the same thing, but we'll eventually want to pass an
online_type through the interface, so may as well just do as above.

> A negative online_type could also be used as "unspecified" in your code (MMOP_
> starts at 0).
> 
> But the question really is which semantics we would want? is that exposed to
> user-space somehow, such that the user could query it ("default")? or how does
> this get set, and how does it later get used while it could have changed
> system-wide?
> 

I think this is the core question.

What selection of these values do we want?

  echo default        > .../dax0.0/hotplug  # -1
  echo unplugged      > .../dax0.0/hotplug  # MMOP_UNPLUGGED
  echo offline        > .../dax0.0/hotplug  # MMOP_OFFLINE
  echo online         > .../dax0.0/hotplug  # MMOP_ONLINE
  echo online_kernel  > .../dax0.0/hotplug  # MMOP_ONLINE_KERNEL
  echo online_movable > .../dax0.0/hotplug  # MMOP_ONLINE_MOVABLE

  echo default        > .../memoryN/state   # -EINVAL - nonsensical
  echo unplugged      > .../memoryN/state   # -EINVAL - nonsensical
  echo offline        > .../memoryN/state   # MMOP_OFFLINE
  echo online         > .../memoryN/state   # MMOP_ONLINE
  echo online_kernel  > .../memoryN/state   # MMOP_ONLINE_KERNEL
  echo online_movable > .../memoryN/state   # MMOP_ONLINE_MOVABLE

And lets say the use sets a value, should they be able to return it to
the system default?  I don't think that makes much sense, considering
the default is really only used on probe.

i.e.:

  cat .../dax0.0/hotplug                     # default
  echo online_movable > .../dax0.0/hotplug   # online_movable
  echo default > .../dax0.0/hotplug          # -EINVAL?

The point being that .../dax0.0/hotplug doesn't exist unless the dax
device is already bound to kmem - and so by the time you can set it, the
point at which (hotplug == default) being useful is already passed.

Does this seem reasonable?  The tl;dr is

+ MMOP_UNPLUGGED
+ #define DAX_HOTPLUG_DEFAULT  (-1)
+ dev_dax->online_type = DAX_HOTPLUG_DEFAULT;

~Gregory

