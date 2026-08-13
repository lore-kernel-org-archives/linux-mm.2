Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1009C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 09:26:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04A946B0257; Thu, 13 Aug 2026 05:26:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3D4E6B0258; Thu, 13 Aug 2026 05:26:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2C2A6B0259; Thu, 13 Aug 2026 05:26:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B91306B0257
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:26:21 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2A444120590
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:26:21 +0000 (UTC)
X-FDA: 85095715362.23.D032261
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8AEB21C0003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:26:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=osZkmIX6;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786613179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eWT1IKWTRNYzP3BjXhUqv26NBwMphfIRgnPCKqxWM9Y=;
	b=x8e12BRnqPxo4D6fQ2Io+rQvqvXsiTrLPmOhhgH1ef5/i3aTN0J/VIvkLrNw+4wdZ0LY27
	Gyo/wdNjxCQGGjDQJWw1FR1/uaZE78Qf1gNcriBfi52uE993aZu0+HXgQzNfstyk0rHzML
	wpOYN9QSkQL0lXBKULPFVrAGTjCasB0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=osZkmIX6;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786613179;
	b=M7UEZr3JKDmyqyjWjSakfojNUueLCtT5UVrpL6vDxkx/u2iSD+2L3pHhWlIdeGqldOjktv
	Zy31RyCDnHgOooqZmtz67m6+caasiE3ih4UwTRX0lwmKw4L+Ql9QoxjH62QFLMPgaLwmsa
	jraIWq0L8fA/vuCMxzlyga8W1jsR6cU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1500B40883;
	Thu, 13 Aug 2026 09:26:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45EB81F000E9;
	Thu, 13 Aug 2026 09:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786613178;
	bh=eWT1IKWTRNYzP3BjXhUqv26NBwMphfIRgnPCKqxWM9Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=osZkmIX6YUKuwxY38slNqvBsWiQNDNxPYCj5qqGQ4/Y0pIrfMjifzx2/z1f3HyXhl
	 ng0Q3tf+dsU4N5U2fYavdTK07+pIPx1hx2EwST2/ucqvwUPiztEz2uJuR6llK7L0dA
	 dKWV1SJ6myQMp1gilTQ8o4ZIB0AF/eI82D+iSpKAy1A8YUC7O9hy4Ubznuma96NwcU
	 BMqSl95kS3NaXdM2gzDn9mlJki3nb8lHZq/BETAikNcwt8J51xpTCMzB8cumyxw7e8
	 w0jUptWrHwj0fzNIdaFWUT8g4HLu+IRYhyLmYnXwjzfIfEJMi/fipBiMli07B/ltRb
	 OPf9hXUNswKjA==
Date: Thu, 13 Aug 2026 10:25:55 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Xie Yuanbin <xieyuanbin1@huawei.com>, akpm@linux-foundation.org, 
	david@kernel.org, linmiaohe@huawei.com, ziy@nvidia.com, matthew.brost@intel.com, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, nao.horiguchi@gmail.com, liam@infradead.org, vbabka@kernel.org, 
	surenb@google.com, mhocko@suse.com, gourry@gourry.net, tony.luck@intel.com, 
	bp@alien8.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	liaohua4@huawei.com, lilinjie8@huawei.com
Subject: Re: [PATCH] mm/Kconfig: allow user to select MIGRATION if
 MEMORY_FAILURE is enabled
Message-ID: <an2NjwBTWoX7l_tH@lucifer>
References: <20260812091644.224299-1-xieyuanbin1@huawei.com>
 <anxOypktGGq_9PZw@kernel.org>
 <anxQuhNh8rTUYqpN@lucifer>
 <anx13IlH6PMxhaSL@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anx13IlH6PMxhaSL@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8AEB21C0003
X-Stat-Signature: pcxiu57acsay35f338akbjbe6ooprsun
X-Rspam-User: 
X-HE-Tag: 1786613179-887734
X-HE-Meta: U2FsdGVkX18fRpS60xaXvPsO2rUzroGe33EXFHJY2ix87vSQHBqK0Hj8poiVLj0j6HZA5hHi7Ixg02dB419vQxHr6gCEM8UmOdOR6mbKTD/dFVYn+kpwv6H6uBIaK+EeS9osh7jZpJetTmIe0GgNLRdNDYLpfupRE1cCvMN/saQSpajnS0OwMycUiUEluKyiXhmgZx7XtvJZmk7bENd3V1Z2+95bwD/RU2ULxY3w6TZkoijK+2c7LmsSwh0WDI4A+h86GGIUvm5TYHfSjgVghwuiqTXYWbA7e5oqpIEITaBmxGmkDEHIHdDGr7aVEmt2OD5+ZUOeAZrvSo58CUQjHEH/ehVOyx+Ur5+xrgZnfGbpHAROl7nKdFFaR2XvJ3QcRD+FqtrooW9QAa8gse9RzindVZv3SjU26OxOJaaVw4MmB6xxFF0Y3q3f4fNwNaqwVQXd0BRu3HhugTvBt0NfkaEdVJ/D5gJA7ZVc+BWf0hMFhR/phl5QY5VrKm+XvbowRtWWMo4eGYuMZDoF9WlN5oIv+J3wGNujtqEM5W9nhlQeLbyweJ3u4kNp2xGgHCJAuj/w+rN9XDYBBdVzDPE4eJAXdvckaXkr6PlPtmvrseDfLZ83W4Xa/eCs7DFHfnkf/FKtzj/cLSbkzVraWbQc0XgHnWt5RLCw4lnaeEkzXHcR1VcEo6rgVHTSCPZKnzyLecLonq1SgBpt/QDTUYm5be9QZJGb87Nieq5YBaBvyQPe5Wy9Cdf2UfDS66bbUu20vZUjDRnThyJPyeyewLEXiQuy+if+r05HtVOh1131A3WzchAn+aKTHwIEst7FA1WRt5Y4UjEzYw2JBD0FUvUimhxHvNsPtsaPk2iEwHQXPAyLnOBZKmWXYadKxiPIs9o0zrBoZdVylisXpL2hPtnT6nBABLl9vXK8NyGTsK22M0AMz8FH71h18tl2FN5Fx7JxvaYXMKYj82at0MJrowZ
 PyThBmhK
 LDZIgDWgc2WVRYfM/JnqZgMpy0IeZeBYr/5Byo7jBkg3MoDvuwBfCeN0pgFk5W8quH+cJymDuRzN2oZwz24mbqSn8STJK/nx+zWL7cVQCXb/MNGjYH0KeivjP0r5jGN2IsybrxMz6ZOmw4ylzrmGo56ggCE9K5U5ILY517VPTmWl6oSVUc76BDRUXeFpEdpsKNNEjrnc8SNk62AbX/s51KL9Cb7+7gY3AuFYxhGofz7sR+Vg942gWGLfORn4RWLeYevGpTjVov0VCQKkQbS19j3JZ9caiOOPcvZbZxKY5XsvOgY+7kdi5UpK8PcI2GNDPqzfnXOrrnUJwrrFwaE5kzOHujLuI+qE0/PZ2dDg41Vc48H7oohB3r8IR6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 04:32:12PM +0300, Mike Rapoport wrote:
> On Wed, Aug 12, 2026 at 11:55:03AM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Wed, Aug 12, 2026 at 01:45:30PM +0300, Mike Rapoport wrote:
> > > Hi,
> > >
> > > On Wed, Aug 12, 2026 at 05:16:44PM +0800, Xie Yuanbin wrote:
> > > > Currently, memory-failure can be enabled without migration. However,
> > > > migration cannot be selected by user when memory-failure is enabled.
> > > >
> > > > Migration is very useful for soft_offline_page(), which may be triggered
> > > > by correctable memory errors. Most of the anonymous or file-mapping
> > > > faulty pages can be migrated to other healthy pages.
> > > >
> > > > Allow user to select MIGRATION if MEMORY_FAILURE is enabled.
> > > > Also, select MIGRATION by default if MEMORY_FAILURE is enabled.
> > >
> > > Do we want to make users decide if they need MIGRATION when MEMORY_FAILURE
> > > is enabled?
> > >
> > > Just make MEMORY_FAILURE select MIGRATION.
> >
> > NO.
> >
> > Explain first why the hell one of the other options that selection migration
> > can't be enabled.
>
> Think small systems ;-P

That need soft offline and migration?...

--
Cheers, Lorenzo

