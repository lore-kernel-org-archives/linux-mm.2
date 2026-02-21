Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02BF1C61DCB
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 09:07:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A70C6B0005; Sat, 21 Feb 2026 04:07:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3547A6B0089; Sat, 21 Feb 2026 04:07:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22C776B008A; Sat, 21 Feb 2026 04:07:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0DEFD6B0005
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 04:07:45 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9871E1603FF
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 09:07:44 +0000 (UTC)
X-FDA: 84467886048.28.E0BEB1E
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf24.hostedemail.com (Postfix) with ESMTP id A48FD180008
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 09:07:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Jpua80SR;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771664862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7mpDa+Cf0rkXthtuWh2Ox5sMJPbVs/hniYk2Xcoitzc=;
	b=Hwxb+ffZyXReTBCPUX4KMbqVQ8HqCBixIzI23xTqnGkus21kj+HjiR9TgqWDqFtf7NoU0e
	fqj8F44cGYRhRG/zYXur79JnANSn2j/u5bPpIwg4wiXYGuxW9YpTakPaldkknmkekWsVXs
	MW6LX77WUaTL9NS/mMYwJmBn6qgv2nA=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Jpua80SR;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771664862; a=rsa-sha256;
	cv=pass;
	b=gnCPx0krhA5tiCChUi4z9UreOxSyxlp5OG6DwfGqRcgHQZwtmQQgmgilN8Laee3xozHrU5
	9Wf+BeUzDXR2YqKVG9Aiebd5AV60uIx4iyOPmb2XcJ9TVEx/k1wQn6tHfRxuKWyeLVFVvs
	B2IHqWx6i136PZ7+yc5MYICHN2U19V0=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-65bfe9c585cso4584412a12.0
        for <linux-mm@kvack.org>; Sat, 21 Feb 2026 01:07:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771664861; cv=none;
        d=google.com; s=arc-20240605;
        b=bofEZ8pHRflbGlSnb4Id5S6/3q/OfraOMQV8KgGBBdsspeSwwAT07IHgeRqL2nlmP+
         Y8RJU9xmqyartMzaPHi1ZiUcHecwcGI3D3KPqSBj81RckJPr0iHy8Ct8SV8IqCXh5lIM
         KqLryGG4e/qrjp3AqpUp7qPVgw3+fZIU0sV1fJnFr9aYv0ZfLocw/oZOXRCUyt/QSrDv
         L56InEY4HrDb+voeGWxKQx+9wP5UmYrU/jQEQ9XRKaNr4IQ1MTX69d4ujLYnrFQILWnT
         eISYiFiL1iaT0JulyiECrP+xEbnHh+jqq/vFVrfz2y2aWRX3XpS68p2Hz4/GjP72tdy1
         /YWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7mpDa+Cf0rkXthtuWh2Ox5sMJPbVs/hniYk2Xcoitzc=;
        fh=KGzgL1pCvBrGK7x8LkyKOAFJ45bgTBc6bMw1QtN/EBY=;
        b=XxPARVrtZippkMNqFxEJyeNvCmUTDkD2tMSTluPEOM40d9qkOmHRGcLiABTdP/j+hn
         gpSxQr5klR8UZuex1iO38O58xR80Mo7dxxFaNGADF03ulskGZ+r0uuhc+yDxwcPAzZ8Y
         sDeRXFKia9xakVgpyMSrr9lts59Kt1obbEuzJke26t08c5LbTMSqsXW4u30J0Y6Rf9QI
         jvuOeDWrq0JKpwEirpzM4B29MgdNPYgDlSvDU0Ejc5PYCFts8+DNCDiGGRRNd1ENlFp7
         4lL6XYOe4AHqd3ZuYPM3E0AlJ+LfTzQeJ/qBBgY0gtO2cp7AThqwkiS2unnmNh6mg5aw
         ULJQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771664861; x=1772269661; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7mpDa+Cf0rkXthtuWh2Ox5sMJPbVs/hniYk2Xcoitzc=;
        b=Jpua80SRPyBz/iLhMyy+QZ2UaUs9US+A1hgy943nlk4OezZfZJZcRmzdb7qolFEWFr
         kXb26i4Cwj45m23txhKTBfFQC2J7sUYXmYAFt2oIFfsJM69ncgIzEBesi2Z7shiMggn8
         CwF1SQT2jLH9Y5KH3ZRzEHwfKGN0PkYn4QxoQokof7czZsqVLZw2DdgRBJ4a0Zx1Tlmi
         BCEPaFiMKYZBwUcYXxMFWxBjkHH2YQEHM/lpT4ODnn71q+KJ+FLyNxfoSkE5/GU6NiDQ
         h/AeFM8Bvso70hgdKQ5ttCcyQNB85qZvx6Zx6+4r5h49c5YpEYh+A3p0KLDJMXVHo6oo
         +e+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771664861; x=1772269661;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7mpDa+Cf0rkXthtuWh2Ox5sMJPbVs/hniYk2Xcoitzc=;
        b=V7q8ehF69gfOpmQ8iNXkiK93xkIutbp8kj6YrCoGe+PpgbKLf8bqMdGasOnI45I7a2
         acCFSdch78OEIIHsR63L8581UV2KriwsNuPEHwPoMnAjDAuCILG8Cq5oku7Uyb06dkrE
         kndAa6mydpymizMze+Fp0Qfwb/oj/aU0GBBsOxsmQZjquqIqzqiidkIAurpCOJBMA4kD
         IpV/+rinK3911fpIe5i4QYkevfWf8qV0WO/MlsPmNjWfFPtVyCR/Sj5hqil0jHDxA2lh
         p1p9eyvx5i4vaLehzTdgM7KYNuhFLJ9A4iK5Mw0MXkx62B+NwT2MBBrRb2T2IfVWSLb8
         knVw==
X-Gm-Message-State: AOJu0Yw+Iz4IXznYffebQ54DqSvy9rCOg/nr/4gGZqNORILz5keq+UmZ
	kxeq/uRfjX6XxVjtzOb0LwZPl2lyjWhhWlKIhj95kncQUVt3KCXysC7x/Knq+2OT1vJOjoPey2X
	4Q8ygWQQixvFu0/GbgJDR5zMr0O0AZeE=
X-Gm-Gg: AZuq6aK5x21sRX20c/itWEEbkqlH4fV48i7hLLlNXLqreO1nuRlUivOic3FDofgie3q
	3I9t4kgg4EZ77GYRudBkLrhmgQk1yjGcb0rm3pGpYQNUyYyyX5M9J5rYOn62dpVWMRfNe/PCFAA
	dGEnj5Ew6c8tkKYRRDBhzoL1HFAIAo2Zlwdze9LwbutSWjwJTfDjFGmyz9j4sycVPmfF1dVMaeD
	VSmEMlmfQUr36aLH0lwL/vbifqOuSBdbs05g+aex0VtyUknyou6R3cbP6es0OQ5gfvz7fm1IJhP
	V7oeAIQGpaEuMNb0o2RpDbSZfG5urS6/A2kF4s+B
X-Received: by 2002:a17:907:3d12:b0:b86:ecfe:b3d with SMTP id
 a640c23a62f3a-b9081b22197mr153494466b.43.1771664859427; Sat, 21 Feb 2026
 01:07:39 -0800 (PST)
MIME-Version: 1.0
References: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com> <CAGsJ_4xF5sK8H1RsqRNoi7DfGBtThASsozY30gq_kdRLaYgaTw@mail.gmail.com>
In-Reply-To: <CAGsJ_4xF5sK8H1RsqRNoi7DfGBtThASsozY30gq_kdRLaYgaTw@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 21 Feb 2026 17:07:03 +0800
X-Gm-Features: AaiRm50ZxftWTS5gtnKtLyAzl5fZtzb6QE6tzQJ7BId14uLxR96r9FuZkjUn9z4
Message-ID: <CAMgjq7CXgGxhtU3XJYnxVQ8fFYtNZBN3uF4FgqbBVV75ohOhtg@mail.gmail.com>
Subject: Re: [PATCH RFC 00/15] mm, swap: swap table phase IV with dynamic
 ghost swapfile
To: Barry Song <21cnbao@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins <hughd@google.com>, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: A48FD180008
X-Rspamd-Server: rspam02
X-Stat-Signature: 7ob6b1p4chyud6yacwacs7u6dar5uywj
X-HE-Tag: 1771664862-84819
X-HE-Meta: U2FsdGVkX19AbXvDhqwHXuSGGxbszHsFrbpX0GYIaFCWKZa2M8onDLyTW8AkwUil1z855BcFIhrVJVz6KIUmowZmmDI0WHj+5ITCZGjuEaQ+33mfYJ8jNcqvAi83c3+WtNDjWe5wuuVm7CWi8Q7oGTHUXRV6aXrVgu/ohXe1Qjr9S7OABPOykeWKflte3vSEFumMiJVbrTr9sMjKUY/4wDiI9f9Lw1o2xVP2tTL4bqFtAmJ5MuolvRKQRvB9fk+VdsyDTLus/7UCdsE4TYEmd8fUbaNjLJJFs6zNQ15SRNNiugIgxYPIIO22uYYxZprGfYY6ELWbHKEAg6w1xWjiM/LYqXLXyeTW5nwq5RBE6EQZQhtkmfMDJ6E/qbJRI1yPiEngr4kLhlmTyIcuSvY4B5Ymfx1tXHWgp4Je2vVHlf6VWiDaMRLvvNcDbDFbFnGPb3s3PhORYZmgpWlSWIOwaVHLLvou8/Yi6KmdAG6IbSqr0YniEeQD3WVfGqA+fcjTTIbhASS22qc0n/UmTameMtqrVeiIqz0FFYWkdRwhun8IOCh8cB6hpE6DU1w70qO0WFbsLbo55sPwcNzqpOVC+fJ+78oDlV1g2ZSi37FE/5tX8zeOofEhiEL0xC4bPYi6BCM3o48JTCgz7FmhmGaSfgawC8r5a05awYI46diPDALxiO00surE4O83W7ammHgtB5SaNAs1tsjbrtUNlczCDZkuqSIQipyZC9HuVqjNe6+2Oo8O0WG4CRLOk0/yfpOOi2L2A6JDBXu3vQjzzS+BWUEX6608+FPmmcT+Y7QfuN7TbvRLj0lzSMoofNFKW/3BRRaaWYIslkg+yqqqKz8gigdWeBoZWM2qpE/4iJfhjzeNKselOupVwupaUWlhF2yjU/O+sfmrDCMpxFiyRlTBDTe4xftUZO3+C5WtnQMg0YDMI0GmArK8IebmFp39f3JHG7/WgjsoaUOhA9OFSML
 l0L7jRw3
 ybeTF/ve9tMp0DJFtXIgruFE1A5jZ6SDPf98Iky67GZIXsVEZwCRVlM047h86349N6N3y+Qaj7eAtiwpxjqO0HuOd7Dj3ZxTCc/TWZ8zOLaWkFNoYEzm6lKdHTaOPS1UHtSd0Uqy1iRTNwtJlgcJDX33hb7oyKmGhDtX7EKBX+7Z8mPLtmcxQumXI/bM66Ri5aDMEzZMlupB08KNgTEARf3zH8YtlkO2nO4qSM+HEYa2dwKJsP7XDjPQ++2C6RcJGdU6TwZ8si8XKl6Ktluw9AdHZmdwSh7GPVWqVx68GIVfJKBQ+rjM5UjIlOJxlYf29sCUTbaZTUJRo8mM6HsFq4HyYmjUBDTQtobIjeiEHBIfPXOPosUHNelZkGOz8E5zeAjL1SEmAYBsl28b7yJqHYjO752ACzPUnmRJ8/Glq+9w3yTf6cGib20u/U4c/pkpZi5ah/+oQiK6hwgxHgrKYd3vvZNiNEWA7YNPbVIZUVvO/DetIbCLR8jcoWEzk5nQ4zQ87
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Feb 21, 2026 at 4:16=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Fri, Feb 20, 2026 at 7:42=E2=80=AFAM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
>
> To be honest, I really dislike the name "ghost." I would
> prefer something that reflects its actual functionality.
> "Ghost" does not describe what it does and feels rather
> arbitrary.

Hi Barry,

That can be easily changed by "search and replace", I just kept the
name since patch 13 is directly from Chris and I just didn't change
it.

>
> I suggest retiring the name "ghost" and replacing it with
> something more appropriate. "vswap" could be a good option,

That looks good to me too, you can also check the slide from LSFMM
last year page 23 to see how I imaged thing would workout at that
time:
https://drive.google.com/file/d/1_QKlXErUkQ-TXmJJy79fJoLPui9TGK1S/view

The actual layout will be a bit different from that slide, since the
redirect entry will be in the lower devices, the virtual device will
have an extra virtual table to hold its redirect entry. But still I'm
glad that plain swap still has zero overhead so ZRAM or high
performance NVME is still good.

> > Currently, the dynamic ghost files are just reported as ordinary swap f=
iles
> > in /proc/swaps and we can have multiple ones, so users will have a full
> > view of what's going on. This is a very easy-to-change design decision.
> > I'm open to ideas about how we should present this to users. e.g., Hidi=
ng
> > it will make it more "virtual", but I don't think that's a good idea.
>
> Even if it remains visible in /proc/swaps, I would rather
> not represent it as a real file in any filesystem. Putting
> a "ghost" swapfile on something like ext4 seems unnatural.

How do you think about this? Here is the output after this sereis:
# swapon
NAME           TYPE       SIZE USED PRIO
/dev/ghostswap ghost     11.5G 821M   -1
/dev/ram0      partition 1024G 9.9M   -1
/dev/vdb2      partition    2G 112K   -1

Or we can rename it to:
# swapon
NAME           TYPE       SIZE USED PRIO
/dev/xswap     xswap     11.5G 821M   -1
/dev/ram0      partition 1024G 9.9M   -1
/dev/vdb2      partition    2G 112K   -1

swapon /dev/xswap will enable this layer (for now I just hardcoded it
to be 8 times the size of total ram). swapoff /dev/xswap disables it.
We can also change the priority.

We can also hide it.

> > And for easier testing, I added a /dev/ghostswap in this RFC. `swapon
> > /dev/ghostswap` enables that. Without swapon /dev/ghostswap, any existi=
ng
> > users, including ZRAM, won't observe any change.
>
> /dev/ghostswap is assumed to be a virtual block device or
> something similar? If it is a block device, how is its size
> related to si->size?

It's not a real device, just a placeholder to make swapon usable
without any modification for easier testing (some user space
implementation doesn't work well with dummy header). And it has
nothing to do with the si->size.

>
> Looking at [PATCH RFC 14/15] mm, swap: add a special device
> for ghost swap setup, it appears to be a character device.
> This feels very odd to me. I=E2=80=99m not in favor of coupling the
> ghost swapfile with a memdev character device.
> A cdev should be a true character device.

No coupling at all, it's just a place holder so swapon (the syscall)
knows it's a virtual device, which is just an alternative to the dummy
header approach from Chris, so people can test it easier.

The si->size is just a number and any value can be given. I just
haven't decided how we should pass the number to the kernel or just
make it dynamic: e.g. set it to total ram size and increase by 2M
every time a new cluster is used.

