Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5884CD98C5
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 15:36:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ADD26B0005; Sat, 13 Jun 2026 11:36:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 686946B008A; Sat, 13 Jun 2026 11:36:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C2A86B008C; Sat, 13 Jun 2026 11:36:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B5A36B0005
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 11:36:54 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BF0E0140465
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 15:36:53 +0000 (UTC)
X-FDA: 84875292306.16.572A609
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8C42340007
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 15:36:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=N4MmU8ye;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781365012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kAnta1paEwdFIQxih/xgWEJ4+KGJdhDjTjYkexN5zvo=;
	b=2noBzUCqojBDSnCpWc14/0AZ1Z3HUMNUs+meMzFsen+jWGc4Ecmn4ZggDJcObZWZcuL2jG
	VhWE1qJMfBEfsPo7lKGNsLtYlDPt614z96zIAqrKom6x45B2Cj2wRMBTsKohL/YS3xG9Bf
	g2ovIPz5MM4rzroSawwJTe22iDTdbJ0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=N4MmU8ye;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781365012;
	b=B07n9xeJ0dB4/3qCxD7E58WI09IF25/xlZBxJODm4UiS2FHBFVKPKBdQtfEJHM1XJmtekq
	v1RybJ1Rn5ZRjm8HHwtgDwyL2wd4LdLuYdVY/pxd6ZwXiJpY3Z0ntKKSS53a0kqK3CgMkg
	w84mlOd9s2Nl4qM4j6Le3NyQePo2J3M=
Message-ID: <683801c1-23a7-424c-ac8d-12a24961088d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781365009;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kAnta1paEwdFIQxih/xgWEJ4+KGJdhDjTjYkexN5zvo=;
	b=N4MmU8yeOUrd20h8DE2N3CrJynJuhtfy2OdKynqokByRbOz2lu15GrpNB3K1dOvVaJUE+N
	Z3cEr1BqUE2WZFHW+Wejet/iGlHgNbbc2zM60EMC7N9GfpAASmkSPZNWTVTRFoR4EeHDFJ
	ukvsUWELv05KfVVr/HIcMUzLDaYttmQ=
Date: Sat, 13 Jun 2026 23:33:30 +0800
MIME-Version: 1.0
Subject: Re: [RFC PATCH v4 0/6] samples/damon: handle damon_{start,stop}()
 failures
To: SeongJae Park <sj@kernel.org>
Cc: "# 6 . 14 . x" <stable@vger.kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260610135546.64943-1-sj@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20260610135546.64943-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ysyw5e96sbby54e9b9jxh3k6ppyu38ht
X-Rspamd-Queue-Id: 8C42340007
X-HE-Tag: 1781365011-917580
X-HE-Meta: U2FsdGVkX18DMyFX6T0FagvfvVQ5pGnQmp03FcNmxnt9fOV7G2Hhxj2ZBakoyaOwf/Hqdn5EaNOfILyiGE5HZk+Y5p3w7pLti7qKqIfriexNzT653hMEpIEgVcNwwuwkGIBvInAEoPf48WzE7Fkab2UpJxLfhTNl8nBBAMbR1wMfVlM+uVffX7rhcmKpVJcLejSa7rayhfTLrn3ZBVfdb/1K5ucOAMCY/NpoCGPPGd7qxH2sTqA9q9L4gIkLK5HOWXV+lslWL1uALu9lQECA7U6u49sV23dNPeIvnC0zEw+xhEl0SMHvE7wKehq1nmAos2Pwa2KKsDaYkEAyOdhQOzU0ljjm2iWHUapU8TAnjV4UPBHQN+gXZzlGUt+KgwWoN2uZAv5C7b0rG6M7bxO4GxEqoQndb1A4sp0+eaX0C/+vI5nU+VdyJd/54Jz8gBt6fo/NnBei4hJMEflj+6864wv8wQ5Ttoh1rJbV3EGqtYxta47/f2q6oe2c5YEis0kYoDUEirjd0WbRWHPsCgvjE6MJO2S+eU3h7vMxHIDq3eb++zpDckYaVFxZlNeQ0xNQqqy9OWE0t5bD30KXf+69KF5wn8XYYY8CXCHKOoxZl8k425Q5q+ltx0FBH1jmNMuTF29IQzfrcrJn/u8AYlirJCDDMf7wjK3d9yRcasm5Eux6i9ZbQ/W1gtORNZRLycIsN/5cvBmIKevZoFkQt7F2di5+kAdsp7yG6U1z4VPOjbWPWMwmy/saFDyhYrnST8XYUIq18l9iVTaj3wpNf/wT7V7NgDr4PpOg4+TdF+aLMhSlShAmMOx/Xtdil9EIjNcjdI/kLnmuSd+tQjPWBtjLGKFUQp32HedftsR6PakPnr5w4fl2gE4NbbgpuHLz9dR9KnEq6MCbOkcz1kFzoXcHdovoMGBYTF5Cgu9yju9NsQM/aIgHyzZhqMdUN2mLR283YCV++kUIo9xxf4TaKn2
 nJodOsko
 IKD7llBlB0hbFBK0vE1V1RrQ+5fwS0TYkzhBl6UFFMDz1zZloNocVQ14SXpT+3nqUINTVKY91nIyLdJs7ILShY831e8ydLj5VNNTbrtqHyPepJRxx5RLvZ/mubxSXrL37PFh7QWq7KxUffXv/Zipc4hgXUCluHI/rA672v3WdIlQZRpxGXKxO4Ezu7ytvG9VqX8116BR/oSEOaE+j62OdV0gXNC/jT1eFC2NP18r3XVQPgarr+7HVCdgvuyWxHby/137D3yN4MochXl4WoVgIuFX1Eg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/10/26 9:55 PM, SeongJae Park wrote:
> All DAMON sample modules are not correctly handling failures from
> damon_start().  Among those, mtier also has an additional problem for
> handling of damon_stop() failures.  wsse and prcl also have a problem in
> their damon_call() failure handling.  As a result, memory leaks, next
> DAMON operation disruptions, and use-after-free can happen.  Fix those.
> 
> Note that only the damon_start() failure caused issues can reliably be
> reproduced.  Reproducing those issues require the admin permission,
> though.
> 
> Changes from RFC v3
> - RFC v3: https://lore.kernel.org/20260610011420.3018-1-sj@kernel.org
> - Add damon_Call() failure handling fixes for wsse and prcl.
> Changes from RFC v2
> - RFC v2: https://lore.kernel.org/20260609142119.68120-1-sj@kernel.org
> - Add damon_start() failure handling fixes for wsse and prcl.
> Changes from RFC v1
> - RFC v1: https://lore.kernel.org/20260609005443.2122-1-sj@kernel.org
> - Add damon_stop() failure handling fix to the series.
> 
> SeongJae Park (6):
>   samples/damon/wsse: handle damon_start() failure
>   samples/damon/prcl: handle damon_start() failure
>   samples/damon/mtier: handle damon_start() failure
>   samples/damon/mtier: handle damon_stop() failure
>   samples/damon/wsse: stop and free damon ctx when damon_call() fails
>   samples/damon/prcl: stop and free damon ctx when damon_call() fails
> 
>  samples/damon/mtier.c | 14 ++++++++++++--
>  samples/damon/prcl.c  | 11 +++++++++--
>  samples/damon/wsse.c  | 11 +++++++++--
>  3 files changed, 30 insertions(+), 6 deletions(-)

Looks good,

Reviewed-by: Zenghui Yu <zenghui.yu@linux.dev>

Thanks,
Zenghui

