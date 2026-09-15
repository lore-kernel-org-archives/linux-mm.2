Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22833C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 05:35:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30ABF6B0088; Tue, 15 Sep 2026 01:35:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BD316B008C; Tue, 15 Sep 2026 01:35:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B0556B0092; Tue, 15 Sep 2026 01:35:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E920D6B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 01:35:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E3F1F802D6
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 05:35:28 +0000 (UTC)
X-FDA: 85214883936.21.5D2CC5B
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9B65640003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 05:35:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=CDGtsvn1;
	spf=pass (imf11.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789450527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OYhi4NJVlhoOAQ0HdJzU0jvm/8c0ymeQ0nH4iCFec9U=;
	b=dRScN/0ikKsw6YIn340UxVxSyO9ZCblDMd4OETHjPiqla/wcCqadsROXa0myMsCFzhCe2F
	ffg0caLctBesrMVRqZC19qmmoofJ+yELiNn6/eJR1U0hLUUIu2sEesOZ4KHieCTw3KuBko
	j9D0ymYEUiBDnLUajhG+DfO8uhQkicY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=CDGtsvn1;
	spf=pass (imf11.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789450527;
	b=6X1k+k3EtTuW8SXUecgI9Pzd7IgUpqxvndqAuJrSpqE+HpGmpZZi0XH5HohSRtQlWltRwi
	iPQy/6VPGFz9inoS+cBnR97HVlfPOCTZpQly9HSMXD/4AWcu2rurKtAOYTpwH1i4n6jxiC
	db6KWUSu831aTJVgaCyxyhKb0n4xZTk=
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccc09d65so2753557a91.3
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 22:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789450523; x=1790055323; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=OYhi4NJVlhoOAQ0HdJzU0jvm/8c0ymeQ0nH4iCFec9U=;
        b=CDGtsvn1NB887hRkPYcY1Q6gx7YXVBg0hcvCM1MRg1KUR3cem49f83YuvZeeJ+G9hU
         VaADbvMXU8ImsbxdyvvEalqlqIuVwrN/yF82pEsv+ciJ08jUG38BbJbJrsKd+n72DyK5
         GpKS6sSFwBpXA119TL37F3Xrt9mHgvHscx7gwCyfjBDj4BZU1I8mi68Rgtp5FMSH8NPj
         XrqHdygcQ0S4//FrmUYja71FgaWkfb2sqN96HQifn11OatCLqSSU/pKCqw2wNezHBmiC
         M8CQlWLbsdUwlvfLolX+BxZUhxGRgnnwk7dk6MTw4+DxKwbFleeJYkK9qQzvZS1/v3BC
         t1FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789450523; x=1790055323;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OYhi4NJVlhoOAQ0HdJzU0jvm/8c0ymeQ0nH4iCFec9U=;
        b=JivE8O8YC9enMlV2Ar0bqwFRdDPrYj49nRBxI555GbEV4jUZkLYB8CjHLRUrBJncv8
         boA856+E3S82bDJHlcEjXXaqetArbMRnqYeJGYZT2J3uAKZDjraZKq7t9ibBzA+xGw6d
         sPa3JIrlyBRb8ibKl0AoFBijTvDPduGl4JLF613IOQPNmesYXXTvXp55jdXSsx3K+QnU
         taMnkWZJ8D43GTphZtudiCfUtQRFS1O3aWSEJm0ZA1SHnLMJWWxSPgCbPVrNcsA3suDs
         vAHvyFkTJn9Eq+Zb02ONZCuu/AcxypAfIYA9FzhxQX9okCmZpNJrc5Q+k34n/TNqYxcf
         fAMg==
X-Forwarded-Encrypted: i=1; AKwUvBw5sa08g7i8DQilmkO0744EhwRjjIYvDb6TPEVxLwSUohsiXBhyySnTCY5B5Z5QeGz1xyBFLNkccg==@kvack.org
X-Gm-Message-State: AFuF++miK2+qgHlRNqLu7W9f0QNYTtfsHBcN3dfqrW+o9VKW80du1PGk
	mmK88KFA7HIiAdCLTwU1ZkRN9/jd8wf+FZihLuYwZtKdziz8bZ6Mp2D/ygDyF+lI5zw=
X-Gm-Gg: AYBFou32xIAXINIEaXA3CsnzTOsT0z3WMXnzZh0UThHqlXaZ7MzllTJ+5UjRZpg73cf
	++O9+bcD8zpsrH/ehxj3YziOSm2TzUq0RAkFBVcSvJOxsGupoLDhMpr9NWJmeyubxxycKYyA448
	immN0NZqYW+Q0k+dpI9M7Vn4/d5+j8mQIg+nj+l9QTppuLoV6gwLyA+WGZjMVB5gWMgEKb/xrQU
	BwPjHCCGdLZWxTbJINOp4DhHBrPxzsSKEtrbr/A1BymGgpoTz9fiB9RH1fWHLCZOt5pUkGs/X5N
	+pfwGaXkRsiYi7skv0TdP6DKJhTAg3o9ijynl+gE5TIvaCzbQyHUsfKAhuH/XcEYsdTnF2Bx5nx
	RcMyo9F/M2Icel9x0wdQxuj78ko8Ic61bLxsxTJ3+8dOpRQpB4o3VSZtgCjff+9p/Jc3WxVv0fb
	7KAq40FWHb7rCdsQrQ2sBVHqKYVQ//PpTFJfIIyhDv7ijUugov+wOwsfaULxakYwVN/F0inOtqm
	yW4lHDmslYJjfnU/kch8atVYW4zkJatJUnkPYiRJlY=
X-Received: by 2002:a17:90b:4d07:b0:39d:f6a6:60d8 with SMTP id 98e67ed59e1d1-39df6a66122mr7696866a91.3.1789450523152;
        Mon, 14 Sep 2026 22:35:23 -0700 (PDT)
Received: from [100.81.12.150] ([61.213.176.56])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39dfdd28acbsm2912867a91.10.2026.09.14.22.35.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2026 22:35:22 -0700 (PDT)
Message-ID: <eba0295b-268a-4573-aeeb-de79b9ca6063@bytedance.com>
Date: Tue, 15 Sep 2026 13:35:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/3] memcg,writeback: flush foreign bdev mappings
 separately
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 axboe@kernel.dk, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 willy@infradead.org, jack@suse.cz, rostedt@goodmis.org, tj@kernel.org,
 linux-mm@kvack.org
References: <20260914103119.1708452-1-sunjunchao@bytedance.com>
 <20260914205947.5aab9d7261ef0f26ec8f3213@linux-foundation.org>
From: Julian Sun <sunjunchao@bytedance.com>
In-Reply-To: <20260914205947.5aab9d7261ef0f26ec8f3213@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9B65640003
X-Stat-Signature: 7hic8grsx7o5sfjaye1n78wbitz5jjib
X-Rspam-User: 
X-HE-Tag: 1789450524-595110
X-HE-Meta: U2FsdGVkX1+drakLWKSwsjsFeUVKZSJRChh9qOIP+tyeIvmW244eAHBUrvCfKik4ejovsPuGPnJ0MXc+LnZNCPWQ3l9Tr6sOctgYD91LHyiCWGv09zAPfVROR0Yz1zJI91pp8uDuz5C5bswrl8oNDoL3A3sKKMZsPFHK+CuhV1AMCzfBHo8GcFUul7DmPavQO745drPcjDv4m5i4UxUt2bcCmmtxkIbmBvDTkRoqhMMM6YeeKTFK5NrGarFWplZayRKmSVE9NNpJB5kqnE9lFLI9dWDQVSnVnlLx3wpJ4vUbHJd6SFygocTpyIDmxOgpcAOh51eChek12Dksg9/4sR+sFR8G3qMMg3x2VIku6QFe8uFt/6cLA4Y388g7aoFhWk+zh+qf4cAnLAGXUYgSpIxt47m7ZnAh9DSwklSAfqX3ish0bNJ3HnZ5vXONn9aab7EbBxkm7jXahdLGG3cgnQnRposL5rxTFH9JiVJDWTKSmaYrpItMsi1/SMIqEs3dqzH4Bar4iQ1CN7bheqWMEeDmv/woUesbwjLtb5MNocl8hsUJS1T+U2IPjI7dUsZLIBgr/ax6SnczzkkqngzyNdjrgRf1WBiL2F3BYF6hlkD9MLN4j5/H6bItbzhKfVGyrNfRvG+eIo6rHOizn2p4l42iZESCdHXzbp8Jo+8u6E6pDxvMqzrwwwJTNkKFpRToBYDrLxy9QGV+9c3pyAkE8kyHvZf17Qt1Vcirb/ENF2ZRCMdIS+/+xFrGTR1myWjneca1BEx7BTCqmZf/0JpI0MLCRiiVKR3qQT59c//LhODZfWJ/q7mzf+T9GKGYng1rbEY8vRWRriafvdTiwFzsyB2FQrhX5x+5J5k6Ec8wLT+E0/Cnl2GC3/1XywKAYHOlix1BKn7HdKc4m9kF8IQl10zZnBpUmNnYf6OHCPRB2fi/3kzjgIA5FSb7mKcqPduG8D0CipWGuSFQiu7vD1R
 XXoHB2eU
 S9N+k5T86/MJTLaaWNx3H6sy5YVfG4n+ZZu/AZbe2s9rQkPiaNzghV5e7mfos5ZdsLpuoyEqvXUB4WUjiDh4RkkOq4VaIOPJnYTLqjXRcA92C9De80fffPBiMlJ79gwvgVF5MTmdrcZph25clmmEhFFQGQxnjGs+fLBr0dzISnKk71w6jciglFyZERaOuwIQLPa8fzqoclX7Jct/RurzECayyWX2gk/kPTQtMP0XJ/ZKl103gmBYHCxRqUbQIXZrLUuzCOUuGrtZEhKVCexDty0Br5fr/Fn5inbOroCqaS3ihGlf1x545+ofowz/QfE+YmeJSc9BE3DLF6RVoZvjZIvW1Gqz+2zsfHZShiDdVHC8COUc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/15/26 11:59 AM, Andrew Morton wrote:
> On Mon, 14 Sep 2026 18:31:16 +0800 Julian Sun <sunjunchao@bytedance.com> wrote:
> 
>> Bdev inodes are routinely shared by multiple memcgs. Recording their
>> owner wb as foreign can cause dirty throttling in one memcg to trigger
>> writeback of unrelated file data belonging to that wb.
>>
>> On one production machine, bdev mapping snapshots showed as little
>> as about 10 MiB of dirty data. A queue snapshot of its owner wb showed
>> 599 foreign-flush works, with an average requested writeback budget of
>> 43 GiB per work.
>>
>> In other words, a small amount of foreign dirtying in the bdev mapping
>> can trigger owner-wide writeback requests, whose budgets averaged
>> 43 GiB in this queue snapshot.
> 
> What is the overall runtime effect of this?  IOW, can we see some
> before-and-after numbers?

I tested this series using a QEMU/KVM VM with 4 vCPUs, 8 GiB RAM,
cgroup v2 and ext4. Virtual NVMe write bandwidth was capped at
200 MiB/s.

A fio job repeatedly overwrote a preinitialized 256 MiB file using
64 KiB buffered writes, at 64 MiB/s, for 9 GiB of logical writes.
Four memcgs, each with memory.high=32 MiB and io.max=2 MiB/s, generated
metadata and buffered writes to trigger dirty throttling and foreign
flushes. Concurrently, foreground fio performed 16 GiB of sequential
direct writes using 1 MiB requests and queue depth 32. Normal periodic
writeback remained enabled.

Three comparison pairs, with alternating execution order, produced:

Run  Kernel   File I/O (GiB)  Time (s)  BW (MiB/s)  p99 (ms)
1    base              7.19    114.74      142.79      1434
1    patched           1.57     88.62      184.87       480
      change         -78.22%   -22.76%     +29.47%   -66.52%

2    base              5.13    103.59      158.16      1434
2    patched           1.74     88.65      184.81       497
      change         -66.06%   -14.42%     +16.85%   -65.35%

3    base              6.14    109.27      149.94      1434
3    patched           1.73     88.68      184.75       480
      change         -71.77%   -18.85%     +23.22%   -66.52%

File I/O is completed block I/O matching the overwritten file's extents,
including final sync, not requested writeback budgets. The other metrics
are for the foreground workload.

Across these runs, mean file write I/O decreased by 72.7%, foreground
bandwidth increased by 23.0%, and completion time decreased by 18.8%.

The baseline varied noticeably: runs with more writes to the overwritten
file also took longer to complete the foreground workload. With this
series, foreground completion time stayed within 88.62-88.68 seconds.
This is consistent with preserving overwrite coalescing and leaving more
device bandwidth available for the foreground workload.

> 
>> Following Jan's suggestion, this series records foreign bdev targets
>> separately and flushes their mappings instead of their owner wbs. This
>> preserves a way for dirty throttling to initiate bdev writeback while
>> avoiding owner-wide writeback triggered by these records. The existing
>> foreign-wb mechanism remains unchanged for other inodes.
>>
>> Tracking is best effort: each memcg keeps a bounded set of device
>> numbers without persistent device or inode references. Closed devices
>> and devices with a busy open_mutex are skipped. Device removal and
>> device-number reuse may race with lookup.
>>
>> Flushes run asynchronously on a dedicated workqueue to isolate these
>> frequently triggered tasks from existing workqueue users. If workqueue
>> allocation fails, the existing foreign-wb mechanism remains in use.
>>
>> Julian Sun (3):
>>    block: introduce bdev_flush_by_dev()
>>    memcg,writeback: flush foreign bdev mappings separately from owner wbs
>>    writeback: record bdev targets in foreign writeback tracepoints
>>
>>   block/bdev.c                     |  24 +++++++
>>   include/linux/blkdev.h           |   1 +
>>   include/linux/memcontrol.h       |  15 ++++
>>   include/trace/events/writeback.h |  22 +++---
>>   mm/memcontrol.c                  | 113 ++++++++++++++++++++++++++++---
> 
> I'd consider this a memcg patch, and not only due to the line counts.
> 
> Please cc linux-mm on memcg patchsets.
Sure, will do.

Thanks,
-- 
Julian Sun <sunjunchao@bytedance.com>

