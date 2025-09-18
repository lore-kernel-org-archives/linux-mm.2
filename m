Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 628BBCA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:47:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5EE78E014B; Thu, 18 Sep 2025 10:47:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0F308E013A; Thu, 18 Sep 2025 10:47:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FE8E8E014B; Thu, 18 Sep 2025 10:47:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8B8C48E013A
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:47:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A307A85452
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:47:41 +0000 (UTC)
X-FDA: 83902649922.14.5CE949C
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8086CC000B
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:47:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="OC/9wlQ5";
	spf=pass (imf10.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758206859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UZUVA/eN8y4jUWH55g8+vAZUWm6iD5IWuaZ9B1DTE0Y=;
	b=rehTJ20YVvCPrW3xEkL5PFwtJURP0vfWEGUhMa5uLpiOiC33bVBMZOPeiCApdJzPPYMcRH
	zbchpvA8Evj40gnyqicAF2x7NrZxapI+YUaXw7UScc2TXl2AkYLh8sRS5oVK14ECpJIGSV
	Yj7+GIstrmjNtphyS0DTfvORqZqDOsI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758206859; a=rsa-sha256;
	cv=none;
	b=YdaXlm7QB6beEBlx2vpoYc2GxXAbieVd24r9cw4/5nfqIKx7oQf6lmw/EPA/OET5snpvBL
	k1a7G5nyunByPCkr9KcBErXmaO0wgzB0cwXTcDdb1/UMeisG2UUr3S/7uCdQE3qhE1TS6T
	lD5l/eu9IFr4rATJf9bX5pqXAtSW7kA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="OC/9wlQ5";
	spf=pass (imf10.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5796051ee6aso86729e87.2
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758206858; x=1758811658; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UZUVA/eN8y4jUWH55g8+vAZUWm6iD5IWuaZ9B1DTE0Y=;
        b=OC/9wlQ5dpkbAny5awzz184qL5Zw/mcg8UWjaTS+pxuwo3bamh0kBW+qAx0dt+yHwp
         pF9I76NGThSORg+1Ns9t9tVlY8XuUVG6h/Nk6UzcPqF2ofjCkwg5rACGEiOg/YZRUIls
         g2N8M86Xw2VzlKzzWO4jpXkp8wpNDaenyGaNcc18CC2FJZyQ+iOuFM874V6KYpQXfrLl
         hIMK8/lakGnxA3p8fvjjIESusEIH2s8X185g3LPtK8H/YQZG5AuL35wEkK0mdw+Seqmu
         Wcn6icLnqLQdQ9DZXGNxTZDJSRWstVbAIh2DwUGUWp6Crer17T5E+f59bJPHEM+DLxix
         +A6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758206858; x=1758811658;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UZUVA/eN8y4jUWH55g8+vAZUWm6iD5IWuaZ9B1DTE0Y=;
        b=rTOBPrfr1QKbnM0+hscusZ+g+3ux/EAtS7ONcfWatsdAMrVCgM6e4otG3ySiGhVHEf
         TkR9k4HDxAC3AT/aFORaUNVQbM8uVqYqn+2u5ph7eGuNp5pzHw61yVIoDsIgkiXpWY35
         Pu5gL7rD4A2o9IAdMfASr6maDXq25Y28seBl9+QjqSJL1Xco1FUsMoIijQnU/5/7M8YW
         mT4iMS+7ONApj43JJjbw81GWRs+acLaLPXX0ph4I83AuC04lC0YM7hhRRp+wSMBoZm9J
         s0veJOg7fiCvN+HLjcScbX7ZpgzAgS20gAyvUFIMiC6M4QcAwxBu6+ilixFCxdRuTEB+
         zSdg==
X-Forwarded-Encrypted: i=1; AJvYcCVgQM5/YIVgsRE3vqFX3+/1Im1DMDV1w760I17Ea+aDgXslEciAgyK6RwtTxN5pO52fjgkFNQk5+Q==@kvack.org
X-Gm-Message-State: AOJu0Yx5YZLYfccKWCshjjaQN9apRyNa11VObFLldj3QN6GKThJymbXC
	xU22k2N3iv8c9P9D4Wm5eZnekj9dDR9ZYYox9jYC0uhf+/v22rBBqxMd
X-Gm-Gg: ASbGncsBBGVQ1xwMEc6UzvC5iB7fxjYhxjOp9OqhbE2sD4Hk4JvfAsHnzZfN3y/qJqu
	zbfjrWCVE5FB081Nb09BAGB8lAfqjqkgOkyU6h3N3Yf1NyUxlcZQaaFXeSHAqmOUXPsztWJ4X7a
	36YjgFlHNQNGGMZFBh3Ex3kSOFzheDv9XiGk5GlpOhWscia66g9wY1mquIfItVpxf/ChTAb9yj4
	iVoq7oKnZDsy2iX1us+38rFbHnXK4PV9bI0zIrkxaqFKoDrx+uL6CvTHX0EN9Y2CCMZ/zMms79J
	YPakIpDuGOKJH8xhfSPL/VdMWhWXdTQCfiU4CJN7KvFj0iTtTzbaPrcLCFYok50N7aUgRPStwKS
	rrrrIuq7w0BQXbqtQr/OqQN9AYUwR/wjUnLuA1SZxUBoMxHs=
X-Google-Smtp-Source: AGHT+IHtJnmg7xLHWlbfBgfrch0goPM4i92u7CS5SbTFZ6QT2H9sZ6KAdWepbZ79ubW13IVKUYf9fw==
X-Received: by 2002:a2e:b8c5:0:b0:336:7747:72e with SMTP id 38308e7fff4ca-35f66df191emr9476411fa.3.1758206857314;
        Thu, 18 Sep 2025 07:47:37 -0700 (PDT)
Received: from [10.214.35.248] ([80.93.240.68])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-361a2f7ebcesm6234871fa.29.2025.09.18.07.47.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 07:47:36 -0700 (PDT)
Message-ID: <dcd0c9be-5a52-480e-8447-ebb0a028edec@gmail.com>
Date: Thu, 18 Sep 2025 16:47:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 1/2] kasan/hw-tags: introduce kasan.write_only option
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
 <20250916222755.466009-2-yeoreum.yun@arm.com>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <20250916222755.466009-2-yeoreum.yun@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zpg8k1ouzqbmphdbiogxtn58a7thdpec
X-Rspamd-Queue-Id: 8086CC000B
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758206859-832468
X-HE-Meta: U2FsdGVkX19h8KwlWGs9PXUKd5j6DtorZm15ZIHpZlgLfo+VNwSnABJJ1kEc+iEwPw3NkzyZiVYdlzHkYHEEc+Nsr4G9PqG1XEcabsBnou+Nok68pGg6UQ/SDZwb6OKXQmjIqmmmRQFEizXoqoka65eQtziNIUAJpP1ifNq7Gq/nyUbGFF/nPiLC7SdF01kv92TJqFMnh4bcP6roSkAMiz9Fjy27s+WHXykODKJdq0X5qJqZac2F3HxiWE321xL7s8RBcnsis4beHQRL7pqyWC1q/TmvQ2Xu/y5ocXODaOkO4QfVH+Jwr3b4h6SWQv9Q6pE8MKk2rUbDJyd4EqKiBHFKelNmwQQo4oM97KKQBirA+Fw6RAahtHwcbtGfcAqMcOWfRenqgmpHcEISvQsFIYKLb++SUFpkWb3QYqExT5kRZ11xgZhUgYUBdNeM4rqkaYQw/GwY2wO4MNuHHNQRp3R1jCt7lPNL3pb6Ro4RrqKwF/DChD9ZUob8hA1gVKxAiTrq4hWa+Iie4ANd8r2sCys7Y44fC72JqJ98wub9AY4IOIErkga48+wP3gnrJv1nEGa/FO/xjtAfUVUJOMJscIeoVIuaxxkjgT5kaVkEUy5gitJwEzPxThxthTuHGKcPlxWqupllct2EjtZSMLv/A15+OIDX3uyoX6pHa17bYc2c1E/hJN/tU8uQjNlAYi62MQVdkY33e6bC/M/Nd/iBbc1knsBlI37MGpAJLS285WNdqCs2i/h9TIC7n2PzaSG60JhfJelY6QLZ++YfV2UqFENwYB2VL49W9EkALosA0/E7JI3xzufgAxH4Z7uX2o1tArn4T1EjN6F6slrTzfQqKKAPX3bA0YBs0URHmvpu1+OzMomJQiCZi89otsXlJLjdyMOpUKHJcUG/itev0LXqdttc5wvHgW7rfbadEZF5zgC4Vp5Q2WfVKVZVT95Q1dPj/DGqdwGzaHIJG989LIe
 gxX0seJJ
 5/ag2foACaXDUAAIVCbW3CQBMEqgfQnVb06YCAeL4aytuV2pV8QS7V4N0QhzvAQsIMU45zng9yINIx7tyWWRA9cjuT1uVqnycOF+OPg/RGG99/3QZ5yGXU+o8vsp+oqgOvAYn0ka0Xe3YOesXsrIkxGP/f1eemCSjR9xmNPkxJl8yM8oAVClxTHAEkf3tKqZNZTOJA0PT609cftDOlpoSPiuVdqxnajBtBXf5fUWYT51QunAGkwTbRw/zBZmAm8t5s9dVw2HhCEs3XNisGkHzlw9Y3QlWE4xHbd0IOa4o8RtDVIaS+YEXnfrMsCxxysdqNV2+GhetAAjoywFmli7ajze3BW0p/Ye4QzBafzl7slGDB+vT73D2NOsZQPq1U7dDMhMAAw9Tfb7aW0TgIWxakc6d4NQNcXjIGUbgOcSO488gSDmQrlOcx3IWB35/JRxwucOyX4jOy5y7DwB6NneoLoQp0pn4V+XNivwb+bayRw63/LXH5O/OdLiN+Bst8KXQHaEym1YU2UYKAInYxjgZBXLtFyFFV0jXM8l4lEJt0Bnl9c+cRjUCC488d4VXP6euiFyYO7a7PFKdpFWgqDMzCJVdFjpUCjIcAqeC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/17/25 12:27 AM, Yeoreum Yun wrote:
> Since Armv8.9, FEATURE_MTE_STORE_ONLY feature is introduced to restrict
> raise of tag check fault on store operation only.
> Introduce KASAN write only mode based on this feature.
> 
> KASAN write only mode restricts KASAN checks operation for write only and
> omits the checks for fetch/read operations when accessing memory.
> So it might be used not only debugging enviroment but also normal
> enviroment to check memory safty.
> 
> This features can be controlled with "kasan.write_only" arguments.
> When "kasan.write_only=on", KASAN checks write operation only otherwise
> KASAN checks all operations.
> 
> This changes the MTE_STORE_ONLY feature as BOOT_CPU_FEATURE like
> ARM64_MTE_ASYMM so that makes it initialise in kasan_init_hw_tags()
> with other function together.
> 
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>

