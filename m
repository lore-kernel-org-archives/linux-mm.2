Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99A72CD6E74
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 09:56:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B805B6B008A; Fri,  5 Jun 2026 05:56:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B316A6B008C; Fri,  5 Jun 2026 05:56:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A20756B0092; Fri,  5 Jun 2026 05:56:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D0836B008A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 05:56:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 16F7A40826
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:56:25 +0000 (UTC)
X-FDA: 84845403930.28.18CDFFD
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0828920004
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:56:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Xpg7mvLj;
	spf=pass (imf13.hostedemail.com: domain of saileshnandanavanam@gmail.com designates 209.85.217.42 as permitted sender) smtp.mailfrom=saileshnandanavanam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780653383;
	b=aikvaFawxMhdsJDEcsD8YAgNKlkFuSBw43FeAPDZ8KI4ydpWgJJO8RP1BjjSJm3POqQ6G0
	ZCRLE3ZBfALamqXu034V3VpMbd5IK4yQLFSh8nx5+YPCSnsVwLtIZqztBjiUX+w4sjlPSp
	Ws5tXy2GCYfGBb68NbMnsHFYEAnwm5w=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Xpg7mvLj;
	spf=pass (imf13.hostedemail.com: domain of saileshnandanavanam@gmail.com designates 209.85.217.42 as permitted sender) smtp.mailfrom=saileshnandanavanam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780653383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=188nvOnCtn3gvAkEJ5AAqju2IjEOtnXumuNth0RPW38=;
	b=w6J0uppvIZfQoE9NoIzuCzJCClHGH0qppof9+wRrMz5ey3sUAm75H1XVGWa40rIlV0THyr
	y/CH17PvwVjR/Z2UqEPBuFl6qz+1Ezk4vEC96VfaoRXcmhAqTbi5+zco6CyTCZakUOxthc
	SSxst+d9WgTWvdtZyBmj8k9JpohnRfQ=
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-6c7e72a6bdcso62897137.1
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 02:56:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780653382; cv=none;
        d=google.com; s=arc-20240605;
        b=JVopkw/tbveL9wJRCwSpGfYJskeJ3mvBEnE3x9mWM7j7B71+a73kvFcg6v0zge747O
         9K99ElCOtPQCoGZvo6pOhQ53yNTx2PF+VPMh7iM7t5vQF+2r6isC4pdLQjHltMj3B7b+
         Fxhkh2drZFZyITurXxqNNU/9jL3YSh/Hr2S1VVtYolc/q82aOXLxu1P2dGGVrJrgAtv3
         Q4CZ0uFrr/2A5t8N0H1MazSx+wunM2oKzcIoAMH/u6fMOZlQKE6l5ELPcvOxqzLvgrAH
         xgaIcANOelWElL3BUhdnjRp5w3ns4hVdhpyWpXXsm/oK5dvIcq+U99a0kCPsTAeQkxXv
         2m7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=188nvOnCtn3gvAkEJ5AAqju2IjEOtnXumuNth0RPW38=;
        fh=dEB/eWDJBrSeupl774TEq7NNYC8MhDcmIrOwQ69oo1w=;
        b=AAOtC/b26oDwgVEXXEp/kaMCYgnYGsy085CJJRNftRW00eYkORsUV/m3BVmyVTjEGl
         8U3Ze5tDXbYiTOjT1C7o7lxUlqiK5VxRjaa5Gnd8wlBPvtjQhmxyO8WTseGxjz4KfFcI
         Sdnm2qxQXl/D8rDzKkd/4acUPqCxeQf30dCs6jdGeY/KrtAOcfG++GfpH+fSVkAxoHXp
         JKtNbT1dAkdj1vui9siKkdRbH38xMARu+L+KrdxZspy2bJfE5DgIRrGEHX5Fp2SoAvHy
         tbOpcfAVQwU1b4z8PtnEdyzcYpk9cabHpTC9qDcdULFRREL0ipimFNU+DIKoUK5+IGN7
         aPVQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780653382; x=1781258182; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=188nvOnCtn3gvAkEJ5AAqju2IjEOtnXumuNth0RPW38=;
        b=Xpg7mvLjF0LgyQTfnfsMnvGlLxTGPOMCzkTl91389vTZ/XtWL95SCZ6VdtzDzYZizx
         2IuSNKo+MzfYeiXranWRMdFO7wXVj3JNMFlxZ7UrhxASCrzEAsMKnctg7WEZHucVUF5L
         6dfq7NeZnqGYmYxPG9f1CmcX3gX96wFZFxfeSgK/St/3SeCkvnY7c1ErdW5K/VZdZ4iT
         TtekSPlrhn781bH8RjsocFRzlAz9Kbop/9dnFX4ycmvTubKYtHhyQcTIenSHaoO8Nfdt
         vE6nOaoICV/5RiaU2gk6/szU79HuoLiL1hrrAWcoA2ZJD3Z/LKvkMyA889D1Kb/VT5ea
         UbQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780653382; x=1781258182;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=188nvOnCtn3gvAkEJ5AAqju2IjEOtnXumuNth0RPW38=;
        b=RFQe8bGDz1JMZKKMgN3xRUR8ZkciYMRmsgtYzkZFLCT37CJA9FaJxNrCN0MC/ethV/
         tEyyqQGnxL16YbALuSOzO7YS/TjpW2DHbv109z3xktvSunwFqdFo9Y7AKWQ1u85xd543
         ukIAlk0lsi0rhRp5j5W5nrGGn6MPu6iAQ0SR411gI+8MRexhDkGaNV1M86Qi/LaQ+lUb
         vrlgcAbSXAV4n/P/VJ/PzYOmeCR0nHMGQqZmVYPAj4PVKzH/3rc7EKvf229CfwBF4WfE
         SRbqdRw3haL9vEcB05iWFcROdNUWYbZ9D11X2qGm0mSz+F1CuvXSVleeI9T0N9hRIQt6
         yY2g==
X-Forwarded-Encrypted: i=1; AFNElJ84+5KsO33ARpir6A1ErC/YPD1ZJH4rJN2+xc/U4xBQUQxBiDWrhiC3PNVIW2Krajgu4lXRiyBlnQ==@kvack.org
X-Gm-Message-State: AOJu0YwF4bYIqk9XNZ4GecKc3Db1yvKgIZszFtX+XtlkMCjNtG6zfo3g
	0YpcwEjDra6UNgN4iUaP8TwNdNDNI2TE9OkSJsILDpVOTJsgBgAdZOJG8I+lKR1uo+TXFhqU52S
	0gJ346LXIa/N+T8VPmXIhdNe269tx0jA=
X-Gm-Gg: Acq92OEXXxrGogr/DWGPpA64RxcIkwhPK+qqMJONy1UNiENEPhrqi4e+eQeHczt85T6
	BjpPgaYXZ5VRVa2J8q+SIUGq0OiIiD2wXWdc6xhBKc3+1+7R8pBtx6yEOwjugDuwVyVPC7OUuVs
	4GteJuNrLVvrQSyMt0V/nhY2/CR4uhGPdRAq8R5lH4xVX4ZqUAnTyzxB402oy48XsmIekVXzqP7
	EjdBjN05UZddzTEmxftsg1F7Zi6udbYoSO5zmTKIMNCOCQf4N5daOW/laMpz/+HlmC+yKjqORH6
	Q83A3QcRrHlp13whnP2qsVD4N61D
X-Received: by 2002:a05:6102:c50:b0:60f:77ad:4bed with SMTP id
 ada2fe7eead31-6fefdee6cd8mr293230137.7.1780653381899; Fri, 05 Jun 2026
 02:56:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260524100258.36819-1-saileshnandanavanam@gmail.com>
 <20260524183750.1810-1-sj@kernel.org> <CAF+TLO0TOKr3nef9RnbBuZ8A-jNpV1po26t1BO6JbSqMhfABvw@mail.gmail.com>
In-Reply-To: <CAF+TLO0TOKr3nef9RnbBuZ8A-jNpV1po26t1BO6JbSqMhfABvw@mail.gmail.com>
From: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
Date: Fri, 5 Jun 2026 15:25:48 +0530
X-Gm-Features: AVVi8Cd8y5fFKwqGfXRah25YurCGU1j0bkf9HlQz8Xf8QOU5lKc-yuHMMmkRebY
Message-ID: <CAF+TLO0=zpnAo-Ma2zi-Op=P0w0TPVCLbBkWKq113RDsHaCXuw@mail.gmail.com>
Subject: Re: [PATCH v2] selftests/damon: add regression test for damos_walk()
 vs kdamond exit race
To: SeongJae Park <sj@kernel.org>
Cc: shuah@kernel.org, damon@lists.linux.dev, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0828920004
X-Rspam-User: 
X-Stat-Signature: ha58z5gwae58qsoqzas68arxemnbpjgc
X-HE-Tag: 1780653382-102299
X-HE-Meta: U2FsdGVkX1+2UVXPQaMSyGDXjGQ+0KPZaLRnBd2KdxYV96UKKhFlWyI0t2zSPV7qGRWQEYOktAE/EI5QzJhz3DFARVKb1SG7VU0NvEj91CyCi2l763b2VCZgz1HEVQAHs+awc8WH7h4wIaSTcVn3n33mFwGLHw9KMXQr/Hi/dRo2/D79Iu8g23SlOYUG6sqBjl9KOMRoerw9NUTes3UvtsCCgJ/+ADxaS8iBTEGtyK6Y6NNCt58vvceRAjrRBkZo1TJZFUZP3jubJ+8mN2+eGPNx2LKzX9GM6veQg0nmG5jIN5cT8JmfAQI+NdYr/fOVLsdpfZRgdoDH9O4JEr7Olqk+zmYWY6CTISgdOVO6Rd91FI5NEYgKpjiyjPz0HlbQYZqlrtJpw7wPLHRqkTqRiRSr7zm9NNyUWV6WQDdVqdEEpREcpF5NX3PQ+mfAYbrH2BSp9/8U8xUnkfPbYUFtTLEnFg/IXH++10IjdASHfSWZqu52vNFeqCzbFmp4O9p6ki/IYlllGkf63Vb3l2NWSx+WyBO1hMuhH3pX75uVNJ5u4FjKoC2iRQx3REzffvPQv+gYLJC3RlEZIfLmLeUxBkteQFZifyrmEKJCoxYqjqgTWHRF9ZZL85AeCmvytY4v7faIIz9aevass3P3HbbSAxFlBYPqQ2MfOPRGj28mKTQy/lh4i6qamBrCQB7T4IFsCMKmT4AMLZz6JgiV+dB8PYmTscrJTChnQ7phmfVF82c254OvuuWX2hEF5L9R9z/VT8iTEAeFLmGhH2CHmzpa3uKI19c6Ef3SlZ3wRQeMV5uYSX9HHK7l13aaAqHoUEhYST0YOpic5z4lgI8CneDktI1TrKO76V6EU3m0GGGFbmq4I37EaMd+0OhcVwWof0nsKeuYN5DPOJ+9pFQLW9AY9wFpTHOhuEO870TRjRzN+Dlat5O7VnWjGKeCgDCN8wDmKp4JIea8pTnhmrUcwJV
 Q5AbGRsV
 InbPvU4C/dgt3oYbDKoL0QkIecjqF0iKOEOU52tvz09fMKz0UJcH2sf3hI5WhUsroXvHdVT3kt5CXBKUC5iw1kCnsyVR4cmIbnb1cQXLC+0PVMiPt153m/dn7SqRzRIn0YjyzOSDhivWBIyAAlkhqpqNCzfzX825I/73X+wp1OAUPQYSxVSvEZPBAlojDmC53TsqNLmUKuqa10BehccFAqCLvjLzeEeu0Uh64VZC1FNK2Xxd2nIQyEcWYrX+xz7EW6lW2Y4foW6KRouwiMaUF9DGa1E9OIygjk6dpbO9fi4hsrcyRqh6M7yIXj8eUZu626NWstF7DnYQreQxMGMKRamIZ77cD7btNQbDcl13LAnZT7as7uoLv2ZmJVRnVgrLCcIcn1VXPFRxZyS+W53w/LPFlTr+DCzfMAnam6RFk2x4fAgEOO9RMw/F6kLYHxHJFJaVLcuxPnpok0OWW3x3ffL7abC7H289rzbZiU8lNPVLn05I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

Apologies for the delayed response.

Thank you for the detailed review and for actually testing the patch
on a kernel with the fix reverted.

You are right that the userspace selftest cannot reliably trigger this
race. The race window between kdamond cancelling requests and
unsetting the pointer is microseconds wide. Since userspace calls have
system call overhead, they cannot hit that window reliably =E2=80=94 which =
is
why the test always passed even on a broken kernel.

Regarding the error condition question:

When kdamond stops naturally, any subsequent write to the state file
(which update_schemes_tried_regions() does internally) fails because
kdamond is no longer running. So receiving an error indicates kdamond
exited without deadlock =E2=80=94 the expected success condition. I should
have explained this more clearly in the comment.

I agree that a KUnit test is the right approach since it runs inside
the kernel and can directly set walk_control_obsolete to simulate the
race condition reliably without timing dependencies.

I will drop the userspace selftest approach and write a KUnit test for
damos_walk() functionality including walk_control_obsolete. I will
verify it fails on a kernel with commit 33c3f6c2b48c ("mm/damon/core:
fix damos_walk() vs kdamond_fn() exit race") reverted and passes with
the fix present before sending v3.

Regarding other feedback:
- Will use correct commit description format with subject in brackets
- Will remove the Fixes: tag
- Will add blank line before _damon_sysfs import
- Will add changelog and link previous versions
- Will share revision plan and wait at least one day
  before sending new version

Please give me some time to study mm/damon/tests/core-kunit.h and
implement this properly.

Thanks,
Sailesh Nandanavanam


On Fri, Jun 5, 2026 at 12:44=E2=80=AFPM Sailesh Nandanavanam
<saileshnandanavanam@gmail.com> wrote:
>
> Hi SeongJae,
>
> Apologies for the delayed response.
>
> Thank you for the detailed review and for actually testing the patch on a=
 kernel with the fix reverted.
>
> You are right that the userspace selftest cannot reliably trigger this ra=
ce. The race window between kdamond cancelling requests and unsetting the p=
ointer is microseconds wide. Since userspace calls have system call overhea=
d, they cannot hit that window reliably =E2=80=94 which is why the test alw=
ays passed even on a broken kernel.
>
> Regarding the error condition question:
>
> When kdamond stops naturally, any subsequent write to the state file (whi=
ch update_schemes_tried_regions() does internally) fails because kdamond is=
 no longer running. So receiving an error indicates kdamond exited without =
deadlock =E2=80=94 the expected success condition. I should have explained =
this more clearly in the comment.
>
> I agree that a KUnit test is the right approach since it runs inside the =
kernel and can directly set walk_control_obsolete to simulate the race cond=
ition reliably without timing dependencies.
>
> I will drop the userspace selftest approach and write a KUnit test for da=
mos_walk() functionality including walk_control_obsolete. I will verify it =
fails on a kernel with commit 33c3f6c2b48c ("mm/damon/core: fix damos_walk(=
) vs kdamond_fn() exit race") reverted and passes with the fix present befo=
re sending v3.
>
> Regarding other feedback:
> - Will use correct commit description format with subject in brackets
> - Will remove the Fixes: tag
> - Will add blank line before _damon_sysfs import
> - Will add changelog and link previous versions
> - Will share revision plan and wait at least one day
>   before sending new version
>
> Please give me some time to study mm/damon/tests/core-kunit.h and impleme=
nt this properly.
>
> Thanks,
> Sailesh Nandanavanam
>
> On Mon, May 25, 2026 at 12:08=E2=80=AFAM SeongJae Park <sj@kernel.org> wr=
ote:
>>
>> Hello Sailesh,
>>
>> On Sun, 24 May 2026 15:32:58 +0530 Sailesh Nandanavanam <saileshnandanav=
anam@gmail.com> wrote:
>>
>> > Add a regression test that verifies damos_walk() does not deadlock
>> > when racing with kdamond_fn() exit.
>> >
>> > When kdamond_fn() finishes its main loop, it cancels remaining
>> > damos_walk() requests and unsets damon_ctx->kdamond. Without the fix
>> > in commit 33c3f6c2b48c, damos_walk() could be called right after
>>
>> Please use more common commit description format that has the commit sub=
ject.
>> E.g., commit 33c3f6c2b48c ("mm/damon/core: fix damos_walk() vs kdamond_f=
n()
>> exit race").
>>
>> > cancellation but before kdamond pointer unset, causing it to wait
>> > forever for handling that never comes.
>> >
>> > The test starts kdamond monitoring a short-lived process, waits for
>> > the process to exit naturally triggering kdamond termination, then
>> > rapidly calls update_schemes_tried_regions in a separate thread to
>> > hit the race window. Using a thread with join timeout ensures the
>> > test can detect kernel-level deadlocks where the system call blocks
>> > in uninterruptible state.
>> >
>> > The sysfs state path is resolved dynamically via the kdamonds object
>> > instead of being hardcoded, and exceptions are handled specifically
>> > as OSError rather than using a bare except block.
>>
>> Thank you for this patch.  But, is this test reliable?  I ran the test m=
ore
>> than 100 times on my system running a kernel that has commit 33c3f6c2b48=
c is
>> reverted.  But test always passed.
>>
>> >
>> > Fixes: 33c3f6c2b48c ("mm/damon/core: fix damos_walk() vs kdamond_fn() =
exit race")
>>
>> This is not fixing a bug in the commit, so the above 'Fixes:' tag is
>> inappropriate and may only confuse people.
>>
>> > Signed-off-by: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
>> > ---
>>
>> From next time, please add changelog on the commentary area [1], with li=
nks to
>> the previous revisions.
>>
>> I was able to find the previous version on the mailing list [2], so putt=
ing the
>> link here for others.
>>
>> Also, before sending a new version, please share your revisioning plan a=
nd give
>> time (about a daay) for others to comment about.
>>
>> >  tools/testing/selftests/damon/Makefile        |  1 +
>> >  .../sysfs_damos_walk_kdamond_exit_race.py     | 82 ++++++++++++++++++=
+
>> >  2 files changed, 83 insertions(+)
>> >  create mode 100755 tools/testing/selftests/damon/sysfs_damos_walk_kda=
mond_exit_race.py
>> >
>> > diff --git a/tools/testing/selftests/damon/Makefile b/tools/testing/se=
lftests/damon/Makefile
>> > index 2180c328a825..60c83d6c318e 100644
>> > --- a/tools/testing/selftests/damon/Makefile
>> > +++ b/tools/testing/selftests/damon/Makefile
>> > @@ -20,6 +20,7 @@ TEST_PROGS +=3D sysfs_update_removed_scheme_dir.sh
>> >  TEST_PROGS +=3D sysfs_update_schemes_tried_regions_hang.py
>> >  TEST_PROGS +=3D sysfs_memcg_path_leak.sh
>> >  TEST_PROGS +=3D sysfs_no_op_commit_break.py
>> > +TEST_PROGS +=3D sysfs_damos_walk_kdamond_exit_race.py
>> >
>> >  EXTRA_CLEAN =3D __pycache__
>> >
>> > diff --git a/tools/testing/selftests/damon/sysfs_damos_walk_kdamond_ex=
it_race.py b/tools/testing/selftests/damon/sysfs_damos_walk_kdamond_exit_ra=
ce.py
>> > new file mode 100755
>> > index 000000000000..8e8006d63926
>> > --- /dev/null
>> > +++ b/tools/testing/selftests/damon/sysfs_damos_walk_kdamond_exit_race=
.py
>> > @@ -0,0 +1,82 @@
>> > +#!/usr/bin/env python3
>> > +# SPDX-License-Identifier: GPL-2.0
>> > +#
>> > +# Regression test for damos_walk() vs kdamond_fn() exit race.
>> > +#
>> > +# When kdamond_fn() finishes its main loop, it cancels remaining damo=
s_walk()
>> > +# requests and unsets damon_ctx->kdamond. If damos_walk() is called r=
ight
>> > +# after cancellation but before kdamond pointer unset, it could wait =
forever
>> > +# for handling that never comes, causing a deadlock.
>> > +#
>> > +# This test verifies the fix by rapidly calling update_schemes_tried_=
regions
>> > +# while kdamond is naturally terminating (monitored process exits).
>> > +# Without the fix (commit 33c3f6c2b48c), this would hang indefinitely=
.
>> > +
>> > +import os
>> > +import subprocess
>> > +import threading
>> > +import time
>> > +import _damon_sysfs
>>
>> Let's add a blank line before _damon_sysfs import, to be consistent with=
 other
>> test files, like sysfs_update_schemes_tried_regions_hang.py.
>>
>> > +
>> > +def call_update(kdamond, result):
>> > +    err =3D kdamond.update_schemes_tried_regions()
>> > +    result['err'] =3D err
>> > +    result['done'] =3D True
>> > +
>> > +def main():
>> > +    proc =3D subprocess.Popen(['sleep', '0.3'])
>> > +
>> > +    kdamonds =3D _damon_sysfs.Kdamonds([_damon_sysfs.Kdamond(
>> > +            contexts=3D[_damon_sysfs.DamonCtx(
>> > +                ops=3D'vaddr',
>> > +                targets=3D[_damon_sysfs.DamonTarget(pid=3Dproc.pid)],
>> > +                schemes=3D[_damon_sysfs.Damos(
>> > +                    action=3D'stat',
>> > +                    access_pattern=3D_damon_sysfs.DamosAccessPattern(
>> > +                        nr_accesses=3D[0, 200]))]
>> > +                )]
>> > +            )])
>> > +
>> > +    err =3D kdamonds.start()
>> > +    if err is not None:
>> > +        print('kdamond start failed: %s' % err)
>> > +        exit(1)
>> > +
>> > +    # Wait for monitored process to die naturally
>> > +    proc.wait()
>> > +
>> > +    # Rapidly call damos_walk() while kdamond is exiting
>> > +    # Use a thread with real timeout to detect kernel-level deadlock
>> > +    deadline =3D time.time() + 5
>> > +    while time.time() < deadline:
>> > +        result =3D {'done': False, 'err': None}
>> > +        t =3D threading.Thread(target=3Dcall_update,
>> > +                             args=3D(kdamonds.kdamonds[0], result))
>> > +        t.daemon =3D True
>> > +        t.start()
>> > +        t.join(timeout=3D5)
>>
>> I'm not sure if this is reliable to trigger the exact race.  As I mentio=
ned
>> abovely, I tried this test more than 100 times on a kernel that having t=
he fix
>> reverted, but I was unable to make the test fail.  If it is that unrelia=
ble,
>> I'm not very sure if having this test is beneficial or just make people
>> confused.
>>
>> If the test has no false positive, maybe having this make sense to
>> opportunistically finding the bug.  But I think the 5 seconds timeout is=
 still
>> not very reliable on some case, and therefore it seems false positive te=
st
>> failure is available.  If that is correct, I think having this test migh=
t only
>> confuse people.
>>
>> I think having damos_walk() kunit test for its functionalities including=
 the
>> walk_control_obsolete might make more sense.
>>
>> > +
>> > +        if not result['done']:
>> > +            print('FAIL: update_schemes_tried_regions hung - '
>> > +                  'possible damos_walk/kdamond exit race deadlock')
>> > +            exit(1)
>> > +
>> > +        if result['err'] is not None:
>> > +            # kdamond stopped cleanly - expected
>> > +            break
>>
>> Is the above if condition correct?  Could you please explain why having =
an
>> error here is expected?
>>
>> > +
>> > +        # Check kdamond state via sysfs using dynamic path
>> > +        state_path =3D os.path.join(
>> > +                kdamonds.kdamonds[0].sysfs_dir(), 'state')
>> > +        try:
>> > +            with open(state_path) as f:
>> > +                if f.read().strip() =3D=3D 'off':
>> > +                    break
>> > +        except OSError as e:
>> > +            print('failed to read kdamond state: %s' % e)
>> > +            exit(1)
>> > +
>> > +    print('PASS: damos_walk() vs kdamond exit race not triggered')
>> > +
>> > +if __name__ =3D=3D '__main__':
>> > +    main()
>> > --
>> > 2.34.1
>>
>> [1] https://docs.kernel.org/process/submitting-patches.html#commentary
>> [2] https://lore.kernel.org/20260524091812.35283-1-saileshnandanavanam@g=
mail.com
>>
>>
>> Thanks,
>> SJ

