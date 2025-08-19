Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A58CBCA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 17:27:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3695B8E001D; Tue, 19 Aug 2025 13:27:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 319FA8E0005; Tue, 19 Aug 2025 13:27:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 257A88E001D; Tue, 19 Aug 2025 13:27:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 14E918E0005
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:27:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 90E7B56738
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:27:23 +0000 (UTC)
X-FDA: 83794188366.23.C0871E3
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf26.hostedemail.com (Postfix) with ESMTP id DF8BD14000A
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:27:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AuLLVTwu;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755624442; a=rsa-sha256;
	cv=none;
	b=8hlnzH+1n0q0AaSanZvN6Kalcwv4pNbQU6ao09TYVQdmmE4QQMIGoOMrR+JbEmCdwSSKxr
	FjDHy8ilQEUQVJnUqa892X33Dm2KULNwSLvBQNne00px0ZRo0H9z79UCHnVAUm1/vRff/A
	SOMjwMjSNBQAmp6YHCZz7ZMbiql2jN0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AuLLVTwu;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755624442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A16B9/z6aVj7cIiP2we9VV+zHRJnDxifVVIPSAcXbwc=;
	b=bBEhtESLep7E8MnWsV0d5ooFqAkGs31as7rulV4RmrtsfV1U6J3zbdi6PRN93OldsYLTdT
	8flNiy2xqtBjnqCbQ8R25EsnsuXdETY9GyXI04Q2SCMXaB4XfEAvKipUmR7kg/dWYF1//4
	8dpCGYOQPte10D8pupG9acrgTHhm6dQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id C42995C59AD;
	Tue, 19 Aug 2025 17:27:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CB5CC4CEF4;
	Tue, 19 Aug 2025 17:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755624440;
	bh=DjIQbLXoKGxiqstdZOoWp4F16Bie/DPqbH9msKl3kas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AuLLVTwu117bVswIvtLMVifZHzBGRg0dfVcOzvrAveGB5/wDCpk37VGrRXrkEb3rg
	 0i7vaLugi+fBalb/L8f8dP84O19OqP0YCJzaFgeFdPy+nyJIiouJo21g+GMG2AJqH1
	 pevxjkcoRc6f2/mI38dnwjSVocie9jTpSTyxbIoiw4CwrjPF2fetNchMfK0yHBCwXL
	 fSs/pakl0RgT9SCaYDxBTSRXCin2dqa3kEluL9RbhWQOUebDykmIy8rE86AmJuFA2e
	 chA1gb0nkg+nGGwLz0MCLK79/ZPMDB3/NS2S+VbRxScgDI6wFgDdtZVNvo20yuyUCC
	 817i5C1zTSzdA==
From: SeongJae Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	honggyu.kim@sk.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/damon/core: set quota->charged_from to jiffies at first charge window
Date: Tue, 19 Aug 2025 10:27:18 -0700
Message-Id: <20250819172718.44530-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250819150123.1532458-1-ekffu200098@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DF8BD14000A
X-Stat-Signature: f9d3teikkjye7ybisbxrn8nj49dm9eng
X-Rspam-User: 
X-HE-Tag: 1755624441-632254
X-HE-Meta: U2FsdGVkX1+qSoCnBSSyaNE4QjsX/yaREH3V5VZijhqwncq3xtGEfBy/5prYQI8XKYq5q3Iogb/DCillUVovcG+wOhnLsKCb4xPtzYVwab7wXxDgJaouss+a86PgQO/vM4aFKg25BW25R1ydO+cj4A2ScpP4/HY8JA+sFtMsOllFYZWB+kTxVcI8nCKdxiYRuKf42MraizkaTdTN+3EkXLqkY53dTY4ELj+bU+TcR2JE0kvX3oVLdAmC45GA8e/ip40/LJghAd1Z2EdlCF+pTQlGmg9cmHuGGPTvNlTj/sxr/F7aWBr1xqrqKHRykmuK+33XKp5qPVDdUxmN5R2FgHVvIYGDDQJaWWGdxn05diRihNNQ5pdXQAQaFULl6dQ6oMa34Ifo1dJnllgBzikK4UjsHOZjfWK66dxqXEnxfEzhZA57VcQupHvMv3/LUfJjLy1yBZxybjqSsV/IC5eY4qPBk3SZQIPRUoUQBL9o2GRtu7GfrWARfuHii7jVoFnYIEw/z4hdq1R7KLp95+8oRHaF/b4KJydSxMNtmIoJ9CYsNrcc4K9okkbeHmQ6pr39Y2NSEEfZdWvAtU7BbMctz5WtEO9u/msNjO/3+xEc4q/9UBdkDOXclSKft+0esb9mKQ3t35jyflbGIxNeWd8JQFlaFKgXmkxEKXvFm4rEt7y0iegKQTCGOUO6QZKGX1AQJn+wPGmFj7g5qp3qtAouZ0eKbcC3kpIwpppMUPM3Pu18GCFBUEazOUB0TwKAn4lOfpdFIJRH1TjyQdtkzEi+J3V+i0Yv9hO20cRKAjPU1St/YdfquiKdYIanCvTOIr9VxbGBSjS1L39aaPLMfvY5ErvyxJ2vy3wZxco3YZSqii2yGdQ1Zi5jM29z2LUpEwogzs8W3JMAh3aTOpCiejQBxCImAnRjLFUJbS+rTIxyPKN6BihGuRrlKpXZL94/c08HqKpoX3Bq8yD61WgIgkv
 7BdY8SKG
 4zU9+ndVsdhkFhBxz3IuUA9D+ysjY1pDVwtdaRyqUlj8B4VCPdOEB0iXTt7R+ByOVO6NjO7uwlS1gmnKkKgpdTMIDiXtQH88zQmHnrPKNUrr/lmc3P7XY0hMZ8dEFl4tNZXaNPAV1eW2vmuZ5HuaU7QpWuUFW6WihBnd60/7uRCUjL8eerpmLqYl7UQLpjPSKSRmyKv7LI/ReiOIoJ5WvHYQQWr7EP47YCyyVUy/hB2J2ahs0B2+43ARQymbDayY2AwRFImOp6KFvGW4iRxCqcSfg4vu8HGh7yfGE6qp5AFwB6xA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 Aug 2025 00:01:23 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> Kernel initialize "jiffies" timer as 5 minutes below zero, as shown in
> include/linux/jiffies.h
> 
> /*
>  * Have the 32 bit jiffies value wrap 5 minutes after boot
>  * so jiffies wrap bugs show up earlier.
>  */
>  #define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))
> 
> And they cast unsigned value to signed to cover wraparound

"they" sounds bit vague.  I think "jiffies comparison helper functions" would
be better.

> 
>  #define time_after_eq(a,b) \
>   (typecheck(unsigned long, a) && \
>   typecheck(unsigned long, b) && \
>   ((long)((a) - (b)) >= 0))
> 
> In 64bit system, these might not be a problem because wrapround occurs
> 300 million years after the boot, assuming HZ value is 1000.
> 
> With same assuming, In 32bit system, wraparound occurs 5 minutues after
> the initial boot and every 49 days after the first wraparound. And about
> 25 days after first wraparound, it continues quota charging window up to
> next 25 days.

It would be nice if you can further explain what real user impacts that could
make.  To my understanding the impact is that, when the unexpected extension of
the charging window is happened, the scheme will work until the quota is full,
but then stops working until the unexpectedly extended window is over.

The after-boot issue is really bad since there is no way to work around other
than reboot the machine.

> 
> Example 1: initial boot
> jiffies=0xFFFB6C20, charged_from+interval=0x000003E8
> time_after_eq(jiffies, charged_from+interval)=(long)0xFFFB6838; In
> signed values, it is considered negative so it is false.

The above part is using hex numbers and look like psuedo-code.  This is
unnecessarily difficult to read.  To me, this feels like your personal note
rather than a nice commit message that written for others.  I think you could
write this in a much better way.

> 
> Example 2: after about 25 days first wraparound
> jiffies=0x800004E8, charged_from+interval=0x000003E8
> time_after_eq(jiffies, charged_from+interval)=(long)0x80000100; In
> signed values, it is considered negative so it is false

Ditto.

> 
> So, change quota->charged_from to jiffies at damos_adjust_quota() when
> it is consider first charge window.
> 
> In theory; but almost impossible; quota->total_charged_sz and
> qutoa->charged_from should be both zero even if it is not in first

s/should/could/ ?

Also, explaining when that "could" happen will be nice.

> charge window. But It will only delay one reset_interval, So it is not
> big problem.
> 
> Fixes: 2b8a248d5873 ("mm/damon/schemes: implement size quota for schemes application speed control") # 5.16
> Cc: stable@vger.kernel.org
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

I think the commit message could be much be improved, but the code change seems
right.

Reviewed-by: SeongJae Park <sj@kernel.org>

> ---
> Changes from v1 [1]
> - not change current default value of quota->charged_from
> - set quota->charged_from when it is consider first charge below
> - add more description of jiffies and wraparound example to commit
>   messages
> 
> SeongJae, please re-check Fixes commit is valid. Thank you.

I think it is valid.  Thank you for addressing my comments!


Thanks,
SJ

[...]

