Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC6DDEE6B68
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 22:50:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 268E86B0005; Fri,  6 Feb 2026 17:50:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 240686B0089; Fri,  6 Feb 2026 17:50:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14CAA6B0092; Fri,  6 Feb 2026 17:50:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 057A16B0005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:50:21 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C462613A7C0
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 22:50:20 +0000 (UTC)
X-FDA: 84415527000.27.E421026
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf15.hostedemail.com (Postfix) with ESMTP id E9DC7A0008
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 22:50:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OzxbI7B1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770418219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pKIcE6GoeXBIyuDrXKVfe0dIRC3Ib5hok4aF2odJDyQ=;
	b=E+umxpByYKIl/cBmtTaHzHHYK5T8ZxfpnI8VrpeNiKCMWYcS7Cs8EOaLZBGWciBwZUs365
	BJ/rltKYmlFLJnh6kPm72CrXt6RzrVOu44rQTdV09deUy1ttjvsDL4CN/QNsuiWtWv+5pY
	0B5BmFZ2G8U9lpt7mtD1w1aPj41gzBU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770418219; a=rsa-sha256;
	cv=pass;
	b=3O60lFHqw5AFkvGZZrT7c+ohHyg4etRFB7zAJ9ItGrLgZxk0JfwbxKDbLsEDaI2a8R4KUo
	UIb0pwNBb9SAhsaAodK8SRsalLU0XrY+hYyQ06PbM28p4RzwuqhhgloexIeUMOeyxOAGab
	enc5rqvv9TySdFn8aB9iryp8+FhT+AQ=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OzxbI7B1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-43622089851so2027009f8f.3
        for <linux-mm@kvack.org>; Fri, 06 Feb 2026 14:50:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770418217; cv=none;
        d=google.com; s=arc-20240605;
        b=iAtTCSfXidL62mbithVfbKjrJ+PolZuOHf7nj6Lvy8ol68R3aPXeCw7RqqugiROUX9
         ddarZXvGwMqlpxY8SQ8lyyoSZX6cLjPDMLHUt0y+lVC/x5P81oG+57m3HPGLLWZWwZH8
         bCrIZHQ5dZ1AMSNGDUHNXjcnukW522GL17V5yut8t5GWk8cPUUOX8Q3rfDXYD+1DkUpp
         OK6nyzPyI7iSV5Z1BgdBo4WsnI8YLPT+8ams+5C60VLbs+hwWVb+FD4jqXFd2CufDzjk
         6UzZn7mhWqHm2W5bs7h70CReRnHCcVVwSGbIlcp4PivSSf/DzodrNx3irg39ag/g4Dwc
         ii3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pKIcE6GoeXBIyuDrXKVfe0dIRC3Ib5hok4aF2odJDyQ=;
        fh=5KOuR3njivOz7QRPghmb7pBMpDVh3c+3dnjUWdsMj1w=;
        b=KIxMYJTeGe8C7CZWZSkdExrULflK4G7hopcX3npv2wjAzWppO3EwSvHuPV9bNqHzQP
         kHJqqYSOtUbsmAjditcJ/jVTqppLok8v08BqFwdV3fY2lA2hkv1dC3XL2CJi6J38irr1
         VlROZ8eumInC3a6aY+gufURtdzvmEafd0eaCd4QJjEseOk/Kvx44cRFm2DEjHsnOBh9H
         91WzTupEKJjRFsY02/1fPB9Fqw1T0Hf/SdsUNUyem36bzjspkZI7xzQNLGu9rL6A3bbU
         iFoqzyCxeTVpYysOBD5NEI30bYmhWZy8MKWejpdaoL3hkupPnFUDXFOKay0TqA2gsr07
         gb9A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770418217; x=1771023017; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pKIcE6GoeXBIyuDrXKVfe0dIRC3Ib5hok4aF2odJDyQ=;
        b=OzxbI7B1FBFhNpSCz5/1Ukhw7F+vaaeyVfq28ZVGIiiTQxGndnydGnt+8llKTSRnHg
         adQPUAIKl6f3P5sd6C5RUDR0XFW2Qtw5PmsuR1hQdKiXYOoj7EZ47Oez2w4vKB17IoLr
         v+B5kPJg1RCcsnwx4fHpIIshk2skpTrcn5tSRre9XE7tU6Q8HdaLHgBoQeAzBWG8GlJz
         v0T+EpMjmyzdYUHJGwH9ogojdCwzKRZ++lnNAgl84DlvFGrPVft7m+CaMvkjO8u0D7mg
         cjp+QwSYpofgqvDwD7rytSS5OoHhtkH/2yvYjjVkw9WxRr/Hp76bS3VST0fjQOMu/OKL
         tITw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770418217; x=1771023017;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pKIcE6GoeXBIyuDrXKVfe0dIRC3Ib5hok4aF2odJDyQ=;
        b=VDJW5/4R8s37SsDoleF5yoZmvmeydXFO1Af+2K5BDCLN1NSayBqEYdFH5/csDphtEn
         NWpjo74+3FJ8QEfmibWrJT0+m+ULtVyev0b7HmI+hJsobdRbgXDJ2tc6cyn9nbkuwvYS
         k9+ZROzlKSXyX2b87wT6E8wUkvFqL3kStJIT2XPMv5X4TdPRt7ShYtagtVsXzGRoQVdr
         udiiXLlrYBzmd/v95h65XqM4OlfXjwlryb/mpw+7L8sPwVDSMUDkKJpuvhfno7hMDZW0
         dyR/xx0tyjg+wMtuX/eekdamJYXb7vuY8KkTCWKdSE0S7X2NKpufvkYf6IiWrDkDS99Z
         DPZg==
X-Gm-Message-State: AOJu0Ywlsba1op75Jc7iJp+0op2NZ1QnxHhn8WYCfaAVpxeEQR9wtTMp
	kRU4+yuZDJvOVQX1JRlG4H2aaDmWWZXcG6s638pOy0iQR7R9b30fBp0WCEGpXDY5CHdb280+ht3
	AxHCVkKC7lubJiGmGux4/9OmWuWr0zvI=
X-Gm-Gg: AZuq6aIgktCv3EtPPoNRVgzgAJfqva+W41wMShQFtSQvttZc4bG4NBz35YaTVgs5yZ4
	hmwRFntD9pSvvnfr3Amj+wbWcsP28febid7x9V1XXFwU30YmnsVWfzbkZpdR4G35fPi2R/Abi1s
	RlHDtWgwBQZfs5IX3wKk2TMbg2cen7R2s8P9k6cJyi1QnZ2bIeCl+wYhwZx95pKFQn3ZA4NTFEf
	cRIq9uxmSTgSuWfj1/EFCE6T5jmKxuqQgLCB8tTE+axXnjdYxmaOc4UTYldUoznHwU25QZW1Thv
	cyzDKbRrpaOah4UeL1Z55wXSnnxaRxF9Ey5FBZ/LUt8skYkBu8kkyOvuga5A40wFe+D3WQ==
X-Received: by 2002:adf:ea06:0:b0:436:307c:b762 with SMTP id
 ffacd0b85a97d-436307cb87bmr1734201f8f.60.1770418216969; Fri, 06 Feb 2026
 14:50:16 -0800 (PST)
MIME-Version: 1.0
References: <20260206072220.144008-1-jiayuan.chen@linux.dev> <20260206072220.144008-3-jiayuan.chen@linux.dev>
In-Reply-To: <20260206072220.144008-3-jiayuan.chen@linux.dev>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 6 Feb 2026 14:50:05 -0800
X-Gm-Features: AZwV_QjoaGZjUJoZZAUbUNek4v2vd9XA09_63K25KesvtBZQTlzS_xae5VjsBQ0
Message-ID: <CAKEwX=MgvCHVMOWNprWu1xbQ6=CO4ok_sywH2Cgz05aT_pdZ5A@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] selftests/cgroup: add test for zswap
 incompressible pages
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E9DC7A0008
X-Stat-Signature: n84k95xiymh5itkdsdbjkg1tc5s8cndn
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770418218-634661
X-HE-Meta: U2FsdGVkX18AH+Ftm8o64mIVm5EdwxxpLou92M0ncCRqGxZKI7eI1++gdl4OmLeFAAuZ1SeTPz4WNj/1pg2+sdbrRe8gh8q0F0uFVxPSxrRF50qd8c0qPb8TLabWO3PzTPOr+vMjDgvg1kKQRvGWROrlErx6nI8TgGokRZamrVrThc7NW3RN3cGW5rd4aTZxlgf1AmmuuJeGS9FnktHYCREPKsbhpp2/cfr1FJg2uNp72VLhuizuJHVCzvsBKCqxZbTGdx25g5embIiyfR6Sw74wJQcMxNW53FBch1ZTO+DHrQU/cLebYdjOxOcO9gMdVKEQ1h9fxQk7xAAuOR41QelguHyXiZeS2qmJURLJdY1aEoHDLxV2/NshXProVVrkuEqo4OdwtGefE4RaTwRLs2msjDs5xEmtDFDgFMM2B2hDBl+XlI+tXkB0kERT9VZIXbxgKQLTcuTjbq4Xww3y7pAJmXo0iujqJxN/XKZI9ud3kxVMXU1q/we1d3Tx5Y0yLmtFiTainbOlWj80WTai89hqyxZ5ebDJFt7Hqy5YcFPvH0hhiMAM2qC7Pcrkck98lP1h7qouZsEbupdx+i8bMG7GJgAe7cIu82MTmAhXhFd1XNXDtkST6jH5XZg+4RB1tV9BhnsPX4GhvfEo7uS+Tt4l/N9mWmuf7R6WuENXrSUh8iicAaTynSyCL3je28dDYOIJProeY6CKJgJLy4ABIWIi11eGH2yYXQsYkRRDVCUfoGWlKaHahzdxaO38TNZMRKsnxqLPv3l1qBK6zjkSdzhZ3S0dakc4UNVN3Bu3sFPY4oBl7HSUcz6fucm6B6VyDgzZgI4hon37mHeFtrz0E/Awz3VMEI8p+1iNLj6CNUq/wFY19CBr8lpWahezbsqZp6R3yKfFCgOA/kHmPuJHn2oAR4iERFmNpvAI+GvW/EH5lL87TfN8I1OryHW/LOnlpKpSaPdFwXireUT9RkK
 tB6oqWn1
 iZCoKgDOU15ANUBa37d/hHwqx4RsWoodFZkRmQIGpSlzAVQEWlmoA/PF+KIPdy06J1Nvi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 5, 2026 at 11:22=E2=80=AFPM Jiayuan Chen <jiayuan.chen@linux.de=
v> wrote:
>
> From: Jiayuan Chen <jiayuan.chen@shopee.com>
>
> Add test_zswap_incompressible() to verify that the zswap_incomp memcg
> stat correctly tracks incompressible pages.
>
> The test allocates memory filled with random data from /dev/urandom,
> which cannot be effectively compressed by zswap. When this data is
> swapped out to zswap, it should be stored as-is and tracked by the
> zswap_incomp counter.
>
> The test verifies that:
> 1. Pages are swapped out to zswap (zswpout increases)
> 2. Incompressible pages are tracked (zswap_incomp increases)
>
> test:
> dd if=3D/dev/zero of=3D/swapfile bs=3D1M count=3D2048
> chmod 600 /swapfile
> mkswap /swapfile
> swapon /swapfile
> echo Y > /sys/module/zswap/parameters/enabled
>
> ./test_zswap
>  TAP version 13
>  1..8
>  ok 1 test_zswap_usage
>  ok 2 test_swapin_nozswap
>  ok 3 test_zswapin
>  ok 4 test_zswap_writeback_enabled
>  ok 5 test_zswap_writeback_disabled
>  ok 6 test_no_kmem_bypass
>  ok 7 test_no_invasive_cgroup_shrink
>  ok 8 test_zswap_incompressible
>  Totals: pass:8 fail:0 xfail:0 xpass:0 skip:0 error:0
>
> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
> ---
>  tools/testing/selftests/cgroup/test_zswap.c | 96 +++++++++++++++++++++
>  1 file changed, 96 insertions(+)
>
> diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/=
selftests/cgroup/test_zswap.c
> index 64ebc3f3f203..8cb8a131357d 100644
> --- a/tools/testing/selftests/cgroup/test_zswap.c
> +++ b/tools/testing/selftests/cgroup/test_zswap.c
> @@ -5,6 +5,7 @@
>  #include <unistd.h>
>  #include <stdio.h>
>  #include <signal.h>
> +#include <fcntl.h>
>  #include <sys/sysinfo.h>
>  #include <string.h>
>  #include <sys/wait.h>
> @@ -574,6 +575,100 @@ static int test_no_kmem_bypass(const char *root)
>         return ret;
>  }
>
> +static int allocate_random_and_wait(const char *cgroup, void *arg)
> +{
> +       size_t size =3D (size_t)arg;
> +       char *mem;
> +       int fd;
> +       ssize_t n;
> +
> +       mem =3D malloc(size);
> +       if (!mem)
> +               return -1;
> +
> +       /* Fill with random data from /dev/urandom - incompressible */
> +       fd =3D open("/dev/urandom", O_RDONLY);
> +       if (fd < 0) {
> +               free(mem);
> +               return -1;
> +       }
> +
> +       for (size_t i =3D 0; i < size; ) {
> +               n =3D read(fd, mem + i, size - i);
> +               if (n <=3D 0)
> +                       break;
> +               i +=3D n;
> +       }
> +       close(fd);
> +
> +       /* Touch all pages to ensure they're faulted in */
> +       for (size_t i =3D 0; i < size; i +=3D 4096)
> +               mem[i] =3D mem[i];
> +
> +       /* Keep memory alive for parent to reclaim and check stats */
> +       pause();
> +       free(mem);
> +       return 0;
> +}
> +
> +static long get_zswap_incomp(const char *cgroup)
> +{
> +       return cg_read_key_long(cgroup, "memory.stat", "zswap_incomp ");
> +}
> +
> +/*
> + * Test that incompressible pages (random data) are tracked by zswap_inc=
omp.
> + *
> + * Since incompressible pages stored in zswap are charged at full PAGE_S=
IZE
> + * (no memory savings), we cannot rely on memory.max pressure to push th=
em
> + * into zswap. Instead, we allocate random data within memory.max, then =
use
> + * memory.reclaim to proactively push pages into zswap while checking th=
e stat
> + * before the child exits (zswap_incomp is a gauge that decreases on fre=
e).

I wonder if we can do MADV_PAGEOUT? Anyway, I'm fine with memory.reclaim to=
o.

> + */
> +static int test_zswap_incompressible(const char *root)
> +{
> +       int ret =3D KSFT_FAIL;
> +       char *test_group;
> +       long zswap_incomp;
> +       pid_t child_pid;
> +       int child_status;
> +
> +       test_group =3D cg_name(root, "zswap_incompressible_test");
> +       if (!test_group)
> +               goto out;
> +       if (cg_create(test_group))
> +               goto out;
> +       if (cg_write(test_group, "memory.max", "32M"))
> +               goto out;
> +
> +       child_pid =3D cg_run_nowait(test_group, allocate_random_and_wait,
> +                                 (void *)MB(4));
> +       if (child_pid < 0)
> +               goto out;
> +
> +       /* Wait for child to finish allocating */
> +       usleep(500000);
> +
> +       /* Proactively reclaim to push random pages into zswap */
> +       cg_write_numeric(test_group, "memory.reclaim", MB(4));
> +
> +       zswap_incomp =3D get_zswap_incomp(test_group);
> +       if (zswap_incomp <=3D 0) {
> +               ksft_print_msg("zswap_incomp not increased: %ld\n", zswap=
_incomp);
> +               goto out_kill;
> +       }
> +
> +       ret =3D KSFT_PASS;
> +
> +out_kill:
> +       kill(child_pid, SIGTERM);
> +       waitpid(child_pid, &child_status, 0);
> +out:
> +       cg_destroy(test_group);
> +       free(test_group);
> +       return ret;
> +}

LGTM :)

Acked-by: Nhat Pham <nphamcs@gmail.com>

