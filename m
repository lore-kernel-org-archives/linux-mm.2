Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8442AF99368
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 10:13:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED9DE6B0005; Thu, 23 Apr 2026 06:13:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E89E76B0092; Thu, 23 Apr 2026 06:13:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D79396B0093; Thu, 23 Apr 2026 06:13:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C16F46B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 06:13:36 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 85233403B1
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:13:36 +0000 (UTC)
X-FDA: 84689408832.03.5473B68
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id A6496180004
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:13:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kq14zpXL;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776939214; a=rsa-sha256;
	cv=none;
	b=7OWIqsTyADraNUJHfTDtvdFLWrpYe/AUD0ceI4N33Y7PgHQ4mzxCPvjNXH7E2IRBL4jTnK
	qgjWvVcg6A4A7Tt0ip0lNTB10PeKXbfM3NjQTdecwbQxYPP5AhBlfLwyxozlDdf3T/t3bj
	qFOslg4Bs33mRifbkFdQ1GcE+7VVuX0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kq14zpXL;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776939214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mH+bA56dyKD+Y9RieNCsn0f1CjH9WSu9ec3Nw782s78=;
	b=zZVZ6iX5jS0gRo73tniy3zMGItV6OMGbbfPoPLVWWpzwanBRXDMpUVc8Y176L+y9WgC6Zn
	ccR4uC98d16W8TDDReEgeA1hxbLYZcLAyM+S/f/xXdMNCBhDlmjZfckkW9T/C1HBugwMNs
	0t87TQVhQTD0DicZZxDEjQaVXKYCrBY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B08DC44551;
	Thu, 23 Apr 2026 10:13:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FAB6C2BCB2;
	Thu, 23 Apr 2026 10:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776939213;
	bh=XDlDi3Pv1jl/HlvTUqd6zWFMsv9KVgXtFB4DW2Jg2p4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Kq14zpXLceZVZqU9nU01Lo7qXH5inYqlAF3bJhOl3xuP1u8kkE0xxjQ2u4xtHpv+J
	 rI1FC6UyvO60E9RjcU8gBwhEYizuiSL+uc4Mi6i3aoirCReDGNQtpP//9XcVTZ4Rld
	 Slp06FxpF2ai4pE8rZe34mIA4YMmQOrC3cty1YhUSRCQkCYTPfJdjhLcwjkZJioLuZ
	 6I2WTIek9RQpjr0bXswQYNF+FbyKjCnR/KpjwLPWnYnyS6pkPVJEu78jRz/R4MR+Je
	 Owu7i7SjhRI9eshL9ZsT5c8C75Lz5ZYcX9tNSAxoW1e0lAQI9RZJlvSc6gqqQoGIqw
	 KjdIX3rkucbGw==
Message-ID: <6704f990-6c52-4c83-9fac-ede4c7af37b0@kernel.org>
Date: Thu, 23 Apr 2026 12:13:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/page_alloc: replace kernel_init_pages() with batch
 page clearing
To: "Salunke, Hrushikesh" <hsalunke@amd.com>, akpm@linux-foundation.org,
 ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, rkodsara@amd.com,
 bharata@amd.com, ankur.a.arora@oracle.com, shivankg@amd.com
References: <20260422102729.166599-1-hsalunke@amd.com>
 <be256a32-dd9f-4dcb-b9b4-3f2a7fcde70c@kernel.org>
 <5eb58895-b9c2-4124-aec7-e55074c372d5@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <5eb58895-b9c2-4124-aec7-e55074c372d5@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A6496180004
X-Stat-Signature: 6ni3hzqyfy577u74x3xh7bwnm93fwrj4
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776939214-865501
X-HE-Meta: U2FsdGVkX1+38cZHRvRaHb7NcsrDtl8EkBXcEv4y+P7F9JejtOPpNz2oHSTubyppgH4ThTgIlPXG7UmvVKGvl8UQWk16CBrJrwrB5wRurT4m7QVqiMEHns8cW6CCBxkBjM9X7UDEleZ0KBqAtmlHZ1dhVI38awpilQepXZ7dUNec/44FUobzCzgKY3CDahMLKDr3YwvoVWhZXNgvk6hBGe4yk6kJq2IpfDre4PhjH1B8Hy+mzVHPlWVRefXY3j8P6IMzFnhCKcq81+qrNN3rIkAWxz/PxIULSNwQXZ+Cxi6Q2qdHUQjlyeNTdMgeWzLPMcKojVQCacs4Vw8dPFhJQMpYCdi5PXFuLkKkzmJc9qYv6nVhMRrTAZuNm7r/cQGwoCMBoUQKHJld7EUcd4IyjH+DvPJ06Mm/NAygoxEBRQ6R7dxC5kytchUyOu5+AhL9dcylrAMpAh/SWo37WtAcK67ETDguKosiGcmfbVeiG+iV8JSyG1zfLJO2q4tihIgW2W6t3uQX1yCLuHpIwl1LmeIHN04V20s1iXhU3KbJH1jxfzyGgbd5zZ3xZsCX9w3qY7m0UaIB6vjg+zeHozJzQfISaTWd9k3WC6fTlSnhGnG+/V9/b3fLAEGGo+n27UlOfQv3DOE7MzcNVRwZzuy+PXs0LQ3AavqVHNyBm8EuxC9+WnWaetvvJaEjMTnjTkAhViU400ZR2zpzH4VcXqJDmaR2suh0K79yXzL6xd7VRYKF442Y2P6rc46h2ipeaTNRlCvNpExPBkkK60M9MIut9RD3Tmdbefm4ejKRVuX+UVi8V6rKbe0mqWl6TCazcepzxpiPk/QObhMEBIW1AetM4pZkhi/gXIrA7zguvzENH10JS4Z55fkhJYV4cuXF123L6JAuZZtv6EelANHsPxIZnW6ydECWwusdXZL1iROCGjUU7ZscgBPnpN99s3+/3IybzMjbvH1H4LJDrs1MvbW
 z9S3uQa0
 VcDT2o+mBXBIJHxjbZS1pc/u7drulclpVxoF+hb+cWw3yoKu3YdMPbj7SWfS866hDSg1fN6HZ9jeHJnymv7BhC25omgkde6LiwcMmHw/g8BIXLDRwVXTrp0PdyQQKxFP4xXPczK7Orbxn4jWsF4F9ZhlriAdiuHNKDPr/3g3wkfQHGL2bu0NhCmnxqybOXuIqogUUTpyNlW464jHxKdsflwO+SXVcWwc6b8sAjJRv5nhqCByF8E56uuXcjza0DyrMfxwrfNRrRVgv/HGSWl6BPuwfydwUJ3vcCUjiqPxoiejZK+OQ/EX2vDCJI5g1k2Cda91nhTn4WYi2bUg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/23/26 07:09, Salunke, Hrushikesh wrote:
> 
> On 22-04-2026 23:55, David Hildenbrand (Arm) wrote:
>> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>>
>>
>> On 4/22/26 12:26, Hrushikesh Salunke wrote:
>>> When init_on_alloc is enabled, kernel_init_pages() clears every page
>>> one at a time via clear_highpage_kasan_tagged(), which incurs per-page
>>> kmap_local_page()/kunmap_local() overhead and prevents the architecture
>>> clearing primitive from operating on contiguous ranges.
>>>
>>> Introduce clear_highpages_kasan_tagged() in highmem.h, a batch
>>> clearing helper that calls clear_pages() for the full contiguous range
>>> on !HIGHMEM systems, bypassing the per-page kmap overhead and allowing
>>> a single invocation of the arch clearing primitive across the entire
>>> allocation. The HIGHMEM path falls back to per-page clearing since
>>> those pages require kmap.
>>>
>>> Replace kernel_init_pages() with direct calls to the new helper, as it
>>> becomes a trivial wrapper.
>>>
>>> Allocating 8192 x 2MB HugeTLB pages (16GB) with init_on_alloc=1:
>>>
>>>   Before: 0.445s
>>>   After:  0.166s  (-62.7%, 2.68x faster)
>>>
>>> Kernel time (sys) reduction per workload with init_on_alloc=1:
>>>
>>>   Workload            Before       After       Change
>>>   Graph500 64C128T    30m 41.8s    15m 14.8s   -50.3%
>>>   Graph500 16C32T     15m 56.7s     9m 43.7s   -39.0%
>>>   Pagerank 32T         1m 58.5s     1m 12.8s   -38.5%
>>>   Pagerank 128T        2m 36.3s     1m 40.4s   -35.7%
>> We do have some elaborate handling in clear_contig_highpages() to chunk it up
>> (and to call cond_resched()). But that function can get called with much bigger
>> ranges.
>>
>> I'm not concerned about the cond_resched() -- we wouldn't do one here before --
>> but I'm wondering whether we could end up triggering a HW instruction that is
>> uninterruptible and takes a rather long time.
>>
>> But clear_contig_highpages() breaks it into 32MiB chunks, and only x86 supports
>> it so far. So we won't exceed that with the maximum buddy order of 4MiB on x86.
>>
>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>>
>> --
>> Cheers,
>>
>> David
> 
> Right, on x86 the max buddy order keeps it well within safe limits.
> 
> Also, rep stosb/stosq on x86, currently used for clearing, is
> interruptible, the CPU can take interrupts between iterations and
> resume where it left off. 

Ah yes, indeed!

-- 
Cheers,

David

