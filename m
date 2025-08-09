Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2440CC87FCB
	for <linux-mm@archiver.kernel.org>; Sat,  9 Aug 2025 06:39:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 830786B009C; Sat,  9 Aug 2025 02:39:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E1C16B009D; Sat,  9 Aug 2025 02:39:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F73B6B009E; Sat,  9 Aug 2025 02:39:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F6076B009C
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 02:39:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F413F1407FE
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 06:39:55 +0000 (UTC)
X-FDA: 83756268750.15.06C15CF
Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1F92F140002
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 06:39:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="JKb/J0IG";
	spf=pass (imf09.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.161.50 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754721594; a=rsa-sha256;
	cv=none;
	b=MFYnYrkOS+tk1a63N+711ehyw9eSZ+AMtgu6aP08EaP0iBPxeD6KJ/GUOf2oTin3jnM+hz
	afYKQnH1MMCbKIusdQ0AcV0a5WkZq84LojJHtwat+BcVyS8W2BTyEDuN8PbWY2hjM1u0Yp
	12LnLxuc1Q/o02TClhvI5XecoQ5IQEk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="JKb/J0IG";
	spf=pass (imf09.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.161.50 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754721594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=veV+M239TKy4G3gr61ocAU8YtRih4s6PgN9gAB5Yo7E=;
	b=g6AQLWZ9lu3N94yvWWbRU2W847Y/6Jcx94tFBYzjMff3/kP1UkdiavUX3uDcgmCciDaSYE
	rfuIEMYbz/a0ceK+Xe766Wdy0jaRkYgRdtcLGFJ+2phgzR5oqvFdRg8gMZMlVn98CB81BC
	aY3Om7gxzRkJXFgt85sBJ+D1gmkOpec=
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-61b6779bb45so489870eaf.3
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 23:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754721593; x=1755326393; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=veV+M239TKy4G3gr61ocAU8YtRih4s6PgN9gAB5Yo7E=;
        b=JKb/J0IG3K/Ok8k8NVj/jssqcKj6vJvIqJ5m6R3dBDjFhz1xQO/rPQYIotfrnJ0nHL
         qNMaF6cg591nyvgip92/yGAYOkH66G/Fh6A1M9J6MY8DJqrJLBeWup4/V+wTlcNxw/9m
         LlZuFongRsS0/FLxC5msqyA611vXzqcRZ3QJ4rS5wPAQTh9Oh1UPhTVT56Ysw8A2yR9Y
         H9MZ1RxRJ2K3Aiu0nTxNDcJz/ABM4LzFTDFtHC3oYGZngEcGj63+xRf5vMRfmwNbfIYO
         oD4LLlyR+a0b6N0lGBa6OkKaAJ1tZfcdN5NB7RLoNORxSBlUCbT/SJg+GRNSCdo8lWqr
         LcGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754721593; x=1755326393;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=veV+M239TKy4G3gr61ocAU8YtRih4s6PgN9gAB5Yo7E=;
        b=ROExwcrdldWgbIUufQKeXEwPCc2dwLhPm30fsNZY760qLJcdFeSL93CmszXgmuJCLP
         IQ4D5n8nxq4tgtnTSTNV+JyKVa9NuIGBzRV+JzNhiCCkYTo7B68G4iakTU8wAE5A5UCV
         zgC+oC4BMMKLdAUgjjd+fQYt61/xFVRymXFg0LZTR3hv70O+6Q1dySNPTHzyEYzzo+WM
         ZHQEiCNz2zEH2f3PGIgmyKQv9MxjDXapF+uHq9u3RotriRiGZrHGJemygE3G3aHmnpwZ
         JW2jWYX9q54P/YtBGA3QZZ46jXVDTscuTkFwzXnOaZ1YIfnUm12eR4CkG89VoU0mhvYv
         R6UA==
X-Forwarded-Encrypted: i=1; AJvYcCVS3Vh/FMSFrcknOPAREpj+fziE4dFFVwONvINp49OBew3Rs+DaN44eMIH2Q0lNQB8eFer+zJ0Z4A==@kvack.org
X-Gm-Message-State: AOJu0YwuzcCZYwrKQ8I+KvHkG5f4QWIFs2R2HnAVc1Mwru3Y4HI+pJmy
	xuOq9khmcVrg+nVbYDZ8ZkWSsMPW9ijOafjeiRVfpxdBh9ELQ+gnAQ1dvcYCZr5PMBamtW+OcWB
	h9XfWgUw+6LeQDTMwd4phWoLU67dzL3JyzJHYS12pTQ==
X-Gm-Gg: ASbGncv8S3EVxFi6cP3awOXe83O1GzfVQrlvJzqTVU3vFbzQLgCDttOgBw7vSFbfixA
	yavhInvHSo/FAvfd86sseIzeWt/dGKPrRxDpxMSlNl6lB6GW4MwXAOJnQZQkUIg3tifPrTum6T7
	iG03OQ6+jldZi8xQKJ8oLssn2HAoQsHIwAIDzVl2PXQSVmoh0k5GjW5yzEabTxi6upFc7ywfC1b
	bNK
X-Google-Smtp-Source: AGHT+IGJd6d5iQ+IAgCBUGEHC07giPLKhEeoKHtoKrti76CPTOW7eWcPtYT1PnqpDMkVDsJg6TSVe1NAbWrjqgN8sHk=
X-Received: by 2002:a05:6871:5b21:b0:30b:9750:3085 with SMTP id
 586e51a60fabf-30c20f8d5f8mr4072412fac.10.1754721592943; Fri, 08 Aug 2025
 23:39:52 -0700 (PDT)
MIME-Version: 1.0
References: <20250808195518.563053-2-ekffu200098@gmail.com> <20250808220526.49546-1-sj@kernel.org>
In-Reply-To: <20250808220526.49546-1-sj@kernel.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Sat, 9 Aug 2025 15:39:41 +0900
X-Gm-Features: Ac12FXxLSMV9ojkBvMIF5dWN25ReJEbVQLVtmtN-3sVjXP8LH_0UgKFz2cGvtgc
Message-ID: <CABFDxMH0LDLLdJf-t2DEHCD40EJDfcq35cJM-HS5GkLX7KqsHA@mail.gmail.com>
Subject: Re: [PATCH 1/2] selftests/damon: test no-op commit broke DAMON status
To: SeongJae Park <sj@kernel.org>
Cc: honggyu.kim@sk.com, damon@lists.linux.dev, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1F92F140002
X-Stat-Signature: x6osjrhz383acphy81omezdink4qg884
X-HE-Tag: 1754721593-513512
X-HE-Meta: U2FsdGVkX1+9YE4CyiaEPpYkRIr3aBnoynu3VZc9yHo8ybEiyxINRtwDuINFiy/GF3uSrKDsN9WRY3y7CvpMlZqZRN3nx7oVzaOcqPDzHmVLgE7QwZaO67GPk0OPLJn07J6QB0pKvq/dlZ+FKp30/D//X/GmF+24Weow12pD2A7yX+qDafmiPppy1tjKERw4P6+yzZnOOuUtWsELwMyCzeCns1cccRS+cqe9b0GVaUAidqgJqx1R787hru2SRt/R/7esRg/Vj7bhZd34eo/KzRvghkcY9y8tec6du5GvK+BeQfFQzTlnp6IYB4Bm4dRsmBet6D1R/KkB5LL3f/xX1a7fhx6IqhX0tkS3eW6a7NGs4d2Ztad3QwzC54+NxID7qeiTPCmhN41xBnx1VPPsW84RjQj5A9n7XQU7NzEOq6xtGw6e4hgeFWzfSI1Bz79r4XdiePNqOlSFA8E9Fm+28cWAkQRv4T5oNHw/YTqjEcMA3chLrai1WYHUZe0egg6s0t0zLtS5r1+fWJPxMstthsecyy+RkabsbYSEUHSB2FkNJ+qAynBClxS74eLN/TBQXdfmWP79CG+Aev7D9ALFA0o/COS9qmdxbGPXXFV+ZdJMMG929XiXxt5T4TXTypAGvg0P+gt7vhBke+Ef2StgbYPsW7/vNz1fDPprG2eEA3hP6ARtRUf/3+IBCmrOrlUmzTIXWmmDt72GGUX4PSS7xTPB4lecMu2YkcMDSbRcNi1tV3Ut2G6glTLgU+sOZQ+5qFUVXYKxfjW7TYo7ABwX15dJVmGSv5zdmpoZAM81qiLGKPDhwIKjaGiBx5KIJJKFSQCXSEM7Sk6cLqNqjDGFt8Ws39MqxLq9UyxBf1sm50Y/7ony/t9l2KVjPxliWipvYMUhoo6P8WynUVZ+gRfhnvF6eTEKqSYoytfEQmktNoZ5lSz2nRq4t+8yOB2BijfEJYVIYp9tRVMVw8uA+2P
 1kXbZMTu
 VarduNm6OyZ/UlO5XoCLCZttiC5rrL+CmIKVBt/nprQ2NeCOwSuHu5vpHBRvH923xUlIjiQ1FyCaTbN/ZzXX7MhK70kWVS77hfEvJM3tIwbR8x5+Aj7eUfSoffH7vnMY7e6BZDn1tqKXbJMi4QWs+fEQHLoYo4BqS0OChOHQ90qUA086tEXqud7W/fvbv/Ir9bouOnp+2SsTJ4F6gJtSApihX847N+tdLOJCr4hgOD2F2yGILpYGwPpBH14097ZVeg5z2t8un+CRoEHVBvB2ie7qOKie/0owQkfgebP2Rk1w0vshq80XWv656TnErbJX6wSUVwHRrPjpanH/VqSBLd6Z6LDyNpDubI+MNU1XU+XvDVaadNEw0WZQgiLWEy84rjQsrjcAJUaYOFepYaprR4SOrCjcFZpYYYTLk6MULu0w4X/c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae

On Sat, Aug 9, 2025 at 7:05=E2=80=AFAM SeongJae Park <sj@kernel.org> wrote:
>
> Hello Sang-Heon,
>
> On Sat,  9 Aug 2025 04:55:17 +0900 Sang-Heon Jeon <ekffu200098@gmail.com>=
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
> To keep bisecting goes smoothly, let's introduce failing tests _after_ th=
eir
> fixes are landed.

I see. As mentioned in another comment, I'll merge this patch set into
one patch. I think this comment will be resolved then.

> >
> > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> > ---
> >  tools/testing/selftests/damon/Makefile        |  1 +
> >  .../damon/sysfs_no_op_commit_break.py         | 78 +++++++++++++++++++
> >  2 files changed, 79 insertions(+)
> >  create mode 100755 tools/testing/selftests/damon/sysfs_no_op_commit_br=
eak.py
> >
> > diff --git a/tools/testing/selftests/damon/Makefile b/tools/testing/sel=
ftests/damon/Makefile
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
> > diff --git a/tools/testing/selftests/damon/sysfs_no_op_commit_break.py =
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
> > +        subprocess.check_output(['which', 'drgn'], stderr=3Dsubprocess=
.DEVNULL)
> > +    except:
> > +        return None, 'drgn not found'
> > +    file_dir =3D os.path.dirname(os.path.abspath(__file__))
> > +    dump_script =3D os.path.join(file_dir, 'drgn_dump_damon_status.py'=
)
> > +    rc =3D subprocess.call(['drgn', dump_script, pid, 'damon_dump_outp=
ut'],
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
> > +    # We can extend this test to change only the Given and reuse the W=
hen/Then.
>
> Above comment seems unnecessary to me, since that's obvious.

I agree. As you said, it is obvious. I'll remove all pseudo like comment.

> > +
> > +    # Given : setup filter with allow =3D True
>
> Again, I don't think the above comment is necessary.  And this looks like=
 a
> pseudo code more than a formal comment.  If you think it is necessary, pl=
ease
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

I just referred other tests. And i think we can remove unnecessary
targets and sleep process. I'll fix it on v2 patch.

> > +                schemes=3D[_damon_sysfs.Damos(
> > +                    ops_filters=3D[
> > +                        _damon_sysfs.DamosFilter(type_=3D'anon', match=
ing=3DTrue, allow=3DTrue)
>
> Let's keep 80 columns limit[1].

Oh, I thought it only applied to 'C' related codes. I'm wrong. Thank
you for reminding me. i'll fix it.


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
> > +    before_commit_status, err =3D dump_damon_status_dict(kdamonds.kdam=
onds[0].pid)
> > +    if err is not None:
> > +        print(err)
> > +        exit(1)
> > +
> > +    # When : No-op commit, it should not break anything
>
> Again, I don't think the above comment is necessary.  And this looks like=
 a
> pseudo code more than a formal comment.  If you think it is necessary, pl=
ease
> use more formal tone.
> Also let's not add a space before ':', for consistency.
>

ditto (wil be removed)

> > +    kdamonds.kdamonds[0].commit()
> > +
> > +    # Then : Check value with drgn
>
> Again, I don't think the above comment is necessary.  And this looks like=
 a
> pseudo code more than a formal comment.  If you think it is necessary, pl=
ease
> use more formal tone.
>
> Also let's not add a space before ':', for consistency.

ditto.

> > +    after_commit_status, err =3D dump_damon_status_dict(kdamonds.kdamo=
nds[0].pid)
> > +    if err is not None:
> > +        print(err)
> > +        exit(1)
> > +
> > +    before_commit_dump =3D json.dumps(before_commit_status, sort_keys=
=3DTrue, indent=3D2)
> > +    after_commit_dump =3D json.dumps(after_commit_status, sort_keys=3D=
True, indent=3D2)
>
> Let's keep 80 columns limit[1].

ditto.

> > +    if before_commit_dump !=3D after_commit_dump:
>
> Can't we jsut compare before_commit_status and after_commit_status?

Yeah, I think i'm just confused. I'll change it.

> > +        print("[TEST FAILED] : no-op commit break damon status")
>
> Let's not add a space before ':', for consistency.  In this case, I think=
 ':'
> is not necessary at all.  Actually, since this test is for the single tes=
t
> case, and kselftest framework will say this failed, I think the above pri=
nt()
> is not necessary at all?

So, kselftest framework identifies whether the test was successful or
not by exit code. Then, i'll remove this one.

To be honest, I didn't use kselftest framework while making these
patch set because I don't know how kernel developers use it.

If you are okay, could you share how you use it? I just build kernel
with custom patch, and execute output images by vm, and setup env,
then just execute tests(it's so raw.. i know)

Maybe is there a kernel build option that automatically includes tests
to output image? Or just a general or smarter way to execute the whole
test?

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
> [1] https://docs.kernel.org/process/coding-style.html#breaking-long-lines=
-and-strings
>
>
> Thanks,
> SJ

Thanks for reviewing! Have a nice weekend. I'll do this job after my
personal schedule finishes.

Best Regards.
Sang-Heon Jeon

