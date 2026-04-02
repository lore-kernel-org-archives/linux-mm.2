Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C82BCC6B00
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 05:06:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 850656B0088; Thu,  2 Apr 2026 01:06:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 801096B0089; Thu,  2 Apr 2026 01:06:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 716A86B008A; Thu,  2 Apr 2026 01:06:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 632DC6B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:06:55 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0E42613AD71
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 05:06:55 +0000 (UTC)
X-FDA: 84612431190.01.04E788D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9F607C0004
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 05:06:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=co7KDZZq;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775106413; a=rsa-sha256;
	cv=none;
	b=ejAWXIBSqzL14EZPexNWQaRuaWvbRPDIgcnvwh2/3wq23AZmmlhtQZC6vfTGnsJq5dBSeY
	6mzU2/LqqCskklCOlbctf5AN1lY/D2cx9O7JJjRUKs6ybEpiD8ebaRVh1k4aAi9BmepxRT
	IOSgM5df/JhSwJPnKV6a64FXzJt1lmc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775106413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7cJv71YjPSfx/FOWjrK24D9Ho/t7pt8M8ag8UnHlnoA=;
	b=eWuXov3Bz4BixkICTQFZZZZOBc7FmyOTG6cASEIeB/PSjgP3VD8pRs11MuthPlmS7IzDBo
	QOD+deWqsqP2/VFb7jg2v2/Ax69XGzwfqQWZ6otz65OxS9ONS4Zhge5SUZvDj7n3HI2T+x
	Cxstb067NRcnSjSMEXYudLlYvmokmm4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=co7KDZZq;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D5D3961855;
	Thu,  2 Apr 2026 05:06:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46573C19423;
	Thu,  2 Apr 2026 05:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775106412;
	bh=wihPoKshCRvDn2VzvCkTU4pBOlXbXSfjJCzi/3jsd+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=co7KDZZqve8xBji8Vx9xt+xu/QeOhAumYCbmZnbRfc1ZRlVL8afw3jM5MFPCMhrK6
	 Q4SLY905C2hRhXGbNil4KA9HvtW/7wMkNC09FrMd6Vm+Lz/8ayG0YGNLb3mlo5nhJJ
	 VI5kO/sTpUW74IthDq3x5UuEvctp+4DJiiIXzcd8G8Oz1foOtrgYTVDP58z0GcSCwT
	 rUlp7gMqPbO3hZQXKtPBnPDgb92f7F5e3CKzC3fbqITeaGeR7nz6o+pkwnD8ZJUL74
	 xBdHmBxI7Pe3W+iX4rCYvQIKJ7I+0tSpLEBdJeVqxtwkWc/wTNyBznMpv6Xx6dLZuQ
	 Sr4/SB/ONuvtA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"# 6 . 17 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [PATCH] mm/damon/stat: deallocate damon_call() failure leaking damon_ctx
Date: Wed,  1 Apr 2026 22:06:50 -0700
Message-ID: <20260402050650.72289-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260402020745.68554-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9F607C0004
X-Stat-Signature: nrc87zr6nana3m4aczfd8kdzeqcip94h
X-HE-Tag: 1775106413-444410
X-HE-Meta: U2FsdGVkX18JJW/INBGLMI5cUBeZxFUJ5ZZQ4X4jSF0gfPzMEWE1yYzCje2Q2f+7CuSnG3b0etZnV0qCyc9t+7A5BhdBMmIbFawF7qIK8gfVe2n73JUp6zwD3er5lQ9Gj/By85aFEuDeFMiupJSDUMHNtzcknOQxz6S8fNUOd8GYvpKJFj3Ha8ug1UGxr8tUHajoyqb6tsiJX2q6l12b0fs8BzXBnq9kwG+w4i/ijKgylCBzqdnyNUuNSej9XDOca59JWmeWl5QHvWfYylEwI6QQnvN5HkqTUAKavGdKCXWRmxWlw8haTCu+U3VkPsytbl9AwMZgxomvJf57u8ZrPomi0VASfKx8c9V8gVnUHP5uFT+WzwXWmD9J7T3p8bjDdq+JsBS8lwqmQTkt05pplOmv6GT4IpWzcuUGFoByOqp9sWIuJnwlSaMzkep14zIXSf4Ui7nvcUtwkBQ2rZ5/EJFxdcyphIqwADeXn4ibDIU9PMeTkwhekojANUNnnxEA2p7ZkiSKHLKQqE14GH/AtNRX422diU2QhKZKcBZQIlDgSwypGxUPsImAJVHgOGvqLqf7iF0mocuACRWldJH9f4f1IU2/VQck5xhwLvSownhFYrWo3Tmig3BxPDeUfQxyBn4Q4h6HaGq/B9186d/A6u3P+iEGyagrfQv3D+tqPqqcO4bIiFAt75C3EBHojEZ5ukKcVj/RPJf1wrf1XpRgKz2D5rbmjJ2HP2m2qRKK2/nObXUjnxynEBsAQnRosREw5cyHHG0EC/R52vnuAezpPSUzi16bCmNUF+BnP9OJcj5WV7oCarPQ246PwrW/Rj2BLc4gQ3tZDV7CeKriQ7IQZOCuu67ux5K2xr1ZejKYGItjetECSSpXM5Ovcki3gIO8QMTe4KARHlaUrZqJh/0Iw9PUwZC0Dh4UPUbIxl9eRoifY782ptRYRede7o5F1htHZNid4saF39CoKFEVUEW
 gXgG8Dng
 bYkBC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  1 Apr 2026 19:07:44 -0700 SeongJae Park <sj@kernel.org> wrote:
[...]
> > > --- a/mm/damon/stat.c
> > > +++ b/mm/damon/stat.c
> > > @@ -257,7 +257,12 @@ static int damon_stat_start(void)
> > >  
> > >  	damon_stat_last_refresh_jiffies = jiffies;
> > >  	call_control.data = damon_stat_context;
> > > -	return damon_call(damon_stat_context, &call_control);
> > > +	err = damon_call(damon_stat_context, &call_control);
> > > +	if (err) {
> > > +		damon_destroy_ctx(damon_stat_context);
> > 
> > Can this cause a use-after-free?
> > 
> > Earlier in damon_stat_start(), damon_start() is called, which creates
> > and starts the kdamond_fn kernel thread. This thread actively uses the
> > damon_stat_context.
> > 
> > If damon_call() fails, the kdamond_fn thread might still be running or
> > in its teardown phase. If we free the context directly using
> > damon_destroy_ctx() before the kthread has fully exited, the kthread
> > might access freed memory.
> 
> Nice catch.
> 
> FYI, I initially thought damon_call() of DAMON_STAT cannot fail, because it
> synchronizes its damon_start()/damon_stop() calls with module parameter
> handling function, and it doesn't update the context internal state, which
> means the damon_ctx->maybe_corrupted cannot be set.  If that's true, this patch
> itself is not needed since the memory leak cannot exist.
> 
> But, kdamond can fail for its internal memory allocation failures.
> Specifically, if ctx->region_score_histogram allocation is failed, it will be
> terminated.  So, yes, sashiko is right.  There is a chance.
> 
> > 
> > Should we call damon_stop() here to wait for the thread to safely exit
> > before destroying the context, similar to the teardown sequence in
> > damon_stat_stop()?
> 
> Seems that is a workable option.  But given the fact that kdamond is already in
> its termination step, it feels odd to me.  I'll take more time to think about.

I just posted another approach [1] that can avoid the use-after-free, with RFC
tag for getting sashiko review before being merged.

[1] https://lore.kernel.org/20260402045928.71170-1-sj@kernel.org


Thanks,
SJ

[...]

