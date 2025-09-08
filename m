Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D518CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 03:49:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A871E8E000A; Sun,  7 Sep 2025 23:49:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A37BE8E0001; Sun,  7 Sep 2025 23:49:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94D3C8E000A; Sun,  7 Sep 2025 23:49:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7D76B8E0001
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 23:49:10 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20686C0943
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 03:49:10 +0000 (UTC)
X-FDA: 83864702460.28.796F9E1
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id 647BA4000A
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 03:49:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Li3hIYhw;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757303348; a=rsa-sha256;
	cv=none;
	b=jvkXxtRjxOGSM5mmX5ZDLfXRveOkqMMxGkubPHx/p6Iody+8iKzqJEj+8UsAQTD0MBjHdZ
	c5Fkbos9ImmuJDIv0btblBrumA/fiD0UKE4ZoL9rnqdtNlXpWtPIceX1bEbw+an5pNVdAe
	SvdWEqsprx2wi1cCS6kD/xwG3rbz8Gc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Li3hIYhw;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757303348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xzr2/A/9cRnXL9ljRehbzAVPu6ab6EXNNePw10uMb2I=;
	b=He9o49E4Idc9umuIfwIbAmgG3+chRZGDWTd8KzYyy+L+UogZTGFMeLu6EwZ2Fi/iXygo6O
	2y7nT+jqPsQgOS7c+5Z7ZVkKiOym4uDV9+AVGylYVochgOJSMiRTyY4exgvrCjyhKjrHAE
	kzCFUP5macp70TKIQcbtsts57C4NQtw=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1757303344; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=xzr2/A/9cRnXL9ljRehbzAVPu6ab6EXNNePw10uMb2I=;
	b=Li3hIYhw7VUuOtZoswUCZ7L9OxCeB94XW5PmdCcy8EqYj/4+AZpsyoqapvwIudg84Pyzturwl0SOG7HY4WekPB2iEHSWJIroPfbVgW0p0sxVZtRGnJxumqn6Vsu1pA+YNu2OejN7wvHvnV7l3jT10X5N+DPUbgYpt9TJLdtan3w=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WnQjwli_1757303333 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 08 Sep 2025 11:49:03 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>,  Joshua Hahn
 <joshua.hahnjy@gmail.com>
Cc: akpm@linux-foundation.org,  david@redhat.com,  ziy@nvidia.com,
  rakie.kim@sk.com,  byungchul@sk.com,  apopple@nvidia.com,
  linux-mm@kvack.org
Subject: Re: [PATCH] mm/mempolicy: prevent the risk of division by 0
In-Reply-To: <20250907235332.931050-1-joshua.hahnjy@gmail.com> (Joshua Hahn's
	message of "Sun, 7 Sep 2025 16:53:31 -0700")
References: <20250907235332.931050-1-joshua.hahnjy@gmail.com>
Date: Mon, 08 Sep 2025 11:48:52 +0800
Message-ID: <87ldmpwqmz.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Queue-Id: 647BA4000A
X-Stat-Signature: j45xib1u3z7aip9aafktsepk3wq1tpb7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1757303347-423778
X-HE-Meta: U2FsdGVkX1/VCo4AicnHaOPKb2UlCoYOFZh17S0dwVBElR3qUjHYommrFZH6mnj2t5d2XNYBmzznvaZB3s8k7Qf3/z+wjo5erZUo5E6jeNGMT7S+hVyFN4DghJa5JyNucHs8CTDl7c6tuFsbMq2TfWP5cfhSy5BoYw8kMeJbpwEUXa7dZ8d4keXK6Wyuy9lQ1weLhwboD8cI76zDsR4DvCBUKnCYWqcFn3a9pKN+vcCN4J0Yx15Kn3E+FyDx2zFjX/EZ+mHNJNRgJ5ieZI0csxHIBjr6JycmhN2FDniXLRzOJDYhw2wdOp4Qas0Mq+iXAQbj6n61jhClYtPl7phjpTCUoY4ajfWd3JSj1y/nE3z4Dv8GP2GJWg7WJHNXvb829Bilj1BLCwxrgvFre5pSthnupLb3+wxyEC77kuG7Axz/TbPneF0PLAwRzGD3vBULEWXToQX93yaLAi7aj+52PSlisB6XVUTCVxXNvnYBYfqUZOFv8Q9R8Cc90swwYFUWTv+NENHpu9ctwIOiMsaCFb8tqlTNCcL4TkOFOcupnsglROMB6fHX+L3KzujXsLyADuRMlzbYxz5JEXkhTs/cIPuQVKtPLIQxOTEKATKaIBXQlERkydEt3wqcUaVru40uUa9Z44X20bs93EyqBe9ErMdPxCbEy/LvsskEX52BsCaugTc+gOwrsBTI7bqh1BVRRNQCaaypNjwaGiHouVlcc8+PncJ65nledepgSRaabuYrnFEhoEZpPZevqTNoVQ22qPgvmlwO5xQaSGgCDwYb1lDPI6IjM2SCcaEfnjv+dFgkqqDlz5VDIOXiM6fbIoREVhg8cuSLjN3S5j1y05IRROlpd7KC9y+/ZpHiY1lkJdjRhVhNeXRCL6jNfZeOk3Ih3UZso9kla1lV1fe97e+JEGg8tq+pBmTlXwU7hiJBE34MzghJciwUaMcpDxsa2dYReVzBDCBYiXcDCC4k335
 1R9vWUrp
 t+GyyZ6dcdQ8XvKYXlqYVUabouvCJ+rA81UKx54My2ppa0IDwNUShUPGA+yqC9+PrlI5bLNeRq4n1WZYr/KLkM0Ir910GdrM8c4DyEVVIn+SMEx6o5zu0R9THhV5fOGnVjkxt437gXnjUqAILNc76gVdSRWRJZ/j2NVzGXTtu4rpvMkwGGGfgmoj0C7EVT5gKLwjvviS5oQvGfuKsCtI5VFA/FM5UHAVKkvG+sJ1oYmt46lJf6NvYM2fb5xlsZ0HE2mit+jRQpDxZY2Ip3NZyz2u0y48xTRNolIQD6H5encIu5gWE+S0F1P6o90LzmiSHme2j3mgK1QdK+IrQ4NPXDS9/LNPRoGDUhYt5h6evtCbR7lo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Joshua Hahn <joshua.hahnjy@gmail.com> writes:

> On Sun,  7 Sep 2025 09:08:29 -0700 Chelsy Ratnawat <chelsyratnawat2001@gmail.com> wrote:
>
>> If no bits are set in the policy's node mask, then nodes will be 0.
>> This patch adds a check if nodes == 0 before dividing.
>
> Hello Chelsy,
>
> Thank you for the patch! I will start off by saying that it probably does not
> hurt to add a check like this. With that said, I think it's best if we clarify:
>
> (1) Have we seen this happen before?
> (2) Should we add a Fixes tag?
> (3) Do we expect to hit the nodes == 0 case, or is this just to be safe?
> (4) If so, should we do more than just return 0 (i.e. WARN_ON?)
>
> From what I can tell, I think it should not be possible for the policy to be
> interleave, and the nodes to be null. If we look at mpol_new, there is an
> explicit call to nodes_empty that checks if the nodes are empty, and returns
> an error if that is the case (of course, excluding MPOL_DEFAULT, which actually
> throws an error if the nodes are not empty).
>
> After all, it doesn't really make semantic sense to allow interleaving across
> 0 nodes ; -)
>
> But as always, it is very possible that I am missing something that you are
> seeing : -) Please feel free to correct me if you believe that is the case.
>
> With all of this said, I do agree that it's a bit scary to do a div0, even if
> I am confident that the value shouldn't be zero. I don't have any strong
> feelings about adding redundant checks, so I will let other mempolicy reviewers
> chime in with thier opinions. One thing I do feel strongly though, is that if
> we are to move forward in the patch, some explicit clarification that we
> have/have not seen it happen before, and a WARN_ON would make sense. 

IIUC, the patch is to catch the bug during kernel development.  And, if
an exception can be generated for dividing by 0, it can be used to catch
the bug already.  If so, IMHO, the patch appears unnecessary.

[snip]

---
Best Regards,
Huang, Ying


