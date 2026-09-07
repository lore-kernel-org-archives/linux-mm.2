Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B27D5C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 12:36:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFDBC6B00A0; Mon,  7 Sep 2026 08:36:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAEE76B00A1; Mon,  7 Sep 2026 08:36:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C46A6B00A2; Mon,  7 Sep 2026 08:36:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 727236B00A0
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:36:47 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 070874014B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:36:47 +0000 (UTC)
X-FDA: 85186915254.17.D5DCA1C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 54077100003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:36:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oCmkiCjG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788784605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NiAfvUfU16Fbk/i6m8tmsKk9M6uO5GP022sgVAPPefA=;
	b=1oVzvrNbvWaeacXkTKX1Ehi83tfkxBK/+ilsbBu6kla6udBItmvPNzXvjson4dGxSLaLlx
	bDb8WzVuPka3XrqAiW13W35/3k356g5dPl8tS5wusFuOIRg2915F5oV3ruehWzInoqPBrm
	nsPDhjZuOdvVDfVm9uh6BMpNIkSGhPA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oCmkiCjG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788784605;
	b=8PpmoQqBdyINWXTJnNFv1uSp/NjjJjoAPcU2KLRCJOy0Wumzf2Zzdy1bafyfdZfapUtG+i
	qaWcXuXuXVMhzwjeFLW8OwgYdx2tDO++r2tPpSnyMwze4uuc9+RUra05+TU64DpE9F4FNE
	O5OizhcWDKRy9SEyhWgKh6yg6llziGA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6BADD601F9;
	Mon,  7 Sep 2026 12:36:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2ED1F00A3A;
	Mon,  7 Sep 2026 12:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788784604;
	bh=NiAfvUfU16Fbk/i6m8tmsKk9M6uO5GP022sgVAPPefA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oCmkiCjGU2CzuKmMRmxVdk2YPKXOh7BCzakTnHcrwrmNMIA57A14Z+iJJy/7rw6AI
	 lcS3X6cWk3xhYkfT9k3yWTMd6RyC2t6wVdQvSVs0f4uzcERZmptdtUaaedlgrNDKtJ
	 I/ijEZiV9jJruxmgPfYEwfFEOfuZLSif9+Ky1LNvzaLpFDUoqPXulExLJMB8PeWNwZ
	 zgSnmNNSBjGOnjMRYLiadlvxZBGD/UaaIW3XQoxJGMEO7NS++3maj5EngPLv1Donsw
	 V4c9YRRekgmQA5zdqSHxRxmGVad8RRrixthi4L6AFd6XAOswPHhzBLNvCD//Mz9kS2
	 jfupjHBbpRS0g==
Message-ID: <6e85fde9-9314-4854-99fb-3582b13486fd@kernel.org>
Date: Mon, 7 Sep 2026 14:36:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/18] mm/huge_memory: move anon_vma and filemap
 management into split helpers
To: Kairui Song <ryncsn@gmail.com>
Cc: kasong@tencent.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Shivam Kalra <shivamkalra98@zohomail.in>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-9-9b43f5163238@tencent.com>
 <acdfa561-0690-4c78-bc50-92d308f4dca0@kernel.org>
 <apRHC9Hk9Ve1gO0o@KASONG-MC4>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <apRHC9Hk9Ve1gO0o@KASONG-MC4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 54077100003
X-Stat-Signature: 8wmirmdwtu7npmipqox7x4e9jxiuednd
X-Rspam-User: 
X-HE-Tag: 1788784605-219887
X-HE-Meta: U2FsdGVkX1+EMoONcIQl2TyJy7ZDfL5nJsx9pFJ8S5SAQwhad9EXoHRNc/KJaxm+m73M0S/ctJEChoJw8/YWwuBnsqu4FFGZMWEwS9Tg9I90EuA7iCerL45ykS4fOjEV783/vy2Kf58Le9O7QPTKnDQL2iIsbEZ1NKxC8gfN6ExrxAxDINTfTFn8d+vicrFu6OoVNMC3Ui5K/AA/pmj0unVd/NoXNqZDV76Uha74Y7WvuxA3EIcQRGrREMOKUHPl49k/RqmBH3VP5FaEtMp9SQI1b9aZBRe2DsGy6rqZjGdxr5F+T6GZTI1FjVS12JR7qItkOGSchsOGtO3RAYSc8OBZOSC7dS6rWrQ9crUAcO7KyarcrXe23hDWmZhMtr+ExALTBVHsEJ+CyB2ZM7CxjjCMxI0OukrpCbiuAPi53LeuLKOm8k8Qkp55BAIIG1hZ/DfWeDLqJv0mzyIg2/CCJ7L2de5z2bxDWnfRF7pGJzC/WX6Qh1bkLNdzBg+zIe8xMSDNRScuF3hNn4kAlYpINHWJPtQVoyb9R6IyRVvUseHZw4/wO0Z2UFKvdpuN61sO/iQds7Kte6CR35c/HzH6b9CptKH4HvejfWRMzMRW1IfQ9NjgVgHK+gp1S2eKtKjXAII75gxj3+13ppdLdM26mJuCl3IpcNZ0qqfliUwyS/Bxa94tlNQbtG36MVi1PKb0009cnIDtKhCKZSmD0x7oxJCiLWfV/TUwTsc5o9XrVxDa3aEMtwh9C3hMj4pXgrpQaXpCF+QsB+ef5OKFZq+QZPM6pzrdINOGP343K+YiFAb4zuQFFSz21TwAYeo0jFsveTlbvgsTKDnjF967I88yr2i0peOKrfOWhcdbOkxLeYdUvrjmQU33csDf7wEgffQRq+psoSmreXsNna0t1g3aAXc5M0MjKQ14G9ol1RNoDU95QVhodbjyOo4cDqXzTiEDl7TWc32WVOgeS8h00sM
 HDqxsn/O
 TzAABos3jzaZqhQ7Wt8QbH/naW4GGVdBO0gPz5S2cQdHCeNcQPsEltPO9HVDt4IY6Jc4P3FLFS87SrjlFzwROfskZjKjSMi40YO9zQKUer5L2Hy87KaxE2ANmQfHwjkotMHF3YxPk9uCMaV+Nn9+PK3x1cdYrAZzFt48stEuVTfcsyOjnutJA/Q+SqBYO/4FVjBDlZyogVSM0L5IOdk+1wMHLbnD5lawghqNbezzZnUg+5c9aJUbHTH2lVcETbrX3DntECjU4UKTv640UqZQNDqTSgmoSjykEM/7xS0Kqi8DAtTaYzZm9B+miflQDaDFnwsmrZ0vtHshHhqk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/30/26 17:23, Kairui Song wrote:
> On Thu, Aug 27, 2026 at 06:36:18PM +0800, David Hildenbrand (Arm) wrote:
>> On 8/20/26 20:55, Kairui Song via B4 Relay wrote:
>>> From: Kairui Song <kasong@tencent.com>
>>>
>>> Only anon split needs vma info, and only file split needs the filemap
>>> handling. Move the related code into separate helpers so they are
>>> genuinely more self-contained.
>>
>> This patch seems to do more than that, like relocating the
>> folio_expected_ref_count check (and duplicating it, which is not so nice).
> 
> We can keep it where it is right now, but this patch is moving the
> anon_vma_lock_write and i_mmap_lock_read into the two anon / file
> helpers seperately, so keeping the folio_expected_ref_count check
> outside and before the helper call will cause a potential higher
> false positive / negative rate of this check? Leads to unnecessary
> call to unmap_folio.
> 
> How about moving the folio_expected_ref_count check into
> unmap_folio since the purpose of the ref check is to avoid
> unnecessary unmap? No more duplication that way.

I think the crucial part (for anon folios) is to also check after we unmapped.

See __folio_migrate_mapping(), where we don't do the !folio_ref_freeze() in case
we tun into the !mapping scenario.

-- 
Cheers,

David

