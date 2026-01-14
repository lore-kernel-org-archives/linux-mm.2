Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A3FCD31A16
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 07:21:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8441D6B0098; Wed, 14 Jan 2026 02:21:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EE626B0099; Wed, 14 Jan 2026 02:21:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 704626B009B; Wed, 14 Jan 2026 02:21:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5D5A76B0098
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:21:54 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DDA161403CD
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:21:53 +0000 (UTC)
X-FDA: 84329724906.08.7408C6E
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3726FC0003
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:21:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qZ+rBRv0;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768375312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K0Y4zcNSVFbhgGtcesaqg9kuOlXT3wYJjn3Sc9JbeAs=;
	b=UJN+Bd/hTrGUTa33MuLx48uF+z6GO5oiHgURPRi8wNlkVMmCI/WnXUiP58VFM+6Yz5yoyz
	v5CbOaIeqv431Gl7L3moqT1l3voM4MYh3Z1YE4qX7VfLCyesDSvuXduw8JtAo4MwyN5axl
	9WUi44SNpWLyu63Q0R3y7ef0s0CWH6k=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qZ+rBRv0;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768375312; a=rsa-sha256;
	cv=none;
	b=q4WpYcD6ebOuDxD7xhAefv3/lJTOXpO/We2biN5+klBceHuWkZA7g6sNp+0jVVDneh/z8q
	QADi+BVoYN3Lr54YgNVoY19phJpcK2ZzeXW5l4qgr/1076V5cNdcs0IRcj6X92BNdhdf9S
	pxMKcC6Lm0qU6zJSOTMACJX9olf+BCs=
Message-ID: <70686841-393b-47e6-b859-c2c07c273569@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768375310;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K0Y4zcNSVFbhgGtcesaqg9kuOlXT3wYJjn3Sc9JbeAs=;
	b=qZ+rBRv0vleQrxZd3mmQRXYExt58TgFeLWRUXsrpCfXmOURY+Q/lH+bKMnWiQPkNVpPtEx
	xWEJ8/R8calcY+rGpgCcrQ3nOkzCxcjqWslqQtG8Tp70Citz+0C0fX4q7ckS/5EolICodk
	KZ56oV0f3a6N09FjxCi35d6h71pASzM=
Date: Wed, 14 Jan 2026 15:21:42 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 00/28] Eliminate Dying Memory Cgroup
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>, hannes@cmpxchg.org, hughd@google.com,
 roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <aWUDXtsdnk0gFueK@tiehlicka> <7c47ff99-4626-46ec-b2f1-f236cdc4ced1@linux.dev>
 <oo7re4nov5jar6nzu7awvbwlclh6esp3mltiflylzltjt57dca@jbt3hs7kgb7i>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <oo7re4nov5jar6nzu7awvbwlclh6esp3mltiflylzltjt57dca@jbt3hs7kgb7i>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 4aekp8rhog43zzjt3kda3ernm4oh7n7x
X-Rspamd-Queue-Id: 3726FC0003
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768375311-781181
X-HE-Meta: U2FsdGVkX1+MfSmtu3qDwHBZSVeI4M9vYW7yBFSZVzoKDP6RZ+Lhz8iUv/KLWpncolGKIAot+iiAqFhKLfpacUHRsSDs86wMO9W0P2jGYJZpk9omoOvAZgKvDLFkoq5eFfXSKdF8JM5EE/y6UHzvws2IjxFopzJ8/PaHFBnn9dFrdmhyzaxg6wcoxyB82U5ELGcfMCxTeXbD5GetBucGEy52Bei6SZGysafZl9YtL7XUI4lpP5S77SZ6hqic6nBORyqPl2jU0/PI5vUEZ7loh8dYuPs3KV0CDqRRDRic4Vr0S+A6zg8Jajr7wW8Gl2SjtpPqyAWF1Q+38rU9mg0ZzeLsFnc/L8KiBUAlgivw4Jjx1wMn5Zw2+6YN4f4sID3gdWA3Ni5H1DrHmGsRo3LCX9pZMxAaYJYvK7kLCxfWTwvWhWANiFXdnMEfMCSVW1bu922jGG6sC51f+39oP1uBD0ZwJRAUUntS/1y2D7+cQw4DKo0hNDrKcolN1Qafa0uuLVok1LL2qGJiu/1Gi37GHcukf0wJvgSBUHQbuI0ovyIrQgrz4ReTUC0EaMe3sp2IbVK61I78C/NuPnk3uLRmUDekoMLyxO3/iq95bZFBTVxDDc1mPp7QFgmrN+j59tJQPrBb1B1dGjpK8bX3AzHSUt1Y79il1DBwHHEDwaBeyFSjFgKitbzU3obP9Sh6X4xF/laQW8MPKH1YOJRUJKE2R8M5UWolFR93YM6nJVStP7er1ymxl9ANF9/HuUvLayE7lsK10pzJnHTBBNp0cOIc6E1YHC7nGdiogk+sqSnxj1JtuM1lJTP6wICAQRtyADaTEm3juhEoRfO5rDwsCsVids8agoJDYbN2hegf5IDw2yOEs6UUEpqv7ntR/MGn3NYEXEPLoBPNMga6URVlfGL58m++9u58Ox/XElgF2kc15eDqAdeveYW5DsYtGaXCoKVFqGBX0G2fgU8VpjmnLiB
 I2RNQfE1
 MU/EdAYlyogcuMTh7aeso9roS/BQhR2k05yuOohmsgZxWPgYxRW/rMSlhQQ2/GwL4J30bozlONV4LJyfOP7nL7/Tbik3lK0Cbt0vblVoonku29ttLRK9/4gVqnv0tecbI1RZOJk54gTavMwhOwH4PFEJCUFKn0dufkB3zAKIEj/XucOpe6Aqd1L6ni+SBFfDxzTCOoO6e4fORhuJXXD4zK9Cq1A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/14/26 2:02 AM, Shakeel Butt wrote:
> Hi Qi,
> 
> On Tue, Jan 13, 2026 at 10:34:08AM +0800, Qi Zheng wrote:
>> Hi Michal,
>>
>> On 1/12/26 10:21 PM, Michal Hocko wrote:
>>> I can see that Johannes, Shakeel and others have done a review and also
>>> suggested some minor improvements/modifications. Are you planning to
>>
>> Yes. I'm working on them (mainly non-hierarchical stats issue reported
>> by Yosry Ahmed).
>>
>>> consolidate those and repost anytime soon?
>>
>> I'm testing it locally and will try to release v3 this week.
> 
> Please take a look at the AI review posted by Roman. IMO it does have very
> interesting comments, so at least go through them and check if those

To be honest, until an official AI bot is developed, I don't want to see
any raw AI comment results unless the sender has already reviewd them.

> makes sense. Please point out if something doesn't make sense which we
> help us to further improve the AI review process.

That makes sense, the v3 fixed some issues, so let Roman scan it again
with the AI bot based on v3.

Thanks,
Qi

> 
> thanks,
> Shakeel


