Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BAD2C55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 19:56:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BDC36B009D; Wed,  5 Aug 2026 15:56:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76E666B009E; Wed,  5 Aug 2026 15:56:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64E7A6B009F; Wed,  5 Aug 2026 15:56:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 313A36B009D
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 15:56:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 97E1E1C105F
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:56:24 +0000 (UTC)
X-FDA: 85068272688.11.A1E989A
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id A8A96140004
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:56:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BKkkh79J;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of pratmal@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=pratmal@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785959782;
	b=XMLQqv065V+vg4274UbNvIRZm/QFUkADAAugw/OTc8jz1H/KELSbP5d3QoT9eT8sBWwQRH
	FyQF1RN20DyRjOOh3kaL1XutvKZn0kFuPopA3AVjL/wBRW7EZbL3u2Kv/pTzDxm1mFH4Sf
	5z/16Wo7m87P1/SV9IylUZ5qs9NYG2k=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BKkkh79J;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of pratmal@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=pratmal@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785959782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zHwIHqoPtrTJVrd9bNz+eu/8WRJZ5ib42Pm/eEnXe2Y=;
	b=P+OWk+ePaSGlDfHIaRo00WNkG3Z3yjtPAG+pHZbN4lmQ1r2XnNqL3TzbClD4PVjdIzskj/
	NsPPctTzbK8QQLfI9bR53xu6sxLx/dC916JNxoQyZQoCzZyTiT60teZ310bXxp6gjfV6IV
	X/6i04EKZPB+lIq16A1dHWsoyTvVQ2U=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51c10ed63c0so9011cf.1
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 12:56:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785959782; cv=none;
        d=google.com; s=arc-20260327;
        b=WmwBUdA+788fqng8aivcl83uQPkS80qoVQ46h5Rq5vF5xlInVui0OJv8w7oXZiQRXe
         AsEbmqJuBXHdTDxFN43UYVx6Q2CAuZ6PcKB4RpmBMAnPhVQbHTTmxm0SB0THrmeSN5uZ
         bpsi8nls7utj6ZiTLbQeMuHjmfGJ6dnFLFMEqnPC/49ryoBPJkbI1PraSf3fhlblrRlt
         kL+avmGnWZ61X7bniGX44f5LsNoQnfbzKNmsWvO8fmAW6cqFHw1QiVb1wqjXCalPfKtR
         w3ExSnGOFAnRJlW5nFwOpa0PJej0ND66l0C0G6HtptNxVV1OCQ2DpiJsijJS6xVqyy+6
         DYTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zHwIHqoPtrTJVrd9bNz+eu/8WRJZ5ib42Pm/eEnXe2Y=;
        fh=ONLdHzzAA+jkyFFl7+Y6sEhGuwQrTyLEe7hr05EGcIg=;
        b=BZB1RH5Eg3Hx3dLvkW/tChCq0MERc5eLnqA2YzytV+WTzVdJupRNUzfXAvDu8fiRYx
         RqX31sUNcBxZ584+BTIgXG2kaokt1FYCBAzjhaxB7e6W3+VCVSJ2CuWUQYCGXozZDW/f
         dkEQovuTtBsWs1WSWnYjj3d20QZNwcliGC+inHSR69aPN8MPHcTa+0Ond6PM8AMy0CG4
         CSBhX6pVZhXJzwx7dBDRP/X02RlphbDqUGcV3esiqsQ52QQu1sLXew/UzM1xw59gjDUJ
         GU2prxWfK3fCEfgWMvDDn5BsnNt+VC50oDBCF/Heqq/dBkc514CWMby+VXQxMc5cu+nS
         EovA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785959782; x=1786564582; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zHwIHqoPtrTJVrd9bNz+eu/8WRJZ5ib42Pm/eEnXe2Y=;
        b=BKkkh79Jr5KlO3lPb/GTQtokD6Me4BluQK4VVwfBTjpIjTdj0vJ2Yw4rKR5HnL/05Y
         Z+IKOthrhX5qmNsYUFaq6PWUO3TWWVffv8+JXJCv+gqYoiwnGH6/0TQPG/O9fxCJa3Rc
         dLR1qK8HTSbD+xtnQk7i8HKkqOm/fVx5tHLJ6ZocoPBepP/tVDMAwZVN840tmzsnJXUW
         SDD5nLYhkKfKNPPAJEgQOgMG0EITl1jLPKuLFYt2daARxkHSovuial/p9cW6H2Xgk98O
         vRItN/ObsQulcviPyYGpnleilwIfn1robohgpAErJxGXro3VDTw74L9HzE6sEjJ2TmWZ
         IPfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785959782; x=1786564582;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zHwIHqoPtrTJVrd9bNz+eu/8WRJZ5ib42Pm/eEnXe2Y=;
        b=EXqauFilPpczqYI6ainqP/nwkzoLdgSQwctLuvfXTDNgN7ccvmjT4uQXCJJWsZwzAW
         Kdh69fPDsiRw51T1PfBUuqlFHGJ2kBJI9qH4YePqfx26s/6POEZNdfc+e9Pp6p4IkFOR
         lh6X3C8VQN0LgdTAZ5imPo8ISwmhw/XdvKMikOJCIEwvfCHJx3qzXsCdPKxUb8WVbRGT
         CE6iDVf53ZlqgkV0MpaJcUCoienAy1Tok4xBUzNgavQSBPzqkkP/s0Uxv36bGLRKGrax
         422WQ53rYdlVsIBVXOmIhfK9Xvu3XYgne/bs3HD7xeFGplxcFIs8OSvpO2ckoiSmSwMh
         acUA==
X-Forwarded-Encrypted: i=1; AHgh+RrAqCHyerIHL25lk9o+U/Aoh/j1+7hLobqaR4zoau0SQXyjSDD1HTz9OWWBwsFywMhWTxpw4ah1uA==@kvack.org
X-Gm-Message-State: AOJu0Ywnd0ejR7y3EouvAbB793dNL82qRjRYL+dZCyBPcM7lpu13Aatw
	wtwO62gTZUa6AmxnEme7CezB2vOShW4lsczKcrsjs915SsEZvbZNk/FJIefxWUZb1qoz6LeB1Ta
	l4Dkyc2PwmuEE5/MQqJA1xRl4Il2wet8qmMh9uKwCuSOU5JmpQrM/oywvvcY=
X-Gm-Gg: AR+sD12oPwwRIiYDvAeu+McRPr6e+BSwb/+62J3/UeZTFk8wb5QPBJfWetV9BgqyGGo
	9dW+fW7jYfUEEbbLXObT6Lje6lkZ5GL2/5dDCBGpsGR0zRIK5KUJPSMQAC1kFKr4mT7VuoNgLxk
	R9PHQYMfXByfhPe/76Sqla7CBXe3+dfuQAyLez+971Ze+OEBZt+liOMSoadZ+n2373kCgNdaSY7
	cexVAaSgmQcT/XlQZv8BHJB31+HsNP8oaOOJl3VWw4iUDQuJDnz/4SfzPpaXnxat7q214GnXYMU
	ScUdXba1g3zAEmiTtp+W81/gQeHGKuJMJ8xqi/8W8eob7EPldHRWguzULlXKQh6hYXTrij+IS1w
	=
X-Received: by 2002:a05:622a:87:b0:517:64f6:3365 with SMTP id
 d75a77b69052e-52cfbd65c9fmr3457111cf.4.1785959781216; Wed, 05 Aug 2026
 12:56:21 -0700 (PDT)
MIME-Version: 1.0
References: <202608052027.LCDnsFT0-lkp@intel.com> <20260805084004.afd47046925c62a5b19e242a@linux-foundation.org>
In-Reply-To: <20260805084004.afd47046925c62a5b19e242a@linux-foundation.org>
From: Pratyush Mallick <pratmal@google.com>
Date: Wed, 5 Aug 2026 12:56:09 -0700
X-Gm-Features: AUfX_myY1R11nU9KasiNlA68yK8CLGvKrR9s7tVmmqzIezO2sr5IYEZJAhJofek
Message-ID: <CALHaPKepTmhB2TZ-mk1kM5PhCq1774YCELDoRNypmus5RhVk7w@mail.gmail.com>
Subject: Re: [akpm-mm:mm-new] BUILD SUCCESS WITH WARNING e47602c51d20a93fa1711ed896dc9480de4374d9
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, David Hildenbrand <david@kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A8A96140004
X-Stat-Signature: hkcrqjkp6qf6ac6wb3fq16s5qx91bmft
X-Rspam-User: 
X-HE-Tag: 1785959782-843329
X-HE-Meta: U2FsdGVkX19hu7D/VApvG0zpKiW1oZ4UL2WfqkK0YGoFpTWPMnQu3aJ8Yo2qf4cXWOiWa95SWWpyOl/p+KzXXsoC4Y5XQSJGDVjDU5oYn8NLNvJl4UzTzdDNXg7IV4UZFdBxOkQeCZXkwhXTm/PUgR70Kh9pallR1n2iMTq/FU/GfRQZ5JZbXpLv1RoIuFzN4onbYYBVBW/J46vkTGU7F3kgLyAzd64dXogV5Ztv7iesRAETqTG5a0mTR5qCdthblg6ICqS10KhPteQIU3ywcQzhozlLfX67O1YY0fVgU89hch5UBI4z0SYxHd2ekB8QZufzK/SJk41Fg+tdhOAZkNuqy1PMx9pEvT748dEDUnQr2ZBvKm2CEoLhb8deOlY5cbPJB74QX+7uzjID08uhV25qjx8mYe0QPXOomiyaNWZ8TZ4vG3ePmdHdNgQ7Jso/IBdHMmpBPklmBg9MCupPDfC6J5e4pYK6Gowtj3ny+8Tw+5nLUwDWO9UQ+d3RRWr0Y78m/IWAIneuE7PyOvTia9PU3WW1a8lyDrcbyu/C8LiUOVO+4thRcr2K0plj4QCJH5TJqLBHA50SUjJnfqyyEiHy6PrFWfBnZ7cfWVfcTq9NkZpCBCIgqQQsZtv0AjqDmGVEb3AhpTlRwAJeQoBLBNboLurNMrVKmNv4704BPyN5azPqz0CSGhzTuyQXHezj+WXS9vKD2QWSLAfbrLyjnpwxo2WxWOwfVNf6yRi9ssvau0gi+O7Jh7Ecz5MsuYCKSjgfhM4W0kBNW4jHkPX5OJvmbGb9f0mghKt35aAXmvZW+wISzC8heLqPILJ7lbhgqjFenqXJ2nYW7lunV7E8qQFHqxGhecXcj87dCqNoohj8VP+OwibvF/2zJJK2v/vTr7/xv7wdVjGuB6YRnZLEu85kL4AvcQVwwjRed8RE8cWwdstV+pfBy9At5hVT/I7BbGbVKZNAy5Ad0+bpBip
 v1pvpizU
 ZaDJMpZmBn7k1/guEITn9htcXsd7+BVr2OlfEwHvyu0N1gPywX7j/X6BgLo0OJkxdGP/rhRGzGlxj4w65mJoRssJ85OQ7GL/LMvyfUyqUU3Qz1i4AjYugeUOxkA3n1UwKxvqTJS3x6fQZAMUtOVrvwF9NyEt8r6Vg7EbNH5mJ69uWV786/Ad4g53yGBQe1v26ZtiqNrZRUD+7AVeiHtj5XZPJ5ttwCvIXj4wPRH8B2KtbX0bJ+VibHmcm4iRtBZVkEO3A8SRQRLdWipb404s1/gwTZkN4wQRGo8BRBngYXaxxgH2Nrb1kjADfcp0lnaQz+1tE9cm7gbJkHM7SuCGWJSyowgo5weu/nyHS4Hao7/huT9Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

It looks like during conflict resolution in mm-new (commit e051bf0188c9),
the following negation rules from v4 were accidentally dropped from
tools/testing/selftests/mm/.gitignore:

!*.h
!*.sh
!.gitignore
!Makefile
!config
!settings

Without these, '*' ignores all scripts and headers, causing the LKP warning=
s.
Could we restore them when moving to mm-unstable? Let me know if you'd
prefer a fixup patch.

https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?id=3De0=
51bf0188c9ae10e822a532aac5821c2cc0632a
https://lore.kernel.org/linux-mm/20260803221732.3651981-1-pratmal@google.co=
m/T/#t

Thanks,
Pratyush

On Wed, Aug 5, 2026 at 8:40=E2=80=AFAM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Wed, 05 Aug 2026 20:32:52 +0800 kernel test robot <lkp@intel.com> wrot=
e:
>
> > tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.gi=
t mm-new
> > branch HEAD: e47602c51d20a93fa1711ed896dc9480de4374d9  mm/swap, PM: hib=
ernate: atomically replace hibernation pin
> >
> > Warning (recently discovered and may have been fixed):
> >
> >     https://lore.kernel.org/oe-kbuild-all/202608042227.XDO54bZk-lkp@int=
el.com
> >
> >      .gitignore files
> >      ignored by one of the .gitignore files
> >      of the .gitignore files
> >     /mm/write_hugetlb_memory.sh: warning: ignored by one of the .gitign=
ore files
> >     /selftests/mm/ksft_hugevm.sh: warning: ignored by one of the .gitig=
nore files
> >     _hugetlb.sh: warning: ignored by one of the .gitignore files
> >     a.sh: warning: ignored by one of the .gitignore files
> >     arning: ignored by one of the .gitignore files
> >     fd.sh: warning: ignored by one of the .gitignore files
> >     files
> >     g/selftests/mm/ksft_memfd_secret.sh: warning: ignored by one of the=
 .gitignore files
> >     les
> >     nore files
> >     s
> >     s/mm/ksft_ksm.sh: warning: ignored by one of the .gitignore files
> >     selftests/mm/ksft_pfnmap.sh: warning: ignored by one of the .gitign=
ore files
>
> Thanks.
>
> I'm guessing this is due to "selftests/mm: use pattern matching in
> .gitignore"?
>

