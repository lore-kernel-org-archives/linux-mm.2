Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9DBEF30288
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 21:14:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 090EF6B00A4; Sun, 15 Mar 2026 17:14:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05F6C6B00AB; Sun, 15 Mar 2026 17:14:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA9E66B00AD; Sun, 15 Mar 2026 17:14:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D4A1E6B00A4
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 17:14:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 675948D072
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 21:14:42 +0000 (UTC)
X-FDA: 84549551604.03.99DA4DD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id A4C3218000B
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 21:14:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SmW7vWl6;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773609280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k+U7suJ8TW71fm5KOxtYg9E9wtsEzt2l5irnsK7Irx8=;
	b=YfTRQZyINVh3dH8RGvN9iRINxZgYP78udVeIaBeqsr8ocxPb544rQ5lAIJHUAtGGgIoev8
	lRurgzAnxWfbGRYD4dsabXmLWrfvewoRc87VeOX9H/xXWPDspEmrhzZsENpOszNLlLckz0
	Osa0LEs/CtmCrQVZAIGQWzZg3QuJqUg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SmW7vWl6;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773609280; a=rsa-sha256;
	cv=none;
	b=sLCnWjhfH5It3lXfYEF909HPOt+rCCvvoWLbmFaLPMP/FkB905L9guOTg0puTLeNo7nsjU
	L12GebI1/gMYjX3GYv39bIm7rvn4cVjmNcfu2Q6UYkme85mynKBF4gt3EPLpDq6rGSRVyL
	cYsrAeeQd1KE3uis1f/VTmlNH2UyrKo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 10CD06183B;
	Sun, 15 Mar 2026 21:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E66C19421;
	Sun, 15 Mar 2026 21:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773609279;
	bh=uhn2s/HJkqr7A49NC+rhbMTs/mAUE6GqP3N9LZ6XXmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SmW7vWl6AJnezLaYhB0d63lzQd3Ov9cuP/DxQmksegSp/7uLBuMO/pjNmsadMB8Hz
	 xMqN4SXjv8AXBDec8vH4RhM5WonU46PZVJCrQLrplxnoSPpSur4t6ac2RNu/J+Y360
	 rBgJC6tKnjasRuMbDVos8EoZCO8JORtULbWNEhlTr8TV9CEkduQ+Ow/sHKuOtgNeid
	 LBf+gHSV17VWRK0xDNBVBlDxxR3iCvaYwtA3eD6RonMGKEidTVuVozbmiMvCy89FFN
	 UbV0/6IC9o8Yf1bl6yZKF2197KVWDTA3nCUw/Nrc4p3QnaGx7DsYoWtmZdPIIOSTnl
	 eQGTogQwBqb/g==
From: SeongJae Park <sj@kernel.org>
To: cuiyangpei <cuiyangpei@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	xiongping1@xiaomi.com
Subject: Re: [PATCH 1/2] mm/damon/sysfs: Implement recording feature
Date: Sun, 15 Mar 2026 14:14:35 -0700
Message-ID: <20260315211436.95385-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20231201122507.GA15806@cuiyangpei>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A4C3218000B
X-Rspamd-Server: rspam08
X-Stat-Signature: y78r1ch5bt6jwo5ex4ytqhph5wf4ws8z
X-HE-Tag: 1773609280-656456
X-HE-Meta: U2FsdGVkX182eZ6lG59hC9fdMkNdgvgWasZwZHa5NXAqk5eNQMUysn0qOzigjr/bhGcomaxm9Jd3gcK/CLRgU/HtE962q3Yrrm6RM86Q8yP3sg2d5i4nx1WYDseL/Tvyw1VNrNbU5jqRRGPcmFJe17brMQciFHHnGLzD7hfZnHLsSIvUYqCFLDPvs2sq6J+G+lrwKN7zitVIfBerNE1g1Qh0Y0KQJj1gTx4mXmjOhQsbiiHPCZFzvZSj0h8XdzIqWC7F7rH8TvN+mnGmr9ud9Wl+ivQYC1BmUd3FnUliFHtUmnur2rOPS2AUj0Xh/YUDKKeqbI3o9mWwx71yeTm1Koff8OfSpxYugXXVi2iWmS9TNa0SkXYlw0G8wgEOhAvBPVXSezElWZTy2q9xB8rHphFIFbcqcwjz5L0MXa+UvPyFnhzLYPvUyouFsE7eXPSm5nRouvufXqdrlfrywbQl6VlCtiYyxfwnLi4QS8Mgv7cWkxP2czP3BbN8pOOy0VKJKIJgSI/yauBcCHJB0Dbnck1W8HCdZ8c5SXDreMsafJF51z4NKLQqNOfdhSIW5j3mVzdWZIbo/Cew2XxCNg0TtegWf8Yp1MP5elvU9z+80i3R9S+KHrgeN47o2iV9v/e9V9vnaD7bBf0e9+R/xyiIoWuxJbxmZBu8uMHi7Oxow9/EddT0rjgEmiJ3mpWp0vElPsBB5OEOVFCYjRLzWJ225K5pB9DDTf0Kzmbx1ND4tWvlPpoBGDdzdgdIPqhQJyoSmYitokpXLMR5aBk6LIdFY+wrupqm8O483DYYEMeKpkT5/HOV1eHAP1lM2xNIAfcvjo9xahyyHaZFTfiRTP+X8kyA5rNqD+10p1uNxnb1j1RsTAvuuVnMQntdSS85iElnJ9YwxWnsQpeNV7WCO+jp4TxGoWy31H2lBhyNRRkym/lxoJERVgxUcYqGft/2ff10hO8Zmcoei3gYV8F2SZa
 DRT4ZqtB
 qMBjX7tMKc6WqP+2WxfL2cocCp4EPXj+ogW8TQpru7y8gB1w0aKFtFmBzyWD0/VMuD0IoSIVfDUTwFf8P1TqzI2YlJ51wVY2TNZlSFPfb7iapkYYW2UUT1sgEzNBeWo3ayEFoZ360f7RVXVgw/JAZMH/t/EebjW2tvCLDFvBxaYXtWO+ToajvSH7WbR1Z/H2mGz5a8IWXzeQMcJqkcEoax5pVcQQz2cqJIQ2bxBX3v683KA0CBbgGuoQHYV29ah1zMI2U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Cuiyangpei,

On Fri, 1 Dec 2023 20:25:07 +0800 cuiyangpei <cuiyangpei@gmail.com> wrote:

> On Thu, Nov 30, 2023 at 07:44:20PM +0000, SeongJae Park wrote:
> > Hi Cuiyangpei,
> > 
> > On Thu, 30 Nov 2023 17:14:26 +0800 cuiyangpei <cuiyangpei@gmail.com> wrote:
> > 
> > > Hi SeongJae,
> > > 
> > > We also investigated the operation schemes you mentioned, but we don't
> > > think it can fit our needs.
> > > 
> > > On android, user will open many apps and switch between these apps as
> > > needs. We hope to monitor apps' memory access only when they are on
> > > foreground and record the memory access pattern when they are switched
> > > to the background. 
> > > 
> > > When avaliable memory reaches a threshold, we will use these access
> > > patterns with some strategies to recognize those memory that will have
> > > little impact on user experience and to reclaim them proactively.  
> > > 
> > > I'm not sure I have clarified it clearly, if you still have questions
> > > on this, please let us know.
> > 
> > So, to my understanding, you expect applications may keep similar access
> > pattern when they are in foreground, but have a different, less aggressive
> > access pattern in background, and therefore reclaim memory based on the
> > foreground-access pattern, right?
> >
> 
> Different apps may have different access pattern. On android, the apps will
> join in freeze cgroup and be frozen after switch to the background. So we 
> monitor apps' memory access only when they are in foreground.

FYI, I just posted an RFC patch that might help this use case.  Hopefully the
cover letter will explain why I think so.  If you need any clarifications or
have questions, please reply to the RFC patch series thread.

[1] https://lore.kernel.org/20260315210012.94846-1-sj@kernel.org


Thanks,
SJ

[...]

