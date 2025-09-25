Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34C9BCAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 10:33:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E4D28E0013; Thu, 25 Sep 2025 06:33:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BC578E0001; Thu, 25 Sep 2025 06:33:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 820248E0013; Thu, 25 Sep 2025 06:33:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 746858E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 06:33:19 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 15361C0432
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 10:33:19 +0000 (UTC)
X-FDA: 83927410518.19.BBFCBD5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 61CC81C000B
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 10:33:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758796397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zX56vZQh6ddO29l8CTyATJ0DBEdvf0QQ4/NcvsRny1g=;
	b=iOgAn40/hSsfrSZ0T6tfXTw8yWzZqlQgow3XnKqpYWyqVQSTzaB07K9d5Y5D5Qpo+esAlK
	CGl4EysMKGM758kMz7T6dEtVgJAZBcCnjOEcYL1xpXZfUmBCLbQwq7IF7zWPOUzTZS6Wj9
	MxOIwJA0ggWZSn6wlct9DM8adSQ8mgM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758796397; a=rsa-sha256;
	cv=none;
	b=VYIvomc1MWUGoUVzHuaxRSOME06zkAvmvsu+lo/5YsJZLeaB1GbMPHjrGNtntXztYyqs3x
	BpI3NJXMm5OiXpH9ralVkEWgTuTGnsKzI8w2SM/MyyQSfHeTUXR3RNtPvhDZ0aneoUWy9O
	6cCDoV9OaUuWVSt3bz1ogza+sqNkyPQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 37F0B1692;
	Thu, 25 Sep 2025 03:33:08 -0700 (PDT)
Received: from [10.164.18.52] (MacBook-Pro.blr.arm.com [10.164.18.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 701BB3F694;
	Thu, 25 Sep 2025 03:33:13 -0700 (PDT)
Message-ID: <45e08ee0-c85e-469e-a3eb-4ca2e8b7ec0c@arm.com>
Date: Thu, 25 Sep 2025 16:03:10 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: move rmap of mTHP upon CoW reuse
To: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Lokesh Gidra <lokeshgidra@google.com>
References: <20250925085429.41607-1-dev.jain@arm.com>
 <072b8684-47fe-4a2a-bf69-f6d348f0489b@redhat.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <072b8684-47fe-4a2a-bf69-f6d348f0489b@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 61CC81C000B
X-Rspamd-Server: rspam05
X-Stat-Signature: 6q4supcg75bp7aqnqughakn346z86wg7
X-Rspam-User: 
X-HE-Tag: 1758796397-614812
X-HE-Meta: U2FsdGVkX1/qYS54/h7qT8xUf4muMkx+TlgOqAJX8qzcoUOn8SMvA+YTM6oJuzowSu8sqmNN+6G/IZV7rPLISeRxJeM5kkZ01QIucrTIx/vfE0sGgu7NbglG0UK5FE5BA56x9FiSJRLnYWXOh5hSvtwmqF/evLu9eNiWzTXYhsPSzof1JYewGP540cItwsrGliSJqhLBdwcsOk2czwX2AgqQ5Bi/7rb+BCqIsaOITHttHJjpp07EGJwE1gyJCzE9k5sgv5ULN+VbgSLXlrFSPdCxk1b7NO/H4zfkPbJdOIhZHdvansqz4ezK0eRZ2EcUGpg36QWBq78n1WSBMWhy+8TTR9p6z+e0HF9Ho4pDVqP4RCgGVUddMF8Xvv34bmq83l09Jrao/GGlGD6+cZECj4scdgffspkGoGQKdUHza1J2Xoi8F55ogTiR6QQUoPNCIKzA0VRe5uoIOBHW/foHDHt5tm0v3p7XS3vwCmqevcE7owU5ylNRPhnquEl1LSMsZMe5Kq+P6acg+oI2L9Dcm8OLMRJzoEFMN1u34lLB8a9tNMy7a9xcN7jO9CUjTc6/g/zGzOdbIClepM9sMgXTQO3DHV7Lhs2ZVVuydXxBbcILGnt8FzsJkYbOUX63Ue1SIvf6dSyW+66OeKi5rcqsMsAbG04iGM5rVGDXINmzVZVbBSFMLHtV8cT7Mlay/zsAYUVMnWcdQM5ophvzgIpr5oFjfhqlc418qkPeInLNzYOYqPKi4IVpeHmLuCxmbTTL4k8e1IHrmqY6aaQ2bfSMGwiI9CkOlxn981haWpIZCdb1SsBRdcXGNERQ63wjO7G9M46XgTrbucBbqWszk49zMWKrMwVrmz1QrXvcLZuqEwT/Qo5A8K8Qr4QA/XKukaIMu4gZjE18CSEvlxwUt+qcATaflOCGSPJLKiMjBWYPea/d7hHx3A2z8rNQEgceDY0paLjkuTfeqy5zfsVeNvS
 z3tQNTw0
 98SIN9mvWdMHe9k4LgL5tkmo3kVggSfBz2ufWQ3xQP3FJ3NWhD84JHsF6Kma+wGQe/YsrsZwF2NUhukMCYRqNasgkqWz8XyNcWeQdj9aasjvyQ3GrVxmtcUTj23bRXyqr8K2mczg5mBfIddo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 25/09/25 2:46 pm, David Hildenbrand wrote:
> On 25.09.25 10:54, Dev Jain wrote:
>> At wp-fault time, when we find that a folio is exclusively mapped, we 
>> move
>> folio->mapping to the faulting VMA's anon_vma, so that rmap overhead
>> reduces. This is currently done for small folios (base pages) and
>> PMD-mapped THPs. Do this for mTHP too.
>
> I deliberately didn't add this back then because I was not able to 
> convince myself easily that it is ok in all corner cases. So this 
> needs some thought.

Thanks for your detailed reply.


>
>
> We know that the folio is exclusively mapped to a single MM and that 
> there are no unexpected references from others (GUP pins, whatsoever).
>
> But a large folio might be
>
> (a) mapped into multiple VMAs (e.g., partial mprotect()) in the same MM

I think we have the same problem then for PMD-THPs? I see that 
vma_adjust_trans_huge() only does a PMD split and not folio split.

> [--- snip ---]
>

