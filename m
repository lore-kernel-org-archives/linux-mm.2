Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EE74E6ADF9
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 22:18:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D0966B0089; Mon, 22 Dec 2025 17:18:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BB726B008A; Mon, 22 Dec 2025 17:18:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BDE36B008C; Mon, 22 Dec 2025 17:18:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7BA366B0089
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 17:18:09 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 238E18ABDB
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 22:18:09 +0000 (UTC)
X-FDA: 84248521098.23.825F263
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf01.hostedemail.com (Postfix) with ESMTP id 741344000A
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 22:18:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iFwmkNU1;
	spf=pass (imf01.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766441887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fzwkrJr5Ee6gFgNZqS18mPMFs5oUWCrwkGlHPOMuytI=;
	b=xcqM0TodR43f6gfHWbe3U+uHDM3e3WtgK1YzzUwxDsZukgtTYhusXZXp5U8qIlfBooqDPx
	U79nUTMO/397yAicVe6I7C+jAp1C44/u72DxbpTkqnhpa+X1Bxq9ylbnDRtGQvIrHhgMZg
	n+usdNvsHxHsDw7QDetw2RyfcTRwu8A=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iFwmkNU1;
	spf=pass (imf01.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766441887; a=rsa-sha256;
	cv=none;
	b=YQgDRpuIH5B41JdZmvIReMl2l5VvivIPP6VLN+Hq3IYEWHVSnNUAzIf5/GRPOrliWRC3LG
	o4I1xc2sZ9rbzReU/be5agvPKHulL6SfJPIS6S9HR9DMqqgPQ0pXTrg6ORxD5irhAbHn4w
	dqS/x4O0+UCSZDJlffimFnD6ouPmrKI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766441886;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fzwkrJr5Ee6gFgNZqS18mPMFs5oUWCrwkGlHPOMuytI=;
	b=iFwmkNU1mQ9+2qaaKmyijftgXuTYJNtT9k8UJ7D6u1u4IZeeIV3BSGvRkKBo2Tdj8c+EbW
	UaQ5auwvPAQhduae2jal/mntKxvMrSrSsQoH5wEVK3Roz9HU6E1qoRp+uMJAyJa3iB/zop
	Ev3utpKG0I7Qv6tSaThu9Tvyz1/wZBY=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: JP Kobryn <inwardvessel@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH bpf-next v3 1/6] mm: declare memcg_page_state_output() in memcontrol.h
Date: Mon, 22 Dec 2025 14:17:49 -0800
Message-ID: <20251222221754.186191-2-roman.gushchin@linux.dev>
In-Reply-To: <20251222221754.186191-1-roman.gushchin@linux.dev>
References: <20251222221754.186191-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 9a7rju8ncwdtowowaseyhyxutjkhafya
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 741344000A
X-HE-Tag: 1766441887-257388
X-HE-Meta: U2FsdGVkX1+GX+69FiBDf0ekj7XDim9GgUwM4leZ2Y5JG5y9D6op4wXQ+hLUPsqWbw4pB97w75LNlONOML4asbE6cuIPDjNaVuKMCjbQpJbgEAgHaHDoWkff+Rk3i6G8sW9G3ifT3rj9m9AuBkyeX/IE7/dJyZ+eB/xLlrQK5UuHhvXEm7EAG7geO3OMlaUnzD4XdYeYdqfPSJZj8fihIUfUkW2Xla23UVY0g5LsB2bwrX+C7737m//e0gToB4c0p1kNqldgdx2ypdxO+2LAnuWJ2xNND3uFRc83ptcd7IKoVM89BUFlbozYKUwm9IswaZKfcMbpXArYDtK2bmrcJRgCQCMwy/jjRTh77wMFNMMzHAzdcuZnO0FHPyq4FWMRzdTBTst0sUykuR4+MjYw6cGokTGumdapIJrFS0k2RhM+OmHj5m2QxcrbAuTuX3sMZ2Vruz46Kdc879HF4EuszA5KUFf64x3OrhrGoDepxQLkOxoq+WMDNDZH3lOIuGLX2YDiAPMdBV5uEnMAb5tL174+6D0YTnlKFMoJwi11HH0yGhqII3OJFihoHxEVWtAoaF8RHSklglvYl9MmVgVIjdwHYpVrwatUM9HxGz32VlWparrOU8Mh/XpuoKFPdh9R/VwRiRaTdtEi1yNEVsGAEihCoT9uYqJG8HcTIxVoe9CkukNj9dv3COYE96PcCQJK2OGV6NBQr22IpaGQc6Kn0jfyh1A7bT04wxTFkm73gWI9+Qo/+plXRzntwBXgW7MXx8G+o48b+QnvfNwHivUhYqcIvJPd4IT475m8VQeopDf4d1kzyHQ7qZQZXnZdNlUfXLKUJUCHY/mSZX+3phBjLClIAQbQM6jdms6ZClBcW5XLkRsQzC3epxBBeoOiVqhodOz2XZO0GU7qvEL/EcOEZxGTCrRHfXaOrL1pB44o5qWqRU9nqwEjETCmLlTeZ01T7jjrka/oiSaYEvco97d
 Fel7nfgd
 zrY+bsWRzMrQxEKp/UHAQiCshpSmnwpGU3mc48gSlQkkrXwp0AgWXSPuzpnhtG64AqiA4ITnBwI05iFBmimf2auer1N6fUUUTE+ypyRl+WAGglte7MGrXK8p+yTPpfFOaHLymv9A7iWjFpfL36TTBiq7Xj9NxxT1ZkSWoe/aae9CHHP49D10FjoMZNWA8wgfEN/Sjs33YUVJSWUe2oNJryj7cyGv9AfCsK6UT0EtiSgjmu189IMGSfBvndlE8PMdOEcccZYcGl4W0bv3ZcvYQ0E59ONX62Q6YyAqXuFxWohArzgJVJLH+0tpPBCzeNraGUH3x1SXKQIbb4g0AEfhfYkQTDQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To use memcg_page_state_output() in bpf_memcontrol.c move the
declaration from v1-specific memcontrol-v1.h to memcontrol.h.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 6 ++++++
 mm/memcontrol-v1.h         | 1 -
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0651865a4564..7bef427d5a82 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -950,6 +950,7 @@ static inline void mod_memcg_page_state(struct page *page,
 }
 
 unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx);
+unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item);
 unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx);
 unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 				      enum node_stat_item idx);
@@ -1373,6 +1374,11 @@ static inline unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
 	return 0;
 }
 
+static inline unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item)
+{
+	return 0;
+}
+
 static inline unsigned long lruvec_page_state(struct lruvec *lruvec,
 					      enum node_stat_item idx)
 {
diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index 6358464bb416..a304ad418cdf 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -27,7 +27,6 @@ unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap);
 void drain_all_stock(struct mem_cgroup *root_memcg);
 
 unsigned long memcg_events(struct mem_cgroup *memcg, int event);
-unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item);
 int memory_stat_show(struct seq_file *m, void *v);
 
 void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned int n);
-- 
2.52.0


