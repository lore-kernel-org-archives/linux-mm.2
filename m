Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AC33CA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 11:32:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 002C78E0002; Wed, 17 Sep 2025 07:32:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1CBB8E0001; Wed, 17 Sep 2025 07:32:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E32048E0002; Wed, 17 Sep 2025 07:32:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CFCBD8E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 07:32:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7702A5955C
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:32:23 +0000 (UTC)
X-FDA: 83898528966.23.9B83575
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf29.hostedemail.com (Postfix) with ESMTP id 36004120003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:32:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fxQsuJDb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MQ0cdVXu;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fxQsuJDb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MQ0cdVXu;
	spf=pass (imf29.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758108741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Ap5mPSoqW5VngVWaJTgyJfGx7MJPhwio1kMAlldw6U=;
	b=UhYNKpu1XiNS0x2CllgSlOvKYj4EUejbp8HweoMt5RHbVBnPeiQBCxIJqlztc10zu0KthA
	ySOo8ZitocYey2LDUinkPdZlJZnksgbEoJHiqACILB5/Aowp0dSy9wNY1wznyKz8VgsNd2
	jPIQ9T7/dCd0/onOBI//t0+8eqaLRtE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758108741; a=rsa-sha256;
	cv=none;
	b=b7doJ5vGxFkePpOJdkpofIehR5f1KEVMIzvm3kD7Ps1gZidGA3FVJ61nv77uIBWmA22hbV
	Us8wyrBdtkJVHO+ZImE19amdXpTq5UzRqQnxHs82TgV13h/ciqrHMwGjqyFVYU6PFo6JU2
	r8K5N4EiFAmRzHikxTu8MNQ4ayp5C0s=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fxQsuJDb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MQ0cdVXu;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fxQsuJDb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MQ0cdVXu;
	spf=pass (imf29.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9A2BB21E43;
	Wed, 17 Sep 2025 11:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758108739; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+Ap5mPSoqW5VngVWaJTgyJfGx7MJPhwio1kMAlldw6U=;
	b=fxQsuJDbFPJ+Aq2i2N1EojNI/Hd1bpt5cNweVpv6AUqFIxUOJbm2qY66huYbwL8Tm3GUz5
	SwH8SBvGIvkqn12PaatbE30ebxk6Fodkbs4w5BuVb54khNk0vMRWP/YIASKCUV0kXQR0cJ
	CDZdoO2GTvamVOJk2LCTJZWR9rZcfqg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758108739;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+Ap5mPSoqW5VngVWaJTgyJfGx7MJPhwio1kMAlldw6U=;
	b=MQ0cdVXu/Fgwg2bcVUOI0ttAv/c4z/ykaLMQuBWxTsaAFW5ZdcGVoWzN/qQnuXyDWnG4qD
	lXTBNkGr95Rj2EDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758108739; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+Ap5mPSoqW5VngVWaJTgyJfGx7MJPhwio1kMAlldw6U=;
	b=fxQsuJDbFPJ+Aq2i2N1EojNI/Hd1bpt5cNweVpv6AUqFIxUOJbm2qY66huYbwL8Tm3GUz5
	SwH8SBvGIvkqn12PaatbE30ebxk6Fodkbs4w5BuVb54khNk0vMRWP/YIASKCUV0kXQR0cJ
	CDZdoO2GTvamVOJk2LCTJZWR9rZcfqg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758108739;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+Ap5mPSoqW5VngVWaJTgyJfGx7MJPhwio1kMAlldw6U=;
	b=MQ0cdVXu/Fgwg2bcVUOI0ttAv/c4z/ykaLMQuBWxTsaAFW5ZdcGVoWzN/qQnuXyDWnG4qD
	lXTBNkGr95Rj2EDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 202B113A92;
	Wed, 17 Sep 2025 11:32:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GSeHBECcymi0TAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 17 Sep 2025 11:32:16 +0000
Date: Wed, 17 Sep 2025 12:32:10 +0100
From: Pedro Falcato <pfalcato@suse.de>
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
	Jann Horn <jannh@google.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-csky@vger.kernel.org, linux-mips@vger.kernel.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-mm@kvack.org, ntfs3@lists.linux.dev, 
	kexec@lists.infradead.org, kasan-dev@googlegroups.com, Jason Gunthorpe <jgg@nvidia.com>, 
	iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v3 08/13] mm: add ability to take further action in
 vm_area_desc
Message-ID: <wabzfghapygwy3fzexbplmasrdzttt3nsgpmoj4kr6g7ldstkg@tthpx7de6tqk>
References: <cover.1758031792.git.lorenzo.stoakes@oracle.com>
 <9171f81e64fcb94243703aa9a7da822b5f2ff302.1758031792.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9171f81e64fcb94243703aa9a7da822b5f2ff302.1758031792.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 36004120003
X-Stat-Signature: t57bpr3mdnuuqnf3knmmqrcgi5hy1syy
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758108740-140207
X-HE-Meta: U2FsdGVkX1/oNpfpiJ35LmB4XOX+EQqRh8oSezq+VT3e2N3/7KhxdXy9QbECN9U3qWKdRunHG/Ixcv5Lu0eI3BhW4HzdlnUZ1Yns8UOglMV6s9epsyCEfEF7LSXznXq9IN8crSFmkZMHEPRCVd1zJ1u3R9TPBNI87dwcUOzMB7lI702HlWcZTGiz+4u/pbc+068h0T8QP1ixfHsJ8BYOZ9OI85CFimJgH4f+XWWNrYYmWU0aFCHJSFr8p39IL42/+4F5EdukarBe0XFrTAeXz8HDesaNxsxY+A3ohsXO0on01tNcWg+7KI5GN7cWSfhDfPqgXqW66Unmwi1k+J+C4SvW1527jNjDV6CkKEx9n+6T4E7f/+WFdO1kIvCmDGdpb/dloWiL74Av1/fl1GV0Y8XE0Y983hrj+lPY2/sojC7VO8dYDoLZaQygzGPvTlFc1uL1gaSmHIsvR/AabqRujKWSR8Dxzx7P55xFfrXcPTlIEBrWyJr6B9EbnIrfxs796Tq21yOcBBuU65z7+2ZtzT4l/C+ejsaqLZGFu7aS5Nvw+mP+qZM0fgBzL7ceHEcVYnlhImUFCkdWZPrQu/XDe1kTxgXCT1avS0rg8bkBw7I7ZgVqmDpN9cd5To67cndaEFEmx3bwuVqywQN8Zd/T06Ln2Pj+l0fQS8v4vV1PhCAGoL4/E2btbIm+KcpMnSk74JlhF9SVWJ1wpwB5j00ZXxiVd0ZTjVj91+aiViTAiDQZ0a54qLjm0MVakI7DjTovvabtF36YopVNKrQH3U1IAzym79lhSDT5dvPd1/rDt15cBhWTHB4fRbtcPSnZ14fXMrweyqNYGpjNXdd4t8PqJAkxe3P5gl1WHiilZgSYFthfPzjRUsmnHLn7ql+4IdiEGj67ythqP9Jdjou7jYNzmDz8cqk3U56SBqa1IF11alIZ6bbQaL45Ei2WwF0ZcQoG35aaA1zTN9rMF+fUdw8
 UUQfAWkn
 CjO1+SnVPHrTs0FmeFfqvaxC5VHByheYdZ2KFMKR+eNuWTlp1q2pajvDbsrM+fa8SmCpRM5gHOnvm1tx7T4pQLjn7wBTcDJqWnCQVPkPmzo+awX18Kdqzz5BvrpEKxGOhYPFpRJHzjOb9GHQwJtFsqlsMBdXoPbS18Jels7fiT3TEKu5vhz+EjCEmhL4Hai08g/bUoWQfHloYMwt6i4SgEKD5VHzk0Z8p8+7lxaamEpuWBGBjahC/CCY6bm51VSPrGfAqdCQeA4MeBJ/2T1gL0iLLNcU1vqcFt0mkocu7jMG3yGOawWMAIqTQVTPcEZfX9tWExtkDKhE6d8LAd+tcmt3TrseOvHuLR5TxWNoUv3V5YFiCmNvJgiKZHlsJi9Bj2Rc3zDrBTONxhp7ebJlZHs8ytHFPHEbdlngp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 03:11:54PM +0100, Lorenzo Stoakes wrote:
> Some drivers/filesystems need to perform additional tasks after the VMA is
> set up.  This is typically in the form of pre-population.
> 
> The forms of pre-population most likely to be performed are a PFN remap
> or the insertion of normal folios and PFNs into a mixed map.
> 
> We start by implementing the PFN remap functionality, ensuring that we
> perform the appropriate actions at the appropriate time - that is setting
> flags at the point of .mmap_prepare, and performing the actual remap at the
> point at which the VMA is fully established.
> 
> This prevents the driver from doing anything too crazy with a VMA at any
> stage, and we retain complete control over how the mm functionality is
> applied.
> 
> Unfortunately callers still do often require some kind of custom action,
> so we add an optional success/error _hook to allow the caller to do
> something after the action has succeeded or failed.

Do we have any idea for rules regarding ->mmap_prepare() and ->*_hook()?
It feels spooky to e.g grab locks in mmap_prepare, and hold them across core
mmap(). And I guess it might be needed?

> 
> This is done at the point when the VMA has already been established, so
> the harm that can be done is limited.
> 
> The error hook can be used to filter errors if necessary.
> 
> If any error arises on these final actions, we simply unmap the VMA
> altogether.
> 
> Also update the stacked filesystem compatibility layer to utilise the
> action behaviour, and update the VMA tests accordingly.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
<snip>
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 31b27086586d..aa1e2003f366 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -775,6 +775,49 @@ struct pfnmap_track_ctx {
>  };
>  #endif
>  
> +/* What action should be taken after an .mmap_prepare call is complete? */
> +enum mmap_action_type {
> +	MMAP_NOTHING,		/* Mapping is complete, no further action. */
> +	MMAP_REMAP_PFN,		/* Remap PFN range. */
> +};
> +
> +/*
> + * Describes an action an mmap_prepare hook can instruct to be taken to complete
> + * the mapping of a VMA. Specified in vm_area_desc.
> + */
> +struct mmap_action {
> +	union {
> +		/* Remap range. */
> +		struct {
> +			unsigned long start;
> +			unsigned long start_pfn;
> +			unsigned long size;
> +			pgprot_t pgprot;
> +			bool is_io_remap;
> +		} remap;
> +	};
> +	enum mmap_action_type type;
> +
> +	/*
> +	 * If specified, this hook is invoked after the selected action has been
> +	 * successfully completed. Note that the VMA write lock still held.
> +	 *
> +	 * The absolute minimum ought to be done here.
> +	 *
> +	 * Returns 0 on success, or an error code.
> +	 */
> +	int (*success_hook)(const struct vm_area_struct *vma);
> +
> +	/*
> +	 * If specified, this hook is invoked when an error occurred when
> +	 * attempting the selection action.
> +	 *
> +	 * The hook can return an error code in order to filter the error, but
> +	 * it is not valid to clear the error here.
> +	 */
> +	int (*error_hook)(int err);

Do we need two hooks? It might be more ergonomic to simply have a:

	int (*finish)(int err);


	int random_driver_finish(int err)
	{
		if (err)
			pr_err("ahhhhhhhhh\n");
		mutex_unlock(&big_lock);
		return err;
	}

It's also unclear to me if/why we need the capability to switch error codes,
but I might've missed some discussion on this.


-- 
Pedro

