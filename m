Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14BDDECD993
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 17:32:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F1486B0089; Thu,  5 Feb 2026 12:32:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49F3A6B008A; Thu,  5 Feb 2026 12:32:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3561C6B0092; Thu,  5 Feb 2026 12:32:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 230776B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:32:12 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A90118C076
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 17:32:11 +0000 (UTC)
X-FDA: 84411096462.06.0790E56
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf24.hostedemail.com (Postfix) with ESMTP id 79C83180004
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 17:32:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PogX965W;
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770312729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g52qu0qGnFSGXKiEGpFnsfB+pG35rlmS3i3v56pM+jk=;
	b=lcKOwwD39jTcaYO/u38GeEfbKKfaaRkPx/U8ylywMHegwY2aA9LKq9AQ7HsxFQguU2EIA0
	oA4e3geBx8uwg694P3H/D5dik/2RjDdPYHPjT8aTbTidP2mye7bsdTHt+GIiK7IKLKoLLP
	eskpImQCOB9T4B+3AJT4Huh782D3HSA=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PogX965W;
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770312729; a=rsa-sha256;
	cv=pass;
	b=tIl9Ai1D1qrC13LdmLv0lp0BLRKkUW5AKYgSU+RYO+k9IG9KWWsqras4pZflQIwC/nPpX5
	Mh0ZsA0Q3LsJBJHW8RTrDCVz2vh7hZIX77j5RRj27C0EU/wTOg5kSRmfMdoGFouHRotsQZ
	/R2m6whLgmJFSXeiYf3E8IRVTK8hIS0=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4362507f396so727696f8f.0
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 09:32:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770312728; cv=none;
        d=google.com; s=arc-20240605;
        b=GGWTlwhUFvntbHS1PhBnu/nNm6WJP4f9lCDoC968wIjoPbFypwGqhKOWyE8A5b8qBI
         T25+y7IWX+sTpRwNwb5x50mv42BukW2qM82llIfnQdKYNzJfLhlfdS1Hfl8f5n3HcWJL
         QfFjqPVL73TXCSogc7M+/34pXt/sMq1+y206MuGWYG3CjsRdh52gKTNjn1T0qz2LzOgn
         rsmW0CSz40sSna7LUGxHgpdW6wCb/0NXR8yaydwb+dS14vOvoMOonYSdQSSV0vU2YYTB
         WBylX/mFQWNDvjWkO6v3g3G+lzSXGGWGEAPIikO2EZF6A4ZivAA4JxosHMDJm+MU7xhR
         1p8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=g52qu0qGnFSGXKiEGpFnsfB+pG35rlmS3i3v56pM+jk=;
        fh=W2h8oEiZRBGhmuuFlJoQZw0Bskx6obR9v4i6pYzyYQs=;
        b=N5H8WeKTpAKNFNPqUIe8ALhYqHNKA6iXA8KAO8/e9z/01GQsAFv63EdMdRCks4RKn+
         pLYZlO1UC/IRdnpZUYs0y84vExGZHUZEYkoDM+l9ngdniBQJjDabKm0DeR0clmxMdxaC
         5szUs3ufjiEF5lK8qP17F4UkKUSsC0LmZJrCUhSqlUy72kS7z3Q8YrU5lQ1DNORaA+l+
         9RLktVVUWtGApphj+OzoNWhNQeDAY/y5eHEXJ0d7WsillRH+8qGQVOVUDhhLQFL9y9w0
         h88gf7ctw1HuIHZwle6/4XMkJlTMoMRpaXpfVPSO/IXwXMV0lUf+YYqx/fcMtxWBpATQ
         QhDw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770312728; x=1770917528; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g52qu0qGnFSGXKiEGpFnsfB+pG35rlmS3i3v56pM+jk=;
        b=PogX965WEGmU+/4SUuMWpG1vZOEmFflWrc++wMDjZdPKsB1u+K12U97Km1tTrBRE0G
         jDHEQDoNbjBxnZHGjsWsRMXNy9mrKBfrFTHdHVtsYV0AyMiGUUlw0UVXx//AMlfUkQ+I
         EHq3gYFLCojF8VruotxLlKLThlaJh3bY6vC2bvRuDfHTlsrI6je0H4kJhEdV1pHEvgrX
         KMOjvHrP9VC3FmZkpk8Tvmmem7VX/aaz/e5y5ZLAzPrA8306+HhtDI8m+L/sBKZEiZZn
         QRXZa8CghZoUbveNEFuOzwYzIQLlc36UcfnW/eq59RtYuoQj+kaI2Jbk++S+tybC8QCS
         lMuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770312728; x=1770917528;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=g52qu0qGnFSGXKiEGpFnsfB+pG35rlmS3i3v56pM+jk=;
        b=UPBbPcZ0ZwnY4T/h07hPHBJ9bKYnD07bLXV+Zg/mQdOJM98Dd87Hm0d1RRAnvtLPnS
         s+v+Hvql/aqg0Zxc8E3gwZzyxZAVKG47OfBUIUHdCHlNcwgMhBvBoN231V2zOE8xT796
         yQM0ruaOaoR7Yn+uqvUEgQKCb+vdzy5jiQVj8Twhz8b/OJsH6mp59cxxzhKb4n3VJ5DC
         9GQbQJanYZvIJ6GTvteuW9ZB02DAApUiw6AE5mW8YlWE4N8/ZSFHc2+ErVA4P8DdJ6eD
         lhrfCc4B7Aw5YadtHJTt5Du8SPV7ENKko0s84i98CbX3h+pSD6BkY2urBxOcKocBAv4X
         IW0w==
X-Gm-Message-State: AOJu0YyZFT65xx+m1NL91jQf/quW/DGhwwVWM1QamVbz6mj57p9Q1hqr
	Z/LVDI/nIUf1PKgQyHz0gZks1X3K34IGFWEeqL8w5DSer0Q70E0iNRtesUAo9lzSKK1bsXjrMfa
	EBBtdVyML9c0rT+ey4O8uuMJ2giW2GL4=
X-Gm-Gg: AZuq6aIdiRIMBRXJfPNAYt8PTZ7Nemrz25bKG8DvdpTosvxLmNDeAY74AHURDXXACu1
	ajuiz0FaPmbXeOVhofpBp1pP0ItEKCf8hTZdhW4Ubk7VKuN3LJmJbdEjsw76/v6TkK49po/qBH5
	LEBj/HZcX+53WPvpmj/X3Sti/j8m/5yXEPmm7ki5bT562RCApjKs8EwfNRLFdMG3P5tlRR+eBz6
	f7TdXnU1zPKnOR6e1Q0rk2o8qAyOWocs2cWywQSzzCjXIrH4I+Heh78+uSRoeDCfY7oc4mkwHrM
	SmXtpkqz7BBZunO1LpWzPYj9pck+OfAa5CcjDDXVFRJJTf6VA2A=
X-Received: by 2002:a05:6000:2210:b0:432:c0e8:4a33 with SMTP id
 ffacd0b85a97d-43629341477mr32789f8f.22.1770312727591; Thu, 05 Feb 2026
 09:32:07 -0800 (PST)
MIME-Version: 1.0
References: <20260205053013.25134-1-jiayuan.chen@linux.dev>
In-Reply-To: <20260205053013.25134-1-jiayuan.chen@linux.dev>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 5 Feb 2026 09:31:54 -0800
X-Gm-Features: AZwV_QjD6TkEI4CsNnehMc1v_KPguXieQKuSceu0vgbdRjFfP_QTgXPulDlKd_8
Message-ID: <CAKEwX=PMQ1aYWr36XKG7oup3diBXb5vjV=fGZeTmYcx+ebmMtQ@mail.gmail.com>
Subject: Re: [PATCH v1] mm: zswap: add per-memcg stat for incompressible pages
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Nick Terrell <terrelln@fb.com>, David Sterba <dsterba@suse.com>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Chris Li <chrisl@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: c985ehqsbz8emtha7i1hmnt17tttxx1x
X-Rspamd-Queue-Id: 79C83180004
X-Rspam-User: 
X-HE-Tag: 1770312729-555846
X-HE-Meta: U2FsdGVkX1/4i+yzM0S58NA4hBNS6dyVMszKD2PIfp5cvetfAgiesIg/tiAKk/1flk89dtIrCq/DfVPxxWSa5idIUybh+4JjLoD3odwI21Pp5qJp6+PobCwkMO909KehacctWj4fUFZrr9sHUEN+eZ3qe/CDt4evji/RTKw5VJNZA9HaFziTt36PZjjVJEvxCJonRUX0buMyNwkGw7aqniLe6zFv9eYanZpD4r1n/qmmETdgaDjLvzMSQYMNNBcXOo7Ph3F43E4T/PVwGlUlXc5M5aCxblXRC1qU6RjNcOqLbQUsv7OzapmlueY1pOvxpInXG8qGiIcYvdEXPbFx+ElspyJxGEJPJfXX/qSA5WcdplLhLw2LKBUqNxhMh6lWhNoapTeVpQtsDaFZWRdTfw0UlXf728V93FYns5c7Y7REfnwlk7ytsylOxXTYRD7MPinAu078ak2OxKbazX1X3acgDz+gszKUkS6fK8P2QDGyWSVb22BdecIHeKHRBV0k+EdXmbr3ms0L5haLEcZQlLqNc7WA/YgoBVvxFuju7FLGk9PMZDEzAeTY3N9jcaMIIvGtiDiLvACeEFX4SGddDuak6Bwxz+NCRNshxx16f8B8efxMixKv/uWa051O3LKBCbzS+mE8bLq63kkqYuq2s0rvDdm3hv02aZVNRCvH4UbKUpmLI4xDxX9p5mM5QgjKs42VTjJL2qi0oDdFrbAuOwneZkB5gfoO41bT3/WCKoJg4rRt4i7nMNwe4HzEg8WSU5+mAGqqZ/XnUBpN+QIxbZkS+7raf41xAaZlkB+X+0xSgYIBQhiSF6j2eiGuRGF/xSR+pxPovnh40YO+qEDpGIfn7f6NYGcKbZhRqdUmNGrfa0kpkxi99wQBd5C+/ga3q20t/aDhG9GEK/L9YBrtzF22+11BNbHYcsoaGUKoCBONxh9bdrwfc/9uoEuAe9qjoHySCjX9wPlW8GHOk9q
 W/wJFwz1
 fvkQJtbuZWdVjU7Gr3Ib46zwmWYnHV7h3NjQl7xEpJndRJaXodB8+8c2kQRTKzox1SWGAlh2b9wT8dCmEfSj50NaJ4J8UbxBjbUOI72qGZI/KRUqYpSJtWBsADronmzlzc+OM+TkmQiqPPiaAVAQx7PWCWu2Y6OQ1Dwfv5PpZVoU37wZnV6jFHUjOs3db+QbUN08S5Z5KaHEl8gxJzbEnwUglcVS58Yfclc7hhTVDgqpehmuZvKFejs6cm3gds4JYxtZ86BaCwWj5EiNbmp40RwWbYKIbHct2E4HfGtOj1au/wrveLmSixpYWdYXdaf9wSaicwdgnNML7sOgfxgJROWc9HYkHSnijtTQhxWmdva8gkLr5lXqNTaiWW0UcEcUD3t9C0ajIt7J1d+t2Z8bZr5nopAo2VFpRgKUOBR8zbBwASy2RjiigXvzkkPKSsQhU3Yw8Ho4d06+xt/0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 4, 2026 at 9:31=E2=80=AFPM Jiayuan Chen <jiayuan.chen@linux.dev=
> wrote:
>
> From: Jiayuan Chen <jiayuan.chen@shopee.com>
>
> The global zswap_stored_incompressible_pages counter was added in commit
> dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression failed page as-is")
> to track how many pages are stored in raw (uncompressed) form in zswap.
> However, in containerized environments, knowing which cgroup is
> contributing incompressible pages is essential for effective resource
> management.
>
> Add a new memcg stat 'zswpraw' to track incompressible pages per cgroup.
> This helps administrators and orchestrators to:
>
> 1. Identify workloads that produce incompressible data (e.g., encrypted
>    data, already-compressed media, random data) and may not benefit from
>    zswap.
>
> 2. Make informed decisions about workload placement - moving
>    incompressible workloads to nodes with larger swap backing devices
>    rather than relying on zswap.
>
> 3. Debug zswap efficiency issues at the cgroup level without needing to
>    correlate global stats with individual cgroups.
>
> While the compression ratio can be estimated from existing stats
> (zswap / zswapped * PAGE_SIZE), this doesn't distinguish between
> "uniformly poor compression" and "a few completely incompressible pages
> mixed with highly compressible ones". The zswpraw stat provides direct
> visibility into the latter case.

I personally agree. This is especially useful for multi-tenants
setups, where different workloads can have different compressibility,
which can muddy the waters, and might prefer different swapping
treatment (disk swapping, zswapping, zswap + disk swap through zswap
shrinker). It might also give us data to extend zswap (zswap
compressibility-based rejection, or different compression levels).

Naming is a bit off though, but I'm not a native English speaker :)
I think Chris Li pointed the out the necessity of per-memcg counters too:

https://lore.kernel.org/linux-mm/CAF8kJuONDFj4NAksaR4j_WyDbNwNGYLmTe-o76rqU=
17La=3DnkOw@mail.gmail.com/

Can you add this to the patch changelog in later versions? :)

+ Chris Li
>
> Changes
> -------
>
> 1. Add zswap_is_raw() helper (include/linux/zswap.h)
>    - Abstract the PAGE_SIZE comparison logic for identifying raw entries
>    - Keep the incompressible check in one place for maintainability
>
> 2. Add MEMCG_ZSWAP_RAW stat definition (include/linux/memcontrol.h,
>    mm/memcontrol.c)
>    - Add MEMCG_ZSWAP_RAW to memcg_stat_item enum
>    - Register in memcg_stat_items[] and memory_stats[] arrays
>    - Export as "zswpraw" in memory.stat
>
> 3. Update statistics accounting (mm/memcontrol.c, mm/zswap.c)
>    - Track MEMCG_ZSWAP_RAW in obj_cgroup_charge/uncharge_zswap()
>    - Use zswap_is_raw() helper in zswap.c for consistency
>
> Test
> ----
>
> I wrote a simple test program[1] that allocates memory and compresses it
> with zstd, so kernel zswap cannot compress further.
>
>   $ cgcreate -g memory:test
>   $ cgexec -g memory:test ./test_zswpraw &
>   $ cat /sys/fs/cgroup/test/memory.stat | grep zswp
>   zswpraw 0
>   zswpin 0
>   zswpout 0
>   zswpwb 0
>
>   $ echo "100M" > /sys/fs/cgroup/test/memory.reclaim
>   $ cat /sys/fs/cgroup/test/memory.stat | grep zswp
>   zswpraw 104800256
>   zswpin 0
>   zswpout 51222
>   zswpwb 0
>
>   $ pkill test_zswpraw
>   $ cat /sys/fs/cgroup/test/memory.stat | grep zswp
>   zswpraw 0
>   zswpin 1
>   zswpout 51222
>   zswpwb 0
>
> [1] https://gist.github.com/mrpre/00432c6154250326994fbeaf62e0e6f1

Would be nice if some versions of this can be turned into a selftest :)

Instead of reading zstd data, you can read from /dev/urandom. I found
those to be incompressible, usually.

Feel free to send this as a follow-up patch, but would love to see it :)

>
> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
> ---
>  include/linux/memcontrol.h | 1 +
>  include/linux/zswap.h      | 9 +++++++++
>  mm/memcontrol.c            | 6 ++++++
>  mm/zswap.c                 | 6 +++---
>  4 files changed, 19 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index b6c82c8f73e1..83d1328f81d1 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -39,6 +39,7 @@ enum memcg_stat_item {
>         MEMCG_KMEM,
>         MEMCG_ZSWAP_B,
>         MEMCG_ZSWAPPED,
> +       MEMCG_ZSWAP_RAW,
>         MEMCG_NR_STAT,
>  };
>
> diff --git a/include/linux/zswap.h b/include/linux/zswap.h
> index 30c193a1207e..94f84b154b71 100644
> --- a/include/linux/zswap.h
> +++ b/include/linux/zswap.h
> @@ -7,6 +7,15 @@
>
>  struct lruvec;
>
> +/*
> + * Check if a zswap entry is stored in raw (uncompressed) form.
> + * This happens when compression doesn't reduce the size.
> + */
> +static inline bool zswap_is_raw(size_t size)
> +{
> +       return size =3D=3D PAGE_SIZE;
> +}
> +
>  extern atomic_long_t zswap_stored_pages;
>
>  #ifdef CONFIG_ZSWAP
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 007413a53b45..32fb801530a3 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -341,6 +341,7 @@ static const unsigned int memcg_stat_items[] =3D {
>         MEMCG_KMEM,
>         MEMCG_ZSWAP_B,
>         MEMCG_ZSWAPPED,
> +       MEMCG_ZSWAP_RAW,

not sure how I feel about the naming, but I don't have a recommendation :)

>  };
>
>  #define NR_MEMCG_NODE_STAT_ITEMS ARRAY_SIZE(memcg_node_stat_items)
> @@ -1346,6 +1347,7 @@ static const struct memory_stat memory_stats[] =3D =
{
>  #ifdef CONFIG_ZSWAP
>         { "zswap",                      MEMCG_ZSWAP_B                   }=
,
>         { "zswapped",                   MEMCG_ZSWAPPED                  }=
,
> +       { "zswpraw",                    MEMCG_ZSWAP_RAW                 }=
,
>  #endif
>         { "file_mapped",                NR_FILE_MAPPED                  }=
,
>         { "file_dirty",                 NR_FILE_DIRTY                   }=
,
> @@ -5458,6 +5460,8 @@ void obj_cgroup_charge_zswap(struct obj_cgroup *obj=
cg, size_t size)
>         memcg =3D obj_cgroup_memcg(objcg);
>         mod_memcg_state(memcg, MEMCG_ZSWAP_B, size);
>         mod_memcg_state(memcg, MEMCG_ZSWAPPED, 1);
> +       if (zswap_is_raw(size))
> +               mod_memcg_state(memcg, MEMCG_ZSWAP_RAW, 1);
>         rcu_read_unlock();
>  }
>
> @@ -5481,6 +5485,8 @@ void obj_cgroup_uncharge_zswap(struct obj_cgroup *o=
bjcg, size_t size)
>         memcg =3D obj_cgroup_memcg(objcg);
>         mod_memcg_state(memcg, MEMCG_ZSWAP_B, -size);
>         mod_memcg_state(memcg, MEMCG_ZSWAPPED, -1);
> +       if (zswap_is_raw(size))
> +               mod_memcg_state(memcg, MEMCG_ZSWAP_RAW, -1);
>         rcu_read_unlock();
>  }
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 3d2d59ac3f9c..54ab4d126f64 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -723,7 +723,7 @@ static void zswap_entry_free(struct zswap_entry *entr=
y)
>                 obj_cgroup_uncharge_zswap(entry->objcg, entry->length);
>                 obj_cgroup_put(entry->objcg);
>         }
> -       if (entry->length =3D=3D PAGE_SIZE)
> +       if (zswap_is_raw(entry->length))
>                 atomic_long_dec(&zswap_stored_incompressible_pages);
>         zswap_entry_cache_free(entry);
>         atomic_long_dec(&zswap_stored_pages);
> @@ -941,7 +941,7 @@ static bool zswap_decompress(struct zswap_entry *entr=
y, struct folio *folio)
>         zs_obj_read_sg_begin(pool->zs_pool, entry->handle, input, entry->=
length);
>
>         /* zswap entries of length PAGE_SIZE are not compressed. */
> -       if (entry->length =3D=3D PAGE_SIZE) {
> +       if (zswap_is_raw(entry->length)) {
>                 WARN_ON_ONCE(input->length !=3D PAGE_SIZE);
>                 memcpy_from_sglist(kmap_local_folio(folio, 0), input, 0, =
PAGE_SIZE);
>                 dlen =3D PAGE_SIZE;
> @@ -1448,7 +1448,7 @@ static bool zswap_store_page(struct page *page,
>                 obj_cgroup_charge_zswap(objcg, entry->length);
>         }
>         atomic_long_inc(&zswap_stored_pages);
> -       if (entry->length =3D=3D PAGE_SIZE)
> +       if (zswap_is_raw(entry->length))
>                 atomic_long_inc(&zswap_stored_incompressible_pages);
>
>         /*
> --
> 2.43.0
>

Those nits aside, LGTM.
Acked-by: Nhat Pham <nphamcs@gmail.com>

I'll leave the naming suggestion to Yosry and Johannes ;)

