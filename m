Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABB3F606A330
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 09:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=E3oQFIU2
Received: by kanga.kvack.org (Postfix)
	id CFAF46B05B4; Tue,  3 Nov 2026 04:32:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA3C86B05B5; Tue,  3 Nov 2026 04:32:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B925D6B05B6; Tue,  3 Nov 2026 04:32:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F84B6B05B4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 04:32:54 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 351F78034A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:32:54 +0000 (UTC)
X-FDA: 85393293468.28.761F18E
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4117580004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:32:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=E3oQFIU2;
	spf=pass (imf02.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793698372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8N0vEDOHENh5TCI6g+MQ642/w77B6Opk/aAqQYUAijY=;
	b=FDw2hMQj0EnUKViYivcyHMv/Bwag3E5cYBL6y4dqQwC7reoNQOc8wXX+Nshc0DWxcIrmwd
	kKCdFD+X23dsSXl5h1qI/Go5IFo3g3ld3uQ1AusDbqS0jY4AgnoXs7A6g55vEtpeSMLkSK
	fsbdvf6X1MvwQGWJMu0TLAxINg07pJY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793698372;
	b=zef23uTJtyZCyNFJoAl09ZVVNgEf0LVRIT8fW6sDpkRrf6slgRW6u5cMfnbk3No+lyV1PM
	NU1MHCaip1C8KWksRu2atWOJn0IhXDaTK5O1YVhP9eDI3EBfljouzKIUhTJqY+SrThJhFh
	t5h+Hd2SdPyrBnn87E1jO4cUG4mOYt8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=E3oQFIU2;
	spf=pass (imf02.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48df54150dfso1920795f8f.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 01:32:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793698371; x=1794303171; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8N0vEDOHENh5TCI6g+MQ642/w77B6Opk/aAqQYUAijY=;
        b=E3oQFIU2Bdx3u8Q//xiIZzHr3QdhPrS5V0WM9DRKxKNKTCZirim/lp1QsDMxvQOUNB
         TW9xyda7kY5H3Vrn/rXlILdhiUfwArzoqoLRYHLkG6YHsYabIPN2goHkPHvAuhuMT5/h
         yTRwWrYUIozMeRD+E8UgOTdhpwMOwYTxfFnuRrj7EDoRwpMfVzt0yLfKlEipXFiGxPmN
         Pw3NPQqvg6kMQOQm/nNyDqDo2YsK4xS3BNWCvhHlcHaTpniD1jZnSedOlGT3jhMKAYFd
         uj0fvjSTois/xt6xsx3GpvSOfRQBW7eknHSUCqbfcPWYNnA5uDJ3IL4io8ciS/bleR76
         5hvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793698371; x=1794303171;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8N0vEDOHENh5TCI6g+MQ642/w77B6Opk/aAqQYUAijY=;
        b=aU8VfpiV3MzQlEtZ1onRZwAhfyun9jq1Y8VCGSVw/usFIx8cSNWxlQxmSU/kIcOo89
         j42KodtDov/qYJbzQKonCgFKwmx3Vz4MaQ6K6fYRfn4F8wtUrGanlVPJ+h8X8/DUYSTj
         57wILBl5AaZ0wDy5ndMl5XQvdXlYU5dM5S6YJh3bXR1eowHCm5wmEVMatBoobeyjZO/v
         /aBJkiXuPq3GZ0L7GceFNjNY55bQUEtKQuUM+I+60S7uY7EFt6MMbGyTUcZcLlKpf+C1
         4oXeJc15/+pgtapk2g9ThJHG2F8j4F2EKFO4WvVzO68VZ24RwWnRBbevRvUt7P1U72i5
         HcOA==
X-Forwarded-Encrypted: i=1; AKwUvBwwM0HR//AhSpzbD3xVQ8LDC1M5iLPXxpNtEG4cJ1oaqrhPzV6fX8KPim16fi0+SZSEawnfKyy4EA==@kvack.org
X-Gm-Message-State: APuU4Z9saKW8dfbxGdoKMzIwcembU1gNbk2yr+K274+j/zrYmTA8IRsJ
	tCYon8CutgrRTC7J0paoFRrstKYKEdWkVju5I3PCV3XGsMtxg50Ycvv8ICo7edfKArw=
X-Gm-Gg: AYBFou2pHOhQBPGScorj4zvzJNvuCPZAeIZjVvEf8VXmrV55WfMkFJcVKLM5VZom77A
	2KpIt9xxJ4AFMHEvzg+CNnWvNre+ypnWVix9tX/cuAbp4oQmrCwvk6nYza0cLORYUQPH+DMPI+5
	8xZPvzF1aFnB8W6azzvyMbc4S9nCK2u4XAnHY+5TGCMHagtIqhWP9xCNRL66u3T7D2Df9ezVjP0
	0WoEAM9axgh/zFxVMe8Brg3mwt2hFhjxM8RlWd7yJ5ERRQtfzZ1f43o7IwW/l1cmClz3jm8yt9y
	FhNEAWNPioJku2LCjQ2zKBGm5+OIeZ8wam8k08iL8kxBL89AULcpX0Bqy8Ay/1dnd8uGxNFPVaA
	4jWSTwnfcufe0bSNKIXVEyPmODDkOxb/nESuY09ESgzUc4W78l749lufDc3bw8hA2XOIYjlFhk6
	nj1tlqJZsvou67fmBZMl703axG8aTLXVbsR3lXQ0CSW+gdEm6OJwQJs0IbtnlTlycj62/e9jJu0
	9R5aEfurgm7IbHwFdRc9+GkiPvRHZJvGjJDwgCEWOl04JIo5z42MCAeBMcTw1/tJJtOhV9Uxo27
	qeC7cORezW+T32+t5fsSqBPi027o/aofi1rKTlA=
X-Received: by 2002:a05:6000:2088:b0:48d:f6d2:9c88 with SMTP id ffacd0b85a97d-48e6e4f8daamr29004855f8f.47.1793698370857;
        Tue, 03 Nov 2026 01:32:50 -0800 (PST)
Received: from localhost (109-81-32-81.rct.o2.cz. [109.81.32.81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e86a06078sm7960579f8f.54.2026.11.03.01.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 01:32:50 -0800 (PST)
Date: Tue, 3 Nov 2026 10:32:49 +0100
From: Michal Hocko <mhocko@suse.com>
To: Matthew Ruffell <matthew.ruffell@canonical.com>
Cc: Waiman Long <longman@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Caron Wills <caron.wills@pulsar.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: Re: [PATCH 0/6] mm, sched, cgroup: LRU Cache never drains when
 isolcpus are used with spinning SCHED_FIFO tasks causing page migration
 stalls
Message-ID: <aumqQX7tKHLKRQ2k@tiehlicka>
References: <20261103075940.110308-1-matthew.ruffell@canonical.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103075940.110308-1-matthew.ruffell@canonical.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: wna7sfhenjobxskzhhhs9xmc95e3gzrs
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 4117580004
X-Rspam-User: 
X-HE-Tag: 1793698372-559659
X-HE-Meta: U2FsdGVkX1+CMins3dsWmQzo9iXAHe71c++lWaONyXD6QR27SxL1ZeH4HODHJfBzHGRg/EpzUKF1AAb5yaAeqvhizh1HaMta0ESH3iKK0SZ7HF7IB7HhFf0BkNglGW9MpLhgsMW2zFZmP3dy38kr9OgGIuOFB9hZtLAlbRP3oPHoOjOy67XKFLDsW4MtdqTJTic3MrJhLkxRWjey09VgEOlmzcN7hUg4pzJ8FGBxwZw2lWFuO4nMTYiHU1kNnFxfeAkx1IgN3N0qolG6DG5jhhYh+6CegdCmgaEG/RuQIGr82rFLW903P+SMO+pvSQC4spwq7u0/R7/mry+Dtx3bv1oySr3PjM8IIggLOnimybuEheFtLpvJ7iASFi5XHWy/1UNTMThTayVUlm4Xn11tmneNiFVz92xeKoYOanWjFef2oMhVo99VJ2JZ8bBNOERp+X4oaqz0cWAUqBDluIsVxnpBhFRvd6bvsH1jlH/+oKYnkdMMEOAPvxcez/obfvyG4NtxadFd0h5pLyoX/ZMAQWLY8CvqdMbfJazLZTQa77tAmQB5NhrZHuX46IjzBFfh5DMwBNYDFifjLooC+IBj0g7y5UVCnQwywrIEZOgFKr46ysSWyDUzXtqNay3+Da5R8q2RwlF5atln4EwBxu6KJBqKlHkhJT/luXGJaFVY5OOq/udkuiUNjEPAN0dkMYqSZ9dXOf9qJJz64BfGYpNU+g6bHnzEtZsBCy3C8YftcG4xGkXT6vAvtltuPD+Sxb76K5haP7wkkKUvnhCCvcI+Dm68kt0p49e2DgRXZMw5//hhF7zpqfTuswaBMZQpDF0DL1bDTuIocBOdAyKMXL0M5gTmc5vuD3U55XFuUSTlLSs0UNCv2abWMjmR+9T9uaDz5gObQL2Tv2K8rgNbmkKMgwn02xECy7FnvXmxw0NHOdNx78vabCxOMsj0S62TX1Qsm95v+BqQGkBgqz3mPmX
 5w8AeIWN
 Ww5jDfhFpmeo8GiSr/PmhbfqDhqMSwvbuV8yDK+nbuE9e8bq22sNIWZ2vaMuEMNUr94esBJbsVUPuS4OvQY8NxUAkzE+wX9fy1Vug7K2Noa0ouRurE8XsFcuar4on1wpWETQ+CR+CiIyK78b9egxPSCCzxhSAMsbRcFKQjV7u343b9eg2QvS/boVgrDbPfW70YKYC6rZ0cZGdi9IWBX3hKTIU86Xi/KM6kg/Nt2H2FKIn+sihrZF3nxM1IMBSOgeDYsqivEyNfEUz26s2PBZFcX440IDUO7aOtiP9b24Hvd20OTCAKTKCjuKJiAPxRm+86gHIgVJNnCeJDD7hIWoZPn0PU7OiS03fYegM3VyJJgDGFG0/Vemkv0wemxwNYofMFVG91ifUoCVDsp61TNRxzV0GTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue 03-11-26 20:59:34, Matthew Ruffell wrote:
> What happens is that the spinning SCHED_FIFO processes running on isolcpus are
> constantly dirtying the LRU cache, and when we attempt NUMA migration of the
> 50GB of pages, systemd calls flush_migrate_mm_task_workfn() which creates a
> kworker that calls cpuset_migrate_mm_workfn() then do_migrate_pages() then 
> lru_cache_disable(), and then __lru_add_drain_all(). __lru_add_drain_all() then
> creates a kworker on each CPU to drain the LRU cache, and systemd and the
> initial kworker wait until this is done on all CPUs.
> 
> Since the isolcpus are running SCHED_FIFO tasks, they never get preempted,
> and kworkers never get a chance to run until they get an opportunity to by
> returning from a syscall, and it takes a very long time before all 192 CPUs
> actually drain their LRU cache before the page migration can continue.

The idea is that they are running on isolated cpus should they shouldn't
be preempted by unrelated work. But at the same time those
isolated/cached pages shouldn't be blocking the rest of the system. IIRC
there was a proposal to flush all pages cached on pcp on return to the
userspace. What has happened with that work? I do not think this has
been merged. This should deal with the underlying problem without
introducing lock contention that might be a result dopped caching.
-- 
Michal Hocko
SUSE Labs

