Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BA55606B137
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 10:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=AvpCnLTe
Received: by kanga.kvack.org (Postfix)
	id 4CFC06B065E; Fri, 13 Nov 2026 05:05:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A6E06B067E; Fri, 13 Nov 2026 05:05:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BCBE6B067F; Fri, 13 Nov 2026 05:05:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A1C46B065E
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:05:40 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 880A81401E6
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:05:39 +0000 (UTC)
X-FDA: 85429663998.27.B6034CD
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf06.hostedemail.com (Postfix) with ESMTP id B05C5180005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:05:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=AvpCnLTe;
	spf=pass (imf06.hostedemail.com: domain of alex@amutable.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794564337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ZNAGjGCHSUHK/hbpNrctHFuArQcFUaSPHFuYTd8W2k=;
	b=OCAqk0QqR1nobORysH+n8l6Rf9Umfo1+k1NPBhxNFZV2Sy1v6oj55tCmHgO40fELN4UfTI
	AQYVvAlZ8DWtDRzXM+u7hR84STg1DZT0eM83H72i0pf9o04yrSXkp96A7/XuJ4+jiZ34ra
	157XOFtALMZNioFNez9ESdhIWFw2zGE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794564337;
	b=tShuMdjQtqae52Oi+dKR+f2VX2tJ8QPHjSPrqx8yUEk7WII9cqhwZRLXwSjj8w8keUtXj+
	Wgr+fO8rPYC5FfJeAVBmtuXP7n3PH5wdjc0KXdj1V1UlFQFVpimErj0L/G4xQgqfoiXQKQ
	HW+6j4NKjLg32m8wdv7fC9BNsruEUp4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=AvpCnLTe;
	spf=pass (imf06.hostedemail.com: domain of alex@amutable.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c50a2efbe1dso79591566b.3
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564336; x=1795169136; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=/ZNAGjGCHSUHK/hbpNrctHFuArQcFUaSPHFuYTd8W2k=;
        b=AvpCnLTe8SedXeYZZyJP6SIUwGNtGVlMP9qTTkCA8Wfi6WONAeV8YnpgTSOmVkKFDb
         zjIRlxvgeD2FLjK/WsQJPRpvObGDGsPaJl62TGufAO65jJC6U/OX4YoSwxAKha1dr7c6
         10RYithQFH2QNHM/noBG7WrmAqp2Aec0c6N1nckTSZQyVOgzy0p8wA+CtVpxYTVkA2GW
         tEiAiPmqNB1eJQkeN3cs/egsUUaSdhNyQZBOQpvJlhFrKXkA4BkP4LJa/jnx3XecY6Lf
         oY6yOQ6MN1MoA0lWi0xf+6qFdQYXKuXCuR60gjyxXiPh+CL4e26Ggf0z5zjf/BfJ1TRO
         HOMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564336; x=1795169136;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/ZNAGjGCHSUHK/hbpNrctHFuArQcFUaSPHFuYTd8W2k=;
        b=ZKCU9iVvmSSrSXs7ZfvwMRc8x3xODxvojL9kk5MoyFCJvNt4Ky0ree+SHtQxNBB86n
         l+cGWtMjLmRiUfjypYu47n3EWFaElk/3TaDW2HF5UY1+FAcGiVM07RL8Hy/PlTKmkttD
         S3oGh1VSKyWi4h938rbJ/W0YpGMadJwXxW3maqP5KmtOadGp+IJhQLvRsQUzPTWTdcvm
         50TCNg5xGB46w449Bef2IJ9BsRShZNqPUSp6nHLbyEufOJ3i0R2QTrgoBSDzqV8IwFfE
         582u5+25YKkUY+xGcrAvqj8Nx0ZXiFt6dxuV0C6+gMuQSZSnVe/wONj6zmmfIc1cJICi
         cfmw==
X-Forwarded-Encrypted: i=1; AL+hErF3jH1QDRmmUhsGYbUCzYqdsnOKJx06kts4vAHyaaqGT4SiW59Q5U4aWommZXchfBwXnd87ifG0WQ==@kvack.org
X-Gm-Message-State: APuU4Z97x42QMr12DA9qXTLXe1KrT09pEAwkehY+iy2lhNyoIgEwcqqt
	a+gf4IN77/IFSleXbd766Y7+Qk4GLVAjmpv2BM9ddJlYhv9e5+l6EFFuZgOqZyavP/nY
X-Gm-Gg: AYBFou3MBGF/tnkxLSKEw+ru4fttV+4+6hp/S0j9+c+5XmcMUmVQJEgk7EHWRUc0pec
	Yss4MPGP+VreNnXq0aThNKKmrsGXljZ/pJa39wKCKXj600sIVqoB7QKpTxEgXQnasF+SyzbfbEw
	LIX1EmDbKk1UBu7KrnQHNyRaBhj59Z7NBVXMty2tqy8C7daKKMagEBwB7PC+vo/gRnVsIhmrNcP
	NaeFE3F0e0i+FFwsQAeoqFB1BWeWXi62tykeVqM8XeVI+35Lmhfs4aR3hvfOi8lXReGoRHaC4yp
	eZmCe1aBcqG1B1qPxfrSnP+N60+OXh9EmWtg+xCfoQT/ws5xv+GzP2mSAoD60oJgiwGJRi1Nujp
	6+uVHREzOEC44lTfVZyx/NzXMm52eU5DGbrjlW7SvNOByeShPbFurALUQ+eoOD6yMdSEwoLdciL
	1dboeGHWpRRYcIvs9XqnfC+7qOCJpnmB/QBBgpymyeH4Ad4jri+/RN2e9rV5sICOhorWevx+06E
	qVIFbiPhSwbShbPUMdt96jnNbduS9b7w81tetSr0ITEe/ZTpcxIoItyD3KK+V0g7WILcTOZPziq
	DsExEtC4QLUIlw0YMO3AAZxldxioCMsYRXzP+VvDrT0gZcrdpJkT88hf8H/nMLM=
X-Received: by 2002:a17:907:94cb:b0:c2e:3a72:ffbd with SMTP id a640c23a62f3a-c5096389759mr162937766b.41.1794564336347;
        Fri, 13 Nov 2026 02:05:36 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095a5b93csm75365566b.5.2026.11.13.02.05.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:05:35 -0800 (PST)
Message-ID: <8f532a01f6cc2eb73582864343e25be4ec990919.camel@amutable.com>
Subject: Re: [PATCH RFC 14/41] debugfs: use fc_init_pseudo()
From: Alexander Mikhalitsyn <alex@amutable.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, Josef
 Bacik	 <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, 	driver-core@lists.linux.dev,
 linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org,
 netdev@vger.kernel.org, 	fuse-devel@lists.linux.dev,
 linux-efi@vger.kernel.org, 	xen-devel@lists.xenproject.org,
 ocfs2-devel@lists.linux.dev, 	linux-s390@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, 	linux-usb@vger.kernel.org, Amir Goldstein
 <amir73il@gmail.com>, 	linux-erofs@lists.ozlabs.org,
 linux-kselftest@vger.kernel.org
Date: Fri, 13 Nov 2026 11:05:34 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-14-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-14-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B05C5180005
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: jrinoeucbq89pr7c79rdga5rfzokugnk
X-Rspam-User: 
X-HE-Tag: 1794564337-733001
X-HE-Meta: U2FsdGVkX18y3WNyZ3McO4R5gLocIMbo33cUJMEoMyXUzNXs1RzdDXmn5uG9v9ws0GJ246/5o7ttc8JNVu7El5Tqt7830VpRPlYIlBYIeuPkikTJNSqTjMCwaCAZM8Alvx6NHVqQcvww+sFO9mrwBDj4eLWD3+N7leiRYaUDsAzZguFKBui7EoWq0uXKJyVIkITbVkttde3qLUsYcCnEQBYsYAxIDTaMW2FXolIc+x4CKLm5caF9zoXjm4w+PWlkiUUXJnGlr7Xt81HDCaMbocWIoTw5ggpJAPX0no42zhrk4S8NINELjRTGVOjXmTeudKkyoa/KzNyDtD/dMFqupFIETP6Cc2eZ6cC3nVrUQIqQA+fbAEeD59ZeeKeIbtxwsTZFi3CjHu7TFM1sICBWVqH2AOqgUHPVftxK/qrQVJ7/XdmknMM+J2QoNna86Q0RFFxmT0R7uaCr6RbEGztOTpNee01DRh3nYDEGxrAa8id2Rd9GmRqNoH3kkaRA8Gf2ILgAFXDYo3kznuKAOU76Noy85PjsPR3QtMxVFJuAlczD8hpCf0ioDkUJmPj59b5LzX7/9UV6bYp7W7mHDQ/OsLXVMK9BJHPHPv0dCv3CQWzlZuBc33Fl+Q/yDYwsmYxNbCA0+RdEZwVnrKxEuzRyJi3GAh6pNJNplPO3q7/or8qkEZhrjgK8tzJe0/3r/vuGOu2308SOmwUxFURvL2fOgXAZfws2psk721UPc2SAMMR3fU4Jh4WTP6+Sp5MF4jjeWY8/RMmd+nKHEJzzMwK+o51kroxAvky7df09XYVX5aXK9cI/3BYtLDZxKHChSZki9aHCY2gPeRtYDThSr2RxmPCBDU8gCd9zExuX4ueLhC4LNkEOQdaw0o3tqbiQAq0d1A4y9b8CzDCZ2yWFmRI8PofYq5zIssYCapkm2h6BaTovo0fUSPoZezz+1yKt44pTQoTv9okSIzYn7oHvZr9
 sxxdijlU
 lEbYVmnZW/+kOxUpiLlTo5PKCQTryP4qBC4bAtQAD8qoKCOF13FcG3KBw+R0zuZ7TL+nZlrJGRoEPgXiZF4aSSfwCIk/VBDVTHRRSIYx+2d5SvgFKZ3wqlpbCjDA5X1Woz9G3i5LdZkFM7ufxD4DpjNk5r7KGBSKiJMlF1/23tljgpSFTrwfbW1LI7yDBmg5Yqr2hG42xe99xnSaTR+CtekZU5Q63Tx087ejdfJjfOAMkGBBBOAollGhEwIu1dSxYQkDOlt6wYPz9EvuPZGx/Cxdj3ZILw3yupSLGtln9GuWEOljNOXg7LHsRUUyU49+Uet4Hlwuqz09EsTDdjI6pNDPtATz2dCTo61biZULfq4Sm+cWnztfOB3JQ7OiKeg/bPAu//c3repF747KqKRrgMDGduqt7smW5Pc+Xne/3SYU6HRArTXP7B8hRqlwm4/xq6Uux+qj3jdXCrxCyVYA+m2D7CMMkY2zuJ3P0re/GhtBjoro=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-11-10 at 10:14 +0100, Christian Brauner wrote:
> Initialize debugfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. debugfs never holds executables or
> device nodes.
>=20
> SB_I_NOEXEC also refuses PROT_EXEC mappings. The debugfs files that
> can be mapped, kcov, relay channels and powernv's memtrace, map data.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/debugfs/inode.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
> index b4915551ad31..f163f0bc5703 100644
> --- a/fs/debugfs/inode.c
> +++ b/fs/debugfs/inode.c
> @@ -15,6 +15,7 @@
> =C2=A0#include <linux/module.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fs_parser.h>
> =C2=A0#include <linux/pagemap.h>
> =C2=A0#include <linux/init.h>
> @@ -317,6 +318,7 @@ static int debugfs_init_fs_context(struct
> fs_context *fc)
> =C2=A0	fsi->mode =3D DEBUGFS_DEFAULT_MODE;
> =C2=A0
> =C2=A0	fc->s_fs_info =3D fsi;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &debugfs_context_ops;
> =C2=A0	return 0;
> =C2=A0}

