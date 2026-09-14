Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3633C88E78
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:36:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDA036B0093; Mon, 14 Sep 2026 11:36:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8B046B0095; Mon, 14 Sep 2026 11:36:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC8A56B009E; Mon, 14 Sep 2026 11:36:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BD4216B0093
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:36:30 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 21363A0184
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:36:30 +0000 (UTC)
X-FDA: 85212769740.24.3BCDDF5
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf01.hostedemail.com (Postfix) with ESMTP id 622F440006
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:36:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NtTPJasx;
	spf=pass (imf01.hostedemail.com: domain of aethernet65535@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789400188;
	b=qsNQxKsuELXGDogbDa7VZr3q4IqwnvWFlLIpLLBahnn1y6yrfaJ/XPWFylMxKf7v0Y+fUs
	SOqO3fgeM1jaLIi2obRqLdH/iQXjuv66TFFZVPAAuuh77+dDEjkGPcSQyBPjVjNmGSUkS+
	NRGHkb0agd6r5st080YHjf3dYiakyLU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NtTPJasx;
	spf=pass (imf01.hostedemail.com: domain of aethernet65535@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789400188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZuYma/Mvt8YazFkYyYSaJ6fwaVS0ky7SQWLme5KxC8I=;
	b=YJ+G7rMHR3/uGhMQq2yvQwVGbqyx3h4EUQi2nePbMNSvO32Krt+sB/u2T+rp47THZD9aIr
	X7cA74IhhWcKb/X5ZssXiYqH3PpSweStQ2p7mhDg+x+OfDHjM94GVsh4FsZehtIOQWq54g
	tu/ba8lVaxHkrlDfQEJtc1erM4N+oNk=
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc4d04d73b8so1656805a12.1
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789400187; x=1790004987; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZuYma/Mvt8YazFkYyYSaJ6fwaVS0ky7SQWLme5KxC8I=;
        b=NtTPJasxcsTqnI9JULaR2mzeR7wfKKBTxh7XRMY30BOrkL6OkBlyv+KrIQsJ9nezPS
         wTU3F8ylsiunqQDXEPpuj4Kq2/qBFRKOgyWdlcFo7tK83yzzwJXQq3+UV7GP5Mboyv3x
         y+RYVNE3yOVkMTTvzvYh3+7zK3QmRI04hyDAZ4s6B7xjdNCO/G9nC+PWR/wlaoKEkZWV
         HYzZbCp7D7fvwJ7/0dvO8NXuzR93ZzB/5onCiofrMvXlN07AHAglGK6HpsuuXsmkYNT0
         rnDaqztAYpzXI+zQS2JjhXqViy6t61MRJqZDAt0eAduD/XNl5pAtH/2g/cy5vXF7F2yp
         7pqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789400187; x=1790004987;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZuYma/Mvt8YazFkYyYSaJ6fwaVS0ky7SQWLme5KxC8I=;
        b=Gr1xcakdRn0FNzvL7w0HtYf9wuiT9FryBhI1oEYowwmtYQaN+LnrSZ5Lgg4azwESOx
         lpTQG3Ky2v/t/n9W0Grd/5zSDEqDa13KOf/bp5V0m52ByGHNZUB7ZiLiUukPe+z+8mdh
         9U4nQjiG9/l8S8Idpd2WWuWkO5mbeNz7fBbggIX2W66DKkPp+zjgYHL3aGUpdzOSacCQ
         D5KWcCU1jUcxqhn48V2XncR9J7nksZMxUa63X/jcTZ/jbnm/UAf4FbJwWwGcuICUshku
         WQ4LRaoKQAxLUlNAlwNnZmZr2inQjBQd4H8k69AF2YI/4t/jfjjNek9mT6IQy01OgIu8
         +66g==
X-Forwarded-Encrypted: i=1; AKwUvBxsukjlPpRXzhov9YiEbgCRvxnifIEOF5hPpmyH1/RMx08wZtkXkjCMmIF5ajNZnd9NAHRGvJOYJg==@kvack.org
X-Gm-Message-State: AFuF++nJCYNTZDc6krztRk0VnU8HaR90DqqUsmSXL0x1xj9i80C8hHc7
	lQfbd3f8++hmkiKWzrqEjwWXzEQtTFBpUK2f2DmX5RxY+1WbGHBcTN2o
X-Gm-Gg: AYBFou0wkIu6BF3ZR6OCZFv+speIasd2HoEOMcaKgqFNgKq8Y9ESAoSlCtNl9eGyXdB
	Xr0FbRW6Qdw03xCBkXrE6+ET55tMvryVWTW+Pizk0z5FUhiwCZytHN2/GvarL+wQlYnOC4zBd3W
	0A9ei8YM5PmNu03sF0KJyYM31F4lyb6kAVg9801qRl93Xp4ta5ZWB+R/+UVZI5KJ+Pekx3a/Det
	DslJhQGW4DMetJdmmCV4yymSP8nLNcY/uNpauhkRc76WnUXsi3xiWFgTL2dVWU13NHVDpsESWK7
	RPOm6tVoL91EQRVP41bsSXpBP3+xbPeYI+VJP1aZAF9pQ/1ZEfqBIopJ+cymBXRpGewdE6qQi4c
	HznpJXTdJdju4Y4ZpANGxyRxyl7FCbjrXf0KoahIUwLpFzzPuc/G4cXQ4ENh0wtDJ3+oSwMLynZ
	vBP4z9U1GSr9Ns87uY1A1phawAfcF+McyNf1uyL12FnDwJYLpZU0tTkqT+gVmc0Q4N6pj1N5kd4
	cc=
X-Received: by 2002:a17:90a:1002:b0:39d:eca2:5c81 with SMTP id 98e67ed59e1d1-39deca25ea7mr3712535a91.8.1789400186941;
        Mon, 14 Sep 2026 08:36:26 -0700 (PDT)
Received: from celestia ([2402:1980:8858:8cc0:7bda:d54a:257:22ec])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39dfd6b9687sm119410a91.0.2026.09.14.08.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 08:36:26 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [RFC/Discussion] mm/damon: Implementation for paused kdamond
Date: Mon, 14 Sep 2026 23:35:10 +0800
Message-ID: <20260914153640.8481-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 622F440006
X-Rspam-User: 
X-Stat-Signature: urqdwpzg1n89af7xczq511dy3kmmpzge
X-HE-Tag: 1789400188-980445
X-HE-Meta: U2FsdGVkX19yv55tb4jAOYXWtefaDK867FcS707/yCPApeSQ8Tu+JFyRB7fq+Vzw2sreLgOw2LVsHDrkXw5N9c2R0HRPP5UGYbTYH8SUfKKXpDCb9G1e1o9PFPzUXEDn36X07L9a7mvMoXo/wOJ6jBTZgEbC1da86nXtRNBqUx6u97oDVaVf/hKzCO8b/9BUVC3hVkF2hYqvOLupealWPGeqbzC2uq/teN1YbcFK5emvvFzb/b7hwaRDOqwKJgDnS8qgkwJJAzdaRnUg6lIz4bAh5/fWGtZzIly6tEDa66w1OKBRduxweIH/p4nIThewE+gTRqfnZzajje5OpB8PENd52qKQ44wkvt7F/DPkliVs3iUo+gaZyUBdkSCHM1WHBS1ot3qIuZmIB1W2KaG/UBJjrcPabN2+oMyknJ1fZ0k/wnu2W6D+qCAiIDEwy6G6bYB7n2a4wnkXvzs6S+6IC+yeLjlOSkEt4qUEt7Vr5dUIwwYME1XNbNwXDxBcLg/ReYwYUUDffaH7PncZWG/wNjEVNp+ubHUQo4NoX7URzDqJZp3mtrCYe4/pK5Cf5l5BuF65smdzaNTHtrMzdL3hUY2G3vUBl2L1fOL+Akqfvfnqhj5qUpOJvtxJH+o18L5t6SjTz44mBdDR9oD2Ssi4xSHET28Zp2WpxxM4xi5qMT2LTinw982jTObPY/v/WdkETYBP6QBjBAeoJph02jcqlopLgLinBsHsiPXRlWQdgtbIe2ah/iJ+VIX5zIQog8M2uNKPZyi28mrxIKIUo+/+dHS9Uj1mCKCTeSiX2/cadSel2lXVyDy625KoHZZaP1MOxue4lkwYTo/M+BCPYPJOx26WIx+uwOchaOEx59AQGobWE5iztKjPzrpxGooOPb/H7LxEoHK1n7qY4NQeY5b9t0kqAbZW90T6hOQo5nT5GewVF2htljd8yH7Q/ND2c1QtLcIR7gU5/c++7N6Ut3q
 vXClhf2y
 O1Cz8DNU73qv+O/ZA5hFdDfGykIRlkrC8E+Ifb4h5oJ6GVcXuex2z3CIy3wfOLy5dQMUV3SfSE8nKKA84iQLzyzAo3cdnzBVRWzd2CQi2mZ3hB5J2sSlKshWFBqCp9LTr09ujNz5xqK8mAotIGLL4nCfjiBJYnjw1xigjw0DbQzdodHnV0Vk4gUBp1YV2iAGhm/kxxe3zHx3uimFBoJIFcToDpTo0Lh8JtchBq1gN9FZQuCbL56SynNVlJ6a0FfkKh6npJNLBAAeUOJzkohwZ3Ly2fXZSeJEfBsosSfCi37otmzA7vl58TlST24oH/c/gF2fyf8G5AIGo5LHHD16Cy+r94tN17EbA8Sb/ID8bsSxEY5pWOpT+vuZG10yMCZX0DLZrZXyJ1a6lduo1KPV4u+1Y7EdEtolLFwTvcbJ0u/C3/ORw40SsFXcdizH7lGZwO7VhVnsnuSYrZxs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

I noticed that the current implementation for paused kdamond is
periodically applies online parameter updates by kdamond_usleep().

I'd like to know if we should change it to waitqueue to achieve a lower
power consumption?

Previous Discussion
===================

I noticed that when you introduced ctx->pause [1], Sashiko asked the
same question, and your response at the time was:

    "sample internval is 5ms by default and recommended auto-tuning
    setup makes it hundreds of milliseconds.  So I don't think such
    change is required."

I'm curious that, did you think it wasn't neccessary to change it to
waitqueue when it was introduced, or it wasn't neccessary to do so even
after it had been introduced?

Asussmption
===========

This is just my assumption, not a real use case I knew:  When 'pause' is
set on an Android device, user might want DAMON to stop running
completely when the screen is off, thereby reducing the load on the CPU
without losing important information such as regions and age.

The current polling may make it harder for the phone to enter idle mode,
resulting in some unnecessary power consumption.

However, pause feature is only present in the stable version v7.2 or
higher, and since the latest Android kernel is 6.18, this highly
unlikely will affect any Android users.

[1] https://lore.kernel.org/damon/20260321202858.98091-1-sj@kernel.org

Best regards,
Rui Yan

