Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07910CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 16:19:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72A436B008C; Mon, 25 May 2026 12:19:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 702E86B0093; Mon, 25 May 2026 12:19:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 617C76B0095; Mon, 25 May 2026 12:19:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5330D6B008C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:19:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 18954A018F
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:19:48 +0000 (UTC)
X-FDA: 84806453256.28.D5A6802
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf19.hostedemail.com (Postfix) with ESMTP id 017E01A0004
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:19:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Vao39Koc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=X+iqXEgu;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Vao39Koc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=X+iqXEgu;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779725986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q0bzF8+BTIPG9AapbSXflhyEvFRKzijZ8O5Qxt+U1yc=;
	b=zMbV1ypDCACywuiLXfwM4eqbZXJyXNpHBExDjeKE+j+S8+Dx2++mRuIeLEBMYGvgqssmnD
	cko6+mPcqVU97SVFQGa+i8j1Svbcezls6LjHw4kaoa3wv6fEjSpCtIACBRwAQ9KsIMs878
	PFf5RuuZAcXqhsA2FhSgYmmY4DgsPrg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779725986; a=rsa-sha256;
	cv=none;
	b=oM77A+Awroais8SJRkVehH6PG4al68frnXw5HJfk3x9e8JprwoYyzmQpmDC2I3GzXhYu4X
	q254XWTHbEXtc70HYKz+W0oi1VYpREqaIrDbdb/8GAf7pbTrgTqwnvbPx5DUE+jTZ07III
	Uyjzd2Yzz4nd5GT48kkkpOfgwN3WMxU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Vao39Koc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=X+iqXEgu;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Vao39Koc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=X+iqXEgu;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8363D67D6A;
	Mon, 25 May 2026 16:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779725984; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q0bzF8+BTIPG9AapbSXflhyEvFRKzijZ8O5Qxt+U1yc=;
	b=Vao39Koc19S3W9vSa6fHGtrHU/f1z+4hFz3tzWjes36lSH4XTdS7NPuFi6KnTjjKDR6Iuj
	xN+dp4CaS6hVf8pzDt9r7/Mc2xY3Qy1hjw7vPIfVv2GNNhvDLOQeYktnfp7551tq5SWTDq
	0iDqw3Zql16Ez+5T4jz8WSBOr1eYarE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779725984;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q0bzF8+BTIPG9AapbSXflhyEvFRKzijZ8O5Qxt+U1yc=;
	b=X+iqXEgu/pq8XEDQKnLjwQ093zBBjPeH5v3oL08rHlxIn4hAPKgllEeo8opirLG+WJB0Ed
	LrK2oQ7z7ltNADBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779725984; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q0bzF8+BTIPG9AapbSXflhyEvFRKzijZ8O5Qxt+U1yc=;
	b=Vao39Koc19S3W9vSa6fHGtrHU/f1z+4hFz3tzWjes36lSH4XTdS7NPuFi6KnTjjKDR6Iuj
	xN+dp4CaS6hVf8pzDt9r7/Mc2xY3Qy1hjw7vPIfVv2GNNhvDLOQeYktnfp7551tq5SWTDq
	0iDqw3Zql16Ez+5T4jz8WSBOr1eYarE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779725984;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q0bzF8+BTIPG9AapbSXflhyEvFRKzijZ8O5Qxt+U1yc=;
	b=X+iqXEgu/pq8XEDQKnLjwQ093zBBjPeH5v3oL08rHlxIn4hAPKgllEeo8opirLG+WJB0Ed
	LrK2oQ7z7ltNADBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 70FD159D27;
	Mon, 25 May 2026 16:19:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MSSuGqB2FGpuIQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 25 May 2026 16:19:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 13460A08D7; Mon, 25 May 2026 18:19:44 +0200 (CEST)
Date: Mon, 25 May 2026 18:19:44 +0200
From: Jan Kara <jack@suse.cz>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, Viacheslav Dubeyko <slava@dubeyko.com>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Dave Kleikamp <shaggy@kernel.org>, Theodore Ts'o <tytso@mit.edu>, 
	Miklos Szeredi <miklos@szeredi.hu>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Breno Leitao <leitao@debian.org>, Kees Cook <kees@kernel.org>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-ext4@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 13/17] fs/select: replace __get_free_page() with kmalloc()
Message-ID: <flztdmhjmz5zp4podujx7ekdxa7qbx4pp2iz37ji2tltyyhzn3@jsikvofbhtbu>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
 <20260523-b4-fs-v1-13-275e36a83f0e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260523-b4-fs-v1-13-275e36a83f0e@kernel.org>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 017E01A0004
X-Stat-Signature: 39gr4zx4b8arzfnjxsurh1ooowm6woz4
X-Rspamd-Server: rspam06
X-HE-Tag: 1779725985-288245
X-HE-Meta: U2FsdGVkX1/juKfV00jGC7j/1XyH2tZkcR6Xaadm98K2SSCvbSxAQWoFI8DTqvdoVtxh2jfalZPmY8dLfzrCFZeEKUViyXRyHojauhkezSb8iP5/wdkLCITPEJZguDrg5pw7o1dOu+C0aRboYDM6vND7042rZRrCGNkM4Yri4PPySpxATORubjzA5iiP1+kXp0UeATtqZXbFopqkClOvKPe1iqlpWjpePXhD6pBBkiXDmsYxFeBT0RYxFXLSF39kLc0SqZZK+jFFwo8ZOgeRsrY4F+zkyZRY4szUtmhxJeUCbOmx/sYLglbUGNerlpBCpzaqyot579vuAZQUkNQgAagJQ5lMOV3ibs22nYGCfNvy6poB9PldNFEyKTAyU1pX07ZrYriXoPXFg4XU0NV5KCsKdUyqA70sPL3rFOwrFhIp37uMuKolFKGhVQviFAT7ITKKtgS8wGgCdXcgLahhTW15Rxp/uBq5Pdz7dGqC1Vk7AnB0CqmT0jgyOf35/kRABNcV2oJ3Bei5JQp4Kl5UmgCi4Pi582kcM5iI/pqzrp4i2/pw8NYDMz2aJY2IzGCzsTUX8FQg2l9MFcnQ9kHgkEnp85XR4IQsrRm8fixxjvLvLCmAhFQZC95fiVx3wQmB8cXa2lCUMzryhLmEVvcHWFiI71b5Am0TvJecaAHtfaadGxw2I4QEHVe68vEZTJEth/4tU8DUSXzaWFXoOVkbIjUTj174LAuOtSIu/SVp5MkOtJoNTQu8LrPXTGX6Y7oY09QkZxVuOCvwgtqERlKVsL6AnLH1GoCNc/ARbT6CszIohg/NLN3DL9pl7AmgLtXZhOeKmWIN2PgLaR4FjTh7lHZfGn1LqIyHpBO/zjJQ7r/wFfW9Tc10UXUgJf66o4x+QkJLYGvDlmMY9c1X1RUFTtGDX6U8+0qlZF/pxpuSsTiUEemtor3yqZnTuSgzdI5Uj7xMpMCoV8u+mjHypVu
 cEKjH5V0
 utS7S2xSYDW83Yh95ZSeOR6+wg4mgrRM5bX05A9cwYeQxwAwF/0s6g+0Oo2JxnbKZi525sLrzIQ7nUpF8V0VYOlnXtLO/iGPisj/L9fFiZgeqcekFPhcn2D9TyMc4vjW0KacLImQsmmGapLSUGUg+VoDGwIInfORf2TOGxc7zDMaRsP3n4LLFKg92Xd4uqXW3va8l4Q8eZk5WPnpaqGUM3oYI2zCPsh11d0fXq3W/47v672fitRZ37QH/CPIxRV2XrP5pOmO3Tq/ni5blwUx/6XjLv4jfQ9+hywKPM3svMBe1KqF4lBtAHKAroS1knkY2BxUng252esoyNTOQs2EVbpJ6WTC+a4E/+bsgPOqja5OlNrlbVRrQvyzVwMjbvvrp+UOF31KQJZBua3ws7JnbJ1kYRz0afCH7qZAHpdoUzF/yoUfaAoGOpkmCyz823l8o8rUbUEl2JUzPZslSfMFLl1bh7drzOKWyldv1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 23-05-26 20:54:25, Mike Rapoport (Microsoft) wrote:
> poll_get_entry() allocates new memory for poll_table entries using
> __get_free_page().
> 
> kmalloc() is a better API for such use and it also provides better
> scalability and more debugging possibilities.
> 
> Replace use of __get_free_page() with kmalloc().
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/select.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/select.c b/fs/select.c
> index 75978b18f48f..6fa63e48cdee 100644
> --- a/fs/select.c
> +++ b/fs/select.c
> @@ -150,7 +150,7 @@ void poll_freewait(struct poll_wqueues *pwq)
>  		} while (entry > p->entries);
>  		old = p;
>  		p = p->next;
> -		free_page((unsigned long) old);
> +		kfree(old);
>  	}
>  }
>  EXPORT_SYMBOL(poll_freewait);
> @@ -165,7 +165,7 @@ static struct poll_table_entry *poll_get_entry(struct poll_wqueues *p)
>  	if (!table || POLL_TABLE_FULL(table)) {
>  		struct poll_table_page *new_table;
>  
> -		new_table = (struct poll_table_page *) __get_free_page(GFP_KERNEL);
> +		new_table = kmalloc(PAGE_SIZE, GFP_KERNEL);
>  		if (!new_table) {
>  			p->error = -ENOMEM;
>  			return NULL;
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

