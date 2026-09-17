Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ABA9C982E1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 22:08:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77EC46B008A; Thu, 17 Sep 2026 18:08:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 709116B008C; Thu, 17 Sep 2026 18:08:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A9826B0092; Thu, 17 Sep 2026 18:08:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F1196B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 18:08:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 634B51C28BC
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 22:08:40 +0000 (UTC)
X-FDA: 85224644400.09.4676188
Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id 68AEE1C0003
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 22:08:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MPwPfcJe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789682918;
	b=dcc6+l7Gyhz217DO0D6rsUKce0k/HM7gDAIQrakPPpCY+gYpkZTwhzjqs4Dl0bHEJ28eRk
	CcBxrgjIhDkuzhwyFUm/+cO+/MpBye06sYFaiSz4jXWU+wklN9NSxifUhAuybnw96OlU0O
	E8WUXzZKMfXA8L65jtZP/8dsvdyUWaQ=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MPwPfcJe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789682918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2UAipQLiMZFJPFAN47iCUjg7J+/3vsroXmj0OXmT6U0=;
	b=XEQvKsz68XuomtObJEDRUTpIRfvA65HRsIwFNiA8IVDn1/iU3zFxVU92u81X2Qz4vqjgJm
	M2p1iAe+5Gd6EYajm1sDZCevGmpC5wiN1id48ALPdp1OmOUfiOMpROo2zLzTxM/SbEfnW2
	MO0h9DjEm2ZIKlDdZ1iHIkn1XiH7dxE=
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-396ccdaea76so35011a91.0
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 15:08:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789682917; cv=none;
        d=google.com; s=arc-20260327;
        b=aLQOnHjSzvr3bNQ/97JC2q/n63YTYBluWQUYtUSqIyuJjULsPK5h2n7L2ub/ANL5Or
         Qs5GoMjhb192XBBsP45CO5pp3c4dBVWDjj8q5DYB1pFLliBiiR3YRwA0elM84mqaZKq3
         lOtxxEWoQCRVFSPrVBWeoXod4lEoijKbOSrU0TXG11JD1dFPzIZaKxT2wdtT3UyoWMnQ
         8G/bEtjuA2Kk+AQWr0cwunxw3azdALpAjU7fBIRKUahHON0UbCcNWeKNDPZsb+fxsVHR
         Xsg3FxIA5hgOAdgVOTFneXFQZNByE7V+sLa8cZTfg5XnmeindNchBtd3B4QPQ8YWl+gr
         hF2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2UAipQLiMZFJPFAN47iCUjg7J+/3vsroXmj0OXmT6U0=;
        fh=JzjN8+8ANKWT4WMJDnyT1SeDJvQSjXg1c/HP2hLU7dY=;
        b=LNx1/m9/NuTY8cg7eFaJ3QFLFaYhUp617oixi2zVFOlc/5cphsOIfeQo5fCMSEYgde
         1LEtqUVGQjhq6jN+aWqMBGLySl/xz72x7aW3g/nSacnXfc0jbMkfRTxEivXWpwN8WevB
         xFObpw+RVUxgMRSNMiXMl9x235iJRTmQiW6wi8JPrtXlFr2+kktUCGQG319fzIg6ezqI
         KekvBZiN6nezi/5jSDePephao3BPEugmlQ6vq4rQBCS60p2Nc80PKWEg5WqiTYnzN0dZ
         9UvkI5UQd3Q7dzNt4cNfSoorljBwQUnf3Y+P7J29omTUgBP8LZ8N0jhdQ0inqz4z+8Th
         f9kg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789682917; x=1790287717; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2UAipQLiMZFJPFAN47iCUjg7J+/3vsroXmj0OXmT6U0=;
        b=MPwPfcJer07R/9z9Ph29EGvOXQLENkT65PIN2M2JPxI38qrNIPx3/YfqK9j0TqBO3I
         1aabOpFnLWZs6f6ITtZ+Daz4ICjWk9rlcC5MzbJ3+gY0uNzZ52dLIU17MjHjbdoNdoiF
         RWkMWKwU8VJvq1ly+KbP7ZGWmlB6l+fWKw3cim9bUFTYIn8zVs87ck70lPWt3lBAU1LG
         eUOriaxwTC7sMqIfoWWAUuSNwZ6ANIsQxOXOHRbKnEDbbv0PnH+Ek1AJ8623oW7gRzTY
         yCjYpCOKSKkJ3nojoXNBzZrNvRHOeVxEAubNeTEYs3um6uP3oaBLwd1pA2s/7SIpGlZT
         zv+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789682917; x=1790287717;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2UAipQLiMZFJPFAN47iCUjg7J+/3vsroXmj0OXmT6U0=;
        b=aoRDfJKVwIE9UaYRg5Oi7OYACJZa4Upxz4/SP5xp7pr57mEACRckAPllqu17v5qZI8
         g1d5/BE1G1F3tTgiNOEcs+j8M2AwpxAIt7Gb2refhaP8Qjv6ANB7Rt+Pame05f0YGs0q
         YLzv+cRObgpS9i5Qh0rdsGvtt7Bz4CYrlIRxlVCGxU1iewhQvxGoZzCmzrqBAsjSm50d
         PVxHU9u0gdVTsQJbkdpqkt5XT+ialcKIEWDAwPhw4ksMvzcv3At6nmSuhoLPDrZMi8zl
         F6IA1O7juJw8Qz2SMkrKWht7rLjVDuTmBUqKfklkzOnOimALdUydFjMKlHtJmphLDDVY
         NeMg==
X-Forwarded-Encrypted: i=1; AKwUvBzVGzuO2M08g/D/UCjyDVncB2B0LiCR3UINWygpgV6xoPAX46kmJBeoSSoNCPMSEYmDWu4oLqspig==@kvack.org
X-Gm-Message-State: AFuF++m0fsfnOQ3Cfd1ED9AlYOzcyWkDMx9W518f+5PIqhxaKOYmcY/u
	ddkvqE0RZ2+Ez1V+zC8c0yyKwU1c+kztKqtOmrxVIA45tuvQhnY9iUJc8JIm8SdLt7gU686N0gN
	gIdo0cTKM7K068PdPMHPoY1xuT/8AufQ=
X-Gm-Gg: AYBFou10ulGn358VLLX+pz4yPyBZnv3dtNNYV/WxfvBs/f6FKh5P6KIRyWP4drRgkym
	5eDJ70CoDcnP3xmkOjXVsC2WD+aQKFMUpHEcmisjfCXblWisJhcQbouGy4tvHBPDry4dXH6XLWv
	G2yPGbR8IDPYHvjrfsYH16VWtXdCVO1O0Vl2ZRum4Eh+AK4/KiZQiSwud/Qz6s3/FCYbeYMaz/0
	RjDVi2tIHvqQxP6UoqCEqavGdglMr6cG+p64nYaAoxG4py/1MHPl1unVdRL7AcS12W3nauZeNta
	OQDWS+/KZj+qGS0n9M8SOJrZw9IJ0SwZ5GcVUmLJ3YX8r5V6ZGWnCaHxQyjfVXVMhvPNPqx0jm9
	f30PFvaGvXfHG3z5nx8MU1whS2dy+YaYB4qnLTA3ycRr9oG2v95dh
X-Received: by 2002:a17:90b:574b:b0:39e:3221:aff5 with SMTP id
 98e67ed59e1d1-39e5551f5d1mr433476a91.9.1789682917122; Thu, 17 Sep 2026
 15:08:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260915080255.48929-1-tasos.papagiannnis@gmail.com> <20260915080255.48929-2-tasos.papagiannnis@gmail.com>
In-Reply-To: <20260915080255.48929-2-tasos.papagiannnis@gmail.com>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Thu, 17 Sep 2026 15:08:22 -0700
X-Gm-Features: AcwNN1Xx3soFgybIiTwKKrBQJfTZVl5aXHZvWrQvKnskNl68sL311oeUiJ_wUSM
Message-ID: <CAEf4BzaH=PJh7QUhh7szGL+gCieYLOSbhriFWaZG92xFWDeGig@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 1/5] mm: Add copy_remote_mm_str()
To: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
Cc: bpf@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org, 
	akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org, 
	brauner@kernel.org, daniel@iogearbox.net, eddyz87@gmail.com, 
	kpsingh@kernel.org, ljs@kernel.org, matt@bobrowski.net, memxor@gmail.com, 
	song@kernel.org, sun.jian.kdev@gmail.com, utilityemal77@gmail.com, 
	viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 68AEE1C0003
X-Stat-Signature: qajjag65wab4kfp3qe9tbrticfo3s9bq
X-HE-Tag: 1789682918-802328
X-HE-Meta: U2FsdGVkX19+GYRltNnC7+Ka5ESqznuJEEp+YFGDUT5DLZ4LAXH0xZsURTuws3oR7YjYadrokaYnSABOybusOZLYHtvFMUWLkZ59uWeh4ZzDB9IijSkx1gyhyFqbWg7DbfS+8uElw0eW6NJ21Tps7UcjbDCe2IPz0Pol5byeK9OctqiQqumS3fSRX7eDMgRe9U6kLBxHMbz2ADV3PPB1rIcUTQk7Hc4SH/wvm0EHJsBoimvQHBELeUYbFGB/3sACOqyiHrFzRQ2EV7iZX5j7JH49ro3xyit9gnlG9Y9Z6ZjQaspZMriGeLjWVJxAoPhvL42gKUZkvsQhyMj7Atkvvhpt7VKePP4S0iWCtZ7t5TlCnYfiAqff2HepnJNhYXNHz1Or2cELBqT2QzIREO9QfZak36HWJo5bvWfPvQef+CLg+7zDlqQHrDAL5BZ3mQXsS2CwGKf1sdcekB+U8eGuvS2zo0zMMnUgz3212SM+Zo89ihA4avd2HXt3DUTP1Hn45C1w/nltHNcWMb5bfSPYPOuPFoEcCk8vs4lmP1TF1gQ/OWCvZkXBEzp8hCIVRKAbw1kfJuyN5OOIy/34Tc908vn28GyfZtcFq8ZRfSFpRuyVF7IKMFCtC4ZMuRTH28Z0rkGMXEj2okkXdKcJBos44vIqHgPZP/GJ6Y/bJsrzYlJyiJdlY8Es2EqF/S/+7chGdis9qF9UP4NzHLLBNpV4gNeRWAc2ba5QAGCtaxjbfAW/ylULWDA8lnfM/eQPkpUFb1NTOtrjVZbFHa1XotKgkdcPakJvKiVMldetnA2FxbckBDSr96lGyoh5AAe/oFQBId5R62Q0ythEUu4td1/HjdJKjFNpf3a3JmvSMVVUL/YmSgxTKFFNup/rB3oWg/+uBGtVTo19MgYTJuOKgFHw+8Y0e92E5F9ePFh+D8ud/Ty3vo0XMJrMN/up2qKzw0IeHKl716IYMHba6wAfCJ2
 AJ5k3nnd
 FTjner3bxchr8ns+ynm/yKqUyJxQPRy2GEBaNEAgRncSYCYw1lX8KrZt7q3q2zS+hjFe3XFSC/l1ltpEBs2KNv/wkMQ8s9iByQCnp/NoOoGqejDf0CecDYKUC7ac85U+R0iaIbgOaRJdV67DwN5L/zrXs+KrL9JbtScg17/VqpFkfGpMVFVgsWS9g79Sgs8DJ3hGR3Ea0g3xCRuHHs2NUV083kXZv1CC7ihxDU2Uu4IA9/1Sl7bfMNzz/IEuxEhOlxQOZkRHpjc/4ggSbzDMeb+MM5OPIfRNla0itTsy8KvGkdaCMqb+CNoeGNp4k2oAl8QxIPbdbtoqav2mzvFLtTgHTFGQKnekZoZgTOgtxx5ollhH3ubx/tVkkRv1JYZTMTRCRRmuNijBrViXAdNeurG2c/kXWx5dwWHHSQA00bcshhO8zTpBjmp9GIfVJJBab7jCJWsyPK7MfvyZ05je4vhvKWpNniNIJB0aG93Ume78zR/QLiNMW81E6e/lBbDT7qZH6totOoW3eENizImBV3WnZSgTbXvofZ0/BlP3aLxlrCSs12civix5gzuPQNw5e5opo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 1:03=E2=80=AFAM Anastasios Papagiannis
<tasos.papagiannnis@gmail.com> wrote:
>
> copy_remote_vm_str() gets the target address space from a struct
> task_struct. This does not work for an address space that exists but is
> not yet associated with a task_struct, such as the mm held by struct
> linux_binprm during exec.
>
> Add copy_remote_mm_str(), which operates directly on a struct mm_struct.
>
> Use a common internal interface for the MMU and NOMMU implementations
> and define both public wrappers in mm/util.c. Preserve the existing
> copy_remote_vm_str() behavior, including handling zero-length requests
> before acquiring the task's mm.
>
> Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  include/linux/mm.h |  8 +++---
>  mm/internal.h      |  3 +++
>  mm/memory.c        | 41 ++----------------------------
>  mm/nommu.c         | 41 ++----------------------------
>  mm/util.c          | 62 ++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 73 insertions(+), 82 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index dd09c438fa23..63f40e615754 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3325,10 +3325,10 @@ extern int access_process_vm(struct task_struct *=
tsk, unsigned long addr,
>  extern int access_remote_vm(struct mm_struct *mm, unsigned long addr,
>                 void *buf, int len, unsigned int gup_flags);
>
> -#ifdef CONFIG_BPF_SYSCALL
> -extern int copy_remote_vm_str(struct task_struct *tsk, unsigned long add=
r,
> -                             void *buf, int len, unsigned int gup_flags)=
;
> -#endif
> +int copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
> +               void *buf, int len, unsigned int gup_flags);
> +int copy_remote_vm_str(struct task_struct *tsk, unsigned long addr,
> +               void *buf, int len, unsigned int gup_flags);
>
>  long get_user_pages_remote(struct mm_struct *mm,
>                            unsigned long start, unsigned long nr_pages,
> diff --git a/mm/internal.h b/mm/internal.h
> index 38b1165212c9..557b29381355 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -25,6 +25,9 @@
>  struct folio_batch;
>  struct hstate;
>
> +int __copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
> +                        void *buf, int len, unsigned int gup_flags);
> +
>  struct huge_bootmem_page {
>         struct list_head list;
>         struct hstate *hstate;
> diff --git a/mm/memory.c b/mm/memory.c
> index 8b0c2c735d3d..fe2f5e988fb9 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -7331,8 +7331,8 @@ EXPORT_SYMBOL_GPL(access_process_vm);
>   * Copy a string from another process's address space as given in mm.
>   * If there is any error return -EFAULT.
>   */
> -static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr=
,
> -                               void *buf, int len, unsigned int gup_flag=
s)
> +int __copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
> +                        void *buf, int len, unsigned int gup_flags)
>  {
>         void *old_buf =3D buf;
>         int err =3D 0;
> @@ -7407,43 +7407,6 @@ static int __copy_remote_vm_str(struct mm_struct *=
mm, unsigned long addr,
>                 return err;
>         return buf - old_buf;
>  }
> -
> -/**
> - * copy_remote_vm_str - copy a string from another process's address spa=
ce.
> - * @tsk:       the task of the target address space
> - * @addr:      start address to read from
> - * @buf:       destination buffer
> - * @len:       number of bytes to copy
> - * @gup_flags: flags modifying lookup behaviour
> - *
> - * The caller must hold a reference on @mm.
> - *
> - * Return: number of bytes copied from @addr (source) to @buf (destinati=
on);
> - * not including the trailing NUL. Always guaranteed to leave NUL-termin=
ated
> - * buffer. On any error, return -EFAULT.
> - */
> -int copy_remote_vm_str(struct task_struct *tsk, unsigned long addr,
> -                      void *buf, int len, unsigned int gup_flags)
> -{
> -       struct mm_struct *mm;
> -       int ret;
> -
> -       if (unlikely(len =3D=3D 0))
> -               return 0;
> -
> -       mm =3D get_task_mm(tsk);
> -       if (!mm) {
> -               *(char *)buf =3D '\0';
> -               return -EFAULT;
> -       }
> -
> -       ret =3D __copy_remote_vm_str(mm, addr, buf, len, gup_flags);
> -
> -       mmput(mm);
> -
> -       return ret;
> -}
> -EXPORT_SYMBOL_GPL(copy_remote_vm_str);
>  #endif /* CONFIG_BPF_SYSCALL */
>
>  /*
> diff --git a/mm/nommu.c b/mm/nommu.c
> index 498e01ee40b0..98596e60311f 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -1746,8 +1746,8 @@ EXPORT_SYMBOL_GPL(access_process_vm);
>   * Copy a string from another process's address space as given in mm.
>   * If there is any error return -EFAULT.
>   */
> -static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr=
,
> -                               void *buf, int len)
> +int __copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
> +                        void *buf, int len, unsigned int gup_flags)
>  {
>         unsigned long addr_end;
>         struct vm_area_struct *vma;
> @@ -1781,43 +1781,6 @@ static int __copy_remote_vm_str(struct mm_struct *=
mm, unsigned long addr,
>         mmap_read_unlock(mm);
>         return ret;
>  }
> -
> -/**
> - * copy_remote_vm_str - copy a string from another process's address spa=
ce.
> - * @tsk:       the task of the target address space
> - * @addr:      start address to read from
> - * @buf:       destination buffer
> - * @len:       number of bytes to copy
> - * @gup_flags: flags modifying lookup behaviour (unused)
> - *
> - * The caller must hold a reference on @mm.
> - *
> - * Return: number of bytes copied from @addr (source) to @buf (destinati=
on);
> - * not including the trailing NUL. Always guaranteed to leave NUL-termin=
ated
> - * buffer. On any error, return -EFAULT.
> - */
> -int copy_remote_vm_str(struct task_struct *tsk, unsigned long addr,
> -                      void *buf, int len, unsigned int gup_flags)
> -{
> -       struct mm_struct *mm;
> -       int ret;
> -
> -       if (unlikely(len =3D=3D 0))
> -               return 0;
> -
> -       mm =3D get_task_mm(tsk);
> -       if (!mm) {
> -               *(char *)buf =3D '\0';
> -               return -EFAULT;
> -       }
> -
> -       ret =3D __copy_remote_vm_str(mm, addr, buf, len);
> -
> -       mmput(mm);
> -
> -       return ret;
> -}
> -EXPORT_SYMBOL_GPL(copy_remote_vm_str);
>  #endif /* CONFIG_BPF_SYSCALL */
>
>  /**
> diff --git a/mm/util.c b/mm/util.c
> index bf0513d1d3d0..47c2e3ae8496 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1061,6 +1061,68 @@ int get_cmdline(struct task_struct *task, char *bu=
ffer, int buflen)
>         return res;
>  }
>
> +#ifdef CONFIG_BPF_SYSCALL

AI has a point, declarations in mm.h are not guarded by #ifdef
CONFIG_BPF_SYSCALL, no? These look generic, I'd remove BPF_SYSCALL
guard

pw-bot: cr

> +/**
> + * copy_remote_mm_str - copy a string from a remote address space.
> + * @mm:         the remote address space
> + * @addr:       start address to read from
> + * @buf:        destination buffer
> + * @len:        number of bytes to copy
> + * @gup_flags:  flags modifying lookup behaviour
> + *
> + * The caller must hold a reference on @mm.
> + *
> + * Return: number of bytes copied from @addr (source) to @buf (destinati=
on),
> + * not including the trailing NUL. If @len is zero, return 0 without acc=
essing
> + * @buf. Otherwise, @buf is always NUL-terminated. On any error, return
> + * -EFAULT.
> + */
> +int copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
> +               void *buf, int len, unsigned int gup_flags)
> +{
> +       if (unlikely(len =3D=3D 0))
> +               return 0;
> +
> +       return __copy_remote_mm_str(mm, addr, buf, len, gup_flags);
> +}
> +
> +/**
> + * copy_remote_vm_str - copy a string from another process's address spa=
ce.
> + * @tsk:       the task of the target address space
> + * @addr:      start address to read from
> + * @buf:       destination buffer
> + * @len:       number of bytes to copy
> + * @gup_flags: flags modifying lookup behaviour
> + *
> + * Return: number of bytes copied from @addr (source) to @buf (destinati=
on),
> + * not including the trailing NUL. If @len is zero, return 0 without acc=
essing
> + * @buf. Otherwise, @buf is always NUL-terminated. On any error, return
> + * -EFAULT.
> + */
> +int copy_remote_vm_str(struct task_struct *tsk, unsigned long addr,
> +               void *buf, int len, unsigned int gup_flags)
> +{
> +       struct mm_struct *mm;
> +       int ret;
> +
> +       if (unlikely(len =3D=3D 0))
> +               return 0;
> +
> +       mm =3D get_task_mm(tsk);
> +       if (!mm) {
> +               *(char *)buf =3D '\0';
> +               return -EFAULT;
> +       }
> +
> +       ret =3D __copy_remote_mm_str(mm, addr, buf, len, gup_flags);
> +
> +       mmput(mm);
> +
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(copy_remote_vm_str);
> +#endif /* CONFIG_BPF_SYSCALL */
> +
>  int __weak memcmp_pages(struct page *page1, struct page *page2)
>  {
>         char *addr1, *addr2;
> --
> 2.55.0
>

