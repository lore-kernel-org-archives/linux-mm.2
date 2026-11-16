Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E6F2606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 03:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=b6y5pjZT
Received: by kanga.kvack.org (Postfix)
	id C68686B00EF; Sun, 15 Nov 2026 22:15:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1A7A6B05B0; Sun, 15 Nov 2026 22:15:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B08476B05B1; Sun, 15 Nov 2026 22:15:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 83ED26B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:15:46 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 836F914052D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:15:45 +0000 (UTC)
X-FDA: 85439517450.04.9761D71
Received: from mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4087280005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:15:43 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b6y5pjZT;
	spf=pass (imf30.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.185 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794798943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=61hA4pI6lWNHs1Ny06AZoS+2gE8bk9pfoV7wwfpwYLY=;
	b=GykIvh7rgh3IQOdT98WYeu0i5ZC9rZCqL5j8R/c4A2qGNY1JDiB1ncG+xgDYTMrb7ReH+4
	Ag2moMt5fqoPvG97rbnwn3KUdSmgT+fwEEsruMstlC6CowsGm3/xTp1StrXxnoAkQnkgOm
	zozs0FSE90lanKRfA8NLGKD+r7EzwDE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794798943;
	b=5oM4Oq5YgBTaSnPLda/Yx41+jlWbNNy4QD2caM0vCTn/WBTVlTou6AYTyOeJbZv9QICzNM
	zz6VrXIs/03/LMtvpcDWXQJ5NRdICL//lfNmFiYdMVoLtO5HnF6FxLGsZHdu2HfIBrFe1F
	TzrBmvWbbu5L0I/mJ3sK+qA1AmqlHCk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b6y5pjZT;
	spf=pass (imf30.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.185 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=RUdXcvQAkasOinh1aHVDzx5Sbf8dYEfIHFE+pPtSAf8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794798941; v=1; x=1795403741;
 b=b6y5pjZThx7DYDxGEYNfUyp+U3/xosaEMZmj2dCioSZXgrycZsMsMAUAuW/xB7bHrCC6ul7F
 9ajzKA3pNWSWmGKecb6G6We6VuI02BRbHXYzbgsLhXKuTqXrA9aqLfU8wfztFqNfoahP2KCso1W
 Xp6Tjkb4pnM2yywUCJeoV9ao=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4346fe518fa13606;
	Mon, 16 Nov 2026 03:15:41 +0000
X-Mizu-Trace-ID: 4346fe518fa13606
X-Migadu-Flow: FLOW_OUT
Message-ID: <5d234178-7799-4603-82bf-40a70101f78a@linux.dev>
Date: Mon, 16 Nov 2026 11:15:24 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/9] mm/vmalloc: BUG_ON() on an unaligned range in
 vmap_pages_range_noflush_walk()
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Dev Jain <dev.jain@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org,
 Sashiko <sashiko-bot@kernel.org>
References: <20261110112546.261415-1-hao.ge@linux.dev>
 <20261110112546.261415-5-hao.ge@linux.dev> <avWtB-nWZUwLdQdP@milan>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <avWtB-nWZUwLdQdP@milan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: i4sd1xaoywc11jeuqh9mqyyua1583ae3
X-Rspamd-Queue-Id: 4087280005
X-Rspam-User: 
X-HE-Tag: 1794798943-995162
X-HE-Meta: U2FsdGVkX18DxIzjGtFKVZsle4aPl43dj2zrpwp8vB+GzIdCnr/2RvLxygx4w/j3zyvN5Nc0EiERB3Rz2DwvNXRY2wvIja+0Fez7PUybuNJVQqtfswnk/oHlVaPvV5lALvy7mr0MmAXWseauOoUNAwYRh2wzuS5p43TmIl8XFVAQyfx5DeCyySMABP7J3pCu1rlGA8DpSEfIxDJK3QqCa84BCULnKH2cQX3B4J6wTUFrT22FxxQJue2hjYojA+l9wvcQut7IjYrVlTY8SZeq1pv4b9rqEYamiRfUoZDpXrDND0DO7NLVnMJDNHgpxnA/uOELPRiy2ANLa45QNFmCPVrraAVT0PVWiZ//kfs7lGBWJkcRaCIxyxRS6aoeQJOhd0MSmubhBqwnSdrw8rkWf0jZ79gptX0CPSMZRgQcd2rCvClajIe1FgqfxAc6VN0SAj3+y9KLSqzoNoTBO2iaH/SVUHZYeS+dFXj5zBtEZz4IulXwLDL5KunZsr0excpRiajdvYTJr0QG4Gi5QOQcxCLtBYzoJB/c+4Ugvg8gKXGAxqxuw82hgO/xemscyxp8nBcN60xBrV1/POSr1rxO/q7QjXYkeMzv55nFldANDUQ6jqLjRkXjtkGkttyzptQnwo5jj7se6KKjRnSa/JgeWDOsT7bFMTP/aUOrbkStyYuaL0FVI/MuRKg1T9PWuKGNbHbg30sy6abw51IGnlZGoDLC45ne649apmcGOzzWZPc8aG+hU9EwjKxIBG+MfYgwNOzFJR46CkdLhFpSQW7ig9lcgsbUGtTNp3jHxZ/HOzVCMvzBrtkvJFX/8zq1G3CvaiBunWmFxrsXSTiyOapOaotAAX28Wx+ief93D21fFukQiegbnk4g84rIi3BQH5W9bbWwF44Lcg5W4gl6AueS/oPjwhq9STJLu1faRKuI7ygnX4WTPbTkskF/zvsqL7Fq4/7bsTcjoB0Nqh1U29B
 6C+Sgtlt
 P97bbgfzyw1QTa/4w5q2MR8PfOp8pvWkq34vIcnOD08p7emKIcC38PRZBeOT+O6gYyZGqn82FqCy3hFWgHGkdVhWdBCogYbuh8AZbHXxGCpHC+Sx+hk2VaXlOF2CzateQKWtRTwYd7sZ5GfQi7CRPlQdonapJUNhfc7zfhsQmX1+y4wiiYiQN4xDGAgGTSLWilgFm9lIJ7M3QL+BmI4woOlRprSDigHJF8s2oOqYhOQN/3zd+cMe7RhtnjKHw1uzpDeHMCeZT1hQ7vayls4FVRAt4wYWa0/mMrR0OMpmM2udn4KRFl1ZNxveAke/U1f+m+wZGFUcFWV9KcclOqwFbowZu2HeTHdfWY2owwdmQoB7gVaxIFjQTH6GHX9CFzRbiPYz8jd0BiMD831uN0aYzWxk13YeN1R58u+zGCp8+ERBCOvU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Ulad

On 2026/11/12 20:11, Uladzislau Rezki wrote:
> On Tue, Nov 10, 2026 at 07:25:41PM +0800, Hao Ge wrote:
>> The pte loop of vmap_pages_pte_range() maps whole pages and stops
>> only when addr lands exactly on end.  An unaligned end lets addr
>> jump over it and the loop keeps mapping into whatever follows the
>> range.  An unaligned start maps the page below the range with its
>> first pte.  That corruption is impossible to debug afterwards, so
>> bug out on addr and end at the entry of
>> vmap_pages_range_noflush_walk().
>>
>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>> ---
>>  mm/vmalloc.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index 27f2674a5556..86fbb1d2b27a 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -698,6 +698,8 @@ static int vmap_pages_range_noflush_walk(unsigned long addr, unsigned long end,
>>  	pgtbl_mod_mask mask = 0;
>>  
>>  	BUG_ON(addr >= end);
>> +	BUG_ON(!PAGE_ALIGNED(addr) || !PAGE_ALIGNED(end));
>> +
>>
> But why do we add this? We used to live without it and as far i see
> we have not gotten any report about any unaligned addresses un-maping.
> 
> The vmap allocator grantees that va->va_start/end have to be page
> aligned.

You are right that no in-tree caller passes an unaligned range today.
This came about after looking at
commit a739e6b557af ("mm: vmalloc: WARN_ON if mapping size is not PAGE_SIZE aligned").
That commit only guards the ioremap family. vmap_pte_range() is reached
through vmap_page_range() only, so what it protects is ioremap_page_range(),
pci_remap_iospace() and friends, which map physically contiguous ranges.

vmap_pages_range_noflush_walk() has the same loop and serves the other half of the picture,
the virtually contiguous mappings, where the physical pages behind the range do not have to
be contiguous, and since functions like vmap_pages_range() take addr and end from the caller as
they are, the page alignment is the caller's contract in the first place, so this is the same idea
as a739e6b557af and the check just makes that contract visible.

That said, dropping this patch is also fine with me. Nobody can actually trigger it today, as I said at
the beginning, so I will drop it from the next version.

Thanks
Best Regards
Hao

> 
> --
> Uladzislau Rezki

