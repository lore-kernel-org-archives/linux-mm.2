Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83709EC1120
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 19:42:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCCC56B0005; Mon, 23 Feb 2026 14:42:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C509C6B008C; Mon, 23 Feb 2026 14:42:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5C4A6B0092; Mon, 23 Feb 2026 14:42:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A0E0A6B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:42:56 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4928E1C208
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 19:42:56 +0000 (UTC)
X-FDA: 84476744352.08.3FCB52C
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf29.hostedemail.com (Postfix) with ESMTP id 43A48120012
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 19:42:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Le2r81F4;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771875774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gIQcQDyS3X7z6KDsG0mP+b5KcPKyO7L8eLyBRsu2r4g=;
	b=m6ScuuLGL9l5eQuEXf9vk6aC9Gf39U2pvk7KJ6xRA2Tt3Se4UFB0CyVyuo3FiepN0AMQSN
	gglNdbjXYjFMPiVt43W4xUv6qfPLiiRSFJl18UU7PWPnb1b1BN3In3CNGmAO+PbC6qw0CI
	GwdTAZnmAQVm8/S3ovzyrokEmTOy3UI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Le2r81F4;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771875774; a=rsa-sha256;
	cv=none;
	b=6nuFZzaL5CWXzBw3qTXlnM9j/3NSk3pj5tumQND4zcNyu9UiF5u9byZYs1F2CM0DJuvIK1
	0TZheeFl4c6U/SES4tib57bARcqZ07YqlfzMiuWwVs/LiRfzJEg7M5EoM3MzfiJfQBIIcc
	ZgWPt21lt4l46DPmI+28ABIq/j1Rkoc=
Date: Mon, 23 Feb 2026 11:42:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771875771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gIQcQDyS3X7z6KDsG0mP+b5KcPKyO7L8eLyBRsu2r4g=;
	b=Le2r81F4jqCDxDLaiX4FjKljCWmKeW2G0hkga84GeWRE6RC3Q9qhm6lISEmmHcEH5pVyOV
	fwAzAP8ofyAOMoqAiK5h+Nx0cdE7fFJWsSnoTJGivZDWCKozuZem3JPsM1zw2utclFJ5aE
	rw/wJ9ewmSyd8dioXnIbBKei5QWpOoo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Thomas Ballasi <tballasi@linux.microsoft.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, david@kernel.org, 
	hannes@cmpxchg.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	lorenzo.stoakes@oracle.com, mhiramat@kernel.org, mhocko@kernel.org, rostedt@goodmis.org, 
	weixugc@google.com, yuanchu@google.com, zhengqi.arch@bytedance.com
Subject: Re: [PATCH v7 3/3] mm: vmscan: add PIDs to vmscan tracepoints
Message-ID: <aZys_tvQinYNNpOk@linux.dev>
References: <20260213181537.54350-1-tballasi@linux.microsoft.com>
 <20260223171544.4750-1-tballasi@linux.microsoft.com>
 <20260223171544.4750-4-tballasi@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260223171544.4750-4-tballasi@linux.microsoft.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 3x4iwp1n58tmbt34iks9xmnwybs6u9bn
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 43A48120012
X-HE-Tag: 1771875774-483688
X-HE-Meta: U2FsdGVkX1+HNRVKi9ZMJd1nhhX3fny7vkCTOxhlFG4bBy2Ydz3qhcfANXYaH/SUSDVjVp7iaZufu+2rdOKwicX6d7oBbbzIxjlCPHyuBoNigPDicw2MlUjBYOptZUO1/uDnmQyr83m1FBvSV8/fF5tplmwfz/oUjOdLAgFMc4ui7wmVMyZWCLYjOm4rDa3zXnU926aSM/RNjvsJ4OKZgKqcPb4FAyTh9YVp0/8o91+JXsMsgaQ2/nh9WFOQWBMy81O1o/fRfZLsPCIotdQ7gRfXQtNN+ABNI+GpbxP6siq75ERBqysa3/hI7knTTPLhETtvs+zHmCsdV6LLOFtXRdKHAl1UPg7g8B/V68mBqTKEkUp7aY3Yv3ncfHcU32QanLVOY07+MUsodI3bfpl3X8RozHFp+21prUwu7IHM20jW4Qhf8OqBGm4y/YilopVEtSicsvsip4WF1/c+pLO73oIiBRqH0gybOECjZxE0TmD4C71k1FRp9HS7QlacZgXERMi4Up9Zu3dLuPlbSNCu15FA+BQN++DEb5969/kq9YrgyEkgvGB28pTBNWGIRvvveYVOcdB2KkUrrQ6ABLONSf5SPtHtW5dHn25DHPmCWssnFKPWDd7D207sV7Agt1tlx9QFmUmRE4UCCQvAH5k8U0ngdBAVBEwTEJ8kGHwQrga/35mrKMIGMPFXSu1wT40v84dMCMxMrZaiOKwKrdmcA1n+85oHQ5MnFGDCCaqXsshzhktuI5P3kgGSxUldSDZ4EKl7JmY8cih/s6XK/Y1+guy9n8gkllpwfbbzLkPJQWwknRtSsgnn3taAMAnLue6iGx7vNFZkVwst124hLu37DmuCrQe/RLfNpUWD2WIwyZO2tot2lLs9PkZN9Pl+xnbn+XLe7P1ZOr6sX4SbMUQXcPjOfec0k1FwP2ar0uIDnBH9ziqyyvlv/KmTWo2Ur8f8+wFgWVw2E4+h+uEPxpD
 jiR7N39j
 oKGeKuPPfzYbhXSvnxk9p6KxeFBQeOzUvNO5V4vodU3ietvPRd3jxTUi1Vhx9yWvyqm8elQcB1jqqS+IAawdGK04Q6YZY9X70wCKOUapincoFPY1lPoS+E/FTJ3rPr0AX2HrgH5REKN82ldXFr/q7OqVGjXX53sBg2CIIFzK7tijkL25xGX2/hsnO8dMrjnru8k+iTgqwgQ7HKHyYvOrb3mEO7w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 09:15:44AM -0800, Thomas Ballasi wrote:
> The changes aims at adding additionnal tracepoints variables to help
> debuggers attribute them to specific processes.
> 
> The PID field uses in_task() to reliably detect when we're in process

Where is this in_task() check happening? Also this patch is changing
tracepoints for memory reclaim which never happens in any context other than
process context, so we don't need __event_in_irq() checks for these tracepoints.


