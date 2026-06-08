Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96848CD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 21:53:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C305C6B0088; Mon,  8 Jun 2026 17:53:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C082C6B008A; Mon,  8 Jun 2026 17:53:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1D546B008C; Mon,  8 Jun 2026 17:53:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A1DCC6B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 17:53:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 56CF08D25B
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:53:47 +0000 (UTC)
X-FDA: 84858098094.11.BD30CD9
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf10.hostedemail.com (Postfix) with ESMTP id 73F80C0008
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:53:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=R51fy9Bb;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780955625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xqf56sX2NNRInjSI0xIcWKifhIm+jUCIOxbaCaOEv34=;
	b=A5PKqqCGDHpFMB/tHZ1b0OncpvuTXmsYno2CqpLjetxQY3ph+N0LwE+CUcWdK2QWdV5hUo
	J7afA/+mJUye2y1Cue2n8xOeAkqi1MZoekUHKzqzOHwh96vBRf/eQXtnsp3TATsfULgA9s
	+OWGEZ+zFNsqIWqjdjkbm8s3HaiZSFQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780955625;
	b=a/2Lj9K+KYPNUj1A9NrbAghGfFmIesm0KPO8mLXAmZr7cm5mZjJP19Tl8nOp1ealo4uptf
	7F/DNO98i3C9DcYRw6qsYM9KV2EnYGt2fvkJuKp9AMtOhFDBhrwWrcq17GTozWoNDb9L6Y
	xsuuYcvklsvqIhOwrCv9+X2VcNYkd3M=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=R51fy9Bb;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8ce9de10985so57812676d6.0
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 14:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780955624; x=1781560424; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xqf56sX2NNRInjSI0xIcWKifhIm+jUCIOxbaCaOEv34=;
        b=R51fy9BbLiHOEwhsfmXMLk0witAQ0nmJ/UhDTQhT2wC/nG2z/W8t8rd+jNjA6FR6fj
         o1BAOvzW0dNYqMunKYnDAQ0YEjhFVasR2lCB8PEwE/AziWML7sDEy6/xXwzyYTKBVceQ
         BxXwcT6oobCv7+N2NDkJCMXrIMdafnuefDHlp9qs5n/R/5D3eXlyldHRWLJ3XUtryODy
         Liwk+RvIa3TwwiajOl24gUa9/gjFfS9s1LziTbOMtvif7PZYy91HGNFtf8hMT3gajjfD
         uyBtsVa0uPW9fD+x98ii4sx32w7K7XSJWOKctOVdplZ/4G9+2ZrfjaGs6Y2tr6rawjku
         VHjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780955624; x=1781560424;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xqf56sX2NNRInjSI0xIcWKifhIm+jUCIOxbaCaOEv34=;
        b=APet9SGZJx644hyi6f1jyTIHos6Fwya5hqXNEGXnaEWywxJQx36AwfQyxVwl/4ydtK
         PFF9z0p8JvexVXcD6JxSeIVSvQnKA4YwmL++UEQt+C5iu2pa9+9ggbIABUPfi4Ae1IEF
         3bv2LARmuTyySTlu/1cxJcWRCdLRz6F4E9c1ZHAiWn13FhYhGyl+Y7u0+l8/macIWXlq
         vxc4XqcNbcy9O+cbI8KKeyh9D0owzctqu4pIf+QobBqmuceFxo4zb6/MpZyC3Lq0m0SX
         zYxU8zFjbNdTQNubWV4A5k73VJoMdS6oVCvcYCQgDb1PetM4lN9swxtOYh7QrQJJrCFJ
         rjzw==
X-Forwarded-Encrypted: i=1; AFNElJ8vnh+lK8nZjMQNxcQgYPRxuG0UqpSOqVpbk5aAnTwMa6Kq/+IrXMiEX7IFVmjKf8ZQVOJEbkNN8g==@kvack.org
X-Gm-Message-State: AOJu0YxmlzQg/10Vu8P1G/rhbxNmAszw4nr9PQWZC17q8xfbszODabVM
	jRLbGCw5RD5FwJTGMeZDTPV6ebT4R2hYhPoOvKFjnTctQbGnM411FyA9Y9nipPpEacA=
X-Gm-Gg: Acq92OFM3WztwXK3z1MQg6QcLMwSMdlFpE9JsrbUd6Q6KyiqJYsdNCYsqR9cN+cEkvJ
	k4n8yQt6GgvZKuChoDPPbRLYOJ68OmDQ9E5fMIolPuiuBjdBAItZgOjAYNlJMQekrSV7hE50H55
	LJ7o+aYTJO6WG+Ajz3Hl8u5+Q6LSzreniLGKmxpQVU5AIAOM8an8tmzIMqt5KgAPnN/3kJPin+K
	He/n+LYUYJmy4aSg+f5sM8DHlfootN69xfriwVKp2B3XdJ3MXhCNDcPbQP9Dojz5Dvpn1BAV+u/
	dwn/6vyNUJ/AmRvguSMgwkUdnFh+YmFK331G/6k7pnKrOasomGS/ZUpuX21EzTwCanRXZ5vG4ub
	zeJ7NYkBPEZbgq6Uak3EyDg3kOr8VvZvfbCSCsjBzpjwRlHfUhmWWUdxUH6VJ4t/JuTGcyJwmX6
	yYcIoBIjWW/Twsbug7xxHm+3xtTmIEzJdK3Xug412JeX680aWxeHyvSFyUZnidK6hnW2mAR0+Ae
	GvXJa5HM6XdhFubPQ==
X-Received: by 2002:a05:6214:1242:b0:8ca:256b:8751 with SMTP id 6a1803df08f44-8cee8b1db55mr210068126d6.1.1780955624660;
        Mon, 08 Jun 2026 14:53:44 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ceccd9fe25sm183503066d6.3.2026.06.08.14.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 14:53:44 -0700 (PDT)
Date: Mon, 8 Jun 2026 17:53:42 -0400
From: Gregory Price <gourry@gourry.net>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v10 12/37] mm: use folio_zero_user for user pages in
 post_alloc_hook
Message-ID: <aic55lsQQ4Hegw7-@gourry-fedora-PF4VCD3F>
References: <f92f6f06e5804b4ea7f68b8664b7e69953b50f4e.1780906288.git.mst@redhat.com>
 <aiacZ6_7SG3nvVjM@lucifer>
 <aiblhJv_BvMn_8XY@gourry-fedora-PF4VCD3F>
 <20260608154354-mutt-send-email-mst@kernel.org>
 <aicjNRrHYOOBt0Hx@gourry-fedora-PF4VCD3F>
 <20260608161810-mutt-send-email-mst@kernel.org>
 <aicruns_4nOx0hD-@gourry-fedora-PF4VCD3F>
 <20260608170646-mutt-send-email-mst@kernel.org>
 <aic1PoxSiHzZ40Jr@gourry-fedora-PF4VCD3F>
 <20260608174430-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608174430-mutt-send-email-mst@kernel.org>
X-Rspamd-Queue-Id: 73F80C0008
X-Rspam-User: 
X-Stat-Signature: d7gogntkcajrwqz8wbf8d8netczdakaz
X-Rspamd-Server: rspam08
X-HE-Tag: 1780955625-999621
X-HE-Meta: U2FsdGVkX18XP5flFSZ9FD8KCvEmq2en2CK+1jCqf/ybfb5x6aj27ez1o/d7dAckHFX9hSX9SD+DPa1iKcNJIoFgOBnYMuj8xVzcoyolJTgIkvxyjeNejPcS7i90MDSnCJ+lTB2+cZFOODFeVwW9kSidyw+7WVU8e7fXf98tO6YSCFeH+QRhtOOGJU6qwj+6VGrZmb85XvIIOkCoDVYy87MSXWihBx3+8ZY9Mprz2IMtvAr6B00oP8JatkJ3dduffx3pu2kArc5lh5ehAmfDyLgXXdDbOVDEHBAL9alvI9v7PpztWyvid6Darux+NplYriOFXac574HhJ5KeboJHar/w+LcUUFtROgo4vX+HmZYeue83qo46Wkvd8DZIfmPwRyMqcSOEJ5d6NXjyPmWwwRSwl1hUb595XhtQnCB3QlO1fZK9RnTDh0gDhn8tu7PrqiT5XeuqwqxC0OXRO+dGk3qnbfQ76m2zMf12EvG0RPMDHy5Ru54zoh0ro+lGScOX5oJBqRx+jQ/dgIZ/P0/Gg9gQEOIAYgKuDZ8lBGoqSWW9qlg+zlx0ikSbVR+opqreYc8fILpsoWn1E95NDNCi0Bj4C8C2N3TjHeAEbLSe3PdeXIb0+VJgpugizphYOolQUhJ1lSb4WOepYlzn37liZS2ljWsJKc0nE+HdSvGjAUZE2nccQgCT9xrpyC+6Bm+NjNv9SEiqaIZCHf/smCsMC8GN2TvsjbtxAkw7Paj1JGJWLODiBRFSk5Cvi5fob6BKWVUGs+5MACd3ZkaPrHSp1SdhLCEgCEiTi80b6bmCj+staOlZ8Sxj7EW85vMs7YiGqOoDBZ8CELM5S5Z2urBlvUt9ba3bs2dG2OlDgXVq/gcuHqWf6QQDuaxwODF5snbpMxLkmzAL3mgAgJHqaLLK/EUh7IB8Aw10HTFfx9lo4UvGplaxGTaT56zidJIy8MF33bH+3kiB3uxFX5T78F2
 aMrIJVgS
 ZON2mLNvN741mq6lSI19mYdkt4c4gafQeNK4ohUM04W+Cp+vV5p/gFbH45nlTRgXDUDdQHQhwb47jW++Ff7StD5ZMIVzul53TtAALTa3cLIGsBWmdZRD57opID0tjp0QFpJ4vyqj7IXjwIfNhwu3HdGO3PZPKI11MYYjXVt/cHZPfAy6IgpR8/s3vKna5RrV7gbqOS4wuzJhN1oz+0q+kYz2cUA28WcTsV0GZPvBJ2ZmOY7kUz0HyvJYzfkDDTSQBAj9Cj8GFF0WXNq/fUaq+omG7soXQc1yljTQFDNNdNG3axWTqRYQonAcfWsGx8zZaPeJ2RJD3ZXLfMmCRBLXh+FfcSyd9JcuHhLCKYR+trCFQTP0rxlGlamrEWjIKEwS8wpk/DzZvRdydUDOMVrQi6uGoW+C0P4VW4YxTPnUfQ0zd3OC6pPe6OdSn4KrTy0ZTnzoBQuPdCz+fDsU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 05:46:27PM -0400, Michael S. Tsirkin wrote:
> On Mon, Jun 08, 2026 at 05:33:50PM -0400, Gregory Price wrote:
> > 
> > You'd save yourself some revisions by taking the attention you have
> > right now and starting the discussion thread (and consider submitting
> > the topic to LPC if that's something interests you!).
> 
> Well it's in october, is it not? I don't think I have the patience to
> keep fiddling with that for half a year.
> 

You might be able to find a way forward that doesn't take that long, but
that starts with trying to build consensus on what to build before you
build it.

You're proposing a non-trivial change to the page allocator API, I would
not expect this to move at the speed of claude.

~Gregory

