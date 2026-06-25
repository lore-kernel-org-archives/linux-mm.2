Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5668CDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 07:49:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0E4D6B00EF; Thu, 25 Jun 2026 03:48:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E5CB6B00F4; Thu, 25 Jun 2026 03:48:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FE246B00F8; Thu, 25 Jun 2026 03:48:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 64A4A6B00EF
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:48:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D9C061405A7
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:48:58 +0000 (UTC)
X-FDA: 84917658756.28.B090015
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf05.hostedemail.com (Postfix) with ESMTP id 21A00100011
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:48:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="PAg/TyiG";
	spf=pass (imf05.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782373737;
	b=mDkZYb05K4YZKPDunyL1h6Hhczb56lJhzxVJrM/3I+RnS7X1Isydck4ZMNPJXmKqXgoC4u
	Ixrmm4Gy+WcLJf/Wo+wq0FzDhKXfoUC/t3Xzx6PwtO+ERGG+0tBBob4EtxdwKmYybZzuER
	/Q4dyzd+cgTN7REK1ifKmazIqdBa6Zg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782373737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zvBtedIXYdaGXlxkmcOhoL0Z1eiMbOLs7sUIu6DdX+k=;
	b=zPEXVLawzo8FcXbriEsH0pxEhOdUf169AFDjf9NO4toi9L4ml3KeKna4BPX7RuFtRwbIWx
	mLqq49zvF5UQ9lJtJFcayZPskkuZ8rDsNQByLb4vcIL9lLe1pne//cTtyLyc5Jf0AjZuM1
	M+j1Uq69LKw6G1YflW54CFcmbJeVTkk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="PAg/TyiG";
	spf=pass (imf05.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <6cf1ad76-74fb-4253-bba3-50da9c3f22cd@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782373731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zvBtedIXYdaGXlxkmcOhoL0Z1eiMbOLs7sUIu6DdX+k=;
	b=PAg/TyiGagM5p4NpBsuEn3guQYqWGe3rIKxEVKJm84zKXFn5SyWJbK9J8jwFRURYBVAypn
	lMF22LV1Qp8GDOVeNtzHgx3AnZYtbUWOvrGdfHMov9KTjOakoTcCpxhk+IKcxOR2k4VVmt
	feNXayQc1DOa+Yd4MyGaEh7zVzfhg7A=
Date: Thu, 25 Jun 2026 15:48:37 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v10 0/4] mm/page_owner: add per-fd filter infrastructure
 for print_mode and NUMA filtering
To: Andrew Morton <akpm@linux-foundation.org>, Zhen Ni <zhen.ni@easystack.cn>
Cc: vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260618035750.3724613-1-zhen.ni@easystack.cn>
 <20260624201526.d96ff165f09f361ad128cea0@linux-foundation.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <20260624201526.d96ff165f09f361ad128cea0@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 21A00100011
X-Stat-Signature: ph91posya836hwyzyoa5mfjuau6s1w9d
X-HE-Tag: 1782373734-482224
X-HE-Meta: U2FsdGVkX19Ew5yL8kjS/4LY5a1Ht96/J9a9a9Xd+So8gbilQC31bzxuJzyYAW4pfyTUOiGdgRm9EMmFceiZ6Kjvxx9zJALt4Yxht2ztATy8QWBhNJAIpK4ApGwMmo2dk/TL4k2v1SVlQrwzku8QTBfzdXKgI/ydgq+lRlT37tN7q7BtWCLHV25xaeNYVCRp798m/1qNhqv+T7nnY6qAKJmF5ZNCJM2zoCGrvs+8PrmkMw9K6LR9kFbo/qWiaZrIzr1dTYmHenGm/a+2yKwUgQ8dPlVw+y5Ncy+55Akf6P1ixdfEZ0W7Ezzd0tmWBJGJr3K37TfsJLBRktQ7JFG1Pod876ClCDGAfsb/wvfowzjq5ixxhQxGk1Nd6+yk0NkNbhBhN9MOokSeje6pG3mw1u/fNtKG/Z9LuG47qHRtfR/hKI69wKLT4W6w1xwJku9xyh2/tzvad5qwsmEcu99vXK+MFChuJLrU0g6Owws+uNmh/GBWiB7+a8vv0tvMom1zIUCUhg0gw8Q2OH903rPrtJH69lPgcgFeoowGK2BxtYL7Mj5yLccSA03rqHBsd49ViftRxEDDsklHQdZfmJ0S6o5uIZy/x2eyBHYGbyqk6KlpduMcnTScC1tCmZxGTIz2EIghnoes/ouNGs47FEEfiscykrvdC57wB9OsSJDlr//vEiGhynZ6xsNMzJs3dGQK+eRvOmclyuDJGrrTv4dGgiOQmZpJzrvI24zqClMHLdj0u3gnqkZk0t8VIvW4c2jbL8/DLUSFZgxQ34A98if5FmrxbbB0QYP4lKKIWmory4fqJcuZFlhDYo/CWhUeUJcBMkcMC93f8VeJO7/HAbepXFJkT1XJLRUcDpyfumZLkx7xNQ2DkW1REv83XBOjAYklWEZ2IEo1LdrroNivRoJHYzKwhtyAU22dS3P3Uj9ryzF4urGiLgp7EkbV+xZWxqVZUuZvNNFBU1RhxBv35b+
 8xgnYr/p
 0VM/HtShx3Oc03pjkogF/QZFVYaoFU/TdOKgU7jCE6IibS06rvpUk/WABB0EZYCxYRC2M6lLJIb+2y5fNa1I2fWSXK2hrHX0kHajpmZ0QbRFxEyCluOzgy5J7mmSCn3dSCeWsIAqTOfxTvZBkbCfnSERg9vTbtFVpdVQhWMcqD6X/ngyBuUbwc3w1JiSmk9OaEXLya5CzMGeGo32M0Rh31GxWlBT9GNfddVVysmcNS19FYldxAEVTn1XLhGyHb+QK7aT3NZdN77BFZUGHO0qiTq5Bei6gw/8kk/kGmi0TJPmcbR7EN1wP/S+NhcNy2HAlQobuA1AyG+RWgW4WBQnbi0RE6jAQoWB5lfkUetKqDU3o8m8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/6/25 11:15, Andrew Morton 写道:
> On Thu, 18 Jun 2026 11:57:46 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:
> 
>> This patch series introduces per-file-descriptor filtering capabilities to the
>> page_owner feature.
> 
> Thanks.  Ye Liu has been working on page_owner recently
> (https://lore.kernel.org/20260623065234.31866-2-ye.liu@linux.dev
> https://lore.kernel.org/20260625014708.87386-1-ye.liu@linux.dev), so
> perhaps he can help review these changes?
> 

Hi Andrew, Zhen
 
Thanks for the heads-up. I'll take a look at Zhen Ni's series and see if
I can provide some review comments. I'm also aware of the Sashiko report
– I'll check those points and discuss with Zhen if needed.
 
I'll try to get back with feedback within a few days.

By the way, at first glance this series seems similar in functionality to
commit 156c0c5d1463 ("mm/page_owner: introduce struct stack_print_ctx").

> Sashiko found a few things to ask about:
> 	https://sashiko.dev/#/patchset/20260618035750.3724613-1-zhen.ni@easystack.cn
> 

-- 
Thanks,
Ye Liu


