Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1BF2D3EE84
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 16:43:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01BEC6B02AB; Thu, 22 Jan 2026 11:43:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F35516B02AC; Thu, 22 Jan 2026 11:43:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E61FF6B02B0; Thu, 22 Jan 2026 11:43:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D180B6B02AB
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:43:48 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 934DF58E1E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:43:48 +0000 (UTC)
X-FDA: 84360171336.22.0AE5F01
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf10.hostedemail.com (Postfix) with ESMTP id A599AC0004
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:43:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Uv9LB2wH;
	spf=pass (imf10.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769100226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f0kz4ZiUZYReaaffs5Nzc33lR02WRzRUUmPU/gSlaqg=;
	b=jrTNjmRxv2H3CUBzTggBnbpjxrQDKBf9JA9AL+zTbxAR69Q0FC6QeW06h+3rDulnGGl3j/
	4zfN90pdFUQr7CiHc6I9//YRq8x0n2RqN8NcmExxkaToX27QYapOhg1JSLfEFMlzaCP7MO
	jh0XrHBTakJxSdH6J6jKxusMYu4fxhQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Uv9LB2wH;
	spf=pass (imf10.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769100226; a=rsa-sha256;
	cv=none;
	b=p21l7W1uSCrhHJv0/QeK0hM70Uk4nplSLooslphXVewMRSjiayMZrNpQ8LQzP2Tpw2fiTw
	kIF1kezp7P9uRvoqD3Q6wPr9p3mDwaekm+dru8pTw6mhb2l8ke9HkhKvz/65ITXp2aVP+x
	n2H9CgB8Qj7rXxuJbD1m8wTjgB4lA8c=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b8718187eb6so173111166b.2
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:43:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769100225; x=1769705025; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f0kz4ZiUZYReaaffs5Nzc33lR02WRzRUUmPU/gSlaqg=;
        b=Uv9LB2wHhoIYU9SJt8zcPdgbcFA5MNYeR76F/hAYrJ4s2nVFIeKe/wfPN68oPRMzQB
         MF/GpfVO31Q4vDkESxEYEh6dpW1E15IM2cEdAoY3xcXtNlR9OOe44EGCcUl58LnIAIZf
         UK1XYEHWrpLgNBPyyz2BO+VadHpWiUOaXRziVBz12u94XBbH/cOFu2Z60gZjDluAysIh
         5ye7W/K5wIf3l7WvMxIz5Iuxjm84qOLEaWfp7zQ9cbbAoV7zg9dWA5EFoK4Qast38KJv
         NpznU9BDJ8h0aM5EuftwJb4zFI2egklsIH396PpYPROLQekJgEfi+v9bXXn5QimD6JRR
         fj4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769100225; x=1769705025;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f0kz4ZiUZYReaaffs5Nzc33lR02WRzRUUmPU/gSlaqg=;
        b=MnXFMHVdB4qDjiGInHZLEhwlb6lAU0ZhS5TpEzFYF2Tzyoc33PPO8Rdm/eb5pWIr5z
         OSQa/52Gxcy5H2QQIeMSlk4WrGrVZ9Uz9PjhHYfiayaKOQ0MmZ+Iri0q1bK+GWRDTg3i
         L5Vg4stHtq6wJQ7ZyFULTwOy91s9eY5MdqF9WRfH3xz1mDhK6uWp+jmcUyFy8tNhI37q
         xoue/2ixzn5rSstoseXFcwcm1wGN3eWRXFTLJ7KN3Q2gfxQNcUPo+TH3dPc9do/+MecE
         knIYZxfLfTLcBPehuia5VP7AH37ehM820wiv5j9Fnn2K6muA6G+fT2BgXtLx153g/4S4
         wdoQ==
X-Forwarded-Encrypted: i=1; AJvYcCXBq1euI8M0670XZXJaacWMpvdAa6xGLM7CvDeOx2qrQGoORqT1u/vErypIG6yrmiZpYUJlaZXt3Q==@kvack.org
X-Gm-Message-State: AOJu0YxJyQxI10Qk/shA5E+iZjGYTqLm3C6pA39ojR9ngW/ArRORQjmx
	6E2opPQQ6NI3prsQoG2MXL+tgCDVH2rJIw23LkP0333RCsCOQySSJJnWurvUhw==
X-Gm-Gg: AZuq6aKweVqv8HSXG3/1wH1Icf/wQImyXGgOFSxT34jcNCtMUMoeb5EZhyNbsvOqPz8
	CA0kKFdIrBJorhgodWA4jRAOddw4pBf4OakllK2oWuIwe6/yDq1t0IjGu3OCvx7vPlnhNtc8QFI
	fXAdrSqloFTAFczKrSpLHYBPaq7in2idmXuWHxVh3tgMdPS98aOU1d8fyjsWbHLjATP1vl1R8S8
	jX56Oc6Bo7OJKJ7R2cKfnPsuwzwcawsSdlbhTT7hfWVcXyStIpw0clTwZGINNyzWGaIX568qvCx
	8LUWTuwD2F9waSYgfkTa0T+7eGp4gzsh6DPYH+IhuHrL6EETD2IHGCsu3Io3tYGUvkqORgHcoz4
	/J3mD5/amLRVlPDs3tp92NF0OvjZVW2mMD9Rt03y9A9bqip4ewihmnAC6Cz/ejj8OZb2XmYt7ut
	+1oUv+URzgOPyaMupLlujz6q9OBtMca2AZXlSbkjtXHXa91OucuGhW
X-Received: by 2002:a05:600c:1550:b0:480:4a4f:c366 with SMTP id 5b1f17b1804b1-4804a4fc5d8mr32785425e9.20.1769093874088;
        Thu, 22 Jan 2026 06:57:54 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4356996dad0sm46479226f8f.27.2026.01.22.06.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 06:57:53 -0800 (PST)
Date: Thu, 22 Jan 2026 14:57:52 +0000
From: David Laight <david.laight.linux@gmail.com>
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org, Andrew
 Morton <akpm@linux-foundation.org>, Linux Memory Management List
 <linux-mm@kvack.org>, Nicolas Pitre <npitre@baylibre.com>
Subject: Re: mips64-linux-ld: lib/math/div64.c:undefined reference to
 `__multi3'
Message-ID: <20260122145752.1e4c4202@pumpkin>
In-Reply-To: <202601222217.uzed54La-lkp@intel.com>
References: <202601222217.uzed54La-lkp@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A599AC0004
X-Stat-Signature: 9cfdaimk1j11aw47kxijiyfi1k4r18y6
X-Rspam-User: 
X-HE-Tag: 1769100226-562997
X-HE-Meta: U2FsdGVkX18hX+3Mmu4EJ6NGJzmtV6Eedl9Z/d/BBJzvxyjAkYAEhDtCNQJydFF7BMTzS8/bFD9G/W7PQa/PuDojrPLfRe8BKr+lKGPCb9E7CF5JTN6MarZqd/QSVL1nnKqYpc5xQNri77RFa5o0H8Zy0TisA8X4BFQYSAGUXf2h4FBTCrbymuRcwaOWB6bwN4gi/zJVAdVZiG6rpNdti1vgCQv+uBa4zT+C/RrAT4IzmNfwthjw6nNP9pRdjWm6BT8WUt7gDvM9bq1FTpBxjgVOtZr9qgQ/NVAvDEpIly55kS7u/9CiDWTGuvraUMLqnqQXDS359RtimBjam9qSA6jOeH8PCjVviMxX5xZ9SquBvWNmtZ90hYPOYXSgmgx04L9iuFvz8XyepxcIMEvKo9V+bTIbhiGEfTtLAKM3XgFh3//jObBacXJM7bM/0rXBgMiFFojJXEkKTSymhj2m2R2GYwbe204qiJqLL2sHT9vDHeiFp2oGW4MpmxWaFgpLRMHKOFit9fRv+W9NJWbrSYr/q+jQfFpA1Oj3PbKTI6O9nib6vnX1NEI4mEPGcu19gRfYF6qCJ9mInp7lR7T74i4rJtSxehR2aVnh7628vxyydUkWg2oupbPtyGmRq5FN/nbkSbqfqFpxrof7w128fAZbvHGHizNTLL7l/Z3NpmqdwuoEk8OK6BkPLATDpKuwS0fYh9uURMhScobZhraOB8U7vUW5F8LC+bArxGBH5j2SjZTWabULSHZWoH44+c3jpWKtBSbqBKRFG/aXqPs8Yz5MuJ6AGzanv9ZH2Y6LounJ6yQU6DHJYtX3QRjj6DOHA//dDgjCm7lIH6NgcopfTOqq/JFLIDiIKfc+wUF0mmzkLK/1izFQ07sCwTnXuLLp6ekmKxWqYJBybZPrO9FalvdkqVV0Ac5mR1AZR6540XBSk/QZJ98ZNNSfdcxQb2BkYkN7/bp+Aklykz9nsgN
 Ff4CzRPJ
 zVbiBZn+gT3s+ApOVxdps9eAPYhtaCM/U6yZT70etRhpXdEuVcXy0sA8Q22ICFO4V8/fZUeQrNYOeF2atjEIp/maPk+C3/nLLt4ulZVN08N4bofQUVN6MSHSXGT0Gb6E6ahRG3cBCgw/iL1QNvVVU+Akkr5wdzk+rpa59Fn3x1jD5BuBJF9WNjUvZj308apKt4q6/gz6MUqZ1vBQDIuSNjweVomMyF4zMP+YCmzKDVjrmt+7aoTe49FDWA1KJE8QFmpRBXaYhrRfT0wZ5qNyKaif71SLy+Vu2mJoxKMWz5i/qLzueE9gU/fIYeaca9eDn4KO2wm2B0fobKU3tBorAyWtlvgQ2/YpE81pOjH+qygsRAK5a4ur6aiUhSF7EGFZY/rbCgLdQW0C0/E6z63Ixh1TInC73KKrtwIgp1KfT32va+lgxv5Q3/M9N0hLoalzdFsZNJ2q0kSHx26W0/V37FxfKfEK/wux3K0x7onjE5dxAUtD8PEBwoGwIWM38Mt9I7R/JT4Ln4SUcMa6pBjI0RAUnm4qpyJ/kfFP8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 22 Jan 2026 22:43:28 +0800
kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   a66191c590b3b58eaff05d2277971f854772bd5b
> commit: d10bb374c41e4c4dced04ae7d2fe2d782a5858a0 lib: mul_u64_u64_div_u64(): optimise the divide code
> date:   9 weeks ago
> config: mips-randconfig-r062-20260122 (https://download.01.org/0day-ci/archive/20260122/202601222217.uzed54La-lkp@intel.com/config)
> compiler: mips64-linux-gcc (GCC) 8.5.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260122/202601222217.uzed54La-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202601222217.uzed54La-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    mips64-linux-ld: mips64-linux-ld: lib/math/div64.o: unable to get decompressed section .debug_info
>    lib/math/div64.o: in function `mul_u64_add_u64_div_u64':
>    lib/math/div64.c:(.text+0x60): undefined reference to `__multi3'
> >> mips64-linux-ld: lib/math/div64.c:(.text+0x188): undefined reference to `__multi3'  
> 

Known error, duplicate of a different build.
Really a bug in gcc, fixable by changing the compiler version in a test.

	David

