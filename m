Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8AB8C982EE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 19:26:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB3966B00C2; Mon, 21 Sep 2026 15:26:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D64136B00C3; Mon, 21 Sep 2026 15:26:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7A326B00C5; Mon, 21 Sep 2026 15:26:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9921D6B00C2
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:26:24 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 209271602A4
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:26:24 +0000 (UTC)
X-FDA: 85238750688.08.97F3156
Received: from mta1.migadu.com (out-94.mta1.migadu.com [95.215.58.94])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7EEF6A000C
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:26:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="cT/jUZ47";
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.94 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790018782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5C9zdjlfV57TZblDN9O3gzeejsr38PuffqEfn7E99Qg=;
	b=bfSnv4PLhzjB0i759iblONGdeMkwkbvATXW4A69iFhUwQa4gyh7dLE9OAqupi1tNAYNtsa
	F3SvwfqIySCQ4HPCgZOJ3ifNNnV/+yY2mrHSQOJ4oCw7iQh1IsUwe+B3Q5VUjfUVG3YPVC
	x5OMGjTpDbxDy/IAhOR4qEakmIn8ayc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="cT/jUZ47";
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.94 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790018782;
	b=qtcixDoAOSlO4Y2mQeq2OuuXtG7oZfT2ihKu1qvyO/KJ8rHMezAQilw/4zh1Q1q1/Fn9Ud
	feTDkD76GxnYn788I3uA+3UiICy9iktVox92nmaDcl3MXTxcgqC6utyQiiTl46j5GBgb68
	4W0n7zFFj9dbg/YQec2vZVLkkFfd6Rk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=N0QLwAgxaBt6p5mr1X5j4hSoGitsMI3jdbKpX7+fG+I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790018780; v=1; x=1790623580;
 b=cT/jUZ47A1q794mPy6RU5ZFbHKhIG2TqdrTOhACX1fYDbznHYC1iFduJvMNgxdl/xGS9XTsu
 rT1+YVcjdAkvobwSkfbPlIiNIOb9jV5aBnUoFgaaLcMXAnRDDsBQPSRSv+z3QHthbH7W0kqju9A
 1EDhpS1si9Swb/8rrmZoMMXU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c80bc367aa6462a1;
	Mon, 21 Sep 2026 19:26:19 +0000
X-Mizu-Trace-ID: c80bc367aa6462a1
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Alexei Starovoitov <ast@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	JP Kobryn <jp.kobryn@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Michal Koutny <mkoutny@suse.com>,
	Amery Hung <ameryhung@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	hui.zhu@linux.dev,
	Donet Tom <donettom@linux.ibm.com>,
	Greg Thelen <gthelen@google.com>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/4] bpf, cgroup: fix cgroup struct_ops query for a second attach type
Date: Mon, 21 Sep 2026 12:25:56 -0700
Message-ID: <20260921192559.2619635-2-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260921192559.2619635-1-shakeel.butt@linux.dev>
References: <20260921192559.2619635-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7EEF6A000C
X-Stat-Signature: ebfa7x3peymo5mwka7csba9f46bxwrqg
X-Rspam-User: 
X-HE-Tag: 1790018781-129003
X-HE-Meta: U2FsdGVkX1+0vhe9n84wXWC4kZ9+mMjEhFUUopnutJhKlWUdLgrtO22thQZahWNXSDxTrNI1zM3hCOSG6YXmrX2JyU3qP/dz0l+zqoG6to8AAhXd4hqW6+e9bcOpLMOtnJ6ouL5rQVkw6Oa+hwN271USen4JyH2FWYql8+ZLVjUj6LDv4fHQTKFOytyWXTuB0cKJVy9m5s6vq3yRDzPygjMGeWFCRFbbVlB7OjbDtIasyoj84NwtVzuBMd/Lw1QdUW0VH6F2Xc2MPYEpdG1gRTFZDg/lk31OUVMNgh8N1LN+Rf8JQZw1v2otYOu8db3pNawYMGmngaSBG3hWrqxKogz11w1r/FhuIWS41OZESO3XdRD41/ObFMV4HlrLE92cReb97n8jG5sEIUru/0qsBxCJMm/w+qKdd6uyqQWjQ4bN+YPgUaYBWel4ciui/JHr8Log+XCNVo0fWl7SUgXvCSRM2iKYgOI7rp/IzV5Y2c1fPEmOw2aN8KFxEVX1NgLEoC7rfvIdIGjHlFPH7gEVgrN9uQp0z6UbPG0UyqLIWzPK2Q4W1Fpxe7pxFFU7o4LCYaZDVOVM74RKso3yetG7TDehxRi/mbDP8vTMhSv/bySFnTtFzqCv9xlWSmXTW9Rdgu2NXPQGI9ItrtHkxLDN5yqtU2xz/Wno5MFADf1ilcI3OB+hlA628J/kJsw7c0dYHSUWmTqQ6KhcvrilkKW3wX7MUnrp7XJn6qbsIR+LLo962nNWZPdczwm7G9QgGISYV+k6NqnE6fdy808lnecsqS4nuWbjgu5ziIDsXTKTVGA8TSqdWEmgp/ZlllIzxDXWWuilBdfa1BfLYcwTwgE8KpRVfHpNHmrAgiB9+lSjEK7aka0KIVrJWYVrKbX9nGClVjEsQ5Khft6xzU+iumrNtMiw63p+NjQDygmhTBzpljvALT2BEnG8DY0QyHKTgaPUeBj2KMZiqF4+XAtZ0Wp
 SjZgTdOY
 JELttJuZK1aoXnLeVNeuzc8UBKR/V7wAUhkKmlS3nQ8XyM1Hk0TO8b/TwLP6txDaWWwae5OVnaxiz66Pc7WSjw/2mySmjynyVDM69L9vY/2iDMHcfF+SiZ6qyXE/g3I+Aig1N6+HWcbbqNgxV5/2hWK6V5oQqhn1kZux9X7ziY9tt1CzvfluZC4vguEcqMN43e4MWcAm9J+UrPTg509dTWTQc8YV2ewm7nRPN2tPZpu5zNj3QyTvU3XlZxVHvtDW+7SkcPH0EtlwoW+TFbgpXhbCSPA7uQnrB9kQzwMy7AOQXo8UCloaodcy5In28lLtDzUxRHxVn+2LnrykJ384ox5nAC9TpykPUVs7B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Two things in __cgroup_bpf_query() work only because CGROUP_TCP_SOCK_OPS is
the only one struct_ops attach type.

It calls cgroup_bpf_enabled(atype) with an atype that
find_atype_by_struct_ops_id() works out at runtime.  That macro is an asm
goto and needs a constant.  Today the compiler can see there is only one
value; add a second type and the build breaks with "impossible constraint in
'asm'".  Add cgroup_bpf_enabled_runtime(), which reads the key instead, and
use it here.  This is a syscall path, so the cost does not matter.

And find_atype_by_struct_ops_id() matches on type_id alone.  An attach type
whose subsystem is not built keeps type_id 0, so a query for type 0 finds it
and returns success with nothing instead of -ENOENT.  Skip such slots.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/bpf-cgroup.h | 9 +++++++++
 kernel/bpf/cgroup.c        | 3 ++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 8a75a6cd7309..3b2c127d401d 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -76,6 +76,14 @@ to_cgroup_bpf_attach_type(enum bpf_attach_type attach_type)
 
 extern struct static_key_false cgroup_bpf_enabled_key[MAX_CGROUP_BPF_ATTACH_TYPE];
 #define cgroup_bpf_enabled(atype) static_branch_unlikely(&cgroup_bpf_enabled_key[atype])
+/*
+ * Same test when @atype is not a constant.  cgroup_bpf_enabled() uses
+ * static_branch_unlikely which creates jump-label site and requires statically
+ * selected key. Since key is selected dynamically, use static_key_enabled here
+ * and keep it off fast paths.
+ */
+#define cgroup_bpf_enabled_runtime(atype) \
+	static_key_enabled(&cgroup_bpf_enabled_key[atype])
 
 struct bpf_cgroup_storage_map;
 
@@ -508,6 +516,7 @@ static inline int cgroup_bpf_struct_ops_attach(struct bpf_map *map,
 }
 
 #define cgroup_bpf_enabled(atype) (0)
+#define cgroup_bpf_enabled_runtime(atype) (0)
 #define BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, uaddrlen, atype, t_ctx) ({ 0; })
 #define BPF_CGROUP_RUN_SA_PROG(sk, uaddr, uaddrlen, atype) ({ 0; })
 #define BPF_CGROUP_PRE_CONNECT_ENABLED(sk) (0)
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 696b27383974..99b4e96f5db7 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -45,6 +45,7 @@ static enum cgroup_bpf_attach_type find_atype_by_struct_ops_id(u32 type_id)
 
 	for (atype = 0; atype < MAX_CGROUP_BPF_ATTACH_TYPE; atype++) {
 		if (cgroup_bpf_is_struct_ops_atype(atype) &&
+		    cgroup_struct_ops[atype].type_id &&
 		    cgroup_struct_ops[atype].type_id == type_id)
 			return atype;
 	}
@@ -1448,7 +1449,7 @@ static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 			return -ENOENT;
 		from_atype = to_atype = atype;
 		flags = 0;
-		if (!cgroup_bpf_enabled(atype))
+		if (!cgroup_bpf_enabled_runtime(atype))
 			goto skip_count;
 	} else if (type == BPF_LSM_CGROUP) {
 		if (!effective_query && attr->query.prog_cnt &&
-- 
2.53.0-Meta


