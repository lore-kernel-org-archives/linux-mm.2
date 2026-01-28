Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F5AAD35660
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 02:02:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A42B46B0088; Tue, 27 Jan 2026 21:02:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F0D76B0089; Tue, 27 Jan 2026 21:02:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D2976B008A; Tue, 27 Jan 2026 21:02:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 788916B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 21:02:41 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0F4451AFF11
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 02:02:41 +0000 (UTC)
X-FDA: 84379723722.25.F144AA9
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf15.hostedemail.com (Postfix) with ESMTP id D5440A0008
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 02:02:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xwQIcx2b;
	spf=pass (imf15.hostedemail.com: domain of wusamuel@google.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=wusamuel@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769565759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xjs7REJ/WW1grWbDrI+yGSmGQ7BvuQU3ORny1k3JZHE=;
	b=JkRLcFQbIjKbxiGkOg0/4343cmgfYM9wNcM3FHZi+hO1pBRcV2cpQi44FLawJaNKu1fwm9
	BuxbT/g3cwheF5p7gjkMP3tCrFrEYrCKkAMewWxiYRIHruAX6STDdQpziwVw+aKihNAkyo
	xaWd986N0Fehne+L24PsSytvPiuYQsQ=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xwQIcx2b;
	spf=pass (imf15.hostedemail.com: domain of wusamuel@google.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=wusamuel@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769565759; a=rsa-sha256;
	cv=pass;
	b=xtUzVECLSJX9T3EzVieaskl0kixLLpA1TVoUU6Fdde30fV7Auq+RL10ExinZpGgKcuTZMl
	bXPsE4WSDk7mtSSwWOxf64oOLuy0UotqhFL7hJOaBGamYoVdjfmEMM/h8luRxAwue6kks5
	c8BgPiNmh3srI2pF410jvq5S0/vMhP8=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b79f8f7ea43so1138307766b.2
        for <linux-mm@kvack.org>; Tue, 27 Jan 2026 18:02:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769565757; cv=none;
        d=google.com; s=arc-20240605;
        b=lj7nZx6hgcuCEwG1Z7doK9iI4bEridseLhqWX64YInLUEwOkZa58BMhhRVqpv2rBX8
         8B1Mlp1a6LhlIKXxuwoS1Jt8Q4BSWP0bGGkuXmKx5WBFWeQnc6T0jAxOPNKSFXBoZaTn
         /1JjH50WzU6T0S3bcbcHSDaPMv0rDHlyMhqjQ942WkihtqkF1lrXCnMBzR6OBJqniV0F
         EDzn7af8KMqmpqBwZ4c0LJIciWvJZp4/hqYdIzIB5RNJYHPo8oC11PVEbcC+Nzuo89u4
         tHyoHFPNVjc4rjfDjCcSNMKhaY/HsN8Km7AplgofsBKr4parL3V2j2CooFLbnpRv1Tvs
         pKQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Xjs7REJ/WW1grWbDrI+yGSmGQ7BvuQU3ORny1k3JZHE=;
        fh=7aBPX7zVRRRtyqJYjspM4zzD3Mwx7TOY1OWW44QsXkA=;
        b=ld9nCz59DJyswd1BBlaXuIOB4GQqkZDP+9aJFpwSTywng+QpijsLKcg3FTiNEpikhH
         db1W6YqbMF7mPyE7oCoMeDYE+WEWV11WRMot0BNMG02A2tU5CQbx2lJPxufVIKAn7cQM
         6pcrYz7FpciT4/17UAiCP9mLepPy0yeK9mE0ORHk8uTkcAUVr9UCpZEwbgi3T1kbIkQJ
         xn1EO9J8EjQV4+C/C2JqsK8rBIfdM+pCAUUd+yqDO18BjQdY+HpdffUK7poVgpc7BGXQ
         KsLWw52cJVB8jbcr0kSj0QKZVfghNwKP/RTIR0aTgeInKz31BHgbT8n+WMfg6w+eKJPp
         dIHA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769565757; x=1770170557; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xjs7REJ/WW1grWbDrI+yGSmGQ7BvuQU3ORny1k3JZHE=;
        b=xwQIcx2bFIAsciI1KHAO2rQk6C0Q8g/89by/amJwpQ8vSbye1Jjsus0OAHJW5vPUeG
         HhSavw42O8BBBicYn/dQvcdRg7b8nnvwCvjRfs0ZmxcIIbBU436txiwVpBin+4hUuoji
         dIaXa/KJ4fuNgUTdH1eop9RSo1UWojx1evvKZ5D2dVtc7SS7aqXL1NSSf74kR7GI6m0d
         +QkvN+nGHTZUmWY2cgluRZ6k4QvbW3M6VWfllRbv+zv/Ftyfo0ClbEA/BGVHB6Iuokw8
         JqyTDhMh8vDVbbvNDDKgrpNmGGh29ZDVmVYEHz/HDB8pjSd6lAERv5stFzMBWBOPtZsZ
         X2hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769565757; x=1770170557;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Xjs7REJ/WW1grWbDrI+yGSmGQ7BvuQU3ORny1k3JZHE=;
        b=jgCdvFsFMCyTDdcbDuNO177Qnt5EUVJfKpGqNh8hNPqjXopxLfEmr55fhRbbFxO9IJ
         7N+Vt22OfhDTW1p6jUgS4Ps1vUFH0hXQ7MYopjpb3Oppfld2ut+yCbC1XE/id4COmKCp
         uGNVnIsZla7jP4pvAfY5KruFeMxbDY3xTK56VftBexyu8psl9uX3GY7A3SdpqN+BUdVE
         PaVIw4vzR3NHIMQkC8ilkPlsKONiBC6cZXDHyc0SZ4E0Ng0dRW/ID3enY4Io7zyyKXyK
         aoNY/oSmrjFtTo3/bD9JwiGBvVA3BDH/eAfkpLVKGeZImnuIBPfF4nEkfLq2gQMbX99L
         3KMQ==
X-Forwarded-Encrypted: i=1; AJvYcCW4OjjyjFiUvVGHKGCtTV6CDHmXbiwVRqkvpYkMSXlyXqn1oRwCX3DIkey4VobsSvHIKLvLz4aYBg==@kvack.org
X-Gm-Message-State: AOJu0YxiL7CkqZj/Th5fcRoGdTfB4ZoMtbPs+hs1qzJO2zZaKCEWHdp9
	RAGjZhIBrHL+QtVvGcJ6FHo8fWjMpZK7WwXvUiqdUdjNkGRL+wKSclEpGdGLVGAJK68ZrtC+qHq
	PVUVFMehR+KVq3t348ouVilTnu32G7F4Ky+30CBkS
X-Gm-Gg: AZuq6aI5trll/LhXmAsaN9WXB5iNy9cQfdqkedpz7/ucbNaJAFg/E0p2yu9zt0kDdRj
	jAseUtmOZyjAOMhwbGBSpIUNdLg1D2HPBDJdsSSZzpLBUiLAZ7u8sjcyITIQ8S9GrO1loULJNdo
	a155HiKcERjCQBqjSbqZ2e7UbAgbEHa0QQvFahmzaS+2Q9bP3uTRGY/M5LTTQlhz0N4STHhXXhM
	9LcLmzLh3815U72CE45HM35fcjaKeaXxsjqc69CP8iEL5wmCcFenr7qISLZHCGnf+BNY7+5NvQf
	iRaFVZ0Pg2prsvkpAG960dYZ/w==
X-Received: by 2002:a17:907:1c95:b0:b87:7419:d3a8 with SMTP id
 a640c23a62f3a-b8dab330fc4mr281957066b.34.1769565756791; Tue, 27 Jan 2026
 18:02:36 -0800 (PST)
MIME-Version: 1.0
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
 <CAG2KctrjSP+XyBiOB7hGA2DWtdpg3diRHpQLKGsVYxExuTZazA@mail.gmail.com> <2026012715-mantra-pope-9431@gregkh>
In-Reply-To: <2026012715-mantra-pope-9431@gregkh>
From: Samuel Wu <wusamuel@google.com>
Date: Tue, 27 Jan 2026 18:02:25 -0800
X-Gm-Features: AZwV_QjNxLKzH4SWKEB4t-7rNY8Sc7_QUT5_wgx9ZFwlSN8bjQfsTOxnH38Kjmw
Message-ID: <CAG2Kctoo=xiVdhRZnLaoePuu2cuQXMCdj2q6L-iTnb8K1RMHkw@mail.gmail.com>
Subject: Re: [PATCH v4 00/54] tree-in-dcache stuff
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, 
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
X-Stat-Signature: mftxsyekp6ou7phdqskwg1ddswi69grm
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D5440A0008
X-HE-Tag: 1769565758-779474
X-HE-Meta: U2FsdGVkX1/C4Alaf9zl/Ar7r80RCe4AJpynaekQLtw1h7vwCVdCpd+Oak4nPOygBBum13R90us3VzzJsVaF7JAnOEUe6WapLUvcjOxhm1hUjZ3NzgaFZW9p5TN6O3ndPSENbiT1hub2Bqzt/5YfZ5suU0JnKX4QMaCnUbXB5pEd7AFAyfIjbT4cE1lKvzz71CxX9GoyYh7qp6usI66CKaye9tkCLb+a0Cnjj285Oc2OXm1G6cWpNA35tOZEYuRS8PIaes2gyTXTc8kfJaGdDg7XyV8s1midIxj5/GLzx4VcXFXEQSDnHUyGSgeCGCOqYISEkSPkk0K2luz1jJ1+atFHLwZaRSVET98BjgXRNLmEI8tJRoET2cE/5OHFGMJULajcEpRD933829Fdv8pxuJkmsU6C8g7xWaY6g4+AQUbGlTOWV3y+pWCjMCHoFwCb2uhdro/ZxDq12a5uTIS/TqQkXOkN/RktC/w6m4BDIQN1QqSeQ5tMiLMdaLuql21WDxZxz0o7AFI0ZY6YUjfOUAE4YELejAf8mNuN+A0J0vlUnp1dkRwNDq7Hdf5LW7IbriSbHQiEZVUB2tEwvXWZs/s7xL9KU6MU1LPjRujmxkkj4xIyyE9fNoJvbyUgOGMJRAKAnxZxOrAhNJ7wTTQexVFSijRVKKTcnKFOhJOTZmqKL0MiAEhGQswhhofxqXXnB6S9tvV8exwFbC/z/XumM9oiT33HkG0yONxKAZZa9htHZsv0NMYvTvcPktl2Q2Yg6wTxSY7fys4Bggmmr5ydh4yu+0gEAB+iGwlaR3mdNrEcrBa7BurA4yoEDdnONTovEV21RIINfD20IIy6Qz2pLZox8dGNmgd3v0xcVUgXz3pb7CoJpcIu60GCWepIHyqVNOuPJcgGh+vrlQBq7iNqeLotOl+okz6wJhnYu7LfTTYqszvfYybhkDFoJ3CavMbO953cldHNc4cLF/6Dx3T
 SSs3fN/Y
 qZoFDBlNIjzgWpGgMDyBXD5+KrcDpRYRHhLHz+/Wn8+ele6VFUzV0xysYYLjNvm/USX6AiUgWHLWHx+e6rs/WAwbMgbdRwoZ5icivsFZPp7nm72A3Ik5eYhFmNDMLq52Kz9zZQLDreaYky8nUsoj/0YPnUVUs5uMpBg75Ab0t1dhcGDkvcFQtDZUC6gxjef5ru+vCgsvx0bkk5l/hLXZy+EcDLXhhmgPeMUxLDy9AgxFRG3XHSEWeXQ4wHgH7lG/fSlYbPwkxWq8pKal0YTDHS5Xb4RKN9lXW9T/RiynFmzAyvYDMwg45UQTf6jD3rFXldNTO9J2sa4EzJj/9tSVTQexwVmDIR7xTfh6n1lS18IT0/d+HNzpRbD/KWQIrvsS5sdEaQk7dk4GnivbZos+2ABLa8MrezOzhfeKKmtUL/hX7PLJKJqpuqlylG/JDu+46Wshf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 26, 2026 at 11:42=E2=80=AFPM Greg KH <gregkh@linuxfoundation.or=
g> wrote:
>
> On Mon, Jan 26, 2026 at 04:56:42PM -0800, Samuel Wu wrote:
> > On Mon, Nov 17, 2025 at 9:15=E2=80=AFPM Al Viro <viro@zeniv.linux.org.u=
k> wrote:
> > >
> > > Some filesystems use a kinda-sorta controlled dentry refcount leak to=
 pin
> > > dentries of created objects in dcache (and undo it when removing thos=
e).
> > > Reference is grabbed and not released, but it's not actually _stored_
> > > anywhere.  That works, but it's hard to follow and verify; among othe=
r
> > > things, we have no way to tell _which_ of the increments is intended
> > > to be an unpaired one.  Worse, on removal we need to decide whether
> > > the reference had already been dropped, which can be non-trivial if
> > > that removal is on umount and we need to figure out if this dentry is
> > > pinned due to e.g. unlink() not done.  Usually that is handled by usi=
ng
> > > kill_litter_super() as ->kill_sb(), but there are open-coded special
> > > cases of the same (consider e.g. /proc/self).
> > >
> > > Things get simpler if we introduce a new dentry flag (DCACHE_PERSISTE=
NT)
> > > marking those "leaked" dentries.  Having it set claims responsibility
> > > for +1 in refcount.
> > >
> > > The end result this series is aiming for:
> > >
> > > * get these unbalanced dget() and dput() replaced with new primitives=
 that
> > >   would, in addition to adjusting refcount, set and clear persistency=
 flag.
> > > * instead of having kill_litter_super() mess with removing the remain=
ing
> > >   "leaked" references (e.g. for all tmpfs files that hadn't been remo=
ved
> > >   prior to umount), have the regular shrink_dcache_for_umount() strip
> > >   DCACHE_PERSISTENT of all dentries, dropping the corresponding
> > >   reference if it had been set.  After that kill_litter_super() becom=
es
> > >   an equivalent of kill_anon_super().
> > >
> > > Doing that in a single step is not feasible - it would affect too man=
y places
> > > in too many filesystems.  It has to be split into a series.
> > >
> > > This work has really started early in 2024; quite a few preliminary p=
ieces
> > > have already gone into mainline.  This chunk is finally getting to th=
e
> > > meat of that stuff - infrastructure and most of the conversions to it=
.
> > >
> > > Some pieces are still sitting in the local branches, but the bulk of
> > > that stuff is here.
> > >
> > > Compared to v3:
> > >         * fixed a functionfs braino around ffs_epfiles_destroy() (in =
#40/54,
> > > used to be #36/50).
> > >         * added fixes for a couple of UAF in functionfs (##36--39); t=
hat
> > > does *NOT* include any fixes for dmabuf bugs Chris posted last week, =
though.
> > >
> > > The branch is -rc5-based; it lives in
> > > git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git #work.pers=
istency
> > > individual patches in followups.
> > >
> > > Please, help with review and testing.  If nobody objects, in a few da=
ys it
> > > goes into #for-next.
> > >
> > > Shortlog:
> > >       fuse_ctl_add_conn(): fix nlink breakage in case of early failur=
e
> > >       tracefs: fix a leak in eventfs_create_events_dir()
> > >       new helper: simple_remove_by_name()
> > >       new helper: simple_done_creating()
> > >       introduce a flag for explicitly marking persistently pinned den=
tries
> > >       primitives for maintaining persisitency
> > >       convert simple_{link,unlink,rmdir,rename,fill_super}() to new p=
rimitives
> > >       convert ramfs and tmpfs
> > >       procfs: make /self and /thread_self dentries persistent
> > >       configfs, securityfs: kill_litter_super() not needed
> > >       convert xenfs
> > >       convert smackfs
> > >       convert hugetlbfs
> > >       convert mqueue
> > >       convert bpf
> > >       convert dlmfs
> > >       convert fuse_ctl
> > >       convert pstore
> > >       convert tracefs
> > >       convert debugfs
> > >       debugfs: remove duplicate checks in callers of start_creating()
> > >       convert efivarfs
> > >       convert spufs
> > >       convert ibmasmfs
> > >       ibmasmfs: get rid of ibmasmfs_dir_ops
> > >       convert devpts
> > >       binderfs: use simple_start_creating()
> > >       binderfs_binder_ctl_create(): kill a bogus check
> > >       convert binderfs
> > >       autofs_{rmdir,unlink}: dentry->d_fsdata->dentry =3D=3D dentry t=
here
> > >       convert autofs
> > >       convert binfmt_misc
> > >       selinuxfs: don't stash the dentry of /policy_capabilities
> > >       selinuxfs: new helper for attaching files to tree
> > >       convert selinuxfs
> > >       functionfs: don't abuse ffs_data_closed() on fs shutdown
> > >       functionfs: don't bother with ffs->ref in ffs_data_{opened,clos=
ed}()
> > >       functionfs: need to cancel ->reset_work in ->kill_sb()
> > >       functionfs: fix the open/removal races
> > >       functionfs: switch to simple_remove_by_name()
> > >       convert functionfs
> > >       gadgetfs: switch to simple_remove_by_name()
> > >       convert gadgetfs
> > >       hypfs: don't pin dentries twice
> > >       hypfs: switch hypfs_create_str() to returning int
> > >       hypfs: swich hypfs_create_u64() to returning int
> > >       convert hypfs
> > >       convert rpc_pipefs
> > >       convert nfsctl
> > >       convert rust_binderfs
> > >       get rid of kill_litter_super()
> > >       convert securityfs
> > >       kill securityfs_recursive_remove()
> > >       d_make_discardable(): warn if given a non-persistent dentry
> > >
> > > Diffstat:
> > >  Documentation/filesystems/porting.rst     |   7 ++
> > >  arch/powerpc/platforms/cell/spufs/inode.c |  17 ++-
> > >  arch/s390/hypfs/hypfs.h                   |   6 +-
> > >  arch/s390/hypfs/hypfs_diag_fs.c           |  60 ++++------
> > >  arch/s390/hypfs/hypfs_vm_fs.c             |  21 ++--
> > >  arch/s390/hypfs/inode.c                   |  82 +++++--------
> > >  drivers/android/binder/rust_binderfs.c    | 121 ++++++-------------
> > >  drivers/android/binderfs.c                |  82 +++----------
> > >  drivers/base/devtmpfs.c                   |   2 +-
> > >  drivers/misc/ibmasm/ibmasmfs.c            |  24 ++--
> > >  drivers/usb/gadget/function/f_fs.c        | 144 +++++++++++++-------=
---
> > >  drivers/usb/gadget/legacy/inode.c         |  49 ++++----
> > >  drivers/xen/xenfs/super.c                 |   2 +-
> > >  fs/autofs/inode.c                         |   2 +-
> > >  fs/autofs/root.c                          |  11 +-
> > >  fs/binfmt_misc.c                          |  69 ++++++-----
> > >  fs/configfs/dir.c                         |  10 +-
> > >  fs/configfs/inode.c                       |   3 +-
> > >  fs/configfs/mount.c                       |   2 +-
> > >  fs/dcache.c                               | 111 +++++++++++-------
> > >  fs/debugfs/inode.c                        |  32 ++----
> > >  fs/devpts/inode.c                         |  57 ++++-----
> > >  fs/efivarfs/inode.c                       |   7 +-
> > >  fs/efivarfs/super.c                       |   5 +-
> > >  fs/fuse/control.c                         |  38 +++---
> > >  fs/hugetlbfs/inode.c                      |  12 +-
> > >  fs/internal.h                             |   1 -
> > >  fs/libfs.c                                |  52 +++++++--
> > >  fs/nfsd/nfsctl.c                          |  18 +--
> > >  fs/ocfs2/dlmfs/dlmfs.c                    |   8 +-
> > >  fs/proc/base.c                            |   6 +-
> > >  fs/proc/internal.h                        |   1 +
> > >  fs/proc/root.c                            |  14 +--
> > >  fs/proc/self.c                            |  10 +-
> > >  fs/proc/thread_self.c                     |  11 +-
> > >  fs/pstore/inode.c                         |   7 +-
> > >  fs/ramfs/inode.c                          |   8 +-
> > >  fs/super.c                                |   8 --
> > >  fs/tracefs/event_inode.c                  |   7 +-
> > >  fs/tracefs/inode.c                        |  13 +--
> > >  include/linux/dcache.h                    |   4 +-
> > >  include/linux/fs.h                        |   6 +-
> > >  include/linux/proc_fs.h                   |   2 -
> > >  include/linux/security.h                  |   2 -
> > >  init/do_mounts.c                          |   2 +-
> > >  ipc/mqueue.c                              |  12 +-
> > >  kernel/bpf/inode.c                        |  15 +--
> > >  mm/shmem.c                                |  38 ++----
> > >  net/sunrpc/rpc_pipe.c                     |  27 ++---
> > >  security/apparmor/apparmorfs.c            |  13 ++-
> > >  security/inode.c                          |  35 +++---
> > >  security/selinux/selinuxfs.c              | 185 +++++++++++++-------=
----------
> > >  security/smack/smackfs.c                  |   2 +-
> > >  53 files changed, 649 insertions(+), 834 deletions(-)
> > >
> > >         Overview:
> > >
> > > First two commits are bugfixes (fusectl and tracefs resp.)
> > >
> > > [1/54] fuse_ctl_add_conn(): fix nlink breakage in case of early failu=
re
> > > [2/54] tracefs: fix a leak in eventfs_create_events_dir()
> > >
> > > Next, two commits adding a couple of useful helpers, the next three a=
dding
> > > the infrastructure and the rest consists of per-filesystem conversion=
s.
> > >
> > > [3/54] new helper: simple_remove_by_name()
> > > [4/54] new helper: simple_done_creating()
> > >         end_creating_path() analogue for internal object creation; un=
like
> > > end_creating_path() no mount is passed to it (or guaranteed to exist,=
 for
> > > that matter - it might be used during the filesystem setup, before th=
e
> > > superblock gets attached to any mounts).
> > >
> > > Infrastructure:
> > > [5/54] introduce a flag for explicitly marking persistently pinned de=
ntries
> > >         * introduce the new flag
> > >         * teach shrink_dcache_for_umount() to handle it (i.e. remove
> > > and drop refcount on anything that survives to umount with that flag
> > > still set)
> > >         * teach kill_litter_super() that anything with that flag does
> > > *not* need to be unpinned.
> > > [6/54] primitives for maintaining persisitency
> > >         * d_make_persistent(dentry, inode) - bump refcount, mark pers=
istent
> > > and make hashed positive.  Return value is a borrowed reference to de=
ntry;
> > > it can be used until something removes persistency (at the very least=
,
> > > until the parent gets unlocked, but some filesystems may have stronge=
r
> > > exclusion).
> > >         * d_make_discardable() - remove persistency mark and drop ref=
erence.
> > >
> > > NOTE: at that stage d_make_discardable() does not reject dentries not
> > > marked persistent - it acts as if the mark been set.
> > >
> > > Rationale: less noise in series splitup that way.  We want (and on th=
e
> > > next commit will get) simple_unlink() to do the right thing - remove
> > > persistency, if it's there.  However, it's used by many filesystems.
> > > We would have either to convert them all at once or split simple_unli=
nk()
> > > into "want persistent" and "don't want persistent" versions, the latt=
er
> > > being the old one.  In the course of the series almost all callers
> > > would migrate to the replacement, leaving only two pathological cases
> > > with the old one.  The same goes for simple_rmdir() (two callers left=
 in
> > > the end), simple_recursive_removal() (all callers gone in the end), e=
tc.
> > > That's a lot of noise and it's easier to start with d_make_discardabl=
e()
> > > quietly accepting non-persistent dentries, then, in the end, add priv=
ate
> > > copies of simple_unlink() and simple_rmdir() for two weird users (con=
figfs
> > > and apparmorfs) and have those use dput() instead of d_make_discardab=
le().
> > > At that point we'd be left with all callers of d_make_discardable()
> > > always passing persistent dentries, allowing to add a warning in it.
> > >
> > > [7/54] convert simple_{link,unlink,rmdir,rename,fill_super}() to new =
primitives
> > >         See above re quietly accepting non-peristent dentries in
> > > simple_unlink(), simple_rmdir(), etc.
> > >
> > >         Converting filesystems:
> > > [8/54] convert ramfs and tmpfs
> > > [9/54] procfs: make /self and /thread_self dentries persistent
> > > [10/54] configfs, securityfs: kill_litter_super() not needed
> > > [11/54] convert xenfs
> > > [12/54] convert smackfs
> > > [13/54] convert hugetlbfs
> > > [14/54] convert mqueue
> > > [15/54] convert bpf
> > > [16/54] convert dlmfs
> > > [17/54] convert fuse_ctl
> > > [18/54] convert pstore
> > > [19/54] convert tracefs
> > > [20/54] convert debugfs
> > > [21/54] debugfs: remove duplicate checks in callers of start_creating=
()
> > > [22/54] convert efivarfs
> > > [23/54] convert spufs
> > > [24/54] convert ibmasmfs
> > > [25/54] ibmasmfs: get rid of ibmasmfs_dir_ops
> > > [26/54] convert devpts
> > > [27/54] binderfs: use simple_start_creating()
> > > [28/54] binderfs_binder_ctl_create(): kill a bogus check
> > > [29/54] convert binderfs
> > > [30/54] autofs_{rmdir,unlink}: dentry->d_fsdata->dentry =3D=3D dentry=
 there
> > > [31/54] convert autofs
> > > [32/54] convert binfmt_misc
> > > [33/54] selinuxfs: don't stash the dentry of /policy_capabilities
> > > [34/54] selinuxfs: new helper for attaching files to tree
> > > [35/54] convert selinuxfs
> > >
> > >         Several functionfs fixes, before converting it, to make life
> > > simpler for backporting:
> > > [36/54] functionfs: don't abuse ffs_data_closed() on fs shutdown
> > > [37/54] functionfs: don't bother with ffs->ref in ffs_data_{opened,cl=
osed}()
> > > [38/54] functionfs: need to cancel ->reset_work in ->kill_sb()
> > > [39/54] functionfs: fix the open/removal races
> > >
> > >         ... and back to filesystems conversions:
> > >
> > > [40/54] functionfs: switch to simple_remove_by_name()
> > > [41/54] convert functionfs
> > > [42/54] gadgetfs: switch to simple_remove_by_name()
> > > [43/54] convert gadgetfs
> > > [44/54] hypfs: don't pin dentries twice
> > > [45/54] hypfs: switch hypfs_create_str() to returning int
> > > [46/54] hypfs: swich hypfs_create_u64() to returning int
> > > [47/54] convert hypfs
> > > [48/54] convert rpc_pipefs
> > > [49/54] convert nfsctl
> > > [50/54] convert rust_binderfs
> > >
> > >         ... and no kill_litter_super() callers remain, so we
> > > can take it out:
> > > [51/54] get rid of kill_litter_super()
> > >
> > >         Followups:
> > > [52/54] convert securityfs
> > >         That was the last remaining user of simple_recursive_removal(=
)
> > > that did *not* mark things persistent.  Now the only places where
> > > d_make_discardable() is still called for dentries that are not marked
> > > persistent are the calls of simple_{unlink,rmdir}() in configfs and
> > > apparmorfs.
> > >
> > > [53/54] kill securityfs_recursive_remove()
> > >         Unused macro...
> > >
> > > [54/54] d_make_discardable(): warn if given a non-persistent dentry
> > >
> > > At this point there are very few call chains that might lead to
> > > d_make_discardable() on a dentry that hadn't been made persistent:
> > > calls of simple_unlink() and simple_rmdir() in configfs and
> > > apparmorfs.
> > >
> > > Both filesystems do pin (part of) their contents in dcache, but
> > > they are currently playing very unusual games with that.  Converting
> > > them to more usual patterns might be possible, but it's definitely
> > > going to be a long series of changes in both cases.
> > >
> > > For now the easiest solution is to have both stop using simple_unlink=
()
> > > and simple_rmdir() - that allows to make d_make_discardable() warn
> > > when given a non-persistent dentry.
> > >
> > > Rather than giving them full-blown private copies (with calls of
> > > d_make_discardable() replaced with dput()), let's pull the parts of
> > > simple_unlink() and simple_rmdir() that deal with timestamps and link
> > > counts into separate helpers (__simple_unlink() and __simple_rmdir()
> > > resp.) and have those used by configfs and apparmorfs.
> > >
> >
> > Hi Al, when I apply this patchset my Pixel 6 no longer enumerates on
> > lsusb or ADB. It was quite hard to bisect to this point, as this is
> > non-deterministic and seems to be setup specific. Note, I am using
> > android-mainline, but my understanding is that this build does not
> > have any out-of-tree USB patches, and that there are no vendor hooks
> > in the build.
> >
> > My apologies as I can't offer any other clues; there are no obviously
> > bad dmesg logs and I'm still working on narrowing down the exact
> > commit(s) that started this, but just wanted to send a FYI in case
> > something stands out as obvious.
>
> Note that I had to revert commit e5bf5ee26663 ("functionfs: fix the
> open/removal races") from the stable backports, as it was causing issues
> on the pixel devices it got backported to.  So perhaps look there?
>
> thanks,
>
> greg k-h

Thanks for the suggestion. I tried a few different setups, and now I'm
fairly confident e5bf5ee26663 ("functionfs: fix the open/removal
races") is the culprit. I did have to revert 6ca67378d0e7 ("convert
functionfs") and c7747fafaba0 ("functionfs: switch to
simple_remove_by_name()") to successfully build, but reverting only
those two in isolation did not fix the issue.

Al, please let me know if you have any other variant of the patch(s)
that you want tested, otherwise feel free to add these tags as
appropriate:
Reported-by: Samuel Wu <wusamuel@google.com>
Tested-by: Samuel Wu <wusamuel@google.com>

Thanks!

