Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B557CFA469
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 02:48:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B85DD6B002D; Thu, 20 Nov 2025 21:48:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5D4F6B002E; Thu, 20 Nov 2025 21:48:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A74106B002F; Thu, 20 Nov 2025 21:48:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9A0DE6B002D
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 21:48:56 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0606914046C
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 02:48:54 +0000 (UTC)
X-FDA: 84133081788.20.F4AD38E
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id 485B71C0007
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 02:48:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=hqjmAQGy;
	spf=pass (imf21.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763693332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mN56KAVECGZFLtl8e3BK+ApEqN4tpkmsSG1PhSyua4A=;
	b=LgpqbHEjoLbIVvq6gBWQ0VKVj9+iModB1q0wVofAR8CjXLexF2/y1GSv/pOKKpkGO99emd
	uFko/zDBLVZRUns2RhvEJBqbY1DbyjjJBXstiQIzbUjnjIVmTdDlVZfYsi9qdT7p5zvj7q
	AEd5PxfpsUoNVXUU0CrV4aqbtmimi3A=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=hqjmAQGy;
	spf=pass (imf21.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763693332; a=rsa-sha256;
	cv=none;
	b=Bbice4NgjCL80JMf1dTp21MbvsYdMSdGokfnDU0YVtVIp4oELs9pj+y7SS8sYjv3b383BI
	LSxcBWkLlOVTDJQVeFwGttAth14w61kACmf8utfC59HZU+JFdZo6UL9TRLzaHEysCWM2gO
	cK/qODIZyQjfN9+VbSkMOail7MXjvXY=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-29808a9a96aso19256975ad.1
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 18:48:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763693331; x=1764298131; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mN56KAVECGZFLtl8e3BK+ApEqN4tpkmsSG1PhSyua4A=;
        b=hqjmAQGyi7gUpVqkqROVUwKP0Rp+qkRN9YrhV/ve9e+RWgYaAqGMeT2IXLwt8ZDVfU
         SiVti/h6MJ2NXCu1a/NAy+s7XaNAXUhAyPtm+jTYXEEUC474JUbmR31RE3ICkCGicjiB
         EOXkjCTlAdKhErQ4a1cgO7vodDzOi1b/5UGMA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763693331; x=1764298131;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mN56KAVECGZFLtl8e3BK+ApEqN4tpkmsSG1PhSyua4A=;
        b=qIIb5sjIslftH2PBrlDCQjrGUqCmZiGEt3AN3n2fwxQ5+IP6P6//S4isXykzrG1hOI
         gizutJlgwJS1REGm4G2KYQaJuQJZMcWS6xNQ1va/TWpBalwSlAWsFeGUBQTqmOhuDW3Y
         CBrmV9Js0OzFDcXGMWFSpsVcYzyZpRmKcwjWjiOh8UtZEyMfwsGsg0t4iYNqQyHFV9Kc
         +qTS9+6m0ScyZXJy3tDZoICD2F54lBlIqAsioAMd+qcgPmi6d8C1owvOBJ1Eb9qKY6AE
         UaYJ2FSZaHjQ1TPYzhkutm69JF5UaJQfyF3bgAdc4nqjpQIrxOjsrv87MGL/rcJ7q+z8
         tERg==
X-Forwarded-Encrypted: i=1; AJvYcCV3DSo2UTgNL0C6RldPfQbXDc0YVkDGMbhWIivYh1tPMlDwqlE6WTHhnHcYdobDEULOYcBOZ1kTSQ==@kvack.org
X-Gm-Message-State: AOJu0YxEZFcDlGpCt0DXEVzHt/RIUPgxzcuf1E+uttr1GQ69+EIQ5M6F
	k4I49esrKyiyfZk2nlv64k4HCHHTADv6lqk4NyOba6aBIp2AD6pilqSWV19A0K94DQ==
X-Gm-Gg: ASbGnct059CyrACgzXgAiw6FAYeyY78Qq8nrvgm2MLdmpGaBzFJnHJG0LtqSbgIElvT
	nDxxmFNAsXJM0ZlT2/6w/WuN9z5rp8Qcu5lElkXWBhpqoI3WJQRPHtHw3aAHWfoflYl2RAh0veO
	DI24+8QcvVkrhu9RBI/EHHLX7e7/y+Ykn2wHceJ0STSPUDgfprg4Z3U950GTEB3xF6xrm9EOnlg
	zwE2lGZkFGR4gYD71zY2yNZT1CnSltWYQs3biPN5LMYr1H5AXXsXxYB56A4NAMj6Z0xL5SYoNVV
	cCdzqVIbuFLIc23PKlUE9SudsVijN7nyQpFSKVjq3+6Y7IPfO2W6GmY6lXc3BR2iyOF8FwzYGBT
	PLJc4Dy33BshqeJm0Yiltd7OYNOt3JGaN+HS0Y8PK+VXL9BvoRvF0jGemclI6wmMVbn2QgFKKF6
	oXFx3EgvV6DNM5JA==
X-Google-Smtp-Source: AGHT+IGO8vM4e+LbFZ+U2TQaDlICVXlmzK2vO0o0gJ1AIsq/eHFmVseFKAQ/T+Qq1ikLdhGppW2GVA==
X-Received: by 2002:a17:903:298b:b0:294:f70d:5e33 with SMTP id d9443c01a7336-29b6be8bfeemr11923735ad.12.1763693331090;
        Thu, 20 Nov 2025 18:48:51 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:b321:53f:aff8:76e2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29b5b15b851sm39168435ad.43.2025.11.20.18.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 18:48:50 -0800 (PST)
Date: Fri, 21 Nov 2025 11:48:45 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Minchan Kim <minchan@kernel.org>, Yuwen Chen <ywen.chen@foxmail.com>, 
	Richard Chang <richardycc@google.com>, Brian Geffon <bgeffon@google.com>, 
	Fengyu Lian <licayy@outlook.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org
Subject: Re: [RFC PATCHv5 2/6] zram: add writeback batch size device attr
Message-ID: <uboc64fpwzcs4phm2xppyvuf3h5clkijbiahsb2wd2vah3po5q@dnzh7ir6inqz>
References: <20251120152126.3126298-1-senozhatsky@chromium.org>
 <20251120152126.3126298-3-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120152126.3126298-3-senozhatsky@chromium.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 485B71C0007
X-Stat-Signature: qkpkoje54569gzx98aggq1h589pcm7by
X-Rspam-User: 
X-HE-Tag: 1763693332-333309
X-HE-Meta: U2FsdGVkX1+Q9mE5mFY6oBwlj/0AxGeSIrMQPkMAjEYJC/WzYRw1Svba0KONaXLZyNrJUgoU+ECBryLEVNByd+zO9UeKQ+wTopDixDrp9E1UD9ptC9dQMwHNQ1F5HADuGmdPjYD+eKYo1JB5JIghqcYPOQa9puGDKMFsSOZHg4T2GQNdVO4qDSRhGgiiM6cr0+NXFuAXQ90/UgXcd5ouchDHM65q+F/80Vdu/hp4rB8NLHN95jxtsunRo12Lj6NJ932+Si7NK4duA1hxw8bNahWrzDX5XrVIUCp6OBMUpa0ECMZzXO8zh0LLRUHYmtWWzX7XYXDzgDnOZkoHVY7MvysVlHJoZ4ZD1t/scDtoVBmCLycdg3BiMrApe513ApVNx9000yKTx/vshRw15eY9J5ieV9OqgFG2Z05/PHBcZbPp5AM2HXTW1lYytasG+fYEliU7/oec6O9zQyXvkpJTYosKPa17F/s6aPsgBfcd5TW+m9IhnNtuum6vtGfM33FtfX6d6rou/F+WQ/nphMai1o9uBfoXWLsxp9T8qqf3pVdjfCudzS0ehHJ1MFgdPpSi5lcAo0Zm9Qm3d3vCQ4WsAPknUEkNHwF7UX0HIEKV8sVAKtEFXlXSuapcSIWmUvpbYkEcpge3dcowTfaeZ3wEEqng/6v7G4R0zmPmzXqeVTY30anBAsQD3lPtpPVfW244YB4BlAcz5fRoRO5LOIcRDjvjyIQtaId+/goQtOq123KDwzaJQUvihge5xbisG1btQAhp1LGxm//lCkhueZybFwsj4yTtWuxwm+7Dw/ZLTFDo87x7GxSHmM75wyU1bjAq8b6vFGLtH0nczqIG6vTC4vRZoIGCxYARBxRZ7TrzH8CerQvgThx+yFuEB/VJtm8Qy1WgWvb3M/U9bLspNRm7ePOXUmYGLbvrXWwd218H4XE+cyihyzZFc2yhpBlld1AMwgTs9Mk3icHI72cCZv5
 gtr3afAm
 iOmQdCjQwq6Jy6Ngai7D9Uei5DQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/11/21 00:21), Sergey Senozhatsky wrote:
> +static ssize_t writeback_batch_size_store(struct device *dev,
> +					  struct device_attribute *attr,
> +					  const char *buf, size_t len)
> +{
> +	struct zram *zram = dev_to_zram(dev);
> +	u32 val;
> +	ssize_t ret = -EINVAL;
> +
> +	if (kstrtouint(buf, 10, &val))
> +		return ret;
> +
> +	if (!val)
> +		val = 1;
> +
> +	down_read(&zram->init_lock);
> +	zram->wb_batch_size = val;
> +	up_read(&zram->init_lock);
> +	ret = len;
> +
> +	return ret;
> +}

JFI, as was suggested by Andrew in v4 thread, this should use write
lock.

