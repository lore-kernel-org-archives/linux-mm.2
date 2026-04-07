Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A931FEEF49
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 14:22:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F9AE6B0088; Tue,  7 Apr 2026 10:22:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D0E46B0089; Tue,  7 Apr 2026 10:22:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70E1F6B008A; Tue,  7 Apr 2026 10:22:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 620E96B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:22:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E4DC15AB3A
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 14:22:15 +0000 (UTC)
X-FDA: 84631974630.18.BE1A9CD
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43])
	by imf25.hostedemail.com (Postfix) with ESMTP id BF39AA0014
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 14:22:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Q+FUDJMj;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775571734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o1P0gjakWASjJripl8bLKBkikWHO1vI/dlXEldSh2VI=;
	b=1+0Caj8ZNjBYAZ4UIkpfOj7s89M1yOVYF3J36x7V+bVX4WGIS4lFKS0FuVSMpijHHoC6Of
	KRdGmlaCSWPZfNsBQ87Q0UFpdU3LXYyL6XHByZxV0Ysmmj/PzveUwj3t7X+eAU3B3YBdmd
	+Ehiju7JxBFv7Fj+s5vRNllAvnrEego=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775571734; a=rsa-sha256;
	cv=none;
	b=2K+KlvfRuwCr4TPd8QK0JYHObCQb+Q6hU+potbyRYOnpQAg8owZ/WTx3yX8yQcQcL4vA5y
	jfFWW0t2ktfFQd1gRDqT1ttAI1F0BJh4Tx7hH3uwKcxQreSjXU4qlA9cVDG2FIQ1XKVIS3
	JuxbtyzzUv1BEe0TP6/f9BChFMECLhk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Q+FUDJMj;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-ua1-f43.google.com with SMTP id a1e0cc1a2514c-94e2ad66abcso1480636241.1
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 07:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1775571732; x=1776176532; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=o1P0gjakWASjJripl8bLKBkikWHO1vI/dlXEldSh2VI=;
        b=Q+FUDJMj+Y0Cj6f01aIet7sfOI/fk+LPKBG13oF/JLxhBY/+itnPHOJDAsxy2y/sRh
         W4+3t6Ta5qGZCo3AbeA4aQ1YE+ggbNvuW8K2+fkr6U9Uv7YrgXmMzMQM79CqCXtF3PS9
         wF+XWaF4F8O0MMKmH7JD+HKQieAz2VIMneLEChEy33DLMyavH4kAsKv2Eoao7McF1fF4
         pVaD9WODU9CJWBCRejincxsp2BqpHPaGexEwJQ3QW7vwP4X71QhJdtrx5kkYcvWoK4eb
         LuGVPWKEpBySGWo/33T/bzbKmZdI/XvxkEQFXHr4z5qozSxciO/Y5KW8xbyEC+69nY4f
         2YQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775571732; x=1776176532;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o1P0gjakWASjJripl8bLKBkikWHO1vI/dlXEldSh2VI=;
        b=DE3k7Wi+CGsVBzwk4nTWqtLO/B8teNFrz3W7c9uaHQefaX1t8ilcE4WsV5GHEQpUsj
         CFtYvyAAbKi4h2tBtASx8shijgaGIjmx3TtodjLDjynxic2dEyx5VTKA0NBcdFvrgISY
         Bmge8hK6F00KwuSmcQVmeAJigrf94L62a6czBDGXHD+XHJ2opIfFjLWRnmFTlsMDtQCR
         TwAGUVLW0JC2wZDjfbZM6RTevb1dEft6Gm+0YthW9n2XICsmz5ovKmhxUlU77mv99XMp
         QCbIpwfP+69lNQKXlvgMbiO7WKfdSzsypKOAm5MV+JbI9D9Q8g3aFc6TpMXGGMOlfMIW
         P2vA==
X-Gm-Message-State: AOJu0YznuOtsP83xTdS0Y6kHH4TFT6M8rn2M6gStMMkkIX+bJS6fT9ET
	13kLV/jBUeNcxFkDztz5UrWDm7YU7ummCg1shaaSa5IrjX1sHakuxAwIexEHRylFHLA=
X-Gm-Gg: AeBDieuMEpEk7bQTgso4OTgrLjiGwNkAyP8g0tle3wulJbk9KGwxrByuIOdiaKiznTO
	dlAvBomaviCINf+uOHdZUSQC6HHac3hWnTqfPN76Na4GdUMYCycZca/l717u2CGQrCXlFhIp4qf
	gx5DWKedIN6jZR6TMaa18PJifagXAeTyPZv0V+WABXo1eiCWFr17uQBPF2wFKIGY6a4pnfCFgid
	sIiiFwFW8WBvqkfnJrYSer5CHAJpYgEpfkfSZlatCrUihONRyYsTggtWcOhdpkekz6OIdaAxKFK
	0JAnagY5bFLwv2m+pwVQOcNmds4p7GsRaCYgIZzAUJ3h9e/k+RLqdai2YoBRJQKrIm+JDcZX0ak
	EA7Nbx+jZHFE2wS1yeVh2kedXZcHsRgWkue1QqrfJpW8ZWcuZ00mNcZgcBXdH7wnKbs8hxCKF6d
	xiTsrUnJLY4kzOmviXtHDtYA==
X-Received: by 2002:a05:6102:6895:b0:5fd:f744:660e with SMTP id ada2fe7eead31-605a5129e8dmr5103172137.28.1775571732427;
        Tue, 07 Apr 2026 07:22:12 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8a596915794sm147000106d6.30.2026.04.07.07.22.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 07:22:11 -0700 (PDT)
Date: Tue, 7 Apr 2026 10:22:03 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, david@kernel.org,
	mhocko@suse.com, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baohua@kernel.org,
	bhe@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: move folio LRU helpers out of swap
Message-ID: <adUTC-7iyOAUlhR7@cmpxchg.org>
References: <20260407110002.204755-1-wujianyue000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260407110002.204755-1-wujianyue000@gmail.com>
X-Rspamd-Queue-Id: BF39AA0014
X-Stat-Signature: eqw6brtgh9wh73w7wzyip4q5jeez9p5b
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775571733-466928
X-HE-Meta: U2FsdGVkX1/GbcwAndXjBGclsYdScWMerAWL4g0cQKX6+9n0Ma06005VINjPEDNapRyYSXCKRzCEUhiRl25VHCGIzmoMwsKlXxSDMlUNWAyIHsltSZcXLUFKP0yWEd7zxnSyBdNpmGhLl1frqBxcJ+gt/zb/7df95whCOjCMuSLo8jKlcIL7iCf6agJSzMaFCHCj0jzZnD/1w8/3f9Paau8fpdOE++jk5Tk+p8CqYYTxXxU8EeRsnyOJeEoxzjdOdGjHdxpM3FsbtrEOpUIntwt81nquQK2xQ4StMBOBFvCf3zoakrdUE4ZFpe34rN2GE0QJMBgI38F2jJNzhFL7tnkAZesEJ0rzqcnXxcjvwhWrh37TaFfE+iCvuGNGUUdPo4yTYVoF0I0aVxzoyaAcssF2WEZYK4Dt7AaojYyTX26MPXr0eelB1SWBJWezJPP7pLQ4c3z87pqvsTAtByPwq3HnKvGA+cFKoHTbIUo7VpA3d2kEYlD5Tdcn+0/MOMrTB9qybYeYAODRGPeTIDE1THgL5rRAi+p32dXcsezfRRKXxYkzReQYs92hewbcFq8XMSjrrFbQlNLDAdefzz88jY2wuOv68H03Cllzz5mgd+A40n2bgEvdHncRqcbqq+Vmai/Rv298kWSsAutaFkxKimQaMaW6+1LQjbJf3i0alTgvQcF48oQ3jwrn6QpI4l0ZQi2KEemqYtV97KXii/WtKQM93okVaxoKujaHPoWPTx8qHFIEkEz3AQHDmHhRYLA3LGsutclX/9aowJdHnZtgqJmGC/c5NZDetkLsTGDdX25WsbSA6zBDWbHq9mVBnsY0pE4Z2/vXmVC3m2W0NYRfICsn0S+up0VjuKwR6CJGI5KgmB4uN3yGWrDw7aFLvuRMVhKeGs6LvTLyb7Qug+So4EhxWE5+3GrRMyT3wB0in1YE2i3eSeOF99HaspPKG+LsyYxFCVQ7VG++GCyxE9/
 uYxiFsjH
 cZl8+5pgNTHxjCHr6M/r0Fat6DzI5E8teQJlRdQ7B2Wpi6TyoXBC+L0r/WhZSZrotm9+c/xtyjtYnXQd2uSr7DyaS/n9INpL2tYS2jp2tqLV9qsFSGCtu24fZjcmPAGiYY5OnV9R6DaoIMUGGfhvgagwM+nvaN87Diwl8+xHsWCgCRdqik9qVxEPY1DbxvzNVh3CZhN/WjAig7kU6HUpZWcSqf2zSJRALkde0kAnh4c34L/JeoaNn4q7drC9tW1TAaBw1EVqxZ0Z8tRKX+XOLMlQ+r4RXFeGJn9Q8ctDtu8VhVcug6kS1bSGtokmNwV+LodB7RakFaB2A83IjvfChHKw1k97TwLkElvBGeOv/oHbR1kKvt6+JBR2451yvxjkXb1MWc0087mcLPCrZPDDz0XD4lA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026 at 07:00:02PM +0800, Jianyue Wu wrote:
> All allocated folios are added into lru lists for later reclaim whether
> they are file or anonymous folios. However those folio lru operation codes
> are put in mm/swap.c which is not so appropriate. Because swap code is
> only for anonymous folios.

Ironically, the only thing that doesn't fit in this file is the swap
stuff. The page_cluster & sysctl should be static in swap_state.c.

The rest seems thematically relatively clean - infrastructure for
managing folio lifetime. swap.c is not the best name for it, but short
of finding a very clear improvement I'd just leave it alone.

