Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27F0AD2D8CB
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 09:44:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 746636B0095; Tue, 27 Jan 2026 04:44:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F0AC6B0096; Tue, 27 Jan 2026 04:44:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F36F6B0098; Tue, 27 Jan 2026 04:44:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4ADBD6B0095
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 04:44:09 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C3C17160BAD
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:44:08 +0000 (UTC)
X-FDA: 84377257776.30.54AA7CF
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1E27140009
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:44:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pCggPyhq;
	spf=pass (imf11.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769507047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MZDHd5qG1jM6uT5/JnPwA06VDLOpkfHtWx6qC88p08g=;
	b=Rks8ZwVZw/vE1MzcK6XZDjErZGuAVTJ7NEE6vTKsItLo68fp2qtp5c+hfEzzfx1SAc+Y/5
	OTbxT9zXo0z9oMnOAuQPnZSVNzXn0/IGq1dh7XnRMngaWSCYC8pKdRVQhaa4CkDcLZyLrZ
	l3+gp7EFl2qz4YExrZ26AQTGWAVN17Y=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pCggPyhq;
	spf=pass (imf11.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769507047; a=rsa-sha256;
	cv=none;
	b=RTFhShH4vR5V/sI0t/KfK/+QhoTrCyLi/RqDIG8909mBJ7RUI1hv/7DZgYeLU+h22V1U+y
	ZpkKKRcC1Fs5qfBP3+oWJaAcUlc14WdEwIsT0wgyWhE55Nt94vE3BEITPpFytWdmXAyZmM
	czVQPic/ssEt9FzXUMIiBc588oG/ETA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769507045;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MZDHd5qG1jM6uT5/JnPwA06VDLOpkfHtWx6qC88p08g=;
	b=pCggPyhqpd99immxb6zujzAvZczggMve7iRzC9xJBttxhuOfxADBoYXpUlm00tpzzWQwP6
	wYQTe7O9rSNR0Q22G5GpJOnPbsyFLUYrNH3wmnLmIBORZ/zKW4lTXISzBudp9cQCKnmp6n
	7IosG+lkEdDwR7eRHrhJH/2v03dH0Vo=
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Hao Luo <haoluo@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Jeff Xu <jeffxu@chromium.org>,
	mkoutny@suse.com,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Brian Gerst <brgerst@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	davem@davemloft.net,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Amery Hung <ameryhung@gmail.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Lance Yang <lance.yang@linux.dev>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [RFC PATCH bpf-next v5 04/12] mm: define mem_cgroup_get_from_ino() outside of CONFIG_SHRINKER_DEBUG
Date: Tue, 27 Jan 2026 17:42:41 +0800
Message-ID: <c7dd362ee9a607fd74416b85d69a4f8fd246da13.1769506741.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1769506741.git.zhuhui@kylinos.cn>
References: <cover.1769506741.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1E27140009
X-Stat-Signature: ddt4dwajasfd9jauq59zc5ja8niazwyd
X-Rspam-User: 
X-HE-Tag: 1769507046-47431
X-HE-Meta: U2FsdGVkX1+cSoliGSd2jA+nl/lr7FooiVhW9rAy5tgc/YHGa4sIxOUjNMD3jX5r0jOqCRpA3kQN1WcMRmBshXW1aU4HnFT6d0V/d63yHhKnfFW4tI1SU6iDPm3c+msgEI1sI775Wjt056FH20GTe9/qfoMQNC327OT7Y5clvG9Vo95u9e9cC2RLKQq1LZQK7uT3A8uI2v9Rk3TyRm+X1TNV6O9Qq8XoUiOr8PKJr9AcxBj0A2NqS/GhBAlUL+XmaoROyRMbvq36Wzu8DLKOlinT1OXTgONMDF087tghfwjvx1F0finyhHF+jojU9l8FTRZRY6Hc3NwYMNQGKmzXIfgzKNsBB62kwzHrHtuhGcycgFZsCct742W2jA9FhrTy23q/1AEBlxMKhiJgJhC1YIrrS0jtULbVqA53cv7UIC/4zxF94PbIBWgBmZJVQDpnKSRcMkBUB9VnmM05gtX861LpT2hRN8v5to/Gpr+EeOt0C60ko+g3EHoKegZHZukrf13GvqlfKhOaCGiOkIOhORmu/sbO+QXW/Od5Er2FuFXMQuguNFp+70MNv+kJ+mTWdv72oQWyPztzyH8dEgkHZoGkKla9Hvl6U1TTjdwCGK10cLLzzwOYbdqcSuwpj6Xgk/QsKYg5bOi3a5UeNuG7lJ8ER/ghBuyvjBmBZ85OZ3SLWUh544NrdSOkgJpJof2HuCITWuIurilVUlI/4aJHG2hRjDc1ncYNKRWXCDBk1562/29hKMho7IUmJVnwrW6gscd4g3zclVmxYpbhkpRpfAEwE9jckhYLUiTWUbhrp+Al/DfeBmogg0r3aOQZfsGl3y3DeC794DYNsX1qBgN+Y/I5rCVXD07gsp4jNff9CQpJcoBlPOZrVzK1f/UOsO3+sSnBiTRh0Q/j/1BIUR8Gr+yL8jhUPXeQ73Nl2ybBlSVO9H4MpxbTN3lbzfZ4RozSRFOy1rXp+wd/XL6B26e
 obPy20cR
 XPe2YqDzAYHvjeH2CKHC6uxOmPTDabU52ideHdqDvoxNkDWlqDNQ1Z2hxOJqTXtLVobWnus6+BGKpUsGqBz+BWbJkxgE0pjB40Z/jvabPRoLXqs2PhVTcg9A0GezAow5cxMHZI2DvzEdYNm5WHusK4ci+DuxiZupXjILGQ25RAlL03rsNX7hcQ7cWVp+Kn+eXNxIFqQlAoe765jz/uuV8XbQhdfVXbCYSkDS7uMbGK6JKgt2v68yuH9iPpi9kC9xr6t5AnRbFuNFuOndAE2k4zmNpyZKcxO+y1er6HOqy4I/1F8BM/kMdIlOUog==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Roman Gushchin <roman.gushchin@linux.dev>

mem_cgroup_get_from_ino() can be reused by the BPF OOM implementation,
but currently depends on CONFIG_SHRINKER_DEBUG. Remove this dependency.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
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
2.43.0


