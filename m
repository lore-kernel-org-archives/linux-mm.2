Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0092C88E78
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 09:05:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 656106B0092; Mon, 26 Jan 2026 04:05:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60DDB6B0095; Mon, 26 Jan 2026 04:05:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52D206B0096; Mon, 26 Jan 2026 04:05:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4247C6B0092
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 04:05:50 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CB8B58C3A7
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:05:49 +0000 (UTC)
X-FDA: 84373532418.07.F3129C8
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2670B100003
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:05:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w4Gy5WcZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769418348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qJzfS1JLGvEK+FxWqw8ITpq79hNz1KKD0GGXddU0FBc=;
	b=scw1Zt96lGhx6TgYLJCrD3KnmWe6+fD34WksgLGp60v+SyIVMILqANH9aJmcF8lpwq+qbt
	vMVKn+zmOaSbgWA2qb4CFifBXwZMIL2KULv3s/BlhEJlWrZEdnG35cGQCOxu/dBBb5OVGo
	EvAAcnB+l0tEPqQALs//Up54K2APWEI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769418348; a=rsa-sha256;
	cv=none;
	b=bq/9uowMhZHEf753LEpuQ2xkP4gfkeJsfnNG/frHpx88tLK/wtjpvIScvlc9uUzcuT3wCW
	ungrdNjHKJBsgVPumjKSee+Nlizy97nMMvnPQSdYpjqEg2WYFJp7IAFWbmJuqeAgZzRBQr
	dU0QvTbTisDgNDQ/+IIMJ2zlJd5kJ3w=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w4Gy5WcZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769418346;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qJzfS1JLGvEK+FxWqw8ITpq79hNz1KKD0GGXddU0FBc=;
	b=w4Gy5WcZtlDZYkEO2TO4A9miXEi+bQ9j+mJmKZdHyxjM/yyMcz17Hm145nGY64rLCBLjEZ
	OaItV++yLzC5YIxcjk5+oVLXZKp0JTibbA0TJipVv9n5lFyJwMExVco1S5jtLB8/LsxqW7
	xJQRKPMULmQa2T7sm/1Q/DaH5knBswc=
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
Cc: Hui Zhu <zhuhui@kylinos.cn>,
	Geliang Tang <geliang@kernel.org>
Subject: [RFC PATCH bpf-next v4 06/12] bpf: Pass flags in bpf_link_create for struct_ops
Date: Mon, 26 Jan 2026 17:04:49 +0800
Message-ID: <6b2d4fa8e5209d363f553d7851d5a1156137d9fb.1769417588.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1769417588.git.zhuhui@kylinos.cn>
References: <cover.1769417588.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 2670B100003
X-Stat-Signature: of8y71u66qett7iuh8i8o3txdkhp396b
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769418347-315678
X-HE-Meta: U2FsdGVkX1/IHDQhvQgNDjLu2uwMjmouAMbS1aXytQxylw/eVEGmBxQdlM7GH60a4eDD4rufOvkkn+IIh17AXIgvlS+fM66NgXKJQSpLi4Gh++lrM0FWZYGQwoy9JG7mIC1CZEmGeQw+uv+rod6h3z+DhkFa/AZPkVphxmTUaNDYKz1mUh9NBWoYFbSQ1G9/4KBVytjbviixpHLjtmRVQbr+7EicbN6/Rgab7YrlKqzSwFnXTFtclJ0CfCRXigxSZ65bFBUCoK2UyJYiAtoZZaJt0F4/lkofIi1FNARXt70OhKUYcvCl7NB/ZrY30VGCBb93106i9U6BBHc2CTn00sk43ObRNuJmTEKD0XRMqT4DjSThj0Cm+xjrYRfiNFGuEKPY/zrYEYVS7tJgmkScOYtqGRdkiWn4eAadTC52Ru+Q6n/07kG07usADwUTb6JBM2exUdiiqH1hrnBAFag1vZP5X/wbMEmF/xK6pboZbpHIYYy0yb4FUaiO/h6uZFHWaeAK2aw9+cQJY80vifgafDStFqVvhWYi0OC0zTRkEEaMSRtfJEKaVLGBGS9n7fm7lYas44mVio7Xsp0WfZXLHKnO6v5qtRuWPgseTT4mNHa1kombynyLrOYgX5/TZ/vpz58yL85g3Em6A2t9DyXYEbbSXVkVUR3EiS5o0e50ln/D8niLTbNNEONfL2jVGL62jkeqtmPC0yepcXk0iJhjjNHFkx43j5pSUrUrBgmCnmAQ8aHARUohBpSB9ZAkulJ6dwsudofp3Qbisbglmex1U/XN6gExP1zxFxalWdHv659wTsMfjsPjxgFph/YB8mZxxGBDWjI/4ZR/jNY6NkrfIXeRNCqsk2ps7Yc1snkyCMBIX5imoJmcj5s0G9EIYFYqHN5lZ4ZG/zF/DVDPyfzd2Ogco8H1L1wqNPei+1I1YH2hH83xq1COTRxV+qXg4ZXIBVOqmLo1CsXiYQE88xZ
 PNi3/UVO
 EZkowJbpy/B0tbqO5j+HtiSYyWhrIkvT1lBElmlIf0BCEKj8xRgmdIn1I+GMj80cDpv/z7p+MWLdTSrh0rQEyRTI5qPs1gdtLkKAAQiJpyV+1Rs5effOAlAKfhsBjszR8T4qkUKZkP7b2yG4pZ7Nfh5spRpOhVjv9Y8e8vgFoqqXg0g5u3equkvLTllqNGhF8LX7NR2Is4YInbPNU8ex7/G8wCiHFngHuOTTTi2Ul8D+1B0oZWyEy6uEWFYYOXThYOFa3NOhNzPcJ5AqAS9DBUKdVGQbnnQGJ7ohXlFgvAb/LPyXD9p8XXCAAPk4X8IMy007b8idI7rysRKkJeNtj/topug==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

To support features like allowing overrides in cgroup hierarchies,
we need a way to pass flags from userspace to the kernel when
attaching a struct_ops.

Extend `bpf_struct_ops_link` to include a `flags` field. This field
is populated from `attr->link_create.flags` during link creation. This
will allow struct_ops implementations, such as the upcoming memory
controller ops, to interpret these flags and modify their attachment
behavior accordingly.

Signed-off-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 include/linux/bpf.h            | 1 +
 kernel/bpf/bpf_struct_ops.c    | 1 +
 tools/include/uapi/linux/bpf.h | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 720055d1dbce..13c933cfc614 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1896,6 +1896,7 @@ struct bpf_struct_ops_link {
 	struct bpf_map __rcu *map;
 	wait_queue_head_t wait_hup;
 	u64 cgroup_id;
+	u32 flags;
 };
 
 struct bpf_link_primer {
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index c807793e7633..0df608c88403 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -1392,6 +1392,7 @@ int bpf_struct_ops_link_create(union bpf_attr *attr)
 		cgroup_put(cgrp);
 	}
 #endif /* CONFIG_CGROUPS */
+	link->flags = attr->link_create.flags;
 
 	err = bpf_link_prime(&link->link, &link_primer);
 	if (err)
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 3ca7d76e05f0..4e1c5d6d91ae 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1185,7 +1185,7 @@ enum bpf_perf_event_type {
 	BPF_PERF_EVENT_EVENT = 6,
 };
 
-/* cgroup-bpf attach flags used in BPF_PROG_ATTACH command
+/* cgroup-bpf attach flags used in BPF_PROG_ATTACH and BPF_LINK_CREATE command
  *
  * NONE(default): No further bpf programs allowed in the subtree.
  *
-- 
2.43.0


