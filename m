Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0800AF34C58
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 14:30:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 674F66B008A; Mon, 13 Apr 2026 10:30:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 624D46B0092; Mon, 13 Apr 2026 10:30:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 513926B0093; Mon, 13 Apr 2026 10:30:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F4026B008A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:30:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 04FCE884B1
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:30:03 +0000 (UTC)
X-FDA: 84653767128.11.D3E1607
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	by imf24.hostedemail.com (Postfix) with ESMTP id 20366180008
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:30:01 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Cj17REsI;
	spf=pass (imf24.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.42 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776090602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l0ayyEFz5IFGW2l3yDhG5wSDGaciiRSS1hB04OlRr/E=;
	b=o90HhqEQGw+5xaEZcMRTI+6lkq1gxgsK3fWhHIlOEbj/6MR4O2U6BXPSPsAueVXYuIoJhT
	1i2u/O8QGTaIv19FyFC4MG/9XpIQS1HSZUASGHP59WEfz/5f7brbGpLh9Butd8UsVryuPH
	4mBGkfmDYIice7eSprVIqSaIjFPIuV4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776090602; a=rsa-sha256;
	cv=none;
	b=3ChQNITe+YxEC2A8+JOnrgFu+BZJ+bREXVAxwwSjSjtKmF0DMWnBD+1DXABQ2sZbe3gtci
	XzEWeBFmp6iCi6iVs5mqOYyoLdwbdaDcDebw8s2F83x9++OeF0T9gFNUB5ZjimCQXWXc8P
	Ecu2WxvKuUhdJ/UcMtdMjdKzUPg8Nkk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Cj17REsI;
	spf=pass (imf24.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.42 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-40ee9b945d5so3275853fac.0
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776090601; x=1776695401; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l0ayyEFz5IFGW2l3yDhG5wSDGaciiRSS1hB04OlRr/E=;
        b=Cj17REsI9Av0he6PDChNn0BqyuAuMlBLbYZ9fWt94OGR/888OCUuvpzYoeDxdCK86I
         zAK5lbtGfSK6W4Fw6MVkLop9GSTUpWHreF6I0MFMvyygAk4NmLfIQxKQCqXz++wRvccg
         vOSUnjaNUWN2zehY2koC0zWipDEzyO+bfbKiwAV9A2V+f4fO+r2EztXJmpF4Jf7pHSKK
         YDq/ij9UVTr9YBJfFDEV1ONiesTRqfRqJUL22tOg+QYsre6Q2YZXa6RJxafOMTFZ0qsa
         oFq7SRMAV2+zSiQz1EE+TPgw+FBV0NQzHjrTC9XTJBbCgLpqJYQcO2Djcr2K5UGL+EfP
         YUSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776090601; x=1776695401;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=l0ayyEFz5IFGW2l3yDhG5wSDGaciiRSS1hB04OlRr/E=;
        b=MzIJbcQORANrcTKZbFaPkvtRIPZtVlKpaFdzQRz+st4+axImSno6S/aK83lD0xf4I/
         p5e2zExXxxe2gRO6Rrel5jtEL/8DtObB9pC815TVw1zpARZ4p2wpVWwRFBXeCZJS4Owj
         plN/Xnw+T1TvLVXMnYMZ9lskaHBShyMWVh0k/hwfxY3n9JvTCvNqRCyQlsHqdw0dHer0
         n5z9pt2s7K0ypZdPUgOzeWD4GLjax4FksOBl1Nalr1tpWq5Kff3ISoM/UJ9o3B8pbo3k
         T4tMFPBwfpsQil7vePHaFDfgrKwqm/jOTd45bFQWxnSRmqcWpr7cGz60OqfmeuCcfXDC
         Ajsg==
X-Forwarded-Encrypted: i=1; AFNElJ9Z2ABjQxWq48wKEmmL4xOzShnyHTuHSDjOJFRCVQudBqMYtRQZl9LfNa6CyN5GUkCO1iiFfcbAXg==@kvack.org
X-Gm-Message-State: AOJu0YxaiAyxM5tI62yGtFq5ZGotjg0fnOoea24PKysPL6n29upop7eN
	zRkQdsqj5d4gxYAXIicaljeLDTt2K7fS1yJgspopcsLIcBrNqDmx4KJM
X-Gm-Gg: AeBDietIbmnTneKu8Yap0Mb8zEotgBBSQ/aCj1J1trKw/VxhI5MYjN4fr1aesyZIENj
	9vC9QtRxn5GNYzG/GQNu+FB829ZKiZhMQCpNu1/oQjPV/JffGbhhQ/7HCWNzOp6cmlUxewminfo
	2v2Y1MKhxqziLfLXQo8HiaQYM6g365g+S/cqCvSY8A6qaGO4XuEiwKt//r2OAgh8HrjkPYEJLPh
	S9FXXboq3z4+wSkclcQ5FBOmPqsch91iOA3Kzlb4XQlG8oDl9nwTYq0Olv+QQ/2PuHT7ORaoytu
	dYGHNcoEbYKSldRVsssL/hzp7fph/CJcmsajpUpG+kBhDJi00KVcgI3OaHSCqNECnFbjvzNKStf
	IuuBkCvnjYmWtjrlCWu9vnzVPhPBHWIaqirgEkmtVyFXkDrjQttNloMU08PqfUUHFZztZqPs9S9
	Y5JtoUOWzfatfzhdYD0n4tveULMFwKiiYt
X-Received: by 2002:a05:6871:c929:b0:417:49da:7ff8 with SMTP id 586e51a60fabf-423e1160952mr7371472fac.34.1776090600683;
        Mon, 13 Apr 2026 07:30:00 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:4e::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-42403b8f87csm5884888fac.9.2026.04.13.07.29.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 07:30:00 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 0/8 RFC] mm/memcontrol, page_counter: move stock from mem_cgroup to page_counter
Date: Mon, 13 Apr 2026 07:29:58 -0700
Message-ID: <20260413142958.2037913-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <adyZ-t4fiKFv_X5p@tiehlicka>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 4fmq9fopd5foycoutp39xxfyko49fkob
X-Rspamd-Queue-Id: 20366180008
X-Rspam-User: 
X-HE-Tag: 1776090601-438342
X-HE-Meta: U2FsdGVkX19UPZjjhm5fGQ4y2Vkmi3i09PY1ze1NnYUUHfu2gB5Gl1Is/EXg39k7hN020rvVlNSLuoZLnsNzRArAsjG37ewqwLkRZN8t73eJ4p+VECB7ZRRzHDclwM9+dmB+QKolz/jUOoYWyNtWdsVjCw4VDXWxZ2Wmp0Ra7kwJ4RnT1DtZ0VWMp9FrMAD37gmspvzz/5B3JrFvG5WZ/nFBEiONmfWdy0SJTb7wvXE3hwOpWMiqBsiQvSnsL9o28ko3GH8k6HMIlJ/JwBFbAY/A/LeQsD9x8ckb0JfXRJ1UrADbfmNUErCA9plWcEZnsCyIoTFfOiKSLsHn3EsFJ8FJl3NmBZOuOFThLgeRASH6iN/BMIFuSAFtsThlso8uv1VFCLrIiBvBmd+E1GWDBrLNWAML5EDRzYp7uXoX3mXtZaCkGIbzKG4/zVx0KJl5EMmr3+JcFvN67DyoMZIOUsfq4W76s33yG8G2Pkq6Zn+cISrDyO9yFxUn3PjS/hWSFgaFFRMmC+snL8u69U135IRbxXcGxEzpqidLS0rGcEW/gCfuu/MNhlMQtqD22ZgCVwUvSWQAJXnjhZihmedvHH+dHs6y7xGhEBU/ge8Zggi5045REOPDbXA8YFPMH0BuP93Gh+Upf+zeCqt0ZVYzfYUs/09gtMDPS5pmST1pm+GPMXgH2URbnEI4XtV0HrEomowsMmmMLgZVzjqcoYv1gF3r9g+dw3zNV3pJHUxD5XW50OwmDUuuB8cyGnKsL+tpqEMToiqOXdaBgX7DRU8R0Oimz/q+RFMJEpyXUmSQ0d60wKDRdhr6PtJPdQZQIvkqfCdrzjghLUy9StgQ0PoURIK7RrkbskB89GIMNJG7tIBfcmzv/hi7s9Fggspe4Wb4IuD4ZwELCEGw/JCAHiRxFPm4O7ROhiRCP8zYJizz1ugha8y7/atf0tb4jfshCKlyWz3WY7swCp/QotzG9wm
 /wA0LnqT
 VaGeCTTTob0i4GBcKirpxIxta9kyN3XoBPoCpA7PYKA/8DQ/ik5uGuzFCdBRg8uB5fJ7mscCDEYQY9t3giFPc448zJ8kDaV0P5+2evSm7l+Q8ddIBZwiCCbd33sjcmCOWasAjaCgXO74dtjaIXt97ol5QMz4oyEqAoSIP/CSGV5opE6Lvv09NcNJqZ9LHmYQEeGTBCBWVuFNaf3ge7vyg0BvgWNf0qbgzYOKO0n0fPCfKUDoz0yjo5ssHwIxUbJ9c2TSjWp9drNwDHJexLl1K1FWVh+9Gg1RJY3PARhgM4KqN2o6gUHXgohHc/v3ox7L9vc3XTCdJmaOG5a08pMGVBxR6LvZun+X3C9qKNLYuyPx4/8vKXzMLBs0NlNQz9rXNYYqi6EUZwzXx9NpqGGMOvYZyTjtgtAW01+8RhlvV25UVcXX4N3KEd0CBIWfQDHRIIy5OuGnOCAeU+QiEWrRUmxLMMNB9oY7BZ4QYBbKYBpJkvt7pAE+3Cdn5iA2dh6hqSMLHEgXxWVLptN+dD8UKo95yjzs6zJjAxLkD//6iOfs++4T4Tjz+UL7aib1IvXqIBJvCYN6UfVusqaae+UiO+tHJJXi8nOG16iyGkF4UCOeqp1X58j8BpX/5iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 13 Apr 2026 09:23:38 +0200 Michal Hocko <mhocko@suse.com> wrote:

Hello Michal,

Thank you for your review as always!

> On Fri 10-04-26 14:06:54, Joshua Hahn wrote:
> > Memcg currently keeps a "stock" of 64 pages per-cpu to cache pre-charged
> > allocations, allowing small allocations and frees to avoid walking the
> > expensive mem_cgroup hierarchy traversal on each charge. This design
> > introduces a fastpath to charge/uncharge, but has several limitations:
> > 
> > 1. Each CPU can track up to 7 (NR_MEMCG_STOCK) mem_cgroups. When more
> >    than 7 mem_cgroups are actively charging on a single CPU, a random
> >    victim is evicted, and its associated stock is drained, which
> >    triggers unnecessary hierarchy walks.
> > 
> >    Note that previously there used to be a 1-1 mapping between CPU and
> >    memcg stock; it was bumped up to 7 in f735eebe55f8f ("multi-memcg
> >    percpu charge cache") because it was observed that stock would
> >    frequently get flushed and refilled.
> 
> All true but it is quite important to note that this all is bounded to
> nr_online_cpus*NR_MEMCG_STOCK*MEMCG_CHARGE_BATCH. You are proposing to
> increase this to s@NR_MEMCG_STOCK@nr_leaf_cgroups@. In invornments with
> many cpus and and directly charged cgroups this can be considerable
> hidden overcharge. Have you considered that and evaluated potential
> impact?

This is a great point. I would like to note though, that for systems running
less than 7 leaf cgroups (I'm not sure what systems typically look like outside
of Meta, so I cannot say whether this is likely or not!) this change would
be an optimization since we allocate only for the leaf cgroups we need ; -)

But let's do the math for the worst-case scenario:
Because we initialize the stock to be 0 and only refill on a charge / 
uncharge, the worst-case scenario involves a workload that charges
to all CPUs just once, so that it is not enough to benefit from the
cacheing. On a very large system, say 300 CPUs, with 4k pages, that's
300 * 64 * 4kb = 75 mb of overcharging per leaf-cgroup.

This is definitely a serious amount of overcharging. With that said, I
would like to note that this seems like quite a rare scenario; what
would cause a workload to jump across 300 CPUs? For this to be a regression
it also has to be 8+ workloads all jumping around the CPUs and storing
not-to-be-used cache on all of them, and anything below that would still be
an optimization over the current setup.

Also, let's talk about what happens when we do reach the worst-case scenario.
Once we reach the degenerate state where the stock is charged and the workload
has no intention of running on the CPUs with idle cache, we would eventually
reach the failure branch of try_charge_memcg, which drains all stock!

So IMO, I think the issue of overcharging isn't too bad. It's very difficult
to reach the scenario where all CPUs are caching idle stock, and the existing
recovery mechanism in try_charge_memcg puts us right back into the optimal
scenario where none of the CPUs have stock, and we only refill those that
the workload runs on. I'll be sure to add this in the next spin of the series,
since I think it's important to note (the other overhead being the memory
that we have to allocate percpu for each of the stock structs, which is
only 2 words/cpu/memcg (including parents). But still worth noting explicitly!)

Above is the perspective from the system, in terms of memory pressure and
overcharging. From a user interpretability POV, I think there is a gap between
when a workload litters unused charge everywhere, but there is not enough
memory pressure to trigger a drain_all_stock, so a user might be confused
why their workload is using so much memory.

I think this could be a problem. Especially if there is a userspace
load balancer that schedules work based on how much memory the workload is
using. At Meta we use Senpai in userspace to create benevolent memory pressure
that should be enough to reap cold memory (and also idle stock), but I'm
wondering what this will mean for systems that don't have such cold memory
purging mechanisms. I'll think about this a little bit more.

> > 2. Stock management is tightly coupled to struct mem_cgroup, which
> >    makes it difficult to add a new page_counter to struct mem_cgroup
> >    and do its own stock management, since each operation has to be
> >    duplicated.
> 
> Could you expand why this is a problem we need to address?

Yes of course. So to give some context, I realized that stock was a bit
uncomfortable to work with at a memcg granularity when I tried to introduce
a new page counter for toptier memory tracking (in order to enforce strict
limits. I didn't explicitly note this in the cover letter because I thought
that there was a lot of good motivation aside from the specific use case
I was thinking of, so decided to leave it out. What do you think? : -)

I'm not a memcgv1 user so I cannot tell from experience whether this is a
pain point or not, but I also did find it awkward that one stock gated the
charges for two page_counters memsw and memory, which made the slowpath
incur double the hierarchy walks on a single stock failing, instead of keeping
them separate so that it is less likely for both the page hierarchy walks
to happen on a single charge attempt.

> > 3. Each stock slot requires a css reference, as well as a traversal
> >    overhead on every stock operation to check which cpu-memcg we are
> >    trying to consume stock for.
> 
> Why is this a problem?

I don't think this is really that big of a problem, but just something that
I wanted to note as a benefit of these changes. I remember being a bit
confused by the memcg slot scanning & traversal when reading the stock
code, personally I think being able to directly be able to attribute stock
to the page_cache it comes from, as well as not randomly evicting stock
could be helpful.

> Please also be more explicit what kind of workloads are going to benefit
> from this change. The existing caching scheme is simple and ineffective
> but is it worth improving (likely your points 2 and 3 could clarify that)?

I think that the biggest strength for this series is actually not with
performance gains but rather with more interpretable semantics for stock
management and transparent charging in try_charge_memcg.

But to break it down, any systems using less than 7 cgroups will get
reduced memory overhead (from the percpu structs) and comparable performance.
Any systems using more than 7 leaf cgroups will benefit because stock is
no longer randomly evicted and needed to refill.

From my limited benchmark tests, these didn't seem too visible from a
wall time perspective. But I can trace for how often we refill the stock
in the next version, and I hope that it can show more tangible results.

> All that being said, I like the resulting code which is much easier to
> follow. The caching is nicely transparent in the charging path which is
> a plus. My main worry is that caching has caused some confusion in the
> past and this change will amplify that by the scaling the amount of
> cached charge. This needs to be really carefully evaluated.

Thank you for the words of encouragement Michal!!!

On the point of cached charge, I hope that I've explained it above, I'll
think some more about that scenario as well. 

One last thing to note, that is orthogonal to our conversation here. Above,
I assumed 4k pages. But on systems with bigger base page sizes like 64k,
maybe it makes sense to lower the amount of stock that is cached. 
64 * 64kb = 4mb per CPU, maybe this is a bit overkill? ; -)

Thanks a lot for your thoughtful review, it is always appreciated.
I hope you have a great day!
Joshua

