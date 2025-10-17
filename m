Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF806CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 20:13:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96AF08E00A1; Fri, 17 Oct 2025 16:13:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F3FB8E0092; Fri, 17 Oct 2025 16:13:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 721C88E00A1; Fri, 17 Oct 2025 16:13:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E6DA8E0092
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:13:32 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2623E1A030A
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:32 +0000 (UTC)
X-FDA: 84008706264.02.9863EA1
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5AB961C0011
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hZ1TrYO9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3aaPyaAsKCMgoqys5zsC71uu22uzs.q20zw18B-00y9oqy.25u@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3aaPyaAsKCMgoqys5zsC71uu22uzs.q20zw18B-00y9oqy.25u@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760732010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dmdP6R9nC9lX1jXEEElpeV73O9FQiFshjkk2aEtJ9fU=;
	b=K5KKjk5g5o+QEQzs55isLmSbVTcofwIF0MGGWoSGY2+CueEH3La8NvIiPhgFSaP1H8qy3h
	9UUUbRbTa0wY4GsJUQNU+v69ob+Q+JWYGIFiwN8Nj5/XaEgzY8P2uw+W3cfpPpaUJvcaZQ
	2cadvx35asuYfDt7vfEIa9x7xum+Q34=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760732010; a=rsa-sha256;
	cv=none;
	b=1emNfXJJAc6DFjj70RR6s+ccBe/mBm7nFbrBoj50mQg9cPeQzBIk54AYceX0afCJ4xUc5C
	Vlp6uVZBjwSXMduHvlGEmqmM9xQMm+r5asUE8gWAWxK95hQm+OHTtp3tqJmrC9PpH3eBhI
	GIH6mAH2IxJYrvtaOOy9LcGxd8gEQjk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hZ1TrYO9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3aaPyaAsKCMgoqys5zsC71uu22uzs.q20zw18B-00y9oqy.25u@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3aaPyaAsKCMgoqys5zsC71uu22uzs.q20zw18B-00y9oqy.25u@flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32eddb7e714so2036348a91.1
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760732009; x=1761336809; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dmdP6R9nC9lX1jXEEElpeV73O9FQiFshjkk2aEtJ9fU=;
        b=hZ1TrYO9mua4oyx8Oo6wVJY4BzchILZM/2T4+fjvmBLhKLHVUcdk1xU/9ad1w4/EYL
         +Aa3r8hlVio8HDZjIUkafHLiNXS+PWbDsh9SWx2SMlZMrlM6wWm459hJdt6HX9lbr0l6
         Pjl3VAFcaLcDSSwSsgU0CCdTVKGjgS8dbWsIVhrt6XJlzK4EBP5duak5rFlTCJuZ/OaG
         iaD7Z/Geqp7tn/0OtYSL/ROHesf6t8yO9OwScBq/pRxUjUUWLqZ5gkcA24yGxCaR3PLb
         Y+7s8RzM2gcU31AgVlns0BZDocFcM8lF59a26dQM0XS9ZRtTjJ6p7IS5FniCPaK+VwB7
         Vcow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760732009; x=1761336809;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dmdP6R9nC9lX1jXEEElpeV73O9FQiFshjkk2aEtJ9fU=;
        b=kLue2gHhH1pbH7Qg4kdtTugIA3KtlgwytPyeEtpgghqePJZN6C0vt9c49hkviKY6k5
         FI3Zj0fybGKjoy/s1Ix0qC6y0r3Hs9xLu3gHG+QEX5oCqaVbzZJT6SRPt2L8IdtwdZYD
         afqd8sKV2Sd4/fITEtu2uGeKgEACUYVXO/k0EksoyxqyBmA7vCupCmPScXgZfagL2ZLl
         rjwIwSivyH/0+OCx7JSSmzp8D1rhAS+ubG+1QyDM4sA0AHOH4OV7pmS8EkQnayaE5g/F
         uR2pGWO+UE3FGaZuCx82UgHG1cLxpJZHjPnEmT/xO8AIqA3pfedw4YQ1Z1/TpH6EPBI2
         lLFw==
X-Forwarded-Encrypted: i=1; AJvYcCUJz5t5poBi+LSeOn7Ren49FVduCbKQzqQtlSuvklU5d6PsWMWHZaBE4jHMq9WUh0TTOEgJh++ifw==@kvack.org
X-Gm-Message-State: AOJu0Ywv+bI+z98ZnwL3jsLhCY+eMuFSOD9CnOeCkeG4ww3jMHZSx/9E
	y5ZSEAvoHTjDf2xPxYC4iEtSFigCMNkBmdi8SrJsfEEdgiVG8eCE3wRZkwZ6mLTzcmyynicc8aO
	EcbwcAn92hXmFnBG1O7PXC+BroQ==
X-Google-Smtp-Source: AGHT+IGzgAEN2nLVpJn47Rpink95697ahn9+YSd6/QfacQuWgps1G1sah8dROQQkq3FQWO7kCJad1FtwMfse5d5QhQ==
X-Received: from pjbsr14.prod.google.com ([2002:a17:90b:4e8e:b0:33b:8b81:9086])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:52d0:b0:33b:bed8:891e with SMTP id 98e67ed59e1d1-33bcf8fa427mr6248763a91.19.1760732009057;
 Fri, 17 Oct 2025 13:13:29 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:12:17 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <ab7645218a87a45b0f3214a07138d3c8eadd3164.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 36/37] KVM: selftests: Update pre-fault test to work
 with per-guest_memfd attributes
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
X-Stat-Signature: 67y6w7ymkxpiwzawpw6fao6e159r38nu
X-Rspam-User: 
X-Rspamd-Queue-Id: 5AB961C0011
X-HE-Tag: 1760732010-826391
X-HE-Meta: U2FsdGVkX19/AMSJaQXHtMxR84yHvAwE1b7GGgx/MDrlqqh2yrTsEvJBmXWaM3vvjjOJSACWo2iricSZsae8yypKSkdY5yci6KV0cs7L7QfCViPBm3puo7DKcwQkLT9d650W/1ie6djlji3VzoKLAKDWe0utq/MS0G48sQjiu0QKUP2JuBV5fLGDzf6RLTFgxdPnoZCtUHgk+54+CsIb4O8/fKA3QkE8kpPnoRJGh3VIZAKcljUJ7F0dJVCOt71sxC/QADDHvVK0XulMpbHdjC+OSC7z0OEP0LLYWNGhVGBRauYFT05hsSntFvefq6AJjbCoaAZ47UX/grVloYqqllepfZVy554l/P2CTuwAtaWOUT0wQy6IyF+Il7ydPYq8hc6TuhWJy1VIJQV9gf0kkPFnhX6fuCnU3o6GjDVE31OWhA4SLUou4xUPIycH3maIPEypqqTiVzlwqVL0hKDQfSQjuavm/ZoqdBa4+KlVC/EOjSmLHZRBzRbuduirwYsBkEDEZR1qPYRELiqpRP9kQHPdzr7r+2Q3gfwOtMqnFcGmdaOJbUsJW9/qtH8WCr1FzrE5+/+/a6byQ4mnkVTitThL9KapAn7LwJCZBz26d32fy+/qpB+kBfLd077ppIGZZx3EVqPeyry6jheNIScLpWr9Ujk2CS68QHKSAJQcspGzuQcr4Q3FTcX4GIHlqavXnXslDXABwgqAGzXQzW7wSKOut40+1mRRd/4oVdjfzU3UbAR9mHT6yCfY04uR/NZSlh4GwDCZRXppXbIJDpqyOw02dqgB/gkSfeLu+ChmuA3N3MIYK4GInJ6kb5Ag/U4fa3ywppxNnm2PpnSNf9/wV8G4/ikCTvBvKwFcgx83CMmqtvWCZTumnOXqQl7A3k4Y59PfHhp0SLeP64dfttYHw3A1EGQGYK6Fag7BoHwY/hE798eDwcA1FTtuDlVhB16XerLbvngtCgCNojxgT56
 L3dIgv0s
 gLhT/kv5CDYJ8P5/hAzUiIW3O6nKc65GWhb+lcpjNwVzDG+mq4CRgf/VpPfEa0SBo9oVkY6K+y+2iASgG6E5M3e/YhVMJG5OeNH3O8diDO5quh5DfB1mzpnqz7tQw2BcsZ2QOT/+zaXjPPY3geNtnbLvUH/KMUZ/SSdkIpRDgZJpTIri1/SmYYgCga/dSdSVYrpCyIi39Qqr4Dzo60EIOT9liOBjUp30F6gwHdF4c03Pg6i4EJp/jG8hhG1MONnK7OS+w+DxY1qtaISe8OW3yvxA1NSB4bPV7k1eJenlgOar3GZVh9XV0i3sfZL3KE970DQM7rrfs8F8Ay+wfETdL4guux8HxWmA7MyhRT89pZZ6ug43zZip3hxcz2HYEn9hmaCtq7sVZrtvkdK+/q6RjemLewcV72/FnwPDwCOyqrt6CpX8MLO6lmk/d6Lbzql4mtccCmNYx3oHIj/ua5spyLM3QmM7JI55gg3pW5wyBJ+hx4PMMETyUbNOVfhYiNgxXtiGapAeHCdaGaeSAjp6tTZlZVc627lcai+LUJo5YjPL6gWQbpraUU/jekgMcokyz2lbkO5ICX3aIxBIqQTfG9qW6YagQyRNFLupK3tFzcPpSJkbBGR39OAvMhG3q1gPZqi4fl3UdvUFZRrAx92hg5rjXPO7WYAdUkP/Ihk2Ocp8PVFgj9KRJQ8pKHsZaCJsm4ujL6+hejHiPJVA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Skip setting memory to private in the pre-fault memory test when using
per-gmem memory attributes, as memory is initialized to private by default
for guest_memfd, and using vm_mem_set_private() on a guest_memfd instance
requires creating guest_memfd with GUEST_MEMFD_FLAG_MMAP (which is totally
doable, but would need to be conditional and is ultimately unnecessary).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/pre_fault_memory_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
index 6db75946a4f89..6bb5e52f6d948 100644
--- a/tools/testing/selftests/kvm/pre_fault_memory_test.c
+++ b/tools/testing/selftests/kvm/pre_fault_memory_test.c
@@ -188,7 +188,7 @@ static void __test_pre_fault_memory(unsigned long vm_type, bool private)
 				    private ? KVM_MEM_GUEST_MEMFD : 0);
 	virt_map(vm, gva, gpa, TEST_NPAGES);
 
-	if (private)
+	if (!kvm_has_gmem_attributes && private)
 		vm_mem_set_private(vm, gpa, TEST_SIZE);
 
 	pre_fault_memory(vcpu, gpa, 0, SZ_2M, 0, private);
-- 
2.51.0.858.gf9c4a03a3a-goog


