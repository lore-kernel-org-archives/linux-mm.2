Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1416E606A32F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 21:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=fUzE4Bey;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=KVNiJYe5;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=fUzE4Bey;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=KVNiJYe5
Received: by kanga.kvack.org (Postfix)
	id DABAB6B05B5; Mon,  2 Nov 2026 16:47:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D84A86B05B8; Mon,  2 Nov 2026 16:47:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9AE06B05B9; Mon,  2 Nov 2026 16:47:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 928EE6B05B5
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 16:47:48 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 12379140221
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:47:48 +0000 (UTC)
X-FDA: 85391516616.20.265F9A0
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id F2E5E1C0004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:47:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fUzE4Bey;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=KVNiJYe5;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fUzE4Bey;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=KVNiJYe5;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793656066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hm+ytWjWmjwRRRqkaZgxMRCNpo3ZO0Yg6C7lgInlKnY=;
	b=5I01661TCDp4Z8A+8zYjMFYkdzERDduuBbK+dVDO1LuEL2ECbYs7lKeI1/Rsq71T+5VdVE
	WReuvpxjH94yzELHy4NfMRJMPxv1TagthNZBsyDS8SkQBAbXsHZuFhJhjxx17Rg+3wVEMc
	kdbhQLlaIidA5bb38JhmURsthGHA3ig=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fUzE4Bey;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=KVNiJYe5;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fUzE4Bey;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=KVNiJYe5;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793656066;
	b=m/qd732dI/FEr2N8BM78fojlSeQ+v4I7ikgEy06IPSM0YMKYdoa5QgW7ZnV8c05KnEGZ71
	+RAsqUAaEKv8VcX7dhjjlYZZOIAL48UprjVeNhDAQ0+C/hQnKz4VXGypObqNJHkTn8ux0s
	S775nSsCBFSeOu2vzLlA3mkUHj4hfWw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 66BC021FAA;
	Mon,  2 Nov 2026 21:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793656064; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Hm+ytWjWmjwRRRqkaZgxMRCNpo3ZO0Yg6C7lgInlKnY=;
	b=fUzE4Beyy/9uaHzBHgm0a/0E9WDXX2YUGoq3mmbuxpzbD76cPpX00HGegTJTQvIUeu3aSX
	9QaCFiOtAFIK+PsS3+jgF4iHKXlM3uWZtzXjDVna3uRaFKqtH1Tm2I8CDtW2ZPP8mRHMOw
	wnRnssT1EZOqce3XIy2EwC4Riq8usXQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793656064;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Hm+ytWjWmjwRRRqkaZgxMRCNpo3ZO0Yg6C7lgInlKnY=;
	b=KVNiJYe5dBXqQS0Zoj5dO/MULZaRCLCLai/0Rde7pMHM3IPbvZnP6m6jmT1uffD6SNnlxa
	omPZYJIG1NVqnFCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793656064; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Hm+ytWjWmjwRRRqkaZgxMRCNpo3ZO0Yg6C7lgInlKnY=;
	b=fUzE4Beyy/9uaHzBHgm0a/0E9WDXX2YUGoq3mmbuxpzbD76cPpX00HGegTJTQvIUeu3aSX
	9QaCFiOtAFIK+PsS3+jgF4iHKXlM3uWZtzXjDVna3uRaFKqtH1Tm2I8CDtW2ZPP8mRHMOw
	wnRnssT1EZOqce3XIy2EwC4Riq8usXQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793656064;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Hm+ytWjWmjwRRRqkaZgxMRCNpo3ZO0Yg6C7lgInlKnY=;
	b=KVNiJYe5dBXqQS0Zoj5dO/MULZaRCLCLai/0Rde7pMHM3IPbvZnP6m6jmT1uffD6SNnlxa
	omPZYJIG1NVqnFCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3DDF1134B3;
	Mon,  2 Nov 2026 21:47:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vkdUCQAF6WplAgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 02 Nov 2026 21:47:44 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id E6688B17D; Mon, 02 Nov 2026 22:47:39 +0100 (CET)
Date: Mon, 2 Nov 2026 22:47:39 +0100
From: Jan Kara <jack@suse.cz>
To: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Krystian Kaniewski <krystianmkaniewski@gmail.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/filemap: stop fault-around when the walk steps back
Message-ID: <kppowwph3bjl6qnbzmoq5zdjplt5eebiuweuvrm7wa7dqfhgt7@sj7kyq2ja3nh>
References: <20261031-jf-mm-filemap-map-pages-lower-bound-v2-1-21029744e589@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261031-jf-mm-filemap-map-pages-lower-bound-v2-1-21029744e589@linux.dev>
X-Rspamd-Action: no action
X-Spam-Score: -13.01
X-Spam-Level: 
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F2E5E1C0004
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 7gpo1mwroeootsuf4kbayor8qybifxxm
X-HE-Tag: 1793656065-686922
X-HE-Meta: U2FsdGVkX18xxMqtHfCD1jtQ2McDGiz6PZirpzOb+yx05eu661u7QwMxVEC2L0qeszXb7ZyuZvgNfhbcln9PXZOpkQGCFe1VpXwV6qv46mngHjKU7oykMMwvQ99rPEd4Zzo/NE91ev+/aZu1oruq/OCJVUfNqjoAhGzrRdnx+6CCdbCR51CFzjBOIWGwWmzCKRrGbwvdJpiffA+x5Z75tGTSkhQ37oPWUxk1OfK8mEp4wgXj/umJxaoIUrs0pOru9qsRDeY5kPqrrtlVsH/vJ+gTmERTpdV/BCCkZSqV6NnRLNUM+ILXlfv+k+wGP5A6OrRFawgs28oZMHdTRU+B63LmpQW7dcZWc+wt8UjPUYDiFz/HKQmWp2HkQN4r1h63cfsI1YXK5XK5mXSgrBaeUTk90Squ5CCIX4v1TPxfgqlDm6uchXKUG+HuI/IpqvhtBTRlSKefUjTrcmwhllEC25IgiAdkkygMuNdPA8eMMqHVu939x/7VvRNJ6DH3FhplnW8rWaBDWeYVM7Q4nboASNYaLXM9dAL+oxcarjXxigvfzd7e300o4/0MAEEqvNpIkJcBEBh/ycuyfza1VSQUCE5ZDLVVz9Z+mdzqsTzFF1xyYOR+It4dDwgU3YQP5r2YbfANMcNXf86g+TOnP6fKnUzk1uw8djRcFExnoCHGknK1ibx9Fs1pSZyz4itLwRi5I8auEJhdQzDU7qT8R6SM/3AuxRNtc25ANqvKyV3ay66aYBuU1oNzW+JppBllH1pOE90Q2HXBmMmvraMzUC5UwHcV99KsC7Ke1vK6YwMJbOwTACBQFY5mU9eAGG066gDYdaInZM4Wj6EbfKeB/nfcxoivpXlo7Fi1GJRs0mAG0yLOmzikPXYbu73ExIcLo3WODO922YsjdT++EqpphUSRiH20jHInRZGKEY9cHhT2k2ZuWhH5bdCfnlUeKecuOBrOmIFoTDqJf8sJ9+fdpd/
 JWOIhn8w
 vFBgp8jxHGhijgq8GSV7oRjwypLtD7luJ8deum7vlnhvc62jxFhHp/cPez4RYAGpsqH0Q/JMabwt4PzdCcMmzl5jvFgNbYDAdaxfO3JHd+7kjkQIv3aUaftpDnkOy4kCf0Q1W6pCiAx/FAcoH0yq+YvjkWWF1LuhrH58oKwwQO5OpdgIjhjnBLLf7lTQiH4iddjGv7xLnBe1yH6aTEEOmrZRNneMYDvArlYR/eCtHA0hgrKFYn58Wlak8nAtr5QpDtYFlWAa/SQ7FL2Q4hPgZTwqcXuFj4f/pOSrkucMY/ofXdDUvVBi8v1mSY0ecz2HPdTP9VXw+U8I/axUXgfnuVKQ/lxSCSYSbV4btUbW5dp0TU9w0fgrEwir0ES0BQLP376uNsm90Ik0KpaWexV5wuJNdRLNZJgCYgvLuFqr06Jkokaex96qJCdUWhGfYxE1PI+mpmkxxi7h8ETM8wTHb5w8+og==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat 31-10-26 04:33:59, Jose Fernandez (Anthropic) wrote:
> filemap_map_pages() can dereference a PTE pointer outside the page table
> it locked. KASAN has reported this as a use-after-free read [1]. The
> same path can also write out of bounds. When the stray entry reads as
> none, the fault-around loop maps a page there with set_pte_range().
> 
> Its fault-around loop walks the page cache and moves vmf->pte by the
> change in index. A lower index moves it back. xas_find() can step back
> to a lower index when a multi-index entry is split during the walk.
> 
> [1] fixes xas_find(), but the loop still relies on the walk never
> stepping back. Stop the fault-around when the walk steps back. ->fault()
> maps the faulting page if the loop did not.
> 
> Link: https://lore.kernel.org/20260904121301.200049-1-krystianmkaniewski@gmail.com [1]
> Fixes: 6b24ca4a1a8d ("mm: Use multi-index entries in the page cache")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> Changes in v2:
> - Add Fixes: and Cc: stable tags, and say in the message that the loop
>   can also write out of bounds (David Hildenbrand).
>   https://patch.msgid.link/0a1ad7d2-ff0e-4248-8f03-2a64a9134aae@kernel.org
> - Link to v1: https://patch.msgid.link/20261028-jf-mm-filemap-map-pages-lower-bound-v1-1-0bf126e876d4@linux.dev
> ---
>  mm/filemap.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index b74bc1e5015c..1df776907140 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3968,6 +3968,13 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
>  		unsigned long end;
>  		vm_fault_t map_ret;
>  
> +		/* A lower index could move vmf->pte out of its page table. */
> +		if (unlikely(xas.xa_index < last_pgoff)) {
> +			folio_unlock(folio);
> +			folio_put(folio);
> +			break;
> +		}
> +
>  		addr += (xas.xa_index - last_pgoff) << PAGE_SHIFT;
>  		vmf->pte += xas.xa_index - last_pgoff;
>  		last_pgoff = xas.xa_index;
> 
> ---
> base-commit: 65ba8f34ec886ec72b2c07ddc8cf3d815c32869d
> change-id: 20261028-jf-mm-filemap-map-pages-lower-bound-a623ed8a81c9
> 
> Best regards,
> --  
> Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

