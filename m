Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2B3BCD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 20:01:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4B4D6B00A6; Fri, 29 May 2026 16:01:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E22606B00A7; Fri, 29 May 2026 16:01:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D38606B00A8; Fri, 29 May 2026 16:01:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE9FC6B00A6
	for <linux-mm@kvack.org>; Fri, 29 May 2026 16:01:30 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3CFF914028B
	for <linux-mm@kvack.org>; Fri, 29 May 2026 20:01:30 +0000 (UTC)
X-FDA: 84821527140.28.D1E7321
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id 16C7BC001A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 20:01:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HK6kODZn;
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780084888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W+5IFUGExZ+iwBSpEJguGBn5lCaGGh6fBKDVTB3MkGQ=;
	b=SPf9QE5LpQF7KXqF7tdSOnWTjSDBZLxG9gJwjABwzH1dyzX3zsLrE7bc2riRXnJ6ImNjPN
	JeC4JBnBgvtu/NpqqRj1IZHypiW1+O7bM0thK1QqefUCQVKkyA+OAE4R9wDPbkhc7Tgxv6
	R+HLp8R/p+CHhthBH/kXKdAV/HhTAm8=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HK6kODZn;
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780084888; a=rsa-sha256;
	cv=pass;
	b=HqgAV6V2L/1Ns7pi5z/Sv69m/fDOvWHfgGLhlBO+BTlFqMR7xRR+udO3/lMtHRWyVuxjme
	K8Fs+sG1Z62Y7nw+W1m24Qk1LfLWtGKQduzOh2G0GfAQKM+4upGizZoIeM0pwHuXKZLVT5
	THFH9vjBibxYgvZyKghGaWUR4HGB4JU=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4905529b933so59052935e9.0
        for <linux-mm@kvack.org>; Fri, 29 May 2026 13:01:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780084887; cv=none;
        d=google.com; s=arc-20240605;
        b=XM025KfOhj8mmT87QfkKBAA0tlDV4R+B77VaOltYWfn4O2PFzZFTi2cmrW1PXoa1nO
         gePD0x3+Oq0WIQZHajzKpPbwfEaX7CWymdee0PkhoUKPV+iQuPWAGJjlVpX4rG6kNl3y
         yc7wGskltwSIFEGW2zc9QLkUIkGtDyexohT3oxpIEAc3vk7re+PY62Wbk5liOMFG8D56
         ArLTT0heINkjqHcTxgc7wf91VV1Dpq2gumS3iAkLjwEvayihpXN50S6aZwC1/960f+/e
         0l9tdnHhoWHv1TpdTJf2cVs5I1OT1HIGywrodFu/B2ii9acuwk0Ebz6fhbM8IKPXq/ec
         x5DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=W+5IFUGExZ+iwBSpEJguGBn5lCaGGh6fBKDVTB3MkGQ=;
        fh=jZugoRfL/uSL3kvEsPp/PbKGlKSp+aOJCyStRcxnEr4=;
        b=ce2wnH+5uHqTTCy+30aDjn/oCOkkJQLeBRuFTjdriM6LDx4SyWJlwbZJZtAG4iDVTq
         RlBeCR6vwOMQ+S/P6Vn/cKmB+P4PeLP9AR7ehld2UNadDTnYRjLqKCojRn+ITwpoogo9
         nmfMWYrSZlgZC/tvLUwfBmVq0pnBFjUsuMZkcwKu0MCI2xWp+2PLyweLC1blFkrkcQTK
         qg/65gHkrczmNn2Yg3aIunjUgt45EXV2n6YI5XrdYUH1ulOIKQN3LTWHE//ohDydypkQ
         P3MASCng+ybWrwYiMCFx/slabJWNJSIwTlUqVMa+h8qEzwBz899K12ZQ+LmNwj4YEau5
         d8tg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780084887; x=1780689687; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W+5IFUGExZ+iwBSpEJguGBn5lCaGGh6fBKDVTB3MkGQ=;
        b=HK6kODZn5QGdhETynPoIyQFjBxLUGYuoSDiEiwiWcpk7zbRD6+3HRiqkJY16UX2hgn
         KkZV2XqHnTACqvJ/C/SgbwgaycIjw86xWQ0ek5r7sycUWgOvH6pQyAsO4m6sBMym574O
         NyRJtrwb4NyaiN988Lgp9zMZTT0rOabLWPTS0ou7ber4eKUJvFsczp7WxFDhL08EoVqA
         5qosE2AZ2AHb7m3f6YAfOQ6a9nlqQeGM/ATSUgCFOfJTpWLnnJoP7wTjK2w6chyBTPK3
         iwnwki3KBrw/gYO4ttJn1HCGJm4a3hjUw6blcNxa1rbWUIUYXeY8yMD8lcLNnncfnPSs
         NZcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780084887; x=1780689687;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=W+5IFUGExZ+iwBSpEJguGBn5lCaGGh6fBKDVTB3MkGQ=;
        b=VlhAopq4ejH3cMYk4cmVl3QHOnxoftyaKNsiupdb9W4zJxOLAaAb8+3NLwQhCX2JbV
         TjUsI2ty5c4UdFWvbvnVNW5qrX5pjQvAyVGVDuPYsNWDYdsqPfyzcqMYJsNx790tRGD0
         MrbfLdP8Am9xLw+xKS9jmgCbUPyXmN1wXQjLlKE01gx+Pv4lLFyES7EuqZASY2sDkobj
         JawyRXchk4jYSbXgJS5woXKqGFQPA1Vum2mbmFQtV6fjApU3MGo/Ylhw2wsq7/OPj+c8
         bYBj1j1+5kcEEgbDu8SAxBJSQ4gIfMaQRStTS4NrUBlU6xlW+CSYgaX77uQZGxxW1UhT
         M4RA==
X-Forwarded-Encrypted: i=1; AFNElJ8jyWeEYXf4nABuqZ4ymvX74lRmVC6+CTFrTdvLsoQHMG2/XiIIoj5sONQR6b4c3HH0GNqKVui4Ng==@kvack.org
X-Gm-Message-State: AOJu0Yw8DMc0Vm6zNdhuR0OUjhAAqtuoRIAy6wjPaCRSA2c6wyMftI0W
	E8qNr1Yvieol+n/SYrhFmSX0J5SVwRgjgmqdOu72U0y2rcMAhXviQqz5D48Y1+kjvdYvh18YaSb
	D59vAX/elmeywHgkt74ACHIgiRI9Y25c=
X-Gm-Gg: Acq92OEkOQK6VE7FqetPeNeDTHt1zaGf6kUs9lPgxsmDIUEe8wJAdMfCBoAUgYaPfmr
	Rk34HgYJWhGgiCwM4lrq2TJU+eUHRoNpSQGnxW4OY4UFpdlCOLFcfcOUmnf5MeYoUPL15sahz+T
	iuBOUlDuFVBkw9wzHQXRhbRLcYnaBUDbOxmb3fFyy9AF06GnvMdhmEn8SRhOsHCKwLGbCult95I
	8PpyPX6j2yNR4tBr2dfgdOql9ikJ9IouC/GUik/aHK5EHX1ae2sfDhyWDQaSSkBnP+ygjziRbqV
	ve1W8LPeqRAndy8MWyPWn7QXvDTmopG2XBfqABHKqUVlFVp8HQ==
X-Received: by 2002:a05:600c:8582:b0:488:b187:3c with SMTP id
 5b1f17b1804b1-490a29399fcmr13599005e9.14.1780084886357; Fri, 29 May 2026
 13:01:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260526114601.67041-1-jiahao.kernel@gmail.com> <20260526114601.67041-4-jiahao.kernel@gmail.com>
In-Reply-To: <20260526114601.67041-4-jiahao.kernel@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 29 May 2026 13:01:14 -0700
X-Gm-Features: AVHnY4JBZV7V4Cuv6pthC1wuO8sZSjsWbark17MncjIwi_r03e6A9nAix31rk6E
Message-ID: <CAKEwX=PcFqmsdFqUnpWxrPkoc1B-1w3CEb0ydK3df0qJGG-mnQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] mm/zswap: Add per-memcg stat for proactive writeback
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, yosry@kernel.org, mkoutny@suse.com, 
	chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 16C7BC001A
X-Stat-Signature: 7h6kz8jya8j54tekyjhzkoo6jo89ci77
X-HE-Tag: 1780084887-963163
X-HE-Meta: U2FsdGVkX19d2F/813mkWhckDG/Kn0mSn9b7/E1toUjw7ohNboAs6rZbXSusr2o0t1nPf09c27wSUawzDZGEULGFvKLO5YysVEnE4C+tXOogbzhUupB6F75M2ExxEaQUlIvTPdlbaQC5PpvMEhNQK6CLvG1bJ4JAKLbiiuOrDpSgpUsAQ/3IQC8C//5bVydt8WycuSv8z4p1MhLEdGW4u4jZt77an+NK505iJMi33cJu8Uy6gECLyXIvL3IDwyH9fQ8q7KimQmEYp9q0LuYx4XS2s2cjaQs4jzqQ3ktRn4S1CJDmsk+wEdIa6cC9V7wqcshTkvZlNr2yL8gaQB3KVT3KU+F3HLSBTT7XLD/C4TuQ0qYo1GI80BhpVF2BSZlPGAwXaOMtm3Ge90xAFKNOw/cF88BvrTTAt4pPCzuzpBQkMACijO+v8XgaC2O4chhZ5ojyK615J39Q6K/Xm3e/MrxOp/EoHqyJCsIpUBHmKFaVmjECryAxrfEmaonN+xom7yjI52Y2YHm9Twn4670rwJh4noNbWbMXh2gv0V9oo07avlDTZo1S0x9Z5V1AmoEX+YRIEY+r48rnS/2txheoae6F0Jw1V70chaBZx2IoLaQTn7iDl+PfGVlVohIHfy5SzCPr1WK16CaL1EikOCkqg5RJTOTi++j1GN7DAyi2WoB5+5FfkdToX3nwLE0y5qvwpTTh8fSv0wVJwhGS2YkL34n53t1+nN5Rv13MRU6ENvvhjQGBkQK132+CodOp/Lv04sF6qxtxfT+EDJK2k5adV34lXU4HG5vp31c1fVoSD7y2xVfsYvwC14ohLXBVRS8LnPEeHxn530SxUekRepfojFlZhVbYWcnt/JoRxpOi3PJn22noA8lr4IhtX/aFySRvzMKW27YB4faa2SriSFaJvMElYpJUielaT4wB7yz6Z/b2egXBodwhDI3ZjY6dnRRw52qD9LIJzS+1baul0eT
 sACvfPTN
 FEXet7CzzZa5U3Y9UIuqSokkvBpxjd+rqFapCPWdqWRW7BOE3y8iNUISy/uDYVLIQEzi87xCFuA2a5cjO0PRbKJbcInf4be9ETcn9EEKeBJJ8tlzqhn1TDgKPlKrcorp+thRc5lDqAfcYrI5uMSTiJ3cnC+ZLNnUHdp8aNPOmk8pc9vPPh8GaHIyQv6XC+JeonMhdHYV8lWIMp39L30cg8/UKsjwfrM4ns6dOQVYFEdZdJO9dHk97zsmTw+HMKVuDhI9Q3nE889y/msWaQ9OoBlWHl1EBiSw0K59IcTwDr5r1c17G1hUX7vhstZV+6r5q/eZekDLJ5BcT2Q/oq8NVSNZGkdR11Me5/oNcPkBlDBua+wUVJJG+qwkCwd9lP0skcMnKIoCD5febalGCr5LigkfJT124pxQtm0Rfivm7j5l6wgs7vL4JKJdXr5f/rV3GIMJzOrtjs4Zqmpzi2KOZetQnujKrEJrqiJ3t2lD+D+dT21iFmnO7jH476BIgHQdlkb73LSeanqod1Wfk+R9LrGl+BJJPJizzlN19ThZzSzB8e0A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 4:46=E2=80=AFAM Hao Jia <jiahao.kernel@gmail.com> w=
rote:
>
> From: Hao Jia <jiahao1@lixiang.com>
>
> Currently, zswap writeback can be triggered by either the pool limit
> being hit or by the proactive writeback mechanism. However, the
> existing 'zswpwb' metric in memory.stat and /proc/vmstat counts all
> written back pages, making it difficult to distinguish between pages
> written back due to the pool limit and those written back proactively.
>
> Add a new statistic 'zswpwb_proactive' to memory.stat and /proc/vmstat.
> This counter tracks the number of pages written back due to proactive
> writeback. This allows users to better monitor and tune the proactive
> writeback mechanism.
>
> Signed-off-by: Hao Jia <jiahao1@lixiang.com>
> ---
>  Documentation/admin-guide/cgroup-v2.rst |  4 +++
>  include/linux/vm_event_item.h           |  1 +
>  mm/memcontrol.c                         |  1 +
>  mm/vmstat.c                             |  1 +
>  mm/zswap.c                              | 41 ++++++++++++++++++-------
>  5 files changed, 37 insertions(+), 11 deletions(-)
>
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admi=
n-guide/cgroup-v2.rst
> index 6564abf0dec5..7d65aef83f7b 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1748,6 +1748,10 @@ The following nested keys are defined.
>           zswpwb
>                 Number of pages written from zswap to swap.
>
> +         zswpwb_proactive
> +               Number of pages written from zswap to swap by proactive
> +               writeback. This is a subset of zswpwb.
> +

nit: I think this is specifically the zswap_writeback_only mode right?

Technically, normal proactive reclaim (memory.reclaim) can also hit zswap :=
)

Maybe some clarification here?

>           zswap_incomp
>                 Number of incompressible pages currently stored in zswap
>                 without compression. These pages could not be compressed =
to
> diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.=
h
> index 03fe95f5a020..7a5bee0a20b6 100644
> --- a/include/linux/vm_event_item.h
> +++ b/include/linux/vm_event_item.h
> @@ -138,6 +138,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT=
,
>                 ZSWPIN,
>                 ZSWPOUT,
>                 ZSWPWB,
> +               ZSWPWB_PROACTIVE,
>  #endif
>  #ifdef CONFIG_X86
>                 DIRECT_MAP_LEVEL2_SPLIT,
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e205e5de193d..7648b3fd940e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -571,6 +571,7 @@ static const unsigned int memcg_vm_event_stat[] =3D {
>         ZSWPIN,
>         ZSWPOUT,
>         ZSWPWB,
> +       ZSWPWB_PROACTIVE,
>  #endif
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>         THP_FAULT_ALLOC,
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index f534972f517d..66fd06d1bb01 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -1452,6 +1452,7 @@ const char * const vmstat_text[] =3D {
>         [I(ZSWPIN)]                             =3D "zswpin",
>         [I(ZSWPOUT)]                            =3D "zswpout",
>         [I(ZSWPWB)]                             =3D "zswpwb",
> +       [I(ZSWPWB_PROACTIVE)]                   =3D "zswpwb_proactive",
>  #endif
>  #ifdef CONFIG_X86
>         [I(DIRECT_MAP_LEVEL2_SPLIT)]            =3D "direct_map_level2_sp=
lits",
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 7bcbf788f634..b45d094f532a 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -160,6 +160,11 @@ struct zswap_pool {
>         char tfm_name[CRYPTO_MAX_ALG_NAME];
>  };
>
> +struct zswap_shrink_walk_arg {
> +       bool proactive;
> +       bool encountered_page_in_swapcache;
> +};
> +
>  /* Global LRU lists shared by all zswap pools. */
>  static struct list_lru zswap_list_lru;
>
> @@ -1042,7 +1047,8 @@ static bool zswap_decompress(struct zswap_entry *en=
try, struct folio *folio)
>   * freed.
>   */
>  static int zswap_writeback_entry(struct zswap_entry *entry,
> -                                swp_entry_t swpentry)
> +                                swp_entry_t swpentry,
> +                                bool proactive)
>  {
>         struct xarray *tree;
>         pgoff_t offset =3D swp_offset(swpentry);
> @@ -1097,6 +1103,12 @@ static int zswap_writeback_entry(struct zswap_entr=
y *entry,
>         if (entry->objcg)
>                 count_objcg_events(entry->objcg, ZSWPWB, 1);
>
> +       if (proactive) {
> +               count_vm_event(ZSWPWB_PROACTIVE);
> +               if (entry->objcg)
> +                       count_objcg_events(entry->objcg, ZSWPWB_PROACTIVE=
, 1);
> +       }
> +

With the above clarification, the rest LGTM.

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

