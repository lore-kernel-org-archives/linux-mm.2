Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CA08C44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 03:29:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F6B26B00C0; Wed, 21 Jan 2026 22:29:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CE2D6B00C1; Wed, 21 Jan 2026 22:29:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40DF06B00C2; Wed, 21 Jan 2026 22:29:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2D27E6B00C0
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 22:29:06 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9886ED4A76
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 03:29:05 +0000 (UTC)
X-FDA: 84358168650.04.9F13374
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf28.hostedemail.com (Postfix) with ESMTP id A258FC000C
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 03:29:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=fLOoaMt5;
	spf=pass (imf28.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.51 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769052543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k/jYZIrpXolnqy/Psn0zy4aSsk3XvNlN8YNSVkk5vMc=;
	b=2W97Q8wPyoFzv6F+wNJnjVk3PO41ig9l1Je1d55mt7rnGjQDA0DkjOT9s0eii31F8mXJvt
	Lz72qfnD+H4ZvJZDQMAzhVJT8bZxTk+/mB+OAsPwBS9rRJAVI4rokre2d6BvrDLL+7ZfJm
	P2MKXqcA3wuh1WNVFi5I3/iUxhFGuDM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=fLOoaMt5;
	spf=pass (imf28.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.51 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769052543; a=rsa-sha256;
	cv=none;
	b=PQP5j32QlMQyR0592BCUO+rELNd5xg1Q+V9Q0BRXT+10X+egFnIqa28JifvDqy9syNsadp
	g3LC8HXAvhhD7hFX9ioTvJorPtLHsNkiSIbh5a0tr0Fy28BguOr/VbF67luMKtlM6DKhwf
	4GbLm+5dRIcAVAXAm7BXGPaMy7XxNNE=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-352dda4a34eso281288a91.1
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 19:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1769052542; x=1769657342; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=k/jYZIrpXolnqy/Psn0zy4aSsk3XvNlN8YNSVkk5vMc=;
        b=fLOoaMt5FMZEOkoR8BN9SuTNqsbkNIEOhmaXwcbreYFlbBGtPwFnpJIk0/4L2ruNEl
         ERyLPQDMWxnSl7zap7gYmnM1VVQppfRBbGM+4olxFsprP7DWbktHlleTaq6d+YS+nViP
         QNRxkJXNGZzTOdyyP+dMDtqidczSQ5qEw0KQE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769052542; x=1769657342;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k/jYZIrpXolnqy/Psn0zy4aSsk3XvNlN8YNSVkk5vMc=;
        b=cDoRCX3qE7HD2YG0/Vx6ihFRKECcsqAmKV8VOc1DzXAyU5G9q+pOdlg2dAZd3E4ER/
         cOzjjCJAX2kgvBj2Kwh4axI66qeteTRbS9yAz1F2OdX6zsLqbfJIpLnbwOrk/p61Cexf
         Q/KBGgsB6OT+wGkfZNl3eZqWaj6XFFHDoJGxY3nUQCJhH3dakLHhXbJN7en2Aw4Hge9e
         vcfwmBA0qCm6kdXsNeeOBwxzzxaa1+bbRFN1FqFI12J6z+CGUaxwVtEI4ViHqYEwuAwz
         KwIO6qNjgHnySD1nFjd4agqx3UaUQFNG0fTLc63+uUBhbui6cotKwW0I5ahuHFaIB1jL
         PRmg==
X-Forwarded-Encrypted: i=1; AJvYcCWGv61jpG9umtKw8VAW6jIw+EVcSNMFI7Gvd/PJLFUbCLZG3Or/BCOWGT8NKjiAPlaCAKXfpseS+A==@kvack.org
X-Gm-Message-State: AOJu0YxkzywbJ6qfxycooWuXTAvcY46hvjFs6+GqQqplbyxKwQMs22AP
	whdd8UHoz1rySsJwgPhds1vVwIo6loNHKWlOZhlNN+VPdRsonrYlas07iztBPef60Q==
X-Gm-Gg: AZuq6aICSY2xN7N85AXD24LQ0gGj48BrKGg9QXhHC+C0mYEQZ0IFfy2J89EkIm2ggvN
	285jZsS9OY3Q3EwDc1HouyHCWQO6EfLR6ZaWcoDBquONPrOEdZGSmeJ8iA1aWorD8QqclFFBguF
	8pEf1hvlLBfhia33c/9p2u4qufPXBaPk1VbiSGf3L60bmQ55uoYtN1VJZTq+y0mPFRqIvO+BTCr
	k1YaYtQNY1HS+HFbnNY8RWynptT5WJ7o0Z1j7trNMI8LSFl8iidYm2h+0IeGrFbdy3X+KUo/Qn2
	BZxnDiE2W1FKd/0aO/L7Kw9pBtDymafHk6DjPZHjmf4VPN1cyT3+YMcLrSsyR1gXNAvydtFgT7n
	8vq/8fYIEEB6iPWw9I5mUPQqcxTh+bSLBCqx/OUGOuRCIXp/ycTeAAgFInwiIpwJTM1+pdRn8S5
	pxkUGCQjczt2YBm6PpY/snCmAvmZfDrIkTud6ife8UVV3QFzlp94bhvtu5fNJ7Lw==
X-Received: by 2002:a17:90b:5488:b0:340:bb5c:7dd7 with SMTP id 98e67ed59e1d1-352c3e56b45mr5625317a91.5.1769052542426;
        Wed, 21 Jan 2026 19:29:02 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:302d:ca04:e174:1470])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35335203565sm819511a91.2.2026.01.21.19.28.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 19:29:01 -0800 (PST)
Date: Thu, 22 Jan 2026 12:28:56 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Nhat Pham <nphamcs@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Minchan Kim <minchan@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH] zsmalloc: make common caches global
Message-ID: <uodv6dukliy7bnfprh4yoxjkrn77uqljarlg5pmlippxsxygzv@gthjss7yyrlf>
References: <20260116044841.334821-1-senozhatsky@chromium.org>
 <zfmvd2oogwtx6mbavyjgwxralsvrd576ye6jnscfwvqy4u4ayp@q7qpxnyaxb6f>
 <CAKEwX=OJBc38i6ZhObNsvsNGJ16ZuNXkV18f-j=JRd-2xecJQg@mail.gmail.com>
 <kmku2oyevj5vbt6na73iyksyod4sjcvik5zx43h4mw55m744oo@ddiynkvadmni>
 <cevxzukpt4363kdlb5ofre5tquuvm6jyphstp6nlxjxqibj4wx@2yg4xwlcxwg5>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cevxzukpt4363kdlb5ofre5tquuvm6jyphstp6nlxjxqibj4wx@2yg4xwlcxwg5>
X-Rspamd-Server: rspam11
X-Stat-Signature: a6uy7jjxumezpmw6tkbbyda18jucqjxc
X-Rspam-User: 
X-Rspamd-Queue-Id: A258FC000C
X-HE-Tag: 1769052543-687611
X-HE-Meta: U2FsdGVkX19VEmiqYUpVoEnbyZDkbTl8RXaqF8KWEbIQDEWQUAe+v1hguNitvCDJh05OMmg/w8O6yqDkpDs1na9IKTtEu3K7CPuv2il7ERY69MmUfOI+RlW17i8tUNIgrUYhqMofEIqKIHSJM+7Nc5tH34e9RlpbKj8QtN7sjN3K3E3ppxfVU5p4heDZ9R++ifAh0Zkblp0ApIWUl9vq3sz013jRb+J1N9gKEcOEMC2mGUmOCzRACl6cqahYRQi+mtYnhI9z+o4K92VZRf3E1K211D+6YK0rn+rx6rPAlqgoseDZ2PaTpYdEaTHv4/RNe6D2PyutL/fTT34kpX60PDCksn5Qym/mLfDN3O2/1+lJgEPcThbSKpmQGsxm/lQj6wUoB1VwTd6yiOZrOOLSMmrwRP1ajMYP6LcjPInDMryDnIapBthQ+MRKoOZJ0i1076y2/+DV2wuUGOM9vYUb53zFwTTco4KqPyVUpauvpP7eYPGV3ZIJ3MUdniDVEKY4F+ZqFYlCn5WuCc/2zgokWyWLhHLMrrmHgov3YRyME8vTx5mBdK4YzCbilazxLzsCfPZ1Ihhfl9bO36bzI+8c0raCFHP00wYigTnZlcUwsXa5eQyf9vT+y7isvtxfZwhGZVt4cJtuNhgntIKZGfYqlNQycqXR46h26/y5PHjCjm0Fi9dqPkt0EpLE7S9Emi2OYp6CzeomHoOq70KyyxVWIXqX9uCjnk2WsY48BU9ugquzVGIVEm4Be+NDfj3mr8sBEjXRsNc/BpPT47aNPzNDiLtvqo+6yf+fnDJ1PZWgxTFzoVBJsfG/oDW8YVB3CNoa0rhB6k2O1Fdz3KKVQ4pYkNgjL6kOB/tS+d2JmYdcFwI+TDM1DjXozZK0PgjKKQoS5zbrxkjWSHEz7EI5j89PfcZouhwsQAbz4XQY3phVJGhT3AHn+YKCqVaSuKv+CnNCJNMW/d04+1rN2WKkHyD
 CFsCacfc
 AUsE/rdJiT2sr4F6s1L/OTWQeV1qDKT90e5sThJJ2R27RTj1xFl8OJnEmYM6bkU0r2mz2gfIu2U12nSpRexT13R0/Ug2igh9smR/fMLZDuLljY5uwTMtt4rEi9Hed6hFxh6C5vV0WjtcyPguAoO0slVfZz8/Ef+VxMNVxwqlclhJFQk6dzCvPWPI1bls/ElMxx43MBaNliB0Qjv8Dq81aaKwTqo8Y/5pTpYEiRgbM7xOo3ylrFXIitmlg1tSTGNdDos9cRuNyZNSzRQuJjrmKGMoGE7eCh89NL8/vuYVn3i7/WwCb8rox6nQdbGd918wqRezY/7wApBSTmte2aWtgdSokNQvDxn4S8xoHerdkD7lKkf5jDET0vM9ElQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/21 23:58), Yosry Ahmed wrote:
> On Wed, Jan 21, 2026 at 12:41:39PM +0900, Sergey Senozhatsky wrote:
> > On (26/01/19 13:44), Nhat Pham wrote:
> > > On Thu, Jan 15, 2026 at 9:53 PM Sergey Senozhatsky
> > > <senozhatsky@chromium.org> wrote:
> > > >
> > > > On (26/01/16 13:48), Sergey Senozhatsky wrote:
> > > > > Currently, zsmalloc creates kmem_cache of handles and zspages
> > > > > for each pool, which may be suboptimal from the memory usage
> > > > > point of view (extra internal fragmentation per pool).  Systems
> > > > > that create multiple zsmalloc pools may benefit from shared
> > > > > common zsmalloc caches.
> > > >
> > > > This is step 1.
> > > >
> > > > Step 2 is to look into possibility of sharing zsmalloc pools.
> > > > E.g. if there are N zram devices in the system, do we really need
> > > > N zsmalloc pools?  Can we just share a single pool between them?
> > > 
> > > Ditto for zswap (although here, we almost always only have a single zswap pool).
> > 
> > COMPLETELY UNTESTED (current linux-next doesn't boot for me, hitting
> > an "Oops: stack guard page: 0000" early during boot).
> > 
> > So I'm thinking of something like below.  Basically have a Kconfig
> > option to turn zsmalloc into a singleton pool mode, transparently
> > for zsmalloc users.
> 
> Why do we need a config option? Is the main concern with a single pool
> lock contention? If yes, we can probably measure it by spawning many
> zram devices and stressing them at the same time.

That's a good question.  I haven't thought about just converting
zsmalloc to a singleton pool by default.  I don't think I'm
concerned with lock contention, the thing is we should have the
same upper boundary contention wise (there are only num_online_cpus()
tasks that can concurrently access any zsmalloc pool, be it a singleton
or not).  I certainly will try to measure once I have linux-next booting
again.

What was the reason why you allocated many zsmalloc pool in zswap?

