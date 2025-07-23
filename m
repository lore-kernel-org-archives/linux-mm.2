Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BE37C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 10:47:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 466028E000A; Wed, 23 Jul 2025 06:47:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43DD18E0001; Wed, 23 Jul 2025 06:47:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32C948E000A; Wed, 23 Jul 2025 06:47:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E82E8E0001
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:47:26 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EB1F31A060E
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:25 +0000 (UTC)
X-FDA: 83695202850.13.DB9A6B3
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf17.hostedemail.com (Postfix) with ESMTP id 21EA740006
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DmD9gvGa;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3ur2AaAUKCIM0hiihnvvnsl.jvtspu14-ttr2hjr.vyn@flex--tabba.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3ur2AaAUKCIM0hiihnvvnsl.jvtspu14-ttr2hjr.vyn@flex--tabba.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753267644; a=rsa-sha256;
	cv=none;
	b=V6AyfkUU35nMTD4hx7ML699OWbBCl+fIfUMAFTFo2EM0Yz66NwSdfmc5ZFWdX4QpjdCIdH
	zLJjzSDNqvHJZXcUgWgIYpwSWTAHjLhZjcKvo2v3zOgoq4HfatH1fFM2BI27T8hqxI363v
	GnzxGK/ahVJQp2uqS1a6OQ0GVc+kdkU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DmD9gvGa;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3ur2AaAUKCIM0hiihnvvnsl.jvtspu14-ttr2hjr.vyn@flex--tabba.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3ur2AaAUKCIM0hiihnvvnsl.jvtspu14-ttr2hjr.vyn@flex--tabba.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753267644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RA80cSFG8RloKjPCJxSK3bAiLUM98d+8AkAnyd7v+Q8=;
	b=geRwRrHzpCDdu//0t8Ijr6qS+ZkC2w7tVCMNjFpHnuQHdEOXyDIbZEGvTaky0V0ItnYkx7
	MRChgj/oBX3RgKQK8Q6LwZvg36LO6+uk5jBiEyZWNTEgbUglFzZtjqZ3dX0MQcL+qmfyWq
	9WPzyBVx0RaByKEVn1wXWeGLDMcUlQ8=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-456106b7c4aso3893105e9.0
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267642; x=1753872442; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RA80cSFG8RloKjPCJxSK3bAiLUM98d+8AkAnyd7v+Q8=;
        b=DmD9gvGa/8v6bvzWh7WUmer11+UaItHbLt81o1sY7docO9aZv0bTQHLYG4HXJ6nN5F
         aC0snYb4ah9jBODcCvfSIpRF2UcaWjqnaJz5NQzF1HYpbHxdcltx80TaXQj9xz7PDw0M
         vZqnD947cJiHUJN4ClTvQzhL4/c3fA4KcvocviNv2XyR8+wks4Ouh2rCWc9OXxL9FGDv
         JiLmdHDre/veGxPYkFgaqXvyVs05K6yjn6BAG6DybAIGXA67IxwDefkgqcAacWBGy9mj
         QgMKdKfZo3CTjAxPz1ZuisL4flKItRH94V8LRo60WsICAEoN6STMsob3z4S/tn/Npbnl
         5dZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267642; x=1753872442;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RA80cSFG8RloKjPCJxSK3bAiLUM98d+8AkAnyd7v+Q8=;
        b=lZL2uJHN3QbU6YULhlIUUPOlScvAtkSywblHjb/0/vqK9TyO807v/4GkZR3BKlJ3pB
         rPB2Bfn8NtcmEzqnpRU8CYiG1KoLMLZGUJOOo77U2RoNjiDV8UXDDgQ+Bn1nvXBqSWUB
         UL6E23z5ngPpxaSfvX9MtXOyJtYeg3su0zl+wEu9vA/YqWhROdB5MCYqAcxn0lvORkat
         dDRuTgGDcYHjyhBt3sQHfBJ0vnP3sPgk7iPdstY/NyMbNUlWHhnUM7F8QPQ2NdxtJDfd
         63UEANSZpzpc9VNDmGWIEG73c4Whyg1KVYBA6sdCJUqVK+ISS5V0Oe3vKSHzwNBTlOse
         37dw==
X-Forwarded-Encrypted: i=1; AJvYcCVnJBdsuvcjzHVX/27fhUbzFEFLluO3wz2g99wX/N9naIK75dj2lxNRR0UQLSdgMUgXzcNpB/yPAA==@kvack.org
X-Gm-Message-State: AOJu0Yy8fw4A9Pef6lDc7qNeRIAMLRG+EjMLwXiUDAq5ApnEGJy+A6YK
	KKOAT9bDfHTE4jlH7yMIHyV3HneF6ISiF++WFud/cQiVE0BAb2mIhXdK/GkNd6Po4tfVO2gheC9
	lrg==
X-Google-Smtp-Source: AGHT+IEHW8UPxyP3e+Y7vaygayrdzupiZRH2UQB8NKUanjQQg40Gzi7ntNOEJQk5x0u5UdSIscP/yEby6w==
X-Received: from wrae21.prod.google.com ([2002:adf:a455:0:b0:3a5:7aac:4306])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:188b:b0:3a4:f7dd:6fad
 with SMTP id ffacd0b85a97d-3b7694dfebcmr2129935f8f.14.1753267642329; Wed, 23
 Jul 2025 03:47:22 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:46:59 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-8-tabba@google.com>
Subject: [PATCH v16 07/22] KVM: Fix comments that refer to slots_lock
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 21EA740006
X-Stat-Signature: zpdqo4wc34rq4agi6ey5hzu9exx8zh4c
X-Rspam-User: 
X-HE-Tag: 1753267643-569081
X-HE-Meta: U2FsdGVkX1/9pbvNrdubpcnWYdKY3Bfhc+IBF+D+eStAzYwd3tLyhmZlNiWzdspnrg0BE3IUkfm0u4jtzSZE8mIcGFzChGDWg9Jp269m6Wd1iiBIUxpbPJMWvu2nEkOAtITpAtwoKj0MYrKeXMNDqEJxNbS3+PV59iSJyx/nGoVt99Bs/y7qJ6PzqPLHWLy9Zz2/PeMClD3yjuqNHVDEqVH0/0zceSkV17Xbr9w6HHkddKqT5tBu4QWHMJ7MZeDnbSolPq6BjHUsehmnOFUeZAPwWa3igcOBu9J7xlZk7quTNwKoQ/1QiLOMZzXwdavmH/Yhe7xP/I7brVkMYN2HaNRhZNQIMxUc/2nOB17l5EBuE0PJZcweIx7zBfMw4TTXJlBMayQ2TTF2hZT4fIdoRgs+hDJ9fLGJb5Dd6PZuvpQZxCyIbuUuBulSeY/VYPJ3olSLX2AnX/McZyJU+ceiy37JyPC5gD5+XwoPIoi4nkpI8Jl/2Zrms192tDjh4UvRZoaEf8yBSa0NcADoRjXrBUEiQcXRxbclPqssmIq9ReBkeOALYKgxWcl7//rDrEdKOmO6Zv/J8Kk550E8AhUklhwvdwG2HRiI2YhwzLjzm0umr8srd9bFchpnDBqSKORpqRuDasFBtyYQcl9I6zwjiLJsgYPrGU9qN47hObsE1CCAcu1BLG2xPYWuFeS62febNd9fzD9Nd/VGAqq8vx+zIYzT164tflthWEHgWP58kcC3kDhQuCZ3UrYk4iIDLIqpfkRrs9DtF949EJfhTstZzk8kZt4tM59Il7QZh7/kdHoEDn3I/Noi6Hf4eM9lSzqzkAlaJq1ac/lUd/pqXmgOqnzeYaTD1mL3mNya7VE3sfry0X9vfs2lbqrtSR6aRFIOMgcIuQJOwsYgByLswDQ2XpHWnZAs4J6qvGc+DXLvNDuxTs/5QS7HRVetaOBJXB4cWwMEpH+XbhGd5u1lgYi
 /3dr1+Ni
 AqUqhSZx1orIrX6WEgYmyzVa1NNlVRKHQ4ZyP7SyvC4KZ7p8xXz4lmrWDmdA1gzFJFaiVp7iAJzmRW2c/Lv16yJiRYmTv+MQXJlDBzGj/5QsD7kJ29xKPRVnnVZJhD1bOteYZF2QTf2C+UQYHLyU8IducMv3jNBBW9fpwF4Jado4tNtE3eqAW7pUP6cODabAUf3sRYY4+sI8qrcHFLzE4m5MFF4YrBosKJH44GPqeWeMl+i/jUFXs0iJwhCt2rInISdfbEeP6R/Ca1oNZXYUh0eIEZU+IJIKfqgoREFy7CO5WY5RossUhERjJRgEAIUMWR3CTRF7eZmogGf2ieDl5q4hufHsGYUjm9JBuF0nQ/JS020bN2e1fuM6HLhiDpyzI1ZwtcaX5e4GZinneeaZ39nZz4vl7Zoxs2mR9WJq9JBStUs9UuOoQvjTz0JdsDta6W1wdxJChw46WNHnN2jFfgkHG6mUXiXneJ4fb1zeTseNZ3NDHEtNwI010zoPy8zX2humWaJhQqsHiF3YX9xE9AbFMIMhkVK1+SFORReQfikoff+2zLBop8kEpY8sO4msxOyKHZXnIWoc4cUMKbpWuu+s02rsMg9vWnpEgSGAoKo0dyLF/d36+cgm53DF8BA+et+M0uzP/QUiSLBbUqO7043hM8qnr+I23cOysK1jifxq/F/PXINSJhngml7shlIsT+V2eEDvz7d0GMOu8+jSTA02Arto0yb+pMZywrbkSKYU7XmqNRgsu6act2sQxB7f4sw/7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix comments so that they refer to slots_lock instead of slots_locks
(remove trailing s).

Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h | 2 +-
 virt/kvm/kvm_main.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4c5e0a898652..5c25b03d3d50 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -860,7 +860,7 @@ struct kvm {
 	struct notifier_block pm_notifier;
 #endif
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
-	/* Protected by slots_locks (for writes) and RCU (for reads) */
+	/* Protected by slots_lock (for writes) and RCU (for reads) */
 	struct xarray mem_attr_array;
 #endif
 	char stats_id[KVM_STATS_NAME_SIZE];
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 25a94eed75fd..aa86dfd757db 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -331,7 +331,7 @@ void kvm_flush_remote_tlbs_memslot(struct kvm *kvm,
 	 * All current use cases for flushing the TLBs for a specific memslot
 	 * are related to dirty logging, and many do the TLB flush out of
 	 * mmu_lock. The interaction between the various operations on memslot
-	 * must be serialized by slots_locks to ensure the TLB flush from one
+	 * must be serialized by slots_lock to ensure the TLB flush from one
 	 * operation is observed by any other operation on the same memslot.
 	 */
 	lockdep_assert_held(&kvm->slots_lock);
-- 
2.50.1.470.g6ba607880d-goog


