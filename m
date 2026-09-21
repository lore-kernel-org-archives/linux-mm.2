Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED303C982EE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 13:27:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D43396B009B; Mon, 21 Sep 2026 09:27:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D19936B00B3; Mon, 21 Sep 2026 09:27:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C30186B00CD; Mon, 21 Sep 2026 09:27:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 94A0F6B009B
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:27:07 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E6354401AF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:27:06 +0000 (UTC)
X-FDA: 85237845252.03.EEA2EDB
Received: from mail-qk2-f43.google.com (mail-qk2-f43.google.com [74.125.230.235])
	by imf30.hostedemail.com (Postfix) with ESMTP id 102EA80005
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:27:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=czVHOdqd;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.235 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789997225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g8OWcp+USTfkb42p4HBmWgHmBefi0T5/3MfSmR1kOTo=;
	b=m3bu82WMd45BrmMQTSq7kUjxmSfsqpL88D4bq6osjyC7ywLU+ch3E9/3QhWJyIhhmlTefI
	qxw4I6fg+cNbnK4ZAgAiaU6yn/+XDziDjIxDkwfqYmN5ehryjL3G+S/GYUe/4suzAuTT3+
	PJPUFuDPAKMgonJg4x9pM3+K1NxEUQI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789997225;
	b=g60telKnLtFmJqAGbuRj90y/AuNp4SBP4gfTUfJWT8raIzzNn6mDbQj7JOuEy+/QCnT9gx
	KvRtAZIhFj8KzB6+gZNL+ypWhu6MwOUAfb9PzXq33rdz+mytq9FNkvAv0O5UlyeFItMBtj
	7bx4bYpil3aqalF8x2IR5v4Gsi11sTE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=czVHOdqd;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.235 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk2-f43.google.com with SMTP id d75a77b69052e-52fb7692a57so37541051cf.1
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789997224; x=1790602024; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=g8OWcp+USTfkb42p4HBmWgHmBefi0T5/3MfSmR1kOTo=;
        b=czVHOdqdnXsG9XZu7cqH2DFI7Uhf67uZzyGgNTyOIikG4xicw7T28yZRUtJHLoDYwx
         1KjHCyERzldR9UTvUFlumgQBNhSlI4bj99ZhIkii3oT/SVb4t6WDGSbqpT2AcDSK31O8
         oZlKsOgRfoDdy18V4zKnJF269dfS0IDQ9rB2Vy/wX2gDTK/EjGg6Vy2MIZrnhpE/lGjS
         vc1IMLGNW02MlM6xuI1oqrGd9eO73ZwpqZ6BSrGofF5hUKPlCgHd1kjYFh/m1aLz44/x
         19f1VFHjnHjjg6cue+FiG9zvjhF9Pk2DFmGafU09vJKm0IxEr8JeTpI9hSg6YRQukPHo
         lz6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789997224; x=1790602024;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g8OWcp+USTfkb42p4HBmWgHmBefi0T5/3MfSmR1kOTo=;
        b=ZMnEDUAxL70y5OgX2qXUZZwLsg5zgRtOHzyOCuf+SJ+h44sp0RZVeIQ6jaqG+LgqYS
         FhBSP3f41Cn0l14uZNAqxEI6QHqw0m5haBkBHkelWIhUTFYFl6+XK4FWBBv1dosV/naZ
         oOKZjDKQaKom/FZM/5f28DGU+hMDhsGJaN0/RI1F96xc3iuqSG702P8EuUBRfAA67xE/
         q34YxtEHICmwEazhddZVxQjD6ZbEzXjkdR2geO2BcWmixXizU6hL8Gv1d1dLu5BTaWSt
         5v9HuofhNuZiF7oAgVYWFx5F1DQxOTxl3ITd/35JTpUiaqPW5bnFpjNVmnLwoXRr3mR/
         OrIA==
X-Forwarded-Encrypted: i=1; AKwUvBw1nXBaZMyrit8we8VQHaoEBEkmgJmGcBhW7Y9BMPAg9xQrEWKHmnYA7V7SaQKi+BQowXBh8cXq6g==@kvack.org
X-Gm-Message-State: AFuF++neLGR1BvWw6BFXzHKEgW1cExGwW6MHoe/JUXXudxwY2w1/RtkA
	LGa8eEUtDrdLOdvT6Xsye1szB6AC3TrN905k6Q9X6hwuZ8NiEG26uorXZL0EyY/RqdY=
X-Gm-Gg: AYBFou3DjIdsvv0PRdgMEaY8W9SGE/j9KFkZB+5kIc3+JZsQYgQW+Bh78dElBIzw2B/
	TdmY0+A1TPbZqnY3AKCJWXk9XxvD77F5IGD/9byCNwVfkdiSikJuxT4DzeIu9KPrKv8Aen2+SZ4
	m5jw4D1U6hmg8tZQ4DotlMwE4QE1IyPTTBiYFi8v3Yqe8XoqvHFpyxhKMZ+fWMDczlVO0M6Y5Nd
	bWpo6gq5AkXGWykqBwh3PqUVT+dk0skuKU//yjUV6MVLrFlW98+jfVP6jYVzb/j9Mj1SS/+GPqw
	DnkMrcO7VqvR8pkbFQVt5c6F3ApBkRdVjCMFxh7XHeAPZYHfO6PELYEHtQdZEOPr2SZFtV4OxLA
	aoT+iOq483tgXVH1ugv0Z9f0RcVEUTKW+yTBcdtMwuxcjIBp2BTlknzyym3kwpqc03B4fgNoCgv
	eL0zDC2tl7Lkvr77sN3MIjplRDteyE3sLCXkrJJ3mxhv9PCVAY5XLpoZ9+SjFlWbNUpVe0SsxjE
	U1S80QppS7PJp9cvheydcSwsqMnhlMFg1s/cMU1IU4T6jflcQrmDZI=
X-Received: by 2002:a05:6214:4517:b0:910:6d8f:a2b0 with SMTP id 6a1803df08f44-913fc94a599mr6047846d6.31.1789997223808;
        Mon, 21 Sep 2026 06:27:03 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91260962cddsm70137456d6.3.2026.09.21.06.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 06:27:03 -0700 (PDT)
Date: Mon, 21 Sep 2026 09:27:01 -0400
From: Gregory Price <gourry@gourry.net>
To: Kairui Song <ryncsn@gmail.com>
Cc: Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Tejun Heo <tj@kernel.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arEotFqE7ZZoxMHd@gourry-fedora-PF4VCD3F>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora>
 <aqLi6cIjD2wJwk0B@cmpxchg.org>
 <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F>
 <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <CAMgjq7CJBHkoZmg9oKNgGA8czL0djyBTCAkPz8ETm-tX=Qci4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMgjq7CJBHkoZmg9oKNgGA8czL0djyBTCAkPz8ETm-tX=Qci4g@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 102EA80005
X-Stat-Signature: 66qxmkscw7oe7tjmsbj6zryne36zw4ni
X-HE-Tag: 1789997224-699852
X-HE-Meta: U2FsdGVkX1+WFaNOVDPI4lGY7ORON5ThMfd/6AS+zTyH9W9DMLQThF+w8HUbmWgctP8AmjItQjmFIPs+umlRfAYCAYupnPLy1WkMMT38udXjVo3fekN6RpNJ+xvC4qtKaIW1fBUqf+6hSE9xnIm3B2WK9b13vO1zybJCKu8osTNWJT6gCR6MRlgSArKEJYKlk8aq/T2kfVBAq2XG5qqNX0gWPc3V+ztqyv572qXUnUTevCAD7SXTPLX6ahZgcyK781d4nuzqefgucs4yo7XbfJN+OHJ/v895P2u+U7MoQmlgL71AzBS1edRlu7ePEfIMicfadlstu0k4COPAS9TyuI4zLU52uffpYTFsIOTXJ2mUqk0BHlCBv5qKP+o4Dp3o9mvP4oFCBn7YS2fvKPsc0rqZDi0k33vhUDFYyt3povGxVKCRl7rdLTL2/mnS2FZM8Kaa0OWAvf3uAyfcObKc1/ECKbsENgqUrMMtiHH37K8e1Yl+ZKRKEDZhAgmXkm4ZrBWWVA/n+ZM2UePeZ5nRPzvEY8jJF5HOKyit78N6YGAe7lyDHiY5LVQBQ+ijvJ2IGL38dWCUJwOcp0FbnBYnbLRyna6ag1IrPt8TRybSPeJgDN+TRzhxaodrEIQTi44UaMX8jdQ/DDdlD27dCIOtkPG0EHp7QSzbcJet9a6PG/BUiPirZd7pby4GVJEZbaYG2/62xgdZxf2kt9TMEoyxiKarKqgu50NKVzolmB/2be1i7Bv4VHST87OT8DXQ5iVuWaaGPlmcVWQPlYJF7wBlq8JlXCcI7iGr8YppkVP3Pee+8nCgMhksnrHTN5y1oa6Xp7p8+sVOWPgDKRl8SCiRmKjARCuqL44UogLOcJuah40JVzxjSAT0GVjtu3kQ0c9bWu5akCtEXNFcwUo2YYkQ2UuRuVrGVVoJz8dAR8wRwi+X3SZJqojbG7g6PC9P7jzyxoj7ueck7Y9n7CHnUN4
 I0n++xcW
 s6wO186BRvjNaBdzxE5dsfGA9HiGxm1JA+ArLWA/x2LVdfpqAe/NWAfLOiPKorDlAwv6vFF95rb/pD+Mlw9+H3XSJerp+MgjOENLakV4YDaNC9Nln8PD4SlqdeZ8H300C2HBA5gCzoGjbqRQvpDNjJpSB/s4+cl075uIJpuddNIrDLz3ja2uwEdb0XkfAH9jrK9l3CJvA56edFAhoUpd7b/pBPYHkzxO+YFP/h2pk9QDMGs3TiM3TqqeIgSwlX5SkmunkUYROsLN+pb5PRvyUhETUv/9n/f3EfsFQWfN01+Cdz25XtCSEM/zPS0+I6v8hpEHhKZk3vG8dsCYrNFXh0z8RN5uwPTyZhjBC0jeQlXdEM/O9o3nIvyDp2yu8humUCRvjX88iFbqu7b9lHEXJqcJNFbjtIKAQWjFHLVbAlABh+flBLFvhhQk/UUNsyPASmzH3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 12:01:18PM +0200, Kairui Song wrote:
> > First of all, the traditional swap counter has a very well-defined
> > meaning. It is the size of the memory that, when accessed, requires a
> > page fault. A page fault adds significant latency to memory access
> 
> Yeah I agree on this. Swap just about makes resources not directly
> accessible by the CPU act as RAM, whether that is storage on disk,
> compressed memory, or a network resource, all accessed through a page
> fault. I hope we won't make this fuzzy in the future by introducing
> too many magics.

Hm.  The counters are already fuzzy - the accounting is already doing
two different jobs.

Suppose we want to allow 24GB of logically swapped memory, backed by up
to 8GB of compressed RAM at a 3:1 ratio, but permit only 4GB of physical
swap.

Today we have:
  memory.swap.max  = ?     /* logical memory requiring a fault */
  memory.zswap.max = 8 GB  /* RAM consumed by compressed data */

If memory.swap.max is 4 GB, zswap stops after 4 GB of logical pages,
despite consuming only 1.33GB of RAM.

If memory.swap.max is 24 GB, zswap may reach 8GB of memory consumption,
but the cgroup may also consume up to 24GB of physical swap instead of
the desired 4GB limit.

memory.swap.max is simply overloaded - there is no way for us to express
both limits.

Could we preserve the existing swap semantics and add a physical swap
counter instead?

  memory.swap.max  = 24GB  /* logical swapped memory */
  memory.zswap.max =  8GB  /* compressed RAM limit */
  memory.pswap.max =  4GB  /* physical storage limit */

These limits would be independent and compose naturally.

For a zswap-only workload where we care about RAM consumption but cannot
predict the compression ratio:

  memory.swap.max  = max
  memory.zswap.max = 8GB
  memory.pswap.max = 0

For a workload that performs poorly after more than 7GB of its logical
memory requires swap faults:

  memory.swap.max  = 7GB   /* workload-specific latency/SLO limit */
  memory.zswap.max = 8GB   /* uniform compressed-RAM allowance */
  memory.pswap.max = 0     /* zswap only */

In short:

  memory.swap   = logical swap       - workload/SLO limit
  memory.pswap  = physical swap      - storage limit
  memory.zswap  = compressed memory  - RAM limit

This would preserve the existing memory.swap semantics while allowing
both backing resources to be constrained independently.

~Gregory

