Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B674BECD6C3
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 16:07:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09F2B6B009D; Wed, 11 Feb 2026 11:07:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04C4C6B009F; Wed, 11 Feb 2026 11:07:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E91146B00A0; Wed, 11 Feb 2026 11:07:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D7F7F6B009D
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 11:07:02 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8041C58F94
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 16:07:02 +0000 (UTC)
X-FDA: 84432654684.14.AE639E9
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9A71DA0008
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 16:07:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Bf7QB1RX;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770826020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yZ6DHhy5X0Na+gJDeHC2tBaf7GDTkeGvvSeEIpATl0U=;
	b=SS0aBME/d0xmcD888760sGJqSCbFM0M5HxRDGDXDvOLljqvoecmC2vg1Xxm521fc43xvLN
	eDCDNFwd+wYjHQ+YUPsb1XdzH++NJwWiYi6zrxbs64lDjL41g/zTZR8yuaZlsoDmSBIitO
	E4Nw32M+7RoHN9lr2qAu59sLZZnhLxc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770826020; a=rsa-sha256;
	cv=none;
	b=nLim5Bzf9uC08LKDr6wSB65pqsNZOig9P+w88A1G50YprPs51U+uBl/05aA6mpK1mbjpai
	1YUZjNszzz0uziW2m9blFYre7jw7cSFjtORk1u25V8ejg988BffFLGn3+aL+G2mHp7n3b4
	iy1IEBjf8Lr53PNjyjwh81RUfFq4Lek=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Bf7QB1RX;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8c7120353f1so560057385a.3
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 08:07:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1770826020; x=1771430820; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yZ6DHhy5X0Na+gJDeHC2tBaf7GDTkeGvvSeEIpATl0U=;
        b=Bf7QB1RXTQMdb9RCcZhyHxwghhXb7WavQJyyfJ+IpVcjsi3sPW9oZP2WuGgNb06GTe
         le4d4l4LVSvUcfUF+sGE4Uhogx6SbJhaF+w24emAVjRbEoxJ7RQX2YAGbMH9nRclLYOU
         V4r3Hpa6XhxdENybb9+mcMKLc4m43VOOqgScj8vFG1w9lcP1gzXcIK+1hXBuwJgz83Y5
         maDf/glr2fCsD/vN56tPPqHhJQpOAUTbrdC9ZLAYmb7kCdkkYScx0AfybsX2kmkuhcVp
         pA1N8aiWEjnsnMAjvVRs5/YUGhcTgqUvRNeKHF6JaZ73Jd/wKg96MoZhvvJUaay7B0Nk
         d94A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770826020; x=1771430820;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yZ6DHhy5X0Na+gJDeHC2tBaf7GDTkeGvvSeEIpATl0U=;
        b=VSaeXPjlJJ6Z6nqNH1+vzSEeR8J/BxZH1tAbRxsQX83mVrvlMMC6/Cbnl6lntlFLER
         OODW/1GQoYq+5nOpnRRgxZcbAOY0H2/O3VSb9zX4M66lM9oRDxcwBLGV7GhweEeVEaVc
         LzH52O5ZkXEHaHbUs91Hfao7DM9GoAeNcG0aa2qUMG7D40rIZLSFLKHuxqkcUF2zp8Sf
         /s5WU5qq1c3COj90Vak2x6SiQDtSLWTio5pedQF+55Bx3TiDKh59avPfhbVDSGuYcWyQ
         Tf1qDj16Tvq9Klo4mjZtFnD73OJNEJ5A9khv2YFv1KGTcit7vr0N6k8O98LaIRmTh6do
         0NYQ==
X-Forwarded-Encrypted: i=1; AJvYcCXqz28iggHYhv6Lx1KsHgHOTqG2PDY9TKgujgkiNgngmrTVr/iFMoNFOl6XX245s1cJL0CK4B8xNA==@kvack.org
X-Gm-Message-State: AOJu0YzaKkKRFEC2ajIP1EHjT/vMPORPZrrX2HqwMl818vwdA9fjOPL8
	1Oy6AA1RA70hSLXh+RQB1ktIG3dGjimVgv5mVryL0V66gyaBHV1/U3YaPoUMBJQOnkQ=
X-Gm-Gg: AZuq6aL/AblKAS7uJMAoF78cM07M3/fNc2k+LarBXTNZDMXKmLu+AiXfb9vmBD5Iipe
	DB1vv4LQuVHcpJ7S/9w5chCyd/5dgV0EMKZ6p46g2IrBanpPjWRhKjvan12AYjrVqBz0s6AEM65
	u0dzY+hCGomzYIDgOXz5d83nL1FILAjlQMCTgc4rlbky+vKPUNc4BYpRRPL7WJWmJcuxJjKcKU3
	qMsnfqb8uK36Y0Zhddjte7SGFsi9mg2bI9uYvMTH/8xVgApEwukRZSyMbR5MiuDTH8O561aMvjb
	prD7dr7uc1BJAph31qSPBIQkU6U3FrIJWCoj35moV1TM+7ZZJbD6CLtgpZFYndS+Bo32FvOtAYB
	G9yCi4dIhehVHr4tFny+z8/bVqnwMEK1e1suaUxA7pWBUT004j8+R69vP69sMzPF7+Id/Kl7sFW
	RQ4GrAV9erMf8VyvHwZHahgX0Zw+ypyJll9BMNah9hi31GCtLoppxvRI5DPXxRwj6DetrUfZBqS
	BQ6anoq5Q==
X-Received: by 2002:a05:620a:29d2:b0:8c9:fb29:e1a0 with SMTP id af79cd13be357-8cb27f73434mr451398285a.7.1770826019496;
        Wed, 11 Feb 2026 08:06:59 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8971cda750dsm19906386d6.35.2026.02.11.08.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 08:06:59 -0800 (PST)
Date: Wed, 11 Feb 2026 11:06:57 -0500
From: Gregory Price <gourry@gourry.net>
To: Bharata B Rao <bharata@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Jonathan.Cameron@huawei.com, dave.hansen@intel.com,
	mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
	raghavendra.kt@amd.com, riel@surriel.com, rientjes@google.com,
	sj@kernel.org, weixugc@google.com, willy@infradead.org,
	ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
	nifan.cxl@gmail.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
	akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com,
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
	balbirs@nvidia.com, alok.rathore@samsung.com, shivankg@amd.com
Subject: Re: [RFC PATCH v5 00/10] mm: Hot page tracking and promotion
 infrastructure
Message-ID: <aYypIYOktgaVLqDM@gourry-fedora-PF4VCD3F>
References: <20260129144043.231636-1-bharata@amd.com>
 <911f316b-87cf-45eb-8d9e-412473d7176a@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <911f316b-87cf-45eb-8d9e-412473d7176a@amd.com>
X-Rspamd-Queue-Id: 9A71DA0008
X-Stat-Signature: bp3mqhhcnj8jg8zd1r7xhr34a7w1ancr
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770826020-708391
X-HE-Meta: U2FsdGVkX1+q3GS212khwn9gZ24x6nHVWe4NKzjmHg5sntV38Xw93TsaIO+g0fvzXsgfZBrqKca2+pBac925YM0De0Jif+RZMa8ulH0VO4Z/5/FlbKqobZRuXSKtoUZpDrP7qnAxScazHESys/5vvnR0MgZ8Uln3NwT0/YhfevNmZxOjRkOPyZvPjtDNAzyAEgcFxeI51e5Y9J5VN5sQFetlP92EvFxes3Zg/noN4Cy7LcClFqA43W/9Ummew15t45Sce7IVuWDWzxUflDz0eqiUJGkLGPlPBTycQ1wgJ5Q62aumx6FE+xmlRDZ8afSJ9WsKxkyM899YHY5arud48hspb3lF8ywgTGX7fbFwjNxnUB9c8qnhfiiC+H01U7Z14G0BRO3Msr0XS+sBVTSzh7rKluu3IbvooizEwgPJuAfwQqRWIZ3icVU1fbUC38ZYtEoA1wczyu9pckFYtfPB3FC6lOITT4tJkdk4C2l8q0kQFK2uJBFkT9a0YpMWywj90skiFy46GDJ4shmQN/4Lf/+2fIf3LVScXL500btZutIzZilMqgx1Tf9njJHyc7lzebQcE2uEJiBZVLGeWoCgX0ygwWGz0s+L9gnLZk5Jay7sZVNUq9b7uZflgco01NXgiceJ+WCFhXhT3iQXJ15UkzxQvxW1361GyY+uMx1mWJKGvxqm8YaWtPRa5f5+C1tQpMH5NqYjcnKhOgeqxAr9kguRMchEswMEIU0kEDOQ1hOMWZxESIX/5MyvIDTCtZ8VRYtYTI5jgMLYbMUvxpX+k57jIXmaH4PkK0x4IhKumhGvutvdSWVxl9PAgIQQ4+u6CRwdHE/e5Vx1X44zLO2i4UufOcHFu97mLrlLpoRP9jfUeHoKZtQHhKMOLzy8qDRUK6eJKjTRhkRkat6hIE+axps06/BECX/XOzTFLZXln6j3OmsQ34I7X3F4s/5aakGWyYCtN15nZizbDQDMqO7
 aEr924QN
 jE/9fJvWiDCmyC3KvOu2QsAro2RzSuocJyMWBh2ppqVSnA7GITQhsrD2wsUJ0H4mpPXVNU43+7tD72HbyCKoy1Au3VwuflKIr0k8ogTyX4gqCAUAXgIgpefH936K+znbyLBo5Fc+KPeYaj0/yslIr88D1Y9T2CJ2co3lPwPLJ5ypvOUn6csHr5/TAIqy7foTxZhwc1aRDhVPGhIHQxRXi2Z0LBVqc1cPoic0uubqNobi8vGpR+s7ApCiMpcUWROd0JDUpM2coBlhXxpCvImF8vOwENIqphWZoD5ZNsH9wkMayJLuuHxyRTpR3P1Vj5TZ2CLzxqyboVyTl9yGrY/idIeOgSnXsB/Ue7aNv4LOQKteTzut/pUEX/DXFKYP4Nk5M7pLI5W39885XuCPI9CUIqVn0yaqQJhsjOG+TH5WwojljhRM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 09:00:26PM +0530, Bharata B Rao wrote:
> - pghot-default mode doesn't show benefit even when achieving similar page promotion
>   numbers. This mode doesn't track accessing NID and by default promotes to NID=0
>   which probably isn't all that beneficial as processes are running on both Node 0
>   and Node 1.
>

Lacking access-nid data, maybe it's better to select a random (or
round-robin) node in the upper tier?  That would at least approach 1/N
accuracy in promotion for most access patterns.

~Gregory

