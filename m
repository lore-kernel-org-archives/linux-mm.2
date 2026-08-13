Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04EB6C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 11:10:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 174826B04B2; Thu, 13 Aug 2026 07:10:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 123BA6B04B3; Thu, 13 Aug 2026 07:10:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 012D66B04B4; Thu, 13 Aug 2026 07:10:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CDF5C6B04B2
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:10:53 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B22BC160595
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:10:24 +0000 (UTC)
X-FDA: 85095977568.17.97BC301
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id AA03780002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:10:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="A/Q04QC6";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=z+nSFKCb;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pOKY66lt;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=poqy2DMY;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786619422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kgl9jHe0ZGbfMuJ3FN/ReGeH6xmJZZNK66A/fkMJmts=;
	b=mZl0S6NxZCD09VoWDgfFv0XpD1rTpuhxL+no8uZQ42b3raf673T0NgQKS0YXWVVkU0W+3f
	6VmvXI9DyL8oPXcdNoviLMJWLk0/ZZ5f7BAGmdCNwADD5Dsgvadmgv7yq9BoSyQTNiD2Qd
	DBATQo6AannfYRfuNp8oLsvGP7EXERQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="A/Q04QC6";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=z+nSFKCb;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pOKY66lt;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=poqy2DMY;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786619422;
	b=mRdZdeLrcvgHB8eG5zEqJ1OSyzKV8XB5f3e/dgkpy3L87SAdboX/utrakYjALh0PIJdH3F
	kXCcCGFT32zOibuYX+VuhBVnM562Iu2zyYyPd1P7vEYaWa37p+6zC7AE3B3zKpopZC/NGE
	M+WUICVVyMe7rMtvmbgU+/clgNlVpXM=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4AA363E62;
	Thu, 13 Aug 2026 11:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786619417; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kgl9jHe0ZGbfMuJ3FN/ReGeH6xmJZZNK66A/fkMJmts=;
	b=A/Q04QC6/4Sqpc8DhTPBNqln1rI0fV+o6xu3pY39oKZQ/BqbJQnmbhFTKNYRZ3rrh1wZ/D
	mARXB+zLnRADM8Z7yvmbvlJqzSFMWzz+d56J8Q+zA9G09nNzb1N3ZNzW2VZkFPaAPvUqpK
	CeIs/vMaYvjXvUCJ1fRwfQoadXHhXnI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786619417;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kgl9jHe0ZGbfMuJ3FN/ReGeH6xmJZZNK66A/fkMJmts=;
	b=z+nSFKCbiZVjYphWTnMzCKRBWMZfg54LrgK0g+EnPU7Aev6qGqVRwAAg9izgr0OEVSBubN
	q3gGF90fPci0T9CA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786619413; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kgl9jHe0ZGbfMuJ3FN/ReGeH6xmJZZNK66A/fkMJmts=;
	b=pOKY66ltwNa8NX4f/trwpTqkPwdj/VysdaQNCkuIV1Gutt38Oe5Zc9Aehmm2LdQZVrq/pg
	oLzH8BDe2yBA02fHGihrFw2a98ZUDgHdgmb9GQvwwJ8MXAMKzF3qcCP2Tk+CjcicklnKzq
	3NQz1eNlY3e2LFzpWE+7mijnkI4zWaY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786619413;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kgl9jHe0ZGbfMuJ3FN/ReGeH6xmJZZNK66A/fkMJmts=;
	b=poqy2DMYGfUSGvCindxYJBLwzIma5ewXbma6SgkYVuzYO4cBOb5jPJAbU/WSzUJWQAPOhf
	UEcSHGGWGq4/W4Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6676B77DAE;
	Thu, 13 Aug 2026 11:10:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9RiRFRSmfWozBwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 13 Aug 2026 11:10:12 +0000
Date: Thu, 13 Aug 2026 12:10:10 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <christian@brauner.io>, Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v9 14/15] filemap: Add support for authoritative mappings
Message-ID: <an2l7MPFFcXH_By5@pedro-suse.lan>
References: <20260805210557.1118966-1-willy@infradead.org>
 <20260805210557.1118966-15-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805210557.1118966-15-willy@infradead.org>
X-Rspamd-Action: no action
X-Stat-Signature: oufuq7ab1urpwqe3779ch8qii91j7zwq
X-Rspamd-Queue-Id: AA03780002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786619422-535653
X-HE-Meta: U2FsdGVkX19OiXpOpLDollfmi2dPSZx9k7FUAyxT2P7ju1klDUeznlaNWx64zmpjYIwL01Lcuvxr+FC9nehislKmoUA9H3LW5QY9w6YxelRnB8mJDZw3WpcR53PRmTkgScJW5C9Bcm8Jl6MCnF4W9fHsPNTq6XTupXIwyHqZ8KWQhkc+C8OH3W4w54/vMNbLZg6irxQ63a2iFGTY2dCqpYrB5SNRaFm2qfIh0JR9w9quYYTBhZEZ/VtpDXE4ca+S4vg7mrzLamqCDswmH1CsQIkRvOjgeBkVcsDoSMYO2dEU1NWPawNCSQZyfwUPUOW3NSiZjWmqdyf0+LvKQUU9SWY4L90dpJAOi+owSQBmBncsuh5qN0eV26Qs1hvce8ewScN+T6hyZQOneFSpNa2Lw5w2gYh/WoV/F7YIDM5x9LgYvdJC5hs/+pLN79dDijoxYszAb5xTjxGbV9VkNs48h7tJSHQ4dMqDSb1GBaHNbXlqsHgLILFFbAvxf6DZmVlqVZ2HTA0WrnUz2oE+Hj1l2V/Tp2xFrkC+zDrp8c3HWn2tFRFnC6wce04s6AR2kKhw1jDs9OAMabDXapXyKNLlBr45InNxsHLu5KLP5YDoQ3hgJIompAsmOGpzDuf2krT9uYS7SyAWOdNLZrp1RHt9gG6GyW3a5js4rI5RmWhGTaktOYv4k2nYT/Z4abOf4FkOt0avNWddjak4ZwCzE37S9GqtZbSAD2/erP4AZW6eAiutKZHAVByVtBoDHKs8zpN7hHcJxHcJse8RGRalgJcCuwatbB30dzrEeXcUPyZSkBEByrUMH/rsvOdls+fsyMta1nBawIPUXQo6EF8mkf+73BgNcgFkAdfQ/KXO07ZXF0/AiTnsuTvk5IXaH+51Dx1bWzdTTUr5ZuhrnOzaYdyUGR1KlIQZrzO6kDdAY2fOBblAcs5ps61rGFfbtCbNZRa6XBYdJ5uGqX/P3pnka3P
 SpdT6lP3
 lT0VBzxrNFEMpy7CtYrw/idBIm+JMYnAVXypUt4bt/WYKbOZxRmONtpxARYu4vs8t3YDoMCH/2W946uMmOgB75W0BIie2bEYDPwuMkxrvcp800rgfxdF4Zw7nFgRKbzvfsCLR+V23XVgi21nv7gTJUs8T+6hZpOblVNuaJPXLbS9a2dWEiY6PnViv2w96nUX6SQVxhs3UDyMfT70imVyDoBbqQNT3aB5DlL+7fHuZroVAcT666ZviAlCQnTNY3Wpc5c1EWOVxraG1tTrMAXpbgrteUJWSe9glFzmjo6bZatfzQOiPSchVrUmGcr1Ci+4hrvcODa20lVl3hVvep+nr+jXWgK/xeMChWmAlgHFICP599Vu/a4KwfpU9TpcYLXkSZqdWzoV1AMu012+IQX8EgiAUkNSwRS13n/MGQF+2I6+Gejs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 10:05:54PM +0100, Matthew Wilcox (Oracle) wrote:
> An authoritative mapping knows about all the folios in the mapping.
> If read() finds a missing folio, there's no reason to allocate one and
> try to read it because we know it's a zero region of the file.  We can
> just call iov_iter_zero() instead.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Jane Chu <jane.chu@oracle.com>
> ---
>  include/linux/pagemap.h | 11 +++++++++++
>  mm/filemap.c            | 18 ++++++++++++++++++
>  2 files changed, 29 insertions(+)
> 
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 968b791cfd14..22d48935ffda 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -210,6 +210,7 @@ enum mapping_flags {
>  	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
>  	AS_KERNEL_FILE = 10,	/* mapping for a fake kernel file that shouldn't
>  				   account usage to user cgroups */
> +	AS_AUTHORITATIVE = 11,	/* If we miss in the page cache, it's a hole */
>  	/* Bits 16-25 are used for FOLIO_ORDER */
>  	AS_FOLIO_ORDER_BITS = 5,
>  	AS_FOLIO_ORDER_MIN = 16,
> @@ -345,6 +346,16 @@ static inline bool mapping_writeback_may_deadlock_on_reclaim(const struct addres
>  	return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
>  }
>  
> +static inline void mapping_set_authoritative(struct address_space *mapping)
> +{
> +	set_bit(AS_AUTHORITATIVE, &mapping->flags);
> +}
> +
> +static inline bool mapping_is_authoritative(const struct address_space *mapping)
> +{
> +	return test_bit(AS_AUTHORITATIVE, &mapping->flags);
> +}
> +
>  static inline gfp_t mapping_gfp_mask(const struct address_space *mapping)
>  {
>  	return mapping->gfp_mask;
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 26a5f18121f9..5a8cc20e624e 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2697,6 +2697,8 @@ static int filemap_get_pages(struct kiocb *iocb, size_t count,
>  	if (!folio_batch_count(fbatch)) {
>  		DEFINE_READAHEAD(ractl, filp, &filp->f_ra, mapping, index);
>  
> +		if (mapping_is_authoritative(mapping))
> +			return 0;
>  		if (iocb->ki_flags & IOCB_NOIO)
>  			return -EAGAIN;
>  		if (iocb->ki_flags & IOCB_NOWAIT)
> @@ -2853,6 +2855,22 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
>  			goto put_folios;
>  		end_offset = min_t(loff_t, isize, iocb->ki_pos + iter->count);
>  
> +		if (!folio_batch_count(&fbatch)) {
> +			size_t fsize = mapping_min_folio_nrbytes(mapping);
> +			size_t offset = iocb->ki_pos & (fsize - 1);
> +			size_t bytes = min_t(loff_t, end_offset - iocb->ki_pos,
> +					     fsize - offset);
> +			size_t copied = iov_iter_zero(bytes, iter);
> +
> +			already_read += copied;
> +			iocb->ki_pos += copied;
> +			last_pos = iocb->ki_pos;
> +
> +			if (copied < bytes)
> +				error = -EFAULT;
> +			continue;
> +		}
> +

I was wondering whether this could interact weirdly with EOF, but it doesn't
seem so.

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

