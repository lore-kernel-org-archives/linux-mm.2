Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57686FC6166
	for <linux-mm@archiver.kernel.org>; Sat,  3 Jan 2026 00:21:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFFB86B0088; Fri,  2 Jan 2026 19:21:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE0D96B0089; Fri,  2 Jan 2026 19:21:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0D926B008A; Fri,  2 Jan 2026 19:21:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D18C66B0088
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 19:21:46 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8C0AB8DBD4
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 00:21:46 +0000 (UTC)
X-FDA: 84288749412.23.2E9288D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id E69781C000A
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 00:21:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mTBZi2+A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767399705; a=rsa-sha256;
	cv=none;
	b=IP8Qe36XCMqtYze9CEqDuikJZT3NOTdXphdVYYZAIE6sAKfH96Z8O8IqKSnLPVGqBjPNCE
	OW3OIq/5+T7gcC0ZdKDVsSxHHiqXlwQO/5/HgXYNlxygSgrosuUG6z6FFvOtymtVnL+1LX
	awhWcm37svPRrKb3JIxJzH46KfzJgX4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mTBZi2+A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767399705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e4lHSIO+1qEkSz0XNFJWZ9SyF8p46jgJGQuc94hZdtw=;
	b=bgRAnfw9m+gwQOnT13IC9sujyVNJviNTboz6R6GHOxtshNjp4hG+nDiPBh5W1S3X0TwIsB
	TfkBLRIN+MTMzVlnKv9WbR99lmEFeeJoUFX389fhtjDjtNTEIauKF1k/jzFUrunwtuR7G6
	uM4XixP6PF3KRMGmLrejaAvBbQBcgIk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A0A1D42B12;
	Sat,  3 Jan 2026 00:21:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505E9C116B1;
	Sat,  3 Jan 2026 00:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767399703;
	bh=RRxvex7w8FVUNgOkNM+y8EuSHgaNGHCq5mSSN/nxhSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mTBZi2+AvRTWYk+wBgldQYvdYBAVIdINkvVX3c1ew+3uRhPqp33ntUYux6d0uog68
	 jZ/QcdECygiJLPjqjgORCJXtnZF9o6iwmUkKLEp5ypNhLpIUBOC2iHVAgkSQdnmwQf
	 f9UHCueduHcGbaeiTYMwp2QviwVwpj1CvhkvmY4tz5YmtgkvJ3cnwRrzg7PyiG9ldK
	 fyTv5RbMUHfi2RrEXX4bfGw8LoY8sROoaPsM3my3URDtBjeUuHrccAkJPn4g4R4kdW
	 Ict88pNFadtt/GFX3o4Gq1uphx5TEqePtZXvk/0N46pVmszreGRlOTGQSU0h1+Cdhh
	 ndZE7qmLcLlHA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"# 5 . 18 . x" <stable@vger.kernel.org>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/4] mm/damon/sysfs: free setup failures generated zombie sub-sub dirs
Date: Fri,  2 Jan 2026 16:21:37 -0800
Message-ID: <20260103002139.66559-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251225023043.18579-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E69781C000A
X-Stat-Signature: gwn5kxs9x89h8kgwnwspgyd3sj6thcge
X-Rspam-User: 
X-HE-Tag: 1767399704-656092
X-HE-Meta: U2FsdGVkX19oPhPHPZx3AWIyHh9f0DVvTFjAGpX3e9vvXXRf4tIEk36hLuiaTdQ6A95igWMEnuJ5wxdvhLl4KroIc0sD0aaVfe1HVv5hYh0kjvi8WGPq18oAUztPOUOPDPvfIX0RsnQ4hbn6JcZ8F1CUbQSDDquu/qAbG0ytmVjqrBlNt0WfjT4JK/HRZYJuVXe7YN1qg4MJEpo/ub4Wz9s/JkoQ/Jv99QjuxiTOKWjhOm2KGn0KBEeohxZzCQ197bPvOx7M+j/f5SRNNiY2KQQPZzaQnOzR6W469v1FgAb7UTXuaOQH4bRHbhdMKIZE1yWtKMUZ8s+IZTyU+pHbVP35ZgK02ECFiAvQvUb4NwejD/bTYSSp37YhajdVDsY06DZTod9pJz9yDcRNjQSp00MsYKjPoRVL06gf96HN0NehwljvUHwscDdRto5CQuLFXbQWZuQNzJHbRjRWvDhPxHuyJrVxjfkC9IS5iQabZlf23pPys9lXaSF/tMQuw/cSjPRWI9jy9lJqahIeqTeEo9wP7uTROh8wcpTd/A8lJlV4NF9G7JLyCj8k1ccEoVnwLy/PVL3QZQIepRNMpwpNhF9pUQvQr/JIG49r5svm3pTrNmYdGNGDRbS6TVTXV5lcJyHx7ert36yoK+l/ZdOWiEUFZrC5llV5y1O/6//3/LCBZ5kvOX40cso+ZE/9DC5hXIDQQnC4qHdxPXEGLlqn/R8y/iMVX+hcAGnMNZjin28yKJgDvcyGDkCt3bb1YG8ULd4Ob1i/y2QEKNh3QpN1tkvmVTDn0dl2r14FJkF8/wz4onUTDSR7TMi5ks5/HvWfr2omfFb6hWVrGztwvhgroYwaxmP4ZQiK4RnewmoeSl7Dz6qSyRXNZUo2UAvQosyoAnXhkYTRyj4eRbBhf8scmtRKBZ9Y8QLxKIcnj20MVzGqHV0RlHiVamutN1bX5lNXvpRxCUVk5gRsPHUQPli
 8BOPQKY5
 60N1Tirz+uafMpNMXCGsktLYUr3NTvoULbYYbo4a1EDU9rq9OIWQIGoSLP5i7Z5cJhVKWeR9cAkGMy1xS2fEwM9noDOsHkWAXgd0tqAXyj0RiKrdCoPcMLAHt7nBU8PF9D2XWlmB2VxQl6VUaDiuQw34U7tzxbuBwjKv2xbZNdu33gn5Glk0BbAHbRkdlTnOSoiPXFj6mmDnDOoKtGJ7UU33obL0iozpjBAARy3Wum+K22ow=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Andrew, happy new year!

On Wed, 24 Dec 2025 18:30:33 -0800 SeongJae Park <sj@kernel.org> wrote:

> Some DAMON sysfs directory setup functions generates its sub and sub-sub
> directories.  For example, 'monitoring_attrs/' directory setup creates
> 'intervals/' and 'intervals/intervals_goal/' directories under
> 'monitoring_attrs/' directory.  When such sub-sub directories are
> successfully made but followup setup is failed, the setup function
> should recursively clean up the subdirectories.
> 
> However, such setup functions are only dereferencing sub directory
> reference counters.  As a result, under certain setup failures, the
> sub-sub directories keep having non-zero reference counters.   It means
> the directories cannot be removed like zombies, and the memory for the
> directories cannot be freed.
> 
> The user impact of this issue is limited due to the following reasons.
> 
> When the issue happens, the zombie directories are still taking the
> path.  Hence attempts to generate the directories again will fail,
> without additional memory leak.  This means the upper bound memory leak
> is limited.  Nonetheless this also implies controlling DAMON with a
> feature that requires the setup-failed sysfs files will be impossible
> until the system reboots.
> 
> Also, the setup operations are quite simple.  The certain failures would
> hence only rarely happen, and are difficult to artificially trigger.

The user impact of the bugs is limited as explained above, but the bugs exist
in the code for real world usages.  I therefore expected this series would be
added to mm-hotfixes-unstable.

Do you have any concern at treating this series as hotfixes?  If not, could you
please move this series into mm-hotfixes-unstable?


Thanks,
SJ

[...]

