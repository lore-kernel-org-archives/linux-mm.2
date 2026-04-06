Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A09B4FB5168
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 21:14:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B93A6B0005; Mon,  6 Apr 2026 17:14:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 969E16B0088; Mon,  6 Apr 2026 17:14:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8593A6B0089; Mon,  6 Apr 2026 17:14:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 748036B0005
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 17:14:29 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D0EDEC1E26
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 21:14:28 +0000 (UTC)
X-FDA: 84629384616.27.590145F
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf04.hostedemail.com (Postfix) with ESMTP id CCE9040017
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 21:14:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SBhA70Wc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of julianbraha@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=julianbraha@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775510066;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gy8Ig+bWpnwTKw5s/3Z/aYb/CpdeQrFnYgs5TNJH2vQ=;
	b=2Auu8cT5dHtqlcjscG6fkpu8fGsgkdezmOgfoD2h4wlKe3Cc6x2QebsJ6aNt4qfUbHHnHP
	GIv45t50ZEiSdpd8GSQyKFhY2p7sp/keo952t3TkFj3Br0BmIvs7OtQ4pSV/JIae+sQFIA
	59Fb3MZru5IVQbq4PomES2OR8D8MT1U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775510066; a=rsa-sha256;
	cv=none;
	b=g1fklWvZaDUa8IsMbON78vBq1U/+ACIdWiVwJvSSECSNvzU/9XVTaezdamUgzp0GBYhUBa
	w9pF89YrewaZLuytGd9z0Pz9iN+UqnD+DRTrSlBIXMo4iobFNmmiWdkTnhDRFjOfzy/c6Q
	+rTuqJ6BHL9+juCAszIY3gnjtX1mciU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SBhA70Wc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of julianbraha@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=julianbraha@gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-488a9033b2cso19660315e9.2
        for <linux-mm@kvack.org>; Mon, 06 Apr 2026 14:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775510065; x=1776114865; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=gy8Ig+bWpnwTKw5s/3Z/aYb/CpdeQrFnYgs5TNJH2vQ=;
        b=SBhA70Wc/qdbcI1x/KKaRzmwCbra2kHlIIEO4jVRZKTe14ighnc3Q5tYAmeT85a0Oo
         4MX4h1A3z84B/w6bwaev9JvWjUNLFJ9i7i9lr/HALGkJBKGrMic7oOTTZbtKCCpYdhBV
         TaQ4eh3twBVe8fbbnTeJAccNsq5SvvZupFGZJTOZNQ0aWJDns8S3+oSzFDMlsnAVUkBb
         U5YYX6p0MORektsOxDqDTiJccp8EJmooRi2RppMtN7iled2qnIsoIMWG4uzA72oJubhY
         wCLqW4hatuQqXbJ9DDbs/MR9HlsG4S6W2octjGveQwR0Bl+RVgXvaExD9x3yUpzA2X7r
         JuFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775510065; x=1776114865;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gy8Ig+bWpnwTKw5s/3Z/aYb/CpdeQrFnYgs5TNJH2vQ=;
        b=EIDCoIRVSUomyu1I/3UPCU4A1ZjLzbiJa8Vf7sjdZ/R221PI2gmHyQMTW1op1KwxP9
         E3UgoSNr/MKzaY8EoUkPO6QQV+jfrFkNQrb8or6S4awgVLYvAM0bheKkOHGBFO+DzMTG
         4/9WKFeLjK41oTkLNSC+2x2ze3u35ovFfqDoiUWA8Z8Ws4tQxxoFJGZxtjugOc/sg2k3
         MT2kpPSpvptuI81YDSVTtBLPoDuMWprCBSU7wij7zrMYVtZavWqv33DrNHkwddGX0mFZ
         VG2QYyTvooMP/duejm/63OQcJ+TMv+ieq6aLcdaAriY7d05jO+ExjWAU+G8VKGobxQld
         BxTQ==
X-Forwarded-Encrypted: i=1; AJvYcCWXFYDj3EOrqbeVdvHU1uQAcfi3Jjhv7+X53cYYZuAjFrwbZWq4m4ubMeuic9BbvtE3Ikq43u+OTw==@kvack.org
X-Gm-Message-State: AOJu0Yx5rx3ZzQrAOIxBJtjyNEeTD+C4sSb0JdLfj+CHxyv5t4BUPAGJ
	55uABNA9vYzzCmUz/DrblBvRwP/pR3Uvj+QBnUIvW6P0b/L0CRq68ihr
X-Gm-Gg: AeBDievaYK6ebGXFPwqy/EWtJBRPxfJJwPARY6U2nRUy4vMzMNXnYirGiGJsltrdA6f
	JB7SsMbJCesAdAGVSbBUWz9VQ7VjD2U5nTetnpk9fqQxpFk9bvDP0TGnBGSuii+0rcqlgKg5P4l
	8RMgLU331MtsZpMErLfYxPYPx20V4m+DT7a8tIM9T9/roYvP6UnBLOk4+758EezPPVcJfpeGcFb
	E2a+sVBCWLXn3ghNryhXBBeOmLCODivfzMZpgrNHJbemt8+VQw4KfTsKbJnfO4/FVJbjS1vsKJw
	RrvfYCexu4kCTZ3gQMXjXc/XDiCEOQnzS9Mn7qL/56vqVTBZXfIC+cyGFzpHw1E3ydp3fI+XT8n
	ByY3aqeUOj/Cp5aZ95BnAcfNmyNEi0LuuPIjfzk90XXAz3911c3ezkgScddG9iKqTUYTaw2kqSj
	lPQsozG9RiuafC/NtxwGfL+/PWt4CbHtYO0gi8oPL7a9aVhxvS1KN8/N+8jQ==
X-Received: by 2002:a05:600c:1d1d:b0:485:3ec6:e634 with SMTP id 5b1f17b1804b1-4889977600bmr191297615e9.15.1775510064957;
        Mon, 06 Apr 2026 14:14:24 -0700 (PDT)
Received: from [10.128.11.51] (195-23-151-163.net.novis.pt. [195.23.151.163])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d1e2c60a2sm42664483f8f.10.2026.04.06.14.14.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Apr 2026 14:14:24 -0700 (PDT)
Message-ID: <e4ca389c-882e-4757-8bc6-76563f448b14@gmail.com>
Date: Mon, 6 Apr 2026 22:14:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/thp: dead code cleanup in Kconfig
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, vbabka@kernel.org,
 hannes@cmpxchg.org, mhocko@suse.com, surenb@google.com, rppt@kernel.org,
 Liam.Howlett@oracle.com, david@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260331070730.33915-1-julianbraha@gmail.com>
 <bfdfdb05-77e2-455d-b68d-9da3fd9d1c0d@lucifer.local>
 <20260331173744.925a6ee6fac299f86a07a7eb@linux-foundation.org>
 <3cf0c280-e5bd-4e5b-884e-6c734619b821@gmail.com>
 <20260405122749.4990dcb538d457769a3276e0@linux-foundation.org>
Content-Language: en-US
From: Julian Braha <julianbraha@gmail.com>
In-Reply-To: <20260405122749.4990dcb538d457769a3276e0@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CCE9040017
X-Stat-Signature: 5me79bwm1zodzxhxt68srxqttqkubsow
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775510066-711622
X-HE-Meta: U2FsdGVkX1+8dYWqlHTfC81i3UUmY/IC+ffyZMDwfm4sU0RBc1/s5BwxLfKdNmKkDdzhJo3Jotbou6oCS3vg6PT+jLQql6j0PWB9SIMKjrNy5kWrkB/1cz/r1WxIf3oafk07ky2nRwChbS0RANyPBg9o1zHsWMu5gdXHag2khB7oTyqiPrmURN49iJyIGXhdNo0qzLiRnz2l0SkW5wjjjLD+4WNAJFMJq/xN48Pn7nBQh/Syh+TfSraLIOODU17acptAPoiFUCe4hlflzYIF2PYYhIRbU7YZQatr3OBlHzM4xM0o8g5QLwuG1YDf19h2ubQh6fFiDeIxLrDjpQfjz23vrBl/3NVbQZXe3coYSuNB0CXfR0jXyzy9U1LuHJ5fI7+RBYRmvR7DFUopkRluGeSCx/7OK88tIWVYlNkh76EvL4ZecelKbQtO/1Zl1vxQP2kgtVCiIbOFUCz9H1wBUVKz4a7vYfk/WimH4t/aIT0s8IqoPpMaGfGbAQVBrDmVIoTzqyqp/NbkN4n89gjgG5EBfCFTfxckCJXgTjtID5FIE2PXjYSEkibjW3vXl8mfbbKdebOn7Xek/L5iaVlgOORUZVsMmgi5ewRixumuw9x44Jpj40UFB+8IDqn7Ghp+vUg66drNjmUfnFChae3sqiCmMPJAGmxDbIn+5z9qY9icpoetLNYrG2bD54skEGil1rwCXD6w4DYbczH2HF2wLzpNhd49g/PbTGb9VyyfyR4pvPHdi/Sxr6MDuVE6p6rNXsIrw82TrOvHNJmXoTDwfc1ohiDMAJT1EhDB1rMC0X5rv2LVuJhrkkH1Z6ukz4CUgLkczhJEjL0ymqDfLGuCaqtgjhrpsKBkI6jSHIWH1kGWi5fkssiyZY1WRsM+y2vStORPnIAzPWi/pIn0JxWAmncn78NvomETjYJSISFuqfFtjUoguLTTNUSVLkk8HaGeANAGauRfrXb5IQu8/xK
 sx27AyrO
 UOwPITzVH6Wzo2Jbv7pyM3AsJhtWzMkay45blOjpCHolDuBPcwWKElTHvlZe24y1D9yssMyWl52NxDnas20TguUR4ROBfSHCdT0EPy096eTUZqp9g1coA/Smdbuq0mX94S0LGo2aZ5FW+I+q6MRO+oP5bqn7RAO9vqFVbzWRLOkTyXjzgFHFaoyVeo5gwxR8vM5CaG1/quuKEcr7UFtTboesHVIss6cRrdqusf5R2BlhB7Y3ZvFQXscoClBgtPCHo/s57atV4l4oNg39IlJL8PbDUNX6MDX27awTnrBvbgZ5cqh2fzT6fa02oiP/hD6Df/AsBipJlyqhoVJBlWsFeu5IqXnkgn0QzUpa+lcYc5uvN60G+sPxjm7ukNxqhKRr1KRUdoj/w2qLFzap44uSiiOR1ZXZjzGyIbvr1LfWKgu//RaI5utPu4bqqZAbxQSkuGl3U3Fp1Cmx7rAgmkHKX3Ce0hQQCA/a3CT9cn2eRbqMEfgzFaf7fotGRtvV4CntPKipHoSqiENZUdBSpt34ZiF0/jg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Have you considered adding kconfirm to the tree?  A top-level `make
kconfirm' should help move things along?

Actually I would love to move the tool into the tree. I will clean up
the code a bit and create an RFC soon.

Best regards,
Julian Braha

