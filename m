Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54BECCD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 22:52:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F3436B0005; Fri, 29 May 2026 18:52:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97CE96B0088; Fri, 29 May 2026 18:52:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8467B6B008A; Fri, 29 May 2026 18:52:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6FED56B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 18:52:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 05CA2C15BF
	for <linux-mm@kvack.org>; Fri, 29 May 2026 22:52:08 +0000 (UTC)
X-FDA: 84821957136.17.58A2424
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf05.hostedemail.com (Postfix) with ESMTP id 06D3E10000B
	for <linux-mm@kvack.org>; Fri, 29 May 2026 22:52:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YsVQL4jE;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf05.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780095126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BfQ/N2G52saqHuveGWcNKjKTf3ibvKRvpKaDsg3k16I=;
	b=JNdoMCcs5f46KrZzoDuxenL3X3x9req+anlWqrfuNs7kQuVqd46AuPdojBXRr0D3o3dS+1
	Tm74Rk5MvXPSW+J26VXne19/PJsV8aij0TkftUsFLpsS/su4KEPuxRhnwnHutN+7ek03Wx
	MenkazLgkppbUv2Z85I03z1LHk1HAWM=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YsVQL4jE;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf05.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780095126; a=rsa-sha256;
	cv=pass;
	b=mmvguDO8GTmbdKKnuzj5WHmiWoZ5c8C2gqDIpvXRC0wuR/iZ0RBn8uaqjCFETwyezdqo4D
	KyARR2lO6rdb3ntQJ0ptA4LoZE9WNIT8wTUzNkOszYcri78Wv7oQXuiBtiltICjBTe7Rox
	nlcmiSxCBfqaieJ7cQliumGMJQutCrY=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49039a8851fso87357355e9.2
        for <linux-mm@kvack.org>; Fri, 29 May 2026 15:52:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780095125; cv=none;
        d=google.com; s=arc-20240605;
        b=a1D1RNpCYL7aULOsyC7TvAQJHg8GcWpN2YESNpl4PfeNCLN35DfQk+qB9ONQnbMPd8
         gH9j46A64wq4cNBzwN88lW2f27Ma42Ii5PIolNtVjF4ALdFgu34ZmOy4DRBCu5/XsWUj
         q90wnCjijeXgPRPbt6w0aqj4WBlj9YA3Bzytt/iTjYELH4RvD+DP72N/4Jqay27KQf/u
         8Msr+J60aNR4hVJKceOaRT6B/nEjLbnDBjxCSuNAjQgybqtJ4Pl3iKKcX8FWm4N2Jh1s
         crWASNMd490JsbcWQWkGN4ljwJgDsjsq5LuGNLSJQDBoTxOzPd1q4QvUL5FbUj8DzMs0
         hvOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BfQ/N2G52saqHuveGWcNKjKTf3ibvKRvpKaDsg3k16I=;
        fh=AyGHhU/uX+/yzUyP9LdYNCeFbmaiVQuuYYa/ltsPQbU=;
        b=EmRNXgM2lTPCRkSyz7mHSwQ6o0SmzBbJFN2KjFN/o+TsPDh+sRbjC+/VRtG+IYF6Vy
         FOvKhMI3i9Re8iHJDtxvZjJDQIhy7jX3hd/g0dcg1vVHer/L0dhwwbBmaBl2kntKOOYm
         H3IslzSr+vjV4y/FIKV7queipNs6w0KbeFaaAE4gEX1hAwDXf60eQndM5m3u9Xy8mqXM
         ny8pw7GcEUqt4aw9e26tApCSebTEUPhGRp3g+8WjCaRlk4NjPqM84VoOm3Dbu+R4khdX
         j3lrdu+T4H8Q/d/WzdRif7PE4UHYpjHnD+oqLVhVbVmi3KJiNVfZxNbBHD+5euMzDXHX
         pueA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780095125; x=1780699925; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BfQ/N2G52saqHuveGWcNKjKTf3ibvKRvpKaDsg3k16I=;
        b=YsVQL4jEB7uTUOosSaf2aDOV/ttQtUjZB5sXaxv//AOUuawS9+nk+x27gNW4oDZ//C
         gJASQPNAiyyMHmVJD37EGGhHFgzLd0IO1bjq9a+SXm2B9lnreQn8YD+DYfys/K2y77bb
         94vaoiz+Egq4oRrMQoCEjkJ4UxSyOJamzhxA5HLGL9bHpXnzFAXCBAcwAHb5DQuUGCc5
         ciRcfNviPvRrSFFmSQO+kudSJHLgw0NhrdVO+43gE1K6cDnqy+0UsUIrcPQyaDHPEtCx
         2fGGOJkI4LjPaFmY7IvtUznmA3LDnGGdrrezQA2EfQQa+nYmWloAlPwwauhNdCiD0wHR
         UI6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780095125; x=1780699925;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BfQ/N2G52saqHuveGWcNKjKTf3ibvKRvpKaDsg3k16I=;
        b=J3KZY1oXJeKJYmkS26lM8raaDylC9NncczHaJ/j49y20ft9GGhrlUUi+uXqT/dpx+1
         Z+QFCrazhU+Jf1Em7Y16B3pwvf7UBp5LxopBw3kg7X2B/rSaq4BJCRV+2CZgoxIuo9+o
         qhxAFcdOBOYG5VwJDKUfCd7gU+HQ/C17X6s75EDtdI7PVrEvnOq3p+PazTUb7fJGUYUl
         yeNEfDP90dRgDw1L0MzSM+MrRy5EWgESHtcsTm46f2vdZ4ZLsaNnvm7x9E6OANKKn7GH
         SFiZvcXHhNnEz+Vu+ffL2zagqedgqkPZLJIAB8fvbsDishUvgjX0Oql881ChTcIKC5vz
         qIkg==
X-Forwarded-Encrypted: i=1; AFNElJ/ludrooujjgzEkpYAy0IU0n1r0id6sxzAqNwNMbhQ0guR8F5SY39FnyBtLDY70OT9a4QaW3L2chA==@kvack.org
X-Gm-Message-State: AOJu0Yx91uH1x1Dj/8Q1fNiUQDDbLyFIkRZRCiWf8slluw5RYHINBHgf
	l213SHiOpSRhC++aY/fiLi0pci+Vn+UU8wh9jS/3Yi7IBF+3QPMyLPstRQLJQFma/ypByZ8MS1r
	QO3n57Zib2J6jNpbI57qkm1a7q6/GiQw=
X-Gm-Gg: Acq92OEyyrdjjhLdqFXr89ph6wObMGgZ81uoo2kZNI8bq5JdMxm+psJCnniR9jDFpio
	LhTopDcxxluZBrMwD5hDLl1J19ubEnRcDH4juKmaj5HLoq4us+Z+1Gxwvx5LFydKSUuw7eCEicx
	f0vUaGOtk0PG2HEPuxKmWBaiU04/ikik061S6qdEEoIVelmbs/j0Kfnhzrvp8EJQigy8lrlMWSV
	5VFvfWPWGVZLxJ+vA6J6PPZ6EciPHLi4HXS8SR4F5OeeUSFID6RkU/naO1a/W7AIsdoEY7E3+vz
	eVV+tl1w0nhLZrtDA7YikyKOF+HXTMlSY9itkUE5ltamBYGuLK/BZfXWj6zv
X-Received: by 2002:a05:600c:8582:b0:490:9df1:f0d5 with SMTP id
 5b1f17b1804b1-490a2958b12mr17779815e9.28.1780095124642; Fri, 29 May 2026
 15:52:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260527115930.3138213-1-haowenchao@xiaomi.com> <20260527115930.3138213-3-haowenchao@xiaomi.com>
In-Reply-To: <20260527115930.3138213-3-haowenchao@xiaomi.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 29 May 2026 15:51:53 -0700
X-Gm-Features: AVHnY4Kn1kSFiLwGd8YEQnj1_05GSMrhR7BjsErqjpucyaPh4S18N2M7iTfEuVU
Message-ID: <CAKEwX=NOTM0KK4cpiy-432Jn7Odbq8DZnS+x-cRvETg70xmFkw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/3] mm/zsmalloc: drop pool->lock from zs_free on
 64-bit systems
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ewurha1qxyzt94kqf5nhtmjtu6oqza9s
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 06D3E10000B
X-HE-Tag: 1780095125-777479
X-HE-Meta: U2FsdGVkX18NwwLGCb3/7cPDQYvlAYwk2+rVV9dIWqREX5dVAUHAaF4E/xz1+NPdWxmZMioKy9sHyr6TOknhhifio6j7snrDumnJE8WtAZ77XNNQQM3R0AnMORhlcvEyt0WYkgvPOn4IY02fmXjRNp+aI/PfB+ObliDmQGAPq36UfnI2h+SQaQDVY5loM6nXqnoN5VfcCnuJmfSZILU7N/2Yb4+zrVodyz/MDJF/xBuyrEYS3tbMB69vBQrVtHdjMML/yyrWCOaq/yH+ai9SXk655tuDigmQVam/VisUzNSZhAnSQyDY6lt/fYN7TmRb25iLwaoT2erL2zS9Sy6bBa8h2P2/+10Xco0sRTLYlDmu62JPr2R2U7u4lkaaOxWDBAZNEkwW+Uqkk/AoaASjrSwE9FL6iWtLouLhqjCA0BwDAi7jaS0hK8urAXNmHILYecf7gh7/6KfKrYyIvGr+UylW4nA5vSu1GmUphXNRS1FIJt/CQrFKFm0BbJ5bVyRXkj6R98qo21c4b4f5Q+xSSB1VukkwwwFgtQ95MPlRXO5MFNcGVol/yBMdshoFqRU4h9ed0Ai/zPJPuw2VG3Cfu9wBcEU1KDJRE/sHP8yKMQrYpFZLTKIflZPPyJdLcQ9VY7lkDmk1NkZf6qP7X5GJQWcX30uQ/zhYbXu/rZqjpOwasv3mVQPaxX3gFrgiXvYVC5Huh0wAOG+1q1pYUjiPgSMkv44LeWceZJZ6VnQbXHg6u/xOYHqe6UD6DDihBivzMAr1xnL2F1Cnw/lIDlnlhxUfWSTHyO1DsJFnpOc6S37hsIzwXiGxF12v0ZWj7ee7PQMHCQaBlZAGWonBhfweWfzcyfIZDfFwJRp9RX/SObNkxBC+YhY1yR6Dx+jJsiLhgzO6TH/yl/n0APnn9T5Zsg43C+0rDvAhqHkc0g6i3PBeR3J2AmNJJchYBqjXbD8ruGqHniHDbr8LIVShOf7
 E7r24FV8
 hiKeJw9U1vXWnSluCi6WuCE6v3cbzVd/D9wYCFvTZaZvWJpNmqUERd22yJEJzbcXFq/8SZpCFOiuq+eLgsqjIj/PWB53ecvaufO9Bi5xrM5R9M45EDx/W5QQEQmOECEUtolBlihW0pcporAPd3gFiViP9ooawCLx3Mic1DLGV3vQsLxnR5po6T3cnstGIfpq+PbBTUdgF9KyLdlyQ0p4SAdzK88wDymxaAJCUWoEnQHl5vj5mXuQ6fkf5im996S9NBUkNrQW0RcDzqV+KkrHwblnF8nXrFPblRLnNwYic72g3QEx6xw2KGNOYWNycVgHIVppGewM+0Fgyjqgt/rB3JS/axmLMtePeriOJQI2sQHqyOIdxURhXMp5KDB9/fv7+WBRPdX8xqK8e/UPkPhOTR/GYZ6kmbwLGhppZcIq1S2v5Oa3tYB2EpXoBOUicakIMLSiZodv66q+ZVfuUTyriTKlx4iV8czqOBdhJjugEzkslMBWRMclziT3pyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 5:01=E2=80=AFAM Wenchao Hao <haowenchao22@gmail.com=
> wrote:
>
> With class_idx encoded in obj, zs_free() can locate the size_class
> without holding pool->lock on 64-bit systems.  Page migration also
> takes class->lock and only rewrites the PFN field of obj, so:
>
>   1. read obj locklessly,
>   2. lock the size_class derived from obj's class_idx,
>   3. re-read obj under class->lock to get a stable PFN.
>
> This eliminates the rwlock read-side cacheline bouncing between
> zs_free() and migration/compaction on multi-core systems.
>
> On 32-bit systems pool->lock is preserved.
>
> Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>

Thanks for doing this!

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

