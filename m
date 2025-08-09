Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 652FFC87FCF
	for <linux-mm@archiver.kernel.org>; Sat,  9 Aug 2025 06:28:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5569A6B009C; Sat,  9 Aug 2025 02:28:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 507BF6B009D; Sat,  9 Aug 2025 02:28:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F6976B009E; Sat,  9 Aug 2025 02:28:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B9406B009C
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 02:28:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 77AC0C07B8
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 06:28:12 +0000 (UTC)
X-FDA: 83756239224.27.8A7222E
Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	by imf14.hostedemail.com (Postfix) with ESMTP id 91C53100004
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 06:28:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cjd8roFV;
	spf=pass (imf14.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.161.41 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754720890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1NUSGToIpiCqsxYy/mriGOw/xYEuRpv/gUdvOiAMf24=;
	b=b5cdcbzvcMsehnKSvZwtvTy03WC1i8mfnE5qHuL8bKmPfckwOTMED4n+iDTc749Ep9w5L7
	NhqlRuIh5SBdylH8Gbdi6KbY7nZm8kbBxFifX1QTh8KyBcJCISQUWgvjt3iFChe1d/cZ6N
	qXwLBwH3uovJDam2odi8x1ZMxHrM0xk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754720890; a=rsa-sha256;
	cv=none;
	b=W8zG6bt83wJQLCjmsU5CrAqkFc0Pws5SHbRtZaxeecsx2Af7ENrOJHgbQro4pT78CuWvhD
	/y5DvVekudq7qXaSZsCqO5k7589d8hY+IFQ1SCoVjqfkxCJBSMTkIE8fWAfVbgXbvgst7u
	iibGX9SIQWV8hLVVrTYDCNcyOPyeumg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cjd8roFV;
	spf=pass (imf14.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.161.41 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-61b6779bb45so489032eaf.3
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 23:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754720889; x=1755325689; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1NUSGToIpiCqsxYy/mriGOw/xYEuRpv/gUdvOiAMf24=;
        b=cjd8roFVH9SWp6r+ZAGRtPJdhoUtK+NWeZYkmNTnyiupOZaZuUSGWczjtN9BOuti3h
         VlcKHYpK2j3lFTN7uKpr4WNM350i/yUQomvrzePFLjvqZqvQYjJjiNx54wSy313mq9o1
         efhW9fhBoUN6rAKsoXfOOqrbPR748opuWjv6umE+GvZ+toqDZUOLBPvczo9I+0M89QXC
         gLbIdrcN7Hy6Y5PrUeY0yxT58u3wnbayA2YzXpvEAa/AtBVhAzD+ziNma4N0yVwwslXy
         BFSIzqhTIwhKrsL+0RiOHkumfEDuH9NDLNLTIh+bFFYzfP+MkCsLoorXYz2yh9LRmJNh
         5IKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754720889; x=1755325689;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1NUSGToIpiCqsxYy/mriGOw/xYEuRpv/gUdvOiAMf24=;
        b=EGc3R8RZ2sySuEKbGSK3NKB33+rbJfXl0W9Cj1AP0gIgMFPvfjLKd98QNvf4LBDc7H
         UK+yy3+O65fyB0X0zMT2hyaOyRH7w8relMwTw1Og1vdibp3P/U6WjiZHF9nh7sDSqCIU
         x0UiNb/iRaQlFejl7KgtW/lKlfFmHLX7rICoFiTaAIh02181yAgyc3Ky/7vwYTxjNtuh
         I0BzouGB5ogYYAQ0hePLhachBp8cdBa3NMjZhtLmJGWgpXsYRmjhmegJm3XqZAN1tIVA
         8bi1c7CXkhMGsKbRG++JKwNblrYO9YzSHEqP8du2365KHYQVCsMHp+4+/5VKntD/u4hf
         oyWg==
X-Forwarded-Encrypted: i=1; AJvYcCUvmEjV2uhNajjw6i5F8Z39i7baKTJEA6B2CY/81Te7pvC/0gM2n4RP5TlPhoMqtVTjkV6CelB8YA==@kvack.org
X-Gm-Message-State: AOJu0YzkD2kbl/KwF9b5xxQc4j8SLhGgC8uzISMZ1sYFa+/Q3xeJO+gJ
	FB5uK787wypX+hlcegmKzhLrFdrLtXCox17woQeBT7c75Rp4UitxxzXn87/ParSJnp7WNCO3kd/
	m2x7gnqjX+5wa2tcQPxJJxLQnLx5NQAg=
X-Gm-Gg: ASbGncthvc6uDxABAPfnKuZ6ztfhKSTL7CQjYQvsTa7kx2B4BLUTrVq3fSZfCnyTKgq
	3ickq8v0GXXpLqsOAhnNPkaKXFRAir5dOEoJlO41WxJc30sei1LIfq7fCA4z47e6X33y7J1+PuT
	2sfGQ3J507B/1EiG61G56tv8pNbhSCd9ITqlKsdXGHU7HrS9BcWRnDKPfE0iJ8h13yYCJP7S6CD
	Mo+
X-Google-Smtp-Source: AGHT+IFrlR5YprEy/GaibTOAZY+V7FODMyfPqVTljLVSUEP0uQ3mypGib8iRbJ9xcNQr9tnCe9f099T4XnJ5KpmHOaA=
X-Received: by 2002:a05:6871:82c:b0:30b:cba0:31d2 with SMTP id
 586e51a60fabf-30c211d8bb8mr4138083fac.31.1754720889178; Fri, 08 Aug 2025
 23:28:09 -0700 (PDT)
MIME-Version: 1.0
References: <20250808195518.563053-2-ekffu200098@gmail.com> <20250808220526.49546-1-sj@kernel.org>
In-Reply-To: <20250808220526.49546-1-sj@kernel.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Sat, 9 Aug 2025 15:27:57 +0900
X-Gm-Features: Ac12FXzAzwBpm7AyG2CHnE6TzB9iPM9xjCqKZwKuSloyw7T9cWBa-XZiuVLbQzs
Message-ID: <CABFDxMHeHYgKPmOy4gAK_-w+4CiVZ-QHyZcxFPT-dLsM9jcdjQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] selftests/damon: test no-op commit broke DAMON status
To: SeongJae Park <sj@kernel.org>
Cc: honggyu.kim@sk.com, damon@lists.linux.dev, linux-mm@kvack.org
Content-Type: multipart/alternative; boundary="000000000000478fc6063be8cb0d"
X-Rspamd-Queue-Id: 91C53100004
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: zcpio6fqgfi1zjnqy1wfm1q4dmw6sok3
X-HE-Tag: 1754720890-791324
X-HE-Meta: U2FsdGVkX18ZIr6jURanjUVAIA/Q/fd6ixoeVhDW1sQlQs1vPk84vrOKfH4wqh3v1f3sCBMVP4nn92kyv/zo6Jc9Q3fZpHgLbGlQlr8HaOyQ8L41CFLwCVyJrgJcGHNIo/PJtLvu5SVIoOwRUgEqTcZsVZFVwHX1fCPJy7PDUk19ui+pOFDFBImDz0uYfRrnUBua8PC5HJHgn+irk8MjL/4OkPi751uS07XFiHrceeOIGC94e4STUkuWEO7qpm/0BLEhcBJ8UbUzbMUoFVQyUGMMWDPUyOeisUrFbMupgdODp0/gRV5GNgoL1ZN30snnW/a9ognsonMKN88pH/AsOqy2XGgFxOSBngtqt+G0a4gclBuH58rnC1zcNX/WlkIRUxYkFShZpq4Rl0es12mEAb1Rhoy2NyEgIurlXkNccE0fVzItBfopWMw6dU6t2+P78PVootgxR0Iz0IwiPnwwhJ/nMYKqpmqEel0YFiGMOhOO1orGnBkWaXGWNidh4shgTXF8/sXBwuMKO7i4Ps2bJSeb53Jiw3ezRm56Z2uXaevxewmms/2ov79eAO+H9mRa46RxUXlVne0Ltu5tYcZttj7zbOAL9fHU1aM+gTQY8OsVkKu6E+yVNlUcpQ9SeLfmgVVqRBN400tFb2PjU9Mcp5hcWqpT+nkWBNWqC5flqkzRC+MGAl1iMNR0fK3sT72N9DLvKjHZEQ7kR9/kRxNpzOD++EXXCmImr7KW8F1r+lRA22TaCSjrLe0X/QpS/Mux5BYc8uLfcOQlbuNAydIi/Xw4MQOZVBR1WStL7dqy1rFYpnTRN4V5PUnb44ifX9bqs6H2p6Hy6UJmajQlBhteGl6ebDFy2M+9od3qhxmLUofYeLzrYgBwZLmMXPjxhfegxeFdwa4/JsqTbqZBN43exEgdH2mCeFTHAcatMtvJeL4G2rMf+1h7F3/oKotzHDL7czSl7odtmfgYVpJDDn5
 3rxwPiZ+
 wibTc9/MOCuIT6qbqcg6mW4LraA+A9zvqPG1GAvZlUsDipXPgj4erQT9ZUJ9xl252LYtmPaE8ZPH+djjTaaE+tHNP3/+J5eBWGL2GCLimUOFqIxGC1rLyUcZzphrzp+hb2bf28gkVttis8wyLCCmQnEUeCNGYV8cC197P+P2k2n1mN2OSzc22ikHWS3/Jj78+07TgkMHmFPdE2/gF1wTIXxRls+jwG8xl4sqN+dSeStjhmBFCVFerS4QjzAz601rdnz22zKWH9+XxXC06KIoMayrrLmiKUtgArBZhMuO4Kq1sIyojpKDQQPEZOC9n0aL2KudGsrajhoKI+fPIU1GrHwLb9wl4qi9NT/Oy93FTdd2SuqfzuQlXUhJ0PLXizjJrJFSAAZiz0Bq/DtUpV8Hs1UsANWpwdus3VgnQiy/SKKdYu6K2mT0lr5R65FGXS6PQAEWwik9jsvuqlmFuQSvBHLjuc1oAVXoQKXblPW6YTxICguBYZd/LWO/JZG5sLxxYgPJEWQLwXO7w3v4iex7Ctxsxyg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000478fc6063be8cb0d
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi SeongJae

On Sat, Aug 9, 2025 at 7:05=E2=80=AFAM SeongJae Park <sj@kernel.org> wrote:
>
> Hello Sang-Heon,
>
> On Sat,  9 Aug 2025 04:55:17 +0900 Sang-Heon Jeon <ekffu200098@gmail.com>
wrote:
>
> > Add test to verify that DAMON status is not changed after a no-op
> > commit.
>
> Thank you for this patch!  I have some comments below, though.
>
> > Currently, it is failing. but after fix the bug it should be
> > success.
>
> To keep bisecting goes smoothly, let's introduce failing tests _after_
their
> fixes are landed.

I see. As mentioned in another comment, I'll merge this patch set into one
patch. I think this comment will be resolved then.

> >
> > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> > ---
> >  tools/testing/selftests/damon/Makefile        |  1 +
> >  .../damon/sysfs_no_op_commit_break.py         | 78 +++++++++++++++++++
> >  2 files changed, 79 insertions(+)
> >  create mode 100755
tools/testing/selftests/damon/sysfs_no_op_commit_break.py
> >
> > diff --git a/tools/testing/selftests/damon/Makefile
b/tools/testing/selftests/damon/Makefile
> > index 5b230deb19e8..44a4a819df55 100644
> > --- a/tools/testing/selftests/damon/Makefile
> > +++ b/tools/testing/selftests/damon/Makefile
> > @@ -17,6 +17,7 @@ TEST_PROGS +=3D reclaim.sh lru_sort.sh
> >  TEST_PROGS +=3D sysfs_update_removed_scheme_dir.sh
> >  TEST_PROGS +=3D sysfs_update_schemes_tried_regions_hang.py
> >  TEST_PROGS +=3D sysfs_memcg_path_leak.sh
> > +TEST_PROGS +=3D sysfs_no_op_commit_break.py
> >
> >  EXTRA_CLEAN =3D __pycache__
> >
> > diff --git a/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
b/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
> > new file mode 100755
> > index 000000000000..300cdbaa7eda
> > --- /dev/null
> > +++ b/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
> > @@ -0,0 +1,78 @@
> > +#!/usr/bin/env python3
> > +# SPDX-License-Identifier: GPL-2.0
> > +
> > +import json
> > +import os
> > +import subprocess
> > +import sys
> > +
> > +import _damon_sysfs
> > +
> > +def dump_damon_status_dict(pid):
> > +    try:
> > +        subprocess.check_output(['which', 'drgn'],
stderr=3Dsubprocess.DEVNULL)
> > +    except:
> > +        return None, 'drgn not found'
> > +    file_dir =3D os.path.dirname(os.path.abspath(__file__))
> > +    dump_script =3D os.path.join(file_dir, 'drgn_dump_damon_status.py'=
)
> > +    rc =3D subprocess.call(['drgn', dump_script, pid,
'damon_dump_output'],
> > +        stderr=3Dsubprocess.DEVNULL)
> > +
> > +    if rc !=3D 0:
> > +        return None, f'drgn fail : return code({rc})'
>
> Let's not add a space before ':', for the consistency.

I see. I made so many mistakes like these; (I worked this very late
night...) I will fix them all. Thank you for checking this moment.

> > +    try:
> > +        with open('damon_dump_output', 'r') as f:
> > +            return json.load(f), None
> > +    except Exception as e:
> > +        return None, 'json.load fail (%s)' % e
> > +
> > +def main():
> > +    # We can extend this test to change only the Given and reuse the
When/Then.
>
> Above comment seems unnecessary to me, since that's obvious.

I agree. As you said, it is obvious. I'll remove all pseudo like comment.

> > +
> > +    # Given : setup filter with allow =3D True
>
> Again, I don't think the above comment is necessary.  And this looks like
a
> pseudo code more than a formal comment.  If you think it is necessary,
please
> use more formal tone.
>
> Also let's not add a space before ':', for consistency.
>
> > +    proc =3D subprocess.Popen(['sleep', '10'])
> > +    kdamonds =3D _damon_sysfs.Kdamonds(
> > +        [_damon_sysfs.Kdamond(
> > +            contexts=3D[_damon_sysfs.DamonCtx(
> > +                targets=3D[_damon_sysfs.DamonTarget(pid=3Dproc.pid)],
>
> Can't we start this kdamond with paddr ops, and drop the 'sleep' process
> invocation?

I just referred other tests. And i think we can remove unnecessary targets
and sleep process. I'll fix it on v2 patch.

> > +                schemes=3D[_damon_sysfs.Damos(
> > +                    ops_filters=3D[
> > +                        _damon_sysfs.DamosFilter(type_=3D'anon',
matching=3DTrue, allow=3DTrue)
>
> Let's keep 80 columns limit[1].

Oh, I thought it only applied to 'C' related codes. I'm wrong. Thank you
for reminding me. i'll fix it.

> > +                    ]
> > +                )],
> > +            )])]
> > +    )
> > +
> > +    err =3D kdamonds.start()
> > +    if err is not None:
> > +        print('kdamond start failed: %s' % err)
> > +        exit(1)
> > +
> > +    before_commit_status, err =3D
dump_damon_status_dict(kdamonds.kdamonds[0].pid)
> > +    if err is not None:
> > +        print(err)
> > +        exit(1)
> > +
> > +    # When : No-op commit, it should not break anything
>
> Again, I don't think the above comment is necessary.  And this looks like
a
> pseudo code more than a formal comment.  If you think it is necessary,
please
> use more formal tone.

ditto (wil be removed)

> Also let's not add a space before ':', for consistency.
>
> > +    kdamonds.kdamonds[0].commit()
> > +
> > +    # Then : Check value with drgn
>
> Again, I don't think the above comment is necessary.  And this looks like
a
> pseudo code more than a formal comment.  If you think it is necessary,
please
> use more formal tone.
>
> Also let's not add a space before ':', for consistency.

ditto.

> > +    after_commit_status, err =3D
dump_damon_status_dict(kdamonds.kdamonds[0].pid)
> > +    if err is not None:
> > +        print(err)
> > +        exit(1)
> > +
> > +    before_commit_dump =3D json.dumps(before_commit_status,
sort_keys=3DTrue, indent=3D2)
> > +    after_commit_dump =3D json.dumps(after_commit_status,
sort_keys=3DTrue, indent=3D2)
>
> Let's keep 80 columns limit[1].

ditto.

> > +    if before_commit_dump !=3D after_commit_dump:
>
> Can't we jsut compare before_commit_status and after_commit_status?

Yeah, I think i'm just confused. I'll change it.

> > +        print("[TEST FAILED] : no-op commit break damon status")
>
> Let's not add a space before ':', for consistency.  In this case, I think
':'
> is not necessary at all.  Actually, since this test is for the single tes=
t
> case, and kselftest framework will say this failed, I think the above
print()
> is not necessary at all?

So, kselftest framework identifies whether the test was successful or not
by exit code. Then, i'll remove this one.

To be honest, I didn't use kselftest framework while making these patch set
because I don't know how kernel developers use it.

If you are okay, could you share how you use it? I just build kernel with
custom patch, and execute output images by vm, and setup env, then just
execute tests(it's so raw.. i know)

Maybe is there a kernel build option that automatically includes tests to
output image? Or just a general or smarter way to execute the whole test?

> > +        print("=3D=3D=3D=3D=3D before_commit =3D=3D=3D=3D=3D")
> > +        print(before_commit_dump)
> > +        print("=3D=3D=3D=3D=3D after_commit =3D=3D=3D=3D=3D")
> > +        print(after_commit_dump)
> > +        exit(1)
> > +
> > +    kdamonds.stop()
> > +
> > +if __name__ =3D=3D '__main__':
> > +    main()
> > --
> > 2.43.0
>
> [1]
https://docs.kernel.org/process/coding-style.html#breaking-long-lines-and-s=
trings
>
>
> Thanks,
> SJ

Thanks for reviewing! Have a nice weekend. I'll do this job after my
personal schedule finishes.

Best Regards.
Sang-Heon Jeon
Sang-Heon Jeon

--000000000000478fc6063be8cb0d
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div dir=3D"auto">Hi SeongJae</div></div><div><div><b=
r>
On Sat, Aug 9, 2025 at 7:05=E2=80=AFAM SeongJae Park &lt;<a href=3D"mailto:=
sj@kernel.org" target=3D"_blank">sj@kernel.org</a>&gt; wrote:<br>
&gt;<br>
&gt; Hello Sang-Heon,<br>
&gt;<br>
&gt; On Sat,=C2=A0 9 Aug 2025 04:55:17 +0900 Sang-Heon Jeon &lt;<a href=3D"=
mailto:ekffu200098@gmail.com" target=3D"_blank">ekffu200098@gmail.com</a>&g=
t; wrote:<br>
&gt;<br>
&gt; &gt; Add test to verify that DAMON status is not changed after a no-op=
<br>
&gt; &gt; commit.<br>
&gt;<br>
&gt; Thank you for this patch!=C2=A0 I have some comments below, though.<br=
>
&gt;<br>
&gt; &gt; Currently, it is failing. but after fix the bug it should be<br>
&gt; &gt; success.<br>
&gt;<br>
&gt; To keep bisecting goes smoothly, let&#39;s introduce failing tests _af=
ter_ their<br>
&gt; fixes are landed.<br>
<br></div></div><div><div dir=3D"auto">
I see. As mentioned in another comment, I&#39;ll merge this patch set into =
one patch. I think this comment will be resolved then.</div></div><div><div=
>
<br>
&gt; &gt;<br>
&gt; &gt; Signed-off-by: Sang-Heon Jeon &lt;<a href=3D"mailto:ekffu200098@g=
mail.com" target=3D"_blank">ekffu200098@gmail.com</a>&gt;<br>
&gt; &gt; ---<br>
&gt; &gt;=C2=A0 tools/testing/selftests/damon/Makefile=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 |=C2=A0 1 +<br>
&gt; &gt;=C2=A0 .../damon/sysfs_no_op_commit_break.py=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0| 78 +++++++++++++++++++<br>
&gt; &gt;=C2=A0 2 files changed, 79 insertions(+)<br>
&gt; &gt;=C2=A0 create mode 100755 tools/testing/selftests/damon/sysfs_no_o=
p_commit_break.py<br>
&gt; &gt;<br>
&gt; &gt; diff --git a/tools/testing/selftests/damon/Makefile b/tools/testi=
ng/selftests/damon/Makefile<br>
&gt; &gt; index 5b230deb19e8..44a4a819df55 100644<br>
&gt; &gt; --- a/tools/testing/selftests/damon/Makefile<br>
&gt; &gt; +++ b/tools/testing/selftests/damon/Makefile<br>
&gt; &gt; @@ -17,6 +17,7 @@ TEST_PROGS +=3D reclaim.sh lru_sort.sh<br>
&gt; &gt;=C2=A0 TEST_PROGS +=3D sysfs_update_removed_scheme_dir.sh<br>
&gt; &gt;=C2=A0 TEST_PROGS +=3D sysfs_update_schemes_tried_regions_hang.py<=
br>
&gt; &gt;=C2=A0 TEST_PROGS +=3D sysfs_memcg_path_leak.sh<br>
&gt; &gt; +TEST_PROGS +=3D sysfs_no_op_commit_break.py<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 EXTRA_CLEAN =3D __pycache__<br>
&gt; &gt;<br>
&gt; &gt; diff --git a/tools/testing/selftests/damon/sysfs_no_op_commit_bre=
ak.py b/tools/testing/selftests/damon/sysfs_no_op_commit_break.py<br>
&gt; &gt; new file mode 100755<br>
&gt; &gt; index 000000000000..300cdbaa7eda<br>
&gt; &gt; --- /dev/null<br>
&gt; &gt; +++ b/tools/testing/selftests/damon/sysfs_no_op_commit_break.py<b=
r>
&gt; &gt; @@ -0,0 +1,78 @@<br>
&gt; &gt; +#!/usr/bin/env python3<br>
&gt; &gt; +# SPDX-License-Identifier: GPL-2.0<br>
&gt; &gt; +<br>
&gt; &gt; +import json<br>
&gt; &gt; +import os<br>
&gt; &gt; +import subprocess<br>
&gt; &gt; +import sys<br>
&gt; &gt; +<br>
&gt; &gt; +import _damon_sysfs<br>
&gt; &gt; +<br>
&gt; &gt; +def dump_damon_status_dict(pid):<br>
&gt; &gt; +=C2=A0 =C2=A0 try:<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 subprocess.check_output([&#39;which&=
#39;, &#39;drgn&#39;], stderr=3Dsubprocess.DEVNULL)<br>
&gt; &gt; +=C2=A0 =C2=A0 except:<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 return None, &#39;drgn not found&#39=
;<br>
&gt; &gt; +=C2=A0 =C2=A0 file_dir =3D os.path.dirname(os.path.abspath(__fil=
e__))<br>
&gt; &gt; +=C2=A0 =C2=A0 dump_script =3D os.path.join(file_dir, &#39;drgn_d=
ump_damon_status.py&#39;)<br>
&gt; &gt; +=C2=A0 =C2=A0 rc =3D subprocess.call([&#39;drgn&#39;, dump_scrip=
t, pid, &#39;damon_dump_output&#39;],<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 stderr=3Dsubprocess.DEVNULL)<br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0 if rc !=3D 0:<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 return None, f&#39;drgn fail : retur=
n code({rc})&#39;<br>
&gt;<br>
&gt; Let&#39;s not add a space before &#39;:&#39;, for the consistency.<br>
<br></div></div><div><div dir=3D"auto">
I see. I made so many mistakes like these; (I worked this very late night..=
.) I will fix them all. Thank you for checking this moment.<br>
<br>
&gt; &gt; +=C2=A0 =C2=A0 try:<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 with open(&#39;damon_dump_output&#39=
;, &#39;r&#39;) as f:<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return json.load(f), N=
one<br>
&gt; &gt; +=C2=A0 =C2=A0 except Exception as e:<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 return None, &#39;json.load fail (%s=
)&#39; % e<br>
&gt; &gt; +<br>
&gt; &gt; +def main():<br>
&gt; &gt; +=C2=A0 =C2=A0 # We can extend this test to change only the Given=
 and reuse the When/Then.<br>
&gt;<br>
&gt; Above comment seems unnecessary to me, since that&#39;s obvious.<br><b=
r></div></div><div>I agree. As you said, it is obvious. I&#39;ll remove all=
 pseudo like comment.<br><br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0 # Given : setup filter with allow =3D True<br>
&gt;<br>
&gt; Again, I don&#39;t think the above comment is necessary.=C2=A0 And thi=
s looks like a<br>
&gt; pseudo code more than a formal comment.=C2=A0 If you think it is neces=
sary, please<br>
&gt; use more formal tone.<br>
&gt;<br>
&gt; Also let&#39;s not add a space before &#39;:&#39;, for consistency.<br=
>
&gt;<br>
&gt; &gt; +=C2=A0 =C2=A0 proc =3D subprocess.Popen([&#39;sleep&#39;, &#39;1=
0&#39;])<br>
&gt; &gt; +=C2=A0 =C2=A0 kdamonds =3D _damon_sysfs.Kdamonds(<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 [_damon_sysfs.Kdamond(<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 contexts=3D[_damon_sys=
fs.DamonCtx(<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 targets=
=3D[_damon_sysfs.DamonTarget(pid=3Dproc.pid)],<br>
&gt;<br>
&gt; Can&#39;t we start this kdamond with paddr ops, and drop the &#39;slee=
p&#39; process<br>
&gt; invocation?<br><br></div><div>I just referred other tests. And i think=
 we can remove unnecessary targets and sleep process. I&#39;ll fix it on v2=
 patch.<br><br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 schemes=
=3D[_damon_sysfs.Damos(<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 ops_filters=3D[<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 _damon_sysfs.DamosFilter(type_=3D&#39;anon&#39;, match=
ing=3DTrue, allow=3DTrue)<br>
&gt;<br>
&gt; Let&#39;s keep 80 columns limit[1].<br><br></div><div>Oh, I thought it=
 only applied to &#39;C&#39; related codes. I&#39;m wrong. Thank you for re=
minding me. i&#39;ll fix it.<br><br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 ]<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 )],<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 )])]<br>
&gt; &gt; +=C2=A0 =C2=A0 )<br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0 err =3D kdamonds.start()<br>
&gt; &gt; +=C2=A0 =C2=A0 if err is not None:<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 print(&#39;kdamond start failed: %s&=
#39; % err)<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 exit(1)<br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0 before_commit_status, err =3D dump_damon_status_di=
ct(kdamonds.kdamonds[0].pid)<br>
&gt; &gt; +=C2=A0 =C2=A0 if err is not None:<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 print(err)<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 exit(1)<br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0 # When : No-op commit, it should not break anythin=
g<br>
&gt;<br>
&gt; Again, I don&#39;t think the above comment is necessary.=C2=A0 And thi=
s looks like a<br>
&gt; pseudo code more than a formal comment.=C2=A0 If you think it is neces=
sary, please<br>
&gt; use more formal tone.<br><br></div><div>ditto (wil be removed)<br><br>
&gt; Also let&#39;s not add a space before &#39;:&#39;, for consistency.<br=
>
&gt;<br>
&gt; &gt; +=C2=A0 =C2=A0 kdamonds.kdamonds[0].commit()<br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0 # Then : Check value with drgn<br>
&gt;<br>
&gt; Again, I don&#39;t think the above comment is necessary.=C2=A0 And thi=
s looks like a<br>
&gt; pseudo code more than a formal comment.=C2=A0 If you think it is neces=
sary, please<br>
&gt; use more formal tone.<br>
&gt;<br>
&gt; Also let&#39;s not add a space before &#39;:&#39;, for consistency.<br=
><br></div><div>ditto.</div><div><br>
&gt; &gt; +=C2=A0 =C2=A0 after_commit_status, err =3D dump_damon_status_dic=
t(kdamonds.kdamonds[0].pid)<br>
&gt; &gt; +=C2=A0 =C2=A0 if err is not None:<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 print(err)<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 exit(1)<br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0 before_commit_dump =3D json.dumps(before_commit_st=
atus, sort_keys=3DTrue, indent=3D2)<br>
&gt; &gt; +=C2=A0 =C2=A0 after_commit_dump =3D json.dumps(after_commit_stat=
us, sort_keys=3DTrue, indent=3D2)<br>
&gt;<br>
&gt; Let&#39;s keep 80 columns limit[1].<br><br></div><div>ditto.</div><div=
><br>
&gt; &gt; +=C2=A0 =C2=A0 if before_commit_dump !=3D after_commit_dump:<br>
&gt;<br>
&gt; Can&#39;t we jsut compare before_commit_status and after_commit_status=
?<br><br></div><div>Yeah, I think i&#39;m just confused. I&#39;ll change it=
.<br><br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 print(&quot;[TEST FAILED] : no-op co=
mmit break damon status&quot;)<br>
&gt;<br>
&gt; Let&#39;s not add a space before &#39;:&#39;, for consistency.=C2=A0 I=
n this case, I think &#39;:&#39;<br>
&gt; is not necessary at all.=C2=A0 Actually, since this test is for the si=
ngle test<br>
&gt; case, and kselftest framework will say this failed, I think the above =
print()<br>
&gt; is not necessary at all?<br><br></div><div>So, kselftest framework ide=
ntifies whether the test was successful or not by exit code. Then, i&#39;ll=
 remove this one.</div><div><br><div dir=3D"auto">To be honest, I didn&#39;=
t use kselftest framework while making these patch set because I don&#39;t =
know how kernel developers use it.=C2=A0</div><div dir=3D"auto"><br></div><=
div dir=3D"auto">If you are okay, could you share how you use it? I just bu=
ild kernel with custom patch, and execute output images by vm, and setup en=
v, then just execute tests(it&#39;s so raw.. i know)</div><div dir=3D"auto"=
><br></div><div dir=3D"auto">Maybe is there a kernel build option that auto=
matically includes tests to output image? Or just a general or smarter way =
to execute the whole test?</div></div><div><div dir=3D"auto"><br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 print(&quot;=3D=3D=3D=3D=3D before_c=
ommit =3D=3D=3D=3D=3D&quot;)<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 print(before_commit_dump)<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 print(&quot;=3D=3D=3D=3D=3D after_co=
mmit =3D=3D=3D=3D=3D&quot;)<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 print(after_commit_dump)<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 exit(1)<br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0 kdamonds.stop()<br>
&gt; &gt; +<br>
&gt; &gt; +if __name__ =3D=3D &#39;__main__&#39;:<br>
&gt; &gt; +=C2=A0 =C2=A0 main()<br>
&gt; &gt; --<br>
&gt; &gt; 2.43.0<br>
&gt;<br>
&gt; [1] <a href=3D"https://docs.kernel.org/process/coding-style.html#break=
ing-long-lines-and-strings" rel=3D"noreferrer" target=3D"_blank">https://do=
cs.kernel.org/process/coding-style.html#breaking-long-lines-and-strings</a>=
<br>
&gt;<br>
&gt;<br>
&gt; Thanks,<br>
&gt; SJ<br>
</div><div dir=3D"auto"><br></div></div><div><div dir=3D"auto">Thanks for r=
eviewing! Have a nice weekend. I&#39;ll do this job after my personal sched=
ule finishes.</div><div dir=3D"auto"><br></div><div dir=3D"auto">Best Regar=
ds.<br></div><div>Sang-Heon Jeon</div></div></div><div><div dir=3D"auto">Sa=
ng-Heon Jeon</div>
</div>

--000000000000478fc6063be8cb0d--

