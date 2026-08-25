Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCD6DC61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 21:45:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE9FA6B0088; Tue, 25 Aug 2026 17:45:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A73F76B008A; Tue, 25 Aug 2026 17:45:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93B666B008C; Tue, 25 Aug 2026 17:45:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6AC526B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:45:12 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E8ED0A2D50
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 21:45:11 +0000 (UTC)
X-FDA: 85141122822.23.39C2514
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0CFE980008
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 21:45:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=as9SUmFj;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787694310;
	b=tQuIXOLNznR2B9BkSbkHCzAmpscmleLmhNCx5ECutTGk+JZu80GuSp4ryhUwOQD4DJzvKO
	a7jmkh9DOBavVA8ky+tqQO20/7iH77M/twqyfAazxuMuum0rTS2uBsYfA8a0HoJq0BOH1H
	Pe6hqxCD1CaPcOLM/oGBdrwArZG7N5I=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=as9SUmFj;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787694310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v8lpn0yTabic6TJjgf78Py4GNoj6ZNUZ/c130S63ZHw=;
	b=tck3kYJXrX2C94Nl0p8EoD7qa7+ihIdER2xB/ZCi4MOT1YXDPxZEg1JQ0uVfP407sVBKBX
	vG5C5hH4y2j+6U5YW9uB43yz7vRcQjBqnyePCUFp56Mj2YQbsu9VaVRwSmDokjuUfqy2rN
	/XByA5K98Y/Q8757DUGLWnkPeCegK30=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BD5CB42002
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 21:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1EF21F000E9
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 21:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787694307;
	bh=v8lpn0yTabic6TJjgf78Py4GNoj6ZNUZ/c130S63ZHw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=as9SUmFjD/CgftGnda9H8FyNHUS5Z+boa7W74d8ATdZoccJPc9l1Oj1fUEMr/ccik
	 icuH0hdSDCllPyLls8St98fra0ZJ8oVvKshp3YrN1ofNFbWXlvayOdMXfmQexk+s48
	 o95KQLjq+rFUWZR0LfHQvfSfiB6KttdkTmgHLUhNSzPQddZXd6yVoSsyrG518Kmep7
	 hygdcaMYX9+AiCwgScfhLT9S0lk41MbrxgFRfrLo+6t1qqJAwaaBc/82Jjb/O954/L
	 6Lw7GT2OBtqml/LTiL/sPnFy1CfiwRRAZRFxzKOJBoxWvbeHrkn4r1Zl1iZ8Ia3Rrq
	 giIv8tPbQVf+w==
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-90cc28ad662so2507396d6.1
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:45:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoEm4WFkPlT5xFrliALHbW1ne9as1DpUKpW+DwoYGXOgsDuZSvmeZpQ2qWIoSbCpu8qOD2X45M8VA==@kvack.org
X-Gm-Message-State: AFuF++mUhUInLLvHvPEtE7E0IJm+xhjt/dlUDO8Lv2TsSwS49N/bhB2d
	agbLY/R8T7W3d4cAjxOehBjZv+EtH9wlBnmzA50OqjO3JuNVWmdlUssQ69oVGyUA9Z8hMqTOR78
	zFCHBnyAT5t77tneBsO5yU4d7NIQzmO8=
X-Received: by 2002:a05:622a:5914:b0:528:38b1:b54c with SMTP id
 d75a77b69052e-52e4222c9admr26729031cf.2.1787694304780; Tue, 25 Aug 2026
 14:45:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260820045603.68809-1-baohua@kernel.org> <20260820045603.68809-3-baohua@kernel.org>
 <5e0b17f1-a9db-4317-aa4f-924c6c767ee1@linux.alibaba.com>
In-Reply-To: <5e0b17f1-a9db-4317-aa4f-924c6c767ee1@linux.alibaba.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 26 Aug 2026 05:44:52 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zAHgsA5V8FcN1bbKDV2rTRynMw7+BVNRaVUwoXRg+87w@mail.gmail.com>
X-Gm-Features: AcwNN1UbA1WE_JQHWKe_aPNvKuoNt_HVipPAw5MZjuMlekVGXMaxchPGmWqmBxk
Message-ID: <CAGsJ_4zAHgsA5V8FcN1bbKDV2rTRynMw7+BVNRaVUwoXRg+87w@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm/mglru: improve scan_folios() exhaustion detection
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com, 
	baoquan.he@linux.dev, chenridong@xiaomi.com, david@kernel.org, 
	hannes@cmpxchg.org, kasong@tencent.com, lianux.mm@gmail.com, 
	linux-kernel@vger.kernel.org, ljs@kernel.org, lyugaofei@xiaomi.com, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	stevensd@chromium.org, wangzicheng@honor.com, weixugc@google.com, 
	yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0CFE980008
X-Stat-Signature: 4mwd36f5cj6s8scfo45ryap15qzmw834
X-Rspam-User: 
X-HE-Tag: 1787694309-640841
X-HE-Meta: U2FsdGVkX199xNw2z5lJtGFkoEvMb8rDqbiaz2p5wx4ZnCNUkPr9fgafL5udoOUoGhvrO/63pQ9rR5dcSy2qKmD+/nEGgPnFRHnEQkDb3QhxVmNVXFHrckEScr2hsUq6A+mDpAMO9ChgK+cAlls5e8GB8AP3uaXNyr3kRh7WrcdjTqaa29O0jiX8vep5tDShzK+pj/Y4alslZ5jgqILL8j/54ES20F4dvATUKURzp2O2Hiem4qCHsyr4LivseBS6oSPFskISonITEbrc9aUqaRcGcxY4srJJ9PlPfFuHBezSzirFn3UdSPC6IHxwA9lagfY6pJfRzoTgT2OBDW0MEa75ZGbAtcBiItwtdyhFNWYJohnmUZSlXH1tT+nXJUfE4GmMebfjSjqGeFtNCqyS93/FrwjBykK08b7nUXFMS3P8G/ycJ5cM79OPEDoadsz1xjiN2Yv3Flf+q0E/jl5arwoXFchXn0JqcLVQNzPFMe/dPtFcxAl3WX7A+CpTKflRWiALnNfECTO6MSZsZNFKBnEjyQCcs5AHVLlNyAndEwgPZqgPWKRQX12eaOxDWFZOiHHQHsAVByYCIL2PIknlqMeZoqewtUbuwzEWO9P+W42QqIW82DAAXSEptrctx/e5HKI4AYK4zZ/cbAdxE9xspAAPM+AwIXGpXJCIFl74YYNiXzMtpdwOa8G/qAaTEI/MjcvWx33cpZJkUeMKzOTER9QqdHFRIusaWQdSh9ySagJZmpHBhkEvms2zsqcucRkfnkVEBgrQZ82QALU7KXdK2tRniFYWlvEgYG0w9saFrAa7vZxzp1YHN26xJyX/nHWHfQw/ZoF5oT81k3GvJvEkY3leWmoMnLCINqZyFPaaCLxR4rqBeAvDBhGdfO9tIY6/og/z4RtDj2xHeKe0r8+WRhMUWXWMfxrw+v8beGid94xv8GPINooyqNw1ShnV3QOcozzsV0OYVD2hnkxsVaR
 2cy1twYV
 rRVCeDr4AuqPve1S3ugX9kl1j9ZW2iGHcJCQiKYSgfS5lO9vhJI0CSaDU6/vVXPZtDTHfa4yPMYfALYZys8IRlf19R7mhE3kv7XMG5d4V3hFbGp/7bYTKSmx+eh/lL6ddHK6DPSTJzM/Zw1I24HSozPk+EP+yI+Sm3hni3GYpBJ1TmBygFpmtwEr2yUbiyQVR6wptzn4WjtXGnX8Xmx/f1dqswhrcP5O2qW3J0UVRLzrvdVDH5ciPlco7JnOlEvj/bsFpmmnVRDhjRuIWWGD1ch7uT3w77B4UME7mbPWr8yYAWH57qcmAwWe2Wi0azfvjAg+N+QmKVMpp4K+JWAJnKt70+bcoR2KEav+rch4v/TLx6jQhpdRqljf0m+U//QKIu2CQHu6Omo/eX7wH9fNkZ5fIxRLlmYah0WOTj13f0My9NQ9ILBVJZVMNLQN9GeBnL/oNlJFdXmGg5PQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 2:48=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
>
>
> On 8/20/26 12:56 PM, Barry Song (Xiaomi) wrote:
> > Commit 16b475d2ac3c ("mm/mglru: avoid reclaim type fall back when
> > isolation makes no progress") uses scanned =3D=3D 0 to determine
> > whether scan_folios() has exhausted a reclaim type. However,
> > this is not always sufficient. It is possible for scanned > 0,
> > while the oldest reclaimable generation is exhausted after the
> > first scan_folios() call.
> >
> > We detect early_stop in scan_folios(). If we stop early for any reason,
> > it means the current reclaim type is not exhausted yet. If early_stop i=
s
> > never reached, it means we have exhausted the current oldest generation
> > without hitting any scanning limit.
> >
> > Another issue is that if the lruvec has 4 generations, we might have
> > exhausted the oldest generation while the second oldest generation is
> > still reclaimable. In that case, this type is not exhausted yet.
> >
> > Add an exhausted output argument to scan_folios() so it can
> > explicitly report whether the reclaimable lists for the current
> > type have been exhausted.
> >
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > ---
>
> LGTM. One nit below.
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>

Thanks for the review, Baolin.

[...]
> > +     *exhausted =3D !early_stop &&
> > +                  lrugen->min_seq[type] + MIN_NR_GENS =3D=3D lrugen->m=
ax_seq;
>
> Nit: using get_nr_gens() looks more readable to me:
>
> *exhausted =3D !early_stop && get_nr_gens(lruvec, type) =3D=3D MIN_NR_GEN=
S + 1;

Yes, it seems more readable.

Best Regards
Barry

