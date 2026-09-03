Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43271C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 17:55:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C4576B0099; Thu,  3 Sep 2026 13:55:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39C146B009B; Thu,  3 Sep 2026 13:55:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D9016B009D; Thu,  3 Sep 2026 13:55:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0BEE16B0099
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:55:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 87C301205B5
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 17:55:39 +0000 (UTC)
X-FDA: 85173203598.11.BAB14E6
Received: from mta1.migadu.com (out-204.mta1.migadu.com [95.215.58.204])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9BE1320003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 17:55:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BBlpvUw2;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.204 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788458137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QkNzWEo56VBHDStwWahj9S/A8ClJcWL595xG7UbC43I=;
	b=18XoV++HsjoWT9mYVOr8XJsM509dAg+t0pP7miHv7sDucyPamyNT6lp9yOAwZvMaTVFrDx
	5DFaKCC51+X+QCUKljvLg7MnL7cuyUGpLwY8EfOHxmilKz6CHOCyIl6SSfETYCY8V10Wi+
	cUntmhkMJtRLZ6ZvPu5Yt4B655InLaY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788458137;
	b=vZQS6hULH/0hXMyFCRDox4onmyxG3lEu0IbIfkpzQ1wMRmwRiHSvnWuP+PU6HuYOKcYIpJ
	RK/3duQg0XCe3VR9V1czJMVIqH4JZI5jgV6cGjd+zqBWiW+EtOPrWKNvuKAYH+k6A+bq3s
	AVtnSo9ObmjJ+Ij+ek+h72TkJevsvGE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BBlpvUw2;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.204 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=3cWqPp22IraIGu0JvB3xQlMqoKb4a/YFuTmuVC27eeM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788458136; v=1; x=1789062936;
 b=BBlpvUw2RgIZusVVoCMvSFjY8j+K2JhYbj2ZiLegxvSijKM+7Yrxs7T65SJop68DOXNd7sF1
 xabXaJ/UkbONF6THFkJXWzm1d8OlTVBXTVaaksqChOvPoPU0CEifrGd/U/8/Landsnq+1p9Lb70
 3rfXu1uEvFld/ci6ifFeHRns=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 82f448d9f30fec5e;
	Thu, 03 Sep 2026 17:55:33 +0000
X-Mizu-Trace-ID: 82f448d9f30fec5e
X-Migadu-Flow: FLOW_OUT
Date: Thu, 3 Sep 2026 10:55:31 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hui Zhu <zhuhui@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] mm: workingset: use lruvec_page_state_local() to
 count lru pages
Message-ID: <apm0b7mioZwXWE1Z@linux.dev>
References: <cover.1788169145.git.zhuhui@kylinos.cn>
 <e16dc5e411c1c5d95c4c4db6ffc789756362b867.1788169145.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e16dc5e411c1c5d95c4c4db6ffc789756362b867.1788169145.git.zhuhui@kylinos.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9BE1320003
X-Stat-Signature: qni7nd35ro6z4h11jw9894omrx84ch7z
X-HE-Tag: 1788458137-614724
X-HE-Meta: U2FsdGVkX18Q02+3MqDcD8byohy609iC/Qv/avH6masFzn7tVUclPBZdYAqClpAbjktyAbRUJRThHz4HQoUkrR5uRbh5OUwgVplKi29dWG0t0IrF/vpN/BqMqHZKlh6NGdM62c0xlV79/JvjOvdECpxq7Mt72vThk9nugUclasgYoyBoI9I4nKv67qLGNJpOcMFRzNT0vmiLwin/KgJZaKZE/9LFKV6JI4tFV/Omde6m9iCx3Iz1Hs6X+lqL88i3+fztiIqX67pZBPabgnid6p/cUitisePGA2mq4WijKFq2E0DCVwXAPjtyTzMzV86wIvWABW5dxoTauEJ83npvmbMZGZl7jatykgLTk7iib0XWvaO+q2Se5Nh+JUwgz9yYkk5b1s+YvHzGMEDGTk3XJ0KZfOm98N1xFdudMJcWYXipEkY3IIRAzblWj/LS7GL+qt3uDs1tX8NxuRC2ZOfFlnL5hYHknOznPWkg9v/Jp7XTRRUeLNp7FMyfEHqjsan7s+gKVXzWPgA6zogweGnOoHqHoV/rK/Wj60wq+ZPZq741WJHY5qmrbw/VTug2YFCdfFu3gQwVucMjdf7WJzvg3/Mxz59OJZQG39LdivSgVziQwKAumOb/TO0s65+nF6dM4uEsSxK2AUO5xOn958u9pty+kv6tzNLK32DqNGWlg/noc/ggaOZGq+UteErTexheLiKsY2HLKl/RdNRgoYBrOQ0U9TowcxZl+zEE4CwC4Jha/SDRIGMYs8MdkZu40cwoNN26xI9U7MQWjSjfwCHTiFrwRc2lcTj/gLu/CWdRsZBKJhS05CYodnhfdKrvjxL7CD8IFKcykJnLXouFdXtsh+KXrOqeVone4jl4BRxQtw+A4MTAwsLy30KRjha/qZcYv8XMgq+OuxT6H7qOdET3zzUS7nVjJagjQQnJ3wQQN0WybNXZ8vcKgGL/pSDU+2fCzO00c51OkNKe1NNYM8Q
 5b48PYq4
 TEKmN5NazqJiv7MntJCQJGmQ8ACXqtbY3oUjtjFaEHyVfOQa3AZY7CG/IdLwETLGpqUssTpVlAx5pnCGUuyJWeQuruhKg7FjDSt105KZm973O0g6dDt0ug7VIVN251tgrqwKFKIpIp0HGcKddT2t4Gsw7JwnetFuMxIQUmH8j6W+Z0dqnTqj+1w7rtpAmtMxewBx+Yx9YecElGnC+bCckaak35UPNnCpVo6Ed+9ggiUXuNmfkcVQbJXlIUGvLzvNxhtUyQpAraG2c1Hzsfg4rtYteKP+xzNR6/sSf1atgO3+Glh5kCyTvRPyE/rqn0/4IsDncL8LiTRE9r1Gyn1hj58yTaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 05:46:09PM +0800, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> Commit 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the
> number of lru pages") switched count_shadow_nodes() to lruvec_lru_size().
> With CONFIG_MEMCG enabled, lruvec_lru_size() reads mz->lru_zone_size,
> which only the classic LRU paths maintain.  MGLRU accounts its pages
> through __update_lru_size(), which skips that array, so with MGLRU on the
> four evictable LRU lists are always seen as empty.  The shadow node budget
> (pages >> 3) then collapses to slab plus unevictable pages, and the
> workingset shadow shrinker reclaims eviction tokens almost as fast as they
> are created, losing thrashing protection.
> 
> lruvec_page_state_local() reads lruvec_stats->state_local instead, which
> both classic LRU and MGLRU maintain.  Switch back to it.  The reparenting
> race this re-exposes on cgroup v2 is closed by the follow-up patch that
> redirects dying-memcg stat updates for all hierarchies.
> 
> Fixes: 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the number of lru pages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>

Reorder this after 2nd and with that

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


