Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92550CF8854
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 13:09:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED6E86B002F; Thu, 20 Nov 2025 08:09:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAF096B0062; Thu, 20 Nov 2025 08:09:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEBEC6B007B; Thu, 20 Nov 2025 08:09:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CDE696B002F
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 08:09:25 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 75D16160888
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:09:25 +0000 (UTC)
X-FDA: 84131016690.18.20DEFC0
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7BE9A1A0007
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:09:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=pYTsshcF;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf19.hostedemail.com: domain of linus.walleij@linaro.org designates 209.85.128.172 as permitted sender) smtp.mailfrom=linus.walleij@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763644163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r1I0QiXVPHftQdf8ZpFoiPUOmVVw5f0W+STeRluV2CA=;
	b=oJZrYl5jRbjZHEwAEXnZ2jUP/4LcU8S7fZg/2N51+KNLMAATJCOervmz8tYr+gZfymVFlq
	yYrBfvdgq/8UOeUFpCkZKkiac3CxYuEuP/vL7Gfo2l0a9rbr/8o+qVxF9oxYJZm5xiZyJB
	VGLlVcUTKpubNwTxtModxGDsBp+qhmM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763644163; a=rsa-sha256;
	cv=none;
	b=QXs2ZX6x/STf5nDDoBWyYpfpHWAiWXZDONparAg0cnYvBNsYjQRCxWdKsx2mfKRYSMgao2
	bbG+BTnLqCros2BTJU8pMuyX2ZIafhWgHyOUJS1WWXOnJPapRYvGrEZN5yRrWLoDMloghO
	mRWhNRNREel86U6ICLfJFXM4rSqWXKQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=pYTsshcF;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf19.hostedemail.com: domain of linus.walleij@linaro.org designates 209.85.128.172 as permitted sender) smtp.mailfrom=linus.walleij@linaro.org
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-780fe76f457so7887347b3.0
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 05:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763644162; x=1764248962; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r1I0QiXVPHftQdf8ZpFoiPUOmVVw5f0W+STeRluV2CA=;
        b=pYTsshcFqs9FD9fJe2HLurHF9mj+NaVMN5ON5GTeWbCzeW0fn3TbXUHpO8t5yzfh6p
         TImylPWVdGLDI51ZTMq+KQa6yRqdbuwm0n/F8KWI4cG+Bsd9DLyY3Osjk1fppuWEhAD5
         /+X2GhdNZNDHzGdkp2Qk3GRO6fjBC55nQn5ZIoW2wQ/pJq1WTzwu3qJatlt9WbDOPCjr
         jXJ9JWHfG45TJZCFTSs7ANOmST5V7kYjr3KqAuQuOV3lXRwU0c8fFAh3gzYLYzro8Ge+
         n3QOcz3hHUV4ticSiT0buidmAu1LzfwD1zzPZBgJfx2N9yu7fL1RDSR7rS143qKGoafD
         oc8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763644162; x=1764248962;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r1I0QiXVPHftQdf8ZpFoiPUOmVVw5f0W+STeRluV2CA=;
        b=YVfiLDsYe7mggA0B0aWj65GOF2D/x/G2MdmvlH2KCsYyjN6KBSeP5tWAD/BlTqh2iV
         VySdWjqbvFdoB2G/nerHYbDaZ6zRElUvqS8218K+n5NoLcmfLfiyiPS2bIoPH0pd6uc6
         JNuYjzUTXkd/kkMNOjB7ZpJcPZNZ0mYNDjvbrLqJnk4MjHM8bqKBcfWX8MRkYg0sBBgz
         +o5lam5/2kbmXJGJQgMudp76mkWHUNyDkWLXVeS0k9B5BaT84riqggvFOCfYzVBAZGHb
         ewOMQyFow4JJ0XsbMlz9iQtrx9MQ5dk3+pd7c7AuGA7lakNcYgkXvLqQ4tyVNQ+RZ7U8
         qCUw==
X-Forwarded-Encrypted: i=1; AJvYcCW5Zuvhu14Ggqj63r+P6eSN2W114XbK+lwjAx6J+2FNdPZwpBXkcOwpPt10K5QODYzE8+2sEzl6Ow==@kvack.org
X-Gm-Message-State: AOJu0YyHaOoNtqxjf+aru7X3LqrpiewvE0zO35dI3OYWB/E/WqD7eCmR
	Rfred9y1dk5o0BKTJOXb48JZIOUup/aROHIbDCIEz+x+V0nBsr12cj6TYy5qY5FdWK835SG4XuH
	ZqzcizIXBhqx7dvSh7Z2O4IRFA4j9o4DGIL66uLkG0w==
X-Gm-Gg: ASbGncsr1dkryKUBStFa+GA85owTcN7gV+e9b8mZrjzyPM21ZZrku8eXGQW+25QMOBr
	o0qg6hK/RzCv5ol4GyshtsENt7aTqROGNKfsYGQmH4M+vyfo0tKdXW/pbgVEPK6UpY5pMw2DHgy
	3u+eN08z8iyi3M2af4OqQXpyIiXQn7SZhH/whIJtnx5YLMV1psf6ff511vgFVD4Nu3+xnKwlABJ
	FVBXBt8wxBXhw13uON2Om0clJ7QIyakRje/AX3q8X7L9LMK78agBZVaboj3uhriELoUmF0=
X-Google-Smtp-Source: AGHT+IEgY5abhSTiMU0lpFXAsS0MziG35W+XuoxZsUyng6z11cdX7siflB64NvHvDx/iWDTD/vORYSvUcdTKAP3cke4=
X-Received: by 2002:a05:690c:e4e2:b0:789:2e24:b786 with SMTP id
 00721157ae682-78a7963c587mr48433677b3.52.1763644162316; Thu, 20 Nov 2025
 05:09:22 -0800 (PST)
MIME-Version: 1.0
References: <20251120054015.3019419-1-mjguzik@gmail.com>
In-Reply-To: <20251120054015.3019419-1-mjguzik@gmail.com>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Thu, 20 Nov 2025 14:09:07 +0100
X-Gm-Features: AWmQ_bmva2PuQJGfBivPIJW9T3qpMV1mhmjywprPZqprVkeKf1AnumodUtem6Hc
Message-ID: <CACRpkdYwUAEvqLugyHfAaHqUXODq+4kdKphgfxs7-UJMaAYeag@mail.gmail.com>
Subject: Re: [PATCH v2] fork: stop ignoring NUMA while handling cached thread stacks
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, pasha.tatashin@soleen.com, 
	Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 7jocsjykdm1nrn8wak6cfspug5et7okp
X-Rspam-User: 
X-Rspamd-Queue-Id: 7BE9A1A0007
X-Rspamd-Server: rspam10
X-HE-Tag: 1763644163-841976
X-HE-Meta: U2FsdGVkX19lsMZzjeznaF57HOm1W2a7TtjntoFHzShtYm6kKcGNJFzLwqtt7xQgWI8j8k5nzthAh6/tLBoDAW1e4Ai3f1KOqHhxgjRECThPBnBtsoU6x+WI22Mos6o0PiFQ/yUIsTPY1koOE8Tvw2s+PPGjKfMw3iAiCeQjh39vW1IcN7T9oXQ2q9GpAzj5leKL5EB+lDdq0nKL5SaaXB30B9gRMqdr7cl+H4rmacruz4wF01hsmH8N0wHNmW7HGdhFIVOAP5Ph8I4XqvBid/r/VpEwl7SFPAfgQYgmsgUatxbKWWBtQMtrmPx70Ex7RhU/ekKbfMJTfugcT2d8aXHjgNlzocJyjEE8b+9dAIOSRX8xrHjgUQ2hmZfsc3J+vjCgtgy1bd2z86LApngn2DvpVLs5rSw7sUAmSZtcYXdHlxAwPcpSr3F95y/s5TJnQLYP0FW47+zhGPadAKm75mBOIOytAOTB9gyQBwuP/WMd+rRqrBNOEQR1ebCKgNMWo+6A9Ve9+h4AyAk/SnefpGPKNuwz7VxBUN1wv5MdNE4+Bxt9LY/MT5f4Hlqg2fT/9DxOmmrU6qyhF+svXvqE5i0KAfjFzQtHY+lLqZG0x0P6mhpLl2tkK1vHEtDXJ7xWjGLjnhA2LA1r/eSb1zy9khejGpFyndpxN3v4JMxF+R8RNAjPzjo17S30Q1xj8a0Zc2WdcL63TExNE1b4p13UdxYS1hjpPE7EEzhRsC/mhvWhg4QldnbCWsVBaK+sUI64TKkQCBxJVjVwRPL8EpVPsrvlNUW8L0aHGj/eiB+w/5TY8eM9VZJXbYuCKPzQ0yAv/3O1qf2Lzo8+FL/idEXr30HxF4xwOVz2BeP3ah8obl+SLr8DQSOebSyXwDVI0ewJpEba2CDMTiKAVDubG1qke8j7dpRYs6j3MGpOzX77lKqASJNoRk79IfIPuJ0X4PEZrcp7B5/bdrKvoEkgPeB
 YxmadYFk
 6shzr8ZUGoAco9KrNVK26gTRFL1hrOW3Atyxg99Gh1U99B3Hyv51Xg6UOF+xse7Kkiw32qKbf+s+YrvGJ15Jobuz6mBotOUU/yiE0JcIXStZhIH2OzHT/puorOkqaR/bkcDLVWndNDwN6A2fOF+kzsqpyrRlD0pLL2gKauUteRKsI8ucQorf9JXWpHh5pJCirTnuUt2WjSTy1JsocrNGyF5H08J2FimAPPfaLltJoR2cahbDNzJ9S33L18dBvJZWoyLkrqomimNXNyPE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 6:40=E2=80=AFAM Mateusz Guzik <mjguzik@gmail.com> w=
rote:

> 1. the numa parameter was straight up ignored.
> 2. nothing was done to check if the to-be-cached/allocated stack matches
>    the local node
>
> The id remains ignored on free in case of memoryless nodes.
>
> Note the current caching is already bad as the cache keeps overflowing
> and a different solution is needed for the long run, to be worked
> out(tm).
>
> Stats collected over a kernel build with the patch with the following
> topology:
>   NUMA node(s):              2
>   NUMA node0 CPU(s):         0-11
>   NUMA node1 CPU(s):         12-23
>
> caller's node vs stack backing pages on free:
> matching:       50083 (70%)
> mismatched:     21492 (30%)
>
> caching efficiency:
> cached:         32651 (65.2%)
> dropped:        17432 (34.8%)
>
> Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

