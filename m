Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 117BE606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 01:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sLqv12Di
Received: by kanga.kvack.org (Postfix)
	id F1B486B05B2; Mon,  2 Nov 2026 20:18:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF2766B05B4; Mon,  2 Nov 2026 20:18:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E08B46B05B5; Mon,  2 Nov 2026 20:18:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B6C306B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:18:52 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 51ADDA7C5D
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:18:52 +0000 (UTC)
X-FDA: 85392048504.17.0A38631
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf04.hostedemail.com (Postfix) with ESMTP id 604314000A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:18:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=sLqv12Di;
	spf=pass (imf04.hostedemail.com: domain of sidchintamaneni@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=sidchintamaneni@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793668730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sT+iwkyUHg13Sji7Ja6rjIl95rvdOCDirpcyZggID1c=;
	b=EiVBd2wSzGIWUhrSdFwwBD+uhnCQW+FqVYUjWd8ingQeH7xB98qY2ZsaUn5Sv8BtlNUZk1
	8gbkZaoUb7m77upO45oC+xH5FiXELXeTGXbOIGdytpCYTmr4OJ9K5DDvDER9QxVTP0mv/2
	C4jn7YwNCfG2aTtn2OF/enkGF95t0m8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793668730;
	b=XcvCcCkJNap21IVERkZEcYsct7S5zJQIadJqq1WXfK+6jfL0b88WiaomR+uuEzHC7BB6v4
	qdxdAnO1QUglojntYaiIrg9zlHRXhMq8ciTNkoaQh+/UlStNNRgPITLknPi5Oq5anKwUvF
	aT5ETm3ok4gz3NPbg7uzSY3FFupDcFg=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=sLqv12Di;
	spf=pass (imf04.hostedemail.com: domain of sidchintamaneni@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=sidchintamaneni@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-8b0cf2c0785so29830357b3.3
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 17:18:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793668729; cv=none;
        d=google.com; s=arc-20260327;
        b=kI6BHzq4J/GsI2WlEODfA23htVW+4+eqs+nJIxSHeM/tlvczctOKh5g9zQdr8+Fz7x
         VT1aJ7EDDsxTFY/3XYoWs9kUBhWJFDfbai3Te+L+oqgJc3RRQOP5OvjGj7WA5+VMGs//
         QwkTJxl/Tb0PQ+IMDVNRCn/K9sFkHtWLarwGcDzTTCcN/vmR323nOZ7jTCL+5hSy87T5
         xKfMj9aQw2lZxS/bhzWDoy2HqtquPFITfD3OV9hmXBNv0epuoBfXMzvcIZ5k5ZmtQQgP
         8c1UjE6X/g9cE3FcUMAsy+ddTIivDRRF6x8sEiKoQBNuGPaZD+UxrFFIadw0nHUleYBQ
         CboQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sT+iwkyUHg13Sji7Ja6rjIl95rvdOCDirpcyZggID1c=;
        fh=KPtKN3TjOOPr8d+mJCwU//BGSVuoAVzNRQopl1x+mQk=;
        b=V+rdC4/eBZBnEOP59hYeKSO2u8WNMkzDPkbh8V13n2MGyqyo6T/pXF+E69qoi2OBSC
         2szTnHgU57a7TQzu/pWVJzOWc1SOLjd3PfJlDkAX+1UBGsAW50C2n0RkXQgJrtJs88be
         0KG6TlfuKkFKNVMGkYD5HfeBWsto0USaPvyoxBcwAeAA+LP1fDh/0/tVnCMC80Vw6dx4
         EUAw9ST6Ag8K+fHWcWoGQiisQXAnNdb3awj6ZtccrR1TQDTAtFBSOXTVAX1kCDFtu36M
         cHXS3zeaK+HW7rZklSY1Ap8q1PEZDXNR5DP0X7xbk1gLH2bXzlvY+SVA0Vn2gSn3yLlZ
         8mHg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793668729; x=1794273529; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sT+iwkyUHg13Sji7Ja6rjIl95rvdOCDirpcyZggID1c=;
        b=sLqv12Di4pNuojCP9H5oRE2KsVnt6BdzEaE+w/SAVeCYAX1lTtjLU5oWTpl01Hm8bL
         AOOxDnu43kAA71KvLkt/Orb/cRfhxUQtvaeGWSwRcWr9UrEKGaCq8w+cyku7ZmD21+Vk
         iQ8uMo8GjAaLZRQHRAa7PGk+uIsl0j5HDeo/++TQF6Xvg/EXacT1BOJdg8RR5nkzz9BM
         XehJ2N93NdEvaLVxXy5PostbCAMTAU+bqEFhcWrsnoenPeLX3IhUEt++vqeNmy2RmIQD
         Z4NuT8YsbOyI4Iu1Yg/RPHbA+fLGy/PVEjFcEXSY+X1QswCYwhxE1TqKfca1qgGfcarw
         e3sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793668729; x=1794273529;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sT+iwkyUHg13Sji7Ja6rjIl95rvdOCDirpcyZggID1c=;
        b=2FaD5CqDVTVzi3zc+5c/Efi8V1xa5o4eVUIdNdFfZUVNpP3ZVAwhrxIePkbLuJTcMx
         c8OwFuAUfW8S2qbmttStEuVyaWhFJ7KpaBXCICo31nxkekjl7m9ejuCo02Bh0v9gYHBD
         iJUDpiqCo37lWKwqzupVo9TMCKsMFnnfIsREbh8mGi7uTc0NAZYiUHE207RiBCtIy/tx
         TrRyIPFwZ4OsQIS71VRx9qEeh37hxrq75cJETJdDiDGy/8CJfHhqk4IHiJ/PQlN5lu06
         EAFhakPpJMrQy66iukHzGFZS3IlvuROVOrkLzbDGBlftxyfwmNzI9sc0+I3z31p+xu+O
         5jAA==
X-Forwarded-Encrypted: i=1; AKwUvBz/7avJk2D/D33BJUPJNRVDdWwYmednmWSebd3v3soj4+HckREKHlbc/GDyr6KFQIRbNDA8hXF6Ig==@kvack.org
X-Gm-Message-State: APuU4Z84Fa4wTUiuVH5wT6VV9K6X55XAeOstgXnmk2qnwbpBRqkMMxOm
	Ur5hqLSzvon2YJcosYBmb++SsD/6rGsD+bVdH8EdIjiIH8EOFFi19fgCIO8P8VGjg/e3PBdhtTc
	pkxqQLGxhYXTBLyhTpDQa/W13FUAt+XQ=
X-Gm-Gg: AYBFou0I3Otq4FUj48rkqkYITZqKPJiMEwb4AsaSq8GGz4opa/5BSXVGa/ePNn+IJIm
	SiYBWKlWyTIb2m+sXZ+oaahsxo215u7SEGEVsbqRYSwtenzIm7GuzceKR0D5zmRgnzj7JQrQdPK
	2c9/yCcH3CA/OKWT1KVpgSmmqtSJxvRynW/FwvGlWSU1LR+fv3b7m2CLqigUmWV/GNoLZesReRb
	dt/u0OKc1Hw7BvFXiYkpJW7QcDoKcEU1w990ONsomKyS1s8d0k1zRuNXdwVzwbEqms/xzTWSQRH
	gtDWhELraIdRSGnXyvbW8YgB7gsHZKl+DKbQgqoPf6h07GqDS4vh8k7/xTuJ0x3+KxEuVaiIDVL
	1RRheWBO/PSHK7tilIeQCtbhInDY6yt3tg12PEyb/kPgXdDBm2JJIMit1ze+sYwQ3KmwadqY4tC
	q0nK7cFGjMw6ry57VOpWQKFGpF7PyXjlkNDYaT7gB02lMfr0U1PqcEsR7vK7tTII38bmv6F03a6
	cZK2Qk=
X-Received: by 2002:a05:690c:e147:10b0:8b1:567c:e7ae with SMTP id
 00721157ae682-8b2b67233f6mr47961067b3.47.1793668729285; Mon, 02 Nov 2026
 17:18:49 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261026202313.63122-1-sidchintamaneni@gmail.com>
 <20261026202313.63122-3-sidchintamaneni@gmail.com> <CAGsJ_4zGmtvOApjFH_-V9z_zNWWQnrBX9q0_iWtbqzENCetfgw@mail.gmail.com>
 <CAE5sdEhVfFuiYySA0cNPTV6FjY3wnwccfLR7HA9vhVOF7DH+_g@mail.gmail.com> <CAGsJ_4wHywBK9iYAzH8DY2KMFO-9oGa0f9N8aLUtzNNv6j3C5g@mail.gmail.com>
In-Reply-To: <CAGsJ_4wHywBK9iYAzH8DY2KMFO-9oGa0f9N8aLUtzNNv6j3C5g@mail.gmail.com>
From: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Date: Mon, 2 Nov 2026 17:18:37 -0800
X-Gm-Features: AclHuK8YPGhiAk2Gjr5YusW-Wxb9ms2GlXj1s1TmR61RHXjCn8KMInnrW2kxE7o
Message-ID: <CAE5sdEjnhXK9jL03grhro-_jKWnd0rCFn_pN6SrFNzt8yngCLQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm: multi-gen LRU: remove get_lruvec()
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, ljs@kernel.org, 
	kasong@tencent.com, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	yuzhao@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	apais@microsoft.com, rlmenge@gmail.com, 
	Hardik Garg <hargar@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: yqes897twps5myrzyibftkgy3euepaho
X-Rspamd-Queue-Id: 604314000A
X-Rspam-User: 
X-HE-Tag: 1793668730-148632
X-HE-Meta: U2FsdGVkX18JILMULR2astJFYOM7g+ooOMYsYIdyQWbWJ5W1PBKVQCEoSmGF4hngWNCI0oYsDsTe1XClXI/CVq7h2PPS1C/U2un/D4ym+9lxLIrT/PHUU0br+GOST5FlF4KoaJIez5aMU5siBPbLpoN75BFPuIN0WBwoT0I/xTwexvNAp8jFezuCEkS5WXWA4LUXbDeEW86i8w0sq3JsqZl6l664dDWEO4s7hiNTls1PSX8jqPVwx5PGtqVxEKKVtXYJ9JHgWyAE01bKgU685vxyWonXoPLTgYZ/I51H2JGPbX4q7LNKt2ElKhcse65XGAzn4L9vvf48DV+pPNN/1KTJcSzLx9I2kTIa+jWKHqTECUPErF/ajlhMWSCpiR4B3r0lJC+hntwNv+eojMunh/nrbgJZHYHRtNdR/GoG+HgKOHuoMqX0GlmV1K+3uWOTN2cH4ziVGHBSnSVcKwMNnGAW2CTpHmRHwJQwe0NBceCelwhPRe5a73oKGUp0k9oWFnrNMPpjTX1CLXeI2EVLqhHi32qpY8SzN58l2dihVlnu4CPq5dEu8sxuziUOiMl+6s/d2+szj++tax2eVWtM9vibmArimhrXbkzP3IvLkssimdoWgul1KWAEYjNRn1zYxr/ONdd8PeeSxuim43XIVBfUk9dEqmAx4Htvrx2uIfkFfFNK8zrwJpUqhtKzA7cVxrpfFf/R+Vh6oCZZWHE6iGB6rr1lNpuI62HZLkGpxDAHxNr2fcJeNQiAWasbOWedrVMdQjuM0VTDKU+fHkqD813vP031Ogumx+RVL/LEVqw8pmXbYUz/Cz6DGbdGt5LZQIM7xCnKag07GvgDp64btrvGLF6tNogy/XHaNlshFGATpNWYMkcGyNkEPLrHvyUyI6+P1HrR2ckmcjAmyG6Hu09mgEyar4K8CT/L35ZCnRcoesvSltJxvgU+akEBOLA78WGvRvcd9vQke9ws4eo
 N5A5DoBi
 P0Utmqb+XTZF5ulCwbmL5yYx8ra/INNG58aC/6G9N/5oQfY8i1hJbVKHqoWHCYRzRgkfhrAJMT8HFLN2OqpAN/Q0gbfzWjwhG3GhgZgth1hXjaG7CNFh7xd0SAq5nQLPrcJ9tjhqhqv4RTNmtIfMiw7tjtxoGXzQjADlpOqnkl1U0tpxf0iIQRTHn/R68Zt6SI29M+cJ9K1wuNr76LCBE1ZKJioRsd7DkGeE2EdURj4qXAIQ9+ITq+hT5eL4vJ6K74+CpAEYWbsPUdm/rXsOqXZjwCvvUwaNzU6i0ZYILC7weBDZa2fUGCUgIamBblauJamm9FHSJ0AufKbca45kk6adLlRRPNuDHPerigr5qVB5RsRMQ89ojfCHjnVFGKMqe30HkR7aP02SjwLbHvGnPuYoUPhhUhQ2Bc3Y5lp1UCeyqZvxM2WnFD1EFtnLhLQt0aJm+7c/RtNapG3161Tp07mnso98s8YLuPG5bcVVeKqIAcEcUTURBB8sQopUnHpvqF13J2Els6klL0l+f6bLol4D7bo9FkcyMS6Sm+DdFN26MgNQPjNWvDcTIAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2 Nov 2026 at 16:20, Barry Song <baohua@kernel.org> wrote:
>
> On Tue, Nov 3, 2026 at 7:35=E2=80=AFAM Siddharth Chintamaneni
> <sidchintamaneni@gmail.com> wrote:
> >
> > On Mon, 2 Nov 2026 at 14:56, Barry Song <baohua@kernel.org> wrote:
> > >
> > > On Tue, Oct 27, 2026 at 4:23=E2=80=AFAM Siddharth Chintamaneni
> > > <sidchintamaneni@gmail.com> wrote:
> > > >
> > > > get_lruvec() was originally introduced in commit ec1c86b25f4b ("mm:
> > > > multi-gen LRU: groundwork") to guard against NULL NODE_DATA(nid) on
> > > > uninitialized NUMA nodes (`return pgdat ? &pgdat->__lruvec : NULL;`=
).
> > > > After commit 09f49dca570a ("mm: handle uninitialized numa nodes
> > > > gracefully") and commit 931b6a8b36a2 ("mm: multi-gen LRU: remove NU=
LL
> > > > checks on NODE_DATA()"), that NULL check was removed, leaving
> > > > get_lruvec() as a thin wrapper around mem_cgroup_lruvec().
> > > >
> > > > Remove get_lruvec() and call mem_cgroup_lruvec() directly at all ca=
ll
> > > > sites.
> > > >
> > > > Suggested-by: Barry Song <baohua@kernel.org>
> > > > Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > > > Signed-off-by: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
> > > > Signed-off-by: Hardik Garg <hargar@linux.microsoft.com>
> > > > ---
> > >
> > > It's great to see the MGLRU-specific get_lruvec() gone. Thanks!
> > > Hopefully, we can get rid of more MGLRU-specific code,
> > > such as get_swappiness().
> > >
> >
> > I just looked into removing get_swappiness() in favor of its LRU varian=
t
> > (sc_swappiness()). Do you mean moving the additional conditionals
> > directly into the callsites?
>
> Nop. In MGLRU, swappiness has values: 0, 1=E2=80=93200,
> and 201.
>
> With swappiness=3D0, MGLRU only reclaims file pages and
> doesn't care about the hotness of anon pages.
>
> With swappiness=3D201, MGLRU only reclaims anon pages and
> doesn't care about the hotness of file pages.
>
> In both cases, we allow cold/hot inversions in
> inc_min_seq(), which can help reduce CPU usage:
>
> static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
> {
>
>         /* For file type, skip the check if swappiness is anon only */
>         if (type && (swappiness =3D=3D SWAPPINESS_ANON_ONLY))
>                 goto done;
>
>         /* For anon type, skip the check if swappiness is zero (file only=
) */
>         if (!type && !swappiness)
>                 goto done;
>        ...
> }
>

Interesting!

> Then we could have cases where swappiness is 1 ~ 200, but
> we still cannot reclaim anon due to:
>
> 1. Swap is full, or the memcg's swap quota is exhausted.
>
> 2. The allocation uses GFP_NOIO, but the swap cache is low
> [1].
>
> So right now, we have to hack get_swappiness() to return 0
> to ensure that reclaim only happens on file pages, or we at
> least need to hack reclamation path to use swappiness=3D0.
>
> This is quite bad, as it can cause cold/hot inversions for
> anon pages. I believe this is already a bug in the current
> get_swappiness() implementation when swap is full.
>
> Ideally, swappiness values from 1 to 200 and the reclaimable
> type should be orthogonal; they should not be coupled.
>
> In other words, we shouldn't need to force swappiness=3D0 to
> reclaim only file pages. If swappiness is set to 60, it
> should remain 60 across all MGLRU reclaim paths. The
> reclaimable type should be handled separately, without
> forcing swappiness to 0 and introducing confusion and bugs.
>

This is more involved than I initially thought. Let me play around
with it a bit and come back.
If you have any suggestions with experiments that I could run to get a
good understanding on this problem, let me know.

> [1] https://lore.kernel.org/linux-mm/179248830836.1744016.842421781128661=
6919.noio-mglru-rfc-v2@bytedance.com/
>
> Best,
> Barry

