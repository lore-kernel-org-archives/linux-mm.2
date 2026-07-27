Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95304C531FC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:50:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 853DE6B00B3; Mon, 27 Jul 2026 10:50:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82B5A6B00BF; Mon, 27 Jul 2026 10:50:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71A506B00C8; Mon, 27 Jul 2026 10:50:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 425E86B00B3
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:50:23 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B7D871C0F1E
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:50:21 +0000 (UTC)
X-FDA: 85034842242.13.6135D50
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf27.hostedemail.com (Postfix) with ESMTP id D32D84000A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:50:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VposDpgU;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785163819;
	b=46Ptywt9T/rN+BmxzsvtK4KReF4Px3ob2+a8K8qiAisHotnXupK7IZ5fR1ADz32i+0HwaD
	RTiHtcSH3bph961o9mjsF5tx1dQjosDCct02njBRg2uhQHt7F1K353sSPLFo6qgWxunOJy
	m0M6FNRuVB8QDBYNJjOvCeDBlyGKnqg=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VposDpgU;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785163819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bAPW3ovGuZVvQWuBxHd8Rf3R36UmFvlEDn3mBs3eyIg=;
	b=3D1yM9ULMvv5n0eJ+Or/xQvT04uuKRy1TdZ3ocsMsm/JwxuOC3QVbb00zrsCzJVacdwohY
	x16bGglzGQpTadTSZf65Nay1qbziDoRCXQJSEi6JBYM87Ir2uC+vU9BCLJ6t6LlMHj0SBn
	pfRiqdtvLd+7lowvX2QfL3gV+TT6i6o=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51c01c79467so442181cf.0
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 07:50:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785163819; cv=none;
        d=google.com; s=arc-20260327;
        b=HCaFyel+DCZmtQ2Fgg3ilHgOz43texuoXd7EG/iHwh3eaIQZhKAEOryQU90IS3w3MH
         OpEHNQO9CD/BYzWpVz3BIOm2bngxe9RSV1zOmq2doVxYJL5E2d2pJUEDP5MwoTFwnZAa
         Cb5oGyb9dfN4jnLiCaHWux9Po3dKN0SkjIHG0cfgyPH4pgXHWcMz6xSAem8EsCtsSh0o
         A3ixWFzFqIfRebpnxUkTn0wQVn7KMsE+kPb5zNtht/bKVXdafjGJVUMoIafFtoxj8Zx+
         JvzdidX/2FynOlvYFpminnWWj8/a6qAdB7W6FfAMHA3RBEtMB+U3umjXP8jRxqg/RnqV
         G4LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bAPW3ovGuZVvQWuBxHd8Rf3R36UmFvlEDn3mBs3eyIg=;
        fh=tHhIsOytqvjuM5SzaCwF9iQEOXGczf2UMNzV1D/X5fo=;
        b=FfyBgZ6048ku2B9D/cIR3JSq+r1X9wHqTfuFTiyIsv23MvSzYc9KZ1bJn2k04Vpvnf
         OgmwSsdG9vmJKkQM1pL+6WlVUPSsTRIyxVdq1bW2twqwTa0Pleg6+XT/WFKZqUXpve1t
         7h2JKLwKcojzKT2kj29TGcmWrNKHC0crF3RYxGV5foHx4QJZ0p2UkRwm+t5no7RosuPx
         NAFQDhGJ8SCjP6Cmg7AhI8Ku574WlwmWXx9T/ZJb6vQEpPKspWO1YS5MwoQoo0YijWM+
         fOb8KltpI7pDB5UxklXR+Ubglcb11LJHk5iPJHDanAWUulT9SXFNLFOOI+yWEf+A/L0c
         7bOg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785163819; x=1785768619; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bAPW3ovGuZVvQWuBxHd8Rf3R36UmFvlEDn3mBs3eyIg=;
        b=VposDpgUCNNC3skErxA4I5fqpiIAcAOiYWpaS69zEKixdBsPW37c8xlMR/DO6qDwAF
         QGZ/ZfRKuN+DkILRNupMkrs2OEXFh7mzW4821YJEpuXRXD8NBhhMvvO7QswhYwsc6Pvl
         T4MZo24R8tSE4b7WY9UGv0MV2/MSFTKA3s88CCjPIHJgNEllAMwhzDySk4f+JkrxGLzo
         1u8JqUbju9ev/jwiBmcgrVKBysbv6ENlMQRMU5MZo9ZwU58RQLdu8eALi/jwKnfg/567
         pT6jR/iDYp36VXjayNgKW2x0xd12JkNhIGRQgM2kJWBfCc8gwhZlH/B5Cq+q6l7qLnAX
         rHvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785163819; x=1785768619;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bAPW3ovGuZVvQWuBxHd8Rf3R36UmFvlEDn3mBs3eyIg=;
        b=ekCiVrfIb9ijY52N8+/LRgzkRcCEOD33qh9IQ3aej0u7kBf3FuJ917dD9GdTdREgT3
         0OvZ4Kig1i7kL385WqOTHcqT/0hL5GS/ITR5B0Yq+M/8xyiU34CwCMmkv2mosTELM/Gv
         zmBbH3t0ihUSyTmfpXxQOwf+eD3GyGpzhgCZ8jbSyNTEt/8CA07su+ORDB1cA6XnwHwI
         HmYK9d+SS3yHugW9bDSElvptBfuQIo7Qoz6hUZfTxx2kjfN7s0uRhIrI44GP+wwZU5jL
         jn17w3Txj3I/iUCinzPDjMQzYi97PZLe3kl9Ad5KzP5hyenhppYk+2DCoRHjR0m7ZOjO
         uVtw==
X-Forwarded-Encrypted: i=1; AHgh+RoAoPcAGemq50OOcZEDTlFwkCzgbLecJb7uU4sGvQz3aHQhQPWXDU3zwyyR2cHCqA69YOd9FjFoyw==@kvack.org
X-Gm-Message-State: AOJu0Yy3/SQUou1Wgmmb0trMbpZjcFXXHD1OUJiyG02jQfwTWTon8I/H
	dxHvgypXRe6/7F31Y3euTlSQlC+Yv9G/Z/qMOQa23lShdCAEWjjX/5P+OxdNVpOVHG2OnSW5DZR
	phPpJrudbKL016Y2K/OwwE9O69hvnC/WKZ5K7RoQR
X-Gm-Gg: AR+sD10ofxKrDu3YV8tVbXnzn1WYPsM7YMP7uCRzvhUnroVUfRG39r28PpGW+s+diRR
	lf9UOEui4vqK0Kwd0fs0UtGEuCMvrQnpFhrg93P0jlgzUQ7KvaTxlSYEZbNidemxBtvdZK310p6
	uPS31Q/pGazpUMJpz5L/Yxkeov275Or33Sbxp8H9ybSHTK3uOunGq2meZYBZmRNeky5cnsNeZsC
	bFK+edbTzbKsw9lZZie0qUWrFoLrgsZCOBNaXaeqtEbdDA69QidF7N2LeO9
X-Received: by 2002:a05:622a:8c17:b0:517:6dc0:698d with SMTP id
 d75a77b69052e-529a5be6c10mr38719201cf.0.1785163818356; Mon, 27 Jul 2026
 07:50:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260724222934.1463812-1-riel@surriel.com> <20260724222934.1463812-2-riel@surriel.com>
In-Reply-To: <20260724222934.1463812-2-riel@surriel.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 27 Jul 2026 07:50:07 -0700
X-Gm-Features: AUfX_mxEPCoFMyimH7eGSVfDujoNBhRk9Ey9QwAw6I6bFceMnESqRS08nfT_-Jg
Message-ID: <CAJuCfpFdEts19VJSoywvvp0WqC=vLeLuCd3FknVQnpC-45ELHQ@mail.gmail.com>
Subject: Re: [PATCH RFC v4 01/12] x86/mm: add untagged_addr_remote_unlocked()
To: Rik van Riel <riel@surriel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kernel-team@meta.com, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Usama Arif <usama.arif@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 1f8hek5tufs1oip38eazz8yt8wc73wou
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D32D84000A
X-Rspam-User: 
X-HE-Tag: 1785163819-311841
X-HE-Meta: U2FsdGVkX1/Fq1uxOu6FIlIoRBCQ6p8T9s3ZskGa9Xp9xPIrCHP6vLjOZtXFArGk9jAkqbcBm9kdkx5Tyj7hXE2Z/rgZueIPto8MBwgOtgv002opnjn3YaWoLaoNyml9MrBQFkZCzZ1caxmP9f4VtfTJXpr7/le0Fe/KnIZaW73KoJskOnhKviRfjXJMia86y94LjP/xHAPrDOO5lV25FCwf29fR66qaYzhFclMB8Z3u2i95w9QAjjgLx67QBeek0+HOxCPeZNOX34A47MtWQ/iYSkKRLi+NfGosLeYSE4G2H70l0vy848yxOgad9FkHjCtKAxDcK+o7VjbZIev4YYGaQIvjS02UfGjprfsYTDdLfxsMM/cddtjZfioeuxsU/qpoGn0wTYFcHuHRy786WC8/5+Q42HA661xW5kSZvJl4cyDe+i1tdHOubkNG+AvQZ3dCJ7av1Aqgtz5KqiujGUd0+c67j2mJ0p1g0vscwRUfSOGZgBwnaHp7aCgurl4+kJZCFHEWPUC+h4hF0tI9dUT6l3i9fCzammGS1trdpX8ONTEq6ebOYLBIKPcxhukv0H9C9LiT7sKeu1/vuHDPtjuPRq3QjAYsWTwIhEHF93Z++voKwKHZtpHiZyxZI3OXBmxwCb+S/Bp5DXqYG6VsTSam5yM7lA2jUJMfLDZtea3GpGhXJUnCujgOXcC0zK6tIjmg0j6k+UKjrKvn8VwxmMQdLxHPzttooigzyFj21184bXmulvxc2z5kvlkYg6vYJpZNO7dx00ovM4lBLlkg9lHgX5/iguoObb7ePJGYkUUnht+hNah/RGT3OnI6qitd02QpGTmDY5LeeR+mwc/VLnWjg6rsbIIy7XQPRmQ8/YSUxfygiR0nS7jf5x2sHIMJ7WgQ2vnq08IA1NSuCrbSYO+5UjfIxJyEwOG2iBWKKJ/DQsZM4TZRhpe6D6xZZwjmnO+hDSbEz9bMWauirUX
 q3mRur53
 a55PT3TFLCuy1mAfyTfpV0MheVRzIVdYp7OEpB4Fd8r69CkKE1OAWKFL1u0xveIbUDOBSfEpxHziWnd6vu75YEM7xY1gFd0MR8CNGU2i+CSGVRd66/AcY9JsEG7qDzXaHLzin40Rp2INTCmpAaTVSYyvvuY1M1zbdRqkvnh2mrIT+vyuSEO+yzleS4ZkBgt6CvnDUMfhW/PLK0JGgxXfLrfJmBL6YLPRM4saU/RUedntobZYUuBxgUR24zjY8o99x5UND3JXET8tRt2oLwcs1Uj6VV2uH378blBqan2yKMCyd+IsTJF9hpuHRx7nv4+Qv9cwRMffDFQP2dT5fVzpI1o1jHCGHAEicnZiwdxF1TWTw2zBWLQO0juu+vA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 3:32=E2=80=AFPM Rik van Riel <riel@surriel.com> wro=
te:
>
> __access_remote_vm() reads another process's memory under the mmap lock. =
On
> large machines running big multi-threaded applications, that lock is
> contended between readers and writers: an mmap() or munmap() in one threa=
d
> stalls readers like /proc/PID/cmdline, /proc/PID/environ, or
> process_vm_readv(), even though the memory they read is almost always
> resident and reachable under the per-VMA lock instead.
>
> Looking up the VMA first requires untagging the address.
> untagged_addr_remote() asserts the mmap lock only because it reads
> mm->context.untag_mask, which can race with the write in mm_enable_lam().
>
> That mask changes only while the target is single-threaded, when it
> enables LAM or resets it at exec. The read need not be stable: it is
> already read locklessly elsewhere, and a remote untag is best-effort.
>
> Add untagged_addr_remote_unlocked() for callers that have not taken the
> mmap lock, and annotate access to mm->context.untag_mask with READ_ONCE()
> and WRITE_ONCE() so the existing lockless reads are explicit and
> KCSAN-clean. untagged_addr_remote() keeps its assertion and shares the sa=
me
> code.
>
> Assisted-by: Claude:claude-opus-4.8
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Rik van Riel <riel@surriel.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  arch/x86/include/asm/mmu_context.h |  6 +++---
>  arch/x86/include/asm/uaccess_64.h  | 15 ++++++++++++---
>  arch/x86/kernel/process_64.c       |  4 ++--
>  include/linux/uaccess.h            |  7 +++++++
>  4 files changed, 24 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mm=
u_context.h
> index ef5b507de34e..cee710f64658 100644
> --- a/arch/x86/include/asm/mmu_context.h
> +++ b/arch/x86/include/asm/mmu_context.h
> @@ -100,18 +100,18 @@ static inline unsigned long mm_lam_cr3_mask(struct =
mm_struct *mm)
>  static inline void dup_lam(struct mm_struct *oldmm, struct mm_struct *mm=
)
>  {
>         mm->context.lam_cr3_mask =3D oldmm->context.lam_cr3_mask;
> -       mm->context.untag_mask =3D oldmm->context.untag_mask;
> +       WRITE_ONCE(mm->context.untag_mask, READ_ONCE(oldmm->context.untag=
_mask));
>  }
>
>  #define mm_untag_mask mm_untag_mask
>  static inline unsigned long mm_untag_mask(struct mm_struct *mm)
>  {
> -       return mm->context.untag_mask;
> +       return READ_ONCE(mm->context.untag_mask);
>  }
>
>  static inline void mm_reset_untag_mask(struct mm_struct *mm)
>  {
> -       mm->context.untag_mask =3D -1UL;
> +       WRITE_ONCE(mm->context.untag_mask, -1UL);
>  }
>
>  #define arch_pgtable_dma_compat arch_pgtable_dma_compat
> diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uac=
cess_64.h
> index 20de34cc9aa6..a095165eb648 100644
> --- a/arch/x86/include/asm/uaccess_64.h
> +++ b/arch/x86/include/asm/uaccess_64.h
> @@ -39,18 +39,27 @@ static inline unsigned long __untagged_addr(unsigned =
long addr)
>         (__force __typeof__(addr))__untagged_addr(__addr);              \
>  })
>
> +/*
> + * mm->context.untag_mask changes only when the target enables LAM or ex=
ecs,
> + * always single-threaded. An unlocked remote reader can race that; READ=
_ONCE
> + * keeps the value whole and the untag is best-effort.
> + */
>  static inline unsigned long __untagged_addr_remote(struct mm_struct *mm,
>                                                    unsigned long addr)
>  {
> -       mmap_assert_locked(mm);
> -       return addr & (mm)->context.untag_mask;
> +       return addr & READ_ONCE(mm->context.untag_mask);
>  }
>
> -#define untagged_addr_remote(mm, addr) ({                              \
> +#define untagged_addr_remote_unlocked(mm, addr)        ({               =
       \
>         unsigned long __addr =3D (__force unsigned long)(addr);          =
 \
>         (__force __typeof__(addr))__untagged_addr_remote(mm, __addr);   \
>  })
>
> +#define untagged_addr_remote(mm, addr) ({                              \
> +       mmap_assert_locked(mm);                                         \
> +       untagged_addr_remote_unlocked(mm, addr);                        \
> +})
> +
>  #endif
>
>  #define valid_user_address(x) \
> diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
> index d44afbe005bb..9fa659117f38 100644
> --- a/arch/x86/kernel/process_64.c
> +++ b/arch/x86/kernel/process_64.c
> @@ -814,7 +814,7 @@ static void enable_lam_func(void *__mm)
>  static void mm_enable_lam(struct mm_struct *mm)
>  {
>         mm->context.lam_cr3_mask =3D X86_CR3_LAM_U57;
> -       mm->context.untag_mask =3D  ~GENMASK(62, 57);
> +       WRITE_ONCE(mm->context.untag_mask, ~GENMASK(62, 57));
>
>         /*
>          * Even though the process must still be single-threaded at this
> @@ -952,7 +952,7 @@ long do_arch_prctl_64(struct task_struct *task, int o=
ption, unsigned long arg2)
>  #endif
>  #ifdef CONFIG_ADDRESS_MASKING
>         case ARCH_GET_UNTAG_MASK:
> -               return put_user(task->mm->context.untag_mask,
> +               return put_user(mm_untag_mask(task->mm),
>                                 (unsigned long __user *)arg2);
>         case ARCH_ENABLE_TAGGED_ADDR:
>                 return prctl_enable_tagged_addr(task->mm, arg2);
> diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
> index eddbbb65ccc4..7e6e4c89184c 100644
> --- a/include/linux/uaccess.h
> +++ b/include/linux/uaccess.h
> @@ -34,6 +34,13 @@
>  })
>  #endif
>
> +#ifndef untagged_addr_remote_unlocked
> +#define untagged_addr_remote_unlocked(mm, addr)        ({      \
> +       (void)(mm);                                     \
> +       untagged_addr(addr);                            \
> +})
> +#endif
> +
>  #ifdef masked_user_access_begin
>   #define can_do_masked_user_access() 1
>  # ifndef masked_user_write_access_begin
>
> base-commit: 248951ddc14de84de3910f9b13f51491a8cd91df
> --
> 2.53.0-Meta
>

