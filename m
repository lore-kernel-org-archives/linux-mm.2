Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B766DF36BBA
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 06:38:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B1FB6B0005; Fri, 10 Apr 2026 02:38:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5627B6B0089; Fri, 10 Apr 2026 02:38:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4787D6B008A; Fri, 10 Apr 2026 02:38:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3909B6B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 02:38:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9769C8466D
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 06:38:43 +0000 (UTC)
X-FDA: 84641692926.26.79275D6
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf10.hostedemail.com (Postfix) with ESMTP id 397CCC0003
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 06:38:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=EP+J6DXF;
	spf=pass (imf10.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775803121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8rfhBI7v/0UCAvMxEbqmEnO+ApvS3TiEWtoH0oFeamY=;
	b=4GSmPMtufCVYHCGbtm7bMgXf5/IRsXVWKA1Gvp+uRdNJEAbBKcfgsM/V8mudooI7JgkjfM
	VMebkbsXymEuc64kZTB30v0dhEFvNwkcaYWAshM9mJNOGsnbj8kcR/qGKop/UWMx1a6Jcb
	+Uu3d4c/0e2HrQ9Vrc02N84hrZMtBC0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=EP+J6DXF;
	spf=pass (imf10.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775803121; a=rsa-sha256;
	cv=none;
	b=b/1Yg4OdJSigOyrJH8MJjvwQQ2URy6LQjcHwbLta8jlLOHZ+mPDIxpbQmqVcLvOqB7JQNk
	OKujbhUK1mAuHeOphMjolDoIUtoVsWacfOlS2qXzMfhvco5FFiBIrQ2yxIeJi43q/I6E/0
	HMZw/cqo7UksKnoHDrdsbOtGWXnVqEk=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=8rfhBI7v/0UCAvMxEbqmEnO+ApvS3TiEWtoH0oFeamY=;
	b=EP+J6DXFj55X95g6q1I4QHniIfnGhXBXOEAl2IK5+i0qbyD6dZRXbJ95jIokXsH07DCVs5a88
	BAWDPtVKEWdJqwm4l2ZgrnIoYDi3vXhE2Tl+xpS0cFOemnaQOQgG5Xf3JsdM24xpt9Mw4Jop6FJ
	RMi4Wdvvmy39VcK8dy7KMGM=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4fsRmZ2S7Tzcb29;
	Fri, 10 Apr 2026 14:32:14 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 207394056E;
	Fri, 10 Apr 2026 14:38:35 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 10 Apr 2026 14:38:34 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 10 Apr 2026 14:38:33 +0800
Subject: Re: [PATCH 1/2] mm/memory_failure: use bool for hugetlb indicator in
 try_memory_failure_hugetlb
To: Ye Liu <ye.liu@linux.dev>
CC: Ye Liu <liuye@kylinos.cn>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>
References: <20260407020715.2269255-1-ye.liu@linux.dev>
 <20260407020715.2269255-2-ye.liu@linux.dev>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <0eb4a198-e80b-127d-e729-3af6f63f6d5b@huawei.com>
Date: Fri, 10 Apr 2026 14:38:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260407020715.2269255-2-ye.liu@linux.dev>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Queue-Id: 397CCC0003
X-Stat-Signature: 1mta3qqacxxu157b7i69rgb44nh4i787
X-Rspamd-Server: rspam06
X-HE-Tag: 1775803119-615815
X-HE-Meta: U2FsdGVkX187vrOVLSMDtQ2pILcLo8m86mpUmXVwYm1806CvuKpYEdlOoZavioHtewEmghiRJXppTvRCZhbE8RtUaFM/RT7xdpmBxhs/S/N5rolECmhaZR9IdzCOiZFGASlrQgDHWNj9Zc4C/eu80YAUdk9oVz9hv9HD91PD1XgOi9ACg2HucYmmiOcafJEgm3swk3J1BnllPJjX5OxxCJl2ZFNHgHu/4GuHhlyEoO7oAf65eWtQcnCTmvxmP5xfj+zm9X+Si64vTL0cvPBw+ozk2B1ElO5YsVQYdBahgZ8hvvzFnkZcZoJJZNc8Ozb425uMnO52oR4lZ/utjiI/NAxoBXixD1MwiTfOoML7dwpZqry5oXRIuB3niYYD+LXFXcq8XFE0M6QTz7W7iUnnwJAeIsT61bWIK2n4uiPc/R9HNvvseztMa1a4PBuRZfrW/GFWp8cnQ7b9OQv7N/Gcv5jEjRYrDNPm34vhUkGWKGSAosmZtK60pjf7y+OMlntL4bBRrURVCZ2B2R0y2rc1gkM7HAywLN/hN2luAehyZQH7P5xeDC6+uZiutUzRqvKZVdahWbmRYz1TGHy0qLKA3dMvCj1F+t1iOod6U11OyIUiI0HAptAtfsAXufm6knZdT4vQBkCGim7Ryuw2fPZjliJh5+x6KhqFEp9n2mZPP29D7FBWEuOVRHYF+V13q4QVgD+hqucXUyBt4DoSNme/KOmB7J8vtWpzjU7pI6Fmxuqw7ONKtFkOkCB976Yp4ZDi2QmSy79B9YSt/Yu+mBUlj3rl9nCPA1mVm/LtCKlcaxzGRc3PW9cU/EornLAq+TcB0tpSieS2R0oh0KCzDuI3pS3oQCUgeMo0EErsSwajNpsfYf2W6OdYyF9cez2sZQ4AHXK8FUKY5Bkm8JDEaZOeFqq8ZsJuE6+EoqbM2RITCi8SH2b02f8wm8vbCUzzXA6gz0yAMcYxD5b12yM8MdN
 hLJx5B07
 Se8wC7mYsJGfg8krQVV/OhuLqSaF1a5qPVdb8Uz8nTSm8F4evnn5aNhCUSdkhFOlkBKaXE6tqYqBKHLUK28gG0aEbpIaAoGv9sBQQ+Nj1QhBWhXuvYErwQ3EQX7exnpbMoFnY8qbwAPZ0AM5Xt7ngpPiit4+Kv9jBnEz5+yJPA7ac6QFJ1YSMoyX/3np07O3Sy0afB2cXtfEDq+gLo2PfbvAUtabalSCHVieoEFlmjZGNxAk5+UR5+hDi8mBBlfjjm5vfylk1HxI0pm3tosSS5QtR69fhpID8BmtnV1b7xFI47co49VnNII7V9HFaLYGkzkM4C+ixRykRw+ucy+4jyweuRtHNwFzCb78c5jZjEyYwnsSvQrLELrt2kcEI98oEOL5vF7v6b6tri/b3g0+A28TCeHES95a0RtHt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/4/7 10:07, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> The hugetlb indicator in try_memory_failure_hugetlb is a Boolean
> flag, but was declared and assigned as int/0/1. Convert to `bool`
> and `true`/`false` for clarity and type safety.
> 
> - try_memory_failure_hugetlb(unsigned long pfn, int flags, bool *hugetlb)
> - testcase path in memory_failure(): bool hugetlb = false
> - clear semantic conversion in MF_HUGETLB_NON_HUGEPAGE
> - preserve behavior (no functional change)
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>

Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

