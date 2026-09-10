Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 221D4C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 10:28:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B4206B0096; Thu, 10 Sep 2026 06:28:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 164446B009B; Thu, 10 Sep 2026 06:28:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05C616B009D; Thu, 10 Sep 2026 06:28:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DB11E6B0096
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:28:10 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8253FA0499
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:28:10 +0000 (UTC)
X-FDA: 85197477540.07.40F96FE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id AE67580004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:28:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iA0GDKCK;
	spf=pass (imf30.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789036088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JPVyV5E0DqIzhRnGLYL94HZY1CWfQkQmEs0e67brq3M=;
	b=xY/PRTlAEXVFAV7F43muYPopyHDaHYnj940OmvtPEmPcuyGC3v03rftTebQWfQtdFlu9Mq
	x417fJYQob7TMr0yWnH0w2fSqfMnTAB2tWrlZGWwlQY6ZuwUDa1TCkcykwlraHlLGRnGHE
	hCpuRlHjBFcqKkp6ZQ+s06ed6Xln0BU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iA0GDKCK;
	spf=pass (imf30.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789036088;
	b=oP9sHVL/nwQ9yYas32iGZjMlwkUaNNNw6zjQC58nNVP5vVB7kG1qK1ynFc55FYglNP5ek8
	yYbnQA86Bsv1QH/S9QB90/vSZxRIgOd+wBE+FgggFuby6Fk7mg4W0OXri2IbDEqXqTCr83
	lRFYtg3BotMHXiknrIYPDK7yX7RXytA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2947C60200
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:28:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4B4B1F00899
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789036087;
	bh=JPVyV5E0DqIzhRnGLYL94HZY1CWfQkQmEs0e67brq3M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=iA0GDKCKKB6z/3Wf7Bp2lFEVxgRqv9dDRBZ0nAXD4AbzfcOzWgjMhjJ3jRxXE3+Qo
	 PmtxCbR6eczSropjhrcKprDaHKCNH4GZC+VphfZt62UT0uI6SfLhBNCb0tvRZjRFMp
	 8OhX1fgi5PAxP7nezhefxXo5TAEdrx0x299tsTXmPw0WfnrJGJ9/1RYNIe64sNse2s
	 ymqKBpoCTUmSxpj4ne/R8Bkyq8EdWLZWLJUQqj+/ZFpp8dwc9ZFqoRTNl4vyx4ptaN
	 F+uPI94MG4ME+1NeU6bPOYzrV0+iLK+GrZ0quos7sNg3e1a84cGJ8uE8V/S02Cq4Nw
	 Z4eVi0/FQfjkg==
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f9f0b23so392641066b.0
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:28:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz1PNCRdP/VSb0Jt6ieVlJARyGqm7/31rVfAgiKqF5aYvymk1YlS9PMw0S8Ck6sq5cZNbkygBxLsQ==@kvack.org
X-Gm-Message-State: AFuF++ltQdKx1+BzyKfGmRI3dk9d77Vg0FODfsSHdnXge5YjBdncPAf9
	zUXcDxu9j0JS4crWhAt898wtlzgJud7zPYy57V7NeDG8oVVve90pZpeNOh7h8wSREDGxZpxqZPj
	xmX0AaS8cJAwcpLAaGSv3vVma80Ajhd8=
X-Received: by 2002:a17:907:97d0:b0:c29:29e1:2a07 with SMTP id
 a640c23a62f3a-c292af1d8efmr979396566b.7.1789036086786; Thu, 10 Sep 2026
 03:28:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260910095449.715183-1-wangkefeng.wang@huawei.com> <20260910095449.715183-3-wangkefeng.wang@huawei.com>
In-Reply-To: <20260910095449.715183-3-wangkefeng.wang@huawei.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 10 Sep 2026 03:27:54 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOvsrSZr5oLedu0jae-VdY9JkRFcJfthPEbqGkOwfw2TQ@mail.gmail.com>
X-Gm-Features: AcwNN1XoK8UFTo0k12q2jzrRZhWEAqgmWTPUK8PiCXhBX1qdHzRnF9MjtfZ5nPU
Message-ID: <CAO9r8zOvsrSZr5oLedu0jae-VdY9JkRFcJfthPEbqGkOwfw2TQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] mm: zswap: reuse zswap_invalidate() in
 zswap_store() check_old path
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Chengming Zhou <chengming.zhou@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: xmpsxhxxjburk97cb6kin73hjpn74x5r
X-Rspamd-Queue-Id: AE67580004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789036088-628162
X-HE-Meta: U2FsdGVkX1+3glyww3iSv3ysBWVVESJKgd8AUsSsEClNxv8kQQmI1EO2lshZQeGVKJSVn/ue80//LD4Fgwf0UE/tV8FPQe1KNyBOD33eLHgwFJZ4/plidp5+vyzcosVeayV8y6Kfpqg7icFUnjkd2tfokePILgc3YNUBFOzhV3vQeTnL31lqjo5ismjSBtAer32YdGhBdYzgxEEz7Kx7wS/0eZCgrbnb5XHndw/kZ8yFzfgdlEZEUcsJb0HSUcPYVTU6cNvui42xZvPW0hCjAMzI9rH/joIbRkHBnBi7GgkgIgwT0K2srFsqSsuUzghVEXTPue+bHUq4gTYriVggMpGcaabk0HgxUdMIb768+eLul5+Ys/T9m9l5oIgnBzFv2px86cBV9NErAWZrxxLAOzP4wVKg+8rJz5Y99/SUcbjTZBBy2eozDKS8ljeeqXgYGFODWwcbKemaigKLmkBA2rbHQQEJe0CjahnGZ4D/vQu+3R/J0bxQbPnL4yXJZRMO2NsyosQ0OrnjnHrR/HjCKZEUjjOuHs0dXxawTkAozAixrqqKyHAo13HJtVGhrmFykLfCxMtAY6ypmKOZ5LQPJqJT8rNY+YK3jcwvdpn9kgOmIOL4tVscXpFh33jKDN3d0S1ZDzPf5++t2Y2JATOj9tKLr54zblhTRS/zSr1m68q9pDJ/VleqRVj5yVkL7l5mVuuSimIljXrAf1/3WJiikSfw9VtF4bnSDkGxQqocE6MEEsZFFqy8X1Kx9/EbUT4cU2LiYmnUc0t6Qqk7n/IwZ9p02LJRK2njN7tVYK5ikwVJOa+RlD3d+5W6LjkmWvVB3IoMLCodAaVAAiqcouxdDj2cJkca6vaYSnFCa4ncJYprpX3QCxZMIgxWcziklzLo22m6nqUUBX5YiyiuxqH/yT64W9Bv4TXeFWdzfL1nQMzd1FLem3OyAp9WRNg8aSMziRDcOvhtazuIe31Jp68
 ZSHo0nCt
 urJnYBhMdA+TvikmJtVSYFiOQRKxyuIpdG+hR4/8FY7m25WCKpk8jcnol70CqQ6YmzpVgahCKaA+z1YaT8zHwgjjC+NerK12uVGq6Ax9lCS9Sib6jJ7vmpDeQwhg9QGZdOxPggFt4YdL7tS0saSCVz6MvgNkk1duaXWgN0yQf28nb/5iy9VarqInFBlGPFxdSuwqiDE7vwE/4VSQmeaqk4PSHn7OMPPvRGrXNyFdUbE4+0Eupt3BOeJaqakIljlzTKVSr9T4VsVP0XFlLZ5ZggV+BTPf91TjudtWAq6yNRL6zJHaVzPk+eZxkej7Fviv4WwshDu0VLRceeww/gTFB6UP20oRxfp0aVZ8+tHI6anAn/SzcyRbbV57t4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 2:55=E2=80=AFAM Kefeng Wang <wangkefeng.wang@huawei=
.com> wrote:
>
> The check_old path in zswap_store() open-codes the same per-slot
> xarray lookup and entry free that zswap_invalidate() already does.
> Reuse zswap_invalidate() whose xa_empty() check skips empty per-area
> trees to avoid unnecessary xarray lookup and code duplication.
>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Nice.

Acked-by: Yosry Ahmed <yosry@kernel.org>

> ---
>  mm/zswap.c | 12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 420c405d0402..2c06e4e0e130 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1549,15 +1549,9 @@ bool zswap_store(struct folio *folio)
>         if (!ret) {
>                 unsigned type =3D swp_type(swp);
>                 pgoff_t offset =3D swp_offset(swp);
> -               struct zswap_entry *entry;
> -               struct xarray *tree;
> -
> -               for (index =3D 0; index < nr_pages; ++index) {
> -                       tree =3D swap_zswap_tree(swp_entry(type, offset +=
 index));
> -                       entry =3D xa_erase(tree, offset + index);
> -                       if (entry)
> -                               zswap_entry_free(entry);
> -               }
> +
> +               for (index =3D 0; index < nr_pages; ++index)
> +                       zswap_invalidate(type, offset + index);
>         }
>
>         return ret;
> --
> 2.55.0
>
>

