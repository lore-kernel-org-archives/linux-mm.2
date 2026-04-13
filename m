Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DC68E93804
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 00:01:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A8606B0089; Sun, 12 Apr 2026 20:01:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 358896B008A; Sun, 12 Apr 2026 20:01:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2475B6B0092; Sun, 12 Apr 2026 20:01:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0FE286B0089
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 20:01:44 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 61395140B5D
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 00:01:43 +0000 (UTC)
X-FDA: 84651578886.07.BA17ABE
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf01.hostedemail.com (Postfix) with ESMTP id 63C8C40013
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 00:01:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=facsiRe8;
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776038501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q1z381Ofo0rx3mIfahNjA70c0ZuNgM+q7a4xb/dSsI0=;
	b=mWfn/+ISsTx9SUtdxlgr9XAheU2W8H4QZp2dONj7V5M6WZ6Bq383U5+QIUGDYPDSKB+KOt
	b8HYbThib2Y91aZ9lbowj4/4vn6H5OROXRx2RqTowKGXZByEAHMhlmjbA2DY9Pe1+MzXop
	kOjSO7qWp6XUJrCDkwPpUlGxJW5sWM8=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=facsiRe8;
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776038501; a=rsa-sha256;
	cv=pass;
	b=LJQJhisD8yS+122nw8HrLuMkpVUBEsTouH6Uu/pFiDnpgjQtggSre1ov4ulSb72Ov8whuL
	ZquRxpFJYiAr/WrW4t06yFRtvRfJfoJ8N4Op1pAeaHp0eXf6k4xoNbJaYWtUds+nBNE4o3
	7XMj/7OQ8CqRTOy08iqqNiPLrSYQlOQ=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-483487335c2so40667185e9.2
        for <linux-mm@kvack.org>; Sun, 12 Apr 2026 17:01:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776038500; cv=none;
        d=google.com; s=arc-20240605;
        b=RNnIDpGWNlojl7J1hMRiCegXYe3X2oNjghrqWsYSWYO944TIOv8DwmADCH5zXg58AG
         PByh355/8m8MvFZxj3LgWXnlkB6LuH7Ws385mHQnEW/ptKO3uHOCJKihhQalNm3Tdtpt
         bivuwV9g1gk01UicgACFmCuUDeVXZOsuqKCOdPPuAZ3Uxoa4xALnBBuqMnxiPHUYPHU6
         /gNj0KPMPxue/clPiE8T9w9o+Jbel00kf3+53UkDqaLhUmKd0rvOqtQ1UHaz/7foTwEi
         HUQ8C1d9mU0Zlff+dhHTuTaivUl1Iv23MZOm4E2HPPJsVreO8PVKgzzn/ybF5TcjLZmf
         Nb9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=q1z381Ofo0rx3mIfahNjA70c0ZuNgM+q7a4xb/dSsI0=;
        fh=hxao5tzO9VkSEMUBAVHv5/gAqbD5wlJmuMLdVphukB0=;
        b=KricsOYYUCbOZhoMj3S7XwJWGr6VrVacf9IssbodF0pPHIkqw+8LOKlttK+gBIkuEV
         jY07z8QpGVjn6CT3lVGcZ2xeyW5r9jL0ZFiExnJ0nUkOlBDRgbACqCIxYNk60cRFOsf0
         58j9sz2yFqcWEafgKn2Ffyb6IJMUdlh99SxKaEFhzxGAB2D+JaWAiCAqZKhEWtNNx0QJ
         klFvhu6HMbEBf97a9lI3BqpUONoruTcugwVTbsiz4aoru5sCgdnb96iCP1D3HR4j6L8i
         aukgyAtxLhwBqmWGfamCfJ/vK3iyfnx8eTpbxrVHgQkLuqRiQEvCdZkC69CMSCYIYZ2i
         GtXw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776038500; x=1776643300; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q1z381Ofo0rx3mIfahNjA70c0ZuNgM+q7a4xb/dSsI0=;
        b=facsiRe8Q+SqAYjPGQsBKRjlz3vCSs2p0FIjqb0MAIZN44A2fZHQTG0J947kAwBTQM
         exRGlInPYgDLgR4xUwSxVd20cQvr1nTTa2yz5VdP2erQ1NdqLjb5wOZ8rN/bja5A3rGo
         ZyUuYpNOkdHwq01FADG7gEErira1KULh3XS0ZsWGcONCNCmp5P7KAHtjyqIOMBA+BysZ
         CwJ10WZjJxKTPlRvXRZcZPj9UA5JJySNbkgJl0hwOGyPnXVWXquCiWHmsctcoCyA1Dzu
         GL09H+vwEpf9OP2TwUdzKGH7y7FB9rGakBAFD+D/2usc3TsKvMao+0HNJ1sCZAbcI9aw
         QjlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776038500; x=1776643300;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=q1z381Ofo0rx3mIfahNjA70c0ZuNgM+q7a4xb/dSsI0=;
        b=tCM6vrtrci5EumTbZKylaUgE99l7hKEaKHUpdq528dKvfFmhGXkQrk1HTJcaDhDWzI
         vEtY4uEOW8K6MPidnBUAuBrJPUKMx4mmH4IBMhqMF0YWTGNTWA4O0jImqqZ+rII7J3+H
         GpZ2+yxOi9pzb16h+JOPhlIA9ej5abqETEzXqGhhXNWC8PqJnEMrwljUfdOMvOe/3R6R
         YAf8IykNKVuryrIJ66Q4oS9/rFVq6TY5LtvmbuBEc1kVRWfNOOuvClq1hr63V83ArwYy
         T0c5XUWJVzEDRfQy0pBq65N4AZKtFah2KSoFMhDD4iAMZ+Rz0k+9VkXEhX4FfRkEAQ3M
         8EJA==
X-Forwarded-Encrypted: i=1; AJvYcCUQvJp++3GMTjHhWKRndRw+gWvSjbkXrLIBitu+wlt1qlTeUbXi/x6G8ljmm/Nmvit4nVQ1x3nGxg==@kvack.org
X-Gm-Message-State: AOJu0YyyE4gUTg27XtZTxeddfJBLQbdyQxkvU0tTsZeCJn0TWVR7WfyJ
	SZ40UcQsNcQBONhn8PJXQazwMCVEB118hTl8F0/pr9odPV/ph5zfON7of52QKYeBWkcCYUz3F3q
	vOXyG33q01Ce4n8pLImIPIp0ekCOrK2k=
X-Gm-Gg: AeBDietnqGGz+oe+8kvmEYXfrL1YCWtT/JHrKTytkkthmAHDm46U991C7VfyQYvMnU8
	/j0qoNNieIV/bJfWTWkxk0gSquno6IvYeXcYO6qCfPTGR+nsa0ZA+NLVSRW/55P671ouhGC+KJm
	866MoiTvZS8Lz1mU7hVHdr+/gN6HFFN7qz9BuoAVWd2d+lOb2m7G/RUxOMj7yYJWYqEuo5x9fwC
	1MjGSmMvKfWYg8NvWXxp/wb35SAgHY4LIgn4WWpz6I4szUxUYtmzCaocf7L3JwGeJBVudCKJ2Nb
	TCCPlPmbB2xvCKUsUAPIGoTxV4Fw/dvVW5MIwA==
X-Received: by 2002:a05:600c:c10d:b0:488:ae4e:51a5 with SMTP id
 5b1f17b1804b1-488d683d633mr103247135e9.15.1776038499521; Sun, 12 Apr 2026
 17:01:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260402063714.55124-1-liwang@redhat.com> <20260402063714.55124-9-liwang@redhat.com>
In-Reply-To: <20260402063714.55124-9-liwang@redhat.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Sun, 12 Apr 2026 17:01:28 -0700
X-Gm-Features: AQROBzCwnFa6eS6aq3Z0ozwi2axh34qQ3NZxuV-fWDi5MSnDHDQiTKyxtwF61fw
Message-ID: <CAKEwX=PWiCcyX03YrZ6GOXK4MEOhos6TrTNMm=047xApqDJhXg@mail.gmail.com>
Subject: Re: [PATCH v6 8/8] selftests/cgroup: test_zswap: wait for
 asynchronous writeback
To: Li Wang <liwang@redhat.com>
Cc: akpm@linux-foundation.org, rppt@kernel.org, david@kernel.org, 
	hannes@cmpxchg.org, yosry@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com, 
	mhocko@suse.com, shuah@kernel.org, chengming.zhou@linux.dev, 
	longman@redhat.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Michal Hocko <mhocko@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 63C8C40013
X-Stat-Signature: zotm5mos31jko4xx7nxnqp89yx6j8mhn
X-Rspam-User: 
X-HE-Tag: 1776038501-879009
X-HE-Meta: U2FsdGVkX1+A8LXMpBVLWcBQDJ1mz6ANc+MRKrzywWtXl/1JljA0AOTtmZouGSQn/d1DfJW5qcQ5jo2oJNR+TuFPN9+QGna/ZweTFY9LkDcGcrm5Tmv+GtLxXWVnXLP4AGXop8j2JjFtx294sgi3+404tm6nLu7covOQ9MkStg/5MmW+TAli7/7a27SD2iFa8D/xZ/XUzUowrFSVNBlqgjNZ/vuncOQNI2JpWwzIIcAfRVevIf/crtQ39SCOveUpeOq/IhbKibiWOe22uiOGm+8tjJuiqavBdN9vesGp24QQqiKeInabM585ncbCURNXofRhEFiatjdEeRDPOc9hBU+68wa8F8ID1ByfxOg6D0qJpqvZ0frxgvl9IvR1JHlIAb0aBdCH/vjlohZ9PQMj1fOClBwj0ira9VjN/oKJPMJQsBZmn+joneg8e3OyGJfwzj1ACROYWOrGszGuSeT36ntfqIPqZ0Ib3h4xfOC2Uktc6eT+WOgauA9nZRaBYAO040ivsS62/CTX5JGCV+CsVBOu5P+VapiVbH74OZfnjdLTfHCqYrHLopOpStiupWOOm5wSsX3kJH08R7YiPfodKuaLd7QXUpd8oHjb4CLaiSIjlFECVwq255C64RQJTwSnxU62W7njzUH9lUyZDdgghYhDe3fmjJc4Hj15p3+Tgvv38Z0MO+g43MT4ep7JyFrb6sJReaaCMsKoJr5sSvjeA8LA7TCb6lpLI2EHcGeKiqPvch0KAY+pQyJdj/mHmwA0YbttGgkKteoTMw1LwvCC+qV6McwOX1l/49cPmuJbWUk0posWH6VoBaUNdw5bPkU0n9346kJ8ph6Jdx7qjIYkFShiTP/4NMGqXRK3+IE0NnL9HRlhluNXVNlNprZ/bkjJnuVSydkMmr9Ln2KL4tGW9HqsSK70VjFO/tVUw+CQKASJQZ0iURfuGqyFzwEuHlW9+hY+ZnTsc7c5hWGDlsb
 cCFcGLub
 2PzJJVp5bOvbdGpGS0Nu2+ew/09n/HvpCQEHgQY+i2S4DwzC2RRJMBaLPSUyfIReM1vdzBh5PvWVfa/MOhC85X+WzzqKIXS7U+h0DzbpxWpM2qNgRJhPEGjSPJXkzSlJwUbaMk0XreoMdpc3WjgdeqB876DlDijDufk4coOiqz6W52wIhEdE5G7njolsUJHHDsxkMLFsKiRAFQnXxjHIn3vs5Cysqwcl1p+t3UgOCfBMqvbZ9uMsSd+ByAFbJLdckEb8/RbxIsgXxBcgYTgt1mxRrmuZMd1aqgA9DtET+H9+rjyIJEs3ZXN//qapsTsKOAAnlimA7f5I4q3g/kENl9bicWV1U5zB1DKlQmhEzQufdPgAJ+Vv2OYChPz1dZLI8RaY8Vm71PoUaFw+4ReYeBTxiBLKvknOuuEAbaKE4SliYi84hYghupURihafgvnFTAUwJtlJke1/0QbOSSzZuW/s5P92mYVOByaEKVtFUE/FvrKtBg8JwvPrVq1BGnsEXicDxSFs08cSiKKFIBy8569rW66n+3lrNXKZFwm/mEVP+tWLjCP/A2ywMRI8BuXiOv8km/UEV/Of2Td8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 1, 2026 at 11:38=E2=80=AFPM Li Wang <liwang@redhat.com> wrote:
>
> zswap writeback is asynchronous, but test_zswap.c checks writeback
> counters immediately after reclaim/trigger paths. On some platforms
> (e.g. ppc64le), this can race with background writeback and cause
> spurious failures even when behavior is correct.
>
> Add wait_for_writeback() to poll get_cg_wb_count() with a bounded
> timeout, and use it in:
>
>   test_zswap_writeback_one() when writeback is expected
>   test_no_invasive_cgroup_shrink() for the wb_group check
>
> This keeps the original before/after assertion style while making the
> tests robust against writeback completion latency.
>
> No test behavior change, selftest stability improvement only.
>
> Signed-off-by: Li Wang <liwang@redhat.com>

LGTM.
Acked-by: Nhat Pham <nphamcs@gmail.com>

