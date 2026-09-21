Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65830C982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 21:05:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5997B6B00A4; Mon, 21 Sep 2026 17:05:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 523026B00A5; Mon, 21 Sep 2026 17:05:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C36F6B00A6; Mon, 21 Sep 2026 17:05:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0BCA46B00A4
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 17:05:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1374280169
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 21:05:32 +0000 (UTC)
X-FDA: 85239000504.22.E73955A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 57B5E2000B
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 21:05:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZZtvlp6Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZZtvlp6Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790024730;
	b=tmVCSjCyiZeBMMCkBlGANBCY5WfP52vE7B2s2SFVSFM9cLqNj+bOhnQdcui0RcwP5tpB+o
	uMzkSoxDBC5fTzPH/a9qWv8U7T42ZAiFc8i8wJ3hL/rVYqUNhBppbbVja4dm7ML3QHZYXy
	Vdqo4Wz71Kc2zJkWRnXmpvLi4KmkORM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790024730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/XBaHOvu3IMpuHFU5Xeyg5mt23hj1PsbznncaOl1HKQ=;
	b=1CSClMavw0fYDwB5r5FbTcXt2wmGkLzhtpCYWKU7+71eyjO543skPc5SIkdZAFNMITQplw
	FMcYsBrmRrC7yDTqWdTNbDIjzz3ilwB9svvJTpeNbq5JtOfM9MakapZkXT58MS+Z1E93Hg
	1ibTxTFVDojolWguQn0DFCXDxcEQiec=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 71CBF60AA3;
	Mon, 21 Sep 2026 21:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A4111F008AB;
	Mon, 21 Sep 2026 21:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790024729;
	bh=/XBaHOvu3IMpuHFU5Xeyg5mt23hj1PsbznncaOl1HKQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZZtvlp6ZrSWFcUl1OOHGUcDffeC1oc11iWttO5FrOktb1gDYjwNvgpXSjGS2cseDd
	 Yb+j7o88Fo2KxgNPdjxbYG+7pwgrGHVWltQUEIQGx6fWjtNO43wRm6cnaCoPROmq/n
	 0/vJx8fQYHGlNu533Rt+kWdWfr356YTeHRKQjE4XjZtpkIPVlZsQQXqf9Cc11vt30/
	 DLf6PTmNB1meZSKZm6eWcbAt60xg3vKFUni+8aEw8WLKLyDXo3Qlq2a6P7kybXEbjn
	 c5ZSxaZhmofyksa+O4k6ulnXX5/iXC6VBU5THtM+bu239GLHqBkkybwHSvVFG8tq8i
	 HSRhzhLyMpZXQ==
Message-ID: <f3cd3778-7423-4241-8dd5-05eb63886e65@kernel.org>
Date: Mon, 21 Sep 2026 23:05:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/3] kselftest: mm: replace usage of /proc/self/smaps
 for check_huge_xxx() helper
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260921-fix_split-v7-0-d25ec991159f@arm.com>
 <20260921-fix_split-v7-2-d25ec991159f@arm.com>
 <36465f31-59e2-43a5-8cd8-f8bb1844da3c@kernel.org>
 <arF74QGjx6oCIBnR@e129823.arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <arF74QGjx6oCIBnR@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 57B5E2000B
X-Stat-Signature: wc3etgehop4hodzsg1hfcrprcwqkbjws
X-Rspamd-Server: rspam01
X-HE-Tag: 1790024730-272166
X-HE-Meta: U2FsdGVkX1+u0ZdbhrkyKxuCOBWGuRYAUF9WI5OPUqjrn0W8BBD0mW8rKlopySLJa3FDkEZ2/eTHCa5VGPjMb9TMf7TeDpweEqb9yI72uydP2iprroi1AuNXhCg9Lfje9NrBJmSCjKfWAdLWQMxou/72r9D1QhSKIkbUN9ODbfYNsad0e2y4yr21DEvXAEkn0Lag5TJtCJT4kOpXe7VlhEsWbDkqwgEZLB6PTOAxJKQTUFvm8zW1nqSS2J7jTo8BmJxotrb/QQItQid1WE+c+69l26zspY5jQC9oNlHRbw2idv9FG07m01gHsmpyVvUPeJrhKjlWDhUIGby5SQq0+Xyrkn8zj6Yb6ZXQ0iXoy5vASuRM46khlLrjOZH+cbYnZfX7rUSozZONrvp9cDmy6h/gbm/wsq9DBAJlWuX6e4WaWUF73eXslKQSYcT4JmghXKWUzcuv4WFHNLEyUA9u/aAsdgCBhKYzn3bjkiseXc5vAOxb6numdf6Oxgj4BmXEUlj7xa8qpAzdzAK5P/zZK7sOZ3lUjFHW6uwIXK4CDK4ZeNzN/Q92YUh/+JLm2wV2QGUhYpGlJnPM/jheACsP8QEoyW1CJTFWGfsakXgqln3GSztZN82WXoJjkcnaJeIBVxybkIUTspE5hGg/5Kai7itnczhyFyaAXUz58+13DrwtW9YYIXb5GPFQhvaOenDu+JVW/YoM87Y8YWGHtiVe8lyHFpvXniJMzDf6j7++XKb+wGFIXJdHHWv/VDZxiRsQQdmTrAEmNIBZsI2JfQYL+Ih8mZ9N+SMyHXagtAbj05irUiwjdDVK9OwK8OIO+VnXlCujznhNG+q8qbaeKN1FWKVx+UcoRTz+S0/jFaPv0Sc4bg32LRlEOsVmOxf1oy3b52DsUtUH4uJDQbWgfKEIlfuA49E00eX1nWsovyEyNJictnexePn47Nzzd9W5MCwVeaKkypROqRco3T7Oefr
 sHscL5ae
 4vKv8TQVO5rnWII7FhcB8WEWNKr6uOHu4tOYvwb+5Zm9mvs3Ha5m0E/x1Qp7tIHK1Ir1388GhjnMXsa6GTUVbucCvvsgWvsHulXcXYx7/pjeE3NHrMPOO/dHmMQWEf+nejcdRPJ1qK+lLsw6NgO6mi5Uzr34giju6uxtzRoXoGsQG21Qs/iKnjEAWGjtfm5sUWcAKgfVuIeLiExvlrUpDjmKo+cT+B+4PUau6q3SPtkCFD41fTLY1Fgcts5FoUutDagVMWdG2E0MQ6RVhnELdQ26MNs43k+DJXua+d3deB21s+Wtw9VvRMAd8iRFgRa4ErL848EdvvTow5wOI5hhkMtfUzOxWYzdAborb54soOkgGLXpofYPHw06ZCtZmwABJ4F8s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/21/26 20:48, Yeoreum Yun wrote:
> Hi,
> 
>> On 9/21/26 12:40, Yeoreum Yun wrote:
>>> Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
>>> glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
>>> made by memalign().
>>>
>>> The underlying VMA may start at a different address from the aligned
>>> address returned by memalign(). Furthermore, a subsequent
>>> madvise(MADV_HUGEPAGE) call does not split the VMA because the flag is
>>> already set.
>>>
>>> This causes split_huge_page_test to fail because the check_huge_xxx()
>>> helpers incorrectly require the address returned by memalign() to
>>> match the VMA start address reported in /proc/self/smaps.
>>>
>>> Instead of relying on /proc/self/smaps, use /proc/self/pagemap and
>>> /proc/kpageflags to detect huge-page mappings and large folios:
>>>
>>>   1. If hpage_size == pmd_pagesize, check PAGE_IS_HUGE instead of
>>>      using check_large_folios(), since only the mapping type matters.
>>>      This identifies PMD-mapped huge pages.
>>>   2. Otherwise, use check_large_folios() to detect large folios. This
>>>      covers mTHP cases.
>>>   3. Check the folio flags according to the type of huge page.
>>>
>>> Since shmem pages are also file-backed, simply check whether the page
>>> is file-backed.
>>>
>>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>>> Suggested-by: Zi Yan <ziy@nvidia.com>
>>
>> Do we need a Fixes: tag?
> 
> Since this change is required for the chaning of behavior of glibc,
> I don't think we don't need to add Fixes tag in here?
> 
Our test made wrong assumptions on the underlying behavior of the user space
allocator (no VMA merging would happen). So I'd argue that we should add a
Fixes: for the test.

-- 
Cheers,

David

