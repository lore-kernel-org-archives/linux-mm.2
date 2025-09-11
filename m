Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9209ECAC587
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 08:37:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC3C6900004; Thu, 11 Sep 2025 04:37:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9B4B8E0001; Thu, 11 Sep 2025 04:37:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB140900004; Thu, 11 Sep 2025 04:37:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B80D88E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 04:37:03 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EDA5C13AD35
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:37:02 +0000 (UTC)
X-FDA: 83876314284.19.9EBAE81
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf19.hostedemail.com (Postfix) with ESMTP id B44C21A0002
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:37:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gbVdZ5or;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=aLTXTZFS;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BXH35BNu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=onTJLSTl;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757579821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MVKatHAMv6K0HJB+fE+uvvzEY9BdzRg6mGSrDhfixOc=;
	b=6oDBCihy6xeN03OBdBKKPyYzlkUzan8Td+cqgBBXLFFpVayJf/wDSBxIBXOfPb51o7xLFE
	kLXbQmiy5UF/gWmdHul5T2Mr56qXGsuruodBcWsh4AZ4fiUd7zmZCMbNIJi+bM+Gw0pl0o
	qN1ziycDwue9XFj6GpqFqMea0DEewqA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gbVdZ5or;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=aLTXTZFS;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BXH35BNu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=onTJLSTl;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757579821; a=rsa-sha256;
	cv=none;
	b=Iu/KQCeU3+UE7qBaLHN1yewtkkkHpuZzkspGOYPaVys+YqnxFIbqOgbQHu7HHRdwjN1v3f
	nyNaRdfb3ijAmB6QvepQxDWRtSIcPWTwUs7G4PbnYvIBX82G427ZKKq4a8TuhMvnPh4git
	Asi9dZ+8QWCVPqW54hgpVPmqAxH8prQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E8F2468606;
	Thu, 11 Sep 2025 08:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757579819; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MVKatHAMv6K0HJB+fE+uvvzEY9BdzRg6mGSrDhfixOc=;
	b=gbVdZ5ordIwsjok0HGyMjLJHMSMCvd7phfCfms+ZTddXEbopzWQoU9SS+FPbGVcufPMb2x
	JMqA30UnF9uP4ZX8DjZuMTMu0J3iWh4dqAOgxyk/H1JXK2INNCBYcRL6RtLmBo7y9ghHvL
	it6KQ2/afG8hGOw9P2K0/2NZIIl4e58=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757579819;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MVKatHAMv6K0HJB+fE+uvvzEY9BdzRg6mGSrDhfixOc=;
	b=aLTXTZFSgnI5/Cod9GP6PRHmztHtOqVdF3UN4+Ox//+uZ9pn/LzTYv8Pv/vn52ReXpGA7L
	LygYn7X671fZo2Cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757579818; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MVKatHAMv6K0HJB+fE+uvvzEY9BdzRg6mGSrDhfixOc=;
	b=BXH35BNu64iIGCB3YP2jGeLYcKsUThmhJ6XH1FZZJOeTGgj8j+AKxuheSOZ825qLuYyoJA
	Fnp0TF+S3NW+tY9TPbQQJsr0ly3mI21S04Ty4JaNJv85r6FBeE9/XfvhuQjAIdfE3zrgCt
	iZWZFl6rA6UgTWCABj5n/rG4pREhBLE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757579818;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MVKatHAMv6K0HJB+fE+uvvzEY9BdzRg6mGSrDhfixOc=;
	b=onTJLSTlgfa3oXRqtjZDgBU2LdJbfKNHu4jUM0BmAA78X6XyIiUUKvU898EivdFRT7NBq1
	eEDGqyXMCeegHVCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D83BA1372E;
	Thu, 11 Sep 2025 08:36:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mpvENCqKwmjOcgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 11 Sep 2025 08:36:58 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8E4F6A0A2D; Thu, 11 Sep 2025 10:36:58 +0200 (CEST)
Date: Thu, 11 Sep 2025 10:36:58 +0200
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
Subject: Re: [PATCH v2 03/16] mm: add vma_desc_size(), vma_desc_pages()
 helpers
Message-ID: <afrz7upbj463hmejktsw2dxvvty7a7jtsibyn4fdlwwyrzogrh@c3svlrvl4job>
References: <cover.1757534913.git.lorenzo.stoakes@oracle.com>
 <5ac75e5ac627c06e62401dfda8c908eadac8dfec.1757534913.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ac75e5ac627c06e62401dfda8c908eadac8dfec.1757534913.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: B44C21A0002
X-Stat-Signature: fk4k3hodhyxkkku1w16bcubmcnfkinpm
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757579820-943169
X-HE-Meta: U2FsdGVkX1/s/HLYTVWdb4ItZ3iqhPAsQ9wPwHHiFTPgx0QvtmTZPXDfOa5bZfwSAwW7juxZk0/wD0gdg4LoKrGWRIolsWHDLG9Trbsmii2ylep7MyrI3HFcmkl7mnzTMZuCytAH+qyHOu7ddGuG+HLDXjXicTDQS0frWy6dm2ikNk1c1lhKYXgxXHWuDrb+dCqO+oHOt8TPCttOZ7+lKyL758k8Emwd7dfFaD5q9oBUr/JgcGBCiswFlLwDiqMUyBokruVIXSP5WMavyaLnz+Aeu4ZqCze0Aa+y4+yH4ukEXLmjitU5w4Fv9wvUtVXEqaN3FoIXhJibFoazEZlrFee8eW7j6bHWkPQkryjiwExzLDjxqC1/jMJcsXJgx4VNui9kG2tgIbb5TqxhRjATgEYBkYGu3uk6fMsYfGtuXDknOjILiQL/LyQgNxZsrKR2vn93zE0GH3eCSLF0zb11MKcOllpu7NoOY9Hva6X1E9KL9/5/kejyoxr4kxyT6v5IlXUbPvkVoYuPUpbLvmiMLiWbIwx2hIRj6n2guqECkqSFhHU4vGRbigrd3zdQiRhGxUzmQ/JM6Pftacn9DxL3Rw4fWnw1+0Ry+1Dg+uryZjcVhaNB2Uml9K6Oj/Wkjc2m2rzmEW1W9OEt70iUvp/Hdvw8DyocaEhq6JH54XTo+7CQJtQ11M9+1AtbiLPmsaN436RRwU+I7o6bqH4OoD1/eYX9W8xbcRWPRnjmKZFI3WD2KD9Pb7Cgm2HqR8t1rlGcFpO+36wfprks0FU9XyepFS9aFs04+iVZYroFDBpSEGFlRNXaN++IzdfAsFlRT/zhCSLLx36JEII8V1zPxoAfQyZYlmnX/81NYYyZJ38MuU5ysaM8D2vCrh2y5/KRxus+9DHboVQhWIRRojNGlbyViXc1SEgpxMdzEn7SMUAxgV8MqJ+zybLHmaF2EHuj7+lvd89ojykr52AA8heTVZd
 7b/cjhF6
 Ye48t6QAVpnFjGORu2b/fG1IrgWNh0B3gBeMTy8Zf3B9gj2y1cY0xQROtDGO4CENBYepsVCOYNrRt5vezGxBrzNIuDmLdDZ+xptlYFkGgUQlCVdv9BlOAQTwFPbBxD5Fq0MJizisT9Y18AGtR7BYHEuK7CDi7/6WV88SPEKGS3DRxxbgAXgaSWW+/bnGjDMdZM0zwQPnnxBLJJ5EruOH7QSZkP9seBRoxh/aqeQBVDiMtzsZwNkfjF4qSQxu67/9KokLOozwtxQCAxP/jPTqma1tcWFvVxTUsWdjrnLcmZLWbgoMNnixQGwsjVoUuIen/bdDrFdEXwdt2sfqecXx6zTs7mJeBlbh3KlU6YISPxS6yZ452zUJ3E3E87FehZr3yVen8ucwH377lyFRfX2fX7E0w5IXOgFsEHpLjBBegit9vD0AVjORC4TSlAcm+wEdv+BSyGCg6HX+93IsnSj9lmzy0kI0zr0lX7UxFiqTF0IEDYF8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 10-09-25 21:21:58, Lorenzo Stoakes wrote:
> It's useful to be able to determine the size of a VMA descriptor range used
> on f_op->mmap_prepare, expressed both in bytes and pages, so add helpers
> for both and update code that could make use of it to do so.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Looks good, I presume more users will come later in the series :). Feel
free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ntfs3/file.c    |  2 +-
>  include/linux/mm.h | 10 ++++++++++
>  mm/secretmem.c     |  2 +-
>  3 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
> index c1ece707b195..86eb88f62714 100644
> --- a/fs/ntfs3/file.c
> +++ b/fs/ntfs3/file.c
> @@ -304,7 +304,7 @@ static int ntfs_file_mmap_prepare(struct vm_area_desc *desc)
>  
>  	if (rw) {
>  		u64 to = min_t(loff_t, i_size_read(inode),
> -			       from + desc->end - desc->start);
> +			       from + vma_desc_size(desc));
>  
>  		if (is_sparsed(ni)) {
>  			/* Allocate clusters for rw map. */
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 892fe5dbf9de..0b97589aec6d 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3572,6 +3572,16 @@ static inline unsigned long vma_pages(const struct vm_area_struct *vma)
>  	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
>  }
>  
> +static inline unsigned long vma_desc_size(struct vm_area_desc *desc)
> +{
> +	return desc->end - desc->start;
> +}
> +
> +static inline unsigned long vma_desc_pages(struct vm_area_desc *desc)
> +{
> +	return vma_desc_size(desc) >> PAGE_SHIFT;
> +}
> +
>  /* Look up the first VMA which exactly match the interval vm_start ... vm_end */
>  static inline struct vm_area_struct *find_exact_vma(struct mm_struct *mm,
>  				unsigned long vm_start, unsigned long vm_end)
> diff --git a/mm/secretmem.c b/mm/secretmem.c
> index 60137305bc20..62066ddb1e9c 100644
> --- a/mm/secretmem.c
> +++ b/mm/secretmem.c
> @@ -120,7 +120,7 @@ static int secretmem_release(struct inode *inode, struct file *file)
>  
>  static int secretmem_mmap_prepare(struct vm_area_desc *desc)
>  {
> -	const unsigned long len = desc->end - desc->start;
> +	const unsigned long len = vma_desc_size(desc);
>  
>  	if ((desc->vm_flags & (VM_SHARED | VM_MAYSHARE)) == 0)
>  		return -EINVAL;
> -- 
> 2.51.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

