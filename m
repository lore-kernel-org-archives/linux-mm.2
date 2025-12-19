Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0373D767F7
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 11:46:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09ACD6B008C; Fri, 19 Dec 2025 06:46:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 041736B0092; Fri, 19 Dec 2025 06:46:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EACA16B0093; Fri, 19 Dec 2025 06:46:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D81F46B008C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:46:48 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8F4A6140436
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:46:48 +0000 (UTC)
X-FDA: 84236043696.11.2993B09
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id CCEE6140006
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:46:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dETzg5j3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766144807; a=rsa-sha256;
	cv=none;
	b=p0fDXLKXmuResZ9G3qbRIvZ8TpnqbM4S7onwpdun6c5J++Rqyo/MpV31+omTCRM8vTch07
	DdeQiRfProyjC+xtbuZEP7dbAy476SNoZZy+sc53sfj7O09voWofhlLPYny+BWNbpy9lrP
	P9t+onMYhFCULNbsZ2GPu6DPRjmlAnM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dETzg5j3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766144807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JxgLbUKw1Akc5EtQqDOSy+Z3+O0YY6pI9k2byi7wuBE=;
	b=difPI6yXk1Kf3ZrQ0R7LHsfknn/WzkmMeSC0WyVlk9iQU0T292x+ioSdNmfwi8L68r4Xix
	slSpNvjxteGmj4/7Mru79LCm98Pwu0ZuePHtsuaiKjrd1EkB9K7RiD8jJkriT/ts5YEQA3
	qEKGDHHrLxlQlWUKzGdzmvPKbhqhd9o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8EAA940A54;
	Fri, 19 Dec 2025 11:46:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380C5C4CEF1;
	Fri, 19 Dec 2025 11:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766144805;
	bh=ZMIY8bvpAjYIhNLbORbK74fYFOO6FDDan9bMjBbDML8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dETzg5j31g043NXtaTvY6nlXP+kWJJme+5yA3MJx9PHC3Z5sdLJJz5nShg8YmxH3e
	 5kIbk4xdU9H14nPUvieVZekusoB8RbaKbI5ZBpQPK4SkF6y1MFDZ6jBfGAhSZBN5ZO
	 sms3XtIeFwh+QBCpoK+AgpGu5kv6irIZOTGiDgTl49GJJimpTLOD19j1sJwXtbCJM4
	 5dcuFovc9TBKgu/KpH04pZt4T4mgwMIOwsqi9IMyXfIqWqEkEAdsgW02uvD1Tc/Mns
	 b5Wg5Vz3/p5Es7/CbIVMgmeK+Bu+z1NXpbjC6U9rZvHEjdi5jFDdNPoDE5ZOqNifI6
	 0IG872Xai0aIg==
From: SeongJae Park <sj@kernel.org>
To: Enze Li <lienze@kylinos.cn>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com
Subject: Re: [PATCH 0/2] mm/damon: export symbols and introduce prdm module
Date: Fri, 19 Dec 2025 03:46:32 -0800
Message-ID: <20251219114633.41156-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <2c8dd0de-e650-4a74-b1f7-61ed81c03d26@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CCEE6140006
X-Stat-Signature: o6k3szebygon4qpfszo934g3ob5t9z1s
X-Rspam-User: 
X-HE-Tag: 1766144806-930886
X-HE-Meta: U2FsdGVkX1+D/tgQCWPo8hyEhzsFSJUBe96XQt6xoSg9QPcVJzgzj5t7q5qphuLxje0EenGcTvueLF4cm5FrPtfsBUDUHoJrWUrgFOXQvQZ9SolK8eseE9VoE3hmdLm2Q4VOH7mJ0bAd8BjxvdB85QXaI0SIabXqDrL36UOQ1wPyC3qghPXxUtnEI2sG2dEAp38srNAygVRCBny57U4+vg4E09wEb+jTYD0MjWd1UUbSaqn9rYL5p56yaiCvdIwx0Jyq4SaZIvrb3eFrhRW/KnVSeRT6DEIfe3UK9od3mVFiOrhCs/Nw40svmKypI1u8Jw4yVPJYZ4jecfDvLl8RVz6/tVrzPBbF1xvvt+fD17aVf/PV2UklKy2AnGre8zCg8Jtg2Ligc56ilNhs0ml7Dp+J0U/AqbP9jRJ2sSnCKHxZ33Jvug1KtemuhU3I1MNJ4I2P8j3Y5/sNnla94yZ2HovNcLHfG5HzcQTs33O0CTAHwNqJ/spaCfE37ua024d838m2QlR2OXoiTrrmlpZqD4WnCAf+rMq0W+MKy1z1X/hQz+m9zu1At1dXvOaaErE/5Szvz8JfoCZulQuHGaP9D8pXKaEwKfmzxfi0oQKRxJwKBbtwAVZW4GrK2oso2rgoDZifzAZ9iRLhI3Jo0y3N5lcfS5Z2XX/gtELnXJlB/FkB8C6gHW91oGKHa6kBBHeHXwH25AsTd6zabSef3Vn95CHW0jwBXP1FfV5lo0QvfD6m48UuQ0DyIyJbVEuvFkNTl3aXvT/jsM6YCsTURCz6AVrCNUR87l8pQxc3jdqeurBK5OgKAKl0WAzqHu1BOCIulYImADnmjNhQ5eNDQU7b6qUGlGCyeg7xE3CwzlPyddS8rsBiOtiu+xg/ezEbVPjDZEUTqMmdg1tzN3+nL5PBpfijzu3YowuvtttYm+Kr3Q2N/vtWeQgiFCXT6l8JOGpcbwpTIMq+j342KLuURiX
 iBmV/RPL
 nQd1FqEghIqOMl+he34OLAs5Jggheb0qlqHpqVMhiZk/MaUTU5bYaCkY5+1uV3KM23j/VWhpEWE4T7xFj3jHFg+/xR6+8JMMPvOR2AMfQbLZwBeZY+WvIfBzcmfv3Qtx/X169PysvwzzRAKZQcaRRkJXb+v2OInTSD53AUKf//KKYoqclS6plg5IS/zgKqKo4CT2Cu/hKlrqRdiuVjXFEalY2eF4WFz0m6W9hCewKzYG9Rxx3eSCNz8Nkjw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Dec 2025 21:46:37 +0800 Enze Li <lienze@kylinos.cn> wrote:

> On 2025/12/16 07:16, SeongJae Park wrote:
> > Hello Enze,
> > 
> > On Mon, 15 Dec 2025 22:20:55 +0800 Enze Li <lienze@kylinos.cn> wrote:
> > 
> >> This patchset makes DAMON's advanced memory management accessible to a
> >> broader range of users through two complementary enhancements.  First,
> >> it exports the necessary DAMON core symbols to enable building loadable
> >> kernel modules.  Building on this foundation, it then introduces the
> >> 'prdm' module, which extends the concept from the DAMON sample code
> >> (prcl.c) into a production-ready, user-friendly tool.
> >>
> >> The key strength of this module is its out-of-the-box simplicity: by
> >> simply specifying the PIDs of target processes and enabling the module,
> >> users can concurrently monitor memory access patterns across multiple
> >> processes and trigger proactive reclamation automatically.  This
> >> significantly lowers the barrier to using DAMON, allowing system
> >> administrators and regular users without deep kernel expertise to easily
> >> apply sophisticated memory optimization.
> > 
> > I agree your points about the problems and the direction for improving the
> > situation.
> 
> Thank you, SJ!  Glad we are on the same page. :)
> 
> > However, we have a module for such use case, namely DAMON_RECLAIM.
> > It was designed for a reason that very same to what you described above.  One
> > key difference between DAMON_RECLAIM and prdm is, to my understanding,
> > DAMON_RECLAIM works for the physical address space, while prdm works for
> > virtual address spaces.
> 
> Yes, I have studied the implementation and architecture of this module
> quite thoroughly.  However, there are certain limitations when
> considering it for production use.

To my understanding, DAMON_RECLAIM is being used in multiple real world
products.  I understand you are saying there could be limitations for some
different production uses, and I agree.

> To my knowledge, few would perform
> indiscriminate page reclamation across the entire system.  In most
> practical scenarios, people prefer to protect critical processes from
> being swapped out, while applying page migration and reclamation only to
> less critical or performance-insensitive processes.

Thank you for kindly explaining above.  I agree such protection of critical
processes could be useful and required.  Nonetheless, to me, it sounds like you
could also do such protection using DAMOS_FILTER_TYPE_MEMCG.  Actually the
feature was developed for such use cases, and I recently met some people who
willing to use DAMON on their products in a way very similar to what you
described.  I suggested them to try DAMOS_FILTER_TYPE_MEMCG.  Have you
considered using DAMOS_FILTER_TYPE_MEMCG?

> 
> As we all know, frequent page migration inevitably introduces some
> latency to process response times.  Therefore, the ability to target
> large, inactive memory consumers for reclamation addresses a strong,
> genuine demand from real production environments.
> 
> > Is the virtual address spaces proactive reclamation is
> > what you really need?  If so, could you please further describe your expected
> > or planned usage of it?
> 
> Consider the following scenario: a host machine runs three virtual
> machines -- Machine A, Machine B, and Machine C.  It is known that
> Machine A handles massive traffic, while Machines B and C have
> relatively light workloads.  When memory pressure arises, besides
> releasing caches, the system can utilize prdm to perform precise page
> migration targeting Machines B and C, ensuring memory usage remains
> within a safe margin.
> 
> The data below, collected from a test environment, demonstrates the
> effectiveness of prdm.  After enabling prdm to monitor the two
> lower-activity VMs (2316, 2284), I observed that the DAMON-based prdm
> successfully migrated 5.5 GB of pages to the swap partition.
> 
>  PID USER  PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
> 2253 qemu  20   0 11.251g 3.822g  32.7m S 4.989 12.28   0:48.75
> qemu-system-x86
> 2316 qemu  20   0 12.191g 1.524g  34.3m S 5.322 4.893   0:49.05
> qemu-system-x86
> 2284 qemu  20   0 12.092g 1.184g  32.5m S 5.987 3.803   0:48.10
> qemu-system-x86
> 
> root@localhost /s/m/p/parameters# free -h
>        total        used        free      shared  buff/cache   available
> Mem:    31Gi        12Gi        15Gi       5.5Mi       3.2Gi        18Gi
> Swap:   31Gi       5.5Gi        25Gi

Thank you for sharing this nice explanation use case.  I think this all make
sense.

> 
> > 
> > If the virtual address spaces proactive reclamation is really what you need, I
> > think extending DAMON_RECLAIM for the purpose might be doable and even simpler
> > than introducing a new module.  How about doing so?
> 
> Before developing prdm, I had considered implementing the same
> functionality based on DAMON_RECLAIM.  However, I gradually realized
> this would make DAMON_RECLAIM overly complex and less
> user-friendly—especially given its existing module-specific exported
> interfaces, which could confuse users.  This approach would create
> significant barriers to promoting wider DAMON adoption.  Consequently,
> building upon the prcl sample became the preferred choice.

I agree DAMON_RECLAIM already have no small number of parameters, and adding
more may make it look even more complex.  But, users may use only parameters
that really need to be set for their real use case.

For example, if we implement virtual address spaces mode in DAMON_RECLAIM, I
think we can simply add target_pid parameter that works very same to that of
prdm.  If it is unset, DAMON_RECLAIM works in the physical address mode.  If it
is set, it works in the virtual address mode.  Adding just one more parameter
that doesn't break old usage doesn't seem that complex change to me, at least
in terms of the user experience.

As I mentioned above, yet another example would be using
DAMOS_FILTER_TYPE_MEMCG.  For this, we may be able to add a parameter for
describing the memcg of critical processes.  Again, adding just one more
parameter that doesn't affect old usages doesn't seem too complex changes to
me, at least in terms of the user experience.

Meanwhile, I agree adding a new simpler module could make it easy for new
users.  But, I concern if having two modules for DAMON-based reclamation will
make users get difficulty at finding the correct one for their usage, since
they may now need to compare two modules.

For the above reasons, I still feel extending DAMON_RECLAIM is a better
approach in terms of user experience.

I'm not saying DAMON_RECLAIM's user interface is perfect.  Especially its
documentation may have many rooms to improve.

And I'm not very sure if the virtual address spaces reclamation is somewhat
need to be supported from modules rather than using DAMON sysfs interface or
DAMON user-space tool.  I implemented DAMON modules including DAMON_RECLAIM,
DAMON_LRU_SORT and DAMON_STAT for users who willing to enable those always, and
therefore want to avoid runtime controls.  That is, users can use those modules
by modifying the kernel command line options.  My expectation for DAMON modules
may not well documented.  If so, it's my bad.  I will try to recheck the
documentation and make that more clearly documented.

For virtual address spaces reclamation, however, runtime control is essential
since you don't know the pid of the processes before the runtime.  In the case,
I think using DAMON sysfs interface or DAMON user-space tool could be a better
approach.  Have you considered using those?

> 
> > 
> > And, even more importantly, why it should be a loadable module rather than a
> > static module?  Do you have a specific use case that requires it to be a
> > loadable module?
> 
> Yes, loadability is crucial for operational flexibility in practical
> production environments.  Beyond some obvious advantages, I would like
> to highlight a key scenario: system administrators can load the prdm
> module upon detecting memory pressure and unload it immediately after
> reclamation is complete, thereby eliminating any overhead during normal
> operation.

I agree always having prdm in kernel is an overhead.  But, I think the
overhead is not meaningfully big.  Also, as I mentioned above, my intended use
cases of DAMON modules is for cases that willing to simply always use the
modules.  If runtime controls are essential, I think using DAMON sysfs
interface or DAMON user-space tool is a better choice.

Someone might argue DAMON sysfs interface is unnecessarily big compared to
prdm.  But, I have to ask again in the case.  Does the overhead really
meaningfully big for a real world use case?

> Furthermore, it supports zero-downtime updates, meaning that
> improvements targeting prdm can be deployed via a simple module reload,
> avoiding costly system reboots.

So I'm not really convinced at needs of prdm module at the moment.  But I agree
your above point is a good example advantage of loadable modules.  Also there
were private requests to support loadable DAMON modules.  No one among those
were for real production use case, and I understand you are also doing this
work for imaginable use cases, not your real products.  Please correct me if
I'm wrong.  But as the request is repeated, if you willing to convert existing
DAMON modules to support loadable modules build and expose required DAMON
functions for that, at least I wouldn't oppose.

> 
> Finally, I would like to add that designing prdm with an extremely
> simple workflow -- load the module, set the target PIDs, and enable the
> switch -- will contribute to the promotion of DAMON, allowing a broader
> user base to benefit from the DAMON system.

That workflow is definitely much easier than directly using DAMON sysfs
interface.  But, for the reason we have DAMON user-space tool.  Using it, the
workflow can also be as simple as prdm, like below.

   # damo start $TARGET_PID --damos_action pageout --damos_access_rate 0% 0% --damos_age 2m max


Thanks,
SJ

[...]

