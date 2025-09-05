Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 696A1CA1002
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 03:26:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94B268E0009; Thu,  4 Sep 2025 23:26:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9229A8E0001; Thu,  4 Sep 2025 23:26:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 812AA8E0009; Thu,  4 Sep 2025 23:26:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 682C68E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 23:26:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2008113B90E
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 03:26:51 +0000 (UTC)
X-FDA: 83853759822.27.D0BBFD7
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf27.hostedemail.com (Postfix) with ESMTP id 70A9240004
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 03:26:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dUUMQ1uf;
	spf=pass (imf27.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757042809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oeyi3n01t4aIJzA9XIk7XbjaZ2H4gsDQPYY0+pkWYng=;
	b=yMcRjlsbFeIzvHDg2IcmyOr+8dmIcozBXNuJkEPssBkAacv2CeVK9NMdt8BJcys89VsA4q
	Mlil5bW2h/sCMIQBySo2lWK+VqYA1fKTvHhFFEJUORRW7lz64IAPHeW9W2xJ9lymRrJl4s
	lPmyNQD3qzlCvYq41NA5T36Kg4lIluk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dUUMQ1uf;
	spf=pass (imf27.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757042809; a=rsa-sha256;
	cv=none;
	b=JwqLp6f6Oc9lt+KUwbRNqsYxAPum8jeskWQFz4bZzqYNWtfsYBBZP3BVCVDgWJa5kebAOc
	aza2aLOH04XGbs35lc90hpIpje4vvdcrighxvk85YRwaawfMrsfr9hLbgYH9vJbeXvAOam
	Z8mroriKJ1kOP77uHbmPMDOduX5Knqw=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b4dc35711d9so1140210a12.0
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 20:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757042808; x=1757647608; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oeyi3n01t4aIJzA9XIk7XbjaZ2H4gsDQPYY0+pkWYng=;
        b=dUUMQ1ufYIDAlE3xKQz7TReyUHhnERnBZDQGOp2XKzoKXbZfjJYJxPAgWh3a0jslFu
         4qZUjf6GTaKpCD+0qNs8uzb71ymWGxZIXMN7BQinjXo+lF7QxMyhjBiVQQ+XivXwjV5U
         3ZTF9FnW/1v7pHlNntYll8IukwcCWIxwBBd6xQLyLOiEUtcYdN4ULE7mIhakvxBqER+m
         VBAevL6ZVoVjuP9NS/7PIoAT5R3FMTh2OLpDSS0XgIQg/7CuNjgA8Aatshnsw49yor9k
         DWc32sL3Rybt8gIRPgNzvHPU8B6o7SlNST4QcGfncOUdMkJlpkrNUAf6llK18cdT4Oi+
         LAEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757042808; x=1757647608;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oeyi3n01t4aIJzA9XIk7XbjaZ2H4gsDQPYY0+pkWYng=;
        b=dMHeDSYWZx6liVJOemLDXwS9YvmlK72Dk6vNuObSRuvqjcCQ4tFsyzHCiTwnVuFVmS
         1zsgGnzo5Ij0LsvZJzPCAm9CHrtK9VR3Ud0a6BjHUwQCbztj4NMxw7lYWrO31F3QYl1s
         6CH14kmmDnCyfIs2ECWQkIomtNB5awGo5+m1NqTnpTDtNRCkRkx0n0Erpb5hkfSuaa9Y
         eZG0pCn3GdmN7EAsz2GJLmI1guvbQqhbwRnh3Okt56T9wBeeilgKVo+FpMu1DCXDFdNJ
         wwZp4ZrYjbpjjHhVz73APAyDqDBuQ5wjeEWbh79SDxjm1hOfjcvgQRZOPsWrcYItC49r
         7JlA==
X-Forwarded-Encrypted: i=1; AJvYcCUjCDvXo7UuojbSsgxR+x/BEClSqxx7ML4OsqfNfI4k2KkxgiCU9LX75R0vsSyMppmj3RYZ/QuczQ==@kvack.org
X-Gm-Message-State: AOJu0YxQIbAp87U5YLPeZj1tQM83FtJwccRxORcuIQ3JnUj4jwu8IQSs
	SqG5LOgP82axw6lEdXFj57MxM8kTqBma7r8nfhOnGBMckVfrvOJGyAmH
X-Gm-Gg: ASbGncsfyHRmXL+78u+DQLpO/gL8jKr/IJ7TFjwMrvMe2uGd0gyD6VTXyS92AjucERV
	+Q8nCqawKKAfLsCemUTyn6CW7lCTY+f9+VYVsLcHOtl8bkrH4HM0MRWqeeqOZf0p4QFwTR6NR5V
	mlxDGzidCUPxqzj42C77+FunWi9bfqcw65cEHI0186K9poi42Lukk0j1W/03reyrNLO8biUX8Cc
	t9p2nKNt0weT9EJu3WpxMy+NZu6TCnveB0LA1tZrDpu5sWti4UjlqGdHbV4c1XjyHgyGW4QdaMo
	kSpS0douSfl5rQDRpro0SYymE/6DgQMwQ+1WRSy0OUgtSPEggPIFpqOgeZgSAOOL9p+r6Ztg3w+
	ZWPNMSvaZH2Uq4SmmOioy7LgcFlkz6GGDZVTXi95KrZICeQQb7A5g//P/
X-Google-Smtp-Source: AGHT+IFXVMkMUJN3DFZuthUkwDTftqC1d/ccwMy5XAIwLxCjAlYyFXNSSGpD37z9EqnlLzHSbLAqgQ==
X-Received: by 2002:a17:903:3d07:b0:24c:92e6:3921 with SMTP id d9443c01a7336-24c92e63c8cmr116818025ad.17.1757042808165;
        Thu, 04 Sep 2025 20:26:48 -0700 (PDT)
Received: from localhost.localdomain ([2409:8900:32e7:81b8:10d8:f0c:6aca:dc2d])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32b9e92d6e4sm2747793a91.8.2025.09.04.20.26.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 04 Sep 2025 20:26:47 -0700 (PDT)
From: wang lian <lianux.mm@gmail.com>
To: kirill@shutemov.name
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	kas@kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	wang lian <lianux.mm@gmail.com>
Subject: Re: [PATCH] tools/mm: Add madvise tool
Date: Fri,  5 Sep 2025 11:26:13 +0800
Message-Id: <20250905032613.76910-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250904175729.1029735-1-kirill@shutemov.name>
References: <20250904175729.1029735-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: n9xc3mi1ihwr56pw4o7kegpp43ddwx74
X-Rspam-User: 
X-Rspamd-Queue-Id: 70A9240004
X-Rspamd-Server: rspam05
X-HE-Tag: 1757042809-562742
X-HE-Meta: U2FsdGVkX19DIdkgLQFngF3L+FSnJcPBzGje9ENLBsvf/IBoAFvSN+KNy84fmcVwJyBxHX4AzS77CY0I92HS5WUddd1EuD6HjITW+xonN5/SzEu3I41T2GmSDK9yID4ORzZ5ia9sGJ5eqjsUe1JVsTwiODE1MyqOudA1TDydSmyJNaIoQeD/VeCrUubUR37zUvfOXbkvjvO30g0slhx4YjirIQMMlvw3LVGwvWIp6qVjDX1l2Pbj8NC2hK+ZSpoXlSCeQbgBsBcopMKXzA85+iC3UXCUGSrEkXwth/y/GWYS2adK7cAz2mnVSQDxq9nm5FkkC95g5m41+/oLrNMoszZA3ZhlIzW9+F4fgl2lFyJ1LGtvSq/CqMEDmbz5IBAoO/GwX1fUBPcFJnXxVfSk++hl2jAoW5qnCRuRXxthh0t8S5ckytNL9kiNGYWY60T99e7KZKs8ozG+faFTmiiJyA7IqhVNEIb+dUKgTs1W+7UqMemsiURBXp/7w7SX2AtMCwD7K4mCb9cmLrOxo+L82EAKevqrFvhIHwYOq4HJbQWZiZGz+Fg2HXyLsG8kXS2F106JiPssFLpeNVCoJZPCkmtij6ZxiZvH6RUgFusWD6F9jHoQtL5ZkReSgiN7oLUBWRL+wIkXykWpBrY+z2/v9X6gNtTYtfiCFL041fOK+NG6qRtbQhaBXsw2IiLcv1l5vieItDGUhSn8YyMuzUo0LJRdKxbct69p8K5A5P94Jbr2X2ptmceM6BO5EWy+U37kw33kTw179EbXCEW8PZt9cmQXzvNJlUHW62WfYSKtXFpc3rsg+fJDKq0j8FBStprHR0/mwnGIBq31ZDB2Qf6fMrwJOziU36aa0NhVjWSluWqQPj1AUOYzkVDT+46Q93Rexew2dIEOSlUcArLU2mYNaU0Eqv68YOQr8tbpxZA0CeT3AIwMGCiUnF13gTFIsf2Kf8/je/4PMTk7H9f1qM3
 5kCqkn1S
 YgVbYBYbSBYZmLHhtkcM6YSp7dDSwJ6qqJlMlqguo0ma/NPu3mef18/mHA15gjKGBFzNaSZ5V4Rr9lyfEHM1FPriByeA8spgnIE+YXgP6APNvLjptpt3bh1IXgdKth6YRYB+VOAGw6LGqapKIPn3abpoAxeCAZGQJZxh5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000005, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> Add a simple tool that allows to issue an advice on a process or a file.

> It can be useful to experiment with effects of an advice on a workload
> without modifying the workload itself.

> Only supports advices available for process_madvise().

> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> ---

...
> +#define PMD_SIZE_FILE_PATH "/sys/kernel/mm/transparent_hugepage/hpage_pmd_size"

Hi Kiryl,

Thanks for this patch, this is a very nice and useful tool.

I just have some super minor nitpick on coding style:
(a) Maybe move the #define PMD_SIZE_FILE_PATH to the top of the file, 
right after the #include statements?

(b) use consistent comment style like this /* */ 

(c) when i test, when process_madvise test fail it give some message,
i think it should add into in the prompt message ,like this 
> printf("madvise TARGET ADVICE START END\n\n");
printf("should run as root\n\n");
printf("\t\tStart and end addressed for the advice. Must be page-aligned and valid target pid address.\n\n");

Other than that, the patch looks great to me.
LGTM!
Reviewed-by: wang lian <lianux.mm@gmail.com>
Tested-by: wang lian <lianux.mm@gmail.com>

Best regards,
wang lian

