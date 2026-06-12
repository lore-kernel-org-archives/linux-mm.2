Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B45DCD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 04:00:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB8656B00B3; Fri, 12 Jun 2026 00:00:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8F9D6B00B5; Fri, 12 Jun 2026 00:00:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCD196B00B6; Fri, 12 Jun 2026 00:00:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB7B36B00B3
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:00:34 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 84E131404F3
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:00:34 +0000 (UTC)
X-FDA: 84869908788.12.1EA456B
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf01.hostedemail.com (Postfix) with ESMTP id AE9F740012
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:00:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G5EcDdQp;
	spf=pass (imf01.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781236833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kb9XhzHn/hQKeTGOyjGfHnMrWyxQdJZuAbxjI5R5xbo=;
	b=DBvmkI9sfZY9wwWIuFLZCfgFAyYTGpL83lvMfSnsqA1Udua0CbFb3HKr+q7prcoCwyEqcJ
	FG7XnAZRTIyBy7958voQ2LaU7Pn50xQDWXNlkiRfplu5hNvRwKjyj26r2WNfgFyiAAfF+8
	ylhNFawY87UeOjBrc71xBPQzbqe3+EQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781236833;
	b=QRMnTHdsrQcV+V9S7pRwSuVtvp22bYtLwVgqvDY8c53Aacv++MM9KQ7/C2LTpuh0/cG6yK
	Y/1hI7YFY3LFThKBO+I5AmXIgwRLL+yD7YY8hp0eP+IYRuvT6atdhT3JywtdzovX8IDeOU
	evmAUZU6cFKrezkvL04tMdsTEGucz6k=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G5EcDdQp;
	spf=pass (imf01.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781236830;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Kb9XhzHn/hQKeTGOyjGfHnMrWyxQdJZuAbxjI5R5xbo=;
	b=G5EcDdQpHo2eHjWBTqxZMmRBT/I9pw3ptbS2GYZEoYTNAWQ0Ke/jktVzTYdCrIR7U34HR8
	XyQmjwvUdpJiCuRK1yO8YElKSgXnzACGMW3lCEN37Wm8+vZow58TLloRZsQv6AztvdLkLa
	FHar+0HFVajewrsqhstI0C1m6FxM6m4=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Dave Chinner
 <david@fromorbit.com>,  Muchun Song <muchun.song@linux.dev>,  Qi Zheng
 <qi.zheng@linux.dev>,  Meta kernel team <kernel-team@meta.com>,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,  Zenghui Yu
 <zenghui.yu@linux.dev>,  Nhat Pham <nphamcs@gmail.com>
Subject: Re: [PATCH] mm/shrinker: do not hold RCU lock in
 shrinker_debugfs_count_show()
In-Reply-To: <20260610232048.62930-1-shakeel.butt@linux.dev> (Shakeel Butt's
	message of "Wed, 10 Jun 2026 16:20:48 -0700")
References: <20260610232048.62930-1-shakeel.butt@linux.dev>
Date: Thu, 11 Jun 2026 21:00:24 -0700
Message-ID: <87cxxwz9uv.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AE9F740012
X-Stat-Signature: gayq9m6htjuhr5da4mtbhfwn9xxxo1kp
X-HE-Tag: 1781236832-169768
X-HE-Meta: U2FsdGVkX19cCw/jAXklSUGkBdvjOAjMzu6Tgfe/iimIOa7n/E3fseYCTIBy8hB5RxHZXMPG8f2DJsvT8k7sBPi/SjN4aittRnT9ClDeAEO2le8VtgqVjt9kEFehv7qbRCJrwL5ksAigjA/smHjWibyRVhI89W3GK10uiGCocvArcwat7GH/8W5gd2p1GEVhUIJalp4nid22/IoQUfeiPKaUCxsEqQEvuCo4/gjF2sHowdF1YZWYaEdEtthSH7D93lmMWOTDQWRVnu33Oo5nSHDuatYUglJRQIGdrysTCdfDBRY1QQyIBAx4krVcY/p7KNwn2cnOwX0vrIn0e0Hh3CVq4H1BcTTlIxkIrSqElValbZem5UoCYv97kPDQb4PRy2XUV0s6X+An2GV7NfetGQT1nmyphDfpBi2hiXajZ3xepsZX5fboVJsO2ODdRkmTD8F12V+42+xqGb59SBqb4/4WjtVEQ0KsnUFYJcJ0YfmMMzUKyBGFrRRFnPdr6kaWJLQ5O2OrToSDnl4xt2dYKGpVuoFOUBygpkxh2MYGkmWicGhxchngNCOK63685y/e8HfQ5mwrsAGONI/RHPEE1019cTIv+jqi9fpwcjHfLD1JSNNCRMFENvgemPOxUUPHSwUJbSjiYW42GjcF5gwhxacmY9MJpeRM03M+UBFrEve55PEKR2Jo8WCahtLk0XQhfYa7GX060dOSiwWIic3pHTEqXNzuFlL/6QL6wZAwYSJ2Tl3Mqyowf7zJlxuPLCvFxemxuOGhIFE1U+Y9Ig2uUEWHiBKPAohDA9V7NTnoTh+uyLufZusXlkuU/YpvP+msJOulNd3RrG8eiXmkx3M9iWAsJz3WmWJodPx86TVtmzbRDRtXWOlfZcPRn7Gs/4U39ZMYJtXhKnyeNHJliZxZV9SCtHZnfxcOjR4JcATXBrJJj4jxw1iFQvqX2bDUtN8wQ9xAZDqVQw6HJHr06jY
 j7OX7B4V
 nWBJPUxjnJW9MDeX2A/ToNJvXZ56bEP8DSW7xGLlDFzzF1phpfjbpnOnzXmu2+8tDAIQwtRGkbtqiZTCssKoSkjYUNZRoBU87hxKE4zwcbIpVySqdrMNbDfwVtyX6r1zds6OjkEWM2weyy94YdhVObVBGwjWBtdC07y53KH49d9TokU3Of/+vder1iYdPN6CJuQO5e1kQFLoc2KMakE6ylrsSTplewpDPlShTNyahsHeKyIJSEvzvSezw1vuXoZgwIdMPCAitWa+370agd36CaGsyWG7tDgP3vZ3fVb5i3c0Z2/M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shakeel Butt <shakeel.butt@linux.dev> writes:

> Reading the debugfs "count" file of a memcg-aware shrinker can sleep
> inside an RCU read-side critical section:
>
>   BUG: sleeping function called from invalid context at kernel/cgroup/rstat.c:421
>   RCU nest depth: 1, expected: 0
>    css_rstat_flush
>    mem_cgroup_flush_stats
>    zswap_shrinker_count
>    shrinker_debugfs_count_show
>
> shrinker_debugfs_count_show() invokes the ->count_objects() callback
> under rcu_read_lock(). The zswap callback flushes memcg stats via
> css_rstat_flush(), which may sleep, so it must not run under RCU.
>
> The RCU lock is not needed here. mem_cgroup_iter() takes RCU internally
> and returns a memcg holding a css reference (dropped on the next
> iteration or by mem_cgroup_iter_break()), so the memcg stays alive
> without it. The shrinker is kept alive by the open debugfs file:
> shrinker_free() removes the debugfs entries via
> debugfs_remove_recursive(), which waits for in-flight readers to drain,
> before call_rcu(..., shrinker_free_rcu_cb). The sibling "scan" handler
> already invokes the sleeping ->scan_objects() callback with no RCU
> section.
>
> Drop the rcu_read_lock()/rcu_read_unlock().
>
> Fixes: 5035ebc644ae ("mm: shrinkers: introduce debugfs interface for memory shrinkers")
> Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
> Closes: https://lore.kernel.org/all/c052a064-cddb-494f-a0d8-f8a10b4b1c4d@linux.dev/
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>


