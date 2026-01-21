Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA394D262AF
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 01:56:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 004D46B0005; Tue, 20 Jan 2026 20:56:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F27FF6B0088; Tue, 20 Jan 2026 20:56:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E34026B0089; Tue, 20 Jan 2026 20:56:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D513F6B0005
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 20:56:56 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7BABFC2476
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 01:56:56 +0000 (UTC)
X-FDA: 84354307632.18.F71B188
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf02.hostedemail.com (Postfix) with ESMTP id 94B8D80006
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 01:56:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="Ld3Rn0/U";
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768960614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ymdUvFBcuNJCAG8vn2vVjtl4hWNvVNAdA3/uFc2LEKc=;
	b=asc2Ct25yAWM3kKQpuZKaVQ5sumKbKSFBUNsvAMkgMPIOL72lt2EPEhFi1fsiVTnm+jP5Z
	dPZcAixohYJwlaiYpoTJtBGnIlSgE2P0I0fhBe/7yebRyzzibC8STZm7G3F4rLCvpHODVV
	L3wHLG/j8pj/vrxxnqaLN4iMdNZQymE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="Ld3Rn0/U";
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768960614; a=rsa-sha256;
	cv=none;
	b=XCBnTaPRJ42NLIoncnAJkmFC0EHEwW93N5IelGYScNPjl9ixvHueQ7Y/xicuIrLFOGznLt
	xObYrn/rQIaWcgoDK9CrULhIRjR+zgZpQPamQhpRqfxLnPcCvT1JgfQV5FMsPY89EAUCof
	F/UptIFcVOxH6AO0WnvLC+9k1TayGTA=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-81345800791so4121471b3a.0
        for <linux-mm@kvack.org>; Tue, 20 Jan 2026 17:56:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1768960613; x=1769565413; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ymdUvFBcuNJCAG8vn2vVjtl4hWNvVNAdA3/uFc2LEKc=;
        b=Ld3Rn0/UvXcgWKM24kO7IBCyCe/Frjtxx6LH3VGokz+Z3nNNSmCLJxTjqzdbzxSCGO
         WDxocVg0yJMmPY/czEP+seb3l8xOJggEOqGCR4xZ32AExNltDao12hY/qo46it84VU3n
         KvK4VAUFe3iuG6j0bXkS3RcIOIXYGKxH4JRQI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768960613; x=1769565413;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ymdUvFBcuNJCAG8vn2vVjtl4hWNvVNAdA3/uFc2LEKc=;
        b=MuIkhLOzSOHq/20RRgqqpbNtBfP3uUTE/oCAHmvI2CDSQ4gI5NNwC1dyvOsXNyeWu5
         eRkLOZUf6hGLZvTqYPu4N5lut2hPwwYwscdit+ZzgglFq030gy//MnJkKSAb6JbZdm8K
         aJPeCy0RHwg93/Zwa7ygWocYQ24jhhi9i4ZXYBhwF9tu3tjtp/+0l4kKMlzqYkN2w6L2
         /lDEvw2zBtcq6bIX9FKwoFctzkpRkjxYqPxqO6Wm8Hbvkcx++eWSZ70GfR9pS01ZQCci
         B9cIY3XrToDjp04/fuElUzIDcu1zTwLaYTDiwnUSXyoPO3YoL9wma5LVSobw0o4P8o8l
         qRzQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+4CMY2pfvA7SIMYpHMrijw5WdzBQkY6G1eimeJqhjce9Z/PEPztjQzSXwb8u9zsKjaSwJKlkR1Q==@kvack.org
X-Gm-Message-State: AOJu0YzElMf//FekpQx3DfAh90FsTerBfyCoau9b/xGifkStxHnqWojG
	99lji7R1YwkzVafgk6/qayNG57T23EnupOBMbEB2tAY2lf+NJdF0M0Eeqg9ysqmY2w==
X-Gm-Gg: AZuq6aLk7Y/Qsd+tRAtT8MrWGbSbTGbb3XzOLsnLt3Xu53wT9lLJJVRNd/8Tfuz5+6G
	XFO8QM4YDEZJUFcs+P4n1c8yhlXHHtuIPvp7JvguXS1ZgAJje7c4NUBieI2ikl9CgHfFdG94gJC
	pozLyQ/sxcXKcoS3WrOvW9P5BPDWQe+/rDd7mU4zedHQYL69PuhNQDvuXuLsHs2q1LMmdkOyehS
	20dDJfXmLnBH/NbVQf82SI18QbF9LyPIm68Tt5ibivY+W0pAr2nhxI5kohyqBLnoRIU/X4u8Nvl
	CJ1srmbUNAG5nG0yGVOTIQJuSKId5Y/yJwiQ8G8iY0Y4EFcOlgZZ8Fjjd0vE37VgAD3oix9eVvc
	kg0+dc4u6IGPk5TPKK2pBn6ygzmg0wIhDcw4M+Y+A3tcq9N01KejgBWrLYxlMZCREMoTHN2XvfA
	GwNXQ8sS53xGUYNDxDAEKpVybNIq0H/LJUDdie7f2dMtQGolLZDg==
X-Received: by 2002:a05:6a00:130f:b0:81e:fb11:96c3 with SMTP id d2e1a72fcca58-81fa184d473mr13401183b3a.52.1768960613361;
        Tue, 20 Jan 2026 17:56:53 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:a85f:a6d:c028:515a])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81fa12b3165sm13179592b3a.60.2026.01.20.17.56.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jan 2026 17:56:52 -0800 (PST)
Date: Wed, 21 Jan 2026 10:56:46 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] zsmalloc: make common caches global
Message-ID: <2tpqaxgslryp3l4wauf5umuseccpkp3z5l6nuulxfiqzrdflsa@jsddpcvarb3r>
References: <20260116044841.334821-1-senozhatsky@chromium.org>
 <z52lw2spqxmvgn6zo7b77nvxyjtxez5nxd6gsn6s3mwqnkvynq@gtd7kpedbtfr>
 <a5jkb4d2xolobcddbac6enh2vjdbi3u6wtwfavo2h4ps2iietq@63nnefjw622b>
 <j6tlqyecmcf7anevhvptoh6lis6hzigencccjpq2j5uy2rax52@fytgstv37ynr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <j6tlqyecmcf7anevhvptoh6lis6hzigencccjpq2j5uy2rax52@fytgstv37ynr>
X-Rspamd-Queue-Id: 94B8D80006
X-Stat-Signature: xti8oj1rt518jacs6qqp1u6u4adxsr7x
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768960614-584874
X-HE-Meta: U2FsdGVkX1+9TUWbWLZWWaB5cMEiBkfH1f0R35YPNZz1ofb1k+5o/4kZLA6GseEb22cWGQk4CSgv8VAdQPSu/7TNwbHtqcDxG2EUQmotb4CrPw1FLFphgptozE4dfZLcz9GbhQZRGmfZOoFIaLI28NQYCEIHy/mmTus31Kj3AAn+iCx0l2eyzHulnCQi+HSTD/IHE7mrR7SkPrCepBjyXElUM1MsAl49GUqCmjDgfTLu0dsOYYE0JiIVW088b9infPSf6Mi9MRdUiaT1TE4Ut0C9g+UOtbYXm4/4veLEnfTEcW5EP+QSQrf+U7aDAKQE8NGavcXVvQXefUmYS7HZe0/NNRgojXlwPxo8mH8RyoKWssWxbOatdgE2h33zsytiCtWzf1QqB7kAC8zcKUhVXhTo/wMWE9fHBchI5py6yaF2VmFFza/w/vN4lnoAAQH4bHkwhQPJRkkYo089iRsHX543E/2gESnublmue7f9j+Kuwpb+nk3ImZ7MHGwBPYf+0v19WCpddbwwMnZCV3FCHMp3dwxA1PaHNepkxxRENfdIp6JquG4nMufneMAnL89gY1LaCBc951CFKqTKlJXDbkG6V64grkk++PPkzXE1Ea9THDNUVAPCGo6MFJ66DZvzX5ar5E0w3LNcAyggKcd09scssdhYdNhaaujOb7qVIvJfupSlPyFRyHHFDeg8DXkWvBMTSLATL+Jr2ik47VHV+N7E5SFAA8BB8isyiG0vlLhWxNZ92p3IqDZ8bt9ArIwCc6tz3C49u1lT1plMixOdVj1Eixh3l6njJwglNYKfh4gdcT84F0ON83JuxSYyaxImBpHAchICT3ogpqERT887yQaibOKVJOMNdRyhi8c3kHyy8y3ZfceHuIu+iskpXoWwC+YpTNmI+infjPiX3n4SzFGSFeJ/p1fjFzcURm98NDlkX5aDW51fHP6ESnDmey08qllkLylfj6Lj3plQkX6
 FQpX1ZXe
 iHMy1RgETIMQylqxGgrt1g7rVKKakBgmT9Z6KjkJqR0atFxjWDrE3l8iu8LeHxqeMn7ftvTYxs2h3gO0jGzsfAducAd8dP0wR64nnaMzi70fxvR6KFn5HJGjwJ3hsB6EVEY2QTmNG5uQe3Jq9DBVNef/R4HApkKp8uxFsDknPpHkWfpy3UcZ2xOavQx9B7MfUYkCSoENIzl4AzswF7tNYoM3xLimMpspuabb/VCm4tP9ZJl7gRnOOq1b6ng8t5wQ19jBaZnTbs8GtAMKnYmnEw+FuIfajEmeVE5YOlWdGPdFYA2Cbxp8krRiTkDUXq0efZnq8B5hcg84+7U/YMbRSP7kym0F0prcIuHbl6j6KH1C4Dus=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/21 01:30), Yosry Ahmed wrote:
> 
> That was about ~20 times reduction in waste when using 32 pools with
> zswap. 

Nice, thanks!

> I suspect we wouldn't be using that many pools with zram.

Hard to tell.  We have users that setup many zram devices, even
multiple swap zram devices.  In terms of numbers - I think swap
zram users still setup less devices than users that use zram as
a normal block device (that number in theory can be quite high,
depending on use case).

