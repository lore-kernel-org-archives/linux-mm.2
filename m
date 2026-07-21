Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 947ADC4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 10:20:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B1CF6B009D; Tue, 21 Jul 2026 06:20:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8897E6B00A0; Tue, 21 Jul 2026 06:20:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7786D6B00A1; Tue, 21 Jul 2026 06:20:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4826D6B009D
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:20:11 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DDE441A0430
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:20:10 +0000 (UTC)
X-FDA: 85012388580.07.173D8F0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2035A16000B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:20:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kU76rASF;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784629209;
	b=8Yy19g8qYeLcXj0u1hChLbl3bwIiiPuACPeJTFq4SlAeY1d9MWhDWw5G0FMrDSyu5064ZS
	o6/gzFmdKfUgduEQ+jrh8XrPk9zKIaNRGu+tGGnYsu/XfurK8v5QZsRwmyirVH2jBzKR2P
	LQvR9ps8lWKHRDqhe66A53QbiX+40BY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kU76rASF;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784629209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BNWrnw811OJBg+6BewLbq493oMwQEWccY4LqPLjda7c=;
	b=5VP2BH+4WHxN2hPza6yL+kDD0Mqt4R5A6Ugp1lN1iDoGb00pa7L/mW/RGJEojuWqK+AuDK
	q7I27zXLF5NhXX5WFLEUmLkgCWd1RmpigUbAcnaGISsMZ95L3bwnmfqGzP5EBy6u1XDk93
	7EzOUugF+zlcNfPSZiRdP0haZ0HFEgo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5729A43844;
	Tue, 21 Jul 2026 10:20:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361B01F000E9;
	Tue, 21 Jul 2026 10:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784629208;
	bh=BNWrnw811OJBg+6BewLbq493oMwQEWccY4LqPLjda7c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kU76rASFWKYmJ7QKivBssiz5Ym9//MoSeLyp+lSNoR1z/Ml+UgzXyrM6umr6vZB0d
	 pAdySnhee6mf6T64I3FmFbPbVC7htZIFKdBcxn0WOE9fNlLV3qFjrC4rGk4sFfLyT+
	 6KRvnmxZCJ5YkkyCiNjRPOJ8efSXUghiK+8Ib1pmgYsrpcUyRUjE6Dp2l5SUcZWid1
	 G0k0SfFdUR3YY2rTOXWWHijfQBWqUTgIhQa65uH7ww3l78l0zgpguIPsysNqL1N7TN
	 VJHWvGzJP8s1n80rqAmrG1f23FPHtRDs1ZjLo1kxHvZhQHZBhYBR2HP/DqPUzDYWbL
	 7JuX7ZT8QDZLA==
Message-ID: <d6c3eba3-c596-4903-b298-ac6f424d639c@kernel.org>
Date: Tue, 21 Jul 2026 12:19:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/7] mm: defer address-space teardown of large exiting
 processes to a kthread
To: Aditya Sharma <adi.sharma@zohomail.in>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall
 <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
 Valentin Schneider <vschneid@redhat.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>, linux-mm <linux-mm@kvack.org>,
 linux-doc <linux-doc@vger.kernel.org>,
 linux-trace-kernel <linux-trace-kernel@vger.kernel.org>,
 linux-kernel <linux-kernel@vger.kernel.org>,
 imbrenda <imbrenda@linux.ibm.com>
References: <20260719185409.409685-1-adi.sharma@zohomail.in>
 <d1180a70-f4b4-4c22-9ce5-881cb0e2370d@kernel.org>
 <19f80cb1ed8.13fd666243425.2308143427066829733@zohomail.in>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <19f80cb1ed8.13fd666243425.2308143427066829733@zohomail.in>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 99a7w1npbw5aodg1aca8p3ofar35wtjb
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2035A16000B
X-Rspam-User: 
X-HE-Tag: 1784629209-171785
X-HE-Meta: U2FsdGVkX1/HiFGptXvCrOYpwu+JtZVdMxAUwXKhyFF8WTWGdCPZqJDqyWpqRjFicsm1D791qhDa/7QMnsFwx5v9f6RHMhsXNLeyk3fVPgk0jrNSAB/k5inmYZ0/MVMAcFelmB9PasxRy7EwkE/nwMfHJGbbVaoV7bEFVK5fkJJ5UQQJRIHxk4iPH1UMgRnPsC+rYH1XN4gq3cZiogckTThGE1UBwg+XYHFO1KJ/KkM7pa37XcdAUVCWuQNGtwuBErhMQoghQmmwSZBCjsDvPZwZRvoRrlMx4YPlt1/SOuinTyapB8itt0TEdQpVZaCeN54JHYoMxQrHWUJpZC4B/o+iWmiLQpxkTpl4BW21Yl/6j9DG/9qj2MKD4JbL/yQ+i/Ux9ZfTw6LbYdQ62xNlxe2FoDlmwMaq97Hf/rAmCECaE3lG26n0KcUCXaWav84sdToCpQZqNOLfuQu1U8kQEzwbPUeQ1v6nmYV5kF6bLYjnEUMIe4m2b/DwqHrFuo1Ru9YcetvEVVKk9+4xGZzApR/TbofB9nRdpg153TfzQBVk5ONhO6K4FL4X3IsGHPQKothJ4D+/MwcWeDra1E3quchNJ5ZqdGzISeUmsDtBiZPfNUCeWYsMieiPquwKmaP20+58CmvRjcmVWe4NNLoyfSKyULOojzQXFYKvOgwi6yH/Ssjy07l5IngeHda6ilu7f2bAI9FGnmGHPmUZlnkfQhI7T8k3oO0bp7QFk+P84N0TfCv5Vumr7EbmpoT0mdhxlORIE4dY/39lq2t0W7bUCoMrHdYtD+5wEx0j9etz2cIwEdVgA8HOxLXp6m4GkRL5s63v0xUddbTxuIxD/CU96ovjMpCb1WZWpASD3c461+gKWnXWudnJjBJnYPFihDgMtnGAI54bDydrsZ2Rf90ZsbOrL7Kyftd03TPf94Cco5eVCV3SDePL2lkwPsqnSVABUpMWNvF5bBkNLehrfP4
 oFyxGdGw
 59ucFPFeVunQgPHmRhHGD4g12DxKbqmLsCRdpdsivxe0wxRCE6RKsow+C3omyU/1CMu9YGjzSZ4RpTp9JmHeF2h9O6qfItD1RLd8F+sI47JT6t3uDVD9ej1aQoooThofg45oU2f8PN1lyoiyGX546RK4MNeMaflnivO5Zl6DFQyEy/X/2gGoJ5ecv4p4CEJ9UD58svJC4d1xguiDIHanr1sTqM+SdsZ2NEZq2s3ICQHNKx+SrmKfeuSxeUCS5kiQykIf7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[...]

> says that the s390 case was addressed with KVM specific async destruction,
> but what you point to is QEMU's shadow process. I will correct that in v2.

CLONE_VM seems to work for the use cases you had in mind.

There would have to be a *pretty* convincing story why we would want more
complexity in the kernel to handle this.

Some smaller performance improvements are not worth it.
-- 
Cheers,

David

