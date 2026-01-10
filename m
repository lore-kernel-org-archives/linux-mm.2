Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75F15D277E2
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 12:44:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CD0F6B0088; Sat, 10 Jan 2026 07:44:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47A406B0089; Sat, 10 Jan 2026 07:44:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3860B6B008A; Sat, 10 Jan 2026 07:44:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 22DCC6B0088
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 07:44:36 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A501B56C5D
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 12:44:35 +0000 (UTC)
X-FDA: 84316022910.09.69134A6
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	by imf23.hostedemail.com (Postfix) with ESMTP id CC973140007
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 12:44:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Vrb5ixJB;
	spf=pass (imf23.hostedemail.com: domain of sun.jian.kdev@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=sun.jian.kdev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768049073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ATWW/HLpqiweEYqLT8vRIgSliGVg19nOlBrikeJ7z0=;
	b=w2Gxb9kT0IHhWiSLZyZYdKvQ4sBKNfqWkqAoAopXYPuEK291BdsUWw2X2rhGqzI/RjxfgA
	zhwAPCY+bUwmcfs1DKHZBpsyHkxoWWQBUAbwhaLlbhqI9GKHyFEyinQnCAIq/A/urxp1Ok
	8dDUrxAKtSzEGIySZc6Hl34fl87l1/A=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Vrb5ixJB;
	spf=pass (imf23.hostedemail.com: domain of sun.jian.kdev@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=sun.jian.kdev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768049073; a=rsa-sha256;
	cv=none;
	b=rG8/AiH4pjxkUPMv9+w7pr83Du1/dMuy+xlWLEPxPwx58dLlwWFhLTHrnfIh5ShLPuSq8X
	OZlFjgvHdaTwMWsi18nKmFhxTotwlIZJDNOUUA3lFC2etLqRJyxjHdud0rbxWQINfIYdGV
	L0jVvxTRbNW7CjYhq4CB2mbO11nLDQw=
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-6446c1a7a1cso4406286d50.3
        for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:44:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768049073; x=1768653873; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2ATWW/HLpqiweEYqLT8vRIgSliGVg19nOlBrikeJ7z0=;
        b=Vrb5ixJBv1CVyp9fbXG/p1aATgOmnWY0AjQahnYPd/MhNm30FtryiUP4khqHNfXacl
         kRb/WNOQhBfRgJz080DeVrLl3nqEYqfgikpSdQ+aGQTpmoJ6CCg0P52E4y0oVA8JpVGX
         i6JHjcxo7LlE9KgZ/LhewgANs8yoxR5D4mtils1erlAWhLUsIe89jScgMDUjnIzYhwF5
         pxQEydPnDULHq/EzqHR6NPqcYiiFZdYOiwit+iqS1EMro/HLEmMsceDUh9t0W/3zoSy6
         iyeM3qStd3+XrHdWuEnD7uMDjOhUMOznqbza6pNKBE2ttM5BC2hiechEPlGEbmR3/uqk
         NMnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768049073; x=1768653873;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2ATWW/HLpqiweEYqLT8vRIgSliGVg19nOlBrikeJ7z0=;
        b=kzjF8qz5gzYSuX3BHj4gHyqan5AVyuXqFdw8xVqxp/fQgYH2VvrX/RvqabyHZrU0iX
         fPEPNsttgK/41gp3m0xVCbp6DsJLSXdeB6cELErC5/jpSiMo6qXuKU+LDqZp8HVEXU2q
         7hQyb9ziXgNv8mK5NeTtBPbEHzFD6Te8pt4l43j0Y4afM4bjzUMAgQAN27rkjqWK2b/t
         u9RY0QqEPFGxQnL0JmvRODsK6C88g/Cu2MqW6xHH8oAwOL1IINsRye39p2OZLDs2GMJW
         doKf0XZRlzcWEKN4ZmJaOFeaDMtWixveC2hPvf4g4nkYjcc/xkFuYFplvsml7te2CEev
         v9kQ==
X-Forwarded-Encrypted: i=1; AJvYcCW+fRi7ZPxnAnGsuOqxhXTPf+x05s9pyZqx0X3acA+cjHqn7NijVUcK47qtmJFxhR2hQcgmV1o9bg==@kvack.org
X-Gm-Message-State: AOJu0YxxcmicNoqBbRgn07aAi/CtW96xgiAb0sdsPp2ydKYcjEyrwZr2
	Hczkwl3gZt4RZterZBW0IPnA8F9UHUBB4C6LC9ovryMOjYk1MdETfQbRCC1rF56zMTbmfiGG6pd
	FTR31msOErMKeGSBptrDWlXVSUvDrfrA=
X-Gm-Gg: AY/fxX5rEaFDW2LvNx1Qixg5UJVQPODrGdEKztuwD9dbr3XlrkT3Ea+WOyIXMfYYP3T
	5iqmtJPH8l44kkJbLt8Oo83S4POlvXZblwK+Uyqqoib1XlyTRao7TJVgvswIWzTZaUCcbrLAsN8
	Lq+QYfbsxRKvW+NWzOIO+iQQoCfFBGBaMy0W+04nEWDGXtTJhZtPgd7JSREa7jk+igdZfYa3klo
	o4VxJK0pYIsyVNjpD9d1sGJjNtzUlipCorbcOcyy6zuqNLuNGyams3g7w0l/pT1IJllX/tfOkhA
	bTWXM3XTkLwHw3QkLw==
X-Google-Smtp-Source: AGHT+IETWZK9RqMS2ankKQKCP3Af4KiZf5Idfm5YJ7cXURSnpzjquubk+1eqrAE4PCAe3MrG+/FDqO0zSaKKeGFnFKI=
X-Received: by 2002:a05:690e:4105:b0:63f:bf9d:e530 with SMTP id
 956f58d0204a3-64716b8d87dmr10902720d50.29.1768049072933; Sat, 10 Jan 2026
 04:44:32 -0800 (PST)
MIME-Version: 1.0
References: <20260109094313.52307-1-sun.jian.kdev@gmail.com> <20260110011641.81278-1-sj@kernel.org>
In-Reply-To: <20260110011641.81278-1-sj@kernel.org>
From: sun jian <sun.jian.kdev@gmail.com>
Date: Sat, 10 Jan 2026 20:44:21 +0800
X-Gm-Features: AZwV_Qgm0OSyVdhuNlptboXVPT1IdCA995oh-89jCEg0X7pwTwvX7mSblK0Y2FU
Message-ID: <CABFUUZE50X=PXAK0nFC1qhj4GhZ1FQJ2T2Jf8M0APE6s5-mgvA@mail.gmail.com>
Subject: Re: [PATCH] selftests/mm: ksm_tests: skip when not run as root
To: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4pkqzw5cnw7udcpypjd4pubwakou8knw
X-Rspam-User: 
X-Rspamd-Queue-Id: CC973140007
X-Rspamd-Server: rspam08
X-HE-Tag: 1768049073-782643
X-HE-Meta: U2FsdGVkX1/rBajaZJzYV5rXf/Sko/TzETWzAr71t3KS6MbOu/8u4IFcZ2cXgV/2fPtAPiRSUC8QSZt6LgC9GBTXOFzQMCI9DbM/nfsnnrKYkb5pJAx8nKs3Q4pV13tze+557AoXyBB13v+dkY/8iW8XDMZKEnhCNNEMXmqX4AEbfFvelXF6KKtjhl70N+bKoKkgavL7WVRD+7kozw1UQ7w04QYBhvSS+YqHund27HTSgdWFn+FjeQics5bCUJNrDwzIB+8Isve+hgObnwMAYuIhsXlVBfh5IbtzXbpT7KCnmDmojAS+ts7SK70UMk1o+1skFalaeeOlQSrQftG2F+y9MYEmOYfMdxWHZH7EK6ec1qkwBDGEswcwMNY2JzTjgE0rPtj+6KNDWWKUMqStwgiwjkxbP6Tf+/oJlmSiEiuKb+Z1eM3lMlAcRa3fADxojozLQnhXxJQ/Z1ULzooXdn5JvQQmVkV4VRHvoEZ4rcM1JLtLp/fK0zOwmkgYc2LVAvU1zrGGVGUqSurkms3qb1XZgDkxlUKSYLaOI01w7/HkVgd9x4ClFCtiTvG3To7cZm/XiLTr8y/hwIXyxL9/injU/4z4i4W6I6YPGyJ23ucGn2JbQEI2oWKtTSk238Xw9omYlHEvUPL3yEnd2MdyNoiS8QoB12LgeUHZjeNOpQl1KOlTdDEuaL9MMX4AOtFt0Bv53AsPpD2Di6dHXRoBDPUx8nU1QxuRJcxYqhzPPyjqI6cmSj/MZxXQpfHyKPXPkfYegEtAPgDe33QS7gHLKyzJ9uzOFcQyu/qY1SjBGQtHUFXTT4o8Em4oJvFjIlQM9TzQGqBWvCxq45oG9+pTv+RAWV5GYVPwocF9sw7FtLun9VA2DNUzIk4u6r6BT+HqdC1uRGR+4txFHmFNh4pvhOoQLuG67aVxskQyDIyxC8crKttbYxV2sCYFa1Bzj/x3/AkbWrGRzmN8oL3JGP+
 Gu1kLUa1
 dpOKu3cFPCnf16XfiGbPPj/Phhhm3SdPnEHD+E5TmYbWMQD2PRU7AMPm/AgXZULrPo4kXywz5EYRr0KHJ/6PePtqIoRyesbi16qPP4vA3uKB4XULds6irj6RczWGu7caXsmHOQtEz9pu4zjtZXiOt5cd9CXoXTVEaVXC/JB800evgiT1JldTYwFsW3sipifilXAOnYc+PKyb08AOlqOu27pv9+Mbys/p8IeOiXqJ18jfySAhhqZRck4YPnmzsBbPkzVe4J7k7cch7shcT18Q9Z432tAnAQ6Eymh9OsLQ3aSuRMAfajv2HljxblZskL+nKVm4rV7DFIOcnVy4e7VrvscL6KByi7SugSj+eQNdVuOcpmivYl+m8CNpPjcrxWK53ptAhnKCP4o9yDqXRrFXbjM2cCAwJLqMAZgMtfK8caPTWudJDd6BVJMd7b+265k3UwvlCvikmnV0MCw4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 10, 2026 at 9:16=E2=80=AFAM SeongJae Park <sj@kernel.org> wrote=
:
> What about using ksft_exit_skip() instead, like compaction_test.c does?
ksm_tests is a legacy selftest binary and doesn't use kselftest harness/TAP
APIs. It only includes kselftest.h for the KSFT_* exit codes.

This patch is a minimal prerequisite fix. Returning KSFT_SKIP already
provides the correct semantic to the runner, without pulling ksm_tests into=
 the
harness model, which would be a larger refactor.

Regards,
Sun Jian

