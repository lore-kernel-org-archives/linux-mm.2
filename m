Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4545FCD4F26
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 02:31:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AB456B0005; Sat, 20 Jun 2026 22:30:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 883106B008A; Sat, 20 Jun 2026 22:30:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7723B6B008C; Sat, 20 Jun 2026 22:30:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4B8046B0005
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 22:30:49 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B78811A02C3
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 02:30:48 +0000 (UTC)
X-FDA: 84902341776.18.BCD5543
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf11.hostedemail.com (Postfix) with ESMTP id BB41F40018
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 02:30:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hOZ7PcEg;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782009046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I7YVuvXThm0toGAM/4mpv9e/nJVFM7CnaeXRQvob9Js=;
	b=thye8izulhpRCXHSNj628a3bx9cKwH/Z9pwI6fmFAuruRJdqQB++QpffKWoKuSaAOzET5s
	O5gRGpcUuEi7LNmaNXH/76WHKDObinsBXnN1+9gD9BqcB3/VQA7qTgJgyQtwOVCGP4MSe0
	wofrt2heddj+RVgkgO/2Va6sH8ADbzQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782009046;
	b=eLAHu9+3ukS7CtJCvIRhQhCMdB8VVa/9UlYkoJKNZ3Sy/4r/N6HIsSvNUFFMOnpF2mDZKF
	8XSZkz4uldZ93MnNdn56RWM5EojQ1tpwQ+M7c2IsOMZzXiVdoQct98OSel7L8hEwuZ1+m7
	aFxHMg+Y5MYkGTTw1x0FUIwQJWnm38I=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hOZ7PcEg;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-51765331535so376581cf.1
        for <linux-mm@kvack.org>; Sat, 20 Jun 2026 19:30:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782009046; cv=none;
        d=google.com; s=arc-20260327;
        b=Be0d0qirFHyJ/HmVNhEK0jWcUgnymnU7J+s0UWWgGFXIct1ncQ7JbCS/6WNDF9wimE
         Kf+F3SihJc1s3TXi0vZDlxm39rcJfBDSTpJX3L8bYhoUkH3aLh0JhSljmh584oGJW6jo
         Xw+aQ2dNaDB9w6dw7QW517LxoJtKYPju2W+oV/uDkpA1oG7YvyHAorcdVx2vzL2y5oao
         GzUBS6xrAI/xU3U494r/o0JG+SomjYe6zEmFmuC4Rtac6zJgRldO4uTOzEzjWWCgXaIu
         ia97AV/ANzeRU89M58uVKldKMkBXylc5XdZMkRSfMsRl4JqoaXiAos7o+9EwQi9rSSv/
         igJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=I7YVuvXThm0toGAM/4mpv9e/nJVFM7CnaeXRQvob9Js=;
        fh=Gw8vbWuKD98OaznkAM8dDa83F+dHkDjteRavURri8pk=;
        b=p9cdTVqsddwqzQYiBwOSyKwOCKWxYJ4t36oNJdwv1+TT8G5ixv7RPsOVWvbqvmYiTd
         TCrI6/19lWAHhGoEhMfBaxZEplGc3Q83prZp+5S1We81SgZhxQFYx29ayrOV4395AtcG
         HIHnC0H3gxNH4Am/S6Nz/pAkhXM7IThxzqLpADV8h3omb1F3JaacQ7pbIdzSM/C931oR
         M17v6ERWqOs1qE5zq5a3UpCZD76Fz0OBnfZ7aLyO/r4SfqKuNuXqMoWP6mtGSuhijy9m
         Mbd445uaZY98v1kUR2jvV/wj48NwrUk0EYJaq44kElneksX3KP3Y+uwgc+QJJz7HYuDL
         DQbg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782009046; x=1782613846; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=I7YVuvXThm0toGAM/4mpv9e/nJVFM7CnaeXRQvob9Js=;
        b=hOZ7PcEgvdJvhG3btUXGT8OcCXWrENtkZo96snkzQuI8mAmT790kuXKS5h7dSnv7Ya
         BJ8/r2dL3p6EwIv1UmpvUr4BlCW8jqVGDTKn53m3ExUkS/gZfQIfyirVPVVWDAwi6Vpx
         4M00wlU283II3RlZDlJywIofJeRKLimGfV9yZswv3AV4xe7WWLRMaixMgBUu6HXXEPkf
         t228FgMYfBKgz9eh1zGJnZfbn0dp7Kj69cLgsWsu+jazaKRh70fbpXOMMS8xpmiKorBv
         epRH87JdhIp5RMtnhYZaMp5U+q5sP4w6Yr4kl+Zz+DFtKanj6lzYqtP98sJ578L+IwNm
         UlnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782009046; x=1782613846;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I7YVuvXThm0toGAM/4mpv9e/nJVFM7CnaeXRQvob9Js=;
        b=KBp2uQAxmHOf97Bpr8E6atvaX5x3/rPwHVFMEAwgUm6l0DubTbxNWX4x04efqqZjPD
         TJJ/CFeektggWe/HLzMPO+K678i7H8ZUC0ZVA1nUyj6pfIhJCPi6ycKU88yY/TrnRDGq
         udTM4xCRt1jaNQVZB5XZv68I/Wb7VbPXf2O4p1f1D6f+qrqI6lH4ZGjCF2FU6WHDHokS
         5GPzBgC4Bg1KCFwp6SpGrnK1bclzw/ML7eqizA28/lJ9Jk9zy4idyyqq+KtLa3DN6mOe
         Cx45hVfn/FWOFlPQYvX4FfE8fx5HcoMBbdg4cToNzDtlBsJLAHESEaonthnWWorVlITA
         O7Rw==
X-Forwarded-Encrypted: i=1; AFNElJ/3bHBbW77WiAlKvU6pX3yTSsDtlIlMyexP5vlG/8YIQkM1ONgH2jc7ybO/z9ORlO/A1fFzNN+MiA==@kvack.org
X-Gm-Message-State: AOJu0YxqslMgcTjmAp7bUIH1wnPXPDuN9M3XB7Qc5lw9aARdddFdvBKq
	BB/VGtkDB5XKn6qIlWM9g/HTyCXoAi9+d3inl7HlTKm2XvvxyI2O7XeZ4/vK2yn+2eXUwLdnsQ3
	TAH9dmSYvedd9QASn5lJzXpaqarPwyxdHi6U8wYkmN0bqM/B2YPNhJWN8fUc=
X-Gm-Gg: AfdE7cm+qCOAGFSOqHVbFc896o/KLzrkSjkkQRynv4+Jpi/FC3fKGQM91vpITYobxUZ
	uHgH5W8Tk4EGz5lLmLkkmxvp8qOzws4DISLki9b9VHvuIa2BQD4qih+VoP3L8uVp9zpfs5M2IKj
	7fSjQPNXTY29Tznu16eDVyS2ySrg+ZrKPTndOKexJRs/E5G7VKlRKiyA+xUvlZjPwgAlcHU5+oN
	rtYxzFplv0h6bpehi5i55CrM0KAsBv0/IacC8UgtCcJaaRYlC/IxxRnICESrsgb39kmpjI=
X-Received: by 2002:a05:622a:11c5:b0:516:ccc0:ee38 with SMTP id
 d75a77b69052e-519e891bc2bmr13237071cf.9.1782000029589; Sat, 20 Jun 2026
 17:00:29 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1781803482.git.abhishekbapat@google.com> <6944ab65167d8884ce0d856184730d06ead68cb5.1781803482.git.abhishekbapat@google.com>
In-Reply-To: <6944ab65167d8884ce0d856184730d06ead68cb5.1781803482.git.abhishekbapat@google.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 20 Jun 2026 17:00:18 -0700
X-Gm-Features: AVVi8CfHs4Muf6EinscyLyhahIerAJ8Wq3Zw_M8pDgJhxRBeKg_Tis_5NswmYtw
Message-ID: <CAJuCfpGCdHc8br0fdGw4cQYgXGCCsCuTkVF_19QWzmV8bSVuhA@mail.gmail.com>
Subject: Re: [PATCH v6 3/6] alloc_tag: add size-based filtering to ioctl
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Hao Ge <hao.ge@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BB41F40018
X-Rspam-User: 
X-Stat-Signature: iu4wnuuaj5grcjsdo4775odjhq7d45w9
X-HE-Tag: 1782009046-891178
X-HE-Meta: U2FsdGVkX1+D4y2hZpGU2StaBHpWefBA3DnZUG69iccXci1B/dyFu4bgQYkjdHAN8o6HAXLlswXCR6JRvpLl6bFqVTr3SmCe15IOn8etLDS6+8MGwUAyzZUvKbpfGl8cR+96GS9D6N82k8eLAHO8XlJcZVWc+aICby1OjaqP8pjqQe8jfq8RxTQdJ33GF2MExn1nUCbtX/2uQ2DtRLtF+S0m0Xw4mrpkpm+JQn2Tu40uDzNqNMwzbgpLDen8D9aJ/THu3SA8TlS+I58LCtZJfzps5loxm6dZ7uhqeb1nUlVUzScBPZeE2Df5BTmLils4AnPywydeZuxxfrMnWn+79dqg6Dm0lKnOi6WdM0TVOZ4ZfSmw1KkW5fbGOBBA6+xWUdfsThS8biuUWLIjhKOTLLxoRNa+2jhEsxHzF9P+ACY/lq/uSw82wOQOTFbys6yvLoS5mYMBgLVhmBDVDYctKlScPraMHNAX40tubQzvPDpLgkWEPb0CvoBd3/1BSlxaJ/AOwTwb5pcUyiUUgCZnsdz2SaHResTqxx9hC9aRcihyI2oFYfjxYsDxIZc7A3llrdfdgrkRjJA7aJP4QUVhXF1tn9jl/RX6DOyLAmpuqpChvqmVobrabTdQSMvHc+FerhMTfVwhEk5vfmm0FFhmyEic6lrkGrQx6bmzR7mtwO2679kiyMFcPtjxGDWlKzL+kmDq7AXCUzXqYjp4XIZY6Z8LRNFMI6GVeeuxqitaCoIxEcPKEwXQreyEooXLraEXMNx8VCR6XRzSm/Ul4yNQRyP+WiP5Rw96DUjPKcedgMw0QXj0/U6tpyS+XldBvAxcD7QK9GQTKmwDpdRysNEUQcIbN1E0NJt91zAHVKLIlz+U80fsvV9Ov+806vJ1kDGO5o/6t5Wmk2mWLasLmr30vyEB7ffAOWdW6LWA9+WGXN+mQ4cc0Mp9NIlxsfpaY2k8lWdIONDTfhoxwkPkfUo
 XcKuXky3
 dlkq7WVrrcvMp/WWba5wqW2LcgQIAH/l1hCdbeaNJTc/XQehyht/PuHJRQI9A+HNQxHZAyx8Su1GBVJRSHs6r7Etykcyjkd7MG6ac6+MRfyppKeHelldUydZ4n2irr/bbH/0cIMWcNN/Na+LLOXIgHRgM62xDzTl9e5G1DuafiXdbnGvgQn2IMDw9mFhDGH6NbXHhT/AHRJaqJBUMDejRW3tcvzzgnL9iL4qk47o+1x41xW53Mh6Zb8ndHbAxe1Da0qlrSxqVpcOSXKg+jT6yHnUBn6uE0l9dazxInsdgjwzRjpxj1QhefYaJpJ10BhrABILZpcvBTCJTUPk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 10:36=E2=80=AFAM Abhishek Bapat
<abhishekbapat@google.com> wrote:
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

Acked-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  include/uapi/linux/alloc_tag.h |  8 ++++-
>  lib/alloc_tag.c                | 64 +++++++++++++++++++++++++++-------
>  2 files changed, 58 insertions(+), 14 deletions(-)
>
> diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_ta=
g.h
> index 13e9b5916bf5..0de5fc180790 100644
> --- a/include/uapi/linux/alloc_tag.h
> +++ b/include/uapi/linux/alloc_tag.h
> @@ -50,13 +50,17 @@ enum {
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
> @@ -64,6 +68,8 @@ enum {
>  struct allocinfo_filter {
>         __u64 mask; /* bitmask of the filter fields used */
>         struct allocinfo_tag fields;
> +       __u64 min_size;
> +       __u64 max_size;
>  };
>
>  struct allocinfo_get_at {
> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> index f00d731b81cf..ad33d63ef7b4 100644
> --- a/lib/alloc_tag.c
> +++ b/lib/alloc_tag.c
> @@ -198,16 +198,20 @@ static int allocinfo_cmp_str(const char *str, const=
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
> -
>         if (ct->modname)
>                 allocinfo_copy_str(data->tag.modname, ct->modname);
>         else
> @@ -215,9 +219,9 @@ static void allocinfo_to_params(struct codetag *ct,
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
> @@ -241,7 +245,9 @@ static int allocinfo_ioctl_get_content_id(struct seq_=
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
> @@ -268,6 +274,19 @@ static bool matches_filter(struct codetag *ct, struc=
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
> @@ -281,6 +300,8 @@ static int allocinfo_ioctl_get_at(struct seq_file *m,=
 void __user *arg)
>         struct codetag *ct;
>         struct allocinfo_get_at params =3D {0};
>         __u64 skip_count;
> +       struct alloc_tag_counters counters;
> +       bool fetched_counters;
>
>         if (copy_from_user(&params, arg, sizeof(params)))
>                 return -EFAULT;
> @@ -288,6 +309,11 @@ static int allocinfo_ioctl_get_at(struct seq_file *m=
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
> @@ -311,7 +337,8 @@ static int allocinfo_ioctl_get_at(struct seq_file *m,=
 void __user *arg)
>         ct =3D codetag_next_ct(&priv->ioctl_iter);
>
>         while (ct) {
> -               if (matches_filter(ct, &priv->filter)) {
> +               fetched_counters =3D false;
> +               if (matches_filter(ct, &priv->filter, &counters, &fetched=
_counters)) {
>                         if (skip_count =3D=3D 0)
>                                 break;
>                         skip_count--;
> @@ -320,7 +347,9 @@ static int allocinfo_ioctl_get_at(struct seq_file *m,=
 void __user *arg)
>         }
>
>         if (ct) {
> -               allocinfo_to_params(ct, &params.data);
> +               if (!fetched_counters)
> +                       counters =3D allocinfo_prefetch_counters(ct);
> +               allocinfo_to_params(ct, &params.data, &counters);
>                 priv->positioned =3D true;
>         }
>
> @@ -346,6 +375,8 @@ static int allocinfo_ioctl_get_next(struct seq_file *=
m, void __user *arg)
>         struct codetag *ct;
>         struct allocinfo_tag_data params;
>         int ret =3D 0;
> +       struct alloc_tag_counters counters;
> +       bool fetched_counters;
>
>         memset(&params, 0, sizeof(params));
>         priv =3D m->private;
> @@ -359,11 +390,18 @@ static int allocinfo_ioctl_get_next(struct seq_file=
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
> -       if (ct)
> -               allocinfo_to_params(ct, &params);
> +       }
>
> +       if (ct) {
> +               if (!fetched_counters)
> +                       counters =3D allocinfo_prefetch_counters(ct);
> +               allocinfo_to_params(ct, &params, &counters);
> +       }
>         if (!ct) {
>                 priv->positioned =3D false;
>                 ret =3D -ENOENT;
> --
> 2.55.0.rc0.786.g65d90a0328-goog
>

