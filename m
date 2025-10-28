Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BC99CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 14:33:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C94E280169; Tue, 28 Oct 2025 10:33:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C452D8013F; Tue, 28 Oct 2025 10:33:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B34BD80169; Tue, 28 Oct 2025 10:33:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A08868013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:33:01 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4F43858830
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:33:01 +0000 (UTC)
X-FDA: 84047764962.28.592C404
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9611E20003
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:32:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LbMXCvkX;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761661979; a=rsa-sha256;
	cv=none;
	b=YvrobzGtAjP8f6ZbiYKxrE7qaGuN9FzMBwV6Dg7JzpWIBSz/Qap84VxflMftAbud4TpQE2
	rbOZMnXgQ1GvlDOR6HWjKoHFJfCK67Vd5YF685xd6G4Q0CxfJ2rPuRqTSm2qA/DWXybhek
	PKkbIpWy+4yky6SEWjsCuYCPRe1CL58=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LbMXCvkX;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761661979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ue43B01s89h8dTAVoRHvq+SnwBXTt8eAkJfY/Fbr4aU=;
	b=HuYihmVa0lSskLfOKo5B8N0yxnhVyiHuabhXDjrPvpVD/gxq5nScIginTVDdKi0mcgAzzF
	Wu8eONmKQW2GaqjnxPOVZ8p1Rmbb3hcO/sR3UCViVAyhk0B9HUB3OORaYQ4myudzBxs9aE
	flOlmImX17UT4kzY39hcQxPsrlB0nEY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1FDDF445E0;
	Tue, 28 Oct 2025 14:32:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9596C4CEE7;
	Tue, 28 Oct 2025 14:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761661977;
	bh=m8qK9GrgBHEtoVg+nw/e+zKxXz+F9N3oAZJPB+bVAzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LbMXCvkXhDDPeEkYXnOKpdGA1nfQvLIw5sSl/MYVTkKI7aknfwsfQ24ERHdu4BHIA
	 rselvPLqKbpZ6dnfgJs+13sTqw6xgfGG+gnR89HTweuQYCFj7JI6TtLtrzt2ZyJW4U
	 qTkf3OacDQT0S1135AhcMB+vsUd1HnsvMJSSzqQWIYXfLbuVuoGv8sU5zMU2qqhpCC
	 KDdMK2a4TscA23GUnkYxzY4P/BFPjCkKs30kmDkUR6LZXymGnR2PJn5P91vmV/euD8
	 y4lP/GbEtC4hrmA7Iw7R4S7gi0w9BkFZ2fey1WjDd4vNOLxY7wv2fe8hcgI0FiNUsw
	 Z2cExOhSi1oew==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Quanmin Yan <yanquanmin1@huawei.com>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [PATCH] mm/damon/stat: set last_refresh_jiffies to jiffies at startup
Date: Tue, 28 Oct 2025 07:32:49 -0700
Message-ID: <20251028143250.50144-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251028141915.49989-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: qsqycwzqahjh6toehw9saweaan77enxh
X-Rspamd-Queue-Id: 9611E20003
X-Rspamd-Server: rspam09
X-HE-Tag: 1761661979-872736
X-HE-Meta: U2FsdGVkX19Jv9vHawOIhaaOUtFwKwtaK06Gm5h0ZSkegcVprujudRUPYttFY8NmSpmFAV+8Ua5u1Wxvzj7G2PfgQbRzyChVLw3zxzeaWZE1fdSsjVUlTvh4IuhzzagfUJQUq30wN71jLl8Bp/5Xl7Ds2e+Gn6QnQeWLOzRMoHXXSSN8CKTxvRlCNo0zYHpJsd/TUe7Uc1zmHNxuyTRjzC+aOnboJinZ3W1x/UAMAD8EjGRVDuAralOP1x85rvYdT/cIu6nhHl4CSbNT07P9CjGRNSbjbZy8UmnJXXctLIZs18wzoRcFukTl4t5DxcJp1TL0irl2rSK4GPHQTEqg67ENcSE3s3P4bK4XHF4pvsu3qU3ca9t1tqjH94bkYjbCQpbdNBnq2yiwDAyMCBZVzW10sF5q/+zrLu39urlFWriDVLCVBXIR7ZwDKgAfXv1m9Fpthuak25SD/E6MUzCSeY/vcFvSPnoTtlv0L1tiiQqf2/qCJJnc5282d4ctoGQGZrExzI1QhF4XWDJMWSIt4EtZa/4d5RSVHTSMlir3lQSUC9XKiFgKasEPJ/+Hy7xm4/VIeqjHkNbkqwbJ2kbIE9yfVlbCtC2NQ0t4wFqP2jOJF0VWwwvKVbSgLVj32XDZmK5Yj1t71LmBxG7Wpem9iDfu/Y+UuVFOO7L3F5hMXeGUBpCAVuqunulks86ftrptqVp4jGpORzOwAUIXz6NbsTHUiqD404DQBWJA3GKmry/h9MlhHF1YJYMhYf035nR6d9o2AwxntqqW8EWoZ8dCu8LMRvRxHWINnGzIJ3lUXx2H1bFP64wQIujCqBEQj1hS+tHoVu+Po0cWkAwrvuTj6tmViaQ5mnyFIU/cyV2yDsNsDXt+psXsYCBsVA6v8oZYEHpItLfszd13Mwez45fesQGZkx4vNUgPpYSqmbXb/DASP3wiXhl5xYzpdCTH7heZLQkhInQ5hGVw7q29We/
 ZE/ICRBE
 r9e9osEU9V6TuvtuCMb3s8DwciAHRf6/352U8V2tWXn0omN7BkYAG7W6g8JwQQ8hxMKQftHvwSvzRVzvGcBYnXyTITcvI7ATaRt3vDkOAyaLH0pndk8vxHF+eRaSVpbn3r4Qr6CEOftKdjLeRyHwMFtE7RsFJNbtfedshvCHEKIsAFBb6ZUn0qK8uMXbjLUuUaqiLtSZEjDUpiBOXqFRshJ1HxKBGCTZwaHKv8LMV8couzd28vXzQttkcZ5oiDjnmXs+/Flg87IZ85xy55oT4smVeaDJ/bj41BThdBbCp3aY3dtR0/SbNlpUzrBx/XRJH09i8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Oct 2025 07:19:14 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Tue, 28 Oct 2025 14:19:27 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
> 
> > In DAMON_STAT's damon_stat_damon_call_fn(), time_before_eq() is used to
> > avoid unnecessarily frequent stat update.
> > 
> > On 32-bit systems, the kernel initializes jiffies to "-5 minutes" to make
> > jiffies wrap bugs appear earlier. However, this causes time_before_eq()
> > in DAMON_STAT to unexpectedly return true during the first 5 minutes
> > after boot on 32-bit systems (see [1] for more explanation, which fixes
> > another jiffies-related issue in DAMON). As a result, DAMON_STAT does not
> > update any monitoring results during that period, which can be more
> > confusing when DAMON_STAT_ENABLED_DEFAULT is enabled.
> > 
> > Fix it by setting last_refresh_jiffies to jiffies at startup.
> 
> Nice catch, thank you for this patch!
> 
> > 
> > [1] https://lkml.kernel.org/r/20250822025057.1740854-1-ekffu200098@gmail.com
> > 
> > Fixes: fabdd1e911da ("mm/damon/stat: calculate and expose estimated memory bandwidth")
> > Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
> > ---
> >  mm/damon/stat.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/mm/damon/stat.c b/mm/damon/stat.c
> > index 6c4503d2aee3..6dc3e18de910 100644
> > --- a/mm/damon/stat.c
> > +++ b/mm/damon/stat.c
> > @@ -132,6 +132,9 @@ static int damon_stat_damon_call_fn(void *data)
> >  	struct damon_ctx *c = data;
> >  	static unsigned long last_refresh_jiffies;
> >  
> > +	if (unlikely(!last_refresh_jiffies))
> > +		last_refresh_jiffies = jiffies;
> > +
> 
> How about doing the initialization together with the declaration?  E.g.,
> 
>  static int damon_stat_damon_call_fn(void *data)
>  {
>         struct damon_ctx *c = data;
> -       static unsigned long last_refresh_jiffies;
> +       static unsigned long last_refresh_jiffies = jiffies;

Actually, a similar issue can happen again if DAMON_STAT is stopped and
restarted by user.  That is, if user stops DAMON_STAT just after
last_refresh_jiffies is updated, and restart it after 5 seconds or more, the
time_before_eq() on damon_call_fn() will return true, so stat updates will
happen earlier than expected.  Shouldn't be a real problem, but better to avoid
if possible.

How about making last_refresh_jiffies a global variable and initialize it on
damon_stat_start()?  To avoid unnecessary name conflicts, the variable name
would also better to be changed, e.g., damon_stat_last_refresh_jiffies.


Thanks,
SJ

[...]

