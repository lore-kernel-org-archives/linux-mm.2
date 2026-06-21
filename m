Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AF0CCDB466
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 02:12:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91DD26B0005; Sat, 20 Jun 2026 22:12:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CE756B008A; Sat, 20 Jun 2026 22:12:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 797786B008C; Sat, 20 Jun 2026 22:12:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B06F86B0005
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 22:12:05 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 20746166609
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 02:12:05 +0000 (UTC)
X-FDA: 84902294610.13.2B22061
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf19.hostedemail.com (Postfix) with ESMTP id 18D621A000B
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 02:12:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZewyBiAV;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782007923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t/7avvu3JxmkKSpM0Bw3iOtaoASVcC0L8AdB5HzPvqM=;
	b=Ru5LH+fi1ISaFkkXwRoZuSyECGTrZyvPHyaaB8FzS+I5EV+odLC3o+683zgBO9P4C2i7SG
	De0aXJVlCDZb8MFXSWfdns6rrrdHFJBb2I7PINOVDVVhSbyRO4jXb68naDvzkXHJsdfkhg
	FD7xfBm9DCRbD9wjIiZudRrG2BsVUfE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782007923;
	b=w29gDgctSuDjRdcKVJ4HpVNeXlXUUMYjwgFoVk9qqS2JVEETJGlcgiiDbGHZDcJMYkO23S
	QwDeegFiojqrX5njfkYkx2ZZ8FnkMijNlmActXvj9KhPAUj0Ohp5i9D8v5B3fJieCozEEd
	nIsY1zQ7owLChVfo9gao/b7wDLsrfDc=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZewyBiAV;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-51765531803so469091cf.0
        for <linux-mm@kvack.org>; Sat, 20 Jun 2026 19:12:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782007922; cv=none;
        d=google.com; s=arc-20260327;
        b=bO1geCNdrXAaO0+eDb9v1Nu0rTzhKm2uToWgc8aZknVLhv829FoF0cPRM6Ydj88qFC
         we879YGa+78Wci/6x2G5bnZj6z2VFH9H+J7DQ5Tusw7LZMHJCSk4+0fKfQk+8O2CPbCM
         IDzCob1fBSMpF/0B3yfz2JwVQ6uuvCirEN1J3GhASdgbs9w+jpuYg/IVXg+F/xHjoSy9
         m0lwnCgWKjuDBeYVezdcpiOCGu3LUPtv7Y2oOFBYWGl4hI5aG1VVsvuOg63PBMOVY0ZI
         +5/b4UYHqV7FP1I/iMy42uZu4PjvtDZ9B8ITCXCeu6NUgGBJfsKmc1/aDH1Mwex/0f/r
         89vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=t/7avvu3JxmkKSpM0Bw3iOtaoASVcC0L8AdB5HzPvqM=;
        fh=8tuaSRRzN3XR2wu3TqUdauvXUfS9oAIOKeDnZc9xzmE=;
        b=ml7i39bhjErAk8tbJA0XloiW/zGTvj2+bGk1fazgMB7/VPq9KZSwxpkgTy/7vyEn1w
         +vaBdNvgqnndpruPG1dBY8Rpp0gp7AZ1oR5VOpP8cvMEp6+ApRs/iszP2U2r6PHvv7ZK
         6pJawMbhcs0qssaVjuV+4n6VKh5G2q4z4RuhCYYuFDdXY05fBxjuNR66ZWLXdlmryUTc
         CcWJA1cuTQ5WK3xgX5aJZC5TK04X9dKUvaK1kbxQRyl4XAHqBnMfnbCgpzLsQlKfvP6F
         wJW2Sw4Icb0suGqoPsR8gW9idfhHXfpm3IrYyQBqboebvNvrNinBuaWO3XXnLd5vklgt
         J5PQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782007922; x=1782612722; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=t/7avvu3JxmkKSpM0Bw3iOtaoASVcC0L8AdB5HzPvqM=;
        b=ZewyBiAVfBVxturTASXNLWTDxEsu//0i2h+1EP5UUH4juTAwf2+Cww7tCyvBI4xf51
         rrJWvrgK+SsuVKJxuAmI71bwqcx5NO0FsAoTuk73TKxtchc5obOEULK34gvCbUYofz9z
         PYIeHb7Cxw65LUlEFw1j8SaLUqxKQyZvV+J5yGAbjFFZMZyt6pJNRLWRo0goP7lMQKZr
         skY90/tCq0Brexb05EfaRaPILF1CGx+u4Gbckg7e/8zMbklI6p3/kpSiQ8dlW/ClwI7D
         9RGgJcDfgfroksgsRSBHlI5Q/wdNSMJ4xg1S3Ri+/lEBFqv2WWjBs0XAjSzX8KhzVyCx
         b+IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782007922; x=1782612722;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t/7avvu3JxmkKSpM0Bw3iOtaoASVcC0L8AdB5HzPvqM=;
        b=Daa9l148p43+LVOFh/aXY6o1M3MolNusDfWsM8O9ftC6M0zNZQ1CZzD0nsKnteQIYV
         He7ZZGxhkL+TicA5uxWLkmpYZHxpxn0Hsz49feDW2lhmtjsnRU3ugwijG5j/kPUp7v9Z
         AdaoUzcW/zU4BHPE0m1QYOvWetULvIZO3aX3zmnzrsZAvBiK/qg5BsnbVn7kl7hkgtwm
         gGKT6K0CdWKomf1ykFrZWPs3HT3Bm6ig7abiVOJad576loRtknoNKX2h7OcGqLqgfDe5
         4nJP+RxleLZ/NDD85gLazUYKKlS4aDqNMCl25PzMoKidl7iitXDRqqKtZwmMJ1NtnxM+
         Rr+w==
X-Forwarded-Encrypted: i=1; AFNElJ+KTXZ9u0AE7OZz9Gj06Edei4LEjxiBQekvnUL9J8NhWaovJsvDKlPlVvv0hv3fQ17QihpnPV0Z0g==@kvack.org
X-Gm-Message-State: AOJu0YxQQFv6/Tj4HbRl8xerCJhE+wzyToQsZYbP1+bhYrqe+q0H1tjX
	KULOrmAuuEGhp30T+Cml7dfvSiIdaKrVUvCkkcTN6Ic3EB14BE8S17fuDgQ1j7hDszICUplntyC
	ZVpig5juQgH7zQU9Pb1qeJf3c+7Iras85bV7qDVnDl1x80KH0QA2MqmFjJ+c=
X-Gm-Gg: AfdE7ck+16Ije2QwV9NFqYGfw8qmxX5eNAcFvd8ViM9glv0fotjBnU3tv6g7n/liUYO
	x5MUooyh9JLaA0MA9IvH9pzjg74Vm6B6XMUVjmrd2uoFWw/+vryPJFTv25N4i50XByfbz1j8pqV
	iGdoVPc+HCPjz3wETIBztIPVx1iyCwJoNT841AqHmvZAINqNnqDF4jtcccIYi/+1LZ37Txm5tUS
	kcNGcxGBVrO5b1gN7PpL6FEeXpQlEpBynHCk1VPH0BDj0epLDl3HVDqXENLwiqNLQhD1eE=
X-Received: by 2002:ac8:5810:0:b0:50e:41f3:6467 with SMTP id
 d75a77b69052e-519e48d14d6mr16859591cf.12.1782001904596; Sat, 20 Jun 2026
 17:31:44 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1781803482.git.abhishekbapat@google.com> <5a485adaa95f8bdce7d29ddab30238b34e949f28.1781803482.git.abhishekbapat@google.com>
In-Reply-To: <5a485adaa95f8bdce7d29ddab30238b34e949f28.1781803482.git.abhishekbapat@google.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 20 Jun 2026 17:31:33 -0700
X-Gm-Features: AVVi8CeJ2bjOzYmP-W27RQlWiULWjVex-vrgUwPzqXYZ3HL8Z1E95q9kptgOpXE
Message-ID: <CAJuCfpEg6jqMbTP4ZEec_gCtaLAA6hHW0hmSsXf6hujB6sVODQ@mail.gmail.com>
Subject: Re: [PATCH v6 6/6] kselftest: alloc_tag: extend the allocinfo ioctl kselftest
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Hao Ge <hao.ge@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: kpic7phjkf3rwnrkmih437pd6onue3ky
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 18D621A000B
X-HE-Tag: 1782007922-613174
X-HE-Meta: U2FsdGVkX1+UWCy0I2TzUN1acdFNQ3gF5wja4PFwxN/Z6mm2NkY8XRSI4wNxBUNxrjVUzgfCcG2ieof2JW45XBOScZr4m1OSKtL9RPtlPpAYouzl0uAqsROflHyFIuVapmProJzPy+l1PP02AJ4S0+IZwMdx566AGHHO1QkS0tkLu2azPcPesntoubJ9pyvRt0vthgRgEeRxKJN0XFPIasViuzM1lJqfbYl4nmCzgz1hwapgs0f/yevQrQbQnT/kYnLy1q60aS5SCZzcZSGTZqPT41Og369dp7f/UUG5T/eC6mHfcDwskZg0LUOsMK3FfuY7BaFtfOKMpBCRFOaRUVYaZ2VKoCK6VZ2bk/ylaVZgWiY0zCqTA9QsYAdatu1Jzb/UeXGkjwvqe+K1lACwNTUg+zHi1pwyQOkCugQTDGTzId2Eu01SPbAECtoLBx0jNXdm0YIpcY8Ns6I5IXeWUhe4QFUV1yFaZrDd50myJFgND80cNkPDzh4F1atri/phNIX1Pw6sTT86SZtDjtGG60kl52bLCWhayhsxGD0SYGpVdKHiWR3/pX6CFX6akGRUkTEauTvs2kR0U8XRVWtfxIHgRj5weONAnaObhYkeIfGT/ydl6OKqW56KngNUtOhxVOzuhhr7TYiBD8Gf2RQOhM7S4yWEnGaYRAUEbSxloEED4nnTQH2Nwt7Vo0IO+pRPGtrVljMSH7NrG+x5U173opEOE/5bWHht7c7rSkAd3gVg6I63I0qLWm5ayhIf8wOUIqOMxSUC+oah1/MlstAOYwK8DTCR/QbIWxTfTSKLQmH40uVc9Lep7ImblvihqX+F9NYpyLrD/aMnVH7ewEa8OKHcO40J1sZoFyp18zH2sCrnQfyVR0xGuP2bwPp5YxEmV8QriAs1Dqsspc9yB2AQf2SiVxdNg4cBlTq91pAJynsvQkQoSrw7EMLSH1QsONRvmfnhA48NBcf8fr9GZy7
 9bBOh/KP
 OXSO4jI2VfSQ2iArvv+AYdB+kheqJ6e5FeTYvr/IYjfGtn35A6zvqNJBXCrAxYXiP9rvJRwijijHe04HmuoIo+MJqhW/LPeknJYRxDe06OaEaFKUgXuEKFOy8Wra3kIStIOyUb00L1/CuWX0qQyMhPeTGOiXk/wwYhpD9kdKDuxKG90oblVtHz70aIGZkUp1Vc4TzUytM2/DlmJGcWxGP+SsnGKMDsNGnKXo1RkCcBcM4os/BYfUcMlXhyBYMVLawiJVjuQ870b97XbdLaH0PqOz7N7Dxo01PPvieUebojlnXm6cfpDxx0PgJrXl1ouNVSF+BAgYHmOLe5sdWNDu/d+N+VA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 10:36=E2=80=AFAM Abhishek Bapat
<abhishekbapat@google.com> wrote:
>
> Add the following 2 scenarios to the allocinfo ioctl kselftest:
> 1. Validate size based filtering
> 2. Validate lineno based filtering
>
> The first test uses "do_init_module" as the candidate function for the
> test. This is because the associated site will only allocate memory when
> a kernel module is loaded. The return value of get_content_id() changes
> every time modules are loaded or unloaded. Hence, as long as
> get_content_id() values at the start and the end of the test are the
> same, the memory allocated by the do_init_module call site should also
> remain the same. Consequently, the test can assume consistency between
> the value returned by the ioctl and the procfs resulting in less
> flakiness.
>
> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>

Couple of improvement suggestions, but otherwise LGTM.

> ---
>  .../alloc_tag/allocinfo_ioctl_test.c          | 198 +++++++++++++++++-
>  1 file changed, 197 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c b/t=
ools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> index 1ae0291f2245..50755a45d3fe 100644
> --- a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> +++ b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> @@ -5,6 +5,7 @@
>   * Copyright (C) 2026 Google, Inc.
>   */
>
> +#include <errno.h>
>  #include <fcntl.h>
>  #include <stdio.h>
>  #include <stdlib.h>
> @@ -313,11 +314,194 @@ static int test_function_filter(void)
>         return run_filter_test(&filter);
>  }
>
> +static int test_size_filter(void)
> +{
> +       int fd;
> +       struct allocinfo_tag_data_vec *tags =3D malloc(sizeof(*tags));
> +       struct allocinfo_tag_data_vec *procfs_entries =3D malloc(sizeof(*=
procfs_entries));
> +       struct allocinfo_filter filter;
> +       int ret =3D KSFT_PASS;
> +       __u64 target_size, i, pos;
> +       bool found;
> +       const char *target_function =3D "do_init_module";
> +       struct allocinfo_content_id start_cont_id, end_cont_id;
> +       int retry =3D 0;
> +       const int max_retries =3D 10;
> +
> +       if (!tags || !procfs_entries) {
> +               ksft_print_msg("Memory allocation failed.\n");
> +               ret =3D KSFT_FAIL;
> +               goto freemem;
> +       }
> +
> +       fd =3D open(ALLOCINFO_PROC, O_RDONLY);
> +       if (fd < 0) {
> +               ksft_print_msg("Failed to open " ALLOCINFO_PROC ": %s\n",=
 strerror(errno));
> +               ret =3D KSFT_FAIL;
> +               goto freemem;
> +       }
> +
> +       do {
> +               found =3D false;
> +               pos =3D 0;
> +
> +               if (__allocinfo_get_content_id(fd, &start_cont_id)) {
> +                       ksft_print_msg("allocinfo_get_content_id failed\n=
");
> +                       ret =3D KSFT_FAIL;
> +                       goto exit;
> +               }
> +
> +               memset(&filter, 0, sizeof(filter));
> +               filter.mask |=3D ALLOCINFO_FILTER_MASK_FUNCTION;
> +               strncpy(filter.fields.function, target_function, ALLOCINF=
O_STR_SIZE);
> +
> +               if (get_filtered_procfs_entries(procfs_entries, &filter))=
 {
> +                       ksft_print_msg("Error retrieving entries from " A=
LLOCINFO_PROC "\n");
> +                       ret =3D KSFT_FAIL;
> +                       goto exit;
> +               }
> +
> +               if (procfs_entries->count =3D=3D 0) {
> +                       ksft_print_msg("Function %s not found in procfs\n=
", target_function);
> +                       ret =3D KSFT_SKIP;
> +                       goto exit;
> +               }
> +
> +               target_size =3D procfs_entries->tag[0].counter.bytes;
> +
> +               memset(&filter, 0, sizeof(filter));
> +               filter.mask |=3D ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLOCIN=
FO_FILTER_MASK_MAX_SIZE;
> +               filter.min_size =3D target_size;
> +               filter.max_size =3D target_size;
> +
> +               while (1) {
> +                       struct allocinfo_get_at get_at_params;
> +
> +                       memset(&get_at_params, 0, sizeof(get_at_params));
> +                       memcpy(&get_at_params.filter, &filter, sizeof(fil=
ter));
> +                       get_at_params.pos =3D pos;
> +
> +                       if (__allocinfo_get_at(fd, &get_at_params))
> +                               break;
> +
> +                       tags->count =3D 0;
> +                       memcpy(&tags->tag[tags->count++], &get_at_params.=
data,
> +                              sizeof(get_at_params.data));
> +
> +                       while (tags->count < VEC_MAX_ENTRIES &&
> +                              __allocinfo_get_next(fd, &tags->tag[tags->=
count]) =3D=3D 0)
> +                               tags->count++;
> +
> +                       for (i =3D 0; i < tags->count; i++) {
> +                               if (strcmp(tags->tag[i].tag.function, tar=
get_function) =3D=3D 0) {
> +                                       found =3D true;
> +                                       break;
> +                               }
> +                       }
> +
> +                       if (found || tags->count < VEC_MAX_ENTRIES)
> +                               break;
> +
> +                       pos +=3D tags->count;
> +               }
> +
> +               if (__allocinfo_get_content_id(fd, &end_cont_id)) {
> +                       ksft_print_msg("allocinfo_get_content_id failed\n=
");
> +                       ret =3D KSFT_FAIL;
> +                       goto exit;
> +               }
> +
> +               if (start_cont_id.id =3D=3D end_cont_id.id)
> +                       break;
> +
> +               ksft_print_msg("Module load detected during size verifica=
tion, retrying...\n");
> +       } while (retry++ < max_retries);
> +
> +       if (start_cont_id.id =3D=3D end_cont_id.id && !found) {
> +               ksft_print_msg("Entry with function %s not found in IOCTL=
 results\n",
> +                              target_function);
> +               ret =3D KSFT_FAIL;
> +       } else if (start_cont_id.id !=3D end_cont_id.id) {
> +               ksft_print_msg("Failed to match content_ids for procfs an=
d IOCTL, skipping...\n");
> +               ret =3D KSFT_SKIP;
> +       }

I know we found the tag filtering by target_size and this might be
seen as unnecessary, but let's take one more final verification step
and check that tag.counter.bytes of the tag we found indeed equals
target_size. For that check you can replace "found" boolean with
"found_tag" pointer and the rest becomes trivial.

> +
> +exit:
> +       close(fd);
> +freemem:
> +       free(tags);
> +       free(procfs_entries);
> +       return ret;
> +}
> +
> +static int test_lineno_filter(void)
> +{
> +       struct allocinfo_tag_data_vec *tags =3D malloc(sizeof(*tags));
> +       struct allocinfo_tag_data_vec *procfs_entries =3D malloc(sizeof(*=
procfs_entries));
> +       struct allocinfo_filter filter;
> +       enum ioctl_ret ioctl_status;
> +       int ret =3D KSFT_PASS;
> +       __u64 target_lineno, i;
> +
> +       if (!tags || !procfs_entries) {
> +               ksft_print_msg("Memory allocation failed.\n");
> +               ret =3D KSFT_FAIL;
> +               goto exit;
> +       }
> +
> +       memset(&filter, 0, sizeof(filter));
> +
> +       if (get_filtered_procfs_entries(procfs_entries, &filter)) {
> +               ksft_print_msg("Error retrieving entries from " ALLOCINFO=
_PROC "\n");
> +               ret =3D KSFT_FAIL;
> +               goto exit;
> +       }
> +       if (procfs_entries->count =3D=3D 0) {
> +               ksft_print_msg("Could not retrieve procfs entries\n");
> +               ret =3D KSFT_SKIP;
> +               goto exit;
> +       }
> +       /*
> +        * We depend on the result of procfs entries to create the ioctl_=
filter. Hence we
> +        * cannot recycle the run_filter_test function here.
> +        */

The above comment is a bit unclear. What do you mean by "recycle the
run_filter_test function"? Also there is no variable called
ioctl_filter. I would change it to "filter later used in ioctl".

> +       target_lineno =3D procfs_entries->tag[0].tag.lineno;
> +
> +       filter.mask |=3D ALLOCINFO_FILTER_MASK_LINENO;
> +       filter.fields.lineno =3D target_lineno;
> +
> +       ioctl_status =3D get_filtered_ioctl_entries(tags, &filter, 0);
> +       if (ioctl_status =3D=3D IOCTL_INVALID_DATA) {
> +               ksft_print_msg("Trouble retrieving valid IOCTL entries, s=
kipping.\n");
> +               ret =3D KSFT_SKIP;
> +               goto exit;
> +       }
> +       if (ioctl_status =3D=3D IOCTL_FAILURE) {
> +               ksft_print_msg("Error retrieving IOCTL entries.\n");
> +               ret =3D KSFT_FAIL;
> +               goto exit;
> +       }
> +
> +       for (i =3D 0; i < tags->count; i++) {
> +               if (tags->tag[i].tag.lineno !=3D target_lineno) {
> +                       ksft_print_msg("IOCTL entry %llu has incorrect li=
neno %llu.\n",
> +                                      i, tags->tag[i].tag.lineno);
> +                       ret =3D KSFT_FAIL;
> +                       goto exit;
> +               }

You can improve the test to also check if the filtered collection you
retrieved contains the original tag you used to record target_lineno.

> +       }
> +
> +exit:
> +       free(tags);
> +       free(procfs_entries);
> +       return ret;
> +}
> +
>  int main(int argc, char *argv[])
>  {
>         int ret;
>
> -       ksft_set_plan(2);
> +       ksft_set_plan(4);
>
>         ret =3D test_filename_filter();
>         if (ret =3D=3D KSFT_SKIP)
> @@ -331,5 +515,17 @@ int main(int argc, char *argv[])
>         else
>                 ksft_test_result(ret =3D=3D KSFT_PASS, "test_function_fil=
ter\n");
>
> +       ret =3D test_size_filter();
> +       if (ret =3D=3D KSFT_SKIP)
> +               ksft_test_result_skip("Skipping test_size_filter\n");
> +       else
> +               ksft_test_result(ret =3D=3D KSFT_PASS, "test_size_filter\=
n");
> +
> +       ret =3D test_lineno_filter();
> +       if (ret =3D=3D KSFT_SKIP)
> +               ksft_test_result_skip("Skipping test_lineno_filter\n");
> +       else
> +               ksft_test_result(ret =3D=3D KSFT_PASS, "test_lineno_filte=
r\n");
> +
>         ksft_finished();
>  }
> --
> 2.55.0.rc0.786.g65d90a0328-goog
>

