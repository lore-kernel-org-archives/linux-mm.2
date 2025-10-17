Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7B7DCCD1A4
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 20:12:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE7518E003A; Fri, 17 Oct 2025 16:12:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E71818E0006; Fri, 17 Oct 2025 16:12:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEABC8E003A; Fri, 17 Oct 2025 16:12:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B5A008E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:12:48 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 888711A02F4
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:12:48 +0000 (UTC)
X-FDA: 84008704416.30.0284172
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf11.hostedemail.com (Postfix) with ESMTP id B55FA40004
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:12:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ebajnXVu;
	spf=pass (imf11.hostedemail.com: domain of 3PaPyaAsKCJw68GANHAUPJCCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3PaPyaAsKCJw68GANHAUPJCCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760731966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kctxz4bkwPEMxjAo5uv7zMkhZ7DomPYpJw8TjHTwuwc=;
	b=EoZQXrmyB1SYmDSrasZKZp8RuPP79+E2USrKgpugYs8X+whw9WH3FolEmkIXs2VQlau+oP
	qXeIFy69u9ZKaVYUWVcBVzgoJ7pqMfLftnRJtlylsLW6wyWYimYVHxwHfHlvElUlElaW5t
	f8jfXE6GGKJwEaBjj5un39RpbcQ71Jc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ebajnXVu;
	spf=pass (imf11.hostedemail.com: domain of 3PaPyaAsKCJw68GANHAUPJCCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3PaPyaAsKCJw68GANHAUPJCCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760731966; a=rsa-sha256;
	cv=none;
	b=H/c97untnhq5C2BelrbCoCE5alVXy1sZyMQx5ztgPno7k3EV/X25ZkAo4sCvsZO2gPAINm
	G7c/luWXRdXeM/d4R20afS25a+vAe6yVvOTs7IWOlvFjWluRwaqwNCb6TlcyXfcM+mH1Wd
	KdhgAZCxZECGa9QtqQCkC3k538rx0z8=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b62f9247dd1so1908495a12.0
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760731965; x=1761336765; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kctxz4bkwPEMxjAo5uv7zMkhZ7DomPYpJw8TjHTwuwc=;
        b=ebajnXVu37zA8TPK+gm9n8/L4Md+GshnHl8cDI3pqCohWHyHtKAlk6U+EoJ9dAjkqe
         FRc7OdkGbMc8qkvh9MtQhm0Su+etaiU33W0uW+HThXSH3pSUoFVSRmjB8ThyOX2I2bmJ
         E+Po1letcgpbyfFutVxaRN8js+fKBx0OvKKjKoIVKYOR1nuWHanHF6Zhc/9fMjp//MLs
         xfS1gR+E4WK3RBja26UxxNzlvInSk9iM6zpBA0HnNlea03D3HDrTCvD9Gmj1MkTNihQ2
         8KL7HRVgK9ifHI1X/fiTl36m4yTqoNKLDBnxJwmgvxHSYBmDZYUmR6zntQ4NRr3JK6wj
         7NKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760731965; x=1761336765;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kctxz4bkwPEMxjAo5uv7zMkhZ7DomPYpJw8TjHTwuwc=;
        b=QpMuosUFWbXVkY58hLi8DNmMB2LoFmN8XTtZHsVFViUsLLyeL4uHvpqc4R6wyF3l+C
         UK3YzthyEvSRknk8J9iJZ1nB0TYNm7zl7HN2vizTp97+Cz2L65Xe03kRsN3q5iJymCqH
         vsf9NL2hgHVcc4up3kHSxgOGhBsUSVSD2eebG13JLbh5nBl/daHKX3LzfDLAaa4kg/SF
         BnDPyGbP1rSZlMQ7I1AIEZF6MkKaShvP0g12B594ej607XTNsZrCEWlVyxIY/uXbUmJv
         rcjlwhL0PoUIrLCvXbVvF24GAESzHRXMdJogBbxRDKjM0NFHUPuTALTlzU7FqmhQG1Ka
         573w==
X-Forwarded-Encrypted: i=1; AJvYcCVH5u7BreRo3zoiOaNX/r7KwcXZJY+BNRuolEvtkjmhlOseWTlLM1rMFCxN8330z36KmKlqjNMxVw==@kvack.org
X-Gm-Message-State: AOJu0Yx349QYKg90pb64JT7r3NdE+PERjwxydhcPN7IQUXWGFmPBd27A
	Y6jGRIVtvbuy6woAFgPx9Eh4wbPCZtuV/FypTMaOKz38BUcEtd2VubFGRw1Yn+7gjsGFnVGwusC
	iB7y9yRs2xGFd+UCNDRDw5kWxKw==
X-Google-Smtp-Source: AGHT+IFw3NgbtgTZNOENDz2gBk436xq9cSXbkfHKeXAn9g3NU8+yq1Zt0gAdx01FZUaxcKcWB1HdYR90j/8QeZ03Wg==
X-Received: from plar10.prod.google.com ([2002:a17:902:c7ca:b0:27e:4187:b4d3])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ce8d:b0:290:52aa:7291 with SMTP id d9443c01a7336-290cba41df2mr57184855ad.53.1760731965412;
 Fri, 17 Oct 2025 13:12:45 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:11:51 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <98bee9fff5dcd28a378d81f8b52a561bca8e7362.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 10/37] KVM: guest_memfd: Enable INIT_SHARED on
 guest_memfd for x86 Coco VMs
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B55FA40004
X-Stat-Signature: fpor6rmszs3ggqxgd7w1dbe7kx9cuijd
X-Rspam-User: 
X-HE-Tag: 1760731966-112032
X-HE-Meta: U2FsdGVkX188IwkBXmW0WHgJrExNaF7zPFEaPq9hHVSPUYfJ6o+01tqYNV9rAOJefdGYAUDKvxG8uIqPDQjH1u9pbhz3yahT9zv7VEMrNfCWH+23yvmvXMFbfzztOZ0mfwiT4SkfuKAYPGSLirEetvvSBT5P0cXdukjugTBwj7Tnngbx6U2w13E5kZVRNFIb7SZqpwdcv8U6NmK4mCBLXIiBIzmBoJtn23Yloz8DsdFCqx1dvPHSvmeGEZrB2SxaYD2rC4NZ8swFL1MI3uMESIy+HLdhoABxHXathwFVCZdgYyzcupqlQQbt4bmbTrGbrwSFxGPP+RPh9x6Hx2eiBQnKCvF69RSHvqXNyK+V/jxfFgM20puBaLT9A538lSuyoYDazIUk+H08R2x1Qkgfoj01PtOvK1zhOEFQ1jhhGHEPrIETzhZkNye2hlxNMcybIEuHAswnw9s7EJoaogIHGjKkpHowMT45ERwJ/d9lZ26nJv63zoOlanMxuxNmdgGBzsuyc9Zi5hYng6EwN4YHYJyUDGrDveJhwkgUDKoMcBFG3pTITbsW5YJkQLAydom0Pr4X2lA4Kzudsceagz4iFvb5pUOp/+jf/arkWebZGDwpqDjZzQZbha8Jen16vop81QP0fYSS7vKwFhDc+kWoF5kRRyuPYSMsAwkvn9PxNM0mY0AnaoE69jVgdIqsrl28iq+f1kx7hq2A+p6lFpp7rPwG0ts+6j/wlvv9lKXVojzWVFCUMxQF2cyTkjqq+2UtKxpTZFWLj9UldZ86D4sQmyclNpCbNt1W6Cd3XL2YK7r2w9pkfQGvwZUC3LS5Hhg73eVxRiS//DdHz0fvXh86a4h1ZW++T3KKG/1tasnbYDmg7OzuCb7TcVP6zKUpARER3vCrURya4Ncof+wU8NLe1Vemhr7WXihSiePeCLc0pUGnB/aNZCOEKSL/xYcHhUpotca6A/EvNr6aNIT4cqs
 SOegdvTf
 Rs6Jird7y5e/vm5AcHnUHUQv4SPIE5557SyqriHhJpoYSlup8TLSBvtqKr2JEHxpHUlaOtxi5P/jsqOPgIc++jp7iFJHwT6wkNQ31wVr2AGarNYA0vPLXXaUDP/ziInH2LJKHB+hMz2XiXFBS7UFYTvAtdF5NenASqAWkQdc506wtd7FmGLo2mVvNthOxuxPL4e7k0jz1qjyJHsgtUoP4YGLXGfx72vnRWMNnSWGAdcjlEVvwnnMNYSFBxbkXbBO4QWNdW0cwn+c2hI+j3BqnXOvjzCO0dAhLH3EU+mEbrAcKfu8VRSqosh8XUx3qjvGT4mtN23UKs/aGjUh1g39NaB7Ec7k21iNqQDfu+ajYeIn4314vlPuIjGXMqX0jWNdSqNWRGZE4MFPh6NhSfsGgpamomSjwuJV5TFu68Pm/6cjuD6y0P/gKPUhLrnrGne83Nh+u7RNNHNu8OQQMqyeT4imRW+HKpgpMxcGNlXF+Pf0JTnBTFzO3ePY0thMFwXBkRAxQIM3HPKz7JJ0STJ9ZD6y83g/yplMhfNaSP6HhMmDBMgX/pljn4t1qEaeX27B76d/WWX7Sbnre+wFnLLAIb/G2R1JI0FDuwB9vdN1Up+khd0EtkzFzlc85+XvWohSE++FJuM6L1F2jAl7gcAqWdEyhvVpZITxPlmdTZHZkYLlohAViGjybu+82QB79UnApfS1i
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Now that guest_memfd supports tracking private vs. shared within gmem
itself, allow userspace to specify INIT_SHARED on a guest_memfd instance
for x86 Confidential Computing (CoCo) VMs, so long as per-VM attributes
are disabled, i.e. when it's actually possible for a guest_memfd instance
to contain shared memory.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5e38c4c9cf63c..4ad451982380e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13941,14 +13941,13 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 }
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
-/*
- * KVM doesn't yet support initializing guest_memfd memory as shared for VMs
- * with private memory (the private vs. shared tracking needs to be moved into
- * guest_memfd).
- */
 bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm)
 {
-	return !kvm_arch_has_private_mem(kvm);
+	/*
+	 * INIT_SHARED isn't supported if the memory attributes are per-VM,
+	 * in which case guest_memfd can _only_ be used for private memory.
+	 */
+	return !vm_memory_attributes || !kvm_arch_has_private_mem(kvm);
 }
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE
-- 
2.51.0.858.gf9c4a03a3a-goog


