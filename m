Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89E30D3B7EA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 04:15:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF5F46B0005; Mon,  8 Dec 2025 23:15:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD0D96B0007; Mon,  8 Dec 2025 23:15:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE36F6B0008; Mon,  8 Dec 2025 23:15:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9FF696B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 23:15:01 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AFFC358C8B
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 04:15:00 +0000 (UTC)
X-FDA: 84198617160.09.9CD79FD
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id D538212000C
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 04:14:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Bul1c7ys;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of hughd@google.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765253698; a=rsa-sha256;
	cv=none;
	b=rcrRmIFQUwm+6JyeOO493R5NoQgkMJhP9HN5nOxIuX60pywtt3+bpqKOoBIJwvs8U7qL6W
	cOXVGnWKfIklVw4mpojNPFW8JzEasFwcplyLFywfx7VseWXDyjpqLsdg8wDyiO/fZ57Rz5
	QL2paJCnc673INo09cIaVaeVYDsatPk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Bul1c7ys;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of hughd@google.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765253698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kxOZQiVrIOkc6jsPHDGEQgDqVs4gmHDUYWM8/3JKHtc=;
	b=Kd398ExHrnwTOkY33SowK8D4EEltyCEun3YhDQWK6f11WQMXVh+ByPcL7NTjUTXaxnW2GN
	x/I2yyNzk2ko0jVCXc5yNY+EyVdWlXnGyeVz68FEWpPGHpg5FoeWHai89abRtBl08qN1et
	TfOMGEHCNkGeteZ4brYNkln7h28xwrM=
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-78c5b5c1eccso6500067b3.1
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 20:14:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765253698; x=1765858498; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kxOZQiVrIOkc6jsPHDGEQgDqVs4gmHDUYWM8/3JKHtc=;
        b=Bul1c7ysAsxZXx9ZKUHisZT+nH8z2+9BqTUaHGAkUZvmLGaK2HqADrO1WJPaTO5x7J
         HiBpJPXD+6aSenzlS1ftYwR49P+/bNvMdLxsGKnwB5fIOdM9rOaa0ML1yDrII8zhksKH
         zQLF/L2WD2YLgHS/1CF+UKgoi2910ZrTPQlYRjEZ7FyLpViIxxtgf30+wN9z2b7lPX56
         j6pt0fh07MT6MwQkbxfcHkMYhr0Cyj6eOLfXsMXUish3uq9ZjPFuhG19d6qCJEJhAy3Z
         mV0ZtFEoiBrlpn1ZnHpdfhuIBkxwL/2vo67OJNZHVca3X6HY5DO4BoVJpnoug94Hd3UG
         n/kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765253698; x=1765858498;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kxOZQiVrIOkc6jsPHDGEQgDqVs4gmHDUYWM8/3JKHtc=;
        b=dgDbbRgONSoO3LmyOMh30J7NO9QFFt23fRdOSBeCP6M6aCSumcxiCnouBhdiMTCt7g
         fIAMu8+Q2+HC7QRdFSuBzjYV/Za2r38kgfQMpjwCNX2xNf4EJmbGEDFCpW60jsHJMJgs
         1Q1meCxh6TNuCnyBUkHs2zdIfIUFlu+nmdAlQGS2586oKb7TVL73E3zH9qrr7bYDAsXO
         vJ1xMdJYPZ0Gt2w5Re0Xp686kIDX3NsigL0IHfdBO7jWylBm/R+6RF+uMajCPZYy+A1V
         wshnn10EtaL+1OirURYzM3QvqMPXbkj3+X9fWAWcr9V73cUPI/QCcMmApUuE16naupYK
         OpHg==
X-Forwarded-Encrypted: i=1; AJvYcCUGPZ+1GajJz8BoqICmP+71SkLvUFnslWDAgc2MFRe3RD/aeFkDQo4H7y+jIXzLSp5LS0IJWZISVQ==@kvack.org
X-Gm-Message-State: AOJu0YwEpuSXbjKRHgdb2fvl8pFFl07lfo9xpD9BPhlZzk3/UeMxEOZr
	J2xqCCnMdezfdKsowJI261fsmZ4wpFRZzuVeIXqXftZvTR2MsVWymGr4j04IH4f0xg==
X-Gm-Gg: AY/fxX48JaIkVh6xpz9bRUSPUhqJ7H2tvXlawOENXHnCgvIQZajbkTTspV4u43cm7aE
	sHiPjjC3ZmP+U7x5/K+tiZKcQqKq9hyZMhw6WAedgxksIIAND/kEuCEx9uOm4wrE3JAd1QvphRo
	LsFGbexA67MJ5Olf2/tpLG5L86lz3h0MHMEyE2WjtY1RX3p3fw9U/NNo2Yq/WPHoMMIboT2PERL
	pHhHWaS0Jo+1lNWIKNezLl4OPBLmQltmNCNVnPeHQpTaBS3GgfWP6OrrSJFrcYTXLhnTWY0j9md
	xH+XSVzpewR6HdZcScOHJ44GJQ2+Pg/kI8B7ieJmjxYIdhXcJQ7kYpKZljEc3DugMgMxKXUd6OU
	Tg1WNZzuaBEFgPv6VOwEVnEA2Fw0wkKsk0Imit7c023ExfXcgaw+8nuiyhCIw9K3R4srnWp4F6Y
	ASSnFaVTTP6SrwzXkObIFDoLaKlVl454/DElcXuLqFYLA4IERHLRq5hk1O3Ngh84cS1f4W6lQ=
X-Google-Smtp-Source: AGHT+IGStD3RTu8T+BCQkOHYtvAsKKgITO3CHa6arajrItSoFji6PAjkptYVeArSqR06eFO3YkONcA==
X-Received: by 2002:a05:690c:ec4:b0:78c:1213:58da with SMTP id 00721157ae682-78c60772f4fmr1081207b3.18.1765253697550;
        Mon, 08 Dec 2025 20:14:57 -0800 (PST)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78c1b4c9e43sm55152797b3.16.2025.12.08.20.14.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Dec 2025 20:14:56 -0800 (PST)
Date: Mon, 8 Dec 2025 20:14:44 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
To: =?UTF-8?Q?Ahelenia_Ziemia=C5=84ska?= <nabijaczleweli@nabijaczleweli.xyz>
cc: Hugh Dickins <hughd@google.com>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Matthew Wilcox <willy@infradead.org>, 
    Christian Brauner <brauner@kernel.org>, Theodore Ts'o <tytso@mit.edu>, 
    linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] tmpfs: enforce the immutable flag on open files
In-Reply-To: <toyfbuhwbqa4zfgnojghr4v7k2ra6uh3g3sikbuwata3iozi3m@tarta.nabijaczleweli.xyz>
Message-ID: <be986c18-3db2-38a1-8401-f0035ab71e7a@google.com>
References: <toyfbuhwbqa4zfgnojghr4v7k2ra6uh3g3sikbuwata3iozi3m@tarta.nabijaczleweli.xyz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463770367-921943916-1765253696=:4936"
X-Rspam-User: 
X-Rspamd-Queue-Id: D538212000C
X-Rspamd-Server: rspam10
X-Stat-Signature: 7y88mnwdrs7nozqxg7bs4zt66rtnmo5s
X-HE-Tag: 1765253698-781812
X-HE-Meta: U2FsdGVkX1/RLr2opmB+71GmbJuVl0SKqcqSh6WLTuKU8jPGNEq19nmFgI1Tl5UG19LLAw/1h/CPrZjZe4LUXVPRWSSgIlL427n5iXg1T11rsCaiOvQstlm0hlUQRYsy07cQMkZg124UNRLEhQT8ORHNNFfYMsn428OUQemkudZjSbzy7CmQWIt0UnrpEpQdZN9vnrHxY0fF3wbd+oiE4VHARa99JWB1sJ84XfuNWIVSQ8cDJ12e7QBPEo2OXYdF6XSCVwiGibCHscPyusV/fdqxlTsBNrvBS0Vi+vUxZpK8rIjH7jvHkbHVK5gNV8kaA3fcf4PKajiEOqc+D/RB8FJnA1Ug8G2rqb+yn2jyXQxsZPf/jZcxi0jyOtjv8UDOiFi5w7OLGv6tuqczo40moJ8CmjxN/4bIahpJG9jVnlxU5DVJ0axPFM0ScR0AozLB5KyCfO9jtqXfd9qjJ0FdfFXrqQ6Uea5Sb+C6f7ka9Y6D117m79R2voArbkRDJXJYXrne+A7jmYAtHAk+rEEQCag/3sJ1PozRQIKDaXf1jENZiqPkdCesMXYed2F+IpeBlef4W4xlcYny/KRe3KZ+8Uwks09fe7s92N71y7h3AGmdwJdb56JhrNT71oy6mx02hqreGw+5PKPEstdjlI8zJXVudMXZvRROZxWOx9S1l2jvV1F9k7RLjhaL0kt/S3zIgw4NY3fv1/h6awf/BOO6f5V70bAxOtKrRF7A1bs97DPZDnSEIS7USmc8rSDAdtRpaIXnWjuWzu7tqWhIdgjM1lfUuC/GsnYNoPZoE/wqkDnXJD+8x94R9fDMzgx/dPSB8OBLflE47O/gzM/9A3YccHlzO1+6sQ2RxLwBZFzYkhwDM7zuSqyGCi0wW4UJx6jysfVBNYw7J/wMU8KCG9CMtfKcO67wKtPGOQ4hEF9gevGy+roanttlu2Qb3080u+kFWiZxxvYFZnROQzDoOtX
 1PDJ9c5w
 XhMFKnnbfnghN3bun6ZWyTZdAg2zJbpbhx8RhpA1isaVd/CgiVurBkK8lfPQnO8EMqQKs1Q35mcvLDSx7793nZCm2QgpjTcHDz6NxRJ1LoEd5TCd70Bef/x4DOmkz7RMtoZyjFBN8G2YWv6gCc07kDKZyY3Rbf0LHyELhqPXc/7DiiBS7xmI7iCSrO4qXdqW+hsZhOpL3y8s1XNVEFzd/C6TrVQc5U9BKu7eMgItL1MS72ZDKmIbx90hAxc3EsIcMDXpFYweYaM5GxMMupkNr8BD4JiV50ujwJZ0Hp5aAyccNv5ooN/29s8SGtEnvwEP8vvyh750C56yy2XwxD7DAbd+BHr88plz5/ar5z3kzabCQ6kVuz467b2PYhiKAcjHIs/HZckItNjqG2FshRE2c3gSkVJnswVjaLT938ih/a+bVovq5HDXF1qwpG+r/4llNNL38XX+L9tjHubbnQy/Vd5TMOvSJRT8CA34C9MNnBkZV7t/Y1bZo8/BZDeWWYLFmaxAa2W+sP1hs63mmFh8ER+1qtYtpDM/rjHPSJNUV3qDJg2k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463770367-921943916-1765253696=:4936
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 8 Dec 2025, Ahelenia Ziemia=C5=84ska wrote:

> This useful behaviour is implemented for most filesystems,
> and wants to be implemented for every filesystem, quoth ref:
>   There is general agreement that we should standardize all file systems
>   to prevent modifications even for files that were opened at the time
>   the immutable flag is set.  Eventually, a change to enforce this at
>   the VFS layer should be landing in mainline.
>=20
> References: commit 02b016ca7f99 ("ext4: enforce the immutable flag on
>  open files")
> Signed-off-by: Ahelenia Ziemia=C5=84ska <nabijaczleweli@nabijaczleweli.xy=
z>

Sorry: thanks, but no thanks.

Supporting page_mkwrite() comes at a cost (an additional fault on first
write to a folio in a shared mmap).  It's important for space allocation
(and more) in the case of persistent writeback filesystems, but unwelcome
overhead in the case of tmpfs (and ramfs and hugetlbfs - others?).

tmpfs has always preferred not to support page_mkwrite(), and just fail
fstests generic/080: we shall not slow down to change that, without a
much stronger justification than "useful behaviour" which we've got
along well enough without.

But it is interesting that tmpfs supports IMMUTABLE, and passes all
the chattr fstests, without this patch.  Perhaps you should be adding
a new fstest, for tmpfs to fail: I won't thank you for that, but it
would be a fair response!

Hugh

> ---
> v1: https://lore.kernel.org/linux-fsdevel/znhu3eyffewvvhleewehuvod2wrf4tz=
6vxrouoakiarjtxt5uy@tarta.nabijaczleweli.xyz/t/#u
>=20
> shmem_page_mkwrite()'s return 0; falls straight into do_page_mkwrite()'s
> =09if (unlikely(!(ret & VM_FAULT_LOCKED))) {
> =09=09folio_lock(folio);
> Given the unlikely, is it better to folio_lock(folio); return VM_FAULT_LO=
CKED; instead?
>=20
> /ext4# uname -a
> Linux tarta 6.18.0-10912-g416f99c3b16f-dirty #1 SMP PREEMPT_DYNAMIC Sat D=
ec  6 12:14:41 CET 2025 x86_64 GNU/Linux
> /ext4# while sleep 1; do echo $$; done > file &
> [1] 262
> /ext4# chattr +i file
> /ext4# sh: line 25: echo: write error: Operation not permitted
> sh: line 25: echo: write error: Operation not permitted
> sh: line 25: echo: write error: Operation not permitted
> sh: line 25: echo: write error: Operation not permitted
> fg
> while sleep 1; do
>     echo $$;
> done > file
> ^C
> /ext4# mount -t tmpfs tmpfs /tmp
> /ext4# cd /tmp
> /tmp# while sleep 1; do echo $$; done > file &
> [1] 284
> /tmp# chattr +i file
> /tmp# sh: line 35: echo: write error: Operation not permitted
> sh: line 35: echo: write error: Operation not permitted
> sh: line 35: echo: write error: Operation not permitted
>=20
> $ cat test.c
> #include <unistd.h>
> #include <fcntl.h>
> #include <sys/ioctl.h>
> #include <linux/fs.h>
> #include <sys/mman.h>
> int main(int, char **argv) {
> =09int fd =3D open(argv[1], O_RDWR | O_CREAT | O_TRUNC, 0666);
> =09ftruncate(fd, 1024 * 1024);
> =09char *addr =3D mmap(NULL, 1024 * 1024, PROT_READ | PROT_WRITE, MAP_SHA=
RED, fd, 0);
> =09addr[0] =3D 0x69;
> =09int attrs =3D FS_IMMUTABLE_FL;
> =09ioctl(3, FS_IOC_SETFLAGS, &attrs);
> =09addr[1024 * 1024 - 1] =3D 0x69;
> }
>=20
> # strace ./test /tmp/file
> execve("./test", ["./test", "/tmp/file"], 0x7ffc720bead8 /* 22 vars */) =
=3D 0
> ...
> openat(AT_FDCWD, "/tmp/file", O_RDWR|O_CREAT|O_TRUNC, 0666) =3D 3
> ftruncate(3, 1048576)                   =3D 0
> mmap(NULL, 1048576, PROT_READ|PROT_WRITE, MAP_SHARED, 3, 0) =3D 0x7f09bbf=
2a000
> ioctl(3, FS_IOC_SETFLAGS, [FS_IMMUTABLE_FL]) =3D 0
> --- SIGBUS {si_signo=3DSIGBUS, si_code=3DBUS_ADRERR, si_addr=3D0x7f09bc02=
9fff} ---
> +++ killed by SIGBUS +++
> Bus error
> # tr -d \\0 < /tmp/file; echo
> i
>=20
>  mm/shmem.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>=20
> diff --git a/mm/shmem.c b/mm/shmem.c
> index d578d8e765d7..432935f79f35 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1294,6 +1294,14 @@ static int shmem_setattr(struct mnt_idmap *idmap,
>  =09bool update_mtime =3D false;
>  =09bool update_ctime =3D true;
> =20
> +=09if (unlikely(IS_IMMUTABLE(inode)))
> +=09=09return -EPERM;
> +
> +=09if (unlikely(IS_APPEND(inode) &&
> +=09=09     (attr->ia_valid & (ATTR_MODE | ATTR_UID |
> +=09=09=09=09=09ATTR_GID | ATTR_TIMES_SET))))
> +=09=09return -EPERM;
> +
>  =09error =3D setattr_prepare(idmap, dentry, attr);
>  =09if (error)
>  =09=09return error;
> @@ -2763,6 +2771,17 @@ static vm_fault_t shmem_fault(struct vm_fault *vmf=
)
>  =09return ret;
>  }
> =20
> +static vm_fault_t shmem_page_mkwrite(struct vm_fault *vmf)
> +{
> +=09struct file *file =3D vmf->vma->vm_file;
> +
> +=09if (unlikely(IS_IMMUTABLE(file_inode(file))))
> +=09=09return VM_FAULT_SIGBUS;
> +
> +=09file_update_time(file);
> +=09return 0;
> +}
> +
>  unsigned long shmem_get_unmapped_area(struct file *file,
>  =09=09=09=09      unsigned long uaddr, unsigned long len,
>  =09=09=09=09      unsigned long pgoff, unsigned long flags)
> @@ -3475,6 +3494,10 @@ static ssize_t shmem_file_write_iter(struct kiocb =
*iocb, struct iov_iter *from)
>  =09ret =3D generic_write_checks(iocb, from);
>  =09if (ret <=3D 0)
>  =09=09goto unlock;
> +=09if (unlikely(IS_IMMUTABLE(inode))) {
> +=09=09ret =3D -EPERM;
> +=09=09goto unlock;
> +=09}
>  =09ret =3D file_remove_privs(file);
>  =09if (ret)
>  =09=09goto unlock;
> @@ -5286,6 +5309,7 @@ static const struct super_operations shmem_ops =3D =
{
>  static const struct vm_operations_struct shmem_vm_ops =3D {
>  =09.fault=09=09=3D shmem_fault,
>  =09.map_pages=09=3D filemap_map_pages,
> +=09.page_mkwrite=09=3D shmem_page_mkwrite,
>  #ifdef CONFIG_NUMA
>  =09.set_policy     =3D shmem_set_policy,
>  =09.get_policy     =3D shmem_get_policy,
> @@ -5295,6 +5319,7 @@ static const struct vm_operations_struct shmem_vm_o=
ps =3D {
>  static const struct vm_operations_struct shmem_anon_vm_ops =3D {
>  =09.fault=09=09=3D shmem_fault,
>  =09.map_pages=09=3D filemap_map_pages,
> +=09.page_mkwrite=09=3D shmem_page_mkwrite,
>  #ifdef CONFIG_NUMA
>  =09.set_policy     =3D shmem_set_policy,
>  =09.get_policy     =3D shmem_get_policy,
> --=20
> 2.39.5
---1463770367-921943916-1765253696=:4936--

