Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C11E9D25921
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 02:44:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36E5F6B0093; Mon, 26 Jan 2026 21:44:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E80E6B0095; Mon, 26 Jan 2026 21:44:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C6AD6B0096; Mon, 26 Jan 2026 21:44:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 06BE06B0093
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 21:44:49 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CF6C0D3C48
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:44:48 +0000 (UTC)
X-FDA: 84376201056.13.D2C7C2F
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id 281D2C0008
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:44:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e7K+ACi9;
	spf=pass (imf10.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769481887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p7vIbktSHcqXA79Byy9E+tFFPUOD4j27CypvW5n/XGM=;
	b=LAJRhq+SzVpLSMW04Xt9oLCtiR4YF3370O1QzDpIYeLpoZ9tc6WzrtjRx/YEhHURiBmp+6
	/lLEvAc2rW3UO0TgkcJ1B7FQOH7pDWCT5e//zLmLeMmGFO9F1a1MvhcvRu/eyp7rUTbWZU
	dc7n2/xW7NYtUWa3MQVBIQ8M1JEfx4A=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e7K+ACi9;
	spf=pass (imf10.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769481887; a=rsa-sha256;
	cv=none;
	b=T7j4u3qRZSiQAQu9S6RSi17Vd6OQc7j8fcitbIMxk4hX2r9cbgzvu/kk9YovFawotWGaj5
	TD6MPclw6HWjyM41XRpTiNGQoI8VHt76+wwNZBaccXo+gyQhM3YsndR8e9rgZ3hYss755N
	SWuxkNcDujxAO9Ktz9EXcQQzTo5Eh3I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769481885;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p7vIbktSHcqXA79Byy9E+tFFPUOD4j27CypvW5n/XGM=;
	b=e7K+ACi9n83DQDrLs2gEyZxviqSCTioKtYK/6R2Y1KGkxiJq+PltmgZRjD4uPP2dmip1bI
	5902E3TbHB9SilvMJ5/obvDx/18kyu4hDGILzd0QyuPZgSHy2rJZ3wkN4vN0jsDOwK+s+p
	Y0PamNzRWNBsZqAdHYuRvLH9MSXAFkA=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bpf@vger.kernel.org
Cc: Michal Hocko <mhocko@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: [PATCH bpf-next v3 05/17] bpf: mark struct oom_control's memcg field as TRUSTED_OR_NULL
Date: Mon, 26 Jan 2026 18:44:08 -0800
Message-ID: <20260127024421.494929-6-roman.gushchin@linux.dev>
In-Reply-To: <20260127024421.494929-1-roman.gushchin@linux.dev>
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 281D2C0008
X-Stat-Signature: 6isrzy5ja9ds19rzhfwnh7xd7he3xx7m
X-Rspam-User: 
X-HE-Tag: 1769481886-74156
X-HE-Meta: U2FsdGVkX1/2pIVmhMDiaVE7s9hANkq7dXRFpaXUOHmIVz/5h0q2E38bMaLvD0nvTJ76GjsUDyJFugFFjOHIL7mpqvJwqXaU3EJTBMTS72EsGAhgQ1/QQtFz8nysjv9iIS2y1nBrdFtN0OSJDbhrRyWexoLidRAdvhfGUpbvBUlJN80MnXt9lPwHnc7hxNkeh5/2n8vhwH2lg42LFeLqYEnvK1q3+tFg5oCIKt4FFEMuOBTJqiWD1gZfdS8nnCzCLvLls720SuyJUckzZlHQOBNdful7p/l220uYWAirXGOKOOk8oDIrCr8D3TQzTDE5XaVz6QiAOLJL+uxMT8BvNP+Hk4+VqAhxn7ntNRVpCObgv/GVa5ga/ZLQtT1Hp3ArA9qhIakFDFtCkFZ+b2Y2F1WkzxE0R00vZmYhreRQTHbkwmlcdY5bpPR/v4XHFinCLozKIbYH0+FyfXbpkuRPeDFlmL1CwY458V6G5vnP5vAoS5YVZ6GySNJYkUCHXhhB5OCztEM4d5DmZtkxgPax0Vwo42czJkzhSziSV/gqQxrMTxbdpjkDni9BmdgyVe3uGAiG7948eHTJ6m8XxwcSrl340GsRaRqXekLk8PPqUg36SjSUN8Dc1otxayGFx4cko+SL7YdM/qjfMNw4HyIpyDSSUtT167Ycf67aj91MBokSrvIsUUPGeRVVDDD5HyOGFGvSSKfiWF1gD/3tJBXQdcvNzPh3yjbuBRmrf3Hqqqy9aMpHYXxC7mX2E6pH6y9omrIoAOd2FK7VM5dYLPtti+SJT/zHDIXVZiF9biq6PmLu2P+3ctCKObYPJWR6nuneJl4xDaWT2T/vNXPto0CUSdnJNsF6YKbbXIuJUTl+qLU2rV2loHyGEa+evFtC42IzoawnLabcbB10TZAeGlO5Oq8mOrS04+NRt0TFGffDeJC0reA4NMgN0m+rXlCshzxY9XQiWWuQRCjhBRNA+VK
 To1V3COw
 yNpal3e9NsRbl7jI+mJWrNKSFCIx0GhNjdyHBVXMa6jY0FRbIrYKm1espIXUakNuuKOt67E1xMa8X6khlKDudCXXa1zbXbhfk7ysvHDoA5udcLbaKXiCa8mwGhiIuoArLYmRKm/rQrC2lf3EI+ZCyIqHFlM23vg0SrhZhrn+LA1aHNF9Okpx7IL7ygpPeCb9/Z0/eIP2hwhhZSTAO7qbhUQj7Y/YtvqsMJFlUC9ytvuF/cLK0ZaB90you5KRvFzrHAAqUJfCavsI4QLRARpXH41PsEA==
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
2.52.0


