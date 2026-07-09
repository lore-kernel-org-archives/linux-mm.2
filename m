Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D770C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 12:36:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EEAE6B0088; Thu,  9 Jul 2026 08:36:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89E516B008A; Thu,  9 Jul 2026 08:36:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7662B6B008C; Thu,  9 Jul 2026 08:36:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B01E6B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:36:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D051A1C6387
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 12:36:14 +0000 (UTC)
X-FDA: 84969185868.09.5680D18
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0130C160002
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 12:36:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CsCRiN26;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783600573;
	b=rZozhA5BO0p4K1Rul4XuD5Iz224Lt4Pz7vttTBIqox98JyKxTQzm8T5zb3TqnVgr7463bH
	59snWyXuwRrAscP8g36KzgKbNqtVdbEXTrC0cCllKDCFghhhkh95W/dffQzCRXovGap6Fy
	37znftsuNs2KZ7OSfqhJa9vWNLKXUR4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CsCRiN26;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783600573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uajAih/cRQEi5P07GjUh87AJGEuGYoUB7sEFHa8VKYA=;
	b=yTu3CSepU55Ajg2yfOUqCsdca6k49G1raI+/BbZ1ul7Me+DosHAnwocJTFS+cABbddCS2Z
	SN8vZXo5OAUpxBx/qc0DvaKjwJkU2LH4xdt+QIBqjHvZJ00azEj96wxWmuax+wqEnMJb7L
	ma9SoBRNkxnGf8ZDYlrIAyqic5bKnzQ=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783600570;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uajAih/cRQEi5P07GjUh87AJGEuGYoUB7sEFHa8VKYA=;
	b=CsCRiN26DZyAILMKmd9IZQ0q2FK7WjXXpQjfSXMZbkuZSkAVVu/0giYKRI1nB6wYgl69FW
	xB9e6mE0czdXxJGOC+QhdTcFxIi6Ox/RZZvACqPluvfwn0/HDVia/wIoIBcrj8xT6/wNfJ
	HiviROy7X9Lv/cQVWxhM6qOhCc9wrJ0=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH 08/17] mm/sparse: mark memory sections present earlier
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <ak996_21b-jxYLGV@kernel.org>
Date: Thu, 9 Jul 2026 20:35:13 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 linux-mm@kvack.org,
 Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <8F2B957E-B99A-46ED-B3A3-CB3C932851DF@linux.dev>
References: <20260702093821.2740183-1-songmuchun@bytedance.com>
 <20260702093821.2740183-9-songmuchun@bytedance.com>
 <ak996_21b-jxYLGV@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 0130C160002
X-Rspam-User: 
X-Stat-Signature: qopdk96ne1amqorj16pyu13i4fn7dikp
X-Rspamd-Server: rspam03
X-HE-Tag: 1783600572-730797
X-HE-Meta: U2FsdGVkX195AP+/QfGQ1TsARI9uvh8tOdi96dgghH5jSSSYzYi3N5/Zs+anIfiBPZnvbtLcAy7HH7lLh3x/ZHCleJwYBlC9sDkWwiGsWtESs75PAwoarQnApC6+tSaSsl2Qjz0fDTO5NIXTLEJ0UxOoH4i1S0CoS4qQj/mH07ykjlH5ny1eZDhX+grABACxwR1sfiOUc3UiRsxVGlRWsZMMTZ4xNGxXzpqnDKs7ov9IRsOCXmHAEUQqrUJnpEWSm8dtgCOkjSLTAxtufH7VTk/CQB+0GPKqIqsvM21zwWt8QbqTEO3jNLTZnDOFOwiJbg653uguxCAXAmObAEOLOMGB/n2tbliH8PTJLJ6L4GDZ308Sp0t17an/BnXZHjLobXQV0TPXcKtAbwIn6dD9miXeemWJKzOsCjIjUaZh0s639XL8YREtdTRIujjmfWzYD2cRT+AHrk7qrfax2IFL/VDhb5Xl+zJUwCju3RKzqDtzQ2p7lDZ2RNuY86GKXBEzuTqIBQZ4mmoJS5GV2xVvqroCDF64oKNm0z3874Wpvd7odyjbZ88rJux/6hayV4ZFCltXaIqZ15erK1UmzHNFusFix0Bn4NaTik/Cu3y1s+cHXSwUOBwS14QSYusLi55bQYv+yWe69LljxitkRSCQuCWHJnB09YIL7SLDUEhy9Lp7pHMcUTKmmoS0+MLmKwWjCLLlVziV/l9ZRVqdFzzAERY5Nr5Swp6yXBJPvd1BXlGe+OJSYsyGhS9byDwJ7DOe9kmIkX4XFzxNSeRKFoSgYE+zsuIgVx0tugJaAqgguKXr7YrdDhdY1wKdQyoMT6bw1qp5Fu67EzVwSzoUY7u2vDIcXuBtcILkd3DxAFokKHlcRHMooSr8SOlb7KwYOa390pLHAMCxHKbeMqAomCIAudpzvzjpAzjbFQzvC7yOC/cCDgYGcjFbgMyMVrZsxwVKC5spgwcYwvP2sblktPJ
 6T0ZqMTV
 0hbpQV3XEpspu2kYo0jQVcvX4xYwqGQdZamxYogBVM5raqnNusNTGLXG0QHLHPoDrMbc5hA4/1J3wDWMUqGycksB0ObtxmBIObGQNeVRIPTrTRueqvT5TNXfKRNDOz2V+F+6de2ACRPGJU4aSMajtllIASqIOValHiYfvgNL3O4cUwcTCF1HSnKHexlausqjgoXJnbDObsL+8tYCg1MGyjh25LFViXu2FhPkHGeL/LGvhQgFC/zLAtEPQqs3gdVIQ/YM01vDXugd5P2+E1M8AojLM9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 9, 2026, at 18:54, Mike Rapoport <rppt@kernel.org> wrote:
> 
> On Thu, Jul 02, 2026 at 05:38:12PM +0800, Muchun Song wrote:
>> Upcoming HugeTLB bootmem changes need sparsemem section metadata before
>> the HugeTLB bootmem allocation path runs. The memblock ranges are marked
>> present from sparse_init(), which is called too late for that setup.
> 
> It's not only that memblock regions are marked present, but it actually
> initializes mem_section's for the present memory ...

Right.

> 
>> Move the code that marks memblock ranges present into
>> mm_core_init_early(), before free_area_init() and the HugeTLB bootmem
>> setup. Rename the helper to sparse_memblock_present() to make the new
> 
> ... so let's name this function to reflect that.
> 
> How about sparse_sections_init()?

Make sense. This name really captures the function's purpose well.
I'll go ahead and use it.

Muchun,
Thanks.

> 
>> caller describe the sparsemem-specific initialization step.
>> 
>> This is a preparatory change.
>> 
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> mm/internal.h | 2 ++
>> mm/mm_init.c  | 1 +
>> mm/sparse.c   | 4 +---
>> 3 files changed, 4 insertions(+), 3 deletions(-)
> 
> -- 
> Sincerely yours,
> Mike.



