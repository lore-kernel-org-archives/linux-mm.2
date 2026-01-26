Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60DF3C88E78
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 09:03:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9AF16B008C; Mon, 26 Jan 2026 04:03:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C837F6B0092; Mon, 26 Jan 2026 04:03:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B92EA6B0093; Mon, 26 Jan 2026 04:03:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AAEF96B008C
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 04:03:45 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 517CDC1097
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:03:45 +0000 (UTC)
X-FDA: 84373527210.01.4FB6C76
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 918D0140006
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:03:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=N5uumHNB;
	spf=pass (imf26.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769418223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R9sBuFUW725uaUgAoHBNUzbcXyyILwwKmBSUQhglIbE=;
	b=opNW0D1K8iLQPkzuFMopeBwXl8OewEmnr4//iWLarIJM5FhRHBMFE+iyn4UrAa6P61WwTc
	+LAhQZ5hAq2JbUQ/fy2KJ++gkwK75oNURDZZs2VhUstcsS53vdnWudkiKze9aHOWx0UTG5
	qv5lHrd10hT5oxaG91gprsC9fD3HSKE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=N5uumHNB;
	spf=pass (imf26.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769418223; a=rsa-sha256;
	cv=none;
	b=fURLgA4MMUG23j4fZF8P5eDgWGMIAvdKMzN1LD1kAIfab30HbsnyMnolDsINAMl5ATYXYV
	5XqhIAlc9iIrXKoia1Avo4C/4ezieVJHyJDlOIE3DAT1SKjab29yaFoHxOb7NInvmuEfjx
	HmSgqWujuzqf2j19nCYwUvszuXtX2MM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769418221;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R9sBuFUW725uaUgAoHBNUzbcXyyILwwKmBSUQhglIbE=;
	b=N5uumHNBSXM2Ihk+yOhHO/iUCVJo+bJ5XzjP49GZRH2DsYiVcQX3W6+QupeuqLR+/O/rVC
	B1YqdMC0pSUBBGy4GE+YVZFZZTfIGs8/WmTmGkfyfvxWbS/AkSnMT255S2EO3+MnhaqvZs
	GSDmBAv0gKJZuBYWlezKM/2Xc9qw0ZM=
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
Subject: [RFC PATCH bpf-next v4 03/12] bpf: mark struct oom_control's memcg field as TRUSTED_OR_NULL
Date: Mon, 26 Jan 2026 17:02:27 +0800
Message-ID: <8c6d6d4751f1ad12582d3d9eabd549d5fd8925b0.1769417588.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1769417588.git.zhuhui@kylinos.cn>
References: <cover.1769417588.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: g86igbx87nn3adkakzbmphc5er3pzfmt
X-Rspamd-Queue-Id: 918D0140006
X-Rspam-User: 
X-HE-Tag: 1769418223-503964
X-HE-Meta: U2FsdGVkX19P5Q/v/wTyM/iXhDwBe8J5Jp8nKKMJ5c/QnyXad8+bxTCIbWgZpGdnE8/7rgN/HnMj+erBSixQlgoBrLkq63VeHkoCoxVWQ6FOnHNZqh6UxECTAuo6jIKLR9gEWO41g1QaCcWCKPJpwBQ917dOzWDPswotHMSz5Q9qI2mRNvxo/F+tSXBA1X32jwvHL25sHyuJY9w+/+vO1YOLEFvfcXKx2+ZIU+LWDoK9CEVJ52TLTisJnxjLIiBKeHEhZrBzi9G92IggiittwH8fD7OTCVukM8+DtYcFge3GN0kuQcXf8KKqce/abQhF2SeUVivdTXAsXDG2HcDf+lIDgYgv1VlPJ8+gsatclDgjpaclZx2AAg0m1Flz66RLB57wFD6jtlhaMn7AM8DXkb3nziq62DEXBgA8McU+jFORwu+dgzHdWV/M0qtjrfDFRkfBLY8xCCBQHbxCNm/jD9Lynf5zQun4EluEQPSp+JOxeo08WL1aYA4uWi1P4y/diz3bGn0SRWEMFBGZBYU2dqw4t8sR2SwO4386mPlfkA/1xdFFNOvUaYbagaq+ygmsM/Jq3pkwXGGcsfYINyHt6in4yJnX8cx8Qq6vkVQZsrPI6BspMg3MZDfGlsdAnv1o4IgpDkPtnonv148EquwSNsAw/bvDzDrRTTxX01Szd1I3pMf7Fa085rZhp4TNeAF2c0SReueKMhh4bjBEv+GwlG4iXVethHiA0z0e0OlMgc+dGYHuFCagaxFM2lzLwRAjfVwN5GApIUdXbDVtJqQZoNPsFbpekg8h+OCY+sTl6qy6ZOe7Wu5XmOTt/X1UG1qIS/i1vQ2P7kEDgwbfhdsLBJOS4PLkDNZts2SmoZCEH1qVZFai9uNKLlQRGgDhecqRxeNjLkVbHJRAkWtRHe3E+U1IkXkWpfKNH0/37mO2PTUBIZWUo0258rCd4A+dOBeMI3oiy9ax1ieOpoz2YQu
 dTDcCtno
 EFIfAoYrCuAfWjtJmPY3XSkHfwqLkC2k1OylmU/Kk7uXzVafdHohQWCJlnUZR9dxklovf2KH2W4oCCjxptdcr2dIOdfRSOd0C4+JhBLIeuzMwLsTB4vrb/HshdHfD2I13CH+mV2mb29cAuDk+AzoMWQIvYqDuvICevdS0rUKaX2nEInxYHlKt0EStEg+/PiIBBnTvDNpd/BlodfuIPEDlUQ6tvxA3CFQmCMEPDRPWHHSxEnaYZ8wnQg+CaWLhsV6f1q26TxoLAWn+95KSgUyjblfE+xchQAI7WpiJeeM+Y5qooh0=
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


