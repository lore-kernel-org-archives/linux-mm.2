Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8DEBD72350
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 08:58:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2957E6B046D; Fri, 23 Jan 2026 03:58:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 280E26B046E; Fri, 23 Jan 2026 03:58:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 158DE6B046F; Fri, 23 Jan 2026 03:58:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0381D6B046D
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:58:35 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BB76E160200
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:58:34 +0000 (UTC)
X-FDA: 84362627748.01.103AA61
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf30.hostedemail.com (Postfix) with ESMTP id E355B80005
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:58:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=s1F4hAcN;
	spf=pass (imf30.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769158713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MZDHd5qG1jM6uT5/JnPwA06VDLOpkfHtWx6qC88p08g=;
	b=Y4R6rwmY5MgfK2M0KpOw+g7eprP6wmFCTUO3zr87eLJxEavXyGdGhpz8NRMeR7Kh8/EEzE
	JEsLJ0KtUmqYAMu3FHcjTDKYup+TWTZedFbaNnKquYhNWqyu3Lop0at8PF8mU19KkM2kBo
	MIM39/wNWjc8zU6HyUjfBBCfRfbZK5I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769158713; a=rsa-sha256;
	cv=none;
	b=SfkDX2WyYF9cnwaICSLLKfK8FgFs7nI/kYRoZgLQmwyoVkIzh7M26W5wcikal8cSJaoPQN
	y3gZKRymKmcZIscoM/fktCA56kr4RIS2wi/fqUg+GBOgIDcKEuCHxvZmeC+Ut2QHe7lUS+
	peQ3yIB+hTHM+Ml/OXZ//tJ7xhNU8dE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=s1F4hAcN;
	spf=pass (imf30.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769158710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MZDHd5qG1jM6uT5/JnPwA06VDLOpkfHtWx6qC88p08g=;
	b=s1F4hAcNIr7FO7zIIhXOc52f/ar923r2DlaIfnkq9t9LXEKwLC/zJvy/Jwl45AvVrjQ7V1
	oM0I6+NJkSSr0xpaHsAfkzNd+jZZOEZBJTWEjJ9HsKumn8IOWsUJTw6yBQ9aPRHuFekepj
	Sqw7JE/M2z8LvOE2rpvDvCmlnRkH+nQ=
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
Subject: [RFC PATCH bpf-next v3 04/12] mm: define mem_cgroup_get_from_ino() outside of CONFIG_SHRINKER_DEBUG
Date: Fri, 23 Jan 2026 16:57:58 +0800
Message-ID: <f627edee18f43dbfcd4c2eb06a8188e88dc6bda9.1769157382.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1769157382.git.zhuhui@kylinos.cn>
References: <cover.1769157382.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: E355B80005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: yeyfio3wo869jid6wtrpzkwpo1ahni6o
X-HE-Tag: 1769158712-221260
X-HE-Meta: U2FsdGVkX18HuJDLEvGVoxWQw5AbOSuVcB1AdpH+YuEeDSzNcU2cpn+IA9joxOsr4VGvy2QgfMfIX45LZnrxJG1zS8et/2LRDWmM6drsoH78pfS+kTr05qqgzgeXosa67FUdecaEA8RxeOwQClpzDCZGM1dfMbsnaz5nMm6SRiyxot3/ROGv3e0sgzAV9sn/qZG7Zjo+ZTj1Mnsaw5nUylqCSygbCn76y/+1XKfK15wm4fTJzBp1/LJ37t8Si+qJKsuxnSR+cYDo7jxngmrH9Lc7igRgRrTrki8ka01aDIE1L3W24ILRg3gzEgUJKsIL3QzY/T9qrRncRiOe9CD5gZb24/L8vA7zv00BkIo95DjFCgsF/kt4sWgcxLt0ZcsJYQIj5GcaiK0zKHEk0Y1CuXQEa3rsNuE8XrMSeHzYn2Q1a+TEHGOBi+Vn5C98pOv79ZcEulpUcC21fJ/t7PUWd2XE+F8d+s/3dyg2mTcXocDAehYdTzT7UYaOkhxrWLmX1YfXMDj0ZT/k4ic07RRUDnoN6CLycWJm36ZHQ66lK5tLUtTjChSpXYl7ZY4iifuYU11TBmt02xZffGBRwwme83JWamQ5lBpt6HV+ggXaEkR/xMysRKIx2TBEwYqbYNUwHJmKZMMLQqWiPqXz05UGEIRRPiEi2wKY9wVTUwZcMzNglrAlzq/xvTWZp09z6W/UDvIj3fzDBLdVKt9DUpncwsJe2tMWqESbi6nOrD/3qcz8FTi0RPfTrF1XZ+0jZLQ8sEjqYo2ilP6cKLl8JgH3HnihQPEDa5IWy/nIJIPxkG+KgdlG4r1jBtJIAA39Q2YIHbcGX2wvZfo7bhHnaHF0w8jYWO3qfXNEXOFaV9Tnrluh5snqy4pvRfgEqehRVRnVGTsWUoT8C6CISUCh00jGLxVRGqgxrwRhdX4DO1aewewz5ZrXBhRrLXO6YaLnz90wKH5Ct9G5xLyB5ZCFw+Z
 U3Jx86o0
 tbsZVm3yscFbLWfVQWcxNIUnTXYmppDZge01kC1nSQRmmynKzz1rX0+2OJDwpqmdOLfw1JdbdIoV2notgErZZu0U/4ZO4vW1s2lJ1k75Xv04TalcJjTNp2mu+8VQY9S3dW6BVbBGpIQDUt+VvZlWQv8RBsSuz8z5VIJOrFgu5Yz1S6Ie+ZF/kuVfawzuLQ8cZsqrrCPOvUYr2idqI/LGctwP9wATNhecHNxM/u60xNYi9UuFRb+v6gyfA/C6U6eUoPJdfyVojUfFhCSoIwvDL8KThAsKgQqBQQF90RzD9IU788OtTwR1XvPeJRg==
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


