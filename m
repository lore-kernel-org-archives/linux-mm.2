Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36EE9D232C6
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 23:56:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A03866B008A; Thu,  8 Jan 2026 18:56:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C4326B0092; Thu,  8 Jan 2026 18:56:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F67D6B0093; Thu,  8 Jan 2026 18:56:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 834AF6B008A
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 18:56:56 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 23ADC1402B4
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 23:56:56 +0000 (UTC)
X-FDA: 84310459632.14.96CC914
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf13.hostedemail.com (Postfix) with ESMTP id 33CCF20002
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 23:56:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fFZU3emd;
	spf=pass (imf13.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767916614; a=rsa-sha256;
	cv=none;
	b=LVmcKvmF8HywXaTPRK16jUAVgEuMqaKmjSU2G13ZZ1fy+U+kN45lfRnSZrgXgqMpfOzzD5
	cnRjz25wQ36ltAtbmqZISMTFLT0FrODeviCvOq8U6YP7oHwsUg7tHHc4W0wQHERBcSEhGE
	0QKPoFbNr9tf2cIgnfir4UpTmdTZ7kE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fFZU3emd;
	spf=pass (imf13.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767916614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oetB2ZjZly87qGWpok8TVoMCIey7xYuJUMfCqDD2fNY=;
	b=pZ4EvIpMc1GIhXY2RNlwY4xdZfU7Tu+/32ZYAoOiWJKxCa8B+VnAV1Md78lHYqZd89Y+1n
	S47gj8SonszCEiOL+5FGnfZNzizCzvngelEx0Avn55sO3kaNVaZoRtGP4yAPgrMKqA1jOi
	ne77PxnQnAD23a+L51NitOE2BzaX9uI=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-59b6a987346so2679316e87.3
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 15:56:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767916613; x=1768521413; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oetB2ZjZly87qGWpok8TVoMCIey7xYuJUMfCqDD2fNY=;
        b=fFZU3emdfE5V/SA5ZVpEojzcKgMqinYn9P+2ctAfEfggVsRaE0SWhLyPcKjqf9ilaG
         wBVKUDBxOOZc4f78Q77+YIDkZfR4ZEtmhfo3j4vSD94Lcg+vfnTmsPskxFQqZeCjVft7
         +4JytyVg+oHu10dMKcbEEEcKqpZTTmDe6a+/oMDmgbgIB8L8IDvtb5RamyVkRXtUx1cQ
         3wetHtQYc2eM+FJusRKGFZQ6p/CFW+AfgZko8RnkhGbGjKXHpCqgGmI53nJ0zE88wVQB
         N9JqeHeJbOUuyUdJJNmvTRXqpDjS4kk3o3LxoJ3pnwRnxBJNIo1bF2wUfUbOcRx9UpK5
         3TQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767916613; x=1768521413;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oetB2ZjZly87qGWpok8TVoMCIey7xYuJUMfCqDD2fNY=;
        b=ANCGv+/e29qHckDLr7OY5UqG0cWTN5Olq2BMCg3vpgZeN1DKwefafb3Zaz+wAr8ZjM
         SYfoyBHdgRw1NCegbGkL5qkskQkFGIJqszH3novdb1JOUAFDR4L9BgvlGt93EC98TQuv
         goLFCvrhSKVgo0hpgBXp2B0alnR5PTPgPAqARbQitdgTo/NVwXZw5usP6GYgQ/vvxdaL
         40TbdQSIq5XeL5FmL+0jwpJsjPFcDOR6EuXB6XqtufYLWl3G9FVDvMyXEduXGXJjQnZ0
         Yc7arx9rEPMhvbbT4wZMNzkP98738GCEbLWsDHgNKvwLXqGDSk9KB/hF1iXYxhVGb95x
         OvhA==
X-Forwarded-Encrypted: i=1; AJvYcCXTivUI7oLxxrLPczo2bSBrLSjaK/vn5aQaeSZSwld4g73JnOhUAM9rBmy6ZRnBV7dsrxhIRrPU+A==@kvack.org
X-Gm-Message-State: AOJu0YxxvVvhmmINfV2ZRJ3Y2SpvuX4RVn+tgtseMvcO0q+18A9VIgmc
	aoorniG/8nMMfDokkmHoPSvgULKFIJJj8dzQq5MbfEFjm65UizFmmJMevpyZ2q0yj6hX1WL0ncp
	xL9/OkGLE5l/Bc0QyuK8sPQ467lVRVP8=
X-Gm-Gg: AY/fxX6+AI3rsKG+wskmww8MWAKkiM0aIgnGKcrq3e5SzsXV5w7KBuXiq1YBBxqbedj
	Htub0bgvMGMmZmr25feY+g3QtAdAhF0pehbGx72MrBRbWYXU6fyK6UmBWSiPghPCHcW1sgg75hD
	X3H28kEVHs+XluaLsNlrc2M9OFXfRYD8nMu8OGMMGtlFoDsyM1dzzm5Cm+0WcSUfhBVt6rNAYo7
	Sl/2Jq/5x0s6S6MwmcCjXEr5OxxZ1LHTj8yHIE9bUnHsQlur5srSmcgYW8swFIM2nudoQ==
X-Google-Smtp-Source: AGHT+IFP6gxzx4CPGFwxToZxuM2DROL1oBRTahs81L4pZ76zZtEYBWrqyFW5M/PbRCzfXuiYZqxKnCkIdCKnpvz6V+A=
X-Received: by 2002:a05:6512:a88:b0:595:7854:af77 with SMTP id
 2adb3069b0e04-59b6f02b59amr2699853e87.22.1767916612487; Thu, 08 Jan 2026
 15:56:52 -0800 (PST)
MIME-Version: 1.0
References: <20260108093741.212333-1-jianyuew@nvidia.com> <20260108111027.172f19a9a86667e8e0142042@linux-foundation.org>
 <7ia45x9bhg8c.fsf@castle.c.googlers.com>
In-Reply-To: <7ia45x9bhg8c.fsf@castle.c.googlers.com>
From: Jiany Wu <wujianyue000@gmail.com>
Date: Fri, 9 Jan 2026 07:56:40 +0800
X-Gm-Features: AZwV_QiaPNCRA8R_jWlbf3lk669pBieo3LIJ3Cr1QuxRdFzz5FJKFoyFeNJPA_M
Message-ID: <CAJxJ_jioPFeTL3og-5qO+Xu4UE7ohcGUSQuodNSfYuX32Xj=EQ@mail.gmail.com>
Subject: Re: [PATCH] mm: optimize stat output for 11% sys time reduce
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, jianyuew@nvidia.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 33CCF20002
X-Stat-Signature: 1aqyz69zpj8jp7r19cj8k91p76pbnot1
X-Rspam-User: 
X-HE-Tag: 1767916613-76704
X-HE-Meta: U2FsdGVkX19xzjyCUvgrwc2i6ySIZZj1AtL6wLS3DU9L/JYJYXiK3kTiDN3LRNaiwqG3iBcNLcY3HauZMWy5ZlOF0e+jBXLkEnxPyQ1xNVvdXfgwooJJsCQMyKMUZ2bORnjrfdgr43YHJnBNzdnZo3LTh3b8621b/g+mT+XYFt1OOhjcvHEHA941hhF35Jd733oyDX9n7WfVY0XLHeur0B4fnlfuD9W3Vxt9ujp/yRZLNHMHoLrAnKov4m4Riy376pcHmw1XYz3SllM1xg2FVZwRQ/jNCcSjz8ahZLksIQ7SGByQBn8dgfzLHbEjv1xVmiM+EPjP5SLf7AHpNbEUz3Gkw5+wrKHmLYdTYpXnoRi4lzlFJrZ0BBRCbccdR4hzZ1O9S85H/Z/iNh58ygCSW3+bENoGtARHZ7CIcfX7WpTeYQhHF9Oe3V2zX9JuNrJ0qFeCRfi3kzBwggYU8DwyXQ2wyXA6WhqQmK4DJZAScvKGE8pmtI6EYlMEINKCc2f6G2JqdZ89W2fbia7h+HffjJgpU8osQ1P4PhYRBx0pWS300V4eTJ68SjORWg3hkU/Z2n46+/y93ddcF5HT82IgslyM9jj9MpFD460leFYcxsMGnICZxTFGqqOPWS+iD9sVdRoNXvsqCm2V7bAyNDEwWEc5Z44cBzn4QMz1My/ln1BzmgVuCaM7zy585ud6gg5IT9C6R/BzaNe+s5pgG20jwFAMMD80/ksUZIeE+1RVv+B2PNjV87ewKUekTZNISvsThX2Ti2tTh0rDFXnVvJD8i2t+xOlXuQC/KLmeB5537wulgTpRKIeDEbCRu3pe+6zPqGoFdJlt47px7ukLvlp7JRL/uO8pMcOgQfSkeS56w60Fu5DRywLP7RO/ja7Vn32uTHW/3NJ1ZcZwBtaRAiygUOGOW7Z+vQw4WUtQf8aPwTrvZYUCJ5hOeh9333NOYGY7vnmRnAGWNPljG1UFb3t
 XJTqfyYt
 0aTXKbLf/V+LoSBg5cxAfu6csRX7upHSktJCpD8mPurnT9HihORCHV0omw9Qdd5O7on+3jHCN57eVnQlCGApbGaHa2wHHLkOqlucYMYEE6r3CfyxNSCb6vSdn638UsTWL8Jt5SlAIzIYHz80DZTm4b3CXntIDW8qBPHZTXSwPdssfS4oNdcL1i+aIm2V6GAHDYviLMwosbmfgO0gwtvp61h5jsW9wTHoCY/LU13g15OHbMCwXLd++jJq+n8RrqL4vY2NfUXrrPIjuOPR1yN3KJZZaM58p93GcjAmicItfx+DEn7Etwl4iPwdzSgMxXFXmPRUSPSk82e8ztVHG3MhaTFX2m63ENjCQof5OhqcIbPrJBQF5xXhLpx4iD9oVF5MTZKJXCyapFkaBvPudy63079+mLHcGjlboVOZ4VCOdClTHQl4jh6cYW7k2niCWwyOEf9Ywka0FBsjpelOcKazNcSmI+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Just checked the BPF kfuncs patch, nice, speed so much, I think better
use bpf to read, instead of normal read.
The workload normally is read about every 2s, but there could be
several different services needing polling this.
Yes, previously the indent was hacked manually:)

On Fri, Jan 9, 2026 at 6:50=E2=80=AFAM Roman Gushchin <roman.gushchin@linux=
.dev> wrote:
>
> Andrew Morton <akpm@linux-foundation.org> writes:
>
> > On Thu,  8 Jan 2026 17:37:29 +0800 Jianyue Wu <wujianyue000@gmail.com> =
wrote:
> >
> >> From: Jianyue Wu <wujianyue000@gmail.com>
> >>
> >> Replace seq_printf/seq_buf_printf with lightweight helpers to avoid
> >> printf parsing in memcg stats output.
> >>
> >> Key changes:
> >> - Add memcg_seq_put_name_val() for seq_file "name value\n" formatting
> >> - Add memcg_seq_buf_put_name_val() for seq_buf "name value\n" formatti=
ng
> >> - Update __memory_events_show(), swap_events_show(),
> >>   memory_stat_format(), memory_numa_stat_show(), and related helpers
> >>
> >> Performance:
> >> - 1M reads of memory.stat+memory.numa_stat
> >> - Before: real 0m9.663s, user 0m4.840s, sys 0m4.823s
> >> - After:  real 0m9.051s, user 0m4.775s, sys 0m4.275s (~11.4% sys drop)
> >>
> >> Tests:
> >> - Script:
> >>   for ((i=3D1; i<=3D1000000; i++)); do
> >>       : > /dev/null < /sys/fs/cgroup/memory.stat
> >>       : > /dev/null < /sys/fs/cgroup/memory.numa_stat
> >>   done
> >>
> >
> > I suspect there are workloads which read these files frequently.
> >
> > I'd be interested in learning "how frequently".  Perhaps
> > ascii-through-sysfs simply isn't an appropriate API for this data?
>
> We just got a bpf interface for this data merged, exactly to speed
> things up: commit 99430ab8b804 ("mm: introduce BPF kfuncs to access
> memcg statistics and events") in bpf-next.

