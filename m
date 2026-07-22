Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21404C44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 13:14:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB2966B008A; Wed, 22 Jul 2026 09:14:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C633A6B0092; Wed, 22 Jul 2026 09:14:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B794B6B0093; Wed, 22 Jul 2026 09:14:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 886C76B008A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:14:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F37768018E
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:14:17 +0000 (UTC)
X-FDA: 85016456154.22.1911F13
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf15.hostedemail.com (Postfix) with ESMTP id CAFE7A000B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:14:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=NSvA+omO;
	spf=pass (imf15.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.48 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784726056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0BxbpvuOHxt9xk85SoAx5gd6wtsST6LyEZ1wRvXtZQ8=;
	b=NTiNLlW2A1xIFTM57aSSalSRYIB5qhNHcmFv31BJuKQEFQlSFx/PhL3DeZP4NQ82FbdSdN
	6qRmnEPMFwemaD9VNk3pUZZqx599/pF80Y8Gyg5HD1hNBK+DGeHDsgoXCaLLeIMlbYK3z0
	Wv8XRarWSxVXerFdHNoyG76ereJ0jg4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=NSvA+omO;
	spf=pass (imf15.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.48 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784726056;
	b=tY7gPby1Nc6/WzPvzlL51K45l+C817T0vUf/q+qoA2EtPaE6F//ZJw8MyywIsnHX7mt0oE
	/s0qOSeR9mHmPhj+cIoA5y+rPCxWSq8Yqli13wHJT0+08Oj7Ps64IsakegxnbuHYvviDDe
	mvrPjQZOYe0Q30hgtO+Tv3JWzGH2hy4=
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8f1a8e914a9so101520836d6.1
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 06:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1784726055; x=1785330855; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0BxbpvuOHxt9xk85SoAx5gd6wtsST6LyEZ1wRvXtZQ8=;
        b=NSvA+omOlBXPHEComzhUUdyIi6hZIukScrm38xXZmt52RSgrNaj++9uCzGBLqwNTif
         I1bPQjcCL0o2jPRUhAADYY61+GqMbtGV8jp7nTxDyWXDZbeXvowIo0uKpkB3gGL2ag7q
         b6TgyiWBYVxIljKlWM2WESR+dCER0rUvJYP7q7kagDuap7+81y9n9YEuCHuCrgcaTpTm
         ArhcqwHt1x2j+R/jno2iCAM89eiU24K5vfREIcjgdu+E6fLStPTDDXbtnDODPVv+/Sqy
         CM3ZbAZRxi1gc4JanwTgPxEeKQ20q6Y64RIonWFKVW+/yKNDbEm/06VlV+GiefYvQvor
         OQsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784726055; x=1785330855;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0BxbpvuOHxt9xk85SoAx5gd6wtsST6LyEZ1wRvXtZQ8=;
        b=bav7vVophQREVunJ5WADbGPoAjjkrM7qhl63gXIhFWOaFrPfKf4VfPh83vQZxcwzfJ
         RerKLwKMoE1c+3mN9L+/FAnCo+ys9roTMhuNXpwKq53zPQZ+3NF6oxe6FW5l9F/f41YN
         wZ+Cw6Q4MqIN269qEdU1VaUzma95uoD23mSrUxvX08cOrb4Ph1uu75AtydWyA8Rl0raL
         PjwlRTjMCX3X5ait7+L0nZWkRwqMwH/EBGVTo86il12xs0BBWTbKIIUfhnMsF62KTKBU
         j4CMGywxpS3MEnJ21kFHRSfc0uWCMjEBACeChquRSet4jqpTkDE4Tvm6MZMxwk3Hjrnh
         vHsQ==
X-Forwarded-Encrypted: i=1; AHgh+RoHaHe5jcpVgWNHYvXsZcveHB6rgoAAM9S9mC3Op1LYmXWS9Vu8jHpjbkkIxjd72KUDIrfb11pfXg==@kvack.org
X-Gm-Message-State: AOJu0YzpOXdzyu8SGEnNr/rBaIhReQi0ebIOs6lMlluiCLd9uacncRhI
	JpHlkUPrgVZiskfidt26jzN0U1m0BFokl7nt1+dLD5b3wyzwl2Dn3T9EpVaW0Y66X9khFDTJ969
	ccfau
X-Gm-Gg: AR+sD11QIcaXqhZPGy6tKizneXPSk0h2UV+K749owoPe1Bb/fRP2PNpya4uXBWJphLd
	K+h1heSPSxOm32FFjhp9N90Oa7QjvwJFnXei4RSghGNQHCVl8sDMFBJLOYL+r9OZiuvLdJnjvng
	/ALCNm+SlmuZszo96TH2GlzeC/+dQN7RpbJ/oIB4nem5SuPjE5wb+T82qEqy3SlKHyp+b2T9agN
	vRYOmpwgaph3POJjI40t8D6mDyOHhzQwmWBRaa4x74nkCI0MQFnYSWJDtc+uZDGd6+ckKGIpN1o
	m4ysKtN2kR24l0RjHF8vd4YMZsoiC9o74Y0JXK0BDnDhYLmjsUB1KTlkBK8DOb2/AxYo5fegeqG
	IJSzvMlgbSTT0nDAp4BCIrpymvaR7Dn1YPIOwrMjVV8+PzS6n4BL29gn1JKKhXSoUG5TUCKNZEI
	E9
X-Received: by 2002:a05:6214:3106:b0:8ef:dc74:91ba with SMTP id 6a1803df08f44-9077834c563mr253071906d6.13.1784726054877;
        Wed, 22 Jul 2026 06:14:14 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907baa0f4dasm20661136d6.41.2026.07.22.06.14.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 06:14:13 -0700 (PDT)
Date: Wed, 22 Jul 2026 09:14:10 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Youngjun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org,
	yosry@kernel.org, joshua.hahnjy@gmail.com, gunho.lee@lge.com,
	taejoon.song@lge.com, hyungjun.cho@lge.com, baver.bae@lge.com,
	her0gyugyu@gmail.com
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
Message-ID: <amDCIl51NoNPL7Op@cmpxchg.org>
References: <20260713025644.170839-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713025644.170839-1-youngjun.park@lge.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CAFE7A000B
X-Stat-Signature: fcmjrhatt91qp8qjxojxfytr7jycaqj9
X-HE-Tag: 1784726055-344074
X-HE-Meta: U2FsdGVkX1+1Xw0H+9iQWaxxZoi5erFMJpxUdi1YcRFSB6t5gCq+eDzMUOVUE8QXPflIt3f94s04/t/dztjxjCVHeGPMwKinefjbIQvFff64arY9RADnPQa7T1N6J0A7T9OmGiQF5KRAoBR4QsrKptSagUBdB/InsHmqawC0cU8qN3ARH4nrSqeav8Kl4MsPlyAHpJegJG66QHjd+XHQPObYyeSbHSHeYTGlvjLV9nkmOwd4ED0RaL6RXRRS1KAcholjQidJKAl21+1inRU4myYUcYE1vFOUj/jmjZ0doTYiN7SWVGbilhuh2A2DpI7OvOUIzQcuQbkpBqEJYn36X1dQ2bHS0Y14p3Ym90a1b4TV4B/d1tqkNHRm5R7DteyEyAQWr1U/FfTFeqcNkye6DozMNUf3RwSS2EwaUvXWua4xOBL7pyK1cMebU2SALCyYonjN7ul+pONJHNzYfnum++B1w0tg6TdlaAQt4n+5n6NUXWdfZr/EgP8ttZ6dQ+4ne+/OS2ebs2odFsFYNQwO0nmDbuDG0cGQ+eU4sfYP1G39lwjhVLMzDOmYyJl8l0HSTEu6O+MYBxlv6D1eFdHYOiflkniRlKj5h1SzFZv7Ztf5P8cvoFbYN8DOrO1991c6paq4Un4AXDRShqGG8oheBRvaNcLi3XODQNjA+3CrZt/pIblAg5zzj6zmcY8eGx83HjQj3c4AittJq23PVX7INODZ3V3hWLRDQIXpnhn7bMCzSDsNKOWAUGeqxZHtGoM9PVjE40+SII6j+avq0pB8ngmTnSuaHiGOk8Ma3j5Y32poOiQitIPlfMWxVXiPLxcrvu3EnBi7xVqSfUUwR8nT55dMy0Rs/IQ/pjEyeMR/tJtfgeFqxkXEbrEZQm3+Q+kO0xQOfQr/nc9lnGIJ1p726XWauSk57xqFchRV9FHbqDKENs+C46Y4FhD1NEN2jIVNeIJXUkPMxOvcmiHNgXv
 exJ3EHxA
 DnzZ0aW+XNFp3kd+cVpxpop+KVFD3uGa/WiI0v+fa0425ottWKwqOkLEoGFrfBXEG16omPA7gD/ZfR6YELYFIOlQ/CYi72XIAu2im5G6jGjISHunWy/VHvZdHBHqxC3n0KqLDulkuXJcplNb41ZPoxO6GlZ9v+OR2BlK4tmwfGOAOP070ZuTEBeEFqYZ2A9KJH3sXSIldjarlS2M8jYwqge2rKLwtw84IR7MsQTEzEgJxgFbu5zsUYSFyY/H2p8zbVLle/S8tu45GTNZagaXyHUy+x7Q5HQiHT6vRGs21i45O/9Uny9ORl20eLBtsnG9mtvXBh6oDsfG0paPKY9urN5JXgjHcAHSbTWEOqTF67gfZgcuzXXE605/Ic44LqmmR7gwo60H1eh0O0/GGHvTKHAEcqmvo7fKfM5zt+pJ5cOnqXv/yfR21zYBJxsuKG9jT9DAMzeXfbYC66b+cUFzO2TsdcQTd534RO+eJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Zswap is a first-order swap destination with writeback semantics. The
way the discussion around zswap has been going in this thread is
disappointing, and I don't feel comfortable adding permanent user
interfaces on this basis.

We will not be merging a memcg swap tier interface until the swap side
has a story for indirection and backend migration.

