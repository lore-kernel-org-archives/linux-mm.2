Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDFF7F31E24
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 15:11:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B0D66B0093; Thu,  9 Apr 2026 11:11:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 262316B0095; Thu,  9 Apr 2026 11:11:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 178216B0096; Thu,  9 Apr 2026 11:11:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0B78C6B0093
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:11:38 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A4BEA58EB2
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:11:37 +0000 (UTC)
X-FDA: 84639356634.29.11DCAC4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id D92A3160006
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:11:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VlUcElYu;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775747495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Exxdezai81WMrpXeIii4WHdkN5NN91vHx72vHcwcvQ0=;
	b=XPp2aj08s6kau8xvc64MaAoLxvTh5dQERCpkfSRIjbTyl0XZIuuVPwUhUbTICFGM46/Kah
	DDr/3NS5WC614N7Tm38hlIn5XVy5MD6c6+FegbeCyMLhechp0y2rAaS5YV0ybKRGRDZCPF
	BVnbTQl7SU4OYNULEhVlmtt/ZjPCNKw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775747495; a=rsa-sha256;
	cv=none;
	b=LqwOo8JX1rC2xQDCnqYFvd0mD7nqRFjFz4Uo4mEaJxMJa//yv/etg9t3J+g/jr3qY4ya2P
	PD0/CYQATvXS238VxeHno7omNc+YDV4/d41KD2EJpU6kZ2UHFY2CYqGn+q19yWnY2ApNKn
	exle1AIbC9P7O+/4S1lRDfMvCTnJUo8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VlUcElYu;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3BCB760125;
	Thu,  9 Apr 2026 15:11:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E9BC4CEF7;
	Thu,  9 Apr 2026 15:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775747494;
	bh=g2ADslYAl1gkG6B2ryk7AAj+udO2hcR5FE/jpdgcyXE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VlUcElYub9DBYJ7OhfBzT83mIYtFZk+b7GV8Yc2OxMb55U279PAMlUoIYKbc+lP9k
	 IcL9R3S0tfkvClz9l31/nYbK7bZIuLUQeXG0tqu7GlemTGalRrhbUGz9B8Ghepg597
	 WHxO0dyzH2GABw8ZivJkcL/syeN8nIodknFT75lBFfJ20KomrrusjUMuxq5KNYk6+K
	 7vEpPVFEQ6+A14Jnnx3JW2tmOVFSpJ6u03nU46hTKoocNWGkAOCtSR7MV+QiaGYid/
	 PO2iY+AhpUY4s7odgDEREOI0vyJFSqeQRLjJUmuCdFq2bWfHRVSo6Lh6twSeohqTyT
	 ipl4sc6yO2Zpg==
Message-ID: <accf843b-ee4f-46a2-b187-a6d8e4115ca7@kernel.org>
Date: Thu, 9 Apr 2026 17:11:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/gup: fix GUP-fast fallback for NULL-mapping order-0
 folios
To: Zi Yan <ziy@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Peter Xu <peterx@redhat.com>, Mike Rapoport <rppt@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
 Sourab Gupta <sougupta@nvidia.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
References: <20260409014647.397515-1-jhubbard@nvidia.com>
 <4d6c1af0-dee5-4f1b-b74c-2ebc23de7baf@kernel.org>
 <D74E0809-E673-4CD0-84DC-46CBDBB06F03@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <D74E0809-E673-4CD0-84DC-46CBDBB06F03@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: a9paddae7mpo47ochshu4fxanscdkj56
X-Rspamd-Queue-Id: D92A3160006
X-Rspam-User: 
X-HE-Tag: 1775747495-36692
X-HE-Meta: U2FsdGVkX194cMMwq1UU6qPvFOw1CGc3bIH6WCvpGo9FwpY/dB2FCneB4NDQrHd8MAD5HeUKk9xOs0k/x+4mi5DMjn/PKnC7qr+a9KG56c+5ml6UVtkkQcK3IRqEcVckBvWw7vqpDwbEe+iWA2KGNtd98pfpB3b7uuoudn3OAMKEcC26VdotRr2fHtuCq4D1Wn50R1UVKBpQw0KLGEgwa5aPklFxHVlYJTna8NdmFMXZPqY48ZySZCcfnBB5shKuuBwJcH4fyxmJyvKFUibvRVfZU7rr4s2blpl0D/DFREqMj0ymG6Q2sgtAN7YylSslPKOCHb4J8/BvJZMoYGVjAn7U8WqvbCF/zafGsM723mSy1F45wWSQ+3NYEAfozC9ggSNCT6fc560PX7ZblX/aimeqkhM8qQV3XLA0khJ4UkBA2iX2+8sUPYeP6QZdrB2ehDNav0I+0FKbB9YEkrxB50eFnEIWUTWg7duh1Edo60AlHu9sgjWV7eTSK4/N1P0vE/XBJ4NoitCP7a/Qp9/wJRVMOTu+4kGIta7irmsC59PAGqSG+8o0cA8Nwgjrp+me/tQBO5hXcqZiJ+9yHciZKSvk2zk77tSE25ulJTkAtFHGfRTqSBxkngz6qn4VF4soQR02s/TlVBp27Xwd3q8YqxyzwCd7nq1lIt5MrwrKmiXUt9310zfQJx/rqZ0uz7Mvbu6eMOyKrXe77w/58DPc23yAv4FHBl5hsaRLaAb6Yu7//QOfU+lbbWrhVJtsLSyyuemrisTyMUWLdQG7LFSp2Z0Q8AbBdsaLKubN3ZLu5AtEo/AqIcWo0VLccupQ4JZsF52l3j+1V4N8XVngqDp2Tt42XVBfmIiDPwM2OkPg0JV+fqBfiuhBDyeJj4IZOtmaCcRtLF5HUJjcBGYOEgGA4lyLm0fYAjxkr0CoFeNzEhfmeoP/wufxtEGjlmahnAYVA9Zypv2KlufCLCTSBvX
 NzvYeP+7
 wOY6E4Xbq5uxU5wsDvIESw4XDTOvfadTGz0CedYFHKXQ/hL1as5FJkzQp491nJH+Yoj4oRTdJTlgF9YdY36tO3eO/Zut2i+Q3eRXYkMOQSa2nYLD+jI1RUbDD2d4/Lp3rH5jNcLF5pDfv+PGHmI+cFL+z0GS0sorJ+jdSmsl2qkcoEW+vqYWc+g5dUAsoTBrPf7WUagiHFsvxwWOTnE65S0mOnKiVCW+EjCPZry+A1OEcgHwR4FERyQ8KfYOtmo2ZuQNzjeOhvqHBZTFZqblnkToZ+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/9/26 17:05, Zi Yan wrote:
> On 9 Apr 2026, at 3:52, David Hildenbrand (Arm) wrote:
> 
>> On 4/9/26 03:46, John Hubbard wrote:
>>> Since commit f002882ca369 ("mm: merge folio_is_secretmem() and
>>> folio_fast_pin_allowed() into gup_fast_folio_allowed()"),
>>> gup_fast_folio_allowed() falls back to the slow path for any order-0
>>> folio with a NULL mapping when CONFIG_SECRETMEM=y. This causes a
>>> performance regression for drivers that allocate pages with alloc_page()
>>> and insert them into VMAs via vm_insert_page(). These pages legitimately
>>> have a NULL folio->mapping, but they cannot be secretmem pages.
>>>
>>> Secretmem pages are always added to the secretmem inode's page cache via
>>> filemap_add_folio(), which sets folio->mapping to the inode's i_mapping.
>>> A folio with a NULL mapping can never be a secretmem folio. The
>>> NULL-mapping check was intended to handle truncated file-backed pages (a
>>> reject_file_backed concern), not secretmem detection.
>>>
>>> When only check_secretmem is true (and reject_file_backed is false), a
>>> NULL mapping is sufficient to prove the folio is not secretmem, so the
>>> fast path can proceed.
>>
>> Hm, what if secretmem folio just got truncated? I hate to rely on some
>> handling in the caller to detect truncation differently during GUP-fast,
>> but this function returning "true".
>>
>> Zi is working on a way to distinguish folios from non-folio things: that
>> we can identify whatever was added through vm_insert_page().
> 
> The idea is to give every allocated page a NotRmappable page_type and
> 1) let page_rmappable_folio() remove the page_type by setting mapcount
> to 0, since page_type overlaps with mapcount;
> 2) allow callers of alloc_page*() to change page_type from NotRmappable
> to other types.

Could we instead just set the special type in vm_insert_page(), after
verifying that it does not have any other type?

> 
> After these, rmappable folios with any order is a folio without any
> page_type. HugeTLB is an exception, but rmap code has special handling
> for them, so it should be fine.
> 
> I have a draft[1], but have not had time to refresh it yet. I am planning
> to work on this after my two other jobs (make READ_ONLY_THP_FOR_FS enabled
> for all FS with large folio support and ensure ->private is 0 for tail pages).
> 
> [1] https://github.com/x-y-z/linux-dev/tree/remove_mapcount_for_non_folio-2026-02-16-23-27
> 
>>
>> Because that's really the key problem here: vm_insert_page() pages are
>> not actually folios, they just look like a folio today, but looking at
>> fields like ->mapping does not make any sense.
> 
> Based on my understanding of some callers of alloc_page()/get_free_pages(),
> vm_insert_page(), they use GFP_COMP to get a compound page and vm_insert_page()
> individual pages of the compound page. These pages might be pinned.
> During past THP cabal meeting, we discussed about it if
> 1. we should disallow such uses and only allow order-0 allocations, or

Right.

> 2. we need a new type like new_type_folio for them and the type does not
> have folio fields except ->pincount.

Right.

-- 
Cheers,

David

