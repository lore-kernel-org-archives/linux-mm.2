Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10F3EC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 10:21:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E75496B0093; Thu,  9 Jul 2026 06:21:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFF476B0095; Thu,  9 Jul 2026 06:21:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC6C86B0096; Thu,  9 Jul 2026 06:21:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D1DE6B0093
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:21:23 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 138C81A02D1
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:21:23 +0000 (UTC)
X-FDA: 84968846046.04.ECBC2C4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3721F20007
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:21:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K4ZgFZUy;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783592481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WdBwou6UoGXgB1ir3Lcp2nsy3ZSLNklF3fHXUXVCCQ8=;
	b=WVMnwzra9jYaQ0tHMtix27C6DDGXAsPSJtm9r0cHuxILWoshesF/DCdjaV6TpwFvJQloO/
	oDqKrHLzfd5DLkxYSr5/frrcGEh+pJaxHhq/2wZ2wHd6h2GqPYDLCEhbOZKmjmLRZEPTDx
	PBw7n2tO4xXlnszqNgOfZ0IpkD7KZG4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783592481;
	b=oeYCjRHvQwiQZlDBJM3lVze/HmYK1QGHNrZ9jeKcN42App5iHqlccYTC6wl+Q3zEqUGsI3
	Guv6e9Y44cG29AEwbbAZIr4QjGAXvmauLoaui8kI3dBTb4q4PIFs+WIrKegVwi4U4D4ouj
	Wwbep7se/5sXrKAAh3E31phHg0Qz05c=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K4ZgFZUy;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5BCE04167D;
	Thu,  9 Jul 2026 10:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D411F000E9;
	Thu,  9 Jul 2026 10:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783592480;
	bh=WdBwou6UoGXgB1ir3Lcp2nsy3ZSLNklF3fHXUXVCCQ8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=K4ZgFZUyiFpb4XeaDDvdVo/FZUL7Aa1kY1P27AoweaquTl0F7WsR1Ox6pOhMbAi39
	 1zirrV2zmwwY4nyhmX7eq4QwcPawoSPfiKSiPHWIKGih2IatZ6QwGKS2P9vQvQScH/
	 Zcel/Mjsnhx6CNRAo97h8GT6sZLKtTSV7OATYhdSKWjtplrpI/ULy9ogNjodp1rXFr
	 LX/xJKZyMUxWN9BzcGuHS6GcYbfLjFm+Ad4h13zfSI4Jopy+i+jEF8/W3lx6v/qRVh
	 EgDC7La1B9C761sME3x57+uIsVeNeK98og68SDGwfbPFq1ki21HsSB1Hj537eSYcuB
	 1YMLNz1/n83QQ==
Message-ID: <67bbfc47-a8f1-4557-9a24-298bad4f3591@kernel.org>
Date: Thu, 9 Jul 2026 12:21:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] mm: split a couple of headers from internal.h
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Graf <graf@amazon.com>, Alexander Potapenko
 <glider@google.com>, Brendan Jackman <jackmanb@google.com>,
 Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
 Dmitry Vyukov <dvyukov@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>, Zi Yan <ziy@nvidia.com>,
 kasan-dev@googlegroups.com, kexec@lists.infradead.org,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260709-internal-h-v2-0-695631425968@kernel.org>
 <0970fec0-5c18-41e1-b63d-029c7a8354ee@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <0970fec0-5c18-41e1-b63d-029c7a8354ee@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3721F20007
X-Stat-Signature: yxh3tw6a7rf7sru4sxmex3n9cs8h8z71
X-HE-Tag: 1783592481-885644
X-HE-Meta: U2FsdGVkX19EbVdcl2kBHL35Mcp8uo7GQ9rhBCEl1u4oDYT5WuNei62GlcicYeYHAn/2Ye28yCE9Nspizj3pjEwWkBPbkr9qhEDvt5IXSLW8zgpaiyxL3Z+L1ZMuL/B4d2cA93lxqGOoyEIuYujLRpvU9uOfssCg5byiwUFeZo6rc+R7MT8dmsbbtc37EHzRM8CiP1cVx5okVDmL0KEquqxUzcUupwx8Do/WMdlobFzuaKZa1+UlwlQtdmova9E3j+ywK6QJaSTkMMyKP3BfJ0BmqY82EB+uxo8XJ2I+IRv1+utfFRVy6HAVQQ1FX4L1dOlSzyDBFX1MBKXrQGwPGoj17A4LrR4I0FvFNl3v117Mm8qFmHxVyGUWBIL2L4LUjyQYMCDEjJtVZ+JP0tRgYDJs1g0+7X7GYm/bXKkW1Dbten+D3ituHDL2YOCUobSew3Bws1xZr8gUnBoHNMYdeVLkzK5u0jCpFikwO6geRIL2Sax/Q4syjAx7fJ4lYYfG0EY88lHuJBGYAFa6jiv4yCYvZUPT+uWSqFUydm6tT48J0fLC3dW28jebdraYZi698x8nbhGvxByZn6ZH7pnKHvycmB8dAjq7HPnmy+YvQQra7B/Q7ovQAuPqbx0fTuOiSYpnxKQvO7t+tVCkGNANcYInfYyvhqPYJLIZfGSJ/flCISg76EcqxExviycUtYwLAowJ4LhOCyI0NUlz6SUCv1INB7xjzkGwFNfUpHhB0ReFOlXaxXxX39/LieLZuEn3JkbSKxFX5JAdHUwWfkvujvRkijeKW0nC50Qljak6cF+OQ+3JNiRRO1aVdI9HzGYX5smrPg2rpvoBWIkMe1TWtPZkYXoLnvt65cyjlDYXZCiVHv1yCYExFrLfpsETeNKk08q/HsnCR4dmneBnYwG2Mkio9uoo5Zr6p+F0KlhgFyHUxnCrq0yq8XEq1ZoNgZzWUoGyaH81dDL6ZkN88wG
 sIOQ1QxE
 qHpzWS8pcP3Jk3RT2tcfP8Udj3kzzgGUT3eETQa3L5bianoOZqZGNdMI2XvNTiP6OmhzD9Cam4SzDRcn7YnWO3Wsbktlbhsjj/OtTQ6oIpF0uATqM6BKWv47+dqyqxLoiR/s7eg8bus0uYV78OaIX17TmTx05vpUlJhRyTLNZfCgATV5q0LcSuo9NW5cgLQC5HAAASVjrB7BhEfca3J79gAyNQyEl4XJz5OLz7ab300Z79h2lKj0d4pTi6bAVHRtyFMkU5+ib5od81ybMSiy4n4jNNBSOt1wOkimZA+QrRV2oIGB4QE/mo7TY74nOvYBFCWSEDmRV1U5Fx5G3sil6syfy2Jm0mwx2dN5lvZhvS6FP6EFLtCX322yVNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/9/26 12:09, Vlastimil Babka (SUSE) wrote:
> On 7/9/26 12:00, Mike Rapoport (Microsoft) wrote:
>> mm/internal.h becomes more and more bloated.
>>
>> Split declarations related to mm_init, memblock, vmalloc and sparse into
>> new headers.
>>
>> ---
>> v2 changes:
>> * fix fallouts of rebase fixups of checkpatch warnings
>>
>> v1: https://patch.msgid.link/20260709-internal-h-v1-0-956d5092782d@kernel.org
>>
>> ---
>> Mike Rapoport (Microsoft) (3):
>>       mm: split out mm_init and memblock declarations from internal.h
>>       mm: split out sparse declarations from internal.h
>>       mm: split out vmalloc declarations from internal.h
>>
>>  MAINTAINERS                        |   3 +
>>  kernel/liveupdate/kexec_handover.c |   3 +-
>>  mm/cma.c                           |   1 +
>>  mm/execmem.c                       |   1 +
>>  mm/hugetlb.c                       |   1 +
>>  mm/internal.h                      | 183 -------------------------------------
>>  mm/kmsan/hooks.c                   |   1 +
>>  mm/kmsan/shadow.c                  |   1 +
>>  mm/memblock.c                      |   1 +
>>  mm/memory_hotplug.c                |   1 +
>>  mm/mm_init.c                       |   3 +
>>  mm/mm_init.h                       | 120 ++++++++++++++++++++++++
>>  mm/page_alloc.c                    |   1 +
>>  mm/percpu-vm.c                     |   1 +
>>  mm/sparse-vmemmap.c                |   2 +
>>  mm/sparse.c                        |   2 +
>>  mm/sparse.h                        |  63 +++++++++++++
>>  mm/vmalloc.c                       |   1 +
>>  mm/vmalloc.h                       |  46 ++++++++++
>>  19 files changed, 251 insertions(+), 184 deletions(-)
> 
> Sounds good
> 
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Agreed

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

