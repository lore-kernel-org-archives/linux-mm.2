Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2ADCFCC6B33
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 15:33:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F34F66B0096; Thu, 15 Oct 2026 11:33:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE65C6B0099; Thu, 15 Oct 2026 11:33:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD4246B009B; Thu, 15 Oct 2026 11:33:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B02E96B0096
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:33:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 07E26C0533
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:33:46 +0000 (UTC)
X-FDA: 85325255652.19.E758AAD
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4681220009
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:33:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=PuNv4dve;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792078424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=72zF3yLWX3oeYl+y53VRvYROQBmMjAwdTi7nEp+9VUA=;
	b=goX7IBBKsEp3w2KD1+JpUdgVnnyzuz4ilTsiMDyEN6RyNNC2z5mRD4rZYmY31pII2nG1rY
	tBgFLyuTt7WG3WxVzL7jntRUQBLcI7WxRKke70Pwoa2/feYL8AsEuCVJhe3VYFtJECIMKr
	zcoB5K2IzUcVOSeqqC9rvlSzi73eX/M=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=PuNv4dve;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792078424;
	b=x6kLYUf5uQKM+8bq5gdxVrNLBJlGKoX96vyM32ICwiQ2PocfRTd7ZTxtrjk/7lnwSH2DSE
	IX6rFEME86p++gOrXj1ljiQEB6tDCxLle74yr7lTxzPdeTGbyXz6C2QBhS/6B7zNBmRBNv
	6YyiCdiwqs8oHgRUf5fer1Q6XQvvc64=
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-74ab6c88052so608203137.2
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792078423; x=1792683223; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=72zF3yLWX3oeYl+y53VRvYROQBmMjAwdTi7nEp+9VUA=;
        b=PuNv4dveY06f8feqtAnyzV2X66kWWXcLllSbV5lZSf8rOkbAWu5/a5SpdxRAHT6PoV
         shCihGAk1cSS9a46UsVc75uXp0YyzukmL313TWNYHVRj2IaT1IbQBmsghISOx3Z565P5
         c4VTxCN0HWAHOa2EmGQB0nDMYN+3dH4Oq/QC7hm9i5YSnfVZ9K/U/5QpCX6guqJm9q+7
         gPrlq4Rx2TI4J5oVlC3DEE3ZkNmo4lwnZeRvrsx3SdZn2OQ623R10M9pbSdf+E1ehGXN
         DYybJ9f85GnU+mTvWqPnlXDiFcUffr5Ri257gljhotRxb/qcc3YmJfPB3ENeGvfDGuqD
         mWng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792078423; x=1792683223;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=72zF3yLWX3oeYl+y53VRvYROQBmMjAwdTi7nEp+9VUA=;
        b=W5gCr0uYwTuqakpOxdaae9nUoV2+votMs9HYuftqAPjv3O9z+cFwPETG+GBFJ8j6TR
         4ZaV9U0YYjLT0dFTIdhVSaJlTjok3H/2D0O7sW/+BSZOtCjXAFJoFZuBX0kkHi+B/u75
         aX08eBy7lviLdQ/+amXEvuY/BAEvQQzUOE4nuAxaaS6E4zaMxtDbWC1Y3uS9FzOt/bu8
         /+iTSfxKbxMveoaeyeWLvdTUEmm6JUmubUhVNDUNy2KH241tdZEZBfwl5NJPPccFwgw5
         oJuBVkyg4x1YM5Gjelx3KdlxmUR8ik4CsaTI1Gu+IHRsPvnDlcErxOB2Z5lmkI3kHbiW
         f1mQ==
X-Forwarded-Encrypted: i=1; AKwUvBxgEgrQ4UH5Hl3zju2tn0ae+kEl5h5DBWa68VaTR2VPgg6CS8xnvr9S+X7ya8V2oV55m7YDmdMvKg==@kvack.org
X-Gm-Message-State: AFq9FYLKs1dF6zJcLLmUsB6k1y7PWOx9Swvm0kyvTcRkWtxAPfHLfbi9
	aoP9AMR9DgJZBZdfG38nPzwdO/9iaseIte7AIeQ6QDyGPPt9MykAjQrHI3/F+diFbMfP8OAKolP
	0qt04
X-Gm-Gg: AYBFou0GsBe9Ajwbwzi/2yjClsW7ZBfAMk1IjxKgc9mMSfkET/z9JGcY+qjQhtqTcRl
	90uj3AJRHIRjy8KB4gsNcrt2s9fq0H1pjtwJ6R117IvgaUuYiNQSuqh9zv2nRrfdyVovRpUwoyc
	R2+QvbdyDUY4NdqmXALYlk81gKOs6geGr3fAZiH8KGPxqlBd2ZKEVJiAT2QSUGHP3AcGjYJOGEq
	RbC/SFZQfW3XVRC2PrvUhx1BxfoY3/ekENomVZTj0CmA8dg0LFhpTuHD9J1+XAok1cyczHSQbfs
	RKi3nbDCy2mPFPpCzlzYOqk81mOHc1p5Dp8BtWeR7x2WdoFx3XzlDAWFAztGnbKMv0yME76MUZJ
	FHzlToFAF+rOn7fihDJr9HrF87y4cR7FJZJbSV266ZHn/i1eCUcxZWneUD2Wpyzr0IFm7KlDz+3
	KAh+z/CeYjcp/Imaa70N/JV0euXTjuXygl942CSHforGZYTVBjjRvAfwwyB6nIh7apj7kQ7LFmz
	6oynNqevHtlmTlGMcIkp2n5pMCyxtQezxX9x0N9hOXT/0l51zvw/t02hMuTCw7QWZK91RjJQ4UO
	zlV8VmoXhf+SCiDUHgM=
X-Received: by 2002:a05:6102:c4a:b0:7a7:19aa:f0d8 with SMTP id ada2fe7eead31-7cb37b3015cmr4260402137.37.1792078421907;
        Thu, 15 Oct 2026 08:33:41 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-99003f66ad9sm12986347241.10.2026.10.15.08.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 08:33:41 -0700 (PDT)
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
	thorsten.blum@linux.dev,
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
	tj@kernel.org,
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
	longman@redhat.com,
	bsegall@google.com
Subject: [PATCH v1 4/8] x86/cacheinfo, mtrr: Skip stop_machine rendezvous in cache_ap_online() when MTRRs match
Date: Thu, 15 Oct 2026 11:33:27 -0400
Message-ID: <20261015153331.1872641-5-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261015153331.1872641-1-pasha.tatashin@soleen.com>
References: <20261015153331.1872641-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: k8u95pf1orku89bb618aaic17brpgj6k
X-Rspam-User: 
X-Rspamd-Queue-Id: 4681220009
X-Rspamd-Server: rspam08
X-HE-Tag: 1792078424-314469
X-HE-Meta: U2FsdGVkX1/xnEE1jRuyEbLJemi4M+vH3/lLmBkn9q3N+ascfDfnvqFu6IAzJhTuqmLlKUlyGEfQKfzA88xJloErNJwozKl0Y2uKLhBQDsrmDnBABOIb9K2oky5pBBBBYkiCtnD/XWYqOZYMLeuuRJzaCRAx396nB6lW2vKw5I1U2yHacyd0ZO/lE4fvn1YPJrj1nFauA3gJTBOVct69YMNq6rlCmyZYx6EjKZWZvgFx9HKdTi4LP4GVof3tyHZiba6NdbdsVdhWEjltqhR8qhc0ytI4lve7oEvt6ErTsOcpAqWqMGziqUzOAFmq5VMi2D+kCReYQ8ctwm6l6+srcYA1++fCTmLMwVqHSXwDLFJrzfywGJHmP6MxLmGfU36CDYjBIJVoGMFIxngvXFPa21Z0b3oj9K0xk2bSNfbnes9Ff3VeesqCQgcJ5cWEX2xvh/JQ6UvU2w3Pi2W1dCPItWw+ILXAw2Ak1AHguf6Faeo/gHOTrVUmIBuF2VQcy7J9wdndPI8XumFs5Uu8XYTZVbH0MmH+Kw/ABcj+rzN/wmxgG0b6LHLiz9RzdBvp94nGuoLN63S9J18vF1noHthG+yVmF0e3PalTqYkUuXf4Qgcy82Zp0jSNYJbX3mT8LTahZIu1SpIsPEfT2hOdUSkutLTjueSeMoOvwrMgLRdDdGEoGF+fQTzdD5W3W/zeFZd/5Yep3XzfgznJ0KilAXq7sbPx+UrKU99taIFz87sORx1rOxlMeTWfnWKB9M7c25285J2EWOblTjhc6GXgKACgaCtvon7C7jVn6DMi8wJTxiX7QMHVMzTGOQgQIl1hOpl4la6TZb9LJgVue8B0m2RKOk+GtE+Wzu3ghVAL/TzbuBHlnVzIgE4DjzfK0Sae/e4imsn1aTWavW8vzYuUEScnOoh9X7kQrsqU1r/6RZX+MDfnyoElpRRC/b7x/fpLs+njMv4eVyRYWmOa5HE55g8
 x9jLupy1
 qOBZqw7CuQaKyvSQEY008jQBJVjGn1KSjVUWvyHd3/0FS6AW6Op25Emi6vEiea/qLx6e6c19MOQCr5KWjzaYHJzvONiWc9p43OpIN9ChSTUQIygZMX6Ydc1hn8469x2WOaiVwYHAADwLI6yerPoHY8NG+x6pL7/KIV1CMRfZuSHAtot7QUxjsbqjvxCyxiA6z4fQuE8sc6NfPQtgmvaVMaoXrHSHf5td26IUjbCI4rUzmckTuZniQFpYP06cc4+tJT0nugK/5j9Xo5cCLu8ohbc51OSztQmrrbohY/yNg6w2STXPpnb9MbnGZkqhXx8aN6/Cx/TsE2NcrDmzlo3C4N8AIfsRtrc5SyXJa/3RZ7RmUAF/tVJUv6LFEJdI46oYbOvFF
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
index 76b95bd1a4058..0527e216808c4 100644
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
index 13ed16527905f..64796d5b34fdc 100644
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
index 67cf69f24b005..8760a7b4dc38b 100644
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
2.56.0.385.gd3acb90ef8-goog


