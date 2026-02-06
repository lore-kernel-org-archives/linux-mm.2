Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB59AEE6B66
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 21:26:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03B6D6B00A1; Fri,  6 Feb 2026 16:26:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2BFB6B00A2; Fri,  6 Feb 2026 16:26:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0C516B00A3; Fri,  6 Feb 2026 16:26:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CBB0C6B00A1
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 16:26:54 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7B54DD5A77
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 21:26:54 +0000 (UTC)
X-FDA: 84415316748.19.1644933
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8423A140003
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 21:26:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="a3U+W/2h";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of maze@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=maze@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770413211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e2vRt91HE57LlxbsBX+S8iZ8+RLwY1B3JoqVasfqz+Y=;
	b=3WruEwp4hqT4dtIYMt6A21Q78cp/U+VCNmSd/ei6geVvsWL9mt2vPSAX98nu0HIYskhxJj
	s6JAh6/cjDk+OvAzy/th86QZZ+3JdvDj82Htr1LxcEfJr6SNdH2MfVXX5lF6CVvAWu9rY3
	S7vONuGdZSxbY9MpZR3aVgeOJHQEqC4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770413211; a=rsa-sha256;
	cv=pass;
	b=0Qmebnp/q2tKMXCviUU7volIEF8zIe0sFnqvPphuYiXZmL7q4kM4bo+eQ6ajHwQVJU/AtG
	g39ipxWfAk1+z/BrVVManG4yWFqkTsA34wjWrqGWTx9JZm9Gyrg72w8c58EI1ahMEPXuTQ
	Z6t+A3B5idpvl8vmqNxo01CuUvcVkU4=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="a3U+W/2h";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of maze@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=maze@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-50299648ae9so21581cf.1
        for <linux-mm@kvack.org>; Fri, 06 Feb 2026 13:26:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770413210; cv=none;
        d=google.com; s=arc-20240605;
        b=LbU4F7agsFn0Czl6SlLPhiVL5WtATizbR3Hp/bKrsjYZ5BL0ViAZkJlpHIzgXNbTf6
         r4jJHAky4+wKkpjwSx8mnilPWhgshAY36cY2f3hGWm01bHTn5LnZEcX7oSHGVMxm6bVr
         RMGPQZaAGQa+sIsKTxHFGsfrwMbx/qTjjhWwCxCk1wLtDjcU2I0LdVMCYXWXCJWc9kiY
         jFBw7dkdD/j3EVe6v+4XJx1xsSTvmilDn07aq8gyHGPFFoOGYlMSBfHLbS/DBcLX6K2c
         ccAgGPG2Fp6gMhEfJNbGdQ17lswxixDPf5ztkbTY8kUNXCsnmq4h7wL0zF0Qeimg4dxh
         pTmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=e2vRt91HE57LlxbsBX+S8iZ8+RLwY1B3JoqVasfqz+Y=;
        fh=MHr+MlxRYlTnjt6URNG18wDhp1IZnmd0sGXioXfXF0U=;
        b=U3EXngfYwVZV3knEY0hJaAk/vg8j2484vTvMcqGbHpNGV6x0xTA/86v+mtr/mY+B9+
         xajE2PFtaxStFGgZ40FU1/pSB0tHBzxyfZskyEc1POLArNyMOTykSleOx8+7in9HjydX
         bmzx3WietexN/i09hEEAAFqDnwDXiu9oQqhvV/IV5u9eTqjBA5E2xPRZL5hg5he4oV22
         FkeJ1B9Rp/ZbFr7rDDeJjI6yVKy+uoZUeOkD0EtNx6GDQg7iHsEH6vYsNQJqpLPrHn9E
         ebXI8oUEL2OBwoPBnYu9SmO19FHnN07gtgj7qPhMatZ0zQxROx+xdVrrgx4OBnSf5MwH
         2W8A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770413210; x=1771018010; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e2vRt91HE57LlxbsBX+S8iZ8+RLwY1B3JoqVasfqz+Y=;
        b=a3U+W/2hHR+61oPPwYmph125Bf9Y8csZxQ5P7L4ijLxY98zt2afZqDWNjmStKVQ0T/
         sXvt4x+g5PziUl+0XzPWJ9RpsUIN91FT1+mm3VV2j0f1lAMG6x1ByQnMMob/w8sC0FMw
         0Rat5vf/n4PCZojLzmuyr9nEZ9v1+eB3w5shVfvWJmoqY4rEAGBltU/9OHZoSzDVT7/5
         r5AkBWmccNBL6li2sWrvv0FLKotSZg5i18z6faLIiuJu1lZUw5AquPzvRXpxnAgAHYkd
         BVdbXTSuk1Kr+Dch314E/bU9YqidavPjI29hRSLwM/8XkfyOAMLmNc5Pp27V0artbjfd
         1FTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770413210; x=1771018010;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=e2vRt91HE57LlxbsBX+S8iZ8+RLwY1B3JoqVasfqz+Y=;
        b=uDeOT+YhOquO8wQEbbyijsTJ35L0btnzkVATl+352pgOOo+LuH/NX/E3wXOsREqZfz
         Yuh/OZV5xDSBSkAE1S+D6cffuXOn90m7dnicSrlnRvDOJBPe9aL2zYXsMvJNJ8jEyC+Y
         4BVZpZ+/4n3Ku9XGmpf6l+af6lEjaXxbJNCea5a98JsaRgJAfrxejuI7S8bhC+v4ld1C
         Qrzu18jF6C3tzJNGw/VkyOuso+z45tl6hhnG1ddC30QNxxNle+nQC7KY4aKj5HlTQbqI
         b95EOLWSWJthVos60M4q4+tHpdr1goxnRFyLKO/0NHQcz+rjx8Jod5d3rWrb4yff7VmQ
         mcLA==
X-Forwarded-Encrypted: i=1; AJvYcCWav+QB5OC5x8szl5VqqQpmqQ79KvUblBnS/sQgDkD9MZkuMXyf/l0fENgQpmPwMP0MVm/aN18gQQ==@kvack.org
X-Gm-Message-State: AOJu0YweJFka27lbbD7DxVW6F3lsaazMyhJIohy3GB3pbm3NPsrhQPrl
	xn5ZtWPTABeRdkjyljRdKtfALymBD6cT0jw53G0RGce83z0QaSpBAiqkqtUwtBb8sCh9z9BiMat
	vfApsR9FZHlCsbA+9NKMLGbppRiDkwm51xUG+OE6k
X-Gm-Gg: AZuq6aKcY9Qgo0/44ne3aUI+ZCcHrOWkiZd+zCykJdwh5w3vBCJrzM5AzPNhCYz8Ht4
	YJt2dzd1HJFtQfrpiAe9lyj2YEjVmpVrTuE5Lkdvrr4yCLMI6Yi5rVQ81Acsk/D54zjNnjruri+
	GZadCyeWn989hjrsXU1ZmrNMDbS0qffEdUSQp0BAslVx1RhEIRw9QZB664rDkAZNsaXciPFmWMh
	Yl0KbVKDoXVT4ISq6D1CmWWaPYvNcbaiBVvIgE3FtuDcJF+4Wrd/0N+cutDjaCOgp5WAJTIF2LV
	1kOs4ZYFwLiL4wPpEXpQx07Ju0X9ZA==
X-Received: by 2002:a05:622a:1b89:b0:4ff:a98b:7fd3 with SMTP id
 d75a77b69052e-50649b6ad07mr2258111cf.2.1770413210149; Fri, 06 Feb 2026
 13:26:50 -0800 (PST)
MIME-Version: 1.0
References: <CANP3RGeuRW53vukDy7WDO3FiVgu34-xVJYkfpm08oLO3odYFrA@mail.gmail.com>
 <202601071226.8DF7C63@keescook> <btracv3snpi6l4b5upqvag6qz3j4d2k7l7qgzj665ft5m7bn22@m3y73eir2tnt>
 <CANP3RGfLXptZp6widUEyvVzicAB=dwcSx3k7MLtQozhO0NuxZw@mail.gmail.com>
 <CANP3RGeaEQipgRvk2FedpN54Rrq=fKdLs3PN4_+DThpeqQmTXA@mail.gmail.com>
 <CANP3RGcNFgLSgKYPjmro2s1Es04Pnhf+4wHpnSwRX4M8bLDW9g@mail.gmail.com>
 <aWFKEDwwihxGIbQA@wieczorr-mobl1.localdomain> <CANP3RGeWLMQEMnC03pUr8=1+e27vma1ggiWGWcpX+PcZ=SsxUg@mail.gmail.com>
 <CANP3RGeHnhufYyc0P2OiKJbXdZjPW41TP=JS6nYk9xGRU8UuKQ@mail.gmail.com> <aYZJ2Ohug6b9Vth0@wieczorr-mobl1.localdomain>
In-Reply-To: <aYZJ2Ohug6b9Vth0@wieczorr-mobl1.localdomain>
From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date: Fri, 6 Feb 2026 13:26:37 -0800
X-Gm-Features: AZwV_QguewADB-2xma46o3PunJjIPEerBNilNQhrGaSGk5f8ofWHwvj9j70yzs8
Message-ID: <CANP3RGerB8-soNb1pBx7TqmOivR7Vp4Q-iqjE5QH0fzHrxEseQ@mail.gmail.com>
Subject: Re: KASAN vs realloc
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Kees Cook <kees@kernel.org>, 
	joonki.min@samsung-slsi.corp-partner.google.com, 
	Andrew Morton <akpm@google.com>, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Marco Elver <elver@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Danilo Krummrich <dakr@kernel.org>, jiayuan.chen@linux.dev, 
	syzbot+997752115a851cb0cf36@syzkaller.appspotmail.com, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, 
	Kernel hackers <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8423A140003
X-Stat-Signature: uhe3d9gf4oqgt9n5qb46axtc7c45ewgg
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770413211-915070
X-HE-Meta: U2FsdGVkX1/uehFIdBm2zORKy/ZBpYPduMIlzNBUeOeWbvsQCD0gVh00uT2cZSeLZuGXiRTMjjJoFKE7VLcg8qcBp+j8dpvYC65LYD6ttArTbJGbQY+Po7rgZ2kBWK1fUcHFm980to4DjbMpTQpmGU3JGut3TkzyEUQ7+5OXn/2Qfr8Gwd7gYBweklWjSfH+EUuH/3Uaf3DloZnw/PGqbwBonbC5uLcGyAUqBQ5zr1tGOC6iRrFuw7T1IN5f8kRKzS3dzXQ1Zxwmb0oJAk30rM54zFos/VtDk5nJOjck64xGmO8SnZqXl/GHKfwLMW7jGZSvR8HBY0DQNC6kvDwOqT31Muue8DDLW7NC2mrXPcBqNG53Ez7e4+u/Rh5Iw5UoG9MwV7T3M/CNSNJRAVA99BFd377QW4IzT8vqv3NmNj227CjHBZODZCBcdVDIdAJgv/zZ7ADlMRlpIwxylsJb+xk8u3P9zgEpRgKmaKCfGTelmznD20ukLpbmu4YORivBpLP6C2vlqBBQx1zm+QDNbp8A1xcZszSYcst7cia6LZgPdwgTYJQiGLGkcBd6ZJjDPfQQlR4ZhDwBaOcMzaDCLQWbqEmrnA9vZiVOXHwaxdGVYnqKGhT5sNV1Gd5/kLhNCWGzz6VJuGuuRuUoIGeA6Q2Q997yx3/lsIOF25u1bWm1WOUa/cue+iGjiZV1xBNlWGFd3MaXhApVSG2OQ4zH61Yitz/w+kLYVFLLkS8m0tXnNkz+bJCHoNhX1v4dA1lgKAEW+lkKlTm1Kq6fw4cq4vm8UiNFq1z2EhhPIky1LLxvlxP3vxT77SoKZjkCLdS6fC/gsKV0ca4S7d9sXoxcBSYvwIehbPkgi1Lwy+5fSmX9R4BVYKbY6e5q+ZxArSz2lxJA39IRJ7t+ROdYVpeXWBLfu1qmIXTEgq9yt7P6pD9j3ePeaSxK9cDrE5+rl5u1PxRAvErSpGyfHyAeRIN
 hkscvHli
 TbrA2QP8STe0U7s0ff51SvIwYkjjENkRZQMsiklRZdHAZAgm5X828+V5q40K5NOOIi9cHLd0z5p/5HN/Hp2AyR0b9/jrWAePTbTx1GMjdFs8LNBb4ewgL/wHbwW+TskXhXo3UzMPFnZXlJex4zMxFjknkAzf2zG2DIYmAEvO019aBpcCoF8UJZUYdjr0o36MDpLQm4Z+wyGsblMcAHGNwk2iQTrqFD1JqLnOTxyDtuy7cqkXo4YhCF5+bNMZIhgP15VTBfk3by35zrnHC8pOauYd4LctD3j1AV/cHDH76cbQPLIwUVGo1Gc+zMeTsCbMiyhm0MzsaUTRc7JPa10UuJzLDjGFf7FJiZNTEFzTOUIPqvipnPrcq/RkZfRGPeamXnhwD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000019, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 6, 2026 at 12:14=E2=80=AFPM Maciej Wieczor-Retman
<m.wieczorretman@pm.me> wrote:
>
> From what I see kasan_poison_last_granule() is called through:
>
> __kasan_vrealloc()
> --> __kasan_unpoison_vmalloc()
> ----> kasan_unpoison()
> ------> kasan_poison_last_granule()
>
> and the arguments are "addr + old_size" and "new_size - old_size" so it l=
ooks
> okay I think.

Cool, thanks for checking.

> On 2026-02-06 at 11:07:12 -0800, Maciej =C5=BBenczykowski wrote:
> >While looking at:
> >  https://android-review.git.corp.google.com/c/kernel/common/+/3939998
> >  UPSTREAM: mm/kasan: fix KASAN poisoning in vrealloc()
> >
> >I noticed a lack of symmetry - I'm not sure if it's a problem or not...
> >but I'd have expected kasan_poison_last_granule() to be called
> >regardless of whether the size shrunk or increased.
> >
> >It is of course possible this is handled automatically by
> >__kasan_unpoison_vmalloc() - I haven't traced that deep,
> >in general these functions seem to have a terrible api surface full of
> >razors... with hidden assumptions about what is and is not granule
> >aligned.
>
> --
> Kind regards
> Maciej Wiecz=C3=B3r-Retman
>

--
Maciej =C5=BBenczykowski, Kernel Networking Developer @ Google

