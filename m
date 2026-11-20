Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71A11606A691
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 21:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=bMVLvqxW
Received: by kanga.kvack.org (Postfix)
	id 365C96B00EF; Fri, 20 Nov 2026 16:14:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 316976B05B0; Fri, 20 Nov 2026 16:14:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DFD76B05B1; Fri, 20 Nov 2026 16:14:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EB09E6B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 16:14:32 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6E1F0C0157
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 21:14:32 +0000 (UTC)
X-FDA: 85456751184.25.44AFA2F
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf07.hostedemail.com (Postfix) with ESMTP id 75F8540004
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 21:14:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=bMVLvqxW;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795209270;
	b=wXyrOu/F+0fPcwzAjUphc/OSsGK8IG0X2Rv5jq+X62OqqmJb7NKd8wHRzhqrdjHOeiZkZP
	ArPfkFmidpIQ0DIGKnXhfoXUi48QI+6tb8LI12yXSLTLwFrSOP4LO9cUapHRv9vlg/YGf6
	lUixL8UddTaHthgiAClrvvnwooTV1fk=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795209270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G105/EwTftSMSsJfJTgrHQWjcbh39Voo9ViZSiMzFbs=;
	b=C8YRW4dkSgiAizqluGwVyeEYxpJU549+J6dpQhYfoPbqSdjkwuS9W0nEeNGk76XRrMQ2Ah
	1RpDmrl2ujAJmnzH+yi5Gmjdn9Bhp6Jo3yj9Dxau4OEJECrVOEXcpVIUb0Yzj8QbmNV83a
	dFODRF/KhBvUIldid4RffAyNsuvtpM4=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=bMVLvqxW;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-55c7445cf85so16201cf.1
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:14:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795209270; cv=none;
        d=google.com; s=arc-20260327;
        b=GkYM1aH/JdWj5362L+vf0elO9/T8Wbs1TYQY8mueWooxZ9pzxL1elZ4u+BfrXjYp2v
         fFTtpAifbOMhpA9bWv9JVeSg4McrlBPTbDgPB0M8/OBItDdzyD04q8B9Uz0onRBH403/
         4YYOcsHd5z1tIdMG+Lqff1s6VyQRknHCFdeuhPlrd20YcqoPXvgbmXyyu1TPSahrfcUa
         bPx/xvEvCgNk3Z4jDyFMgTb5MbddEUWzB8KcUCFzyXdIQCYTVuOILz/3me755YcKGXb4
         pJ2MXmBuqvbw27zPr50sqqbk1cBxBqvthK3vFaH1MFq3/LxyXP/goAfFl4uwjN/SMkWf
         grng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=G105/EwTftSMSsJfJTgrHQWjcbh39Voo9ViZSiMzFbs=;
        fh=MZ6TquiqOb2Wtnsb1e3I/Uj79lUo3shHOV/4eAn3hBI=;
        b=AIDtURomfxz0EXOEq8uQatoCGwfZPL79fQvDWvi7Q2rmE+ME0TuqVnkJhB9zHZ7Ddz
         OLAFBqvtqecEg2QJm+yz1lhFJdfmr+tj8QhiEWca8/ASfWXT/ZkMCujlB1Zj7u9E9uje
         LWmmALSppO2ksA+xMmjFXRGPRDEe2PQKsg3dy74klpGUmZmH5XcRTLaBD+evFK+LcadV
         KG9NvBSI7Lj2wMkWXWe8ppPkqbjBYPYAVU2jAukDoI1dWbOlymMz6DjLBAZR9u9tIsmd
         LQ06MsSJ4+fQsu8xcZsIsGv7fQ6CgkOdmPb8lVYAmGuGHWLaUxLruYgTExH0kK/GL2T/
         DrdA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795209270; x=1795814070; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=G105/EwTftSMSsJfJTgrHQWjcbh39Voo9ViZSiMzFbs=;
        b=bMVLvqxWQg8GGqTc8N4bQm4jFu9AqFkZN2oRtHU2t3n8N7K0L9etQTXss9MsHn54In
         2h1oQN4x88NbgRiJP0A6tGSAuXWGr3G5FfgqaaFsL0tYFv7yUpqK9V7J9EHnOlgz+zd9
         Ys2DGB15YE+mg0I/6RnUZNmI9z56Qx3B8WlBX1aKCQA7/J4LLlA0VoZqE5qMOtbeZ2X8
         v45T27hBpcO0RQewczAA9/+iG7vZ47488/qJsrhFYhrLOHxZzOmlprMdFM5zCxN56M50
         No4Z68PXas8ijS3tPOG/rnLH+VrR/O/ROKztk2B2bzCuTcD4tebCqF+z0iEhwIPF7fzp
         1Z8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795209270; x=1795814070;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G105/EwTftSMSsJfJTgrHQWjcbh39Voo9ViZSiMzFbs=;
        b=2iq7z3pYIkVBrkAAYfyIGRZWmPaa4sPXUQEX8azYEifiVzaVnpvJICW5DuHQscn4cO
         fyi0rkA5jvQ6QmTqvcogmQ8pGZeMdRZPjrAIuu3pY7KN/Vo41KxNwvDGkxcgTjXRW4Jr
         eoAhZJ6Jyl3FFPKIQy2xxhtcuTMru+jXM+gEQAAVivwT6wda4kY7hyPtWXgprDzX9uwe
         IQG2swiE42gYHJmunCgyU48y+Ni5UlGTtQjGcZrKlx6QOz31yr9LUlA2Qtv1Bc9D472I
         NaOSAn8BCrsh3481/5S1I0iTFZJMH+I+vvRKFIOJfKP/ZUwQO5Plc/HiKkjuOAYALC1E
         KfxQ==
X-Forwarded-Encrypted: i=1; AL+hErGvGwqoWPx7ScFVoMTUa91UMZ0wvK25Gl1W+JuYOxkQ24H9LwMXipFqetpLcp5dFryM+8XU/wcpDw==@kvack.org
X-Gm-Message-State: APuU4Z9/i64NRhE/Ek5Y5LBuB+OfwbKYoR7eBiJgl8SunJR4p4ajEYOk
	Alq+eQgtDuuIYmOKvzJ9dcY44e0oNDdlnqhn0GzRWLoLkScisI2natKy85jb/qJo5/mUJFoKPvm
	E1LD3uDnHDbSeEgSxEvCpdophGHZ+S3Yjj3milHcj
X-Gm-Gg: AYBFou2dMinXMfI8AhnjQzZvIBmF5HWcqzCqgpbN7qwqOtDZyh2/Db9YQWE4YCkAEDw
	iLXA0mmfx4rbx5gCfgyhzMEWM80L5UYUnkQoBZj/4mt82tztSxGRS9U6pJM5Z1ZTrXmBwZQ0KD9
	GNHPrCpAjhdloayMtUVvxypm0ZbZ99yfgS/40QKIR7Jp+Jpcxc5EYI7EBw7cSxjEZBd3a/Gbexr
	8Y7YGYYIJLv5nHDDcm2zipQw5EyVwYjuAg/0ngA16GyywND/lqPTyMG2OlRq2QNwBvFR0qp1T8k
	VLSBaFX/3pyAm+7WO2zKAfnH5vFeQWxiqyXd9LGdqP9KDWp/BVOBJcDiMz0vIcOqMFjJ8hC09mh
	GSQYSawJ+FA1YrfGJSTkSVTzL6kV18lg5Jpq2fxbL3hYI9EDfZeA/9ayjvf+FeCZLGm38kUwR8u
	9VlcUWEHZ3EfZbidXyv6SEPu1z
X-Received: by 2002:a05:622a:c15:b0:530:e335:4ef with SMTP id
 d75a77b69052e-55d88014944mr3792091cf.2.1795209269050; Fri, 20 Nov 2026
 13:14:29 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261116071325.263682-1-hao.ge@linux.dev> <20261116071325.263682-3-hao.ge@linux.dev>
In-Reply-To: <20261116071325.263682-3-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 20 Nov 2026 21:14:16 +0000
X-Gm-Features: Aa3M54plrOc1jkMpHJwvUpjhSrspGdyrmpubZwGwGNbiFNMddwdSWFYtVtM3KLk
Message-ID: <CAJuCfpHOZS6mp_no3wKmU3-S4HKspnbriUw8Mwtxf3nmw0-pfw@mail.gmail.com>
Subject: Re: [PATCH v5 02/11] mm/kmsan: undo the shadow mapping when the
 origin mapping fails
To: Hao Ge <hao.ge@linux.dev>
Cc: Uladzislau Rezki <urezki@gmail.com>, Dev Jain <dev.jain@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 75F8540004
X-Stat-Signature: 1k4zidkatnzs8emmr9io9z98ieqaoe98
X-HE-Tag: 1795209270-859339
X-HE-Meta: U2FsdGVkX18tMCPjgRhZmGcAvStkpSIEWUTBWtS+4Vh2vZKqBh5ewyv5kbZsJJAJUx+2n+wClNKzxFAzFGLw2CGECQf4LxHQP47NBEdOHh0oxh+v59IIRxj3OMjMgTzLfXu/fD4HhU2uvyNl6hUWv4Jg30AcXV7qxjfAlfIoVZdz8vJMnORMviP7sswG4QNjXe6UF/IXYv+4Wte/xYk8Spj9/WD8Qwk6ppzMPmp33+wjBeucPVbdhxVOsIJjO9EZblQ5zKClBFbTxotirCZWeOnzGxjIBe1iEmKt+wmo9Bcgv03lKYs/X7lbd3CIZtIqGuu5B2T3YaERsZh6SEl8563K5npoZ3lSJUd80+TmJ/LRqFCx5JjisUJ9SiEn5uPP8rbfIFnditwCVJ9gwhlHqWVr8IqxHYw6tPDVRYQZZrQ4JSi48c21gdNlgjsTzh6gmG0/Wjhz5OrG8YnpcfwlVmKmWM1SG/HUeCPoxZtIHEAWZOi+NJn37Xri8lYPEgoJrRNAc/7edtgMdMqTtfOGiLqC4GNbuzH9HUGFw67qkT7UPCtqwXOeby3plhjB7JVIlArPdvVV9xbTYH6r1t3GYa9zgTupKkcHC5X9rQwBj1NTFa3nhx6aeJeuRUbYGVwcWMqaFmOCQrGwwaYNSac4KgqAlzYiVt0shCp6wMljGAzUxdth6eKIeDwEL9cAniLHeC99WbxEFEeB6kVgZSRYZ3MTugIQArNZgiaepQY0DSEW8vvPr3/6u76Ylij8Db0nsdNoaGMVZx9D/inzSwEhFVJEs81O/qtZojo/pLt3PO2WIZIR3mGZU7E+bmyNlG4SHWBsPlBEeij/duylrXW3t0s6GJVHicQlDtZCL7ct15owMTbjnjA8j8Hb8HzgUV+l2riEyWErhV9YNm0cz2mTBo2smzUzDobcsfwp55RWiS/6xcA06AbFS0LszxMLCdnWY4CSgCUswiKFQ2ORAKo
 gMAVIiqF
 bpjXcKpmFJaID+L/RvBTV1NlFp0QCNFiEdvEMW2J2CO2FSBmne7sSvfF5u2JSx9Rj2jIL/9lAXHDGZ0LjpWnUw10SzNYoO/dmKHlAi684yUgpqMdTrmumLeq0TVZRHBeLY1ZFujwnXC/Mq9gaO2OvDBCBZ+g07TwYLR1bZUaBrI7s2enWF7epcFfJX8vF78Tut1roBxsKimh2SDSunQ7SuvJpNIR2WEeb4mmwt7nfHsUcV+LXlGH7wZlYWEfiyACkv3IHPpRkiaQ4KcqK2Gs4Sqb/0uHD5u2BHfBs7/0Vvobj4T9OHlh17uSam8ljAsxioag8owOYry14zmguuzBqDz741lwZSr88OiL3TEcZhYQ8efLhjLYJCG8L5ZSn1OZaPoGEa8N8bg27iT1opYiuhQxqkb4bSJcHtpOh6wAfpeNiWPjHqzzlOFOxEML2fn1A3JfO79OOIK4/az6rhJA4XWVZFY0vcClhWgd+GEwHlUJF3woM0ge7rKNyOElGJHRibpX3YEuaRGTZMN5ChsitjklF3B+ZymkhD4T01/9vc3AiezXWCdhV6PJwRwnjTKS59mj9y4YDnwh6c5iu87+EMf0G6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 7:13=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> kmsan_vmap_pages_range_noflush() first maps the shadow pages and then
> the origin pages. If the second mapping fails, the first one is left
> mapped, and the callers do not roll it back. The next vmap of the
> same metadata range hits the stale PTEs again and fails with a
> WARN_ON() and -EBUSY in vmap_pages_pte_range().
>
> Undo the shadow mapping on that error path, the same way
> kmsan_ioremap_page_range() cleans up after a partial failure.
> __vunmap_range_noflush() only clears the PTEs; nothing has touched
> the shadow mapping, so no TLB flush is needed.
>
> Fixes: 47ebd0310e89 ("mm: kmsan: handle alloc failures in kmsan_vmap_page=
s_range_noflush()")
> Cc: stable@vger.kernel.org
> Suggested-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Hao Ge <hao.ge@linux.dev>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/kmsan/shadow.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
> index 0c88d89bf0d6..212449db34a1 100644
> --- a/mm/kmsan/shadow.c
> +++ b/mm/kmsan/shadow.c
> @@ -258,6 +258,11 @@ int kmsan_vmap_pages_range_noflush(unsigned long sta=
rt, unsigned long end,
>                                             o_pages, page_shift);
>         kmsan_leave_runtime();
>         if (mapped) {
> +               /* Undo the shadow mapping set up above. */
> +               kmsan_enter_runtime();
> +               __vunmap_range_noflush(shadow_start, shadow_end,
> +                                      gfpflags_allow_blocking(gfp_mask))=
;
> +               kmsan_leave_runtime();
>                 err =3D mapped;
>                 goto ret;
>         }
> --
> 2.25.1
>

