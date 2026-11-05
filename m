Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D2E5606F58F
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 19:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JxUDwRLS
Received: by kanga.kvack.org (Postfix)
	id 860496B05C9; Thu,  5 Nov 2026 14:35:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 809B16B05CA; Thu,  5 Nov 2026 14:35:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D18B6B05CB; Thu,  5 Nov 2026 14:35:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 48BD46B05C9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:35:51 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B7A42160BFC
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:35:50 +0000 (UTC)
X-FDA: 85402070460.28.0073060
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id E93061C0008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:35:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JxUDwRLS;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793907349;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1MugNV8TCf3DcwhciMioHkCDdfBEvJqmJegZE7T3Anc=;
	b=dz6Shqzqh2QPxgGUm6hDvzGfPPpiRuWw0ZxhObE9TVDYANIsRNkIYO2K2FjsSxeQSCAgbV
	lcmAnSxD8QaZm96M7YOvtvtG12WeX0SWUtw3Y+djslk5qbhNkkRnlfEI7exAfrPFyXvqdb
	JPDlEPBbeFvE/9dJcHAL5Gbf4G42lTc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793907349;
	b=wbz289SOlUQBHbaUtkxQ49BAEG1dvkbHh0uQbt18QpjgoBCTJm+wNmP5r+2NjihuvpaSYT
	xCW5JxTEzJKWdgAavs1fe0C81mEW7h98P0l7JQS/xNAzWqE5gDOPaye7bbnofeV/90xt7p
	o3xCgHBQ3Nj0A7YISnbv7uJevKsmogM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JxUDwRLS;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3BFE843CC2;
	Thu,  5 Nov 2026 19:35:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6371F0089E;
	Thu,  5 Nov 2026 19:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907348;
	bh=1MugNV8TCf3DcwhciMioHkCDdfBEvJqmJegZE7T3Anc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JxUDwRLS659AKy9L6EF/sMAUNJPV9IWLdEGgYT37J3Q3xoM9Rgl+/f5tJog9D28GT
	 YMaZHCMQxAz8Q/YhL7D2HkKgLdWMS13ODeIvOVS2cO3Xyt1UiWgXthVq8iKNCfiwYC
	 CBZKMuWNvUYO3GRSHNobx37W6/E4wT6vFZKwM2U+b9rd+Q0o+xU/Q/0vCpfhxieJT7
	 F6OAqSTAk8K2MFcN+drjgRiXeceRcYXDu/MhOHTrRoTOf/Jcy6qlsQJs6CLNabmhUG
	 q0HrKvIx+/XHSn3ssmSRL1+tCAkBs5GI7/FQwPFk1on24fvEEyzBWmsp3oEib+CbCf
	 nnIC8BG7tI46Q==
Message-ID: <sashiko-outbox-199946@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v2 16/23] proc: let procfs copy out reads that
 don't go through seq_file
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>, "Jann Horn" <jannh@google.com>, "Josef
 Bacik" <josef@toxicpanda.com>, "Chris Mason" <mason@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>, NeilBrown <neil@brown.name>, "Eric Dumazet" <edumazet@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Al Viro" <viro@zeniv.linux.org.uk>, "Jonathan
 Corbet" <corbet@lwn.net>, "Christoph Hellwig" <hch@lst.de>, "Greg
 Kroah-Hartman" <gregkh@suse.de>, "Joel Granados" <joel.granados@kernel.org>, "Kees
 Cook" <kees@kernel.org>, "Jan Kara" <jack@suse.cz>, "Jan Kara" <jack@suse.com>, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, coreteam@netfilter.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, linux-usb@vger.kernel.org, samba-technical@lists.samba.org, sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-serial@vger.kernel.org, "Takashi
 Iwai" <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, tytso@mit.edu, dmitry.torokhov@gmail.com, "Petr
 Pavlu" <petr.pavlu@suse.com>, "Anna Schumaker" <anna@kernel.org>, yukuai@fygo.io, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261104-work-procfs-core-v2-16-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
 <20261104-work-procfs-core-v2-16-76ace653a773@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:35:45 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: bfx6uupgkbem13hau467gf8kxjiroexf
X-Rspamd-Queue-Id: E93061C0008
X-Rspam-User: 
X-HE-Tag: 1793907348-329608
X-HE-Meta: U2FsdGVkX1+8TaZHwDNmFZRyjxXfyAICfScOkEUIn+szxXhWUtKHt5YXncHQpNs24cqVWytXFXU5cTClXAXpi/LC5kSAtTXXiJSiryqiXZb1R69VzJN7R3Y5/1bz2gp34ryc3QSbvem1MlzzLLDJnrU4wK0JxEKXpmeLrvP/DCWFHshfMP2F+OKOx9iVUvey5thVzFlVgMMVGm1Wmq0I7XPnjWXXCvzpxb04sXD+GcWoIrRGZE0Ymb47f6mRdG2/StRp733X8tJCNfDMqSfpQt/BDo+rAZ+b3FHrbesY32Hvj327Ox/5w7XZxKmZh32D0DUTSwVDa2/MET5jjdfYo1AKoejzx2Sve0sToGQMc8DNM8lXrTmM7KNdwAeNOFBN4MZfiheI2L0DQwBUhnDWne7NzvTohfK9eZ1mACGMyjb6o5qwIaXIND7xfJUp8RHhrMyEdFv3B/+IQAMq5egucMp5zUD0ZwidaeI3DZUMJT8UIDzwkY9puQUGE5L0B8jqO++/ZQus1kpFibBwPdJtr7J5fDC4XfEtmZSmitpFhevWe4NtsU8kti+htnOL0ali8CcaTqRBjtD5XwZgdIHdoX5Sp85I8nrHrB7lq+bz7S986vvxL0a+/7JAkGmRaReMCe596hazBvIiebNzegvB1azP7VnFPBq4hJZdtJY4t4DOV2PTiDJEJU0xJhePodqPeseuK6kcFeKlW9OHeCL/cXqNHL/T+o5ppW/wWkV3A0sNVhWRKStwlk+2ntbdPkKwCfsPxIVhv3OXmYpYLnqina7xfWiIfycw6+7WGaHNdoGMtdIwUL2x1ouasYBM8p8EIab31dzGae1DjZvXbJ5JILz6Ai2ahgMaCm03NmzjQ2UFxH7vpv9MBh6L0EAO2/q225ku7/Pz5S5UO0MhjV2EdNtfcJ8ywigR00foEoRo2EBMIQMGxcZxb9vCJbt7665L1EZqUJUlwVeYzbv+Ou5
 1uHfBSsY
 rebRLbWygSu+LYPZ99oYNSyw1F98UarCiqpoXv/EDWFltoRyjiP3MhrxgmOqdr6op+guuoFdDcAd+bQWNubYrO3FDGRBuk3CsH4gaIAemUIZO+HK2D0r0T0H99lJtPrDf1ID4x76dsCftb1UCZbSuV0RncjuqKz39OnydArRtQECsS5v7BlcWZd0+nSHEPcbXpdvVzZ/eTH/SLdr09NWXkP16PdfwA2wZ2qWqJ6lKtgx86NFaOPwV5fBZusKVlML3Mhq56XUKymoTAprNB7HJ6s7L9y/zuvfagDgPJlkJrY6VWPS4ufMYu39wNOB6uRZmlcg3QroCG3iETGgqm8GhRwA6uqekM6lwEV9RgoGsharNkZuEjj+Fdd6RcmUDH2OaFCrQdWLN3Y6eVOVtG/AqT37QrYL63/28+chO6MtsoUvrf4L16QyhK9syoZy0CIbSnWFZkfk6DaM+7B44DPCr1zqs+PJK8c387bGQ/7eYWy5wUeGNs+eGz8q1S8kI4EeBjlrOuYBUnQXA3R/qvRhm4aARTPd3pgdNqiFG+3RAZphn7L/jX6p0btL5L7s5W07IdpTPMZd/dhK8qhGd63uvo8c3pBf2S6naB3HlvzoI1ywUJTlcZ4bE/UNmaXmMP+I/mHzlfghPLKTg9YzO7jV+Yn6nygFgEx+s4PJw22kYnoawotVjAmgU+ZgR8I3xvpRS7cP3W+iCnuhztEVE/HL0zvqRRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] proc: define and initialize __free(kvfree) variable buf in pde_read=
_buf()
--

commit 19cf278eb9fee57b90ee19764f6b076d9cab553d
Author: Christian Brauner <brauner@kernel.org>

proc: let procfs copy out reads that don't go through seq_file

This commit adds ->proc_read_buf() and PROC_ENTRY_FULL_READS to proc_ops so
that non-seq_file procfs entries can fill a kernel buffer while pinned and
let procfs copy it to userspace after unpinning the entry.

> diff --git a/fs/proc/inode.c b/fs/proc/inode.c
> index df1caa0f238df..caa47933c233d 100644
> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c
[ ... ]
> @@ -377,11 +379,67 @@ static loff_t proc_reg_llseek(struct file *file, lo=
ff_t offset, int whence)
>  	return rv;
>  }
> =20
> +/*
> + * The entry fills a kernel buffer and procfs copies that to userspace a=
fter
> + * unpinning the entry. A reader that faults on its buffer then doesn't =
hold
> + * up remove_proc_entry().
> + */
> +static ssize_t pde_read_buf(struct proc_dir_entry *pde, struct kiocb *io=
cb,
> +			    struct iov_iter *iter)
> +{
> +	struct file *file =3D iocb->ki_filp;
> +	char *buf __free(kvfree) =3D NULL;
> +	ssize_t rv, done =3D 0;
> +	size_t len, count;
> +	loff_t pos;
> +
> +	if (!iov_iter_count(iter))
> +		return 0;
> +	/* neither the allocation nor the entry can honor IOCB_NOWAIT */
> +	if ((iocb->ki_flags & IOCB_NOWAIT) && !(file->f_flags & O_NONBLOCK))
> +		return -EAGAIN;
> +	len =3D min_t(size_t, iov_iter_count(iter), pde->read_size);
> +	buf =3D kvmalloc(len, GFP_KERNEL);

[Severity: Low]
As reported by Sashiko on RFC [1], this isn't a bug, but in pde_read_buf()
in fs/proc/inode.c, buf is declared with __free(kvfree) =3D NULL at the top
of the function before the early returns and then assigned later at the
kvmalloc() call. Could buf be defined and initialized in a single statement
at the allocation site:

	char *buf __free(kvfree) =3D kvmalloc(len, GFP_KERNEL);

to follow the cleanup.h conventions?

[1] https://lore.kernel.org/r/sashiko-outbox-195540@kernel.org

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-work-procf=
s-core-v2-0-76ace653a773@kernel.org?part=3D16

