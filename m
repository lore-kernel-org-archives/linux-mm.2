Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B281D2D8C0
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 09:43:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3A546B008C; Tue, 27 Jan 2026 04:43:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E05836B0092; Tue, 27 Jan 2026 04:43:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE7B06B0093; Tue, 27 Jan 2026 04:43:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BF1406B008C
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 04:43:46 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6C69B5C6C6
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:43:46 +0000 (UTC)
X-FDA: 84377256852.27.4014F6E
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf18.hostedemail.com (Postfix) with ESMTP id B79181C0005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:43:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YQXTc1qw;
	spf=pass (imf18.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769507024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ycrFyw6aXaYmQPmQruEJsfLSWjPHoV8ar+xnlNHnd9w=;
	b=WnfqSj47KV/mUiF8zsAlzQnRLRBWEN6r1ZjBvUuqq7S8iQqp1Ou1RFYr8BXOd+CLculRIL
	Fwn2+KclEkbro4ymMu9lx9k7xonBgiXUCUwhEoVnDqb8jvUEDuhCoeyhEi2keV7UspimeA
	ibn1T1NZ0/inAqIqAdttuicDNy9X3ug=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YQXTc1qw;
	spf=pass (imf18.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769507024; a=rsa-sha256;
	cv=none;
	b=KsKskGIVIGcF15aB8iDjDrkSaa30EiUZ/wsCudIAsQy5vOj7oqkJQxcsQdaW3GTtb7sxub
	bxAP3KEY8L8WHKdJvERFANflwNbVt9XR+updimz8jspV/35r/gEsbpO7YA/X400awbuhxX
	170YPYNzFkWsWPBKd5hWv8623JXgyo8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769507022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ycrFyw6aXaYmQPmQruEJsfLSWjPHoV8ar+xnlNHnd9w=;
	b=YQXTc1qwSK8YUcIlgs8w3Xp+DkzqZVrK9w7JA7p4wJtHvmD4cMt1T5d62d/hZOzzrTSVBH
	tUdc78LPAuaxmK47I0TuUtkE7/SOXlNqNq3qwXbzCw/sb/tzsdCY85bnStZpiMVXlLQBKB
	KxpyEQ0JelY7vPIP2LXhZyj+susJMGg=
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
Subject: [RFC PATCH bpf-next v5 02/12] bpf: initial support for attaching struct ops to cgroups
Date: Tue, 27 Jan 2026 17:42:39 +0800
Message-ID: <1c5845208d235e5deb37807f3be93af325033ba5.1769506741.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1769506741.git.zhuhui@kylinos.cn>
References: <cover.1769506741.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: B79181C0005
X-Rspamd-Server: rspam07
X-Stat-Signature: mh7hnm3nzgybn6pzygx46ymcui9mfujx
X-HE-Tag: 1769507024-913756
X-HE-Meta: U2FsdGVkX1/nsKm5Nyb7t9FfrD0QbP0p7wzvlQGkHir0rrlch5QndyvRRAycIU0t7tDx6/EKF5Lkaw+SLTKd/hKnPVjZ9h2WGgbnbJJp6S9PByamkJTmG64idy6HbBUcl7pVm1bnIy8LKImyDHVPruQNmlUvXrzLtSCBjGYUdT8LC80Ji16U/m9PVqaFCMkg2ChdSZ2J+8BuQR1kAaipKNjh5Xm8SwueLK0B01YZzJYSDFqBhMTG/yhaxCdar8vLImLqIqvcfWY0+OkMFiux11mnKhYo6CS3Uxp0QjFTYrE6tl9LssXtsYhVwW+0YiEzsT3bWNjIeeYhUoOR/nsfEM2Zsx/a+2C42H/D3h+JzTaXS+ru9JWoHF5bchhUG4cxT1TZjc/YnuoSzHfIW2hvIzr5rXvhdXCSu7/gDuUcrZMuCnJoibihvDeM23dXkmalxYWLyE/xRzEmC95eFq+9rkq1OhnNPQfe0w2+MthO19LL/l1xcopdBYsOYyvNWo43w78kXtWkm+1kJggJufJ4L21xvE8Nx63SyieYIPzXKC1HLGr298QUBL3YJX4gELCC9zr0aPzL+BKOCleOkJpKW/9O4KOwYEVuD6zXITpcErjE8Iaupazco2xSqscgm+n7rnDM5Uejw2IAtnBe6lrLfMkugHSoLc9daUk6obJYGw0dSo/Y/bLlCSlv9EnQ276bduMRXjlXZF1xss3/A5ufSZTGCqGVFwp7ubwAD3M5bUiFWdTSsBannHt56y8hQZOvOo/umKT8IzyoecaLLm2dMglBaQdiGRk96uFZb6mF9gAlp22PaYQHdRdLVDbPxl7bZtnYQuprsKVOiknKz/ZxqNH5w9D1QnyCSwZrJMtLG/N4cu+Q/9Iz2tTainLE0/IWMvL57hUlMpnEYEETi3GB76I97lBrwcCtMhXq9rMZpqO9d+5cigxDgp4huI+z9Zaos5AmDbXQGVGXhOn6tiF
 HLE/1M3X
 NYJndcsoFFSHZS3CUxr+9qkiXCv96e3g6Yq2B/GdnWWoK9uHK42mZqpoy//pNFwKV7Npaf38wiSwJ8KevGMcRS0hcJnhQ6FWkc0QQmGgV9AbIkUP5c72kL7CvIQjZ9cgoi8jThPML7N4KSEI4PwkHhAlIcoQ9aoxC4kRX/TBVf5dNuTYKMTWkjKi6cUYUaaCEKT8Mg2f7InUuW/GgjCrMgEf6lKrgHY8ukZaqn5GNNmZbIbUKp+oMdDgVhS5VhqkVqUcCcbqHRZO69hs=
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


