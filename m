Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA6CDF34C4E
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 12:30:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B50B6B008A; Mon, 13 Apr 2026 08:30:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 064FC6B0092; Mon, 13 Apr 2026 08:30:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E95F16B0093; Mon, 13 Apr 2026 08:30:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D93BF6B008A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 08:30:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7F0D51A0182
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 12:30:06 +0000 (UTC)
X-FDA: 84653464812.28.556715D
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7D72914000B
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 12:30:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pesrYmJv;
	spf=pass (imf23.hostedemail.com: domain of glider@google.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776083404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EIvZhTQr6tmo7ji60QbhOn4IISjfSdOARCghWNQMVDg=;
	b=E0fnepWrhRqSYzU116uRrORCIhBRL4ef6mZe1bkwXXjEJOVuHNRN8K+TmUR38sHamG4+y3
	UxSGlpDA6fjA8K2BlqthRU+/H2d3lREJBbx9weKnudz+bP5T4NF2CA+iIdY39kd61LkCfG
	sBRIAfoKQ6uiknmPQsAYLlONZjORpUc=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pesrYmJv;
	spf=pass (imf23.hostedemail.com: domain of glider@google.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776083404; a=rsa-sha256;
	cv=pass;
	b=HiHvwxNWslvQ7gFMfFW7h/uM/xLAeCSxSi98BH+ojuqAJiWQqu/PN8Q7iaxPupVI3ygisE
	QplNTCa59esRa8CTqKILYyu+6AvCFsi7ktiENmVY98V0SGQWGgnLblX1mX8p/UodF8Oq7s
	dZtbYDYkIrsGty+2YmSMC/k3qUOyFes=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8acb3daf2aaso7750206d6.0
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 05:30:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776083403; cv=none;
        d=google.com; s=arc-20240605;
        b=eXzSTnHoGXW2Ki9+92mjr1jECGW8eQcr4nscKaDuWd6qGHzBwSvHC1qnNaQ610cJnQ
         ikTed7N/MsHoS5nqdkAE6JhLlQ++XFN2jMdUPaej1RPLESBHTLbnnvEe6v9giKl2h+Xk
         sc03oAKhwrnQfT2CgzMZ6k7YYEhez9Yzi2hnng6VMONUv1+BqbNesnQXRaS7gxauNzjO
         u7ahNGvl8lbh7DNppvcfiTWmo8GGlppCy50ZkJeSXxffiPyIZs+isM8V4Ps4+fEGg7pR
         c+czKByR4gQ/xydU4lublqGnnGznH0NckyWM2+lrZi3PNM9qjKz6gmzr0PIdgPJpsxsQ
         lGdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EIvZhTQr6tmo7ji60QbhOn4IISjfSdOARCghWNQMVDg=;
        fh=ylh0l0D4VpcmlDJw2L+1yTfwMvBVYX7ZUmGVLWFteFQ=;
        b=X7olPPamuBWsHdIdHhudvGK6/gaXIpm+dO7QdFtAfjAQY/Ov+rbsGiQA+U00ZD+oIx
         uGhFYqN1qzEgV0Y47u93PxLFv60bfnBR8lgKtI+nLB+/YFGCrwmWYSZCngPNMCDhndkK
         Z4k03SEtNCdIBYObIQCdE1QduaB2c74JL7LI6PYq8eN7I3jvJ3xzxh32XMgZFF1rGglz
         Cg1ezgzubtlSiFD2CHpWTzt+kxyLr8ueGzb/6SohLLuyZafYoO4EfnXaXwfkZ1cmpFG6
         9ZX7AlOrL4xz+14NUnPU44fMMxab5b8iRJPd8bMYwJ9jl7+uYjq70ixbQ6eI4kNljAQp
         JzIw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776083403; x=1776688203; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EIvZhTQr6tmo7ji60QbhOn4IISjfSdOARCghWNQMVDg=;
        b=pesrYmJvw69aXCNwX3xvW7XDaMS8YCwWRufYH6dUv836qmvnKb6zx+CdyMFfMv4Xxv
         q1/MGkFXLFuR48CSb0jPeDcROVdVj7Ou3dm/LtfOr3EGjXnNMUaQCVQl+coYztYt5C52
         epGcqWvoO3l1cnkcJlT8VeL/EL9EjBNMfOcSz7tLJk8ZiY19+bkx2K6losJclxhY47A+
         c0sqUqV9pTytMTylZdLuo0F+9g5Z6Optr4rSyd9f7CxLXp2OVeeC2RzjPz5bO0fO9E5G
         O2uoHiZREnYzF80xPCq2yIFVGFaFgSg2w71Cm2Cdmrm5u6V5oiAmTsS4ysYT5UxzHdFC
         Bmiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776083403; x=1776688203;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EIvZhTQr6tmo7ji60QbhOn4IISjfSdOARCghWNQMVDg=;
        b=RHjWTFSd8kmji8imyV1NualXe3u/lHlP5A6CWZz+O6HTEtliwzvA1OtEeoBn62VJKT
         m7cgeF+cl0KUEb9CmSqwKxENTVBbdlFA3c2aiPk/zcXydboyhBhmnv/RtY1706Z/GlrN
         qsHL6QrvFvdkYPhiCG1kb+SBB+o43eCN/FAHZjKEMk8spm8105UzQrhjITvLYPIrfVW6
         TedwOlm3UcxVxzoH9I7SeW3Rt+nTI11guIMzvNkWecroHiFH+2U24peUblvT0CYL/gfx
         5/UyihJJRrIcwyF4Obz5o1srNoI0MReR7vHdq0++UbGmgrdfj9Kungy7YqzANlpo4kqZ
         y/mA==
X-Forwarded-Encrypted: i=1; AFNElJ9JwrHPsUqE61wATxDWgBp3dqjtqD6i7IGdEMb1R5jyzVy5iVj2lGUSJoX6+ZR/9fvXJZ72orPbbA==@kvack.org
X-Gm-Message-State: AOJu0Ywz8GXDVTdVAVIjcr0TeXcU2hZioaZoYyu32sELDh8KCb8dcdc/
	KRK8wIKMRJb+dhtj69Em8X8Qa66yYGbhf0zYuUXgc+B5+/L6HsiXUqROdVJ/oN68EihWArnn/vz
	qhFowfs1jEtX2auoP13lF1T3ssFWLA0v+y45ZbDE3
X-Gm-Gg: AeBDietQm3aUTNM8g8GYwu/8MpUCaGT9q/gsCtcgYCh3C/1zBGJjHuour6US6aqMTbO
	0fponQzoFDFuG0uVMqo+XP3hROm71PXGKB+dOtVwIHLDjY54e4cPGlPnqw5fTbL2wRCme0zPW2Z
	iOugRGj1dqGqszzjCj33fEiqk0S9nKpiuXcB4tG8ig22f0Shvw2TFYtQ/KpFYTWtwh4R7Q5z0s2
	vOT1D2LQKBNxGDGiewTU2Il03IRcnjEWExRRoKZfWGOPvo+51bWXcXU7Qj2MI142DdgJxBZ9gq7
	sYZhBNyDaYumNKoTvqR8ScBgzehxCEAX4HaAhgZ+PQGX3Wsp
X-Received: by 2002:a05:6214:c8f:b0:89c:c84d:ea32 with SMTP id
 6a1803df08f44-8ac8615f739mr216178676d6.3.1776083402608; Mon, 13 Apr 2026
 05:30:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260413094034.6944-1-pmenzel@molgen.mpg.de>
In-Reply-To: <20260413094034.6944-1-pmenzel@molgen.mpg.de>
From: Alexander Potapenko <glider@google.com>
Date: Mon, 13 Apr 2026 14:29:26 +0200
X-Gm-Features: AQROBzBzqLb5POy7ec1gf_KPBXGxILAIEMg4qSVXdporPUBPVVAgyEVNkiZtdZk
Message-ID: <CAG_fn=VRNuOahnVxG3LzHprhgi11W0FEmMJ19z+NGZGYhiCXZw@mail.gmail.com>
Subject: Re: [PATCH] kasan: Add abbreviation KASAN to init log
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7D72914000B
X-Stat-Signature: ffuqqkcns6aiuppibfqbteok9wb9rgy3
X-Rspam-User: 
X-HE-Tag: 1776083404-195391
X-HE-Meta: U2FsdGVkX1+rXmJTEg9mbG6X4sTBTTx3snmmnAqL6Ee+RrFmima+6Gd24Tp4XgSW1djKdjwqb4y71g6SEYsVSb4VT3m7u/xCMS4Xv6OGhYNA9hnU3NKRaGCW3tFlNXiR3y0ghLqYCdnd4Io5X8pw2N8YIqYwfFB5hJCoSAWc/OGsHFzFQTwOT8lpQjf2Zb6ne9lDa+BzZWCRzGC2onaAmv1teENWOov25yAkg3uLdbuxNvXYDOc3cXcdkle0cWmTQiJ3v5tCfS55IAk3Pn6ETZrLfk5HVdqvw2ZlS+Ku1kfwQeFYqu9SoGe0pATtiNjmL599TTGqqVdkQhyYIjsSUYlQy3pA+cn6DaYMKl0LgmsYdbI6ze8+2vCG5e2YKHp5zITCjbN8CQA/xTZdAkysbWL/lfP2/qLcrxFUowQIj/h7kx9uJm9QV6ZTSrlcP+gXD1UNgN+L97Hkv0xV1N5+DfEuRQh6A7x1NHdkUyhUy02Ge0x4KlFReohJzDheQLI+LQMkz24r8LzHyBFkSTpjauvjQ4Gczo8Dv35gWJKp+cIAEwW5XEYOP1dj9U9hdE5SHwKy6S/dKNscgOwjLSudinYfaYm8M+fgAET7q4bH6lILvBWa8plYTnqLwK9JGZkVsB4mVfI9EHNXb3LnFKavJrykwsTpePpyhFcM4rxmG69C7vFTi4gibY7wdFsw/o3qMwkGf5EkJpAymk4vp0XcV1AjZFFTtM++0MXmR1jObmcquyvFN2Ys1Nt0dC/Pe4Zhbs83cHzXCFFXv7X5mcAjYCxAvF24Vx/4ELqqhq+kYjpkxA3S4lq4C0pZWJtHcV49XhAgxJpQbOBx6J0/C6OW96ZN3oVofX/hNXccTAjRqPeK7r8etY2XfUqHyEJMPtAXULSb5W82JKKu7GHgGNqxkRqGvoMCZjPUpkF4BpUc8VDpF9kByi9zw7zE7cYi9hCD0nkL4TSDpeTmvehmF1g
 DtpLoXyc
 scSF5jer6ZLl1fe4K+O//Qu0sXxLY+v+K38MLJcs34J5UZ8RtuiZWfiDhOufUyI6/gQ/9d+I9VUeuborYfQGL5phF2b/k9COlkW9D1v2XfGf01bSsOX0+jEGOJhvbCBgzH0R0P30dtFIfiNNxQkYUvO6pzEG8lAK82XCTGoh9/ednKtOY2wqF/SdFV/91vqclkJ/bEK23GC7H8LMHmZVL9PDSq3rWjBFDSt5FKqD1vTejOzpbNqk/6j5NAS0mYMKOOCiRVJ+PwBlUWyn/+aCG/FTVObUuvXyg7V7OSHCBRD7rNqfXwwjqDDvGpJotBA9ATMeoz5oyxAQyGko=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 11:40=E2=80=AFAM Paul Menzel <pmenzel@molgen.mpg.de=
> wrote:
>
> `sudo dmesg | grep -i kasan` comes back empty, at least confusing me.

Yeah, I think this bit me once or twice as well.

> So, include the abbreviation in the log line.
>
> Before:
>
>     KernelAddressSanitizer initialized (generic)
>
> After:
>
>     KernelAddressSanitizer (KASAN) initialized (generic)
>
> Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Alexander Potapenko <glider@google.com>

