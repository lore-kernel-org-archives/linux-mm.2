Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E42E7CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 20:13:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65D238E009A; Fri, 17 Oct 2025 16:13:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 599298E0092; Fri, 17 Oct 2025 16:13:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43A6F8E009A; Fri, 17 Oct 2025 16:13:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2DB2D8E0092
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:13:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EFC521DF6E6
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:19 +0000 (UTC)
X-FDA: 84008705718.17.323B111
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf09.hostedemail.com (Postfix) with ESMTP id 30247140003
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=i2EV5Bjo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3XKPyaAsKCLsbdlfsmfzuohhpphmf.dpnmjovy-nnlwbdl.psh@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3XKPyaAsKCLsbdlfsmfzuohhpphmf.dpnmjovy-nnlwbdl.psh@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760731998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z/lNHI4Q/bFe7E7u1u54KO9h5F/sVs5DEw3rAt9A97U=;
	b=n+cc5sgovG2oJybk/SWCYIhrVHXCNe89LT2aNsAglT7Te4mZFr0bmz4GC5by2ipzquMjjf
	vfCUt/RADdPSe2WKdlpGiZz9KgNpYNOdd3jk9NgoJuXIoT/gCCcjTNL6EA1Bvu+SGEftd0
	JIKaBTVCNZoHKqr3KkrRxWHwUGDgWz4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760731998; a=rsa-sha256;
	cv=none;
	b=FH/FAdVr2lCHgDhbt6xi+oQQSwwmEIgT57vT2WxSSkrsngRtbB/exH5VBRqf3mpAizk126
	dP6sKk94DJ5hp0rXug39/ccx8vwuvNDUBIXoP/UQjvBb4OPvcJf2suVlRM91qhugXAAcs2
	JU0qVWPJrwhEDiIIqe96/vYAZtp45K4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=i2EV5Bjo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3XKPyaAsKCLsbdlfsmfzuohhpphmf.dpnmjovy-nnlwbdl.psh@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3XKPyaAsKCLsbdlfsmfzuohhpphmf.dpnmjovy-nnlwbdl.psh@flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-334b0876195so2500162a91.1
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760731997; x=1761336797; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z/lNHI4Q/bFe7E7u1u54KO9h5F/sVs5DEw3rAt9A97U=;
        b=i2EV5BjolxnKmjW2XrFuuKV96K+LwCncTb2/ohonW2eiRwdYUQhy1NKKgnrHZnxjDC
         chzHhh32WF2K2Io47iePI5sDWxhuWluttt02Uq9tyEdclIKbMH418Hylb+TcKRPmKvVs
         zECFcbZCHxhTVgzE8Gyl3CvBKZzcsxhGQChXFnHg6cfIJetYOgp3g0vyAfZ82baGIxu/
         DU+WvYbXeo/4E936L3tBxTAy7Ze8KN1ghdS5W0QyAaqedmdKcEihHPNdsESY01w6KMl4
         Idj5EyObPkmH8gufVFHaQW8ShrT2m4mrqOLMBE7n7UJLnFe/+kiWEvM8QcDwqY9rOo/v
         9t5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760731997; x=1761336797;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z/lNHI4Q/bFe7E7u1u54KO9h5F/sVs5DEw3rAt9A97U=;
        b=I1uos1EUCOfgugoNxzetRorOhsbYtUfuqEOB6MVypsKc1s1qOyfXyK8wgKuRTY991z
         +lq584eRaqr8vGFzUiJnLJg/0uk5qTEIJlFtnISUE+lMCWPlAJT4wz9bQUzvACnVcV7W
         bONWhvVXV+D7f4l6sFt2tJ7CAdUDFV0hWGNP5QEIwIWery/LguSkhVawddZMZxokOYBY
         p9R5+vnW5CcyWWL2AFaTe5qd7A9Tr1kzBgFJOL5NFrqEXuFwq2qewgWqcuZYneBlaMUB
         kNkB7Vi+MFCRSBhZ0C+DS/zjCa4hvnf28V+9U8ryOxickwZaOtk0yhBhuBi4yoIlnCjb
         C57g==
X-Forwarded-Encrypted: i=1; AJvYcCV6pJsJk3FyMD8/3wQ6JEXji7dULMT8ebxOFqXkrN8KKn9SoUbA5YXL7p0zDu9R9efQtSwjYRxrVQ==@kvack.org
X-Gm-Message-State: AOJu0YwK7Hb2z58rx/626RdrtjW8QUfcsGeMhIJ5fw9tuTPtsSvTALva
	ymabWc20xc63gQcbHLm7f5lE0ZOd3hhAB6xlQEjzPxGh5Amsh7JsGjYJ5tP54inG4e7DyIXvDFO
	tzq3RCEUoJdQyVZzE1D37zQFasw==
X-Google-Smtp-Source: AGHT+IEJOmwwfA3Kaekqa8uydRah72/LLd/POEax3xDQXkYFm9XmuPnw9MNGeowIWx2EtPAAJiD//RyC47hEWG+7ug==
X-Received: from pjbpa17.prod.google.com ([2002:a17:90b:2651:b0:33b:51fe:1a8c])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:498f:b0:33b:da51:f05b with SMTP id 98e67ed59e1d1-33bda51f510mr5711640a91.26.1760731996748;
 Fri, 17 Oct 2025 13:13:16 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:12:10 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <5656d432df1217c08da0cc2694fd79948bfd686f.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 29/37] KVM: selftests: Add selftests global for guest
 memory attributes capability
From: Ackerley Tng <ackerleytng@google.com>
To: cgroups@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: ackerleytng@google.com, akpm@linux-foundation.org, 
	binbin.wu@linux.intel.com, bp@alien8.de, brauner@kernel.org, 
	chao.p.peng@intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@intel.com, dave.hansen@linux.intel.com, david@redhat.com, 
	dmatlack@google.com, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	haibo1.xu@intel.com, hannes@cmpxchg.org, hch@infradead.org, hpa@zytor.com, 
	hughd@google.com, ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, 
	maobibo@loongson.cn, mathieu.desnoyers@efficios.com, maz@kernel.org, 
	mhiramat@kernel.org, mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, 
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, 
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, qperret@google.com, 
	richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org, seanjc@google.com, 
	shakeel.butt@linux.dev, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	tglx@linutronix.de, thomas.lendacky@amd.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Stat-Signature: ri3ppzcp476xyeg6fof5x1omaighd1n3
X-Rspam-User: 
X-Rspamd-Queue-Id: 30247140003
X-HE-Tag: 1760731997-995354
X-HE-Meta: U2FsdGVkX19GlU549/mGhH6/TFkZlW49haboUXq0wq1dqQNUBnA7E0H1VrL9Xg+cd/3K2QnLbwuIc2zQWkj/825VF7IxM7TnFrHUxjmkhqEIfNlyQdLrWONf9ubbt7neAh6AcHyLgwemWbWC2WjPZa/+r+F0r5uVRYshEWWJrPPYT8rxuWlG1bRdzDzBf35DQBA5lAMmDBz0TCbQi4goHqy24bRBYYHWpC/KEupeI1Y4M18aYbZReOqEq3Cumq/XkGpFU7vWN6UrSKQy1JmdjvUjbQ9wCbMZl87alhaRloJYLXTpDSU8tcpJ1W+SxNGpE6DQGIBBzmXbSyeB9LzoPiGGN5gWEVz4owE9gFWQG5VF2wMVMUZHDzXg0KKZpNOvpYAP5pRmXr2w4Cev/NG1ngw8kTtPN/Nxij2VAhly8yfLwMu8P6uoc9P9cpdgtJkLIj5+CYWI66Nfexd2bbI1rjT4aEwNzw01+mdnosE9bAotmYGk6YkL+7X2nP1ZfuUVb4ECna5RMtD4+PVOpsf5EJpr95lQwqHFIBQQ43GMkzqCXu/4A3mTcdPTn/P5KOEmu7StWlcTuEWaQ0oxyOHsMz9XaZMSiswFuV022VNvGtmGk7X738w1pOXxZ9bNd78AihyBY/BHxmii9FWqQiZmnI5SAWGlns7wta8EDWx8EuK0k20tnpqrKhGcLwTaCcBgjFUGsibv2lRXnQZgYjstNz9VWoI1MiUL3ZGRI7eeD4PtdsXLqMgkI3eybhegyO64UaAim4/+RbzTpArKrJRzghrzzR0e4VYYEdEbTER5401hSK46K9cUpmzLdxO3EYxJoSyggcbKM8D6PK7JDLzHQae0J4FsMq2BP4RUlR+TCjGVAFQmOraGgkudoyNETJhlxkAbE+d6BcHVndmd3iLvN/nAMIhhdRb9tYn6DpA/QKJkWX1vzXORcbaI9A/I512D0dvP1SqJtyq22HCqIor
 9KPotbeO
 7aY8diduaGWWKe3wJik93MJr5S8rw3V5ZpEgqn0Eg46R4aChnyuy59LL4URSxS7LKduYh+4NjJweYWTdiagPYvwoVqM5DBf4EFGtJgPG9qL0v13jio+dWBsKOOu4h6bz4W7HNg55zsom+BjpLvSLFcXGHXA34rbKP7XbC2Z6uIQqNFyrkcL7lYA2YW91D5F348Hy0RxAZT8y+YlCT8fZ72DNgGjPMeIf+vcoq1UpOJZiW0+dFnY7kozA8JzhN4NHEChQo4yJiqPIc02Ds35g+krnCmk0E96XF4Z35ICGalw24lUIj2fpZ0s6NyJ8llZl3xAetKyURZqblgZl4xzVHiEWAkc7gac1UcY8UcslrLCYHPkpqQlRCxKGdA6uHT9R+xs/+BvV0esHAjYBGABSp9BpWkGvSeuYz3454neeze1PnH8I8lpJ2wW5bYtya9ucHEkkDdesm5ClWhJMDhj6+x5AS28tACeQVhrmw/uMrQ4LMTAcqXKL9bvZYHobNY4NRUIuwibHeo06AXUblhcR1MQ0ZbQ+Ku0FY9I4pk/yFRSwPvO5mNvvgTgDUBjVFn6kltvSGVkwETT+J7pzk7mk52s5HG8/tFnvoHPAk8gG92+dVw1crP7nfeav73k09FWGYK3GYjUn+zQBds5+kd28yJW3lAg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Add a global variable, kvm_has_gmem_attributes, to make the result of
checking for KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES available to all tests.

kvm_has_gmem_attributes is true if KVM tracks memory attributes at the VM
level, as opposed to per-guest_memfd tracking.

This global variable is meant to be used by the host only.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/include/test_util.h | 2 ++
 tools/testing/selftests/kvm/lib/kvm_util.c      | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index b4872ba8ed124..2871a42928471 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -113,6 +113,8 @@ struct guest_random_state {
 extern uint32_t guest_random_seed;
 extern struct guest_random_state guest_rng;
 
+extern bool kvm_has_gmem_attributes;
+
 struct guest_random_state new_guest_random_state(uint32_t seed);
 uint32_t guest_random_u32(struct guest_random_state *state);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 19c0445c0b296..c9c59f3ecd14f 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -24,6 +24,8 @@ uint32_t guest_random_seed;
 struct guest_random_state guest_rng;
 static uint32_t last_guest_seed;
 
+bool kvm_has_gmem_attributes;
+
 static size_t vcpu_mmap_sz(void);
 
 int __open_path_or_exit(const char *path, int flags, const char *enoent_help)
@@ -2321,6 +2323,8 @@ void __attribute((constructor)) kvm_selftest_init(void)
 	guest_random_seed = last_guest_seed = random();
 	pr_info("Random seed: 0x%x\n", guest_random_seed);
 
+	kvm_has_gmem_attributes = kvm_has_cap(KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES);
+
 	kvm_selftest_arch_init();
 }
 
-- 
2.51.0.858.gf9c4a03a3a-goog


