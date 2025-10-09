Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC936CCA471
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 06:14:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DEAB8E0048; Thu,  9 Oct 2025 02:14:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 969CA8E0002; Thu,  9 Oct 2025 02:14:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 807E08E0048; Thu,  9 Oct 2025 02:14:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 518C78E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 02:14:28 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 179D14641C
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 06:14:28 +0000 (UTC)
X-FDA: 83977561416.09.60DBE4C
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1AE06120004
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 06:14:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=WO1SAnAd;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759990466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tY+RxY77Pgjb4Q3Ych7maYZ2J/C8zV6CQKxbmiyQ6H8=;
	b=0XxrEch87No9me0CemF2okb314sPv7pw/WIVhYt4o6obObKqXNjKHqBeEDV+lI6Cvj9XyH
	78O/JXF5KazWp172ZGJ6m/LCwVs0SsSGzskARogxju7lDxEBnUbfhL7v58nHorcqrU5vPR
	oeMv1ZHFI7h4yxtLk+uGu7WS58/7TBc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759990466; a=rsa-sha256;
	cv=none;
	b=yviPNWIBRoHGzP2JTmCEa/NfyCna04FCsezlDCzkstn7XqNjP+RBT8LQqQ8GxM1CWVMOoy
	f5br8zaZaErSXJ2mUvxNZDW9FW6XmnE41XgIACtdyq6xBUO9kNmcl1Vx55kx1+QVqUuurV
	T1YippuuFQUHH+0qPCO9CJUDFOj8MTQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=WO1SAnAd;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-62fb48315ddso841523a12.2
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 23:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1759990464; x=1760595264; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tY+RxY77Pgjb4Q3Ych7maYZ2J/C8zV6CQKxbmiyQ6H8=;
        b=WO1SAnAdKkOXTnBnz+pFLAuy2wBKZV539YRPGC/xywo60ofSYJQvtGKn1eYSCwatVg
         Y9HjoUDp0SneEX4ygKlSl+2s8Gq9tyah8HOQWlxK7IYeJC9kZwYIKsTwQ/aiwgcyPAeb
         zxVeK+WOr1yfHpQKea8HHPddeG6n41Ef0JTqctvTDNAePdTt7G68co8UrxlgMC/pdL1B
         3CaKpdT79oHiiX0zgvf6F2LkKwOMMcSoCRbfW8EwoiJkmGVEtwQs6I71FpkZczafq3gV
         w7sDF3yX6pD4h7tXKPyf4NvZWHb2ZJCGaI8UgkfP5e6Q9g7Y1S8UyGWYcuBmy0vw9fdK
         S5xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759990464; x=1760595264;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tY+RxY77Pgjb4Q3Ych7maYZ2J/C8zV6CQKxbmiyQ6H8=;
        b=pR/U4GZ4BtcMukMh4+1Tjyc0NH1iEYrnah9kdjdKvuwlOGhFAu+jq8QxmHs3au003f
         C3dwmaQ69yeQW8zdvYlkzZoYAY0hL9w9WuQjFy98WQLfmy7OiscRjGyGA21L51Wk3lJw
         k5DGfA4PidmVpAnemWDLdDDqv8y8u+UZCECydGejm/88FtCxlh3QnYr1LulBUcbMaR6y
         e3FeIGqxwyNgj76pCpLro29XW8bfoTfoU5oT595Jl0PBsw+DObNz1G9Ywh7/ItCxx+iA
         NphHJTjRJceb8uWl9OsCMDaCR2dyfbzxh+XWNGQQWc+7BEjw/YAEOWgOAc1yXMbUN904
         QFkQ==
X-Forwarded-Encrypted: i=1; AJvYcCWPWpV1vNFWpLjOFty+zt84bOLJOyyM4xEiAupzYtYKUjOrXKr/nkOIARyKDRKPpqyu6D48Kkk/kg==@kvack.org
X-Gm-Message-State: AOJu0Yxyni3uIjFa8RmAU91VbtxUBrS44Ba1aPzHIPg3DHfxkf0yfn8m
	lSDCZTZq/ZVAKnDi2m1tRwVt4Hu0AdSm7ce/ewQObGPc5896Kplh7F9s0vrVmuh+Sgc=
X-Gm-Gg: ASbGncvsnGZEGVdFCrYO3joy2Jo7qqlkp3BYqIPhNLsg235bA2isb4aYC726xduy8JM
	/F70xD9Ye+FvJAizUMXUIktdbTBPHFmSsaHn3+KB+WLzKYKWn3dqra5RR0ojQGExj0I3KNBpmL0
	gFXY4ICYyWFfpnfBanM+Pr7dGLTNIQyIlcR8iwwOBywp4BkVGoiNPpqdWTAN36WgoC3+Jixl0HE
	C/wclB8qJYwQJkEc/4l4X30YjcxSEYTbf554JE0mTqw4TUcnIUZQZ4BFNSvDWCpfPH1UkIs9qJJ
	HULxcBNhqyRdld2wGti07jdXmrZqkkDnzn+dPXh7GaHCaEVWRmLwo2UwXMUBMIuywU05ZTn0AbV
	xT9eivX6t11Z2wKEWukt3nVUjHOT3j4OdRjFLTnOgBDbX0XDK/6+EALgEBty6tKnlfyYuIAw=
X-Google-Smtp-Source: AGHT+IHag+XyI9AEKljQkUUbITbyiNy7sILEJRnoopPBDpFTzbe1XSGFErdxTP4ZeoFPTMso1aYmeQ==
X-Received: by 2002:a17:906:c146:b0:b3c:f48:ed57 with SMTP id a640c23a62f3a-b50aba9f7b9mr602408966b.35.1759990464254;
        Wed, 08 Oct 2025 23:14:24 -0700 (PDT)
Received: from localhost (109-81-95-234.rct.o2.cz. [109.81.95.234])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b486970b5acsm1816673066b.60.2025.10.08.23.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 23:14:23 -0700 (PDT)
Date: Thu, 9 Oct 2025 08:14:22 +0200
From: Michal Hocko <mhocko@suse.com>
To: Gregory Price <gourry@gourry.net>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
	corbet@lwn.net, muchun.song@linux.dev, osalvador@suse.de,
	akpm@linux-foundation.org, hannes@cmpxchg.org, laoar.shao@gmail.com,
	brauner@kernel.org, mclapinski@google.com, joel.granados@kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	Mel Gorman <mgorman@suse.de>,
	Alexandru Moise <00moses.alexander00@gmail.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] Revert "mm, hugetlb: remove hugepages_treat_as_movable
 sysctl"
Message-ID: <aOdSvriKRoCR5IUs@tiehlicka>
References: <20251007214412.3832340-1-gourry@gourry.net>
 <402170e6-c49f-4d28-a010-eb253fc2f923@redhat.com>
 <aOZ8PPWMchRN_t5-@tiehlicka>
 <271f9af4-695c-4aa5-9249-2d21ad3db76e@redhat.com>
 <aOaCAG6e5a7BDUxK@tiehlicka>
 <83e33641-8c42-4341-8e6e-5c75d00f93b9@redhat.com>
 <aOaR2gXBX_bOpG61@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aOaR2gXBX_bOpG61@gourry-fedora-PF4VCD3F>
X-Rspamd-Server: rspam05
X-Stat-Signature: cfqfc9rq163oq8fetauecxo8mbs4rwmf
X-Rspam-User: 
X-Rspamd-Queue-Id: 1AE06120004
X-HE-Tag: 1759990465-741555
X-HE-Meta: U2FsdGVkX19W0+8SL+F5PLCBwkE0iWrsN/lrsFE1ebVl0nLCpp2lgNh2CDAs24IB1mLUw/bQyc4xieXQC7Q1c39mxfD3N8ztLyfZYaPd5eteuxRLxWc6XT8sFvtTjG1fdeloQgZbi/TeYIMB1JgFcil9z5L1+ZIRDs1ZZT5NVEWrnBvUpzvvMjJbFvsG9AgDIz0DqO3iO4p+Zp/E4tbRksmuOtnBOYclos5oK3aJFeFGE6YWm83C0NUo8u6+EenPF+C9IsamnsCQeQhR6Le0QtHCebg3qo5No0hJRr84v2qAgfPrO4BdoGsEIoiVQYT7EThg+g0OLh2T+XZGKWeW1n0lpUdoVDl42wuMyuLGUKAuKRGVJuSaxhdkuha77X2mK1/lgegpPEq7pa37ars0Li29tptFX3CAREWzW91OhDwJPhJE02JuSMGgyP+jxlKxVnarWrXMFz/Ma48hftnS+ERtIlNxyDYN0GX+tISuDVjf9r12Kpiss14LmJUXWu7X2VaJoRDwvRn8JBE0hZqmwW6pXAEs7SnOmGbdOMdSwFy+jhLgmYRJerEV16Vz8kPfAKiWVQkeEM10AcDUKR2npuKANXvXyuv60+/V5A5U4AqAvo23VJq5e3ASoVZkObLiH6OsCQ/1HPI7LGejQcFHvISTEaEM5j/n2Lsaib5XZLV6qPQd3mMs4vita2t7jXE0wON/4ufnwp0a93/mvGX2yVbJqTAqVRyx42vBWleF5EvHEXc6JTku96a5N6B8NvFxN9NMUm5eOvvmeHY+DVrikuAuKKGo8CzZhWah1CL9o4nosnfJ22d44GYcEARPtNiNPX0j3M1VLV+SY+A/7xqTa7bDs0DcZ/hJFM9/XGVRo7O9xJJWwI6g8fwKYv925+eCXqEV8KwEgX5ivJDDPVmPs3Du5HLY2xjp2VXtxGbKSjtXuTY9uDe161sG14NEsgmsj6xcxAkdRmUc0Gws3NL
 +eUn9C5r
 1yw91jIDR47ov3TjIVQDEcoGePBgzm23hfFbTBYyQbXLh8lzJ+SKMJ0C6YoG3eOIq6SVIOiynp8GQ7BxQTVVdnjwhi/VlhMPdOq9A8/Fo2tAXs4OsA63LYiE6dc3aN/T+ZENdAVbD06tr+2qE9FVx32VvMHRO7zAMs05soRUOqURTMxg0j2+ANd2qjhpWKdP37THGZk6TiCCjAcophiP657y+XQ0XgzcWDMntmc5DFiTdCVk4c1g7I1D7e3pJliMXg8Cg4ZJr5rAM2a+UkM8bHAjsf/M5BMAWB44xyiSvaU7FpSq//NXKU+qqUnVfEcXkWoCco4x5MAOYPeBL6wH5RQqSv2aNj0KRUyam0uL5ihLL9fBNLRnms3JvL6cniH5vaPhjpStZ/lnYdzqgRGw29UB27UGeLyxIausCGmV7/wTiozAxGPv8nev6dw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 08-10-25 12:31:22, Gregory Price wrote:
> On Wed, Oct 08, 2025 at 05:43:23PM +0200, David Hildenbrand wrote:
> > On 08.10.25 17:23, Michal Hocko wrote:
> > > On Wed 08-10-25 17:14:26, David Hildenbrand wrote:
> > > > On 08.10.25 16:59, Michal Hocko wrote:
> > > > > yes, I do agree. This is just muddying the semantic of the zone.
> > > > > 
> > > > > Maybe what we really want is to have a configurable zone rather than a
> > > > > very specific consumer of it instead. What do I mean by that? We clearly
> > > > > have physically (DMA, DMA32) and usability (NORMAL, MOVABLE) constrained
> > > > > zones. So rather than having a MOVABLE zone we can have a single zone
> > > > > $FOO_NAME zone with configurable attributes - like allocation
> > > > > constrains (kernel, user, movable, etc). Now that we can overlap zones
> > > > > this should allow for quite a lot flexibility. Implementation wise this
> > > > > would require some tricks as we have 2 zone types for potentially 3
> > > > > different major usecases (kernel allocations, userspace reserved ranges
> > > > > without movability and movable allocations). I haven't thought this
> > > > > through completely and mostly throwing this as an idea (maybe won't
> > > > > work). Does that make sense?
> > > >
> 
> I'd also considered something between NORMAL and MOVABLE, something like
> ZONE_NOKERNEL or ZONE_USER. But that seemed excessive.
> 
> > > That is why I called it user allocations because those are supposed to
> > > be configured for userspace consumation and planned for that use. So you
> > > would get pretty much a guarantee that no kernel allocations will fall
> > > there.
> > 
> > What could end up on it that would not already end up on ZONE_MOVABLE? I
> > guess long-term pinned pages, secretmem, guest_memfd, gigantic pages.
> > 
> > Anything else?
> > 
> > I'm not quite clear yet on the use case, though. If all the user allocations
> > end up fragmenting the memory, there is also not a lot of benefit to be had
> > from that zone long term.
> >
> 
> The only real use case i've seen is exactly: 
>  - Don't want random GFP_KERNEL to land there
>  - Might want it to be pinnable
> 
> I think that covers what you've described above.
> 
> But adding an entire zone felt a bit heavy handed.  Allowing gigantic in
> movable seemed less - immediately - offensive.

The question is whether we need a full zone for that or we can control
those allocation constrains on per memory block bases to override
otherwise default. So it wouldn't be MOVABLE but rather something like
USER zone.
-- 
Michal Hocko
SUSE Labs

