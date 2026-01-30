Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E00CD73EAF
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 01:16:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CC966B0005; Thu, 29 Jan 2026 20:16:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A3FF6B0089; Thu, 29 Jan 2026 20:16:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ADCC6B008A; Thu, 29 Jan 2026 20:16:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7686E6B0005
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 20:16:36 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 25F4A1BEA2
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 01:16:36 +0000 (UTC)
X-FDA: 84386865192.01.77741A9
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1D5A3C0005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 01:16:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qocRzWV2;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf10.hostedemail.com: domain of wusamuel@google.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=wusamuel@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769735794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TDFRbEmoo50qM27MYVAAAo2rNiUVkc6+HtDETmMWn38=;
	b=1WtxCZOZ1iF+pV7MvJs+0iMAgkJyepCGZaI4L5/R4P3ZXhygGuZEu2ZZ0NH31FYYF8yZVk
	LWT+/X0dx+o7w/y/R8OOtCHCIvmE6Y0Zk6dj4Rf3c1yABva8sT2sqWeM1tDvJ8/M/KIspQ
	UD88EMxEevPxS0CMzFw14nF0L4cJKOs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769735794; a=rsa-sha256;
	cv=pass;
	b=4Y5nvmhRFAbWV93PtpEyzu8PLg9r6FZx4jJK7AGX6dpG/KqmHXe9eCA4vSX1n7sA5f2o6m
	9cPcXV58ouObMmZf1/bJ+xjl6mxn6MKn+zyeYS/0ZziTolN1uu+49da/hIx8awGPkX6PDe
	YMk4NX5RjdR4yDoEANgAxnqOR/DNEMI=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qocRzWV2;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf10.hostedemail.com: domain of wusamuel@google.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=wusamuel@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-65807298140so2629408a12.2
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 17:16:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769735792; cv=none;
        d=google.com; s=arc-20240605;
        b=M5tQlsxnZwn13EzTICu1AqSAlXR9xP3LoVKG2nlG4FrL8WeKWuceQvGBBcQRILiSYN
         6gQEe8JkI9Wh8/imkxGnP1cW/3nCFPxU1iyuFTIezaVXrUvVJzlc5ZFXSk7fgpEbs01/
         y4XvzP6+KRGSxD4Q61w8NTdpI8tFQO6pJ6QpigaFkOl8KCBID4bQDOfd1c1TWGsusANy
         wJ+IJFqqzNcBRveb1+HHfLPJ4oMieSnr6ZwbSdvqjNMQ/sFwcRn9gMVmK3+TA9ru6Tn0
         a3eZOUxdMTVPeigP0GeX8au7OwksKQ83rTGunYKqZ3hM0PZ7BU3wxs14CmswyviLh4Tl
         RRfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TDFRbEmoo50qM27MYVAAAo2rNiUVkc6+HtDETmMWn38=;
        fh=T3PU89eWyVlKXH9+cT8UNrIrxqXkmXGp1eJqc+KiPCs=;
        b=DDBqSN+6vUaIiu9UCIieZDUznahUU8B1ilE1Q06Ki9VmhoS2aUtYOBjvzVJb9PKBUH
         cUtdlZjbSr3FtL7/s1l4bPkqW7EP6W4C/fxfK0xdpn2q9Pd1FZz8Eun6HZTrEuKyGdgb
         0NuWpL+79mLTIb97Eq2bcjbWNLn4/DNC17+KmkYcXuTF4ySZHsrZ89UsfCU3nW6+P7FP
         u7UfxPXPaG+kXGP269EnofCKe3/UMka06BXXMYHDnFG7S8UQWMvgjNb7ROCcFTNZSnhm
         02Prun1lIDCukK6OhvU7yOkUwZeVXvt+95eMcLbMwaVPYy6ikAjFXOdScSvh6zta1hgi
         2/oA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769735792; x=1770340592; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TDFRbEmoo50qM27MYVAAAo2rNiUVkc6+HtDETmMWn38=;
        b=qocRzWV2pNuCXUQvNzkhkVgVq1VTwT51mb4RTPZM+Ub+aPvEjMfma4YasbAwW8LCsh
         U9WMPfS1cS9T2xboFrWjl6/hOfCipqs6+Of3TW9K/b+hFJN1/Gz3/IEuFoq5ZqAhHbxI
         aY//HzLiA5joO+j/4XznyCA/gbupy9pQJTt4BAzxCFyCKOfcfRxbPX8NGH/l3Tt0r3vj
         yNoIIMNT6/nJ/aCgVognkstUHk4FWN0KXc2ZVyObsMoM3t0IGNuotd2Kto/PnDdrUHli
         V6SDqM+4X7KmLaEggRJZOsHR11vp9rDuTkRMF6WbeGmyXQtxekYg5ZJbR5azzNkd2I45
         Xn5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769735792; x=1770340592;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TDFRbEmoo50qM27MYVAAAo2rNiUVkc6+HtDETmMWn38=;
        b=iOw2SeH0FhPa820VZqvkK/+jgaMcPr+DyjfIEwU3YP+9IFhR4hq7Gli+sNaKaE6Rrg
         ih8pADfFUccZ+NogU7rka4RoZLRWoAdljHTG+yTG6V0dJtXe+95xXiSVFd9nmJink58b
         Gt5xy9TALqfnm/ftQ4jff2G+PSmHNUFN9PhVR5v3iq6JItfmfWfFgUYAwBBxAyWkPDAw
         Lxmlrr+S+WD+tARhHclsm2tRcKeB4AtDHsyeCa3gA9mhF+442nufYz3PSxGE9TEcxZSX
         3ZusxJf5jVAq4Mi4ROdMj4huOB22hQFslGztMxLFMMhKSY8pAl8f7VtCk5cTk4MAIeUA
         TBoQ==
X-Forwarded-Encrypted: i=1; AJvYcCUuMI9zUJV5zyieEX/RI8E8SricuTCDiTN3AM5KXeoQGNsrNS54tAsl9ApxJBbYaHFNMTyEgeS1rA==@kvack.org
X-Gm-Message-State: AOJu0Yzzm27qxZmixlB1PEDd4U4VZ9Vo43sou0xvclhm19vLXKdByLIC
	JwCwgdMgB2q39QiZe8ZGrFt2sntOfw4Ts0pXEaZbiqJqiCEqqggJFcggFtbeUdTRtntEbkA3+5D
	Ni+iKBBKgBi17OIOBOnPWRt3JYpwW6F/HgBDvu9X4
X-Gm-Gg: AZuq6aLFjhof+0xlIpKi9k2Ypjco0ERCPhCk/pmWtCmK6pWJ0jeITcvq1n1MizQ56tQ
	xoYxxyunppOZocZG14EVEuLDcHAlioZzhy2UpAkA2SP7F2+Qtz6vsa/2/rUPrXz0LAurFnElhsz
	/SYJiZJer/tMPPm5K2HkiAoNRmcDGrrx7r3/CHDETf9ajm1mSy/wnR1BFPd5xklE4E5oT0/8t2d
	QYwHL0jZFGPI9bK8tY3pzq+f+Yqh/jkGWPqfZf7TCbJhUfeOGeHoi/1lX1UoTJcrQU34ld9k2YI
	OIPieBeYMaGBN9e60VL7oQcM9O9sMQ==
X-Received: by 2002:a17:906:eecb:b0:b88:31f9:1d9a with SMTP id
 a640c23a62f3a-b8dff71fbbcmr62042966b.62.1769735792220; Thu, 29 Jan 2026
 17:16:32 -0800 (PST)
MIME-Version: 1.0
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
 <CAG2KctrjSP+XyBiOB7hGA2DWtdpg3diRHpQLKGsVYxExuTZazA@mail.gmail.com>
 <2026012715-mantra-pope-9431@gregkh> <CAG2Kctoo=xiVdhRZnLaoePuu2cuQXMCdj2q6L-iTnb8K1RMHkw@mail.gmail.com>
 <20260128045954.GS3183987@ZenIV> <CAG2KctqWy-gnB4o6FAv3kv6+P2YwqeWMBu7bmHZ=Acq+4vVZ3g@mail.gmail.com>
 <20260129032335.GT3183987@ZenIV> <20260129225433.GU3183987@ZenIV>
In-Reply-To: <20260129225433.GU3183987@ZenIV>
From: Samuel Wu <wusamuel@google.com>
Date: Thu, 29 Jan 2026 17:16:20 -0800
X-Gm-Features: AZwV_Qio50GdQN1165WVg9oPRvbdMSYV2LeALjhPJoJWlsc8zYrp7Hv8KsFMrXk
Message-ID: <CAG2KctoNjktJTQqBb7nGeazXe=ncpwjsc+Lm+JotcpaO3Sf9gw@mail.gmail.com>
Subject: Re: [PATCH v4 00/54] tree-in-dcache stuff
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-fsdevel@vger.kernel.org, 
	torvalds@linux-foundation.org, brauner@kernel.org, jack@suse.cz, 
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org, 
	linux-mm@kvack.org, linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	kees@kernel.org, rostedt@goodmis.org, linux-usb@vger.kernel.org, 
	paul@paul-moore.com, casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org, 
	john.johansen@canonical.com, selinux@vger.kernel.org, 
	borntraeger@linux.ibm.com, bpf@vger.kernel.org, clm@meta.com, 
	android-kernel-team <android-kernel-team@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1D5A3C0005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 955tprndgjtt9tp9wxkg3sejctrie8ua
X-HE-Tag: 1769735793-784029
X-HE-Meta: U2FsdGVkX1+KeQ7sqtyMZXTm0isMh31HUZpYFhZGLXNMdgI73kf518uf8n/toUm4bwSRNs4V5d85vGm0OPPAe+VvnJY8R4n7jWZaWVYkfwj5g8IqkyvOobRHz/g4LCrYxp+mtH8hBFKbDzkffDdlrCTUcPADiAbXbTa+pvcQH2DHioaPj7FGDxYEAtOjsTYefO48t228hjpo07dtabuXq9HVtde5kOu+4uSOmCduGbXe3yIm3WWLeSXfPYW211kQ5f85aIpWDA6ku5Rf2fTyFc82ZcT+j86trE5MYt9U3x3f6kIRbpjAs4WNa8v7tyVfucu5tu+YNDeUP7vXwE8ToMdsySvV+uxiYPZuGwyohPDnYGynjTDucdLeSfS8lrzLyCN7gcFW+04T+uehMjt9moRFkNCPtTlZ/+XFgatW6LFR7tLhKkqxsmkPPXNKXyr123MVDzLLr2/hHaed6yUZeW9wjKFmKBys2BAh5JY3X++shU9lX55/UomLaR1TFW/L3Yz6B3n4YuNT2cMiDBSac6VgrzGYiNRKadM5bHTDLrw8/4EnZCC9dzKbbYDwe3eEvRoPdsifjl19iF0WU12hKQfdbq/EI6qP90uRefHnb5PeICIadd3o5oAM72SrQXJW6PBmkjOy2RIn5iH75Dof3lKUumjUWit/c6OKMQk7asueD3ZhFUk+mIK1/xaHfC5rXdFjFm7m2zwVwidVeQ1KXT2/7BDktCmXQDmgeGbq1gP5S11upY/xfQRgp3/CFAWe/s+E9ybGpSM6Br26UtkZnXcc4NvkPX/c+L3jxfiejKcHJMvEnPbVQwdGCN3qDPGT57LUv+c+IeWV8SddG6FqpxOCmuT8dL2ZD+Tn8wmLSjPUD5GofS+SjxJnZom6qYY366/o+l0/dCB40QRgazN1ADCjIulML9bmFZcvySuZyqo09h1ejynYt/kn4Or0vARKvF9JrXbmsd/XvK2MKdg
 7IxQmjg8
 fST0NO0UyTRZqQHWwlCK+8YXQOBozq8qMH3HtwirFYGN/a/2p2YoSnpx4WM1p76e29XvA94qUXGRdRebWqP4XJ+ebm/sS30SL2s/uONKVaSgncHCAR3MDq6jzFd6piPPa4z6rvJIiJnxqzE07gSNf7lOURgsujvmYLT9/eC8p9hEB2/dVeUK/szkDDWG7In/ROJD4YQSEAuRZ31h59YTdusH5Erx3Sg9glRWhu/sIBPaKxgEQ19UiUMa8f8qHP/9CfYCkQRBu+nlimDUt5SkZBsgc20ztmWRsuaCl3wc/QPV2k8nLpHyxzNd8OD9UEz0yykqxh1g5X4IHe3DmEg3NUfSYaB4pHszqLHqmGSWLuMP72Vb05Z2dxZ5xaE6rR2Ek1Bdf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 2:52=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> w=
rote:

> > Sorry, I hadn't been clear enough: if you do
> > git switch --detach 1544775687f0
> > and build the resulting tree, does the breakage reproduce?  What I want
> > to do is to split e5bf5ee26663 into smaller steps and see which one
> > introduces the breakage, but the starting point would be verify that
> > there's no breakage prior to that.

Ultimately, same conclusion as before: 6.18-rc5 with patches up to
1544775687f0 works, but adding e5bf5ee26663 breaks it.

> > PS: v6.19-rc7 contains fc45aee66223 ("get rid of kill_litter_super()"),
> > and reverting 6ca67378d0e7 ("convert functionfs") would reintroduce
> > the call of that function in ffs_fs_kill_sb(), so the resulting tree
> > won't even build on any configs with functionfs enabledd; are you sure
> > that you'd been testing v6.19-rc7 + reverts of just these 3 commits?

I also could have been more clear- I had to
s/kill_anon_super/kill_litter_super/ as part of the revert of
6ca67378d0e7 to properly build. That felt like an appropriate change,
but if not, adding patches on top of 6.18-rc5 is perfectly fine for
testing this.

> Could you try your reproducer on mainline with the following delta applie=
d?
>
> diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/func=
tion/f_fs.c
> index 05c6750702b6..6c6d55ba0749 100644
> --- a/drivers/usb/gadget/function/f_fs.c
> +++ b/drivers/usb/gadget/function/f_fs.c
> @@ -646,12 +646,11 @@ static int ffs_ep0_open(struct inode *inode, struct=
 file *file)
>         if (ret < 0)
>                 return ret;
>
> -       ffs_data_opened(ffs);
>         if (ffs->state =3D=3D FFS_CLOSING) {
> -               ffs_data_closed(ffs);
>                 mutex_unlock(&ffs->mutex);
>                 return -EBUSY;
>         }
> +       ffs_data_opened(ffs);
>         mutex_unlock(&ffs->mutex);
>         file->private_data =3D ffs;
>

This didn't work on either build variant (6.18-rc5 and 6.19-rc7).

I'm exploring a few other paths, but not having USB access makes
traditional tools a bit difficult. One thing I'm rechecking and is
worth mentioning is the lockdep below: it's been present for quite
some time now, but I'm not sure if it would have some undesired
interaction with your patch.

[ BUG: Invalid wait context ]
6.18.0-rc5-mainline-maybe-dirty-4k
-----------------------------
irq/360-dwc3/352 is trying to lock:
ffffff800792deb8 (&psy->extensions_sem){.+.+}-{3:3}, at:
__power_supply_set_property+0x40/0x180
other info that might help us debug this:
context-{4:4}
1 lock held by irq/360-dwc3/352:
 #0: ffffff8017bb98f0 (&gi->spinlock){....}-{2:2}, at:
configfs_composite_suspend+0x28/0x68
Call trace:
 show_stack+0x18/0x28 (C)
 __dump_stack+0x28/0x3c
 dump_stack_lvl+0xac/0xf0
 dump_stack+0x18/0x3c
 __lock_acquire+0x794/0x2bec
 lock_acquire+0x148/0x2cc
 down_read+0x3c/0x194
 __power_supply_set_property+0x40/0x180
 power_supply_set_property+0x14/0x20
 dwc3_gadget_vbus_draw+0x8c/0xcc
 usb_gadget_vbus_draw+0x48/0x130
 composite_suspend+0xcc/0xe4
 configfs_composite_suspend+0x44/0x68
 dwc3_thread_interrupt+0x8f8/0xc88
 irq_thread_fn+0x48/0xa8
 irq_thread+0x150/0x31c
 kthread+0x150/0x280
 ret_from_fork+0x10/0x20

