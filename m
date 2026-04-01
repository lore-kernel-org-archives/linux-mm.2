Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F1FFD35178
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 11:41:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E163A6B0088; Wed,  1 Apr 2026 07:41:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEE7A6B0089; Wed,  1 Apr 2026 07:41:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2BCA6B008A; Wed,  1 Apr 2026 07:41:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C0CD96B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:41:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6F04D8C39D
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:41:22 +0000 (UTC)
X-FDA: 84609796404.17.A751561
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9C8CDA0011
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:41:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z5igplaL;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775043680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b13KGvyLogtVdL0iQImh9QPPdc4i4Vx371Gruxsxw98=;
	b=L5YzNwgSy+QgG3A6i1Nd23Kl1YBhymkgw5zktOY67D4Rx9vrJmlOuBUc+vO++09Dg/3KuX
	e6JbUOjOoBsmhgRI5q35SuPs4rq13I1h+9UQIKyBr6xc32SND++DbAw6Ao30QMMF4I2y/6
	AGtBZ9Mxg6u/vrrI79YBPlFuZOZ1Obk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775043680; a=rsa-sha256;
	cv=none;
	b=Jn2xird5ek/Ed846T65FKdcq0elhIVxX2c52bVaDIIDdWN1lKjfxmgVYCnHgvIHkiSxU+o
	AAvYZbFCG9ZY4iRa7qYLBoaiM90gncd1u8K7cJlUHW21WLIjsx67uOOdogYbzYQKi6nNDl
	BZ2LwCpKvoXtIMPCosIRVFMGPoOVGxY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z5igplaL;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <7176f8a2-8830-4fe9-b00e-fae67e2ac81d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775043678;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b13KGvyLogtVdL0iQImh9QPPdc4i4Vx371Gruxsxw98=;
	b=Z5igplaLxy29+thTrFyJCAfRPzl/HshpDrD3dnFTkZn6ogDxQZJiNOfhfblTCiY3+NctKA
	QE3k2hPAWTAjw6fzQcLS3PYLC2TLC0y8Xut0V0MixZIRyTgUus6yyUnSvKogvtYveleKNp
	YoI5uDwS+YFCHEG2lTtSzkWl6NnW1r4=
Date: Wed, 1 Apr 2026 19:41:04 +0800
MIME-Version: 1.0
Subject: Re: [syzbot] [mm?] WARNING in deferred_split_folio
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: kartikey406@gmail.com, usama.arif@linux.dev, Liam.Howlett@oracle.com,
 ziy@nvidia.com, syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com,
 akpm@linux-foundation.org, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 dev.jain@arm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ljs@kernel.org, npache@redhat.com, ryan.roberts@arm.com,
 syzkaller-bugs@googlegroups.com
References: <38a347dc-8a1c-4d04-926d-7a6318e93ca2@kernel.org>
 <20260401113434.29369-1-lance.yang@linux.dev>
 <cc8a2d06-c774-48d4-af8a-905126dbd588@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <cc8a2d06-c774-48d4-af8a-905126dbd588@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: dmoxwsg1ski5kepstn3cze77qjt717d1
X-Rspamd-Queue-Id: 9C8CDA0011
X-Rspam-User: 
X-HE-Tag: 1775043680-105441
X-HE-Meta: U2FsdGVkX1/3ymTO41INhkbu7GEkJgzyTQtan7WaNP6+eRHqDMrcJ1qxdHrSHHUYNf96Nh04jSZsqNFcwzh7lCtgshVrtmN+CD3vTXXm5EYAlvIjgDInLx3lJRf3ocgm9IjxnD34p/Z1eSYSv9UBC7U4Ge6VsNbE1HiQ/rb4DrknKDRERO1QfunftSF9iz0DSrlXBE/bdakEjCOfrz3itjU/kZ5pN/xZc4lJBod7dIxJExtpRG2Sn5F5moAc7qragVLi1Kyq/lXN7XjTO0hxgk0ou08BoctWPI6XArTcrbNumCaGRsWlB1cDoXH3+rLMXZYJ4Nj+8j9P04S9h+Fd2nFr363WCFRqDpevU82ywCrVQGL/Ns3SaboKpnynGh9swWahg3uMbUk3UArkIBr5RxiRX5fvCGWVilaemHJSlwUwl7SH3pXPw1RimaOwPmza9jNYiKhZN7pGi+NWrKvITsrlZs3wpmVQaW+BGDv5CeHwQuMV7kzn96FmIgtSe5LeEdssmO7uZAS/MeW95rnAFILu+kMDUp33bLlHxFev9LQPTXY5N+jlg2HJjKXGFfCriH5uoxk4tOAvPxdzOkCqZXxx1pJGM+LLyTSXC+jIVJmlmd+arD44ZPN4XJZxnnDxSvwkyh5XoCasX6njWMipJlj1xjey5sLOpJHRpatb1mw15of4HmrrvrPqWnt6Utbor/NgxvwK4x6C/y8wbMhoY53gyh+dPotnV0gMubh1u4RQqqS/1/pcfABk6EpSkG+VuWCoq0H/VAzxbYnlw2hcjntHcRz78jotwKgu08g3LaqyUxouaWSn4vTn+7Q+D6Eburn8VhASiepWNKOVxJCyGzoFPvqtO4ys1ufWg+s+xmR6lzz1qFAREMwESX07vcNQfoOUqDtzD0H8zOQ6ZlSh8OtZ1dl1g5KrUdRXuuEv0nNT4aBV74thJ7LzTnEAdgZLD+pjDjh4X8Jcn+Xh3kf
 IoGsWaOo
 OuzzucZOvNLwo6g+tvAjvxNDpQpBb1xPt9Yuls9/FHZJFT1jfKhFlkpeAipTzgLT7A4AUBc2Qj1hYeP3UZDRAcU0Y6haDfICHtJyLeGnyz8rdPP5nwEkFKELU75IpMyY2cI2WhTqzB/fhImWWk1uLxoRWcBRIPlV2mu7A79gGzsK/xuo/6+FEnjv6Hfmk09QfyUpN7fPhswOj5E62ueiVLN0bEd8yZ9UazUtCqwZrJspMOy+NpXyWNyD8C3RUBIY5ZP6WlZecscNylucPxk/ZUQu9ffsyXNsW/B5k4uUxXhcaZGNOIXD/4tpwk1l6640MHq8pmg4VwKpNsgQntjqkq5FFrRD16nfFCOREjL/B72KU+XYzh3ZWwNjuxh0TnF2yA6QR8SE6vLM+IddplHbh8ocSsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/4/1 19:38, David Hildenbrand (Arm) wrote:
> On 4/1/26 13:34, Lance Yang wrote:
>>
>> On Wed, Apr 01, 2026 at 01:22:58PM +0200, David Hildenbrand (Arm) wrote:
>>> On 4/1/26 13:20, Lance Yang wrote:
>>>>
>>>>
>>>> Ouch, you're right, I was wrong - the trylock drop is a pre-existing
>>>> issue, not caused by the reorder ;)
>>>>
>>>>
>>>> Nice, LGTM!
>>>>
>>>> Given that the "trylock -> drop" behavior seems to exist already today,
>>>> do you think it's worth fixing that together with the reorder?
>>>
>>> I'd do it in a single shot if possible.
>>
>> ACK.
>>
>>> Can you craft something? (cc stable etc)
>>
>> certainly, will do! But commit[1] ("mm: migrate: requeue destination
>> folio on deferred split queue") is only in mm-stable now, not yet
>> upstream/stable ...
> 
> It's tricky. The original commit will be backported to stable kernels,
> so we want also the fix to be backported to the same stable kernels.
> 
> The commit id in mm-stable is "stable" now.

Emm... Not a big deal, I guess. We can always submit a stable backport 
once that fix gets merged into stable :D

