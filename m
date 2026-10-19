Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1483606A31D
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 21:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MLRw0p56
Received: by kanga.kvack.org (Postfix)
	id 3AE146B03A0; Mon, 19 Oct 2026 17:46:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35D936B03A2; Mon, 19 Oct 2026 17:46:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24C786B03A3; Mon, 19 Oct 2026 17:46:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E4CB06B03A0
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:46:51 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BB044A0866
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:46:50 +0000 (UTC)
X-FDA: 85340710980.30.842692D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2D176140005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:46:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MLRw0p56;
	spf=pass (imf23.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792446409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZMh0iCAmhjZDg07+iXZGqb/qmaSMmikK3Gld4B4JZmI=;
	b=64cKdO2U6w2oxkxisotp5233m0Xu7bknaPcEfBPceeZvJnV1pPa6ZboUnq7Z08IqoK2YvL
	DzgOlXeQ6Im6WKuWHSvXiBdITQA7xzXcoBa3OGBI2TRSfDjUO3NL0slJqCT7t5Qr4vhpJ9
	X/b1yTpNFXYD/XpepBnoCCFT/gpRzBM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MLRw0p56;
	spf=pass (imf23.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792446409;
	b=6TPJRPPt1IRg5GIzyhVZ1uzWNtGPNybaERDKegIJSwMSqG9v/ydGuwqtx+XEoEWmjP5trz
	of0z/jYA1+FsS8DIeCh/BY94dPBn3kMjaQQrds8zkb84hOmu5MUANkI/RxExgYDqyWDgjf
	rbOcNKILVptUB6A+fJnp+icyQdYklIQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 40CDD60098;
	Mon, 19 Oct 2026 21:46:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F372B1F000C4;
	Mon, 19 Oct 2026 21:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792446408;
	bh=ZMh0iCAmhjZDg07+iXZGqb/qmaSMmikK3Gld4B4JZmI=;
	h=From:To:Cc:Subject:Date;
	b=MLRw0p56RTCHYs3ndbGLGg7z8qzas9EKQRXKxLMBtobIGIxXx4IHlH9PI7P0GAWsm
	 PWBdvrRrHVNMeg9q/rKDe4sgK/UJ/dkBYaYLahu7vwGNT6Cp6ug9RiadqWjPgp5NiA
	 hGlj3I3ozZ8gOm+ExBIBm6OwWzVFoJnRHck++v4sRIalGpDDHsnaX6gnd6MM8APRDq
	 EDPRkWh7uHn5ONmUmyZU8JNPBvx3Z33yDMNApXnooBDDmUl0WqO0PwnftvAcSfz/rH
	 vGnPuORqalJowiqLL8GU4r0oxf2Goe9gqa7Oa+8yqd+ipktAIW3zyexgTTVJXAS5Dl
	 nDSnVhwtbSj7g==
From: Yosry Ahmed <yosry@kernel.org>
To: stable@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	Kevin Cheng <chengkev@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Laight <david.laight.linux@gmail.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Luiz Capitulino <luizcap@redhat.com>,
	Matt Fleming <matt@readmodwrite.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>,
	Mike Rapoport <rppt@kernel.org>,
	Tal Zussman <tz2294@columbia.edu>,
	andrew.cooper3@citrix.com,
	gregkh@linuxfoundation.org,
	sashal@kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH 6.18.y] KVM: SVM: Stop toggling virtual VMSAVE/VMLOAD on intercept recalc
Date: Mon, 19 Oct 2026 21:46:11 +0000
Message-ID: <20261019214611.404880-1-yosry@kernel.org>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2D176140005
X-Stat-Signature: m6qnzaxzbagmng71o4s51y7a3m11somu
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792446408-758251
X-HE-Meta: U2FsdGVkX1/5ybvI99VJuvwaP9vRjMujv8CYhFGNA+YMobD2dA6J8LrQ/RP4HvkV7MIgOF5tY0ltrMktm3iHjjVZ0hVK8TmkeX3GDhE6r/ZvzwFVcgcMs7wCTtorEnhfP8NoK23dMAndUobHjJSFscITHITVAtVu05B0bmcqyR0JoEQM5yw03IUO5qMP4GUErvXISXbSyddNFYZIAM+s/5M4MCuXl7fEECVx/1fKpVX0xzYPICwa2+7kNjVDMgZ+XPlzpnI4W8sE41lXhdFTEZZKB8ZKJEFsKnsOPKUpx60270sIt6U9w1vbZVOI225w9ZIhLhj1MLMT4qgtei1mnKMxugKZkqE5vrj9BiD1VNGXxjUxduGBJ8kLb2jkorUkEBdkl3YL5HucanrvEZHgpafJdw3SC4bCqk2JqIjLIQutzraqUFmI10RfEaMGFQ/Q2AcuzgrHDFzcdsc7Jb0Pl5hCxW9u2RVr4wmJYGV/7NQpf5Y3Q88F01ifgcSi/1p0Eut8HOvvMIs29DcGz/1rJGqmuZvPcqCmSljD4iB2uUKLQkCXmuorNl1cjlrBHRFEYxuVQDzIGMm88H5rjLIwSF3Xb1oDPX/kNK3/7wEqrORs5IOF46nB9/TIdwgKMeWyTJpYuw3YG52GlGRUhStoTS4fmbdE1f3neLvoklujQg6luyKRV8B4IkiLzPQlkZT06YeZLv6ZEThiQCQv90Mmh7lhb+OCUZBtHvGwlEUMLiUwYsgcfDUsInXhKhaeJIAaC0Y+YEwDduVvTzoYmLNC490jKoUDHzRO1LF4Ncygcn2Zwrl5AyFsj9l1mbXpvqV19dMASouGr0CLjitvrL5VYvgOr5AwdPj3hDjmD5vxbETncPXbXbdh4KORLWsYX3UOmVo8SjNhrmgdTOQSzKZ9/tcUYOTbo2+3I2aAs3Uc2KQcj1HnowhjpP1Y0tKPw/0Q5nGlPwKEsCCYxlhBO4t
 xwJvWab7
 hZp/vmucBsVTaLUcg3VIDlOy/nKniVSY/z/Jr2WsKumn4by4vKq86tBDvHaP+KDnO2Mu68pKnprtVMpsDdLhwYvBkOf6i/O5ECa62nJL747N/a18UacDBw8sTOggYYizmGNgLqXJ1o8FrPczBkIYEkB4tcsp+YOYCv1o++wQlt7gmkU7pjYwQizG1fiJiymA/3QCESfQaIBbxOnxSPXgXfJLr3pQhfgkJ5MxGlbxXXehucNjd4G+h79z7ZOdYgeD8blT8EZceXLGWCCDiTgBhy5MG5/8/G5fwqALHSH8K8xfVH9D3CvYEJlSpnH7YmPucmNRgrQpXeVhNbF7AGylHOcTo2Yro1Nirkqyq/BAcPYzSZZ2QEtMF/509sjh79NcgN+FpWpxyPfOTDJozcUjuSIg6y31vKPeGy6PG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Yosry Ahmed <yosry.ahmed@linux.dev>

[ Upstream commit 55780d8a1dcc93d2c4b33c565ada88df12c9f206 ]

Virtual VMSAVE/VMLOAD enablement (i.e.
VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK) is set/cleared by
svm_recalc_instruction_intercepts() when the intercepts are cleared/set.
This is unnecessary because the bit is meaningless when intercepts are
set and KVM emulates the instructions. Initialize the bit in vmcb01 base
on vls, and keep it unchanged.

This is similar-ish to how vGIF is handled. It is enabled in init_vmcb()
if vgif=1 and remains unchanged when the STGI intercept is enabled (e.g.
for NMI windows).

This fixes a bug in svm_recalc_instruction_intercepts(). The intercepts
for VMSAVE/VMLOAD are always toggled in vmcb01, but
VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK is toggled in the current VMCB, which
could be vmcb02 instead of vmcb01 if L2 is active.

Virtual VMSAVE/VMLOAD enablement in vmcb02 is separately controlled by
nested_vmcb02_prepare_control() based on the vCPU features and VMCB12,
and if intercepts are needed they are set by recalc_intercepts().

The bug is benign though. Not toggling the bit for vmcb01 is harmless
because it's useless anyway. For vmcb02:

- The bit could be incorrectly cleared when intercepts are set in
  vmcb01. This is harmless because VMSAVE/VMLOAD will be emulated by KVM
  anyway.

- The bit could be incorrectly set when the intercepts are cleared in
  vmcb01. However, if the bit was originally clear in vmcb02, then
  recalc_intercepts() will enable in the intercepts in vmcb02 anyway and
  VMSAVE/VMLOAD will be emulated by KVM.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Link: https://patch.msgid.link/20260110004821.3411245-3-yosry.ahmed@linux.dev
Signed-off-by: Sean Christopherson <seanjc@google.com>
Fixes: 5a1a726e68ff ("KVM: x86: Use KVM_REQ_RECALC_INTERCEPTS to react to CPUID updates")
Reported-by: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Closes: https://lore.kernel.org/linux-mm/arY1Wq6R9OY20ans@pcnci.linuxbox.cz/
Tested-by: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
[ yosry: The bug is not benign. Since 5a1a726e68ff, a vCPU restored into
  L2 (e.g. on live migration) recalculates intercepts with vmcb02
  loaded, leaving vmcb01 with neither VMLOAD/VMSAVE intercepts nor
  virtual VMLOAD/VMSAVE, so L1's VMLOAD/VMSAVE corrupt host memory. ]
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/kvm/svm/svm.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 335b214aa3711..5f3c6d7974fb9 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -981,10 +981,14 @@ static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu)
 			svm_set_intercept(svm, INTERCEPT_RDTSCP);
 	}
 
+	/*
+	 * No need to toggle VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK here, it is
+	 * always set if vls is enabled. If the intercepts are set, the bit is
+	 * meaningless anyway.
+	 */
 	if (guest_cpuid_is_intel_compatible(vcpu)) {
 		svm_set_intercept(svm, INTERCEPT_VMLOAD);
 		svm_set_intercept(svm, INTERCEPT_VMSAVE);
-		svm->vmcb->control.virt_ext &= ~VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
 	} else {
 		/*
 		 * If hardware supports Virtual VMLOAD VMSAVE then enable it
@@ -993,7 +997,6 @@ static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu)
 		if (vls) {
 			svm_clr_intercept(svm, INTERCEPT_VMLOAD);
 			svm_clr_intercept(svm, INTERCEPT_VMSAVE);
-			svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
 		}
 	}
 }
@@ -1137,6 +1140,9 @@ static void init_vmcb(struct kvm_vcpu *vcpu, bool init_event)
 		svm->vmcb->control.int_ctl |= V_GIF_ENABLE_MASK;
 	}
 
+	if (vls)
+		svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
+
 	if (vcpu->kvm->arch.bus_lock_detection_enabled)
 		svm_set_intercept(svm, INTERCEPT_BUSLOCK);
 
-- 
2.56.0.212.g129ede20d9-goog


