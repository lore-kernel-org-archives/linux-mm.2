Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AA0FCD98EC
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:18:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56A8D6B00E2; Tue, 16 Jun 2026 17:18:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F4B46B00ED; Tue, 16 Jun 2026 17:18:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E45F6B00F0; Tue, 16 Jun 2026 17:18:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F0CE36B00E2
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:18:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6C3F91C3AD8
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:18:01 +0000 (UTC)
X-FDA: 84887038362.03.4F68E9D
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6A322160015
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:17:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NITiAepb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781644679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IMviEuCDkBMrPwRjrS65z+u0zLyVMty1GBcioAfFiHY=;
	b=0f/ixOME+lrpKS2jpgDGWvBW3U4QY8gOmzRnOmKTsuMS8yQgFjNIkR9X45mUkGB4ruyk/K
	d5/eKvun6Rkvigqm6JNKrRLa2gWWtzCzEM+LrKBMbl3U6SwadvcrTr0T2I1gjzTv8ILyJY
	7WGPdMjiITdzpkDWVTaz9ZEOOOH9aiA=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NITiAepb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781644679;
	b=sf+iL2pbp1W0mc30/qeMw+3P8ycE2awuqhQGweBQ5j955XjuE4fb7iJPnlwl5hoWpgjBcR
	55wKIuMREqAB0HD9lEJEbx0HKYC0HDjjnsyVqYwtahNBPL/WQiL2V/P6re+7RDrVRCI34B
	+BrbjEJW/IyTd3QdGD9f/pO/76oPTN8=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-51765331535so37331cf.1
        for <linux-mm@kvack.org>; Tue, 16 Jun 2026 14:17:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781644678; cv=none;
        d=google.com; s=arc-20240605;
        b=bjFAZch9BU/ietIm55N56xudi5R7KvrKA6B+MGCNJJTQTvsnAv1T05Qb8kyna7CZUB
         bOQNqpVYOjy2FHSsaKHYnly788SnT5dteIFgrbVnTCCi1o6CzYCT+PrWR30uwFWYR9jO
         RqoQ2dC/PFrvot3AtLVoKbW30jlIbnSNL169fz60LOuUn+l5cvWOs+iFpMAotJnsT/7K
         uOWqIEKYMhK2K4sq7njzMmGjPhyXFEpI49kOwRlBNCEVX5uHvZD/cL1VOo5NNPklUpq8
         Lsf2ojbXJRNXGfosQZzfLaoR8ntlyI+YnB/iY9rxlQAICqHwFDRyZu8nbufMZxcq4Mh9
         SC1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IMviEuCDkBMrPwRjrS65z+u0zLyVMty1GBcioAfFiHY=;
        fh=bDJDmScj3pbp8B8TkDwKg6tVAGcXXJoUdja3HlTHGUE=;
        b=SsIEz8BzRkiuEUSjul73wdZbSWMBZuGqePHytUw1V3CIHogd6rZaH1rGW4Qo88LBHQ
         ZhdSXZwayR5NzF8VVmDNY1r125hRql64m6O6b+ouqdb1nHXlgwGMfS4bT1O3JR/tTHff
         xRSyFmB2NJoRjtqwJHCyPKVQUO34tmxVKf3mZzNLuI7W8FLMTG2iNPjK+fY5TXE01Uyh
         rqrTgSbujA1n1Ro27xqvq2WYt6L56QSpJRzR0sKcpxh0vkCslhxGJNroajtGO4KrRKet
         akLTolU2DuAd2uCZEvcGkrCGruox4FpjGx91DLsFtAGYCO3bua/DTXyhusa6CRhy+TOG
         LK4w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781644678; x=1782249478; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IMviEuCDkBMrPwRjrS65z+u0zLyVMty1GBcioAfFiHY=;
        b=NITiAepbwD9DJhX24PfOzC4Bdqgb3DdtEixnsN/52Jti2fs6x0EwynZIjtHoN8tb9w
         +59VSl9868Dg6zKiRaGwXxZWxARSLgn+36KWEkl9SH/Yqtv5xXhS3uIquFVbvD7E72bh
         Cs219S8aX1DjRAxGsuKnlxnHcZCo76ZShRsecezvaCULaoRtweZ0mHw7dd0csadxJaow
         TgYTsGx5YnSqm9BpIPGZGBcX8/BN/aBz6RmppGMki/Fk7BA/zO7Lha/JhMeqB7Oz8Qbf
         h8H7CYAKAcKVePOBVvaysX6a+gRX2RzxkiRVsBDJvesQ1fV9sKr+1qUeqSU5h04wnOnK
         1bmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781644678; x=1782249478;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IMviEuCDkBMrPwRjrS65z+u0zLyVMty1GBcioAfFiHY=;
        b=IssnUt2y6oAiObtRc7eUrOgU7PyrGStLeqPT4TZJDota7QhcLfTwMGSR3GlH3XNHp7
         4F7MEBlSJ7DC5oY5PUezY5hQf7oyyi4tZ6Kbqthby0a7mqqZNKhdcgdJ1Wa04o5dczXQ
         EvQS3u9Qkx8s85c0FkQTi5loJrOn50fUwA8rGGBqYjZRZeVa8Y4XNTURYoGVX9Zzj2aK
         8aB9nYRVS8oveQ4J8+LXJTA5pzWLNHgfRHYBEJo3QYLnxCEfRpgLEmq7eqfkMT/vAvRX
         SHkacmFLebV6PuUsqjvR51IZPCZ3RB3EHX1xZdEvWj5Mn1dnKQ3ArZ4e5f5BybKJO8iM
         07ig==
X-Forwarded-Encrypted: i=1; AFNElJ8mJ+uwmod3eRcmbxvyj3piNoxlAzvrV8Ulbp001NocnE6tE+X56g+6e6e3ba5eviNFKDOd9m1w1A==@kvack.org
X-Gm-Message-State: AOJu0YzpEs6Mv3JnGQ/e2tLNBdR2c2WR8T2X4NjeE4pekU2ueKbvDo/S
	4UBG0p6ZfsHlYTOV4BqKNiR4BWEQwXaZkXR00Ugj1/y3UlWif+iEgnHkFMMi4D1TSPyAgVzZHX6
	OPthfth6Cqp1wzBivcvNKKSAjwHLyoYItXJL8HlT810PrZnrlSz8EtJc1Nb4=
X-Gm-Gg: Acq92OGnj5lQM6nVKnqcwEl3e4f9wYq5wWpT+wftjV8FGL4H2YSVf5kKP5A5g8cKNvl
	genmCuuPZgArEd54IvPyfq+nmzO5F2udsC2fuNjfShs4pryfWqev+ropUZO0tscPqWY08K3i2x9
	+sKh2ulwHm6urY2LYlK3/Qsl2m0vAknzV/Shql6c5YXG6UTQ2+hmMvnGXFjfQcvlnKfzI7OLzzi
	TqBgcqgBUPUeze3o3u34vGswp41VzapBiwmx1hVlOR/Awn4eEmBMCtOBwI2uKJ97vSWwVmeCvgD
	CRrRpdQSXjIHwv42W/9uhe0EP1T6O1sSth2pF8sZPJAlS4qR
X-Received: by 2002:a17:903:4b47:b0:2ba:6518:e4d8 with SMTP id
 d9443c01a7336-2c69a30be19mr2222665ad.20.1781629021114; Tue, 16 Jun 2026
 09:57:01 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1781564384.git.abhishekbapat@google.com>
 <1a68864b1493528abed0e9e3489688fc6287c37e.1781564384.git.abhishekbapat@google.com>
 <8e554bce-bd66-4481-bc53-fa4cbaf0c0b9@linux.dev>
In-Reply-To: <8e554bce-bd66-4481-bc53-fa4cbaf0c0b9@linux.dev>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Tue, 16 Jun 2026 09:56:48 -0700
X-Gm-Features: AVVi8CdGEXAE7f78CwWc3jRhOwC0BnHsvEC3kawu3AF1rMOPeiKHwo4utET_39k
Message-ID: <CAL41Mv7By-q-dXwFbDzrqqWeCh-CR8UdPpmcgfdsUX+xNZsH_Q@mail.gmail.com>
Subject: Re: [PATCH v5 6/6] kselftest: alloc_tag: extend the allocinfo ioctl kselftest
To: Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Suren Baghdasaryan <surenb@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Kent Overstreet <kent.overstreet@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: g5ehstd4cgng114f4ebx8d56e8w5enbi
X-Rspamd-Queue-Id: 6A322160015
X-HE-Tag: 1781644679-638336
X-HE-Meta: U2FsdGVkX1+vRYmTnQR9VdoEeiQ4PrGQjiGsjETgn5F+KPoLoFkJiKQXEsSZqakzcjoOa+l4KkqrvrVAOWlQ993kuWLNJBP71OZ8XPUbyJmYBq0nKWm+HHFXbFxkpScQt+Q4HwHACbEIKWfkTx2sM/W3ImfVb7a/imVhAqgzZhMBWUyJpBsJNJ6f2L7agUQLp3DJhSUgJAVd1ZHF9Bb6GPkAS27kToOkGFQPQ17oF9irFzT26JM3ckfSW9d7EFLO9qV2EC7zWRWlnxh+nArxLUX6BMjShBoHOorjSIcAL++EFOEYYSfe/F72VhD1e0oYPFkSdP5Uxk1qQ0hnHlarXduo0EL7pKl5dZCotfSsszY6jymNP2e3K/iB5dthQEsNumc5TKpPyl8uOOANYAhvRmsyi9/JpixU+fPSTgt911TbDNwSNSNixYCvtEGoKKGxvY8RC4NXTDKD/oC8mAob6MPpd4xEOppJSoPPRMAWLCT3/bDD9COi41ob2l5ga7QrgJqaaEvo7+CuaP9NyroiyuMkElD6MxYKUpnJZFQpqevWe1jEcs0S2LLxiI/ti3dAylMW6m2KchhkDKmHqkMr2RGUeOxsZoq6bIswbaS3fkMOGMzaPvZ0c4TEnQ4OsSwNT6smWc3t98LKIgrCsvMzpzeDojrvsb4ZquJzpJeaXUSoJjjabWGLB8A3/yz6eqsfaZaG5vgBILgvU24wyaA/nfJ29PVYVU85HeRvTLsZa3v4xut4VaN/7jkKV8TZygyGLf6/c2oD7PbRcZsG5jUb2fe0Lf7fNKpsRYgXkGv/0d6RrOFO116JElkrU/GNXrtjhSuT6n2uvhVHObG5w8WTFbYaJoreq0fEL647uKYHwjMD9FlmD+W2EMSAtZbeRAVeAKVL5KS0MSlmYFUBjvkPy6umjxf74fQkd+pd2BikUrmDq9vKT0kC3xnVOkFbaJIFXZyy8tQ1WPOLvE2Uaxv
 LKQCs8I1
 eUleMkCkpI/0jOP7juzb/acSKjSFicG1YQVUF5JxGPmzrTK2K2UlaveGbihapl0Q5P7Fm3ByGvWFz/OkUyNwDdUojwUoD3QrYwBfqOIDmS7VEJQUQLJETg/tzAsFfm8Bj6c7ePNbs6G94KxvkANYrBMNEOc0/hhmlfezKdRsl4UFYbJj1FLIxZSxkS94dXjk+/pARfJj4TFljHMSRcmEAqBFcEu8vRWPkKjlSVVP2GJOIELbcDZyIgEoGYAB+8e006PtTZVz/hlm4brP2wH3ev/1BR/JApNDItSQ1rM/WtKg/3S3odNneINWtecLEyIuyHF6ubhXWH6HxIbwrcWiKR3lc3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 15, 2026 at 11:19=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Abhishek
>
>
> On 2026/6/16 07:04, Abhishek Bapat wrote:
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
> >   .../alloc_tag/allocinfo_ioctl_test.c          | 197 +++++++++++++++++=
-
> >   1 file changed, 196 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c b=
/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> > index 62d5a488a04d..041fee1a3d74 100644
> > --- a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> > +++ b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> > @@ -309,11 +309,194 @@ static int test_function_filter(void)
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
> > +             ksft_print_msg("Failed to open " ALLOCINFO_PROC ": %s\n",=
 strerror(errno));
>
>
> I see. The #include <errno.h> you added in patch 5 is meant for this
> spot, right?
>
> If that's the case, I'd prefer moving the #include <errno.h>
>
> addition into this patch, though this is a trivial detail either way.
>
>
> Thanks
>
> Best Regards
>
> Hao
>
>
Ack, will do.
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
> > +     } else if (start_cont_id.id !=3D end_cont_id.id) {
> > +             ksft_print_msg("Failed to match content_ids for procfs an=
d IOCTL, skipping...\n");
> > +             ret =3D KSFT_SKIP;
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
> > +      * We depend on the result of procfs entries to create the ioctl_=
filter. Hence we
> > +      * cannot recycle the run_filter_test function here.
> > +      */
> > +     target_lineno =3D procfs_entries->tag[0].tag.lineno;
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
> > @@ -327,5 +510,17 @@ int main(int argc, char *argv[])
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

