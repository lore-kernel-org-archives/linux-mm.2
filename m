Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC970606A326
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 08:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=o2RDp/6v
Received: by kanga.kvack.org (Postfix)
	id E61646B0626; Tue, 24 Nov 2026 03:07:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E38D46B0627; Tue, 24 Nov 2026 03:07:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4D886B0628; Tue, 24 Nov 2026 03:07:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B10EF6B0626
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:07:22 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4F084160A96
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:07:22 +0000 (UTC)
X-FDA: 85469282724.27.947395B
Received: from mta0.migadu.com (out-25.mta0.migadu.com [91.218.175.25])
	by imf02.hostedemail.com (Postfix) with ESMTP id DE4688000C
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:07:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="o2RDp/6v";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.25 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795507640;
	b=PVLmJwWXvR1mehd4mCGSWQX29eZBynvGPIiFhiRZWBqGTHI9MnHirpFL9OkxaIwWIi7zsl
	bQFWG3uDlBkhACI/kvKc272xvauzTc3sr3cl4VyZhoFmlxmCssxDWObjneN9IWFF5648iR
	a5MRClMDSCefthsJY2Cc95+oiu6o+Uk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795507640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=67vHNWv5XydQCuOWzXnOZHfUdZ5hbczxGbSf1cnDCr4=;
	b=nmXGb8BNRg+Vws3Sf/TDW/auVGrbRLNiyRuOmTZtQm//bEmZ3lpmiwIHkQS0wMPgLnQXL+
	tBbnZ3sQ52sKTNm2UP/75xwt7eQ/4SB/VevU4B6P0T5SfwYJuGXbVghRon5Gnh8v2S5Qkp
	wkLYvVozwvs6ngOeCWp8V+Z7QY0vVG8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="o2RDp/6v";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.25 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=cXjzmosgBA+4GsZx1vbHqYGDv5GQy8T2isKKaaoWxSA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795507636; v=1; x=1796112436;
 b=o2RDp/6vMg9dCJBd5K2vR8eLitzzwzQsZDVVPHNmFoYF2Lfb/nrlf0VUI0ykkQ0WngAdDoRG
 8Rk+UxvIJpJJFYUl9aT2M4DYvVIifQBY/hdVB4zDZuO3jTen+ugwVpl0I5+D0m2T+swd7IbAjCI
 EHDWmnIJjgR6fYcBtwcgQzhE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e41294f2a3451cd8;
	Tue, 24 Nov 2026 08:07:16 +0000
X-Mizu-Trace-ID: e41294f2a3451cd8
X-Migadu-Flow: FLOW_OUT
Date: Tue, 24 Nov 2026 00:07:11 -0800
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Runli <mingyu.he@shopee.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry@kernel.org>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, littleswimmingwhale@gmail.com
Subject: Re: [PATCH v3] mm/bpf: Always flush memcg stats when explicitly
 requested
Message-ID: <20261124080629.GA564737@shakeel.butt@linux.dev>
References: <20261112041348.66915-1-mingyu.he@shopee.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112041348.66915-1-mingyu.he@shopee.com>
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: nwp9m13i91w3ksyixdas1th5muuzb78h
X-Rspamd-Queue-Id: DE4688000C
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,MSGID_MULTIPLE_AT,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795507639-187165
X-HE-Meta: U2FsdGVkX1+CdbCNeQH6URxm4eZdtBomG79MsDCy4z9sF4ikpkpTqE0kJZhntGnJE1Zo4IhQb4F+jRjSyrG+l3SiMuDKJ8mXITUjB8xLtSojDzld23VprCHKeN4JJqP9YROOjYQDNHQo5wJOWMoOR1+zbM827ZM9TPTuib6AIpr+ZWsQvMpT1oHWtnFaBybkdrlxhOSfqvNGLJxQ0Yt0xKlBr2Gm/TZzuVS7Ib1YOiQHmUy4+08QvNHUel9tLv2t6RIXpJVAa3jQdh6/BzHmZ9U+85rzpb9xs33w9ljQox+fdXeHcZV2zbCeklMm1oMs0cqKptlN84PLM5oKo8p4lEqFAr0k+byzOvrZ95d7PgEN0gPXSyrWC0tzcycW+DyxkxuESU7G9dQz3C0EBStisrGdCL4szHy4ZGJ5mc4e17OJdDl0R+ezA2cWn5lzWTzPV/SK7Q786liPbbItGjfNuLTxW0Mt5fqFMsC0B7GWDdY3miTeBUwmvRmPuaqDSdBuQkjiAjLxqKIUT8pn4tFMLOfulewM4r5DMHW2nSjxwzWsnG0TgA5ZgLOm9BZRy2y1IOKrONqV8S0VUp3A96MOAFHdh1LAbPJ08gLY7eHo/vh12K+W5FjCOZABWk2XS2f3dKQy879iTbXWA2xFSabohVPjxyS7mZ4WPWob0D73oWu9zdzSxt35lhpSLRIgsPeTErHbGf+LHtjLGY2YGjGHtSNNbTfFYbEhI/Agfz9//GNb6nGfmb0v3Nn0mWV4F0BZfAENrLVem4JaPHOOfXCRkq5QJsWeYfM3BYqkB2LxxZmnq6duYcVurU2uqk0erolhNiW7BvRPX3GKWPi2OWly4B4xXFVpnUBW5N6IZmdRMfg7fg16UviF3HtHLpjWr3mpSYPeh3/b9WksSdkVXxojWtnaWpQHSluiL0q7sMLgJGOz/1Ux5F5SX+aaIILHuW6+KZ4bEc0OTrPK1W8kaPg
 DDhO9Ozf
 5EWI8VnyyjiaaEihdEl6pn7Rsm7GIf3vFd1MpLoVDwegbBGHqb4biOGrwn7zNxVqoQx7GmIdMcTVJ8sPCZBRBKvQ01ytcn2c7Gvh8djyhwxCkCUDWs7rg/TRpnqA8o+ax1UizyXJ26E1r2jmBvMhvy39jBPahc9rQHnv//ohWdHS0Eoo+R7vjBG0N6df5i1kfVgcxeUzrbrtGOMRDuRKJX7QaN8OMlhpGmLQ7nn0bUkJOwmHHY++IhkGDh9/EPFF/NiAi+XKPcjyQH0s40udd5Y+nGFNrHgLWXemnSIQ+fvEjEgnXWi6556ASekE2hIO2P46uBrVo9WqIwpZ3VAKSEPojgDV9tUXiYoM6s2nwB/Sc+UaTy0Wlm480ZRnj+ERTIQRYO3qQ9bSReMV2br95koE/SVPPm7S16x18zXmFdndVBsymCUGImz7AbscTO6+nLp2ODfNcOvA481snsI+LFPZZVggWKKz7/h07tl2x27K8zaSF51kcED+/6LhkqpPvtGS43vzlDr/1SMlJ8SeU9DZ62u/BWKY55ihdMctr9pQKtPMft4hhUetKFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 12:13:48PM +0800, Runli wrote:
> memcg_rstat_updated() stops walking the ancestors when a memcg exceeds
> the flush threshold. A concurrent flush can leave an ancestor below the
> threshold, so the early exit prevents it from receiving further updates.
> 
> Consider root and leaf on a 4-CPU system, with a threshold of 256.
> CPU 0 is flushing another CPU's stats after CPU 1's stats have already
> been flushed. The counts below are shared stats_updates counters:
> 
>   CPU 0 (root flush)                CPU 1 (leaf updates)
>   ------------------               --------------------
>   clear leaf->stats_updates
>                                    add 64 to leaf and root
>   clear root->stats_updates
>   finish flush
>                                    leaf = 64, root = 0
>                                    4 more batches of 64:
>                                      leaf = 320, root = 256
>                                    next update:
>                                      leaf > threshold
>                                      break; root is not updated
> 
> Root remains at the threshold, which is insufficient to trigger a flush,
> while further leaf updates keep taking the early exit. The periodic
> forced flush restores progress, but until then the root's aggregated
> statistics can fall far behind. For example, page cache grows at rate of
> 1 GiB/s, a two-second wait can leave the reported usage about 2 GiB below
> the actual usage.
> 
> Make bpf_mem_cgroup_flush_stats() force a flush without waiting for the
> periodic flusher, while preserving the memcg flush bookkeeping.
> 
> Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
> Link: https://lore.kernel.org/all/avKy9oMwDRjKjfzm@linux.dev/
> Signed-off-by: Runli <mingyu.he@shopee.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

