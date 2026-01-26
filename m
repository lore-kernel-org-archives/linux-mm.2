Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FB74D1950C
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 17:20:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65C566B0099; Mon, 26 Jan 2026 12:20:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 609AC6B009B; Mon, 26 Jan 2026 12:20:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 508D26B009D; Mon, 26 Jan 2026 12:20:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3E3746B0099
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 12:20:58 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E5AD4140832
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 17:20:57 +0000 (UTC)
X-FDA: 84374780154.07.60FF1F7
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf05.hostedemail.com (Postfix) with ESMTP id 007B9100009
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 17:20:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gnVfs5ro;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769448056; a=rsa-sha256;
	cv=pass;
	b=n9TbiqLgew66XAsPasd/dPhKUCsnVkdQvk+tEaqlwY6KLJG1q6JmUkBGeSlo3dkdylR3UB
	RAHKYWVK6xYjeb/A6wyhwNSy67fUUNN/qs5wXwk1rCggteK0eZYD0i6N1QRYU2OKrKwQyt
	gYPbV1+9WC7wDqGffDnzpR8gBkgVaP4=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gnVfs5ro;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769448056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p7APez++HU18X32QySejJYuFhFmHW/DtgVmQ1nohA+Y=;
	b=evko749A/uxI0CkLDUii6G4SnB4D5AqDE0POiXzsF93mO8pyUomxYahigMGQ4tZyoC4CBr
	PET1Jjd1FhzXTEi7Bj1m3RZU+BRkxvdeCC0BiKHCMiY2wVy+klJGQLZecdg4nzjq9sxIMx
	4DLzMNArR/MgA63UvWEKxiw3DPChnns=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-501511aa012so1106381cf.0
        for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:20:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769448055; cv=none;
        d=google.com; s=arc-20240605;
        b=g1yfCiv2Z47p6zyqCGH/GzaUo4DRPbUq2fdT75egFVfC6Rnt7tVR9yvAwGq+mJGWVO
         LrKnntCAWBTJ1tt4kqyGSw6K/0B4cbvH0NkujXA3TUF+KPb9WxPAE4/7uAN0H9yhq9rx
         01p4bEs5M6XQQy1Qvb19mEHKjFZ3D5xi5LwbC1GCnDFH9+ACgG3pAZYM+BsXAdTMUsLM
         bO7GLzKFVenkj7p/lrsv3KKGgnncS/HzDrhltZhXxCeDHhu3iKeS52NrybaIuSHdXBZi
         gkSozgDnOugQRARmw4u8WSObiGirlfOYnp9kQB/6ASstIFPTvZ6HJf3ieC/2S2g4vTgD
         m83g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=p7APez++HU18X32QySejJYuFhFmHW/DtgVmQ1nohA+Y=;
        fh=WpC4k8CbPu6glXtcIz8ZQFiKIhKtCBHKOlolg9dusl4=;
        b=iZKF67bkr7DpGCFNU5nGE9AqykDgIOa5gND/9eDmDPsJXapOMFDFjyf1jhNMqzVeZW
         ocxliOBkhCsvlLJOCQ3cdISt5phJVLtKp9ULiWCr8wO5OrtNzxoex2B/GWS93/L736a9
         8MXjC/ads4gZTVwimSrke4bNaIXKv+MADbIFxKyVpXnYT0olLw37nGzpVhDcbDTqMhOd
         hTYchBUetCLCl13TiwSNTRe8vEM2Ca9WAMaVer5twG/pZ2yi0kARlbzQhYZihtoHLzhJ
         P03C5IiV1fg1/hMrxLkUnoE2NSnzQuiYn2gAdRzDxJi4Yb7ceyC0NBpblxf9YlFvcpvC
         QbXA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769448055; x=1770052855; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p7APez++HU18X32QySejJYuFhFmHW/DtgVmQ1nohA+Y=;
        b=gnVfs5roxCeJi1rpQ4P6o6SevVKlg1/7q56IFQ7QXRBCrIGvoBsF0Isb/1k7aAjc3J
         37xfjdUlEIAEtMMTv2jJ1KVavZ3tB4xBPq+h7s67eJ9bPpp/Ni5TgEtHs57ULzNqE5XS
         Qi0HptIF9UiWnWCToe4dUz8q0JHd7yFdc7TFmo3TIcX3njEDC5Kx8Ct/DguykjVO4mbc
         R3i+Tp9jVL8bEB83YyjrrxGIX2zz7G/QoDcFMoGvyjtRz90KkNxrBJNkej3Iu/B/hUPC
         I+KWG9/Gu62pI7Dg6gWvzcvdbc22ZMLRfDWZFqEchnn9NzxNpjD1BYQLOcWbjA5eVb7Q
         siEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769448055; x=1770052855;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=p7APez++HU18X32QySejJYuFhFmHW/DtgVmQ1nohA+Y=;
        b=OdO0MTi0FHTpLdaImkdaE8zQgIjnrR6FnUrPmVklqqjCBlq8nY+5IG8qtlSdetcXT/
         5f16pRYQOyrc2rNbpOaHrStolJy1UedqoZD2SlgflAUQLhLppJU8et0t4BrXP2QNRCTL
         rQtdbOf0IjyiKs4SUxUbNijV2NnUwG/6u1I89DKg+IHqBTdZzwfzl1COMniTo3DOcKKI
         RYLjBKTIDBXIecE0Tdx/cHkPaesfSiYuc6QKGi6Wso4/Yu9TX47B/I6+fx/ITD5l/bNi
         E1e8mINIhkJqqCijMUfKckL2R3q5IdzwRgMAxsAdlB20U3z/9G4tprYwVA0fNp+PjZtH
         pMng==
X-Forwarded-Encrypted: i=1; AJvYcCXAlhcb2AwIGuy+dXrTzy0eZ4K3CrTd6girk9X08TuebTK+HuikcR/bRO13D+NqRIarrQnOZ5sAeg==@kvack.org
X-Gm-Message-State: AOJu0YzDURvvFRMjKVWkvtcAh4k54Md6JMX5/OcJKatxsgSTWoiEKvxb
	/nOoJHwQnt8qgjy00slbwGx/H2dvroBQPdMpymcy9ZXIhZhvRWIzntDFN5O5YHozE5FCMU3esg3
	Wjqn7i8yRJ+VYNO7RUmUAu5mbpimXmOY3JvedE/Y8
X-Gm-Gg: AZuq6aLTJxQUixhGg6I0gf7mTBzwMRBClIHvLu6dxNkyKE3uYNRitbTQF35dvqbbtUp
	SpFZ26uMdG6iwD9QzFxqQr8A9JRES6tAKNouxgjZAjuLTlIbTXeAL7ZdktZNOyideduHWEfnGkM
	2MRb1+vFYAYjzt1f5Tv0GSF0+iMbahnQNp3qQOeDuqv0MWE5Bn1DmDSgCjNNHjtqn0+D4v/5zbr
	3CjYcZxRFtusVF3nsf5kJwlI8XxvbWCTYuHFIQFRcIdb8yY+nUAYpu7WLTYSbfRoEJI4A==
X-Received: by 2002:a05:622a:1:b0:4ed:ff79:e678 with SMTP id
 d75a77b69052e-5031460c5bbmr12761811cf.18.1769448054567; Mon, 26 Jan 2026
 09:20:54 -0800 (PST)
MIME-Version: 1.0
References: <697400dc.a70a0220.35de72.000a.GAE@google.com> <20260124113148.2398-1-hdanton@sina.com>
In-Reply-To: <20260124113148.2398-1-hdanton@sina.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 26 Jan 2026 09:20:43 -0800
X-Gm-Features: AZwV_QjN0MTy89Cv_uUZhJM67pJS7MJrnu33QJJk62Z-m3gDLWs3VFenxC3gr_g
Message-ID: <CAJuCfpEcqAiK-z=EZ5im12F2wfGHYogiMHaTC4t5uopLmBKQPw@mail.gmail.com>
Subject: Re: [syzbot] [block?] possible deadlock in blkdev_read_iter
To: Hillf Danton <hdanton@sina.com>
Cc: syzbot <syzbot+4e70c8e0a2017b432f7a@syzkaller.appspotmail.com>, axboe@kernel.dk, 
	linux-block@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 007B9100009
X-Stat-Signature: ikps59wez7jedu9qzef3yj1mi6tuoa7g
X-HE-Tag: 1769448055-493245
X-HE-Meta: U2FsdGVkX18ADY0QX0+JMjeKu8pyl53XZ2lXxALHKHWLmCZiXoenMk4Zs5OrkO+YxgJQefjiFkuOLZCUfxqUiVDvyrF48XYRVk1wQqZrQEp2JSm3W0DMhJgshEUtn0GO1OLgX7NsuLy58WqXcqkFzbfOReE7Qvu61jEDp4dKvDkkEZAZzg0adJq+VNe5Vgu7TkIJ818s0IfG0sbjexHHFliVSyLbs1SIozjNuFX2Us018XvIXnPd0aBilRGjIdMABmDrDHz6uDTvI3QRXUFYDP6WNuT0FX0H8o3qlrmyLWY7fwXMjxNoHPrK1K8Ph4PG1vOl5D22DmXmwdJ8rPkiyxyHcuQFZwieVbNbZfLevL0uOVerjcHu+zWO0RaWsYCQ8LwDXW9iiqbNKYoayTE4k5+5cozxYr+JpXeMDSz7l2WZryvUsbG7QhwBp3y8p/PT9a/VOv96jDcryKlXgpcume8zPiMqZl2jnJyteIHjZdKkNqYzzK043blpQy9ys9PFjO3MedkS2fYb6CkREXTlA7MKKQl2AC1DkrgZIAG683eO/VA2cSrvLpiCZ+m3dFM1kGLBz8e2N8aKHsXS//+bMG1Ur9CamsI+3qegNuNqOvbJAVgs6d9UXCyyzf3HAiDUDpLtGVlRKQeOVFF5Svqi81CWKc9t6jIGRHPxbQYWHaLgmnpvLoy6qFC42xiuFa+CHVXSLfCKnqlbubdRT6kjmJV3+R71u+qwiIxDsrEozJbjO1P4yYSGe/TrIFZokRw2P/gWNs/JVJpcIOuGV6g1h2pdkBSg8tK6OAYGY3jyg4VTkzmo5WuVOwHuTWa63tgUZIYxU35COBywODpM9o8KrH09v38JauRyG2lM0cJHpwns61b/a1bCgqdxt5Kb2aJg0bUcRPKa+d3FPA0kGb7Y7Xwutw2wjLoD8apB0v/acEX4fqDY8udr6wRC3zAJ3d3YNsdFDSYHY28ab2WSGmu
 59Sihn8y
 ft//Gp7i/nJTXloyeWlIh3Kbl6Zt4GwJmRI/g01UPZQzsOkKOvCwfkb+/69QGZgTole2jUMJe9l9lbPSE0KmeDe5tT8xoc3dGHzozD2kKk8CT4ybSEByEWEsArT9OHN6FklI6KIWfjgsHLNcXrCCrpL3Uz5IyXZUsUXUn8Kl1tXAAQafb8+IFxFrxUJsPq1GFMuHGeltwP/9l6m/Q06EWYV+Cd+S+cAtIPtuI4N9MJhZF9u4v/nKopZezYivrV4VLHnwe2pCx7sXuTIw66qk7oxiq9UKUghYpvs8h1xdSMBF33OeZ8qmOfqiEBa3x7ho0ipcJLcnHrNcsm5jMzZLbKV4VjEA0+tD6X/zzeD+44Lj+Mkqb0QcSuSu29buKXYiCRzzZEsbV2Htrv0qo10UnfWtGslzVL6PByHsI/ezme9V2Cg3uOBgL4AOQ26H2ZM4jag9pb28XvufFuvtFmnHjW87Pf6qwyG2u91xmGp1cvRuEK14+iCWycf2AIqkU2FpRD7FqKKEV9Y161CsxCNB+MOOi9Winf0j8nhVuqktK8eKntcgiH2cXQXh9C6fOSL1NCq/ba05vJHYKXhEqAmFY8+ZmBU0X/Gw2tfFizJuuCt5hGnYdZJEFp1m3sf/cr+PXxVS68T9AxnnLp6yWBl8CzYsY6qwlLXPa1+XcC8TtIkdEUYOwokzkyjS4TGsw/w0387TrBVFlrwDu+PFky/Bf/rvQl1sgQikVwsRRTe8wSFsxENC+mPtlk246oCjfKrHSWzEwV1bTdS6v2sFPtIykbCgQH6E/WKr2MoWmYDmro87/pNVyWaWRXAGZql50UPgfMbL0e4sHji22k+112V8Q4Rzxm8CMzGFYiqGM6VTAD9yi9zikIFtSNeSOjT48erhgP141aqeVBqY5uTEyy+cEg0+WQXYhPI5hJqz91AlZTQS6+LWlgytHIKTCpJzWmpQNLBn1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 24, 2026 at 3:32=E2=80=AFAM Hillf Danton <hdanton@sina.com> wro=
te:
>
> Add Lorenzo and Suren

Thanks!

>
> > Date: Fri, 23 Jan 2026 15:14:36 -0800
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    24d479d26b25 Linux 6.19-rc6
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D100033fa580=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D18594768328=
63c41
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D4e70c8e0a2017=
b432f7a
> > compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binu=
tils for Debian) 2.40
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D11451b9a5=
80000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D1045e852580=
000
> >
> > Downloadable assets:
> > disk image (non-bootable): https://storage.googleapis.com/syzbot-assets=
/d900f083ada3/non_bootable_disk-24d479d2.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/d0f3c47f6869/vmli=
nux-24d479d2.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/800231513703=
/bzImage-24d479d2.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> > Reported-by: syzbot+4e70c8e0a2017b432f7a@syzkaller.appspotmail.com
> >
> > WARNING: possible circular locking dependency detected
> > syzkaller #0 Not tainted
> > ------------------------------------------------------
> > syz.0.17/6091 is trying to acquire lock:
> > ffff8881061287a8 (
> > &sb->s_type->i_mutex_key#8){++++}-{4:4}, at: inode_lock_shared include/=
linux/fs.h:1042 [inline]
> > &sb->s_type->i_mutex_key#8){++++}-{4:4}, at: blkdev_read_iter+0x19e/0x5=
00 block/fops.c:855
> >
> > but task is already holding lock:
> > ffff888012aa0448 (vm_lock){++++}-{0:0}, at: lock_next_vma+0x10e/0xed0 m=
m/mmap_lock.c:334
> >
> > which lock already depends on the new lock.
> >
> >
> > the existing dependency chain (in reverse order) is:
> >
> > -> #2 (vm_lock){++++}-{0:0}:
> >        __vma_enter_locked+0x260/0x770 mm/mmap_lock.c:72
> >        __vma_start_write+0x21/0x160 mm/mmap_lock.c:104
> >        vma_start_write include/linux/mmap_lock.h:213 [inline]
> >        mprotect_fixup+0x4e3/0xb80 mm/mprotect.c:768
> >        setup_arg_pages+0x4a2/0xbb0 fs/exec.c:670
> >        load_elf_binary+0xb5b/0x4fe0 fs/binfmt_elf.c:1028
> >        search_binary_handler fs/exec.c:1669 [inline]
> >        exec_binprm fs/exec.c:1701 [inline]
> >        bprm_execve fs/exec.c:1753 [inline]
> >        bprm_execve+0x8c2/0x1620 fs/exec.c:1729
> >        kernel_execve+0x2ef/0x3b0 fs/exec.c:1919
> >        try_to_run_init_process init/main.c:1506 [inline]
> >        kernel_init+0x14a/0x2b0 init/main.c:1634
> >        ret_from_fork+0x983/0xb10 arch/x86/kernel/process.c:158
> >        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
> >
> > -> #1 (&mm->mmap_lock){++++}-{4:4}:
> >        __might_fault mm/memory.c:7174 [inline]
> >        __might_fault+0x113/0x190 mm/memory.c:7168
> >        _copy_to_iter+0x1c2/0x1710 lib/iov_iter.c:196
> >        copy_page_to_iter lib/iov_iter.c:374 [inline]
> >        copy_page_to_iter+0x12a/0x1e0 lib/iov_iter.c:361
> >        copy_folio_to_iter include/linux/uio.h:204 [inline]
> >        filemap_read+0x6b1/0xe40 mm/filemap.c:2851
> >        blkdev_read_iter+0x1ac/0x500 block/fops.c:856
> >        new_sync_read fs/read_write.c:491 [inline]
> >        vfs_read+0x8bf/0xcf0 fs/read_write.c:572
> >        ksys_read+0x12a/0x250 fs/read_write.c:715
> >        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >        do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:94
> >        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >
> > -> #0 (&sb->s_type->i_mutex_key#8){++++}-{4:4}:
> >        check_prev_add kernel/locking/lockdep.c:3165 [inline]
> >        check_prevs_add kernel/locking/lockdep.c:3284 [inline]
> >        validate_chain kernel/locking/lockdep.c:3908 [inline]
> >        __lock_acquire+0x1669/0x2890 kernel/locking/lockdep.c:5237
> >        lock_acquire kernel/locking/lockdep.c:5868 [inline]
> >        lock_acquire+0x179/0x330 kernel/locking/lockdep.c:5825
> >        down_read+0x9b/0x460 kernel/locking/rwsem.c:1537
> >        inode_lock_shared include/linux/fs.h:1042 [inline]
> >        blkdev_read_iter+0x19e/0x500 block/fops.c:855
> >        __kernel_read+0x3f3/0xbf0 fs/read_write.c:530
> >        freader_fetch+0x1d7/0x9d0 lib/buildid.c:100
> >        __build_id_parse.isra.0+0xdd/0x6c0 lib/buildid.c:297
> >        do_procmap_query+0xb0e/0x1080 fs/proc/task_mmu.c:733
> >        procfs_procmap_ioctl+0x9d/0xe0 fs/proc/task_mmu.c:813
> >        vfs_ioctl fs/ioctl.c:51 [inline]
> >        __do_sys_ioctl fs/ioctl.c:597 [inline]
> >        __se_sys_ioctl fs/ioctl.c:583 [inline]
> >        __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
> >        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >        do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:94
> >        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >

It looks like:
#0 is executing PROCMAP_QUERY ioclt, read-locks vm_lock and then calls
build_id_parse()->__build_id_parse(...,
may_fault=3Dtrue)->__kernel_read() which eventually takes
inode->i_rwsem.
#1 is a file-backed page fault which asserts that it might take
mmap_lock for read.
#2 is load_elf_binary()->mprotect_fixup() which write-locks both
mmap_lock and vm_lock. I'm guessing it already holds inode->i_rwsem
before write-locking these locks.

Originally I thought the issue is most liley introduced in
d9d1c2d81797 ("fs/proc/task_mmu: execute PROCMAP_QUERY ioctl under
per-vma locks"). But if #2 indeed takes inode->i_rwsem before
write-locking mmap_lock, then the problem should exist even before
that change when we didn't use vm_lock and relied on mmap_lock...

I'll try to analyze this more before attempting a fix.

> > other info that might help us debug this:
> >
> > Chain exists of:
> >   &sb->s_type->i_mutex_key#8 --> &mm->mmap_lock --> vm_lock
> >
> >  Possible unsafe locking scenario:
> >
> >        CPU0                    CPU1
> >        ----                    ----
> >   rlock(vm_lock);
> >                                lock(&mm->mmap_lock);
> >                                lock(vm_lock);
> >   rlock(&sb->s_type->i_mutex_key#8);
> >
> >  *** DEADLOCK ***
> >
> > 1 lock held by syz.0.17/6091:
> >  #0: ffff888012aa0448 (vm_lock){++++}-{0:0}, at: lock_next_vma+0x10e/0x=
ed0 mm/mmap_lock.c:334
> >
> > stack backtrace:
> > CPU: 2 UID: 0 PID: 6091 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT=
(full)
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-=
1.16.3-2~bpo12+1 04/01/2014
> > Call Trace:
> >  <TASK>
> >  __dump_stack lib/dump_stack.c:94 [inline]
> >  dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
> >  print_circular_bug+0x275/0x340 kernel/locking/lockdep.c:2043
> >  check_noncircular+0x146/0x160 kernel/locking/lockdep.c:2175
> >  check_prev_add kernel/locking/lockdep.c:3165 [inline]
> >  check_prevs_add kernel/locking/lockdep.c:3284 [inline]
> >  validate_chain kernel/locking/lockdep.c:3908 [inline]
> >  __lock_acquire+0x1669/0x2890 kernel/locking/lockdep.c:5237
> >  lock_acquire kernel/locking/lockdep.c:5868 [inline]
> >  lock_acquire+0x179/0x330 kernel/locking/lockdep.c:5825
> >  down_read+0x9b/0x460 kernel/locking/rwsem.c:1537
> >  inode_lock_shared include/linux/fs.h:1042 [inline]
> >  blkdev_read_iter+0x19e/0x500 block/fops.c:855
> >  __kernel_read+0x3f3/0xbf0 fs/read_write.c:530
> >  freader_fetch+0x1d7/0x9d0 lib/buildid.c:100
> >  __build_id_parse.isra.0+0xdd/0x6c0 lib/buildid.c:297
> >  do_procmap_query+0xb0e/0x1080 fs/proc/task_mmu.c:733
> >  procfs_procmap_ioctl+0x9d/0xe0 fs/proc/task_mmu.c:813
> >  vfs_ioctl fs/ioctl.c:51 [inline]
> >  __do_sys_ioctl fs/ioctl.c:597 [inline]
> >  __se_sys_ioctl fs/ioctl.c:583 [inline]
> >  __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
> >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >  do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:94
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > RIP: 0033:0x7ff1a238f7c9
> > Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89=
 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 =
ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007ffebbe538b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> > RAX: ffffffffffffffda RBX: 00007ff1a25e5fa0 RCX: 00007ff1a238f7c9
> > RDX: 0000200000000180 RSI: 00000000c0686611 RDI: 0000000000000004
> > RBP: 00007ff1a2413f91 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> > R13: 00007ff1a25e5fa0 R14: 00007ff1a25e5fa0 R15: 0000000000000003
> >  </TASK>

