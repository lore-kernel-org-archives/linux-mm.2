Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7A9BC624D3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 15:38:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7EBD6B00DE; Tue,  1 Sep 2026 11:38:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A304A6B00DF; Tue,  1 Sep 2026 11:38:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F7B16B00E0; Tue,  1 Sep 2026 11:38:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 601CD6B00DE
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:38:58 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BDAE340443
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 15:38:57 +0000 (UTC)
X-FDA: 85165601514.27.AFD7286
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8979640002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 15:38:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=mSpN6oVG;
	spf=pass (imf12.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788277136;
	b=uVKl32/HHBnUTgDwMFlJfDBIh0xXJzTlP+6KoIbj1PB5CSOMY+KjdjPi8HOBf7NfdqozHO
	/tug5zyg/hVtVWzzikWHoBraSq4E8cTe7T/Y/V6XU0gwlv/IAiRYXiGP0r7EuPEcLSkZ+3
	KYYY4fRy8zPIG4Unvp7OFJih15Bp/uU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788277136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0OJo9BDKzfcZA2u2cy0960w1Ox7UILmrTsclNvb0Qhc=;
	b=LqDaM8PvEtp9LoHC4tO/NH3mJyG9yim81O7YbgWijBLtfdWbjU9Xc+Yxtrqg+cZ/RvLicS
	y6QpjYinfXyEpYo9vfZFcGb+hIUHzbmV0SeKL1D0ro/3zLA3tB91Eb0mQKWvCNpMZ4n8GU
	Ot/6CcsYc2A8w11CMKECege8wTVNhUw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=mSpN6oVG;
	spf=pass (imf12.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-866e57f63a3so743637b3.3
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 08:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1788277134; x=1788881934; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0OJo9BDKzfcZA2u2cy0960w1Ox7UILmrTsclNvb0Qhc=;
        b=mSpN6oVGgbsamoTkK8mNQ+Qbt8Ny6I09zAfBDob8JrzO0CF3JFFRP5cj6jWAKre/hs
         zqElGjkWMFYQ9L0vkUNJhaLzBdVLhB5xIIlKKknzMGhyPE59hqOMs1vuT2mtorqf+5ns
         7U3NTfdh2LtIxoX2cQ6qjMFHHMkfMPU0ug6Utk1VwvH7Uy0BMKHuqylQ7JP6QTjIp35V
         BaKCxWHgTR7uF4JtZXgIkiO5YoMOgQKU0tOU7c201EM7JMYRGQXY4EvoMrG+YWhVph5h
         yuj72oDE6oOl4xwQ0s8Z1mewwhPqQSmjfWeScGDVqK6Zc5vKTCnwXDav4OAvolcb+cUJ
         8XhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788277134; x=1788881934;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0OJo9BDKzfcZA2u2cy0960w1Ox7UILmrTsclNvb0Qhc=;
        b=ExQDdtsFn0s9rbbrsw0b/Rh2kn9Q9qFuEZZj7kn4E111KbzodNTd6jmftO405zTCmE
         /QUJC2a+nbA4OCMy3fA/LGw/HlJtufNeo3Yjrhp6vVPVccHIpLdkQhG2+QrEbl+AOjD+
         MC11W26ifa3P98QHqEOc/mJ962lCcJNm0FMKJCKEddDqW3aQXJ6QnyRlejrl7gAatEKJ
         vFms9hEUp644lEnoVj7H7jiMhq9pzgCxRf/cetoPYlegoZbHe28s99TudeXEartB1fcQ
         4hQOeGUHpAnbQm2WdJJrAFY7ZstskEkCLzkS5Wl5pvnXJRvlrEctqZIWqXMGphXu+Pdv
         E6pw==
X-Forwarded-Encrypted: i=1; AKwUvByrjc0K94oMi5NxrQoKUUdkeQCgOLHcxNzFdTc0mMngVykg+Q8g7zHb5vwUjmdr/V+3qiF2TpqWeg==@kvack.org
X-Gm-Message-State: AFuF++ni7Jy+kS6qlxPTYxNqvBOYiv9ozNAog4b/Qg4xcS1tFLNzd7Ef
	oOaClUMUHd+MWzb+25QAj+fyn/QxPa5lFFXdzn9R3i8fVCeDCvptFEhb0p392Cz7ewU=
X-Gm-Gg: AR+sD11OyGlhaR16Rk4Se/rostjAmRndOIVD7qeCWia+FSKMPD74zkXP2PEZuNZJh4/
	C5yS94gCMSqGLObzUWl7K6XLRbHnSKDhGNSKLS32vCrw2WDCpOROSeQr9f9yErI9em4gmJ8+2iI
	7XxqWrI3ezwNKKJutefoL7LJIxEV1G+74x/pudRugK1Yvf0iW2IgJZY+5x6F2wb0lmKDzWq5JCv
	QXf5CYNHyf41wjG7KHzpY7dEYMBIAXBchmyMXBljqjSXVJv1ynulrz5eQmZ4y5kCLT4vk+7peGv
	wZZtTKRi3vmqHBnV/ch6YogAoheUZnam9wHTj5CYnF4S0DYXY5Z0geGHtw3WnEoNNUYjvfYwE91
	1duKiOY7+QvkL3S1BCwfA7xHgAn7Rx0bX87+fzZM+hObNZhBjr+ZKb0DRaC3n0v3zTdaKsEDOxp
	InkFgqq1ufkY08XObS3wlTKydWCqj20KEqwCkgsoeqY614dmi5wZd5Pi4y43Up
X-Received: by 2002:a05:690c:f13:b0:859:6fe3:7352 with SMTP id 00721157ae682-85d69e01771mr129530347b3.9.1788277134333;
        Tue, 01 Sep 2026 08:38:54 -0700 (PDT)
Received: from localhost ([2605:8600:200:1a83:fe59:7385:2855:8588])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8650aacd1c7sm48548897b3.35.2026.09.01.08.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 08:38:53 -0700 (PDT)
Date: Tue, 1 Sep 2026 11:38:52 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 1/3] mm/zswap: release retired pools via
 queue_rcu_work() instead of synchronize_rcu()
Message-ID: <20260901153852.GH3004@cmpxchg.org>
References: <20260830114731.8322-1-wujianyue000@gmail.com>
 <20260830114731.8322-2-wujianyue000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260830114731.8322-2-wujianyue000@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8979640002
X-Stat-Signature: rj3koje3bhcfuoj1qx1hn84u9burw8j3
X-HE-Tag: 1788277135-850636
X-HE-Meta: U2FsdGVkX1+8sreE1xdOmTZYUcT9ICTLWdciavn57ZJkH1YOm6H+AsKl0nm/zfpFdm7GFlHZlzuPljouCgQK5T+riNJtkpLSePPZW8lTpR0HbCYBGD6qjauekfY5SG2HERbtuuR36ThL4MyHMC0Te4X/1w3q1XAFFIgBqaevaCRXK3THfaWWN9VVkQc07Ol1dfcEsgQnd0zqm6W5AamRn/2MZ8mhuvTasr8foAsKfWxDXsFm95vX3H9gRz6UCGhhq1nz8M4q77eITsP7LpPrxiVZJnNSyAsUZWGmdiOdXZlE8JBVzIknszHe0Sli2vBnN6UyYczStCWPTfzQQZzt4iNZrSIJ1k5TB+vsR80ZLQLBcACJRnKH9rVFyzPKe9gvc5R6/C1lMHv/dqes4/r7w6QriZ9OqcawX0C+4NCgumPzZm5M3rinuR/44NSTS6/xXtJfGbAS69i89KJh88TYyXW7oUjc26E2h+dTbvE+v5A4nXMUyDg+ZEAbIJ9kuk44WtmdL8y5viWgm//I/0R3EbT9shEtrrbcIXqJ9ZTPf9v+a3mSPRrZe9vrCXItA7YjN3NlPYGLDeO0FIjLHQUPM3EycGRePsIpEvfEU3umhn/OKDBBX/cr8ICg46VBlF5qVWPsARBr6mJobBBHudc7j963F+aiXBsdnylmtUx/ZVPFzORMFxVDJQF9ueTa+KF2UJpFobGGiC0tkbCHMxkwl8GUkaLVAAWKvdGgfAMQAuv+n5TtFJiT7+qiH4gS5i661CdOO5f9e5kejpOfLuc7+dXRvO8YMYh7YwCNt27XIPRQwymc06vtulxK5CW/JSsg9myHa/9QWLqW+Nst3V8jmYdsBcp/nCcAu2oBmgtooSt0J4YsFYjsz6qdPyv/lm/Ypb5kRN/v071HDsmAEGoeJi9Zbw7yREf6DdzkrVxDIgrGdNNkGaGqSKG9JcKWCFtsYML/1V/LynXNFQq+x0G
 8XkAxKoB
 gRZBtfTji8dai4j2t2qKmMsWNYwcR2Wj1JOsxuWL7B8bbSkwxg7rNgw16acekrwbqaM1EokamyTtUfrPH/WFo0eD4Ni5vQV/RK2w1YSZL7vn97phhEdhDzQF2H03WOS6VQT44HMSFsVdaQrEGSEP2j7I4WDZ0PL8UGqVspDqq3v+3p67F+hfV+4n/p9mGnKI1PmmN7Ad27g+Y6pUsn612TcGuehGtyIiXiTjBCpT7dJ0uwMYclJIdGSinNMlJ36GYJheYQQcH7kPqWthOBnH1eYkvDgc5nnu5I0bVVEi5nHddk52sohwXj3klZRSa70YaAnWXZQvoAA07EtMbUqdSPrQVjJkxBv7SypVM3mcRNH/7wXvilIMfcsazSvMFCTQUiHpTz2simUoAJEN4CvBCxVKiuhZpZ0Qh54l3PMHeRSYoRMZCwWXJ8iBFrvELwVUsTAbtiFO/01/S/mIyIrMPfJ49z8HCQGb8QK3AlDd09UZCmWLgawMfyBYlX/S6deu0tQdhn7F7sD+cJKmoP4p7zAQMTM3fdXLB42EXPZyG9Z5knl4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 30, 2026 at 07:47:29PM +0800, Jianyue Wu wrote:
> When a pool's last reference is dropped, __zswap_pool_empty() removes it
> from the pool list and schedules __zswap_pool_release(), which calls
> synchronize_rcu() to wait for readers before tearing the pool down.
> 
> synchronize_rcu() is a synchronous, potentially long wait.  Replace it
> with queue_rcu_work(): __zswap_pool_empty() hands the pool to
> queue_rcu_work(), which waits for a grace period asynchronously and then
> runs __zswap_pool_release() from a worker for the sleepable teardown
> (__zswap_pool_empty() can run in atomic context and must not block).
> The grace-period guarantee is unchanged; the retirement path just no
> longer blocks on it.
> 
> Suggested-by: Yosry Ahmed <yosry@kernel.org>
> Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>

With "release_rwork",

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

