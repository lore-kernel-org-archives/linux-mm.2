Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4027060A2601
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 13:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=OXuoreeF;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=6D0vMvDa;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=OXuoreeF;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=6D0vMvDa
Received: by kanga.kvack.org (Postfix)
	id 557996B05B3; Mon, 26 Oct 2026 09:25:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52EA56B05B7; Mon, 26 Oct 2026 09:25:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41D6C6B05B9; Mon, 26 Oct 2026 09:25:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 199756B05B3
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:25:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A3C4FA8302
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:25:47 +0000 (UTC)
X-FDA: 85364849934.06.A6F0B3E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf13.hostedemail.com (Postfix) with ESMTP id A3BD720006
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:25:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OXuoreeF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6D0vMvDa;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OXuoreeF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6D0vMvDa;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf13.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793021145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yRPCNA7q22mNYbPLjS+vxZpi/8u+Qm+QOc21SCkQ9tk=;
	b=nr0DiCvKf1SDoehCI7nJiSLIZze90jHn9qt/OQRgirN7rkR+vo2KIn/w/UfqoynD/lZmQI
	zNno7/U/cs5msJb32MHewsULz4x1Sg7K2lkeIsyV8ZACLCVmOhCVabxnXxtjxTqfdnqczR
	3edm+ObW8/9ci0B7bDbpsMbBxDXsDVc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OXuoreeF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6D0vMvDa;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OXuoreeF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6D0vMvDa;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf13.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793021145;
	b=iJpu+73jRmvB/ZsGznRWSAbm/DvOm1HJ1n7EzAhzQGnxpWXdHuhP5IZnGeuZEAar9EvZD7
	xpqnwSuI+loc08fiiUtIdacw8TB1+DraPNt8DWGWOSLrTUxuEvkKNQ2lI/zYq/oto1UYYH
	sKyGrQroKXzBPPGPnd2xSfNJeE+jjI8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7A55F222EF;
	Mon, 26 Oct 2026 13:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793021144; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yRPCNA7q22mNYbPLjS+vxZpi/8u+Qm+QOc21SCkQ9tk=;
	b=OXuoreeFlFTH8oQICNZHe/5aaneDHnDEEK62Mx+VR8WyQ3vTEh1ib+DJ9NkqYg345EnLnG
	UBC1UdQJylhv4vRFlU5XvLs89oVTm1lkiDBAeMvqBTfGSj4xg/ACk8R/3yPoR4g1EFjU8n
	PrIbHovoWD3PPhl84HO5AgxpXlNMgjA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793021144;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yRPCNA7q22mNYbPLjS+vxZpi/8u+Qm+QOc21SCkQ9tk=;
	b=6D0vMvDaE9d67fTH0ibs7NBChKNZ8ES2v7d+Io0T/NWF3lz+m+SsBLNYRKMCtkcS1uS7+4
	cn7LE22YETP6yBAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793021144; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yRPCNA7q22mNYbPLjS+vxZpi/8u+Qm+QOc21SCkQ9tk=;
	b=OXuoreeFlFTH8oQICNZHe/5aaneDHnDEEK62Mx+VR8WyQ3vTEh1ib+DJ9NkqYg345EnLnG
	UBC1UdQJylhv4vRFlU5XvLs89oVTm1lkiDBAeMvqBTfGSj4xg/ACk8R/3yPoR4g1EFjU8n
	PrIbHovoWD3PPhl84HO5AgxpXlNMgjA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793021144;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yRPCNA7q22mNYbPLjS+vxZpi/8u+Qm+QOc21SCkQ9tk=;
	b=6D0vMvDaE9d67fTH0ibs7NBChKNZ8ES2v7d+Io0T/NWF3lz+m+SsBLNYRKMCtkcS1uS7+4
	cn7LE22YETP6yBAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6B3CD13408;
	Mon, 26 Oct 2026 13:25:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +MmFDNdU32pPcwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 26 Oct 2026 13:25:43 +0000
Date: Mon, 26 Oct 2026 13:25:41 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Ngoc Quy <ngocquy0700@gmail.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] fs/proc/task_mmu: pin mm_users in do_pagemap_scan()
Message-ID: <at9Uv59VV4_R1lgH@pedro-suse.tail5790ac.ts.net>
References: <20261014095540.3261469-1-ngocquy0700@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014095540.3261469-1-ngocquy0700@gmail.com>
X-Spam-Score: -13.30
X-Spam-Level: 
X-Rspamd-Queue-Id: A3BD720006
X-Stat-Signature: d75d8fs1ugiqj3gdxdjkt6aw5uncqc9h
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793021145-461309
X-HE-Meta: U2FsdGVkX18iDi4shIeY9TbU2Yg3nLu0mxec1KCWZ3OR/uIBfnx3uN++mtKntKHT4TdU9RyqCOw8YsDwFajVnkF8aqsF4MPjGOPQXtKuDBMWmUzf6gl7uO4Kez6dcKiwvoU0EBfGbB76Ihon1hUR+QwxZMi4hUHpQvGTg64Ej/8+qjODRKeXfMEv+R+gx8Uk0uS9q/vAlvHXLcX+LPL+hdk/S2t2vuyfRtP4QiW6VczWMuuSOdNdzuU0hbIteHgcfLXMRTEBDl4wBJgnSGbowccrJwB+Hj+dfPvTA7yOSmPvg8c3+Rz8DMryVs+ao9p3Pn05+igk8nDJdpzM69Rp9cAjRGRRJdCx5RNGklVNk62z1jDYrNYVcJoDBTVM3oWvipHBQoFp9+4829mLyaVMIDhfHBewmyeOZSJXAqG9qNXTqKnZFioIHIUBiNJ4iyRxsIwVIgf4dDV3JsQETtZiEtj/HzvbmP7SGksqDxV5vPhnZEGpmHWYQLHVw8RgcR79wTog8J4M9tcJCEXYkD/rdmfITAEpJeItp6RGt2lIy+VVKe88A3tUdYCzpqU6qQyw5vWC80p/uzQyJuAJ7n7F3qAIWfdmyn7VV93od6BgRYONWpzICIv71rM8VsEw/XLvYARYl2im/2Z5BIwYA8u4qvQdA5Sn49dZHQbMIqhsCxwJuToJKqAato8kWkQbUgP/AM0iNe60wBQpZBWWE4g/2UqsAL565V3Rpdg9SWx9wpIv6pAIlgQMmJFLyI3mBRxLj1B1svGja0CWVqtxM+glFavAByVk8ehj+yfszomo6nWk0sCWABth98Z4vqYC3sQG7A56EENvQ8HjArJQ+UrjAPfpCbrP9gX5Xqy8GwQxyMsHlO2GWhrtRVuWWgLVK4CnN8EXk0B1yrDR8B2iLINLm4e9cUNgZII6BomMzJ+SQxIE/3Pv9KoDrIAzwSUiHU4+8bTgOLuSOvznqY6waQm
 gh3P+4+G
 kSli5oX2OflFtZBD/m4hElcSzzhYdAA6Ta29aecU4kwBJtL0PKoQ2/2IHqsrWf/ieCBJ928XfEs11ktdwvJzULjVaHMdB3xJIvMm5SXkVs9nizYQdkVTZLNjK1l5vDNCmHB37el7cVxiUcyu6NDsWnAAAWQp5H3RndYV3W/wFdWMxymYRhlO/vV+bKCah5isT/k/rbf53Zc1y9SFB4aRQxnWV6H5z4ek4cYylvIo5KNqnGurSOglAfX5HY/l9x+2ArtY4wWY5oBRmwe8nQ0Oepap2tlnahtVIdmBf0YG2TuUaz6Qp0i+bN6aIqba/sJX5U6e2UecxTpmH43Mq6v4QCmB9vfxD9wr4Utmema9tWU1tXH4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 14, 2026 at 04:55:40PM +0700, Ngoc Quy wrote:
> The PAGEMAP_SCAN ioctl takes mmap_read_lock() on an mm obtained from
> /proc/<pid>/pagemap without holding a reference to mm_users.
> 
> proc_mem_open() deliberately grabs only mm_count, so a consumer that
> touches the address space has to call mmget_not_zero() first. Every
> other consumer in this file does -- m_start(), do_procmap_query(),
> show_smaps_rollup() and pagemap_read() -- but do_pagemap_scan() does
> not.
> 
> Without that reference the target can reach exit_mmap() concurrently,
> and exit_mmap() calls unmap_vmas() while holding mmap_lock only for
> reading, which does not exclude the scanner. For ordinary VMAs this is
> harmless, as free_pgtables() and remove_vma() run afterwards under
> mmap_write_lock. A shared hugetlb VMA is different: __hugetlb_zap_end()
> frees the VMA's hugetlb_vma_lock inside the read-locked phase.
> 
> walk_hugetlb_range() can therefore load vma->vm_private_data, have the
> lock freed underneath it, and then down_read() a freed rw_semaphore.
> The load happens before the freeing side clears the pointer, so this is
> a use-after-free and not a NULL dereference. Any unprivileged user can
> reach it with no huge pages configured, as hugetlb_reserve_pages()
> allocates the lock before the VM_NORESERVE early return.
> 
> Pin mm_users across the scan, the way the other consumers do. mmput()
> from the exiting task can then no longer reach exit_mmap() while a walk
> is in progress.
> 
> Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: Ngoc Quy <ngocquy0700@gmail.com>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

