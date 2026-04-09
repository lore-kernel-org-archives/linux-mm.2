Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56C03E9DE41
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 07:06:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C86E6B0005; Thu,  9 Apr 2026 03:06:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 979856B0088; Thu,  9 Apr 2026 03:06:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88EE26B008A; Thu,  9 Apr 2026 03:06:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6CA8B6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 03:06:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 17376B8B85
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 07:06:04 +0000 (UTC)
X-FDA: 84638133048.11.8E64D74
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4FA20120014
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 07:06:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=e+T2023E;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf29.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775718362; a=rsa-sha256;
	cv=none;
	b=NTLnmr4q1h/6gLfQZ7c+6kZLVZFX1zZ7Eg2Q1isXO+eAUNLGiEzYLbKQpyLjxdf0aPuRfN
	OQq4IOSBtVOn+aiVn3/NjameVkLuTkbYCku94HYddUsxAZvCQ8mz55PRObOJKyGsiqXVxX
	D65qPua9YyBKQo0aVEyQrV+mgBvkpFs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=e+T2023E;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf29.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775718362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Av5kApTuVKQ2ovOm1Q+K88vhXOOjtCZxC4N23qscKWQ=;
	b=YSImnD35fJBtH1KlTxs5qvA9wz9dC3XaLIovFztpyASMCeJPG25J9XKEQ1nDm/1sWrNpNL
	RbFwAjC6MVYqaDDP+pL6JPb9VjseqWiDGl7z9xuhmaXCIzzqrNcpH/NQEY5EcDz2USHPVe
	axduM+z2At+fNdeAYW9uzedaHWymYEc=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775718358; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=Av5kApTuVKQ2ovOm1Q+K88vhXOOjtCZxC4N23qscKWQ=;
	b=e+T2023ExjiZS93rgp1WVGhS594foI2Hxy9WRZlnOPhyARu7i0bVCgzH/NCN4cvCLADBfIzqwA9E/AaGWmtugSDUW9CPH1LVf+rdKH77n+/HYJ3buOdj0Rw4+SIoPDDahfCiuImWVlCrFhVh9Sj5GXZ1UDW3qOltutT8soXgiIY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0X0hYF7w_1775718356;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X0hYF7w_1775718356 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 09 Apr 2026 15:05:57 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Gregory Price <gourry@gourry.net>,  Andrew Morton
 <akpm@linux-foundation.org>,  Jackie Liu <liu.yun@linux.dev>,  David
 Hildenbrand <david@kernel.org>,  Zi Yan <ziy@nvidia.com>,  Matthew Brost
 <matthew.brost@intel.com>,  Rakie Kim <rakie.kim@sk.com>,  Byungchul Park
 <byungchul@sk.com>,  Alistair Popple <apopple@nvidia.com>,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,  kernel-team@meta.com
Subject: Re: [PATCH] mm/mempolicy: Fix weighted interleave auto sysfs name
In-Reply-To: <20260407172350.699577-1-joshua.hahnjy@gmail.com> (Joshua Hahn's
	message of "Tue, 7 Apr 2026 10:23:50 -0700")
References: <20260407172350.699577-1-joshua.hahnjy@gmail.com>
Date: Thu, 09 Apr 2026 15:05:54 +0800
Message-ID: <87bjfsy5nx.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Queue-Id: 4FA20120014
X-Stat-Signature: znsqwexa8ayrmu9bnfgf8oo136gttcqp
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775718360-80382
X-HE-Meta: U2FsdGVkX18IXmFEv0pJ9TJq4GCeIrZlDWXoQjFqPvJJZ4dFj42eEWuODq/TPZnzZli02B38IgUfYnN66dpTjquKvSSf8ThzEPFKW2r5tO1+jN8fT6y6un1jSbW1i9z7JDIhtBCuCV/N0CohB827qEgddCPvcAKa6f4ErBP57o/t/Coo0PhHKimCsdipblTx4x1Ig6xCPn9ZrsgIOK996ElMRtAJ//yQAU6ey+Gpe7hQj41r/tu3hvHn4aITsy72Og9VwVnVHYa9REEamezIDGFNB1wk7P44i7naDM1ECBGT4Dceofvx3dnZX95Ft+PamxcLY3IKoSRSArQ4hvnGvGLvAu/KSOeeaGQc/MYlJz0JxeovW8DM6Z+t2gHl+PqHXkO8KfUAuBf+FCY3pSeKTPk2F4OU4j47Ddj1JQjYAPPzOGT4f84UZmFcV5eQTyW2XbXhLjMWMM8C/D+qUj8kkhnEzdVLQVDlgEq8EjZD9cgzH06wrFmFVfpV/qJR/PQlYf4vG+L7Uz+Fwep2AJ0GP64F+YW6Afio2GwGZ2vtYBsPdONP4J8jMOhLeKoWPbeqP0Rlx/US8VXBSsNa7suX5hoLUrJw4tsMMte/1Pt9JUa0gzIIP0nsubtoDmNdU3/Q6R7H0ii7ruPsDI068o2Mi2GleFoVQ3pxKsv0XRLzMshAGieYpBi6+xzwcVn5NNTCbexxVj8CFF2wLqOADi7UNfi3ATeDuDaOUB7Qm2FnIOAAhwsgXSuDXkULtBiRItHuenBtXzqRU/Fo005/PZCn6NDXxFWtPUC7P0ybEixg45lfUyie8lG1WuXnWMHXZTsS2qoYpjFrIM1iYlQFSlQAOBIOloDKh+0CIueg/dWF43nlJ3/piVm7IyZrjakx+fC468UjJOIugUvDdBnYxlFb9xwBoifdB1+gZwpXUNUmxXTGfwJBC0BZUr7Hts7nHmH3LJVSM5GvTimbFVxUpY4
 19ovW6sQ
 rBbBapTo4kkDLmvH2jdq7d4bOSt6R+9BJB2d8bWOrqk8EKrkOpq41oeaTykwRlwnUwsLO8LzBMA1T+xB9yZX0zLWeA05F7+3BFQf9R8239bUyRr4tUsR+JgdvYva1uFn8HhXQlBss8BcdoaNo+8JD3MwUl/7P8YPgR/s9ylnm8UEa/Mr+9nUDeCSDKsKVI6VHw921ObHXeOuA6oQPZpF0j38L7e0p6gpR94LD02e95twDCOYiC7tNyLtIDkwpg+7aiU+59OekQwzVz7NjArhfsRKQveCSlCMMs5ocattmv12sc41tOnzKyqkvileoCVQZDrJSYosPjk7Z0NpiNRk/aZp7ZmpXzC2w76sP0Rf102wOPPY7zxTkqpZ8PWwjn4jjvFUNRz9D4QUm0MJen0paJFsTs5TSDpP96Omq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Joshua Hahn <joshua.hahnjy@gmail.com> writes:

> On Tue, 7 Apr 2026 13:09:04 -0400 Gregory Price <gourry@gourry.net> wrote:
>
>> On Tue, Apr 07, 2026 at 07:14:14AM -0700, Joshua Hahn wrote:
>> > The __ATTR macro is a utility that makes defining kobj_attributes easier
>> > by stringfying the name, verifying the mode, and setting the show/store
>> > fields in a single initializer. It takes a raw token as the first value,
>> > rather than a string, so that __ATTR family macros like __ATTR_RW can
>> > token-paste it for inferring the _show / _store function names.
>> > 
>> > Commit e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tuning")
>> > used the __ATTR macro to define the "auto" sysfs for weighted
>> > interleave. A few months later, commit 2fb6915fa22d ("compiler_types.h:
>> > add "auto" as a macro for "__auto_type"") introduced a #define macro
>> > which expanded auto into __auto_type.
>> > 
>> 
>
> Hello Gregory, thanks for reviewing my patch!!
>
>> Well that's really unfortunately.
>> 
>> Is this really the only "auto" in the entire sysfs structure?
>
> Thankfully, it seems so:
>
> $ rg "__ATTR\(auto"
>
> mm/mempolicy.c
> 3786:   __ATTR(auto, 0664, weighted_interleave_auto_show,
>
> arch/powerpc/platforms/pseries/power.c
> 44:     __ATTR(auto_poweron, 0644, auto_poweron_show, auto_poweron_store);
>
> Although maybe it is more valuable to check any __ATTR family macro
> for a macro as the first parameter.  In hindsight, I should have been more
> wary of passing a keyword as a token.
>
> [...snip...]
>
>> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
>> 
>> Maybe - 
>> 
>> Fixes: 2fb6915fa22d ("compiler_types.h: add "auto" as a macro for "__auto_type"")
>
> I thought about adding a Fixes tag, decided against it because it's
> purely cosmetic.
>
> ... but now that I think about it, I think this could break some workflows
> for users who have automated writing to the auto sysfs file.

Fixes tag helps people to decide whether to backport the commit.  So, I
think that we need it anyway.  Feel free to add

Acked-by: Huang Ying <ying.huang@linux.alibaba.com>

in the future versions.

[snip]

---
Best Regards,
Huang, Ying

