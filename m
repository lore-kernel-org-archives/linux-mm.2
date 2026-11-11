Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91075606A327
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 04:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=ak+Yzqay
Received: by kanga.kvack.org (Postfix)
	id 605616B00EF; Tue, 10 Nov 2026 23:15:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B52D6B05B0; Tue, 10 Nov 2026 23:15:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A4196B05B1; Tue, 10 Nov 2026 23:15:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1BFD86B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:15:31 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 851141201E7
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:15:30 +0000 (UTC)
X-FDA: 85421524020.14.51462D8
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf15.hostedemail.com (Postfix) with ESMTP id AED9AA0004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:15:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ak+Yzqay;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf15.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.169 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794370528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zqiKMWOLSQyjwMbkXK+aSiPK2rl2ZK7WmqO7AOWRX9M=;
	b=EhJarK7clbXhzzL4YKfbMqGSglCF74JUQCvZvFO1MmDgb7/A3UdFzLmpdChKnXWdGg7fPO
	olsIVCLspzZItWTVewilO4sYkI5XghuvWycNUrWf6psvvPhoUhGjKivpprnjL+EXE1Lqub
	IaAIC7e0ZCrp3wwqT6rKtkFEnTXzBDA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ak+Yzqay;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf15.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.169 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794370528;
	b=rZt8uNQmKpnjLiqUVqPoL9ShINieEIo/2MwYV6w02+sbNk8d9K5Zx/PcXqotJP5ofGSV3X
	eFnLCbQFl+EHpwebfN5Cy3xIBvxhcJqLVR+migCtti08zOpzzRrnjLVNtb7iihMuM1Aoxb
	c/Y3N+RDArbws5d3/N+y4fiw9VS+Hcg=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2e95bd1c14cso25106935ad.2
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:15:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794370526; x=1794975326; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zqiKMWOLSQyjwMbkXK+aSiPK2rl2ZK7WmqO7AOWRX9M=;
        b=ak+YzqayGAiCpw2fOq/yHeP8q4JAkvSU0yVgYjRXnBrkNFdoGi+qTggF0+B48BupgW
         /iFHvlKnFiltBMkNzt/31eHozmf37G0/wabNXv4q0QNIDHq27MoAflW/+yLZbV5zhTSy
         LFnsnfKiit4/Kf4eq5gQMAcMRJ/TSYWxnDPIg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794370526; x=1794975326;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zqiKMWOLSQyjwMbkXK+aSiPK2rl2ZK7WmqO7AOWRX9M=;
        b=sD/BR2y8gvC5Msnfp5BSQXSZuOkGMW3x3ET9e059CK0XxP6QbTe/pvwJyQd/nw45tW
         1Z26UIrVRvEeISvLz7wSf0kd4m/0z+/VNH4duE88siqGt4uHrCCthOGC+Iuu3ePH+SsG
         PySSDsCfJ0YZM5QTZXPqvl8VIJfRnfgQieF0ij/GOgdDPuy4awI9fj9mTsLEQM4a8gig
         3ZDuKqP4nX2qa2ELDGHmdus0+KDKM5FujXETYEkhk1k07xuoXgefZUJcIXg4txnqG2fO
         pXQNbjUZAsdKHAtyJ0MYnOAz2OsungqzQ/UbEPXqwqV21UtNIrRuRt2J0PO+dKFnSdcS
         hotQ==
X-Forwarded-Encrypted: i=1; AL+hErEwPwuQjDOpezXBPjfJvQCsNRgYJr9WANoLDf5Mhx1tUGgZN0PaGMe4rW/4mFSx/AwcrwriMel5YQ==@kvack.org
X-Gm-Message-State: APuU4Z/Tl/ZSf4N/asWXqmAg7o1YmfpKZpsiorqLbizfqOAZeh3i2uYj
	uaf02eKfF7CyasQgZmEqzdskY1asxKTGv3O0iBgPerByjp3tZGQWc8U/dK4xF2TkDg==
X-Gm-Gg: AYBFou1jjQp2PeS0bxTKQp/MrzjpoJpuRLvSnvV83juKXdj8WGEKLqZGwsnhrpw9dpo
	1rvSO4dD0v0sLoZOro0RBBmRYxNAjwVep6AE6zLM7SvkPLBj0M2sE4kloSjKNevrP99oNvEUCyh
	cRknqVmm/jwDKF8Ts8OoxlmVqQOqjO48a/My/4lSpdo7gCT+MBedlr5b4FAdGPsg1URjWFboq2+
	Icb/OBbgkntJeICvGhgrNBExsxHirlUfCCYvXj0ek86vKw8+AS7090grSeLsNIlAzlRdqUvu7Vz
	3c3Sy4VrrBqwV5zB6GIdGGzqCB2vLLhvSH7HzfVgbCUpk8qQ9haHQPvxdSIy8YpNul95ubwAZJf
	AvUjEuV87vSO8Vm2qtXSzsZcsnCE2PZs6Xohr1I/FhDrpw/STh6wpqWEn0PliA6ukym8ckylFxO
	c+wNtWRo3OpH4Mn8P4DOxu/CnkeTr1LudXKT5ec7s5prmm7pZcxQOiViyuGtuiWHuuCfZkaEo0x
	Im2yweYk1+JfV8csJZsYUNWO60L0PBDKFgyuHpGAlZEX9mqvo0UDiau3QGFujeT52/uXb68iKkE
	QFEKAeAsdxVRfSQTagL0BlJpWZv+3P9EK8+C6EigBqUylIR6wtbEQp2LqjQnLdmXZx+Wcw==
X-Received: by 2002:a17:903:94b:b0:2dd:ad74:ac1d with SMTP id d9443c01a7336-2edd79bf870mr15709035ad.24.1794370525821;
        Tue, 10 Nov 2026 20:15:25 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:ad6a:b446:df00:78dc])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6d7bf46sm16294355ad.31.2026.11.10.20.15.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 20:15:25 -0800 (PST)
Date: Wed, 11 Nov 2026 13:15:20 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
	Richard Chang <richardycc@google.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH v2 04/11] zsmalloc: switch handle type to struct zs_handle
Message-ID: <avPrwgD8lrQQLBlG@google.com>
References: <20261110054836.1515030-1-senozhatsky@chromium.org>
 <20261110054836.1515030-5-senozhatsky@chromium.org>
 <avNHoaIU-RV8_fEG@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avNHoaIU-RV8_fEG@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AED9AA0004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 9bg1ax7r6g4irhx8boyugu19ccpa97ne
X-HE-Tag: 1794370528-25742
X-HE-Meta: U2FsdGVkX19mJPt5SH3JHxJfCL3Z0/X41WxWF30N44GEd0nO/rTwtzbCqA9yleuOO3vWKNejiokj9ULViJ2n0cPPEYwC3c+7GvMrubfgH+7vWJd3uKobt2fuVWAtaxG7cIFteXyIfWhAvG0IwM3yb4phfHBmODxEhXpczJ+XjHpcz0S7x56+zLUXlU95Ka7jgWb6yogx08t22I+GyNubTDKMpyXR+f5dUSCoZ4bQbhMDxDtfPaEIfnf8ngCHiaxkXPAhuFJR9G5nLxcCJEzHe8BYwh6YsUhsH2zl3DDshoHVXVfNbdXf7vXxPeBQ3mt0ApksBoDTzE8/kBUajW4O3KMNbFAMAycZrdRoIwURmK0RRxVxcCV8Pb5cSQNiGbcwsQz9jFMVnHSGgjUoouSSZ4C5Bc+93WcXEd9attAjr5vRayDX3pNvTipXqulUIgGna268uxuSqH2ql3mfv7kbfOrN4SER71k1ap88Qxxj3PrhCPW81uteZb+QZYF7ftvaJSnm7sZENueXdMSWKQzZkePz9u7gZZ3DeaJyTS9E4qdHUA5T/fiVqDoTz0yZflEyhnF8NOteC1lZRRpb+orxQa1tjxkpyQ2CFQIBbSMmo4vQqpU0Zc+bOnq6H/c5rkEDRDgLFAl0wp6wPKmv734ZPF46jhJfZuVktgiwUAVqBqollX2YBwmgkrOW+xonGT02l5xaaS0Vr895A2d5+s+5L4FY3IHSYrjF7NYMmPMUTH4PA5yY+r1XkUomgscaO+6GV9gmzXdcO7MwmgY/Djb1MsKz6CkRqfr89TLxauaERX3j0bZrDbeHj+/bisx9PfEj+EDU0QTA8HwwzB6PKybESTHWnUTFB2ycMXQKp1/fPSvJQZjBMKEqsVkcMWUJi4MYdjUzXXG2PQbn52Xr14Lee5myGiTtSsQ61adRJNgN/2J2x1y+IfnuBA28TUhDtwkl8iXFewkK/kJj50k1WTS
 D9EpI0yR
 NuMAzkWhSh7EqvMPTzE4ET2962zzjkbV8puS6FCBgGAt88NqM3OdryQt3HZadwruBtGqvvyc2QwJ/+pQdoMgPkBpgx12k25mXs2da7uA2j6RUamRf+Uh/KnX6J5sFn+mpYmLI7cTi5fnlQXH22jsHKAb397/PATu7XyS5ReaQN57bI7VHBIPYbeBl9ET9aJK4gmEpccPyQ9wYR8DZdIhFNB5q4+8UZa4WdL8uW8yENYfmSE4OBgsrUcAxns5TQ2bkDhx02slLaZYYM2jVKjKQze66lJTopouAOETIOXxv0PS06MAE1kdjrNLUIJ6P0CUAAphHEVdU05E2ZwY6WQ6qsTscmDhH0pdTrHLjkcj0Qd0Lf0S6A/+rLxylWTthaQwuttaLrlVsrFjIZQHihgGaOCkbyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/10 16:35), Yosry Ahmed wrote:
> On Tue, Nov 10, 2026 at 02:48:09PM +0900, Sergey Senozhatsky wrote:
> [..]
> > diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> > index dab71f582103..3a6a7253fd01 100644
> > --- a/mm/zsmalloc.c
> > +++ b/mm/zsmalloc.c
> > @@ -264,6 +264,10 @@ struct link_free {
> >  	};
> >  };
> >  
> > +struct zs_handle {
> > +	unsigned long __private obj;
> > +};
> 
> nit: Update the definition of ZS_HANDLE_SIZE to sizeof(zs_handle)?

Ack.

