Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02400CA1017
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 20:12:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2FFF8E000D; Fri,  5 Sep 2025 16:12:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE07E8E0006; Fri,  5 Sep 2025 16:12:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF66D8E000D; Fri,  5 Sep 2025 16:12:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B753F8E0006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 16:12:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2C39FB7FA5
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 20:12:55 +0000 (UTC)
X-FDA: 83856295110.11.CD63002
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id C6D31120007
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 20:12:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dz7cmopB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757103173; a=rsa-sha256;
	cv=none;
	b=076jEzIOO6wJd27pG9OdcFuAZfGNUPzOMK6UqgIG5VXeNm8ocucNvrsYOIXecRBFxDyH87
	2RUgA9bFHsor0CGB5XI6PwZ9A2wHOVnwAVZEncwMS5oFG0u7r9XOcwFyEytgPNzb5W2f96
	BJCIdyxcSoXOU913Z4ynSzG/17UVvVo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dz7cmopB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757103173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FxWpbDwC84JyUDzhb3akjgxCsbIplIjX/ULDYohJU8Y=;
	b=v7FEXiyjjJr/QH7OT7V5s5UKtpQNUUyDqGsDDOgEslpKdAkoUqSNE1tSHNviSeSlE10QJN
	WOk6t8iJjci/SGfyAo01ZeCXC1IB6hMoUG5Dfr3HSxLREe6nuscHnmJs4hCxIKtjmyYkAp
	ab6xtlVSGz5ovPpwUhcm1wP/kCExtw0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0F15460280;
	Fri,  5 Sep 2025 20:12:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816B1C4CEF7;
	Fri,  5 Sep 2025 20:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757103172;
	bh=NA50xwmQmHmnHyMRdpp2t+2pd4JaCvoJdVuE9gVOf8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dz7cmopBXbpWZFEY5lwdPnHhoDBxWatG6S77ihR9vfdasn+oWaloQ8R8lz3gxY6dT
	 +vthFNb1napSOAVqSuIxn3UbERXOCSzoM+dTow0p9FsDrVfmyK2ZAOysq1DvqrjTuO
	 a3RnFSddTRDoNXb87FctjFGMt+vp9N79ImfLBw+TPyagm1eTt01fJ/95GWGbGODkmP
	 lDGfD+3TY6IAX2dv8jnmmQZFrxVfZ0ChPR0+nkWLPosBSsk2/8u5Yb+j3YsP2AxEM4
	 vB0UUl6PXrh7qZRI9STSEd1It7kIqdW1Mjn1kH52b39balPfjAubcqi6O+ZCahGoF4
	 /acHfYNM/IzGg==
From: SeongJae Park <sj@kernel.org>
To: Stanislav Fort <stanislav.fort@aisle.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Stanislav Fort <disclosure@aisle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] mm/damon/sysfs: fix use-after-free in state_show()
Date: Fri,  5 Sep 2025 13:12:50 -0700
Message-Id: <20250905201250.36561-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250905101046.2288-1-disclosure@aisle.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C6D31120007
X-Stat-Signature: oswex3yi3dpg3wk5ze4nmkh8cjb6p6qe
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1757103173-42415
X-HE-Meta: U2FsdGVkX1+XsxYaQHyDaj+lf1IGoXSm/Zd+LnC6If04cuQfK7ttNSanEmxeLJLZ6dykOpK4zYbDcviTY3CV7FQ7rNjUC/aofWuBc5LUpS7qakDUtseGaMBwNXg2j+tWi/PYWyaM3qYCJUHd1h5UMZDqjzkBV50qkpnmAgRo1cZ3p5bGLRlzVgp1nlNG7DnpRx9ydaLVhCeBcBuA0WJqlNvQFPhfcas7jUqmBohJanJSbyYBlSiMLn5PFoWpVXQYP/svcy2FTGXRmkHoqlWICn6ZuN/eHlFDZerPcM1QTjSN2EiQm/FjNC3iz/M2UdSytXsUKtpaiD1UjfddoV00qdGaA1Q56hgZVCw2HVGHlWcMgc0Oz6LFlumfsAMnNyKRTNaJjjZXjydItdyeqNVaoYBOE23tO6+eQrIpyw+oEVCbD9JjT9ZQLq2jQpF0fIbPY4mYRc6IobdT1MbDRg95kVFSX7IBUTkhryGAqUBh6CLkf+2jtjmiUlQ3DpERbIKLJFu30uSNWV9G5zQ7zp7MGEeXdk2901v2J4/RfGyMnIST0GfsV5gwd4S8LpzxLGFRoFEOfa2cZgUxsIJRPJcqmp88a28IhlhZ5r2X5qvbrE1Cy2aZW9H9z9VO4+JG7yb1leVgWcQUtU3PR13I2vmFHHH00sn4yfXGpT/qHikFIhbm4vbufEyRQ+dGbCW361sO9FWCloBhlajU0ENG1gCeDZP29zgtpA/FQMc7GfQwXZEy7j6yytuFzorYkj3V0hL5UHvr5fw9B6gkRpvao0sQPDo1zO+cVw2YEX1spJGnzN0u2h2Miu3VejAz96rHzjKEHQfb8v8v0mgx24+l/EXpAYy4x/+tMgpB4thrcY77N7xtMz+GFoeD/dmg5P2xEyjbzd9spBTG2cix8R9t9TJq9OVfx6ygUWQaa+h3SQaK9Q8QFHrkYVat8kzK9Q/UzMA2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ Andrew

On Fri,  5 Sep 2025 13:10:46 +0300 Stanislav Fort <stanislav.fort@aisle.com> wrote:

> state_show() reads kdamond->damon_ctx without holding damon_sysfs_lock.
> This allows a use-after-free race:
> 
> CPU 0                         CPU 1
> -----                         -----
> state_show()                  damon_sysfs_turn_damon_on()
> ctx = kdamond->damon_ctx;     mutex_lock(&damon_sysfs_lock);
>                               damon_destroy_ctx(kdamond->damon_ctx);
>                               kdamond->damon_ctx = NULL;
>                               mutex_unlock(&damon_sysfs_lock);
> damon_is_running(ctx);        /* ctx is freed */
> mutex_lock(&ctx->kdamond_lock); /* UAF */
> 
> (The race can also occur with damon_sysfs_kdamonds_rm_dirs() and
> damon_sysfs_kdamond_release(), which free or replace the context under
> damon_sysfs_lock.)
> 
> Fix by taking damon_sysfs_lock before dereferencing the context,
> mirroring the locking used in pid_show().
> 
> The bug has existed since state_show() first accessed kdamond->damon_ctx.
> 
> Fixes: a61ea561c871 ("mm/damon/sysfs: link DAMON for virtual address spaces monitoring")
> Reported-by: Stanislav Fort <disclosure@aisle.com>
> Closes: N/A # non-publicly reported
> Signed-off-by: Stanislav Fort <disclosure@aisle.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

