Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B49AC79FBB
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 19:33:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FC626B0095; Thu, 10 Sep 2026 15:33:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AC5B6B0096; Thu, 10 Sep 2026 15:33:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C2E66B0098; Thu, 10 Sep 2026 15:33:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 089EC6B0095
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:33:20 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CB265A0675
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:33:19 +0000 (UTC)
X-FDA: 85198851318.09.8BDE48D
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf13.hostedemail.com (Postfix) with ESMTP id D736320004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:33:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=uZiDh02J;
	spf=pass (imf13.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.50 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789068798;
	b=zUAwAN4oQGWeXChTuR8yDqzb/Ch4cvsNv2FUsx7C6s7sxd7acXbhoesXJhBNw9o2zO/hUX
	WE5Z4jtIb+/l5m17WgBbqDcZ03tnjQN54VmYpxbwjvkQQgQeGRB7SeVOIPNfAesa0wZTB6
	5x7kT38M23VZw0Ig5qdn2fbZ0uwnhpo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=uZiDh02J;
	spf=pass (imf13.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.50 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789068798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1dkD1VVTYJcnhBTGjXiLs+nayeiUFA0BtAsi8htAAaY=;
	b=qGsYOiVQhG4DbDgcDkfgfZlNtbJCRWQwtVxAy51yvMGGDnUD1xTaflR/4lhnp1rhlW+VZo
	Gyu5Adj0xRz6RHgUZrwsOA3wR0Xki+IpYoB5fmLX4yPtQwitp9Cd8QVxp8sed52hnJltb8
	IjnITM5M0cjoXfcKzRomqZl0reE9QtQ=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-9106ffe17e9so997586d6.2
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1789068797; x=1789673597; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1dkD1VVTYJcnhBTGjXiLs+nayeiUFA0BtAsi8htAAaY=;
        b=uZiDh02JR8b5MxyHDlVgU0O9BXYr4V/cwS4fcnGBtY6tcReM4gw7UJZ8G0DNb/E2eC
         u6/ttB7Np7dmWCSj6Rw+/iUyrkhzbcHsEFmCEClI1muCYaty9dRNZ/CrgzJ47XIXa5P1
         GqT+DgIui+g1CKQgXJR6MikQpyFK5Z1n4IIRC+SP5nNH4qOSMkOf6ifMjkWPZHXFE4h+
         AntZ5O2yQpcs/vFxQt8zvxeIvUfvowK2++qs7dnFs1nE4z+chyjao07IctMGSWlNPJVH
         76GBeGlq1aBwmV9inanhZcPzibo6BMvzV/i4d/9mGgjU14FUBPG0E106IbrTN5+pzo0Y
         XB2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789068797; x=1789673597;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1dkD1VVTYJcnhBTGjXiLs+nayeiUFA0BtAsi8htAAaY=;
        b=mg/pfayhsGEFtaAnoPmoKXmr/P168HYH0mtdKc14lixynhy9S90pataWg0l6GuLYfc
         Kq87js2S1CZZNHne+CwbSIooKwlkuTnMcoYbZOMYtIZjk9twrh2DR0OGsSENzSZ+DeFE
         Z+hQciZCeMfOsV2SNF7VqsYhkrMJMEM8ZVNO6BhQHXkrxrMbRxIk9N3R8C1WR6tEnxOE
         cGu4pUBRhgrJmMQOXA7jmYwpTciZ7aDHQ6z4vXO0x28lBfGAJLIgVgQworWCvYA2FB/n
         56Qox4Do+uX1IOByJB2XY5kUiry6+kJdzOH2SHZ2n8KgXNn6JsjzvL6CwnFObRy/+Y2b
         qS+A==
X-Forwarded-Encrypted: i=1; AKwUvByFoT9KRHDNaMXIdUssi5PlWkcXz9b9EDDsYGugyRDyNRq43adc8suz0q82gTBTDyQlIVGgMIoqzA==@kvack.org
X-Gm-Message-State: AFuF++nKpvDIGLHxLIepYagHwwEX0KTL+7Cm3S1bYOzGrQfzeFIyBXuZ
	NlEmNWTkaCLvJzbwtVJHlcc9MHcMrxDs/AYivqIzcYptOsE14Bp3u53LsBqBipYQZ6M=
X-Gm-Gg: AYBFou1xIhmOOw53weaFmGHSbtQinuJt/k+V4SBbrNdwJvqMzqu9kthxvfQpfGKIxex
	rb0sU+XqqMD5QvFicz2nJcPIPB8xl+b20r68R9yC3klznPEPzt3Co+2ySudkLT+Ayrtz+zoOmAx
	EF7EwFXD2fXsZoOwf+lmW7QbnbwL+PMxeX8sVrydF692gnLxR2YqqBRzh10Z2dnbrfz+sDiJh9W
	PcbE90jwKxC+kf5Mf40iqBlCHTfJFfyHwGkmZTXT8JA3ClgJujrT3bz/pCBAmbHOmVAbFN6paeO
	0t1eBr+6gJ3vs05M4wHiDgHqLftN9RRYxxtHMnSNtRatPDv3ER0fMAfvyX1D0R0BqQK25YQh3B5
	Yg39wRSeU/rFW9tdVquyvt720XzYTP8swsTdoAa7CvPWGpeOshpp+3K7sJKQAnmi7K+qb5USHqA
	QC5e2jEFioVxTiyagivJ6eg/MxYnfdd2PqeLCqmMcYHSCSgQqQf1FGUjemZI1QkeKUTAHhxA==
X-Received: by 2002:a05:6214:b65:b0:90c:e89f:14b7 with SMTP id 6a1803df08f44-912120dc801mr3584756d6.20.1789068796634;
        Thu, 10 Sep 2026 12:33:16 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f5e880csm3140256d6.49.2026.09.10.12.33.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 12:33:15 -0700 (PDT)
Date: Thu, 10 Sep 2026 15:33:15 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v3 3/3] mm: zswap: reuse zswap_invalidate() in
 zswap_store()
Message-ID: <aqMF-2AAHRbScyk_@cmpxchg.org>
References: <20260910123544.818146-1-wangkefeng.wang@huawei.com>
 <20260910123544.818146-4-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910123544.818146-4-wangkefeng.wang@huawei.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D736320004
X-Rspam-User: 
X-Stat-Signature: 8xtsgpmctriqfdz8yodyrja3rhgnn77g
X-HE-Tag: 1789068797-118528
X-HE-Meta: U2FsdGVkX1/7qdjweQ6+/IIMgm4/SloWmWaBm6iM+Iyf/Jp3gP5HVC9531TGZuKw6M1TXMMcKwZdI73SgiBZDF2lF67iYswZ/mVdJsZx+CMl7qDZBZYHrZVZ+BvwSjQw0xpZccQSsYjQu/5Q522sP5rnLLpDYqwjJIhSiBKCG/psWkc7g4JOWYYAaTwpkCgo4xe96wzc+qBS2SVtrJLSkllUAM0J7H9Cj5Az0QbGtqI+G08zrP9/gIEBDrHOYJICj3uIVDY9ZfercsyqEFm0v7a4o7n/w/3EKkeQFZkqBu+g9Hqh+zsyFAq7PDu4sTbUSQ70+oiUoBmXGbaRBjdFtHe45gOxZLupGrt8eg65JHIRzxhbr8P8TZx0Dj+a95F5mxCytylzo7nAldxU9SOC9MF/9Xs3UeTCvJF6ovsaaGFmnsltkHVTT1v7kChPAF75ylxIyw0XrCKgZLt/l3SecrshbXTJWp2Kf0RT0A3H25VHwzkhFsnbCRTLh//zHNJ2wX9qsn+qD8kpjPc4fuuOdma9+0BmU4b/wJbHdZL4DN5VpS9HreKSwoRRq9VGed+eDJyIRGUpurpYJ71e47hlO31xz/KyH71+X2L7bMwJZUbqgnqMBjJMvbJn73DmvalyKGxVwwdLqFVwCExNqr1RzuZInuUB9JEVk9MD4JFoYQMKZpoXtELJk9an8MPrLZ4wFvz+hP49NIBQy2sa6Wubr+rERWQe2mqYWLqCKxzt9fmIXRMZ4heo0p4FnqOOo/F83O9GUbN0goP+SDFbsHhWihhDYFR9nGfHn/vGhHJNHL/KHjAtnY14AMZJ+9lZe2t7Qw7tYypvoVQyj2M0tWf9gHY+HpM15nqjN4bc0eBJ7cxfa7LLM6QCsVO3hQvVLpL7IGlCJ6pSA8rBZs8IpzNBKhar5zT2SKtuyzcB1Ckb7zQaiOfpwLIt2DFaVLTUR9znsqJkxUzzCCDtgCbMbaK
 cDGO42eS
 d7pPwj/IM2GfpI9ZyHlQryCMSrapI3T69bh7Gq9SimF7gr3Q+hAoPJG4/8TAjkskUhrGXPKh1/7l+ARHC113ct3OV6X6wut0ho5/nOFo4+1wWKZwpLIbqBweo778Yu9z6HrFiE2YhWofR4mmOXGAtX3qC+zo1lcZSJhaAdpnwSyP6YzRDn3eDES4sGlKWu87ZeJcnri62+MZmXQdb7qRGxOKcue5E0zYk2y6O7cyarLlgD8W/UXbp9Y5lCkm6YiU+fdnmCVk9n+f9wUsRHgZTL4nFtSu9dGmYucALVnEJNVqqvbqPhk3bxhvTPE3nM0EW9QsQDxra1Dmvg+rsUK/zFYt80rpfkizXFPwd2ScgZiy5rem3QDZHspia9TcYexxEhC4H9mRJHUN3bP2VsM4Ohf5fvUrXABw7gtrn1oJb7Z0bQs28p+ht9vJ2z5x2QigmnGe78ghLevs6zIXSJn0PFAFas6nfgaD8u76rgc07YeIfYPrXkmO2jk++vBI6KwWJDX8r2poaefwM6eFZjlN67LYw4oRY4YH51QcCSbFSMnT9YB4XhkrQWc8atA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 08:35:44PM +0800, Kefeng Wang wrote:
> Reuse zswap_invalidate() in zswap_store() check_old path. Its
> zswap_never_enabled() and xa_empty() guards avoid redundant xarray
> lookups and deduplicate the per-slot free logic.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

