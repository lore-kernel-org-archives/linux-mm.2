Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5429CC9832F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 03:09:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FDB26B0088; Sun, 27 Sep 2026 23:09:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AB8F6B008A; Sun, 27 Sep 2026 23:09:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C1B46B008C; Sun, 27 Sep 2026 23:09:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 11C9F6B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 23:09:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 884A51C3577
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 03:09:36 +0000 (UTC)
X-FDA: 85261690752.24.CD455F1
Received: from mta1.migadu.com (out-211.mta1.migadu.com [95.215.58.211])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3E5AE1C0002
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 03:09:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tFuFBTPF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.211 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790564974;
	b=d7UQKkWHmoOPwXDJKs2dyuQhZkIAjLNzrNpRZpohOR7F7s0Le3Z3/TkVAFknyPe2l/mjdL
	klOiHMByRdkQJPc81uuTwegNtdvfuya9gHwDAAjEO3q+X+SksJWTBbdfzBiv/H8k/q87e8
	LKYmOz74g/T7tBBHJ0iFMaGS7kquR3g=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tFuFBTPF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.211 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790564974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dF60Hd7PjfkiS+g5nIwvpRQzBnUdsegDx4pdjVSkobs=;
	b=zDi4HzEND4oSGYaiUYxOAcxzOdSQWd9ko+WVii2Z4w4dghc35Hikt5TdcvztpzgUVvKfJ6
	816iQ37cdGCmAGWT6hsqHIDB53kbJHE5b1MLy0AHseaeFDt5uqbuC99jP1lli1IESLL5V9
	dVIesGEI6P3qGrVTuBqvzjT/y9+yrh8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2m+NU9deBab6lT4HoCkvMMoFBLuSQjYvO/0juA/rOEI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790564972; v=1; x=1791169772;
 b=tFuFBTPF96qxlbbzscreEqcfkjw3woBis79wdlBuTOC2LUcf+i00J05QKkx3GQExQbo/zVQF
 mm+DZ4IDEqVFRBMKXwiwKTR8gDvQlwu9JMScF11waOErvP4oKIxwaBTkd5KcxqJmO+u3UYt5N6y
 H0tHy1BheLxiCtR/QJ+Vl6QI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 2350573a62ce507b;
	Mon, 28 Sep 2026 03:09:32 +0000
X-Mizu-Trace-ID: 2350573a62ce507b
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.11\))
Subject: Re: [PATCH v4] mm/hugetlb: fix overbroad MMU notifiers for unshared
 PMDs
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260928024723.87708-1-lizhe.67@bytedance.com>
Date: Mon, 28 Sep 2026 11:09:16 +0800
Cc: akpm@linux-foundation.org,
 david@kernel.org,
 osalvador@suse.de,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 aiqi.i7@bytedance.com
Content-Transfer-Encoding: 7bit
Message-Id: <47EB85CB-D961-4A41-9842-A842C9E620C3@linux.dev>
References: <20260928024723.87708-1-lizhe.67@bytedance.com>
To: Li Zhe <lizhe.67@bytedance.com>
X-Mailer: Apple Mail (2.3901.100.1.1.11)
X-Rspamd-Server: rspam06
X-Stat-Signature: gipckjxq7s6ixtnia9yyc5nm4kd6r8g9
X-Rspam-User: 
X-Rspamd-Queue-Id: 3E5AE1C0002
X-HE-Tag: 1790564974-826469
X-HE-Meta: U2FsdGVkX19TG9J8ImJMFyVE97Pj9/bWFeBLpDnytIMvHvVaPtQoLE34snr2qXdDgENeILe0LNLQxAOFuam1p6npEhpO1iFixjmj6Rw31VLwD9gSgnmWnMiE3iBW1YqEYowfa2lHy+rlRrOB5cqE7jplIH/qtZoKq3gRQvybHMV4cQqmIR8exAPnyjquhbula5NIt8RKW2ms6NVaHy7WdkSidLee4HT2NeV2evlhqUIctN1G9RZavU+TJGmBPw2pBFWa6OfJhiPuJUnI83fPPQO0bYYjUJ0NUHGqWSIz/Fho/870pavS4x51ZF4AZgHJdsFDI6XpYY0Jtt41SnEAKJxWVz1CLPTR7kUWck9KeskMp3LZSvBO37TEGVhgU4nn1jBzzv8Y7uK8dGUeaRjdZNqDbI7H1u/Hk90f/uTCXPgR7eS49nVZUw7BnkbdK5YikLCHsF5wlCXKSYDuUZE98F4pwwL+bl1TCyf14tkRiO8CN1FIkwYbHhz1c9e3GGcnkBHUJ0CVGN3eZzJIyonb0Jt1C7v6ZGJfw46dnyYLW5MaU/RlH5Pmw6AVSm2nA8BRGIGyWnrWkDAeBWllhN37O1W5mLtd0ycLjnK+HBnUbOxoYXdsxeUOD7qQ/3nEZUr0vQNLJpeQegbFCRAJn1O9HofQ8PJdcVcDeiye4TN9xFqMTEEXop0Kj6up8VOS9DYTo/gVntSvR9NNw1LS7m+Q3+O2UqP/odC1URwclLHGYHL3xiryT2b6F59gLpyp1WxNPM2P/FoNCJRDVA6YEyAstW1Z0zL7CXhishpk5WUhShtJL9XdFys52tAJYWPC+hyYJpz3t4+cwRVxwAg12HLnEeoJ/lQ2pLJJbOMI4y0LFqoETCrDcvD9nB8n3esk0FZ/pNB7n+qoYyf7tmfcsxtceh/lawql5KcnnBg/9QYCQJGLWtEAHFibk91ZMugEyrayEjQIcFxAvYW3AA8t9uD
 tEVdB5Ah
 Qq2wuLB9h6ktEarqu2N/DhvFRCzRFTiCMLOua5Qa0yhrp8SkOXVkwcG2rBSV6jXAhyDlmEeDk+cTTovWC9yUhgdNnmdw8upWZLKmVYjfMlQ5eDYfVXlZ2MCZ5UVLjOUzjx6p4CwR5fD5a1IMSWUOkExDszy4hdWJmjiGL9Zs3NSfJF0BUKL8zgd3gxuD5fDsWeiiX1iMg0DP0H47qTHETx29sbJjDRxZyvSadVBDSjtd9naaVjjA0wKAb7W9t7XD+ZgLd7joomP2rg15k5/i02PkqHk0tUzT+/mGYgCiqd6puJ3E/JMEIMGPkT/CKQenLf/jG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 28, 2026, at 10:47, Li Zhe <lizhe.67@bytedance.com> wrote:
> 
> Hugetlb currently expands MMU notifier ranges to PUD boundaries whenever
> PMD sharing is possible. That is only needed when huge_pmd_unshare()
> actually detaches a shared PMD page table, because clearing the PUD
> invalidates the whole PUD-sized virtual address range.
> 
> For hugetlbfs hole punch, and similarly for other hugetlb unmap paths,
> a shared mapping can pass the "PMD sharing is possible" range test in
> adjust_range_if_pmd_sharing_possible() even when the hugetlbfs file does
> not currently have any shared PMD page tables. KVM then receives a 1G
> invalidation for a 2M operation and zaps unrelated secondary mappings,
> so the guest has to fault them back in.
> 
> Avoid this by tracking active PMD-sharing attachments per hugetlbfs
> inode. The count is incremented only after huge_pmd_share() successfully
> installs a shared PMD table, and decremented when __huge_pmd_unshare()
> actually detaches one. Since huge_pmd_share() can run concurrently under
> i_mmap_lock_read(), use a 64-bit atomic counter. A zero count is used to
> skip the conservative notifier range expansion only after excluding
> concurrent PMD sharing with the mapping write lock.
> 
> On a Redis-in-VM workload that punches cold 2M hugetlb pages, this patch
> improves P99 QPS stability while punching pages, reducing the QPS
> degradation ratio from 7.09% to 1.45%.
> 
> Reported-by: aiqi.i7 <aiqi.i7@bytedance.com>
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>

Acked-by: Muchun Song <muchun.song@linux.dev>



