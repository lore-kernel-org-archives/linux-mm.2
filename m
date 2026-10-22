Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17A8A606A31B
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 00:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U0eKPT7E
Received: by kanga.kvack.org (Postfix)
	id 969B96B080E; Wed, 21 Oct 2026 20:53:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 940A56B080F; Wed, 21 Oct 2026 20:53:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87D626B0810; Wed, 21 Oct 2026 20:53:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 154FA6B080E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:53:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 45CB11404B7
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 00:53:23 +0000 (UTC)
X-FDA: 85348438686.23.51241ED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id A39FD40002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 00:53:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U0eKPT7E;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792630401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8b5nCz8QSeUyyC9CYP5Soi2IAEV97jGZySiEE6BlXEc=;
	b=mQpUwp3JphVf/NQfijirJyU5l+iwI6eI9d4oz+PdUcDrto+Fo6+S/tp+ZotHQi2dbMAkko
	PWyd9MymtkE5OiOQMkA/5UGSbcqqJve8tRB9ZacUj7MoofVYpDaYkNDqzsSweqpijDPgT/
	KkDGdiGXVBmVXBNSuzPJLH4eVq7cHyc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U0eKPT7E;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792630401;
	b=CdWWirgYD/3VItB9JFYVzTbUCJrXGe+Guckrdzbe6rj3OEL+Fdrav4iVXhuT+LRW9fJhkC
	Y3Und9NXRGpETdXX8/Ro0R81VRxS6FcHhNCvDsKuq6wwGxYnwpOmTtQgmhAy90C6teWgBO
	3A0t1Ol1WKGFigptPdPNhKCLVxWmP8Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6BB17409AF;
	Thu, 22 Oct 2026 00:53:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CDE1F000C2;
	Thu, 22 Oct 2026 00:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792630400;
	bh=8b5nCz8QSeUyyC9CYP5Soi2IAEV97jGZySiEE6BlXEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U0eKPT7EPpYXONbxlYhXtXDGL7X5L2m43GmogPVtOg17umKScJgZ8YdquJHumGuFK
	 ggLyc/z8oMM1C9+OLEUqYZhWw+pfaSpKzfuOjs7y4WQE4DHsjQOaYWQSM2rCJllppf
	 gydKVr1xuEC9Fp8AkI4OMyg6GghywwulDc9pPxIsXxQy3GrQ3pbHtoiaIA82sUoodc
	 +rNyQS/q1YZt0kivdQPNMjdYzlu3KYMJz/qPQcTfiAWyme2FlZiv/Z4HgPuFZpGUUE
	 ijeBDQKPnPIiGegcdDlGDlMDXdXexLTp95egJGPMnL5dS+I8DKv6CWlYb6l7OfMS3U
	 BdDG85kk6t5BQ==
From: SJ Park <sj@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Chris Down <chris@chrisdown.name>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH] mm/page_counter: use WRITE_ONCE() for emin/elow when parent is the root
Date: Wed, 21 Oct 2026 17:53:07 -0700
Message-ID: <20261022005307.87910-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261021204818.3431099-1-shakeel.butt@linux.dev>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A39FD40002
X-Stat-Signature: hu3x1p63q6oyc5wo13a3ai6ccc91udnn
X-Rspam-User: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792630401-776124
X-HE-Meta: U2FsdGVkX1+9y/58VQvcYj/jvfLXV8adKNJJmWAYq1Qflpt4z1377HJFXwq0CJTRFeYJYMx8a3pooM30RKjz+2UhZdZQkCt+dB8S6z8P2pcfxwn2C5PCfASsqEGIIDDfqJ5YShVTwPgX7YShBTt8Tqbt9wDqZAxETXRQ/m3QJbnNlKKEjitxeGh2/sF4ZxF3I18nqo/sMcCI3dSlD0b54amZDVM+7ZAjNBkWEnS4H30P86wUsSemAQemlemmwqTERDWCbb3n+ht2Pj3YpxPLNL3+awt6AWneQ0qI5h5x+l758QCgCk9JUxEWhyfOGN9y8vxYmSp1MxBCMb/irIbaiTEwVKfZN8iTN8/lD+IBNYnlMI4Gx6s17yfzdGtZLXjdFxirAJS8I/EgX+z8odmEauf92e8dL3olY3KGD1iD52h0TgJ4U5Cz9/BeXJgaMcGiX8v6Eb+L6Cjl1+V6fzfbzlg3cfPW+AfOLwtRM4cs+bVVp4U57bx8IGoxXCD7tWhVlvNd+m9rBfxhvb7ExhSjwVsU9Segzw8CEqCz0yl5q/HmeMOaeSd8LYfdTuObaz0QVSu3Nbf8PNUGUJGh9P4aWTyaMwgNO1vE1WSIYL8CrL5OAlEOJ/roqWBgASs8QmZobYL0jQbQ5Q+DRJUyFTE3J57UnnFjEzSFqu2UJb0uK5RaU2wkocBcwR4HdLn7klJV19rTk/WxNEEVE+pGzJWrSmS6lbFaDqooc+BhvneRA9HkhMc/TNmVcQI1zkMvSep1804DwZcqW5fnXmSQbRaSvMJ7ri0FcWVsWZVs8BJCOXiX4WUX+pIGrZrz99hVNCo2wjERIwcABeOPDDt2/RUJsXIyLPzdV2WlX6k02Gs+/QJVngVnG1b62z+aI25PguVHNkHfdO477YvGMKpK6vxBPaavkB2UFXOgNHRAFNOb4KyJQKZRCXza4DSwD4W7edwYhg7L+D8yXNqq0/E4h5X
 ytGtYXAG
 71eghJZ4dTx5O2P9dCkVcu45SCtplu3G3N45fQtBQuLO9Tu4xghfXdrn+1psPvIFhOKF5bpOr0y/myFq62abk7L8kVr5ugG6EghQpg8XU582SCuD6/dV5VZnUdHyRtJ/oUWSIs/CxfNvFl4pF8AyELD8/Nfr05SvNDKrTUXPc5nT79Y93w5ca49TI30KKGj2tcnpV3pfCy12WRp/elV4s1iSF3AhgsZx7WMaGbdyk02dXHUpfXREHpLdOffCf6F5zjRt2vEvkoRRFr4RFKe7YVoxD0XbRhTmjFtFXwz25372KyiMAAtTeSkuYdR0c0tsEgYqP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 21 Oct 2026 13:48:18 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> page_counter_calculate_protection() runs without locks. Several
> reclaimers can update the same counter's emin and elow at the same
> time, and readers such as mem_cgroup_below_min(), mem_cgroup_protection()
> and the dmem eviction code load them with READ_ONCE().
> 
> Commit b3a7822e5e75 ("mm, memcg: prevent mem_cgroup_protected store
> tearing") made the main path store emin and elow with WRITE_ONCE(), but
> it missed the early return for a counter whose parent is the reclaim
> root. Those two stores are the only plain accesses to emin and elow
> left.
> 
> With CONFIG_KCSAN_STRICT=y, a few tasks writing to the same cgroup's
> memory.reclaim trigger reports like this within seconds:
> 
>   BUG: KCSAN: data-race in page_counter_calculate_protection / shrink_node
> 
>   read (marked) to 0xff1f91b146d40e40 of 8 bytes by task 163 on cpu 4:
>    shrink_node+0x57a/0x1210
>    do_try_to_free_pages+0x194/0x930
>    try_to_free_mem_cgroup_pages+0x204/0x3f0
>    user_proactive_reclaim+0x28a/0x4d0
>    memory_reclaim+0x35/0x50
>    ...
> 
>   write to 0xff1f91b146d40e40 of 8 bytes by task 167 on cpu 6:
>    page_counter_calculate_protection+0x1fa/0x360
>    mem_cgroup_calculate_protection+0x4e/0x70
>    shrink_node+0x53e/0x1210
>    ...
> 
> The default KCSAN config does not report it, because it treats aligned
> word-sized plain writes as atomic.
> 
> Use WRITE_ONCE() for these two stores as well.
> 
> There is no functional change. Readers already accept stale values, and
> compilers emit a single word-sized store either way: with GCC 14 the
> x86-64 object code is the same before and after this change.

Makes sense to me.

> 
> Fixes: b3a7822e5e75 ("mm, memcg: prevent mem_cgroup_protected store tearing")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

