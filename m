Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93ABDC87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 14:18:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E176C6B00A5; Tue,  5 Aug 2025 10:18:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC8386B00A6; Tue,  5 Aug 2025 10:18:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB7176B00A7; Tue,  5 Aug 2025 10:18:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BBB3F6B00A5
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:18:55 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3E7EB1407BE
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:18:55 +0000 (UTC)
X-FDA: 83742910230.25.6082600
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id C8041C0008
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:18:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JLEiwTWg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=15OpfyJo;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zDiNZGJ5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZnbvifoH;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754403533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+NfTJO6QExB/AjtZCsMzDvrCWnZLiopnMrmlLDf3JbE=;
	b=nfSy8CWxfbpLcmQcaor65pY3qSQISfvVdQFxKMGi7cm1Qb80DraeTbE1WqSRbey/otmr4k
	hv3+2E8R0mbmGulHPCpwMuZDI/jMSxG1ZLHS1NaBkOjlBdvQhf/8jXho9Ep0VLUiQPipxi
	TMfW7kfQryN/isHzvU/nXrUuGLTdJBQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754403533; a=rsa-sha256;
	cv=none;
	b=3pYWrZ1NX6CDeJUd6eaI0rEamVXJlASJMs8ThULF9CoqSUJa9MW145vnqnO/CygXrnfpwq
	WrOIJPVQIxDONNibLIAhOWkLmkzNfeO8qD4n+Pd5W0DRroWGvoI+/bf1crrQHxDHmkG7Ew
	6DUniYpqtL8lgmbeHQdphMwWt9musPY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JLEiwTWg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=15OpfyJo;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zDiNZGJ5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZnbvifoH;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DB6CE1F38A;
	Tue,  5 Aug 2025 14:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754403531; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+NfTJO6QExB/AjtZCsMzDvrCWnZLiopnMrmlLDf3JbE=;
	b=JLEiwTWgrN3FMXG6fIc7sMoJCxq1EVPmn0gw60A48lFseG+7pgp16TK0QsWp2cyVPSlB/d
	Ax+Gw0JlK4Ic1I5p9wroVK7OffPuUuzWkwRIAtIjjJCgaMcdqyBW6T9hWmecarQgR9mpQE
	OcoOcLoqzQ/JdIiyuaVHAe7bXMGe0cY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754403531;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+NfTJO6QExB/AjtZCsMzDvrCWnZLiopnMrmlLDf3JbE=;
	b=15OpfyJoyk2taAkgIC4Xv+OOtyhWW4yD2jIA+HdaA0B9fKtQ5TD5UCTC0igqFmqQ3E8Gz+
	59OI7CE+fPo/VRDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754403530; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+NfTJO6QExB/AjtZCsMzDvrCWnZLiopnMrmlLDf3JbE=;
	b=zDiNZGJ5si2mcehmfw2uKJsVv/5QwnJ6f3tNpjsLAoeQmqBlltQNalA9bop2V2mU6urcLB
	1rnepXmjAR41zGBOEEQSGv/ckndF0/HNZADa6bItMJME+ydlyKB7WT+CUIj3PF6Hk3a+3d
	hydmdVEkZp/7sEij6hxG7BWqmmO6fDs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754403530;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+NfTJO6QExB/AjtZCsMzDvrCWnZLiopnMrmlLDf3JbE=;
	b=ZnbvifoHF0Ve/E4VFWtrLfAQSaYUTFoeM8xoPnpU01Q7Mo4yP0G3GwG2rcPBIw0ZSkljNF
	2gAHxNsZHZZYPrDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D0D8513A50;
	Tue,  5 Aug 2025 14:18:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ysP5MMkSkmh2LwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 05 Aug 2025 14:18:49 +0000
Message-ID: <a2fca13d-87bd-4eb3-b673-46c538f46e66@suse.cz>
Date: Tue, 5 Aug 2025 16:20:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] fs/proc/task_mmu: execute PROCMAP_QUERY ioctl
 under per-vma locks
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, david@redhat.com,
 peterx@redhat.com, jannh@google.com, hannes@cmpxchg.org, mhocko@kernel.org,
 paulmck@kernel.org, shuah@kernel.org, adobriyan@gmail.com,
 brauner@kernel.org, josef@toxicpanda.com, yebin10@huawei.com,
 linux@weissschuh.net, willy@infradead.org, osalvador@suse.de,
 andrii@kernel.org, ryan.roberts@arm.com, christophe.leroy@csgroup.eu,
 tjmercier@google.com, kaleshsingh@google.com, aha310510@gmail.com,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20250804231552.1217132-1-surenb@google.com>
 <20250804231552.1217132-4-surenb@google.com>
From: Vlastimil Babka <vbabka@suse.cz>
Content-Language: en-US
In-Reply-To: <20250804231552.1217132-4-surenb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C8041C0008
X-Stat-Signature: aeudzogshkz8duq5jbhodq8x7b7rgqt7
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754403532-926486
X-HE-Meta: U2FsdGVkX1+zB6TspAGtR1x5XKjHlJ0OpLJKd3kV3ZziupkRn1PBAd9RH8RRp/C4HgCgFs/WrjgRg06Ga/4SYmNVKLTUZA1PMBu4tMDDnJHaAjzvzmSnlINLbRdhr3ogdDA7ZTMH6NENz9sFV9PaFcPqugkPLK0ZJPPHq35bqnuyx3DZrIKAZKMkiuKs8yi+4arxFaRzlQo5eP1TL43mu8aDb45/C8PMWOR+acWhMYnfFFHn4Rv2SPwBAAsha08ZUZLNKYdfXK2Rf7upSsSzvF4afD2l4zOnlQP+esQ0frNoEpFk/Uz9O2tPd4qkuh1U5dmT7ofN+wcQhQ3EpcIntgY2vgrKMupCX4YGzTMAx2muW1SfuaI5/x9dZk3WCozBAKJC9pxccLJ5gaDAhZxekUWrK3mGw7mmUXBR3qMywI4puDJtXuCSu9OJSpNtLHUCD2h1K4yOeP7YYHcB2TXx42q4z0k8LimLCHOxVwEiMw+jSdQQoYmHv/J4BHNEttKLWNftgzfp/cUQ7Dd8aD1AN9DThT0jGkThlaWNxPh1318oH1JKIzQjkf724y+5xY3qEu31IXnO5Xbif36KMSrt79XuQpK8xeWMqmKzIZitH8/8dNgjnzjTvW/UbUNy1yGYgirMAT8LuTDaICZnFi3z7LZUZYqR0R7y3ZvW/CG/CHWnR9q/DmwKKHvGHtvrxshBB3E7CDa7XH0YqT+8zdySfoDfOeWFzZ7Sqqi/7RSlE2RoU5wdbtl8TmNPmPQGLTGvzNVmyL4Q4uuV/4KzS/J+i3ACqTtKALSN3jNsryWFXNDsSSQyn02kuQTKJM96vE5KMAB5DCbogD/kYKhn+VoEfagezQGmaz/6J/ziW1oXQ8/m+x7SMdAaXyv8FvI80rm0Gh7BNyPLBlq83+5lZjM1whiFkzXtF/1LKUnGAX1UmjAGaCyc+EWcOlNcSZ0mF2PhzWGbvgrnT0HF65bPIEe
 G7nxasac
 /yxw1o9IZ5kOTvmhy2CW/Pc98lAh8Fnfwk66qwdY/83W+sRwGXqss92mGzhNe2mNso8IPsXNMbxVwIZIM85K9U8z1iBMztSe3tzCN6Op0egNF2PXnU0tkFOxc9FdbdeGh9tvy9WC307cb/oUVKPqm9EwXEo+1bSgn9xNq27rgjdYthELoDEIVpcinvRWKWVEBUxB0FwDDSG/oqGF3CK94GxScVV3Py52k2mk3sK5PtHXwynsB+LrhIMHOqICV7Y2jw/300LTWT4IWlfvvlkYm8x+cMRvnAFTojcnIJExRM5BqSIDM6kqcpBx0NjP7xKwVHOfJ9nmeesEHVpzUuKkEaArCtyOYH9FoHHY3domM+KcV35pXfmZBzIoXefbDXOATP46W1VNsHdSmMao=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/25 1:15 AM, Suren Baghdasaryan wrote:
> Utilize per-vma locks to stabilize vma after lookup without taking
> mmap_lock during PROCMAP_QUERY ioctl execution. If vma lock is
> contended, we fall back to mmap_lock but take it only momentarily
> to lock the vma and release the mmap_lock. In a very unlikely case
> of vm_refcnt overflow, this fall back path will fail and ioctl is
> done under mmap_lock protection.
> 
> This change is designed to reduce mmap_lock contention and prevent
> PROCMAP_QUERY ioctl calls from blocking address space updates.
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
>  fs/proc/task_mmu.c | 81 +++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 65 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 843577aa7a32..1d06ecdbef6f 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -517,28 +517,78 @@ static int pid_maps_open(struct inode *inode, struct file *file)
>  		PROCMAP_QUERY_VMA_FLAGS				\
>  )
>  
> -static int query_vma_setup(struct mm_struct *mm)
> +#ifdef CONFIG_PER_VMA_LOCK
> +
> +static int query_vma_setup(struct proc_maps_locking_ctx *lock_ctx)
>  {
> -	return mmap_read_lock_killable(mm);
> +	lock_ctx->locked_vma = NULL;
> +	lock_ctx->mmap_locked = false;
> +
> +	return 0;
>  }
>  
> -static void query_vma_teardown(struct mm_struct *mm, struct vm_area_struct *vma)
> +static void query_vma_teardown(struct proc_maps_locking_ctx *lock_ctx)
>  {
> -	mmap_read_unlock(mm);
> +	if (lock_ctx->mmap_locked)
> +		mmap_read_unlock(lock_ctx->mm);
> +	else
> +		unlock_vma(lock_ctx);
>  }
>  
> -static struct vm_area_struct *query_vma_find_by_addr(struct mm_struct *mm, unsigned long addr)
> +static struct vm_area_struct *query_vma_find_by_addr(struct proc_maps_locking_ctx *lock_ctx,
> +						     unsigned long addr)
>  {
> -	return find_vma(mm, addr);
> +	struct vm_area_struct *vma;
> +	struct vma_iterator vmi;
> 

Hm I think we can reach here with lock_ctx->mmap_locked being true via
"goto next_vma" in query_matching_vma(). In that case we should just
"return find_vma()" and doing the below is wrong, no?

> +	unlock_vma(lock_ctx);
> +	rcu_read_lock();
> +	vma_iter_init(&vmi, lock_ctx->mm, addr);
> +	vma = lock_next_vma(lock_ctx->mm, &vmi, addr);
> +	rcu_read_unlock();
> +
> +	if (!IS_ERR_OR_NULL(vma)) {
> +		lock_ctx->locked_vma = vma;
> +	} else if (PTR_ERR(vma) == -EAGAIN) {
> +		/* Fallback to mmap_lock on vma->vm_refcnt overflow */
> +		mmap_read_lock(lock_ctx->mm);
> +		vma = find_vma(lock_ctx->mm, addr);
> +		lock_ctx->mmap_locked = true;
> +	}
> +
> +	return vma;
>  }
>  

