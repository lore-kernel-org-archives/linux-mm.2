Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 915A76071C10
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 15:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Gp4zIMJh
Received: by kanga.kvack.org (Postfix)
	id 9A4306B05D3; Tue,  3 Nov 2026 10:01:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97CBD6B05D4; Tue,  3 Nov 2026 10:01:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B9DD6B05D5; Tue,  3 Nov 2026 10:01:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5E2826B05D3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:01:37 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A1F8612044D
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:01:36 +0000 (UTC)
X-FDA: 85394121792.08.A9071FE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id C05DE1C0018
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:01:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gp4zIMJh;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793718094;
	b=4aQbxMHJyr34Lr3+9V0TDrz5zzFGBgQ/9XZFstOf76feoNQ7uygtA/Yh/uIL5Q4tUJUoX8
	2qep5WhG9HpjGcmwJSWGhP3nvlu0WtIHYMiKW3qVxQ3y5Owyz6KAJtqMAGx674T4lF0ygt
	YK3BFFRtouUXQox/gvNZEnxSxYoirU0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gp4zIMJh;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793718094;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r9QXWEwcwVsmD+gtjv1V0GbX1OqeCi9C0moHpPKkhRQ=;
	b=04rK++51EofpbFXyCH/cpMpHte/WwLwm85uDG4qFqmRilaYZoDV+XXnnfpZDqgQMg7PLpz
	QQajrEZZ+g5AoGNKPmsoMHE02q9oJPRSZ2WwXc9iUklrqinKNnthqRU4VmqlH3bSMQ5G86
	3jTy8VfsqBtGswhEZ1xXp5TpUCs4uwA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D15C9402E8;
	Tue,  3 Nov 2026 15:01:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F351F00A17;
	Tue,  3 Nov 2026 15:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793718093;
	bh=r9QXWEwcwVsmD+gtjv1V0GbX1OqeCi9C0moHpPKkhRQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Gp4zIMJhOwNqzm61c0h9XNd9e0AwMrFelEXQHKRAAlQ2LDeEpeF5m7tBEoFMtPFtY
	 uS4RsfPUfBZ2hRlArgVukP7X27SDUoJHgd88tPlb4o1OnQzVSaWgr3kNiGA9hxIq/E
	 7mb+cQIMUcKjUtjkRzdgBHMuNsu5EauysVoMaNwzoPfPD0sP32Kk9v3DT6vIUEgTNp
	 cOzOKQMESWOupzjY/ff38B2v3OsIMhrG6ZdWGYcCgTBgg6ho7OLcY+ImD//T211CBM
	 0ZuQsQcQMsjbrmcE+Eu/aRaJ5b+O1TMZX8eMsi4Ysf8/HRob1Y5+l5qFso1ia6iabK
	 z49HG1oD9fXRg==
Message-ID: <sashiko-outbox-195540@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 13/16] proc: let procfs copy out reads that don't go
 through seq_file
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
In-Reply-To: <20261102-work-procfs-core-v1-13-75df35e4f8b8@kernel.org>
References: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
 <20261102-work-procfs-core-v1-13-75df35e4f8b8@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 15:01:30 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C05DE1C0018
X-Stat-Signature: b6bz3qnz13kgjdcra8t6kbagpmhji11o
X-Rspam-User: 
X-HE-Tag: 1793718094-751613
X-HE-Meta: U2FsdGVkX19P2KjKfiOq3CXGRoz45Z73YQFKlwofj3Gy9kdhw7J1nhGuUMskj/goZq4t6t1+uJXvUtFCwn6VCtarfP5uijYA9kya7rVCvmouPWRddK/qA6TLcgCk6vMy0B9YZOILRWR3FPSNWH/5IxzoyuxkDQrKPSMCEjWfPUT85lCewPnC/pAijxjvZiEkVwFjZpnyWhMcqC3MpYqVn9zfoonpu12DgywZ76xc9Au4RozF8QKGDqMD+2aD6VB5ViQx3KJe4921pKDGW3ZQGgHKMJQhUuRvDrtLkitKw8D7QnmShYFSwDUq5by0RTF8S06csrJXufykNZfELAUsOC362eSlOuDm3Df9V7kIY0fj4BgmyDKb4PF4BNfQHFqnNegZ3BGmaTMRkRSM5AF5WTPLtQWVqfQp8L/vyc70a3RKKjFmzKwT5GFjjVx37m+Dzs+oL2tdls3XmenlasP/LCQThj7IOPqDXockHCjGfBhkHDjkbbSxVKe0etBkZ1lEaTWx8O78i2l4jCMROPB7uJLz+RyW8uPwC9+RmF74b2Ea/Ne7XjnSzueWNAiApO4Rz2hsge151Q84hoXoWMG8WPGdT7bj4r6Wo4ik3vXr29/6y9kLJGbAGKrCyDnnKiPbnAvsnL5LXzJ/tlAxgvT83NbVA6pPydOSF6t3HJcMQp4SNKqz3BPK1vhBI3ls7hS6j+dWJntCrWmNQzpcepgzMIS3j12ndLZI4OOG8x6zwodJf0WeDUwvgy5a4puwbFWN0yEu8O9aSLPNk9ocjux9050oHB1E+1YIgTcPldVML1n+DG2SM4wrkH9tZ9r/QmiN4zS9THLamdR8flUc9Ins/MCpjriZ3eoW2JL3QVblKjefmx16X5AtEshgWYWTy3zqXIdKlrTe9P8SwYKRJCr4M99n9toKP1nRXhrT15hveJKkfUiqTkB2UjkYIqiNQmSdiI7pwRJMQUNRe87p6bW
 erR5Jtb6
 Yk7YXsz+QF171m3SgUcPJ1C0RsX/U2xxiODn46ivH4DXIRxD2jyCAzsXTI4qR8uuBBI6ilHLkNRR4V9Tm8gNcuD9lIaWdXLppVntxDPM2qr3QW6mCvgQHYlMnDrXr6YjX9Q7VjY83iQY2fZZMXYEalZh0vwUZ8rqcBo3UxCv5yMf2MdKr7dBE9u1G6QExTvMc693kdCzQOGBwvth5wACqoFJnHM38RbuWHh0DKdEJVgIWDxxJ5QaBI0l+mDUtM4uKvJfeYJnRckj8b+7loYMwp1ghl1PRpFt5eRc4mC1lR8Xez0lTHURrFOY0bzCJVQNs5pjixPYy6HMZgaALEbqRS3OKU2gN3RI4tFUs91WANhmJUc0FTEHzfjMCG6lD6+yQ0tjZpBOHqpbEO8wxUXwVEoWqaiG2by7/Y0N5XXExXvtSwcL1+XLKhK2RPr0Sylg3GpY2fYMd1jz4z9X9u+1ELRMVf73DYGhfl6bCSKacQlkUAdy/7QeMuNlO+pVdsUlzxXBB+MuZl6dPzT2FjXjBbV9a1bHyJ9qjeLp21KdcdtT0e5qKdmJTh95l6BaPO+cOoy/+3Ok6bUbc6xd/fsqyCOwF1xqjLjvSg0ZsbNP6VEMv8AYO/pX80RN9M43UTwVW/s3Na1AhuQtt56zxlmb0TWg4XyxFiudLfABnAyEgEMYSvvqSE4kgID+9A6CPf6tMFm45gr7OT2OjtF2GOP5skOZv4Q==
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
- [Low] proc: define and initialize __free(kvfree) variable buf in one stat=
ement in pde_read_buf()
--

commit f2c1eb05c1e48ef170c932c3f77db0e09db3d058
Author: Christian Brauner <brauner@kernel.org>

proc: let procfs copy out reads that don't go through seq_file

This commit adds a proc_read_buf callback to struct proc_ops so procfs
entries can fill a kernel buffer while pinned and let procfs copy the
buffer to userspace after unpinning the entry.

> diff --git a/fs/proc/inode.c b/fs/proc/inode.c
> index c0bb40e7ff964..3f29a1663d266 100644
> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c
[ ... ]
> @@ -400,11 +402,67 @@ static loff_t proc_reg_llseek(struct file *file, lo=
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
This isn't a bug, but in pde_read_buf(), buf is declared with
__free(kvfree) =3D NULL at the top of the function before the early return
checks for !iov_iter_count(iter) and IOCB_NOWAIT, and then assigned
separately via kvmalloc().

Could buf be defined and initialized in a single statement at the
allocation site (char *buf __free(kvfree) =3D kvmalloc(len, GFP_KERNEL);)
to follow the cleanup.h conventions?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-work-procf=
s-core-v1-0-75df35e4f8b8@kernel.org?part=3D13

