Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2107ACD98F2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 16:29:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6E7F6B0005; Wed, 17 Jun 2026 12:29:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1EFB6B0088; Wed, 17 Jun 2026 12:29:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0F006B008C; Wed, 17 Jun 2026 12:29:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7F9FF6B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:29:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 07BE3A04CA
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 16:29:31 +0000 (UTC)
X-FDA: 84889940184.29.7E85026
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf27.hostedemail.com (Postfix) with ESMTP id E0F654000B
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 16:29:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Tqa50QAL;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781713769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j3ViCNINWU1ApHw0TpbKMpVstUJu6vw+UuDtJWe3ZJE=;
	b=1YtO2/6rDZwQV9Rfw/Ugjd0r+XCafq/nwCjn+mAGBdBcbPi+2nZndhOECNMyH4MGKn/m06
	v/ndyIRfw0YMdg6A38CUbySqW3l+7b08eIA2uPOmhXxlQoQJu0oSLlK9YaiNqWvXO6Snp2
	uf2ukRv0bqZZAgRUeBpKS+01luJZOo0=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Tqa50QAL;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781713769;
	b=MkXMyTFh4K3gj7MaCl+pmzy950GK5SzMliIcXkdyBYyxSTQbVI1gUiqOkXf6h7BAWyxUjU
	3iahFT3JNK5OT56sd2UVeOS2U1pa5iwraH7hMTnF5MFidEaCQsgLFFfK1X53tWSM3amFHf
	bcKQ53m4GGFK3H+q3Ufh4LDm92QyeVc=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-51765531803so353231cf.0
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:29:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781713769; cv=none;
        d=google.com; s=arc-20240605;
        b=Wn3ik8FcD5yIEPSgHC9Ahas4yDeshRmFS+FAY6w8JnmCNUbuRr0cTHePyBrIB3mWYy
         DpTFRNjK6+FSsc2bOf7kWZ6cm8wYOc/1hq8IeSaURMfrNvLiHh1qwcwhqg4Z088TAwMd
         D9hUNmDx0fRBTou8kFdDpxJOmAXgMf862PE6i9uoItwm5On5rJtCGsCFDAITuMI/8ud4
         zNL0QqKtKA/x7ncJBLlkTs/RsdQ0NR+iBxMeVZP1sfEFlTv9SadG39dKkLX4wdT3ZwZk
         hAyLDblqGkHKEY/o3vHbJyraqh3RKCOvZ6ZHIXpDcfjcaXkg7VbqD3QtHsqfynaizFW3
         phBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=j3ViCNINWU1ApHw0TpbKMpVstUJu6vw+UuDtJWe3ZJE=;
        fh=FXZ38PVK6OXHrJf4JwfjWFw5hsXkYIWjeFvG49yySXo=;
        b=eNLbXlpiBMr6BfSa5FmmbA2XHPgjugxhIWEU0Fm2HWrK6CameWRMFVEvQYEYy+LBFj
         UmEH/dyr/swKac9OTBRJRVgzjWs85f+Ad9nDjIyX5dJDvh5yuBlIqDznM+SQx79qBmXB
         vJ4yjRD0FC1+/oMEZop/58hN5dKgrNj08qmR95oHsBWKHUctW0j0Lx5qqcbrsCzoH30c
         ThMs/uIrhjHic1F7QRQQ5rRsHLaoO60hrtEy5KX5eubkZZVnyE28BgRtmdILyNVHQZh8
         4QkUowhfyFMgYuMp30l6EJTV3lZ1GXg73AqBxQOmdpb/2HCu8gbIOG40ZQRTjRxBk9/Q
         HaNw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781713769; x=1782318569; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=j3ViCNINWU1ApHw0TpbKMpVstUJu6vw+UuDtJWe3ZJE=;
        b=Tqa50QALqLKxP1eqGOr5RNwmOPamg7JJIIqi7tryr5+MAjobi+n5iu08JF/G4oHmK1
         +tEmB3Ozn/R1QkPhnEatTTVgQ1NZIPlhkwGsjC1RmP1yKkVwYIxg0/V5SkWLA+CKtTCP
         j9mqZhP4i3/xFdN0opdRYXp1vxiMsrRbzM7B8/6cTqRRnOWVxRwbVi7o9u+QFan5N18U
         6AXz2dqbevc85Peo0HqCdCvDPnt4GFMSTAXu2YTwqnTjk/bq9jnioz5Huv+FNi2HkZpA
         mzLJmNZHNm8OGw32Sit+VUE25AqSIbct9mNK4dl5XUol8EeRwzC1Z/drbUlbCUnfTrae
         H4zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781713769; x=1782318569;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j3ViCNINWU1ApHw0TpbKMpVstUJu6vw+UuDtJWe3ZJE=;
        b=JydVmxiX71T4B/skoWY3yGubahr/4X0RhLrwHL3OXwYrkGtRawlw093KBqbsOcaU0o
         U3Ky48Q7YWbf5UEAR9efg8JB49LgOcKYnd/VDosEhPXsiYkz0cElYLUrqgK6Lz8cHvpo
         iIgXGGk6UvOYmR1u3iCi3c8YkQrkelSJGhX64xoK0HuG/+Gu3sZ8zalrlPRM5HX1nD65
         /xJ5ZUA/UjysPdVU8Uo8KG2E1NzC6p8reHDK8fmiMxIez7V9jmIp0j9GFEK5CTKeXYdQ
         /iBK7GSKi/ZCbcIBp+SbR5F1yiI8YK459C1zuWx2Rp44jvxT/ZC1gkKt0usGotZ35f/g
         S/YQ==
X-Forwarded-Encrypted: i=1; AFNElJ9K37SQs18c8AqEA08NoRYIpPT5RnTrIe+Nl+qsgdSRAF7CNzPCd7rHsC7lFm5yXAAZDc17LYXb/A==@kvack.org
X-Gm-Message-State: AOJu0YxUMONweHIYGbKEvWJiKOqBoR+IaX4ziL0TYOhRJZC/R9qyAL2a
	pgT4nr0tDQqCxRdya9c1mPmqe8jr04t9F4AGQaEVDGU3HeJYuMoJZZCHrvwF/HwP1aL0Sh8iGeq
	3w/dyZTkPNcPmg5B1AXlv8rm45FVuUc7MBtfHvkyk7O4lwB9ZvwcH1K8v3fE=
X-Gm-Gg: Acq92OEZL47ggQiR0ZrkarprwvR3blMgfVqsOfWIMNFHtECbgqiLYsEiDlUGqGH92Rv
	OaqZ1qwsjTvBEyDyjMZfBucIzKZVh5mF3gxSBLw/UVux546q2Bkk/L4vzTmgTufvSluHAKzmfh+
	4KiossQlPtMBg84T0ao7HvJwxR/JHaJhInxdh02GISlIKkTFzxIxiSjfS3SGtaGLVlspgROUDkF
	0nFT+W6yTDaCz7f8MeCwLtrWkbFwuTco9VJ5wZMtk3OB1xPXeQHhh/W1qnM1YEAnVC69hru1SfR
	yjvxLONRWlhrJeiLLNpIL4vrId0=
X-Received: by 2002:ac8:59d4:0:b0:50f:b69a:f4a8 with SMTP id
 d75a77b69052e-519ad98f5c4mr9857921cf.7.1781713768155; Wed, 17 Jun 2026
 09:29:28 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1781564384.git.abhishekbapat@google.com> <7d98db60ab0fddab230b1a7a32140f3361ab42cf.1781564384.git.abhishekbapat@google.com>
In-Reply-To: <7d98db60ab0fddab230b1a7a32140f3361ab42cf.1781564384.git.abhishekbapat@google.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 17 Jun 2026 09:29:16 -0700
X-Gm-Features: AVVi8CeKwui872F-kOLXNptMWCgfxo-c2VZxjkZFlkeHAc29MMPClekmD4MDk_Y
Message-ID: <CAJuCfpFbCKc7FR3tbeCzexCzyfiP+Ab2fJ7Vd1Q76MKTvqC2XA@mail.gmail.com>
Subject: Re: [PATCH v5 3/6] alloc_tag: add size-based filtering to ioctl
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Hao Ge <hao.ge@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E0F654000B
X-Stat-Signature: 4fk68awgzo5yb7qwty4kg3sbpqtuazor
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781713769-255666
X-HE-Meta: U2FsdGVkX1/A30H1HLvAb/VHroMe/8rPxOJPlUGOZCSMEgIPb/Ynb0fv8mT1+gOOw30ZPZVb68WIGB9TkjGQZemOWXLbXdPORqX54Jr1STz2ZVwF1+RcopclF7sicwPNoen7FgGaniG8+Rv3B0z8BtjSqYVvxGJRCFKTkDj0ql/HQc/zp+R1xAKclaRPhpZ/dZoJt5gktfHQ1k+QCqy2ZuxuZumN6gB19VT4uZPS9BVIvidE6nh140XGK/rWEmUCkv4+/NMra+dW0McQTdyrbZNTMILq/5pk/97ZW79pDeE/flmaFqYektH4FhHIH2yHaHP81TNARv9msTiRB76iN/K7OYdFbDDGyPfe7M8mcWGiIeny2YezNncCrRqar5rfjEURbJrNebu5tiV/fkS8ExcCRh7+Ot1aldtJQf2kvpgUUED69cmfiX5Bv0Nw9oj8zCwnYFF3oUiawjJ2p7iZ7EQwXWJ4Kyk31yZn0k5RyLTQ/i9sJrSFLAevuRBW3Z2xTEV+Le0tZ1lwY4iwryVrm9qiHiFIDDiPZA+avmlTYOF4tG0hQpq9zCjX16BNm+DddVnYtcGSIVk+XpMsC/UH9FaympkmC6XU3PEXWylP8N29A/GXYdHtA09ceOCENQ2ZGuByygGNH0CYGLNtCYxym91T2c2M1gdAGYILc2ZSIcxaJQ6O3bqWb+ixDktI7NHohL3NX6DJssIuW0MUKoTwKEDpqo15NzqpC30kGAF0j4W7OHAJYqSSdonXvVMni6GwrXI1AIOmV9chPzRW3WbbKtOpkUxesSJNmSKI+5qZfnbdobxY8coilv1lhE5CnEdzlt85R1qr9ezNK/Eu3d9s54wg4hqC5jOsf0VrhfcVMytPcXcZMuuJp8JTmlQyNRugIckes/IeK6WgpvncQyOP/Ll12SueaeKwuTOl7HpptdMuBdzSEM6a4kBDgIAiBV9ADigf4TW8lutoBN2QBBG
 sYfogjWU
 H/2bAO4tiMVb/4TBf1wl39iTv8rhhHK1/poOCy6RjwbYdLIkn+PPyj+1WAi4QuUw4pUreGLMKZiFlvsK2wH4s5V+rJD9yb4abRWZfVXBU/ELT1Tl+/Rbi51ApyVVSUcC4AmX7nij6PYSyPwuXtP2lEdFMYUG8pMwZuek5XLcEMSEMAatiNHYdAIioA+CddaTw1crCKMZ1EF6oqv3Pho24qnwp/rJDpMhKgcGEIuxv3Y7jQOJIriWvjZ40K4sINmS0RVpiqZbG95jZk8wJeS6laKScgkmgJ1w9fZWfU8neoF3SVSKcXm6+EldyJX/Af2Rmhk8vaTntqGxEiD9ewRSL7Os9uw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 15, 2026 at 4:04=E2=80=AFPM Abhishek Bapat <abhishekbapat@googl=
e.com> wrote:
>
> Extend the allocinfo filtering mechanism to allow users to filter tags
> based on the total number of bytes allocated [min_size, max_size]. The
> size range is inclusive.
>
> Filtering by size involves retrieving allocinfo per-CPU counters, which
> is an expensive operation. Hence, the performance of size-based
> filtering will be worse than other filters.
>
> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> Acked-by: Hao Ge <hao.ge@linux.dev>
> ---
>  include/uapi/linux/alloc_tag.h |  8 ++++-
>  lib/alloc_tag.c                | 63 ++++++++++++++++++++++++++++------
>  2 files changed, 59 insertions(+), 12 deletions(-)
>
> diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_ta=
g.h
> index 3b11877955b9..7f5acbb44c14 100644
> --- a/include/uapi/linux/alloc_tag.h
> +++ b/include/uapi/linux/alloc_tag.h
> @@ -45,13 +45,17 @@ enum {
>         ALLOCINFO_FILTER_FUNCTION,
>         ALLOCINFO_FILTER_FILENAME,
>         ALLOCINFO_FILTER_LINENO,
> -       __ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_LINENO
> +       ALLOCINFO_FILTER_MIN_SIZE,
> +       ALLOCINFO_FILTER_MAX_SIZE,
> +       __ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_MAX_SIZE
>  };
>
>  #define ALLOCINFO_FILTER_MASK_MODNAME          (1 << ALLOCINFO_FILTER_MO=
DNAME)
>  #define ALLOCINFO_FILTER_MASK_FUNCTION         (1 << ALLOCINFO_FILTER_FU=
NCTION)
>  #define ALLOCINFO_FILTER_MASK_FILENAME         (1 << ALLOCINFO_FILTER_FI=
LENAME)
>  #define ALLOCINFO_FILTER_MASK_LINENO           (1 << ALLOCINFO_FILTER_LI=
NENO)
> +#define ALLOCINFO_FILTER_MASK_MIN_SIZE         (1 << ALLOCINFO_FILTER_MI=
N_SIZE)
> +#define ALLOCINFO_FILTER_MASK_MAX_SIZE         (1 << ALLOCINFO_FILTER_MA=
X_SIZE)
>
>  #define ALLOCINFO_FILTER_MASKS \
>         ((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)
> @@ -59,6 +63,8 @@ enum {
>  struct allocinfo_filter {
>         __u64 mask; /* bitmask of the filter fields used */
>         struct allocinfo_tag fields;
> +       __u64 min_size;
> +       __u64 max_size;
>  };
>
>  struct allocinfo_get_at {
> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> index 5feb61d9fb92..b3d21834b61e 100644
> --- a/lib/alloc_tag.c
> +++ b/lib/alloc_tag.c
> @@ -195,15 +195,26 @@ static int allocinfo_cmp_str(const char *str, const=
 char *template)
>         return strncmp(allocinfo_str(str), template, ALLOCINFO_STR_SIZE);
>  }
>
> +/* Fetch the per-CPU counters */
> +static inline struct alloc_tag_counters allocinfo_prefetch_counters(stru=
ct codetag *ct)
> +{
> +       return alloc_tag_read(ct_to_alloc_tag(ct));
> +}
> +
>  /*
>   * Populates the UAPI allocinfo_tag_data structure with active runtime
>   * profiling counters extracted from the given kernel codetag.
>   */
>  static void allocinfo_to_params(struct codetag *ct,
> -                               struct allocinfo_tag_data *data)
> +                               struct allocinfo_tag_data *data,
> +                               struct alloc_tag_counters *counters)
>  {
> -       struct alloc_tag *tag =3D ct_to_alloc_tag(ct);
> -       struct alloc_tag_counters counter =3D alloc_tag_read(tag);
> +       struct alloc_tag_counters local_counters;
> +
> +       if (!counters) {
> +               local_counters =3D allocinfo_prefetch_counters(ct);
> +               counters =3D &local_counters;
> +       }
>
>         if (ct->modname)
>                 allocinfo_copy_str(data->tag.modname, ct->modname);
> @@ -212,9 +223,9 @@ static void allocinfo_to_params(struct codetag *ct,
>         allocinfo_copy_str(data->tag.function, ct->function);
>         allocinfo_copy_str(data->tag.filename, ct->filename);
>         data->tag.lineno =3D ct->lineno;
> -       data->counter.bytes =3D counter.bytes;
> -       data->counter.calls =3D counter.calls;
> -       data->counter.accurate =3D !alloc_tag_is_inaccurate(tag);
> +       data->counter.bytes =3D counters->bytes;
> +       data->counter.calls =3D counters->calls;
> +       data->counter.accurate =3D !alloc_tag_is_inaccurate(ct_to_alloc_t=
ag(ct));
>  }
>
>  /*
> @@ -238,7 +249,9 @@ static int allocinfo_ioctl_get_content_id(struct seq_=
file *m, void __user *arg)
>   * Verifies whether a given codetag satisfies the active filtering crite=
ria by
>   * matching its characteristics against the specified filter.
>   */
> -static bool matches_filter(struct codetag *ct, struct allocinfo_filter *=
filter)
> +static bool matches_filter(struct codetag *ct, struct allocinfo_filter *=
filter,
> +                          struct alloc_tag_counters *counters,
> +                          bool *fetched_counters)
>  {
>         if (!filter || !filter->mask)
>                 return true;
> @@ -265,6 +278,19 @@ static bool matches_filter(struct codetag *ct, struc=
t allocinfo_filter *filter)
>             ct->lineno !=3D filter->fields.lineno)
>                 return false;
>
> +       if (filter->mask & (ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLOCINFO_FI=
LTER_MASK_MAX_SIZE)) {
> +               if (!*fetched_counters) {
> +                       *counters =3D allocinfo_prefetch_counters(ct);
> +                       *fetched_counters =3D true;
> +               }
> +               if ((filter->mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
> +                   counters->bytes < filter->min_size)
> +                       return false;
> +               if ((filter->mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
> +                   counters->bytes > filter->max_size)
> +                       return false;
> +       }
> +
>         return true;
>  }
>
> @@ -278,6 +304,8 @@ static int allocinfo_ioctl_get_at(struct seq_file *m,=
 void __user *arg)
>         struct codetag *ct;
>         struct allocinfo_get_at params =3D {0};
>         __u64 skip_count;
> +       struct alloc_tag_counters counters;
> +       bool fetched_counters;
>
>         if (copy_from_user(&params, arg, sizeof(params)))
>                 return -EFAULT;
> @@ -285,6 +313,11 @@ static int allocinfo_ioctl_get_at(struct seq_file *m=
, void __user *arg)
>         if (params.filter.mask & ~ALLOCINFO_FILTER_MASKS)
>                 return -EINVAL;
>
> +       if ((params.filter.mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
> +           (params.filter.mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
> +           params.filter.min_size > params.filter.max_size)
> +               return -EINVAL;
> +
>         priv =3D m->private;
>
>         mutex_lock(&priv->ioctl_lock);
> @@ -308,7 +341,8 @@ static int allocinfo_ioctl_get_at(struct seq_file *m,=
 void __user *arg)
>         ct =3D codetag_next_ct(&priv->ioctl_iter);
>
>         while (ct) {
> -               if (matches_filter(ct, &priv->filter)) {
> +               fetched_counters =3D false;
> +               if (matches_filter(ct, &priv->filter, &counters, &fetched=
_counters)) {

Do we really need this "fetched_counters" parameter? Here are the
possible cases:
1. If the filter does not include ALLOCINFO_FILTER_MASK_MIN_SIZE |
ALLOCINFO_FILTER_MASK_MAX_SIZE then counters would not be fetched.
2. If the filter includes ALLOCINFO_FILTER_MASK_MIN_SIZE |
ALLOCINFO_FILTER_MASK_MAX_SIZE and
2.1. matches_filter() returns true then we know counters were fetched
because they had to be validated.
2.2. matches_filter() returns false then we don't care if the counters
were fetched. We do not report that tag anyway.

So, instead of passing fetched_counters to matches_filter() we could do thi=
s:

bool filter_by_size =3D (params.filter.mask &
(ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLOCINFO_FILTER_MASK_MAX_SIZE)) !=3D
0;
while (ct) {
           if (matches_filter(ct, &priv->filter, &counters)) {
...
}
if (ct) {
           allocinfo_to_params(ct, &params.data, filter_by_size ?
&counters : NULL);
...
}

Wouldn't that work?

>                         if (skip_count =3D=3D 0)
>                                 break;
>                         skip_count--;
> @@ -317,7 +351,7 @@ static int allocinfo_ioctl_get_at(struct seq_file *m,=
 void __user *arg)
>         }
>
>         if (ct) {
> -               allocinfo_to_params(ct, &params.data);
> +               allocinfo_to_params(ct, &params.data, fetched_counters ? =
&counters : NULL);
>                 priv->positioned =3D true;
>         }
>
> @@ -343,6 +377,8 @@ static int allocinfo_ioctl_get_next(struct seq_file *=
m, void __user *arg)
>         struct codetag *ct;
>         struct allocinfo_tag_data params;
>         int ret =3D 0;
> +       struct alloc_tag_counters counters;
> +       bool fetched_counters;
>
>         memset(&params, 0, sizeof(params));
>         priv =3D m->private;
> @@ -356,10 +392,15 @@ static int allocinfo_ioctl_get_next(struct seq_file=
 *m, void __user *arg)
>         }
>
>         ct =3D codetag_next_ct(&priv->ioctl_iter);
> -       while (ct && !matches_filter(ct, &priv->filter))
> +       while (ct) {
> +               fetched_counters =3D false;
> +               if (matches_filter(ct, &priv->filter, &counters, &fetched=
_counters))
> +                       break;
>                 ct =3D codetag_next_ct(&priv->ioctl_iter);
> +       }
> +
>         if (ct)
> -               allocinfo_to_params(ct, &params);
> +               allocinfo_to_params(ct, &params, fetched_counters ? &coun=
ters : NULL);
>
>         if (!ct) {
>                 priv->positioned =3D false;
> --
> 2.54.0.1136.gdb2ca164c4-goog
>

