Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4313EC4451C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 14:18:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04B436B009D; Sat, 18 Jul 2026 10:18:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 021126B009E; Sat, 18 Jul 2026 10:18:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA0A66B009F; Sat, 18 Jul 2026 10:18:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B249E6B009D
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 10:18:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BD9BCA0B30
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 14:18:08 +0000 (UTC)
X-FDA: 85002101856.27.4F6D878
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 35DC310000F
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 14:18:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IbP4Nqeh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784384287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JEySjlnLkSfVZHV/syZ323GKzIZd/xh+MIEHHLrWc/g=;
	b=t3XqToom0Ge+wE87CgnhaGqr9UoNb90yCw77fUvLI/HvV7waHuuP8CsR7Z69oculnWuxot
	gj0hN2Hbwm+1snurkj9gnJGtpYaw2cDN5mfr6KK+HP6pZQM5+vVnii/777kI6ZzbF5wS7O
	1ePnGfofQq5JboBjGdxMZJuUPKPgaq0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IbP4Nqeh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784384287;
	b=pocPg/SoF/484bEi5tC15UqYxncFBKEkZJ71G2mr9mlZe+IvKPVfKJkozjyUEsmuEs51H+
	1Y3UThV/qWMIhL5Y9VCfblmDdv1Hq86wsrWgRchNn/vUklZcCwyXTttTpmP3eMP6pyYz/P
	reDBvEtBDE5YnXNZ2zHyw+dFfTWQzZY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B802060018;
	Sat, 18 Jul 2026 14:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5721F000E9;
	Sat, 18 Jul 2026 14:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784384286;
	bh=JEySjlnLkSfVZHV/syZ323GKzIZd/xh+MIEHHLrWc/g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IbP4NqehMlKAJ03Vc0t3/uVOASYDjrgqkWdiJxOSfy/HqGSuYKv7nzq6lbsxfFFMb
	 7GZD+OT3RM4ofaSav8lyI9tbPWuW2diqA69CtBe1jv9dt0+oH8Ry0FQB/hWYbzX4uT
	 fPdpC0DFDR0JOFXcpptIccjK3vSYb+Ym1io08+BP1Wuk+/AyzCUxwv4p2kvXxyISNk
	 y7o92If5aDgqmeSdOCz+0SVooS1YjYOyXPiQEXKSADYyc9g+fwgVxM7dAgXTeTsRFs
	 aOfE3MxrQ4zdJ60V1w02f7cJYTLw2eEfU0SfysRbgZHplikEzdFciznr9/+Qm18G0A
	 Ru4IE7LzJ8JLg==
Date: Sat, 18 Jul 2026 15:17:50 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Liav Albani <liavalb@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	jannh@google.com, pfalcato@suse.de, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vma: fix imbalanced file reference count, properly
 abort mmap_prepare
Message-ID: <aluILz8j8BL3CA7-@lucifer>
References: <20260718123417.16339-1-liavalb@gmail.com>
 <20260718123417.16339-2-liavalb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260718123417.16339-2-liavalb@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 35DC310000F
X-Stat-Signature: xwax5sfk1sdwk4i5orht5ibiteod7dyx
X-HE-Tag: 1784384287-175816
X-HE-Meta: U2FsdGVkX1+43e4AXOSHzc+E/Ve1yaKowITuLS1o0d/2NX5Xo7/h+z5oOeVqkaddX7amDB+x8tG3b8NmAj6VhP2yurwWJ4YSJ/lOo+EXSx4S+RgONDgaRjHC/QYuG8XqC0cOqnRLl89+mbwFBpC2FhqlSzcIxss8fqnFB9MS30bbi01fX/Y7a32BMqKEK+QbrjeHbEt016MFcCYl0I0wuuEmOX7OqBL70IVrvnae/ov6DLEdTqMVhyxZwRwu6NN00Olh4dB911x4mvqclfdB4Gjal/qcF/0CwrnDHJ7J+IArIURe6l2+BsoJtjV/ho0H0vMF1mYIoKBAqtCY5Lk+5BIIXId0vysK4VVGwqKvD+Sx6aw956i7btszyXc5vYqu3X+XFxetMfp80QP/PYGsyMPNVV3iy8+xwHF4kCxO+oF8w4axa8Fjz2RkxL8YXeiNOpz6qeYLlX23ylZM6rjhSBPQBS2cdnIoZI6pJlm6MfVvnHEcBvjkl0LTOIIUQDCFaanlRaXYeDSeX+3WryIEaJvNHKKkNRoT/+ZsP6Mt7oAqdSqq1ApLPj1eQolLNwmweQVudmoZq9zLGcmtUkpsTZmS7431wN24enHL9KNV5Rc4TkXLVpOr3OX1ZPWax2m3+ullOex6QeNw/Pv75+aH+M/ZKAs7pL0oG2PHtc8FKSniSGxSA3+ugKuroRYTN2iuGLEQ1Xnvg/qyHfSj6MBeUSi7LBfZMWwz1JE1i5KPiOC9tagtDFS7mtwj5pkI8w+DA52ZOTzczEn46ua6dEQYl9zo1vO9YPDCFGD/ukoZK+X7lMeWNX67em5t0NUe1m0bnNTOHSZFg/lSmHfsDeyqKIL+aJWKkcc6w5U3wI1lpummWRluP3qVz2fc8jO4DGWuQg6ZzH427YfjW5hRp9/CWa/4O7H+AhWjYAkheLXhuPyYeLPbhmb6rSO/2T4uRdNHWqt71QnN9a/X/g8XazL
 ojceR3Jh
 2NygOF/VWCKsjOJbyU4ytQihNueCgj/BH5U/8arw3NMzzdN9gZwUr965oPNh1oIZIp60qqwXaPNiajZhg2QTAHPQwSdCsmbnY5quZ25YjbCPocOGtC9q6HqGwZj1Gu28goKhqMVawHrMavG87Zy4JQBBJ1/cdeUfoAghhTAi5G5R3Zo1ACLJ5P+csklFcK/285pJaxhEUpm1IfhAcE1Db55qMQPu+A4nWVZe9NuF4iMvImsrvhjdwGmXRYCXX6hT+TXpoQ2PavXlZPkeLIiXATgzWNOEXtcJtnw2+zou3hwML6ZbYgeTqTc979vcuz/4ZUtV0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the patch but as per the 0/1 this is not correct - the issue is that
your mmap_prepare hook doesn't get the file.

(Also in general, we don't add cover letters for single patches, only for series
with >1 patch :)

On Sat, Jul 18, 2026 at 03:34:17PM +0300, Liav Albani wrote:
> Under the new `vm_area_desc` struct, a driver may change the vm_file
> to provide a different backing VM file.
>
> In such case, it became apparent during testing of this capability, that
> a remove_vma() may drop a refcount on a VM file that we didn't call
> get_file() upon.

As above.

>
> In addition to that, calling vms_abort_munmap_vmas when we didn't do
> actual work is wrong, because mmap_prepare hook is about preparing the
> mmap state and not performing any actual mapping (yet).

Not the case - __mmap_setup() unmaps any existing mappings in the area
being mapped into (they are taken out of the maple tree and put into a
detached state then added to the temporary map->mt_detach tree), and
vms_abort_munmap_vmas() will put them back.

The vms data structure is set up in int_vma_munmap(), then
vms_gather_munmap_vmas() populates both map->vms and map->mas_detach.

If nothing was unmapped map->vms->nr_pages == 0, and
vms_abort_munmap_vmas() is a noop.

>
> A kernel stack (before of this patch) could look like this:
>
> imbalanced put on file reference count
> WARNING: fs/file.c:36 at __file_ref_put_badval.isra.0+0x3f/0x60, CPU#1: test_proxy_mmap/116
> Modules linked in: ufedm(OE) virtio_net net_failover failover nandsim nand nandcore bch mtd
> CPU: 1 UID: 0 PID: 116 Comm: test_proxy_mmap Tainted: G           OE       7.2.0-rc3-gaf5e34a41cd6 #1 PREEMPT(full)  bdadc55b51524b311c430c1536a97e7071150fd3
> Tainted: [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.17.0-2-2 04/01/2014
> RIP: 0010:__file_ref_put_badval.isra.0+0x3f/0x60
> Code: 85 f6 78 05 c3 cc cc cc cc 48 b8 00 00 00 00 00 00 00 a0 48 89 07 c3 cc cc cc cc 48 83 ec 08 48 89 3c 24 48 8d 3d 61 bc 30 02 <67> 48 0f b9 3a 48 ba 00 00 00 00 00 00 00 e0 48 8b 04 24 48 89 10
> RSP: 0018:ffffc900006bbae8 EFLAGS: 00010296
> RAX: bfffffffffffffff RBX: ffff88810409a180 RCX: 0000000038748000
> RDX: ffff888100a44480 RSI: dfffffffffffffff RDI: ffffffff83b12730
> RBP: ffffc900006bbbf8 R08: 0000000000000000 R09: 00007f8b49f8f000
> R10: ffffc900006bbba0 R11: ffff88810409a208 R12: ffffc900006bbba0
> R13: 00007f8b4a179000 R14: ffff888102222440 R15: 0000000000015040
> FS:  0000000038726400(0000) GS:ffff8881b77d1000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000038728618 CR3: 0000000104a1c006 CR4: 0000000000370ef0
> Call Trace:
>  <TASK>
>  __file_ref_put+0x30/0x40
>  fput+0x4f/0x80
>  remove_vma+0x42/0x60
>  vms_complete_munmap_vmas+0x179/0x230
>  do_vmi_align_munmap+0x225/0x2a0
>  do_vmi_munmap+0xe6/0x1c0
>  __vm_munmap+0x113/0x200
>  __x64_sys_munmap+0x1b/0x30
>  do_syscall_64+0xaa/0x660
>  ? ksys_mmap_pgoff+0x168/0x200
>  ? do_syscall_64+0xaa/0x660
>  ? vfs_write+0x281/0x560
>  ? ksys_write+0x7b/0x110
>  ? do_syscall_64+0xaa/0x660
>  ? do_syscall_64+0x5f/0x660
>  ? clear_bhb_loop+0x30/0x80
>  ? clear_bhb_loop+0x30/0x80
>  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> RIP: 0033:0x440bcb
>
> Signed-off-by: Liav Albani <liavalb@gmail.com>
> ---
>  include/linux/mm_types.h |  1 +
>  mm/vma.c                 | 24 +++++++++++++-----------
>  2 files changed, 14 insertions(+), 11 deletions(-)
>
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index b18c2b2e7d2c..5db0894e6064 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -981,6 +981,7 @@ struct vm_area_struct {
>  	unsigned long vm_pgoff;		/* Offset (within vm_file) in PAGE_SIZE
>  					   units */
>  	struct file * vm_file;		/* File we map to (can be NULL). */
> +	bool vm_file_doesnt_need_put; /* Do fput only if we did get_file... */

We definitely wouldn't add a field like this in the VMA type :) VMA fields
are in very short supply and the data structure is very sensitive on size
(it scales to a lot on many systems with many threads).

In general it feels like this is to pass things down to remove_vma(), but
that's an indicator really that you need to put it somehwere else.

>  	void * vm_private_data;		/* was vm_pte (shared mem) */
>
>  #ifdef CONFIG_SWAP
> diff --git a/mm/vma.c b/mm/vma.c
> index 9eea2850818a..0c2e71fc09be 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -467,7 +467,7 @@ void remove_vma(struct vm_area_struct *vma)
>  {
>  	might_sleep();
>  	vma_close(vma);
> -	if (vma->vm_file)
> +	if (vma->vm_file && !vma->vm_file_doesnt_need_put)
>  		fput(vma->vm_file);
>  	mpol_put(vma_policy(vma));
>  	vm_area_free(vma);
> @@ -2487,6 +2487,7 @@ static int __mmap_new_file_vma(struct mmap_state *map,
>  	int error;
>
>  	vma->vm_file = map->file;
> +	vma->vm_file_doesnt_need_put = map->file_doesnt_need_get;
>  	if (!map->file_doesnt_need_get)
>  		get_file(map->file);
>
> @@ -2497,7 +2498,14 @@ static int __mmap_new_file_vma(struct mmap_state *map,
>  	if (error) {
>  		UNMAP_STATE(unmap, vmi, vma, vma->vm_start, vma->vm_end,
>  			    map->prev, map->next);
> -		fput(vma->vm_file);
> +
> +		/*
> +		 * We set vma->vm_file to map->file, so if we didn't increase
> +		 * the refcount, don't decrease it in this path.
> +		 */
> +		if (!map->file_doesnt_need_get)
> +			fput(vma->vm_file);
> +

But this just means the file is unpinned in general and you really want its
lifetime to be at least that of the mapping :>)

>  		vma->vm_file = NULL;
>
>  		vma_iter_set(vmi, vma->vm_end);
> @@ -2757,7 +2765,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
>  	if (!error && have_mmap_prepare)
>  		error = call_mmap_prepare(&map, &desc);
>  	if (error)
> -		goto abort_munmap;
> +		goto abort_mmap_prepare;

Yeah, as above, this is incorrect.

>
>  	if (map.check_ksm_early)
>  		update_ksm_flags(&map);
> @@ -2795,15 +2803,9 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
>  unacct_error:
>  	if (map.charged)
>  		vm_unacct_memory(map.charged);
> -abort_munmap:
> -	/*
> -	 * This indicates that .mmap_prepare has set a new file, differing from
> -	 * desc->vm_file. But since we're aborting the operation, only the
> -	 * original file will be cleaned up. Ensure we clean up both.
> -	 */
> -	if (map.file_doesnt_need_get)
> -		fput(map.file);
> +
>  	vms_abort_munmap_vmas(&map.vms, &map.mas_detach);
> +abort_mmap_prepare:
>  	return error;
>  }
>
> --
> 2.55.0
>

In general I can see you're a genuine kernel enthusiast so I don't want to
dissuade you :)

This code is fiddly in general so it's _entirely_ understandable you had
some misapprehensions about it.

Hopefully the feedback helps and you are able to continue implementing
your feature, do let me know if you're able to do what you need with your
driver (mmap_prepare is in live development and I'm gradually adding more
actions to suit actual driver usage).

It's actually nice to see something human rather than LLM for some early
contributions :)

Cheers, Lorenzo

