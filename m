Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E13D2C982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 03:49:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFFDB6B00DB; Sun, 20 Sep 2026 23:49:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB1226B00E3; Sun, 20 Sep 2026 23:49:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9FBA6B00E4; Sun, 20 Sep 2026 23:49:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8AC2E6B00DB
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 23:49:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E6EF340555
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 03:49:46 +0000 (UTC)
X-FDA: 85236390372.23.E6FCC29
Received: from mta1.migadu.com (out-239.mta1.migadu.com [95.215.58.239])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1E8EF180004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 03:49:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R3djp9Lp;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.239 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789962585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=28SAODsjBVAdEFNL/DREIySi6dVovlUoxUjNe7E0v7k=;
	b=opClwJEwO0XeCbytSn0qURlhLghs6rF+ps0zz1JvqbYzkew/6JyhhrsLM8xtBEKGVKDe49
	83YTVCQIEfodiGT2iheYujnltrEq6i213yDLKVJjmne3cNLIASKd1CExwN8Vmdzi/IN6jP
	P1861dvNmLYxChHbNsy32l/vkKmOv9Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789962585;
	b=QaURoSRYbEKXol1lVeZ1NxAI8CiEq32pLjLxAizUR/uqUb1Q81Aul4Yj13/89TVSr+nOvE
	alfs7xxvI3Wwq0syIzPHcgr2cunAZOFSDsoRQ71reXq6IwGrCZVQmhn5BgnAFkMu8Syh1e
	dJO8k8RKjeMHjNsFIRe38rXwkNECEoo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R3djp9Lp;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.239 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=28SAODsjBVAdEFNL/DREIySi6dVovlUoxUjNe7E0v7k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789962580; v=1; x=1790567380;
 b=R3djp9Lp6q7p1WQW44p6wZoyKGyJN0bqYAZSySR1ojICUXRB2S1cozr2bAwNFJhz4iN3zIf3
 vX3oEkH4Yx7LZ1g7RMkzlXW5dBE+cBtq376DVzzzUpqmBWzUsJDJd7Gz5LwiPbIzWxTMLoDl2PU
 kEmUhQUTmSbSfTviXpL/KLeE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id e91057e5e69ad459;
	Mon, 21 Sep 2026 03:49:39 +0000
X-Mizu-Trace-ID: e91057e5e69ad459
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 1/6] mm/sparse-vmemmap: drop VMEMMAP_POPULATE_DAX
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <95d326cb-ebb4-492c-9062-5d373609e18b@linux.dev>
Date: Mon, 21 Sep 2026 11:49:23 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <6479325A-E6FA-45BD-9392-262E71467EDB@linux.dev>
References: <20260913083734.86802-1-songmuchun@bytedance.com>
 <20260913083734.86802-2-songmuchun@bytedance.com>
 <186ee2ba-daf3-4120-a3e3-101cac1ff5a1@linux.dev>
 <4AA6C66B-0FD8-49F3-8447-959A3E438FC2@linux.dev>
 <95d326cb-ebb4-492c-9062-5d373609e18b@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: mtt51zg8j6eedkkn93cmh756g8f57b77
X-Rspamd-Queue-Id: 1E8EF180004
X-HE-Tag: 1789962582-165531
X-HE-Meta: U2FsdGVkX19sqNb5zFfschWPX+/ZrLsTnCDf9S4yPSExKGqh4u14flhk/q8TKyIn5VqV1ejrmR1BHavvCnk0LCUVgYOAO30Ngc69CSqL019QzLHZXRDlMycTSBF32WF+sGkIweu724n70ZanY/GYCt3GHqWHnhDbqc3iolXceIhGcPzTYVRy93U0GsV33uedaRnruCB3rpaAv2SWYPW13Xrme8HsJpyMvpH6lBdJQPz3iEC6z1g0DZK8UI5inGkpIrneFGh1MO42DoxrXjRTU8FVPqXjXbcWTgDOpVd5dwSK6/+gALBIlcgPA6gU9viLAQ6WlB1t7yuGDq8i8cw1EySa3SMWuES0SI55TTACyAvJdyG8x/mgu/DcDoZZy/p/j3tCCwYD57bKjrvGT3OBt0/2ygYlGaWqC96hBB8aoBW5dwoulBLvc8xE122jHTwanrjcrwO2wgd0Vk9Roji5BRRDHNsvAlWFWLjUjd4OkcyqPgPHIiB937KHiLDDDfTN+TDOLhNo2a2LSzZ0GyVAhGh133fMYjqggDaWH5HTxLkJ3JbXxpt0B0xwc5P79nz/NkSdYJYOvklGimf8Pm/QkqHFAmmjW26bZPRTRPo+HmErDrF4AY1KRCG8/j3+6B9iU7R0Zf0TIdOT9nB6+Fe8mi0ED9BFzXJ9ghiE0L67Owy4avzk9NOUoGsS+UNpkZBZixffILq2epdsAHTCCdvz0HX2jM7OYBONFqyJbkW0XbHS1Nt9ewWaahOoF4SZvHl1wo+LlGdVkzhzhmkrzPJ8ogKqJg5hK1xp0eceaI7Hh3pBJ4o3T2m7IRCrmZuASXpPlw1tlIxmAi2RJu/TtNQ87Yu6awCpSGGb2nAxkuOowf5zZjraT2hJmNdLA/2UO8PB4Foi6tS300021v0GBylaZn99Id846fgrOaW5gzfLOVRmEcpo8mu1atMY2QYuHEY3000q7NrYenJ7xB/Q04R
 HZFHSsc2
 Ic3do8cHhjdgPpUpw2D+PYAncoRh4y/5exoRITOKMUsyfQONbSDVXvad9cUnzaa8EV4NtLk4mmlv/RjFDK4Rs1oHlg/EBVlcAeAfMpQWY66RhrdgH/s+9NqFdpsL3dt1FIMdknk5foT/KetD4x8lgWzItK6vlqD4JEf5lXNDizPQw3zHujCEXQ/eaxRdzojsZFJNtS40JsokodTP8DUX+Rg7mD0cryxLiDLmRjxdxmDp9/0uYu0Ze66z8x1KEqG2AS69o/uSyBCRZ44DhBJ9V1emHfO2u+vaj2WrFhutqgbTBMNLdDSyU7dxIiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 21, 2026, at 11:43, Qi Zheng <qi.zheng@linux.dev> wrote:
> On 9/19/26 10:07 PM, Muchun Song wrote:
>>> On Sep 19, 2026, at 22:01, Qi Zheng <qi.zheng@linux.dev> wrote:
>>> On 9/13/26 4:37 PM, Muchun Song wrote:
>>>> VMEMMAP_POPULATE_DAX currently distinguishes DAX vmemmap population =
in two
>>>> places: it keeps allocations on the normal path and takes a =
reference when
>>>> a backing page is supplied for reuse.
>>>> After Device DAX switched to the common per-zone shared tail page, =
both
>>>> conditions can be determined locally. DAX supplies ptpfn for every =
shared
>>>> tail mapping and requests an allocation only for compound head =
mappings,
>>>> whose PFNs are not optimizable. Therefore, =
vmemmap_optimizable_pfn() alone
>>>> selects the correct allocation path.
>>>> When ptpfn is supplied, the caller is reusing an existing backing =
page.
>>>> Once the slab allocator is available, take a reference for each =
reused
>>>=20
>>> Does the availability of slab mean the buddy allocator is already =
being
>>> used? Could there be a window where the buddy allocator is =
functional
>>> but slab hasn't become available yet?
>> Yes, because the slab allocator is based on buddy allocator. But I =
want to know
>> what's your concern here?
>=20
> The goal here is to check if the buddy allocator is ready, but the =
code
> actually checks for slab.
>=20
> I'm concerned there could be a gap between these two:
>=20
> buddy is ready <-- gap --> slab is ready

There is no vmemmap population during the gap. We don't need to concern =
the gap.

Thanks.

>=20
> Thanks,
> Qi
>=20
>=20


