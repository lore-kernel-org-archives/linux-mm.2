Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE175CEE343
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 17:27:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CB236B0008; Tue, 18 Nov 2025 12:27:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A3D06B00A4; Tue, 18 Nov 2025 12:27:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F225D6B00A5; Tue, 18 Nov 2025 12:27:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E12E36B0008
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 12:27:24 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7C6241DEDDD
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 17:27:24 +0000 (UTC)
X-FDA: 84124409208.20.0710CB2
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf16.hostedemail.com (Postfix) with ESMTP id 80CE5180011
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 17:27:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=V1bj0S4S;
	spf=pass (imf16.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763486842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GeYIGeECIYv+1PKRqNzOMqbwXs2hjyOg9yKuiCvHd8o=;
	b=xpprJwrCEa2r/1cKcWBoZLyFnrJDCm1bczvTABGfjEHlixsrH2DYJPf415GIcgWcST0wF3
	HmXZiVVPM29tq/NcFb4bHOcDSBCU6zKBDxhkgcyk69dhWyZDMzPFQ0r77PKYSdOK1MDJBy
	TypMFBH8wqOQziEJI0wAybDBdvH7CpY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=V1bj0S4S;
	spf=pass (imf16.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763486842; a=rsa-sha256;
	cv=none;
	b=gSQbgvcg0Z2bHhhmmxU9Io/0KfHSZKp7eEZ2J8d5hDOoblX9MfIeSrfTUX0P0pehrnRgAN
	dMaieSiUkSA7uOFhLhiUlOVKkPEzJ722CZPwlo2bWAJ0/yb8l96IpTPC3kLP+jtCharvbM
	BrrNrvJ/ccLt/EgsviSvdm0FTEDjVLw=
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-595819064cdso56836e87.0
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:27:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763486841; x=1764091641; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GeYIGeECIYv+1PKRqNzOMqbwXs2hjyOg9yKuiCvHd8o=;
        b=V1bj0S4S1RWk1cew8qSkirN9SvtHZzFST7XUDM6drDXIwXhAZnLuNkXufUXeRmgXtr
         ttgNPfmJdh+D0lbUiak9cFqMs/fQzRlpDSdIFN+rhcAIZrfbbAeB/ByyHM/lDRRMQ/hD
         nlcj3XylasaIwLnp3pHcL7YZxF8rdJ8JaJBDGc6mFz00ENAaA+/vb8pGV2pymmoVjAwO
         l4VHIfUXg3MWMJcuGiazz8M9OQTUGb7GlO3RMfjGlGxed974XO4TOLz2r9pLEvM7DHft
         Md7/VSLIky4Ds6k1SadNtxjXRQiA72RMiNHTudsf6fYUGx99YDVh08mVv1h7cYlrUMg8
         CSkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763486841; x=1764091641;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GeYIGeECIYv+1PKRqNzOMqbwXs2hjyOg9yKuiCvHd8o=;
        b=j1RFnG5KDc06fk5oz9IZOlkvQDIhMU6ROjyNCkVJ9+Pxa0LUyiRqN3cD+52tJfgJqE
         AmSIJTzY3aQHkPRddMGhqHL7QqtQiLCrIOXUDJk3GgUtTepyaTKQTk0fuuDD+l2tgAFO
         klm5C6XlKq0QqMGQdUAeVFWS8ciRyWglL3j8pcRO9QA1dLNbvVguaoUUzBlpH9hm3617
         nRk9LEDc2d/vBBTKYyUadA9wHLGh7+4muxxiV6r8/c2cBlGhtr841x9ueZtX/J3iKZMN
         17myyCkv0PH9mq2quZPkHT7PO5lQCMP9HlEP1qzaJ7vdoL4EnYUoPODIe2whzasHsyGq
         xw1A==
X-Forwarded-Encrypted: i=1; AJvYcCUn/uoTsBCjKuZG99sJ4vutMQJlG8SvuxtybgcFTgJjtZx6Z2X7jsWjXO2Z5MEQvpTa6e2BfpBEYA==@kvack.org
X-Gm-Message-State: AOJu0Yw+i9yxzpuJhx1oYj6uP/LTvAMMDrgWs0oRvP2odNp1p1aT7Vfr
	uizjshNHs6hCqFa4wYziH3jdTXr5M2Au2UGA38rmrIru7HYkFMLaKQy1
X-Gm-Gg: ASbGncvhAy9aNMoRnj7oZU+crz7oRveAvPG3E/oxqLKWjMmw0hK2Ox9IExo36SL6OoY
	ANdUOL/AhlEVhLbasGreKGl7MW7cdsIOi8MKYTeCaFfa4PhmMS2Y6xH0hFLUpwh//gtzAh6CuYT
	r4MWPuKly9y1oXcISK3V38BCzXgI08G6+Ged/cuUqacBjvdyiZdrWQI7F+b+X1aFi7itv1jb9tr
	ael+WalwQcwWVCmvkodMYXX4DNDBmm1x7jcHaUa2rhdTh37XJ2hTku2zhZq3NwGuoYFeb8AqYuh
	U/6TdX4FW9TCL9XYVE7zOZMr7yGWlcqUJqbawZTH1ctLutIaJfLagrJWIUQM2g2iLTlqbXFEH9L
	ZeW8xGFoZSlId1sI0saZuVc/YHA7hKkeTXoE/185I3+2Xhsaxlwv72A==
X-Google-Smtp-Source: AGHT+IHMtbVD5e6616CjOrb6Sjbe6GElqnu6dJjDGJNWdOtSNrU9bV68xcPDW2dOFoWXGtnS4HUs4g==
X-Received: by 2002:a05:6512:63c3:20b0:594:2d64:bce9 with SMTP id 2adb3069b0e04-5959d9c3e89mr74276e87.4.1763486840350;
        Tue, 18 Nov 2025 09:27:20 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-595804004aasm4124068e87.60.2025.11.18.09.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 09:27:19 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Tue, 18 Nov 2025 18:27:17 +0100
To: David Heidelberg <david@ixit.cz>
Cc: david@ixit.cz, Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, phone-devel@vger.kernel.org
Subject: Re: [PATCH v2] mm/vmalloc: warn only once when vmalloc detect
 invalid gfp flags
Message-ID: <aRysdXRCistSHSJr@milan>
References: <20251118-only-one-vmalloc-v2-1-fe702aa68d8b@ixit.cz>
 <aRyo-d-Sj8i0Trtp@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRyo-d-Sj8i0Trtp@fedora>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 80CE5180011
X-Stat-Signature: 3ke78uddsp69aqz7rnewg5y6y99nhrm5
X-Rspam-User: 
X-HE-Tag: 1763486842-251752
X-HE-Meta: U2FsdGVkX1+3aNjtzyVObPT8XS6kOJ5W1amoBbrJtPLtxaXZ32X0BWGsXysexKAJsfoBODPZdgKGJjJZBNKsUjQSILCItd5oMiD8Ti5Zx7qMnEAa+58pwo+xj4x9S/F1atx/dRZKt/rrxOGviawZIZaeJ7tk5LHxvMZXl0HQcnblCi2MYvwKOD7gX8wNdQ5E/bYlNPKQPaKXbs/eSYpg9TPpnvHR8gutFjiFFMbUXisJLAdDmzOzXdR+3sMkha5CBGiW/M0p0kyx5biowytVrNZhCYUHOMjuA/HloFpqbtMeA247MXu/D78nNBqH/Rk5fiDKpN92KJdNIK593GlWPYtq4Ttck6V8sDV7Zc2HJSoe2/Ph18HknG5N62oQYE7X9iABl4f/8W+2N8wrTfBLy+onOGilL997fsMlR8bvkhmJOTSbfx4UbLVnvjohnr+D014udXrSO0IzDBNLUqATP3twAkg3E04Gvibzfcx3PMdBiCj65vhLtsaJXfrQI+jczdr43uKSXOQMSjY4btAa12qIe8q0iGoVDohrkr5pvsoPHyt/T8M4FexGGhCG1J/0IzqD5kTCo8zLOJe1RKIn0XvZnWqZNa0+N8M/JsKpimuQXQORzOt5e9E97prblnxS2+6ctKkzzLXtI7JO0iA+cY77SNyoxt6Hv6AA2wepP0nleFBZCPHhZ0Z1HyAGQ/F10QSMkacOdC409ha8HtWuLspF9aIcFcZAt/kZqAzm9ts8nfNx/iPFKyjt7/ADQlltRz4ZfHqbdaCx/AH/Dn5nTQUaA9suoWat3Fx3YB0FUmSg9n9ELya7cDXZUhC1ckIe4xdeffcb/VUymdzoNv4I7LCTsVhfLhi42dDdkNv5eWWHDQbpR2ZSPkcfRlpJT9c6YNhTg6hTjymHm5gG5T9e/rvOftRRKu3gQnGIVGM3wTFJEDXOghNjtmmK0QXyEcamYUElEIQYEJyX5DKf5oC
 nqXrNveN
 dwxH/3YRew1dEL7gu2pIQVrCHFK1HVi92Wt0gUgX/fvmWfT6acwcagqbk7SfqxzgMyYZOLH+8vZ+6gvC2KY1C9lUB/6HqzaENy1pS1K5Ehc9gyMWK8UTiSzZkBBdeX4ae1gqYeNy3PzpR1/o3BRCjSM98H9Bmuxm/TabO1nS8Ip4wHGHFwFaO/9UlNztq8El4TDtTXimWxHYJVP/TNe1CW8IOvhMPjLQXxHjgFEaj8xCoSQjZmw5Revel9l2IzAqkZc3GYBUXkTB+q53/+yKiEbU6ogJjCh1Ny1026Rh1ROvZQvs+NigHvD4JXx+wRzm22SEi+I05IYhOH/Edxe5fPBt2lHpEIrYCAxNxGRU8yntlc6L+ZUr8BcSRLYinYhmZ0NcA7aLs6TtultIFQdjRgfognfIIn+7XM0e1kERnYQkAbvTTZMk3Ue/a0uRcjnM/BfUUaFVcGf84tg7k8HZ+hR7gpQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000006, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 09:12:25AM -0800, Vishal Moola (Oracle) wrote:
> On Tue, Nov 18, 2025 at 12:37:16PM +0100, David Heidelberg via B4 Relay wrote:
> > From: David Heidelberg <david@ixit.cz>
> > 
> > Without WARN_ONCE, the logs get spammed immediately after the boot,
> > on devices as OnePlus 6T (Snapdragon 845).
> > 
> > Fixes: 7179b2256315 ("mm/vmalloc: warn on invalid vmalloc gfp flags")
> > Signed-off-by: David Heidelberg <david@ixit.cz>
> > ---
> 
> Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

