Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE807F531CA
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 19:28:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E93E6B009B; Mon, 13 Apr 2026 15:28:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C1316B009F; Mon, 13 Apr 2026 15:28:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F189A6B00B1; Mon, 13 Apr 2026 15:28:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DFC4C6B009B
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:28:00 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 94A68E1D00
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:28:00 +0000 (UTC)
X-FDA: 84654517920.07.4F03F86
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id A6B04C0007
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:27:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sq5WgcMY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776108478; a=rsa-sha256;
	cv=none;
	b=7bqZWBV+sptZ+8GS54IR0tfCotun+sES5KWq7MpqfC6Oh827v6cPjPGhl6WczFY0/Y5J9m
	vMgok+A1QKvtqIGMODPu9gPDNsvniAqj5A1anMEB47Akhy5xLYsOT0awsDc0n4Y3rMK7SE
	yYQvzhMKHpns96tdlWzutAdUwAzBHNI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sq5WgcMY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776108478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4t+aHyf2s3gqYw5kLtMeIq2I4l1QhcH3VIAaHENm4JY=;
	b=ke+c/SAfPIDOGxhKsSzfB6M8XpqqCvRaB1oy2bDDUTmftOKrtjr0JUh9e4AIQxjYz3KaS4
	xwTucboftuYqOAxX0+MxG4W14MbulJqyu/Qxt6sTaCtuuDa6hW6i5VCMGbcXQxVMIwZJtv
	JaapV+k9zUsgBPMfVAhH6FMZN8yBH1E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6BCB240025;
	Mon, 13 Apr 2026 19:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD778C2BCAF;
	Mon, 13 Apr 2026 19:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776108477;
	bh=Hfs+6Y7gcGQJL72F4dYFx5Gznr+OvUZ9Zk/MEnMHgoA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sq5WgcMYK3l0ZU8RH001hZQzqmJ3HVN+S6B9cNcMMkw4TJetW4VcreAaHi4SRFjAv
	 FQGTb49s+/ZujASfwByx/J+PFsM3VB6fv0ZqUqevLYsYE+iaAHrXiO9lDF5n3MU5PF
	 UsXIi6rs68VbFkxXw5doQQOV6Jg0GpG+deu5k5F6inEItwzivzVttZtCEPbjAVDkE4
	 NBy1FTG9Fgm/jlPm5Kkt9hMZEXV4JeOJuYYEY/RGqhxDQRUjth6fpxLkHx8f8w51ng
	 mH/3sSu1zvqFwegHgzCTlJBOp1KkM13EttTGrgngClFKw4L1F3tWGyt9x4gT7HVCvZ
	 xbyeMfgJLi11w==
Message-ID: <5297e0da-d8ec-49df-9b32-0d9f907588d6@kernel.org>
Date: Mon, 13 Apr 2026 21:27:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: Simplify byte pattern checking in
 mremap_test
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, shuah@kernel.org
Cc: ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 ryan.roberts@arm.com, anshuman.khandual@arm.com,
 Sarthak Sharma <sarthak.sharma@arm.com>
References: <20260410143031.148173-1-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260410143031.148173-1-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mf4jrysu3ytdyeq7a1q97k14gkbch8qf
X-Rspamd-Queue-Id: A6B04C0007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776108478-92402
X-HE-Meta: U2FsdGVkX18J5ZlHyj6GZFYS/aul3MHMUS1z9nRKxq5HRmZ2e/1yrkPgy38BDly4HgYecg0PbNhF90Jv0cZ2fD9E9Q6asSo3v6wDzBlj2wK83Yk6Wo4yW+rmyk/77HAP3Hhr2u98UqrXgcVGce2TGUkfKRBPfHrR+Jaiv4KZwLmPv9mudMhonLOGeSySIlCzaCpx5fxNCo1zlBJDcrWUrEJa8n2XfLgDEXndnCjhBW/kkuk1/lxaCuZ5cOmvX+G4mhP+Xz5DXIqRLFOwWYFTgcYwGxWTfuWKCym8tmbysCSfon6X4DLYjbXCIRaSSHRVPRKzGQSIQ8+OLIJ3USA4P8Wu2JDdt4mJOyB3t5zrNu5cFhCdHhVm+eClHfsvRZWSj4FmVIAbMmMrMe7fxVWkJDRPDhAs53dVEnxUQ+HZ1DAJGPnza4JXscpz6qPIq2wjvfVuQGthktFhjWgbzezD5DPI+AuTZv+lyVbTv8RS4iYfum7yWytFBxpjGJuFNqjx6qDCnkZwIHIGanzdpZa80BtJc/vC4AXhvrVapOt4QIDT21lqeKImfgci2qbXMvgLXtqh2A9EwI5U2Vv+MiL8BygCvXyBaiNoguwBSo9ThTgFvZ0WS0oQYykhWol1ejdoIrJgmLNpep6rlqRtSc6D08vAGqrnfo4s7sWU3lGtu48IGpG/ZG6UtfbC3c8XWDxOVwCJvF0ee8Xj/Ifyv+vJEy0pvktPcg6pIqtJxnx/3fvq0k2qQ7l6vkWIFvjYkZ8+WsPnOtjz8pXAzg0OHno6YWTfOV8+B2NQI9TwSC4rZ8H+2eZtjNdLKeba9iJFUkKM2ylYmkbS1TriHuvRApae8GPMmr6VDIxD8u86AJV820HHQ/g/MmR7+Bhcs+b+oSlaCvo7Xd0wHLMYYGFJ2dP6a+hW1ZaFpNOY3fNF07FVa1xrLjwjPmLXzuPzYwy/HJgE/dh+Qh72SJBuSLH1CEK
 nLj4KWrv
 mAjBYCmpfYN1sI+urTb9X285lljRvGYN7Ikh1THfiKvdYQjCoBB5VxQGPUceMA6LjF4iYWE9pLRr6VdiepuBG3RFFr6f1UGz5wR1ArpZb9IY4ikA8aQJaplzcedBWUMM3B70AGw1pCJV7tb+/GdZzEmsN352H4CrAkfnEBiu6p7U6nnH0+gmodxuyrhG7MpcskKC/A+3HTA0inNHPrYNKwBk9uYkr6YpWLtAvptogR8YBMWZPgew5H1BMBfNdyYrU+VOryWWoCH9lPdFDXzSZ+C4Sd3qlG2sSV+bk88Sj39SucJPFdnPxXK0a43xtY9HWT3/PnJU26xUHETGndni50ZLRpwzDDsd0ZAPd9yao4v+pqngQ4mk5Pu1t2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/10/26 16:30, Dev Jain wrote:
> The original version of mremap_test (7df666253f26: "kselftests: vm: add
> mremap tests") validated remapped contents byte-by-byte and printed a
> mismatch index in case the bytes streams are not equal. That made
> validation expensive in both cases: for "no mismatch" (the common case when
> mremap is not buggy), it still walked all bytes in C; for "mismatch", it
> broke out of the loop after printing the mismatch index.
> 
> Later, my commit 7033c6cc9620 ("selftests/mm: mremap_test: optimize
> execution time from minutes to seconds using chunkwise memcmp") tried to
> optimize both cases by using chunk-wise memcmp() and only scanning bytes
> within a range which has been determined by memcmp as mismatching.
> 
> But get_sqrt() in that commit is buggy: `high = mid - 1` is applied
> unconditionally. This makes the speed of checking the mismatch index
> suboptimal.

So is that the only problem with 7033c6cc9620: the speed?

> 
> The mismatch index does not provide useful debugging value here: if
> validation fails, we know mremap behavior is wrong, and the specific byte
> offset does not make root-causing easier.

Fully agreed.

> 
> So instead of fixing get_sqrt(), bite the bullet, drop mismatch index
> scanning and just compare the two byte streams with memcmp().

How does this affect the execution time of the test?

> 
> Reported-by: Sarthak Sharma <sarthak.sharma@arm.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>

Fixes: 7033c6cc9620 ("selftests/mm: mremap_test: optimize execution time
from minutes to seconds using chunkwise memcmp")

?

> ---
> Sorry for sending two patchsets the same day - the problem was made known
> to me today, and I couldn't help myself but fix it immediately, imagine
> my embarrassment when I found out that I made a typo in the binary search
> code which I had been writing consistently throughout college :)

:)

> 
> Applies on mm-unstable.
> 
>  tools/testing/selftests/mm/mremap_test.c | 109 +++--------------------
>  1 file changed, 10 insertions(+), 99 deletions(-)

I mean, it certainly looks like a nice cleanup.

-- 
Cheers,

David

