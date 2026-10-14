Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5772CC6B2A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 23:09:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 516B66B008C; Wed, 14 Oct 2026 19:09:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C78D6B0092; Wed, 14 Oct 2026 19:09:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B67F6B0095; Wed, 14 Oct 2026 19:09:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1456A6B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 19:09:15 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 925ACA85A7
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 23:09:14 +0000 (UTC)
X-FDA: 85322774628.03.7D4443E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id C1ADE1C0005
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 23:09:12 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wPW2HHY0;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792019352;
	b=zd3W+TKez2NWgvMY+Yl+KNCDlPl52p5phgKcVAemesHSx372Jqu/TJ6ivm7/tTe0D8l9Jq
	FLyUio4DEy/iC3bLcBeUdjuByKUFDI/47KeVlBTHm1p3S60E2HukmtSyW62VAIKZB1SK8K
	CybtrY9/s1NQVjF/KTER86DRD02TUcQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wPW2HHY0;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792019352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cbmYsA9KrEptMrJ4TWH3Zu5hn3Aq4CSH6awCQPo0RqY=;
	b=OdV7mTMmmZVq2/zNf/qTnfTChA+cDg3RdoIxSAtUTZbDvM3GfIMV5289/j2LuXK+qN3V38
	cYIzL1S76ej1JWMAaSlqL0hX+iqGSsQXYQGlAjQEcckTyLb8d8pEQ3JwuzFhSGIacEvP0I
	raI7WB1KGPts1QuJYW33I5R1h4KkZWY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A2FD540B30;
	Wed, 14 Oct 2026 23:09:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 102F51F000C4;
	Wed, 14 Oct 2026 23:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792019351;
	bh=cbmYsA9KrEptMrJ4TWH3Zu5hn3Aq4CSH6awCQPo0RqY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=wPW2HHY0GoMweDWZnBFXZJZVavcyDJP8YNyVymfc6W5aZU6VEOoxj7GOJN1L0eH8R
	 MauY1JmmqzvI6WJX6rEfJ1ip5JGLPov29C9a8jqeAVE2ZDC6ChTa17LNRWZbO0qf1Z
	 HRtYpL0p47CIJRiu/CFRK6CFRJsPcrtd1knpcaTk=
Date: Wed, 14 Oct 2026 16:09:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, Shakeel
 Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, Axel
 Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei
 Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, David
 Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hui Zhu
 <zhuhui@kylinos.cn>
Subject: Re: [PATCH v6 0/2] mm/vmscan: fix NR_ISOLATED accounting and
 throttle MGLRU eviction
Message-Id: <20261014160910.eeaa24697b614d1b94806d0d@linux-foundation.org>
In-Reply-To: <cover.1791968227.git.zhuhui@kylinos.cn>
References: <cover.1791968227.git.zhuhui@kylinos.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C1ADE1C0005
X-Stat-Signature: k1amzzud5oo8dre9njzkp6ggqkj6cpy4
X-HE-Tag: 1792019352-205346
X-HE-Meta: U2FsdGVkX1/QXSlEnCJSNDzs6abjWdGgL6rxZP3D8H8mx9pddjAlcjKx7pv+Z7bcAMPEp7dt8RWNqio1EYpDRlwsYlcIO8DJfy8ZoI67QSb9vbhW3hLoQaQ3S3mfGOFg9wkiOknZbSGVRCPcxVt5HmF/8LzT6a2MyUxZtbFjtjd+tXXTXD7nt7bFEiUzQG2JFDM3FmoTxk9zBxdtFpkUv155cYXn9ca9BILwYjwQKHot8SspMv7YrnXBoNuxHcwZgdM1IA98uaEXy21xnx2fFkGwqDvs4G2Zt5qoierCQeaBcgU837hoWK0K/+jNIUJYz6fCWqavBIDZoZw4uLBVwvQrfqLB23IBgh8Hd8/YPVP1i+wI79ZvpSjSVcJ7rnJwJh50C5NC30d3yBdsLrAjECXAOIP5p1pkrgMsqINlF661ZYUqUG7J2B4tUe/m3W//4naVybpMjwOYRzHB8I5sq4zdmqeEsw/ENF/BylHN526rnis+D2uqtWSadKmVz/sBYEJAhsJAZpWUihiaiYAp3fJ2rxtV/JWcociZWXLV0JSmbhIvU+VXiQqKvL8yYtYvG7eLVnCxwyTxte/vjExXtbTmqZDy9kNswNHtWhpxOCKwn9nG+K/DneETunj+cuzK43UEj+zMa1TFLzXXkV6SZkBLiEcwnJ70dXxBJbL2G3bChVLdzjK+Y3X14vawVxfUfcRTmeMF3ovGC1Z/FvS/e0BmT0PzD26of0jXbU3Vo0MZb0s5iGWnrXbb+fP94v1k/IJlShRdjqFC71Qb3qg2tQboxLfRa7mZQ246Pg4rbG0ChBPTn+oqBlZgQRmTctvSRfXI/BTIa9ynrj+XlX3pG6iXTIloMj+URaPtfA8BOBZibl0y2/1/ZJ3V8F2vXXAok7oz8VCuc/fjYmZUk3z8b7Y/9oaZl//pHC6vMxvz005byK4i0pftGga2LfJNN+k4VPmOd2uyo7O0TsfxFII
 MdKB3CEE
 jlQIX5Dm5Gi75Kt2d+M2SRGn5sIFW8dh/AbbVfBtXXDXv8D94DYi9nu0V6ePrOKgGLhL0Og8b03RvTJtLOkVCXB6b7l98vEq4fq/YK5XnM04bF+zS7nASmb0ayE4QeijoCpWnIrr4l4bFR2ZNyT88VymHq1auIZAjBwltE7eMmoah1S8a7Rf59TBh+dghLQ9WFlKwyZx+ZDp3c3qI3sKGd3Y1y519pm9Jf7D/hcsWpNvbzXvH1nAZ7w2uF2Hfc1nb9LzNNeFTy9xaSRb0UuSRYVmMNZ+c+dZN6Feu1JuZRfVUTRqfuRK57XSe0ZvasBQqUciulq4J7/+iNy1QcNQ8b0lrARVHjeuOX0MZ0valNuvDQO4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Oct 2026 17:00:22 +0800 Hui Zhu <hui.zhu@linux.dev> wrote:

> The legacy reclaim path has two mechanisms around isolated folios that
> MGLRU lacks:
> 
> 1. NR_ISOLATED_ANON/FILE counters are updated when folios are isolated
>    from the inactive lists. Compaction's too_many_isolated() relies on
>    them to decide when to back off. The MGLRU reclaim path never
>    updates them, so compaction cannot see MGLRU's in-flight isolation.
> 
> 2. shrink_inactive_list() throttles direct reclaim via
>    too_many_isolated() when isolated folios pile up. MGLRU's
>    evict_folios() isolates folios without any such check, so many
>    concurrent reclaimers can over-isolate the same (oldest) generation,
>    leading to unnecessary swapping, thrashing and premature memcg OOM.
> 
> Patch 1 fixes the counter accounting in the MGLRU isolation path.
> Patch 2 adds a per-lruvec throttle, mirroring the legacy behavior but
> adapted to MGLRU's per-lruvec contention and its dynamic type
> selection/fallback.

Thanks.  Questions for yourself and maintainers:

[1/2] is nice and simple and reviewed.  How about I queue this for
second week of the upcoming merge window?

[2/2] is much more code, isn't reviewed and has a Sashiko whine[*].  So
I'm thinking this is 7.4-rcX material.


[*] https://sashiko.dev/#/patchset/cover.1791968227.git.zhuhui@kylinos.cn



