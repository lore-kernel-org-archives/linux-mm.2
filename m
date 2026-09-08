Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4235CC79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 07:46:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5152D6B009D; Tue,  8 Sep 2026 03:46:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ECB16B009E; Tue,  8 Sep 2026 03:46:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 402686B009F; Tue,  8 Sep 2026 03:46:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 231B06B009D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:46:31 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A8765403CC
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:46:30 +0000 (UTC)
X-FDA: 85189812540.30.E620C62
Received: from mta1.migadu.com (out-10.mta1.migadu.com [95.215.58.10])
	by imf09.hostedemail.com (Postfix) with ESMTP id B64CA140005
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:46:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TqNJeRfn;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.10 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788853588;
	b=5X6+rrvLgf5Qns0l5eJULQdpJx0zI2SvSOmRWGGq4RrumKCLCtNBlMHAsNL//2xJ6X6fUW
	MvoaQPOOrnW0DX70EWYys1uQVf5E+A0EsCm0ZnN0fj8keTXk7sYaAtDx7dROYarJQ6+beA
	vGqNQOivaUrJNAB7HExDk6GkRDgJdAI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TqNJeRfn;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.10 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788853588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sYYxiXN+Hb8rQ6JwFenQMkWjeUMFgmbC7eP4OQjvJIM=;
	b=fYndhuw0ICEDVNFpL9/nDz+Y+0cuhjigN/GuYb4ZqjSCeFMFRl607Kxq1GBhe+269zCLct
	AIhue7qgMRmnVVjeRIv7dv0uJYYuP9VdvQgVYG53McPhPR0yfED0FDUgFxQuX44aau9MAr
	FfoHQWTFAvvdY654iAwREkoAs6/JqhM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ixBAYP3Du6CsKocLljvRGfCjKPRhF0PCatiq8iaNJ/Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788853587; v=1; x=1789458387;
 b=TqNJeRfnlPGt5thwILWmaRYK8CK+vf+m//CuibP3MRNHd5H0PlyhI3O8jUpMHnmAmBK5/9yV
 35l41r+H7hf2qvrP0IJEhjF7O8US4lpcbNgsBYUezkwjfIbFonFA/PrdIN8FC7jLO1PT5LfGyaR
 DOBKDiFjjLdhdg3R9MZXdFpI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 539c04568d93ce89;
	Tue, 08 Sep 2026 07:46:17 +0000
X-Mizu-Trace-ID: 539c04568d93ce89
X-Migadu-Flow: FLOW_OUT
Message-ID: <1fc41803-a0b3-48ca-84a6-caf965fb11f9@linux.dev>
Date: Tue, 8 Sep 2026 15:46:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/11] mm/sparse-vmemmap: switch device DAX to shared
 tail vmemmap pages
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>, Randy Dunlap <rdunlap@infradead.org>
References: <20260908030335.96549-1-songmuchun@bytedance.com>
 <20260908030335.96549-7-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260908030335.96549-7-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B64CA140005
X-Stat-Signature: brmhurgzzapfimrf9wu73uzkffdank7i
X-HE-Tag: 1788853588-354202
X-HE-Meta: U2FsdGVkX18V3tfMqrCTwaqeiuHpGaxK14gk4pAmN5GIMP9ANEQpcYa+gUYZ6SAb6VJRfToORW3633PR+adLT2hue7cX2oZG/MQOlzBkb3VYbFy1SdsZ+azGHpUdl7FI5twHVoGRIjgvtQHDVBYJCzJCfEyweRNeCeqpNXXbtiEhczwUf0MBKFT5E66q0A0I7JFJFH8tm/fZdvCdt/HAOsiMj6vXANBEG0zsmn/PevM5F03w+P0KpFN0nw9/KjYGyPOgDSmUvBojEYZr4svOpSVvSyIuoxIpjjTAOQkqaM2W+kFFAwHtEzUELo8v5EDo/c1jPX0Ofu4ARnf08JMw6pLF5nN/32xs5EjErxd8zOnKl+LZmFRwbSWF5MX91dshVcebLk5oumE6ieuRo8cRb4JKm6//Heb7hmx21VPR2Elsbw2CgrEZEgMaiCT7KhxviqsGE+jcMCnhRoR94Q/w3OEN5iwv6skjhN+/uKvNdbSpKxXHoWFli2ELbzuQR5StkwyfvP2AEBDBziN8b+wvtzdZn7unbarmqG40G08xUW7zyssB65zgD3U8uWfporF6ruYEXXuvObBmfBfGUe7nosJRtOUynX4z0Xa6JAzjIUgvU7zbqr7+qc4N8eQsMnJmVNOnkwY8KLloAxAa72JIiyR/n6BhYxhnLyhVbGunMJijC3LgmOwx9KzVAvSo/CSoVDUPOpeDDuIl/4i/C48742F2bg7Nfc6t5RTe87QZQ8rN+5snSAzZ+GOhNF5MwUqr4uGjrpf7jL/1dexO7gPAHZZ9wXiM49ZTAxHZ/jrGcreK2ZTxAt2K6vjJjcePsfEGvsE4xyEH0M0z/Om8cPzyJOGyCZpr8OMboGXK+Pxf78DBzfWOFX+HEfzIJiJljZ1S5V/446psw4nR6eRjCznKwRAUTEhUXwdRpzPBG9BblDWW9PiI7YrEm4x8DQmP/uWaMkjrDCMhUUiE9M69azF
 FQffgSxO
 6zbAj4vLZUneafKGuKwdQQwuZWbMMOJ5SV22EekocN+ZL/qoM/xn7vwRPm5DOY1Y95dnywyuOvNUNseUOlCuwDWjIwnc2zogD7Xx9lW69S/HeNAexq9XHqRySh5/qOqjfMDrh4vG/wRfMZY1wFTsZvDhSqe5aGPAj2wUDL6I7GfRNo27kbc0+Ck0hvXohxXe5QPagG6DRQHQ+1shJ222027d8mZNV67kg6frRT1D2aA18S35D5MoJ6RIKE7u5izc2jOCr/TSV60cH3upvcYn2upWUhhhjJUwoxaqso9nvTtgJRMeIUtaBmYqkpNWTIDoYJ/ZDycYVNRaqK2c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/8/26 11:03 AM, Muchun Song wrote:
> HugeTLB vmemmap optimization now uses per-zone shared tail vmemmap pages.
> Device DAX has not been switched to that mechanism yet.
> 
> Switch device DAX to vmemmap_shared_tail_page() as well. This aligns DAX
> with HugeTLB by using the common per-zone shared tail vmemmap page.
> 
> The optimization is enabled only for DEV-DAX through pgmap->vmemmap_shift,
> which is assigned when a DEV-DAX device is initialized. Unlike FS-DAX,
> DEV-DAX does not modify tail struct pages, so sharing them is safe.

Got it — adding this description makes things significantly clearer.

> 
> Since the shared tail page can now back ZONE_DEVICE vmemmap mappings,
> initialize its entries with PG_reserved for device zones. Also skip
> poisoning vmemmap-optimizable sections while their struct pages may be
> shared.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
> v2:
> - Explain why sharing tail vmemmap pages is safe for DEV-DAX
>    (suggested by Qi Zheng)
> ---
>   include/linux/mmzone.h | 10 +++++++++
>   mm/memory_hotplug.c    |  5 +++--
>   mm/sparse-vmemmap.c    | 47 ++++++++++++++----------------------------
>   3 files changed, 28 insertions(+), 34 deletions(-)
> 

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi


