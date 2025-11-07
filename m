Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2133ECCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 12:01:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E3AE8E000F; Fri,  7 Nov 2025 07:01:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 494808E0002; Fri,  7 Nov 2025 07:01:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A9F98E000F; Fri,  7 Nov 2025 07:01:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2A6FE8E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 07:01:08 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C68FC4B91F
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 12:01:07 +0000 (UTC)
X-FDA: 84083670174.24.028E37E
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf16.hostedemail.com (Postfix) with ESMTP id A0739180002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 12:01:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=EiDKATdJ;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762516865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lUsVfRHnhaTc6L0mfrJ+S8eMrRvLqjKV9gyOwEzhVzo=;
	b=URXgx0wZhzUNxw92S2zmRBdG3IgwTEkUJLrDSqLUE1Xpxa6jUMnXQ0J4Bcm1rncry12bLD
	8l0D65nNGBtGZ3sjB+k1ntoViNLaMC3ExkXBxMboGgjfMjCCDXyReAXUqm1hzl3LgWNLYm
	pSIclN8fzYj1e5QTCAzUmuMlaSDx2FQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=EiDKATdJ;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762516865; a=rsa-sha256;
	cv=none;
	b=x/yvIfoiRNzFJWsTQ/eXdRhyOf7wcvRtKCtzhxcgloONVS6VjC0IDR9Ik7gI5sY0DJx8Gl
	Y3SBWFKXIBaJyPus3N3YVSS8iM9NJBhqbSOkEzOQqZgnKWV9GIrrCk3sdSZB3MABgnKfrm
	DcFPF18Dzjc/8fFXDken3Z4RuwLOo5k=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-640b4a52950so1028541a12.1
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 04:01:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762516864; x=1763121664; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lUsVfRHnhaTc6L0mfrJ+S8eMrRvLqjKV9gyOwEzhVzo=;
        b=EiDKATdJ6ISTdoRRnmtjPfU23WGyVmEl1zyo5rbKVGaCVhV6vTS/dtEBg5XDFizs8N
         4a6VbAfO9A/Do2r4W0SCmG/5EWNeZYZCx6feaSrt4cZHuZ1AUzVkud2dz78i94hTjPcr
         uhSdVDuuq8TZN1UJpywDlghcc08f0nuK7Vv2D1MVCGIidvKa2lxDFymXJoRMXQgMDaf9
         RRtofC8OtDF9hBp0xLxwTb8TK9yj1dg80VgMJZQfCZK07QhnivUHpBBF5cBTMXFx2ISN
         QqimTV1+RCsYDc9gk+EbKgHqlgHw+tN4BHaqpw5ZAiIFEN5Vw0jNUub8f956QpGOaJEj
         JARg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762516864; x=1763121664;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lUsVfRHnhaTc6L0mfrJ+S8eMrRvLqjKV9gyOwEzhVzo=;
        b=AYjM+lSynuHoMoCGpUmTvjZ3mD3Hi/DVJ/mLLqD7FmsfH4WfEiKZKQOOJXHxZ2hxH0
         IyLXx1rYc+ZFgAHLaYVMEQpXhwyHN5ev5iiqjKHze5oGN0f012BH6HrgXAg1uqKBFfnc
         XyA/a+jpKu4tKQAoHUBy5u+CRHKYsw3M4lQr9VbOkgB9DFyRPwt+X6z7mNZ2wANzJ1E3
         nLU20vhBslj1foSv70l1UpTy4Q8ojnckVg2BnIP016Nkza/Lx8LqWiOZc2h1PIb7BLLf
         N0pzhu7Dg8ASDICpyajZLUfypgyqjze9v0s1Uy0dZ+jyjMk6ar+mB14i8PG7Cl1a/RL5
         hkYQ==
X-Forwarded-Encrypted: i=1; AJvYcCVASCJOIUKArxCF12R4/YQ1VVxp1oDJ0atkW+OZkynwzZXjkh9TNq57ZcqOJ3EZRHy6DRkHuuN7Lw==@kvack.org
X-Gm-Message-State: AOJu0YxnuDua3CdsaeQeJ90qduBaLh6bDx6Jb1LZEgI8fPGXoedJfDs7
	uNIygTzMXHG5bPIWLbbYUedaEkwaJ0xKWGNbiON/cGCXNMESRsDqzqHWnYwJm70g8+3D1y3CIFh
	1AWbIiV9bWI5s80tui5q2bCxk2GM7SQYuAAiHbr1ivQ==
X-Gm-Gg: ASbGncsGN+ht0haWDv33pDVd18lhoxr3oz2Dn3UYHE2YRg7ZC0pT7rR0yqpPFNzBgrP
	x5PDrI5DKgdm13nqe+iWfhXsyARhPrYCar9M3qwCEsINORU3UsMH7BokidxYyDB9ZHaqw7oreVl
	KUCFHiEMVfQniBWWot5P8GAZL/38JB64TxrSezSxxAdEuCl8OxMagi78Jpc4Sf8Zvjo76247iqH
	qrmsm5pTSUxs0NKZ06YJ6UHeTvXGRQ18EGtlWcas2dxXuYVyYGQ8qYGMuvA5ANS6KWY
X-Google-Smtp-Source: AGHT+IF9pn2F0a39L7q6vQA1QNL5mEmZPkN59pguhs34CMH4Kd6QJlTFZpAj3QhY1fmeJmLCWP6NNkx5xTN4CeVBEd4=
X-Received: by 2002:a05:6402:518b:b0:640:9b62:a8bb with SMTP id
 4fb4d7f45d1cf-6413f063ab1mr2470983a12.22.1762516863928; Fri, 07 Nov 2025
 04:01:03 -0800 (PST)
MIME-Version: 1.0
References: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
 <20251101142325.1326536-2-pasha.tatashin@soleen.com> <d7651272-f979-4972-ae41-bab2faa8473a@linux.dev>
In-Reply-To: <d7651272-f979-4972-ae41-bab2faa8473a@linux.dev>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 7 Nov 2025 07:00:27 -0500
X-Gm-Features: AWmQ_bkI8wIkZ7GC8hYGylBjaXrBxtU3ZeBWwhoHk2_ITShMsozqrZ6SHuSvZSc
Message-ID: <CA+CK2bDSvtuwrrXGOC07Rj42yGFHWR4Sse7Q5z1z8f1ZFHWQ2Q@mail.gmail.com>
Subject: Re: [PATCH v9 1/9] kho: make debugfs interface optional
To: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net, 
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, pratyush@kernel.org, rdunlap@infradead.org, rppt@kernel.org, 
	tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A0739180002
X-Stat-Signature: 4zygzjc4mxwz9ih61zrny1jna5ammtyr
X-Rspam-User: 
X-HE-Tag: 1762516865-682655
X-HE-Meta: U2FsdGVkX1/z2oAqgcHUIexoba8zZmi8lmCvWrHWZhv8WEWSpFDFAmM7QDaRAJHK1THTST130nHrPn9NlOYBUcVD0hXyJH0aLEuj2y5/ImB+ciqLXo46gIdVqQt5S9v4hxnjh0QS1o0qo+wduMTGy/RImPRKy1rVyh1Be7MaiFUPOuEMVW3SKnhqpx6J/PqvAeKF3VeE7lD9Yau4FAiW24zWkzvkAjqbLh0GZcKroI3xFUtEzjHIr6r1nNRXXNfS8SKQ9AkNj0hc1Pbb5nQrUKTmOnu0/MgpSwcChqaY/Su7+RdgIEiHCfH6sDYLo9RhGtxa8Binch67ZQgCwdNnNEcYKLY78sgsbgEw/Fr3K76TrMj1u++8wo8xDH9q+PEt1DqkexAJC8haii7IxTMnaEu+kIaNj+uT2pHTi1bg7xSpYk8lxQeewBRZXzbDf+I/kQKF2s5n3HlciY7iwE8gTwZpoE24itEMr9wZ1Oy2if+XvOIqnE8qfgolsB8QYT0hSrhgVU8o3200yNqzNPXI1fG+aq77sb+V+XcP9bIG7ak5D9ER4GKTXqpOAPUqnNpMuo7YXp/1NO/6AUwlS5L2ZTFeFT72JCvY6U+3gAm9cCQDpwFl+x7PBZqQBHd/zxr3AlGyepQxSyT3vKAafejtZ/aZNwj3ltqChaDV7w5i2hLu2FAijDosKBXGK4jbt0MceancoLCuwuhTjxDJduXxx7cTuc4caGK2pfw2Ae/JTim4CMg5jnbOQyFycyUDvTEcDiHJbK9xy6+FRJzucDVEIAaoY9fW14uxka0yi8zgM4bGHMUMKBoQJyZxe6YqUvCNCKfFXKSooyaxphn5FRRKcVHjvyR4cb+r77l3OE+BEd8+FRcqHS9omTHbx/pUIwVh2hn+bKHDW/lJw3nutpg4dGbEa2gn2hSR1fUQ23b7sy8+v89wfNyniH5XnZZ4di7BR6QH3vAAWr7Z9/ulMDX
 LMEYsy0P
 k6TZxciy6g9kEryYv7p4zR02Z7JzHffTdhjUbszrn8x+pGeOQEYEMkNGwtoW4J6XIf7zHrdun1tOJgZbB2J/OP59wAvuuHu1zuXYXjqi9XP6sPxbIWBLFjtwCvwPxshKoJ4MbwpOCGh0yaMzR0EURAn6k8g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Hi, Pasha
>
> In our previous discussion, we talked about counting the number of times
> the kernel is rebooted via kexec. At that time, you suggested adding a
> variable in debugfs to keep track of this count.
> However, since debugfs is now optional, where would be an appropriate
> place to store this variable?

It is an optional config and can still be enabled if the live update
reboot number value needs to be accessed through debugfs. However,
given that debugfs does not guarantee a stable interface, tooling
should not be built to require these interfaces.

In the WIP LUO [1] I have, I pr_info() the live update number during
boot and also store it in the incoming LUO FDT tree, which can also be
accessed through this optional debugfs interface.

The pr_info message appears like this during boot:
[    0.000000] luo: Retrieved live update data, liveupdate number: 17

Pasha

