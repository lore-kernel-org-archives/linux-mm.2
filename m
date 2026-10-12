Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 556B2CA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 16:46:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 180CA6B0088; Mon, 12 Oct 2026 12:46:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1307E6B008A; Mon, 12 Oct 2026 12:46:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01EDB6B008C; Mon, 12 Oct 2026 12:46:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C98CE6B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 12:46:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EDA8BA938A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 16:46:56 +0000 (UTC)
X-FDA: 85314553632.17.AD38F15
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1BDAA14000B
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 16:46:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DGySc7jB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791823615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0UrN5VSM1Sm71gRbWyyCAhAHasLekx/YSqvnQwMreug=;
	b=4fhJg5l3Qf1TnN3rXvciZeQwQEfHFqtn7GO1Q3pYlrimvu928Ry3bpisGiMy35zvb6df80
	65w4cQzeKhwDjia11Mmy/Zddy7XsQ7NgmpDFDcKwH5pBFfrJXb2ilRKbvOwuSqYrpHxUN8
	STfOGOmlwR/6Jaz82gurjZUItSSk9Xc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DGySc7jB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791823615;
	b=QL66A/VsGCuiHPu9z6VQcGzMi9VRGO+jhgtI96VqSX5TN8meKlknxE2AMojulWCPk99+pJ
	aoBr+kEQI6GP21NPvna+zsEO5+8gpLuY9gev9LUnYQ0U1hDmX6CRqsnlaJatEkttviJB2Y
	oUerNqHQetsivckrhZpCBfiV9hWiRFA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 65A1A435E7;
	Mon, 12 Oct 2026 16:46:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7C11F0089B;
	Mon, 12 Oct 2026 16:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791823613;
	bh=0UrN5VSM1Sm71gRbWyyCAhAHasLekx/YSqvnQwMreug=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DGySc7jB23/V1Z0AiUJki0Z8E+1NITPebzHJoljKGLolAv23dMkVULASEv6xcM3hP
	 URvKzoUwGJbKWzmEXSPRHB9IBLvJSHW5FjeLNe3ZH5AXI7XnbJP67L/oF7D/DiaWnl
	 aDMZEIjcEVpwUF7XuHEB9FvmbBwqDzgtukk98Rm+p5gsCZCSHsxXM0yYjSbt31HnDy
	 eIk294Mjj0CNM7ykSZ0YscTCi0i6vupSrnS4gWjraC7oKXpky4BUIRati+wEhVDL56
	 YV6QnEC2eKQmVROYtSGXUKnJLLGUX8CtEkIA729wb5QlNYCQ4J0hiU6P+qFKp1Sglk
	 MzL4zw2ZPN3Sg==
Message-ID: <4866a382-42d9-44da-b68b-377d36642528@kernel.org>
Date: Mon, 12 Oct 2026 18:46:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v6 2/8] ipc, msg: Account msg_msg allocations
 with GFP_KERNEL_ACCOUNT again
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>, Kees Cook <kees@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Roman Gushchin <roman.gushchin@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, Pedro Falcato
 <pfalcato@suse.de>, Kuniyuki Iwashima <kuniyu@google.com>,
 linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261006092030.got.500-kees@kernel.org>
 <20261006092035.166776-2-kees@kernel.org> <asjhg2e4-WSeKuXd@thinkpad>
 <202610092010.934197B@keescook>
 <20261010153714.b9e91801ea93675da099e903@linux-foundation.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261010153714.b9e91801ea93675da099e903@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1BDAA14000B
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 9xm86ci7dzkrzd9jryu1bfu9bucgsop7
X-HE-Tag: 1791823614-838638
X-HE-Meta: U2FsdGVkX194hoiaDhdzhxvl5b8Z14g9Mzyi/mCxpD27NzS+XJu7vxjALGjXRTpFMvOeKE45Ticacw57IOCQlKPQdaweRwToDycPCIMiNNEZxObaYEbhGKbRe9Ms7CmB3Os+HFJKiHNItP5UFh5i3mM0Nu1iSJZNiH8hR59vpVYNA6xx6/6LPM3AlxkBVh609enjGsmlCeBy2JGl8iNQWnTiURcxXZ8DrRdLK/+9gi13royQw9MNAp0335iOHvHQCNwiDFNMRFX7kaei740XxCrRDUiRJmn22FqDG6sl2GHswQCxnppyxkt+vbBAvv+8lLOm6J7pmzo1M7CzRmBOSataPmdOre34NmqADk39AK+jU7JiKmCqbT9SruhgD5QRM/0142e3o5+1VoJCrrfxmUHkXICTJuxQfdYkAUa43sNVdhI+fmqZD09Zm5rVlOzmOfIC3G6FqfZ3sbWxouIv4pOF0flghJtw/FRFdZhk2KN/oH5HqmFzeEZGmR42BNDGNRRuoB9pKIkehli9NqWZm1ZQXr/KshMkdeD09aGJGmwOAVskHOxOQBpmKT/6YGGqtL2jYF/esFrcUhj2fqSSOrCZ7mfHNiqKo+YXHxsrnCONi9Q/9ZZwZj9gtS8oR+MN0DGnV0S44GmXskWstOFrU2618q1w9xqv7UvbPhCw+K+SojPDyQr/6Dsui/wuZ9V7RPxb8BL2yrWVpllQqAhbBOgNQtM9e8CqpKaXxCxmeuwxnu/u1mmXMhJVcpGxcrvQqlLpGCzGMt7ZwutGM6lcJpLRlXK77n3QmGL4OoFMyEbyNBjwIln1+iisPEkF9XTPXvtQeXHPCop9TuFoJPihOCJj01EjZVGg3MCWtER6BLriMhE1HPgXV2mixUjEEYIIwHuIiQK9iBPd9YhAS/DPJc3KhzOBJfN3ibdgEnlmzHFFsAdgL/CgeZNqFc++TUuaowZLfGwTuIzK3eeLnPm
 ycJidUMJ
 8hxGS5fCLotZrB9ATLVXGvmfz2Kk2ZIz2RV2w210UTjaXojGmVFpoG7Q2gYIkyE7V0WWD3sBWL/BXJXrTnieeZdXusyyw1R6pVhiSG0samakWvnZ0W5oVir2XrncMEI1pYJIc4gqVRr0mtgCo53MUOgAdqu9VuWyzNpVzJOiHHe97Pwq5hAd09hjETxddNNGnrxSTEmVcTAdBil5aDh2pS0E1HKQVff8M3R0i0AuGC2v//VQNeCK15kopSUlS5vjOK62ozvyANXs8PEWGonJhQ1q7+JvWh91DOnJhi7Y8QNxq1JKIdELB9cxTgH07BtlaK3LQEQ7MJ/jwph4yXp4hzeLhWRWx8PoNzgC2QL9mIBZqxxUUOqM+VuRGA8OtRWWlimJhibWlA2XbJSM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/11/26 00:37, Andrew Morton wrote:
> On Fri, 9 Oct 2026 20:14:20 -0700 Kees Cook <kees@kernel.org> wrote:
> 
>> Anything with Fixes: will end up in stable, so I just leave off the
>> stable CC these days.
> 
> -stable maintainers have been asked to Not Do That for mm patches. 
> Other subsystems are doing the same.
> 
> I don't know how they determine whether something is an mm patch.  A
> patch which covers do-do-that and dont-do-that parts of the tree is
> likely to be mishandled.
> 
> So yeah, add that cc:stable to reduce the possibility of mistakes.

There's also this from the list of pain points at
https://lwn.net/Articles/1099594/

    Kroah-Hartman: subsystems that do not add CC: stable@vger.kernel.org
tags to patches, but which still expect the stable team to pick up the
important fixes anyway. The stable maintainers are overwhelmed as it is and
are not doing that.

