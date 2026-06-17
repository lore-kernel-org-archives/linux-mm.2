Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E94A2CD98E1
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 03:47:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97D556B0099; Tue, 16 Jun 2026 23:47:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92E1C6B009B; Tue, 16 Jun 2026 23:47:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 845596B009D; Tue, 16 Jun 2026 23:47:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 549706B0099
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 23:47:03 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9BC481202BE
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 03:47:02 +0000 (UTC)
X-FDA: 84888018684.28.ABEEC8E
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf26.hostedemail.com (Postfix) with ESMTP id AD949140002
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 03:47:00 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="K/h/zD1p";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf26.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.48 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781668020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pK4PQ1902R80gheBMlvl0pQHw4MWAl4a6tgY9EExy9w=;
	b=rScX0NsgM6WS6L3uwGOEC2Y4uVl9tC9smPJ2ZNC0vtdtfzz4SJ51l/Dxjaca90NcteEvKz
	RGqKJWdLaZV3/nSziJ8DEHFSRPcEoEqUiF+Vp/C2mmOCWyuOIsHntaWZ0Uhy4FZXsPWj+z
	HjNqLXu6/KILCLT3crC5on/761VsnDo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="K/h/zD1p";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf26.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.48 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781668020;
	b=0+q6znhZEBfzDFKrxC3tNzDznln7wI44RDh5YlLlchIhECccTJM4lBAqlS/Cu7439dvIb4
	FZafQyMICWPP1I1Okkq6aRdqj1v50QZPjpU2xEdeOnp6jD8CBRmwg2wruIKjJCF/JBBSkB
	CZ7RPMePP6ArxPHCtBwdq5KCkBIr07U=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-37c64d34032so238576a91.0
        for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1781668019; x=1782272819; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pK4PQ1902R80gheBMlvl0pQHw4MWAl4a6tgY9EExy9w=;
        b=K/h/zD1pwyOYvK2Or2XIFfxnP/Tit4hIta/V4HUUv9iVg1AwWRMpYoyHlzgENMR2R+
         994xBgnSa1f+c15hzzwRc/FkE/1AsM7Jn+29t8sSfxXzpso4ROXRoNXZ+bPMdxh7LsMN
         shsBH3m5UM0PDlgIEMspCcSSA8CxyznaSZ88Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781668019; x=1782272819;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pK4PQ1902R80gheBMlvl0pQHw4MWAl4a6tgY9EExy9w=;
        b=EvitHy1WsO4dmjwcRynlCfvtDUTE68yiP7sPIBkz+WprZ5/gowzQlYHDkxrpTWekQh
         w7T723wj+dipLOrCKO8W0YhqhlPjEhRmooJcd+p27OV6iiHeimV2FOsYf9IHFI14Ddcn
         WDumSIk7JMmKi9nH3bh3DidhkkyfUBm7qZB7xRaxeLMs79oF5ZXKizDGiBewhMWrn5yF
         iJBrUTr3ZVUrMWiI6T4IyNWOLHu/700kTNAbLvxX+iJJkuYQRDU7xCBbbqOHi1+FNuIP
         8EfXaJ9uX4qWPTc0892yrLRUHXtFmVNMmIDUqcDM+zJMI9L2RI6PwiqA8RTaU+hTCosL
         inaw==
X-Forwarded-Encrypted: i=1; AFNElJ8Q8KjQOcYP3aKzTV+4HJHsKP4UshFEF1PBF6Se1wQdLQsE84nbzM9jCmbdPbxrzjFC7j+RFe4tXw==@kvack.org
X-Gm-Message-State: AOJu0YxGReES9+M4jYyprpjMjjQZRIYzlr7c0F524EUzzg1KlZWctELH
	weNiiWk2L8MIKlaJs9QEViAkmRMdQSZxkTv7SylKhnmJ2Sj2s2XJtUH1MBEQ/77DCw==
X-Gm-Gg: AfdE7clITrDmZOdOxm0dfKoP3PJ0eVCeoFqANn2gy0CunPdirwvtlqNZs2wrih8W9Tj
	vTsaKgf/Xse70Ivpf0wzP52xf8dp6/W2dIcVBp8/IHcn94C75wI0uFgvksTLt5lM6ydz3dXRN87
	J6s/47Vlh2BFzD8h6rckWwgwRCfYPrUy3ZsgirT6GlRG4rKW1g/jqhQFIzHRU/lLTyOic/QuK5Z
	VPcbA/Q8fBBokCgT8ZVOUB4Fq+sIl/9cW1bMhaOyF7++db/Mk/JERD1mtaDK3ypFdnvappbNRG1
	6Q5Il0SscNrkpLAWxosbMrjI9lpaxSOQOOdyVwAUSSqJzePDOMQR1Meu2dwm2/trTT4SOadlrui
	chJ/sAN7tBKkzpZgvOHMrybSq+BQERTHEcCthPRheSzfIzFt/hlcGHeDynKMIBsFG1UjeVuLvJg
	ikt+oMm/t1muaYuO4jU8IvRDF5MoA8KGHXd4to+4P0j6r9bbFxjkc=
X-Received: by 2002:a17:90b:350b:b0:369:9469:aeba with SMTP id 98e67ed59e1d1-37ca6843e76mr1031173a91.1.1781668019333;
        Tue, 16 Jun 2026 20:46:59 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:a0b:fabb:5b62:b85b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37c521cac5bsm4446256a91.5.2026.06.16.20.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 20:46:58 -0700 (PDT)
Date: Wed, 17 Jun 2026 12:46:53 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, Baoquan He <bhe@redhat.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Youngjun Park <youngjun.park@lge.com>, 
	Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Jens Axboe <axboe@kernel.dk>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-doc@vger.kernel.org, Brian Geffon <bgeffon@google.com>
Subject: Re: [PATCH 0/3] mm/zram: route block swap I/O through swap_ops
Message-ID: <ajIYFtADxQDq8q1P@google.com>
References: <20260614-zram-swap-ops-block-register-v1-0-6c1a6639c222@gmail.com>
 <20260616123646.GB21024@lst.de>
 <CAJxJ_jhK+zkpjhs3YsQ9RoasKYh+E0NweQci0sPAEY1ne5LmBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJxJ_jhK+zkpjhs3YsQ9RoasKYh+E0NweQci0sPAEY1ne5LmBA@mail.gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AD949140002
X-Stat-Signature: qt7hwbo9wxj44e4641bn8469i3xh51ea
X-Rspam-User: 
X-HE-Tag: 1781668020-124768
X-HE-Meta: U2FsdGVkX19Os6as2GzmICFFsH44bmWxlD9lzVlGI8NUCviH1IXOBA5sfhYfyvB6so0Zd6lp1AJNqqXtRaDH+q/hOFTKx0iLcvZYNWuJXRUpvTnJ+6XFmoXA5KYzgReJ7CFOklX1YLzR9e57h4t0czo5M61tzojnLGGE4ZtvvAQatctgLMDEOgchbzsmYg8gU/VhVI3I/hd2RxgwRhrKsC3Nz08fI2X9Icc0d9WMonx2sVkImjOXVRukN7S1I5W9bAAn1ynIybCllOAhLvmLctqJgk2CtbxNDtpbDDiakVsDrwp26GHx9KQJEBzUHU4yUsUF0hkceKfnoZWuTn9Pb1uz4lc09SaXOSWeb+4YC0cQlP6o76F+wyxtq9m/cvmIlEe0Fov5+z+cw6hrVwfkZLTckQkYO+TPtjJ3DJMNpTKhyMAvgwZP9gFERbKhGY0/fXgckYMO/UU9DPl/OYnedNlL5zU2LLOjKC8zAR2kwjaJ3v81O6EN0bHR+qws6GRRZKGJ2UWTWiy8uomJtUpGkD1hZnlCrirJhJ3mlaO8b0KyQb+t1l1N0ciFatppONyfsb+YLiCNKefmNZUbg99MnS4RjncZ4jpVtRJs1JdfAcrTKe8Fv/vvxIOBu1ED35xCxCDJiiT3g8827yop4A286bphiVqQmENYwLKE9W4U2nqDKF7Dp/VbudnEyz0Yydv69kpJplAA+yrZ8eVVnpYUGQ1ddRKj+P8LJl9oOZ0N8OfwPCx/DUEt4HrMBS2KmOtOAngojIZHzwXJeB/pcF50L9+W/FiyCrabEBJeqiJK9h+SHsmpeRYKb4j8B974DnYfZ3TL62H7QBmYUImBIsGyPaE+lirtOxum5imGS4uh+2F5D637S2rpyduWKRmzh5wHIJBysMOBkyhFdB4RbuTlwZXgVAWObBxC6zj2u45xiNIJlHt+YGNMoqmFpR/K11wUW2FSOCgoZPFG2Q8cNUH
 T41e+k0u
 0Rr3Gyb7ZijfifvJ5FqEbGSVuPd+eqLIAWm6hIKWehKTeTC6PGALheGA2Cv8pSJyQSixD4ah7mYqQ56t/nIeu3AtVZF+EPFP/+hixSgosZ0kVWOaY838rHfHuk8tpD8HqZ4k5YrbX7NVfEfDCyIYFn5QON7T9NVD4dkHBwmjk97rGq7H3QJzJP7sfgJ/CDQMSJ+EI9sP5KV/5MsGq1wkYf3OugI71/Kmy0kM/1BbqSp9noNKOtD/EAmz4L1KpIflNUdzW1rmONnXNBADXgMbCZsKslGxslgrgm4iX04Xtvqp5GTD2N5fsC6mk+ACskr/Q67KRQPXroRSECsG4waJ+VbeQxwshlu6JKMyZhXNLw+9V7YRTaQw1q/CeZOekLlL/DlXYJS6s+uNBc6XKz2GUOpo0WA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Cc-ing Brian

On (26/06/17 11:38), Jianyue Wu wrote:
> > I fear this is going entirely in the wrong direction.
> OK. I was trying to build on your swap_iocb / swap_ops rework
> for the zram swap path, but I take your point that compressed swap can
> be handled more nicely.
> 
> > Yes, we have to keep zram around as a legacy interface for now,
> > but the right place to deal with compressed swap is in the core.
> I agree compressed swap belongs in the core is better, so not only ram,
> but also the block layer can use it.
> 
> Before I rework or drop the RFC, could you outline how you see that
> core-side model working? In particular:
>   - How should a compressed backend like zram or future block device
>     plug into swap_iocb / swap_ops?
>   - What role do you expect zram to keep while the legacy block interface
>     remains: current block swap only, or something else?

Those are fantastic questions, thank you for asking them.
Can we elaborate on zram being a "legacy interface"?

