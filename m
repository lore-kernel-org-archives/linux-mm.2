Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DD58CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 17:43:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D5FA8E0018; Fri,  5 Sep 2025 13:43:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AD578E0001; Fri,  5 Sep 2025 13:43:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C3918E0018; Fri,  5 Sep 2025 13:43:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5B4DF8E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 13:43:41 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 03525140352
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 17:43:40 +0000 (UTC)
X-FDA: 83855919042.02.A55ECE2
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id 137E8180004
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 17:43:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SLUpKRVv;
	spf=pass (imf06.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.173 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757094219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cYAcYUm2desKUIWjDcT5mJIRYDoJyqLayOEtv1fT6T8=;
	b=CeCjW3Q+nGN0w5dyS7fGQ34vf7mRv383gRt/9bW817lAsPJSZVIwTBuK1RafYAHPmQNBxU
	jAvWjH70JUFg9+gp4eJFOXe2xjZNWjZ15BERqqofQy7pv+1IMBGjrM3SWWeZB4aW93RZ/k
	Ges2PJij834mbXY534CUsGI+wcnuWYA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SLUpKRVv;
	spf=pass (imf06.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.173 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757094219; a=rsa-sha256;
	cv=none;
	b=xVoFgs8jGp5ffWoW81XOIFnCUSC7xWp0CWhiX9LzC8yuqbAp40yQuNdh5CNbmkFnqO/eKZ
	Q6eEo2mPXA6Ss48RUNbdViMnCX/HdReLF6ZlAuuejiKLZnXyoWYYZA1cTPqIbi+u6SxCI1
	odor/qc7ioUp5aiLSI92Kd3e81R2O2E=
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3f2b6e0b938so17929115ab.1
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 10:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757094218; x=1757699018; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cYAcYUm2desKUIWjDcT5mJIRYDoJyqLayOEtv1fT6T8=;
        b=SLUpKRVvQ1yDMZAo/Yf+yXZ5lxodjOWGYshmQAMxGKCE5rJbVkFgZ/Uq6Z5Cdng1h5
         v7T05+jySEmdZtRLnwaJb4nccqmVd+T5VoPrIE7VGSx5jV32nrbKIdYcATO/sn2MQGDP
         FwFuuXAF+/Je6hxQAVV7jHyuMN+LY48c/0/S5v3gq2CucMdw0648MBgUfDWWgqJnJFNb
         LrMKExX7RYzR94mO6NnGXMxDlzuodbRJEXUSjvmIbqhszBcItD9mRiXkp2lsfoQjxjiC
         Z/fVZi0N7t7zDdVGnI1BV7MkaOPTdkyfNxaGuomt7j8yXvKsVs3PFN9KXd2N09TTCJAL
         lMaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757094218; x=1757699018;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cYAcYUm2desKUIWjDcT5mJIRYDoJyqLayOEtv1fT6T8=;
        b=jD45nZNpRvDejYNEgUvT6Y0ONjMhR5TSFzNoP9OTdKuPgrzvzyvo96YfAHtQD+dwLu
         b4du5X/aGDzjjp/4+M+XVTR7GFub2s7O7NawaVHj71rH+/86oJaXc/f+lcbIlk4HVPAM
         ALCV47IHayytXN8aN87V8DyAmg1o/kfZNsnbAp64zNAjJ7nS7sWhji1VbWafrvNiPfgn
         M1Cr3gFQCwIckMujl6pa4SQqSzV2fuEZshOt7XvZJlqt9Ql2z2Yr1jnR0D6vvqebJZlM
         MuJzbMoTk2VV70ExMEcdxzwVgHRdRpNJOgcuvA1HcHayXpkM9dgTlzRHWsbXh6nI0Fot
         O6tw==
X-Forwarded-Encrypted: i=1; AJvYcCUrNL+v01hT/CyNuu/5XV4gjYml2a5sR2Q61RrfKKv0kULLD0/QfxGaFUDZ5deqWqmuAZI+K9+SdQ==@kvack.org
X-Gm-Message-State: AOJu0Yz3atDyWTOowH4SAmeUGEJhISHgO8gLNXTEbMbJM+CVokTFJzGT
	yVKMhypDY3FBst+6CEr/u4x30+TiktAiiYnLGngC/iH/21LkL0AGPGwA198ViDyxWa9KbmgO4Kk
	VYJwAd1f8aG9wn2wgrHFbd3KnukqMRR0=
X-Gm-Gg: ASbGncvPgIYIbahVYzQMEU55b8By8h0p+AyAnUJVf9YpX4ov/bS4tG06HHcZnz9c1lQ
	ZVlkl7XjbIwayCB59fRKOMC5ccEWREi3EFsnqv7nQTDGMtSceqcBH7M4lKNcNq3kA8Nmq+SYYaN
	hne7ui8ctbG0Iku31DZtxuIM+EYaZpT7sx1zHHcucqlJxkwky72A2C24qH5pbTVhwbLkhzPt3iZ
	exF4g3WPM44q/0=
X-Google-Smtp-Source: AGHT+IEwEjYO6pbdTzpOQwwF5PJX1YyD+PzcDAA6tLXdH03HNNfX60nXN+2m4+GA24ynohbZGrQKBMcpA2LhAMJI9yA=
X-Received: by 2002:a92:c267:0:b0:3f0:70c1:2ca9 with SMTP id
 e9e14a558f8ab-3f3fd18b311mr363966335ab.0.1757094217951; Fri, 05 Sep 2025
 10:43:37 -0700 (PDT)
MIME-Version: 1.0
References: <20250902-show_mem_zspages-v2-1-545daaa8b410@igalia.com>
In-Reply-To: <20250902-show_mem_zspages-v2-1-545daaa8b410@igalia.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 5 Sep 2025 10:43:26 -0700
X-Gm-Features: Ac12FXzDLYaqMKpvmLPOXMb7wIRAdgl5L2hjUr5ikag9JEtMKW0UJSmOz8j3uPA
Message-ID: <CAKEwX=Pa7p-BvHCj_JGkT2BcJsLpw+AMn3zvLjoZEGxZ=x3M1w@mail.gmail.com>
Subject: Re: [PATCH v2] mm: show_mem: show number of zspages in show_free_areas
To: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
	SeongJae Park <sj@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-dev@igalia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 137E8180004
X-Rspam-User: 
X-Stat-Signature: nh13tiwahdmcagw3f3m3tzhhekp9z9hz
X-Rspamd-Server: rspam09
X-HE-Tag: 1757094218-700188
X-HE-Meta: U2FsdGVkX1+Irgveng+hoSgRKACrufKLJgdc16DmKJHQBrqsVf1qycd4QhPahlIDzOGoi7fB8hNTTsIaHM0pYJZ1v60RzuFJ4jBySHWUIIzYAwspUSXYm6N7YochBhhv/4wAZV+MeafbQuekrlaeiR9AHv5l2AF9UA4HBTTPv3o1uru3NMy0c+Q9lg/GRAKRSCzQsiE/PE5ATWYMYCL/GfAmMRelspZ3aOxZGrQA+Cu97u+hZiGyBkyH4/M1i/UnwPxvdDzdIZJFGLKb3wlYwO9lEN9c5GOBKGFw4m8w4hOVBmiymm6L+Ag+1IrT8WAVwzB+9NIljEjzSSOeU3UHmHbgEvYMVGLpAGAfFlLlPjBbNl2YDAPhTmum1jJwQjDiw+1VEkuV6BaJCQ4FbpLkgtt7AQYK89mkVdHZpYiCRLcIykQEhL1eNHQzaMeFl0bNUxQMjNOJAI5oO5vKygECnYC/XgysTJo7Bt+p2dCaHWDWYQ+rQFFEdl66WiTNMguKUsft4zgI9udNCeBczY8yPNL3ZoLzsn8genyhiA/dW3zHvGshPuS2/ZHb7s9lpd4UejhKhDsjYpq3yW/kuaZqDC/WJnx7p5tTI55LthNtD+soIH+I/mLhVa61PW1k3gktdj+OF4tnNXScCGHt9IbsCmGgVkyoLPLPk6RqOYGM7JEUDON32rX0QhYRMsDLEm0i+asISEi1uBSVCEBxJmsFlfeeL4HKoCgxkOaui+/7O9q/buu53yH4Ow1HOZhz/NUOZ49Qh18BykYrtqv0Z12T2fxzex99yqo4b7hBRM9rI/DVA7+FqOYdjwJn/IDsS4YbSi5GYnjuYdtUnOL/f5+wbZFQL/cELpTqnwvqc1ZaLERKsuMqZfADYjNNrp3YgLO1gwYBms3rMXGMORDgsI+3BwJeL5WsW44MWxiGXIdigOoT2FyBnToK4SgwZ/yLiqpUOkOWcDtk+lss+WfND+1
 WrPp/6r4
 vz4iU+RSUsXNzXzQ3PjwQy3Z5fvQaeJJWSInP/LwkU6t/VgSHY18d3xRz820mBwmAWzb7QQ6iKC+MGsoggsAJsVoLzd7N/yAr5+7AOi1Uqa7WOsNGA1goY7YDFlyZYVKvA3xmJvCb0ABFa39V/hSg/hl/O3raNeSLBsxs9YuBWMiYip8nVctxkUqzgHoltIkBQ8hOxghlBaJAbRebGZK1l5XTMmSVCSjqHIjIGvmhVU2SOQxUEZvTiNEAueUwOAlrDlAvQgeJh8D7spJuonpzUF20RpmpfPyTIS+C2syJMykpvQsqszdFI96bM33/pR8o8S9sz5Rc6vo/c9sbFZ2US+oq6R/DoArDNPnR/sWlNzuDbHHllZ0bNn3FV/B6CQuqpcXtIFHKXc8Y/7YIyg0eylxLETdHnSwx8XVuJlG6ef0QVtcQSyRaaP5KQ+JustSbdWJE7J0uVzyCeyZ94BZ6VoxTGE/jMvNURPKr8PEpX2gzGmc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 2, 2025 at 5:50=E2=80=AFAM Thadeu Lima de Souza Cascardo
<cascardo@igalia.com> wrote:
>
> When OOM is triggered, it will show where the pages might be for each zon=
e.
> When using zram or zswap, it might look like lots of pages are missing.
> After this patch, zspages are shown as below.
>
> [   48.792859] Node 0 DMA free:2812kB boost:0kB min:60kB low:72kB high:84=
kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inactive_ano=
n:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB zs=
pages:11160kB present:15992kB managed:15360kB mlocked:0kB bounce:0kB free_p=
cp:0kB local_pcp:0kB free_cma:0kB
> [   48.792962] lowmem_reserve[]: 0 956 956 956 956
> [   48.792988] Node 0 DMA32 free:3512kB boost:0kB min:3912kB low:4888kB h=
igh:5864kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inac=
tive_anon:28kB active_file:8kB inactive_file:16kB unevictable:0kB writepend=
ing:0kB zspages:916780kB present:1032064kB managed:978944kB mlocked:0kB bou=
nce:0kB free_pcp:500kB local_pcp:248kB free_cma:0kB
> [   48.793118] lowmem_reserve[]: 0 0 0 0 0
>
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
> ---
> v2:
> - fix build when CONFIG_ZSMALLOC is not enabled
> ---
>  mm/show_mem.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/mm/show_mem.c b/mm/show_mem.c
> index 41999e94a56d623726ea92f3f38785e8b218afe5..c563d9adfa87765a8736e91c1=
f68d824b03eaea8 100644
> --- a/mm/show_mem.c
> +++ b/mm/show_mem.c
> @@ -310,6 +310,7 @@ static void show_free_areas(unsigned int filter, node=
mask_t *nodemask, int max_z
>                         " inactive_file:%lukB"
>                         " unevictable:%lukB"
>                         " writepending:%lukB"
> +                       " zspages:%lukB"
>                         " present:%lukB"
>                         " managed:%lukB"
>                         " mlocked:%lukB"
> @@ -332,6 +333,11 @@ static void show_free_areas(unsigned int filter, nod=
emask_t *nodemask, int max_z
>                         K(zone_page_state(zone, NR_ZONE_INACTIVE_FILE)),
>                         K(zone_page_state(zone, NR_ZONE_UNEVICTABLE)),
>                         K(zone_page_state(zone, NR_ZONE_WRITE_PENDING)),
> +#if IS_ENABLED(CONFIG_ZSMALLOC)
> +                       K(zone_page_state(zone, NR_ZSPAGES)),
> +#else
> +                       0UL,
> +#endif
>                         K(zone->present_pages),
>                         K(zone_managed_pages(zone)),
>                         K(zone_page_state(zone, NR_MLOCK)),
>
> ---
> base-commit: b320789d6883cc00ac78ce83bccbfe7ed58afcf0
> change-id: 20250902-show_mem_zspages-d090ea0bd1d4
>
> Best regards,
> --
> Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
>

FWIW:

Acked-by: Nhat Pham <nphamcs@gmail.com>

