Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54C9DE7DEF5
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 15:52:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A13706B00B5; Mon,  2 Feb 2026 10:52:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 997326B00BD; Mon,  2 Feb 2026 10:52:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 899176B00BE; Mon,  2 Feb 2026 10:52:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 755C66B00B5
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:52:50 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 06B0813929A
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:52:49 +0000 (UTC)
X-FDA: 84399959700.24.673263A
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf18.hostedemail.com (Postfix) with ESMTP id DD8EE1C0010
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:52:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LHO+UJ4a;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770047568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PduxyDODlH9YHL0rneveZmMdter31WXHAeGzrsiCre4=;
	b=GoAuUpza0lLZsrtlPF0LOO2RQ3RqjAZYgLm4WZxrEHMD1D2rhNU7Xc3bIS1k6makR5vwf+
	zIeJs9bU0sIW0s4SpCoc5QN+yTVZMpRmHBzaN+7462Uj1JG6kOjrgyka4UWJxetvxZI+1T
	k2G3qYPNPlXmNrJdp3OuBdYHmQpEju8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770047568; a=rsa-sha256;
	cv=none;
	b=k//Cg0wzoSYz5hsi3PZS93AqCIiDqX2ZnPvOu404m5ooMNAnHlz0HxsDbp/0btD17HJN+n
	bZ3YRyfb1Rc3MFCEKCoZSYUkNvfT5tPjvVvTRqncopylbyv8zCLMiEP3Lw05Wuns5FgRvx
	Xmw5mxa1BkdwMr5EkSUa/KnJUVWFGgQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LHO+UJ4a;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
Message-ID: <d6944cd8-d3b7-4b16-ab52-a61e7dc2221c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770047565;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PduxyDODlH9YHL0rneveZmMdter31WXHAeGzrsiCre4=;
	b=LHO+UJ4aR+t9zhuFaEeNktv85tisbUgqgGP+452qgxwu8pe3VAbJyWwRwIMkIkhrW3CiiU
	amX509lg1rXTP7Wtltg3TnQsfApgqjp0Blp35vsPn2YE5n3hsGAPY5Q6ckZZXKljWJkLo7
	a+vSwZ8/xCaiyucTyGL4QbFRUgmLY+s=
Date: Mon, 2 Feb 2026 23:52:31 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 0/3] targeted TLB sync IPIs for lockless page table
Content-Language: en-US
To: Peter Zijlstra <peterz@infradead.org>, david@kernel.org
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 aneesh.kumar@kernel.org, arnd@arndb.de, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, boris.ostrovsky@oracle.com, bp@alien8.de,
 dave.hansen@intel.com, dave.hansen@linux.intel.com, dev.jain@arm.com,
 hpa@zytor.com, hughd@google.com, ioworker0@gmail.com, jannh@google.com,
 jgross@suse.com, kvm@vger.kernel.org, linux-arch@vger.kernel.org,
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
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260202150957.GD1282955@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: DD8EE1C0010
X-Stat-Signature: suqywqzub8tmbg8rk3rpjisaf7iiziag
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770047567-194619
X-HE-Meta: U2FsdGVkX1+Zj5/1SHFijVgRI+p0vWG1lvoeB2vRyblk5kzVAudcB2iEVv2zIWUQeqCLAt7zIfA92IReF7d2hcZZAnje/MaO/cZYts8UrOMkbjtVOsAhRpVGo1+j1KthfKGmYlH5e4Wd+sKFbLKxoVIdp/myLr3EB1HD+3o2FLhRCc+EBBPyF04pvSnAAZwLJyiwBJHnPW8+x0EqOyR9SDaok65rsMUU97hN7m3AJJBtaysNUe9/IGxN747NmCuvNfVYLxVHlgAS73AOhOdCytFiSjGyX4rrXpY3xn50bV57Yq3z/axuCijtQSxGK0m09fIoc0wOhCgWIxwTYcS0ewKFUXNXckyVylsNl4akTDyPm13btu8FMhaR3Nta90quNeuyxx/e6X4OWN+pivTcv2onNeXLLz0+f+r3z1s9gyMSzGiiGCAR0kg0kqaHCXVuct+9EzF0q6dY4uj3AWEQ4WdGvBKLg/Zcokwdyp7yTLmvi31fzk6v3jHv7jLw1iQRg0TAhp+/Irx6Us8NbBeouxSFj+ws2/WRF84q5jsbfeHAxlBS7PfnQt4Gg7hpVRTxQNSSCvdT2QYzfNGqa1ckrKx7aTdZv7er7jo7dyxOsJG4qQrVOm3MKluRvAW9Frqhcu0CLXEEtZMjRhrT2WKyYnOClWHcYJxL8CtY+J90vraFltVOKTbCTwKjXi08aC8HJieYIczmz/tzImwu6lYK6T2sGhEsktfLE6lrR9qxA1cnSYjjpSk5pu1So1nD20ti/GMeV7xlsjMr4Tmk2mNP2wHftaVy/XQLYUDNaMYEXxJ+JHEDzLVB2xD+zMSMwbeyUSUPCqVHUMH0YdZZFVeOfjv2M5XRPTvX8gMR4DsWXzwExlCXbFfJ50blv8vtG2z9ZuHz3Qzp/ryQvp76CGeMxUNyznMcOD27zMFVuCuNiKAPcYtbdfN8m2wuS+CBolJs0Z3m2EDo9U+UECpu909
 I26tOuKa
 jf3lArktEfMvuc+4iWAsyxrKDWwku6Y1CK/jtkgIghhwuAgicb+QKLMuW6XMfnvwWqy/B6JbBT2gLzZS+FqwiDPgCDFh9nQrsc7+xZKMSNpKvB/EGlX+CWY6NgEOa816194/v+vHf/WPMr8u6HvO1lgCRTPWTWkeryb/ElS5Y81IzUJU7HSm7kSEgo3WFAZzkEC5S3KhmU3woh3G9gs+mlg5UBkbvd3/0BxJud+Uat6MXZ5s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/2 23:09, Peter Zijlstra wrote:
> On Mon, Feb 02, 2026 at 10:37:39PM +0800, Lance Yang wrote:
>>
>>
>> On 2026/2/2 21:37, Peter Zijlstra wrote:
>>> On Mon, Feb 02, 2026 at 09:07:10PM +0800, Lance Yang wrote:
>>>
>>>>>> Right, but if we can use full RCU for PT_RECLAIM, why can't we do so
>>>>>> unconditionally and not add overhead?
>>>>>
>>>>> The sync (IPI) is mainly needed for unshare (e.g. hugetlb) and collapse
>>>>> (khugepaged) paths, regardless of whether table free uses RCU, IIUC.
>>>>
>>>> In addition: We need the sync when we modify page tables (e.g. unshare,
>>>> collapse), not only when we free them. RCU can defer freeing but does
>>>> not prevent lockless walkers from seeing concurrent in-place
>>>> modifications, so we need the IPI to synchronize with those walkers
>>>> first.
>>>
>>> Currently PT_RECLAIM=y has no IPI; are you saying that is broken? If
>>> not, then why do we need this at all?
>>
>> PT_RECLAIM=y does have IPI for unshare/collapse — those paths call
>> tlb_flush_unshared_tables() (for hugetlb unshare) and collapse_huge_page()
>> (in khugepaged collapse), which already send IPIs today (broadcast to all
>> CPUs via tlb_remove_table_sync_one()).
>>
>> What PT_RECLAIM=y doesn't need IPI for is table freeing (
>> __tlb_remove_table_one() uses call_rcu() instead). But table modification
>> (unshare, collapse) still needs IPI to synchronize with lockless walkers,
>> regardless of PT_RECLAIM.
>>
>> So PT_RECLAIM=y is not broken; it already has IPI where needed. This series
>> just makes those IPIs targeted instead of broadcast. Does that clarify?
> 
> Oh bah, reading is hard. I had missed they had more table_sync_one() calls,
> rather than remove_table_one().
> 
> So you *can* replace table_sync_one() with rcu_sync(), that will provide
> the same guarantees. Its just a 'little' bit slower on the update side,
> but does not incur the read side cost.

Yep, we could replace the IPI with synchronize_rcu() on the sync side:

- Currently: TLB flush → send IPI → wait for walkers to finish
- With synchronize_rcu(): TLB flush → synchronize_rcu() -> waits for 
grace period

Lockless walkers (e.g. GUP-fast) use local_irq_disable(); 
synchronize_rcu() also
waits for regions with preemption/interrupts disabled, so it should 
work, IIUC.

And then, the trade-off would be:
- Read side: zero cost (no per-CPU tracking)
- Write side: wait for RCU grace period (potentially slower)

For collapse/unshare, that write-side latency might be acceptable :)

@David, what do you think?

> 
> I really think anything here needs to better explain the various
> requirements. Because now everybody gets to pay the price for hugetlb
> shared crud, while 'nobody' will actually use that.

Right. If we go with synchronize_rcu(), the read-side cost goes away ...

Thanks,
Lance

