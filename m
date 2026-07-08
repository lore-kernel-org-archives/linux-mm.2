Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E44AFC43602
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 16:46:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C34676B0088; Wed,  8 Jul 2026 12:46:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0BDC6B008A; Wed,  8 Jul 2026 12:46:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD6AF6B008C; Wed,  8 Jul 2026 12:46:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7E3826B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 12:46:31 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C7884120217
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 16:46:30 +0000 (UTC)
X-FDA: 84966187740.01.425A8BD
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf25.hostedemail.com (Postfix) with ESMTP id C6733A000D
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 16:46:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DpIIMygX;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783529188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3IZCtBnhcpmWhrAVR8iONqaT4sw22ll7ue/gnD3gzAo=;
	b=QaEaFLXtCfQszeqG/g7z8fem7VjMq3E55dzeD3ca1iZx4I+JwwdUj37hwonuEitnW1ku4P
	D+0BkAAypgs1gt5gZQgOFAZXOrZlXJxD/YDJp9QSzddu1rN9uoNbgruMYNAdGHVdGSdaQV
	nr2CLyh/b/ffS7FsHYv6CWwC9MN6TL8=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DpIIMygX;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783529188;
	b=FhdRZZL7Va3//liqPfS/tV73lAc95bcAF3+/yDZXN2Oza0RXG9KXdUFj9Mkw9HaWQyfcdO
	Of3WPMvYAJqq07Bu6fMM8L0WsxaZsfGAIwqQeWvtPZhbgYTsFXhcsWEgmXUXnSofh2kPoR
	55fuwQaNnu5GQs3BtGzfC/5fqphoJKk=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51c10e86e52so278641cf.1
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 09:46:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783529188; cv=none;
        d=google.com; s=arc-20260327;
        b=eM+Y/B9s/tkmZgFSA9EwUrbEQvaYA0UnylWAX3VY/GIS+h0+5h+mhK+Jb7xN1kH1zW
         pbuE5ZL1i5ScI30qW3re4X8rIvRNrIZQZtzl0VCZZNwLUkZpsu9qiB4xPJkSJGxxTZex
         8x2BcXQTTnLYtFortAQsK0OvRvuHekhOh9DOqFratVFRlL6F4kdbgG5dIWQMkTIvaM2g
         pXWieeefnoR1a23gQOJuCLl18+d9mxN/Rgjg5yQcSejvhaFR/fypO1GdR5q1Rg9hdfZN
         YnWw6sA5nR7iCeAWrOpoggoQBaB0LgxPmUKhvyQpitQRkXyllgvVDD7glLcNXzPt8i9a
         qn2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3IZCtBnhcpmWhrAVR8iONqaT4sw22ll7ue/gnD3gzAo=;
        fh=3xFp4z3yCv/J+2Q466NX1KIZCN8VXsPGdmWwokz1o0o=;
        b=oVOTQIdUtnBDN1nG2C7hM2emsMaBLr6SiMb7J6cRDC1fSO1eRYEM1PHzXrF82DbDBG
         GR6kzM7vlIWl+XBMj3SNgMhyXuNgmofpSk9j3h5W+2mcSve5iifO8yMReOu8vo3e0Pe4
         g0cY2/PRjiyUPkOYEAWMFrhbpZcZz6RaX2OUTkLZT7i4reIxXxf4Lyec1zlM/EdFNUS4
         BQAekEzJwksaFi282GRxxFKVCPCUzbNH4a8DGYRqjSyN6HvHmms/sE7fRXahzyyjqywI
         /yMH7sKJnjGcdE+OG5BqOF2msqflORjX9mTeMs+SNdh/eO7z5fPj99j8xhjT3bci9D4W
         lUBw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783529188; x=1784133988; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3IZCtBnhcpmWhrAVR8iONqaT4sw22ll7ue/gnD3gzAo=;
        b=DpIIMygXZaUt/J7JgP0x3b33WlwFcQ2UIF4XQQ8jIVo8oPKG3yLziB0x7lmcrKdzwN
         e066Cg68BTH9WpfWx+K+e8iGU9btXnZQVl7C+JmFz8yyw/17RP2Vsd7yPfLg0W4asFmN
         2gl31b53ppEDbuR0lAqxhMi5WmKJ7oke3WSIc0FlTAPlBhPobNxZzBxARf73cBtgxC+V
         kZYcdoEuT27iuZsk8E5EWiW5mofYMt284SFCT3vld+VDDKxn53QnAhadl6MFNcq0vd0F
         S55eW5qB4ckYsLHmJO5YfY9kZIMeugiWP7uVoL0jGfTRSwiTLlMYYuf/l/Lfzq7bX63G
         GFdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783529188; x=1784133988;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3IZCtBnhcpmWhrAVR8iONqaT4sw22ll7ue/gnD3gzAo=;
        b=iNYw8S4hV9462DeLBzb8uR3qJemuSt1GpvXPJfKwNRK5y7onn79gD2Y8Irvfy6ivG5
         BfEKebTP2cOnOZyT7qpXE8Y1WBhJgiwRkZApDRDb6XG/spNvuq5yhbwySlmtnA8pe3Xl
         c+2Vg1boCgg4pCVigYN4ED6USn4CDWp4LVSE1uczyDJGdY41DrlqfbA+upy4pSnsilRE
         e/2HnJFQdN9YErvdZ9xNJKm+nltPLzVpiBs0TsX2oDIozJgc76/NRfsFUJ8DVVSzNC9u
         yW01Yrwb+CeOVEffYpepeD7wJVdXV74Or9t3e+UBJ9qCkjflDDWQCQezI+yqMrxp0Z6l
         ZnCA==
X-Forwarded-Encrypted: i=1; AHgh+RrsOZEI95DvhMoU7mqPtzW/ry54XCNHXpHFPugpnw/bcXSvJ1wmw814bhAPcZ931oLE7V6RKP+mFA==@kvack.org
X-Gm-Message-State: AOJu0YyoJ/w3V7kpWTVdGs5sZ/0ioyoXb/s8qtEqYDHdUfiIzjCtGiy5
	HsMel2cJQHtdEZv2vYO45WZbFoTifo0XRAHgUEpB2LyOigdMugrklCPrCFLuZUaB/nPi0cbDnoZ
	2QWoCSpnBSyqPTNcpksYvmD5BI735FPZit0j2H1Ws1UcZ2/fbQGy4a68nYt4=
X-Gm-Gg: AfdE7cmZV48PScc3qfl38OpU6f31i0Z8hgJRYPSjAryxkJwVTdnSl6QNuf6fSg5DzIs
	oGcN0GjIV9o4sMq/n6h78CGv3nDlVVNQEDjesoQWh0Cg9ENG0Zs9KDMp9yDug6rHSls3ZhOL4im
	BCrcH/bAzqEoomgdIGGcMivgM1s94ZEqAUEi/j8Y86Na/l9S4nRC3fHdc1jhxPThS151aE7TWe/
	EUT+RyATW5W3xJHeJj/xTRIsTMTEc/srKL19bbuZsG4BItdVrKRfdwjgzggs9QqSkMpYA0WvnNR
	cVRqmmeBuu6NxCGRn7n3aRNO
X-Received: by 2002:a05:622a:6684:b0:519:b655:235 with SMTP id
 d75a77b69052e-51c96d9ba2fmr219201cf.3.1783529187229; Wed, 08 Jul 2026
 09:46:27 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1783361692.git.abhishekbapat@google.com>
 <f6bd1ff0257987dbb7512f93595eaa6962c6153b.1783361692.git.abhishekbapat@google.com>
 <4cc47988-49b3-4b73-90ed-a0a16a56a8dc@linux.dev> <CAL41Mv6SdpOd=oLp9ceBkR-q_Y73Fx6rYjFO-Zc0hiNJjCFzYA@mail.gmail.com>
In-Reply-To: <CAL41Mv6SdpOd=oLp9ceBkR-q_Y73Fx6rYjFO-Zc0hiNJjCFzYA@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 8 Jul 2026 12:46:15 -0400
X-Gm-Features: AVVi8CfdW5a_6w9H4h8puTYyUWLIRYPykZWez8jFl1QFDheAElWManBZcW37izk
Message-ID: <CAJuCfpHaKRBDMPF7yHiCgimFmo6Z8kj78caEOF3vsYErv7WyLg@mail.gmail.com>
Subject: Re: [PATCH v7 6/6] kselftest: alloc_tag: extend the allocinfo ioctl kselftest
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Hao Ge <hao.ge@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Kent Overstreet <kent.overstreet@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C6733A000D
X-Stat-Signature: pjt71z4669csm3u8oug7b5qgsd4auyx9
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783529188-147411
X-HE-Meta: U2FsdGVkX1/XjTpI9js/X1vvr9r3hE9GYS3xTEuA+rSXAmKixtfBWhVlphhfscnsuKjSgFYaXa76YTsfP2w7eNwlDdtzb7bUOqAphx8wXSjMBU/LrJ2YPf/i5Asy6hSpNwaUIYzXCV0uIOZUD3h4gCD0ccspJgJq6Cw1EjLnzrUvqEGYuBVwAOgz4QwK1QoagP5VIkdKodmMRFYfvRT87XMe2X6HcgZ7kFUpNdhAPgXirsdEffaEhbfM2DB7CUZ4DoxvUvIJKHQ3MFa6U3q+uSgv26Fbr7881nzSG6HImdVO2KadEmhZJ32XovK49amc5COktQwtFnNinfksepU4ld1/3DIMy1zHEd2OTa6KKyIoly/rU9XTZfPLc3C2Cj5YGOqphl8CzZSYFVrHt1s58BcAMxPm7ZvjPmIVo5XyBtUrlyBunZTMs1aM/YPQkIhT03HRVsnpix+YopH9y1CZG7IYk0bkZ/HF5Ybkwqqwxd7dnVU4mjsbUSr7RX1XS5kMOeXjlbzq9Ix8/frA1Glww19ViTUcT6/6YlP3Yspi3rTwZpHgnh9p/Hl+PSppXCKJpPLNQFv3QXJzPdUKRPvxwt/M54OoAROgPkv0PLl/BaFSLIQtn18fzNZqW7zjs+926pWHB09lzgj4zb5vMYkWYT4UpW5ct/sb9Of5z1M7UmCLhArMZfTwYb0RHt7RxnXqE5QbeVsat4SvzTYutm+rB+F20aHPVzZBGsz1GuoRM5AXFsR8IeO3dpjOJBinFxgEhFY5NaZ20QVEjVYBMeCjGpDwC+8lbnRalDWD/EJ17TFXfnuwf4WJ1l+LFO+/NmibpQRviw4yDAlXzqq48qMBFYK45z19CNKpDpi8yc31fZphde1XGh6z6bq/3zUSAsvN2E3ZfAqfoW0UBTpa+HXd+yCDFU1/ivJYToVyOEcRox9007EtCjy7Au8+/T3N9x8aVxrwv2TAt/xNoc0YvW1
 u70phmUc
 aq3Y5H7SdRGKAA+TATHpMfZF8kjExDR9g5a1CWQxV1dn7s1x7ySuE5SAyDw2r6G9VIfnljYQr+Pw5ePgx4I0uBHyoVrg0JLtH5Ha5oPQv+2rjykMSmNpFWgc66vjF1GygdIXvqmBWKEXjZ1JGlkyrcmvaxNJ92WuhDzqunrjNj6VvYCpV/34XocQxP1BdAN88udST4kGUFGtizn+jUb39jLyhKP6iopBhTyb9burBwC4AvT6jsfIxOQtSydT4/K5IpXmhrp00Zdv38oF/b1Tj2vAI2vGVoOf6Kovd+9PjUAHmNHC0rGKPo0zIT3hdaqe+tqgo+fgHXV77Ub8KPNIfM2C+7pRJOamjVwP4YKcyeIGMml77Q3akLhylsFLcly/Bptyp4roDS562314=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 7, 2026 at 12:59=E2=80=AFPM Abhishek Bapat <abhishekbapat@googl=
e.com> wrote:
>
> On Mon, Jul 6, 2026 at 8:28=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
> >
> > Hi Abhishek
> >
> >
> > On 2026/7/7 02:25, Abhishek Bapat wrote:
> > > Add the following 2 scenarios to the allocinfo ioctl kselftest:
> > > 1. Validate size based filtering
> > > 2. Validate lineno based filtering
> > >
> > > The first test uses "do_init_module" as the candidate function for th=
e
> > > test. This is because the associated site will only allocate memory w=
hen
> > > a kernel module is loaded. The return value of get_content_id() chang=
es
> > > every time modules are loaded or unloaded. Hence, as long as
> > > get_content_id() values at the start and the end of the test are the
> > > same, the memory allocated by the do_init_module call site should als=
o
> > > remain the same. Consequently, the test can assume consistency betwee=
n
> > > the value returned by the ioctl and the procfs resulting in less
> > > flakiness.
> > >
> > > Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> > > ---
> > >   .../alloc_tag/allocinfo_ioctl_test.c          | 216 +++++++++++++++=
++-
> > >   1 file changed, 215 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c=
 b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> > > index 9ce7b53078b1..092348097204 100644
> > > --- a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> > > +++ b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> > > @@ -5,6 +5,7 @@
> > >    * Copyright (C) 2026 Google, Inc.
> > >    */
> > >
> > > +#include <errno.h>
> > >   #include <fcntl.h>
> > >   #include <stdio.h>
> > >   #include <stdlib.h>
> > > @@ -312,11 +313,212 @@ static int test_function_filter(void)
> > >       return run_filter_test(&filter);
> > >   }
> > >
> > > +static int test_size_filter(void)
> > > +{
> > > +     int fd;
> > > +     struct allocinfo_tag_data_vec *tags =3D malloc(sizeof(*tags));
> > > +     struct allocinfo_tag_data_vec *procfs_entries =3D malloc(sizeof=
(*procfs_entries));
> > > +     struct allocinfo_filter filter;
> > > +     int ret =3D KSFT_PASS;
> > > +     __u64 target_size, i, pos;
> > > +     struct allocinfo_tag_data *found_tag =3D NULL;
> > > +     const char *target_function =3D "do_init_module";
> > > +     struct allocinfo_content_id start_cont_id, end_cont_id;
> > > +     int retry =3D 0;
> > > +     const int max_retries =3D 10;
> > > +
> > > +     if (!tags || !procfs_entries) {
> > > +             ksft_print_msg("Memory allocation failed.\n");
> > > +             ret =3D KSFT_FAIL;
> > > +             goto freemem;
> > > +     }
> > > +
> > > +     fd =3D open(ALLOCINFO_PROC, O_RDONLY);
> > > +     if (fd < 0) {
> > > +             ksft_print_msg("Failed to open " ALLOCINFO_PROC ": %s\n=
", strerror(errno));
> > > +             ret =3D KSFT_FAIL;
> > > +             goto freemem;
> > > +     }
> > > +
> > > +     do {
> > > +             found_tag =3D NULL;
> > > +             pos =3D 0;
> > > +
> > > +             if (__allocinfo_get_content_id(fd, &start_cont_id)) {
> > > +                     ksft_print_msg("allocinfo_get_content_id failed=
\n");
> > > +                     ret =3D KSFT_FAIL;
> > > +                     goto exit;
> > > +             }
> > > +
> > > +             memset(&filter, 0, sizeof(filter));
> > > +             filter.mask |=3D ALLOCINFO_FILTER_MASK_FUNCTION;
> > > +             strncpy(filter.fields.function, target_function, ALLOCI=
NFO_STR_SIZE);
> > > +
> > > +             if (get_filtered_procfs_entries(procfs_entries, &filter=
)) {
> > > +                     ksft_print_msg("Error retrieving entries from "=
 ALLOCINFO_PROC "\n");
> > > +                     ret =3D KSFT_FAIL;
> > > +                     goto exit;
> > > +             }
> > > +
> > > +             if (procfs_entries->count =3D=3D 0) {
> > > +                     ksft_print_msg("Function %s not found in procfs=
\n", target_function);
> > > +                     ret =3D KSFT_SKIP;
> > > +                     goto exit;
> > > +             }
> > > +
> > > +             target_size =3D procfs_entries->tag[0].counter.bytes;
> > > +
> > > +             memset(&filter, 0, sizeof(filter));
> > > +             filter.mask |=3D ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLOC=
INFO_FILTER_MASK_MAX_SIZE;
> > > +             filter.min_size =3D target_size;
> > > +             filter.max_size =3D target_size;
> > > +
> > > +             while (1) {
> > > +                     struct allocinfo_get_at get_at_params;
> > > +
> > > +                     memset(&get_at_params, 0, sizeof(get_at_params)=
);
> > > +                     memcpy(&get_at_params.filter, &filter, sizeof(f=
ilter));
> > > +                     get_at_params.pos =3D pos;
> > > +
> > > +                     if (__allocinfo_get_at(fd, &get_at_params))
> > > +                             break;
> > > +
> > > +                     tags->count =3D 0;
> > > +                     memcpy(&tags->tag[tags->count++], &get_at_param=
s.data,
> > > +                            sizeof(get_at_params.data));
> > > +
> > > +                     while (tags->count < VEC_MAX_ENTRIES &&
> > > +                            __allocinfo_get_next(fd, &tags->tag[tags=
->count]) =3D=3D 0)
> > > +                             tags->count++;
> > > +
> > > +                     for (i =3D 0; i < tags->count; i++) {
> > > +                             if (strcmp(tags->tag[i].tag.function, t=
arget_function) =3D=3D 0) {
> > > +                                     found_tag =3D &tags->tag[i];
> > > +                                     break;
> > > +                             }
> > > +                     }
> > > +
> > > +                     if (found_tag || tags->count < VEC_MAX_ENTRIES)
> > > +                             break;
> > > +
> > > +                     pos +=3D tags->count;
> > > +             }
> > > +
> > > +             if (__allocinfo_get_content_id(fd, &end_cont_id)) {
> > > +                     ksft_print_msg("allocinfo_get_content_id failed=
\n");
> > > +                     ret =3D KSFT_FAIL;
> > > +                     goto exit;
> > > +             }
> > > +
> > > +             if (start_cont_id.id =3D=3D end_cont_id.id)
> > > +                     break;
> > > +
> > > +             ksft_print_msg("Module load detected during size verifi=
cation, retrying...\n");
> > > +     } while (retry++ < max_retries);
> > > +
> > > +     if (start_cont_id.id =3D=3D end_cont_id.id && !found_tag) {
> > > +             ksft_print_msg("Entry with function %s not found in IOC=
TL results\n",
> > > +                            target_function);
> > > +             ret =3D KSFT_FAIL;
> > > +     } else if (start_cont_id.id !=3D end_cont_id.id) {
> > > +             ksft_print_msg("Failed to match content_ids for procfs =
and IOCTL, skipping...\n");
> > > +             ret =3D KSFT_SKIP;
> > > +     } else if (found_tag && found_tag->counter.bytes !=3D target_si=
ze) {
> > > +             ksft_print_msg("IOCTL entry size %llu does not match ta=
rget size %llu\n",
> > > +                            found_tag->counter.bytes, target_size);
> > > +             ret =3D KSFT_FAIL;
> > > +     }
> > > +
> > > +exit:
> > > +     close(fd);
> > > +freemem:
> > > +     free(tags);
> > > +     free(procfs_entries);
> > > +     return ret;
> > > +}
> > > +
> > > +static int test_lineno_filter(void)
> > > +{
> > > +     struct allocinfo_tag_data_vec *tags =3D malloc(sizeof(*tags));
> > > +     struct allocinfo_tag_data_vec *procfs_entries =3D malloc(sizeof=
(*procfs_entries));
> > > +     struct allocinfo_filter filter;
> > > +     enum ioctl_ret ioctl_status;
> > > +     int ret =3D KSFT_PASS;
> > > +     __u64 target_lineno, i;
> > > +     struct allocinfo_tag_data *target_tag;
> > > +     bool found =3D false;
> > > +
> > > +     if (!tags || !procfs_entries) {
> > > +             ksft_print_msg("Memory allocation failed.\n");
> > > +             ret =3D KSFT_FAIL;
> > > +             goto exit;
> > > +     }
> > > +
> > > +     memset(&filter, 0, sizeof(filter));
> > > +
> > > +     if (get_filtered_procfs_entries(procfs_entries, &filter)) {
> > > +             ksft_print_msg("Error retrieving entries from " ALLOCIN=
FO_PROC "\n");
> > > +             ret =3D KSFT_FAIL;
> > > +             goto exit;
> > > +     }
> > > +     if (procfs_entries->count =3D=3D 0) {
> > > +             ksft_print_msg("Could not retrieve procfs entries\n");
> > > +             ret =3D KSFT_SKIP;
> > > +             goto exit;
> > > +     }
> > > +     /*
> > > +      * We depend on the procfs results to determine the line number=
 for the filter before
> > > +      * making the ioctl query. Hence, we cannot reuse run_filter_te=
st here.
> > > +      */
> > > +     target_tag =3D &procfs_entries->tag[0];
> > > +     target_lineno =3D target_tag->tag.lineno;
> > > +
> > > +     filter.mask |=3D ALLOCINFO_FILTER_MASK_LINENO;
> > > +     filter.fields.lineno =3D target_lineno;
> > > +
> > > +     ioctl_status =3D get_filtered_ioctl_entries(tags, &filter, 0);
> > > +     if (ioctl_status =3D=3D IOCTL_INVALID_DATA) {
> > > +             ksft_print_msg("Trouble retrieving valid IOCTL entries,=
 skipping.\n");
> > > +             ret =3D KSFT_SKIP;
> > > +             goto exit;
> > > +     }
> > > +     if (ioctl_status =3D=3D IOCTL_FAILURE) {
> > > +             ksft_print_msg("Error retrieving IOCTL entries.\n");
> > > +             ret =3D KSFT_FAIL;
> > > +             goto exit;
> > > +     }
> > > +
> > > +     for (i =3D 0; i < tags->count; i++) {
> > > +             if (tags->tag[i].tag.lineno !=3D target_lineno) {
> > > +                     ksft_print_msg("IOCTL entry %llu has incorrect =
lineno %llu.\n",
> > > +                                    i, tags->tag[i].tag.lineno);
> > > +                     ret =3D KSFT_FAIL;
> > > +                     goto exit;
> > > +             }
> > > +
> > > +             if (strncmp(tags->tag[i].tag.function, target_tag->tag.=
function,
> > > +                         ALLOCINFO_STR_SIZE) =3D=3D 0 &&
> > > +                 strncmp(tags->tag[i].tag.filename, target_tag->tag.=
filename,
> > > +                         ALLOCINFO_STR_SIZE) =3D=3D 0)
> > > +                     found =3D true;
> > > +     }
> > > +
> > > +     if (!found) {
> > > +             ksft_print_msg("Original procfs entry not found in IOCT=
L lineno filter results.\n");
> > > +             ret =3D KSFT_FAIL;
> > > +     }
> > > +
> > > +exit:
> > > +     free(tags);
> > > +     free(procfs_entries);
> > > +     return ret;
> > > +}
> > > +
> > >   int main(int argc, char *argv[])
> > >   {
> > >       int ret;
> > >
> > > -     ksft_set_plan(2);
> > > +     ksft_set_plan(4);
> > >
> > >       ret =3D test_filename_filter();
> > >       if (ret =3D=3D KSFT_SKIP)
> > > @@ -330,5 +532,17 @@ int main(int argc, char *argv[])
> > >       else
> > >               ksft_test_result(ret =3D=3D KSFT_PASS, "test_function_f=
ilter\n");
> > >
> > > +     ret =3D test_size_filter();
> > > +     if (ret =3D=3D KSFT_SKIP)
> > > +             ksft_test_result_skip("Skipping test_size_filter\n");
> > > +     else
> > > +             ksft_test_result(ret =3D=3D KSFT_PASS, "test_size_filte=
r\n");
> > > +
> > > +     ret =3D test_lineno_filter();
> > > +     if (ret =3D=3D KSFT_SKIP)
> > > +             ksft_test_result_skip("Skipping test_lineno_filter\n");
> > > +     else
> > > +             ksft_test_result(ret =3D=3D KSFT_PASS, "test_lineno_fil=
ter\n");
> > > +
> > >       ksft_finished();
> > >   }
> >
> >
> > https://sashiko.dev/#/patchset/cover.1783361692.git.abhishekbapat%40goo=
gle.com
> >
> > Sashiko is really strict, but its warnings are legitimate. I ran the
> > test program on a kernel built without
> >
> > CONFIG_MEM_ALLOC_PROFILING, and here are the results:
> >
> >
> > [root@localhost alloc_tag]# ./allocinfo_ioctl_test
> > 1..4
> > # Failed to open /proc/allocinfo for reading
> > # Error retrieving entries from /proc/allocinfo
> > ok 1 # SKIP Skipping test_filename_filter
> > # Failed to open /proc/allocinfo for reading
> > # Error retrieving entries from /proc/allocinfo
> > ok 2 # SKIP Skipping test_function_filter
> > # Failed to open /proc/allocinfo: No such file or directory
> > not ok 3 test_size_filter
> > # Failed to open /proc/allocinfo for reading
> > # Error retrieving entries from /proc/allocinfo
> > not ok 4 test_lineno_filter
> > # 2 skipped test(s) detected. Consider enabling relevant config options
> > to improve coverage.
> > # Totals: pass:0 fail:2 xfail:0 xpass:0 skip:2 error:0
> > [root@localhost alloc_tag]#
> >
> >
> > Looking at the test log above, some tests that ought to be skipped are
> > flagged as failures.
> >
> > Would it make sense for us to go through all relevant test cases in the
> > codebase,
> >
> > and check if we've missed any logic to skip tests when /proc/allocinfo
> > is missing
> >
> > due to CONFIG_MEM_ALLOC_PROFILING being disabled?
> >
> >
> > BTW,  when merging this series into the latest mm-new branch, there wil=
l
> > be a minor header file conflict.
> >
> > This is because the series at
> > https://lore.kernel.org/all/20260703-alloc-trylock-v5-15-c87b714e19d3@g=
oogle.com
> > was merged ahead of this change.
> >
> > We might want to consider rebasing this series to resolve the header
> > conflict.
> >
> >
> > Thanks
> >
> > Best Regards
> >
> > Hao
> >
> >
>
> Hi Hao,
>
> Thanks for bringing this up, I discussed it with Andrew as well and
> will fix it in the next version. Waiting for Suren's comments before
> posting another version.

I went over the series and it LGTM. Please post the new version and
please use "git format-patch --base=3Dauto" when formatting the patches
to send so that we know which branch the patchset was based on.
Thanks,
Suren.

>
> Thanks!

