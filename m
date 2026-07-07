Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65E64C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 16:59:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49FAC6B009D; Tue,  7 Jul 2026 12:59:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 450846B009E; Tue,  7 Jul 2026 12:59:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31C256B009F; Tue,  7 Jul 2026 12:59:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F25146B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:59:04 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6995CA04BC
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:59:04 +0000 (UTC)
X-FDA: 84962590608.20.2487CD0
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7119240012
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:59:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qnQJe+IE;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=abhishekbapat@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783443542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V+0pheG9ogqbrNNEmsLqS/R7/lxeP3J7M6TTyjZm7Es=;
	b=C1EzwmsN11EvOnjNjl2MI6hm3kBmSS+I7+Hqy+P6bAulyeCQ6Qln2G389LVzExHjwQEYjl
	28NHZQEQkPyhsTtWhlIsY64EP3ZqXdl+2xIFWxq5/3ehWaR3Hcr1Lt58p79YfxuxWmdcUR
	UsEbWx4FBj9yq6pGoln7AXnVktExr/E=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qnQJe+IE;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=abhishekbapat@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783443542;
	b=FD6N2Vul/cIUEV7OcEFxRfKw9xOy7k7hSxhdlv28Svq5wFhkzZaj7SGK88Usws/+kYIWKT
	csyRdEjSjY6SlECP759lfaLoPEUvt0+kYqigP2EbbhAjnQA6phBhRE9ADXo4McNVMNfDzM
	RyPmlycNfv8FSMNlp4FzYfxbCGNuyWE=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2cacef7d299so100735ad.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 09:59:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783443541; cv=none;
        d=google.com; s=arc-20260327;
        b=YBHRfeUqy9646PzlsCX9HR8PyUOkvu0qWbWfiznaOHnHnCfXxBc6oCoijKy/PbsO8R
         ndqqWL8NvEk2ix6Jhsvv2H8lg5ms6cdcUp6WoObb3YO9ZIWlPFqQ2UBIl7mxfwWqeb7c
         pHOrFYF0gOsoo3teI9rIsiLs2borcAWdo+zH92sCiLIchxZlBdFBNU6dHSfZJ2a+Mnyo
         1+t1+KaiJNV+iyTqYxh5tDk6Djth5x2FX5WXk+J4YcC7KOL2qhezmZP0sYF/9303mp4y
         9UIBvpVbNGGHwuEhhivgxUSHRcM+U6008TAM3xKZwUf9VbLp7d+wBsVcX1H3Yhi0lTfj
         PHTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=V+0pheG9ogqbrNNEmsLqS/R7/lxeP3J7M6TTyjZm7Es=;
        fh=CU54av4rYnCQs3Raqxqw6cejVCdN/kHHHx+k12KHOy4=;
        b=PgXiTv2Dq0VOKFl1QrzIH/UH/d0+yRNStQIB+x+MHeybPR7JaSFAxbBsRqSe50iwLB
         ua+rGsnA5yNG0TsDlTYvHwF7+udKonpFUGJM5+GfzmFo2RJe3T7+nznlee7wiCPq6+iK
         hTjTAUce4txYG7AlqlE2l2fLXmEpgk8gUCyW1ZZYxHx2BE2vONYBnrdIY0J7ebvSkHGn
         uC0OxbzyWlFCqpnfygzjc8mVC86UfhLBDxTTFoJ0xIigqqfQuLPBrG7T0fyPG8B/FLjW
         WwUeWTiC8afPiGssesyXvkT1nhbQapNi2bcYtCNaL0mP3vsCDaNYH4ib4oEOagLwZkUP
         hsYQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783443541; x=1784048341; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=V+0pheG9ogqbrNNEmsLqS/R7/lxeP3J7M6TTyjZm7Es=;
        b=qnQJe+IERtwYNOP/y/ok5BNF0/K9UWciOMFEhMtm5e4LkqETO3GAx4f1strmU5HkVm
         6AMV4mnHdl6NyO8MCLyqa3K19RiXZGsAGTB78FvhgG5c04oRCOkFFCnPL7FQORPLN+65
         wIMy/rAk8sGJXEC3A4FOakEkOH2mJIVIAbBS5b6YSV2LacpQSAAN19WwUz05FPpe57AX
         BSiyxPigMM75Dcf2NQ9AQXFinpVUAnKsznlDlnv/hVyU3XBxHz81ysq2iSsC59d+pS0w
         AXs5+zp0lSDG+HkNeJtMBIkssXYHQXEIjZIrXr57TGoGWLuaQvf81L/3YgA+ynwmLShW
         q+wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783443541; x=1784048341;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=V+0pheG9ogqbrNNEmsLqS/R7/lxeP3J7M6TTyjZm7Es=;
        b=au3jWdZ7S33vRaJkeSi5+Vf8XM5qpjU3/opBzf5yhy6/lLBtAGT9xq6MdN12y9yj8i
         QIo4RL4hIGNJ+6KtOtGLIj3WXb5N8pf2p+fiKyR0ssB/Y1SgmyAPRtxLjFfK3MdvPLeV
         SNTd8/S0xXVmzNlm8f6MIioGwvx6jVWFOYxynOn050dVxo1hG3dHT5Ot5q85sxG+W58M
         6lWynVgZKZVec6E5aCP4ADZqD1+d0eQtYrNkOKUKMYiBOXB5xsi5NpRDn/COIr+1SvR7
         hPNDyHnQOKeRuj1qIK/f35hCFQTj/wOm7Mk8WV2hfBORl9FJP3RMFSHgrEzaQdyFAUiD
         8rBQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro+laWnwrO37V9ELtdsiOj40pIQKzCl2wetUBdj88qnDtnduExKhoFAE7eK2qtKVpHYKxUP8LBwJA==@kvack.org
X-Gm-Message-State: AOJu0YzVrYElQ2CZ2jIFFu1Uib+ZaJuHI/6usc8yS49iEuoDR0vwvw8F
	aXbpw0fYQCmUGq+d6MJ+Zz6ljCLVfTzfLC7fdm2TeouNGWgz1egmDavkQlsWNICWjwaUxHLgbnv
	sTlRdna7yM0VywYaWsNIjfmb92UhAc+/Tk2/FaC8F
X-Gm-Gg: AfdE7cnUhSgj76YY138F7c0+dBT3ixoNSg1BUwWCmovEoFTWBuEgYKQFp7KnOnNvgZ2
	Mu2E31hXCXajTv0IM2F56n0tO2CvwQzT64XiFiXMdOBb90MR8azbQRQ7+1q6YVjrG+cqrqa3B3+
	PGXW0bbBUEGbH7oRZI/GHRAJgCSNWlqR12XScjhi83u2uY77gaXkp9krv93MMVUNQLhtqSiK3Fq
	Soa9lfjcLwgQBDAaYSKxH1Q1Hc2+8h9yn9ESSDqFtpQXr7+dO1Dm9yhjzRoI75R3TRIeS+5wjk8
	b2rPHtKoqCrfaBEAGolWQHmRiCY=
X-Received: by 2002:a17:903:32d2:b0:2ca:6bf:5bac with SMTP id
 d9443c01a7336-2ccc9c2e544mr3390245ad.8.1783443540658; Tue, 07 Jul 2026
 09:59:00 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1783361692.git.abhishekbapat@google.com>
 <f6bd1ff0257987dbb7512f93595eaa6962c6153b.1783361692.git.abhishekbapat@google.com>
 <4cc47988-49b3-4b73-90ed-a0a16a56a8dc@linux.dev>
In-Reply-To: <4cc47988-49b3-4b73-90ed-a0a16a56a8dc@linux.dev>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Tue, 7 Jul 2026 09:58:48 -0700
X-Gm-Features: AVVi8CfFdUMm1gAhA1nAbBcUBxXzhWfJGOy58ezcRxCaUnQUCzGM3HR43Ps1Zgw
Message-ID: <CAL41Mv6SdpOd=oLp9ceBkR-q_Y73Fx6rYjFO-Zc0hiNJjCFzYA@mail.gmail.com>
Subject: Re: [PATCH v7 6/6] kselftest: alloc_tag: extend the allocinfo ioctl kselftest
To: Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Suren Baghdasaryan <surenb@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Kent Overstreet <kent.overstreet@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7119240012
X-Stat-Signature: 77rb384ns4eyex7q64gwkhuytm99xadr
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783443542-991299
X-HE-Meta: U2FsdGVkX19WhnsjZYPAZn3xrOq480Qr9++vqPZ6qWT1Xp8XoVw/XHCKOwOe7carjvxqF5xvsWWWqIeZPbFLszPX8WvGE+aUnCyfN8MQQfAV4IlU9LWxrvbB7Q8G3H2w3aS3KA2RoEIpsYVv3PqZoaDTcSbXACJ4eo0UIGXfQJ+pAy9WSKCX1EQI13oiRHHCxt/ehXHJocMzBqvy8g6s++WHe0voCN+ZRh5MVsC1y0N/VN94jsLLlXuxX35D6384Mxk+lMLs1jYZKf89ZkwQVHlQBKZ3Pzhn2y+SVNKeUQ3zDNJP1Fvjt5vmupHi6wBJESSSbvaF+7JNn/6FnbiUFwcR92AMVvcaD88ldXrfLwkchvccOq0tB3hT3t/4D7zqPyimWADthehuNuh/890cwyaJmCMLhobtTxclbtEXQkt788YRHEG230aferhg4r+cl8RVkdlEJxG9oAVU6aZL17NtpebckslJCwOgfWYpLfRBuPsfT5qfBtpde5Yd5Z4qfmgImb5kIyNHwn5Ovt1QOO9HYxuwZVEXeoBocfpqLZwc1LpIza8zY4oBDCPeXPtv87wuoo2/sDzidtpnu3ebJQ3redMaNf5yq6gNz0VA0Xawa0nZLb05x6MrKwT3vhC4UBgfAQnz08qxMiXVY4bZYPJka5zVJNrxDO9vqm4xtpXfCBULa32/XNjfm4/reMIOlo7ieBJ7u5Ofx3ooYxEho60QJ6nvmW40WQbUmcbNX0/bzW8csxJMMdcEAJuepKTVRlZoKikqslNm41vBtpQ9XfmtKgq54pCsNNhpCv8JHjKWZaW6d+qda+1BYLVrp65mJ0f4YL4flTwY4CquuJT34FN63ElOohpIw/eM6+4MAzQblJwaOkIv5oHEaa/f9oyS6Cy3UgrgseNIS0xFrWwG4P7mEbCqsTtboGmnd3q11Xaz+ejRLZh2gHuMgw2hhqQ3Qrx9ki3QASz3c7G0Ckx
 DBBSe1T5
 8Y9MwyOXLSJVsvkq8qZe6wbwye6ljNxkYGe4trcsYBrxzLPVFRCt/Yla3Mc+zYgH6MzD26hOrEtZZRifM9JNkA+C9TnN2vEfQl0dxrq6Kf/KLzCAR55wJOBrKEGDEqC54eIz4gJagamiz4PQKaesuF6uisp5n5iEbKW5i5UjDpijDxR3TeVU9duyahnvigatR/Ar6Vi8/meff+whE1EgGejibnNaITfmkTaNorsJouJUikESeTDFIftwWW8gn0JaNcPfwOW3jkl8eWpnp2UItGxbo8vEoaDBRa0QGiHhKl6BdbIQk/8t8fdMQRIdzI+qYikZ2M02c4UCCB0wMGoteXrEhvn7Lc/T3SSe17PiEHQqH0BU2betiBqmxpshcM8vqAAp4+1+9O8abMjc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 6, 2026 at 8:28=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Abhishek
>
>
> On 2026/7/7 02:25, Abhishek Bapat wrote:
> > Add the following 2 scenarios to the allocinfo ioctl kselftest:
> > 1. Validate size based filtering
> > 2. Validate lineno based filtering
> >
> > The first test uses "do_init_module" as the candidate function for the
> > test. This is because the associated site will only allocate memory whe=
n
> > a kernel module is loaded. The return value of get_content_id() changes
> > every time modules are loaded or unloaded. Hence, as long as
> > get_content_id() values at the start and the end of the test are the
> > same, the memory allocated by the do_init_module call site should also
> > remain the same. Consequently, the test can assume consistency between
> > the value returned by the ioctl and the procfs resulting in less
> > flakiness.
> >
> > Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> > ---
> >   .../alloc_tag/allocinfo_ioctl_test.c          | 216 +++++++++++++++++=
-
> >   1 file changed, 215 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c b=
/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> > index 9ce7b53078b1..092348097204 100644
> > --- a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> > +++ b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> > @@ -5,6 +5,7 @@
> >    * Copyright (C) 2026 Google, Inc.
> >    */
> >
> > +#include <errno.h>
> >   #include <fcntl.h>
> >   #include <stdio.h>
> >   #include <stdlib.h>
> > @@ -312,11 +313,212 @@ static int test_function_filter(void)
> >       return run_filter_test(&filter);
> >   }
> >
> > +static int test_size_filter(void)
> > +{
> > +     int fd;
> > +     struct allocinfo_tag_data_vec *tags =3D malloc(sizeof(*tags));
> > +     struct allocinfo_tag_data_vec *procfs_entries =3D malloc(sizeof(*=
procfs_entries));
> > +     struct allocinfo_filter filter;
> > +     int ret =3D KSFT_PASS;
> > +     __u64 target_size, i, pos;
> > +     struct allocinfo_tag_data *found_tag =3D NULL;
> > +     const char *target_function =3D "do_init_module";
> > +     struct allocinfo_content_id start_cont_id, end_cont_id;
> > +     int retry =3D 0;
> > +     const int max_retries =3D 10;
> > +
> > +     if (!tags || !procfs_entries) {
> > +             ksft_print_msg("Memory allocation failed.\n");
> > +             ret =3D KSFT_FAIL;
> > +             goto freemem;
> > +     }
> > +
> > +     fd =3D open(ALLOCINFO_PROC, O_RDONLY);
> > +     if (fd < 0) {
> > +             ksft_print_msg("Failed to open " ALLOCINFO_PROC ": %s\n",=
 strerror(errno));
> > +             ret =3D KSFT_FAIL;
> > +             goto freemem;
> > +     }
> > +
> > +     do {
> > +             found_tag =3D NULL;
> > +             pos =3D 0;
> > +
> > +             if (__allocinfo_get_content_id(fd, &start_cont_id)) {
> > +                     ksft_print_msg("allocinfo_get_content_id failed\n=
");
> > +                     ret =3D KSFT_FAIL;
> > +                     goto exit;
> > +             }
> > +
> > +             memset(&filter, 0, sizeof(filter));
> > +             filter.mask |=3D ALLOCINFO_FILTER_MASK_FUNCTION;
> > +             strncpy(filter.fields.function, target_function, ALLOCINF=
O_STR_SIZE);
> > +
> > +             if (get_filtered_procfs_entries(procfs_entries, &filter))=
 {
> > +                     ksft_print_msg("Error retrieving entries from " A=
LLOCINFO_PROC "\n");
> > +                     ret =3D KSFT_FAIL;
> > +                     goto exit;
> > +             }
> > +
> > +             if (procfs_entries->count =3D=3D 0) {
> > +                     ksft_print_msg("Function %s not found in procfs\n=
", target_function);
> > +                     ret =3D KSFT_SKIP;
> > +                     goto exit;
> > +             }
> > +
> > +             target_size =3D procfs_entries->tag[0].counter.bytes;
> > +
> > +             memset(&filter, 0, sizeof(filter));
> > +             filter.mask |=3D ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLOCIN=
FO_FILTER_MASK_MAX_SIZE;
> > +             filter.min_size =3D target_size;
> > +             filter.max_size =3D target_size;
> > +
> > +             while (1) {
> > +                     struct allocinfo_get_at get_at_params;
> > +
> > +                     memset(&get_at_params, 0, sizeof(get_at_params));
> > +                     memcpy(&get_at_params.filter, &filter, sizeof(fil=
ter));
> > +                     get_at_params.pos =3D pos;
> > +
> > +                     if (__allocinfo_get_at(fd, &get_at_params))
> > +                             break;
> > +
> > +                     tags->count =3D 0;
> > +                     memcpy(&tags->tag[tags->count++], &get_at_params.=
data,
> > +                            sizeof(get_at_params.data));
> > +
> > +                     while (tags->count < VEC_MAX_ENTRIES &&
> > +                            __allocinfo_get_next(fd, &tags->tag[tags->=
count]) =3D=3D 0)
> > +                             tags->count++;
> > +
> > +                     for (i =3D 0; i < tags->count; i++) {
> > +                             if (strcmp(tags->tag[i].tag.function, tar=
get_function) =3D=3D 0) {
> > +                                     found_tag =3D &tags->tag[i];
> > +                                     break;
> > +                             }
> > +                     }
> > +
> > +                     if (found_tag || tags->count < VEC_MAX_ENTRIES)
> > +                             break;
> > +
> > +                     pos +=3D tags->count;
> > +             }
> > +
> > +             if (__allocinfo_get_content_id(fd, &end_cont_id)) {
> > +                     ksft_print_msg("allocinfo_get_content_id failed\n=
");
> > +                     ret =3D KSFT_FAIL;
> > +                     goto exit;
> > +             }
> > +
> > +             if (start_cont_id.id =3D=3D end_cont_id.id)
> > +                     break;
> > +
> > +             ksft_print_msg("Module load detected during size verifica=
tion, retrying...\n");
> > +     } while (retry++ < max_retries);
> > +
> > +     if (start_cont_id.id =3D=3D end_cont_id.id && !found_tag) {
> > +             ksft_print_msg("Entry with function %s not found in IOCTL=
 results\n",
> > +                            target_function);
> > +             ret =3D KSFT_FAIL;
> > +     } else if (start_cont_id.id !=3D end_cont_id.id) {
> > +             ksft_print_msg("Failed to match content_ids for procfs an=
d IOCTL, skipping...\n");
> > +             ret =3D KSFT_SKIP;
> > +     } else if (found_tag && found_tag->counter.bytes !=3D target_size=
) {
> > +             ksft_print_msg("IOCTL entry size %llu does not match targ=
et size %llu\n",
> > +                            found_tag->counter.bytes, target_size);
> > +             ret =3D KSFT_FAIL;
> > +     }
> > +
> > +exit:
> > +     close(fd);
> > +freemem:
> > +     free(tags);
> > +     free(procfs_entries);
> > +     return ret;
> > +}
> > +
> > +static int test_lineno_filter(void)
> > +{
> > +     struct allocinfo_tag_data_vec *tags =3D malloc(sizeof(*tags));
> > +     struct allocinfo_tag_data_vec *procfs_entries =3D malloc(sizeof(*=
procfs_entries));
> > +     struct allocinfo_filter filter;
> > +     enum ioctl_ret ioctl_status;
> > +     int ret =3D KSFT_PASS;
> > +     __u64 target_lineno, i;
> > +     struct allocinfo_tag_data *target_tag;
> > +     bool found =3D false;
> > +
> > +     if (!tags || !procfs_entries) {
> > +             ksft_print_msg("Memory allocation failed.\n");
> > +             ret =3D KSFT_FAIL;
> > +             goto exit;
> > +     }
> > +
> > +     memset(&filter, 0, sizeof(filter));
> > +
> > +     if (get_filtered_procfs_entries(procfs_entries, &filter)) {
> > +             ksft_print_msg("Error retrieving entries from " ALLOCINFO=
_PROC "\n");
> > +             ret =3D KSFT_FAIL;
> > +             goto exit;
> > +     }
> > +     if (procfs_entries->count =3D=3D 0) {
> > +             ksft_print_msg("Could not retrieve procfs entries\n");
> > +             ret =3D KSFT_SKIP;
> > +             goto exit;
> > +     }
> > +     /*
> > +      * We depend on the procfs results to determine the line number f=
or the filter before
> > +      * making the ioctl query. Hence, we cannot reuse run_filter_test=
 here.
> > +      */
> > +     target_tag =3D &procfs_entries->tag[0];
> > +     target_lineno =3D target_tag->tag.lineno;
> > +
> > +     filter.mask |=3D ALLOCINFO_FILTER_MASK_LINENO;
> > +     filter.fields.lineno =3D target_lineno;
> > +
> > +     ioctl_status =3D get_filtered_ioctl_entries(tags, &filter, 0);
> > +     if (ioctl_status =3D=3D IOCTL_INVALID_DATA) {
> > +             ksft_print_msg("Trouble retrieving valid IOCTL entries, s=
kipping.\n");
> > +             ret =3D KSFT_SKIP;
> > +             goto exit;
> > +     }
> > +     if (ioctl_status =3D=3D IOCTL_FAILURE) {
> > +             ksft_print_msg("Error retrieving IOCTL entries.\n");
> > +             ret =3D KSFT_FAIL;
> > +             goto exit;
> > +     }
> > +
> > +     for (i =3D 0; i < tags->count; i++) {
> > +             if (tags->tag[i].tag.lineno !=3D target_lineno) {
> > +                     ksft_print_msg("IOCTL entry %llu has incorrect li=
neno %llu.\n",
> > +                                    i, tags->tag[i].tag.lineno);
> > +                     ret =3D KSFT_FAIL;
> > +                     goto exit;
> > +             }
> > +
> > +             if (strncmp(tags->tag[i].tag.function, target_tag->tag.fu=
nction,
> > +                         ALLOCINFO_STR_SIZE) =3D=3D 0 &&
> > +                 strncmp(tags->tag[i].tag.filename, target_tag->tag.fi=
lename,
> > +                         ALLOCINFO_STR_SIZE) =3D=3D 0)
> > +                     found =3D true;
> > +     }
> > +
> > +     if (!found) {
> > +             ksft_print_msg("Original procfs entry not found in IOCTL =
lineno filter results.\n");
> > +             ret =3D KSFT_FAIL;
> > +     }
> > +
> > +exit:
> > +     free(tags);
> > +     free(procfs_entries);
> > +     return ret;
> > +}
> > +
> >   int main(int argc, char *argv[])
> >   {
> >       int ret;
> >
> > -     ksft_set_plan(2);
> > +     ksft_set_plan(4);
> >
> >       ret =3D test_filename_filter();
> >       if (ret =3D=3D KSFT_SKIP)
> > @@ -330,5 +532,17 @@ int main(int argc, char *argv[])
> >       else
> >               ksft_test_result(ret =3D=3D KSFT_PASS, "test_function_fil=
ter\n");
> >
> > +     ret =3D test_size_filter();
> > +     if (ret =3D=3D KSFT_SKIP)
> > +             ksft_test_result_skip("Skipping test_size_filter\n");
> > +     else
> > +             ksft_test_result(ret =3D=3D KSFT_PASS, "test_size_filter\=
n");
> > +
> > +     ret =3D test_lineno_filter();
> > +     if (ret =3D=3D KSFT_SKIP)
> > +             ksft_test_result_skip("Skipping test_lineno_filter\n");
> > +     else
> > +             ksft_test_result(ret =3D=3D KSFT_PASS, "test_lineno_filte=
r\n");
> > +
> >       ksft_finished();
> >   }
>
>
> https://sashiko.dev/#/patchset/cover.1783361692.git.abhishekbapat%40googl=
e.com
>
> Sashiko is really strict, but its warnings are legitimate. I ran the
> test program on a kernel built without
>
> CONFIG_MEM_ALLOC_PROFILING, and here are the results:
>
>
> [root@localhost alloc_tag]# ./allocinfo_ioctl_test
> 1..4
> # Failed to open /proc/allocinfo for reading
> # Error retrieving entries from /proc/allocinfo
> ok 1 # SKIP Skipping test_filename_filter
> # Failed to open /proc/allocinfo for reading
> # Error retrieving entries from /proc/allocinfo
> ok 2 # SKIP Skipping test_function_filter
> # Failed to open /proc/allocinfo: No such file or directory
> not ok 3 test_size_filter
> # Failed to open /proc/allocinfo for reading
> # Error retrieving entries from /proc/allocinfo
> not ok 4 test_lineno_filter
> # 2 skipped test(s) detected. Consider enabling relevant config options
> to improve coverage.
> # Totals: pass:0 fail:2 xfail:0 xpass:0 skip:2 error:0
> [root@localhost alloc_tag]#
>
>
> Looking at the test log above, some tests that ought to be skipped are
> flagged as failures.
>
> Would it make sense for us to go through all relevant test cases in the
> codebase,
>
> and check if we've missed any logic to skip tests when /proc/allocinfo
> is missing
>
> due to CONFIG_MEM_ALLOC_PROFILING being disabled?
>
>
> BTW,  when merging this series into the latest mm-new branch, there will
> be a minor header file conflict.
>
> This is because the series at
> https://lore.kernel.org/all/20260703-alloc-trylock-v5-15-c87b714e19d3@goo=
gle.com
> was merged ahead of this change.
>
> We might want to consider rebasing this series to resolve the header
> conflict.
>
>
> Thanks
>
> Best Regards
>
> Hao
>
>

Hi Hao,

Thanks for bringing this up, I discussed it with Andrew as well and
will fix it in the next version. Waiting for Suren's comments before
posting another version.

Thanks!

