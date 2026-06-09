Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83233CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 21:44:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 728656B00CC; Tue,  9 Jun 2026 17:44:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B2A46B00CD; Tue,  9 Jun 2026 17:44:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 553046B00CE; Tue,  9 Jun 2026 17:44:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 411D96B00CC
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 17:44:37 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EAB58164EAE
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 21:44:36 +0000 (UTC)
X-FDA: 84861703752.21.8101392
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf02.hostedemail.com (Postfix) with ESMTP id 055B980008
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 21:44:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DGzOyuCh;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781041475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aD/5zoYJey3JVZwJskUEOWQGpMW2wHY02NSSmxoYtHs=;
	b=BMA2oj3Gi6n9g4ubtY7UPQnISLx3wFFMEEVAaHEELGAo7PgITN81jWBZYos793brtB91Tv
	a5oRLYIpNgx/c/yp6ZsenAvNcOEF6wSdq47YTQNIrR4PJowNzTjcjvsF+qWr6k2fNzlcK/
	r6wDOyrE79s/yTHSCv/T7QMNO0xllz4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DGzOyuCh;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781041475;
	b=464tE/8Rz6MjmJUSz2hGs9GGxniELPhOrLOxlp/vmtdeg2NrnBaEIu4Skv1hcLjPiuZFZs
	5H3S/trrTHD5ou5vExP27R+wEkOKLzDcFND+hRkj/mqkTj9Ib9n3fkgob1gTirgAYu/jm6
	u+VGkzh5KqpJS6nyAHOLDIDzgqu7lf8=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-91563382bcfso696808285a.0
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 14:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781041474; x=1781646274; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aD/5zoYJey3JVZwJskUEOWQGpMW2wHY02NSSmxoYtHs=;
        b=DGzOyuChzyWEQBTx4IYokjjPjdtSkuZj5JSQ2CzqUiFELvfOuCE/Gthu45fGdHv3nC
         3v7URTNTO9CNTSAWsQB/61aYw13PHNkepAEHDJCUvdHms9qsbxVUHtGM0+d+rp/hJMJN
         Va6DlLpjGn8+mfdOwiI2ff91YFI6eELkgBhSYTmPRUJg3CfdE7tbRW/LU2d6RyU2gZ2U
         448oNveaSWq9+1s1EKXqiWvKx8Bhf/Je33wMbrKM6U/9nKv3HmyMwTbHiE1eQdalbfnL
         yg3Uf9aNp7hnLYqjgr4tnF2AcJsQfiyPerFL8cp4MPqOWPC8LycK1K+9pbo0rY9VUlXF
         wzMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781041474; x=1781646274;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aD/5zoYJey3JVZwJskUEOWQGpMW2wHY02NSSmxoYtHs=;
        b=l7hPQu7ALdjRxf+Zf8M6oudgCtuwiOMa8EVZ8VXFvrXF5EJH3b+ZEkmjD7fyc1/f9D
         83uTlbvWkf2ulJ/uDXpz+WbEUbvfGohny7dzPWu/GPftIJkoCVsYDygfBhx0SRK/60oa
         Wxh4wCnYLDm3zp+AMB2Y5K81h8QI2sQ64z1kE2T8OdbkIUrAQP32v65EVZH5dOvYEsGf
         mSGAsGprviNX6MPaTmXExGjz37dlmH5uZzjR4ebjrc8DLbMLFZrR/SNJNEf3uE6hsw7N
         I2dkV3OSIw+CTyr990limYjIzD0EKz8hYtheownoC9iR/O5DuBBrit20nUBudmRkpyn1
         Goow==
X-Forwarded-Encrypted: i=1; AFNElJ+SOtcLKeejv5lh/OcUA9+1sp2cXwXx3uALoZsA6/qjXW9TBuIJDjwUhOStoN0+MfC+ETQ+UNXmLg==@kvack.org
X-Gm-Message-State: AOJu0YxzIyYnHujOrXCH1JJEWugW6RO3Mw5xsY0rs5HWkLf9X7B6PAF1
	ERrIp51+YGcEqczZc102muhTZJ+aIbfm8ERUHQ08xKqadro3+KpaMw4evTWyJ6uoy+g=
X-Gm-Gg: Acq92OHL3SFgYMEHXmkh+MSurqcG9weG+8R5ajH7MaSCxtYlhlPBRUlzm6wE37xP+VQ
	1Fvl/4y14Kq9w1Wmo8rbzSfde4hAFz3pzHgkrKctbn/FQi0PwSDbUvi93T6CIp5peTVDY3NqF+g
	3YJweT5NaXryoczID6DwMs0ZHz+PAnAeuDVQzy/Kzxy/PYKYshMMfyX5V0gUuDsVF8/Qsa3n/tl
	TWnUERnz5iljXs/tVVwWoSU48RT5U3M2zEdaA+dSgiN1GEWZWyaEVkxeL4rIL8uIxD/bE2Q4ieN
	lTm7/kVgQBvYIRA7N3Cy+paQJW58wLiL2wq04Bpm6dS80zhIAlS8/WyiaZdG5oPG6VJczuzEJxX
	58bbgTgR7fyszhorFNUekJHEqgYEI9jjV8hrSlgVnirVfAGZmHn8yaWxiP3NwDtP+ebfKTpb3Jl
	2VDIXEj1lD5VYFDn3o9Qq013IiB41sZAIlxoGPBlPZo2oFJqDDEB6halDqIGiRjWjUT5KLl2bA9
	9U5SLI7ui5pacvBVjFApln6rK+D
X-Received: by 2002:a05:620a:880e:b0:915:cda5:27ff with SMTP id af79cd13be357-915cda52bcdmr1869020485a.45.1781041474035;
        Tue, 09 Jun 2026 14:44:34 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a381abfsm2275058085a.27.2026.06.09.14.44.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 14:44:33 -0700 (PDT)
Date: Tue, 9 Jun 2026 17:44:31 -0400
From: Gregory Price <gourry@gourry.net>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Alexander Duyck <alexander.h.duyck@linux.intel.com>
Subject: Re: [PATCH splitout] mm: page_reporting: allow driver to set batch
 capacity
Message-ID: <aiiJPwhn6gF3ILur@gourry-fedora-PF4VCD3F>
References: <b25ea6c63503f24c8b5b64910a44dc03b5aa610d.1781020302.git.mst@redhat.com>
 <aihRBTaTUmgYmZfX@gourry-fedora-PF4VCD3F>
 <20260609160506-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260609160506-mutt-send-email-mst@kernel.org>
X-Rspamd-Queue-Id: 055B980008
X-Stat-Signature: ykeu6qax93tou4fhdd66owm9mt63rt7o
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781041474-853
X-HE-Meta: U2FsdGVkX1+0zYk0YID1lMkWnEKxW2St3Oz2sVh/2J4wnvWjGhSzlCa6cgLCU+z85aVvtU0N8I482bY+pV38o0vY9mmKTediNqqzkJxqoqURRxlaqIry/ARzWuMbpbcrp63vJHvQLC00hqUKWbC02uK+aMQIYkloY5yLubA9zeeVdHpOuwO5P/M6ks6MqY/WaeNtOLQPpHFeLplLKhbyXBHAIy08cJulUGVRWj5yLjIxNDpnQP9x0tNpQbaUXSOJJx93z8lsaOY7JzEBODP4TfxSC2yTeUdDapPE0jjY2P/COgdUkUKawC4U/c6GJgaJu7w1xNUmJ51wtopZXm5YIVS0uJIbuOIHaxdfJ8L9W5Sg9UYdh04BXWjDEXxjnw4toYxqfxq/T01MucJ0IiJq9Sj2khD8TMQW1cgtR38pIWc0uQFGoLheKktNOZawaDjikQ40V06Ewa1qRkFYkYfH+UYL/5aRbWakn7iS7s31xK5pa2cx2lX/T6s0D4XLplbVzL3vQfFLaQM/BWdO+KnRI9e1jSLjpp87Yq7pI1nyN0/xVY5jQRhEpZVI7vMUsmPcYLPg3XnBy2dAikt4+FMfFfW0AOdTcrWcqyCx44+w3zq5SmnZ2v465OwH1cyR/3FEPMb9Xw7tjwtrMpzszEGNS5G/X3Jb2vnCW7oTM1XJevsxisSwr3qWl6PatYCxMKzG2MMOwYEboXKWSPCEdp4XR765PEJdUeGQhjJvV1NqWiziFFXd8e4ULu/4SGbv9kx++5mThAjbpVRIuYKePTqx/LXbU1LDXirtLJ8m54Qaptt3BTr/PPYeMn0RU9dF4bljOQNWQ0sjNIqCt2unA0QU1PGhy2QgGraxiB9ZYRPjvhmZBXkC9sHFuqJqLmdqCgUI0mhsCSqfWX+sY725crvL/5BeFlvpzl7yZTTB9HDmixxDz8OQ8sixgZBzucvdFJ+sVJHazATzf7vrPQg9meC
 7j4oANSB
 3dwNeVVllYM7OT2y5KPpOSoVmTyhIyOSlBRSSJuO1el2VCZGMZCbwInTRnDu9GLomzhuGeRsXCBRMHEYLdI3yZWpgkOtjY4FwaLiSc17v0IitjWXkj3A65Gz+b6R3NOlEdJAA7xoPcAbcTrSta4o/dg5eVyxBk8BjqWDdH10AquCwcwT8FkiHwrVWbHIz2sV17I9vo386fB2hHpRAcoZimm2NQa7f47cQl3NiPrwBbiAIM0YjKMk0ZvC3xRlWdf2qvZB+cmEEIeTMHK6Mj17wxiurovWqAZQUsJaNbzIUdkrE3JeOiX1wPlGq6i3t+KCqsVyCH4V4t9R+HLJV4Yb0b5GGlIIFpL3QZWjzM3Xt+LCGGE1itJoD7B94uHOb7qpOrxIWkCSrTWxdQR0karlk+VuT7MZ9BN2YkLsOdNIAImhE8f/6/8Gr78bpXoHtguUB6KtJNF7ZFCtWuiU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 04:08:08PM -0400, Michael S. Tsirkin wrote:
> On Tue, Jun 09, 2026 at 01:44:37PM -0400, Gregory Price wrote:
> > On Tue, Jun 09, 2026 at 11:53:20AM -0400, Michael S. Tsirkin wrote:
> > > --- a/mm/page_reporting.c
> > > +++ b/mm/page_reporting.c
> > > @@ -174,10 +174,10 @@ page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
> > >  	 * list processed. This should result in us reporting all pages on
> > >  	 * an idle system in about 30 seconds.
> > >  	 *
> > > -	 * The division here should be cheap since PAGE_REPORTING_CAPACITY
> > > -	 * should always be a power of 2.
> > > +	 * The division here uses integer division; capacity need
> > > +	 * not be a power of 2.
> > >  	 */
> > > -	budget = DIV_ROUND_UP(area->nr_free, PAGE_REPORTING_CAPACITY * 16);
> > > +	budget = DIV_ROUND_UP(area->nr_free, prdev->capacity * 16);
> > > 
> > 
> > Initial look - is there a div-by-0 here?  I noticed the old check
> > prevents this from being (0 * 16), but i don't see (on first pass)
> > the same check anywhere.
> > 
> > Unless this line below always forces the above to be a
> > PAGE_REPORTING_CAPCAITY if it's set to 0.
> 
> It does, does it not?
> 
> > > +	if (!prdev->capacity || prdev->capacity > PAGE_REPORTING_CAPACITY)
> > > +		prdev->capacity = PAGE_REPORTING_CAPACITY;
> > > +
> > 
> > It's worth making this corner condition a little more obvious.
> > 
> > The code intends for 
> > 
> > if (capacity == 0)
> >   capacity = PAGE_REPORTING_CAPACITY
> > 
> > but that's not reflected in the changelog as a default value.
> > 
> > When happens if a driver sets (capacity=0) either on purpose (???)
> 
> what would the purpose be? if you don't want reporting do not register.
> 
> > or
> > because there's a bug (???)
> 
> exactly ??? since where are we practicing defensive programming in kernel
> APIs?
>
> > and then page_reporting.c forces it up to
> > 32?
> > 
> > There's something to improve here.
> > 
> > ~Gregory
> 
> 
> So I'll update the commit log to mention PAGE_REPORTING_CAPACITY.
> And maybe a comment near capacity field?
> Should be enough?

I suppose the question is whether capacity=0 should cause a WARN (i.e.
only a bug explains that value), or if capacity=0 means something
special (i.e. use the default) and therefore that should be documented.

I don't know which of these is the case, but if it's the latter than
that deserves a comment yes.

~Gregory

