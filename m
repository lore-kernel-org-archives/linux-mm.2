Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DE87CD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 20:37:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 552C86B0005; Thu, 11 Jun 2026 16:37:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 529696B0088; Thu, 11 Jun 2026 16:37:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 440BD6B008C; Thu, 11 Jun 2026 16:37:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 353DB6B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:37:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CFD571A07A1
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 20:37:04 +0000 (UTC)
X-FDA: 84868791168.01.5E65FE3
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	by imf08.hostedemail.com (Postfix) with ESMTP id CD903160011
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 20:37:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qi9G9zf1;
	spf=pass (imf08.hostedemail.com: domain of saileshnandanavanam@gmail.com designates 209.85.217.46 as permitted sender) smtp.mailfrom=saileshnandanavanam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781210222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+sd3cdzhpA5EXsMbu0XJlZwk0ZLWyDF9YQvcNfzR1z4=;
	b=ty9R7VIoECbRBV2pXeCpjfl76kHwntTcQPdMysn7+z9dhcUAcAlXKmFhJZ6TFN++DnRyW4
	28NABa8KaJPa/5/tO7GFqswoW6X8RpoQDM+X26WXmRF6X5DkgccgAveL/JWDxptW1b1epq
	Gmp4L/SPd/7Gz/bVrP1/gJkxy1ILWV4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781210222;
	b=cMrnS4m3FwF2DPiqtA7oVD2V4g7cvT4F4nMVSQ/NFe1+YscA7bq7npKHYRacn+M/bZT4lO
	2RPULDn9a5+dOtaxRKQ1V6AsFYQRmnk2OM7nLwCvo/Ehy+Ecn3mlLaZETaXYAsv0nxqE/Y
	uZoeUe2+NH8nUL1284pbADAm1EULA44=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qi9G9zf1;
	spf=pass (imf08.hostedemail.com: domain of saileshnandanavanam@gmail.com designates 209.85.217.46 as permitted sender) smtp.mailfrom=saileshnandanavanam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-6cfe2f908f7so3839137.2
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:37:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781210222; cv=none;
        d=google.com; s=arc-20240605;
        b=B7c1RZUV28A/r5Dn2bXcgvgWyLldXyXnYWciNE9mlfb2fE9I3bUuvBDeu9RlOlkmfK
         IlZwaKcAzaojcRp3p8EecWDAZ4wImMMUMlUuVpM3MpX4z3pe1KUzO/N6zx4LG/JOBBsv
         h2B0CoDcNMoIjdxEKvcwsM8y3PKgm9983V4NWsV/i60RTbpVdcZZifbXroadN/NNjLLe
         tx4ECQKBspd5keU0Q9aoBqL2ew7e8Z07yTgZsZhQafpqbRplNHNURGYeeI+Ps3s7ZmW5
         0OOw3VEZKUERXrY2SUOXLFB/cR+M+HHwsxnuWbBeG9NQxMVmQFcLlTXgzWVa/vNcTTXY
         OzOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+sd3cdzhpA5EXsMbu0XJlZwk0ZLWyDF9YQvcNfzR1z4=;
        fh=0Rqgkse1tgq+LlvR5rKfZTqCDXEwhvbZDYK3yHzKpIo=;
        b=DSncRmcuQ3bz36y/XMnfyb9Y+LQmWEsT6Puqe8lWdkIwkaLvY0GmG/U3mtSwYfHwV1
         aWq0OImIQza+XzzfUS1vphTvwtyHSaDZgsOF/heFlp/hPJNjdKAt/PQFPQ0zFHAmwUtj
         cjpZq2iEQwuAytgtb2tNdgrnGbACXGcWCZfTndhGcJbjjdYv8QgRoScP0nOe34J9xIHJ
         8VaQPMyDMxMHJN58Dg558UJGCZEWj2YeBOFbxKL4Pu8m56Oy+mYUurs/V0yxAlm7dqmK
         XP3NgFd3xq24KgZcwsGZB/HvtdSganT8bAq3ZFoX8jJ6LIBqdqp8+OWrzPByZM9/ZWfg
         C4MA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781210222; x=1781815022; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+sd3cdzhpA5EXsMbu0XJlZwk0ZLWyDF9YQvcNfzR1z4=;
        b=qi9G9zf19UQh3B53vW9Ipvz6oyIgWHufU5HM2BCay6kCl/IMwHJRy02J2KzDulB5A2
         Ix9XDa9M4yMaptFYh48imMtbh65A/spwLlVOFHupDqnKKftDrLKUhJFHWtqa25WBGjh4
         du8+QAyzJu/m/NFTWAhrTGNjNLEvGGmuYJ/x53jJUGpy3n2SlexoWE6s/6OnYZlY89LQ
         BAEnS0K9ATSKFKjx92zAOli7kfcI7mVBUdt5qIlXKViblkb8cE4GJJNLklW7Fw8IoovX
         eM5RAo0YE6p+mv1MATzv3h9cc19qjJtuAet7DFFnIy2ySO2B/GRJVeb2HDEbTzr5Zrqo
         d0Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781210222; x=1781815022;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+sd3cdzhpA5EXsMbu0XJlZwk0ZLWyDF9YQvcNfzR1z4=;
        b=naznBytE+PwkZs9Ux6eK6QebSHwEJ9ThH9xG73E+xLxmcFKAgf34jnOuWu5Vv4eCAN
         2WOxKe172GRvF6ee9e161lucU5o1UDUWPHj4ggEKviMYvfAKXgzKtFod/6lY14UlO2oD
         jNlQYkw1CFkfemh3qtKzItYYti1czfKO+q2TUAdN0wZ6aGFwB33HOQdkpcNlj/k6rFZq
         0bmuTWpLuoAckkKpQKl4zZd+6oLuWo500BGedvFmJcuxcm5Eo6JPjCcnzHCfNJzwtRpg
         Qo2rJM7oms1HH8y5w9eCaTmXAsvniTkEioZgdV+i+AmuGzRRJoAeIZVM+ILX5UFf4elI
         kwyg==
X-Forwarded-Encrypted: i=1; AFNElJ+b8M8v41unXDJD95MUBnsr76uFaP2BtrYqM8UaYnNRh3oksEX5dqPdo1GEcHAVFGIAI3XtcFzGaA==@kvack.org
X-Gm-Message-State: AOJu0Yzwpf0DEXNVVcMdLmg34rPoXVd2y1NUumvFdxPs89LbKI/tkjp/
	wSfkjWxo1WhA5Op4yxirviAO7vVuF0II6KiLb+3tjYqiS2mS7SNQGbFbCry07/wM9U8ylSksxSG
	po9blH80cL+hb6sBguWNZgG5gM3+qLJs=
X-Gm-Gg: Acq92OHJViI+f0sQyrliZbFTBjRHIiL18aXthHeYav7agMEH6pMvuQryzOOPoy5getL
	7/BTDtkOa9j41KR91BBlrGruEPA9BReB1r6GpkqSDNU8V/Avqqoh8OshIft0a8u6KZm96ymu+1X
	xswvJF93Aec0x1tlavbUly7tI5Mjr0xfuB1HnzbRL59SvmfUAF6pOn0YmG+Cr0ivEbsBcaaLHHx
	U9W+4dh5isrGl3IBfy0N6+7jq3/N3DUNVTmPxHeeL26EVnc48sthxMuyd07wJAlcgE1f4/AbcjU
	zVBR3rxm6g==
X-Received: by 2002:a05:6102:26cb:b0:631:4d32:a86 with SMTP id
 ada2fe7eead31-71d5c67f824mr916400137.7.1781210221808; Thu, 11 Jun 2026
 13:37:01 -0700 (PDT)
MIME-Version: 1.0
References: <CAF+TLO0TOKr3nef9RnbBuZ8A-jNpV1po26t1BO6JbSqMhfABvw@mail.gmail.com>
 <20260606003627.88973-1-sj@kernel.org> <CAF+TLO3a2MBVp3-7jm3BPjuT8jhx4yzdWxuA_QPQ9YPVEj0XZw@mail.gmail.com>
In-Reply-To: <CAF+TLO3a2MBVp3-7jm3BPjuT8jhx4yzdWxuA_QPQ9YPVEj0XZw@mail.gmail.com>
From: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
Date: Fri, 12 Jun 2026 02:06:51 +0530
X-Gm-Features: AVVi8Ce2REi4mUqmiQKXLcfNq0RParFt0ik2l5LBrnYnygRVam7OLZkXJS6yVMY
Message-ID: <CAF+TLO2PX71_-9nKBEAJ50+NpjNkgipig6=9OLsvbgZtqF2yew@mail.gmail.com>
Subject: Re: [PATCH v2] selftests/damon: add regression test for damos_walk()
 vs kdamond exit race
To: SeongJae Park <sj@kernel.org>
Cc: shuah@kernel.org, damon@lists.linux.dev, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CD903160011
X-Stat-Signature: cn4xzujz781w8rfiyqbhhgsywaduwdoi
X-HE-Tag: 1781210222-402694
X-HE-Meta: U2FsdGVkX1/mrlIiJLKVVyoHAiLSp+nA7msVaGylYQt5tb+5pgQ6KvGNupk1Bxm+A8NIfFTa/bYTNSUGwuPg4xWZE20+Hr9RrrqIztqktSjOXGRCMT9+3grzs0fKXDWXkBER2DVAO+Tz74ZTP1JEod+kBXcbABTH03HeE28kJn1qCeuLsRJsyaaajLL9a6Ww4UKcIRvjt2jaM5H+EVfvSdj8hfNb/HkmvHMH/z1mqmWx5fKdK4+luXTXPeLoJdx5OXy9nI9VFRlUIPhMNFJXzYXetmYVAvjF1K8km3N5Z4/gJ/cRWCzGYR3mQzQ28KxdtEawDHY2kjV4hN26WnmNHh/AUjulBvVKWw3JbXewHqgUKkWZtYc5mHrIjZXycT94pgeyVRAQX0qDLfxuG9aIgvpHnZcVZ4m69W1laVdE0HkEOjVpMnwT3auEd8XLrXTkiHGFDFcc5jHADx5tT3m0QbsPfMLKfoajVxQjKRr8CNvEms17VZ1ZNEP9r0wUd4HAMtn/KqA3aIbLcuJo2so8uB4+RUkZLPYAFBzlhhBYB87z3c8MlgTASHS2xAGHgsPH8BGIq2SF4i0Hl3qcr1iMHZg+Az1KROAxOU8K98XMuCSjyefIqWqXT/COLxhzP1G7w+yNJt7E4xXW8rRNVemBUM/0Ycv95bo5KOX0Y5P/k2/TNjUDWiz+FN6nvzdX+lWg9WeO1kv1OHTRZUk4yz9QNRd1fe6NmcJRHurACVR3IBQi7QzOI+aEQNdOx2k8MCvHKzdJyjw+StvlhlCD5/Ctw1GAtKXIgYDglLLzMKdJlz9wVnaLzmWG7Dr5s8FA3Kwmnb2YvHZw+UKhlESTCyGhi3Au10ELhr+4qy2oLMHEUIYQHbUXXCgq6W+27jGrVj8qLgqmQ+hcaMKMJhNfKoTJGvJyQRmY/2NZPJHFO2B1/8nq4xnrdervfZUSZG4CU7ovM6dEhAyqYNZQFFExvFb
 Zywr+YVg
 PTYkV72V9vMv88cgR29RZEqTWOdcyeBCIzznq22ks6RD1Y+LzbbkirotUnceSnFmFl+eXxCsTJfNctlbaSC0fxIC8G/GsLyC0Fq33SJUvrLtpfD4H9fXPvxCsdbrIhZdac9MkFtN0bRSEO4FQprUN1C0mOyYjVHqY/pQlB8GZYxkeH+YKzYvPojEKBReVuTZJIgOXNuBrnnGa6vrHaFwGux3HoaEZZGiGXZu7zSyb37UVmqca3ZM7injpdm1xN/Cm+4wrbQoHgsHHxtDt6R7syR1IPta5cUbpdGNKdQ4+sIVt8HB14wzD18Vr0Kh/GTAB9KfxQZ/OwJ8zF8FEc9uuDimXoN6yzkKgkA8d8cuFTv7vfkdzS9cFpBQsax/oduQZrRKA0b5Gdec0omXtr7HioXW0bXb/jDc8hCml+rSb24XjkphkVbEMwnguqMnTyuiqSLz1dANYUFqsAZujZl0+ShKOvA9XQSDVHjZoztPC1ZDAN5fEIXoEUPdRG+2HPFjWi1CT/AmsappLAdg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello SeongJae,

Noted on inline replies - I'll follow that format from the next response.

Following up on this thread with progress.

As discussed, I dropped the userspace selftest approach since it
cannot reliably trigger the microsecond-wide race window.

I wrote a KUnit test instead, added to mm/damon/tests/core-kunit.h:

- Creates a damon_ctx
- Sets ctx->walk_control_obsolete =3D true under walk_control_lock,
simulating the state just before kdamond_fn() exits
- Calls damos_walk() and verifies it returns -ECANCELED immediately

I built and ran this on a kernel with commit 33c3f6c2b48c
("mm/damon/core: fix damos_walk() vs kdamond_fn() exit race") present,
and the test passes along with all other 28 existing damon KUnit
tests:

  ok 29 damon_test_walk_control_obsolete
  # damon: pass:29 fail:0 skip:0 total:29

Since walk_control_obsolete is a field introduced by this fix, a
kernel with the fix reverted would not compile this test (the field
would not exist). So the usual "fails before fix, passes after fix"
verification does not apply the same way here - the test directly
validates the new field/behavior introduced by the fix.

If this approach looks reasonable, I plan to send v3 with this KUnit
test (replacing the userspace selftest from v1/v2), along with the
commit message format and other minor fixes from your earlier review.

Please let me know if you'd like any changes before I send v3.

Thanks,
Sailesh Nandanavanam


On Fri, 12 Jun, 2026, 01:50 Sailesh Nandanavanam,
<saileshnandanavanam@gmail.com> wrote:
>
> Hello SeongJae,
>
> Noted on inline replies - I'll follow that format from the next response.
>
> Following up on this thread with progress.
>
> As discussed, I dropped the userspace selftest approach since it cannot r=
eliably trigger the microsecond-wide race window.
>
> I wrote a KUnit test instead, added to mm/damon/tests/core-kunit.h:
>
> - Creates a damon_ctx
> - Sets ctx->walk_control_obsolete =3D true under walk_control_lock, simul=
ating the state just before kdamond_fn() exits
> - Calls damos_walk() and verifies it returns -ECANCELED immediately
>
> I built and ran this on a kernel with commit 33c3f6c2b48c ("mm/damon/core=
: fix damos_walk() vs kdamond_fn() exit race") present, and the test passes=
 along with all other 28 existing damon KUnit tests:
>
>   ok 29 damon_test_walk_control_obsolete
>   # damon: pass:29 fail:0 skip:0 total:29
>
> Since walk_control_obsolete is a field introduced by this fix, a kernel w=
ith the fix reverted would not compile this test (the field would not exist=
). So the usual "fails before fix, passes after fix" verification does not =
apply the same way here - the test directly validates the new field/behavio=
r introduced by the fix.
>
> If this approach looks reasonable, I plan to send v3 with this KUnit test=
 (replacing the userspace selftest from v1/v2), along with the commit messa=
ge format and other minor fixes from your earlier review.
>
> Please let me know if you'd like any changes before I send v3.
>
> Thanks,
> Sailesh
>
> On Sat, Jun 6, 2026 at 6:06=E2=80=AFAM SeongJae Park <sj@kernel.org> wrot=
e:
>>
>> On Fri, 5 Jun 2026 12:44:50 +0530 Sailesh Nandanavanam <saileshnandanava=
nam@gmail.com> wrote:
>>
>> > Hi SeongJae,
>> >
>> > Apologies for the delayed response.
>>
>> No worry!
>>
>> [...]
>> > I agree that a KUnit test is the right approach since it runs inside t=
he
>> > kernel and can directly set walk_control_obsolete to simulate the race
>> > condition reliably without timing dependencies.
>> >
>> > I will drop the userspace selftest approach and write a KUnit test for
>> > damos_walk() functionality including walk_control_obsolete. I will ver=
ify
>> > it fails on a kernel with commit 33c3f6c2b48c ("mm/damon/core: fix
>> > damos_walk() vs kdamond_fn() exit race") reverted and passes with the =
fix
>> > present before sending v3.
>> >
>> > Regarding other feedback:
>> > - Will use correct commit description format with subject in brackets
>> > - Will remove the Fixes: tag
>> > - Will add blank line before _damon_sysfs import
>> > - Will add changelog and link previous versions
>> > - Will share revision plan and wait at least one day
>> >   before sending new version
>>
>> Sounds good.  Please consider using in-line reply [1] from the next time=
,
>> though!
>>
>> >
>> > Please give me some time to study mm/damon/tests/core-kunit.h and impl=
ement
>> > this properly.
>>
>> No rush, take your time.
>>
>> [1] https://subspace.kernel.org/etiquette.html#do-not-top-post-when-repl=
ying
>>
>>
>> Thanks,
>> SJ
>>
>> [...]

