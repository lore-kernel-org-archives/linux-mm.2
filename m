Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12866CD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 15:00:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ACF66B00D2; Wed, 13 May 2026 11:00:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7844D6B00D5; Wed, 13 May 2026 11:00:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C1F26B00D9; Wed, 13 May 2026 11:00:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5D45B6B00D2
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:00:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0BC42160182
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:00:43 +0000 (UTC)
X-FDA: 84762708366.05.6776A1D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 36EE740009
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:00:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fxinpcWi;
	spf=pass (imf11.hostedemail.com: domain of hawk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=hawk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778684441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Y/nq1aLv8jnmqrQgpS8tPdBgoO1Nmr2VW8H0CaACr4=;
	b=5TK775EWEwbtYVxf0nkDW7aDrPXlSSW83tbmUT3khh7VqEZP5F/gy0QISeUd2+cIiEiwCB
	HcBAVXspTQEto6k9YkEbgntvwvYhCis6iMqw3w1kDpuN3Z+NXyY5ZhWZ9TV8UNv1xcXkA0
	Caf4D2jL2SjUaxWQqf5zZFWJ3LePbXM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778684441; a=rsa-sha256;
	cv=none;
	b=8mlZYrr1SNeaaFwtqvRWrP9rT27DlyBfSgBu+XhGCJnaKEcql0O95hfTEW0asB6dDDEB9H
	oLX0z1yDHASquDhwrHOXZpI+XkfVWr6SalGYwGVYWIQ5ZzzgLuINW0noMrK0OxhJtsrjMQ
	b1H++izMPYHH3JGP8YvbC8lPRTb8Erc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fxinpcWi;
	spf=pass (imf11.hostedemail.com: domain of hawk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=hawk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 763F260121;
	Wed, 13 May 2026 15:00:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6067DC19425;
	Wed, 13 May 2026 15:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778684440;
	bh=rFQxbFf+d5v40nY8+ULLt7p0+NDFB26iq1h3cbEuAmI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fxinpcWicIgDP/jjCLvgA8QAhRzHwuNnSTLNbHpNh7LOH+bC8AKIalAivbk0uMKKF
	 dq+RbDNdaq6+GAW3+9qNFnDX9vYtSZht/5yHP+dgTYUJP4wenFJC/MiN6gt6Jg7xkc
	 ISZPm8IbCFH0pwDulPD0PyQ2NNs5JfmHxBhexRTXQ7e6Rc3vG8LcisZlpTTSIVO3mo
	 SehVfsInq5CECU/dl9kI5KgqF7af4YS/fdr8H6RxsS5ti97gEXFEsoj55QGYVMjZVx
	 PkVik3ugjSSi4yLzqifdDrlVkw0mGRTCbfWnbyRnyeKpqNtn4gxba7Dqb4BAF1PRRh
	 gY5/EPm9Kx3/w==
Message-ID: <f00caef7-9f89-4252-9794-76e32a2c3336@kernel.org>
Date: Wed, 13 May 2026 17:00:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] selftests/mm: add zone->lock tracepoint verification
 test
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: Vlastimil Babka <vbabka@kernel.org>, Steven Rostedt
 <rostedt@goodmis.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 kernel-team@cloudflare.com
References: <20260508162207.3315781-1-hawk@kernel.org>
 <20260508162207.3315781-2-hawk@kernel.org>
 <d440b00b-6d7b-48cb-b37d-43f6f885ed01@kernel.org>
Content-Language: en-US
From: Jesper Dangaard Brouer <hawk@kernel.org>
In-Reply-To: <d440b00b-6d7b-48cb-b37d-43f6f885ed01@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 36EE740009
X-Stat-Signature: h11tqo3rinqsy7w4aoc8z3oh4oajnt7n
X-Rspam-User: 
X-HE-Tag: 1778684441-91127
X-HE-Meta: U2FsdGVkX1+aD0KQeWjsZ/dD7l3p57nQ+uA8JdUlrySeTXxG17B32BrzODXfE7CRn4ltRhsVUGYlD1rXD5aSNrQIEJ/9hUG6SYPWonMPwEvIm2y5n6zeH+vDr+EUEat3hCjYNHcrZ/npQ/gxHKAlrqDlPNntY+gWO5DdJ7rf5JCJjGVQkcUBGqMUXF6Gnfnuyb8Q0vZ5pUTt5N9+xhL6fcyJrwSpgBDT+rdXXHpui4YrnNIcWII4NrEz/9bYMHqCe621IacQZ9W5W0lksMPZt4//ApYBB8Gsa9G6DeWUoF2yT1l23URkakLOf9cdYvgdIBF2yY3+UzNm6Duj00WL8AoM3gJNQis/nOF1kaJHp8crTaMiNpTJe9apIRIC1BiTmroiiZjKKPWarAodABmu9F8dQQEVUL3xamJ2cZllTVYOKh7aUZ7VDNSMkSlUI24gQOEVEwslAwU1MjhpHuJvYxKYLvB9utHjOhK6//z0vnDzh1lyMBJzbUEcCIy76y6J4yDxwt1YlMLET8xbTusYiPFOc59FD/XNogvNzLCiynwXgjv5QvBvbTySK5YRtgdifeSEAag/PUW3eAXB/c6fziLFc5jjIt+GaftTtmMOiPxYuYa7hOXdPsF9ZzU9GWa3kuNGk7U/4/6pB6ZZ9rB7CrNeSk0nMKdVFBzM8E+buaEVFt7/aqfH2HEqqvlshi8ocF2A7TpWVq9yc2BfhEDa13lPnoTfMonqVeNE89ahyQqNTYmy4pRLc9osJ8cqcK0AllWpQ7bYG+6rcwi2wg5bdHeqweWsMarHVj5TQgQPh/oNmZzTXfnrGGnu8sho1NNiaDQ1Y+EaZjLPRj6vngkiCu/SzNHSwevaWtJrGm2ByGZ3YCONoSmqJV+rQPDm7RBrgQ52QW5RDZ7CigmVtVWmC8Lf8aqJUf5HgxJ2SIEf7k1Oab2OQXrpfqTQjd+nuX14jveLp0VnzMz/jyY3W3U
 VqsTMGiw
 hYY1lXM9BLOTehd6YIMOQ2XIiEwREXr+IxD+J0dL7QttA6ud9dXxy2JNS11nFgr8i5ACZfwoCu44hziknKqGMsCGm0+pZaPsnche+Q6YBRlPvHBllAKOgFp1UVKRWznNypmQRTCRshL3l8BFMpp0129i/cYI3NscDRCMebloOmhei7+ORqKxSGvBeyCyMCmEqn3u3r5rW5YyolKy/NeKS+TNtnd5gA0Ff+LNENJYLEKgx0j8qhX9XGp6vwWoklF+Lg7nFel2N3K+8FQlC4fIUXIObow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 08/05/2026 22.15, David Hildenbrand (Arm) wrote:
> On 5/8/26 18:22, hawk@kernel.org wrote:
>> From: Jesper Dangaard Brouer <hawk@kernel.org>
>>
>> Add a selftest to verify the kmem:mm_zone_lock_contended,
>> kmem:mm_zone_locked, and kmem:mm_zone_lock_unlock tracepoints.
>>
>> The test has two components:
>>
>> zone_lock_contention.c - a workload that spawns threads doing rapid
>> page allocation and freeing to generate zone->lock contention. It
>> shrinks PCP lists via percpu_pagelist_high_fraction to force frequent
>> free_pcppages_bulk() and rmqueue_bulk() calls.
>>
>> test_zone_lock_tracepoints.sh - uses bpftrace to verify tracepoints
>> exist, have the expected fields, fire under load, and that wait_ns
>> is populated when contention occurs.
>>
>> Signed-off-by: Jesper Dangaard Brouer <hawk@kernel.org>
>> ---
>>   tools/testing/selftests/mm/Makefile           |   2 +
>>   .../mm/test_zone_lock_tracepoints.sh          | 212 ++++++++++++++++++
>>   .../selftests/mm/zone_lock_contention.c       | 166 ++++++++++++++
> 
> This really looks excessive and ... not really how we usually treat tracepoints?
> 
> I don't know about others, but I don't think this is really what we want as a MM
> selftest.
> 

I wanted to have a program that tested the code I changed, so I simply
made AI write a verification test and asked it to create as a selftest,
that I've run to verify my code change was correctly implemented.  As I
needed to trigger lock contention the test is more advanced, but luckily
AI solved it in only the 2nd attempt.

It makes sense to drop this patch. We shouldn't keep this code in the
kernel tree, it simply verified that my code works. There is little
chance that this test will catch meaningful regressions for these
tracepoints.

--Jesper

