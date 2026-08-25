Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2C7DC61DC6
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 20:59:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D54AC6B008C; Tue, 25 Aug 2026 16:59:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D05F46B0092; Tue, 25 Aug 2026 16:59:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF46C6B0095; Tue, 25 Aug 2026 16:59:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 938C36B008C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 16:59:03 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7C5C51C03FA
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 20:59:01 +0000 (UTC)
X-FDA: 85141006482.02.A193E8B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id EA009100002
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 20:58:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="RX/jzQJQ";
	spf=pass (imf14.hostedemail.com: domain of echanude@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787691539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B5Bz6gO+Bvo75SwX7Av3lT6AmsBGemBy+OoHD+/7QDw=;
	b=qyVTdUumC8L8uW+4Od9Jz9+eBvJa074JyJ4JXbPGL/k+rrtvN9NgymRMdN9MHIq0UauSUs
	RM3V/NoSc4GyB5fhDQZXQmAGqjD+61/oMpU6Jom8HrbLruvLQNw2rTV8EBRsLqTkgnt9VG
	QV9g6Y336HoUZBlWmd/66uQ75RYOju4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787691539;
	b=aD3s0SPC9uWruODSexyd8GNRaDwxsDUc6NC0k/4BK/h85OM9UlKgWnFoZ748yqYfXeT2mM
	SAWHK5IVL/m7s1scgASXjvv0A75xLJBr6RAAi6ixJkvOXGhHQbNQDQlGvqUYeXDCEp9s1S
	7DvPTs6QtmsOOpE3sy2luyKUVApcGQY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="RX/jzQJQ";
	spf=pass (imf14.hostedemail.com: domain of echanude@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787691538;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B5Bz6gO+Bvo75SwX7Av3lT6AmsBGemBy+OoHD+/7QDw=;
	b=RX/jzQJQDxM1aiSl/YPTCVr7j0QvfHaJIR864TmLOAzIutI90K668kJcBbamDdG4F1AHFM
	oPaYLI/sLoGpAQ7Y87GtsXL0g/nFgQFTlBY3mc66hEdWlxZjeai0M3LEvl46/Wgpe50grD
	YUHJoxpBpHSozTJFM2MIbRfY+HVZiO8=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-680-z1v29UxoO3-eifdOMCF3ug-1; Tue, 25 Aug 2026 16:58:55 -0400
X-MC-Unique: z1v29UxoO3-eifdOMCF3ug-1
X-Mimecast-MFC-AGG-ID: z1v29UxoO3-eifdOMCF3ug_1787691535
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-936aa34873bso12423585a.3
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:58:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787691535; x=1788296335;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B5Bz6gO+Bvo75SwX7Av3lT6AmsBGemBy+OoHD+/7QDw=;
        b=mX9smHVGQpgzkJQjOLFUKRkj8uoxX3oQzc2Ct/f+tamjmtcOlbpF3zTCCDDsj8Lgn/
         1FED+jmOcaTCjiNYB1O+xwp3ftCuCbl9W08de1WzomkQvxgrExqAU0IJK/L2tgeWm9dz
         VcrP+7KAGqnx2zglt+ufwfTIlqjS8e1uyQoOGmQ9ri/GiDZTF/o5kp91wJaqlO0/Lqj1
         DkEQQ7Un9xiNph/cxISNcwz8NIHG7f2a2Vkz6ELVjGF5EY5Hoj2BtWmgd9R6hj2OocBe
         zakccRlpnO98w9izLCFlBXItXAVj8xA2zgYVpZlQYEwOZfvwQm7XnFmYvWZEFnlMtZxt
         1coA==
X-Forwarded-Encrypted: i=1; AHgh+Rqv4PEN7ZN7+VDDeGth3/mRLQUa1+HfyxhxdxDq9e/xG8QDRq5O2u1AAL86+MykRqGFRu+gBs59PA==@kvack.org
X-Gm-Message-State: AFuF++k8OVzhzM4k/emXUBAgBn/gwDkNfl0RvI9hZWAQhfH7oPpkG5gq
	pBFxmZbcYiYyJN1fkKahTtXc53xCtDYNxPTa26VZMgib4GtgQlBulBK1GfDgF77vSuea5iN/9TL
	Ym1ueJGsqw1d2rB2vSSfRQf8QglZensOhpMaei86c4IHuehyo8g4W
X-Gm-Gg: AR+sD12jqEBh+7yh+oYO//FDn8iDyuZt/xUfYDjnTIjw8Zoi+v9YrCBB0fYl2n9+BWh
	bSzfR8q6gLFbsK9BNfKe+XyrisLO27+4fxTWe/Wwln2dZNdxx0Av5tGQZzJfupPs8N3da7ZLQnG
	1+Tu3NXbK6yr3LN752vA30TABBsW/4MM6VPx9t1FBYDjCZTJfVLE2rEKjLBOucAd/hN6ogC0C9+
	lRIMpKlih8iniRY3l/yQPdMp1DDQ3G49Hw86bR7q+aYqa6QfFbYWHHLId9HeY8mUte9dMi2uURq
	Bi8vbGm/KMN+l7Zb52NTQdqSWbrb26ke5RAgEzGtfZRTM6hYvbXBXFSCKEklTH8r3kVAk0zcq2d
	kMwx6fBzhP2n8F/Zxxc6XfhIUcvx3vCAnHeore8+pz82a
X-Received: by 2002:a05:620a:4725:b0:937:2762:ef33 with SMTP id af79cd13be357-9378044f08bmr147507885a.41.1787691534426;
        Tue, 25 Aug 2026 13:58:54 -0700 (PDT)
X-Received: by 2002:a05:620a:4725:b0:937:2762:ef33 with SMTP id af79cd13be357-9378044f08bmr147496085a.41.1787691533101;
        Tue, 25 Aug 2026 13:58:53 -0700 (PDT)
Received: from localhost (pool-100-17-17-231.bstnma.fios.verizon.net. [100.17.17.231])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9377e36879asm65847385a.17.2026.08.25.13.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 13:58:52 -0700 (PDT)
Date: Tue, 25 Aug 2026 16:58:51 -0400
From: Eric Chanudet <echanude@redhat.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
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
Message-ID: <ao3tFg4JLNlbylTR@echanude-thinkpadx1carbongen13.rmtusma.csb>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
 <aowHqqaqK7TeexQH@tiehlicka>
 <ao2gA_m3BCBu2esy@echanude-thinkpadx1carbongen13.rmtusma.csb>
 <ao2t6HP-Zt5KDg30@tiehlicka>
 <ao3UKM5SbxBmxuR0@echanude-thinkpadx1carbongen13.rmtusma.csb>
 <ao3quaSze8YjPjxZ@tiehlicka>
MIME-Version: 1.0
In-Reply-To: <ao3quaSze8YjPjxZ@tiehlicka>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rQiYUhW7caqPjM6Cf1eQSRP_64WPH_ZLxLfgdBuVKIg_1787691535
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EA009100002
X-Stat-Signature: dpja9pwmtcya7pcg9kuufzppdruw5qub
X-HE-Tag: 1787691538-510523
X-HE-Meta: U2FsdGVkX18YQrBAq/WGnG+pAuQlxrvQCUwm64AozA05fzE/G23Tmsmpe+2w3zashkoIwjUKmsmYv4sk4N3eCKugFyFmWxHyANFFpY47aAmQ+dtPkiyXkRZq8ocV0kdeV7zc9OZWO0fYFfUFLTRtI3/R6QZbdSTe+PGzHFyyQ7nN6W8thwgq5CE1G/KyCm0KqcgFIdvm/LKfQskfkDNFpu7turOCkUwHHLgNKEbflXRkQ3fOjVjZYfnV+vcF6GM/Bk6esNbswDRJfMe7y70ln6RrbII8GikwzS0HzxqelI795AR+yC9Nnbw6F7ygUu+Gu2d+XEXCeYRRVebMOMWPSRga9zMbGSCx8Jvo6wkbxH+YFx5yFkl3RlHddveBaViOUKJo1dsjo/8ABJv2kc/cBnLlq/7OxxFlI1cY7vcteki3TTo7/9cr+WIC90TmQTy9UA2SPG9lK8ZnSsivVgaBmTZC29z7NI42r2iiSU+EGIFQ0yh8CDvjgl4lY2KAsZXN+NYbvNf4t+ajmIvWo7pG0U6lcq+6imfjfH0iu+bcuvbQT2JJnABVlm0xH4Ftv/9R39BjH4PTbZxALQHhbx4QqISKhOj9SSkdLXOcxkJ9okZ7ZDmd5z+pvJL4dtawqLK7KEeb5e8d1IdQbJ4xaPmDOeW4NLb8zJ1sZH4tfmY20AD8qn8iOpjt7kuHw2n31lhZ4cc2sn0TGkE7fGY2G6MsgGQ3SD/3ApOYWA49ZHbENPnrqCOB/2Cp97zqR0vgYjURb+1kq1oWVDUVDDnwnZEpd2rG1XYWz7ioktJyoQsOleJEHysfSeftaI/IriT8Up03Kcf523WkeMTTYSF8lcsZZSBRu5+vEi/iHGg4SgwY4KO3qLsH+L2/qN9zWS/zHwHQRkELGthWw83vwWZxvRzeyPZaJGDmg5dYPG4AbTPyAbhzGCiYp1UUYHM/R5Hg90zUU8UOkPpqdI39QYFx8bf
 3hKwETOt
 cGdt5sCyoTyzitcf0XkRgNipQ/LF5hbAMCgZaTOp8pEoeh6qRnOD+6E5Q8vMpRRxvjb1QSsSB+FRoibWew73YgbS4izwx9MinE3Vhzc6IFcDF0YKFziWXBbYaqD8sMF0R4rEXRNjtT4yV/43NMUjI0jCrV9jR2FuvRQd6eV25wKH2/TdPUVnnhH9TRh9ktmu1sJ5+oNqaw1uYWTsDPUV+IBVGcJkXDEYGEsv6LyChB9Zx/A+0i0HSy/xfUWIk4TWYaC9cQBa/P9+YbuKGYNbmM+wP9EyRmu2avzWlmAh2SUV6ThmltC8VbBRo04xf7kduPgm7CNRMUsYxRa5S5kCOIkHFEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 09:19:21PM +0200, Michal Hocko wrote:
> On Tue 25-08-26 14:33:48, Eric Chanudet wrote:
> > On Tue, Aug 25, 2026 at 04:59:52PM +0200, Michal Hocko wrote:
> > > On Tue 25-08-26 10:47:53, Eric Chanudet wrote:
> > > > On Mon, Aug 24, 2026 at 10:58:18AM +0200, Michal Hocko wrote:
> > > > > On Fri 21-08-26 14:56:52, Eric Chanudet wrote:
> > > > > > CMA allocations are currently unaccounted for by cgroup memory
> > > > > > controllers. As system resources, they should fall under memcg, but CMA
> > > > > > areas partition the available space for different purposes and memcg
> > > > > > doesn't have a good representation for that.
> > > > > 
> > > > > Which CMA usecases are covered by this work? It would be also great to
> > > > > spend more time describing usecases.
> > > > 
> > > > We would like to offer some usage guaranties to userspace processes
> > > > ending up doing allocations in CMA.
> > > > 
> > > > For example, a shared CMA area is described in device-tree for an ARM64
> > > > platforms. Userspace components could then, for example, allocate from
> > > > it through the dmabuf heap, or a device or framework-specific ioctl for
> > > > that matter, to use the buffer with sensors. The dtb may have other CMA
> > > > areas described additionally that may or may not be used by that
> > > > component. In this context, we would like the ability to limit one of
> > > > the userspace component to over-allocate and choke the other(s).
> > > 
> > > How exactly is this supposed to work? How is the CMA access controled
> > > and opted in for accounting. What happens when memcg limits are hit. And
> > > many more details, please.
> > > 
> > 
> > The administrator opts in by mounting cgroupfs with
> > memory_cma_accounting. At which point the cma allocator will charge CMA
> > allocations against memcg and manages a per area counter depending on
> > what area the allocation was made into.
> 
> So each CMA area will have its own counter and limits?

Yes, in order to enforce a limit per CMA area this series add a page
counter for each area. Areas are fixed and discovered early so the
counters are added to struct mem_cgroup and initialized when the cgroup
is created.

An admin would then use the cgroupfs entries to assign an area limit to
a given cgroup, something like the following, using the reserved area
for example:
  mount -o remount,memory_cma_accounting /sys/fs/cgroup
  echo +memory > /sys/fs/cgroup/cgroup.subtree_control
  mkdir /sys/fs/cgroup/mycg
  echo 16M > /sys/fs/cgroup/mycg/memory.cma.reserved.max
  echo 64M > /sys/fs/cgroup/mycg/memory.max

> > Assuming memory_cma_accounting is set, if a non-root cgroup makes a CMA
> > allocation over either memcg's max limit or the per-area limit set by
> > the admin, the allocation fails with ENOMEM.
> 
> No memory reclaim is triggered?

Oh I see, try_charge_memcg() may try to reclaim and would do so before
the area counter is checked. So a dmabuf heap allocation in CMA could
end up with a page cache eviction if the memcg limit is reached by the
allocation. That is down to the configuration setup by the admin, I
didn't put any check that would prevent say
  echo 1M > ..mycg/memory.max
  echo 16M > ..mycg/memory.cma.reserved.max
, which would exacerbate that scenario.

> > If memory_cma_accounting is dynamically unset, no the CMA allocator no
> > longer issues charges. Whatever was already charged can be uncharged
> > when it gets released.
> 
> I do not follow

I mangled my sentence halfway, I'm sorry. I meant that the charges
persist until the resources are released. Enabling memory_cma_accounting
only controls if new charges are issued.

> > It looked consistent to use memcg since movable pages from regular
> > allocations may end up in available CMA regions until a CMA allocation
> > needs the space and has them moved. So in an extreme case, hogging the
> > CMA space of a large enough area could trigger system memory pressure.
> 
> I really do not understand what you mean here. 

Non-CMA allocations can end up in CMA physical regions when necessary
(ALLOC_CMA flag). Since both CMA allocations and other system
allocations are represented the same way, with differences only in
properties, and they can live in the same regions, it sounds reasonable
to account for both under the same counter.

> > > > memcg
> > > > looked like a good fit to achieve this, albeit handling the areas, so a
> > > > cgroup has a quota in a given CMA resource.
> > > 
> > > Please expand more on why do you think this fits into the memcg model.
> > > AFAIU we are talking about a unreclaimable memory and reservations of
> > > CMA areas.
> > 
> > Since memcg already accounts for some unreclaimable memory (kmem,
> > hugetlb),
> 
> hugetlb pages have their own controller
> 
> > or induces failure if no reclamation is possible, I did not
> > see CMA allocations being unreclaimable to be a blocker to track what is
> > otherwise system memory.
> 
> yes, we can have unreclaimable memory charged to memcg, that is not a
> real problem. We have all sorts of memory consumers that need to be
> capped charged to the memcg. If dmabufs are another ones then fine, just
> charge allocated pages from the cma area. It is the "make all cma users
> memcg aware and have per cma limits" that I am really struggling with.

CMA is system memory independently from its usage though, and in cases
with shared CMA areas multiple users can allocate from them. Yet the
kernel cannot enforce usage limits.

> You cannot really assume usecase, requirements, lifetime etc. for an
> arbitrary cma area. I do not think this is a viable way forward. Focus
> on your real usecase, which seems to be dmabufs.

While dmabufs are indeed my main use case, they are quite generic and
may not always have system memory backing them (device memory). Working
at the CMA allocator alleviated these disparities.

> Explain what do you want to achieve and then we can think whether memcg
> is the right model for that usecase

Hopefully I expressed this in a better way by now. In short, enforce
usage limits for concurrent CMA users using shared CMA resources.

> -- 
> Michal Hocko
> SUSE Labs
> 

-- 
Eric Chanudet


