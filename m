Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 610B3C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 16:48:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 272116B0318; Fri, 14 Aug 2026 12:48:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22A336B0319; Fri, 14 Aug 2026 12:48:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EA1E6B031A; Fri, 14 Aug 2026 12:48:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D46816B0318
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 12:48:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 51C5E1601C0
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 16:48:28 +0000 (UTC)
X-FDA: 85100458296.01.36EC58B
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7EB4818000C
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 16:48:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hk1d9+Qc;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of praan@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786726106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mG1kOJ+Tut2DmZVpOA/Iv9r39LYIA7qLrHZhoVN2dxo=;
	b=4Y+zw330WlT4PxGX44c5GekOgtRE3JvE3vDZv+mVAYwjNt8a8rSY5z4dlrWxG5EqDZP3Wd
	1m9oVyew1lq1GCCxUpUu8g/Jg/7acCP3598qyHAQy+nBz8pGD6QJBeS3VlYYZwPwIbg46w
	KEo+yaTcFKIhvNYsavY+qGVGbPJAL+8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hk1d9+Qc;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of praan@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786726106;
	b=B9K3yO50mIVhy2F7l9mDXR2NeP1Z7qoA3ud6DYef2T30OgS5WyOcOuOjceLwZev2EiumaL
	b3/LC6gYZtyZmyf0MhJVQrr1ZRqmTTWplBrQUYgqtfekpmjNmGtVt4nOvpRQMbR//fOhNj
	3OzB+Anebz/hGZmR2zZ+rsKlVELFRoc=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ccdf36f63dso134725ad.0
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 09:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786726105; x=1787330905; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mG1kOJ+Tut2DmZVpOA/Iv9r39LYIA7qLrHZhoVN2dxo=;
        b=hk1d9+QcoiEYtAGX6AxyobciKmWewe3QYHL7e34qPiKh9KU88PAfh4fLhE/To7ktM5
         1lmyAoqulUgw52taTq2IePwIoeSE6dLZqXXraWd4svIrmt8FxuL1bp5oTluSupxJEt3O
         IsLtYPOqqSbC7i0EAlbt7V52RzOobo/UcwT6s4oPAupz4KwEpLzICVFGmhwvG9UH6gL1
         RPoih6ixYDQiRgEW/6NukO2ZW39i1ju1GBMgqLvCTJiPlta4X+26YzENKStO2OpWuNGn
         EwMiVwORJQkgvto4jz1xyRRss7tZjn0m2WBsfr7Sy6+QQMgRKaZi4YqTVQ+8hJG6MhQd
         j/0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786726105; x=1787330905;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mG1kOJ+Tut2DmZVpOA/Iv9r39LYIA7qLrHZhoVN2dxo=;
        b=JQH7TeeNvOQX834cNX4XrQd4J1lq0iFlp1Aye4/gQ6nr2GZwPWg6cINs8yiD5gipYp
         OWc8Fu8FksN8FJtxmGUnVT7STtby9HnMkuu16lrgTb4hcU1tiMhOX6azKPsljBEVSVqy
         kCG5y2xONNN2jwQMDCov2hY9RIQlh7dwJ+wIDxMJihBEpJ0EuStSQ/b+pos6OADs84xA
         lpvHc9xvw/NEzXe64ceOmA9HFsi+uCJ/8hMefmuk3UJTzTMIDJMyvCH9sue05StMqFQm
         sqvmOgCMtmvH+JtVa1Dnolri1GGJErdeYBRlXkBdkoMkL4YQ1JCPEFi+olOeeELaFjOL
         IwSA==
X-Forwarded-Encrypted: i=1; AHgh+RqfOtyNQnyuQ01mRLmkVlt36P/192vDSmStjcHaaux/If8wvffowY/3nZ8iG//vlHhFV73ZgYmqYg==@kvack.org
X-Gm-Message-State: AOJu0YwG0uEYjTMjn9HVaIWdIEOCW6ptFHydDm3IGMRgWkaQFzvbCdID
	f1vdo1oryI+Y3g9p8H5aJ/mytztdPlSzNId82HeNSfOItjjl6oWUk+78yYsaCdYI3g==
X-Gm-Gg: AR+sD11pERwjoUQN6QMUq/g9xES3ShEgPWUVJ/qSCL//I93aS6+TYagAXdoezdlkjhI
	iaZfIFxF+fKCRMOZvMBpvpUJKOSYzeOpOUcuVF9N93L9L266FPtVKCTRyIFJLRnOB/j3NeoBkXI
	aTZwumWt7V8bQTaof/T6E0nSzM+zMyXVdth31oa/9hSyHQMPax7tio5SWgHw5IzJufFoVzDxK4g
	pkvKVGzy0UqbGR4tDCQ6KI/PoL0IMyOjLQJdUeJF/0tiHptLQ2e93zcjtU8MC2rRz8cI0p712CY
	gNv/YC2ywe761Vy9Gk4hNBhl0SOuXZWzKddg0SB7s/u0ZnYQ1/neNbGDPwCqmHdWEumr7f6MiNE
	JjAsOTeVTSX4oqXZCBlyXFmferv4OMxAX6k0D2EoGYObVxifdQJHBZXe3a6mMbDG4olyOoDJ+Vz
	9Aa7xRPYsjGSmSSpq2CKEqr3n9atGMidQ0HJUnwIWmZF3I3ODY+YaBHOvlbwGsfp7hFm/sv4qGL
	GqzPdQV3yrbgIjXTRoSH9s=
X-Received: by 2002:a17:902:f78d:b0:2c7:b1e7:501e with SMTP id d9443c01a7336-2d3b48aa5f2mr7298295ad.3.1786726103643;
        Fri, 14 Aug 2026 09:48:23 -0700 (PDT)
Received: from google.com (21.168.124.34.bc.googleusercontent.com. [34.124.168.21])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc095a490c1sm935638a12.29.2026.08.14.09.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 09:48:23 -0700 (PDT)
Date: Fri, 14 Aug 2026 16:48:17 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	David Matlack <dmatlack@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/2] kho: support preserving high-order non-compound
 pages
Message-ID: <an9G0Y3ZNIA2NfjP@google.com>
References: <20260803113944.3694290-1-praan@google.com>
 <anr4-F-e5_vHEar8@kernel.org>
 <2vxzv79f39za.fsf@kernel.org>
 <anxrvA3z3NUkWvnE@google.com>
 <2vxzecg33103.fsf@kernel.org>
 <an2tArzOomSNpjV9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <an2tArzOomSNpjV9@kernel.org>
X-Rspamd-Queue-Id: 7EB4818000C
X-Stat-Signature: 5mtotnzccqhej1df9gq7ia8jt5sxy8st
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786726106-1068
X-HE-Meta: U2FsdGVkX19FFW29IaDBhHWZpXRE2P0lOT3oRB9LxVNFGO7CyjKjYvvAd16U611vS2LTVWMeHipOPkicPqpGGD1FRNdx7EJJm39V/k3qlZ2U9r5CWPi1UGxdto29t+tAGVYF2SDy7R2FjUs0oX/MBf87l3aHqUNYvJZdLVnBzEnUO0Pcd0vnmh5fIwzeexSqx9te6BOX6TQwP+3gpT5e1y26ZHUt4/AgCAVMZCDKC+OQwiRuBEyhiIK4EdE5j0fQEz4wmUd8gzgrzLStThNQUyRSJmmuWp44d+7B2YuyWnKUjNQRXJzjuMvp/1RK2Jmz9A40376/UJdY7IxnSjYHHz4L6Zq23OgzWKmOnjPsfuclBG7Lpaals9CZ/k3NtwcLyHqyQ3QgJRqXM1Aix7afLoD1gslk6mUWiRA60hui1rhuWYgN9pJd82rhJRgDZu9ofFO090516Dc4AhTJOTvT5jv1lfbCtn3WmHYsn3Z/pNR82yznVMtr4WTvqn9YElNTtwNIialh+e07foso7rknGOPUE7kFu8ed9HR6s8TslNZK4nI8GMIFIP8oS0l7cHr7t/tkFuZW7yC9pcFD/gaj0BWpDxACig99hp4ZVda3wjl6gem15Ezu40Emq1GYLr4hHBN3VjcKM8A3BMi9P2oNvR0bbG+gBPU/lTjE2+JI+c11wzmJRVxvwmRoeC9h7uQwPfDS2qsf9PKvm9F8d/fj+ZO3NUmlZvBz5eQAiE1zTMFSyIxP04NIwq2rAvgLjJ2hjlZYLb+Ied5kAXoL4/naZSBkaRyfx13TIaXtq8OA2jyZZV51DMMaup2Ec1pyO+K2hcUFcsvj1Ab5P+ROKYZ6rQppMWyz68qKbOzyzLWAlZOl2uEFCr4DaXk4CC7XeOeq/wW3m3jFLruwOKtH7+IrLg/D649ufDw2OYX9QbKYBOsVX8IuW4S9Xqt6/KzsBukbpud8n4+Yw/POBv9T79q
 FyhECS9H
 /BnBl/b6X24pm/NJKdX2P9zJY7pQP0K5rc45QRlsBXJL9M0H+6HB+QoVadEeOOAXoxqDGghYkSOZ02lySrIxNT/xognauNKzHJGkohbiUxfDDOgkFbO/+374PK15xmu8iEhgvdc4MB047bH/xq/JdX4qq8D6tXdG0rJO9lzss5N49SJj5jkMki0JP+/HJP9vd1Q4YRYq9lFY86tX9LhzH4dxq/bU/y5hfevHTQDZt3JMSfX58UXT+E33kc/b0TzcHoMDMIglS+DGHENbdDAJ6lmJGnQPEUGM26gMZxFVGemU+GccrQN9X/HVWIsmLklIB5dx6lqlV8J0aZNj9IA5qEBj38wcKdULKxRbIWTgcFyw8Rw8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 02:39:46PM +0300, Mike Rapoport wrote:
> On Wed, Aug 12, 2026 at 03:46:20PM +0200, Pratyush Yadav wrote:
> > On Wed, Aug 12 2026, Pranjal Shrivastava wrote:
> > 
> > > On Wed, Aug 12, 2026 at 12:32:25PM +0200, Pratyush Yadav wrote:
> > >> On Tue, Aug 11 2026, Mike Rapoport wrote:
> > >> 
> > >> > Hi Pranjal,
> > >> >
> > >> > On Mon, Aug 03, 2026 at 11:39:41AM +0000, Pranjal Shrivastava wrote:
> > >> >> Introduction
> > >> >> ============
> > >> >> This series is required for the ongoing effort to preserve DMA allocations
> > >> >> across KHO [1]. It addresses a fundamental mismatch between the current KHO
> > >> >> restoration logic and the physical reality of high-order buddy allocations.
> > >> >
> > >> > I skimmed through the patches, they look fine to me before the in-depth
> > >> > review :)
> > >> >
> > >> > But we are really close to the merge window, so we'll anyway need to
> > >> > reiterate after v7.3-rc1.
> > >> >  
> > >> >> The Problem
> > >> >> ===========
> > >> >> The current KHO restore implementation treats all multi-page blocks as
> > >> >> split pages during restoration. Specifically, kho_restore_pages()
> > >> >> initializes every 4KB sub-page with a refcount of 1.
> > >> >> 
> > >> >> However, many kernel subsystems, most notably the DMA allocator (via
> > >> >> dma_alloc_coherent), frequently return high-order non-compound pages.
> > >> >> In this state, only the head page carries a refcount of 1, while
> > >> >> all tail pages have a refcount of 0.
> > >> >
> > >> > This hints that these patches could be a part of the DMA preservation
> > >> > series, unless you expect other users of the new API.
> > >> >
> > >> > Generally, we don't merge new APIs without the users and if DMA
> > >> > preservation is the only user, it's better to fold these two patches there.
> > >> 
> > >> Makes sense I think. We can review the patches here, but then they can
> > >> go in with the DMA series.
> > >> 
> > >
> > > So.. IIUC, I'll post a v5 here as a standalone series till we get
> > > consensus, and finally the reviewed patches can be folded with the DMA
> > > series?
> > 
> > That sounds good to me at least.
> 
> Yes, although when the patches will be a part of the DMA series we might
> notices something else :)
>  

Ohh yes, definitely! Just asking to know what to follow for the next version :)

> > -- 
> > Regards,
> > Pratyush Yadav
> 
> -- 
> Sincerely yours,
> Mike.

Thanks,
Praan

