Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F740CD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 11:22:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74EFB6B008C; Fri, 12 Jun 2026 07:22:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 726A16B0092; Fri, 12 Jun 2026 07:22:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 664196B0093; Fri, 12 Jun 2026 07:22:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5876F6B008C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 07:22:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DFA1BC200B
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:22:51 +0000 (UTC)
X-FDA: 84871023342.20.3592FEB
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf08.hostedemail.com (Postfix) with ESMTP id DA5FA16000B
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:22:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="rK/4qiQ+";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781263370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S9H34KM0CzvAdGWJO94iGmMoL4Jxl0Cg8wXuvqWR/cE=;
	b=L1j9GaDXxFznSb/vOrQhtxT5+kOOleUXDgCQQ3VLIpTwLQqFQISuQcyvanaA/gIOG5jT0q
	1vpTSi6jqPd5/+XBiBitJLHYiZFwIMbG94kiOrid2R1qIGuDTh40l2Ph3PHGz5z0jdbR+E
	v6oUEAwBL5Hhgwq2qw1uJHVlQxDymyI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="rK/4qiQ+";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781263370;
	b=T4aFTVNzG5HM2IOhVoXDSPukmolk3WO/2ZlE8TYkw9aDzmXjZHBq9yUGI3DSj60e9tqAQG
	elbcK5uBD3xmZfVCPcixM6Nqrx9lYym3vPP/IKN+6JwJeTICtHBvVaK9p3U0GSpCULC50l
	/UtEB6UkfUoYlaTx/R3rzBE+HM5gw5E=
Message-ID: <086712c1-18bc-414a-9a7a-723b9498847a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781263366;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S9H34KM0CzvAdGWJO94iGmMoL4Jxl0Cg8wXuvqWR/cE=;
	b=rK/4qiQ+XLdBkl7Okeesu87wgP7Mgh4oBmRzUCGOvu9pPnd/ic3ah3cJ1CMoHgTrwmpFB0
	6y/jI8vDt5GSR3cvaWWyDuMzebjA53ulL17K67G2IctToNkmbf54/mk/DoFVTbWYGFzsd7
	+2xGjRK/NZ3gtwU2fM9n44tcvY8FWXg=
Date: Fri, 12 Jun 2026 19:22:38 +0800
MIME-Version: 1.0
Subject: Re: [PATCH RFC] mm/kmemleak: avoid soft lockup when scanning task
 stacks
Content-Language: en-US
To: Breno Leitao <leitao@debian.org>
Cc: catalin.marinas@arm.com, akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com, sj@kernel.org
References: <20260611-kmemleak-stack-resched-v1-1-d6248ade5f4a@debian.org>
 <20260612031605.58235-1-lance.yang@linux.dev> <aivJ5Dv0hAQ1sJu1@gmail.com>
 <6bc446b7-8e25-4add-9d72-a3c9e9191533@linux.dev> <aivhX7RtLVwBkNj6@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <aivhX7RtLVwBkNj6@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DA5FA16000B
X-Stat-Signature: xmhsn8tbotbc1ob7f5rdoxoiu8zdgc66
X-HE-Tag: 1781263369-256972
X-HE-Meta: U2FsdGVkX18ZeHn4ZGqClCM3ukwOBOMbWExWW6FT7v/m5FM9DU6QumWa2dc9rbH+YmrcDf36lVYXTVps3Kdl3Bq5750Vgyu3yRGAqnCgrhM02EOiiuppo8NNV0FwBpnslorakcsC5VGpof9Jd9de0ZpBYTQHpUUyqGwqHDWtSsJKQcyV3aGTtTrVvbMif0ezSsUiYMst/Xpwv3Wqs2x6ZaLWzh8+ERnT2UEguNKrdRVrlTA4W0p1MrvFIqZPCKNpiRAGkfJMTmjiUsSO6IpiJAdYXPJySyNyCP+BjX+q4Cy1EGtydcxQcaQmCp0m1d07mp6frsxc1P0M1sN6oanAF+LUq8BllenWp2BrJYvxdqU4U9yuL+QAQ1MdsTey90zqm0a6swrZfagtBPwUv6njffLnt/R3SneP2GuTOu4X6yBNQC8f/xriREz6EiMNbP1DATZ1b3FQypL9LBZyC9AhFcOXKQOvGlej++xoUi/vyyeRTcN7RyZBlV2NHR4z9cSF35oEerbZtkgk2vm7xe+vKEEkmKMDZ+GzTraJgiwPV/mS4ezOJAkiGk9zb59tNjOKGxltGwFMym/AmaNnoAlSuezKgoaBsWOGO86id/XBeTM5D3RqGNxG8QVtb/M0/Kh+H065VMya/0qTONf9OIeoDT+MMjPTLHqbSmQ3Z1oRdWrpsmTLA8KPfNUkSiZCkKnyOS5PKlnaMPtq3r2xM/JMK5aHw4C3OAo6ndg0WlWvYK3Z7o4Ns5/FTiCBi5IoZVRGUhlZmXiLH8s5vVqu4o9SInemwaVH42V1HaZuiy0sWnrmH4QoMuLkWL1xYjsXjuTh97oHXr+PN2QGigAFIyOQ9/Nx4a7C0MfWkecy3Uvd457kxJl9bFznVOplxIUY0RAREXiFqlIE9s/PJr3HPWJyxO5QHiTpLnjEetiaj5ik917zWof2hWDRH+9bI3RTD3LtPWQZ8+JLkuGHI9T3ggM
 dkFArYGK
 hE/k8zYlcPdmeNnossMxue0xO/rUsePdl/VnmflEEyfAkscY8iucHnJibxXfRAB8rI1ubJP/ZjbLXh5ceRzuATZXRAEQRySYVf9D3DpKLAIT2knWXjofEYniF5ok4ud/iWCxIXKVEyylvbACTBjZYv7Iyoxi30WE5c9O6m1KIGNtc9f725TaZ7p63MTloZQB1nyy7WIj0mrHWfsFxKEcZYTKHRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/12 18:39, Breno Leitao wrote:
> On Fri, Jun 12, 2026 at 05:57:12PM +0800, Lance Yang wrote:
> 
>>> If we go this route, the aborted round has to suppress reporting, reusing
>>> kmemleak's existing "scan was interrupted -> don't report" path:
>>>
>>>         if (need_resched() && !kmemleak_stack_scan_break(g, p)) {
>>>                 aborted = true;
>>>                 goto unlock;
>>>         }
>>
>> I'd expect the normal case to just drop RCU, cond_resched(), take RCU
>> again, see both cursors still alive, and keep walking :)
>>
>>>         ...
>>>         if (scan_should_stop() || aborted)
>>>                 return;
>>
>> And yeah, you're right. If we do lost a cursor, bailing out and
>> skipping reporting fot that incomplete root scan should be the
>> right thing, I guess :D
> 
> Thanks! Under what circumstances would the cursor actually be lost?

It should be race, but possible, that we happen to stop on g/p,
drop RCU, and one of them is gone by the time we come back.

