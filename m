Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3D6EE9410A
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 04:49:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C41FB6B0005; Mon, 29 Dec 2025 23:49:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEFC96B0089; Mon, 29 Dec 2025 23:49:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFB5C6B008A; Mon, 29 Dec 2025 23:49:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9F9E86B0005
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 23:49:07 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0DA5716129F
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 04:49:07 +0000 (UTC)
X-FDA: 84274907934.20.AC68B15
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3995040002
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 04:49:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ovyyabce;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767070145; a=rsa-sha256;
	cv=none;
	b=DHpxK+8d1GoPyLtItoR2TuMXvT9f0wqjw63jtpzrTLIsMzlUwP3tWc27yEjPUU+/ODdMjm
	eAcndRm0iNcsnP4pnWIBlfYV6WhiefJ9ZSDJsDdXFO+1nczoK/xzvsRVz+NZWwRk8zZCve
	0TuIA7Kf3/g/rS+jUP0fx5l8HlWv+Hs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ovyyabce;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767070145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8hZeno5oIt6J6Bc6V0PL7wUGOP1/2GdnYexT8Hupqww=;
	b=ivlAUK+84fruEMT7RhV/XYL8Dg1K7f1OohHR9v9ASnbqwnnNs91L4Dyxd0w4gs2L+m1NIU
	eWQWfihYkzJ32pTQXN/MYzMeqZVnps6hCM7d2RWNrr7WOnGfntieLZgoxcq+XHQORt7fQj
	D7enosOI2ppDXk8fwPOq5haoWL3CXIo=
Date: Mon, 29 Dec 2025 20:48:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767070142;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8hZeno5oIt6J6Bc6V0PL7wUGOP1/2GdnYexT8Hupqww=;
	b=ovyyabce7Jt1awm1nqzdjwTZoNxtEAY5Hh/oEZ2fpFEev2gAhRvJ0M0ONabqtbUzmNpSK1
	8pTWncgHE2uOR0vE8y24K+SnHSgKcqd7g3oJB1m9ch4gsZmnVL8dXpMMAOKpn1Hdwud6WV
	aQpnfKqsLRgmiVJbXb8pXzwyyQ0I8qU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, hannes@cmpxchg.org, 
	hughd@google.com, mhocko@suse.com, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, imran.f.khan@oracle.com, 
	kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org, 
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 00/28] Eliminate Dying Memory Cgroup
Message-ID: <krpcb6uc5yu75eje7ypq46oamkobmd5maqfbn266vbroyltika@td6kecoz4lzu>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <7ia4ldikrbsj.fsf@castle.c.googlers.com>
 <1fe35038-abe1-4103-b5de-81e2b422bd21@linux.dev>
 <87tsx861o5.fsf@linux.dev>
 <c3ee4091-b50c-449e-bc93-9b7893094082@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c3ee4091-b50c-449e-bc93-9b7893094082@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3995040002
X-Stat-Signature: x51zanmugamwcpragzhio7cwa798hbmm
X-Rspam-User: 
X-HE-Tag: 1767070144-876811
X-HE-Meta: U2FsdGVkX18iiamCVMYTi/KCJMMzhwKMlsaj0DNOQzJRQzwgSWK/uPlNVfFNVfMPxVVcKEbN8hvOb+3OJmG42V9Ah3DeqwWNjnbgnt/sQpkaJJ4OAX1oGDnNbq4RNWONxNfUmaiNlAmUbW+zF1xx8oWAaJ3C0kMCyCxqQB3EE+20IdHpdZCMV79xJVx9A6O8aA9mI09wnpNJ8pZTV8rxkQ6ed1oQXDxIdXaUD4KN1X3O2sMEInthroN+QPC6QcYRR+EqIW4ilJiGrRibh7BywAU19CoDW9xz8/m1lBJWWZADdfyJqtQskd+QVHzRi3qB/IzDZ6YaAiQ7nBceL72M1JBFe5JFQ0Q4bE+qQe22lR3nwkyqVNyIufBS3Y31JbcDcWukQIZOyK+IWht/ZWSmruUPIcE/x8pUKb0s58/uiEvW3IKwt2DrT50smTNpvgx/04uyYNWO1VVp5r7e1cb+8W2rJyhyvHkAScBopMeQNXPoOg4X7cTi+AbaiTgizLHWx/4vDAn10CLwAywkYtWDl4WaPJQNIHuFvFb6lk//lyxgsR4HW30fGaQtGJsz3QCkS44DWCWpmxWgi2saGPB/BKLPb++YkdXwnWpXfaHaQ1WetVjPM1RKMzWr/C4bBgoTkoxvPJo/qZ90qeI9g/NNOaJdMunOgEjv/Uj44h22rw1nZF8VLqLPKTyvBiOx8nKb4vBeoT3g10x8PxohdKQw3ueq5lCKhUOxsXaBtNOrmVA8eQyQCGIPIBzntUYGF81cvq3XzKdomy/LaMiZSETbvMwQThUewPwsnrmLvjbnXm21RfyEcz9nXobOVAFSjl0ErSbqaDnaUZc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 30, 2025 at 12:25:31PM +0800, Qi Zheng wrote:
> 
> 
[...]
> > > 
> > > Thank you for running the AI review for this patchset, but please do not
> > > directly send the raw data from the AI review to the community, as this
> > > is no different from automated review by a robot.
> > 
> > Hi Qi,
> > 
> > I don't know why you're so negative towards it. It's been great at
> 
> No, I don't object to having a dedicated robot to do this.
> 
> > finding pretty tricky bugs often missed by human reviewers. In no way
> > it's a replacement for human reviews, but if a robot can find real
> > issues and make the kernel more reliable and safe, I'm in.
> 
> I just think you should do a preliminary review of the AI ​​review results
> instead of sending them out directly. Otherwise, if everyone does this,
> the community will be full of bots.
> 
> No?
> 

We don't want too many bots but we definitely want at least one AI
review bot. Now we have precedence of BPF and networking subsystem and
the results I have seen are really good. I think the MM community needs
to come together and decide on the formalities of AI review process and
I see Roman is doing some early experimentation and result looks great.

Shakeel

