Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84885C982D8
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 19:38:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8590F6B00B4; Sun, 20 Sep 2026 15:38:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 831956B00B5; Sun, 20 Sep 2026 15:38:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F87D6B00B6; Sun, 20 Sep 2026 15:38:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A2AC6B00B4
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 15:38:40 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AF0444047D
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:38:39 +0000 (UTC)
X-FDA: 85235152758.16.C2EE045
Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	by imf03.hostedemail.com (Postfix) with ESMTP id E405F2000B
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:38:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=FNL3a9me;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789933117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JRKWvI6gXs3ZnBptz6N5dDWBJj3evKh9UPuhZyU0zUo=;
	b=zFyqs/n9jU//VUJ054rdw4D1bPaa1po51OHVMM7rkj+joHOQd1E+vFMsuh5W1LY91v3Rt1
	gWDOrhaMWFLyMQqb1a6UrHrITlLA9ab2XZDVBH54AYzvanaYBp8ne0mXLXVZ28XV2p5fcY
	b6vzRx1FFVVsfwJaA6U23eYEdixyPOc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=FNL3a9me;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789933117;
	b=aQTy0r6XwxgCFmsXTEi/duieMWT3M3lw0CPvgSY6SmA26fICPDHsVvzv4mlrYcq/SqQSS/
	+nfa9veHOuIv0XqwbTz55z4VyUw4NSStsEL6bPoPTikYd0VvuI9nErkydRPOykAUw4DpCj
	N/omCI3/4unW9mHJGzKNcd4kmNp5r4I=
Received: by mail-yx2-f12.google.com with SMTP id 956f58d0204a3-66e4ab201ecso1902421d50.2
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933117; x=1790537917; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=JRKWvI6gXs3ZnBptz6N5dDWBJj3evKh9UPuhZyU0zUo=;
        b=FNL3a9meP9o9AA9XEK+7UK2ISNYFwA+Lf2HpubS8Qx2DepLD7uE+6RSo8qG5nAIDzy
         +5HS1TstkuMnWDsb9/oJHEJbsw96jHvn62QCwh99WY6M8MoUpqsz1P0muDG1cElmVHFF
         Tko6Y/nmFmuRPpuAfSW7iYJiVH1mr5lSk/DqLI6Mk/yk3FkLge7wOammS1wy9iXbtGGa
         U/fEGGt18XRZl2BrguseOajVYTd2TauGjdSoDNcCogm36Ph8NFSQc7IFMHq0uSnQHq3D
         A94y2Qys0JIX+H6A0bSuLrHDoF3iOJFaoJxOx+cx/Wt1toIYBJk2tKyX0Ts2j9hrPvhR
         U/Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933117; x=1790537917;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=JRKWvI6gXs3ZnBptz6N5dDWBJj3evKh9UPuhZyU0zUo=;
        b=h6651PTD5B/B/XcQIdXdcpllhRwU05Al1+lPdqRtKhhSBRUUV8t+ZTT9DbYuxp2tJW
         bWjqw5sM0XwWMznze7dT4icTLGvbRrRB3tEtDKAfDAnNItQY8NS57IzNzvUjFmDt+1F8
         F0W4DfADRPQ+1tQXTXvOKvTcGGoGYnlnJIEDFN8wCE69tDRR4hsyprYl6rGBLc3KnB8K
         LTK5oWwufoTxTl+i+xO63CZ4kDP2+FVT5c4c/5axf3+Xs7AbypWofwnxK3yz9V+YwX++
         Bx+8l2Xv2uINqznOV008h0Jg2fT0xMlfQrySl9k6GB1OEniEevFExMTEX4OBaiYdJPIg
         AvOw==
X-Forwarded-Encrypted: i=1; AKwUvBwey4nVZjEmTn2jAlkZfyNxBFc1pTI3X13aFdtd4Y1W4cB/9eB8krd8V/Zz2kkUpi74gwGeAxEPDg==@kvack.org
X-Gm-Message-State: AFuF++lJKUq2IFk904tmxMSaRV/pKpJLTzYEtSshmuqQveC4pVZNN6uY
	ioILeYKLDxt4JxlzHNfqDARainQ6V8VwKOoe7npOb0aCX1R6TKchnlhynMINFoNNq3U=
X-Gm-Gg: AYBFou1kUkncM636XEaGneT2SMi263SXtkAFDxCBZ7CGz5K0wMapvUigt1nALd07qCw
	o6zcGrFaXLZI1rx60B+G2MN8W/u3T1iuU6pYN8rHsMq9r8uF844RS7BiVBM2t73yaoFy9H9YdwA
	wHvlQNizIhAheM7NAL5/UlgSdE/VU2qVprRm+DQOtZo6MBHPOjuGqj3dlYmpUpXQGBbNhqOFLlm
	uPhonJu4ANK7cs+ezA5hDrG6WJ64HZzESgeo88Y0K+pRqWqKWRTMteD+x2k+JqSc0ve0CeL+4FR
	Ie/2PjGFrcjpz8Aoh5ZBUzyZuieBVZ47hRfjB7HxiZFInYXHuZWe2pwXe9RIYF/EM+Nv1g4UjYE
	K2wvCPVNn4Q6hu61KRMq/a1pfP/WvZTC4McFPCdfIOfWKaHv4lbatkCTseNew5sqkLnQARrXVbq
	ZXftJx/G99JrKG9y5pG7vbXxyaoPhRS3EwjlJBHUaEgHs7eK9HKjw9yIW50Afg6BV2j4+kfvhfD
	i6QLfNcEdK5HdjXrprW+uyID5SijMg48Ku6Msv+JBofKACZqefLG65LCfLUTh3zPZaqaMDbPoPK
	gOf9E2fuqs/6kYOp3t8=
X-Received: by 2002:a05:690e:d44:b0:66f:c1bc:87fa with SMTP id 956f58d0204a3-6717fe14445mr2057757d50.83.1789933116687;
        Sun, 20 Sep 2026 12:38:36 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-89a46e4f919sm18960787b3.24.2026.09.20.12.38.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:38:36 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	legion@kernel.org,
	kees@kernel.org,
	will@kernel.org,
	ruanjinjie@huawei.com,
	atomlin@atomlin.com,
	rppt@kernel.org,
	jani.nikula@intel.com,
	hamzamahfooz@linux.microsoft.com,
	joey.gouly@arm.com,
	tglx@kernel.org,
	nsc@kernel.org,
	alexandre.chartre@oracle.com,
	james.morse@arm.com,
	dianders@chromium.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	shuah@kernel.org,
	catalin.marinas@arm.com,
	linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvmarm@lists.linux.dev,
	jaredwhite@microsoft.com,
	johan@kernel.org,
	pbonzini@redhat.com,
	mingo@redhat.com,
	linux-mm@kvack.org,
	seanjc@google.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	tarunsahu@google.com,
	gshan@redhat.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	xur@google.com,
	djbw@kernel.org,
	oupton@kernel.org,
	nogikh@google.com,
	sumitg@nvidia.com,
	linux-kernel@vger.kernel.org,
	zengheng4@huawei.com,
	peterz@infradead.org,
	corbet@lwn.net,
	suzuki.poulose@arm.com,
	luto@kernel.org,
	hpa@zytor.com,
	zhangpengjie2@huawei.com,
	x86@kernel.org,
	yuzenghui@huawei.com,
	jic23@kernel.org,
	ardb@kernel.org,
	pasha.tatashin@soleen.com,
	petr.pavlu@suse.com,
	ryan.roberts@arm.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rdunlap@infradead.org,
	kvm@vger.kernel.org,
	fuad.tabba@linux.dev,
	maz@kernel.org,
	mbenes@suse.cz,
	jgross@suse.com,
	seiden@linux.ibm.com,
	pierre.gondois@arm.com,
	song@kernel.org,
	nathan@kernel.org,
	pmladek@suse.com,
	graf@amazon.com,
	chao.gao@intel.com,
	zhenglifeng1@huawei.com,
	arnd@arndb.de,
	sidnayyar@google.com,
	linux-arm-kernel@lists.infradead.org,
	vladimir.murzin@arm.com,
	kas@kernel.org
Subject: [RFC PATCH 17/46] liveupdate: cpu_preserve: Add isolated address space management API
Date: Sun, 20 Sep 2026 15:36:21 -0400
Message-ID: <20260920193650.3373435-18-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E405F2000B
X-Stat-Signature: 1xnwibhoddaaif6xp91sr765pzpbsbac
X-Rspam-User: 
X-HE-Tag: 1789933117-466488
X-HE-Meta: U2FsdGVkX1/clkmT3g1sygUaVA0fZhgL2JXWpDuRgnHc0g32z39mBLvjueJbFqt8k0jsWj81e2PuOPNOSix6mcI5MmKRtyAJMzt+jatQbUCtVlNod2rmzA97Upj+QvOhOl4CzK0T+5NnxCKJ1oReXuIvyIYalCkSpkR5ek0jJCtJQBUMxRAzsWf1UzuSo2K+T+6uKCu+Ni9wUSHWD3FlKROBzTbhiRDJSEahqMOb+CMmaPTYSS7exka/x9pt1uXn0dIzL8olMvXEqgvWiJ5l+TT2ONK2gQYEIK0BGA29LiFjGc05/T7MtYMrBhNNPZDRyZzgwWW8kCJvd8roP/yX1EPDT08/9a/vJkEaEbtBFhWg6jBmJGb/YLNv4Fkrm0uHuRfiK6vXtsbSE5RMjKWg5VuIiRI3w+bauhC30Mzj+uIkokZ3QiTJI7ISSf883c3cp5BP36CmDpeDGoQzke4OlGfly6ypVlM0/IpF6Z3Uwl7GZ0W7Pdjt8QMMColmLbsqbHzr7C6guPQYKFlJ1LxZOntINUDVXUd7BChR2J3uZJndr4Y4tSl0K5xlGCj04xlrePRibA8GDY8m5QUV6qaAX7N0Cdb+OVaZF6PUdE0jST77Yiok8sTnRP8GjJ9FabFpHRBZ2SYBtNsAOwUtOOJja51+G+icu9DQNH7nVyI6rihqliC/FjCt2IPyvhYKrPSUaWNDabLS3kpHw2iQiuGAzCJm2BEWRXZKg0/lxpbdbjMH41wiXm/IFTzDVa8noqCaxLkUdhVJ1mXLqfdBXdiDh2V0iQjfw/e2IhJtsE3NL8kNv2JUKYFQNPeC1tjJXAlZB8nlCgvlRtUAzvvZkTnsnkY2kgvodXZqpPjfIMm/qhGzw1J/gc6N6GT/m7YgpPDrt5SPRE9qfd8YKPsxGMzQMDNBiQeYjPpd70Ccvf3Oc+ucgcgxpiVeXiNh760nzr4lpNp2TrQm5oPDG4TNbdf
 TQx+iHmG
 Cxvo2fP9YkJcc0sB6jAxhsU4XGDXRlkYkCYDYPvz8IFIdoJsjHtD0mAqjkKwIWq+lKIrloYonheeRpFFacRWXg+CvgfgUcXf/NrK1oOj82Do4Waz80sxOudb2VwUKlmfKXyBtlH9TCBFv3Im0C9C9yd5uWmFIHoLdJbjT2wJh15LBT4nCTCMpch3PSEVx2yvkIvkeaP/ifwRaCvWWH18FbNjLg3anfjJwFK2nUqyV7C2KTiHn4veH/pTbhCvuAOpdr/Bh1hUVGBqcz59UIUBBPseiIrBvlxmhoO+73xY0wbW2vXBXPPTIpJxAPThUaEDEbZ02aQG3cchCEeWoTCK+MT98KRSvlXnxu0qGzQwpR1A3w7gjEp4Jo/EDjzDsCBem8gbg/pP+GZ8BhDVFVwm+YHyJ6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add struct cpu_preserved_as and cpu_preserved_as_create/map/adopt/destroy
interfaces to manage isolated page tables for preserved physical CPUs.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/cpu_preserve.h     |  65 +++
 include/linux/kho/abi/cpu.h      |  38 ++
 kernel/liveupdate/cpu_preserve.c | 958 +++++++++++++++++++++++++++++++
 3 files changed, 1061 insertions(+)

diff --git a/include/linux/cpu_preserve.h b/include/linux/cpu_preserve.h
index 94181952df1a..472fcf3933a2 100644
--- a/include/linux/cpu_preserve.h
+++ b/include/linux/cpu_preserve.h
@@ -269,6 +269,71 @@ void cpu_preserved_as_destroy(struct cpu_preserved_as *as);
 struct cpu_preserved_as *cpu_preserved_as_adopt(struct cpu_preserved_as_ser *ser);
 int cpu_preserved_as_map(struct cpu_preserved_as *as, phys_addr_t pa,
 			 unsigned long va, size_t size, pgprot_t prot);
+void *cpu_preserved_as_alloc_page(void *arg);
+
+/**
+ * arch_cpu_preserved_as_map - Add one range to a preserved address space
+ * @as: Address space to map into; @as->pgd is the root to populate.
+ * @pa: Physical address of the range.
+ * @va: Virtual address the range must appear at.
+ * @size: Size of the range in bytes.
+ * @prot: Protection to apply.
+ *
+ * Architecture backend for cpu_preserved_as_map().  Page table pages must be
+ * obtained from cpu_preserved_as_alloc_page() with @as as its argument, so
+ * that the core layer can preserve and later free them; the caller holds the
+ * mapping lock and takes care of cache maintenance and of the TLB.
+ *
+ * Return: 0 on success, or a negative errno on failure.
+ */
+int arch_cpu_preserved_as_map(struct cpu_preserved_as *as, phys_addr_t pa,
+			      unsigned long va, size_t size, pgprot_t prot);
+
+/**
+ * arch_cpu_preserved_as_flush_tlb - Publish preserved page table updates
+ *
+ * Called after every successful arch_cpu_preserved_as_map().  Architectures
+ * whose preserved CPUs can hold stale translations for these address spaces
+ * must invalidate them here; the others need do nothing.
+ */
+void arch_cpu_preserved_as_flush_tlb(void);
+
+/**
+ * arch_cpu_preserved_set_transition_as - Publish the default address space
+ * @as: Address space a preserved CPU parks in when its workload has none.
+ *
+ * The value has to be readable from preserved text after the kexec, which is
+ * architecture specific storage, so the core layer hands it over rather than
+ * exporting a variable.
+ */
+void arch_cpu_preserved_set_transition_as(struct cpu_preserved_as *as);
+
+int cpu_preserved_map_range(phys_addr_t pa, unsigned long va,
+			    size_t size, pgprot_t prot);
+int cpu_preserved_map_buffer(void *va, size_t size);
+
+/**
+ * arch_cpu_preserved_mpidr_to_cpu - Map an ARM64 MPIDR affinity value to a logical CPU ID
+ * @mpidr: Hardware MPIDR affinity value.
+ *
+ * Return: Logical CPU identifier, or -EINVAL if not found.
+ */
+int arch_cpu_preserved_mpidr_to_cpu(u64 mpidr);
+
+/**
+ * arch_cpu_preserved_is_active - Check whether any preserved CPU runtime mapping is active
+ *
+ * Return: %true if preserved runtime mappings are active, %false otherwise.
+ */
+bool arch_cpu_preserved_is_active(void);
+
+/**
+ * arch_cpu_preserved_switch_pgd - Switch the current preserved CPU to an isolated PGD
+ * @pgd_pa: Physical address of the root page table to install.
+ *
+ * This function must be placed in the __cpu_preserved_text section.
+ */
+void arch_cpu_preserved_switch_pgd(phys_addr_t pgd_pa);
 
 #else /* !CONFIG_LIVEUPDATE_CPU */
 
diff --git a/include/linux/kho/abi/cpu.h b/include/linux/kho/abi/cpu.h
index 5926be37f7a0..f75bfb4c6161 100644
--- a/include/linux/kho/abi/cpu.h
+++ b/include/linux/kho/abi/cpu.h
@@ -96,6 +96,44 @@ static_assert(offsetof(struct cpu_preserved_global_ser,
 		       cpu_preserved_bitmap) % sizeof(u64) == 0,
 	      "cpu_preserved_bitmap must be 64-bit aligned");
 
+#define CPU_PRESERVED_AS_MAX_PGTABLE_PAGES	1024
+
+/**
+ * struct cpu_preserved_as_ser - Serialized preserved address space metadata
+ * @nr_pgtable_pages: Number of valid entries in @pgtable_pages.
+ * @reserved:         Must be zero.
+ * @pgtable_pages:    Physical addresses of all page table pages (root PGD is at index 0).
+ */
+struct cpu_preserved_as_ser {
+	u32 nr_pgtable_pages;
+	u32 reserved;
+	u64 pgtable_pages[CPU_PRESERVED_AS_MAX_PGTABLE_PAGES];
+} __packed;
+
+static_assert(offsetof(struct cpu_preserved_as_ser, pgtable_pages) == 8);
+
+/**
+ * struct oncore_session_ser - Serialized on-core session metadata
+ * @session_name:  LUO session name.
+ * @sess_pa:       Opaque physical address of preserved struct oncore_session
+ *                 (retained for freeing across kexec, never dereferenced).
+ * @as:            Preservation pointer to struct cpu_preserved_as_ser.
+ * @nr_cpu_words:  Number of 64-bit words in @cpus_bitmap.
+ * @reserved:      Must be zero.
+ * @cpus_bitmap:   Bitmap of physical CPUs assigned to this on-core session.
+ */
+struct oncore_session_ser {
+	char session_name[LIVEUPDATE_SESSION_NAME_LENGTH];
+	u64 sess_pa;
+	DECLARE_KHOSER_PTR(as, struct cpu_preserved_as_ser *);
+	u32 nr_cpu_words;
+	u32 reserved;
+	u64 cpus_bitmap[];
+} __packed;
+
+static_assert(offsetof(struct oncore_session_ser, cpus_bitmap) % sizeof(u64) == 0,
+	      "cpus_bitmap must be 64-bit aligned");
+
 /**
  * struct cpu_preserved_file_ser - Per-file serialized state for preserved CPU fd
  * @cpu:      Logical CPU identifier.
diff --git a/kernel/liveupdate/cpu_preserve.c b/kernel/liveupdate/cpu_preserve.c
index cc27d1624d29..2f92dfee82b1 100644
--- a/kernel/liveupdate/cpu_preserve.c
+++ b/kernel/liveupdate/cpu_preserve.c
@@ -267,6 +267,8 @@ static void cpu_preserved_sync_global_ser(void)
 			(1UL << cpu_preserved_data_order) * PAGE_SIZE;
 	}
 	KHOSER_STORE_PTR(ser->pcpus_runtime, cpu_preserved_outgoing.pcpus_ser);
+	KHOSER_STORE_PTR(ser->transition_as,
+			 cpu_preserved_transition_as ? cpu_preserved_transition_as->ser : NULL);
 	cpu_preserved_clean_sz(ser,
 			       struct_size(ser, cpu_preserved_bitmap, ser->nr_cpu_words));
 }
@@ -282,6 +284,857 @@ static void cpu_preserved_free_kho(void *va, bool is_incoming)
 		kho_unpreserve_free(va);
 }
 
+/**
+ * cpu_preserved_as_alloc_page - Allocate a page table page for @arg
+ * @arg: The struct cpu_preserved_as being populated.
+ *
+ * Page table allocator handed to the architecture page table builders.
+ *
+ * There is deliberately no alloc_page() fallback.  It would be
+ * kho_alloc_preserve() open-coded, and the only way it could differ is by
+ * ignoring the preservation error -- which would hand back an unpreserved
+ * page table page.  The orphaned core has no fault handler, so that failure
+ * is unrecoverable and must not be silent.
+ *
+ * Return: A zeroed, preserved page, or NULL.
+ */
+void *cpu_preserved_as_alloc_page(void *arg)
+{
+	struct cpu_preserved_as *as = arg;
+	void *ptr;
+
+	if (WARN_ON_ONCE(as->ser->nr_pgtable_pages >= ARRAY_SIZE(as->ser->pgtable_pages)))
+		return NULL;
+
+	ptr = kho_alloc_preserve(PAGE_SIZE);
+	if (IS_ERR_OR_NULL(ptr))
+		return NULL;
+
+	cpu_preserved_clean_sz(ptr, PAGE_SIZE);
+	as->ser->pgtable_pages[as->ser->nr_pgtable_pages++] = virt_to_phys(ptr);
+
+	return ptr;
+}
+EXPORT_SYMBOL_GPL(cpu_preserved_as_alloc_page);
+
+/*
+ * Page table pages are preserved as they are allocated, but a cancelled live
+ * update unpreserves everything, so state the preservation again after every
+ * change.  Pages inherited from the previous kernel already belong to KHO.
+ */
+static int cpu_preserved_as_preserve_pgtables(struct cpu_preserved_as *as)
+{
+	unsigned int i;
+
+	if (as->is_incoming)
+		return 0;
+
+	for (i = 0; i < as->ser->nr_pgtable_pages; i++) {
+		void *p = phys_to_virt(as->ser->pgtable_pages[i]);
+		int ret;
+
+		cpu_preserved_clean_sz(p, PAGE_SIZE);
+		ret = kho_preserve_pages(virt_to_page(p), 1);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static void cpu_preserved_as_unpreserve_pgtables(struct cpu_preserved_as *as)
+{
+	for (unsigned int i = 0; i < as->ser->nr_pgtable_pages; i++)
+		kho_unpreserve_pages(virt_to_page(phys_to_virt(as->ser->pgtable_pages[i])), 1);
+}
+
+/**
+ * cpu_preserved_as_map - Map one range into one preserved address space
+ * @as: Address space to map into.
+ * @pa: Physical address of the range.
+ * @va: Virtual address the range must appear at.
+ * @size: Size of the range in bytes.
+ * @prot: Protection to apply.
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int cpu_preserved_as_map(struct cpu_preserved_as *as, phys_addr_t pa,
+			 unsigned long va, size_t size, pgprot_t prot)
+{
+	int ret;
+
+	guard(mutex)(&cpu_preserved_as_map_lock);
+
+	ret = arch_cpu_preserved_as_map(as, pa, va, size, prot);
+	if (ret)
+		return ret;
+
+	ret = cpu_preserved_as_preserve_pgtables(as);
+	if (ret)
+		return ret;
+
+	arch_cpu_preserved_as_flush_tlb();
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cpu_preserved_as_map);
+
+static int cpu_preserved_init_runtime_buffer(void);
+
+static int cpu_preserved_as_map_buf(struct cpu_preserved_as *as,
+				    void *va, size_t size)
+{
+	if (!va || !size)
+		return 0;
+
+	return cpu_preserved_as_map(as, virt_to_phys(va), (unsigned long)va,
+				    size, PAGE_KERNEL);
+}
+
+static int cpu_preserved_as_map_runtime(struct cpu_preserved_as *as)
+{
+	unsigned long text_start = (unsigned long)__cpu_preserved_text_start;
+	unsigned long data_start = (unsigned long)__cpu_preserved_data_start;
+	size_t text_sz = (unsigned long)__cpu_preserved_text_end - text_start;
+	size_t data_sz = (unsigned long)__cpu_preserved_data_end - data_start;
+	struct cpu_preserved_state *outgoing = &cpu_preserved_outgoing;
+	int cpu, ret;
+
+	ret = cpu_preserved_as_map(as, cpu_preserved_get_text_pa(),
+				   text_start, text_sz, PAGE_KERNEL_ROX);
+	if (ret)
+		return ret;
+
+	ret = cpu_preserved_as_map(as, cpu_preserved_get_data_pa(),
+				   data_start, data_sz, PAGE_KERNEL);
+	if (ret)
+		return ret;
+
+	ret = cpu_preserved_as_map_buf(as, outgoing->pcpus_ser,
+				       sizeof(*outgoing->pcpus_ser) * nr_cpu_ids);
+	if (ret)
+		return ret;
+
+	ret = cpu_preserved_as_map_buf(as, outgoing->pcpus,
+				       sizeof(*outgoing->pcpus) * nr_cpu_ids);
+	if (ret)
+		return ret;
+
+	for_each_cpu(cpu, &outgoing->mask) {
+		phys_addr_t spa = outgoing->pcpus[cpu].stack_pa;
+
+		if (!spa)
+			continue;
+		ret = cpu_preserved_as_map_buf(as, phys_to_virt(spa),
+					       CPU_PRESERVED_STACK_SIZE);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+/**
+ * cpu_preserved_as_create - Build a new preserved address space
+ *
+ * Allocates a root page table, maps the preserved text and data into it, and
+ * publishes it so that subsequent cpu_preserved_map_range() calls reach it.
+ *
+ * Return: The new address space, or an ERR_PTR() on failure.
+ */
+struct cpu_preserved_as *cpu_preserved_as_create(void)
+{
+	struct cpu_preserved_as *as;
+	int ret;
+
+	ret = cpu_preserved_init_runtime_buffer();
+	if (ret)
+		return ERR_PTR(ret);
+
+	as = kzalloc_obj(*as, GFP_KERNEL);
+	if (!as)
+		return ERR_PTR(-ENOMEM);
+	INIT_LIST_HEAD(&as->node);
+
+	as->ser = kho_alloc_preserve(sizeof(*as->ser));
+	if (IS_ERR(as->ser)) {
+		ret = PTR_ERR(as->ser);
+		kfree(as);
+		return ERR_PTR(ret);
+	}
+	memset(as->ser, 0, sizeof(*as->ser));
+
+	as->pgd = cpu_preserved_as_alloc_page(as);
+	if (!as->pgd) {
+		ret = -ENOMEM;
+		goto err;
+	}
+	as->pgd_pa = virt_to_phys(as->pgd);
+
+	ret = cpu_preserved_as_map_runtime(as);
+	if (ret)
+		goto err;
+
+	scoped_guard(mutex, &cpu_preserved_as_list_lock)
+		list_add_tail(&as->node, &cpu_preserved_as_list);
+
+	return as;
+
+err:
+	cpu_preserved_as_destroy(as);
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_GPL(cpu_preserved_as_create);
+
+/**
+ * cpu_preserved_as_destroy - Tear down a preserved address space
+ * @as: Address space to release.  NULL is accepted and does nothing.
+ */
+void cpu_preserved_as_destroy(struct cpu_preserved_as *as)
+{
+	if (!as)
+		return;
+
+	scoped_guard(mutex, &cpu_preserved_as_list_lock)
+		list_del_init(&as->node);
+
+	if (as->ser) {
+		scoped_guard(mutex, &cpu_preserved_as_map_lock) {
+			for (unsigned int i = 0; i < as->ser->nr_pgtable_pages; i++) {
+				void *va = phys_to_virt(as->ser->pgtable_pages[i]);
+
+				cpu_preserved_free_kho(va, as->is_incoming);
+			}
+		}
+		cpu_preserved_free_kho(as->ser, as->is_incoming);
+	}
+
+	kfree(as);
+}
+EXPORT_SYMBOL_GPL(cpu_preserved_as_destroy);
+
+/**
+ * cpu_preserved_as_adopt - Take over an address space from the previous kernel
+ * @ser: Address space serialization descriptor recovered from preserved memory.
+ *
+ * The page tables are left exactly as the outgoing kernel built them --
+ * preserved CPUs are running out of them right now -- but the list linkage is
+ * stale and has to be rebuilt, and the pages now belong to KHO rather than to
+ * this kernel's allocator.
+ */
+struct cpu_preserved_as *cpu_preserved_as_adopt(struct cpu_preserved_as_ser *ser)
+{
+	struct cpu_preserved_as *as;
+
+	if (!ser)
+		return NULL;
+
+	as = kzalloc_obj(*as, GFP_KERNEL);
+	if (!as)
+		return NULL;
+
+	as->ser = ser;
+	as->pgd_pa = ser->nr_pgtable_pages ? ser->pgtable_pages[0] : 0;
+	as->pgd = phys_to_virt(as->pgd_pa);
+	as->is_incoming = true;
+	INIT_LIST_HEAD(&as->node);
+
+	guard(mutex)(&cpu_preserved_as_list_lock);
+	list_add_tail(&as->node, &cpu_preserved_as_list);
+
+	return as;
+}
+EXPORT_SYMBOL_GPL(cpu_preserved_as_adopt);
+
+static void cpu_preserved_preserve_runtime_buffer(void)
+{
+	if (cpu_preserved_runtime_preserved)
+		return;
+
+	/*
+	 * This is the text the orphaned core executes and the data it reads
+	 * after the kexec.  If either cannot be preserved there is nothing to
+	 * hand over, so do not claim the runtime is preserved.
+	 */
+	if (WARN_ON_ONCE(kho_preserve_pages(cpu_preserved_text_pages,
+					    1 << cpu_preserved_text_order)))
+		return;
+	if (WARN_ON_ONCE(kho_preserve_pages(cpu_preserved_data_pages,
+					    1 << cpu_preserved_data_order)))
+		return;
+
+	WARN_ON_ONCE(kho_preserve_pages(virt_to_page(cpu_preserved_transition_as->ser),
+					1 << get_order(sizeof(*cpu_preserved_transition_as->ser))));
+
+	scoped_guard(mutex, &cpu_preserved_as_map_lock)
+		WARN_ON_ONCE(cpu_preserved_as_preserve_pgtables(cpu_preserved_transition_as));
+
+	cpu_preserved_runtime_preserved = true;
+}
+
+static void cpu_preserved_unpreserve_runtime_buffer(void)
+{
+	if (!cpu_preserved_runtime_preserved)
+		return;
+
+	kho_unpreserve_pages(cpu_preserved_text_pages,
+			     1 << cpu_preserved_text_order);
+	kho_unpreserve_pages(cpu_preserved_data_pages,
+			     1 << cpu_preserved_data_order);
+	kho_unpreserve_pages(virt_to_page(cpu_preserved_transition_as->ser),
+			     1 << get_order(sizeof(*cpu_preserved_transition_as->ser)));
+
+	scoped_guard(mutex, &cpu_preserved_as_map_lock)
+		cpu_preserved_as_unpreserve_pgtables(cpu_preserved_transition_as);
+
+	cpu_preserved_runtime_preserved = false;
+}
+
+/**
+ * cpu_preserved_init_runtime_buffer - Allocate execution buffer outside Scratch
+ *
+ * The compiled __cpu_preserved_text and __cpu_preserved_data sections are
+ * part of the host kernel binary image. During a host kexec live update, the
+ * memory range occupied by the current kernel is designated as KHO Scratch
+ * memory to allow the incoming kernel to be placed and unpacked. By definition,
+ * Scratch memory must not contain preserved memory, as the incoming kernel
+ * will overwrite Scratch during boot.
+ *
+ * Preserving the compiled text and data sections in-place would create a
+ * conflict where preserved memory overlaps Scratch, triggering handover
+ * failures or memory corruption when the incoming kernel overwrites the old
+ * kernel text while preserved physical CPUs are still executing Caretaker loops
+ * on their cores.
+ *
+ * To avoid this, we dynamically allocate dedicated text and data buffer pages
+ * from free memory (outside Scratch) via alloc_pages(GFP_KERNEL), copy the
+ * compiled text and data into them, remap the virtual addresses in the page
+ * tables to point to these newly allocated pages, and preserve only these
+ * external pages with KHO. Preserved CPUs execute out of these external pages,
+ * allowing the incoming kernel to freely overwrite Scratch.
+ *
+ * Return: 0 on success, or negative error code on allocation/setup failure.
+ */
+static int cpu_preserved_init_runtime_buffer(void)
+{
+	size_t text_size = (unsigned long)__cpu_preserved_text_end -
+			   (unsigned long)__cpu_preserved_text_start;
+	size_t data_size = (unsigned long)__cpu_preserved_data_end -
+			   (unsigned long)__cpu_preserved_data_start;
+	unsigned int text_nr_pages = DIV_ROUND_UP(text_size, PAGE_SIZE);
+	unsigned int data_nr_pages = DIV_ROUND_UP(data_size, PAGE_SIZE);
+	int ret;
+
+	if (cpu_preserved_text_pages) {
+		if (cpu_preserved_transition_as)
+			cpu_preserved_preserve_runtime_buffer();
+		return 0;
+	}
+
+	cpu_preserved_text_order = get_order(text_size);
+	cpu_preserved_text_pages = alloc_pages(GFP_KERNEL, cpu_preserved_text_order);
+	if (!cpu_preserved_text_pages)
+		return -ENOMEM;
+
+	cpu_preserved_data_order = get_order(data_size);
+	cpu_preserved_data_pages = alloc_pages(GFP_KERNEL, cpu_preserved_data_order);
+	if (!cpu_preserved_data_pages) {
+		__free_pages(cpu_preserved_text_pages, cpu_preserved_text_order);
+		cpu_preserved_text_pages = NULL;
+		return -ENOMEM;
+	}
+
+	memcpy(page_address(cpu_preserved_text_pages),
+	       __cpu_preserved_text_start, text_size);
+	memcpy(page_address(cpu_preserved_data_pages),
+	       __cpu_preserved_data_start, data_size);
+
+	ret = arch_cpu_preserved_setup_buffer(cpu_preserved_text_pages,
+					      text_nr_pages,
+					      cpu_preserved_data_pages,
+					      data_nr_pages);
+	if (ret)
+		goto err_free;
+
+	/*
+	 * The address space a preserved CPU parks in when its workload has not
+	 * given it one of its own.  It has to exist before anything can be
+	 * mapped for preserved CPUs, so build it here and let the architecture
+	 * record it where preserved text can reach it after the kexec.
+	 */
+	cpu_preserved_transition_as = cpu_preserved_as_create();
+	if (IS_ERR(cpu_preserved_transition_as)) {
+		ret = PTR_ERR(cpu_preserved_transition_as);
+		cpu_preserved_transition_as = NULL;
+		goto err_free;
+	}
+	arch_cpu_preserved_set_transition_as(cpu_preserved_transition_as);
+
+	cpu_preserved_preserve_runtime_buffer();
+	return 0;
+
+err_free:
+	__free_pages(cpu_preserved_data_pages, cpu_preserved_data_order);
+	__free_pages(cpu_preserved_text_pages, cpu_preserved_text_order);
+	cpu_preserved_data_pages = NULL;
+	cpu_preserved_text_pages = NULL;
+	return ret;
+}
+
+/**
+ * cpu_preserved_map_range - Map a physical range into every preserved address space
+ * @pa: Physical address
+ * @va: Virtual address
+ * @size: Size in bytes
+ * @prot: Page protection flags
+ *
+ * Anything a preserved CPU may touch has to be reachable from whichever
+ * address space it ends up running in, and which one that is depends on the
+ * workload, so map it into all of them.
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int cpu_preserved_map_range(phys_addr_t pa, unsigned long va,
+			    size_t size, pgprot_t prot)
+{
+	struct cpu_preserved_as *as;
+	int ret;
+
+	guard(mutex)(&cpu_preserved_as_list_lock);
+
+	list_for_each_entry(as, &cpu_preserved_as_list, node) {
+		ret = cpu_preserved_as_map(as, pa, va, size, prot);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cpu_preserved_map_range);
+
+/**
+ * cpu_preserved_map_buffer - Map a virtual buffer into transition page tables
+ * @va: Virtual address in kernel direct map
+ * @size: Size in bytes
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int cpu_preserved_map_buffer(void *va, size_t size)
+{
+	if (!va || !size)
+		return 0;
+	return cpu_preserved_map_range(virt_to_phys(va),
+				       (unsigned long)va,
+				       size, PAGE_KERNEL);
+}
+EXPORT_SYMBOL_GPL(cpu_preserved_map_buffer);
+
+/**
+ * cpu_is_preserved - Check whether a CPU is currently preserved
+ * @cpu: Logical CPU identifier.
+ *
+ * Return: True if @cpu is currently preserved, false otherwise.
+ */
+bool __cpu_preserved_text cpu_is_preserved(int cpu)
+{
+	if ((unsigned int)cpu >= CONFIG_NR_CPUS)
+		return false;
+	cpu_preserved_inval(&cpu_preserved_mask);
+	return cpumask_test_cpu(cpu, &cpu_preserved_mask);
+}
+EXPORT_SYMBOL_GPL(cpu_is_preserved);
+
+static bool cpu_preserved_is_incoming(int cpu)
+{
+	if ((unsigned int)cpu >= CONFIG_NR_CPUS)
+		return false;
+	return cpumask_test_cpu(cpu, &cpu_preserved_incoming.mask);
+}
+
+static struct cpu_preserved_pcpu_ser * __cpu_preserved_text cpu_preserved_get_pcpu_ser(int cpu)
+{
+	struct cpu_preserved_pcpu_ser *pcpus;
+
+	if ((unsigned int)cpu >= CONFIG_NR_CPUS)
+		return NULL;
+
+	cpu_preserved_inval(&cpu_preserved_pcpus_va);
+	pcpus = READ_ONCE(cpu_preserved_pcpus_va);
+	return pcpus ? &pcpus[cpu] : NULL;
+}
+
+static struct cpu_preserved_pcpu * __cpu_preserved_text cpu_preserved_get_pcpu(int cpu)
+{
+	struct cpu_preserved_pcpu *pcpus;
+
+	if ((unsigned int)cpu >= CONFIG_NR_CPUS)
+		return NULL;
+
+	cpu_preserved_inval(&cpu_preserved_host_pcpus_va);
+	pcpus = READ_ONCE(cpu_preserved_host_pcpus_va);
+	return pcpus ? &pcpus[cpu] : NULL;
+}
+
+/*
+ * The preserved stack is handed over by physical address: the same page need
+ * not be mapped at the same virtual address by two different kernels, so each
+ * side derives its own VA rather than sharing one.
+ */
+static void * __cpu_preserved_text
+cpu_preserved_stack_va(int cpu)
+{
+	struct cpu_preserved_pcpu *pcpu = cpu_preserved_get_pcpu(cpu);
+	phys_addr_t pa;
+
+	if (!pcpu)
+		return NULL;
+
+	cpu_preserved_inval(&pcpu->stack_pa);
+	pa = READ_ONCE(pcpu->stack_pa);
+	if (!pa)
+		return NULL;
+
+	return phys_to_virt(pa);
+}
+
+/**
+ * cpu_preserved_get_pgd - Get root page table physical address for a preserved CPU
+ * @cpu: Logical CPU identifier.
+ *
+ * Return: Root PGD physical address assigned to @cpu, or 0 if not set.
+ */
+phys_addr_t __cpu_preserved_text cpu_preserved_get_pgd(int cpu)
+{
+	struct cpu_preserved_pcpu *pcpu = cpu_preserved_get_pcpu(cpu);
+
+	if (!pcpu)
+		return 0;
+
+	cpu_preserved_inval(&pcpu->pgd_pa);
+	return READ_ONCE(pcpu->pgd_pa);
+}
+EXPORT_SYMBOL_GPL(cpu_preserved_get_pgd);
+
+/**
+ * cpu_get_preserved_mask - Get the mask of all currently preserved CPUs
+ *
+ * Return: Read-only pointer to the cpumask of preserved CPUs.
+ */
+const struct cpumask *cpu_get_preserved_mask(void)
+{
+	return &cpu_preserved_mask;
+}
+EXPORT_SYMBOL_GPL(cpu_get_preserved_mask);
+
+/**
+ * cpu_preserved_set_dead - Mark a preserved CPU as fully dead/stopped
+ * @cpu: Logical CPU identifier.
+ *
+ * Publishes %CPU_PRESERVED_DEAD in the KHO-preserved per-CPU state block when
+ * @cpu finishes exiting the preserved parking loop.
+ */
+void __cpu_preserved_text cpu_preserved_set_dead(int cpu)
+{
+	struct cpu_preserved_pcpu_ser *ser = cpu_preserved_get_pcpu_ser(cpu);
+
+	if (ser)
+		WRITE_ONCE(ser->workload, CPU_PRESERVED_DEAD);
+}
+EXPORT_SYMBOL_GPL(cpu_preserved_set_dead);
+
+static void cpu_signal_exit(int cpu)
+{
+	struct cpu_preserved_pcpu_ser *ser = cpu_preserved_get_pcpu_ser(cpu);
+	struct cpu_preserved_pcpu *pcpu = cpu_preserved_get_pcpu(cpu);
+
+	if (ser) {
+		WRITE_ONCE(ser->workload, CPU_PRESERVED_EXITING);
+		cpu_preserved_clean(ser);
+	}
+	if (pcpu) {
+		WRITE_ONCE(pcpu->entry_fn, NULL);
+		WRITE_ONCE(pcpu->entry_data, NULL);
+		cpu_preserved_clean(pcpu);
+	}
+}
+
+/**
+ * cpu_preserved_should_exit - Check if a running preserved workload should exit
+ * @cpu: Logical CPU identifier.
+ *
+ * Polled by workloads executing on preserved physical CPUs to detect when the
+ * host kernel has requested workload detachment or CPU reclamation.
+ *
+ * Return: %true if the workload on @cpu must exit back to the park loop,
+ *         %false otherwise.
+ */
+bool __cpu_preserved_text cpu_preserved_should_exit(int cpu)
+{
+	struct cpu_preserved_pcpu_ser *ser = cpu_preserved_get_pcpu_ser(cpu);
+
+	if (!ser)
+		return false;
+
+	cpu_preserved_inval(ser);
+	return READ_ONCE(ser->workload) != CPU_PRESERVED_WORKLOAD;
+}
+EXPORT_SYMBOL_GPL(cpu_preserved_should_exit);
+
+/**
+ * cpu_preserved_attach_workload - Attach & start workload execution on core
+ * @cpu: Logical CPU identifier.
+ * @entry_fn: Workload callback to execute repeatedly on the physical core.
+ * @data: Opaque argument passed to @entry_fn.
+ *
+ * Transitions @cpu from idle parking to executing @entry_fn(@data) on the
+ * physical core, and kicks the CPU to begin execution immediately.
+ *
+ * Return: 0 on success, -EINVAL if @cpu is invalid, -ENODEV if not preserved,
+ * or -EBUSY if a workload is already attached.
+ */
+int cpu_preserved_attach_workload(int cpu,
+				  void (*entry_fn)(void *data), void *data)
+{
+	struct cpu_preserved_pcpu_ser *ser;
+	struct cpu_preserved_pcpu *pcpu;
+
+	if ((unsigned int)cpu >= nr_cpu_ids)
+		return -EINVAL;
+
+	mutex_lock(&cpu_preserved_lock);
+	if (!cpumask_test_cpu(cpu, &cpu_preserved_outgoing.mask)) {
+		mutex_unlock(&cpu_preserved_lock);
+		return -ENODEV;
+	}
+
+	ser = &cpu_preserved_outgoing.pcpus_ser[cpu];
+	pcpu = &cpu_preserved_outgoing.pcpus[cpu];
+	if (ser->workload != CPU_PRESERVED_PARKED || pcpu->entry_fn) {
+		mutex_unlock(&cpu_preserved_lock);
+		return -EBUSY;
+	}
+
+	WRITE_ONCE(pcpu->entry_data, data);
+	WRITE_ONCE(pcpu->entry_fn, entry_fn);
+	WRITE_ONCE(ser->workload, CPU_PRESERVED_WORKLOAD);
+
+	cpu_preserved_clean(pcpu);
+	cpu_preserved_clean(ser);
+
+	arch_cpu_preserved_kick(cpu);
+	mutex_unlock(&cpu_preserved_lock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cpu_preserved_attach_workload);
+
+/**
+ * cpu_preserved_detach_workload - Detach workload and return core to idle park
+ * @cpu: Logical CPU identifier.
+ *
+ * Clears any attached workload on @cpu, returning the core to the default
+ * idle parking loop.
+ *
+ * Return: 0 on success, -EINVAL if @cpu is invalid, or -ENODEV if
+ * not preserved.
+ */
+int cpu_preserved_detach_workload(int cpu)
+{
+	struct cpu_preserved_pcpu_ser *ser;
+	struct cpu_preserved_pcpu *pcpu;
+
+	if ((unsigned int)cpu >= nr_cpu_ids)
+		return -EINVAL;
+
+	mutex_lock(&cpu_preserved_lock);
+	if (!cpumask_test_cpu(cpu, &cpu_preserved_mask)) {
+		mutex_unlock(&cpu_preserved_lock);
+		return -ENODEV;
+	}
+
+	ser = cpu_preserved_get_pcpu_ser(cpu);
+	pcpu = cpu_preserved_get_pcpu(cpu);
+	if (!ser) {
+		mutex_unlock(&cpu_preserved_lock);
+		return -ENODEV;
+	}
+
+	if (READ_ONCE(ser->workload) == CPU_PRESERVED_WORKLOAD) {
+		WRITE_ONCE(ser->workload, CPU_PRESERVED_PARKED);
+		cpu_preserved_clean(ser);
+	}
+	if (pcpu) {
+		WRITE_ONCE(pcpu->entry_fn, NULL);
+		WRITE_ONCE(pcpu->entry_data, NULL);
+		cpu_preserved_clean(pcpu);
+	}
+
+	arch_cpu_preserved_kick(cpu);
+	mutex_unlock(&cpu_preserved_lock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cpu_preserved_detach_workload);
+
+/**
+ * cpu_preserved_set_workload_context - Set workload context and root page table
+ * @cpu: Logical CPU identifier.
+ * @ctx: Opaque owning workload context pointer.
+ * @pgd_pa: Physical address of workload root page table (or 0 for default).
+ */
+void cpu_preserved_set_workload_context(int cpu, void *ctx, phys_addr_t pgd_pa)
+{
+	struct cpu_preserved_stack_context *sctx;
+	struct cpu_preserved_pcpu *pcpu;
+
+	if (cpu < 0 || cpu >= nr_cpu_ids)
+		return;
+
+	mutex_lock(&cpu_preserved_lock);
+	pcpu = cpu_preserved_get_pcpu(cpu);
+	sctx = cpu_preserved_stack_va(cpu);
+	/*
+	 * Validate the signature before writing through it.  The read side
+	 * (cpu_preserved_get_stack_context()) has always done this; this path
+	 * did not, so a stale or not-yet-initialised stack_pa would have been
+	 * scribbled over.
+	 */
+	if (sctx && sctx->magic == CPU_PRESERVED_STACK_MAGIC) {
+		sctx->workload_context = (u64)(uintptr_t)ctx;
+		sctx->session_pgd_pa = pgd_pa;
+		pcpu->pgd_pa = pgd_pa;
+	}
+	mutex_unlock(&cpu_preserved_lock);
+}
+EXPORT_SYMBOL_GPL(cpu_preserved_set_workload_context);
+
+#define CPU_WAIT_DEAD_TIMEOUT_US	20000000
+#define CPU_WAIT_DEAD_STEP_US		100
+#define CPU_WAIT_DEAD_KICK_STEPS	50
+
+/**
+ * cpu_wait_dead - Wait for a preserved CPU to exit the park loop and power down
+ * @cpu: Logical CPU identifier.
+ *
+ * Polls the KHO-preserved per-CPU state block until @cpu observes
+ * %CPU_PRESERVED_EXITING, leaves cpu_preserved_park_loop(), and publishes
+ * %CPU_PRESERVED_DEAD, periodically sending an IPI kick to wake it from any
+ * low-power wait state.  Once %CPU_PRESERVED_DEAD is observed, invokes
+ * arch_cpu_preserved_wait_dead() to wait for final hardware teardown.
+ *
+ * Return: 0 on success, -ENODEV if @cpu has no preserved state block, or
+ *         -ETIMEDOUT if @cpu did not reach %CPU_PRESERVED_DEAD within
+ *         %CPU_WAIT_DEAD_TIMEOUT_US microseconds.
+ */
+static int cpu_wait_dead(int cpu)
+{
+	struct cpu_preserved_pcpu_ser *ser = cpu_preserved_get_pcpu_ser(cpu);
+	int i;
+
+	if (!ser)
+		return -ENODEV;
+
+	for (i = 0; i < CPU_WAIT_DEAD_TIMEOUT_US / CPU_WAIT_DEAD_STEP_US; i++) {
+		cpu_preserved_inval(ser);
+		if (READ_ONCE(ser->workload) == CPU_PRESERVED_DEAD) {
+			arch_cpu_preserved_wait_dead(cpu);
+			return 0;
+		}
+		if (i % CPU_WAIT_DEAD_KICK_STEPS == 0)
+			arch_cpu_preserved_kick(cpu);
+		udelay(CPU_WAIT_DEAD_STEP_US);
+	}
+
+	pr_err("Timed out waiting for preserved cpu %d to stop (workload=%u)\n",
+	       cpu, READ_ONCE(ser->workload));
+	return -ETIMEDOUT;
+}
+
+static void __cpu_preserved_text
+cpu_preserved_run_workload(struct cpu_preserved_pcpu_ser *ser,
+			   struct cpu_preserved_pcpu *pcpu)
+{
+	void (*fn)(void *data);
+	void *arg;
+
+	if (!pcpu)
+		return;
+
+	cpu_preserved_inval(pcpu);
+	fn = READ_ONCE(pcpu->entry_fn);
+	arg = READ_ONCE(pcpu->entry_data);
+	if (fn)
+		fn(arg);
+
+	cpu_preserved_inval(ser);
+	if (cmpxchg(&ser->workload, CPU_PRESERVED_WORKLOAD,
+		    CPU_PRESERVED_PARKED) == CPU_PRESERVED_WORKLOAD)
+		cpu_preserved_clean(ser);
+}
+STACK_FRAME_NON_STANDARD(cpu_preserved_run_workload);
+
+/**
+ * cpu_preserved_park_loop - Generic execution loop for a parked preserved CPU
+ * @cpu: Logical CPU identifier.
+ *
+ * Core execution loop executed on the dedicated preserved stack in
+ * __cpu_preserved_text.  Waits in low-power park state, dispatches attached
+ * workload callbacks, and exits when the CPU is unpreserved and reclaimed.
+ */
+void __cpu_preserved_text cpu_preserved_park_loop(int cpu)
+{
+	struct cpu_preserved_pcpu_ser *ser = cpu_preserved_get_pcpu_ser(cpu);
+	struct cpu_preserved_pcpu *pcpu = cpu_preserved_get_pcpu(cpu);
+
+	if (!ser)
+		return;
+
+	WRITE_ONCE(ser->workload, CPU_PRESERVED_PARKED);
+	cpu_preserved_clean(ser);
+
+	arch_cpu_preserved_park_init(cpu);
+
+	for (;;) {
+		cpu_preserved_inval(ser);
+		switch (READ_ONCE(ser->workload)) {
+		case CPU_PRESERVED_EXITING:
+		case CPU_PRESERVED_DEAD:
+			WRITE_ONCE(ser->workload, CPU_PRESERVED_DEAD);
+			cpu_preserved_clean(ser);
+			return;
+		case CPU_PRESERVED_WORKLOAD:
+			cpu_preserved_run_workload(ser, pcpu);
+			break;
+		default:
+			arch_cpu_preserved_park_wait();
+			break;
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(cpu_preserved_park_loop);
+STACK_FRAME_NON_STANDARD(cpu_preserved_park_loop);
+
+/**
+ * cpu_preserved_park - Main execution and parking loop for a preserved CPU
+ * @cpu: Logical CPU identifier of the calling core.
+ *
+ * Called on the physical CPU being offlined/preserved. Enters a dedicated
+ * low-power parking loop in preserved memory, repeatedly executing any
+ * attached workload callback, until signaled to exit upon unpreservation.
+ */
+void cpu_preserved_park(int cpu)
+{
+	void *stack = cpu_preserved_stack_va(cpu);
+
+	if (stack) {
+		unsigned long top_of_stack = (unsigned long)stack +
+			CPU_PRESERVED_STACK_SIZE - CPU_PRESERVED_STACK_HEADROOM;
+		arch_cpu_preserved_park_on_stack(cpu, top_of_stack);
+	} else {
+		cpu_preserved_park_loop(cpu);
+		arch_cpu_preserved_park_finish(cpu);
+	}
+}
+EXPORT_SYMBOL_GPL(cpu_preserved_park);
+
 static void cpu_preserved_free_stack(phys_addr_t stack_pa, bool is_incoming)
 {
 	if (stack_pa)
@@ -346,6 +1199,106 @@ static void __cpu_unpreserve_locked(unsigned int cpu)
 	cpu_preserved_sync_global_ser();
 }
 
+static int cpu_preserved_init_outgoing(void)
+{
+	struct cpu_preserved_state *outgoing = &cpu_preserved_outgoing;
+	size_t ser_sz = sizeof(*outgoing->pcpus_ser) * nr_cpu_ids;
+	int ret;
+
+	if (outgoing->pcpus_ser)
+		return 0;
+
+	ret = cpu_preserved_init_runtime_buffer();
+	if (ret)
+		return ret;
+
+	outgoing->pcpus = kcalloc(nr_cpu_ids, sizeof(*outgoing->pcpus),
+				  GFP_KERNEL);
+	if (!outgoing->pcpus)
+		return -ENOMEM;
+
+	outgoing->pcpus_ser = kho_alloc_preserve(ser_sz);
+	if (IS_ERR(outgoing->pcpus_ser)) {
+		ret = PTR_ERR(outgoing->pcpus_ser);
+		kfree(outgoing->pcpus);
+		outgoing->pcpus = NULL;
+		outgoing->pcpus_ser = NULL;
+		return ret;
+	}
+	memset(outgoing->pcpus_ser, 0, ser_sz);
+
+	WRITE_ONCE(cpu_preserved_pcpus_va, outgoing->pcpus_ser);
+	WRITE_ONCE(cpu_preserved_host_pcpus_va, outgoing->pcpus);
+
+	cpu_preserved_map_buffer(outgoing->pcpus_ser, ser_sz);
+	cpu_preserved_map_buffer(outgoing->pcpus,
+				 sizeof(*outgoing->pcpus) * nr_cpu_ids);
+
+	cpu_preserved_clean(&cpu_preserved_pcpus_va);
+	cpu_preserved_clean(&cpu_preserved_host_pcpus_va);
+
+	return 0;
+}
+
+static int cpu_preserve(unsigned int cpu)
+{
+	struct cpu_preserved_state *outgoing = &cpu_preserved_outgoing;
+	struct cpu_preserved_stack_context *sctx;
+	struct cpu_preserved_pcpu_ser *ser;
+	struct cpu_preserved_pcpu *pcpu;
+	void *stack;
+	int ret;
+
+	stack = kho_alloc_preserve(CPU_PRESERVED_STACK_SIZE);
+	if (IS_ERR(stack))
+		return PTR_ERR(stack);
+
+	sctx = stack;
+	sctx->magic = CPU_PRESERVED_STACK_MAGIC;
+	sctx->cpu = cpu;
+
+	scoped_guard(mutex, &cpu_preserved_lock) {
+		if (cpu_is_preserved(cpu)) {
+			kho_unpreserve_free(stack);
+			return -EBUSY;
+		}
+
+		ret = cpu_preserved_init_outgoing();
+		if (ret) {
+			kho_unpreserve_free(stack);
+			return ret;
+		}
+
+		cpumask_set_cpu(cpu, &outgoing->mask);
+		cpumask_set_cpu(cpu, &cpu_preserved_mask);
+		cpu_preserved_clean(&cpu_preserved_mask);
+
+		ser = &outgoing->pcpus_ser[cpu];
+		pcpu = &outgoing->pcpus[cpu];
+		WRITE_ONCE(ser->workload, CPU_PRESERVED_PARKED);
+		pcpu->stack_pa = virt_to_phys(stack);
+		cpu_preserved_map_buffer(stack, CPU_PRESERVED_STACK_SIZE);
+		pcpu->pgd_pa = cpu_preserved_transition_as->pgd_pa;
+		WRITE_ONCE(pcpu->entry_fn, NULL);
+		WRITE_ONCE(pcpu->entry_data, NULL);
+		cpu_preserved_sync_global_ser();
+	}
+
+	if (cpu_online(cpu)) {
+		ret = remove_cpu(cpu);
+		if (ret < 0) {
+			pr_err("Failed to offline preserved cpu %u: %d\n",
+			       cpu, ret);
+			scoped_guard(mutex, &cpu_preserved_lock)
+				__cpu_unpreserve_locked(cpu);
+			return ret;
+		}
+	}
+
+	set_cpu_present(cpu, false);
+	return 0;
+}
+
 /**
  * cpu_unpreserve - Unpreserve a physical CPU and restore it to online state
  * @cpu: Logical CPU identifier.
@@ -488,6 +1441,7 @@ static int cpu_preserved_flb_retrieve(struct liveupdate_flb_op_args *argp)
 
 static void cpu_preserved_flb_finish(struct liveupdate_flb_op_args *argp)
 {
+	struct cpu_preserved_as_ser *trans_as;
 	struct cpu_preserved_global_ser *ser;
 
 	if (!argp->obj)
@@ -495,6 +1449,10 @@ static void cpu_preserved_flb_finish(struct liveupdate_flb_op_args *argp)
 
 	ser = argp->obj;
 
+	trans_as = KHOSER_LOAD_PTR(ser->transition_as);
+	if (trans_as)
+		cpu_preserved_as_destroy(cpu_preserved_as_adopt(trans_as));
+
 	scoped_guard(mutex, &cpu_preserved_lock) {
 		if (cpu_preserved_incoming.pcpus_ser) {
 			kho_restore_free(cpu_preserved_incoming.pcpus_ser);
-- 
2.55.0.1082.g2b9226bbc0-goog


