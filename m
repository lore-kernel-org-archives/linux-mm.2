Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 466E4CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 11:24:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 835E26B0088; Tue, 12 May 2026 07:23:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E6916B008C; Tue, 12 May 2026 07:23:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D5376B0092; Tue, 12 May 2026 07:23:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5D0016B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:23:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 00A6540471
	for <linux-mm@kvack.org>; Tue, 12 May 2026 11:23:58 +0000 (UTC)
X-FDA: 84758533398.28.7E7737A
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2E5D52000C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 11:23:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cN6X46Dg;
	spf=pass (imf13.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778585037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pj3CnjNQfUpkH+U3gC/I8KUGZmw67J04qC2DMFV41gM=;
	b=nupU3VCzYyMe6fuvDExkidDHteqA/660RBnSrQBwFN4DHVvyHK2HVRfTZMgHRzILaPWKN1
	4/bWSrLATwgiyXa8lujv6eq1s+ADD0qdKjHVvxYy9jW2rbfDUHH+QhyfemvHNd5ZLmfjUK
	5ye2TVAPegEfhU2qitC7ZkZ9W6LNLGI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778585037; a=rsa-sha256;
	cv=none;
	b=F9F/Ph2x1FO+9Y4SqxuoM0h+6WPU2HJ7+XofslIClP+Kt5t5xemS/9wrh5KVyCK6sVz5iK
	MOPUoKtMa1s4+Ki1oUrEsO/QIOhloDe5r6pbDq6q+uDKE0jja2HpNS5LvUWWpTRuhsZpEv
	6DYRivR7WKpR+VYQXQp003Q2ldoeIiQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cN6X46Dg;
	spf=pass (imf13.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3567e2b4159so3269337a91.0
        for <linux-mm@kvack.org>; Tue, 12 May 2026 04:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778585036; x=1779189836; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pj3CnjNQfUpkH+U3gC/I8KUGZmw67J04qC2DMFV41gM=;
        b=cN6X46DggRzNAanYC+c97cnnSqtkApuxOe9T+Ggw6NFPCjEDHGwkamQG8Mnrtg4nmc
         YSEZwjCYOdpVNxgxvOqA+X7Ni3kEanSKNIAnJgwRcWJHyexavfEPdSTurzFUuJH3Ausq
         tsnMyjiYFl0z+yax79cYejzdHL1mpN8pNB0ZCXVI3JfALjlEBc3NKjQ8lOD1zEQM8pYm
         W+BWoXtP7Ydowtd0gvH35GpKO93hI9926uLSoJqnIRBse1+ySLAi33AZDOdepfFfmiks
         2nUU7H7zGewRFSant5UNbaMH4EaLkAWCmLJ9+4XJo32tjbfOole+bO/ch/ucU8oGYQup
         6Fcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778585036; x=1779189836;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Pj3CnjNQfUpkH+U3gC/I8KUGZmw67J04qC2DMFV41gM=;
        b=UUlrIJh9o+vWo+De1qqrkIwnh6Z6AuLzsw6LW5jbPLcny+BGBqM0sGfs0cDWDl48/b
         fGeKEI8301IuiGcrD5Oo6CCCBuov5fNQ4u6ST3LAkD1n7s/gx1+4LjvYiAdIKdAsaUqE
         mY6AXMAdHtxtRllPO9oX6PpUy3rJnnzKtVW5+13ryyhxw7xD6i7rvV8DGOD2vvyw3tbD
         GEumFGege6q1QBq5knD5Knn0/HBqVMpDArabk0ixuQUiWLFfegXDKVfSEgn4Q61idBVJ
         Bpx0MwcLh+XTSt9lxyGKEfytcgJVPlRznRwlRH9nwLm1fRSGk5dNXkihD3XULhYxwV2n
         TZxQ==
X-Forwarded-Encrypted: i=1; AFNElJ+uQShzbsf09b34xAZNq/XdWg0Nh5kkulgCrmUh7Ms3uAvrZyodA2exbZETCjJs++kjDi3eeLq/Pg==@kvack.org
X-Gm-Message-State: AOJu0YxDxEkCYxclB3qaVPmJBPwi8y4ghlStzNQpg1BkS2bV1jSVwZOl
	AeTDsAKG9iVg3ypLFCoVdIeOL4/MCJ60OE8zxv/ccQFu3Iv5otjqjU1P
X-Gm-Gg: Acq92OF2HvLYJqUZqK69+Ay0LwtAL/kzdkWIlFajQVfKIkH7VJabDfLjDb0O/hYtPfQ
	JoXXowwwksdFducCe3UbUuTsDjyaRb35T5kupjkpP/BKItJJX2y49ORPkfpnXC33DtwnaaQHIbu
	HBxskX+fiN1ZNUtYTkp5xm3KjQyyDCsUcTuZezGOY3Z/j6HsMiquI7bfdy+Ec5l23uaDkXUXk7D
	NsaPeLaApj23m4J7Zc/ti3u3cICeXY9rUEqxRHbI8KQ09lZoYNFQsFmGj0/8Mct9mlxxpTmywTR
	JIvyP+LvpjGhc+OgUaLiNDwVFW2l8TX5xzlenpgvwLewSL3l8cVR31N7aLoLpZSwOyKZFIqHRFk
	snUnGEPaJTSjwe+Q/uOWEjjQ/ZUcaYvO9rqhlS8w53g6CVhwqt4SiSn5v9O1UydTxKNWMtDt+X5
	HuCMV3oNu1uDyEfAQDOZ9LIYU0dpHo4fjy0yFaUKXqAsM=
X-Received: by 2002:a17:90b:3808:b0:368:cff1:ed99 with SMTP id 98e67ed59e1d1-368cff20420mr1095608a91.18.1778585035935;
        Tue, 12 May 2026 04:23:55 -0700 (PDT)
Received: from [10.125.192.65] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3685d84aa55sm6286680a91.5.2026.05.12.04.23.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2026 04:23:55 -0700 (PDT)
Message-ID: <5e6cf3fe-40eb-4a57-4bbb-eda2c31b3210@gmail.com>
Date: Tue, 12 May 2026 19:23:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH 0/3] mm/zswap: Implement per-cgroup proactive writeback
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org,
 shakeel.butt@linux.dev, mhocko@kernel.org, yosry@kernel.org,
 nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev,
 roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Hao Jia <jiahao1@lixiang.com>
References: <20260511105149.75584-1-jiahao.kernel@gmail.com>
 <agG-gNEclOVf-9WA@localhost.localdomain>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <agG-gNEclOVf-9WA@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2E5D52000C
X-Rspam-User: 
X-Stat-Signature: azi85p1um3xodui63kqof8kwirnohr8z
X-HE-Tag: 1778585036-11708
X-HE-Meta: U2FsdGVkX1+2QCVL+5ZsQgyTvYBkHK00AJMd5cR2y4+yg2g2iYG42kcwxDej+/LsZMFULdRNaQbHKdpYOLWaBBINRYTV/o5HfXVLBhRJK8p7MWBVYRbdHvFi+zZw6poFhm0KLBWQVq3Et5cWC9Ms31yLKjsEdTKY8qfm+em2OAXuhjX4B+B1+4QNg5tr/9hIk1nmK3XtL+BmiW14XUy11/r2+U1rjyAUfWDM8D3SYz7DHb3bE/qac6ht9pPMI6JCcKWA8EPpmKUbS6im/I6J7uhuph55Nnuvzq57sSiahD60seODf2eVS31Vu3Fau6h3DsMhbPKIAivRk4pGSjQNk668vl8di1oBXu+0t0lFk6rEtY1NLxeT+O6WiOkLGOeeG921czPL1ZbUF7vwEyCWTiHVxj8w07WR5wdUoRKHdwyCL3MTXe8qe79E78/9760jh+4N8eYrz7hDvVyeitGHhssaX7VHJlTuqwsdQeBEQyukiWhy6SmMsvRrJgUliyVrCbbvlP5Uwh2OhHyNxPv+pSTiwNFtpQj6RdgHsP1wtFYAaSrLhg+7J2qlUyHkQ9dhm2xU7YGCtiB4B8QTD/pIfWFQkpX+ZtH5XdPTG/1CqV8EFdibLrIlHSI4vDGzmB2pN3PE1lMs3lNDS0vkC6fWJGPvUOs5JxdHnF0gZRJlIwHa44BYBSkVi0bpJHnHl8wkapJKnrnf3fO3CSbGhnJ5noj/7zlxZ8IC8gNul60z6XNOwmZ3pNdqe8wwkSlb+3uUHSxEJbjpyOwag6QSS+uSZU6ybX6V6ymrvmYB21Ck5R69KifNbxNttd8/P/yLuvblT7wnoiFh3psPjkXHXfHF4ApF1Ddp7yyq8Nbbc/Pt5jWbXlk6oz7XbjuiqSlBgTvWDr9bnb0QMm2XpHjEGW7zr7BPU92nbhCJmC4NfsviLIOotgWIPFM4cwttu3LknNWIzm7b1ybXo6Vu3xmBHLH
 jqkBO4fX
 70qPugUIYDp/uXXimgtNooaVlcEGNVQFtLy751asPtE5R2EOVQPR1aQ/C2LIKAqeip1IERUKm5Sx96kqVBBKhiCKKYX8bIbkM+bVq6bcgo6UF0XumtcKRsoMXbkGsgDayP84xfeVzQVEwJM162Fut3jHi0lfCFYnFX2IUOMcJKFmC4Yk8VGMvP+uy3jgaoYbrKtBsZ2TBS/0aHdfc7OgA3nng4hFSp6ndWO/zUuCYbjPyYoWV2Krqxhl66H7R08EJkANsjbDM+sF1ZXXSNrX+AR/nFaRgffLO2UmjSKpX4lKfSzr8Dst97Yh1YTEdltkysjYhumou7uFJF7zGUz5l3KO22Iaip/OFaslrWn5tQA9auv7sQGGBn41wppM4GgRD5OEYr6lEADEqfpuapxH7cksQ6oTNEyv+99hqUMRwNk7VVDIcsnCpTqqzwi2+6gFWQOfRLtm420YbdCkh7WRUjqVFBrtgZWnklnDCItschNy/eUYzllzjZyh3D5RbK5Mo3jaxGVt42ojz7vM8jn1VG4soLimtN9BUNfzL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/5/11 19:39, Michal Koutný wrote:
> On Mon, May 11, 2026 at 06:51:46PM +0800, Hao Jia <jiahao.kernel@gmail.com> wrote:
>> From: Hao Jia <jiahao1@lixiang.com>
>>
>> Zswap currently writes back pages to backing swap devices reactively,
>> triggered either by memory pressure via the shrinker or by the pool
>> reaching its size limit. However, this reactive approach makes writeback
>> timing indeterminate and can disrupt latency-sensitive workloads when
>> eviction happens to coincide with a critical execution window.
>>
>> Furthermore, in certain scenarios, it is desirable to trigger writeback
>> in advance to free up memory. For example, users may want to prepare for
>> an upcoming memory-intensive workload by flushing cold memory to the
>> backing storage when the system is relatively idle.
> 
> I can imagine the zswap writeout can come at the least possible
> moment...
> 
>> To address these issues, this patch series introduces a per-cgroup
>> interface that allows users to proactively write back cold compressed
>> pages from zswap to the backing swap device.
> 
> ...but I see this series is not only per-cgroup proactive reclaim but
> it's also age-based reclaim.
> 
> The per-cg consumption and limits (and regular memory reclaim) are all
> measured in sizes. This age-based invocations don't seem commensurable
> (e.g. how would users in practice determine what is the desired input to
> here).
> 

Thanks Michal — you are right. The series is both per-memcg *and*
age-based.

The interface carries a size budget, like memory.reclaim. The two
parameters play different roles:

   "write back up to <max> bytes, chosen from entries whose residency
    in zswap is at least <age>"

Size stays the unit of *amount*; age is just how we describe *which*
entries are eligible.


> Could you explain more reasoning behind this design?
> 

Context on the use case:

Our deployment runs a userspace proactive reclaimer driven by the
system's runtime state (memory/CPU/IO pressure, refault rate, ...)
and workload-specific policy. It uses memory.reclaim to drive
reclaim, which compresses cold anon pages into zswap as the first
stage. For entries that then remain in zswap past a policy-defined
age threshold, the reclaimer wants to write them back to the backing
swap device at a moment of its own choosing, to further reclaim the
DRAM still held by the compressed data.

Why age is a reasonable selector at this stage:

Pages in zswap have already passed a first-stage coldness judgement
(otherwise they would not have been compressed). For second-level
offloading, the question is which of them are cold *enough*.
Time-in-zswap is a natural proxy for that. A swap-in invalidates the
corresponding zswap entry and resets the clock, so by construction
an entry that has sat in zswap for N seconds has not been faulted in
for at least N seconds. Residency in zswap is therefore a strong
signal that the entry is not about to refault.

In our deployment the userspace reclaimer starts from a conservative 
threshold (the starting value depends on the workload) and adjusts it 
through closed-loop feedback:

   - on one side, the age distribution of zswap entries, to see
     whether there is a meaningful population past the threshold;
   - on the other side, the post-writeback refault rate and related
     signals, to confirm that entries written back were in fact cold
     enough.

Both <age> and max=<bytes> are tuned against these signals until the
realized writeback volume matches target. This is the same
control-loop style already used to drive the first-stage
memory.reclaim budget.

Thanks,
Hao

