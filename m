Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D0B4F41996
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 12:06:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A84B6B0092; Wed, 15 Apr 2026 08:06:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27FA26B0093; Wed, 15 Apr 2026 08:06:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 196196B0095; Wed, 15 Apr 2026 08:06:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 088F26B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:06:17 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3A01958B68
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 12:06:16 +0000 (UTC)
X-FDA: 84660662352.11.71FE896
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf06.hostedemail.com (Postfix) with ESMTP id E007E18000A
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 12:06:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=JhjMDbpc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=D9TzG1hZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=JhjMDbpc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=D9TzG1hZ;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf06.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776254774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dC95RKCSCi9LVrg1A8un9ES6lp7MegYkrQ18OXExBbc=;
	b=S5X9C7Eie4dZp6TmCWWFqCdJLVuIf64ZzX7T2r0k7WFLynhjsUDKgGLs/4H0jHcEfff+8L
	3MSd+/de0JzqSMkHnUWbXWbPrV7oOHwxscp3ihfmFmaUksnWoI/dIZb4GA+5NU+eVdEDhX
	i4FE97zfWMT48FA14reedj666LiaL44=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776254774; a=rsa-sha256;
	cv=none;
	b=GC5G/1sCctC0SKZESDGFiP85q/96uB4F0ym0CeXqZyh4xtUVfihezXbxAUDPHvxCKG6JQZ
	+o63LggvLcMiEU3logCJ27RUBZkzNt4c3G997R3Rhqk66AbFT3cZgW4G8TYWkQWdzCgIxD
	pKLeB4gV3HHT2erAQeUi5Uyri2DGqUo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=JhjMDbpc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=D9TzG1hZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=JhjMDbpc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=D9TzG1hZ;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf06.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 607AF6A7E2;
	Wed, 15 Apr 2026 12:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776254772; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dC95RKCSCi9LVrg1A8un9ES6lp7MegYkrQ18OXExBbc=;
	b=JhjMDbpc2lU9/UB8R7Xr/Y4op4IjOAEy58l7zPCyS1zO3143XIN5+vldCGxg0k+nnKlUxU
	YWyuCW3jKPHNUjRWEub8nJrT9S/VF/pAGh/+X8oHBxauSZ4VeHNNc8JMXL7TF//2VycV8N
	f8xIIx/DlqAbNMuiQKmbHayWwHPQh2I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776254772;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dC95RKCSCi9LVrg1A8un9ES6lp7MegYkrQ18OXExBbc=;
	b=D9TzG1hZmdWBcb4rhaXwoDbJIIF05o1vfaGJbFQaAnp3uwh5xGoHyBwRSgCUpQFFdomaGr
	SUBO0bIW7SHyvGCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776254772; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dC95RKCSCi9LVrg1A8un9ES6lp7MegYkrQ18OXExBbc=;
	b=JhjMDbpc2lU9/UB8R7Xr/Y4op4IjOAEy58l7zPCyS1zO3143XIN5+vldCGxg0k+nnKlUxU
	YWyuCW3jKPHNUjRWEub8nJrT9S/VF/pAGh/+X8oHBxauSZ4VeHNNc8JMXL7TF//2VycV8N
	f8xIIx/DlqAbNMuiQKmbHayWwHPQh2I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776254772;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dC95RKCSCi9LVrg1A8un9ES6lp7MegYkrQ18OXExBbc=;
	b=D9TzG1hZmdWBcb4rhaXwoDbJIIF05o1vfaGJbFQaAnp3uwh5xGoHyBwRSgCUpQFFdomaGr
	SUBO0bIW7SHyvGCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 31A534B9CF;
	Wed, 15 Apr 2026 12:06:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id R52vCDN/32mlEgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 15 Apr 2026 12:06:11 +0000
Date: Wed, 15 Apr 2026 13:06:09 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Anatoly Stepanov <stepanov.anatoly@huawei.com>
Cc: willy@infradead.org, akpm@linux-foundation.org, david@kernel.org, 
	ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, wangkefeng.wang@huawei.com, 
	yanquanmin1@huawei.com, zuoze1@huawei.com, artem.kuzin@huawei.com, 
	gutierrez.asier@huawei-partners.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] filemap: use high-order folios in filemap sync RA
Message-ID: <3cr6ppe6bic47tan2iapuh67s67hiroangvdiap4jbn7ypru2o@rbvqv3sxifwp>
References: <20260415192853.3470423-1-stepanov.anatoly@huawei.com>
 <20260415192853.3470423-3-stepanov.anatoly@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415192853.3470423-3-stepanov.anatoly@huawei.com>
X-Rspamd-Queue-Id: E007E18000A
X-Stat-Signature: 8ytoh4t61hu4mgw6gy38twworr8foog1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776254773-253386
X-HE-Meta: U2FsdGVkX1+aMnod0CD2iJLzZMztFFl1UGYu3rHUIhCnGne3uBtvWEqZu058qLd93UuqJ2gBD8aLa2drgzvmPjMoum3ltYCyCEBmIF1o5cvtBrrpXMF5mrvseCJ4yusdwaSjkw9tlJVPF2v8mSBvVHX5lUnUDZEhQ5EjO9pe6rAgezKNr6vhOi/hqODbLWKXOiDm0uUxDDIXZnVvUQIdMxuwaU4ezKNCpHs103DycAgZkWLW0Q7ecH+4Qbv5eHwixcWNoWXmUOGv9e88+IgN7/HMYhqt/IrvY8Q8JWXbYdNRLTnXrIyCRNVH/N5ycoN88TW9CH12NbooMrmQ+FvPnfswZjIgSM68cbHAi6GcjqDgEhT+k+hVv/mxQ+YoY4ToaM9V6Bf4FudgRQIEJpWEByBz8OcdH0H80Y6/Y5s/56um6jHvKW+F/xrGx9Sk9UcgkV+DCwyXmZTMPY+2Zn07qSJ0wLVAXiK06pjuK6f7HFGKHAIOT2jVZTxaZLnoRNs1ouWtNlzFXsmyi9s3LFBYuR3h6RgbeJMbwBXfi5S5PNo5CJtiWSA2Dwi6r65kt4njQx6UYGH6kzfCdr3pUBwPQ1Hc1PhrXSOmBeMKQKUXKQAKTxbYFd6mw4Lr4az/0LtHGcBiYAswQhYp9IyI7bS7ePT/RQEFCslGDNmFSyGOgmImo6DzHWsScqE+F9ZjO1K0DLBXxMP1S4ZslCehYVL4MYJGjeuMmJfZTiDlJta++7iTTW4CJ2vcuY0hht9jtdL2qu9LUe2IqnO8CRcxCBMV/RAAb4MDZZeaDgjwKutbI0jebbp+kvvlJgpdBmuMqWXt7ITMfUlcJErYfHUrrVgSHG6GnK6M1QE6pIrIBQMYg7+Wtr12cSWeOltFrzhGRozioF2QChXxB3XNofsXzve6M145MdLBPwvjCS+VuVH/+x78YnD/lBXQ/Mbxlnry/HL2kH1jW3FChCR+dOJkMGx
 O6SEIKCo
 hmjh/QNRXcl872rH9K7v8CwAA8uF+W2FFD/qQoZrfRXdMvxxZYLdhi22Om0vIK7ASHCEPMQHplW0xDOi8KKiZtnJC7gydVIdtMdcsWxKFTT3ozdVMTG9ai0vLAXHkRcJ96zE6+0coxsoUpT2K0hoNeFQrVN2cRwjuCa6X1leFCJSnq2EHKScGCc2ytEmqJWHF24k6QW9Nn5Hj46D3lKJrLl4NNM85vkQw69kgorO2jKrKU1k/SJJFZ93O4ftKET79xfLd4UNI8iQANCWn00YLNZ/2zIXIdsW+yif6dLYrrAkYmLE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 03:28:53AM +0800, Anatoly Stepanov wrote:
> [Idea]
> 
> If a mmap'ed file being accessed such that async RA never
> kicks in, we might end up with only 0-order folios in the page cache.
> 
> if fault_around_bytes is larger than 1 single page, then
> it's beneficial to use high-order folios, which brings significant
> filemap_map_pages() speedup.
> So, let's just use fault_around_bytes as a starting point here.

Well, this heuristic looks arbitrary. I don't like to mix different concepts.

With this, in practice most file folios will be 64K. Why? Why is it related
to faultaround when faultaround is a separate mechanism that isn't particularly
relevant here?

> 
> if an arch supports PTE-coalescing we can get more of those for free.
> (see arm64 example below)
> 
> We don't save the new order to "ra->order", so if async RA will happen
> it would normally start from order-0.
> 
> [Things to be discussed]
> 
> But at the same time, i can see drawback for 16K, 64K pages, in this case fault_around will still be 64K by default.
> In this case, it seems makes sense to make the fault_around_bytes be like order-N of PAGE_SIZE, not fixed bytes number.
> 
> Another issue is - when fault_around=0, but we'd like to use high-order folios for sync_RA, for cont-PTE for example,
> For this we can use kind of "max(fault_around_order, cont_pte_order)".
> 
> Or introduce some dedicated tunable like "sync_mmap_order".
> 
> [Benchmark]
> 
> Simple benchmark below reading 100M file in 4M (RA size) chunks
> such that async RA doesn't kick in and the page cache ends up being
> filled up with 0-order folios.

Well, the problem is that you are _never_ getting RA to kick in. Folio
size is the least of your concern, you are effectively not doing much
readahead since the kernel thinks you're doing random accesses.
> 
> The patched kernel gives ~3 times increase in throughput,
> considering the page cache is filled up at the moment.
> 
> The main speedup comes from filemap_map_pages() due to high-order
> folios usage.
> 
> As a bonus, we get better cont_pte bit coverage for Arm64.
> 
> Example:
> // Open 100M file and read every 4M chunk, given max_ra=4M
> // Perform 10 runs, measure the throughput.
> ...
>  char *map = mmap(NULL, filesize, PROT_READ, MAP_PRIVATE, fd, 0);
>     if (map == MAP_FAILED) {
>         perror("Error mapping file");
>         close(fd);
>         return 1;
>     }
> 
>     struct timespec start, end;
>     clock_gettime(CLOCK_MONOTONIC, &start);
> 
>     unsigned int size_4M = 4*1024*1024;
>     unsigned int num_reads = filesize / size_4M;
>     volatile char val;
>     for (int i = 0; i < num_reads; i++) {
>         off_t offset = (off_t)i * size_4M;
>         val = map[offset];
>     }

This doesn't seem like a real issue. And if it is, you can always issue
readahead manually. But the whole pattern of "every perfectly-sized RA
window, access 4 bytes and advance" is completely bizarre. And _if_ this
is your workload, then having order-0 folios at the read site is much better
than filling your page cache with data you are not accessing.

Do you have an actual use case for this? Where have you observed these
problems?

-- 
Pedro

