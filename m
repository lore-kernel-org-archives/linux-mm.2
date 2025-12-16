Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F0D9D5E13D
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 18:54:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8BF86B008A; Tue, 16 Dec 2025 13:54:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A63976B008C; Tue, 16 Dec 2025 13:54:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 962836B0092; Tue, 16 Dec 2025 13:54:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 84CF26B008A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 13:54:36 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 240A8C05AC
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 18:54:36 +0000 (UTC)
X-FDA: 84226235352.13.F0B7011
Received: from mail-oi1-f194.google.com (mail-oi1-f194.google.com [209.85.167.194])
	by imf08.hostedemail.com (Postfix) with ESMTP id D248916000E
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 18:54:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=oqLMevJy;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of axboe@kernel.dk designates 209.85.167.194 as permitted sender) smtp.mailfrom=axboe@kernel.dk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765911274; a=rsa-sha256;
	cv=none;
	b=JgouLO0wyPjkH+tPFZ3noCPX4B8SQwj9DeJ208ak8UOEb/QhS7uWBgnWAgLvkF2eUop43c
	rfHr7HNVSsD2c6G+lNq4TCKxl2i01/wv4RsUSuH+GqiQkvG7lsK+CH9E37untpg+c9ppKM
	S8FR8PX96XF5gABfDfr4jI4pHI8tD6Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=oqLMevJy;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of axboe@kernel.dk designates 209.85.167.194 as permitted sender) smtp.mailfrom=axboe@kernel.dk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765911274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0iw2xY6JQzASC1R9Bed6V09JeLA5frTrl4y7H8Kco4E=;
	b=A0SRq5uoIxAGr82QEz1tyBk2QrxsbHSDA3DImhj4SpH8pOu23VhVXHjOpd1WYb/kMiN9wD
	1N0wX7gV34uV2elM04Wyo2iE9jVhuV58ICElzWlTtzu3HlF158mlghdAGFc8qv6FCZrdzh
	JugWtGAGeNwq6cMM6QO1L3ariZBSyzI=
Received: by mail-oi1-f194.google.com with SMTP id 5614622812f47-4557f0e5e60so3204753b6e.3
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 10:54:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1765911272; x=1766516072; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0iw2xY6JQzASC1R9Bed6V09JeLA5frTrl4y7H8Kco4E=;
        b=oqLMevJyODEZY7U/2e6H2SSWo/T+55RcTFgn3wy94DP2fFrtSbcXpMJUq8hb1j1enL
         RihBpCXat6ApBAViC8qMDEHXp4zbdFb94z++mN3k/L7ywTM81F4eWQKBNXnaI8uuIFxH
         QSV2ZEZ/9dagCLMcUwDivqBoEOQ9KANEir8bpD1wggvQq5W9Qk2pkDmVRx40JzvLQ3E/
         7CvoUkOQp+u+CwFbkgD0DtPhSpCqPXYw6Mm+5q6x828X2xKDo0SMkz4B/LCyqTk509+P
         Z2J8vq+m0HzhGgeSwupENjXLZwXFIH06fN+kbIyUwime394NFYwDUcgu0+NXTDa0wldU
         jPGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765911272; x=1766516072;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0iw2xY6JQzASC1R9Bed6V09JeLA5frTrl4y7H8Kco4E=;
        b=L5PT3g1sDdCCTgQzn7WIUH2P4Qz2NJQnum3ch8gZR6+fx7QqmZqJIDnu3kIMTTYKw4
         pTsH/vykGKfFfm8vAW5j6MjeCpafVQJIy0a+8JVrbcysKz3x/smjIjukBR6pUYDewyee
         DXL41Yde7eO4RUGoKZCWvOx/9q50j4BkC5NVe5/yjAw1S7yCx4SVp3X7TIrx2WqmZ3C4
         I3bKR5LlBrmHArH4eWf1ZOfpKwSKZGUK3QbTSQBoNSDdOZzhxb/yWoFHRdA3AT5DttAf
         lToLlHtFrgVZI033RTZphaYoDM0uCZHTmXHELTbpOiXFgkBhCOGIsVuj5dNbUNHxiFNo
         9kJQ==
X-Forwarded-Encrypted: i=1; AJvYcCX1onyCTRmUYFqSJHsBCA1/eLKqiXIuV+OxAl4qes6T9j2/A7C2sFTuOkLE5WEeEifZiy0Iuh+l1g==@kvack.org
X-Gm-Message-State: AOJu0YyP8Foj96rLTC3PhbRrILVT6wS4eHzfE178XsnVwdMWQ91G0Fhw
	OxgmibpwXfq29gS8OI0rVAAwTsURSkbolEjaep3/MbAK2mgd8oF1fyrkMI/G3remrEA=
X-Gm-Gg: AY/fxX7LDZI83WIioyGRpGGZWutH236+HG/zCxXuBytfG31TOvtozvttq1TPfXgdbJf
	+Z8QfDqaf//NuIQaTbU0RvFQbDFSQtQJ2Z8mRpqnqVmMlpX2qnlv5UeXyNQXRuUJOFyjvUqEs7I
	h0ThqGDLsPryxph+Jy+mxRnxUAMEtaRfAa6MuKE6VmzYh93JhZWOT4A1wDNYYUfKU/Pbz/sKSWj
	zkV2+KWP2rN35zYIGdVr6Haju8oWJzELiwFxHNgTzCioDEQadJYiWGarX84ygmva+/20Af8G7MV
	ZtweAU9woNsSRRHLb2g/rUW4fsc5TH7SY3/7LPm1je5SE54kIO7xsWm6IJAAwlH8IYCsOUybSh6
	aCX8XyNw0VizrL2wv2gC5q7lDkaKCcWNd7h/cClUX7Tjr1rNZJCN0pr/FADPrUS8XRZC332bf7I
	2DOHq9tkA=
X-Google-Smtp-Source: AGHT+IFPg0Br16etay3tCJOJnOVZ6iuOsWjdFdhNTD9nNZ31cHvdTDMftoR+8m4fheCbHLZ9JtH9FA==
X-Received: by 2002:a05:6808:c1e9:b0:450:ae23:54f8 with SMTP id 5614622812f47-455ac8721f9mr6756020b6e.19.1765911272568;
        Tue, 16 Dec 2025 10:54:32 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45598b46bf4sm1832321b6e.5.2025.12.16.10.54.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Dec 2025 10:54:31 -0800 (PST)
Message-ID: <4929c371-b264-4049-8618-095f748ef5c9@kernel.dk>
Date: Tue, 16 Dec 2025 11:54:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: retiring laptop_mode? was Re: [PATCH] mm: vmscan: always allow
 writeback during memcg reclaim
To: Johannes Weiner <hannes@cmpxchg.org>,
 Christoph Hellwig <hch@infradead.org>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
References: <20251213083639.364539-1-kartikey406@gmail.com>
 <20251215041200.GB905277@cmpxchg.org> <aT-xv1BNYabnZB_n@infradead.org>
 <20251215200838.GC905277@cmpxchg.org> <aUENEydFvVvxZK8r@infradead.org>
 <20251216185201.GH905277@cmpxchg.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251216185201.GH905277@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D248916000E
X-Stat-Signature: zp7heqgswo1es3mkhigmnsjj7spn8r76
X-Rspam-User: 
X-HE-Tag: 1765911273-174536
X-HE-Meta: U2FsdGVkX18ZdtD8A6vvlSgZ1cN3uuVHctXpE6FCN4yqZ+HkHHYZ70go7uvaeIvdqQZoU2o3xVKHE+y/w0n7PN3oKkzVKHkyNxeNR2hjD80tcU2Iwgd8qXx1EftuWNz5xCLPv8XGGL66kK6Y6lS9Vj7cmljzpkhTkT/68eD/uBklJ3QprC3DNo/i+r+P3K7oR1mu1xMtJylmbiKm/kxdJf8qZngFv/UBF36mh1rpY5L56jLb5MLCdmvH0kLTGPSj4TW44CnXnpQG1QhPOLCwjcO4JRgkTrclhRsOOQsZk1KHQt9Qmlp9dB7iCN9NTWB2X3lx4q/2Md1BUc5HYUgRWktprFum1DPGMhWfO4Wxg9AEPHVhGUAvf9Sx97XVtig5zcNKo6XNJo9y7rdMbjpHWHBSqbmyKo4Nh4dHS+dkfBQmG80gXTWwcAmB0eLzlr6DJ1ZOrlRisv/1tNAmAMsfeiINW05tkXqe1Nsxw2O20km1mVOC/rSaRASu//iRh3NwE3/nsg5o1/4DYU5oibXZqG6ut51uoQ3BKGs7eevC2XyM6qc/2485zm976QdbyxVZjUsZt35dnyn7CJxxk1WD3C3pcRKMH54NkGsAPYZpJEiqBMrz6H+TWxTDpxt796rWLaw/2q55nll6QVqPYY9/hkjC0Hbft1SWYQq9A4PmZZMcj/Clx74lEwjx/RSjCL5p94DAKyCNGjaa5XxoK47W+3uLIfRr99K1iNfVi5q/N4jN4ul83BCe2hTDl7Tu/AjtnEiTsKggkv9R70ouAT0qDKiasE04FhJf3UazIbgFdSrrJU7qLbBA0xJ55m7OPUN26pjWqF5eMZZZBp/voXa8KiUgjxCApPYSkDKFM/i6Wj62wRgdXTqe9phFKBNzCvSPuXFjnts/01OpV+Niiv/FPUHp7CUrE/rdf8Kd00RxQR8MfpcE4VL8TjzBsBt+fMQFfHqkSxsABPgjjskasqp
 6qEXN+Ud
 n+ga5IX8/1LybpY2Lpxji4TQlzcEGb/1MHeEwn336VsnOzvdo8OK274LRTh60NpS4POnNpL0L+WKvvNBG+cmyUXBvJpJNyJI3yXm7jobh/vU+kX7yga9cBa6KzvkaHq8b7pnbHUtx2kXHz06f9GgtQbL/BpbyldrJ7ZcJujuhiwDWzEnwtrvlr9p45RG48P28xM778P+OacbK1DVyM+R2VXroLtiAv6jm4m8YzA7vpTCgDvlX4XjP+6FTn0/eFfNs0IUtRAW59+8aAvqJbqAOuM/Pin7E7s1bh70ym3XQSU5KLoUMgTRi2wrWah9odc6KYlJY4tnDo4mIueBa/X6a558AHEKc7n6Zubueu1uBBO9Q980b217xLfFRnt0VOe6RLE2+OWQBfdvzKBI6DVzi7SYtyyjNrs98ZFQ9XwLrPntnimyy3jUuEc7R1W4qBOpfsQG6TUR3YjAwXXLvMlBOBaprZbKMbQE+V8vdNj6o8en/tbs3Xo5M3J5eWp1jQ1IhNPKgw0mDF7bSqZcD8jA3Eee/l2hlouXfGlIkAAV8IG9Hisy4fwilxXO5Fg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/16/25 11:52 AM, Johannes Weiner wrote:
> On Mon, Dec 15, 2025 at 11:41:07PM -0800, Christoph Hellwig wrote:
>> On Mon, Dec 15, 2025 at 03:08:38PM -0500, Johannes Weiner wrote:
>>> Debated whether to add some sort of deprecation sysctl handler, but at
>>> least systemd-sysctl just prints a warning and still applies other
>>> settings from the same config file.
>>
>> In general dropping sysctl will break things.  So I think we'll need
>> a stub, at which point it might as well warn for a while.
> 
> Fair enough, I added that.
> 
> Jens, that change seemed small enough that I carried your Ack, but
> please let me know if you feel otherwise ;)

That's fine, fwiw I fully agree with that change.

-- 
Jens Axboe


