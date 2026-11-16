Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99543606A32F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 17:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZHhtp9dV
Received: by kanga.kvack.org (Postfix)
	id 912616B05B0; Mon, 16 Nov 2026 12:17:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C35D6B05B1; Mon, 16 Nov 2026 12:17:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B2486B05B3; Mon, 16 Nov 2026 12:17:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 532F96B05B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:17:02 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DE06AA7099
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:17:01 +0000 (UTC)
X-FDA: 85441637442.23.9BF8F40
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf21.hostedemail.com (Postfix) with ESMTP id E828A1C0005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:16:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ZHhtp9dV;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794849420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cvhlwTnVB5qObUR1donDWKQFcI5lhmN3ZPbArGLp5LQ=;
	b=QAO/yIpcXkJZtpR7ItLxH+iLjCjOjehsxH+4urQw06i988fM15Hy6AqCsKKFHSK8eW8EQh
	nDo2k1yZGbzSZncc0YhWYR29ELiLTyshZmVQyKsqE+kh8NY00y71fwCVZDdyHiEO5Rokj6
	lgCUTxKh+VbCyHtvK6hIMZ2UvK6oXzs=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ZHhtp9dV;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794849420;
	b=i5nIbU13IxFFsdGpPO53kE13YOW+MLP6OlXGglC9zsbMSu/4iL3CGe6DVZa86QcNa9vPMf
	8rmFDwe7Z+hZCSKZ3r4Xm5DRXXL2nd0EJiuc32QaF4wGpr5OQIG7O1QtAXRrHjzhG2Umfb
	a1HD4M7lEiN6CGQNKh1KPNkk9nti8UQ=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b6e7a05225so5737916a12.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:16:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794849418; cv=none;
        d=google.com; s=arc-20260327;
        b=p0a7REIZk2MesoSFTehTrHkozPM2gS9Bn1Y410K/dHY7gKX+GmZk140IAWGC3ZufLQ
         5GfTtVi+QjDEuUeTL45pc1+RLNaOg+KhiauDr14Akyod/+uLw8Da30qkxPtwPejAgCX9
         NpxaGu3W0zpQpKqf3QJ7QgMkznSotOGnTVtPG0WsAbdhdYX4rHzBkgKep3yymmIJFZru
         1zRTdHGwJhkszcInskfYAmkumWTxif7BTmFB7Ju6u3pIdkU4qOVsVvfU+oT5gVVmknlW
         6p4OfcTQ6mo2gRhPN3vvQY1vYEp/4TXoBK4h3AiNf54YMpg/9n8nXTBG/Kr+IW4rSANK
         IYCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cvhlwTnVB5qObUR1donDWKQFcI5lhmN3ZPbArGLp5LQ=;
        fh=hkIAImEPzT0cYG0xN6gbWR2/yC3UwSUHT15lOX08AUQ=;
        b=ploRAgD9ORXykCyvAAi9KBMmwf+ybUS98wV7A0RO0KL/mgPg317KM5BwrhmWt0C0eT
         y63UsO4lAj/iRnrYx6sZjv26IRNwmK4If6s8rItMOv+R7BPNoH8JYrXRc4ERxgy/BiQM
         HwmV3Ebqm1V4f+kk4rrlN6RTxPpL1B+Fn0HQUmnFU9aQClH5gfa++LRDoNbPPHhIhxTy
         ulqYiQ/jq80XLDBmGwVGnA3sMtH4WUEyWCvdhOJ58n/gFtUTGVpVN+ayTUrqzzmMW4id
         WEH4w8xIWd7U2eslb2WqjiJOxbkhc7FJw/m441jeRIvYuleZHkiVQx9kukmoBSfEL9oS
         cs0Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794849418; x=1795454218; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cvhlwTnVB5qObUR1donDWKQFcI5lhmN3ZPbArGLp5LQ=;
        b=ZHhtp9dVDS6WNG5MIvW68VC5sUnDqcsCQ6X+qip6BHlU1Tg/xG7RHkFSN46M9UNMs3
         zeiSu4mTTMe9dTxjyo8jFjp+cMU1zgtyEiXM0GU0J5X5KI0o5MRz9YqsfNjiQYgkZdIe
         wVWrzxkfzzNHhOOGP1KVnqBYmlvDO861V1LhXHE4skIfKoTrPMRxM/ZkIuLaZjQA1OhQ
         YeNW2u5gwug/8FPhSzIcOFmR7jer1g/DkIgleFOuIo116HBMrxVaBegBC4NzwgiGZaBd
         n4fHiPQrINpKFY/diC4IoCGBNz0DcdwYN/HUhjrCosAonGE3zF7drdEgPjgN97ih6zMJ
         /r0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794849418; x=1795454218;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cvhlwTnVB5qObUR1donDWKQFcI5lhmN3ZPbArGLp5LQ=;
        b=mfbofQLj1a3smZ2MNowzxShyIgM+qsEH9BgyBMZg0GEtXJ/baMQe6P/OsRtK0JKCSj
         PwpCM/Cnsg7N24DRwo96yG8hL1aHtcyvqw3ul8NxAuXig9Ezuq7fzEExS6xbaxAlL+Ux
         jWGmWGI88sf60wX2xSm8vRig2NlkEItT4iFpscXdTAHrceAY/wbpVAq/avp+qhxk09Rl
         roUPNZi0r4VHKViPH8jDZCYc4ZyUCDM9aLZujEwe7ckEGPl5170bg9NW0mD6iQaUnPSK
         49NL7u5IgkmaQuchHwP+SUiyUV/KwIzYM7e5GO3/PjcXHUBxscuI1nIR+0fKhWMxKDfo
         q9Ug==
X-Forwarded-Encrypted: i=1; AL+hErFAQIooA/8q708feoihQeUlpMvXoUnV8XYinxBNkMRKeVKH+CVy2ijgarhbmnp1FJmpUqpIu+GOEA==@kvack.org
X-Gm-Message-State: APuU4Z8NbO1XlcZzvNm9yK18mroEvzwClJtJ0JgOjCk1WwdPOL25+9V9
	xOYk82+fIQ4PYyYMMT9zwfKaizqKWOOM9btNx/Ovtxa7vvgHN9FDQa5sexE/yhItyZF2jq1FXcd
	+dtLsTNqI/daRQxOZ+L/K5/4ZbYVWRjo=
X-Gm-Gg: AYBFou2obi6kPe6EF8OM1vSi3AMU3GkAjbvfuMGPnSBE9saTpaIpuwqnBytOa4CzHKs
	i3MNhgsgpRK0tsCGDC+tpxTk85Z3oqwaAsFNO+1zpOCVOBsjwX/XUjHT32lpJzS/ZHja7HfSM6S
	ZchSmQGmBdJYAOsubFeQgBxSqedthqKNAoKIsOZOBfeh/zBsIbLr6XEOj8xUeaT25EK/NddTVkz
	e7uuzAoTVcXpO7hd4pI3lY6dDNC9jmbO3BSRdQ/s7vRbIZN0ocA/LkS0OZRII8v50ctzx3aWrIW
	i9y4ocacRJxIyZh9UpajFXJ/U9MVH9Uspaq/DLEe9gsGIorhvU5m7n+I5Lgea7kPDo9nkUclTS9
	aKcKJJNWhHVNm79FNsEFRAjZchkWUpiUvIF9i+6oGEVYv2PVaFWSzgyYzib85DN/gXAfhzQV4Yz
	H35lRCAcs47vCnT7U=
X-Received: by 2002:aa7:c258:0:b0:6b7:d69a:a3d3 with SMTP id
 4fb4d7f45d1cf-6b7d69aa8fbmr5089335a12.39.1794849418257; Mon, 16 Nov 2026
 09:16:58 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org> <20261116-work-loop-pseudo-v3-34-8cbbea1cf34f@kernel.org>
In-Reply-To: <20261116-work-loop-pseudo-v3-34-8cbbea1cf34f@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 16 Nov 2026 18:16:46 +0100
X-Gm-Features: AclHuK_s2Kpb4OdbgPngYJl9gLHjfhlAmiJMqLtxRnpTDibz-Ni4SZJspSV9laM
Message-ID: <CAOQ4uxjJVgy-skUbbScfz=eAEATf=iMpqRHNshX=eKu3oiwnrA@mail.gmail.com>
Subject: Re: [PATCH RFC v3 34/44] selftests/ovl: test data-only layers on
 pseudo filesystems
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
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
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: qqn9iuhqogt4sotiohw9phuuk8jnw5rt
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E828A1C0005
X-Rspam-User: 
X-HE-Tag: 1794849419-316444
X-HE-Meta: U2FsdGVkX1+6vOO1rIikQczGZmaxG9QCO8FJSfJdJY2wJkkqgQNIfbhbMTaWvWdklBWDXn3bbqAA4uwFGp+NJopwqOi1AWcliFkjmE8zaFt3vdwiXKPOM/4foKHy5GiXXTvzRawQimZ9RDBsBWm8ioZVr5Iam/9ZyR5LWAINgDMYYeV/2wgGy4vmUkwInbwen+qRhB6ZEv82WmqNjJVD+ToRh2Zy3KdFPP9Jg7GIWBhEpnX4P9Nl4Qq9YXu7vc4Pc1+GUwyg2PJpMbiTYZyMqmuCXiX9FZY6BXLvBfY2ONzSGl0ZF9X1kw6x7z538WkNO/85YbIgG2o6Z9pGuzTpw1fIlOmZkxT8AkrRrSc5y8xNB5AgiUiB/pnAfH1VoIaaCdOq/qJjEdyzd9hSqU5PdnuprUFmteUBbhIJC0FcYYYgyl2fFV5anpyXhBI82Q2esQmBNi0hhIKYsn/W6BzMojLtfEKPTvYWnnnEsspsKkNakz4ao55KUj4yVWEPNBogNvXTDkzzpsA9F/XBc4PP7eJ2iaZ2teq3VIjOeqtTVDlzEdcDzVTTZpIdudMcnxuP18jRoteBj4mjQZ3XdbelzLzIA0LX9XV2+y/+G14YMHVFZlC/d+EhSD+QBRryQXEx2qnTF7j5RuWrK1HIrdJWngGC+aYxefeXh2GOoNOF1AneqlWD4wZWXAdDv7f8cDcniktpereaZzPMnkiv9d8zoLoywuTJxULt8zJEO371OnoWUUP1Ps6vP1yU2nKhzhBK1hFrxPJj/mux3udBKWJMjKTnz+5lXh9FOsG218bLhqv9YummmpJCjG06AHYL2sWskZ9LNVZk7I/D0Dy9kfbX1eWZG8NU7qCw4CDm5dm1mLvkNYZd9iu6erVBZTCHOiwRtEDgNAc1OVL0NnCjLOBcfaDv89xiwLrRNV0AyTgSrVMOunIOKaZXecQ5NuYdWJyxkiMdHlzE7xS9pdPVzxo
 A4OGXgiD
 xlhEpjJlfinC3mt0ckFi6rrDaJcyFNSWXQAsBRNhEG2g8zZTHKr775rWxYKa0jf3I2IqRve/RXMQu3uompUteELJ5oeTnEPkHHCWH/hVXYn5YxWRGVfrJll6BTMptQ8YbWNv4IvFg/jNOepDYWv/isSl8GAvZ24vvP8WADA/WWXPnaSAmTcosUAjgggWPjwG4zI1O1SIgtqKAtareJ1M1LuupEj4AMjvOd2fQQv3bJvqzKAAwiz8HNvsacKTi/tnhVakWJgWR3nGDVqe6E70ai7IInQktWxcvxT0BkLV794wulupoctRwIPqpHuXgYY4kIrqvZp5nhsDvpt/YMUXr3zT6ivh3r0uni3omRf51V6dwx8Msxpgxh+z1d1ynR46DRzcY9pL/OqXTVaZHsFcDbEPGIhyCS+vevEXdl4CG4jczA9QeZ+VXMf2PP5rJOosCIRzSdfs/C8NKX5U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 12:10=E2=80=AFPM Christian Brauner <brauner@kernel.=
org> wrote:
>
> Add tests that overlayfs refuses data-only layers on pseudo filesystems:
>
> - sysfs and procfs via the "::" separator in "lowerdir=3D"
> - sysfs and procfs via "datadir+" by path
> - sysfs and procfs via "datadir+" by file descriptor
> - tmpfs as data-only layer
> - sysfs as regular lower layer
>
> The last two must keep mounting.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  .../selftests/filesystems/overlayfs/.gitignore     |   1 +
>  .../selftests/filesystems/overlayfs/Makefile       |   1 +
>  .../filesystems/overlayfs/pseudo_datadir.c         | 131 +++++++++++++++=
++++++
>  3 files changed, 133 insertions(+)
>
> diff --git a/tools/testing/selftests/filesystems/overlayfs/.gitignore b/t=
ools/testing/selftests/filesystems/overlayfs/.gitignore
> index b343cc430051d..e1410fee2269d 100644
> --- a/tools/testing/selftests/filesystems/overlayfs/.gitignore
> +++ b/tools/testing/selftests/filesystems/overlayfs/.gitignore
> @@ -3,3 +3,4 @@ dev_in_maps
>  set_layers_via_fds
>  idmapped_mounts
>  automount_in_layer
> +pseudo_datadir
> diff --git a/tools/testing/selftests/filesystems/overlayfs/Makefile b/too=
ls/testing/selftests/filesystems/overlayfs/Makefile
> index 382a59bda5e70..ace75f5627e0f 100644
> --- a/tools/testing/selftests/filesystems/overlayfs/Makefile
> +++ b/tools/testing/selftests/filesystems/overlayfs/Makefile
> @@ -10,6 +10,7 @@ TEST_GEN_PROGS :=3D dev_in_maps
>  TEST_GEN_PROGS +=3D set_layers_via_fds
>  TEST_GEN_PROGS +=3D idmapped_mounts
>  TEST_GEN_PROGS +=3D automount_in_layer
> +TEST_GEN_PROGS +=3D pseudo_datadir
>
>  include ../../lib.mk
>
> diff --git a/tools/testing/selftests/filesystems/overlayfs/pseudo_datadir=
.c b/tools/testing/selftests/filesystems/overlayfs/pseudo_datadir.c
> new file mode 100644
> index 0000000000000..3b59fd3e9f5c2
> --- /dev/null
> +++ b/tools/testing/selftests/filesystems/overlayfs/pseudo_datadir.c
> @@ -0,0 +1,131 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#define _GNU_SOURCE
> +
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <sched.h>
> +#include <stdbool.h>
> +#include <stdio.h>
> +#include <sys/mount.h>
> +#include <sys/stat.h>
> +#include <unistd.h>
> +
> +#include "kselftest_harness.h"
> +#include "../wrappers.h"
> +
> +static int setup_tmp(void)
> +{
> +       if (unshare(CLONE_NEWNS))
> +               return -errno;
> +       if (sys_mount(NULL, "/", NULL, MS_REC | MS_PRIVATE, NULL))
> +               return -errno;
> +       if (sys_mount("tmpfs", "/tmp", "tmpfs", 0, NULL))
> +               return -errno;
> +       if (mkdir("/tmp/lower", 0755) || mkdir("/tmp/data", 0755) ||
> +           mkdir("/tmp/merged", 0755))
> +               return -errno;
> +       return 0;
> +}
> +
> +/* Mount an overlayfs with the legacy "lowerdir=3D" option. */
> +static int mount_lowerdir(const char *lowerdir)
> +{
> +       char opts[256];
> +
> +       snprintf(opts, sizeof(opts), "lowerdir=3D%s", lowerdir);
> +       if (sys_mount("overlay", "/tmp/merged", "overlay", MS_RDONLY, opt=
s))
> +               return -errno;
> +       if (umount2("/tmp/merged", 0))
> +               return -errno;
> +       return 0;
> +}
> +
> +static int set_layer(int fd_context, const char *key, const char *path,
> +                    bool by_fd)
> +{
> +       int fd, ret =3D 0;
> +
> +       if (!by_fd) {
> +               if (sys_fsconfig(fd_context, FSCONFIG_SET_STRING, key, pa=
th, 0))
> +                       return -errno;
> +               return 0;
> +       }
> +
> +       fd =3D open(path, O_DIRECTORY | O_CLOEXEC);
> +       if (fd < 0)
> +               return -errno;
> +       if (sys_fsconfig(fd_context, FSCONFIG_SET_FD, key, NULL, fd))
> +               ret =3D -errno;
> +       close(fd);
> +       return ret;
> +}
> +
> +/* Create an overlayfs with "lowerdir+" and "datadir+" through fsconfig.=
 */
> +static int fsmount_layers(const char *lower, const char *data, bool by_f=
d)
> +{
> +       int fd_context, fd_mnt, ret;
> +
> +       fd_context =3D sys_fsopen("overlay", FSOPEN_CLOEXEC);
> +       if (fd_context < 0)
> +               return -errno;
> +
> +       ret =3D set_layer(fd_context, "lowerdir+", lower, by_fd);
> +       if (ret)
> +               goto out;
> +       ret =3D set_layer(fd_context, "datadir+", data, by_fd);
> +       if (ret)
> +               goto out;
> +
> +       if (sys_fsconfig(fd_context, FSCONFIG_CMD_CREATE, NULL, NULL, 0))=
 {
> +               ret =3D -errno;
> +               goto out;
> +       }
> +
> +       fd_mnt =3D sys_fsmount(fd_context, FSMOUNT_CLOEXEC, 0);
> +       if (fd_mnt < 0)
> +               ret =3D -errno;
> +       else
> +               close(fd_mnt);
> +out:
> +       close(fd_context);
> +       return ret;
> +}
> +
> +TEST(datadir_sysfs)
> +{
> +       ASSERT_EQ(setup_tmp(), 0);
> +
> +       EXPECT_EQ(mount_lowerdir("/tmp/lower::/sys/kernel"), -EINVAL);
> +       EXPECT_EQ(fsmount_layers("/tmp/lower", "/sys/kernel", false), -EI=
NVAL);
> +       EXPECT_EQ(fsmount_layers("/tmp/lower", "/sys/kernel", true), -EIN=
VAL);
> +}
> +
> +TEST(datadir_procfs)
> +{
> +       ASSERT_EQ(setup_tmp(), 0);
> +
> +       EXPECT_EQ(mount_lowerdir("/tmp/lower::/proc"), -EINVAL);
> +       EXPECT_EQ(fsmount_layers("/tmp/lower", "/proc", false), -EINVAL);
> +       EXPECT_EQ(fsmount_layers("/tmp/lower", "/proc", true), -EINVAL);
> +}
> +
> +TEST(datadir_tmpfs)
> +{
> +       ASSERT_EQ(setup_tmp(), 0);
> +
> +       EXPECT_EQ(mount_lowerdir("/tmp/lower::/tmp/data"), 0);
> +       EXPECT_EQ(fsmount_layers("/tmp/lower", "/tmp/data", false), 0);
> +       EXPECT_EQ(fsmount_layers("/tmp/lower", "/tmp/data", true), 0);
> +}
> +
> +TEST(lowerdir_sysfs)
> +{
> +       ASSERT_EQ(setup_tmp(), 0);
> +
> +       EXPECT_EQ(mount_lowerdir("/sys/kernel:/tmp/lower"), 0);
> +       EXPECT_EQ(mount_lowerdir("/sys/kernel::/tmp/data"), 0);
> +       EXPECT_EQ(fsmount_layers("/sys/kernel", "/tmp/data", false), 0);
> +       EXPECT_EQ(fsmount_layers("/sys/kernel", "/tmp/data", true), 0);
> +}
> +
> +TEST_HARNESS_MAIN
>
> --
> 2.53.0
>

