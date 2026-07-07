Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7519AC43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 07:05:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61CFF6B00B4; Tue,  7 Jul 2026 03:05:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CD4C6B00B5; Tue,  7 Jul 2026 03:05:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BC466B00B6; Tue,  7 Jul 2026 03:05:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 17E476B00B4
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 03:05:00 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8392F12033D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:04:59 +0000 (UTC)
X-FDA: 84961093518.25.CC7FF35
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id A469D12000D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:04:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ecTdmXvb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783407897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rn/9LU+GQtcSAga8Zs0rlzpZT3fZBiZfoTOsbmoDN2A=;
	b=3HfXgHE+p95XTo84i5jxIAjZbMK98G2FGgxr4ombm9YKSNF2b8qf+kI33tURUD89V/H/qf
	CoiV/7SALrclMtgGHZLZm4Ibj1tT6CdbIjn2cQhRMh0YxgcDGDOhhLlGWj5py6wl5TgujY
	mXrVTIA+4V+GxtcDvJwDLOOMaUgVkAs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ecTdmXvb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783407897;
	b=m4lp9PYWjDmefpMf2wwyqXug34Q1zr1ur6IFK/+yZnkezS0UTAxm+om2YBQcmV6EMD7Kt3
	GFJaiZCvoHZjhx0IF0y6uUrGHF4KZTxZ9TRA84ltl5tqduiwxnS6ocRrrhHa1uG3bWhBY0
	DeyOgVsbenBlOcwjCYjbNb6MiPYcp4M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A74FD4391B;
	Tue,  7 Jul 2026 07:04:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068D31F000E9;
	Tue,  7 Jul 2026 07:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783407896;
	bh=rn/9LU+GQtcSAga8Zs0rlzpZT3fZBiZfoTOsbmoDN2A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ecTdmXvbW6l67Xr6a3dPQdcwSbUTUoIqu0budd14MeJe6VpH0PW8vdISsjwLbRtbi
	 hVKjiA556BCVWoLyOZK9AtFTz/WR1rqY5yzrDV4vC2Mur8cHfCecxDkNdLtYBB56yH
	 tF7YCn08wwUMnu0d/jPNLqxOpZheh/p36Eu9N8f0GOW4wb5ECZsClY0rQMmTg1S9KX
	 h5fT56mpap5UO1tj/QxNWsarB6UlOMaxk8KgaG1R7mr8AFwqBc6RAs7VWgaKvvxKDl
	 jtsWPWYDNa2ULcyAvzuPi3J4v/qISoE81jRWoB8SIgbIpq4wCUM6fsQ/1FHBhFlJvT
	 VBwjU+bAXAIzA==
Message-ID: <2e749bbc-86d1-4a10-9809-4777bb5061e7@kernel.org>
Date: Tue, 7 Jul 2026 09:04:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: migrate_device: fix pte_pfn/pte_dirty called on
 non-present PTE
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org
References: <20260706111958.3649651-1-wangkefeng.wang@huawei.com>
 <892b2a73-4dbd-4090-89c5-46929530b855@kernel.org>
 <9beedaa7-0896-4aa2-810e-26042476e7a7@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <9beedaa7-0896-4aa2-810e-26042476e7a7@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A469D12000D
X-Stat-Signature: bn33c4sne8iccoaj5fy98kxxr3jy8gqp
X-HE-Tag: 1783407897-477977
X-HE-Meta: U2FsdGVkX1/joqCBVw8OrreXe7PAdV++s8QypA3bd+pWhIkYbNOti2WYZzsW+kPqaWMwD0ByliKPSakSUXhdf29P+QL3tqQghL3XDhzrRSG1VRIChfhfjRGnMKWMg6hSZXMeVO+ooD583jfMPkvys0pscNJTE8gb0s6uEh8Z8KzC/EGZDdoJ7rkMlFM9C+RekAezpASSgM9XhKQh075d+TDTOVcNtVD7zDUQBqsEL/hyEsmUzmv665toKaAWee0b1aMoofqVF4PuezFmqDqFPpZ4BHH8diDA2bqO8Sxu+HZMUvjuwkBAvsDhGkyd2MsfygkOdVDkLzUUXgDLPAOL0P3bPaYhiGx9++VMr1ncA48Ckr55BbK5n0KerSvzepgi+RHgierw9RpjKS1x+3jRy1IsNq2kHO7xQ2if8CEpATIPpxNHzA/7lFhYY0YCnhF+X5yxgeKOp07Dvlo+pOOBc2mQlS1xZWVRzL4g7uOR0TngMaN3hud8DDo7MWgqEPb+TEF6hyzIXWsnmorapGJIiLZqoe0VfTuoPDIIaJP/IeSeXvfeheaKnEEK5n7iEcf4i/S4+mc+qyj6nkKv0v/90JKg9qROunJzS6cSzdYzcrFosJIT8Yck1S+3WzpP8m0QBGpxE6z2TVOzVapwHYWa0GGInNxk9bI6bU7vGknIpwpF6UBDsC2YXFZW2wmNHguRDL20iLpCGTlCG99lpj2lDsmfDZQddSwwwl+FugdIncLw5qoSSt3txRkFKZyLJNWN5crsgI/tMrMkQkXhcg9oNTpUIOp5DPFpdNxOk6G2pMKzW7ekC4YU+xtS/NDPaTneh+AxV9YW9UuqqZiZ5ORCOYK3FqmDBVgvmJfkUNUUv72s9aLrx+f7fraqd7obBoqOvg2K+YN8kU91ff9O9eFxHoEHwkxNthA4/osLSehzIxwIHRjqzuqKQ5Vdfr9Srzoobm8eF7+XxiSD4Bx8xke
 G2xy/lk5
 Cc7/jZ2yoDt0mwkfPv3xZN+UNgQuO47Ai0OwaFBnKMW9orx9H2oV05MUG9JPcWqg/vRL6GxDAYQSMMn/9zAHEfMAWNMSMep5CTnbgOFKBqViQo38a4Lov5BGquUESdX6Jq3btkaPY9dCfPk9g6D/3BTgP7TymHxGK9FAPUBPaePylDQ0byr5QAQW4tavOIF509zpcyN4X0h/2yFfJ3eYTwjavYbIWVAVZIpPUAJRiajBVraEeMa/QeVTOthPbvXPaYhR8jMatsTK+sD9EudThJR2GjBfLgx+E5U81xLAR97Pv2uUNOI4X4uZlLz+Bk5KSk2lvoUD+WsFmuSTXSO2r3R4txbc5aie5pV+49GzB5YG1eDZN/jxux3NhkQ4LEYwkAbjxOgjZ3wMjzMq4VUZ2NF0gvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/7/26 03:28, Kefeng Wang wrote:
> 
> 
> On 7/7/2026 2:30 AM, David Hildenbrand (Arm) wrote:
>> On 7/6/26 13:19, Kefeng Wang wrote:
>>> pte_pfn() and pte_dirty() have undefined behaviour when called on a
>>> non-present PTE. In migrate_vma_collect_pmd(), these functions may be
>>> invoked on non-present entries (e.g., swap PTEs), leading to potential
>>
>> Certainly not real swap PTEs, as the previous function handling is
>>
>>     if (!pte_present(pte)) {
>>         ...
>>         if (!softleaf_is_device_private(entry))
>>             goto next;
>>
>> Only device-private entries?
> 
> Yes，device-private entries.
> 
>>
>>
>>> crashes from pte_pfn() or incorrect dirty folio accounting from
>>> pte_dirty(). Fix both by guarding with pte_present() checks.
>>>
>>> Fixes: fd35ca3d12cc ("mm/migrate_device.c: copy pte dirty bit to page")
>>> Fixes: a3589e1d5fe3 ("mm/migrate_device.c: add missing flush_cache_page()")
>>
>> I suspected device-private code, but indeed, these seem to be added afterwards.
>>
>> But a3589e1d5fe3 only moved the flush_cache_page()? So that one seems wrong.
> 
> I couldn't find a more suitable commit, before a3589e1d5fe3, the
> flush_cache_page() only called under anon_exclusive, not a device
> private entry, so there is no issue. This is the reason why I chose
> this commit.

What makes you believe device-private entries wouldn't have PAE set?

This likely goes back to initial support for device-private.

-- 
Cheers,

David

