Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6B7FC5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 19:52:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA7FB6B00A0; Fri, 21 Aug 2026 15:52:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7EC46B00A1; Fri, 21 Aug 2026 15:52:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6F216B00A2; Fri, 21 Aug 2026 15:52:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 988E46B00A0
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:52:58 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 386F31C0B46
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:52:58 +0000 (UTC)
X-FDA: 85126324836.11.65F5906
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4E91FC000B
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:52:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AWBxJ8NQ;
	spf=pass (imf22.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787341976;
	b=TgisVmn1CNMvRgQCbfLAsJSi9RsNaUnS+qnCgNcfX/fumEiT+Rq7rd9XzObUl8otP5t3lV
	K1VH+f9WvJElrVhuKvved+5ta/2RH9T9vLOibyD29nVl/Xwo97XAroHnyqG1Obocwf2ItZ
	BaojjwXEcOm9PhBYsVWWr7RUdut+PfE=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AWBxJ8NQ;
	spf=pass (imf22.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787341976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KidtnQB/eYDDRfHgfBWu/wvFzRWxKzN8GJX8+RxP7Rg=;
	b=m+0tdCyZa+1zPni2nyVOqMEphJXtn2V4rOI8gDG5KcdF2PeaaiHl8zgpfKbG/uXPXbVWOg
	0kv0mvQmeyBNrBgrTUZQB4tIByvYWXOI7jIK9Zco+EOitfhI2Uf/G5tStOvZJjT4ESmDdo
	rT/b1/P5OgpYF2VsMPq1/AyNiiTSeUE=
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-c9b373d5af0so1091764a12.2
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 12:52:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787341975; cv=none;
        d=google.com; s=arc-20260327;
        b=rJLvpKvgRSVmUqaXgOjif9aFAzxdMZMq7MHJVqIR0TjnaPurYBySbDHTd4Fq3ulC0S
         IYEeEgKpm2D1UTfl0SeNjo0gn0QLPrD3A0AzlSu/cXMOx/UBAg6EMdeG763I3H86IHU3
         lASRp08kmZzX1JJZgtL+fczagDWqmWitAhpj6xYGq0881ocZdbBZeTZhtW161NsBmw1r
         /ET+mGTpxU2Hk6mzGFHUZ1ui6exyydnDcr5zvNswj+afC+Uy7zWI1wCCga/GB+XloPef
         M2+BLV25TeP9xI/5iom/GwxEM2l/U4asE2LknRGUvGsp9AUBMJ9rUnQMiptSO3jqFya5
         5q5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KidtnQB/eYDDRfHgfBWu/wvFzRWxKzN8GJX8+RxP7Rg=;
        fh=MhA4IeT3c6CiAHOmxdLsgmoNuC4dMqTduP0xl2yPNvc=;
        b=WdsWg9Y79w4feLJkkP2A5TrTUT+/XeBWdKr8XQI/Wml4N90Kg5kERuBw5dDjG1Namx
         HIkcIYopKoTmP5xPnVt6I74CLVKpwS8IXGPcyEuMnSUbBNDjTrdS8sLpvb33Hyxkm8pF
         x8VvkTR2gp2czTjfcBidC09kAoNscRyYVJMdKCscGB9xi3ln6RdwOWKBLAIZFI16tUl8
         3+D13CbI0JAowOji6K0xfNzvzCGijt5Km43Fu1pmvpvTrEj5/wwmwQSyrMKaFNvqtGYP
         rZJ1QYuqngE4H4Frfub80U7wkegBTjRKNIo5IWCIwLfmYJqs7q5nlDnMsOahdTgjmleg
         0djQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787341975; x=1787946775; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KidtnQB/eYDDRfHgfBWu/wvFzRWxKzN8GJX8+RxP7Rg=;
        b=AWBxJ8NQrdHwIIH8xcXIknvTpn9cVbIctz4+hVMyfm+ekuO5RZJXPoUXTepxyDNRU2
         E4H50RFNY4JbDgAQ7+l/CK77lMNpAkZ9oc+9HQCV4KCLeDw4+srIcVplpu7gsaKf0wiF
         GgUzMLQHGrLC/i0gGo0gIcNVsCoXjJSuL5u8+xPRNe3Ljphgde7E/BKsiZ6+xF8z0wZZ
         CPVuQ7CLah1bcOwkDffzmmIvL8fTvUlClVwNBznuzD4ACTE4ngCYHkySrLNub6UUCVKI
         uDHxmUMIeFedxGFlLq/J5SFEFhFMeKoZCP+uZHt8gLgu1CCBReGkyMnl2qUIf7b4Dz2Z
         QCxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787341975; x=1787946775;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KidtnQB/eYDDRfHgfBWu/wvFzRWxKzN8GJX8+RxP7Rg=;
        b=J9N2EbHOS4+ugeKOC60LZam8gX7EvhzbA5zHaWBnmWc4rTyIBOy3xDQuoQ1+fz1Lxy
         joL1+uasCreVDp1ygGWpyEncqXqrgA9ndsCur8M1guVr0ZwBdtxvnVQ6yqTSg9uf2UFu
         8S4lrFsyP+i1KpScKnRBa/5yJdsKny/5YOObKzffZFD5BOOR8YlbAYAymeY8AOIWgMuU
         WTjg2h82uQISnU3Vd+LdIjslAD6rYCCv0vBEr7ns8/ge4b/eAAnhQy3qo2V6uHsIRjZa
         GP011yZlNBfc+W9BD8y1mqJuaxs+CKk0zhTNBVgCFR4PMjR64rl9Z2s+Dp6dLn01m5t+
         dZRw==
X-Forwarded-Encrypted: i=1; AHgh+RpMU2UBFNgCGWA1kqqTSLqVs3x/1Vf6L78gWINcHARv8dWpdta59m4JkvLir0Q4m6aTZNSbR9Bodw==@kvack.org
X-Gm-Message-State: AFuF++kP02GSp/Nxcx5WbNOXvKBdaFF2sHiySF62LjjM+2Mfudpeye0A
	vo+uTjJPqp2EUKUQlj6vU9pwJ2SbDPRZOHLejx3jF+aCpNQAEweih0fgz9MnhWw3CUH0q/M+FAu
	n5nt4je1hRt84S+eXh/YWzA828e2lsh8=
X-Gm-Gg: AR+sD12SMmKxQQrulnQgbgew6jJ+C6taW7vhrblrTe87xTgqlBWZQNTie21C4AZ2DnB
	Hcysb4idFjEwREeeh5lSPRk26vADZxYuTUS9x66abNtkzcX2QVmZMWT9toaKCP1lrnAD0II0zq4
	bE0JjzWgpig7UdT8Q3ObhJPaSWOsDaXMWl2Axtv9ptE8g5sMBbblxY23rz3PrpYgD6Wj7dhQVER
	yRO224Kd7eQVby0zovopdr7bDBL4YPZUApVJQaVKaYq/X3nL2ebT1M3CkNQ3Zv2hzcUANavSZNG
	AGde6kKIbYSZPmRFPSq3EtU+Acn0gghuBjIs4uWPuJG84CUTfXEmOOzQXsTeSaDSwE8GriOekSS
	lCk5ov4q6YJj5WiB5xYO6cIuzTw==
X-Received: by 2002:a05:6a21:6492:b0:3cb:853e:850e with SMTP id
 adf61e73a8af0-3cd4bbe8aa6mr2217187637.13.1787341975075; Fri, 21 Aug 2026
 12:52:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260820131801.68759-1-tasos.papagiannnis@gmail.com> <20260820131801.68759-2-tasos.papagiannnis@gmail.com>
In-Reply-To: <20260820131801.68759-2-tasos.papagiannnis@gmail.com>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Fri, 21 Aug 2026 12:52:42 -0700
X-Gm-Features: AcwNN1WiobjREO1ATp2ZQpfgWCtJVvDwcD8UEwKRu-9pDckvpVIFCNaWpSBtzYk
Message-ID: <CAEf4Bzb-43E7JSc5aNBEi4y1PKfQvjRi_FwTUyP7cYaQ+-JqXw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/3] mm: Add copy_remote_mm_str()
To: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
Cc: bpf@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com, 
	kpsingh@kernel.org, matt@bobrowski.net, song@kernel.org, 
	utilityemal77@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4E91FC000B
X-Stat-Signature: pu4xrkp1jzmz6njgudqqre777n83mor9
X-HE-Tag: 1787341976-525369
X-HE-Meta: U2FsdGVkX1+uJhEiHDPTOJnnBAzTL9hgTHAWOXbTr8ChxxpZi6FGCzQODA7uHZLp/z1Oz9XEgf0B11xiwBcVEA0UvdEu+q/PwITeim8k5TscxrASZv8szF3aimTiitI0I/WYzhi5SX2qvQFtth+iKyVvWcvcj+KT3/2t0Uvt2o9iDwLWp4IiOEC72Xe4BYtO5sqPk6CF7Yxp/1R84GzPpuFagfvThPy+/t+2Q51xCrsZz+Abn54NjtGJuTd3L9BxeSyTjlXJ44lyw8Bl37Ls/cRP/b8j1yIEoGPK2h3zhG6kaWigIM4CnL11QTsYEJ7UB5uV+RfHtzp8FJ21aVpDTfKogqE+ACilNh93lXeuDszKV2g+qbdtRNRbgXiWkP9KizptbiLkgRN9XbxxNODeWlUGW/TbK23ImOS7ZPUtoDQWcejVrejspOHvR5/zmU4g7RxgxY9p8qsCiq1QYlkmlyqwhzcTK7OyF/xUCtPAoWlYR7riewXWkZQ8pWrcOUt+FPJM8FzVhW/UOf+aLPSSNUhi35BmUwtpvZC3k/qWOnSUL93ok6WbfIoMaorJdrNxwoAOUrkxGjkACCNwqJggQfHJSiK7f3C6evs8CfPIgrkzNWMBwByu/Ye8mqU4LU3orNmSNnVPNjKoOT1b3JLwqMJrcNtPgODe7ZipKda6trqC1y2JTrph5g3CODVmm+oGFUcMvBYObw0gv9V9HnmQG0q0h5RWrgKQ6fCYBcdIPpbFCGdRRH2E3MT7+1gksH6n69MhCV7+1uIzpPDfjpbbrFs9JR+8oU6EY5p9XFxHM57NURqvF6jlwXx63QCWE/fmo7eBmfULfQmGMJwTf+4wcLsS4iXpQ3VYB4g/1ckH/a+aqBJXgszo3pG3OaHPzGTeP6bxr7IAv6BpF1sJdXIH5kjwFlHL+ovhx+jMdT2KW5/NG+3C47OJK+2Za1oXFSvOsjJxGABBWTr/r7VUY/n
 TXHUtDGM
 ZBDPLWcwf4vok6rIKMWmMNYgm/mtu3BbGYL9Y/3LZauwZGdZ9bUyp423mV/9P52fFy6RvdeAXXgssO1vNLXFPDwqmrFKZSKp67vopwnM2LEjxr9OQ5Yv8xchiZE6CS7krlctVQ+3ROPIMFOK45ujVz7GODM3StW4NeMohRR5fm5gzgtypQQ6pyRIN788esPwVPqih6tT/IznVGOA4JzpOfVbFP1UsrxV6Gqg5pJ4H0ZGt2FN0BqlyF4vVN7WHCTCsp7MZxej4thAgY/Ie0+aahsn6lv2DN/K/5xH3h1goNXVPXWFgOyuBFhE+Eond7Gc8gNlfMzMt+jVJt9AEwoUvFdzvgoF6IRcJPLz8cdICvgZP4eG9ObIfM8eVSqzl/T+bp1qz9lgnpnUcry4C/6v4Dnck2qfRU2YnHPkCrvWU9XVHvFaexkpHiAfNmM7rktOITVfAKWqh28PmxiFQvhaRzPBvXH18UZdUQQ/APC0CTvpnPpJrWcechU/9vOu0Re5IuwbY1JCPtWfQpPyjx8s2V+NRYlTvP/NaJfV6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 6:18=E2=80=AFAM Anastasios Papagiannis
<tasos.papagiannnis@gmail.com> wrote:
>
> copy_remote_vm_str() gets the target address space from a struct
> task_struct. This does not work for an address space that exists but is
> not yet associated with a task_struct, such as the mm held by struct
> linux_binprm during exec.
>
> Add copy_remote_mm_str(), which operates directly on a struct mm_struct.
>
> Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
> ---
>  include/linux/mm.h |  2 ++
>  mm/memory.c        | 26 +++++++++++++++++++++++++-
>  mm/nommu.c         | 26 +++++++++++++++++++++++++-
>  3 files changed, 52 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 485df9c2dbdd..eede435bf4a3 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3222,6 +3222,8 @@ extern int access_remote_vm(struct mm_struct *mm, u=
nsigned long addr,
>                 void *buf, int len, unsigned int gup_flags);
>
>  #ifdef CONFIG_BPF_SYSCALL
> +extern int copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
> +                             void *buf, int len, unsigned int gup_flags)=
;
>  extern int copy_remote_vm_str(struct task_struct *tsk, unsigned long add=
r,
>                               void *buf, int len, unsigned int gup_flags)=
;
>  #endif
> diff --git a/mm/memory.c b/mm/memory.c
> index 6b8280cfc1db..da0010c4475d 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -7218,6 +7218,30 @@ static int __copy_remote_vm_str(struct mm_struct *=
mm, unsigned long addr,
>         return buf - old_buf;
>  }
>
> +/**
> + * copy_remote_mm_str - copy a string from a remote address space.
> + * @mm:        the remote address space
> + * @addr:      start address to read from
> + * @buf:       destination buffer
> + * @len:       number of bytes to copy
> + * @gup_flags: flags modifying lookup behaviour
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
> +                      void *buf, int len, unsigned int gup_flags)
> +{
> +       if (unlikely(len =3D=3D 0))
> +               return 0;
> +
> +       return __copy_remote_vm_str(mm, addr, buf, len, gup_flags);

we should rename __copy_remote_vm_str into __copy_remote_mm_str

> +}
> +
>  /**
>   * copy_remote_vm_str - copy a string from another process's address spa=
ce.
>   * @tsk:       the task of the target address space
> @@ -7247,7 +7271,7 @@ int copy_remote_vm_str(struct task_struct *tsk, uns=
igned long addr,
>                 return -EFAULT;
>         }
>
> -       ret =3D __copy_remote_vm_str(mm, addr, buf, len, gup_flags);
> +       ret =3D copy_remote_mm_str(mm, addr, buf, len, gup_flags);
>
>         mmput(mm);
>
> diff --git a/mm/nommu.c b/mm/nommu.c
> index ed3934bc2de4..1fca0bb7f042 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -1752,6 +1752,30 @@ static int __copy_remote_vm_str(struct mm_struct *=
mm, unsigned long addr,
>         return ret;
>  }
>
> +/**
> + * copy_remote_mm_str - copy a string from a remote address space.
> + * @mm:         the remote address space
> + * @addr:       start address to read from
> + * @buf:        destination buffer
> + * @len:        number of bytes to copy
> + * @gup_flags:  flags modifying lookup behaviour (unused)
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
> +                      void *buf, int len, unsigned int gup_flags)
> +{
> +       if (unlikely(len =3D=3D 0))
> +               return 0;

I'd just move this len check into __copy_remote_mm_str()


> +
> +       return __copy_remote_vm_str(mm, addr, buf, len);
> +}
> +
>  /**
>   * copy_remote_vm_str - copy a string from another process's address spa=
ce.
>   * @tsk:       the task of the target address space
> @@ -1781,7 +1805,7 @@ int copy_remote_vm_str(struct task_struct *tsk, uns=
igned long addr,
>                 return -EFAULT;
>         }
>
> -       ret =3D __copy_remote_vm_str(mm, addr, buf, len);
> +       ret =3D copy_remote_mm_str(mm, addr, buf, len, gup_flags);
>
>         mmput(mm);
>
> --
> 2.55.0
>

