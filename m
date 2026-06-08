Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F600CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 15:53:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E0E76B0088; Mon,  8 Jun 2026 11:53:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 691F66B008A; Mon,  8 Jun 2026 11:53:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 559DA6B008C; Mon,  8 Jun 2026 11:53:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4563F6B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:53:46 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E537B1401B5
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:53:45 +0000 (UTC)
X-FDA: 84857190810.15.F6A7987
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0C40618000E
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:53:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=VUchoLYo;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780934024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TE9J+WgrCGKOabTk6u8XUcIRp2nQnN2zdp+a9uxxJ3k=;
	b=LhrmW58gnRidF1IvxVccxWD7XSh9JeB6KZnzO9wzl/h3d6xyjw3NqJSEazyb6LwTKNICcm
	cJ+GXZFEiBgGUelsIHrA1GCxR+Y3Z9i1hFSwxHa2uxoTzlJKGhWzoVzflJophefrDCPqLt
	DO+2+rnZ7ktSuxgXWin0RJ3IxS7DtJ4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=VUchoLYo;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780934024;
	b=TiqG5zO72DoxGb8a/dsemSuLYgeD6jBihfdONAHk2pb06ffYg7kWfz0iYfuvyNla/Y6wx5
	r10putZIlMNUfpElIMYbHBhmFIzZDW1mkIav0DM+gx3H0v85HZ7h1bWsUKHcE/Qf3vQzTp
	jtmCUNxC7MzsZbfME0Y3/FrAvzDy+io=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-91578122305so750936685a.0
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 08:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780934023; x=1781538823; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TE9J+WgrCGKOabTk6u8XUcIRp2nQnN2zdp+a9uxxJ3k=;
        b=VUchoLYorrfpvSCe2m/V+Xtclg6yXW6H4M+Cf3dVwrk3Il6sVXwlB3wCTCQ9XeVdAs
         GKQhyNzmWgDnxIyFDXOFuqePyeAyCjKmz2jFqTgtw5wI2InH0zu971fU2y0IMo4Ol/Bm
         ybmC1GFzNxyLZZ6q305y08snf1wXklilHcCY8Y9HoZte5R3G4trCAwzVVsmaCzSEk5HW
         iaJSBaRNQlpag4QBMaIdX6U3/Se9xckTZKHjvE+gfhVp961fSQnRf4AOCKm16uihDaID
         /Kipu+DB6c2HvuppEOgm0RmMpPsAee/2awqD7wC2Aii536sn3XGpB8nAMuDK6EuBDtWp
         MpAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780934023; x=1781538823;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TE9J+WgrCGKOabTk6u8XUcIRp2nQnN2zdp+a9uxxJ3k=;
        b=LcHQe81KVRjsryoh8TafyNwUvdxeRfJ2ehzCvbCktGbCPqh/EBzLEF7AE2VbgzPJX+
         KKz+IgJmBshSl00KpgCBNl8n3vq5QtYFK5T501kzvP6mGEjrkB10nhceTkSHxgbOCNq1
         3YhI9EY2mu5XNuFYdYGTtnl1FJKrB5QnrquGpKYL5wIyh0dlU7UF58mfw6tSxLPkIjOA
         g0TgJThWLOnwbS6/q5Siq5AoPXxfnljMy6WTgg9AWGXYBBr4opNK4fCxcRmh1n9FrdbF
         4k9gHP3cx6O8GXysANT35HGrAh1/wovaQQjDysfll7e6ZGjUlQohqfq6veVIYVLU2FFh
         U9Kg==
X-Forwarded-Encrypted: i=1; AFNElJ+sslIsqd6LGvEnx7eDRtL+gT5+5rMI/+D6kDv/M7PVS6E36S7Z5DHQQTIHOt4afnRIih89wuVyvw==@kvack.org
X-Gm-Message-State: AOJu0Yxo4QYThs72h53fAAHdpWYB+790C/ta8crldFUBIYbdacycf3ZW
	uyz2CQqi7kIvD8yeNrrqoI5Tk0JUY2xLPlgtGqTbT9UDJpRVQAdElKfES/NyszNBIIw=
X-Gm-Gg: Acq92OFBbAjAiibsVCgo/8BmUrUy4SIVsOcOJeIvVOH5Ag163Q5HJC2wQEq++FboMsv
	X6kR4xAbJ4FMdbIHhHvpVW9RMiTzwZLxs4ISjumU0v9tQxr9dtUnKLBgJr3aiaWT08HHGnzE1xQ
	VsJY4WGpxc/B5ush+h5zF07QPQcc9XwYFPe9DcFmklxOqEuVcQgF39e7+xxsbJ8NHRXFYEKshCz
	NbhSEJQu76JOeF1u6oYZTMUwHgNyKKATbQiODqs9IUpa1L8U3vULGiSBgCD4JeSUivWpRbokM+v
	gJRT59axJx7Og1KMbE6SWzR0d0H2vZqcz8Ia2MWsn9EVO7oOllZbaBHhr1MfB5fi3coygk1mGE1
	DnwM7HKa+CloyRZKPQ33FnaU+cw8DpxV6dxRZjec/nYGSBq8wIUFDcK4z768vtI58nznHyy5UPP
	eb0grnbwMAKdL9RvKO6DKT7JzjnsqYRnp0FbPXvuJIR4Y4zEH+Qk6v4T83igolEkELWCLCtxojH
	X2e5uoihjkOl96e3Q==
X-Received: by 2002:a05:620a:a407:10b0:915:745a:70fe with SMTP id af79cd13be357-915a9d763c3mr1868020985a.28.1780934023069;
        Mon, 08 Jun 2026 08:53:43 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a37bcd6sm1798163585a.25.2026.06.08.08.53.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 08:53:42 -0700 (PDT)
Date: Mon, 8 Jun 2026 11:53:40 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
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
Message-ID: <aiblhJv_BvMn_8XY@gourry-fedora-PF4VCD3F>
References: <cover.1780906288.git.mst@redhat.com>
 <f92f6f06e5804b4ea7f68b8664b7e69953b50f4e.1780906288.git.mst@redhat.com>
 <aiacZ6_7SG3nvVjM@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiacZ6_7SG3nvVjM@lucifer>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 1chb1bxptpbzke6rrca9gwzhnm19jk3i
X-Rspamd-Queue-Id: 0C40618000E
X-HE-Tag: 1780934023-74113
X-HE-Meta: U2FsdGVkX19zjqZ4Z953eWdDDsSLCs3t1PdBHhY51DQCi0Br2w0//573Rc32fRlMWcyBSxY2akMVpQQYRxZMRs1LII5NXIZbaRM/mXHIGMFdHKuyaDNSqf5eTJ6CzwB4rRdV9k3+eD7y3mlypiDehnatvwJyQZyXPsDC5ObHjuwY6kOf9PKQOu7SAampFIK7VQDESE52fmO2rxy82Dh3NtKaGBXhO6bicgS82uKb3Hj0r6e7qpNhaVFd4QdLx3RyBhxj3wGeBiCl0Fp/moVprY3/H1Iiuvh7uDlfmxEyovneHTwFO2hz+3OiuPWJ/PJxe5x9Y8rLz97XE7O9r86azhkDhk7Uu3AGjGdV4pHCTVWr7AbzJSiAV0J2RVfxX2oB+X3DrM2wi221QCnL7lvE2zT+p9+6dV8zyw+QqWlKvIkMRsBLwK74h+HDssfIbUWJbzCDHuBX4EhFNI2HOGwns6LAuyzvDFHYzg/3/fpXNseIoJGCmpBvbw9MWUi5Rj8BRaHwhVwdnh50zrTXF3HIkGPUFMlUeg/slwHmaBBsGZL5frT3rd5aCSQKzAFZ9dA4zJ4YDk4sajmuItdGiDsBbLZ0yT7WVKcZwkCDa5WDIVDhNcaMQIFUrMZVmPD9ubR+pal1UUUFZtgz6wDJqkLqDbu8qMO0AfZal7pUKQ16yM1QRt6P3iQyIK1xABwVo8JTi6HLd9lo7z80OOjjdzev39PVtdHsBX1s9sXZPCeJXyF7QFIOIzDbyYYwKVRECS8tG0BcZmCtnPP+yWOpGCIwR4uQcaJnaCR1SSpz7ainC0XJtMf8u5wxiAvLSrG4B3I32u5M/V34GocHxg05RwU2QS1fP+EAuI7SmM0CTF/iZqkGcCzI/XJmtkXMOIOV3jCH5ktNjisPwJn70QyBI8VcHLXLCJdaFoIUESFr/Q4nXt/tyE4/gc1sE3qXmvZDKg1rfnDyohonWG0z842nUUm
 TQlvoR31
 zBb1lzkURQWlg8ATJ8hYjrY39Fo1xTTVFWs7/pcBTJmbzAzpPQiAIK+L6mLbD5QC1pv30jLcNnpWoTbqYQZhkDzSx7oDjgz1SHTW4oGEPs2iB79QKwpVctN5X97wTQhVrGqZSE//jSQ9F5f+KxWvPXvPf1QPHotttNPFGsxdJ5voFblX6rYaD4iW3oGfDwFl5uQTpVfkQrdEtQ6RtR/K2vBMcy4UUfUKYNP5Q4oEZISixB41f2e9DArJb8zbB0XCA8aoIRBCMstQc5EVITNu3PtNRIWr8FqrmUV2a4ZV7G8qpqeyoUQRWqQVUwRuFthEF5wucNf2iSwnicVOQ/YjA8tPCU0U6D3EOPYPCVJiaatr8HnTzoZGdcdBRSkI2uclAX1SeDbpLB5Vbv8ysqZha0z8ZXlGTBmchPzj2ZETpXAtB6hV4Sq43Nt44B595vGAlBSUmxWxWQTIqRGk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 12:23:07PM +0100, Lorenzo Stoakes wrote:
> On Mon, Jun 08, 2026 at 04:36:38AM -0400, Michael S. Tsirkin wrote:
> 
> > +			 * user_addr != USER_ADDR_NONE implies sleepable
> > +			 * context (user page fault).
> 
> Can you safely assume that? Also inferring which context we are in from this
> parameter seems risky.
> 
> It seems to me that you're now making it such that kernel developers:
> 
> - Have to know when and when not to specify a user address, and under what
>   circumstances we might consider that to be mapped.
> 
> - Need to know to do this correctly for aliasing architectures or have silent
>   correctness issues.
> 
> - Need to take context into account when specifying this.
> 
> We definitely need to find a simpler way to do this!
>

This feedback was poked at in earlier versions.  There's a tension
between keeping the old interface as-is, having explicit interfaces
for something like this, and the state of a page inside the
allocator vs outside.

Double-plus complicated by the fact that we're trying to reason about
two allocators at once:  host and guest.

It seems it has gotten a bit more complicated since then (I missed this
"sleepable context" bit, not sure if it was there on prior versions).

If `user_addr` is now implying anything other than exactly: "This needs
to be zeroed / caches flushed", then this is bad.

~Gregory

