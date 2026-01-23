Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C755D6CFBD
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 03:57:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED1B26B037A; Thu, 22 Jan 2026 22:57:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAFD66B0386; Thu, 22 Jan 2026 22:57:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE6116B0387; Thu, 22 Jan 2026 22:57:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CDE2F6B037A
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 22:57:06 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5DE8F1AEA13
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:18:07 +0000 (UTC)
X-FDA: 84361769814.09.14EBE27
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id AEDCA120003
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:18:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BfxcSjFt;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769138285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bBa1opegXvihHUYsnRQChp1IEIKxoUt/Nr3e9tfuCps=;
	b=N1sjFKhSNULifkvjhvMz+CM5nU+Bk/TYermBTp74FLKkQwx+GE7ci08I2E69ych7NlsQjc
	g/utuxvxNjzprDoWAYQJ2ktonyMTBdWeaeshcIyksJtbtzYFQ6jlR/3NipYjKgCGkO0m/Q
	KbPq92C/Hrpn4PazXdQXMqQSmyBTlEg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BfxcSjFt;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769138285; a=rsa-sha256;
	cv=none;
	b=A2vrBKg+cxPde/GoDYx1unXKhmrr0mwUOaf8wejFrFxSnBZHQjlChBKsR/xt/ALwR/mzJs
	QobjzUQzCYB3km3ReoEsfshHSBeloLKkLA+4xpHxzWvKNv60l8XGMlAUMGzeyUBOuUAe20
	q58HTJl+wfukdGA/rG6RRL/CtU5lPHI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D174160135;
	Fri, 23 Jan 2026 03:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D298C19421;
	Fri, 23 Jan 2026 03:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769138284;
	bh=nlPeJAhDYljmTRmioPpA2sw/m+1n7Bd8TriNkEkzG3g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=BfxcSjFtu0XN92Qicx3/UT5FVLzq69pzsSNPzmVs/I0qZL4aTz87xgTRr8/SKNrt0
	 4Du/XwpQmM8EjWl1N/QzZEmgYtFiJwsl1ZQFW0+yKUrgtnHW7ssCqVy8OhgDh/jsPL
	 wEb8kqCSCQS5HQ2OPd9tz4JJnAk7VVqDMY5yFY38=
Date: Thu, 22 Jan 2026 19:18:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Li Zhe" <lizhe.67@bytedance.com>
Cc: <david@kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, <muchun.song@linux.dev>, <osalvador@suse.de>
Subject: Re: [PATCH] hugetlb: increase hugepage reservations when using
 node-specific "hugepages=" cmdline
Message-Id: <20260122191803.96e521b3a8dd579373f5bd66@linux-foundation.org>
In-Reply-To: <20260123031400.37480-1-lizhe.67@bytedance.com>
References: <20260122141900.3eb028abe20f6c31808f9b5d@linux-foundation.org>
	<20260123031400.37480-1-lizhe.67@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ezab96bsy6539pszy8yj65ebkccd158r
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AEDCA120003
X-HE-Tag: 1769138285-647135
X-HE-Meta: U2FsdGVkX18Bj4LABBSnKlXaXqkv9EnEQbbbKPhkDcb2B+gujY5voKJ0T8PDV/mBd/oFeDYogW/tf+s5G6TLc4wv0jGhKiaqjKujRT75vUmSDdMTTmuf1GWB1In0xKtvbZT/kjNiFuqkumtfOYt67DqAZWeXAWou3BEU/NBLRt/nm/DKRTtuf3TtQwvGahOMj0/0X0O8d+hO7CqsigVMosGND2QZEV2lcg2XiovYdeTaVXg3XsT9TqfTLSv52KO164Fw7vME0ON+9Sivs5CddC1xZYwCDxRunsXPDdj8pfkwxU/SYldkZXkKpzWlXfvEaqlC7vPB1IoL0Lt5LKiUBatFQ40AdUT+m2vbKmhisS2xtXEA5wHPVzIMCSs4fv0uJUC7DMaNO72biTTG9Pppizo7AmdDA/iU46/qpeOEZnh31wHI4MzG64dwVnwhp1OZCt5YUPPic5D72kQ2XOlZPcNvZgHFa/1keIn/O2yaGjf8MEu1f1253XdCDn5lHtSpPtILS+9SoM2hgAy3XHSIDvYGC/am4wseDCwos4r9SdXtX/8XR6ItFClWwTXh0Ktc6Nl00hLTXIlhN9HzY/9iOhl/gvsLbkxeNyt7GtaEqMfvoPvwSj+IdfgiYPUnN80Vzy0e08gCwm1LGsl6kkHtB/Z+cZDXy/RmSsIrirNKEqi3r+lv71d2hxThpnrMQ+7LRtKLHPVdX9e+6kFR1d1Ly84U7D+mY6lofGZ+YFQmYRcezP+jIn7uvTh0kEAKvp/pl3s1VD2luR7POTKcdWTCXbYJ/T7B9lYH7a+wUGZaXplIvpdgqadKM7y/p8mcW+Hy+vom4BSuWsAHwGyXdUgTt8V+XNOkKRMfUNIKHYX6pseSV5CKpjWRz8eii5X0Iryh4B9SWROxjUAPpz26uTL3xxkMXmWYWleJPJF1bxWnegDa/scTGcHBja73BFqvHfIbei3IRipylE7xiNbbZ0j
 5PLwPYQv
 qMdHzl8UIWKX60UBfKIlsZzFnw6frG6O8HqFvXp0S3z9Qyf3wI/6oX0YYJzr0QA/Ibzr6/ZS3WM+dKv2bxgAg1WdFkipYTHf3pLqI2+FxkiOgLeipfifoJY/VSGn3K0ct8wMfL+7HzQMI0dKX77d6NEytxB41d4OHRfTNlhfDJb5N92q8cxC38262CyqVtLCkh4/ONPwNQJmZHIm5lmp87GKs4kf9S3QKIgI2jo2CQQmfDDJduQzu9YypierjnT7svkj6PCHpcvSULYE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 23 Jan 2026 11:14:00 +0800 "Li Zhe" <lizhe.67@bytedance.com> wrote:

> > I *think* the hugepages= documentation in
> > Documentation/admin-guide/mm/hugetlbpage.rst is still up to date and
> > complete, but can you please check it, see if there's somethig we should
> > do?
> 
> After carefully re-reading the documentation on the "hugepages="
> parameter, I did not see any points that could or should be optimized
> regarding the number of reserved huge pages.

Wonderful, thanks!

