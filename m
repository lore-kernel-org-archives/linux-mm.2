Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D88CCD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 08:28:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70E2B6B0005; Tue,  9 Jun 2026 04:28:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E5686B0088; Tue,  9 Jun 2026 04:28:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 622846B008A; Tue,  9 Jun 2026 04:28:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 528786B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 04:28:05 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 16CF7164737
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:28:05 +0000 (UTC)
X-FDA: 84859696530.14.3D43D56
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8112A140008
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:28:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ePD+sA10;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780993683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KUTWvkYgd4SUoz3GQ3EreKamUH7kzM6u+lTKw2+UhB0=;
	b=NBm7cINsHzHWF6cq4q3PafmzqxNc38fcLKZ2+EeLcvX/TIA66rlit3i19AG3DfZN4nXyJ/
	+GQjavKQIx0nHyvrhCRUUHiWnifz84ZMocA9KZUR3g8MJRKtsU4Mche1+Wn4e6eHP8aOV7
	08HF1Vd5LL/Ry0zEQsnbPV+WMarzYpQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ePD+sA10;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780993683;
	b=c9sG1x6Qa+uLLikSifI8E681P6GfGvHxbjAXfgLPO4kZ4iOWIzZFxR5EhUmuyKBujquK9H
	7xxehhX0DG2QZr5zfWQVSiW9AuJjmwACtOWm0SF2ZTAgINf09nZfGzeNJejU/OOZ773EYF
	Cld6l8t9RPH9Vh6nnVnl5d9tm431i1k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 01614601DC;
	Tue,  9 Jun 2026 08:28:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36681F00893;
	Tue,  9 Jun 2026 08:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780993682;
	bh=KUTWvkYgd4SUoz3GQ3EreKamUH7kzM6u+lTKw2+UhB0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ePD+sA10auk+0GlzUNcXqGiA8HKi9Y2JwdUhisxwcywX35moIyMcANbTc/VRTQR51
	 MFUniUu0p7IYhynxwNLyu9DK2+4bdeMicIOdPck5dsrai7aWkMWZ8Gzqvl14HSbcHy
	 YE5h+kNNN5zaeYqYUloL6UIVR+QXltPLiXsoeqRd8IxXJvKqRZ8/vC/jZP2nacV6tm
	 JF7koe1kXEKnDblzzOl1pQvxXc1S1WrIYcWyOVnXhC2qkVLQYeaHU72h3uc885vivn
	 T2PDleobwrFY4cxvaH2202R6Kv63uQcLtOK9UdL4CUrq1Z8cSLbQJy8vuLu/cH+IjJ
	 enacxdiPUbdgw==
Date: Tue, 9 Jun 2026 09:27:56 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] fs/proc/task_mmu: change lock_vma_range() to return
 error code
Message-ID: <aifEZEisSFABmYiW@lucifer>
References: <20260606015729.1837935-1-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260606015729.1837935-1-surenb@google.com>
X-Rspamd-Queue-Id: 8112A140008
X-Stat-Signature: mu1cgb5e15nhrdnye5n4kyi8redoxs4a
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780993683-439477
X-HE-Meta: U2FsdGVkX18iGbyfNY1LpnyPFSo3hnaWsxuRHxKcMVMqmYDFe38lvaky8PxfaG33Cy4t8GPU86H+7IrX1Gdtb47ftyK0IpzaRBn874SuMss3POnw5Xl6jaYFRyhxYAbPg4goX87UtAi7AC9ViMDBBJeCtkmITUrBshuqxSZcEe6TfHA84kP3NViYI870n/FCkt1Az9cHPbWgj9DTDvVWGkvgwoevqLRtJdjyMb9r+LNwyRvLcYP3bHe+73gIF8qanByJfVIlbWaYbC6b+uI5IRqtplAij7EEXMUctaWqJpPjUN8A4MSdIy6pPYglDVWffQCCLII6MC19YURU+XwkW+vehn8AG+1q02RVZCdthVuNziJeR7Pl39bfNhcLC6/iL+PrxeW9knhv+YBGkvXgPeKM+HOs42cDl1fXujUCjV4dGoV9v+5m6BqrGyY5dOv5JHEJaKuAa3W+cshcPwk5mx3fxY6+otgP4Y42TlAf9cxSn1bAJeSqUANCYcyXhjWfCntCFqnBa0kblDLquqY1SGFMpIahbe3ytTfTrCVFWLxNXaRy1ZL2P8M/u+wd+JEpSzMyFDJIjq8lPfNLxjook/3D/W1zs6RjGsbO1Al56Cx0cVgp61/GZNVmM6QUXvD4DJxxqjfFqh/hQ4JyrDRvKZ6/j2jOj9hUUw7egjEmor1Eo9LoB8IgPsouLhKzKVbkUjOCuyNmZrAKsGuNI+k4jVxLVpg9xvcY5eSvgu/3vxfILUagrkcUcK16IE2DU01MUzzAZz7l2/Tv765oBRovddhkBLb4whzzhm2ZI+esaFOVv9FRhKAHwFQ7p1WFrq7wpmZKkqP8yeKaLGFWKHIvyTIHoXEF/3nzPkeRvzoB0CUBbkoeBvokp+8iDhnozamWY8FLHgt+vrODknH2Cib+vj4zG2ZALgefAN9Ahc3kpnVvzfpyY3CNRW7ymP/HvhSjWIg90YILfYT9ZqawI9T
 HLXVY2Px
 m1zl2nMKbUePrfFG7F7fvGuys1ssuRZnq3Ge6oietikC3YDFe4tI5LY0C4gETwizL/gPxZPYSDvkb9Tr+eP7mepXClgma5e43PgfgVvi7obgfDLYrAHVGIiJvwp9BrJKP213cp7BzFtK2iXaAVE8hBSknmb4YDDbV2EKRY5OtyTSrrQ9ZaGi8FTrI+9K9+98/oBoeGz82h8ArrMUKxfRdfI6nLkibcb0XxMANfT+99UoCuOETsr/w/MAHliG+96rZUaFpDQ49Yt1zxy2oBYKoNWepa0c8+r8UBkXBSi0wJruuv/FYpBxdkXExKSQf6FwXadXEmJxNI6k3URCSmnttZ8RU4qI38bFCe2Ln
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 05, 2026 at 06:57:28PM -0700, Suren Baghdasaryan wrote:
> To correctly propagate error code from lock_vma_range(), change it to
> return the error code instead of the boolean. This simplifies error
> propagation code.
>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Logic LGTM, couple nits below, but:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  fs/proc/task_mmu.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index d32408f7cd5e..023422fcee12 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -162,13 +162,13 @@ static void unlock_ctx_vma(struct proc_maps_locking_ctx *lock_ctx)
>  	}
>  }
>
> -static inline bool lock_vma_range(struct seq_file *m,
> -				  struct proc_maps_locking_ctx *lock_ctx)
> +static inline int lock_vma_range(struct seq_file *m,

Could drop the unnecessary inline here while we're here.

> +				 struct proc_maps_locking_ctx *lock_ctx)
>  {
>  	rcu_read_lock();
>  	reset_lock_ctx(lock_ctx);
>
> -	return true;
> +	return 0;
>  }
>
>  static inline void unlock_vma_range(struct proc_maps_locking_ctx *lock_ctx)
> @@ -245,10 +245,10 @@ static inline void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
>  	mmap_read_unlock(lock_ctx->mm);
>  }
>
> -static inline bool lock_vma_range(struct seq_file *m,
> +static inline int lock_vma_range(struct seq_file *m,

Same comment as above.

>  				  struct proc_maps_locking_ctx *lock_ctx)
>  {
> -	return lock_ctx_mm(lock_ctx) == 0;
> +	return lock_ctx_mm(lock_ctx);
>  }
>
>  static inline void unlock_vma_range(struct proc_maps_locking_ctx *lock_ctx)
> @@ -311,6 +311,7 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
>  	struct proc_maps_locking_ctx *lock_ctx;
>  	loff_t last_addr = *ppos;
>  	struct mm_struct *mm;
> +	int err;
>
>  	/* See m_next(). Zero at the start or after lseek. */
>  	if (last_addr == SENTINEL_VMA_END)
> @@ -328,11 +329,12 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
>  		return NULL;
>  	}
>
> -	if (!lock_vma_range(m, lock_ctx)) {
> +	err = lock_vma_range(m, lock_ctx);
> +	if (err) {
>  		mmput(mm);
>  		put_task_struct(priv->task);
>  		priv->task = NULL;
> -		return ERR_PTR(-EINTR);
> +		return ERR_PTR(err);
>  	}
>
>  	/*
>
> base-commit: e178a530a81621a29efbca49b3b78202a18236e4
> --
> 2.54.0.1032.g2f8565e1d1-goog
>

