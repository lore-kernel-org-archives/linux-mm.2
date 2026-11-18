Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22ED3606A33D
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=he36b/6E
Received: by kanga.kvack.org (Postfix)
	id 1B4A36B05B0; Wed, 18 Nov 2026 10:38:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1650C6B05B9; Wed, 18 Nov 2026 10:38:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0058E6B05CE; Wed, 18 Nov 2026 10:38:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B8BAD6B05B0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:38:13 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 22A8B140786
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:38:13 +0000 (UTC)
X-FDA: 85448646066.08.53C1EC0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 08DFC4000B
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:38:09 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="he36b/6E";
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795016290;
	b=lcsgA/x7eONjuDQrGas6SgDTiVosfF69OzrwRry58MqNF1Hh4XH8vVqhI0YSs8z+74HV6c
	Vqxtmx6Dxe4uO5jJ33rGOS9enFK/KODetHlZdjSeUrwvkuDZ6WPFabGSwFOCHaE6xqurut
	fTo9VOJlIW4HB75phB+jU9G/yfMrmik=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="he36b/6E";
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795016290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jIGDyzvPixsYlZiwHZ7n3WuXYMcBKEBGbB/tgkrjMOE=;
	b=AaLqDhYzMwZlevNVeo3zb7rAjik6+gvh6O4YZNOonqmHpovwHb1y1LEZ6b70+nG/ODtwuO
	6lAUMuK+Uh+RvmEJ6YDW1EA95Yx51zXOIiswMKVJzva8LNMWVsMsCnM490BwMXCQ0dkrl+
	yMq2U5FIWDhAVtebzqNLK/Bu5khxHhU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F60360A7F;
	Wed, 18 Nov 2026 15:38:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC80A1F000C6;
	Wed, 18 Nov 2026 15:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795016288;
	bh=jIGDyzvPixsYlZiwHZ7n3WuXYMcBKEBGbB/tgkrjMOE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=he36b/6ExIluxhS6fD8EE+OrESiMUvOsH6TIF2u3W59D82dL+HTWsu0/TFIofuwdR
	 G6xqvNe31LWTTGZhOVEFwDQPkFjflpIPu6Z4W0Gug4RXFek702hxbRI6Wd6+sIFCvw
	 VTznp9fKSRNDWRmax9MHhw1PSZd3cXIGFT+9K2xvWLImeHn5XprOL4u5ARPQW+Luhl
	 zAlM+qNSD71sGU9tEIlIAgq1D71kwzQddNfmlI+yeoZHCvu6W+ebYo6a85jacJxNm3
	 JS1MOj67VkIo4x+PjOA12EFczi8U6R6POyNzOkMPAKJlToymzEYjYsr+4fDxCJVngZ
	 sQX4EqWiD0qhg==
Message-ID: <d05636be-5a37-46e1-b6d2-30950b7778b5@kernel.org>
Date: Wed, 18 Nov 2026 16:37:50 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (subset) [PATCH v3 0/9] userfaultfd: assorted fixes (part 1)
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport
 <rppt@kernel.org>, Peter Xu <peterx@redhat.com>,
 James Houghton <jthoughton@google.com>,
 Andrea Arcangeli <aarcange@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Michal Hocko <mhocko@suse.com>,
 =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
 Andrei Vagin <avagin@gmail.com>, Muhammad Usama Anjum <usama.anjum@arm.com>,
 Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 =?UTF-8?Q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>,
 Tal Zussman <tz2294@columbia.edu>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
 Breno Leitao <leitao@debian.org>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
 Felix Kuehling <Felix.Kuehling@amd.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, dri-devel@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, nouveau@lists.freedesktop.org,
 amd-gfx@lists.freedesktop.org
References: <20261117-uffd-state-fixes-v3-0-b617009d1a4a@columbia.edu>
 <179501525761.13527.5348420494097607881.b4-ty@b4>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <179501525761.13527.5348420494097607881.b4-ty@b4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 08DFC4000B
X-Stat-Signature: psgnou1ua57zoje66u6orwfoy8jabnmr
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795016289-502778
X-HE-Meta: U2FsdGVkX1+kh5jnIWpECKEtDm4kPz0gWVO9Q7AQeXNIpvXbu0+9Jadm602xTioDQdmGu0ZoE8dFwYwYuK3URCGiO/JLi1ORf3+GJ+pOce1y2OGY2Oc2nkxe0vBezJ7EwCZE2bCcxuu3B6EHYcFVoQUDcZmk2PdGUtLPlabEV1HVt7RLhi55+xc1DLC05idEfPtsKgX9gRDmJ7Gv+FQ5cwhxZmJQTd72RX20xZU6SY6F6mgyFhjn+vw+iojER1cD2nmeNE8zrKA1BSPbyfgosoCB9cF2wQxNcegYbEvOJChERBhCq+k7qmhTshcmw423N2ObM1WE0V9/AcUvUw7Bqe7CIRTeh5EeWRvPuChjGnbHhMlXAf9eCeh7B47DsYTGoVa/uMdAosS6Lb0flEkJ7khmDhzqLuubTVutIzucN4NHkjok47xp49iQ5NgqOH721/RC09o8yxvqZNmEKyjVAbml7/PUZbcR7Sj22LkMTTb1ZuEz81nZL1R+kaIYcrRjhj+5UEKd+UgMpM/FvTvX8Go0xv/+9F5MlrvwQmdFTDbH/Yto5zFdZjudLJ6/Bbk1dgvEJa5TW3+VZrphZ3nrI6NRMIPWXKLUIQfCaAR2Mda+HCASiPyyHaXjCu69qQBCa/BBy0+yweF9GvvKsZCYDRYo4Pj7P7qscgjvtvNmjOL/GG4cRRXb7a5Zhcd+oP4klOFqcQlzIh+O/rOJjysDxKjhv00CJmRUKd2emtPyAc7LT7jP2/5vjsbGU0b59UaFksj56haNqQm4ux2b6O4ZSm9R+GD3WlF/9vvjxswYCCrLjh8JnubN4/1XpuFyNBdoqnlX5k9JQF8/FOsppy8wsCDjJcMI5rWjaGCIymroiJdbLgKfVuQMl/Fhb7lSkLmElUoon67XSRCHzdBSrajYO0ggmWJga+x6D5vdRDe1gQq+yrv6KTbZzVcwA6B45Ck/0ucA2UOoTXTGQNcmt36
 R9Kk9mit
 2/e1N8yHHxYbGT5JLUuX2U5rVNBl+xvjwxAlo91KnuO9NHHX4cfwMdeA37CgE/ohwX8+7Imy52Z+PKmgzHTogDpZVviuQYGaZSfVLt5pGTArjkziPBb6QBEF4J3LhCymdKMdV8Aa33eYQk8ovFFKsczbErZcciaIX9uwZbTn4e0trFH78KVth5Kzl32WV9AaheXDBeReg7nPCFw5/ZQLsl5rmk7LSNfpgst4aj/HGH/IgE08u3h//c3wGlT6NgmEbs37BH7zBB7Yk4si1gcoWCpTGkFtKSIRqvXq3ylEgDRpUalwu/363TI1GX+FabuVwkwiM0f88alNNjXRWm9SU7pm+m5xaBiQwHlUZgbsJDypAFl0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/18/26 16:20, David Hildenbrand wrote:
> On Tue, 17 Nov 2026 23:28:40 -0500, Tal Zussman wrote:
>> This is a first batch of userfaultfd fixes, with more to come.
>>
>> These were found by a mix of regular old LLM review and by having an LLM
>> write a TLA+ model of uffd interactions with PTE bits and other state
>> and seeing what issues fell out.
>>
>> Most of these fix places where mm code loses uffd-wp or RWP protection
>> while moving or migrating an entry. Userspace then either misses writes
>> and accesses, or gets pages reported that nobody touched.
>> There is also a hang in UFFDIO_MOVE, and UFFDIO_ZEROPAGE modifying a
>> file through a private mapping.
>>
>> [...]
> 
> Applied, thanks!
> 
> tree: mm/core.git
> branch: thp-7.5.misc
> 
> Applied patches will appear soon in mm-next, followed by linux-next.
> 
> Please report any outstanding bugs that were missed during review, so we
> can either drop the patch series or decide how to fix it up.
> 
> It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
> though the patches have already been applied. If possible, patch trailers
> will be updated.
> 
> Note that commit hashes shown below are subject to change due to rebase,
> trailer updates or similar. Further, this is not a guarantee that the
> patches will go upstream. If in doubt, please check the listed branch.
> 
> [6/9] mm/huge_memory: build the moved huge zero PMD from the destination VMA
>       https://git.kernel.org/mm/core/c/ec36bf72


Aaaaaand undone. :)

-- 
Cheers,

David

