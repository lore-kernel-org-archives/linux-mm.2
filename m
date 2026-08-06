Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 824E7C5AC7A
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 22:47:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5C806B007B; Thu,  6 Aug 2026 18:47:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0D816B0092; Thu,  6 Aug 2026 18:47:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A23AF6B0093; Thu,  6 Aug 2026 18:47:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 740236B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:47:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DB75F1A05AD
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 22:47:24 +0000 (UTC)
X-FDA: 85072332408.14.D48D72C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 133818000C
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 22:47:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FINkf+SH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786056443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f0JJ2dsclzdRsuC9t44MmmtZCwGmLaJNhhASDkwou8w=;
	b=uyLI6jA5iU5KP7XVQ1HY3uzaxV9lEtajxCdLq+w90K7v9k/Sd3Egnl7wQ+QXcPK3ri3LUs
	u+TNwIjT7hv8Cp5clH2qixynM/9kxkpCAbVzVroWxWOQEVuwnprEEGiZw1ekq7eFg+fYop
	NacdRnDzNdXHxw53l3jjsEkRU7FO87A=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FINkf+SH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786056443;
	b=nPaQa/NmrcgDWcD8vd3LaCZsmDK11celMCGXQfmSFz1RW8U1GoW8ERonbpfYGET2uRGR/A
	rZogHEL4mQ0QI+AL9qZ0bDX7oyFVqNY+gFpJ//zYYNh0uvkI+X07KYvZ4lmNXnIOOpFnOh
	k858zZfg1FZ0LZEyZENiCaqWwdotUV4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 803E06004E
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 22:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C201F00A3A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 22:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786056442;
	bh=f0JJ2dsclzdRsuC9t44MmmtZCwGmLaJNhhASDkwou8w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=FINkf+SHOMJoxm0DTYc7A6uZ+sLnGO6XT42riUP3n/beEyUj0W1g1vpDHW5QxHTr1
	 U/Pi0loQ0q+hu9p/JEXi2NwiBekKq9p1MujfVSL7iN/vZL0EckXDrzCuZIVGPDyRHB
	 JYLBuoXfIqxTatXrj2eEDdfrbWx2EikaO5vCPhHaXtoao7OYygAWZ+fY+paurLh3Yo
	 y8I1IZRMWfzu3+MsUJNlWkc0JKHnuJR9PiAMarE2qcQJNM8VCHrD5xnWaxrfQWfbr/
	 yo037kLJf6aA3B7JcsMyUCsZg8LqD5DiaTFIGLcnJtS7TuIGhrKB9SP8ysErcwW/7j
	 HZhEC2Qy0MtGA==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c2055f5a993so178190766b.2
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 15:47:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rq43A/3VfzGAdiLFKZ3apm0spP93nV260CQavXedFT4P+HyjjkReJgN42I7NxcnsGjQL3fe8krVvg==@kvack.org
X-Gm-Message-State: AOJu0YzuQghFb5Pfq0tLeqbCLq6LVd1SQAOu7Ng9kAwr4K+iklt/7wqd
	9A0dgg/0yv0OQkAFmHRjN/jgzyFWLSMKhiBOYJS6XUOHV+ULmRtoxG21uyT4ynmNP5jjmXCmTxh
	A/CvgLqv4Njer3fqNG9gx+evROTY+0Pg=
X-Received: by 2002:a17:907:9807:b0:c1c:2fd3:bbd7 with SMTP id
 a640c23a62f3a-c2039d15c0fmr873226266b.26.1786056441200; Thu, 06 Aug 2026
 15:47:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260806070943.95542-1-jiahao.kernel@gmail.com> <20260806154113.fd52c4c6207c6945dc77cf79@linux-foundation.org>
In-Reply-To: <20260806154113.fd52c4c6207c6945dc77cf79@linux-foundation.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 6 Aug 2026 15:47:09 -0700
X-Gmail-Original-Message-ID: <CAO9r8zN4p_AWFU=ckb7QaEMnm0QUep6mgdai2ad20Zfu=VQ=kA@mail.gmail.com>
X-Gm-Features: AUfX_mwIfYMougPH_EihoPHrXv58QsraN27bZSAQ7q9-N_iv3q8NwbNfos0cO4k
Message-ID: <CAO9r8zN4p_AWFU=ckb7QaEMnm0QUep6mgdai2ad20Zfu=VQ=kA@mail.gmail.com>
Subject: Re: [PATCH v4 0/2] mm/zswap: Fixes and improves the zswap shrink
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Jia <jiahao.kernel@gmail.com>, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 133818000C
X-Stat-Signature: dhst35m8yxper1om8q7g13yen4ok5hn3
X-Rspam-User: 
X-HE-Tag: 1786056442-548540
X-HE-Meta: U2FsdGVkX1+3Ci1tnXRJz4S8bTnq3zJoGbUlLLK2uJwdSAjanDMaawZLeWEsRgWAu2uilq/13SpjX6yHPPxOcajv/pmAzbjsf80yQZ5I7/7hi4Z2wsBiyn8lxGOzYoMdO8+UgmGhLxQks2/bNSroJLF+6VYJnxFKXN/71lGwPJ7rhvXA4xqg7tSOpa50lxfrLZNTDjvxrKJi/gYm7UDzxgcHVCKee7Hc/eatKf2lE6ncqVPfdSwbIoKZ/XKuAiPpmZ4VK1I5UbnimsvFjQZsybIt2pNJ8GA38XjofxIYH/8O8xAL/eMMUiK4NtyMW/MmDJq0pFTwBGG1NeyefgzT0+oGt72pKHzblcwiZYFf4rkUFre8s+0VTUO2WthaUR6l7GT39TTwL5SjTKZaAO6k6ZlOTY3IvofizoYfmBLLugYXJxLn/BuwtI3R6iYnCyd+JqFwRXNGCwGYpH35cbfWUutP8ZZyaF6GcBb6GcF/oVCXS+x+j8Avc0hy1Ydaieon7a+JoMHpslk0WxqwtxhP2Gri++ckYrntU2HW4jdLsXxwbJPlKjGFOk8qHEWl0kKM0qMGhPwWY/rLYH1RdNzLWM2bVqu9YwibbrhKoRXo2PH8HB7KO0XMqeGrYiZpj+Tkfnyiikn3bYihNPm40wYdPLOawJE1lB6A7Qme1h80v6koYXuM2OiAPpylZE/2kcaLuSAg8yXTCdznrGD+GtqGW4IqhsW6FxFSXwIngttMQ2AxQKo2eawV/mcGKKMLwztYYDrAfr4oHx2qHRjMc+GQMdtLpKUb/gdlKlxHTd4fhb8Iv/eOgg8TL6PkPdY005SxGTTkRQong6w5zVWr08ZnkScV/pQZ3CQ6GWCCQsvI7gOpDcQq+ok/MSSxIjRycqoDIkS0XiNwco3uPQn2PxWRe62KPjZnRKfCwNavd8jLyuYFNZkPoFeoCUBfUSkpnksvyrqe7+OrnRjGVKYF5mp
 EfY9Mn2f
 pwM9N4XFe9hQv8A2lOAfXtOtXDgO++n0wXHrJNISlXMgFVMGrviToQF5JNe0vLXpWygeA48gpgfs4FkSDOE/a9sBYLRiSzqfbbuarDX6gdcFQJ0bn+jJxDSLOSOkjhXuRrmMfBC0ZnHnV0NIX5zEJc753e/FbF9OgFm23lG/+ABnTv0Glb5L1myN6PknI2imcZTFFRuBj56/mXHSleHhIu6UvbmMLdZUlq6QdKowxvF/5/oI/s0OoX2wv4l+CSUHq9tx65F0rQZAfBh7btdVhByGZMEqZ7gcPHqocjuvtaxTdewko33iIisZEThdqATigMa5g/qVPw2NVusHj7+zafdbzVntzAdSpmrzWOc5Z9R2oIH9rV2w40XeCey/c5fdkxYUt2L4+4WTxZcTWcUyumbZNG1wwY5we7RoLMJgUfUntwUBJ97TSDO4x1wFfbIzsmPuJz11tzO3hmbl9MDFMjC2yBg5UHzcJV4UMNXLFsthTDYGIlXczIeQ6Elq3jupabzHa/3YsgsGYjv2hJ+fTi3eyy4XoxRKnQQABPXDDEx5c6TLwDVqtaHLqxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 6, 2026 at 3:41=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Thu,  6 Aug 2026 15:09:41 +0800 Hao Jia <jiahao.kernel@gmail.com> wrot=
e:
>
> > From: Hao Jia <jiahao1@lixiang.com>
> >
> > This series fixes and improves the zswap global shrinker (shrink_worker=
()):
> > Patch 1: Fix missing global shrinker when memory cgroup is disabled.
> > Patch 2: Extend shrink_memcg() to support batch writeback and thereby i=
mproving
> >          the writeback efficiency in the shrink_worker() and zswap_stor=
e() paths.
>
> Thanks.
>
> Why is a -stable backport proposed for [1/2]?  Its changelog should
> describe the effect of the bug upon our users so that others can
> understand why this was requested.

It's a potential performance regression for people using zswap without
memcg that was introduced by the commit in "Fixes".

>
> AI review suggests there may be an issue in [1/2].  Please check?
>         https://sashiko.dev/#/patchset/20260806070943.95542-1-jiahao.kern=
el@gmail.com

Same thing from previous versions, shouldn't be a problem in practice.

