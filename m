Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C981BCCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 07:50:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30EFE8E0015; Tue, 18 Nov 2025 02:50:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E6A28E0005; Tue, 18 Nov 2025 02:50:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 223758E0015; Tue, 18 Nov 2025 02:50:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0E7628E0005
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:50:08 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A6B5214040C
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:50:07 +0000 (UTC)
X-FDA: 84122954454.15.9D70800
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf21.hostedemail.com (Postfix) with ESMTP id BC06A1C000A
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:50:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=VxebQgt0;
	spf=pass (imf21.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.52 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763452205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=plNtX4FgCEClMcrKjGfKlLaCiD+LAXHKIrMj02EWGZg=;
	b=QZVRmJRnvijlrAhcj76WpMlMegdpnV6gMKlfp4lS7g21r0+1RvuIijUeTVdK2TmDt/EMgt
	UIQtFHPY43G9xjO+V6ZWQZN6LBolJtHO1KYNM4AYREmqYrFiWlUwizuRtf8k1YnIpGcYhi
	itf8lqs0zIJabxIXRFAuTb5KA5GebWU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763452205; a=rsa-sha256;
	cv=none;
	b=Y7ks3Et4fGnQwGeHJw7m2JFNZpLGIr6SrEdeMBJI26PRL056Y/Xx8OQ9AEFKD6d6p5BpDm
	S7hOW5pK6QGomP81VCG5VolIl3juyRtnPVfpje7DU5cHRWZbslA/SofXeszu/ZgiIim7gR
	xopaohO2u6f4NgxFp2+zHaFjk3RhPjs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=VxebQgt0;
	spf=pass (imf21.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.52 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-340bb1cb9ddso4407732a91.2
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 23:50:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763452204; x=1764057004; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=plNtX4FgCEClMcrKjGfKlLaCiD+LAXHKIrMj02EWGZg=;
        b=VxebQgt0LqXbtArkZjGv4zSBVlo6TxrRkdQ+Y6qijffXqA3ujzmbb+jSLGDrNAK9co
         gXpFvm2HvDpHZG1iCfZAfqmucr0A4XWgSJNCqL7kp+qWbu+tRs9fncAt0X2jbkVN/0Gj
         jvL467tMrWIBVD3tuxpkz/P1YhwH65cpbPQNc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763452204; x=1764057004;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=plNtX4FgCEClMcrKjGfKlLaCiD+LAXHKIrMj02EWGZg=;
        b=FdJGzf940w3pXVkAZtqybUldW8ezfjrSLzn+L18AqvZYyacm65tmyPVjMPEyIDj/Nu
         Zdc8dyUSjzHoF6/sADeLIxMP8QH3qOvtSNcJAJeyrqI0SuEeokHdPm6kRyLC+t1Rs2Ye
         GL88jum88PATcpfPQFFvUy99xHj0zGkRo8XNlYiTgq+bVN9WDRe9K71sZKMDMRv+8Gfq
         DOsh4GVdb/aOSKqpOkJs1jumE6kd2w4PpPvJ7/u/cbsYr2esGSnLXXDv4BpCJs/x6A2U
         XVnM7P5pba8QS+f+Cf24CFWy+Gmaifk3j4M+vFkt9WNeEpLmWDQz938I1GtreX/phLNG
         C+zQ==
X-Forwarded-Encrypted: i=1; AJvYcCXs4MonXVY85lWV4Km4omF+UReHeyC+GnJph1qmCB4PwV55JgmvqJJ5dtxgqriyT72a2fwswRtTag==@kvack.org
X-Gm-Message-State: AOJu0Yx/bACSP0CiP7vqfaxFHw6imyw9+LBYLDr12loY3LYPfrZXnJE9
	3Zo2g0xFDtVOa6JkavSOSYIenUAkB2tMBHZEXg4ZTOrv6Kzr+SZ9LkY/ABrSvhg/UNbMaB7E3XC
	nsyk=
X-Gm-Gg: ASbGncv8kXUE1VFH26Ng3qSKEAXnDhkEOBUnaXfoeP2e6EH34xIvKlBYnyGFSQUjaab
	DXsrI49ucZTDeTz9b8GRIMW0d3rqhgsNGpRaEAxINmHqU0pn4vWJ8/KygyDR1o5130BQXSG1u0B
	T4gJiLgGZertoYRIyVbrSENq2qPP6eBn6GT9LbjjrkityeXPYD1Z2qS2AO8RGFnE/v7gKy8kRDv
	0QF483k0QApDuzD7qGlAMR2emiMf6R27NuinKgw7jmUYAJNErESJyOMf3w5Qeiys95G9BC9XX6i
	oGU0++OszK3Wfse3wunhI5VtBAsLIg0lWiVLHW7HnlE9kDQusko4oCBgI0/kB5ufXpOIwfjQjid
	hqppZsEJ5kqFoHczZgTVqNsaybkPNtfLTZuwhHy5LCS7vMpSMSg10cPNZKKCPqmDG70zyWf15nh
	2PbKpcUo86NYIi04y2luOxkZCKKA==
X-Google-Smtp-Source: AGHT+IHZwl0OAHHI3jg5IDqTvWIOofVPyV3wFLo/icrQp+7MyguQnHwiS3UU2BMu9Gy23vmm1Zpkbg==
X-Received: by 2002:a17:90b:2f08:b0:335:2eef:4ca8 with SMTP id 98e67ed59e1d1-343fa769fa1mr17863076a91.33.1763452204610;
        Mon, 17 Nov 2025 23:50:04 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:beba:22fc:d89b:ce14])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b92714e298sm15568611b3a.34.2025.11.17.23.50.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 23:50:04 -0800 (PST)
Date: Tue, 18 Nov 2025 16:49:58 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yuwen Chen <ywen.chen@foxmail.com>
Cc: senozhatsky@chromium.org, akpm@linux-foundation.org, 
	bgeffon@google.com, licayy@outlook.com, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, minchan@kernel.org, richardycc@google.com
Subject: Re: [PATCH] zram: Fix the issue that the write - back limits might
 overflow
Message-ID: <eebxwjzm5sdej3i5hb7pkj3w2xkacflxkeuetbyb7i4dpmltdl@lkysptw5owko>
References: <tencent_80150170978D13BAF69D63E57D7F5175F90A@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_80150170978D13BAF69D63E57D7F5175F90A@qq.com>
X-Stat-Signature: osxrdqajx4799ripw18xb1z66pwn696d
X-Rspam-User: 
X-Rspamd-Queue-Id: BC06A1C000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1763452205-275314
X-HE-Meta: U2FsdGVkX1/kwQyrHIH8P3IICIJhUT1AGBRBJFWeMCk4cNEJhcp5whrgqe6n3iJ8poQT8mUvTr0bRySWwocB9MmUB3yYL6xoDoqCRiCnVtqf2xTnWNqMSJkV6UgCZuh2NWDbSxfXB7xDcmIIZ8htbAv5WJjAMG9Jo4KN3mlrR91XvpTaM2m6lDJA+vTGqQT+wxrGjmuRPhEuoTUD/GDt70x4sjVtmdS3a/OTTovuknTRe8MybLlZH48GQjP5vOL5+KdsHEJwykB1hZgwDfdd/husd2Tmn9rOAZazt0orISqrM83unUsg3MPIj6jK+/LegUtqZtPRkU4JW479qXTDDiMkY/LGnxD90sEKGQv4iKZ7Q+xBVWZt/ct1iIV2nMqGsKSnGf1B8LOIN3nnkTuzLUMzdAl8Ui6CMp4h/6QEn0vRGx4C4EFgq6nu7aIB9xumFcPUbXeTsSl6GSq71uiYMQgQqKqPVqZkcSIdSNcARTBI5tpc/z2WlUSPD0Iv2PSpi0OCJ+pViZCv5ED+s408PtBHE5wXG1Zq19XGrji/1bNFlFuaz8q5Iq4NcJsHpETK1FjOdE/7dOchDtJuC7mm04BGGHgMpxfxUEftq4iA/MRyzcaeQtt8vgy8+2XlBHUwxjfqjK3JCw17aexfJl1+DYY8UJ13yjQGgvZ4mZAu9EWqaSLRp/2AntJ4BXp7gXH4drE0dN35rmIABl8jHNSISpFsJB0ySXojP++0VnigRINH/uB0vH1ngVrZHvKg85Q1k2H32MHxTDN2OierqlWGoeDrEbkN8ONyFSV6LBZyQKX9wyuntEN7Vfp2/Zss1MnNJEVpF1GxPvPHIKoPWgiCY/MeaaYuh2dxexHS1RUMyvdeVhOpQNCk6MG6qqOFcfGeSrrrE71J0JFX9fHs0kb7/NjKv19CEel8lA2IKkT0/o7qprrpxqGoAf3FxGObUFDILSPHN4cCd2L2qp/6JEC
 eCfdD4K/
 v0L/txgBMJMQs7UMB6TvRGpAjFpeZ3iav3dAISJ2u7uMOy8/b+8HkM3ltkYr8Rxi9WJJvfY/FjcCtw5a2AmzCm1ZbHb9qVFOGzQ9nQanIt5cP2/bQo6VJhBXL/+tBwaGyR8V1WTie218wbxSfh6I3tsY7jEQPqBT0o3Z2klSXe+r68yI9i7NDdF6ID58iYe4rxQtOAriUeX8VfeQBXBDQ/mH6QfhTXDA7N36Eqv7Wj03ICAffOy9aafCk7JvEAT0Sx34lSaGLRR0mFs6UivsDiPwDJwrBv6iscnL1YG4KGTlBoQJA4SvZHUr9Aosyvn0STMEERWK9Z/xn5nZBuIYnBkyudwdncSbzYZtizuVD0XErCj7uCQiLFenFCTKsog+NokQtyDX8Rr0+CnwcAXmq4PCwUPea1xZR3aW4xgtSIWzt1CQSR1wta+HR+g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/11/18 15:39), Yuwen Chen wrote:
> Since the value of bd_wb_limit is an unsigned number, when the
> page size is larger than 4 KB, it may cause an out-of-bounds situation.
> 
> This patch fixes the issue by limiting bd_wb_limit to be an
> integer multiple of PAGE_SIZE / 4096.
> 
> Fixes: 1d69a3f8ae77e ("zram: idle writeback fixes and cleanup")
> Signed-off-by: Yuwen Chen <ywen.chen@foxmail.com>
> ---
>  drivers/block/zram/zram_drv.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 4f2824a..4ecf2e7 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -562,6 +562,7 @@ static ssize_t writeback_limit_store(struct device *dev,
>  	if (kstrtoull(buf, 10, &val))
>  		return ret;
>  
> +	val = val & (~((1UL << (PAGE_SHIFT - 12)) - 1));
>  	down_read(&zram->init_lock);
>  	spin_lock(&zram->wb_limit_lock);
>  	zram->bd_wb_limit = val;

This patch is against unfixed writeback_limit_store() function,
it will need to be resubmitted once [1] lands.

[1] https://lore.kernel.org/linux-mm/20251118073000.1928107-1-senozhatsky@chromium.org

