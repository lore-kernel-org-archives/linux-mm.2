Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFFFCCCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 21:53:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 370B48E008A; Mon,  3 Nov 2025 16:53:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 347388E0058; Mon,  3 Nov 2025 16:53:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25CCE8E008A; Mon,  3 Nov 2025 16:53:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1274D8E0058
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:53:59 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B3A7212B486
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 21:53:58 +0000 (UTC)
X-FDA: 84070648956.04.B8F1B03
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf15.hostedemail.com (Postfix) with ESMTP id CE8D0A0006
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 21:53:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qmNvGM9q;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762206836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XIGFU2coMm46neXYWhGBTRXr3T93OdUqammYsrVLHyI=;
	b=fnp65DyE4potZpBlyDMt5j1lAlMUTFSzTWfZbUICf4RTlrVE8wnxQ2JVdX9/G/XiEwjdhA
	t5Rc4xZpskZ5Cs3dleiQbv8MSdh5snzYUUMdPf3l0J07UFtUc8yC+oSQks6eH0GIDSncQE
	2Vd/2s7pzimxAoEEoasTt1HIQBkWlrQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qmNvGM9q;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762206836; a=rsa-sha256;
	cv=none;
	b=MmY5FU5OD5Wj/SRnPlI68tk99gkEuniMPLT9DTfy+olvDSm1w37EoXNzCY0ydfJ1dzS5XO
	hJhUWn4d3sPQ0p3/tZ0isUYvGiPo6zwnJYW6IskOHY3yqkMjulnhNrhTBLdobMHmuEmPJq
	P5KSnQqiyjsHCUouCp46k3W2fXOVkCU=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4ecfafb92bcso41041cf.1
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 13:53:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762206836; x=1762811636; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XIGFU2coMm46neXYWhGBTRXr3T93OdUqammYsrVLHyI=;
        b=qmNvGM9qymAXo3qd5uatR01I/dvQQpR8bm+PPZ5Sh/4ZFE9U/OtOptYhIouyHYhere
         tSqU1BNVrH900QaXjf3A2gUHuqw+D+lF2HjtalLae7/8GeSwVmCQTa3c+JAi6ZBiZawr
         RIjk7eu/hbViw5m5Wik68eGS0kBjv36f/ocJJ5E7N/Fs/anWBoUNkvbh1nCq5/YUcqtE
         MpMR+A5IMlXzlLj7IJq2HGHk5w8nTtBxVit47XbNsK7uGUu9J5ghma7tNvK993HZDrSB
         j32DeEK/yJYPLvSUqNx3cKEZPnQdAifcdiOhnppxYL3+X3IRTpgMwylGccKZsK6kRUtb
         yCgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762206836; x=1762811636;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XIGFU2coMm46neXYWhGBTRXr3T93OdUqammYsrVLHyI=;
        b=AybJtCplWW5cUbtmoiAEfpjiyH+51peUZ7pqNhlspIpSrbY18f7F27xBN+CkZgz9c/
         D1ybf6cEvS6uvnfIrxrKVn1oYZwwm/wX4TBJiW6GdmWO1IFmuy5G7mXGySGOHje8t3xR
         3KszsDvvkVzdi5ehyfaX7F6lk/1fnkjgEUbvhgkvfNJJkC8XSM7/VzbQf6b+S2OY4fPk
         IDpUB59Ccr6O6jKsSFaDt4dC0M107KRoOe9Scs40QKBtFaQwcy3nU2rOtc0w4r8RZ1rB
         /oHS41KayvfF5/GdkUd8xaObudnULn13THQWmQ56qZmc8NGquLam+zecY8F835LWyzgh
         J5SA==
X-Forwarded-Encrypted: i=1; AJvYcCVbqJzwzzJF2cnq63lR6j7KAAxglEEY346hlOrvPLHqwqmEuiIn6TsBO9PvywyFVpPIk3DlCFnQeA==@kvack.org
X-Gm-Message-State: AOJu0YyHQHsySdCpFlwh8XexpHSWrb016mlH1ERbfKZIi1eQeMtdiAqP
	TzmunVd1/sFdiNLu0QY/gA0Eh8U4prqLEhzJIym6ZLoTNNLXd86bzHuG4ElK3Wn0Ptl4qA6Ojpw
	O5xE0XylzElOfqCVFLEe8gnEJ4A2p2+fNWpQUIn6y
X-Gm-Gg: ASbGncvNSCQfL7NGf26+c0fE8KNqIswbbwTMN+vzB87OrCmtVxIfYMgNoAjQnkL2jnl
	2ZOkk6QOd/+a7C3GZDHAwFktChPdSOhVkvLhUqFHsMhmkHZq9CM1R+bTx8/zwU/XYfngdQ+rVvi
	SPaCKNgTUfApZtzGwn95x2oDM2a4hwoKgECwVNeSXtmU0JUAG7PkzmKmNeEdlPsXKauqaV4rChK
	iS5Qvh8MkhL0KxXws4DmnCfE5sbSt+Rp1zmP8EUzMAS1fJKqLipiW/qtGI=
X-Google-Smtp-Source: AGHT+IHp8GtB2XOz9+trA/9Ael4ibkH25fumuCtOkSydeo4ww/uwru4zKzt1xOGkZZxjPuT2TBleFKb+ri/nqT6gK6Q=
X-Received: by 2002:a05:622a:13:b0:4e8:85ac:f7a7 with SMTP id
 d75a77b69052e-4ed6382d702mr533001cf.9.1762206835478; Mon, 03 Nov 2025
 13:53:55 -0800 (PST)
MIME-Version: 1.0
References: <20251103180348.3368668-1-willy@infradead.org> <20251103180348.3368668-2-willy@infradead.org>
In-Reply-To: <20251103180348.3368668-2-willy@infradead.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 3 Nov 2025 13:53:44 -0800
X-Gm-Features: AWmQ_bmu4vRH5JLi_wX7r5u1k4L_OhpPPQn23nvzssIKzhpB-qsd5oTrUuGpiMA
Message-ID: <CAJuCfpEGdMLxKqPZND32BZeYcpmRb7WQqBc2Qq_Z2Dk1LZEVhA@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: Add vma_start_write_killable()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CE8D0A0006
X-Stat-Signature: qi1zqjtt19rk4b4q6zwcjezgnaw7yfo4
X-Rspam-User: 
X-HE-Tag: 1762206836-136768
X-HE-Meta: U2FsdGVkX18c0lqeBrYRns3vcCaZnlh80Alx0EtbFUDry86N+/BJwHEPtEAuvYSEjBi++MMLvCtf0L1C2cmWTRnC6TFEXqv5nj3UL00AmKM2LdfEInXeXEjvD6FYxoNOCxOPZUg2900gRDiqstYFz61U38nFP6sIKzEv7V47RpwPxrJQnKgl9/uTsf+sICJ002RLMNvJi0EEs/O0Si0oC2ZLqvfuEnrrrC6Uync1+qkc+C35vd6cmhGkzvKEvK2kNWYd7pQ3+t5xMYvEe+AqdNNQOLmXAvBnAd9vhGsDan/ghlqvOX1+1maW+/mEwiKhOGvR5eToQOfHM2oUyiHz/2RgXi/fq+Tou1RQNto6YHHmsr0anF/1wC+94TgsjIp2Fdd1waIrObpQpQn8AEFlS/QCAU4dnhnb83AoNG86Q949FSJ2WeSgIN4D6lquBgfsHWdMy1J3U+KEtVnV/T/pQwAXrZY693f7DAjKU7sJOn8bvHa3eUFV1a7Wo6bbgHDfFSlYKK1OJXteFkOHIEVnxBUvwol0Hg2T1H89nxU7kviKpVRz9Wsp8ca+2sUsx2dos33P3kMdAjmYamSc2JQrn4dD3NO3urOuhAh8FIsPHPafow9aDsIqIrIzobAM7VlEQvW93g0LMkmxSH4drs/n14T9W8IxR/wLVMPTPbdxZVCX8o2IiUzsYXynyLwDz+n1BBnRIbRfcqzNAs6iDp3Ecpl93Vh8vGFAr2cKgHsw6tjBFJhuEeDbcljYtN4eE/cyhmh97EWaYCWHO5irc1+KITQjOQ/5WYyrVpmosjCoK3RjmYUk6ziQ7xqVsIQChon314EyZtnnciLIuTodAZCfu9jkrNs/szPpelWOsyOqSBqoIpeF6dsx2zLAVIDXfEEBtc6JH1zf+ZrniI9cwtjyxPPA8C6b8s81Un7/aFh2bl0NlnBPV32pjICywNSxhB1YyJbC2/X/tblTZOkJL4R
 YACBOOwz
 n3bqnlWQbh8liiKzQgUSfdKS1/Kb1aUd+QYwbiLAdMLi+3UqZYP48rHjpWtj6zX5Xk6m6hghgqKMgvdNhmweKwbfKh0WXFo/wNUmV1lVlk6Yc3mzmhD1SjgvMLXESpbnPVNbPMFhrSXJu7zPNB3DW/H6P8W7GLBMklC+Fc57Y4Bxvs3iWcvL8snodixkKnHdnHocR/5HRYmumn2kNsIdvfiz4N8bxrNHlJPlVa4i8suOysX+MHVZ6JNtrgRfMKaCnAOg/UlQPvJAnlkIrJ70h4IQFuwNTwabC3pREcRhMMvGNsnlVMJDwqQbTkaLR0abQv9hEHcFILrtPNx0WDsh16f9QAMuYaoBmRcDS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 3, 2025 at 10:03=E2=80=AFAM Matthew Wilcox (Oracle)
<willy@infradead.org> wrote:
>
> The vma can be held read-locked for a substantial period of time, eg if
> memory allocation needs to go into reclaim.  It's useful to be able to
> send fatal signals to threads which are waiting for the write lock.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Thanks Matthew!
With the below suggestions addressed,

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  include/linux/mmap_lock.h        | 31 +++++++++++++++++++++++++++++--
>  mm/mmap_lock.c                   | 27 ++++++++++++++++++---------
>  tools/testing/vma/vma_internal.h |  8 ++++++++
>  3 files changed, 55 insertions(+), 11 deletions(-)
>
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 2c9fffa58714..b198d6443355 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -195,7 +195,8 @@ static bool __is_vma_write_locked(struct vm_area_stru=
ct *vma, unsigned int *mm_l
>         return (vma->vm_lock_seq =3D=3D *mm_lock_seq);
>  }
>
> -void __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_=
seq);
> +int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_s=
eq,
> +               int state);
>
>  /*
>   * Begin writing to a VMA.
> @@ -209,7 +210,30 @@ static inline void vma_start_write(struct vm_area_st=
ruct *vma)
>         if (__is_vma_write_locked(vma, &mm_lock_seq))
>                 return;
>
> -       __vma_start_write(vma, mm_lock_seq);
> +       __vma_start_write(vma, mm_lock_seq, TASK_UNINTERRUPTIBLE);
> +}
> +
> +/**
> + * vma_start_write_killable - Begin writing to a VMA.
> + * @vma: The VMA we are going to modify.
> + *
> + * Exclude concurrent readers under the per-VMA lock until the currently
> + * write-locked mmap_lock is dropped or downgraded.
> + *
> + * Context: May sleep while waiting for readers to drop the vma read loc=
k.
> + * Caller must already hold the mmap_lock for write.
> + *
> + * Return: 0 for a successful acquisition.  -EINTR if a fatal signal was
> + * received.
> + */
> +static inline
> +int __must_check vma_start_write_killable(struct vm_area_struct *vma)
> +{
> +       unsigned int mm_lock_seq;
> +
> +       if (__is_vma_write_locked(vma, &mm_lock_seq))
> +               return 0;
> +       return __vma_start_write(vma, mm_lock_seq, TASK_KILLABLE);
>  }
>
>  static inline void vma_assert_write_locked(struct vm_area_struct *vma)
> @@ -286,6 +310,9 @@ static inline struct vm_area_struct *vma_start_read(s=
truct mm_struct *mm,
>                 { return NULL; }
>  static inline void vma_end_read(struct vm_area_struct *vma) {}
>  static inline void vma_start_write(struct vm_area_struct *vma) {}
> +static inline
> +int __must_check vma_start_write_killable(struct vm_area_struct *vma)
> +{ return 0; }

nit: a tab for consistency with other stubs please.

>  static inline void vma_assert_write_locked(struct vm_area_struct *vma)
>                 { mmap_assert_write_locked(vma->vm_mm); }
>  static inline void vma_assert_attached(struct vm_area_struct *vma) {}
> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> index 0a0db5849b8e..dbaa6376a870 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -45,8 +45,10 @@ EXPORT_SYMBOL(__mmap_lock_do_trace_released);
>
>  #ifdef CONFIG_MMU
>  #ifdef CONFIG_PER_VMA_LOCK

Let's add a comment to list possible return values:
0 - the vma is not attached;
1 - the vma is attached with no readers;
negative - an error code;

> -static inline bool __vma_enter_locked(struct vm_area_struct *vma, bool d=
etaching)
> +static inline int __vma_enter_locked(struct vm_area_struct *vma,
> +               bool detaching, int state)
>  {
> +       int err;
>         unsigned int tgt_refcnt =3D VMA_LOCK_OFFSET;
>
>         /* Additional refcnt if the vma is attached. */
> @@ -58,15 +60,17 @@ static inline bool __vma_enter_locked(struct vm_area_=
struct *vma, bool detaching
>          * vm_refcnt. mmap_write_lock prevents racing with vma_mark_attac=
hed().
>          */
>         if (!refcount_add_not_zero(VMA_LOCK_OFFSET, &vma->vm_refcnt))
> -               return false;
> +               return 0;
>
>         rwsem_acquire(&vma->vmlock_dep_map, 0, 0, _RET_IP_);
> -       rcuwait_wait_event(&vma->vm_mm->vma_writer_wait,
> +       err =3D rcuwait_wait_event(&vma->vm_mm->vma_writer_wait,
>                    refcount_read(&vma->vm_refcnt) =3D=3D tgt_refcnt,
> -                  TASK_UNINTERRUPTIBLE);
> +                  state);
> +       if (err)
> +               return err;
>         lock_acquired(&vma->vmlock_dep_map, _RET_IP_);
>
> -       return true;
> +       return 1;
>  }
>
>  static inline void __vma_exit_locked(struct vm_area_struct *vma, bool *d=
etached)
> @@ -75,16 +79,19 @@ static inline void __vma_exit_locked(struct vm_area_s=
truct *vma, bool *detached)
>         rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
>  }
>
> -void __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_=
seq)
> +int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_s=
eq,
> +               int state)
>  {
> -       bool locked;
> +       int locked;
>
>         /*
>          * __vma_enter_locked() returns false immediately if the vma is n=
ot
>          * attached, otherwise it waits until refcnt is indicating that v=
ma
>          * is attached with no readers.
>          */
> -       locked =3D __vma_enter_locked(vma, false);
> +       locked =3D __vma_enter_locked(vma, false, state);
> +       if (locked < 0)
> +               return locked;
>
>         /*
>          * We should use WRITE_ONCE() here because we can have concurrent=
 reads
> @@ -100,6 +107,8 @@ void __vma_start_write(struct vm_area_struct *vma, un=
signed int mm_lock_seq)
>                 __vma_exit_locked(vma, &detached);
>                 WARN_ON_ONCE(detached); /* vma should remain attached */
>         }
> +
> +       return 0;
>  }
>  EXPORT_SYMBOL_GPL(__vma_start_write);
>
> @@ -118,7 +127,7 @@ void vma_mark_detached(struct vm_area_struct *vma)
>          */
>         if (unlikely(!refcount_dec_and_test(&vma->vm_refcnt))) {
>                 /* Wait until vma is detached with no readers. */
> -               if (__vma_enter_locked(vma, true)) {
> +               if (__vma_enter_locked(vma, true, TASK_UNINTERRUPTIBLE)) =
{
>                         bool detached;
>
>                         __vma_exit_locked(vma, &detached);
> diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_int=
ernal.h
> index dc976a285ad2..917062cfbc69 100644
> --- a/tools/testing/vma/vma_internal.h
> +++ b/tools/testing/vma/vma_internal.h
> @@ -844,6 +844,14 @@ static inline void vma_start_write(struct vm_area_st=
ruct *vma)
>         vma->vm_lock_seq++;
>  }
>
> +static inline __must_check
> +int vma_start_write_killable(struct vm_area_struct *vma)
> +{
> +       /* Used to indicate to tests that a write operation has begun. */
> +       vma->vm_lock_seq++;
> +       return 0;
> +}
> +
>  static inline void vma_adjust_trans_huge(struct vm_area_struct *vma,
>                                          unsigned long start,
>                                          unsigned long end,
> --
> 2.47.2
>

