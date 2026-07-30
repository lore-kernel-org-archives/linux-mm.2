Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82635C55167
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 12:10:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A9EA6B008A; Thu, 30 Jul 2026 08:10:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75AE76B008C; Thu, 30 Jul 2026 08:10:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6226A6B0092; Thu, 30 Jul 2026 08:10:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 35C006B008A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:10:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C614D140120
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:10:33 +0000 (UTC)
X-FDA: 85045325946.05.EB3CB96
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id F019E40012
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:10:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L0w7fPaj;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785413432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l85ulI3D6QeubP0OTVTfkt47Xt0r4PcaywJzAgl+XD0=;
	b=gJsHTruiOT57cTqqhgfToJubQi9tKg0GFxUauMUlkxqJSj6HnDvsBbTeaFMbxmNQIFeHes
	Ui0DLczJmR0jzaSuaT4IlPyrAy1+SYGXaoE3kLl9c6nZ6/FDZHrvbxHcbYysxYxCNPsFSe
	Wq5b+QPjanjec5A55AAeXQORGedFFRs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L0w7fPaj;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785413432;
	b=mxHvwXfKqlIfXAE1eeewHgL5s7uUohRTd3+opZ8Pi8qBeM5PVfl8AFchAfvbiCVg2jy+Kx
	eeotQ2KBTjOt9hz3v1PZZ9/dOKaTHsDvAYGE9czh1D8iTekEjay6BlNz5TxCAZI8LGAN0Q
	rYoOeQ3dS/h8LoiObbEhw6szWI4sm0A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F212B437D3;
	Thu, 30 Jul 2026 12:10:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73B81F000E9;
	Thu, 30 Jul 2026 12:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785413430;
	bh=l85ulI3D6QeubP0OTVTfkt47Xt0r4PcaywJzAgl+XD0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=L0w7fPajcd0k1r26ufcG5q/3Dk6pUXAKe+RbVcgBUAd36vS7PiHsSijccpPvlIfrX
	 0IljZAjR3ZknZWyy57kmojYWKwJluLg313pxigW3bYCFDVgrEcZ32KQKINuxCva9Qq
	 5+619lj65w358KWsUqQY/NsKqf653S9+kYrnxqwGymqNkiAdaDJlyWDBmDCq9Zi2iV
	 TFbwtmUuNRaKNU2SN4rFEbuebYQZHoSAexEJXeL31M/qw6aNQtMucS5Q1bkbIqgSCY
	 7uGFkmERHkG1y4GbJX2NJsKtWFfGx9HUHsley4XzYeno58vf6JLHW1xTCcQ7a4NUqL
	 k+o5we3oj5PVQ==
Message-ID: <39b527d7-9c6e-4798-be9d-b834c8a3d2a0@kernel.org>
Date: Thu, 30 Jul 2026 14:10:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-hotfixes 2/2] mm/huge_memory: fix huge_zero_pfn race
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Pankaj Raghav <p.raghav@samsung.com>,
 Hannes Reinecke <hare@suse.de>, Hugh Dickins <hughd@google.com>,
 Yang Shi <shy828301@gmail.com>, Kiryl Shutsemau <kas@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hengbin Zhang <uqbarz@gmail.com>, stable@vger.kernel.org
References: <20260728-fix-refcounted-huge-zero-v1-0-3f261f5447b4@kernel.org>
 <20260728-fix-refcounted-huge-zero-v1-2-3f261f5447b4@kernel.org>
 <25d560df-6d7e-462a-a987-60a8695793ba@kernel.org> <amsch6HvEH5IJjfM@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <amsch6HvEH5IJjfM@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F019E40012
X-Rspam-User: 
X-Stat-Signature: s7q5iixnrxaxwg9rbkxuysrwzgdw9sj1
X-Rspamd-Server: rspam04
X-HE-Tag: 1785413431-280618
X-HE-Meta: U2FsdGVkX19+x6UtT71cx6dNxjSe5IFKZJRwbDXIGvwtahwWR+pnQxu26Ts47K6gH1lIqDb+C0r5u5nzESR4m7Qxk9E1o3LaHP2rAm6Tf5eRyBYd8lFn8TExxUA3agX3M/P0E2VeFd++JAQPSGRqWiZ6qIMSYDSgPbd4FnozI+MvIZBO+NKbd1J377Rwc0O0Iov/zjQRBAURPat5lva1Vby6lH0y66qQ/7S4B5FPgg1IfXbpzWZBsyKo1idOXfD0emWNbM9y2BgV1KdfwyxBgz7TD7ahcBhVabbb1D3GjpmjIqMBCX6tc2cRGOTOUCxvUq8rJVeAgychRP2kbtj9FrsSELzSPf1ZjCWNxUbLNnP2IMokvjetYm3BZpajOazgJCPWTJ8PgVUb4tygttq2hzNmWNnOgFCkpErUABri0Ms8zl1UHEj/L0RDr5/nnG6LkATG7xcGm7IoQI6r+jdkvM2WMdjqHqKPcVPSrQB7izPhmjyN1zr1A8N1SiZeNdEdABkVkJbp3wLazUvzPcg2X/tyYITnQRZwRRd6TUK8gXdJQD8pxVkfMR2O2CAf/VJ3YcKh+O0R+Bf8cowkffddaRIBqrFOqzis89IfQSGWg7ubv9E2BpH1TQjV9puuisT1j9HjVkkPykIPFZHOr+xwEISJcrA6DBCsfMa4KhOKgm4Fxq+G6F7AWvd3iAT0BOyFfJcyfY++XgJCM+4DECL2Yt6GvVMMcELgwj2+uijHE68i61gXG4FxrarQygH31qPUyT5OGl9YhboMCREsc+KwXM9ehIQs5GkpVLjEgnNms5nJGcleKti+KTmLdcAIcl2s5APRH15THd7w8BQ90+TeIjhf0XA1GZ52e3euFlzEdl3GzvXwC/M5/VqvD4xjUJvFzbzjGQtdlh3Bc2kswECitCCnUoxMVKTyDCjwfeL+24vTcb51g99QkfG4Rz+bFWmSMezneXPXyJ9YBC8qKEi
 HjNVQ3Qv
 ioAclNrC33/RbwnHjUzC/agqiO8QYXqlo4DGm7Nep13SjdBu3rb6a0fiqOzoKEF2Yqy+2lZmJgdQ5l7oML9LFgGAtQYlFZihfVOjfQVooUloV6GsSMLW9Rw6HZVLPGPKT2bs0i4R36byOP67CUkZHfDU8SruSFbM6Bj8FwcVpuG4j8erCWKomyuxb/rrWbz+AyC1Sm/w6K+PCYooL6QozAxmJPw238dJ+kTMC30czubFPGexwvLqRDlWWKJQPvVKcbIAq6cpFbnE96SlBrPIDtSF6GAPN2NvwnTSYpQ2Tlt9ka130+pYn/+5nsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/26 11:55, Lorenzo Stoakes (ARM) wrote:
> On Thu, Jul 30, 2026 at 11:22:09AM +0200, David Hildenbrand (Arm) wrote:
>> [...]
>>
>>> So invariants are required - huge_zero_refcount MUST:
>>>
>>> * Only be set in the huge_zero_lock critical section to ensure
>>>   serialisation of huge_zero_pfn, huge_zero_folio and huge_zero_refcount
>>>   writes.
>>>
>>> * Be set non-zero only AFTER huge_zero_[pfn, folio] are set to valid values
>>>   so installation of the huge zero folio on read page fault ensures
>>>   concurrent is_huge_zero_*() calls correctly identify the huge zero folio.
>>>
>>> * Be set zero only BEFORE huge_zero_[pfn, folio] are set to NULL and ~0UL
>>>   respectively, and atomically.
>>>
>>> Establish these by:
>>>
>>> * Only updating huge_zero_refcount in the huge_zero_lock critical section
>>>   in get_huge_zero_folio() and shrink_huge_zero_folio_scan().
>>
>> That is imprecise. huge_zero_refcount is updated (incremented) outside of
>> huge_zero_lock in get_huge_zero_folio().
> 
> You're right.
> 
> ->
> 
> * Only setting huge_zero_refcount to zero or an absolute value in the
>   huge_zero_lock critical section in get_huge_zero_folio() and
>   shrink_huge_zero_folio_scan() and updating atomically elsewhere.
> 
> Seems better?

Yes, I guess the transition from/to 0 are the problematic bits. Everything else
can just be lockless.

-- 
Cheers,

David

