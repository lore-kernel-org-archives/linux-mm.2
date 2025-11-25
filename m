Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4F8BCFD379
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 08:52:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04B016B0024; Tue, 25 Nov 2025 03:52:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3DC56B0026; Tue, 25 Nov 2025 03:52:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2C466B0027; Tue, 25 Nov 2025 03:52:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D0CFD6B0024
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 03:52:32 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 80BE21A0766
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:52:32 +0000 (UTC)
X-FDA: 84148513344.07.551580C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id BF7FB1A000D
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:52:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jlWqvyTf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764060750; a=rsa-sha256;
	cv=none;
	b=GenFLRwd5BGMp+CBgNM4FLJtJrQKn58Gp7WGZnplL/F2lU8E0w+ZtQk76+1ylDKVLAmOPt
	KP9Q07zc6M3qChIhjFRfhZeY24FX4FReGQthRNm4LbjduIsP/y2SDs0xkm6KDXhMzsIZDH
	5gE7vf1XSosNvYJX401sH6YWUJseIjY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jlWqvyTf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764060750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XxgCjm8KJfnOG75IlYZIKmCNP4rFm4UYg08/PhxOZO0=;
	b=VPsokUiJJBL2TUZxxuRQ5XO43cDgGv+oj5xiGq1FRNJEijAUMjBY0WUJ9e2ZAg1j4Q6+J2
	DBC1B6LtXgswg91WKh9RFmQkcomNZcephIMckvRkimKPBOxyb/W70lSiATY7ZU9LtULyx8
	C04yFXCjm9l76FWssha4JFGHhLU3AGo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 029886014B;
	Tue, 25 Nov 2025 08:52:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A900C116D0;
	Tue, 25 Nov 2025 08:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764060749;
	bh=WACZF/HwQACWdEWXrmIS+prCAYLYXVe/fT2oiuOjUjc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jlWqvyTfEjzLn7bT1JbFiKyTwqaxXFDroS868o8NNusJwRiTK+Sps76NoS0cLLPvc
	 f0Zez5qO/g7UB3ZtE2LfiYzfMJwZrRFFfIvfQV3VBfQOBUdfZpNVioCAybcC4IRzIY
	 LNhKW3xwaKQ3dlvcyzflVtWWnLfpJFAcKi+1MyMiWGp94SxVAwDhapEMqMZteLOLF6
	 j/6pttGboL2g6ZZLWd6UAiOZOwkHAesMCVAVmmZegLPh3bVgNpifhyjup4oWXLRZNq
	 Jm4/S4AOfkg9xz2wfe4M4kkA1VrtxrD011ACQXUYgsRwS1aDd3UyMpqsyRlAASJaz9
	 r+C9omdYQxaew==
Message-ID: <2f708eae-7d4b-43b0-83f0-7c2d98b294e6@kernel.org>
Date: Tue, 25 Nov 2025 09:52:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] mm/huge_memory: replace can_split_folio() with
 direct refcount calculation
To: Zi Yan <ziy@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Wei Yang <richard.weiyang@gmail.com>,
 Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251122025529.1562592-1-ziy@nvidia.com>
 <20251122025529.1562592-3-ziy@nvidia.com>
 <df92a886-069a-450d-a551-dbfc3f629ead@kernel.org>
 <33A929D1-7438-43C1-AA4A-398183976F8F@nvidia.com>
 <34bafd06-250a-4019-8b34-5ddeedea1cb3@kernel.org>
 <66C159D8-D267-4B3B-9384-1CE94533990E@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <66C159D8-D267-4B3B-9384-1CE94533990E@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BF7FB1A000D
X-Stat-Signature: t5b8agddp1ufderi9ku5gsiw1m1jpojk
X-HE-Tag: 1764060750-443481
X-HE-Meta: U2FsdGVkX19Sfg4p7hs0PftPKnVSFsXwucv4ZIrXTr80ma3IQz0wHxoLq7wADiMSwgb755wQEGXwII1pVUHdTPtFHM1jA90XG5WCM8ekAruwQeWdi2svwKsjQtDNFgIt91+2AQ/MUmtTJzTynP0GSr3FhKiC911sRODpfv+furNvdi1f7L0BWO0ghcc734elu1Bznu1hOpXicLZjj0WTJ3H0Okrid0gTYCuvl/b/2erCA/HuDrec9XD8NBUHzo8H4tOsJ3NrZuTHMOdmETrLn79eBp/YXbrZ8l5aMDXNxh3s2VQCeh0DQpLW9QLGOg6O6qWOcUF35dXyzFxN7d+mWVTTQ7zO25LLCJrazk340Oq9CL8pwMNtlBGimPsH5R3mBYy1krmxIECH7Aq1pir3ywuIKRQCnySwoi1xW0Mt6dg1FCRolGC2c1BkPrvbvB7KXva625l5jYn6cQiPjcOSh+MiDcaLVDyB3wqYI9KJjQjAFuZcaIHrpmjQZmcoYFEKAU6J4dzb6fIOXM6GUUGqhHQ3uGiDJ3Tgkz9HgULkZ28+iNYMjUz9nE6T5wcLNOoQJE5zh1VWJjjL1ePpMIKyEwNvuJELIwSkkwcOs+aoZi/dHzlDdJSzMuxn8fDFhIBxm46eLY8UT38R9WfVwnY/TEQ1IuM8GQuM7UNIWbCvGLRWe+nUB9zzk4iNfNP8p+chuP4qP9XeMwaLPJolEdSZrcuzxZG60MEYyMxuilkuYgqLkAHWqgDQQqb30UMVtvgn44IDGmo1vgXOjHqe2f17O+K59fMZ6fI2+wc4TFNP6pFJlUMGA5kKEuPI4SflIq4LEMdau3nntdB5d17BUx+7JX9T9+TTXiiZaCU/gYcSgwEBLWITY0GFnOkomtgthQkN7faFk/QZp7qqp8WVtt5q5wLHKvLvN3sTzq7y7pUPqE+CDNTih0VnaJ+7IDhbVyFuE+dAV7Jx0+bXLJvZDtM
 gkz/IgLm
 hK65Js+LciDrxcxGVebZrJjXwrv+Ujyc0C4K2CGxLTVBd15g0O6xBd2r2DSzI09zZICknA03r3CUqPM3X+lPONjRB4jbIYguzfS8SCTpArZiiOWZTMzXGzLbVyri5wbh9yTn6rn/o7PoSa7woekjyAny46xSKyQ2Qs8ddA7CoiV+hYne/kOzCrNaUZ5/3Aij/yBKgYS89lAf7JBaekN4Ct975lrgkquq/UMHPHSDBQFtonnPcAckfjgL3vFBgDWZ2TGU2Uj/wgUI3rD3aOPU5N+yZoDcKbbPuo5JDykUvNpCns1drWtpzoTrQZUyN/dgsJpGC4ppqDdik+DMaVu5aE2621F6VBG8Ld8tE8NdY01caWwgJfx4n7nHgw2PwaWRpr4UBgXiAueIK4k9u8fLpLKXqZg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>>>
>>> Like:
>>>
>>>           if (folio_test_anon(folio)) {
>>>                   /* One reference per page from the swapcache. */
>>>                   ref_count += folio_test_swapcache(folio) << order;
>>>           } else {
>>> 				/* One reference per page from shmem in the swapcache. */
>>>                   ref_count += folio_test_swapcache(folio) << order;
>>>                   /* One reference per page from the pagecache. */
>>>                   ref_count += !!folio->mapping << order;
>>>                   /* One reference from PG_private. */
>>>                   ref_count += folio_test_private(folio);
>>>           }
>>>
>>> or simplified into
>>>
>>>      		if (!folio_test_anon(folio)) {
>>>                   /* One reference per page from the pagecache. */
>>>                   ref_count += !!folio->mapping << order;
>>>                   /* One reference from PG_private. */
>>>                   ref_count += folio_test_private(folio);
>>>           }
>>> 		/* One reference per page from the swapcache (anon or shmem). */
>>>           ref_count += folio_test_swapcache(folio) << order;
>>> ?
>>
>> That is incorrect I think due to swapcache being able to give false positives (PG_owner_priv_1).
> 
> Got it. So it should be:
> 
>            if (folio_test_anon(folio)) {
>                    /* One reference per page from the swapcache. */
>                    ref_count += folio_test_swapcache(folio) << order;
>            } else {
>   				/* One reference per page from shmem in the swapcache. */
>                    ref_count += (folio_test_swapbacked (folio) &&
> 								folio_test_swapcache(folio)) << order;
>                    /* One reference per page from the pagecache. */
>                    ref_count += !!folio->mapping << order;
>                    /* One reference from PG_private. */
>                    ref_count += folio_test_private(folio);
>            }

Interestingly, I think we would then also take proper care of anon folios in the
swapcache that are not anon yet. See __read_swap_cache_async().

I wonder if we can clean that up a bit, to highlight that PG_private etc
do not apply.

if (folio_test_anon(folio)) {
	/* One reference per page from the swapcache. */
	ref_count += folio_test_swapcache(folio) << order;
} else if (folio_test_swapbacked (folio) && folio_test_swapcache(folio)) {
	/* to-be-anon or shmem folio in the swapcache (!folio->mapping) */
	ref_count += 1ul << order;
	VM_WAN_ON_ONCE(folio->mapping);
} else {
	/* One reference per page from the pagecache. */
	ref_count += !!folio->mapping << order;
	/* One reference from PG_private. */
	ref_count += folio_test_private(folio);
}

Or maybe simply:


if (folio_test_swapbacked (folio) && folio_test_swapcache(folio)) {
	/*
	 * (to-be) anon or shmem (!folio->mapping) folio in the swapcache:
	 * One reference per page from the swapcache.
	 */
	ref_count += 1 << order;
	VM_WAN_ON_ONCE(!folio_test_anon(folio) && folio->mapping);
} else if (!folio_test_anon(folio)) {
	/* One reference per page from the pagecache. */
	ref_count += !!folio->mapping << order;
	/* One reference from PG_private. */
	ref_count += folio_test_private(folio);
}

> 
> I wonder if we should have folio_test_shmem_in_swapcache() instead.

Interestingly, thinking about it, I think it would also match to-be anon folios
and anon folios.

folio_in_swapcache() maybe ?

> 
> BTW, this page flag reuse is really confusing. 

Yes ...

> I see PG_checked is
> PG_owner_priv_1 too and __folio_migrate_mapping() uses folio_test_swapcache()
> to decide the number of i_pages entries. Wouldn’t that cause any issue?

Maybe at that point all false positives were ruled out?

It is horrible TBH.

-- 
Cheers

David

