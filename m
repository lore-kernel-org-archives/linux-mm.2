Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB9E9CD13DA
	for <linux-mm@archiver.kernel.org>; Sat,  2 May 2026 14:57:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3AE36B0005; Sat,  2 May 2026 10:57:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A12766B008A; Sat,  2 May 2026 10:57:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94F2F6B008C; Sat,  2 May 2026 10:57:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 842736B0005
	for <linux-mm@kvack.org>; Sat,  2 May 2026 10:57:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C354640636
	for <linux-mm@kvack.org>; Sat,  2 May 2026 14:57:32 +0000 (UTC)
X-FDA: 84722783544.08.EFCF694
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf16.hostedemail.com (Postfix) with ESMTP id CD7D7180002
	for <linux-mm@kvack.org>; Sat,  2 May 2026 14:57:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="tZ/FDRoJ";
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.48 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777733851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EYA14pq+CY0U9Sxh6f6UsYdGKim8qygJpX+jtNAVFy0=;
	b=qw6HEy8qbvmAVOYloM0B8mvo7F96XdAveRAfJTPoyAUnE47Ct98ZAV15l7G7V8VDAmoqW7
	CPTHZjoo++t7h3yW3PtoHBHHLkJimZIfexr5KJCzVjNGhzaKyfN50t+rN0DwJtUeAPKolx
	nZKuG/0iQGB4sGM/xvKGpqRSF1LYRUI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="tZ/FDRoJ";
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.48 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777733851; a=rsa-sha256;
	cv=none;
	b=lx4Wj6+mBuRdpykZOHisb9GFEqXL5ulw3EJcX7vkFTa0zERisc2VfdA5H4443MDdF6nYgR
	FK2+V8nrrxW/p35wLZLHKGeRUXCXfTGDhi8/1FqcsEezZ10wiVF102YeuIwRkI8Qgjfx5E
	o5S9naXCHE2ytelpuZNkPKfQ2gWKmoo=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-488b8bc6bc9so16526135e9.3
        for <linux-mm@kvack.org>; Sat, 02 May 2026 07:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1777733849; x=1778338649; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EYA14pq+CY0U9Sxh6f6UsYdGKim8qygJpX+jtNAVFy0=;
        b=tZ/FDRoJy4izyLa7h/FLc4gT5kTp4HoCRrB5GCjhiBnvQYBcHvGS9pW95npLWJq0+r
         45HMmyInpww826ctXx4Y+jwTwvH4hray9dGagpv9wHORPxDHPu6QIwkLKfdIg7y0crRR
         A4t0XAAVpNUAmFfCxvqS1uoGu8ulnEiKlsTWLEIYkgU32PXZs/CIskdMn28tTKpzCdS0
         /yAzFv/L/bpkxAkF/aND8g4HSSF0teiCX1XlCPZa3GBDSijTyWvGr78lmE8QbfyJA313
         etcX7wkcoGW2OmwgdVMhR0VppnkOBXlVyt/XBHuhWVnbcMGlG+4NEJpJj2gdwpU3Sdcp
         Nz4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777733849; x=1778338649;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EYA14pq+CY0U9Sxh6f6UsYdGKim8qygJpX+jtNAVFy0=;
        b=qypQQ3jCsbS3xClgAzoTQLJrre65AVnIkzh/+XdAjUI9S4zoTFoRaYaDxVy48DGXS/
         p9K9VwtaXaZKT4Oj5vOCYYFLdh6DWX3BRSQKxNZqAu1grfRC2R5nJIRNB7uqmOiUsios
         RJ9x9A72FCKhZgQdxsDC5QQycHl+GqW86SzkkjKNPalJeQdcLq1Fp03/8mKEAphW+nM6
         yC7Ilk6EicyjImA8LiPNaVhlsyFg5Rgg6lnnYjRx2rAcugkwHBAFA1b4S/jURb3sc52w
         VT6RU6u8HtdBZNhr7Xz7U3NzBee3a2kxUGOoIg5dMqROTMcAhuO96FXE7UorGxSwAr/x
         kgrA==
X-Forwarded-Encrypted: i=1; AFNElJ/UttKWstH2S9dRfs3a5y/YIAu4gJ+KISFaNcpsW/WIH4eVehdN6PPURrbWCjAwUbOSIG0NudsVHQ==@kvack.org
X-Gm-Message-State: AOJu0Yyy7hckuhb2cGEb+wlno97kN0vy4GfQWtCaSoyEL0U5hcnHZs6+
	AEeoXoTjI3IQvHb3/jHRh+yjhuMfSED47JE4klLFmZEBFXEpr1GCqwFSA/tqQgPIqnY=
X-Gm-Gg: AeBDiev9Yds2oSoPfWwyCX2M+ZcffgOTZlzzIm3zMeIMjsLZ3NwFxbNO/7EUBq0WSkP
	GIODzAqxNsUpy1SBY/B8X7iYLYc1iIyZJvFhanjHoMi8m6Y9FNG4w9WPPM31dno94xOhK1S2jho
	vtbqUa/9+ioJ355fKP4AycOuJTark3LS4JSrPhT2iiKM2Y31FpaTGNjrT30Q5VXw58onrjBc7zd
	rYyiCorliLbKnysUD8XVbuJe0JwPIeedA5ppURuMeXFDRnEM95uzMRiDFDayh5+GhR0nMONpFqb
	GgDBvnqNO4Jl2km003zA/SYAQHItVWe2EIgI0o58pmrlq+JKEOvNN+6/9blSxWT4NMEk1yUCs9g
	ZDzAbfMiQYTt/U4qbHA779xpRcpOwe1IJUxEwgwCyUabdfSitiPRCmS72/HxZL5FF1bbVz/6XFk
	TJuX7TpqocjOzOE2+wV+He5BTECrbhjbxviVe+KsJUkbd/
X-Received: by 2002:a05:600c:c170:b0:48a:7aad:4425 with SMTP id 5b1f17b1804b1-48a9852e515mr48090795e9.3.1777733849035;
        Sat, 02 May 2026 07:57:29 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([213.122.39.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a81ed69fasm222039835e9.3.2026.05.02.07.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 May 2026 07:57:28 -0700 (PDT)
Date: Sat, 2 May 2026 15:57:19 +0100
From: Gregory Price <gourry@gourry.net>
To: Matthew Wilcox <willy@infradead.org>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	lsf-pc <lsf-pc@lists.linux-foundation.org>,
	Bharata B Rao <bharata@amd.com>, Donet Tom <donettom@linux.ibm.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>
Subject: Re: [LSF/MM/BPF BoF Session] Numa-Aware Placement for Page Cache
 Pages
Message-ID: <afYQz3YJdWB2R-1q@gourry-fedora-PF4VCD3F>
References: <h5ossmwe.ritesh.list@gmail.com>
 <afNV5wbhsFQJLzxi@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afNV5wbhsFQJLzxi@casper.infradead.org>
X-Stat-Signature: nj5xda1ofpso5iz8gmwwer3orn44tg65
X-Rspamd-Queue-Id: CD7D7180002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777733850-562834
X-HE-Meta: U2FsdGVkX1/yYIFlVUZchQaa/OQiVCeqhmaiUSLwgTjX5tXKqCKTYOluAXziZlr4pOToqHwn7BYW6941NmZ9h+ZEjttMzzlQ07lwFNTnfPngDNNLLtu4fIgRsV3o4MYMrERgbmQXcgmi5+zswITJ+pN+fOa51mr8PRqD7ADSk5qn6JauogZU2Tw40jE/90Lu91X6hxvrRYsGfoIFmyqN5RfBoA7aIicM8UKmvOlBuM22Usm8PPvXs1/ZcW/vxfQBvWdb4vBYPAT3mThN6v+srYHxI7o0f8DkyIS3RJ2lODmccfcyGxEOD+SI6w/uIzV/GnTlcm+9ULe1qmVhjloUEDLzT2kecffjaNjLLUT+0O3ZOjmRnZv7JNfWxPPtQuUDz3+uJbcy8Afk1/ohB6i9ujTFY3jTLN4JTetp/wdkEZoccAWvbQoCY7JwC0JIkiPHiTkd6CGIAXxutIoGX70TDJ9cofMpNKIi3FF2eomt9xhZO3BHcR5XTQEFhUwYZYVILCBPQXVgqbyzThJ7X4lMNIc8sraYub+/FA45N7s5+JAVey2ICAP9RSHffEjJ1pYfWA9sObqKq/kYIPmTs6PCgqA66EAzqb30dztFLkXiDmLbpCqCcWbJl6zUepZukTynoltb0r5EkITv1PLdYfWkDrH0H0KBZ9vTLX/hUdEF4i0OwDbj9/bkbpGLCD7jm+seA+/y+rwpjjgN2gNsYBBm6+ZO+CgTYr6uvyss2qtpEC8In3ud3/+gEP+9NLlAfSs9u9Okgj66TG4pczIa8Mj8nOgw19deaI9Xs3kUTvLkOteyBXdIC2ya6GwT/nImTrnOR7+xS6v1cCzyJRSKYDO5L73BLTTklp76pz5uFm2mnMBnRugm2UXyL2vzGOpMLV7YIp+6WZrWecpo3n0Do4ggOCuHezweAixZoxoO0H9QTwU6ocTVNT8Uw4PPj7TwXdnd3gnV/4mtfbfqYRCVc/C
 d6mBcYYf
 b7+NprrEl2Mi7lwct4MgD4fNKhr8mzRqY6FasL6z0d7MCxFYn6dsojYDRpfQU+AEFX4e4GlGnStqvNiEdz0+tiInFutEa5JfUWoI49aWMmZuhB0DQsg6OdOkfhB67hZxXXKB8ElpFmaOiTlpSZYKXVyaYBmBXl0QqwN/+c31QLnD3y1BwWzcBNEcCdj40YTi44bNrNJb9YkXGZpvxK8hRCH2VttTizKnDvmuj9PbO/xas38LnPYcM386PsW4KUald7XzF4VdVZfs2KsKwZ4d4uSTrX0Jh6bGeCDVpsBp1MQ40pCkf0FGhT9jH+l16CHwYsBTWyYxMdpStFnNcI8uLX0bUhS7rvJw2dOBj/cxnhcx00crV/pGp5qRM9b/kBjzwXMQendbaZrCVUuQPGQ6VGywiBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 30, 2026 at 02:15:19PM +0100, Matthew Wilcox wrote:
> On Thu, Apr 30, 2026 at 05:03:37PM +0530, Ritesh Harjani (IBM) wrote:
> > Linux already supports memory tiers and there are ongoing discussions around
> > promotion of unmapped page cache pages, which lets kernel do the right thing
> > for userspace page cache pages on a tiered system.
> 
> Well, you know my opinion of that idea ...
> 
> > So the question is:
> > Do we need a userspace interface for the placement policy of page cache pages on a per file basis?
> 
> What do we do if two tasks both "know" the right NUMA placement for the
> inode's data, and they disagree?
> 
> > 1. Is there a need for an interface that allows userspace to do per-fd page
> >    placement and maybe per-fd page migration?
> 
> Ideally, no, the kernel should observe the task and get it right.
> 

Out of curiosity, a use case i've been exploring is something like

fd = open()
buf = mmap(fd, ...)
mbind(buf, device_node)
/* fault file pages directly onto device memory */

this obviously breaks if there are concurrent accessors of said file
with read() (filemap will just fault onto the local node - clear race).

Do you think there's a world where we can hang a mempolicy off the
address_space via an fctrl() call with CAP_SYS_NICE?

I haven't quite worked through the full lifetime, since there's a
possibility the mempolicy ends up with stale nodes (hotplug, etc)
without plumbing for that.   But it did seem like a somewhat clean
abstraction that isn't specifically a tiering use case.

(not interested in this for anything other than single node placement
policy or tiering, so no interleave or migration support or anything)

~Gregory

