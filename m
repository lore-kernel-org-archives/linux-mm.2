Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E88B606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 08:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ExXMuR9s
Received: by kanga.kvack.org (Postfix)
	id 55C5E6B05B5; Tue, 17 Nov 2026 03:26:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 539CF6B05B6; Tue, 17 Nov 2026 03:26:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44A1E6B05B7; Tue, 17 Nov 2026 03:26:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C4F76B05B5
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:26:09 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AB18C140320
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:26:08 +0000 (UTC)
X-FDA: 85443928416.22.345F10A
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf04.hostedemail.com (Postfix) with ESMTP id C330E40004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:26:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=ExXMuR9s;
	spf=pass (imf04.hostedemail.com: domain of alex@amutable.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794903966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z/NZRmC5bENRF/WsK1hUt6gARTy1xozW3x04wBCWbAk=;
	b=5+SoBAnuFOmp/jRRpsUGFYCyt6SjwOr4TDWQ+3OWDClgJW5joriQ9VtUqy9lCnWp6lbpfe
	oT/SjTi0mjFlWmk/54PT3aPmH/QKB3HhcmGOjTDv8HEKjUnrW3/DPZhlbN/9+7Z5LgT5tC
	u3gQ/6SPLB+S/zIe+BuCcuAo4QAgEoY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794903967;
	b=cJP/XZAckWQj9pmRV1cQodq/O23O9Xt5JF2BSTS4QL4hnLQXewJLFh+4GLQDjvERUmB1fE
	5xwbaTc+VZoKU8/4Pzru3TgJ2d4NC/p806GdPvoHQavo7bKtBIjr8oGtjWtOpteTKJr0ig
	1x2A1WbY9jxxKwU1/wn0IF4vox4MVbM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=ExXMuR9s;
	spf=pass (imf04.hostedemail.com: domain of alex@amutable.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so7875585e9.1
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 00:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794903965; x=1795508765; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=z/NZRmC5bENRF/WsK1hUt6gARTy1xozW3x04wBCWbAk=;
        b=ExXMuR9smTs9t9W1zpgd7rtKEQbKSoW4uoZghKmzytpbfwKEjHtA1hkZHjoDpdSdeL
         22QMg1qKyoDHjKtGU3N/SRv2gQdi0enonmPg0hR5zAB6Zi7fzSfo3KkCojJcNixeYnXj
         y5MTY3aJIK4uQCs5rHmUz20P4/Idynst7XqXVedn4lOrKXpVWmJYE57Slzx8pIH3+j4V
         yCPjsrUulRn5tQBFlQtBEOVoVxBCxkRbmTGnr6Z0W1Rv4OUW//Rdv3p6q3A385c7UR7+
         gZ1SopqDR/mE784+IUSRiRdy/6igccUF+siE49EhwfF9Qa3ugECvBEBu7WLXyAV1GkfI
         UOhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794903965; x=1795508765;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z/NZRmC5bENRF/WsK1hUt6gARTy1xozW3x04wBCWbAk=;
        b=wIOpiXMFEBAahPfCm0jotj2w8n24IKGfUkyB80wGNF8sRPgm5iS3eTOiOrlw6QXNYB
         nhkArAwNXy+qvl3N+8DaNq1e+1b0+RY9vY0GldQ2QQGI85p4N0Ibb+VGYiDvnqRD2pQw
         o1G/eQHYbn3m1t3tcqDyNlLkZIYm+thsvMLa+iatc/s343slmRwcPJzp+YrDSi3ZOf88
         +69zFrg7P8Zkk5dbfJNzNSI2ilWOdMQ0jwgK2nyNgK0yuGRYZlyEuxgcccW+LRjBzund
         vCF05U/+eztpnntEz/824yGihUDvgdGKLAzOPWD4D5pFr6Ged0kRZjrRa9hivoaHYlGK
         eGsA==
X-Forwarded-Encrypted: i=1; AL+hErEouc+AWLgOV7z73DuIyzF2vca881hCWBr+IyAIXf/cGXxS81Jd82XIevcW8O1LgPlWkseMmqgjBA==@kvack.org
X-Gm-Message-State: APuU4Z/avSW4RzV3XfEiWjLPYjF5eZ+ySu2ofPtjSpUB5mCKZT1ymEwA
	f38KN07eOy7CoJXIqGLFGRy5FSugHoRLWqBQpfLWkGWJ6RXxoDkduKqOjK6xYKbNLJLJ
X-Gm-Gg: AYBFou06vmYo4Z0O4OEO1+Y80x2zgmFlNkmofQ2DpL79lkZLLb5CEAQPij/ujP+zMlv
	2pT6I+5v6UoG1Dg85g0rJURdMY+3504AJmmkQ3BPKHotIMsR0qj6exwTEKjwsxv3Ef0UEaMMkm4
	cAeRuJE8dcvZHdclOcViMh9+VG2Di8sadBdbiBzTu6zenxRVy3ChfjqWPWkT98xYjio7ql5lE7U
	LLpBcoxvrquN/E4YnAY0VVL0W9qtXqot592HQEfrL0q6cu9cRsIXcSQCnfcbk3AOl3QQJvggux+
	APFb/s1VmlszWaxqKRivxEMLZXQB6mJU/CSMb0Vrz9rB0UIBgLhoL7k7fECDFA0Hh/X7JHK2Hhn
	9pUIJLUYDL44CTt1OO6bOeYsyL+yOzAnJ+B23kZa+eSEIuOpLk8GQNN7AO63lN/2/wJaO4swMm0
	IsKQaGa8SKG/WrzsE1zxz/ntpSR6UKWJkxv/9fJRLrFNmGLO8O74O7e4p80WreBfWA6I93WZQsc
	zFRzr3VCY9Og+gnOwYJ+LpVr+neGqjqilSUEL9OgtAoyjmIhdup6d9ioAO/R5CQtz9xL1HSCcMe
	25RBabiF+yWXpXM5+O4LyUCGlOQcUEAKy7KK3MdRzSMXfKstWPjqPU9OQOYuLf79QaaDU8e7sYC
	ObDOY4aWagEwMJp2eq2lw8suwLWcF0OAau2YvzIsK8crG8RhzG5HYd3IX
X-Received: by 2002:a05:600c:5493:b0:4a1:c27d:e1a8 with SMTP id 5b1f17b1804b1-4bb783813a7mr42606245e9.10.1794903965400;
        Tue, 17 Nov 2026 00:26:05 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb7ad9430asm12629125e9.15.2026.11.17.00.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:26:05 -0800 (PST)
Message-ID: <88041240268f70b218de7dfd58c41977d03a60d3.camel@amutable.com>
Subject: Re: [PATCH RFC v3 03/44] target: fileio: check that the backing
 file supports ->{read,write}_iter
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
 linux-kselftest@vger.kernel.org, Chris Down	 <chris@chrisdown.name>
Date: Tue, 17 Nov 2026 09:26:03 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-3-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-3-8cbbea1cf34f@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Stat-Signature: 4e5658ej4ybjnj4o78ha6pufpnsfm8nm
X-Rspam-User: 
X-Rspamd-Queue-Id: C330E40004
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794903966-393967
X-HE-Meta: U2FsdGVkX18XH5J4OimFyyCHagN4Tfp6yI0mTq/S/f4BhK2lhoF1U3oUPDTVViD1WtNZYbpUGSAhkp7D5QT9OCQElPKQfJ06OLDkj29KTdxJN5av03n+hNh+NbkpUL8dbeM/BYS1r5cukwvLDEnIce04mI9gDZTFA/EGuKRmdSIjiF55OS3C4tJCwJ5L8lB2dNxxeXGarQDeQ+U0NMzJq8IOLv3p6N+QfHzIdw/WuBrKDlvFWyXfSVC7qmuUB3FBul2hAYI+B9E1iGk+cvyMASLBsn9GWAXmLTgnqojMVcrQQzy0nsjmER2aBablrvz5piZUQFeIp/DZgEQJY54YxmzOBKXZrS+08aWyCdKJCq7fd+Mxj8hpSFhv7Rub+SJoJw+ZenzRGRRjj1QTni2Brd4D9Rilh7PXbSFTpXcbu4JggJGaJkDVcQYy72wRk9zFyqgKTCAEUN3th7c/xX10mdGGJ4UC/L8R7a9dcGOFY/NjkI7rFAXjsPRFjcvQ7ExuFEWTyf9H2x2hmY7PFHoPf4Ey86CXWU+4j16xKd03MsX979JvDEbKszauIaxIji4s8cdYDM3HoHp1DpFTL1Xf3NOSeU5vS6vJutZOmkfAQYqWXleSnzHMrRnzhNVDbuh5gnishaFXFJJXbfjQlkP+JJ0M3jSl0UbnLVLz1O0Bm19cfY6x8jhoHrJTFPG6RT+DVc2lLJtuwCoD7wKfnTh0ApKipp/2S2NQgZ6j/QDVQ3a99PLrFb4xBzteTTTyzjbIvpFBBlEQqEAD9a1JIkCQBVzSKpCamTensJa3rR4ErKELX07VwpNSXIvQ6Z2aM+/UEuzvxwJImwSGqF2Zw8eajcc/FAET9NiNq5dLvllgBjz28PDAwJ01oH54Yk4C6UsuX//yMdrxO2mVlPjvI2BDxae/4nU8GkOCE3iMlsC7NqV6WwxbGKl11gqRFjFL8vPS4rdhK/4uZJ9jCt68RSI
 BGEsjzmw
 mcNcQldkHx13rRjxehLUTJYBDi78kGPkv+dIhUJ3m2MzJY9dGXlPCM1O/sL0V6ONMHcufsmlhazECZsZk6doxseiOmYfdjkjV7MLKJlUtQZ6z75G/wNAxQAY5rfMK7rdtUe+wPa1EGPsoeVacnFMP58l4EmDI7bsChTiO5Ns2I1yLVzcpc430rC7L6y/IOimhTbCP64Q4oFL7ddTgVdVK//b1QDpb4RvRtLFzySeuy4ZMCQE3cUIarwxA62PYzDLCULKmalJkVWOZCfqMMVCSUMSramSuF6Uu5f9Sv4vz+dKyp2dOJ4rYu0MhOHOiyzgQCL6ifUgdGznGxY44ateaQX8pXPiDsA+sD/XkTArTRDWjzmXFFdqDsssAG5L32rvcnn0ZGzT7Hz4DgicAHWDlM3lYG+QuDoNLNQMljE9/Gt8GMAlCReF/SNoBszBGPwGp2+m/lM6SRHZ/9FW0FdMAwlk+OxdeoWI3o9yRjV+R0AjWOWN6DKSfXWDcSKfYWO3ju/oEPH3wnQcv7zRdqAxcbYboGH354vbuO35A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2026-11-16 at 12:04 +0100, Christian Brauner wrote:
> With fd_async_io=3D1 the fileio backend calls ->read_iter() and
> ->write_iter() of the backing file directly. The synchronous path
> goes
> through vfs_iter_read() and vfs_iter_write() which check for them but
> the aio path doesn't. So a backing file without them calls a NULL
> pointer on its first I/O.
>=20
> Refuse such files when configuring the device. On the synchronous
> path
> every read or write that needed the missing method failed with EINVAL
> anyway.
>=20
> Fixes: 769031c92c8b ("scsi: target: target/file: Add support of
> direct and async I/O")
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chris Down <chris@chrisdown.name>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0drivers/target/target_core_file.c | 8 ++++++++
> =C2=A01 file changed, 8 insertions(+)
>=20
> diff --git a/drivers/target/target_core_file.c
> b/drivers/target/target_core_file.c
> index ab9824a4852f1..a5391e57e9aa5 100644
> --- a/drivers/target/target_core_file.c
> +++ b/drivers/target/target_core_file.c
> @@ -144,6 +144,14 @@ static int fd_configure_device(struct se_device
> *dev)
> =C2=A0		goto fail;
> =C2=A0	}
> =C2=A0	fd_dev->fd_file =3D file;
> +
> +	if (!file->f_op->read_iter || !file->f_op->write_iter) {
> +		pr_err("FILEIO: %s lacks ->read_iter or -
> >write_iter\n",
> +		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fd_dev->fd_dev_name);
> +		ret =3D -EINVAL;
> +		goto fail;
> +	}
> +
> =C2=A0	/*
> =C2=A0	 * If using a block backend with this struct file, we
> extract
> =C2=A0	 * fd_dev->fd_[block,dev]_size from struct block_device.

