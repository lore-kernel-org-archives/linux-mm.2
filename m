Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04A88C88E53
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 11:51:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E94ED6B0092; Sat, 12 Sep 2026 07:51:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6C466B0093; Sat, 12 Sep 2026 07:51:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D82C86B0095; Sat, 12 Sep 2026 07:51:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A53056B0092
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 07:51:58 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 127AD160481
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 11:51:58 +0000 (UTC)
X-FDA: 85204946316.11.6CE766A
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf24.hostedemail.com (Postfix) with ESMTP id E4118180005
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 11:51:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=uaJD2HTi;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf24.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.173 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789213916;
	b=XxTdtucQEy3Az4WHt34fRWNrvzeSOhPEmGqf0TNyJiycSH6FKHOpsqZPB235iJL54vVu0W
	lMlf8Bry3FZfRTtVnrsBkVNX2j3bNc/0QMy8G2jFBMYweHrIPrdtxDY+H6aIUYZ21ZFj6U
	+cAZdTMtEPURi+Z9RjiVG+AFsIC+sJA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=uaJD2HTi;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf24.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.173 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789213916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bcAx2yrZ5W43UEp0p7bdF0l1dDSK9D0U9mKNzi+eSEk=;
	b=mqA3qDquLcKmSB4MvkyAJ4iXCCE3x+9s3D7GI7dPuhuNlY9BqFGWEVrlSXkfKxlSe7lPIN
	j0fBObiXpkWGh5/6u1+hJ8ZvAWjkeTTcPddlQW1Z1PMMr6Jg1CtPcvlMuKie0zlvR+wdTx
	MX3zyPk3WTMi8ua+8vEhPSdlx9moMuY=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-9399daa3d43so158209785a.2
        for <linux-mm@kvack.org>; Sat, 12 Sep 2026 04:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1789213915; x=1789818715; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bcAx2yrZ5W43UEp0p7bdF0l1dDSK9D0U9mKNzi+eSEk=;
        b=uaJD2HTi/Xc6EFk5SNv209VKPYr2jEnlFblrxL46lo9CBokev4KGKynOtD8iPgCP5v
         x6g+3Kj9lpH5M7tfgB0MQgR+hi5H+YBFzfQyh2uBIS2//skIWYmWnqKLMnXaLAOUYISP
         g2xPW0A42FAW3f44kk0d+wpTvG96Weo3QVWQcwCyZ0zkad9vIHckw1otUUEO+yQDzfgU
         qDJyRCOdeVO8YU7QFP2oJZuKzeOPECM1z1DWX+wmMHXGsTojKWUrdGGJh6T9Pk9zbpcO
         p62iwNiTy51iokZnXaQ1U4KbboMXr6D39xG0XThqm6JqtWfo58peEo+pBQ9eIUBnaCYG
         XShQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789213915; x=1789818715;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=bcAx2yrZ5W43UEp0p7bdF0l1dDSK9D0U9mKNzi+eSEk=;
        b=R8z0hVPVvkD0DTLPaS9NVxd1Lby1IeqV+6XW6hIVXGKnYU8CIixtnHv6uz5FRklqHk
         7DxZ8a9/0HTo+mGaGnW040kEIu7ayagqRDGDfkPO8ZPu39gx4sdnpqkpeaSZdnDTNhh7
         S4LY0ouGaLRG3LUblTeNIUtH/GeKNsc3BkZbq11TP/KIC7m/j7050d05LjV95DXgEsGY
         HE+qtN8jHCiqi0m6SGjXAfKn29qGTjdqf8Xsl3rurj3lBKIcNgV2N6ZrfbV9a6e7lPX7
         uTIWLLYkOeLD0+3vDGN4MmMQ9FLBTuc6XrUs3p7taSAwjbBsGnfiNJx3ghFRqp7Pb3Cb
         zgaw==
X-Forwarded-Encrypted: i=1; AKwUvBxSX3IP9UVDzG3ddFDUXajukRd6wEEon1yhc1fHc3dtD44zFiyN27NTmpkupR1XixUhcALHRfQXBA==@kvack.org
X-Gm-Message-State: AFuF++mtacB/Iyv2zrpzegdAqHFGIR5++JG2UEqIvvBqca1Dim8eGUyT
	l0LyPiuOLkZcjGGw3MhyC8toIhZ1dD+Ts7twmCczm5vEk9Pdu/hfuqBYUTXhV+pVrF4=
X-Gm-Gg: AYBFou0JhVs0PYLkOxAdEpcullYB6VkRH7McZozKQ4Um8z0txE/nSxlaLu0qlV2jl6/
	G7gNom69R1LePveec1tkIj8IjXS79zsTwRrBe+tCSncCu8HHYb0yPbCZ71TeKt5NbkXevT3T+QJ
	hNh9D1DGbzsukrZIqAJv7Di0mGZvXTkusDkzyeoPHUN1y0zeoTW4YQsa8ckr/W/aMqgBbhfhnLc
	a7axUzzlAgeT9kAaZa0Or0EBT8s+1rJnC04dXPkeQ57mHW2mda/MIW4SUfVygSrqhssjKkaxGID
	LrPgOYuFhkiFkc+gokFAGvomW5CgojkPJwTHuPihcmfwBkIpTgcnEWxsi6DdM4xanAHV28L5K+C
	WNVuyJgGzxg36kEXoxrItTs0l+cyPeS7CqxYMSHekCxb2CbFpYtwUx2zxyweDuqEzLnj4RIlk0d
	b5Iunbl9eJ04qBhhNQx20heRcchi/xRCJBjxN/xWKybCt4L+Vj4ecVvsHRgT1fTATnh0J4Jg==
X-Received: by 2002:a05:620a:700f:b0:936:e702:51a9 with SMTP id af79cd13be357-939ea275a08mr1168041885a.36.1789213914937;
        Sat, 12 Sep 2026 04:51:54 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939e7f18628sm481437485a.13.2026.09.12.04.51.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2026 04:51:54 -0700 (PDT)
Date: Sat, 12 Sep 2026 07:51:50 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>, Chris Li <chrisl@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
	YoungJun Park <youngjun.park@lge.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Rik van Riel <riel@surriel.com>, Gregory Price <gourry@gourry.net>,
	Wenchao Hao <haowenchao22@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-doc@vger.kernel.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <aqU81l1oqGItb-0C@cmpxchg.org>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <CAMgjq7AHRzBsbmGOx0s=TQFBwcn=DEU1naR443sO6x+pJd6hAg@mail.gmail.com>
 <aqBT_35E-eSoN_zj@cmpxchg.org>
 <CAKEwX=N4aaq_oD2agTUNrUNXhaYGeQ9vxu+dywFvEFgWFi4uQg@mail.gmail.com>
 <CAMgjq7AfNBUpMamcv29JFzpX=7ApNYVLtPjWT4Sm8cXjSLYL9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7AfNBUpMamcv29JFzpX=7ApNYVLtPjWT4Sm8cXjSLYL9g@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E4118180005
X-Stat-Signature: zqmg5gyt6g4of6z9r8tayicss7betmhi
X-HE-Tag: 1789213915-717985
X-HE-Meta: U2FsdGVkX18dBxcaPcd6omnWAmzBrzrGJB78qHzUGcsh41gBWOwS+qF+7JCdNUFww8a9yMCpByEaWwmQX18q4INM/n5nsk/w8IREbP2s8xS9zIlaWzsxZ1/6SKzfCYiqeGSYuQaS2Urlf99NJgyXQ8Zkj9chQ81YfDQEtT/mubj+FlDbQZhSo/Hx2XQxkF5zucb3Ibt38g3R8nJcGjpgbit7qH1LGErZUVjbtKfDOMpFdbhXTwQ310WHgMCHAJorZ2K6omXD5GloaJdeIYi3ZxGBs4D6tLAG/mQUUXau2Azcw7b+Xpqf7LvxpBsyU9K0c7ISj89XsXub9u24He1NIvDvHwMazsoIigdWFq40AFjIQX5LDwtAFgkS5L093l8lMHymSoiG/LHksPj2Op98cQ32KcEoo4cbhjt3JeCv6t7jYycEHN/8N0qF2TdnHkXxZH07w6ga2/Q8jUZuuyCbH1sy3ONET6J9Jo+gJ3KPr7YZH9VckapPvajK/3aEYodNsdttXBf+RT4rJG7Uiss4W63DgMCipFNf7rwyYvF+IkNfnvHkk/gxIdOVc1H7LuQcOJOb7u9a/SB6qJfapDSCxXOAWyNVYLo2c1PFJLbs1cBrzUZFa4JKQvWNUHMYnY1bRpIq/VjgYi4fW7idCDkihHhTtOLsclIHjkFXHOEPHvNuXJlxCCQ62VinMCNGWIoFpaC9Kio/82Y7dLDmWkCKTi4REz6pjwlGexmWhV10GUJouXfux9RHMpWdzry3VgdW0zFMUOI3W4bbI701G1SwXeoZBfS/w14LOyxy8cyyZiQncd5QOEmjJz7cz5/arKV6AWvDsKyM+aV5K2IzrrO5J1CuLeCkYA27ZAQpFeSacaazfxtCBgdXs5sPlT3nSH51oGgl28n7GFo6kFfomuHfifsoZ8qSEY3znXDFv06ObcSquxtdM7gyTc8IFa7o3dqNVbuUtsurUzL4JDEExLC
 d0MM+sOQ
 VgxRVycih9E+rskEDsibmPn2jB2fKMFbkoTc6b4HnVdxJ7tPDUywhd1wcuG08WX4N+BHf+LqG81amNXtJ7NTZqBOzCnoNWk9bxTdutdfBGWCx3Ahg/qAmA8QGpUrDfQbjRLB7Hj8PJv/3XTnqXJYHRFcu7eq75NN3uuOlg/uuUzIMWF7j5MnhwsrobI86mTqoJ5vE3F8xQkpdXWixn0GvUs6R8Q/7IqKGPnlFlA173Rg6TsXU/DsObmhFavv+Z84EidPGZ5c7ikyWV3B9vfggb/O8XaQYZH8+h1VR8XPvUzJ4rX5SSR0gUbMCx2tz5EvdrPLB9OR48hprAP/xeW5KBHNQtC0SUZyNZiD5vkDwfC4LDPrBq+USh7eddjjDAJitxFxDnUsJXKoZqkGsrqdBgfQZRCWDM8Vvg3/PIun3nRtmAdmCaBy/ED1Odf9dGvq+9GCMYa5KF5gdVEKGREm6MMkD1gyG9SoFTMbiO4Qx+cSweJyL3ApYwgPZwmMj1McDVhU59SI+usV6Yv+hTzh/Op9rDbcXWRt0L2vEkq6goEaWK6YCA1jrAf+mG1+RaQrBE+FVx3l2JLTw7DL8EeZ30mjDg7C98+VeQ1ad
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 12, 2026 at 05:00:42PM +0800, Kairui Song wrote:
> On Thu, Sep 10, 2026 at 12:42 AM Nhat Pham <nphamcs@gmail.com> wrote:
> >
> > On Tue, Sep 8, 2026 at 11:30 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> > >
> > > On Mon, Sep 07, 2026 at 01:51:31PM +0800, Kairui Song wrote:
> > > > Where I've ended up is that unbounded growth is a real concern. On a
> > > > host with no memcg limit (root cgroup, and most desktop and embedded
> > > > setups), an unlimited pool means usage can keep growing, with no
> > > > admin visible ceiling at all. I'm not attached to xswap's percent of RAM
> > > > knob specifically, but I do think some kind of bound makes sense.
> > >
> > > Swap space is just process virtual address space, no?
> > >
> > > Swap entries already have one or more page table entries pointing to
> > > them, which in turn are managed by trees of vm_area_structs. That
> > > means rlimits apply, overcommit protection applies, and OOM killer
> > > attribution works as well (oom_badness()).
> >
> > I tested this theory. I spinned up a process, and let it spam 0-filled
> > memory + swap these pages out continually.
> >
> > As you predicted, oom-killer picked it up eventually. The host was
> > (and is) intact otherwise :)
> 
> Good to know the kill path works. But I think the accounting side cuts the
> other way? Won't that conversely underestimate the host's ability to
> handle memory alloc? Not to mention a lot of application are
> swap  space aware, some built in logics like e.g. with vm_enough_memory:
> 
> On a 1G machine with vswap enabled:
> [    0.241906] vswap: created virtual swap device (2199023255040 pages)
> 
> a 2G sparse anonymous allocation fails:
> [   46.044002] __vm_enough_memory: pid: 1129, comm: search_agent,
> bytes: 2147483648 not enough memory for the allocation.
> 
> The default "Heuristic overcommit handling" policy is meant to handle
> seriously wild allocation (as documented, and it's named as
> OVERCOMMIT_GUESS).
> totalram_pages() + total_swap_pages
> 
> Is the limit, the heuristic exists only to make "a seriously wild
> allocation fail" (as documented). But on a vswap-only machine,
> reasonable allocations fail. Common swap devices, zram, or xswap don't
> have this problem. One could argue that the size there is just an
> optimistic guess, the compression ratio is not controllable. But that
> heuristic is a guess by design, and a plausible number serves it fine.
> "Unlimited" seems break that.

That cuts both ways, though. If the configured compression space is
large and compression ratio is poor, it lets through allocations that
can be considered "seriously wild" for this machine.

It's a filter. I wouldn't say that letting things through is evidence
that it's working.

Since compression space is backed by memory, it still makes sense to
me to reference this heuristic to RAM. Cut it off at 2xRAM or 3xRAM
tops if compression space is available.

That all being said, I've laid out implications and concerns around
limiting compression space in this thread, too. Collecting pros and
cons is fine, but if you bring up cons for the unlimited case, it's
fair to ask that you engage with cons brought up on the limited case,
too, so that we can weigh the tradeoffs.

