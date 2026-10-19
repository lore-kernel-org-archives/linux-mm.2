Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0399C606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 20:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=lwftIVxS
Received: by kanga.kvack.org (Postfix)
	id E24346B00FA; Mon, 19 Oct 2026 16:13:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD51B6B036B; Mon, 19 Oct 2026 16:13:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC58C6B036C; Mon, 19 Oct 2026 16:13:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A33516B00FA
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:13:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1D76C120830
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:13:30 +0000 (UTC)
X-FDA: 85340475780.30.DDFA577
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0673914000B
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:13:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=lwftIVxS;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792440808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=33VILW/iOz2Ho7n7DFsaPmdMpjSfqsU0e30Nc2GjpZ0=;
	b=Ufy4VvOLSc5gjjjuSf2Ja1oksSwMz0TQU3p9J9MJ/aN+FbG8xw256o675qhXfAPyB8lwbL
	56TlxpIWpA85kVOVYnY01X0m2JpT62NTjyiJUWm+rJhvGsQCXGpBwZUDtHwaUQ4CsNx3Jo
	4pnJVD0esFDND5gsVpDD3Sl3+gMAdaQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=lwftIVxS;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792440808;
	b=14/IRCtjr25KxcIh8P57D3dAitLYh3cVnwIQsVerCVNJ+oexIzRrqRWkUIpqyc7lMmRj1s
	glRJdjMo7Lh2xuOrRZVkEMzeC9rzjheShcnavDKvXllDDTtEDbu1/VMkm0u8cf7+GHHUyd
	g3KXYMxZFxB2yTcw+mBC/myGqfKsyd8=
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-8b0c5a64de8so512847b3.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1792440807; x=1793045607; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=33VILW/iOz2Ho7n7DFsaPmdMpjSfqsU0e30Nc2GjpZ0=;
        b=lwftIVxSNniglSp2qZtPaSLlcIYq1Xvu19nbxuMqUJ+qADMWtMa9wOAlQXLagZ0Adi
         IhGhlwzU/7bn1xHz+XtHvTTexPRV5itESDbfF7nFLbKJ3bJ/M6vI1TTbWOmtIpDV6jNA
         I/iO2cSi+G2HeBzi31QxIG5a9d2XHm2kSSeQc0QBcq2QrZyufUUNpRuERGa5K9gnfaQR
         w2/a1DQsuq02gLIvt5cZHuuVCTDhGTAqQ+PMcAhSM0/JtS57Zvf7YTeGESb3g5EOw89f
         SrgxZ2rCWf2nOK9pz7RnuaXaCTKQGpwg2xomLCpSaUFwXoDxeM0PTOL0hxsKzuHeyoA8
         Hujw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792440807; x=1793045607;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=33VILW/iOz2Ho7n7DFsaPmdMpjSfqsU0e30Nc2GjpZ0=;
        b=NR/ypnJunCHSRwFAUtSX8HaU92tfVTWo1lj6XHLISVub5GUp4Ys5lAHRs88s163hNe
         QTFu7gDtPZjTMeVI8uWT0GY9S3DE+dEHWf05LA25sxib3wQXdzc3yZjPnf+QCD/BnqjE
         cHDs3pQC3QgyH1m0Is1yM5tMMB5Eg55jzUZX/rTy8RbZIIrf2bp++uNkOY4m4kL/jzQX
         lQqjI5lNccdIxxprdK/4Uogfyj5FVoSEcnAfvPA51u/CaEPNGBsY0d3qMOjDk/IVLdxY
         kxJx220KYRqDWnEETqdUKK7PRWBeNhULDdxcGboaOqbCV4gnw99ybwqdgQZuv0F7PH13
         9B0g==
X-Gm-Message-State: AFq9FYJxVXRlEgChCd4Zi8NJfBbgSGKnSp2XLtPaA6Bdh6xnfrrm0n5B
	ZvRN5lz1K+k9nVqzVRgJ+ehFFVNmQfqOLDZsvm7kHFzAC4wG2HrtmOQTtN4Pe9sVHwc=
X-Gm-Gg: AYBFou2tbcCDPpqQFdyM+HmIvEAp038o/MJvXm1uEOoL5Zu66oPOr2PiiSMxhyZktQ3
	vlzqBt/IbUTvzehp2510deDh7hH99plwbIRfsZypY/5nJvv4ba1hTFU4lGJJkmMXJajd5AQWoHR
	+LfWZsZx4Mwb/yEMV7sEHaGlA4Za0CHAOYwqHGbvA1WYcAq7t1L/FjBloBgbD0xQmLe6S+5mmcU
	gv2tp98QBOQE7D3cYno1dwGGde/fle/+aoIacphoHaj5TSsAAKt4HR61QGw2ncmlFcwDZ7awEFs
	mFRweXUBdIbid7/q2UupeCyCjkaqunxaeC+fT0LSp2jlf14wYtWmckWAYaiq8hdpScxN+x4aCWS
	tcC4KMF6xM64Ddi+U/dG10r3HZ191OYzJayMEQZb1w9LpiEkdzYPF0ZCiy2dNJtEJ+MyYT7FI7n
	3htfxZFFobYZ/F7n1gXPGFVs0M7d1NJ0x52j2ekuAYSHKGmk23wJGHjeUdOe4AT/MQ/Ncp0w==
X-Received: by 2002:a05:690c:4992:b0:8ac:e48c:4f97 with SMTP id 00721157ae682-8b1201bff9emr666537b3.24.1792440806814;
        Mon, 19 Oct 2026 13:13:26 -0700 (PDT)
Received: from localhost ([2605:8600:200:1d58:2ffc:79a5:7374:fa95])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b11b8117ebsm4601537b3.16.2026.10.19.13.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 13:13:25 -0700 (PDT)
Date: Mon, 19 Oct 2026 22:13:21 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, brendan.jackman@linux.dev, ziy@nvidia.com,
	flyinrm@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: let the highest memory node recover from
 hopeless state
Message-ID: <20261019201321.GJ371161@cmpxchg.org>
References: <20261019184850.3427905-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019184850.3427905-1-gourry@gourry.net>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0673914000B
X-Stat-Signature: d39bdgshoay8pcpdoma685p9zdy1dzwq
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792440807-363820
X-HE-Meta: U2FsdGVkX19TZSH6e8QBJtAYnGSCHXnlAUxj2pQDMiMIHS+Xt2H7HRWLlkU9dPfC/igSkGYMUWhkke/PPTJk5Y1JTCK0t2NnIau8GyjEYkYngWTX6L10sYkj6pUeNm0ZDGESer0X+hoTmJftAj7pJLyHPONtjgk0fb8z6qgkloSrrHtmkWifBdMJon2LCJMIn3OTYch/xfVRrgmIi0rZMBhixunONBGNYA8UglmLcJU0lT7pIL45+fBm2mr4e2au635NQsMsmR/QKRAAk0fTmwBGrYr6mTrILomIl0f8RHugBkwSZJPkvSYKD4VBkZ3agIfDJ6gGihVjKGW/9SqL+s6pOyKa9nftsRiMoO5ELPQMcFzlZEuO4DkHg2qQNDwjw7OaaVaDyV7kZZ4xQSlses1zs2CkmEXGgRrWxofwjQKDCMi5LCAMGmReKxSVNEyIZRRkuHa4UrXtPcuWo9d314823om1uWgE0tibEy99H7kCoZMhO/5syMzeebrsGrOLh5idBTXDhz9/p9FGpLQepv0e4VNzNZEkN4+S2c28aVC+PczM1sKvQqP6KuC+KkMotgJBh+3aDqHCilO0so8asWmWUUpTk6EBgw2La/yzYj4ntFvNBtuDWNwM0u0QtxdtgvnKRvY6KcqyCd1l6+U+xYn1uEE8UMZz2PYkoiRzBExD4205U/PymUjrTUOkpis7z2nGAdzNiflbnzirJfqZnhDtd7pgsTQuefKuv8IEEsPeSW8OWn6tv78LqDGiToOGHZZUhh3wMGBIOkRYFtdpSRxVM9j/whxoJUTWeFaq1fH7yFwhJk3M3KCPkUGY8SUWP9G12EEXVx3lWXjA2mo72HQkqc5YPHYrIBasiYYljHbnT7zApSA9CKn2ygW/S6AIGIX6pMJ8RO9QfzT15iMaWn621YohLuWvxewHa0dMOtiRoVvUhSwsMBr6mC5hXYnw3CtQkuchG6ZCei374RG
 Mzlrlc6i
 QNalddRfYsQLg0YmC4t/jzj84Y4XhDnmlSPg/l7bkyK7CFyZbc7lqMZQmRILGtje9rYCKlQTNcNNF6jwyDnvqLeTsmj738F/phzfrM5qPy9nkbF9YZL6BKZOt5I5AS0JNViOMDuPOXqpEYLHcJGz7TkLV438MSIV/54eFPh+tu0ixnAIZ5EwVvy0w9Zvb8GVK1fJNQHPZ586CrxyyNuhoh4gAbGkarhs+0wDlXy9fm29vc6D6P/lhAkFZS48BLokMAiBj/y8LuYDq2f6FLleGHY3u25TjN0XVbQrZGNKS7Z/WqJE2gyZIBuOBJjMq4q8PEu7nPKEZFhGI8QM//gZHFSGp2gR23OA+RkOYmKvvK9zRIz7S+WkErqCcDg6Ne6tnXa/q6qaxi2j0Fvd4VhOyY2YB5ZnLT3Mz/aVnqN877BpVsW9nMdRbBMh5htFaFrmdy2w0u9Y5LcfOEdY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 02:48:50PM -0400, Gregory Price (Meta) wrote:
> free_frozen_page_commit() clears a hopeless node's kswapd failures once
> its zone recovers above the high watermark, but only if another memory
> node exists for allocations to fall back to.
> 
> The test `next_memory_node(nid) < MAX_NUMNODES` finds only memory nodes
> with a higher id. The highest-numbered memory node therefore never
> recovers on this path, and its kswapd stays disabled until reclaim on
> that node makes progress and balances it, or demotion is re-enabled.

This seems to be the express goal in the commit referenced by
Fixes:. Can you explain why this premise was wrong?

The patch in question also only added another re-wake event. It didn't
remove one. How can it be at fault for kswapd getting stuck?

> In many cases, direct reclaim many never fully run against a lower
> node (CXL/kmem), and that means its kswapd can end up full disabled
> in rare situations.
> 
> To reproduce, fill the highest memory node with bound, non-THP anonymous
> memory and no swap until kswapd gives up, then free it: /proc/zoneinfo
> keeps showing node_unreclaimable 1 for that node. A lower node recovers.

> Count the memory nodes instead. Adding first_memory_node != nid to the
> existing test would also work, but a count says directly what the check
> means: some other memory node exists.

I don't understand what "having more than one node in the system"
means for re-igniting kswapd on this one node.

Generally I don't understand what the heck we're trying to do with all
these patches against the hopeless state code. It shouldn't be that
hard, right?? If kswapd on a node failed for whatever reason, let it
sleep until direct reclaim makes forward progress, or other frees
(unmap, etc.) put the node back above the high watermarks (which means
enough of the unreclaimable pages were freed to justify a new wakeup
in the future to attempt reclaim against new pages).

