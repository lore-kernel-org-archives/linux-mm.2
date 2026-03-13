Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E81C105F7A8
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 13:48:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F29316B008A; Fri, 13 Mar 2026 09:47:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBFC26B008C; Fri, 13 Mar 2026 09:47:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCFCA6B0092; Fri, 13 Mar 2026 09:47:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CEEB76B008A
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 09:47:59 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9AC401BE97
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 13:47:59 +0000 (UTC)
X-FDA: 84541168278.24.B51C0BB
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
	by imf30.hostedemail.com (Postfix) with ESMTP id 99C6280013
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 13:47:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.196 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773409677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ydJU4uu1SDaubdlZkanQq1xbavAKjumGai9jG6QvmEM=;
	b=o3aza4T6h/FfYxwPagaut/KURLLwggjBnH1OTJwasBcZ24ozmpPHC2mrjO42phACE/VuYv
	/zy9crnCyZFyCq5MPFabRV96WfPzeWmgsL3JSXOJkD1MF8APf5L6FL5tDf6wyi7t84OkK9
	rrish1hYjEiA10u9NHN5HEq+3qEMWfM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.196 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773409677; a=rsa-sha256;
	cv=none;
	b=IHgyN9UR+fKRu0XC63l9KniFeJYNWFYzkHJqCF0ri0XtDGnYsRyZZ/4O5KAaffP/jlyIbj
	iK5ftUEc51r1YmDz0n0PyMznz7e4GDB3+PFjHg7aZUsucga1PkDtDQYBjzYuYyXgmmYCR8
	nlipuKphcCPCmJGbPxwftXNSGYFw1c8=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 182733EDD5;
	Fri, 13 Mar 2026 13:47:49 +0000 (UTC)
Message-ID: <fa3994f3-3b10-447e-a550-de4e695e82de@ghiti.fr>
Date: Fri, 13 Mar 2026 14:47:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm: Fix demotion gfp by clearing GFP_RECLAIM after
 setting GFP_TRANSHUGE
To: Andrew Morton <akpm@linux-foundation.org>
Cc: alexghiti@kernel.org, kernel-team@meta.com, akinobu.mita@gmail.com,
 david@kernel.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 hannes@cmpxchg.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 gourry@gourry.net, apopple@nvidia.com, byungchul@sk.com,
 joshua.hahnjy@gmail.com, matthew.brost@intel.com, rakie.kim@sk.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Bing Jiao <bingjiao@google.com>,
 stable@vger.kernel.org
References: <20260311110314.237315-1-alex@ghiti.fr>
 <20260311110314.237315-4-alex@ghiti.fr>
 <20260311100646.81819c0f02eec5d3f1dcaa70@linux-foundation.org>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <20260311100646.81819c0f02eec5d3f1dcaa70@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeelkedvucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomheptehlvgigrghnughrvgcuifhhihhtihcuoegrlhgvgiesghhhihhtihdrfhhrqeenucggtffrrghtthgvrhhnpedthfelfeejgeehveegleejleelgfevhfekieffkeeujeetfedvvefhledvgeegieenucfkphepudefkedrudelledriedrvdefkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpedufeekrdduleelrdeirddvfeekpdhhvghloheplgdutddrudeguddriedtrdektdgnpdhmrghilhhfrhhomheprghlvgigsehghhhithhirdhfrhdpqhhiugepudekvdejfeefgfffffehpdhmohguvgepshhmthhpohhuthdpnhgspghrtghpthhtohepvdelpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopegrlhgvgihghhhithhisehkvghrnhgvlhdrohhrghdprhgtphhtthhopehkvghrnhgvlhdqthgvrghmsehmvghtrgdrtghomhdprhgtphhtthhopegrkhhinhhosghumhhithgrsehgmhgrihhlrdgtohhmpdhrtghpthhtohepuggrvhhiugeskhgvr
 hhnvghlr
 dhorhhgpdhrtghpthhtoheplhhorhgvnhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhm
X-Rspam-User: 
X-Rspamd-Queue-Id: 99C6280013
X-Rspamd-Server: rspam08
X-Stat-Signature: 7eutuof8equzed96pweie7rhsno6d35s
X-HE-Tag: 1773409677-302609
X-HE-Meta: U2FsdGVkX19e+5q8KvTf/46DFQlQkQr1zueLs3+nagQ/sRmEO+fxdVWTQ434buJfKdAYnr5Q+02bvRiO6ukUOj/Ine1riEU9WsIqWoM+HFYtiKEcNgs/H+hmgJGe9e1b80Jx1dlWDJtAyUjL9O+R8rLDy4vms3ZZxADGf6U3atorVI8m0GGcd1q94aLZ7s/kr3tLRE7Lgbu5A8fdJA0dhgKWIwdsMYYCTLSwji16PKTyAmUU8nOuKEMdzLmhR57p3ZVD9B+SMMB7I6NymyJLZdUJpta00xvtIq3P+VFrlG8o6jMWNHL3CAfvMHFGjHbYFaQ20IPhimJjylOmiLhpK7QNVs5uCmyhe8zjYxs0H1BofB0QH/j+X8DgxFWzo6dyOEqD10ZdicmoArrJNcLoCzIZZlDltWy3XV3s+hiIfxQk8GlJDaVURTohegooUubYTv18nrpeo8lCi82nDnVf/WlY8s6WybE3im96eWTa7zXaInRTawl0Y/mta0fEyDYWdEvrZdxBO6NToNV+yoTthKbTngheHL2TnptAeDEDUwdnqiHNBIoEYcHdzZePAaL/VQQbBz48hGBOu4WorUztRgylh22Y5RC1ZzHDrcAstGoC9cW30xA9kNArf2+6Hux4IwYjwBNsAVtO4cs4wx4qq60XKTt1HiNpVwE8Wg2lG4LQ5w1N0/xhKzY3lW09RHMPZA/e4TsXAwinPZXiBDvesxUnpUwW0uZFCbL3qUecWXpVbInXaZGOGnFs8qUkDCGB7AYs8Le1Qp7A54/U4YxKYqrA1igJWRnWVsk+4yXpf+l0pAk/zTJ0kclhnCO5o5iWe3CbR94SUixdO+CgUuQx5EHGjZ3GWu37h+221uDEECc9+6ePolZv4rJ1b4lOfIF+3dwknEZVqm/3B6wpy912jQH5f6cXM9j1nKnD8wrOC76ZQmDihbt6pnbEEK48XGOmOvSssGNLDg3A9JNbYAF
 n6kLkBCb
 Uc+q4dFm3g87cNqHRuG4IZ3LnO1T4FA7mRbFHcfvBUagrMHTkawwDDRwGq+Tk7ZLG5DO0B39XXFBXjW82kzzeC3ClkI7h2MYp7Ji3YiKW9LJPJfgcDgxPTix6tyyplysjq4hRbcVUh/uYj+g1/4MqPHcpiJpzJz8FfWcliejvM4yrmNocMHdjB/A67XuMn5x+x2xt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

On 3/11/26 18:06, Andrew Morton wrote:
> On Wed, 11 Mar 2026 12:02:42 +0100 Alexandre Ghiti <alex@ghiti.fr> wrote:
>
>> Fixes: 9933a0c8a539 ("mm/migrate: clear __GFP_RECLAIM to make the migration callback consistent with regular THP allocations")
>> Cc: stable@vger.kernel.org
> Please let's have the cc:stable fixes separated out from the cleanups,
> and prepared against current -linus mainline.


I'll split the series in the next version.


>
> Also, when proposing backportable fixes please ensure that the
> changelogs carefully describe the userspace-visible runtime effects of
> the bug.


I was unaware of that requirement, I'll do.

Thanks,

Alex


>
> Thanks.

