Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 639EDC982E6
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 19:40:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4645E6B00D0; Sun, 20 Sep 2026 15:40:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 413FC6B00D1; Sun, 20 Sep 2026 15:40:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DBF26B00D2; Sun, 20 Sep 2026 15:40:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E1C576B00D0
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 15:40:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0AA621204DD
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:40:02 +0000 (UTC)
X-FDA: 85235156244.07.E52B8C4
Received: from mail-yx2-f42.google.com (mail-yx2-f42.google.com [74.125.224.170])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4287740002
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:40:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=OxtA8jHh;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789933200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K+2B3zmRro/zDH0n7+YdvazCE3Eaf+b235sNOcPlOno=;
	b=i0BV3kpY+N/sTLt2+kr9Zr6RCcrOdlkDTy5TiEW9RcadqzAEcW0HI2wXNAQIud0irfrp9C
	pUgx1/cs3hK2QH9A9brbXKawa94qTqtM4JFSAEwhH1EybJnR38ACA4axcq/F00k5vtZTrF
	1ItFHnSg9px9bTMOsDBKGsa2LGJQLA8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=OxtA8jHh;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789933200;
	b=T86h8ZRgy0iMV/R9FtqTmPbNi5NueaS2fL7f098/TE2J09D3+sISpWR3iFc+EFyXVkdj6F
	WXgfNFejVQTx98eNvurYU/mzMKUPvxONfZ2e22A7Ca66FuTfQO45uJRyB3G2iGRJuijMiY
	wnm1XL4/u9vgjQOhnGtKFmYZrdeqvZw=
Received: by mail-yx2-f42.google.com with SMTP id 956f58d0204a3-6729c4030f0so838556d50.2
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933199; x=1790537999; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=K+2B3zmRro/zDH0n7+YdvazCE3Eaf+b235sNOcPlOno=;
        b=OxtA8jHhhjp7hbASleQ3RUofVBWV4eWzOiOJeS0GIVuIE/N14Yy3pcXzirg3F4fJ8g
         8tN2mrKkSS8UZphrxNb60JRYMsTwiusjmA8jh8GwUHiTZJcGRUOtKq8/s1tBXtet+N71
         DbQtsSdyV9Tr0Ey040w2N2bFKTETpGXxMkZEBM+deGi3AFd3P2sKOB6ekTQe62WVrE8L
         YoYD2BosRn60ZRdnrXTUG4DPF8K6JBmmhPn/7wIigoGxR20/2jh6EHOw4nwG8gS7Obmv
         /MqxRKqT0Ga/50FuivVU1MoDkWkcIbzBQBWGjOB4rTzHwzvaVZz0GKb0CaXfLNoxcNb3
         Ah6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933199; x=1790537999;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=K+2B3zmRro/zDH0n7+YdvazCE3Eaf+b235sNOcPlOno=;
        b=haT7/93aOt7r94vqSuWT4WI9XjwsGaC60hYCqnO6ZzmgO73PoQvFI6YyU8NXABl9aM
         P1LkyBvVDWkx6VNGk4smPAiz9t0Jum3vPIC0ebUC+JxmxIHGn22pcS4GePZGaDm6z8yK
         NrwOaBFFALz7p4/plmjAXKoQ7EttdYkjdSf6eo1lU6pFk3uLHh0St/vwlLzzkZwOYziI
         facYYtIFnYiXyb8Ze+K7HkmWglh27oKK2L9z1h9zB/p1/P/NoX5lDGXGEQsIArdFs5oV
         d3XtszAHMaksgNvw7VhXjxbRljersWzXyhwPgMYLVFZiwQt50PRnEbPjIkQpiDJhU7zk
         UOQA==
X-Forwarded-Encrypted: i=1; AKwUvBx/WyVEzDArIo24jjKQdomaa6Hsog1EaKNdcePE8Ei/Mmrv1f4U87mIGE05Dew55fzvsr1j86hkKg==@kvack.org
X-Gm-Message-State: AFuF++nNa00aIdIoIaNHdhkr61DIMS6CPeNNVd1io98yigc3c9J8/nCv
	aiAIfqctzLCU09xd6lQyjROMhgT5OAQ212n6NI2EK7pQjnHQv6bXfwUT+wh0QswbAcc=
X-Gm-Gg: AYBFou0zvIeWI4yiCVKUFoPdGgTH4QnRiRo6fE0sZNk+uLVpStnRVgpDGYfRacbE0Z7
	dRyr+dHtR6r2NPkFSIfae/5u+mLmHyjA2dsboNlXY7O/jPxi+ZNaS7Cc8ilDRYyPsetmMtaQe+w
	m7O3L/92IEzpRkXtabUQBEzZJ4asI5v+SgrHlUpV1+38hph2/EPaxREOkGqMJoFfQKWUvrEkJ5g
	WSRre6JCGsZoLMQQcf13jvLoE9dw8DwEKE/VA0xNqhiLWozqam5/Vr2dPo/gveJ045by3EGHcy+
	phU46TjBIL4LNIbn0CNRRi8aYSn2O9zmvgTvaAKsYIloMF/xaNj5IrxBVqJbpSlg+wqWMCLw1DC
	cUIJpgCAmV5JolrWWIvuoKMpJlq2xHZOWDDUeF/p9w4KuLxCy2QMJxc1A/eAxSDYZmG4xPUIgJ/
	FqnuuvTq4YWZLdC2o9aJNFa0P0qD87Joy6sByv6KL1Dn1Ty2bNMcGRduVX1OEqEeliu4h/AQQKr
	YIncl1A03s37bjKy9B333+Oc1/b6qC3NGpiXsGj6Pmok1MIglmrBenW6NZC8Z7R8sZkmSDB1I+R
	vjI8RQ5LU2SbnXi8BSw=
X-Received: by 2002:a05:690e:1408:b0:671:41c1:daaf with SMTP id 956f58d0204a3-6717fc95e09mr2518491d50.6.1789933199337;
        Sun, 20 Sep 2026 12:39:59 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-672990ab5desm2605625d50.8.2026.09.20.12.39.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:39:58 -0700 (PDT)
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
Subject: [RFC PATCH 31/46] KVM: caretaker: Add generic KHO ABI telemetry and debugfs reporting
Date: Sun, 20 Sep 2026 15:36:35 -0400
Message-ID: <20260920193650.3373435-32-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 3y3qe6y4xbtm5jp9kfrm31psint67zph
X-Rspamd-Queue-Id: 4287740002
X-Rspamd-Server: rspam07
X-HE-Tag: 1789933200-412324
X-HE-Meta: U2FsdGVkX1+HxpXRh2sae/gTrvvvqWuZATOeLbx4uppz0yfXha4pX2FcdNDmFKAIL3k1W4HYYa00UxamrxljJDDVB6go1Fu3SdLAcjDUKETqsIRE1rizOebyKZXQ/kvkcWD2/cIdUgKvO4gVJXP/DgVB88l9iAHIcY0AXJgflLVs6orRTcs8W0wu4/nASwiibUqAfQh9F1rQB/5f0uydHwUMBbUketvNPaWXCq4hSq3FPRKO2yu3Dt1caGUTwvTxYVP1UQRQcQhklarJna3QKMIHsIfsvw61iCW6nKMLzn2aolDyR4gtFg8eUYHcd70uNKDX6GfAvN7LNkncM733dnmYFx9fJGvytIo4IAYoQUpC6MyhMbDI4oEJto6YXZy0QGwjVOhGBKUceQQhvpCEf65HDrFt2RfrG8R6RgiN/UIrjd64TaOby+B7lOJhclTwEell3+DZ3gbLzHDr0k2eEa7N+uTH5ZuKWYoahSNhJzt+f/glj8ZlTPZl/oBv8lcbnFkbOp4CgcL4XCW5lm2ijL45IdO4+wHNco+CH8TZtMqeaFSPXpbKGobZVbPtoZzhM6z/6JhXLLTmR7v7iVXA3zVHs6P1Hlj1ct8hOkcVhmzC8OY7w8t3YeL40kIXdzto6wwx7/6mvs9NwnjL8VDfICbBI59qUjU7fvLvfoqWWSTu2FX5gTQWPET12otThGHkv0E5NOlFTJFssMeIYjjrKrSv316i+QNQOqWEisL/3vcS8EIzOL7SoQpgijUMA1O7y0xTDlIs7VN1vPSdhNmRcRxod0kTerZqj6QWvpgGwor9xwCYMx1rFYbqhwc1DJd+nVD0DnRy3vx+KBwsMeL1F7OBGJQSY9qsPglLJCusWDnK88v7pc2LFrnQ9k7/OXP+D+qJOWt23UrUNLCoslXK7sJLI/b6Qniu0BKEp0A/gNEVerkI1Aw+uYkldc115r/G99QC01TzOzH21GBtK4t
 pd/whv6i
 LvKUY38u+oi2lRzNcSCatSjmjLtm7V7QPGz1Un+9xejryHA0C1x+f07oJoTxmlTRPg1m4dnLxdGcADHsDdZ1wMczlKKczD/hf1AuIpE8vdasJslq2D96i8N6sJGaAvAOe7NgZgwm1yWIfnx0r6BhiaslPeeW2LJKVwn8hM8HKVEWk2uQNoeShtSdGApkBHi6yHaKKIKSVddmgXXy6hOas4TGMlshzPliEeSwzG4zkCqAsCyMxWmD6k4SA1MJfXKsf4d+dkmMHoJ5UiKkhv4L0mcjvogV5ugwc2hP49xjgUKx1f8b2FkBOSd0gttKvhITiNRUIaBQQezNqMhI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a preserved vCPU executes inside the Caretaker during a host live
update blackout window, standard kernel tracing and KVM exit counters
are unavailable because the host kernel is being replaced via kexec. If
a guest vCPU hits an unhandled exit and parks, or experiences unexpected
exit patterns during the transition, the incoming kernel has no
visibility into what occurred while the vCPU was detached.

Add optional cross-kexec Caretaker execution telemetry behind
CONFIG_KVM_CARETAKER_DEBUG. During detached execution, the Caretaker
records run counts, exit counts, stall counts, the last exit reason and
guest PC, and stall diagnostics into a KHO-preserved telemetry buffer
referenced from struct kvm_caretaker_cb_ser. When the incoming kernel
reclaims the vCPU, it logs a summary to dmesg and exposes the preserved
telemetry under /sys/kernel/debug/kvm/<vm>/vcpu<N>/caretaker_telemetry.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/kvm_caretaker.h |  97 +++++++++++++++++++++++++++
 virt/kvm/Kconfig              |  10 +++
 virt/kvm/Makefile.kvm         |   1 +
 virt/kvm/caretaker_debug.c    | 120 ++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c           |   1 +
 5 files changed, 229 insertions(+)
 create mode 100644 virt/kvm/caretaker_debug.c

diff --git a/include/linux/kvm_caretaker.h b/include/linux/kvm_caretaker.h
index 0d4bdde7b1c3..f889d17212b0 100644
--- a/include/linux/kvm_caretaker.h
+++ b/include/linux/kvm_caretaker.h
@@ -108,11 +108,13 @@ struct kvm_caretaker_ops {
  * @cb:        Pointer to KHO-preserved Caretaker control block (&struct kvm_caretaker_cb_ser).
  * @ops:       Architecture operations vector (&struct kvm_caretaker_ops).
  * @arch_data: Architecture-specific runtime context passed to @ops callbacks.
+ * @telemetry: Pointer to KHO-preserved telemetry counters, or %NULL.
  */
 struct kvm_caretaker_vcpu {
 	struct kvm_caretaker_cb_ser *cb;
 	const struct kvm_caretaker_ops *ops;
 	void *arch_data;
+	struct kvm_caretaker_telemetry_ser *telemetry;
 };
 
 struct kvm_kho_folios_ser *kvm_kho_folios_alloc(unsigned int max_folios);
@@ -260,11 +262,106 @@ void kvm_caretaker_vcpu_finish(struct kvm_vcpu *vcpu,
 			       struct liveupdate_session *session,
 			       struct kvm_vcpu_ser *ser);
 
+#ifdef CONFIG_KVM_CARETAKER_DEBUG
+void kvm_caretaker_telemetry_init(struct kvm_caretaker_vcpu *cvcpu,
+				  struct oncore_session *sess);
+void kvm_caretaker_telemetry_report(struct kvm_vcpu *vcpu,
+				    struct kvm_caretaker_cb_ser *cb);
+void kvm_caretaker_telemetry_free(struct kvm_vcpu_ser *ser, bool is_incoming);
+void kvm_caretaker_create_vcpu_debugfs(struct kvm_vcpu *vcpu,
+				       struct dentry *debugfs_dentry);
+
+/**
+ * kvm_caretaker_telemetry_run - Record a guest entry in Caretaker telemetry
+ * @cvcpu: Common Caretaker vCPU descriptor.
+ */
+static __always_inline __caretaker_text void
+kvm_caretaker_telemetry_run(struct kvm_caretaker_vcpu *cvcpu)
+{
+	if (cvcpu->telemetry)
+		cvcpu->telemetry->total_runs++;
+}
+
+/**
+ * kvm_caretaker_telemetry_exit - Record a decoded VM exit in Caretaker telemetry
+ * @cvcpu: Common Caretaker vCPU descriptor.
+ * @exit:  Decoded VM exit descriptor.
+ */
+static __always_inline __caretaker_text void
+kvm_caretaker_telemetry_exit(struct kvm_caretaker_vcpu *cvcpu,
+			     const struct kvm_caretaker_exit *exit)
+{
+	if (cvcpu->telemetry) {
+		cvcpu->telemetry->total_exits++;
+		cvcpu->telemetry->last_exit_reason = exit->raw_reason;
+		cvcpu->telemetry->last_exit_rip = exit->rip;
+	}
+}
+
+/**
+ * kvm_caretaker_telemetry_stall - Record an unhandled stall exit in Caretaker telemetry
+ * @cvcpu:  Common Caretaker vCPU descriptor.
+ * @reason: Raw hardware exit reason or entry failure code.
+ * @rip:    Guest instruction pointer at stall (0 if entry failure).
+ */
+static __always_inline __caretaker_text void
+kvm_caretaker_telemetry_stall(struct kvm_caretaker_vcpu *cvcpu,
+			      u64 reason, u64 rip)
+{
+	if (cvcpu->telemetry) {
+		cvcpu->telemetry->stall_count++;
+		cvcpu->telemetry->last_exit_reason = reason;
+		cvcpu->telemetry->stall_exit_reason = reason;
+		if (rip)
+			cvcpu->telemetry->stall_exit_rip = rip;
+	}
+}
+
+/**
+ * kvm_caretaker_telemetry_flush - Clean Caretaker telemetry counters to PoC
+ * @cvcpu: Common Caretaker vCPU descriptor.
+ */
+static __always_inline __caretaker_text void
+kvm_caretaker_telemetry_flush(struct kvm_caretaker_vcpu *cvcpu)
+{
+	if (cvcpu->telemetry)
+		cpu_preserved_clean_sz(cvcpu->telemetry,
+				       sizeof(*cvcpu->telemetry));
+}
+#else
+static inline void kvm_caretaker_telemetry_init(struct kvm_caretaker_vcpu *cvcpu,
+						struct oncore_session *sess) {}
+
+static inline void kvm_caretaker_telemetry_report(struct kvm_vcpu *vcpu,
+						  struct kvm_caretaker_cb_ser *cb) {}
+
+static inline void kvm_caretaker_telemetry_free(struct kvm_vcpu_ser *ser,
+						bool is_incoming) {}
+
+static inline void kvm_caretaker_create_vcpu_debugfs(struct kvm_vcpu *vcpu,
+						     struct dentry *debugfs_dentry) {}
+static __always_inline void
+kvm_caretaker_telemetry_run(struct kvm_caretaker_vcpu *cvcpu) {}
+static __always_inline void
+kvm_caretaker_telemetry_exit(struct kvm_caretaker_vcpu *cvcpu,
+			     const struct kvm_caretaker_exit *exit) {}
+static __always_inline void
+kvm_caretaker_telemetry_stall(struct kvm_caretaker_vcpu *cvcpu,
+			      u64 reason, u64 rip) {}
+static __always_inline void
+kvm_caretaker_telemetry_flush(struct kvm_caretaker_vcpu *cvcpu) {}
+#endif
+
 #else /* !CONFIG_KVM_CARETAKER */
 
 #define __caretaker_text
 #define __caretaker_data
 
+struct dentry;
+
+static inline void kvm_caretaker_create_vcpu_debugfs(struct kvm_vcpu *vcpu,
+						     struct dentry *debugfs_dentry) {}
+
 static inline bool kvm_caretaker_is_stopped(const struct kvm_caretaker_cb_ser *cb)
 {
 	return true;
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 165e0c85b8aa..bee73dd079c6 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -153,3 +153,13 @@ config KVM_CARETAKER
 	  without pausing the guest.
 
 	  If unsure, say N.
+
+config KVM_CARETAKER_DEBUG
+	bool "Caretaker execution telemetry and debug reporting"
+	depends on KVM_CARETAKER
+	default n
+	help
+	  Enable Caretaker telemetry collection and reporting of VM exits,
+	  runs, and stall diagnostics via debugfs and dmesg upon vCPU resume
+	  following a host kexec live update or cancelled live update session.
+	  If unsure, say N.
diff --git a/virt/kvm/Makefile.kvm b/virt/kvm/Makefile.kvm
index ae1fcf9861b7..157d0bf6132d 100644
--- a/virt/kvm/Makefile.kvm
+++ b/virt/kvm/Makefile.kvm
@@ -15,6 +15,7 @@ kvm-$(CONFIG_HAVE_KVM_PFNCACHE) += $(KVM)/pfncache.o
 kvm-$(CONFIG_KVM_GUEST_MEMFD) += $(KVM)/guest_memfd.o
 kvm-$(CONFIG_LIVEUPDATE_GUEST_MEMFD) += $(KVM)/guest_memfd_luo.o $(KVM)/kvm_luo.o
 kvm-$(CONFIG_KVM_CARETAKER) += $(KVM)/caretaker.o
+kvm-$(CONFIG_KVM_CARETAKER_DEBUG) += $(KVM)/caretaker_debug.o
 KASAN_SANITIZE_$(KVM)/caretaker.o := n
 KCSAN_SANITIZE_$(KVM)/caretaker.o := n
 UBSAN_SANITIZE_$(KVM)/caretaker.o := n
diff --git a/virt/kvm/caretaker_debug.c b/virt/kvm/caretaker_debug.c
new file mode 100644
index 000000000000..8905938bfec3
--- /dev/null
+++ b/virt/kvm/caretaker_debug.c
@@ -0,0 +1,120 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ *
+ * KVM Caretaker execution telemetry and debugfs reporting.
+ */
+
+#include <linux/cpu_preserve.h>
+#include <linux/debugfs.h>
+#include <linux/kernel.h>
+#include <linux/kexec_handover.h>
+#include <linux/kho/abi/kvm.h>
+#include <linux/kvm_caretaker.h>
+#include <linux/kvm_host.h>
+#include <linux/oncore.h>
+#include <linux/seq_file.h>
+
+void kvm_caretaker_telemetry_init(struct kvm_caretaker_vcpu *cvcpu,
+				  struct oncore_session *sess)
+{
+	struct kvm_caretaker_telemetry_ser *tel;
+
+	tel = kho_alloc_preserve(sizeof(*tel));
+	if (IS_ERR_OR_NULL(tel))
+		return;
+
+	memset(tel, 0, sizeof(*tel));
+	oncore_session_map_buffer(sess, tel, sizeof(*tel));
+	cpu_preserved_clean_sz(tel, sizeof(*tel));
+	cvcpu->telemetry = tel;
+	KHOSER_STORE_PTR(cvcpu->cb->telemetry, tel);
+}
+
+void kvm_caretaker_telemetry_report(struct kvm_vcpu *vcpu,
+				    struct kvm_caretaker_cb_ser *cb)
+{
+	struct kvm_caretaker_telemetry_ser *tel;
+
+	if (!vcpu || !cb)
+		return;
+
+	cpu_preserved_inval(cb);
+	tel = KHOSER_LOAD_PTR(cb->telemetry);
+	if (!tel)
+		return;
+
+	cpu_preserved_inval(tel);
+	vcpu->caretaker.last_telemetry = *tel;
+
+	pr_info("caretaker: vcpu %d resume: runs=%llu exits=%llu stalls=%llu last_exit=0x%llx (%llu) rip=0x%llx\n",
+		vcpu->vcpu_id, tel->total_runs, tel->total_exits,
+		tel->stall_count, tel->last_exit_reason,
+		tel->last_exit_reason, tel->last_exit_rip);
+	if (tel->stall_count) {
+		pr_info("caretaker: vcpu %d stall info: reason=0x%llx (%llu) rip=0x%llx\n",
+			vcpu->vcpu_id, tel->stall_exit_reason,
+			tel->stall_exit_reason, tel->stall_exit_rip);
+	}
+}
+
+void kvm_caretaker_telemetry_free(struct kvm_vcpu_ser *ser, bool is_incoming)
+{
+	struct kvm_caretaker_telemetry_ser *tel;
+	struct kvm_caretaker_cb_ser *cb;
+
+	if (!ser || !(ser->flags & KVM_VCPU_LUO_FLAG_CARETAKER))
+		return;
+
+	cb = KHOSER_LOAD_PTR(ser->cb);
+	tel = cb ? KHOSER_LOAD_PTR(cb->telemetry) : NULL;
+	if (tel) {
+		cb->telemetry.phys = 0;
+		if (is_incoming)
+			kho_restore_free(tel);
+		else
+			kho_unpreserve_free(tel);
+	}
+}
+
+static int caretaker_telemetry_show(struct seq_file *m, void *v)
+{
+	struct kvm_vcpu *vcpu = m->private;
+	const struct kvm_caretaker_telemetry_ser *t =
+		&vcpu->caretaker.last_telemetry;
+	struct kvm_caretaker_cb_ser *cb = READ_ONCE(vcpu->caretaker.cb);
+
+	if (cb) {
+		struct kvm_caretaker_telemetry_ser *live;
+
+		cpu_preserved_inval(cb);
+		live = KHOSER_LOAD_PTR(cb->telemetry);
+		if (live) {
+			cpu_preserved_inval(live);
+			t = live;
+		}
+	}
+
+	seq_printf(m, "runs: %llu\n", t->total_runs);
+	seq_printf(m, "exits: %llu\n", t->total_exits);
+	seq_printf(m, "stalls: %llu\n", t->stall_count);
+	seq_printf(m, "last_exit_reason: 0x%llx (%llu)\n",
+		   t->last_exit_reason, t->last_exit_reason);
+	seq_printf(m, "last_exit_rip: 0x%llx\n", t->last_exit_rip);
+	seq_printf(m, "stall_exit_reason: 0x%llx (%llu)\n",
+		   t->stall_exit_reason, t->stall_exit_reason);
+	seq_printf(m, "stall_exit_rip: 0x%llx\n", t->stall_exit_rip);
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(caretaker_telemetry);
+
+void kvm_caretaker_create_vcpu_debugfs(struct kvm_vcpu *vcpu,
+				       struct dentry *debugfs_dentry)
+{
+	if (!debugfs_dentry)
+		return;
+
+	debugfs_create_file("caretaker_telemetry", 0444, debugfs_dentry, vcpu,
+			    &caretaker_telemetry_fops);
+}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4f661c5d2ee2..84b4b96d7916 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4156,6 +4156,7 @@ static void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
 	debugfs_create_file("pid", 0444, debugfs_dentry, vcpu,
 			    &vcpu_get_pid_fops);
 
+	kvm_caretaker_create_vcpu_debugfs(vcpu, debugfs_dentry);
 	kvm_arch_create_vcpu_debugfs(vcpu, debugfs_dentry);
 }
 #endif
-- 
2.55.0.1082.g2b9226bbc0-goog


