Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 810DE606A323
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 07:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.a=rsa-sha256 header.s=shopee.com header.b=L0FJbtAC
Received: by kanga.kvack.org (Postfix)
	id 985696B05D1; Tue, 17 Nov 2026 02:09:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 935EF6B05D2; Tue, 17 Nov 2026 02:09:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84C5C6B05D3; Tue, 17 Nov 2026 02:09:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 696396B05D1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:09:40 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 01A4180312
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:09:39 +0000 (UTC)
X-FDA: 85443735720.04.70BB8F2
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id E04B34000A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:09:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=L0FJbtAC;
	spf=pass (imf27.hostedemail.com: domain of mingyu.he@shopee.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=mingyu.he@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794899378;
	b=xK1fZ+Mxt+tjsodqMJHIzvbR5Cr/cjQ6GyrQ7zE31uZWh8PA5XtyDJv+pMPUC+2IH+tmez
	rbLsDE9wTzf7nu+BvlHTgdotjlSkzfySsKH00vXO0R1c1TRlKEGeRj3X5ZT1CpG6HkPYSG
	iHKbvXxl7Yb0QsiMHlbJvG15S4R3k7c=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=L0FJbtAC;
	spf=pass (imf27.hostedemail.com: domain of mingyu.he@shopee.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=mingyu.he@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794899378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WnR+cG1zrK99ABssRDEAQLG69JFukBqigLZq1PXp1Q0=;
	b=WgWVOBVtW0jH63kEhORc3TQgUV2vJlnSPCsOrC8nuNwzUaRQayDQTHV9e309Ku9ZS8p5vD
	bfibnqqeUfoFJaymxt6micszCi/Zf6mfBlpfWkaFeqVTHu7fY7ajJlYcCJPPf7fcanbwZT
	I1bnny7DOkHvQ8/T18dtN2tA5+aXWY0=
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-3704d30b84fso5159923eec.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:09:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794899377; cv=none;
        d=google.com; s=arc-20260327;
        b=aArSJHXZGZ9be+LnJYuEcE3dM2Fdo5mqrvMIq7mFs+5z6NySXcH2rbsjU5/5yPt4sh
         5UKknAxSKYU5/g+zHZXLNGLPqrwVOrauiGYNRuOVbSxHgdw/+d/TanW19uhSsdvCnE3b
         WKvTbmRFTjA30dYpS9W+mbFkKA/envH2hm9hpU3cY9Q/hAoljdaVs2QTIOw9vhZdWplA
         5H+Vimaj1hidGimPA02Jj5GWRKBwx/fug8+PZ9gZIXlu1Svb9Sd9ysyGCMmiyYfe8xbE
         dlsd/C4Rqs8UiZpbqYDOV5lGnWyQfDTtr47tY555ATtN5AeBcGI9ksr1GWxN9LBnJbgG
         ENhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=WnR+cG1zrK99ABssRDEAQLG69JFukBqigLZq1PXp1Q0=;
        fh=M5Zb/ft4jcGXbWob2VnET0fRZvywK6+PimKZgaB/KdE=;
        b=hPoSQervpgf60kJyCo8JruEMsfbGqDqcHLYTfVW6sKYDqihtYreNlBtirP3HjK0uMW
         CbcRwBcBsdPrrMNJfivERSxW3A1RNXU7Qu99Y77l9YKkfWsq+LRtcOkF6GNqTTf8mEgv
         jJeSrJO8geH26sbgPf6tXe4LjZzRsrzILuLFmu0uKWDI696CBPPFt9d/JNggqY98tVig
         n7ye0+Inp4Q+AmZpOlvWHqZjQdp5Fm2tlGdqIuNCB8DPljU0jWipuda7O0iyrODe1qhJ
         zXgFfibFfA4oOCf9P3MMGNwJXq8awz0TIOWnwLFwt00eCnFLmVLMizBIHdDmgFpGvSEO
         h3TQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1794899377; x=1795504177; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WnR+cG1zrK99ABssRDEAQLG69JFukBqigLZq1PXp1Q0=;
        b=L0FJbtAChxkStDy4pl4I7cOLY4C/xPp+hef4UZParEFqUJDzwOUh8gXgcVo52YVrcL
         kA/LHVX1Or6sHupKQwKdhL87q0Kg6I0Ls4jQXlpiryCCb7LLgHhEfbJ/Jv/5fI1ZA66P
         fAPnO0UzwuHVKbVlZnpy8YGaaYHTFIJD0hwvrEnRzzWK0r9XAT+zrajW31f8klgTEbkO
         6xlGmi+4blA4kwESfcR0uul52bbzt3DoAtQo8IWijTNTg9awDs92ms7nUWvTBJsLx+5Y
         ZClVw1YEvLhl5U4fdb1GXlapqGZJmlbfKe14n/MSP/U8ynI/wzVKJ13crr1GlzEhSdQh
         gU1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794899377; x=1795504177;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=WnR+cG1zrK99ABssRDEAQLG69JFukBqigLZq1PXp1Q0=;
        b=wVeQsJxiS1Y3mRWfX9bpieujmegq3W17QUSdozCWrX91mmJRqoadjMxpeKc6L8630T
         ee52pKwTvMdRKZ4bg8oYdqqL244mwPzv39R1TVUPsFCQw488qurcBlv9tTmGG4781P3F
         EUTGo5f0+TgkQo++nYZjUAYrqG2w9jRFzU9qEuxcX0t2gCSrYh6NjR4GAf4TOfkStIFp
         E2AdtfH/brZpGf+7uR66oj9DeImS9rFhUbt7MTdUdbeYkVhtJx3TFce1qi1DOtzfGL2e
         jaNojx6Ul8gO4nUkyObDyghcLO7JRjn2kKgUVzIewbnr1Kbc+TxZb83FCNVGmHl+kz6o
         6csw==
X-Forwarded-Encrypted: i=1; AL+hErG7qgqA43VuNjwiRUy8No09Pa/4cL44UIIqSQNO0rXgw+uiIFZyKQPWDzCdCt+HwXx0pn4KPmG6Qw==@kvack.org
X-Gm-Message-State: APuU4Z/o5b0MGr5jMX0ELa6i3srw/QVjF/YbbJod0uW/EY51m7G+Ae9I
	YJYnJ44v2S5y6EbaVh+etlQcw10C6I+V7EVbLDPlUbXwff3t7NzBHcLs0BgDUR7bPS+eX6r947I
	U4MeY5rdnGuq0/YKFLBH+9bh18dtt4Hk9b3W3CqmIIQ==
X-Gm-Gg: AZFdTZfOzKvI7PPXEBE6M/z9gcSrArovmeJDQwOhD6o1JvpiQVcDCbbslGVSddaTcYx
	AQMEgITru+aS88/PZCLgDe5F0/bctnhIqjIhvmdnvtYixZbLIT+n51imd1TRtiT6Ho2nxCfqFjF
	Ns7UFNfN/66uCmGhymRrv9KSsBE0QazKOT2p0cV0qfeNWk090+sS0K21AHmox7mXIY1nsXGvnCD
	bSv9mISuK5G/6HWRgL6X/K4y420fPqgu02juxzmPdUoJFeihAYAHUPR44D6Zt4WTvAwwAkqE0C7
	i493E3vogxhSlCLSP5ObdQ9mFy+eZzbv15JJ9bBRyI/ZKac8K1E23g4tSCFBPbA/uaUK4jKh1FM
	zZq6n9F8snIsAQHxrfsM98LM8oZb/nRdelUwf
X-Received: by 2002:a05:7300:de01:b0:369:daea:812a with SMTP id
 5a478bee46e88-379682c2053mr10636754eec.30.1794899376652; Mon, 16 Nov 2026
 23:09:36 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261112041348.66915-1-mingyu.he@shopee.com>
In-Reply-To: <20261112041348.66915-1-mingyu.he@shopee.com>
From: Mingyu He <mingyu.he@shopee.com>
Date: Tue, 17 Nov 2026 15:09:23 +0800
X-Gm-Features: AclHuK_OdWVIh2slf7tcPI8uUm8C9Xejgxejc9Hqh6QFSCrmh8eY8O7vcMROZXY
Message-ID: <CAAoBcuTiyvYHPpKNzYsHdLTGmkQmrKUZPkJAkm1qEdOeu18hRw@mail.gmail.com>
Subject: Re: [PATCH v3] mm/bpf: Always flush memcg stats when explicitly requested
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Yosry Ahmed <yosry@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	littleswimmingwhale@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: E04B34000A
X-Stat-Signature: huc9f94wrx91smf5nanf34mpafr45mdj
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794899377-571233
X-HE-Meta: U2FsdGVkX19hDSWTgbZV8HzLEdXbqb4PbM602kOlLQfSljolB2Tq00mIjG7hNkMvCYbPNsqm6E8w3ww746/zmkPZQR+EZZyekrsZDJLa91DwuP+BHabFX3dkNCnYHQ3PZWxQGjR1bP3sU6WpXo/XNHnIWitzslP124DGbmQXQRYMpHn2m4o6AIKt/GoRj8WQemez5QI7LDTiEas5WjrffKtr3MQXtd648CVPJ4KHDwJSd0Ye3l5rR+Q8Kozj3KlA0HY3aSnjrsGvI+2ZhX05D8eJ3T7sY9EWIud8RuATjV+ZPyjnkvTfMSlXySzbr+wrIls4FDZUZoQuCKgE82rUD7nSe5Olr2clJqz/gEUsuDh4Xx07DpJy0QYiRlyC9kmQeG3sN858sF34tKm2gqxhthbB65kgq9O54CS30GyX2DghIEaC7nmel2vx3IcvuEKfVF4k0sJP7vL79Oxke+1YYUcR4m6T8BT3UWNRWXL3N7k24BqmaX9xmOXQHCqoFXQbRGqJUkkXjM7tBR1nAcTi7rFlyWhgIOELpjkuyVx/lGN87T+Un5Ohh8NqQpVgsEozUQXxdcOziwznHB5kl0Mui9GIPZEkfeJOsPPhsbbOUJG3+8CnSqhlgBjQNI6IPgbGLeWExXho6Pl1bwBTnMxPNueYBasjmMZQwidSRxVMjS2QstUjESbd+24m0lYKN680g3DrtIBuc1256GElz1g8/37R9OuatGW4FIeu9zZ5bDrbhNQWiFAK5LPGkBiaUfDD1nCzbVAJExzg/HduOMY19i9b5/Hbyn6tUb5vWzapKw6vaxkdvoksPaLXMtbMuEpV/Bz26KXDLg603I7Seo0ShFVWQOUvvVf6R4aEgtZoKcoZ2AkFn2zXIUaSJ9SWb2Jp+ioLXQsRZPejZdA/QL/sPDDrnT2qX3A5RePZFTnIzTRQMNsyaklLFQe7d2kmmiAVh1H2J+EkMWjIkhMJmdt
 z1RfBvKF
 nkJKouc2vq9r8NKZuRM6X9/TsVPBlrITXpiRtwCp3grV+D3x1h1ci7/j9kR84d/MBtM1uzJAmCBn8pMXaUundg7eeNwkLxupBUkEnBSm0fVcOTL66BDd++ycqmJ0F0SO4ZsRMx+GzMzqSLJITDVjNfFa91QDZsbuscv5/1WPsCDp4K53+vvVOcm/naBrMlLvoagX60RpQ9CkRBA359pvTMvBu8TndUs8mzvAkM/odrsMv42oh/quHNYVvQUmhCEE0lTGsbTaXkVXtCVdDhCSNKLsXGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi, I wanna gently pin this email, thanks.

Runli

