Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 102D3CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 04:03:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B4816B00A4; Tue, 29 Sep 2026 00:03:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28B4A6B00A5; Tue, 29 Sep 2026 00:03:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 178FC6B00A6; Tue, 29 Sep 2026 00:03:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D89BD6B00A4
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 00:03:45 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 046BC1C1EC8
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:03:44 +0000 (UTC)
X-FDA: 85265456010.10.6D91777
Received: from mail-pf1-f225.google.com (mail-pf1-f225.google.com [209.85.210.225])
	by imf19.hostedemail.com (Postfix) with ESMTP id CCBBA1A0009
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:03:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=IqgEj1gj;
	spf=pass (imf19.hostedemail.com: domain of zack.rusin@broadcom.com designates 209.85.210.225 as permitted sender) smtp.mailfrom=zack.rusin@broadcom.com;
	dmarc=pass (policy=reject) header.from=broadcom.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790654622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QwnEpUDfw+7fPie+mcX7kjJEU0lPRR1jdyRNDD8g1m0=;
	b=KBntJwYnT0ecIiDXrq8+rfTvak22mEhHp/8LQ1YLG0nnMkGMte50lbfnw91GD1FJVBxxTW
	Kx1opQCjy9oniKVENGFzYvMLFbzBvklMM65w5Ela0/MKJ64jVMTtUVnglEd5UoIcVXlWM2
	cmXen8thxUcFtAwpZRv6hzz1OI+F2js=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=IqgEj1gj;
	spf=pass (imf19.hostedemail.com: domain of zack.rusin@broadcom.com designates 209.85.210.225 as permitted sender) smtp.mailfrom=zack.rusin@broadcom.com;
	dmarc=pass (policy=reject) header.from=broadcom.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790654622;
	b=W1bynd10uvgfX4P3RUVeJsFR6lJGfXRDmG0ntbdJbcs/a4Yk8fx+DARqnWpPEFXemgo78O
	dqMtChYK56lemqjQMhg0UBVI0hPjmEwnvqNqHkVtIV2XSPlCedHrE/iOxQ+jH+ZyQnWUEf
	r34AsGZjKJoAK8BQs45Hvj1UIMywuz8=
Received: by mail-pf1-f225.google.com with SMTP id d2e1a72fcca58-880d942556cso714916b3a.3
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:03:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790654622; x=1791259422;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QwnEpUDfw+7fPie+mcX7kjJEU0lPRR1jdyRNDD8g1m0=;
        b=mDcB7RMvccyeez5Nol8eNLKaQ1r4QNAPh9ejQ14+HC0p9pKsN4Ey6suG4BZKoV2+q+
         F3EJG9BtZEqRZvHV8uDSq4KmG7x08Ob8k6+H+xP6CAGqi9UV5vMxQEQ1yAmujey0UVDI
         7n1I0xjNcgV4El4q8VSoGCaivV7wfsKzKrW4MVUiN5cVDp4Ns0QLmNk3L6e1p5m2hqed
         oi7IUc1Q/ri2BcmBiuTnMYJFZePFFZd1aorJAYQeSmjLRx7oGP3dWMBiYEYb4XaBEdIz
         i3Mv/iV5D7m8+ofJq+zXcb8ZlWaHUft4rlY+CKhFv3m0k/dkfoBh8c0WTRDz1JbJ7ZAW
         bfLw==
X-Forwarded-Encrypted: i=1; AKwUvBwlepU58jR0PkVb2y9wCwKf18IQJFQwXWFAqTZdsQ9Cz6HVwnvmCom1ME+TZ3TNJOoAGLXIVhuBHg==@kvack.org
X-Gm-Message-State: AFuF++kq8tJ9o+fNMtgfM/0odVeegYyr1LOCAvzj8ziwzvVGnYomdLCs
	zeGYQKk57xgmjzOpSjN9fVwAkGRW3GXgd5yctRWNy/itTcNPmTsqjbH39iPSUwsEo4fc5tKsTU8
	+wDNmUkadwRCcLcyG3dQzhKIKC5rHF7lRZb6chExIRQzU1tI1DppHvPD+o98F8mbprYM0q7/XgV
	3I7s0iWeQqqAia0t1GRHz+cD10joYHoGblZk3UxwTsvEAp2UEPeYpuquDy8QCrrC6p0OtgXvhhY
	GI=
X-Gm-Gg: AYBFou3E0nZzPWtLXc6YYRuHsF7cZB0WbcP3CLekXuHfUJrmlC/KhgOkeQVSuEKSTEm
	qJoQE6+9Oyxa5lAInugiA7L2XAcIG2lSzxSFQ0Dj2VHuDTpjKgDGkAfzIJGyP01F+keoxmH4/xb
	IsEQ3vMii/RHntefx5I4qrbYMo5JUpPVQpwib9H+AfVbimxi1i/8yba0wkh50TLWpL0zleFI1ei
	QWZfPzlIEtKgslk/JHnxL/P8j3UBvSXIbMmNoFpZA/NawwWnGKZ4uP0OBkimkXWcQ6HXxNJE6pi
	jNaJX00hLhR6bJ6Z3H0NKI3zHtIN+F9Jz/d1XZrF4ldqP4TH3qgd3/eYflhVh2O+H/tY1MZ9bhf
	UvTRu18LjAd0lfUEEjzmvrEQ+zZJiHdm/3/vC6WYmWHkcy5yKrR19Mix/RfKMBBYEdX5fsq0nwH
	kdsj2UfTnyKHBbpfGXtH4et4hccZt7bk2p
X-Received: by 2002:a05:6a21:7e08:b0:3de:3f4d:f2b9 with SMTP id adf61e73a8af0-3de3f4df74bmr6682684637.39.1790654621687;
        Mon, 28 Sep 2026 21:03:41 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id 41be03b00d2f7-cc7877bc2f9sm7837408a12.10.2026.09.28.21.03.39
        for <linux-mm@kvack.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Sep 2026 21:03:41 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-30c0d568830so7722572eec.1
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1790654618; x=1791259418; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QwnEpUDfw+7fPie+mcX7kjJEU0lPRR1jdyRNDD8g1m0=;
        b=IqgEj1gjyBHoixeNYdI6wFgdgk/bEh0AV8ZGRjQOCLp/BoOeBVZP0dMp7aDoTSZvtm
         HQ8DIO04mQg5dkVbfiUXcOk3pmnKbItoSRMISIgTeDPGS+2shPjana7HUUud4E2Py01Q
         Ul6ONz0OkSqdj8eJGLxu72Jfjnl3Vx0wAWGgc=
X-Forwarded-Encrypted: i=1; AKwUvBw0y+fmltk0TDKD5O0j/geI7lAbtdctuZ4JqPPi+ruoqkNz8bY1UTOeoPCdlsRvMZM+bCKZX4S3aA==@kvack.org
X-Received: by 2002:a05:7301:b05:b0:340:7202:d7fc with SMTP id 5a478bee46e88-342713a2732mr10393724eec.17.1790654618229;
        Mon, 28 Sep 2026 21:03:38 -0700 (PDT)
X-Received: by 2002:a05:7301:b05:b0:340:7202:d7fc with SMTP id 5a478bee46e88-342713a2732mr10393671eec.17.1790654617422;
        Mon, 28 Sep 2026 21:03:37 -0700 (PDT)
Received: from vertex.localdomain ([192.19.144.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-347323f5a7esm10952571eec.15.2026.09.28.21.03.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 21:03:36 -0700 (PDT)
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
Subject: [PATCH v2 6/6] x86/percpu: Share decrypted storage before guest CPU setup
Date: Tue, 29 Sep 2026 00:02:55 -0400
Message-ID: <20260929040256.543767-7-zack.rusin@broadcom.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260929040256.543767-1-zack.rusin@broadcom.com>
References: <20260929040256.543767-1-zack.rusin@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CCBBA1A0009
X-Stat-Signature: z4qnmhm9rb33exdonumriy1dmtksr4j8
X-Rspam-User: 
X-HE-Tag: 1790654622-76459
X-HE-Meta: U2FsdGVkX1/gd5LrTVwtGAMsFkMlt1LLOySA8aNXA9wgktx3kc9aFmFZYsGGrsH7D+m29kYA8KOk752Huqs43udaeXKKSeJLle1otwT0rlEk8YrQZJmEgeB0UJw4mKqj4PN1aluKmH2pQV+u1MF9YrbR8bx1BK6DliqvyiTFdzgFfFZBPgeAaxW+smJvEHhRMpUwnJnSiDQkHCq/RNPN6mjDsRO3rmIFN/N9iG4IsVBAh5yahwA3dda0/5eouSoY3bvCkO0HkgAUCnUSsixjNFCNMQ9Ss2+n1pjOWoKWqZdoBk6ff62RdJXA6EUFfW1jStRd7YAzJr0zcwTDm4UEnAV7xqTleHxCOiOcsv1p6ijLwV7ETJnBC54TRXUs87eTyFDOg+O8uyxZZbtNL/qu4+pfFhKqCgip118h5QssKD980dB5zl9m5EXkbyVhGNjh6NfPtfmYuubrbUss6AX4ugYeY4OcEMKwuLHPRwR9qj/qkVPOQblDn512BwLn8g9OChlIQeDyaI/ES0W2Z56YVn7xiLuMCuVbJxinzcz5zOHgNQ9Lpg6OUIXL2ck4yIWa41sgEORkkXIKICVWa6h3U3ZHChhQp0yTtMHEvNIesr1nm7fx80bqyRyKtiwRdO4n8WFpQvKv4ncHbv9emKqA0pHOpWJTiM3DLdiu4d/0rCStOOeaR5uKw4VlbQmEcyo0qx/Wi/wvMwL+BB+l9LzpAnL2zYI/dw0Ra/wQ83Nenlp3H0Fvi3NJEKmlhoj8TSVAP/AKsKwY7d7x0MwK2T6cXvL08mvzFkgsAn4NJpsAVYH3RoPB/JBo874v5JWvaPqDfp2rf9JbZfqlSkXbVUDdHR1gdh0nGCfrJJwvdNuUXil1UGW4rJ8R7EYNrBMBUaZByN/YGasHda1ujn6tIug67vYa+AljCYBS60Q2TaA86G9fqkcEdVOSMTHk3py8O6kAZyobdRkAH6Zvsl4SiJ3
 iuWHVjUQ
 IqF2fn2E7EsFJIMk0o2NdC1Hfv8w82Vgj3u5AMLJJkxt6YXI78Zrl2g4zXK4YNzAt8TRUu0FXEkBeyThlZ82KT7ECG3EacauNt/SfFLuspZjA60AliBOzWTF/Cnzy8OUj/c0h82C0pnph02Nvsyv/1kGlt7e4YpTvTxqTjVlfO/f4WwQG3lJYoiTOrC1/8a9NB2Ro0gkNGie3kWrGwfoUiL++QdxspZtTa8WyNjdBedFA8yvBWVzglOKEssjhV6gStoCmuY/x+4dwMYumfdg0hqbKwHUYV8VXxzUqnkQwe/JBVNsJKe3EbW9fOeH/xr1hZtIjSEyhH0WSLIatNBAUl46JZbTBqJAYf3CNJpheEItIIQFpFV1lw8+qDivI/p2zlBkLGN3gjC6wv+FcBBIvfQ18gQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert every possible CPU's decrypted section after per-CPU setup and
before the boot CPU registers its buffers. This replaces KVM's object
loop and shares VMware steal-time storage without a driver conversion
path or readiness state.

UP KVM registers inside setup_arch(), so convert before guest_late_init()
there and move VMware's UP registration to that hook. Stop boot on a
conversion failure: inconsistent page state must not be published to the
hypervisor. Host SME keeps its existing mappings. Skip Hyper-V vTOM
per-CPU storage: its visibility callbacks require later Hyper-V
initialization.

Suggested-by: Kiryl Shutsemau <kas@kernel.org>
Link: https://lore.kernel.org/r/aqqGUAX65s4LdJkr@thinkstation
Link: https://lore.kernel.org/r/aqvxQoIoYhJTZpAC@thinkstation
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
---
 arch/x86/hyperv/ivm.c              |  4 ++++
 arch/x86/include/asm/mem_encrypt.h |  2 ++
 arch/x86/include/asm/x86_init.h    |  2 ++
 arch/x86/kernel/cpu/vmware.c       |  2 +-
 arch/x86/kernel/kvm.c              | 35 -----------------------------------
 arch/x86/kernel/setup.c            |  2 ++
 arch/x86/kernel/setup_percpu.c     |  2 ++
 arch/x86/mm/mem_encrypt.c          | 22 ++++++++++++++++++++++
 8 files changed, 35 insertions(+), 36 deletions(-)

diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
index 2ce4dfe53472..4a5c735c9c52 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -887,6 +887,10 @@ void __init hv_vtom_init(void)
 	cc_set_mask(ms_hyperv.shared_gpa_boundary);
 	physical_mask &= ms_hyperv.shared_gpa_boundary - 1;
 
+	/* vTOM has no early per-CPU consumers and needs the Hyper-V setup. */
+	x86_init.paging.skip_percpu_decryption = true;
+	x86_init.paging.early_decrypt_page = NULL;
+
 	x86_platform.hyper.is_private_mmio = hv_is_private_mmio;
 	x86_platform.guest.enc_cache_flush_required = hv_vtom_cache_flush_required;
 	x86_platform.guest.enc_tlb_flush_required = hv_vtom_tlb_flush_required;
diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
index 4d81f693b1d3..05cf395407ef 100644
--- a/arch/x86/include/asm/mem_encrypt.h
+++ b/arch/x86/include/asm/mem_encrypt.h
@@ -21,11 +21,13 @@ struct boot_params;
 #ifdef CONFIG_X86_MEM_ENCRYPT
 void __init mem_encrypt_init(void);
 void __init mem_encrypt_setup_arch(void);
+void __init mem_encrypt_init_percpu(void);
 int __init early_set_memory_decrypted(unsigned long vaddr, unsigned long size);
 void __init early_set_page_decrypted(unsigned long addr, unsigned long alias);
 #else
 static inline void mem_encrypt_init(void) { }
 static inline void __init mem_encrypt_setup_arch(void) { }
+static inline void __init mem_encrypt_init_percpu(void) { }
 static inline int __init
 early_set_memory_decrypted(unsigned long vaddr, unsigned long size) { return 0; }
 #endif
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index e4131402c783..8d1597372eb6 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -76,10 +76,12 @@ struct x86_init_oem {
  *			Callback must call paging_init(). Called once after the
  *			direct mapping for phys memory is available.
  * @early_decrypt_page:	Share a direct-mapped page and its optional image alias
+ * @skip_percpu_decryption: Platform does not use early shared per-CPU data
  */
 struct x86_init_paging {
 	void (*pagetable_init)(void);
 	int (*early_decrypt_page)(unsigned long addr, unsigned long alias);
+	bool skip_percpu_decryption;
 };
 
 /**
diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index 34b73573b108..b477cc027b18 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -366,7 +366,7 @@ static void __init vmware_paravirt_ops_setup(void)
 					      vmware_cpu_down_prepare) < 0)
 			pr_err("vmware_guest: Failed to install cpu hotplug callbacks\n");
 #else
-		vmware_guest_cpu_init();
+		x86_init.hyper.guest_late_init = vmware_guest_cpu_init;
 #endif
 	}
 }
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 6b0a5861ccb8..acb3b7b18ebe 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -429,34 +429,6 @@ static u64 kvm_steal_clock(int cpu)
 	return steal;
 }
 
-static inline __init void __set_percpu_decrypted(void *ptr, unsigned long size)
-{
-	early_set_memory_decrypted((unsigned long) ptr, size);
-}
-
-/*
- * Iterate through all possible CPUs and map the memory region pointed
- * by apf_reason, steal_time and kvm_apic_eoi as decrypted at once.
- *
- * Note: we iterate through all possible CPUs to ensure that CPUs
- * hotplugged will have their per-cpu variable already mapped as
- * decrypted.
- */
-static void __init sev_map_percpu_data(void)
-{
-	int cpu;
-
-	if (cc_vendor != CC_VENDOR_AMD ||
-	    !cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
-		return;
-
-	for_each_possible_cpu(cpu) {
-		__set_percpu_decrypted(&per_cpu(apf_reason, cpu), sizeof(apf_reason));
-		__set_percpu_decrypted(&per_cpu(steal_time, cpu), sizeof(steal_time));
-		__set_percpu_decrypted(&per_cpu(kvm_apic_eoi, cpu), sizeof(kvm_apic_eoi));
-	}
-}
-
 static void kvm_guest_cpu_offline(bool shutdown)
 {
 	kvm_disable_steal_time();
@@ -709,12 +681,6 @@ arch_initcall(kvm_alloc_cpumask);
 
 static void __init kvm_smp_prepare_boot_cpu(void)
 {
-	/*
-	 * Map the per-cpu variables as decrypted before kvm_guest_cpu_init()
-	 * shares the guest physical address with the hypervisor.
-	 */
-	sev_map_percpu_data();
-
 	kvm_guest_cpu_init();
 	native_smp_prepare_boot_cpu();
 	kvm_spinlock_init();
@@ -868,7 +834,6 @@ static void __init kvm_guest_init(void)
 				      kvm_cpu_online, kvm_cpu_down_prepare) < 0)
 		pr_err("failed to install cpu hotplug callbacks\n");
 #else
-	sev_map_percpu_data();
 	kvm_guest_cpu_init();
 #endif
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index cda6adb9f69c..8eebd85e59af 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1251,6 +1251,8 @@ void __init setup_arch(char **cmdline_p)
 
 	io_apic_init_mappings();
 
+	if (!IS_ENABLED(CONFIG_SMP))
+		mem_encrypt_init_percpu();
 	x86_init.hyper.guest_late_init();
 
 	e820__reserve_resources();
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index c83c61e0b20a..8526ad37a81b 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -5,6 +5,7 @@
 #include <linux/export.h>
 #include <linux/init.h>
 #include <linux/memblock.h>
+#include <linux/mem_encrypt.h>
 #include <linux/percpu.h>
 #include <linux/kexec.h>
 #include <linux/crash_dump.h>
@@ -234,4 +235,5 @@ void __init setup_per_cpu_areas(void)
 	 * this call?
 	 */
 	sync_initial_page_table();
+	mem_encrypt_init_percpu();
 }
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index c3e239a47b66..d3224607170d 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -13,6 +13,7 @@
 #include <linux/cc_platform.h>
 #include <linux/mem_encrypt.h>
 #include <linux/pgalloc.h>
+#include <linux/percpu.h>
 #include <linux/virtio_anchor.h>
 #include <linux/iommu-dma.h>
 
@@ -24,6 +25,8 @@
 
 #include "mm_internal.h"
 
+extern char __percpu __start_percpu_decrypted[], __end_percpu_decrypted[];
+
 static pte_t * __init early_lookup_pte(unsigned long addr)
 {
 	unsigned long pfn, step;
@@ -134,6 +137,25 @@ int __init early_set_memory_decrypted(unsigned long vaddr, unsigned long size)
 	return 0;
 }
 
+void __init mem_encrypt_init_percpu(void)
+{
+	unsigned long size = __end_percpu_decrypted - __start_percpu_decrypted;
+	int cpu, ret;
+
+	if (!cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT) ||
+	    x86_init.paging.skip_percpu_decryption)
+		return;
+
+	for_each_possible_cpu(cpu) {
+		unsigned long addr = (unsigned long)
+			per_cpu_ptr(__start_percpu_decrypted, cpu);
+
+		ret = early_set_memory_decrypted(addr, size);
+		if (ret)
+			panic("Cannot share CPU %d per-CPU data (err=%d)", cpu, ret);
+	}
+}
+
 /* Override for DMA direct allocation check - ARCH_HAS_FORCE_DMA_UNENCRYPTED */
 bool force_dma_unencrypted(struct device *dev)
 {

-- 
2.53.0


