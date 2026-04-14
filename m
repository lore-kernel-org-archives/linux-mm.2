Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AEBFED7B93
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 09:53:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DDED6B0088; Tue, 14 Apr 2026 05:53:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 669BA6B008A; Tue, 14 Apr 2026 05:53:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5300F6B0092; Tue, 14 Apr 2026 05:53:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3E0886B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 05:53:16 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D9CE71B7F7B
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:53:15 +0000 (UTC)
X-FDA: 84656698350.01.B0C02C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 24D3C10000C
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:53:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="S/HbgSJC";
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776160394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mijJ7hpVk4NtXMwHeb5jGPomT6KuoLjW4OjQVt4T894=;
	b=Qq8mJzmuNVw08TaaYJ2FLXV7f7LKcBAfJAKkeAfh9YbHoH1mpLVW5BSBUZ33lk68FSPYe5
	6Gnt63XsDhZyOxNvwClGrnAgOleAyYQDPkfRBpcC/lo7qpiudXuEnxdiRonZM6c2TK0PfT
	1qHXS83QQKemJf6sto/MiqNnEwEvweA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776160394; a=rsa-sha256;
	cv=none;
	b=lAYfqUxvV3TuWV+tJerHGpeNvKdWvPhpnkfibiPsC0MGFn4POPNIvCqpLnWdY2+Z5h98zY
	lMkBqaezo8HmJ5DYzvQdNrh8zivT4lasNPznkKMGTRjGaW78AbtpjhyygRU07fY9K8GH51
	Wym6sslq/riKoOC/OOngVSiYN2jhrIw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="S/HbgSJC";
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 77C0460018;
	Tue, 14 Apr 2026 09:53:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF65FC19425;
	Tue, 14 Apr 2026 09:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776160393;
	bh=6XvkeH7K6YpHjPzJU8T0S8ZEsUF/REJjGBBC4+bnBk0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=S/HbgSJC1xisLbIYZkprBmKPEYPOE0dxloBxvt31ueSU+JPdxbtWoSJHPtVgj83GT
	 tK5sgFOB7Clofff1zo9lHBhTRO38sShtitPzt5GnFWpASA2qVrgXgrFXzOEfI6nnvf
	 pMfnrw6koYXVRqNyff0/vnmwfq+4Q6lNvpAMZhvOiFSH+Qihyf8/Pn+TK8pQ+pbnuN
	 lWAzRO4MX6p7UibBs6HKuXxet3KSDXMkWnVj3t70SdvPue/1lztATxNJ9jxHmI5p4G
	 9RfNAeN1Ht1V9OG+03MjybKC3Hw09EddWTx+SdCl6fj1xKq3nZLuAHVhUNANeIBbXh
	 G6eWOj87sujhA==
Message-ID: <c44d5afc-2936-486c-9806-01c942a73f70@kernel.org>
Date: Tue, 14 Apr 2026 11:53:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: Simplify byte pattern checking in
 mremap_test
To: David Laight <david.laight.linux@gmail.com>
Cc: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, shuah@kernel.org,
 ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 ryan.roberts@arm.com, anshuman.khandual@arm.com,
 Sarthak Sharma <sarthak.sharma@arm.com>
References: <20260410143031.148173-1-dev.jain@arm.com>
 <5297e0da-d8ec-49df-9b32-0d9f907588d6@kernel.org>
 <8b5544eb-5ec0-4c85-a2da-7a454fa606dc@arm.com>
 <134c372e-5c9e-493d-b954-d9954546beaf@kernel.org>
 <20260414104712.2b634741@pumpkin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260414104712.2b634741@pumpkin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 24D3C10000C
X-Stat-Signature: pmwrmzjarxidsctbjuor77gszngnzrc1
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776160393-38810
X-HE-Meta: U2FsdGVkX18/oxxAJLccixX4o8wkkv15oTFHJQxf7mnDvBRy+aGX0IOMVLzWcEw9H7GiBNW6LF+YCc7r7eM5GODL19FtJtSa269/JWQNt907Re2tJunzJs56hq5ngRwcJw73bE9eWgiFl+j2qhqTNAUh8bhtbl87XA36Xe5/skmWURpkfK4JFXQlwqiFoRhplOoqoZ3/k0z40jaSekFHTdWCz2ne0jitlULgyVenCrohwGz2z7FRmD1EGNbJY320laOLBCgGClk9ioR3xqz1VAhNgmf1pmC+YV3Z9CaN9jeDdBrODjootw6cEEw3QmMnxF0kPS2STYNEJRUxwqDcjcXIkWLVO7bwdhhROjOQpEOfINBqqyR+Jn0dIUJggBUq1XSSZ4E+IkzaqkUzwK/cNPInjxQMT+JXOYEwGVkcVzNoNVyNhscInt1c3+dcZljC6pl+8JNkS/IbWN0w4hRnFqz17SS9uY9iXy0CjSF+ZreXatoGGqlg0wRtn7uTw60AH3J8jSWs97Y2gzA1vq2R5j2CmrYxn4Rn4QX5G8NUpZhq1Vz56zBzN2XkATld4k7DfScT8R6kQ+6Nwr2QkZ4uyGRGAkh7TFPSOxX1s/6Y3QkPk8IM5m/qRMI2CKOLteNsvsL+O3xBkJeCqN2vJbpz42mmM7//oDOKjbAi1P8H08k1WpoMhwPTXusd4O22hBXONMOz7RRpMw5SujKlVQhXLEhM+WVXiI04fIlT4TPo9S1EGoMTJTzLXX0Yx8pPzKMT+j9AVQYeKgnhd6ne8SPr9IUKgiyRp/enVb1xLZ+jsalSbS98Nj0aWAB8VbWraoA1PSwbCADY7GoJokKfVQU0LF5ePPDMXnEK7rBaJQkSbp4ftt6XgreICrLq/bhzt8naCrL0woFEbJlFPnsgOs/BosoWkPZFNNxAuSoybw88LrXun7+YVkclibQ1zpluy/I6O2er40o8qg7L3oP4o5Z
 4I/gWRbH
 G9wSHzc5pxT5lA7EYybZcF4T4+z4n9P+tQzk0bj27nZt3dQ6ikWpu6HZrDkSJm+rgjOlD4+leOs+JoAzZt4OnJVP0MIrq643LwyJgFq9wGtiUN5uEBBJRtDE2YZo9BlI7cQJjUn6g8Jp3vQcAJZc9+e56tJxNUYbpQaFMvQsNZwVqHgRzCHJ+p2z5uIb1ko1zup1oOM8htG5nNUY47eOU7K4QYL4N7yc/ntpcbK/UnwuV1OjHoI4Dju+ZA9lFiLTUvn2vtn7KvbVNmKS1cyE7RNT/eztuxRipGZjZLiq/mcxCkjtkl9iSIGdu46XhVn9615yrkgLdUhm6cBm8O7GjiUcAurSAsItPzdBLGm9CdVscoytWMgJv2cBrZKRJJzTzfn0N6HgmL9UONfRVZfeEuisjWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/14/26 11:47, David Laight wrote:
> On Tue, 14 Apr 2026 10:01:57 +0200
> "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
>> On 4/14/26 07:09, Dev Jain wrote:
>>>
>>>
>>>
>>> Yes.
>>>
>>> I'll explain the algorithm in 7033c6cc9620.
>>>
>>> The problem statement is: given two buffers of equal length n, find the
>>> first mismatch index.
>>>
>>> Algorithm: Divide the buffers into sqrt(n) chunks. Do a memcmp() over
>>> each chunk. If all of them succeed, the buffers are equal, giving the
>>> result in O(sqrt(n)) * t, where t = time taken by memcmp().
>>>
>>> Otherwise, worst case is that we find the mismatch in the last chunk.
>>> Now brute-force iterate this chunk to find the mismatch. Since chunk
>>> size is sqrt(n), complexity is again
>>> sqrt(n) * t + sqrt(n) = O(sqrt(n)) * t.
>>>
>>> So if get_sqrt() computes a wrong square root, we lose this time
>>> complexity.  
>>
>> Ah, thanks for clarifying.
>>
>>>
>>> Maybe there is an optimal value of x = #number of chunks of the buffer,
>>> which may not be sqrt(n).
>>>
>>> But given the information we have, a CS course on algorithms will
>>> say this is one of the optimal ways to do it.
>>>   
>>>
>>> I just checked with ./mremap_test -t 0, the variance is very high on my
>>> system.
>>>
>>> In the common case of the test passing:
>>>
>>> before patch, there are multiple sub-length calls to memcmp.
>>> after patch, there is a single full-length call to memcmp.
>>>
>>> So the time should reduce but may not be very distinguishable.  
>>
>> Okay, so doesn't matter. I agree that we should simplify all that.
>>
>> The exact index is irrelevant. Whoever wants to debug the test failure
>> could modify the test to find that out. It's one of the tests we don't
>> really expect to fail (often).
>>
>>>   
>>>
>>> Not needed. 7033c6cc9620 does not create any incorrectness in the checking
>>> of mismatch index.  
>>
>> Yes, agreed.
>>
>>
>> I would suggest to rewrite/simplify/clarify the patch description, not
>> talking about "buggy" etc, focusing on the simplification.
>>
>> "
>> The original version of mremap_test (7df666253f26: "kselftests: vm: add
>> mremap tests") validated remapped contents byte-by-byte and printed a
>> mismatch index in case the bytes streams didn't match. That was rather
>> inefficient, especially also if the test passed.
>>
>> Later, commit 7033c6cc9620 ("selftests/mm: mremap_test: optimize
>> execution time from minutes to seconds using chunkwise memcmp") used
>> memcmp() on bigger chunks, to fallback to byte-wise scanning to detect
>> the problematic index only if it discovered a problem.
>>
>> However, the implementation is overly complicated (e.g., get_sqrt() is
>> currently not optimal) and we don't really have to report the exact
>> index: whoever debugs the failing test can figure that out.
>>
>> Let's simplify by just comparing both byte streams with memcmp() and not
>> detecting the exact failed index.
>> "
> 
> ISTM that if you get a failure it doesn't really matter how long a
> second scan takes.
> So a simple byte loop that reports the offset and data of the first
> error and counts the number of errors is more than enough.

That could also be done. But if the stars align and the test actually
fails, I am not even sure if the exact index is really helpful. So I'd
just drop that index reporting entirely.

-- 
Cheers,

David

