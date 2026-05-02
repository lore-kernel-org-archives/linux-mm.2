Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3624FCD13DA
	for <linux-mm@archiver.kernel.org>; Sat,  2 May 2026 06:37:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E505F6B0005; Sat,  2 May 2026 02:37:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E01D76B008A; Sat,  2 May 2026 02:37:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF3376B008C; Sat,  2 May 2026 02:37:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BDD046B0005
	for <linux-mm@kvack.org>; Sat,  2 May 2026 02:37:57 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 016B04049A
	for <linux-mm@kvack.org>; Sat,  2 May 2026 06:37:56 +0000 (UTC)
X-FDA: 84721524594.25.736F64A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3CBCA1C0006
	for <linux-mm@kvack.org>; Sat,  2 May 2026 06:37:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ARtsPHvx;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777703875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PFHery65CB+x6FylRSPj6pjQm72YiWw33v9NYivN4DE=;
	b=ErFDcOIwMDz6fppL/c/ftyKHMWnmYFkqVrU2EvXrM3fBIl3oc5J9vLPOryIEmRhEPAbVbh
	9hJXg05VxBv/dwWG0y6HbHO68LlH1Jlea3RIhNT/El02k7jON5g2Zw6/4vmbK/Nkq4+bGL
	yPC7wYFItLqdYsLeUtCUl4JXY0zGcPk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ARtsPHvx;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777703875; a=rsa-sha256;
	cv=none;
	b=u8rNpPiWNSjGmXCs9n72lE9yIkYbuL4yWjQTGTwMjusEGECQkwpvw5bHdetTjfV4qxMsxN
	wANyYv9dohqJVOIHrUPge6xqt83Y6sWPqo+Sk6mxBahixmLj2KLwqFNmJBcPCOSc/eDYoh
	3IVMMQos64ObdEMU07gxUL3NWcvypuE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 878E760120;
	Sat,  2 May 2026 06:37:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D170CC19425;
	Sat,  2 May 2026 06:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777703874;
	bh=e+yK/NeSnHhg+IiXQpYD59qs3oaMWPrmXoofKICJOjc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ARtsPHvxb/WxPqwljPsHBbehUVrispm1PlvzAm29cTg58YO+Wc9FM1HvyM8oXCFC6
	 25YOkUOfftKD894jtf6ezRSIbwmwBm5dcuKDfpXpjQxnZKNT0gRNu7Ua6Q8iQDwwpo
	 nkj09WZuhY+yodzkWMV1klCVSvvyr8cAC6UHIhQkH7XTXXrJOY/VhrEA6+NgfUxWxM
	 zn47C+1dusRahNtR0cmHBoC+bvUgZV3LWBgMGqeiEodXJjdR5W0lbOsH6NL5+rYxz5
	 mpRDOoJnVUE5l7H2cNSg3BiR/jKpGifL3pXBWkPY0XhoiTZLbvxpthhRyJQ7vRyGq9
	 C7eqM4/+vyqpQ==
Message-ID: <6f024319-5685-4ce3-b642-fd7d487c3fff@kernel.org>
Date: Sat, 2 May 2026 08:37:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] userfaultfd: merge fs/userfaultfd.c into
 mm/userfaultfd.c
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Peter Xu <peterx@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260430113512.115938-1-rppt@kernel.org>
 <d5f17a01-4504-4a7b-b58d-c183cedc37f1@kernel.org>
 <b31e1b5e-511b-4213-a8f8-d9721959d709@kernel.org>
 <afNtnXnU4J6syETa@kernel.org>
 <c2ecd0c6-fbb8-41f4-a7fb-2b1f15d1fa12@kernel.org>
 <afV_3ZZ69cpeYmpS@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <afV_3ZZ69cpeYmpS@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bntk9ugnb7depoeirwryac8aydyjkihm
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3CBCA1C0006
X-Rspam-User: 
X-HE-Tag: 1777703875-876510
X-HE-Meta: U2FsdGVkX1+p3RhRABt6WulrCwaKxwFjK+7rCMdrwhrEn0Qp8CK0zx3zfjWA4x0qag/hVgYx99iRkdaPbTDFfTmn/n0h2CS3mUUGipqPcoBvpVmkhKUzXaUAdcyVYDHJBru0UX4GE/8D9a4F13AlbRWve5hq2DGfDZvh7ObEuSjcQsBSX97wKedVsZ4FI6nQ8aR49QYQ9Php+5ie8Ccrvp7MntcwLbiqw+/ro+jfL+cGqwUig9ngJbRTmhJksL/O73bSlM5rfsK93iHrq1LzgZUSy/0bkjf3Jt/okJS4Nh7+gGim0qd8UkCV82qtv02BzpY37uHnymtTxMPvCh/5awtvym1snkOLo6iFlLc6hoRc6u/tgWlJ0Z+ojrNdCrjrDzq2FHshl1OuIZPGZc6na1GvsIyPTCn95LqnlKSANjTVdFC3sLmTKWzik8bIL6fbaG+j8kz+1Fhy2KxBPFvWec4CBJ+euPoKVW64Pu7NYPOktQCfGUmQ7+nkNuMFks9cCAjghBGiyLTL2LosM+8GulmwSYYqUcnYKNaC5aHULcwd7JkQqt1mylagQPgxpkBBjKTC7pF9uRvPqf+1t057bbe0K+tqd1dmCmZFhCfWP9OG5MsRDKnz+PMeqSmkrex0YT7R7rL0DQO8ET5SpRLeUl5S5vOugDndPELSz301D/8XhdOU126dgNd4w+LSZKmLJP8mJQq3ov4Y6QKqEaZgWXK7ll8WMyJ963Y3V53a725v7uOq63LBTqUfr2zZmx/KBl6PzcZKnMEKFw1VL2XRXIFnsxUZZyP9h4BYsOTEqNGchl/oVVv7nNz3gwgBSVDGBaDWrWwXhPZ7j+KvI+WaJf8FR7hFmDTPr1fYp+KRFqS0gNaukIhGpTnQkYiGVAswRjbGFK5MnWy4iF5GpSlqMhCRpVILBQsls84mhg6e5zd3xCO4pfI2UijGLKKQrLjXI537SHK70Qt72Iow8AU
 OMJmlQKN
 xLOS2Ui8NsIAiR8/mB+zVgeYZ7Z9ovLJLdotiORJ01AptePvnJgvmiaIXiTZoLj9EvjdiMkPkfrnFWzv/q2VfPGSI2CNoax790+atmr4Ryw7zubWjHEfTXTt/SVfNVuMdcsaIW+VA6s4JDKsbrDd+fbjNrYDbajlaSH/ddRgUT43ofEugjooQPRcAaDnJxtAtP6ZeYCXmLH88lwLtNZBg+IRdRA7k2kCZLpw4T7Pkczp93a0fkE4kk1ao/hXjTqShchlu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/2/26 06:38, Mike Rapoport wrote:
> On Fri, May 01, 2026 at 08:33:04PM +0200, David Hildenbrand (Arm) wrote:
>> On 4/30/26 16:56, Mike Rapoport wrote:
>>>
>>> But it's in mm already.
>>
>> $ grep HUGETLB fs/Kconfig
>> config ARCH_SUPPORTS_HUGETLBFS
>> menuconfig HUGETLBFS
>>         depends on ARCH_SUPPORTS_HUGETLBFS
>> if HUGETLBFS
>> config HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON
>>         depends on HUGETLB_PAGE_OPTIMIZE_VMEMMAP
>> endif # HUGETLBFS
>> config HUGETLB_PAGE
>>         def_bool HUGETLBFS
>> config HUGETLB_PAGE_OPTIMIZE_VMEMMAP
>>         def_bool HUGETLB_PAGE
>>         depends on ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
>>         select SPARSEMEM_VMEMMAP_PREINIT if ARCH_WANT_HUGETLB_VMEMMAP_PREINIT
>> config HUGETLB_PMD_PAGE_TABLE_SHARING
>>         def_bool HUGETLB_PAGE
>>
> 
> $ grep -c USERFAULT fs/Kconfig
> 0
> 
> HugeTLB is another story.

Oh my, what did my brain mess up there.

Sorry, please move along, nothing to see here :)

-- 
Cheers,

David

