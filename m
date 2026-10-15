Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61CB9CC6B3A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 15:33:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8305C6B008C; Thu, 15 Oct 2026 11:33:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E1116B0092; Thu, 15 Oct 2026 11:33:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CF4C6B0095; Thu, 15 Oct 2026 11:33:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 37C876B008C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:33:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8F956A88F4
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:33:41 +0000 (UTC)
X-FDA: 85325255442.30.28C3851
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	by imf02.hostedemail.com (Postfix) with ESMTP id B89E38000B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:33:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=StouSDC+;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792078419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j4tKjkoRHQBs/0qfSCONCIuiBtr3cfqRy92h/STkCYg=;
	b=x56BByn4CSrYAzRRWScbNwVOOD8Cc8Se+LBkVIMVDsAwJwP4jcVmA0HS9qz4AATaINXNHN
	C4OhUYESl5MkGXoaFtb4qzgBt60TDhUsGBYUQ3UI04OYSjFDOy3DNPFF3SgktbG/jCTDEU
	E8C77TNWOVzLvhDiLD68ZTXRx+ZOBl4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792078419;
	b=yEbmiVVEn3CxDxYH7rkIs2qAeKXC1LDdkIvHXD6Ia3gL8Zzgw6AJiLOdL3HgR0iApLIngT
	XrgezKy9LZ39GrFhpnpTbAzoX8B79eSKKuNUo0w35p2nVV++vl502IDXBUW+uEqYlqqvGB
	+0ahIRlJA+GudK038R2h0JAYiyKLqAY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=StouSDC+;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-74ab99038afso3462170137.3
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792078419; x=1792683219; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=j4tKjkoRHQBs/0qfSCONCIuiBtr3cfqRy92h/STkCYg=;
        b=StouSDC+0+CfhWWAjJeqycWmKAqt1METC/tMJwgGjW+3ISuQhOCNPog9QOIkMtX0WQ
         zYuBduLf4u4xAM2LIODQRLOFEqYSlgUO2MEvVa/lIldhoSPJhWmBuUgyIa5YkEWx8kY9
         XPmgqchJn5c+HAdeykZemSKCb5oIHssmrfQps4/efx4RZXiCO02oCPKryozaBRdK1bnN
         zG2FW2rD+ydrRi/r1nGJlyXamuIS5dpJbbXftIIzfTvhxzEv54LTw5x0/GavRu4TKCcc
         KusvI3TKWgvDjPAIFK/BT1MtLUeBzSqJv6RhsEINrx5USL6mkPr6/SiOSkHDJNYdJY0N
         PDvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792078419; x=1792683219;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j4tKjkoRHQBs/0qfSCONCIuiBtr3cfqRy92h/STkCYg=;
        b=wvjN5S8HZhZJfnNPZnzCRrQewfDObG3VhKbIOkpb5nZvrpDFsZudnKTV4UJ0cvEykp
         KPyJhJFvB1P9EJNBzPi5VcuxjMZfJ208PA6x2GDKTn8YfXd7etP0r+wxgE5njRTFLqdI
         2H/+fc7tL4rh/4JmYRhRZNIbJpwqGdvvAZPglKTrDVjjFSCWI8btYglu6Jvkg6Av+x2j
         xQrUA5PyTi9qjoS1APpUf2fU0I6Dpr1spwq+SL+b11vHPiqs2/NtQs7SnFy44hcHwb1d
         fDL6Sdw1fR/tPTvLtJLiFWWg57+NpFw1/jI9anx9CHJKCiyQPdlNiwbc9rAtk/NvY6Ux
         IYEQ==
X-Forwarded-Encrypted: i=1; AKwUvBwrdbIBDf+YwPXl66d/XVIsI167/umAMM99+J/0O7tTAQsz5jh71qRZX5vQR4rSErTynVkBtoUUTA==@kvack.org
X-Gm-Message-State: AFq9FYI0wTUcgjxF/TN+PYPtZuVxrEtrOSXjVESLlYwnwiP4NewcY6cm
	63ViGJd1uyfYs+aJ+CQdmREu4os0KXRjUb3TXNPjF2CySRxkTKOa7gwjwOwUJE4Yas0=
X-Gm-Gg: AYBFou266qad157UzvAMdO80iT0TDINYT6v9GkTw2C/Fz9BGZvh4gDXXnD8+/R71sXC
	qkbdaH3kNJ3b1CJ/hHGuGiP87C11wJ32wZ1XGTuMAT4KRrXgK8n2fKonsnUuAxpCc2I7QenSg34
	AZsJkMjI5qSVaGGKZxolmc5xTOASy8q5lMFZHi3yCNpCZ9X3lsLsBnHkN2nYQNhDpJ03N/NvqVW
	OlYQT0vDTcCUFD/enV5d4lDNZDYINyvh2qPuMmOh3uFzR6aE6DlOmvVClWNrmwYDtKAwmwjSspW
	6gKeRGmaGyEt1P26X0WtFBEKGBWsHawGC8V08HTxk7iofpDrX8NFiN6o69WstoDIZnCPWp11xRP
	QTNKIMiFfc5rn0eRp7dV5mb4QtIsoL9LdVO6y8m9TdnEnBRdg7tObxLGkrLHJJLJxGS4ZnCDWUG
	GB0aqqufGuMalIQZKwo2ybRtoYSTSqrLMXDfKg0H6gBxbPG1q1/RUsN4YnLAcFgq28JdA+fBkF+
	kPNeqL+Gu1XjHKScBMgQWaBJTx9kAdfXd8D3ZFsmLfDdlIahS4N7RSSLMxlbPqBkgvDd0g8nFdF
	hHbRd1o2o1XJw7mtP2xI9SO0iF4N0g==
X-Received: by 2002:a05:6102:5110:b0:7c8:448:5237 with SMTP id ada2fe7eead31-7cb3a0e2580mr5832272137.24.1792078418833;
        Thu, 15 Oct 2026 08:33:38 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-99003f66ad9sm12986347241.10.2026.10.15.08.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 08:33:38 -0700 (PDT)
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
Subject: [PATCH v1 2/8] x86/smp: Remove unnecessary WBINVD from mwait_play_dead()
Date: Thu, 15 Oct 2026 11:33:25 -0400
Message-ID: <20261015153331.1872641-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261015153331.1872641-1-pasha.tatashin@soleen.com>
References: <20261015153331.1872641-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B89E38000B
X-Rspam-User: 
X-Stat-Signature: ufra3m6c8c3y5fdkkm8c3wjkg8qfgkj8
X-HE-Tag: 1792078419-482977
X-HE-Meta: U2FsdGVkX1/urDktBlSsUH7MUEYlYM3ltyCfjpJV9e2vjpgXxPG3uQwuXD2GybxPHmsRiZUt61On6r1s1CMwPRkmifUz9DMQV0++ktpmm48Qqn/dCZNTgN6sIkpEelW0eylZzob1CK7o+74oz9Xxqn64NhzUXefF7oSaU+9F3/NEKC4MPHTCH7J+gq4H4FLFkLus3qIK/SYRqsr53QNEJQSDu0gET6lQJsNc1xGfD541rk3TiK/JKWaIVZUtH0Q2cWjYKgeTfgyGtJW5/W7RaGbbfmnyU+GxIGG7l0e+1YUT3TTcChlHlCNzv0/YQ29yPc7yY8Q9x2WynOAospEHrOT2LjhiTIVxjyhqVy198ykVMp/SvQHFs9hmrhDV2NqTsvwRgXyRkBQL+3NePfx1ICEgigF2Nogz16eBYhI08Ld+8B4UA9sO6M3BudBVL4NAEBIVv67gXmIeY6mWp5h7UpxGBiSLM4pZmKioJaCPV754Pg7zDFoddVozNFeYJ2kTutsYk5Qy6OLzRfbYHqsTOybWUfBH433IdR/H6PB73uMuMSIm0eP0ELsy7cPu+sPn6xONH9os0gyCHe6qdsheyo8T3rfzb0RPzOiwkh5SmXL/Q31Jy6IpNa3L4HlEMqGffhY9M64KbIqbFiY9vJutoeDP5EfU849hSwu4i8rgZvsJW+nsPsB1pGVaklxviEBg/2u8aePaIDd0yPnzpJsLKvnOFzCL+z85y4flpFt5Nr3g/4Kdw9y+apQfxQlJgx8jjyNPUwFCPDY0lssCACU6l8pnMY/QUUMgvdPE/bpNtZrekdSnNPsO3Ndc2TjEH8QY2DgbhzZasOEI2E2veRVar6ZBMbbVSxvwb0bmoMh2W/qSYV+kUqhb8cbqx5oMjY3nSH3ao1ym76zmRSJs8aCy0LnX+5wAOJ6xW+BT+shjrWIAO6rq8Eh8OcLShLpIDYoMv5V+LLk0ookTRBnk9GW
 nQjM0Lak
 612jA8AqlPLsqE6OrFJiPNa38zCPdw5vlnEkxR5J2LFtvGn2YMNvrBRxZtUKu/Zkety5pPvMXh2AEZzbuHoQ0IcrtUiQy3q0f0ttZk9+BowIbWohgVw5mEjZN/yxkHQPS5QQYXaD27C3Yt+qz06oycVWMpX0BvjnI6b1Ha5/et1CVTLG7KTdSwqug/diQhMuNaz97xuKGWWcoHMOxW8pmJUXASUKD60ZN2lmrFgr2tkSc5t9ZVoXxElCXn23hlyBvZ11i4QWCNPKoMkVRowsb0Fc/y4Umd5X3SjmrhxQYxpZiIzsiWsbESKoGTaCSVIOO2juGL3+mJnMqvf0TSPYr4GhrVaUFyYRqux8/IhrMBvXcKc/wr9JNaQgGUAC4v5TlHnkwxXHBLXAUbKRw87jVp+JZ9yboDamvqBYG
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
normal idle without executing WBINVD—where hardware maintains cache
coherency while the package remains powered and automatically flushes
core-private L1/L2 caches to the coherent LLC on C-state entry.

During system sleep (cpuhp_tasks_frozen), however, power may be removed
from a non-boot package's caches after all of its CPUs are offlined,
and the sleep-entry cache flush on the boot CPU only covers the boot
CPU's own package. Skip WBINVD in mwait_play_dead() during runtime CPU
offline and only execute it when cpuhp_tasks_frozen is set. Note that
wbinvd_on_all_cpus() callers (such as cpu_cache_invalidate_memregion())
only reach online CPUs, so a package whose CPUs are all offlined at
runtime retains its cached lines while powered.

2-socket, 480-CPU Intel Xeon 6985P-C (N=479, mean of 10 runs):
  Offline:  40.46 s -> 11.42 s (-71.8%)
  Online:   11.14 s -> 11.08 s (-0.5%)
  Total:    51.60 s -> 22.50 s (-56.4%)

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/x86/kernel/smpboot.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index ba01a9e919b78..60a781dac9991 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1414,10 +1414,6 @@ void play_dead_common(void)
 	local_irq_disable();
 }
 
-/*
- * We need to flush the caches before going to sleep, lest we have
- * dirty data in our caches when we come back up.
- */
 void __noreturn mwait_play_dead(unsigned int eax_hint)
 {
 	struct mwait_cpu_dead *md = this_cpu_ptr(&mwait_cpu_dead);
@@ -1426,15 +1422,21 @@ void __noreturn mwait_play_dead(unsigned int eax_hint)
 	md->status = CPUDEAD_MWAIT_WAIT;
 	md->control = CPUDEAD_MWAIT_WAIT;
 
-	wbinvd();
+	/*
+	 * MWAIT C-states keep the caches coherent, so runtime CPU offline
+	 * does not need to flush them. System sleep, however, may remove
+	 * power from this package's caches while all of its CPUs are
+	 * offline, and the flush done by the boot CPU before entering the
+	 * sleep state only covers the boot CPU's own package.
+	 */
+	if (cpuhp_tasks_frozen)
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
2.56.0.385.gd3acb90ef8-goog


