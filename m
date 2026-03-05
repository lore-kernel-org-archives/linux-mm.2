Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1A81F30951
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 11:58:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49EC96B00BB; Thu,  5 Mar 2026 06:58:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 473116B00BC; Thu,  5 Mar 2026 06:58:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38CAE6B00BD; Thu,  5 Mar 2026 06:58:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 289FF6B00BB
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:58:04 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E6054C1D12
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:58:03 +0000 (UTC)
X-FDA: 84511860846.27.B69E55A
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4037B140005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:58:02 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nqgE8YuM;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772711882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f+e+MrbxStkCyw/Uqa2jpcsS2d2D2I5PIhTEX7t4Mug=;
	b=Ac95w992MiIUcRNu50fPeqIebyQt31xcwmszHJeG8yZmKWbRjpMyYtjo2CEt19xepWZs3Y
	GPFgaWDfdt8bhPmS+/f4X9wmVedD/9u5APcHBCUoez5pAklP+7gcDAyPBRmDcl2VfT7Inl
	YrUolwXH20BMsRqcgXbZwZdAmpUwHsY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nqgE8YuM;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772711882; a=rsa-sha256;
	cv=none;
	b=OqeQI8qbV543ABSNvbLKsz/e7dMrlZummV/HWHupCA0SEWMMJdM4ol1tELYtE0cxLwY6ji
	cD6MNAJkYC1iOzL3fu/wcir1ELzRwy+IVjcsS9L7cc1M2ar/lmAJ47cKwI2ghCrzjIF624
	S5v62sIU6ofyn2f6pinsqEaq2y8cdxA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772711880;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f+e+MrbxStkCyw/Uqa2jpcsS2d2D2I5PIhTEX7t4Mug=;
	b=nqgE8YuMYpDeMSH70KNVeXPS0W/PRINNke44gBx7AlwJ4YmwlZE50vf2Y4Jo1VuXMWZp62
	KPKir4dzqgTTlpd9/Attzl0mRO9jxg8AH2zpwt1vEZFsP+YMJW7CyX4oq3KY/eLsrnIwsf
	T0X1I8DTJfskCOaiY4Ntpo66q467K2k=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev,
	bhe@redhat.com,
	usamaarif642@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v6 22/33] mm: workingset: prevent lruvec release in workingset_activation()
Date: Thu,  5 Mar 2026 19:52:40 +0800
Message-ID: <c6130476affbba0a7d309a887c3df11e0167990b.1772711148.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772711148.git.zhengqi.arch@bytedance.com>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 4037B140005
X-Stat-Signature: g1axijwzrgaanmkzciascr5oorpy8fh6
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772711881-230174
X-HE-Meta: U2FsdGVkX18a98prMza1I91CqInt+PTA76i8EEugtwyN+5OGGyNpVeDQ64OspWrylO0qWsr786SVTB9YnHEht5T23/Jp4mn00DvGMFKAPaehnmAZ562aYbKFgIzAiVEBwvqgDthg0elyBpsyjX3MULzc/4Xqf2plSXhjhBb8pXkzPL0u7x7SVCrU+yZ/i21jw/08lEqSwRLWvHwwb+XiDKD3oLGpGG7LNH1ZT5+ZbiyLxRTWhYzWw7VOEmz2ucqRG8r9v6FNK9mkgYmK6IGHSVYRWxoNIp1wbQ8zrE1FbBtuLDCKnaWehyUm0ODCqFAiNQpL52oLRnYudPw3rlcVlPkB8IXr+kU0RTZKct1DR1vw3WAzg0fr0QYdGsw/axJCE+LzYvlBJnqsjIDrgystVoVuDh9abz2B10iw+8Exny+y3UsEsG1yYsv46foztVTAGK8Zexm7j69JAbB3GavnGRU4XDSKEvkOISbLKfPrSWn5jeyQDZyGcF7q2ppm52tAgPiH5xjvy27vcTkW1ZYKrt+j4Q/CC9r2rnMpaPpAgVJ3snwG2Ar9YggrLiPP9YLIB34VqKmd0uMpufh9/BJPePBxChXiIR5RuO6JYc9uhkppSF1rGYc9blCsCKQPVb347Wu7WTg1DZ9trTqzITmNQaX1g/ya9dLH8opg2No5g7C2lG5WaOC3ue75+KlPyVKQU/+CVqUmL4LwA3FXJ43EJ/NJl4WQZfU2DCV7ewUZrtX8qC2OL9AwyjOu79C1HuIR6HDUG0DXUbyqyLquo1LZzYQyGrVYeNm0HUqRy2M1RHYlbqf0TH/bUntUAs/+AnCDEaL/0BNjyH4+SJYCD1/n8O9KsYnO5Ls/w70uLrS19flrvq/FlyFb3dpY/zBoRGUlwoNf2NKVMR/KBknA2HnpugyO/JF+K1qe6XVJgyFWSslCArJB7Idaoc9o8n1fbq08C3DlZSGTmfpF4lZnUxZ
 DWt/wqn6
 gYqVZe+T3lSojyvYDXIFUxDeTViWnRBxPRqNewetgFbpC3sxtECkslzefrNgLH22Gz601OxaOG0tlojEw2ugQjW0i9/dDAXpR0fAjH3a6275iFG9+rdeXth9hS6R7JfX36go6AFIzNUwVPLyvBhM5KS7jD0vt/RlTjagHLm/3fS6bmxUVhr7NrSDh+gO+POPat8h6G8pQ/BzvEBC+jCyUaQaXWMZwwRh/pi7ePrChXqWfUU39104XS+KLzwhsqX12YSKiqYLxfdhBa7tXrQAQuYvzrbghJcJ7ifhH+h5bg8dRqRwJ1FAHHCDC0LUU9I6HNI1Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

In the near future, a folio will no longer pin its corresponding
memory cgroup. So an lruvec returned by folio_lruvec() could be
released without the rcu read lock or a reference to its memory
cgroup.

In the current patch, the rcu read lock is employed to safeguard
against the release of the lruvec in workingset_activation().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/workingset.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index 2de2a355f0f86..95d722a452e1c 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -603,8 +603,11 @@ void workingset_activation(struct folio *folio)
 	 * Filter non-memcg pages here, e.g. unmap can call
 	 * mark_page_accessed() on VDSO pages.
 	 */
-	if (mem_cgroup_disabled() || folio_memcg_charged(folio))
+	if (mem_cgroup_disabled() || folio_memcg_charged(folio)) {
+		rcu_read_lock();
 		workingset_age_nonresident(folio_lruvec(folio), folio_nr_pages(folio));
+		rcu_read_unlock();
+	}
 }
 
 /*
-- 
2.20.1


