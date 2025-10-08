Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25620CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 15:23:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5678D8E002B; Wed,  8 Oct 2025 11:23:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53F7C8E0002; Wed,  8 Oct 2025 11:23:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 454BC8E002B; Wed,  8 Oct 2025 11:23:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 348688E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 11:23:50 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0679713B66D
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:23:50 +0000 (UTC)
X-FDA: 83975317020.07.760006B
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id C933140014
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:23:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=DqRiEOvz;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf01.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759937028; a=rsa-sha256;
	cv=none;
	b=oadPwYbC7GrRh45Yceo/6QkKp66/uOp9fSwJXg0+IHswbU//q3+tLWbGYsobH574wYO1TW
	mHRIfBxaftC6dNMDFVgGufrtZhhyGskSjeB+ooW+8KXPm/maqIaNlLaFMH4Rp5z3WwN3iw
	q9JKx8oE8Vea0xgcvpcDXcoUd8ZSMW0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=DqRiEOvz;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf01.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759937028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VEFKGIEcuas2Pari3eoGaAS3BufIbyvqNDimCw+KvpQ=;
	b=Kk66Ur7XeHr0vl1DNII6uZHfS76Fb34+pPBgTY8sQiV/wzYoJjRp14Mu7ft0Dl8cAtG0ZE
	13OrjpWjKZGt6iUUGtvh/lzizevsGP8znfdtWNhTh/VYvTNlCtQPbU5EYS/DJZljSkY+75
	PbhDwfhsmDmnUrC+3gbX0J26oKdnva0=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-afcb78ead12so1375959966b.1
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 08:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1759937026; x=1760541826; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VEFKGIEcuas2Pari3eoGaAS3BufIbyvqNDimCw+KvpQ=;
        b=DqRiEOvzVOhLHbPeGWNqB+PRvcOsNZ9KeOP+ssryMs3eubJHboQXsRL2I0W8IPzYJK
         zUc7iJcaemslQ3GC8+dqOLpo964qzUATr+ljkUL9KGJ2Ilg+pO5LOFitPhqj/35zrAif
         +B45jfWcYLQBzFHft2MJVxBI/b0IBajDDvleqT1jpqFnc1tA7ZWRlVPexUJTVi/wr6cg
         F+y6FhdJNFsVYZKP12r7uiGksN3he4pvQvM3d1C7fK6eWkk35uerze1vhZQaAxYOXQgY
         WtA1G374RayZ2KQbcXumIZmUhtq/Umay9QmdB9uJucNW2OHqGKNljz5hiWB9cRo64jR2
         LW2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759937026; x=1760541826;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VEFKGIEcuas2Pari3eoGaAS3BufIbyvqNDimCw+KvpQ=;
        b=kPji4bHksnu/+g8CUOujbS/PEiX2AXKyfQMLa+kLZQBIgG2KS+V6Hc4quvW+SkrgJm
         otH0LjZ4BYJjKF+thshsVTFHZM24vCs/R1W2j7DFV+nh04EOUP2yiW/Pmwa4jSjNJsPa
         bbI9t8H6cnOwoKbh75ewMs8pEbzxVwchEkoI0xQUC/UuDs7oGhJCHCCYT+G/e0zORAfa
         ZgxNiF8hNGVbRQjjCIy4M2u+ap36jmEDzpoJjTPsOue/qfHhMy/qMuQodBSMzFKTJ4H2
         YM73W8wkItIRLz53kJ9nLkTwp0gD3BNHpWUrDLPqpqPx0nkUv1ZmrYO858sFR8OCOgyu
         n8UQ==
X-Forwarded-Encrypted: i=1; AJvYcCX8JQBAcswm+02Pjg2W78iI/13e88qWB1A/gyKKmwM4pyOzxhwa1FW7/qMPf9G53qPUOYFi0ITfTw==@kvack.org
X-Gm-Message-State: AOJu0YwZyl6doh5aiwp5cFgQ1xDWAbfc7FH19EB5Knx6YmsMhYwF6Znu
	Dz2ILWk07JjxsnpLxs3mpLeROH8JMyPkhQ+pJ9jhenXnQTLhBNS8LUPN8HVKmGThkKs=
X-Gm-Gg: ASbGncsBUGXyOxHZp7prESWlXy8T7Rs/l2Y0U4mwZvk2LfvAvyQ3/ZNLcRjnds/yi8k
	Jp3ypJnM3DDRJX4kUag0dzuIPtOBacU6n66SfDoJ5+QuptKJ8OKpS4tcS24QqD5b3Prdot0TeKW
	2bYOIE1LkIWho3UZ/F+B+33ZDlDqGo+ZB/VJgaRiHW7rmffzVEEdFJ4+r6piuqnZ9pI5Xv5kP01
	9eFul7FLj354aZ2LMuNkOmkTl3xUM6KdcUxInOuePcEYgRURHd2jq5SHoVyBKs0HHVUro23rfBb
	4uqbgTPMK66iLUkvdSl8qQvC3iP7bTr0TQDHEFcRT6w+WhwfWW6veW65ElAZBhIOLqTMsk2fz36
	ywumogwy/3Hn0zMc8v9Den6n8FNiubjt5fnjbl/A+Fuz3jBj6qf/zoGyLlW+o
X-Google-Smtp-Source: AGHT+IGNuMGqHdw+uNNDnAnIMkPJmLsC8kdVFIi2VETZkBtQkqYRsFlkZfBi/u6TL2LUyonVmTrK0w==
X-Received: by 2002:a17:907:c14:b0:b45:8370:eef6 with SMTP id a640c23a62f3a-b50aaa9d0f5mr485367066b.19.1759937026160;
        Wed, 08 Oct 2025 08:23:46 -0700 (PDT)
Received: from localhost (109-81-95-234.rct.o2.cz. [109.81.95.234])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b486970b2ffsm1711555666b.47.2025.10.08.08.23.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 08:23:45 -0700 (PDT)
Date: Wed, 8 Oct 2025 17:23:44 +0200
From: Michal Hocko <mhocko@suse.com>
To: David Hildenbrand <david@redhat.com>
Cc: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org, corbet@lwn.net,
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
Message-ID: <aOaCAG6e5a7BDUxK@tiehlicka>
References: <20251007214412.3832340-1-gourry@gourry.net>
 <402170e6-c49f-4d28-a010-eb253fc2f923@redhat.com>
 <aOZ8PPWMchRN_t5-@tiehlicka>
 <271f9af4-695c-4aa5-9249-2d21ad3db76e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <271f9af4-695c-4aa5-9249-2d21ad3db76e@redhat.com>
X-Stat-Signature: 4erqrahwqdb8u8iia9jnxbawxbjgh7ew
X-Rspamd-Queue-Id: C933140014
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1759937027-866591
X-HE-Meta: U2FsdGVkX1+r23GTOBx9QiyYuIs07//gQ1UdcCGVBzIRbRFMtCcIrZZwqU+puNAIrf/LVtxqrNTl3xnvJ9GiCjXkkWXf8xwXB3SKHPpcH45gFf6WZPe8pjNIs/ASnxyX2ijtbRpOaUKkkFbkTC6DHNwevqHeliu4DLQBV5OixZhNowjkrdhrYON/e4nR/FeaA8yTyKY7a6+D9u8aC7l3Px4yo9FlugJeWrPxeVQSNeQg1OJQBi0Y91SR/IHRdivLfreJ27Y0udVaRR+PFwOjU50nHUHj5qY5SfdGjcTMbRnDsyjcvPbMUBchg5dlCwvokg15Gr4TjDSchRbYKOT/sL/Gi4c/1qrx8giP9yXWBocWALaw4uOQO6SyUQ41qgqoKCkOct35JbN2SJk3dh3siqBYfos4YGf6ldK486niPk6CrDMqSBp7AzAhGHaPwutfX8xPhffMuUpCZOQZl5HCzLohF57UKhUCl+AnUTG+sObIWvqxCFmD9vA+URY3p0oRj8scK1z5T7HJ5Phi+G+wBVMb0OhNhv59rmVkH4DiweYRNQVxlvI8tW+6HxJ7JjRsexPk5ktk01W+uWB16uh+O/UmD4EpL4HHKA9x2ehwGCjLz7QHeQZ5fQdWHiLbKKH3Ak77Lcy/mc7JEWYWof8J8Cnvd8X93nDqe0O6D8UtwIlRMjHkzTbzDwEimbzEi5pkuikxHlzS3h2L4CmVRx2R/71l1ZOG7RqLqr5bltvhVb/J3tqJ3wyucC6VsV4JV9wGVaF60gI5tLiYYOa5JIsSFOzxE7MKvRopdClJVuXRKQKaxHFLhomW3JaHzkRSFhw5eooQ5ixvnRAIwIeqaksJpvwSFVkP1fUp89yCZwzFtufVLUrpIYc/93b1QDl98bEo56xfN21dL08qgGIp1Ez6NBGlLxV8wWVsMeZmVPauBOT64kRqHHrUgKvxi1pgZzWkkGQoM5Gm9CpkOjIKdho
 6sma5gRg
 DK8tX1Cwsx0cIsDO78S9AywJPS3q0/nczBDEVYTJLBn++ir2WSCLWjv6neQGTFwUTaCdZga8RN+Gc+UHP2dzoMFZ0j6J4E0UkwEmEk7lwcOXhg0N7Gp7R8atF0uJFFdYWGl8sJf0e+l6OvMjucYsgKKrogSBcifmKdvJ/GVF7+L8REzCFugaiUf8y6N115dCAriZT6dHcMBxPoIRPff+K6hJ4/cQVxRC6kdnyxrhFNbaZRPnbK6M5Xu6NZaqt4sMZGdkQFsqJ/jilGqbpmdERsXQvQps3g7Z1whfdPar6DXk9C+w4kiypR7LkOdXl1AjxRSPq12s3jcjgcemDvn6oeDIlxGGs0ie8Hj46oEhIPAmcKvyTlKb2TNWAj63wpk/bJGJUQUYBpNiToVihFSS/1n9IqEHUMpD8qgQ2kS4vsOb0EEYSdC5z0RUtPw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 08-10-25 17:14:26, David Hildenbrand wrote:
> On 08.10.25 16:59, Michal Hocko wrote:
> > On Wed 08-10-25 10:58:23, David Hildenbrand wrote:
> > > On 07.10.25 23:44, Gregory Price wrote:
> > [...]
> > > > @@ -926,7 +927,8 @@ static inline gfp_t htlb_alloc_mask(struct hstate *h)
> > > >    {
> > > >    	gfp_t gfp = __GFP_COMP | __GFP_NOWARN;
> > > > -	gfp |= hugepage_movable_supported(h) ? GFP_HIGHUSER_MOVABLE : GFP_HIGHUSER;
> > > > +	gfp |= (hugepage_movable_supported(h) || hugepages_treat_as_movable) ?
> > > > +	       GFP_HIGHUSER_MOVABLE : GFP_HIGHUSER;
> > > 
> > > I mean, this is as ugly as it gets.
> > > 
> > > Can't we just let that old approach RIP where it belongs? :)
> > > 
> > > If something unmovable, it does not belong on ZONE_MOVABLE, as simple as that.
> > 
> > yes, I do agree. This is just muddying the semantic of the zone.
> > 
> > Maybe what we really want is to have a configurable zone rather than a
> > very specific consumer of it instead. What do I mean by that? We clearly
> > have physically (DMA, DMA32) and usability (NORMAL, MOVABLE) constrained
> > zones. So rather than having a MOVABLE zone we can have a single zone
> > $FOO_NAME zone with configurable attributes - like allocation
> > constrains (kernel, user, movable, etc). Now that we can overlap zones
> > this should allow for quite a lot flexibility. Implementation wise this
> > would require some tricks as we have 2 zone types for potentially 3
> > different major usecases (kernel allocations, userspace reserved ranges
> > without movability and movable allocations). I haven't thought this
> > through completely and mostly throwing this as an idea (maybe won't
> > work). Does that make sense?
> 
> I suggested something called PREFER_MOVABLE in the past, that would prefer
> movable allocations but nothing would stop unmovable allocations to end up
> on it. But only as a last resort or when explicitly requested (e.g.,
> gigantic pages).
> 
> Maybe that's similar to what you have in mind?

Slightly different because what I was thinking about was more towards
guarantee/predictability. Last resort is quite hard to plan around. It
might be a peak memory pressure to eat up portion of a memory block and
then fragmenting it to prevent other use planned for that memroy block.
That is why I called it user allocations because those are supposed to
be configured for userspace consumation and planned for that use. So you
would get pretty much a guarantee that no kernel allocations will fall
there.

-- 
Michal Hocko
SUSE Labs

