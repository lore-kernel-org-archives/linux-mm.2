Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35B4BC88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 19:36:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F32E66B0092; Fri, 11 Sep 2026 15:36:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE52F6B0093; Fri, 11 Sep 2026 15:36:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD1E96B0095; Fri, 11 Sep 2026 15:36:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B515D6B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:36:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 40E09A3612
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:36:21 +0000 (UTC)
X-FDA: 85202487762.09.9324B9C
Received: from mta0.migadu.com (out-157.mta0.migadu.com [91.218.175.157])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1B53520002
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:36:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="I/QUrGAl";
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.157 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789155379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LZIrsjaeNx8zQaEJ8wnArPLWi8EOHvxNP5+2egmzfHU=;
	b=ATSJGLFK8I7OJRu2tLmFwsopQZPD0XCKYU70lWmlw98YrP4emxfkgfy/xjxwehM8dnYA8e
	/CxVRFMRicJPL+Z4Z+aBTBpIttynUpXsS+GCPnGYDgQeiIHrI/Cr0C8Jt3yDyiKymk0eId
	4uBu2x8M4SHYylOEvGUPUjXWZUFLSYs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789155379;
	b=8Fs+2fgmZ1e7+aseSXXeRfrtqEff3gU0TvW/CexzTfP2B2B0gOxRseno8PEgwAE/UXlp3t
	Yb3fjS6/DpcY0fmccmoEYn3QDtWZt3+/ZmkdpRaIWwGbg5wrYjJsLCWNKfpJt7SkXBv0ff
	MRbR+xsGebsmqT5DlLfaZcH1RJTuLuI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="I/QUrGAl";
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.157 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5axUg2fGvQSR87hlCNMrBXF6myPM/7xQ+ipU/f5bq9M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789155374; v=1; x=1789760174;
 b=I/QUrGAlUsfm1o9sIX9LcW4TYrrzzwwBJdUBskLmhCtzevu5HOF7uQP6GeE+VGc7+TqLN7Kp
 Tv8xQHLwB2Jwm2ByZuP9NL4Hm6E6B4EUtg/c5b4n7D+6fljv1Ktv2YXDJwchl54c8y8yYSUxxSP
 KJk4FGdymXlIzuOEUTgyahaA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 199cd7cb081f703c;
	Fri, 11 Sep 2026 19:36:14 +0000
X-Mizu-Trace-ID: 199cd7cb081f703c
X-Migadu-Flow: FLOW_OUT
Date: Fri, 11 Sep 2026 12:36:12 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Runli <mingyu.he@shopee.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry@kernel.org>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, littleswimmingwhale@gmail.com
Subject: Re: [PATCH] memcg: keep propagating stats updates to ancestors
Message-ID: <aqRXqcynCx88D2QK@linux.dev>
References: <20260911032905.63683-1-mingyu.he@shopee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911032905.63683-1-mingyu.he@shopee.com>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: n7bxn8orr5mbci7ood69b55c66d56r36
X-Rspamd-Queue-Id: 1B53520002
X-HE-Tag: 1789155378-355278
X-HE-Meta: U2FsdGVkX1/kpPpjWAAj2HW/NgEZL4d01eCPgwiC63eBciKW9cEIZxPGchtLk3HlDKLYO5Fgdh2IkKEcCtuiOrTab2BrK1ghehK3kR4XDkcNsErFYKk8tNK/HFCjqI/NZikm9dYvoTY8bTzuQn+LBc04mQ1KFCM8fwtyDzQWLGlh1fTluLd8tsnbSrNs3VRC1Jau5YTODvk7dhFB6VWukXnG0sSUpaRWZeeMWFsNM7B5USgCqEd967Xa6I8tIjKfG5T6dw6D2QIGRUD2HV/c33W/jiIAHA3aL+VuxZFRZW4/4/pVS59Y4rA6aijJxukHEJ+11J4w8oQvV5bg2Q4QzXvtcH3Yeyk23F9sNckTuVOxGu3BP9vwZJTOkq3FW8s/oiSwmwoKWak8/iBWuuH88ThNGkR+TOc0vP4MtIlYbr4CAzuEQo+r+Q1Wp67PSZKcyYoZg4IDRq9OcDjyN5nvRmQlt6C1cpvm5skyroBfgb8FlygmGM3BjqWBqT5yC4MzlwzZ+t711r1muhaVjWJzqInUzUnSXwbwIz6zn8QI+5+dRrYnFytg1FY1sDWtvwS51SE6wA0cKK0s2PzxMq35Jv6kAZHfYxT/rJ6JjSMwRzwnJTc/vF7imNR54sfoSooYrIzqLZ/kaVD2mO4pN0HEvzTiIQC5Qwua3PkC/ES6Rpn4gkbGtWK588OTJRTA+NvnRc9x38lwqm6ZiqHP019kJdsJy56piS/Ueu9rrsJzk1UGwfbERvszKHsf5tp1ENPJjIFRK7r45q20dzNLScglHCiTxUYgA1bgRGQUuOtA7QrVQlV1YgODzY5CwS1GOnh1ZGjTFqBQgemfbV/HMO56jSqq7f7dWNUoNjLL5XEeQqTRzlM6c4Bt8kly0jR7p0vW0LYEBEXrDbklgJ6DB92Om0/at2SUoCRwTd+csnoR4Lx1AwfVk7Gm19EQ2mBsChvjU4bVMZV0a779s7h3+i/
 j95FaIqs
 30dob5+rqaXC/l+Zn9uPJRkZ/endXX/TsoIf9GG/WzjT6CI8SusZn7656iabJNdfzkwy9NMeipip40JHqkO+7Z05ToTnoRYyvC0d6TPc118vC9pwFv8WMOxreDuan6AMG4JSG6mMInB2kzt/j0e6hQKvb5ULH/HH2b+O0ozegS/79FDNNfh0NbivK6Xu2AKOS7mjbx7sSLvSmvK5oqOCdZTyaesVcKr2PcxUJSjO/yOQToaZ6lv8UziaLAqFQReJJM+TdmjnzxsdWICr9jimfeR6HgFgN5pUWuBAKikF397GJYovP8mrvF7Ugr98et07SiN2g+YaUuL9U9JY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 11:29:05AM +0800, Runli wrote:
> memcg_rstat_updated() stops walking the ancestors when a memcg exceeds
> the flush threshold. A concurrent flush can leave an ancestor below the
> threshold, so the early exit prevents it from receiving further updates.
> 
> Consider root and leaf on a 4-CPU system, with a threshold of 256.
> CPU 0 is flushing another CPU's stats after CPU 1's stats have already
> been flushed. The counts below are shared stats_updates counters:
> 
>   CPU 0 (root flush)                CPU 1 (leaf updates)
>   ------------------               --------------------
>   clear leaf->stats_updates
>                                    add 64 to leaf and root
>   clear root->stats_updates
>   finish flush
>                                    leaf = 64, root = 0
>                                    4 more batches of 64:
>                                      leaf = 320, root = 256
>                                    next update:
>                                      leaf > threshold
>                                      break; root is not updated
> 
> Root remains at the threshold, which is insufficient to trigger a flush,
> while further leaf updates keep taking the early exit. The periodic
> forced flush restores progress, but until then the root's aggregated
> statistics can fall far behind. For example, page cache grows at rate of
> 1 GiB/s, a two-second wait can leave the reported usage about 2 GiB below
> the actual usage.
> 
> Skip only the flushable node and continue walking its ancestors, so each
> ancestor can accumulate updates until it exceeds the flush threshold.
> 
> Fixes: 60cada258dfe ("memcg: optimize memcg_rstat_updated")
> Signed-off-by: Runli <mingyu.he@shopee.com>
> ---
> Testing:
> Based on commit 893e11787f78, with and without this patch,
>   using 32 concurrent instances of:
>   netperf -H 127.0.0.1 -p 12875 -t TCP_STREAM -l 60 \
>           -T <client_cpu>,<server_cpu> -P 0 -v 0 -f m -- -m 1024
> 
> Both netperf and netserver ran in the same leaf memcg, directly below
> root (root -> leaf), with memory bound to NUMA node 0.
> Each kernel was tested for five 60-second runs after a 10-second warmup.
> 
> Median aggregate throughput decreased from 107.26 to 105.23 Gbit/s
> (1.9%) with this change.
> 
> I think fixing the correctness issue is worth the roughly 2% throughput
> cost.

Do you have any real world or production data to show that this is an issue? I
would not change anything unless there is real data. Also we have periodic flush
which will fix this (I have not looked deeper into this to see if this is a real
issue). In addition we have bpf interface for the stats for users who really
care about accuracy and efficiency.


