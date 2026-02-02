Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70083E7FDCB
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 20:03:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 976366B0005; Mon,  2 Feb 2026 15:03:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 923C46B0088; Mon,  2 Feb 2026 15:03:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 830196B0089; Mon,  2 Feb 2026 15:03:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 701B36B0005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:03:20 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 27CB7B7A41
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 20:03:20 +0000 (UTC)
X-FDA: 84400590960.24.810E9DF
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf09.hostedemail.com (Postfix) with ESMTP id 206D2140011
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 20:03:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="lqpe/cZc";
	spf=pass (imf09.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770062598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oeyy3A9F0h68gai95rKC/WKtYz02tqXoxrCeMHYnONw=;
	b=FwUEnMky1VFiLzvi3JF8+NAhhW4jnv1f5ABQJt3kHeVFCU+Z9pLc/Lo4x25PdvZ3BV6nDw
	O8QkaADsdQRDvGnhf7w9POdUxnE++tm6ajwDreSH1UqkpTtcXmbeiKTiHxzfoCIOM/Q3HP
	leZqjo3JCblAxb263r40vZpor2KJFU8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="lqpe/cZc";
	spf=pass (imf09.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770062598; a=rsa-sha256;
	cv=none;
	b=o7edOKB40tudJM1hTmvJCXcWPILJlU51Rm8BGNV8R9na7h1s8I04Golwyqg1GFxXR5hAht
	KjUODD38m5rnI/81T53qmg2CGak9OviCV6N0Dwz5aUCAIclwPYXFCskq7UYsrM4NMiqTzb
	xOhVqb9VRWrFRXzl1QNeXWdRBoAF8iE=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-480142406b3so36167965e9.1
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 12:03:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770062596; x=1770667396; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Oeyy3A9F0h68gai95rKC/WKtYz02tqXoxrCeMHYnONw=;
        b=lqpe/cZc3Anrq62tCdMvb9hXArwxsvgcD6LmHu0CYgw3jd/SuOt8VTXgocZ6fWwc8N
         02FPuxIBCFezoRi0sbYvfGDJlh2mFTW42FD6GO79wjvmxnx5NttzOhwSLxuuzpmdsEBi
         r6fAg7ahZ2vL8RqpEkeFh0fXJ1IdMfy1RnH/PubRCzstwT6lj0SMi3wjFTvrFWw47WDP
         nAYQTvr8ZkE9FDCLsQN2UFL8XvACcPdYp8u9yzOa8r7rASTTvUmBIIGwfmm2fxUcEboL
         qXS1HbGL6+5A7jdfhvXr0fKX1dxIvDxuzYvvii89UskRVqR9Kq2g7qycd3VGB1XSTuqC
         TUHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770062596; x=1770667396;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Oeyy3A9F0h68gai95rKC/WKtYz02tqXoxrCeMHYnONw=;
        b=SE+Xy/FDsLlkdcZL+z367Dw/yP6Sm7jEvD6Rskno6XUQ8gme4b3yCyGYtm8Zu1v2/j
         Smi+rI2W49Dl9plWkJbwXwco3Vr6YzMOV1modVrAmslOeP6erfK9LAoeFPCK2JobQPVH
         yF0T1hAE0MFNfPWJUd0zlQKeW+8GKQcuuR+/714lmWB0fBnnMrC8x0MOTS7LSnyJtC7J
         NMAUBgpAup/I20E2WaZF5VVf7wMGN1mKug8KM3Kd8Y3+biYJ4D/1WYIv3vquQ5S0d6rs
         6MveWFG/EPOcZ675cocYsNyVftx+6W8dzIIPH+zNIG/OsJGUlqsyD6hdLGka+KrpLAKK
         MDjA==
X-Forwarded-Encrypted: i=1; AJvYcCXH1tJ/ymYQWBQIXN7Rbo/e2CjQNxiqtEHAenitjMsgs6R4H1c9pFfZ4WZjZcztaYix5rphInnXDA==@kvack.org
X-Gm-Message-State: AOJu0Yw1SmT5v8D66XHGK1ZnFdKmJiIZMInQ8rvhO5YFb1VjJzQnHvzk
	LsLrbSnwfgMiD+NAOKtE1LuTwWjd47m3ODqq++npewCcnebXBZLAV2zn
X-Gm-Gg: AZuq6aLD+SaJX/k3x2JItrJ9oMjMMZBMoPnIC7KoBoLlT0cVD9uaFXl4kq9cs9ZtAID
	nuOkf5pLgvsRuQKGO7vMK6b3KtF0on1Bqiq/27kT/QhF+eHJxLVC6Tu5HU2XkZV5MSBUgHqHh6c
	iuv6kMXHPWEQRG3Vk5y12JicbSNxtWUGf/nSBYzvAi8D3a3AssqyMbcPGewopQbnQNhPmG/BhFf
	TaOnnd8Z9b+imjUoQTeyo2472Hw9KeaVL53TeXqWBkV3Vpp3A7oRHJSLCV/FB9jS2LwQdiinaDh
	6xk0PBIBLFyRhF0GcMe6FsDojU+7OHVdTWyWbrQf2ejWeT3VXoiKZADLTxI6Cb0CCLff9uk1v/k
	KnWcCP+EHk0+L7zpP6lrZxyUrBgMHtplkAqL6msQlsb2vQpMDnfifpewaIUlYeVth5WYdC4j8dE
	wDI8dREFM=
X-Received: by 2002:a05:600c:4507:b0:480:39ad:3b7c with SMTP id 5b1f17b1804b1-482db45e244mr170114895e9.16.1770062596185;
        Mon, 02 Feb 2026 12:03:16 -0800 (PST)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-483051626c1sm9918025e9.13.2026.02.02.12.03.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Feb 2026 12:03:15 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: kas@kernel.org
Cc: baolin.wang@linux.alibaba.com,
	brauner@kernel.org,
	hughd@google.com,
	jack@suse.cz,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	viro@zeniv.linux.org.uk
Subject: Re: Orphan filesystems after mount namespace destruction and tmpfs "leak"
Date: Mon,  2 Feb 2026 23:03:00 +0300
Message-ID: <20260202200300.2719301-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <aYDjHJstnz2V-ZZg@thinkstation>
References: <aYDjHJstnz2V-ZZg@thinkstation>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 206D2140011
X-Stat-Signature: t17h9kdcto7rrh5chznp9efmcqjqpdzs
X-Rspam-User: 
X-HE-Tag: 1770062597-118631
X-HE-Meta: U2FsdGVkX18AvC86VBacQqdTIAGbeVcvZkKKq2KPJbH7ukxnXAqTbgdN0+vuOdk+5Q+80QfuD2LJRHHk6g5UHecoZGIpGIDdjZXg/x4NbH6WPsHL/fAOLVeu/ZmrWU5yrMA2kB/esffG5QvqINMh35V3XtIi9c3jauJrLEqyuD//QMtRuWLSUXDucIxOJrikkE5pzgCQ73VdPeUHC4Jzwrh9vx4IVkRIOrcHcD+5hUY5LvGANCD/d3cACfboKRY20JaDjbtxqLyJYq77r0atXDo2W2qXg4JV6mCthWtnhe1llqvptXhUhccz2FjzP0KLqGHNYWmNkIjulxgXJR0Aq3++HjBYufqWTAS9kwiWLp0RSFPPLXQ4uJ6VxpyDQuK1jU3b9dl5e1puk4SfIQ02GV4YlUq7kCtUbPaYBSZyXTx/xLNoeHeQZwrx1/tGvoXSrdnIDwLhQVfvTT7pIrNzUGpLyKugvSE6fq3B/x0B0JRoCd4l2oyvHTroORm797qAw9elYlB3jmZd1mOVErDcvvzjFYEZG1Zacu40BIDwHnDkjuOLKcY0G4Q3TKCsvZNaz58Xbv3qKQxJ5pULHGZKA7HPWJY4gLpEiQkjjQYfVgkiAojYGT/BK36y0QIXgfAK0bgXGzLzDyD47muNnFb6OXeC77oTZEzNoxiTGX+QFH0MnfpyProyUIfCVnlPqnPIKL6G2jTiDfAfaAkWfAAhoObcBpA9uvyaw8shga5Mz/oQ42QlNj+mF7nS3fYYw/v0mbMZR7xunD3oHdvpXDVAnz1jEFUGvDMCKTbzahANgmGDH8brbWMaitBGlfqlbBZoG8voasAJgvsHCogzFCwsyJC0o9K74jVf8AjC3XfkRbl/1IBigHar9GJIfyPMpEDyMoYnz+evmkDesfZ6YPshykamBBoqbgjhgr8sO7pd9907UXuunEFBazB6U0dRHJyNectWofWnW6FcJO+lQbk
 7gI30H7K
 aiD4xef5sxXMus1x7+uMXKqTATnoyWshE3GJ7NVP6kRcxgsX5yDh5DdCy5kNqDm97vinEyTGUSgUNCANiphzwdLDqJTkKr0U15VyLm34wi/fvZpexG3s9JueGShqNKyOoaXIaK2XGSMI9TuM2ua9QxNBNYALsSpJa+ZwxBcQ47PRqbMeebV9mYJI4W7vqM+ntEREXDi/r51TBhbO+3J/soWsRWxjP2IClObKKkmPNUWwwzP9T8aHVwNzJtS4+RLvyzcdzxHGllB2Jym7i3pPeV5XeOBJmJim52CA4Ckw7VV0DrirWyYJjeCmOeG4TfomAnVrl6DqTonXcDxKoQxFkm/inDVQWIJSC5OyV7fjU6t9++X0nmA4cV7VSVhXYbOVIa1wG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kiryl Shutsemau <kas@kernel.org>:
> Hi,

I think I know how to fix the problem.

The problem is in your container manager. It seems that the container
manager doesn't unmount filesystems or unmounts them with MNT_DETACH
(i. e. lazy).

What you should do is to make your container manager actually iterate
over all filesystems and unmount them without MNT_DETACH.

Of course, this will not work in your scenario. "umount" call will fail.
But at very least you will actually get failing syscall. I. e. you will
get fail instead of silent leak.

You may go further: if umount on tmpfs fails, then simply go and remove
all files in that tmpfs. And then unmount it using MNT_DETACH.

In fact, this will not remove all files. This process will remove all files
it can remove. I. e. exactly what you need! I. e. it will remove whole
47 GiB of data and just keep 4k, which are actually busy.

Feel free to ask me any questions.


-- 
Askar Safin

