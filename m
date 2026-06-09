Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90F7ACD8C92
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 12:56:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEABF6B0005; Tue,  9 Jun 2026 08:56:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C74866B0088; Tue,  9 Jun 2026 08:56:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B15216B0092; Tue,  9 Jun 2026 08:56:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9BF816B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:56:56 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 65B391C1CC6
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 12:56:56 +0000 (UTC)
X-FDA: 84860374032.24.45F2CC3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 16E5C18000A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 12:56:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XGUvgZT+;
	spf=pass (imf06.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781009814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qhurUYXgY/vtFubmMv1aV68KKYL117Ptx/zNouKaS0Y=;
	b=pe9mZRhKdTxf60dhES/DAY1Oel1oAEe1R0Bt/I4ttpA0DuPfAq3L3yGQpmWUTHgsIBnzNu
	6rzzF057JjJGQPQoqNjGX5jzSQsaEsbvLG8LOkGMfwBvOpqIfwe4ZL9eDX8c+5ZLRFwFti
	NtZdDc3EY9fnFII8S7YytE3lGpxJb/c=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XGUvgZT+;
	spf=pass (imf06.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781009814;
	b=jDsXZ4HJ/RSpz8HK82WZCCvjR2SAezdXXTbDTm5GsIin+IZbXCP5uE8MVGKEoAQ0Gl39Jv
	g3UZ3vtiWnD8qRS0JHKzxSXtyHorgbtG/1MsD6ZFMAq2JRFDtvECls0pW6P9rCmAg4+X6+
	XMZMicFR8evbVQX5HsuaI9QBwMAbCPs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781009813;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qhurUYXgY/vtFubmMv1aV68KKYL117Ptx/zNouKaS0Y=;
	b=XGUvgZT+lpiDGRbZdhWbvlX7sFp3suGUAF/r3g3dohIzPn5hKzmoE8krZv929ts3Q06Hgl
	lkpFhD0gKxGnTMNOtyOnvHFcr8TkMHY5eh9a8Q2GPmU8aoQVGSGdqYoZAMgYAGzB+eV4Wh
	OuvIlUeuBWWzIlsR03nw2PCdJn2bKEw=
Received: from mail-yx1-f69.google.com (mail-yx1-f69.google.com
 [74.125.224.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-524-c0IqFpO2M0yiblh6f7fjNw-1; Tue, 09 Jun 2026 08:56:50 -0400
X-MC-Unique: c0IqFpO2M0yiblh6f7fjNw-1
X-Mimecast-MFC-AGG-ID: c0IqFpO2M0yiblh6f7fjNw_1781009810
Received: by mail-yx1-f69.google.com with SMTP id 956f58d0204a3-66030c38630so5695190d50.0
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 05:56:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781009810; x=1781614610;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qhurUYXgY/vtFubmMv1aV68KKYL117Ptx/zNouKaS0Y=;
        b=qOT9RS11Keuofe627ukjX327BHCJ/i8lriHH+NN8bIl5TzzMDKDHo+iFXXwmkq5Vzf
         4QRa1dx2Eh0fqzTflXUCMFbgbZajQ4qFEvoSOPsojh/tGlkLUEdHBCGqQj9HYSZHBoU+
         oXPJebhtZjZEdXUtkmTi30/LQr31uRGx+XDSDymBzyQZo+UoeqQ4DYArn4i8pMJYlAN9
         NQfLxRcNV9I5gG9qp7iFt9UYkp48KQeXwDASugrgxbJVRPYup1nLTpn48KJIQAppvyh2
         g5YTskd/99hHz53+BAQOwk4sW6k3RNGfCX1eyL2mgU+S9hOW3TAtM7tahMPbagsKgmTR
         J1LQ==
X-Forwarded-Encrypted: i=1; AFNElJ9/jN2tptYq5mAn0PmBuePFEKtbvr1gDOVhhenS2jrgBxgeCKkrSJ4k92SPTiOQUf9njBJVVx/2Mg==@kvack.org
X-Gm-Message-State: AOJu0Yw4uuW3Bg7T0LTUUPdESdOnZRzrVUMkABMM/Sx1RWAbVQCwuVR/
	PMgHC9kHxvcauhur/uqEz/m6hDAX0ze6tqwhlgkcuKmyl1sQ2vdNk0Gem22GekhWTWXvMRSK0DO
	fhNGTdICptxb46P1QShWJY3zEjXvukuiu6nGrRHX7woPyltjmJ4TfuFuY4C0/mXUI2MJBGZVT8r
	zWNsRDsUGszD36uoKiiSRmPZqbSOU=
X-Gm-Gg: Acq92OGmcg/d/7VCurqD/UbY+0PxWpHlrWR2tvWxCVJJulibKBYVSj+B/laY9JRFENH
	ANUpott4Fr34NFlnvWeQOt9ewHYc2juFOSgG8ZzipABTlr0iMAG7rbEqA7DBN3tVZ8jcuQkrlwZ
	ZOB6jJvJpOCC74Tw7+qnZ4L1RDR7xEIOzrPPk0hR1iio+kAa5itwCH5VOCn+JbG/7b0lmd5vkbz
	K37P0+sl2pI2ETA
X-Received: by 2002:a53:d908:0:b0:660:9420:56c0 with SMTP id 956f58d0204a3-66106f58309mr13074278d50.32.1781009809641;
        Tue, 09 Jun 2026 05:56:49 -0700 (PDT)
X-Received: by 2002:a53:d908:0:b0:660:9420:56c0 with SMTP id
 956f58d0204a3-66106f58309mr13074250d50.32.1781009809181; Tue, 09 Jun 2026
 05:56:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260609114619.144416-3-npache@redhat.com> <20260609201202615oT6yd_LtIoKkGLksFaCha@zte.com.cn>
In-Reply-To: <20260609201202615oT6yd_LtIoKkGLksFaCha@zte.com.cn>
From: Nico Pache <npache@redhat.com>
Date: Tue, 9 Jun 2026 06:57:34 -0600
X-Gm-Features: AVVi8CeX1yVxWKr9cE7xNybnP-Kvk1uhW9BR6RKkm1VrAxBnCw7n4gqJM4Dvr0w
Message-ID: <CAA1CXcDv8uXN_yZgCqbGUJ4LG-kxFMv1P0yz5exMMAyfUS6N_w@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v1 2/3] mm/migrate.c: Prevent folio splitting
 from interacting with KSM
To: xu.xin16@zte.com.cn
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, usamaarif642@gmail.com, 
	yuzhao@google.com, aarcange@redhat.com, akpm@linux-foundation.org, 
	david@kernel.org, chengming.zhou@linux.dev, ljs@kernel.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RQ3NcqEZgQ9GUq8Gg0wnNjFTjn9iTt4rsSW3kXF3O_M_1781009810
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 16E5C18000A
X-Stat-Signature: bfmkee74prqxo6mdz8fhc6yey6bqezzy
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781009813-367579
X-HE-Meta: U2FsdGVkX1+aOpQK0QifOmee5+A09Mun84bWxum29FsuELMxOp94ba0iplkWNxGnFW3qeBV88ySOluQBgnSF/AdaP71in7H5IY/Gw4MuKDMSHX9TQR7zgmcBcdneReWKRBRxksaRA7UV0KAEjP4y9xj7h/PjUZaCUT9+JEHC6Vct2/84iuN3Y7pGa8EYlL4UwduA5qnFyqCMjACbhSjarnLQTfPEp25elpVpPOcaIYWWsiDu2D0aGF4MLKBVoZfbljO3CubrzOaUEt0gmGtRb43WulxtmXtmSvn93D1P5EvvJL3m97hxmiMeWvobgvjG3EarkHLvyROyOtENj4abtN8pWoppPINUylP6KC/DUc2dnw8kZgGqlkufbSjCLLrHRIMf1Arn+7FTEQ5BSAG4rCLdF+ZbQ6LjptMkFx2+e2/OYhR2wFmFjMRxDa2A8EPexJ/Y7BhBXJBJKXMYEV5Q3cO701drEZUMeCnvLnE7Tuh98/aPtXlByrG/jiDapFKKwPvfMk0iaeoTvSZ7NcEVJUHTV1XxezOaN57izxEmaZ9gKl0i4QyKScERROP4IYwf4EFn+Y9UrxVQY+uIOHxCblu43wYr+sJOulI+5103nYBA4lDbDChxDLP7JOxbMTrNH0/2cFcMRZQXGMHe5BSuMPOwn7Qt0McCGsArcF8W9LIRmVpkQ5aa1jnMpkof8tdmM3a5P8gZJTFvtVFAOk30L37sQK8fYD6aJhiAvaCJIXCAqvcEnjXhFadLu0Pya8qucGpexgeEQGjvfMq0Bo7zzRGOhdYIOK6nJ6KlNN4pEeXeHRng2n/FZlK1zkOIt8dbD4rYb2qT8WXxZFpULH9CM0I75PN3u+d/atFCwc2hzscIpsaw9Bk1n4l1vxHfyeRr19os99s9I7xdeD3ZYy93wAAX5ym6lEWs8CeLlUORBXyZF7Xim9AZIvqulvSaDQqGxyQ9PsfMaqeKiOwJYKA
 /+QlreAR
 rzHUCzRPDBQzcsy7BF0hSc+NhrCHVHGOnlYUYFyIMgIEWPMUNDxKUq/dqInbW2JnKVNX2adItmtqP9z4QyrnbRYFA1szY4YFin23S9UZcu+aaespV/RpyBgSm/xSZRqTXxLWPa8aIyGIYTuKOQsTVEjTADMmUpv1SHUdWNZ4rGf6KnOh3ET1rnQW6TkZkigPUhw8jFvwPFPUZAeKqMwwclDA5/1d7Zg1fb7cvSk8wezd/5jDdl3TbvlHNEpGrqPDf1EOkRoLHp+UCjwWRBj819s8vhIHc4w7vZ/DFk1Wso6JX3PHWfQo1uyOIHeOGLTwb4ElmLC/my40E405os8ykIL3PZV+Bsl1JOBYOYsmIwngUkcI9T2hQ9gdyH7x/NaJ1edLV1Lxb81e4UfLbee2QSugylSvP6JReTGFrjU8TZzrwSRoCpVexnpXF8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 9, 2026 at 6:12=E2=80=AFAM <xu.xin16@zte.com.cn> wrote:
>
> >Since commit b1f202060afe ("mm: remap unused subpages to shared zeropage
> >when splitting isolated thp"), splitting an anonymous THP remaps all
> >zero-filled subpages to the shared zeropage via TTU_USE_SHARED_ZEROPAGE.
> >This flag is set unconditionally for every anonymous folio split,
> >including splits triggered by KSM.
> >
> >When KSM is enabled with THP=3Dalways, this causes two regressions:
> >
> >1. use_zero_pages=3D1: KSM calls try_to_merge_one_page() which triggers
> >   split_huge_page(). The split remaps all 512 zero-filled subpages to
> >   the shared zeropage at once, freeing the entire 2MB THP when KSM only
> >   intended to process a single 4KB page. This bypasses KSM's
> >   pages_to_scan rate limiting, causing ~1GB to be freed almost
> >   instantly.
> >
>
> Why do you see it as regressions?

Since the zero-page remapping was introduced our test has shown the
following behavior changes:

With use_zero_pages=3D0, the merge rate drops from 60MB/s to ~6 MB/s
even after raising pages_to_scan. The KSM merging is now much slower
and CPU utilization has increased.

With use_zero_pages=3D1, ~1 GB is freed almost instantly, and it no
longer respects the pages_to_scan behavior.

Even with just this patch (1 & 2) or the RFC linked in the cover
letter, the issue no longer occurs.

>
> AFAIU, KSM and THP do often conflict with each other. THP tries hard to c=
ollapse
> a huge page (which may contain many zero pages). If KSM is enabled and pa=
rt of
> that huge page is mergeable, it can easily be split by KSM, rendering THP=
's
> efforts futile.
>
> Therefore, in our actual production environment, we typically avoid makin=
g the
> same region both KSM mergeable and THP always.

THP=3Dalways is a global setting used in many production environments,
so these features now interact very poorly together.

Let me know if that answers your question!

Cheers,
-- Nico

>
>
> >2. use_zero_pages=3D0: The same split side-effect occurs through the
> >   stable/unstable tree merge paths. Each pages_to_scan iteration
> >   triggers an expensive split_huge_page() that silently frees 2MB,
> >   while the scanner wastes cycles on tree searches for zero-filled
> >   pages that were already freed as a side-effect.
> >
> >Fix this by restricting TTU_USE_SHARED_ZEROPAGE being set in the case th=
at
> >KSM is running and the VMA has VM_MERGEABLE.
>


