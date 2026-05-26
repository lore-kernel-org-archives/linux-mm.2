Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ED6ACD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 08:46:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C27576B0005; Tue, 26 May 2026 04:46:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFECD6B0088; Tue, 26 May 2026 04:46:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B14A86B008A; Tue, 26 May 2026 04:46:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E0636B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 04:46:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4476C1C12A6
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:46:27 +0000 (UTC)
X-FDA: 84808939614.02.995B277
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf05.hostedemail.com (Postfix) with ESMTP id E3379100008
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:46:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b="agd/2G9s";
	spf=pass (imf05.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.160.175 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779785185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Sm7AdbBwz89HswDM1U3a+4O4uaDOPsFPs5dz3aFbf8=;
	b=xEyeeSCi0rdcU1YH2WcEPXNgYX78fUp1RUSBbbwuT3ZZ+gB+Y+0alOZkbygSwLy7EdJX5J
	ph3cotYAvVkKeBHO6APWnEFchq/URaNnEGRYqz5y9U3dSqu9bPdYJCRIlTGODKtks/WH4n
	5jheQs+GpfEgZmNDYyF+gUi0Uz/zZbk=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b="agd/2G9s";
	spf=pass (imf05.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.160.175 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779785185; a=rsa-sha256;
	cv=pass;
	b=ykeUJqEKbq61MQG8XwYgbRru+ZhARWJE8/ypQSOmuNiSLaPWZC/m/e9dgVFZuvs5ZyTAjj
	tVqYLtB6HiZDjAgCJFhe1Qd4CmFwPRDsx2NmqGnHpw2F44CoRmJ1Cf/p9GxcYeQ4ITGUGJ
	5PFyh9eaKAkQ/9NRVwJzNaHcoKN6l5s=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-516d65a15f6so40290611cf.1
        for <linux-mm@kvack.org>; Tue, 26 May 2026 01:46:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779785184; cv=none;
        d=google.com; s=arc-20240605;
        b=XTd6TvyX8oY/u7O+zxs/EFUvgZSS38btEhATsT7qNYfhZOIJStR9CcsbiISd2EWAnD
         +GEawkS2D6FZHmBYJGSPxFuV/tAqi+V2SwaPnvsThiPCEZXtWs7QM6ChezvtSyRyXa78
         GWb5fpv5A6IEO6wLOcpyNqlDf036hiwj2uSTCNkG1VYPh1Vt7Ol6P+xaZvsA1mHxWoZP
         koUWBNourdqoWoz2TX6MPXLrYBHGe9YXtv6IrWx3DScgJSMvTLooOmY1tXCDKfJRmF52
         Q208GK96qcla2ZylwJrwo6UPDovRZ/1kiT0hyM3EIlKJlPj51QNtPhDHqjEuCKtMfHFt
         MXpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=+Sm7AdbBwz89HswDM1U3a+4O4uaDOPsFPs5dz3aFbf8=;
        fh=nblh8AZDODzhvs6WckaciDhmxnWtefFxfAz6N+pERJM=;
        b=ZYWD587EGWsCQU2UroaIfM51Amw0CgIiELjrQ6YXyacZbm26nBOQBOChjhBBScJXCI
         rVpoSE2z0EQSMlRTUjtY3aj3IQlTZJeZemBz/+HjsfFNmNuvw9v0ZSX/HOifoo29CrVz
         CfIQZVEmhmHTfDMZ/TERpH+0NZhbHjUHVkVLQ6eScWIUFHO7DYMarWy8xdHrYd4TIyhq
         /5AR18Rle0vvqSWcmtuiz6PG36ircGDclEz5M3NrGuujlUIdAz6X7sgLJ679WiMSujDE
         gVnfMtFMB3LB3H+HpJY2xLLUaEd3/POMgKi0iJ1UAJo0cwbAhNymaUwtqyegfAesdLgE
         hSnQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1779785184; x=1780389984; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+Sm7AdbBwz89HswDM1U3a+4O4uaDOPsFPs5dz3aFbf8=;
        b=agd/2G9sl4Xwp/BQpPvJ929lPFAUpyVigl/fqEf0ILlX0udyntCa226z/h6yb1gOqR
         BS+nWICUesH8JgZ9zcXGUgVk+xxa7E3psPFGeyAfEPnG/zoQRSFvXnPvjWY1FckfvNpZ
         4EWtMF+SxAd/8NDIqOmHk0w3I5lS2n697KroY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779785184; x=1780389984;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Sm7AdbBwz89HswDM1U3a+4O4uaDOPsFPs5dz3aFbf8=;
        b=VNYWkClsWQY6AFhC/NIvCTzYCcbgfSKalEdZ8cT5/qbvhg+nQPmPC4LaX1TXek0JnB
         FCIV7teMcTt8nbrpjsb9gQmGOx7BckE8ZWBjN0Lca0spgjh/lpF3y+QAJ/QvYyYSUTNK
         JDIPfLWiTEZADGXZbvhVI1uYCGAHXTTDfX8iVoagww17rz78xEJjJ/6A/Ep6c/1tIDCg
         ZlKARWLc0uM97j3WaDzP3nN8b2mRbYyJ5+8ixA6ityHb/BMAsVYVaoT9a8Qwu+ezdo5D
         dlpJHJxUSDHxMt9iTBxjnT2ZZPQI3OIMBTSbAItV72TVDOzzqxKE1DxwZdqlGJ6ix8iu
         SyqQ==
X-Forwarded-Encrypted: i=1; AFNElJ8gTGgZozlE9OID4oFusnocf62BYBwVm0QBxnVDgVDOukT1Xdbxr5aA9A0g7yWUTWOXtMRkxZtBzA==@kvack.org
X-Gm-Message-State: AOJu0Yz7ilmB/k/fp5+/bRiWg2Jvl138kXD1iNzziGlYgmoLdC7Oamz3
	vdi3t88ggqZxuMJ03qRTmQrAx2vY50QwrmygPJ72ywys3oLd6ATKs24xdfHPGUXQdKzypn6GqSI
	zwmS8PPV3Q+f7vDTTBi1Y0kynXz5Za7+aQOK9+jdqmA==
X-Gm-Gg: Acq92OFdL8Gy37D9Zczy7mMQ4FuFLwdW2mW8N8G657JP0Wdl59VPgSZCa8Z4AhAAdPp
	MBrB7QgpqP4WSuK59yPCltDND0rUKtZDbGYSN6R9Tdm4RiaarU/2NzHzfL8uhS5DwhNJ3fjNZkK
	29Y4h93RJa8f+uxTDKA4rsNfSJeTNB5VjchZPKOOiEJ/eBRUK+SpqCL6XWDu7ZKkNW/KNYLMX9Z
	PxfGxNq21jym4Qo1revEwNmo+499LHZGK9NliA57rtWcTwxpCzQIMLn//RHV8T2uSoBIEMUwQ9o
	P+Kn+TSuWPbCxV9NA4bLdnJJZfYtFi9QfBgRRuYkNPQaR/NHEzcYoF09ewOi
X-Received: by 2002:a05:622a:1a96:b0:516:3183:c20f with SMTP id
 d75a77b69052e-516d5864945mr188188911cf.20.1779785183718; Tue, 26 May 2026
 01:46:23 -0700 (PDT)
MIME-Version: 1.0
References: <177945382308.2991556.1256192774754909984.b4-ty@b4> <5386153f-9112-4971-98fc-de90d7aae2c6@oracle.com>
In-Reply-To: <5386153f-9112-4971-98fc-de90d7aae2c6@oracle.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 26 May 2026 10:46:12 +0200
X-Gm-Features: AVHnY4IqbMVtwyrUXhgBbVSdtrrlrZmTIKsKCBn7O4rzlywtF9IJtI5xqfn6ILQ
Message-ID: <CAJfpegu3PawBxwOPEO-+at-B9zRTJOzY+z4qeV7xOwOQb3Fr7w@mail.gmail.com>
Subject: Re: [PATCH 1/3] tmpfs: simplify constructing "security.foo" xattr names
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Calum Mackay <calum.mackay@oracle.com>, Christian Brauner <brauner@kernel.org>, 
	linux-fsdevel@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>, linux-mm@kvack.org, 
	Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Chuck Lever <cel@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E3379100008
X-Stat-Signature: 6tr7efcu1kci5j19k4ewycwsmcof9uou
X-HE-Tag: 1779785184-826115
X-HE-Meta: U2FsdGVkX1+EYWbJW2GCe4mBv4zRw24mUKsEPjevaLGRoLb2/TROLuNWpA36yfbjwwm+bxWso02c5idpr6shkLkCl4pdsZDgyZr46Hbfwl3BcHqYOC1IHaQ0+2HVjatE0qNfW65tKkr7TWzWSZYlWiOnfQxazCO6bLtA7SYYShRVqdYKOZEh3uWfox2wP72k8pJQeGSl4XsDZlVuT3WIdKm87DUaGGtAnXRcaiVZK21j2bk2DdtiwfuLZYDoRM+/mfpq0ZQ19mnB1wRZwvU4fE07Bv8ZXkJay4+EyFQQBuKcDvbJzTkvpD11v6jRGNAzZfTFWiXkAwIswgRSND5XjGGKpG8FwCjiyTIKQoLsY4gzwtI3kq3ZASpApi28H9/JoWw9P2lENM36EHuIjQYrNyso/qEMX2iIGFUx8LO1yx2a54VjppaNGe9YLJpe7Qu5RRH9/urs2hoTes47kuo5Sr4nu/efKg3J0vsKdnuy81r59yljp0dlSiGQONpOvkh6SME53KtecXeNEI/CDRMFMci8w8wFIF/v4HDt3d8LunSe5Legdg/SgzOcR6nca3tCqwENojjHqRoQ3BbP2L6hoC/X3ouhGVNUsLrfgTiBZpTpg+lsj/e2qEpgERKlL/lSOcqu1tlVhEbMWE/lvUIjMvVWXS2au1gexrMZInyuqv9FZA1xJPslfx+8Leb0aynvN7KGnhk506CT6v9OeyrXxYCnqikZwoCkgY10+JAi3vIuErTaMsHRFQBXSVO59rRXOyfDbwjujrxz58/mCqR59/v//UID3hFQVCHSMOaUZOxm+frpAgI8vZQ171kVsu9KZvbioWsrGz2Cnf/KwT2b+U7w5cPYcRmdq+sujilEq+9uIDI1514Sj40Jdn264OHE63ML3ULv7mm2Y6EjbQRnpgAkTwLs6nyG1kSk1pXe81fI6MEMrvpT27UK2t3gAmUpgg0k1g7cQlx5iK6aa8X
 3dKZ8zvw
 oJyM98M/VLKcyUM4BVfKRT5UkRZrAv/uMVK8D0iDy0auEc55e4ZwliHrJiIPLUFIOoMskFMVL78iUILgpLXB/DRJVE78cFSIlitL6hcMn9VjPYEBJlOBt67n7ZWLZFViTLQKvTdjEY+7wjnI0oPwsIei9WNBoghxyJqBY5jXPNt3Eqfo0l9iZ4RqjHo6aOykTBL+zKsJvTQUE900SRDT1wNmFm5wvxkIYm7yyYOw0+wXtkaQwiernBZ2EyAxUUuJBJQplfbSG6/yMrYf8+YrF+t1GrI2qW8qRcQqjPXMgq+u4NHEOf5+Y+UZJhKV87+dyImFkZ+4phuKVUbibIEkTs5B5fG7j+PsMZFFXAHUggacL1EFlfeWqtJlbyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[Cc: Greg KH]

On Mon, 25 May 2026 at 05:59, Calum Mackay <calum.mackay@oracle.com> wrote:
>
> hi Christian, Miklos,
>
> https://lore.kernel.org/all/177945382308.2991556.1256192774754909984.b4-ty@b4/
>
> > Date: Fri, 22 May 2026 14:43:43 +0200> On Tue, 19 May 2026 10:13:21 +0200, Miklos Szeredi wrote:
> >> tmpfs: simplify constructing "security.foo" xattr names
> >
> > Thanks, this looks great!
> >
> > ---
> >
> > Applied to the vfs-7.2.misc branch of the vfs/vfs.git tree.
> > Patches in the vfs-7.2.misc branch should appear in linux-next soon.
> >
> > Please report any outstanding bugs that were missed during review in a
> > new review to the original patch series allowing us to drop it.
> >
> > It's encouraged to provide Acked-bys and Reviewed-bys even though the
> > patch has now been applied. If possible patch trailers will be updated.
> >
> > Note that commit hashes shown below are subject to change due to rebase,
> > trailer updates or similar. If in doubt, please check the listed branch.
> >
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
> > branch: vfs-7.2.misc
> >
> > [1/3] tmpfs: simplify constructing "security.foo" xattr names
> >       https://git.kernel.org/vfs/vfs/c/aba5853b137b
> > [2/3] simple_xattr: change interface to pass struct simple_xattrs **
> >       https://git.kernel.org/vfs/vfs/c/1cd9d2387c05
> > [3/3] simpe_xattr: use per-sb cache
> >       https://git.kernel.org/vfs/vfs/c/12e9e3cd03b5
>
>
> I have been doing some testing of Chuck's nfsd-testing tree, which
> includes some vfs changes.
>
> The test systems are reliably crashing, in what looks like it might
> possibly be something related to these three patches.

Calum, thanks for the report.

Relevant part of call trace is:

kernfs_new_node
  __kernfs_new_node
    security_kernfs_init_security
      selinux_kernfs_init_security
        kernfs_xattr_set
          kernfs_root

Since __parent is assigned after security_kernfs_init_security() gets
called, kernfs_root() will return NULL.

Greg, any idea about dealing with this?

Thanks,
Miklos


>
> I reverted the three patches, and the crashes stopped.
>
>
> best wishes,
> calum.
>
>
>
> [    9.215122] BUG: kernel NULL pointer dereference, address:
> 00000000000000e0
> [    9.218829] #PF: supervisor read access in kernel mode
> [    9.221484] #PF: error_code(0x0000) - not-present page
> [    9.224201] PGD 0 P4D 0
> [    9.225557] Oops: Oops: 0000 [#1] SMP NOPTI
> [    9.227773] CPU: 0 UID: 0 PID: 1 Comm: systemd Not tainted
> 7.1.0-rc4.master.20260524.el10.rc1.x86_64 #1 PREEMPT(lazy)
> [    9.233281] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS 1.6.4 02/27/2023
> [    9.237483] RIP: 0010:simple_xattr_set+0x27/0x8b0
> [    9.239951] Code: 90 90 90 0f 1f 40 d6 0f 1f 44 00 00 55 48 89 e5 41
> 57 41 56 49 89 d6 41 55 49 89 f5 4c 89 c6 41 54 53 48 83 e4 f0 48 83 ec
> 40 <4c> 8b 27 44 89 4c 24 3c 4c 89 6c 24 20 48 89 54 24 28 4d 85 e4 0f
> [    9.249572] RSP: 0018:ffffd1334001fa20 EFLAGS: 00010282
> [    9.252362] RAX: ffff89974107e460 RBX: ffffffff856b2f80 RCX:
> ffff899758b0ef60
> [    9.256059] RDX: ffffffff856b2f80 RSI: 000000000000001e RDI:
> 00000000000000e0
> [    9.259712] RBP: ffffd1334001fa90 R08: 000000000000001e R09:
> 0000000000000001
> [    9.263416] R10: ffff89974107e460 R11: 0030733a745f7075 R12:
> 000000000000001e
> [    9.267138] R13: ffff89974107e498 R14: ffffffff856b2f80 R15:
> ffff8997443c5440
> [    9.270772] FS:  00007fc098c74500(0000) GS:ffff899ae8a58000(0000)
> knlGS:0000000000000000
> [    9.274906] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    9.277976] CR2: 00000000000000e0 CR3: 00000001013d1000 CR4:
> 00000000003506f0
> [    9.281668] Call Trace:
> [    9.282985]  <TASK>
> [    9.284145]  ? srso_return_thunk+0x5/0x5f
> [    9.286188]  ? srso_return_thunk+0x5/0x5f
> [    9.288277]  ? ktime_get_real_ts64+0xce/0x140
> [    9.290614]  ? srso_return_thunk+0x5/0x5f
> [    9.292776]  kernfs_xattr_set+0x63/0xb0
> [    9.294829]  selinux_kernfs_init_security+0x13b/0x270
> [    9.297496]  security_kernfs_init_security+0x36/0xc0
> [    9.300105]  __kernfs_new_node+0x182/0x290
> [    9.302421]  ? srso_return_thunk+0x5/0x5f
> [    9.304597]  ? srso_return_thunk+0x5/0x5f
> [    9.306645]  ? pcpu_alloc_noprof+0x481/0x990
> [    9.308854]  kernfs_new_node+0x80/0xc0
> [    9.310876]  kernfs_create_dir_ns+0x2b/0xa0
> [    9.313103]  cgroup_create+0x116/0x380
> [    9.315123]  cgroup_mkdir+0x7c/0x1a0
> [    9.317051]  kernfs_iop_mkdir+0x75/0xf0
> [    9.319014]  vfs_mkdir+0xc2/0x240
> [    9.320809]  filename_mkdirat+0x1cc/0x220
> [    9.322932]  __x64_sys_mkdir+0x2f/0x50
> [    9.324938]  do_syscall_64+0xe8/0x5e0
> [    9.326895]  ? srso_return_thunk+0x5/0x5f
> [    9.329104]  ? count_memcg_events+0xdf/0x190
> [    9.331392]  ? srso_return_thunk+0x5/0x5f
> [    9.333556]  ? handle_mm_fault+0x24a/0x350
> [    9.335741]  ? srso_return_thunk+0x5/0x5f
> [    9.337894]  ? do_user_addr_fault+0x221/0x680
> [    9.340194]  ? srso_return_thunk+0x5/0x5f
> [    9.342653]  ? arch_exit_to_user_mode_prepare.isra.0+0x9/0xe0
> [    9.345955]  ? srso_return_thunk+0x5/0x5f
> [    9.348377]  ? srso_return_thunk+0x5/0x5f
> [    9.350793]  ? do_syscall_64+0x9d/0x5e0
> [    9.353123]  ? srso_return_thunk+0x5/0x5f
> [    9.355707]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [    9.358689] RIP: 0033:0x7fc09832076b
> [    9.360891] Code: 0f 1e fa 48 89 f2 b9 00 01 00 00 48 89 fe bf 9c ff
> ff ff e9 a7 ca ff ff 0f 1f 80 00 00 00 00 f3 0f 1e fa b8 53 00 00 00 0f
> 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 71 56 0d 00 f7 d8
> [    9.371018] RSP: 002b:00007ffd34f0af28 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000053
> [    9.375220] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:
> 00007fc09832076b
> [    9.379178] RDX: 0000000000000000 RSI: 00000000000001ed RDI:
> 00005609edb55790
> [    9.383159] RBP: 00007ffd34f0af60 R08: 0000000000000000 R09:
> 0000000000000000
> [    9.387102] R10: 0000000000000000 R11: 0000000000000246 R12:
> 00005609edaeea70
> [    9.391136] R13: 0000000000001fad R14: 00007fc098754472 R15:
> 00005609edb481d0
> [    9.395140]  </TASK>
> [    9.396605] Modules linked in: vsock_loopback
> vmw_vsock_virtio_transport_common vmw_vsock_vmci_transport vsock
> vmw_vmci xfs nvme_tcp nvme_fabrics nvme_core nvme_keyring nvme_auth
> sd_mod ata_generic pata_acpi ata_piix virtio_net net_failover failover
> libata virtio_scsi serio_raw btrfs libblake2b zstd_compress raid6_pq xor
> sunrpc dm_mirror dm_region_hash dm_log be2iscsi bnx2i cnic uio cxgb4i
> cxgb4 tls cxgb3i cxgb3 mdio libcxgbi libcxgb qla4xxx iscsi_tcp
> libiscsi_tcp libiscsi scsi_transport_iscsi iscsi_ibft iscsi_boot_sysfs
> dm_multipath dm_mod qemu_fw_cfg virtio_pci virtio_pci_legacy_dev
> virtio_pci_modern_dev
> [    9.424581] CR2: 00000000000000e0
> [    9.426635] ---[ end trace 0000000000000000 ]---
> [    9.429400] RIP: 0010:simple_xattr_set+0x27/0x8b0
> [    9.432229] Code: 90 90 90 0f 1f 40 d6 0f 1f 44 00 00 55 48 89 e5 41
> 57 41 56 49 89 d6 41 55 49 89 f5 4c 89 c6 41 54 53 48 83 e4 f0 48 83 ec
> 40 <4c> 8b 27 44 89 4c 24 3c 4c 89 6c 24 20 48 89 54 24 28 4d 85 e4 0f
> [    9.442394] RSP: 0018:ffffd1334001fa20 EFLAGS: 00010282
> [    9.445458] RAX: ffff89974107e460 RBX: ffffffff856b2f80 RCX:
> ffff899758b0ef60
> [    9.449465] RDX: ffffffff856b2f80 RSI: 000000000000001e RDI:
> 00000000000000e0
> [    9.453436] RBP: ffffd1334001fa90 R08: 000000000000001e R09:
> 0000000000000001
> [    9.457506] R10: ffff89974107e460 R11: 0030733a745f7075 R12:
> 000000000000001e
> [    9.461589] R13: ffff89974107e498 R14: ffffffff856b2f80 R15:
> ffff8997443c5440
> [    9.465681] FS:  00007fc098c74500(0000) GS:ffff899ae8a58000(0000)
> knlGS:0000000000000000
> [    9.470290] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    9.473702] CR2: 00000000000000e0 CR3: 00000001013d1000 CR4:
> 00000000003506f0
> [    9.477743] Kernel panic - not syncing: Fatal exception
> [    9.481889] Kernel Offset: 0x2a00000 from 0xffffffff81000000
> (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> [    9.487771] ---[ end Kernel panic - not syncing: Fatal exception ]---
>

