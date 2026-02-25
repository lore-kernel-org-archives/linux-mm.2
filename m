Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C78D7FD45E2
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 19:34:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FA436B0088; Wed, 25 Feb 2026 14:34:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A89D6B0089; Wed, 25 Feb 2026 14:34:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECBFA6B008A; Wed, 25 Feb 2026 14:34:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D94876B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:34:29 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 82220160732
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:34:29 +0000 (UTC)
X-FDA: 84483980658.17.9E593E3
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7C43540008
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:34:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TdWi6uJT;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf01.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772048067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Si8z437tvGEJio1pwGBHAqSsYapkryN7R/ntn+VLWw=;
	b=HBP/5Hp2sXJq12QfwVWKbwghVSQLsC2xgct1dpni7KhBFwZ1ruizzVE/csu1h57/fFm4Ko
	2FnefN3psvO+SMJGuo1WmIpzytBY1UoYC4RAUAALc98kx2mJgQyH2qTS/sL0bfouCegaVN
	/WgPmIWMXTbliNN676g6WIK+lyGXcDM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772048067; a=rsa-sha256;
	cv=pass;
	b=ieUrTd+Ifip+s9MUkZ1ktZjC4YrjNswoFwTKKTGsy+vLRLF/ZRLlD+sXzxCUizmD2WoxrV
	oLUQGcfQw2ufXJajIhVttWJ5e/c/0DzS8euH53F+YX+KtJ+MYGPy4Y2q0jvlPTSpDrjXxc
	xfiE0pOpZmSvQ9VIhNXYNdIgztWOrII=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TdWi6uJT;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf01.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-48371d2f661so10475e9.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:34:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772048066; cv=none;
        d=google.com; s=arc-20240605;
        b=GI1bf6blECkPu88ZfoeYfgO0HtGmPzcjkPW+5V6tfDv85ewhJllwkLJu9BWNqhVC9A
         VQQra+65iVFi1zqcC2K+FsGQmYX+yG3jQNSWVo2eZJJ9eorfR9jZMoSllGQUS1n3YNNw
         hjVHfO2baT1jvzkARABldN1G5oYgRW9FTv0knIN21PKAfu1d0Tcda1n3hTH0gCh45EOT
         WF1dZOK0wIPqYSfPe9INPyXcWDLnVwA6HtKVWQ+qRORRywVbXF73b5aQWPnDQcvxu+1z
         UJlIABLm1Ppc4Aqh+OcfxvPBp9toxg0vs52k93k+SI49x3eVJE2MRs4RkIL827Sbly9N
         ywTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7Si8z437tvGEJio1pwGBHAqSsYapkryN7R/ntn+VLWw=;
        fh=YSMnXsVpmAy8HMrsnPPovE7KaBMfvs4CMr52br3DF+k=;
        b=AWQsqYujHJwvCnWWoRXE+xKDFIHjsw6TH9eN6BSatagPFxq39Sukr2MPV6eeh0T/9i
         BaO1IILK31HLm4FAexbOAMQTvP9Ghw+rLfOlC/WDt9cJNPur3q5bu5j0bFs93ZRH3TNL
         pbX5Rn2qGwxbQjSmRbnJhVYDL5cI0KZ47P5Mq8/ngKdOcsHfLCmprW7+uyy6iBhVuM/t
         mSDMjoWo6MCwW8oSatBt6bTNrU30nuNDimAnb+FSXpSw/JkWjZgodKg1wNCMR8YoTT1d
         zsgXgfEHPPZtHytt+RF42W8JqTux69EXqrPBka2P4xgGW83yagmDFjJQN4CFCzRUjpVD
         Ao1Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772048066; x=1772652866; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Si8z437tvGEJio1pwGBHAqSsYapkryN7R/ntn+VLWw=;
        b=TdWi6uJT9jGKXoEzCWiH7jSPrLKm0kXhUPxAZUWugxsLnbKPmp8q+T1LLqEazTqhiC
         3Thc60kwKz5o/i7IpW+WX4vzrGBzEm6RRrnZ+5xbGoMqkqHOr9k6xLq5sv0raNAmWO3y
         M99NvUs5N0YOBeWHioikZQJ9VpsOHuXCMZCiZLYdyWkv4tRrMFAEdlIMaBJqaN2eG5uB
         WZabyJFH5eCudmN8Ej7HQ2/jKnH/iw3UXCsskQttbu90CZqrUq1NKWTkHWbdD+Wk4SXx
         SDqicMqyZk0e5YwGPIC2JbCP+7duIQe524d8J+SB2Yc2K8F+khJ3KsMkTqx2wfL6WCXo
         D0+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772048066; x=1772652866;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7Si8z437tvGEJio1pwGBHAqSsYapkryN7R/ntn+VLWw=;
        b=DSo/D+r3JqTw0UzErP1Pat3njCoq5or+AyLOmbx9VkZsc/aMSIQxjq9ypQEdcM+VEF
         NyNAdlzkIvDb8P/USuTCNjflPqxvLH0D7KBhGYonPXAAq0LhmX+VeKWTbDPrVLQKSZJ1
         O8G3g9mpV8bp3ec2SZCOc4JTYFofZaYqazrgy2mB4IFL2rUTZy2XFrQfnvsGRK+UttRa
         Us26NfC6BsUYyCgfLVwXQyNcwMyM6qan2lEAyKzyYhem67Z/99QCzLXue3wUnUVDGU8V
         ZytE5GHkWk/Yj0BqO96FpKltHDUCGt+fJOLvVIk9x9ollCYEFdxUHKavdVEGDG85Wbzh
         RbnQ==
X-Forwarded-Encrypted: i=1; AJvYcCWKXMLRbeJDVCCoMR+4PEuaIJxNNKWza5QBJqwc+e+JxUQqU0wzv9YfgAUs7Hw6/07GxJw/Pl7PWQ==@kvack.org
X-Gm-Message-State: AOJu0YyD8jxh7GWxWZgvuZhXnUksqIvK7SU4Wkpgir7+yXgFgIhwdWaN
	103JpI5slOZtrWNp6S7b/u5PfpLxK3Wd5xs+bVCA+bBTvuklVD3i/EkMl7U5im27suHR2iMyIlm
	ZPrIwxY01rgfN622e9oxfoVOzU/QV2UVRv5NGxjtP
X-Gm-Gg: ATEYQzyhnrNTuRIlCl2HcRkpGddMxPnk3Ab8ne5Bqzs3+jBNSjNO6IxlqiK+Xzkw44P
	EThV1AuTOoAbXdZYBayUGOhG1jTaV3/2wU7qeJb0fYopZ3YRyV74dI6HW4MlA6LWqzOBwsfDRZP
	IQwySFJQ0mOr0b5RjiJ8ksR1DdT3mB1qfSU0D6+smvu/8yjB3D7E6olAUFzhaccoEtvRQlSXoR0
	8RvCtLPWCRAaPKKkixM6QSoet3Y6XybKfrIdUsUXU4luY7QIrN/UJAyJEG7eEpa1zB0UB938k5B
	VGHa3Tfr81Vn72j/itqeT4d5kz3zjBBLBrxiiF5e8fIcW6CgNQQemHFhxlkpN6tlCOU6Rw==
X-Received: by 2002:a7b:c059:0:b0:480:4a7b:228 with SMTP id
 5b1f17b1804b1-483c3195488mr93045e9.1.1772048065599; Wed, 25 Feb 2026 11:34:25
 -0800 (PST)
MIME-Version: 1.0
References: <20260225-dma-buf-heaps-as-modules-v1-0-2109225a090d@kernel.org> <20260225-dma-buf-heaps-as-modules-v1-2-2109225a090d@kernel.org>
In-Reply-To: <20260225-dma-buf-heaps-as-modules-v1-2-2109225a090d@kernel.org>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Wed, 25 Feb 2026 11:34:13 -0800
X-Gm-Features: AaiRm51mS0fj4CpzrUrBMi_FPuw0tp6YT-qMjNhlthEAQ04zl32goABU8oOB09E
Message-ID: <CABdmKX06VsekPpwairaWC6JuH6BHMj-NqJj1cYgR=-rd6iY9ZA@mail.gmail.com>
Subject: Re: [PATCH 2/7] mm: cma: Export cma_alloc and cma_release
To: Maxime Ripard <mripard@kernel.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Stat-Signature: 516yw1yexbx8g6gk8rzazes3jotq4kr8
X-Rspamd-Queue-Id: 7C43540008
X-Rspam-User: 
X-HE-Tag: 1772048067-914338
X-HE-Meta: U2FsdGVkX19y2uXRuSQQAVzE9onnmibvcMil/tdpiv8tnFWWE2JX2X4Q0aYWk7fi/dSXVyH2VcBQjFTFju4530E9bWkEGJ1sslBx8NWxqEDtsg3wVpH1Gogm2abFXx+8dQF2ivIVej/3W33ZQccMWsricSTlWsTXc0NsMwr0e8GRjqSwnESnd/ADSxwTLQYcMLZD4LQ/56IdxWh9yZug1D4AHigNop3TNTKFoVCC+7K7WXqRfsXbSI1hN++P7xDhhPEplwNxoXREg7oj9WZ7WEeHWUxKxJPIJOa5dM3tSJcYdBAYPHeFpP1cRluidDHgIW3W9MrbaoZRfT83OHAs7X9iLCooubwmv+MKOs8qwTrR3C8sHoNfBboYSamq1DtPMfzKzNCWEqJTjA5nSTps70GABrtOjRoJY0iPh/azlZenDb6ia8UM7ldihy+/zpJAFNms+uANVsmn0kJcylb+vkBzzLAoYpasjFDo1Pc8V0er60WS4S9hnUndVaH49O+6ps8O/wUGV32rvkY2fJJ4GMvlQWcpI2EGlQpvnu2uM/G1VPzRRwY2sn2fcTISyEb4NYuO7+um5Coe1IodKKiOswr0SsncdYPKEpkvbGgTXDSRvodh9oOhMGdF0gLnPf6TfDJzqWD59ZXFU93WhKL976yzLqV4IQSy0ufJLOO4px41J1PexXmUKEvEGQhEVHZ5/uIkAcVJLg9pNQ26radVJ+kT08J+QwZL4mvlhPToASw/L0SjufRqsdEpYNXcpNf37rpJpCBa3SUQxjJbHFBO5eIQ++0J5URi6ZzHDCwx07RFL/WvybBP3jFlLclnfdPS668yI0j+a47d6P6+J+9ocqkpLGMetaiuQFkUeTf7ycy1bbLwMscb8rD2b9pBhPFW7HLLKv0FeTPmfT8HUSHJGDWaxDQi0b2Ace7eGE1gFE3cbi5TRnkP8nlm5G0qFbCfh78LOutyiBopN7HeJsQ
 Bpx8S8Y9
 CHMUDXd4E0So84bdX8+HFgQ35eTlfPmX5YevGha1/QEYx6Z+EfT/KjsH27jvemlj3j3hd8qxN4C/1nVjjStabfNnzYy/xUYr4ke3cz1UqiYS3bk3BZuLuu6RdwKUqSE2F5cCWFalWXg+M3/kl7KdsLzaXobrnIOpyPqqZ3LDw+7G0vx9YadylCBQSBpMsPc/2qb0eGqlsptlOGpSYak/GWAhlJ7dZwrQEayOCfUbNTRqV1Yen+UI8yOFUE/gZV7M7oiuECXGrcsiO3uv5GotvVXI5ezD/SMEmdrYjCKpEvnQHfg5FO5RC6ruDfajx0HYlE289UBobAyPbwPo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 8:42=E2=80=AFAM Maxime Ripard <mripard@kernel.org> =
wrote:
>
> The CMA dma-buf heap uses cma_alloc() and cma_release() to allocate and
> free, respectively, its CMA buffers.
>
> However, these functions are not exported. Since we want to turn the CMA
> heap into a module, let's export them both.
>
> Signed-off-by: Maxime Ripard <mripard@kernel.org>

Reviewed-by: T.J. Mercier <tjmercier@google.com>

