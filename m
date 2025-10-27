Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C583CCF9EA
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 22:46:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 553E5800A3; Mon, 27 Oct 2025 18:46:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52CA28009B; Mon, 27 Oct 2025 18:46:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44199800A3; Mon, 27 Oct 2025 18:46:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 30A008009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 18:46:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C57AE12A000
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 22:46:25 +0000 (UTC)
X-FDA: 84045379530.24.816F827
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf25.hostedemail.com (Postfix) with ESMTP id C9586A0006
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 22:46:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FgOvM+8D;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761605183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YbNF9xBLgvPcEJ73q19bteNh3qQ4EWHWmqaSpEAAHPI=;
	b=t6gbh9sAJsH9Gf9/YvGQyB4X4nzs2BAc/k7N7tqxlCBnvMrrke8DG6Mo9uhYKTp7B115NY
	Swyl1QTn0RQwTiRAtecnP0ssjosCvJDGfnmTQfAaO1iQN7QpMwwDts6hldccap6tBJD9PJ
	rtXV5wSzEzD5E2UnGIsfmcmTGqR2Q1c=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FgOvM+8D;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761605183; a=rsa-sha256;
	cv=none;
	b=EX8SieADLZo8xbYGEii/kOi7si2LnMaiVOZJ4qsK8GyjdOOanksvD1EBh/cjSX1TyLO26X
	mzuaDWx0AKn1kiXckw0Jb1xm3TiIjnIthfMKBBQFMqsK2JchEMNLeP0+/UTEwMM4RrYXGV
	TSZ+M3yF5GSI4G8JuETwA+k6OkawOzs=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-475dbc3c9efso19996145e9.0
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 15:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761605182; x=1762209982; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YbNF9xBLgvPcEJ73q19bteNh3qQ4EWHWmqaSpEAAHPI=;
        b=FgOvM+8Dx9QPLO1bnYxY69b+pM4FdHHW7F6tGOxV1lZ0h+MN8exvLgBFWK8fAfEqFJ
         O/uMSmvN+INNAAYye9p2dVprwKxKJ7k5UffxiAKvVIJHfY38ehIgAYbz3Cmh59DZIAYN
         20KU9nxxfKrxHIDTianqDwteE6HYYJfU+RC82372K9Bx8QbJhcAKHqhkA9E1BKLdzg3g
         po6G1SiIuzLWBUyo3h5Dnc490+d/w75vapT8QiAjLBRPS3GEPFqH+SaXrUlqGzYqXUY0
         dR7qJMoSzygs64zqP/kB/RMR+r+YQhINrpncyQ2pa8B1vqgQ+vLtcsm51Jsw5LyK5xab
         AWAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761605182; x=1762209982;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YbNF9xBLgvPcEJ73q19bteNh3qQ4EWHWmqaSpEAAHPI=;
        b=rIBbQRyEEtSGdx+ZcbHbb6FP4iSuOhJbI2sqLKZdqJ2B0hZnYtf8TsP8+sy/joI/JP
         XoSRO2rKLcosVkJbtO+tAPPxjE2g3fHXjnKgljwYwLbb+JdAfDZdB+l7rPswuyCLiyMA
         t6KuzsGWA1XrIsKsyfLjHsoF/L8OfUfVF0/JgkeaHttr4GLUt0nrV+sIvVNMZ21t64oQ
         xxhcmCWT9F1G5InaYGaX6F1+BnulyXR8KjxWTSgdknVsZMWhhGDNWjYVZVlyfbczHtgT
         RA4wpFQpHHR9GhiP1hZMSTj9JE2D6gMgdWxFUYcdM7ZEVVvO6UzBqliqnheizb/Dia9U
         XrzA==
X-Forwarded-Encrypted: i=1; AJvYcCWPJ5S5f8pizIUEKImIrk4AXiWiZKpOUU9HkZLIszj30p8DrmA7NGrGLPFWqrEBhwZsdiBWqCH8JQ==@kvack.org
X-Gm-Message-State: AOJu0YwioqKcz63CkTYn4ITNTX6hYQW8UBNi1BCXEPcEL1zi+2dWGgJS
	d1kmmt36u17cpfT1B/hZ56W8iaqOgwfFEXltSpiHVPBH/j4ceD9llW5kMqdvoWoCeO3m7bP2/7v
	zOYkPuWep+p8hf2it7DHhj7hPb4ZUKaY=
X-Gm-Gg: ASbGncuhskt8YO+HX5AKagFFAjraH9qz85pptVspqf/DEq3bu6Ze5mz5WGtYcd06450
	i62RhU1K+UxYslqghgb0c63L2k00eE8UhUFbM/6Y7GS6uCy5w9KoM/xp/zkqLFUecD19N0NEcuc
	lUS0reNa0dBFLp1KZyHDtLdrrntZJ87/YzUlyeFcHD6ODPjWRzxToniACqjzcfbf2WHD9/jg2wh
	fZcIRBkJl5TtQSh/xuM32dom44UylYaMEKRzDclml63UKZE+3ZivtoWtRQ5009KaUV0Aw==
X-Google-Smtp-Source: AGHT+IEeNWo2bsGLLqGLfQNsY0L6lNVZZ2khSDzRsqsRr6Jo8tC6B0Avoq1yBzRM+ieeQ79ZgiTz+pEgGuOt7PLnUe4=
X-Received: by 2002:a05:600c:46d3:b0:471:1415:b545 with SMTP id
 5b1f17b1804b1-47717def6demr11070845e9.7.1761605181955; Mon, 27 Oct 2025
 15:46:21 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1761439133.git.jinji.z.zhong@gmail.com>
In-Reply-To: <cover.1761439133.git.jinji.z.zhong@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 27 Oct 2025 15:46:10 -0700
X-Gm-Features: AWmQ_bma6lyHlpvPtwTt1egk70m2KnBJDjgat6AjIDzKFfoBCYrn6d-bXve4s8M
Message-ID: <CAKEwX=MqsyWki+DfzePb3SwXWTZ_2tcDV-ONBQu62=otnBXCiQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Introduce per-cgroup compression priority
To: jinji zhong <jinji.z.zhong@gmail.com>
Cc: minchan@kernel.org, senozhatsky@chromium.org, philipp.reisner@linbit.com, 
	lars.ellenberg@linbit.com, christoph.boehmwalder@linbit.com, corbet@lwn.net, 
	tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, axboe@kernel.dk, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	akpm@linux-foundation.org, terrelln@fb.com, dsterba@suse.com, 
	muchun.song@linux.dev, linux-kernel@vger.kernel.org, 
	drbd-dev@lists.linbit.com, linux-doc@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org, zhongjinji@honor.com, 
	liulu.liu@honor.com, feng.han@honor.com, 
	YoungJun Park <youngjun.park@lge.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: C9586A0006
X-Rspamd-Server: rspam03
X-Stat-Signature: kw4n1t5u4fuyaozogj6ry61q7mhkn1co
X-HE-Tag: 1761605183-319862
X-HE-Meta: U2FsdGVkX185Ym85Hsyvrv/aYoX5PXhpRxuNP6hLSUqKuKxSr4IjEL0yxvdzn02x0A4eyP9DKWVZVO7OuIV86kzusFhyxru27t8w12tt4y/gcBdYkeXXApChyJujR1mnCCMQfv6/Ph1aHP+9QgyMV+IOLeznZV7UATV40ptSjfC765CwiTZ+NWM4CT2Vo0GXuGbq+Gq/SrDlUG4OcCAB7+MAGu2Dj/R9gxz4Ep4LPQPCsjL4C0NVyHtm8zE0FsxKYpQguyoufnB72jkgXeKirdmG4lCnCu6e6qEYDG57m6YPXxA1EyohTSO7+JY93R0/i+nFzlO4cLYatgeXjaDY+IxrSeTPiExZq1HLByxICcLErfJxYdSd4b4fTCMQsJUBt1m8tDPpZ86/ynUOjsb95h4sNOPA35X8b10IItkZlKun7BFBYr7FNXNzInODcA08SMiI1sQ0Us/+0jG4v8WAX7TuKGydknfT5nGK9JwzfahNnn+GbEAo86yAkWVSI5B36F280nLrQdRu2svy6+a6A6XZkTI8HmGIbFvr8Aci9U8IFAncyXjXDC0pBI1MXkmVN7OmP5baXQaBFmcDR61W0831fhw0DhDepJPffSMG8RzVYRDJkLAZaNrdSHd82ox9a1uUyBwanIAmIu7FgMSc6XQJkTDLRgoL9Hcc08Of1561znvS8lriZkozbhzAEOCmgnlXpIniFFQNvnxr/Pd1hHRiwza+vYBotSr4RZ6qj2+Ndyvl8wYMOliU3XetI8Re7A95FHmHrn/RrmvoH9kyvWNTFkXUs6ATcIvnrWrFuXAMRWMsBz7kvaDDKNMnGvZVHkXuEGBavOxG6gL9mVSBnHNY5rN7nG4XO6odJGik4ksIyUiePDp0/cR/sWLft8zSldHFRuG5yBowg7HyNcpYmUGlzSpGRpPFflAjBHDKXFCvcSYF8jPJiz63Jy7Pcdrb7c85vNnaygRBpfWPLjh
 UILY0S25
 3XxjpZYTXgNkrEG3jh0h3q5V95n8SAYCfJM9GJvH45DHmvgr++VH85k8uKZyGI1kmWRHHkrQNWONWkR+qtK4WY1ht+wQ/zADyJGme+v8MsJtq6g/TXHVQvbC9nfQ0LybrcQT4chuphFP3bPgYt2mdA21OpCC1uEfDYdoKbKAq8T69X5BYU1H35rCIp6zaTjIaQP6qMvfqp8R9Aq/wS75d5odFxRfT4wPzhzKOiKL15lzCIHhLmrJQuhGiCh+5JWNpr1zhRuI8io6ICd5uHMoCtQ7r/up16OV/cXraX0blUHSxIcqnKpGGa+cZv0ceyVPWCJHlRpyJzZEob5rJPwph8u0zRT6PhXz4ptB0WRz6dQLlPuZqxL0IisegX726yywl9HxvaPbdDc3UCPcspO7KrtgHR++3FbnQ51xteGAfSQdoLaR7asjWsT49BGzYk9ID+VrJg1l6cmD2qONzGO8uAde2zk73dEhhjxikY6pKe3NnQrfQk0Bo+VQsfQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 25, 2025 at 6:53=E2=80=AFPM jinji zhong <jinji.z.zhong@gmail.co=
m> wrote:
>
> Hello everyone,
>
> On Android, different applications have varying tolerance for
> decompression latency. Applications with higher tolerance for
> decompression latency are better suited for algorithms like ZSTD,
> which provides high compression ratio but slower decompression
> speed. Conversely, applications with lower tolerance for
> decompression latency can use algorithms like LZ4 or LZO that
> offer faster decompression but lower compression ratios. For example,
> lightweight applications (with few anonymous pages) or applications
> without foreground UI typically have higher tolerance for decompression
> latency.
>
> Similarly, in memory allocation slow paths or under high CPU
> pressure, using algorithms with faster compression speeds might
> be more appropriate.
>
> This patch introduces a per-cgroup compression priority mechanism,
> where different compression priorities map to different algorithms.
> This allows administrators to select appropriate compression
> algorithms on a per-cgroup basis.
>
> Currently, this patch is experimental and we would greatly
> appreciate community feedback. I'm uncertain whether obtaining
> compression priority via get_cgroup_comp_priority in zram is the
> best approach. While this implementation is convenient, it seems
> somewhat unusual. Perhaps the next step should be to pass
> compression priority through page->private.

I agree with TJ's and Shakeel's take on this. You (or some other
zram/zswap users) will have to present a more compelling case for the
necessity of a hierarchical structure for this property :)

The semantics itself is unclear to me - what's the default? How should
inheritance be defined? What happens when cgroups are killed etc?

As a side note, seems like there is a proposal for swap device
priority (+ Youngjun)

https://lore.kernel.org/all/20250716202006.3640584-1-youngjun.park@lge.com/

Is this something you can leverage?

Another alternative is to make this zram-internal, i.e add knobs to
zram sysfs, or extend the recomp parameter. I'll defer to zram
maintainers and users to comment on this :)

