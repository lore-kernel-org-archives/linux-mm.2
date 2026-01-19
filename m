Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD0C6D2ECF3
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 21:44:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFA046B02F8; Mon, 19 Jan 2026 16:44:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA7776B02FA; Mon, 19 Jan 2026 16:44:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA9CA6B02FB; Mon, 19 Jan 2026 16:44:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BA0F56B02F8
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:44:49 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 69BACD1D9D
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 21:44:49 +0000 (UTC)
X-FDA: 84350043498.05.7998E17
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf24.hostedemail.com (Postfix) with ESMTP id 57820180003
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 21:44:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WNLMVWdG;
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768859087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RA92Uz6yzMgzgAdJgeWwZijf7ELO6H9pNz/yFpB3p8A=;
	b=j2oB7G0x08J1EZ0EdZ0hFGc1tPkBfw+YfnZtoJXPu0QHtIp16+sBAFyTFkgxIz9QD7a7fl
	3zUY2ausTCLyMkRYOsYGKzj6eXv24D+FaZvg1sKLq+HD5MaByTgTw/gIe5lOt3vYBZ0tmm
	mr20eA+yOudQBZ6bXXrWvWuAHJumywo=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WNLMVWdG;
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768859087; a=rsa-sha256;
	cv=pass;
	b=rbQkMbpLA6zZ3EhPYNkTVecQDhuLqJVU01iUMsdXWynn0lAnnBM6MNAZ/64ffoWIBbsUlw
	lvx8SlRA/0T1UQjzolVJnBb9uIbZwOR7GnSVT7LlqGvSuPTyycmrOHM2kTH9UZWW885qG0
	y7h5EZ369qu1jX7x6Bz4Q4izG/I1qhQ=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-47d59da3d81so26967815e9.0
        for <linux-mm@kvack.org>; Mon, 19 Jan 2026 13:44:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768859086; cv=none;
        d=google.com; s=arc-20240605;
        b=kE84fo/qEaJZaZw3aUG6GPYmkTi6hUKaX4PI96H8LVPm2OXXbSpNn+C2M8ews1NsWB
         jE5ad5v5QYoyIydVXQq1YpRZIYq6zDbZlzW/uylu+9pepoVPL9Btqsfxb7fh9mUyKttb
         Dk0ZaEG5VkEBqTiSMy2o4NshJCIsoEo0X8FcmL5QLn0Rgyq59kpJBrK32glNs0Ltd3a+
         +J4AJvRSyMWTZ5pXAYE2/h5a+0wHY3LN9ib6gZTVUjfvN7sQuEQ6DN92ekuaxCwF6xi+
         dvpCOArMSayIyq5xZHN3EKir+R9F9sbs6004sbROzc38ds8YoNTec3i/uFTwtmxm+bME
         OWLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RA92Uz6yzMgzgAdJgeWwZijf7ELO6H9pNz/yFpB3p8A=;
        fh=0cwNCSRLUbsP3VBXPU6OwkgezeTjz5lQ7Hp5YQ9vM6Y=;
        b=Ku7Nzs2eisuTOwE5jEVBd39pLyi0ycNki/P44hv+Dw7JCMbprRsJXiIxB9b5AmFW0c
         NxJlidpym6dXXWmxoI7E0QEK1CR67c8ORuB0ev7CsA1vVriYS4UolVcYzojgjDTQ0O+P
         UAjM/64A9y5qHaPofhx+zFHFiW9H0oQrVveDzkthbggyFTVDc7oyJ2q33Sr9owAxCxMO
         FI+unM+sEnhMae7YS2mHhzM50KkXXH/SYzmLRIhAe97AyRVcZDkOiQLCCTdch6s3Cx76
         UEc2t42pYMqwunsMuE75sV4TPD+aQjnWrPfjnJg2ch2FVw6vr0Lq1aBE4QhdkTxtA9Td
         217w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768859086; x=1769463886; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RA92Uz6yzMgzgAdJgeWwZijf7ELO6H9pNz/yFpB3p8A=;
        b=WNLMVWdGROJ0/tHo9TdGYNjdlI1VeL4i5YtLTp3PZhSS8xVgmuwnh81cj3bk5pN1hH
         xYXeJ697ujlPUjo5Epmvy1WDLm+qglMM6vUEb06vCD8Nf/H6mViahYxvRLXfNUy9369o
         6QZmuxJDuW8eQl7XSVZcwq2A7UZJYGyA7ptnS8eygAN98PSgNd16eBgnhd8LP5yt449s
         BtG8h3ivpk0VF4UA2I3Hihm2vpk+0OIgAGIVTeURnCKF60nLiZ+fNmC3J5pwmbuZQ8BE
         AIkNF7gOzqRff15mQjp0xHhHf7AFXZMsFG6gwywJaC89Xm0DHkK/p8XZ1CNmMqY7J5Jk
         Zmew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768859086; x=1769463886;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RA92Uz6yzMgzgAdJgeWwZijf7ELO6H9pNz/yFpB3p8A=;
        b=kMqkrkj1/MdDrJwDO+9u0xeMK/aygheYXPIw3mR4vC/ErgUN8oVQRp6kC1wKv8kwuq
         MEO872KWq+3NOCLsbq2sL6g8KrxayeoxkktRkL4BnPYfVMxn+oqFUqs6YOf0s4TVH4nT
         bcjjZOF2z9/2VF6aXj4aAStXXBs4zGNWxgofr2VdV24pTayl9kAAEt+Mr/mP94NyLnv2
         izph/3n7RMbt5yLHZJVmTsQI0Pp/MmwfrUIg7d9WH4CENBgBC4Kvxp5P0mTlIbx9mewg
         bKL2Jk+V7rmlXqNlqgx+Zkz1qX6JYADOeX5RKMmkoJ29kcHyN5o1M8JK4l0lAibQhN0h
         JRWw==
X-Forwarded-Encrypted: i=1; AJvYcCWHlTj75AaVsOHhS+9ipbWE4rPBK5lKJK3Qzd37hZVqkLorMqQ9kk6CJmUjSCac2IeGgi9DOCI7Uw==@kvack.org
X-Gm-Message-State: AOJu0Yx4ggeWQnSPYpPaPG2YEEVK6Y7RjiWN4bp1k8G82C63dW6VWr+T
	+L4MVzyFZcXW7Z4XNjZnatR44tSnSK8prOPDYFg4W/6AdpqSuRHa/mgmmeJ5eB+34pGbV8JTIjz
	MSu29rxKcrE5PyhCHAtxYF0iUP7r5rhg=
X-Gm-Gg: AZuq6aJ/kEE9T70EFuNhxKC4I6WgiwGkvEO1Gyai0tuUZQK7J183flgrxAcPG4f7OZF
	iemLiyFGOcj4tENx3yW/CVKSUVb71fln6UXApQEm/FO2Zkv4QyL0+cb7xSSR3VGka6hPPyd8YdO
	siQ954FMj8/p2So3dfOTBXfaO2bfu9j6zGqe49Z2pKQqvrI8FLqS/U7QtwBWnwPhgdFZuLScfRV
	IgnY+5wl4AGjHVbBKanG5hT3PbIrwHXbTXN/I9ZTwd1PT/msgO5M7sR0qzHtmUFQE8pX4U=
X-Received: by 2002:a05:6000:4023:b0:430:f2ee:b21f with SMTP id
 ffacd0b85a97d-43569565238mr17218779f8f.22.1768859085572; Mon, 19 Jan 2026
 13:44:45 -0800 (PST)
MIME-Version: 1.0
References: <20260116044841.334821-1-senozhatsky@chromium.org> <zfmvd2oogwtx6mbavyjgwxralsvrd576ye6jnscfwvqy4u4ayp@q7qpxnyaxb6f>
In-Reply-To: <zfmvd2oogwtx6mbavyjgwxralsvrd576ye6jnscfwvqy4u4ayp@q7qpxnyaxb6f>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 19 Jan 2026 13:44:34 -0800
X-Gm-Features: AZwV_Qg1CrMrgazcbkOBRSxdLw2cz0PEeFMtHTdtPdmwwmjo1Zkn76XdooFf2cE
Message-ID: <CAKEwX=OJBc38i6ZhObNsvsNGJ16ZuNXkV18f-j=JRd-2xecJQg@mail.gmail.com>
Subject: Re: [RFC PATCH] zsmalloc: make common caches global
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Minchan Kim <minchan@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: zmj3rzgg6m8q4cubfb6nbusq6ffermkt
X-Rspamd-Queue-Id: 57820180003
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768859087-791338
X-HE-Meta: U2FsdGVkX18fpsgouG56/2pdYDt7ulGZfvrBhcL34jcP3yRbwboygMaz4xt1CXnrLd+XgGPC2ldSxj1XWCrlhzT5z02LIhwH1MRioz5mONBY0Z5taJHtmYAoVJeR7uRirSsy8sIPKpdWM4Oob56Bov4R/3bRNWhdYr5X7ndI9YGqhs38UJ/xiIbQuHV6NvMYmsttyVCP15XoZGnGeaklT/Dfck5tUW2D19F7esbvaugYnsPbnNXhVX4epo4faYYGn0GWDPkmzPZGU2aQRyi56IdrPE44rP/Jaoxen9/uN4Q9IGJ6ZOujzxeKt2QtKIFnErwmJ39jjLhK4ltGf/KfY2FKbN7zUxblQcXtZTU4IlaE02xXaxELbmMA9MMMuyrVwhmMDHrKO2cu9j048kFQFRCTsT8wwTlfCY3+AzCer3u6OqzYQF5bJmuBtZ+N1uHT9dlf0gMLS60ceO8bo7JgP+fJ5DlpXn9qA43DlN58urPmNvz6z1uYgB8qtQGJhTkeEAtFOj6a4dI3bIsCdNB6VaUmSLJx4hraD+/q9qwmDFxNICdrv+4mUtsE0ctL3puuAPwst9V8IhenN/Q90jasXGpJyxSi8ntPEobFt4TzuJU/43PJlrTVqUgiWPniLA49DFpBTtfp9OfwjM9BuSF4bZYOGdkDaJDx3q00lDh1/HP6bCMpWtg0jinKB1AstroUA3agegUwnjDq64wpONLbye1T9RVTHKkcycbmYwVDdt6ObU3nWRRR2yoYqRa8jEYkSa2aqDWYfa49FtGbRFsB05rZbXLm11elLDiqSeTioQgiWXJxHexq1HmT3OWgdQ5liljoBPrk5w+NukYCTUgui4Ws8q3ZlFQnepg6xu6/5vCk10VsvOGdXtopNelG/lKpVhCmGgComK6KLifcDuEv2E+xDs6L/8MqVs7XY/x6yDduGrG3Nm+4YDfuAULRG86mJDaWNe51bGdVF0aG/VF
 ceQdYSHu
 Ql9qKOvhyrmVZ04XBTPTbE8O6qkm793iF6QowTlFqdescfdqfQ3VK9a4snAA9PDsT2r4JWrZwB6jZhU2+Y4+FgqmnTCdGt6Wtf1cCvS+6b9YJAyvkrQv9LVwGEtofXvZ6181TK9kqQ+whxNkZ+gX5i07rtk5rdYocG4aDODrmeALlzOClbcYZ0+n6j1eRnCBlPq3ZZvF5b1F0Y2jn9WcOA7V3FlgHMjBCW0g21uTdbjoo9Br5kpTYsagTzjLez3iymdGMKEfGWPi5eYpQxohrF4yBBQ8LdmNjygis5WBcq7p2Fypw0+EqEazv8qM6d8/TmlA8zoRjZIC8ZCcFVDFTSl63TkrCZEYwL04enNBx6yoai9ldKnkqSxH6chyw7G7fomrm9yGwJIk7DnUm1ykK1OXMoFFUkHj79zCJt9FyM2bN4kU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 9:53=E2=80=AFPM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> On (26/01/16 13:48), Sergey Senozhatsky wrote:
> > Currently, zsmalloc creates kmem_cache of handles and zspages
> > for each pool, which may be suboptimal from the memory usage
> > point of view (extra internal fragmentation per pool).  Systems
> > that create multiple zsmalloc pools may benefit from shared
> > common zsmalloc caches.
>
> This is step 1.
>
> Step 2 is to look into possibility of sharing zsmalloc pools.
> E.g. if there are N zram devices in the system, do we really need
> N zsmalloc pools?  Can we just share a single pool between them?

Ditto for zswap (although here, we almost always only have a single zswap p=
ool).

