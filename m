Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1AC1606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 00:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=e4RKXyPy
Received: by kanga.kvack.org (Postfix)
	id BBE626B0803; Wed, 21 Oct 2026 20:19:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6F706B0804; Wed, 21 Oct 2026 20:19:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A86D06B0805; Wed, 21 Oct 2026 20:19:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B2A26B0803
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:19:56 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D34691601E3
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 00:19:55 +0000 (UTC)
X-FDA: 85348354350.13.D49A664
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id E653A40002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 00:19:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e4RKXyPy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792628393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7LKanmub9UijD2PMm7UCSGFp6N4jqIqQ+Weyqyg9TkI=;
	b=KP0qmYHfQbcd1Wh3V04o53+eRUA+LdnnEGXZaXhmFQ0B52gy9fV4eebVMK5YXAalm65Gg6
	xjKwgfw0s2g56rHEHgWGzTgfCQiNWFUXYn3R4HPutnQplpBZ4oFgyPZq8bTcIfg+l6ib6u
	EZRkNZ/EmGki7Z/LXjRlwaQtvaBLKm0=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e4RKXyPy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792628393;
	b=he9tTfYof/541kL9kX3PGoM1TmDgh9ZsdDXmcbykWBo+t6NU2j3mOB76HRrxUZVpnTkYqB
	v+nDWiptChJ7Xe6TfCr8pjt5ODbQQoJ7XAmyN11mG0VdXfhskmib8A6Zx1R5pwmzDCNFrI
	2nkIMirtbBAo4+/R6w6sCwAzGTJTLwg=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-93e4c00d71aso142263885a.3
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 17:19:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792628393; cv=none;
        d=google.com; s=arc-20260327;
        b=B7h3wsOuhMQjZ0l7yL/xM4EM2sr3VL4om8asfuJMs8i7cQ66dtcP033W/n1RzLC/gt
         OTV4LcES6RMLVlFeNvjhFeg30EEyfQ6J6NFbROXwCpJjZ1uJE6Ty/hivbZFB1TsahM+h
         htGgNnDch7E8AFhFkKZddoWvDcQbQdWLUQU5VLi6phMjLGZDa7XP06Qgq+YEHC7BIlAX
         P9N3TxgjMLoKr8AA/CF7ztL+QXLqQ4o/6Lu0X8GsFpcKHPBcVw2LOpquHu22m4f/U33i
         HNwEThtIzaMN9efURvttsHbgZRIR+7wXR3h8WBdC00QUJlaQUd72jdLIQXYBoXthRa5q
         j8BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7LKanmub9UijD2PMm7UCSGFp6N4jqIqQ+Weyqyg9TkI=;
        fh=+8Wcsx3ZrmrAO4m5/+zTDcLnbRKTNSuRYVXPHw/FDoU=;
        b=FP8IVM5HreSyx0oy0dzsbiFIgspdrSxa9FbEslk2KDjh89KvrijlWcm/p4wvEUCJhM
         +DV6rvvcgz6RF3y7SfAZlz3keuA9iK+y9ImLrpKuobRF0vNyvhOGzOz37MTf/RqV1WKv
         0ggxwTdNoIb8EZxB8B76UHqHv8CpIdxr9gMAjU2KQYX4syFePeLApybieeoE2XBoUtHX
         wJ7HPIiWD2FtxkjzB7yhYEjQGvdaAhvOmxXZGMb6Nt5fd4OAUSKXa2ablvvDsb5h4gG5
         E7EoIRdQ9ZSDPP4JaWKg+tg2IsOZOZd2m/tkqa9rUHuNEDTJsBsV/p/dtBCCIeopUdMG
         W2Uw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792628393; x=1793233193; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7LKanmub9UijD2PMm7UCSGFp6N4jqIqQ+Weyqyg9TkI=;
        b=e4RKXyPyUio2AgKiHpMMxa3vJ+RAAZdltUOaAwN5p7pkbF1P3o6nAIcDanZYWSrYPL
         tNGji8tzFmXbh8pE674XV1K6B2NAkT8xHGBOYxiSMP8cGkymXYcSr8QRRnXUfYl982Lj
         FM4CIEzx0RJLd7IYJ9pTmAhRihL7hguDUI6KTEtpEx3qUpeo9ccp3FBjZ8VXLdbsoW2N
         JYnDtm0SzQMKGZM8X1gfffzrTB67LX7FJ3tb0aGs2KZJF6rI4xBPbagCXRdv/hLQc2Wz
         Mcqh4Aez89WsKKVAtwpr/IhspmQ9rPhEKNeJWkedL6reSHYdKhfd3E/lJkyRjs1+csHs
         rV1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792628393; x=1793233193;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7LKanmub9UijD2PMm7UCSGFp6N4jqIqQ+Weyqyg9TkI=;
        b=cd/QDI7illWDnbTPZPzFg5MWyDe3Kw1+V33at7glmibFbfCeZfsCShReR+qqPBVh3R
         d7iKndQ9eVBHVK6UJ9hl5e7QYAqE3xVyNxk/AAz+yS/g4JHdzyDpCmWTVNtZPKvC+h7D
         AWwPsQt5JncyUMSw2wN0MvKWIwTA1KKq4ks/hpQ9QIg/MpSUcTLQ2XdBoTp/d13Ovs5s
         p+q5NCFKzgJwNJb3LCoZaWKTkn+OzPlHWl+kiAE7DoJkdzY2+SBifrplZNc44WGL+hNY
         vY97yhx4Oyr4BPpihAquEkjY0LFBtcj3vZlIV0ZNCVRT9XdpB2nJ5S+WF0NL1Y2vZBud
         29rA==
X-Forwarded-Encrypted: i=1; AKwUvBwkHUmLV0TL7Rx9n7EBE0nYetvZm6BMF8HJA7kzXLsWbhVUq4XEEs/I4H8p8rM4TbTSynOeIW58lA==@kvack.org
X-Gm-Message-State: AFq9FYLj7xYpo1Fr+fx59merkluB+yZnZCuRyjz6c2bDVJg2WCcYpjFL
	MbzTJpdEIhGssURI+ExTGpf2WLdBq15LdxhKJcuypHHvwfIdJK5WeiMYL4KvPouYtTAfJmpQfpj
	p4kZ5wXDfRTHemWks46u7exUlE7uCc5w=
X-Gm-Gg: AYBFou1L1oIfmNbNyopvy6GfPFyA4oQMr78D4Lv/9Yxg6oXpGEpBcwwD/QLDCqf9ntl
	MCWPafJvvEEh6PwEkHdCxvsbtb7o5l4poTjSlCd4K2W2JLG1S3Wl4dq+WiZ3RjhuqLfCKCvvdF0
	x1+DhbIAR3gzSdoIyHLyYWvwiIYRBLLsFQXsWGKlaQpuJY4YC69u5YRY2XhapyBbHL+LJmp9qd/
	czyJ/nZ5Nn/xhYkZ9FkUqmgfBDQZJG6RJM9uPN6Qa78mepAF7HdoHeBEFcpDcVeqeBFHaxEKVKW
	WomAgFmIEAIZzrU+j3zVJbsXo5zmcqIz41CXePujIQQSllmRXqewfLcXiGlP3XGFcbaCdleaHQ0
	iB2VLUgFerrxBO8kZJfNL73GHQpzR8YkWhXSBb64Sw57cblbI77NJ6qqTt5QCNeLdjdmMY4twH5
	fp3kJTfOOBUqaDPWv0jL8VQ+anMmSdTaHYFYoryH5e5Ha/fnmn
X-Received: by 2002:a05:620a:4505:b0:93f:1dbf:6cf9 with SMTP id
 af79cd13be357-93f57fb7c32mr727310985a.33.1792628392905; Wed, 21 Oct 2026
 17:19:52 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261021075322.923-1-hdanton@sina.com> <20261022000822.938-1-hdanton@sina.com>
In-Reply-To: <20261022000822.938-1-hdanton@sina.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 22 Oct 2026 08:19:41 +0800
X-Gm-Features: AclHuK-8o9GQW_xs43Q0Qq_oZJaNk93VFne7SJrKQjUrSEZ5apBJRUVwrXnRIsU
Message-ID: <CAGsJ_4wMQteCGxQ7wxUKP2g96myo91ipF_zedFVVbxKdDrb=bA@mail.gmail.com>
Subject: Re: [PATCH v6 09/13] zram: split zcomp into separate R/W streams
To: Hillf Danton <hdanton@sina.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E653A40002
X-Stat-Signature: dwk8yx3n7w65jsxhbosi4jxztkzwypsp
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792628393-935016
X-HE-Meta: U2FsdGVkX1/m21LwQAvDkC6Yu73PBEw2aqW1hwyun3Z4NlH5bCKtpaRRHShEvWlJGH8NqtO4EwYVlFhYDG3bPMEWXMH1bJCX/gXPdvK4lWJxQRYZCpsYxzSCqqETyIQbK13aTzgdy/75U6axDZqqiaJcvOYh2NznI2xHXcG8Lz4BZMz1Z2Ne2dTOwJ0/XEfo7lilKDnA6nzvoz708cCdsCw314ZACzBAZSeJlVC+VMhNEnNszu+W83lZpbghQyE6CMoFlawlA/Ieu3lyBEmySvFA+Aot8ystYDBN7B4UOi/vPlyRwDFriEUhAGQ21MkrhNw5l7wOdCdEN4QTQ4gnpqHDXxOvReHARKIdRxwYA3L8YGzZzbQZBD+Leli9VxPWiZpxmhMsKPy1qyMX4PstatO/INsdk59swGjcrCspcGSsG+Z3HRfYfrIWQOlUJ5+vVAQy/Cy7/haZz2y+r941JCQ/7P2qKrxghfcnAg9O7J0vZX4TBwG7Euz3ih+vypj3zJAn/8t3WqPgwgy1dVg5rcd2UjNH5x+fvSfpwn+s5bTVi6b/RDotlFD4t5qaryzhO8AB+4ii+2YFdhZn71BDRWAN6PnGqjpTob50S2WanjtO+OVVPp2uBVsOhvOU53NdUGEi8NpFQGbcmveg2BEUitzJS/x8YNQ5Vlkc/9vGCbs0nwzPAg5Swrj1ZuP65FrmH5ZE8Ea9B83R56AsKzhshJf8zKrbe0K2NVU/zHeqyyOw45t0U5xAH1kW46CNgdf/UBAMgaRhIL9yoR82XE41JVEng1RIIwz0mxzn3LD+jMoj+DrLQjKpL81xuf+rBfwVfJT4EHYHRosdQMlms5UoRXhlNVpP67RwkYnFE1CftbRwHUFeWZoZKXk/suqlkhzA77W9G/BkA1JzKBkMVE43Prn32mLnuroi+xFAjBndUUWnG4S0Nc37UOmSF27Oe8uUTklXzj770w2AUCoZCLf
 X9OcppyF
 rrCGp/RnM+Q+AXWmVTbBfZvkDwUTZ7zl6ETRu6ZPot++Axw/PQycgbsINF/vze73rjZFD7hroRW1ZQ6RcBEWUnR9ZV+gyuCnE3Tn+apE9bZInBqhwk8K2eKuGbPEYsqb8744btXGOf7vUnzC6ybccVRcAsW1YNyV3OzY2Jf7TOrGzoMB9d9k84htcAtnvli/GqyrEvSMZ9oJQI0V83hTcaOpHGyWVDqn5v0Jx/hq6QPKrAFk//zIOayPmV3v15iQfUnXZaKasLL8dfRslhZwFpOHAITrFwJW2eOZrVaLoupgFwvZrE838wYPVYjqpXMjdTE3yjATnf06b385zXsVeTjTvIfR0Y/GqLEDu8tcJUiwmrTA324G73/xWOWPVex9iQ2g5oxmkUMA63IotXQeR984iXUft7MyDkDeMSC+RcSBQAUI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 8:12=E2=80=AFAM Hillf Danton <hdanton@sina.com> wro=
te:
>
> On Wed, 21 Oct 2026 15:53:21 +0800 Hillf Danton wrote:
> >On Wed, 21 Oct 2026 13:56:17 +0900 Sergey Senozhatsky wrote:
> >>On (26/10/21 12:23), Hillf Danton wrote:
> >>> On Wed, 21 Oct 2026 11:42:19 +0900 Sergey Senozhatsky wrote:
> >>> > Split struct zcomp_strm into separate compression (Write zcomp_cstr=
m)
> >>> > and decompression (Read zcomp_dstrm) streams, and split zcomp_ops
> >>> > context creation/destruction into create_cctx/destroy_cctx and
> >>> > optional create_dctx/destroy_dctx callbacks.
> >>> >
> >>> > This decouples Read (decompression) and Write (compression) paths s=
o
> >>> > they no longer contend on the same per-CPU stream mutex (Writer vs
> >>> > Reader priority inversion).  Currently, a (low priority) Writer tha=
t
> >>> > holds the stream mutex can be preempted by a (higher priority) Read=
er
> >>> > on the same CPU, which then blocks on that mutex until the Writer g=
ets
> >>> > to run again and releases it, which can take a long time when there
> >>> > are other runnable tasks on that CPU.
> >>> >
> >>> Given lock like mutex, priority inversion happens from Monday to Frid=
ay,
> >>> but I wonder if you are inventing some wheels in 2026 if proxy excuti=
on
> >>> works for you.
> >>
> >> Reader-Writer split is a foundation for further improvements (like
> >> singleton recompression stream and so on).
> >>
> > But that split is not needed at all if PE works, yes?
> >
> Because PE is good at handling complex priority hiarchy. In a simple case=
,
> task1(priority=3D1) is the owner of lock1 with two waiters, task2(priorit=
y=3D2)
> and task3(priority=3D3), while task3 is the owner of lock2 also with two =
waiters,
> task4(priority=3D5) and task5(priority=3D7).
>
> When the number of locks and tasks grows, I have increasing difficulty ev=
en
> describing the lock chain that you in combination with Brian are unable t=
o
> handle. That is why in general PE is prefered over whatever wheels you ca=
n create.
>

I still believe that reducing lock contention is the most correct way
to address  lock
contention.

Proxy execution and other priority-inheritance mechanisms can help in
some cases,
but they also have downsides. For example, allowing a low-priority
task to run at a
high priority can affect other tasks. When many tasks require proxy executi=
on or
priority inheritance, they still compete for the same resources.

So I'd vote for reducing lock contention as the first option. If that
turns out to be
impractical, we can consider priority inheritance.

Best Regards
Barry

