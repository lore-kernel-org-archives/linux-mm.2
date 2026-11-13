Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E5BD606A8AD
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 10:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ZqMvlq+1
Received: by kanga.kvack.org (Postfix)
	id 5E2EE6B0686; Fri, 13 Nov 2026 05:28:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 595CB6B06A6; Fri, 13 Nov 2026 05:28:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 483106B06A7; Fri, 13 Nov 2026 05:28:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2247B6B0686
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:28:45 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8E5D21C271E
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:28:44 +0000 (UTC)
X-FDA: 85429722168.17.254A201
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf03.hostedemail.com (Postfix) with ESMTP id ADDB320004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:28:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=ZqMvlq+1;
	spf=pass (imf03.hostedemail.com: domain of alex@amutable.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794565722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HIAZ+a2RY8snYu8gjwIzGL7aFLB+UDjcbceUrGWDUl0=;
	b=nYF67nvwcCTkWzZaApWVoLOAVt0RElZ8auF2TnW07G9X8pBUpf5oaGhh/sh8qyqHLdXudQ
	CHPdWuOGK0+OG48fTYxn9kpR+viP4iPEQ5lp/tpp4XNuqRy54zpXCgSLDSdN8B4lP8ybnt
	rMpUqIS/uu9GukCuK3IBeyLPMK/r4AE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794565722;
	b=B+CHYpkb2+JP35yKSMqDSnaZjgZUq2yMzpRs85Y3tR9m0bWB9HwV11G05jFq5XmKq3oBUE
	Ru837V2RjlNQdiAQ9Vm+r8TghxH5U/E8KxKBOP264D4qpmSShm8Qd/uRGIaZQIvSCdmNbe
	moWxuwV07vzOSLsk+Hv+8ZqoHOhJouo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=ZqMvlq+1;
	spf=pass (imf03.hostedemail.com: domain of alex@amutable.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a5177d78c7so11141925e9.2
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:28:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794565721; x=1795170521; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=HIAZ+a2RY8snYu8gjwIzGL7aFLB+UDjcbceUrGWDUl0=;
        b=ZqMvlq+1r/r6N+OG+APTEeCTVCkg6nUYiQfFOEbzGleNhAH5atvnu1HdIIaRGJe0ZO
         Ih8Gb5rf7QaYXHPcsYcquERz6bvXX6aGdBgOat8SimhIcP8d2xySVXei931WFhf25mhD
         aca08uLqq21Kvlkjs4DG9byLuZJJ67QDTswo+uXnYtExGDSU5i9XwBtdClWssF8lv8dV
         WMP7mQoqeZclSPFQIicAntdupjDmqdT9K8ysZvx14e5JTr9rPoAsqq65xye7UakYYhbt
         GTE1tZVJi2I34k8Jt6helaBuHW/0+6Aq37tLPZlzRoy73PwWRatxNu8HsE9N2K0/uZ5u
         3XPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794565721; x=1795170521;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HIAZ+a2RY8snYu8gjwIzGL7aFLB+UDjcbceUrGWDUl0=;
        b=Jq0MlDOLjRDBAXlLS9w5riEO2rIaHn2VGEqlKDHg2oJ75QplGl/9XlrKDfSr3MJ34d
         J7P15yBxlq8kRRW3pKrqThExlVFqP0HmVjcltu+8biwaD25GnIrjMKGL6Clu0Gq1SGUF
         WiopaGJB8DsRpc3frPbZpr9uxNUyPrl6wDvq6giIWixf6UkCcdMkO6WQjSM1UUxP2Dne
         s5Hfx882rOacikPs1o9Br21PrSzlwjoQS5PsCyTqg4+XZp8bMeBNQJBS+xrOohqkJWOT
         1OQeWAliPmrxmvI/I/LSez3W4+80cAhMN89yQLeIf5ePLBfQT85wLqywhlaHYc6+IuAJ
         PESA==
X-Forwarded-Encrypted: i=1; AL+hErEvhwUQSP5brkY5YwactelnSFLOmKDjw3H4kmBbsNCec2Np4BLv8ZWzNFARwnyNrmZd1DplXvfLEQ==@kvack.org
X-Gm-Message-State: APuU4Z/9HtZNXNSqSOxaG95wkpiHMlYxYTycJXXPu73DMLzHX0H73Dgb
	dcgGISU0E/oagaTbikzBqXLl4cOZjVUmBJwdNDVIYV0XIap7G2sPdpyTcrmhSmNKzWnF
X-Gm-Gg: AYBFou36o8bNn+xuxlp5m4Is8pw2SOB0QcuV2Sw8X2nEYIeBjj0RlQX6oOGsqpBpdf3
	DmQiQLoQClHuNzqffQy7JYqLr26QU90fEUhTgkvukEos68B9AnOML210F67Z6Zlm8jH4GFPigJ5
	ElInrEhZpoG0mdlog1c6XmD5HrCehPbjaw/5JiLFjuLEe2uHvOhm8IXcqiQWARYDTKB803vthFr
	yNmwd8ssoAyOK7s7xxm4HO47jeAfxH/odeWnWq6ocE0TE650v2MJjcBayPmJEtgASSkjKOGaleC
	yF812qyyHSbcp6XvwtCczzQhcYBy8i6a2ITZKKTPnUN/0Tx6Ii13bicDxHQoTkKHSkHAakGvBJz
	7UgcG436cLSjfLDC1ugll77LfsiQKKdL1ZTP3I/5BWAAEAVFr4SIOwDLyooP0L48NQRNAjHBr1B
	KndciY5DSsGhGhiubBYocVckekMNYceDFHL+X6L8uGUP7yml/ghwTPYEvLhw13OpAWC7ps0njuT
	/CH5ZgC5A37YBWtc/uXOlNfe+Qr1X20LyxgeCDwrsOD+ItsGkfEUKAsnEIlamcjNnIKGOqGpoTh
	XS8AWwBYsWhzdwyB8DBkby3uM49MpVx4by0ZJUzF6X9OXTD5OgbkwvqctDYQmIo=
X-Received: by 2002:a05:600c:428c:b0:4a1:9661:14b5 with SMTP id 5b1f17b1804b1-4bb55aabd53mr26666375e9.29.1794565721222;
        Fri, 13 Nov 2026 02:28:41 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e252f7fsm152260095e9.2.2026.11.13.02.28.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:28:40 -0800 (PST)
Message-ID: <ae5a09a7dc0ab5d01e78114c38e90b39af32362c.camel@amutable.com>
Subject: Re: [PATCH RFC 41/41] selftests/filesystems: add backing file tests
 for pseudo files
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
Date: Fri, 13 Nov 2026 11:28:38 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-41-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-41-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: a88rpj4u6axpqnajmjkjr9kt5pwo1wu7
X-Rspamd-Queue-Id: ADDB320004
X-Rspam-User: 
X-HE-Tag: 1794565722-817129
X-HE-Meta: U2FsdGVkX19ivZ4RurWwheMTzBGofVGOTJ71VZfTanh6vnSAMRdsfAhF80/HRtE1Hu9W9mEIa/bVBja+W0zFuugqlUqw+91jD+HuNE0LV0Ob6XTV99/X599aMOdmpT0RU0MhYV1hFGfkg/Dr8OaQwxbVAs6OTQCn0w4pWpTUtJFUJkRY8ag5cqHsv/WbhXj7Fo3ayOJPh8y4tUK0+J69CQCljfG/h3EqemasnqOdfgc291HTCXpqu11/DsAjHNWhjJgmWfKQJO/KLQQxWSuomOIi3xt+fjxlJFU430GneP7xLeqqQMl5+cDrWkMpR171p5A4bGcRmb4pyfXpINuBenInbL9cGk9nblARZRBz3ceaL7RcGKrri863nHnZ/gTJEnHLOli71iVMZ7GF/h96GpYDvlsg6xMmmCij1JQI7DnljDBU3uBzBhi9d4AjB2GyTN6UT/pvR0pgF33MRPLjtFeDDluPCIJi7ufRcFdR0JUAhwW/hdxSf7NxEX9UPRnsEj/JIC5KzjufaK4Z5w2YGGpPmLZ1uz4NqDmHidByOYKp+rsNpmXmXwr2qs5n3ufirOFVTY55QgHAoUPmU4mCg7in9pUx4wb0ApiCJeq0a/h16soWG1QKkS6AfLKtFF1bhKywQqk1CkZC6Hyg2zazrgVxNW2E7TzdR0sfu1ef1yUbXnNrXSLMpxMMzEetywgvEyyU2sbL/Y3sLyKm2YC76WIZodSV45py5nkxqd6f3M2KAcjSUaXilGWoSy34st4mY9bR8apFQ0Bcl59dGkTUvshhjcEfXdZuJW+VYKegMfe68AvlD2FFCX+8FvlCpvR5pUfcWjyVxrJNOgHt3DjMPX77hfiYAji2W4LLihWxTvTdH9JSoSiJ9QUq1Op5lkQmgfwmtg8OOEd3GMv1NfKmYzb+E3HW9dYi2GMg6sy7VnrTH8uGF/JLG2bGv72mcQ4JuHp6YlXXVcEmW0FCZCZ
 mPFGyxAA
 6zki7RYYrC1uWYOH3SNwKnqB1Y5FBnTjW3BaRXZp1iklMB9YY20Lglr/9mH3R3XGI5Ptz/yfur4rTE4fhWl12fOY//Nr/NPshIazrL0Wdt9CaZdIPcbT3CRkpmkbWY0KAHEFsiAL1f2iSNYTC8I+ywNt6HFYDdisW/nnW3w2/unMpLK2SqyVdzMdFphyKafo9DZBMuT6p2XYpsxaHs2EEGASKSFWh0uqX3OwC18bfWlnuWR2fk1oaqb2skFNxDd+FcLVv4W95j9644dKnneYdjj526Bv+EPGRfHUUJ/C/Oyax3WSgK6QIjADZKx1Cq1focNbZjsdxyEhmugQ08XS7Q1+81ycSIs3ptdUkUlxp+g1HWSazAA7/bAKRM4tHzuFqrMa5kZrfLKCPODnd7Ihc4LRkVpYAWqv1RESoGNwgAi5ALICHpyrTC3jB0ajdHyCIcI1sTvIlCjY4FLywcRN1goYOS3JF9skBW7WrvkqXnZFid6P0a5VVVshvj5t6Srms3ued
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-11-10 at 10:14 +0100, Christian Brauner wrote:
> Add tests that files on pseudo filesystems can't be used as storage:
>=20
> - a procfs file attached read-only to a loop device
> - sysfs files attached read-only and read-write to a loop device
> - a sysfs file behind a lower-only overlayfs attached to a loop
> device
> - a sysfs file as the backing file of a usb mass storage gadget LUN
> - a sysfs file as the source of a file-backed erofs mount
>=20
> And make sure that a memfd and another loop device still work as loop
> backing files and that loop refuses a backing file that isn't open
> for
> reading.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0tools/testing/selftests/filesystems/.gitignore=C2=A0=C2=A0=C2=A0=C2=
=A0 |=C2=A0=C2=A0 1 +
> =C2=A0tools/testing/selftests/filesystems/Makefile=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 2 +-
> =C2=A0tools/testing/selftests/filesystems/config=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 9 +
> =C2=A0.../selftests/filesystems/pseudo_backing_test.c=C2=A0=C2=A0=C2=A0 |=
 274
> +++++++++++++++++++++
> =C2=A04 files changed, 285 insertions(+), 1 deletion(-)
>=20
> diff --git a/tools/testing/selftests/filesystems/.gitignore
> b/tools/testing/selftests/filesystems/.gitignore
> index cf79000e4092..8df38eabb125 100644
> --- a/tools/testing/selftests/filesystems/.gitignore
> +++ b/tools/testing/selftests/filesystems/.gitignore
> @@ -7,3 +7,4 @@ kernfs_test
> =C2=A0idmapped_tmpfile
> =C2=A0ustat_test
> =C2=A0rw_hint_test
> +pseudo_backing_test
> diff --git a/tools/testing/selftests/filesystems/Makefile
> b/tools/testing/selftests/filesystems/Makefile
> index fbd5c27505ef..0ebb9005bcd2 100644
> --- a/tools/testing/selftests/filesystems/Makefile
> +++ b/tools/testing/selftests/filesystems/Makefile
> @@ -2,7 +2,7 @@
> =C2=A0
> =C2=A0CFLAGS +=3D $(KHDR_INCLUDES)
> =C2=A0TEST_GEN_PROGS :=3D devpts_pts anon_inode_test kernfs_test fclog
> ustat_test rw_hint_test
> -TEST_GEN_PROGS +=3D idmapped_tmpfile
> +TEST_GEN_PROGS +=3D idmapped_tmpfile pseudo_backing_test
> =C2=A0TEST_GEN_PROGS_EXTENDED :=3D dnotify_test
> =C2=A0
> =C2=A0include ../lib.mk
> diff --git a/tools/testing/selftests/filesystems/config
> b/tools/testing/selftests/filesystems/config
> index 9f45bc493a30..228196160d29 100644
> --- a/tools/testing/selftests/filesystems/config
> +++ b/tools/testing/selftests/filesystems/config
> @@ -6,3 +6,12 @@ CONFIG_NET=3Dy
> =C2=A0CONFIG_NET_NS=3Dy
> =C2=A0CONFIG_INET=3Dy
> =C2=A0CONFIG_SYSFS=3Dy
> +CONFIG_BLK_DEV_LOOP=3Dy
> +CONFIG_OVERLAY_FS=3Dy
> +CONFIG_TMPFS=3Dy
> +CONFIG_CONFIGFS_FS=3Dy
> +CONFIG_USB_GADGET=3Dy
> +CONFIG_USB_CONFIGFS=3Dy
> +CONFIG_USB_CONFIGFS_MASS_STORAGE=3Dy
> +CONFIG_EROFS_FS=3Dy
> +CONFIG_EROFS_FS_BACKED_BY_FILE=3Dy
> diff --git
> a/tools/testing/selftests/filesystems/pseudo_backing_test.c
> b/tools/testing/selftests/filesystems/pseudo_backing_test.c
> new file mode 100644
> index 000000000000..bc8e17ab8e6e
> --- /dev/null
> +++ b/tools/testing/selftests/filesystems/pseudo_backing_test.c
> @@ -0,0 +1,274 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#define _GNU_SOURCE
> +
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <limits.h>
> +#include <sched.h>
> +#include <stdbool.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <unistd.h>
> +#include <linux/loop.h>
> +#include <linux/magic.h>
> +#include <sys/ioctl.h>
> +#include <sys/mman.h>
> +#include <sys/mount.h>
> +#include <sys/stat.h>
> +#include <sys/vfs.h>
> +
> +#include "kselftest_harness.h"
> +#include "wrappers.h"
> +
> +/*
> + * Put @fd behind a free loop device. The device is set up with
> + * LO_FLAGS_AUTOCLEAR and goes away again when it is closed here.
> + */
> +static int loop_attach(int fd, bool rw, char *dev, size_t len)
> +{
> +	struct loop_config cfg =3D {};
> +	int ctl, nr, lfd, ret =3D 0;
> +
> +	ctl =3D open("/dev/loop-control", O_RDWR | O_CLOEXEC);
> +	if (ctl < 0)
> +		return -errno;
> +	nr =3D ioctl(ctl, LOOP_CTL_GET_FREE);
> +	if (nr < 0)
> +		ret =3D -errno;
> +	close(ctl);
> +	if (ret)
> +		return ret;
> +
> +	snprintf(dev, len, "/dev/loop%d", nr);
> +	lfd =3D open(dev, (rw ? O_RDWR : O_RDONLY) | O_CLOEXEC);
> +	if (lfd < 0)
> +		return -errno;
> +
> +	cfg.fd =3D fd;
> +	cfg.info.lo_flags =3D LO_FLAGS_AUTOCLEAR;
> +	if (!rw)
> +		cfg.info.lo_flags |=3D LO_FLAGS_READ_ONLY;
> +	if (ioctl(lfd, LOOP_CONFIGURE, &cfg)) {
> +		ret =3D -errno;
> +		close(lfd);
> +	} else {
> +		ret =3D lfd;
> +	}
> +	return ret;
> +}
> +
> +static int attach_path(const char *path, bool rw)
> +{
> +	char dev[PATH_MAX];
> +	int fd, ret;
> +
> +	fd =3D open(path, (rw ? O_RDWR : O_RDONLY) | O_CLOEXEC);
> +	if (fd < 0)
> +		return -errno;
> +	ret =3D loop_attach(fd, rw, dev, sizeof(dev));
> +	close(fd);
> +	if (ret >=3D 0) {
> +		close(ret);
> +		ret =3D 0;
> +	}
> +	return ret;
> +}
> +
> +static bool can_use_loop(void)
> +{
> +	return geteuid() =3D=3D 0 && access("/dev/loop-control", R_OK |
> W_OK) =3D=3D 0;
> +}
> +
> +TEST(memfd_backing_file)
> +{
> +	char dev[PATH_MAX];
> +	int fd, lfd;
> +
> +	if (!can_use_loop())
> +		SKIP(return, "loop devices unavailable");
> +
> +	fd =3D memfd_create("pseudo_backing_test", MFD_CLOEXEC);
> +	ASSERT_GE(fd, 0);
> +	ASSERT_EQ(ftruncate(fd, 1 << 20), 0);
> +
> +	lfd =3D loop_attach(fd, true, dev, sizeof(dev));
> +	ASSERT_GE(lfd, 0);
> +	EXPECT_EQ(close(lfd), 0);
> +	EXPECT_EQ(close(fd), 0);
> +}
> +
> +TEST(loop_device_backing_file)
> +{
> +	char dev[PATH_MAX], dev2[PATH_MAX];
> +	int fd, lfd, bfd, lfd2;
> +
> +	if (!can_use_loop())
> +		SKIP(return, "loop devices unavailable");
> +
> +	fd =3D memfd_create("pseudo_backing_test", MFD_CLOEXEC);
> +	ASSERT_GE(fd, 0);
> +	ASSERT_EQ(ftruncate(fd, 1 << 20), 0);
> +	lfd =3D loop_attach(fd, true, dev, sizeof(dev));
> +	ASSERT_GE(lfd, 0);
> +
> +	/* A block device stays fine as a backing file. */
> +	bfd =3D open(dev, O_RDWR | O_CLOEXEC);
> +	ASSERT_GE(bfd, 0);
> +	lfd2 =3D loop_attach(bfd, true, dev2, sizeof(dev2));
> +	ASSERT_GE(lfd2, 0);
> +
> +	EXPECT_EQ(close(lfd2), 0);
> +	EXPECT_EQ(close(bfd), 0);
> +	EXPECT_EQ(close(lfd), 0);
> +	EXPECT_EQ(close(fd), 0);
> +}
> +
> +TEST(write_only_backing_file)
> +{
> +	char dev[PATH_MAX], path[PATH_MAX];
> +	int fd, wfd, lfd;
> +
> +	if (!can_use_loop())
> +		SKIP(return, "loop devices unavailable");
> +
> +	fd =3D memfd_create("pseudo_backing_test", MFD_CLOEXEC);
> +	ASSERT_GE(fd, 0);
> +	ASSERT_EQ(ftruncate(fd, 1 << 20), 0);
> +
> +	/* Loop reads from its backing file so it must be open for
> reading. */
> +	snprintf(path, sizeof(path), "/proc/self/fd/%d", fd);
> +	wfd =3D open(path, O_WRONLY | O_CLOEXEC);
> +	ASSERT_GE(wfd, 0);
> +
> +	lfd =3D loop_attach(wfd, true, dev, sizeof(dev));
> +	if (lfd >=3D 0)
> +		close(lfd);
> +	EXPECT_EQ(lfd, -EBADF);
> +	EXPECT_EQ(close(wfd), 0);
> +	EXPECT_EQ(close(fd), 0);
> +}
> +
> +TEST(procfs_backing_file)
> +{
> +	if (!can_use_loop())
> +		SKIP(return, "loop devices unavailable");
> +
> +	ASSERT_EQ(attach_path("/proc/cpuinfo", false), -EINVAL);
> +}
> +
> +TEST(sysfs_backing_file)
> +{
> +	if (!can_use_loop())
> +		SKIP(return, "loop devices unavailable");
> +
> +	ASSERT_EQ(attach_path("/sys/kernel/warn_count", false), -
> EINVAL);
> +
> +	if (access("/sys/kernel/reboot/mode", F_OK))
> +		SKIP(return, "no /sys/kernel/reboot/mode");
> +	ASSERT_EQ(attach_path("/sys/kernel/reboot/mode", true), -
> EINVAL);
> +}
> +
> +TEST(overlayfs_on_sysfs_backing_file)
> +{
> +	if (!can_use_loop())
> +		SKIP(return, "loop devices unavailable");
> +
> +	ASSERT_EQ(unshare(CLONE_NEWNS), 0);
> +	ASSERT_EQ(mount(NULL, "/", NULL, MS_REC | MS_PRIVATE, NULL),
> 0);
> +	ASSERT_EQ(mount("tmpfs", "/tmp", "tmpfs", 0, NULL), 0);
> +	ASSERT_EQ(mkdir("/tmp/empty", 0755), 0);
> +	ASSERT_EQ(mkdir("/tmp/merged", 0755), 0);
> +
> +	/* A lower-only overlayfs serves reads from sysfs. */
> +	if (mount("overlay", "/tmp/merged", "overlay", MS_RDONLY,
> +		=C2=A0 "lowerdir=3D/sys/kernel:/tmp/empty"))
> +		SKIP(return, "no overlayfs on top of sysfs: %s",
> strerror(errno));
> +
> +	ASSERT_EQ(attach_path("/tmp/merged/warn_count", false), -
> EINVAL);
> +}
> +
> +#define CONFIGFS_DIR "/sys/kernel/config"
> +#define GADGET_DIR CONFIGFS_DIR "/usb_gadget/pseudo_backing_test"
> +#define MASS_STORAGE_DIR GADGET_DIR "/functions/mass_storage.0"
> +
> +TEST(usb_mass_storage_backing_file)
> +{
> +	const char *path =3D "/sys/kernel/warn_count";
> +	struct statfs sfs;
> +	ssize_t ret;
> +	int fd, err;
> +
> +	if (geteuid())
> +		SKIP(return, "needs root");
> +
> +	/* Mounting configfs on top of itself fails with EBUSY. */
> +	if (statfs(CONFIGFS_DIR, &sfs) || sfs.f_type !=3D
> CONFIGFS_MAGIC) {
> +		ASSERT_EQ(unshare(CLONE_NEWNS), 0);
> +		ASSERT_EQ(mount(NULL, "/", NULL, MS_REC |
> MS_PRIVATE, NULL), 0);
> +		if (mount("configfs", CONFIGFS_DIR, "configfs", 0,
> NULL))
> +			SKIP(return, "no configfs: %s",
> strerror(errno));
> +	}
> +
> +	if (mkdir(GADGET_DIR, 0755))
> +		SKIP(return, "no usb gadget configfs: %s",
> strerror(errno));
> +	if (mkdir(MASS_STORAGE_DIR, 0755)) {
> +		err =3D errno;
> +		rmdir(GADGET_DIR);
> +		SKIP(return, "no usb mass storage function: %s",
> strerror(err));
> +	}
> +
> +	/* Writing the path opens the LUN's backing file right away.
> */
> +	fd =3D open(MASS_STORAGE_DIR "/lun.0/file", O_WRONLY |
> O_CLOEXEC);
> +	EXPECT_GE(fd, 0);
> +	if (fd >=3D 0) {
> +		ret =3D write(fd, path, strlen(path));
> +		err =3D errno;
> +		EXPECT_EQ(ret, -1);
> +		EXPECT_EQ(err, EINVAL);
> +		EXPECT_EQ(close(fd), 0);
> +	}
> +
> +	EXPECT_EQ(rmdir(MASS_STORAGE_DIR), 0);
> +	EXPECT_EQ(rmdir(GADGET_DIR), 0);
> +}
> +
> +TEST(erofs_backing_file)
> +{
> +	bool refused =3D false;
> +	char buf[256];
> +	int fsfd, ret, err;
> +	ssize_t n;
> +
> +	if (geteuid())
> +		SKIP(return, "needs root");
> +
> +	fsfd =3D sys_fsopen("erofs", FSOPEN_CLOEXEC);
> +	if (fsfd < 0)
> +		SKIP(return, "no erofs: %s", strerror(errno));
> +
> +	ASSERT_EQ(sys_fsconfig(fsfd, FSCONFIG_SET_STRING, "source",
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "/sys/kernel/warn_count", 0), 0)=
;
> +	ret =3D sys_fsconfig(fsfd, FSCONFIG_CMD_CREATE, NULL, NULL,
> 0);
> +	err =3D errno;
> +	if (ret && err =3D=3D ENOTBLK) {
> +		close(fsfd);
> +		SKIP(return, "no file-backed erofs mounts");
> +	}
> +	ASSERT_EQ(ret, -1);
> +	ASSERT_EQ(err, EINVAL);
> +
> +	/*
> +	 * Something that isn't an erofs image fails with EINVAL as
> well so
> +	 * check that the source itself was refused.
> +	 */
> +	while ((n =3D read(fsfd, buf, sizeof(buf) - 1)) > 0) {
> +		buf[n] =3D '\0';
> +		if (strstr(buf, "pseudo filesystem"))
> +			refused =3D true;
> +	}
> +	EXPECT_TRUE(refused);
> +	EXPECT_EQ(close(fsfd), 0);
> +}
> +
> +TEST_HARNESS_MAIN

