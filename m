Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FFF3CD98F2
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 18:04:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6DCC6B0088; Sun, 21 Jun 2026 14:04:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1E616B008A; Sun, 21 Jun 2026 14:04:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D34CB6B008C; Sun, 21 Jun 2026 14:04:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A48B06B0088
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 14:04:03 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E69EBA04BB
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 18:04:02 +0000 (UTC)
X-FDA: 84904693524.02.7FEB2D4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 47C0620003
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 18:04:01 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l0YSS5Dh;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782065041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=54TyF7XxWkGv+SmhhNpIN1Mr1dGEVPPbVs82yylKPaY=;
	b=ZjrELkLXgDfnjlaF80hPAKUhBEluMJxstKTI79EdH15T+ONk3U6toXQeZe9Lp5g4CAz7E1
	/1h1oVlueekLoVBJhH/JCcA6Z5NySDmkW5AZxeawZGeK23VYyrPjcQGOqS8wrDiCHq+aEA
	ThuVkTAhD5Dkmma6zfyxx6Knb0pt0S4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782065041;
	b=R0mChcIQzB6n7OdzG9uDDAfFfJLJHY7uVTuIaTB4muksox/sWbkXmsBk1ssvDrxfbIxKpz
	GlESFVE/pp+qKDmG9Qz93XXrB33j7dQcnlf2UhA1L7v0nw/l0i9mMmw1xjY2CdIDj8MACA
	bwReEtez+9Ru+90bMtjfIbpEERLTy2Y=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l0YSS5Dh;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3D96044086;
	Sun, 21 Jun 2026 18:04:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA0F1F000E9;
	Sun, 21 Jun 2026 18:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782065039;
	bh=54TyF7XxWkGv+SmhhNpIN1Mr1dGEVPPbVs82yylKPaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l0YSS5Dh6e/G7+zzbyorV8r97fLmf6IUEwf9ogcwCELprQUPx6gmVUJBhK/HXRoY9
	 LKPQPCvnZz8IsJgmWJBIMS6Fcy9C6R3oOu2zQ1v7xwOgL64Xu7Ito4qX+U0S195aB5
	 6X1juTWcf3xtoFh6B5GWEDcZRmoZz6fvC8kMuzoN5hlfpT6XFawpT3EzVGqxIAxGFd
	 w7REcOpnrH9uc/RNYlfP7MLc7SEi7Ncl/MOQ3oWmP3BXN4EfMKHU6+XWmXERQgWcny
	 ogQRLZzMMUgQkZZw0+bBoBjC5jf62bDT2uWZLlehFyQ/HmK3xDBAZ1X1sdN24e9MFW
	 KI3Z+FScSoCJw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"# 5 . 16 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon/core: handle zero intervals in damon_max_nr_accesses()
Date: Sun, 21 Jun 2026 11:03:47 -0700
Message-ID: <20260621180348.92118-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260621154808.86431-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5uchouh5bwubonjyhhcu8adce6n53ufd
X-Rspamd-Queue-Id: 47C0620003
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1782065041-923951
X-HE-Meta: U2FsdGVkX1/rfIq06fOkAKQs9oKAzbL7ge8SzU7G78Xg3ukH0BDYemkxKw9EshBRfIRCebcVI5znITTQiBjEy1oisgKV0mC3M7FV9pA+12dohZzu2Y1LTDXiPaSNRQtSr/Blj/3K+JSiOVUEgVZ9cTlVtGG65l0IfzaBKHSgSH467Y/x5VjhLjCNpRNUFebxV8q3LJw4mmI28MZOzeMWHSD8u6jL4oRW9tsB0bF4wXCKa7lSdBGVk7XKRbn0qNwH+EK9baFbnnGDVc4KLWmxF67Rn3/saCoUwTgY1BDB6TPpPfJkZi3Q9hr9eHYQrJk+gBWmtUeiPnTlVn+d89tokAehgjcVZm7r6MridkmCfXrZ+HunF5UneCZizGq4AQ6/xJZ+xSRvbjBB+pKfyEAjoaX49I0pYObbCRvaCXN1Z2HCR0GopIQPf5kwBfI9rGi9c7gDmCThsMMATpLVeqiiKCJ/I/w3Vfe3uG7qPX3oM9q9gP/lQc+JsDavBQAQOipzoOQZeaeMumK6YO7y6+fdH4QAcYfMo3vUS+pG+uNctFP7C83Zt6lKc0U8xk52174Cv/Ani6ycVPhimAS4+b0wBh4Or+/RSW8NL8XD1+h3HbaXdpYCG2aq/iRdS9KdTr5nVErXXG/UfpPvcfXzfri/5F9vzYTwVktMhTCIXrHubam6DUOjaTU7L+vYvy2NkFfUf8VttYFgmMwGBQZOJTg5Wy9H+r39IRL+m59eGXhpfjo+uvkiQ8ipw+ANj6Jl9HqzYwNHkWcuxAEl/3YZIjOlpnB+klB39X/xMQzGLBW7WqK7uSLcG2TIBIHSdMrDdL48iINUL37fyemyNKL8rGhgLryiMT+BwvXAWJgYfNqHmN/lrYcs2pJ1WDm/j2gisE7iSjj9f07K3zIPqkr1/bMQCfI5PW+2gXuJ/kDZyq5rrQK6g1Qx24+RzlQ91WeSVBQhn6lSVaXE3lNomP/PAM2
 cWTyg+FI
 WTsHeWnrcOZZHJa2tl7yrmHvst2FB4TUWYqXor3J5LlA+sZWlP+26lyuIOcsuxqk+u/AF/tNB61wf0EdbIkoYeK9CuVdt5B9aTKC6CknJNNRdiOw+3yUsNXdOWHGShgMp+vJ4F0HGG/PjcX9c8wMR4v2H/ByhMF2U756DVsPkmoQXk13KwN/JlHRbZlVx0dW/dxudGD+o77fazLi3lyUuQi1a+YRU+/Eo+6LHw+hHpKH8OHYiMCJ7eSGExBQh0ZR6fL7z0gVFdNStSzpwN39p8lzrtg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 21 Jun 2026 08:48:06 -0700 SeongJae Park <sj@kernel.org> wrote:

> damon_max_nr_accesses() causes a divide-by-zero if the sampling interval
> is set to zero by the user.  If the aggregation interval is set to zero,
> the function returns zero.  It is wrong, since the real maximum
> nr_acceses in the setup should be one.  Worse yet, it can cause another
> divide-by-zero from its caller, damon_hot_score(), since it uses
> damon_max_nr_accesses() return value as a denominator.
> 
> Fix the problem by setting the denominator in the function as 1 when the
> sampling interval is zero.  Also ensure the return value is always 1 or
> greater.
> 
> The issue was discovered [1] by Sashiko.
> 
> [1] https://lore.kernel.org/20260619202459.145010-1-sj@kernel.org
> 
> Fixes: 198f0f4c58b9 ("mm/damon/vaddr,paddr: support pageout prioritization")

Sashiko found [1] another bug that was introduced by another commit.  I will
repost this patch with a fix for the another bug.

[1] https://lore.kernel.org/20260621175849.91990-1-sj@kernel.org


Thanks,
SJ

[...]

