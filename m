Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4756C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:49:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC7AD6B00A7; Mon,  7 Sep 2026 12:49:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B77C26B00A9; Mon,  7 Sep 2026 12:49:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB5666B00AA; Mon,  7 Sep 2026 12:49:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A8D46B00A7
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:49:38 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 26FDF1401E4
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:49:38 +0000 (UTC)
X-FDA: 85187552436.06.0B6B135
Received: from mta1.migadu.com (out-111.mta1.migadu.com [95.215.58.111])
	by imf07.hostedemail.com (Postfix) with ESMTP id F1CE040003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:49:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QQpm8w8q;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.111 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788799776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JiYU6625XtKri1a7IwSypZL7ttmfsbZ/QVL6tjZz+Zk=;
	b=MIXmpZLcSut6YhebrVBFpE8EMLMgbUyvTqLI49u4WBzMSlgKWZ+asdQSmAZ7HO5hWGUl7A
	rvcY7pcIvnL1OhyPfRnsxjEmx2pUj1Pcs3IvthwLYqjODSpzRQ31xdjs4psLZbzPNwPy7Q
	007VCQa80tJH+ygmzd9bhi9oh9fb/Nk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788799776;
	b=LBP8yIXbVx/GW+ZnwzltmVKqwyfKjWKfcpheQtRGkOk2gK5KahrZhkm3IQqtOblLxPG39g
	zOQArXOAAa1h5vIJZGogLd2I2CKHKvRjyCV8I5V5aBuqNApwG7N66QuTsuqrrqPl1ii522
	sMhMoo2poAL9R5wE3wEV7bRIa4NG+ns=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QQpm8w8q;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.111 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=aiOV96iWD1E/8/sYj8GdsqnibwPCG/X4Yj+j2mG5QNs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788799774; v=1; x=1789404574;
 b=QQpm8w8qtlyl4A29Mq6LnWHurYgAMCMDz+IP0s22x/N0nM/hcuEbmZ5o0tzh+VcdNjCr3Reh
 OFnSHnHBZZNkvbzy9FKBNEf0SBsQLLgMuHSlBS+PPYe0YiqW1KLbxCn251Ze/xK9zS4bEAuMvbB
 6T8MKteHfhqzXgK7TUMxIYYY=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id b961d15e53dc88c5;
	Mon, 07 Sep 2026 16:49:34 +0000
X-Mizu-Trace-ID: b961d15e53dc88c5
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	david@redhat.com,
	willy@infradead.org,
	jannh@google.com,
	paulmck@kernel.org,
	pfalcato@suse.de,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 2/5] proc/task_mmu: remove unnecessary inlines in function definitions
Date: Mon,  7 Sep 2026 09:49:30 -0700
Message-ID: <20260907164931.131215-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260907063918.3432401-3-surenb@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: thhp3p5co8hu4py9oszrz7ad5r8ruzjq
X-Rspamd-Queue-Id: F1CE040003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788799775-749697
X-HE-Meta: U2FsdGVkX19noP+KxsbxvUsDLxMNMw1zr5s1e2j2Yykwio9Bg08UKuSX7ddLRcXiujlPFBCymZn6ExAW8KNZSmGgrx/fpFwXR0bK4KhtIpMvkUVPCpf6+3KPpbLNLwsD1z84s7O/D5lH2MWuC70dIUm9S5POnaqmmqmrpJmg2ZYUEU+mWs3a40ifUzkKeHNgXILpDJucHF8JRXWTqEXQ5pWjrLTjVAIgS5RZvg9f66n4JsclcU3LCJsvIOPKTxFAUr+2AmoNTTHp022kKYsA6Ik582UcTzWmvVg/ATLYw/sQN7uwhHm6Kh4GwFmfTmbqFPpQ73C/z/T3CJGR/iwE4/MLTIT0wXBQsYNbBznq8N3AuNV7w+w1tSic24R1yx5+tJ7SlxbFKIiDvnj50QCeQWmsVnLzhwVncFyqlJr7VlsE4rLUVGjL2QZyaEhhjyOKkZtyxWO0ikgpI2NK+8EbRU4TOPnRucX7jpkRDM85+Q2CoDUG5TB8o9+9r9UWP+65U8J8mKlHC/F0FzGWUf2AzCDQ9puLCbs5oFfs1KxMG2hxdhyEGtuOHv6QHaOBkiFxBz7FCmc899LLFQa6BFsiWSksGEtH3b6xU42SLay2y9umrbRhLfRxnERMyp8cIWUGZ541KShxqAEvt6cQkROyH2WCKk8u9x5DetLozAAg38GO+gg63W87g3nJOgO58NhuW2Dx8vIR5OX2A2YJ/IzNCFO2NALbgas/t4YkGKltyAG58EvsGdBQhmymgrhHCXLoJEzVl2Iw8T+TrrRZg5zgaMQK4iBxKKRbD6ANnbaqUfcaITjVFCgXiSZIbSm/3Mz1MN+DA6bqVD6RCEEQPV3J8TFKQoM4/FOYGCwGXlDGavai9mit8knJmybP+w9paBGJJgxgKBzLtseCaYylw5v9pherMdhAMst5/xTvkFUdvQmSLGXjnKdXxVYJmGhrxtxS6SNzeagmS3X4LmtYRcb
 jguL8X9L
 O4RCZ1BM79cLXrtXmu75r3RMv/Jgu+fD9yxyLC/dEOVfuEXU6az56JUmQH8H7481avvvvUYlK1TqMSflEE5qS+Z3URw4CFIzN73Zh8A61PNts7c/ExoQx1S6LCRQM5Wkr485vm3kMUbaw8TGwWhpKS3EqkCZlTZhV9hRL067l9kNuh3bDv8dh7X/4JKOASZo0Vxs71Cz1+auY7ZcIrAAGvr3Q3AMsBGukUIjHzdxS0bUZyGVlW9jeIduf5kXq5tKZBeOePgwg5EXM8IgPXBdo85o5lbbQma467VCMw7RgmG0b97A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun,  6 Sep 2026 23:39:15 -0700 Suren Baghdasaryan <surenb@google.com> wrote:

> It was pointed out in the previous reviews of this code that many
> functions are specified as inline, which is unnecessary as the compile
> can make that decision by itself. Cleanup these definitions.
> 
> No functional change intended.
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
>  fs/proc/task_mmu.c | 32 ++++++++++++++++----------------
>  1 file changed, 16 insertions(+), 16 deletions(-)

Most of these functions would be inlined anyways so should be ok.

Curious if there was a change in binary size with this?

Acked-by: Usama Arif <usama.arif@linux.dev>

> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 2f500d639db5..9908ba32f180 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -130,7 +130,7 @@ static void release_task_mempolicy(struct proc_maps_private *priv)
>  }
>  #endif
>  
> -static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> +static int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
>  {
>  	int ret = mmap_read_lock_killable(lock_ctx->mm);
>  
> @@ -140,7 +140,7 @@ static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
>  	return ret;
>  }
>  
> -static inline void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> +static void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
>  {
>  	mmap_read_unlock(lock_ctx->mm);
>  	lock_ctx->mmap_locked = false;
> @@ -177,7 +177,7 @@ static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
>  	return vma;
>  }
>  
> -static inline bool fallback_to_mmap_lock(struct proc_maps_private *priv,
> +static bool fallback_to_mmap_lock(struct proc_maps_private *priv,
>  					 loff_t pos)
>  {
>  	struct proc_maps_locking_ctx *lock_ctx = &priv->lock_ctx;
> @@ -194,7 +194,7 @@ static inline bool fallback_to_mmap_lock(struct proc_maps_private *priv,
>  	return true;
>  }
>  
> -static inline void drop_rcu(struct proc_maps_private *priv)
> +static void drop_rcu(struct proc_maps_private *priv)
>  {
>  	if (priv->lock_ctx.mmap_locked)
>  		return;
> @@ -202,7 +202,7 @@ static inline void drop_rcu(struct proc_maps_private *priv)
>  	rcu_read_unlock();
>  }
>  
> -static inline void reacquire_rcu(struct proc_maps_private *priv)
> +static void reacquire_rcu(struct proc_maps_private *priv)
>  {
>  	if (priv->lock_ctx.mmap_locked)
>  		return;
> @@ -1230,7 +1230,7 @@ static const struct mm_walk_ops smaps_shmem_walk_vma_lock_ops = {
>  	.walk_lock		= PGWALK_VMA_RDLOCK_VERIFY,
>  };
>  
> -static inline const struct mm_walk_ops *
> +static const struct mm_walk_ops *
>  get_smaps_walk_ops(struct proc_maps_private *priv)
>  {
>  	if (priv->lock_ctx.mmap_locked)
> @@ -1238,7 +1238,7 @@ get_smaps_walk_ops(struct proc_maps_private *priv)
>  	return &smaps_walk_vma_lock_ops;
>  }
>  
> -static inline const struct mm_walk_ops *
> +static const struct mm_walk_ops *
>  get_smaps_shmem_walk_ops(struct proc_maps_private *priv)
>  {
>  	if (priv->lock_ctx.mmap_locked)
> @@ -1572,7 +1572,7 @@ struct clear_refs_private {
>  	enum clear_refs_types type;
>  };
>  
> -static inline bool pte_is_pinned(struct vm_area_struct *vma, unsigned long addr, pte_t pte)
> +static bool pte_is_pinned(struct vm_area_struct *vma, unsigned long addr, pte_t pte)
>  {
>  	struct folio *folio;
>  
> @@ -1588,8 +1588,8 @@ static inline bool pte_is_pinned(struct vm_area_struct *vma, unsigned long addr,
>  	return folio_maybe_dma_pinned(folio);
>  }
>  
> -static inline void clear_soft_dirty(struct vm_area_struct *vma,
> -		unsigned long addr, pte_t *pte)
> +static void clear_soft_dirty(struct vm_area_struct *vma, unsigned long addr,
> +			     pte_t *pte)
>  {
>  	if (!pgtable_supports_soft_dirty())
>  		return;
> @@ -1620,8 +1620,8 @@ static inline void clear_soft_dirty(struct vm_area_struct *vma,
>  }
>  
>  #if defined(CONFIG_TRANSPARENT_HUGEPAGE)
> -static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
> -		unsigned long addr, pmd_t *pmdp)
> +static void clear_soft_dirty_pmd(struct vm_area_struct *vma,
> +				 unsigned long addr, pmd_t *pmdp)
>  {
>  	pmd_t old, pmd = *pmdp;
>  
> @@ -1646,8 +1646,8 @@ static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
>  	}
>  }
>  #else
> -static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
> -		unsigned long addr, pmd_t *pmdp)
> +static void clear_soft_dirty_pmd(struct vm_area_struct *vma,
> +				 unsigned long addr, pmd_t *pmdp)
>  {
>  }
>  #endif
> @@ -1846,7 +1846,7 @@ struct pagemapread {
>  
>  #define PM_END_OF_BUFFER    1
>  
> -static inline pagemap_entry_t make_pme(u64 frame, u64 flags)
> +static pagemap_entry_t make_pme(u64 frame, u64 flags)
>  {
>  	return (pagemap_entry_t) { .pme = (frame & PM_PFRAME_MASK) | flags };
>  }
> @@ -3388,7 +3388,7 @@ static const struct mm_walk_ops show_numa_vma_lock_ops = {
>  	.walk_lock = PGWALK_VMA_RDLOCK_VERIFY,
>  };
>  
> -static inline const struct mm_walk_ops *
> +static const struct mm_walk_ops *
>  get_show_numa_ops(struct proc_maps_private *priv)
>  {
>  	if (priv->lock_ctx.mmap_locked)
> -- 
> 2.55.0.979.g7e5102b832-goog
> 
> 

