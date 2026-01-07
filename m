Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D2E1CD5822
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 10:15:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D04CB6B0005; Wed,  7 Jan 2026 05:15:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB2076B0088; Wed,  7 Jan 2026 05:15:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8AEA6B0095; Wed,  7 Jan 2026 05:15:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A622C6B0005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 05:15:03 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4F8BEC0900
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 10:15:03 +0000 (UTC)
X-FDA: 84304759686.18.ACF8ECE
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5923A4000F
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 10:15:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=dhv1A0HK;
	spf=pass (imf07.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767780901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8bceZUEvCu5KrQ/L330EZO18iOd4Vxp4vClh5tI+Gek=;
	b=bJlECJWflt67EqXp9oXzqPb3aBEzQ70AEy0YTO/Nq5LCh+O/SyTqHdVBC3A3m+4aGMiUKw
	2Ncz3EXLbFwZhWRP9pES5tYX7X6+usUwifM8aOqK/aGpLPNZRtjB3Qb/N2HO/WyPxBe9Fq
	c9Ypna7OnASorOS4D+/JVRPxSal8AUQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=dhv1A0HK;
	spf=pass (imf07.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767780901; a=rsa-sha256;
	cv=none;
	b=dPUlVNuLz+wHfPUy5q9QjjDxSVWTy2MikD265OqMrX8VJS96hj+3woghMZUL98muZ35nK1
	F5uR95T0wcn0mRd8JoKKLEyzr6hc8A/96LsU8IyfdFukK76hj1p4/hyyu6M2mfAet5k3S1
	/ZZo/LynuyE3kGf9TT5pZPyZQdK0H/8=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a0834769f0so17258915ad.2
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 02:15:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1767780900; x=1768385700; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8bceZUEvCu5KrQ/L330EZO18iOd4Vxp4vClh5tI+Gek=;
        b=dhv1A0HKZXULTjg1l3WfIvCtC2i2ZyQe0zPnMVNjzuOxjwa15x85qZbn+A2tVSnzOV
         0RdtuBC2nII2/YjL05tzDSBR5rbOFIo3oFuxj9zygSfiyjJXdtKjH3Z72TwmdWx2DMoM
         C3KPejUEwfR4LXrvasZF3qui97T+QRjYwbGEY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767780900; x=1768385700;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8bceZUEvCu5KrQ/L330EZO18iOd4Vxp4vClh5tI+Gek=;
        b=fm4AfoaalMrhR+Vw2GdkXmkH47euX231wYBz2JO+197NqoZ2Ogpq1pL34R23F9GRbK
         uDhQTTjWYiszRQbU2ytE4R2On1STzp32p9BVeSsOA/Br4WVdhj4xzT5a+hTH9nqCeqSA
         jVmljrctC6ZZ5Gr//uWoP2WRHb0dlwFQV3wLEg3h9l7EKOec3Rlqa0J9y6B74MkbQeg5
         vcElnabE6IM1sLfiilZpo06TPq413x/+QmCu/ycv3PWAEOH9UVaOY52QcZb0KncWpOJP
         WUStjx2QQ9XIAF6hTnhlzcxbTgiothkvM3un7EN0OnajCVRfouPV1gPuJIkAJa+/5G7R
         /ZDA==
X-Forwarded-Encrypted: i=1; AJvYcCW7kSNvN3CqWoooqSE4Y2eEuHyZLu5ku6rwKu7GIDFS2AH00bVEQWBsbtdeXsFRyHs2zaGI9QfSKg==@kvack.org
X-Gm-Message-State: AOJu0YyaFI502zcYqKwA4KVZcd+GbMbaj5Ph5oScz8tmDZ2tupPQxhMN
	fat992BR5zePX/AWmvQCzb8DrA61GOG+Umo0oZ+Hoxm788+fUgrowUAKLC5QpP4oMg==
X-Gm-Gg: AY/fxX4fbG7yeB9EezdIbzX3JbqCDpyhYNHZaE+5W7SO3dOD4owrfrQWhXhy0VsX1xF
	kIvziQwtwKkJN8q5BQdYqgxs9V/ZTX8pZi+GTR5kmM/AAqOnXHiMYAvcOk+0gSr784aN9lD2jK7
	fv9PA1WjpXcuHdsldYQi7fbG4mvBVIU2uT8akd1VsoGuB2rr8m63tjwtLqXxCm6n/gdJHvLE/Yb
	yNlgLgCjWf11+itpfu5QWOQats2+V3jgIeJbdAUig7Kt6/ZXnawJ9CdJNe92ckp/6E6urloZb4C
	uVkVrlP9P5hM1YWFBepbKIC+FHxebLdA07uzvRz+Ea0XCsmZlnIU4XB7fJ5cxHRSNkYzzWm59/0
	5thEUgVnTHFNIpxFd4md3BJ6kf6zcDnRmCDqjiSkmJ5SNHLM+srz/ynFJI4z/Fb4TpFKZ5HiZ69
	xNFZwunjzNs/SYHUJ8vx8AwTEQ1/yYSEN7rE3kbBpoPXKwiFyJ4sHWBNxXq0+Gzw==
X-Google-Smtp-Source: AGHT+IFQ1af01hhk8mScP/1n6gA5Kz+2eLZd+kVW9ydONrfQdZgC8g2moml33TCqjBCfPWZdXb3RBA==
X-Received: by 2002:a17:903:2ac4:b0:2a1:3ee7:cc7a with SMTP id d9443c01a7336-2a3ee43434cmr16758185ad.17.1767780900130;
        Wed, 07 Jan 2026 02:15:00 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:7bef:7c13:79b4:e9de])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3c4795fsm47255015ad.33.2026.01.07.02.14.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 02:14:59 -0800 (PST)
Date: Wed, 7 Jan 2026 19:14:54 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: zhangdongdong <zhangdongdong925@sina.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Richard Chang <richardycc@google.com>, 
	Minchan Kim <minchan@kernel.org>, Brian Geffon <bgeffon@google.com>, 
	David Stevens <stevensd@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, Minchan Kim <minchan@google.com>
Subject: Re: [PATCHv2 1/7] zram: introduce compressed data writeback
Message-ID: <z22c2qgw2al73yij2ml2hlle2p24twgpmz4jemfqhjoiekc65f@pvap7olsolfp>
References: <20251201094754.4149975-1-senozhatsky@chromium.org>
 <20251201094754.4149975-2-senozhatsky@chromium.org>
 <40e38fa7-725b-407a-917a-59c5a76dedcb@sina.com>
 <7bnmkuodymm33yclp6e5oir2sqnqmpwlsb5qlxqyawszb5bvlu@l63wu3ckqihc>
 <2663a3d3-2d52-4269-970a-892d71c966bb@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2663a3d3-2d52-4269-970a-892d71c966bb@sina.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5923A4000F
X-Stat-Signature: w4twwbcqdxgtj3qhqswfniu4i9kb1ys1
X-Rspam-User: 
X-HE-Tag: 1767780901-739964
X-HE-Meta: U2FsdGVkX1/K/cQ5YHOeAmj1pJUEO/4e21WjtaFGmFiVaj1ZvkykIdgvpGJXsWBlZTfOnaF5QpRqo+OZoX1GN0PnDleLIIBL5AVNLi1RIEQ0BJlUSKBkiC2RpsMzahu+wCBAbJhv9xRKkkwn0Z3oxwl/Tcjm6OzyODVDzlsBGO800GkRKmJdF3nWzrCHym/Q2vw1VM9gTnVzrY4+PM6EgQ2vZADKJ49xyU1/rELGGTBbBfV5DO6JwR753e07uAMpCDrZ8BuN3dPFNGtmzwcwIg87DGMabezy6VO/iIAMI6PywRLY8UMt0thT2/kzmcifpAAcMRN+c89vCZz/SIzoCWgItXTT+4xfKjs4HvsM+r00/YeArmLEkYR2TSnOlF6JqDolhBXXnaqjkqVLWvEDD1dW+8RkkyXWOh+zMMW4Ce64KsWdDZchWADybyP4jn5lgZe3wh603Hn5ZRUjGDY0SjtDitoVdn+8l/Fodv/dufJALj23qJNneeSW72+wqeSD1d2pNdqZpW9zw4nwzJt+z7Hwwga1gQ8RS00B8yohR0S6uRoQbDTsu2fAX5ntNQ6EvXttNMo68YI5paJEQ+2v5Hmt2TmVB0g+qC2aC7x4n5glKt0KkFfLYQvNxFoyMoM+m3hKAwL6qeP9bK86p3o2wAuaWggIwi7dtnz6LDgNdq4xZ9ifvqYxG0IrYPaNpOD80KXzdG9yl5zsxdeqDOGig5/kVezGbKMraowlCYM8o5AOYBXB1B1PtA1ikPQGBOi/FsF5e9c0Hk+pvki/QkJ1IWWEd5Sr5VfEfPB6iMUwZuhW+IMHh7my52vV6/qf7kDN/rONJJX1APkFRuLg4PxfSTln7YlZ5OQSe2LqoNyAtz/UNPGnbN3aUlaajeu0/M58TjCt71dX0nE+Z+wE2UWC/TtMSLTM0c92qaIojssR0rxOMIh4PBZ2uVnbHHCoWWRYIVvAOdRy6mmtT7MK2D9
 6yNtJP8a
 Oau7omUW0RNU3TeqKQ77ZaX/msZ2nFibAqFdCkP+tYHu/WGKF8LudLTxsiXiA79o2pP1Xp9iipucII8ngJSsdXk2RxXzkEVmycREoDX3pYIGFL+zSdbwTB/SNTe4XJkG6Qoubkj8pZRlyN9hF7exrBAhaDzq+WmVCnHX/CFHHfL76IrkRQO5+lfZ9wbUOImySayzhW5RNtQdC2NCP3tgeI/0Z7lTbp90mjPCbG4Te97XvR2jgcuLB3vNTlpBa+L2PJ1bcf21QXNklWIaE8UAcX7020mZYNBxpXJhclQL9vKxwFpo//ldBSVKXmjbDtlAMsc2AItmKVbX0f5GbKcOyvYp0fFHdJCA3VttkFlC1yd3HgqE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/07 15:28), zhangdongdong wrote:
> Hi,Sergey
> 
> Yes, we have tried high priority workqueues. In fact, our current
> implementation already uses a dedicated workqueue created with
> WQ_HIGHPRI and marked as UNBOUND, which handles the read/decompression
> path for swap-in.
> 
> Below is a simplified snippet of the queue we are currently using:
> 
> zgroup_read_wq = alloc_workqueue("zgroup_read",
> 				 WQ_HIGHPRI | WQ_UNBOUND, 0);
> 
> static int zgroup_submit_zio_async(struct zgroup_io *zio,
> 				   struct zram_group *zgroup)
> {
> 	struct zgroup_req req = {
> 		.zio = zio,
> 	};
> 

zgroup... That certainly looks like a lot of downstream code ;)

Do you use any strategies for writeback?  Compressed writeback
is supposed to be used for apps for which latency is not critical
or sensitive, because of on-demand decompression costs.

