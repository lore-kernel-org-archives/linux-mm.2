Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CEDACCA490
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 01:15:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82CED6B00C4; Sun, 18 Oct 2026 21:15:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78EF96B00C6; Sun, 18 Oct 2026 21:15:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67E9B6B00C7; Sun, 18 Oct 2026 21:15:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3FA786B00C4
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 21:15:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9DF481204FA
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:15:02 +0000 (UTC)
X-FDA: 85337606844.26.B148544
Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	by imf12.hostedemail.com (Postfix) with ESMTP id D72F540002
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:15:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=hQFieNMu;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792372500;
	b=VDcfNz0SCcmEM7LGTcFgRclRnKUBU2Od8s9wHXlcNOViz39+jq86+FV7xWnZhDqXB2lmkR
	aqUyb7Xv1IyCl8aJDzKVib1fQDYIxiix10dlh6qARvnBZ9I5rHSAHmCmLKaUznNaKGvxwh
	9F3uKK63Ni0Wwo0bFtoEPwIkL67gL4s=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=hQFieNMu;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792372500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z5LyhpH+32vicnnX5+Nfrq1TH+85hwwraSFoho5291M=;
	b=zmVR6VRI9N21xcL4/mNOKCeQ02U7Cundl6HxbaNlr7pMP+RNxAFuHn0Rx9hvtB401Nvs1E
	kufIc+Ph/MGpc+27ZQeUm/9k3qoR5bPbxPUsAo5J7l2DjZAMUsoOmeugEgrJBF7W6uGcq5
	lAzRK8VY+dC5jnhqhVwhyMTlmFVhpxc=
Received: by mail-vs1-f49.google.com with SMTP id ada2fe7eead31-7cc013095d4so467861137.2
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 18:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792372500; x=1792977300; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=z5LyhpH+32vicnnX5+Nfrq1TH+85hwwraSFoho5291M=;
        b=hQFieNMu4Uiot9UlXRqA2c6lNWVbd7+5PhK2UqQXBl3+90O7goOIKjzYfY4SL6egGq
         eTURar2mkRe0LX7par/mjKwFOwbrOITtp5N2IxKPIGHFqeFHet8BBkyu25jGn1iBLNs6
         q1d9lUrlQqaPTQ9CTSerDsuMMK3nyB4uoDTeb6iRPedk22XSet7KJyCwTKqgCK56L2Xm
         5SxAbXiJDG55aUNWBFt6lpgrcHUl4LFwb8exeEmUuQ419TTmqiuHhKcHEczLW+Kq11Cd
         cfiVxL4b9Yxl/5LYIf9NEfzjqFLP+1JeTkz1YUHB2E6dimVF6Ccm6Yjhr5m3AOPj2Yuq
         672A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792372500; x=1792977300;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=z5LyhpH+32vicnnX5+Nfrq1TH+85hwwraSFoho5291M=;
        b=emtFHfnRfideLSPCrIm2xdc5TEsatBSOxQHCX35TxdtFlnsg4q2QF05v92tiyR+eAO
         bVp9CWM6GjuST6gW0mGpJJhsnQMalD9Fy2pOu8XATuNNlJlgtwvkBmxUA+HdtVFxo0QF
         VK3nfGqvhpSmqdodvv3W8BLgBNeunE6HAywHZsIU/IrAccRakVweMfGI63oh5lFxPTFJ
         4pUVm6Ej3KpkNEw0LxXhofxS2WUHsB+ZaoYnXGyUmNrJq6uckxgitslENyZLBJBbfHj2
         DBIv+jaIJeGd6QVv4gHYrZXOSeRL3tAV3rjA6+LYqxh1lZLC4XCRMblw4mS+9njDG7zj
         A/KA==
X-Forwarded-Encrypted: i=1; AKwUvBzf51d1udgeQ1DbpeYsKapYWNBtJHZxPYxXz7lJStbqcwCwGrxohR6y50ezemt2ua+FgOc0Oeo4Ew==@kvack.org
X-Gm-Message-State: AFq9FYKhoO9n71szbgsINn3llyiMb0OtqhyyZMcsfGULKB8NfxpgyL9q
	WBzbbV+/uxPc81K99SnkoOYE6bcEJKzBLfnv++diGfLJ35sk2drGUhyDR0sCWduAXE4=
X-Gm-Gg: AYBFou10kenYwVYFYFjSfPuKNCkoQv7L545NXYkxTQs5P0xNI3Neho4ehCQFNwI/Lj2
	PEUhMTJ/Ie0++NHsvLv/wYd3rcRJWvS5+CjxVda0zuSqu+IR28X1ZZ7CK8Uqfffj9TCog4/yrx2
	uBP8mjJ7I32naz7lnOMhej+mAl5+jPiVMde/CAD023Lh6pq95xLuSXCyFoKdE43IiRIOnTyxFw5
	CEjZ0z46hZ56lnkti9ADOeOMzzfDraHbqVKTaUzAuPoeArmoLdO3VOdJqwH598YPLvgnS3FWg7v
	VG9IfvMQ7gRKRdmGiwnNG6Kc5SqcTu35XJiO3o+nZ90tQVUCigbHkwKqVFjj/zVSIIJtCOjaXDa
	WIQDrTvCakpWguoJS4Bmf2gPNAekxpoR8MJbGlpir0pjTMhyPMKRwGcqRCNUVXV2N4GzX5lKCg1
	/jM7EWMOgNMkD0dzjkoGDSWOobX+2eXLPKkrthHK7srEOZx7QyB/c2Wc0O5pwhW51PpJn4C8gPF
	RlrvtkF4Lhir8Q2YwsRjN0V1gaw/o98rk5OEqAlqWt5YxWqrS8MYVtJBEMCVfSkxEVBVddpgc2f
	X9iRP1yJjqV0C9AaazsNCY0CGR45Jg==
X-Received: by 2002:a05:6102:419e:b0:7c3:6466:3155 with SMTP id ada2fe7eead31-7cc36aa4af1mr1518608137.33.1792372499968;
        Sun, 18 Oct 2026 18:14:59 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ea9b474b2asm8039142e0c.4.2026.10.18.18.14.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 18:14:58 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: kees@kernel.org,
	rppt@kernel.org,
	juri.lelli@redhat.com,
	nik.borisov@suse.com,
	tglx@kernel.org,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	vincent.guittot@linaro.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	cgroups@vger.kernel.org,
	tony.luck@intel.com,
	david@kernel.org,
	mingo@redhat.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	seanjc@google.com,
	ljs@kernel.org,
	zhangguopeng@kylinos.cn,
	dietmar.eggemann@arm.com,
	mhocko@suse.com,
	vinicius.gomes@intel.com,
	vbabka@kernel.org,
	linux-kernel@vger.kernel.org,
	peterz@infradead.org,
	surenb@google.com,
	hpa@zytor.com,
	x86@kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	tim.c.chen@linux.intel.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rostedt@goodmis.org,
	gmonaco@redhat.com,
	jgross@suse.com,
	mgorman@suse.de,
	graf@amazon.com,
	linux-edac@vger.kernel.org,
	liam@infradead.org,
	ridong.chen@linux.dev,
	blum@kernel.org,
	longman@redhat.com,
	bsegall@google.com
Subject: [PATCH v2 4/8] x86/cacheinfo, mtrr: Skip stop_machine rendezvous in cache_ap_online() when MTRRs match
Date: Sun, 18 Oct 2026 21:14:42 -0400
Message-ID: <20261019011446.834487-5-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261019011446.834487-1-pasha.tatashin@soleen.com>
References: <20261019011446.834487-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Rspamd-Queue-Id: D72F540002
X-Stat-Signature: cdn9j5rn5s7kndhzsymtdszctr6kqctc
X-HE-Tag: 1792372500-235359
X-HE-Meta: U2FsdGVkX1/jCO2B9H/alEPQV+j6sfm4SyEKq2M4+cZwu1CAb11m0Hk+ecUOh12Y8liMRVhEEgS1hcEXlm2Gk0nBALMjaWouVhhiRcAAmTEph5IfP9zr2+1ugNOlCRvyqkXvnCZ77uxIiXPrMptqEorVu8bpvnJ0T5zV90yF+iMqVvoamMdHixdEasBbteGALJhBcuhTPe1+3di0frj61+5BEDH1kk51o7Rw6DDF6N9e1HH7dhUqPbTpB1fdsPeTmjtyOn08P+LjfPBU58m65nl6FJp9gUXrrp68SrkUpH3hlYvbw5wRRIAh5hMVMKKiRKE3N/V2KIJRiDvzs/p2izbQqA1ZhpNWD5W4z/gudxXnL8DFpKUEOVViTshBsboRQw0xwJ8e3mscCjjnvpfZvdUDeiIiZr0FGq7LnugB4QIOGzU/ZUPKltYlmgnZM7gAeL/De0KV3W57bb4YYtMQFdIwFpqn4Dfrhs3jBt3YLZmOdQ36XkDHKkVJarmjsIZWlN1asn6lv0D79RcPGCwk1qHDVYpNTPyZqvFL7dTwVy0bBRkt4yZvh4WFgBrsx61RfgmXT47LXF6ZqV4ktMiM9GweEc09s5k7eaL8tmg1GgHVtB4KVDopQIHyBdjWchm9xVsMSycep9xP/T4W4Tl9CKVYfs92HxOHD5DzsMu0v6PzeygMW8D5RvU605Bcnbaa1Yb8CwAoIgUTmEDvW/7xoPuVLualYCw7S07g9qheww+8sbc3voH8yVBt8ybwBym6EYFaISabErZcj2OBF79DRw7MUkCTY2fRSYyqDxPt9XXhPr6GoB6/ZfKJUkv4a33r8OW/e6/5uJkvGGnWvvMytemI77tFKDrVQ3+G06iB0mg3iIMCLzy/mD9FmFnrbEl7bU5tPpHd4xn+57ULxJ81pmcHEa/WmdU8IbSRy214HokmJv2KhUaH+UTA5RnLCvvN9EERVot/8g/7hYQ1J1F
 ZPY8comT
 tGYj0CGRGMg+yodK1UNtayhdtJINAGU7cxLGUWTqvIoBzAVWyZOCPwLIJ0XxsUtciueA6gDfMActOzyRFVVBFhGspl4RLf5irEeGPe6+pJ2vGi9R9R1WvSvO63Y21E0eLB2ZYyD+PICddcYfqOn4r3gzhYqC8dSKSUnMetOV6sGDkwBcYKk5aP4Okt2JpglgNxfb9FlemKDcRNzG9MsDf652c11KKE9QcQ3AgKobPf3/yirtgqq5gi+badPQgKyRDBwic0h0Xj6Y25QzP/mTBL5NgIM2oWAC8BTc+unUu+sXGhYKHDnDhOEn0smzhNRjqo0km5j9WbLc8aEIl6xuUOA+CsGSM9ay3dbToxOXOXPgkSRg/g2ssmS/f5vWnB+4kHhSm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a single CPU is brought online at runtime
(cache_aps_delayed_init == false), cache_ap_online() unconditionally
calls stop_machine_from_inactive_cpu() to rendezvous all online CPUs
while the incoming AP runs cache_cpu_init() to disable caches
(CR0.CD = 1, plus wbinvd() when X86_FEATURE_SELFSNOOP is not set),
reprogram MTRRs via mtrr_generic_set_state(), and re-enable caches.

During initial boot (cache_aps_init()) and across warm CPU offline/online
cycles, the AP's hardware MTRR MSRs have already been programmed to match
the saved mtrr_state. Stopping all online CPUs in stop_machine (and
flushing caches on the AP) when the AP's MTRRs already match mtrr_state
is unnecessary.

Add mtrr_generic_state_matches() to compare the local CPU's
MSR_MTRRdefType, variable MTRR ranges, and fixed MTRR ranges against
mtrr_state (including k8_check_syscfg_dram_mod_en() on AMD), and check it
on the AP in cache_ap_online() before invoking
stop_machine_from_inactive_cpu(). If the hardware MTRRs already match
mtrr_state, initialize PAT locally on the AP and return.

2-socket, 480-CPU Intel Xeon 6985P-C (N=479, mean of 10 runs):
  Offline:   9.63 s ->  9.85 s
  Online:   11.11 s ->  8.69 s (-21.8%)
  Total:    20.74 s -> 18.54 s (-10.6%)
  cache_ap_online() (cpu479 online):
    7,704.0 us -> 4.7 us (-99.94%)

2-socket, 512-CPU AMD EPYC 9B45 (N=511, mean of 10 runs):
  Offline:   4.53 s ->  4.51 s (-0.4%)
  Online:    3.92 s ->  3.15 s (-19.6%)
  Total:     8.45 s ->  7.66 s (-9.3%)
  cache_ap_online() (cpu511 online):
    1,354.6 us -> 6.4 us (-99.53%)

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/x86/include/asm/mtrr.h        |  2 ++
 arch/x86/kernel/cpu/cacheinfo.c    |  7 +++++
 arch/x86/kernel/cpu/mtrr/generic.c | 49 ++++++++++++++++++++++++++++++
 3 files changed, 58 insertions(+)

diff --git a/arch/x86/include/asm/mtrr.h b/arch/x86/include/asm/mtrr.h
index 76b95bd1a405..0527e216808c 100644
--- a/arch/x86/include/asm/mtrr.h
+++ b/arch/x86/include/asm/mtrr.h
@@ -61,6 +61,7 @@ extern int amd_special_default_mtrr(void);
 void mtrr_disable(void);
 void mtrr_enable(void);
 void mtrr_generic_set_state(void);
+bool mtrr_generic_state_matches(void);
 #  else
 static inline void guest_force_mtrr_state(struct mtrr_var_range *var,
 					  unsigned int num_var,
@@ -106,6 +107,7 @@ static inline int mtrr_trim_uncached_memory(unsigned long end_pfn)
 #define mtrr_disable() do {} while (0)
 #define mtrr_enable() do {} while (0)
 #define mtrr_generic_set_state() do {} while (0)
+static inline bool mtrr_generic_state_matches(void) { return true; }
 #  endif
 
 #ifdef CONFIG_COMPAT
diff --git a/arch/x86/kernel/cpu/cacheinfo.c b/arch/x86/kernel/cpu/cacheinfo.c
index 13ed16527905..64796d5b34fd 100644
--- a/arch/x86/kernel/cpu/cacheinfo.c
+++ b/arch/x86/kernel/cpu/cacheinfo.c
@@ -770,6 +770,13 @@ static int cache_ap_online(unsigned int cpu)
 	if (!memory_caching_control || get_cache_aps_delayed_init())
 		return 0;
 
+	if (!(memory_caching_control & CACHE_MTRR) ||
+	    mtrr_generic_state_matches()) {
+		if (memory_caching_control & CACHE_PAT)
+			pat_cpu_init();
+		return 0;
+	}
+
 	/*
 	 * Ideally we should hold mtrr_mutex here to avoid MTRR entries
 	 * changed, but this routine will be called in CPU boot time,
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 67cf69f24b00..8760a7b4dc38 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -981,6 +981,55 @@ void mtrr_generic_set_state(void)
 	}
 }
 
+bool mtrr_generic_state_matches(void)
+{
+	struct msr val;
+	unsigned int i;
+
+	if (!cpu_feature_enabled(X86_FEATURE_MTRR))
+		return true;
+
+	rdmsrq(MSR_MTRRdefType, val.q);
+	if ((val.l & MTRR_DEF_TYPE_TYPE) != mtrr_state.def_type ||
+	    ((val.l & MTRR_DEF_TYPE_ENABLE) >> MTRR_STATE_SHIFT) != mtrr_state.enabled)
+		return false;
+
+	for (i = 0; i < num_var_ranges; i++) {
+		struct mtrr_var_range *vr = &mtrr_state.var_ranges[i];
+
+		rdmsrq(MTRRphysBase_MSR(i), val.q);
+		if ((vr->base_lo & ~MTRR_PHYSBASE_RSVD) != (val.l & ~MTRR_PHYSBASE_RSVD) ||
+		    (vr->base_hi & ~phys_hi_rsvd) != (val.h & ~phys_hi_rsvd))
+			return false;
+
+		rdmsrq(MTRRphysMask_MSR(i), val.q);
+		if ((vr->mask_lo & ~MTRR_PHYSMASK_RSVD) != (val.l & ~MTRR_PHYSMASK_RSVD) ||
+		    (vr->mask_hi & ~phys_hi_rsvd) != (val.h & ~phys_hi_rsvd))
+			return false;
+	}
+
+	if (mtrr_state.have_fixed) {
+		u64 *saved = (u64 *)mtrr_state.fixed_ranges;
+		int block = -1, range;
+
+		/*
+		 * Ensure MtrrFixDramModEn is clear so fixed MTRR reads do not
+		 * expose K8 RdMem/WrMem bits and cause false mismatches.
+		 */
+		k8_check_syscfg_dram_mod_en();
+
+		while (fixed_range_blocks[++block].ranges) {
+			for (range = 0; range < fixed_range_blocks[block].ranges; range++) {
+				rdmsrq(fixed_range_blocks[block].base_msr + range, val.q);
+				if (val.q != *saved++)
+					return false;
+			}
+		}
+	}
+
+	return true;
+}
+
 /**
  * generic_set_mtrr - set variable MTRR register on the local CPU.
  *
-- 
2.56.0.176.g3575e65682-goog


