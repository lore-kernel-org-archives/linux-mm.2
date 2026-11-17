Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C17C2606A880
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 08:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=PGpgrfaZ
Received: by kanga.kvack.org (Postfix)
	id C11EA6B05B1; Tue, 17 Nov 2026 03:04:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC2406B05B2; Tue, 17 Nov 2026 03:04:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFF576B05B3; Tue, 17 Nov 2026 03:04:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 933506B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:04:34 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A45CA1A0356
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:04:32 +0000 (UTC)
X-FDA: 85443873984.25.401342B
Received: from mta0.migadu.com (out-239.mta0.migadu.com [91.218.175.239])
	by imf25.hostedemail.com (Postfix) with ESMTP id BE770A0003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:04:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PGpgrfaZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.239 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794902671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fr+hVevMxhFED02GURMU20tKWkOs3+xF0X0pX/yzRQU=;
	b=Rdj9eD/Ok1Bqys3KHt2Us60SrNBjmLgAtFNPtQiRJlfBxT24yRq8LM1XezNoRtPvB0PV7k
	o9mQ0n+c33ZRbnqr6HQJ3E4/fuW+1/zkIMPwMSbID/Moi7ksIm+4EC6ceMC3rngCGCEL71
	UatH93HhWcMjxnol86LyaOhftgftbrA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PGpgrfaZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.239 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794902671;
	b=TiHeH/By/X5bPpdGzHL2DZUXTzKzQSilj8sfKdJWmdyD7bRDNF+6sAoqt4VOBLXG93rs+R
	2rYXVea9cSJNsqLn+UJo90tmvbiFIpddcIbiV4QAYTsQ4H5wl8ebCzkfxi74VlUTQXiTW3
	ZBWLaIxlJA/ZC9OlIQq40NyLCIhc0mU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=HT+AvSGQmCJPID8n4M/T08ixuiDzXLImqF0yDDDj77U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794902669; v=1; x=1795507469;
 b=PGpgrfaZ2VM58rmnP3EvmRVchWywekWALpZj3AlSMilFrWfzAxYlJTTeLmzedKAjU8RpJXIS
 UJQlAJejoj6DlNOCFWxxLXOsuDb5Nduiebnv+cQC6xkDKwRJyJGDObfUTi0wN+1J8e/QT5uy+Ky
 rOWa5BHXyHfk1U/tzUwS/h7Y=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id aab591f1a1b28741;
	Tue, 17 Nov 2026 08:04:29 +0000
X-Mizu-Trace-ID: aab591f1a1b28741
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Down <chris@chrisdown.name>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH 0/2] mm: memcg: fix memory.high allocator throttling
Date: Tue, 17 Nov 2026 16:04:19 +0800
Message-ID: <cover.1794902513.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BE770A0003
X-Stat-Signature: 4btwwg8o1bs7mmyn1dketipo5g6qxhzk
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794902670-338600
X-HE-Meta: U2FsdGVkX1856neV4WBdntOkl0jlANakN1vV2+XmStq1cX7pGTCyhCNr3bPiQhIxpubzpQc4OGbmRLulf2obpHzujdPGa+M45GOLVMY4TF0fRvXhTsot8ok+V/xWcoicYN7z9XnX5cgQ+tx3OCwnvYUYEd9i3AZBKg9E7yD570eNJGvHzzEi8gGxYfugNxpXosbk5WfwTMZJW3FkTtfgSaRV+ZNGiH2ULZTyIoHsEfBn865QSsxwXUnyF5psn/PKQMCm3YSgEAEzCYE+KohV+RAxezP/TZaarlSDwTtgMB3fkgKnjtWTf/jAfrjqbZdz2Wn1bLfENoMF6Vff4/Zz3Qo5ijqmtAdB9q5nQKwjcsrec+HlbZcs16gKn2BjAPkFqIHI4KZZ6nUtORYfySxoRCGi+0FeUuX+4uIDHrXxtFxgxc5iqpSrvDG3gaIHwVrQZWO7OhlXARKV3wIesD3asmLLhuo14nDK+gYwlO4CXXeqD9T0d7jGDqmAKbZXPo6cyUEXPfkhqvjJeB8XuMfTXJr5DUQDwZ0albqgZWKTJpNlEkrE1rq32OYlfq7ynmrlYAyoasGHar1hA4eym93jGFMxSlzrbvM85TyfnKCoGkVRjnHWrQ1Cn0fJtOSmKOvk7H2f8SzK+26Q7gQhxeWoZnbBQXrzTxu29UTj9u3XSdqaNNq/1Znm+IamDk4R6PxDNSkPM4OvK8Eyd405jIOBFCK43uXL0K9bnLx436UQb7mPDv9npyYgktDHmvwJfnqe9zMOAzIsX0DHYMIxBxLzPvJEYUQ1xt0LoWc3xGXLhCUqupqKBiejuGo139DoOx/poG7UDNKvj95OjRe80LKnz59u/aIHlz8K3YWG5zUeT+hhWjAUF0bR0LroxBNirqWEaw1ZDNU7gAg5meqSQjB7PvufXvglyc+Q/s6Q5B2EFfl+m6x6B3ZMhum/CJoVSDcMdhD+0d6nKgimFdub+Ci
 zXHclO+x
 RvbGdW/sSLZHI+sZxKaAUCFAhQPrOObOEf56rt/lqF7CrmNbp+FMgcX+p7fcNM6CiTmNcbT3qeFv8RkpyD4RyGYxhyz0fbv/mPGfBNrEvggmwiFUf1px/d058UXBg3UNAd79i7vJWOseMoLJk/bOtPmj5DqHY/4qgvGatVpWuBY6EbZjy+auRXvQ3kMFewhpDtkkc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Hui Zhu <zhuhui@kylinos.cn>

calculate_high_delay() converts how far a cgroup is over memory.high or
memory.swap.high into a sleep penalty. Two defects corrupt that penalty,
and since the caller treats "penalty_jiffies <= HZ / 100" as "nothing to
do", a small result silently skips both the throttle and the
MAX_RECLAIM_RETRIES reclaim loop.

1/2: the u64 product is stored in an unsigned long before being shifted
right 34 bits, so on 32-bit kernels it truncates to zero and no overage
ever produces a penalty. Broken since v5.6.

2/2: the u64 product itself overflows once a cgroup is about 130x over its
limit, leaving an arbitrary result that can be zero. memory.high has no
lower bound, so a one page limit with a few MB of usage gets there. Also
affects 64-bit kernels.

Both touch calculate_high_delay(), so apply in order. Different Fixes
tags, both for stable.

Hui Zhu (2):
  mm: memcg: fix zero throttle delay on 32-bit kernels
  mm: memcg: fix memory.high throttle lost to u64 overflow

 mm/memcontrol.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

-- 
2.53.0


