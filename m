Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B3EBCAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 16:31:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2C2F8E0029; Wed,  8 Oct 2025 12:31:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDC758E0002; Wed,  8 Oct 2025 12:31:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCB6D8E0029; Wed,  8 Oct 2025 12:31:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A6BF68E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 12:31:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 27A1D45FD0
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 16:31:34 +0000 (UTC)
X-FDA: 83975487708.11.50D170B
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3A0901C001D
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 16:31:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=QD4YkTaK;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.48 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759941092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ftJpOb1xcFQZv0a+i4an7Jz1/tLAQUsdU9C49sUWsFQ=;
	b=571tbFD1yG8eJWBwmUXFKOkfUQZfaHpo6Y6xWD+P57j23ZfnZhNi/Tv0mRP3SGpv1Pf6jx
	05bMCbuH7L67WLHPBQcRbCaV3rHy+deawQ6iP12El0qV2ovTdqpuJVqTFLEWtYxJLlWWEE
	Wa2iVov2lptaPD9IokSufJTLrQRjCK8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=QD4YkTaK;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.48 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759941092; a=rsa-sha256;
	cv=none;
	b=emfoYhzk84rZ145zXO8Ak2LNQxRO2skTQgw27WtNo6bkmSz92IyuJ3NszQWFz3hJKP2ZJa
	qbpx7NnzRazKX5ANV9u4w2B2YIEsipypKhcNIt33/RyuKbyJhoTjwL9SajFKTzUcRdD+5L
	IIfSdTMK9i8jrBpPfX9VdHxImH2TW8A=
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-80ff41475cdso932696d6.2
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 09:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1759941091; x=1760545891; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ftJpOb1xcFQZv0a+i4an7Jz1/tLAQUsdU9C49sUWsFQ=;
        b=QD4YkTaKzm+o7OJT6padmw2VgQFldz32PFnYDD3a6eRVoyrD9bdlVU1lGw6D1Yrhz7
         wigXU23b20t/lNTbAaH6xf9XhwzOykwihtIVLEYv/9QBv54N6s+RERF2tmtlfliC3i0x
         5T+MsLsdO66jp9ZM58JnPgMquCE7MjwvPc0ZNO3BuoGmABMdUE3gegSPgZDkfpvKizbl
         3bK8qji0eTe+rmGdM8Omk4DwmJbK5Hek45T6HRFWn99xZaOmU1QbrAu/70zzva4UEnMb
         0iCicAGL02Cu9RvjAxoEvp5zOWLGMnyKU42BhMcIJ4w8pJcXZ8wJ8TbRNifp3O45pyZ+
         p3ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759941091; x=1760545891;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ftJpOb1xcFQZv0a+i4an7Jz1/tLAQUsdU9C49sUWsFQ=;
        b=SA7bxcAlZYh8CHmUMuoyGll6xVWwqH0T+mT6o1BcE3S/LzsWVvEBaiSgd0yDk8V002
         5jGU5lGrPAFnZgMTpvergve0Tu4vi7pdo87dtyZQzSH2hU/FAUUbmUcNoCRagjsqz4Ec
         aGGjTsdgEEs73R2n8J8tvMvVIw3+jFR4BY6jrKZYtc3ZSOws9mDPEY0stjJ5B94mFEPc
         EgSd+PK5wwLFdGIaToy0n4n5PYMIRPB+aS8rUeiqFKpNfUkzXTWR25/DxbEAjdKRIg3h
         CMpscTQL/kv4Fff7jX9I43FIZITU9BNjC5KWnCxbDBt3ai0N2y2QZLihxsd4/CPIKuRd
         mLoQ==
X-Forwarded-Encrypted: i=1; AJvYcCULiroiL6DXMmHINUjAbaaY3wK/upUOt1nP8DJs6rQtfO8EFwQXbcXMZpE1ll+Vf60xM4+TwNRGXA==@kvack.org
X-Gm-Message-State: AOJu0YwZk4/atGBgKC0s/4e3gVw0l58Aok6ZHI3X9lmlhnswJRffbp8q
	pBXJItwcMkAEBiDeRhDlvXPZccJb5X/NV+F2e97KYoukWn9U3F9o/qN4aseCdcV5BCc=
X-Gm-Gg: ASbGncv34vgSMtGjbZCOCDL/DlMOdtab2CAPBL56pcWdWwrme8pOkukXLEMgtvaCSgi
	mCo3jNAyMAag/j7yUIDfO7GDnMslh6q/NSdyKG1bOuUwFmnINzm4hpuUe+cpr79GS0MIoPPL2Sy
	/e20I9lIPZeti1QR7ZhOdlPyLztIgbIQD7biRb88FIE1oFLivV0ASc9SemI6tnfnSmEz0SQEyT9
	n9rTFTFRdnsD6q1xjFMy/G3nL9kZfken5uT1vtyJvltGOCqkAFpxaTK90Yj9QqeA5d0CyJWWjXB
	c5rMt0Izly+SvIdEHe9Vxs9bG8ha/QhRbdTTmzkbmCS7gOKIvyMJNzsOiqi/XR/xHc8DXFNbUbE
	dlJvtIgEGGjc+rWqxPEFfi/GN4QLcebr2ZWWUiIq5L1aAitzJDI/YVV8R5veKRONiYGLU1RA7+p
	9jlJtrfSwDLZk5H0pjfMvwHgKs/+aLOVYAk0qTyZVYLyP+5Gk0IJc=
X-Google-Smtp-Source: AGHT+IH3li9YLOy2HwLU9l6NJx1hAvZugBHxS1HCl35MSzFjO8cle36MgAd2/H/V1sd72ii7wdm6jg==
X-Received: by 2002:ad4:4ea6:0:b0:73f:a7c8:980b with SMTP id 6a1803df08f44-87b21001056mr61864846d6.4.1759941084963;
        Wed, 08 Oct 2025 09:31:24 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-878bb446e8esm164513976d6.18.2025.10.08.09.31.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 09:31:24 -0700 (PDT)
Date: Wed, 8 Oct 2025 12:31:22 -0400
From: Gregory Price <gourry@gourry.net>
To: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, corbet@lwn.net,
	muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org,
	hannes@cmpxchg.org, laoar.shao@gmail.com, brauner@kernel.org,
	mclapinski@google.com, joel.granados@kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	Mel Gorman <mgorman@suse.de>,
	Alexandru Moise <00moses.alexander00@gmail.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] Revert "mm, hugetlb: remove hugepages_treat_as_movable
 sysctl"
Message-ID: <aOaR2gXBX_bOpG61@gourry-fedora-PF4VCD3F>
References: <20251007214412.3832340-1-gourry@gourry.net>
 <402170e6-c49f-4d28-a010-eb253fc2f923@redhat.com>
 <aOZ8PPWMchRN_t5-@tiehlicka>
 <271f9af4-695c-4aa5-9249-2d21ad3db76e@redhat.com>
 <aOaCAG6e5a7BDUxK@tiehlicka>
 <83e33641-8c42-4341-8e6e-5c75d00f93b9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83e33641-8c42-4341-8e6e-5c75d00f93b9@redhat.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3A0901C001D
X-Stat-Signature: o5ke9mr1sb5o53nh1ioau9jrfiyci9yu
X-Rspam-User: 
X-HE-Tag: 1759941092-483647
X-HE-Meta: U2FsdGVkX19ggKUppPduPDK6A7ssRxpEEX8aBynI8T3gEp40d8Jw+gN6cN51rBDekOQIweZGnA+P7IeMM7KwZKVK5Upu5rmuiUVKOw8K5reUV0esYwTnI06LLlZhwCWQHSJIGP+owZty2F1R8wLFtTKfOErI9ch/slne4yRKnO4n3WtkFfPrFvdUQ7DwchfUYA310PGGxN6XGGgU3mOJJLMs412wOKhYUVYpHVmsRxgtQzVxmq5oWOHIOJsP/kHnDzc+IvC5inTPWBVtoDULqF5FWdU/Aya01sHJi37xxzTqlMdEd9CgNAe71UEilecg5ZxVYSv/1Awj3egM4iJVDGXGUNDM7T3AqN/RcUQh5up2/rp7YN5oY0ea3BIpNooNYJC822DNHFH0faGl24WAwCLW1sGGTjycq05Ei4MPqjlp+amVvJbaMjHuGuH6fCuYBH2Y7ibT72K02X0eDKnK3ldE4shibgxJDvy6uelboB6EiNFlEFll7Nc/7JGgKjylhxn7+Xdd2vhWcUvXG/IfoSFD6o1h/shFmNMMOoHtQS2SQn5kil2hCTb9D935EjzdsHZKpU14kSgZybD6J2TFMMC2/v3vSwueY2Yh5+YfQqWaftQYT9/Hf8j7Sjhnk+v92yQ7060bvkAcAxhvLlXa+XMbUZCbRfsFQ4Rdt7Jg9bxaUhkbsdEAfdj8oLMZO5CxxsiYcdg+wN5Rq7em0A1Mwr5bLw5gH7lsf8fLF39fGJHYfPRDMPTIgWUH3ze3/KdSeL0ggu0Dz4bBCWjzFAXkLkPucwRIuX/NSDVsCtNb9J1E25UX6byEQc9bXjFLP73hJljM2FxkyPsarJ3qQcmq/fmSfT9qp6ezBtiIxOkt+e0zAs94silcojqAbuQjJP5rqqboZ08BzpBpEojchN5VoYOeq9N+GFDmwZT4EgXV26RPMqVojTi6icrkDJuI+4feY6nLOjq2fZR2AuyC5Gy
 ILY6gE6L
 LqL7FNBF97EMO0tP4iJmqEyIWNlBVhS3Bth0aZTw6leaEtNOaS9b89LxzjEP/jVPx2uJH4oP7U7uFqCsdDDBix54kxkM+18eHVjv40YjVu0mO84ssT4LCjy+hoJWM3zoi8qTg9GC/egJ/h4Evigr6Zbrd799GbinItvheW9cfBoLnLLdDSnfKa9spjhzbKbXW0sZ9sieLCynx0+e9haTHn2SMHTHyJi8NQz8Y5iOvubE9lAQg7oPkDjzZTiojIwJcDLtLJb8OP0zysftmgHupQNnXT52FMuQDP/RHRy5KIkieC1tlVnaF3IXJqYNPVmKVNu3bA3aafP8b+xJm0dBwUWW9uBZVomKdN6aI4SSiBaFzEDOb6vtASk0iGAtqg/n0rbW9zcSq9R5FSIkZ7vb2Q7FkNHNOmZSnSH+lJFsClJHUUYgaY8+OWuiC7MQaoxH9GAgj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 08, 2025 at 05:43:23PM +0200, David Hildenbrand wrote:
> On 08.10.25 17:23, Michal Hocko wrote:
> > On Wed 08-10-25 17:14:26, David Hildenbrand wrote:
> > > On 08.10.25 16:59, Michal Hocko wrote:
> > > > yes, I do agree. This is just muddying the semantic of the zone.
> > > > 
> > > > Maybe what we really want is to have a configurable zone rather than a
> > > > very specific consumer of it instead. What do I mean by that? We clearly
> > > > have physically (DMA, DMA32) and usability (NORMAL, MOVABLE) constrained
> > > > zones. So rather than having a MOVABLE zone we can have a single zone
> > > > $FOO_NAME zone with configurable attributes - like allocation
> > > > constrains (kernel, user, movable, etc). Now that we can overlap zones
> > > > this should allow for quite a lot flexibility. Implementation wise this
> > > > would require some tricks as we have 2 zone types for potentially 3
> > > > different major usecases (kernel allocations, userspace reserved ranges
> > > > without movability and movable allocations). I haven't thought this
> > > > through completely and mostly throwing this as an idea (maybe won't
> > > > work). Does that make sense?
> > >

I'd also considered something between NORMAL and MOVABLE, something like
ZONE_NOKERNEL or ZONE_USER. But that seemed excessive.

> > That is why I called it user allocations because those are supposed to
> > be configured for userspace consumation and planned for that use. So you
> > would get pretty much a guarantee that no kernel allocations will fall
> > there.
> 
> What could end up on it that would not already end up on ZONE_MOVABLE? I
> guess long-term pinned pages, secretmem, guest_memfd, gigantic pages.
> 
> Anything else?
> 
> I'm not quite clear yet on the use case, though. If all the user allocations
> end up fragmenting the memory, there is also not a lot of benefit to be had
> from that zone long term.
>

The only real use case i've seen is exactly: 
 - Don't want random GFP_KERNEL to land there
 - Might want it to be pinnable

I think that covers what you've described above.

But adding an entire zone felt a bit heavy handed.  Allowing gigantic in
movable seemed less - immediately - offensive.

~Gregory

