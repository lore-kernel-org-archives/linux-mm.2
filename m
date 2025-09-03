Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4949ACA1007
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 01:31:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71CC18E0018; Tue,  2 Sep 2025 21:31:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C6198E0001; Tue,  2 Sep 2025 21:31:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B4AC8E0018; Tue,  2 Sep 2025 21:31:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 488368E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 21:31:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E12C616045B
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 01:31:06 +0000 (UTC)
X-FDA: 83846210532.30.615B6E3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5B4BCC0006
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 01:31:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ph0ZExWO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756863065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XI2iubCmcs7ueWi8ob3uwcWZAwJRoVi0RP+o2ePR/fU=;
	b=rZWxotwtTpsayWOBIvQEx9oJcmK7O27Uk3wiGc3flKfCrOUk7iC7qZLZBBJ4bdL+roM8Rh
	FzpAwXrGYKCIuZeCdQJ1Iz3q7J2NzrBvCS+rKQ9zDA78eKbobjATk5DLcKL1H+awp4tVUp
	c+6OcszKb6cSKSSJNzTXQccdqElK45w=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ph0ZExWO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756863065; a=rsa-sha256;
	cv=none;
	b=K7+cDYVI0H47kO3REWpbcH+ZJBDfMv2D8uRJEqtf/cLb/NzWH/RlAcvR2rzEfB3AA8/Ldr
	IKx5E8BP4c/13W8ICt6CoguwIpCLE1ZW2LFpsXN203/Vg+K58gaa8axly0iFh2OGQuUQbJ
	AOEjn3HPC3m3jJ/o4ThGU8HNnbIrU4k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6076360223;
	Wed,  3 Sep 2025 01:31:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58D8C4CEED;
	Wed,  3 Sep 2025 01:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756863064;
	bh=kqYf/4DtmRggyCL5vvRGSjcy7p5hV4/sZ1rl1iXDH6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ph0ZExWOTBSSmdRfB4nmMhQhpcprkugPz/3bDYGAsmJlDy/PRZCLfFe4VWhx8UcxK
	 GvxTS2gTgHt8ho4jjnQBpzPHuy8cKx+bXFnjPwq2x/KVW4W8VleFoKZZVbpOJDeYmZ
	 X02vYw4zs7CnPVub1abgfNYQFzxZ21DKLEVxtzXqwVyu2ridEC87Zi8fKV5PdqicZM
	 WUK/GQH+5IW6Z7ZCIVBoiG1t5Vu//ll0qvnjvGgcTac4EumsDOGn8MWGTdUfQKzXjH
	 lrceChUUKZhRSYVUXIYGQ3VRp6Z93MZweRgm7Jb0Zvysbzuxy3hjs3gOqUcc9ZY+TA
	 uxjPGStPBlnnw==
From: SeongJae Park <sj@kernel.org>
To: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com
Subject: Re: [PATCH v2] mm: show_mem: show number of zspages in show_free_areas
Date: Tue,  2 Sep 2025 18:31:00 -0700
Message-Id: <20250903013100.190488-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250902-show_mem_zspages-v2-1-545daaa8b410@igalia.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5B4BCC0006
X-Stat-Signature: hob8ojoqi9k3b4agmx6zaabmu7nbf617
X-Rspam-User: 
X-HE-Tag: 1756863065-158479
X-HE-Meta: U2FsdGVkX19+BXAJg8G7qQYECCneipH5DKn9p4wZfAP4RyR/cyCw7oD9BQ+yU0qCc4z4eNRQqYbA7cb0KbuDKMvgCDFRgcZ10BYmRNyCr9UfJZLGdMyjIOtSfdQuylvfYnG2dYNBijpIuVN03FDDNEC0dMN5XFPfiB8VvXWofVJTojQlNqk/EDdm7fDKaSB09wawcjyp2D6J/5XEZSF1WUWce3hLyAksXQkTMuZ1vqP5U8BPz99UCIAo8OeMYU6Cq5J+xCjnwdz0ZUQOIAzgHnBiP7CebR94Jf0lsi0C3mTVse/A/bg10IAJZg6Fbr5MP329kvv2bUJ8Zc4qvNoDaQ8w4RgZdXcfodbwb0/CdkDCjaUerHf0tmIvYRcXMdncvcLsqbj/b+a/LPcKgH3MoFmNimDBeUEUXUqm62K9EDAObquIJPoAqxDdWnF0v22ipgOOfx5XNkCrlkTLEYlwQPQqeP1er3KgE/+31CJgyiuVJKmOMWcZJAqE9tpMaMRh09IMzT5MAP8u6T6kXONsaSLWmVY/MI7qAMlOgzQi6AuqsVyWpWCu6lF7DkBxaY7E27t5aE65zO4WbDFLodO1MapyROR19YUFhvIu6FePcTLGJoju1WA74lTT56Ch47NWZSo/rsCUFqe4lrKdkAaVM5YNJFIp9iTHxWgLVgI7dOZ43fK49H8ddnlZ0bKid+BiPEyM63iAD99cqv968MchemSVSmmsV0yjvjoqCA0CkbIDZkrJQ3LRHDLjhLtU5ptPuYE51AuMs62pnBuYSDUfyES9U+oMfiToaGo9yuQJMVRkGj9qHS7iwREchM7WzmSK4TNTmpucxqJHKzA7+WJMqKM6NARnKkC1mgH7cXvrG2Is6ams4YQxdXDe/4m70o825Qfvp/XCZGuxlL0rasoMa7j8F9EBr7Llu2WeEXL4yM6LXeYknYjiTFoa+/wHhgH6lIn1FzRxNY+0o+IhX9x
 s4GxbTYK
 +RkcVKIw/wgLGQFbVrIWBBui7cqxuhFxqGG/VY+vTNm01/cy56sLpXVoqU5Fh4T+HxZvTxiCmb6xMLQwrGemlcJBKzgGcI8Z93YiFF3S317xlBwJmxILQvf/aIwI4jEzkSWdqIf0kWF9Lh1QB812WhUX24+Q1NGWzh9xBlwtSUFTuCiErRYJVgQpp75MhAiF5ZAr9hZHXgRw1DbEFod+k7pj2tgrESyTkn0hLa1kVewFdqwBbgdTu1C1ke3tEWKxZswtsThZNrsve6pAehXfX5vSOzyI7i/Cwo+p1h4JdqhK/hC+i5Cse62BYSW9lv9yP8UHKttJiyqQ/fCczKObVg8cxkQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  2 Sep 2025 09:49:21 -0300 Thadeu Lima de Souza Cascardo <cascardo@igalia.com> wrote:

> When OOM is triggered, it will show where the pages might be for each zone.
> When using zram or zswap, it might look like lots of pages are missing.
> After this patch, zspages are shown as below.
> 
> [   48.792859] Node 0 DMA free:2812kB boost:0kB min:60kB low:72kB high:84kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB zspages:11160kB present:15992kB managed:15360kB mlocked:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
> [   48.792962] lowmem_reserve[]: 0 956 956 956 956
> [   48.792988] Node 0 DMA32 free:3512kB boost:0kB min:3912kB low:4888kB high:5864kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inactive_anon:28kB active_file:8kB inactive_file:16kB unevictable:0kB writepending:0kB zspages:916780kB present:1032064kB managed:978944kB mlocked:0kB bounce:0kB free_pcp:500kB local_pcp:248kB free_cma:0kB
> [   48.793118] lowmem_reserve[]: 0 0 0 0 0
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

