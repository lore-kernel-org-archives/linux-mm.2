Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6803CCD1A4
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 20:12:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26A5E8E0012; Fri, 17 Oct 2025 16:12:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C6A88E0006; Fri, 17 Oct 2025 16:12:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08E688E0012; Fri, 17 Oct 2025 16:12:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E7EB28E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:12:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B90DC11980F
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:12:36 +0000 (UTC)
X-FDA: 84008703912.20.F3A09B8
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf09.hostedemail.com (Postfix) with ESMTP id DF9AB140012
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:12:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PR7Xqe5W;
	spf=pass (imf09.hostedemail.com: domain of 3MaPyaAsKCJAuw4yB5yID7008805y.w86527EH-664Fuw4.8B0@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3MaPyaAsKCJAuw4yB5yID7008805y.w86527EH-664Fuw4.8B0@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760731954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZEij1CupCDGyNPjfKEYxhnSr/WYW50lo3K/U1CWabEc=;
	b=iVKBtf/1AsyEXNmZI5S6oVNJwFgyhibAeVtxo5YGIUYDG4HKtJ1g935ceQmGPkTE4UG/wp
	AqLtq0Wkewd/sN/BZ87FXdiGB3SSz/GR0Tpm3+z2feKNUSMua7pjU8k5xIlY225+j3mzsh
	j6mC8+Alq+ZyKtVFnQjEMEfmyK6IDkE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PR7Xqe5W;
	spf=pass (imf09.hostedemail.com: domain of 3MaPyaAsKCJAuw4yB5yID7008805y.w86527EH-664Fuw4.8B0@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3MaPyaAsKCJAuw4yB5yID7008805y.w86527EH-664Fuw4.8B0@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760731954; a=rsa-sha256;
	cv=none;
	b=OaY63xaV4a1zx++fuhk5JgiRXCuGcg6ShAEwn8pwCNudq38Rc/clfyJqXACxWir8AcqCKd
	mFOiyDbuPgLYmWhKA/xynalr5xuPL4pKDHmvVUMPCBv7d7sfp/0qTPoTPaVISxDCWbNB8R
	CVeWOR6JiGf3ZxYz+QRq+YY3KSdsEgE=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-336b9f3b5b0so2523328a91.3
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760731954; x=1761336754; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZEij1CupCDGyNPjfKEYxhnSr/WYW50lo3K/U1CWabEc=;
        b=PR7Xqe5W4g3Dx1gUruurLeIa8dIfVHFi9VysFnZLk9aO9Jm6+GczOGTeM6EolHaHPK
         CyXlA4TOemRHIuf2O51+qcBTnRA8QtBua7+gp83F59ox4BEFaXITkOQc9nubDdYUmHow
         bIljjcL/HmuBwkR8AgZ9Z4Fz0ASe/En850i1DlSzqvKcr3U+8l3Xj8ZoV74cESo3/p97
         E6yVSHAQwbrfAbsPhCrhvRfS9cQTBibAAtvd8KA/1KouleL1X/iiYl0PjteL2AIzsNBT
         9ki1xGOy4PsqFvTnJEzB1FpJA+GSPCh5b+iHYMdnpSGSW6Cf9GCJv1UY3Lm0cNOIHgxw
         AtMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760731954; x=1761336754;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZEij1CupCDGyNPjfKEYxhnSr/WYW50lo3K/U1CWabEc=;
        b=st89sV17P8VDPrc9igvm9Qs6wNC2x3klxwOZOYN48R+nI+xEl/ivej23DB/k9IaBad
         vAlkblLSgWpIy8JFLld30iKvu/evZt7hqujUpoLceu16CLIX6ZA2oByQos+l3LLJwK9F
         iTpjPnoFuy/UxP4yrIXehhgSRWwynzxMHmEgVhsV9pwZiOboHQwHhnANCuPqJBRUXx+K
         EOhyNaKs1barGYe/ngmqgKxHSXmHtxMMB7mFzYwQEkEH/tx3F3H2z8GhrmlNwI5KyyH7
         4dI3Pz/fjt9VDxzq689zfxgAQL/dQ6kwN2sKiXM0b2rl6vQ174wEFbdH/8NiMnSz7n0A
         8H/Q==
X-Forwarded-Encrypted: i=1; AJvYcCU7HTOHQ6pbZ7nWlM/40ZZzqNr2hfzAEImPcOR2Ho+RC0UW4kC3PFvy9P/ayuMwJa9C3GOUDP4uHA==@kvack.org
X-Gm-Message-State: AOJu0YyFIckmRclWGfJ56kt0pW3ymX5yGx8kkdG7HcC58w7/gfuE9Ub1
	Ma24UbKRamhhJHqK6LaDjMeronhlqCU7i9GrRuMISJzkRThKi/DBJPib5sSS4Ge+NAAfH20xelG
	C5mhqMvrRPJx1KD0iULIFg1UAlw==
X-Google-Smtp-Source: AGHT+IGB3FEZBVXofYnV/2OlFnNwgrJDt0eUkK+vRXpIJeJOVHDG0MgXbSCylMyEgGvaFtRNgbmZV92cuc0fSiwxCA==
X-Received: from pjvp17.prod.google.com ([2002:a17:90a:df91:b0:329:7261:93b6])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5623:b0:33b:d371:1131 with SMTP id 98e67ed59e1d1-33bd3711391mr5701672a91.34.1760731953647;
 Fri, 17 Oct 2025 13:12:33 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:11:44 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <405686bacd68ce6c76aa5e6ef40f0a5324983c5b.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 03/37] KVM: Enumerate support for PRIVATE memory iff
 kvm_arch_has_private_mem is defined
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DF9AB140012
X-Stat-Signature: 36dxdajdksdk45a5onzszfop7op6fqnf
X-Rspam-User: 
X-HE-Tag: 1760731954-768265
X-HE-Meta: U2FsdGVkX19b3ZJvccDhYx2tHL8aXicRJM3bmeADNMOtjT5nSXR4wOPcKw8ZIG3653ZYq6sN5sLUK6B9cg+etMPZTxiZq1X5NwhfHe/TTe9lSjBRwNPyUNVUO1H/S9uinOyoWx+w6Uwp6yyabCrOVwvKXTJgxjvxC1gpfdKvGRr+BM9KclLVLcfk0/HofMq8KyRi3XxEsxrPSbhtTYgzp3OaTlQv+YIU5w5gnjctLW0yQM8ZaXoWQfJgy3dJfkGP4JkXFl2+UqCw3W0vhdq8KExR4Gaz/XzAAm0hrCeRYKCFzcsj5TKBJnwK5dlWE9NDV5CxRW0PndzjS+3A/Xi59MK96VWFjSPsWi1tqRpdgZ0WiCRoG9MOV+6PbbhvIKG7SmxcXgs5iDy3Q4FmZu17+3FpcCjXEG68Z3FvJm1HTHMuF13iiihnPFQl9fsZefUJozUR0QSz3Kn544u6mGBs7uPiRKLi/JqrjcIWtQR/45Rws3/K/KhyK1dJ1r7/yPIz8iVB1imHsTgmXH4B7Pd8/S2PmpAxNQYhKmwQZPiZsg9XK5WiTtaiI1EMG2qenNonMcOfWRpS6cPgNmuXSmH5TtIAhE6ta//z25Nll1pV3zIjt4QR6LZbu1+fyZLhCYB0N2JJKwi1Y7Yy4Hq6Oux+ouEbvpCgkBveWta2Z/hop/uS5fdohNyxBPB8FzNQm/KKK7nfttptC1voiAZINDG6lhKB8zmGrGYXktq/JmEQ9Z+jtS8k+iAXDtzaceHGARoXtk7Giuivrh6fo4/x8W2I5R4vQEAnbKgFH28l0JuQfC5L+3PXQswhqwxYOCuL22Kyskbw1VlyCeueYZ79jwF/U5jhDnj4mCdi1egrpJacuT/CuG3mPFVtzJyXpkqXxosezrY0fgublAuOyERGWRb1x/AN2U0YueiLmpCqZDFILydHIpjQwd2jGQzQDRinXNTiB2Oh7lzgAdpymoggcT9
 dbE8/v61
 kC7uTbwhiO59uZtAV6Pbwjd9R0qnB0RrknkJWMPnp/9QUTRznT5ODyEsm/38km8NXZkpvRw5F7b4v/5Uyzc45kBUw0L4GAuiC+g1E/81VwWr3hC09U1ozXbJtWij3SD3BqVVmgUW4pZUoiLTzM9IO5xyzeMBET3Za3RGqXO3e14KFTHsHmv23fmIv5GMjIVgx5AgRep8t10vBKSb72H+yi/1zkoqsLETypeTjRslj7bRKkCS4QCOw6rqKXsghZpduTRRbMoIXhzc5ILv1g+pG4SDZfyNQZJTTGLn5CmeCkF/JGwmvlNAonqI5jW99wsd3SC5IJLqPIFV+l24dx8N5nvZTeyY4xws8SgmpmIldA2BF9a0CxUTHo1edFbx4ZYUGW6K5580dDjqzz0ocHyC9WfNukwyhis1RwCol+g24f0BfuQ0ycrO9xY+Qg8TwuaoFKGxAgP4HLKDjb2CBwzdB4U/+PQ4HfRbMOvqDLHn+IZ7oKdMUNyPyy841hUhee+KKwxVMNlZwNwhJF4Gth4ymZlGGNxhqCtPs8I40sIqDBQfxhRG21p8qduUEwJ4v3kLboSyR20wanRRFV2E/nh9KW76T6oKzODAG04v7jFRHKHvruFadmr3ASIcah++Hp1a7o8WaDNB82fbdQcZ7kFLnxrlUzYYY9NRMreg5FjFROKI6+ZIvjulS1TKiY/GRlZKssDO8ecwS0qyVCnocxA8t1LvZeq9Mu7R7+rL0rhf007eD/VE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Explicitly guard reporting support for KVM_MEMORY_ATTRIBUTE_PRIVATE based
on kvm_arch_has_private_mem being #defined in anticipation of decoupling
kvm_supported_mem_attributes() from CONFIG_KVM_VM_MEMORY_ATTRIBUTES.
guest_memfd support for memory attributes will be unconditional to avoid
yet more macros (all architectures that support guest_memfd are expect to
user per-gmem attributes at some point), at which point enumerating support
KVM_MEMORY_ATTRIBUTE_PRIVATE based solely on memory attributes being
supported _somewhere_ would result in KVM over-reporting support on arm64.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h | 2 +-
 virt/kvm/kvm_main.c      | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index fddb373fcbaaf..21bf30e8d3cc1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -721,7 +721,7 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
 }
 #endif
 
-#ifndef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+#ifndef kvm_arch_has_private_mem
 static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
 {
 	return false;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f73047ea4333e..591795a3fa124 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2428,8 +2428,10 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 static u64 kvm_supported_mem_attributes(struct kvm *kvm)
 {
+#ifdef kvm_arch_has_private_mem
 	if (!kvm || kvm_arch_has_private_mem(kvm))
 		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
+#endif
 
 	return 0;
 }
-- 
2.51.0.858.gf9c4a03a3a-goog


