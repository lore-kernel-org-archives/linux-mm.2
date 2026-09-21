Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5363C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 11:46:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0F4F6B00E1; Mon, 21 Sep 2026 07:46:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE61D6B00E2; Mon, 21 Sep 2026 07:46:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFC9B6B00E3; Mon, 21 Sep 2026 07:46:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B09646B00E1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:46:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0B718C0153
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:46:42 +0000 (UTC)
X-FDA: 85237592244.07.3FA9831
Received: from mta1.migadu.com (out-58.mta1.migadu.com [95.215.58.58])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0E11C1C0004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:46:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="J/UK/IiC";
	spf=pass (imf18.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.58 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789991200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J5F0QiGhWcKSd/JObQhFEX5LCvv8KtlOInFt29hntGc=;
	b=qGycxdg77AIaxvR7us6oAIuXcASkFBt1HSpXFto8AaOcvBn0ge/QLkWMziUKi7OpsOHSpF
	DKOw2qnM68aQyv8dYqod/8OxHkEvtOp7yrJhfpP4Co4LJfOAuIXIWN2/22AVqPlwcjoaQ1
	dkQdbW/Ul38APrznSNpVqtyvEZZL/5g=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="J/UK/IiC";
	spf=pass (imf18.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.58 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789991200;
	b=wCqgTy8ur+0GQWRU5ciXW6UHC4F5rmNC85qmXKtfjBzld7IYPg14lUy/cGmAKGIwEPyyR5
	brBA1eWGZ8YWnPxXEOMGOCeQk+KaUZRqL089bU+CSYVKO4USrE+rjM8OfIOnMtSvC3Xn3X
	ovf9tvB7RY3yOozMFI5NvNePWpxAXwE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=jRoLHiXUjqgSCQI9swstc7I6QdyBDVBnU5RnGjj+W6U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789991198; v=1; x=1790595998;
 b=J/UK/IiC5s+C6wAqG+lSel0+4AUh58am8QpK433Zn2jnlGo9EMJIsEBa7lkOlsKTQF7+E+2O
 wvfGVyNI+OmpmKDga0DDG3RDhWLGicLftzIK4VB6T0HqnfGudcKdRAUofJ0PdlTlNZASCilhwoF
 EoKxpd+5jM1llzAfUjiW+9BY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2b03a41349172853;
	Mon, 21 Sep 2026 11:46:38 +0000
X-Mizu-Trace-ID: 2b03a41349172853
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH RFC 1/4] mm/memcontrol: drop unused vmscan tracepoint include
Date: Mon, 21 Sep 2026 19:46:03 +0800
Message-Id: <20260921114606.3871820-2-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260921114606.3871820-1-ridong.chen@linux.dev>
References: <20260921114606.3871820-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0E11C1C0004
X-Stat-Signature: yqby5w5azganahit79eeqn3ozfkmqnaa
X-Rspam-User: 
X-HE-Tag: 1789991199-245781
X-HE-Meta: U2FsdGVkX199JpcmoOGK6WkTDoqJRw70gtSOOr2ijVmvGXPW4LzSyaR2hI6OTPOlH9l4i783ajoupnW6GXk+wOZKG0ZNBoS9abeH7cKvKUGuCoWE/9EA1x6E/6JCwNEEuEkn5WCvMtiVsXPmw6H/I2mAuuQ6FKfDZBlP181sKZXEEydUhTT9TZHHENKSqCtY+MbwIoZeeuyS2aoONYOTQNQxF6UGfqM4R0E9RgeACq1Le2cLyjeEE+vpfsOeVJG8JuUJognrcxrNrG8Cuy9leWKGYBSnITjt53w12yYkBMAvbQpcZLjP//4diwU+1NlvzSgWpOMh6OBSO7iatgk7m/3h8cuixeIL57ucKHNdOhsbl4D6WuDVkA4fWlsj0hKbtUus9Ab3Zzd0dk6P1R384HxFkrhrg48bST59B4fakKRhCQ9og0J+VBpVMPtpkRsbmM/82HGHcpcKvuOXarFdcB0FicUEzYR/q/UkiA89VU82RGP2eK5cXG3zJkWyYiSh+L5MR9i357cT+/kZbSkk3mSKYyuC9cfZ43CRnJDo3ccWLp4/Bi16X9v+gu94SZnYIzkIfB5mbbHCrVZay7+kammx9tF1B8Gi7cO3I/trF8vTBb/SGf8ntM6UjJjMMhijBKYwmpHAmy5kgUCHicscW9uabyrvoqm9wbXd4CeOyucuRei5qsyWpvqWMRt9dp2ymuW+7Ef60uWtb6d4cMEMz6lC/kHmkezELucNFE+XiWwxx7C3ssd8Jw/XeTD+ML3fZw01QJTcCrUbAlR1MDi7Kt/IWcs43jPRFdErZaDk5oiK3S5yQgd9vC9Bif5vjFdOUf4wDJxXsXbWNUv0qLe70Sm1X1Xb/xDKAkpjHqDO4G5uQMlyDwtHSP3JJBnWdLRy37NzLcFrYX0Xo5w6dpMaIKE2zMloV5esH3+cCdnmoi0qq8xChVenQmBrrxULKJ+DRtJF4oixj9EWInZv6DC
 pkIHGPsv
 xtNUGdnmQjvLlIHOpx6INrasA8Fi8RCKSJaSuO1TIT2RzfRsBN9JQrDg1k9bA3Gse2zIXvaPtsdzIKS2Q6n98nrW3sYtUiTXjIWl4FSsOpn7ISJxr9Ul15g2Cgk6HDFHShCwg9ZzFpm8yZVS6yTEnWuEuXx0HDYxcazDLUBIySmqz0S3lc1dJVir2zExErG23i4iWorGSkOAOrCUnuIPz2wd+8XKjLpPuyqv9CbyOr8b9vMtyRT1ybD/lm/XPT7yyIJLQ5fb03lqO1K0YQ5pvj+IvKb7GLACktDk0z3Wh5+cDmH+fLrZXurwq2iRtgDDq5qcvBuc71ON+Oa0Ngqajc45cgGefQW+wvp5xpXvSy/c2zU7zcEpbe5FW8RZFNdvcy7UDEywFvXytP4r1/R1KZayu6blQPSZcnCOWR8kDiInBlgkTUE8UCwNywF0MfUcT9P+shylK+4hzQEody7VrgQKn5lB2NBOaMYeMnvqW4gzT+HkXfxhHp30pCbfOMN2pltCwklFAVy92LW86ei3UuOAWJYm5V1hcXttRKMYiq3YP9FGPwanTy04xV2MDAbqlylnMPREjVqbhNXwEsHWnlu6FiQZSa7Cu5x14fifxOCRY4ADO48fyId5f0xFtyb5D+PKaLSflJV79KiUkTTF4ZQfO3ub0RZYoRjssz52y/mow15wyW4kjgq8w1W/MSyHz8xgbNb2DF9iwEUVtF5ewWB+fdUmclB/syCox3Ql/u3eU6xK3ETX+6GFXRcYrMhVYdCIctnJ35737xmkRzATgtM15cbnjvV1CukN0W5cmpt49jHz8I3kdr8rXIzUxZPLIIcTy4UiJyzpChW5kekzFudRuGL8Kh6rBfPo3BPjUFt2kFtlyiGIxQYu8yP8QFvaEHjreLAHhZEE+e58fMIGvg5Kx/JEjviJ6taO9L45HUEJY/5hoxJC+hJeWP1EL87USQiSNsKuj0NVCSVEUbcMabQNgvL/D
 Cd9+sA6G
 eFsgt1DQsFT9J+kE7wVH75RhINr5OjkC84HIjZok45tTv13B8qerfAsFHI0F/n7w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

memcontrol.c includes <trace/events/vmscan.h> but does not use any of
the tracepoints or macros it defines: all tracepoints invoked here come
from memcg.h and writeback.h.  Removing the include still compiles
cleanly.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/memcontrol.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4d00748c8a5b..2a98c5ca46a6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -77,8 +77,6 @@
 #include <trace/events/memcg.h>
 #undef CREATE_TRACE_POINTS
 
-#include <trace/events/vmscan.h>
-
 struct cgroup_subsys memory_cgrp_subsys __read_mostly;
 EXPORT_SYMBOL(memory_cgrp_subsys);
 
-- 
2.34.1


