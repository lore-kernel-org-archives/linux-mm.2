Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 680EFE73163
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 12:59:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9167A6B00A6; Mon,  2 Feb 2026 07:59:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C9A36B00AA; Mon,  2 Feb 2026 07:59:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FA506B00B2; Mon,  2 Feb 2026 07:59:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6F54D6B00A6
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 07:59:25 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D26B656064
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 12:59:24 +0000 (UTC)
X-FDA: 84399522648.04.653CB53
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf24.hostedemail.com (Postfix) with ESMTP id B06E418000C
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 12:59:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Zik0SDuK;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770037163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=covw2BPyK8sacnLEewv4QKBXzjC6wkJ/DzN2BwEzgJ4=;
	b=wsiB7tL0pNno8BYIuoCcVKRVgMYX/HDIEbagamltPKviQ9p1cnhHAJ/8cDgqukk6jk9Brs
	lDVkxWbyenc+80zmDe6xRim8Q6nurR6Vew/arq7ld4nhopMpCgOezTSU8PYgUWx2xIbOiZ
	uq0qQfbTxmUeQAkVSqxh5KbIgUE2q2M=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Zik0SDuK;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770037163; a=rsa-sha256;
	cv=none;
	b=4Uipqp1rTZPyLVAOMBIvB5409U6oEOy7kRUeJO4qRi7DW1tCltX3RG68Hyx3laSdD7Jx1K
	DYrdq/lnw11HK5A7/zKWDLpVUy+w18iGDt/48NP2bpDpqzVsA7QBn/nwjd5UHXxNjlL9NQ
	m1vSRGvFOQPJML7Wi0F9BI6MXFuHKdU=
Message-ID: <c6fda7c2-ad54-416a-a869-1499c97c7bd7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770037160;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=covw2BPyK8sacnLEewv4QKBXzjC6wkJ/DzN2BwEzgJ4=;
	b=Zik0SDuKukGMkoBY4OiYAQDGvhqEL+dALU6z/drOGTInLZ1tB4ddKjX0fNVZgTzxPLQ/90
	Hq5fkhYQju6F/Kr97o4bQ5FcxNV+oH3zYlHH9q8tvYTo63d1HktRsCSlvYi7ewtgseKl7L
	vqbyPrSvvOZfEepxweap4WMtVMLr6hw=
Date: Mon, 2 Feb 2026 20:58:59 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 0/3] targeted TLB sync IPIs for lockless page table
Content-Language: en-US
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
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260202125030.GB1395266@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: g67r5mm4n7hacf6amhgoeojb7n49e5jy
X-Rspamd-Queue-Id: B06E418000C
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770037162-110017
X-HE-Meta: U2FsdGVkX1+AYjwjQhui04y9RnI1kcgJoqpgqPgPCDf9KQJXe1MUaS0JSucWmnTsOAqQzPjH1722Df5GTQCihAnLXfwgusmRwWym8t9c7YihBEBOFZU/BLeqRnOQ6c6Wl35IrNqMQj6EDfuGKCPnedtabdFvb24ZV6Q8XIeZWIJSm7GpdCanomFolcOTG5DwPLD8kvHS/AnkW5tuxuCJyufadQLQimsMWuXOj6/lYCjek9xAvgaf2f50AbABsB06s2PvPbMkvCfrZm+hbRVQc+HJXsNMhPPqAOQadL8mDvUtng9vZmKl8A6+Lj/egtcj724PlEzaltfeAww45zdf5SqRa1HoUXNEV7XPbB4NN9JtHGikcRf1sZXNCpviioAHuQmrvq28M0YKUbPNZNth8UhH1iHtPw6i/uJdO329u/PaU/GgkqoJiMqsKo/Puo/RCl7HedBBmnbCpjl5gN9yYUH9aD1GpsSRyiFcwI2vf3OdElTM24t7VdiYW2B7MCpWgSbTIU7Q6O55/qXbDz2tUn4+rmkdEiIBAqndXxv1/khRLRRLRV4GyFy1t/nK83SOewC9c7R7XBABSDpJCbb6xpm9KprtMrzlDlYgUYEbLb+NdNuFfX5iW7MQcSof6xss3pSarf0NLTsHifezugyE2fWlubteTiJGNnKF+LWJCACmnK4BZUZkPMNojWOH0hU88E325eMJrbnq3Vw9ZwG7OLqawiB0wQooN6rUyPcQ/YCxQVVE+ylqvWybp6ejzIT7Lh260ULBZI6COfvjvHgVxwk26MUvOJODjTSMZ7OJ/KWWQBcB/SIZ3ofdvLis9XYIhuIyszp78tG8BpGwPphe+QFOE9tdXM+PwfCGHZtFv5kGBYXANpu3xqS9AxCPRSQIbaU13TQlvWIerLRtcd/mnUF75w1h1XqrlekkCSo483405LAT32M7Pe9u+aKVzAd3tHaNuZtao983CcytwQV
 Vece17JM
 c8oFbiGnP8XVyMay4gSCteM/uFOAaRYqBiJq32Hutjv2hBdJdw0A2u5uDGylWFrtvBK0YrSJ79nCyU8+zhbB5iyGPjCBvsFaSiw4jwKKHoVgnbdFkXWxDC/fjxAkUc6cpfGPBKEAYprDDh3G05tfidvFkPmPbLp+j6rwahqa08p3z+9bLEiaEmvacqoLTotQZIU94nTINP8epbyq30d+1R3sM18Mq/a7+GwwPfCjSgMXanmg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/2 20:50, Peter Zijlstra wrote:
> On Mon, Feb 02, 2026 at 07:00:16PM +0800, Lance Yang wrote:
>>
>> On Mon, 2 Feb 2026 10:54:14 +0100, Peter Zijlstra wrote:
>>> On Mon, Feb 02, 2026 at 03:45:54PM +0800, Lance Yang wrote:
>>>> When freeing or unsharing page tables we send an IPI to synchronize with
>>>> concurrent lockless page table walkers (e.g. GUP-fast). Today we broadcast
>>>> that IPI to all CPUs, which is costly on large machines and hurts RT
>>>> workloads[1].
>>>>
>>>> This series makes those IPIs targeted. We track which CPUs are currently
>>>> doing a lockless page table walk for a given mm (per-CPU
>>>> active_lockless_pt_walk_mm). When we need to sync, we only IPI those CPUs.
>>>> GUP-fast and perf_get_page_size() set/clear the tracker around their walk;
>>>> tlb_remove_table_sync_mm() uses it and replaces the previous broadcast in
>>>> the free/unshare paths.
>>>
>>> I'm confused. This only happens when !PT_RECLAIM, because if PT_RECLAIM
>>> __tlb_remove_table_one() actually uses RCU.
>>>
>>> So why are you making things more expensive for no reason?
>>
>> You're right that when CONFIG_PT_RECLAIM is set, __tlb_remove_table_one()
>> uses call_rcu() and we never call any sync there — this series doesn't
>> touch that path.
>>
>> In the !PT_RECLAIM table-free path (same __tlb_remove_table_one() branch
>> that calls tlb_remove_table_sync_mm(tlb->mm) before __tlb_remove_table),
>> we're not adding any new sync; we're replacing the existing broadcast IPI
>> (tlb_remove_table_sync_one()) with targeted IPIs (tlb_remove_table_sync_mm()).
> 
> Right, but if we can use full RCU for PT_RECLAIM, why can't we do so
> unconditionally and not add overhead?

The sync (IPI) is mainly needed for unshare (e.g. hugetlb) and collapse
(khugepaged) paths, regardless of whether table free uses RCU, IIUC.

