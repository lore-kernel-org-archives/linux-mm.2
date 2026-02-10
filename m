Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E17C9EB2712
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 20:36:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2BC16B0005; Tue, 10 Feb 2026 15:36:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED9346B0089; Tue, 10 Feb 2026 15:36:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBACA6B008A; Tue, 10 Feb 2026 15:36:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CB6326B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 15:36:57 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A292C1C854
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 20:36:57 +0000 (UTC)
X-FDA: 84429706074.25.41BCCDD
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf08.hostedemail.com (Postfix) with ESMTP id 98F43160004
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 20:36:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=mihalicyn.com header.s=mihalicyn header.b="PMg/etVW";
	dmarc=pass (policy=quarantine) header.from=mihalicyn.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf08.hostedemail.com: domain of alexander@mihalicyn.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=alexander@mihalicyn.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770755815; a=rsa-sha256;
	cv=pass;
	b=cuDjRK2kM5vE+OuM3SDsrAaiIhmt+YcuYE1KE3ff6BKJlEBqeuDLXhHVWQXsGv65GLLrde
	UuMER8a0jOu3O93LQdUCT/ckZNe9k4bJ9C+BEA1SM6Jth01onepnDlMD2Pz5oupVfSk9BE
	/rZghQoOOYr0XpqUUgZk6KYOvx+H3fY=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=mihalicyn.com header.s=mihalicyn header.b="PMg/etVW";
	dmarc=pass (policy=quarantine) header.from=mihalicyn.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf08.hostedemail.com: domain of alexander@mihalicyn.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=alexander@mihalicyn.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770755815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/RVEjU7kEYe1QZq8m5Yk/boKMRnRFHVBS46XFdmJlx8=;
	b=fgFeJ/jW8IfCkq7uDyt7elwzeGW6vUV78f67AVPcCP7AgYc1zTiqZLmZP3PODRdXdOjhEL
	+oLE5RkUpun3N7iTPTLw7LM1OiM05bHcvG41tvafzuSkK5IGs/Yv4UoUqHM7EYPkZ+9Us3
	87/j0pR0/yOU+rep8SwGz9Yz7WXMaMY=
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-59de66fda55so5457583e87.3
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 12:36:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770755814; cv=none;
        d=google.com; s=arc-20240605;
        b=L10kIfBe/lnBV2YmrPDfm76TFu02ozGI4q5LgteY5vzlqr6SrB52obzajnkt6nMTq2
         2ljP1UJBRVjYvrBfHH5L8+SanhC5d/NPWKwDJ+na7vyQWKnCzq109EYXtZmbUvIPA6D/
         8QEyjtx9+rCL1mocNJk1nlSDDTJwGfnLAxzfSjSQkuPpNWcoBhIB93URziLEez5dixyJ
         ZPL+BA8wakZpWKZTmZWr4W2o4DOAcVfOBYJLMLQNDFjmp1lnfviqxlcTY8Nm/awHkXsR
         HahHLlwheNUv0Tq5ZjQI28TDnbHHakZ/iTovg428VpyvkgvJbBZay76C/CDibdtoHihN
         If9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=/RVEjU7kEYe1QZq8m5Yk/boKMRnRFHVBS46XFdmJlx8=;
        fh=Zp4eSDTo0tKU0dkBb8rz2eYWANrg54SI8zImcG/orR8=;
        b=lufvLR37b73JZE+PbeJ07+ffbiPnxXErPgL5naYvVvtEToTKbgXXznoV3VUZh8jz23
         GSbUcyxtHUr5YuHue32Pye62RW0QRZzeD6v/TLFYSwkpKLj3fgkQjZ6DbJkLHLABJNB5
         eByywdyQtCuv8RIsxGx/Gej+neudmF6eQJ10PaYmhYLaxfElSQ+xwxYT64DYDsXSR8mx
         ri4IgP+oXFWHO1a/zbbJ8ZcXNgx4i7TAmfiPBM1OhXRIjYJYMd4DyWIXK1CyiDzlCfQ/
         zw1ubH8E2uUSjJR2yM/xTj5VKcuuiP9Oqs6qdBTPBV26Kf8op3gRCEdvMmKun9m8v79B
         912g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mihalicyn.com; s=mihalicyn; t=1770755814; x=1771360614; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/RVEjU7kEYe1QZq8m5Yk/boKMRnRFHVBS46XFdmJlx8=;
        b=PMg/etVWlTS2a+IPEzJQX9Le+zoXQQRft96k0o001atKkjWcIx8gCiLHfPoF3/SryE
         X9Wahy29YDLU4oCsf0dve3TR2VCpRLdWgHglyGsYYEbdLyxr919O7LbBBnrI/mhN5EVn
         90Ise5lR/219H/HRFvnbP9VYUkUGClGAal7TQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770755814; x=1771360614;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/RVEjU7kEYe1QZq8m5Yk/boKMRnRFHVBS46XFdmJlx8=;
        b=AY2j5aVMEOq/zr8yQtFEQUczC0pirBxs4Qn7fRVKGu4CsS9Dx+GmjQ5de/VC5fpXNJ
         MHpNQuGaXyElOhsq7MRDQjecnJr9GtxKXKajVafxp4HTGEhuxcv7AAq+nmL6BkHSPs68
         i9xL3scIDm2PbisYzYUjDaaRS372xoTylR+q1wc46czO2IiRDvbDC0Q2WRROgLhR9kma
         sl1OeyYcVTB6jlFXBXtSxSEdtMzPL03tb/Har8yOSrWvpyxA9Y95CBwbT0BSP8Nbeh3k
         7fNsVQMOIgPJ/WgAcCE/kXLm0WxaL7dMki04Cbaqvo+BReqsRZxbnfv1fdEyiF+G9YIq
         2eJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUCSfx/015jijIRsVpDf9dwW99wjAID3e82j+kVW80uang5SBWuKzML0UhWaL6PcP14oitQvpQlZw==@kvack.org
X-Gm-Message-State: AOJu0YyGXKMPJHL7yydtI/kI463cDmAsjw3jG6nWHQ3gFYa8IS8qVIUJ
	To+hadHgKKfzdYmgLn04aaMZDpMPTGRkj408azGlcGSZ7bfve/QH5w1Y0J+HTcYT3ygZl3lvNFj
	jNzn4bJzFnZfjUXsWJd2s3XXyi93hTlxWitEK1I2bVg==
X-Gm-Gg: AZuq6aI/lymnsGYodvodu52V/j1efClNZrOPkkeKTyOAxXSJ+Cr48PKDf+wIG7jfx8+
	dQrShuaV8N12YRj2YdzRNhdaoXGXH2kc84TxKNt9KeXdlgOPKrKkFLMRDeokMnGRgqwnws2hZU2
	IDxy9o2DxmKKW4ushXAu5C0ErBZtooEfCfW97YKbDyGtsYCcXsRkECArrEuPVBvn75l1rbt9GX1
	gzmUxNv6HcCHTbWrR2obuz+yZ83yYToVorIlxE7etv4wM9HhSqpb6NTRSTtNQfmOxenOkWB9r9C
	6PmGeYub2hz+WK+j4Sl7DPJqU5/Yyr1zw7uMrn4=
X-Received: by 2002:a05:6512:1301:b0:59e:1a8:5e86 with SMTP id
 2adb3069b0e04-59e5c3f991amr134928e87.41.1770755808592; Tue, 10 Feb 2026
 12:36:48 -0800 (PST)
MIME-Version: 1.0
References: <20260209190605.1564597-1-avagin@google.com> <20260209190605.1564597-4-avagin@google.com>
In-Reply-To: <20260209190605.1564597-4-avagin@google.com>
From: Alexander Mikhalitsyn <alexander@mihalicyn.com>
Date: Tue, 10 Feb 2026 21:36:36 +0100
X-Gm-Features: AZwV_QgjfoRdQrlUqWSC4XnkqPkyYSWTA1P5z4cr4cHfm0maV7oMuAR0P9Khr8M
Message-ID: <CAJqdLrqFJm5s4qgczWUi50muoMbUm7tbDZ4vTp=3ktEDYoi7wA@mail.gmail.com>
Subject: Re: [PATCH 3/4] mm: synchronize saved_auxv access with arg_lock
To: Andrei Vagin <avagin@google.com>
Cc: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Cyrill Gorcunov <gorcunov@gmail.com>, Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, criu@lists.linux.dev, 
	Chen Ridong <chenridong@huawei.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Eric Biederman <ebiederm@xmission.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Koutny <mkoutny@suse.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 98F43160004
X-Stat-Signature: 4ft98rb98jhyo38xnj5i9ryyc7bn16nr
X-HE-Tag: 1770755815-273522
X-HE-Meta: U2FsdGVkX1/r7hnT1+AYtgksJNEOkuOhT4o/4rno5RTbUVAulWEWvWafsqiYbW8yMaKxCs0gCfXEb5l2/8UcixYMNOt/hWLmZBeMvL7IJrCHMQkaD/ikSkOq/7nm0utGIDL7QjyQeHSz5lYSUE+xQhdw7gpRygStxlO3cYxGS/OmdEQkWzPgEgOAtjk1aznNxG0AvC/AVD7cve8C1WxPEMfF2wX1ANPO47m4xg5Z7sch1pMCuifva4KMezV18m7I9WD+kgCyLGs6/Wnhqb+CnjhdT3HtmRLkQnAnvCjw4Gj2F2+SZIEtuJK9xnlMmdA7KJ648R9klNU3A5qR04MxJJ76cMqF4t9557R2sb8j3fa27FZfbu5/6xpXFs443FKF27x5QpjppuYhP26Ey8M1GrAIeHbFsMgJhbqjBYfuTiMUCGPNbAUajRNB1Vrg5QGZWvOQev5N3t6LnZ1K+P0Y6YW80dW6fjfTxGd/RULEA85g3+fvrPQNg0tS9FUctJfvWgeRhb0MJUZTuPwjoGN1qoBNq2vGwkTnJ2FcpOwcPaLJ7bgTVpSuVtAHv0qnpF8+4E/SNRtH40FMxEGpC0wH43pl/dJ0QErbIpFVcdAqq7S8ZiOwsYc/I8He5J0VbIogSBmGblI41ZXcKQkn0LYqBLYRAE12mnLwSdxcFU/aLs9i0fSiCyG1jDjwca2idw1bWVh3CiDy+BrzAzp8wKhmZKI5shPO6ZGSUjBp6eZAwULSCfYiJzrMFpen9XUDrTT5Lvff5J5I1rfeGq+tIjb22gOUuGsnuVs0ggku8NtQAuVhz8e0liDG82HBEqtaRAL7G3cE/V7IfJlgdOcK5s3mU9A+NeQIj48YKnDAnn/AQv/rsGMG47haOt1czRd2SpyQGrBitku3xe900psNRStY8DnVNVpg14CjhsIeLRzkmWiQl4+dFQFGpP7x6FM5sj4OodELOvr/z9gWAlv1vo9
 yMTjZvNm
 mgIbDwjUAxi0kI+kzZ3+lgvZp/z36rakP+XagZcB9rky0yBkuM7flySjh1/uJpM96o/NwYsGNLnAdb6x7E9XOLDwc/miCEQaXR+huo1uojho88vI98um+QTSp+119CgmlMHdsDuKH6uu6llz2C3knS4Dk9AbQWkfcsDTEFYLfe2rmSw3JLKX7KG4orvUo2/dE39ePtfCS/NLfZ99Gmf5x0lVHVybDkXiuHKPNq1e9fUcZGSTVm+EBsvjIKPMeAoLI9+IgPDwDb31zrtEPiImFsAv350s9P3MR/ggF/trxFLYXIq9VUnhlIgjxM/UlpC/0I9Twh3nQtppHCwkYs/23JM9oF/V5w0Cn+wYOWew6DpAY0Vw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Am Mo., 9. Feb. 2026 um 20:06 Uhr schrieb Andrei Vagin <avagin@google.com>:
>
> The mm->saved_auxv array stores the auxiliary vector, which can be
> modified via prctl(PR_SET_MM_AUXV) or prctl(PR_SET_MM_MAP). Previously,
> accesses to saved_auxv were not synchronized. This was a intentional
> trade-off, as the vector was only used to provide information to
> userspace via /proc/PID/auxv or prctl(PR_GET_AUXV), and consistency
> between the auxv values left to userspace.
>
> With the introduction of hardware capability (HWCAP) inheritance during
> execve, the kernel now relies on the contents of saved_auxv to configure
> the execution environment of new processes.  An unsynchronized read
> during execve could result in a new process inheriting an inconsistent
> set of capabilities if the parent process updates its auxiliary vector
> concurrently.
>
> While it is still not strictly required to guarantee the consistency of
> auxv values on the kernel side, doing so is relatively straightforward.
> This change implements synchronization using arg_lock.
>
> Signed-off-by: Andrei Vagin <avagin@google.com>

Reviewed-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@futurfusion.io>

> ---
>  fs/exec.c      |  8 ++++++--
>  fs/proc/base.c | 12 +++++++++---
>  kernel/fork.c  |  7 ++++++-
>  kernel/sys.c   | 29 ++++++++++++++---------------
>  4 files changed, 35 insertions(+), 21 deletions(-)
>
> diff --git a/fs/exec.c b/fs/exec.c
> index 7401efbe4ba0..d7e3ad8c8051 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1793,6 +1793,7 @@ static int bprm_execve(struct linux_binprm *bprm)
>
>  static void inherit_hwcap(struct linux_binprm *bprm)
>  {
> +       struct mm_struct *mm = current->mm;
>         int i, n;
>
>  #ifdef ELF_HWCAP4
> @@ -1805,10 +1806,12 @@ static void inherit_hwcap(struct linux_binprm *bprm)
>         n = 1;
>  #endif
>
> +       spin_lock(&mm->arg_lock);
>         for (i = 0; n && i < AT_VECTOR_SIZE; i += 2) {
> -               long val = current->mm->saved_auxv[i + 1];
> +               unsigned long type = mm->saved_auxv[i];
> +               unsigned long val = mm->saved_auxv[i + 1];
>
> -               switch (current->mm->saved_auxv[i]) {
> +               switch (type) {
>                 case AT_NULL:
>                         goto done;
>                 case AT_HWCAP:
> @@ -1835,6 +1838,7 @@ static void inherit_hwcap(struct linux_binprm *bprm)
>                 n--;
>         }
>  done:
> +       spin_unlock(&mm->arg_lock);
>         mm_flags_set(MMF_USER_HWCAP, bprm->mm);
>  }
>
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 4eec684baca9..09d887741268 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -1083,14 +1083,20 @@ static ssize_t auxv_read(struct file *file, char __user *buf,
>  {
>         struct mm_struct *mm = file->private_data;
>         unsigned int nwords = 0;
> +       unsigned long saved_auxv[AT_VECTOR_SIZE];
>
>         if (!mm)
>                 return 0;
> +
> +       spin_lock(&mm->arg_lock);
> +       memcpy(saved_auxv, mm->saved_auxv, sizeof(saved_auxv));
> +       spin_unlock(&mm->arg_lock);
> +
>         do {
>                 nwords += 2;
> -       } while (mm->saved_auxv[nwords - 2] != 0); /* AT_NULL */
> -       return simple_read_from_buffer(buf, count, ppos, mm->saved_auxv,
> -                                      nwords * sizeof(mm->saved_auxv[0]));
> +       } while (saved_auxv[nwords - 2] != 0); /* AT_NULL */
> +       return simple_read_from_buffer(buf, count, ppos, saved_auxv,
> +                                      nwords * sizeof(saved_auxv[0]));
>  }
>
>  static const struct file_operations proc_auxv_operations = {
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 0091315643de..c0a3dd94df22 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1104,8 +1104,13 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
>                 __mm_flags_overwrite_word(mm, mmf_init_legacy_flags(flags));
>                 mm->def_flags = current->mm->def_flags & VM_INIT_DEF_MASK;
>
> -               if (mm_flags_test(MMF_USER_HWCAP, current->mm))
> +               if (mm_flags_test(MMF_USER_HWCAP, current->mm)) {
> +                       spin_lock(&current->mm->arg_lock);
>                         mm_flags_set(MMF_USER_HWCAP, mm);
> +                       memcpy(mm->saved_auxv, current->mm->saved_auxv,
> +                              sizeof(mm->saved_auxv));

nit: I was looking for this memcpy(mm->saved_auxv,
current->mm->saved_auxv, sizeof(mm->saved_auxv)) while reviewing
a previous patch. Shouldn't it be there?

LGTM.

> +                       spin_unlock(&current->mm->arg_lock);
> +               }
>         } else {
>                 __mm_flags_overwrite_word(mm, default_dump_filter);
>                 mm->def_flags = 0;
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 6fbd7be21a5f..eafb5f75cb5c 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -2147,20 +2147,11 @@ static int prctl_set_mm_map(int opt, const void __user *addr, unsigned long data
>         mm->arg_end     = prctl_map.arg_end;
>         mm->env_start   = prctl_map.env_start;
>         mm->env_end     = prctl_map.env_end;
> -       spin_unlock(&mm->arg_lock);
> -
> -       /*
> -        * Note this update of @saved_auxv is lockless thus
> -        * if someone reads this member in procfs while we're
> -        * updating -- it may get partly updated results. It's
> -        * known and acceptable trade off: we leave it as is to
> -        * not introduce additional locks here making the kernel
> -        * more complex.
> -        */
>         if (prctl_map.auxv_size) {
> -               memcpy(mm->saved_auxv, user_auxv, sizeof(user_auxv));
>                 mm_flags_set(MMF_USER_HWCAP, current->mm);
> +               memcpy(mm->saved_auxv, user_auxv, sizeof(user_auxv));
>         }
> +       spin_unlock(&mm->arg_lock);
>
>         mmap_read_unlock(mm);
>         return 0;
> @@ -2190,10 +2181,10 @@ static int prctl_set_auxv(struct mm_struct *mm, unsigned long addr,
>
>         BUILD_BUG_ON(sizeof(user_auxv) != sizeof(mm->saved_auxv));
>
> -       task_lock(current);
> -       memcpy(mm->saved_auxv, user_auxv, len);
> +       spin_lock(&mm->arg_lock);
>         mm_flags_set(MMF_USER_HWCAP, current->mm);
> -       task_unlock(current);
> +       memcpy(mm->saved_auxv, user_auxv, len);
> +       spin_unlock(&mm->arg_lock);
>
>         return 0;
>  }
> @@ -2466,9 +2457,17 @@ static inline int prctl_get_mdwe(unsigned long arg2, unsigned long arg3,
>  static int prctl_get_auxv(void __user *addr, unsigned long len)
>  {
>         struct mm_struct *mm = current->mm;
> +       unsigned long auxv[AT_VECTOR_SIZE];
>         unsigned long size = min_t(unsigned long, sizeof(mm->saved_auxv), len);
>
> -       if (size && copy_to_user(addr, mm->saved_auxv, size))
> +       if (!size)
> +               return sizeof(mm->saved_auxv);
> +
> +       spin_lock(&mm->arg_lock);
> +       memcpy(auxv, mm->saved_auxv, size);
> +       spin_unlock(&mm->arg_lock);
> +
> +       if (copy_to_user(addr, auxv, size))
>                 return -EFAULT;
>         return sizeof(mm->saved_auxv);
>  }
> --
> 2.53.0.239.g8d8fc8a987-goog
>

