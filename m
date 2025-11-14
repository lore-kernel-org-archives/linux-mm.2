Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF632CE7B1E
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:06:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 409978E0026; Fri, 14 Nov 2025 10:06:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E0FA8E0002; Fri, 14 Nov 2025 10:06:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F6BF8E0026; Fri, 14 Nov 2025 10:06:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1E25C8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:06:24 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DEECE1603E3
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:06:23 +0000 (UTC)
X-FDA: 84109538646.02.8AC5C4F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2467A40024
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:06:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QnML+RWU;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763132782; a=rsa-sha256;
	cv=none;
	b=UDsvL9Xzj8K61Uvj584/J4KeufbnS3bKbxpKFN2P8GLiho8jZe7PcaEbNuDifDXF94LYXy
	FYB+ljpipwz225/FZyD2o7fIOey5JY/F7engvPAA5DA2+gYpk+7RuMP6beUpMhNfXYHNkj
	Abz4nvoLFZcmETMntgwTxtYmutGZsk8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QnML+RWU;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763132782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FsW1nZftMuTt/QMj2LpkXoZxukhojZ+9zXL0gHIBS/o=;
	b=JEkBho/qcvqzdgDIIWeDy5eT4CBOYV8VYTNoKlNmyS1f1v3K3EzJ2mRAaBLyjVqho969y6
	SsXSMDxLDJoFTGEwnLPAdoNsqB40j4a5npKV5koQAyUU8jme+oehmrPkX8JKytfGvAclFT
	reNBeVTa8nVLIvh8TBWpMTh555miYJo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763132781;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FsW1nZftMuTt/QMj2LpkXoZxukhojZ+9zXL0gHIBS/o=;
	b=QnML+RWUiG1ADcFwldZuy1mKqSxGpERm9ccFCZtJ+C1HbH8SkFp7xrWjLYWVATI4DHj8QH
	Kkay6OoCssETcjTxkZ9ln5b7R2RUBjiycDk5rZpoE4onPgSznH6czgMfoZwi+TADMW9xm+
	WbDBxVA7yipwrOi1LQHutS3minyL6HY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-397-mKrJmDmGOguRh1Y052DobQ-1; Fri,
 14 Nov 2025 10:06:19 -0500
X-MC-Unique: mKrJmDmGOguRh1Y052DobQ-1
X-Mimecast-MFC-AGG-ID: mKrJmDmGOguRh1Y052DobQ_1763132772
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 82E521800372;
	Fri, 14 Nov 2025 15:06:12 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.226.10])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 07E3B19560B9;
	Fri, 14 Nov 2025 15:05:58 +0000 (UTC)
From: Valentin Schneider <vschneid@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	rcu@vger.kernel.org,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	linux-arch@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Jason Baron <jbaron@akamai.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mel Gorman <mgorman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Han Shen <shenhan@google.com>,
	Rik van Riel <riel@surriel.com>,
	Jann Horn <jannh@google.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Clark Williams <williams@redhat.com>,
	Yair Podemsky <ypodemsk@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel Wagner <dwagner@suse.de>,
	Petr Tesarik <ptesarik@suse.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>
Subject: [PATCH v7 16/31] KVM: VMX: Mark __kvm_is_using_evmcs static key as __ro_after_init
Date: Fri, 14 Nov 2025 16:01:18 +0100
Message-ID: <20251114150133.1056710-17-vschneid@redhat.com>
In-Reply-To: <20251114150133.1056710-1-vschneid@redhat.com>
References: <20251114150133.1056710-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2467A40024
X-Stat-Signature: 919du8915raiqk9b6q7ckkj57kash1jt
X-HE-Tag: 1763132781-504588
X-HE-Meta: U2FsdGVkX18xCPDi6RVFl3Watg91ViNsGAhDzfU2ToEjhGSwSKqmdAqgL6JUO6Dvu+lPIQtNbVDNKkJnlPTP7wGMOe9KO/VwE0+SdBY8M92N7DDwHmHFSutfLRCn+nxZIno2ZanlOIOkzJTnl+3878PrNw/ietD5NLwbYFIwGy9V1V3cINOl3g0uSJwqypUKRDNa1hOJm1fHpm4uB6VeOK4Iyt48fhU6AFwDQgSYrOwIajBKBKfzvnay+mpnYITWec40YWkX8c3u+x7Huhp3cAIOqYt8Z4GbBWM7n+uKZmRRqNk5aSk7AHECEIhSKxgnvDtBQSbJqXwum5Y8zGwMmFdOhs0dq9DS6PAiovJcYopf7x/yz6EgtoiM0vV5tCts+oR4uT5Ca5yixIclJWBSAzj0iUuM9KxK5bHAvu/WJLnU9srO7YU23PwD0f9JWvNt2q0MnzhvN3+KHRSfKIITfda2ekyanlE7R3A0jMzRdCMA8xk4hNGKE4lPOFUPQptq1Uo4UN/CoqfLgjShfPJuBk2qrL71NR4ADpqIjyie9tPl7Foz0ocixxP511E7dxzbXJhdfaE8esw1HKUoku5iFMTpdgy6X+GuxSvKIdwD2filc9wXOfm0U6q5Xhx9YHxpX8+oKfK4miawHzU/SBG7zpD2NxjOpyWoBODR9f3r3odNnbZWpYiqBJwUbT+zCf2DXz531Idmt/LnhiXCsKXWeACMR5ni8xKTXijmnvJD4CFekkw8p/z6Xve5ZkbW9XiJe7akIF1JHFsZlD8mWiimcwu+M+qVUs54/Bfi/H0MWtPZV6euAS5Yv55XTtFlqssX5l/I+pg+tbn/+o0Fl6Kso18el1t5gf/KQ7Xnlx5Giarp4VYTDr6ZGTEjgPR+906MQ8uw1lV4sIwMyx+XPXBMNgevWnkM4/RHlokUrkBHXQDDZqilzxGv9dvolqFpaorE4cWcd0LY/Uh0fVPXFdC
 oCe4b1iV
 gCrQhiEXdfu1lqNgDZ1dl5dpMzOnrhm40uuf2+NY3ZrNc2eMhjnSw9tLEtKTV2pTX8LA2BXTO1RQ/r1ZWJzpu/7kbKZHrb2MXwQHp0kHe+yhT5NNRmaXhY7A4rVN0jOf6WO7K1Ts86pAQyosbTWLZ24aJcGTrYHaKfCOxZEyyUvjvWalqPxT5RYRhEQho+6gBtCh98Ra2q2ua370vEqVlT3GizRFqip8bagZIrWzEtbIQ6wewrqf92KiQ7YigLEGoYsNa36pJmo5WO4PA+BN7HVat+IVz6cwiTVbqWAhfQ/R4BGsPh8TRRLLtdKqH2b1yVqsRetFDpUcjQsf/LLYewjcjf8fbvOGRzk6gBET3YKv8/NMyftbT+mliB7SInPCIwbmPkDXgq+3bib+dgiQoaNtUrZLRdx8bywAUJz1SsB4Q8Q9l0SH8byYPDGfNpZ/cC6OB01U8pPmoYj+vznHLv6r5UYJdAh0WH9k8rGqqZIp9TAyTV24NMMaDcA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The static key is only ever enabled in

  __init hv_init_evmcs()

so mark it appropriately as __ro_after_init.

Reported-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Valentin Schneider <vschneid@redhat.com>
Acked-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx_onhyperv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx_onhyperv.c b/arch/x86/kvm/vmx/vmx_onhyperv.c
index b9a8b91166d02..ff3d80c9565bb 100644
--- a/arch/x86/kvm/vmx/vmx_onhyperv.c
+++ b/arch/x86/kvm/vmx/vmx_onhyperv.c
@@ -3,7 +3,7 @@
 #include "capabilities.h"
 #include "vmx_onhyperv.h"
 
-DEFINE_STATIC_KEY_FALSE(__kvm_is_using_evmcs);
+DEFINE_STATIC_KEY_FALSE_RO(__kvm_is_using_evmcs);
 
 /*
  * KVM on Hyper-V always uses the latest known eVMCSv1 revision, the assumption
-- 
2.51.0


