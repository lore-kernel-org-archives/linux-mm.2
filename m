Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22451CAC58D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 08:38:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64D92940007; Thu, 11 Sep 2025 04:38:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 624F78E0001; Thu, 11 Sep 2025 04:38:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53CFB940007; Thu, 11 Sep 2025 04:38:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 38DBF8E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 04:38:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D054E1403B1
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:38:46 +0000 (UTC)
X-FDA: 83876318652.25.FA4CC9C
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8DE3A180008
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:38:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xB4gv7V3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PrOFG9bh;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xB4gv7V3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PrOFG9bh;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757579924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C9OZHv6l97MqIsXfPxgJwmp3fJXxpsxaT+6E3H63F4A=;
	b=vmPQvbuGJxuRFB4nGtj16Vz5neUkuXnxZ3V5ZHyDv4X/tQUNrbz3kzs7yAS9VsPhHT+6ea
	3iqwUnalBQCdKhkZFjYk3KwIY0uNBkeSMFK6+8cTH8IKxw/xlc12TGZVHWOpkeRszGqy6x
	5lw6unTNbYTDGd63DMl94bqvFfYG63M=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xB4gv7V3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PrOFG9bh;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xB4gv7V3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PrOFG9bh;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757579924; a=rsa-sha256;
	cv=none;
	b=laesJBny0dTJbiQ10OmlJGmuZg41wrE0s746vkiVrfSCQipTlE0VoOse8Cjqj7d09XMS9Z
	XR+9+5X5QhYJnMdd1kMfGKm9qRSGE43baJV2HaPuJ0nPJlmS68tFtpLCbpi2X8zNTh8jJa
	RBmACOcscZJo4MZKQztNPgB78Z8uKUc=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9E8A93F958;
	Thu, 11 Sep 2025 08:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757579922; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C9OZHv6l97MqIsXfPxgJwmp3fJXxpsxaT+6E3H63F4A=;
	b=xB4gv7V39AjvzZqhbFvpMeDM5nwbiNwlcCmMOJwTz+PdsznaXJuTdLn3SoDQMoeUWdkeii
	1r2pEaTWog+deAhwvgwTELQPnF8oZ0yYguW4upel7rfdVE+3wrH3qFra+HpwdHuYteaBSS
	arDvuQko9RTMU9ux7Cb1QQtSWsvsur4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757579922;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C9OZHv6l97MqIsXfPxgJwmp3fJXxpsxaT+6E3H63F4A=;
	b=PrOFG9bhllLqFULElo/ImR0TtrXr4AVrHSKP1NkH/s/biYgBBErxRpzuzCM3a8Sfmolf0X
	olWF0zUGczMgn/Ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757579922; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C9OZHv6l97MqIsXfPxgJwmp3fJXxpsxaT+6E3H63F4A=;
	b=xB4gv7V39AjvzZqhbFvpMeDM5nwbiNwlcCmMOJwTz+PdsznaXJuTdLn3SoDQMoeUWdkeii
	1r2pEaTWog+deAhwvgwTELQPnF8oZ0yYguW4upel7rfdVE+3wrH3qFra+HpwdHuYteaBSS
	arDvuQko9RTMU9ux7Cb1QQtSWsvsur4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757579922;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C9OZHv6l97MqIsXfPxgJwmp3fJXxpsxaT+6E3H63F4A=;
	b=PrOFG9bhllLqFULElo/ImR0TtrXr4AVrHSKP1NkH/s/biYgBBErxRpzuzCM3a8Sfmolf0X
	olWF0zUGczMgn/Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8EE661372E;
	Thu, 11 Sep 2025 08:38:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RzXXIpKKwmiAcwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 11 Sep 2025 08:38:42 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4D7CAA0A2D; Thu, 11 Sep 2025 10:38:42 +0200 (CEST)
Date: Thu, 11 Sep 2025 10:38:42 +0200
From: Jan Kara <jack@suse.cz>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>, 
	Guo Ren <guoren@kernel.org>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, "David S . Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Nicolas Pitre <nico@fluxnic.net>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@redhat.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Baoquan He <bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>, 
	Dave Young <dyoung@redhat.com>, Tony Luck <tony.luck@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>, 
	James Morse <james.morse@arm.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-csky@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, linux-mm@kvack.org, 
	ntfs3@lists.linux.dev, kexec@lists.infradead.org, kasan-dev@googlegroups.com, 
	Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v2 04/16] relay: update relay to use mmap_prepare
Message-ID: <q5kr5klayp7wcdv5535etvhfcmsftf2h5pi2nhxjpxsyu4h6qt@e6fidg7kolk2>
References: <cover.1757534913.git.lorenzo.stoakes@oracle.com>
 <3e34bb15a386d64e308c897ea1125e5e24fc6fa4.1757534913.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e34bb15a386d64e308c897ea1125e5e24fc6fa4.1757534913.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Queue-Id: 8DE3A180008
X-Rspamd-Server: rspam05
X-Stat-Signature: 3c3w5qzbh93dk9446ap1ftkzdudhs7pz
X-Rspam-User: 
X-HE-Tag: 1757579924-239192
X-HE-Meta: U2FsdGVkX1+vVkKYJfW+VFzj8ZL0BB3NR8ywYTLz+8jk6wBkQ9wWApnL5dscE+0Z93j7cr4z9/5X8pc1oPNErQI3IbZb+FPsxGRRqkfljixgJ3cWwWG3joPonHL5/BKmlOGFjVrcrFhOzjCMQqLuPCk15AINj85WK+syQ/pyrBTGutUW3ACt8q1fCJ2ne+w6S19j3X3w9fbcCSj1YubuVWpI6NPhvqaZBkIQb0TudKruG3qOoBWtvqkNF8sdrSlxHq5yfAhoTQc4stYCLBJySI2zPnZOTb5unLuzN7yO7AVvHWulXQ/s/+KNwyinkQHS8aD8qzG0dbl/FrIG6uJHtQrDrwp1lUIzNVeM6ynwOQL9yjiQZ0QPiwCoGk+5UWQH4bDPOx8jqiw3beBCXpQ1OSA+LRogH2WEdh0fV4qvhX4lJsxc8yquCv77JzsyTcIA/y3kwexnW0XLAZ5kdf8ZK2rEhXGfkL2rhjwgOfeQn0E4kEjArvMeJ6RfpnD/6CdYd/5X2Aap1KJPOc9zS7ubisk1y5tyOia+e6ZJpUO2SwTmzI89+CNn94/uYHJ/m8mNMfpBVkSnxCM0t+fK94u0lLWn45de3QGaW48VL7S2MlVIWQao56WHbIBdjhmjRkHXFDfdsJenVVw3V/F0n8IHd0o2eI4ZgrPEcjNmT3q5XfRR+8deVWr/iF03chfadh39MzAHnERXT+BxGZpsw6v+cVBTbq2bu9Y6VcREtzzZ8IxQt6eXRo2ZkF5Hi0m4UbsbbuMjXlDRbzUZMLPhmcICz23+oQ6PCtNnfI/wK80GR4zPWHK0bPGWnPHYvPjJS9oE5A+3VpratvdLINbvOuDwvwmCnbjw4Mzn1xer8moVznK5l+IVdM7acGVgY28UvPSIil272LDJgdAjCJIUuBOk0FsUxQ0kXoRKYWYIrEeth4GHrck5YEWMUwcYW+PCC5c37JQLctVwGZ5Sw0r7PdX
 VOX2bfbP
 1p8NKR1ny4gGi+WX450u8X7nz4aKnrwXIh4T/DdhwkGPqVZmLV503fhVqUXJJqvfbsaHznLv3t0LLYEevd+f2VIWTaUNknBIg6CG1wU5WciXYrRWvmy0yUtl0o1D8GnjMRNTcsOqfrTyGEuaow2t0L0k3PrDIAfNvRw/rHDmU9h188RNFOnI9tvLHysOo3C0rIZJMQ/X9WH3VAaldQWNZysl/QpRXfKPeelZx/thmnaqIste26+eAH4fif3M7qM0tG9sgTvEWRQEiIUW+KoX//ngvKunf0FyeL1n5YJiZGkmgoy1WC5pBzfZAtqA8RCdyaYLk/25lUNbFSbPquG/cSdIgoa3QjMsrBcTrZaBlktnTXBD35UL7NlZv/a5FUXpPZpp6ip9/fz24R6I83wEUhH8xdDPrtVrsX7m3p0aFU+NWOMD3RkDC+8Vq7cCnB4+Q2SlIZyhHfL2ff0IeEjC6qvHrkw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 10-09-25 21:21:59, Lorenzo Stoakes wrote:
> It is relatively trivial to update this code to use the f_op->mmap_prepare
> hook in favour of the deprecated f_op->mmap hook, so do so.
> 
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  kernel/relay.c | 33 +++++++++++++++++----------------
>  1 file changed, 17 insertions(+), 16 deletions(-)
> 
> diff --git a/kernel/relay.c b/kernel/relay.c
> index 8d915fe98198..e36f6b926f7f 100644
> --- a/kernel/relay.c
> +++ b/kernel/relay.c
> @@ -72,17 +72,18 @@ static void relay_free_page_array(struct page **array)
>  }
>  
>  /**
> - *	relay_mmap_buf: - mmap channel buffer to process address space
> - *	@buf: relay channel buffer
> - *	@vma: vm_area_struct describing memory to be mapped
> + *	relay_mmap_prepare_buf: - mmap channel buffer to process address space
> + *	@buf: the relay channel buffer
> + *	@desc: describing what to map
>   *
>   *	Returns 0 if ok, negative on error
>   *
>   *	Caller should already have grabbed mmap_lock.
>   */
> -static int relay_mmap_buf(struct rchan_buf *buf, struct vm_area_struct *vma)
> +static int relay_mmap_prepare_buf(struct rchan_buf *buf,
> +				  struct vm_area_desc *desc)
>  {
> -	unsigned long length = vma->vm_end - vma->vm_start;
> +	unsigned long length = vma_desc_size(desc);
>  
>  	if (!buf)
>  		return -EBADF;
> @@ -90,9 +91,9 @@ static int relay_mmap_buf(struct rchan_buf *buf, struct vm_area_struct *vma)
>  	if (length != (unsigned long)buf->chan->alloc_size)
>  		return -EINVAL;
>  
> -	vma->vm_ops = &relay_file_mmap_ops;
> -	vm_flags_set(vma, VM_DONTEXPAND);
> -	vma->vm_private_data = buf;
> +	desc->vm_ops = &relay_file_mmap_ops;
> +	desc->vm_flags |= VM_DONTEXPAND;
> +	desc->private_data = buf;
>  
>  	return 0;
>  }
> @@ -749,16 +750,16 @@ static int relay_file_open(struct inode *inode, struct file *filp)
>  }
>  
>  /**
> - *	relay_file_mmap - mmap file op for relay files
> - *	@filp: the file
> - *	@vma: the vma describing what to map
> + *	relay_file_mmap_prepare - mmap file op for relay files
> + *	@desc: describing what to map
>   *
> - *	Calls upon relay_mmap_buf() to map the file into user space.
> + *	Calls upon relay_mmap_prepare_buf() to map the file into user space.
>   */
> -static int relay_file_mmap(struct file *filp, struct vm_area_struct *vma)
> +static int relay_file_mmap_prepare(struct vm_area_desc *desc)
>  {
> -	struct rchan_buf *buf = filp->private_data;
> -	return relay_mmap_buf(buf, vma);
> +	struct rchan_buf *buf = desc->file->private_data;
> +
> +	return relay_mmap_prepare_buf(buf, desc);
>  }
>  
>  /**
> @@ -1006,7 +1007,7 @@ static ssize_t relay_file_read(struct file *filp,
>  const struct file_operations relay_file_operations = {
>  	.open		= relay_file_open,
>  	.poll		= relay_file_poll,
> -	.mmap		= relay_file_mmap,
> +	.mmap_prepare	= relay_file_mmap_prepare,
>  	.read		= relay_file_read,
>  	.release	= relay_file_release,
>  };
> -- 
> 2.51.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

