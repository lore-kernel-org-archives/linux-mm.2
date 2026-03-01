Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBD9CFD0055
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 06:56:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEDD26B0005; Sun,  1 Mar 2026 01:56:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9AD86B0089; Sun,  1 Mar 2026 01:56:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA6D76B008A; Sun,  1 Mar 2026 01:56:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C569C6B0005
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:56:32 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F38AE896F3
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 06:56:31 +0000 (UTC)
X-FDA: 84496585782.04.EB3AB15
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf01.hostedemail.com (Postfix) with ESMTP id 03F3F40004
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 06:56:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EMKrQY7W;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772348190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7jVbiQXIQMX/1B8+z3NiDZcVvND9uVKdGlGO2tuqfdM=;
	b=LyHXKhgEmvAIcqjxp5Fm4Jggii9l6GFQEB8e+bC23UZb5o1d1/35vMABpHKDUq3YVpzmpb
	Wb5OaSfh92+v6xLbQ3BDC5/B8gFXNWqvczvHUQufPKjg+DdbcJJD9TgTGkKVHL/hsKKrib
	9aD6cXnbIw7VufIf2QB2YMcm4NkjEpU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772348190; a=rsa-sha256;
	cv=none;
	b=rDsBDjpmzXgcrfr81+g8oXQjYWePBIi8/w/jxD9Yk7H8AnUlg81BwfP8fAB8ULJ0G6Rt0R
	krwQ5hu63T51ydruQh+CZi3RHgWwxTlchSgR2HLl3jEPJXwBIYxe43udKIKiOcITJcZcEQ
	6WLLAdszZs0/9UWSf9UDuoirwuWgnXI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EMKrQY7W;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
Message-ID: <7454cd72-3816-4a05-89f1-ded8b99acb41@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772348185;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7jVbiQXIQMX/1B8+z3NiDZcVvND9uVKdGlGO2tuqfdM=;
	b=EMKrQY7WRXO8kYWzx1xdMTU5rEVlMVp9IHizMuBLddZGHk9vGaaiFIPCtNKy/esjK1Fdcn
	0f4AVHD0lMvSwDLyupaQdautjy8Z5F5qRfp4hQHxi2VKY2kFJD6nVSIzo6ArC2A9XtumQ+
	DuHdDT4XyvQvlIfnfHqthTSkSmlZAzA=
Date: Sun, 1 Mar 2026 14:56:14 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 3/3] x86/tlb: add architecture-specific TLB IPI
 optimization support
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: akpm@linux-foundation.org, david@kernel.org, dave.hansen@intel.com,
 dave.hansen@linux.intel.com, ypodemsk@redhat.com, hughd@google.com,
 will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 x86@kernel.org, hpa@zytor.com, arnd@arndb.de, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, shy828301@gmail.com, riel@surriel.com, jannh@google.com,
 jgross@suse.com, pbonzini@redhat.com, boris.ostrovsky@oracle.com,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ioworker0@gmail.com
References: <20260202074557.16544-1-lance.yang@linux.dev>
 <20260202074557.16544-4-lance.yang@linux.dev> <aZ9Xcgxa0_ouGr31@google.com>
 <e3cdcbfa-525d-4e0d-885a-8f7d69a7ee3d@linux.dev>
 <aaCP95l-m8ISXF78@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <aaCP95l-m8ISXF78@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 03F3F40004
X-Stat-Signature: crtmrkchftpcg4z7rrq7fh4qs4th8d5j
X-Rspam-User: 
X-HE-Tag: 1772348189-9028
X-HE-Meta: U2FsdGVkX1/+HOZDf2QnB+odTplCZmYGQbPHMOGmQlSJBmE+QP2gcV/NKVJpm17O9Td8sRbqtW3YdnQAa41SnIsy1BBc/yBC3SLxgJIl5LYodHkJmDMMWQ5zKM5n0mPE9KTh0JTAPGJR+aooDFdf1D+Q5+fB02gB10f2ov0g8CnvrVD65LOdx8kQZoznq16VWSNtkKpvKSnCmJHdOFhpbgZF4dC5W2k8OyyXpCtgrcnH3Y3UkbDu52pBhYirbnp88eJG0ypbsdYgyjQqnJGDpdym3l2tFlW2cRroRoOiYYeqSiz+WMzVs0/HYbhRtr4Jeg8fnk2ZIYWULeotqD07A9oJzlAy2DXtqIR/feYK9hEe0sDugDOvjquFX90wuL5fmxIpfnd1QDB+DdbXWcoXF0j2hcNJ+CFZ7U8RYA4LztyjxhuzotPTZ+mYefvfXXoVp0Lp07KSqE+Zza8rGMxF25O+O6mzYMKNhu4YNcf5NuqULuwbwV25eXR1edVB6wiCQM3GDHOj+66Qke+YNnZKbLj6eP1QUI6PSYrE5Dq2wCVL9dI5qvauSsUsNmq5j4t+CeEMynmTFmPhur7U2FP1OBkSH86vTrY7vKihr3WozXMlpSmvbcbZ2MU8CvhKJBWOMz7TVmpG7FraQwuOgT+CHmUptVVYOH86MEp0e0YxPa/YYyYke3fN51AdvwGbAyKFwHjDG4WXymMVh8oSJsvCpc5QKkzeSYj0qzS1LwN6DfDJMISCyp1RTrIgFmnGmj/1e0YyHUJFfzoAmz75d4qVZCDY0dj2A+giH+76wmXhc4sxwKlPpGtXLGRes8nud9izo7mTnbRb6Vlbdy55+Qw8XiRZJr8DKBnPjjioohO8bO/dpi2a0GbZKKA8FfmWfMuLFRCr3EYMc+b/m+l8bKgpToOV9Ra5dxIQKW0ZA7F0nlCm6c3H/VdKdBkownh+93zOfQp/mOQOFTWrdqFTwQ2
 zgkE+1vb
 WWosIqPBH/59XRlbyOR28crvSo0KzzlUA85aj6Re9GmyyaGizYJABXGfcOaXDZ7RQWZxfxWwG8KPUlhINkpzTCDYiJsBYUn24zXeRWkfJwJvOTk4o8R57RS2n+J1B+1hTwJERm+tiZskZlNZbDaItgoFbudoDMNH6t0N2515vjq/83iGWx9yvVrTBxuN5qAqQDEtIudxNLv4u82AoN84G5hCKKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/27 02:24, Sean Christopherson wrote:
> On Thu, Feb 26, 2026, Lance Yang wrote:
>> On 2026/2/26 04:11, Sean Christopherson wrote:
>>> On Mon, Feb 02, 2026, Lance Yang wrote:
>>>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>>>> index 37dc8465e0f5..6a5e47ee4eb6 100644
>>>> --- a/arch/x86/kernel/kvm.c
>>>> +++ b/arch/x86/kernel/kvm.c
>>>> @@ -856,6 +856,12 @@ static void __init kvm_guest_init(void)
>>>>    #ifdef CONFIG_SMP
>>>>    	if (pv_tlb_flush_supported()) {
>>>>    		pv_ops.mmu.flush_tlb_multi = kvm_flush_tlb_multi;
>>>> +		/*
>>>> +		 * KVM's flush implementation calls native_flush_tlb_multi(),
>>>> +		 * which sends real IPIs when INVLPGB is not available.
>>>
>>> Not on all (virtual) CPUs.  The entire point of KVM's PV TLB flush is to elide
>>> the IPIs.  If a vCPU was scheduled out by the host, the guest sets a flag and
>>> relies on the host to flush the TLB on behalf of the guest prior to the next
>>> VM-Enter.
>>
>> Ah, I see. Thanks for the correction!
>>
>> KVM only sends IPIs to running vCPUs; preempted ones are left out of the mask
>> and flushed on VM-Enter. So the old comment was wrong ...
>>
>> IIUC, we still set the flag to true because only running vCPUs can be in a
>> software/lockless walk, and they all get the IPI, so the flush is enough.
>>
>> Does that match what you had in mind?
> 
> No, because from the guest kernel's perspective, the vCPU is running.  The kernel
> can't make any assumptions about what code the vCPU was executing when the vCPU
> was preempted by the host scheduler, i.e. it's entirely possible the vCPU is in
> a software/lockless walk.

Thanks a lot for setting me straight!

So any PV that has its own things and doesn't call
native_flush_tlb_multi() directly cannot be trusted to provide the IPI
guarantees we need.

So we should only set the flag for the native path, which truly calls
native_flush_tlb_multi() directly.


Have a great weekend,
Lance

