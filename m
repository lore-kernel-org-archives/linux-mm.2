Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F521606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 08:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=b48+ppwE
Received: by kanga.kvack.org (Postfix)
	id 7E0EC6B0934; Wed, 25 Nov 2026 03:31:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B8CB6B0936; Wed, 25 Nov 2026 03:31:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CE746B0937; Wed, 25 Nov 2026 03:31:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 494336B0934
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 03:31:01 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B71E21A0D8A
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:26:00 +0000 (UTC)
X-FDA: 85472958480.19.9D0DF4A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id AAD791C0008
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:25:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=b48+ppwE;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795595159;
	b=1tWSJJCad1ygRLedozINs1cWm1hb2qKDvP1OreKW4f8kT7WYOc9pOAPTH71E6XPFV3Nmc4
	orD3ydH5XOJbtltjZtUZmVJRBRhlQGrMC4ET1SviZL8FC2FOgt7CLqg0NLwQkOVQPrukGH
	h3YGK1qHbFVT2J7LDmHlM9dsIDYY+Gk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795595159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=04pywlPggVjZZXsvKKiktE10oUk8nyW7nRcN3gWRmzc=;
	b=B+oniXOjRJ626OE5XXVMhqRUYQdUN98KdquW0txTD0G1MBTpQZ+V0vL6N9rImBeLFkUJhx
	i9ULNyTc+gWuDtYZsjvlcYt1DiqElPZFZg62HXgx4HLUiRJIOXtYmAleTNrHjcWKFLP4mW
	KAUpzDJG4VCrRy0i5OE3e3rWiKg2CSo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=b48+ppwE;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 83E3D339;
	Wed, 25 Nov 2026 00:25:54 -0800 (PST)
Received: from [10.164.19.73] (unknown [10.164.19.73])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D55943F86C;
	Wed, 25 Nov 2026 00:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795595157; bh=uiMswwfCXJIy2pRDFuaBVv+NGaTY4TCXsaeQwexIUOM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=b48+ppwEd7Q/s01C/r5AKqqQm3kBnoOUiXuuicvTXvotWqA5KAkCDJb2AraZLfZvI
	 gxfMfw419n+HZMgqnCAhirgvICkVUAf1F1o+pUir+JHh/NWd4qQ0ieXNJK64o9ZMUC
	 90QtVVmIPfTIjygiO5pVh6vT7lVDFNVbyELFtAqo=
Message-ID: <ddd9f940-0e12-4b55-a76a-47cf4b1dd5d7@arm.com>
Date: Wed, 25 Nov 2026 13:55:48 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] mm: page_alloc: make the high-order watermark
 check honour ALLOC_NOFRAGMENT
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Harry Yoo <harry@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20261116125103.2894162-1-kas@kernel.org>
 <20261116125103.2894162-3-kas@kernel.org>
 <a066d403-1608-4c0b-b06b-0b786e71b12d@arm.com>
 <av7_n5llADUbJI-r@shutemov.name>
 <38d06816-e138-4edc-b26d-499617870506@arm.com>
 <awRS1q5WvQyKLAf3@shutemov.name>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <awRS1q5WvQyKLAf3@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jw4abek4p7q4td8kipeheaw4ajtjq6os
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AAD791C0008
X-HE-Tag: 1795595158-988158
X-HE-Meta: U2FsdGVkX1+jz68oAtS3M7A+ylDFKDKXv9wu40XQrQEkhZvhsVqZJSgWsR9y9vLlvyZ5Y1DhI+kVtKZd2nGoRVnFAlXx+Hx8JHf0S8EhgtZpR42BZf57k3B9qncQSo+eR0uGpeplNKvpWdy8P6yAnfwkCC6VCm6GR1cYfpO4+Q3oMYoTLUn/YHXs0UhCq1w6ApxrNRzW7wJ9nj370ai91nCKFTyz5h7Jj11wl0DoZmhw0qOP575BCuijZVERU0yWhaZMe9JpW2L2H6T4ZOTjnCSBwLnNPNEXyrlikkBqh3TY5VY2Sy7aW5sp5gaLodo5nwROWtT/16cktR2nep1zInAjSnT9PJRLx7olbKw0u9QoqkwP9SeMB+nySsARkX+sLPE0RXD0OvXHNw66f6hkZi1b4eY5UnhVjvC0yEgUwKkY+jlGoVC+pvQU/dvybYfIBulTBlBiCepBYtIMHU8sX2te3Lrz/62LFFtpdp1BHp3XHbOSGfeNkOqGb2UHoNyxWNlAh4nKNfGFZe/mHgckWatn+cYm0OqShOZ/XDwupVVDOrxCFv5bJL4MqUaW5JRDx/JI9fdPxj4m1R1nzJ7Qgxn4khrM5+sT3+aBUd8qFEpUHfvF0u2lJuD9+Be/vyIpuY9Fmf42rxFPuZhRIMTLtbvm1Fv1cU8spcXkxe4q3KEZ2Lrg/w7uW+jyXF3NhKh5G3+s7f+Ob5tfgGa2vJo6jZkh+D3ZmyoDvXK/LNqM1OU2Jz/BHFwlowUKSCLk+hqtYLNag7hEuNXH+7BpIwlvVVp7HlBtfu0Lj/tEMjKONqppz16YhxqPKB+nxIkUGaUJwxPO850kdmEDmtaTtj1jblxM+MGhcqR9V9U74RXIsQE6LMHmP9LkXkNT6tndQMhi33+SKvI1Wb/1Cs0y3/+SuowzogBshG4cRlnlq0CMseJIHqLlSoVh0s6VH9vGoEFWgg+H+mu07/6cwB++Mxe
 1WEJ0MlT
 yMxEO750l7KhcIC5k+aOQHTlPWpGJdPMJVV9EDR9b+j8+GSIdEMwSFkR7QzLhgNN/hTfRQ0xnVL6dtop6tzA9FaVQepox8N/mMZfT5g8/gXIKsqmfQNgV5H2LdH4/IkS1HwytAXP09JH1S17cM3D1B6I3FKkGZJmqYPh+HJQjnM1AGsmum8tQuthPkVx4fL/6nOpkStVAf6fv5/wMoIGDF/fzrV9C9BveME2C08tCeW/EsuAeUrhsMQ9/qlxxpZ58NclGVHVVP7ZZklzASnk4vcmPTuZE/JPJPy5IdtnSiD4hvt3d5vkNku4RNkB9Xdnyz1BQkPcoSuxtapVAb9FD8aEDUseRaRkrJtVqL40cgIvTiydeR8BcLXIeQwNY8fiATptAT7+mBcAgPlFcJaA1wSHC+342NLXBivEYGZK8M3kzCPD2ZHzmceiIW5RPl2WEFJcGLk0yaeo21b6sSmdRHNfNkG/hC3Ix/6/buDZROKt4V1cHvsCrOIiM0ygCHwqJ5Fip
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 23/11/26 8:25 pm, Kiryl Shutsemau (Meta) wrote:
> On Mon, Nov 23, 2026 at 04:11:37PM +0530, Dev Jain wrote:
>> But, for the existing callers who pass order > 0 , aren't they also checking
>> whether the allocation can be served?
> 
> No. kswapd's pgdat_balanced() and kcompactd's __compact_finished() have
> no allocation to serve. They are woken with an order and balance the
> zone for it. There is no migratetype to pass.
> 
> should_reclaim_retry() has an allocation, but it asks whether it could
> succeed once everything reclaimable is freed, not whether it can be
> served now. Its order-0 part already counts reclaimable pages as free.
> 
>> It is confusing me that both alloc_flags and migratetype are logically
>> part of the "allocation context" but some callers are doing
>> alloc_flags & ~ALLOC_NOFRAGMENT ... I am not sure whether the below
>> Sashiko report is related to that, I didn't check in detail:
> 
> Only should_reclaim_retry() clears it, and that is what Sashiko flagged.
> It keeps what the check did there before the series: it never filtered
> by migratetype.
> 
> Filtering would send movable order-2/3 requests, like 16K/32K mTHP
> faults in a MADV_HUGEPAGE region, to compaction retries and the fallback
> sooner. That is a behaviour change of its own and needs its own numbers.
> Out-of-scope for the patchset.

Okay I read the function again and it makes sense, thanks for explaining.


> 


