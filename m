Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2208FCA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:24:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EFD06B0027; Tue,  9 Sep 2025 05:24:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79FCA8E000D; Tue,  9 Sep 2025 05:24:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68E058E0001; Tue,  9 Sep 2025 05:24:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 516446B0027
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:24:41 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EF71C1A045E
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:24:40 +0000 (UTC)
X-FDA: 83869176720.04.AC5D3B9
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1961AC000B
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:24:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="EIa3eo/y";
	spf=pass (imf28.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757409879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lW2Nzzo2BQ2Und6tq1pi4NPh0bbGS+k2agz2uQ6CIcU=;
	b=5i/oVD2B7zolsrxnF7rmtygsDMqlFxteFee2ggwoeb6E8oh0IMRt1Vqh/vwNmLtkDn0UX0
	a3tHcTAfnXoXvMu57/OnCotfz8mWSahFrsAYKilGPjKHQ6yynTdPjb/NyCO9+ib0Z0FE4d
	fBLGHfP7HqXSCfypxaQasTY7gjzZno4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="EIa3eo/y";
	spf=pass (imf28.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757409879; a=rsa-sha256;
	cv=none;
	b=m66DxPh0nSnzet4E1QJzyfc36cH1vLhblnZ1SmsASzxD84uzzic0bLlpHhM+xbD5+xSc8t
	aQaJQHGpK5+DTe/sEaDKmfDzK/of2n2Ka3r1+KHx7h/lfh6kbNNJ8TPWTQZwUU+uNLwkG1
	iWd55XDUiVbAOWYWyCQa4PUu24fk68k=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-7f04816589bso573450485a.3
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 02:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757409878; x=1758014678; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lW2Nzzo2BQ2Und6tq1pi4NPh0bbGS+k2agz2uQ6CIcU=;
        b=EIa3eo/yysq+B2NnI30AKe/HFhzH7sLJUyN/ZF2XXtqr5aRb4++WcC8grj4pLONL8h
         WIelpHEGMKfgWYbhLJ5I9pgNRqUaPR5au6nRwNxzZxjt8KP3AEplCSs42AEv97I6MBu2
         v17rGunJCLRX6S1zsW5X/267HNw7AJv/W/xYMK9AzasU7IitG6HgQ8xKIDQOoJACsnNu
         wUp/ssS12ZG3ikrPPN2oKduDtqF0rGO4wAMW5ccn1IKeSVgvv8n51U4bnB3mRCQ/N4HV
         A1+fU+zltgcGKEAPjIRK81e7l3Hgp6kjsodrC7sAzQsQ4nFCV/T8BSHd9HgL9IAGUC2G
         sGNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757409878; x=1758014678;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lW2Nzzo2BQ2Und6tq1pi4NPh0bbGS+k2agz2uQ6CIcU=;
        b=BBKMv5A9E3LNb7q8eZTmIwsF7lWPA12+yW6hodraehaAEScBSJ55N3rcxbo0xrQWW7
         S75op8KaVB0/Frq7hlVC9n+OVeVFnIT74ZGUsKs9dQk1zqTUdUgdSZ01mNKZnOuBtkhF
         tbIDdn1WxLWYuEPsbCyrnHLGNyjydZBmnvo09rb2zClCqdVGQF5SaIZXEgYQKsxVEKHn
         8uuJENJncIBzQKgJuP+y6QOQerSxw8kyPWxSNv+RvMzydmVzN+aqvsCFPIuOGaqyNvYG
         trTip0LH4Q1zme1tewZnd+kFRBg+VTmV0oo3GsLSaSqOFYHs0/2D3PWvqlvfH+4Cjvcw
         4ABw==
X-Forwarded-Encrypted: i=1; AJvYcCVVxk7cXP9FqDrVPtCJfWaBiX4inmYG7vRb/CfDohW8LP9BiU9i8/fHD5ysIHkw9sVI6yM4XgsuNw==@kvack.org
X-Gm-Message-State: AOJu0Yw7NmUmZ8eGclhAKjw4QiOY9XY3kwGqwiPzi/OTa+0fiLLqI9Fp
	tCGD7vpC3BEikeRD6+ixvyO7yjNPmE6vW+U0km8hDeYSsaRc1XbY2nO79SOW0kUm3hVOQHz6Y7L
	sP3WEyePjg+dzjsYscpx/8xh9Wk7Knqo=
X-Gm-Gg: ASbGncvs0hCY4BtDO96H/W3eJkGWwEX2sQBzsmtfJ9QYeed9XivQ+aThIb4Z5QkYZ6/
	5EQYmpnhrSdQwdpjSfOEEsxU9Ejy/iTeHewT8AQymJhiO6gBie7PNOsMXHHTExyigPzqbusscWT
	brxZC+JYbnigf4rMC+OFW4qGXg24KEC7vld2QfNphUEbtYnEtbFR0jPcQcwNowLqMwl7Wq3Ps6Y
	aH4G5kMWClZDIMcbQ==
X-Google-Smtp-Source: AGHT+IHJOggxKeQl2En2vkS170HN9upj3XN1GrIbX/RBrm3+a8OJxKgKoilHkjOVfWI0HrL/ttqp+LzQfAyxcN8ccUo=
X-Received: by 2002:a05:620a:172a:b0:7f9:ec3f:b047 with SMTP id
 af79cd13be357-813be24adf8mr1052891485a.2.1757409878127; Tue, 09 Sep 2025
 02:24:38 -0700 (PDT)
MIME-Version: 1.0
References: <20250909065349.574894-1-liulei.rjpt@vivo.com> <CAMgjq7Ca6zOozixPot3j5FP_6A8h=DFc7yjHKp2Lg+qu7gNwMA@mail.gmail.com>
In-Reply-To: <CAMgjq7Ca6zOozixPot3j5FP_6A8h=DFc7yjHKp2Lg+qu7gNwMA@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 9 Sep 2025 17:24:26 +0800
X-Gm-Features: Ac12FXzBjrEDwqilLgwY9xCBO5DS-3GJmCy35oFzG2rRHCjrrELhZ_Lm3diPEjA
Message-ID: <CAGsJ_4xiTteQECtUNBo+eC9uu8R3CgVT2rpvGCGdFqc3psSnWQ@mail.gmail.com>
Subject: Re: [PATCH v0 0/2] mm: swap: Gather swap entries and batch async release
To: Kairui Song <ryncsn@gmail.com>
Cc: Lei Liu <liulei.rjpt@vivo.com>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, Chen Yu <yu.c.chen@intel.com>, 
	Hao Jia <jiahao1@lixiang.com>, "Kirill A. Shutemov" <kas@kernel.org>, 
	Usama Arif <usamaarif642@gmail.com>, Oleg Nesterov <oleg@redhat.com>, 
	Christian Brauner <brauner@kernel.org>, Mateusz Guzik <mjguzik@gmail.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Andrii Nakryiko <andrii@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Fushuai Wang <wangfushuai@baidu.com>, 
	"open list:MEMORY MANAGEMENT - OOM KILLER" <linux-mm@kvack.org>, open list <linux-kernel@vger.kernel.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1961AC000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 6pmykjynxxaimmsyc9zhy9kd1knfu4ic
X-HE-Tag: 1757409878-154783
X-HE-Meta: U2FsdGVkX19NBrmj/cJnfYnXZ/KkC+VVCZNnW6S70pDnN6d4tEOs3O+EFgT8YxnJcsxDl6ofM2XhsZv70gmJ1b+H3BeJwkfCHo2/dGAVNmst7jV+5E2aAfs2sMK8dHVPv6pzFR2BmE9DLYt5HIAb/SSYNZYhcaZv74yhELb95VL9Y/LixcGvs7UKJ8Wn8KZndg7KBEuc4zAVWGK3puB/S9Ae+DQrmKbmT4tW/E4JNGiP700D9PLcD1FmsniP7Waolw3SGSsc+T9L0GuV6APgoqfdGZZQJBnOAoeab8e0GefBk3wbBapGA9086XFru1+Tv5cNWUf7iZu7f9ZvvOlQY+e+Ek5/yzB2N2InSIYevrkim27LGJ3VokTfISaiwcBswn+r60dRX8gW21p2rrubvBz/99cImexXkUF/nUyck8RqKV9j/XOGHN0IWOdnwmYfbzqEvZofuTmMtVfdzSLPqwkM63JyWkBCxIgPYKEpp6lG7vbCkh1pVOBlTXyzdHrC5/OX29iWJVS9/68JMRB7uGKi/bV0fQfZxuNCy9YUIa4HSl7VLdfKpqnD4ZK01MUdf1MMQaGItgs9Bke8pnomjgt0mg9cgLm+3DgzuLukjk55OUi742Iqy93Ot6n8vk4JRqbYE61TGNiRBCKgwZkJSsIizwEiXbdUiQPf8mHl8ayIqV/+zQVyZQoTTkSaOhv26lqmgSZIVOtsF3sVWrD0h2N3nEbEpEe2k0q8UzKOjY7H7/Wrof3FBsEKInbOvjr+hKLbwV/GbbQ8lYElWY785HOwLRl8kMamgpVdauUS6vIScL5STIBdOGfbOd3jYhIDoQMTExyrW7d8C0xsVYjndzHQEILJxbRqUx0g7ltdaS0BdmhFoOm6qx+M9hja+5Fv65UMCVgsDna09FKB1BxGWYIbox7u0Nt0SW/KhuNZOxfDuMCFZo/2ypUf0sE/zknIIPSxSK5Jme2mk2yGWoF
 KrQUl69k
 vsuCVRcCJmY+3yzJ/svvwbxIVLe3+WUJLQGkG0nrLsNdCp6lia6nPjC4X+UvUpCJvdaxlHYemhx1qMDeZItPLLiwevrPsoFqO9iQ5p4Hy4pSJrlxQtG0JxVXM7MzW626flBNz3N4iIdKrHXlWyzEYGgdtB+CWnvl9mzaiDN0ww1CGTC2v0BaUi1s+M7Kz/RNwPp/qPdwA3rR99ZVlwhJXi8nxVIBCgbSHjZLBOyFQDpFClSokSWqnXUtmj30hXxtKScGpTEkf3ugRT9B6wbJP949e4cFDVQrbTjzYXNnOlgNmcN2RRK7iFE1dBqwYuZc1Yh92kXwAk7eUUpDIsxpQpZYt5xdrc87emxNgiE4AUFdlBcceicGg8qn3vxyt9AQlAFqp/h4Ypks9n8s9s+YGsJs4xTCUllP8XMhwiBpMdy+W5Io=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 9, 2025 at 3:30=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrote=
:
>
> On Tue, Sep 9, 2025 at 3:04=E2=80=AFPM Lei Liu <liulei.rjpt@vivo.com> wro=
te:
> >
>
> Hi Lei,
>
> > 1. Problem Scenario
> > On systems with ZRAM and swap enabled, simultaneous process exits creat=
e
> > contention. The primary bottleneck occurs during swap entry release
> > operations, causing exiting processes to monopolize CPU resources. This
> > leads to scheduling delays for high-priority processes.
> >
> > 2. Android Use Case
> > During camera launch, LMKD terminates background processes to free memo=
ry.
> > Exiting processes compete for CPU cycles, delaying the camera preview
> > thread and causing visible stuttering - directly impacting user
> > experience.
> >
> > 3. Root Cause Analysis
> > When background applications heavily utilize swap space, process exit
> > profiling reveals 55% of time spent in free_swap_and_cache_nr():
> >
> > Function              Duration (ms)   Percentage
> > do_signal               791.813     **********100%
> > do_group_exit           791.813     **********100%
> > do_exit                 791.813     **********100%
> > exit_mm                 577.859        *******73%
> > exit_mmap               577.497        *******73%
> > zap_pte_range           558.645        *******71%
> > free_swap_and_cache_nr  433.381          *****55%
> > free_swap_slot          403.568          *****51%
>
> Thanks for sharing this case.
>
> One problem is that now the free_swap_slot function no longer exists
> after 0ff67f990bd4. Have you tested the latest kernel? Or what is the
> actual overhead here?
>
> Some batch freeing optimizations are introduced. And we have reworked
> the whole locking mechanism for swap, so even on a system with 96t the
> contention seems barely observable with common workloads.
>
> And another series is further reducing the contention and the overall
> overhead (24% faster freeing for phase 1):
> https://lore.kernel.org/linux-mm/20250905191357.78298-1-ryncsn@gmail.com/
>
> Will these be helpful for you? I think optimizing the root problem is
> better than just deferring the overhead with async workers, which may
> increase the overall overhead and complexity.
>

I feel the cover letter does not clearly describe where the bottleneck
occurs or where the performance gains originate. To be honest, even
the versions submitted last year did not present the bottleneck clearly.

For example, is this due to lock contention (in which case we would
need performance data to see how much CPU time is spent waiting for
locks), or simply because we can simultaneously zap present and
non-present PTEs?

Thanks
Barry

