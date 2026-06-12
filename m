Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9311CD98D5
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 00:24:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4E266B0005; Thu, 11 Jun 2026 20:24:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFF086B0088; Thu, 11 Jun 2026 20:24:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AED266B008C; Thu, 11 Jun 2026 20:24:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 989E36B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 20:24:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2AD5991AC8
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:24:04 +0000 (UTC)
X-FDA: 84869363208.07.DF1295C
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf08.hostedemail.com (Postfix) with ESMTP id 321D4160007
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:24:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="cWTT+g/w";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf08.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=abhishekbapat@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781223842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jyXrMUC0RjTC8nbXHDAOeHanWGsmOWhzs5+AVdeqrmM=;
	b=CZtr17jqZZy59/v0a/Y3pecXKjQh5c5N+WGB5huGZZkhFiYgI1p/p07taoociGLAjZ2b6j
	SM9ICp/vT4ftk0RlY+RKvLcXdiSpUu5RRn3AqkBUcwnmIPp+e34fBksGbYSMYVBfqsQ9DW
	amqx4pXon7Z71NvMfPg7Ao5BT0ZJRsI=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="cWTT+g/w";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf08.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=abhishekbapat@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781223842;
	b=eyFVaofK0iXQcwrirKgv1059E1DtNnp/WyGb0JTfgvy2z/AN05qpOfrR6Rab39603BzcuZ
	CM7oSLp6OfAT7PFw9RjdKK11dfhhGY/7dApADfL1fDCYKPmk6/UXt+yK/UTPT9iXtK08U+
	+CnnLDkbvoxIPWcb3lN3mg1dQrygXN4=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2bf22c18ad3so48875ad.0
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 17:24:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781223841; cv=none;
        d=google.com; s=arc-20240605;
        b=G4GWfOJd8bkCa3lw9xw3M/5N91Nz0RAYeX3XDcXaJVzUTjwrfxBnmav/nLzHG/mo9P
         Ct7qi2K98YweewWgQOSZGwnrxhUQEFr/PY/ewhyKvo+vzW9tDIZKMhPvqeawsWpfJk1y
         uRHNTt9VGsBr40DsSWqWIdjN92a4SGQp0/POv023ooIprN8EGt9eAMvIyhnFcnML5ZB3
         3DHg/udQcsV3DBsYHsMSwGIpRpbZOf4DBWKP2ZELtfjvzzXVkOqjmY4A8FZ38fE5txi7
         ob4cjmAeZ3Oj7p8P+9zOkk8y8pOvgIaKxb/k+7ySwvr1SZg3A7Bu50lxWiIIHNaTfoJf
         hVCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jyXrMUC0RjTC8nbXHDAOeHanWGsmOWhzs5+AVdeqrmM=;
        fh=MToBprwJKCaEeREbKXggqVHp2FRxz/XWgOFpgR+fuQM=;
        b=Pc3FY88AW3lJQt0lKISzh1YNVzD/swVPUGJbIv+E8oRlmXNsMTgk2a4Qh7zqXDxaNF
         1l1yB1fHfElApSk9sJCJd3RtLDgLYEE+PXI4DuqVdny5yz0eRqjcCn+DqrATEf16qhcE
         Cc0sVE0Z0azy2HbO1NSH4nKPXlroiXi9YLC1U+3KGFp9KTpEfwIX2U5Obtzj0HIKnwbY
         zg/UYa3K1rXxq5TDY4EsLdu4E9cXzvvz9ADXtfSbQZvcnLQvSwU4eLmtU6LFt15Bk+/K
         rCuihyy1NcZ4euy6LMENMm1P5Z3a/9Azmkgl8x1LvfOVU6+/po3TvmmsSIdGCdOPmWuJ
         vkfw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781223841; x=1781828641; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jyXrMUC0RjTC8nbXHDAOeHanWGsmOWhzs5+AVdeqrmM=;
        b=cWTT+g/wY9zLRK4bAjWAHgdoRtMHg0Q1OPoKLnOLZsKEDSISW6lcAgE3wV/f4538Ip
         ntpIFpxJaglCqzFsQF+J9EDWwtbS0n5OV2wCDX45pnMR7mEQe1b3alUBJBbOlsIZm1hi
         5013et+3/ToaWzcIxJHUDnnOMtIhTAxOc8p3pImNi6+S9wP6UwCoXhLQvLhYhJTVpPjz
         RTUdf7SUVN5zpXjA7u2yy3YTlmAKzCgN8f6ScDaY+IBd/5qOZKlRH9uIkJtZT0Agdrry
         COdDVYkTodaDMeFy3EOON//AaiUcwbJn2PZ78TGtOW8/f10DQN1lqUXhm/wu56xv/tLX
         tW+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781223841; x=1781828641;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jyXrMUC0RjTC8nbXHDAOeHanWGsmOWhzs5+AVdeqrmM=;
        b=HsJtas0N8lqwkGH1+rlyoIVg0OfpHCtM/MyFSmEUL8ZjSeNI2RtWcBJF9TS4NKYfTz
         9xgwyY1XLR4Bq3CxvShZAzHVxTtAYyIgB6QCG22o/f+DiuYDnXsdpBpCtRs7ewoxz/eb
         pXcQFW9kOSn2Zz4+WvP0wKFMeFdXYHTbBq6yyf9i8YkZr6ZGgIFUnlBMSFJbOMFXEGir
         Bg0z7LpaVn+LGsk3V68n5X4B9ZA5xwXDCgP/hyqpwxWI+1HGcteLBZEWT8GsXMSQuwV1
         UbwrkkE9I4AhwVcHts2p1wA8zWY2Wgef8GnxeSF/Ebj9JKwAqfrKUjt8im7yghz2U+t/
         ZdTg==
X-Forwarded-Encrypted: i=1; AFNElJ8LHDUfvGDXVaEO5O2hiIp33/sdRGRVK3dPOJwF6hI4J0wXgr/oQp77y4OHRkQJxwlkuXqLj9FQsA==@kvack.org
X-Gm-Message-State: AOJu0Yx8Tu0e+STsrnxX9wLGwtHVy/97xncNrg9U7wCqKhKdHLOHvrDR
	Ukdwp6jifDXcsxG7+ewakvrmBdSwZpF0b0ZTjIXonbyvmsLKpgZIH7yH/htZf8P6WQlh9NT6Xra
	v4wMQrGhU7GrmaZGNiRcJ9bgfKm19KfMTZ9yJGz9P
X-Gm-Gg: Acq92OECrrea+xBhigm7alGSEpAnFRqRgfu+K0YkzOvE52jNL8URUp6y20IWQIHARHp
	lGOfFmDva7E4arQlvFjG1invzWGK3e5UgIgLY9CCUgYXXNNwwZUFzd+9kRafT5pmoxtKhoX8h7n
	Jr81Qw2pyUQjbGaG9ocFWWL8jI5JPKDiZgeYdB7SxDiacWD63FG782HKFXVXf935UMQmM4TgoOU
	RNVfngXRjM1Kxd8h1VVEY4ltfjAh8qHmrspl2Ixuo3IJII9DkOiLQUmeOihNlW0dFqlC70w74Wz
	DE4h+Y/mLAoDL+3lhLTMXxWvZuNlus6pfEDv4w==
X-Received: by 2002:a17:903:2b03:b0:2bd:6727:d689 with SMTP id
 d9443c01a7336-2c3e10657b2mr1140345ad.12.1781223840341; Thu, 11 Jun 2026
 17:24:00 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1781042698.git.abhishekbapat@google.com>
 <d0a8308b4d0799876d24461a8ed9b5a71d3e1e89.1781042698.git.abhishekbapat@google.com>
 <c7ae2aa9-a1fb-4965-a213-f9cfb2aa101e@linux.dev>
In-Reply-To: <c7ae2aa9-a1fb-4965-a213-f9cfb2aa101e@linux.dev>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Thu, 11 Jun 2026 17:23:48 -0700
X-Gm-Features: AVVi8CfF5CHgoW_9yOQmI4p_7KWANitzcX4FWUhUywKGZOQVl_gGnfRVD-S8jvU
Message-ID: <CAL41Mv5eoi=ms-x8roBnuxj4pzYKQjsSthzom_wzCM39JAXe+Q@mail.gmail.com>
Subject: Re: [PATCH v4 6/6] kselftest: alloc_tag: extend the allocinfo ioctl kselftest
To: Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Suren Baghdasaryan <surenb@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Kent Overstreet <kent.overstreet@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: j5dtuss8ixajabu6qxc4b1ggn75x3nnc
X-Rspamd-Queue-Id: 321D4160007
X-HE-Tag: 1781223841-830170
X-HE-Meta: U2FsdGVkX18oaHYGSAUhNrBiPmF8Rkid9gmzmMcxQv7yCKMsI+X55/34rTBTzbO1XMVS/BapUzWNt8SPjHTeP8Ef5oJCUBcmitPFQJliGq6e4XEtJp0zGeeBQsT0TMI7e9uz5tLcut3qpVygkOzTWStGs4dc93qTbqxCfGajb57hNkYzgKHx1dstrY8iF7PoqyT8jZvlUQFzqw6HH58quikKpi+fFcy6O2nYoViPJZyRoYYegnWWHSoPRrxyJm19djGWgsSpEkT7Xu9nlGR96lcOqLpySgh7bt7qYlOpUrkABg512hOEn2o8NkzOq4iTLzEvRjNkD4Gz4gcIJjHpOP6wq9EF99CjGiqNa/mtSASLxTil33B7FSZwizAF8fyCFbKeDZ4KFwqlni8frKnh3gfgsaq9309M6gGqxmpchlw0MDh4K17asE+2Gb3FcO6OlGRDM/l+STbubruTU0SdF72C2NVJU4QIwBRZQYqx/kwTZcM6OFQOg+hbvfNJ5p+D/VXhlR3wTJe9FFXnzAyxg+oUKEvEtLlnyYZLG9Sa79kIzaJ3We6tG/COEC1GMLpwu45MhmHjtwll9KXXQuOtSGowhElG3Y2S//emLGfd53E8WIxVvdc50oQ3PA+bFPsFt1s46qC2ALphidTUrJv++dCfGiqR/XmZZaLJprx4ewBovQP2VBF8Hss69TjKHWoRqvyfNGHsxqBlo9rmQsEiK2OdEu94ZvPGNrgqQ8ohDukLENu/Nx7/j08fV1wCDHScAFuXA08pMajeGOqjN0LVw25Hi0zttqHl9NS2F9LHcDQRvagmL4zHScq+NsIhE1CM8ZqPTr5eudsPCb4xEHNIGEloDTaKap5R7bg7APfZ/pxxS9/XAz8ADnYqGCo23DOaWON4NjTLNTVdXWOAVQcp/ZCg84V+mCp466LRz2GIwCZ74iXdCuNb9u/76zo6zFS4lJrQBTr1SfE5O+Sui/t
 jAsjQbU+
 72z2qXarH/PKGJ38nseK5uvJdJ+UptVmY7y6XF7e+mYkTibKEdcc/Pv7nKGAaIH1sQj6OpLAes9aCdDnGu3t/cr3H399i4FP4RgxPA2PN0bSr63x48wvK3v837cJFJyehroU+6lNmXrdiy2Dih2BZABs8+b5Y4r+ezC/6A2FLqQPFutucg4yTeWVMh93WFMVLYr0PTKVtOE+KPOtbxw53L+m+x7vzuBhgCoWNa53axjGSA3WtudiUmksDiT0O76tzQP+w5yXjV8WCv5P/fKKLTyQXMsp03+Dg2Hn5BAtMDJc7eGJSa05sNqCoIjJf46Yc4f2aOFl6upYPc31e/aooUYORqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 2:34=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Abhishek
>
>
> On 2026/6/10 08:12, Abhishek Bapat wrote:
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
> >   .../alloc_tag/allocinfo_ioctl_test.c          | 204 +++++++++++++++++=
-
> >   1 file changed, 203 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c b=
/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> > index cd9cf229ae1f..5d2f13900a47 100644
> > --- a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> > +++ b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> > @@ -311,11 +311,201 @@ static int test_function_filter(void)
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
> > +     bool found;
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
> > +             ksft_exit_skip("Failed to open " ALLOCINFO_PROC ": %s\n",=
 strerror(errno));
> > +             ret =3D KSFT_FAIL;
> > +             goto freemem;
> > +     }
> > +
> > +     do {
> > +             found =3D false;
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
> > +             if (get_filtered_procfs_entries(procfs_entries, &filter, =
fd)) {
> > +                     ksft_print_msg("Error retrieving entries from " A=
LLOCINFO_PROC "\n");
> > +                     ret =3D KSFT_FAIL;
> > +                     goto exit;
> > +             }
> > +
>
>
> As I mentioned for patch 5, the retry loop in test_size_filter calls
>
> get_filtered_procfs_entries() which reads fd to EOF via fdopen/fgets.
>
> If a module load triggers a retry, the second call to
> get_filtered_procfs_entries() gets EOF
>
> immediately.
>
> And Sashiko has also reported several minor issues.
>
>
> Thanks
>
> Best Regards
>
> Hao
>
Hi All,

Please note that I am moving the file descriptor definitions inside
each of the functions. That makes the code much cleaner and avoids the
weird scenarios related to using the same file descriptor everywhere.
I will include this change along with fixes for some of the other
issues Sashiko identified.

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
> > +                                     found =3D true;
> > +                                     break;
> > +                             }
> > +                     }
> > +
> > +                     if (found || tags->count < VEC_MAX_ENTRIES)
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
> > +     if (start_cont_id.id =3D=3D end_cont_id.id && !found) {
> > +             ksft_print_msg("Entry with function %s not found in IOCTL=
 results\n",
> > +                            target_function);
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
> > +     int fd;
> > +     struct allocinfo_tag_data_vec *tags =3D malloc(sizeof(*tags));
> > +     struct allocinfo_tag_data_vec *procfs_entries =3D malloc(sizeof(*=
procfs_entries));
> > +     struct allocinfo_filter filter;
> > +     enum ioctl_ret ioctl_status;
> > +     int ret =3D KSFT_PASS;
> > +     __u64 target_lineno, i;
> > +
> > +     if (!tags || !procfs_entries) {
> > +             ksft_print_msg("Memory allocation failed.\n");
> > +             ret =3D KSFT_FAIL;
> > +             goto freemem;
> > +     }
> > +
> > +     fd =3D open(ALLOCINFO_PROC, O_RDONLY);
> > +     if (fd < 0) {
> > +             ksft_exit_skip("Failed to open " ALLOCINFO_PROC ": %s\n",=
 strerror(errno));
> > +             ret =3D KSFT_FAIL;
> > +             goto freemem;
> > +     }
> > +
> > +     memset(&filter, 0, sizeof(filter));
> > +
> > +     if (get_filtered_procfs_entries(procfs_entries, &filter, fd)) {
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
> > +      * We depend on the result of procfs entries to create the ioctl_=
filter. Hence we
> > +      * cannot recycle the run_filter_test function here.
> > +      */
> > +     target_lineno =3D procfs_entries->tag[0].tag.lineno;
> > +
> > +     filter.mask |=3D ALLOCINFO_FILTER_MASK_LINENO;
> > +     filter.fields.lineno =3D target_lineno;
> > +
> > +     ioctl_status =3D get_filtered_ioctl_entries(tags, &filter, fd, 0)=
;
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
> >   int main(int argc, char *argv[])
> >   {
> >       int ret;
> >
> > -     ksft_set_plan(2);
> > +     ksft_set_plan(4);
> >
> >       ret =3D test_filename_filter();
> >       if (ret =3D=3D KSFT_SKIP)
> > @@ -329,5 +519,17 @@ int main(int argc, char *argv[])
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

