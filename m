Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19B0DE73164
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 13:07:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FE476B0095; Mon,  2 Feb 2026 08:07:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 781676B00AA; Mon,  2 Feb 2026 08:07:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 683A96B00AD; Mon,  2 Feb 2026 08:07:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 533E36B0095
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 08:07:30 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1831C1386F8
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 13:07:30 +0000 (UTC)
X-FDA: 84399543060.03.1F1F5D6
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf29.hostedemail.com (Postfix) with ESMTP id 42F3212000B
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 13:07:27 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="D+aw/TuK";
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770037648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rtRt2J+NteIme3evuIB2m7Zz3ToxciDgZMFuOP2gieE=;
	b=XM6lCc608E/+xtEf+Q62fJe4zx9NTmjPX/K2030MbCt0IwFindGBfbQf4uj3n13AH5FYNq
	yUxYHdVgSoOnviVivmenmvb0vsm+PMFzbevNWSrxdbk8a/qfCUZ8TURLsAFAYPcpUzyXKm
	AWUGts3KzIxhPj7UGY+sxpENPZuyTeY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="D+aw/TuK";
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770037648; a=rsa-sha256;
	cv=none;
	b=ztPi8v5Qurl2IIamdabW4obAxmcKCmGH1k26y6NJNNu5kZsALzMHDH3Y3jh/Vswbeiogwl
	iZeJ7yOOUNzpaANW0kOSa6pOABzl5iYOfXbDe4WF1KhTO4V7qp8cWpSpYqKrsEqG+ODcE7
	vS/oAPDbGQzmQSt8O8ceO48L2NNNM+g=
Message-ID: <4700e7ba-8456-4a93-9e28-7e5a3ca2a1be@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770037646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rtRt2J+NteIme3evuIB2m7Zz3ToxciDgZMFuOP2gieE=;
	b=D+aw/TuK5ROJABoMvBj2zE/534Oz1vKJLXvEAqHUd4MV1pSHSiClseUddZQv0N7Sxaau3Q
	dQpodJOsye1tbDd5fadW9kkIegNhZA6SVB/dPRmMyzPBNi+yMtnIdGQPmP78O1gnJpVdUY
	tn9W9eJ65ExTWgYCt0d9CDAUtzFC4bs=
Date: Mon, 2 Feb 2026 21:07:10 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 0/3] targeted TLB sync IPIs for lockless page table
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 aneesh.kumar@kernel.org, arnd@arndb.de, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, boris.ostrovsky@oracle.com, bp@alien8.de,
 dave.hansen@intel.com, dave.hansen@linux.intel.com, david@kernel.org,
 dev.jain@arm.com, hpa@zytor.com, hughd@google.com, ioworker0@gmail.com,
 jannh@google.com, jgross@suse.com, kvm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mingo@redhat.com,
 npache@redhat.com, npiggin@gmail.com, pbonzini@redhat.com, riel@surriel.com,
 ryan.roberts@arm.com, seanjc@google.com, shy828301@gmail.com,
 tglx@linutronix.de, virtualization@lists.linux.dev, will@kernel.org,
 x86@kernel.org, ypodemsk@redhat.com, ziy@nvidia.com
References: <20260202095414.GE2995752@noisy.programming.kicks-ass.net>
 <20260202110329.74397-1-lance.yang@linux.dev>
 <20260202125030.GB1395266@noisy.programming.kicks-ass.net>
 <c6fda7c2-ad54-416a-a869-1499c97c7bd7@linux.dev>
In-Reply-To: <c6fda7c2-ad54-416a-a869-1499c97c7bd7@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 42F3212000B
X-Stat-Signature: ro1wuwxztfatrkafm67741s9qt9656ja
X-Rspam-User: 
X-HE-Tag: 1770037647-373689
X-HE-Meta: U2FsdGVkX1+LIMT9qx2qy80qi+U+sBQJ2GC9iZsIrPO6/Y2R8Q9kpaF3MfzaBOFv4yWiLamaytl+JKV/ExMO6jxGcQvxYJxIFK0ehIlfshFby8MJx3Kx3L5ev3cSGIDI/mvJb/jV1A2YfudD02W9qTc4LzWFGQdWZB0fQj7UIYFViKrVkJLVn2u7uKdw827+0q2RFkID4uBmHp92oCRCPTZZ65N+DJ6zs3g19LN9o/9f9gmj0fZYQaiZF2M7r2S+4DwyKtAWFybeBt0weS3MFrnT43bOgBhkj7fWHR1Sdi9LcAv4xjZmb23dP//1H7KRdKQePceVp0U79Feh4lImdMe7zT8kig/rlYHuAlI9jnmOLUNPm1hKbBEK6o5I2wT+hd7HeYAO1njjtfI137ts9uHDB92sxaWsbfCXutMtlYIntxRlYDoguBQQ5luoqz0jFL1xw5tDz6fxAQ05A4KXH4ozZoByxsrDJ0JVakKDxsZVU2QIfjhj6E7PAUvLi8kyWSZrzFnKdttZULaeRKjJfD6LT+FZQrLEg5bA3y4bpV+7y95FadozaT3S/hJWGrWHVzsqN9bm1SvGXS8QjqhcYSyKTyAhor1vnDRE0Z8Y4ItU7vu03IPij/z5EnD2HxoKt99Fc5xD32wGURwjIdOtlxXnDfFDJfCMY0ryyMtTnGL8yhpQCoOpfKHHngbDSqQkuzbfHSh5G07blk2mw8RQ/JHhnOgjHp29inbvABLqZt1wprYLZbei6tuyecRWhhwXVhqm2IR2cejheyihnOISp7Q+GRYOkLHgDHzxvPrHm6JYTvWDpWXHhmaq665X3WWwf+vq2h1UCTPU2DTBw6v4XGKiBOD9EUoyTmsxoTlBQMMf38cvzy9YoqcnSCN3A0MUaOYhVWMyEX60AjYNQsREbobhYfhIx5sRNaZ+bm4qGmLIHXdVf6n3QzqIrafx2xtJ/ily7vluUuwmppQFnH3
 Z//YWO1w
 Vu/sBFd88GJaNggxKq1+zblKPpKxgUqmyaPr9waS2TUcTaOZVSeZXmJ5Ei5aSpOV9lAY2d6uKHTxE65FCoRqsekgOct8n+oE25Ol7QYZbUFQlN631OOWbPfHJeLi7Znf8kMNJyEN3V4FqHjMZBDaP6DL7RCCeJrCmhOX25rvAxgFDKn3IeN2O49GIm4vw7zQwAIo7WWUX90UlUTDWU3ZizJcmAlx7jeohHzzODSYnkI+dsrs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/2 20:58, Lance Yang wrote:
> 
> 
> On 2026/2/2 20:50, Peter Zijlstra wrote:
>> On Mon, Feb 02, 2026 at 07:00:16PM +0800, Lance Yang wrote:
>>>
>>> On Mon, 2 Feb 2026 10:54:14 +0100, Peter Zijlstra wrote:
>>>> On Mon, Feb 02, 2026 at 03:45:54PM +0800, Lance Yang wrote:
>>>>> When freeing or unsharing page tables we send an IPI to synchronize 
>>>>> with
>>>>> concurrent lockless page table walkers (e.g. GUP-fast). Today we 
>>>>> broadcast
>>>>> that IPI to all CPUs, which is costly on large machines and hurts RT
>>>>> workloads[1].
>>>>>
>>>>> This series makes those IPIs targeted. We track which CPUs are 
>>>>> currently
>>>>> doing a lockless page table walk for a given mm (per-CPU
>>>>> active_lockless_pt_walk_mm). When we need to sync, we only IPI 
>>>>> those CPUs.
>>>>> GUP-fast and perf_get_page_size() set/clear the tracker around 
>>>>> their walk;
>>>>> tlb_remove_table_sync_mm() uses it and replaces the previous 
>>>>> broadcast in
>>>>> the free/unshare paths.
>>>>
>>>> I'm confused. This only happens when !PT_RECLAIM, because if PT_RECLAIM
>>>> __tlb_remove_table_one() actually uses RCU.
>>>>
>>>> So why are you making things more expensive for no reason?
>>>
>>> You're right that when CONFIG_PT_RECLAIM is set, 
>>> __tlb_remove_table_one()
>>> uses call_rcu() and we never call any sync there — this series doesn't
>>> touch that path.
>>>
>>> In the !PT_RECLAIM table-free path (same __tlb_remove_table_one() branch
>>> that calls tlb_remove_table_sync_mm(tlb->mm) before __tlb_remove_table),
>>> we're not adding any new sync; we're replacing the existing broadcast 
>>> IPI
>>> (tlb_remove_table_sync_one()) with targeted IPIs 
>>> (tlb_remove_table_sync_mm()).
>>
>> Right, but if we can use full RCU for PT_RECLAIM, why can't we do so
>> unconditionally and not add overhead?
> 
> The sync (IPI) is mainly needed for unshare (e.g. hugetlb) and collapse
> (khugepaged) paths, regardless of whether table free uses RCU, IIUC.

In addition: We need the sync when we modify page tables (e.g. unshare,
collapse), not only when we free them. RCU can defer freeing but does
not prevent lockless walkers from seeing concurrent in-place
modifications, so we need the IPI to synchronize with those walkers
first.

