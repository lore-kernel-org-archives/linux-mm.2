Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 299B6D25921
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 02:44:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93B396B0096; Mon, 26 Jan 2026 21:44:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 908FF6B0098; Mon, 26 Jan 2026 21:44:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8493B6B0099; Mon, 26 Jan 2026 21:44:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 701D16B0096
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 21:44:52 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3B064C2AD4
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:44:52 +0000 (UTC)
X-FDA: 84376201224.28.7582A2B
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9ADBF40004
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:44:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Rhts6mQM;
	spf=pass (imf07.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769481890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NPd+QwwbuEzKgn4FQGSv0lyG+/wois/P4FfQeHoWF5A=;
	b=LbrNH+DnMURJoYpfXo3HODd0eWdE5IfIRHc8Ji8SX2G4MqYMOkNSx5p+PwyEPcCijOajzo
	2iUnDjDjf1+zGpJYvL46boiyofBkUYdrGPJe4XagkjhVhw/Y6QogQQe3ik+ayvbS6BZdNU
	VMK3KKnkOZwu0ohuOiV1HyfYOy1KgxA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Rhts6mQM;
	spf=pass (imf07.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769481890; a=rsa-sha256;
	cv=none;
	b=7DwAZlLjXsT0LgE7+Dfx1DeeFsPZDwqCQSbfjBbb2ftu2lCL3n9JKLzTRnX0fRoJ6REJyd
	sG/2HMFVHJvXAoqBgPg22ISbUcM28AXhna0PnDp7z4xu7wCECSnKWlHEoiSAg0/fX2P+/i
	pqeGxnp3TBK/MSp5GWOcLCcOXvfOc1w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769481889;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NPd+QwwbuEzKgn4FQGSv0lyG+/wois/P4FfQeHoWF5A=;
	b=Rhts6mQMQZZxrxw8Xk9BEvbK6o44XNbmmhK472cmB7CuGwjezMpdne9VbrgkQ78D+ePRvh
	iuPRgl1aJc5D7xd+Q2FexArub5LkM4xpCa1vLG6jo2/FLTi+r5RqwIX/LUa/N5Y2AuZ03I
	Ls4PTjaEgPnGCW19UOoQ6xc+pTAwkPg=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bpf@vger.kernel.org
Cc: Michal Hocko <mhocko@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH bpf-next v3 06/17] mm: define mem_cgroup_get_from_ino() outside of CONFIG_SHRINKER_DEBUG
Date: Mon, 26 Jan 2026 18:44:09 -0800
Message-ID: <20260127024421.494929-7-roman.gushchin@linux.dev>
In-Reply-To: <20260127024421.494929-1-roman.gushchin@linux.dev>
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: yrwok633rshc8f3dkf6bgkdoq49npi8g
X-Rspamd-Queue-Id: 9ADBF40004
X-Rspam-User: 
X-HE-Tag: 1769481890-788249
X-HE-Meta: U2FsdGVkX18gDLv//O9RBpIsbEmEaNluKoY2K79y2DDfTldHmEu3s2jPVaqdO8lxjJ/VBTWbMCw3LlKj/wsCFxy1kmLp3NnNCMrr/M7dKSPwPuhOd6cjXTTJOKalONfIof+oVz6jszoFV1j7apcuCmchnwg51MxuAHEG7mVUItCKERd3Lge1WkYmjD8Z6wAfZeOFpbqdH0/yJ5p62+GnLKPVNlGdl9JYqq4MrIYh5rALJGW4N7m8yxbghRHyRONe06CrjO3/ZFM1aOVWMkgVsdfzDNySuVJvcb2a7T8X2knTkZDx62iUuN8rxVjw1FRI6U5N7Axqjlg4GlOEnO2eRtvm9dmwgLmg5SiyQSkKah04GmXfkP0U/3nXj3SF92fageKwKqosAeYUQ0bT1FTCOso0T88cj6s2ezpbffoUBVfgWxe0t6JU41An4xDsxuf/OMJxytsv78sIJ2+biKrRL69q3tuaZIZ/F0StHKsNsqRU+0eDy7yQo19y3G3KTkMcr4Rsurte7lUtfePNfTlk/H/6LCWQxyajGb/0d68VlEJvU4M7gXUa68Rux94/NLdrOzQYkf1cQgdwzZIS4UCB5f2q6pzY1wgg+qlIr2FCHD0S7SJNEzanmVVtaJcTWUVu3B1tibZx0WzDkr/YJfKwwXDM+4wCXqTH3774QqQ24OPasctmvelOHWEvOYISmEJ2AcoAuRsNFqIwp7R/UiTClNnerK1imYRb9vNKb2Gs4Z6/wees6f0brEDFBuLh7Pss0A0BazU+p/hWCXpJGl/BZXO6xDnF6cTYzMQ15w/QZkVW6CT2d+7Iarvl1X/Le4ufbC4/fb7/BQMqmGzgpHnwuqR+TdHax+79O/klTzG4MpKukkt5dvWMyNi+E3iBbU1WAjD1tFNC/3FxzvVxD96pUUFIqj77S4s/Iztf0azn752PzynwiR6jp0qmUbTuUP2Yc/bDYo+ls4DON1xShtN
 0b4iZTsO
 Bzr9zqKHk0tVmNhYS3hGQY9KzRgraJ+GpUXzZKFS0Sgg8MTRbSgp2xRErW4qfAocABwMKl6VHUO/ngyvJ6CnYq6oIgwZleexjrgct3RK5tMO0HbZj6Ln6xlhbdytZMA7qMVUBfc2TOZYw991FX7CoIJxjg+lbQrQLrBoSAHbEqYAVWZigKJ7RtaWCYq1hRPdgpe60nKlAXNovmyEKsI+IFezXVeBRrMkTpT85xOlxJxwmXqExUvj9pNvt4ts2fAPx3DhR+Hb/VJjxgJGVimjD5fbrnv1uqWtiT3H06saf0YyyFQ6S73G83XkHMXhIBTL89VbeWEz1QWVoqk5x6Zr8ishfUA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mem_cgroup_get_from_ino() can be reused by the BPF OOM implementation,
but currently depends on CONFIG_SHRINKER_DEBUG. Remove this dependency.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
---
 include/linux/memcontrol.h | 4 ++--
 mm/memcontrol.c            | 2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 229ac9835adb..f3b8c71870d8 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -833,9 +833,9 @@ static inline unsigned long mem_cgroup_ino(struct mem_cgroup *memcg)
 {
 	return memcg ? cgroup_ino(memcg->css.cgroup) : 0;
 }
+#endif
 
 struct mem_cgroup *mem_cgroup_get_from_ino(unsigned long ino);
-#endif
 
 static inline struct mem_cgroup *mem_cgroup_from_seq(struct seq_file *m)
 {
@@ -1298,12 +1298,12 @@ static inline unsigned long mem_cgroup_ino(struct mem_cgroup *memcg)
 {
 	return 0;
 }
+#endif
 
 static inline struct mem_cgroup *mem_cgroup_get_from_ino(unsigned long ino)
 {
 	return NULL;
 }
-#endif
 
 static inline struct mem_cgroup *mem_cgroup_from_seq(struct seq_file *m)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3808845bc8cc..1f74fce27677 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3658,7 +3658,6 @@ struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
 	return xa_load(&mem_cgroup_ids, id);
 }
 
-#ifdef CONFIG_SHRINKER_DEBUG
 struct mem_cgroup *mem_cgroup_get_from_ino(unsigned long ino)
 {
 	struct cgroup *cgrp;
@@ -3679,7 +3678,6 @@ struct mem_cgroup *mem_cgroup_get_from_ino(unsigned long ino)
 
 	return memcg;
 }
-#endif
 
 static void free_mem_cgroup_per_node_info(struct mem_cgroup_per_node *pn)
 {
-- 
2.52.0


