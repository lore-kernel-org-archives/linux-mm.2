Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6807606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 07:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=qd7P/w0W
Received: by kanga.kvack.org (Postfix)
	id C35C06B05B2; Sun, 22 Nov 2026 02:08:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE68A6B05B3; Sun, 22 Nov 2026 02:08:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFCAC6B05B4; Sun, 22 Nov 2026 02:08:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8CA7F6B05B2
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:08:19 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E6651160657
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:08:18 +0000 (UTC)
X-FDA: 85461876276.27.DED3CC4
Received: from mta0.migadu.com (out-103.mta0.migadu.com [91.218.175.103])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4E01C1C0004
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:08:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="qd7P/w0W";
	spf=pass (imf18.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.103 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795331297;
	b=TX2HJ5asRoLwiS8yF9yDYyFboiW81ycXo9dPYHYqhVJLfmIhQGc7JM+IdFNjB4GH3znoSm
	mBiU3fiN4y7k70KOSXVoJWj7v9tzmtmfIYTyN/ZWHGMYZkZapKlV0S2gZJjL7GLjHtxPj3
	kwWYLC2v+wQlJgANaSYWC+Jlped8v9E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795331297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fpVPbeFMltrY5ZOohyFH/1X6RQS2degmMqVdNbfmucw=;
	b=6eGW3a7LffAQU2kqb0sgMWKlQOSUvnYKXP6Q+Z61pA/CNWDwcdnieC3oQ80d9w4TBMzhDx
	zm5IWeoKxh6Syk40amVtFei5ipqN3qCbxFEtwdKZhiXxvKrQ5PFpFzqcf+c/ByFZkVbEbp
	Y5rxg05csvuDGFMubHz5F4qM35Hi6q8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="qd7P/w0W";
	spf=pass (imf18.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.103 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4aLff9bBf+2cChSkzEnmwM9IlWonQJ2YgakFBBad1qc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795331290; v=1; x=1795936090;
 b=qd7P/w0WaHeuRUTwmP2qeoqkF+rWM7LaWRV8M79yeWh4SIEaQrBwzyCzulaat+uHOMVTGJkD
 ortCJExsp3wH6cfLIfB80+UMMWjWPQdAx3xusnzVFGfb3KMra8L/NHzsYE9FyEQMDVLbMm/zeud
 A3Pu20dOGiF8cSL8qKuFTUP8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b8ffee67358adb4e;
	Sun, 22 Nov 2026 07:08:10 +0000
X-Mizu-Trace-ID: b8ffee67358adb4e
X-Migadu-Flow: FLOW_OUT
Message-ID: <bf367035-ee89-4489-b268-631120ac1143@linux.dev>
Date: Sun, 22 Nov 2026 15:08:06 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/list_lru: fix potential infinite loop on xa node
 allocation failure
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Kairui Song <kasong@tencent.com>,
 linux-mm@kvack.org, stable@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
References: <20261122031143.3639941-1-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261122031143.3639941-1-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 4E01C1C0004
X-Stat-Signature: 7ig7oh49xc77gazd4qnef5z1aewbdoxa
X-Rspam-User:
X-HE-Tag: 1795331295-197884
X-HE-Meta: U2FsdGVkX18lU7n7ZuvFaCyb6z31LXfUsWCp4trdb0y3FlJDK4CF3rvQvCiuUCTy71uImDMHuTqw61RkNrozuP4ZMZ4wVSY0W8mqFXymvcpbIG0EqRlsC8MvwA1WCu8+oGfS13ObY4XjaLZmOsMvI0kwFf0ViU2GeyFEaSLoJ9PHQcxxqH8Nzl492WVMRfpoOHVE2LBtl8f60I0f+Tk7i6CrFBb5BKUDyKKEKgsBWZm10Cv4af591GZ3yJ9SL97JfZIZ4dFiQix5Aa8idPSMNZ3ggyoYuhjovJTqOvX9TQM5E7iMFDZSSBAOLv16SZMW0BSOenVLl+MooK4PJr4V20yBjsqIXntTedtyQiLBX1ViYTDZoyw/vgIzrakogugrs2yimYyNHp+avfVLFmCFa/MRNua8WeKS2cx+5LUOkx2YEq68Nq1fzXWh+Yau1gH4scQZcUeuRRi4qBgQkC8lqpWBcklSAly39Vw47jU6mL0m86kx0QRlBDE1JRO+JGsvOVDgsFq2YbKmLbtPicwRoIoCiDHW4RXvDonvDboMZumuTUM0HBaeFp2uujvp5nkKJ0neY1qu5num964hv64qVNd8TcFuA8Si00k7FpbL9MJUNNA+I6KSwnUaX+7SmBQw/bp19BZxO5xgMEKQG22X2LXQrad8nUuvUZfiLpdTOLszFmAPriSCAIZpON+nfEdeTUyraGcA+kjgbWegILFqefFpyfn66L0VY/sONU8Mo8bNOQ8Yu2WuIyNdJyXSoIzl4NIr32YeeDA1g2N2gW/Y2OfWarFslCQ1GS9zjrIT79MOCoCQsH17hrz64vUOEoLnLjg1KueO3cqhELeU5jsfyO+u0+YtsIHMsIeNxdWgwnrT/eTv/79vQEU9cCpTWB/ynY2QdRgbTyLYezL3/e26MxXCui/FoTEPIM+oe89UUQnVZAB79XZlsLbR/sl8Mk0eEREWogIP4byPkD+PVVB
 oMIsMOzS
 voAbpDbjK6nkegXRizP2OlgL4geLetMB079oYIEdX8kyqp50kQwPuIHx2J4nczp6v7aVFIR1bQPW/HvQ/WSHEwIZ8YS1JTxqX0gkBNhoDlZb5kk/xH+XQRvF3LESJ364mZ1qzEGIWyBlZLTMzLKucPrqka6Ji4byHRPg2Tfx8WNYodbbgP0W08sSzS6eu2R33RZh+U15sFci/6YXyhKTUQ8IzYxdncg7MzxRcmjunymLn1GOyafRht2FReuVcySNMlROIw+LISg6V7mJarS97zo7Ooc6Rs7bwS1cRFaD6j428tl8xVsodfztmXdyrIoTWfBCAYVh1Gdl6WN5SUWbLM1DQmdzTliGWIEUVnHfvZHCb0cP7zekRFSgscMFvyb/RWgL4UgpWiRGhwIsOAx33Px9OCVeIPSk+FbU1KnUso3biV+AGUpNDFd6xD64+FJlLDagXgax3SVq8pNRbrtDhNfIKp5JpIl9iHn220leaSm73fbAvG8CrVxMz3pcwrterriLIdoQ2ATQS1XouqfelDdaBwsVSr5kEE7uAML7da2DyLDjIJeOHH5PauhQeU6qpJ41KYOWaRZNGjB8Vy50ZLpfSPmzN8/XapLcsT7pPni/9OQlp7udeBXTcdgm++rdx/3B0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/22/26 11:11 AM, Muchun Song wrote:
> __memcg_list_lru_alloc() populates missing list_lru_memcg entries
> top-down, from the farthest unpopulated ancestor down to @memcg.  When
> storing the entry for an ancestor (pos != memcg) needs a new xa_node,
> xas_store() sets XA_ERROR(-ENOMEM) and leaves @pos unpopulated.  If the
> following xas_nomem() also fails to allocate, the inner loop exits with
> the error still set, but the outer loop ignores it and reruns on the same
> unpopulated ancestor: xas_set() then resets the state to XAS_RESTART and
> retries the store.  A one-off failure is recovered on that retry, but as
> long as the allocation keeps failing, e.g. under sustained memory
> pressure, the loop makes no progress and, with no schedule point, becomes
> an RCU stall / hard lockup when the caller holds mapping->i_pages.xa_lock
> with IRQs disabled.
> 
> Stop the outer walk when xas_error() is set so the existing cleanup frees
> @mlru and the error is propagated to the caller.
> 
> Fixes: 28e98022b31e ("mm/list_lru: simplify reparenting and initial allocation")
> Cc: stable@vger.kernel.org
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/bug/linux-21c1dba9-8d6f-4368-b38b-9a57cacb056f
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>   mm/list_lru.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi



