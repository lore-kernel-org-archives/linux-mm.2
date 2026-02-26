Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C65D9FD9E10
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 20:41:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D58936B0110; Thu, 26 Feb 2026 15:41:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D06666B0114; Thu, 26 Feb 2026 15:41:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C08D56B024D; Thu, 26 Feb 2026 15:41:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AA0DE6B0110
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:41:05 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 370AA1BC1B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 20:41:05 +0000 (UTC)
X-FDA: 84487777290.29.A24F355
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	by imf15.hostedemail.com (Postfix) with ESMTP id 542C8A0011
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 20:41:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Rgvm5leb;
	spf=pass (imf15.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.51 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772138463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NguBUFNmUMF9el0MqWxRk1yX+e6cF7VtARIl6RrUMW8=;
	b=OKRu/DLMGvzOtPdVi2G1K/g1f6y/jNHyWrEhzqJg0UKyHO4BO02NiJygoxrSWpZHYnHePE
	/VvOhhYSALutJtLHWwfRCFOA6G+MggU0+6fGDUJzIizZE3LwZ81CQuok3nLWFlOy1AJO/d
	/32nKPCk/Sy/tvGVJ9MvpY55FkFNXuo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772138463; a=rsa-sha256;
	cv=none;
	b=xafcgaKAG8LnrxLdC0oC7JrAphctMY4/nTmUpPqtKYY0ePHDXM5tGQFWo9oJ/KssCo6Nrj
	80vWfFPKH4GKZAOzQSid8NlmOk1s+gDOhuMKJvV91Mbd+EK1dx0+VCzRFAXe9vkWNb6w65
	nBtsiVDvU2keRuYp4XRfBWzG5e3hNEg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Rgvm5leb;
	spf=pass (imf15.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.51 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7d513bc15c7so1580400a34.1
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:41:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772138462; x=1772743262; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NguBUFNmUMF9el0MqWxRk1yX+e6cF7VtARIl6RrUMW8=;
        b=Rgvm5lebgjAZPTlvDimO7H9C1cXqoPAG8/+ClgkXYaHhQd3mMFONp7AFYWRTpH9LII
         DRDB6fDe/zgmAPaSdA0StnrOrbLVZyVEkZ3arMYgZLjRNy1LtV1QBjjQumwxIlsVCSuf
         VE4KTV9S0LOF85TZ5+OXA5iz3RsJK4TD6T2P7dqslJEWwWr6yABzJVx8X+Zy0cnAwqpA
         sIlNTtddSWmVxFIKwV31FIJbhhxAc+OZw+HoWiUcP3uN/6M8/9wYsaGFndSzf1nhlHjT
         bFPGrCGQjpyLfBmbLIxk8uMPgUNA7G4ZAsv/hdqUFE+i9bvj04GFl7x1or+Z8/gWLFiZ
         uZYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772138462; x=1772743262;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NguBUFNmUMF9el0MqWxRk1yX+e6cF7VtARIl6RrUMW8=;
        b=MPOMqBZWQwXAboMUTyJtYKxwWkRNhEMnUAGX0dlXDJPXc16YKd6mvX+eUbEXIIOpMv
         NnHgwKQ6wPLSDe4DSb86GRL/WUNYPeQLWWmQ6CyGLixedvSg4aq0gtE4Ri5jE2lUjD02
         aReLSec3Zq6MTyMD6NziaO1hgwWtT79d5wOsX6mVLovYUz3kUXTlfWE4X6KA8Gf9T8uB
         h88FeCEf6i/hU9DBp91fxrkCn9WWDLkPcbhYyPJRpNmBtcQuVk2s7uY0UOCslvHzOYfE
         9eyGPhTKGo1t8A6krodt5nTyQhLeSvHPdYKQO7ltlUI293Ht1uFNja7FFVAp5WkvglHR
         UZrw==
X-Forwarded-Encrypted: i=1; AJvYcCXMqUu8ZVxpZ1kxD0GsvHFsrFdOFYzXjuL0YNsL4/PPwe53hIwLOk/MGQt3WQqQjVUxd+fjbKT7Tg==@kvack.org
X-Gm-Message-State: AOJu0Yxh7g9iRG/DnXqvyooUHSLdZBokfKAhzIj/pgHNn321VY+HDpGi
	CSmaxRj4Or5tHUlYjugTKOhqc/yYkp5oHCPO0XEo4ZKzrMqc8xo5sKhm
X-Gm-Gg: ATEYQzyqdV78DhsapzmKjIW77cMFBVcXkkaRbEz9nWcmy3T4u6RWLd8ZNrpDAtcR1Lq
	oRW3WMbB5EQQMunh3L/lS7Wh9vkZvSaPRLoa5Py1+vZnECVsDiX6u5Tmbd175BQlCoHyXx+68Kz
	cPT9Qf9f85FbQUNRxftvELDu2/uYxxYlyH2o5LnIQCoKmBDtZLZv99nLA2xaFkl3D6YzQh4ip0v
	py+uEPwFGOurHLxjwGkrXm3Z8eW3h0K/5gOoBZu8nTxj3tPj466py++9UlZ6WPpMG3m7KdsPIur
	qIlb3TW4wFglMPX4aOsXyhQMslj5ks8xzICwERZ/sQ4x8mwgX5/xz2BJNCUtVTi1mWkLiWgoY6q
	I8hz1G1gfeZhMUmjqbJuh0qwVD+SRo4b7puHnj6xxcyXL06qa8axymLYPlp37Q+i2MQzSOuvDF+
	kfE7JYKzSqacfadf28DvSWcw==
X-Received: by 2002:a05:6870:70a0:b0:409:5241:8abc with SMTP id 586e51a60fabf-41626ddf8bfmr404506fac.20.1772138462037;
        Thu, 26 Feb 2026 12:41:02 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:73::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4160cf239e0sm2967025fac.1.2026.02.26.12.41.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 12:41:01 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Bharata B Rao <bharata@amd.com>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Jonathan.Cameron@huawei.com,
	dave.hansen@intel.com,
	gourry@gourry.net,
	mgorman@techsingularity.net,
	mingo@redhat.com,
	peterz@infradead.org,
	raghavendra.kt@amd.com,
	riel@surriel.com,
	rientjes@google.com,
	sj@kernel.org,
	weixugc@google.com,
	willy@infradead.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	dave@stgolabs.net,
	nifan.cxl@gmail.com,
	xuezhengchu@huawei.com,
	yiannis@zptcorp.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	byungchul@sk.com,
	kinseyho@google.com,
	joshua.hahnjy@gmail.com,
	yuanchu@google.com,
	balbirs@nvidia.com,
	alok.rathore@samsung.com,
	shivankg@amd.com
Subject: Re: [RFC PATCH v5 02/10] migrate: Add migrate_misplaced_folios_batch()
Date: Thu, 26 Feb 2026 12:40:59 -0800
Message-ID: <20260226204059.481964-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260129144043.231636-3-bharata@amd.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 542C8A0011
X-Stat-Signature: 6otkuhqik4b8zi9x8gxh3okk4jbkg7mt
X-Rspam-User: 
X-HE-Tag: 1772138463-615151
X-HE-Meta: U2FsdGVkX1+yvUgnm5sELynLVsFvLEid7PpdFkgQtHtsa2tjXqOQWgmi0/c2uPoGND2g94PxzSKphFW8FDc5lOSPVg3R+4WB+ZJ0j4EP3duwcdHumr5DiS64hTLEyzKa8kZeSfEyJPulBzbRYBBAK/HRhUjn8czpwX7zoV5IfNrWWQp9UI+UD0HWA5cfiu3t22pmnM64n4cXg4I2xlwYBSJqsB8uY0Dv7RHYO0HmDOCOFV9et3rdLH/F3nj9EeU6hp+seVwDDtCB0AVaNlkRTCJMteQD+jmFs0KHwlEqFOhLXpM+jz2lqv/PXwb073lzG24OKgSCMd5YvR6ynvIFdhjF7IIyDA0abZZtpKxKPGOEykzTLNlOIangbEnCFbuiOMaq030BFoVHwDt98Cu4ob7Xnt2siOUboI/Thi61Scqjb1Non0X0mCdENZ4M5Lmv1Sd6Q4ZDEddLuWw3lRDSOo8qXEqm9M0pOWxR85ajrXdermY52laHe+T+4dK6Dzy7K6CPitWJ6K7D1jyPM6PCyyp41HL1+I2CSCTHs71/+xnXyIQvlZANu3KZ0BLzAL4AQ1+XUtFLy+3iE/RLCYFRxNIksfkX8m3ApfKt/b3z8pn3ARFOhpC3mO16dGE/JRjZNAv6hrW0+C5FTUGWxGFwy6CaMyGkQgV/CMEEHF2PuIhg9B5jLyUcWde4flpQyJrIvGjtwLPYosh+ovVJCUPjzXncN675B4prk9yS+7ZGt4FxgsBQ8wLhWN1sNqjiT8AbTRG+qctpkv7/BwW9C2QLUi9AOqKdTYVPxsZa12BbNtSiRU/z8sbeAR5x9xV1sHCu4im/vHx6x16bKxvfOX9yGou/3WKz5X0sxIabou+pPvQxFxS4DWwItgtRZsQozWWXTzjknsl/38RVZzmpGD3nG1rggI1gA4DGK19zgji4ECisj3rZzCJ85/NYKQflorJCAJTNmRJnvc3IFgXpdqz
 N3u0t1M2
 O4TJ7P6bgA9OgdYEoLz4lozm4vgAXoO9eC9eknn889qvbGGwrsUxYmBx210g+wzNGODSQR9iz+PigNeyIc8mV5/tCjYa9aEvaUriJliuICrZNxX8S3ei5dyhWcdZv7bad2lhS13DF/LAt3pQanjNf/6Ao4yDm1k5wDzd6d9FoL16UwoBJW1dWK4A++BXsd41PU+CPb+65UADz1X9Yvj5pfS/l5LOeqUZXLz69EpOWulcEYir9JrD6S8sUHLFWuPVWYI+kpjHyd1y1xaEltvUQIVqGYs1xhBgpgpDh62yGtrOC23WEklaFCCcGJfMmKTeHrNH4IB+F5iwdjN9wij/uTOy+fv4ZZImEZupEYQ0d6uENvu3kUkLqghW+uFECnwmYTLpmV0lid/IUUYtbmmWLQtcBj7ehsxOHZWCLu0o5mrIxF7IK3e9pE30hauC4IR/gf9RzFFvF1nn0GhsZcytEjF3NhAGz2Ar6FLrK7NgIpPy8CxKGOgWZbUysDE3/+pkl/E1x0I4qi8S03iAH0haWKR5qdoobb29lFSmgSnmcZZlW3h5IUZaCeylaiDwheWM0rV57UrWYi/ws0Qu9E9goWVeDvgn0HMpEou6O/REOBS+66QFvfSSbZvaUwMMWVMklnTnu/zbpIEpSq+S3vRO4s6HL1CmvGLii2hsI2cNrXX0BFeVXedzrXvm3vEHqtWdcU08/jglBD0uHIpQB5lNe67VMjSMYU/JY7/4fXm74i0ZZnME=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 29 Jan 2026 20:10:35 +0530 Bharata B Rao <bharata@amd.com> wrote:

> From: Gregory Price <gourry@gourry.net>
> 
> Tiered memory systems often require migrating multiple folios at once.
> Currently, migrate_misplaced_folio() handles only one folio per call,
> which is inefficient for batch operations. This patch introduces
> migrate_misplaced_folios_batch(), a batch variant that leverages
> migrate_pages() internally for improved performance.
> 
> The caller must isolate folios beforehand using
> migrate_misplaced_folio_prepare(). On return, the folio list will be
> empty regardless of success or failure.
> 
> This function will be used by pghot kmigrated thread.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>
> [Rewrote commit description]
> Signed-off-by: Bharata B Rao <bharata@amd.com>
> ---

[...snip...]

> +	if (nr_remaining)
> +		putback_movable_pages(folio_list);

Hello Bharata, I hope you are doing well! Thank you for the series.
I saw the numbers and they look great. I'm hoping to do some more testing
myself as well : -) I'm also going through the series as well!!

> +	if (nr_succeeded) {

The single-folio case, migrate_misplaced_folio, has a guard here to
check that the function performs more than just a migration, but a promotion.
Specifically, it checks that the folio's node is not toptier, and the
destination node is toptier. Should that also be included here?

When this is called in kmigrated_walk_zone in the next patch, there is no
check to make sure that the folios are actually on a lower tier, and the
destination is on a higher tier. Maybe I'm missing something? But it
wasn't entirely obvious to me that the migration is always a promotion.

I want to note that we're also skipping the count_memcg_events, which
I understand is much harder to do here becuase each folio might belong
to a different memcg. Ying also noted this in his reply from v1 [1]
but I don't think it ever got addressed.

Anyways, thank you! I hope you have a great day!
Joshua

> +		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
> +		mod_node_page_state(pgdat, PGPROMOTE_SUCCESS, nr_succeeded);
> +	}
> +	WARN_ON(!list_empty(folio_list));
> +	return nr_remaining ? -EAGAIN : 0;
> +}
>  #endif /* CONFIG_NUMA_BALANCING */
>  #endif /* CONFIG_NUMA */
> -- 
> 2.34.1
> 

[1] https://lore.kernel.org/linux-mm/87a541e51s.fsf@DESKTOP-5N7EMDA/

