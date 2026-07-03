Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECC6CC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 12:32:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C528B6B00C5; Fri,  3 Jul 2026 08:32:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8D2C6B00C6; Fri,  3 Jul 2026 08:32:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7C886B00C7; Fri,  3 Jul 2026 08:32:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7C6F86B00C5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:32:34 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EE219C28D1
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:32:33 +0000 (UTC)
X-FDA: 84947403786.30.5542B75
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5258820002
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:32:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="m7/40kfX";
	spf=pass (imf13.hostedemail.com: domain of 33qtHaggKCK0WNPXZNaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=33qtHaggKCK0WNPXZNaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783081952;
	b=ChuldLhYeLTrr46QVyAs7auNs/bOQogYooqYIo5wGVbOxPqp33m2Xd4MHli85dsEfj2zth
	e682CgbbrYO/iQlE2iQQvnsRSZyThOaybSL74NZP8vDreX7KLN5hmi7UrbIXGejlIP2kHu
	G0jJnjBxC55RoZ8fuh9ZHYm8AcsdP1U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783081952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=84+Rn6wYUXeYiLyW3+xzYg/p7pJRku5hcVgAFmLjUag=;
	b=AWnrw11JmXh5hoRWMkTacwjN0/6oE9Dis9cSTKs3yRMW0CMv0sfMDzb6B4O09s9QzSymQg
	R5qMINh6rDqJaMjEYhDb/iMywrrggccPmDt0ENOJdEg9aJJicy/n9A2vnoTO/HPtYiqShI
	mlVOLlmhnfeWETBhuHnYsWY4wbgJ2+8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="m7/40kfX";
	spf=pass (imf13.hostedemail.com: domain of 33qtHaggKCK0WNPXZNaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=33qtHaggKCK0WNPXZNaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-490a767b782so4249335e9.2
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 05:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783081951; x=1783686751; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=84+Rn6wYUXeYiLyW3+xzYg/p7pJRku5hcVgAFmLjUag=;
        b=m7/40kfXqQeIcpWIihi0cwXCQzCUGhXu5AD7YIZuqhuBHPFPvkjT8fLdM7mqPjg42j
         MIREQ04MDdKtMskP4hgtZ1R/zHcmaJkTuPj/pOVsUQDE+TjamLjjwiAHXmntfNqrxfFB
         UPb6UTxfY+3p1s4Plehl/k0gFOzWGj48BL/5BSGBwDjqHHQZXJICBRzlhBPOcusG/qq0
         9SBZP3+L7g18l19WibwNHMKcX4sKVqw9rOD7bJ2KolIcNEph/zBGsAnjS2SikpWzIl+L
         4QTRZZVLABRWFeBtRcrjBOrHoPnooUBdWt/sD90g0w5a2b2UzYkpJ2qzTB9P6qvILmf4
         IcHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783081951; x=1783686751;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=84+Rn6wYUXeYiLyW3+xzYg/p7pJRku5hcVgAFmLjUag=;
        b=ZkR6IvmmwuqYoozarOHbgNCTPubv2q/9Svq19qX0/H61Az4gywHY8v/Muzer0gP1uB
         rLvTpjfs1r169VNzsXBNJyGD80JEqPGAG9okY3GSuJ0kv9eqG6KoE2WoSVc916U69oGT
         gTJV70YzYT/vwAo9/OorRIpoehXX6i43YT8GtKZjUcQbcv2jprXo16bVpS0cN7fM49wo
         bg/Xnxe3sM8JbtRiN4uC85kFGepp41DVL9njdZehP8SwnQFcFXX48GaniGETGUazelWZ
         sP4+hinYla84+Xd8eMvU81bu+XUCi+rrNRJ72sGRbuuiEAwJDHOmjGJYuuIkPr1MM8Bv
         qqEg==
X-Forwarded-Encrypted: i=1; AFNElJ8tPtSfJUT4eIExmdG3UHolQY6N4YxaT3YgJR+4J23HvjPwUGjYUkxUG801ewi4mSzZ8hOmCwj+WQ==@kvack.org
X-Gm-Message-State: AOJu0YzBgwgxLzclFxfcSAmUoMMsOTaU+8GoTVbeufF+p5rngayCtmaX
	nr3dw3Zzte8bQQFyE5SiTDvb2v7attzKYXHyZKOPOE/cGDApVAh1GKAKK8b96el0spb2pssaCTJ
	ar/JmOh11D3KtWA==
X-Received: from wmdp17.prod.google.com ([2002:a05:600c:5d1:b0:490:b2b0:c4aa])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1991:b0:493:bba7:e9f4 with SMTP id 5b1f17b1804b1-493c3cf2d58mr138687005e9.18.1783081950438;
 Fri, 03 Jul 2026 05:32:30 -0700 (PDT)
Date: Fri, 03 Jul 2026 12:31:49 +0000
In-Reply-To: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
Mime-Version: 1.0
References: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260703-alloc-trylock-v5-9-c87b714e19d3@google.com>
Subject: [PATCH v5 09/18] KVM: VMX: Use higher-level allocator API
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	derkling@google.com, reijiw@google.com, Brendan Jackman <jackmanb@google.com>, 
	Yosry Ahmed <yosry@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5258820002
X-Stat-Signature: fgzeketfwy5n78rjmbjptceu8bqx4htz
X-Rspam-User: 
X-HE-Tag: 1783081952-665164
X-HE-Meta: U2FsdGVkX1/hPNmFK1rI62jQLQ/fZWBJBbF7yc6fDSRCY4ob9Qy8tdXKiFiLCDRTXpK/D/Cl0mc2ScB/CEla8fthGutmDJexMpxn4f3I6uSg5vrZvOwtrDM0lpE9nqOXkpoAMR9/lxghzup2687cm0i8X7hjQd+ZOfb8tPmg8eLlnn9I+NySg7SZ279Zzv4oZL1O19j+hS9yr71v1rc4rykTG7g+MxFNJ4DhVpNaASISg0twdp9lo+Ffao+irowWkIaIxFOi86byVZN9vBAJ/27p1OqxyTs7J2XZZEMH1VMLbDOTGsnTOcdfXOb4wvtO2eZXFOdCLhnrb7HcA/wAQQzrQ1usoEuM2QIeUNCkV8vnA6f6uyqfnEZhoVsIcveDJKxTqYb0yEqeim7I6wdRRUOKb8R+yE3QpKPQsXC9pLC0+HWPJ80loO4Njh2qFMdex2xPKQX0h4o8qnDD1mp0AwEFlZ8Y+RoJOkidz2Idxme5USNq5lIhnDRw+9xrl6moSoHnqywooDWsq7Pg74dRsaIP0h7Wv5LKI8meh9PFBjaNX0NqObL5O8h0fnnNDhyE0gC0ZBLQJEbx/9VCc4ttqLgwvZ4aB5SkErrswiDWrE3ALHSZR0eY2DI9U0jG7ZPNQRqdVhT5rtsvKCGDfiuzMkOi2UB0rH+h1tUit6bft+7/ig/9hEi2kMgvyQ7uAf27kZIy0tWW1kHWh20XixMSE0gdQRq5e0JA79moELRbb0EXaMyUoTEi2Ml8nFHemHm2YiZviCTY2ZiONyCbIO8U9RaenjzKAYhvrlsAAfL9r+IQVAXzGqOo1mAT82kC4drU9qj4OO+ortHM9IHn3JtWuTZV1qPxZRnnES5rmCaZEYZX6iB/8xVwvJIwOQ0oPOAKdQjT7u7Q50LQ0Ai6lPbLIDoYg12udSRyxOIfD1+BUdjw97sZlGEUliw7Il3+oHd9lI8kbnaEQ/aIF0ZDRaS
 +fjftxjr
 nW+wcLVKQAP6hKRI04AEorsjRgLT/tgH7TEyXtipkaNuW7bsjfwd8n0QYg/W9JbMMI1shBwVDAEctIhULTC3ODAgIHLJLqP6eFjr969D1gYCzp2Na9X5S3nL7UM+ZHOArZ0PkTjNMbysuJTwDJxy22vJzmLC43YT1PxcktnsyzxYzKYcSrDD5av7qEsAVPaP5aJxk7T06TIwfWxfWNCwS8c7yGpACdUcu6zSy0D6PtAZs5fk2uQfuQxmOSwHZH/6jzEEkuVDnHsn4Vdm14qE9U4mx5szghBgerEjrf8oose1fM9qOgBvruRpgfzKthTLt5lumb1WZxnnyiAdI8tpMhcuIDwcKfGJdhM5KWt4z7K7a0XpN+h6M87pt6oIgLkgdmElcqU4VLhTQaLNTisZ68TjcljtfKKK7zcQEl2OvJPp2Gppd5JJ0H17AOnlOYUjt0ZYzOSqmUiNfN8qr5rnzzkDQkFQRXOT2036UOQ/ny2xPpjoucp1GA0fmbVcxMJRfe/Z4LVU1yB0aVqGC20r1f6MBQegeqzgp7ecw0QBq6AsEdKEZb2EJw80jXtj7qHaPZWEJm5aO9Me2vq+87wz/AmVMxFAx4Vp5loWA9jz0l8lzxEZFqvej5uBrDIV3lq8D6VITrTjl9iZ1V1rbNYdvzK6JP6V2hCKQD8BGKf7tQj+DlzTkYwFC5Qn8Sg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The difference between __alloc_pages_node() and alloc_pages_node() is
that the latter allows you to pass NUMA_NO_NODE.

The former is going away and the latter works fine here so switch over.

No functional change intended.

Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Assisted-by: Gemini:unknown-version
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2325be57d3d75..ad6a7fc6a54da 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3028,7 +3028,7 @@ struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags)
 	struct page *pages;
 	struct vmcs *vmcs;
 
-	pages = __alloc_pages_node(node, flags, 0);
+	pages = alloc_pages_node(node, flags, 0);
 	if (!pages)
 		return NULL;
 	vmcs = page_address(pages);

-- 
2.54.0


