Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC8BDCAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:48:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 238C48E014C; Thu, 18 Sep 2025 10:48:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E8768E013A; Thu, 18 Sep 2025 10:48:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D8F58E014C; Thu, 18 Sep 2025 10:48:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EE6058E013A
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:48:12 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A3EFF11855B
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:48:12 +0000 (UTC)
X-FDA: 83902651224.17.7BC5C50
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf30.hostedemail.com (Postfix) with ESMTP id A08E980017
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:48:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=M3OlU6Js;
	spf=pass (imf30.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758206890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iAxT3fVcqeuUfVjtRTsWYQE3cdG0LYpzTMO+2TQXp/o=;
	b=bUExcLegTz10kE//48AV/ve6d2WQqT0ulHpXz6mKZenojKEcO1/DDGB1TZGFKqYTOeqD4x
	rVC/glD1UXOfL8OBVmRHbQkA3BMHO4xVIp7Fo1y6FGMHBDRyR7ICDXzs6uXyl0uWCzWwWt
	17bPhWr3zHnr7Kwy56TL20ovicnum5E=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=M3OlU6Js;
	spf=pass (imf30.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758206890; a=rsa-sha256;
	cv=none;
	b=cCPM6rdE4Rj9+7C4tnmGnaLmw8MIWFZ7bx70t81sjdwRGBMM1NuewHtW2PanjpxWv92WJf
	3XpxplUOgD3AFpxLwNLDotlmnVaSgBoT/tM39l7kBeQ2TooosOjIBHlkDrW+Q6/D5u3Lyx
	1MzDIx+K3kXuQ6g+Tqe1Rip+YrD0smo=
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5720a377d2eso129830e87.0
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758206889; x=1758811689; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iAxT3fVcqeuUfVjtRTsWYQE3cdG0LYpzTMO+2TQXp/o=;
        b=M3OlU6Jsdl3aa1RCdhAouDulXNOwkEXVEW5ISv/HVi/wtxgpEAUhCWcsgXSvrEs3gc
         q7H5kjnDRg+5LyVIZiEj4qpJgejVVMePCWABJnTDkhTeCuS9UYTGNp77oisZnzsgD4ql
         5oTkoIyHvwmnHohxEp+ktn9nExdz5uDIMHCpppoYPyGgWFlpw0GLwUaGlRKWjtKjUQOn
         NB/1L+DvSt4D8AMjCqRZ6bakU7LPX1WO81r6URKDdp/Rjf0kMkXdrdcw9Szy+4cYqgdV
         DQ0RsbuF3ki2N+3zxwuxzsFOpOOy02mi0zwDy474nDJCvC/e40sXhY6772hZT7NGwSrl
         EpLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758206889; x=1758811689;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iAxT3fVcqeuUfVjtRTsWYQE3cdG0LYpzTMO+2TQXp/o=;
        b=lJD159+Do0xnDSI2MunC1tKi/1Anpaz9ITjVK16wmo/qqswd3UEk6tBYyw1ybDoMvr
         NtwER9aUlaXp69ipKyR1PaQh/3WqHU9pQV0V8GYCBU1x6FzhWm8fWKCZ+n5NffN1vBFX
         BJoHiEgxHHpIXuE+jeH+uq/gPKRZFczIEWF6TL4yD/6waCxA9v0lRsSkPUOrq/vISH43
         bnOLqnb0yNgJIoxCq+zwI77uBB6h/75qGkcW/2CmvLF75Ul9L77zjs10DMbv0GvUXGoN
         m4y9r42K4jBPdazeIZtY5BLRu5zGldLYbiTM5eBV5yAlHjbvOzdrZcC/1mlM717JJZsV
         yGsQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZItQBw/vEdBbzf2MMHdKShrgx6IqQVLfWOsLZWKcrQZLvacFuDyAN6IVHWq4KjEolQRxIgZF48Q==@kvack.org
X-Gm-Message-State: AOJu0Yx+wzFWZUghNljcyX3b74RxLQ54Vp4cxL3lbab3SjgvSIAYSa0U
	AzhWmquWYOMtQwP5RrVqKVeWPYU9Ff5d6W7e9qKLeUtdK9mvMVnS4H77
X-Gm-Gg: ASbGncsSYVip9rFIhHdn8+SXDdp5EjK67sqZD31Y8N305dB8F5wEegoXhFdm7z4bPlk
	vLdigg1wCUu0O31mNOiljGaLOuW3RvpeIPrI48gA+KiUWLNsSC8XHQ0kgk9xlJweMvVFpbSRopZ
	5Asatp991zcdzrP5whUaTPTExykgC8RtPR+OWVPZek8BcfZah8W5z0iZ9S9lYFu71MBnwGFRVfa
	h6KaLdtkYW4qZCI4cdX4ztHmg8xODFD9Egd7Gb6slPaOo2S3iqmy8viuDvdejX1J2JCvB49rwN6
	Dhy4HpQlaWsBxBoLyMYrMCUtMtNFKpXzeL1Lv9lHDpcRRFPznoUaBYf2Py5hKfsXlb0UpUyqTRa
	zhoCNk5cmpkuxK+ZXzlV5vCC5NP2PNnETKFC95344PrsJhTYGwEox1sNAUw==
X-Google-Smtp-Source: AGHT+IGHEzqw59r0e8igL1+CPPVfjvLXVyO+/F/7yKLyQTtxPDFzXxzv7jI8gfftK+xRhHpq+exTSA==
X-Received: by 2002:a2e:b8c5:0:b0:356:25da:89eb with SMTP id 38308e7fff4ca-35f64fef9cfmr8254611fa.4.1758206888768;
        Thu, 18 Sep 2025 07:48:08 -0700 (PDT)
Received: from [10.214.35.248] ([80.93.240.68])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-361a1e07947sm6404731fa.12.2025.09.18.07.48.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 07:48:08 -0700 (PDT)
Message-ID: <9f332ea7-4210-42f8-b640-3135cdd808be@gmail.com>
Date: Thu, 18 Sep 2025 16:48:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 2/2] kasan: apply write-only mode in kasan kunit
 testcases
To: Yeoreum Yun <yeoreum.yun@arm.com>, glider@google.com,
 andreyknvl@gmail.com, dvyukov@google.com, vincenzo.frascino@arm.com,
 corbet@lwn.net, catalin.marinas@arm.com, will@kernel.org,
 akpm@linux-foundation.org, scott@os.amperecomputing.com,
 jhubbard@nvidia.com, pankaj.gupta@amd.com, leitao@debian.org,
 kaleshsingh@google.com, maz@kernel.org, broonie@kernel.org,
 oliver.upton@linux.dev, james.morse@arm.com, ardb@kernel.org,
 hardevsinh.palaniya@siliconsignals.io, david@redhat.com,
 yang@os.amperecomputing.com
Cc: kasan-dev@googlegroups.com, workflows@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
References: <20250916222755.466009-1-yeoreum.yun@arm.com>
 <20250916222755.466009-3-yeoreum.yun@arm.com>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <20250916222755.466009-3-yeoreum.yun@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A08E980017
X-Stat-Signature: kfqauwnordxxuigg3z534k9ra5qzc9xo
X-HE-Tag: 1758206890-594807
X-HE-Meta: U2FsdGVkX1/sU6GwG4JvcgjTodMYa9OlsE3QDxK6bs/TcDVtwe/Zh0kkwELD3s1TFyw20pvKsrpbbjClhVHkWOctSXL8W7lS0gHwmkXDJdZd0NA/Hkth6u467l4sqt9UqilubFcxeDIdkGp48JKFGGMB+kmsOydxT1n7WB8sS37XSu50mFglU0+xplN9lD7/DvvQxGSTLTOppgHcuBR4ecn97XiU84BY6aszAYzupyBxAYwa33pTFXz1KMCXGGg7NGJPwNoIVpZLgMCCs7V61jdtVvSb/avr5exyrYcLhNpZM5Eq50AQUEFt9k1VGruvtOTzFz7d3pQ2NrHuNtSZwfxCFSVa10TC+4S7XJ40qoVxDM8RKNBfhRHEAbl/5B50kuO7AddfGHghFq+XdzxN90iZTJk+VQKAnX0YB8b/hhAQG92ODBsTFE69EflQrUSOmts60HFIQFNdHnKPTTM7YXxNljs/7hh7BCpTNBgyDet1T6R7jcuDDBtpLuQlVAyNzFNu+3dtBjOiU6Fh0o8JCz2fBNjltC5LTCoXYdbaMDMtNEPOs/4Zj3MYgDHLxU5YGc7Gu+ad3IzoHY/2OsaHHRGiEHpRJtEiiWMKgLlLspEhsiSBU1m0xnBM8fYm7bOxIH9yxI2JkelJwOnUU5alQBu7LaeCwT/TPN5KM1SVPH7sV20DixNAhKiET/r0z4UH0UMzOzXSAkwJBUxFOsmOto0YzUhy/iRkqMLEBwUaVnRlzNSl38kuqtVFcKH2/ayqeG2jAHESKRdRtS7edsa6hiX2IbLaq2iEzdWA8z3gOxAAOzKhmH4txM805u5WaATM963cn3/iMDZriaHjUugf+hgZffvIk9Tl9kEECgMZ6USTkno8FNAmG3xmnzDAWfbIuZsCfjI7wh4O0KZm11IvhIhsRAjbOLPdad/d/A0/ugGJ2vTogToDNULRYOyrOUFuF+CD1BXVkpSUGh9+QYU
 E2iuDBtC
 DB4vrtCXFEYgJwuqoaTzHgwnTfUIC/jYQFKDmK7Bi45VgY2ocSG8Wpa1il5KHIzF/55TEzGNlts/BnNh/iejWmIZi6i38Zlh8eyDVk5NRKmR6ErrNaddGU1Hvu9sMkXryYq7IFSSH//SVRAt+Efvdambuha7tDq8XKQjIyjKHcxJKt7DodtRdPD98ejc7lYdq2bYZ6lQnk8+Y9fqpR9RSNHLVzvNUI3e2kSm58TR7CR3meHnZhSfUhsc+LDe87veU0zgALw/P+5yyaJh1+flppSjYAGLmC94bEOkonpb3ZuVdQE5vcJ5AuOeSxE+/x83tjWmBCgfs6L9QWmd4h/cDq8xZwwLJmqNUsGYO5XDmtUMvJEIZde5Xxo9HfuY9IkJxwsrYcD3Jd90id3wKBfyNeC2eqo6aQZoETXAHqbKoVthcYrVzXdHzPKiFhxK3wvPAtIir+TSaBiU/6CbQHbq0v/Wkk5RgEVaIIzUvBa4gPFL/clG9wT29XI9HzhqQAnORv0fCeAsmZZUjZcrvnZTZyD9nTfTDnMCGUMV1+cdDF0i8e5g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/17/25 12:27 AM, Yeoreum Yun wrote:
> When KASAN is configured in write-only mode,
> fetch/load operations do not trigger tag check faults.
> 
> As a result, the outcome of some test cases may differ
> compared to when KASAN is configured without write-only mode.
> 
> Therefore, by modifying pre-exist testcases
> check the write only makes tag check fault (TCF) where
> writing is perform in "allocated memory" but tag is invalid
> (i.e) redzone write in atomic_set() testcases.
> Otherwise check the invalid fetch/read doesn't generate TCF.
> 
> Also, skip some testcases affected by initial value
> (i.e) atomic_cmpxchg() testcase maybe successd if
> it passes valid atomic_t address and invalid oldaval address.
> In this case, if invalid atomic_t doesn't have the same oldval,
> it won't trigger write operation so the test will pass.
> 
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
> ---

Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>


