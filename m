Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39435606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 06:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M47Q5eJ+
Received: by kanga.kvack.org (Postfix)
	id 5361E6B05B2; Thu, 26 Nov 2026 01:42:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E7686B05B3; Thu, 26 Nov 2026 01:42:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D5326B05B4; Thu, 26 Nov 2026 01:42:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 184DE6B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 01:42:00 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 92E371602D6
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:41:58 +0000 (UTC)
X-FDA: 85476325116.25.AECD3C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id C475120005
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:41:56 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M47Q5eJ+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795675317;
	b=utQ3xBNr9g/TdQu6ssKxCHMU/+L4Q8FVd8ATjqMhnAgqbBTajSsKHqTkaT08bi7rnQZ5iw
	4a7ap6X7djBXeswfB+oNryT5VLZXAQOlst6jV3wbYn3sIhbvTQFx7OnvZ/vY2ayIICPKNe
	RC+TYCmebajpXCShplZm3KE0IPQBQUE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795675317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wgeUolha0fJQH9UwTLcaDXErohxlBmGVPsT2catGQk4=;
	b=gQ2ifRUHpIx32eV3EjYbmjduBzHG6bLub8/zja0CsezIuBNsego6bOaAMK4VzeggYXu/hw
	ZEI680xDJ0NKc/N6DVHT96PRi4wi7QOvEZF400P6AQPjHWXPSpu1eXrbPDRb7Uj8n5CK5L
	3eRUMkToRQOAtjAnGWoLCzRFKNT+sC4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M47Q5eJ+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D38F2416AC;
	Thu, 26 Nov 2026 06:41:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD1931F000CF;
	Thu, 26 Nov 2026 06:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795675315;
	bh=wgeUolha0fJQH9UwTLcaDXErohxlBmGVPsT2catGQk4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=M47Q5eJ+gBbg21TeYhMgcQJmEolXZeGyr1Z3yNmNIhsk8ZCUDRuYEPJdLV77mzPDt
	 bs/OWPm7HRyz2gDPAT7YlDQ9F5FeGXPadxEC62HPXUdNKrcZ5KNYa0eKncwoZ34xba
	 rNX0wPiDl01AO0GxeRZJXGI6FbZmbuVL12VmI6xOAtOnrtSuIaRR4FswZdpEdvM4s+
	 ZCKU2WpeiAi+xs9SEY3M0zKI+z9k3SYhkrzPRDxiZuZuBwielUOgpc/5i/OFHARn0H
	 0VHxvCMoMASX6x4Am6ugvOFAges/84GO2oj2jbmtQ6yZmdID/5k3651dfTxxcNS2N6
	 zwjuHgmnR6Q/Q==
Message-ID: <fba23668-add0-4787-b027-bfba1f66e090@kernel.org>
Date: Thu, 26 Nov 2026 07:41:48 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: move the HMM migration benchmark out of
 selftests
To: Balbir Singh <balbirs@nvidia.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>
References: <20261126025653.1344932-1-balbirs@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261126025653.1344932-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: z57sgi513gku1bxrghw4oeg65g9sffj7
X-Rspamd-Queue-Id: C475120005
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795675316-212891
X-HE-Meta: U2FsdGVkX1+UKHg215FvnLDZKvnAtdeHoFnrAJvvhG0LJ9G64IU6oqO691xr63+gyu1zPGTL+yBtEleSSgz+fixsXAddV/AmqkPgZWIaphqOnQw28UbbUruPWiWcq2Kv1HMPsRILU8SOdFycpzvip7istXNK1y2RxzeVyg7Yf5fBhp5+tJeSpTSuqYytzwL8ISSWPGb0Vu0JKu3B3MqVYn9NhyRO74cUtkwh8PONBrYZudOchmOumlU0UcIuO3zfOFT+GYIKjMVaCh3xfiPRovVOPug1hUPDhQ3o11iuDbATi0nvwNPlJ6IzaQgYRsz+SeFrNA0JD+ZjMdNdE5RpHHDYQpMvaV8YdvEYUf+TZ712phtb0m4itEWEjwqB+s0yqJkaIFnsZ+qYo10p8T19KG4QNQmh+vU41QG1LE3tIE3pDBdaLRLSjH7TR1DVd6BhpUCWT7CL9pFIJHpDJvbcv6aX7jMZq7Q7AaimAuxADh5BY0qoIxc7thA58H3hFSHg467t9m+XiV1bfo+vjN8V4MNkJRz7MlAjOSuQDPqBHKQ2XNqGgqFc/C5Sw4rlrOieLiOc5atzlJNiynGrB3dITdS/ZG8IaJd+G1KReOt+Xg0jKT2L08VVbI3UOb5raZfSYqE4OcFqofcAWV6j3HLR4UOA9ZXZN9NMaAmVVh9rlC+mqZiv/t60sShZyDLKl9kTRCcvxTLjlHwDgMasCoX/fFdZ79718WriB9L01GlQdYkdge5E5vzXXAuJbNuwyQ43FM5MmY9mLblSJUuD5j8UPlvjDV3FpcKkEYSNg2pq+NTLwkhxS0POyAFzAnOOd1iaGdHDxkP5KOlAKJCZkjcensKvyz22fDjbY30vHp6r+IFhbWIzhVm2gocGmsmSs6ufMrXrL21kK+6vl/nE6NPzmn8JEKWekHNUb8RZAlWFl7JndO20rFMTQh9C8hXapcq/suN2jIc+AdS7ut9mkjD
 JjV1Ok36
 1ksbNFS7ScMR0Sdm8t+44MZHwbs8A4DWhbiuZdskUjphBACmz5dng+IJuqEGGHJzxTMgXpFUDzxnXErkFx1drHWi7EwuuBP6lameqMTp1Xcv4Qgqt5QHQg9liEBqqy3nzns5SehylFolT44JJSo10bU2mur2f4TTgC9shDUZWnFE1ky2ZnzKSNaiVFO/3JoycB2+uLguABR2E/bL2HL2mvUuWHg+sTpMCIoavZI6YGXBxLi6q7cb8iA3r09XiVeHzGKSyy9rdf05i3AVqzQ438UEfxCTDAHL3jk2VhCIjr05XOS25bzvyuLBR5HFsD1cp5k89RHXvkAuq5RZdbT6el4LjaYtxP8fMc8hTVEeBJVfuGeAFwZrIHR5x/OeZ6RN/NzQ4o0v54ULBHItJSYfWa/0YMCcTxKcmPBusYmD8aooPhAvryOXcHKNC9RXrqapHidmam06VKN0+f6NZjwp8l+zjgT/TFsngYOtc3HCyHtTn5N0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/26/26 03:56, Balbir Singh wrote:
> The HMM selftest runs benchmark_thp_migration on every invocation.
> The benchmark repeatedly migrates buffers in both directions to measure
> latency and throughput with and without THP. Run it on demand so the
> regular suite spends its time checking correctness.
> 
> Move the benchmark into its own hmm-bench binary and share the device
> fixture, buffer helpers and migration ioctls with hmm-tests. To run it:
> 
>   make -C tools/testing/performance-tests/mm
>   sudo modprobe test_hmm
>   sudo tools/testing/performance-tests/mm/hmm-bench
> 
> Drop the 128-PMD buffer to bound the amount of memory migrated in one
> measurement. With 2 MiB PMDs, the largest buffer falls from 256 MiB to
> 16 MiB. The remaining sizes still cover buffers smaller than a PMD, a
> single PMD and multiple PMDs, with and without MADV_HUGEPAGE.
> 
> Call fflush(stdout) after printing the results for each buffer size.
> The kselftest harness ends the test child with _exit(0), so timing
> results still buffered in stdout can be lost when output is redirected
> to a file or pipe.
There was recently a discussion on where to put performance tests. Usually it's
much rather tools to test performance.

So what about tools/mm/ instead, where we also placed gup_bench.c ?

-- 
Cheers,

David

