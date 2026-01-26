Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF510C88E78
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 09:05:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 415106B0092; Mon, 26 Jan 2026 04:05:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E3436B0093; Mon, 26 Jan 2026 04:05:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C4DD6B0095; Mon, 26 Jan 2026 04:05:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1DC536B0092
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 04:05:26 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D3375C26AA
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:05:25 +0000 (UTC)
X-FDA: 84373531410.08.AE9FE62
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3C5471C0005
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:05:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aDOq1xmX;
	spf=pass (imf20.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769418324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MZDHd5qG1jM6uT5/JnPwA06VDLOpkfHtWx6qC88p08g=;
	b=DK1DA/5zXTrlgqGL+8ZGkbd/Nwl/dQXctJZBQsaBKx7QBgTZaXK0VRLrbuVC0gkS+QiGqz
	yLCq5FBmoytROmXFhOyhxkLuqxEcwMjnFzjsw0loUkRKRXvPpOIAY4fHcPzPqINe7TDJYC
	4pwH3Kb6c85SGjIullI94AhiBSrmqqA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aDOq1xmX;
	spf=pass (imf20.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769418324; a=rsa-sha256;
	cv=none;
	b=V5QON0rM8Tyyh+8MI+9/t/l/jvrRqG1SjrZCH8bVt3QLvx/ZL6Thsec7rRSKH8fqC6pXjH
	+At9yAbt0rM59vJf2aYfCe+dhrQd9FvzknqVULit/avCaFBJmXQ2HkvcQjBuUgxllu+6lg
	CuXX/1v6pBZIF4aGHwbVrpX46hi0c34=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769418321;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MZDHd5qG1jM6uT5/JnPwA06VDLOpkfHtWx6qC88p08g=;
	b=aDOq1xmX1htN3hO0feRYUDc3w9DQ2r1pila9TAuDHs2gzwvwuhQKew3H7l1iGkAqae1m+d
	14ScCeAjq4WbJGmEoYbx8fpu+fFe+XBjV+Zcdr6Mu2ENKnJjCRbVoh9SQf4eVSjSQCwg4f
	MA7hyAoYo1P2OFkMvRn/S3+kwsgAky8=
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
Subject: [RFC PATCH bpf-next v4 04/12] mm: define mem_cgroup_get_from_ino() outside of CONFIG_SHRINKER_DEBUG
Date: Mon, 26 Jan 2026 17:04:47 +0800
Message-ID: <c7dd362ee9a607fd74416b85d69a4f8fd246da13.1769417588.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1769417588.git.zhuhui@kylinos.cn>
References: <cover.1769417588.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 3C5471C0005
X-Rspamd-Server: rspam07
X-Stat-Signature: iu38kfbgri1e1jad9mrhg6ku738a1xyp
X-HE-Tag: 1769418323-218094
X-HE-Meta: U2FsdGVkX1/IZegbY2fMvATEV/ZfBIb8fcbjbNmdpxSbf1YoNMxkpFBmHjt9ppId+4JLhjIX1C85W5eRCCnriNgJutNukwEa8Ys3aGzhWcN4ucFjexnrvfV2PZh2snru5yVoLbx4Ef/g32eaSFSyIIe7guITpD7W9eObLXOJ3oJo6vrgLGZfmH+rt5ZLY1RynqJOWsheY+B19FJVcbhnxz1iII3OGv/nQQ1Cz3jxaWqry8bonqwlEOtG7yzk98TgdIS9NAPvyQxD6x9uecii52CSde9U9GGWW/y8QU2MB27iSmCo13BH8CdmQWhNyHbbHCIf6teGXEfrKfSFdXVvm8GB1A1ok7jn3p6xxpV/k9Ygtq5IQ8IZ4ZM1CVhpoGRamU72Pum8dl4KF++foUl9bCtV4TKPbN+6k2djmssavMQzZ1KblVWEztVaTW5D7zjieG3DwRErWtBsCHHMWQMiDDHCD9QzkqCQcOw37bC3Ab97MlJfeKhZywlDOx66/sMGvRS4ygorvd6ckAkfhx0A4ZqQe3s5gG1B/DvR5aU7WKpAYj4+P6hVJ0puR5FiLP4bwpLH6qtPc+D0P47ZbfCkdqPIyS4ZipJ0SaPdPVnNWo81T9bhBe35BOwXZ939r46gDKO/RNXWFpwI+kS6hpRaSrFW7hYYxrxXMGFYLL6y+7KuSHdhSFWlMk1m+f2050uaXPrfV9cX1qzViuxYyyTbGVRIf75mWRM6b7E4vstksiqnZ4qjlrkBhi7PUvyRLEWLCKADHdZ69aZgyjEXE5UOHrWN0FBoYAZCxvLemDIyBj6Zs2B7DhGq1ejy5/whnRpKmjd0nkqMt48wTpBygqekxH4yJ96w6q7DlAUiDzLgocGVq60fzoNCFd8+rNwonMADK4yHYTcjbcuKm0aL3f6LeuPV53uRdVH9CmPnjrbEtPoVnKxo65VRIICuMJLYGfW9kDd86+XXfF0eVpZBm3H
 LGnoDy+g
 aFH8/90YntRh49cdTTIWhSA/W6+e126KNT4W/EZj3q21k9CIirWrPM4+da+xbH6X7EypNaAvOUJxSSYlp3OMXcPCFXU5g9NNmSf6LC2KcNDuESUlyGsXdFRPscTjM6IuvcfVvo7WqNlfRrWpfdktpuHtPVCbNHegoXKai7fVF0Vk6/pEcfojq8fTiNmdj/ODx5VH6rZp1PStbcDqRjZUZWqdlog0mVpkKj7/SLcvbILZUUn1YSVNak8KDRDHHON0v0uvCegebFxwILVM9W28LEIvkVFjOLdM02O1i/Vw0eO7q6knuLIaMkxsyhA==
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


