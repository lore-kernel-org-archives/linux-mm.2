Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D94F5D2D8C7
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 09:43:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DC4E6B0092; Tue, 27 Jan 2026 04:43:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B0726B0093; Tue, 27 Jan 2026 04:43:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B2EE6B0095; Tue, 27 Jan 2026 04:43:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2CFB76B0092
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 04:43:58 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D63141A09AB
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:43:57 +0000 (UTC)
X-FDA: 84377257314.27.F00A45E
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf04.hostedemail.com (Postfix) with ESMTP id 580A940009
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:43:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=V6EVuU79;
	spf=pass (imf04.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769507036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R9sBuFUW725uaUgAoHBNUzbcXyyILwwKmBSUQhglIbE=;
	b=Dr6t/5ik2FbK/E5AoQbtBYQtuZJGdzq1xvonxEEjWEYN2klRgsAZOCRF1/rELeG1u6BZNm
	Ilu9otPSmPI6Bewk4OZ0TBP3+qrfEN0Oy/y7MvHto1weJKZaEHy/Sri/g5zGxiNkMWnP0S
	xBr61J76FNxJY70gK5+WOq8DbmkLa20=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=V6EVuU79;
	spf=pass (imf04.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769507036; a=rsa-sha256;
	cv=none;
	b=PnknXUujmAV9Amc0RhICal5FClFihW3qSLghZaLSLgtCFpVTv74poBg88ZrxFGCeIZdC4c
	zCuoV5u+LfW79ctjEqSp28TVejnd9POTgDROkq2maE44R5uHl03K6SU76FQBtwTP2stXKV
	mqB3AUOFqE7LWIVMatAJU9IfKBV3aoY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769507034;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R9sBuFUW725uaUgAoHBNUzbcXyyILwwKmBSUQhglIbE=;
	b=V6EVuU79vNgGvQDc4EYR6qMx3zOUY5408Nxax8gbmUwfgPseSVeEcTfzDsDZA+SxLgBG6J
	ycTWpG/K3bX4xhq8fUTlLKDdUJxgXGL6eIAo8yRqRAlHFGOXBPt92DhC+LCgp+5XL20gxh
	89thHaGUOr0HUEDMOXYU5iX25cLsrI8=
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
Subject: [RFC PATCH bpf-next v5 03/12] bpf: mark struct oom_control's memcg field as TRUSTED_OR_NULL
Date: Tue, 27 Jan 2026 17:42:40 +0800
Message-ID: <8c6d6d4751f1ad12582d3d9eabd549d5fd8925b0.1769506741.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1769506741.git.zhuhui@kylinos.cn>
References: <cover.1769506741.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 580A940009
X-Rspamd-Server: rspam07
X-Stat-Signature: zuyhbkt19prdsy11ayjtz8o3ot4ddeow
X-HE-Tag: 1769507036-933050
X-HE-Meta: U2FsdGVkX1+SJBTJ/W2q538GPymVgBs/UCTiq7UxILXF1DXWIex79H1jCbJj5l1Drid6scb8s5l+ILEl8xbd5xEiTsILMuRqFgu3pSkcIKrMOQzOh8Io7r7WYZmHKnTeP0B3Z/B2eSD6SnODlZZh8GQE00BOfhMxa7XZD5beLqRBXxZdOUJXwIkzm94gcAFTTSzQCmf7zDaXMm9Q5N9NCbG563wpTFl0/martXJLSXHS0SdoCGeE2HsQ8OS11moNLo4IDBiAzXTkW/rkjcpBtly8ARIPCtgEPG00pH3LT/JvxrhIB33RYbc8zwq/78pOQvc/r/mHm7tOzDgqTzITFt5wThLNElQpDdrN80aLdajK/Ilu/BGx+w+smKK6MX9YW2Zqob+oKh/Z7Od1yPdUAPo9aMeOrxcu2CLMW+qN2wMogKZ9I/6xxVxMgcHydZ1GzwF4I7CqqI50xbIggxKf1vTGXVcjjrBjWC+748kDGFVkMMRBKpdkY+VZuZryCvREIeFkX1JTpOEhpJ45Sv7WDokmC8wSsOhoMV2+zwQJo44WXc9r8yYjG6SUyn/q/Gs7exC3Uwuzdv5reHsUhcJqAohBi4a5ie+SYKsnz0m3p6gfBx8FY0/CZuCloPpWzWXIoRXPfKSTCppuElmfA7TKrs0oAmjxC4Lwly1aK/OIXaM7W9Ec+V91NsFfpoMf+gY5y/rAQ01LnkYyH2xoG8BZI6qFVY47nuYqtqDRbEOOgO0oPPFwpAh6ZOHv8rb0HU60w0X7pecqvJuuWqS+xkHf8dQJgwcCDAf6/aT4Ap1YfNE6j31+6XfV+8Xjy0RKNCOamdxikRoCety3ZaLkTi8IHBDei5tZU9VjrYD7P2LhOOYqXhWsKdCracHoMz9DqXweaDq0rpmutR3Dh/Ay0eeV4iCYmvOs+Y+BUqHseACmdlYzxBnL+fd+7hyjifNzcaMT8qdGoG9FLrYTCJpFb96
 wz3W9OuQ
 LXYI6zIxaYe75Zn4=
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


