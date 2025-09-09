Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0C94CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 07:31:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F07A98E000C; Tue,  9 Sep 2025 03:30:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB76C8E0001; Tue,  9 Sep 2025 03:30:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA6A08E000C; Tue,  9 Sep 2025 03:30:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C2A408E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 03:30:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6160E13AC30
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 07:30:59 +0000 (UTC)
X-FDA: 83868890238.07.4775B50
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9F23440015
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 07:30:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dR+A8Ocu;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757403057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z3+Kk/XPyaoPFAGQbNe7IovKooJsmlYdWhO37WXBxdc=;
	b=dY0jCE6tKTKeFzKeAhYSpy5mj5cWsYJCFTLLv89Ws2DBtP+uX2gjepm/TD2RZnbAvT1ZNc
	avUez5NXb3Q07IUk39G/aFWZ1XeAct8hnnHdSACp+oZfEIcgTSb/UNgfIotcDMkx0ZpRmy
	nh/aNTawrs9GAZo18gJMREeFntDDCu4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dR+A8Ocu;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757403057; a=rsa-sha256;
	cv=none;
	b=w4fpsHRfo7Oju/7/aTsEwCF/1+QZS1RuOvSE8WJmC0lcS8UyWkg+exZ1ILiFAOQyYSTRnA
	VY3gB5dXsD/alrO5Ek/Ws5S2J0PkOyy3w7lyDdJeYXQJ3MCLatgd8oD7T0+8zIT/HwzqPl
	Otnt1BMFlsFn3oADwTnQsxZxFY/9JOA=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6188b6f7f15so5848693a12.2
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 00:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757403056; x=1758007856; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z3+Kk/XPyaoPFAGQbNe7IovKooJsmlYdWhO37WXBxdc=;
        b=dR+A8Ocu3um6Yds8JGCu7lljxk18c1s1GVOEHlfcJMAiCYUhDbbb6lniqA+x5+xi9t
         Tm6PmqOLSnlkD1JvTxAU2dTyY3Yl9MeXFEcFNgh1KcIXltFRIuik9yrfakya2CVv7050
         sj6gMvju1r0tuhL/0udCr5yRS9vPg9Rys8OCo3yqQDHWuKZ38qFp42GxdETNDW0dVo/s
         Ml/rgPaJbQfCt/adS9klJ65vmchdWqeSDiUDPgUIOFz78E5j4e/KcIjBv2eBIT16v6gx
         cs5lLu7UAk65C3PZJVHMqK4nkOAgNDWYq9DDn8dL6fL34ZOkFYuwSB6rFl1WZszuZE6m
         5vwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757403056; x=1758007856;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z3+Kk/XPyaoPFAGQbNe7IovKooJsmlYdWhO37WXBxdc=;
        b=w7A3/V8SyMYVUzZ6Dr/yrATbQXLmX7T7IM8t/WQudTPNJtFuJLJP11N1/FHLx08b+x
         wJmd5qQneMY4OWC/dDlud0AT/rgdDY6k8Q8RAs27MvAT2fvBbkjJeR1kV3GtUjMT1ymI
         0TJj8A1jpSBZ39wiiS8Sh2rFu/s9994mkJakqqUWljeZWy6qPkhIYLcsTDOEvvYYeAom
         ZmcCRVv+oirwdywAwFUhK+hS0mJNALdVzjPG8tshiNtjhXTg4GFwcwKDDXbqHt8aiepN
         Qd1lf60s4yrTK27vfhYpuiWDLXABxgRELWto+J+kHWAYzaZBSXYdgYVUnh53HYFqJJu7
         wgwA==
X-Forwarded-Encrypted: i=1; AJvYcCWOJtOlDKrZCcXGwk2T5zksdN/Q32zrNILL5yrlxwyCCv2lhU4mVOKm0iUDl3K8r06wHo6Pn1vNrQ==@kvack.org
X-Gm-Message-State: AOJu0Yz2NEsJ7YxiY8frxvtjsz0zP6Gxz8zX/+zNvBGWMpHtONd3X3Y6
	1ZKWz/tUfhMwhGRZOhfyYWkp1vWmde6gIiD8bxqXjoXhe2zlbT0Jstp8j9eHB4Wq9LcmfTWE4W7
	ITnp2rGVvIJ6YIIBRAwSO20fO6AkwDGM=
X-Gm-Gg: ASbGncsXcrrBdX0VBqDZTgfOfNXaD112chu7vwIaAzE17hg3gyFoGy06wgVapC/xJm/
	gBXJMIO8f0PlkHVnEPESIXEekgrnQAb9cngsgCPRKdbTvVIn5gtgg9azL5abljXrIZmX13Sj85q
	p4yg6QKQHFWxiJpColuuVS47TkjmHYuqh3xrfFkMooYn3sokaHWG9uQd0zpoUiriHzLcxQ4gm3a
	ZFXbKOmzt8=
X-Google-Smtp-Source: AGHT+IGjr2QZ8D0kU0BkyVOPs2gj5QrOqZDajV1M594DAyIble/NtY0CSQ0leCeRkPIN8ags32/XQWc6jRZA9F0e5sU=
X-Received: by 2002:a05:6402:2343:b0:61e:ca25:3502 with SMTP id
 4fb4d7f45d1cf-623771096b8mr10416425a12.17.1757403055674; Tue, 09 Sep 2025
 00:30:55 -0700 (PDT)
MIME-Version: 1.0
References: <20250909065349.574894-1-liulei.rjpt@vivo.com>
In-Reply-To: <20250909065349.574894-1-liulei.rjpt@vivo.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 9 Sep 2025 15:30:19 +0800
X-Gm-Features: AS18NWAz3XTJvUfnFn8DaSWQ-_PUj4IEFkaKqEP-Sn1HvdPmymYZeK_WshKPDek
Message-ID: <CAMgjq7Ca6zOozixPot3j5FP_6A8h=DFc7yjHKp2Lg+qu7gNwMA@mail.gmail.com>
Subject: Re: [PATCH v0 0/2] mm: swap: Gather swap entries and batch async release
To: Lei Liu <liulei.rjpt@vivo.com>
Cc: Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
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
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9F23440015
X-Stat-Signature: bi8yjgr79gs6r5ep6sa1uz1esb8d3sng
X-HE-Tag: 1757403057-322096
X-HE-Meta: U2FsdGVkX1+pSanr181Yh4Q5HdhwP78q28hOOsHTBOFLYycA+XBSC1lv21D8SFQ8WcvZEH08TPT03hqYjg6mb2G0cKuGbWc2RABTKlTO+05iNdeAuLt7TTg3fuz/TER5yXpWrU/Ngh+YV5snZXjQD4xiza6Ob14NsgEtWRA1bmACPhZH8gNxoKQI/Yq/kb2tOYlYoWYruHItI5wt9K75efxFpJ6pCoBrq4KjxAFvgikQEsjnvL+yGia5BPauNETVt5F1hVz0rUa8bq8dGZfaR9nsLgL4L9W9lVjwRjxXv8G1JG8LtMCkvU9qMm4EbWPtZfKfV/I2j56BphcDzUt8UOriBkFffvKvEbucqrKg/MSu/VxZDIo9Mb5UcbFkSTiwFyXRGwKnk+tdrJ3bGDgT7NOQPdWRj+5Dt2EbAscV4oyBzqNrOVzzfVaZUcIfRNpjh/o/0OvZV1RCKlFdMBABSfxYdLW84j3eZivGSMkAyQnTOo/mEepVI7dxAvyFm0rwXQrrQ9OUemmk+c8o/gxqR0rI28Cjv7mAjbATX5eC/CPGr2zq07jmbwGZAHwfvWLMZaP98FPQyLQBR78uIq8poBsp65EvC0ekMM6GHzVYvsxxqRQIcT4Ga4N+UGJ9kK5MXNagfeB0G8Vfj13LaCOxjPHofHObo1HEAd9+na8NyQe2UQ9lmqoWDWklv3LKahZAgFHy6m8SfmqYQebMcW356FAjMMlYPWtMLA26WCrEeVSIZWwht9m9y5GDb6l3EePYp9x0kmr8lP+Sc3ogDpp4uOZccdk19fzqOpGqihswHvz7hsUh1sKxTMPJO3GitrQ/H+fL3f5IqqHJdLEGqrM8HwY6cf+UO75BOg6UxthUhT86NC9P6dFnWkjs7uig1HSjUEkDAeLQ6U6t2TjFFKbWeOy0C2MkZpBLD5bviV03vc8NNHT/4bD3t/0TGtLdR92AmrZCt8a52ArMJBmMxsn
 zNy8Xfq6
 4trH/htK37WQ3CLg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 9, 2025 at 3:04=E2=80=AFPM Lei Liu <liulei.rjpt@vivo.com> wrote=
:
>

Hi Lei,

> 1. Problem Scenario
> On systems with ZRAM and swap enabled, simultaneous process exits create
> contention. The primary bottleneck occurs during swap entry release
> operations, causing exiting processes to monopolize CPU resources. This
> leads to scheduling delays for high-priority processes.
>
> 2. Android Use Case
> During camera launch, LMKD terminates background processes to free memory=
.
> Exiting processes compete for CPU cycles, delaying the camera preview
> thread and causing visible stuttering - directly impacting user
> experience.
>
> 3. Root Cause Analysis
> When background applications heavily utilize swap space, process exit
> profiling reveals 55% of time spent in free_swap_and_cache_nr():
>
> Function              Duration (ms)   Percentage
> do_signal               791.813     **********100%
> do_group_exit           791.813     **********100%
> do_exit                 791.813     **********100%
> exit_mm                 577.859        *******73%
> exit_mmap               577.497        *******73%
> zap_pte_range           558.645        *******71%
> free_swap_and_cache_nr  433.381          *****55%
> free_swap_slot          403.568          *****51%

Thanks for sharing this case.

One problem is that now the free_swap_slot function no longer exists
after 0ff67f990bd4. Have you tested the latest kernel? Or what is the
actual overhead here?

Some batch freeing optimizations are introduced. And we have reworked
the whole locking mechanism for swap, so even on a system with 96t the
contention seems barely observable with common workloads.

And another series is further reducing the contention and the overall
overhead (24% faster freeing for phase 1):
https://lore.kernel.org/linux-mm/20250905191357.78298-1-ryncsn@gmail.com/

Will these be helpful for you? I think optimizing the root problem is
better than just deferring the overhead with async workers, which may
increase the overall overhead and complexity.


> swap_entry_free         393.863          *****50%
> swap_range_free         372.602           ****47%
>
> 4. Optimization Approach
> a) For processes exceeding swap entry threshold: aggregate and isolate
> swap entries to enable fast exit
> b) Asynchronously release batched entries when isolation reaches
> configured threshold
>
> 5. Performance Gains (User Scenario: Camera Cold Launch)
> a) 74% reduction in process exit latency (>500ms cases)
> b) ~4% lower peak CPU load during concurrent process exits
> c) ~70MB additional free memory during camera preview initialization
> d) 40% reduction in camera preview stuttering probability
>
> 6. Prior Art & Improvements
> Reference: Zhiguo Jiang's patch
> (https://lore.kernel.org/all/20240805153639.1057-1-justinjiang@vivo.com/)
>
> Key enhancements:
> a) Reimplemented logic moved from mmu_gather.c to swapfile.c for clarity
> b) Async release delegated to workqueue kworkers with configurable
> max_active for NUMA-optimized concurrency
>
> Lei Liu (2):
>   mm: swap: Gather swap entries and batch async release core
>   mm: swap: Forced swap entries release under memory pressure
>
>  include/linux/oom.h           |  23 ++++++
>  include/linux/swapfile.h      |   2 +
>  include/linux/vm_event_item.h |   1 +
>  kernel/exit.c                 |   2 +
>  mm/memcontrol.c               |   6 --
>  mm/memory.c                   |   4 +-
>  mm/page_alloc.c               |   4 +
>  mm/swapfile.c                 | 134 ++++++++++++++++++++++++++++++++++
>  mm/vmstat.c                   |   1 +
>  9 files changed, 170 insertions(+), 7 deletions(-)
>
> --
> 2.34.1
>
>

