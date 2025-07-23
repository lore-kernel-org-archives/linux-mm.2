Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02D61C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 10:47:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26AA28E000B; Wed, 23 Jul 2025 06:47:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 242968E0001; Wed, 23 Jul 2025 06:47:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 130EB8E000B; Wed, 23 Jul 2025 06:47:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F27948E0001
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:47:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C0551112F1A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:26 +0000 (UTC)
X-FDA: 83695202892.28.C135694
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf09.hostedemail.com (Postfix) with ESMTP id 20F97140006
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LuppfsfO;
	spf=pass (imf09.hostedemail.com: domain of 3u72AaAUKCIQ1ijjiowwotm.kwutqv25-uus3iks.wzo@flex--tabba.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3u72AaAUKCIQ1ijjiowwotm.kwutqv25-uus3iks.wzo@flex--tabba.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753267645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=++/QPN6SuFMfkHRmjrhS6+IMVKdQVW60svD12JCzsMw=;
	b=o6qHrS2Kn3tgt1PtX6AQ1QVsdTlwVhTqdcqhvOAH6IRK/4/LLVFkN09nbrMt3PbKu3HTTa
	Itq5u4IY4xGPG2GlZfeip3R0iurclGI6Mf5f+yRiuPRv2y0FDI32qndlHJxSpZ1tvaGl4g
	aXXERYGtotsZ2HCyjW/DJo27nuooxrs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LuppfsfO;
	spf=pass (imf09.hostedemail.com: domain of 3u72AaAUKCIQ1ijjiowwotm.kwutqv25-uus3iks.wzo@flex--tabba.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3u72AaAUKCIQ1ijjiowwotm.kwutqv25-uus3iks.wzo@flex--tabba.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753267645; a=rsa-sha256;
	cv=none;
	b=5qFYfrWFgJMWSOyjqflPmsSeou4aQg9mwgd0CJyp0HeOP4VnYsivF74DiiwJc47QGgwG5u
	wB8yJV7GPrmzFOm4T8ZquD1suZ+JJ03eybO5b9wPkN9nMFbFQZ4+i83Mb+jDqXr34Gma8Q
	cGuvgTKzriUrYc4rv4IhEEGCBVssGAI=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a54a8a0122so3759941f8f.2
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267644; x=1753872444; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=++/QPN6SuFMfkHRmjrhS6+IMVKdQVW60svD12JCzsMw=;
        b=LuppfsfOhaYBWfaeMwdiJ//+YJgbhLWXKNIneJmT1uNB7uN8B+2etytZcFpvfYZ4Ye
         3OoamLIJJKe9rRXA/4omRdanYA3a0XQ/CZ4N6vXXXm2SAuJmnvAbUTn12Jzp8WS9KzQ8
         KVhb6Oqd8M4yco/tUbFM21Bm93svqye2qaIbOPib6VxKkDWdSg9NnvHFQHYNFNikCLF+
         iXV3PAGjErUaMqqUpgqxzVrkDxA+N4yn6swWzE1Zbtm3tdjhUg593sjMObiW+pQycoxu
         B2hIlPu6CZyhPdpUQ90LmvPhxQkACu+DQlx/xZQwtv7udQQDW47SWd+OKpv09CLyOWY8
         SbFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267644; x=1753872444;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=++/QPN6SuFMfkHRmjrhS6+IMVKdQVW60svD12JCzsMw=;
        b=I6ZIHspq4M2ygIIYtlU7dIWZ8Yc8dnweqJdFdSR08QECuxiWb3fOJnuCEuDOQqRnl1
         b/T+zKtCog9hbVQjaYC0N+L4rhZ/vaO6wrLhRNPwNR66R0RKrLQ3dYUk02HwEo9nNhUk
         0jlBv+iINYVzIVYVAyaH9IryMEGy5/cU2ncPTbcnU3WNBCRr7N2KNj8Iwy8gJ5LFUgVq
         Z/DJn7qmWXFu9tcPvfOOtXGgL0yiTVHAwXI1CDGGADlJzf11N0725iBTkEHtN4zgo0ZG
         4cJnFyWXnqsN9kP9BX/Vo3mEWD209oT2UYNKevvGICFzfC2tDhTdztPJz8AryE/8zqED
         y2/g==
X-Forwarded-Encrypted: i=1; AJvYcCWDM3y0+ZakhmtWfWJdA9NeW0cBDJj6xCUthGPI8BSnLhb6tJuyGssWwyC4QvqooUHcfxBkBwlFug==@kvack.org
X-Gm-Message-State: AOJu0YzTHirOT4zFnBKpO/ap8Hfsn3drAuMHCiL/0kbR+oAesEmuehyk
	BZaU4pqTqyyUGEIItv3v6xm63m9WyhbOHOU/cq8pymAqagg+GziDt6mBY7HLH7Q8aWHxdftQVv+
	grA==
X-Google-Smtp-Source: AGHT+IGh1e+V8SmScKMa7B9rDGNrVFkyz19g/99WYS3fME9s9rYU5XZGuebCy3D5fzuVYuNyo6dDcGaEqw==
X-Received: from wrov11.prod.google.com ([2002:adf:edcb:0:b0:3a5:7883:6563])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:1449:b0:3a5:1c71:432a
 with SMTP id ffacd0b85a97d-3b768ee0916mr2198617f8f.14.1753267643374; Wed, 23
 Jul 2025 03:47:23 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:47:00 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-9-tabba@google.com>
Subject: [PATCH v16 08/22] KVM: Fix comment that refers to kvm uapi header path
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
X-Stat-Signature: eaic6upo598honpq35tg84qh1bczsk6g
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 20F97140006
X-Rspam-User: 
X-HE-Tag: 1753267644-137671
X-HE-Meta: U2FsdGVkX1/vp3ZGK0h4zy2dTYTd6sx/HsBcYTc944A9LlydLdXxFpoBnHga7UQRMLABcK4T91oQn+OKjCR7/M/2NiJE45qMiUexY0X978pc+LX3tsvqHYMhOtVtn1eYMBaViFv2hp+0qSKwcu6VEGOXhQkGNZzh9ElJ5zCPZ1Ab/CKTx/a9WFrsTUrTXStWrsNujhH72DZ+qzLWG1wub4l62qjzowWEMv4gwKuq88c/FhIFRIEjMAj96n5MDmk5vpwA8PGHV44M9ClWS39fhvOtB772szOF4ps9dO75dt+evjmYrzn4RBQrcJz8ZylBx9Aq1KSaZfavyLNb8xkNWMsJR86okFtyD5fEe2OdjADTxhOpYkrWV7Ua/ylQU4hilkJqJkrzLfAMX+Y7s6r6a/5wx57CdYmZgCVt27f2wSrCg6SDtzCWq9sUBY3kPHgXss2MxDnT8eian89Avyf6jZZ2ZufIjgt05Xtsh6+31Ze9G//19tZa/SQJn9dEU83SwhREP2LqqspiNv989xMJL9l5tkHVoP0ciro7i6DmbYhVAdOgldy0g+24Kn/30OEPx0x0Sol79lmOGSexpNYNS42TkeHQP89C8FLJcV9lY6TeRZ01RA8BPZLkdJ3+ssXekzmp7MeLR4WtIVTLMjeFe7dGisjTKD2EjgFsOklYG+T1GJzZDuSVotVqJFonxIhZXmuC+OjgArspS39OadUAVsRVPhtu6m5/T5oR+z1KaLVDkFCQVAndIKeuEKhr7M3x44XzPEP/SKuHIH1ZTwNPUZo2/mOppBTrjcCxb7Qsm3iZ0rs+N8h5uGesCm7plCcI8JeU1QwKD/CJW9kSnZjyMCf1bksoD47k6g+i17HgJFEs/TcIFexSBEugjnU7aIwUJkd7eWIQP/v32wcuoyIt9luO9VtFzsffZPoDm3s1tS4PRwj7KcOqBjxDrYFCy+QvwccHPh0D9jbdYTE88RF
 cDYKMfw8
 iRcJ81iBvjS+Ril4gojNErXaDCwCb3g0ayBjtBXL4cKEMxfQVEStsDBy9rQ68BD1Qo6cuNA2G3LQklJwhfsRhOdkJ6ZYBQjAutLs8JmHQ6ofm9O4BcFrCRENvLXhn5ekLmqG12ggzx/gh5b6O3aq8UTwdJ1WTOcem7Ams5Ni6f/PIqdVcRMJ+vXvHgRDy17Vq9pS6bKKjyEvlvPmbR0EoOp3CQjzAZNlU2mmHsEEKi81j74F84mhOjIDT8/5s9Hg0+YSCKc0+zan7itXMJUb7iDWtZ7FiZ0x/rJgcu2k1GC3BMC3Hxf11M2i3Pz3jU1+g0m5G
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The comment that points to the path where the user-visible memslot flags
are refers to an outdated path and has a typo.

Update the comment to refer to the correct path.

Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 5c25b03d3d50..56ea8c862cfd 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -52,7 +52,7 @@
 /*
  * The bit 16 ~ bit 31 of kvm_userspace_memory_region::flags are internally
  * used in kvm, other bits are visible for userspace which are defined in
- * include/linux/kvm_h.
+ * include/uapi/linux/kvm.h.
  */
 #define KVM_MEMSLOT_INVALID	(1UL << 16)
 
-- 
2.50.1.470.g6ba607880d-goog


