Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A34E5606A33D
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 09:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PKhHwF3j
Received: by kanga.kvack.org (Postfix)
	id BFDFC6B05B9; Thu, 12 Nov 2026 04:26:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD6386B05BA; Thu, 12 Nov 2026 04:26:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AECA36B05BB; Thu, 12 Nov 2026 04:26:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F9CD6B05B9
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:26:58 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E34081C3CFD
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:26:55 +0000 (UTC)
X-FDA: 85425937590.06.1190722
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 189261C0008
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:26:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PKhHwF3j;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794475614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6llN3WGsJ9HH0olCgh6YbKzYaA4IOfRnHqvyyuyt2z4=;
	b=v3LrRLjdq/8DG0GUkGeUPFMB9IIQIJ4RjFih5qfxeR33QF0c50sURp6Yn2vGDpcL2sLBXi
	G4wfFf+9RqA+b8uNudR5YWgr9mmM7OwLrfPX3CJhHGEAN3m6jMG9UXjLJHmmOzirS5JafJ
	RtAfZ1R3Y951BWL1S9UE3VrA7chDFA4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794475614;
	b=V8qt6bVz0lsRgFhHeOfsYqSx56rprvs59iYBVDaTEvWjJ0Pb+LrJlR71nSKy+oFN9KwuUD
	5ZgTLpggK9NfGTPFAuOs8N4saBcmFUjzwU9MvTEbVMTMnkL38Hi6m/3O5xN4ZkdcFvnD8Q
	fgmHdfiw0tD/1QkXn9fKo5ZP3KRyZtY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PKhHwF3j;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3D9C046929;
	Thu, 12 Nov 2026 09:26:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684BC1F00A0B;
	Thu, 12 Nov 2026 09:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794475613;
	bh=6llN3WGsJ9HH0olCgh6YbKzYaA4IOfRnHqvyyuyt2z4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PKhHwF3jHeR+K40Zwx1KzkLdBPuVfLLkSwb9frVG7uXK6WFgawSqR3KQldi7tr7iY
	 KGRKzEoZ4gk5fE1MYCq2lzljvS+G+b0KJXvygqEpJQmPx1/4BMj8ZAmZtgcMaI83iP
	 CvhYFFin/kHUZ1Dkh6NK6G+SHd1+ycJ+OGkFWtG25ABHxh7vwI5CCXvsy8eK7oumKH
	 yjW9qm7ytfFqu1YUCKn6EmUjibHUov6WIsDLm94DFRarZkSIJRK8EeBeqV3CbD/4Gh
	 GwXtz8FOole5V0AyUvJb9FyIJ3IUJyWZwIuIbwzcAeCcOcKQmiTLyUTIru6Nawwyqi
	 EM2tz8rbQ2YIQ==
Message-ID: <a1ee8e44-5a3b-4bef-aeff-eb19d354f767@kernel.org>
Date: Thu, 12 Nov 2026 10:26:46 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] mm/khugepaged: release contended mmap read lock
 after scanning enough VMAs
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261110-khugepaged-latency-fix-v3-0-6eea743cf9a3@kernel.org>
 <20261110-khugepaged-latency-fix-v3-3-6eea743cf9a3@kernel.org>
 <avNrPKIoZ3JHiAjh@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <avNrPKIoZ3JHiAjh@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ydsw8snjgimhtbgkejk3fb97hupwg65h
X-Rspamd-Queue-Id: 189261C0008
X-Rspam-User: 
X-HE-Tag: 1794475613-503514
X-HE-Meta: U2FsdGVkX19xYeeKE46b5SgGHpbPwVIIrYo0ainub9Z2Vt34RfcYLaceQcD9O+ssDpiwZ3naRr85KmZhaj7oN0dQ5ju+6NJywQ+gLpsXzQtrZF8o9g4Qbq+HjbPWVP1v8dMj4qdU252amKxW/i79tCA41BsmoTnXED3+Jv0xPROTgy5Xnvyy4GE4U8Y3JkZK5NKcVnJpcGJ0k6mfL8RcMN/IfHvNMo9uSzkayMzkTcy8qqEXnp6EFSBUWheIGKTrEwK4aVRwkPR3T2U/c4Gu45Zom4niseaya4qcYfGGXJRCxGw3cphJkTgywss+NghWHCGrU++K2FUZJDvrK6zjaC/U1f3YxHuv4AKal+mqt6fV7JBm+tzifjru2PLDuExxdrDg7NMWeRxfxFQPjCX1Aem1MLqSueM6Iumgi5hUcnnjjqsLcR7bEparmVpixpSm0flqMlbA7ww6Dh8Fn2ZvN3l2SMVxyuUpqyFa0Dss52/Jx5GW7YMrWAgeh6Dq7eexaFVGsez+0s1Hr1MRsCfKRsG0JvdfEK2Ll89Aydk40Gp/+QrUQdpqWLxgIDuusLbUPI88z8j4mMd+7hLFx6Y9/ynXxg62Uu4KW575zK2N9+B7OWFWUE4Wc2IZQ9G6FKIC2TZK2WWN1oAP3XyVjIvl+sn40sPMHTkAgB2i3lVKYNxyp/qXwZJAmZCIq6ilJJhBpjy8/33yDI3jCo2/sk6LszwLadxK/o11jYjwtXptlXIsC6Fl2Pz1f+whjK1469z3qfo+E1YHfhbWVBw++mCjgR8ZFIDrnVn/HHH//eWjvNuv7l4PDgEnYugAslxZ47PTDJWTkYzhyixQKsR9O+bHrM2fX/pkUN2KUMxvszuKUP+KTs3BZhBm8X8ugfVpkylkWhj0RbydSoaSVMkJAZkto8iDsYzMgmFR7Y46ye9BR2B2zgLZy6NU1k8G9G7Qf/VuzLRSNvLWU7Exb474gS0
 M0Bd8YGv
 1y0/xLBy6HLTqKztJaSeAzEdC610N85VTevNX60ioHCEQoP3Xp65hMf6TRwyIA5SfH7Rvu0SmJ4N/uSwis8EYibeVY5VpZzsifrG/Gw55ywW72qXdp7vY0dMGkfe1wXXEAu2dUe9UyQKYtW1Znaoz7386GEfX+SXGrZVh+mhMj2h3MoWp6YdKBGKQ3llKHx8b6qGcqMmo2d5+LCwxqw8f82GRRNAEflQeinsMskr6MJp+bkYMPtCVKtQY8VzkvuTKO7qt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/10/26 20:09, Lorenzo Stoakes (ARM) wrote:
> On Tue, Nov 10, 2026 at 05:19:13PM +0000, Lorenzo Stoakes (ARM) wrote:
>> khugepaged walks an mm's VMAs under the mmap read lock in
>> collapse_scan_mm_slot(), checking for ineligible VMAs first, and skipping
>> them if encountered.
>>
>> It charges cc->progress 1 page against the /sys/.../pages_to_scan budget
>> when these are encountered, however only checking this budget once an
>> eligible PMD-spanning VMA is encountered.
>>
>> It can therefore hold the mmap read lock for a long time if there are a
>> large number of ineligible VMAs present in an mm, over which time no mmap
>> write locks (and thus no VMA write locks) can be acquired.
>>
>> Address this by checking whether the mmap lock is contended after 1-10
>> ms (depending on CONFIG_HZ), i.e. the granularity of jiffies. This is a
>> long time for a lock to be held, so is a reasonable compromise for
>> determining when best to do this.
> 
> Oops I left this in from the previous approach :)
> 
> Replace with:
> 
> 	Address this by checking whether the mmap lock is contended after 1024
> 	VMAs scanned. This was measured to take around ~100 us on a fast
> 	machine, and given VMA eligibility checking is a light operation, it is
> 	likely this will remain at the same order of magnitude for slower
> 	machines.
> 
> 	This therefore establishes a reasonable upper bound on how long a
> 	contended mmap lock is held.
> 
> Thanks! :)

Fixing it up as I am applying :)

-- 
Cheers,

David

