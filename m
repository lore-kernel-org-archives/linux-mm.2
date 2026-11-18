Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCEFD606A320
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 23:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xes/E2vx
Received: by kanga.kvack.org (Postfix)
	id D8BBF6B0615; Wed, 18 Nov 2026 18:00:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3CE96B061B; Wed, 18 Nov 2026 18:00:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2B026B0624; Wed, 18 Nov 2026 18:00:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8484E6B0615
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 18:00:07 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0F61DA08FB
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:00:07 +0000 (UTC)
X-FDA: 85449759654.13.60E7EA2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 26F4C1C0012
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:00:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Xes/E2vx";
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795042805;
	b=bA83ZDZvmmyc9utUE9mOaL/q07iZQU5tg2/FjpUCa8kk9RknDIaRarSX5uNf5wZcgUpPs4
	tvxIV3CzZ5H20DmzMRy4YYRq9PyKT9ffwmrRLC2VdEfLRNgf5inaT95xxWFp88ScUfgkuL
	203eAi4qL0d/G8Co6veQD562kpGRd+k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795042805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XAuhA+IU5X7u3tpSaiC00u8UC8LTIZ7zSVpFz6MURNo=;
	b=SmZIt6kos7WNIKusrm+MwjRz8JR1ZYQQsrwdLzAbtcp3eo5q4pY9aCg0hnyIbqcAi4r6YN
	2DRhJqIyKr5VIwA8o3rYrmSw9ZDiTlPN1pny8NXW8cm2+GpLpqnqRM+zysKmgDc24i/kLo
	B9X2ZXLQKNKYjBcShu9zPi2sRnY3yHw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Xes/E2vx";
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 92A5A40483;
	Wed, 18 Nov 2026 23:00:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CBFB1F000C7;
	Wed, 18 Nov 2026 23:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795042803;
	bh=XAuhA+IU5X7u3tpSaiC00u8UC8LTIZ7zSVpFz6MURNo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Xes/E2vxcQbfPOkatddUiAnb4zYnJ1FeLekD5lDExpx+Ct0bPR8nWagx0C20vj5F6
	 RPackmRHerVZOMDioK7aUASk82QgYK73h1BebC+5t3H9Owt/FA0ukPT8bCD1z2bl7S
	 vMMSqwxg26fpqR3qaN8iG410fpymMrmXe73bzvzZ2viTkRFblTvVMZ170eoY916KyI
	 gDX0OKdGaqx98mFVRh0Hds+Z8tQlC4ZiwoMYjsycVs9+LvKWkPhewydmx5ttf0QMi5
	 n5V8MFEf2O1DHcLckSPOLFfqTWa2xI9vh+P6qfhx/AmQ78j7OdAwi8JoEG/TYiM2n2
	 RORAm6tMpospg==
Message-ID: <45ce0b42-d45a-44e3-b300-607989e618c5@kernel.org>
Date: Wed, 18 Nov 2026 23:59:57 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/secretmem: Keep locked memory accounting until inode
 eviction
To: "Baek Kyu, Kim" <pocj8ur4in@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 "Lorenzo Stoakes (Arm)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261030152407.113568-1-pocj8ur4in@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261030152407.113568-1-pocj8ur4in@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 26F4C1C0012
X-Rspam-User:
X-Stat-Signature: azt6xznu5w5dcpeegiy3t3ugdfbzzzx1
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795042804-782312
X-HE-Meta: U2FsdGVkX18TOjdsBM8J915chUzg+o+bWhxsEMsDhFASnoaBbN+ESpYiBOm46m7McgkWho2/YXHUHu7neA/KTS6TBvYCIB+fcIwJzJsTtuJ9rOQZjS2yFMkK3gEE2UOKai3POGpp20c2NlKa3bNmP9V+PE30FvQkDyX5ZF1l0Up4BbbdY8MONHOihNxm/wG24qS1Agw7b3t1HYXOISAc/3dN0xV6jSmH/HhfXf5i7jIa2araBdkmLPCuB7VDops79dAiIedz5y3N7Eo4IRoymyPFwFRfro4dJqg3oAOS4qCs3jk9hRWAc1Vn9FyqTDgSzpuRlkKOYGWmp+jFsTsjCbhVzXA5jrftsjXvjvBlvtkla6vYOAa1lukJiiGm9r22pOy6fHRePT/4lQgXf4Dz4Kdu0uIXu5dvoRZWHtoMjFmmtGTAin2CtzOK63/VNXTkSdyq7qJN9Gpc1dRS8krT7+/miMZA3lu6Ds82xWa+uKME+/jGpOBJLSEjJvjYVLINLC7Jlj0EKLFoxprtjMRBVVMQC2JIScO+5QQgVeJBTm0wp7IaZslD/coBPU75g5TT4HS3pDFPgBHX7xydntl8rQJW6jQgx7WcUQ+Z+P/H1N49WC0abY1X8jMcEtPDvw1zfnb/E1ELmIOYaq2nuEg881bvp4MI1nC36J9+WNMwec2puSJVRHLZHCLzv+RPgHb7lnM1kVeQ5pVhLEjZ5KgcL6YWdaDBvhEgdaTLP8UoPWtHLTcpwk7OxIoHruL19a8GUWpA5D9B/CmmpJG87g4GlPCMBt48ciLU9AwSYvvUWm96UrAA/LgT+SVpAgS1DcY2ULhF9lG6i6JskGzXCTAQPvr/CqmKOnidBzoYAJfmYtZDZlALV3mqcHPSdFY9847auG8YW8MPdEOQFkUawRS4AAgQm/cHAXP4i+azuddS8Zqm9B6hfWSB9lzCCMpNRRRJ9bBNndzRVDjcWIU/TnN
 ZhaSWpQV
 xP+34+mxbsOF65Ny/Q89jgzmR27IWMGOs9thYwZrxlzqauH7M/DMqSqvYx+rihMUKaf1kriaRH9f5T4ilSJprVeumiinHu1XgBsCz2VBxzCtFYfpmTlW5zcjDaKihdeyoidqPdEpTZerg0hoY0ZZSjdhNNYqt+gOHZhXyBuV9yV+KIrbawvXXWZyN+idAPmM/YZuFGBPiGobBEdz57icA2OnjfFj103Q8jhu+unbiReZpkmVdul7l7JxjqMBbSPiABEGWi1oKq/aGYAAWThXLkk7EHeZf9KK2fjeOD3kkyQs+tIBsfafRrKCuIWHl7WCICjiRxEtWNPICkbOlcdKuUi77+97KX0uzCrgcLithM6cSm/gyQHqbtjP+gSXxufM6GTlw/mzUWyKqQVZ+YD4mYSURyFtqVCoqUsYzc+rN74Aq4c4auQ0RG5UMT1mSsBj8pDK/XxEEJOeI2//4NJ1Ggv8sGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/30/26 16:24, Baek Kyu, Kim wrote:
> A secretmem inode can outlive its original file. An O_PATH descriptor
> opened through /proc/self/fd keeps the inode and its unevictable folios
> alive after the mapping and original descriptor are closed. The file
> release path nevertheless drops the locked-memory charge, allowing the
> same user to reuse RLIMIT_MEMLOCK while those folios remain allocated.
> 
> Move private-state and locked-memory accounting cleanup to inode eviction,
> after truncating the page cache. Keep secretmem_users active over the same
> lifetime so that the hibernation guard covers retained secret pages. Let
> iput() handle file-creation failures and tolerate an inode with no private
> state.
> 
> Fixes: 97d34aa65c29 ("mm/secretmem: properly account locked pages")
> Signed-off-by: Baek Kyu, Kim <pocj8ur4in@gmail.com>

Lorenzo, Mike, this problem seems real to me. Can you take a look?

> ---
> On an arm64 QEMU guest with an 8 KiB RLIMIT_MEMLOCK, an O_PATH reference
> retained two secretmem pages. The baseline dropped the charge to zero and
> allowed a further one-page fault; the patch kept both pages charged and
> rejected that fault until the last path reference closed. The Image
> was built with KASAN and lockdep. Hibernation, other architectures,
> and long-running concurrency were not tested.
> 
>  mm/secretmem.c | 31 ++++++++++++++++++-------------
>  1 file changed, 18 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/secretmem.c b/mm/secretmem.c
> index 384f5cfc457f..fa8be360bd2a 100644
> --- a/mm/secretmem.c
> +++ b/mm/secretmem.c
> @@ -185,18 +185,14 @@ static void secretmem_destroy_inode_priv(struct inode *inode)
>  {
>  	struct secretmem_inode_state *state = inode->i_private;
>  
> +	if (!state)
> +		return;
> +
>  	secretmem_unaccount_all_folios(state);
>  	free_uid(state->user);
>  	kfree(state);
>  	inode->i_private = NULL;
> -}
> -
> -static int secretmem_release(struct inode *inode, struct file *file)
> -{
>  	atomic_dec(&secretmem_users);
> -	secretmem_destroy_inode_priv(inode);
> -
> -	return 0;
>  }
>  
>  static int secretmem_mmap_prepare(struct vm_area_desc *desc)
> @@ -216,7 +212,6 @@ bool vma_is_secretmem(struct vm_area_struct *vma)
>  }
>  
>  static const struct file_operations secretmem_fops = {
> -	.release	= secretmem_release,
>  	.mmap_prepare	= secretmem_mmap_prepare,
>  };
>  
> @@ -274,6 +269,7 @@ static int secretmem_init_inode_priv(struct inode *inode)
>  
>  	state->user = get_uid(current_user());
>  	inode->i_private = state;
> +	atomic_inc(&secretmem_users);
>  	return 0;
>  }
>  
> @@ -296,7 +292,7 @@ static struct file *secretmem_file_create(unsigned long flags)
>  				 O_RDWR | O_LARGEFILE, &secretmem_fops);
>  	if (IS_ERR(file)) {
>  		err = PTR_ERR(file);
> -		goto err_free_priv;
> +		goto err_free_inode;
>  	}
>  
>  	mapping_set_gfp_mask(inode->i_mapping, GFP_USER);
> @@ -309,11 +305,7 @@ static struct file *secretmem_file_create(unsigned long flags)
>  	inode->i_mode |= S_IFREG;
>  	inode->i_size = 0;
>  
> -	atomic_inc(&secretmem_users);
> -
>  	return file;
> -err_free_priv:
> -	secretmem_destroy_inode_priv(inode);
>  err_free_inode:
>  	iput(inode);
>  	return ERR_PTR(err);
> @@ -335,6 +327,18 @@ SYSCALL_DEFINE1(memfd_secret, unsigned int, flags)
>  	return FD_ADD(flags & O_CLOEXEC, secretmem_file_create(flags));
>  }
>  
> +static void secretmem_evict_inode(struct inode *inode)
> +{
> +	truncate_inode_pages_final(&inode->i_data);
> +	clear_inode(inode);
> +	secretmem_destroy_inode_priv(inode);
> +}
> +
> +static const struct super_operations secretmem_super_ops = {
> +	.statfs		= simple_statfs,
> +	.evict_inode	= secretmem_evict_inode,
> +};
> +
>  static int secretmem_init_fs_context(struct fs_context *fc)
>  {
>  	struct pseudo_fs_context *ctx;
> @@ -342,6 +346,7 @@ static int secretmem_init_fs_context(struct fs_context *fc)
>  	ctx = init_pseudo(fc, SECRETMEM_MAGIC);
>  	if (!ctx)
>  		return -ENOMEM;
> +	ctx->ops = &secretmem_super_ops;
>  
>  	return 0;
>  }


-- 
Cheers,

David

