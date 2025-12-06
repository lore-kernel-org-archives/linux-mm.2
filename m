Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 302C9D3ABF5
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 03:44:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F6416B034E; Fri,  5 Dec 2025 22:44:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CEDA6B034F; Fri,  5 Dec 2025 22:44:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E4206B0350; Fri,  5 Dec 2025 22:44:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F17BF6B034E
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 22:44:14 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 82AD9C03EE
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 03:44:14 +0000 (UTC)
X-FDA: 84187653228.24.F847659
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8E9E416000A
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 03:44:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="NYirB/XO";
	spf=pass (imf08.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.43 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764992652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B5yKXImvbgtz2yovFNQUHLcbnuea9LQbWcCyrFf1PMk=;
	b=eRe8WR6GObZ4Ha2jTXqJt6+47NLj5Fjdfx3ofMxipwDZDSGme7+ajaOVFdgzVtVsVrWDbF
	9NRRRcfHDu2KVNSU70Gh3L60dxWPYpXJYBt/GhX275WMne0adu5s4tRtyMEZ7LoeJwAt+1
	0/Wb0/7lDonB7iDtGaTCYjIftC9ObkU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764992652; a=rsa-sha256;
	cv=none;
	b=cTF4FabqlsrPTe2muBNOU9+Cors/ksqhUod6t8bfdidlIFN5x6ps099HGMQWWlHRGjBxwI
	0I9p8CndmnQZ2dVJNma1i2w81PwN4pEX8ToUTaoghIFQd4CpunLSnLLkPxYsdZ3D9Zj9RX
	6ZOYwdp1A6AEM014AqIy/FHqH9tRM9w=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="NYirB/XO";
	spf=pass (imf08.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.43 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b7636c96b9aso371988466b.2
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 19:44:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1764992651; x=1765597451; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=B5yKXImvbgtz2yovFNQUHLcbnuea9LQbWcCyrFf1PMk=;
        b=NYirB/XOnrNvoVERiqoJIU3QhQtEr2Wwzn7Ri14mqZee19J+aObvZrn52y6qtazg6Q
         ZPrVFiJ1ZZ2TgSmAkKb4oquA0U9169glFF3fEvmrYW73v3pBQ/MZfkOiHUziZKwO7iHZ
         vcda6dlQaKh+jJjHbBMPh8/AAMrR5d+p/fPkQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764992651; x=1765597451;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B5yKXImvbgtz2yovFNQUHLcbnuea9LQbWcCyrFf1PMk=;
        b=iHejTqKEThPIE49A6koTeg9ec3rKhsKGLbvGhqtaNmJZIqYh152EIVThucMvJlT80p
         aXGpJpg0SSirTtoO7gQbrAkEmNGdEkAeXDdOk6IzAAwGAX7qc2p7TR6oT2sEThPiIt9H
         v7lQA4B96H7CVzMp5+699nlCLxKPvqFRYOshtR08iLrJgSQePP6sgz9o2sa3BshbksIh
         t4uljYrXR0BCT9sM/LLmfi7Gx4dbkQL3dry+MIf0e2y5tWhJ5lhOkaih9PN0PABwOH+w
         QOLQcLI6rGh6qDSbse3dwQTFAWIJ0RaVh1DXmffW6MY4UblF0HQk6pOxX4PI55Wpz6jG
         B4IQ==
X-Forwarded-Encrypted: i=1; AJvYcCUhLSTnzu3VbB+yqVYczAWctUlrdb6TZ0ZH9puKcDd3YmSUEmhIoZQdkzknUqGkpT53CGdWqE2bAg==@kvack.org
X-Gm-Message-State: AOJu0YwDQFe0uASE0bVyQmRpRWkelxh3TA9qeGXZZR2acK6zuLZNTPCq
	zLQ4xbbPiVwv5pm3bfpIsEPjeE752c90R15ttAm3Ol5+/69X50xMN7fiBNvp0Ch4vt13E0TFhWi
	kVNJwUCv6cg==
X-Gm-Gg: ASbGnctdEBmUsHyg3WamfhogASQxb/kcm/X14E0uGllDEX0WFmV0z86epX3iw27eBHp
	UVCnrki02FegCCfIYL+VzanykaOj2Yi3Ih0dMWhu3j7vaT7zVYuXqoGfNVLsXNT8iCtvCayNMPm
	HTWK2tEq+tPh96l41siNXfzLSmYbOZMs8XwxooVKIimwclKMpwZWKpeA9Eu33wsm7GHPTSjY4a3
	BA0u4u4IdkNavQgGzyvhhgkScvKvle3QVap6h1IcJ+FTm6XBTaSY9ARxArbJnQ4zg5404fifuYa
	5OLm10pII/x9x/Aj9OgM6D340mTF8olQYzITnHyzkaLeVe5nkJZIuoDL8MllsC9YoPvFbS8XpBy
	OY6xkMoz0rf/uiwRSTGeqVRN49R4b0iC2iv7cZeBx27KxIbCU9I/ie3Rve6rr37KPHuWG9rv15W
	GmVHfZcUVAaK+qPoq8AGPA1puNth3EgGJ1Nt7f+vyZFguGkzDWg1YDQaq2yej8
X-Google-Smtp-Source: AGHT+IHlPFOV4PcWBEYCWGEDiVYpcnOYyo9DFiCyG5FMOnrNpEHdbzqadOw6s680o7C8L2QZrq+KEg==
X-Received: by 2002:a17:907:c1f:b0:b79:fe9d:9fec with SMTP id a640c23a62f3a-b7a244e424cmr125461366b.33.1764992650707;
        Fri, 05 Dec 2025 19:44:10 -0800 (PST)
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com. [209.85.208.51])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b79f44994basm524098666b.20.2025.12.05.19.44.09
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Dec 2025 19:44:09 -0800 (PST)
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6419b7b4b80so4150058a12.2
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 19:44:09 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXiyu8HX2XspzRT6o12jjz0odpgsHRCbRvPUm2OkMuAXdmn6hlXieDwZ6PnAG1ZG5WpsTCnEJAY5w==@kvack.org
X-Received: by 2002:a17:907:5c6:b0:b72:fd32:a463 with SMTP id
 a640c23a62f3a-b7a242bff7cmr135251366b.23.1764992649368; Fri, 05 Dec 2025
 19:44:09 -0800 (PST)
MIME-Version: 1.0
References: <20251203212918.82f1c9d3947940aeae263878@linux-foundation.org>
 <CAHk-=wj1aw7p-JkWdcJOkQQ279qgppG7_1kxFQAqaak7fEQAjw@mail.gmail.com> <20251206025434.GA1422789@nvidia.com>
In-Reply-To: <20251206025434.GA1422789@nvidia.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 5 Dec 2025 19:43:52 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj681NMt4ofHWVDzbcb2CjyAZWnVYX=9eJ5tmYjEONNBA@mail.gmail.com>
X-Gm-Features: AQt7F2ryDYxuiAxHRVl65vEABcWsri0dTWnBJNGoQshzjLrlHPuL2xKoXV2N73c
Message-ID: <CAHk-=wj681NMt4ofHWVDzbcb2CjyAZWnVYX=9eJ5tmYjEONNBA@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.19-rc1
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Alex Williamson <alex@shazbot.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8E9E416000A
X-Stat-Signature: czswgq8iisg8amngccmrpec3xummu6nr
X-Rspam-User: 
X-HE-Tag: 1764992652-712825
X-HE-Meta: U2FsdGVkX1/7opjSX1jsTM5PAvyq4t4Rt9bGI3NEBLH7F/S5tgwPvH1GRS+Hi2Qq8sNvBMcGRd22Ipe5PpX5etjs3vy4meK08tneYKAwxgb4dhUvihWA2dWhfu4r6vI1jSKSN51bxvGOG+Ic/5j5tc6A9/L883FO5HhTmkOXeVWrMeEyrK+r06kdz6JlfwTm7yElTYrdPnM4tiVpqNPD8O3hMXzs/4iWh7ltOEinf5lq1z6dLJrKjnjgpTxo+agYqqlpeqbHmO+Wp6av5KOcRINd/HpE3ZfxuuIQEFXT7yWfrhIZ6GXE8CmAnGNjI0UQgdejITyupq1bCKL8RRedyt3Aw3yLOQis7E5vc9xPUV/VMb4+ZNlurFzI6DDqoxxa5AmXm+McHwWQ9SLPu4JHkkL6RtFC9qfg127XHZdtbzonUpmEqUBsTzqOuo/AkgsYPb8ZiIaNEQXZ30TBbf/ySJPR3HE26W0uXvNF2onlNO/FzzEzwYY3/YLAzGEo2wg3jCE3DDuGCANghLETtgC4NSszrvpd4zhqItGxztEEy+KhWZJA5en3Yp8eGuJEAOqf8C8kfldDxMS0hP1PCtJ+Ws2X7Wibp07RPPMvu0pVjiZb/33frKJfp+trXAbojnrQuC0h5qLzyypLpRzTPxAEtJz1zsWCUGpI3+FNP3mC+vv1yb5bNnXBuM1LrNOXXFC4mcZLpHvfwq3a4tzyF+Lfq32C97kDp72mChHaNIAwsJ/EJInU8Xh7wbI/Aj3LCpmh8hkXz5V+NpFUMCjO9fGWjQf82qvw8Mw4eNDwgediGGmKNLYR9siQ3HS8j1+xAcHF+USGMmtipLNbNyGrUE2AY94tJDmr2+kk3bn/lKVeIroNM7hmsyRs3rXASCOLJ5OEQN7NJ+Y/zyHNyGDnCUBarW6g3NgqZWQXEYO/vzxmAwJrzCNG3gIJtUOnefkefl10xuUnKy2B5s+/mvtIEB7
 ADPK1iN7
 vAI5y2/BEhaupPbmj7jOroxuthQKPUwZUFucOhrYlD6uZH329+oLGIdPpL2tUS7DDJiDYpkjcAAqrnQs0BjjrQvEvoLXjt+3D88srOENhGTiq4Dzbzgxj6JHK/qhRWNxkUAXOHrxF7kOhbTpaKdqBuwJiJgp8A5QotSNPFwMpW4X6wr3vdqboYV5ZwQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 5 Dec 2025 at 18:54, Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> Reverting it now works well enough too. Let's see if Ankit can prepare
> a new revision and perhaps Alex can forward it next week or very early
> rc1 after LPC.

So adding that memory poisoning logic at mmap time looks crazy to me.
The mmap has *nothing* to do with memory poisoning. The memory is
there whether it is mapped or not, and admittedly it's harder to
_access_ when not mapped, but it still has nothing to do with mmap.

As far as I can tell, that memory poisoning logic should be
added/removed when the device is registered or unregistered, and there
is nothing about mmap that should have any effect what-so-ever.

                     Linus

