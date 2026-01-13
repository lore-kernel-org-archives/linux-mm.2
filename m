Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1F7FCF45D4
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 02:34:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3A996B0005; Mon, 12 Jan 2026 21:34:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE8E36B0088; Mon, 12 Jan 2026 21:34:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC06E6B008A; Mon, 12 Jan 2026 21:34:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C73E36B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 21:34:25 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8039C1AF3EA
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 02:34:25 +0000 (UTC)
X-FDA: 84325371690.05.7DBC26C
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf15.hostedemail.com (Postfix) with ESMTP id 20E05A0009
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 02:34:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZPBxRXty;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768271663; a=rsa-sha256;
	cv=none;
	b=oQz33NAV3ECl1IekEm1LVrTjbj2BnW10F8/ktccgDbfiAeBdFvIx0mZK/qBMo5E+TPJcRi
	M1mv1Tp0QGnfqObzEJYpt7reDAuDvLNZqkhsvNZ/sapO+NzXF/sIehJcRQZlPKpE03VR9R
	I6Ub+rygpIloTSO47WseaI+m/7C3dx4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZPBxRXty;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768271663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BmDNvAhPPmik490ESD8CzA1I44hk4voNy+X8J7EwDSo=;
	b=6sc/Y1lzrCsGgVvMUF2N2WibznwAVJc+0Bt86GC+UMDfBhkW/lKyC/XQ6hqfaTZqq0JpiS
	JyXzRdWU5B39y1kl1PCLD4UtLMFR2y5FFv1r2zli4FmzE3kcebDPtfjWKLXq930rFBeNTs
	++C47UPlXG2S0Kx6UGg1tXgl7/+btwI=
Message-ID: <7c47ff99-4626-46ec-b2f1-f236cdc4ced1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768271658;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BmDNvAhPPmik490ESD8CzA1I44hk4voNy+X8J7EwDSo=;
	b=ZPBxRXtyvVg2YawHBu1UG2LM5GYlhA3Xo5UMZW3n9gtBBiBxgk0mGy7IFTl1xwiZTrSMD2
	rzpf9kUUqFcVDU8u0xmXyQAW8JVBZS1yWNr8JSsCBEqTdo0wM5aZDOlKetLTLpWK5G7r/v
	IWQKBT1o1IHQnlxlXdmp5OyqoP33M6U=
Date: Tue, 13 Jan 2026 10:34:08 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 00/28] Eliminate Dying Memory Cgroup
To: Michal Hocko <mhocko@suse.com>
Cc: hannes@cmpxchg.org, hughd@google.com, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <aWUDXtsdnk0gFueK@tiehlicka>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aWUDXtsdnk0gFueK@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: 13j7jutd56ynjp3huxs4igxm4grfga47
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 20E05A0009
X-HE-Tag: 1768271661-114071
X-HE-Meta: U2FsdGVkX1+ZWJh4FrnbQw9YpYg0vOIeOoPm9uO1X2FMSOKfD9X+2VVQ+0xvL6dFihBnrXwCIUlDagofA/0hpwVLOm8O21FdgpjQlPnP/V07huxjpwCafW+JEyctZSwJwFeVMeUHtyOnmvWyIADov5LojBjTp1PZhlGqrS3vu9blKERVrXSoXnnO4CiGMDk9kjv5Bpx+uS1UD5O7mkHRgmt0ZQnK7cQYisgBlidyD3lvzrIvkG1w3Q/BZbGavEN1JHnfjduvgG5OZBK2FU+pttN28mmzf1B4naJ6Gd/HUIy9BbRYExazx0Y60qeS+z6zHZg1uE+h6D7rmsT4eM5m/54CMTu1ny3pzp489pCWPEaF5zwQJOpvxp6Y5fS7/jON1IM4P3jEsRr9RAroyxhdC0PP5mGHDUZWbaJ78tuGApt/BnzVV1qVU9YE+7/w6XVr9+25ocL1KFstoH8si3X8hJxXMk95q/xExg6ocJNmKxxbx1UQ/7En/zoSlRVqJfpE4wWoYr3ihhsYa7pYcgN8FMAM9/bYtA00bsxVD4OVMAtg1nQMgiXBuuSqfJCFpuoQVByCIs2Wj5Nenj5+z18Len4fIZqrt7t52EYgQ1Kh63VokmS3PueKw+7IRZ8hxK9rtHlv85W62iemIZO+fPL95KVgs+znnCAdbfmxShFJ771TJoHiwVORC0n1Grr9BWgdQyxOnrTqS8PVlBwj155ee3Ye5qtq38+N7NqCw/VQIaj1v+99dKkURWf16TomTmzkoal38FUQk/NLt3Hr4Zgw5Op9eabwgG8VLEfJiI/XCC5QgHmMc6SjIWJRmU8GDtZAbhUKKZ2j0USkejUtGhCy5uBHYGt+nhQncYBh7kg6NzyMclFfQi8rn3lXTAKkTHXQPvUL2v+nb3EDFTtyL8MBFVUDEPRSTIh3dmTob3Gjj2h+rmkLka1JBm22ogDWQQkxzNbvFBNG+kODjBHRl3f
 nc0EqGEm
 OqQvvIpETcfmGLMHpjA+Ng2O0myehUGcggIcaEh4Tc+fcf5MyD1SDumZ7lpmNuWCLEtMv9i7DkAv060e32Uk3P9ZSFgsDooqBj2zS/szaNJGoqJow7fmy74GXPtadCaD0gcHtTy5ePS1cQrqQ/jojA9afatNF5ZTTMmvK7MlJWttCU8jKu3xS7ehtqOZA0XNgQXIM5uk+/aOCQqX49UK9YbK2VA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Michal,

On 1/12/26 10:21 PM, Michal Hocko wrote:
> I can see that Johannes, Shakeel and others have done a review and also
> suggested some minor improvements/modifications. Are you planning to

Yes. I'm working on them (mainly non-hierarchical stats issue reported
by Yosry Ahmed).

> consolidate those and repost anytime soon?

I'm testing it locally and will try to release v3 this week.

Thanks,
Qi

> 
> Thanks


