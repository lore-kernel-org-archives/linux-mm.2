Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39805C88E75
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 09:03:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A120C6B008A; Mon, 26 Jan 2026 04:03:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CFC26B008C; Mon, 26 Jan 2026 04:03:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DF436B0092; Mon, 26 Jan 2026 04:03:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C6566B008A
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 04:03:33 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 375B01B07CF
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:03:33 +0000 (UTC)
X-FDA: 84373526706.16.0EC07B7
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf29.hostedemail.com (Postfix) with ESMTP id 860C0120002
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:03:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ud2bx3TE;
	spf=pass (imf29.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769418211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ycrFyw6aXaYmQPmQruEJsfLSWjPHoV8ar+xnlNHnd9w=;
	b=m0Qhd8rCxk2xidRruCxeqxdav6yokq1v79DHfjjmAPHUq+a3INxsDoGefzrak8aiEplZFw
	AoJMw69XIIXWLLo6dRPxwZ4MVGE8DwWJe53tnQDJGjJww1f/dI2OPsMg1VBYopePh8q3Az
	viiQVt+/9PFLsgE4TTOmDKFuZivukOc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ud2bx3TE;
	spf=pass (imf29.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769418211; a=rsa-sha256;
	cv=none;
	b=6RCHY+n/ISRYyj/wKFeyS1tlcHfs+k0ipTShf+4eswEFtjM2H2Wa1p1CXI6FBz4CuMiHZh
	zoBpF/6rPmfQRSwBDIcJNptIJEtAfmWsD+5Vci9IAgcYZLPFN0KNZwewX7SGbJjfxSYiRX
	nK7oGnADuzF7wmn+3vzz/Q+Ri451wl0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769418209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ycrFyw6aXaYmQPmQruEJsfLSWjPHoV8ar+xnlNHnd9w=;
	b=ud2bx3TEMtPgGp8z9l0owlnpj/NWdkQzdMWzUV6IHhmPv+afJYoJ7IIdwVRMloPKltQlvw
	FQmrztNLMufNKeF1BrzsNQbomsBldDjN2Hfb8Z2Z9HFOPwzyYDRyM+oobxVNJMwW2QDu6U
	/uEQiGHQD90+yXc7b4Gz4aNQFNrWppE=
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
Subject: [RFC PATCH bpf-next v4 02/12] bpf: initial support for attaching struct ops to cgroups
Date: Mon, 26 Jan 2026 17:02:26 +0800
Message-ID: <1c5845208d235e5deb37807f3be93af325033ba5.1769417588.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1769417588.git.zhuhui@kylinos.cn>
References: <cover.1769417588.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: oh4hwiq54crzsgjbnp6oqjmn58fqtj9c
X-Rspamd-Queue-Id: 860C0120002
X-Rspam-User: 
X-HE-Tag: 1769418211-772699
X-HE-Meta: U2FsdGVkX19fQjDwowvYdJRE6+i4kbid16cpgnHubt8wGuW8zBxiz3o9fS+I1dUGhBhmo8cyIuKdBy/3J+WT2a/HybGSF60ZZJCh5yG6Mo2BI51+qrpxmEmG+P3UvM9Y6M2KC307YO+aadfoYPinpzXpFmGsOPfASYzcEc5iTqf5KvXG1AYUeAfMTdRIyRBVMi47eEjlYqcb1CR/NU84egyZ9XER0u/3vrto1Hhil66vLcYVLqb3hzqCoLJU+3JOxfycgW1HzHIXNtf6Tb6jhZ5/ytK4i1LINgEHnrYmt0OBpJ7P5G/ssIyw+VFHlJWf8JbVMAWUQY7q+ewNE1YQTRl0P04DuJfS57n23Jp97gLWkpQDODHYg4OdtXn7KWG3E4tlCr653dy9Vm1rW8nPpzyt6n0l3ydBhUyWwBuVR+JUyc/eK2fOEFC3S07o261IlNTGGVztT3/a1O2+QOQs3Kz+ag1s5BpKKBa9xkj7bOVIXcGb43lMHa7AsLk9t1TCETnrKITuU335EeSA0+jNTzRhey/RQydUWwwkPm9axoSE85uVm0tW6Vo0Rhlj86+KZcAaUCWUXmCIH8G6cWaPSE2byLEy9j5gjD4CgKgVd6XiVYTp7JeSvuGeXqhJuKf9mmS62LJwrzGASCJtUUbSCJ5ALPwRSkOsiB3vyecfv9zg4HUwHwbHJBMJG0+3rYyCoozT6f8Z5Po2HrRYIzaiIqtrUuWT5+6eIdkd+ZyKiJ+LSHivyYxnJYzQuQjB4kpcP0BWM42WFQXPXQbzDa1mfPBi+Y3tizjeCK54o/FHeqtz7Y1iPLRBOO2AGRrHatY4Dq2BAAfUYQU5RsEpxe4hng49nVGxUiKlFl0dFu9KTR6l/KSUUR/hXm9ynImgmmM4wJ+rf52GrfMwwu8WjKEcK9Uo/jLZOeXtJ38YApOONjMezr6SFEDePtapri5vMPkwN7idkDSW9nGq3PrBHSE
 zi24oJCx
 Q8eNV7g1DzFWCimqVc3aLDGbpX++5OVSeUDN3UACmQnUF+RMxDmTijnwSNPCyESAA77Z6JeidYdvU+Vfi6USfTb4yfuUDHICAs/K7ZwRBkIFmkDFXxVcqZwk6yAWD4ZBcc0HLGEoEaMEGjrIkY2d1Qiai83Y7hisiMUbSiC+I7A8lXPRoQAIy0pyZ6uTybxPXYHlxEDyK4klncMqbsV5lOGYN9PbZ+sQ3L3uugMWXhvN38qOj5+P4OtHVWNSPvmXTI3K7ObWaezxfw7M=
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


