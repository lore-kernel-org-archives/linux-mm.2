Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5311CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 15:16:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2A906B0098; Tue, 26 May 2026 11:16:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E02866B00D9; Tue, 26 May 2026 11:16:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3F256B00DA; Tue, 26 May 2026 11:16:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C40306B0098
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:16:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6A6408E6CD
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:16:38 +0000 (UTC)
X-FDA: 84809922876.30.FDA969A
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8E2E840015
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:16:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UOTOjEgo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779808596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BVmfi+uDn4MQKurIQE45dLQAanWv2IAzX5ZFf3oRwXU=;
	b=gawebV90bAKs6+wffFyjO60UXt4Pc3BZHI90pDFne9ujYW5k/XkeBamQFmrF74cmrFOmfh
	/A/7PrajhtGvqZ6aWe+IhcYJa7F/3KNpPDdh/pqXXCe/Y9y+C9wtFJ/kdn3ykGjjn7ZV5/
	ml4/GAKw//Pi/zUAM/Wta/Txpwpyf3o=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UOTOjEgo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779808596; a=rsa-sha256;
	cv=none;
	b=elA8/qGmFUrui/T0EZrlZCh96hhLIDWWzeD0D+Ll4NDQ6xzWzHZFGf1XDlZFzeju4X4gHC
	Q8fhXKQcfwrqt0dZ31sjlasFrb/bPWE9ZjGBhRzM+H7OZDnxPKHtUXlidsmUNwGSj8p5Tk
	5eBhHnTi/sNWWiP0KkTq57uvkN7oW7E=
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-43b6f19b7d4so2842930fac.0
        for <linux-mm@kvack.org>; Tue, 26 May 2026 08:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779808595; x=1780413395; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BVmfi+uDn4MQKurIQE45dLQAanWv2IAzX5ZFf3oRwXU=;
        b=UOTOjEgo632eHhNhutfwNL6UdxZp8/V32NCTsN2eTz0RXaXX346+IIixY/jGBxXplo
         L6AfrHkM6vyu8x6m9W8XpxZu49//D5SGgqnS5TbKyvdTY3L1Tiz/+ITR6CtwDiPzNvs1
         SgJZK0/YqCDw/KbjyEW+3MJMRXe3UafHqrxjEwSmMzThZ6W2cD2hhrtugVZs8RweYLN4
         9n2dLpalj/2HhfLwIy+2/NQKwdTTufCIv4fW/I9JS/36nbbQ7ZxeVpjWsHp9ImjHnGmR
         WeRATXjB20oKgl5sxx7Ov+A7A9avJKrFo6jjrWH1IL+2bb5SZn8vPqVQerD14Iuzqrr5
         yQmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779808595; x=1780413395;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BVmfi+uDn4MQKurIQE45dLQAanWv2IAzX5ZFf3oRwXU=;
        b=pn+EbLC+dC4JkB6/w5w5nGo1z+ce+t3hnkg7SC3gdpqjbVCi+7VIxbmT4fGZrYpJ7K
         kTEU/hBBof3Q4EWi8/RS5+0fPnJGBkF1NyXW63o4kQSl73rs2LAAeB+sTSAKWheqxyBy
         ivVjOQrbBgVmNl3SQhgr3biY7M0JLkms5oQxDAzCXwdlny3fpoBRKHgXmeciw69IGQIS
         5id7HrKHyY6EC61JHZ4tgfz7yYPVM7ndj7C8Wzc4wwcQPushgMuYY/DYscsBgH1EHv0E
         hVwoqLkRBln2BOesStBC8z81uSuPOxOlc/DzktwxFRWNFzMn5qRBIg5T2bsNRHpcYtNU
         LiKw==
X-Forwarded-Encrypted: i=1; AFNElJ9znfUnwOx+vEsonx3FbqJ2Irixz1gnQppYkm6ZlG0sHeuZ04UHFTgXdIS7Wbq6Dw0/BUulHvHpPA==@kvack.org
X-Gm-Message-State: AOJu0YwHMT86iQSotU+UPkUbxRBhJFzjaLBGeG2gBHmA+DanxPIZl4Cj
	Fyi0j4sxpZem+Bnlje/a2DhsFdApuOupE4L9Ddi/LAJ7NtVGRzQP4VZR
X-Gm-Gg: Acq92OFqnx/OqWnoAr6JeoRMng7ONfN1gCNsvRYBzDg+hYuos6wxe17lq8oWuwwGEXf
	TXFk2d1m6kKN+A4vHwtdGSHSUGPhlfOpCrKERidUWbcY/+wKPO6C8x+dlw8+qZoS6vY8j35o5eb
	zJ5QBuDLimvV9D247qFgPZ9XhBQJ4h98S1NhiRQvJchckYJ14/3GN4Bu+Wowp6Xdj3AxRL/xyzz
	6jHCiYlblYKzBH1xRDJA0Cc6TLsqR3PoxNO7okLFtIPqhTk/SfoNYef7ip4pOR+fGqjq0FCwxae
	ljAU1lvJ9lMFeFbevOlN2AKLcDY3jArTVx+m+TSonx+OTYuDipnXxXU1K05HZR/JBwbeDVQChtb
	L4xJxV4tFEw+6fMi2Dhk7cAiYLNzcMALJ7M1A1qOg5D8RM13H88Ba2GUjHPhiZwP3Stc/nFdWkq
	Xl8uEhNhOR3cnAjcyvHLATisqLFhHFX7gtx6Czf0Y/QX79aHQZ8KyWmQ==
X-Received: by 2002:a05:6871:5d05:b0:424:23a2:5cd with SMTP id 586e51a60fabf-43b5a9f6fe4mr10168185fac.6.1779808595391;
        Tue, 26 May 2026 08:16:35 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:71::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-43b62e4211fsm13405421fac.0.2026.05.26.08.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 08:16:34 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
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
Subject: Re: [PATCH 0/7 v3] mm/memcontrol, page_counter: move stock from mem_cgroup to page_counter
Date: Tue, 26 May 2026 08:16:30 -0700
Message-ID: <20260526151633.3738554-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260525190455.2843786-1-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6m3wseqar1h1p4e7eukje188dkp8mnyw
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8E2E840015
X-Rspam-User: 
X-HE-Tag: 1779808596-820226
X-HE-Meta: U2FsdGVkX1+/jsZGxcCeBZqWUise5xR0AjiOsU5B9zYhr7QKJIML3ZmY9TnucWHCifrw0PgP4kfgKMVljnGhwH7mvH92T9+o4Aou2Ls4qSjvfDIoP1ScIyUadJPexje5b5n+qn5bDoSRMK7/YX7Kf/gEmqdIffIPe7oJXvr+vSWW/r+3w18//RH0EludP3E/tbiN22wPMkmqJxI9ieJWhj9RsErezKlaOrK9PCe31PL0SC1DgN3RaiV76PbNC/Ewk1Vc++BpkzAsWDAcRT22TNKSE5r1qLjH8w2uggqb4N0uXaZBLtBKWSHmPfxgiBWkFzKa8dqnqCoRMsTiW4RSqufH/GZTl/rM0NQLy1p0TaUFwKBhYLshjEVCI9Ws6N82bkIUiF1U0AnNLiWsC0gJDxmOewUeY5HMp05AX2Bjc9g1QRsRHnx0fLWv2Sybr4Tv9Bargnonizciuw6Ts14iHeKynC6WmeBgXR+QrDc8IKu1eyaPdEerCG6X7PZW2r1Wbh+hbDH5V0wiwNoHeDMeXQSduh9Neu+mr/HnWBn5yZRnd0/z7ECUjbTuPp81Q9YU/ffsbgP9/xITZ+K7a9LA48G7YAo6ZANEH4epyxJt4HM/rS0dpjWTP7W5blJZFMlMjDRyowqtXSVGGFS09opgW4NKmW2JYzNC4LQej2rxImuZmqU/+px6VCTv8G0TdfXVRVdBma36oqyY+ZYLFexmHU2byhSwPOOIy2iIPVIFQNvupNeo5w73oTYoqdb724Ph7ChqBYGGEiBJ7ylglw6ivhG9ShFnnQDznIBT6Ggr+bUBxlumdND8JKlNNnjiLLHpgQZuQMDqfY/wMKxr54FUL9C5WtDbTPDyNq7m5mwfyvC0ezenqPzvakxQjNZahuEM0wz2jIod9aW9y2LWzFozpKNU2sSGs6jiZss2EfKJssj2JLePOFuPue24yp+RJ6mIL7okQW1ciYKm/qSuWeD
 lhDMtqlB
 fmaXu5vWhuerQkbWlDcuzot9HVyEUk8B4IZ38mCNqypGfIK68RLd7KLWGyEJthyWRnV441/FM6ajRh224FVMilovQDHcUzdt7nfTG8pxyAdASaehr81BVgk6/+syyiZwyMs3BElv1x078nOjU4Yd2Uf2irOSfRorkPH96XXnRJzgoLZrLb2IUrLDqxgL26uam/EiDE+I7vTdN64UpIctk5J4L5HBn7oMLd4R/ilRUiAMpgn2pt8WjUiFQ1FmSmet5Q580w/aqVNumOrnwmQ/Y1qjoWgQpzIFSPHmSK+UiYmAeZ1Wlfyf3hbGjLU6jVN+7AtO47Ut6voBfhbiSIbwwfyhzkxIUGYE6BmkWtoRjjfg7ytdgyzlafvske01uNz72rICUL6LJBCXtMCsxu7fvl7q6KJqaeZDwq4LjcwOyGP2OwoUb92+pdsGBa/96z6SU2x4eEBvC1gySc56FIsuWb1e/B5p9p39VN0p+MWSrFRecDlCzXf38rsw6Bz/ZteRVoE9ai+dKElgMYx6A8YqYjWYnG9hJ2KGWuUmz/hQEfj33tTht6CUo843XUs72bPKbeZvaaoHMHrkA0hn4gYGezMkldJ4We3T6BRQ+Vjv0qshtdfuRAZp3kgX0+Pv902Ov8Y909nEThlqLsEo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 25 May 2026 12:04:47 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> Memcg currently keeps a "stock" of 64 pages per-cpu to cache pre-charged
> allocations, allowing small allocations to avoid walking the expensive
> mem_cgroup hierarchy traversal and atomic operations on each charge.
> This design introduces a fastpath, but there is room for improvement:

Hello everyone,

Sashiko has left some great comments on the series, some of which are
things I need to address for the next iteration, while others are false
positives. There aren't a bunch, so I'll go over all of them below.
Note that the same warning brought up in 1/7 is duplicated for the rest
of the series; I've addressed my thoughts for that in [1].

> Joshua Hahn (7):
>   mm/page_counter: introduce per-page_counter stock

Sashiko raised a concern about how zeroing per-cpu stock during the
nolock drain could race with in-flight charges that read the value
before it gets zeroed, leading to duplicate drains. I think this is
solvable by just changing the order in the callsites (disable, then drain).
More details can be found in [1].

>   mm/page_counter: use page_counter_stock in page_counter_try_charge

Sashiko raises the same concern as [1].

>   mm/page_counter: introduce stock drain APIs

Same concern as [1].

>   mm/memcontrol: convert memcg to use page_counter_stock

Sashiko raises 4 concerns, of which I think 3 of them are false positives
(or not as serious as Sashiko makes it out to be).

(1) Sashiko asks whether the synchronous draining with the percpu_charge_mutex
    lock held could lead to more time spent holding the lock, which means
    more callers of drain_all_stock would fail the trylock and just skip draining.

    To clarify, even in the original code, two tasks simultaneously calling
    drain_all_stock would serialize and only one of them would schedule the
    drain work, so this problem definitely existed before as well. It's just that
    the window for this race is a bit longer now.

    I do think that there is actually a behavior change here (for the better).
    Previously, drain_all_stock had no guarantees on whether the stock was
    drained before retrying. Now, if the caller can get the trylock, they have
    a stronger guarantee that the stock is drained before retrying the drain.

    On the note of premature OOMs, each retry loop takes much longer than the
    draining itself; I would imagine that by the time the next retry loop happens,
    there's a better chance that the trylock succeeds in the next iteration.

(2) Sashiko also raises another concern about a potential ABBA deadlock with
    the mmap_lock. I think this concern is not really true, the synchronous
    work being done (drain_stock_on_cpu) only takes a local lock. Hopefully I'm
    not missing anything here.

(3) I think Sashiko's concerns about NOHZ / CPU isolation is real. But it shouldn't
    be too bad, all I need is a cpu_is_isolated() check in the for_each_online_cpu
    iterator. Again, not draining a CPU is not fatal here, so it shouldn't be too
    big of a problem to skip some of them.

    I also just wanted to note here explicitly that we don't need the
    migrate_disable() for the memcg stock drain, since we don't differentiate
    between local drain work & remote drain scheduling (like objcg_stock).

(4) Finally Sashiko asks if we should enable the memcg->memsw stock here.
    That's included in the very next patch : -) I separated them so that they
    can be reviewed separately, since they are separate ideas. 

>   mm/memcontrol: optimize memsw stock for cgroup v1

Both concerns here are addressed in the previous section.

>   mm/memcontrol: optimize stock usage for cgroup v2

Sashiko raises 3 concerns, of which I think all of them are actually OK.

(1) If we drain the parent memcg stock on first child creation, then this would
    mean that there will be additional synchronous work being done with the
    cgroup_mutex lock held. I personally think this is fine, since it happens
    once per parent cgroup, and the draining work is pretty cheap. But I would
    appreciate it if other reviewers could chime in here.

(2) Sashiko also asks whether we need cpus_read_lock during the iteration.
    I think it's fine without it; if a CPU happens to go offline during the
    iteration, then that work will be scheduled on another CPU. That's fine,
    duplicate draining work on 1 CPU isn't the end of the world (and preferable
    to taking a cpus_read_lock here). As for the dying CPU, it will drain its
    own stock during the destruction path anyways, so no stock is lost.

(3) This one is not related to this series, so I'll move on.

>   mm/memcontrol: remove unused memcg_stock code

No comments for this patch.

I think that's all the comments that Sashiko raised for this patch. Most of them
had to do with performance tradeoffs, for which I hope that my testing results
in the cover letter were able to instill some confidence that a lot of these
tradeoffs aren't as bad as they seem. Regardless, I would really appreciate
reviewer feedback on whether they think it is acceptable.

There are definitely some real bugs that I want to address, so a v4 will be
incoming to address those (in a week or so).

Thank you Sashiko!
Joshua

[1] https://lore.kernel.org/linux-mm/20260525194506.3414995-1-joshua.hahnjy@gmail.com/

