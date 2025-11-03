Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58453CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 12:57:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45BC08E007A; Mon,  3 Nov 2025 07:57:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4333B8E005E; Mon,  3 Nov 2025 07:57:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FAC78E007A; Mon,  3 Nov 2025 07:57:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 158948E005E
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:57:08 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B77B2B3AF6
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 12:57:07 +0000 (UTC)
X-FDA: 84069296094.12.205C4C3
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	by imf24.hostedemail.com (Postfix) with ESMTP id B34B3180013
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 12:57:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Qqq1m4dW;
	spf=pass (imf24.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762174625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ABjcrw89jAA3Q20fdppeCXKOEoaWX9Ww3g8nGLhqb0U=;
	b=XG4d407uBkDE6OU53R3GjarlNPfhYhCMqGjyasklCvhVU3vfG2XFRXp9SigScRaozWFAxk
	lNYSSJieAKJFXHE04/IYEuHftS0gd5n+Q+DxiDSHm1BgVM+5HSTNONa6WZf5w2HmovtXSs
	SO+ZWLn7pff6NXYsBEcMmz+CQ96UZsc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Qqq1m4dW;
	spf=pass (imf24.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762174625; a=rsa-sha256;
	cv=none;
	b=tBMqO4HjSWhxUmYI3Qmofr3Z2dOMs/t57938q28ukomClo5zxbaCQwxadeJPmSDwCjIeme
	OdSfP+ud/rVpuaop6l4KRwQ39q21BbR2GLLpajNGAo04LctpTpFKowltHIMJ84eRVnVuzO
	0BmHl2wJboOc+v08rqOWbFUg5KhISgg=
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-378cfd75fb0so50718011fa.1
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 04:57:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762174624; x=1762779424; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ABjcrw89jAA3Q20fdppeCXKOEoaWX9Ww3g8nGLhqb0U=;
        b=Qqq1m4dWKV1Lfj7Nm5CdxLxHt8b4Fb41/uA2syPSSZVpEbXmqOo2tXI3d9iXefAz4V
         J4k4SAHMopSjQqd2vVaL8WWq3vT+hJPnRjpKQh6jyX+nnhgV/o5mDFvlw8i4ua0zdav1
         M2WBooO2/V6qtAGh3PTYjZVoi7rc4TrKO2Zn5UKQx5XS9FdCRV8/OqEA/SmnItbeVg66
         ibYNpak6L82Tk5lS8ICVpIwfHqgo8F1CZGiN8KxChskO/MAT4s529i8/sK2k8qOjfKHz
         0xEZXsqyBHmQzeDBa3+21kBA9KslsnbwwEWROjKuSQVHpJYAzGU53hUOQcJOTc/g6pFS
         vOyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762174624; x=1762779424;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ABjcrw89jAA3Q20fdppeCXKOEoaWX9Ww3g8nGLhqb0U=;
        b=X0Erb1Zh8KXBEiSCltzCdY/FxLOg81CpexlWIMdHSlMUPnn/+/LX43gnDQ+Nch6JIa
         VbRIN30UE+oZSL/tJm+CFAElvbWEhD/O92eh0rv/smnQ5SItNTi4Xbm4sCN+EXd1y2aF
         HGv/M2erIJQcSODKjLMQOwVFxoYNdjAZWkdHY79L8xJvy/O+XVYs5+CiiYJacHFitkz8
         YWhKb2+I7RYscJQk0I7RxuKtlA33l1nqUZeFS9EUBb/LprawEcd3fVKX8v2WQWiOy9Va
         j+JHzbmClA+5OBg1rzMozRLMaJCOKrkmeF7GO5b5wIZ5zgJ6EABb4jJ9c4xPGWGnHcMI
         FRRg==
X-Forwarded-Encrypted: i=1; AJvYcCUOwjszG0lfHaOBwrsd+Tmu+9RtrQqe1shdCUTxL344u06D4J+rWZczDgYl4vaApzyv9l6k2FTOcw==@kvack.org
X-Gm-Message-State: AOJu0YyZGZUS73ifsDBovNb30d8wkg7zmFCdo+uBd3AnBeHGQcgtAX/Z
	DGzdoOwyNl/Cmd1yNgl8ijWR+13PCcGP8V366LFyiF+vv92+y15n72Aa
X-Gm-Gg: ASbGncsdIWDPgXawS1nhH+BmDs6b17NZMLVlo9tsBpkZBXDA+QPmHmp+NclkLurZA1/
	mF5TfoBbZKq6fg5XvMc90Wc2OLUvD/J6rGnBj8Tj8WCFFiqs3kaiIT0iA+CgEoqtAdpQGATSaqL
	it9PPdLRq6SES6P2HXPlr0KgfTN2wIuO4bAJWXIaJznbE5WuyGjmt+F54o0ZKDcCGTHvmc3qYhG
	ZRK9SqAxtsfCOVBarkMPSdFmMEuSqqRExbsLdA6ex6URsk0t6LdK730hhWCqZ4sp+jDpW9nnRMv
	9xdu9uKRTJp6ahrgimgQiiqYfLo9pAsnTx1ix3AL7g2LR83ctCho95dRsoco971FdNOeyKkeSpn
	sw/quQLzh/iH/lXnQYRZqPaFdNK4akMQ+YIKNzLYuew==
X-Google-Smtp-Source: AGHT+IG4xzdqhYAc4R6V0PORR3naINtbpFIeJn5oDtyrwDfJWC2/RhaLJmIXtOn0jpFV5tRicG8KCw==
X-Received: by 2002:a2e:a542:0:b0:37a:2fa7:53af with SMTP id 38308e7fff4ca-37a2fa75c90mr17228221fa.40.1762174623533;
        Mon, 03 Nov 2025 04:57:03 -0800 (PST)
Received: from pc636 ([2001:9b1:d5a0:a500::800])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-37a4167f286sm276301fa.52.2025.11.03.04.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 04:57:02 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Mon, 3 Nov 2025 13:57:01 +0100
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 0/4] make vmalloc gfp flags usage more apparent
Message-ID: <aQimnV815XIjV2JT@pc636>
References: <20251030164330.44995-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251030164330.44995-1-vishal.moola@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B34B3180013
X-Stat-Signature: kk4fk7gggxaeq4fgcxhxyrowxiqjczjn
X-Rspam-User: 
X-HE-Tag: 1762174625-762316
X-HE-Meta: U2FsdGVkX1/2oAOvJwTqlP2RkAvzEPFRBR7NxLvnN6tJYiE6N+1BCbw6zzCw3YGfYrs8yNa7574CStBS7EW/gqZJne/Xj1zT7ImRDncuMRlYornU2o1rvFung35kWs8UHxA3ueg1agYy4FFzwrdcFLDTOUGPCu0nsQgy8lcdzEz2f3P6Z6r5kTSicE/eG3sPqQHauxDN8nFk5UC5Is2er+jJHEZ4uRk/pHaPz0UaXQWIg8dLHPeDVt4XPMUuwWHKXlvTHT2gS8yN0oUg/ojESDh/s2P9iKNmw9RgBcvPvdewo1VK1ceQQRe8K9APxTIR9KNGQeB0JY/e662lCUty2JFk28dyxl2zdGwCYXgcXRMT5sZ2e5/n0URerwxg+VUpaxPUXMGrJt8K2OsRj0bP1fnnEkgXiKTpadNOBZL9mb3VrtI5ltleRWMcXM0QJRwEoHRIlRhloiFddD+qpgO/JazY5EycwRwcCMi7KsLVSYu2UvFq43ssIP69GHdcytHa8JkbfwyBpv0TubZfEDQb5j8ww72EjTUeQgVNHqHzE9ibQEyyN5NRb6UZGbVCGqHDDDgY8HwLzqqptWlzHtQn/cHhfVTDwAvsA6F/7Pw2Q4/y3VFBuIJ/6QW2LlIPtpmlbQAbCohxrVRHDMTHxGadEI7QnvVKD3l5AWqXIbn2FvU5d2hY0rMgzgYBO6iz8FU0eQ6TSvEp1+phoNMyhGXFsKkfeRlXLkKkHpqgWRZYWE+0mNtmCJLJo2YKBpFa0zomfPVr9VqJ0ZdnIpfLLegOwDe74d06yzCfqeWwfqaruuBA+OiiMxfWKBbIt5mqUQEqyx1vHu+eu7VyOdO/kq1ljyPGM2f/O0mEqKhtEg3lU3arucIT0fPn/Fqk9hY9IW9aLQAFznPfjmhXbTpq7HichHKUSUKD7BiLRWXFftmVOe66uQ/eMnS9eOwr21h/sxQrMrYif8s1JubRMWI9M6I
 S/jXF1bk
 9pPot8tSslgufH+fBWXMdVULv0gG8zYooQlbmf3ChDzvzanFBrjfZmhLtb3IGmi/2a+iFub+iQIzdqNgnZ1RuonIdtMoP+jofRBFsPPIWvdgSR6d+kAlJGsBBM51MwxQQ3/RrMUHPgdhbZ/XiGfMhKQH2VXZS0EpWTzGdzBhjH95MAkbKLj9G465+XquVzze7DuC3sbW5O3yIcofeopbu0QPrArdsvDcFoVgY8Gnp+7Bu3qXMldMILq5StAJe/BiKdHmtmuKNpn+tGMps95KJPYvJN1nBqAsw198FD67npNyjMQoaDndffZhql85gA2dcMJ5A7nta0bBzzb0EaMWbfweDQTX0o4QkTgmXI4PDSdum9riwBYprABUiCfo8k8j2pt82IEGnVGZF4m2qp52EkPVGqSg72MA2DtQtZTRPUou4ZR1Hvl/dkOA7FoqCKFOpHVFST42R2pwOIJ8tYng9sKwS7OWEK6ZpKmOu5jtuOKVNpny2V6qilGGQlIALPGU3qpUBCQ9WTc+5xu/jD3Xk6GazZ4WnMPyejBLR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 09:43:26AM -0700, Vishal Moola (Oracle) wrote:
> We should do a better job at enforcing gfp flags for vmalloc. Right now, we
> have a kernel-doc for __vmalloc_node_range(), and hope callers pass in
> supported flags. If a caller were to pass in an unsupported flag, we may
> BUG, silently clear it, or completely ignore it.
> 
> If we are more proactive about enforcing gfp flags, we can making sure
> callers know when they may be asking for unsupported behavior.
> 
> This patchset lets vmalloc control the incoming gfp flags, and cleans up
> some confusing gfp code.
> 
> ----------------
> Based on mm-new
> 
> I did some digging and am not entirely sure what flags vmalloc does NOT
> support. Is a better idea is to have explicitly supported flags and drop
> all others?
> 
> __GFP_COMP is an obvious one due to a BUG call in split_page().
> ~GFP_BITS_MASK is also obvious.
> 
> Then I started following the kernel doc and added NORETRY and
> RETRY_MAYFAIL, and after forking a couple hundred times, it turns out some
> per-cpu allocations pass in the NORETRY flag right now.
> 
> Does anyone have a handy-dandy list of supported/unsupported vmalloc flags
> that we should reject/clear? Ulad?
> 
We recently have added GFP_ATOMIC, GFP_NOWAIT support. Both are handled
based on gfpflags_allow_blocking() checking:

<snip>
* Supported GFP classes: %GFP_KERNEL, %GFP_ATOMIC, %GFP_NOWAIT,
 * %GFP_NOFS and %GFP_NOIO. Zone modifiers are not supported.
 * Please note %GFP_ATOMIC and %GFP_NOWAIT are supported only
 * by __vmalloc().
<snip>

>
> I did some digging and am not entirely sure what flags vmalloc does NOT
> support. Is a better idea is to have explicitly supported flags and drop
> all others?
>
Maybe we should look at it vice versa. Focus on supported flags. In the
slab there is an adjust function which modifies the gfp and emits the warning
if passed GFP is part of buggy mask.

--
Uladzislau Rezki

