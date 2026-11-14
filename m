Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB2DF606A884
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 23:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=laT9YiOW
Received: by kanga.kvack.org (Postfix)
	id EA5ED6B00EF; Sat, 14 Nov 2026 18:20:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E56AC6B05B0; Sat, 14 Nov 2026 18:20:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1F8A6B05B1; Sat, 14 Nov 2026 18:20:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B90F6B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 18:20:13 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D47891A04B5
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 23:20:12 +0000 (UTC)
X-FDA: 85435295064.02.F8810A0
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf29.hostedemail.com (Postfix) with ESMTP id D464312000A
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 23:20:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=laT9YiOW;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=amir73il@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794698410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=98mXXJR5XCg4Z4S2yqrizowpYg4fQiN0pgPOU/BiUFY=;
	b=HahTW6OTil4G+MtRBWa3MFMfnLeExqMFe+Maq4nJM3RX6BoM0247GRQbf4HDEFPfNBE/nq
	hbvO7mdzA4ngdmpmWaSfK7AYRHxTF01ritUjZU2P9xqPGScLZXdnXCfSpdVPtRet28trBR
	825bRtcRgjKfSkOzi1aLh8zp/IHIhUE=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=laT9YiOW;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=amir73il@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794698410;
	b=yordWUIezc8+o2FkyVNeSAQVEN1nRrJj3W0JORGbHtOHgx4FkTrkxuP2DJkWnT8lx/Eo8t
	0ToxBSixZ3ONs7O+coMSsmn6AOif7n0JoG8sHmuv9mKk18EFUmNhSJ+cbAMp4CAh1W0WLo
	ixlUVRLAFSUfvZEEHxLrld/r4yuHnXo=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6b58cb69927so3771028a12.0
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:20:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794698409; cv=none;
        d=google.com; s=arc-20260327;
        b=hLhwFk8WeVafC3btfumfXElRWH9EVGNPUdpYg3jwQh5KXmdC4NaLUxuPqasbVgtZ8/
         F1AhDk38ZLYHSY4Xxs3tySvtReTJI+ybwH0bWrjN+Ga50XSfmYZ29oyk5ySXzx+YbJOX
         AFVM9aQxQYIS5ysSWwPnP36FFfM94Qb1ez7FJR3RpRmesRj5yiF5jHI2sWjswROXMxV+
         jtmcnm43pwz1FuzjmteI0npFtyRgnkb5D0zhGRR7dQESac03sDGoCty3g+kvcLxXtJp8
         AG8g5MvjmlXH4F6kwiDUCw+uXtwVtyIf7v7mkO3GNy0L1n5k/8HI/SxfWrz2tOMF4b4v
         OQ5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=98mXXJR5XCg4Z4S2yqrizowpYg4fQiN0pgPOU/BiUFY=;
        fh=DBb17qeqUl/AmUVpVEewEPzMKkPUNco1BR+qP/m9otI=;
        b=VQk5sbR4odPnD2WqXeh2kJNtpY6gbbGtTGpOpwwp5pjCw6A5UnoV7VTZk9g3/4bxyr
         IsVPnTuCxk2B9BbZm/HXIvPSp1QnXzni0vtRivQ4GnEIX6k37UQKiuSsQjTEuQ4598Ps
         OKlCh28lCzpE7ZoenM0cP5Zp2HBnUiH5wAnINiUqPeCyMi2Vc0+zztEHlRzLuefuXj59
         MUH5uVu6Oi6hZyWH6YnT8xREjjQcW4oCIvItkE1zGn/aty0hER1RkD0Hw30mqPmh53Wl
         BNCeigcN6EW+/tJLB1+sxvo0U5DL1qloIld8iNhxI8oV5heT7W1UgXCBVSDY37wDqbkv
         MZ+A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794698409; x=1795303209; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=98mXXJR5XCg4Z4S2yqrizowpYg4fQiN0pgPOU/BiUFY=;
        b=laT9YiOWVVNVrWLpt2qVlIevN1Dy62XPMIW2bNeOYqc9Ahb8GGyhuAHBhOkuxWFJIP
         1XM+PUSqVsxW8knxldcD+gOHxJXLwF5i9ED6RcWJKjey45pqMSLFI0jsI/33y5J2tDA5
         n1CmjBfEB1gessS6ngtoPE5Mr7vQblzR69mgc+HLA0PDM/4eULXKU05JdiEFYSCQB3zu
         D6J5hT/v6nEDX5ke1jXZfSYorNMmu6Bdb737GjadTYTkmbiOGLRvxpvQegMZTvx+3oe4
         ZIQCRt2hhDMqYinQnkyGDxOu6K/CDlG6eIW9omptXZm9rfzvv7S7aebSoRcUMt7CMTNE
         4uJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794698409; x=1795303209;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=98mXXJR5XCg4Z4S2yqrizowpYg4fQiN0pgPOU/BiUFY=;
        b=gDWTQcCRqDvccot64qZOMOYds+TmP7SFOIHUFORvPI9mcXJmlsoxb0SPOojQyO3QQU
         Mj6Rau4wsD17/yQQjRD8gFmRTzKCnkWhuX6MDfNMlH0AjAId5OulGERe2pVzRl93ayTg
         2UqvIVB0MTUbiUt7UsPm03InbevG7pDi8JZlboGoV1g9gtradQSTJXhBMD7JjYe8FfKl
         d94kC8hqRi1d9T+PkcvlKLKUTzi4Xz4tD2bM+QMr6Y2WbOiRYqp0+FUeq1h5Ci0sXh9W
         ejgolvzReM6/U1EvchzP2hKigv036vgvVgaAS4x1qEfTOJCqcctVpjlCTYcIceDM7BO5
         97vg==
X-Forwarded-Encrypted: i=1; AL+hErFtvtwF40Sep+7BoG3FtdNYcaABvOCjorv0IU3QBFNf+BGRcQPGhDzakaCLeOtCM+yeQyAH48YFMA==@kvack.org
X-Gm-Message-State: APuU4Z9bo2D0l42fpxjdSAXZGOZ4/+HvRRGIOPcvEzziutCkVkDy8rUJ
	gLjWg0Fe0pwrVOHAJYrCFsR1wP+zBTVx8lzmKdLK+lP2DF0vRxgmQCWBILHJAnXRWuj9p5HxaKM
	V5m+x82CmhcwggD/pGy4uRKrGJL2/s/A=
X-Gm-Gg: AYBFou02BK15rsyIkUliJlP82DD5V7OAQ41KA246gPqymo69uzlfci7lJOGMcvE/WOu
	AM1KvG2SFtwDLTaEll+IGSp9luQITiRdn6MUOAz0vAtdE4dser/QIAr+/pDkKvMXiuhzbCr4sKw
	vfPgTZgvplDQZ+kKjTy77SZhtpF2mS1NdhrAbpVvAGr6rR/7gCT3mE/1ksYO1up+3NjaHBjEObg
	aboH74aPHRy5Fszkj7pM1+vtPXvmarUfeyuvOKcfCsP3hY74Sa+5Bj17eOeQYd6mMSVKkASGuJR
	il6K+4WbA0tvx3EjzTAeRlYpzW4r72v+CdS9ULairxvN3eibQ6pM8FLX+errvj6vl6dF4lElocq
	fx3FPpvJCaEzrqi+v5FVSaCbbkMSFihJvgk/ccdBkmkW5p2EzwuOWnOcGFZbQWFTE8TSIPw==
X-Received: by 2002:a05:6402:e10:b0:6b7:f00e:5e56 with SMTP id
 4fb4d7f45d1cf-6b7f00e5f37mr1542816a12.1.1794698409123; Sat, 14 Nov 2026
 15:20:09 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
 <20261114-work-loop-pseudo-v2-33-98639a2286fb@kernel.org> <20261114120557.4bc1eb6e57218cdc@chrisdown.name>
In-Reply-To: <20261114120557.4bc1eb6e57218cdc@chrisdown.name>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 15 Nov 2026 00:19:57 +0100
X-Gm-Features: AclHuK_YVxhIpv6JLzeNAX5mX5IHGfu05WS6uQ-TCKewxE3JKeci2PyA-UDMCbo
Message-ID: <CAOQ4uxhGxpBtMZ5kfuzR1tQAewiecoX7UjXQRo91QjJHH9T_Yw@mail.gmail.com>
Subject: Re: [PATCH RFC v2 33/42] fs: add file_check_backing()
To: Chris Down <chris@chrisdown.name>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, 
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org, 
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-usb@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D464312000A
X-Stat-Signature: 7t1pmema4f1u86n5xtpphbusp886nqzj
X-Rspam-User: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794698410-531819
X-HE-Meta: U2FsdGVkX189Vs/MJ5j8DlSDPx06eJaeoUr3OEV56b66bVUtPlDs5en5yXDMIL6JhnupdGN00VJjGJTZ255jDSDQ/R4aPgN213NqJNXa18f4pTvFGPYCxzPgK1Bungb/h0R8PZd3/aIIQNl01AugMmlqbFfrDqFQQp/yr4LhHo4syDXdmEa1t6/r5HAQ4Sd8a9rz7/Tkb4AQf3gftPBJJ+M5aCwttCsGBJobsg4cV9uPgVIUXu7L9ObYcc6P/qunaXwYYRaBnyo+deYvbzvU/XeM2GZeVNBKzczfSzTbDwwpgSHLUhXNNdCJOpgBq4xh4sEb/8T48fhwqdcBooFCBMuxnQr/1fScSNqcK8VHoKznDRjQXQfMSPABORoGILjV/OumLV4K68k1UOSbpOH+6nz679BWmQMK6WyOSeoSXsoae24iLTEhSW/bxsQGpZqoxEQWPmU+/ye5ifbBoP67n/IsO8pa/FPir47MLcr/FccPvu38gRVQthuglliNFUCmf0GOg8HP8zGKnEn2RwHcx/JpvNA8PqwY8duN0SyWVVme2y8IXAbAPKSPue9goZYUG1IOcqMqX1MEhpIoTVyqFCRm8qCgYFbWYqv3hipL/YUk4hmwe3yz1RB35wTBqNUcnVoH6q41MXiyFAAPE7IRYBn7I6ifYK9miMGIa/s0Apb30HVLjORj+3rxLxBHE0tEsbDJTcExN2lL6AggbDhHOUpdGjTUBCfoQZ9X9BqVv7uU1QZyn/9a0Ug3TlvBS+tXUTP/bkzvgO4Q9Ro8JqjthvU26vHHD0DwMxjD5WgkrAMPlpx1iJzaUANSPcJDG6iexcQ81EG9/ZcL9YKFljWjpkwzct34mt09+f3S/Nw23Xsru/BXLjyOh5UYe4t91+Q4x7zyF5XZqlOpdRHkuW/pkowQ/JaZ4pk81jYOR8qk8es9RdyulwLh905T34yisnQX/Z38GefUpoNX/EnQKfo
 U9nzWMqE
 OiKbzZI5odkrPqoDKD2TLMhSOLAigTzZzPhsTtyaYxDxFInh8Ly0YyE1F43aiGCVG4xPTulB0RT09/tcJYhDI6eeXntvzCAWTtMQJXTXE4XYw8cFxKOntAmip4PrqlnU3lDoKT3pct/fEPW2/2F3sLk4iWQktcFvZadcKwmgm5Kj2XbNF/O0Ozg1gKYFDZURwvw44DitIE6D6lhsiLKzPvZqb8tKH8lN4dKoaDoG8olA37CEj3bbMweWI0sLlCk4U0fMrMa+/tPDXJU2NpZeE/Z6eAWCkXRrfrZlxBwVbrCMz5Uu7Sx7nXgvmwXomgt7g8SAN8HVa84gB/t4hWvgATBdeAqlLYg91MVhIGROGWlJ1BM0GJ8Ca4TKHdKlg6KxPNCVSe3+inairvNjFmiodch0YaM65Lr0uKFA3gbN8lEs8AT2OKRLOVw/zbfoG5+dCEl7h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 14, 2026 at 9:06=E2=80=AFPM Chris Down <chris@chrisdown.name> w=
rote:
>
> Hi Christian,
>
> Christian Brauner writes:
> >+      /* Look through stacking filesystems at the inode with the data. =
*/
> >+      if (d_real_inode(file->f_path.dentry)->i_sb->s_iflags & SB_I_PSEU=
DO)
> >+              return -EINVAL;
>
> This looks good in general, but what the bots said about O_PATH files
> here is real. With FMODE_PATH this is reached for a file that was never
> opened, so on overlayfs nothing has been through ovl_open() to look up
> the lowerdata of a metacopy file yet. ovl_d_real() then does the lookup
> itself, and when that fails it hits the WARN(1) at its end and returns
> the overlayfs dentry, so the check passes as well.
>
> Only fuse passes FMODE_PATH, so it takes CAP_SYS_ADMIN to get there, but
> it's easy to trigger with that. From a quick test with a metacopy file
> whose redirect into a data-only layer points at nothing, registering an
> O_PATH fd of it with FUSE_DEV_IOC_BACKING_OPEN gives
>
>      ovl_d_real(/f, 0): real dentry not found
>      WARNING: fs/overlayfs/super.c:79 at ovl_d_real+0xc9/0x210
>      [...]
>       file_check_backing+0x308/0x5e0
>       fuse_backing_new+0x219/0x4a0
>       fuse_backing_open+0xe8/0x390
>       fuse_dev_ioctl+0x53a/0x7d0
>
> and the ioctl still succeeds. A normal open of that file fails with
> ENOENT, so nothing could have used it as a backing file anyway, but with
> panic_on_warn this is now a panic.
>
> Maybe ovl_d_real() should just stop warning when the lookup fails, now
> that it has a caller that isn't trace_uprobe?

Yeh I guess that this needs to be a Fixes for lazy data lookup.

The correct fix would be to teach all the callers to deal with an error.

> The check would still pass
> for an O_PATH file whose lowerdata couldn't be looked up at that point,
> though.

One observation relevant to this patch set is that a datadir layer has no
business being a pseudo fs and that can and should be blocked explicitly
at overlayfs mount time.

The other observation is that fuse_passthrough_open() should probably
check the backing_file that was opened for io in addition to checking
in fuse_backing_open(), which could have different FMODE and specifically
could be FMODE_PATH.

Thanks,
Amir.

