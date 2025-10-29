Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA814CCF9F0
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 16:11:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A17A8E00AA; Wed, 29 Oct 2025 12:09:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 777178E0045; Wed, 29 Oct 2025 12:09:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68D2E8E00AA; Wed, 29 Oct 2025 12:09:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 40C998E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 12:09:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 032345AC3E
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:09:37 +0000 (UTC)
X-FDA: 84051637236.30.3E704C9
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf26.hostedemail.com (Postfix) with ESMTP id 15F29140006
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:09:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bn7pTQ72;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761754176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cdh/X/VV7mkvnM/eGAn9dAekn5PCJt3dAFaRgWAOZJI=;
	b=QhVTy2Uh+Oi7QvvoOs0G5hnOn86VlhPN6S9kqne/OQTJs7TtvOSZwbo+iD9nJCikZ23ui2
	NeVLMUDb410xZ7AcyZDBuN+/7R+Nns3mrEMRVj/l/2pRfX1H/GMSIrjx0p/HmF73fy6Zv6
	PkL0lGkS/NKMV1IFF17PIaJrG3JobtE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761754176; a=rsa-sha256;
	cv=none;
	b=rEFGEGzYxc/fn3CeSFcFR8flSL3tvNUrDm/0Q+9T1MYkUiKF1/1FUS7z/H7E/LEnvIJKiq
	n3rb+EJjAl4NIfBtQ8rNO5q9JKgZJOh7rstYml2e9t9KyCURbOTcRe0rWhBiqdrHDwNA3H
	j7yh980SmYpOkYV+BnuXBMIsQj1X38w=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bn7pTQ72;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b679450ecb6so5641777a12.2
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 09:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761754175; x=1762358975; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Cdh/X/VV7mkvnM/eGAn9dAekn5PCJt3dAFaRgWAOZJI=;
        b=bn7pTQ723HeOszaUjNPzCRUYZDDEedzpQ/yRFmNZmhFaXFQDEB10K5inviQdFimBIR
         AUI4hP6AVLrivkTtscc5WaESDkbUenv1FvHc/JJlkIvC60Vze+rDkQTdCjrXajvgVT8t
         N7vnvpoF0yAsNFBSTJo1LdaXsjmpkNXIfjHKNmrEgJuvASB7mdpr24zOwgCTLTxv5WfO
         oNSzNSSqhIVAWlNixFmhQgsVNdt/TgHEY4HbD0tQ1R7Yye6Y9HNxmLrIZziyzD4wWjAZ
         pw3wGiCrM2Sr5/C0WiLoKaPGuKvWA9UTeA3FPDodpV7f6nrve6BhfNm61seNe4l0bhfP
         oV8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761754175; x=1762358975;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cdh/X/VV7mkvnM/eGAn9dAekn5PCJt3dAFaRgWAOZJI=;
        b=QupYtC5t6d9XO5JlEwYaU5jpCZts9wgRf49UVYadlJazIGEYQorSbWJSFCwRpSu6/p
         12XOaTimE93yXUhsnbL34565SijsFspICUUEO7mHBddruS85x5GmKyPgCxcc9mJ0zkWm
         qFkDJMz0FCP5y0bNJRyfD2m8F/6d7ctS0cxMJDFs0qagJMv/9hfchvr7rKvatUVQ0raA
         KdIZ3cAMcAg6JDE2OCHFJwS1++hhbiWTeWrh4iLuU0cIpwv5ZVj5mCce/y3myeDzOCSS
         LoVtwIEYfmtNiJ4V0BXQEtIVvkGB3eKVzaBjEdx84AXar0pasUaOv39NU6KRGDJq7B+Y
         ULIQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJmeF6XSTlQ5SQ3wBTiLiXWNRf/K6Kut+3zaDBqsMIYqvV4RLBSiixykEpf3cSe+AusQuZk+lkiw==@kvack.org
X-Gm-Message-State: AOJu0YxzAWe8Aly//otV0ph5qBTINZ1fmJrfWuj37EIxo4bb6l6bQQW3
	ylmvoR9ec8np0HPJa6EhZwR9eCET4Hj2fEyNPeeVcSdQqiHkgMXo+hxT
X-Gm-Gg: ASbGncuzUEHnFzR84qju1I4BXxuENYl8S+X/fQizdsfimgkFALiVGtNMdZxrHVbso3J
	v8za6qygTUjmBRkRa39S4/Vu8ALYdbm/m8Bx/lXP3jeucAiSa2aHikCkjGU/EUi/jmaY7+xA9x7
	fr9GZ0wXnHC96gFkiODkhRUibQcBdWONs7EJkKhAFdjxHd7wSzN0xBKkA/7Sq+1e++AOe4Yz2P+
	h8nY/sIpJ36AG5jsZ2csqU1/r94aSHS/Q57G5JwkQqpyH+rpkpfiNtuFqYofUfv326/AEJCpnCm
	SFJ9Va6SAXSE4TECk2inKagd9aeLL84ZqjG0oCEBQF+B30l9q48thUJS0RuEL1B2wsqemlybEPp
	d91rUeJG9Gev4pgVVYSh/6BjcnRvAjbWKFi1KJyQjuyK/YwlMbDwDL1W29i3BZlKXSOhwWTUtgj
	+451XMRHJO
X-Google-Smtp-Source: AGHT+IEK1abrEbHa3Yvxsi+vX72K/QFmnAs3oTv1YT+299kSHq3dyQnUOY76bUzwNCz2X1kzl+sZ6g==
X-Received: by 2002:a17:902:fd08:b0:294:7048:65b with SMTP id d9443c01a7336-294def4eaf7mr30184625ad.58.1761754174843;
        Wed, 29 Oct 2025 09:09:34 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498d29acasm154316045ad.64.2025.10.29.09.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 09:09:34 -0700 (PDT)
Date: Thu, 30 Oct 2025 00:09:29 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Youngjun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com, 
	baohua@kernel.org, chrisl@kernel.org, gunho.lee@lge.com
Subject: Re: [PATCH 2/5] mm, swap: Use SWP_SOLIDSTATE to determine if swap is
 rotational
Message-ID: <waqpfeubqf5sp4qqt5pirwy42rmtb2ld4d3263tl4nlf677rp6@z6va3qr5lwfo>
References: <20251029085659.2005942-1-youngjun.park@lge.com>
 <20251029085659.2005942-3-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029085659.2005942-3-youngjun.park@lge.com>
X-Rspamd-Server: rspam01
X-Stat-Signature: hnb7hu44jiwowt9z5bfb9btwjt8zjktw
X-Rspam-User: 
X-Rspamd-Queue-Id: 15F29140006
X-HE-Tag: 1761754175-607788
X-HE-Meta: U2FsdGVkX1/Rsf/qGvomd7JDl3NNCu/5cv7jhi9iG8s2nB7DAlgZs8w6tSDBsczGWpB8H/eeQxbF+ZsV68TGi/ZjjI1N8Xpa+IAs/nxhNO1oQebIUtAEk/RX3qazlHd7kBvDjlsLVW0pBqF/nuLHOdFPyAcHPaPne49eOQm1A4SxAtv6l6CVptVFsU1XI+mqstbcoZjDbwNEWlCXvXs58Jn4sP0WpUKgyzcd6ooNX1CMyd7tMnDQE5BKI4SfS8t7/HX6CK31DCNF6xY1+rmlKZNA2Xv9dBQwYy/CGhaaLlssEKijkN5iXh4BUx3D8M9sai+XKaF7MbM7rdvocCV2CVBJv+yteqpkxB4rRpqpCTZDHTwsyRd2iRcaOZ3t7Nk9W8iefyESs/e63aVgO7j3ZsrlCyBETOkX13SYApN79fXBtfoGJ5MbeB0GqN28V1JL49RtWWAcqujJWrYQYvc5jTkVTxQt+AlztUQ31DPOM48D+CVhB21VOX83Gy2Bz40HdBWs8Ty9JoEg6LJBwVGp+Q2KBNZb7mTROR84KG7sgkh85XrEah+a/FhEz/pGUGJSmSPRjYoBD77jXsue2J1pBDvBwRedmJ1to2ZjB5c/3vsBE1KrVFrWvpeCKx24Hn939a9+ivbyMCQsZI5VNjv/moRW95UUX54qgdKuiNqeoiBlW1gfRwehOZFtLRvBFiMtlhm34xcNOYEGrbDZzpTo1A2jOjHhjUdkG0DHOmEfNso++52HHotHlogamXnG4425y9tuB/Mpea5B17pbyWICMMmARWZQc7koLafpPCFj39Y4YkfiHSnjMZh8GOEang3yZk5XSFSskmIJFar222Fn7KmynFfI+PN5KNqa1HyKXcZsXgHVNe6CEbrZjDns7N3ZNzEXbX6oQGx9cXRrQo/y8s/TSOd1IiY789qZP+XuIwEkqSoRS7xRdm3m1GT1WTj5p6mbFiXhN80UoZU1HzT
 jnqfikmV
 g+6Dm+2QssD06RjAXQ8g/L6SmWsNTwHIuS1xNNchNtYoTs28va/yNR5nKfSj63rhOhs6+ZOMRx2+fZF15gAlg8n6P7NzAnXaQocIdMDYBOYUd2z5aL1fgdyxaVutwS8uNtUWjBAybxsDWa6hF3X6C6c0MvGFjxPk0TN14oaRHjkNzp4s6ScwNOc99jpLANXgvQ2SPDlYuyToO3ytswd7WNLxDPAzGWMz7crLKsHtSMibqUoNxb1RVgwcDDXHoil/EpA2DP+MQ+lTJuG8lQu/FTNGZAIWtIDjil1LzIbT4u8MV5cB505dHPs8m00/alylD/hii2O5aVlfCv45sfC5LS2ImuEy+4YHEHg7+G+VUxtE00AEKyr+UFG0BbAlLj3dzR1Hj+nqQFB2Uhf9pCW6D9ApDZ+PE6zAolDmgfkuphuAVBUVUV5U6f0JDYLFT2SKFqYVlbEwf7ZojNe065iVp3PushKoRsDw36rtN5lymOz7cvpbfinrlPZeIYQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 05:56:56PM +0800, Youngjun Park wrote:
> The current non rotational check is unreliable
> as the device's rotational status can be changed by a user via sysfs.
> 
> Use the more reliable SWP_SOLIDSTATE flag which is set at swapon time,
> to ensure the nr_rotate_swap count remains consistent.
> Plus, it is easy to read and simple.
> 
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> ---
>  mm/swapfile.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 6dc0e7a738bc..b5d42918c01b 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -2913,7 +2913,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
>  	if (p->flags & SWP_CONTINUED)
>  		free_swap_count_continuations(p);
>  
> -	if (!p->bdev || !bdev_nonrot(p->bdev))
> +	if (!(p->flags & SWP_SOLIDSTATE))
>  		atomic_dec(&nr_rotate_swap);

Good catch.

Is this introduced by 81a0298bdfab? So we need a Fixes: and backport to stable I think?

>  
>  	mutex_lock(&swapon_mutex);
> -- 
> 2.34.1
> 
> 

