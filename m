Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77F9BC9830D
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 02:24:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6FCF6B0088; Fri, 16 Jan 2026 21:24:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1DA46B0089; Fri, 16 Jan 2026 21:24:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2A816B008A; Fri, 16 Jan 2026 21:24:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A087D6B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 21:24:11 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 317C5D1A97
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 02:24:11 +0000 (UTC)
X-FDA: 84339861102.29.9733001
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4F3DD1A000B
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 02:24:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=FoIsjaX7;
	spf=pass (imf19.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768616649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RG9JTep8SZzMFEcooUHKo6wqW44FeI2fh0jmVquhjHo=;
	b=yK6p3WXNbjfyR0DpAR1lYKcE94VIMoNWvWbhQRpvRzLUPi8f8bQthiMdWJGVMfpNbK7Rrl
	T+RCJJ3IueI8QwXJpH6GDpcmCbWnj8zdTpwPboI0N4pLz8AXzV/xHK60rzI2qb9/wdNlxA
	IEoJXv+iTWXwsRC8N5pOybnZPDGgEto=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768616649; a=rsa-sha256;
	cv=none;
	b=U+jvVwqJJTWBFmfdoHyUbEsClKEAR56B2MLfJl3Op2UWp9iBCbvQaELPptcfzU4DvoB39w
	gMyzFqcRISSQt4a4UnYQHBM8Y9UQJ5ZgsEq3+NsB0qUHe4lPUUmHi4GKLS9FBBWj5RQN92
	Jrhtvgsvf8SPOEJjboaqsQrPgccf8zk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=FoIsjaX7;
	spf=pass (imf19.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2a12ed4d205so16161115ad.0
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 18:24:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1768616648; x=1769221448; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RG9JTep8SZzMFEcooUHKo6wqW44FeI2fh0jmVquhjHo=;
        b=FoIsjaX7twfsS5mVOvs1jzZxQktSrtbSgV84Ah1GszZK2pl6oGMU2I21mOFKPu4ze/
         yXRh5DforJWLOs3JdvEbtt0SVLuBV80M8U4ow1rGnD3A5WzbZaxoswpu3KG3JuJRLh7u
         5pMtF1iSKwQf7Q9CdggWFv8G4Gun5YPxMkm7c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768616648; x=1769221448;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RG9JTep8SZzMFEcooUHKo6wqW44FeI2fh0jmVquhjHo=;
        b=W0LRQzW1x74ydz64bzKreuwiOULsi5gjGGOljSyehT/vDd5Dp6W2kUOpqEOVvYylwL
         9Y5JsdhOILSLXirFkC1qZm2YCRaFakm0A8VL9JCDoBze6hQoXGMyXHgb1sfCrcdNgxvx
         VjnES5v/HcRyWViIfqnEhQJNvnhyeRlPOh2C6zj8i+hki8woArDPMoEdBSfwg0UrBtTZ
         +1JNuuoOIV4NAfJuiKmAyw/cSJF0bvKBnFedQBp++NQK3DigH0YJfvp1O8LQYQAtGvIQ
         N57tkoFUcrHdcUn/lf5Zfwo3xc1enhLrZjA1ro62OoombYzepxaVtzKHWEf8Qt8McPsw
         stOA==
X-Forwarded-Encrypted: i=1; AJvYcCVnejt0Vl2r9DlZpToJfury+ptvrTs4wLtx1B2FV0DJBxPH1yfFBXmAPOYCIkApv9/4q+muZcGmtw==@kvack.org
X-Gm-Message-State: AOJu0Yxx9WyPDKplwgoNhaXhTOQF9z8/hDlJlZTqhpYoWsE7tS3nsQKl
	VgkkUntC2htYAD5XOjmyIrAB2pPvG6dC6rT3DQe3aKPdjtLENdT0ePpia9EJjoeN3w==
X-Gm-Gg: AY/fxX6xozF9LHxMKzAkoOLpr8XUIIDj2LDqueCJAOP7QSkIAyNFAlfSztYDGeXBdKa
	dU/Q1hrlz/i8bBmy172c9AcBwkmvmZipyS7sdrCniT3cNRLMXIaBmrigdwwvdZCMT8k1UVy6c0v
	0hn1cc2de11dvbXQVHIQ9a0BBrYTTPWArxkHu+A75s2An7uLshISv1Iv9M86/LGPSd/antsCGHB
	YRCYxZwECqJpb0uFr3Si+Je/ANfmuTxGXWTsLywaLb1xIm1Kt6VA81VmZ+hMPDZz5nLl5hA+xkU
	yvmkXOJrsqn1XOjguruTUfK6nScUsPyo/CjcnxPx8AMUasuAcHJtIQ+FzQKBOqSJgVA3dC/pkhG
	y5nOlQnOrX58nqKhtYrTocvm4YtS4FFV5kaCmBcoaUpANpEijA7O9Vrvi4VmWTh4WgeQ5bNnfvW
	ub9zPrcOne77XXlEfzvyqH+Mf/i8o4a6kmexZBfuzFDOBWeOI6Gu4=
X-Received: by 2002:a17:902:ea06:b0:297:dabf:9900 with SMTP id d9443c01a7336-2a71865c7a8mr44334845ad.0.1768616647960;
        Fri, 16 Jan 2026 18:24:07 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:fb0f:ccef:d815:5581])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a7193dd523sm32661535ad.62.2026.01.16.18.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 18:24:07 -0800 (PST)
Date: Sat, 17 Jan 2026 11:24:01 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] zsmalloc: make common caches global
Message-ID: <a5jkb4d2xolobcddbac6enh2vjdbi3u6wtwfavo2h4ps2iietq@63nnefjw622b>
References: <20260116044841.334821-1-senozhatsky@chromium.org>
 <z52lw2spqxmvgn6zo7b77nvxyjtxez5nxd6gsn6s3mwqnkvynq@gtd7kpedbtfr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <z52lw2spqxmvgn6zo7b77nvxyjtxez5nxd6gsn6s3mwqnkvynq@gtd7kpedbtfr>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4F3DD1A000B
X-Rspam-User: 
X-Stat-Signature: yubzoni4889p9zqxrdd75xofccrm6791
X-HE-Tag: 1768616649-147655
X-HE-Meta: U2FsdGVkX19V+9XKozzvRuGajHWXeX6SIost/PH91H6U99rygPKSwrjopxjC9OguD0qfzqUz4ZntGT39xZ3v5iJn4swuSsyuuzieViG555NRHeVVSVvu0/6HbWR6y1qSvQu+chiJmjZp/SyJyN8KIN/NbRvVCmqBOVKAPNeM/Dlr57/vSXzOqLjKwCWNr/BsEDiOonhwqvfEuEeok5OhyObAKV0gArakXWXALUGUrxRMzQxDND+3pLcpsMp4AXnCBgoraQNDZz7J5hE5aIr4sFhnL2L+gqtIJqAlM7hOadOfaMDcJIHf7ly99sCgW8V75gfCfaigXaQBUod4dTf/35P1kP7xO0Oy4s0qmaIM3XSj7Ze8oGA1Q2mrDbvmGWBOBr8ROnO1htWKON1uDQl549uTcBBbPL1QhGGuOB9gIi3wXPX00ZuXtfhzUyIJoRWqYfEvW33aAbzeleCF4xG9lFkI8CkcQlbnEnlERCZsaD4OoDmpFq95cPYiGCZDD/23qxG1gnHm5XagRMEJ9MuDRjzhqw9C5UnhhdXSNzwXf92dTdw4Dvh+63iuaAdyvlMoa795veeRdD1LzLsN+xpAHJYEMMm9PGDCkTFWBn1fYqK/GqO3lT808OBRsH7nqU4w1e2O/aidrexaj0TAQB5CkMg+6UgNlhnGtScYb4hi2fNeP7USb1t1MCTtwqRXTY6/7JlMfXBAQ1Atz1tlFEGNsA0Wk0vhdZHjga45wiqC56JVymykz7rti2bPTNKV1p/wxBYrcAwoxV6EwhuwI7u13QijPfnHuHpJjwLzbyg02lEN5ctW0bwZcNvqCrRRKP4bc8B6/LYyOtqRjQQiAe6XIqvJnVQgbYv2h1po10xJNH2fDQcYIvUhkaczpicDzyNCwqyCINzYN/IIg5qgPuWJNuGT2ZhC6VDaWrLTHqbk2zlBCFA5RgnzHxov8QDNw9FM7d3cwch3wa/ALWnC42M
 myPHyPnK
 64YlJuGsXN3OQ9lAVTKQljNgcuQR2zkR8MmEWSu++K8mgilWY9h8mCf6XLxvhTTiaNozBAlk01v7v3pIfFsHKrD1uLVTQr+vKXK1Yte8PvtrWRodBicweiF8vKKQCk/2iOFPmQKMGGGEWvM6SGUAvErEcj2Qk/k/RvvI3EuGtUX2N93G5kj6TGyIoaG9qE9wsoTnkluxVkOOJgKzOVemeqkjzaPd+TKtqAIgsAvQxlpbuCJ58l7TamAbY05/6ZZ+84ZvQuPqEtHo/MC75vyxeXdBzIlorHlxRVD/F8T97Diopk+mkHrCWXtjmcSHQg0arP3ZCuH+M51syM6374yWqIT4BFMs40AdJgugc4qQtuchV9wjWrbypmf0JOLF3A3wFZvjb2rrS8fzrOPb8kwk5LoHukrcWcpZ0nRIFE2LuGc1OaoH32bmF/nOFEZwEbZB6jzD1h4LTSgRMjg9tGV/NRGcFOigGXjqHSAlM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/16 20:49), Yosry Ahmed wrote:
> On Fri, Jan 16, 2026 at 01:48:41PM +0900, Sergey Senozhatsky wrote:
> > Currently, zsmalloc creates kmem_cache of handles and zspages
> > for each pool, which may be suboptimal from the memory usage
> > point of view (extra internal fragmentation per pool).  Systems
> > that create multiple zsmalloc pools may benefit from shared
> > common zsmalloc caches.
> 
> I had a similar patch internally when we had 32 zsmalloc pools with
> zswap.

Oh, nice.

> You can calculate the savings by using /proc/slabinfo. The unused memory
> is (num_objs-active_objs)*objsize. You can sum this across all caches
> when you have multiple pools, and compare it to the unused memory with a
> single cache.

Right.  Just curious, do you recall any numbers?

[..]
> Hmm instead of the repeated kmem_cache_destroy() calls, can we do sth
> like this:

Sure.

