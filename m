Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9873CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 23:55:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 414686B0011; Thu,  4 Sep 2025 19:55:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EABD6B0012; Thu,  4 Sep 2025 19:55:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 327BC6B0022; Thu,  4 Sep 2025 19:55:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 21E3F6B0011
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 19:55:48 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ACDCE16045A
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 23:55:47 +0000 (UTC)
X-FDA: 83853227934.21.77A46DE
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf11.hostedemail.com (Postfix) with ESMTP id E442F40007
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 23:55:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YjLypLiX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757030146; a=rsa-sha256;
	cv=none;
	b=sQP+3g5BE5N0vinDBMHCX33ecdAcoN9R5krSBOhschGzfzmhewbnBB9VLYX9pxMaYeYJhX
	/ED14N23+AK0yfGm+9WT04dj+3Xthju6uZBgZgo1RRbhbsy3fhZffcLGrxPPl52GNWX8Vm
	Rmg/GiPSXTa1uKQVpu+cL+gJBE8bPoA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YjLypLiX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757030146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Pr14zv5u5Jg6s/TCR/mvY66VjHG8LpXuYMxg29uTMM=;
	b=mu4/7brKDM7H1DJitZv/lI63e7BIECON6gz5jpK8YTCZ8YE68MPiIM2ogvF3ktxqPZ4KaP
	CJZdDwZ9Kmz+0odWylEKGd7Cdu8S/bNOEvKCnipB32iod4Z/nxeT2fsfER1mdUan9uloK7
	ffWQe5a1M5vtX11CwiJihs/I+fjjUhU=
Date: Thu, 4 Sep 2025 16:55:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757030144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4Pr14zv5u5Jg6s/TCR/mvY66VjHG8LpXuYMxg29uTMM=;
	b=YjLypLiXD6Ir2BWcVk0EcnqrPhfP+qYVCFd0BIO7aArwCRf3O5lYAuHvbK8RelTuh5bvTa
	3+YOoTZrVaKX8jWRIoUdj6YyYeEpTDCGFfI+mMnYRzHO9vrOkIQGf4HwxfQBz4eetrs0Zf
	dDEgi9Tb2Pi8clsCkKVVeCc5kDD58eA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: zhangjiao2 <zhangjiao2@cmss.chinamobile.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] samples/cgroup: rm unused MEMCG_EVENTS macro
Message-ID: <izkhad3p62zbja2olzuqhsgbusbq5bfam5w7wsonand6ti3foo@gcc5xqhnfaac>
References: <20250903073100.2477-1-zhangjiao2@cmss.chinamobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250903073100.2477-1-zhangjiao2@cmss.chinamobile.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: E442F40007
X-Stat-Signature: faefxagcym3tsybncob9h9repsxuniuf
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1757030145-76905
X-HE-Meta: U2FsdGVkX18s3HSXHwbY7NHKxXn1xqoDu/KPUQsS+6rSWFj4/PDVB0aDbn2SaBtPz5CYTMA7TrY6g//2a9bLjCLFwhMDZ/vkt/gLtp7durwQSEW1cbPOOxPzsDqrzB/LYFRT31dYySoG5JTPperwCa3nkvEPhpu6MA/xsRpuWTehRZ0i97ksvR2OVATsTDMxYVpB19kh/Fs4qRmF17UD7gNfnf/3WvZsGjI/f0OZJw5fe0/YS4NNZFoGPj9KtAZQhg9Cdz12QkZ0zmQIOMkoCog6k56I/VbSvk+etjunXYdrrp2KTSoQQHlLzPXyD/npQgC83O9/3j38i8NDPXf940ngzOQXxNKTcm1CBZElShld3NA51ShFSNJsFWN575Dg+7zHL/6QpOUee/e9Tj43Rdgbi2+ywv0sbCjTQJRgeZoGLVU/Qmc3Ev4Uj0EytbqptQC8OhM3mM7JB+ubICNZythBpGhavRavGwlnoXUWhrkL5hpdHuC+GX/T5SfTbcMsX4lr6e0+r4nuX+2vwFIIq5ZsiX22FGkTELN7cBOx8Bs4+PcNOJUUW4Iw2Swsuxh4T7/GFbOgO27fzIsWsRdWBovkZJNLJ14YXxhHJASntqpjlvLx/1iz2N1qoc8PxQWsqOFpoaoeZT2P2jio2mkZUwGUbYraK8yPHjFk+ef9+etqYpXcEL2E1Bk5k4QdbI2it3ffotDWMZAcFPgHmjaoEtvththhmrNtsxHgfWqyr6hcz6nfXiQ2hcRfviyV4vR5kz2iEjKn/yaN+ZXkpbgFwiPHkMC22vZXaGOKer7Lmo2ZWmNiw6C3WmP2r9QUm/HB3yyy5qh1rh4SMHf/hwJbZjv4ooM+bNus7CXI2vhwS6ywY9rb2dR27vTj3itJm0CUyzDsqC/jWQK1fV953zIqx7p+UyWwY6BslzIO7yVFyuEIkVGWBfy3jcRNXysOfsND/faqWsGUVsuzuOHKR9M
 bn48DWWV
 Jga+vQYXqeRl6qKHXRsBWpGqOuAgme+sjuaAebDiW5Ult9gCuI7I1/3P7ENVHvyBQhNeqTY5uVVjjRDG3xZCGFn2bmuvdPVsmXNxFQyIg6q3xhuAY9mw4Iq9vTo7JhnkD8MTYd3lAk3uIRjrCtpMG2+7puY//f/0dCdkI81RJSKCFHLpNAIG12CgLxReIxCAYzbkRt3d5gGRWIFaKXc+2TZixf2IosJ36IShljigNjpxirXGhyPKNRuobcgO7Qi4DvGett5RpqhYJ6+qqaL0b4cwn1iqOA2CnaGkwIntmcHjR7eEb64m9O/ykVpDKn/x4we3BmyjbAeBtc66WzXBZa6Lj0g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 03:30:59PM +0800, zhangjiao2 wrote:
> From: zhang jiao <zhangjiao2@cmss.chinamobile.com>
> 
> MEMCG_EVENTS is never referenced in the code. Just remove it.
> 
> Signed-off-by: zhang jiao <zhangjiao2@cmss.chinamobile.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

