Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C891CC44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 11:58:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C75E06B0088; Mon, 20 Jul 2026 07:58:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C26926B008C; Mon, 20 Jul 2026 07:58:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3D196B0093; Mon, 20 Jul 2026 07:58:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 882D06B0088
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:58:15 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1F824140111
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:58:15 +0000 (UTC)
X-FDA: 85009006950.27.CCE9AC1
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf27.hostedemail.com (Postfix) with ESMTP id 40E074000B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:58:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ap3FmLC9;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784548693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fxe1A8n/HOI6xv+xqE3ZM0bWb93kXau9xar1FOIxHVE=;
	b=vPGrf3Jb2S61koqNFeZAz0x0ATXNi6BiHvzv7+THKIyd0PK+vohS0ywgSSWhuSQFaUGT1g
	CHPw4V0AdnnWjCzwlsn6bpPrKWAi0yXV+KqNNGNDkHg7LTHmclAwUvtPRlk3rLU2h1PLRI
	GbQqEAdafQ0vTPxGVSTxMxQsPDJY7+0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784548693;
	b=ud9l+cQBwC23pBu0usc1S1Zn59RlmUEoWcvtYeeJZL6oBGZi7pc+WrlYDSEhCiXIMXsKiA
	BnJ3pK4NtU7o2SOeI5aNpuAfDjg6jE1H1MixMx2ZsvKeZFJxyzN/T2ytm8m4mRuFaYJyAQ
	zfVg3G83kxMZeGniDn20mQ3wTov0s0g=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ap3FmLC9;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784548691;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fxe1A8n/HOI6xv+xqE3ZM0bWb93kXau9xar1FOIxHVE=;
	b=ap3FmLC9+CABkuc2ilRJm9vHORiiuYZTT5UCt/oLPr9W1gGeaSVJqCJuzf4ULX05V8CVrV
	OfccRrNyJQgY1GFwmDqWZjKPFoajdDl4cWt8p7L8QEnrvMTHahSg3mupUbvJtHNSx5+OtO
	Pp+hrViFORPXP+c7NUeFdacBQhtWvvg=
From: Usama Arif <usama.arif@linux.dev>
To: Rik van Riel <riel@surriel.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	kernel-team@meta.com,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	linux-riscv@lists.infradead.org
Subject: Re: [PATCH RFC v3 2/6] riscv/mm: add untagged_addr_remote_unlocked()
Date: Mon, 20 Jul 2026 04:57:39 -0700
Message-ID: <20260720115741.239657-1-usama.arif@linux.dev>
In-Reply-To: <20260717170036.743149-3-riel@surriel.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 40E074000B
X-Stat-Signature: 3kzxd6o6xwogm8yoaochrwh6cpxc4xaz
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784548693-720146
X-HE-Meta: U2FsdGVkX1+xGXtUBqfZj/+IK/0FE6iM2M3GCpkn/JWOi1N21qohsiqDeLKnFbXkM6WpdgOJF0tyaJ3P9WGgnLSwwXwcI3IqswiABV4H+SaZPbm5Kl611vl2CWB03JtHrE4n7oOED4+J79tLnNoeko/cqndALUmQ89DUdydyyOL0AEGLHBr4O/aORAWkUuRxEEJntMkPBN0lJBF6Sn/cEB7Z8F3S9b61Kkx0vYzEoYbb88rupj1+URGnKrf1InBrqs14ZrudG+qFYfowLE5lpQfOGpwBwCCY5l4G8lO7c5VtOxkp3haaupHoMjnWnyxKNa69Ac2PCkyoPu1eX1+MJQn1fYoF2/3Y4TahoZnv74QjcCbwP6GfHbTMxnwowRXTDNj6JzzMOK0O1b9KoUD4Bi5h6u3eh9f/Hy8nNVASfodeamyVbnKTUgLrkHggreCe9+by7MbC+4c/clT6ZHokNY/cov8acBfiTd/pwZQFG+Ym8/AGOCIjV17UkABKqm5oj29g1ebDH6P+IYkcYSr/pVA2Je6YIm6dxk+B/pOFSoMxD2qBJhtcqRdxCcv/336oRGoTe/1XndYhA8URHEYuAnuFo/oZzdlxurTvVDJBIngCs9U3OFOXXEk2vgjyPOWIps2QJBi8stM/8PF6V7E1Kh4taZ6//l+c3dmrCF4lshbny86pL3sOiJWZbDRweZVKPokb1gXjtnnDv6tApizdTHDGEN8HMfG603fwPbtCjPO2Xg83zAPm9IuB2lik8fgHV0ELbmZYcSfzhGjmtMLtyFnpWmStahUPduYfV5+/1ZQWtkrXh8g2cGGfW/qpNRaEmwNwisWANgaAQrOiu85BANnb8WXVHUvrTTV0shskEqq/8HsXttbFoCasDkFgM6bRu6jFXjMruKxv+YvZBF8dwaAVwO39srnLb+236Pj5WTdxUelVn7PQ/i/vcy1Y9L4S9A9zCmZ8Y9ax0X7wZWm
 iW2E+8I2
 LTpjlw3JEv3wsgqpwkHFlZE9LYXYTD043qR0izQs4FKjmkoBXT5QNxomT4XaQ92W5uY57QVf7eM5FZ9U1155OONa+L5AmTQgR+OzBmjxIt2C2m1oqLLCeVMi0TcHPOlFbI23z/Fdy+Hxc8pEP5JbBaCGUfrxHo/ECEBHI/qPDPXX6LsqmuemZuiZdjg4GoJx5xGSOYw0GBC1yvSSASBJ/c2M/Dz/p9QpxfroDdbneAYmusIesiSVTc+SgsjLedNf2Q77L/w+9YpEFw5/YdP2aPFu5AMkUVgG4bMsM/1jgbDdnpPI4W+SilSOVFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Jul 2026 13:00:32 -0400 Rik van Riel <riel@surriel.com> wrote:

> __access_remote_vm() untags the remote address before looking up the VMA,
> now without holding the mmap lock. riscv defines untagged_addr_remote() but

This describes behavior introduced in a later patch, not by this patch.
At this point, __access_remote_vm() still acquires mmap_lock before
untagging the address.

> not untagged_addr_remote_unlocked(), so it falls back to the generic
> version, which untags with untagged_addr().
> 
> That reads current->mm, not the target mm, so a remote access to a process
> using pointer masking would untag with the wrong mask.
> 
> mm->context.pmlen is set only through PR_SET_TAGGED_ADDR_CTRL and is stable
> afterwards, so it can be read without the mmap lock, as it already is from
> untagged_addr() and mm_untag_mask().
>

I think it might not be stable? set_tagged_addr_ctrl() can change it
repeatedly until a CLONE_VM operation sets MM_CONTEXT_LOCK_PMLEN.

> Add untagged_addr_remote_unlocked(), which untags against the target mm,
> and annotate context.pmlen accesses with READ_ONCE() and WRITE_ONCE() so
> the lockless reads are explicit and KCSAN-clean. untagged_addr_remote()
> keeps its mmap_assert_locked() and shares the code.
> 
> Assisted-by: Claude:claude-opus-4.8
> Signed-off-by: Rik van Riel <riel@surriel.com>
> ---
>  arch/riscv/include/asm/mmu_context.h |  4 ++--
>  arch/riscv/include/asm/uaccess.h     | 10 +++++++---
>  arch/riscv/kernel/process.c          | 12 +++++++-----
>  3 files changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/mmu_context.h b/arch/riscv/include/asm/mmu_context.h
> index dbf27a78df6c..3ce16796e5a2 100644
> --- a/arch/riscv/include/asm/mmu_context.h
> +++ b/arch/riscv/include/asm/mmu_context.h
> @@ -21,7 +21,7 @@ static inline void activate_mm(struct mm_struct *prev,
>  			       struct mm_struct *next)
>  {
>  #ifdef CONFIG_RISCV_ISA_SUPM
> -	next->context.pmlen = 0;
> +	WRITE_ONCE(next->context.pmlen, 0);
>  #endif
>  	switch_mm(prev, next, NULL);
>  }
> @@ -44,7 +44,7 @@ DECLARE_STATIC_KEY_FALSE(use_asid_allocator);
>  #define mm_untag_mask mm_untag_mask
>  static inline unsigned long mm_untag_mask(struct mm_struct *mm)
>  {
> -	return -1UL >> mm->context.pmlen;
> +	return -1UL >> READ_ONCE(mm->context.pmlen);
>  }
>  #endif
>  
> diff --git a/arch/riscv/include/asm/uaccess.h b/arch/riscv/include/asm/uaccess.h
> index 5d4ec15584cf..53806e0f7dcf 100644
> --- a/arch/riscv/include/asm/uaccess.h
> +++ b/arch/riscv/include/asm/uaccess.h
> @@ -16,7 +16,7 @@
>  static inline unsigned long __untagged_addr_remote(struct mm_struct *mm, unsigned long addr)
>  {
>  	if (riscv_has_extension_unlikely(RISCV_ISA_EXT_SUPM)) {
> -		u8 pmlen = mm->context.pmlen;
> +		u8 pmlen = READ_ONCE(mm->context.pmlen);
>  
>  		/* Virtual addresses are sign-extended; physical addresses are zero-extended. */
>  		if (IS_ENABLED(CONFIG_MMU))
> @@ -33,12 +33,16 @@ static inline unsigned long __untagged_addr_remote(struct mm_struct *mm, unsigne
>  	(__force __typeof__(addr))__untagged_addr_remote(current->mm, __addr);	\
>  })
>  
> -#define untagged_addr_remote(mm, addr) ({					\
> +#define untagged_addr_remote_unlocked(mm, addr) ({				\
>  	unsigned long __addr = (__force unsigned long)(addr);			\
> -	mmap_assert_locked(mm);							\
>  	(__force __typeof__(addr))__untagged_addr_remote(mm, __addr);		\
>  })
>  
> +#define untagged_addr_remote(mm, addr) ({					\
> +	mmap_assert_locked(mm);							\
> +	untagged_addr_remote_unlocked(mm, addr);				\
> +})
> +
>  #define access_ok(addr, size) likely(__access_ok(untagged_addr(addr), size))
>  #else
>  #define untagged_addr(addr) (addr)
> diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
> index b2df7f72241a..6ae7552fed09 100644
> --- a/arch/riscv/kernel/process.c
> +++ b/arch/riscv/kernel/process.c
> @@ -357,13 +357,15 @@ long set_tagged_addr_ctrl(struct task_struct *task, unsigned long arg)
>  	if (mmap_write_lock_killable(mm))
>  		return -EINTR;
>  
> -	if (test_bit(MM_CONTEXT_LOCK_PMLEN, &mm->context.flags) && mm->context.pmlen != pmlen) {
> -		mmap_write_unlock(mm);
> -		return -EBUSY;
> +	if (test_bit(MM_CONTEXT_LOCK_PMLEN, &mm->context.flags)) {
> +		if (READ_ONCE(mm->context.pmlen) != pmlen) {
> +			mmap_write_unlock(mm);
> +			return -EBUSY;
> +		}
>  	}
>  
>  	envcfg_update_bits(task, ENVCFG_PMM, pmm);
> -	mm->context.pmlen = pmlen;
> +	WRITE_ONCE(mm->context.pmlen, pmlen);
>  
>  	mmap_write_unlock(mm);
>  
> @@ -394,7 +396,7 @@ long get_tagged_addr_ctrl(struct task_struct *task)
>  		break;
>  	}
>  
> -	if (task->mm->context.pmlen)
> +	if (READ_ONCE(task->mm->context.pmlen))
>  		ret |= PR_TAGGED_ADDR_ENABLE;
>  
>  	return ret;
> -- 
> 2.53.0-Meta
> 
> 

