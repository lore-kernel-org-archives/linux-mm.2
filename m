Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D3D0606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 18:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MuAnMwHp
Received: by kanga.kvack.org (Postfix)
	id EC2466B05B8; Mon, 16 Nov 2026 13:46:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E72D06B05B9; Mon, 16 Nov 2026 13:46:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8C1B6B05BA; Mon, 16 Nov 2026 13:46:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B61626B05B8
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:46:08 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0876BA7BD2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:46:08 +0000 (UTC)
X-FDA: 85441862016.21.F39D6BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 37A2440007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:46:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MuAnMwHp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794854766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gzFx4bAFFI59zir9v19DZ8XQdYORxLgBOc+BKvg0EbI=;
	b=Ac+lpeAYtUS7/QxT8v3sNvf93vuuC5BHapaclpSlD8ZVrhuGzD0e3/5iM/ZFLjCO0f0eFV
	1fNkBAflR/b5o3CGiyaQJ8v4mCM/mXE0dasKm9qBhjC4rCF3uncNpiNQDokS0+Xw+ntfUg
	lpvM4zmjbjDUBfqoWOyAqL3EdzfLpAc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MuAnMwHp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794854766;
	b=Aq/1wFm0mPCW1/mcm+18RGknPXR+Zz75NJfcGsiLBozYGm4RxyLsGIHD/uppO5AMQW/4+9
	yG5EQtaBWfCv/HxNXnQxS1qOHW5mMp5Yx4knTwQdqthAJujy49ksEr/M9KOliCzcLAcrq9
	Z2dcxVq5ISTLf4MZRwe3UywEJ616f8k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ADFDC60D81;
	Mon, 16 Nov 2026 18:46:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91F71F000C4;
	Mon, 16 Nov 2026 18:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794854765;
	bh=gzFx4bAFFI59zir9v19DZ8XQdYORxLgBOc+BKvg0EbI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MuAnMwHpi1veXXgOhLsmT8bbWX2uZfL5RpgSMzNAtF2cjdLjfTpzrW61t4LmK8s9R
	 trgh452FwlXb/a8UHqoYQ7K0QacKn6YuRudprdpiWdi+KJqVZxRF83Bov3vjGIe1oM
	 /k2Voe1INOjwWBLiN+RqPfJktpZnedrbMAnXNDsfO2+o2IcVa9rwhYh14SowjmVEVA
	 +acEv6ZE/7rCrMClDYV4qpY/hINETO+6ghCuDJ4ZrLpEs0j3EfzhfrbeYK7nQpa+qd
	 5DRJ4Oa2dLTzQPIU7Y0xaPcS8bl3DsqReNEunp0oTo071/+tJCKzGlDUNz/fhAHSR6
	 mSbU0MjMCZbdA==
Message-ID: <90cdf3bf-7c38-4f8c-b2ce-00f29e5bf41a@kernel.org>
Date: Mon, 16 Nov 2026 19:45:53 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] mm: don't PTE-batch a swap-in of a folio with a
 hardware-poisoned page
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com,
 byungchul@sk.com, gourry@gourry.net, jannh@google.com,
 joshua.hahnjy@gmail.com, liam@infradead.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 matthew.brost@intel.com, mhocko@suse.com, pfalcato@suse.de, rppt@kernel.org,
 surenb@google.com, vbabka@kernel.org, ying.huang@linux.alibaba.com,
 ziy@nvidia.com, kas@kernel.org, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, kernel-team@meta.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev
Cc: stable@vger.kernel.org
References: <20261116063624.1382944-1-usama.arif@linux.dev>
 <20261116063624.1382944-3-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261116063624.1382944-3-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 37A2440007
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: rt4r6pwq3fsyijd8dboi3kd18xiuw1s3
X-HE-Tag: 1794854766-269063
X-HE-Meta: U2FsdGVkX18N0QCP+hIcpyszAt1KF4+iB/as7aut610Rseogu69l6QvCSriVlZspiM+8rJgErMESWLaN0wcRCPjn/nnodEiscgt7/JcDi0/higLAS4T7/EU9sfE298KHepx1j3xWm9pFzogBRMkO65R0TicCQFCGtpkHfRjHEvnpiwdFGe0f2kGyDq4CdrGCz1XFeBlTMEmARm9eQB9lwDScUAA26/pQKeiC/OjR0SMaE1zDiMDxpMe8FIU+PbS3rBEkIxvpR23afkOdNTRnqseVey2Ti1RRhR4TzeHhcfRSgSAgvLZ8/WXVHnOpaU0e0wWSFBMTx9WNn3dEE3N5uWcl0cHm8lm+RSxo8KqkB5f7GDolT1scy0OB/33xLyUofbWg/blLZBOFXA5IFZvvFKazKU4aCZ6++5NUlnXPKU3NeqiiWF4C9Jaa1y1IIYJ2Lx8DkUS6ls+qqinOvrny0kvC9oH9aTbKgohsn2jv1NtG+Mh4Pb+KU6JRxqzqMuEVkbkuQNl4dySyx8us6A7A3gE3HK8RxcHItv4Mc1KpiAhiWzE8zjFLLoj7VKjxBcz3MJ/xASxesxIBMME9rHH9a4NZ1mtV9r6gwXB/1XgPugsozowcaMqyDFPKwEj9KaOwjRxKc1OLCXb423UFZ6EwzFCcq7RKDRJZa9HDbQK+lgNeVsq6yqBWS0JVFNOZ49yIMzeVdQxBvq1ZUSHR7bPQ5v4ISpLcl54MEsFtFxzYwhaD77ProVOPsLUq/Ya27+pJ1mLCzC1x4nYCxg3Fq3fq9me2DRQQu8HRoGzeNH57gfBC8FOVT5zsrf27vjAsakpQa60BeKQtjvKZE7IftnAkIH6tMCxKgccdBbu4/1GaJCeRNyDF1/VbqUvl66gG9cViJ3MSnHWbR8wYaO4BgUQ4UGNJQgX7/U/vZ/hYVqMaUOXNu0JJpwW3cLgCdY/eNKc4MXLJekhYAZLZn9NuBH+
 pooUxFzA
 zJwv7UwGGp0oZPzlR0shrZ+wM1VmUbRn3QO6MibCK/RPLtrQuFKJusYhLP5NqLqN6jHJ4ZoYCiMxJrKyJhKPhv/aXyOOUUgNs83eVfaIlmo+NW1NcPideyVejhSkjuf+U5g6YiMmrZ+M6hl7+E34zdWcYZkOEJ8mZ8x/AEz2m8wqEGqZ4Nb495/yQrLzb9rZE6Ck12Mx0EqjhHuykRCgkH8sT1B4qaM8EKSmnHzHqLV9dD8U08mWnUlWTQCHG6qUiJt6+eMNWXIY3dth5+WtfLZGbAa6D6gnSzbl1YhPA1ib4jTrLVPoj9gvevlka7xocnduwnHco/N3AwUG220iez03y3BRdXYSscxjP3KvSi4Td+kw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 07:34, Usama Arif wrote:
> do_swap_page() checks PageHWPoison() on the faulting page, but the
> large-folio batching path then maps the rest of the folio without
> looking at its other pages. A poisoned page that is not the one being
> faulted gets mapped anyway, and the fault that would have reported it
> never happens.
> 
> Skip batching for such an anon folio and let each page take its own
> fault, where the existing check catches it. do_set_pmd() already backs
> off the same way.
> 
> Leave a freshly read folio alone: it is not anon yet and can only be
> mapped as a whole, and falling back would free it with the poisoned
> page still in it, which the retried fault can then get back from the
> page allocator.
> 
> Fixes: 508758960b8d ("mm: swap: entirely map large folios found in swapcache")
> Cc: stable@vger.kernel.org
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/memory.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index d477a4f986bc8..51e72fb40655f 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5158,6 +5158,11 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  		    swap_pte_batch(folio_ptep, nr, folio_pte) != nr)
>  			goto check_folio;
>  
> +		/* A poisoned page in the folio must take its own fault. */
> +		if (folio_test_anon(folio) &&
> +		    folio_contain_hwpoisoned_page(folio))
> +			goto check_folio;
> +
>  		page_idx = idx;
>  		address = folio_start;
>  		ptep = folio_ptep;

Why not check before swap_pte_batch() ?

-- 
Cheers,

David

