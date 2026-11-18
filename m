Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0BCC606A320
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 13:40:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0ADE6B05B4; Wed, 18 Nov 2026 08:40:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE22A6B05B5; Wed, 18 Nov 2026 08:40:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD0CE6B05B6; Wed, 18 Nov 2026 08:40:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BCA906B05B4
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:40:35 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 81CB7A8441
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:40:34 +0000 (UTC)
X-FDA: 85448349588.24.4C8B3D3
Received: from lgeamrelo11.lge.com (lgeamrelo11.lge.com [156.147.23.51])
	by imf28.hostedemail.com (Postfix) with ESMTP id EA1B1C000B
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:40:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.51 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795009231;
	b=wSf22mEwHuKNriVWbWrDRKsd89lukFDIXifxtljSWTNN4/3eGKPq8F9E4Vq5wL/p5Xde9U
	7CAQ+fn3yNq2GM82GsVys9s/vmyIKm67+47lPRm+3KM1QhnFAGrwSBFKa1GN4/w3grfX6z
	NKZfRQoDqlQhz3R75V0uC0HxEqgQ2Nc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.51 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795009231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VSl6vmKd8F9dLMXuhSHY6FVcVpFiASZcDBBbw9C+TP4=;
	b=M5fcaqom3sfGshmd/20GvxoUgvLBYYHkqlM7x16pVI6Q1yJaQaEPyMbEBU9xo1WbOqfJpa
	SEwPDigU6yvH3p+aIbmG/kCgz+Osiun17VPzZep5Q9QPDuliCMugJHzkZj96aUAe2H6LtS
	Bcnh7UcJ2cMnfdrYNwIq4e2e7VOdnMk=
Received: from unknown (HELO lgemrelse7q.lge.com) (156.147.1.151)
	by 156.147.23.51 with ESMTP; 18 Nov 2026 22:40:20 +0900
X-Original-SENDERIP: 156.147.1.151
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.151 with ESMTP; 18 Nov 2026 22:40:20 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Wed, 18 Nov 2026 22:40:20 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: linux-mm@kvack.org, Rafael Aquini <aquini@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>
Subject: Re: [PATCH] mm/swapfile: really fix integer overflow in swap_show()
 and swapon()
Message-ID: <av2qxMxZXDIlGsX4@yjaykim-PowerEdge-T330>
References: <20261118112610.122799-1-oleksandr@natalenko.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261118112610.122799-1-oleksandr@natalenko.name>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EA1B1C000B
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3s1q8uruaetd57ykrem6y1rdkn5wtip9
X-Rspam-User: 
X-HE-Tag: 1795009229-443352
X-HE-Meta: U2FsdGVkX1+/Uesbpf/NVFxjmw0lLfsJQIh3JkHqGb3F9/enocqXgQe+Yl8wtv1ZxtT+fCpXsi24nrlyO0+ObVxylA4JP4TWQmW+2mFfcx7hy7L9x+mMzwhw8YMM1aLee0S7ma8zAdkqrHBFwXo485P4cyE7pITp1/KDLp98Fp4PEiwn5PxGPsplrNl6XgOWQJeM3oBaNAEmtJto/n+yyl3KwaGY0J8JMm2yJug2EfF5IPVGOlSdXSmlYzVYkD3ap+q8xj5Aqm6fvaQK0htEc2U9i/cszyxtAbn3ovvk8TutxqOEzgcbTYor58ubaXxqJy9/sp8PBLgzlRiWBvW/dXXPloUm0hF2RBIGRyT1TfW0m5O60/HoGQTP+z2OCkxedPm9j8fUzZbD7PXHiv/E7Mb0SGd35W1BtC3gYLLaXcQKWEf+pC9Ua+ffQC9DHABpw5IkCmcGJwM0ce22QqOsBf+FEEyXwfM68oyT+wF+UINcgQTeW9O3ShOzAmC5LU8h5ukrHtBhU6YSZ2PlTJ5Gv/Su2siwkDjYIFlao9H09GBEnyeynfyHYol9LmhvKdfm4iR1s2muBW53wTHJQwiMwDiXtAaq4dUiXnzfjWtysBh1yk4cxR/doJGSYgx2/B1iWWlpwLu7zjq9wpA8ncBuC99JJNpHMht5a3viE/fBQJRQmmb2Rg0g5M+7Kj4EujjWgfbJJFeUOiPCSETmgmuVvcCr1xqS2YqnLHqSH0miCFrGp+/vBPg0EzelrSlSUCHU+TXUdhX5bDPkj1Cgt66N8cFFKcKgDP4z9sFY0Ml89UndV/OJofyaxx9VqGgQjgPl53ionBm5CUQWRuNMY/9H6J1OPpSTICQYjBW6lkYtqDQiwSwG2DazI69v1gG+DFYDQa5QsXhkOKD4gwi/qHyawAc0MlOqi2OV7fM4/VX6qCorg5TwKZaqAJshlv7kcKKF1I/BgvBdQIFY0Fg0nkW
 o23UWWFS
 AjJsxRNtIKzqMMpSY2hccT6QMCn8Uues7KdhGY6fgUniYl2BvT0yUuSviIRtgoThaY2dmuL8DMkiXs87/eSVu6WxrFVfryXq3c9t6G+0v9kkx+GG4KckjVGCpLmheUdmGtF2a0EG+oelimWIwSod7v3OcytO219HzmRuY9tFlIAPp4tTSr8nmIlgVhDWeaEXalTyI6IW5VCn91RG5oYSnUQFzCLOZGQDKpag6Vqu0TLnAN0m/XNbh18/9K0fdHmfZkW+Y5GbjB7ivrFLkYyGJfI/d8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Oleksandr,

> Cast si->pages to long explicitly so that the bitshift in K() doesn't
> truncate the value to 32 bits.

Nice catch. 642929a2ded0 widened bytes but left the shift in 32 bits.

> Fixes: 642929a2ded0 ("mm/swapfile: fix an integer overflow in swap_show()")

stable kernels show the same wrong size, should this also
carry Cc: stable@vger.kernel.org?

Reviewed-by: Youngjun Park <youngjun.park@lge.com>

Thanks,
Youngjun

