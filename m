Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5FFBC5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 11:20:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9F4F6B008C; Thu, 20 Aug 2026 07:20:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D78746B0092; Thu, 20 Aug 2026 07:20:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C66406B0095; Thu, 20 Aug 2026 07:20:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A13406B008C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:20:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3DAD3A355C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 11:20:44 +0000 (UTC)
X-FDA: 85121405208.06.C9C901E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id 00E98160002
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 11:20:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZF3erbxi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OfVmpSul;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="DT/kVxbG";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=paRH9hh0;
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787224842;
	b=b95lP7d9W7AtNHhysLokGb1k9GTeHZDFrKcM0DM30o35CkhO1MbOrW76tSoOpyDA1jJlzI
	A9DpWQsDtAEylL/4cK47TFc5319k+pQT+gbULXQ6Bn0xlbP+EheGM9br5cQ3TkkfyIWFuW
	5y/Gf1KvgZUwzNLg5bPnfKyXNRNlftM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZF3erbxi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OfVmpSul;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="DT/kVxbG";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=paRH9hh0;
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787224842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tk8jiJdcjWsP4GhLOTgEUqckIP3KNVGr11ane1BhbCI=;
	b=OD9WmdgSYAhqX6l0kQRHKet25sYdo7RkhH1jsook3s0z1iDff4PAQfb0p3dBIw6xLJ1bCC
	AdOHcfvgak0nsaP1fkJZlvNhdjyefy2yij8RP6yquCRGITbvNW2rXnbi66xh7+iekbwhjN
	dqBo/oVcOeETrzDVgrn4b9XwD75C63k=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 33D3385041;
	Thu, 20 Aug 2026 11:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787224836; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tk8jiJdcjWsP4GhLOTgEUqckIP3KNVGr11ane1BhbCI=;
	b=ZF3erbxirjWV5nK4xzrbZfVT2O07TlMViOfP300cWFayelaGeKLsNk8LnWhR0Ub7k9Qb0r
	esXasTH/LcTKHRpHhiBDPkefP3+BiSJuymIMfBYJWFBrFTsWp6dMRjktRnWlTBBfA0lzyv
	ABcue/sUx+mR+asrIVKnVEr9HXvR5gA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787224836;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tk8jiJdcjWsP4GhLOTgEUqckIP3KNVGr11ane1BhbCI=;
	b=OfVmpSul/tf1tTue3qzy23FO6thfCUnoi31375KiZboJV0+JrSzTGv9ZiTW9r5KZjK6MlF
	8Ju7a+e/DDu4G2BQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787224832; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tk8jiJdcjWsP4GhLOTgEUqckIP3KNVGr11ane1BhbCI=;
	b=DT/kVxbGZ9DAq4jap/S4imDE9t9bAwAQIWRYYy2h9s22K3c+L9qQAioHE2McDQ2FMCPQTo
	zQhroHvJMkycZODk3BZWf/D8izEYAb7d+3jrrqcUhUisGx7dq6nwBowXSA7ETEsaXuOVIN
	xvNIQoA+rzKFVKJfwzIicxW/XwndYTA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787224832;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tk8jiJdcjWsP4GhLOTgEUqckIP3KNVGr11ane1BhbCI=;
	b=paRH9hh0L1JywzeFQYaxAykZpRkx60X7NaCFq9r4bRRR7t0I2YZz5z8TOP+nrnrNFb6FhF
	xoY44CJ2ozOSn9Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2336D27A8;
	Thu, 20 Aug 2026 11:20:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VUaWCADjhmq9MgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 20 Aug 2026 11:20:32 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id BB7A8A13B9; Thu, 20 Aug 2026 13:20:16 +0200 (CEST)
Date: Thu, 20 Aug 2026 13:20:16 +0200
From: Jan Kara <jack@suse.cz>
To: Jann Horn <jannh@google.com>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jeff Xu <jeffxu@google.com>, =?utf-8?B?VGhpw6liYXVk?= Weksteen <tweek@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] proc: refactor /proc/$pid/mem to use struct as
 private_data
Message-ID: <2vwbng2vmyvssphmthcuzuicpfv2e3oe6ybbakct4fcbachjdr@ixzg6tvsjccu>
References: <20260818-selinux-pokemem-v1-0-90cd2357ee05@google.com>
 <20260818-selinux-pokemem-v1-1-90cd2357ee05@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818-selinux-pokemem-v1-1-90cd2357ee05@google.com>
X-Rspamd-Queue-Id: 00E98160002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: x3bp7j64hnikqo3j9ptm5r9d7ffeig4s
X-HE-Tag: 1787224841-657298
X-HE-Meta: U2FsdGVkX194P461nD/YaxkhKDJ11TcHJi8WbeM96xVI3e7Pa+03kJ3Hq4O8XBrJj+m7GkD7M5vai+r4aFBp07xif26HeK8eAYxIj2aMqMAxhPC0wwa774yhqfjZfXryU6+xkWU5Vzz6uvdVa8BMTx074ktDJMUHeouvHsBNDtcb77RxHta9o1xkK1FSZH1BNGKcGXto3OO0khr7w7CzZGDRfs+C7PCeVAEKviGXyqzzD/gGv8FAnhmYig6r5FExR24RUYdXZQr2De1ushWm6rucB5Q6a6GS5ZVyit9K/iUrKkhN8DIXFT3gWa2kkS/JCv8aMybRzrq+87TNKDCoc5OxjdXsI5nsV6bCBkyQDQDRjf4sLc9ytwzTqPvXPLKOnUBLvrwtJUZ/JrNS8GB4vM6WIsVGZ7P5NoGAEH63fWdMLQnhmjLR1cd60UY7DdqFKkBprmUlX2EFe6+9fSsqL/2v5gYRfKj2OGcV4Sgu6J3KKzKIez3OQbWI3qMB0bY6OUWKTnrs9eLIdkj6jlLGYs4QvbDDgXvYbG7rJ8EDLBEr7IaAhkW6kfTh8rDe75gHmHWeX1cPI71sU8p+Cqh7Gtj0uUj3r3vuss1DxDSbznNikK+/BTUM90yE0KDqZTNlQokvy5KTUWDGsyPFM5YIiWWNp6x2g/g3E3Ee+sbEXbIEX5AZwsDUkLCgb6qB8HDdstiTFOHI5TnDFVPVtfYFumnlM7TsRzQYJs+GrtNbwVBVonNMJzqkMoCLPTJvaSqngwIQOnQ5jRx2f59ylEqHJFdc75iMzt8A4irdQPpdIumK1YwMg+ok92g7OV0zI8Zn1x2EoaZ7nQyWcoMc6lOW0U+vSqq+D+7Rd46LeHEPCI7L04ah5Wnc3mdGV8HU4BZNfp4osnoJR8+UURiAv9pq5auZz1+YwTggKNN/+bgwbbu6GZy99mM05ekESV010GhcRJGKF2Blc69gSmQyLv3
 SkgPfJCM
 ZDCQnasnKAwbjFwSXu7m2c/JHg3ziKkl3AXYHbNr0hX8jqlwOlJwpcHFN1ILHhTBJZh3NIfbj8yNJ1fQEf2+ASZ2IbmLtBe+89un4rpETetAwVCQ7ZXbv1e0AFmNs5fwoubVH5v+vEjlMTnzaPQLRop2Sm9EGgawEVb+Zo1K5VbiARAb9wlM1VBmfRppPBMNlOtx/Q2SXQabQZE9eaoBitnorpy6O3p6qJVFZCT2owcWRb8VZfuSB9rEmfn0S71p4xDfxkeAJQWmcTNEEr+zO4iBkS8hCTjQHo7Tdhf0h39E37j51Nwazt3czxV3qTVeggHUM//6YdVmPbbEAqkNRkRioprCSVcyOIJo351Wu8UrP010nICZunZc3yt0ASsHf/V+pyQGI/04V1nmGDRYHJVGG+U2SYEHgjEh/LK3P0dAwQu8Wfmjbbc8diVWjccVP5xV8wQoGZojROPGgOKZUCvi9N8zaoAeiLZDi2AOyQA9QQxwkWwKbrOZdA72wwxDCa75hhCD1gEt7Wzr2Wat7G2uAZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 18-08-26 21:51:05, Jann Horn wrote:
> Refactor the handlers for proc_mem_operations to use the new struct
> mem_private as ->private_data, rather than directly storing an mm_struct*
> in ->private_data.
> 
> This is in preparation for adding more state in mem_private in the next
> commit.
> 
> Signed-off-by: Jann Horn <jannh@google.com>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/proc/base.c | 29 ++++++++++++++++++++++++++---
>  1 file changed, 26 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 780f81259052..bec6197329dc 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -848,11 +848,24 @@ static int __mem_open(struct inode *inode, struct file *file, unsigned int mode)
>  	return 0;
>  }
>  
> +/* private_data for proc_mem_operations */
> +struct mem_private {
> +	struct mm_struct *mm;
> +};
> +
>  static int mem_open(struct inode *inode, struct file *file)
>  {
> +	struct mem_private *priv __free(kfree) = kmalloc_obj(struct mem_private);
> +
> +	if (!priv)
> +		return -ENOMEM;
>  	if (WARN_ON_ONCE(!(file->f_op->fop_flags & FOP_UNSIGNED_OFFSET)))
>  		return -EINVAL;
> -	return __mem_open(inode, file, PTRACE_MODE_ATTACH);
> +	priv->mm = proc_mem_open(inode, PTRACE_MODE_ATTACH);
> +	if (IS_ERR_OR_NULL(priv->mm))
> +		return priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
> +	file->private_data = no_free_ptr(priv);
> +	return 0;
>  }
>  
>  static bool proc_mem_foll_force(struct file *file, struct mm_struct *mm)
> @@ -880,7 +893,8 @@ static bool proc_mem_foll_force(struct file *file, struct mm_struct *mm)
>  static ssize_t mem_rw(struct file *file, char __user *buf,
>  			size_t count, loff_t *ppos, int write)
>  {
> -	struct mm_struct *mm = file->private_data;
> +	struct mem_private *priv = file->private_data;
> +	struct mm_struct *mm = priv->mm;
>  	unsigned long addr = *ppos;
>  	ssize_t copied;
>  	char *page;
> @@ -970,12 +984,21 @@ static int mem_release(struct inode *inode, struct file *file)
>  	return 0;
>  }
>  
> +static int mem_release_with_private(struct inode *inode, struct file *file)
> +{
> +	struct mem_private *priv = file->private_data;
> +
> +	mmdrop(priv->mm);
> +	kfree(priv);
> +	return 0;
> +}
> +
>  static const struct file_operations proc_mem_operations = {
>  	.llseek		= mem_lseek,
>  	.read		= mem_read,
>  	.write		= mem_write,
>  	.open		= mem_open,
> -	.release	= mem_release,
> +	.release	= mem_release_with_private,
>  	.fop_flags	= FOP_UNSIGNED_OFFSET,
>  };
>  
> 
> -- 
> 2.55.0.737.g08866a6d13-goog
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

