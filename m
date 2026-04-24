Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD1C2FDEE56
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 01:46:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C2996B0088; Thu, 23 Apr 2026 21:46:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2736C6B008A; Thu, 23 Apr 2026 21:46:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 189286B008C; Thu, 23 Apr 2026 21:46:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0386C6B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:46:52 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7D913160763
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 01:46:51 +0000 (UTC)
X-FDA: 84691760622.29.C89607C
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5C798C0003
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 01:46:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NkTv6S0c;
	spf=pass (imf28.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776995209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P52wiUOMlzlFIjlIdW/hjb2V5GhJzkN7ef7FawczLxw=;
	b=2M0L+r2pjQ+nd2NdLiId52/cD5fVgKhxMQe4ymq8fz5YdJ9VURk69XsWO/im0/2pl5fFOR
	8yaEeHcLMVF4hTwkuKkYb/3Zkt423+Rzfttp4TznipSDUxU3UILLoBwEQ8/s1XliqZWlz5
	W5uYi2UlY1/Wctg805mquRuvz/XFdJ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776995209; a=rsa-sha256;
	cv=none;
	b=DHp3jywv11BP2ZwDuPb/220N0W2E4vzNG7gJ4ZvfQIEuS2QJt0VL9i99vWA+eY2pZ5reT+
	/Gn1VX82/jLBPGnWN80lNiwkkhFXttywCOQKD0wssEY99n8ZufkJU1ajY9Jw0q0BvywLDW
	/pG6Zsbnx4q85aKldcz1JJ4Af31ZpNA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NkTv6S0c;
	spf=pass (imf28.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <59887af8-24ae-4d29-a637-be13d5d715fa@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776995207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P52wiUOMlzlFIjlIdW/hjb2V5GhJzkN7ef7FawczLxw=;
	b=NkTv6S0cldIfMOVdOltfF4u3hyc2n7q2LgwFHb0ap+JkZwZFeomhWQiT1fMgA+FiC012SK
	v1BtdnaB5WkzR54C6m/i3wCaSZqnGdVeTMLQvZgcbcVymEmLUL+GUDf4mN1NDi7tCc4fs/
	WZqq2QCES2oAAV47dcwIuupUk6mYWPQ=
Date: Thu, 23 Apr 2026 18:46:39 -0700
MIME-Version: 1.0
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Subject: Re: [PATCH] mm/lruvec: preemptively free dead folios during lru_add
 drain
To: Barry Song <baohua@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, vbabka@kernel.org,
 mhocko@suse.com, willy@infradead.org, hannes@cmpxchg.org, riel@surriel.com,
 chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com,
 qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260423164307.29805-1-jp.kobryn@linux.dev>
 <CAGsJ_4ygEvptQy662tTiPm-k+E4cbfvUKGGg3w7NaaALO-F4ig@mail.gmail.com>
 <aequK2ZM3O_7NM1M@linux.dev>
 <CAGsJ_4xy+kGktiePL28DP3PAcVsdnz8Noann2UGhD=EV+3xjqA@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CAGsJ_4xy+kGktiePL28DP3PAcVsdnz8Noann2UGhD=EV+3xjqA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 5C798C0003
X-Rspamd-Server: rspam07
X-Stat-Signature: o1hpps5q5xugy5s1cwzaracjx7ru1w6r
X-Rspam-User: 
X-HE-Tag: 1776995209-461166
X-HE-Meta: U2FsdGVkX1/507qrCgafxmsJ4gI61OsbXggS2x9KOtos64V+uiNV2A2dAnZv7t4ntzTUTT3WS4zzEfTWGC7VT5XK7hr2ltCPvvyPRAOI+w0brYeF4vcv+j+bGJm3yFvwJ7oz2EOK+ltd2xuY4q0bGkID6RpX8VWFXO2Mdck84E3NMJPsjv4sPU3rWavfaDiYgl5KXTF3YNVS8q6/Xx/CdOxTD65E0bO8AVepCoMmUFx26gLPMwEXAoErA3dwfcEOpLJr0LnSJLIjz6c1MdUKO4wft2Z3m4IemCW0aK2JTWhZOOF4t3oz9yNhQR1qAM9uyduvylSvzF60M9goUafjT7zpnBSR48Accqs/unFqel97GM2M/NMdl5q+TBqk4kJcs/HpHh1IqZw6OP8Jgjf6bAQQiptRSJprG1Fc9e573SnbU5ZLab+gqqMD8WumA8nV2OLEhzzOcBeYPjPEnM/X/LoKu/rYa4QZxD33MHHdOU2LLhe9+KrWzgKExxy8DSze4mGQoE8TjgUwYVk1ci8xD5EgzHskHCnVGG+H7dOfXxbMqDMj6lihs5Qo6F+OZmxy71PZya7tTU/qLGeDrx2RgbCwy/n5nlaIwUGRMa0GNuX7F9eXBWypmtTwMhqcVrVVaBsDgQP4SHGH56aQOWCzkOUvPkT2cmjy2Kv7SwqWVtiwEdDaCw+9F+v1MifWbgs3AYzY62tBPpVe0luZRcaDodx8rPvYjliRRqNLryVgMxLb4LNuiWLEXx9kD+iuVkOubBTaop/EtP9fwFcG/DxfUAxaCCnMPVg+CWqIrQ5fUWH6ukuXaWAsHWwdvA6W2FJMTszH1Zb8HF+TS1Om3k1QlKRSnRKESPYn8nsTXjOAj/u3PlZV7/+psSgaXaU76jOYa5ATezFfUaFgg8HDdGasQQyrNGkNxIYcB58Ky/Qn0gFqsAlj0KBWuz9pRGUXWpEhjT+n/KAD4+QTHOwVwBV
 HXho1axL
 Hxk80PKclFB1x4f/twJPxARcjNZ+Rp4uvVOvfwyhLhkoulLm0NWbeCrIGB560dhTrJD5k1OASBhO17D6HL1M4SE0tLYBLcxPz2msTBdvUsmYbjYkfLmeQt1iDJF8cTYOdX5YNYheTtXy5BfAdFo9EV4hJKzTyLb8DqEGtB3nNvQKPyActb1SWPu4b9qTv7L9EL3DG3Fgh2a1f5+zbVxMIFlaGRs7l8egbF7FVGIXsUQ/P2DiJuZa9FnJCRZ7kn7GaVsazCk+MSL4Ice+eWC9JlQFslvAI1FY7hWBHMWVfOOB5X/n/+MPuyjRZlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/23/26 4:53 PM, Barry Song wrote:
> On Fri, Apr 24, 2026 at 7:46 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
>>
>> On Fri, Apr 24, 2026 at 07:22:30AM +0800, Barry Song wrote:
>>> On Fri, Apr 24, 2026 at 12:43 AM JP Kobryn (Meta) <jp.kobryn@linux.dev> wrote:
>>>>
>>>> Of all observable lruvec lock contention in our fleet, we find that ~24%
>>>> occurs when dead folios are present in lru_add batches at drain time. This
>>>> is wasteful in the sense that the folio is added to the LRU just to be
>>>> immediately removed via folios_put_refs(), incurring two unnecessary lock
>>>> acquisitions.
>>>>
>>>> Eliminate this overhead by preemptively cleaning up dead folios before they
>>>> make it into the LRU. Use folio_ref_freeze() to filter folios whose only
>>>> remaining refcount is the batch ref. When dead folios are found, move them
>>>> off the add batch and onto a temporary batch to be freed.
>>>>
>>>> During A/B testing on one of our prod instagram workloads (high-frequency
>>>> short-lived requests), the patch intercepted almost all dead folios before
>>>> they entered the LRU. Data collected using the mm_lru_insertion tracepoint
>>>> shows the effectiveness of the patch:
>>>>
>>>> Per-host LRU add averages at 95% CPU load
>>>> (60 hosts each side, 3 x 60s intervals)
>>>>
>>>>              dead folios/min  total folios/min   dead %
>>>> unpatched:        1,297,785        19,341,986  6.7097%
>>>> patched:                 14        19,039,996  0.0001%
>>>>
>>>> Within this workload, we save ~2.6M lock acquisitions per minute per host
>>>> as a result.
>>>>
>>>> System-wide memory stats improved on the patched side also at 95% CPU load:
>>>>   - direct reclaim scanning reduced 7%
>>>>   - allocation stalls reduced 5.2%
>>>>   - compaction stalls reduced 12.3%
>>>>   - page frees reduced 4.9%
>>>>
>>>> No regressions were observed in requests served per second or request tail
>>>> latency (p99). Both metrics showed directional improvement at higher CPU
>>>> utilization (comparing 85% to 95%).
>>>>
>>>> Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
>>>
>>> Hi JP,
>>> I’m seeing a large number of "BAD page" bugs.
>>> Not sure if it’s related, but reverting this patch
>>> seems to fix the issue.

It seems this was missed since classic LRU was used in testing.

>>>
>>> [ 2869.365978] BUG: Bad page state in process uname  pfn:3a5417
>>> [ 2869.365981] page: refcount:0 mapcount:0 mapping:0000000000000000
>>> index:0x724884c20 pfn:0x3a5417
>>> [ 2869.365983] flags:
>>> 0x17ffffc0020908(uptodate|active|owner_2|swapbacked|node=0|zone=2|lastcpupid=0x1fffff)
>>
>> Hi Barry, are you using MGLRU? It seems like MGLRU set active flag in
>> folio_add_lru().
> 
> Yes. If you are referring to this set_active, I think it is
> incorrect, so I have fixed it here and am waiting for review:
> 
> https://lore.kernel.org/linux-mm/20260418120233.7162-1-baohua@kernel.org/
> 
>>
>> JP, we need to clean active flag but let's check what else can be set before
>> folio_add_lru().

Looks like only active is the problem. If we start manually clearing
flags it starts to feel messy. I get that some fix is needed though. I
don't see this patch in mm-new yet so maybe we can hold off on merging
there to avoid the MGLRU case. But if Barry's patch is accepted, could
we re-apply?

Let me know if you're thinking there are any implications beyond the
active flag.

