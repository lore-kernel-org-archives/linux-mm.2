Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3553CC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:56:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A5916B0152; Thu,  2 Jul 2026 20:56:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17CD06B0154; Thu,  2 Jul 2026 20:56:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 096126B0155; Thu,  2 Jul 2026 20:56:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8544C6B0152
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:56:18 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 035CF1C18CB
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:48:34 +0000 (UTC)
X-FDA: 84944571390.20.E78437D
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2394B18000E
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:48:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LiqVBGSp;
	spf=pass (imf06.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783014513;
	b=2/Fwk6SckT4d7vx4vlSBzMvt6w2miI/Jteb5WL01oAJ8MlcKMZ9jdNTs1fmsOVQrfFfQfr
	b84XjvO8CXH83eJhnxz58K1KQHAfFckdz2ZS8COLdrz8XCTDSAE0LhzackZotoT8r1wgCk
	gS+iOKVbCrLxWlAwffdUwyQkCeIVFzE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783014513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r1iw1Kf11G8Y2iJEwm3GfbWSG8bTonFB3NcyHNMfkRY=;
	b=C74zmvBkoJSNbSKodVdHUeIL+p+m2DDOkUYxgZlRq9QZ0fAv4i2TMdC2q3zJSAv5w4VrkK
	7+A8sa0iCJ1/2pS7R3NPX/oDZlAlRW7+FcuM+Z4cGl/0c6NJY8/TTrK23cKyBDFO0UXo/P
	VZatZDIFc+lM7sr5I5uCSQVO6Kyzsk8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LiqVBGSp;
	spf=pass (imf06.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5aeb2b17167so859990e87.0
        for <linux-mm@kvack.org>; Thu, 02 Jul 2026 10:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783014511; x=1783619311; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=r1iw1Kf11G8Y2iJEwm3GfbWSG8bTonFB3NcyHNMfkRY=;
        b=LiqVBGSpYT5tGYSQPxtsMsNP7YRysiPwdL4/5Lso9HcvPGZcSvhVg18tbFewz8PZtb
         +p28bDXE4ZaCYnewbmVJjV9AoZ6cuVAw3nTd43tIXvKd5UbDwOlmTzlbTWrEVhDysaUa
         zXhS4bh7wW4l2lwRDHTkDBmbvPpkBfpfRHLA4zsSlwA63fp+ifiKe4fgRYpVYLATTb1N
         Br91MR8sY/tRWvSE8zpVLubwbJjUw0UyBbMxPWJl6GrruDhOhTtZcJ37Su1CjPBPu5pe
         QDwkTXy5FyMyP9BC/UcxNjnYRYYFIEFdZKhsq9XImGwzMkRjJQqFDpsKA4L/XAdjlFf5
         1LUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783014511; x=1783619311;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r1iw1Kf11G8Y2iJEwm3GfbWSG8bTonFB3NcyHNMfkRY=;
        b=qPnWAT8voMhRWmpN7glb/yWPwGSH7tWhtOcIYeaooIOeGblDg52Fgu5J+4p7vTed5B
         SWIZbpWLRrtwOBM7OXpiND/2zVz0xJHvQTXaSjhskyJ94dHm9/pSt0HRQlCXs1RMWrGd
         TdWJZhRZ43U5lOSe8ixpnexQwSuB9WnFA2kFgf9dfA63e/eJq8UIkh2L1ep3xsplIzcE
         WU1yPkPUggVVBn9QL1wTJ1hLpSq0hWKTP1SOyjt5D6p48R43M2IJOVsIg68YvKXfGVsS
         HpTF8TT4WruJfvvi6pVLbmGSWSlgjesdX42/1nlBZpjaIhlxAfILXJjAQ/wxDNRRalNu
         pRUw==
X-Forwarded-Encrypted: i=1; AHgh+RqoQM4bOMmhByX/sFKde90vKVTJVR2/DPRYUmV87N9L0ePWKbl0K2EoI5XjJV267h1hsn8BgALhuw==@kvack.org
X-Gm-Message-State: AOJu0YyCbLT1xpJ3B9vSfSgToPO1TZYHdO+vpp/vQ4aiCyOGdWnnlFRj
	Dtp+Nlyqo+g8HrXW+yxUxgx3D1vejmcYqriUGVAH15jTgAjInl7KqWuB
X-Gm-Gg: AfdE7ck06fp3Wcw4yth2TwvP7PpiadA795JC8K4UdkG0wcZ1lPrvYBAuvrL47tgrunL
	O2IIJgV7oCj+OeyzhbBV77s3q0NO405py673WGBVWCwfuVnKqcGysjjRR4knsWaJ69MldWdqNRn
	NiuigBYZszPGVTfuK/v2fOYB5vinYXERF/a49kvRg3veCYD5wiGZbCRx8BetIZU1bsYIuMUSfxI
	R28H94dDMu5nsVbAtEuuXqOMqHQreiAw8y4om0vXm6M3105d9yh2/FLZAGa/QQEEb45vfWhmUHb
	2h96hNDVI4DdsXNpw1fqMb+/fI5NYyQPobgCyNItxyZe6JGFzIvNxqV+ZTsAAMAlwujynXLKLYz
	2aeF4sDIMcahSkShbzlytvsj0vaQIIynCeIkp8PQMd0AcXRE5S03q8LJF+VZrgfG85DWi1ptcL3
	YB4vEOKHGIwV865OkbVoHBEA2/JCoNSY2f4PotCF0CBaPlupW6+MnFHw==
X-Received: by 2002:a05:6512:648d:b0:5ae:b6cf:c745 with SMTP id 2adb3069b0e04-5aecf4dcd9cmr163318e87.17.1783014510420;
        Thu, 02 Jul 2026 10:48:30 -0700 (PDT)
Received: from pc636 (host-90-233-199-119.mobileonline.telia.com. [90.233.199.119])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aec89a16a8sm823845e87.34.2026.07.02.10.48.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 10:48:30 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Thu, 2 Jul 2026 19:48:27 +0200
To: Feng Tang <feng.tang@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmalloc: add alignment info in warning print as
 possible failure reason
Message-ID: <akaka3D3IC883O5t@pc636>
References: <20260702112610.21589-1-feng.tang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702112610.21589-1-feng.tang@linux.alibaba.com>
X-Rspamd-Queue-Id: 2394B18000E
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: mz8qfh7sowtfbncw96zuqz7sbbw6ubkc
X-HE-Tag: 1783014512-238291
X-HE-Meta: U2FsdGVkX19jvDKCRR8xZiTOxqYiQdVSsZLcYC7RoQ8iba0Wt9lnTTVsgqb6kX/ti0BUv9vxb6cXTiIiKXakL9dahgzzrLkw9pkapGZmIMA/UpCjPBPbgdHgHjxIQIqPZWJMpNWap1K594X4DnjNorwNCAGjkB5lBbBIvHxIsE5ZscT6wwnKSUm2AkQw4Lb/P4nHjuwVq5T7oZD1Xng10VDF4VB7gaZ8etTR028YyOh4eD3g5LY6mDJFauDCcTPzkvwmpq64E0cXARz2qETW0A1ji3LTaPsZSYjgZYzrZotEmGYnT2nOJQG6z49fKspa+8oNBdo0Gw+heN4boNO8aCotqWjFxRCdypciV7yu7xIqRijYhuagmtgG4ocBxzGRYSkELZUoiAbBWiE/speaYu4aH1Ki+ctLOezPt4fEMf9PKUnTFdlFDq2i/VrcFs2yPZm8zIVuKJwZIebzyNYLwRF44j5gZbKN4n4EevQs9LaNfgfy4wZP6JA2/fqzL1rJp7W+kqN/+WuTO9ziwp2xjGHv8HEIDaBvWLRKAHsQr+H+ITp0v91UYYVG0s+tK3yRqEiKffmOwo8PEPNMWwQHboVmBS+7w+8U89jJKHndbimvQ9XowdDfGOue/xE7eB1nCnEN1lAofkVV+noXrybwqxoCyqjXQvBbTqdjzvjGl0qJ2IO0zHYXaED7tn8y4CUuHwFNtAsogSasXMNykKDpNmPYbTwIp3oS6qSPFnXzu/zRQNbpc7VR09qY3nUnj2lTLuAYd380mofF0KeaYppuYE1oLhxdjafI9awhfuGAGDNsxH3RLy49P9bQbqy/jBXFmpPFY2rR1qydYJoSrvVNJmuxSECGDZ8ffe6RGLUHF5/JPm0/YHyKzgTsIHFH0WNEclX7MWwmIK/2RSqCoBrSxyWpZ7VOnHwbk/jpZ0a4XUpj3EvGV3EAdEKLZpicxJYBJq6owHv88FeAcH/DHs/
 hYxJH5zq
 NHbshkgVBulzUAnoEVdAzKYoFFO+wgIKFwKQTAiWaZztgZ+lHXQfbzMPh013vZQdMtPSjJRwFRX5O1y8MhwlTBq+jdmoL8VB0zlhtdXyD1W9MAU6+OnPGVG7OhLKo+ZfjsaZKf0RHfUF3gItXaw1vtZwWVXRaCOtc0cm63TaQXxq+uJ5qxta278riKnw4IP1yCRVkHIUKIAMNkhOMynSaTKidYsf+fxAeRn0eFVT8k4BL2j8c2BQPPcEJJYXBsTXDUtVWTICEnEdk32E1OaL5KcEw7N4aWHCwLYazbCTX09nrben7QmtKrpNHpcvUVNTFZzkWrG417S8qXg87O2QDY4NLExyviRSbWY4UC5jbW6s2xhNWLyViwd/OLs4gl0p0nZoX/N/NhsKhSymI/6uzO4xlEBfwsKBlmaG1bbvvHWJYbu80H8xvKjXn8LlbWHoi6JLftp3LlAxeRawRNqG7DQ7666HmNoo5WEdB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 07:26:10PM +0800, Feng Tang wrote:
> When running 'fix_align_alloc_test' case of test_vmalloc module with
> command:
>     insmod ./test_vmalloc.ko run_test_mask=64
> 
> It will fail, which is the expected result, as the case increment
> the alignment parameter gradually to 64bit limit. And the dmesg has
> warning msg:
>     "vmalloc_test/0: vmalloc error: size 4096, vm_struct allocation failed, mode:0xdc0(GFP_KERNEL|__GFP_ZERO), nodemask=(null),cpuset=/,mems_allowed=0"
> 
> It doesn't give the alignment info, which is the real reason for the
> failure (not the 'size').
> 
> Add alignment info to the warning print to give the necessary hint
> for possible failure reason, and the message will be:
>     "vmalloc_test/0: vmalloc error: size 4096, align 0x800000000000, vm_struct allocation failed, mode:0xdc0(GFP_KERNEL|__GFP_ZERO), nodemask=(null),cpuset=/,mems_allowed=0"
> 
> Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
> ---
>  mm/vmalloc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 1afca3568b9b..e066324dcc76 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -4045,8 +4045,8 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
>  	if (!area) {
>  		bool nofail = gfp_mask & __GFP_NOFAIL;
>  		warn_alloc(gfp_mask, NULL,
> -			"vmalloc error: size %lu, vm_struct allocation failed%s",
> -			size, (nofail) ? ". Retrying." : "");
> +			"vmalloc error: size %lu, align 0x%lx, vm_struct allocation failed%s",
> +			size, align, (nofail) ? ". Retrying." : "");
>  		if (nofail) {
>  			schedule_timeout_uninterruptible(1);
>  			goto again;
> -- 
> 2.43.5
> 
Do not see any issues with adding extra information on failure.

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

