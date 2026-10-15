Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58F5CCC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 11:40:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 542596B0088; Thu, 15 Oct 2026 07:40:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F4946B008A; Thu, 15 Oct 2026 07:40:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 408B56B008C; Thu, 15 Oct 2026 07:40:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1F7D96B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 07:40:16 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9EAE512097C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:40:15 +0000 (UTC)
X-FDA: 85324667190.13.9A80A78
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf30.hostedemail.com (Postfix) with ESMTP id 15D0C8000A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:40:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=KMaBtk66;
	spf=pass (imf30.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792064414;
	b=0/eUIY7WLXk4PfU6P9iDLtIU+uFxv1p34pi1c4YQtB8ceZgIDrp+nvSTUD+rsu6ci6a7gO
	2H6GsNAKv42xi/bOBj667iZ9jGjocDfqIoHZmL1rp+8ar7oHa6qyp3mRaXI42dzZ+wmUam
	EyAy0wmADhD96QwR0WmbVRFAIqfhyXQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=KMaBtk66;
	spf=pass (imf30.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792064414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WrIl2V6/+vHdh9lsYXKRb2wtLrMBBxx5uhfmnB2HaOI=;
	b=4+cA0yNgamfT9RwuF6KELoJr40QxkBGsVb3vcaaGhpExYMJ1gXphL77VIk4Uh/jzsvzuFP
	DgyYc57jKLuQol//3zu02AZvyjF0dtalBJsmgsQPqhQGijwI9dHfAdYiCbbdb0wDhLokhX
	3R7M82oFt6VeEVr+1S74Uvx9+gd074M=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792064407; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=WrIl2V6/+vHdh9lsYXKRb2wtLrMBBxx5uhfmnB2HaOI=;
 b=KMaBtk66CUOyRVizyXfwVFkmtoIqA5aJKevCMvzv+ib3u39jeIBs1f6nTEs5DIqOsNpEvk
 GgM3JUescu7U4TGnKW0+5AVuswtaiQ6VERjptDC3Gp/CbCKyDN/dYXu/RcfuYJVpAHIhik
 eTsyZ9no+DEgRKtWU41b6v3NdOqmXjYpke5bnKmXgsO8eQK1FabjXwK/Hhy+uKA+dgz4sf
 k6Z/Y9a1gV5UtFWgUeWl5vBKxwOQRijsWhrcFfUKN8WR10P4dEEVZwjGJAci4+FQXF+Gkd
 KrF+X0s4AHDkvuWzGRdbuajgsYysEjrHKzXq5QKvafrNlJup6auZtdmGFolUUQ==
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>, 
	<joshua.hahnjy@gmail.com>, <ziy@nvidia.com>, <mingo@redhat.com>, 
	<peterz@infradead.org>, <mgorman@suse.de>, <riel@redhat.com>, 
	<juri.lelli@redhat.com>, <vincent.guittot@linaro.org>, 
	<dietmar.eggemann@arm.com>, <rostedt@goodmis.org>, <bsegall@google.com>, 
	<vschneid@redhat.com>, <kprateek.nayak@amd.com>, 
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Thu, 15 Oct 2026 19:39:42 +0800
X-Lms-Return-Path: <lba+26ad0bb96+7927e5+kvack.org+lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
References: <20261014094347.99157-1-lizhe.67@bytedance.com> <20261014094347.99157-4-lizhe.67@bytedance.com> <as9_SwmLxAcTovnl@gourry-fedora-PF4VCD3F>
Subject: Re: [PATCH 3/6] sched/numa: fix scan-period adjustment for shared faults
Message-Id: <9b9e6c92-a291-48b4-a128-c31bc718db7a@bytedance.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Gregory Price" <gourry@gourry.net>
In-Reply-To: <as9_SwmLxAcTovnl@gourry-fedora-PF4VCD3F>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
User-Agent: Mozilla Thunderbird
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 15D0C8000A
X-Rspam-User: 
X-Stat-Signature: a1guoxw15rpaf18qft6ha15zekcxcj51
X-HE-Tag: 1792064412-686139
X-HE-Meta: U2FsdGVkX19fwHLZKKnHxiWt3iLqpmQbQ9p7C/JisnHV/43pDSk95Zu4zGoJbQFOeEOY/jCE7BHG0qXybGifDfRCJ3CurMWkP0M1xP/ihHqxOeh/NztbooSAvQS88kKOvaIXPQAYOnmGvWFwFjP3uNL8yQEcx/vfI4gcYLVvV/ONBwWG3QyFs/zQwbLb3Yfs0PhEqVva0bGPyOUihGcYXIYGxglpt3EWkQLQnRMHQNstQb/0cdQef7R1IDWcL4HG/Jq3UQICoqqztYnuBlbvYoUQs20DyKlY8Q7fhmYK7RDJH7xHbqUElYKfBhiYWwZRhXlAplHNeiMj74UV81DrOkwjYu7A5VrOXt1k/GgfxoiHnXTqeuObAFX4hkolbhWZ7+mD9aYEICSIsGKZ6xS5kBUFlJw75aXAnmxkN2TSXhrSyNGEPXZBMmGYGB0hgOaMDr+RQQ1hCFU4U7+gxZ0tpv5NTAjdWNR6ycVpRbAtM3k08MY7UDOt6lDp7+9vuk0trJFPQBryBhbHWFTW+J1F3JPDCPWqnY1U1WqSPQHnU3aCPGwLpTaME2XSg6CueySKTEir1HBIILgMNN7GBh7WrfFkjeHo+oLcnUUErAELie1sqjOfYdDoC/X1PFu/TML1AGxG7wa1+AJfzQwqlVM9E2I/8Zdk0SgqEakPH+c6qyjf1iruUe2h7+somqF6RReriolcV7WeK44fzbUj8diaZBY+AkU+bfiZ3ngVOTFXTNoL58qZALrSwiJP2iEJyJ4XKe0fFbKfT6oz73NHjVsVhke+yZGx8BWAI2ZKRrKAU3zSGRylowvvQg3FfjE5VKnn70SJSdHD03fOgMR7XATVuab/XXqvfXtmgPwMp61I+D3NVX6UpWKjt8/+SggsgSnAkr0qnYcmedc44mp8DwRC+/Ql/z5wo2G/6Fj3mzvBC8HLCmLq8tq7kuw+HWWxffY+yax5dN6rlEkWamVjpkS
 WdOy8cPh
 dndQYfWYjiyM6rDdJ72E5mzqg+sJMfqt9asXS+02ZIF/bW/VcGvGImAVJudXz4fr4aT5VmSZu3mvt57dScwJ1LJA8XYxrrdDZaxW3B5k5moOR0EOWDQKEuxhSaQg/e94uMv/ie3N5gZM6DPQUqn6oUUpZ4wo5y5rqJK5+8j+je/nvuk5apbdVdWcwOmqb7k2ekdaWj0K0DIUkXwI/a6vVjyUDDnqp0uYg6anGM2qUpLrgjPsmJ+ZMCTkq9uAkHn+4q8GmZ3B5prsFZrT3cCY5+ZEosE2m03Q9GwpZ7soe4vPJdnQxmHGBVU1fnwvxQr30zisX0BlP1rG/OTDlPrjpxVuGFwgPyheNp4jU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/14/26 9:12 PM, Gregory Price wrote:
> On Wed, Oct 14, 2026 at 05:43:44PM +0800, Li Zhe wrote:
>> Commit 37ec97deb3a8 ("sched/numa: Slow down scan rate if shared faults
>> dominate") intended to slow scanning when either shared or local faults
>> dominate, and to speed scanning up only when many private faults are on
>> remote memory pages.
>>
>> The implementation uses the private-fault ratio as the slow-scan signal.
>> That makes private-dominated samples slow scanning, while
>> shared-dominated samples can still fall through to the speed-up path.
>> That does not match the stated intent.
>>
>> Replacing the private ratio with a shared ratio fixes the
>> shared-dominated case, but the scan-period code still only has separate
>> locality and sharing ratios. Those ratios cannot distinguish a window
>> with many remote shared faults and only a few remote private faults from
>> one with substantial remote private faults.
>>
>> Track faults that are both remote and private, and only speed up scanning
>> when that signal is large enough. This keeps local or shared samples
>> slowing scanning and avoids extra hinting overhead when the remote
>> activity is mostly shared.
>>
> This changes NUMA balancing behavior that's been around since 2017.
>
> While it's not the stated intent, it's been consistent since then,
> and i'm concerned that this could cause unexpected regressions.
>
> Do you have performance numbers on this change to show it's actually
> beneficial compared to the existing behavior?


Thanks for the review.

I do not have convincing performance numbers to show that this is broadly
beneficial across workloads. NUMA balancing heuristics are
workload-dependent, and my motivation here was mainly the consistency of
the scan-period decision logic rather than a broad performance claim.

The same concern also applies to patches 5 and 6. They were written from
the code/semantic correctness side, but I do not have convincing workload
numbers to show that they are broadly beneficial.

For `update_task_scan_period()`, there is a more concrete issue in the
memory-tiering-only case. The function currently depends on normal NUMA
placement fault statistics. In memory-tiering-only mode, when there is no
useful normal-placement feedback, it can keep taking the slow-down path
and grow the scan period towards the maximum. I am testing a separate
patch locally to handle the memory-tiering-only scan feedback explicitly.

So I think I should separate the severe fixes from the heuristic changes.
For the latter, I will narrow the next version to NUMA balancing behavior
that is specific to memory tiering, instead of trying to justify the
changes as general improvements for normal NUMA balancing workloads.

Thanks,
Zhe

>
> ~Gregory

