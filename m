Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98C05E7DEEE
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 14:38:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACBAF6B00B2; Mon,  2 Feb 2026 09:38:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A79246B00B5; Mon,  2 Feb 2026 09:38:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 985A36B00B6; Mon,  2 Feb 2026 09:38:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 83E616B00B2
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 09:38:07 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2219B1401BD
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 14:38:07 +0000 (UTC)
X-FDA: 84399771414.17.B233077
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3A8DA18000F
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 14:38:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UgCRKXtO;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770043085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+YuikHIpXYtVLQeTjpDEpyPPM+rwsAsIsRE/N+8+UvM=;
	b=A4FIPpHQ3IkGR/74UwrzEbcgpm7yYwpYCq4rw3AQmlUdU2e97k4rFlurabotBa1bkfCrgk
	Yq1KhxqQ2k0xjpEN2Uca/nKiOLBa8BPsLDZ31kd3qz844tvZDPPzS+jE4eOHLOgg82+9/g
	CpgcxX01tTQWCdsVb4UMzvItE8NwVjU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UgCRKXtO;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770043085; a=rsa-sha256;
	cv=none;
	b=LtxFVbtQNoXXeoYdfNzzOTFF9cgN0b3MiEywLr/RVo7eVLasU6m4n2k8mR/iBKYSUkx1wF
	ENNO0sTUIrK/gj9tojgswl4/baIWlohRqhjflsUzqxI0DYd9XomPAlCfPEOsjAWSSZAiAy
	wT19sdSj6n4036cNLu9uwFSnZXy/BMU=
Message-ID: <540adec9-c483-460a-a682-f2076cf015c2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770043082;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+YuikHIpXYtVLQeTjpDEpyPPM+rwsAsIsRE/N+8+UvM=;
	b=UgCRKXtOZlfN+/7cORPTlSVzR8UJHh7JqxgK0CfCBKekoSTHFgghh9HracXNSrSC3awjkU
	H+AQz66kUh63gKnKZVfMkiJJ+X9mVe1TcLsZJJK3NjU7aPXYAA3puXscll30N4PFjBYfdj
	QKaUx6BxL4dSPBiJMateUtbngiHNtnw=
Date: Mon, 2 Feb 2026 22:37:39 +0800
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
 <c6fda7c2-ad54-416a-a869-1499c97c7bd7@linux.dev>
 <4700e7ba-8456-4a93-9e28-7e5a3ca2a1be@linux.dev>
 <20260202133713.GF1395266@noisy.programming.kicks-ass.net>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260202133713.GF1395266@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3A8DA18000F
X-Stat-Signature: 174834r93r5if4io48mq1jpg6nkpzzhh
X-Rspam-User: 
X-HE-Tag: 1770043085-850966
X-HE-Meta: U2FsdGVkX19jbzwaKjcLBNpRuSibQzLAZdkWv+KMNYIqiI7Dxb8shmhjmAYt2YYdovQgHz7/You9RoNH+8fUJKck2hqh2fvyYdDnJnia2WdK7pSgwr7zLIQSpGRDmQQ1rjACoEwTfJj4aJKPaAgXSYiiAVSvtyfWHvjAvC24Lhs9AhV6TRW0j+AmyNQ99Zb+6WS+16lEoUXruDWX+FsTxxxU5ZQ2IbIKK4y52gWFKvSOjA2eIv0qCdz3E7B4KPOYVjnysmZIwz7uVHkJVoO58XGgLmasibw0MGt0XWvoHryTNFcNZqqhE2Wn8f+v2CHvPdL/D9Q+Xw5NOkomLWnVAhLJL+reMonPDclBnAufj1SMXNViE7XKlZvOYVBd7P8NbGeCYC10rJRj6YDaX4p0rn93Z4CuWjQovsKUaOdUw+FLWCM1/FK5QiZe/9KvlVyojtU4rsKKgtUWD+RZQzi/rBwAkB44a/m9rsYASEUkA0qi3G16mXRFhHVp7KnLOfHdu2pqrip+bmAnFb6/tnpZ4oZJXiZN9SmMBHf5DAIewpGN1rnjGA9ZA68EZ43qsY5aVxpYqQ+DEj+lKnmk1c9BnVEOGBL0txiBItZ9kmYf8c/lq/HDze8Wmmuozb2KWkBGr+Sg8J3tq3VcxBcAhiOsU9SpW4fvQn5PVp7H7BM0m9bDO060/gVczjpq3KKd2Q+GgOecwBkjDNDeAt+rnWXcmmPwHgrBcqpikvKy3L/KDJLJpcRtqBFEJQEagUEVjU23vukYLOTPNMn9du+Ck9alaqm4e1uQrkmXvZ6YkSfXrd/o1iu6/fmc7v+aEoaG/wwtsjb7rNuuhn7wTWEK5q7vvnQMOy6zC4vUJBqk0fvWS9OxV2qIilBclkWUf7KYSU8wLCqZcjxj6nX/HTtzx5/IzS7We+LMYNlI1r1g9oadQMLNcjsmaqNu4vpoj9MeWNtqWKaASNGthLnRrqGIcvN
 h8Luma9u
 G8/YaawoweLw09AqqWsFgjwlrW0xhmp0JjbJqEPeO6K4AoW86BEDshAp8IRbw5jrszG95d6wKs21TsFoS6QU5qp3+gBMQUp7pyTf2s7G29MtGJigx8YoYxaXgQISwT2KxRlxeAylWY7vqRsMr4MMjSwtsMkgR7lEl281TbKa2gqoR0PzFb7CdmA7E/3LCr4QkVFB/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/2 21:37, Peter Zijlstra wrote:
> On Mon, Feb 02, 2026 at 09:07:10PM +0800, Lance Yang wrote:
> 
>>>> Right, but if we can use full RCU for PT_RECLAIM, why can't we do so
>>>> unconditionally and not add overhead?
>>>
>>> The sync (IPI) is mainly needed for unshare (e.g. hugetlb) and collapse
>>> (khugepaged) paths, regardless of whether table free uses RCU, IIUC.
>>
>> In addition: We need the sync when we modify page tables (e.g. unshare,
>> collapse), not only when we free them. RCU can defer freeing but does
>> not prevent lockless walkers from seeing concurrent in-place
>> modifications, so we need the IPI to synchronize with those walkers
>> first.
> 
> Currently PT_RECLAIM=y has no IPI; are you saying that is broken? If
> not, then why do we need this at all?

PT_RECLAIM=y does have IPI for unshare/collapse — those paths call
tlb_flush_unshared_tables() (for hugetlb unshare) and collapse_huge_page()
(in khugepaged collapse), which already send IPIs today (broadcast to all
CPUs via tlb_remove_table_sync_one()).

What PT_RECLAIM=y doesn't need IPI for is table freeing (
__tlb_remove_table_one() uses call_rcu() instead). But table modification
(unshare, collapse) still needs IPI to synchronize with lockless walkers,
regardless of PT_RECLAIM.

So PT_RECLAIM=y is not broken; it already has IPI where needed. This series
just makes those IPIs targeted instead of broadcast. Does that clarify?


Thanks,
Lance

