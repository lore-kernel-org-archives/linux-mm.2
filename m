Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55F9F10BA423
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 18:43:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 565A16B008C; Sat, 28 Mar 2026 14:43:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EF3E6B0095; Sat, 28 Mar 2026 14:43:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B6126B0096; Sat, 28 Mar 2026 14:43:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 261906B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 14:43:25 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C0FE9B69E9
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 18:43:24 +0000 (UTC)
X-FDA: 84596344728.24.DB815CC
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2677D140004
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 18:43:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DaFKQv2b;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774723403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EP2ckNKWBPmkFolP75nur6z6WVdO4BalIzs38VivV8o=;
	b=ivArwrR/kS8czKSyXySeVOHhajGgTNTVuydn29B4MPwKVJBWUhuaH27gVJFlO1oQatadxu
	cnYyxk7IF25KzHO35+L/3PH9BRh+XVtTYJjOE13qeR08keRpoKVoRv7r/0IpbH50qbE8si
	zy5fALVwH34JktjogkY0rc2KzzxtPqM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774723403; a=rsa-sha256;
	cv=none;
	b=H9N8q3YJ9kP5Zar1GFXNHKMVNgjDLPWzrpM6xlD6lBxfp6Fadu0bVMns3rkm2ySe7uWNwB
	0gZyTaxGhfycvS0gDcRz6+Cm/JfuXpGjVXUWfC/4AS/o1WJpDgMV+wHjXJ3p9viX264XYA
	MuvA3F8+MDdD+ofK2bwF0Ht6HxWSK6A=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DaFKQv2b;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-35a1cc6e478so1891224a91.0
        for <linux-mm@kvack.org>; Sat, 28 Mar 2026 11:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774723402; x=1775328202; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EP2ckNKWBPmkFolP75nur6z6WVdO4BalIzs38VivV8o=;
        b=DaFKQv2bCziMHtU4TdAz1QQai6Npy47BZbnqqSTEWib1vxzpcXHnMaQLKLKCBYyRpD
         5rnzfZ3+0DU3rWIpt6YR4dnYug3sQLiNZe0g8pFaa1PxOY5twkCWMmtdJpxilnxEwflV
         2Od6ffcLnoqRZGR4r/Mr2dmFv74xpn1ZBbdYcYBks1bCGdBtz74XwrugU5fA3qfGIjRG
         IuImOVrh6pb7L5PsQtZuVKY5TnT9PcuJg5hlXhP+x0X9f6ZezjJJXbvocTzIFJQI89/0
         O/+ool4Bv9GvRpwHBbl/B28yDdsy1szYwmHHizg/zuLmfhhheqBC1nJ8T2IxXsMk5S4o
         bPpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774723402; x=1775328202;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EP2ckNKWBPmkFolP75nur6z6WVdO4BalIzs38VivV8o=;
        b=bmJRY8AhuXM8J53AGjoO0I9qYL3PDAI2lnFpH6VZwkgiCqHW763IIm8PqXRCeSkkVT
         W+3NLthZ9j6uePAe9jPTTmFTxqwgOXiziVewieXY806qSKLxKZAzz3nOVxeOPYlYyUCJ
         VlxPNRc/YTTbEuAAEtZMViYPLIwE7SnoO/ZuuVF3i85Zao9K91B3K2bEuTDeehbWr8oW
         TR1flExNz5AlDzsmn1vy7n7dcC/6HUBD+8D0EeOfr4p8fH9PgXJi8r2ASM2qf1tUx13Y
         M47BezmO92ntU8j0EFxXQctXvcwxIt8c3ghH8hqToyvjTCXdLwKpc18DP3qjUcHYBOoo
         Jy/w==
X-Forwarded-Encrypted: i=1; AJvYcCVM8c0eLKYWHbiCdihmnPz+mb8RpaQZJtKDjtvKemkzFgtg6rYq/p/o4E7oUVI+2Z9KUp0guj42iw==@kvack.org
X-Gm-Message-State: AOJu0YyQ0AAkI9NS2SSIu0qAU5K8eS44UATC3md5geQTzl+1e5o6g+NL
	W7VgThmWlf5BfR6orW0bPG0TapxC3KAGC6Jx3IEKSDLLBlK59hGuBJ2Y
X-Gm-Gg: ATEYQzziIW2u4rx/XNgDnJI+IZoMfGF2YC4VuBP6SppsOfsooqbHrB6RCtz7JJ+Bi09
	DX1zQDTMErJJvgVh02NJzXhvF2MlsbwMfYDjP2BB8O39G3hxwuLvA/kzNxbNybC72nbJKckMvNu
	mIp62gly/EWs37TWS3v8SnpB6lunGF9WNDfkRBa7vpqIGVnlFOWcmgwx80P1KVUqvTxU6uwzN0R
	jqFAhKzp80V0S8ah+gpgk/ibtVsNSHqDuPR7MqtHn/xu1/LvuR34t0PkVE+eD7KgovzFQjj1Goq
	fe+JkkGxqx3B9F66wQzPnYJD4uDauWn+l9GXi5EKoArFi0HEGLNL5B5Iee7JcZoc0n+faAnDI8n
	GoVA5vmZmu7vbBr6+R5Mybq7g0Glh3mRbR//GTRnKC7h+WeY//rYNQV0lpAS79pn/6HjfpOHH4A
	QZZ5D/vJOW4AbuDPJJkebgPhajf9g=
X-Received: by 2002:a17:90a:da8d:b0:35b:e550:e68a with SMTP id 98e67ed59e1d1-35c2ff1be42mr7049890a91.3.1774723401883;
        Sat, 28 Mar 2026 11:43:21 -0700 (PDT)
Received: from celestia ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c2ebe2c98sm2617321a91.6.2026.03.28.11.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2026 11:43:21 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon: validate addr_unit to be power of 2
Date: Sun, 29 Mar 2026 02:43:19 +0800
Message-ID: <20260328184319.13176-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260328180629.55498-1-sj@kernel.org>
References: <20260328180629.55498-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2677D140004
X-Stat-Signature: w9447i8aotnxyz66nmygdynj6837f134
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774723402-576048
X-HE-Meta: U2FsdGVkX1/zI22i/XollW54bMjo77INT0LIEDuavAj44TaKnjTndsxhU/jvE414dY12GAScPDgwMWUzgiimKaCU8fcqe9jjwc0FxXHxk+1ZRX/Nd1rNVpNsygsVxdSWAlZeIeAVFVBoabIAwUcEj4t/6w08XmwSJo6AIaAVo2U9wT1xquRoGfzRSQsoGrnsxVig7kb6Fzi7mtJ9JEp01r3/eN8PCzUbCLPHKMuFcos4GV8FTiRey5CCPNF2Z8MZMxl67eC3J1ri1HCJneI75uD1/1mIDpMegL0/Ywv43HUpCBDaAHAZHV0S+r30XGf1FLIGJn1MENZxwp4q6BhoTiq93vLQ2NApQEvjHrAwIgzkP53y68UX573dNT+LFoXeN4vcK888o60nkPNqIkQ/sJR4BZmqUN/FnznAPfGzPb09CsGya6kyLW7hZ34dfFX9dtrbXJyoHFq+MMXzz2Zx0EhbQGbPQrgkH6t1X5ro3LWOzEMQNDEVyp3G9zAx7R5CzdL2Ti6GIyQppYp8y5+Ivs2yiy1yNUFdTjQXLk9E44l5GlUm1x4WUJ+mKS43NRn02R7olNC4f19UoVo1gqPp9HrDCgKqPqeMqDQ+vRFA2yHokY66ieDAuelaesDvZ/0nGb4s6A2YPo+qxcBNpL/zEVmGF/K4j46aLJUC8cF8nrjtmqkb0FvOTHK22ni+5lrRFQoEJcafADZ1lzBBcrfRwP9u74/VIVhXfQPyssj8aeH31+9Khnj9iAeX1M49SnXoX/7VaMDenyyTSBY8ZUJ5N88Al9ZVEisUKK5uS1HEnhKq/Qw5DI7iTsA9a1tZV6jl1/ahrKZJW5xxfEUTNZ9zez1YdoRoBs6nAaRBR+LoW+pto3QMppOIfmdbDusx1+iysK7QGlr7A4xrwolizgwtL9XLjPOzkno6u2DBSth+Hnjs16EATLVhtxgDuXcRWI4nWuL9ul4qXyuIsGUMBXQ
 0eGBe2jq
 /NoN3akG0ktwDwtfHrkygbHFjYSMoE8cQ/k8NYwmsheOXytlsKPm2nibR4CyJW1RAOMMKV8fSR0Zs4JsHh0DeTtA+ZkgXMSlAHyFg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Liew, I suggeted two options before.  But you are skipping providing your
> opinion to those, and adding yet more options.  That makes me difficult to
> follow the conversation.  Could you please answer to my suggestions and make a
> consensus about those, first?

Apologize if my previous email was unclear. Let me directly address your
two suggestion.

1. DAMON_SYSFS Type [1]:
   I fully agree with this. Centralizing the validation in
   damon_commit_ctx() is the right approach to avoid "whack-a-mole"
   problem. This is exactly what I am proposing.

2. Adding a simple check on existing validation logic (in callers?) [2]:
   While this is simpler to implement, I prefer avoiding it for the
   "whack-a-mole".

So, to clarify, I choose your first option (centralized check), and I
believe my "Option 2" is the simple way to implement it.

Does ths align with your expectation? If so, I will proceed with this
approach.

[1] https://lore.kernel.org/20260328132937.9580-1-sj@kernel.org
[2] https://lore.kernel.org/20260328141323.10540-1-sj@kernel.org
[3] https://lore.kernel.org/20260328174409.6786-1-aethernet65535@gmail.com

Best regards,
Rui Yan

