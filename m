Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FA87C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 20:49:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDBE86B0095; Mon, 24 Aug 2026 16:49:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8CBF6B0096; Mon, 24 Aug 2026 16:49:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7C946B0099; Mon, 24 Aug 2026 16:49:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B03A6B0095
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:49:52 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2754F1C0D1E
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:49:52 +0000 (UTC)
X-FDA: 85137354624.05.18D8372
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3239F180005
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:49:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iwbNyNiP;
	spf=pass (imf24.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787604590;
	b=IAVsCffrh4A7jCIwMbivOYatUcc+XkZbxlkerSwILC4373U9mcgNTD+4VAbUI0nZvZanAo
	yc670B8LIknWvvLmEOPicCzD75+ugrnrW0f/iwB9WMSuHlCM63vt/KyFeJTqw8gSTho+84
	U9bW/TUwyE/UPIvl6XEWka/AsMGO2vg=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iwbNyNiP;
	spf=pass (imf24.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787604590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rnrc6rgXkO/4siYHOqsGt2EqzbzE5rWSn7kKau8RpvM=;
	b=sO3u2CVseMFe+joys/YkOYvoVyjhQb3SL+ivk9i3oYT8unfRljJasw6SxA2MabXbf53bpR
	Lo2NDTajnry+E7VKxscG5Gdimli1JGijG+j0wsEB2qiLFt8nk9BnnrZvxOzMmOauuXGJ8C
	ZFSKZJOVuHxrnNPFDFXTC6VaKpFnM6U=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-51c10ed63c0so17991cf.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:49:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787604589; cv=none;
        d=google.com; s=arc-20260327;
        b=Znf6Op/sgJSCKAX/sNSzNHpTNxMNy5D42tPXF3Q5LiXS8Q7MvxGNtCUwAsicDiyA8Z
         oHytT5UaCx3XhK1x+3miWrn5Qn31YUBk1VPR/cA4CKuYciWj4dQhdJVDNCGI+LFwFtgf
         SK7HCwiuBOxtBZjbk/meyR+XCn0Q4mAAfggCV9uR2uG0EQmo6Nghxvkjk+N+tQ4d6erF
         9Gme/U8UYBOu/mbXi1zwzA3N8INgCGMckmj+mW5awC3FoHU4Xj3HJpP9p78Lk3xyZfba
         1hGhH69Fx/kNAelg3NJD18RQdmlyLHkc6RiZI3MDJARGZVY2ruH5wD+if0/Lbr+C8uPq
         MWYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Rnrc6rgXkO/4siYHOqsGt2EqzbzE5rWSn7kKau8RpvM=;
        fh=pmx3UNx47fDhOxz94J+V5/bRUbhHg6jEInq36GJimRg=;
        b=H5yFeYJO/DsLHPPBZ+fjcZ70UnF60g+pa3K0yLZ/05VGbXHU/SxNmIgaUSN0pAWSYO
         votAqRCgI582Zn4kNiPJQ8GNvdDzoOWXT7IOP6f4HGR/wFgS+zOz3AXY92btOl19+DzQ
         A0qw3SQf0NscoA9b+8M/+RVlZLsCTpSjDl+1l8Wp8BeSfCJ+OtUrIgZGaGwvTXsRngwj
         FmQJrGKWXANwnf3crGwHQ26OzgNExho/l7G41Fd7/ckxpqPjKhDMZsR8p1iRBcSOFM51
         ivUuCT97h/uCiIS8p5QoQgvSI4oZ6DjIM6r4X+H6BcYDZlG7YAJQ35zPue1XW2ezjX4s
         jHuw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787604589; x=1788209389; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Rnrc6rgXkO/4siYHOqsGt2EqzbzE5rWSn7kKau8RpvM=;
        b=iwbNyNiPMcDnEDwSgEDsFE2YJ/zrAqqiWqVt3jDGxLBgq3VkgUsvZIBFnLLRk+pEXn
         oqjJ+vSoW9wmzi99jKBh8VxHdoqRuWgNDCaYlS5Lp4wgbKGwLwWZe20KrrD6sqUAxt3C
         59LJrX37ItSTPR65iq31t2zs9zFo17kGmov21oZsiV8uqqkIRs3XmIN2nP4sF/lyGbUP
         2GeE4LHxuvmfd+YlMbIdCDk6/1SRjtJ4ZFXAlvESezsCOW0Z1p6/mEoM+0u5+Z56j03+
         zp2N1sheJr49ZdGswoUsxxS77AUP/m0r/yBh+r402z5i1eGu6NO+rmcLFW/YAQc1WJIb
         unxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787604589; x=1788209389;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Rnrc6rgXkO/4siYHOqsGt2EqzbzE5rWSn7kKau8RpvM=;
        b=TNH5c+EtaQ60NTWAnrgZh1CxULOQYiX99udpmvTXnBNRLIuYDm2Ae+vqv6j3sUcYCE
         aURDbUiwjTZMK1Z1jA8//c54c//Q0/wzeW2Vppp+zafwmG8YY2AAxEZGKp/8Z6H2xlRH
         zQ9DcBL3AuNJGTTNWjvUObCCU6K9h41+/aEkVhYNedUbdS40jlNsWxOQ2Pw5l2X2jlL8
         MAmNT4oMxs/tCgK/mvVbrTaFVW81ZBrKKdpy3m7LwId400RHjQ8IoTIxKCZ+5UMTmZFM
         ocb39SaugCY6SifeCgKkD2BxcjRvjygucoiW88818T3N4AzmHIXCl6WMbiyARbiBaguJ
         Fbrw==
X-Forwarded-Encrypted: i=1; AHgh+RoTCuSMpjNeE/hqRp2U6r8scj7cy4Y9g1zAj9MdjoFdqY8gSP2A0sGDV0VnFHg4trbznDxATF/kwA==@kvack.org
X-Gm-Message-State: AFuF++mG263bai4xVufLLjaesRj8dRjTk0qqHDsCXpXto9RrN31+Lw++
	s7tdM2B6nIyRWwT/GcoWlvaTnhLKwTM9u1f4+DK0Pl7g53sfjp4Y+TpyA71H2+a7VpNnEmb8nuR
	p6GTwBZKUv8XyYgrElRWjir5tkzcnbow7LPUvNH3+
X-Gm-Gg: AR+sD11+77wF75HDH/DPSA7gTkUSHyh0QAdTaDV0YUOxCnWj9UFElX+q1gLnyWVg7++
	KhTTRAeHNQXzv90GOrLJa8/ewk6e1faHU3HXgpZm3lYf0XWlatHJte3f8jDUz8PYprQTOceOH3p
	z82RkWl9+iabMYAmvdWMu9zfVeUIOD2ll2fFYzvLBJOa68e9NeORodFWP7SMraI0HGDdDZOT8g8
	dB89E/nUyjEUmLPa/mraJobt+e7hlonbOYBeSU96Jtf5OTzYUWeXTCZFI1/beHzZhq867DFwqiA
	k0A0vBRcybESFY+uV0GtfXKoBgz1rwXa/p7JNGqImco=
X-Received: by 2002:a05:622a:22a8:b0:517:5e32:2d14 with SMTP id
 d75a77b69052e-52e308039c6mr3439151cf.10.1787604588512; Mon, 24 Aug 2026
 13:49:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260808200312.6326-1-kmehltretter@gmail.com>
In-Reply-To: <20260808200312.6326-1-kmehltretter@gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 24 Aug 2026 13:49:37 -0700
X-Gm-Features: AcwNN1U3QleQBnvzJTMW5EoRgp4utl8IsEYk7xBRzJCJAaM1F0xAu0phz7nBY1A
Message-ID: <CAJuCfpGTneUdh6xvZoeds0xt0Y=dc_xgOCninwqSv=HzVnPvoQ@mail.gmail.com>
Subject: Re: [PATCH v2] selftests/proc: make proc-maps-race work with READ_IMPLIES_EXEC
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, David Hildenbrand <david@redhat.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, Alexey Dobriyan <adobriyan@gmail.com>, 
	Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3239F180005
X-Stat-Signature: nn3479wquownqgkmnfnh1qx9cikg8wsw
X-HE-Tag: 1787604590-376834
X-HE-Meta: U2FsdGVkX1/dT2DEVWIEfvxDvvV0VoOKQgmQkaKl+z9dyDm/zJ8ICIt8LKyOtYmXmHGfXC69qkBxCbatJIWf26Roan8fyEWs9PxwHuSl5SchseqJ1t2eKMbV0zMa/77OPGDMq87VBukbAsLMx+XzlAVop3YHMxk+RhfNoiqS7P51atT7xOtXTz4KPnD7kJVxf1uQ9CEN89vnctriE3uulHQoD7xajDH3Va87oCaQ1CQlxquWUickFD+ACP0lWVlXe/ibKS0NjSquzQducRN7y5G3Y0QwHoxHLyYeg8I31XRpD/gs0Q8FvItY0Ve1SclT1KQXmyu9haStfbiSjYBJ7bnxTmRnTpKsVn88J5H2I/CnYAkNEra689Qd1/nypysOz7SI2UzVTkG/ASnQ6FUWrfmYkm2nZObqAdAvX1kw6CESk2m7nOSnsopPUG+RCtwz5C1lz1KtEzZF5751BlEgR1jdeAWReJrHWQYr8G198EbvGfv+MnHPzsFum/x7zL5BH8sEXC7UQog6vGhtrvUvLPHfsZbC9rHp0dKz1UAljvW4DXjv1O2AoZVsTp/+ED8ZeYtyxpDFcLv4HAcNV6bTJfFdXux8PBey11aXs/cN/8tUzs1HCiPfqdieWlt7E+jFV+wOBox0HzgoKVHDp7sgQjZTZZImnDYWswERqPx7ztQkbUIymIOguwQfxm5pcMpZSHRgmTfAXQQbjHI7+QsYYr4MU4wsOOl4TrjzexXtsRpmDdcCRhMmP9csTORAv1gYYCWlc6VCHTNn8VvB7mq5QJ0IYpwZ0p3j6IV/p37Ha7ipBYKYANKzWuuX7tMgewMKJaTr2eKCnUzl4+Mt3PCV86d7uJZcD8I2VWzENKzXN5jZPs8WKSKWNcXu6BUimPLuwwoPq0ky4b5oEhG1IWyXZ04CrLfhIWmrrzkH1gIOUMYdMOU7TBzvdQhDc1FUDtDrm74qm6FTUUPNB/dLJqd
 zx5CtHSo
 t/OAOxnXTOm9pyO0AqfDSZQKSE51oN7neuYrUuIIj8vdfywdNG/zAiAZcY+9DqD2kALo9K6Rs/bZH3qwaxXT/xNUaOdZ5gxNPCRYRuwpZKqaVJ28G3IXrWYX/X61/fKGx3SNTffKF4ZmQY4vHTz/Fg8lyRxmhVATWjbWVB+Dn4REjZS4V03JhrkkZKLzksncQkIKtjunIw76GEx6GDGv96iX8Cuc6RiAM9z3JTpnaulj++8kshzXH/KCFY3Bvyo50r9uYDwsd1i4fDTIt8OZGxrIMj1PZE/MXzzE3ByECaM13qTBwsZQovBj7PR8z5wOS3T3umcU9bamlfVdb6v6BYMYEhG8OJHL9ZuMc1q1UOG+n15A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 8, 2026 at 1:04=E2=80=AFPM Karl Mehltretter <kmehltretter@gmail=
.com> wrote:
>
> test_maps_tearing_from_split times out when READ_IMPLIES_EXEC is set.
> This happens by default on pre-ARMv6 CPUs, which lack no-execute support.
>
> split_vma() re-maps the first page with mod_info->prot | PROT_EXEC to
> make it differ from its neighbours.  With READ_IMPLIES_EXEC the original
> mapping is already executable, so no split occurs and the test hangs
> waiting for the modifier child.
>
> Use PROT_NONE for the split mapping, which always differs from its
> readable neighbours.
>
> Fixes: beb69e817246 ("selftests/proc: add /proc/pid/maps tearing from vma=
 split test")
> Assisted-by: Codex:gpt-5.6-terra
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>

Sorry for missing both versions.

Acked-by: Suren Baghdasaryan <surenb@google.com>

> ---
> Tested on:
> - QEMU versatilepb/ARM926EJ-S: maps and smaps fail before, pass after
> - QEMU realview-eb-mpcore/ARM11MPCore: maps and smaps pass before and aft=
er
>
> Changes since v1:
> - v1 went out without any recipients in To: and received no reply in 19 d=
ays.
> - No functional change. reworked the commit message.
>
> v1: https://lore.kernel.org/all/20260720061835.6290-1-kmehltretter@gmail.=
com/
>
>  tools/testing/selftests/proc/proc-maps-race.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/proc/proc-maps-race.c b/tools/testin=
g/selftests/proc/proc-maps-race.c
> index 1026d8c400e1..415eccb70468 100644
> --- a/tools/testing/selftests/proc/proc-maps-race.c
> +++ b/tools/testing/selftests/proc/proc-maps-race.c
> @@ -490,7 +490,8 @@ static bool query_addr_at(int maps_fd, void *addr,
>
>  static inline bool split_vma(FIXTURE_DATA(proc_maps_race) *self)
>  {
> -       return mmap(self->mod_info->addr, self->page_size, self->mod_info=
->prot | PROT_EXEC,
> +       /* PROT_NONE differs from both readable neighbors. */
> +       return mmap(self->mod_info->addr, self->page_size, PROT_NONE,
>                     MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0) !=3D =
MAP_FAILED;
>  }
>
> --
> 2.53.0

