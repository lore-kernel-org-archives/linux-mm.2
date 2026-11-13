Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F17B606A882
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fdd8SQJS
Received: by kanga.kvack.org (Postfix)
	id 754286B05B2; Fri, 13 Nov 2026 13:36:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DE316B05B3; Fri, 13 Nov 2026 13:36:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A56D6B05B4; Fri, 13 Nov 2026 13:36:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D3326B05B2
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:36:08 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B3BBA801EC
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:36:07 +0000 (UTC)
X-FDA: 85430950374.04.EA4924F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id E20DA2000A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:36:05 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fdd8SQJS;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794594966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nr1sabwRiVAnVE1Zz6waN9h+CZcSzSFjuvr4+7jGL1A=;
	b=aZH4+sbqDuJcrG6HC1iSiRaQpi/qGkLR9inr+jSueuzWXI3e7WZXzIVMgaaiG3PJmeEgvM
	A5cfyMWnQri/63fZYa9VovsHizjWEmq9k19SwpfOtUU75i99R7kpCgx3qUlo0zYaumyDqZ
	Z7fUUvqEvv2zY3ErQL4VhhNPReNxWpU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794594966;
	b=Sg82zHlKS5ygXOBTtV/E1u+igUHHyqOZ8wpjylZwF64acAM9pMaClO+CYwPgJ6/HH013fd
	Eu1WTPr0ZpIeG8THsMbZCBqy27dz7dwAIN1gNkV6byTCT+29RM6/uaTgMtBqTCS0/sw2As
	7P/WQZhyXa+ktqdMzTfe6GyvobgcQM8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fdd8SQJS;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D17EA40B81;
	Fri, 13 Nov 2026 18:36:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0618B1F000C4;
	Fri, 13 Nov 2026 18:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794594964;
	bh=Nr1sabwRiVAnVE1Zz6waN9h+CZcSzSFjuvr4+7jGL1A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fdd8SQJSLXHHGJM+CTe5q0eusqLo4/Yvj6Hy+N/Kdr4TpdX80s8pu9YqSQPtU1RAo
	 F0uIHpulEmevf26g2P+5GP91AAQGtijOfX2d/nR0pLfTIFybtsfyCfdnV9vddJZ6GB
	 cMn/SiRohtSr3ditXEnGa+7K0U5oaJWNnZxfGSRnYEHmTTLDzEasOu+ss9NXQnLLs1
	 9ke0TAlhkOQ1EeRyY1uWxLihthGWstqA5D+7kFOmW2MwY9m318XGHjKXBcLBRZFU3z
	 +yF0IH376OzpLjOpO3042tb2yP9n9VWCcQo5XB+T8UNEaSQC8v6VqzbdHx50/oXw8a
	 6/jn9/5CMHqxg==
Message-ID: <b32fb02a-68b4-4db9-83dd-254147dbf215@kernel.org>
Date: Fri, 13 Nov 2026 19:27:56 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hmm: skip NUMA balancing on protnone faults
To: Matthew Auld <matthew.auld@intel.com>, linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Matthew Brost <matthew.brost@intel.com>, =?UTF-8?Q?Mika_Penttil=C3=A4?=
 <mpenttil@redhat.com>, Leon Romanovsky <leon@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>
References: <20261112-numa-v1-1-ad9cbca8f49a@intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261112-numa-v1-1-ad9cbca8f49a@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: cspqgsrrdsumxgd9ua7rkeer6ufy68q8
X-Rspamd-Queue-Id: E20DA2000A
X-Rspam-User: 
X-HE-Tag: 1794594965-408726
X-HE-Meta: U2FsdGVkX18+A//V9xeahtotiCn+CqDuMGN5wLOKACrRThFYqy096rYHh2hpdiWA0pOC1VfUFVuFN6VK1+lbIaiKspTv9yz9ejexewWj4KP/SsUhM5Xg4RuLXRqOCt3MXM1EQZEEx2MqO/gsRgxqMxROi+Nxmpq/pXuc0PxkRGcL12awD+iXJmNFRnKqToRGri27UBpB7USN5qE21DS/p9hsnYBK3FzSmPEZv4KbnxdqKQQkol2uD4d19FhVun6VEbDhsbDV8dPJa5xp5IkLM4XQdcImWRYKQBLMnPxEjp5s8eTiqi+O7na1EHZTHXZWxJDZYlOZq1nCTzmGh1dJM+/5j1W0fzMLl5oeCsbvDtc/oLTBwckV0ZclDTpzpAncNdKbxYViuhin22Eeuyoq74tSs6t65mjNA419TDwxP85F3cWoav1D3aA36dfJBJH3W6fRgIaZZ0p+jXK2vb4cQU3ifgVB+7p+8utcLS47sGb8ga7VShThRj51BEBhjIj0JejB3FQTxj5STkwEOgTlRRKl+G0I5kwtvgKHC3NPgIUlDweQC3LjH/BtFDxSE2ELDZ6IExoswm+KNjE86VQpf4mb4n1A3sz0Rve9cB0y57k98Xx+nR0h+1bwg9W5qnFhBPMz8x8jMnpcvsUoCNnUJME6dQOaA/zPqqzIfIlcQu7PEPm9Jl1cb/by7jlYzwAZdCgOTQzCFm+dNLhud3ynMgv+i4+I8Uw2xoOQ9zgko6dx3LM6FQbXk6PYZPq8h1eHwQ63mFt2l4+1H6sWgTT1hDsAr0b+jmwUq5AfAM0OAmSHKV+OZF4rJymrool7MfISrimH47QZJsi/NvdGhv2ldWJ41cL4MdmLXvoo7ctwfapeRhuF8rXTc+lJ9qsfEXGe/Cxw6bMLUDCwxEVSwSdzDEljjOjt2sry5+RQxkdktCL7Cp7+Cqz+qRDP0pNY+5rsCv8VE/BhxJItsyfvn0h
 XX4f+Ig3
 vr3gBj4fZe7xh0gI39a1elo7JWu0ZDIHq4kghQZTBiSsFOEDykoVekAmqGHQ963XgBgfv5aBY/bYlTDCX9jkF9iKx7jE8XSGx/nHCqXmw811LZPNgtUYTO5X7XQokzLPTP+BbJENYk9FLX9nDsr7/tpPE8c38JbRPP6KMbcmEMu2DLUy0wUfgYL+Yi5PUGZQTGbng2R3/BCVFD/DquGxtpTXqv+9GZZzRBQMyB7ZU3LONxMUc87dDNFlEgRVI1ojbfJm9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 17:25, Matthew Auld wrote:
> When automatic NUMA balancing marks a PTE or PMD as protnone
> (PAGE_NONE), hmm_pte_need_fault() requests a fault to restore access
> permissions, including _PAGE_RW when write access is needed.
> 
> Calling handle_mm_fault() from hmm_do_fault() currently triggers NUMA
> balancing in do_numa_page() and do_huge_pmd_numa_page(). When
> hmm_range_fault() runs from a device driver or kworker context (such as
> a GPU SVM or userptr rebind worker), folios get migrated toward the CPU
> node executing the remote fault.
> 
> Also, each folio migration invokes try_to_migrate_one() ->
> mmu_notifier_invalidate_range_start(), which invalidates the
> caller's mmu_interval_notifier while holding mmap_lock. That causes
> hmm_range_fault() to abort with -EBUSY after every 2 MiB PMD and exhaust
> its retry timeout on large buffers, which has been observed with large
> imported Xe userptr buffers.
> 
> Add FAULT_FLAG_NO_NUMA and set it in hmm_do_fault() so protnone entries
> restore PTE/PMD permissions in-place without performing NUMA balancing,
> matching GUP's default !FOLL_HONOR_NUMA_FAULT behaviour.

Ehm, that's not how it works.

GUP will not trigger a "special" fault and will try not triggering a fault and
not restore permissions.

It will try continuing, leaving the protnone pte as it is.

See gup_can_follow_protnone().

For read-only access that should always work.

For write-access we always trigger an ordinary fault and do NUMA migration etc.


So FAULT_FLAG_NO_NUMA is doing something completely different and I don't agree
with it.


-- 
Cheers,

David

