Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06CEBCAC5AE
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 01:14:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48AB38E0018; Wed, 24 Sep 2025 21:14:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 461D68E0001; Wed, 24 Sep 2025 21:14:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39E668E0018; Wed, 24 Sep 2025 21:14:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 29BCB8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 21:14:28 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B742AB7A88
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 01:14:27 +0000 (UTC)
X-FDA: 83926002174.27.62F32B4
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf09.hostedemail.com (Postfix) with ESMTP id C09DC14000B
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 01:14:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="OmgOzL/n";
	spf=pass (imf09.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758762865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CmJEc8PuIKQeVF/j4Q0UrN5IUEGXQ70xxORlJFMbhVQ=;
	b=U9dUfYaDdWLZ67t79o2qAOBSXqx2xFSJo1QUNHRymwdKFdptKLI+NqUt0QaSTRyjjiyFnD
	0fJDgp2zQcNlbqeMuhI8hKVBpalmoUmShXWEd7qmA9XKtL3sI/7/gNBQkrtHg4ciqmbe9L
	68q3T3I8aZokEyF3p3i0wWm5UUtIaYo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758762865; a=rsa-sha256;
	cv=none;
	b=Itv1l1h5oP+JgvGiKyd9dZPDKsxPJJMGq3+ORYklza886yJBHGGExIqfpNxIpmcn6oCJBB
	j7M6+DHk3PwWWzIT82miJN6bY+U5juqWb9smcbD5iA57gbKqqb/xOR9FhQEtn8HVK5XG0k
	leneHSWCHfnt+J2rULDebjrM7voixUc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="OmgOzL/n";
	spf=pass (imf09.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-576c6f0d40dso72993e87.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 18:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758762864; x=1759367664; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CmJEc8PuIKQeVF/j4Q0UrN5IUEGXQ70xxORlJFMbhVQ=;
        b=OmgOzL/nzvuetpgw6L60KB2JvGGpPQBa1hpIcjYIx+cky1p0KZwmzz6cXp5Kj28iBy
         WWssshx442sdN0UDsZY438139GaMgU477h9ZMbAr7sT1FEAXkGA17Wr77zs8PaJTQ6uj
         UEzT19a6h+uVG2yqY2VsjK9aTN9CMc2cKktUjlejH3h1VNMKkKJ4gSMUBWnG3q+o7k32
         3yf8aiCZwU9lCoYDe9Vn+AspLHqcPb79mgZrqC4E9VR+UjoS5KiA5cPwcF9WpVjtt09x
         RtYk+XQDGFKd1ts4IHsi8ncFlUaNcINCK/GhxnK4h2m5ipoxjQwPNlrsg7ogUzOgDJvW
         BRPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758762864; x=1759367664;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CmJEc8PuIKQeVF/j4Q0UrN5IUEGXQ70xxORlJFMbhVQ=;
        b=Wmamz0aE79uprpjOge1sNSBvWTq+N5q/HApjEgQN9v3stR81Mu+Zh9NJxHBMoiSmP+
         C6evjKN7q7D5COrooZV/Bi73PqlgDsih/Scsll6+anNVUaBerYXq7hcLaepK9g9rFj3u
         f97hD4X76SE3/PtM8D4MSC5iCYAT9uNrbPnFbDjMzdoS8xwxVCBWHmn8gPr6cX9yHgmI
         HSr3bLkJjCbXkrq51nQXoprXKeIvbd33MH6StdvxrfVdBOiAdh/OgkCCW7NuIgbKxzGz
         0vI3zbkrHuXy6StpSPUYQj0i4kAmbsrk7NiFuei1kGvbAN22NM34vomrc83j5p5ERHs6
         +BhA==
X-Forwarded-Encrypted: i=1; AJvYcCVbMKR3nOjl+pbvaFip1ibxTYLLTb33N+xqYnyOcHoF8IfwuWNz9XWnz/D1RKB9nOD3VjjRx9596g==@kvack.org
X-Gm-Message-State: AOJu0YxcKoQbUthTI2e596ezpJxyCsGMON3fXaXreWCiRU8M5JyHHsBX
	S2JvEch9HJ5fxDgBQAC8EJs//ZcjupNj5rvpLfzwUS9TlAemFdF6kFcXIxT2X59k94UVChKvVus
	YTSxBFSuIIRZrV+dXQ3NSdEIpXDyB1CA=
X-Gm-Gg: ASbGncsWSvE3BzcBjT4Wf8qBdsQxtJ2v1o7fo1QIb6lFKC5QFybHTqqHl1JJupXxA9K
	wRWv+GXl20NA+/8MwVl5eXRnbpMRU9dBEz4vAHF1GUCebb1Msih9KNilXlbtzvbBV6VGKp/6xds
	OGBcR4NRyxY2PPFvSiG5ArBgt51hDuwELmz1wTrcORBzK7yfIIRdllv8dYh54Nk3nNDlewGWkjC
	fOfWop9
X-Google-Smtp-Source: AGHT+IEDxOEhug5hAKaoFRD60f715RVpOz3j3GIYEQmZZCl+PN792xxfVmyqR8cZcVtXVUn2rZBzgNmHAva7CXKAXjw=
X-Received: by 2002:a05:651c:41c5:10b0:365:4fd1:a15b with SMTP id
 38308e7fff4ca-36f7ff189f4mr1625801fa.7.1758762863690; Wed, 24 Sep 2025
 18:14:23 -0700 (PDT)
MIME-Version: 1.0
References: <20250922032915.3924368-1-zhaoyang.huang@unisoc.com>
 <aNGQ66CD9F82BFP-@infradead.org> <CAGWkznGf1eN-iszG21jGNq13C9yz8S0PW03hLc40Gjhn6LRp0Q@mail.gmail.com>
 <31091c95-1d0c-4e5a-a53b-929529bf0996@acm.org> <CAGWkznGv3jwTLW2nkBds9NrUeNQ1GHK=2kijDotH=DN762PyEQ@mail.gmail.com>
 <CAFj5m9K4yv4wkX2bhXSOf141dY9O96WdNfjMMYXCOoyM_Fdndg@mail.gmail.com>
In-Reply-To: <CAFj5m9K4yv4wkX2bhXSOf141dY9O96WdNfjMMYXCOoyM_Fdndg@mail.gmail.com>
From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Date: Thu, 25 Sep 2025 09:14:12 +0800
X-Gm-Features: AS18NWBK4dJcK_-7IGtI0VoZd54sZXtNSb7uUlofZ2Iu7nxMDq9z6uDViCFW05A
Message-ID: <CAGWkznFe4W0M4NE_ZjiSC6+28tHqJoah6dmP+X1aP6oCCTTe2Q@mail.gmail.com>
Subject: Re: [RFC PATCH] driver: loop: introduce synchronized read for loop driver
To: Ming Lei <ming.lei@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Suren Baghdasaryan <surenb@google.com>, Todd Kjos <tkjos@android.com>, 
	Christoph Hellwig <hch@infradead.org>, "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, 
	Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, steve.kang@unisoc.com, 
	Minchan Kim <minchan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C09DC14000B
X-Stat-Signature: w4xsyu1fkcz6r631xfq3hdeb1owacju1
X-Rspam-User: 
X-HE-Tag: 1758762865-753975
X-HE-Meta: U2FsdGVkX1+0dVxLRJwsBwLv13Ng6b2Aofe02+F95jje+1DvpNXEXbUfveKEy9QJj9rYw38rWeNaMSsunhYPtExL8vYQVXLzkK770uI6spI9OqyU/1wwLsD37nVTEdLrYNOIbnlp+5urqVdNo2hD1Tat83fDucx2t0ufvn4s+UL8xqyfHD4kqeRBCyHUAn1XZ449iSRPCmff/u4Dtb6vjDD2+RtOXCWcKIOOvFEEZduRm7HqFByIU52nlQG1AB2GkqtAZG8JvvrM6gExeiCTPqa6gfuGI8ssBW8MRPNzp0567ZDe2fdZFBQaZew0gG4BdEvY5qORh3RbvL2s8K4oyPHd4HVesrWq68P29lQD6e4TRm8qTqp5LK2Z9Y/epa3H8v4Dd74QhFJRWNr2kjbrRBfra+/hryXxVCm75GOud9AZ71HsYbdbX1YbdRYkc2oVhak/7xT95je5QaQxg/8IXnK5/fXCfBCXilzi/JOJjqdFTyKaQDqlXT6E5mIKYzow7cv8eJh7XfcrKlDxDxEmCp8/H9n7IYmik6f4CHAFaDFyWWhAn0jT3vpYVCQjOS4rNJTUdECrEMCnkjCsrmu6G+DurZ1rL/KgvgWqTNabUiWF2pP1A3ZavHmpcaba/MqOd17wHZOFPo2sdvuBxvdz8MCcHGQ8VeSmmcMqDyRSf3Sozwi4w/OEg0oJK/anHCviMhXcjmVC5s3FM4CtGoy5kWnjsRgyU9X8a/WJ5tKLXA5BSlnPGPLv73ghzq5Wud+nA6w5MJUvtUbIKf1AioKR+5qUHC/Y14ZS2OZX4ShGzrT8arKIC+wvG23pxlhOL2vLFku4NppQqMST7AxaH4c9zuxON89P/7BNmlD55/cJtd9P5gL8jkCFM0WpuDpYnGkbhcnUbjcHOpvLJTv6dSY6xH7asycanWrqEB3pgd9GPomFLi7HDqqTJn/pFJK9BgOZYbCGaGSTkftyeSXHy+y
 k329Zwd4
 FWrDRluyKh9/gQOaT9xQwYlxX+3U7H+oMTWcAwfm8tyA4Ly5zh1awTQ0fyLCmMajp5jRciSYu4WXzYTpkg3SwmY0CXScRdPhVe8GXmuP7X7b4qvVxspLwcd2HYWOJdn4m1hK5gH1WzHcUCchgcoyXOb4QhrQ1LOmVO8fYoV8rP2x+cxQ84oRCTjK7Oy7cEZhbCl9i6GFZJXRjah6b2Vh5LyBPuTUYr8BvM4ck0BRxZ9xvVRJyfOoijGDvcdkjhMktxsyDEl6x/HxJmsTB9Te/VcA4MIzNmRbSAFb7EuVfWHA/KUJYhPH+imcoUSeYur/KDK8/4lLbYnqkVf47NKt86+sooHhHkkzxi68qlJXAjYCMbQsuNup2LOEVi60qsZxCmsCWZibr5xuZCsqDal0hplRGLwBjOYMTkC1/TcLSNBbjSSd+opgs2YdqjTHEFWCOjlZi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 6:05=E2=80=AFPM Ming Lei <ming.lei@redhat.com> wrot=
e:
>
> On Wed, Sep 24, 2025 at 5:13=E2=80=AFPM Zhaoyang Huang <huangzhaoyang@gma=
il.com> wrote:
> >
> > loop google kernel team. When active_depth of the cgroupv2 is set to
> > 3, the loop device's request I2C will be affected by schedule latency
> > which is introduced by huge numbers of kworker thread corresponding to
> > blkcg for each. What's your opinion on this RFC patch?
>
> There are some issues on this RFC patch:
>
> - current->plug can't be touched by driver, cause there can be request
> from other devices
>
> - you can't sleep in loop_queue_rq()
>
> The following patchset should address your issue, and I can rebase & rese=
nd
> if no one objects.
>
> https://lore.kernel.org/linux-block/20250322012617.354222-1-ming.lei@redh=
at.com/
Thanks for the patch, that is what I want.
>
> Thanks,
>
>
> >
> > On Wed, Sep 24, 2025 at 12:30=E2=80=AFAM Bart Van Assche <bvanassche@ac=
m.org> wrote:
> > >
> > > On 9/22/25 8:50 PM, Zhaoyang Huang wrote:
> > > > Yes, we have tried to solve this case from the above perspective. A=
s
> > > > to the scheduler, packing small tasks to one core(Big core in ARM)
> > > > instead of spreading them is desired for power-saving reasons. To t=
he
> > > > number of kworker threads, it is upon current design which will cre=
ate
> > > > new work for each blkcg. According to ANDROID's current approach, e=
ach
> > > > PID takes one cgroup and correspondingly a kworker thread which
> > > > actually induces this scenario.
> > >
> > > More cgroups means more overhead from cgroup-internal tasks, e.g.
> > > accumulating statistics. How about requesting to the Android core tea=
m
> > > to review the approach of associating one cgroup with each PID? I'm
> > > wondering whether the approach of one cgroup per aggregate profile
> > > (SCHED_SP_BACKGROUND, SCHED_SP_FOREGROUND, ...) would work.
> > >
> > > Thanks,
> > >
> > > Bart.
> >
>

