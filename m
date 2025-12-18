Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC3E6D6ACDC
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 10:02:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18F4D6B0088; Thu, 18 Dec 2025 05:02:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14FDD6B0089; Thu, 18 Dec 2025 05:02:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05C936B008A; Thu, 18 Dec 2025 05:02:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E917E6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 05:02:12 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9296E160E0B
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:02:12 +0000 (UTC)
X-FDA: 84232151304.01.883E7AA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id E735840002
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:02:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qUxR5p9n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766052130; a=rsa-sha256;
	cv=none;
	b=IfIQeuaQc6PcVJP8htuogXZ16TaxR5EqiRo12+UFKjTFh/ydv1XZm8HuXtQ0xkr9wYeUXk
	kD8u0QK4uWnXj5C6kfCx60puHgiZe7+gOT4llUEKtTk3ZzZucCXcEG+ZNS9iPZ2/kVvK8J
	eolv5iwACWPFExYxazC1Ul3OjU7gFH0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qUxR5p9n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766052130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jXayoTaQ77V2XANAImmfYENdHOut0SX0pqYydj8KJmQ=;
	b=Q0qYDEIkdEEiHs5NibfdSgq5K9xdOcHKRlE7eaakd395BNYuVthreYikwbdeO97RkNeoc0
	epllTU4uFmKO0gQ4ESbSoxAh90x529rC3qZSapZw8gk+QUaS+eVqE9QGydDKOUef0FVP50
	42d3QPtInKSBOPYPM3IYZRZkf9t+Hqs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6565060008;
	Thu, 18 Dec 2025 10:02:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05ADCC4CEFB;
	Thu, 18 Dec 2025 10:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766052130;
	bh=Nw8/xPqRtJ3jr9PSKxoQ1BcdKB0FWuTnbRQXps9AJuA=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=qUxR5p9nLaGIa2IPol7GwO939YNt4cI6BRodAmVjF0+8L62Ffd2H5W0CeL07eFj3X
	 5farBmoQooRnqvZDzrtSUiOU43l64FLfBe4wILCSDYkNOXbYuEgUsUT8X6CXQYq2cQ
	 Maxo/huPBXAcATB8n7EoL9p7yl22QHDPL1PZ4p/EnQPnyzHfHNGXaFyCdixFqMSukR
	 dBoQm42UODTkVcUfdc8SdQw/3dmKFNwPiEa9rLlZ/tgVTTPCYWK3JR+UMJpxPMp2mz
	 y0Ox1jt27Qr7NiXyK6nzHn5U7juAH31r1UuHLge7X4DKioWpwQCiZx0bJFhjs7FUNw
	 XxqgeEWeLeGTg==
Message-ID: <ee42b057-b2d1-4a61-a6b0-39f81f78a918@kernel.org>
Date: Thu, 18 Dec 2025 11:01:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] mm/pgtable: use ptdesc for pmd_huge_pte
To: Alex Shi <seakeel@gmail.com>, alexs@kernel.org,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, "David S . Miller"
 <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Thomas Huth <thuth@redhat.com>,
 Will Deacon <will@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Magnus Lindholm <linmag7@gmail.com>, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, linux-mm@kvack.org
References: <20251214065546.156209-1-alexs@kernel.org>
 <52e2c1eb-67cf-41ee-9088-760fb6258153@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <52e2c1eb-67cf-41ee-9088-760fb6258153@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E735840002
X-Stat-Signature: 1b1685s4m7rwzkwzybqbpw89ozr3azne
X-Rspam-User: 
X-HE-Tag: 1766052130-256055
X-HE-Meta: U2FsdGVkX1+KTXQsgfcYWs+/oTgWspgAMdrQLCBbXlNuAT3Pvjyu93CcsP3Y0cjkyVpgwUPy1gMXNz7eWg3zSV88hrK3n54dQI3rZCTK9B66QlS3BalpPcg8Aw1O+NrvZiHV+fkGxNtQ30cZ9PIMtrXqR6H8TQ0v1wU3RmUj6Y86sgpvLm8C5sCYpjxnBBG/XiHvQXAeTg70Wffl5sQgwtvRb5IuRNo+SIWLweyo1/Ya+eKajq5A1sLYNDHTF0/4C1CH/d7VLnvBQgU/NIV0zhohs6CpkZztGgo75VgSCF0I8QAwsIGGUasg7mlyLyo7qGZ0RoaTcrLVNuaXDYfY94PoITRLa70tfhNOPQ7mjLw9X4uZL8WHtLJv0DL46WWwjud4EggijXcaB/TKcRjzbEWICv/NVqQxAEbYxQkhUPyPQCXpfEjt7K1B2pLlHQotxCh9pt5Rq0rnfkfDnf89esgrE945KQxsnGpvm3zMZN3V+oV8cCmNM0TiqZ3pIT4hfn+IoW+VP6ylNvHAza6ASeMEoDfqV9R25qbpcwMX08WWhE64rjyNIOw1sLRs2866gO1uOBmNdsEiF3FmQeZToHfHvtrpZx1cq+8vOa3IvfL8BhhK3vb2L9cJfiTAS1vAfVqKBYlU8yIHrGUQm98LI8RYr9BuqQ2+ex73B4QBFKpb93vtahanjQzCWfEqRuEfoxPxQuCN22GnhcXc86FPVvScTpzYkdNUyUQkt+Ff/SXVxQeJgxFuHmiJWVVIwQLeDQJqcpY/yELgV65uCw8EXE4JCmBguHgZwOcugJU84kxG8KdDaif5prVLyiHyvijlruTnaXUss6oLgSMc37iKYNMhKfSPEfYyXrgxIrjUD//POy7UUBH+f+TPqVYU9pTENGK2JQo58ZpHSu1EMNYfGalUCTAvQuwJFMHIDgpUd8HMtFZ4WYH1ys5L9+ZClUV1iGBsOWAGzQaoeNyQN6+
 rEXCM+Fs
 qIuKeu8HP0K7a3MqIvfOxwcrsjGDu52tCWII2F3evV7hKEpcdQdWF/Vm42JwMaGDF69ERMDc7uEVUTCHYqrc1vFpEqY7z4sszFTzJgKM+wVbvUs2NMMGWKbsE/gPU0562cd/q+9f0CGnXYxGUHNLeQcmn+7O/HjnWizjbbyCD42Av3B6x6CrhMG7ekYQHJcW6rhokN4011/3fHVnE51fdqFSzVQG/INsKwW9gkP4oUjPa0RbKAMclDhdtxtgPVbkSlioQqAA2hZY2kQqmbSI1W2DzpY/K/q8EoGf3anXTcqfe0czgnwQYOYVZ/6PV+bepcssiut2szUjdjK3BYjhjF5EeWXstS8mvWcUGgQ36U1u8VBkPxDl4QymMU9zp7tpbA80cr8JIj2YBzzfKTnadldZz3g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/15/25 01:53, Alex Shi wrote:
> 
> 
> On 2025/12/14 14:55, alexs@kernel.org wrote:
>> From: Alex Shi<alexs@kernel.org>
>>
>> 'pmd_huge_pte' are pgtable variables, but used 'pgtable->lru'
>> instead of pgtable->pt_list in pgtable_trans_huge_deposit/withdraw
>> functions, That's a bit weird.
>>
>> So let's convert the pgtable_t to precise 'struct ptdesc *' for
>> ptdesc->pmd_huge_pte, and mm->pmd_huge_pte, then convert function
>> pgtable_trans_huge_deposit() to use correct ptdesc.
>>
>> This convertion works for most of arch, but failed on s390/sparc/powerpc
>> since they use 'pte_t *' as pgtable_t. Is there any suggestion for these
>> archs? If we could have a solution, we may remove the pgtable_t for other
>> archs.
> 
> If s390/sparc/powerpc can't align pgtable_t with others, we have to keep
> the pgtable_t to bridge different types. But we could take step to
> change pgtable_t as 'struct ptdesc *' in other archs. That could
> simplify and clarify related code too, isn't it?

Not sure. s390 and friends squeeze multiple actual page tables into a 
single page and that single page has a single ptdesc.

I was rather hoping that we can make the code more consistent by making 
everybody just point at the start of the page table? (that is, make it 
consistent for all, not use ptdesc for some and pte_t * for others)

-- 
Cheers

David

