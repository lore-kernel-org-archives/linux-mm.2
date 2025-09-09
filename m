Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 889B2CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 22:39:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C387B8E0007; Tue,  9 Sep 2025 18:39:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEA028E0001; Tue,  9 Sep 2025 18:39:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD79A8E0007; Tue,  9 Sep 2025 18:39:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9ADE48E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 18:39:34 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2C64D13B31C
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:39:34 +0000 (UTC)
X-FDA: 83871179868.21.6D3141C
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf27.hostedemail.com (Postfix) with ESMTP id E015140011
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:39:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025082201 header.b="TvOUc/rv";
	spf=pass (imf27.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757457572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o4pJzl4BWqncjRLwqdCVSmCaOJCq8m9Ifms3vJmzKBM=;
	b=FBt+P+X/ljfyxdpajQos5MwZHWNLhskVQKO2ETTVTEbvfW/oPJSdPB0lfr2Len163SGB6p
	eX8VL6+NJrl1d3bIJjtnyExeJ61tXBk/S0rm9cBZiCbSFm7h8KM/thNfBVjWe59jQXZmhP
	xX79qvmGpTiamv0XM68++xijoO7BEnY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757457572; a=rsa-sha256;
	cv=none;
	b=vo98K0wxM4wF1UjhfeZxjH5hYDX5YFBgvr1jNZeCZUrIBNSpdAjUNvtimyxTxN+iBXGD7j
	e/p6AttmIu6lByWk0z/JH1Hnw9y8lDPIDVAt4sPwjyxTSxZssvbWZcAZZA04qtQySNI4dK
	q17NqI//63rzSehjpH3zMNXeE1p5fcI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025082201 header.b="TvOUc/rv";
	spf=pass (imf27.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
Received: from ehlo.thunderbird.net (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 589Md5a71810392
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 9 Sep 2025 15:39:05 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 589Md5a71810392
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025082201; t=1757457547;
	bh=o4pJzl4BWqncjRLwqdCVSmCaOJCq8m9Ifms3vJmzKBM=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=TvOUc/rvPHuoAgZik4kP6Jrk/1+TPY9+I66slCEYRMAAVaJliSrzt+2sOFL7uxfep
	 TkUyZI254fJRZ0lrODF9atINh0A8S4jLrAmCkJHU6JXLFZKZC0KSUVdi0tmre9KWKN
	 XbKdciAhvqcaNOwc7fFmyUBOA5BxnpqIS4Eb0rGthQiBgS5HHj+CzVzQJOWVF0iflT
	 tgpvUETHe9/40V2F6BCYuDmvwT7GfqNk48CbFXskPApkAJTXDi/C8HYPbnObeJPLQM
	 4VGzdB3lbm4UCWwMufH5gTZgR2KMO3DzwNg9CgZkrpc9Dml+J/eRl9RSkkGtbvpN2l
	 PQy3pTIde+vBg==
Date: Tue, 09 Sep 2025 15:39:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Arnd Bergmann <arnd@arndb.de>, ksummit@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org,
        linux-mm@kvack.org, imx@lists.linux.dev,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Richard Weinberger <richard@nod.at>,
        Lucas Stach <l.stach@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        David Hildenbrand <david@redhat.com>, Mike Rapoport <rppt@kernel.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>,
        Ira Weiny <ira.weiny@intel.com>, Nishanth Menon <nm@ti.com>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Alexander Sverdlin <alexander.sverdlin@gmail.com>,
        "Chester A. Unal" <chester.a.unal@arinc9.com>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Andreas Larsson <andreas@gaisler.com>
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
User-Agent: K-9 Mail for Android
In-Reply-To: <CAHk-=wg0bp-_kqmfaDYQLRJO30LYxEsMu3EKi65sKoi83EUZ3Q@mail.gmail.com>
References: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com> <C85C32F4-BD58-460B-ACCF-F0569ED0941A@zytor.com> <CAHk-=wg0bp-_kqmfaDYQLRJO30LYxEsMu3EKi65sKoi83EUZ3Q@mail.gmail.com>
Message-ID: <F6A7C7F9-54F0-4E97-B21D-FD0EE023B986@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E015140011
X-Stat-Signature: f1napkjgofz3ugcxxeuerc8ot91yxg8j
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757457571-527578
X-HE-Meta: U2FsdGVkX19AGLdNdzRlhCxfcvTOKBcFkV4uWaZ0acf77uSQRv4HznhEPbdYa9Zjhjt/b+ntCCrBIbmlhMN3C6HoALuXMJ4UkW1RZb17hRAUfp1p9qSFUQrmkvj5JBnQdurZvIA9KSjbQ22gKJmVi7ASRtvxMVFNDq9IgOAw+eIHKlvVKnJiFdZQ8zAv1BlQ9EWb/4lUY2Zg9FFcrc0w8nZTHYD8jpP4BYdU/+Ewjp9U83dLGk8m5FJw/QpVVAuLT2ofaSQZf6cDeL6tn5Vz8GHzPFpgwFO7ECQ5yXBi8wjl+ZOKjsNWI62TkSU8/wofoG6trCtuzBzzahYY5xCbXVdwKivnzh0eFmrciw6VFeNv6iKs7/ZO1bnDRwiOdqKSJMiQBTpLnBzvnotdtuPoY22iiw9RKm5wkUUp7xZVIkZAOmfXPMv4FhlXwaBa2tCGdU0wXT+bS9TU9kQdoTKZTdVdQLpUOhwTLFUrD7x1j+HInOIEVmMpYocNkyy1AH5+crvtuGK+xVdtvmcyPdaSQ21hB56NsE2qs5t+iwTDo5Jahax2jJPU+9EvLh6Ih5cMlblgBuny3YjcdmoO3ZxO342BMme6GvxchTY0TXIxSKd0kpj/0zSGioQS2zaUIEgM1MhIbFrBQxBP0fR8YkwfqMzutc2P2d5att9MTZvve6AHTx9UG6Lu+T4KgcyPQ9XoVzVI5jZ6b35g7YmGaG+2Ij63YZUGeVOwLHUj4GhNZQzxe0RTDK8TZexviZUD/DgRPnzjdypj1nyMugjb2Q+cSotM9jxVh65Ii15kWE3elxEjMlqle3QTBxyr3X/ypn9jrOe+3ApCu4A9nASKuOtXy5DeOapdlybqwi2qmvplnjcGBUy4pcwBlcC7+XSRIrjVBgypAwr/BWfiAfO4846qZZ2MFwqySLCyTkPj6tqo2u1thUaM4x76h2WAHndPmEVESdwNuqov9zMK+u3uDv+
 f8XCf4Md
 kY/xvXo8PbZHRJi0YoM3RWCkYFIeg9taZsAH6+C4nKYA6PpmB/IOazMewZJ2Ls5K8D00FXOPNFZ0zMqvZ1fa8GoX15G1QDVZ52rNGGdW/WYAKt2fH/Lp5j38pY5gVCj4YHLUNtYxoSDNg+B2Giqw9BK2PGR2yrQ1YNxQ3/3iSYTYeRMRONuLN7rNwBTwWNJY+7x2mZ9y2Mz6eZBhOLPEgjnfheWBb1rUeZ1+pasHvgjrK/XVjpLuQEvjJP1EHQXiFRYNX4W+YYEpLzjXkPZRGvp3RKimb4jGV5J4kaHpiupwEn2u2mfpbE+EzydKUnFkWctUOvath8t0DYSQzKfYsIyM1WN4e1kqBwsC3DApKqBSeSR9yVVqhxc7LEzk8wtwQ5TsIRx0d6y3Cu1gG+k9NRJa6lvjVbkRpAZRuZaDkWKsv2GTFa0yrqIoowAVi3erGvbERwU/PfkqCdT91BLi5IVoTsM4bhtpSjcQBHlBXp4OexeU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On September 9, 2025 3:24:29 PM PDT, Linus Torvalds <torvalds@linux-foundat=
ion=2Eorg> wrote:
>On Tue, 9 Sept 2025 at 14:39, H=2E Peter Anvin <hpa@zytor=2Ecom> wrote:
>>
>> 1 GB systems used highmem too, sadly=2E And 1 GB was the norm for a big=
 chuck of the late 32-bit era=2E
>
>Well, while on x86 1GB systems did use highmem, they'd typically not
>use very much of it=2E
>
>IOW, they'd have about 900MB as lowmem (ok, I think it was 896MB to be
>exact), with something like 120MB highmem=2E
>
>So they'd either lose a bit of memory, or they'd use the 2G:2G split=2E
>
>Or - and I think this is the main point - they'd stay on old kernels
>like the ancient museum pieces they are=2E
>
>I'm not convinced it makes sense to have a modern kernel on a museum piec=
e=2E
>
>         Linus
>

Certainly=2E And the 2:2 split is probably the right thing for the old mac=
hines anyway=2E

