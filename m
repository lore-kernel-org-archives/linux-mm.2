Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17423E83EE7
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 08:57:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 788346B0092; Wed,  4 Feb 2026 03:57:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7456B6B0093; Wed,  4 Feb 2026 03:57:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65EDD6B0096; Wed,  4 Feb 2026 03:57:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 53DBF6B0092
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 03:57:36 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E643A1406EA
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 08:57:35 +0000 (UTC)
X-FDA: 84406170870.13.B124C77
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf15.hostedemail.com (Postfix) with ESMTP id 48E0BA0002
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 08:57:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fJcycJ2X;
	spf=pass (imf15.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770195454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ycrFyw6aXaYmQPmQruEJsfLSWjPHoV8ar+xnlNHnd9w=;
	b=Q4jg68xSWNY4see4zQ1aCSDlM+0RQQbmbK5PUOL/tbRg05IGXcN8nsnaDJ6fViQS4esKeR
	Vtl4kqrErzG8x77WH2KtdKDeJKrGmD8SA7BI3mheEI95tTfw0kxn6QrNggON9iNwEMcmhf
	aHAI9C10EHhqE9prC0ZD0/U8PjbaZKU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fJcycJ2X;
	spf=pass (imf15.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770195454; a=rsa-sha256;
	cv=none;
	b=BKbPdQ9F7jRnAzpmUXxdDr8CvB+ZJ7X3Mh0FiRbzxYF9qviMwWIxeY4tU8p+ignHc/H5B2
	8hxJ+TYJLrvJEIcDj8V8DksSqXUOSEWU/lJDV0CAopQhTeNQySqH1R3mCaaOekcMNDW9Yv
	d7Dj2kv6nPTPTtFfVn2Rc4H1cfjSMQ0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770195452;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ycrFyw6aXaYmQPmQruEJsfLSWjPHoV8ar+xnlNHnd9w=;
	b=fJcycJ2X9rvYYkieCQ2yF+bDxhFJWsVBjVISmDnDnsCv/zx1kwxX6wGWFsYkte5c7bZ3OR
	k52PQo0K06QaemtcyTAwbomydY8NZytTT++M5okta4pi9qhc/4LM4sTWrQ9W+NLM3YNKMI
	IiJ2at1yBuTGr9ZHYnUZFjdfBCxikoI=
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
Subject: [RFC PATCH bpf-next v6 02/12] bpf: initial support for attaching struct ops to cgroups
Date: Wed,  4 Feb 2026 16:56:23 +0800
Message-ID: <3ddbac0ce63baf8574ba430f307cd542f489d592.1770194182.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1770194182.git.zhuhui@kylinos.cn>
References: <cover.1770194182.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 48E0BA0002
X-Stat-Signature: 85gy6wuqyk4qy43nsjrte5s5j3qbwocb
X-Rspam-User: 
X-HE-Tag: 1770195454-240690
X-HE-Meta: U2FsdGVkX18pcsur124tm1Nzzq2BePKQ3lDbKuEWCkYdMDHtS//XJcitAABe3Ja9w/VFIk+gSLLaEApnFwDbSxs2uwnvw2sIJJCnBt4j8w7V99d5pGcP4IYBhZUhdeE+79aT2iZH5Bi0kJTAW7AzxRl7ler3bShvvzYwFulQy6W4eTg7BE3QDwfPaSQGd0KytQKU3L8OOMgWTUjodlFz1nSaDzXVxW3oqfX6G/nkYFvaSztUYjxrpq+iDOusHyHEJm2ayRQhTbj255dzXYM86Xipf29yq9te1pOooPH303UAhItxOv0+8bdYYNoEDsCZ1raYwIZif/PdDMtHl6M9LHawPJmC4r0yuNSPOxIL0m0OMdE+32ukdrS5edemd9E5MAWtMYvSc3Rud1vk7HvuM5jMbrscs/XmmXbic5wMBBkQrYTXZqwA0r3K9INDhWq9Jm1DrCSGSm4JQ+c7q32mlQApW1fSZMJU9HSYB/rAftEGB3KKcjaisjzB/kmhoWDzWGec4puvKsKHpW+Vnie0nBt/hIqivGYmAp2mMv/BJ6ao5QO1G2DtB2T6rNBhswr61R8nm4Er759e4biIdR7nCX+6ZxOo5+B64lDxpnhFRIUe9PyseNX/Hs1uuUcFAKilN06zHUKE1Cd5i542rlbbzP7OnbXfQbRbDObtrHG4yiDImeZ/5ImEpFf6vde6m4B6Hp7c/EpcMEEF6CJ/1ysJ6QgK5qgpUVVtauyrVepGOqdJPbg/mkdXKQ2aKk6ZVFuSw3KsiiFZtvMRCJXUvMaFf23pxtBha1UCpFO9SSEwFD8db/MKtWskY/Q3GCyTx/qc/B9usAFmYwpRu3gvhmS6Jm/6N1oPnXCRN+Q2ttfkUPGZPb0a6tukpFUatzyqhy5zU+ubE77SoJIm3U2zkxas0VO19WihPy5xXu9dNvAmzveQ6q9S8aWSAtUMoH39NqlgqR1jkur8QU5FQD37bwp
 cZW5BYyx
 tYpHEuST3p7I+GyMGD1QfNgQQBZJW5kl30l2qsIB0XNVRx7EIca7OC7VKanMPte0gZXGaaIZytKsSqhcJHAQH6nVaByp8CmT4934X1KUIrGfFLZAcxu1nr7+gSZu5HNHSkkeb6NMPYXu1Iplq1CHX+C/0GZTbL74ckyL2F2sHcb/EizlDvTAE2Be39eTFIL3ha6YSUtErIgMJj+HW7bJ36zBds6PLgAsADh/QBnweM6wHQkEWwkYhMC0aKDX8hKi4GiDqGTDRKzTApAg=
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
 kernel/bpf/bpf_struct_ops.c | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 899dd911dc82..720055d1dbce 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1895,6 +1895,7 @@ struct bpf_struct_ops_link {
 	struct bpf_link link;
 	struct bpf_map __rcu *map;
 	wait_queue_head_t wait_hup;
+	u64 cgroup_id;
 };
 
 struct bpf_link_primer {
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index de01cf3025b3..c807793e7633 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -13,6 +13,7 @@
 #include <linux/btf_ids.h>
 #include <linux/rcupdate_wait.h>
 #include <linux/poll.h>
+#include <linux/cgroup.h>
 
 struct bpf_struct_ops_value {
 	struct bpf_struct_ops_common_value common;
@@ -1377,6 +1378,20 @@ int bpf_struct_ops_link_create(union bpf_attr *attr)
 	}
 	bpf_link_init(&link->link, BPF_LINK_TYPE_STRUCT_OPS, &bpf_struct_ops_map_lops, NULL,
 		      attr->link_create.attach_type);
+#ifdef CONFIG_CGROUPS
+	if (attr->link_create.cgroup.relative_fd) {
+		struct cgroup *cgrp;
+
+		cgrp = cgroup_get_from_fd(attr->link_create.cgroup.relative_fd);
+		if (IS_ERR(cgrp)) {
+			err = PTR_ERR(cgrp);
+			goto err_out;
+		}
+
+		link->cgroup_id = cgroup_id(cgrp);
+		cgroup_put(cgrp);
+	}
+#endif /* CONFIG_CGROUPS */
 
 	err = bpf_link_prime(&link->link, &link_primer);
 	if (err)
-- 
2.43.0


