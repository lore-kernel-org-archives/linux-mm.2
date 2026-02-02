Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9391EE65293
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 04:26:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B646F6B0088; Sun,  1 Feb 2026 23:26:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B11F56B008A; Sun,  1 Feb 2026 23:26:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3E0F6B0092; Sun,  1 Feb 2026 23:26:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 947C96B0088
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 23:26:41 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EC67DD505C
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 04:26:40 +0000 (UTC)
X-FDA: 84398230560.11.771DA8B
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf23.hostedemail.com (Postfix) with ESMTP id 45CF6140006
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 04:26:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="WK4WO/Vx";
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770006399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RX4DYoaFUx1Q/wII/CNEigIzDOhmkDv7YtwkWo/GjWA=;
	b=GbC7uj0V5ENH9uf4gevZ1p8p8Vq10LJlaCc+GKX/pcfqmkPIexlFu26y785BuNIjMOdtur
	YDPnvN8xx17G2f+OGif5briBeUykOCFspew56kFtmMjnKvi/sHepg/xa0louNoVUxLOjLN
	b1O1ixvsFhtUhrfSnwGUPkIYVzByPes=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="WK4WO/Vx";
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770006399; a=rsa-sha256;
	cv=none;
	b=Ja6pz3+7/VmbjJPXqkrVTjJbZgt1Ozh9kCHNX5ZykYk/3uIC2chI/AFZRMdSoo0jYcojXM
	EBHUAA//8jdJ4oHnF0VZHqlvK+oMzYAcEvlpl+fzYwAkYGm2xS/QUxDdhyVlv7mfBb4ybf
	OvWf3Z7NGeJMPd9/2fcm67dcSbFOmrk=
Date: Sun, 1 Feb 2026 20:26:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770006397;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RX4DYoaFUx1Q/wII/CNEigIzDOhmkDv7YtwkWo/GjWA=;
	b=WK4WO/VxIDlhyJ7Yt7tThvk8vTVtZPlexdarCKgavf04ztFMlFdK22LNttf1+FdeZ7uO8h
	TwOYJJ4QnchiuFoX/L04ZlJXsUcv+92qRcVIUtqXiNPnEzyTVnX94MjWVnh61MOGLiOymt
	+lENuKBBYW9WdNa+dWqXd1PpTrpmSI4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Dev Jain <dev.jain@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Qi Zheng <qi.zheng@linux.dev>, Vlastimil Babka <vbabka@suse.cz>, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH 1/4] memcg: use mod_node_page_state to update stats
Message-ID: <aYAmGc6lu973jRwu@linux.dev>
References: <20251110232008.1352063-1-shakeel.butt@linux.dev>
 <20251110232008.1352063-2-shakeel.butt@linux.dev>
 <1052a452-9ba3-4da7-be47-7d27d27b3d1d@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1052a452-9ba3-4da7-be47-7d27d27b3d1d@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: 5xopeyjn6eu6nij8y5j894ado9ri9r9h
X-Rspamd-Queue-Id: 45CF6140006
X-Rspam-User: 
X-HE-Tag: 1770006399-976839
X-HE-Meta: U2FsdGVkX1/aBcG2Uw2JmcfRF/UcwLYPGzfhM9m3d7BzNa5OMKa2vCYmGFf4NRP+YnzED7rbeb+iKx7/KE45B7/JWKKlBUcoqJhSn91bQtuv5o1bVeZYCnN6Jqt6tt2RjPM4Y5oMzZB5nK56qXbTuDX9y0drNKVBn1I/ur3EHMtTHXBGWTz7p7W72btQytSB7hVhdOV+f3ZJ079n8JK5pywLb6vpqf7kmPl6UpDU5kj4BNYJ1N0SQyJu+woz66myUclZ9FKUVhRKeLISSw3naidtVb25I90RMOSBIsUqlK0yCxqXnnhAxSxqrx8o4vBkVg0kX3XGUd5b6fFHEVGiRqQBcbPQD2/y3OArOq8E/xRqn0z0s44XSvVFyqyuYlDz4YNBrqAJCcZvbdno9JChcwkefp/kjLXlJVpTYd32MbPETpivGyGyraPlENVSm/ENNBaUvLnB2gnQKLReNdqKJkobo2yBNi12wFTmiUYck862NMzWbltan5/29RbYiWvZOGccUBODlRX+AhHdmptzfwvCFRlQZWSnnuSpwpUETOt8BJRQ2DFwV/tBMjfeEhGejFiDDQzOvy1EiUFlqT02BaisCKOLVQK6JtDxLYPQbkwTLJ5NeeOo8/ou20QASKM1OxycbWFAxMzwLwDodpFRy04NU0cxNgXXxD/4mqrX7uxp2e7zSsjn3ZkKK5Swt+5+93WqRW93yS6XdsBaGtm+AOrd8hT61QtCa9exQYBVlCrqA3ebIsnH+ObwkToj62zsTHuqvkHInG8JCxAUL1CvmM4ofqGrLPOpUONhxOLZBrreuK2zqCoTM5C3wqcww53f6QXlQ2xRCqrPtvktUXNd84Oq1ILVVa54zi1EcajBikaSIHSqj+LTXMkM2RjhQk2M+oVv4VgSMFNROnmaenGvu4qSj+FYQ7pK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 06:35:21PM +0530, Dev Jain wrote:
> 
> On 11/11/25 4:50 am, Shakeel Butt wrote:
> > The memcg stats are safe against irq (and nmi) context and thus does not
> > require disabling irqs. However some code paths for memcg stats also
> > update the node level stats and use irq unsafe interface and thus
> > require the users to disable irqs. However node level stats, on
> > architectures with HAVE_CMPXCHG_LOCAL (all major ones), has interface
> > which does not require irq disabling. Let's move memcg stats code to
> > start using that interface for node level stats.
> >
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > ---
> 
> Hello Shakeel,
> 
> We are seeing a regression in micromm/munmap benchmark with this patch, on arm64 -
> the benchmark mmmaps a lot of memory, memsets it, and measures the time taken
> to munmap. Please see below if my understanding of this patch is correct.

Thanks for the report. Are you seeing regression in just the benchmark
or some real workload as well? Also how much regression are you seeing?
I have a kernel rebot regression report [1] for this patch as well which
says 2.6% regression and thus it was on the back-burner for now. I will
take look at this again soon.

[1] https://lore.kernel.org/all/202512101408.af3876df-lkp@intel.com/


