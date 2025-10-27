Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8225FCCF9EA
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 23:17:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2692800AB; Mon, 27 Oct 2025 19:17:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD8D38009B; Mon, 27 Oct 2025 19:17:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9F22800AB; Mon, 27 Oct 2025 19:17:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B9FE08009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:17:52 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6DAE912A425
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:17:52 +0000 (UTC)
X-FDA: 84045458784.19.5E7C1F2
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf04.hostedemail.com (Postfix) with ESMTP id B92D140002
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:17:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ku2hs8Yy;
	spf=pass (imf04.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761607070; a=rsa-sha256;
	cv=none;
	b=B7gE9oagU72V7082UbH8YX9SB+DlDxN/KMD8mFPxQ06XOt6o+2pFFHKVULB6dvJ1hfJ7P5
	SX9v3+31UJ5lBUZ0g5lTvutVLVocxZMwhFrVRlQ0XLWbvAaQ8aXP7KNXB8cZqhmF5Mugnw
	H0m+Sgrp0slB5UX1Y4IkinNjOEXPCBk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ku2hs8Yy;
	spf=pass (imf04.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761607070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fKYk3X446OvKPFK1dbaJLt6hxCv7gj7lfZhXfighlFU=;
	b=gvXstXLHDBlWMQrGTSg2M0n6JJ1AgA02eeIawrNRD4opjVFAApd2kFMDSP9LU7en0KczTM
	SOfF3rpkVzy0EfVKl+xKeBAtOlewPNlx5QRmkX6xJBTVdyrq1I+e+FFF/WPzEoCDmWeFJ3
	Pd+gC/qP00SobQubWnE8EVakrhrUem4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761607069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fKYk3X446OvKPFK1dbaJLt6hxCv7gj7lfZhXfighlFU=;
	b=ku2hs8Yy7UvEemaXTfBXG4klDsCAebaAkVDabecACSyHzK1FlAZNchUjP2R9kWCRuWzeh3
	T3K0YConVo0LzU3EJ2u5NQdqk331R4Y1lpBjCenBmLbDLwG6y+8Xctm/5qrxAe9u/FQ1Mw
	yNRExSxjfmVtfHkr2tIxuzgjMiNhz5I=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH v2 03/23] bpf: mark struct oom_control's memcg field as TRUSTED_OR_NULL
Date: Mon, 27 Oct 2025 16:17:06 -0700
Message-ID: <20251027231727.472628-4-roman.gushchin@linux.dev>
In-Reply-To: <20251027231727.472628-1-roman.gushchin@linux.dev>
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: w8t6qmqff3ut4tkwryfu8xp3gfstkaok
X-Rspamd-Queue-Id: B92D140002
X-Rspamd-Server: rspam09
X-HE-Tag: 1761607070-886795
X-HE-Meta: U2FsdGVkX19lkL4vBVgpjG2i2aqiW3OxaWk+6jBaMdG8ObRtqoTPa0ChuUapXw4fqtjxIawc8V4wPN10vOinJl4Vyg653yWA9pWyzLpjmJGygwuIYKhLHiTmhel7BlSqYnIEdEzwVCJ2oa3veyAsd717VV5JDznHbz4GQqI4nRIBCYCFXlUzlti0lp9srjoEXyuSBOS6adNOLA8MIOydJKdQvndC8S03KQsgBzLkZjGBP34dlTqa4dXb+hvNeT6u76CtaIHlUHVUd4alSYNIqU986FwWn4m6+OUtvFkcoKhQdI/7RlAFv+znHAo9Kie4Be9jHcZl6iyDV/u7cvtwrohSbbmacPl9M9EPystX17zQpKtYLFkrzxcFeU6dt26tWqNQ9nm8Cr0SCsDoi8Xnpg1ltDTFOraFiikss95QwDMnJxxtqo8a8tKSgcMPVU9F/XRyG47FI4UT5ohM9dL14FzNWNNx6ZhX0BiWtWIM849N+tdX/qgPVQzxa8lTyvkGUB7F1NOagytsr6EDh3ES39VKiSBLda9Qw2rjrpJFAX+lhJpvRUmSnuTv6WZVrdEWksck5YL1rXgUZvIJ48oWgt9EcBX51yPvpAWEePzxOc86f84PCDnzj9rbt3ceI+rAYh3TE64hZW8fJIdxv7ieUNdPWNFnbez/a04rQOAkyurrolhhsJiHW1SWOVDBkJfs3qXzb8EpsFzoFxOIVAcr1wlqOzyJLgvtbjAU8duashRzNgA+w/1Se3rQzBwikI6GuX6Pb2em3ZZUaHfryshg3ff9APNHJgvHz2CH3KC+FqINKBefZWN5+/huCpRgxKXhlLlQo70ryx8fckIO80NzR0Ab7H8Lg2aF/ynIShEziDqsQm3j2mlJ1NINj/l8KjxWH4hMWjQR4MkLhG5Cej5TdGTHHSOYqRuvh3HtcY47Lp0Lki4FYyURfbb52Q+ZMdPdbEZcpET6MgReE1G05L7
 cIsylQHu
 77uO+LAzeANqEJtXm0Zo3DdMTlOXFGElAcO7BJUQOBCw4y1B8kW9X+NSBVwX/blLCe9A39GyScQpZZqabR0UDeuczuIxRRPvOwRSAeIZ97MKLCGhlmjbwgs9STjFkkx4G17k6QN+BI+oFPxArtz8GrHJRHy36gQx3epPrdNY2XvkmQ7SdkCj5Hcqhe9ufBp55EdGuF0bho6iHguyJ+rHAwhaM0EYs/woEiZCBfsPkU3XRff4udC9fal589KN8DvqQD9Yp84oZ1roWsP4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
index 542e23fb19c7..811275419be3 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7104,6 +7104,10 @@ BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct vm_area_struct) {
 	struct file *vm_file;
 };
 
+BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct oom_control) {
+	struct mem_cgroup *memcg;
+};
+
 static bool type_is_rcu(struct bpf_verifier_env *env,
 			struct bpf_reg_state *reg,
 			const char *field_name, u32 btf_id)
@@ -7146,6 +7150,7 @@ static bool type_is_trusted_or_null(struct bpf_verifier_env *env,
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct socket));
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct dentry));
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct vm_area_struct));
+	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct oom_control));
 
 	return btf_nested_type_is_trusted(&env->log, reg, field_name, btf_id,
 					  "__safe_trusted_or_null");
-- 
2.51.0


