Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE943CD37AC
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 18:55:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CF2B6B0005; Wed, 13 May 2026 14:55:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07F986B0088; Wed, 13 May 2026 14:55:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFE736B008A; Wed, 13 May 2026 14:55:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DD3AD6B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 14:55:03 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 412C81C01B1
	for <linux-mm@kvack.org>; Wed, 13 May 2026 18:55:03 +0000 (UTC)
X-FDA: 84763298886.05.B95CA43
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7603AC0003
	for <linux-mm@kvack.org>; Wed, 13 May 2026 18:55:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LDWMEh+2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778698501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oy48rSFgn/Urnek9HoSvpEF/u10r5XtDsuRkhJs2+R0=;
	b=Lh37+AQWze23R4GPsgph6Y1xi95UZhC3cOr7QtJU5MBnukAhrhp9WTD0yTqgtEo2GFXLL2
	tMmMwotmqBKIPlFiuPVb3YmiUlG6bUMktnYC3WB8kP+Yh9wtN7FfGqRCB/d8ayqP8dSIz4
	uon/3NZs/mx/MufOGfEcDkRmErbw2YE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778698501; a=rsa-sha256;
	cv=none;
	b=CagMroT5h3JfsPjf5oTTs1UkjnaCR/xHPUeobIj1fvODxHXeXHRqyeoZxVlDUJ4EtSlIsy
	HsnGCRqtJ4x8f2LGbOQxKHkhoGyDosA4mDTCuYqlYYQwhf8WT0HG7jpFOfv1qROzoZOFIi
	F7dKcUlucW5/9rjZdLXSFr9aI79vGjE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LDWMEh+2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BFCB060126
	for <linux-mm@kvack.org>; Wed, 13 May 2026 18:55:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E67C2BCC7
	for <linux-mm@kvack.org>; Wed, 13 May 2026 18:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778698500;
	bh=oy48rSFgn/Urnek9HoSvpEF/u10r5XtDsuRkhJs2+R0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=LDWMEh+2qLNLseuxA7u9PZiJrS7UJ995evm7L/D696Qwxo0ZjKQEGE/RFTjLDMM1K
	 lGCnPsySEh6nsjfqHIQN6bxN4ckE4lRX0mWjbBwKj7xFkmwZWD58ocq4J7NWnrmsvX
	 x32rdYJ1W5uKsuZGYA63Fvsn+AF0es+pD/VzZ8ftNzfGPsH8a8NjOAO3M3rebSKaKh
	 bqNQ1sA8Hni390pTaPHLv+x+T7twymy+0+vUdIYgRAlSO3SzQzw+fnJ07J/t1QRgNH
	 1lkm9W8U9OVJ9QWlmPPs+NGNP6KnJaDaO+Uznev9F8tOEs0o8E92LYrhBMpoCWq651
	 WPjpbtB5w2veg==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-bd2087858c4so391814666b.0
        for <linux-mm@kvack.org>; Wed, 13 May 2026 11:55:00 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/WUEEK2wOaEgF1khP0AyGGLmV74EYeWgONDio2iwPaNiuf3m8N8cwpiBP96fyZ/lrI28BkxUwBig==@kvack.org
X-Gm-Message-State: AOJu0Yw8EF9EVzrgfNSpK5UbNDosmmqrftttHpk9Xa0FHZhfeTbUxFTo
	ByV/dvGN7QxImOsLlpqZLdCzbXOxVgsFsnHdmBUQeXzD8SPdnGc13VZiAmUnydmqYqhB9YebFdF
	u0pl21vAO7eyQc1X3ZkbGeIvAgpt+J2M=
X-Received: by 2002:a17:907:a808:b0:bad:f032:fc78 with SMTP id
 a640c23a62f3a-bd3bf5810admr316310866b.1.1778698499361; Wed, 13 May 2026
 11:54:59 -0700 (PDT)
MIME-Version: 1.0
References: <20260511105149.75584-1-jiahao.kernel@gmail.com>
 <20260511105149.75584-3-jiahao.kernel@gmail.com> <CAKEwX=PLFRkfUvZyaYfwBv0QJ-8KAktvZvGA02Hod04H-RsS-Q@mail.gmail.com>
 <CAO9r8zNOPdpJuTmccvQ6ZAVS+tXxp-_ofA765DbnfaUZOPPO-g@mail.gmail.com>
 <12e4784e-2add-d849-7e54-bde8abfa6e78@gmail.com> <CAKEwX=MOixJAUGiwUcMQa0Stvg-mR-MvpDRD8WA4YMtRvnUYTg@mail.gmail.com>
 <6fc7fdf0-368c-5129-038e-623f9db2aa88@gmail.com>
In-Reply-To: <6fc7fdf0-368c-5129-038e-623f9db2aa88@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 13 May 2026 11:54:46 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPvgB-MG2ufmdn4HoS+QEPBAehU9u7fQmYs+47NF-C9aw@mail.gmail.com>
X-Gm-Features: AVHnY4LWBpgK05hIM_DR0y0RJ9IQwojHb2pGG4Y0yyBRaatpgBUHNNyaBPv-4Bg
Message-ID: <CAO9r8zPvgB-MG2ufmdn4HoS+QEPBAehU9u7fQmYs+47NF-C9aw@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm/zswap: Implement proactive writeback
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org, tj@kernel.org, 
	hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>, Alexandre Ghiti <alex@ghiti.fr>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7603AC0003
X-Stat-Signature: ctyww5xodshm8mymwa6wddpxajo4c1kh
X-Rspam-User: 
X-HE-Tag: 1778698501-689988
X-HE-Meta: U2FsdGVkX19v1D+oJ3yjLABqwXEFzr5yATizAGd+MThO26GH3hTjE7c6rJKDu6dCtubuas/4c7e47mz8wd2TThtf4ZYknqf8A2IMOjyqqX7H8Sb0LfPdaYL0qlt9iXd0cFxqz9RxhZ8Uc24t4xkWDcW+o/YibxBxVHMs8qhROgWBVIMuzz4eezRwFPC7YzGjISFsi4AoBRNEkxwBADm6JR5Cun7vGpH1SEIFPzCS4HEnG/taGPfODRR+g/xTKt/hrnONo98VJhmitKn+wveGeNPCAVYMMU+WbJIrsKAljHJUqOSmn5GConOEjK9zng3WldDGvjYHH8DniDwEC0Ye1P6yV7EwCbdrocUcUOQlb9TlfRzJ0kO/sywOuoEmzhUaJOLpFnnmLfwwzv+Hi/1b5paa72abOuBrKYiw9VAUlpgWO9CWW/9VfS7e1zf+iZ/F2tCHyo6Ecx3+HsRNSwBvQx5UsdMwy6O7+R+qng0GnzoCmJblba99JHF1165u4d2BNO7ECmLQV4XOektWZmXSqhXgDbwSYeCVyVnN533+v6VnWca+V6A9fA/BLX7jFtMKMYcf8Ez1JH4Agk1wi81wwoskOUdP6tkOvkRDlxYRklVdT5p5LgdvqGvS4FXK/ZeMjhEiTPuMnrKlmdH1f58RshMEnY5BJp73PCU8Uzh0tDJb6oNlQi26NRxE2I3Jeh6ctqD9I0zxYGPmaVqoI+RDc9iXUINX7oYa4k5tY45XfN1LPXZAGVUtPPzH2pf6c7YrfsnOZ87D2Ww/cQ5lY+fY46uLTRSWL7fTabBXo1Km0haXYUT5rVNs6YVkY3Dc7U+/9QkySyeK+pnoa7WPVOF6Bt80Tpl//GQi5LSq+dGjpY9cpD3pzO52qREgbkviwj4Tjot2R4/I/8wbuSWfrirKSrnz4dkn7jt9P34rmMDClENQ7yzDYDvYHOfiGuXz3s3o3ZCA4b5TdOiSHMPp5Ew
 bSP4dLXo
 ANlvM1ZzAAnuE9qY8JBvICxxAq0Z+sJ/pdZmx+OUK9fzKSjDwDZAaPRZxsF0wtvmSraUrqd/9YesqNTBYP9bmHfma7sekuYCCTXZzcDStBCJy8AgKyF2oPyAqDCaTVoa6xLSoNfUZxR+cveknvBRDq9TFTg+HWcfQKSQLUc245obanxX4aAvZTqiEad2/IWrvG4uDYCGId8bX4TVCl2EsqS+ffaOmP0Zkr/PnkIGAXMnUHVXSfC1ajzzN2F5qo1fcpxw9Y6CdsrjJpUl3gonLt+Q2fcFCGQaV8jhY3EHeAAzLihyicUVFF8XNRrbqgevrbqSgaSEjpxYIYDFIe3QYmMyTEXcQgeT7tIHf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > Zswap objects are organized into LRU and exposed to the shrinker
> > interface. Echo-ing to memory.reclaim should also offload some zswap
> > entries, correct? Are there still cold zswap entries that escape this,
> > somehow?
> >
>
> Yes, the memory.reclaim path does drive some zswap writeback, but
> it is not enough for our case.
>
> 1. For a memcg that has reached steady state (a common case being
> when memory.current is below the policy target), the userspace
> reclaimer may not invoke memory.reclaim on it for a long time,
> and so no second-level offloading happens through
> memory.reclaim. In this state we want
> memory.zswap.proactive_writeback to write back entries that
> have sat in zswap past an age threshold, to further reclaim
> the DRAM still held by the compressed data.
>
> 2. Even when memory.reclaim is running, the fraction of zswap
> residency that ends up reaching the backing swap device is
> still very small for many of our workloads, and the userspace
> reclaimer has no way to participate in or control the
> granularity of zswap writeback. So in our deployment we prefer
> to leave the zswap shrinker disabled, decouple LRU -> zswap
> from zswap -> swap, and use a dedicated proactive-writeback
> interface that lifts the writeback policy into userspace where
> it can evolve independently of the kernel.

To be honest I see the point of proactively reclaiming compressed
memory in zswap. If you use memory.reclaim, you are also reclaiming
hotter memory in the process, and you are not necessarily getting as
much writeback as you want. The memory in zswap is a more conservative
choice for proactive reclaim because it's memory that's guaranteed to
be cold(ish) and not being accessed.

That being said, the interface is not great any way you cut it :/

I don't like the 'memory.zswap.proactive_writeback' name, maybe we can
stay consistent by doing 'memory.zswap.reclaim', but that just as
easily reads as "reclaim using zswap". Maybe
'memory.zswap.do_writeback' or something, idk.

I also don't like having two proactive reclaim interfaces, so a voice
in my head wants to tie this into 'memory.reclaim' somehow, but that
includes adding a pretty specific argument (e.g. 'memory.reclaim
zswap_writeback_only=1'.

I don't like any of these options, and we also need to consider what
the memcg maintainers think. I see the use case of proactive writeback
but I am struggling to come up with a clean interface.

I also think we should take the 'age' aspect out of the conversation
for now, it can be a separate discussion. Well, unless we decide to
tie it to memory.reclaim. If memory.reclaim broadly supports age-based
reclaim then zswap writeback can be a natural part of that without
requiring a specific interface.

