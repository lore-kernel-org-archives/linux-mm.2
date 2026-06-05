Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAB24CD6E6B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 07:15:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6FAE6B0005; Fri,  5 Jun 2026 03:15:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A20E06B0088; Fri,  5 Jun 2026 03:15:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E8046B008A; Fri,  5 Jun 2026 03:15:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 771DB6B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 03:15:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1CDA4C3275
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 07:15:27 +0000 (UTC)
X-FDA: 84844998294.12.A4170BC
Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	by imf18.hostedemail.com (Postfix) with ESMTP id EB3241C0009
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 07:15:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Z71vMjeF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of saileshnandanavanam@gmail.com designates 209.85.221.180 as permitted sender) smtp.mailfrom=saileshnandanavanam@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780643725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+9ZS9Cw5++yYWFZfLeheDUCrYVRNGeLmL6kxLI94cSA=;
	b=DbcLgUh0crnXP9tFtQRrhv0ej7NpXir0PBJKHZ51UWx/ElcuhX2peeHoRKVzxuGGBEwyvK
	0Y+xIITVwa2NblcqPR/2RTCCP+ZPCz1rncYC5OTKBByUhRubQmpXkrVwzNt/GndmQ+rWTV
	npKl31+PEB7OtQpCEGu4GaEEAw4PQUA=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Z71vMjeF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of saileshnandanavanam@gmail.com designates 209.85.221.180 as permitted sender) smtp.mailfrom=saileshnandanavanam@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780643725;
	b=1kTfYPxJ3wU5M8EeNDYWbZ1Pa5XmM3B/MBW+PKqIbl7xz4L70UDDlWJXUvfqnx0esvvzuU
	Yu8kotdfrKw0+VTIbS7nCaifUKIsxCyUYjIs6V/Ec3j1vL6QDFn6FFlQ8mqdobVdlPv/bK
	e8PJZnK/gsyVwyqi08AZuIV3YfIVvd4=
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-59f0dbdecf1so58059e0c.1
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 00:15:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780643724; cv=none;
        d=google.com; s=arc-20240605;
        b=PiwODQYass4Jn3iyIg9ZxE6rx/bx39//0EanK7UUGhjgQSxnYI/T7O8tWeeJV2Nce1
         tEkXmwAA6ZR6uThsbMD6GZ8E6R0rrS0F1XM+x757NbnJ0LdS8t+fCbeKfHFDASZdCEaj
         0ZgnhHD+/kRgYZeyp7MQU2usrTsyLiha3WAfWWxHk4PLMS5SC8xVbDvTu6lzIlpze8BV
         fTlFtJnP07SPIxx+MQn7WQZ8H0CvfLo6NOrjEpxJxP3md8Pmj/CigVwolXeD+q+LRwko
         2og5MQUyQRsLx6rFoXa5lnj5GbS0iEFArxRbaVoNGOyYv382N4tUGu+yZ6tqEL22eyOD
         RWGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=+9ZS9Cw5++yYWFZfLeheDUCrYVRNGeLmL6kxLI94cSA=;
        fh=zdmBxQ+g9zXe/jQ0+EbaPRIwHLvOxxyx+bExEnoQBCU=;
        b=h8UMeWkUMp0Z6Gac49benOmAntH+ZKkeUzYC1fcVGanJlxaEP0XqPyZZdgmccKeNP+
         xhbaZi/5vTAojIzUmscog/be5pix9u2opSQn/Ejb+yhv692lV6li7y+5cqrGf6iekvf2
         1WVSpcJjxRKVGVz5idCFK2N+Htoy6FZwWsqGcTk7RvfxRfiC0SdfmiWjDGhv8e1ymK+H
         6IU5RJ3Rd+Oe4zs99AjHfrYYrsfiudjrRl+4Gnsnm1wmh3rzU+GE8CVWu5gLNWuYnRFQ
         ejZx5pcQTRWQLQvS5UzyDtHvUjbGHTh5eTLpKIRdkgzVw2X1fMZINfyOFbfTS0ikonSL
         yIJA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780643724; x=1781248524; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+9ZS9Cw5++yYWFZfLeheDUCrYVRNGeLmL6kxLI94cSA=;
        b=Z71vMjeFfb1SWn9M0nvHOuDwTLZSHGpftjHtvOyZQKot9w1nGtaipz39O8sW9E/Q4Z
         3dhMsKm697IbFQoRI4I2f9WY+Dw/iJbvfNqcKPZXB3n7aFredZrZSlG5WeU7O7p/uRaG
         4uSSAPXKPotZX7vbCqH5P59zjMrqE0cSWhS0OFn5FIKZSBnSSdP4eQrQ4vvmF4lQrhF2
         o1Q2NDOd8PRtRQiBL+KCMP7oL3nLt4w87irkfi1tLVZ+S70jWCrb8D2bLebAOXxQzh14
         wqL1tCfkYczBy0gUpIZatDSFi11g16nLAGkQz+WpSJhmzfuG3BXu1/IUMA8fW9aC9XiO
         ceEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780643724; x=1781248524;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+9ZS9Cw5++yYWFZfLeheDUCrYVRNGeLmL6kxLI94cSA=;
        b=EzBUaJqXOrERvht3pM+Vb7KVWwQjgjbRCr4+KRADKuKVmmxtLkvk+QIFpSIhcmoPaW
         /GDI2W3X4S1b4AsclwT20fDwKd1uxdl89eJqhiSacIdqAELHX0rHm+Wo6dYiGVvewRtD
         ImwNRqq8LGbCA0Gug0kHg8o+xefaOVKLlM84deILVr5N0veDTEOWfaGTuTUuvQYA9JjL
         iElQs4KM0yYBSyiSECAg3G96hGNLjx2VmUlmqvwuBQvd8F46rg3/is3LP/uOLKtPalkP
         hk56snAmZZDjtik8uDMMMWCOmu1IXIuvMvBXal+6/JNtnsK5OOEBbfW0cUgko+eHtfQB
         WHhg==
X-Forwarded-Encrypted: i=1; AFNElJ+Rx+/rIb+LePv9YAhgYONGA1oTr6XNde03mWCU2zJJmU3DcS7MMjGgspA7VX5ymzM4MwsAmGbE1A==@kvack.org
X-Gm-Message-State: AOJu0YzfVIKt/KopqakY+tw0UwgTdDXxpb6P3cwG75fw3JrGk6t15F+B
	eUUSnsedC0sJRdWt/Pc9royI/ZvKqgFPcu5o4EN4lHkvsv+xiGW7jtbcPvwNLk8d/DQDYMTeLZK
	/gLaxxM6l8S2eoi7w/iiVSc1YSlJFDPY=
X-Gm-Gg: Acq92OHLuS85PaSCZHEO9avy5oLI03uu4THR/TbkiKVXIfmjXhNWmvR+eJgWGGQeken
	skK7bJT8PcfWMGJwoIkjER5R3ZE8M/Nx8nfB2gfWMn+LIFHfxjJVvMTIIV41ffytNhakA/WFZim
	C84he+X1vkkoZLjNLGgFQaWm2nV5sYL1tgJqwOWTCkoRgvF2vF6STUzJPG/Uwtg52Z9a0A9oFN9
	2/VmwJU8SvoXFd6n9HQ0h44pDV79UjOXTpqJOTkR4U9XgkkAj6xoZJyDK0sAdiX9XH7oeti7KZ5
	FvqQCTl/H14Cu9WLpA==
X-Received: by 2002:a05:6102:2922:b0:605:53ef:d53f with SMTP id
 ada2fe7eead31-6feed961064mr329824137.2.1780643723732; Fri, 05 Jun 2026
 00:15:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260524100258.36819-1-saileshnandanavanam@gmail.com> <20260524183750.1810-1-sj@kernel.org>
In-Reply-To: <20260524183750.1810-1-sj@kernel.org>
From: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
Date: Fri, 5 Jun 2026 12:44:50 +0530
X-Gm-Features: AVVi8CeNBfHtQAXUuww_Xb1Q-B5k6gqMZrQ3V7u0LwKXvG4XqpAbM_iFM0XLsF8
Message-ID: <CAF+TLO0TOKr3nef9RnbBuZ8A-jNpV1po26t1BO6JbSqMhfABvw@mail.gmail.com>
Subject: Re: [PATCH v2] selftests/damon: add regression test for damos_walk()
 vs kdamond exit race
To: SeongJae Park <sj@kernel.org>
Cc: shuah@kernel.org, damon@lists.linux.dev, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: multipart/alternative; boundary="0000000000009feb1306537c6c51"
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EB3241C0009
X-Stat-Signature: mqkazabw66typsu4opxzwpkrtiwsb4ry
X-HE-Tag: 1780643724-28919
X-HE-Meta: U2FsdGVkX19iWi61qQhKvVr6Pq67hR7S694fFYzAIAwyWG8UKJlS+rPMflYF/fN8A0YOKsWlDHZ8h24Uhk4U2iTsfJql9y62gHP5RYitXy0upiUF1PPTk2QuckHHYV4vOpT1IZ+DVPVmVIBkGUsMAwEMH7Z4gGHY63helv7TaQ1d4NHWBslr8UVYJVVgNgvzd+O/tZML+pRlupXwczkqnscFUwjbw1f9nJq+SkbUSht2ehKIJsI98D+WV17zXJver3yvW1wUJMy4dhqAEbPcWmyIEUadwcoCrSjWnDyv1mgDxm8R4JTdm75mG3FahF6QM8iFKVEjjgtqZQoA36YX25WqP1h8u0GeBodXf4z8WotaWwRgFm02kUmk9r58beQTu7nw2ULg55B4mlqCCj5fuYOGeJLrzSnhT5Aziua/+v1rJuUpEGWOCTxg7fljQGnZXRwx3BJpjhgo6IVKTAlvtmkHmUG2jKglOOWUf4VKOSGrU4EJax7bv919mfq5Asl36WJ1gBpmi3s3afpysOiHg9an9zrWi9mCyKOYLZ3u4GTrTNxo+JkRiJqg55buiRLP/IU3mXx/zUAq/bep77qfzjYF1Cz8TsFnyfEI3CLjXy66r1b8bIfbeOBMaikMyJ/LzGmdDSCsEj+63G5yxRLLPQEeX3zJR4ZXtULbpdDu3n9bpCoJMEq+xgFvPnLNTUDdIFtvnH2DUqNoluvYcCcapn72EQBE6D/XpXvdbFNb6SQWt94Xmyru8Ww1xvgoYh/BWbkIHeWw9PM85qinIH6DAbSZYw7WztaCrb1djAXXig9LGCPaKWKqgrvHakOkJg24t4qxAWOHwknAy0Q50xfFcscn+N8XYvSXpfxxquSWCQPz73s5JoOKdtkY9wJzLUrmWNCbLRjJ06/lB8QgpMzRp/t9Q8aGWkE0UuXdbEFTBlO/gijXK+zra/mzh0jUEwQL7GpZx0hasxhHaykysId
 F5u3z5YB
 LSGhCXOqyN5+u6sjlUbXjD3MXvIQj6kdg+5QlIdeyxNsP0ALMvuOZ4NCE5YCMH0pBJbxB5dlCfNshBOuht+ldZu9fCTrO/PpojYEeRJ7oj1p5nf6CTg3qnkMLKLb1QXbfyoh7bTRj++vmmIL6OvEhkHO8wy2m6p9bICk8h82lDtU5RcpiZdgJ1zSyv5RUm1XmVrUJ69/E35AnmqDc3VCJeGZWSi7+8uNHdv5VDpyjyzG9VDt9zsXP0mIy+Gf2EXbFLnJTixXEz9TYPPlLHW0rz8RxBqyOLh1pDyl+drXgK5Urgyadu/dTSYIMkfdPnHpFLr7XOoC4e42uARIL3qi5K2kuS5jjV0RbYyChG2d4HXTiYUuEeYC4I3qec7tce5dyjzyjMhu60b2DcFP2HfuNSW7xcDDyIwoDKeQRNkl197zwqacw0SuYgjInDtN6XHURpTOOKWx4s1bx+/vfYoWS6ZiNYtPftUhqHdmdY/sa+g7bHIshEjV/6IXDz1U2cu1gC8dSR7NhTpO6HT6ZUc7QSm4rmvm2Jxd/GYKJX+uYLvvSaIt5gRmvfszjXzdc2FU/0hsx1sGx7pC68MI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000009feb1306537c6c51
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi SeongJae,

Apologies for the delayed response.

Thank you for the detailed review and for actually testing the patch on a
kernel with the fix reverted.

You are right that the userspace selftest cannot reliably trigger this
race. The race window between kdamond cancelling requests and unsetting the
pointer is microseconds wide. Since userspace calls have system call
overhead, they cannot hit that window reliably =E2=80=94 which is why the t=
est
always passed even on a broken kernel.

Regarding the error condition question:

When kdamond stops naturally, any subsequent write to the state file (which
update_schemes_tried_regions() does internally) fails because kdamond is no
longer running. So receiving an error indicates kdamond exited
without deadlock =E2=80=94 the expected success condition. I should have ex=
plained
this more clearly in the comment.

I agree that a KUnit test is the right approach since it runs inside the
kernel and can directly set walk_control_obsolete to simulate the race
condition reliably without timing dependencies.

I will drop the userspace selftest approach and write a KUnit test for
damos_walk() functionality including walk_control_obsolete. I will verify
it fails on a kernel with commit 33c3f6c2b48c ("mm/damon/core: fix
damos_walk() vs kdamond_fn() exit race") reverted and passes with the fix
present before sending v3.

Regarding other feedback:
- Will use correct commit description format with subject in brackets
- Will remove the Fixes: tag
- Will add blank line before _damon_sysfs import
- Will add changelog and link previous versions
- Will share revision plan and wait at least one day
  before sending new version

Please give me some time to study mm/damon/tests/core-kunit.h and implement
this properly.

Thanks,
Sailesh Nandanavanam

On Mon, May 25, 2026 at 12:08=E2=80=AFAM SeongJae Park <sj@kernel.org> wrot=
e:

> Hello Sailesh,
>
> On Sun, 24 May 2026 15:32:58 +0530 Sailesh Nandanavanam <
> saileshnandanavanam@gmail.com> wrote:
>
> > Add a regression test that verifies damos_walk() does not deadlock
> > when racing with kdamond_fn() exit.
> >
> > When kdamond_fn() finishes its main loop, it cancels remaining
> > damos_walk() requests and unsets damon_ctx->kdamond. Without the fix
> > in commit 33c3f6c2b48c, damos_walk() could be called right after
>
> Please use more common commit description format that has the commit
> subject.
> E.g., commit 33c3f6c2b48c ("mm/damon/core: fix damos_walk() vs kdamond_fn=
()
> exit race").
>
> > cancellation but before kdamond pointer unset, causing it to wait
> > forever for handling that never comes.
> >
> > The test starts kdamond monitoring a short-lived process, waits for
> > the process to exit naturally triggering kdamond termination, then
> > rapidly calls update_schemes_tried_regions in a separate thread to
> > hit the race window. Using a thread with join timeout ensures the
> > test can detect kernel-level deadlocks where the system call blocks
> > in uninterruptible state.
> >
> > The sysfs state path is resolved dynamically via the kdamonds object
> > instead of being hardcoded, and exceptions are handled specifically
> > as OSError rather than using a bare except block.
>
> Thank you for this patch.  But, is this test reliable?  I ran the test mo=
re
> than 100 times on my system running a kernel that has commit 33c3f6c2b48c
> is
> reverted.  But test always passed.
>
> >
> > Fixes: 33c3f6c2b48c ("mm/damon/core: fix damos_walk() vs kdamond_fn()
> exit race")
>
> This is not fixing a bug in the commit, so the above 'Fixes:' tag is
> inappropriate and may only confuse people.
>
> > Signed-off-by: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
> > ---
>
> From next time, please add changelog on the commentary area [1], with
> links to
> the previous revisions.
>
> I was able to find the previous version on the mailing list [2], so
> putting the
> link here for others.
>
> Also, before sending a new version, please share your revisioning plan an=
d
> give
> time (about a daay) for others to comment about.
>
> >  tools/testing/selftests/damon/Makefile        |  1 +
> >  .../sysfs_damos_walk_kdamond_exit_race.py     | 82 +++++++++++++++++++
> >  2 files changed, 83 insertions(+)
> >  create mode 100755
> tools/testing/selftests/damon/sysfs_damos_walk_kdamond_exit_race.py
> >
> > diff --git a/tools/testing/selftests/damon/Makefile
> b/tools/testing/selftests/damon/Makefile
> > index 2180c328a825..60c83d6c318e 100644
> > --- a/tools/testing/selftests/damon/Makefile
> > +++ b/tools/testing/selftests/damon/Makefile
> > @@ -20,6 +20,7 @@ TEST_PROGS +=3D sysfs_update_removed_scheme_dir.sh
> >  TEST_PROGS +=3D sysfs_update_schemes_tried_regions_hang.py
> >  TEST_PROGS +=3D sysfs_memcg_path_leak.sh
> >  TEST_PROGS +=3D sysfs_no_op_commit_break.py
> > +TEST_PROGS +=3D sysfs_damos_walk_kdamond_exit_race.py
> >
> >  EXTRA_CLEAN =3D __pycache__
> >
> > diff --git
> a/tools/testing/selftests/damon/sysfs_damos_walk_kdamond_exit_race.py
> b/tools/testing/selftests/damon/sysfs_damos_walk_kdamond_exit_race.py
> > new file mode 100755
> > index 000000000000..8e8006d63926
> > --- /dev/null
> > +++ b/tools/testing/selftests/damon/sysfs_damos_walk_kdamond_exit_race.=
py
> > @@ -0,0 +1,82 @@
> > +#!/usr/bin/env python3
> > +# SPDX-License-Identifier: GPL-2.0
> > +#
> > +# Regression test for damos_walk() vs kdamond_fn() exit race.
> > +#
> > +# When kdamond_fn() finishes its main loop, it cancels remaining
> damos_walk()
> > +# requests and unsets damon_ctx->kdamond. If damos_walk() is called
> right
> > +# after cancellation but before kdamond pointer unset, it could wait
> forever
> > +# for handling that never comes, causing a deadlock.
> > +#
> > +# This test verifies the fix by rapidly calling
> update_schemes_tried_regions
> > +# while kdamond is naturally terminating (monitored process exits).
> > +# Without the fix (commit 33c3f6c2b48c), this would hang indefinitely.
> > +
> > +import os
> > +import subprocess
> > +import threading
> > +import time
> > +import _damon_sysfs
>
> Let's add a blank line before _damon_sysfs import, to be consistent with
> other
> test files, like sysfs_update_schemes_tried_regions_hang.py.
>
> > +
> > +def call_update(kdamond, result):
> > +    err =3D kdamond.update_schemes_tried_regions()
> > +    result['err'] =3D err
> > +    result['done'] =3D True
> > +
> > +def main():
> > +    proc =3D subprocess.Popen(['sleep', '0.3'])
> > +
> > +    kdamonds =3D _damon_sysfs.Kdamonds([_damon_sysfs.Kdamond(
> > +            contexts=3D[_damon_sysfs.DamonCtx(
> > +                ops=3D'vaddr',
> > +                targets=3D[_damon_sysfs.DamonTarget(pid=3Dproc.pid)],
> > +                schemes=3D[_damon_sysfs.Damos(
> > +                    action=3D'stat',
> > +                    access_pattern=3D_damon_sysfs.DamosAccessPattern(
> > +                        nr_accesses=3D[0, 200]))]
> > +                )]
> > +            )])
> > +
> > +    err =3D kdamonds.start()
> > +    if err is not None:
> > +        print('kdamond start failed: %s' % err)
> > +        exit(1)
> > +
> > +    # Wait for monitored process to die naturally
> > +    proc.wait()
> > +
> > +    # Rapidly call damos_walk() while kdamond is exiting
> > +    # Use a thread with real timeout to detect kernel-level deadlock
> > +    deadline =3D time.time() + 5
> > +    while time.time() < deadline:
> > +        result =3D {'done': False, 'err': None}
> > +        t =3D threading.Thread(target=3Dcall_update,
> > +                             args=3D(kdamonds.kdamonds[0], result))
> > +        t.daemon =3D True
> > +        t.start()
> > +        t.join(timeout=3D5)
>
> I'm not sure if this is reliable to trigger the exact race.  As I mention=
ed
> abovely, I tried this test more than 100 times on a kernel that having th=
e
> fix
> reverted, but I was unable to make the test fail.  If it is that
> unreliable,
> I'm not very sure if having this test is beneficial or just make people
> confused.
>
> If the test has no false positive, maybe having this make sense to
> opportunistically finding the bug.  But I think the 5 seconds timeout is
> still
> not very reliable on some case, and therefore it seems false positive tes=
t
> failure is available.  If that is correct, I think having this test might
> only
> confuse people.
>
> I think having damos_walk() kunit test for its functionalities including
> the
> walk_control_obsolete might make more sense.
>
> > +
> > +        if not result['done']:
> > +            print('FAIL: update_schemes_tried_regions hung - '
> > +                  'possible damos_walk/kdamond exit race deadlock')
> > +            exit(1)
> > +
> > +        if result['err'] is not None:
> > +            # kdamond stopped cleanly - expected
> > +            break
>
> Is the above if condition correct?  Could you please explain why having a=
n
> error here is expected?
>
> > +
> > +        # Check kdamond state via sysfs using dynamic path
> > +        state_path =3D os.path.join(
> > +                kdamonds.kdamonds[0].sysfs_dir(), 'state')
> > +        try:
> > +            with open(state_path) as f:
> > +                if f.read().strip() =3D=3D 'off':
> > +                    break
> > +        except OSError as e:
> > +            print('failed to read kdamond state: %s' % e)
> > +            exit(1)
> > +
> > +    print('PASS: damos_walk() vs kdamond exit race not triggered')
> > +
> > +if __name__ =3D=3D '__main__':
> > +    main()
> > --
> > 2.34.1
>
> [1] https://docs.kernel.org/process/submitting-patches.html#commentary
> [2]
> https://lore.kernel.org/20260524091812.35283-1-saileshnandanavanam@gmail.=
com
>
>
> Thanks,
> SJ
>

--0000000000009feb1306537c6c51
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi SeongJae,<br><br>Apologies for the delayed response.<br=
><br>Thank you for the detailed review and for actually testing the patch o=
n a kernel with the fix reverted.<br><br>You are right that the userspace s=
elftest cannot reliably trigger this race. The race window between kdamond =
cancelling requests and unsetting the pointer is=C2=A0microseconds wide. Si=
nce userspace calls have system call overhead, they cannot hit that window =
reliably =E2=80=94 which is why the test always passed even on a broken ker=
nel.<br><br>Regarding the error condition question:<br><br>When kdamond sto=
ps naturally, any subsequent write to the state file (which update_schemes_=
tried_regions() does internally) fails because kdamond is no longer running=
.=C2=A0So receiving an error indicates kdamond exited without=C2=A0deadlock=
 =E2=80=94 the expected success condition. I should have=C2=A0explained thi=
s more clearly in the comment.<br><br>I agree that a KUnit test is the righ=
t approach since it runs inside the kernel and can directly set walk_contro=
l_obsolete to simulate the race condition=C2=A0reliably without timing depe=
ndencies.<br><br>I will drop the userspace selftest approach and write a=C2=
=A0KUnit test for damos_walk() functionality including walk_control_obsolet=
e. I will verify it fails on a kernel=C2=A0with commit 33c3f6c2b48c (&quot;=
mm/damon/core: fix damos_walk()=C2=A0vs kdamond_fn() exit race&quot;) rever=
ted and passes with the fix present before sending v3.<br><br>Regarding oth=
er feedback:<br>- Will use correct commit description format with subject=
=C2=A0in brackets<br>- Will remove the Fixes: tag<br>- Will add blank line =
before _damon_sysfs import<br>- Will add changelog and link previous versio=
ns<br>- Will share revision plan and wait at least one day<br>=C2=A0 before=
 sending new version<br><br>Please give me some time to study mm/damon/test=
s/core-kunit.h and implement this properly.<br><br>Thanks,<br>Sailesh Nanda=
navanam</div><br><div class=3D"gmail_quote gmail_quote_container"><div dir=
=3D"ltr" class=3D"gmail_attr">On Mon, May 25, 2026 at 12:08=E2=80=AFAM Seon=
gJae Park &lt;<a href=3D"mailto:sj@kernel.org">sj@kernel.org</a>&gt; wrote:=
<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8=
ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">Hello Sailesh,<=
br>
<br>
On Sun, 24 May 2026 15:32:58 +0530 Sailesh Nandanavanam &lt;<a href=3D"mail=
to:saileshnandanavanam@gmail.com" target=3D"_blank">saileshnandanavanam@gma=
il.com</a>&gt; wrote:<br>
<br>
&gt; Add a regression test that verifies damos_walk() does not deadlock<br>
&gt; when racing with kdamond_fn() exit.<br>
&gt; <br>
&gt; When kdamond_fn() finishes its main loop, it cancels remaining<br>
&gt; damos_walk() requests and unsets damon_ctx-&gt;kdamond. Without the fi=
x<br>
&gt; in commit 33c3f6c2b48c, damos_walk() could be called right after<br>
<br>
Please use more common commit description format that has the commit subjec=
t.<br>
E.g., commit 33c3f6c2b48c (&quot;mm/damon/core: fix damos_walk() vs kdamond=
_fn()<br>
exit race&quot;).<br>
<br>
&gt; cancellation but before kdamond pointer unset, causing it to wait<br>
&gt; forever for handling that never comes.<br>
&gt; <br>
&gt; The test starts kdamond monitoring a short-lived process, waits for<br=
>
&gt; the process to exit naturally triggering kdamond termination, then<br>
&gt; rapidly calls update_schemes_tried_regions in a separate thread to<br>
&gt; hit the race window. Using a thread with join timeout ensures the<br>
&gt; test can detect kernel-level deadlocks where the system call blocks<br=
>
&gt; in uninterruptible state.<br>
&gt; <br>
&gt; The sysfs state path is resolved dynamically via the kdamonds object<b=
r>
&gt; instead of being hardcoded, and exceptions are handled specifically<br=
>
&gt; as OSError rather than using a bare except block.<br>
<br>
Thank you for this patch.=C2=A0 But, is this test reliable?=C2=A0 I ran the=
 test more<br>
than 100 times on my system running a kernel that has commit 33c3f6c2b48c i=
s<br>
reverted.=C2=A0 But test always passed.<br>
<br>
&gt; <br>
&gt; Fixes: 33c3f6c2b48c (&quot;mm/damon/core: fix damos_walk() vs kdamond_=
fn() exit race&quot;)<br>
<br>
This is not fixing a bug in the commit, so the above &#39;Fixes:&#39; tag i=
s<br>
inappropriate and may only confuse people.<br>
<br>
&gt; Signed-off-by: Sailesh Nandanavanam &lt;<a href=3D"mailto:saileshnanda=
navanam@gmail.com" target=3D"_blank">saileshnandanavanam@gmail.com</a>&gt;<=
br>
&gt; ---<br>
<br>
From next time, please add changelog on the commentary area [1], with links=
 to<br>
the previous revisions.<br>
<br>
I was able to find the previous version on the mailing list [2], so putting=
 the<br>
link here for others.<br>
<br>
Also, before sending a new version, please share your revisioning plan and =
give<br>
time (about a daay) for others to comment about.<br>
<br>
&gt;=C2=A0 tools/testing/selftests/damon/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 |=C2=A0 1 +<br>
&gt;=C2=A0 .../sysfs_damos_walk_kdamond_exit_race.py=C2=A0 =C2=A0 =C2=A0| 8=
2 +++++++++++++++++++<br>
&gt;=C2=A0 2 files changed, 83 insertions(+)<br>
&gt;=C2=A0 create mode 100755 tools/testing/selftests/damon/sysfs_damos_wal=
k_kdamond_exit_race.py<br>
&gt; <br>
&gt; diff --git a/tools/testing/selftests/damon/Makefile b/tools/testing/se=
lftests/damon/Makefile<br>
&gt; index 2180c328a825..60c83d6c318e 100644<br>
&gt; --- a/tools/testing/selftests/damon/Makefile<br>
&gt; +++ b/tools/testing/selftests/damon/Makefile<br>
&gt; @@ -20,6 +20,7 @@ TEST_PROGS +=3D sysfs_update_removed_scheme_dir.sh<b=
r>
&gt;=C2=A0 TEST_PROGS +=3D sysfs_update_schemes_tried_regions_hang.py<br>
&gt;=C2=A0 TEST_PROGS +=3D sysfs_memcg_path_leak.sh<br>
&gt;=C2=A0 TEST_PROGS +=3D sysfs_no_op_commit_break.py<br>
&gt; +TEST_PROGS +=3D sysfs_damos_walk_kdamond_exit_race.py<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 EXTRA_CLEAN =3D __pycache__<br>
&gt;=C2=A0 <br>
&gt; diff --git a/tools/testing/selftests/damon/sysfs_damos_walk_kdamond_ex=
it_race.py b/tools/testing/selftests/damon/sysfs_damos_walk_kdamond_exit_ra=
ce.py<br>
&gt; new file mode 100755<br>
&gt; index 000000000000..8e8006d63926<br>
&gt; --- /dev/null<br>
&gt; +++ b/tools/testing/selftests/damon/sysfs_damos_walk_kdamond_exit_race=
.py<br>
&gt; @@ -0,0 +1,82 @@<br>
&gt; +#!/usr/bin/env python3<br>
&gt; +# SPDX-License-Identifier: GPL-2.0<br>
&gt; +#<br>
&gt; +# Regression test for damos_walk() vs kdamond_fn() exit race.<br>
&gt; +#<br>
&gt; +# When kdamond_fn() finishes its main loop, it cancels remaining damo=
s_walk()<br>
&gt; +# requests and unsets damon_ctx-&gt;kdamond. If damos_walk() is calle=
d right<br>
&gt; +# after cancellation but before kdamond pointer unset, it could wait =
forever<br>
&gt; +# for handling that never comes, causing a deadlock.<br>
&gt; +#<br>
&gt; +# This test verifies the fix by rapidly calling update_schemes_tried_=
regions<br>
&gt; +# while kdamond is naturally terminating (monitored process exits).<b=
r>
&gt; +# Without the fix (commit 33c3f6c2b48c), this would hang indefinitely=
.<br>
&gt; +<br>
&gt; +import os<br>
&gt; +import subprocess<br>
&gt; +import threading<br>
&gt; +import time<br>
&gt; +import _damon_sysfs<br>
<br>
Let&#39;s add a blank line before _damon_sysfs import, to be consistent wit=
h other<br>
test files, like sysfs_update_schemes_tried_regions_hang.py.<br>
<br>
&gt; +<br>
&gt; +def call_update(kdamond, result):<br>
&gt; +=C2=A0 =C2=A0 err =3D kdamond.update_schemes_tried_regions()<br>
&gt; +=C2=A0 =C2=A0 result[&#39;err&#39;] =3D err<br>
&gt; +=C2=A0 =C2=A0 result[&#39;done&#39;] =3D True<br>
&gt; +<br>
&gt; +def main():<br>
&gt; +=C2=A0 =C2=A0 proc =3D subprocess.Popen([&#39;sleep&#39;, &#39;0.3&#3=
9;])<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 kdamonds =3D _damon_sysfs.Kdamonds([_damon_sysfs.Kdamon=
d(<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 contexts=3D[_damon_sysfs.Da=
monCtx(<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ops=3D&#39;va=
ddr&#39;,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 targets=3D[_d=
amon_sysfs.DamonTarget(pid=3Dproc.pid)],<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 schemes=3D[_d=
amon_sysfs.Damos(<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 action=3D&#39;stat&#39;,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 access_pattern=3D_damon_sysfs.DamosAccessPattern(<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 nr_accesses=3D[0, 200]))]<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 )]<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 )])<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 err =3D kdamonds.start()<br>
&gt; +=C2=A0 =C2=A0 if err is not None:<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 print(&#39;kdamond start failed: %s&#39; =
% err)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 exit(1)<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 # Wait for monitored process to die naturally<br>
&gt; +=C2=A0 =C2=A0 proc.wait()<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 # Rapidly call damos_walk() while kdamond is exiting<br=
>
&gt; +=C2=A0 =C2=A0 # Use a thread with real timeout to detect kernel-level=
 deadlock<br>
&gt; +=C2=A0 =C2=A0 deadline =3D time.time() + 5<br>
&gt; +=C2=A0 =C2=A0 while time.time() &lt; deadline:<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 result =3D {&#39;done&#39;: False, &#39;e=
rr&#39;: None}<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 t =3D threading.Thread(target=3Dcall_upda=
te,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0args=3D(kdamonds.kdamonds[0], result))<b=
r>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 t.daemon =3D True<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 t.start()<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 t.join(timeout=3D5)<br>
<br>
I&#39;m not sure if this is reliable to trigger the exact race.=C2=A0 As I =
mentioned<br>
abovely, I tried this test more than 100 times on a kernel that having the =
fix<br>
reverted, but I was unable to make the test fail.=C2=A0 If it is that unrel=
iable,<br>
I&#39;m not very sure if having this test is beneficial or just make people=
<br>
confused.<br>
<br>
If the test has no false positive, maybe having this make sense to<br>
opportunistically finding the bug.=C2=A0 But I think the 5 seconds timeout =
is still<br>
not very reliable on some case, and therefore it seems false positive test<=
br>
failure is available.=C2=A0 If that is correct, I think having this test mi=
ght only<br>
confuse people.<br>
<br>
I think having damos_walk() kunit test for its functionalities including th=
e<br>
walk_control_obsolete might make more sense.<br>
<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 if not result[&#39;done&#39;]:<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 print(&#39;FAIL: update_sch=
emes_tried_regions hung - &#39;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &#39;p=
ossible damos_walk/kdamond exit race deadlock&#39;)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 exit(1)<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 if result[&#39;err&#39;] is not None:<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 # kdamond stopped cleanly -=
 expected<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break<br>
<br>
Is the above if condition correct?=C2=A0 Could you please explain why havin=
g an<br>
error here is expected?<br>
<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 # Check kdamond state via sysfs using dyn=
amic path<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 state_path =3D os.path.join(<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kdamonds.kdam=
onds[0].sysfs_dir(), &#39;state&#39;)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 try:<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 with open(state_path) as f:=
<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if f.read().s=
trip() =3D=3D &#39;off&#39;:<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 break<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 except OSError as e:<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 print(&#39;failed to read k=
damond state: %s&#39; % e)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 exit(1)<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 print(&#39;PASS: damos_walk() vs kdamond exit race not =
triggered&#39;)<br>
&gt; +<br>
&gt; +if __name__ =3D=3D &#39;__main__&#39;:<br>
&gt; +=C2=A0 =C2=A0 main()<br>
&gt; -- <br>
&gt; 2.34.1<br>
<br>
[1] <a href=3D"https://docs.kernel.org/process/submitting-patches.html#comm=
entary" rel=3D"noreferrer" target=3D"_blank">https://docs.kernel.org/proces=
s/submitting-patches.html#commentary</a><br>
[2] <a href=3D"https://lore.kernel.org/20260524091812.35283-1-saileshnandan=
avanam@gmail.com" rel=3D"noreferrer" target=3D"_blank">https://lore.kernel.=
org/20260524091812.35283-1-saileshnandanavanam@gmail.com</a><br>
<br>
<br>
Thanks,<br>
SJ<br>
</blockquote></div>

--0000000000009feb1306537c6c51--

