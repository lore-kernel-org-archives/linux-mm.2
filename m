Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBD19CA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 14:46:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC2096B0024; Thu, 21 Aug 2025 10:46:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9AC66B0026; Thu, 21 Aug 2025 10:46:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAF3A6B009E; Thu, 21 Aug 2025 10:46:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 967536B0024
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 10:46:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E7309138713
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 14:46:16 +0000 (UTC)
X-FDA: 83801039952.23.777EBF3
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf15.hostedemail.com (Postfix) with ESMTP id E8D85A0005
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 14:46:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GKZywSEt;
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755787575;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JIG+w3J97fChnrmJiRIedihpzfaTzFXkYAGxoj1msbc=;
	b=Qx4y7226XZN1yu+eAcnSzwe5IknUZw1RAaCKhIlzqFz/WmkEgYBbog5wN0NjepzXelwM0e
	gUcijYNjGkfZqaC7UOzhYoGJ3ru2aCVuB5VjAV+wKgR2X6ua7OxWKSeXCaiedvnbjIYBYi
	Fu2kdwdjV7OLZuAF+X7PaktFgq2kh/Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755787575; a=rsa-sha256;
	cv=none;
	b=FKqSsen3MSxPX7eDP05nGD1DzJ9e15FwKLDxFA4vjDjM6+her9cf2cVep7PSRHnlBhOhWD
	CI1fLMnRfw49+DfzT4O9lKNm5uyhHwMfA+MyPHxf/nye7vz1b90aMrdYQnTUlEEDoxCPy9
	fA8QgmuL+5LzatLD1W/WaK3HeTxJA4s=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GKZywSEt;
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-afcb78fb04cso146794166b.1
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 07:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755787573; x=1756392373; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JIG+w3J97fChnrmJiRIedihpzfaTzFXkYAGxoj1msbc=;
        b=GKZywSEt67ehSBT312YZZ9kcSaeodW48jjcpMTEyMOD5RFHXhuuNNPBtSU+uGLsQXH
         GYXogNQC/RQf9YYl55R0UwSBfU87NwvOU1KKb55gIea08YQh3sy6NSju8vf2nyQlxeqd
         D3MCtgOFzg31HNeUbUBRpJr/yP6s5iKBRrIOtsFSeEli4vY7CkP8jNvatdKzc0aQmJWX
         0FnNebR6G/antCHMX9XWmrnP6lgQz5oqVsXikRxXHyTTL4l5p0tP2BcHD1XkosaSQcFa
         ip1yeO2swohGu1+snHi5pD0WnPVSw2UTGkORsCxVCvkHYaA2tvruzECFGuG7T+9JzuIf
         MbsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755787573; x=1756392373;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JIG+w3J97fChnrmJiRIedihpzfaTzFXkYAGxoj1msbc=;
        b=oJyN3g1xgDOOa3Ioz1jAPxHj87rGpKx2NmUtqSiS9ODWJdMy1D0PaZcKxFSnvwlQwI
         N41xjPJTSkN9dUR76KiHadownzAdoBHRouuPFEMy6+XVx2kFqUauttJWtpJYGYFIuHph
         /D+s8MdYhLHpycJnte/f0tuvU2AEn/Qaa+/X3Rc6B63roZ0of+gE2ecfeFX6W/s3SoHB
         3hgGlumwY/gvXTJlvX78CwQqm3tTzEeduYEDNR17xKoWpiAopPihP/reQyxlxPMB2rx1
         cUJYOiqXdi5Yppq1UwsEtGi6h2DPW/GbKiqLEBBn38uFckVyKHaTca9mf8muG/JGZAuv
         bzkA==
X-Forwarded-Encrypted: i=1; AJvYcCU0PbOChZnRo6FCnzj1YOmNNofRShOSPhuhCQoQS6jpQdcZvyj6quDy4WqGa8WUtaioy+eiGOYEkA==@kvack.org
X-Gm-Message-State: AOJu0YxzwSvXVcykFrEbEMPO3YTbBnEiC00AxfcBVd7NHX9DQOXMixm/
	EJRuxK+XG6gPsSHEvU1Ma5PpjribTyvHVUUPljVEzGhgYJRMUknFGB+a
X-Gm-Gg: ASbGncsF291Hgu+G5mIvzFl5y5zdclEMQUsYwBOMEUbDedoY55SAJn7Naw+KMrUMl+m
	vzEBq+Us/nqTly5iRmMave9yJMfYFrGwh0ranEFL/V5xsN2DbS5ri6karyWhxy5RrUEc1BkcEjy
	XLgfrDjwo+0XThZGLsmlGFO/ypQMGU3Qfdl/i8GYjEG462JUNfxZyBmVp/6JqGsDxexRbyDPZCJ
	AYjOKBzAU9kG7lYvEUT4jO8qAr1/fo/vnYyAe0jlis138/7cIsMkuNmWWRP5Ju5c3BR5KkzWeRk
	ZY1/lH5sUrJzgOOKSrwDXJEm1BfTdWek1c7+hBmH+S88omLyeIX6zCl7Iyi9zHk78DwyPgUBP4R
	QZtPQC/hzADXVheTaeT6541Lkk1H2QRfD
X-Google-Smtp-Source: AGHT+IGLVuYVD4/5frXWAQs5H5qLefX8r3lwrN7PcOc+bxumtnjbgdiK8HV2S0+1muwsZBsiec73zw==
X-Received: by 2002:a17:907:1c17:b0:ad8:9997:aa76 with SMTP id a640c23a62f3a-afe07b96fcemr266557066b.37.1755787573131;
        Thu, 21 Aug 2025 07:46:13 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afdfa887a90sm289060966b.11.2025.08.21.07.46.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 21 Aug 2025 07:46:12 -0700 (PDT)
Date: Thu, 21 Aug 2025 14:46:12 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
Cc: akpm@linux-foundation.org, shuah@kernel.org, mic@digikod.net,
	gnoack@google.com, david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, ming.lei@redhat.com, skhan@linuxfoundation.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-mm@kvack.org,
	netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: Re: [PATCH] selftests: centralise maybe-unused definition in
 kselftest.h
Message-ID: <20250821144612.a26otz2yriqb5gdq@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250821101159.2238-1-reddybalavignesh9979@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250821101159.2238-1-reddybalavignesh9979@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E8D85A0005
X-Stat-Signature: u9ijgjozttnp98q8fea4oo9a8yfrmcsr
X-Rspam-User: 
X-HE-Tag: 1755787574-963432
X-HE-Meta: U2FsdGVkX18keaTHSIaxKqSTZtoL+4g55ECVd47LHofNxPz7bQtuzYRalWKVSGwGXWaZom9QdivhlG2mO9xtLugXAocSamxuHJuFseJOlNOsKS0EnZOLsUcg+na26KujYQIbVwUdz+M3KZwKguleeO8wPwUVAjBaSrM8Wor0HKk1SZC8Asctz2H4Yf3K447SpOErht6j4ZdooSOvn+BXUN/cVHOAikNlTivTFBuNW2L+BTqRFok2PRDxTQahQ4Wqi0rWFlTDqaBgB5owQcSpxEC81QSrkXrxDFZ8MWnjAwhygaID44i/ZlINF5qj3U/cLo4FNspYhNJqBHvVyVTfQ3hfqcGbRdNA4aPV44V7whZBFJuPAhi9a0ChfIRS542gsLwhFrbfIaCJ4y3ytySBUd3wf2pFpeJutmXk/zSqO6q/y6Fmun69G3sFKaHAPVD9nN8jAldqbOi5wRwfKohTMUJpDP+YhjK09lko5VY8Se1hyy9ZCJ3y4ojhO3t1i8pirvPYhaniIXR1Nvy12/U829p0jZxiHJw8c5TdDnCdmA+f9jLAS6Bkf8QjqWfTvjey6qusMwONhJ4q+j2xX1Z9D2DVNG02NhlEFGzlvA4TLYReNpoZYxfxhBEw3RO1lXGUq2sQb5rNdF5cpr72YR3vWIijg6xIzzrqUfy6v98oJsrfh0m6JDvcY0wzKDJAaIkKGjQqlliRNJ6v2HEZf4PiweoIO0wiqGgqAf85iUfMvYRI9+ZiAAv46mLiBHFMrnvArWkGkSPPfxvaSRkV5PEiYAJjqksuAs1HCiqYmxXxE7BtSA8MBCcxF68RLg7M3stvAiKAlKe5/1UbNLRMdrW0yUBRvb/LiGyRANxfSi1uogoq3BBdDjJ30V6tlpJx+wes1F4+LtB3ZJKotZNu0iI5GMwkux1YFwGwrc2f0g349YDzC6CLzcLpQiMuq6xCUl/Bl8232sMqfYopBDRecbR
 gsYmYnRw
 umqxbIdo9Aec74K35S/S9GyDeAZspO6jNoFrJJiUmJdpHYBq4X9J0kDHdOTMSnJ1Rv2c7WcBKrRI+vVJDWi8wTWqcr6jjjqFogAwxLcI8EldI/rBhzsqWD5HDMgr8nSrl9ZThqVmX0d23OML5W4Q5Abcaktv7RZmGJv9l4BE6IpLhnCO7Wko9CogDbqx2Okyrz91JH/wczl1XRS6Rm3QSKV9HV+g8373pgySTFoGk/LZYFstNewedoRqKRP1y15t5bAk+OgWpZQ4JZbi++ZW8VayDQ3ZSDXmbmElPFLijp1AefnLJQQ42yxeNXH2ouLsAAMAA6dWSdJ64105mKywrYUYNcm53htea6f2O5oUy3PWlIXfxfClJQsi5zxRYdvIS8/V9U4/SKdQCkHIyIZ2NF+HSBc5hx8XMos5WyxUgQZqJUHqSpy0ut5EfyhXJgJQ1rCEWapGiNFERxdxBfLXBIlUNUEu1TloIykTP+GSk7tcM1HIeiOSHXI7GhiwknHtF9zbreKkqW95uCQGTpvrI/7+2JpNFaYpSqZ0rmeCgEkWOaeaADAuelri7t6soUlFj6Mvb+U1NVAxIxAUYnr+4KKHQGIeTLeTjYWcUEBEIHYoZFmSmsE+hZBGCdPrMK6YS3Cq+AhsSOJxC2QUwR19Qokk2NgOhAqxg0bkfn6VKNb34e5qrROLkcEJ9wCW4cKhLvZfA0+tNZBK7SM2oAHZ3gIHUjx9o+ox3ejmX4i80PUpLSw2IKzIqQHXEfA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 03:41:59PM +0530, Bala-Vignesh-Reddy wrote:
>Several selftests subdirectories duplicated the define __maybe_unused,
>leading to redundant code. Moved to kselftest.h header and removed
>other definition.
>
>This addresses the duplication noted in the proc-pid-vm warning fix
>
>Suggested-by: Andrew Morton <akpm@linux-foundation.org>
>Link:https://lore.kernel.org/lkml/20250820143954.33d95635e504e94df01930d0@linux-foundation.org/
>
>Signed-off-by: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>

Looks reasonable.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

