Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2951EE6BF1F
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 15:38:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C05C6B008A; Fri, 30 Jan 2026 10:38:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 777C16B008C; Fri, 30 Jan 2026 10:38:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69AC46B0092; Fri, 30 Jan 2026 10:38:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 59E8F6B008A
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 10:38:24 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2FDEA13B7A0
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 15:38:24 +0000 (UTC)
X-FDA: 84389036928.13.318D59D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7991740011
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 15:38:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZY0KbrUS;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769787502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DPHyoxrR1Nax03a/zDp8zs4tZ8OS69ZR4AIpJtGV/Xg=;
	b=feNFi1WgIOZ2TDlxKLpVBz7meKeOd23OJ+Dfqm0YVGSo7OdY6p9IiP6ybAsDJ76N+SG0p9
	ojCnDjieUqucw8kz3CmINdH8XgcA9W97bTkJ/2dhVtrHH2HjfxlzNYaxboIKKsyLiCPbGT
	EBimVx/GixBUBJo7iQAt1Gy0mLPvbzE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZY0KbrUS;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769787502; a=rsa-sha256;
	cv=none;
	b=m7fv7nfvt4yZQCCAHNsi67cQ536HOT/BSGTvcaAHPPbVh1c/069YM1Ge5O51l4BHGwwhMJ
	gqCnP+d6H6Q8PgLq508F8KOn9UKGklAqk6I6++VbmxBo7cmQMJrZLU6ZgKinGyC3iKZYHm
	G8ENWTwXoa1pW0btcpe+nvYwCM/KwYo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 388A0441E5;
	Fri, 30 Jan 2026 15:38:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB84FC4CEF7;
	Fri, 30 Jan 2026 15:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769787501;
	bh=SG6FWIoaJiK0ZkyIPU7qA28SftwgtJE++lmHxE14I/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZY0KbrUS3iafgHIOS/z8sXj5kaZZ1CvEE69JECYv9IqqCimh5NxnM7/FA4r7OF5sA
	 ulSXNbGqFG9KvtuduEOfBvUskiF+SoiYuahg089uvfCAORgJDm2HIR+eNXavpWrvzU
	 6m8CJaGeqs+uZzTMb9HyLNSdYRydk5AA7h1HlmFKlS3A4zc8515TMxosOU/TEdAW03
	 TTi2EdrdoRjMdQjLWMhTQ5V6s3r0INArWlknwyVBqO/OKi1WURVmykSBzqbwm6JG4r
	 iN5S/hMBPw8NqfZXgJNm50jkYqzdEU1PJiNoK7uJYQTjzXSgXcx66/pBgnSxNLdL1q
	 vs+wZhurqKBgA==
From: SeongJae Park <sj@kernel.org>
To: lirongqing <lirongqing@baidu.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon: remove __read_mostly from memory_idle_ms_percentiles
Date: Fri, 30 Jan 2026 07:38:12 -0800
Message-ID: <20260130153813.784-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130085603.1814-1-lirongqing@baidu.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7991740011
X-Stat-Signature: w5k7iy1ou8ef4f77ipdpyy594nktdfyz
X-Rspam-User: 
X-HE-Tag: 1769787502-697406
X-HE-Meta: U2FsdGVkX191lsmzihQqyQLt2k9naPWObtDahlRyGViK3pGQ0FQngl20d+b64GtDDwuFkwR1hVxvDfTuYNuwUSWl7sEvGTl6khk36bJ+Jv8L0vgM7jFwJBXtXrVt6ZEYCo1dFbrXHFYTMMCCoVyomBC993dpTDsOuPRfORpJC9tDXf/nkUoY1kMWoV5tKk8Ols39bNr1jNOl4mpjoKym0+wzxKG/+C2odiBO11m+1v6bz+DC98a/kkDi1hokFGNkWToCyumo2Bn8fUbTHoo1KEKAvQp95vCbJwo8y6HWPiWv5+C+I52OfdVCknhjgKGp1ccP+m9Vg2ntpV79oqnQYwOb/HR54bK1G1sXtKnoSX4bjnzK6aKclQH6iKlCKzrwYzdMGHYgo68ROgaMPV4f3+ycMektpJddb9ZZhBrjxqu7AuRKMasnMSPx3c24jy0Z4O9cI2ZxUhlMx3mN1sZE3zICjtWqdRLRQTYoJNo7+omNo9bc1/jDOt725fR0SH3bJN++GDTza2xrIHiN2Pc/LoaMjPh6Y0TueGWdeXI3g1Tn7LuFN0ptINWIsZ3o+2ZfKFC68cCBeBvAO+zB5hVE4qyVF7ZkqBsorqvsSsktzCasjmOdchxFrqEYzb/YHACqDJpNaoD7dW0eVchJ0km7HbzF9kRfl3Vd2FNjF4kGOmqSt0zXbBbZgHmG4QMsOzupGQ5hg37ImMMELf80ma9+My/GTpvNsbr2G9p66AH3AK3ztW4eixe5X/YsfQNWHLLurvORRmtRtcLAZYk9cq+zNcPhbU4GOYhCPf/b27b57iuBV0qdox04/MOZI788yLtjzLd++M/sYCbicbW03aN3VsVOYUDW1Z/vP6m8rqp/u0ZtFXEZwidSbyRgqJFt6wGafzenvsY/2mWvPH98S53S4nkLqW35xvP83hL5kXABNAXBFXzDj8Z8NqDZTOUE50Yr2P3GaBDDZVOrKdbSgIY
 awaOh+V6
 zntukWB/uMIS9IqUCyDK8K+rGGg82rPUu++fqcI06z1k0dpEGs0MmM5FyZh3EPjrfKc68mVo65CtknhwXFk7lSFxWEvDjaquh8SMaSAZul0IwVZ+wcAWVUunt1gaHp3EPudJB6dAphor00ulFeZ5V2T+/4kYYlyqv8ecehieFXCGKAHr1Z2Fkiz7v/HGTMPUlm0k+ua9+fI6pfR8AKWpS9hsoLCXUOGPrrVLeEWw6y8yWQM814ef1nhTxQRVO/CC8a0SfPYH0h9AfGpN+5av0e7eGAvSGb1A09nsH6vd4R98nxHg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 30 Jan 2026 03:56:03 -0500 lirongqing <lirongqing@baidu.com> wrote:

> From: Li RongQing <lirongqing@baidu.com>
> 
> The 'memory_idle_ms_percentiles' array in DAMON_STAT is updated
> frequently by the kernel to reflect the latest idle time statistics.
> Marking it as '__read_mostly' is inappropriate for data that is
> regularly written to, as it can lead to cache pollution in the
> read-mostly section.
> 
> Remove the '__read_mostly' annotation to accurately reflect the
> variable's usage pattern.

Nice catch, thank you Li!

> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

