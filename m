Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 150F5C44533
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 05:48:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07C326B00DE; Wed, 22 Jul 2026 01:48:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02C706B00DF; Wed, 22 Jul 2026 01:48:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E84AB6B00E0; Wed, 22 Jul 2026 01:48:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C61756B00DE
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 01:48:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4F5AF160371
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 05:48:27 +0000 (UTC)
X-FDA: 85015332654.24.0F953DA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 408E540004
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 05:48:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jX4VlVwl;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784699305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1S9JD7JtPYeIJLVINN/0y7QJwd6VS7i5IUqqAPByz4M=;
	b=D4ojFj9funCjcjAB8GKDd9WDgdnoFGKv/uCxwJXHCGfm/E/eAaC4nHSSsDeIDyFqk/umVT
	zNIbiXuFJEUkP6RUsNlzGxRsO1tFuGdlXYZjShp7gyAKm8eGfMsVMwup2iEEiIy4Sv8JSQ
	NMp41ICN5ntX3JMvrz5Hwe5TGPmJ2sg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784699305;
	b=lpe1hj1xpeRlqJ5771rEMCnEgPlvai6MzJuWR22/EJAxS1rOkUlWJOovix87dQps3KyZ0T
	C08yCyAUGxUuEuBkT7Jf79bEwLng/091xR8Bq+qK0gPkAy7qW8+ABWiaWDbrcngxRp4hu9
	McyZcpVVxpCeIKzonT8prrZr0lJ0cJM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jX4VlVwl;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 00C961595;
	Tue, 21 Jul 2026 22:48:20 -0700 (PDT)
Received: from [10.164.19.44] (unknown [10.164.19.44])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 79F383F66F;
	Tue, 21 Jul 2026 22:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784699304; bh=uuScNhPjiBHrt/gYpKP8cSsm20R1SEdWS+CAB7ZKWZ0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jX4VlVwlJYchtykzWqygqSFJTy82MBKeE6A7CogVBz3+8u/HKwi+5xt/7itTlr4h4
	 XoI7kHVSloRvXK7Rk+DpUSGj7RBDpiNoIwOsW9V0d6AfjoCNSpzSttZ4JdJK8Mnm/r
	 bvNWID8sF+Xfj4F0+cEJhCeD6FBx7oOL2FbDf8xQ=
Message-ID: <dc402537-1527-4433-839e-960b6eb32bc4@arm.com>
Date: Wed, 22 Jul 2026 11:18:18 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] mm/mprotect: shared-dirty base-page toggle slower
 since v6.17
To: Chengfeng Lin <chengfenglin@stu.xmu.edu.cn>,
 Pedro Falcato <pfalcato@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org
Cc: "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 linux-kernel@vger.kernel.org, regressions@lists.linux.dev
References: <7c9eeb21.1c04f.19efaacbb2f.Coremail.chengfenglin@stu.xmu.edu.cn>
 <433d619a.1e8a6.19f1d4d1be6.Coremail.chengfenglin@stu.xmu.edu.cn>
 <6c8d9b6c.24a8b.19f84afccdd.Coremail.chengfenglin@stu.xmu.edu.cn>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <6c8d9b6c.24a8b.19f84afccdd.Coremail.chengfenglin@stu.xmu.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 408E540004
X-Stat-Signature: ag5uj34ejrse84e1u8q1x9z6czn4zhum
X-Rspam-User: 
X-HE-Tag: 1784699305-395638
X-HE-Meta: U2FsdGVkX1+m5kxiyvNHGEp7URB8enoCkKgWKR2HCX+sG8kUjQqX61leOyTobJARuNvT5SylCLa44jQKDkSEa9u7Ll3efl9YfAEC7xvs2NEaUiq8r2NSuS0CjJKJ8DcUzYoOvU+OcFbgPeqh9z2ZyAx5O7v5iKKTuGXcByWO3M7yMvUFHuywB4STJXWHLuB3mUDpPpS5aHlbHF7o4uL2X7o5HE3ZmVwpn+eIulyNp6IMhqd6JdBZFRV0oMxwg7T7oRGp6W8eyYWXzfSTqdhVMdjwQ5RH4huxTokI3KBLraL1zLW5RTE3ulBqAw1QjJZlXEqvBJD/AuxzRnlXESKlnok8EwULZvNbsQmqjpUq13eeK3/7Qlb6+TEXDPhoHRkBHATvMtiJ6evR9gMFO5gLp4s395dC47h3qIcJd9nuXf/ErvACFLeDLHPpVRjxVjRtVNg2g3TGPv3qg9LQ6cen+C7/6M22hq5FgJwXsNS7SXRbYQmQOgzSFpNyQASZDpUHJkasgi09jHc3xUe70sSqavtvhOyRyDA272JKmUL4UzGYlUTiutvCWEB964/CpEwgTWhIPdpQKVGmQd08F8BIsnso4G3IKmkRqSKx8G9zc4wuhzcNTO3MVulRC8PX7dNb01DlG8kObSo0BSjUY7qJNUu/MnVy0g4UtU45urNXjarGus1E/ZCABAWRcFQ/KyhOvVuPMQpUgwTLhOD5ZUkn3efykT76aHZEDVH5CO8lY8AAhig2ipH5b3ZAZZg9j/av3DG4QO89KwhoKsjcWTAibG7B6mIPHRDzW/FvcTJij1/FWb5p1K6yckMX7TRZb8dk53z71kgVKd43GSXy56qq7qv1fRwYgeGjKLZvee4+WsafmcdrpIy0zxHSmwwytyekrxY++WS8BaXuTMOCXNCYjKG93BrnYthcnHsnmyDYPiv81nKuQdFXGgH37bLO+ygiDi5PGUSFb7/VQrLNJuj
 DG9ke/Su
 bCjY/+w2ke1wINU+yRtAY1ADe6r7eO6QpSXuVeOjZbLOE+fH2rH/ALBRrtLWm2vt/zG/i8rVN2xifWgdTMqoNHP2INnvBJ0HCw5kr3TeWBzlqWsn6wuUt011m/KcND9Ow+Mye6LwVorAztpFxU3kj87p8sOntWg/245Ivqf+TxaW6H7gAiaIjMYJ7HDQrK87mkTcEI3A9FL20PhDOps5MIL+sjjA+luxSkDzmVRsCXghqs8Ez+OwGkX9KzVG19Gy/yTwI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 21/07/26 6:09 pm, Chengfeng Lin wrote:
> Hi,
> 
> Just a gentle ping, with results from an exact commit-level check.
> 
> I tested cac1db8c3aad ("mm: optimize mprotect() by PTE batching")
> against its direct parent 45199f715b74. Each point used a fresh boot:
> 
>   45199f715b74 parent A -> cac1db8c3aad child ->
>   45199f715b74 parent B
> 
> I used the same narrow 64 MiB shared-dirty 4 KiB base-page toggle
> workload from the report. Each point had 3 warm-up processes and
> 15 measured processes. Each measured process ran 1,000 iterations.
> The primary result, iteration_ns_per_page (lower is better), was:
> 
>   point       mean ns/page    SD
>   parent A          38.133  0.743
>   child             53.533  0.516
>   parent B          38.467  0.640
> 
> The parent midpoint was 38.300 ns/page. The child was 39.77% slower,
> while parent B differed from parent A by only 0.87%. Dropping the first
> measured process from every point left a 39.53% child delta.
> 
> All 45 measured processes passed the semantic checks and used 4 KiB
> pages with no THP. The protect and restore components each increased
> from 13 ns/page in the parent controls to 20 ns/page in the child.
> The post-touch component stayed close to 12 ns/page.
> 
> The exact commit changes only mm/mprotect.c. Both kernels were built from
> the exact commits with the same normalized config, GCC 15.2.0, and Kbuild
> metadata. Every point used the same CPU settings and runtime preempt=none.
> 
> For this narrow workload, the exact parent/child result identifies
> cac1db8c3aad as the source of the measured slowdown. I am not claiming
> a generic mprotect() or application-level regression.
> 
> Evidence:
> 
>   https://github.com/lcf0399/linux-regression-evidence/tree/a3ae7bf1a50e4d88b572c6005a037679530c9b1f/mprotect-shared-dirty-toggle/bare-metal/20260721-cac1db8c3aad-exact-ab
> 
> #regzbot introduced: cac1db8c3aad97d6ffb56ced8868d6cbbbd2bfbe
> 
> If useful, I can still collect a perf profile of the child around
> change_pte_range().
> 

Sorry it is difficult for me to parse your report. So I didn't understand whether
Pedro's patches helped you or not?


> Thanks,
> Chengfeng


