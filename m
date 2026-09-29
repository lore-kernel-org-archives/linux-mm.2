Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20FB0CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 04:03:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EF606B0095; Tue, 29 Sep 2026 00:03:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 179936B0096; Tue, 29 Sep 2026 00:03:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 068526B0098; Tue, 29 Sep 2026 00:03:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D71B16B0095
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 00:03:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5E8EE803CC
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:03:26 +0000 (UTC)
X-FDA: 85265455212.28.F8F3ACF
Received: from mail-yw1-f227.google.com (mail-yw1-f227.google.com [209.85.128.227])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1FB5A160009
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:03:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=XIUZKDeX;
	spf=pass (imf08.hostedemail.com: domain of zack.rusin@broadcom.com designates 209.85.128.227 as permitted sender) smtp.mailfrom=zack.rusin@broadcom.com;
	dmarc=pass (policy=reject) header.from=broadcom.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790654604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p1CKCrpax+qcHAbV5I37hg3uq7X1UIkb9ImgfW4E7N8=;
	b=eywAhfywJf4GigQiKr6vPDperYygX6pX5nChfXYfKwCRcBPRXvMzazGfpCro9sGBbLoVyo
	dAkel2rnyWzZzpcrQ1IGBBSJXbwcjcIb5p7KmEocBliTw0MviTPAwMOcgGYEyF1bFPhHRC
	Nph90FU4IOhWA3HVqnuP5ctSjcF4bMs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790654604;
	b=29LetnxPnhYeKy/obL+wv6BIR1CCRUJ7nLSlS7DrS48PYi9vfOhaAIYLU5ZYQfhTICDYfQ
	ZS+6M7K6DER8Qb/mhGUtes8u2xMczg7kpD/8fczjPJMfcivIWO/nwYm6HA4OteWcOW7fkC
	g4g45TMrVAMDwKwvjVeacNnwBBeigy4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=XIUZKDeX;
	spf=pass (imf08.hostedemail.com: domain of zack.rusin@broadcom.com designates 209.85.128.227 as permitted sender) smtp.mailfrom=zack.rusin@broadcom.com;
	dmarc=pass (policy=reject) header.from=broadcom.com
Received: by mail-yw1-f227.google.com with SMTP id 00721157ae682-89296e56dbaso6156957b3.2
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:03:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790654603; x=1791259403;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p1CKCrpax+qcHAbV5I37hg3uq7X1UIkb9ImgfW4E7N8=;
        b=HVa7d4pSrtwliyy/Md4lLMJJ/wqv4TgG4+XqM/TWGpl3nXKCRmJtV6CFlGw/m0gcDd
         qqL5QcZsF5eijboDu7u2yeDZuJ9DX9uFg8XYo9O2EUSlOXium1X7+oZcTb0RNZjPzi7a
         1dTVr9iB3CJbRMuLm7bOnYqwng5ilJEQ9fQ/H51K6V40Su8YZI9/sIP2/neOhZkIjiDH
         9l9JXhIUSQF0u99TRNbxbgBO8UuGVBrDqzlEHNS8szDSYWfVHVRQxCSdUcgK2kQQ3uTX
         GNqfEYw15usPand9GnxennOmDYnsSBjzowEUxxCDW5sSR3sLJ6DnPOltBPSReVRALopU
         /Uew==
X-Forwarded-Encrypted: i=1; AKwUvBw1wD2vCTH2gPzNg9U1YA2rQjO5M5czqf7u4cdLVorSHSsLy+7/cdTMZ6jNdb6GVYu9LN+rG4u+2g==@kvack.org
X-Gm-Message-State: AFq9FYJ1Ks2ZRXaQmAGf8Duz2PCF8ywSaQn2NjVHglwgnT49t8Pqy3pV
	HOa82bVXCZ5lWJlLN1bdymPu1ogynphKE7vhwJ5Q+0ylgEr17e/KiTHBSoaoK5/A5hDnI0XtZw1
	1y6vkYUZXq32hbWrVJ3P6zBoUOPLov1P+x86obwEU1gsT34iqCAQmUGBTLO0S/H8xc1U8qqC3yh
	WSby/Fl+FlH/nFlae/qRtD9OmXoqOApP27ZhA2ioqewdlLgG1A9/Eknszke//Z1RS/Fwe0R83ZO
	JI=
X-Gm-Gg: AYBFou3zF/iHVcWnX/goUb/Oosx1nUygCXoT8eijKFgrrv2x06xfiA1U6182lQul+Nj
	N4AVa3ADGbjgwCJaiY/iRZswNMdU63j0IvpjlpNbd9auJXJHqcJR1xYYiht763IBNlJ0B55FVRZ
	aXFtQ7BXi+iMIfFFZHlLHohtClmTb3SXSoaL4dHyc2LGKr8LF94BkT29fMA0MwzG6UnGOY6XmAF
	vk8dHuJ0c/SALe/KLtN2UgAvbJEvWBah3ChpfAPgdKJGUjmoVuNBqr7BQsUqir5jeoOsxuhCbQj
	7fLs7TlEeCXJoYM8EP9bPiSY6q56xj3J4TxNWt8aXDNAj6u7w1XnXOO5jUsGLpfObRE06XRqPtM
	XvyMwqV4JBdZZQmPPIN9J82IepxI2MaGz1ptB5RQvxXjkUQipg7GIf82ZMiKNYdUEeK4Pz7h+tA
	l5vj7kidAC3xhYm93JLpalomM+EUPTCuj+/pI=
X-Received: by 2002:a05:690e:d4b:b0:674:eef:ffa1 with SMTP id 956f58d0204a3-6740ef002c8mr4495533d50.7.1790654602885;
        Mon, 28 Sep 2026 21:03:22 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-120.dlp.protect.broadcom.com. [144.49.247.120])
        by smtp-relay.gmail.com with ESMTPS id 956f58d0204a3-6740efb3a2csm1733364d50.26.2026.09.28.21.03.22
        for <linux-mm@kvack.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Sep 2026 21:03:22 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-30c0d568830so7722359eec.1
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1790654602; x=1791259402; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p1CKCrpax+qcHAbV5I37hg3uq7X1UIkb9ImgfW4E7N8=;
        b=XIUZKDeXZRA3ODLn9BqRbcYfvBbnOTk0MR0xPEFt5dfg2aKmp2fZee+c5IbbTGVeRl
         57VJp1Hqi9d3CZCZaCL24NhQ7ckksmeM+JB7fb8pcUNolf/lrexyHgcqWnNTySqLEsjX
         AJBw9T2zvUH4cbUjLFGXXc8YhnjkpQuewNrI0=
X-Forwarded-Encrypted: i=1; AKwUvBxS2A4as/hoMb3bEMkCQ65hsXwvyi3kI+5W/hXKJrFWQhOn4AEIBCUdoF9yfXOEj2dBeUriskZtww==@kvack.org
X-Received: by 2002:a05:693c:4099:b0:34b:401a:4648 with SMTP id 5a478bee46e88-34b40298aa6mr875198eec.20.1790654601477;
        Mon, 28 Sep 2026 21:03:21 -0700 (PDT)
X-Received: by 2002:a05:693c:4099:b0:34b:401a:4648 with SMTP id 5a478bee46e88-34b40298aa6mr875122eec.20.1790654600700;
        Mon, 28 Sep 2026 21:03:20 -0700 (PDT)
Received: from vertex.localdomain ([192.19.144.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-347323f5a7esm10952571eec.15.2026.09.28.21.03.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 21:03:18 -0700 (PDT)
From: Zack Rusin <zack.rusin@broadcom.com>
To: Kiryl Shutsemau <kas@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	virtualization@lists.linux.dev,
	bcm-kernel-feedback-list@broadcom.com,
	linux-kernel@vger.kernel.org,
	Christoph Lameter <cl@gentwo.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bo Gan <bo.gan@broadcom.com>,
	linux-mm@kvack.org,
	linux-arch@vger.kernel.org,
	linux-coco@lists.linux.dev,
	kvm@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-doc@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Ashish Kalra <ashish.kalra@amd.com>
Subject: [PATCH v2 3/6] x86/percpu: Require embedded allocation in encrypted guests
Date: Tue, 29 Sep 2026 00:02:52 -0400
Message-ID: <20260929040256.543767-4-zack.rusin@broadcom.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260929040256.543767-1-zack.rusin@broadcom.com>
References: <20260929040256.543767-1-zack.rusin@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
X-Rspam-User: 
X-Stat-Signature: yen531ywnkfp6pa1grium9k6spybmuke
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1FB5A160009
X-HE-Tag: 1790654603-955301
X-HE-Meta: U2FsdGVkX197zSuBugpwuYAdwK/iosWl6ow35cgBV7Sser5/qbQ4BR40zc/UqqVQ/MBiQS0mFi53hcx8Jrkm1BHGl7u4ikZncDb+kQDUceV45FDVbpm3hcYUcBqDA0xpOwKWbevM/mhq09KFP2g4aLkJLu9xSIvN2F/fbgkmpHHy0pLeK+xfLbW+9rbfszlKEOHCUNqO/KDtY2Uxr6lBijCEohdfz/L5NhCdYvjmYWMB/0d+bs1PNEfNg3ZEDIyFWwwN9WX9f7FWsYTQs8wKJ2ssgdAQuuPGRARYDvLaqgdgAWtvCNR4J4SEHQ2je31zkm8rukolgrU0I+TFjfqGcz2WNOti1eAML3rP3ZeVRqVkN2PVFmQwLLtfI4S8C4bDP6claflNXuH/NSar5olNZQdiS3RjEpgFvYOxVrOPD1OK+qqRa9nINfy7G7hk+Dr5PbvYQ/Yu1hRUmlGnF7X48TCRLvvgOzvYDDLKe0DtL6gvKb60oG7nEQ8f3FP35/ii5zuRSaVFKabSK4QPkY8mgQP73eKvEFYPKB9QyNTJICbWF7C3sMHMByMCMPLFcEmEz/+KV55dfAbS8jkpKhrehse/AvxNnAc4/kLl2OHbAJaoqsqfdtNy0sckRmgt6JEb7EMVMOxociE20IPA8YzvdpvPno91dMuus8Am/AldtfBFvzMGv9oDuZ+/ettnJQLGnO924y8cPcFANTr8FbkwmEHZuAe+OoPmnnnuCLEfzjBv+YgRVtPHbmkyQmqp2PMxCYehjV6/H5hgRS0IIPtjmQkOgdy8HCQsLRm+IO1iCAGKleG3r6uvRYA/6PMnqfbj4YlUMNgMwBuxQwvKmtja0xmEldC5tpciKKt14BrhDMzSxR2KrvesZycdj02i2YKO1bD4sAKIPxBavSkIXwEaiZwNCfoehXwJBvC7L37X6TyHEQFd3rnq1cHUV56PEfTFBUGGAVBCFVyi6Y65x+z
 YdJnS7e2
 8dJP4ZrpKJf89PsI0CWlr1IB7I9jHokD9GcEJ3GqicHrD/eJJvGZxIBZr5godYOob7uY3puXZopqujiSVP1bp3dQtkO4sN76iwupJg2CsTfAltfxQ7tOvlQH9Td9cz7OxTFEVQjyTDB3jo8IzyHO/LIx+rLRs7PTORPResQsLxw8ucntAZ2/rBdpMwRKyfA5rYTA1xNjbI1NW3kvzlDGfTaZk3ESa5fS+0dnHVQkbgQmN6PN58s4D4G+7pBQnm48OdmyD/HKlYpFzIi11vH0z4qIYEVobB9ssUHiDx3cGtufPq665BsDvoUfeo0lXmFK3XL2UUn+EM2OYoe4KqcmWciSRkBuv1fj0s3mSsCChG0I+fHnpYAYIJbK1khlduzB5gs8Z4XgsHbymnxonRKJSXRQhEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Early sharing needs direct-mapped per-CPU storage. In TDX, a private
direct-map alias of a shared page can terminate the guest, including
through load_unaligned_zeropad(). Require embed rather than adding early
vmalloc conversion and alias synchronization.

Warn when overriding percpu_alloc=page and let embed failures reach the
existing panic. Restrict this policy to encrypted guests, leaving host
SME allocation unchanged.

Suggested-by: Kiryl Shutsemau <kas@kernel.org>
Link: https://lore.kernel.org/r/aqvxQoIoYhJTZpAC@thinkstation
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
---
 Documentation/admin-guide/kernel-parameters.txt |  3 +++
 arch/x86/kernel/setup_percpu.c                  | 12 ++++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 33cd30996e47..8ba881af3520 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5347,6 +5347,9 @@ Kernel parameters
 			See comments in mm/percpu.c for details on each
 			allocator.  This parameter is primarily	for debugging
 			and performance comparison.
+			On x86 encrypted guests, only "embed" is supported;
+			"page" is ignored with a warning. An embed allocation
+			failure is fatal instead of falling back to "page".
 
 	pirq=		[SMP,APIC] Manual mp-table setup
 			See Documentation/arch/x86/i386/IO-APIC.rst.
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index bfa48e7a32a2..c83c61e0b20a 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -8,6 +8,7 @@
 #include <linux/percpu.h>
 #include <linux/kexec.h>
 #include <linux/crash_dump.h>
+#include <linux/cc_platform.h>
 #include <linux/smp.h>
 #include <linux/topology.h>
 #include <linux/pfn.h>
@@ -112,6 +113,7 @@ void __init setup_per_cpu_areas(void)
 {
 	unsigned int cpu;
 	unsigned long delta;
+	bool encrypted = cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT);
 	int rc;
 
 	pr_info("NR_CPUS:%d nr_cpumask_bits:%d nr_cpu_ids:%u nr_node_ids:%u\n",
@@ -127,6 +129,12 @@ void __init setup_per_cpu_areas(void)
 	if (pcpu_chosen_fc == PCPU_FC_AUTO && pcpu_need_numa())
 		pcpu_chosen_fc = PCPU_FC_PAGE;
 #endif
+	if (encrypted) {
+		if (pcpu_chosen_fc == PCPU_FC_PAGE)
+			pr_warn("Ignoring percpu_alloc=page in an encrypted guest\n");
+		pcpu_chosen_fc = PCPU_FC_EMBED;
+	}
+
 	rc = -EINVAL;
 	if (pcpu_chosen_fc != PCPU_FC_PAGE) {
 		const size_t dyn_size = PERCPU_MODULE_RESERVE +
@@ -149,11 +157,11 @@ void __init setup_per_cpu_areas(void)
 					    dyn_size, atom_size,
 					    pcpu_cpu_distance,
 					    pcpu_cpu_to_node);
-		if (rc < 0)
+		if (rc < 0 && !encrypted)
 			pr_warn("%s allocator failed (%d), falling back to page size\n",
 				pcpu_fc_names[pcpu_chosen_fc], rc);
 	}
-	if (rc < 0)
+	if (rc < 0 && !encrypted)
 		rc = pcpu_page_first_chunk(PERCPU_FIRST_CHUNK_RESERVE,
 					   pcpu_cpu_to_node);
 	if (rc < 0)
-- 
2.53.0


