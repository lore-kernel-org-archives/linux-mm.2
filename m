Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87188606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 09:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iYQFQ2yU
Received: by kanga.kvack.org (Postfix)
	id A66B16B05B5; Wed, 18 Nov 2026 04:48:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A44E46B05B6; Wed, 18 Nov 2026 04:48:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 955866B05B8; Wed, 18 Nov 2026 04:48:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 745A86B05B5
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:48:02 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 105EB1C3DD7
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:48:02 +0000 (UTC)
X-FDA: 85447763604.20.35BC66F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 41C4640009
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:48:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iYQFQ2yU;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794995280;
	b=W60j/H/kPgRpcjjcu9ablHObvhrGrYhCbQ0c+IWTs+FW9EWX1UwYAq3VLCWXRoqvfFbyWl
	UG6p8GOdgrRM/sZXdMC2ns7eUq7vH1bJph+xVK7yzUINNxDAEx09OULky5hZpiEvMr9ufx
	Jr95CNDqBB0BCvwUnEJ6FlYOVQuSjH4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iYQFQ2yU;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794995280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s0Wz2n57vdZUokFSxrkbmaCxtfmXfbqv1U3m9lAxLV8=;
	b=gFSWLM6wdCFBOaCdsjBhQmh+5f3DH2cmUyvJPXyJaiMDol7cfZeHj/tEbVdpDN+evJ823K
	g9Ry9kGnXra98R1/tqoc+jGXGnttAdaXT68ETnb6j+RUgdSc6yc8e0pPTGuaO+8oJbQtyC
	PK+zmMg5/MO0aEtZO51E+1Phc56xh2E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8631840918;
	Wed, 18 Nov 2026 09:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05261F000C5;
	Wed, 18 Nov 2026 09:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794995279;
	bh=s0Wz2n57vdZUokFSxrkbmaCxtfmXfbqv1U3m9lAxLV8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iYQFQ2yUPPHHAygrFTQLmV9BIcvsWBPutdR6UKne64hmmls4FrhwNuCdhGchWH9BE
	 fxBJKKIoXw2SDtqD8bf6CoC6AgqfRYmwbnrY0nFpgQKfvVaBTumkOVSpheFYai/zYY
	 pL5vyXvxNFCknv5Y9otK+p1L7dCAohmoxFyOvyo635m7v1o3eChpz+YRXPn3qDTW3J
	 EXPWqO22znVOX5FG46X0l/ylJJuX5lIY/VqEh+SdT6p+0J4cgmeFf3ElCKCrWfUoCF
	 JC3+FQbyupECjWTpRpgD+Kjd4a83vLvp2JURAhPMO0Ssx4Jw1Gi4sB8io+lR2fd4ei
	 hV67Rbwa7irOA==
Message-ID: <d7edeec8-d9c8-4516-8426-de2d8854ae06@kernel.org>
Date: Wed, 18 Nov 2026 10:47:48 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] mm: fix races between huge and non-huge faults in
 PFN mappings
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Alex Williamson <alex@shazbot.org>,
 Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>,
 Roman Kisel <romank@linux.microsoft.com>,
 Saurabh Sengar <ssengar@linux.microsoft.com>,
 Naman Jain <namjain@linux.microsoft.com>,
 Michael Kelley <mhklinux@outlook.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Eliav Farber <farbere@amazon.com>,
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
 "Gregory Price (Meta)" <gourry@gourry.net>
References: <20261117-huge-pfnmap-fault-races-v2-0-276007e73bcb@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261117-huge-pfnmap-fault-races-v2-0-276007e73bcb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 41C4640009
X-Stat-Signature: fqmn9ahw9wchyeu6xy57wrm1bfqsifqs
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794995280-894398
X-HE-Meta: U2FsdGVkX18f6bSCJXpL30WTr+a5e9ZSngrua1O3IvzwcKqF0/56Hcn0EihrjBFY6/evvVvxbp31NzxVpGvfbKJQGmNXsvUUWKiR1oUH/P00hsLvzjPlaer+zLqRteQrBA8fJzRpEcAw4PiBSPbGZcHjArY1e6Pxxj4VcRmDfARS4ndNT0LJm9dd6Mpgj8W4hSDR43AAbksci/EzVOJ2fvd3XW+mrJKYWD8q85SPp9HcpNyP4JcZ5LOhOaIAPGO/kxpT2R5W3/NqWqYsfvsKm7o6YB7JtluDnhtNIpGcCG+q08V7b3GqeTb/3lK2/JvIjaC+l4UB2JMFnVyAOleWR0nh5tTLY793o9m9zNjhF37zDMKY+Di6H4XZySdoz5qaYQQ00e89ZN2m0nfv2pPG2Qs6P/PwzmVMccZJ5ugV4+8jhvhLy1mj7PXt84flQL5HHNRtfNVncMNLA56OG7OOe4NsEmNCYYN3lIaSeXSUssYsyoL1b3JArsxLP1HIgFJjlNRgUoPiMAtaSKE8MNRrBRTz+vbQIfymeyw8K6Nz9G7D53QkdVjCMM/K7uyvLwOs+q6E2P7now4esH6MyZXH/Ft1JTCJo0KXiqOkAZIGJhbAm92PMwiuyL2DcoiPMeo6Sw3bCgn0okR1lV0M+LPThRcYKKue238T+E2c2FtCpEFiELrdSvph6JOWgyTBtWOM3eVQE9xNNRp3VA8Vpb3Js6Z8lmqSsPciLj9I9YKdDHMolV5eA6CACOp6wLTHt3QttKKGViryMU8c1nFmCrT3o5fjNB9zQh70/J7DqIGg6uPb518Y5jJ469x11aAOJBJn8RE/eDPK8C161jyeWPsIXCjzHUv846LTGmRmcaQDyQpHjePsCotmN0VYuJNVZjDZHxxWjaX6q+7Leyx/azofYQ+m/LTLgY6tNf9aQJiZ604iSxofvYey8/qxKNNqls7FYFZhE4MqLVoQJyYYi++
 9tJF2wkJ
 maxNehtYVqBxTb7Gt5hOPBnVKTJw9kaRfQcC946lZIGxdXmrlHk9N5rZ0d4ePnl7eXsANZGUoqLSzeLYIATvSYOUlxd6QmLq/W21Au6Zq+jixE1xNALL6wWAS8BSwulz0+GHbWV/oxw0KOGItP0vLmAHmjvMDnYgkhCkA+ajHuo3dJ9zlUJ9W5Iej4WWvAlvYmPIAHrVV+JNZdMPR7rCvOm9Xt43Zn/tVRmZVZSz/TzjID1yjKEEDwQjJmh++SEf3WwvfqgNMHiBbmHpwPGe+NNzHRifVWRddj/NTGbeF17nPLqjvtUV0NRFW+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/17/26 19:31, Lorenzo Stoakes (ARM) wrote:
> A driver that implements both ->fault and ->huge_fault must anticipate
> concurrent use of both.
> 
> This can happen, for example, if a user calls prctl(PR_SET_THP_DISABLE)
> concurrent with faulting, as that only holds the mmap write lock and thus
> does not exclude faulting threads stabilised by VMA lock.
> 
> A number of places in the code that implements huge PFN support fail to
> take this into account correctly, which this series aims to address.
> 
> Generally the shape of the issue is that faulting the same empty page table
> entry can result in the ->fault and ->huge_fault handlers racing and the
> loser finding something they didn't expect.
> 
> The fault code must tolerate this, but fails to in 3 places:
> 
> 1. walk_to_pmd() asserts, without the PMD lock, that the PMD entry is not
>    huge, so a VM_BUG_ON() triggers. [ vfio-pci, nvgrace-gpu ]
> 
> 2. insert_pfn() treats a failure to map the PTE table as an allocation
>    failure and reports OOM, causing kernel accesses to the range to
>    spuriously fail with -EFAULT. [ vfio-pci, nvgrace-gpu ]
> 
> 3. insert_pmd() and insert_pud() assume a populated entry is huge and
>    compare its PFN on write fault, warning when that of a page table does
>    not match. [ mshv_vtl, drm_gem_shmem, panthor ]
> 
> This was originally reported and fixed by Eliav Farber in [0], this series
> reworks patches 1-3 of that one.
> 
> Patch 4 of that series (x86 PAT encoding of huge PFN mappings) is dropped -
> it is unrelated to the above, no in-tree driver is affected by it, and it
> needs a different approach which is better pursued separately with the x86
> maintainers.
> 
> All three issues were reproduced on x86-64 under QEMU using vfio-pci in
> no-IOMMU mode on an ivshmem BAR, with 6 threads faulting the same address
> in each PMD or PUD aligned range of the mapping while another toggles
> PR_SET_THP_DISABLE (note that vfio-pci had to be modified to pass the write
> flag to reproduce the third issue).
> 
> Without this series the BUG is hit immediately, with only patches 1 and 2
> applied tens of thousands of -EFAULTs are observed within seconds, and with
> patches 1-3 (and the vfio-pci modification) both warnings fire immediately.
> 
> With the series applied 30 second runs at each of PMD and PUD size complete
> with none of the above, with or without the vfio-pci modification.
> 
> [0]: https://lore.kernel.org/all/20261112051440.16140-1-farbere@amazon.com/
> 

Lorenzo,

all of these are not super urgent and can wait for the next merge window, right?

-- 
Cheers,

David

