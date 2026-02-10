Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E3FCEB270F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 20:13:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACDEF6B0005; Tue, 10 Feb 2026 15:13:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7BB66B0089; Tue, 10 Feb 2026 15:13:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 929836B008A; Tue, 10 Feb 2026 15:13:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 80F7D6B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 15:13:56 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2DFF61A0668
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 20:13:56 +0000 (UTC)
X-FDA: 84429648072.20.93E6017
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf18.hostedemail.com (Postfix) with ESMTP id 163FB1C0013
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 20:13:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=mihalicyn.com header.s=mihalicyn header.b=EOrFc4g9;
	dmarc=pass (policy=quarantine) header.from=mihalicyn.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf18.hostedemail.com: domain of alexander@mihalicyn.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=alexander@mihalicyn.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770754434; a=rsa-sha256;
	cv=pass;
	b=xqmhf4pb+htDJZ9r2msNl5K1l9s6yvfD1aXNbilB2TBS24pdOSoaK47vHLjoM0K5WONjjS
	3+iFDUW3sVK2sTWBqsxJk0/9HW0kmMsXJu9cq7ypfHWsys+5mQjvu54eGfRy4rK7kqM8r+
	/YTxDSOdNTxbTpwWD3cLFjgM5fmdprs=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=mihalicyn.com header.s=mihalicyn header.b=EOrFc4g9;
	dmarc=pass (policy=quarantine) header.from=mihalicyn.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf18.hostedemail.com: domain of alexander@mihalicyn.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=alexander@mihalicyn.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770754434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xE4HPFLV4wxMbDW18a6mpuhV8ULKkz9tZ9KJu12oN84=;
	b=hFXWYdIwrmTDZUMU1bhTwsu1DXNZM1Ze7bi8fkNtU3miqbXZuZsQ07I+MCTIxK5kvwicIF
	QyQXzZg330yzN+CNhyQNe5MtOUf38/c1JCYx+PJPoTGtQD3IyC5+qB3HY17hkDbR5yP+T6
	9cmg9YL/4Re5/Rhu0HJDnVRilyM5rp8=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-59e0d5c446cso1366560e87.0
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 12:13:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770754432; cv=none;
        d=google.com; s=arc-20240605;
        b=VrMjLVTBIQxBcZv6/0dzfVnkkblh1otM8O+BizKz+kPpD8bCg7IfOZmsyTcdQsQ6ng
         Q2KTbPiNIGqcgRuQEcFCr+mjBDY+KBMJxHgln8199543snVAf4ouYR3VyZHia6JDipQg
         iq5B3LVpOwdUu/Rex5m+C5DboFbJHplD2LAN3bDt2R0fRds8Jz17PC8zbjp8GRG/I3iV
         D1ugCyaqKL/FZlYl79qixtTqp8Ln3g69pDYy8sqgQxJUDJgJIT0glTDyQo+4C/9TxKZl
         S+oeG3OIBBXEmI6YbUi552s8REDYyE6AUt4l2mw92U/XLtYn6EgaviDvaQaXkHThbA8e
         nExw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=xE4HPFLV4wxMbDW18a6mpuhV8ULKkz9tZ9KJu12oN84=;
        fh=TJ5jH70JkJQ1PixCyUWL6H17gWpRxLRGdM39JCieJlY=;
        b=BQj3BVpoEHXFDJXSgKBFM5tbOY7g+gllRvIl2nUV6MWFB5oXtCkekpN5FBxN891UDJ
         YoMPnjrr4Yj0pKhL0T/mK2JdoaaM5YAyDE+fmxnzE64ohUhJX1AOinLVz+FUrlFHSmlP
         k+CwjoGk0OPTlMSGLXNoYUZNLwO57dqP+fVpV5yXLskFdd4RtxyR7mUgMRB1FQn7qW0g
         /ySOFIs52SIR58TyCxeHeZ8aHqEjcqWYZJHOYw945OnEQd9o2hL+oKqDUA5bQnyXgzrq
         lnTQNiKRay2vVDX3ADuKZ0egE/lQZ7T1t2lja09nav+m0JHCqeapIqW3UWhkbpkB8scG
         BVYw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mihalicyn.com; s=mihalicyn; t=1770754432; x=1771359232; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xE4HPFLV4wxMbDW18a6mpuhV8ULKkz9tZ9KJu12oN84=;
        b=EOrFc4g9j6tcH5ydQ30iL2V2AY17L3By2T/DUcTlP22v9sKa/teMuLcdXEmpga3A9x
         tbDZ17MFldP9VEIJn4kE277LuXIeavgfYgKdUuRwdQZAi8+zUCPbwPk9EZZIs5JeSMpb
         kv91imSgzNIrzPK+mGsAl4zNrg0SLH+uaYiPg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770754432; x=1771359232;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xE4HPFLV4wxMbDW18a6mpuhV8ULKkz9tZ9KJu12oN84=;
        b=jI1HMl6eXlYXva2nzi0Ud39MThQziYEhZ0u5JyVn8Vx8R3YCbwhV4CKrM47/Zai/ah
         CBPUpc91L3ArbIJhhoxVnOJfIquVyAMphyfcOtYj5Qln7UM5iaYHawPUDBaSir5c8XXB
         yx/vuhv15LzDnxSrYyzDkDVJ/yt9lgwKffLCdb59GxT53oiF1X00aZ6RKYiZ9lU+d3UY
         U4AQCjzE6sFqtsvyhIx7OVnVCCB5ruTJuN8TfZ7sRY9FSX0F/eGrnIYeveRzcdQpwsxx
         WzPIhMsihPpXxiH7yJ3ykOTp0DrkrwrtdjYHlBUO1AOxTmRqv7ddv7dzrL3whOEH15SP
         qhhA==
X-Forwarded-Encrypted: i=1; AJvYcCU2HyNRlUVHWB0DnpXOFUmBNMtxBRqtakL3M+537pDXic/4rnGn7id6dng8QiMvDyb6ADKu0cKZIA==@kvack.org
X-Gm-Message-State: AOJu0Yw72z/71K+K37wZHcH66Nm3/2mtXMhodLItCDoGZE95+MVgm+sa
	I0Ekz7sd5E25R2uoCxW30ghrcVSacW4UD6WVbJpz6HCYOBmczBKJMeQoPpQr+Bm3TmRH4m8aY4D
	Cs7tVa+NTgiUGExelxd9ndaftLHQtpvXvPkOhQKE76g==
X-Gm-Gg: AZuq6aIQcBIlIJVfYAvUTBoAI7ytXKp2FYgltCNJGWVA+G0ozKJV6XJuOqJTMNZ6imq
	5vAjXHkvJnIWkJKQBz+vXe9OZNla1Cl1LEyOMpW5kYoq6rOj9y5fpUjOHlFkHXKLXcX0nbZW6jw
	yiJlicgrbyAv7VW+jA1I1IOWItY8OGqXYpKIToJmomXq6H9QvtCHHU60h2T43pXaYAydFqex3Fk
	bt7YxSOjQkSZk2QL6iEEmZdWi1wICWeMX67m4qtVMCElg9ft9TZbXR4Z/kIKFFNWCKhpcXZrlsM
	WtFEASmRLDoyVcsUwgLeCSSqt/WEyZBtc+OSzs0=
X-Received: by 2002:a05:6512:2391:b0:59e:1846:1d83 with SMTP id
 2adb3069b0e04-59e45159f85mr5082195e87.28.1770754431824; Tue, 10 Feb 2026
 12:13:51 -0800 (PST)
MIME-Version: 1.0
References: <20260209190605.1564597-1-avagin@google.com> <20260209190605.1564597-3-avagin@google.com>
In-Reply-To: <20260209190605.1564597-3-avagin@google.com>
From: Alexander Mikhalitsyn <alexander@mihalicyn.com>
Date: Tue, 10 Feb 2026 21:13:39 +0100
X-Gm-Features: AZwV_QhjVYT6qDnfaDJCVklCsmeouFRZOW5DUXZzIAeF4nFNqiJH8NjGgTgoV-0
Message-ID: <CAJqdLrogefL5ZkxJfbQ75u45BFFJxttJd1V4yf=KUPxdHg7ocg@mail.gmail.com>
Subject: Re: [PATCH 2/4] exec: inherit HWCAPs from the parent process
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
X-Rspamd-Queue-Id: 163FB1C0013
X-Stat-Signature: gbgdfncsoth4sbgf144fzb75i8774y7h
X-HE-Tag: 1770754433-736507
X-HE-Meta: U2FsdGVkX1+42o/2/8i725F5wg9sj/FROqWCm0tU24h+Tkuco2zxGqOASpMef87+YWXNmajq4f0/lWAPLSnD8ihUmkBJBNMf/e4lC4Yx2whASLd40yfG/3O8m3+FhIlKf+FpRWxwkRdg6KO9gJ6DyVsDj/gA/qnZwdMOxBfqVNNC/Dkof7Cvxmx94wU8TEJUS+D6ctKzAzO3hesXAx2mEXgNYCQw5Sp4TpYNmMLouZVE6nhSkWvbGdE04byrphWkQY4UxLcQzWqgT5u97ld78UHayLlyK5bmpqCzfohkPFopPTHcyyopyknWukvlSAGq6VCeClIjd22xTKJhDlcUxCmV2Y3+MGpCGgt1ZtBq+EWGxvSrVQXOSSDHsa7O911VZvJYWUeLjNdXtJSqzzgMMwsf9aSduXnQB985r6dnp85Nd2osR00k27IooRol3ofpd8HUPxxsGHXqzDPYVUfILZMbANIeKtt+AjGTXZq+X3i+HQ1VSPQTTBCs6rdmVZQnpCkZKFvagPSVFHCZTcTKcyOYMWycLxuiWtN+4/wkGNRwVG98jC/1NU+SQZLB9uPPUN+FhPKz1SQfvBVzn30jKO3C4Mbf9Ma2SDDQa2uv/fDnBO6uj8fZn/xuNTkf33UFJ4JP//D3v2stDDZIKfUtbcRKyiHysCHApFPaLBEEQ4wUGu1iVD0EAuaQErjBAwVax0jbjJCD9tWkkMWcvqnHWi+E7TyNQN5CzV/UvnMgN2woeIMbb7c5qz89tOlpPOp0W1/aLo4+moYrak7LjgAXxscmzQmnBtW0vATnQIjN8OiMFWk1ok4gOAd70PUCB1liPlxUPgH6XO1V49IsHiW6/pF+USRjJFozisRuu/oQd6xUR1fkSUfu/6FAL9T7zw2rUlJXkubi0E5pYX8vEuDj2E1VnCC9ywujn44bXmY+j21thH6yv3EXA3yddFMQJOerxqLY2fXByrrdEUuurvF
 Nw4QxY5s
 JH5HUw5IHZJTERQr0vEnz3Nlap7BzqNX51IuScMRk0CWIsX1XYP66hqiahGKbpQmdi3m9qk1uucNa4GKdjI6mxh7JktG8GeBP9hQofcgE82JmT7+A7gpknMkSwQ47DuVOf3kaBkAnfba3qsm1MWZLTofqy3xYwnjpQvEU2VHubDgX4HAVrDzAbHFNWN4Asi+zO5O3IdLhyPD9Dll8wdRY1XieEXgqBeiCk5HUXD/I1yb2oArf8y8eme9NM9TYViyzHQJD+D9W0KQe5R9Pxx19iKs7kmBDGUi2J6Ba2fo4JpB3ngQJHvVdJhg0pfCMfVgew8qE+XS4ytrvnO9BIbl0XIR9csaOv4MMU2B1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Am Mo., 9. Feb. 2026 um 20:06 Uhr schrieb Andrei Vagin <avagin@google.com>:
>
> Introduces a mechanism to inherit hardware capabilities (AT_HWCAP,
> AT_HWCAP2, etc.) from a parent process when they have been modified via
> prctl.
>
> To support C/R operations (snapshots, live migration) in heterogeneous
> clusters, we must ensure that processes utilize CPU features available
> on all potential target nodes. To solve this, we need to advertise a
> common feature set across the cluster.
>
> This patch adds a new mm flag MMF_USER_HWCAP, which is set when the
> auxiliary vector is modified via prctl(PR_SET_MM, PR_SET_MM_AUXV).  When
> execve() is called, if the current process has MMF_USER_HWCAP set, the
> HWCAP values are extracted from the current auxiliary vector and stored
> in the linux_binprm structure. These values are then used to populate
> the auxiliary vector of the new process, effectively inheriting the
> hardware capabilities.
>
> The inherited HWCAPs are masked with the hardware capabilities supported
> by the current kernel to ensure that we don't report more features than
> actually supported. This is important to avoid unexpected behavior,
> especially for processes with additional privileges.
>
> Signed-off-by: Andrei Vagin <avagin@google.com>

Cool stuff, LGTM!

Reviewed-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@futurfusion.io>

> ---
>  fs/binfmt_elf.c          |  8 +++---
>  fs/binfmt_elf_fdpic.c    |  8 +++---
>  fs/exec.c                | 61 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/binfmts.h  | 11 ++++++++
>  include/linux/mm_types.h |  2 ++
>  kernel/fork.c            |  3 ++
>  kernel/sys.c             |  5 +++-
>  7 files changed, 89 insertions(+), 9 deletions(-)
>
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index 3eb734c192e9..aec129e33f0b 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -246,7 +246,7 @@ create_elf_tables(struct linux_binprm *bprm, const struct elfhdr *exec,
>          */
>         ARCH_DLINFO;
>  #endif
> -       NEW_AUX_ENT(AT_HWCAP, ELF_HWCAP);
> +       NEW_AUX_ENT(AT_HWCAP, bprm->hwcap);
>         NEW_AUX_ENT(AT_PAGESZ, ELF_EXEC_PAGESIZE);
>         NEW_AUX_ENT(AT_CLKTCK, CLOCKS_PER_SEC);
>         NEW_AUX_ENT(AT_PHDR, phdr_addr);
> @@ -264,13 +264,13 @@ create_elf_tables(struct linux_binprm *bprm, const struct elfhdr *exec,
>         NEW_AUX_ENT(AT_SECURE, bprm->secureexec);
>         NEW_AUX_ENT(AT_RANDOM, (elf_addr_t)(unsigned long)u_rand_bytes);
>  #ifdef ELF_HWCAP2
> -       NEW_AUX_ENT(AT_HWCAP2, ELF_HWCAP2);
> +       NEW_AUX_ENT(AT_HWCAP2, bprm->hwcap2);
>  #endif
>  #ifdef ELF_HWCAP3
> -       NEW_AUX_ENT(AT_HWCAP3, ELF_HWCAP3);
> +       NEW_AUX_ENT(AT_HWCAP3, bprm->hwcap3);
>  #endif
>  #ifdef ELF_HWCAP4
> -       NEW_AUX_ENT(AT_HWCAP4, ELF_HWCAP4);
> +       NEW_AUX_ENT(AT_HWCAP4, bprm->hwcap4);
>  #endif
>         NEW_AUX_ENT(AT_EXECFN, bprm->exec);
>         if (k_platform) {
> diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
> index a3d4e6973b29..55b482f03c82 100644
> --- a/fs/binfmt_elf_fdpic.c
> +++ b/fs/binfmt_elf_fdpic.c
> @@ -629,15 +629,15 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
>          */
>         ARCH_DLINFO;
>  #endif
> -       NEW_AUX_ENT(AT_HWCAP,   ELF_HWCAP);
> +       NEW_AUX_ENT(AT_HWCAP,   bprm->hwcap);
>  #ifdef ELF_HWCAP2
> -       NEW_AUX_ENT(AT_HWCAP2,  ELF_HWCAP2);
> +       NEW_AUX_ENT(AT_HWCAP2,  bprm->hwcap2);
>  #endif
>  #ifdef ELF_HWCAP3
> -       NEW_AUX_ENT(AT_HWCAP3,  ELF_HWCAP3);
> +       NEW_AUX_ENT(AT_HWCAP3,  bprm->hwcap3);
>  #endif
>  #ifdef ELF_HWCAP4
> -       NEW_AUX_ENT(AT_HWCAP4,  ELF_HWCAP4);
> +       NEW_AUX_ENT(AT_HWCAP4,  bprm->hwcap4);
>  #endif
>         NEW_AUX_ENT(AT_PAGESZ,  PAGE_SIZE);
>         NEW_AUX_ENT(AT_CLKTCK,  CLOCKS_PER_SEC);
> diff --git a/fs/exec.c b/fs/exec.c
> index 9d5ebc9d15b0..7401efbe4ba0 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1462,6 +1462,17 @@ static struct linux_binprm *alloc_bprm(int fd, struct filename *filename, int fl
>          */
>         bprm->is_check = !!(flags & AT_EXECVE_CHECK);
>
> +       bprm->hwcap = ELF_HWCAP;
> +#ifdef ELF_HWCAP2
> +       bprm->hwcap2 = ELF_HWCAP2;
> +#endif
> +#ifdef ELF_HWCAP3
> +       bprm->hwcap3 = ELF_HWCAP3;
> +#endif
> +#ifdef ELF_HWCAP4
> +       bprm->hwcap4 = ELF_HWCAP4;
> +#endif
> +
>         retval = bprm_mm_init(bprm);
>         if (!retval)
>                 return bprm;
> @@ -1780,6 +1791,53 @@ static int bprm_execve(struct linux_binprm *bprm)
>         return retval;
>  }
>
> +static void inherit_hwcap(struct linux_binprm *bprm)
> +{
> +       int i, n;
> +
> +#ifdef ELF_HWCAP4
> +       n = 4;
> +#elif defined(ELF_HWCAP3)
> +       n = 3;
> +#elif defined(ELF_HWCAP2)
> +       n = 2;
> +#else
> +       n = 1;
> +#endif
> +
> +       for (i = 0; n && i < AT_VECTOR_SIZE; i += 2) {
> +               long val = current->mm->saved_auxv[i + 1];
> +
> +               switch (current->mm->saved_auxv[i]) {
> +               case AT_NULL:
> +                       goto done;
> +               case AT_HWCAP:
> +                       bprm->hwcap = val & ELF_HWCAP;
> +                       break;
> +#ifdef ELF_HWCAP2
> +               case AT_HWCAP2:
> +                       bprm->hwcap2 = val & ELF_HWCAP2;
> +                       break;
> +#endif
> +#ifdef ELF_HWCAP3
> +               case AT_HWCAP3:
> +                       bprm->hwcap3 = val & ELF_HWCAP3;
> +                       break;
> +#endif
> +#ifdef ELF_HWCAP4
> +               case AT_HWCAP4:
> +                       bprm->hwcap4 = val & ELF_HWCAP4;
> +                       break;
> +#endif
> +               default:
> +                       continue;
> +               }
> +               n--;
> +       }
> +done:
> +       mm_flags_set(MMF_USER_HWCAP, bprm->mm);
> +}
> +
>  static int do_execveat_common(int fd, struct filename *filename,
>                               struct user_arg_ptr argv,
>                               struct user_arg_ptr envp,
> @@ -1856,6 +1914,9 @@ static int do_execveat_common(int fd, struct filename *filename,
>                              current->comm, bprm->filename);
>         }
>
> +       if (mm_flags_test(MMF_USER_HWCAP, current->mm))
> +               inherit_hwcap(bprm);
> +
>         retval = bprm_execve(bprm);
>  out_free:
>         free_bprm(bprm);
> diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
> index 65abd5ab8836..94a3dcf9b1d2 100644
> --- a/include/linux/binfmts.h
> +++ b/include/linux/binfmts.h
> @@ -2,6 +2,7 @@
>  #ifndef _LINUX_BINFMTS_H
>  #define _LINUX_BINFMTS_H
>
> +#include <linux/elf.h>
>  #include <linux/sched.h>
>  #include <linux/unistd.h>
>  #include <asm/exec.h>
> @@ -67,6 +68,16 @@ struct linux_binprm {
>         unsigned long exec;
>
>         struct rlimit rlim_stack; /* Saved RLIMIT_STACK used during exec. */
> +       unsigned long hwcap;
> +#ifdef ELF_HWCAP2
> +       unsigned long hwcap2;
> +#endif
> +#ifdef ELF_HWCAP3
> +       unsigned long hwcap3;
> +#endif
> +#ifdef ELF_HWCAP4
> +       unsigned long hwcap4;
> +#endif
>
>         char buf[BINPRM_BUF_SIZE];
>  } __randomize_layout;
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 78950eb8926d..68c9131dceee 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -1871,6 +1871,8 @@ enum {
>  #define MMF_TOPDOWN            31      /* mm searches top down by default */
>  #define MMF_TOPDOWN_MASK       BIT(MMF_TOPDOWN)
>
> +#define MMF_USER_HWCAP         32      /* user-defined HWCAPs */
> +
>  #define MMF_INIT_LEGACY_MASK   (MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
>                                  MMF_DISABLE_THP_MASK | MMF_HAS_MDWE_MASK |\
>                                  MMF_VM_MERGE_ANY_MASK | MMF_TOPDOWN_MASK)
> diff --git a/kernel/fork.c b/kernel/fork.c
> index b1f3915d5f8e..0091315643de 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1103,6 +1103,9 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
>
>                 __mm_flags_overwrite_word(mm, mmf_init_legacy_flags(flags));
>                 mm->def_flags = current->mm->def_flags & VM_INIT_DEF_MASK;
> +
> +               if (mm_flags_test(MMF_USER_HWCAP, current->mm))
> +                       mm_flags_set(MMF_USER_HWCAP, mm);
>         } else {
>                 __mm_flags_overwrite_word(mm, default_dump_filter);
>                 mm->def_flags = 0;
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 8d199cf457ae..6fbd7be21a5f 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -2157,8 +2157,10 @@ static int prctl_set_mm_map(int opt, const void __user *addr, unsigned long data
>          * not introduce additional locks here making the kernel
>          * more complex.
>          */
> -       if (prctl_map.auxv_size)
> +       if (prctl_map.auxv_size) {
>                 memcpy(mm->saved_auxv, user_auxv, sizeof(user_auxv));
> +               mm_flags_set(MMF_USER_HWCAP, current->mm);
> +       }
>
>         mmap_read_unlock(mm);
>         return 0;
> @@ -2190,6 +2192,7 @@ static int prctl_set_auxv(struct mm_struct *mm, unsigned long addr,
>
>         task_lock(current);
>         memcpy(mm->saved_auxv, user_auxv, len);
> +       mm_flags_set(MMF_USER_HWCAP, current->mm);

nit: s/current->mm/mm/

There is no issue, because this function assumes mm == current->mm implicitly.

Maybe we should get rid of (struct mm_struct *mm) argument here? (not
a suggestion for change
of this patch, but just mentioning it here).

LGTM!

>         task_unlock(current);
>
>         return 0;
> --
> 2.53.0.239.g8d8fc8a987-goog
>

