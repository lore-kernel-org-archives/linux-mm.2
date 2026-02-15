Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDCEEEF5871
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 11:19:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 246456B008A; Sun, 15 Feb 2026 06:19:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F3736B008C; Sun, 15 Feb 2026 06:19:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F5C76B0092; Sun, 15 Feb 2026 06:19:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F122B6B008A
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 06:19:11 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9095113BFCA
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 11:19:11 +0000 (UTC)
X-FDA: 84446444502.04.EAD59FE
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf26.hostedemail.com (Postfix) with ESMTP id 98E84140003
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 11:19:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FNKD2myB;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771154349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ox2CDuqzI57uLB8CBlCfkrupp4w7Jrt88SB/Nkc1CBc=;
	b=65SWdpn7w7DxwgHWJ2rD2WDpp0heBRIxLkBlMvy8DLWajgyI4H04UbA7ZiHyYXrlGc6wzV
	jpQu+goELsFtKeGXOrnZBW/h2xmAedP/VI1+QvygFowpuWLIF6k/LfiqSW173qwqgZKe2o
	/2e9zrTCytpf8apBgqH2j3fUOYHZMwE=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FNKD2myB;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771154349; a=rsa-sha256;
	cv=pass;
	b=ONtRxSLh5BlBsqGvQqzfic4bTg2vJT6ZeepCFLzfE1IudnvcEIl6sYg0jtWRxH7dzykSrF
	PPj+T/UvWC0cNBSqnCiQX8JlBp6x6ogEnk5E7Uzh0q0sFVqpoLlnLc4iEOsgdniiUzDPGu
	VKSPdDthnukHl/LV0htwGIgY9zF10zI=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-65a3c6f587cso3038762a12.1
        for <linux-mm@kvack.org>; Sun, 15 Feb 2026 03:19:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771154348; cv=none;
        d=google.com; s=arc-20240605;
        b=XbYgU/fDHN8Q2KAx7EQFWZNCmhqF6n0l7qPJNTgfZfYIN4bIZrvxgOqC7r5ktxc19A
         7cHiA25Lh02XJhRCLmZeBpOjwwEV+eMNA/o2yzeSNo1/mADqLS/CraLueXJlS6DjP7iM
         v90EOLY0RlLBlyZRiWA2J2vkV38nMJiCRIK+DYthh8r7KpiwWjh0f+FDoqycT4x9rHeB
         o0vm+NPp5SEeA/MtzlVxMBArNZn+h5u2TnZcHzbF+UkxD6eMoGS70X07yQUpxll8TcNF
         eG/t4otjB7YAXIeynmS5sXY7wJ4M4sZn9k7Rnr8R8AONRUiLVQBpJ3n5CxvTT1bXWNWf
         FtOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ox2CDuqzI57uLB8CBlCfkrupp4w7Jrt88SB/Nkc1CBc=;
        fh=oVIQGIsPvQkzGnuKj8NF+tIbeBHcwQRgyjYfsSE8chc=;
        b=JiQBMtMfHlNjYE3yqj5xaSjyWcEruQrKt3NQht4Ju/Aw/Tyep9iUxVH0+ePMCHM/Ux
         nlRKiyd/SwuCWHvoaPVSq26XF3f9QX5w3k9zrNkbS33GxMHwqd5RrjRLAh2U/62h3cnb
         4utl1dlDUP9rHkjIkhG9TdiHnAj7/lpS1z8r7AAgrUCxrZoU4D9XG8hwCJ3b2ZwJQvMh
         1SviovWIa3zCRSk4QHEEEGpwYT+qE64kNhQUa9cpgieUS46XRAxizNqg2TfMIcfrY7VQ
         sBWh9x5HrC18SFv63YbH4y8MB2W/NtNNW7d4GlTAa0P4E/V/UlbNJSWe48gq1q/L2qbk
         VlYA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771154348; x=1771759148; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ox2CDuqzI57uLB8CBlCfkrupp4w7Jrt88SB/Nkc1CBc=;
        b=FNKD2myBYx0f7lsqnxtrXzNCfLeCDDRyASVzoOTshzTqbc9ucKbzeJGAA0V6kNBZ5r
         kje0e9DjfyAxIdLUskVBU71M7bmaAnc0OnPpcKYZRLfLEdLDLSVyvB136/8NMH5vLWCD
         SW2uzwV95amprSVLgcT8kZlaIecyaBJU9ZCsQKaHgmALjCc83LCtMQYenFTajZlfOPRk
         OQD52WwE8mZxsXwuVuJRL0CzNTyw3peC9hugeG7YPwS2Q7uQDyzuZ2FARkcQq+XOgAMw
         KBmJZYOqnBy2IQLA+a/0v/1kNNzPXBF6JZHJl8IU9LQX1krxZUvNM3Q3uM9ibIXuVGum
         h8/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771154348; x=1771759148;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ox2CDuqzI57uLB8CBlCfkrupp4w7Jrt88SB/Nkc1CBc=;
        b=o17YmP/VhMa/t/NPkb6Xr1P/Nu1S0MPewkGXakhNxxUKC1lpDgYNtkwTEoUcAL9++F
         nmP9MGDB9HdEsb2izyOIy2kjZKYCwWV+aiNWFy3YgNhLqxNSt8IVdM5jVDDmOi5TR/Mz
         Op9KybCC9Rjy4ftAxE47OAAwro+5aUhnfYHmkGqLfaxs5kMJ0m6HxG/tP96KC0P1+l+z
         dwvXmX/zcqO1ofojOnCQSLbm7fcFpxzadtZAEGFtBRDiUVhDwg9yDgpO8lHzCEB/HMe2
         2DebLKB85wfjPeEJY+b+61o9qXuYKOOWAfrnSiOM5WB2VbiXu2ycl4xfjdLuaXT4LQYS
         HCBQ==
X-Gm-Message-State: AOJu0Yxv8qgVGUz1thap36rethTMXPgPaZTXvyks4mdIMCIQw9A/7OWK
	/UDGm9wBR2bQmIzk+mLSX2MfTwhdyxlH8wnYwKWrGELs0RYGKwZADP1b1g3/XfRuq8im5Txe4rj
	FJZc0MehaAv1Z6ZmQvVL9YaPxohO0V8nf1/JuW9F5kQ==
X-Gm-Gg: AZuq6aKqJ8WHqjLALbV4Nm++DzUB3O+q296+4QP4wfoPgr3lLBmtHRAVrubXdghkB3q
	LiHNJ+tZ6V5nRGvLzXCRp/yOsj7/lRSt7vXfC51m5p7QpXkKpxVAoc+rLPhKE6WtStFTvkOrwsz
	sP+y18QbXvVUxWxvXSJVVScL9e4OhuOrrQrpnoC5BW4trhLI1xnANNaYBNxjzxoX5mOfnmya5Wb
	254Yk5niYs5eFPqa6aaaKBQsXs5TRyasX33OUPGFPLrFbNmqPtFXOAIpjA7nH+fluCBBv5bkrJT
	Oin4ZOyCzOcpCrrYQb2qxXPpLNiSIwv7+uNXRT5D
X-Received: by 2002:a17:907:3e0c:b0:b8d:e10d:6f96 with SMTP id
 a640c23a62f3a-b8fb44a6f8amr411119466b.32.1771154347545; Sun, 15 Feb 2026
 03:19:07 -0800 (PST)
MIME-Version: 1.0
References: <20260215-hibernate-perf-v1-0-f55ee9ee67db@tencent.com>
In-Reply-To: <20260215-hibernate-perf-v1-0-f55ee9ee67db@tencent.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 15 Feb 2026 19:18:31 +0800
X-Gm-Features: AaiRm5163H6nvK_79QuEJvHPMlc_6xIM2aw4ipOgiTJHSPUBFTFzHzHk1kEMfrc
Message-ID: <CAMgjq7Dqh4xPFQe1AywHytn6zCRjTS0GBy9FTb4F-AuN66OFiw@mail.gmail.com>
Subject: Re: [PATCH 0/2] mm/swap: hibernate: improve hibernate performance
 with new allocator
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Carsten Grohmann <carstengrohmann@gmx.de>, linux-kernel@vger.kernel.org, 
	"open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 18sag3w5zkmc5qousoaatcnxn5xjiru4
X-Rspamd-Queue-Id: 98E84140003
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771154349-359929
X-HE-Meta: U2FsdGVkX1+Z06LTj7HcWMbg2eFvWe8FCGZ34HKX/PxB9aD60AbdvwW8rg8tENINs2AaCLUvhU4yzCetldI8S7bbALT5zzgSmvbtfgljxyGLHLubgQ4fMEMqAnSg8sawJNkQNXnWPlzq5s76hWS+x6D663MnP/C/7KbJZ2BImUpxbT9BsVDXvJGMC2yzYCinzkqgNoNvewYTR4MhKZjPyh96IEgUrALXBz41tAxlqflWY4W87FPg1ppp4kpWPLvxUtoCzawV9Bwb9rkSnEqv6v0Dh2GKkYI6dw9tufnY1dbE9+ojKfB/ll7ROXoJv0vgJhxDn6dm+hLMZBrTPuuk/vQM/qsUFjanb/0UKNvx8dxYR42WW225K3Yf/kEturDCSI35qM3PjaJmY3683GXqjoNkBrRILB9cNfmtKFMfiROXn5aOpHIK5gZ7vB3p2N21WJxEpAGM3mZHpeFxmJAnGxVakhbt0UDoq5wkLxwDmG2EHeErYKRAO/zOVy6vJW56i3FF/P3i4NOB4BqKc9C3i5Oc329y9gRkM3qSSoztEtrad3lnLjnXgP9RbQS/gbnId/w4cLq9o1SYwsJNtd/W4LY3Xw5brATASE3d5xIJD7LPS1JQwo6+iPCEVn2rjvxwoZsj2+W/Wpm/bEg9X4GEpxpTJmw69YGwRdsHHNbDBwuZTp4D+fADc+rDb6rJwAnHtG/KrpAzgAvU7rHmi0jWmRIefk0se+7y6RtKS5h9hVcZcBmGk7IbzFTQexQmNPJJZz9mSp3di9VtHhRgPgEtrH52J8Uerb11sQIJJZaw3EQjcdLiE82z41lt0Mh1CFid6h+pkO/RxlxtBW220DR42zq7Q7lhwqjzPA0AjhEjTUuoT11FQ6KvcxJBPJXOMnQ2uWg2hbhUqmUwcoLtelMdN+Dl5cmELMZjBQC7FlxY+wICF9ifVjBYyL55+GDPeY8eBDqxKnzOdkC3g5Wg7v+
 KmxIcA2R
 vlVlWo9JO5pK5ePqC812cI/7W5RwYc/y+kdtnEU8ISMKZoFeHI8byuo8Kh1CCcVgB1oFVybTo8doVDnSrz/QhNdN94xFBQoG9CJJNe/9bJAVIIskoJAbAOF9Y8adoXvQCBVC0a2FF4pMgi0aGVkFuaWAqVT+w5vbLXNkWUiyqzSZOsC4A12anQmL4LmtLmelAAORi/KxGcZTt1Oh+hYBvL6ndrzN//p21e6MD8RweeK9SpwkHJXmSPCCaRwan6f/rhD6Soj5AEcqyYou5POxduXnkhCXf7m9+qxnlnnY6h4mpwzwiC8Y1bntT/qgxfaZW6SciNS1vzGFJDndaqITGWber2Bfig1CS1ilVY/DRw3Swg9yfQsC9mI+HZInNsjnzz3kdRnRgVVi/+EqeekGJwQ3YS8NJpAwkzVo2HLIcUmWWZxLxwPrqSD7w0PA5CdSG6TpD04NJICpj0ByzTCKXPeUndQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 15, 2026 at 6:25=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> The new swap allocator didn't provide a high-performance allocation
> method for hibernate, and just left it using the easy slow path. As a
> result, hibernate performance is quite bad on some devices
>
> Fix it by implementing hibernate support for the fast allocation path.
>
> This regression seems only happen with SSD devices with poor 4k
> performance. I've tested on several different NVME and SSD setups, the
> performance diff is tiny on them, but testing on a Samsung SSD 830
> Series (SATA II, 3.0 Gbps) showed a big difference [1]:
>
> Test result with Samsung SSD 830 Series (SATA II, 3.0 Gbps) thanks
> to Carsten Grohman [1]:
> 6.19:               324 seconds
> After this series:  35 seconds
>
> Test result with SAMSUNG MZ7LH480HAHQ-00005 (SATA 3.2, 6.0 Gb/s):
> Before 0ff67f990bd4: Wrote 2230700 kbytes in 4.47 seconds (499.03 MB/s)
> After 0ff67f990bd4: Wrote 2215472 kbytes in 4.44 seconds (498.98 MB/s)
> After this series: Wrote 2038748 kbytes in 4.04 seconds (504.64 MB/s)
>
> Test result with Memblaze P5910DT0384M00:
> Before 0ff67f990bd4: Wrote 2222772 kbytes in 0.84 seconds (2646.15 MB/s)
> After 0ff67f990bd4: Wrote 2224184 kbytes in 0.90 seconds (2471.31 MB/s)
> After this series: Wrote 1559088 kbytes in 0.55 seconds (2834.70 MB/s)
>
> The performance is almost the same for blazing fast SSDs, but for some
> SSDs, the performance is several times better.
>
> Patch 1 improves the hibernate performance by using the fast path, and
> patch 2 cleans up the code a bit since there are now multiple fast path
> users using similar conventions.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Tested-by: Carsten Grohmann <carstengrohmann@gmx.de>
> Link: https://lore.kernel.org/linux-mm/8b4bdcfa-ce3f-4e23-839f-31367df7c1=
8f@gmx.de/ [1]
> ---
> Kairui Song (2):
>       mm, swap: speed up hibernation allocation and writeout
>       mm, swap: merge common convention and simplify allocation helper
>
>  mm/swapfile.c | 56 ++++++++++++++++++++++++++---------------------------=
---
>  1 file changed, 26 insertions(+), 30 deletions(-)
> ---
> base-commit: 53f061047924205138ad9bc315885255f7cc4944
> change-id: 20260212-hibernate-perf-fb7783b2b252
>
> Best regards,
> --
> Kairui Song <kasong@tencent.com>
>

Patch 1/2 is a wrong patch, sorry about this.

Just resent the series using B4 relay and marking it as V2 to
distinguish from this misformed one, please check that series instead,
thanks!
https://lore.kernel.org/linux-mm/20260215-hibernate-perf-v2-0-cf28c75b04b7@=
tencent.com/

