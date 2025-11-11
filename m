Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65C4ACCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 13:06:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF94B8E0005; Tue, 11 Nov 2025 08:06:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA9B88E0002; Tue, 11 Nov 2025 08:06:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABF668E0005; Tue, 11 Nov 2025 08:06:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9C1EA8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:06:35 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3FE3E13B347
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:06:35 +0000 (UTC)
X-FDA: 84098350350.20.31E2A44
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9E551180009
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:06:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Tg0OtVLz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762866393; a=rsa-sha256;
	cv=none;
	b=3YFSV7iMSX6ZaTO21bBEunz3+153V7q6mEIhok350jsh5+gKpVRjriGwxqjaT5KXA8+4PM
	wdvBzvABM4vAR0KWSy8eW5TIkUHZM/mU7JT8fGs2B8v7VhsqD5lXoVzUr3DQeLtlzPIdlv
	0biF+Zo3jW8j31u3bBH5BS7dOHduopE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Tg0OtVLz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762866393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QUuxZIIuJ+7a2uOXKUVW8bGDd4sgEnQiZHeUL+8j6cI=;
	b=euZpEjPkjF667QKfEI+CpCUXXfXEQHORZ93Qf5swNJ0zcV9wwZNLr6CpFUHySNz/2J3pQz
	rrY0WkSsNUhrG2Wlgxby7cT6tMthl2sN8LmtCche6dOfVrtG3VdvpATZ3c9Z+oMmUhxHrX
	yHMoZFacHIYz8UPFnuY7Lx8hMRiJf5g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B15426190F;
	Tue, 11 Nov 2025 13:06:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E9AC16AAE;
	Tue, 11 Nov 2025 13:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762866392;
	bh=ahDE0Hde9+gZsnP0JCOLdJBo8hGroTd4JJCH/jgFj/0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Tg0OtVLz3wAXRZo7tCvWTInHjKpVK4LV67NTO+lYAZ/bR93jyG2IyFgcvsue4SRjB
	 0h8QMWesGpk3qXoW3f/y5g5hNGaIhpu5ZvQWDGwHfLvH2QohrLgDnSv/T7XK5D98wL
	 z5paZ8OThivObxShM274wdwZcvtkA9PuAU6b+qI29fKv1akghKWsQ9OqLPjtgfb1tU
	 4dhW8r72DwTtl22M6htocWaDV7hTEh5uNlGrHZ2wikbz5TAqNJgsCaWZxjg5IGzZHl
	 e2ra3fX+DjamK0ohLsg2Y80OH6UCT/oI2TuutGRfJ5NWGrLux815QwhhypwuSp+iZj
	 JUT65tT6i+w6g==
Message-ID: <6c7c5f86-a9d5-4b7e-aa08-968077f66ace@kernel.org>
Date: Tue, 11 Nov 2025 14:06:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/16] mm: introduce leaf entry type and use to
 simplify leaf entry logic
To: Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Arnd Bergmann <arnd@arndb.de>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
 SeongJae Park <sj@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Jann Horn <jannh@google.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Pedro Falcato <pfalcato@suse.de>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry.yoo@oracle.com>, Hugh Dickins <hughd@google.com>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-arch@vger.kernel.org, damon@lists.linux.dev
References: <cover.1762812360.git.lorenzo.stoakes@oracle.com>
 <c879383aac77d96a03e4d38f7daba893cd35fc76.1762812360.git.lorenzo.stoakes@oracle.com>
 <CBBF1711-5881-4B5A-ADE6-1D86C0E94296@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <CBBF1711-5881-4B5A-ADE6-1D86C0E94296@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9E551180009
X-Stat-Signature: dwcrnxjt4t1f1u54bd54jyb4qczjx649
X-HE-Tag: 1762866393-36146
X-HE-Meta: U2FsdGVkX19uaWiSqMG6s7qFXUKIB1x+YbAyFIWd4lWOXjPYdBYbNUxUy8k2n/Fdz/eMd4jx4u+X2iNq5XbLDumZs8pisHmivX/FEjvRX0e/3EXZ3SM+lXwBeANiqdSg7SmHZW2I/v6WSMFf1TlMdYZdh4AsG6YR3g6DoweuDXotcy9gq2DptuZ4XNlR+DVGUuNR39NU32r4QlRwe7oK3wDd2BajvnPuGYWK9k4UI2+p+O9kU1qabKfsQYyxTzPIonnIUbH0t1ufcUGJ7G/rCVjtMXlMNBontZuwNiAE8IaSmQw8s0GpE+/tQY4FkE7pKUr0ybUeR6BUUieAelqpFKqKMA5rOeMxKxrhmIixLET+iMuFGME5u5iuHlQs3N5k7djCnxhT1A47yzSOBVc5CMk/Bbh97yGMnaDu4OQ7ahpplwhcV2qowwLkNfhDmyr16TfG8MPtpD6+lN+NYbPPP2vZ073TJtKZ1Z03Tg9R8sxdaupuC46BgAhyIBM3Nk79umPs1v7yWrvX0UX1Pf8VbZRAWNHdETZ6ASDvt18mTftaUQrc57+CWalhL0qBAFdljDMbq3f5medCQknoJD545oCpRCgonNN1ysmZDgCY1rNf/7xs72fdUtVjge4kdpNchR+q5IJQIObHX9ARFQ327w9uYSvtCbDK0s39aztdyy+g6tCDBEmtuIDhi4M8iGe68xuVHRSX98dMMPy4yFd2/YU7L1Yuv7Ddq0y4l2fz3vroKocPdnaWZoWp6x9/qhw47PeQ2b+C2HfgABZhCNE3X2BHDg/8VvEnW/28GF17O1cOtMnpclcYaX+vW+KjALtPNtnk2AtXxnJN5zx6nqYLxs16GFPHHV8zLn7/yv8VPA0UCG1mhKJQW2TS/5Pnr9TiO2Yg5h/LZAobZPMEbeubzNIY5Jxc13M8k8mTUNCmpbsvqVoWTxjCFDaiR6mUyW5szVvMrgEZ/Tk/eTU42HM
 unLdM6ba
 Vwh7iXTkiPtLzByeoSQ8BKaSYB8asUCUeySpDANimTyhC91fYc0OGfAFYKIu6SFAeh2A/BPabDYMH40aEcayJhqBtMP6A75it1KsekosXy2z7+duSelqn7AXmiD/KXeNH4zvqTLv8orhnsLMspHvdPF1XvyJ0MjucXyvQceAj9h9kTEh477ni/1XuSAAFSZ+vwfJKaox0ZztIZwfVcJkhQJogWLw+W/0DtgJtit3lkcBmOPTcqh0Rj3CuOsSMCJmlRgb8damzM6md00uR8wHuQQy+5WWU6sR++R0VQYTuFhk/nLJzsS3slsPQuNrXkkDcLc9RO6AXoCtfPgg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11.11.25 04:25, Zi Yan wrote:
> On 10 Nov 2025, at 17:21, Lorenzo Stoakes wrote:
> 
>> The kernel maintains leaf page table entries which contain either:
>>
>> - Nothing ('none' entries)
>> - Present entries (that is stuff the hardware can navigate without fault)
> 
> This is not true for:
> 
> 1. pXX_protnone(), where _PAGE_PROTNONE flag also means pXX_present() is
> true, but hardware would still trigger a fault.
> 2. pmd_present() where _PAGE_PSE also means a present PMD (see the comment
> in pmd_present()).

I'll note that pte_present/pmd_present etc is always about "soft-present".

For example, if the hardware does not have a hw-managed access bit, 
doing a pte_mkyoung() would also clear the hw-valid/hw-present bit 
because we have to catch any next access done by hardware.

[fun fact: some hardware has an invalid bit instead of a valid/present 
bit :) IIRC s390x falls into that category]

Similar things happen on ordinary PROT_NONE of course (independent of 
pte_protnone).

A better description might be "there is a page/pfn mapped here, but it 
might not be accessible by the CPU right now".

We have device-exclusive/device-private nonswap (before this series) 
entries that fall into the same category, unfortunately ("there is 
something mapped there that is not accessible by the CPU")

-- 
Cheers

David

