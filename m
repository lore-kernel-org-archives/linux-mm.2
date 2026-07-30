Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9454DC54FD2
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 06:31:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27DD36B008C; Thu, 30 Jul 2026 02:31:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22E8E6B0092; Thu, 30 Jul 2026 02:31:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11E066B0093; Thu, 30 Jul 2026 02:31:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DB6266B008C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:31:42 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 625CB40901
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:31:42 +0000 (UTC)
X-FDA: 85044472044.25.4CBB913
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 86F52100006
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:31:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NKgFqWzq;
	spf=pass (imf05.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785393100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hOvMF22l5yq9rb3H7AnJyb7Yc8S/1iRInoiHq1DCJyQ=;
	b=0aB5Hfl2foxGIhb3dIWtpdU1xDnBz9fROn5pjEudO162piKqQRc+3Dwry/Y7pxkmz28o0R
	7+RNkMSH/iTVT0jhkMkwqsqQHPD7RRR/XrmbmsLzTWZOt1XBxkUVrkHIvnJ4wUTn213yFi
	uQiNid/aQ3YBuLiQDN48a0cZzS8UKIo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NKgFqWzq;
	spf=pass (imf05.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785393100;
	b=ghmzkKP/UJmPYisTrCIuvW+7HluY1iTzX2C3j/qUPle2EX1enaCv/UFgcQmSsWV5nMJsYD
	0KbatU1OZXz8MZQNxahU7RsOwIU4Piefkk92rSq6Z5vTKyeLXuKxXCEifryTUNwaRjy/+d
	RTbAYhQfF7elB5HpzpAvvvPOwdOhhm8=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-84e04df8c46so2032003b3a.2
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 23:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785393099; x=1785997899; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=hOvMF22l5yq9rb3H7AnJyb7Yc8S/1iRInoiHq1DCJyQ=;
        b=NKgFqWzq+5wjf1CJz6LP8ecs01MqeI3eqk8rPYq3cDiTsAICwuYrMB7pgVGKs71SYG
         BrXr/YenFt3ygr4N/GDt2QqxOl6Mnul6NgS93WxnkMQb9MYoXD070QEI5USf9jRKoI65
         TjtAHlxDEJw2MQs6Cr7k3QHsF9qV0tffRmTCcgl01K0FtkM94xHjm6MT9Rz5IxoYjZnp
         Fh/zrI/3p2/Bf6KZXkNVsuPkn1AbajSwLHmC3HqlpWBMyOsIVmllmbQLFdA398SPXjK7
         qfxJRKVn95WpU13/D9c8FkFvx4XRRZOdtgXoUjX1BYgZma3kUcWjQ1L6h/0rBRuyEaG1
         nUqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785393099; x=1785997899;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hOvMF22l5yq9rb3H7AnJyb7Yc8S/1iRInoiHq1DCJyQ=;
        b=DKrxtJt2Xs63RDSJFpnS5xPqERb0jCR+lrtqO6glko+xcSiTEpA1k0HuZw33+k/Qk6
         zxLRaYan6MTCAu0WAD0Ks8mqiUMFUFSfdl/UkVjYiayY3KG6he7r8zQCc0MfpRf6HRce
         A+/jrrWhqXgeaqGvl59foS3u/PR2GNv8Wh+WlYnMohj/GxYYiRBb6vffW2KJvK0GYZVS
         Lnk27nFRkvHCOUAHvrLl/UHtkdWxZ9jkBLEWlwzQ++xR6gGFXOMBYj6oZXgydj6h7OWa
         Ui9Wo/xdOQUyR6Dv+hml5wH7tN0KjpqnSCxKL2Vme7Cvljzv9jEdwnocqHJJA5bSrE3A
         3CPw==
X-Forwarded-Encrypted: i=1; AHgh+Rplbnvq2tN5RE44lF4r5lC0Zi6Utpg+T634HmayeGuRRTJyefk7IiNQ1Jiy8f4ZclsnyRkW7eUBYw==@kvack.org
X-Gm-Message-State: AOJu0YyR/dVBfUUW1uv1s5adRyzQdiD0KTXs/dNnHGlV3eX5b6Lh6+9S
	wZCN+Y5a8+uYxPqZ6XauvhQkOgEBXnsLDtio6+LWKwD9o9wjyzfJzON4
X-Gm-Gg: AR+sD13bzhZf68y5kXfHF56za9V5jSL4NI6lbD0POHf3mazGwD0m86fqfucnGlu4coG
	x1pYYOCAu1SpdAVHcl77BhkMAGSiwVLyfHhxZa/CWHc7mONr5xnos4OC0TG7xSxblFH3i8n8Ng9
	72IretEdJmp+00P+l80/jelPZpql7uMfO74T82Fyg9C5y9J10LlBwfQDyRirqSohr9SzITfaKSH
	Liec1vwNaGXntbxMIiQA2Qu25EuvAOZ7d+Fz9rs62o8mfj5PEpsEBlQzfLNo6WQqFnVaESYi3kE
	AH700c45aIvKPgXQL0qkaOpV1zu+EfNFRk/U3ECdqh2cV5YZhhw/LXFGEf0xdKOK18LaNFOJkCz
	sehtRrpNfbnSYUY+choqNyXCtXnP/YwyFUoaqhG3uMj2r/rYCJOygM7+K1jEWaz8K1jJ+p1dvhc
	0gWKbNVYQJNT55l/L1jMj9Ix+RQE/9dt2vCO/DfGS//mkuJuk9W/UOG0hGVQ0X9PE/1ABTphAmC
	N5psYuRgoD4nQpZUeC+
X-Received: by 2002:a05:6a00:2e95:b0:845:d284:9e14 with SMTP id d2e1a72fcca58-84ebc468c9cmr1404273b3a.59.1785393099312;
        Wed, 29 Jul 2026 23:31:39 -0700 (PDT)
Received: from [10.125.192.117] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84ea0052e04sm2418453b3a.22.2026.07.29.23.31.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 23:31:38 -0700 (PDT)
Message-ID: <c4c95102-72e2-a44f-f16e-4134ba6bb060@gmail.com>
Date: Thu, 30 Jul 2026 14:31:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v3 1/2] mm/zswap: Fix global shrinker when memory cgroup
 is disabled
To: Yosry Ahmed <yosry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: tj@kernel.org, hannes@cmpxchg.org, shakeel.butt@linux.dev,
 mhocko@kernel.org, mkoutny@suse.com, nphamcs@gmail.com,
 chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Hao Jia <jiahao1@lixiang.com>, stable@vger.kernel.org
References: <20260729084206.77793-1-jiahao.kernel@gmail.com>
 <20260729084206.77793-2-jiahao.kernel@gmail.com>
 <20260729155858.c7aabff48166a9bca4d68ac3@linux-foundation.org>
 <CAO9r8zNhBCghP8T_98z2p==Cfs_=kamcRN_3ROxaj3R8PN2Qvw@mail.gmail.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <CAO9r8zNhBCghP8T_98z2p==Cfs_=kamcRN_3ROxaj3R8PN2Qvw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 86F52100006
X-Rspamd-Server: rspam01
X-Stat-Signature: oc1mxyaag9z6wjeewhdyb9u9q8miygps
X-HE-Tag: 1785393100-872512
X-HE-Meta: U2FsdGVkX19okOY/Yd2uC+zRtUz/5EEEv9X9nmMS2Ek9mH8baYHgpvGhobNGI6fW/E+7XgCwEaY3JNb19Tb2QvqjtENJ6bHIYGwbRx9GW3QQ4fgtj3Vb5Vw1vVPJgdYXpLwuszFUQMaG52RgLwdBcG5SGOnRywjKNgELL3u3zJepsaG/AUAlcmxUH3vuZWPHvIJZSPhLfL4VdPoFRHyqvG/+7AvNybyHad2/bK7KgJYW6O0i12AhRtisDAO5R6bdjka+jh6TuW8a75D66JsMYeT0JQw4Iy1PMGZSVWRS+TBFVOFNRwtfqh8hGDfvrhI3OyDVePiAVh5YIVNN2mCzDQENuQ9FE01fQh9+HOrO4sAPxrgZqv2i37Mhuua84cRcoTIOGoVW5bbMCtQutQSFYinhDaQ8IVbSrUkaMgrc78aUnwmop0jxJGb7PLXyCcL7QwAUHtTufj6qBBInse4bS7DWowSsN6QPk1rJsehYgqI2GMWciFp1dBayYY7pkN1JWbuEnVoLcamt97Ro2+TQ8dGnpFd2XUftRxe7q3Olf3teZU2ys65Gmse4zRP1CsdNcPPe4I4DQ4Fgn+9iymbKNuEw588ULhZG37vcE+V+xkt3pTdnP6KbavsKGqnHX+6IPmxjQ9RSLrsiquHWwcCgQjQWd78nhHxhHa1tqt+WgJiBl1B4ffIbbu1ERmrGOitxMJyiCTa98eWPhR7VWiPjPtgjlgxBhfWfLJG8xwTUAdf74iU3lAlYX5y5Zg59n+cFwPnDfErNMgcaKSYOboDiCVsNubiqyoTQgU2i+Z997mxytrVq1jyFPWAvySGWI8dV+Lay9E3nVhWID9Z71Fz0yDokrBShRXFW0Cl1kizTsOwy7CwT3fHv01CW3oLgm08B8Hvm8eSZeZSov6+Wl2wYG2xuMhm0aEj4zP1q6xopwEhhtYthU8mdhP6iNkIydrbBzcwxhDnUoHyKTrdLNVY
 doQQZ+/Y
 +xDXB/l2d5/26H/qazwFzUmwN8W463tRkC1oxdB/czc4PUPW9BzeqOngvIA7Lun/nuO2jGqTYeQ9PzwGJVdn4z3DUJ7NcH/jqv5B5dbkAQ/7f/cb2H8pfqogWFnRSXrM5g7yhK8FlMvqHsl03CQlNEdDTydgysqBPB27zi9aTkVxjXyrn79hBgzr2/EG/PAbNxxdmYMnQQyW/26whljIqY9RTYcgwbErIHM2YItIt8ai5q+7LcafXRP/2j41U0MhvJIQJhw/uc4Ex6BjXUqgZ3sd8mCj3ItQKBECl/Pdvjz5Ud09TZvruVNTZfickWa6G+BItbjkm7zMhFJmDGzQKK3fnbI1f0tuoKcfaMS+W5/IqtUM878xnEK16OABQO1lsVJ+b+Fz2e7dmPK5/OjNNIzKziTy314QEiw8yAW/2U5ItSCtVUHx0tyxTlaAtZw6AicbEnaRESHPT3eEPn28NcAJW+G/p+wU0BNqQPB083aq0x1HCz6A1m1AoKfzXhCMcTS69O97meRNn60Vz1JA7Suvx2gocESYpbaiL1FzZ8ZqvdcEZZTWB1QN6U3Cm5ha626wFCSMyjCvUKBf9ABROiNyvOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/7/30 08:30, Yosry Ahmed wrote:
> On Wed, Jul 29, 2026 at 3:58 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>> On Wed, 29 Jul 2026 16:42:05 +0800 Hao Jia <jiahao.kernel@gmail.com> wrote:
>>
>>> Zswap writeback when the global pool limit is hit fails when memory
>>> cgroup is disabled. The pool remains full until it is organically
>>> drained by swapins or memory freeing, leading to zswap store failures
>>> and pages bypassing getting written directly to the backing swap device,
>>> causing LRU inversion (hotter pages with higher fault latency).
>>>
>>> This happens because mem_cgroup_iter() always returns NULL when
>>> memory cgroups are disabled. As a result, the global shrinker
>>> shrink_worker() repeatedly takes empty walks. After MAX_RECLAIM_RETRIES
>>> failed attempts, the worker gives up without writing back any pages.
>>>
>>> Therefore, when memory cgroup is disabled, fall through with the !memcg
>>> branch and shrink the root memcg directly.
>>>
>>> With memcg disabled, shrink_memcg() only returns -ENOENT when the root
>>> LRU is empty, which means the total pages are already below thr. In the
>>> absence of heavy concurrent zswap stores, the loop then safely bails out
>>> via the zswap_total_pages() <= thr check; otherwise, it will resume
>>> shrinking the memcg after processing the reschedule check. For any other
>>> return value from shrink_memcg(), the loop is guaranteed to terminate,
>>> either after MAX_RECLAIM_RETRIES failures or once the threshold is met.
>>>
>>> Fixes: a65b0e7607cc ("zswap: make shrinking memcg-aware")
>>> Cc: stable@vger.kernel.org
>>
>> How does this affect users?  What behavior do they observe when it
>> occurs?
> 
> I think the first paragraph sums it up pretty well, especially the
> last sentence "hotter pages with higher fault latency".
> 
>>
>>> Closes: https://lore.kernel.org/all/CAO9r8zPVzMKFbCixxD-qgtRrkFxWVrHiZZeLc=eyTPKPVQgX4g@mail.gmail.com
>>
>> hm, that isn't really a bug report and doesn't answer the above
>> question.
> 
> Yeah, it isn't. Probably we should drop "Closes". I assume Hao added
> it because checkpatch annoyingly complains if you add "Reported-by"
> without "Closes", so Hao just linked to the thread where I pointed out
> the bug.

Yeah, checkpatch will complain if it's missing.

> 
>>
>> AI review asked a couple of questions:
>>          https://sashiko.dev/#/patchset/20260729084206.77793-1-jiahao.kernel@gmail.com
> 
> The review on patch #1 is something theoretical, we discussed it at
> length in previous versions.
> 
> For patch #2:
> 
>> Does this batching logic break NUMA fairness?
>>
>> Because for_each_node_state() always starts from the lowest node
>> ID and breaks when the scan budget is exhausted, subsequent
>> calls to shrink_memcg() will restart at the lowest node ID again.
>>
>> If the lowest node (typically Node 0) consistently has enough
>> items to exhaust the scan budget, wouldn't we exclusively evict
>> pages from it while ignoring older pages on other nodes? Could
>> this cause LRU inversion across nodes, keeping older pages in
>> memory on Node 1 while hot pages on Node 0 are evicted?
> 
> Yes, unfairness is possible.
> 
> For global shrinking, it's probably not an issue. We reclaim until we
> hit the acceptance threshold and it's very unlikely this will happen
> before iterating all nodes (given that the batch size is 32 pages).
> However, with the shrink_memcg() path, we only reclaim one batch, so
> there's a chance we'll always reclaim it from node 0.
> 
> Maybe we should just drop the early bailout and accept potentially
> doing more writeback than needed. Hao, WDYT?
> 
If we scan and attempt to write back SWAP_CLUSTER_MAX zswap entries per 
node, it might lead to excessive writeback on machines with many NUMA 
nodes. Furthermore, I'm concerned about introducing higher latency in 
synchronous shrink paths like zswap_store()—especially on systems with a 
large number of NUMA nodes, where it could end up writing back hundreds 
of pages in a single call.

Maybe we could do something like this instead? That way, in the 
worst-case scenario, it falls back to the baseline behavior without 
introducing any extra latency risks.

  static int shrink_memcg(struct mem_cgroup *memcg)
  {
-       int nid, shrunk = 0, scanned = 0;
+       unsigned long node_batch, scanned = 0;
+       int nid, shrunk = 0;

         if (!mem_cgroup_zswap_writeback_enabled(memcg))
                 return -ENOENT;
@@ -1289,14 +1313,26 @@ static int shrink_memcg(struct mem_cgroup *memcg)
         if (memcg && !mem_cgroup_online(memcg))
                 return -ENOENT;

+       node_batch = max(1UL, SWAP_CLUSTER_MAX / 
num_node_state(N_NORMAL_MEMORY));
         for_each_node_state(nid, N_NORMAL_MEMORY) {
-               unsigned long nr_to_walk = 1;
+               unsigned long nr_to_walk, budget;
+
+               /*
+                * Cap the scan at the per-node LRU length so each entry is
+                * scanned at most once per call.
+                */
+               budget = min(node_batch,
+                            list_lru_count_one(&zswap_list_lru, nid, 
memcg));
+               if (!budget)
+                       continue;

+               nr_to_walk = budget;
                 shrunk += list_lru_walk_one(&zswap_list_lru, nid, memcg,
                                             &shrink_memcg_cb, NULL, 
&nr_to_walk);
-               scanned += 1 - nr_to_walk;
+               scanned += budget - nr_to_walk;
         }

+       /* Nothing was scanned: every LRU under @memcg was empty. */
         if (!scanned)
                 return -ENOENT;

Thanks,
Hao
> If you respin, please also drop the batch size argument to
> shrink_memcg() as it's now always SWAP_CLUSTER_MAX.

