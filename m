Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64F73606A327
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 01:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=as+ZsFAa
Received: by kanga.kvack.org (Postfix)
	id 4EA286B05B0; Fri, 13 Nov 2026 20:49:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4741F6B05B1; Fri, 13 Nov 2026 20:49:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33CCB6B05B2; Fri, 13 Nov 2026 20:49:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 02ED66B05B0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:49:29 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D5CF71C35E6
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 01:49:27 +0000 (UTC)
X-FDA: 85432042374.15.DA9B887
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4A11280003
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 01:49:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=as+ZsFAa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794620966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uEA/O3KkpMmiRM8JdXggkU7r8GbFSfOA2tjkwk4bvLw=;
	b=MfAYrQoHrohYVfKx2tpMlpYlheb0HM/8XDkZeHdQRIlb1vGMiL7geDLt57yDMRWRrpR2nE
	C4zXRYpgIwYphAY7vtx7SFFnGN/C5Xx2huvJRq1w8dp44m0NnaYc7oRyvN+0oTCBOU3n98
	vRIhgXhsNaTY+RaSlin+nLIrHWF82pA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=as+ZsFAa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794620966;
	b=nr+S5MmSFFiHUidFdwnj7O5OJyhoz8OGFrwl/6sGxwiMZ5j2pNzK0TrQB26PdvuTkLnPd+
	FYvclW7WKaBfFJhkkClYBaRH1iGv64LG2ncJfieROFzC34U5027x3K8YTB9cVyxyjMrZVV
	68C8/UKGeD+z3R3wt7Q9SFV17xotLLg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8158F41ADE;
	Sat, 14 Nov 2026 01:49:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E901F000C4;
	Sat, 14 Nov 2026 01:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794620965;
	bh=uEA/O3KkpMmiRM8JdXggkU7r8GbFSfOA2tjkwk4bvLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=as+ZsFAaAa6jPW5pWt3mK5WGXEWGFaBAOvrPpOK9I/LIIb0sJMx9zk0N22j+zXFVN
	 aUK9GP8vlwBsQm/eb7zb9UTreprkDHszo8Mq5U2B+FX47k/g5Cv9kjCjRNLngR7sf0
	 nLS6JdlSG7zZuzBFs5EzgdJgVfLRIfK5hHC3cwuAoW1rcU0So+ZRVOXqP+uR6Kt8TZ
	 pMbVq43hZwg3UOZaz8JMtMAtZtt5vVdRKg3Vq3F7PR00triu8DudncS61QpUsGkWB+
	 xaFG6s2ivdcbfdyWjdgsyj5KASNA1UUAOQsy8ISldgdnkDvIfwZ84+DcuAe4u/MgHL
	 2nbvALK/Vr8lQ==
From: SJ Park <sj@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 3/3] mm/vmscan: consolidate promo vs. high watermark checks
Date: Fri, 13 Nov 2026 17:49:17 -0800
Message-ID: <20261114014917.86531-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261113235238.3595412-4-joshua.hahnjy@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4A11280003
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: nx8csxup8kacjmsk9xakj1843mttkuko
X-HE-Tag: 1794620966-423430
X-HE-Meta: U2FsdGVkX19xQjJjKrb5+iZb/MSkA0IA6QTGKwNkCPEnMOKxeXLtZMhLSMQ5043fIEMCcrQXnMlwO4alZt5n9d/mixQWALSyRPSbG5Y2t9ZyAgYWYp6RMehY9wPTT0S90IbzTyS3SskMIzAggqsjKJB0O73PDsT6I/YQ5Qk1PtmHwpSS6IHjdZk/ODTdD5goBDBDHyeH1rOJ55m+7qVINlMrlmOCF8CeUvvt3RdHWCRt5dAc0ER9dd6JBz9feQiN8Hl/lYNrKQl0980fklMzwYthqyviAqa+qwIVgQMu91kfPl4jPBWO/dCNrF0D4hx45XqiP0qQtc1Y6LdtazEIxdIOk1OBgHD22t2HIY+IBeJJ7QbcfwU1UMRAuLmICuHu7FLAGgD4e7MoHyqCo9GeMJmA8Tb4AUcTo0PrM9NTMS7rTMhQuW7FfWYpnH4qoS0MoS1OZgVjPo5PVDY/6cUCbcEQoISSzcHJgtcE6Cyi5LahxPqq3NMu0+JrZV018vfaMNVJGOZ+BA53gNbHF4YknAsIfGHOI3FFUZtdm5TjUxr/jSdYb4wztbNmI+sI25ySk4WBhtonKpPbUm7y1o2UJS76+uD//CMrdzGkDmqDGo/4tFtSxW0oePA7ZzKFvql9v3JSVLR89ulbH7dYL6GPYRdmYlz/CMjx0GgKiRm8NkB4jFaCi1hAw5E7/5NI9GaTPFwvjPHYbiBJz+Iyq3ZMcNtqdfVCYlCFPXgM842X00Ea4oGA+5evASbcLICIZDamfK2WEBuAykG3gMs/c+7QiPnlyULOi6D+gPSjGXNngbgdlPrQSIpPo3A75X5ynD8+s6z/Cn2GT48n5sztEGiyDhlvhaKhYY+MiRrTf2PfzzN1UidYa64Q1eqnJlHTDJeYx+PQtYX15Rch4Ie4UwtWxoV32WHAKp03CdLyaDhOsZuWtGjTzhsvHw8Txhky60XQOi/SxZg8F24TN2nVd3C
 fKlBL0QQ
 b+P4WGn3R7tsi3cRp/0gMAyruoVExmj+CCwTC5yo7K/Bw3Zxi//f2/EQhZnlUZ1RlUEwdyQTHeJZ93+T3Hn1J3qOal+jw5cvB6G55O/dsiCQ0QaVGu0ksQoDIPzV0ZCyWVTeypb5WOMNvDlukCPvYR3Ii6XmhTXJlgiEILILXwNdoIyI5j9Qf7TUn7Jqb1cxuGeMMLYO92hgZDrki+OOLGiPra7aAR42fxkzvoFXT82ydwrqVwLfglPIBcM0WzFwWtO84XpM6soCpjQ0EzgruMeceHWZD/wmdlJaIxxV0OiO4sCE3sNFZLT2Vdxkd4xC0H1QdS8J7XW7yqo4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 13 Nov 2026 15:52:36 -0800 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> There are three sites which all check the watermark that kswapd reclaims
> zones up to, which is the promo watermark when NUMA balancing memory
> tiering is enabled, and the high watermark otherwise.
> 
> Consolidate the patern into a helper function. While at it, remove the

Nit of nit.  s/patern/pattern/ ?

> include for <linux/sched/sysctl.h> in mm/page_alloc.c now that the
> dependency on sysctl_numa_balancing_mode has been abstracted into
> vmscan code.
> 
> No functional changes intended.

Looks good to me.

> 
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

