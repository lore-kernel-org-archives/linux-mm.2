Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4087D72357
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 08:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13AFE6B0468; Fri, 23 Jan 2026 03:56:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FC866B046A; Fri, 23 Jan 2026 03:56:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 007BD6B046B; Fri, 23 Jan 2026 03:56:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E2A116B0468
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:56:34 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B56C7D2B3B
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:56:34 +0000 (UTC)
X-FDA: 84362622708.20.85597B5
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf07.hostedemail.com (Postfix) with ESMTP id 23E6C40007
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:56:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NMD50k4b;
	spf=pass (imf07.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769158593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mRzQHCKarCYBi7G1xIo0Ho9ytROzsvuCqz+L2Dk75mk=;
	b=o2SKevThXWWtkUaCiE/kYyiT/FFhnOaWDyaTZ502OBURf6IrSPJiAdtTm1Eg+jKSgH4WuL
	2no++4HU4135DF4NZAY04vAGZpixXHS++nRwASrtbi1WHMnv2M1RsBb+HPfXV9Mbcp2qpQ
	EwYhJly4d+Sx0/4tfFEdSqAUdmzwbJE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769158593; a=rsa-sha256;
	cv=none;
	b=z1oyvywUMq1r68gZ56o4i13pVmeOa2tNx7LDp+4eTvfMRFR3FP/reCHjg9A8jL12GXKkN3
	UKhIjmRRzSM2C2B23n9+lLJICphIfQt/wh6jlavm9dVjzKQpbnL8szc7pE33L4KSxt5jJo
	7ippe/5lldoI7w+B88KRFqVffxFC9Iw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NMD50k4b;
	spf=pass (imf07.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769158589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mRzQHCKarCYBi7G1xIo0Ho9ytROzsvuCqz+L2Dk75mk=;
	b=NMD50k4bUm77bwDcYhOB0EpujUCmId6LC0LnmOQ+cN7HRcsMqcCVMBNhz7FEmicI88cTzs
	fCiKD/e7ZUORx7uTYhwqmUndQiS7GsgwVJdfUZ4G1Wtzv8/QnHJOyc0nCpr8f/K4LOtplX
	e4UW3EsGa7P7cP1zRrhbOsTQC9UwH8w=
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
Subject: [RFC PATCH bpf-next v3 02/12] bpf: initial support for attaching struct ops to cgroups
Date: Fri, 23 Jan 2026 16:55:20 +0800
Message-ID: <e34da0fc270eb7cc41f6b388026f503799541675.1769157382.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1769157382.git.zhuhui@kylinos.cn>
References: <cover.1769157382.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 23E6C40007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: d8udboh57174ethnb8bzuijrasdwgmg3
X-HE-Tag: 1769158592-663252
X-HE-Meta: U2FsdGVkX18woIMIMB/RQk8/vvX9rmKeUYzhXBYHcQem0DNYWQNhfaQm1U5TH0YtIqxXyv30t9bwLlbpoSeuReij2j2f9qASLrznZNvDCsUfP67w7wSnHpCgvllBDdD1IFsqCT5fKJhbwlKelquRfVZE0cftPetUtu2dYl1PVwxNuIq4mvEbJV+a/2CxXGLPLreIbYkcZsTj19CjZpaxIL4N9feaL7iGO6D/5WYmNlxJ0KvBqkd3xUiKDgu40opXIdqxE6VsxTOs+v0obdB6lerqiSTVW+xXwEqKuaICKL7AVUzP8vIxGf8aZCdjWjEXxaDC9MDNc1KMCdLZ8pCpwKzAGH6oplCS0Vg8Qz40BtDDzRkHXk/KWUfnX/JIGsxhd+D3Q4fFk78fGicUVoyY6TmZETExzw7RslnVtXEHxMIymlK2mz9I9tiWeenCMtxQXB2K+e4n4/nmls48533dmgEL7N0vCV0ifX1LSViRt3KXhVk6khcEjAi3FoAVLDu9mWo5fc4JPITlSPpvj7X/qxTvQMrlmpYIQF325RFpVK8+kEBQu2++9zC8tJoTT8QQBXDKKX8etGZNnEzs/SXq66G5mkRzh5I9z3cKCeSVnyPe6yGhsyY3nA4CUGfkgJegeO5RRQMuOvxrNhRzzYwhd7veNhw7sfCBAzW+wNjgot7nj7SQUkT1PrbD6ZMFH9avYqXeetRxqvhHtAqwM4TAWCDbG/REH+f8L6uv76DEieono887Yc/I22YCmmZcmY5FY3+ZhfKlbGh0fuyW4tLfPM030gImFAivSnaHLbXa12ilVatnualVsakI5doCrhG/H/EpWHjmz28xuUo/tth2JhGH7+NBWER5xlheQx/N1VJ6224ZNIDoIjFu8cxGachomLSJHfSotNdMyX3FO1CR2Q1vw4Z4jPQiADx8qFCC5U5SSMuC1iB7j30CT699PVC1qbliysLb1oruPRS2rG5
 4JVz8VE1
 /uRDujGtoPqK6q8pcHX2lr/FQ9nR/uD1vHdq5h8ms2gC6ND+cTs3c1wTKcspnrvGYu1Zu7/z3ENoy7ptNqlIYXxT1s24zE9ECWoHIddF+9EgWG5+prQRBkEIkY+189C5Eyyw0nICfDUs6SbPtU4uBOpxUjK6w2V5l7dsuJRB8WEzBVLm21QQalmwH8cQIeRbqqwXN+u4nRnHVUEWqgX73xIaR78bMirdRamohBXFpjeSeeBaSUWRD/M2Y5KziIgEjQMv7rPG8+y/V2CQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Roman Gushchin <roman.gushchin@linux.dev>

When a struct ops is being attached and a bpf link is created,
allow to pass a cgroup fd using bpf attr, so that struct ops
can be attached to a cgroup instead of globally.

Attached struct ops doesn't hold a reference to the cgroup,
only preserves cgroup id.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 include/linux/bpf.h         |  1 +
 kernel/bpf/bpf_struct_ops.c | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 031682f1ad39..7c15bac782fc 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1885,6 +1885,7 @@ struct bpf_struct_ops_link {
 	struct bpf_link link;
 	struct bpf_map __rcu *map;
 	wait_queue_head_t wait_hup;
+	u64 cgroup_id;
 };
 
 struct bpf_link_primer {
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index de01cf3025b3..f575c5cd0dc8 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -13,6 +13,7 @@
 #include <linux/btf_ids.h>
 #include <linux/rcupdate_wait.h>
 #include <linux/poll.h>
+#include <linux/cgroup.h>
 
 struct bpf_struct_ops_value {
 	struct bpf_struct_ops_common_value common;
@@ -1377,6 +1378,18 @@ int bpf_struct_ops_link_create(union bpf_attr *attr)
 	}
 	bpf_link_init(&link->link, BPF_LINK_TYPE_STRUCT_OPS, &bpf_struct_ops_map_lops, NULL,
 		      attr->link_create.attach_type);
+#ifdef CONFIG_CGROUPS
+	if (attr->link_create.cgroup.relative_fd) {
+		struct cgroup *cgrp;
+
+		cgrp = cgroup_get_from_fd(attr->link_create.cgroup.relative_fd);
+		if (IS_ERR(cgrp))
+			return PTR_ERR(cgrp);
+
+		link->cgroup_id = cgroup_id(cgrp);
+		cgroup_put(cgrp);
+	}
+#endif /* CONFIG_CGROUPS */
 
 	err = bpf_link_prime(&link->link, &link_primer);
 	if (err)
-- 
2.43.0


