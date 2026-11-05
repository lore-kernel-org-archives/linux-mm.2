Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DB58606A32E
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 17:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BrB1bRD/
Received: by kanga.kvack.org (Postfix)
	id BB7756B05B2; Thu,  5 Nov 2026 12:52:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B67966B05B3; Thu,  5 Nov 2026 12:52:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A56FE6B05B4; Thu,  5 Nov 2026 12:52:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7DE236B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:52:09 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5238F40A85
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:52:08 +0000 (UTC)
X-FDA: 85401809136.30.65DAF5A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 99E4F40004
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:52:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BrB1bRD/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793901126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TU2co5OHwPqZGsjHAK77lVb6RAQX9yPBM909tv534g8=;
	b=59t1oXM1eXN2OjmRiyUYliQR40M0/JqD1Jia0tmIiXYAdMl4a/MnECQDK4iDeCJ0HsWilY
	EsdLtV76vZhkiw0lSFXamahcKLq7EgvL2WXoKV4cNMrtni9Im0p80V3ZY/wCBaHNgUuMtC
	J91ZFzBYEbf5plEPCN4vkSgUQdbgbr8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793901126;
	b=Hkbrbr3WUHwelRVoQQXn5QBnzL3nmXOvtGjkXTdWXruicFWsyMB9YWyf2pDNsdURNF+GPh
	1m3myIYqPQ79Ku6njhpjRwGGSwOTjWr9P4BO1Nf5i2mDIoPEyzys7mkYyzVWGX1myKMATy
	IjEGtUehrCmVCPV2QVL6vOj8IQI6leM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BrB1bRD/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 28908600B4;
	Thu,  5 Nov 2026 17:52:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10D681F000C1;
	Thu,  5 Nov 2026 17:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793901125;
	bh=TU2co5OHwPqZGsjHAK77lVb6RAQX9yPBM909tv534g8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BrB1bRD/Soh7jF52sv//X1vQCquFJ8zymfkK/FXO3wwGJCCa1tEzIwzqm+fYvdCY2
	 DhOXVYoY20C6gB4jzI06/aa3FJKL16cXAVTE6GEma7rI1e7g4iXKOlePRLiF288XT4
	 VranzWw07bgVjhZQsOa83Q/zQ3MuhhyHnyb2Y6HAkPVvrS/Wn+pivLXwQqw5DGkCmY
	 Cz1VF9gZFLMgCfghzav+g+H8FtHrcNJ/t8tgMMFQF3ADgfQtXjJ3DcjRu6FOLIlaUE
	 W42fuX0MRzbloN/Ga6DFTl1WfqZzBIulN3KaPzlLmT4L3jFyDf4xTB+qfOgbKxHlU6
	 KSfFjlSeP944Q==
Message-ID: <b21a62bb-db95-48d7-8de3-e8b4d80a3a4d@kernel.org>
Date: Thu, 5 Nov 2026 18:51:53 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] mm: limit pagecache folio refcount
To: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Song Liu <songliubraving@fb.com>, Rik van Riel <riel@surriel.com>,
 Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>,
 "Joerg Roedel (AMD)" <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Steve Sistare <steven.sistare@oracle.com>, John Hubbard <jhubbard@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 iommu@lists.linux.dev, Chris Mason <mason@kernel.org>, stable@vger.kernel.org
References: <20261105-refcount_overflow_stable-v1-0-70b9c655da3e@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261105-refcount_overflow_stable-v1-0-70b9c655da3e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: guwy4e5ain75n85rn9j4uqg61qmiqo8h
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 99E4F40004
X-HE-Tag: 1793901126-625297
X-HE-Meta: U2FsdGVkX18B/8+Yi2XIQVkGu16nGqPTAj5HkV2HUClOHQtiO++L/desZ9ObfqOGKA43GF11xRq9kt6hAYZ7f/fm0I31kCveCi8d99TFwcQL/Ql5xaoXrIAQ744z2p9OtvRYIlCN55rZZahfC6iQ5bp+Lhhwzz1NXFwFQVMyO3nyYTxaxOzC5s8utKpeqLpuCMrUJ9gokm161T1KuM8KhEwGSYwpozpjHTh5id/DAKYtOEBKO9B1rDu5Zcuo6akaKPNkVVQxnMb4bB3gISAd7qlAcg4XtWBP9sfBo87dTtUAApzvZVOto5Czgq+jr7DRBzY2sXBihNqZQKOzesgdTjcOj1ArrD8WNpH2F1WmyB8oA7b9GnY3pAgq9MmPVn4NtNC6OCdKuPRXj7WfmF18+Aks+fJzNMXN6lYABrSsDWUStwmmSfnUzbwmTjfi/y++5Xc5FHOusIWYe3+KU1vFOFsNhRS6ET2tk3NeWSKTHkCxQ+Dv95TNBrORID6+i6Tjwg9hdjuFIGhcxrz7NUbk0DgDhpXFeRQu3rmzJkCtAZ5wKTAbwoRNtXYxIuKh5+9URSol8fgFXAM8YnBfqM3EGZ1fYQfAFgBkJXFrmyXrf/5iVoTZyf7VwzKSVlnoSrVkiMiFN6NaLkA2lshkhmwHsH3kIP98HTOx9rnVCVj+jODq8uENNyjDqWGTrUYCaTT/TJvE2F19M3cvgm6B+rZS1/g+AJ8qyIHcgMH2/jFuCCLM1dnvLBY0rUJ2nv6n6DnCQJKha3DQs5MXn/WThD6TDrrZ+t1vSJ/bs7tNKT7DAgQFZDA97n2hlZrkWmeePjoBVOXPbGR0iYVr2fe1hU93PotNAzr3NUBOTea16mfUibvN+ZEeBriuhrw8FghJLMr5HGIKFtAG6sALMtgwfHOujzv13cQ3mqTi127Px67B+14vvSxKYBKr3dLg45B4ZbfTFtRXG8p9MaYehGqT+XW
 89QXeqIt
 zDrMtgSgO9KBHIHO5JFzXfGOP5JnuSTYZJ1BxJk6xBhy2Vka+q6oCnDLGcz7Hkh4aeNJ/qLlc7L0LhQiRIvS4CrxhF2pMO3GsPawP1F0uUb4U4Rxq93fxQAOMIQATk5Egx6U1I0IjrrA3HV7B1+yiaTiX13PjRGD3D/Vv6ghF6CHx6M6+lFDvvg+lPPhxyppJGsW6tFX1HGCVnVJd1a0ZVIcMC+KrnPpW/j5CtAXPi7ShoVrREZSsU4pyKzVTe8xw7BFdQgI+o++60GtnR5lHaZj2smouRTv2V3H5LUtsJefdyADygN0TlKgSu+PPJhGXZFufsayIB3ZO80M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 14:10, David Hildenbrand (Arm) wrote:
> Users can create a lot of folio references to pagecache folios, making
> it possible to overflow the refcount of large folios.
> 
> While we knew that one could in theory overflow a folio's refcount, we
> mostly assumed that bad things would happen and it wouldn't go
> unnoticed.
> 
> Not so sure if that is really always the case, and leaving that problem
> unsolved is irresponsible, so let's limit pagecache folio refcounts.
> 
> This is really only relevant for large folios / thps in the page cache.
> With anon folios (including THPs), we should not be
> able to trigger folio refcount overflows (until we get PUD-sized ones ;) ).

Just a note that I don't think anon THP are as really relevant today, at least
for 4k kernels, as one would usually need that so many processes (consuming so
much memory for everything else) that this is mostly irrelevant in practice as
an attack vector.

At least with 512 pages per THP.

The exception might be arm64 with 16k or 64k page size with 2k. (putting aside
that 512M THPs are barely usable in practice).

#processes to overflow the folio refcount

4k kernel: 512 pages per THP: 4m processes (irrelevant in practice)

16k kernel: 2048 pages per THP: 1m processes (mostly irrelevant in practice)

64k kernel: 8192 pages per THP: 256k processes

The 64k case might be the only relevant one, but I think even there all
processes combined would already consume way more than 100 GiB of kernel memory.

If we really care about the latter case we could throw in some cheap checks
during fork() checks.

Handling migration entry restore / swapin would be a bit more nasty, but not
sure if that's really something to worry about in the big scheme of things.

-- 
Cheers,

David

