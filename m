Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DFAACA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 13:21:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C74D68E0127; Tue, 12 Aug 2025 09:21:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4C888E00E5; Tue, 12 Aug 2025 09:21:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B89798E0127; Tue, 12 Aug 2025 09:21:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A172F8E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:21:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3399357C78
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:21:21 +0000 (UTC)
X-FDA: 83768166762.09.140D57A
Received: from mta20.hihonor.com (mta20.honor.com [81.70.206.69])
	by imf13.hostedemail.com (Postfix) with ESMTP id 93CAB2000D
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:21:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf13.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755004879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ywcBlogMrLUaF0c3jQFVnxTYpIcvBhvxWvSX5UTus60=;
	b=TzKRT2G1cE6jQpuI/5XSmCNnpUx/34vPCCtzGoIjrevMD+Z+T/4/f4+qPKXd7VEstFPHLH
	eNiE1eXipBNstvo9Sd9CU17Cu+M/VeuUFB5hM0Hw0rSl+/V9EgiGJCXS+4jQLdTuKrCl/F
	eBH6ggDcZAlztJMNjd67FxHCu1PisfQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf13.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755004879; a=rsa-sha256;
	cv=none;
	b=encnOa2wS1zTPKkq4zUplZbLgWaEekQMyGpafPmZAWpXiyCejd3JbT+C9bZA/GHoTIm+EJ
	6dGsMF7JmnY/ZxMijahpt0tLmLoS1BOLO1TJZOzidAc813gYCjcoNlzAJPGbaarMMEGtT9
	ALoIEfebVU7xkBo79HuhSxlx77tNrcw=
Received: from w003.hihonor.com (unknown [10.68.17.88])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4c1XFT51GXzYkxsh;
	Tue, 12 Aug 2025 21:21:01 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w003.hihonor.com
 (10.68.17.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 12 Aug
 2025 21:21:08 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 12 Aug
 2025 21:21:07 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <tglx@linutronix.de>
CC: <akpm@linux-foundation.org>, <andrealmeid@igalia.com>,
	<dave@stgolabs.net>, <dvhart@infradead.org>, <feng.han@honor.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <liulu.liu@honor.com>,
	<mhocko@suse.com>, <mingo@redhat.com>, <npache@redhat.com>,
	<peterz@infradead.org>, <rientjes@google.com>, <shakeel.butt@linux.dev>,
	<zhongjinji@honor.com>
Subject: Re: [[PATCH v2] 1/2] futex: Add check_robust_futex to verify process usage of robust_futex
Date: Tue, 12 Aug 2025 21:21:03 +0800
Message-ID: <20250812132103.9910-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <87cy99g3k6.ffs@tglx>
References: <87cy99g3k6.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w002.hihonor.com (10.68.28.120) To a018.hihonor.com
 (10.68.17.250)
X-Stat-Signature: c63i5x4wsds1kxabs6k7murenyy6ot6g
X-Rspam-User: 
X-Rspamd-Queue-Id: 93CAB2000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1755004877-526880
X-HE-Meta: U2FsdGVkX19Z7f4WzpUxWSFDMIm9KM+Ju8VIicvinEBcT+cD4+wSBcEmYCrRwMzlFNH5khC/ToTJPi7I7olgcXswHZCJD5ejb6Lf/PZGaXutGij0JEihPwjOJCpmIUdsTwQjIndxSsf1iXKG/uG3Gp+1+eQ/vPUUdQL6pkIxLouKpcQ0ukO8DdGbwqhOSnqCVkY8iLHkzyY7mq1Erc33LWBx58iyXDrhob6VIv6n3gxldLeCBeCh0aFa2LCSqftj+HZy92fTTVaYoYvpybsGp8Y5/phLHMl14wjyU/Kq6aO9EsrGq/tcxM6BF4HL/TZUxd+b+Nr0W6HxLJvukHLRHXGU2Mj3wsfv+WoaAKv6tKZJ6iLZkj4FUMyxi8iAgG6dWbnPlzhqNt2qWWeEDAE4TT79Ysmr4LKld9COwvxrrV6hAnw4Jwfy347X04B7DsK8DDUAyI8vXL7nJkkQcnihYpR0yLz1SCFDanFyKy7zBFBkBUmNwojZ8SRSUsZWrhwcYMl+2yiEzK2KSQH5UDSs86ZRLJGiaA+pxfsCG3U4GQ9i3iwH8QXJUHTCrpvtfevPRlbFRPbSrtV6x7fDY+19GuXwXWFAwtnbMaK+SG7nZJgo0iC1SQgh2q6Eq1dsM7U3GM/DoIVq990YtVZUNtnKifpf5MNEVgqpZHtZ4lkcM9vb2AAPSTw60+ij2fiLocAiVmKxhIVYzVlOAYoPfZ++2q4USO0X/6F+bYOTH831ecG5Cnlcms6Q2LWTnnSnltjkFWYWQAXNy8fVV/9sy1RCubuTKj22O+UXtJtQzTrqdWRK8WFkIJ0EyMdKbeeTswNg489GYU/3Far+acrl8EqBV920B9Q3iJJnRctilYBAPME7Xhqp6gjd/NM7f7mRaGQb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Please use foo() notation for functions in subject and change log.
> 
> > The check_robust_futex function is added to detect whether a process uses
> > robust_futex.
> 
> Explain the problem first and do not start with what the patch is doing.
> 
> > According to the patch discussion
> > (https://lore.kernel.org/all/20220414144042.677008-1-npache@redhat.com/T/#u),
> 
> Can you properly describe what you are trying to solve as part of the
> change log? A link can be provided for further information, but not
> instead of a proper explanation.
> 
> > executing the OOM reaper too early on processes using robust_futex may cause
> > the lock holder to wait indefinitely.
> >
> > Therefore, this patch introduces check_robust_futex to identify such
> 
> # git grep 'This patch' Documentation/process/
> 
> See also:
> 
> https://www.kernel.org/doc/html/latest/process/maintainer-tip.html
> 
> > +bool __check_robust_futex(struct task_struct *p)
> > +{
> > +	struct task_struct *t;
> > +
> > +	for_each_thread(p, t) {
> > +		if (unlikely(t->robust_list))
> 
> This is a racy access as the thread might concurrently write to it. So
> it has to be annotated with data_race().
> 
> > +			return true;
> > +#ifdef CONFIG_COMPAT
> > +		if (unlikely(t->compat_robust_list))
> > +			return true;
> > +#endif
> > +	}
> > +	return false;
> > +}
> > +
> > +bool check_robust_futex(struct task_struct *p)
> 
> The name sucks. Public futex functions are prefixed with
> futex.
> 
> But this is about checking a process, no? So something like
> process_has_robust_futex() makes it clear what this is about.
> 
> > +{
> > +	bool has_robust;
> > +
> > +	rcu_read_lock();
> > +	has_robust = __check_robust_futex(p);
> > +	rcu_read_unlock();
> > +	return has_robust;
> > +}
> 
> Why do you need two functions here?
> 
> If the OOM killer is invoked, then saving a rcu_read_lock()/unlock() is
> just a pointless optimization with zero value. rcu_read_lock() nests
> nicely.
> 
> But I'm not convinced yet, that this is actually a sane approach.
> 
> Thanks,
> 
>         tglx

Thank you very much for your review. I will fix them in the next version.


