Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE217CCF2D4
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 01:15:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC1086B00C0; Sun, 18 Oct 2026 21:14:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C49D76B00C2; Sun, 18 Oct 2026 21:14:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B12296B00C3; Sun, 18 Oct 2026 21:14:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E1766B00C0
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 21:14:58 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2EF5B1A061A
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:14:58 +0000 (UTC)
X-FDA: 85337606676.27.792FEB0
Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5BEAE180005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:14:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=S4jWN9HP;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792372496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r5Uh0UovwmV8EFz8GLwox5sAAEwyuEzq/FgIh/SpVjc=;
	b=5UprDP3nnUkjdvclKhhxELEH/8Ikd3Ce91Hp0bwejg+BmeXUs7TGeDUfQXK/v3RELuKeyF
	kUcfUsOarRVBuHB0g9oDgjossSg+LwwgFu5dHQflIhbyHdmryxOoqqm2hzWUOOLZ04mNZ9
	jQMxrPQmsLoahLd3W7N1vrbZ8CbOo44=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792372496;
	b=hZ66wFx9Sr16Uhqa6lZ5/M7kx6/vYcEM0ThlZocdSR9PmrsXabVyZV4Df5Zs0s7R1R1/JY
	YGJdcO7vKGQNLZHUc4h0OFuUnTnENpe0s0zyCKd4iCVLQni6Pj24ko0j69vIN+5h7yN7t3
	08NpARN75rfDBHIVmctQTohb1rBYIWo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=S4jWN9HP;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-5eabf243d05so321376e0c.2
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 18:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792372495; x=1792977295; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r5Uh0UovwmV8EFz8GLwox5sAAEwyuEzq/FgIh/SpVjc=;
        b=S4jWN9HPmDE9xwQjU3giqk97GtNrAFqgc6iF3Se11IuUxboEok3NNlBPT5sqC/eMPY
         Ek0KkgWGhRpn63ZGxRq3qwI2QiMLOy8CJxEpJjQoMHhSbyp4G9Q6hhASbkLjtJGvegXk
         D4Sc53JAmBo+fzB0riBi2Ghw8E/MwgvB67/w815/27iOPj75gZDne3nzh7GA/yfcJYF4
         +4GQfwPVHSfcoqmqSwBPLvX4KRFmbKvD3nHoiGTqwqI/jbDseEqpPc2gEhqwA8iG7Jiw
         CY/FU8svbb7Dd6gn91KISzNO7raqtc+CY9knleuLzvGWOTIZRYH3LJE+c81zJkVWl1I0
         0kqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792372495; x=1792977295;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r5Uh0UovwmV8EFz8GLwox5sAAEwyuEzq/FgIh/SpVjc=;
        b=Kw5+lC3kmN75+BW85s4OMAbc4XL8obXt1KjZuMXLMGnGXPXiBdu6Za3OvcldidAbCw
         kCUEl4WSJZFDhi0HQcgajr07yu7UaQFCh5eGU97uahdKOCZqCFObweXHH2PLNgkf2Vzd
         0VmXHT1oxqRxaYkEXAeSd1sZKo66X0Z5GtnRPDrlBrc+nnWQXuWrORjSwpSX0+LrZJub
         eFpaa+BIVZapjmyLuHB78kQOI4Ujuj6CNB/ZXVSI2c8nK/59z4QE/M0KhzTcfUu0qeNL
         NgcuMUnzmUyZ8xnlmJV3DpxCvX1QtUtsQuQvxDrNSQqdFrkfpp0ipDmmZQ3Mkl4EaVgY
         OzwA==
X-Forwarded-Encrypted: i=1; AKwUvBxJ6+/ilN1itXvWGg7HA5LLTtJnwypwQ/FmuPbhSt3upMHDC489GZYYepIQ8BAUyq6Qtyngtc3nPw==@kvack.org
X-Gm-Message-State: AFq9FYJlq7eFWLPdXQxNFMegXph4sBAoXvM7QzG1gzyJQXrdv0s4Ihtd
	5RNwJbvE1VovQ5FPhEtFmhk1uz1x308XXPTuLraFv/k/OkQ23bvBxRquwfkdzaXjQiw=
X-Gm-Gg: AYBFou3XUJxWE2uHSLbFqdVH5FQ2EK7wUTw9ZDp/lfXbOarHDiLri7QL72Qq71zZztY
	Qa147teJpUVi3FzDfvmDq1pwg0Tr/UszUtgcdAwaGlK4Ps6UlfxLStFErecitLHTuK2HiMqY2pJ
	Y1AA/uBYE7VWRpRM62L7YQ5mVQNbUY8SUuKmThZGnPVl7shysKkux7HD4FhzD5ngBaE43ZuMBBU
	I3Nk5Qf7ennYlAx64FQvXY63aSc3OHMySirMq0a0qfSRB8foTSqYbyOMZy2zKxXK8vkVwkJvJsJ
	ANIVuvMCYeohyBpEkOp6YuGOVPqHh4YC8WIyhER3ciDhr1mCUaJvNtvWaWYjggqZ8Khe8gSHehj
	2dOa+fcpLb2H3GJeyoG2V0867ZMIOUykn+3iM0VitMYb+48yizHrZ6fsdv9+rJXpTazU+FA0Jug
	Y6dJ/HzCgQlKLV0PiLWNqjCpqKw4bFHueThqPPWP0nanzRZ+QZervwsTM/1wBagoWhkFI9b5zsL
	LKTw//vbSqldCtFJMQlUhzoZGKblloP2OBCfvfP66K125Mv6VvtPIzR75k5lUl74fTcjLWf8TvW
	tXYIJ7ErdcehRkCxmNo=
X-Received: by 2002:a05:6122:10e7:b0:5e7:e3f9:1322 with SMTP id 71dfb90a1353d-5eaaa4183dbmr1605940e0c.9.1792372495503;
        Sun, 18 Oct 2026 18:14:55 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ea9b474b2asm8039142e0c.4.2026.10.18.18.14.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 18:14:54 -0700 (PDT)
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
Subject: [PATCH v2 2/8] x86/smp: Remove unnecessary WBINVD from mwait_play_dead()
Date: Sun, 18 Oct 2026 21:14:40 -0400
Message-ID: <20261019011446.834487-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261019011446.834487-1-pasha.tatashin@soleen.com>
References: <20261019011446.834487-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4sut5uenf5qjiqyokajrcwmagxjqg1r5
X-Rspam-User: 
X-Rspamd-Queue-Id: 5BEAE180005
X-Rspamd-Server: rspam10
X-HE-Tag: 1792372496-877000
X-HE-Meta: U2FsdGVkX18ZA4RgcA1wBi72fruzLq4cOvUjT7cVHb2Ulnf2zl6FFJwepWFZGe9XaU374zgg4IKcLfLrF/Rb1bLc4uY/0aVT0wCp6m/s7X31G87uIgG8LeMF7qyIbh93mDrwD2J7xb27cO8ITbzpxldd4dKo1nVU3o5QensDU/L9zFHDIbQs9AK0eHwxgucvEByb3h7lZfiPKUOTsfcn1GPQXlx7yLTWmY+eyjurgCKP44xCoxwRXNZ4FyvIH4MKmoxcLONP2noNrqAZxF4IZhNTSeHSyadSc4u0kRViN8dz1PDxu/ytgfuMPdzNabucGmf4PyOyw2mYVEX/QFMIonr+OlRdJqBG8tAuBH4gcZwSP4dFE8svCZR+7pR/aYbPyyA4uon3CoJsPt3CFOqvcB0CkAf0gM2IHMxRftapW2OPi+cN2jiWPJUkhH2q9Lc27DXdP+ZLNLvgibX38rnWGmb33noG07cpeDiKlsS0c9qGv+ZLwFkUR52fZ76sJYy/MmZVAWtQKzYApZU5+a/Q6MKASXen1dq+Up/2D69y3UO68DhOD9gZKoiZf2usMkhgFssANBa0xOaqu3il6BKw2fvg95AbL1uEaxwSyzQ6nO/W6Jym0T1hmwm0MFUwr6CX3O3DIdSpM+qNvGf9nXhOUIcAAXe66P5+imzYiAiH4GQYColh795jjh4t/58f5bTHt3wFRgE1UgWXFOEYqXEfO4MfK8JbQ3gYIRVejAhhYr0Fz3UYXbrpovndwpdyMO2ijwjSNCCk20vYub11YVa6Z5tqzNvYCxLPL7DiGUQqhYLjfjb5Zct6oYCka3hdOy/CkNXxXxda7YPiiJcg59+Rr9+VUPPbT2b64ZHxOpluhcZI4RrgXTiVRykQcrGSZVmNMSdAlWXXvykDUNwvZnZrmH2vyoU6OE4uqFP7z2WoegxepD1zy/wi40Fes1559GCCm/G7e9/zFP8LhcGwC1f
 IxGqEGqR
 dfKMtTdwW5t8q3xzCvn6ZVpxEVngilWXjvndTsxr/v6hnpXf6XKapdtCqFZiHu73yxZELWarvkRsbufDyTRFVje7x19kPUQUV9/zdjIdx3ukAlS38Bvksd6nwFdvrkdEJ5EJnFBeAR/k1mSKneVOn34xPqLVjGBNQ+K983v1oynpVeZHVZ/aPbzBZLiAHTSpUYARKysSukEFjWZYIvZnafaXlFjGEcAa9ic6ROxEWxG3nUrXU4oBSwvnOlZWpcCH4UlG5s2YiMnptZUwtTU5VYNqogGv5pVsAQXjLDlepIBAGDt5xKjMOD5Wx01I1qX6qn0fTkUq3p+7x2HZy97jD6QpMT8MaXXyy+UGJJDJ/PvaOjqgXFPnei9leadDjnwoQuKfp23XtvXKxq/pE+CLLtJG6w0RNE544fCah
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a logical CPU goes offline via mwait_play_dead(), it executes
WBINVD before entering the MWAIT loop. On processors with large shared
last-level caches (such as Intel Xeon 6985P-C with 504 MB L3 per
socket), each WBINVD takes ~85-115 ms, flushes and invalidates the
entire socket's shared caches, and stalls the physical core (including
any online SMT sibling on that core) for the duration of the flush.

mwait_play_dead() places the logical processor into an architectural
MWAIT C-state—the same hardware C-states entered by intel_idle during
normal idle without executing WBINVD—where C-states deeper than C1/C1E
flush core-private L1/L2 caches to the coherent LLC on C-state entry
and maintain cache coherency while the package remains powered.

As long as at least one CPU sharing the same LLC on the package remains
online, system-wide cache flushes (wbinvd_on_all_cpus()), system sleep,
and kexec will still flush that shared LLC via the online CPU(s).
However, when the last online CPU in an LLC goes offline, no online CPU
remains to service wbinvd_on_all_cpus() or flush the package before
S3/S4 power removal. Similarly, if the target MWAIT state is C1/C1E
(which does not flush core-private caches) or cache_state_incoherent is
set (e.g., SME), the CPU must flush its caches before entering MWAIT.

Skip WBINVD in mwait_play_dead() when entering a C-state deeper than
C1/C1E while another CPU sharing the same package and LLC remains
online (unless cache_state_incoherent is set).

2-socket, 480-CPU Intel Xeon 6985P-C (N=479, mean of 10 runs):
  Offline:  40.46 s -> 11.42 s (-71.8%)
  Online:   11.14 s -> 11.08 s (-0.5%)
  Total:    51.60 s -> 22.50 s (-56.4%)

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/x86/kernel/smpboot.c | 46 +++++++++++++++++++++++++++++++++------
 1 file changed, 39 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index ba01a9e919b7..0dccd2f927bb 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1414,10 +1414,28 @@ void play_dead_common(void)
 	local_irq_disable();
 }
 
-/*
- * We need to flush the caches before going to sleep, lest we have
- * dirty data in our caches when we come back up.
- */
+static bool mwait_play_dead_needs_wbinvd(unsigned int eax_hint)
+{
+	unsigned int cpu = smp_processor_id();
+	u32 pkg_id = topology_physical_package_id(cpu);
+	u32 llc_id = per_cpu_llc_id(cpu);
+	unsigned int i;
+
+	if (cpuhp_tasks_frozen || MWAIT_HINT2CSTATE(eax_hint) < 2 ||
+	    llc_id == BAD_APICID || this_cpu_read(cache_state_incoherent)) {
+		return true;
+	}
+
+	for_each_online_cpu(i) {
+		if (topology_physical_package_id(i) == pkg_id &&
+		    per_cpu_llc_id(i) == llc_id) {
+			return false;
+		}
+	}
+
+	return true;
+}
+
 void __noreturn mwait_play_dead(unsigned int eax_hint)
 {
 	struct mwait_cpu_dead *md = this_cpu_ptr(&mwait_cpu_dead);
@@ -1426,15 +1444,29 @@ void __noreturn mwait_play_dead(unsigned int eax_hint)
 	md->status = CPUDEAD_MWAIT_WAIT;
 	md->control = CPUDEAD_MWAIT_WAIT;
 
-	wbinvd();
+	/*
+	 * Entering MWAIT C-states deeper than C1/C1E/C2 writes back and
+	 * invalidates core-private L1/L2 caches into the shared LLC before
+	 * power-gating the core. While the CPU is still in C0 prior to MWAIT,
+	 * its L1/L2 caches remain coherent and snoop external cache flushes,
+	 * and once in MWAIT its L1/L2 caches are empty and all dirty lines
+	 * reside in the shared LLC. Thus, as long as at least one CPU sharing
+	 * this LLC remains online, any concurrent or subsequent
+	 * wbinvd_on_all_cpus(), system sleep, or kexec will flush the shared
+	 * LLC to memory.
+	 *
+	 * Only flush here during system sleep (cpuhp_tasks_frozen), when
+	 * entering C1/C1E/C2, when the last online CPU in the LLC goes
+	 * offline, or if the CPU's cache state is marked incoherent (e.g. SME).
+	 */
+	if (mwait_play_dead_needs_wbinvd(eax_hint))
+		wbinvd();
 
 	while (1) {
 		/*
 		 * The CLFLUSH is a workaround for erratum AAI65 for
 		 * the Xeon 7400 series.  It's not clear it is actually
 		 * needed, but it should be harmless in either case.
-		 * The WBINVD is insufficient due to the spurious-wakeup
-		 * case where we return around the loop.
 		 */
 		mb();
 		clflush(md);
-- 
2.56.0.176.g3575e65682-goog


