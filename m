Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 945ADC61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 18:50:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69A886B008A; Tue, 25 Aug 2026 14:50:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64AF96B0092; Tue, 25 Aug 2026 14:50:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53A636B0095; Tue, 25 Aug 2026 14:50:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 234F56B008A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:50:24 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0B45514013F
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 18:50:22 +0000 (UTC)
X-FDA: 85140682284.11.7F1B530
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id ACE6740003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 18:50:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A6yc6QOT;
	spf=pass (imf04.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787683819;
	b=s92iOzrKbpMoseDoRBj6yaxMuR/0qpdew9+T0jPwXAFMCOhp9ovC+84p191XnrnYAZDOjA
	VYS9Uu0Y0s8Bg2zUzJmJfXL9eNhclpFpflcbn7tHQECAVqowX+Wu8grkQap9Bqnc+LVLLw
	AV4t/pEttoHBdzC4HY1ZJUl8lL1zV/w=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A6yc6QOT;
	spf=pass (imf04.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787683819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bY+uq+O6hs+OCaV9/h1J0zsMTaL2h9lRcnb5h7llFxE=;
	b=75ecscqoiOQJ4BC0mecdnvo4vGyFrD3Kw6BGcCrwpNblEfXax2Spe3eITHUXoF3P7m8PH0
	WryLa127mUMBGLhlSTfdLYBiM53G8kZuVYBnrXmZG+rjV3bqDZ/S4uIZStydafMocjk+S3
	LgoDUdJyKGt/Fio6Gu81xhaQacsVeWQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787683819;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bY+uq+O6hs+OCaV9/h1J0zsMTaL2h9lRcnb5h7llFxE=;
	b=A6yc6QOTsZpiE5MIdHTDrhFWX5b3piNQ26brbY412fGdavqKdS3nuZEVnZ3EqszsgvkB/2
	me2W1jDyTM2HQjmLcpyDXzpKX9dRMttzY15xCyqJT8upY2H6phoucz6h6422TR9oYzKg4s
	BXG5b3DDxmCwhSSMUyIofz9GckcKdLk=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-47-KzN3DC52PD-_ND4LXRM4MQ-1; Tue, 25 Aug 2026 14:50:18 -0400
X-MC-Unique: KzN3DC52PD-_ND4LXRM4MQ-1
X-Mimecast-MFC-AGG-ID: KzN3DC52PD-_ND4LXRM4MQ_1787683817
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-8f45dde7595so1647936d6.3
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:50:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787683817; x=1788288617;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bY+uq+O6hs+OCaV9/h1J0zsMTaL2h9lRcnb5h7llFxE=;
        b=d3p157rVzUfRJ3RGuKL9zbjuviQteuC31Bf2gqCUWMjN/po2vppr3WoalI8B3E2ja/
         2smHvJgh+S07OqUdlVYOGYEjv7YKtgNWr1jowGvADC+w+6tWz60zEtBtQI6e5g2G3Gmu
         osazfJq0HIs6w46sUskLFTK4tGdofy43HrjaFHdHk/5gRHRSFNfIXMoBnIk8y6RDYqZ7
         uo849CXbsygpe2Cm197lOl1TZKJ3ju60yU1EiwiGdpbqYL78pGMvo0T5TAn9s+zDUEfh
         KI5W0WvkDTM3aJ/hAog7XXaioSaZfhlRtzMfjKOpFfuKCbv5mCzgz0JsDhbSeRLC7FF5
         7/5w==
X-Forwarded-Encrypted: i=1; AHgh+Rph/n+gRyJQtIduby80INVsGuCLRs14aqytsCjQjl3iFvnzlxJVBmEVWayEpnNqx5LBpzjShdK1qQ==@kvack.org
X-Gm-Message-State: AFuF++mK7M3Rc1edK/47xvrsimIWQyiNFwiXBTFTb2bPqBL5isw1QgB5
	fjW9v5tjG98J0G3kPSD8FZxAkuUr8MfmQoenckScuKv8gBEz3POY9xjG9epVVYcS/geFa8St1gn
	YccHsCQe8l6OzjyVJJHg7G666wW/oJOBiW970YUddXoxvnSGIy4Lm
X-Gm-Gg: AR+sD12+u8Bpe/j8fUHVj1ZQ023RKaQ+wegy+ytIcRn/yZZtepkhtVzxtvWhqUWIEMl
	mRh33/WwRsscKA2eLLGWR3Iw0CWcZfmBjnC5gq6rPJhc3kPe9LwTjU8SO1jdjjfX1rk9SPQMj1L
	eNSs7w8AO6wRd36LUcsWKtTELu8Mnnk7OvK+VlrBW3d7mvLN2mD/CP+JnhZTzrg0rRncxE7w826
	FRvDc0kNorNVLFzoySWnrerylNK/6ZaSQCTcZAVL5kvov8YSDdC3ejRz1vyEMtWlzZ4SFMTnCti
	pDZbZ9xfYCnWLJgZiUSvIEE8O+rgU11Hp9I8c3NfuQ19PQ7eXqam5NeDJF9VIeqKAOfql844UeI
	8gL32DheWfyoe5bA6SxEA9tn04xvAxhNCxjwsMAy4BJXp
X-Received: by 2002:a05:620a:4055:b0:92e:db1f:185c with SMTP id af79cd13be357-937804594b8mr54686685a.43.1787683816944;
        Tue, 25 Aug 2026 11:50:16 -0700 (PDT)
X-Received: by 2002:a05:620a:4055:b0:92e:db1f:185c with SMTP id af79cd13be357-937804594b8mr54681085a.43.1787683816399;
        Tue, 25 Aug 2026 11:50:16 -0700 (PDT)
Received: from localhost (pool-100-17-17-231.bstnma.fios.verizon.net. [100.17.17.231])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9377e30ed0esm42285485a.9.2026.08.25.11.50.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 11:50:15 -0700 (PDT)
Date: Tue, 25 Aug 2026 14:50:14 -0400
From: Eric Chanudet <echanude@redhat.com>
To: Michal Hocko <mhocko@suse.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Maxime Ripard <mripard@redhat.com>, Albert Esteve <aesteve@redhat.com>
Subject: Re: [PATCH 00/11] mm/cma: charge cma allocation to memcg using per
 area counters
Message-ID: <ao3gLqsF4WSeKBIa@echanude-thinkpadx1carbongen13.rmtusma.csb>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
 <aowHqqaqK7TeexQH@tiehlicka>
 <ao2gA_m3BCBu2esy@echanude-thinkpadx1carbongen13.rmtusma.csb>
 <5970a8d4-fe7c-4dde-bdc8-1c66bfb57f12@kernel.org>
 <ao3CQicH0t-k95NA@tiehlicka>
MIME-Version: 1.0
In-Reply-To: <ao3CQicH0t-k95NA@tiehlicka>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OK7B6YoP7GYRTzHLfDNFuMco7Py7vmblJ4fk2vNnsK8_1787683817
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: ACE6740003
X-Stat-Signature: 54dtupgs98goh45hqsbccegqzj5bms1m
X-HE-Tag: 1787683819-219477
X-HE-Meta: U2FsdGVkX18eopERjZBt9789833OpNGUDRtnwEM+WvVUH3YqPoMO+MW+2WLp1sGMmaLAd7gx2WvQfOf1AQF+kQcre68egn+pUcU0QmDvbZaFiYXE8ZO2B7LLNlelAcukmKSB6lF5W8v5DugzRwSl1PqmooyG0EnGjUk98JBi1JV/G91+62GjrB9z+QmNSP9UsMX9c9KFQBNZFIQsfhc76aDXcjnjXKP/Gy4X7niYmIXQlkoqN2pGp21tmeu3AQTvdAi5ifC3HvZTUPd9ld3WeZnqytcbWYJERnYNOLggS3/MYLG+DsA0x5957q7HdCHP9B8O4un0f/M32eyA8ZdcJVA2OD+IYc+MpKC9yDRmopCLBVbGbaeCmlbFspif+vJuseXHjYfAWdE/dKfW92iCHFmBFRs3WCZSlbvqp1dCBzzCtTscrBjH9OggRr0nUB7tmswp6A4WqSmKGO76vmf+bpBi9K8RFoaMYUaeEKbaBCUmYnQczRq73kVHsQF6/rfIvbXM3NCINoPt/XyqM6mNFYtlymXjxXMFd3Am63dOYSHsHL/03RM25e9OGkpHw4Qf4ZWQSHHyDpaSxojoRvOQeUKx0CEA9Y1Iy8MRJ5dEiWex9cXFPTeY1ubOJ5pzDT8Ltn3CRlog+OH+F8gz02H6mPr81FZdJPMdEZ9HbrNZOJq7RgVNdOrlUN6d0ZIhNe33H1YSYyuX7i+i7q0aBwVXLmwYXJj8tRgO72dfu4q9qAJqAa+Ok/yhQagLIb9wwaNu4juj3DM1wxUcK2nn8RM6XHoE+4RPw+KFArDyn/SZn302d8d0ZOodm2kGSUD5W7AFQJ8p4XU7IJ1kj5NpynloGxY6XSfGHo3VvRHUukgKBlg/yd1NBR1F0IV5EejgSHdkRekAq/G26u7Pmo1yniiyXtgqbpm1+BzhfPU0KqEOKPvovgFpN/R88NsewSQTJ6NbyJnsRDtq1z82b+b1M3k
 +2YiaK4H
 QHJ/2q3lvQjBdH5mO0J0SjR6TLTPcM3Nb84UXPmVMIQ/XJiXhMCRjwlyiPf6+/cMCZIDdjHJAbU3mSm14azgGJl5mVUVuDKAKP6QFZgYY3Op5Fd9hqbFwU+7AKNh+F+dpTt+iQ+9Yc5XSpw/AygWh6gszspExubzFkKJICM8mkmsJ0A8sr/9nccmYIe/5K299Ck4Pe8wy2RSJDFiU40tSckPxnqJEpcYqEfjuZ4v3jes6aEfXu2HqTxANxes3cHgt1gwUTdxvLM6M/K/93v2vRchH8jrRtLo8cluLmnsBXCG+E1R0qKZ8Ya63MGgBaSxrV6wjvWNGHmy/r/iYvI9RFBenwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 06:26:42PM +0200, Michal Hocko wrote:
> On Tue 25-08-26 17:45:56, David Hildenbrand wrote:
> > On 8/25/26 16:47, Eric Chanudet wrote:
> > > On Mon, Aug 24, 2026 at 10:58:18AM +0200, Michal Hocko wrote:
> > >> On Fri 21-08-26 14:56:52, Eric Chanudet wrote:
> > >>> CMA allocations are currently unaccounted for by cgroup memory
> > >>> controllers. As system resources, they should fall under memcg, but CMA
> > >>> areas partition the available space for different purposes and memcg
> > >>> doesn't have a good representation for that.
> > >>
> > >> Which CMA usecases are covered by this work? It would be also great to
> > >> spend more time describing usecases.
> > > 
> > > We would like to offer some usage guaranties to userspace processes
> > > ending up doing allocations in CMA.
> > 
> > How does this e.g., relate to hugetlb allocating from CMA, to then charge to a
> > hugetlb cgroup?
> > 

AFAIU the system defines CMA areas to allocate hugepages from. For this
initial series, I failed to handle it. The intend was to consider it as
any other CMA area. It entirely missed that hugepages are already
accounted for by their controller (cgroupfs opt
memory_hugetlb_accounting) and they are charged when faulted in from
their available pool.

> > I always thought of CMA being a low-level allocation mechanism with various
> > different use cases, and actually the higher-level users should decide how
> > to/what to charge instead.
> 
> Exactly. There are many different users of CMA all with different
> requirements. Then there is CMA reservations if an area is shared and
> the overall memory consumption. That is why I am really not able to
> wrap my head around this proposal.

It is nonetheless available almost directly to userspace via dmabuf
heap, or as a result of drivers ioctl providing a contiguous buffer, and
unaccounted for by existing controllers, with the exception of CMA
hugepages with memory_hugetlb_accounting. The dmabuf heap use would have
userspace choose the area(s), but allow for no limit to be applied
beyond that, which is desirable for areas shared by multiple userspace
components.

> 
> 
> -- 
> Michal Hocko
> SUSE Labs
> 

-- 
Eric Chanudet


