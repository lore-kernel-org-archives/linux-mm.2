Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A78AC61DC4
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:20:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B73596B00BA; Wed, 26 Aug 2026 05:18:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A600C6B00BB; Wed, 26 Aug 2026 05:18:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83B836B00BC; Wed, 26 Aug 2026 05:18:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 41D796B00BA
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:18:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A480C1A02EB
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:58 +0000 (UTC)
X-FDA: 85142871156.30.BF92355
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf29.hostedemail.com (Postfix) with ESMTP id CD82F120006
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uzNntNV6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3f6-OagsKCHQSUcWjdWqlfYYggYdW.Ugedafmp-eecnSUc.gjY@flex--ackerleytng.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3f6-OagsKCHQSUcWjdWqlfYYggYdW.Ugedafmp-eecnSUc.gjY@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BY70MMIKZKRKauwOTq9m7n2x1FHu0Xdv6rM2Gy5jXqw=;
	b=KQMjz4OkiznMNxRg6PQXuLAbgh9ehns1ZPMl238cx7Ovd6dkbLc6RMql6XWEZvA3HNrTgN
	flHi7sDbnPgaWoswflGA7/c628vI//QdxVVLU5NxILXLkWe14l4cbJc03RNpDzLAlkTC71
	pxq2ov33l3FvFwTSZjvhVkhZGkFOP48=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uzNntNV6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3f6-OagsKCHQSUcWjdWqlfYYggYdW.Ugedafmp-eecnSUc.gjY@flex--ackerleytng.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3f6-OagsKCHQSUcWjdWqlfYYggYdW.Ugedafmp-eecnSUc.gjY@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735936;
	b=P8mqZ3tkFPzqzdbfBJTzHhHRBxS7nIytsDHC4I74MQWa2LrIDPThpPTJvI4Ocrhd67qa7S
	5xvFE77Wc3NcvUPfCVZcdwTkdrnG6oTMErpwqHXwgOpk7y2fwu8Ik9NDORi7vs6u8TlJu4
	zjGzkV7gyONFZnqfPfiRIfhYW5S1Y7s=
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cc12e8e22b7so1714872a12.0
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735936; x=1788340736; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BY70MMIKZKRKauwOTq9m7n2x1FHu0Xdv6rM2Gy5jXqw=;
        b=uzNntNV6dumVjnNC4IYE6q9PZblOeNcyeryDkS44eqkLmcyu/xghmtS/cUdhD4di2n
         KCyNFnq/qQuhGrCQUgli0ZwfZgmRPQAXipWHnAF937TXwCxMTiJHeB9ncJ5pGVLAwGEF
         2dqEG/pGJPdvgrMGD2Y0U40Y9RRsxIr/8Upgj6nZgDqQ2tEqyb/cFi24xmiWlx11GdVc
         VDC7c3uHkvETY37IjPhEUB1pgHp7E+ckPOyxTn/l9xkk4bH2jdAaAIFvkSen/v1Aj+Mk
         3/ra1x8hwde7CUnObOpVW49VXq1FyjsvT2XvK3Ioo2ZR6kbykdqN+3+cjnQwe5Y33zha
         PAkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735936; x=1788340736;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BY70MMIKZKRKauwOTq9m7n2x1FHu0Xdv6rM2Gy5jXqw=;
        b=e5KK1tvwDkqXAfSnBiWcCLP1jdk3Pv+6aZybbkNZ6DRQfZ6ssrVgoUm47u5h6yoQh0
         ZaGuV1pRzFGQNTWnftPJTsjnYsOuNP3zWAsFXiWPpQN4yXPCph4d4ZeQUQ9EXNbriAsd
         bQvKR9OrMVXT3VF/OAUDagJst0nzgFY8cfqlnL4zzj3ClFGStNmGzkSJakS5nTtOjUbe
         lomoPfjxcm1w9gwDGe6R5MZazY+/T9hE95ODnUskWHbxca0mXkdA79yxk3K0i3Azrxzm
         FuVF1Vt/WTa/s2ZFf+O7dTR03+CghzKsf1FXzGuhLddtR6EXn7Af9pqg8OauZglY12zc
         CgCg==
X-Forwarded-Encrypted: i=1; AHgh+RqieN8xG5D1cnACcMN+93nKIs7e+5px1or3KkVzZFbMzMAMMzLRlVptSt0J5i60e7IFdZqIW4Mgkw==@kvack.org
X-Gm-Message-State: AFuF++n+0OW5sMFV3UHX/72YIIKQQuqNwmgP/vtrJYpGFiO2w9fuoBTl
	+hOdD5dYPcBA8ynXSOORdY9KnYzkl8a+7r84VmNegpuvxKb42GpJjm9yunhpTnGBrGRoj+4/b7/
	LWwUKWM0W61mfA6tHn+IThXidUg==
X-Received: from pgnd15.prod.google.com ([2002:a63:734f:0:b0:cbe:6339:419b])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:9202:b0:3c3:64cb:9b99 with SMTP id adf61e73a8af0-3cf76283ed6mr11221625637.6.1787735935314;
 Wed, 26 Aug 2026 02:18:55 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:26 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=2380;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Q/A6Dc0B0gRna9abP7QnB2WrkUxTYkjcUX3FbTtwMJI=; b=2YkTIc1SmD00N2MMdJmLmjlME4gtBWUYhIUyh7O71YGRuPDt2J8tpdmJsRGiLloiJb86kHa1e
 IiS094M8sscCQIJsw6CDHW3d9k4k2B+zvtFayWaStH6wkSP2zGMskI9
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-28-0a15d8a799aa@google.com>
Subject: [PATCH v11 28/46] KVM: selftests: Add selftests global for guest
 memory attributes capability
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Fuad Tabba <fuad.tabba@linux.dev>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: 6by6zjmqu6u36miu3mna141tfgwgypgz
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CD82F120006
X-Rspam-User: 
X-HE-Tag: 1787735936-785826
X-HE-Meta: U2FsdGVkX18gKVjVQpKhNL+ZyLvgPeRgTKA41qlVXfB+0bYX5SCw3q0k+P/RbMIGfvYgmzpgsjS1XVjCL2Den6hLltQnsH1/DZrNg2FuKG2dUBdHUJ6MAKv24sz+0Njx+G7gus+k2J41dMgTbsntstOvwH3d/kOyMS/lLvMNcAYN794QQsBaDoPX/iLVncsqOv0sDMmZWG+ZskVIuq+/RLm6HxqOcTpi2I7jO9rXagfMjzpax1oiDVmN/yWnk71btPiLYh9CvO/8BHXzRtaViNyELihBGVJievgQG/fkma3ujxYkvFZnYFkn//zvGESMCJg7NukLEi1trfiWBBMOLcO2800/CwC+Ka7PSy8n1M2tF8iV0E0zLXoQG7g3Z3giDrLhtLSGaTUATrKuY9ufN0qrLlB82JvtC8G9LrttSTk4qxUFgnxMblMuB35BJV1BgVc+Q2nuwpq7sbIYt6QTO/QwdcLRbIrH76Z3/4t+JjeE88oWFaBHQTm/kbUbNXA1sxiZGeBv5M9PxzGCQVIBp2frawIn2r/lfAHrFyA1PcZbWB92SAxK9H7DqqAtxDpPBovLTV+Xci6CXfPH0rzAXCAO8tdGCoXmzNAuxNuZ0OeOms/JKQ/HUJBXm56nhvPTvqwFrIX4alcndNjYsVnu3+R9kXtcWNM8hEY9OLwfEmWpORuIaX/eAoSKQWzEYGV2jOr2pR2haMB7UvuxDNfNQJi0PCo3+cHU/bnJIV32a2nFKbUF1yVfK8/8+6UJrqkLd+u7JjzqfPKF6Ftkya6Nyr3NUNHg6ONugZPr6f+bE2uXLQZJA3fWxLeoIdBHksWb9UbwRRm/PLYSIE9V2S09NBu5S+GjRSviNERNLASRX3Nb7KNRJcqleLSh/lLNnU3TtE2z4FjSgmi33sLrW2Xq/4IP71RYaiMZKBaX9kxNHFOyJKuWn87RThIxW4sySx2yQvpI60hHiRpl8U2sMp6
 EgMZIzRu
 ZqIBaRINkwI9Djz1hEEsxkZXq/2ow/HQI9I24xPTxYkeZEMMSkp+eWMu6hgAxy2/YWIkD5CAmDHtu9Fbwo2+aKSOtgiI1OfhNrzHn5ST4EklkD5icmAT4nkiohY3LDu/+7stRKzJFVf+h+H6zS8naMQK5MIWg97uvSvooNI8SQe5U4gfvfI8ymyYGUUxHtrT21UsfjZgbOCclaAhB1ec5tzQi1G9tQTPe19BY5nlM712akPVua1Gql2a29jyTg8uO6kI0DO7HNPp4kX5V0N/roP2z3aoRsKOpd9H5VpCGBF+9uPsag648uCEINuLZln4yDgskyUupnJchfY1/ZRK3HvD+dRxZ4meDAvV56Of7UWLamvOUeP5rIErA+QMbUl7x0FwYb6KZxp2RslzsIdG768Ts74D2pj/kf3jCr5grHI4kaEiETuiUrjpGuX7yPapOw45et0vhwOSbU8Y6/L2mynJXd+UDlJpekPmm9xaObmtFvQ6w9QxScS6lIdH6rTM1UwO1vg4xDQa9QxlVcuYMw9HYuFLYUX5qiw3va8FtQPWvzRjtypSDGc2rjXG2ntxYpCUy3ZVrU4JCbZwbbMCWWqII0kpwy4RduBfQEInmoDSHlKOM8hRHojKSjsS3YrbWuCzdtPCQFZv0iiM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Add a global variable, kvm_has_gmem_attributes, to make the result of
checking for KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES available to all tests.

kvm_has_gmem_attributes is true if guest_memfd tracks memory attributes, as
opposed to VM-level tracking.

This global variable is synced to the guest for testing convenience, to
avoid introducing subtle bugs when host/guest state is desynced.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/include/test_util.h | 2 ++
 tools/testing/selftests/kvm/lib/kvm_util.c      | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index a6a3e16578959..d5825211f2727 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -116,6 +116,8 @@ struct kvm_random_state {
 extern u32 kvm_random_seed;
 extern struct kvm_random_state kvm_rng;
 
+extern bool kvm_has_gmem_attributes;
+
 struct kvm_random_state new_kvm_random_state(u32 seed);
 u32 kvm_random_u32(struct kvm_random_state *state);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 08d0bbcd421ea..cd468b2bb8343 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -32,6 +32,8 @@ static void kvm_seed_rng(u32 seed)
 	kvm_rng = new_kvm_random_state(kvm_random_seed);
 }
 
+bool kvm_has_gmem_attributes;
+
 static size_t vcpu_mmap_sz(void);
 
 int __open_path_or_exit(const char *path, int flags, const char *enoent_help)
@@ -527,6 +529,7 @@ struct kvm_vm *__vm_create(struct vm_shape shape, u32 nr_runnable_vcpus,
 		kvm_seed_rng(kvm_random_seed);
 
 	sync_global_to_guest(vm, kvm_rng);
+	sync_global_to_guest(vm, kvm_has_gmem_attributes);
 
 	kvm_arch_vm_post_create(vm, nr_runnable_vcpus);
 
@@ -2311,6 +2314,8 @@ void __attribute((constructor)) kvm_selftest_init(void)
 	srandom(time(0));
 	kvm_seed_rng(random());
 
+	kvm_has_gmem_attributes = kvm_has_cap(KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES);
+
 	kvm_selftest_arch_init();
 }
 

-- 
2.55.0.887.g758fc8c411-goog


