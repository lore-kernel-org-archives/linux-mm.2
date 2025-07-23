Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8631CC83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 10:47:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A33088E0007; Wed, 23 Jul 2025 06:47:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 997128E0001; Wed, 23 Jul 2025 06:47:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8367F8E0007; Wed, 23 Jul 2025 06:47:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 703198E0001
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:47:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2E6EDC064F
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:22 +0000 (UTC)
X-FDA: 83695202724.20.6CBE4A4
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5644A10000A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=A3zQBf3B;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3tr2AaAUKCH8wdeedjrrjoh.frpolqx0-ppnydfn.ruj@flex--tabba.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3tr2AaAUKCH8wdeedjrrjoh.frpolqx0-ppnydfn.ruj@flex--tabba.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753267640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ArQXXXEY7OXN72DRjey+Kc1kp56HNzq8gc9uHD9gj5A=;
	b=CNWO+VqQTZ1aNOtd9cNBSE44bMFxRgWr+EUacMbLn0P45M0Fk/bMlaoFTy0vGfjs2GTHJ+
	G6RpEcKnvHFzG3+D2O9Q7a0ESb56zvP+AKemvXKGDtgTkM15jkYkTFh9dAl+Iz4MRcwYLG
	2LLaeXmtYWfD7Zlyhhi4WCzJuWOUaCE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753267640; a=rsa-sha256;
	cv=none;
	b=bnIzudKbmdgv+wkrztxt+yWDDhtPKVTYlKdO7eGQ6rZbGO8SFo3S+nKyOVcfFn6/Ss92fC
	FzNkZRamItFqj9kkONZxtrFv8uwMXwLIj6PT030s8vZt30LMwtdryEd9seRVUEfaRFnPx3
	+mF3qdUrEJQXcrsl3lZMdQxbCXoQEik=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=A3zQBf3B;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3tr2AaAUKCH8wdeedjrrjoh.frpolqx0-ppnydfn.ruj@flex--tabba.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3tr2AaAUKCH8wdeedjrrjoh.frpolqx0-ppnydfn.ruj@flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4560f28b2b1so23055745e9.2
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267639; x=1753872439; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ArQXXXEY7OXN72DRjey+Kc1kp56HNzq8gc9uHD9gj5A=;
        b=A3zQBf3BC2YfAz1BOBKievB9SUVOv1LVTTLsMaMThPvqXGbaYDHSjE/d3Im1FuIPse
         4lvlZK19SsARapVPvhaQ4OuXWl2FJqH9p7XfF1qRTDZdMFjP1IB7hTdzjzjsuFINQbSO
         xclEQAO3cbT0h1Hw7r1ZSaEzTuy2HfTsWu8vETHwXcDHHni1z2orb4cm+4zoTALLtGhB
         Hg5AXRNBv5QRZ38IwS3cbMrfJCce8Xu/js3GgunsugqjHci1131TQsXzuECbYbOSDCAp
         Hjv/DZ1q5K3ajP+YOelfV4D/fEkqjAMATZq9kRrPljY8Y0b3BHOwg1E4FHsD3YnRTYu4
         Vwzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267639; x=1753872439;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ArQXXXEY7OXN72DRjey+Kc1kp56HNzq8gc9uHD9gj5A=;
        b=EjFIWPwxMiGDPw3IDs0hhWGN7RF4PtSTdh5BRUY8fyUHkxwnu8xfZnv8lFLiFKaH9u
         gZ5X4BVQUa3ZSj7/7+wX70tj/F6dgBySiczPrkYv3dF2pjN084o/X5xpM1LP77J+/qvJ
         uLRldETQs8cpLyOLOHMl7FYvNlZcsmG9aVjz2Lda4D8b3ISqPiguw0kTjO4sqr/rOwLZ
         4zXIe0FCnPs+Y3LE71L0HJ9J5gqiuLCyNvCNXVTUwLyG9ofz6FTCgasHtAmSQcJj3vMB
         Y2hC04M4GuIYCTssy2IBQ83X0U8uHZ6ebywqbfurhbzrD92BVo26v+9OT/Mbc9NCzNVr
         rV6Q==
X-Forwarded-Encrypted: i=1; AJvYcCXtsrZ+7rgRpdxFBg8Hg6pMXBDYXl9LiSIZ33OVgVntkWNh+M+d4hlN5AfyENkBljUjZuPF+GJNbg==@kvack.org
X-Gm-Message-State: AOJu0YwExt101L7zbjo/09sKOhty+N0PUuIaZVERKtsg+YtvfpZ/U5rB
	0EBlsQUQTKBAdOOuRReoGRisRABHEMDBhw0H5fEJ1p9T9FYAn7/QzzTzOS7djnIYfezx3y9iQUU
	rHA==
X-Google-Smtp-Source: AGHT+IFw9/gp4rUKGBmKsgikBacUJjpjGeakFJ8EOn8lPNZtvr6eyYajGoSHpKrwO0vxhCTQzHhdq7/1nA==
X-Received: from wmbes10.prod.google.com ([2002:a05:600c:810a:b0:456:2903:c96e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8717:b0:456:24aa:9586
 with SMTP id 5b1f17b1804b1-45868d4efa6mr17457625e9.21.1753267638782; Wed, 23
 Jul 2025 03:47:18 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:46:56 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-5-tabba@google.com>
Subject: [PATCH v16 04/22] KVM: x86: Select TDX's KVM_GENERIC_xxx dependencies
 iff CONFIG_KVM_INTEL_TDX=y
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
X-Rspamd-Queue-Id: 5644A10000A
X-Stat-Signature: 9bq5i315hbzrdqzwb7ks7hsicdnoz614
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753267640-537950
X-HE-Meta: U2FsdGVkX1+d8yoi+9lFntptT9ci0rLg2Orgp5Kqsv5+Ra1MoBWNpw9vFiVLZ1zNDv3LkxOV5z6YkGMjNEol2XKsE864aAjpXqVlS2BK44owO5dnGBy4rnRiGoGNkYiGXhMsS+ALE95Ai2gD+nDJHoUCtzCwNMzBx5PxjyR0wYm6CyIEcx/Y0sMYJ3KMTYnnhuffHVY551/ZR1JVzeySfVqo9AwoHxsr4/j/MIkSYK2ebjf1H38tPzJBhLJ3lys2LYPtYHkuSJ8m2eJwM1w0s3VJ4tEEVou04zqB3M6l4CSlBfn7nUxw4ObVESGvTuV3XI6dI5stQ8/j0MH7qlePWFXdF+9ifHeyv+tkawwjoQ5baD+bmQ/e20EGvGHaQuqXntvSBVep+wcmV7NOYKLeuSnmW9uQKB8DzY/2HveK42HlVBfU6CQr3AeXrcXwAAfRIprS4r3UMPZd2aEFDg51I2zZWegevxp0tqEsmXtnaFgNbMZgtsEzyfMtE6nrpAvhV2ykcDT5YP88N9Fb49iLszQvlhCBczqbwIGZS/zSOsZzOLzqiJ2am2mVQvUjxO5+NM0f7LuVH3stqTGFofVyVRba3Xdy97lmaOzSU4XZ41pwsatDb05SQR08v+G7Wg3CR722T14usxyPEh73E5n2F6PCUp9R05dwrUbUpjnTRn0A/7KMAGlidWBX4XBSmUI6QixxJ5y04kaF2f7v23jxc4dvHM/CMbn/5abNGR4yz+MwgDehd06x5xk9r2TVIJMOMRCWNsC1Oe/8KlcgUB2kvk/om3pcmEtAUrQxOtZimuz7PHugb5KN9Ujp2aETZF4cXYxqhN2rBJYauFbGt+swlDNsP14NhcZ4oZzBB0JDrJnrfUlas+YhiBYQbXhWTdem3WewrnW17MwNOoJ5H0NlVSNUkwLlAOXzfNXlDDMWQeK/FVzsqlSd4uQz6fSMAGmWkQcN9ZfWhyT82oNJC3s
 DhdvylgR
 8ZLlwQaES9qpDbZ5au/P8WEUkf0b/GMdTupqm1f13Tm/PfyazeNhKG7N6wnl2JrdgJGxKMX/e1av12izFxF3j7oYOSjgyxQAroTL7AWevbK2FKNcNVrtZf03OowzPFTaTDyxn9be8UGtCnaMjWwlNP+dcOZnyVOLllvnLr3eEz5azB75li6NzLMSqbtcVwJ3YVsa7sp017yp4+HnAOT1xMFRx5FBNd/VxYAcBLxER7WsCZmoYWaWtKrbvsERqHH+F/wyhGU0JCRy/zAq7JTqsRdtvIGw0YP89+XMMpC2O35BlRq4YSKi/ZF0TUTDzmsRkRvPOiPluAMRs1MbZP5nYFl/xmgDl2i91FXx9E4pRS+vVZyrBnZuYF+B4FoyO9VOReuWuJtfPKEvLsKkj3EKjQIcFIVYYKtD/oDLRMpJUgGiiRxZVz9r0mLMl7EAiFF+iTThecyYjoqbc1YWn1JhYzlPsvcs8aVgurwHxA/rYG+nYuybLR8V/uxbRFPFK0A2hN9xzoYLeNoFZ/l1wl9XyPTqS8uyPtrhLFIZpMAH1WBxp2hSglHENGvq4ZMJfXqSPRXAPXmIBjywKpnWOv32RyZMX7hxjDT2FiFTajTEXq98nDAvUyiCvzLYKTl1l5ikpNFLHP9OK5jJ+q65PNTXRqy/hNA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Select KVM_GENERIC_PRIVATE_MEM and KVM_GENERIC_MEMORY_ATTRIBUTES directly
from KVM_INTEL_TDX, i.e. if and only if TDX support is fully enabled in
KVM.  There is no need to enable KVM's private memory support just because
the core kernel's INTEL_TDX_HOST is enabled.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/kvm/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 402ba00fdf45..13ab7265b505 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -95,8 +95,6 @@ config KVM_SW_PROTECTED_VM
 config KVM_INTEL
 	tristate "KVM for Intel (and compatible) processors support"
 	depends on KVM && IA32_FEAT_CTL
-	select KVM_GENERIC_PRIVATE_MEM if INTEL_TDX_HOST
-	select KVM_GENERIC_MEMORY_ATTRIBUTES if INTEL_TDX_HOST
 	help
 	  Provides support for KVM on processors equipped with Intel's VT
 	  extensions, a.k.a. Virtual Machine Extensions (VMX).
@@ -135,6 +133,8 @@ config KVM_INTEL_TDX
 	bool "Intel Trust Domain Extensions (TDX) support"
 	default y
 	depends on INTEL_TDX_HOST
+	select KVM_GENERIC_PRIVATE_MEM
+	select KVM_GENERIC_MEMORY_ATTRIBUTES
 	help
 	  Provides support for launching Intel Trust Domain Extensions (TDX)
 	  confidential VMs on Intel processors.
-- 
2.50.1.470.g6ba607880d-goog


