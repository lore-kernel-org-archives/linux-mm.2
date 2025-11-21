Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED34ECFC26F
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 13:02:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3561D6B0024; Fri, 21 Nov 2025 08:02:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 306536B0029; Fri, 21 Nov 2025 08:02:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F5D86B002A; Fri, 21 Nov 2025 08:02:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 071106B0024
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 08:02:51 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CF132C02AB
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 13:02:50 +0000 (UTC)
X-FDA: 84134628900.14.6B3C3F3
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf02.hostedemail.com (Postfix) with ESMTP id C5D2780028
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 13:02:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mclMI2fY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of asml.silence@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=asml.silence@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763730168; a=rsa-sha256;
	cv=none;
	b=iF+Vd2sVvNd6Ob7lCKs5wmyBjol1PLwL+WVfsdB5TNKGS6FB0bNCzd25qTYmJ6q7qOVomi
	6HcuZdBeoGwQDQ5lDtToo1jFGd6voXQODT5tMJ0hmcbOIrk3y7satux5BfX09k03U/Kw2U
	iFwj4KrQpmYESMd7LqA5hHLdrW3P1zA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mclMI2fY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of asml.silence@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=asml.silence@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763730168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+karDUIwaluMCQfDCqIqXlR93Ss9N56UP9ZbbJblk6I=;
	b=whW01gCujmZpQ374mWfj01LJ2ycCbmUJut+vwxSS+ECuRQLp0kWANB0O3468IF5U5YGwka
	of4JwcPcHzaptneZ3K8ulOsgp16B84waI6zraQcEQfwsL06TvRtk46Gz2fDRBUTBYrTMJO
	vxUGxOu0CQ3RyWsmclhYpSwyliRDHgg=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4775ae5684fso9519315e9.1
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 05:02:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763730167; x=1764334967; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+karDUIwaluMCQfDCqIqXlR93Ss9N56UP9ZbbJblk6I=;
        b=mclMI2fY4QIMxWpINCSWM1qg4L/1hIz+pWCGTO5yUTqqOIVoMqqCjl94FweOYxD84K
         sTlA5DO/+FWAoe1BxxEO6nF/+iODPY8QG4OmEsAr6MpC79GKCxezxaKnhhIg9YzXfSFV
         v/CKLxMTmglaOO3CJx/zF/InCtq7gX1ElEUP+Bf1MPGb7uyhicKKKrIUxRytN8F0ksXZ
         APWbp88LluPSzam5XXle/YA8R55uRdwR7PKePS0vfas977CjlcMnMc7CWp1xCKtROrTq
         Bz+tZDMuNC37g1vWTHVnmlO5Kna3M/0lP4QQwcrH8jXxRMtuL6tLmSm3tHHiu5EUC+Ko
         YvCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763730167; x=1764334967;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+karDUIwaluMCQfDCqIqXlR93Ss9N56UP9ZbbJblk6I=;
        b=EcMR0j6BKReQnOB4KUOmOAQJIRd1oHPRm5KOqDKWrXPfcmJ6oEMsPtwBSBLt514ESb
         gWUBq9ZO8//N0efw4suvuWBV97c9j3pAiaj0DnC/eaziqh2EnBWQSATm8FpAg4afDp4C
         fQyeg7sLUjBAecry3gAD0Rgpy4ITH7surDTIZv26xa6tgJerS0Aphq1yqBn77EwQ+trC
         5RF/6I2Gv2Cu8iTKebv79Mz+Xm1sxsQKtFUMNBZmuOGZi5cqoXEbq4vO7ZNSfA5RVZwP
         pEdNCxLFFGc/S48gd0I8m6MX70fuc5E/dd8mXs22yEkCxa5tm/bD2Hi9PtlzS8hm8EdH
         LcEA==
X-Forwarded-Encrypted: i=1; AJvYcCW8sKl6EQCSiANF+jTuKHhG9Tyl4t/KtSlAEXfMOK4zv9U7x8JMeu+3Hq0Xi2qvNGfwxXBSP0mM4w==@kvack.org
X-Gm-Message-State: AOJu0Yy9cniAY68KET+5/YwTUJugzgodiPbT0rw2y0JeogpuLxHHbN86
	DmEyCTeVOw57YoFuSmTwIVHXXnYw+iGP6LCHhpwnpr+CCOwfWcrau6kY
X-Gm-Gg: ASbGncusmiejrUftSyXF84KObomqDm9n06/oNDrC6Q9lfcLGFNs0S9QJP9m6sD4o/Da
	kJUK7LPujX77fT05nbD34mWYy8wc/0Y10OFQ1fHpHC2tRhqwQdNkQW0y0yT4P9SY8Hm9mXwH8pi
	BGaUuK4aRkeOp7ZvqmBlvfoIreaaRoBX8aLSc3V2kGZpfW/i43f0TGCIg3OiBBbHxG9B8VE3yp+
	vUQHSYMvENIfD9yNdRv7zzI6lVsNGPevwM8tvR+4IioqZYznYylDakOrxN2t1jCpidzisueJEUA
	a1eOwt4/hb6eQ6c6EYI7mORcPMqEQfl0QtL3mrlB6yHXvFlB8s8b/KOkzjrDFBl40QpYJdYdxUL
	4R/8tMb60/K/0Ud2eIL765YYKkfFduixBkC3/7lkbXPmRN9QRNTl6MmBThnMGaxNadQiRO3SLf8
	CYhnfrTUovjpabQCd+4NwODNjgurq8pjKEVHaJv3/XUFI=
X-Google-Smtp-Source: AGHT+IG0dHMzWmFJj/rAQgcaWfg4AOgSKobtzdJcmRQ7G8ZljQW4t5jDW4Xt3mXuEOEmi28tMC7DZA==
X-Received: by 2002:a05:600c:a07:b0:477:a3d1:aafb with SMTP id 5b1f17b1804b1-477c115c657mr22920655e9.29.1763730166896;
        Fri, 21 Nov 2025 05:02:46 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:813d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477bf36d1fasm41153185e9.7.2025.11.21.05.02.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Nov 2025 05:02:46 -0800 (PST)
Message-ID: <72e3ecdf-343e-4d1b-9886-67d48372a06e@gmail.com>
Date: Fri, 21 Nov 2025 13:02:44 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 1/3] netmem, io_uring/zcrx: access pp fields
 through @desc in net_iov
To: Byungchul Park <byungchul@sk.com>, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 kernel_team@skhynix.com, harry.yoo@oracle.com, hawk@kernel.org,
 andrew+netdev@lunn.ch, david@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, ziy@nvidia.com,
 willy@infradead.org, toke@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 axboe@kernel.dk, ncardwell@google.com, kuniyu@google.com,
 dsahern@kernel.org, almasrymina@google.com, sdf@fomichev.me, dw@davidwei.uk,
 ap420073@gmail.com, dtatulea@nvidia.com, shivajikant@google.com,
 io-uring@vger.kernel.org
References: <20251121040047.71921-1-byungchul@sk.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20251121040047.71921-1-byungchul@sk.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C5D2780028
X-Stat-Signature: 3rg56m1n69ro9r4e48334ywyfhoyan86
X-Rspam-User: 
X-HE-Tag: 1763730168-306996
X-HE-Meta: U2FsdGVkX19hveWV0Hz5aFJOUys3m2zJ24LMm9Pj1BTfzfWAdPaoA7KGnm/k+wNDQT8ji8rLJvfU3bCXRGS6yyfGn3KRn75CxMoTMtaDXtIYAP8apKH39GLv8bO5H6nCC+UyQFwMpLG49TRCvu/vbLPQEyeb1VO1fsnIxKyYoXPF5NMMLUzAY+pisUdvt+GtQzlpUx/+qyHEUzLVuVDcEdNpAV74pFjRZid/85lJfyXaoEjSVBNLBq2X2tstuomNJ4SnPAg4fQjS64QH9zobbp9FETs6yGDezTXBAX9+zCDWJW8Wx422C+J0xLLR9gYLtduaLsvB/rAZrU1zjZ75faJU0YvS57Oqe9iI0gAY0D7nQAdQrVE4hvkAfQa/PtSWTky3egAtdx7yeTuCm2dSEHWh7m3xshKl6dlRu6I+lBR6l9/kQd8MT5GIgQlDbmlhJqWwjhcvvWhkhJVLsm/V3nBLoazdvsGlzO05Gmx1Cw6FgZJJxfChjQ9n02pGg7P3INmKdlb4u2T3ymxpM4j6v5VseDbJHW4Lkv3uHSPPIKWUOSZWqFtx391g/4XhbkmCHzzh6x+EXnkYruvXxL6Du+c7OIq1EPmQUJ0PLBL1YIHeCPVsGKsKXYouBJpq3V03XcgvO5U2ir7FMUak+9qvh53Dkni9iDKTHRlJO4LXys6OX3ks7jTMJa68OwJT+6dx5bp2b4cuSJyGcquDmh5ijUiOUjJE6Bx9H4zx/eS+98BtatXWWRq/Bja/QFhKDh8t9udOrVvvGyPrbNtBOBf9YmGhwna2k0f7V9dpTy8bmF3bpBldM+EPHou6sBLZPZehXOYg81QJTJ0j22iz1h0LqXMSSYEbMzoO78KJr6MiqN5UiJUadnDp1gGjKYwWMqJDuryCJSrS+CENES4WlPz7ZuvTND5On6gFW1hcubcyYrxvQujPBgKIrF5Xo+ymyMN+UApdtzlUP/eLbRyylrp
 OwZ3YS/o
 K8P86/FGSqitAuKtemQPY/Vh7PgQpw3KBKUkldkLa9vo1aN9SHSxDBgq2obYlap6kcFL4jSfE1fGLo6QrDcN0fGWvwOY1g7ZUmXUTOqK8dJ2s/MbGf/V0nEL+8uS50/SVzh2aOGWx/WqETBDt7/6FjqqbkhgG8H250DCtnFuLrZcQh18aIqvsYQMgOuq3hYrcu+qB8x1fMakEVpdmY/sChK9Ia6KMdAJW2XC+KOxhY7CerU5lXyjLdb8wFRz3JfvsYuTC78mGjHT0Ry8bDdrdTEFZ4AODdk2ot+VbFavqXtNwiKGKxVVJt+LAfhlilq3W2VAKozR++baWT8bKzhIn+JvqnyG07+PDQJmtNB0aPHRZPcj5I30dLXOgdTbn6p+CYHD5oGBOf2o3ztokjDj9brDLWE5+WHJhfm4E26PFBnE8XeKdUzwf+jSVS0dyaNTg9LVLIFCYa8DVB3Pv75QpFQ7aYdH6x7s0bRFIE68LVaAjHWnhmnUlGzKU13heHDvg6SaR01+BZCMwDBWJVCVrRfdMsvRHQzCZ8yI0H/1mqdt+I02lPs/6TdtsKNCRHWfNM4HQllguE3Tti5Y4HaIdHei2X1iiwvUvW7pYW5O9AjBOy84VRA8Dm15qQ7/n5aEdQwN8sscZbBZytO9XvUsuOXCn8PQb7CfQZFDA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/21/25 04:00, Byungchul Park wrote:
> Convert all the legacy code directly accessing the pp fields in net_iov
> to access them through @desc in net_iov.

Byungchul, that was already converted in the appropriate tree.

-- 
Pavel Begunkov


