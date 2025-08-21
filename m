Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1492CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 17:21:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2429D6B00DB; Thu, 21 Aug 2025 13:21:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F37B6B00DC; Thu, 21 Aug 2025 13:21:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 109D26B00DD; Thu, 21 Aug 2025 13:21:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EFA596B00DB
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:21:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9C69E160499
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:21:20 +0000 (UTC)
X-FDA: 83801430720.10.794790A
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2A25940015
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:21:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="kWEdl3J/";
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755796879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wkq32fAU23ciZUPuGi6RSggEntFj7+0FH/YpcY90xxE=;
	b=ySSdHG9vORu4fQssmFMUBs4wMDWEl31x0znp94I165nrttrdAPV8lyCH/ftDmiz4ZzNDML
	lnO1IqSWJaVORvjELUi/32l9D41lW/4wIXnhxKZUL1/ddtn0cDuqa0rCjbBcHwmKC4rG5r
	k6C2MdlD03THs4jm/BLfzWbu5p5IZy0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="kWEdl3J/";
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755796879; a=rsa-sha256;
	cv=none;
	b=wQxnpoVc2MusB1jJwcwWCTu8wcNqhwctqRuxo2OqF2cCf8su0GEBbCC8NQbFo+EYmW0mCg
	oyyKXbHAbwp5QvXqp8I42f3nlJZmA9gxAhI5sE8yTzEUZYM5TSj64aQ+2U5rbpEE6OlHTS
	Kv5sdDeTphAbZTpZOlR2X+6txO+drlQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 980E2A5851A;
	Thu, 21 Aug 2025 17:21:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF06C4CEEB;
	Thu, 21 Aug 2025 17:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755796878;
	bh=E0Vi5c30Cu76scUs3f6qRf07u3YDzAxATcvA54H/SEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kWEdl3J/4HQ/3zf7JFAOxyl3zZr5zyt+S3YX1p3Ek05mayg5h2D/s0p7KDr+elgTY
	 MFjqIetJAZzCX4IXTkazMAjfdZ259eu09S7YikFd2uo3nu4d6WOXrhlkCbsWTjfzr2
	 tN0fRHX+bSZ3BSu5exh4uKfm0UM3PymAmBAwn5IDpCZp7QczbDpYrlnn/RzQyCCut2
	 jB9woZbso6K9hC1oXV9hRSrvwjzAMWa6hNpADjkAbdJzshdVsY1ALp9qItmjg6TNvQ
	 +dpUc/58xk70M2dQiAx2fS2WqdKl50O5XuPhk57vekOnFqOyEsbpe/CdG9hH93WJxt
	 mi6+253ErSXLQ==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [PATCH 07/11] mm/damon/sysfs: implement addr_unit file under context dir
Date: Thu, 21 Aug 2025 10:21:16 -0700
Message-Id: <20250821172116.82165-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250821105159.2503894-8-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2A25940015
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: iyorissd19c9nn4y1r9c88ds31mbx39x
X-HE-Tag: 1755796879-243926
X-HE-Meta: U2FsdGVkX196fh9OjEVjPfzBKhLujk7Iz0HGaz1ie2rvqXqXh6QYQhNY2L1Opaj8rpo7VOIkCT1IxpeXUk+vZgTqPMZuBP69hfVCdGTVf81cJCXGmb3xEcMkUpYRxTXtfnLBgKEfTZR77ygWuZl8ZrlfJp4eIDD2AsEIlZID6YHZDzCfY1TFTXsNliezgTarLeeafOfhv5vA+MaHXY00oYkdtei/Shx1BxLPIkPF1YlcaexJM+Xx+Tr92f4v+S619LwnDxyw+AJ/QRh583WQwwNbrenau7Hfbmr6ivNBsu6U1NcRzmNs6QyBBGtd7IUlvnYD4y98YDjdYqyq88HFR0uJx196Be4/Ev/Ke6xqR0IJWKCM6SvIeoBRdzthztNnr5hDXvUfHRfffmzMoB8l6aMXfF3bd52hHYrHRvDFRCskTVSWwlfzwANmwnatsWM6JRDVVu4uG1TzvlJ3I1gTKt0b1EYoTpE+wsBw4NlByK1DGAI5faMP7/S+bh8QwkbsUD/Zvi6KvXM24pbMTlLEg9ViJttwudI6wFo9+rwgAaUxjfNXqXzJ63SBj6I8THJMfKXUrgOKPaxCFPQOfjeeIaaQ9MO2C3rgQeugjJIiP9T1XoWoLoNalIob1mk4Vr4tzzjdoSyj/nET+fVnka8NJ84ltI3WLiqybnlXuuKBSVq7owJI2dr4/0jJsRvUFctBCg8FbGig1jWaaNI4DLPSDe1p1LsL5CLfKg1ZPmxCpc+DiBsgEoYMu1A1AdlsSwk1umkwCOJviGFsLaGtY6rXpvD0sSpRtAGrhqoe8H1ZEg8oT2b5LJubAOH9SzrTUHhpChbS+eKufpYqG5SMa1EHTybFg41kUw4cFTnu0aWqHoSDcknIYSJjw6qcnCP5sFzisW0yKQy/iO5O3YRO1vNc5/K+7nstN+1cOB9f7oMRTuAkrs4qHfRp1Aj29NdOf3TDkF2blyUT22hrV5Ao4KU
 BCccfSYP
 xJcL1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 Aug 2025 18:51:55 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> From: SeongJae Park <sj@kernel.org>
> 
> Only DAMON kernel API callers can use addr_unit parameter.  Implement a
> sysfs file to let DAMON sysfs ABI users use it.
> 
> Additionally, addr_unit must be set to a non-zero value.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

