Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 778BFC5DF8C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 19:51:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7744B6B009D; Fri, 21 Aug 2026 15:51:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74C996B00A0; Fri, 21 Aug 2026 15:51:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63B686B00A1; Fri, 21 Aug 2026 15:51:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 38C116B009D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:51:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D733F1C0E08
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:51:36 +0000 (UTC)
X-FDA: 85126321392.13.25E93C9
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf11.hostedemail.com (Postfix) with ESMTP id E52D140007
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:51:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TutM8lRX;
	spf=pass (imf11.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787341894;
	b=hnEDLSV0RJmBN9L0/R5D5b1kPdiZ0yu7hGUAqB+FFmCRADUOiA97OC9Epdui8HKTKLihdw
	U6mIIgPQDNC6YhdP5eQQL57hQBe/jz4QwEWclW+WEbOQHoBeNTtfuGtSIjwzFaDHfut7z5
	lH+TsH75MYCC3hRAhO4VXFo4ztExcjI=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TutM8lRX;
	spf=pass (imf11.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787341894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SzKLdRzgtAdfhltrrDFuuJzcJUuv3uu5ISrFgqsjcpk=;
	b=2oOz+BeTcStO63wLcfOtspJ8OPX5ut8wGHBn1bsY3NdYq5mSwp8AAS9B2ryjjw0BvSzsgB
	HHpfyevItzlsAo5wKksOPfxozLRsgD53+ROkKETRispRuH9PNYoTWaThHg+vKnWuhFY5ZP
	59+Az0D5TeqrqE8laL0QIxDZyZsLD0U=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8486672f03cso1408727b3a.0
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 12:51:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787341894; cv=none;
        d=google.com; s=arc-20260327;
        b=j1KS8BDz3oTlkspHrIq3tTdIRd/Vu/q0492UtSIE7bA1pyBLbrUsqDg3KJpGv0ToRC
         ky+QCSbzHXvkJzQgYxjDIIqX2AMwdTSJTZq9w0Nk2VWKH8a54DiSyWxjEoCvEiEj9SHv
         LtaAtV/o3E+GkivOvJyBUCRHXoubVLMZ4MACErugX3NEsmGF/mX9wHNpjgwH05kYCst1
         5EKZSgOJ2Phf96XZwecfxepdK3ajRGWsghNAjijpDLKhQ07QFtCSGYnDuhS9utIsIi+o
         WtzPYx/FuoEQHVHUObd1iXZMiFgScI3H/6d5D99CbSB7UYxMrWBG4nPVitbP2JEZX5uG
         WP1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SzKLdRzgtAdfhltrrDFuuJzcJUuv3uu5ISrFgqsjcpk=;
        fh=UadQm4c2yJfjeZW/yqnUFM8+PJTWfmcIc5NxzNCA1VU=;
        b=BVz37b5tgdg7C9gg/4au7ipgwMKzooShZZgdGhJveWFTuoXbL6iYhPBMMvr2zQYHAw
         MoKBKh+hlHX6md0KNfcnhgVLEc54JXPKp7YSU+qAxnlYIjNJWiRhJ/Au0JiIbXxmCCC5
         hnpeairGRpMQYwFrfd+D8DiwxZTlFFlLTRA9zbuPmZXRnGteNCvTId6YqU2QzvnuUQMD
         xGZIRmdTMkyxjyqbrgfWhgAuojk0n5SD7AJaGdIR7PlaMWKyR8QYRSmjua4J1h0aCoVt
         4+TfdSNNR7wvPjJVXWxDaRB8UcotLbK7BMUChBuRDRQScyHW+lrG5U+3o8d2VZyrlWF+
         CpEw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787341894; x=1787946694; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SzKLdRzgtAdfhltrrDFuuJzcJUuv3uu5ISrFgqsjcpk=;
        b=TutM8lRXury0VVxU376iH/dlE0SnFHdywmEohZ4DGWc9Z62Z6Q7CBt55f89KFkEZBz
         MWDQpILr7mbLbg0YtmVRbMgx0LMJbn3WpE0iDwgakXofbuun4aRDq1RznOsFv0MlGol1
         8RoN5u5vasJmj2H1g1Fm7hhKZsuILuCdLm6NVeGvdEyXaWCgoNgP6lMyiVDeGVCvhRPH
         8rIGcdFYhnTyL6Tm6wJOXHrojFOoCfsHOAY4aJxAQhz+u9nLuHsrXTl7sh1C7pm3yE0k
         55qNvH3nmmL183W1jRTdJWGj1JmWgqamkeoex73M++dknliHFK1nyYmRxHiVjbfP9tgZ
         aY8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787341894; x=1787946694;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SzKLdRzgtAdfhltrrDFuuJzcJUuv3uu5ISrFgqsjcpk=;
        b=O/DpluUw4kA6Dd3E+ANKB/UvEDtJ161oaTK10HzGLvjFagJF/jidc/eX0l47cCQ3O7
         p1W3B4XqmnJbE04kBik9ZW/iZjHm//BILBqlnbsN9MYey8wZjysG+ZTtBiv0ZOcB3/Kp
         SERrKrqCjF7oJVLywYF0qWMGZrTxjR+b9ENGIRcCKYyUI4doKjRRGCYOKtOJW7A1aWNn
         1VQ5Qbd0nm2omCfdYrhNAF19lCNj+YFGWejivThdLQVj3J0mMahLam8S2PNwtJG8GtM6
         fZjaQOSdTi0qMzdnKUbUoq2M3TJXfOcxIYPh2LYHgDay5w5O22deFzcqBo05oFnez/Nh
         EQdg==
X-Forwarded-Encrypted: i=1; AHgh+Rq3XHng4hGSCH/3YrnAYA8I/NPaJ/AD/zcaW+jQWviu76LMnVb7+r0W+37qcWhQqKJQUdXL/4UHaA==@kvack.org
X-Gm-Message-State: AFuF++kBQU2jF40NR5jBeaCuxA7J32LtcihDVuLlkzE1h3UiDVHGTCEp
	RTS1ctVXK1aVBURQucYDsf+T7lr4eqiSv2dsKiEo3Twq2hwx5ds7Stsg02fthiaDoaBlnH4cIcm
	QVYdfPxrN3dFeYreHPnZuNQqmkWDvvuw=
X-Gm-Gg: AR+sD12gP9TA0C7gXR1iPgG84RJHclWX9EvyhzpygktlvPgzskaFYp6nmOeMc7cufqq
	hsjZdW3OnTqJB4Wludyja3HmnwmatQYh5YuvPTH+TbG7RU17AeSLB3V+idZLxw6TYwMTQAd0WTN
	OBHArpOwAiFNTwGhe6DCfdL74lL5aL6Lv9niTmAQpRyZgwNuN2c6K5G/9D4KY5f4hks11aoPSQe
	Q5qtcfKpVKigiRrB0pwpd9TruMQlkJvLdVF4RwCbYbJgE4YBNUnwox/2mUToWcG8x6PJzNK1keC
	IcWXNFmuvoEP+m3XWHqhhIF/2Hy++FLEH8JVGAUItYq6/j9Yfjb8qPsFV+c59HEt0Rknk8nQtRf
	l4U2FGFsVIrPk70RRbsi/gqjZtw==
X-Received: by 2002:a05:6a21:a41:b0:3c3:68b0:e273 with SMTP id
 adf61e73a8af0-3cd4bbf659dmr2252454637.15.1787341893121; Fri, 21 Aug 2026
 12:51:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260820131801.68759-1-tasos.papagiannnis@gmail.com> <20260820131801.68759-3-tasos.papagiannnis@gmail.com>
In-Reply-To: <20260820131801.68759-3-tasos.papagiannnis@gmail.com>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Fri, 21 Aug 2026 12:51:21 -0700
X-Gm-Features: AcwNN1XWB_nq5Mq_nLbpufPwO46TiYdXCycQY7yskOQpHdsg462Mk-gXUf3OPbg
Message-ID: <CAEf4BzZTM5SehNnM83U3Kj0cz=NN=JwUtG-pcvSHdvZBsHdM3g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/3] bpf: Add user memory access kfuncs for linux_binprm
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
X-Rspamd-Queue-Id: E52D140007
X-Stat-Signature: wffqbra7jsrjxkcu14r3k1uoaqsxr6pp
X-HE-Tag: 1787341894-369740
X-HE-Meta: U2FsdGVkX18UMT2/i1PEV9qajvJWpdMTpAKcNbBbuN7a5pRU0JlE7fwiapul61uvk+VipdPQjclv5WmfNx0q/n8NfkJ7WF6EcJKTXDMPrsmS1n+T3iMe+hN74qw6xJrtC2j/1ccphhuJ/jqS7XWhR3bsQpXs1STrQWD2/MAaurpoJ+9wCwzgORAVNo7sp/ZtWGD4BZODDV4Rq+cDwdjx4dFwfgyORNP+emRge09aiZ1io2gxbj5cvb3jJgRkVEnSpD56L29VsLJmUqJN1eJAiR+DFLrNQFgzFecCTpmYdGu9iOdaBH22Zx1qm/puFALOVA3SWGTnHJkGp6b3Ba77Rm9+86WcndsuiOb4XOVXIlcIIhdhNsqRBu7tUNRIitn4TXxSFBdfO1V6IQkwklbu1pnwz128WMqLgxhbGUDxvhFHlSu4o0YYYEv5EBlq5Cnvfk4lnDcZa/J/cy3HY55SqeuOdZuGPTTMwTKbV0n00A/6K9nUFKJYV6sWGAjbcv/tzC5qSY/0iYgr20bpCO25LXwtDkNVgs1lXRwAQWuOiYLxeEDmg2BkPQR4HewVSw+uIohcwsrjs5zk3HNBvAZusYo6uKY3vi/EBBwktZWNUWjbjQjOynAyhVN3iMmPArCrWAlj9edUVGCINN2W8hcEmtrxx7B3fyOnQkEjzBOGMHJXH9Mr8xTp33pld0Xl4G7srg2jdA/XXeiehrO7gMSB/ZIff5ke5uYNzSuWz1sqeaoPGCeC7s9enPhbRxQocLAnIugjcS8blFkc2aOHSzkcHcSgKZkBiGttw/CbHm7brIjt162J48O4+2RZf+FfdeD+Y7s2sC5rKA6JDj6LC1D0BmW+KcEgQOdivpzmrcmqn41Y3w7Dkv8s+JTorBGdEUf0I4outggKOWxh8ihnMtaRaMUxMEJ5CdIcdJgcqdHPWo6j60nWi66H/oMCBBBqvBIcGRCVYNNinGeUY99AgaC
 EPGbMWYB
 ykeLHjS+7wcUhmrz/13hGojNaGSzrRChIvJUaHD7dALW9D2gBGTYK/+cC3PNdKTz2CZ0Iw0tkPxuYR0XRnvEFGsc4Kl/ZjOLrmiLfDamJt4N8raaZfXQSKc5WEbt0UNwU9h3Tb3OXgUGVEcbJRiu7y83rzuQ5UMolDYW7pV/usneMS9hubWggx0XLM6ZsuV6GDc+VyZuzXYHm2phiC6ovLNt9+rl4rthNYW+qtNRmWP/T6Ojv1Ro4nKJ/0wSxjeq/SzKAkVoa/+3DHIHQ681ntPm9H2ZFJITD3Qx/2gbj4LqBrdrGoCMyr7iG9lCWyoq3YLhHvzZKSxh9Nnc8RFHqFoiJ1gXho1j02uN3Wu9nr3tg5feHBKukI/q9yXkU+NG8iNop8aSrB1PQ97OReciVGn8epNIUxMh3NJ6AXAkEYXqt0sH9yfQhG3lTttwd5U2pDAqIo0LtCxvuFkmtckpgVYln6lX7j0uMtwFQq8sxgxy0Ep7Jr4uOI31KvMF5/Ep5HmZWmtOUzDmdfAYcvbdHmnoUzlaSQhCQGYbV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 6:18=E2=80=AFAM Anastasios Papagiannis
<tasos.papagiannnis@gmail.com> wrote:
>
> When security_bprm_check runs, the arg and env strings for the exec have
> been copied into bprm->mm. The new address space has not been associated
> yet with a task_struct until exec_mmap(), so existing BPF user memory
> helpers can only read from the calling task's old address space.
>
> This patch adds bpf_copy_from_user_bprm() and
> bpf_copy_from_user_bprm_str() kfuncs. Both use the mm_struct provided by
> struct linux_binprm.
>
> Register these kfuncs on both MMU and NOMMU systems. On NOMMU systems,
> exec arguments are staged in bprm->page[] rather than mapped in bprm->mm,
> so the kfuncs return -EOPNOTSUPP.
>
> bpf_copy_from_user_bprm() has similar semantics as
> bpf_copy_from_user_task(). bpf_copy_from_user_bprm_str() copies one
> NUL-terminated string and returns its size including the NUL terminator.
> It accepts BPF_F_PAD_ZEROS to clear unused destination bytes on success.
>
> This patch registers both kfuncs with KF_SLEEPABLE because accessing the
> remote address space can fault. This allows BPF LSM programs attached to
> security_bprm_check to read arguments beginning at bprm->p and reject an
> exec based on its command-line arguments.
>
> Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
> ---
>  fs/bpf_fs_kfuncs.c | 128 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 128 insertions(+)
>
> diff --git a/fs/bpf_fs_kfuncs.c b/fs/bpf_fs_kfuncs.c
> index f1863a891db6..1cd06f9e4890 100644
> --- a/fs/bpf_fs_kfuncs.c
> +++ b/fs/bpf_fs_kfuncs.c
> @@ -1,6 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /* Copyright (c) 2024 Google LLC. */
>
> +#include <linux/binfmts.h>
>  #include <linux/bpf.h>
>  #include <linux/bpf_lsm.h>
>  #include <linux/btf.h>
> @@ -379,6 +380,131 @@ __bpf_kfunc struct inode *bpf_real_data_inode(struc=
t file *file)
>         return d_real_inode(file_dentry(file));
>  }
>
> +/**
> + * bpf_copy_from_user_bprm - Copy data from a binary parameter address s=
pace
> + * @dst:             Destination address, in kernel space
> + * @dst__sz:         Number of bytes to copy
> + * @unsafe_ptr__ign: Source address in the binary parameter address spac=
e
> + * @bprm:            Binary parameters whose address space will be used
> + * @flags:           Reserved for future use; must be zero
> + *
> + * Copies data from the nascent address space associated with @bprm. Thi=
s is
> + * useful for reading the argument and environment strings before the ne=
w
> + * address space is installed by exec_mmap(). For example, at the
> + * bprm_check_security LSM hook, @bprm->p points at the first argument s=
tring.
> + *
> + * The destination is zeroed if the requested number of bytes cannot be =
copied
> + * in full.
> + *
> + * Return: 0 on success, -EINVAL if @flags is non-zero, -EOPNOTSUPP on
> + * NOMMU systems, or -EFAULT if the copy fails or is partial.
> + */
> +__bpf_kfunc int bpf_copy_from_user_bprm(void *dst, u32 dst__sz,
> +                                       const void __user *unsafe_ptr__ig=
n,
> +                                       const struct linux_binprm *bprm, =
u64 flags)

making this linux_binprm-specific seems short-sighted and overly
specialized, why not pass `const struct mm *` and call new kfuncs
bpf_copy_from_user_mm[_str] ?

and this seems to belong right next to bpf_copy_from_user_task_str()
and others in kernel/bpf/helpers.c (and bpf_copy_from_user_task
variants should just delegate to this mm-based APIs and minimize code
duplication)

pw-bot: cr

> +{
> +#ifdef CONFIG_MMU
> +       struct mm_struct *mm;
> +       int ret;
> +#endif
> +
> +       if (unlikely(flags))
> +               return -EINVAL;
> +
> +       if (unlikely(!dst__sz))
> +               return 0;
> +
> +#ifdef CONFIG_MMU
> +       mm =3D bprm->mm;
> +       if (!mm) {
> +               memset(dst, 0, dst__sz);
> +               return -EFAULT;
> +       }
> +
> +       ret =3D access_remote_vm(mm, (unsigned long)unsafe_ptr__ign,
> +                              dst, dst__sz, 0);
> +       if (ret !=3D dst__sz) {
> +               memset(dst, 0, dst__sz);
> +               return -EFAULT;
> +       }
> +
> +       return 0;
> +#else
> +       memset(dst, 0, dst__sz);
> +       return -EOPNOTSUPP;
> +#endif
> +}
> +
> +/**
> + * bpf_copy_from_user_bprm_str - Copy a string from binary parameter mem=
ory
> + * @dst:             Destination address, in kernel space. This buffer m=
ust be
> + *                   at least @dst__sz bytes long
> + * @dst__sz:         Maximum number of bytes to copy, including the trai=
ling NUL
> + * @unsafe_ptr__ign: Source address in the binary parameter address spac=
e
> + * @bprm:            Binary parameters whose address space will be used
> + * @flags:           The only supported flag is BPF_F_PAD_ZEROS
> + *
> + * Copies a NUL-terminated string from the nascent address space associa=
ted
> + * with @bprm. If the string is too long, @dst is still NUL-terminated u=
nless
> + * @dst__sz is zero.
> + *
> + * If BPF_F_PAD_ZEROS is set, the unused portion of @dst is cleared on s=
uccess
> + * and all of @dst is cleared on failure.
> + *
> + * Return: The number of copied bytes including the NUL terminator on su=
ccess,
> + * or a negative error code on failure. On NOMMU systems, -EOPNOTSUPP is
> + * returned.
> + */
> +__bpf_kfunc int bpf_copy_from_user_bprm_str(void *dst, u32 dst__sz,
> +                                           const void __user *unsafe_ptr=
__ign,
> +                                           const struct linux_binprm *bp=
rm,
> +                                           u64 flags)
> +{
> +#ifdef CONFIG_MMU
> +       struct mm_struct *mm;
> +       int ret;
> +#endif
> +
> +       if (unlikely(flags & ~BPF_F_PAD_ZEROS))
> +               return -EINVAL;
> +
> +       if (unlikely(!dst__sz))
> +               return 0;
> +
> +#ifdef CONFIG_MMU
> +       mm =3D bprm->mm;
> +       if (!mm) {
> +               if (flags & BPF_F_PAD_ZEROS)
> +                       memset(dst, 0, dst__sz);
> +               else
> +                       *(char *)dst =3D '\0';
> +
> +               return -EFAULT;
> +       }
> +
> +       ret =3D copy_remote_mm_str(mm, (unsigned long)unsafe_ptr__ign,
> +                                dst, dst__sz, 0);
> +       if (ret < 0) {
> +               if (flags & BPF_F_PAD_ZEROS)
> +                       memset(dst, 0, dst__sz);
> +
> +               return ret;
> +       }
> +
> +       if (flags & BPF_F_PAD_ZEROS)
> +               memset(dst + ret, 0, dst__sz - ret);
> +
> +       return ret + 1;
> +#else
> +       if (flags & BPF_F_PAD_ZEROS)
> +               memset(dst, 0, dst__sz);
> +       else
> +               *(char *)dst =3D '\0';
> +
> +       return -EOPNOTSUPP;
> +#endif
> +}
> +
>  __bpf_kfunc_end_defs();
>
>  BTF_KFUNCS_START(bpf_fs_kfunc_set_ids)
> @@ -390,6 +516,8 @@ BTF_ID_FLAGS(func, bpf_get_file_xattr, KF_SLEEPABLE)
>  BTF_ID_FLAGS(func, bpf_set_dentry_xattr, KF_SLEEPABLE)
>  BTF_ID_FLAGS(func, bpf_remove_dentry_xattr, KF_SLEEPABLE)
>  BTF_ID_FLAGS(func, bpf_real_data_inode, KF_SLEEPABLE | KF_RET_NULL)
> +BTF_ID_FLAGS(func, bpf_copy_from_user_bprm, KF_SLEEPABLE)
> +BTF_ID_FLAGS(func, bpf_copy_from_user_bprm_str, KF_SLEEPABLE)
>  BTF_KFUNCS_END(bpf_fs_kfunc_set_ids)
>
>  static int bpf_fs_kfuncs_filter(const struct bpf_prog *prog, u32 kfunc_i=
d)
> --
> 2.55.0
>

