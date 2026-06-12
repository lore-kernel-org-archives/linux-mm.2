Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDC85CD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 14:44:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D5396B0005; Fri, 12 Jun 2026 10:44:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 287B46B0088; Fri, 12 Jun 2026 10:44:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C3A86B008C; Fri, 12 Jun 2026 10:44:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0BCD16B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:44:45 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A3C0F8ABF9
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:44:44 +0000 (UTC)
X-FDA: 84871532088.29.7AA5353
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf07.hostedemail.com (Postfix) with ESMTP id DA43040007
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:44:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K5b4np2E;
	spf=pass (imf07.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781275483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sm7LC9s3/U6zi4eNQM8LGi9/FBieRVF+Q1Y6/W1/d70=;
	b=W1w9fX9vzrO2ZPPwjRSHuxpz501vPLWGQm29IDnjgfOwRVcxcP5errqwLpLdWX7jHjh8Nm
	O6hgwn6sR+WweXRjLE7kWtpSLy4tjcXtX2PNfblwppksWLXeEeL/A6xvRyV+sXkYdMBIzI
	0K+WMny1wYTVcn9Qw4CCigPgKmY0euA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K5b4np2E;
	spf=pass (imf07.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781275483;
	b=1asfO9OPGqpZcvH1FZdM/UJxQD3foDw85cPEIUQHm9fvag9z7nEq8EIPxtuAHe6k5xvfAz
	8JG9fSegr6Us/YUv+bCZsQ+JT/JauHtL/x6cYt/Dq8hL9FOx3Cu3WIYV3kqxt7GLO5nSDI
	ivIIeu0Uv7eRLLDGj/qjJXsqv62W6Ds=
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781275479;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sm7LC9s3/U6zi4eNQM8LGi9/FBieRVF+Q1Y6/W1/d70=;
	b=K5b4np2EH2mufIv23N3XE8xiNCf4JF/aTU2vhFHxHQUYgQ1TVc0QJX4aSqWcZdPNSXg/iN
	B9cjFzIIfc/nUsQ94SI/UuxPc3ghxQcnz7naL57jdlM0OMXIvvAWR/RpuW8EmuXwZ/BOWU
	CuJYJLlNhIYY4fTEolZyYcrmhjpGM3M=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 12 Jun 2026 14:44:31 +0000
Message-Id: <DJ75GER4WC9G.3PEDYJQ5T0EWL@linux.dev>
Subject: Re: [PATCH v2 09/22] mm/page_alloc: don't overload migratetype in
 find_suitable_fallback()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Gupta, Pankaj" <pankaj.gupta@amd.com>, "Brendan Jackman"
 <jackmanb@google.com>, "Borislav Petkov" <bp@alien8.de>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, "Peter Zijlstra" <peterz@infradead.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Wei Xu"
 <weixugc@google.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Zi Yan"
 <ziy@nvidia.com>, "Lorenzo Stoakes" <ljs@kernel.org>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
 <rppt@kernel.org>, "Sumit Garg" <sumit.garg@oss.qualcomm.com>,
 <derkling@google.com>, <reijiw@google.com>, "Will Deacon"
 <will@kernel.org>, <rientjes@google.com>, "Kalyazin, Nikita"
 <kalyazin@amazon.co.uk>, <patrick.roy@linux.dev>, "Itazuri, Takahiro"
 <itazur@amazon.co.uk>, "Andy Lutomirski" <luto@kernel.org>, "David Kaplan"
 <david.kaplan@amd.com>, "Thomas Gleixner" <tglx@kernel.org>, "Yosry Ahmed"
 <yosry@kernel.org>
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-9-28bf1bd54f41@google.com>
 <646fd09b-0dfe-4646-997f-22e464bca024@amd.com>
In-Reply-To: <646fd09b-0dfe-4646-997f-22e464bca024@amd.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: DA43040007
X-Stat-Signature: ogi6udigcdhztjbwsbr5sghuc5kix7gz
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781275482-190595
X-HE-Meta: U2FsdGVkX1+l0fjYyRNlWnsFgppTJ9VhsneySweQtthZfx8zXclVGbtyqM3eIOS7PRKyj9rcjNKrk8wTcSD6fy/nwy877BQmuW/PyhN63ydRcReWdcMbm808pw2Mmd7gNTfQlq+/JvcNi/Usw3CnxW5CDAuzBBxVhHzM4X1jge2VilNUmEt+3kFNYosBuHhkITVH92/O00jsTOP7MkQCUj5YLDV7d3PWmZYpiEw43A6y91KW3xjKcieMP0Gxd+FHT16huLKikzi8p5hdokcFcL8UZ4YiQMdhIC/qvMWshOep8YikQ9X5COEun7ajQdkJg1i1zNk5oLZHm21wGId2zvV363pF813Osc3x8lmDCPE6seJIKqjvyuFsmzK/HNNowJEcfnAMgGKnslnmSCuC+uJJdenEdN7PWOaeU7ptUAq9HU9DRsltcphNsaQsn1B5tijlsdHJP7I0C//UW4JNKLixShjYf+nPYmVu6N8DFsUYdN6i65slnhSbJnaKnRI9d2P4kDEzb+fhmA0dXMhD7Vz7citfqbNTOrhObLKm8vjb0HIgbir9vwvjS11PSlK8BPDsVxykz83RcfiicKQoxGUzzVmnJQS8ImM9Ms1Ekb2zcHhicz3l5c01ZgrZW4yMObzaLK0vBl/NCaErvLfM6xMV0ub1vnqivIaabu/bpr/kXkDJlx+3BFnaZWZFHsCMIZMFwofMY1RjZSi7T4jznjqNDp+6uzyFZXtndC54i7+LlmPnH5r0jEhHyDe6U3FyegfFWqEVNpE/d3nWT1rUtcLs954HPvXHdYPgrXPo4Bzk9XCACGJoVbt+n0KgQm6rEbdWz0jBh1F0h3u3lhetebp/5f2QNXkuZWCp1AfSQwcrJyCUd13yqoLAexpxEf1pU4Wq13JK7HmECpK6QQMFxuK1/Uz1vi/79B04wBU0ph8NHA9fVRMkCqjCIqag4z0ykuCIILQUJM6D9G0p5kK
 hbJryTaH
 bTwX1nos5pU37KJ2izz3/SHoP8NxYX4/1wccjWzdpuOYOexqQnfhoju4ekhZ0WbH401SdwqS35jwliInFtNnT08XBjaQ7WVcCSPI2QjNenwSVaRVTvoxYo9a8PXOtkJjwMAHGR1RpxngswYeU8qFjYoTORTn14bqmYpobSlr5UYGJ9o5qpQj0OVcTwLQed0s27fRKAISFaodZltncbSTUC9XXTHY4nCHgXdOZr6XPIWbS3LRWrmS3TNRI/uMCc5N1YS3j79s77c6aD32ibK537edqTIVPKcce/hiPXny37FOBczCeubrjThH16CSIj6AnddvEgGHFKuWjZ0i5EZHxTa3MsyoeXPpd3Pog
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jun 12, 2026 at 1:24 PM UTC, Pankaj Gupta wrote:
>
>> This function currently returns a signed integer that encodes status
>> in-band, as negative numbers, along with a migratetype.
>>
>> This function is about to be updated to a mode where this in-band
>> signaling no longer makes sense. Therefore, switch to a more
>> explicit/verbose style that encodes the status and migratetype
>> separately.
>>
>> In the spirit of making things more explicit, also create an enum to
>> avoid using magic integer literals with special meanings. This enables
>> documenting the values at their definition instead of in one of the
>> callers.
>>
>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>
> Seems independent patch with no functional change.
>
> Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

Thanks Pankaj - also BTW this and some other patches were already split
out into a separate series and they are now in mm-unstable:

https://lore.kernel.org/all/20260503-x86-init-cleanup-v2-0-bb690bd2477c@goo=
gle.com/

