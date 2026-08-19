Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E36E4C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 14:23:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06FC36B009B; Wed, 19 Aug 2026 10:23:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 020BE6B009D; Wed, 19 Aug 2026 10:23:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E787F6B009E; Wed, 19 Aug 2026 10:23:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BCA846B009B
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 10:23:11 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 56C51A0183
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 14:23:11 +0000 (UTC)
X-FDA: 85118236182.04.7ED0F49
Received: from devianza.investici.org (devianza.investici.org [198.167.222.108])
	by imf31.hostedemail.com (Postfix) with ESMTP id 218F120004
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 14:23:08 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b=bjMOTD+w;
	spf=pass (imf31.hostedemail.com: domain of include@grrlz.net designates 198.167.222.108 as permitted sender) smtp.mailfrom=include@grrlz.net;
	dmarc=pass (policy=reject) header.from=grrlz.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787149389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PmK3ncwTQiQXAZMeh3sTvHkCfE4LURycHONVQJ7SAYw=;
	b=30R3oWIkxR9xQmYxcm4hYMwswLyPuUYUUtG7eVH3/p2dIlg7hVvrJFhvzM6v0pMrPWj7VZ
	oAfqUih/AtRTAcT1aHzMy8gOVL21H9+mtSsr9zyd9xZZ8qKOFLkkaUPokK99b1N/LB8CyI
	HZK1g9dXO9ZwrneK5hJCGo37hHzv1oE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b=bjMOTD+w;
	spf=pass (imf31.hostedemail.com: domain of include@grrlz.net designates 198.167.222.108 as permitted sender) smtp.mailfrom=include@grrlz.net;
	dmarc=pass (policy=reject) header.from=grrlz.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787149389;
	b=2c0R47wvJoF6F4+sitEa3f795DzRl91et3Q2CkDBQaRG5SfkRBV/A7eR/sZab6mQaIQGyU
	UnCZPqqGFSih97G/4gS7GiHPgvaWXKUnODULf67IzqUZpMwj+hAQcctGXJp/GYXQJzIALJ
	Sq9D/4DvP4iPcMNnu58DLBBOCzLAlJY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grrlz.net;
	s=stigmate; t=1787149386;
	bh=PmK3ncwTQiQXAZMeh3sTvHkCfE4LURycHONVQJ7SAYw=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=bjMOTD+wRqyP/D3W90OS7+jo0JAp5OhVkZrmeVelKAVcKsiJd2+teYZRsESxY9JKa
	 OQNV7YAcxpxWPQaWqCZ/gizjuxMEvDu0pCgWARsX/fXxK+Dyd2mziIUO0euXOq+FuW
	 52BTW25ZMib3ug0Kh8aQmvTsTA+sGouce6Wk/1BI=
Received: from mx2.investici.org (unknown [127.0.0.1])
	by devianza.investici.org (Postfix) with ESMTP id 4hQ81Q001sz6vBx;
	Wed, 19 Aug 2026 14:23:05 +0000 (UTC)
Received: by mx2.investici.org (Postfix) id 4hQ81P31wdz4y6W;
	Wed, 19 Aug 2026 14:23:05 +0000 (UTC)
Date: Wed, 19 Aug 2026 15:23:04 +0100
From: Bradley Morgan <include@grrlz.net>
To: Mike Rapoport <rppt@kernel.org>, Breno Leitao <leitao@debian.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org, rmikey@meta.com,
 riel@surriel.com, kernel-team@meta.com, Kiryl Shutsemau <kas@kernel.org>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v6_0/2=5D_kexec=3A_keep_the_ne?=
 =?US-ASCII?Q?xt_kernel_off_hardware-poisoned_pages?=
In-Reply-To: <aoV5EfBtlWcyf51E@kernel.org>
References: <20260812-kexec_posioned-v6-0-e477887086f0@debian.org> <aoV5EfBtlWcyf51E@kernel.org>
Message-ID: <6CB4696E-03E3-42A0-9E3B-6BD1E143D5ED@grrlz.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 218F120004
X-Stat-Signature: gnt46heqe55a5qqgq1eb4pwdyyzdzc1a
X-Rspam-User: 
X-HE-Tag: 1787149388-178351
X-HE-Meta: U2FsdGVkX185c6FYM+NObqep1RLBBVyJngabL8kNWpsrUxb3gle42QSr2tmBscfWs4RrRYB/Co1kf91PHnNDRV0qt6OtZP9kpCsalkTUesR8jQQ0cJecJX5TvTCZ80wYlkyLk6tLvTHbCSp4HzaHJa3AZ8cRINeAe8bpYX3ahBQylwGK0BBVdoEA4eV1BM1k7BGiPqYuC1+Ge2aE86ew4p9lSmRb/v7Opwk3ahNVzOkvc6JeogFZWCngx9CD4GcBax2V6tcn8FM+apOHkmSyv2VnPR/y1pwptfFBqme+kK1Ep8xzYHGhN3utZkS/A6KsmfuEPVZdBNHXuD0wg9aZGNmQR6FmArMTBRqRIkhloYIFmIFmA6/JdqIA8HFIb02BoWFeRnxCT5bVP2nQEluzmxEVL4cSiMa8F123Xms8JpvEpdaRm0D7dYguJXv0YMKxowpxFhVYj4D3FKeKODTmiKymPYqIvo2hubek8RYEIaqui0SuXopCwKxg5h8i4TlYXRHXIpGJWdfqqjtd9S2d2JsZzUNV93XIE8dQF+M5hz2SSn3yijnWngy9q6FCbpUhiIEPck4LNCVA1o6B2739E6sDe7B5VsU11r0RRbupEnkQ4vbclbavdahHDXZEgstF5S+RlbjImR/roF6gMAxU2S3MIhoyWO4+H9raQDulzjIP0M5WbPKmlddneIJBqluHiENvQCfVIh42odm/DoHFWL3OFFjdiUhv1tKYZhEXvcvKmydDUOzWvJaL7rSn4rNhQ5txSGT+zdhnXD6xHIfABwI/KI8cQNZhWFvmSvZOSGPAt1PJRBsDb8RRSHwUfwPuanw/wVZ4c2hcTLVVF5j2zZw/G0q4rA4g+dV0hSrxaj0Z+6/zpXsUy4uX3SqGJ8wTNDiChGrxDbLEEfO9KFD4GnS3HPiQYa+NPlfgIAU/WLz7XyDAfIC2QYDp2mhUxLZzc9U0SbLh9TMFnSdcrQs
 U24cl6Ek
 MxtQOYK26sUE32mnzRoSPB8/jeC13+Vx1/mDAlrl9J6RfE/eDBiOY+Ircr8fvmHGGjyiM9zZB38IGEOl5arvD9oMZffcs4hdoOFqnkQ9zfRZKXfDsqXkvr4tF9nGA0ZX03jQS4h0FpKKuZ2XIxhkNxs/lG5JiYmIjQ/sK5HqBsmDoKUi8n3NW1AnfrjxpPg0KtMEl1tUVHa22JtqVtkE+LJmoogwV83BXmt+YVCcu3fo7mY6lUOrFWZHiB2wgqaP2qngtLS30pF0NdhSmP1QrLj1NgAIeeNqkjKmuhTx8/rUWkVZQYXrNxnrxB31WVcL37rHMjHoSwBUkfqgH5hJlR1AJf9rBPaVrK312y9QLb+SbMzDE2wn9QLorwL+71MgvyYUGgU9lZv11hUnPy68TfaVvhu7BYs2Pqq/ZuFypmpVuRDJb1G/05EZUTSQDYeXyRMfX8zvDPMkVT1OCNKW4HxsArhUJOO3Ypfso+EsczNGimWMr8RJrtq/ogKZlQjr6051DtnKlnPsxu/uynJzgePTHYlD9qQ1OojwYWVfdIPHn9GbWOiiqhCvZ2LyZYtoGhkG+nDf/7lsWyvNRkNtGBDvggZnDO00aaPimLQa9zIHSYWzhGnMaFFWYZGhl1eyP/uGpXhzZa7cTjL+4JDFq+X8r8SL+spFA41FXrlY3B4vX1+c/jkd+PLoejCwcT62UPlcXHLCnZIY8WjDz4rYW+rRqKqAa7GJGdmkkmwcyPnhaFhoJso+51iAPz/CumpelyvMpN4aFPpYtUoyctxV4D6A1JKBSGflVi7Tc/Gj580bVYASgziH7Wibx5WjnVvlRHOelxt+Ilrv+Dxk4pwbTo8xGsBgMTNdj3t/31ouhF2SU3e283jvDkyeQaA8WBGLuMBPbRcmZQLUrBqkBaJ+zwss8JpsaOb23tpzLS0LNBTJ7Cz4Ouyedu/Wp6ROQ/ZecOMKU38pSFAA8s5/z197kTuJqiTB5
 ezV+R6j5
 LWbTOuZSfa92kvQbzrvItN4bg1AwfMaoDvMkRNP2+tHL8Tz3U9CO77OdZPMHCKN5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19 August 2026 10:36:17 BST, Mike Rapoport <rppt@kernel.org> wrote:
>On Wed, Aug 12, 2026 at 04:31:50AM -0700, Breno Leitao wrote:
>> Memory failures are common enough on large fleets that kexec regularly
>> lands the next kernel on a frame the memory failure subsystem has
>already
>> marked bad. Patch 2 teaches the segment placement to avoid those frames.
>> 
>> Patch 1 is a prerequisite. locate_mem_hole_top_down() walks candidates
>> downwards without ever checking that the subtraction stays above zero,
>so
>> the walk can wrap and report success with a destination outside of RAM.
>> Patch 2 adds one more downward step to that loop, so the bug is fixed
>> first and both patches rely on the same bail-out.
>
>I queued this for v7.4, the patches will appear in the liveupdate tree
>after the merge window.
> 

Ah, so it'll appear in a maintainers tree after MW?

>> Signed-off-by: Breno Leitao <leitao@debian.org>
>> ---
>> Changes in v6:
>> - Split the pre-existing top-down underflow out into its own patch, and
>>   drop the "if (poison < kbuf->memsz)" guard from the hwpoison hunk now
>>   that the loop bail-out covers it. (Mike Rapoport, Sashiko)
>> - Reword the changelog: the MCE comes from reading the poison back, not
>>   from the relocation copy writing it, and the placement paragraphs read
>>   better split up. (Mike Rapoport)
>> - Move cond_resched() after the struct page dereference, so the scan
>does
>>   not yield between pfn_to_online_page() and is_page_hwpoison().
>>   (Pratyush Yadav, Sashiko)
>> - Keep cond_resched() per pfn rather than batching it. (Kiryl Shutsemau,
>>   Rik van Riel)
>> - Link to v5:
>https://patch.msgid.link/20260810-kexec_posioned-v5-1-95e1b5e2e656@debian.org
>> 
>> Changes in v5:
>> - Return -EHWPOISON instead of -EADDRNOTAVAIL
>> - Leverage is_page_hwpoison() instead of per-page check
>> - Link to v4:
>https://patch.msgid.link/20260807-kexec_posioned-v4-1-70d57f14625d@debian.org
>> 
>> Changes in v4:
>> - Anchor the top-down hole finder on the first poisoned page in the
>>   window and the bottom-up one on the last, so each jumps clear of the
>>   poison in one step. New range_first_hwpoison(). (Kiryl Shutsemau)
>> - Count a poisoned hugetlb folio in full: the flag lives on the folio,
>>   not on the subpages, so the per-pfn scan missed poisoned tail pages.
>>   (Kiryl Shutsemau)
>> - Link to v3:
>https://patch.msgid.link/20260803-kexec_posioned-v3-1-83aa6ede0351@debian.org
>> 
>> Changes in v3:
>> - Return the address of the last poisoned page in the range, or
>>   PHYS_ADDR_MAX when it is clean, instead of a bool plus an output
>>   parameter. Renamed to range_last_hwpoison(). (Pratyush Yadav)
>> - Add cond_resched() to the scan loop, as a segment can span half of
>>   memory. (Sashiko)
>> - Link to v2:
>https://patch.msgid.link/20260730-kexec_posioned-v2-1-f92d18551f64@debian.org
>> 
>> Changes in v2:
>> - Change from pfn_to_page() to pfn_to_online_page(). (Miaohe Lin)
>> - Return the poisoned address once we find a hit, to avoid the O(n^2)
>>   rescan. (Sashiko)
>> - Link to v1:
>https://patch.msgid.link/20260728-kexec_posioned-v1-1-160c81d180fe@debian.org
>> 
>> To: Andrew Morton <akpm@linux-foundation.org>
>> To: David Hildenbrand <david@kernel.org>
>> To: Lorenzo Stoakes <ljs@kernel.org>
>> To: "Liam R. Howlett" <liam@infradead.org>
>> To: Vlastimil Babka <vbabka@kernel.org>
>> To: Mike Rapoport <rppt@kernel.org>
>> To: Suren Baghdasaryan <surenb@google.com>
>> To: Michal Hocko <mhocko@suse.com>
>> To: Baoquan He <baoquan.he@linux.dev>
>> To: Pasha Tatashin <pasha.tatashin@soleen.com>
>> To: Pratyush Yadav <pratyush@kernel.org>
>> To: Miaohe Lin <linmiaohe@huawei.com>
>> To: Naoya Horiguchi <nao.horiguchi@gmail.com>
>> Cc: linux-mm@kvack.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: kexec@lists.infradead.org
>> Cc: rmikey@meta.com
>> Cc: riel@surriel.com
>> 
>> ---
>> Breno Leitao (2):
>>       kexec_file: stop the top-down search before it underflows
>>       kexec: keep the next kernel off hardware-poisoned pages
>> 
>>  include/linux/mm.h  | 14 ++++++++++++++
>>  kernel/kexec_core.c | 10 ++++++++++
>>  kernel/kexec_file.c | 20 +++++++++++++++++++-
>>  mm/memory-failure.c | 40 ++++++++++++++++++++++++++++++++++++++++
>>  4 files changed, 83 insertions(+), 1 deletion(-)
>> ---
>> base-commit: c5e32e86ca02b003f86e095d379b38148999293d
>> change-id: 20260727-kexec_posioned-72bb0a4143a0
>> 
>> Best regards,
>> --  
>> Breno Leitao <leitao@debian.org>
>> 
>
>

Thanks!

