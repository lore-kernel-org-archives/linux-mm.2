Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4A75CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 10:55:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21DE06B002B; Thu, 27 Nov 2025 05:55:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CFEC6B002C; Thu, 27 Nov 2025 05:55:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10BE06B002D; Thu, 27 Nov 2025 05:55:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F3D786B002B
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 05:55:51 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 662728A8AF
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 10:55:51 +0000 (UTC)
X-FDA: 84156081702.08.FAAF78F
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf25.hostedemail.com (Postfix) with ESMTP id 592CCA000E
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 10:55:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=s14P8P0P;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764240949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iRVmjU/Y9Gn+2pqu0CVyrzRMl+J5d/ZiDNk/GmUSLQY=;
	b=gyjac/yW/rbtP56BvK7DtomoD6rVMSKXtT4ySee591njfEbEQj9cn4GUkftXTabN1PV0vt
	Er7Zej1og1mBKVZLbQJGIfyZ2zaoK5YCjfUgOj1Y1w8Q1b3f9Cye79tyx14QDsyj5fZFMg
	tdX7eawsL4wL9tYGzaal/tEJbbD0sis=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=s14P8P0P;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764240949; a=rsa-sha256;
	cv=none;
	b=t09gxPEYyQYVTEAOv1cuIjW3vsCvd3saS9FVkYOO06qB/8hGnBELIt0NGjM+sn7vocNqNx
	NFXwBNBkUnVbuXn1tZdFUbhzS80Rz5uP+yb4OnFjeuwYjbo/TanQ5AUbblL+ORmERi5tn+
	EFR3EPz8AERXjBDyOWpzJwCZWmDLr58=
Message-ID: <8ce13061-b4a7-4474-9e57-bab9b1a62b63@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764240946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iRVmjU/Y9Gn+2pqu0CVyrzRMl+J5d/ZiDNk/GmUSLQY=;
	b=s14P8P0PJE11i12hs9kRxZwk7rjf9SBW1ODcAc4YQFqTE6LZUBuEpDAR6JPzETINtrrFQ3
	S5YbMm0FgUEPkxoGwgSnRAshddGklYK3rA/KTAjm8rjln78PtplcUINUcZkF16B/wBYgDU
	v6UPh/nTm3GriJ0S3zaMsz3hCNRFJ9E=
Date: Thu, 27 Nov 2025 18:55:37 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 2/3] selftests: cgroup: make test_memcg_sock robust
 against delayed sock stats
To: Guopeng Zhang <zhangguopeng@kylinos.cn>
Cc: shuah@kernel.org, muchun.song@linux.dev, mkoutny@suse.com,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, shakeel.butt@linux.dev,
 linux-kernel@vger.kernel.org, tj@kernel.org, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev,
 Andrew Morton <akpm@linux-foundation.org>
References: <20251124123816.486164-1-zhangguopeng@kylinos.cn>
 <20251124123816.486164-3-zhangguopeng@kylinos.cn>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251124123816.486164-3-zhangguopeng@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 592CCA000E
X-Stat-Signature: fpc338hp1khkm8rdwrrbyzrpfryqwgcx
X-Rspam-User: 
X-HE-Tag: 1764240949-967798
X-HE-Meta: U2FsdGVkX19sXJDIyNvH7gQZxfZD9WjFlHoUogOb7/EMSbBG/PVrhpuPHpHnMapQmuWXEV+5H3KqLK/7QvdICDd2MeyrRCM9zOT1X29qvdU3MZ8SKuGFbqQLmbgcJdr5k9Jmbvb/9dHq5ApQORr2etJ0KWXBIafgLL/FK4uFT1O3QY2TXaFDmMuJJiY9Sff3AxqSUTFRGhlfEaIe5ZavJJqglSsI1C602DWENUY0cGaSMVsqGCfBT7oAsiF9AJHbdXAEAABujKRJmzStOhM5hA6AdCu+JjafM804Z7ilJaQpsyRXqyatTfodTALh5wYnp+RKi57S1XiVdLrvsNZ2UVgXm0O05V+pGK4k8tOT3PMreK0llhxttfeZgt9oxcDbErIiid3diB2MOgjyENeCj5cHv1NlUt0YIrla88tZOcrj89x4kzAIYFEFMxhqn5Mcw+Ofm5Q0cdrL2t8tPFGvMRCDJUEFmsnqm3YJGH6SxwC9oHZSvtpS9hEL2x7KtZ9baTG5Bk0igfpU6Qas8otdiIjUpV984ML96fjTWr/QS6widpQ3gVG1m3C5UxbHd37bOlFOMboTlnK5tdnzYgHedrTB5ENAjupBqTmHt4NY0L2WKJih9YdsDB8hTpgZ2YEOOVE8NqR/lKbBnD0zC4fqS0YbWzE58gKG1joFhJuJOjtSQHAFbicJQTdCzm5IbRXrwQQ56Drm0lAUMEcRn5SRc51S2OP29vtIh5jTkjlbFdz6StFyCHQmro8nngHrxve+StSJdtrE9k+23rnNuT8XS2IM17ku7kmRkheVmi6QD5avPBEjfxpmcQSbKqEdpBZ1DR6e1neturkhpWAd30dm4B2Ri1ukNniMiUiJPLM8R9LCbncLsfaX0JTToi7RE8fuNQt25g+A2UhAXIaRBsDf64JEJ2KAWTT7HaaEKXL1r1UNXdmJWHK/F/Gcv1GGTHSsHR3eRWdgFWuDSlTyPih
 MkF8UPjj
 5/3/XRQ6bj958wT3AQf+mnzWIsRpEJjgmWFkWQIcSMVa6PBiAn0HTRXk4Qsc8nMa3HiWEeTE7kiK0wwn93bKZxLIV2jfMOtAKURfI3gxl1D3C9e6tX1NXmYTWMis41i77bSb7vn0GEytSJKtwGcryzQsSRc9B3gVYARsFs2W03m1jY++MoUZpKs8p3Tpi9aK71lSN7Crk/yyW6G8Oi8LqDn/pJBB5KESB1Ky9HFA2oXKtJv22rIWnCTHv0grKfsLvNfoA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/24 20:38, Guopeng Zhang wrote:
> test_memcg_sock() currently requires that memory.stat's "sock " counter
> is exactly zero immediately after the TCP server exits. On a busy system
> this assumption is too strict:
> 
>    - Socket memory may be freed with a small delay (e.g. RCU callbacks).
>    - memcg statistics are updated asynchronously via the rstat flushing
>      worker, so the "sock " value in memory.stat can stay non-zero for a
>      short period of time even after all socket memory has been uncharged.
> 
> As a result, test_memcg_sock() can intermittently fail even though socket
> memory accounting is working correctly.
> 
> Make the test more robust by polling memory.stat for the "sock "
> counter and allowing it some time to drop to zero instead of checking
> it only once. The timeout is set to 3 seconds to cover the periodic
> rstat flush interval (FLUSH_TIME = 2*HZ by default) plus some
> scheduling slack. If the counter does not become zero within the
> timeout, the test still fails as before.
> 
> On my test system, running test_memcontrol 50 times produced:
> 
>    - Before this patch:  6/50 runs passed.
>    - After this patch:  50/50 runs passed.
> 
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> Suggested-by: Lance Yang <lance.yang@linux.dev>
> ---
>   .../selftests/cgroup/test_memcontrol.c        | 20 ++++++++++++++++++-
>   1 file changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
> index 4e1647568c5b..dda12e5c6457 100644
> --- a/tools/testing/selftests/cgroup/test_memcontrol.c
> +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
> @@ -21,6 +21,8 @@
>   #include "kselftest.h"

This patch fails to apply to mm-new ...

Hmm, it expects #include "kselftest.h" here, but the tree uses
#include "../kselftest.h".

Which is odd, as that line hasn't been touched in years ...

