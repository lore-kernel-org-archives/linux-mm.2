Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0734606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 07:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SrylrmSI
Received: by kanga.kvack.org (Postfix)
	id E2B926B05B0; Sun, 25 Oct 2026 03:26:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E03F26B05B1; Sun, 25 Oct 2026 03:26:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D409C6B05B2; Sun, 25 Oct 2026 03:26:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B23F76B05B0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 03:26:10 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1B783C052B
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 07:26:10 +0000 (UTC)
X-FDA: 85360314900.17.55D91D9
Received: from mta1.migadu.com (out-110.mta1.migadu.com [95.215.58.110])
	by imf27.hostedemail.com (Postfix) with ESMTP id D544C40004
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 07:26:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SrylrmSI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.110 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792913168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j9KSsqg4A137dhfxHCtQJ3v4H0Z3Fv0RGgyT9sIdyTM=;
	b=2ndjm+nW6qsGRQYwnd89AwY8AZceWJ9ARlKNuOqsUAG0ksZcJ1PXfV7L16xyDRP94CfWro
	2pLBEdG3xWrV8pXv6HO26CHZuAIutXrEU7B1QgDurcO+CyQ7BiPaTLpAZroTyTKAIc4dCZ
	VpN/xvh4Nct+BctQkPa2W6pkadw95w4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SrylrmSI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.110 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792913168;
	b=C6HY7h0VjOaftwLqRw4GGp/xnsnhDnNmIEsbvcqsOHf0YsVZVkf15DLixGekpTuMlipWfu
	dx+d084lUAgebWSITyMEPLm2ooDIL+ggKORye+bCaAJfNMgJMsmmMYtyirCZm8AqvOx2R/
	8jO2o2ZjNQ3XmqpFIMOl7sptUDOf0Xo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=EX8dlYfY5NSf0gGAQukKQCIqou6iNOsLwD+U7YkkxHM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792913161; v=1; x=1793517961;
 b=SrylrmSI51G99gfF6hP20BW1YezhxVFD2E9TcQm9rb+kJyGod8R9UFeYM6oOD81yF6EmKP2a
 Cc7uTvxq0o6eOPxCE4pAEqTqOXP3yM9Z7W4JamGMlFNRx6/ZfN5JtJTLvu3e35ENVW7M1jFEBZL
 wR28/ZW6JvosYCN7CyRmoWgg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 483da7f721b1c77a;
	Sun, 25 Oct 2026 07:25:59 +0000
X-Mizu-Trace-ID: 483da7f721b1c77a
X-Migadu-Flow: FLOW_OUT
Message-ID: <c9df96da-983e-4803-9082-472f5294d50e@linux.dev>
Date: Sun, 25 Oct 2026 15:25:46 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 7/9] mm/vmscan: pass scan_control to
 mm_vmscan_balance_pgdat_end
To: Barry Song <baohua@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Dave Chinner <david@fromorbit.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
 cgroups@vger.kernel.org, bpf@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>
References: <20261019034426.2354049-1-ridong.chen@linux.dev>
 <20261019042308.2372396-2-ridong.chen@linux.dev>
 <CAGsJ_4z7u_PtSkjm+kH7JX_ZZDLSnGr1teHq6By0ovgB23O8_w@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4z7u_PtSkjm+kH7JX_ZZDLSnGr1teHq6By0ovgB23O8_w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D544C40004
X-Stat-Signature: 76rch1dn8f48m5jwgu5t1j3rahd88gyy
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792913164-763744
X-HE-Meta: U2FsdGVkX18hLjKrZndetHStFzPMS1hSehXDhI70dUbqFs4tgnoATJ7MSXLq6Mj31HNMDnbkLaW1IA6TXTXXUMeFNHdONYdl0IWDCGs4ndt5Yoqwp0yDdNVemi7unotNeyvb9UCMsAR8LZZvfjEc4Wp8AZ+rck7q13/KuzwqbURWx9hr4S3Voy7OZ4ktvarwVuvlbOA/OYEDsaTt8UnvVtik2VTx+Up4haxeRxzcNBLNO4CZIbqpT3BUCT41hQPVnLRYUPMuYTsCIpDUToaQA1tAmtab1JiOdkzGj26xhFikRpiWlrPFcbGu3fsW+hN4Y0HT2xCor1HgiuNNO0D7Skz5B/FcADECCFTBLJrUagIU9iG9m+aBrSHMs9KRRS35dwR1FOYtfD+kmVrvLrqNRM+nseCwEdCDDr1+MsCghzc/+UVrYwTXffIwiynS87+n2CG0maLhA1SXQiRdEmnW8EuzLMHHC4cYX+ySfBQCdKO3sHEzr9A4wg0H6LQw4ZX7j+DD9oUhd6vsogb/wS3mWyDYJMPcGquBAVk0tCtRYLnfdejHL0DOEM6LE/caV8cX2WTZk2EeVgeACZZMj5w/UQijlKUvf0wkfaYoDFz0SbHSkACN7rF+be5FfudD206zy5UCrmciW9RP4/gFmsoXpuwz2OTM/AwFfv2nhwOKgwPhMIV33i9x7VP3vQDHO/j8F4Xh3Ji1qBG0W8qUNjMRPh1MQ3FvRr848pqPHlY2qgx483rw7gaEatZDIuPeAUcfZr8Vz54KydE9Jd9PKxPPnFwApqS2vE0hS09wVE3x/ZCdZLR6GXZvSKiazBvVMB4JfBW0owTxKKwK1qfJaTKekv6NiOfJShODg4fplH0KMWY4pWZWAKc5CNcDCUmbCx7FiaXoazZv3ASFlkunGdOV52hpoLTItPmb9MUtC99WEmMgY0v87+ax61Y85JjXoYZF/D1xiT/+9gsYLwva09J
 //ZkeI/r
 gCqzZbpz/moc+2cCktMtVF2m6BH9NtTVWcjINzsMcggOCrM/nE8JtlhhEpwd0GpfjM5LSL5FXcsdUh7qG+5UCvrhAm5oyBFfHgSc2lz3f1f+HWkVvZXM4K3e6tILlhFnLi3kzmFQCkiKFyEiHCTTO1Tgcmmt1Rln8xG9lfJ70n4Ej+XyodU/zH4MFoDp0YhUUMgCMyVeVoRihJkPIMzBg+ulUmyn5pl/gmBvb8k5UdQ9LW8bYO3VfugeTrLrGdJNh/W4AgPBFZEFp9W5P3g28hh/YtgHTkIl8Sbblx7Z3zP2KAtADXqM31hCcRAAJiLC50JVDbS++tgYtB+SDjDiy4M476v13IfdlhRSqGCD6ugwz7XtLX0RFyVY0xg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/25/2026 6:24 AM, Barry Song wrote:
> On Mon, Oct 19, 2026 at 12:24 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> balance_pgdat() passes sc.order and sc.nr_reclaimed to
>> mm_vmscan_balance_pgdat_end as bare arguments. Pass the enclosing
>> struct scan_control instead and read the fields out in TP_fast_assign,
>> consistent with the other reclaim tracepoints. highest_zoneidx stays a
>> separate argument: it is a balance_pgdat() parameter, and
>> sc.reclaim_idx may differ from it by the time the end event fires.
>>
>> No functional change. The tracefs event format (TP_STRUCT__entry and
>> TP_printk) is unchanged, so tracefs-based consumers are unaffected.
>> BPF programs attached via raw_tp/tp_btf see the new TP_PROTO and need
>> to be adjusted; tracepoints are not a stable ABI (see
>> Documentation/bpf/bpf_design_QA.rst).
>>
>> Assisted-by: LLM
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> 
> Could we combine patches 4–7 into a single patch? The changes
> seem a bit too scattered across separate patches.
> 
Sure, I split the patches just to make them easier to review, since each one 
contains only small changes.

-- 
Best regards
Ridong


