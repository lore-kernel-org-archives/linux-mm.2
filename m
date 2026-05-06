Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01D85CD3424
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 04:18:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 349A56B0005; Wed,  6 May 2026 00:18:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F9CC6B0088; Wed,  6 May 2026 00:18:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E7A96B008A; Wed,  6 May 2026 00:18:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0ED076B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 00:18:06 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AA0F21606EC
	for <linux-mm@kvack.org>; Wed,  6 May 2026 04:18:05 +0000 (UTC)
X-FDA: 84735687330.03.F489766
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6B9A0100003
	for <linux-mm@kvack.org>; Wed,  6 May 2026 04:18:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=r5zREULc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=dziTInwQ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=r5zREULc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=dziTInwQ;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf14.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778041083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0r7EBPI79XYcDKO6GsjOBlljdqO0v/WGk5GC7DrDj+4=;
	b=6Cyk9xyF0Y3OWHgkSRu0tSwIwQ/mVMcmL8T9ws+vonLTwNmhIj3Info7LZPBegTw7sZoos
	71XsBGa6TlSy+q/o56Sz92Ml9Nb/NsjoTQCOll5Vded3erDgIxXFugqWYZaZ56Ezf8oqqC
	G4DdiN27LnMy/702eIIJW/AM83Hes9M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778041083; a=rsa-sha256;
	cv=none;
	b=DhmWo+xn/ftTb3/sn4AEOfa596wc2ZW6OwXzEQMRAsb7BAdoMrjm0nnF/tstzMk56Zsaix
	WyzkDaIE/jl2k7fT7GWRBEMNvYnhT0ekEUubY8tzc/VxX/i7AkvDOFhkITraebcL9Jrgqn
	bTGzXRNLkTIjt+7tKXD/FUa9vA1JJFU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=r5zREULc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=dziTInwQ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=r5zREULc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=dziTInwQ;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf14.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B8BDF6B1EA;
	Wed,  6 May 2026 04:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778041081; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0r7EBPI79XYcDKO6GsjOBlljdqO0v/WGk5GC7DrDj+4=;
	b=r5zREULcHeUkuvLmZwlYTX2pl1khxfHadGYOEtAC/sacAdf4XrXSK1SsReJW6u6lxLwAQH
	+hUB5PmBHcmfvIcSimlqYuq8aQIH/UcxEs0BydgscXIDtOyuNC7GlPZNnc1K+QzkbqfANS
	wLSRHXq+U6kFs70EvSfVhC1JsblOSeY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778041081;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0r7EBPI79XYcDKO6GsjOBlljdqO0v/WGk5GC7DrDj+4=;
	b=dziTInwQTMUOcFYHcG1Ue3pXY246daDGNOvW/ZFizFGLKvFU+gVEro7XvG1+3c904oN8Du
	n7SYnvZTCtJVB6AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778041081; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0r7EBPI79XYcDKO6GsjOBlljdqO0v/WGk5GC7DrDj+4=;
	b=r5zREULcHeUkuvLmZwlYTX2pl1khxfHadGYOEtAC/sacAdf4XrXSK1SsReJW6u6lxLwAQH
	+hUB5PmBHcmfvIcSimlqYuq8aQIH/UcxEs0BydgscXIDtOyuNC7GlPZNnc1K+QzkbqfANS
	wLSRHXq+U6kFs70EvSfVhC1JsblOSeY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778041081;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0r7EBPI79XYcDKO6GsjOBlljdqO0v/WGk5GC7DrDj+4=;
	b=dziTInwQTMUOcFYHcG1Ue3pXY246daDGNOvW/ZFizFGLKvFU+gVEro7XvG1+3c904oN8Du
	n7SYnvZTCtJVB6AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EDC48593A3;
	Wed,  6 May 2026 04:18:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +Z09N/jA+mmlIgAAD6G6ig
	(envelope-from <osalvador@suse.de>); Wed, 06 May 2026 04:18:00 +0000
Date: Wed, 6 May 2026 06:17:59 +0200
From: Oscar Salvador <osalvador@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
	Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Bibo Mao <maobibo@loongson.cn>,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm: fix __vm_normal_page() to handle missing support for
 pmd_special()/pud_special()
Message-ID: <afrA9_KqCSo1Yb0_@localhost.localdomain>
References: <20260430-pmd_special-v1-1-dbcbcfd72c20@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260430-pmd_special-v1-1-dbcbcfd72c20@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6B9A0100003
X-Stat-Signature: oq8kai6fyx31ieunpm8tddb6j1bs7uhb
X-Rspam-User: 
X-HE-Tag: 1778041083-347114
X-HE-Meta: U2FsdGVkX1/fIn+DNmKnhDpWXd3l2T5QVD6hjTe04NWhNqwHxFLRttqH6zVvXLHscCsRfwFiZf8gKbZCYNL2r6J1kMDrM0F32lKUbLdHSLU5mVbwmfP0COiEXF24SuM2JRXO6xus6ZHRlT+6+XLR/araxpnVG9Vz5T/1vwiHtvD3SDLlhPIkuSKqoovECG1PZA4fweJu2lHFm8ezacShRXxqNRvwUU9vfu2cZR0H+/+fFMgPJpBDti9sY6Hus6yW1tclYsZC+rcjZeAcykcE2apONjGjZ8Lp1Hz92cGaYX0ZQGNgu4j1Sopf8rKpmK3qslheEXmcrdXPCIjpnRvbkx7/bBmbQNBoqcBxBCcLjj0xl7UYf2ZjBWAcfo1zmCmuC1nwfY4xEf+0ex7tqFIj7XQGiM0RCf+CZ3IgQomXeUu/Q5eBISEiEUaUMgrhLh0ckJd3ItKRAHKcxJOPSo5ivF/dvXF0CjgSFYSY9mO0Hqz9XBV+w8PcV9hXGhM3EperFY9zN5Dhz1vY/eXI8Pcwmb3znuU9fgoAl+6EFzjpo5BRFeJJDFu6GYRnaBTJEhTQR2TdybsqBU4d3M0xmI03GymZQOzoDtJTYAqeSHqrsrHVWV7T2/EGXDs45dHXSFi++KpT4LqXE/TUYrJ+sTfKismlssLF4MnMSCZjX5sl7ImI6XQAkw9A5HF3cbDrrlFMVfwELTeMRi4OfOI4tdISUpBlv3Kmoywora4GEWMSrXo/hugw6vmPhJn6rAM5oN3hveowKDClEPsXZYE6ne0V9fUQr9ofzpm0LK/g3s2LSTAKFG2o4vO2HWifbtROzfvpl32Yp3vx8Au6fMpLagaJjliiChKI7NFHWuNT+3yRY4m/6rM2G0BE2YfdSxpzecOrvlf46zu6EX3B1R3hSQL2G5oI3Ytl5dElgSbIZZt5fJmv/vQ4kwtM6hWjiDlgqu0KZXVkFCfTeGybZNveWNg
 PXzQwzXW
 G9TEntqAB4BG3X/MdwKXayOQTCu0pFzExzOc2kVE9vS3XQb+OvDk5jJX+rjdNHXRJ3pzcoSk3m/Xv3rOXWD64VUmiudcFG8cqJvYqR95gpbP+eQrwtriuwtZDwkW9CHpAJX1Ehsf99Skx/UhZozSJyZ2MhljkayL3PLGsWRKNOfdoT6n3P7o0U9biGxhRnPvZh+aQl6L+6KLAVTxVZaR1k1r1En3gxjvuBVtGCA+//0EaaaO3OVzmvvqv0kZye5opBps5P/ABD9d/2M5C5aHMfq62Cju4m6LhOF5cALjSfyOBeZYqqdHXpswvoNAw3s2x0N1sa9U7NTrG5XQfE9UDhEqBVVKwOrXd4LY3sSbynDqbV44=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 30, 2026 at 01:31:22PM +0200, David Hildenbrand (Arm) wrote:
> On x86 32-bit with THP enabled, zap_huge_pmd() is seen to generate a
> "WARNING: mm/memory.c:735 at __vm_normal_page+0x6a/0x7d", from the
> VM_WARN_ON_ONCE(is_zero_pfn(pfn) || is_huge_zero_pfn(pfn)); followed
> by "BUG: Bad rss-counter state"s, then later "BUG: Bad page state"s
> when reclaim gets to call shrink_huge_zero_folio_scan().
> 
> It's as if the _PAGE_SPECIAL bit never got set in the huge_zero pmd:
> and indeed, whereas pte_special() and pte_mkspecial() are subject to a
> dedicated CONFIG_ARCH_HAS_PTE_SPECIAL, pmd_special() and pmd_mkspecial()
> are subject to CONFIG_ARCH_SUPPORTS_PMD_PFNMAP, which is never enabled
> on any 32-bit architecture.
> 
> While the problem was exposed through commit d80a9cb1a64a ("mm/huge_memory:
> add and use normal_or_softleaf_folio_pmd()"), it was an oversight in commit
> af38538801c6 ("mm/memory: factor out common code from vm_normal_page_*()")
> and would result in other problems:
> * huge zero folio accounted in smaps, pagemap (PAGE_IS_FILE) and
>   numamaps as file-backed THP
> * folio_walk_start() returning the folio even without FW_ZEROPAGE set.
>   Callers seem to tolerate that, though.
> 
> ... and triggering the VM_WARN_ON_ONE(), although never reported so far.
> 
> To fix it, teach vm_normal_page_pmd()/vm_normal_page_pud() to consider
> whether pmd_special/pud_special is actually implemented.
> 
> Fixes: af38538801c6 ("mm/memory: factor out common code from vm_normal_page_*()")
> Reported-by: Hugh Dickins <hughd@google.com>
> Closes: https://lore.kernel.org/r/74a75b59-2e13-3985-ee99-d5521f39df2a@google.com
> Reported-by: Bibo Mao <maobibo@loongson.cn>
> Closes: https://lore.kernel.org/r/20260430041121.2839350-1-maobibo@loongson.cn
> Debugged-by: Hugh Dickins <hughd@google.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Tested-by: Bibo Mao <maobibo@loongson.cn>
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

