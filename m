Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA0BCCCD1BE
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 07:08:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 001E08E0005; Wed, 22 Oct 2025 03:08:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF4728E0002; Wed, 22 Oct 2025 03:08:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE35F8E0005; Wed, 22 Oct 2025 03:08:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CEE848E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 03:08:58 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CC55413BB28
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:08:57 +0000 (UTC)
X-FDA: 84024873114.18.3A0883B
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id 802E220003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:08:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tQQAHmKk;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=z+t7udLx;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=cCOmOphU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="je/MybQn";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761116935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EiqzOTcD6BeiMm0m3Qik1jWulQ22mecGBwnXl3IAyTY=;
	b=vSyYSuOA0mlsMk0/UyOOJSQzMtcdY8GpsMc8nxj5bjyjhaEP4DJZR0gru9RNmSuAGPT5Rz
	9hkmCEqztlKKjWhcnfcCQPuDqDl4K6acxnlDBaNprvquq3gVXp7R0l7s03Sr8bLCDcRtEe
	DFP8PuH2Ucx/p3x2GfMUiNSrfKzV5AY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tQQAHmKk;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=z+t7udLx;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=cCOmOphU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="je/MybQn";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761116935; a=rsa-sha256;
	cv=none;
	b=UbPUlnKjvuq7/mfSFDATKMNJ3JD83bf6ZXsmhjw2wT4PYQeAHkCNjqgQH/6e7rgr+AmFir
	8GqZjkk+zQabdSOXLMlIZMSRe2LEdhkyiDgCZchxGGQUPcSO5yapQCTfuMVIonGJBro0j2
	zb3GCJa5vvOA66DOU9YP4uEgHE5hY70=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AD4A11F38D;
	Wed, 22 Oct 2025 07:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761116929; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EiqzOTcD6BeiMm0m3Qik1jWulQ22mecGBwnXl3IAyTY=;
	b=tQQAHmKkibpPDnyQgtlMZSpkOn0Wz/I7jjvBFmJ1qvbuwBsSG0bA9PF2p3G+1sn6u6ia24
	hoUy1YP3YoujGOMGP4IutV4Uyg/NbJoQYxFlSlgsQYdZdxwwa74r5xd8a2/QrycOarWv/o
	qYotXMZKxHCPNUUvlP1Hc1kOd1fMoL8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761116929;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EiqzOTcD6BeiMm0m3Qik1jWulQ22mecGBwnXl3IAyTY=;
	b=z+t7udLxKXENOYjuxaH7Jcb+kZuZMce0iuT2MA9UdsN3bWkDOc+XG5ndDikyJk0o5Gfekv
	3MQLjlYRZ2O6DyBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761116925; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EiqzOTcD6BeiMm0m3Qik1jWulQ22mecGBwnXl3IAyTY=;
	b=cCOmOphUpqowelBvduOESBfAfveCRIu/36sTR7fYXJ2SFhx7BL2S8zVSdtb/9WhYFDajly
	mSl4RgSwmlo+INNAjRAabISO12kXXdDuraakTs+OaNwvP3n61f6SQf3dnx0FUi61/+uCGl
	REolJSuqpwdcd3tBghZ8ao1sTFwNIWg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761116925;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EiqzOTcD6BeiMm0m3Qik1jWulQ22mecGBwnXl3IAyTY=;
	b=je/MybQn3PHBim9ffU5JgGUHSwMYAjfNS7uirlQ8S7PQ57MsfShgooOxVdE8ZNMYzOrzId
	zN/00VF0MkMeMlCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D3C401339F;
	Wed, 22 Oct 2025 07:08:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id M23uL/yC+GhCAQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 22 Oct 2025 07:08:44 +0000
Date: Wed, 22 Oct 2025 08:08:42 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH] mm/filemap: Implement fast short reads
Message-ID: <zuzs6ucmgxujim4fb67tw5izp3w2t5k6dzk2ktntqyuwjva73d@tqgwkk6stpgz>
References: <20251017141536.577466-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017141536.577466-1-kirill@shutemov.name>
X-Rspam-User: 
X-Rspamd-Queue-Id: 802E220003
X-Rspamd-Server: rspam03
X-Stat-Signature: 1cizftjbixsem4yy94o3ijpq8dftg3rk
X-HE-Tag: 1761116935-543618
X-HE-Meta: U2FsdGVkX1+PS5H7cn40pSApG7Z+GVTXqUa2q2aynzonEwZarHbhcWvr3bbqcsoopOb/wInma2qHB4E6e1HU5EUgE+23E1MCBGTafF+pBb5zxJUs1++UQQueUP7zwPJYnBaVf52fd80vnKKE3sK+Pu6NzDwNI5jFou5lY3/Zv3hUUPaD/yjIb7lGqY//KABv6pvSKS0WDKJU3xMzQ1t2aIdIrJM23uymVgY6D4vY/Lcj9wEviGXHXFzWvOMsxsr549CBwBLLDniDMLHV4wuYutmWc8OWGZtQjvZb81OkUjES7gNjpxHc9pHgDsiOnlvGtcvj1NFZWJFScv3p8a8BBmwZoUwE5ILmhBa45LKKXL4OCNRhqEVLygfPj29dfr/jyO6K2KqAeNGtqcttQV/TLKLS2jU4ifF6yG9pjsxYM/yAR228jY+0arqem2j5r2INGMc/MPYHvJ8z6sWAw5zy6iR/QqAknE2EQG3dwTsq9LC8UulF9O3vOcxia6ZyDFAWi+KPuF1Uu1lgKSeZF8kPpxBM7UB32tlgvqfovNFhGOO0sYlI+SrHtUoXPF0PqErizI+PKX8EQYC1aTSFyj+LK7Fz9xtk00LM8yTD5FaYtTkD28ehJSxMi3f2sPXF730FmCJQ6pWl2KBX/czMyYMWQsecI5uuywFUvedwqguWtnzStQN/LVxSP6zD0W/quob0FbvOj7TfHX04lJva5CJqC5r+yY+k2wqg+8bJp1z3gp9jboHYd6ou0sN6scNYMioYTcPCL2MAKkDGcAul4Gsxb+iq1cdbAnJkk82oz6YMGwamddbXdV+7AwQH0+pnfoUE/UMAH4LU7xj7l4l2pv2sFYqG+ix0yKsolTSxguEcROS4KukseXKyHFCHmW4XsGfboryX5wZp9mwhcpOVykWJx1sW+rf16OCh6amlM9siKEFEwki1y2s8Y/ytXU62rAY7qX7jGHSUjxHJvNnCWh2
 I7Y9+KfE
 7nlKVOu8WahHZOvlQc52Djb0mtl34VA/3wsx5mi1btIh81Icf8/D3+hMQe4czK4DtYoxBl9b8QmKzWvYQBktqnJANbANKZZeQrI3KN6vQ+ArCeRzmNhrQJtzzk0SGBr69drCz5O4+ZV5QFq78W5U6bfcwoVwS+dJY5a8rygv1YWb5Zq4+dSAFWGLJKZT6itHpBxSSi/DfbDQwVPZ+/ml51SiaKTXZaxOQCyMFLR2tLyAO9/qCcpQm4sOutAHA/8dehw8X1eUOeWMC5NqRxBHZDuQgbw1eBDDvvl7g5AzhUz/mg+iw/q2tMyUt3Nh3Nrk+kG+ZB2MKI5hbkKg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 17, 2025 at 03:15:36PM +0100, Kiryl Shutsemau wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> The protocol for page cache lookup is as follows:
> 
>   1. Locate a folio in XArray.
>   2. Obtain a reference on the folio using folio_try_get().
>   3. If successful, verify that the folio still belongs to
>      the mapping and has not been truncated or reclaimed.
>   4. Perform operations on the folio, such as copying data
>      to userspace.
>   5. Release the reference.
> 
> For short reads, the overhead of atomic operations on reference
> manipulation can be significant, particularly when multiple tasks access
> the same folio, leading to cache line bouncing.
> 
> <snip>
>+static inline unsigned long filemap_read_fast_rcu(struct address_space *mapping,
> +						  loff_t pos, char *buffer,
> +						  size_t size)
> +{
> +	XA_STATE(xas, &mapping->i_pages, pos >> PAGE_SHIFT);
> +	struct folio *folio;
> +	loff_t file_size;
> +	unsigned int seq;
> +
> +	lockdep_assert_in_rcu_read_lock();
> +
> +	/* Give up and go to slow path if raced with page_cache_delete() */
> +	if (!raw_seqcount_try_begin(&mapping->i_pages_delete_seqcnt, seq))
> +		return false;
> +
> +	folio = xas_load(&xas);
> +	if (xas_retry(&xas, folio))
> +		return 0;
> +
> +	if (!folio || xa_is_value(folio))
> +		return 0;
> +
> +	if (!folio_test_uptodate(folio))
> +		return 0;
> +
> +	/* No fast-case if readahead is supposed to started */
> +	if (folio_test_readahead(folio))
> +		return 0;
> +	/* .. or mark it accessed */
> +	if (!folio_test_referenced(folio))
> +		return 0;
> +
> +	/* i_size check must be after folio_test_uptodate() */
> +	file_size = i_size_read(mapping->host);
> +	if (unlikely(pos >= file_size))
> +		return 0;
> +	if (size > file_size - pos)
> +		size = file_size - pos;
> +
> +	/* Do the data copy */
> +	size = memcpy_from_file_folio(buffer, folio, pos, size);
> +	if (!size)
> +		return 0;
> +

I think we may still have a problematic (rare, possibly theoretical) race here where:

   T0				  		T1						T3
filemap_read_fast_rcu()    |							|
  folio = xas_load(&xas);  |							|
  /* ... */                |  /* truncate or reclaim frees folio, bumps delete	|
                           |     seq */						|  	folio_alloc() from e.g secretmem
  			   |							|	set_direct_map_invalid_noflush(!!)
memcpy_from_file_folio()   |							|

We may have to use copy_from_kernel_nofault() here? Or is something else stopping this from happening?

-- 
Pedro

