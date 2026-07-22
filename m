Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56741C44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 13:54:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CB656B008A; Wed, 22 Jul 2026 09:54:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07AED6B0093; Wed, 22 Jul 2026 09:54:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED3136B009F; Wed, 22 Jul 2026 09:54:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CB85F6B008A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:54:40 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4D50AC01C1
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:54:40 +0000 (UTC)
X-FDA: 85016557920.09.0CB26D4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 457C21A0002
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:54:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="arvW5y/g";
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784728478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZNv7peGFV/82DC1cdUoaVd+Nv36b85dTLQCm80SRMF0=;
	b=WBe3Ktkt7r4DBgS2UQbWUSKMORcXh0+kb90AaL/3MMQMebgrcFjqnY5WvkXW226HvEsqtL
	aHNO3bwGdsRIO0Z8RqimKPWEIOh/Pz6370Ics8KHjLq0QYPj0tG2vG2LPM+5o22/g89EDY
	bw5KkHU7lbQUpFjaLEO21QwrfdNo8f4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784728478;
	b=2DaMFXf49tkHHpkVNBV08vukyc8WorzbgM2hwxNgjOnxfbAhXCzX57qHp0ft1FBfLvoIfY
	xCjAiUFpwYvE71S6ianls35PSPbOXIyVy62cpZpIhH4KdnuhZn4HqA9q6QXbSmXn+DYhjb
	5coLIE9RcAww7qoqWWgbozhjDrqHC4M=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="arvW5y/g";
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D06DA1595;
	Wed, 22 Jul 2026 06:54:32 -0700 (PDT)
Received: from [10.164.19.44] (unknown [10.164.19.44])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 251033F59E;
	Wed, 22 Jul 2026 06:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784728476; bh=kRlLh6vb8jx0/62iQUQi3I2/CfPEqiB5RJ3y9DVFQ5w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=arvW5y/gsXMxgbhxLXOryhnBWf8VH6epu8Og1Rh33qwarIKtzEeiaQSfdtndZ8mVm
	 yzen6khX4L3taHk3yud5zzvdHKeooFS30u1QNfZPFXb21I2Kdec/GrSiDuM/DejPtc
	 9mu87ra/NbMsv7cZ9tIycWEXfr/wJS2J39n0JJyg=
Message-ID: <03f91210-e0b7-43b9-9a95-755b986b3c40@arm.com>
Date: Wed, 22 Jul 2026 19:24:31 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] mm/mprotect: shared-dirty base-page toggle slower
 since v6.17
To: Chengfeng Lin <chengfenglin@stu.xmu.edu.cn>
Cc: Pedro Falcato <pfalcato@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 linux-kernel@vger.kernel.org, regressions@lists.linux.dev
References: <7c9eeb21.1c04f.19efaacbb2f.Coremail.chengfenglin@stu.xmu.edu.cn>
 <433d619a.1e8a6.19f1d4d1be6.Coremail.chengfenglin@stu.xmu.edu.cn>
 <6c8d9b6c.24a8b.19f84afccdd.Coremail.chengfenglin@stu.xmu.edu.cn>
 <dc402537-1527-4433-839e-960b6eb32bc4@arm.com>
 <4dceab6f.24e3b.19f8966e8ed.Coremail.chengfenglin@stu.xmu.edu.cn>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <4dceab6f.24e3b.19f8966e8ed.Coremail.chengfenglin@stu.xmu.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yzsktqrbzg49fc4tg67r14pyqrkrwbip
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 457C21A0002
X-HE-Tag: 1784728478-361809
X-HE-Meta: U2FsdGVkX19Dh//sCPq7qu4gJU90kCpa6Su735tN+d48TNcuO5XyU4wKFnjVBnmTNudTi+ySnkZmajLQKSYjwQfMfXEBMpc1kxuCuN4RNd8Fu571ApmG4oq37KEOBrzFfnfbqt1N5D5mqIF4XtEJ5mdhtBHEjh9VpNck5niAOROl5no+31zYd2YjcijgErxMMKofuZq+vXqtkUeRYynBAYruNtOGpPQLPzYIJQRqcDnuLmABhz9/Kpea5Fcfuz9NkGEsGPb8/2tDEHcnxQNBKayzsQo7es0DM/xDtTQYbP+bLD1mQDGNqtDsCos7r5AbWdmb8geMut2Ki4FxPdbbfXw1qsoUjO5Koy50YKCTWNmlFHWGijbb8EcNBtlGhN5tLlmNtYsRdH6S6h8/csH5jzmQDx6yAUDL/P1/wds9zCdz7dLwqNF1XBCbu1AB8V7frEDXfm/m2GmqzZ1N6molF2RytMKM+2J7TfGK2RmxRuJzh1+QdPq2i+NVpodb/sKEY42zJaVTs9762b+X6ceGeMseFPPMCHR4ZnNJBKz+QV0cJ0easMuc1owYNlibxKySbybTsbKj/fn+Yg7oIkCrG745HU/MeuVPSoa7sKfuS1d+UCQhn921xzJz6MCpAngudB8Ut19AKslJuWvFYqrfNvEd5vG3+3b/nIffpmUJnGnHUyhZTW2NrzSy4EF8jF+gxwkuVigaIFr9Sy1hSAbFolgtj0kQHUaAG1W76j3dzzH21vPcMF/SDMaHI2JPIzCEQnIhNM/CzVj529GZZBeY8AjQjn9fQs91gPtffS04hEPDHzdbFd5kLDmsqh0CAYMMBMFHbh0DMWSDplSDk1AOY/bVfv7u98Z0eBIImERLt8wpYULM03uCzpRj8MSoNhgctVmyD8QNVmq1DiMvJgFdDbVB3ZUREx9uMb+yv/zhYkp9Sscvgvxi+b6ZBpZv8Iuslwk8AcH9VOdMJAMDu56
 K87Y9G8r
 TACdl5yb4JJQ+r7JS+doV/XKQqs8whTY01P4wm9w3OMM/yxbTPCzYl2Al9Hzggb2YBfq7NtP6eU34sSA+BLxlxxgB1q4AkaozddMfj2w51mGwkvKzQj24IS45qMvi+9TRy1MGXXZfpX2/TknaKd1qsXeS40yO3bRRsR6QcYFNhUvFDjNtnvaWzDgmBYrh0qyMHmQKBydPLmXrZuHQBOdW3yR9s9J5Kgn7Ta5bi8dDvs2ejV4jnR0QSEmetvolgWuEiuGaYTgX9AnL3pMMjAr8nCGwufTuWUEpIVi3TSZJ+lfjjdLHqr+eVfS08OeylTWuyS3u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 22/07/26 4:07 pm, Chengfeng Lin wrote:
> Hi,
> 
> Sorry that my earlier message was difficult to follow.
> 
> The previous exact parent/child test showed that cac1db8c3aad slowed this
> workload by 39.77%. To answer your question directly: no. In a separate
> matched v7.1.3 patch-on/patch-off test, Pedro's full v3 series was 6.20%
> slower than the no-v3 controls, so it did not reduce the slowdown in this
> workload.
> 
> I also checked for an update. The latest public revision I found is still v3,
> and it is already included in Linux v7.1.3.
> 
> To isolate the series, I used the same v7.1.3 source for both kernels. The
> no-v3 kernel replaces only mm/mprotect.c with the exact pre-series file at
> 19999e479c2a. The full-v3 kernel is unmodified v7.1.3 and matches the series
> tip at 89e613bc0b2d. The normalized configs and all other build conditions
> were the same.
> 
> I used a fresh boot for every point:
> 
>   point       mean ns/page
>   no-v3 A          55.333
>   full v3          58.200
>   no-v3 B          54.267
> 
> The no-v3 midpoint was 54.800 ns/page. Full v3 was 6.20% slower than that
> midpoint. The two controls drifted by -1.93%. Dropping the first measured run
> from every point left the v3 delta at +6.18%.
> 
> This was the same narrow standalone workload: a 64 MiB shared anonymous
> mapping, dirty 4 KiB pages, and repeated full-range read-only, restore, and
> write-touch cycles. Each point had 3 warm-up processes and 15 measured
> processes; each measured process ran 1,000 cycles. The benchmark was pinned to
> one P-core with Turbo disabled and preempt=none.
> 
> All 45 measured processes passed the returned-value checks and stayed on 4 KiB
> pages with no THP. The protect and restore phases were each about 23 ns/page
> with v3 and 21 ns/page without v3. The later write-touch phase was unchanged.
> 
> So, for this specific microbenchmark on this machine, Pedro v3 did not reduce
> the slowdown. It produced a small slowdown instead. I am not making a claim
> about other mprotect patterns or application-level performance. My earlier
> QEMU result that suggested a partial improvement should not be used.

I don't see why Pedro's patches should cause a slowdown. The only diff I can think
of is the if (likely(nr_ptes == 1)) check.

But again, we have had these microbench regression discussions before. I think it
is clear by now that vm_normal_folio() is bad on some systems. Best we can do
here IMO is avoid that by doing something like

https://lore.kernel.org/all/20250506050056.59250-3-dev.jain@arm.com/

> 
> Thanks,
> Chengfeng
> 


