Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 875ABE83EF5
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 08:57:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDB916B0098; Wed,  4 Feb 2026 03:57:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA2936B0099; Wed,  4 Feb 2026 03:57:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA6426B009B; Wed,  4 Feb 2026 03:57:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C087A6B0098
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 03:57:48 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 60AD91404CD
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 08:57:48 +0000 (UTC)
X-FDA: 84406171416.18.95A1DE7
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf24.hostedemail.com (Postfix) with ESMTP id A992018000A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 08:57:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RY1vW+qt;
	spf=pass (imf24.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770195466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R9sBuFUW725uaUgAoHBNUzbcXyyILwwKmBSUQhglIbE=;
	b=ukr78Ed7qIMxDjBogMtSFRikvIJo+64l9Syw/dQUu0zuwi+Ll1QzTVkoB/U/TkJKx78+fF
	YoGTKV7jtGtt5s3KQs9kzgSzbQmut107k1+lsZCkIiECLD/qQwjDPQwXjH9SdCi32irWB6
	I7bVwAwK6gMGYHZ1OCR6GWKrzVcX24w=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RY1vW+qt;
	spf=pass (imf24.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770195466; a=rsa-sha256;
	cv=none;
	b=JOEF95DEcFI81NJ4bs9wxiYY+0Jm0wrvtn5fL/sJ1X8xtrsdL1QMt+ABQ2+lx0S01tUU98
	6/YLZiX/8Cc8I/Ufc8hGEShtgYqppPdMHoaO6y6Yb6WwvFtAb4+aoB7nBjLjoBzM5o/Tij
	8lHsDCFxDfK/ZolZU+0g4H5m5I/hvg0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770195464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R9sBuFUW725uaUgAoHBNUzbcXyyILwwKmBSUQhglIbE=;
	b=RY1vW+qtMDKwQl9rjfLkIOtyLgswYcVFWriYQGB5ViEB8shz43J9Ec08uBIyeeeiZyfnQZ
	E/0McPljtFAhv6dfAVv85rfIYU71RM+5tUag8YupjCOOz5QzN3oXtc4pl30wlaALRD4YFl
	JIp9lG9tLFZz9mEN0ps3XsU5fir3MBk=
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
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: [RFC PATCH bpf-next v6 03/12] bpf: mark struct oom_control's memcg field as TRUSTED_OR_NULL
Date: Wed,  4 Feb 2026 16:56:24 +0800
Message-ID: <f2ff420de45ea9a1ec9a7d29328e4df47aa168d7.1770194182.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1770194182.git.zhuhui@kylinos.cn>
References: <cover.1770194182.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A992018000A
X-Stat-Signature: ouczefjbqemnh6fcm1c7ytmh3c7tcpzq
X-Rspam-User: 
X-HE-Tag: 1770195466-738086
X-HE-Meta: U2FsdGVkX19alTe57I7XmjSyrRfQLzTr7CR3lvXK+9lFtQgzu3JqO3cOSchjt4MkIjfq7OGr387r0pLxyuzIXFMQupl+2kkrUcACU/szBRioXUt3d6I9T3DS5d+bNpJuKK6V/FOH9MwP0XWeW/6mGdnkMKlMXipuKr5SM/x/hrNbEnVLCljL49giANXMhxlnBX0HdeNNFCOBKb5eGgcD5Un5NxnSDAjbqfi8HKfpMOyWT7wnq0+k7gx+wtk/Yon2AylTXhlXv1u6nyB+3KZ9xsH7yohlwD18OeMW8Nlt6yqsKZYKuMx1BBcKCDWf7V1YD1xJ/Mc5Tmwu+dk5qGKciIBQN83KmU3V7gZA9klKhhv+Hricrj9PUO5gBU92BFuwKzziDGO3np3XXxtVGG3N+Vfg1sTdopNOqQmYWPL9dY0cR8m3rb9vVe6SuPzCSzaLzkMx4yDSUJ7Ly7mfEHF/bPvRWlq6JtkRAKt03MbKtusRqhhr4MzQED+A87uPm5oLtnC6mNQ8nkTJgBo39EvSUm0IeF6fRGcsJn3YQWZFKjQ3bs1NJqPD/5IN3UkaG0Gk02P3P81pFAPmdPovkC7UPorYOYFzKb9OviZ0BKvaGGOXrHz3653X8+YE/AoAxRmiGDBX2i/PMgVDFYd9ngx/lqj+KHqOCjBFvXBMnsH0RGQxv2NAA9Hgim+YB18yqBj8uf2yflGbCR+lYEWviNFBsDLUCxKV5PMwW4xib3CYPTH7tdTTBS/E19DEAMJGi8JLwefe6t3DsgcSyuqXr4IpokLzOLMvsaW82szY4hkjEN9xQxPxeUk1r6R7LHtJhhCEWSbpjOhh2HfuZQeKF4oGWQX0eHGVvR89lQpStfze3G9O//xbYEujk4tZ7Ka3mLqOLeaZvkuNj0WhwdRM2FbUZEu1z73ha1qYZt63vTfcGNnR535vvcA2BQiI2qt6q2sTmvkq7qCI35/NKQjCF3Q
 Kkf1NtJq
 6YgNE8ja5nh3wsFy6F37gGQAL3s74qZff8fW4KVkgqvW8kHSQWPi4WgaeM4G6z3l2uLefs/Xo7cJutpDyrwcEv/3yNNBW10Ni94LYIx1MB+D5QKy8f6u92riJQCPvBqFURhQ37NIvB9RieSEr2lWOxBSgizx4QbatUHH+283VP8XEAO53eOAZnJxVfZxBNwiAN9ZVro9z4kKKEKIJG6iLXZQddsKYJkw7iKM8alJwaq2AGlB5sPREdbo1uHmi8RTGasx9hRbc56C9htRnt+ZEY5bZCIjTCZcf+U3+2mKevQ0KWnc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Roman Gushchin <roman.gushchin@linux.dev>

Struct oom_control is used to describe the OOM context.
It's memcg field defines the scope of OOM: it's NULL for global
OOMs and a valid memcg pointer for memcg-scoped OOMs.
Teach bpf verifier to recognize it as trusted or NULL pointer.
It will provide the bpf OOM handler a trusted memcg pointer,
which for example is required for iterating the memcg's subtree.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 kernel/bpf/verifier.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c2f2650db9fd..cca36edb460d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7242,6 +7242,10 @@ BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct vm_area_struct) {
 	struct file *vm_file;
 };
 
+BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct oom_control) {
+	struct mem_cgroup *memcg;
+};
+
 static bool type_is_rcu(struct bpf_verifier_env *env,
 			struct bpf_reg_state *reg,
 			const char *field_name, u32 btf_id)
@@ -7284,6 +7288,7 @@ static bool type_is_trusted_or_null(struct bpf_verifier_env *env,
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct socket));
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct dentry));
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct vm_area_struct));
+	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct oom_control));
 
 	return btf_nested_type_is_trusted(&env->log, reg, field_name, btf_id,
 					  "__safe_trusted_or_null");
-- 
2.43.0


