Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35E96D637A4
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 19:44:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F07A6B0088; Tue, 16 Dec 2025 14:44:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89D936B0089; Tue, 16 Dec 2025 14:44:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77F946B008A; Tue, 16 Dec 2025 14:44:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 646D36B0088
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:44:37 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 264E18B01B
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 19:44:37 +0000 (UTC)
X-FDA: 84226361394.01.F04C0D1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id BFE491A001E
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 19:44:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JPNpLkhX;
	spf=pass (imf19.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765914275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OWZMfsrJ1GHpp0Gacc8vZFboQMCus5dZjsnuyY0r3Lc=;
	b=t0KqKSJ6Kw9IwnnrvNNBmk0ZUNbEg8EhnfCzFumnWYLiHBqiUrabv+QEWKhSJ4pEo8eD6N
	AOk56SCZHYy/tMB9q+mZbDm+ReVZ0zMP/GKD2yJAB4VcS5aijNQe9w68/+bOUvKWYKIyPp
	yBXU+rTI9/5NE83NcaXdjQGmHhUibGg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JPNpLkhX;
	spf=pass (imf19.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765914275; a=rsa-sha256;
	cv=none;
	b=HnKfeREVsmbKLGZCxZ40TpHk/Fg5kDvyX6Fkal4JgPVV5HrfsDKk+XW1kfoPjyz5LdiDZ9
	aLLVCAe0BEon7ZnC78I8KXwpbo9gWPqe39J2SlOuQhX4jSCyAMQ7D6ayBfqLMrMlzSV6jE
	amcP/LXSMEpABqMw6YNJgqasno8OnLI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765914274;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OWZMfsrJ1GHpp0Gacc8vZFboQMCus5dZjsnuyY0r3Lc=;
	b=JPNpLkhXtjUEtBKfaJLQeq1psG/lEuZvzcJ0uMnCUTlcmNE0gHQe8AbDpONWbiYESdSZub
	F7zy4nLbmW4k9hHoddlymQa6OyXneQu6uz4ojKMcC3gP3xV84N3AdWNTJ1CMwMf/kmuJDF
	wZbSiRB9XDhv3Op6apQSqWGGigubSA4=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-bDH3i2E8OB-TbU4Jpf9xtw-1; Tue, 16 Dec 2025 14:44:32 -0500
X-MC-Unique: bDH3i2E8OB-TbU4Jpf9xtw-1
X-Mimecast-MFC-AGG-ID: bDH3i2E8OB-TbU4Jpf9xtw_1765914272
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4f1d7ac8339so148756071cf.2
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:44:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765914272; x=1766519072;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OWZMfsrJ1GHpp0Gacc8vZFboQMCus5dZjsnuyY0r3Lc=;
        b=pVMN5B8Oy4a6pq93eAjW9oZBHK3d2umXP7j8avTyVCQ17TKmy6h3CG4xhq41JLHaJO
         kwxwmIjbxyrMLomi9Z+3WD6hbccZq9UojLJ46gerWZjvfTweO4XJVDhIBzBoNUZs57s6
         VyoCnbVRpn0qqOjUg2Mw5N1HeFvAfVWZmSJ0Vgi+6W/C5We0I5bVfWuqVoKrlAgb06CV
         /qwRiiQEaraEzvrBwJGHPx0GNuaYTXFYQ7HnINmwzXsQ40F5IEut77UBwetDNnko3pt0
         vio1lPofpd2t3sCcXq5VOleVqFI5xKRv6+2BdYf6ZVeEiB95gX+YXuoMKKHV2ElXAXSw
         yKdw==
X-Forwarded-Encrypted: i=1; AJvYcCUJ0ApD9kUHacoTnWOioONcRVYejB7pKtbvYfHcqUalIFTtqdFPIdqkJJw4IvreLfAXvrh/kOMCpg==@kvack.org
X-Gm-Message-State: AOJu0YyG1mU81sT17CXmLYybFrT+iWeYsc264JwhGnjvgrhYb7r3qXfv
	9amWT9rDPWcRQCW9wr15BiVqYk5g8jGE1LDFlilMwgrwpPN8HM62HXg1jskh59Ye/YsVe/hrCkp
	6XH2ZOD/QfhUXAxGav1lLFFdGBK/zeQhElgU5dqfTqT1dwl3KfzFn
X-Gm-Gg: AY/fxX7AmbAiAS9bpw486E/2Co68mNILPiHg73lga7NKo4BU5M+fyTrkptS68QNt5rb
	V6sQY8rvhqNEQkQ/Af7ovf4tWuaYkqczcvFKu6s25kfd6fKwjD4AhgdQ7rV9qeirD3QY86Gg4St
	VOvkTWDPAqwXyu+iYGOlyb2tXGcZP8+xL2eqx755Q2OHGvx0ZEoW0i+IiBrlcYsrrqSCRlMgVmS
	q3fvTBgXUDDZ3Ba6O4t9FTppC6FmMePBXoIFpXY0S7HI/7hnFyvZkfqCR/BIPRAbJk3eQuZva1x
	ZElR0NuuajdXiK2LqeMNUPYTMxtBVTDmdClJFqZ7kAbecL6/xSTg6OHedUrtx5LmPGKgtzO6PSi
	+ldc=
X-Received: by 2002:a05:622a:5911:b0:4ed:b4ae:f5bb with SMTP id d75a77b69052e-4f1d05fda57mr230282301cf.65.1765914272125;
        Tue, 16 Dec 2025 11:44:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGrrpjRFCD1x1zKDvh6gBnxEwhK0Ukm+SrqYrMtn8W42xybAzgzISZS5MGyj4ryNBGs0WxcZA==
X-Received: by 2002:a05:622a:5911:b0:4ed:b4ae:f5bb with SMTP id d75a77b69052e-4f1d05fda57mr230281951cf.65.1765914271709;
        Tue, 16 Dec 2025 11:44:31 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f345902748sm23150411cf.0.2025.12.16.11.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 11:44:31 -0800 (PST)
Date: Tue, 16 Dec 2025 14:44:29 -0500
From: Peter Xu <peterx@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 2/4] mm: Add file_operations.get_mapping_order()
Message-ID: <aUG2ne_zMyR0eCLX@x1.local>
References: <20251204151003.171039-1-peterx@redhat.com>
 <20251204151003.171039-3-peterx@redhat.com>
 <aTWpjOhLOMOB2e74@nvidia.com>
 <aTnWphMGVwWl12FX@x1.local>
 <20251216144427.GF6079@nvidia.com>
 <aUF97-BQ8X45IDqE@x1.local>
 <20251216171944.GG6079@nvidia.com>
 <aUGYjfE7mlSUfL_3@x1.local>
 <20251216185850.GH6079@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20251216185850.GH6079@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4M9NgZcmJI7ZPK4SVoGl8dhKG65D8njSM9qdvJMUtc0_1765914272
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Stat-Signature: h6zfm59ohrzzywcz5z6niyas4id1yx1i
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BFE491A001E
X-HE-Tag: 1765914274-331847
X-HE-Meta: U2FsdGVkX1+k/ag/sMwY1JiRL9xqN9YWS8vbGoeBqOJjgOVXySOVv40b00dKMS1s9/gMBUD60wCksfH1Vmcp7fN2T2zLsaEQB+AGCgb7zDDc1gRbwE57EzjBgQTBvp0HuzfXHyjq0rI1NkZCAXvQbvb53VHGLVeMgBTdwGuYSuoa10g15AXwG5A6KxCP1ahbVvkQFA7OO4BOAk+KxPy1VgyVKnwFoBkJK4yi4bfXRiZ679WtnV/faVIZb4DKwhXAWBHP04SMeU0K58ssIYDb01vlakV0TQerr7eXpDNbq2pKVEEUS6qr6F2BqZa7ZRHk22O15RH0VzKp9TjKLDeh/uBqMTYjZPHPSjEPpJMk6E94fTNhNLuF3gH7sVXpMK9f2xVurRUEc8Ny8WRFsm+woz9exJtPdCC0838FkArEKsZF7Kin3gOuPFHa/tCDS78x/O7naZggumO/BuDWS52sQVZnX3iMecjKXbvyR+DZ+pME8WKLgFbNKOjhlAc6Oh0pLcTdFg/2p4svCdggK8bGbqGAw9FY3AuOYqjq6jagcD9JgCqrBeQJuyeaPb3wQCLlb0fYP8wDWTrR2Z9ygme947y+D89/gb5hz6W81jDE97f5Cd9IhOL0wKCXKYHuAVbyDpBj9jTD5NvHjlrnYbyC4J654a9O+Z/54i17WbK0FM/zJE4wRL0cOmRhj3iJK3HgVElxtLA2wN7SaAHayJsnm5KYBECAcSOfy1WZ5A7x54l0fQzGHnZIsc+yjlxewSLs39yQcO+9PcaY112Z4TmMP/I41y4FcE41Dbm3WguxVAZlp1NZA4oyv4DGTYw2x21MrtxoeyKZ1W1ttclY71SD9GGZFveU+C5bkTSrcNzneRxCliBbuvrjAgYopMveo83gf+9tFfgW9aEK3JaDn1AYgAAKRylpjOzof5x21UlnFrzJRHfobCVRNy9lX5eL6fBifV0n4I3gez27/F2H2kN
 R0g5G8MU
 xxa6j5rBeDop5p30QW9BPOBTDhFi9jQXvcXnWFcriadRhwC/xQJ9muaVP8+yWThmiOPQAKRDOhRn7uk6x8eyBp6A5hpRescUw3OxBHZJIWbttPA1XWlfY1TMOT8B+5YhivITRAkdIVI2VuC2NMBDbOYAr9owRFaZpnLMT32L6+Rgm3R/dtpKFhQhDYJrU/GLThcIUfGh8UIGmf2dwQvylm34UcL33GWJgvidGla4O780On8PbGzwate2/LyjhAnoxEHjVPLRyryNPUyqfKbqBth0GEzGkMblZ6OkIuQM7uZaP55XXQ9hWJNspsx1/FZePTRXs+J5Z0bnx3h8AchpOZrPIjTq5YP4VfcS3B+TYHQzdvtS/oyR+k12lxi4zV9egCo28orma2p9qzprXnPE4W5VV2AEMQl9Zu4WkAk8frb/v+5u0Tv7qaRIK213I9ZvpjO5kZ1Mz29XABM4gSIJRWpjFNvy0YYVNzl1H0sJFEtdpDZv/HNPfKPTcwraceteB5Ul1egGJW4dlDtxAsKZva5rNDedQc4k60HG9FvMWlBbj4Kg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 02:58:50PM -0400, Jason Gunthorpe wrote:
> On Tue, Dec 16, 2025 at 12:36:13PM -0500, Peter Xu wrote:
> > On Tue, Dec 16, 2025 at 01:19:44PM -0400, Jason Gunthorpe wrote:
> > > On Tue, Dec 16, 2025 at 10:42:39AM -0500, Peter Xu wrote:
> > > > Also see __thp_get_unmapped_area() processed such pgoff, it allocates VA
> > > > with len_pad (not len), and pad the retval at last.
> > > > 
> > > > Please let me know if it didn't work like it, then it might be a bug.
> > > 
> > > It should all be documented then in the kdoc for the new ops, in this
> > > kind of language that the resulting VA flows from pgoff
> > 
> > IMHO that's one of the major benefits of this API, so that there's no need
> > to mention impl details like this.
> 
> It needs to be clearly explained exactly how pgoff and the returned
> order are related because it impacts how the drivers need to manage
> their pgoff space.

Here "pgoff" plays two roles:

  (1) as a range, (pgoff, len) on top of the fd, decides which device blob
      to be mapped.  This is relevant to the driver, for sure..

  (2) as an offset, pgoff is relevant when we want to make sure mmap()
      request's VA will be aligned in a way so that we can maximize huge
      mappings.  This has, IMHO, nothing to do with the driver, and that's
      what I want to make the new API transparent of.

I agree drivers need to know pgoff for (1) in terms of get_mapping_order(),
not (2).

> 
> > Here the point is, the driver should only care about the size of mapping,
> > nothing else like how exactly the alignments will be calculated, and how
> > that interacts with pgoff.  The kernel mm manages that. It's done exactly
> > like what anon thp does already when len is pmd aligned.
> 
> The driver owns the pgoff number space, it has to care about how that
> relates to the PTEs.
> 
> > Or maybe I misunderstood what you're suggesting to document?  If so, please
> > let me know; some example would be greatly helpful.
> 
> Just document the 'VA % order = pgoff % order' equation in the kdoc
> for the new op.

When it's "related to PTEs", it's talking about (2) above, so that's really
what I want to avoid mentioning.

Docuemnt anything about VA is just confusing on its own especially when
"int get_mapping_order(fd, pgoff, len)" doesn't even have anything in param
or retval that is relevant to the virtual address space..

If you think missing such info is harder for reviews, I can definitely add
a rich comment when repost explaining how __thp_get_unmapped_area() works
here.

We can also pause this a bit and wait for Matthew's review on the API,
where he showed concerns.  If there's major reason this API is rejected, we
don't need to bother this part of detail either.

Thanks,

-- 
Peter Xu


