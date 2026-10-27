Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9E21606A31F
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 14:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nZUK+SXF
Received: by kanga.kvack.org (Postfix)
	id D47796B0773; Tue, 27 Oct 2026 10:06:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF8256B0775; Tue, 27 Oct 2026 10:06:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0E7D6B0776; Tue, 27 Oct 2026 10:06:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A6BF6B0773
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:06:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 35C3A160A6A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:06:16 +0000 (UTC)
X-FDA: 85368580752.26.612AD54
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 79F7B1A001A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:06:14 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nZUK+SXF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793109974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=82GVQF/r/unWzQfzjss77Hz55a2gB/UcDEpj21YiSxk=;
	b=UiguaPSQM1dppVlpI3W0oMaUvRcj+B7ZyKSog2NrrZ5n9gc5eAi5T5jIsBEwk1IZzb+qmQ
	RbSxdXePSraWO5W4MktmUiCykLQHPjsCaq02GsJAPCI+HdX+4GEFbtuCtjgUftzftAOPrf
	JodCFezEjbIiy5lnXiMeAvWYb4Z1nfE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nZUK+SXF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793109974;
	b=AwFl2kpyDbGTZP8Yf7Yf4zzH2z9OhRPU5c5wODUXrnZuvHBT5VjFb6SSVhwiWDSCu4jjm9
	zmELUCEMu0UPUhCmckoma9jK9SiJugLsnqK42q5XBVicCyRKUBsh0n59nuDCUtpsD5WF1w
	BAspPI8sYDR74bK9D3cmKYqmmGbWPmI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E0169601FE;
	Tue, 27 Oct 2026 14:06:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0201F01825;
	Tue, 27 Oct 2026 14:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793109973;
	bh=82GVQF/r/unWzQfzjss77Hz55a2gB/UcDEpj21YiSxk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nZUK+SXFsAgy++54w5IClDKo7g3++cFiM8TnqT2+LuG2HpPq1/K3HIQXOOIqc8mVi
	 mimy9pQ3LiHr7Uv0RMQYlxatSPdssmML/JLJvYuIdW+skcb7OAscL1zKzvE/7KFjSi
	 C5SfM2niQETkzsKlEAsLJjyhwPpgFj3h1BLvGqJKVglngLpLProiWkhE3sxhOwjds8
	 Y9aYsuyyzfMODkxbCLDMI2MKNmGNxm1x3h2InAoU1pty5v5HJn/qrj2HC5Us/03zJT
	 /pmxKM0bibEgfhWd8LG22BhwEnrdTBpRB7oS2UKU1CUeUtFxQc4UiWu8EfdKYfprbP
	 4ptN8qpbOZvCg==
Message-ID: <99117abf-29eb-420d-bf8e-740c2068a0ba@kernel.org>
Date: Tue, 27 Oct 2026 15:06:04 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/4] mm/rmap: duplicate a PMD mapping as one in
 folio_dup_file_rmap_pmd()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Peter Xu <peterx@redhat.com>, Alex Williamson <alex@shazbot.org>,
 kvm@vger.kernel.org, =?UTF-8?Q?Lo=C3=AFc_Molinari?=
 <loic.molinari@collabora.com>, Shuah Khan <shuah@kernel.org>,
 linux-kselftest@vger.kernel.org, dri-devel@lists.freedesktop.org,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>
References: <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-0-66f00b7a564c@virtuozzo.com>
 <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-1-66f00b7a564c@virtuozzo.com>
 <atnEFyGRYGGf9shA@gremlin>
 <71101695-339d-4f8f-b9d8-dfadf7dbd0ed@virtuozzo.com>
 <atn3SPG5MKpj2Unj@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <atn3SPG5MKpj2Unj@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 79F7B1A001A
X-Stat-Signature: pxd8xgeao413a8ndcd5f99u6zdsg73iz
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793109974-736742
X-HE-Meta: U2FsdGVkX19EdWIRKijtd4ymAaP0GuFxtsLoKwITgM3Jvih80HeEyBZL33rvot4BSWzkgWRVTFjx0eNlft3qKeqYeOTyLFGrc7FIdM69G1U/6K6w2TWJd0ktbP5vE7ElkWV2vpYo0zfC565zfRmUnuk/MVTgYm1nnu3tFSXBBXS0gWtCuwukg1y1BCWiKgrfy1Qt4Yz+pbau26JBe2hn3TLzxZItljbG6YW0uDsGH7ndpK7ngSasdUPhDpNuELZB0Y3Aw9iz0AXCaObfbOO5l5XJea4DAzgMJupbfzTb9H8gzdPIf3ZRf9cVLEevVWLXRIdCRt9/pZD2ECgv/tIbEvvvTj4eclF065dyxVc+pyskCH+OwBbjD0j3XJliRfv52NccDJBRiGPiDg2SwZNvqlIvmmCU79GTIFhiKR3N8HyLQXk0dVf8TqJmklP1y9xeCMAIvXH9iELyDnKq5JICQtIKEUsTHtAZ54V5dGbFgKv2vi3p3MGF+epNsvKMcKXFdiWy44wsgZUl4ylXQOwXxzAWFrLztXMjpr3vXj3kOcBBV+yvahN6aPQBIrdyM4j6n5IxFbk+aMDoTyh5mV3PTPmEnUrwXev4mDgWhHkTGDKS/FL/lanu44JEmCskmcPllRcZaFHc5sU1VnHc5y40LPcnorSzyJptv3LUQo0OAGtzfFxjroq3KLuGeEHWcR7XxFCYyXs44F9Bydlnp9I3q7YgWSRj6+p2oVo+GQwzWSlNA763ky8iXU4bFp+zQSs3ZSJ6qsOCQ2S4ecIIr86eYkqCnzQ9zDasGRIvMHIUw/2OaFHGZCIbZzuWfR4EBSD/Ny6gMqu60KVHR4z0kg3U9fePB7srYy35wn7ayJVI5faL24CKnAqorSPWcoUEUQrSkRJXrj02beoTRG0cQIfOIb8QQwRquD9zbD4wpydAp7wCPv9FpgJVFafdkq6T2yDlnprvJDuXFpmXi0pzvP7
 rgCtnVzg
 dDMgFpKVfIwnWKd9dH6DiqSnOgP97aKXP5AA/hnGSauKXAw3odUcgz8ncCUY6zopW+7fs17qufbM0SKgTX95xOO7EGUYJuxuaUGcKmjfiC7jJBlg0TDmIZblJJM3oBgbVQSDGkTS2hbGEtwZBtD6s4WvQThotSIL+OM3xjFFf9SPzLZFrlFgNgV55mEf/oKg4bnyTNKF1LmrR4PAKrgA8VbgjlcOAiy/C9QlUmxcb+ZDINekF8YmRjG1y8C4tO8TSrCTXIoUS6t2wQ1TRf0FmWCnFqM2zJXVvrW9SRuVYVlx02nlTit1C5rhosPOMo9Rfvyh/sj5jVF8RcrY1zw0+jmiqKcwab26PgMOngyIR3hlSbNh+ZHDl1d8vOAPwbld8HDDeMAgiBBAGqSrZyGrgSASAKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/22/26 14:11, Lorenzo Stoakes (ARM) wrote:
> On Thu, Oct 22, 2026 at 12:44:40PM +0200, Konstantin Khorenko wrote:
>> On 10/22/26 10:07, Lorenzo Stoakes (ARM) wrote:
>>
>>> Was this a mistake in d8ef5e311d7b, or actually intentional for whatever reason?
>>> If the latter this shouldn't be a fixes.
>>
>> commit d8ef5e311d7bfde54b60ab45026f206eff31b2d2
>>
>>     mm/rmap: convert page_dup_file_rmap() to folio_dup_file_rmap_[pte|ptes|pmd]()
>>
>> ...
>> +static inline void folio_dup_file_rmap_ptes(struct folio *folio,
>> +               struct page *page, int nr_pages)
>> +{
>> +       __folio_dup_file_rmap(folio, page, nr_pages, RMAP_LEVEL_PTE);
>> +}
>>
>> ...
>> +static inline void folio_dup_file_rmap_pmd(struct folio *folio,
>> +               struct page *page)
>> +{
>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> +       __folio_dup_file_rmap(folio, page, HPAGE_PMD_NR, RMAP_LEVEL_PTE);
>> +#else
>> +       WARN_ON_ONCE(true);
>> +#endif
>> +}
> 
> OK so it was just wrong at the time :)
> 
>>
>> Both functions were introduced in a single commit, i think it's a simple copy-paste issue.
>>
>> The helper never had a caller, so nobody could hit it. If you prefer, I
>> can drop the Fixes tag and only mention d8ef5e311d7b in the changelog, as
>> there is nothing to backport.
> 
> I mean, it seems like a bug to me? If there's no harm in backporting it I think you
> should add Cc: stable@vger.kernel.org in that case actually.

It was never used, so it's by definition not even a bug. :)

Cc: stable makes sense if we want to backport it along the other things.

-- 
Cheers,

David

