Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF1061061B1B
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 19:03:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EA6B6B0095; Mon, 30 Mar 2026 15:03:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39B2E6B0096; Mon, 30 Mar 2026 15:03:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D8D56B0098; Mon, 30 Mar 2026 15:03:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1C4266B0095
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:03:23 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ADA018C58C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 19:03:22 +0000 (UTC)
X-FDA: 84603652644.17.8C7843A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id D7E6416000C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 19:03:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SIPOM7xF;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SIPOM7xF;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774897401; a=rsa-sha256;
	cv=none;
	b=uGUaRfqEs0qjKU//Ww8cEfGbsraJ74pKMQwxAOuo7UQk0o+AqIDAfuob78qz0ZZS5bL53H
	GX820w2I1TSzPGnALwRmVobiPdKhmIdjGMCgTP4gXgel2Z0kKpro7rEQJ4ICF+SFSWGWGh
	XjL9GmSrFKMWRkUq5wtGxAkWTxDSpu0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774897401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=378aud9Dh+FWd+8dwjv+cxpLPvlrAvdiIG7DVZAnOpQ=;
	b=OyVbOaCYuirLiZKmVyp8SftHMDtvcXzJR3pT7KlOuLBDKOqoCsEUuJkwDpzikxN1LcnuDT
	csDQ2sgtUMtT1ivnPnzeEV3VhARFxzv2Sz1ewx5nUTTt+CLpH7vZmVgdWnUVQi44U/J/Ft
	7kwAio5EUPC5eVoQmuuXzsF53Cn9DP0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 066D641984;
	Mon, 30 Mar 2026 19:03:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67614C4CEF7;
	Mon, 30 Mar 2026 19:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774897399;
	bh=bYoBpf9mMwP/A8V7PLvxT4p0yP3S1B/zELC0UR3Nn7o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=SIPOM7xFPJM7CrHXXiyNKv84sJFnXFhGPo0qbVxnJG61dZY7p4Eb7Ci/76pw2+X7f
	 E2hoUm9F5YJbTXrpgwLJBvEGXpCZ2fhj7BAAj6icy5xB1xulFPO9GwscEcy/c8C+69
	 4XJlWIr0ODjMmsDi9uH5naeTYGTi7f5yFJcWbdL8=
Date: Mon, 30 Mar 2026 12:03:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand
 <david@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed
 <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Usama Arif <usama.arif@linux.dev>, Kiryl
 Shutsemau <kas@kernel.org>, Dave Chinner <david@fromorbit.com>, Roman
 Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, Alexander
 Egorenkov <egorenar@linux.ibm.com>
Subject: Re: [PATCH v3 7/7] mm: switch deferred split shrinker to list_lru -
 [s390] panic in __memcg_list_lru_alloc
Message-Id: <20260330120318.3499796039de007752554cea@linux-foundation.org>
In-Reply-To: <4d3f8d79-3593-47df-9de8-f94f7f09a403@linux.ibm.com>
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
	<20260318200352.1039011-8-hannes@cmpxchg.org>
	<4d3f8d79-3593-47df-9de8-f94f7f09a403@linux.ibm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D7E6416000C
X-Stat-Signature: 515afbzus1pwbsscpr41coajxgo8ra4a
X-Rspam-User: 
X-HE-Tag: 1774897400-217158
X-HE-Meta: U2FsdGVkX19CDvYKmICGEucJn7961EiZIdvaucUG+D7OCI1JdDR4qJ2XDHV6XvRkuSZ92MOGrwq9KrlN2kgkWSLUNhFCGbNF4jGecobf0lxsQde5xVy/ZaNqlKOmASwkBqAOxOK51TvSA9yjq1IEquQzvbFbhzM+fYr0xVbibgWYkzwaeryoLtCn/62FhtPaL1USADNVrHHnm0L1NAJUGcHJQQ8e3s6QGQUrgmQxxlzj/BVNAVWw3Uh/U2NHNChgxDzUKAKG4YRdagVwPCOpnJuVYgiaoGmHPUclqq7ggm8Cv5CIIhM/7cMndZiBGfKz7DYufdDd3IJxTE/wOIJW2Ud7MoKYPTJrMiOkT33e8H7EevUs8jarWPzd9eVQp/bIxwwTTFTmp12PgttpM855zumtIMsQNzeIYQS9p7HH5yj3PCFtLp97GTC7uzR4aoWCuOy4ar2/L0dLn2HbZ/3nxpYnwiOo0uL00hmSmXok/1e4MqQR+no/Y1d1lHnOVl6CYwG9kufeSnZMmMfgTICMn3QxFvwILoC8dLt7udUhc+RYR6xxtcw5VhVuAAlbz62Zu5AIyWMUQQrkVUV1GucyPFhEh3cdGr+MUrPkO5mXXlu6mg9KyHidmFNJoQalLg1GNQZmtU+OvixgiX7xZQFp0EeUR0oGfblamUnVVa9dqK4bVq3I1kxmnFMqj8wY78jePBrNznz/mbFQOEjV2uPsUjoU5b0DYIT7jPks+JkDqCq28iKR8yBrPn56u8WmCyUTDA/uPkk+imyYgaHrMfaFdd6XOkKOxc+HjMgEXbQEnEWucdRApmNwciD+yn8tODLW53Tn2l3tCdu/eQhIxSDDOZsq4KLawLFyvn5mzqx9+SoOiufqt1jy+G4GWqVeTAqvYVhMAbuF93g1+Pr8qCPzQlRcyq31wxy0ZipArtgSewV1a0ILJ7jB5Y/1inwZBiCwBU7/qgDBBHvlUg2NemY
 JwDjeJTh
 Z1ZdDvqmfeSjl5OD345/4D3pugykTsZeYsVgTSTcVYTF5LqyzYbKVwW5xi4MpktdwvWBEygZ4yCgRFb6ckdSTr6yqrrwqcMKk1is0Aq89mJHmvykcTVEGlcTA8G9g8Fhjv38eKcjAZ98DH7gyK4MPFcdkG5SPfEfYF3wlJXf7tR6F39NQ/OG8TiZG1te68tjxcwlmBh/IGKU6W0rsXFjmMUGe48PVHhiFveUAS1aW97aELuC7vMvLPRAfbRzSuOfYzUqdNaNPbf0FtHzqafhZFt/5+WLPXaLWOk6bORliPfAIm+e2lLqPJIRQL1g2DBroElfL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 30 Mar 2026 18:37:01 +0200 Mikhail Zaslonko <zaslonko@linux.ibm.com> wrote:

> with this series in linux-next (since next-20260324) I see a reproducible panic on s390 in the
> dump kernel when running NVMe standalone dump (ngdump).
> This only happens in the 'capture kernel', normal boot of the same kernel works fine.

Thanks.  It seems that hannes is working on a significant respin, so
I'll remove this version of the series from mm.git/linux-next.


