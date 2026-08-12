Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CA98C5CFDB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 10:59:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E07A26B00DE; Wed, 12 Aug 2026 06:59:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDEDA6B00DF; Wed, 12 Aug 2026 06:59:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCDE46B00E0; Wed, 12 Aug 2026 06:59:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A64606B00DE
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:59:58 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C87271C0DF2
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:59:57 +0000 (UTC)
X-FDA: 85092322434.20.47A8D00
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf01.hostedemail.com (Postfix) with ESMTP id B0C6A40005
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:59:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xTmP5Qpg;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QnF+b7tp;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OyuT4XMr;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="4/YckPR1";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf01.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786532395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QswIT/rCI0cwQtVcS8lMq+TQBP18UyXHMFLt/8eLSNQ=;
	b=dSN3KWbOPmnbcWqY+NtBMEGkD0Jvumfxe7qHHc0kS0DNRd45EA1BVb8g83rRNR5Kn3McpY
	c+eRUYGYDmSZioKHhOQ1hnVrDSLNcxKx0CIUa0o439RusCDsQ+yS2EnMH4nHP56ABoniaN
	cc37j1t7deJROQS1da4AbKeEUWkf4oU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xTmP5Qpg;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QnF+b7tp;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OyuT4XMr;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="4/YckPR1";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf01.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786532395;
	b=aBt1UrQ5Vp718cqRxfcXgFXipu9oOeZ34JUKcI4rFkxlTlrvWqExn9gEY4lZ9Kx7QhVNE/
	x6Riy83ImSQX/Y9/DI4Z2CTmysWPDIy4Fhrnu6XV7FLldElJ4GkrFZUzEHF6fgyCbbvzsI
	c4IsqgUPkIV2hGzvX6NBxwwnXenVqFg=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 221CC82269;
	Wed, 12 Aug 2026 10:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786532390; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QswIT/rCI0cwQtVcS8lMq+TQBP18UyXHMFLt/8eLSNQ=;
	b=xTmP5QpgCWjnmFqwHeaCcaCSVqDoYDOSw5qtviOUvuRjYfKXskmGQqp2azXD9jTkI/Ifwo
	VlMIE80CCma98enNhKq0iKA4c+8VLCfK+m5Lno6GPPZN6qOj/MLjRn/QWLcvUR9jYuRU7/
	m38xUuthh6M95bZwiCpyH6Z4QB/yKzg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786532390;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QswIT/rCI0cwQtVcS8lMq+TQBP18UyXHMFLt/8eLSNQ=;
	b=QnF+b7tpmRhs+oViGdTXNhikTCZPxrgx7dIELfx7xGlyBQbF4SRJATas4+XHsxSig+KAoS
	r+UioboklOPeB9Ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786532386; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QswIT/rCI0cwQtVcS8lMq+TQBP18UyXHMFLt/8eLSNQ=;
	b=OyuT4XMrdrjjGUnxk5suZMco9xrBJGrZMY9Jxf8Z25hZQjOxMmy6UuGiwFFg9nzxRQ6/I5
	YzfCGuf1njQUkgaFKYVJmnJKMx5GWeX/3fg6hWPA1cj+8OVASJKFbSvgOwNM3JbtExC2E8
	59HxA6sER6xXDJl9za3ZJNZ8DR7sarE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786532386;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QswIT/rCI0cwQtVcS8lMq+TQBP18UyXHMFLt/8eLSNQ=;
	b=4/YckPR1pDvDmjE+MXaRyQyw4tGdbfM6JwvvMKTrT0v28ROgDz3/On4+FywHdusja5rfra
	CTnYENy60VwEpuCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7E7D2779B2;
	Wed, 12 Aug 2026 10:59:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sX6nGyBSfGr+UgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 12 Aug 2026 10:59:44 +0000
Date: Wed, 12 Aug 2026 11:59:42 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Peter Xu <peterx@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH 3/3] mm: fail the fault on a malformed swap entry instead
 of retrying it
Message-ID: <anxRBd_LJaHmtzDS@pedro-suse>
References: <20260810-swap-v1-0-375ef0767206@debian.org>
 <20260810-swap-v1-3-375ef0767206@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810-swap-v1-3-375ef0767206@debian.org>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: anxpxo9jfioyx9izsgrrmzsqo6ok6oct
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B0C6A40005
X-HE-Tag: 1786532395-161695
X-HE-Meta: U2FsdGVkX1+eqMFMth4cPttc7A5yyOFGh22nhbJrvGZ4leWPNd3d9F7JJuljP3zPYJnLMuXqxTWR27fCRhxhmM3w+yUBZVPPZ9xcpFelhZd16dU0Mw8BXtKKYmrqIwLDag0FqKT73G6vnPN6smTfhw2FAfKV9jTENwnJGn36K7D4PZBhHF6et+haQl84DS9spJInjpqMEvJUivK+ZjG9eu6cShYNmKoXv6IVhd9HsELEsZFjtAjz5hI41ZOHM3OfGXfLx7OBC3G13Fuxf12ecEA+oXe+417uMZqoIwH79WerlXhG5z+5+xFPAg0kC3O610uLohaAfKqkOx+l89K1V3CK0N5+XyrvWuE+xYvTHgmg1EuGNUGka4+2ve1ab+/XhhI7PbsXyomec5lu73qkpAjBDw6Mr2J9K2OGsUkGJ9Eb5YE/P6lYQLe6+e88gduLAxpIrd2yNFj0ahs+vrFI6hJNtmChx8H5VFEVNslGBTuUOGHSw+DzsVkCqFL/FyRH34/u7BHZE/Wr5DMpAnfLY1IogLiWmmPHztUmM66IEewyVcU8JVJsG0KR3m/tzEjlTiMpEIi5AL8FW1IK1aJm2z8P3mnLHZh31uTYYnepQwPXY1ptdGhkIrPisk+OsZSyDL9tWHlcj2/a66thZEiwdF4wPgMk2uJ0tNMNEiuXW+qpAOlkgAOMNXw1Vkzjgt5wspppDmtRHjYW+nfKW217+Shpi5KvTE83bGlqbbVh4fIhQYDiCnQ4+XEg8LQFjwu8SLV+CzSmWlJH6ds/wjF8G3ZBYye/bY7bhHPGqBYu1HWlYlee7RSVpk/Ls2zKzxj4oOt//FPkNd6nTwNAA6Capm8AeVmL+j2NcbaxfBdDzKoEbxgM7bLYoe2zTf5HiuTl3NKrxrS14FL30BX1OP3VIdF7HeCh0mzSIKpwjqtDXjbcwlM0Ky2WU9M7xWQwxhnjBLAl3UUMYBnJekFyw7C
 lSPQzjIo
 8TWvDEvIMQxEisB37huejPvpGBeC8C6w0zO52yrPk+haJjN8FevShTgHmAKsZLNoLwRuNiwaefo6m7R1ub2P6I64drutYhYh1eqhSxQLcccJJTZ9JtjN0UXjtNzc10RBp/x4bx6j9EJvu94Tu5bT02S4cO7ZFEppQ37mWlGhx3dK7eneOFEQp8PlGMIcU/wuiDbpWaXUZWmhdLuIg30UlvKR02ljQphy6gE469EnTSF4MzTLb2UJ0xBVCEXw5Ehl2AWbd3nFmFtCgM67fE9X0ZO7iiw2M58RvPZ2PzkkTQOz2ZNYHE4CcA6F+K5ojLWHDcFCkRFRqFcdXVQ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 09:26:51AM -0700, Breno Leitao wrote:
> do_swap_page() returns 0 when get_swap_device() fails, which the fault
> handler reads as "handled". For an entry that can never become valid
> the retry takes the same fault again, so the thread spins until it is
> killed.
> 
> Return VM_FAULT_SIGBUS for a malformed entry, as the sibling arm
> already does for an unrecognised non-swap entry. A NULL return still
> means swapoff, which is still worth retrying.

What kind of SIGBUS do you get from this? as in the si_code. Out of all
the options

#define BUS_ADRALN	1	/* invalid address alignment */
#define BUS_ADRERR	2	/* non-existent physical address */
#define BUS_OBJERR	3	/* object specific hardware error */
/* hardware memory error consumed on a machine check: action required */
#define BUS_MCEERR_AR	4
/* hardware memory error detected in process but not consumed: action optional*/
#define BUS_MCEERR_AO	5

I would say this would fit none of them. The default (AFAICT) would be
BUS_ADRERR, and I think that one is quite overloaded with meaning (namely,
with regards to memory-mapped IO past EOF, or EIO on file IO). I wouldn't
love to also use it for this, IMO.

> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  mm/memory.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 4238778b66c42..2842cd976f1d3 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4957,6 +4957,9 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  	/* Prevent swapoff from happening to us. */
>  	si = get_swap_device(entry);
>  	if (IS_ERR_OR_NULL(si)) {
> +		/* A malformed entry never becomes valid, so don't retry it. */
> +		if (IS_ERR(si))
> +			ret = VM_FAULT_SIGBUS;
>  		si = NULL;
>  		goto out;
>  	}
> 
> -- 
> 2.53.0-Meta
> 

-- 
Pedro

