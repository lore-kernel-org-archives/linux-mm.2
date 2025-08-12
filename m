Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4439CA0EDB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 17:59:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51E9E8E0184; Tue, 12 Aug 2025 13:59:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A6A88E0151; Tue, 12 Aug 2025 13:59:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36F9F8E0184; Tue, 12 Aug 2025 13:59:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 26D2C8E0151
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:59:45 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BCA8EC0151
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:59:44 +0000 (UTC)
X-FDA: 83768868288.09.DE28FD3
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2B9D34000A
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:59:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qJ0sQwZJ;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755021583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wv7byLvGfPogXg6ItT1g61EzBjkDNM+tjrHItnyap0k=;
	b=jafmyuXCKjCIeBVnZYoLcfK8HeabVJzTJbCsxalm2XmhkJGlN7eqqDrubuiIZHp5YCZag3
	4W1AQM11IFAJR5zjpwtYACCxEuXXY4h2+0D2vBA0zW+t0WL127FLQwpVXDURhBvMc6RPkG
	6EuZWMimsviUEGX4fBSEpu+L2I5zGw4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qJ0sQwZJ;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755021583; a=rsa-sha256;
	cv=none;
	b=VLeZpIWVt5bys8PMeKUcXk5vpiwCPOMlDP5atzHY45OeJK6xYhn5SkrZ/PiARrNipcvSKE
	hzztX/Bl2V/IgHpBD4p7RCG4Xk1vnqOBrb0DYijzZdm5133/MT3Q6bifz6b6vhQIsfU63s
	e9EVukXmUXJRuPW7cXcYr0jUIEZH4ec=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 8F49CA4C267;
	Tue, 12 Aug 2025 17:59:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1147FC4CEF0;
	Tue, 12 Aug 2025 17:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755021582;
	bh=rFjNHrdiptsoYzIPMeCnezOiQ0/fh2kvuPf4huAWgs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qJ0sQwZJ7WQBftcoew9ogVjiGGqriqHFdBTvrvYnlzHh120BgkB/m4MSvvB5fcnbH
	 mIxbRuyWv7kFm0NDScia8wAAiU9GYk+9LGixpW910wSf89nJdcxj9bJq+bHgQAe01l
	 l1E5DVGziZBs/rsuccAAIM2sO3aaU3ADhgos1roNFr+q6zzkiuA2/af9WQVSJWrH98
	 ZmOi+KYb1sD/WAs7TRPoK7SlyevFyCcrM6pkJyxSiIkOW2n/+s9Y/NQ34dNRzBucOo
	 +4T6p7xI5J2GCRbWjXCzlcbPYM79xavf7iPEAxJRqtPwXv04DBMmoWdt+D4fd72sy1
	 7EH1TFULfRdSg==
From: SeongJae Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	honggyu.kim@sk.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] selftests/damon: fix selftests by installing drgn related script
Date: Tue, 12 Aug 2025 10:59:39 -0700
Message-Id: <20250812175939.57506-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250812140046.660486-1-ekffu200098@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2B9D34000A
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: tfabm4krecodfmsfcsibnnrukrmag3z1
X-HE-Tag: 1755021582-892867
X-HE-Meta: U2FsdGVkX184giZsn1846PctMTnJMEtrcX4ofoKdxp2sFRxJAi37mznSFBeuMwxqxC/XKMtrtS1sVzlwqYOSvJdcFATLRW2M++Dh+EUvXqeo6Bq4VrzIbVcmlcIb1PElVU/QIn6s8/LmhMEZkLqwiXunrZf1cOOHf5Oe61yC/1bqKtfCFhZ8x1cr9HUxqFUccwhuMyW31UUIA9W1DvVo8jPwSKyn3OrziNFtoJcwvtXM/6+cS+otMPTga4veUb+6PmuZd5XXwmq04NQ1++4mAjY2vTE/JKTtdamB59hirrbGX1m7hEXhvDfq9o3HbM/WzkMxpv4/RoR76S2fG9uqoKxk1An26ZDeejpFBONe4HmR1H+Ysb/vZMU81aZhXxHwY0KMVLlddxAv89de5Gof7rpJnM6A5+ztVFaGNmnLmhzzoQMsz5WlPmVnHgiVbrMiyypg/Vtpxxfj3xSG7tyixh0WBNDjPFCv7TIegy0xe8GBSvBqpFWxlvxEwPIb6ZzByII8ypxrCGDl+JZQMoumG5PtYEwoMPAPJuBpt1dQsW9eMI7U+18BL1tAH1xtlW4cWNF7fX6svJTUoDnxDXreOU2EZh8+/LDw2VE93XUz9IbvpRvIm+Ar/n/z1hrCW4eW+Z6A9raV6juOrkRPI07Ub6blzceezLwAm+Nf56FSxjpSFLlWIm4raNYXt/9CLzRIkoY7QLdu5WkwInP1wuQnpT9RjI0tYO+Vk9B/V3H1g4/RHEwLx8K9RA5wFoDJN0sPvmxdbnyRkr0BhDtv5NuLYnMehBJ+qz4MZ+Acfn80cXX+lQbGd2hzS0TJ4S3IIaTOW0bVWnNtA87K9S8cGfNGiK8CYE9rJzlybX+CU14pF5VZKZXcOGta4S1dikWrWMcpEWvBanYZh7gYQjOZS5HaB0HMe6uCaLHy1secNkr54dA1eLkoFcNq8VYw6EA+7qsn8iyiVa2dUmzlcVC0ncS
 hikO68/K
 Oh1HLEygtXeCO8nU8FMAL7ZJ+f46QCJjblE8XUu/3FR+TeAKNzqTWlTAgReqgOy6kfihoWZbzXwDl246U/p8yFlqAi9VYIYR3yEBZr2Sj3w4vIax0R2Tld+CKOHzjAfc7Nq/hskWdY0hht1FGXfAdJ7NKX7NYkHHmsxXOVRjAmJTyTgZDrDFvGiG4OaKd1Yms/JFOwbAYKcEXRd6Edlt58fKCSiDTjGd/LjLwkDX8Bx1UsSGCz0WG73PyfprOPhYCVQEUE13iTYVujFS3ZEh3YXDZwIFUnup5NgZ+Q76D8bMV2hVMIuNAli1Mtr+21VkxHIe4xLS1C0E2onlhJu7ap6KuFQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 12 Aug 2025 23:00:46 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> drgn_dump_damon_status is not installed while kselftest setup.
> It can breaks other tests which depend on drgn_dump_damon_status.
> Install drgn_dump_damon_status files to fix broken test.

This patch conflicts with the similar one from Alexandre Ghiti.  Could you
please rebase yours on top of Alexandre's one (and mention the dependency on
the comment section under '---' line), unless Andrew resolves the conflict on
his own?

> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> Cc: Alexandre Ghiti <alexghiti@rivosinc.com>

Reviewed-by: SeongJae Park <sj@kernel.org>

> ---
> While setup kselftest executable environment and test this patch [1],
> I found similiar issue. Honestly, I don't know exact solution for this
> situation. So I just make a new patch. Sorry if it is wrong direction,
> then please let me know how to do next.
> 
> [1] https://lore.kernel.org/damon/20250812-alex-fixes_manual-v1-1-c4e99b1f80e4@rivosinc.com/

For patches that you are not really confident about and hence not insisting to
merge as-is, but wanna ask other's opinions first, you can ask questions via
plain text mails, or post patches with RFC tag on the subject.

I think this is the right patch, though.

You could refer to the TEST_FILES part of documentation[1] and "Install
selftests" section on the document for more details.

[1] https://origin.kernel.org/doc/html/latest/dev-tools/kselftest.html#contributing-new-tests-details


Thanks,
SJ

[...]

