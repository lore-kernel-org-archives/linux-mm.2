Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25318EE01F6
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 21:29:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C23F6B0088; Tue, 30 Dec 2025 16:29:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86D736B0089; Tue, 30 Dec 2025 16:29:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 799166B008A; Tue, 30 Dec 2025 16:29:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 696D66B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 16:29:57 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1AA3D13A904
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 21:29:57 +0000 (UTC)
X-FDA: 84277430034.15.4641F56
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7DF3610000E
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 21:29:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="PdwRUS/m";
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767130195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9VfDCGALhIwXfIoTID0Yhj/5lOKXW0UtEP5GdII7c3A=;
	b=YToMUwPUhtRH4G0N81w4m6qwviG/BNZt4KykIUfMG4je2RMl9zEMxFxkzE5sYy1Di70ak5
	kOCzTJZskSYz0hQTJAolei8gViBqqnwqVU8Rypx3sulATlNB8f2RthZO0BHxh7G14P5EYV
	j8GBDfrZ99i78RhS6ZmuIqIo4oWRDtQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767130195; a=rsa-sha256;
	cv=none;
	b=atphhUuLNnexwVid/z353J2/MDGuy7DKmIlmu2vtfEIhI1NDJsCp6Uy3enZiKqMv0v2n7b
	wc7x/X04F01OaCq65nl2xcQlouFG5g9bt6FMBSYiswkJQyGwUMsir/Tpuf2doqO8Dr5Bct
	/4u6aKVAlQ7xLmQI1q3F9VfH56z3DdU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="PdwRUS/m";
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7767B4068C;
	Tue, 30 Dec 2025 21:29:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57DCC4CEFB;
	Tue, 30 Dec 2025 21:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767130194;
	bh=IxI611ewVn3TkXYsfQGaKWr165GjWawy7PB3qyN3Nns=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PdwRUS/mjSsVSh4CCh7bLteLWXUnNX4QT8VbygtGfUnwnXMBxY0ueLUakEtJu4Q1t
	 FGXA4oUgSUNPAtwY8enqcaiqjMYs3/Sczx9pb4GCnqvKPjfMEs9XTjN1DGFXwBEQ/z
	 MwmlkZO5EJ/O4Lb6Yd++MefsClQnVUL+zSwSg7A/7L8kXo/Yv8ex9uFVpJ2f9cS6xP
	 sT0Dp6lZHzFE2rPC3mL9ukeplETs1yOiA0/s18aTq5rbRoJSuw5IsQOjCexd9fY6Ae
	 BB7sdogG80sVMJ8lQc8jtSqKI5U54R5lu/V0wXn7z0qct1woG0EFJzzNv2CAZTtTyM
	 xmynp1euIy9Pw==
Message-ID: <46d418f9-74ae-4801-99da-2e31c019bc79@kernel.org>
Date: Tue, 30 Dec 2025 22:29:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next 0/2] THP COW support for private executable file mmap
To: zhangqilong <zhangqilong3@huawei.com>,
 Matthew Wilcox <willy@infradead.org>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "corbet@lwn.net" <corbet@lwn.net>, "ziy@nvidia.com" <ziy@nvidia.com>,
 "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
 "npache@redhat.com" <npache@redhat.com>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "dev.jain@arm.com" <dev.jain@arm.com>, "baohua@kernel.org"
 <baohua@kernel.org>, "lance.yang@linux.dev" <lance.yang@linux.dev>,
 "vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>,
 "surenb@google.com" <surenb@google.com>, "mhocko@suse.com"
 <mhocko@suse.com>, "Wangkefeng (OS Kernel Lab)"
 <wangkefeng.wang@huawei.com>, Sunnanyong <sunnanyong@huawei.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <0ce50058e6254a29baee1271ae0ef31c@huawei.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <0ce50058e6254a29baee1271ae0ef31c@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kz45gpe3iiced8tkmhyueejuhft9hxej
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7DF3610000E
X-Rspam-User: 
X-HE-Tag: 1767130195-771611
X-HE-Meta: U2FsdGVkX1/D+hCEBDX4vIQRxo5Lli/C6PXfQViNDWiIytihEeojH4kX71g4VjQVa4TUyLt5aCgUOKq9dzMx/0+AADrnzuoCZ2z4QNuTyfurGc4/R7ctnLQviXDg/vV1Sf6wvGCXd89bn2qieGo6yMtYWQ/W28eD666Ypz00cyfkC489EFP6ElkHbY6ezjABOGUL/M7eb8tmcIkUBcc9k5gjDsqE/Ut5WUG6yQhc3FwAY5Y5HKK6biALDXXHtok7jEl4ulZmWep3l1Cbi2WpOjsvHWpDt13IDKD5NkwmYtp8j16G18dDeVN9CqFthikipi4vXTGIYaYogpMKaQAHCNvunRTyPMSUUW2LGYA0XFz7D+TRu3cOSVrCu9gmXUm1Z9twSvFEDGwbg6TfaBETmPEQwaQLE1rVbpAe0wbNsBsoYp2tT6QHcu+/DvFKuea9DVC3WzzuSPzkb1kEhmoPE/xUwekdQtpKhKA6z3mpFSa4ehfHY4G0VprKzrP1rXjxUSmovRPF81I38+JrmbIIDBAFu6uaeeitM0wMCKUzi/zdz0/5AUvrl80eFLSME7NxZIaKCb7+bnbeGGLJd9m9rdL1ucWfrk6G/hs+NoioJLByNWoIO4Bd72TOIR933yTzGvf9HkiIfIHVZu6WRJv0VJsn0bQEKefSaBMwET006ffoAhpuxuU+fpbuInJmKhdEX1q6JXosgy5+gdMse6+RtgEtJHhnJecZUKt4lUWkW3p+8cnYSOlvssLCzZO+y3CWtSHjSv69fg0aYz7Rf5C0M/NpNWNteMdGgw6pmlpFr8zflFaLC2eyZzFUylzUOET7t+lqQJq89GfJBPqlENuu1yFoqmgoBzRWp3syvVj30xKapVDzcNgankYSC816zIQsgv5UavNKjzgAABBM7fjdKYWeLtuoONQ1RDapZ86EI86sBJacwRbH6+Xw6X93TpR/AnJN9/Jzsek5BNXt+lL
 2QMz4hPP
 YtFP/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/16/25 08:42, zhangqilong wrote:
>> On 12/16/25 03:24, zhangqilong wrote:
>>>    > On 12/15/25 15:00, Matthew Wilcox wrote:
>>>>> On Mon, Dec 15, 2025 at 08:34:05PM +0800, Zhang Qilong wrote:
>>>>>> This patch series implementate THP COW for private executable file
>>>>>> mmap. It's major designed to increase the iTLB cache hit rate for
>>>>>> hot patching application, and we add a new sysfs knob to disable or
>>>>>> enable it.
>>>>>
>>>>> You're going to have to provide data to get this patch in.  We've
>>>>> deliberately not done this in the past due to memory consumption
>>>> overhead.
>>>>> So you need to prove that's now the wrong decision to make.
>>>>>
>>>>> Microbenchmarks would be a bare minimum, but what are really
>> needed
>>>>> are numbers from actual workloads.
>>>>
>>>> In addition, the sysfs toggle is rather horrible. It's rather clear
>>>> that this is not a system-wide setting to be made, as you likely only
>>>> want that behavior (if at all ...) for a handful of special processes I assume?
>>>
>>> Year, it's not a system-wide setting. We consider enabling this option
>>> only when applying hot patches to special processes. If the sysfs
>>> toggle is unavailable, we will evaluate the overall memory impact on
>>> the system after removing it. Thanks very much for your suggestion.
>>
>> I don't think we want this as any kind of default behavior. But the system
>> toggle is really also not what we want. Could we use some per-VMA or per-
>> file hints to affect the policy?
> 
> It's really a good idea. Maybe could setting a xx flag to VMA, but it need hold write
> lock and touch VMA. let me have a think how to implement per-VMA or per-file policy
> or other better hints.
> 
> I have a thought that, how about adding a new flag(in ptrace, uprobes...) and passing
> to faultin_page() to mark the exec PMD COW policy?
> 
>>
>> Note that your proposal will likely interact in bad ways with uprobes, after
>> removing uprobes again.
> 
> Year, good catch here, it's really need be seriously considered.

I'll reply on v2 with the issue I have in mind.

-- 
Cheers

David

