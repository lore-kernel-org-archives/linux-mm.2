Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DAADC61DBE
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 20:32:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05F766B008A; Wed, 26 Aug 2026 16:32:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0374B6B008C; Wed, 26 Aug 2026 16:32:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8FA36B0092; Wed, 26 Aug 2026 16:32:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B93246B008A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:32:04 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2371D140232
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 20:32:04 +0000 (UTC)
X-FDA: 85144567368.15.D52E870
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id A7E25A0002
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 20:32:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CUekZBGu;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787776322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YpcUluZmeNlEB/De7gKA8OsQpvEQvUU+qqs19ZSEzKo=;
	b=cuRnb24dAJv80a/ws2fgk0ftVp28PD5fjZhyh74ybqmhrvyYWWzbavnLp2zTZg7Z1sS3iu
	ecvOzZOj73gw5uaeJsJJNml0BMOz+3UXEDw3vKT8BBDrOzjK6ivw19r9mMKXauoqrBtZdR
	5k+ySwUTkweJu/ldavqCJqEE7ezDhYo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787776322;
	b=RIfxUfUcCV4DZMasv3gfKF2jtDPmFbvyNkssNXYFTdi/rFcppJBqlIwqRQFgFazciBa9Jb
	rO6i25xXGyxjM9xXZvQ4kefz+W19ofUT6z28y53R1JqdCiG/8G5N5HGgoXX4RM6Si5fI1i
	xcQQWVTTuuuRio1LD90huHfR4HKDpw8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CUekZBGu;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787776321;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YpcUluZmeNlEB/De7gKA8OsQpvEQvUU+qqs19ZSEzKo=;
	b=CUekZBGugW/xzLIHzYTByU9w7pos8//2S9YOMCPtpV5EPqCSwipe7CY7wREc8Q+4mHJaLq
	mCpM21zxooUFxIeI5CEuVo74PLP/6ZHK/6ZRKMhm3mXkZcabTac87pMaALS64lbrrJfcBn
	YI7hY/2BeAZejVseQKDZ2gPOvlOkNlQ=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-323-Lky_XlrOMdm_uUipvsG1ug-1; Wed, 26 Aug 2026 16:31:59 -0400
X-MC-Unique: Lky_XlrOMdm_uUipvsG1ug-1
X-Mimecast-MFC-AGG-ID: Lky_XlrOMdm_uUipvsG1ug_1787776319
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-90a602a4e6fso29316956d6.1
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:31:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787776319; x=1788381119;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YpcUluZmeNlEB/De7gKA8OsQpvEQvUU+qqs19ZSEzKo=;
        b=IrwFwXp52Ncvg74rKI2dBOQIIm2qezBE2e9NdAtvoMJ4MaSZLb1u+c1HdtM4N1/hZd
         IzsJeOL1C8QQfmW8ZfY8G5ODsocUXL5R4WXKpIyCjDpNX2EHpHHq3y9RvW/StapfmqUX
         JhkUnM2weAfUX4dlxPWs6XqV1Rd/Knn1px92RyCMeR9L2uwfQWYPPYvAlWl7wRN7IdwN
         f6a2fwHYhjvio9nlJRUGDvLFrd5drGBdzTBcWcRv1q7XLygOXdzNZ+bELwZ4anxvjZcr
         qu2qvYHxMjUexlEo/S2uAwpU9qTfG8knrSUqxR7jY7rxr1dm1whwZ5MVD7vO4lGLi8ET
         hWog==
X-Forwarded-Encrypted: i=1; AHgh+RpIbnTpSHPG3mZA1OWAXKArdYhouuk5AL8iRpIKC7OjD2ZZ63DgXLWc5mGuekDMnAkV1Yjt4GYgwQ==@kvack.org
X-Gm-Message-State: AFuF++kE3wXHI1hz0NV1Uh7e0hdBAHByihLM/mc+WYOfc8kB1+VqVH+K
	fG9ad0nKfVMkz/dYfGl/osDVa7vJQvRbqGc3So49HEfQxLaSsZo2T6/JXrrlS0h86GdpN32/QR1
	s8CREnvKCN9wGNMlZjp1rckf2BSxlYTlnmVqfd18//M6sc9cieKSA52bcrvLnuKQ=
X-Gm-Gg: AR+sD13NnUqgBkaM4A0N88wIfmX+G2zEGObvFQT5Z2KSiINyBfUfX9Hn5LSymAczzdy
	o5CL32oqQvKqlGMyr/70LivgVKQfzyTCqQrZoI3GCh9x/V9Vrxg2XD/a63I1P1kg0uQI1ovuGhO
	GTpEo7deB22Xd9+IqvVb76W7ocsF2YTh0w/lq5ka54HzqJLNpO0jEe5wWnPWW/lgh5mRRfn/wej
	o+oYV5wEZ93wmRgWj7WNNg0gu94pBhMKcElQkD5lciKGm3WL/3kmepRJQpNRa8wGNS6wjLiLgBM
	aMXpC0Z+Exoaa/T1sk2L4YiDUVL6Fr50cMAjp2nytJO1miMwMg31TV3AJ2syMJS6I6N74pddAqg
	4EVjDd23MWDN1uTDrE7XCKM+13oSjLcHcx6Sxsc4cDdSi
X-Received: by 2002:a05:6214:1cc8:b0:908:a729:73bf with SMTP id 6a1803df08f44-90cc792fe20mr112761606d6.22.1787776319082;
        Wed, 26 Aug 2026 13:31:59 -0700 (PDT)
X-Received: by 2002:a05:6214:1cc8:b0:908:a729:73bf with SMTP id 6a1803df08f44-90cc792fe20mr112760516d6.22.1787776318384;
        Wed, 26 Aug 2026 13:31:58 -0700 (PDT)
Received: from localhost (pool-100-17-17-231.bstnma.fios.verizon.net. [100.17.17.231])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90cc63bcec2sm36143716d6.5.2026.08.26.13.31.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 13:31:57 -0700 (PDT)
Date: Wed, 26 Aug 2026 16:31:56 -0400
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
Message-ID: <ao8uZ0cNyqaAJuPB@echanude-thinkpadx1carbongen13.rmtusma.csb>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
 <aowHqqaqK7TeexQH@tiehlicka>
 <ao2gA_m3BCBu2esy@echanude-thinkpadx1carbongen13.rmtusma.csb>
 <ao2t6HP-Zt5KDg30@tiehlicka>
 <ao3UKM5SbxBmxuR0@echanude-thinkpadx1carbongen13.rmtusma.csb>
 <ao3quaSze8YjPjxZ@tiehlicka>
 <ao3tFg4JLNlbylTR@echanude-thinkpadx1carbongen13.rmtusma.csb>
 <ao6eC2SUIGVz3Qct@tiehlicka>
MIME-Version: 1.0
In-Reply-To: <ao6eC2SUIGVz3Qct@tiehlicka>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lBFTrUBhJ2HKjBBv2CMQsdY0oyfBaECs705W54IcuJQ_1787776319
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A7E25A0002
X-Stat-Signature: bh7ccy8pgmc5kbzop3ky1epai5z3zoq1
X-Rspam-User: 
X-HE-Tag: 1787776321-934500
X-HE-Meta: U2FsdGVkX1/cPWeQzxPLwtA+5MoQ+eXPxUz8xOXnzUvBVyBtaxsSUIfvS5AUbfvbXL09hb+vJGKPtYFxG+X+dcql3MIyTxHI0OS5UT0BH/xu8uhyAtC358u6ms0bz4QFSNvQxIeNY9KMhYNFOp8GkF2P/2s2jw0YnG+glUsEdcr6iswVshtCS5qFCaG4c5njvB7PGw7on+T70xqpJPlFnystD23bKIVzchXQoYhA++I1qkYAaqdC3Aq1y1kFcxwa1+qM9Dr+YdgFBcHbICvBC1ixn98ZQnT8muw+YkQaBb1/fdVu8Wh6an6lFUclnuKG0dgZ+ad3fH0vsMyGTPwIz8WjfsX92FzUT6XUJORBSh+ooNvBCLTEwnd056OO5HLwDVRXzFf3HD+i2oAXA3B/+QgCyGKK9E9+tK8HoQApT4nw2DLNWMSo0hBmmIvtVNqNrCiGOj2/6nj/ptoIbA9GFNwEUeF3K9YUItzTRfuoVoYWiEwdRZDlpzun0lpNzDRQyW7jJdcn9trNN8ouX7ahPGy9EeSjR+d19+zyHEjOu+T3JmjqOhU2yAPR+JZEgbyxcBh/q8/QmekV/SU5Y9/KgAPSxWG2Sf6ziv+9+oPvdcTmkaUAtxoZFnlcql4qNUPA3wKGAIW6KYwLh4D6X9WCvUBPnB9PWg9epe26eomJaatbjijj5tAp/8vXNAVksYraTfz/Bqqp9OoKG+w9Fb4i8g0jXkBfjTEf6i2IO0+b5CqBWWhSuXK9O7H3AwaUeGJXK5UfSM9FSfU5Sy5kpr9kBzVoov0yPGE7ZfL3aTBvJtlM+d08y3WwDTGmCa4f97eRi/9eEs1enVI4J+a1jMutwmW9YLmpd7wxIGAfOxFDkuWA5nv8i4ZEm+IoK37cjoL4JfZ/J+CTd1/CmmfvD4cx1WTn9c16/QeQBKuZq39sPe1/WIoizAXRhBB9/3NQNQlC5s33QgLXEs4Vu7Frd4D
 oe5ZwiIj
 puZvq8N/mrqA7ChWgUlyTnsW4nJ5O36IIwAlSkSW0+ZoWKHG2uvlI2GtLIAh6P58QMbK1OHfpcm2YbYbTL1Rw2Bw1nZjp6TDbKzli7vvMLjtpfJp8trPJUMN0lFDZXj/YYGesMh9is0l+vTs8dSru+ArTWNlwDwWqdoZ6KqvrYX7WLKIER+SY7rOuOaoRC/9ESv6eQrhhHPYkhAzZs1dnfukF9ZX6zbpODqswUKH2girjX9FwTNoFtHtAv/xMs8+Kmk1bk/oLohzAAurLDBULgMn84v271ZMpC94sanrNCUECVQI/S1Qu9Pd9ItEDDjMhL9WXj0pAYHLYCYrYhA4Y1CwwBgmjGCRyvY4N2NzWUHH6UVDGPMpMgy0vmlNvFegcIeX4zApGydrq2J4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 10:04:27AM +0200, Michal Hocko wrote:
> On Tue 25-08-26 16:58:51, Eric Chanudet wrote:
> > On Tue, Aug 25, 2026 at 09:19:21PM +0200, Michal Hocko wrote:
> > > On Tue 25-08-26 14:33:48, Eric Chanudet wrote:
> > > > On Tue, Aug 25, 2026 at 04:59:52PM +0200, Michal Hocko wrote:
> > > > [...]
> > > > The administrator opts in by mounting cgroupfs with
> > > > memory_cma_accounting. At which point the cma allocator will charge CMA
> > > > allocations against memcg and manages a per area counter depending on
> > > > what area the allocation was made into.
> > > 
> > > So each CMA area will have its own counter and limits?
> > 
> > Yes, in order to enforce a limit per CMA area this series add a page
> > counter for each area. Areas are fixed and discovered early so the
> > counters are added to struct mem_cgroup and initialized when the cgroup
> > is created.
> > 
> > An admin would then use the cgroupfs entries to assign an area limit to
> > a given cgroup, something like the following, using the reserved area
> > for example:
> >   mount -o remount,memory_cma_accounting /sys/fs/cgroup
> >   echo +memory > /sys/fs/cgroup/cgroup.subtree_control
> >   mkdir /sys/fs/cgroup/mycg
> >   echo 16M > /sys/fs/cgroup/mycg/memory.cma.reserved.max
> >   echo 64M > /sys/fs/cgroup/mycg/memory.max
> 
> OK, thanks for the clarification. This confirms my initial suspicion but
> it is better to have it clearly articulated. I can see several problems
> with this approach. First and formost I do not think dealing with all
> cmas this way is manageable. This can become a mess very quickly if we
> have one limit per cma and too coarse if there is a single one. I also
> have my doubts about space allocation control through a simple limit for
> something that is effectively a reserved physical space.
> 
> I might be proven wrong but unless cma serves objects of a uniform
> size then this will simply not work in practice. Hitting ENOSPC without
> hitting limits and thus impractical for shared space management.

Isn't that an inherent limit with CMA as it is? If the area gets
fragmented, some buffers may no longer be allocated since there is no
remaining hole big enough to accommodate them? I do hear that putting
arbitrary limits would make this worse, which might breach the threshold
at which it becomes a problem.

> 
> [...]
> 
> > > > It looked consistent to use memcg since movable pages from regular
> > > > allocations may end up in available CMA regions until a CMA allocation
> > > > needs the space and has them moved. So in an extreme case, hogging the
> > > > CMA space of a large enough area could trigger system memory pressure.
> > > 
> > > I really do not understand what you mean here. 
> > 
> > Non-CMA allocations can end up in CMA physical regions when necessary
> > (ALLOC_CMA flag).
> 
> Correct. But those are a subject of migration so any such placement
> should not be blocking real CMA allocations.
> 
> > Since both CMA allocations and other system
> > allocations are represented the same way, with differences only in
> > properties, and they can live in the same regions, it sounds reasonable
> > to account for both under the same counter.
> 
> From the memcg POV we do account physically consumed memory. So yes,
> it makes no difference where the memory comes from. We only care about
> the overall capacity you can constrain or protect. Generally speaking it
> makes sense to charge heavy memory consumers directly triggerable from
> the userspace.
> 
> That is all memcg can provide you with. Specific requirements for
> specific types of memory is a different story. We currently cannot
> control per-numa node for example. There is an ongoing work to make
> memcg memory tier aware. 
> 
> > > > > > memcg looked like a good fit to achieve this, albeit
> > > > > > handling the areas, so a cgroup has a quota in a given CMA
> > > > > > resource.
> > > > > 
> > > > > Please expand more on why do you think this fits into the memcg model.
> > > > > AFAIU we are talking about a unreclaimable memory and reservations of
> > > > > CMA areas.
> > > > 
> > > > Since memcg already accounts for some unreclaimable memory (kmem,
> > > > hugetlb),
> > > 
> > > hugetlb pages have their own controller
> > > 
> > > > or induces failure if no reclamation is possible, I did not
> > > > see CMA allocations being unreclaimable to be a blocker to track what is
> > > > otherwise system memory.
> > > 
> > > yes, we can have unreclaimable memory charged to memcg, that is not a
> > > real problem. We have all sorts of memory consumers that need to be
> > > capped charged to the memcg. If dmabufs are another ones then fine, just
> > > charge allocated pages from the cma area. It is the "make all cma users
> > > memcg aware and have per cma limits" that I am really struggling with.
> > 
> > CMA is system memory independently from its usage though, and in cases
> > with shared CMA areas multiple users can allocate from them. Yet the
> > kernel cannot enforce usage limits.
> 
> Correct. Those are effectively a shared memory pools without any
> control. I do not think memcg is a good method to enfore any usage
> limits for that though for reasons mentioned above. Memcg is effective
> at capping the overall memory consumption of a workload. Not really
> great when it comes to a specific memory pool control.

Understood, that makes sense, and with the reclaim scenario mentioned
earlier, it doesn't fit.

> > > You cannot really assume usecase, requirements, lifetime etc. for an
> > > arbitrary cma area. I do not think this is a viable way forward. Focus
> > > on your real usecase, which seems to be dmabufs.
> > 
> > While dmabufs are indeed my main use case, they are quite generic and
> > may not always have system memory backing them (device memory). Working
> > at the CMA allocator alleviated these disparities.
> > 
> > > Explain what do you want to achieve and then we can think whether memcg
> > > is the right model for that usecase
> > 
> > Hopefully I expressed this in a better way by now. In short, enforce
> > usage limits for concurrent CMA users using shared CMA resources.
> 
> Thanks. Yes this is more clear now. And it resembles hugetlb situation
> more than memcg. You simply need a memory pool specific access and usage
> control. Dispersing that to a global memcg limit seems rather coarse and 
> I would say impractical. So it really calls for a per pool control with
> an understanding of how the specific pool really works.

Thank you for the feedback. It looks like this won't work. It also
excludes the attempt through double charging dmem[1] as it would have
similar issues trying to use memcg.

From your last sentence, would this rather call for a different
controller entirely that would handle CMA semantics? Referencing the
other thread[2] it would also make the charging separate from the
allocator, but simplify making it opt-in at the user's implementation,
e.g, the dmabuf heap would call some cma_cgroup_try_charge() and
cma_cgroup_uncharge() around cma_alloc()/cma_release().

[1] https://lore.kernel.org/all/20260519-cgroup-dmem-memcg-double-charge-v2-0-db4d1407062b@redhat.com/
[2] https://lore.kernel.org/all/7e4e9662-d876-4493-a0b3-e31640937dd1@kernel.org/

> -- 
> Michal Hocko
> SUSE Labs
> 

-- 
Eric Chanudet


