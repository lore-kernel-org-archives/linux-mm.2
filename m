Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E343FED3F2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 19:52:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74A416B00A1; Fri, 24 Apr 2026 15:52:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D3EE6B00A2; Fri, 24 Apr 2026 15:52:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 574926B00A8; Fri, 24 Apr 2026 15:52:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3FEA26B00A1
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:52:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D6A48160313
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:52:10 +0000 (UTC)
X-FDA: 84694495620.03.95DA12C
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf09.hostedemail.com (Postfix) with ESMTP id D186F140010
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:52:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Lf6tkG1g;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777060328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wE/7ErAGo72joNqsxPMrNEQEyJ7t+edUI6j7ULKzBaM=;
	b=Ar9D/tB2ZEC/+w3agKcgjbAKhKRK3yhr/VmPvQ2dt4wZje2X+5QGWBDXhE4WcmTu7lTVon
	imHvGtDTBmpoYFckb9QXu8hKKcyS7zS6miL04eKPSDvSZzSeZKI6CjbGD0sGqa1epzaXT4
	sYUpoEA0KpHNRMapuVLmLcknlf3xB2M=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Lf6tkG1g;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777060329; a=rsa-sha256;
	cv=pass;
	b=l+3bh4QgXG5Jj0n6vWt+sGR/CYYxqmFPXm7BtQgiVLU/vAd1K3W8mARIwf7BtiQuM5keHP
	LE0FqqhkfL3mYp8T4uqWfKErah7Zpgr5C88KPyVCaN7wJd2v3gBodqhedJfnd6+0bIhgvM
	pvDsfbbfSQ9Zpr386m1kYBSjTbBe30s=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6729c6f0ca7so9771560a12.0
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:52:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777060327; cv=none;
        d=google.com; s=arc-20240605;
        b=SUDDM0cdIVsEfVl0BJMhZImIwju0xzMeTL8l+m5X24lURIlJ0J4HPYWpGuqrxTf5h3
         pG1IzB1zDURKP2IcA8mz86/1rT4Fo8WnqGGll+cyfJEp6wg64o9ckBRkGwJnXXYjj3ku
         8u5SfZJYcI3XD47bTv5FnAwH6LIYlmgyW5wUF5ytfl/Wh/EsTNg7MPiHqVOPI8Azeu8J
         T3jysWf+SkcoBAlwFoY7EKW73r4wrNCTj2fh9wCdtzLMyAl6sFLyNjQ/7EFjS6PwNyg3
         mgQ/tRbx2jBJL8y8ioss8veVmOfRS7OYWocxg8SFpcoHScYfqc7gCapB/LtxjaewlLh3
         Buqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wE/7ErAGo72joNqsxPMrNEQEyJ7t+edUI6j7ULKzBaM=;
        fh=eNVlJFZyLGjZe0f/Lo1dJ85OdkEHtL67xOqo4LEZD6Y=;
        b=TPTJQe9xrYaxyKHEm2+jH9d3Z29iJ/Si2Q7nkYKCW4kRMhyWJ+FDYBa0ueH/awm07Y
         HKAHqJy17ZGqQ7QvkLEcutFxqpwif9ysShHJWPx6iKLpYql7c0EhoKlKvkFLWUoopFJO
         kEzB0maeZoXeMvLOvUpKyn4oUWgJQZg03S9XxkaoAHw3alNuwsy0+z+3BCDHEhg++kts
         C0Rd1AH+lODCWsoHGiqzs4AUU5uxpN3kf+t1hQfxZ/pPrpiKg6J5EhQhTIw6au+uXT0I
         stcA14s5mBEDfHZxiNCD86julCTb0wEQqU+lP1IZ3leDFei4P8ALpsIIBPaY6deas55Y
         seRA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777060327; x=1777665127; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wE/7ErAGo72joNqsxPMrNEQEyJ7t+edUI6j7ULKzBaM=;
        b=Lf6tkG1gfKOF8mJHtVrRPHn8jc8VZe6vbGfxY7XRktRK7HjUW4gFjCnGw6pCnaYUbF
         EFVTXmRAiPusKhOMPgX7hTBMqVWl1Q9cSHxi+THzES5MpEhOOtn2++C/zp5lQgG11WTp
         vVyWiJaFrgAKJqfuNpNJA3+zkL5Y88coqGQE51S12Skmn7wMZWfep5o+5oJm61PLmjly
         E/clH/iqFay4/B9wC36Zdg9jDg7uSGZFMs7v6kdw8kZ/m5jG62PNI/kCi+WMSir6YOQg
         qk1M88jpeFMoDeO0bhomFfDnVjdvW1jcLblUrz1mpOGEgupNND4BuJd0Bw6LFak/UTY5
         VAlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777060327; x=1777665127;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wE/7ErAGo72joNqsxPMrNEQEyJ7t+edUI6j7ULKzBaM=;
        b=U1X8FhhNZQJ7pZmCmRtqLIhXFJmcLDS5OteiNI1MFxKh68Cxas8oGVLsyNgD3QxJ7u
         Wtw/Z+0+x/DbfehtY4xglVMUq1xv+RFURlCC555FGdU1zXpukyKPZm3xERIZYsYXiL8Q
         QJQvoO/ZxRXX4BOsQdg4MdJ40wiHWAFJcHiokw0v8Q6ZYiJRF3wAiXsAC+5GJtwzQitb
         4AyVLDLyWC19n5X2NqDsa52WFEcMpmSDrDHnYaUh80duC4uQ05aNaD4J6FGgWWTdE0nh
         1ZbRlrZIjOL1U5FRl3ZehBDLEGZmSlFfb1cgZnW3EpYV3H1ygNj5+TfHAp7b02GgXNeE
         PuPQ==
X-Forwarded-Encrypted: i=1; AFNElJ+UysKawumPOCoOlYHDGaBsbKSYh1eGUs6mW7I8Q8TOO8+sF5UvwDW3ZNFA6PvgjkhJZRhMsQw+wQ==@kvack.org
X-Gm-Message-State: AOJu0YybWJsHMLlSEdohOqI/cZpkAf24rnoyBtyvm03nu5qTj6Fw1Z5n
	4zbtorh7vAMKASbK9WD/8GMeBrfTxYimNn9cwMfG8f48eFHskAf8WkOEkSLIbSp/Gp9rsHaonhT
	m9JWusOrjJIhVODnXP7LCQc03k2OecmM=
X-Gm-Gg: AeBDiet+T3BXocQOm1J1LoYQnsngBvN+oI7i08cA1QAyL/DS2C9RugvS74E49Lj3zIA
	rtDD/EuwNaMU3oQhCRYUjGhv5tJvxD9x8ALBV+KjZrnw3MWI+0JNkolDuVvnMdE2idBnIjFbfk+
	Mov4F1F9OHoNwakG06LqyWfUPGMOIc9vlx0TgB8vnD6OZyQx8khVTrE0/k7Ah4WJgOxKEMnrlA8
	sh7UFg0MpXcMzl1CkGnf5Z17cbE7/szPEpfD6CbyLEk3YVYDHBm6mmTYDkh8tMth7OR4nMwQGVR
	FcwYU99xvEQUmdSmLrxrlnNQNKbBzrx3IBByMRvtRMfQ8WQ8n2o=
X-Received: by 2002:a05:6402:24a2:b0:670:8d90:e861 with SMTP id
 4fb4d7f45d1cf-672bfd82177mr15503860a12.6.1777060326795; Fri, 24 Apr 2026
 12:52:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260320192735.748051-1-nphamcs@gmail.com> <aegUoOiUbjUAH5aT@google.com>
 <CAMgjq7C53WRS5oYxO157mX7JxhfoPoi34k+taiKLrMah-b-iRg@mail.gmail.com>
 <aektdlD4npMVThu3@google.com> <CAMgjq7DRrz4Hdy-s4y-C=3BmPt50LKOfdWjjf2mWmCybdRaJ4w@mail.gmail.com>
 <CAO9r8zPvApgxKiVy5NhiWup_m57huF3MTuPvo=iq5kAxjRZC8Q@mail.gmail.com>
 <CAMgjq7AGzBubCkmv7LubBjPLN1DzL472d4zUm+sGxo8ZptMgRw@mail.gmail.com>
 <CAO9r8zO+tm2J0FRC64VKCYOSuKPXX8cQG7C07SwMWKoLiwoV+w@mail.gmail.com>
 <CAMgjq7D1WXUHqAV1yuXvrUmEsE_m_+yx0mBq6teJhipx6mySbA@mail.gmail.com> <CAO9r8zMk7xTi-Txmj1+Z9=250fD8HuMQFyT1iwjTW9coLXgqoA@mail.gmail.com>
In-Reply-To: <CAO9r8zMk7xTi-Txmj1+Z9=250fD8HuMQFyT1iwjTW9coLXgqoA@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 25 Apr 2026 03:51:29 +0800
X-Gm-Features: AQROBzCsso3pTVLRZNMTqiOUBfD8dT5yym5C4wDmzSyyd7Bc0ZTx2dDcUA3zHto
Message-ID: <CAMgjq7A4+Sac9-CYkig1LFfEh5rq-4vLka8AXREei_m3svzJ7w@mail.gmail.com>
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
To: Yosry Ahmed <yosry@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	akpm@linux-foundation.org, Alistair Popple <apopple@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Barry Song <baohua@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Baoquan He <bhe@redhat.com>, 
	Byungchul Park <byungchul@sk.com>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@kernel.org>, 
	Dev Jain <dev.jain@arm.com>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Lance Yang <lance.yang@linux.dev>, lenb@kernel.org, 
	linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, "open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Matthew Brost <matthew.brost@intel.com>, 
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, 
	Mariano Pache <npache@redhat.com>, Pavel Machek <pavel@kernel.org>, Peter Xu <peterx@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Pedro Falcato <pfalcato@suse.de>, 
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>, Rakie Kim <rakie.kim@sk.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Suren Baghdasaryan <surenb@google.com>, tglx@kernel.org, 
	Vlastimil Babka <vbabka@suse.cz>, Wei Xu <weixugc@google.com>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Yuanchu Xie <yuanchu@google.com>, Qi Zheng <zhengqi.arch@bytedance.com>, Zi Yan <ziy@nvidia.com>, 
	Meta kernel team <kernel-team@meta.com>, Rik van Riel <riel@surriel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: mhst6st15rc1w8mumcdj58d87wq65pjk
X-Rspamd-Queue-Id: D186F140010
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777060328-916653
X-HE-Meta: U2FsdGVkX18PHAPydteTPcviZSUw3R1T4JGZlJk/ruFBedp0U8sqcSyo98KQq73/USpLMaBCMMlLh4pCDJHTHTiXIpZc17S0jFFeHmX7cv3oNN6n9sOJwMv4PjH0xJGu4iR/f63k0ZbNrsAiuazOnrjMyIcwGa5iupTt4T3qM7YooWLMeu4NZ9pFwB6LURiCDVWbOUoHd/BI3rjxs67/7a1fUTqrsUUCEQ2mbamZk1s5MuAbaDdxk1/my3N7mXywk8SDzlbLHooZAuLicvSiqVuOVRzXF4Y4cOLgy9FPifpacN+YaSrAcfpz1ETbqC2+ke5hjbKIwKnkaOFOGhRJiqlkDzoXg+Jbc1/SdGP2bUlrRu9nrEhnKqDHbY89fiqbVdn3dZHBNvc3U2ouptfmjC6q+qGKBLwWQBiB20a17U2BHMxQyw9/UgwVlbRTZKa2aYrCps42Bsef/9JO0U8k3Ia0Ihxk8KzaG4DBsw+fzquX45HyZqC71+pR9DcXnysFZ+VV6iaGi3DrFQ2LLQOD74QU3mnuNMTlT9uoIEbSlcaTpay4vl0Y6wfHui6it+9HZiC2JvdZFswUJPZbVXkin3hThc6IyYl6pmo4toz/eUwIDfGN2OtiXiIBuWFIpK7TUpoc9B44La3rDrbOcWlcKi/NgjpORcuOuZcrbi88Xsc4XV6e43M7V1yqZo85tNlT9DclQuAqPFKlM+oqz76jgjD3TwWzXy7HBnd2xI2cS8AtqgEfKIw47KacrMlFR1hf1ZmUlPe7cyNUM0yInykKHi+WY9sR+u17uIWoJaT+b97L6yVzHq2c7myf+lfUfNXIhJOcgHl46wuVZNsXbI3zbcgexIPSDMF9zNuSX5CUOgQ4pXqsgN8gv5FhtUDlOqk+mr074+h/w19fIaRVUmI36jK17sNY+xdKLcReDB0CHoc37CG0g/5CnpcYB9V0rO02+uUpJHEy3NBqhlBBmYn
 H4/N6ZEl
 Yk80iExIMb6CaqNgKB1+0ho1K5tbGe1x44ZRrznv/92WCGeHNYrwjG1OsQu6s8Y1wvfpDB2NwrpRlBk/c7FKG2mJLYjxAsgdRNclNU3SXVbuPWq2pLbqyhV7yEg4fBRZb0OCFu3gUQMsRm+Tvhs5NnpY0p5r2JNFjWWlqrP3jPGuQ5wpPvMjx4NbVAY9S0/BMRY3kSQENSInt4iUCJvtWvBhAFOq70FX8+cwFeWqcASCl+5is49Tf4fEQFAYG6wu1+lwKjNTtJw39mQvrLc/JJvTu/QTk/LMFiZzYFUOAkWhlt+y9lI2D9ULf2aTUnbKdYbbCs3GCngkELQpXEb+Dhxmo3xcFsQdIprHXIbTNI7FjQr9w54qeSm0zaMU9e0D/RE3IKTqx/E1LPscU3wXtBr4UmxL6Cw1Ej7wIuxuZcbC1TzTXaMABpUTG+qIELc+PX8yx6SCRyLaLH9SitWNSgXohcZt4jrQrdY7uk4L3CRt4M28ir2Jr/RKUTf7lTGjAPYUFsN7sa+DNzMdB3ot4ho7FtHmH+65WZhiJvy2XMuU859vKvuigFD6baw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 25, 2026 at 3:12=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e
> > https://lore.kernel.org/linux-mm/20260421055323.940344-1-youngjun.park@=
lge.com/
>
> Does this do promotion/demotion of swap entries?

Not yet, let's do things step by step.

> > For example just reserve a type (e.g. type 0) as the virtual type?
> > (type is really a bad naming though).
> >
> > The that swap file (or swap mapping) will be
> >
> > I was trying that based on this:
> > https://lore.kernel.org/linux-mm/20260220-swap-table-p4-v1-15-104795d19=
815@tencent.com/
> >
> > It seems to work and the only thing we need is actually just something
> > like this one in VSS:
> > https://lore.kernel.org/linux-mm/20260320192735.748051-15-nphamcs@gmail=
.com/
> >
> > This part:
> > + /* fall back to physical swap device */
> > + if (!vswap_alloc_swap_slot(folio)) {
> >
> > We do a folio_realloc_swap if folio->swap have type 0.
> >
> > Which means, if there is no virtual device / mapping / file / space
> > (I'm not sure how to name it at this point :) ), the ordinary swap
> > routine is just still there untouched.
> >
> > If there is one, and it's being used, then, it is still the ordinary
> > swap routine, just do an extra allocation (and the extra allocation
> > strictly follows YoungJun's tier rule), which is same with VSS, but
> > everything is reused. From a user or high level interface perspective,
> > this can be designed with no difference as VSS. Just with a few
> > bonuses: being per memcg / task / runtime optional, zero overhead if
> > not enabled, and reusing all the infra.
> >
> > BTW this deferred allocation (in VSS or dynamic swap mapping, similar
> > thing) is actually a bit concerning to me as well. It changes the
> > common swapout routine and maybe worth reconsideration (e.g.
> > activate_locked_split and mTHP stats is now ignored?), being optional
> > for now also seems safer.
>
> I am not sure if I understand you correctly. I think what you're proposin=
g is:
>
> - Page tables either point directly to a swap slot, or to a virtual swap =
entry.
> - By default, page tables just point to swap slots maintaining current be=
havior.

I mean, they are all swap entries, nothing special from the page table
side. Swap subsystems handle things internally.

> - If we have multiple backends (e.g. zswap or tiering), we use virtual
> swap entry instead.

Actually that can just follow the swap priority, or tier rule. Even if
virtual mapping exists, it can be bypassed. e.g. you have a large NBD
and don't care about either fragmentation or compression for offline
workload cgroups, then why use a virtual layer for them which could
double the kmem usage or spend more CPU? Setup is a different issue
which can be discussed.

> - The physical swapfile has clusters and swap tables (status quo).
> - Virtual swap is implemented with clusters and swap tables in a
> virtual space, and each table entry points to an underlying swap slot
> or zswap entry.
> - If a page table has a physical swap slot, and we need to do tiering,
> we basically "make it virtual" by making the swap table of the
> physical swapfile point at a virtual swap entry? or another physical
> swapfile? Not sure.

They are still ordinary swap entries, nothing special. The virtual
space is also just a ordinary swap file (or swap mapping), which is
easy to do:
https://lore.kernel.org/linux-mm/20260220-swap-table-p4-v1-15-104795d19815@=
tencent.com/

Then its virtual_table will have a different set of swap entries. (I
left that part undone though).

> > Right... I mean with two layers you will likely have >16 bytes
> > overhead, and double lookup.
>
> Why >16 bytes? Do we need anything extra other than the reverse
> mapping? Also why do we need a double lookup?

You will have to store at least the following info: memcg (2 bytes),
shadow (8 bytes), count (at least 1 bytes), and revert mapping (8
bytes, since you have to address a full virtual swap space). And some
type info is also needed. Part of them can be shrinked but still,
scientifically, merging two layers into one is considered a kind of
optimization.

You need lookup the virtual layer, then the lower layer for many
decision making, is was discussed before to introduce more cache bit
or things like that and I think that is getting over complex, reminds
me of the slot cache or HAS_CACHE thing...:
https://lore.kernel.org/linux-mm/CAMgjq7DJrtE-jARik849kCufd0qNnZQs7C8fcyzVO=
KE14-O+Dw@mail.gmail.com/

> I don't think I quite understand it yet, maybe I am the problem :)

Haha, not at all! Blame me for the poor explanation. To be honest, the
design is still evolving and there are definitely details that need to
be improved. It's hard to discuss these abstractions purely in theory,
so it's probably best just keep the works moving forward in a clean
way, and make things simpler and better be opt-in first.

