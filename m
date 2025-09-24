Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE4DFCAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 12:01:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3405D8E0022; Wed, 24 Sep 2025 08:01:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 317E58E0001; Wed, 24 Sep 2025 08:01:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 254E28E0022; Wed, 24 Sep 2025 08:01:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 148748E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:01:26 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C313EC046A
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:01:25 +0000 (UTC)
X-FDA: 83924003730.16.53AA0A3
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf04.hostedemail.com (Postfix) with ESMTP id 989644001D
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:01:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=NKsh3MTd;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758715283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5MMKd4v/xcqOt5cNKf7ReIa3kzuv8h8tdplQ8zOdNAA=;
	b=pYN5qtij0L1VtSNl1ofh01iijsDfJdRLyqfBZIRCOqNeGi4hnPOhwCMVzrW0S0uK9HEswT
	efTgljuMN8l052g42Uu/15aK2WpEqds1hAI4/svvhjfhx6YWyRU+P7wsYhFrERnQHSRqVm
	F6cPWwUuLOyzZfTa40i/aCedHjo7rl0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=NKsh3MTd;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758715283; a=rsa-sha256;
	cv=none;
	b=QOjijRtWBedNA2/DfWxmjzgUN/vlKB7ZGW5/wVcTJP9ixR6UxhlX6ytE/Tgioo5fooRbMV
	Ol8f/+alCr1uSa1AxWd78kN9+eYXuuVk/3SC0tF1xQ5tGjte9vKBPeYEonX+De0P6lEh6t
	UJJCe0ULc0UA0AFWaccomPrJ8CfSJbQ=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-afcb7ae31caso1168139966b.3
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758715282; x=1759320082; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5MMKd4v/xcqOt5cNKf7ReIa3kzuv8h8tdplQ8zOdNAA=;
        b=NKsh3MTdDeldzAq3DaZoEx/ZLEa5kIxgVloAWps7NHLEm5huoekGV2himAKo/gacdG
         6kXmKB1mGNRaf5cOBfteaItS2qOGaPlCnQW3A4utBIjG7gDFj2B/Z0XRU3tIw9py7pwJ
         mG0BmAl+ztDI7v4G3RxE+n9zl5EHSN33SE+GZ6CJYzeNn3GtXZnH3J3jFcOxGj8qbZp0
         yEG8bwoI00ImCQ8VC90n4JrrMOWU3a5A0/NPjHvZ2si1e2Rux9uXPoc/ITTC35Dc+lVr
         mLORk9/2tNZNi9eU4Fh+Lkx2OLUassY7cq8+SREbiIvoIkgDXRvDYKrh18pptOs2JRsG
         6Q7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758715282; x=1759320082;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5MMKd4v/xcqOt5cNKf7ReIa3kzuv8h8tdplQ8zOdNAA=;
        b=qF0Q3NZHzYKoeWgHYWDci0VA8YD5g5K3T7SvBYsY8y5fi+S0aRQJQLhG9Jsvm/0de3
         KbW/Kclyd/2CvDgjYy/Gy+boVVjDX8hVWtQNPX4r9h9/dIEitHmt+ikHeCEgv5eM52tl
         +7VcA6xT5wlaH/ey1XNtvuOVil4C52N74Ze8uD/79GtNv8mrPoORRavt8nOrHsbxcU40
         os90VIFv+u6K0oKuT3ejBI7TQqYtos17FVLssBBhGB5r5YA9sHz6oPQxQJRlKclF30kX
         XW0NIOTHlkJ8ID3Hv1UAFQ5twP1duGRZOQFdUwgUO3Z8nvMa9ADAlCQ1FAPrbEuII5LN
         DkLw==
X-Forwarded-Encrypted: i=1; AJvYcCWssPu5G/rWcTh9nOy5fnRNmVrVTSjU01J8xzL+fW4lC9T2XBvAqjA5nH5ZMrPuX6DVnGY11zoIIQ==@kvack.org
X-Gm-Message-State: AOJu0YwvvPNbSfXI+xmm/1wc2fsxtxzEii/kmEufpX5AYO7TnY2vGHJZ
	2IaISGnvxiIkOmxKi1yGy6ZFPFcZjcFHAzmliACWIb1x2kxINQTiXoWkhBn356kzz4w=
X-Gm-Gg: ASbGnctlvmWQSzx49XuGiJCE9c1k+JtvJ4w0HMNoJvCtdNowO+kTxclyXIMTzd07Njj
	RQ/f6QLXJW8Kur3/hHhi4nK5rxk9/W6HF063rzHTGB9K9J8YutmAcj7mI4XOlNynDUWFP/Vx5Q8
	ScXgpn5R+vHTOM/5ah9kwb5BtHQvAy6qwSGnX/yN+X2Z08H75WjsQJ37SlJ73W/pIAxVQ+N9VGj
	T+63u5y2JFt1jJM3XU4y01RODNIWRIkiUCYkByQaQOK63F2D2jZQ84w93KTDR4AdoqVIFiubBFO
	pM5T8o7hWI0OGQI79nY/zQsNKJJEO3pOC0WhdcFHyl5NiMWuMdfUgsv+tAwNBvu1rh5il+wvmCx
	QigKGrOyXGTO6tcSJoIVUcFU11gnbOYcC2Q==
X-Google-Smtp-Source: AGHT+IHI3zZtg04smL2TEl7T7QHKy9ayyKqzWjWI5hwHw+uwg0pC946eDLyxRu9IRUMCSbNf5jrOyA==
X-Received: by 2002:a17:907:7206:b0:b29:1c4b:3d50 with SMTP id a640c23a62f3a-b302c107c19mr530054666b.64.1758715281880;
        Wed, 24 Sep 2025 05:01:21 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b2ba267f745sm745653866b.33.2025.09.24.05.01.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 05:01:21 -0700 (PDT)
Date: Wed, 24 Sep 2025 14:01:20 +0200
From: Michal Hocko <mhocko@suse.com>
To: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>, Anshuman Khandual <anshuman.khandual@arm.com>,
	Dev Jain <dev.jain@arm.com>, Wei Yang <richard.weiyang@gmail.com>,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	jackmanb@google.com, hannes@cmpxchg.org, linux-mm@kvack.org,
	Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH] mm/page_alloc: fix alignment for
 alloc_contig_pages_noprof()
Message-ID: <aNPdkABVUvJESoqm@tiehlicka>
References: <20250923001943.2479-1-richard.weiyang@gmail.com>
 <3BF1389C-4B8E-4F50-AB0B-F0D96833D387@nvidia.com>
 <5491dfda-862a-4c31-b64f-5339007a5302@arm.com>
 <09284390-5a1a-47e0-9929-0a5ba98c836e@redhat.com>
 <760C8EBD-9201-4680-8B9B-CAD7641A81C4@nvidia.com>
 <aNPW4Ynrxyn23Ko8@tiehlicka>
 <81a827ce-24f7-4038-bca7-c96dc558cb38@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81a827ce-24f7-4038-bca7-c96dc558cb38@redhat.com>
X-Rspamd-Queue-Id: 989644001D
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 7ddeg4nuy48zcaazmua5bf79t4zc5eka
X-HE-Tag: 1758715283-873306
X-HE-Meta: U2FsdGVkX19i84svNlJbrl+3bPRs6GAgRMcIYpViuQaRyL9KlYqtFMtt5lS9hcxVY55/Z2IGS08tm2JoOS0IglC6iVncSmvc+zP8coQ2BnDB8yaBFCj+hUW6E1HK7MJbd6b6pMBTn3pxG6m75Puqmn9BGQZyzSmtA/GOOzkpiSkJyY1wvcaeNluruzA0U5uc92MPomgqtXKVjxWD9LVrnY677tynuPdlrOyCx4ivfgR3t8xV4h6I0sbUDZMxj19aFdem9RHIb7RVVpj/0koT+50nWg1KTg58rlJe5llO5UMPwOHxOtRCrBKAvru+4D+S5l8Dmm1XBXQ9GgB+mfG1ZvoD50iniQdjx9TDWdMzoXXrrzSVxhlG2oACkOQh3bIBFjpP3XcJUCReWn8zidvOWrxSUU2tl66/jMeYIPXiy/q2QhK9dD+DHRFC/DRPHZiDTmP+Q96zxHqhc1pfgm1EslLgOC/4MoLmRE3uSwM6mIqOrf/fnxsTW8lqHdMQ59ujcajP+FXz0GufMlgxEPrGBpKgS2rjfXcvlnDduJJgawJtpEtFgT2i0H5RQ7dCyFrZV28tSVKGIF7Zb/qtnfDex02dCFpxN2un38stXSYC32GCsd0wyOXcf9Nndpz7fOFak3jauW0smJJAw4pYM86giieyjPpkWH0kiUecmCM+m35Xx1qLWpeUE+egwTGI0iXJQN9MYbXX1SVhwULXh0CxboSPycrjD2EU6w4zSzY0vyEtD/QF87vtZ8IEAE2WppWfWzwInzScF7+8hNr1ee8RDpx0EFSCrgDrZ2CqBeopDFv+eIGoRNbwS7mw23iM4qwyWFXRv0hi3JvijptpyaHXDWZMBEF0klZ1xS+ermyZ972+Y/2behAS48CaHIVsC607lqO9VcoNdowYlEXU3oK5AKH1/DCfDJKKfm5+/FLghnuQUyfzB5e/v/RpIgUI019zO5NIdpVCLh8Xc1KVeo0
 FLuzOTn7
 3jbZT+ucygOV5nNQMTqrJmfk+x3kpsKCnnG3v6W80fIfv43R/Jv/LwhNLvs3CkAjXWgd9YW4E3vYdeyleNXsNRML08P2DkHXq14s6VdGbuOQ4HL2C3q9bq7exWoh5qiBQ26CpOD1gszko4X1j37L1Mmj3phxHxT5ygDLGgsLhmK3TO5z7JwXjyw4iJ7kfMPuv6qCabaGBmECBayX1fuUPu6WK1xvZYnRqb2il2Bg091LF3EzbTn5t7cmD+l/aEBZEyfKmW9xk7nWp0Q3c5SUNX5oMljcqJ/nd42GDiabJieGEdVB6p/HCTSTnuAGGtpJE/dvrznFfSnFRArFJ5GankPjwpbK5q7HfbkHvWqgiRDNNGvd86Qd0SicxNRnMNp9tOkzpg8h/vCmf55Vr5yj98GfjZHYa2Ousq7+msF76fVDzeKpfeTFSyW2EEQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 24-09-25 13:40:58, David Hildenbrand wrote:
> On 24.09.25 13:32, Michal Hocko wrote:
> > On Tue 23-09-25 11:07:28, Zi Yan wrote:
> > > On 23 Sep 2025, at 3:48, David Hildenbrand wrote:
> > > 
> > > > On 23.09.25 09:06, Anshuman Khandual wrote:
> > > > > On 23/09/25 7:16 AM, Zi Yan wrote:
> > > > > > On 22 Sep 2025, at 20:19, Wei Yang wrote:
> > > > > > 
> > > > > > > Commit 5e27a2df03b8 ("mm/page_alloc: add alloc_contig_pages()")
> > > > > > > introduced generic method for alloc_contig_pages(). But the alignment
> > > > > > > calculation seems wrong.
> > > > > > > 
> > > > > > > Since ALIGN() only accept power of two value, while nr_pages could be
> > > > > > > any positive one, the result is not defined.
> > > > > > 
> > > > > > The result would not be any value lower than zone->zone_start_pfn,
> > > > > > so the worst case is getting an unaligned PFN range. I guess
> > > > > > most of the time nr_pages would be power of 2.
> > > > > 
> > > > > Agreed.
> > > > > 
> > > > > Also as Dev had pointed out earlier, this function gives no
> > > > > guarantee on alignment of non-power-of-2 requests. Hence I
> > > > > don't have a strong opinion either way, but does it really
> > > > > qualify for a "Fixes:" tag ?
> > > > 
> > > > I'd say if there is nothing to fix, then this patch is not required.
> > > > 
> > > > What likely does make sense would be that a non-power-of-2 would be aligned to the smallest contained power of 2.
> > > > 
> > > > E.g., a 6 MiB request would be aligned to 2 MiB instead of multiples of 6 MiB.
> > > > 
> > > > Not sure what the existing ALIGN would do with that ...
> > > 
> > > Something like the code below:
> > > 
> > > pfn = ALIGN(zone->zone_start_pfn, rounddown_pow_of_two(nr_pages));
> > 
> > Please let's not try to fix a non-existent problem here. If there is no
> > alignement requirement then make sure we document it and drop the
> > existing ALIGN which doesn't seem to serve any actual purpose rather
> > than make the code more subtle and more obscure for no known reason.
> 
> I think we need at least one initial align because the zone_start_pfn might
> not be aligned to the desired order/nr_pages.

I thought we have concluded that there is no user expecting a specific
alignment. Or have I misunderstood that?
-- 
Michal Hocko
SUSE Labs

