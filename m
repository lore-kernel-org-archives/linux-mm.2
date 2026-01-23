Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EED5D72355
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 08:56:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66E1A6B046A; Fri, 23 Jan 2026 03:56:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 240AF6B046C; Fri, 23 Jan 2026 03:56:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0433A6B046D; Fri, 23 Jan 2026 03:56:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E615A6B046A
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:56:44 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A588816040C
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:56:44 +0000 (UTC)
X-FDA: 84362623128.24.7F04A0F
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id E643540003
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:56:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="G/KkPluM";
	spf=pass (imf01.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769158603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ev1nwp2jqQHVpe3TXk2x9AVEGB6Nj6mx2yP0IpcUZW4=;
	b=uhf+X+o4RdMKkWZtx2LxCULCC/Dack6Xi5keLzivg9wkz9hT0mM0Ujw1ljSOx7wnnA7u7n
	2cnK4ca7jwSoNj2bSR8IHw/B7oLUvWg4Dz0DuU8xwX9mdKXsI2wEMxWZGCk1cJMhV0dMM4
	yboWQk6NsOT6h2mHZ2a8jznbzbkp9bc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="G/KkPluM";
	spf=pass (imf01.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769158603; a=rsa-sha256;
	cv=none;
	b=YpYugJvbEeFkrJix+2Q0ODnGOR1fFgVQfwV1WnfhKO4AUEnVKAQ166ye8ERikN1LFCI8yU
	I/GaAxYfd6x5bNPJMktaR9pD2+D97oufNGz/9sEis4HrdqhGAiPn90rCy0mOIREGGicYL3
	k18qDYO6d6c74g5tRRKs8q1n4N4CQKs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769158600;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ev1nwp2jqQHVpe3TXk2x9AVEGB6Nj6mx2yP0IpcUZW4=;
	b=G/KkPluM8KiVv/KlXXvon+NjDg2D+OVXWkHzALnwohFtZK4prPRR6w8tcl7XhnGO9L1O5L
	yoLCuV9BE9e/bPYYrRXc1CFx1c+BQkJAnwkDsEou9XN8/GXO2/DN8T+qUPqi4V4YqtegaR
	vdecvuwC7H3OEHkwZGZukpN6hW5pqn8=
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
Subject: [RFC PATCH bpf-next v3 03/12] bpf: mark struct oom_control's memcg field as TRUSTED_OR_NULL
Date: Fri, 23 Jan 2026 16:55:21 +0800
Message-ID: <27af33f679846a2783cc8d82111ebeac170b004c.1769157382.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1769157382.git.zhuhui@kylinos.cn>
References: <cover.1769157382.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: dtqx1fu65ybyzjs8537idfuobitax3h8
X-Rspamd-Queue-Id: E643540003
X-Rspam-User: 
X-HE-Tag: 1769158602-359222
X-HE-Meta: U2FsdGVkX19Z7oTaFzmTxOywlmhcHIgr00p1IhRjnMPE1ERqtgzRsIO9H+WmY0QvRqqwrmny8Fif/4k796ntYVEShzb83D1fSXYMOTpsjv0ZgKYi6rO3seWArVOcOykaAxIST7/tugFJgHqZm82QHfhNyEVdpNLLchjk4I8msGTcOVyvrffg7WKZMS2zlAhLG6KKTaAHw2uECdcReclbLnNuuL84s0f7JsgM66bWGUrcHqnLycIDhdBUS0cggFoeD0iwjv1MLGevXoOx5oMshNUQlr40Vg1f+EY3F0SglDnRJHEsrSgOanL/y/5q169L/lkzAGwZUXoxqB17keE3d7r3Kkn3GubqO81onYzgLTNgjCIRCY+hTI6iGXqdy2mN2lYJL8YlyEnMIGHUy4tCjdrXO/owl+okf2S10oVpH133M+Pycwh31Kw2BUR4moJd2EAGHegYiWPIn0hrLY3vgn8y9zQY25HizOXv7wH+V6Oqn+2E4rDPlv9lnBIFDZ6eSnXIVlezkAwQVBUpLyD2NYzb6m0AwftNG3OUqwZq1RBGylWenrdlBr2jrgE4E8NYVNoR3Us2bN5nDSzIeV/T+1xb2CnX7hskqJrkRN/BA3/x/cujYA1+ST3U05MOPgZv3jPV/xZjlcVETf5lj7MOpuEnfRULr4PN9/NFgA7b9gj9PykGdhIVpve7BH1BdVX07rK3nEREym+RMTWkzNg2/DSFr5P1Ox0HvzTk+srFX6JcmaBa8QKMVOdbLGPANfctnfQ+JZzEJzLvQep02llWwTvS/Mx2IaFitE/9mrtSfkjcF4UrShDWbEcMmLC/0LgPk+oOLDFLCRjfxUw9RmvfAPGPHjBBkiT1ggFn0tSzuuGILF+D5NCuD3TWwvpBji6agREJ3V8+1MZMxb6mzIBwjxmqPBxoqIkD7yL91lKmDgndJv+dQiv9YwgP4C6phtYr1SQ/FSoQ6uV6yWl8jU9
 pXfFGBPg
 T9T29bbxaIZVtft9rhP0QKJivNjqKOGyHaCNpyrH0UodnlkIZa6x8zDZXhEGoGhN1sq8F8YSZV32wqSOF6TKKcIs+bVRE/OHGmhLqowFZ8ulW3C1jb7TTngjKvap/iIrNu7qOyV+vxpo/RaU/xNCIjDBU+gaNxkdzn9litc5IpqhX/SOGq0rI5X4YuW42SDKEBe93Cp7rHYnl5yp+DvLXVVwdDYdwOOanA6nRNbYRPEvbyEO+6zyzxkrcU2zuRQcMAC3nlXU77AL8Dhd862jf8A7F+r/9NcPVRXZNIw6Yrq52Nt8=
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
index 7a375f608263..e59acdbb5062 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7152,6 +7152,10 @@ BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct vm_area_struct) {
 	struct file *vm_file;
 };
 
+BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct oom_control) {
+	struct mem_cgroup *memcg;
+};
+
 static bool type_is_rcu(struct bpf_verifier_env *env,
 			struct bpf_reg_state *reg,
 			const char *field_name, u32 btf_id)
@@ -7194,6 +7198,7 @@ static bool type_is_trusted_or_null(struct bpf_verifier_env *env,
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct socket));
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct dentry));
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct vm_area_struct));
+	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct oom_control));
 
 	return btf_nested_type_is_trusted(&env->log, reg, field_name, btf_id,
 					  "__safe_trusted_or_null");
-- 
2.43.0


