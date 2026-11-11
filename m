Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7877D606A320
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 06:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=KhrmC+le
Received: by kanga.kvack.org (Postfix)
	id 852FC6B05B4; Wed, 11 Nov 2026 01:05:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8043D6B05B8; Wed, 11 Nov 2026 01:05:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F5196B05B9; Wed, 11 Nov 2026 01:05:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3FE0B6B05B4
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:05:21 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C6F84140196
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:05:20 +0000 (UTC)
X-FDA: 85421800800.19.5EC1915
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf20.hostedemail.com (Postfix) with ESMTP id DFED71C0004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:05:18 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=KhrmC+le;
	spf=pass (imf20.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.54 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794377119;
	b=RYwdlP/Ui0vn3Di9x/agYFx5gwTJR0PaaK6c5LYZp+wClWZzkYzpPmqOxi7ozx1UHzmo/F
	kBCBFL+eeEnp948dhllz9mIS2dIVBvfhVWHmkqQ/BQAPkwq5LePvb/2AiqZ3NfJJFkeii9
	BNCHX2KoB3Qc0aTTFjCFiN2+T0fiazE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=KhrmC+le;
	spf=pass (imf20.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.54 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794377119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IM8our1qODgBYXBjuIaJFEMcF7pAsbTKhqQQH1o60eI=;
	b=QaXue2zc97eWX7qXs9GDgsYifnhsC78rm8O4qu43jAX6/qzy+678GBSjDzDfefTykHQE03
	hbUw4aA88vwd7TKdK4QTNTpsOkU6Pna8BmTFwu1Y97zwQL+sgtiZ3mAK8g1hXUL+1TCAEL
	0AG/mbY8wRldGAai+XMVYhKn/U48S2U=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3ac91ac8924so1672873a91.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:05:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794377117; x=1794981917; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=IM8our1qODgBYXBjuIaJFEMcF7pAsbTKhqQQH1o60eI=;
        b=KhrmC+leX1NDgHxH2JEWY9rVZ+a/no35ha7Z636rWkOoG3X1ZvXJtSMyffg1Mf66gG
         HC0JqHhpzGehzWCwkYURC/aqeDc/mb2z11JdqyTIUqpLKNxRx7clrH2YHB3ddjMYHO03
         Q7+T+O7X7rjcOSldG9RxjWl0LxCVE/mbRhm74=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794377117; x=1794981917;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=IM8our1qODgBYXBjuIaJFEMcF7pAsbTKhqQQH1o60eI=;
        b=BqkfAY0x+VnNlD+/6iacsDb1QNAeA8jAO0XlgAIwHl0p+BIniYznMp3cQDh2zw5JKM
         Ccy+rzW2KvUeuO+xNC3BdZOrrmfOANojK82go03laUhLn/AqIbTnC8LQmKQsU2X4Tcv7
         aqYO8zj4rNRGfwbsDA+LXbJcbvknvs+85Rf7hx48aMCPTdRS0+FdCr9DW6Q9K/zvPw28
         w9KTeFxMw7lkiBNPsSoq+3GUKkdyZnTEjHYLglRHVZCgp+1Mak7lJFwHUnslJYqtw+u1
         UshnsH4R76Jr65r8G3/9hoN+sXrW9+lbVX2Hh91R/WEO+O8DN2QJawg/pZHYwTeM3bRn
         Ex2g==
X-Forwarded-Encrypted: i=1; AL+hErFmPVHyHlUzZerGWera7QMmgpnVS5ublsnt5OVILkEXJnEVvcJ2Py9PY1yL+ah660l9ftMyO2zlsQ==@kvack.org
X-Gm-Message-State: APuU4Z9DpGlq6AOdYtRxxfaa77p2d809uRNBybylmveCKf08oDjZHQ6P
	6Gb3B4OjOfqMOWEZEs1YRVcrPzOG3JJw0a4CjIjVw/EqmsiygZ0CspSRWJdatZ33NQ==
X-Gm-Gg: AYBFou33OB+HzuSUCpAe2MVpZDE8yeQzKjLTt1DrmzInvND4vdBA6x/6o7mvYnXrrz8
	4T8hYhQhrXBjt5M2ANT66UOlFg1ClYA8rag0ovrQU5P5cKohr9F/GqUMkWKRF04uPbr1sAR3YOS
	y8Qu6gS0N/Ku+JNZ9OV/5660sAxzORLxgbDWRVdx93rrIWPFWQgoWu2OoewmwVWMegLgIIyCpJq
	jX26AILfBIlANXzqLc+8N0IuNcg0m3E0NoiyjQjsDs73KrVFW6sOvlrEKTnMA14PquECC47Dktm
	pHo2xDYM+2WKapuuQ+qf0j/knGUqTdFSf8Ruo4m99XY/KV97y2G/mYscKUoEhJNj2P7otjwFytz
	Ib7vp/bDOhWrwwD2URA/ECsPUQBM4XfrPmvzGOooZtzQsJe47GU+C27IVu7PpOTvXC/F4uabqg2
	g27F49IHoDKw8IVTgmNreKda797lt3o3jcJZhZGy4e+xeIiyNilsnVDbHHfZ20No/g8fwViCPjP
	iSg0hfkHl8RKPryjdFlcrsUYirfQPKSRqV8IvyMb43rcTRQyz8d2hNtTKuLFZXt5l0i5qATt89y
	/WKbAbAgb7Eiiw1linxbg+lgCfENsfaTBix9oscfGLKWMk4/kanGyCgE3+bHiwCHx8SWtg==
X-Received: by 2002:a17:90a:e708:b0:3a4:6f38:f2a2 with SMTP id 98e67ed59e1d1-3b182f26e6bmr1551048a91.25.1794377117628;
        Tue, 10 Nov 2026 22:05:17 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:ad6a:b446:df00:78dc])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b17e313932sm2766371a91.16.2026.11.10.22.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 22:05:16 -0800 (PST)
Date: Wed, 11 Nov 2026 15:05:11 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, Richard Chang <richardycc@google.com>, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 10/11] zsmalloc: fold zs_obj_write() into zs_store()
Message-ID: <avQFhb2EwjRkSM-a@google.com>
References: <20261110054836.1515030-1-senozhatsky@chromium.org>
 <20261110054836.1515030-11-senozhatsky@chromium.org>
 <CAKEwX=PJObB4gDPtsOWGjW6FJD4dtoz0qDu9KpK9jzP0=N=d_w@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=PJObB4gDPtsOWGjW6FJD4dtoz0qDu9KpK9jzP0=N=d_w@mail.gmail.com>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DFED71C0004
X-Stat-Signature: 8qh8t5kg3gr76m6d39xr6pbtrau744pd
X-Rspam-User: 
X-HE-Tag: 1794377118-754765
X-HE-Meta: U2FsdGVkX1+LvdbvsEIoUt0g0fh7/4QXU56EtW1TTj/x9XzTw8olBIaNTKsipqxra8DJx0PtHygYr4wiCE1KOiQOF6rGT9+wuv3y1cn0wSPtBrFm5hJ1ATG6FP83bsqbN39Ej6NV71mlkKVJ0eCDaHCMePmmCIConiGHuDzn1YC2xmhbBSpptKFJ4zoeIrtY+Rwa5TlvuwrmEtvLM+VnEF6nIid8pIEFoMfqyJnOTfAYpc0TCyRsGD+4f9as6AS0gH3vBB8k99237ZEf3S5Ic0W1rmRYu97K97BxBjqBHUEKCQ7yYI7z8IJOYvOa20bvBV3ISocA8fG+PMqMlxLrfmP8dovUU6qG7vNla7ty2Y1fok47YI950o0T8rujBjNyb6VNOnBas/eLU1S5AvF9x7/pKN8gJqQbNFr56eg+KbGwcZxh6Ly8z2NQzmh9o49dQq9z6uHHGs3KE3wH86kD4NsFiMz4m/xbKSrBoyqwD1DSaObqZw7RnR84zA9RaSw39D8XIffMcjIkNuDNj6vDMPB7ce5C0/akFquzCzasKCDWNpLhJZpyM+ZWKFaJJAqGMToWwn5dAZ0XTCVqyi9D2BLtEg/VdExYuJJWs81HFxRq2B7gHiX6figZ1ApdqxiMDXtoV42def5vtzgmhhTvjKK+Wh/F7xFfRssRut9QZAJO5sfKQbsVE0JeeEsvppQxme9+d7W9zIHzs5X9k1/b+MJvybYIzCbeMAXqEDmmzNVY3CYw1dkTEvSqTM1mReO9ssnpr1CD5ECQ7yS5RIrMjFD7ZSTdektDuPPYu0wGCZpGR4FlyFe4CAXX0B0BhIlv2TQ5E3hC4tGBhiNBeJ8iM4JITa2/49ytATv7OcMzmG5DGHUi8Wmz5DXi2MVyGeuComdLhNgNh6qrTavjK5RZXHvaVLKo1/Qx+FtFIqwfP3eTCrni+qwcmlll9r6RW73F7a68kDu/FEwTRIfU35l
 dbk99B9q
 e2R0eJFkFdweeQ6itmjlmCbCkudAK6hiw3RJVO+kBvF1b13zYgmWgRUYc+sCIkAJ9NBlcUrqc0FHj7sEjW0I1Fenu2ZmeMuu3RCZXJyMAlW7y0WJmpvHPw29SNXpZGm3/jPsjcNcSva3xkAnqi61RqyePqhDHbhiunRFH96jngJXT1Kr5LxjP1UH6gr9LGUSXOHV2PLc+qlacLaCUvFcMMZvcnUTGYOH1L524FPA1vaaGeMRTst/DjXU9VM2r2dtI5MEh3y+hVSmdfate4pL3cPfeBqZOy3iZPNkw+lozLxNWIA4vZxQhIJBNTxSDn4AQ5q8AjUvSOGj6nzAu8NgH3ozRNv3UGZSikATqcovyrOJkcz7MavVQDgUu6Y9Um/1V/WF3P9KDgmOsTHI5B4ys5XCFGFrGektT6KyT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/10 11:01), Nhat Pham wrote:
> On Mon, Nov 9, 2026 at 10:49 PM Sergey Senozhatsky
> <senozhatsky@chromium.org> wrote:
> >
> > zram and zswap always call zs_obj_write() right after zs_malloc(), and
> > zs_obj_write() has to take pool->lock and look up object location
> > again, which zs_malloc() just did.
> >
> > Replace zs_malloc() and zs_obj_write() with one single zs_store()
> > call.
> >
> > zs_store() takes zspage read lock under class->lock, before it drops
> > class->lock to copy the data, while zs_obj_write() used to take it
> > under pool->lock.  Compaction and page migration already take zspage
> > lock under class->lock, so this follows the existing pool->lock ->
> > class->lock -> zspage->lock order.  We don't need pool->lock there,
> > zs_store() doesn't look up the object via the handle, it already has
> > the zspage from the allocation.
> 
> Oh nice, this looks like it'd save a pool lock acquisition?
> 
> That (effectively global) lock can be quite contend-y under memory
> fragmentation, etc...

Right.

