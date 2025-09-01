Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04766CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 19:59:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C3DD8E0006; Mon,  1 Sep 2025 15:59:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49B668E0001; Mon,  1 Sep 2025 15:59:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B0AF8E0006; Mon,  1 Sep 2025 15:59:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2D4728E0001
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:59:22 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BD9CEBC4A2
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 19:59:21 +0000 (UTC)
X-FDA: 83841745722.14.81CA61D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 19CB820005
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 19:59:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="N2nZhoK/";
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756756760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zqOhLbrcIqzuhpABpgctrJgRyjHn/kFRl9Zasvn2ISI=;
	b=IN+pJ808LjhKAzE8UAb8V80G8FIFG7Jg4sAPxIf7h4FoUZRbaTNugQZm/t8UPcF4X5rBBG
	Pt4gWfB98CrZhzzYjUsOzqL0uai7NvcSkgJw22Twe2IJ8vI75KaJUNQ14SjULo9n4tHOZA
	T0HC+KhOsEXeonPydWYkfR2epQ/60CA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="N2nZhoK/";
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756756760; a=rsa-sha256;
	cv=none;
	b=8few8ll4GG43L38gBRchS39PKdfIJlfwxok9RhVJafaTpyeOB5+yAJvZTcNBTVr+IReUiL
	VoVIRNT4lHWtDvdhhYfumTMOHA06EWpL9DGlBIvnYiF59m6XfPsil6E3s+P5AhJtsCWkRX
	zcWIcXOTUxQTNus2sUhoGhWw8ZCoSsA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 35164601ED;
	Mon,  1 Sep 2025 19:59:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A35C4CEF0;
	Mon,  1 Sep 2025 19:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756756758;
	bh=C4TZGfosvdpMdKEeuKbEg3eDbne8rkSeMAqsXA1tYqk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=N2nZhoK/Q21LIbrSnildvG4xpGY+k68+D5kfaDcIxkTjgeF3IUDsP7xsKzTzMKStp
	 GHMPTe3JVyTaKevz1ZPsATz3LZevBNmkcINf5YYDPMuSccRpOz243d4StJy5RGtIeb
	 xP0OlHp/akySD5KbATJbrZ5IaVKH9SRieMRW8uBg=
Date: Mon, 1 Sep 2025 12:59:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ruan Shiyang <ruansy.fnst@fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, lkp@intel.com,
 ying.huang@linux.alibaba.com, y-goto@fujitsu.com, mingo@redhat.com,
 peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org,
 dietmar.eggemann@arm.com, rostedt@goodmis.org, mgorman@suse.de,
 vschneid@redhat.com, Li Zhijian <lizhijian@fujitsu.com>, Vlastimil Babka
 <vbabka@suse.cz>, Ben Segall <bsegall@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3] mm: memory-tiering: fix PGPROMOTE_CANDIDATE counting
Message-Id: <20250901125917.e9792e5d0df12ba1c552c537@linux-foundation.org>
In-Reply-To: <20250901090122.124262-1-ruansy.fnst@fujitsu.com>
References: <20250729035101.1601407-1-ruansy.fnst@fujitsu.com>
	<20250901090122.124262-1-ruansy.fnst@fujitsu.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 19CB820005
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 8fbr1zm9erfgqexezeg6hh7q46qnuarx
X-HE-Tag: 1756756759-680994
X-HE-Meta: U2FsdGVkX1+Ika3bVw3PWM89MUlM+dmWi0UtEYSW1IaVRr2ckdyxKO3vN4k4G5UBQcU6cV5hq9tFiVxFjb8WZdZ57+lI2buBQx560hIqHHCbIpDiT6DjNRPWKjLpQq4BwOQ89fLJuScWEI/bIxkJQ5q0R27jTNOSarcuKBXlkmJbtUTHJ1CNbbYDZVYD30lIKp9oU/035j/sCNyZiGAUpn0qtu3tXxfJVP8ZAzwrNTPjT4fYz98BMAPYD8PBHNMrWZG1Hjxh8AiSGGh8/EKCV0douxZm/TFtX1ToAXfV0QXyRw5bU92u5hKXh8MwoWKvD5TiXv9DpO5bFng2ZNkX+o093us1c/xnPXia3Vh7u/BYc02eQUnA+h/ts1inbEXVja0PJ7mMmiuZqDh5AvTFUtYxPiPTh0qNIXyFjjhLEnVeXoyZh5M0vwFRjoe9TiAsELKDYtlraDiXt6vrqJgFQaej47P4UWVWUdEg15FCUHq73YFbVT/46q/tvWVAj7ph7Qs/VyoQwOF97xl4kmW6KeHjq7Du2O8dunR6s/nwpGHmRfhqRIL1gF2QhAH87yBo3nyQ6GGp1vdR/LLWJsyD06pHlALSeaikzPHdp8Wfdeytgg9Dyv/28fZ7XtxkySu9hhJ2spFHmRImGH7IBkunrWKNYEZ7R6O8+i/LX7lhW5X2c6Is+emApqKhv/kNOHSuxN37MWV4XGxty5QuPUZC7DC7jHhd0UeQot+pEmC5YFocqOntDY85UzUMrXxsQ8DOGgHlhHwvIq9h1U9Xvaa9Zagb9s1xZbutfaJFawyjJpXa849aQg1vNdLLZ/olTlurv3/FkcYXawGV5iCWT7F8vtZ+ODZQmoqBbphUda3AQBLd/o+E1nL4E0VVgkrx8gAeRoydwKKGkernTT8WI4w8ipT7SGLHXcGDHpA3NzPOZ3V3OpQT9ZaEP76zVMo3kjKN9lEred/7D0tSrsY8Hes
 qMMbV3Ax
 41z5tK8bVpidlMXxLoeBp9eKukhcquS3RFYD/h5lBQzmf8nCyhcFw+3N+FhjY+qt7rpf1WbY+3y9E12Fwk4EsdT2Zr3+J5XnwOi/p/RGRaUo/EcESc+zC1ms2H0I7vMgNWlCE2feSXodNwjEq5pRbXzY81XPBgJyFQ9yQwemo8agtDzILSdqHXqihvXYykmEa2qxLOsAJE09Fy5MGlmTfK0HhYfx05Z/AmTidml5CwgJaVDF2dHmH9LAtAjW2yNld574mlvp3lbsb8hCmyD/GhU+FzgpXyig0JvyN85qpk8vw1FC72DK97hOxLwaSDoEATC1C
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  1 Sep 2025 17:01:22 +0800 Ruan Shiyang <ruansy.fnst@fujitsu.com> wrote:

> Goto-san reported confusing pgpromote statistics where the
> pgpromote_success count significantly exceeded pgpromote_candidate.
> 
> On a system with three nodes (nodes 0-1: DRAM 4GB, node 2: NVDIMM 4GB):
>  # Enable demotion only
>  echo 1 > /sys/kernel/mm/numa/demotion_enabled
>  numactl -m 0-1 memhog -r200 3500M >/dev/null &
>  pid=$!
>  sleep 2
>  numactl memhog -r100 2500M >/dev/null &
>  sleep 10
>  kill -9 $pid # terminate the 1st memhog
>  # Enable promotion
>  echo 2 > /proc/sys/kernel/numa_balancing
> 
> After a few seconds, we observeed `pgpromote_candidate < pgpromote_success`
> $ grep -e pgpromote /proc/vmstat
> pgpromote_success 2579
> pgpromote_candidate 0
> 
> In this scenario, after terminating the first memhog, the conditions for
> pgdat_free_space_enough() are quickly met, and triggers promotion.
> However, these migrated pages are only counted for in PGPROMOTE_SUCCESS,
> not in PGPROMOTE_CANDIDATE.
> 
> To solve these confusing statistics, introduce PGPROMOTE_CANDIDATE_NRL to
> count the missed promotion pages.  And also, not counting these pages into
> PGPROMOTE_CANDIDATE is to avoid changing the existing algorithm or
> performance of the promotion rate limit.
> 
> ...
>

It would be good to have a Fixes: here, to tell people how far back to
backport it.

Could be either c6833e10008f or c959924b0dc5 afaict.  I'll go with
c6833e10008f, OK?


