Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A77D1099B30
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 20:59:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81A596B00E7; Fri, 20 Mar 2026 16:59:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CB066B00E8; Fri, 20 Mar 2026 16:59:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BA566B00E9; Fri, 20 Mar 2026 16:59:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5B38B6B00E7
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:59:30 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 024008B53B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:59:29 +0000 (UTC)
X-FDA: 84567657300.05.4D76FCE
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf13.hostedemail.com (Postfix) with ESMTP id 106AB20003
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:59:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RkWV+ZJk;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of axelrasmussen@google.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=axelrasmussen@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774040368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kD2oiXKOGMMQtFfgVKhW5VJAqQSDWQO7P8JTSfR75k8=;
	b=qn5FjPZ45X7n22zyShCs+FsDQUv+ayrrTSEm/vaLq4icVlwOAgb/ZaB3cU9IIvcR3CEQrK
	B4Ijtg8Mc1xMBA57hXJvDKuiWbVYFlEUpIj7tTDg2slbBFej1bOQdRsRupNr0kHRZAdlBE
	C0fxdhT52QXQbiZYqf3lonPGxUBAP+w=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RkWV+ZJk;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of axelrasmussen@google.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=axelrasmussen@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774040368; a=rsa-sha256;
	cv=pass;
	b=VeHVySGjGix+Y1WTOJo0LPKlCXBAxbrDfBIxmIqPcWHYTPz5UjFK+k8wDwTlEjmmYCjYfW
	Du/cLTFJfyj+SHESTTJIt1ozEU8qS/dUfC+FbGxu7wB1Ldd3iCxY4sjrS3dtlnM4I24bGT
	7rYZrIqO5wh5OoyCOdJRkHoiZ0FOHFg=
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-128ce536fe0so2210c88.0
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:59:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774040367; cv=none;
        d=google.com; s=arc-20240605;
        b=AyYRCarKNoRRDAPltkc1O6r70dJt7wLUiBInxUMsvdBKsDvad1/bJUCvWNtZVyh0HS
         Ua9/7+WJI+3wogPN8Vi++7kvJTv57zB4XVDlYL41CxTk5HAGzozvVpNkp8RzT9M/mDIq
         hp8OoRG8BwjT1IVkSFKz9y+JQNOcEjbO/R9Sk0+QMJCReWj3Q1yzDVCwuMfIbxV1hn9P
         EWEv2YpjGV3uXylGHzaPikB9QBryRC5MVuBSPP8/92KSLwX3MfQ7IWolGCmpH8/6XM8H
         IzcwZ6NhzHsB12dsWnI3rbYeCdZd5VDQEA0uJx8kHt1wZnXsZZcWlhmH6O4lYzb7E68U
         l8bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kD2oiXKOGMMQtFfgVKhW5VJAqQSDWQO7P8JTSfR75k8=;
        fh=vjmlo65dT3bwujOwu4be5PnOTUPYF/zNrpV078uiamg=;
        b=QEjBopA/m8YWGvmXZgi0v4A2P0LBk6HI86/DJ0MgVy4+eKDVgLkdqjR9tgsxwmGX8/
         tMyI7Q3CriQZdrN+8yDobsj4aBSaaRC+2dUHP0dW/zdEcdrGwylRdm+MX2OusP7QyrUH
         I0LO+CzzlhMzEypbrnnyWv2+9UuJZA7rVDd2Aa2EhR3oyivewb3Dh0ZqKVkj2cS8MYlM
         EBE+JZ1NSt+AMBdrUbzj64+oMJ+fbdAQDkgRivBpFIXnGjJ7SLvNqM4rk0TbdPXtGRSW
         kQGl273ErKaA55LcN5Is/HuF5f01D83c1WUns9aqqRrFWCiXfP+5Y6e1qeNQSEUFeqpB
         NTKQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774040367; x=1774645167; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kD2oiXKOGMMQtFfgVKhW5VJAqQSDWQO7P8JTSfR75k8=;
        b=RkWV+ZJkhb1bqtbSTIURxkPoBuYatzJqh2+jt5uoHx/kbColxNbRUto0rwRNWupauL
         j6HzF/4UASjGkFJcGDQNDiP1cgMcTwArJbMmYH8M2wkljizBVcM8rtu+h95hP5un7ZHO
         8hRvVz3KISWSwMJ3HAGwD3U8i3B0uY+hcit/52Cw+ioqV+SulGfWr7QtSI+G1lK+8cRi
         N1Ze+sdzDfljTkLgm4qNXhpNtOZCupuxadvtqa+/o0+kMggttT/5DvGNPWsqrEu2FAfW
         LKKiPnZJh4kPClxj4hmkmTZBH85pSq1BiHmSKW3QEGpL+5iJ9asXkjBt4VdKLYGzEXbz
         ypEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774040367; x=1774645167;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kD2oiXKOGMMQtFfgVKhW5VJAqQSDWQO7P8JTSfR75k8=;
        b=fSn7ApMP1IwTtjjmBomdRWHIHXG3MuX52q7OOqztmxDhPPDKMoc5cACg7mXsWi+vH4
         ZcR5bxvsrS0XsTTiLGX7oZCxLt/UqaFj+nsz9I6vFd/8RcHYUC9TWozkL/mYVGee5pML
         g4uWGL4T+6TGq0z1GZEGfvj2E5TClWrx+UDj2CBCnhxC3md89ON6cwyEZtP+/86Q18vu
         ZjAz5TupGx4AZZeoSzisFD+SfFXqWAi0yeIw3wQSd5vqM6TR4CSrXTiYKOnDrDPSRYSD
         OIVHJzQL5pPTLeO5YNmyLmQyaZZEb9KgaKiAzlWvfS/k0tgbVnPB0Jp27wBZqRKc7JZz
         j25w==
X-Gm-Message-State: AOJu0Yw4n6MlEO9iOCtS/fCmwAkr/IUkZQUlsnp7Huk1MLE32zbV91UU
	39LBZD+Ov782qM0+Gu5nrjhh3vJHi8mQ11K16LoyXioYPcJB6Z9odjMr6dgJYlFHX4BOwK5xyQ+
	x3RKZOFGnooM+05OC5wLOBkwZalohvtyl9FBEiky9
X-Gm-Gg: ATEYQzw0+hcOxLm+fEJDSwKIhD+t8igIrtN+pmFVRHNOwWTb0xHTADzCfM++xDTF4N6
	WlI+yHlJf5tXL7rECFT7vsI3VS7xu0qPP6D7VeV4tkujXqbMVwDkOxxOzbC/rAxINLW85fvU4JE
	T5plyElIspp57YzQpEMp3V/tLodlsiDwIeBJrOJxIhOlztRBMDp3+kXnYD2AoKQKBVEMOFVO1P1
	glwpqMQ07WetGrsj/PkUYNd9VBpxbIw8+ivr5RmQgjOLPzgXKy0UqaL6998fLPUFGPby9KUAoPt
	EZjxr2IS
X-Received: by 2002:a05:7023:b82:b0:120:5719:624c with SMTP id
 a92af1059eb24-12a7ba182f6mr8229c88.19.1774040366269; Fri, 20 Mar 2026
 13:59:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com> <20260318-mglru-reclaim-v1-5-2c46f9eb0508@tencent.com>
In-Reply-To: <20260318-mglru-reclaim-v1-5-2c46f9eb0508@tencent.com>
From: Axel Rasmussen <axelrasmussen@google.com>
Date: Fri, 20 Mar 2026 13:58:49 -0700
X-Gm-Features: AaiRm50Ydmirajsbwt7vQ6k_hCF3c_J3YD6NjlI-f21DFV7xpTJc-e-2fR7R9JQ
Message-ID: <CAJHvVcj7bnyxLgc3xxmd9MXajge4kZ-MERQjWm6+xpWyFf8eiQ@mail.gmail.com>
Subject: Re: [PATCH 5/8] mm/mglru: use a smaller batch for reclaim
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
	Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 106AB20003
X-Stat-Signature: pagzyg3fbrkkt3p3ts8y1mffqh9f5nx8
X-Rspam-User: 
X-HE-Tag: 1774040367-751833
X-HE-Meta: U2FsdGVkX19Bcd+wFB0FdYtA2u2w/JkbSZKyZP0x/vMyLkjpSBhSyvgVY6olaFFuX/D+rrv770TT50jvIxepKQKV68Kvs3PcYwkOmjf9kMBwEK6OpGLC9i0UVeUdL9qenc08CTX8bLYNQ35E5lBdTE4w/ZnwwlDB67EgVAolEa+tMYd+KTCimcz4q7jNM7Zp051EvCj6je5VIQosyWCs7m9bRb8XZWtYd+qYxb1Vnef98qv4LJXuh3YqQeX1QveG1u7jSfbXoi71k/2obwpeTJlRqeZMbHaPJYLkt4SCRJ51pESHdGw76gl9xrNHww1FzbW2NBA/+wfRhbGZ9f89PiA0HOlYskAwVjmxdCuEZeU9xEtrx+aABwI8/8s0iOem9Tsbd71NFuLbfLgGSPmIqCW7sW6j2uwjlylkuYXvykUit4l3/24aZGeV7MvUG/DMosRyqCSgMGwAxNTB099lXzMlfRUKYhinJg8F6ePrHdXpkH1v+sOtSXfAnzL57d4S4/pHc7Z99PSkYsdlgkWkuLRJy1XQ8yyB+zWUBV7Z+5e9X+lPFF2aZ3KxAqqUYsFcG8so/o16SBunZfpvWyp2walsiJaVZdlTarmYkci8hF/RuSYPxSEoDpOl2Ci2LszLmLjbGb0ciR1gY6KVvOt9UiYrJoFze0q6znMc2OjJzvSw0xMPGF0fDUUbkd5YAEZ0iegWcxuK3RKdRsrPvtaE+in/WtZ9u5IEfP9CIgKr6H1Duvoke8MsqlOWIDtTjeyBCb5uTJD1oyUeiphY7go4lMpOyZfuDFhpRiUC/yseLiNA3zPpQ/b75lY7xlkwwFRkRYM+l120/aV6LpdUbYj6zETtrl++iLnccuPvZmZqR83rVxz4LnSk3kLHyiOxNTUDmosE0B7xX9jsrEx9RJzcl0ZVSD13vOLjiD73htfRkzndjTnAobzQfwEtLFqwDz+8SZBW6U+GYKagtXhK4wR
 0sIj2SYX
 RxvOuxwTeYtJtbiFPlT314F70dFbponxHOMnKl9L/YTiQOMx+YVWa/XdD0eklutlOYrgdfkBc+MVeW+9KsKHwTQQ1pPtyeGLPZ3jkTNLHgeHHKjHUvUNLbmKZaju3sfWHE865bINyupbAG87hZy7xIkqS60FMfzuVyTYkMkNB/x2aMIJ/j6snWriMx5fQsIFACI3s9zIn1U2WYxqHml80p2ito1owBavKHIpGq//3zmAXjNEAkaAwCaFvarfLt8p2cduQJxlacslV/7I8lejNec68nCGYEF0lmW/d75r+vn5zFtEc78w2UuJtidGLa4aXh/DzI3yvlcZhOBznQQNCvg+yfkCf0zfY5rfd/gU+T1xjlZtbrpignxO2tLmXSqQI2gG1ANfkwDvicXHBqFHxNwJMwA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 12:11=E2=80=AFPM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> With a fixed number to reclaim calculated at the beginning, making each
> following step smaller should reduce the lock contention and avoid
> over-aggressive reclaim of folios, as it will abort earlier when the
> number of folios to be reclaimed is reached.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>

> ---
>  mm/vmscan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 4f4548ff3a17..2ff1609ff4de 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -5007,7 +5007,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lru=
vec, struct scan_control *sc)
>                         break;
>                 }
>
> -               nr_batch =3D min(nr_to_scan, MAX_LRU_BATCH);
> +               nr_batch =3D min(nr_to_scan, MIN_LRU_BATCH);
>                 delta =3D evict_folios(nr_batch, lruvec, sc, swappiness);
>                 if (!delta)
>                         break;
>
> --
> 2.53.0
>
>

