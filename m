Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 050BAC56201
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 10:37:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 066656B0096; Wed,  5 Aug 2026 06:37:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0169B6B009B; Wed,  5 Aug 2026 06:37:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E46FF6B009F; Wed,  5 Aug 2026 06:37:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C0B2B6B0096
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:37:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 530FF1A042E
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:37:45 +0000 (UTC)
X-FDA: 85066864890.07.4FE9913
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7F212160004
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:37:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=PRJzq4o+;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785926263;
	b=zC0vNFxX29B/G7IZJppo+8Pc8dyNwvydSSYK85p3OcgVPjVty4FwgWqj3OjqtWfjjA3hjJ
	qo70yMyzTRy91xWa90Z5msdjnDMT/po08dhK+p8mH72abc8X4ZARBpO3m+wp6vidaC7Bvi
	Y8P0JzUvISU8MnxIE8wHqQQc7JShj4k=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=PRJzq4o+;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785926263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sCsrPx5m8J5wuYY5ld7QEshnQZYxDzXTxr/SGYPENFk=;
	b=S3tkBQVOeYHEfN7dWQRGw0CSwyeQwizHuK417NUvVmb2FL7Uc3ypdZ80CpQuF202dwtDwC
	ytRB20Do0dPsBOy6XqNP83LhBxJG2v47iCQExwxZfMR6oq2AdSCYxH92rZ432GIrSo2RXc
	4SSsVKl6OfUCN8hlRUqTzyiGCsXv5FM=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2ceaf8a1265so13049955ad.2
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 03:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1785926262; x=1786531062; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sCsrPx5m8J5wuYY5ld7QEshnQZYxDzXTxr/SGYPENFk=;
        b=PRJzq4o+EXCg3+5VzTQdNia0gw3fwrINIJBxAQSyvbAjYY1rLHik+AR7rpftKhGkUQ
         4HrROWnhGUUFNK6CLioYFFLTkkWo7IBPuA076wNLtSkKYTBGrhbyiBiKcHaMmKpldw27
         0a/vbAuykN84XY/21u/rWn7qOwUkTtDU6se1s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785926262; x=1786531062;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sCsrPx5m8J5wuYY5ld7QEshnQZYxDzXTxr/SGYPENFk=;
        b=UqH13oH26Nyl3WBtR092O0msUM8nQkssotSJp8+B4Ln2sks8QWwZrLRa1kyRTOCBEk
         1dmqrxZB+s+o0xyeJby6Lwt1H2wihAKJhFP4ee9CkmREwPF5uG4q9ptKaQxO21pcjla+
         M+8mI4ASMA6A9mDphGN0K8HiKJ5MVUO33uemeo2IxrKcS6sdNwHLySNaOsjiecJ5j6mC
         +u6u4stGcu1q98taQVXPTwDsphTljA8JbzQwtcBoupoxqfq6JBZ4+DBTOcjTii5FfeWp
         f+KqqgFfz0Q3nnt3sqMG7mYDvMWCZ+zu1mw1UmH8NyEXLXuOnUPJ2ZInkVkZnjveFc1s
         nKQQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq4fCZNDo6yzkP7CyNleTWNMX1cAQgSn0zzkhXlmcYawRbN5DJnkGrLrwxU+b4bZvv3NQ11DX3nww==@kvack.org
X-Gm-Message-State: AOJu0YxwPHAS0hiqX4Sr6mTbUrNUzpSS35oWO2Go2cjdrdZ/3dh7kSi0
	Tol0tK07ar4SWZgQXDthJfHG+SDPX2kbwUrn9oPXn/pJgGutSW9lVQcKX/WSyZwUEA==
X-Gm-Gg: AR+sD11p1Y7FHrw/0/nIShJA63PaS+Q43G7LjWXyC1uK7biZe+gDIiLE41H4GlBiT2e
	ePMnoGSRs2pS1gu58bzZDOzaKGFc0hc6bO2ui2KIFlTO41jRC/9+2cafXjs8zh+MpLZSBzjkp4v
	W7j/lgXez8odXk1Pu1CP+SHI6S3EpbFI/PcyMS1d3fZrod/asyVxAaOatvsXDNLi8eStzJG6yJc
	4JXPol88lIGaf1Mlz/Ccowj01s47IrSO1vGH02wxGX6BzqOFMhlmGLw3M6D3irrqmPFr77iLr1Q
	mgpouDdpaci4m2Ua65/ypxS4bBTlGH+kbJgzu8pqFj0s1VgFOSIIssFXzEOvzQTZxvkoR9aMDmN
	ZilO7EDOE+q4hbK/LmqjX0cBWK0G/NzJeIGa0u6qQGxkJVqkL8DGFyyWavJCc6T+D51kOaxadhS
	0oNS2ZhZFcH0XwkpSEQ8kWsqbFAQTUNznYyDjFlBOY1WHGrriGs5sX606VDxH4XrjA2rcIJsSmT
	UKzNP4d+EpbT0uN0TksHOuEvxQI
X-Received: by 2002:a17:90b:288b:b0:38e:8050:e63a with SMTP id 98e67ed59e1d1-3903c54d9a2mr6094340a91.6.1785926262401;
        Wed, 05 Aug 2026 03:37:42 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:8002:2a47:a704:5a58])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38febfdae56sm4428181a91.2.2026.08.05.03.37.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 03:37:41 -0700 (PDT)
Date: Wed, 5 Aug 2026 19:37:37 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Barry Song <baohua@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	akpm@linux-foundation.org, bigeasy@linutronix.de, hdanton@sina.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, minchan@kernel.org, ryncsn@gmail.com, 
	yosry.ahmed@linux.dev, surenb@google.com, Dongdong Zhang <zhangdongdong5@xiaomi.com>, 
	Suleiman Souhlal <suleiman@google.com>
Subject: Re: [RFC PATCH] zram: avoid preemption with CPU-based compression
 backends
Message-ID: <anMSKKwfQYEeiX6J@google.com>
References: <20260805005545.66112-1-baohua@kernel.org>
 <anKQ_qZ1-Q6FchZ9@google.com>
 <CAGsJ_4wD+KNL0yMkuS4GijbHaiyPxgTmqKzkr0DErC0XH30w4A@mail.gmail.com>
 <anKaU6VStrW8zaQo@google.com>
 <CAGsJ_4wQ=mDXuxxTdAZkicN5pJK3SsNTOxHt5oNYrq7CgCVObw@mail.gmail.com>
 <anLGxk3iShEfCB30@google.com>
 <CAGsJ_4xU5VN3abCPzACZoS92MqaUrMHn9EQ1FCJD+wy=upbbMA@mail.gmail.com>
 <anMPLgbrf7XMC7Qw@google.com>
 <CAGsJ_4wd60ok7BF9XGRiO6dvddkaYTziPV-Bxq+3mA+-c7MvQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGsJ_4wd60ok7BF9XGRiO6dvddkaYTziPV-Bxq+3mA+-c7MvQA@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7F212160004
X-Stat-Signature: dtheq9ztro3wcpanamu6kbjjwafnothn
X-Rspam-User: 
X-HE-Tag: 1785926263-521439
X-HE-Meta: U2FsdGVkX1/sAMgl3xWOE7DnOzumSjXb7OO+/I8mjz8cSKi20kxFLvggoSoSBN8YV1DWMeeO6Jt9u3M/QUYlsRBJ0Aiy90RkeT82gQ0RkCHSnlWSROblA4nHsQFE3+HLJLzd3cwFjZjg9wVzZKSxUx7BKpHVYvnZPqiWG60IhcgPIwG0pKU2kfXfqijhj9/AgOPZFDchbA+Ji/G81lRq46hGdUWOU1Sfe0kOENZyWLgMNDOtBFJXk1cBXFrTpES7ELfcNH7vHg+u220D1F2xxswGPEarlt1ZyGsxGb7Fun9yRgT6JU5M5ZiS5dSoglhcxdrD7sF16YGRES0EZ0P14LbU/PLXDKPqN8geTWQsLGKliISCVZG8g3hawgymhDmTKbD0dxCRRSQRhiMEO1FZHmztCnja3cJgrOSBzwTYvmps6C13TxgvW/HOnSBOoz2pEl8XBF+Qn+RVwqDjsuyMqdqTM5IhmQCK43COZizNCZvAaF4v0CEBYqTD2xtKwLRXXrvAC0NdEL+/ZY+KprCv+cMSVDgxPcKYDVP9drvA0vzjRrMpYbtGBI/AMOwwWVzL5XgVH8ALsCrl9q3sVIQkDf43xS37nl9o6AtMIIIcI3Q5u+WEMYCYof1eEcVhpm3+qkxRPf0VaJLNGEdGq1pSARmj5CmevbZDAqFDrNaDQQdoNx2TtIA5bOcGbS2me8iDr444WMeuDDbjYjmOQySpttXdp5NUCeFsiYCC4jNe1Spj8qFKQy+KOcbV/bw67uGcZvnYthm08R6Hs1Ce7CeDWzl8ixaG65NEbpSpmDt0tu70OZcRv3Cahon4LRU7AQJk+Fh/OTice6m2IAEl+EvQXsjnetpO/p3Nk8l85QmkRRbWkQ3dGtCs9t75jUriiilijJ2lUSDGMYnLPsZNpUeTqVIvIMS1eWVIJXffmhCvrRsvLyU3gtMiZdcxrilf3ePQt3Di6cysWKkt/weB6+Y
 ESkBa3ln
 dbThcoSzpH29N6gieGq+rCWGAL88TGLcn4a/JTZHDzTb1I0V27jsk4mKojYSWwuaVYO1n+LxZFF0WOxRiyXCQwTxht1wM7uikl2gHTe0APIKMdlKP0wB1t035cyNLHZXj/Vz5IIQQ+24hTC9bkea+2x6/JdXpHB9E97+wuVdVkCD2w7WfamPMV3bq232ECECe3Q3PJj2zruBRxcIlxN9omDaT9gGTwwL47mAZuWvliBZcKBqSXOnjhV81uUl5NO3qY+iwR2lZ2VnGaMQ4J0HT2h/rhwmGH7GRthhp/jD44HohQIMy3Sk0hnqKe4bdIRtFuK5BjpZ5nUwgeJbBmNS6uNS0/LEsHR4AO9JxPWWisyVqMFGXt9elfknW1t8Chc5niiKB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/08/05 18:34), Barry Song wrote:
> Thanks very much for your quick patch, Sergey.
> 
> We are going to run three experiments:
> 
> 1. Use the approach I just sent, which avoids calling zs_malloc()
>    with direct reclaim while holding the mutex, and extend it to
>    the other zs_malloc() call sites:
> 
> https://lore.kernel.org/all/20260805100740.71994-1-baohua@kernel.org/
> 
> 2. Experiment 1 plus preemption disabled.
> 
> 3. Your patch, which separates the compression and decompression
>    mutexes.
> 
> I'd like to understand which change has the biggest impact on
> performance.
> 
> Let me gather some data, and I'll get back to you.

Thanks a lot!  Take your time!

