Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDBABC5AD05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 23:12:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DF8C6B008A; Fri,  7 Aug 2026 19:12:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B6C96B008C; Fri,  7 Aug 2026 19:12:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F4626B0092; Fri,  7 Aug 2026 19:12:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C05E6B008A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 19:12:43 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 633E51C013C
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 23:12:41 +0000 (UTC)
X-FDA: 85076024922.04.8D67B0E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5116FA000F
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 23:12:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sx1xihhf;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786144359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dowb5rrx8aW14inrtue8QbnzaOrLHhcAjLJTHw9fDKE=;
	b=LTIhtif1KDRIVWvHfktt0Ctp/KkEXkY08Wfb08g7NZj5teHl4Sf7Q4AprKWtqpJbV/qqCI
	iNpywmWBxAM6vhFUFBt2Yt/ddnz3bbiXrxbVBqUKINYc6KdAsWZ3SX++d7PykmwaQAKMf9
	NA4I6pQP4r6i3I7UvahCwieWmJ9k/w0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sx1xihhf;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786144359;
	b=r25+N8WCIG2TLTHaXZTDCSFOKGy/CpbFAjxJKsX4ZbpInwILThxxYWriSRO9Chz8k+3p4a
	u47w54Ovh4xkkJR6dNtwL8Fxc6WiWmJGCWLjgiDUjugqltkxBlsdto54/C31iNcfY7H0AV
	Obf9NCTI7ghyAzBmsPbxzFobHsrIbmg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 84E9044018
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 23:12:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D861F00AC4
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 23:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786144358;
	bh=dowb5rrx8aW14inrtue8QbnzaOrLHhcAjLJTHw9fDKE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Sx1xihhf0wT2f5wuIdqdslNoo79JeZYANMuu3iHBr1z2F4U3R2eBFJme2r69fJtAK
	 i38MoVFaLOLJIR4CUiNdpMEjKPbyF6gpYFOsJ6AIRpuvDyaZ/qVRiJHAcxTfxpRpdi
	 yEn/iqhorSfrYD6lUFnzooKFm/o6NPXkb0HohaEJxML+wlSbep/11gL6Cbuteb0XY6
	 YxPUj3IfNBDbvStDd6yrYwx0VpnCB60hWz1//KL3gk4Kehl9FyuykZUb1+pL8pkVuE
	 s0LLKqRqiYfe/oihngFhKGP9DFOqHXq6VGrjqP1miEty0KDA3v1rMBYsXeIIMPuzGV
	 YzcZr35plXfLw==
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-902fc790cd5so25466d6.1
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 16:12:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RodrcfMlEYjDkL5bAEjZHr1uNyIPVaCYX/nPIGFbv3hpCuPcAugfM0G8W9M1rbcco9r5DkX4XflwQ==@kvack.org
X-Gm-Message-State: AOJu0Yy6QM+7zJc7It0PR+8mQGWjSLwymIYl+UiMcYcGj/2HwOtifnzp
	wfs68lsMADqLM5SS1XukzFYgc6q4bkuw1MtltsGjEv3DCMFUz4i4KcKZwx9QxDxCeVF+mNh4O4z
	zfF8vB8G7IhHjzuZnZLtRv3rRAoJrR+g=
X-Received: by 2002:a05:6214:260a:b0:8de:9230:7c77 with SMTP id
 6a1803df08f44-908a2d25988mr105511476d6.25.1786144357815; Fri, 07 Aug 2026
 16:12:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260730122304.2496440-1-xueyuan.chen21@gmail.com> <20260730122304.2496440-3-xueyuan.chen21@gmail.com>
In-Reply-To: <20260730122304.2496440-3-xueyuan.chen21@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 8 Aug 2026 07:12:26 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zo_uya7-iFS85W78+mpvjhmfxp7HfxTPKDD=Aiw2c1vQ@mail.gmail.com>
X-Gm-Features: AUfX_mxCOwjxKm1_zD7yUozU-Su7wX8R2bYYon98LGNe4AfrBRCrYZ1VBdnkqWo
Message-ID: <CAGsJ_4zo_uya7-iFS85W78+mpvjhmfxp7HfxTPKDD=Aiw2c1vQ@mail.gmail.com>
Subject: Re: [RFC PATCH v5 2/4] mm: distinguish large folio swap allocation failures
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, zhaonanzhe@xiaomi.com, 
	hannes@cmpxchg.org, youngjun.park@lge.com, baolin.wang@linux.alibaba.com, 
	hughd@google.com, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, qi.zheng@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5116FA000F
X-Stat-Signature: ns5i6xkeaw43qrnrx1a57zczhtcck6m3
X-HE-Tag: 1786144359-148368
X-HE-Meta: U2FsdGVkX19rBLa8sEXqUjO1sqiivO+K6bBy7I865vagioNKBkhQs2rA7zDvTsAwDB1+HOplbQ4agUUjy+a+SrrhyTl0wK3aJ7z/UJ9IDlNViqr6+CYheAN1M+VdZZNHuAYn656wXi36V2SNxK5axlV+8jsT8PakWQe0hzfioeo2Qit248/8tVim9a1ounhhBwUhFlyJX+/XNX74E1L5Hd66XzJKnUHbkuQAVQORiPdWooP3oYrLvpO9lc8JbTgJ80m+tAsIQhSYdgx+3JRsEEhHfagqhxPCbZq6yZ2P4JGQ2vZdqfR4P/3VPbs2H4QWUnkQa7+3ecUEVdVXqKffGeMHLdufJ45EZjOrHAkcBum3b/LgkZ4Zvau7233/YJ2DFeGEFpYwrG99BxQWWzScBI1kAeZ28M2PwKZmo2VMeOqFrnflCSj2R3TrFuIfyTVdpa8q38gIcTG01OUKB5YCB5nq0TW1SepJOipA4eq1ke6OOdgDx2zbabOLISGSoMD0L32VZdM9NQ2Zz/fm4x9YfRaUJJ7YRwrEHC9JV5MB+YwRTGIZrX5rDBvJuMm6lRfscm2Fh3N7wBGSz6qRP+TfNhX3wUv8+4gH58QjG+7e88Ja5INQuU9BP5QJcj4kvxvm6eJ0tuJ75uO6dtoh60GBO0lmsE1c5cS6oc43W5jNpkGUdB8Ec+OQHk7rAx1drP3tY5/OYpUDJjkBxyTC3TisT8fKID/9Nbo/g2jpkglfaxR5ZsCze32jcAXIf1GKbATGchWo1gDA4T8HDPON6xzWf3YM9+b8kwDvODQQ3iacYQV3NqP990spgrRIEvzzEgo4YmxElZGA53tXYZ02+KvTRf4Xp4iNPXbEXqFmxctlB00rtZQmz6lAQFSqmJv+81I6KBgCqJKuzm6Hesu9mMN9npNnNdFJ+wEnNsDqTPKU0LicNauFdwoKQ3DA2wNlz+qhPNm+TL4oFIsayeFAxqZ
 ebX1F+7d
 f4dnowkDhLYJ/2gb63bMogxayyXIjfkGziXtNt5fXBc54R1pi03CM4fZ3NA2IBp/5Z9jhmlZ9RVXdsrkAefWVuADiLNMKvZNU3e2rRYCbLQE0kZ9o9kz1vHJP/EpTFXwARUYYpeQIWYIfO/7TWm2Zl5Dq65yEHpOGXAy4YvD0bygwLw/xQyPdUIUzKzWMDVJBa06YLpqF2hGfwRtVh9S7ca+zoPgft0ZATHqQYlXWCM3uoRExFHsy4tikGcOTjFKAAeO5biIYklXmOYTiGfezvIBS+fcvOPtDhEcIYpERk5+2Mm/Zf0tl5gidHB3+Dp2q6Ljwhoqa+UYzMYoR3AIkvomTXI1++iL91QmcJikroj5TI6M4p6PQLnYTXwQ9pcentXkQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 8:23=E2=80=AFPM Xueyuan Chen <xueyuan.chen21@gmail.=
com> wrote:
>
> folio_alloc_swap() reports most allocation failures with a generic
> negative error code. Reclaim cannot tell whether splitting a large folio
> could make progress or whether there is no backing space at all.
>
> Keep the global free swap count and the remaining hierarchical memcg swap
> margin as separate inputs. The memcg charge path reports only its own
> margin; folio_alloc_swap() combines the two layers when classifying an
> allocation failure.
>
> Return -E2BIG for large folios when a smaller allocation might still fit,
> -ENOSPC when no global swap space is available, and -ENOMEM when the
> failure is not helped by splitting.
>
> For early large-folio rejections, check global and memcg swap availabilit=
y
> instead of returning -E2BIG unconditionally. On a memcg charge failure,
> swap slot allocation has already succeeded, so use the remaining memcg
> margin to decide whether a smaller charge might fit.
>
> This only refines folio_alloc_swap() return codes. The reclaim callers ar=
e
> updated separately.
>
[...]
> +
> +failed:
> +       if (get_nr_swap_pages() <=3D 0)
> +               return -ENOSPC;

I wonder if we can do this earlier when swap is full or disabled.
We could exit immediately and avoid trying many redundant paths.
Have you tried this?

> +       if (swap_margin <=3D 0)
> +               return -ENOMEM;
> +
> +       return order ? -E2BIG : -ENOMEM;

Best Regards
Barry

