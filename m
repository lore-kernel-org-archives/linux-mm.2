Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5BD7ECD986
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 16:31:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE9616B0089; Thu,  5 Feb 2026 11:31:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C97366B008A; Thu,  5 Feb 2026 11:31:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA28F6B0092; Thu,  5 Feb 2026 11:31:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A6DBA6B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:31:17 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 49235C222C
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 16:31:17 +0000 (UTC)
X-FDA: 84410942994.10.4C6ABD5
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf16.hostedemail.com (Postfix) with ESMTP id 49C3018000C
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 16:31:15 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l1TzN3rS;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770309075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IbZHvzzZjCNHqfw2Za1VcDxMPMr4DhRUSdKJcr9E8gk=;
	b=2AvMQIDfgz2UkBylPlUuZEbPKKFGQfVVf2S+jc4aagzXuG0hZGkriVo3G6l3ij7e348W8t
	jNo80Roei5K3w099iA3L2Wj4vfm8sW4TBIZpX8/opodjjPLiLNjQ0xzmRlrJH3bcspt98m
	sC/zpre20e+RfVvP1TqaCusEOKbHPng=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l1TzN3rS;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770309075; a=rsa-sha256;
	cv=none;
	b=HbF8JKzMhHixVywZ9foOmML7Gv8V+/1FxRFxMr1rtskj2TLKDpFGBTTC0nn5fPcEz0Vr+0
	IxmilA49HNRk+DdupK+Kv7t6v72megmJ5Gfttompzz/KLnSi4mQe/SWAqGe+fOAiaH4B4H
	qhEP/dB8D+vmpkiCA077Ph5egUhbK9g=
Message-ID: <99237729-f2b0-4a7a-8213-65a2f1c57744@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770309071;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IbZHvzzZjCNHqfw2Za1VcDxMPMr4DhRUSdKJcr9E8gk=;
	b=l1TzN3rSqTHJAvlDtvSYCjaDB4zHST0ryzOd0kL2Ys4/vjxmH2+LAUikMM571gueD62OzJ
	VhGD/7n8hlqhrRpZlPJIyvs0jsS8km8JF9zNNTaZ41HqkE2adsSo3LB7bY52C6Du4BCLNi
	4YVw83ojYxp2S5dWu1dipTU3aJVgcIU=
Date: Fri, 6 Feb 2026 00:30:56 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 0/3] targeted TLB sync IPIs for lockless page table
Content-Language: en-US
To: Dave Hansen <dave.hansen@intel.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 aneesh.kumar@kernel.org, arnd@arndb.de, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, boris.ostrovsky@oracle.com, bp@alien8.de,
 dave.hansen@linux.intel.com, dev.jain@arm.com, hpa@zytor.com,
 hughd@google.com, ioworker0@gmail.com, jannh@google.com, jgross@suse.com,
 kvm@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mingo@redhat.com, npache@redhat.com,
 npiggin@gmail.com, pbonzini@redhat.com, riel@surriel.com,
 ryan.roberts@arm.com, seanjc@google.com, shy828301@gmail.com,
 tglx@linutronix.de, virtualization@lists.linux.dev, will@kernel.org,
 x86@kernel.org, ypodemsk@redhat.com, ziy@nvidia.com
References: <20260202095414.GE2995752@noisy.programming.kicks-ass.net>
 <20260202110329.74397-1-lance.yang@linux.dev>
 <20260202125030.GB1395266@noisy.programming.kicks-ass.net>
 <c6fda7c2-ad54-416a-a869-1499c97c7bd7@linux.dev>
 <4700e7ba-8456-4a93-9e28-7e5a3ca2a1be@linux.dev>
 <20260202133713.GF1395266@noisy.programming.kicks-ass.net>
 <540adec9-c483-460a-a682-f2076cf015c2@linux.dev>
 <20260202150957.GD1282955@noisy.programming.kicks-ass.net>
 <d6944cd8-d3b7-4b16-ab52-a61e7dc2221c@linux.dev>
 <06d48a52-e4ec-47cd-b3fb-0fccd4dc49f4@kernel.org>
 <3026ad8d-92ad-4683-8c3e-733d4070d033@linux.dev>
 <64f3a75a-30ff-4bee-833c-be5dba05f72b@intel.com>
 <c985a8ed-37ad-415e-b7b4-18a66b4da3fe@linux.dev>
 <647cbe2e-a034-4a75-9492-21ea1708eccc@intel.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <647cbe2e-a034-4a75-9492-21ea1708eccc@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: f9dxnh9s3bhxt3d3hkcwqzafcmxbfq8s
X-Rspamd-Queue-Id: 49C3018000C
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770309075-772038
X-HE-Meta: U2FsdGVkX1/ABnTYU86k1+FV0q/rwtnNGf/U4AfASDUiJfSHb4S+et5h85MNHM88LD61X8+1P+jKpGSi8uYXK62kxoYpL6yU8cxBAhCufBeM72fvSP6sGOxZI/gcaUET8wlGbg7oq0vFs7rb7HQAl2ayzu7+ZNPAiyX9h+XvKO5iNKLNhWSPcmP1ok9DV7grDI8UKfCJAgEp+a4tpCgXMi+xzsHJr6Th/GRvtdcbXEYbEF5EhARLqReGlB6XTKx1ix9Y6hy0/HnhTQ7l/HMI+vi2f5q7kekhXTGmnmOUQOYovb8k0xRphr51oNR/TEJjoVYAoNA+oYTvbGoxS8x62mMBQTsDNTyvRjiAGscyTld3q2LIByMKfsQQ2uBGsXd9iloS3Eu7FygyHiEdXllzBC8sVNzvaOPRyXeSP1t9PdK7qn/gNppSrb9dxM7Ud7ev4vfvSI/U6hHcjcBHlaGYSX7epQpu/meT5PsXN/RfGO6vj7Lk2ffEjPTIGHG6nAauYe7hLRwEMveXNVKskUQGfv5uVayZL32VEsPPETeq13TVkY02ztA7YKj4Hu5XGUGCieCNGelumYQGdJu2PUDIHz9dsVjhKn6jBMzsZRYcl0Pfy9Xa7LzyK21yBjVFxYDoaLBIwRg6U2hZ56IwPMpUCsCE9rB5Ont5xmUzR8InK0uWSlc2tOAeZ4zFmsYEAL6elreyBXAHoaBuFfbLM1dpgY41QX6obv7bIB4DzsC13NlYmSXTSyASbl/XbKOHyhMGoktzL1IsxiwUQgz7H87ZJgb+XcTdDCHX/ViS2R4WL0u0jJ+7Lmf3AOrLrULYCkQ8lwqjwj8DN+W/nqmIOjGlKY86CAL6If1Qr7Nn5OtQp8vfmeUQ93aEw9/E3Yo1/hobKhz7Gl/3/mQEF7Q6e/5XggQwoJxFSKTrVeohnxnXKX9yt85DCf8QeLJ+xZYhSg5OXJJssdgFTPmey8gIRSS
 LwE4T5WQ
 K0jnpCtAFzbyJbqah3jNAUsDfD4mVS8NQPD3Zc49NQN+m8lRn2xvqgf+ISVA5Tu4NdmL4uT3EgmCiYuwSircCEuUvRvrWvOY2utKDZtyHsAnuAOuSOTVEKlU3OoKqmwqKVN3yq+l+MvWZ5nQu8SlSJ0YaykpcfAI85XmwdBDGKav8cxXowR5xdUnmrWk9I64FGVcbr+N5viEDglZ6orWSvDWNcJ7ww3a0Ql3sOsUOfAZn3Gg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/5 23:41, Dave Hansen wrote:
> On 2/5/26 07:31, Lance Yang wrote:
>> On 2026/2/5 23:09, Dave Hansen wrote:
>>> On 2/5/26 07:01, Lance Yang wrote:
>>>> So for now, neither approach looks good: tracking on the read side adss
>>>> cost to GUP-fast, and syncing on the write side e.g. synchronize_rcu()
>>>> is too slow on large systems.
>>>
>>> Which of the writers truly *need* synchronize_rcu()?
>>>
>>> What are they doing with the memory that they can't move forward unless
>>> it's quiescent *now*?
>>
>> Without IPIs or synchronize_rcu(), IIUC, we have no way to know if there
>> are ongoing concurrent lockless page-table walks — the walkers just disable
>> IRQs and walk.
> 
> Yeah, but one aim of RCU is ensuring that readers see valid data but not
> necessarily the most up to date data.
> 
> Are there cases where ongoing concurrent lockless page-table walks need
> to see the writes and they can't tolerate seeing valid but slightly
> stale data?

The issue is we're about to free the page table (e.g. 
pmdp_collapse_flush()).

We have to ensure no walker is still doing a lockless page-table walk
when the page directories are freed, otherwise we get use-after-free.

> Don't forget that we also have pesky concurrent lockless page-table
> walkers called CPUs. They're extra pesky in that they don't even stop
> for IPIs. ;)

I assume those walkers that don't disable IRQs only read the PMD and
don't walk into the table; otherwise the current sync wouldn't work
for them.

Thanks,
Lance

