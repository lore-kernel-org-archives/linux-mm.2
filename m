Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48327CAC587
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 08:32:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B3B38E0006; Thu, 11 Sep 2025 04:32:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 889488E0001; Thu, 11 Sep 2025 04:32:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 777BA8E0006; Thu, 11 Sep 2025 04:32:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 606CD8E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 04:32:54 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2CAED118C1D
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:32:54 +0000 (UTC)
X-FDA: 83876303868.05.17B0DBD
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id CF6A5C0009
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:32:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=g69g7tVg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0Kn9GhCx;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Rlw8/zRp";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=10BqmkcK;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757579572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pePLUMNa380skWZ7luqeNYuVXr6xGvhkxPkdStUqzL8=;
	b=5jIXi65IWXxFpwNRyk+JSKujpPSEw4BhLSjDAxzFureZ9k/VGY76dIEF5Jq7EV0uQL117A
	P0h6ka/47hx9Y0+a3mkYLp4trkNc9OvwtEdysphkgInL9PUhBUt/Q0GxovvdpFpcLgIAHp
	IwsVvel98+Zi82eq+VZSXZJSzyPvcBk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757579572; a=rsa-sha256;
	cv=none;
	b=Ewt9ILCNtrOKsXsYtLG2M5P3sokg/u+erp7Uyiems1+sKxL5H74/coBExcMWVCrLIzaahO
	ENdwPYLlpIbjIlOeFeZLsNmmpQffDiJrHuXXpMTKwCMKnu4TGKDjSF9LQu8/hipklSD2il
	h8PxyWHW5R8ZHR7VB34uU93zIGni9U0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=g69g7tVg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0Kn9GhCx;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Rlw8/zRp";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=10BqmkcK;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E82216860D;
	Thu, 11 Sep 2025 08:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757579570; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pePLUMNa380skWZ7luqeNYuVXr6xGvhkxPkdStUqzL8=;
	b=g69g7tVggGA4ICLcQNCp2a7FDFhEJgYZx+rlhxptW3OatO+qLAsjc1gwFiT3lagr6ckCae
	W/ELmYo2UvyoKHg55pepNIQTqKprdkRGz8wGK2RCoVMTIvYZ7hOjyPCUfmPF892jrcts8m
	6yQx2w5csZ75W+co3a197Outu6bRzj8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757579570;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pePLUMNa380skWZ7luqeNYuVXr6xGvhkxPkdStUqzL8=;
	b=0Kn9GhCxwfH7UtNWm0rPiTVf56F7jJTb27XMxMZrnkmLNlf+ZBZNmnvPfhGPo2lW5NDk33
	Sh850po/Fb1oOjBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757579569; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pePLUMNa380skWZ7luqeNYuVXr6xGvhkxPkdStUqzL8=;
	b=Rlw8/zRpNMaso5w9hJU5rsFvLwdqP79gThQ0ptKrbOk16/q7H+vryA9mjmyFasd5sko7gs
	kv2NB3QC3scH9aY6Yti/UmBGb0kXexhPBDR988HTBztTRbzI55KnYlKO3eIddsjqaZcBgT
	EFQBO91Cut+OCVyQ+KCEaNZyRP2OCtk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757579569;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pePLUMNa380skWZ7luqeNYuVXr6xGvhkxPkdStUqzL8=;
	b=10BqmkcKUZL1Wc7BX4XLQc3Xzt89ZfORi8DPbmWNfCdmEsWQqWW8TCaGQojxjk/Owp6q9B
	PFZSurPaXwnOuJBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C178813974;
	Thu, 11 Sep 2025 08:32:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0sg1LzGJwmhDcQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 11 Sep 2025 08:32:49 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 3E12AA0A2D; Thu, 11 Sep 2025 10:32:49 +0200 (CEST)
Date: Thu, 11 Sep 2025 10:32:49 +0200
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
Subject: Re: [PATCH v2 01/16] mm/shmem: update shmem to use mmap_prepare
Message-ID: <4lfedpbfjq6yexryq4jmdoycky762ewmw2thjm2h6wzgqda46a@p3wzpxlhe7ka>
References: <cover.1757534913.git.lorenzo.stoakes@oracle.com>
 <c328d14480808cb0e136db8090f2a203ade72233.1757534913.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c328d14480808cb0e136db8090f2a203ade72233.1757534913.git.lorenzo.stoakes@oracle.com>
X-Stat-Signature: x4it8iseiodz868h3uj5wb88u4wbqome
X-Rspam-User: 
X-Rspamd-Queue-Id: CF6A5C0009
X-Rspamd-Server: rspam10
X-HE-Tag: 1757579571-192742
X-HE-Meta: U2FsdGVkX19GEZQ3y10Ebh8Io2PnJXCwY/a4FR6bfHQvQKR/VHZrb/MwDBVBRzz3pEMUWuORpou+i3Tqfut4cEui0sPBm0b99WJhXxkgKh50ToiHPOnE3DmvXMfkmaTDN70YzxTI6s+vVa8xnF/WlKZ3ne5+JiBXBYUE7bBzeWKSPLeA9djE9mAMb5fa72+0Nt/CX+rrA2qQ7jrefJhPrS87WLs4XFebtT8gcDhFq2bIpXxjma/TPaL2o22xeRMutmI2byvEJAgCajdJBRGGf84f8jxWGU2T731QySLkHyLctTDmc5K2na/fq+SgBEM64iLLnuE45H9im59pHAR6SulYBhvNJJML+NVEkNy+bj/haMkHaVU7K0gPjZlZjrihK5CL9fXeTVAQ20EZm7rD/8LUqfhYt2hJe68nYBo7JNo5ecdyNH6lzILWjKGUxqphKEffyTd9pYD0GIlVEZeHMLblrCz8Xeq5JtZZMRAPoLOIMOmVGl2v0LnsGNjALqgfxPzkvjJPrC+p1GKmHeAWTyGPCdd5gRwBCpzIfCQJnCV88ihxnHrB8faNEIP7DxzB7cg+KHdG5XAvwLDHRXmgbISZ0P+kUkRXjuhOyEU6kJ9WWga51B5usBqwqXplce1usKfhL9y1aJZF8x0xlpXXYyo7LP7061oNKuS+IbwadwK6fLPwPnBwD9fheemBA2fGtStG9eDSMBShgGt8RVEWGj3zKkFP5xEKZZhA5LnQEFI3wnFdQ+46gAKl4Fkb5x5GgfEcMj98ANNk8j0Tm/YVSW++LytVfgP4R7Ns/jL83WsleWYG3L2wVOIr3noPytZKZuY1yNq4cxnSb1KcHW8GKleeT7aVgsglK4DXuCx5YE4LsnihKUCxblvuRZj5lPfBFrl34df58LUj/T7YwWliqRpb53/ccoFke7MlJfL+TIIohJ03nWP1aF04q0rRiRfF18FGdXS1Z6OGDE56BNS
 OyQxlfHD
 ALN95rzkm1tg8vZUxJLxuISvgOIVVafZ1hr5eazqjUIPU1q3JSK2O8IKFSrylGNQMeJq5pnKFvl4OPJlyNMChC87R9newfLxuKZ8wxcWK84ieyBAp7esvypLVITeVXyNNeKgVvdSXyknoMcB+NcOzjr6BJqdl5kt84jXLGCZiTd1lqoDM2yfixUKq6sS9Z//VVP3oo6Ac2OuJ5dgcISZSoobTIXRQZ7YFWySxvzhV8rLVvmvwiqf0n+VcTbvAvhul9aPG7fdz+uCYmZOaDVzTYKtHMONQABBzqHgoPrR5cTfJ045iINKGA04V70GaGDM0aHdErAXE6BVBZIKF83csotTCEF5xD4Nwdngoo/ttEer6sce0lh2peKzHBWgm1/y3v6ePtPkzOhWKjjuylK5L1FNtzutQwaPTZeWwgK1VKM+mP01F3u8xmsPSKkbCofd9vsISdApUoHNCSnN3OURxu7Mte8W+rsp3nUtq8fU7sHlVKGd0IjFusdgRSA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 10-09-25 21:21:56, Lorenzo Stoakes wrote:
> This simply assigns the vm_ops so is easily updated - do so.
> 
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/shmem.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 45e7733d6612..990e33c6a776 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2938,16 +2938,17 @@ int shmem_lock(struct file *file, int lock, struct ucounts *ucounts)
>  	return retval;
>  }
>  
> -static int shmem_mmap(struct file *file, struct vm_area_struct *vma)
> +static int shmem_mmap_prepare(struct vm_area_desc *desc)
>  {
> +	struct file *file = desc->file;
>  	struct inode *inode = file_inode(file);
>  
>  	file_accessed(file);
>  	/* This is anonymous shared memory if it is unlinked at the time of mmap */
>  	if (inode->i_nlink)
> -		vma->vm_ops = &shmem_vm_ops;
> +		desc->vm_ops = &shmem_vm_ops;
>  	else
> -		vma->vm_ops = &shmem_anon_vm_ops;
> +		desc->vm_ops = &shmem_anon_vm_ops;
>  	return 0;
>  }
>  
> @@ -5217,7 +5218,7 @@ static const struct address_space_operations shmem_aops = {
>  };
>  
>  static const struct file_operations shmem_file_operations = {
> -	.mmap		= shmem_mmap,
> +	.mmap_prepare	= shmem_mmap_prepare,
>  	.open		= shmem_file_open,
>  	.get_unmapped_area = shmem_get_unmapped_area,
>  #ifdef CONFIG_TMPFS
> -- 
> 2.51.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

