Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75748606A32D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 10:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Ea1pyXsz
Received: by kanga.kvack.org (Postfix)
	id 856256B05B0; Mon, 23 Nov 2026 05:09:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E0BC6B05B2; Mon, 23 Nov 2026 05:09:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CED96B05B4; Mon, 23 Nov 2026 05:09:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 42F046B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:09:17 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B7633A850E
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:09:16 +0000 (UTC)
X-FDA: 85465961112.24.825B944
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf23.hostedemail.com (Postfix) with ESMTP id BA927140003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:09:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Ea1pyXsz;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795428555;
	b=DU/RAZ0jogvVuYoX9MTW8KyvfNhc7ReSJCNGkbCHdNSawWhS06NcbWaggu3NDySYG/Pwir
	agLgvSa7e3vXgnvVfcqKujXznwkPTpOjueCnKAHWnwCvnU0PeWltKVepq/qpJFTBPdD+F+
	yVMse8qXw+cswiosNmijRThUhVpIM+g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795428555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pryCjk4CWyRrgAZYc/zoRA3NaYdrmsP+3BUItR4T6Yg=;
	b=JO+Jol+tTACKC//ePxNx2FrjHZGjSP1JH6JeHZJx0gG9TyolwDVmp9VYzY1jSZ1BkY15mN
	N6r6vBNFIaNuDyqX3iHgHdn9Fjjj7moPfnrSv9qvkbMM5qSTuLIGiotd5VMKcrtwMGJE4W
	Qyh/O4u7/aJ3fUscFHIgJIXknLOywmM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Ea1pyXsz;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795428551; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=pryCjk4CWyRrgAZYc/zoRA3NaYdrmsP+3BUItR4T6Yg=;
	b=Ea1pyXsz+qmQWzrsa59GHbKMO5OKCuCphCTO95c9YjnGhnJoYhwO/pdgwXxbplHaLHE8a2tduqRMBPepdCPIgDpPxkQIwPE5/kaevos+iFkuy8YiAh3dn1p8//b93OJeC95GnGEpJRw7F3lF8TzcJmUs50FAemE/uWevTqBzmTU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XFH23DP_1795428547;
Received: from 30.74.144.153(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XFH23DP_1795428547 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 23 Nov 2026 18:09:08 +0800
Message-ID: <cc47e669-a662-4d80-950e-d44bb4c311a3@linux.alibaba.com>
Date: Mon, 23 Nov 2026 18:09:07 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/5] mm/mglru: reschedule between memcg reclaim
 attempts
To: Max Kellermann <max.kellermann@ionos.com>, akpm@linux-foundation.org,
 kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, baoquan.he@linux.dev, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, hannes@cmpxchg.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org
References: <20261116081403.216452-1-max.kellermann@ionos.com>
 <20261116081403.216452-6-max.kellermann@ionos.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261116081403.216452-6-max.kellermann@ionos.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BA927140003
X-Stat-Signature: 5dra49ghqnjig59wgrxatmitkpa8nsz4
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795428553-180771
X-HE-Meta: U2FsdGVkX1+5DbHZ7n3qsDew11SXlWmd36G36fkedcXYpws4qBnr1RS3C7hsbjyHjMX5adCTU4etcbgZW7DwrJa9PKAbirkJVyzwT6IEXzM8CECQt5aJlWRntQ4wx+UYDaq0bHV82+rD4vdmBjlenJANJBqGwjg4nSN0C7kbTPUlFFR5otObIbg4iOIJNoLUoim/AYJGZox7yFm9a2jMJ3EpQvFruBSncKPdYRA4TmMmX2g5pj15o/nbD0d7hxTAfxTUFzLr0vXbazJTLyJiNEtSYxtSw8gTU1oDsFE4pkGmQ+lPvjDNSPe+O605h3nfFNcLwjU+rkE6Z3FPSajpk6DbhJW5ptwv9uL7c7Vc3Q2h4aKtqzCMbeKQuF95Ze3rbbra8/1Pz5AihKyq8QZDnxMT9be1DlrhU+uHGI2xCfBOMLhWboDTlUqyUDo4bvw95sKSSUnpdL5tsisUPfeyNA6ads/GEeH1tphRJIJVLpcCB1n9iGJHwEtgLVVYK7MBMghVKf6DGpa45k1Ua6sTzlCoqD6zpDW2NhcbDBTCnq+2vuWB9IH/PIV0MNIAGhMUNODOegU2/EAVLhiDOYcSyxAmydrnHeCwV1K3CWjO4eZQ/UTKBc2yfBgPLxL7xrLhC+proNHUhxCdNQhKKbg7BVuk6eM+S0EtZ0hEWshOEYfUhUC1fF72ksFunqqtLv/IqmIdxlPunQMRTA/p9urOvIDo42Ewxa3afzD6kOxMiWLxv/pTctryXx64aiuYQnu2yvkOrFZsFsCXvF9gn5DS98niMR5uunPyvtzJYc8aTD7TS1Yw7saw3+f0GWBBs8tUDQhMaaqXdH1k3ljh3wj4+434q34pPmk0myYNDUBCNGpBG+4bzj95Kbwea7UelwWwzIqoSJOAKxWPimtOGQLMSB0a/oJ7qQh2S2F5n79JI/nb14pS+3r7UnCDaRM1OYM+ubRcqgyRhqfrUYnD/ey
 Zabhl2lG
 oNBKjjaZ5q/01GlPuuAcmlPCsbY4T8L3v57DamzczuvWpRT1q8oAq6II6CkKngPN9wBi1WYF1S+MO/UcVI2kuwB9tmSLbWQSIMxobTovmGlqJ2Z0shrnnOOjDDF852CCygoHZ7ecGrJQVE2ZmmKAfjKTOBwImlqFp6+55l5cvTaWyuFHAPR5crvpqgPe5/n3KZ8bI2CDwQQjrMrSIhC3ofnV15udW4Elg+W4PReYzCa8ZCEyuP3sgamFRw5FmHnEX0pyAkHY/fV6fwMx4VQ4XAmHu8HA5xE0Nyz6PprxjtssTiZ8fUFes3Ym2KQ6yZxGoJ77C9W5wPF31LRkJAMfZwpXKLPQcknRDcvn+2jEAOmh3/X1d+Kfe1TTfGoHU6t34ijJtH9XyfPgb9PFtWCH/Ym80DFab/VDh2ZUpzKYmxASWaL5w/A9jLREm7OvSMJ4nnKKDlDUWWkvHc/kk6WGbv+XexaP/A3+xOcX63NFmvRnT1iwZozaQItS2uM/WseIlrNEB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/16/26 4:14 PM, Max Kellermann wrote:
> shrink_one() can return immediately for empty or protected memcgs, and
> try_to_shrink_lruvec() can break out before reaching its
> cond_resched().  A scan through many memcgs can repeatedly rotate
> entries without giving other runnable tasks a scheduling opportunity.
> 
> Call cond_resched_tasks_rcu_qs() (as the existing shrink_lruvec() loop
> does) after shrink_one(), while the memcg reference still pins the
> cursor and before reacquiring the RCU read lock.  Also call it between
> bins and nulls-marker retries, covering scans that skip every entry.
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

