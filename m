Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8DFE106ACEC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 21:15:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56DD76B0089; Thu, 12 Mar 2026 17:15:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52F236B00BF; Thu, 12 Mar 2026 17:15:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 430D26B00C1; Thu, 12 Mar 2026 17:15:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 351E16B0089
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:15:25 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D2FFEC1C40
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:15:24 +0000 (UTC)
X-FDA: 84538666968.05.33A412B
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf02.hostedemail.com (Postfix) with ESMTP id E85A880015
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:15:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FNg6CR54;
	spf=pass (imf02.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773350123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=csK1En/4fONGq/lr85KpbezFYh469Cwgl1uC4F6XmcI=;
	b=U+3K+K6+9K3Eg5PMlcKaiFmAUd1jthE6bH+5pWUq2cLzNaFm9gV+1sPkVcdQ93mWfNvEKx
	AcNQFMifrsdUdJXOdGmE1HHdztt89i1NXtAQgWy1Kp8lFOhZkNIIROmoKyojvneYPWLIoF
	J49RpZl3M/1cmxSCDf5nl+f4wmWubJ4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FNg6CR54;
	spf=pass (imf02.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773350123; a=rsa-sha256;
	cv=none;
	b=TahvVyCz6g352W7Ja4rmMMMe9V/pNNB9FiN5vADb/EmPFcNSFM+8Eyaqsf4wdZoiZtGVSm
	Rs/xm8rw6p9fVqeoofJ6xe+Bb+CuCmImnTmsJ0ywEtIvC7bYL5xwHZ3b/kWHTSA92AVlYA
	hcN4VMKxbjpC6esik4UlJ97oZKwEGys=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-483487335c2so13084545e9.2
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 14:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773350121; x=1773954921; darn=kvack.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=csK1En/4fONGq/lr85KpbezFYh469Cwgl1uC4F6XmcI=;
        b=FNg6CR5497T47Fa4w7eLtdLR52wBj7o2Y0fzszJRjWPfyZl2LdQHNYFFapHznC4fC+
         v2c9IJih+G4nuUkUWJpvK2Iryf7aOkPip1xxp5JL1vuWaQBgYOG1yL9k5oNqDZ6NAiyK
         6WETSCSuJv0Tx6TERTnFYyXhdhogeASS41rTvomipQMPGbAN6TvQLTRMmzE1oEnAfnd2
         qXeaTkQAdFWr1wdQyUfRk2fXas5ptiTBILV1h5M82FoMmwBSF61tTXJBdgD7FMfrQoZk
         kOyRUuifTSWEJ+wRvHOEo2ciX2PZ+lFikZ+SRRyjnq5/OyV5gOAWGS14iadDGqOHkTEd
         O5Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773350121; x=1773954921;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=csK1En/4fONGq/lr85KpbezFYh469Cwgl1uC4F6XmcI=;
        b=A18kcgu18amGopKEstkOP++DhU5BKTalc+P3kWZP1IW93vUXWTwCzTMrbqY8E876Rf
         px6pAJKwZM87jUUJomoqjbIv6i84LMBnehk/T+/1uoLpARQtL+tu8M18yEQ6ViOOUx42
         QtwbE5iEkWw2g/Ioyzm6aKX19D+qMetUXO40Kn2KJlmZMyAO2ClJS018uN3a/SK/iyAv
         V09/UqtJN/XeU9njuq06vqzym0oEqQ4KyXiYmBRve+9xn2IGj27DAB8snVskOBkNHpPs
         n/UXviuVQJIde3Eiu7S8pGn7dOKfZjq4os6SnnUVcEblie2t5760YW1ucIv2S8Of809/
         jTSA==
X-Forwarded-Encrypted: i=1; AJvYcCXqNHo3unkTC7MsqUHn+WTiueq7+PsYj53K9KpjL44T9CScHtzZW7ddSPpKASe0WFZ3wxPdF7YHWQ==@kvack.org
X-Gm-Message-State: AOJu0YxfvVpLJzNAp64N7MgjH10PAT+w5mf4xtLLkFM+M92QFd1jkqEn
	vZ1tvsZGluoLnlc0Z8QgcJ6YE3B2jTTNZ9dsECjXYgFzrlGbiVUZwGVq
X-Gm-Gg: ATEYQzwuNLgzErdNZSKAHM/M9itvpr7vWT1WY2agrBSn9L62oBa4cZmRj4qxpLot+/j
	MlEv4UMQtvCHzvENPAyY+0Lyjw7QZXHomSxKqmJnXb7/FC+C46aRda372E1tPBW/nm2BnJtKvGo
	HIW25g+VWhTXG4Ali2bFjQGyfj3arIr1NJAbZpXx+O5OvgVSeRo53o+5prDRQSL/N4MsaAof43P
	/oLtx19lduBS2nK6uFqf2kKDoWvvus0TbRimHd+ECb7eLtW7Zk4MU9s7RVd1p9dQIryU13RU8Ty
	EB/sdUhhe0AdGSIhenv9u4FGMWdpU9opG6NcqMwBZ1XsQtkZB+4YcrVjjz5Ot/3E+H801hPcOBR
	LH6DTtI2nZUrp3/LZaYim4ijcSDiRZ/FFm+suJnt391ZHez8vOXfFWbhOe4nxO03AiWi1MJ8oHo
	RC3XDvNNkeG0wti25VB7MlQ4Js+A==
X-Received: by 2002:a05:600c:3ba4:b0:485:3f72:3230 with SMTP id 5b1f17b1804b1-485566d936dmr13803785e9.15.1773350121216;
        Thu, 12 Mar 2026 14:15:21 -0700 (PDT)
Received: from ?IPv6:::1? ([2a00:23ee:2968:90cb:1c6d:1979:bcad:501a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4855640d915sm5009175e9.4.2026.03.12.14.15.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2026 14:15:20 -0700 (PDT)
Date: Thu, 12 Mar 2026 21:15:20 +0000
From: Josh Law <hlcj1234567@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>
Message-ID: <c41dbb9d-b8a5-4b5f-9f71-3fe1bed210b6@gmail.com>
In-Reply-To: <43bacae7-3891-417e-9384-20cede8eec6e@gmail.com>
References: <20260312181948.20020-1-objecting@objecting.org> <20260312181948.20020-2-objecting@objecting.org> <20260312135514.e4fc0fa4c1f50e6fbda2644c@linux-foundation.org> <43bacae7-3891-417e-9384-20cede8eec6e@gmail.com>
Subject: Re: [PATCH v3 1/2] lib/idr: fix infinite loop in idr_get_next()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <c41dbb9d-b8a5-4b5f-9f71-3fe1bed210b6@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: E85A880015
X-Rspamd-Server: rspam08
X-Stat-Signature: a8hjg1t4jastwxxk69jkmyqowiqewris
X-HE-Tag: 1773350122-141079
X-HE-Meta: U2FsdGVkX19q7Wx65BRlDw65pp3dGotHyvw+PGo677szNyTy5AuG3JGUP4XO6/vF9809se0DgHyZ/Q48CtuOADIpL1O7l0TLDDov/APT43MFyMhd6O7SEwU9caSte/FXOF/cIK0dH+kn/dyP7eEIeldRRiHCJZ5/32sT+URpzrWrFBXBcwePSWsZJz+J/ApXiQt3Mk+5yWEpTMak/QeNiywIaqnLzxcpu9j2UJwxeuFjZgUa8IMCo3UWl86mioOOyUufg/iqeJik/TiknNh03A3dpkX/78Mcr1gowGg+14LNQ1BOeDIYCqK2w/hNGPcBu4ihzmjIIpWdmz4uZjjns71fkJmIUmapIdS8KHtHD+A/Eu5+wqP/MuAXUOcLwhU3wgLBSvE7ltsIsSvVV3ifS/Q3rGWOSikfRGO8lJYgXEXisyN5V4zfmbzQVAsKeSCxth6hR8pSqMzk8/buU2oLBkIQtBeNOn9ApOSN8b4n59TlL/7FC3D1eynjs1RRUK+Il7FVjGKMVN95c5ePeHSqr0F0vE2au0k+LMmTVR9O+eNZnl3y0oOvhgYBceZy0v1DTpYg+ijeXXnd75/W9XUlO0QBHVbICf7EBwKJgdQnLCAEjhbTRhqhWcl6aXO0iP5KLr2x0OxUy2pBY/5cNIlb03NwmqlEEDCSu/VARz54g7jbE+5r4exXSiRbKVPQ6lNGbVSaqTnCgFbBCgyCgWorbbRJLW6Ns1efrBzcp1+WM0SS8LGC/MoJmw4AQ1yRnxn2DRvHqanM8WrC63rq7rN7dYNsqQAl31WtpLEaYUjhXKhCJ/dIiYPKMHHca0UoyC0NINjgFsUXyOJg3qLfAIbn380M0KvN6+CVziYj+mvDmvG2pkU3TIx9h7/xHv2quU7lNZBfH7lorWHLYg3wvgY6NWlmlUhPv05Vbbg1visNtrE8Wp+GgSkV8ilFlqeZwHumoViaQiA8e+zDMOqNZJP
 VZao742O
 yOEL6ViC7n0pgr3j3x2Dg29gGjo9SjtRiZOOLn0f/ihYkoZxPCR1FobpkFiebBW/G9rJ1V9QkitGY1QqSeloQhRk0bvc3M6BoCLudyp4txEdQOerBq9pqVxd35hUFjhVToMaKn3hwTHcnjfyL/LtD46aG2AAAvzicrIY6Fa3ExqNkWsEGUuSscWae2xGHz/BJq8gJFwjJWAgl0WNSQQs2bhV7oLvOdpcaI90fa/amoh3t9+LUeWxv2oAk9skxOVlWN4n/u7NaJeX+RUEnjKbxsoga7TktXIgiePBs38hVjugpYaoRot1tpYNBN5o+Aw7Bi0uRPYsYYaQ0Ma7P47hocye8bf0MqOjZPnA9BqLelMbpCZdxZKT2szU1KTS7WomfKC6kuIK+wn6tMWsnGVLNBwx0NQXM0mY8OhyJKHylaMxO9ccGtUG4pUtopPSjvjmLHZiQnp0AF/copFRcx48M/Xd0w9yKnzxLO++B+o9DMuP9UztoMILsntK7d7MRVJWREzvU1wa+6+97aywgnAj8gB9+dvlPa62tPhe5ifakKj9L/q9zNtBK2oMianz0lQy3kLsO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

12 Mar 2026 20:57:48 Josh Law <hlcj1234567@gmail.com>:

> 12 Mar 2026 20:55:15 Andrew Morton <akpm@linux-foundation.org>:
>
>> On Thu, 12 Mar 2026 18:19:47 +0000 Josh Law <hlcj1234567@gmail.com> wrot=
e:
>>
>>> In idr_get_next(), if the returned id from idr_get_next_ul() is greater
>>> than INT_MAX, the function issues a warning and returns NULL without
>>> updating the *nextid pointer. This causes a soft lockup for any caller
>>> iterating over an IDR (e.g. via idr_for_each_entry) because they will
>>> receive NULL, fail to advance their index, and repeatedly query the sam=
e
>>> state forever.
>>
>> This assumes that the idr_get_next() caller ignores the NULL return and
>> just keeps on looping.=C2=A0 Isn't that a caller bug and if so, do we ne=
ed
>> to defend against it here?
>
> The risk isn't just a single loop failure; it's that idr_get_next() break=
s the 'forward-progress' guarantee of the iterator.
> In macros like idr_for_each_entry_continue, if idr_get_next() returns NUL=
L without advancing the pointer, the caller is left in a permanent trap. An=
y attempt to resume or retry the iteration results in an infinite loop of t=
he same warning because the index is never incremented past the problematic=
 ID.
> Advancing the pointer ensures the infrastructure is robust against these =
'soft lockups', even if the caller's error handling is imperfect..

This most definitely needs to be merged.


V/R

