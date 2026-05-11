Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF318CD484E
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 19:55:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B99346B00CB; Mon, 11 May 2026 15:55:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4A5F6B00CC; Mon, 11 May 2026 15:55:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A38DD6B00CD; Mon, 11 May 2026 15:55:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 935D26B00CB
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:55:06 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 25EB4A024D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 19:55:06 +0000 (UTC)
X-FDA: 84756192612.30.316F4B1
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf07.hostedemail.com (Postfix) with ESMTP id 066F240009
	for <linux-mm@kvack.org>; Mon, 11 May 2026 19:55:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PRQkTjH9;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778529304; a=rsa-sha256;
	cv=pass;
	b=wc7j9hbPsVt9ccVZXdEbuPQUyTmQTdcwPrT+0kFs5pEZC7ghYRrsWxZTWMyPPgBfeeMLLD
	48G+/wayliltDy18XiEy81IgkG7HcDN2oT5uAPQp5UbRIQltEU7nN0tm0+qTzPTz5mKZ/9
	cb/g6PDFRXuLIgghJSEsCzfHHrWUo3k=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PRQkTjH9;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778529304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i7Wb8FVSSb9fnvT6S6aZiv4w+DGoN/cjPv8shYHV1nQ=;
	b=RskuILIDEnnfDum0gorHRkJgVeARFkZ3b4oXp27F0Fkgm2m27qiPGVYWrxQ/5tVgaqIZhL
	2sI343HdOcfcS/FVQUG09t1nD9B6gMkENenmn3ab/Ewio+Fss4jAP3NmuH2FjxKEJSRpwL
	8QbhHCMjZyc5oiBXdUyBIv4mSQJ5QDg=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-488a88aeec9so52929345e9.2
        for <linux-mm@kvack.org>; Mon, 11 May 2026 12:55:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778529302; cv=none;
        d=google.com; s=arc-20240605;
        b=IAblsexMmwbbv4fOeNMHDVt5YELsNcE769UQGHqE44gYPIepwZy3/8latkJJ8heNKO
         ssDmsmQclZ67h+vVcDf2m4Kz31WvCWmRGNO1ZkC2rXQQBuRZIudGRVDOKPI5U76+S3Up
         7C8NhJ/3ANOHyeays9FwI5CfyfX2PaqRfe227bCx7hXypwsVgIc10AHULxN/PN2vGYa+
         Vhn9M4dyVhlMbl6ZxdR/Q41uKoJj+CERNbI/oN3VHsZKit9FKH+jmVtmpOdb/gS2l4c5
         OHji6E+NBbrnEnykM2guEZaxnyQ62vegUpv/w9VYYPKxAMixdJQpRz+HN0X8omDjKxw7
         AoRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=i7Wb8FVSSb9fnvT6S6aZiv4w+DGoN/cjPv8shYHV1nQ=;
        fh=7CNPS7PYeir1nX4So7Hpa3My6yfzCa0QBnLZck+tsJE=;
        b=O4s7hI65d7c2mbBT5Kyv4xglk3j8SxUyxaIr2rms9HcSWzGDhAqp/oSHZgrLXxhyG5
         k75W0i9fFYQU2TRdAFuxr1KQXMI94GFeTXQ7TUAkMKB9eg3u4Cj8tWZftp1lyF2hvURc
         BR8wbMdcwOGDVBVTjDfl2aZ2hLfiqvBUQ3MVgat8GGRvfGJlIl/GyQ5o+UYSt1etUzTv
         XO+XIFL+5rVQmUCeee4YMP5xh0lopAc9lPTn/3aiyP/d8yjEw4N0ylIrtwi+Ihk0iUNR
         e8FMLbWVRWtyJRjszB+aJ0URX2QsL156cmdWFuwwucW9H3sQ+DFnpFe4PiMgqIbYVDfU
         Ra2w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778529302; x=1779134102; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i7Wb8FVSSb9fnvT6S6aZiv4w+DGoN/cjPv8shYHV1nQ=;
        b=PRQkTjH9LxHEyd+q+MWkcYi++TFb5NCeMR7foM1fD8QwOY5Z1aQB58qVTTY6AdYjdF
         QS7aCE6nR7ELcfWfC7+wIfs8zY8aOB2v1/cnsjljzN2S7h7O3Vusa+N3are2ehmR5fqi
         kWQ/GN7H798S22SkVhNgT3KuumnG6y2ekBYLUfcGmU7W54XJ5iXmjcOogCICVfSLQitz
         RPpjKWVLiednBf6DwCqPEyT8CePIMuUwYQ2LaCIqUvBwg1mZZ2B13BZy73uCNah68J/w
         QO5Ep0ovIJyS/PEJjFLSazjfO+PbnVHbIIkNgI9S4zge6ON1+JIQU5VUDLGJQnaSXbtW
         qH0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778529302; x=1779134102;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=i7Wb8FVSSb9fnvT6S6aZiv4w+DGoN/cjPv8shYHV1nQ=;
        b=i/5dQ2ABnI3213zwBJcQhR7DiEKYSN/5cq+AEd/gJMBf6zv0aTjzH3XEFPXwg2H5y9
         jeH5gxZk1q4Jd5Cj0H/mhUByfH4E4NH25VWYA8oUCa3UJTvcJia3MQmZBpDJYApt2JeI
         JnDfnddML81L9BKyVqAKD1bNPuOx+YO1U9DA8DLRMrQyMTOZCIBIUeW4yRgUEl9R7uIg
         fQkJVJmtiNWAzPkbHdUa7PKdo8sPzdWw4lZHYsa0Jh9FjdkYu01TEno22Dlx87bwYEwA
         P427j4JdzRQzLm/iOtyc3AeU+Zz4ZaMFODzLSo+cfx//PnxMYxMfl9CsHIQ6a6IZ4zqi
         eO0Q==
X-Forwarded-Encrypted: i=1; AFNElJ8hkWOZOaRJu8Yhy9BFei5x6Z4SNlgpSh4NtsyunbWOVKvl0m2yyxKgZelKkcaKlLrKcV1GnAvoIw==@kvack.org
X-Gm-Message-State: AOJu0YxL997aBqHQCoRuFKGHbzDmRf6+gBKxPQyEJCTS0dlIJSRx4C+a
	PT7FmC9JYcvzxRdr7Fwd9nLwa4ZTSIZb9K7JmSgOVnelAhggOTjmFHRAu52LC4mrhidZcTvT+aM
	xz0WHeB3iWTwigzgdCQnvje8wL5w61J2LOUvzMXA=
X-Gm-Gg: Acq92OFXBvp1EXA3pd/Gdrey3TUE/uUiKEET3TO/Popr8zQDbCC7VLpyUt24R7dkkKV
	bQoxRVzNxh3+PQv+3dW440S/OMuCuxI37Y7cYb+XknP41K70i8+LV6XFeyDiJ9YebJm1U6WNR6E
	TaiT2Zqt4odIup6ai0pBrU397eYKHNQeWBXsdwF5FLqY8/C4rXzOZJ8+hbi9eXwlXfUelqnh4rv
	Di07KeNEB1vg0CHtsgrO9Jf/TSTVcd9xD95P8ryI1zDRfB2rpBjiy2Yv6IHyhRUuz+EKl8E/nNT
	8Dav/IKrvv/lZiyiKkHsvJzPS+FtA/q/IP+nnf0=
X-Received: by 2002:a05:600c:35d6:b0:489:1ff1:74d3 with SMTP id
 5b1f17b1804b1-48e707033f0mr185372725e9.20.1778529302289; Mon, 11 May 2026
 12:55:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260511105149.75584-1-jiahao.kernel@gmail.com> <20260511105149.75584-3-jiahao.kernel@gmail.com>
In-Reply-To: <20260511105149.75584-3-jiahao.kernel@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 11 May 2026 12:54:48 -0700
X-Gm-Features: AVHnY4KxTofzGA29WdApz7TAGVVFv1pib_PN6weIqMmJZRLUqnjNkT8S2YWonGY
Message-ID: <CAKEwX=PW2+EN41ANutv4cv+iM+JpwV5V+NSp5ukAt0M6fbHFLg@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm/zswap: Implement proactive writeback
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, yosry@kernel.org, mkoutny@suse.com, 
	chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: endjwfmgimamt8jg9mjokxioj4sr7ja7
X-Rspam-User: 
X-Rspamd-Queue-Id: 066F240009
X-Rspamd-Server: rspam07
X-HE-Tag: 1778529303-193534
X-HE-Meta: U2FsdGVkX19LvXIuW7rkRL2MTr/Cr9OijazGsozmVhgFIba45TJga/e7XOZPA2DoqlDQ9kn9fUWDjbg+atKy1rDSyK6Lp4R4WxSOSTEwaS75Oawwc9X4QMe5pDEnz0D7NgQQ6duv0kcwJVNfwv5BNlKAlYuQhYaI/zHKfKmfBlNCMTtcXN4toKm495Fd9IpF5lmMX7TlmsCjyVsZxyxPFB4m2J9/VAmOyTO9B2uoCfHDLeUdRv83ZxcfkUpppnCFDbuwjRRtkNVKOIczi4tqnshP7X8485sUSIRyfUwqOOCemcF5mP/Fm0+x3HGpK6ZHiBZkwNSlvJlDl2lW/qaMlahgqpsoMm16KjQojWUKqLnpkQePs8LKRABx4/H2wWVegWTZCes2ysz3qzRFUKn097p97LButNm7zhbjGvebOI8pdhWTE5pIMv6Owp7L/284OR55jxJG9zfUATdY//OsQXFV0ot6Smk0T7CbtA+Yl8gZp/jLtg+4EEo5usdEOp4ZrowoWUIXWMAv1WazMhoMElGLn8jTeIkRgRFIpQa8neSKzqI5EXMQlguwZo9bIfi/D/JlS5/DlGVvOpFLAcQRK0ZFCoJXNjSLEUChk08Fz3cqIKxi6ftzf4USZGgHl2LiXUuQHuxS2TZdbjpWJvhzcnFyDCqAJnbf8ql32g8Ann8kH5JRRvuYskQyWmAU7/WazQ9wwP4PvXI9/bLu3/zSLA0N0wKdZeUlWGkL+PFXVbwzn0YgWKGitvpX4LOMyoEYe4imn0QvPkhEQZ/B/QHajg6IZMF49t0xu7B7zIsivV4c530BNLJ76Q7fYkUMGwTHaZ22G18Zn0pdVnkkOCVcHswqHuP1dEdiGqKUVeVo4eGmOi6fPOhbCvnxdxnp4toab766PNYKXm+kFLJx3LuLuLFM73CWqqTdMo0uNdfMRKNEAcdZMkD9pAaFp1DnEbXC6uzEpWDsFh/kZ0aB15i
 vs4PA0QL
 8KO2BGGa2deKjl3bwuHHUAWF149iSCi1yfN4qpLvplkLKHn/lwh3DKR7KCtd5L7oZZ33AMPofUGQztagNZpcD/qqEepOOh1ounHjoOw7QWYCe4ZMBYopwWWUlavfHgoqGtRYnYSYvI6/SABXbZPQaEULIB5W+X2eY4I5T9nUisHkroiwM73tNAVP03thQEM0MYDkz3xqKwg2qi25bcax+0OHs9kldCRf1tlIhrL5Xj4mZWcI6PUsaS0/IU7OTHUCzykYlpYRJLLkrnoMU5xXdj5cpPL1fIhTIrO30u8WowRsUPtyDUPMGylvZ3ojcXP29n3TdxsgHhiKONqxeyndtXj3B0tv62F0j4gMj8po9d+og//IdDetvAlOmlQ7EzgzEQ3IP44KClQPKE8bx4fOexSR3cQsMVTUBuvzuwV7z1b6JeVWxaFUEokKvLg6j7cb+CC9laNBk2pTVqqiL0xl+VBQjd23i2MtUSv14PUHFRNp9h+lLuQ3CBNLjhSXC329sTJUWco9xN6ueQyov4F/NLYigqlQukSAWWG6ppjmYPEQLBOY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 3:52=E2=80=AFAM Hao Jia <jiahao.kernel@gmail.com> w=
rote:
>
> From: Hao Jia <jiahao1@lixiang.com>
>
> Zswap currently writes back pages to backing swap devices reactively,
> triggered either by memory pressure via the shrinker or by the pool
> reaching its size limit. This reactive approach offers no precise
> control over when writeback happens, which can disturb latency-sensitive
> workloads, and it cannot direct writeback at a specific memory cgroup.
> However, there are scenarios where users might want to proactively
> write back cold pages from zswap to the backing swap device, for
> example, to free up memory for other applications or to prepare for
> upcoming memory-intensive workloads.
>
> Therefore, implement a proactive writeback mechanism for zswap by
> adding a new cgroup interface file memory.zswap.proactive_writeback
> within the memory controller.
>
> Users can trigger writeback by writing to this file with the following
> parameters:
> - max=3D<bytes>: The maximum amount of memory to write back (optional,
>   default: unlimited).
> - <age>: The minimum age of the pages to write back. Only pages that
>   have been in zswap for at least this duration will be written back.
>
> Example usage:
>   # Write back pages older than 1 hour (3600 seconds), max 10MB
>   echo "max=3D10M 3600" > memory.zswap.proactive_writeback
>
> The implementation consists of:
> 1. Add store_time to struct zswap_entry to record when each entry was
>    inserted into zswap, used for proactive writeback age comparison.
> 2. Introduce struct zswap_shrink_walk_arg, passed as the cb_arg to
>    list_lru_walk_one() in both the shrinker and proactive paths. It
>    carries the per-invocation cutoff_time and proactive flag down to
>    shrink_memcg_cb(), and propagates the encountered_page_in_swapcache
>    out-signal from the callback back to the caller.
> 3. Modify the callback function shrink_memcg_cb() to proactively
>    writeback zswap_entries that meet the time threshold.
> 4. Add zswap_proactive_writeback() as the proactive writeback driver:
>    a per-node batched list_lru_walk_one() loop bounded by the
>    writeback budget.
>
> Signed-off-by: Hao Jia <jiahao1@lixiang.com>
> ---
>  Documentation/admin-guide/cgroup-v2.rst |  24 ++++
>  include/linux/zswap.h                   |   8 ++
>  mm/memcontrol.c                         |  76 ++++++++++
>  mm/zswap.c                              | 176 ++++++++++++++++++++++--
>  4 files changed, 276 insertions(+), 8 deletions(-)
>
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admi=
n-guide/cgroup-v2.rst
> index 6efd0095ed99..05b664b3b3e8 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1908,6 +1908,30 @@ The following nested keys are defined.
>         This setting has no effect if zswap is disabled, and swapping
>         is allowed unless memory.swap.max is set to 0.
>
> +  memory.zswap.proactive_writeback
> +       A write-only nested-keyed file which exists in non-root cgroups.
> +
> +       This interface allows proactive writeback of pages from the zswap
> +       pool to the backing swap device. This is useful to offload cold
> +       pages from the zswap pool to the slower swap device. It is only
> +       available if zswap writeback is enabled.
> +
> +       Users can trigger writeback by writing to this file with the foll=
owing
> +       parameters:
> +
> +       - "max=3D<bytes>" : Optional. The maximum amount of data to write=
 back.
> +         (default: unlimited). Please note that the kernel can over or u=
nder
> +         writeback this value.
> +
> +       - "<age>" : Required. The minimum age of the pages to write back
> +         (in seconds). Only pages that have been in the zswap pool for a=
t
> +         least this amount of time will be written back.
> +
> +       Example::
> +
> +         # Write back pages older than 1 hour (3600 seconds), max 10MB
> +         echo "max=3D10M 3600" > memory.zswap.proactive_writeback
> +
>    memory.pressure
>         A read-only nested-keyed file.
>
> diff --git a/include/linux/zswap.h b/include/linux/zswap.h
> index efa6b551217e..7a51b4f95017 100644
> --- a/include/linux/zswap.h
> +++ b/include/linux/zswap.h
> @@ -44,6 +44,8 @@ void zswap_lruvec_state_init(struct lruvec *lruvec);
>  void zswap_folio_swapin(struct folio *folio);
>  bool zswap_is_enabled(void);
>  bool zswap_never_enabled(void);
> +int zswap_proactive_writeback(struct mem_cgroup *root, unsigned long nr_=
max_writeback,
> +                             ktime_t cutoff);
>  #else
>
>  struct zswap_lruvec_state {};
> @@ -78,6 +80,12 @@ static inline bool zswap_never_enabled(void)
>         return true;
>  }
>
> +static inline int zswap_proactive_writeback(struct mem_cgroup *root,
> +                                           unsigned long nr_max_writebac=
k, ktime_t cutoff)
> +{
> +       return 0;
> +}
> +
>  #endif
>
>  #endif /* _LINUX_ZSWAP_H */
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 409c41359dc8..ba7f7b1954a8 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -70,6 +70,7 @@
>  #include "memcontrol-v1.h"
>
>  #include <linux/uaccess.h>
> +#include <linux/parser.h>
>
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/memcg.h>
> @@ -5891,6 +5892,76 @@ static ssize_t zswap_writeback_write(struct kernfs=
_open_file *of,
>         return nbytes;
>  }
>
> +enum {
> +       ZSWAP_WRITEBACK_MAX,
> +       ZSWAP_WRITEBACK_AGE,
> +       ZSWAP_WRITEBACK_ERR,
> +};
> +
> +static const match_table_t zswap_writeback_tokens =3D {
> +       { ZSWAP_WRITEBACK_MAX, "max=3D%s" },
> +       { ZSWAP_WRITEBACK_AGE, "%u" },
> +       { ZSWAP_WRITEBACK_ERR, NULL },
> +};
> +
> +static ssize_t zswap_proactive_writeback_write(struct kernfs_open_file *=
of,
> +                                              char *buf, size_t nbytes,
> +                                              loff_t off)
> +{
> +       struct mem_cgroup *memcg =3D mem_cgroup_from_css(of_css(of));
> +       unsigned long nr_max_writeback =3D ULONG_MAX;
> +       substring_t args[MAX_OPT_ARGS];
> +       unsigned int age_sec;
> +       bool age_set =3D false;
> +       ktime_t cutoff_time;
> +       char *token, *end;
> +       int err;
> +
> +       if (!mem_cgroup_zswap_writeback_enabled(memcg))
> +               return -EINVAL;
> +
> +       buf =3D strstrip(buf);
> +
> +       while ((token =3D strsep(&buf, " ")) !=3D NULL) {
> +               if (!strlen(token))
> +                       continue;
> +
> +               switch (match_token(token, zswap_writeback_tokens, args))=
 {
> +               case ZSWAP_WRITEBACK_MAX:
> +                       nr_max_writeback =3D memparse(args[0].from, &end)=
;
> +                       if (*end !=3D '\0')
> +                               return -EINVAL;
> +                       nr_max_writeback >>=3D PAGE_SHIFT;
> +                       break;
> +               case ZSWAP_WRITEBACK_AGE:
> +                       if (age_set)
> +                               return -EINVAL;
> +
> +                       if (match_uint(&args[0], &age_sec))
> +                               return -EINVAL;
> +                       age_set =3D true;
> +                       break;
> +               default:
> +                       return -EINVAL;
> +               }
> +       }
> +
> +       if (!age_set || !age_sec || !nr_max_writeback)
> +               return -EINVAL;
> +
> +       cutoff_time =3D ktime_sub(ktime_get_boottime(),
> +                               ns_to_ktime((u64)age_sec * NSEC_PER_SEC))=
;
> +       /* age_sec >=3D uptime: no entry can be that old, skip the walk. =
*/
> +       if (ktime_to_ns(cutoff_time) <=3D 0)
> +               return nbytes;
> +
> +       err =3D zswap_proactive_writeback(memcg, nr_max_writeback, cutoff=
_time);
> +       if (err)
> +               return err;
> +
> +       return nbytes;
> +}
> +
>  static struct cftype zswap_files[] =3D {
>         {
>                 .name =3D "zswap.current",
> @@ -5908,6 +5979,11 @@ static struct cftype zswap_files[] =3D {
>                 .seq_show =3D zswap_writeback_show,
>                 .write =3D zswap_writeback_write,
>         },
> +       {
> +               .name =3D "zswap.proactive_writeback",
> +               .flags =3D CFTYPE_NOT_ON_ROOT,
> +               .write =3D zswap_proactive_writeback_write,
> +       },
>         { }     /* terminate */
>  };
>  #endif /* CONFIG_ZSWAP */
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 19538d6f169a..1173ac6836fa 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -36,6 +36,7 @@
>  #include <linux/workqueue.h>
>  #include <linux/list_lru.h>
>  #include <linux/zsmalloc.h>
> +#include <linux/timekeeping.h>
>
>  #include "swap.h"
>  #include "internal.h"
> @@ -160,6 +161,12 @@ struct zswap_pool {
>         char tfm_name[CRYPTO_MAX_ALG_NAME];
>  };
>
> +struct zswap_shrink_walk_arg {
> +       ktime_t cutoff_time;
> +       bool proactive;
> +       bool encountered_page_in_swapcache;
> +};
> +
>  /* Global LRU lists shared by all zswap pools. */
>  static struct list_lru zswap_list_lru;
>
> @@ -183,6 +190,7 @@ static struct shrinker *zswap_shrinker;
>   * handle - zsmalloc allocation handle that stores the compressed page d=
ata
>   * objcg - the obj_cgroup that the compressed memory is charged to
>   * lru - handle to the pool's lru used to evict pages.
> + * store_time - Time when the entry was stored, for proactive writeback.
>   */
>  struct zswap_entry {
>         swp_entry_t swpentry;
> @@ -192,6 +200,7 @@ struct zswap_entry {
>         unsigned long handle;
>         struct obj_cgroup *objcg;
>         struct list_head lru;
> +       ktime_t store_time;

On the implementation side - will this blow up struct zswap_entry
memory footprint? If so, can you guard this behind a CONFIG option, if
we are to go this route?

