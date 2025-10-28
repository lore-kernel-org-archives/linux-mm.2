Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B97BCCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 19:54:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68FB78E0003; Tue, 28 Oct 2025 15:54:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 666058E0008; Tue, 28 Oct 2025 15:54:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5819F8E0003; Tue, 28 Oct 2025 15:54:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 46D4B8E0003
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 15:54:36 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D99BAC0570
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 19:54:35 +0000 (UTC)
X-FDA: 84048575310.04.5E0FA6C
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf21.hostedemail.com (Postfix) with ESMTP id 070D41C0013
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 19:54:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BC+55atC;
	spf=pass (imf21.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761681274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rhIcXb4aXV0fENr94KRpkXABN40V5yFAtKxbMD1Jnz8=;
	b=Wt/nyG+d8z4+BN/ZvzV0RqsfKSKKdZoMHdNj6O8DkYweU0AzzqvcvlajaB6+yck0OhxV6P
	Da27YmqKn2ZpRKSIrIKbYlYv1dUhz1hfdDTGoHfWC1AmEzCdhPP3IZh/VRVeaQbDtWZwfp
	TTpK6j+OseSTJcE6zRpk/rCLPh/ejmo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BC+55atC;
	spf=pass (imf21.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761681274; a=rsa-sha256;
	cv=none;
	b=qID3zgeVPIeUEfPtL/MJVyvKaI9bU+HE/ewijCgoFHKqtXxGWEw7nIzbU/OvHEDdUMUS06
	IJTv5WXG6TVm7dmXo1gJSe1+2wTNkfaor+BFFRtQUYBoS6nDigsTgTDKxJqQWZ/uPB0bFF
	9Y2mY6U4oVz7oYA1RF0NZIo7XSRJxBg=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3f99ac9acc4so6014840f8f.3
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 12:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761681272; x=1762286072; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rhIcXb4aXV0fENr94KRpkXABN40V5yFAtKxbMD1Jnz8=;
        b=BC+55atCLpnY5sptf5nvzRq3SJI+8gSDHc7tj3f+axzJcdZqqAopz7HM6XOJyE60qR
         +P6NuTlNezshHECv+fu2p9EVXlyk+g7zpTdCbSfQSA6NaY3n+im7NfnfqlqQgOT5a9dJ
         8/s+TkqR9R/hlFwhUx2m5WzVFNBFT1buRcL7owNWHOOiOLlNefStvQuGY9LZI259QB/8
         jxwz+Ij5ZMJ/lGj09AxFiEbFv6j4dXCGFwbT73NrP/hc86sZry03ylOUP9ynNyWaN8zq
         5LvMzG6E0pvsr6j+r0iE6vo7ea1nMd9Bgup442PHSvCjMj6R0OUZ+S2uxb4EnHfzoxgl
         VbuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761681272; x=1762286072;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rhIcXb4aXV0fENr94KRpkXABN40V5yFAtKxbMD1Jnz8=;
        b=OICaD5GEC2+XYV3JDWqf2+bW+i2Y+QT6m2H17dhKQSVhn7iEBBm4JVdlzcVn/hFpho
         VGX61wfZYJodOGsFAAXwd06UKIhk2jadEJNwSs660Pn0yzIB8go8oiEv21eruwyc8XvV
         y+vLTdfIEbWukqCn4/flKjdRKvweyqmj/cvI3PZgt3OkGBuxP8IoPpiTPDysjUjgkoeP
         JYQbOPwx0fsaYw8BkPaGgMoSmTk/eDPx422QA8CAz5YDyIHL9UrSiqEDmLD9qj1O4BSE
         ee+SlP7rP6WlTtCzkh+f3y9IA/litvUQeSF4iziCmZq3Sn2xpsfYPpyg+f4N6xhJssr4
         Z1og==
X-Gm-Message-State: AOJu0YyNMi2rsiVZ/Ogy/VGeEg4fLfcL+7yXhtEyDQl58sGyXA48jmpI
	wqmvFE+C+IyIWy352OA1YrevIY9E5MrUWAgAbm++WugehTBU4oJFoQxEQ0nWM5JASao0jPuLYIn
	GyZOUcVrpiYBTZ4ba226SlIEbpUU/osc=
X-Gm-Gg: ASbGncvsz9WOSsLKAXai1gej3iBB/Ly7z70r41w3XfcHbwSgmJJNdkHfeF6+6Ae3wm9
	Wd8N0NaCNSEYVjv4ENOuhNjNz+jFNsnY8SBWR4H5VFrnA3Wj4S7raMudmlon/CtOSv8wlupJkj7
	Aa6nd9+pbVanhQDd0mwnYXqnyL34Jl1rR1z+SOQYP8Pi/mSFRynXsNUz55rTbZf7KboUhdpQeo9
	uKalQJPZAIPRwjjHOGlBWQWR9Yd3VHAHYvpxhij4QQluwHiuALT1BfmHnfgbKlDVCHM
X-Google-Smtp-Source: AGHT+IFoRx51YEZZ6cHKTr6GcjXFeOAYt/mqxBE/0xMI+0BSA8VH00NtCVOAwJRO+jfmNlf08oKEAl28VKZI42aCF7c=
X-Received: by 2002:a05:6000:1867:b0:3e8:9e32:38f8 with SMTP id
 ffacd0b85a97d-429aef7b0a7mr252123f8f.14.1761681272125; Tue, 28 Oct 2025
 12:54:32 -0700 (PDT)
MIME-Version: 1.0
References: <20251028034308.929550-1-bhe@redhat.com> <20251028034308.929550-2-bhe@redhat.com>
In-Reply-To: <20251028034308.929550-2-bhe@redhat.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 28 Oct 2025 12:54:20 -0700
X-Gm-Features: AWmQ_bmTS3xzv_KgixISSS3LNzmf1rY6tRw5qgG1hb5HXxYOgTaAo9qwond_zlY
Message-ID: <CAKEwX=MdGJ6t1w46cMfcXaq0SO23K3P=ubZWSjDZ=woWSvcVDA@mail.gmail.com>
Subject: Re: [PATCH v5 mm-new 1/2] mm/swap: do not choose swap device
 according to numa node
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	youngjun.park@lge.com, kasong@tencent.com, baohua@kernel.org, 
	shikemeng@huaweicloud.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: onmx8rnbbsdihz4u3cfb4gmqc16ip48n
X-Rspamd-Queue-Id: 070D41C0013
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761681273-281184
X-HE-Meta: U2FsdGVkX1/DhsCwjfX+fzoq+bi3rf62uY9E5CDFsWyZeW9dNuJW7BhjmoC065y2fTNnF5cJUMt/Sex8wuW3qPFhNxQhYnHkEkw0Ib++Zf7RB2qK1Yf3782BE6iO5UPoZoY+2AKqAYY0uZIjePSDZeKyGRAy8fjBNGNYL6gP9IQMkHkwz22961JYYB0Srqktsj3uXwPRrCoaQOjsXdKTWg7HiOXVopQut3gtNrTqjY4Fj5FJsQ//b460FhW9X3PiXzuP4jPy7i9/8JOVx9bi5MFT9+BrWcBeH1tWqZs5cc/aV7bbF4JG/i/vx4RrZ0OiSuDbDgJDYIPEtaAgcWM4/LZwLuCZm9A3fqXrouCfGTkpHW/snE3VaAMV9Gaf+Rb+kYUuQnFaf+RhHvti8GR47yPJgrUJgP4Ow3SHhStPdcYX1ncHBNvJfAxY6O+MguHOjD4d4LILytJcFpr4il5RWk/3BGlowT60WotNeSBswnWhHumRnnh4I8Vh84V1zX4utY5tueExscTflQyC3oLkqtzS3/ZbEnuBwTSgtUI12p+CpSqhfW5+5sibqrlDW4vInhOG42YAmEFt0cNn4VKJT6sWxB3NjWMrAtZurGyBlykq3UlOJe0QSKCK45oaIHB32MQOu5N2pJCE+DMqugo+E4j/WlSmzQ7fDUsWAPpVScU0nEFZah4Ne55WqVR5b/i/VPQROATNePKjYHWEKg1gEyUILlLvPTk+Fc2aLietmONyht0naMldtRE9/i2toD8tghfr6NI6Nw96M1sVY305M2coZt7W/TvnU+klJVw8UfnUaP9kr1Cgnutkt8s+Em6C+MTg1GPjdjLtQdwkIvyLNR1CAKy4ne60bmuTErdw03huFVHU7CHr3lWm2pZo4JDWDQbY6xzr2JzupoyX1qMI9C4k8JQfCjU3JZEcQZbOJy9AUinxiWzrDqRFHKIyg7CMAGxIjpHPXoLbXeGYehk
 ClMI7ZRl
 hmeDzP3Y6p5oLZhsoBlLjmMIcU+XEEM98xWFY5E04DQeFVFIMV48/+ZRp4vLifwuXDZAdh+68N6c94gkLaDpyYXmHebxijDP9DWsWpQpoP0F7Yq6XIBvFHOIuD3bhMF817CXBa8QWX58NstlFl9Debkq8bEHu8WQJtfaW7zQJHj6nuQlxnsENYLljPqD0ItgsnGfwYou1NyM4s/1Z4TGBbHqq/i2k4jNnRAE+wFtboFXbegTiCb856yaWxX94InMFy5GyPEHCmAcJBHAP6rxEgSbc7AyrwBWi1pFzkWdVWWlmBKr2LRK6g+yH5uQAtZbJHhqjZe7NKWzT6HfwGAT2oRSUK7nuYAXVg+E8gcnNclNaZSfqO79CyvRUwzmu95oiKAnjNHLx/GGiE6H+nnFpCH50i3ttvsSgDTTFtY5GZJzc5tw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 8:43=E2=80=AFPM Baoquan He <bhe@redhat.com> wrote:
>
> This reverts commit a2468cc9bfdf ("swap: choose swap device according
> to numa node").
>
> After this patch, the behaviour will change back to pre-commit
> a2468cc9bfdf. Means the priority will be set from -1 then downwards by
> default, and when swapping, it will exhault swap device one by one
> according to priority from high to low. This is preparation work for
> later change.
>
> [root@hp-dl385g10-03 ~]# swapon
> NAME       TYPE      SIZE   USED PRIO
> /dev/zram0 partition  16G    16G   -1
> /dev/zram1 partition  16G 966.2M   -2
> /dev/zram2 partition  16G     0B   -3
> /dev/zram3 partition  16G     0B   -4
>
> Suggested-by: Chris Li <chrisl@kernel.org>
> Acked-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Baoquan He <bhe@redhat.com>

LGTM.
Acked-by: Nhat Pham <nphamcs@gmail.com>

