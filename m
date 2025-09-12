Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BC2DCAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 15:56:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C7D68E000C; Fri, 12 Sep 2025 11:56:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 798D78E0002; Fri, 12 Sep 2025 11:56:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6870D8E000C; Fri, 12 Sep 2025 11:56:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 572D28E0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:56:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1677C5B9EF
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:56:31 +0000 (UTC)
X-FDA: 83881050582.27.78C3F11
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8BC8216000A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:56:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AzDlI4U7;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757692588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LwtSBiRgh7l8m3eHqvj0Z/4D72nKcmOwOzm2avrIc6A=;
	b=GNwxbKBbzvNMqLt1pcrMVkIYnTQqskQ84zSbVW+095nZqyCoJGcujI/leWGynsHUylpGe3
	qvkBHsrI7A0qamKyfA+UNJBB/gXbNWUE687EK09Fdu0z51Vj7Wjgeg/WaGcyberuYcowT8
	/zm9KohYq6aSmTlYZnOr6kUBAFfsPSM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757692588; a=rsa-sha256;
	cv=none;
	b=S8ym2YOnBmxLOJQsf3AKpSF7FTwA0yBoL3Cg4xm6ysbgRY0z0SswiDoGwBsXgd3Y4rWOEm
	66Aa4T487m1L3zLSY6PdhZslqJ0VxDIvXdQwxaQP6pRl+ywPDOzeNHg4lV1HIPXxUK+BEM
	kYRJ2iIdwwyTy6vG5iUJjn9gnvhnrpM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AzDlI4U7;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757692587;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LwtSBiRgh7l8m3eHqvj0Z/4D72nKcmOwOzm2avrIc6A=;
	b=AzDlI4U7adkgkDk1r0w5xCMl5zeLoSrg/d9HgVAwWMrcUgecnVBGt0jwzzOATG7Fo9UNUd
	Cntx76pKX6oJMcPdyM7W0ufyY0zrr2B22tmPqCyajZsDToXwTb7CMVeYdAhe7p//w10V5Z
	O5MJ/ZadF2NpCb9eUZJmKtczaiQnY80=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-223-aHa3TelAMtKGM1kIUAC-LA-1; Fri, 12 Sep 2025 11:56:26 -0400
X-MC-Unique: aHa3TelAMtKGM1kIUAC-LA-1
X-Mimecast-MFC-AGG-ID: aHa3TelAMtKGM1kIUAC-LA_1757692585
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45dcfc6558cso15853615e9.1
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:56:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757692585; x=1758297385;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LwtSBiRgh7l8m3eHqvj0Z/4D72nKcmOwOzm2avrIc6A=;
        b=oAyA/hmJLE4chKTANGU/Tq9vVvDBKLAd7MZnE68Xjjc7GGH8PHT3DvEZtsPuw9Bz/j
         KlByidZx8IKoXDGiSuX0JJGKgpX4EnpJOdUDV1rYOw7Yr8nFGcTYRx1Tv42DIxRhwrSd
         EQ4CYCkzegnQMIKDNvnZ/f99AmdcjvlSEra/4x2doJdeMwur/CRzE0uJZUIDLh9JjaQK
         Uli6p95CUbLGS4BVB2IE0baVl4RCiRYIT9H1D0ArrRiB25D9YAgy2dqWyowmX7QxcAk3
         z+qRIwiHcPFOTAI31E1emV11hY+u0Og72PKjMnaNoN27Z/c6OHlRmr3RgjBZD4pt+sZg
         3AJw==
X-Forwarded-Encrypted: i=1; AJvYcCUiQklfGVTP1UDr1CDuAIklkHW0Xt1pGjR4KIcU5jo5hhFcbWndbtSoWynyILFko9CR2qdx+/3cYg==@kvack.org
X-Gm-Message-State: AOJu0Yy9TByc+pJAjky8MjWWdzM6va9Hhv2KDoDEg3YdCRIy7xbJJ5Ta
	4l/1TrFNgJX22rhOuTUrOgzR5T8ThnLRxfR0HxFvlg3PLDDAICIcqx6HfKhLbspJX0KXCnI6GD2
	wr7AbW9yBGwBtpjPvPBqOrrKCskujDOeK+t9FymYIK6sQcRaam5Y/
X-Gm-Gg: ASbGnctFrAhowDSwkvxGiuvoqE0IEPngDJTSLui1HCDaNivASf495oxdB0aEd6xkOiU
	pd6BETzTwV2RRy3Y+RkkHZEVoSU4BcFWTVFyXT91R4bA2m9bnNd0hTLZc/fOMfamsTF9x0gVpdS
	IhvF0Myj3bqunu3X2pbnpaVCsMWWkpLAlgsEnufZWKDCwRJ3FimW6S30VwjIZc4HtXFs8nZSrFE
	+0IWEOZ7RGlNqPPNZ9/nvvU0aRzrxvIpGbhZ/YwNTsZet9sjs+qN8KzSXpas6sWcX/BlQany6FC
	8qZuiJeuUCUx3GI7KhjfIxPcxirUjHz5W0qU6tPd9vKLe0ENF13lzXKX7UeRAv7pwocdEc7pZN+
	U9VB5fjRCwv/4EKM94P5FHXsmPZYKGvOEaAZUgTOgxKkG6EA9/svLOh/ZEIiHUgbiEFc=
X-Received: by 2002:a05:600c:22d2:b0:45d:ec9d:5fc3 with SMTP id 5b1f17b1804b1-45f211f6790mr33105555e9.18.1757692585242;
        Fri, 12 Sep 2025 08:56:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFac7W1MrERsCK511VnCTt0k5ir4FTQySao9wgWh9TgtQ8MeIZa8a3y4/zUuscFnBsbmei1sA==
X-Received: by 2002:a05:600c:22d2:b0:45d:ec9d:5fc3 with SMTP id 5b1f17b1804b1-45f211f6790mr33105325e9.18.1757692584728;
        Fri, 12 Sep 2025 08:56:24 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:da00:b70a:d502:3b51:1f2d? (p200300d82f20da00b70ad5023b511f2d.dip0.t-ipconnect.de. [2003:d8:2f20:da00:b70a:d502:3b51:1f2d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e037d62besm65340495e9.21.2025.09.12.08.56.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 08:56:24 -0700 (PDT)
Message-ID: <9c2e289c-0258-4e25-aaeb-a97be89ebd84@redhat.com>
Date: Fri, 12 Sep 2025 17:56:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH v3 00/16] Introduce kmemdump
To: Eugen Hristev <eugen.hristev@linaro.org>, linux-arm-msm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, tglx@linutronix.de,
 andersson@kernel.org, pmladek@suse.com, rdunlap@infradead.org,
 corbet@lwn.net, mhocko@suse.com
Cc: tudor.ambarus@linaro.org, mukesh.ojha@oss.qualcomm.com,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 jonechou@google.com, rostedt@goodmis.org, linux-doc@vger.kernel.org,
 devicetree@vger.kernel.org
References: <20250912150855.2901211-1-eugen.hristev@linaro.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250912150855.2901211-1-eugen.hristev@linaro.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Vqgro0lQN1nRpcPToPzUjiyqNUkikByql0Y8biSDJzs_1757692585
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8BC8216000A
X-Stat-Signature: 8mxczekh3bbsy4po4sndwum8jp7fxm83
X-Rspam-User: 
X-HE-Tag: 1757692588-950724
X-HE-Meta: U2FsdGVkX19K0taJ9B5wkQbaiAKTWLo6J4iPj0LMvLg+eDpbIl8f8mUnqqWPeFgFBYN5Rln7nYtyNWCTxdFJnW7FNYUybB6sC/PIX2qOLcyxjeb65wDkzZ6c2O0cGLxWo+37TVV24UIEXqEcp5LyBtFbkzI7abcd6ySltSTtQaw4ffuxF3kViFKDIZp6+LhEBeUfAHi6CVfmGGRje0hIK99vqppZGqiQ20GhlzU2zSkKy+ELCX+OMC2o2Gzs39+0qgupzzrQp3rYkGIAAAusCYQXauA2Yxq/Kg0rKR6yymWwohzirPnlVBjXYKYZVoySxIm1IZyVkw0vziOM/PtDau6/M5BQJ2mkGmx4ntCoSkxbw5y7O2/Fkph8It4sHUT4AAECTW6otxgiPH4HORJX5UMO66AmBppC/ecEhgZUIIsbaLsc4u+dBU+0hBH6p5Nlh+HgIR2nIc1VT1ZpQXvX3PhLaiSPh+aFjbX4LdoH107b2DszLqM3hhr32HpCVBCEWF7jBQ3wwgwub5j/y+FRht9Fgb47Jb5ROfdCY9JktoXgScUgDDHId0pAoq9DLkWp59xEYPWbdkYNKeXe5C+fHl+W8HOBMfuLt7qbtGkRXoYMKNRQDdeNl1gLmXGzmqJK7NKQPtPhc4/Vtk9e5I4jFeg/itxqf3u8UyMYTIQsNHA23PWki5TZT9hqEEOVM1gU3DYt4RqtiGLl05yF3LW96f40AF+ihE8F3RaYIIrj+dFyKNEYfWkgoMUfyZ8uUskgzuBLlH67hWTPI96LDyfoXTYV/JacmQ3tk/QHjWJdJKy+SFKNqtyY30V4fTzzjIVhOYJAPCjQWWMQjVJsULPIDOVCfXNiPdzB2nJSiMO6yyJ4pZ807y+rOk8xHv+UvcxmPDsD7g+gQIHiVSaDsO3s0t97YSVFhnbiSngFypjDi/5xqoOMKtvysLGveCxlVFRoSvNKK23i7gyxDA3WNau
 VIXhRcWA
 JiksoM2WuiJWbDPBRC6BBEtAlIiSRePdYOuwXG5W/V5a8QkEkCBhQT0HJ6/77DDQFm0fCFv9IVlQvzrVA1yLaXfgfWKKiVnaKYo1YHEXDmgq/kK79V/e+Ln63FhLhUOrQaV1QPm8CiSGJmT5dRbv14QFUT6EA+h5QJpRjfkIAzidxk0zbCHRuW7cnYdyB55tUnacAx241ToDk2QjawJX+Zx6P3zRM+2oTN7R/CXwqj5ntn/pKdanlU7bZsxq5yJmTi7Rl2jU4Jg3v587khWcF63iUr/H/OOb+DbJSujeJqLqi1MLCG1xZLrXLNwIScpADGCZ0B+tjMIx54Vlflu+SEe7JyvtLxHzpiXmNad57xJNRQCJ9AUu23In/WVd1FGo7AYxxU3pSlxetIG7G+cBIqXhs6Fm9b2EfBd4o6nm6PnC1t2FibopD69tFK57u2HuHDTHszHrl93snKvLnyiuguiRxHvIJiNxzvTpA6Vgc2PhMB6GERRKMpH3vC8csGv+iYjUhvbahc2FEdHtI24twPo3tigBF0ly1LRuR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
> Changelog since the v2 of the RFC:
> - V2 available here : https://lore.kernel.org/all/20250724135512.518487-1-eugen.hristev@linaro.org/
> - Removed the .section as requested by David Hildenbrand.
> - Moved all kmemdump registration(when possible) to vmcoreinfo.
> - Because of this, some of the variables that I was registering had to be non-static
> so I had to modify this as per David Hildenbrand suggestion.
> - Fixed minor things in the Kinfo driver: one field was broken, fixed some
> compiler warnings, fixed the copyright and remove some useless includes.
> - Moved the whole kmemdump from drivers/debug into mm/ and Kconfigs into mm/Kconfig.debug
> and it's now available in kernel hacking, as per Randy Dunlap review
> - Reworked some of the Documentation as per review from Jon Corbet

IIUC, it's now only printk.c where we do kmemdump-related magic, right?

-- 
Cheers

David / dhildenb


