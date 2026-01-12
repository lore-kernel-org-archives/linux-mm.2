Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EF9DC9EC8D
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 15:36:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78E8F6B0005; Mon, 12 Jan 2026 10:36:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73B846B0096; Mon, 12 Jan 2026 10:36:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 647EC6B00A9; Mon, 12 Jan 2026 10:36:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 525BD6B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:36:46 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 05E5F1A0522
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:36:46 +0000 (UTC)
X-FDA: 84323714412.24.A270CBA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5819780011
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:36:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZtAGRCCo;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768232204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zx3XjcfW67X45x0UPAkrB64a7/Ro1uaQi9z3OcccVTM=;
	b=nh02KACrz4ZLEY4rYRPUegHoRWpU5u5k6ETEBRc18MbJLKDJs+kyTX1ZgG9aZrhw0iKpoT
	dvj3XvrPXkGZNr5dAVmdy4NxCA1ZogjkKPEcFm8d/f3fT/S/Pe6wgazzD4vgJO+QEAtAzN
	X5pfyspDFEDfNVM0BrXSRPELlz8auXQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZtAGRCCo;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768232204; a=rsa-sha256;
	cv=none;
	b=U+PHXWl3iOoRsZnJRSszQo9EiHszuz2yp/xgEbvziOwx0PbNtO4yU2BbdRl0LIFak4DWMv
	YMCS6F24QpI2oZTjvHSIIlToiwOcUacbRny+cu/QoKwVjKXRzet/Zhup6QNxLciKUO2PFQ
	y3w7QnpiPb44q+GfmC6UCI7W0+d2jMs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 678F76000A;
	Mon, 12 Jan 2026 15:36:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF16DC16AAE;
	Mon, 12 Jan 2026 15:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768232203;
	bh=1IheKnbF9KpHc+KQVqpS9yoJRX/NZTD0YAWB4rwgNT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZtAGRCCovJdx5faE/e1P43HebX5iIoYXJqMvilM5BAuONqitLKugP4IlpPxp+RnoI
	 Bfsx1G+cKPkG7BPaC19VOxzLYcvfFBFk1CJRXzxt8oaZREejHQapMXVaw4lm/wenFc
	 w8McvlFckcT2H/8i7Uk2+zz0oMIwNfMCuaAcNmhZJcWPN1brOS80PGalj9uZ+bNLXS
	 04MfUvqujte7dCPboRGrEw4bq9h75IECK50Dob22R4N0+yGd4bOolxe/7LvO2FUPjV
	 QBX8Hrh4NwNIMI2Rvlp4MG9JKaJ5LfyPU5ZimS/BV+QpdRBiKIdkex3ljqsaLxbcbH
	 nqbHyeczFuA5w==
From: SeongJae Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SeongJae Park <sj@kernel.org>,
	JaeJoon Jung <rgbi3307@gmail.com>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	wangkefeng.wang@huawei.com,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com
Subject: Re: [RFC PATCH v1] mm: improve call_controls_lock
Date: Mon, 12 Jan 2026 07:36:40 -0800
Message-ID: <20260112153641.98331-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <909dbaad-f0da-4372-a151-a393619da6ec@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5819780011
X-Stat-Signature: sp8h1kxrorcrcp8d4h1xq6x1rcuspfzw
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768232204-715935
X-HE-Meta: U2FsdGVkX1+m4N9Mj9aFS2JwQll3P8v2QXvhpGEnynhVZLkTQLE+OKULiXpyM5h9Hu6UX0HO3jf5b7M0iWBjLM7G+wrGvJhf8pZMZ8ZOe9Z1arNg8RrKdSPqR2wWeu5jrphQ9lc7OM1OXB3ay8l7zMI+a0KnRmkxdEjneJoet2iRURvIlkejkpQyPdnuatqbrFif+gG2iwMQ/bWeRyKtDxsiuqNMOMMKJPF7SAP0FrHTRjZCdlqRoqLFUKBmycercqU26UTftRJlpob316Po4BAby3WnrjStqgsxI38HbMKxyXY1XhqA0YoeOmbQBy/vtvocc9webWMdkhuZaNUnZtFyrUkCMIl/X7HeYH6l315Ax6pkZfyslLT+15HvZFT4RR2dxh8Is/wXgPwqWkYAs4uAUky1lj1c2QfOTeII7rg2Q39CXQQP5vJNf7AAMI4Hq0XqadfwCy6A5QTcZqovzWc/uE9YROpe3GEqw6rFC+9IDvHtYWSOEM+yQYtHnB+x5J32sXWrC0oplOHIc+YNljQ3SQ1giJQ+CUVTC5lktumEynIPEqtWNNKYtzKnJrtOG8PxTJeTcdfoV9S8Xs0ksbeNF/1xp0JdetRrUHKv79xJAax2memtJ+x795OYqRkxnqXEz3sU5N04EQCJfL06UydLGsHW3bZBPvLV6i+rY1sDo0ah6lXj+u9nQa/xOlt1vYhaLIQMOBb8T51KpSVoPfeQ6jTb7hK+qIObT0crFtJyg0dxAt6XPMqahGBGIVw7bKZmGA7WYtHH7ZaypTKIVcDMUzGBAV1UGtNWLtOGoZ2vY94oD1fIEWkbtVsGyNfQsan9BfhKb+TNYqAkcJdSmHG3Bu/lncm7Ax37HXzBMfJ1liKlM0g2Pq0mwaFwHizBX9cDudgs7s4zjybNJtskniYK7XGGN0WDWAK4j0RCHdobq4sUR52L2yY2h+WAR2L+x0XxAuNZtSGQUtIRBcC
 F4BeUeVT
 +HMNjT6SaozPEEy6PP36o2C8T7DbCRypZwAx3iixsIHU2045Azv2DZ1UH2ljjqUQM4VdlcaGMPMqpeIT2eH+YWNWdQLyaDdFG+IeBQCVFwqi3jwskoH7Yg313Tnf2Lu5UCrxt6aAjEvyD28IrC7LuSsfRGH2zGsjERQ/Pqzszd/eroVJhJgEcWkzmoAPqIBbLJ8xdaWOsBGHR8Zc2LORtqDrlsjeUhobqJa5Vu2eWm36MvEQFQGr1y2ApuXe25/NgOFQnVCuCKH4Cnqx+7GZDpvbcefm73rfE8eTC3y1M+c1unhg6yc1R8MWu3g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 12 Jan 2026 13:32:59 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

[...] 
> I can submit a new updated patch with this small change. However,
> I believe, as discussed before, that the improvement in general will 
> be small and it may not be worth it.

I agree.  I don't think we need the updated patch for now.


Thanks,
SJ

[...]

