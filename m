Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F77BF41986
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 11:27:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B207A6B0089; Wed, 15 Apr 2026 07:27:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF7A06B009E; Wed, 15 Apr 2026 07:27:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A350D6B00A0; Wed, 15 Apr 2026 07:27:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9349C6B0089
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 07:27:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3C745160295
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:27:35 +0000 (UTC)
X-FDA: 84660564870.01.C4A48E7
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf16.hostedemail.com (Postfix) with ESMTP id 73B6A180008
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:27:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ChmZ18f3;
	spf=pass (imf16.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776252453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W/nLB/pOMgjoGvlQGXIaocK5El7h3zMc3A4XsLzA8T8=;
	b=ukQf+ML18evcbQ2SfWGgnGiWR1rVayfUKVD8yi+YTOVqCP9k0nijk7PGhyPR3AxIDqHMkF
	VewahKwfjxm8UekGe/v9ry7UrOOQa8yCzFx+pbX+5O8lQmEcsHrHGoFsIoTLJFPYuRgw+j
	pH5j9Y+JzKnoGXa9l92ceGu2CrFPJPc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ChmZ18f3;
	spf=pass (imf16.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776252453; a=rsa-sha256;
	cv=none;
	b=SHe8JEHheUzVDigCbs/2I2fEPCFyqwD34Z+wOyBXMLCTvPA05lAiFVJ5pLjDTv7HektmGg
	BG/jvSZPnSaN/Tkr/y+/HMIL2YEqaEWFW/KdNhLYgGiDrSI66kHi4Ei2h7LMAklvyXOY9w
	paUtsz6whseF5RSl0Lf001sMomH2/E0=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776252451;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W/nLB/pOMgjoGvlQGXIaocK5El7h3zMc3A4XsLzA8T8=;
	b=ChmZ18f3JvhbPpaEqAnc6eSjFBzi2KgGxng36eRvZ2vKerK/1Yj8VS3kTtDm5L0Igs6jMI
	lrynZAOw99WwWSciyGCsFivc8aHBV8Jso1+1485q0Ma+wP+8r+AVvzhMTTFsPPGMyNPsAw
	3Tt7FsFPBv8e3p1zdU6neMzO9SUOPmk=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH v2 1/6] mm/sparse-vmemmap: Fix vmemmap accounting
 underflow
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260415111412.1003526-2-songmuchun@bytedance.com>
Date: Wed, 15 Apr 2026 19:26:48 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com,
 joao.m.martins@oracle.com,
 linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <A5A00658-660F-4CAF-A2E9-61834A8A640A@linux.dev>
References: <20260415111412.1003526-1-songmuchun@bytedance.com>
 <20260415111412.1003526-2-songmuchun@bytedance.com>
To: Muchun Song <songmuchun@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 73B6A180008
X-Stat-Signature: 8rwokig4rn4qznrut6dgqfnpcybdms1k
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776252453-503206
X-HE-Meta: U2FsdGVkX1+WBVM538T3+hLtj+eTvUgPX/a3Ns+S4QKaxDIJG9RGuzfs0eVgm5NaDgn3EPu7Yq8VnOFNVZRvrl+ETu0FWb0TRXL7ci1EJ3dvl3HDZvd4EgIKrFJLOHkKDsY/5+1rFKkFkKM4BlHXJ0p4B9L3hdYTOkrBErRvHJ4pSQG7rifbYWkv77Nx3ba+K1w8HTBn3TaF3h2KFfBTnxkubfc0D0f4Cz0ZDkW+wjjAfbR2qBcYIZ8g1Dt/h/Es/giUxPrccgxONvUnd0b0Fvx+itmopra9VglupWNoVXkmQd3KlZLW7E8bvdmDLnGiAwgCcanzWOtYazjzR3U8rZEUY7nlpTOd9G19d2eHinqrokVM+dmsbl9mO1dUUDO0W8YZ4HLEFei7/RqPljFNl1Jo/yOODXTaYzQiqRSyUx+qnSUYcT5sUiPPf5PNnXzELNdquIl+NRWg8cAOn2plotTfLWOTes1xFGEaIhBx51LIig04TESau2UGIX61IoZcK1Mf00A/InCjY1coiJggUaZjJ7VGKMdl2Ww2238NdZV/NJ5UzHYWiKfCUV+kkqo9h3P9OG2GgdiHZAtOe5RqbQC5Z7ukOBtafvfnG/Fhrp7H3HTCrzP2NEINbG+QLvd2sZawUtC+nrDFQRJ2ttmQhsz/XshjX6evQw1iAKMDJ2tXOCgQnS6jGiIIlb2JzjeC669IPNkJC39SqaS/xNQnSRqet6ox37kPN3iC7HX+H8+0JyI0uTB23JOeFkpkwM78b3xpGJ8uE/v/b63/GcfGDKe/eOgNCm4kdud7p5FAFaxsktj4LVvGOAAH5Y0BbPrOs5hcFGDi5dTdx21H9wkceXey2OAX/WO5tQ85iDWieWek63fcActIVH+vYzCChcq0iOoee2YLMP3YqSNp0GNGh2/nPIMIWssHHeY11i8Pt3s9rpuHbJ230JNpCulJdFCeTgPMi35eEqGYsfEcfTh
 OM7q4hM+
 iVX6hLbEVsZe0cFp2CvAtRlMzt9HDTfl7kQtaJZJxArWPdLixrRHyx+L6OQ15zd3WQWG0Xgswqqyoub4HLlsToA/VCznEg3ROnMvzMlfmgLqo1imdJLLUJSvn9AnQXBCOhlP9IstzWFLRoWUWAzYIybpWsOTSgf4CU7C4cOWTqH73Yrgthon1xy5DGFURh6GkYzHzaHl2HbQVhgta0M3z2iTmE+2gOVJXT+BiDbFZqDQ7yo/NsNtBL/aFnr9pkvv3t4Ym
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 15, 2026, at 19:14, Muchun Song <songmuchun@bytedance.com> wrote:
> 
> In section_activate(), if populate_section_memmap() fails, the error
> handling path calls section_deactivate() to roll back the state. This
> causes a vmemmap accounting imbalance.
> 
> Since commit c3576889d87b ("mm: fix accounting of memmap pages"),
> memmap pages are accounted for only after populate_section_memmap()
> succeeds. However, the failure path unconditionally calls
> section_deactivate(), which decreases the vmemmap count. Consequently,
> a failure in populate_section_memmap() leads to an accounting underflow,
> incorrectly reducing the system's tracked vmemmap usage.
> 
> Fix this more thoroughly by moving all accounting calls into the lower
> level functions that actually perform the vmemmap allocation and freeing:
> 
>  - populate_section_memmap() accounts for newly allocated vmemmap pages
>  - depopulate_section_memmap() unaccounts when vmemmap is freed
>  - free_map_bootmem() handles early bootmem section accounting

Sorry, this line was forgotten to be deleted. The subsequent modification
of free_map_bootmem() is a separate cleanup.


