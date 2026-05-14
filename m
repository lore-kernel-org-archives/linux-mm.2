Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39CCECD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 23:46:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 092706B0005; Thu, 14 May 2026 19:46:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06A6D6B0088; Thu, 14 May 2026 19:46:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE9386B008A; Thu, 14 May 2026 19:45:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E23136B0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 19:45:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4A90B1A06A5
	for <linux-mm@kvack.org>; Thu, 14 May 2026 23:45:59 +0000 (UTC)
X-FDA: 84767660838.16.9850BF4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id B30F8140009
	for <linux-mm@kvack.org>; Thu, 14 May 2026 23:45:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RedXKoAv;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778802357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TocsWq0hUW+sqKFNASFe0AS7EG0ZhVczNI0kpGHXlYc=;
	b=mng7bLx+kc29/I6HKxyJkr/JyEfm5DUa5BZqnYzu/OLcy15FQ1H2v5NmuHJh7ufdauXgEO
	9D8lBKszzDS9jtd0594NamTROgvopQaKfriUeZ+2I5M/U60ZRW+OVfWzWbxECEt/NbrwF4
	fw7/wDp+EcM8LtaXxH2gAH9id32YZlQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RedXKoAv;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778802357; a=rsa-sha256;
	cv=none;
	b=Za1xiF/XE5eWmPq8xeaDZk55AqNWjM5mA0qYHHHIifgD+/ad2vs6x+pxYvj8KNd4cFRvoG
	vmVu9uAhfTPQavIePibvcTUKbhdbdOFhZ2iEEhBZsrddwBhTysSMnZKr9mBACdhNUXm4nW
	SfmDTBkLoIL1hmEviOFWoqiV49Ocm9s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 068E860008;
	Thu, 14 May 2026 23:45:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83479C2BCB3;
	Thu, 14 May 2026 23:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778802356;
	bh=bsHRd/vwPkavOuwpmuRZxnPcYjM2v93dFITdwXzhbuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RedXKoAvi8JZueyphlsZY/3r+qSX8OBulmGj2OvNmTJl0Guu49m0dw12EaEmP+/Bl
	 jzQ3eR/yz8IzZKawJNDOgt8GGUI5XVg3t4MffMaS2amLkfJNL1mvcdAbkH6QkuGEX6
	 aPLIrEa3vUIW2uF3IGFWsXFGcM4SJj4enGEXwdaMfxbAqEJvk0M7/xfQMMog0rtaxP
	 x0rE/A/aUyEItcBFmyPQha+0mkNzhiGmEZ6VIgWhQSMmVqgD4nmS8Y7bL8wbvzT1CI
	 r1E4FiflOgA/1RbL1O/IylOUx735eCnuXKxXiE+MINFbm5bqjaYOMrhkHvR+oKH5o2
	 9RxqkyxQjItZA==
From: SeongJae Park <sj@kernel.org>
To: niecheng <niecheng1@uniontech.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel@uniontech.com
Subject: Re: [PATCH] mm/damon/core: clarify next_intervals_tune_sis update path
Date: Thu, 14 May 2026 16:45:09 -0700
Message-ID: <20260514234510.123948-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <D3B0C1F5BB6ADCE4+20260514163751.3399513-1-niecheng1@uniontech.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B30F8140009
X-Rspam-User: 
X-Stat-Signature: frisdpttubdf4qh7ya51afaoe5a43a1j
X-HE-Tag: 1778802357-794008
X-HE-Meta: U2FsdGVkX1/AAhBQd0d1aFc87NqK3clp+zwCFO8SF8+oi0lwBmiFjZ4ThMufqP4Ovg4TCOTY3/hpcq+fNHOCrK54C4Hg5T4r+HYUlVKv0trjnAylWWwxD1ujgVL+6BroP/5Dtv/UzXUiphiX4Lx56b4oHxmA5saFGWcHweKAXxItUffZghV1upaOY5yHZ9KWUK3OGAw1bfxqlKQfzilusgX3qqrSbUTVXtIBxdP3ZGKTX/UJVFJjOS2K6q5gMVulgh29xqsEqHVVWvFE97iFJh5LW361T/ymha7OrZkW5ANeL/w1Ogg9Rjjxay91JPmGOtBBcZW6nnbNSXQmOYEQWqoYoxfdrNduWDL/2myUD7iRkLyvHVfItUfwCp5JvYzikpOQxylPP3k871qiReJQKGlDq1LscibgdhmAb3FWC4+kLIvMXYjbApwaVuKIAqBDOVIhqdkoiCRoMP1KbtXIeiZ7nJHYNzCBb04ZMGYMwdBvqoButBpx2yJHQLLbT6H3tu8+ArzLoB27iqiaum/wTUjw1vdC2qJ1W80IUo7BkNEM41KGiJcoLA9EH6FfmDC6tnWRGDNxc/F+KBlvhL/8XTZ5r8UXqZc/nL1zVyduLxCPOHqGtS+Jv2id1EfZ0wIjMPG9JwrWvIwf1WlbBtNsL4eKAnzucsyHoxxYvOuL/YrEej/4SZSnMVq28tIxpAnOUkUR9pB1Xnicu+3ZprFDjf4xdWlCExgLKvn7CW725P8HRsD3p5MKQhYmCntXt9Wk9/2F7VT0FYomXPMpZ6SKhoWLdaKsifOgm3Y1Fm3G+jUyzVuxaNLVcs2gSOXPQxy2BOEtQ39bNhx7PMyNRtNljTXkJm8kFmcJEN4Hi9VzA74CP5UeoKbebKCCThB7AGZ9UBDpYe1H4MQ9TbTuoe1vEgeYbSoR4b7FAnaOI/t/uwUZwWrLH3F7EFkbkXATuHziUnqWT+jl6T+qyXdzpyG
 zmdLXmjK
 ZvoPueyQYAxOhsrm948nIIhZffijaRCTHslqFprMDOD6/zmABMY7sCffFPe/hQAtmtfYs3ZmX+BpqJ9EbDFG62lFZScMkHG+E07KdYeggZ9PPr8iapOVPdN6ZpgCbY+tUvIZN1xkfMNJNCHYl1khmy/vCDQXLOAG/RHwto/gOiOlfRIbcNESMiAT7S0S0zWKB1GTrC91SVVdCiIJrHVUe48RA/13LmZA5gVd0IAFX4HBRetWPpjTWT829eXvDCymNGk6N2XSLD1bjsAz82N3cZWuRpPU0LcoZTaIiP0AkG2RAtIF8oKzlLUs24TtVIHC2CBJhzJ2L8OW6GvQEvnoPgMyi6YTqLSbxCVPol0IjrU52av8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello nicheng,


On Fri, 15 May 2026 00:37:51 +0800 niecheng <niecheng1@uniontech.com> wrote:

> damon_set_attrs() updates next_aggregation_sis and
> next_ops_update_sis for online attrs updates, but it does not update
> next_intervals_tune_sis there.
> 
> This can look like a missing update when reading damon_set_attrs()
> alone, while next_intervals_tune_sis is actually updated in
> kdamond_fn().
> 
> Add a short comment to make this explicit.

Thank you for making the code easier to read!

> 
> Suggested-by: SeongJae Park <sj@kernel.org>
> Link: https://lore.kernel.org/linux-mm/20260514144102.120203-1-sj@kernel.org/

So this is a second version of the patch on the above link, right?  From the
next time, please add the version on the subject prefix, e.g., [PATCH v2].
Also, from the next time,please post a new version of patches as new thread,
rather than a reply to the previous version, with the revision changelog with
the link to the previous version [1] on the commentary area.

> Signed-off-by: niecheng <niecheng1@uniontech.com>

Reviewed-by: SeongJae Park <sj@kernel.org>

[1] https://docs.kernel.org/process/submitting-patches.html#commentary


Thanks,
SJ

[...]

