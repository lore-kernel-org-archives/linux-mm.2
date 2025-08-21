Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74879CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 17:19:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C03208E0017; Thu, 21 Aug 2025 13:19:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB38B8E0001; Thu, 21 Aug 2025 13:19:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF1198E0017; Thu, 21 Aug 2025 13:19:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9DF6D8E0001
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:19:38 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 71C32B9A07
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:19:38 +0000 (UTC)
X-FDA: 83801426436.20.9258F9D
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf11.hostedemail.com (Postfix) with ESMTP id 960444000C
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:19:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OKfsxkDO;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755796776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y/NLg/frEs47feD0u2U0+lbzpsbB/AMjwS0DSAmssCc=;
	b=PTGtxIpverNPnvQKXzoEX31BFDaKmP/rZO+jPMtKyQMgR2KjmrftDfulk/UjVG+bGl6K09
	qLSh6ddSRU/HN4tBniqGY2pqFC9ogQTCow+7XLq75xgACTO/m8PXMH99eQ50d6FcA8hG2+
	amMxrQtTKTBsXO7E+9i9ZZQKn+BJWJk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OKfsxkDO;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755796776; a=rsa-sha256;
	cv=none;
	b=FP0MBVwPnG/uuIaTD6fLrZl5EY7QGNUYk3ao/56jHEZ9cFN2rC4mymHeKw1Ptz2ldqwF9z
	mBjbVNJBCEQq11d9BouVTNkeI4+DwuiyHDz2CQR+l2v8DllFlk53EeJU3SWdGEz2cnRM6u
	eSkud36a4XBGdFhwaFpm9rMxZjAaz54=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 771DB5C4D73;
	Thu, 21 Aug 2025 17:19:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31E1C4CEEB;
	Thu, 21 Aug 2025 17:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755796775;
	bh=u36V95yWLge4MrLb1TEu7xiKJXaJ7fDEQmfbJlfHy3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OKfsxkDOXEbw1fAQJ3E92dEXJNDCAm0hIau16dul8nxX4lCm4hSmheKoRIZB2ONL7
	 pxD1UA/R1AuQObNGu8s53ey9KmYwwhmZyta8YmXciJsuNnNxEK54/h2aNT+M2uzaG+
	 TDuKLH0/orm8rz+jDYtAMBz1pT1sEqqMTMWaHCsxUN2bZH9dwHwwvVM6KkW0cvMBMK
	 rI/NSamy/QThI5qVRCBInvBVRcC3IXmM0DEAWor025smmu3D+ch11U9icH7uzMHRPp
	 Z009nbBIsijjlHZ9uu2FJZyNI8dXMvj1sD2fyogCjED4VbzMV6ejNKDC5efp2CNEcc
	 edjJVcNVRpVOg==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [PATCH 06/11] mm/damon/paddr: support addr_unit for DAMOS_STAT
Date: Thu, 21 Aug 2025 10:19:33 -0700
Message-Id: <20250821171933.82070-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250821105159.2503894-7-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4grpp86toqu8x17jbkz8ba76dminmo4h
X-Rspam-User: 
X-Rspamd-Queue-Id: 960444000C
X-Rspamd-Server: rspam05
X-HE-Tag: 1755796776-631585
X-HE-Meta: U2FsdGVkX19bWG2Jx/yh4hfilHyu+o9V2J9/p06/klBg9QWNSkNTsvYeq0ap9pb6M612NWwuav29FZbrfHy2pOkHRs5FnbLS+arajt66VGjsp3J3UWGydIyKZpOqdF0kGmb7s7NXsAaG9HgmrUESPTPLaDkY9dBIgmRNziHSnD/Ufo/gThWWozaMMHf+mQ85S96ou6UKPDsGkQYlI5OZY4bka1nU/TrFOso19Lq8Zbldf0dZqirwaVM+GB5d9Hs3XcY4yLj7BDrWzVi3wUe5XOnfHSEG+EqzY1q5YG8ksFu7iZeLctqzvgqLrCtS0KB3bH2CscAcO3A/P1pnPscBu5EH+ovjL1qKp9lTXaDVB2GsQjXgjcg6Po7C14d2dHIlSspaYKLIhzwkp2WcT26fWqKyIj42IbV8Fqyctq3Zv3mwRbXd/6ecIliodPzLg/Io7ZNeW2umksajodySu2KdZYhY4HGigI5h1XOMKJ9tlNfbKYkUqICIvVp9I/GSuvllXOo6S4ZR2Mfxv6JVKNYz8i0KsI4T0api6+3lMJPZD0/F1dDumDBKzo63pIvttc0SNjqiAO2SbMANw98AFROzMIbe+IMvgc5lzw6dWT1uXm8HBsYfpx97W5KPAEKb3mte4Zc9voL6k9jZf+dWhwlWJB67lxYuRCtWZaNPfT3Z6RRgktTJ2HieQuP5IzyY+A+7uTqNSjHXIzOxx/bSOKuj4WQuhIvcJpdoze7K9M5IlWJH/P9fBQSW38tsgn/SuW4pQODo+8gilQFsvyyZpMaMLkkDQ2CpjJiJ0ckYxNh834CHApVXcWxrNnE/Nu+3UC0/lcxDKpXk6SWbdbe/tyck4yxps5XEcJFZA3EVsMWZ4z2YZtZz28OCOYE09I4imiXwu1PmpDta0Re9fVWwvn3gexn90IEGpzvZKbgPQNU86HpKq+T4fDyCTecRzo0qH0r0t7ZeMq1g45mKX8Z5tPY
 8rzIJ9Rv
 LqIJs0UqSfSGYji+zXozkR3Rh5RwxOzktoFz58su0FTotZtNAzGiwl1nelbLDwALC+IALUddxUwvhPZxrC+7msSwkvCQFOr5ERKnWmIK3+DSrbvKrmJYOchehulMkMqaFVYK+C7qn+kETNqPtkih0svSVAXBpNbIgZ8S4hnvYy+Pv7beCEOvPiHa7qq/vmzpYQi0Kp5ajQ1HcghjyTViR2sUX3luqrMOe3znpSgyP3oev4UrwSH5PrP2ZoY9IXQ9P/K9JfkzLTPio3y3uzgK0ZxuqGmhAAWGbahGm3siMUdKk3dI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 Aug 2025 18:51:54 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> From: SeongJae Park <sj@kernel.org>
> 
> Add support of addr_unit for DAMOS_STAT action handling from the DAMOS
> operation implementation for the physical address space.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

