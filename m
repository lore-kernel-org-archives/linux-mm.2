Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66B25CD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 19:58:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 594546B00A5; Fri, 29 May 2026 15:58:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5449E6B00A6; Fri, 29 May 2026 15:58:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 412F06B00A7; Fri, 29 May 2026 15:58:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B86D6B00A5
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:58:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C022D4017C
	for <linux-mm@kvack.org>; Fri, 29 May 2026 19:58:24 +0000 (UTC)
X-FDA: 84821519328.28.FB3C9CA
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf23.hostedemail.com (Postfix) with ESMTP id AFE82140006
	for <linux-mm@kvack.org>; Fri, 29 May 2026 19:58:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LOXDKxF2;
	spf=pass (imf23.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780084702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LfwYj4DA5FPfcIbVqcNLhmYJgj92y6YUeOF+OaLYeaY=;
	b=ziHmfoYDZGOyHtb5PsBoXwmE6r5StLNSvdWk4TqJNthwbFpaXnNXePB1aGu3uD6mQMl7bU
	uaL0wYgmvHR9h02F9AyjShC9WplJ45OySDcp45rBzn9xVvAa+FSkQGmJf9N6OeZGjgZwhl
	Ne2foHzCCSUxUJClnuGqHjNTtpZuP3A=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LOXDKxF2;
	spf=pass (imf23.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780084702; a=rsa-sha256;
	cv=pass;
	b=tGKIvyEUZWWj8achjB/NETId2JE6LUpIMVY3Md/FHmY/aZsQUkM/ikOrin3EdL5uIhX8QG
	82TNDpXEdsmKfxJTuVHHXPP8L84AhLwOsgnbRmAldyEnetKMcGp8nBSbxTFE2SJXuJbA97
	rFhWoo2vXrNqBpYUaW6zTUMIOeUDLBk=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4891c00e7aeso96676475e9.2
        for <linux-mm@kvack.org>; Fri, 29 May 2026 12:58:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780084701; cv=none;
        d=google.com; s=arc-20240605;
        b=OsHMpCvqo2BIPhEHox7lkjTr5jGQ/C0CG3NJOk1+bAK4YtftZAgfOtgHLoLfmSIfIN
         hTlQHxeLT5HgB+UL80KULePqrjmoJOSi4zOxgunJDWDlV4L959s1K//D4L0yAbND+7XO
         wwkZ8X4jQAtOiZp0IuBJQBzXdNwzlg/8ArmvLSg9Xq+D1itNtV9SDqpZ0Lo3NtC/hfKS
         n0ti4TaM4IBrQNWLLxagdR0ug+EogZ7KrqGJAOEA+xfU80o9w6O9d1owss8gsdH1ibs2
         Ga26S0ZcQqU6Pf1wjiGvCNYiRQV3ZpiyOH815K/ssTrAF1qtZ0mQ6Th/CVryUTHxXVVQ
         mUEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LfwYj4DA5FPfcIbVqcNLhmYJgj92y6YUeOF+OaLYeaY=;
        fh=zN7l6Rx5M0/NyYPg5IK2TSmw2Zhl7JGD8XV6CnJ6zoc=;
        b=I66eDEQFg3Y9Yn28D5xZl0TkqMH7XACOrTvs0g+q+IlN3yEQWemlc3yVnpkPIHPabN
         45x8VuYlI/lFxq9s2yakmTRDTZ2kOqsCNsgAZrjp7O0BBMnvngsb3CgkY0Ae7OvUFopg
         6G4qvpBFe6GBgyztLQAGZZ5MH28ORywF4ELLOIG6+PKL5irPSuRrrx7LX3lcaD9/FL2D
         esGpbRqYHtfKWMff5IYO8QZ1bvXGECdZvdlK9VOTAq6KBcD+/qpK931pryySYmLwmy/X
         S2ljrmrX66xmoGEHCCOjjF0TQ5xdcAzix0IJwswWHvefsROYJzxGts/tDn8gqG+hsMfp
         tWAQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780084701; x=1780689501; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LfwYj4DA5FPfcIbVqcNLhmYJgj92y6YUeOF+OaLYeaY=;
        b=LOXDKxF2Jd4ebI094NQ+4KafBtU/V2UJXw+IcZdqEUmHetWM7Zo8lRkmb/qSlO1U+3
         xU3rUw8nDlLy4DeQVWUzcNpbNcNEB12ElE/l41IMk2InhhPvbmPNl3mpi6vWjpPhwC2H
         RPN4Mc6DWg7uKQydpMNO5qi2KbhXnfbWDf4q0Qjw36mTPdWireFZR4QFHLJkWEczFbDx
         YZP9j/cwmiWZqilUv/Dt6TZ4gqfigEDkWUfK98pDTUbPQukeN9i4ZEPD/dqyfRQDig12
         JhbN/5i93GVRivKmwFwfooRkaRJhjPRd8Q2bbi7FS60mm556O9XqakE6Yspxa48tVoin
         anaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780084701; x=1780689501;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LfwYj4DA5FPfcIbVqcNLhmYJgj92y6YUeOF+OaLYeaY=;
        b=c0C87rTN1pV3nsruhQpUncXaigQ5RWMO5dH4Mbm0GFcamsvt2RznyzWWPr6ddY7Rr1
         QhEjTeQK74CKXOs4h1Xwk+a/cUUwJm+cBjzaHx6B60F5oFvgg/Swx6bh/XDNdcrpUuLa
         f1ZivEnWM3rggzxJGypEAWpOIJGaCfvA8fM48Z54rjEaFkUGq93rEgzCX93Avo3nG/0h
         /L3wLGPWCNYkaN4LfwOdxIZxCuh0WP6Kd/NmFLSbr+U/85BpaZIuZGWCuChInTylilbn
         xeH8CYkB6NZ5da9m3MleG9ATxrP8tIMQi88v5KE25SvRl5gjvaato0wSqxx3k9sBWPQK
         ieeg==
X-Forwarded-Encrypted: i=1; AFNElJ+30PLPWS0MOiiZtksF6YuBovfkGOuCfO5lSRX2ijbgTROgq2IT/kG76kHSQuGJYWtFU5HMAkuGUQ==@kvack.org
X-Gm-Message-State: AOJu0Yw50ZgOFaJs4GpMVToVLWU75AP29zQuo8Vuw268bSEkv80qDo61
	bqSe4KLLplcM2bfOwHCoiG0sq+lJZTTdaaSxC97pOwGSNn6QMGHMteKVbB3zJuNmeRWSZHvXKs7
	gSQ84xa/Am5bHi0KSfbiaf55hM9WYUNQ=
X-Gm-Gg: Acq92OF/uBm4izHlOcdI3hpv2j1PH55rkLYN6hvbFcVxzjVxpMLNWPYyR7FiDT0mZpR
	PYEIN91JwZNbbXCg4wKcJNN09ddfi8O2JvVMd0YTsdKWSVQvt8hAKJbuO1qoFFyjxZcHYYA2UfD
	jYkpUdhzCoDdo7Eyzlc+CaLXLeHke1jkitu7n5eFyrt1mdyY5qLqXjxFCQ7VDBqYUdo4jKd1UCI
	R854Ri2HUPJneFlVWHFEBkw4NfoVnb8ABcT0MpcR3mAAeyXzXowCs0cvAQM5R1G8k7TL8cTw0EQ
	/T2RenTUjy5NU1xBby2cNI+B/tjfmGTlbWdoRwjaH0gawBD0D32tcZgpyGgt
X-Received: by 2002:a05:600c:1d86:b0:48e:60a3:220a with SMTP id
 5b1f17b1804b1-490a28aa789mr19945345e9.0.1780084701135; Fri, 29 May 2026
 12:58:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260526114601.67041-1-jiahao.kernel@gmail.com> <20260526114601.67041-3-jiahao.kernel@gmail.com>
In-Reply-To: <20260526114601.67041-3-jiahao.kernel@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 29 May 2026 12:58:09 -0700
X-Gm-Features: AVHnY4KgMD945lA_grdRhWAHXr8MpUc0KE7VWOqQOVSVohEoWbBZtrIU7fMWjKc
Message-ID: <CAKEwX=MQe_KFZe2vBXQYh0aa-x+E8AzNwmyjJGJk4tDoS9ML3A@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] mm/zswap: Implement proactive writeback
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, yosry@kernel.org, mkoutny@suse.com, 
	chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 8nqn5fzwux35edmc35aokw5dtfmqonsm
X-Rspamd-Queue-Id: AFE82140006
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780084702-67902
X-HE-Meta: U2FsdGVkX18fUMYX9UCT5WkIO1LCMBrpUsP0T3+z0uw3/qxI9wRlYoVJ7iyqkXo1J3fDKU6MsIzFgqNklI0NVh2XxLC2PlFcVEQ9N9JE3CtK13wXzW2iAu8f0P73+cuiJ8wcpPhJpn5XrCKiZN+Q9tQ9GQv6F9gH5Qvhsw613pZ5ZaRX92Du4t6V2SP4LslJRhBWsfSofUy3PRJXLdTom7kCvjdbtGKy0Wcd2y/5ZXxFGsISZ87DoyeGzuhX7ePUGYR4nuNjdgGqib/XAuYol5tiEIbfjxwGLUyhbP/i6IqNTUpfCX63iWUa1ZWvwXgoiq8DUCRYdHGydvcRAn2hIQ2D99LKk8gmyvbufhPWti+IlJTpcE8XC26OJclzPzF9Bu/GejEIdQWBXA59E25bYwXY5pzGy8YkrlFbIHkW5f809U/rfhfxZkU0/2+rRncQGBs5grtMSa2b3fEtpp0RUbQTsrplu7LryG2odltndSt/vPbSOteq/oSqkJznsbkCGQ8rGDXZKciLMEY0I+ow5Vm53ScfCPh7LyYtB7aLldkRi3UvB68eBfOCmg6uBk3KzIqE8QN3QrCt3LB/CtbMgugBTHe/xc20fZuM+sjpwSzzDT84a0Xc0XYC/lkSJ5+sI0b0hfL/DKkvZ2CQn1xV4vMj1PjxKh0hcWorsZ/1mPKnlNlY4PPEOVMYSQwKT77i91ByP2OCfiqEw6LBTueJ06XPgVHbM0smskWti+yU9moYDZwTQ3p3tK0htbTY91PwrMnCBj99HKjHydD9MnxFde2crcS1JKYK7kaW3XnE4ZH2kPv8UJntRiZeSlyet0XDpANg4K6av+0F0JdTBoTnBP4GcGB9cH1SV3jHB/aWmYQmM0EyNx/ebaZRRX3FdAb5+5EXx8xArMv/AYEkgLN6sxyOVGFA+Xi58UeON44tu3nK0jGqNxhopDSQyiUnV1JbRIlhLmq7cBT2jfyHXdL
 hCveV82o
 XwkVcYlXMzhvid8GEmJzvCwHehJDynGdjZoQ2XMGH4hdMrenw7GEdmBGKqB3DEyn3qLREPOfctQBqW3iEI6qSvD4trJcodHpDFRwXkmPRqvVRZ7lQzSN8TRUlpQCKlF9QSIbiwf+/i19/a2c5tS3KIaPgr4cyOcwxMdMuFCEmm8gdePKj99ksFj78N5x2Ss1WUjOKO/r+dlKvBeAguGlwvMsyz1ti4TyIwhmfzteLp6A+QTeZ940Vz8XQD2utt8rxj+7O/ObjdpYyD23R9lqss3wGNM/LW3mlmL+02BLdDfYT9ikCF4tDDPvzjKYAtrJm0Ap4UYele2/VqGcuQLO+caD8ZV11I59l/4LPjb/OS/EojtbsgOk2f5s0VqwdDZXiZdWjbyJ40hIv4SmUeSb8Tdkcke4re594ThAS0wG82E065m8AcpOsyuA682Evv+rinZa8uY5yyTn8SqHmHJyT/417EnChUbsd9AygnEi3Mrnkw+lRRGeoB/B5AGwX2tOpUl/9nY8bA7nKcSj73186rmbHQzv7h3nDU47d6iszWHGu8BA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 4:46=E2=80=AFAM Hao Jia <jiahao.kernel@gmail.com> w=
rote:
>
> From: Hao Jia <jiahao1@lixiang.com>
>
> Zswap currently writes back pages to backing swap reactively, triggered
> either by the shrinker or when the pool reaches its size limit. There is
> no mechanism to control the amount of writeback for a specific memory
> cgroup. However, users may want to proactively write back zswap pages,
> e.g., to free up memory for other applications or to prepare for
> memory-intensive workloads.
>
> Introduce a "zswap_writeback_only" key to the memory.reclaim cgroup
> interface. When specified, this key bypasses standard memory reclaim
> and exclusively performs proactive zswap writeback up to the requested
> budget. If omitted, the default reclaim behavior remains unchanged.
>
> Example usage:
>   # Write back 100MB of pages from zswap to the backing swap
>   echo "100M zswap_writeback_only" > memory.reclaim

Hmmm, so this 100MB is the pre-compression size? i.e if this 100 MB
compresses to 25 MB, then you're only freeing 25 MB?

I'm ok-ish with this, but can you document it?

The rest seems solid to me, FWIW. I'll defer to Johannes and Yosry for
opinions on zswap-only proactive reclaim.

