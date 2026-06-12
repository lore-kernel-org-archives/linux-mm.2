Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D904CD98CC
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 03:14:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4A6A6B0005; Thu, 11 Jun 2026 23:14:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD3D26B0088; Thu, 11 Jun 2026 23:14:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9BF36B008C; Thu, 11 Jun 2026 23:14:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A4A156B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 23:14:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 502CE1658EB
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:14:37 +0000 (UTC)
X-FDA: 84869792994.04.618D25E
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id CCC1040003
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:14:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RM5K7Geg;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781234075;
	b=ZVDbptQavAjLR2WTyFnURnFqACiLQzgMFNuq7tiMJ9g3MEWtZPJJkrzxl9pb6qCWWFZRWh
	YPahgtndXy0My+A1sWxcAs7rMfjzPjfDWLYy1s/vZY+9NxPR5hFstt9H4C/0/jgUIAZY1D
	2uT8m/fh+H2b4K5g1qDnAks5XFOhi+4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RM5K7Geg;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781234075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fx4XH+gdmaatynF2HbNiaRzulnURipVC2+u2CSHKWqc=;
	b=KTNkDmlKqTpC0miUAhgikW7AtJ6unrNzjcfjMCafKvUNK/v4rjzgwmHqW8DI8NHxSfxNEr
	lfO88GGrjh6g9vYwjPmHhm/1ay8H8FytzdRduAmWiVonpWS+bFTiciujmn70AgfpQ5k6zW
	py/7p7ZrlcmNW95PbKpkf3dUr2LCxZs=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781234070;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fx4XH+gdmaatynF2HbNiaRzulnURipVC2+u2CSHKWqc=;
	b=RM5K7Gegvr/qYlJsWmxEJwZmeqnLTvH6TNVM1SSVcpxqVAhgshMiZZF4s89zWg2IOdZ1ae
	onpdpWXQpIkdR8ln27AqCH1d7PgUo6hlTtSsjHjjiW/QWDitesOiJvprY7XipcfUJH+kiT
	ehJQGvy9oVQxM1wGnvbMmaD1rnFo5+s=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH] mm/shrinker: do not hold RCU lock in
 shrinker_debugfs_count_show()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260610232048.62930-1-shakeel.butt@linux.dev>
Date: Fri, 12 Jun 2026 11:12:54 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Dave Chinner <david@fromorbit.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>,
 Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Zenghui Yu <zenghui.yu@linux.dev>,
 Nhat Pham <nphamcs@gmail.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <0C56AFF0-61B4-4212-80D9-474D838C9498@linux.dev>
References: <20260610232048.62930-1-shakeel.butt@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: CCC1040003
X-Stat-Signature: ksn9k7199dza4r4juhm7j9xyuj3owmdu
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781234073-556485
X-HE-Meta: U2FsdGVkX1+7RsbAOQxGztCEcPpj0v319q6dNCAToRm9iLEGkqI6kPQOr3Y/UY9G+HKe2w+17a/mlSxn3B/nKYFk9k0DFwuQBl/vb022O07vLBsz/l+UD2Dm4m8e+L2M56oeKu5jFPiSzGwwMJUaEA3bDM+Gk4ZviC5Szm5kwpvzoz8Skxpx3ix2x6YM2Pb3yPqOmsimj3/Ma0y4pkmlSgOTuC28yfcGhpqTQIqXPucRnY4Nqs5pZs8HcujKpqASMRvFC9KQaoVdt/VmUeCvnwWi8jb1lm7ZcafoHaDRybXW2IIip+qVf0Yq2ByNZWhz7zv1Ob31Ff0ioBJsJ3B+Pdk4/51NKK+kqBx4i+mVOPTc8bGyY8OkmkEFy+LRH87OCvC2lMbMF/7jCxew+F4gTJF0laADWn7GtjyjxInScuOTuJ6johGVdhOcdkUxUP+gepxOtuIednPVfp38WfVhJlY5RSXN8NgAOGAwdvcMh5u2g+3SSUsNxPPzAYqXelAzUNlKj3NsAP1shKND6LsmEDNwxM4ZjagA7iPbRShY9rDvmdAAsa1y/bLFMCuTL8+M369wJ9A0sCEEcecqm0tm5MRQWGJL6/wiwnfwpgGYXMfgv6ZAF9lXJPR1zBVVDXLPBstW7z8ym+Avfqc7slYN0YS4ppLA1YJe+jftyoaIGGTRUltgXCyJcOKj69j4vNggR/BjU4sIc5STY4fP/O+JnavtPo/owYYZVTBP+6JWIh9k8f2YrGXd6N+yO+GzPKmsSpeE4SerywhMFWzAmwQ1pVFxbgSuJpuei+r3GkY2XEa82Ryi10AK52zyzNPTihP898ZJW1bzYpiT2OEmhbM/8kdPPnLJIaubmVCIDpz3avewQHrCIlaZ9ay5lTfzvBLCOOua9ZLqXw4ENXtPi/SLHY5s8Ac9ytz617g1npzkjpsjlanuITPJsAAmlS4tbrFSXVGrUJdgSoMJSnKMVwI
 aVU0gKS3
 eROafUTVkCceRCpGc5BqHMOI3o2gucXY3/lFHx5WrTGeZ/BP5hNCmFQkjC9NUg3FTPK5fl7ce+b0MdnU0cak2XoPqfZyXNpWTb7HAhyv9vL60BFK5WF1DYyBDiketyoBddGIySkIywmNwHhfPxb0dDJhQ8MbKik6jrNfURWH4d4Odi8wzsOn2c9runw6b+mTfBut57hWuHzerXY+d7NE4HrSsJqFRLai8x3yiD99A5NBz469hu7Ur1yCpIuBzGcwer7ninzJjI1zDh7W1T6MEzGB1Mpj2cP0r3g1HHkPLyvvGDqisNXMa48QdAXnJGvIQWw4fVYzWwfZgRy4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jun 11, 2026, at 07:20, Shakeel Butt <shakeel.butt@linux.dev> =
wrote:
>=20
> Reading the debugfs "count" file of a memcg-aware shrinker can sleep
> inside an RCU read-side critical section:
>=20
>  BUG: sleeping function called from invalid context at =
kernel/cgroup/rstat.c:421
>  RCU nest depth: 1, expected: 0
>   css_rstat_flush
>   mem_cgroup_flush_stats
>   zswap_shrinker_count
>   shrinker_debugfs_count_show
>=20
> shrinker_debugfs_count_show() invokes the ->count_objects() callback
> under rcu_read_lock(). The zswap callback flushes memcg stats via
> css_rstat_flush(), which may sleep, so it must not run under RCU.
>=20
> The RCU lock is not needed here. mem_cgroup_iter() takes RCU =
internally
> and returns a memcg holding a css reference (dropped on the next
> iteration or by mem_cgroup_iter_break()), so the memcg stays alive
> without it. The shrinker is kept alive by the open debugfs file:
> shrinker_free() removes the debugfs entries via
> debugfs_remove_recursive(), which waits for in-flight readers to =
drain,
> before call_rcu(..., shrinker_free_rcu_cb). The sibling "scan" handler
> already invokes the sleeping ->scan_objects() callback with no RCU
> section.
>=20
> Drop the rcu_read_lock()/rcu_read_unlock().
>=20
> Fixes: 5035ebc644ae ("mm: shrinkers: introduce debugfs interface for =
memory shrinkers")
> Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
> Closes: =
https://lore.kernel.org/all/c052a064-cddb-494f-a0d8-f8a10b4b1c4d@linux.dev=
/
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


