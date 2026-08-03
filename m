Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CCB4C55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:34:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0FFA6B00C6; Mon,  3 Aug 2026 09:34:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE6A86B00C7; Mon,  3 Aug 2026 09:34:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FD666B00C8; Mon,  3 Aug 2026 09:34:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7ACE16B00C6
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:34:04 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2BC8AA1FE4
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:54:50 +0000 (UTC)
X-FDA: 85059499140.15.0B1CCD3
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf01.hostedemail.com (Postfix) with ESMTP id CA2424000C
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:54:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="fHiUgDc/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Lqn1zzlt;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="pDooKbr/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CLT1mS7S;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785750888;
	b=H6RXsh5qqM7vjIJhstnuneQM8qxSZRildV2Cgqr7MrDkm1y2hbhFF05FMXMuEU8pw591m1
	YY/Rkh75G8Qyt7RfwdiUW1mhEkr3mP+AbC2htSHes+FGJ4dbEZW6nzf2CU2unbN/uVIElk
	5rZ6K3xxKyIls2ex5LKV/5PHeAFV5iI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="fHiUgDc/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Lqn1zzlt;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="pDooKbr/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CLT1mS7S;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785750888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iROqidNnIXSZtIIk8nl3VK4dOUo3dfGu6PFD6UoFhbw=;
	b=o+XfYJHXCGz0xynTTaj500518FDPzlL+6QdPmYR+PUJtGIN1XPrrTt5qHqJFi43Q9lZspf
	2B8vfBIy49w62TsVexL4uO98PzpaR81T/pfSIST/1yqtlNBGYMlaK3k26VlEdQQw8KabLy
	VTXa67cstNLq7lwD2H1kAi6U3cqkt+4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9B5F77EFF8;
	Mon,  3 Aug 2026 09:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785750881; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iROqidNnIXSZtIIk8nl3VK4dOUo3dfGu6PFD6UoFhbw=;
	b=fHiUgDc/gBWZNPYTfUL+/RKtJMvY4YDCOJBMBuxQzU5xto7ubw4eaPSQkzSlU46dks7UBX
	ruxnjVfs10OfQlbHXoApIdA1V9BstCp9eGS8uYEWOZo6w+PuO0/uuVZs4UhrgGet0VOHQS
	ALWCsVaUyzTGnAoYHqbDwYDkvPKvxQY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785750881;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iROqidNnIXSZtIIk8nl3VK4dOUo3dfGu6PFD6UoFhbw=;
	b=Lqn1zzltP7SCM9HQ6qrUpcN9jfu8MXAXViLUoliKx+AzkXpws+spjIvH4se097r8DHkyEP
	Kfu4eglMl+CVnBCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785750877; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iROqidNnIXSZtIIk8nl3VK4dOUo3dfGu6PFD6UoFhbw=;
	b=pDooKbr/7Sc7/HRKzOzWRfK+N7685sWi2sBn2+fcCVca6XP+3RJ0SzE+9VqVH3VR9aO+Ub
	RmCm+VpxU6OwY8SqzrioAod+X5fHjMen/sbX/cAD9QfOdkGUoTmtjhfVH57TYfX1Ue9JPa
	elh4I9oIIZ0Mjc4RhC+lll0YdIppR/0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785750877;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iROqidNnIXSZtIIk8nl3VK4dOUo3dfGu6PFD6UoFhbw=;
	b=CLT1mS7SoLb60oRjTZ+JbcfZfJ79SMp450+duotun2UxsMTeGEme3vUvdiIRHgqn4qsUvq
	zAmEZumhqT1xMcAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8FE4A779A1;
	Mon,  3 Aug 2026 09:54:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1MAWI11lcGoWNAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 03 Aug 2026 09:54:37 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 2C4BFA13A4; Mon, 03 Aug 2026 11:54:33 +0200 (CEST)
Date: Mon, 3 Aug 2026 11:54:33 +0200
From: Jan Kara <jack@suse.cz>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Jan Kara <jack@suse.cz>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <hongbohbli@tencent.com>, Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RFC 07/14] fs/erofs: mm/pagemap: add
 readahead_folio_reverse() to avoid folio->private
Message-ID: <332rknj4vo3cfhvfhhlf6pvg37s3lbrnzbbnv4swa6gctsiu6a@ndotgokvnglc>
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
 <20260731-remove-pg_private-v1-7-142c97ba3562@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731-remove-pg_private-v1-7-142c97ba3562@nvidia.com>
X-Stat-Signature: q6hqygdwsbrft15pspxiio8wf16eawkn
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CA2424000C
X-Rspam-User: 
X-HE-Tag: 1785750887-563333
X-HE-Meta: U2FsdGVkX1+at8xMza3c56QJPyYrTdhAn1YZ2jZ7dKOR3Sn7G84Jc6hS3wu2MXcy15pAm3QZUbxHcg4Sx0EGlQrUX/N4Xusxr0s9HvSpwT4bKEXceHiPQV3nIVngFPrU8oQbd4ohvmCH8jOD9u7n5exxPI7sAEaiCTw5S11SZ7nq6WPIN5MkwyMjsaDrQb/76Evjhvbr+nrg3QM0Isrq9vNnmUR2Hkj7SkhErBvXMklJD+aDyxKIS6iHoqoX+pvuX7Akg/sanIgg0RlfeEkR5bpAdFW9YgX87AQs1CDCUq19d85EeQFQB3QFkreAWVVzglsbYCtYPu0M8+M213v4rEWwJ55twK9k5nypK+5c/DOHhq+g/XDciHXrEwBXcICQS3mZaZ1w4htBXPZ3FaCBYI26Mx6k2DrLsESw9u0lC9c12S8sJ0WTaO49igi89DRRCkIXd17Ugz6HFeNplGs8fTaVWUvwZc9RC3+d2QAVdEuAhe1spsQyN8OPlp3E19TrwacAJzTyCi6eIy2jE8KO4dNoRT1J9/SHmSYPA2NOAlTTsQVMbk8cXkrZyrJNQSlCYzjUxRnQf4+1OkB2F7Rtbxwj7AjSlEcjXF3m+TxpZtRfGG+wrsLn5iXWLp4nLyHfDxHc57SbAHhHR6NnG9skCcmr5482QAsj5wFT4PGciq4z+bxe/9a8WwVPT40s67UYmNCO4OVqXsr7SszgwQUwHTgSxGwSEaWEJ8eawSj6VT+K3WF2SrCNjCemkAevbZ5ukDZCThsUH8JYTSgiGZp42wmdBS+B3HRP2LxSwYDX4D06njHKHadye4BM5J1hmJAKyT4x2KZFMCZWmwitxyXmoMyX//uP6SB17hv595Uv1lF+P5N6SKXUn4KyBfaN1731E6aIUIJ4yUCtaecDUqh8zRxYDlCOtjpZw7mq6pGGh3fIfENm5DpBFLdmH1d1AT4Q6thR2SXI3C0NcxRD8mf
 BoDWaw2g
 /p1TJsQTa8EUDkRXowVcqT/JzS8yPw++pTQp+Tnmk9t0zhpQ6e7NWHEdDMXF+C/GsCg/J4VjhYaxpcFV5o/3bA1F3gmkoSoXaoEo1ygrLV744q04nIr4Kh4MLsoctjUL60lpbdQh9XA6Y20ICUZb7w8aCalaQJue95tkb0FIXy8WXR4r4zXR141vhBttuq4F8zZtYj3An8HiNIa6UC6uVqbcBwft2fvviNibUS1ID5jMBBJAPemf9JNl3WX9mtmIdmJQbzFsoF+FAHaI7ZdS8DSZxgqcIFHwoHiy0/9ddfzRiq05EJtURNNEXpRkNFIJju8A8DDFN3RY5zHmdJkOOH0UX5R6bp2Go/SwwJHTwZBm5VHdTfv3zoqmUPIvQUFGQthGrlVp7FTZzxnxH4fv4eM/Onqd0BvkPLOmLbz7G7QKB2/20hRsc/X1GSsYwHLog7EZ9sX5AZ3sz+GF1jpVyZRZPgDgTvZnykEouzwYG9bs+IXoNSgHK8UKmEhNVYdAF2MOMLwKXLYblL2Z09J0eVKVCzg2bKdi5hjHgCEwaVJ34vEhkWoT0mHc1aDHWlInVktgD8csIo3CWjjjWoDAe2b7XDLRMANzkaGG6IBr4KnnS7jRbNF+tLZnXcRKpgb4SbWo7cWYBSMYMX0IqfBF03ACkMxgRGr4B0F0fMsqhW9TYervhLMmWdVon2UVkRoWViXNw1tGXlr/EBW0OFCrVxaig65OO3vAGSIYd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 31-07-26 22:13:30, Zi Yan wrote:
> erofs needs to traverse readahead folios in reverse order to achieve
> maximum performance by
> 1. reading all folios from readahead_folio();
> 2. storing the prior folio pointer in folio->private;
> 3. traverse from the last folio to the first one.
> 
> Add readahead_folio_reverse() to achieve the same function without using
> folio->private.
> 
> It prepares for a future commit that replaces PG_private checks with
> !folio->private checks. After switching the checks, erofs's use of
> folio->private without bumping folio refcount can cause unexpected
> outcomes, e.g., in filemap_release_folio(), try_to_free_buffers() becomes
> reachable.
> 
> No funtional change intended.
> 
> Assisted-by: Claude:claude-opus-4-8
> Assisted-by: Codex:gpt-5
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> To: Gao Xiang <xiang@kernel.org>
> To: Chao Yu <chao@kernel.org>
> To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> To: Jan Kara <jack@suse.cz>
> Cc: Yue Hu <zbestahu@gmail.com>
> Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
> Cc: Sandeep Dhavale <dhavale@google.com>
> Cc: Hongbo Li <hongbohbli@tencent.com>
> Cc: Chunhai Guo <guochunhai@vivo.com>
> Cc: linux-erofs@lists.ozlabs.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-mm@kvack.org

One comment regarding the generic infrastructure below.

> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 4e8b2b29f6d3e..90904a4d173b7 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -1549,6 +1549,37 @@ static inline struct folio *readahead_folio(struct readahead_control *ractl)
>  	return folio;
>  }
>  
> +/**
> + * readahead_folio_reverse - Get the next folio to read, from the tail.
> + * @ractl: The current readahead request.
> + *
> + * Like readahead_folio(), but walks the range back-to-front. The folio is
> + * returned locked with its refcount dropped; the caller unlocks it once I/O
> + * completes. Compound folios are returned once, at their head index.
> + *
> + * Context: The folio is locked.
> + * Return: A pointer to the next folio, or %NULL when done.
> + */
> +static inline struct folio *readahead_folio_reverse(struct readahead_control *ractl)
> +{
> +	struct folio *folio;
> +
> +	if (!ractl->_nr_pages)
> +		return NULL;
> +
> +	/* xa_load() follows sibling entries, so a tail index returns the head */
> +	folio = xa_load(&ractl->mapping->i_pages,
> +			ractl->_index + ractl->_nr_pages - 1);
> +	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> +
> +	/* Shrink the window from the tail down to this folio's head index */
> +	ractl->_nr_pages = folio->index - ractl->_index;
> +	ractl->_batch_count = 0;

Thanks for the patch! Currently there's the invariant that the returned
folio is still inside the _index .. _index+_nr_pages range. I think when we
are providing a generic helper, we should keep that to make code more
robust for the future when more people start using it.

What I'd suggest doing is add bool in struct readahead_control telling
whether the last folio (batch) was taken from the head or tail of the
range, advance _nr_pages and _index accordingly in the functions returning
folios (probably hide this in a helper function __readahead_advance()
because it will be used in 3 places) and maybe call this new function
readahead_folio_last() instead of _reverse() (but I have only a slight
preference here so .._reverse() is ok with me if other people prefer it).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

