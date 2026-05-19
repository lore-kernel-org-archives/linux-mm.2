Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E7F1CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 05:36:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A496F6B0005; Tue, 19 May 2026 01:36:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F8B06B0088; Tue, 19 May 2026 01:36:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E7C46B008C; Tue, 19 May 2026 01:36:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E4196B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 01:36:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 09A938B989
	for <linux-mm@kvack.org>; Tue, 19 May 2026 05:36:38 +0000 (UTC)
X-FDA: 84783059676.30.B2041CB
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2A8E740006
	for <linux-mm@kvack.org>; Tue, 19 May 2026 05:36:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=q6HB+15s;
	spf=pass (imf27.hostedemail.com: domain of devnexen@gmail.com designates 209.85.160.46 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779168996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A4ETb00fdVBabWuvw/CSYnIRHgghcWb28Lht2KTiLdM=;
	b=pLrcWOh9XqU466cAEx81F6INAWGrxK/ceouhKux41vbNhVYcM5/kA7kBKnpESfRKrok3Sz
	5oOWDAdiRB3/GvxPdkthavEIXV9hs2BOKT7LAHjide61AcEJkZnXvT9dytg2aCI8gq/M5d
	86PIiO0GTe9hhZGw57CQDk7VaoWyOQc=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=q6HB+15s;
	spf=pass (imf27.hostedemail.com: domain of devnexen@gmail.com designates 209.85.160.46 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779168996; a=rsa-sha256;
	cv=pass;
	b=5NDtRQf/94x6c9DIjQjdOOIXbsFgvKuXHrhbH0xmw75lAOp3cyJiUhFF4LnbdVcZ37EJud
	bIpcTee6fOR0bE1uTXruhCQApsqc4pI3gQt7YSuVM1BFPUfSPbFD+Ed3Ef9nKrDp+bYb2W
	J1zMjgvjCvg1Ckp735w4dCepjxzgZyk=
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-40427db1300so2847876fac.0
        for <linux-mm@kvack.org>; Mon, 18 May 2026 22:36:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779168995; cv=none;
        d=google.com; s=arc-20240605;
        b=EJ6s9R2nCcSPuGaVHAQrgRTvKy9wAhbBkFKvkbtiu/Izq2FQle3gbB6TwwvcFohkfL
         4rxl2QbQ9n3k3e4/Gx+wpK7Q+S23VebsDJaGRLleRhhwO2dbQipj8RCwS6SOgjfpDKy4
         A+pqZWuVmIoJRdc0CQ2UcOpKSFVRCAE/o5i8jaLLhXXt5/OCWrGqlDGLY4K+6c6hgYG9
         bl/ho7BXPDSozHptpp3qxS2A0/wbVbR2Y4Rij8r8uvi3C+4YsCbALIDkhH4FWfJCpWXp
         piDB5QChfW72nqU49MB7FJnT0xnmCbbYzBosf/7pgwL8CDmc4phL4j8zf/vICTopxOvk
         sxtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=A4ETb00fdVBabWuvw/CSYnIRHgghcWb28Lht2KTiLdM=;
        fh=tr6RwzSggvip/EZjkEbjgYl0zMrvAAqeHxHLUV3JM7E=;
        b=e5Hs027bQ5X49iwLXNOnsH1qkEcA5CGZJUvAUZ+RcgLKxoMLJ/9o2sIFh7pNdAJd61
         1l3YpDcXiMSKtV6ruYMq5/X05bUZZJe4nlFesbJg7YPmBdMHfdBQr76If6/6uFp96qEa
         0V23BfqH+XSU6h587PHaPQtjtYqW4apcllPDdk+XsFzQ4QD5TFP9L63/9T5wmNguhQ4y
         GoZm/B6FNKpauuqE3Xf5LjvelayHFd3edQGpWfqLP1P1U/e9LatM98QaGqWZvoVOVg/K
         vLyxdoYAvbQjQBMYFFqrCKy1cXPkypSTldH0k49uSMvg+q18FpsFSeP0gLVaVqLLY745
         Ovbw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779168995; x=1779773795; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=A4ETb00fdVBabWuvw/CSYnIRHgghcWb28Lht2KTiLdM=;
        b=q6HB+15sk4YnJiuK8B6rPBIEZmh8wOv2hMpu1ySXjNf1K1n5tJV6jwEiWUY2EumkOK
         ELPSiQ/rChWzxPsjlKrtyLr9lUXaIVD4LGvxKeFgXKz12jlm53/5+5AcwcEPUhZn193G
         zdDvktwrrZYVJv/b98PrftITTn4UZeKLieY6uXTCpciyIXQNkn6CpdXMFvJdXw1Tl75i
         IfH70pQwQp2Jnofut/ebpNZZWdGwE+/0at4XEOaL+5YKyRILql9ErUok1lZ4S6XzyoA8
         taC7TWTIohIfqq4rd5ugZtTlXacLiLv+t+jwFsZiXaYVIEjwQPnLK0yNZg223un/m/Qv
         VxMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779168995; x=1779773795;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A4ETb00fdVBabWuvw/CSYnIRHgghcWb28Lht2KTiLdM=;
        b=i7rxlH9nXiSLMj1c1BQGuaa1vJ3zuzHz+FPvm3ArjstN4jL+FeBUvEEADP/i7EoWsd
         EJSuzZAxCU5wT8nkZe47TtO0SJjUABMV8OLVWyEY6NbgZBrq4jvR/zf1dJ3R9P5DtmYw
         GMrzK1nhsY+b8uIu/+AtgwuJ2/lyQU9aUtNH2TOcoJoZ/d8EOT4y/h2v5z/w0ABbTPUM
         pbU/YTthifpuY6jVXaAVscIQezwQr57XFjUqxRjNnfcdUnhZ1OzmpRBYHUIakwnD2HGa
         5NGRIxIoibQJCez2EiMCgchGJ+lLoF/6jxyVThXoy7UH4Irj/3sur4+CVqoOgR4Agqjf
         a1TQ==
X-Forwarded-Encrypted: i=1; AFNElJ/jjHCguc3AH4AFI9Pit5gXZssrIVr2TkqA5FJh5G1pzTTJ5KXtPIP7hhHp6Ohi/yKyUhDjbcjVyg==@kvack.org
X-Gm-Message-State: AOJu0YxgefNwxl131m8f4Yjqpw2nUPA6XZLnbV5nTyG4XD9YwqZbA1pC
	rYrZuiEZnwCR4p1PtBs6dTLBe7CEQ14ZBT/UW31N+dRzdbcoGkJkNF5z4uxapjAw8nlWJGvIzkN
	BIK7EgGC6EpaRkKcwj3eVTDUHaW5YHmQ=
X-Gm-Gg: Acq92OG1qe3piG1TxVyl+xzmRuevic9QYgWXVjJj8ng8KCVQgdSt6hkQtO6cb55aqn1
	JuN/l8Gdb8dv/iWuii/Gua1NM0tt4ygHX97QemIgm+7Ha62tIsjol19ATxvS0Z/djWSd5tXCrqP
	MR7aGxX+j7NxBLfFxa+idzEbsn2wMaE3PjFtJmXhFN7zubXoDP/3Daoig+Ax4fL78L1aElelFjg
	s5oZM1ZUROX+gFt7KC7FkS2e+VLT4LdKj1pjBgzWGFtwM5NRQfzFOa6qAFsmHXEw+M7GkPf3I24
	4mDI/laSy9pvVHWoJn+jkTrfCvGgQJHkJzrzRg==
X-Received: by 2002:a05:6870:9723:b0:42c:f89:7555 with SMTP id
 586e51a60fabf-43a2d9da002mr12065617fac.11.1779168994937; Mon, 18 May 2026
 22:36:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260519052516.3315196-1-rppt@kernel.org>
In-Reply-To: <20260519052516.3315196-1-rppt@kernel.org>
From: David CARLIER <devnexen@gmail.com>
Date: Tue, 19 May 2026 06:36:23 +0100
X-Gm-Features: AVHnY4KUNU-YDdm2BnpwadztDEU9chtk-L1HqO4XvKcFp6sc12h6Uf70AGP_BLM
Message-ID: <CA+XhMqxPFy0GotRrggfo+WbrCe4qyy5CFUZJM1fVnY+iEucsHw@mail.gmail.com>
Subject: Re: [PATCH RESEND] userfaultfd: snapshot VMA state across UFFDIO_COPY retry
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Heechan Kang <gganji11@naver.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Michael Bommarito <michael.bommarito@gmail.com>, 
	Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 2A8E740006
X-Rspamd-Server: rspam06
X-Stat-Signature: artu8a7pnghd6zbuqomrfwpwr66nh7wp
X-HE-Tag: 1779168995-620124
X-HE-Meta: U2FsdGVkX190KFTiOl8/Fyg8v+1wrsG2MLxcdtQN9TW6h1G5qEeZu3mu77ubvp1Z5DbLFMHSbu9eNKmGngg0CNpurlMr6TYcddjSF2zcidyQoBAE2ISJer+bFitmye/G8x+4slkDSXPswtf361nPFIGrLhFvJDUkF7+t7+4GKtgcibdKSLt2AORXgpnqyIB3NDblUzCtLPXJ97H/pehIS5CgU6Sypelsp+SD/f5TTUox92xJQe3x7t7iwlbUxKGsDAqlxu17zaYmXIHwqHu3rV22sNXypBFZLn2946i7dZ3xE7pYYT6z67JtHu7Y74axkjIuiGH0U7rIzdrtPiZqSUISJbM4JpKHPEBqh14+JqNfEmv3PYwBRwX5XAbS4iPF1soMkCECxrQWjm4nhY9AzT0Raqmgg4p1lWlvSO3XKAy6JAlLyA+iF8Lq/FRzLDzsQ1V7lAZHEtnz92LJ1MJNtgwCIOg8y7LZYjxlluh3s7kVBqzbmmHpnseFhGHwNEmwdpehUICdPOi8z1RmliQjKaWu9+g1kPfhHD37ieHEMXLfR5DgLye5oK7r9bYUZHtXcgP/rkAkSRX8LKedUEcSrAOB2NfUHJYeuOTIEDXZbAXu71sPjP+TwyH4Wsmw3IJ5SgEpZeJoV6fNX/dXq25aqbfus6I7mzSbcZY15BmK7HpSjiXmhNWtCFcvKVMcAIcpKMKbEo1ZcKWg85NuRlQvwsULsCppRb9yWVNNPi51zGiOZfjjZsaCfFLys1dU1km5K7GA67L8VZrnDocmKKaA6YSMXDu53TdLNVCJhZzHKBKcHzFrPp1ekV/GmBagyWlK7GXXAA2sNZqHQi+eKCJ68jjBGIZzmMQmhQWIhaGUkAfJCT8uEsSo5Cy7wI3MOCwYQOAKcv/4gJOTyOXYGoLETufW/SvS76fhyspYk7DuG8YSiwR+7gC3u8RVYHcRoLdb7E9KGjX1nGFXaQIrUeC
 qckPHd9l
 e1HLkC/WbfP7m/XX5fMuh4aQa+VG3+gCo6OFXhqOuIUzLlx8GepWkLwR2kE2GXI/wSNcGnpSOZFKD2ya59fRifFDzPSU+4HSacWhhk2vX2EGF4yb05jQRhRAgCJzaWtogvgSKoJYdd3zGuIpaDw+hUINbFw3LsYiOczRG1HzPkbezI7xyJUN1PUtYzQ5KGXJr8iy5wyBUfplEcGigMGIgtKmMJgoG3dlqT0LkjG4WullJA2I4RlmxcyIWzZdtmNyJ64NFqB+Rn4a5b2SNxnYIf8GThUWVwx0CGS1k9eY0Cxh0j57rpD3sRTvjacnfKcguRHyMCSJbYu1jtIpHnlkzmq1bsUYw1JoJnXSjB+S7dMT6xPId0Toz2cIFCWPtz/namSsEi2yqQpbaBL6i2zKnwt1FEg/78j7IIKNaD9ll0g5/H4k7SIwQ1U05YuQCcvFR3ZW2zuKnAOLfyXhW3p2AkjeAzixvXBeiVEwxtbotgOUfAjKN0HAh2Wjx0YO2Mm7/gFLyES1YYbjFxqeAnj72DA1lYPW/I47Xr7BQfmEL0YSlkSbD03J5rhFcZK/NqFtSGiX9Yb7bpfo21MlYGqPGYnBypw4Rh00SfPeEpSDU5DmwFGw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

On Tue, 19 May 2026 at 06:25, Mike Rapoport <rppt@kernel.org> wrote:
>
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> mfill_copy_folio_retry() drops the VMA lock for copy_from_user() and
> reacquires it afterwards. The destination VMA can be replaced during that
> window.
>
> The existing check compares vma_uffd_ops() before and after the retry, but
> if a shmem VMA with MAP_SHARED is replaced with a shmem VMA with
> MAP_PRIVATE (or vice versa) the replacement goes undetected.
>
> The change from MAP_PRIVATE to MAP_SHARED will treat the folio allocated
> with shmem_alloc_folio() as anonymous and this will cause BUG() when
> mfill_atomic_install_pte() will try to folio_add_new_anon_rmap().
>
> The change from MAP_SHARED to MAP_PRIVATE allows injection of folios into
> the page cache of the original VMA.
>
> Introduce helpers for more comprehensive comparison of VMA state:
> - vma_snapshot_get() to save the relevant VMA state into a struct
>   vma_snapshot (original uffd_ops, actual uffd_ops, relevant VMA flags,
>   vm_file and pgoff) before dropping the lock
> - vma_snapshot_changed() to compare the saved state with the state of the
>   VMA acquired after retaking the locks
> - vma_snapshot_put() to release vm_file pinning.
>
> Use DEFINE_FREE() cleanup to wrap vma_snapshot_put() to avoid complicating
> error handling paths in mfill_copy_folio_retry().
>
> Add vma_uffd_copy_ops() to avoid code duplication when original ops of
> shmem VMA with MAP_PRIVATE are replaced with anon_uffd_ops.
>
> Fixes: 292411fda25b ("mm/userfaultfd: detect VMA type change after copy retry in mfill_copy_folio_retry()")
> Fixes: 6ab703034f14 ("userfaultfd: mfill_atomic(): remove retry logic")
> Tested-by: Heechan Kang <gganji11@naver.com>
> Suggested-by: Peter Xu <peterx@redhat.com>
> Co-developed-by: David Carlier <devnexen@gmail.com>
> Signed-off-by: David Carlier <devnexen@gmail.com>
> Co-developed-by: Michael Bommarito <michael.bommarito@gmail.com>
> Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  mm/userfaultfd.c | 99 ++++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 79 insertions(+), 20 deletions(-)
>
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 180bad42fc79..b70b84776a79 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -14,6 +14,8 @@
>  #include <linux/userfaultfd_k.h>
>  #include <linux/mmu_notifier.h>
>  #include <linux/hugetlb.h>
> +#include <linux/file.h>
> +#include <linux/cleanup.h>
>  #include <asm/tlbflush.h>
>  #include <asm/tlb.h>
>  #include "internal.h"
> @@ -69,6 +71,24 @@ static const struct vm_uffd_ops *vma_uffd_ops(struct vm_area_struct *vma)
>         return vma->vm_ops ? vma->vm_ops->uffd_ops : NULL;
>  }
>
> +static const struct vm_uffd_ops *vma_uffd_copy_ops(struct vm_area_struct *vma)


My only 2 cent, I would name it vma_uffd_effective_copy_ops() instead or
a comment to highlight it is about "UFFDIO_COPY into a MAP_PRIVATE file-backed"


> +{
> +       const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
> +
> +       if (!ops)
> +               return NULL;
> +
> +       /*
> +        * UFFDIO_COPY fills MAP_PRIVATE file-backed mappings as anonymous
> +        * memory. This is an effective ops override, so retry validation must
> +        * compare the override result, not just vma->vm_ops->uffd_ops.
> +        */
> +       if (!(vma->vm_flags & VM_SHARED))
> +               return &anon_uffd_ops;
> +
> +       return ops;
> +}
> +
>  static __always_inline
>  bool validate_dst_vma(struct vm_area_struct *dst_vma, unsigned long dst_end)
>  {
> @@ -443,14 +463,70 @@ static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
>         return ret;
>  }
>
> +#define VMA_SNAPSHOT_FLAGS append_vma_flags(__VMA_UFFD_FLAGS, VMA_SHARED_BIT)
> +
> +struct vma_snapshot {
> +       const struct vm_uffd_ops *copy_ops;
> +       const struct vm_uffd_ops *ops;
> +       struct file *file;
> +       vma_flags_t flags;
> +       pgoff_t pgoff;
> +};
> +
> +static void vma_snapshot_get(struct vma_snapshot *s, struct vm_area_struct *vma)
> +{
> +       s->flags = vma_flags_and_mask(&vma->flags, VMA_SNAPSHOT_FLAGS);
> +       s->copy_ops = vma_uffd_copy_ops(vma);
> +       s->ops = vma_uffd_ops(vma);
> +       s->pgoff = vma->vm_pgoff;
> +
> +       if (vma->vm_file)
> +               s->file = get_file(vma->vm_file);
> +}
> +
> +static bool vma_snapshot_changed(struct vma_snapshot *s,
> +                                struct vm_area_struct *vma)
> +{
> +       vma_flags_t flags = vma_flags_and_mask(&vma->flags, VMA_SNAPSHOT_FLAGS);
> +
> +       if (!vma_flags_same_pair(&s->flags, &flags))
> +               return true;
> +
> +       /* VMA type or effective uffd_ops changed while the lock was dropped */
> +       if (s->ops != vma_uffd_ops(vma) || s->copy_ops != vma_uffd_copy_ops(vma))
> +               return true;
> +
> +       /* VMA was anonymous before; changed only if it no longer is */
> +       if (!s->file)
> +               return !vma_is_anonymous(vma);
> +
> +       /* VMA was file backed, but inode or offset has changed */
> +       if (!vma->vm_file || vma->vm_file->f_inode != s->file->f_inode ||
> +           vma->vm_pgoff != s->pgoff)
> +               return true;
> +
> +       return false;
> +}
> +
> +static void vma_snapshot_put(struct vma_snapshot *s)
> +{
> +       if (s->file)
> +               fput(s->file);
> +}
> +
> +DEFINE_FREE(snapshot_put, struct vma_snapshot *, if (_T) vma_snapshot_put(_T));
> +
>  static int mfill_copy_folio_retry(struct mfill_state *state,
>                                   struct folio *folio)
>  {
> -       const struct vm_uffd_ops *orig_ops = vma_uffd_ops(state->vma);
> +       struct vma_snapshot s = { 0 };
> +       struct vma_snapshot *p __free(snapshot_put) = &s;
>         unsigned long src_addr = state->src_addr;
>         void *kaddr;
>         int err;
>
> +       vma_snapshot_get(&s, state->vma);
> +
>         /* retry copying with mm_lock dropped */
>         mfill_put_vma(state);
>
> @@ -467,12 +543,7 @@ static int mfill_copy_folio_retry(struct mfill_state *state,
>         if (err)
>                 return err;
>
> -       /*
> -        * The VMA type may have changed while the lock was dropped
> -        * (e.g. replaced with a hugetlb mapping), making the caller's
> -        * ops pointer stale.
> -        */
> -       if (vma_uffd_ops(state->vma) != orig_ops)
> +       if (vma_snapshot_changed(&s, state->vma))
>                 return -EAGAIN;
>
>         err = mfill_establish_pmd(state);
> @@ -545,19 +616,7 @@ static int __mfill_atomic_pte(struct mfill_state *state,
>
>  static int mfill_atomic_pte_copy(struct mfill_state *state)
>  {
> -       const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
> -
> -       /*
> -        * The normal page fault path for a MAP_PRIVATE mapping in a
> -        * file-backed VMA will invoke the fault, fill the hole in the file and
> -        * COW it right away. The result generates plain anonymous memory.
> -        * So when we are asked to fill a hole in a MAP_PRIVATE mapping, we'll
> -        * generate anonymous memory directly without actually filling the
> -        * hole. For the MAP_PRIVATE case the robustness check only happens in
> -        * the pagetable (to verify it's still none) and not in the page cache.
> -        */
> -       if (!(state->vma->vm_flags & VM_SHARED))
> -               ops = &anon_uffd_ops;
> +       const struct vm_uffd_ops *ops = vma_uffd_copy_ops(state->vma);
>
>         return __mfill_atomic_pte(state, ops);
>  }
>
> base-commit: 444fc9435e57157fcf30fc99aee44997f3458641
> --
> 2.53.0
>

Cheers.

