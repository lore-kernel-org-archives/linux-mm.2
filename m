Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FFADEE01F6
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 21:39:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A50D36B0088; Tue, 30 Dec 2025 16:39:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D4456B0089; Tue, 30 Dec 2025 16:39:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D39A6B008A; Tue, 30 Dec 2025 16:39:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7C65E6B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 16:39:16 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1D689140146
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 21:39:16 +0000 (UTC)
X-FDA: 84277453512.13.B5B68B9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 49FC3C0008
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 21:39:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TteOwrKo;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767130754; a=rsa-sha256;
	cv=none;
	b=u+2zKy4tpG7HZ1PtG68RnCFXEOfW1WDNhQ0witbXPb8qII4i08VjTFjuSAZDxX/3ayjAaV
	Iu83tMKBvZdfPj4Gz9QIgQK2ABBLyYf1JYlznFrBn3Y4ZeAQDNBt2J0VCVXEg4sq0zlIVv
	2MxrdFzpHoNwJarLyRAnYbS3TdmBozQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TteOwrKo;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767130754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BT5Os13fNrX1ZabsYpjcB2MOMaC9WFIFHWUx3jeyBQY=;
	b=dLnNysKwY1ER1485pBUNc959p9EYnM0nFF6J/AA4DmfPL0W5fTY9JyVv91oZFpXO47n2Nb
	hR2oO1q+KlkTwgSYqMks1hk8sAQQkCEOeEfEzn6ZeQdjzTk6NXW3BpyKSo+2vosoYz6KWS
	rpg1N4PkJvGajRBsIA6DQw8VFi9kFIs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 48CF542A1F;
	Tue, 30 Dec 2025 21:39:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E81C4CEFB;
	Tue, 30 Dec 2025 21:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767130753;
	bh=YtquKurop/OvwxN4Eq8Ltk7Y+OOoKVyFZ6MJUUIWI0Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TteOwrKoS5IxeqeKPFtXFsRfZP3vPb7PkPehFZL6R4m3JY81atVBoIlphCBU3vVi5
	 5p0nN76pXtqc4E6/CtCPjHLH8Q0lPyPMiwIEUMnEBJ1F9fKrRk4b03cxzhSSPzYcSN
	 qzimu6v3errdDrfRQ0Biww2RVGOFI6rGrPqbrsO1abAvFDsvLxlBuntyZHNkhwaXee
	 UXBbHzT7mbhDa7F8q/QGpCCbyVPo8e1XGcNo0QZIyCbq2OoT79q6DOFw6wpaiFXk8V
	 8hOq678GkZ0lO6BitPZEJPlub11soUQif+vZeB6QqfTqQIrz5CeeeeVKlctHzcB6R9
	 WKRpjsI/obZ4g==
Message-ID: <b0e8f746-3170-4101-9ceb-54af06ff8e16@kernel.org>
Date: Tue, 30 Dec 2025 22:39:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next v2 0/2] THP COW support for private executable file
 mmap
To: Zhang Qilong <zhangqilong3@huawei.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, corbet@lwn.net
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, willy@infradead.org,
 wangkefeng.wang@huawei.com, sunnanyong@huawei.com, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, lianux.mm@gmail.com
References: <20251226100337.4171191-1-zhangqilong3@huawei.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251226100337.4171191-1-zhangqilong3@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 49FC3C0008
X-Rspamd-Server: rspam04
X-Stat-Signature: i8awjn4btfg7wi5sj9hs75ezexwsrfgy
X-HE-Tag: 1767130754-248690
X-HE-Meta: U2FsdGVkX1943vKkuCgp9ePZaTvHtIEkxVhSttRHYp1vQEiTbhN3fXqUw3+OFKBHUzMzM1IseTGBVZKBEicGYGfQpKBOofCddXwwL6La/HWRL4881kGDAKSE/37Z4YqX3Ja9dTbvRh96nUZCUfafJfUMPVh3I6b0/M8tvi/e56WFGF1fOrar1ISELS6J40bTDcnu/1CX9JeJ73NqNoqGuBeOMul1MrtuC3NdQBmG5TpMSnNpMdiVssxUrcqp5Ge4gNC8V5sVuHUIlWjzr07+C49y9LFaUpJYGLST82tbCqfhy936wsLMIySHGFhFQT+GRi0b62qPjDLH+/kFfFCihRJEXC+8WzELc4NbBP21fBvMBUcDjbQnVZeNeF5mNA7qTNymspTKMrxTh5tcdAaRTEiH+dg7fHvVNqtEnWKa2JLWr0ooDiyYb4Nyqt+tXRdg4I9+3U02CPuJYS5vKH0MQM83dNWx9XAr+jKLyVv5GhZidSmzAQlQ9PW9rL9I9L0POSlXuYJYGgTCaE9YNAPyKMclBVkEurVqLMcsbGofVtM3ftBFyzQYz1dxCwAxhf3vHmbIO1f+pZKFQ1g+qaiTeVIicrjIrM/+TVEwoAN2I7f5of37DDPtu5tjICd7amj18UOWOFDKd7N7NQJ2FqYUrW6MS/lniGqhvnQx5P0b4jbIhJloak+tfyApzzQZjgVEMV/Zip/pK1RYRansjaAyOpROY2dg9+RAMICM3AjQBy6HBZ2/nPT7gV0KTfurEynRi6tco/jOAA4nQaamurdhbrB8V+yf/Hqp/tSxXyQ02NHol72lKOV9HTPUE408rAayyfh29rH7OrGZl9y+WPaU8TUyP/73VZ/tme9CKoz/6DD/rJ6P7c+vCypLeMcF0VB9YyXFvN+eY8oIktEodDH7eIm+3tGWOXW1XYwr2Y3xtE/lQdKlw9/YN+bw3XwqhOvoV4Q9rQYnAGNQmfNEmYB
 UlIq/soG
 uP+T7GLE4Ka8BrhEGb+vzfc7gFxHTMuiucU3J2MqpU7EO/mI49Eyr10KQtd+vityZ6r5vAbV1rWd70hPN8jgHUqHZOrdeUtYRfmoSm8hLvdrBZJ49eXgcigYbFp6GbZHZROgAyaX4r/HWIfJII/BGXCq5H+4yZNTrTNO/Ipq6EMIM1Ljbfn2uhyUQqHs+velAZAb9aH1CGJOrSjmHS+FdRETFvJ4T6zhMbsbebrTQX+Kg7YvA+cy4XkA+KGAgXXLL1vwki+QS+/pWnpDxdgKB9cVBv8L9Fu9reXqod3z8TAYX48SzS/Ap3jDJA1qnGsxi2hEahEPEyi30kLo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/26/25 11:03, Zhang Qilong wrote:
> This patch series implementate THP COW for private executable file mmap.
> It's major designed to improve the performance of hotpatch programs, and
> reusing 'vma->vm_flags' hints to determine whether to trigger the exec
> THP COW.
> 
> The MySQL (Ver 8.0.25) test results on AMD are as follows:
> 
> -------------------------------------------------------------------
>                   | Exec mmap Rss(kB)  | Measured tpmC (NewOrders) |
> -----------------|--------------------|---------------------------|
>   base(page COW)  |       32868        |        339686             |
> -----------------|--------------------|---------------------------|
>   exec THP COW    |       43516        |        371324             |
> -------------------------------------------------------------------
> 
> The MySQL using exec THP COW consumes an additional 10648 kB of memory
> but achieves 9.3% performance improvement in the scenario of hotpatch.
> Additionally, another our internal program achieves approximately a 5%
> performance improvement as well.
> 
> As result, using exec THP COW will consume additional memory. The
> additional memory consumption may be negligible for the current system.
> It's necessary to balance the memory consumption with the performance
> impact.

I agree with Willy that "negligible" is the wrong word. Assume you're 
using uprobes and end up firing up the same executable in many 
processes. Each process will suddenly consume 2M vs. 4k just for 
installing a single uprobe. Of course, VM_HUGEPAGE mitigates this.

But really, this is the first time that we are using large anon folios 
in MAP_PRIVATE file mappings IIRC.

Take a look at kernel/events/uprobes.c:__uprobe_write(), which I 
prepared to deal with large folios.

But the removal logic for zapping pages when removing uprobes will not 
be able to reclaim the memory in case we over-allocated memory during 
the COW fault. We'll be zapping a single PTE only and *not* restoring 
the original file THP PMD.

Zapping more is rather complicated (doable, but complicated), and I'm 
not particularly keen about adding that complexity there.

Long story short: this is the first time we allocate anon THPs in such 
areas and I wouldn't be surprised if there are more problems lurking 
somewhere.

-- 
Cheers

David

