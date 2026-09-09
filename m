Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D106C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 11:37:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 318016B008C; Wed,  9 Sep 2026 07:37:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A1B96B0092; Wed,  9 Sep 2026 07:37:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16A176B0095; Wed,  9 Sep 2026 07:37:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E3B396B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 07:37:52 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A5540C01B0
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:37:51 +0000 (UTC)
X-FDA: 85194024342.02.417CAC0
Received: from mta1.migadu.com (out-78.mta1.migadu.com [95.215.58.78])
	by imf05.hostedemail.com (Postfix) with ESMTP id AA673100002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:37:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F3P79sMK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.78 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788953870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hhNcgP/FB1SrLxikxCtmMPld8+EK1TQc1KwR3Z9HOfI=;
	b=frxSw/QITN2QaCcqfFy5h92tWJpzA1WiXtSwFulYH9w3fVxXNrJno3b0nI55V3+wH4aGOz
	zeCc63zoyrEIvOmEMygitqDW99d81F+SUa0ODNzniTREKOmgKAlOYZarHyRV/fpUBb3D0k
	xSP29VQjsxfbOv5pUdWpbg+KX/gsK/A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788953870;
	b=RB5X+MCp2KEuNhyPWvhL32urSf1HcnxZUqBn16IRlh4y0RDWVb+clRxe5HIWy0YQBpKqgS
	AkXisAJz04u4I/Q0XHdCsHjAOG9rTP8r6UUwE++ndfw51hh1JZnvujVvuW8GChtIjYDiWt
	qe89lPmLzYPGEQwy8UrdeHRWW3Kc7pE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F3P79sMK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.78 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=q5wYplptnPo5g5OG/Ii1Mn6lJkV50u27645zmx+c11o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788953868; v=1; x=1789558668;
 b=F3P79sMK/J9nfLVId4bzB4+fSyZPnw3Ptc6kxobklsRBMKrdFIM88Scd7EE5hml3dYEkEtM9
 0bB1Fb1NvPYFzcDEHvGnNBVvVG5Y1W1IiL1WcEX00r7L5yOTgq3/yLTU5/lFlQUbuLE4qW4rPh1
 qMkldxg5FXYP8LrWB7SwE844=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f492fb48b4208d8b;
	Wed, 09 Sep 2026 11:37:48 +0000
X-Mizu-Trace-ID: f492fb48b4208d8b
X-Migadu-Flow: FLOW_OUT
Message-ID: <16a81e23-cc94-4373-b201-1e9707576eeb@linux.dev>
Date: Wed, 9 Sep 2026 19:37:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/2] mm/mglru: add tracepoints for aging and isolation
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-mm@kvack.org, Ridong Chen <chenridong@xiaomi.com>
References: <20260907042447.2450663-1-ridong.chen@linux.dev>
 <20260908094504.262faa76@gandalf.local.home>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260908094504.262faa76@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AA673100002
X-Stat-Signature: sm9xrr1ms1unbskicuuyn8ybdsqpxzxa
X-HE-Tag: 1788953869-783283
X-HE-Meta: U2FsdGVkX1+6vbqdYiFJZVF3HfYPxV+XBOSb/r0WjZa45xTDD62wIkMILuYuR9uXI0GnXrMN20mNvLsLEw0BDkaP92C5QrAVDXcQfWtHysdt5czhXN76MgRlPQx88YDyt/wcpfh6T2HqEuftEFrFCBN5wieK1lyN3AjIPJDlhnoZIxvbNcccLFhkgKscJsrtm17PziT6XVhK2pornXqH4RFM7Qmgpp/ToC6Nx8BWw6kPHIQkmJQmVcfq5kdCnvvtb25Znbw/3oumm3chcd/FBIwal2lOVOf9YiCBSU3kk9ajjV4K6TihW90amG19GXxl1J/tOKtrjuLLUOTyk8vYYFC1bxcQzaLQVVpu27+lCq3r7N95YFof7k4CRV3kgcQIllnAFvlpD2Cu1EXa+EW8ehDP5Z2miJNfy2sOeprwTgjBBW3ZjTnwxSLQgr7Ydef4g1TYmX7mWzXuq/g15mAAPV5rTXRf3fE8jzvDbiox0Dw7LvRs6ArQ3qhf6SwYjL7ygfCDVbp8xQs+vrhHLgoOgHVYwXDVrAqXiLW4kbPJvsQ7K3ksqz6Fs/DCsBhzruJOn+F9uYvD36f2X/hI2GCi+Rtq6K3b1sys18rzFYS8cPwrtFDwojMfFeS1Mu7VMz+PA7CvrDv8fZGGGuZXF3Y4Y0KWI4etmLjPMLv1n5euhTvhnGeuNTUt/Gk+PG+GIFY8HrHOhd1JdQUDaXm8aAjq5mhAR64SPyJrXGmL3S/vASCLMqugQQzxcHp8zEA6Wie0YUeknjyGx06PNUcbelg3ZX0t+4fesFmggR4FLtnItKeWjYxc1OBNsmoOgFG0RqSPo/3vzkbGHHG7AYHLT5QC8u+ocHSGGkE3vPe0EBquxFVmSWdeq+cXbnP80jUkQRP12H7ay5uW2KDA3KgWRQYPxsoDfV21plQXwEEK/g2tqGI7mab1aGiJOStR0G/32b8bQvbQtv+hx+Wc7+05GV0
 wmmebODR
 BapRuxKx0UvpPR4uWR2juQ77OILBfECJ4uwNRoeVmdQ4PBcdmvQjKx7xxDAWa58NeK0nm/h01lGrcd3Ean1YUYQNwja8pZy9KP/H0F4NqlMJmXvnNIAYEGQpJhzJl0OtNwBJE0LeB3SXFkHxukTAzUwkKX6n3F+MkRSY0l0sZ4bsHlKH3K83DDPoRm8CBuLqGVcCYD7E3HDs+ZbzaAbFAFmrzGA0D2ZEToRhNmeB1fCA8FLg27YeueOygJZeiF/YjU95PKqh80rDBKKe7cPz5NUwQiNm4E+ogzVuwLyriuaCkd4CrhhJhoE14Pj3FkR7NIuf8hs5w6iEDSBUW/IK+QQAeUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/8/2026 9:45 PM, Steven Rostedt wrote:
> On Mon,  7 Sep 2026 12:24:45 +0800
> Ridong Chen <ridong.chen@linux.dev> wrote:
> 
>> Sent as RFC to get feedback on the choice of tracepoint sites and fields
>> before proposing them as stable ABI.
> 
> I'll let the MM maintainers determine the above. From a tracing POV, they
> are simple trace events.
> 
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
> 
> -- Steve

Thanks.

-- 
Best regards
Ridong


