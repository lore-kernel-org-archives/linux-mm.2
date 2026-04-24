Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00548FED3F2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 19:17:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DC066B00A3; Fri, 24 Apr 2026 15:17:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 546B96B00A4; Fri, 24 Apr 2026 15:17:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31DAD6B00A5; Fri, 24 Apr 2026 15:17:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 192D26B00A3
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:17:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D7CCF1C01BE
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:17:08 +0000 (UTC)
X-FDA: 84694407336.12.D3B264C
Received: from mail-dl1-f73.google.com (mail-dl1-f73.google.com [74.125.82.73])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1CA1F1A0004
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:17:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FLorAVft;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3scHraQgKCDooparajoZckkcha.Ykihejqt-iigrWYg.knc@flex--stevensd.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3scHraQgKCDooparajoZckkcha.Ykihejqt-iigrWYg.knc@flex--stevensd.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777058227; a=rsa-sha256;
	cv=none;
	b=Rq5KKF+786trIrKfGb76QWCy5+d6/SVk26gOLTN+5utVfIcKCY+6jC1hngciWnqjlAgBai
	R6IIjk626IS+ZR8UbsNRMkeR5hFV0tlpBfJphp7H88hW0PTac8X+liQ79pNOlBG0IGmL8f
	8ccvCSfwlOlAStp69j44USMXBg1TPt4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FLorAVft;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3scHraQgKCDooparajoZckkcha.Ykihejqt-iigrWYg.knc@flex--stevensd.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3scHraQgKCDooparajoZckkcha.Ykihejqt-iigrWYg.knc@flex--stevensd.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777058227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RwTIWWS6PoMEJey7EJLHssvqaQ5r36vA2Bmz8LkSSZY=;
	b=zM13l2thmYft+ReFb6Z5FmCix2QV9HfmSECLw17C0eL5fO6GTwRvQNPrmuXXWYiZim8oBf
	gNo2MPnkz2mlMVlvsttLXrbRnbUTxydRFQKzhd+TIbXyadE3TDKTflzVRJ6ilzXTT8GYn3
	x6RmKGUI7JOQq6KzGPEHATVh1tQtf70=
Received: by mail-dl1-f73.google.com with SMTP id a92af1059eb24-12c91ef7009so19770126c88.1
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777058226; x=1777663026; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RwTIWWS6PoMEJey7EJLHssvqaQ5r36vA2Bmz8LkSSZY=;
        b=FLorAVftSiCF1rx8M3SsgVThjmxntm/Q9lHLH+KKZA2j37MECCQpKLeWicS+HDk4yA
         3EUciflgMrgDKEij1d1MXn0FPYCzTiWLEyYMfgLrqu4CsE9kIen3xJnyUspfdfuV+m/k
         tCVGX7hQAAAvQkUyf3o+Xbom3g4I0Vz6ehkOEpJ5wwibuSwZg+yxp+Q9TeJki6nh+bMy
         +GkBA1eebR7ihup3YZV6PcYJY6tlKx5wXuuIu5Bj1s/n5IOVCmCrwgRFuw8ftzcIlpWI
         dTaCS2ZSK02fF5pb6wfhWyOZEBzkEseoAJa3FeCo51XT9aNz/WdyOenagqJt0AtFwqh+
         9Q5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777058226; x=1777663026;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RwTIWWS6PoMEJey7EJLHssvqaQ5r36vA2Bmz8LkSSZY=;
        b=AE3bfVHaggZBT4y09UrinQsEirandr0e4bhH6ehfevw7GpJTZPzWg3fGAPl9ob7pBt
         Rt7kJIasNQBhxHZ672bAx/X7FLnM+4Qe48bw/tVMEuOdajlRG6FSdFskZ56TIiHNYY/y
         qGeqP+LANxUNWRgJR5os8cvzLZ28jneBH38BMdqua8H0tbBM/NSzczs3j8GLh7aFCD++
         mhXI+KEx18/j7IHLDS/mPeaHYat3q3IWPWUJxtUrQMr/fZtqwI2WZ5i0F4iGLE9sWiVO
         X8pLKRHYZ80AI3mqxhDVo2jXqS03FWSjWxvpQAn0/szd1nFm75N0Fh1g0z+XdlHZue4/
         7lsQ==
X-Forwarded-Encrypted: i=1; AFNElJ+pWrtqtGZwEI6Q2rrNuzLzbI9EM7qscdKO/uZ/T8GBkaTV0O72zzsDuyQNI1P8g1lg47W6JyaeBg==@kvack.org
X-Gm-Message-State: AOJu0YyDuEHMiO+NjmOjnmeODWdjIhrv0A8VPCZs6cTicidOLUlFs8LU
	SSbmb57KiKOsqwMoS3dg7NeEPKpApe17db2BkzaovqEyhrjyfrVJAI4yJh5V9mEIdJ+LAZmSS0Z
	v3twlmiLXsTR9yg==
X-Received: from dled1-n2.prod.google.com ([2002:a05:701b:42c1:20b0:12c:5513:fb7d])
 (user=stevensd job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:3d0e:b0:12d:ca31:f19d with SMTP id a92af1059eb24-12dca31f3f7mr1182426c88.28.1777058225702;
 Fri, 24 Apr 2026 12:17:05 -0700 (PDT)
Date: Fri, 24 Apr 2026 12:14:52 -0700
In-Reply-To: <20260424191456.2679717-1-stevensd@google.com>
Mime-Version: 1.0
References: <20260424191456.2679717-1-stevensd@google.com>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260424191456.2679717-10-stevensd@google.com>
Subject: [PATCH v2 09/13] fork: Dynamic Kernel Stack accounting
From: David Stevens <stevensd@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Linus Walleij <linus.walleij@linaro.org>, 
	Will Deacon <willdeacon@google.com>, Quentin Perret <qperret@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>
Cc: David Stevens <stevensd@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: j3epmub86h3qe8uz6n4bhxe8o95tigmb
X-Rspam-User: 
X-Rspamd-Queue-Id: 1CA1F1A0004
X-Rspamd-Server: rspam07
X-HE-Tag: 1777058226-955170
X-HE-Meta: U2FsdGVkX1+XT6wTn+rMISEOwxVXbdEhXjP7Vphi8gOvh01XY/PJ4nzU1xKLPlyHi9c+PoS/43LaH4q/NLnnWnXlrb7PaKsd53lk8DhhzOF6AZZxmnRTS1b14OUbzQwOYCnCD/nqDC2UHqYM54YNooum2bb8JyrMklEs5nw49j3gGflhkYi8TVgZXMvqVTLfKNkyoLs+P+tyKtY2HVtqiub9hSMAPaP6IPDoZU9Ly95ks2tOa5X1gegwVdSzr1PV0qplSmnjJJ7gZMPRnXpdAMvbnkouk9rkyVHejxz5bs6neoe8Hd3AWKhc9bx6QhRLGV9bRnZBdasqaULj6aumAQFP2Kx+wZEBztV7/gcvYtru8CzXJyynkse68vFei463vbVRWb5VhcjmLd9VXYj7E8njs7TsxO7EpuyL5pZdc6wHiuqda33qq+jACb3ZyVHp1QnCmmWp7ijOG6DuFSoOnQCHdGaWGrW/n4ykRykwZMa4j27oxdnUZNTQ+Zf8CXYx4sLfocS2j0oRm4S5j4GEx3i3CbKtNtgZH7T9cDGpgGNDdfxUvdMKs8uERcqH5YWs0rXwMWErNWGV0Tz/7ikGzF65gHiRLnFEcd4A46ejefghwcpY8UI1bT25/w7VdbR2Trjt4KWq3yLWoJdfxmHO6NG49YMhUpOPy2FAeAiPNlmFDMKcROFKppAhruCw8Xn6U26Z6SkDVv1mSvvZF7xYN5E8MahFRxDPkKc4zG/BpV4Lrwc1Pmu6gUSCLzqYwV/S5v1vt6HdB8ODUkMPRG9sqlSIaOvw6f7X2VwlzQp0hneYGfP6IzG1ccHC5L9wQE35rERABMvcaGwG1o7V5ox8JjX3trjP0YI5ssDMD2oY4+kDHcPrxM/l6ahS+4gtMWEzCiiUrq4MGiheqXMdQX31+fTphHCq9JntGv9v5V78yF2rB0BMa6tFrlklj/5lGF3Lcylrkhud6aBdrNsy0n1
 Nr0iEX08
 zC4/c8GpwyB/6/kPHGcuv0U0l/YOQM38z7PZkE2kbmFbMNaod+1JUr6yFAtHHB2Vm1p3F/vQOAWzGCI1VpZrR2o5ZuQxWxlYelxV+WiJVTiWGFElG9Ik1O5c0ZqNkvN3Phd92T/CEkGbgdhRCmun48Ujkufl98Bn6qCfzWnzirrjflQhjBNVd/yR0hsFmTJrkO2HX7XAOxuzjpkun1W3UXfRN1JWuNRF7shWRWwzB8C7xow4VgPPFAyDiN7jtUE9xOBS5zV2j8ENzB8ufAB26lt8YvbxzozB/YlLo0t4wmWVgKYw/y9AX57yZqCRaV0arPfoMmqgA+aIjFSLbUAzyWgwNJ09gb7KrzHBjM7Va/c6gPyu38JQqLv7XBFIdvPVpF8nytdXJTlwPtwekh+RseKbdsaosv+Rfv+lxi0moqM0wy831zlwki/TTgJb4BrKCjT8vAbo33iR5PZrH7iOYUraZIxTefoaRH8m5cRoy1RZXztWFRCMD2xlnp+x3SG8BUIOt5TNqOImlb/s++qOuAlvYYLAzSF/W11PSF+jo4jPlhuLy02iWFaPbEizBuUf3MnbYIMKuwXVKBW4NwElATBL6vyKEGkpmTL1wTrcWQmpvyNKqPe7aNOBiI5tF380EK8PEptOpjtX3GarBOQyVMLEQsral0+1xa5O1Zqp57fwAtOCGvW1pp0UfKyhMLdAIz/eNI+cU/nET0FLY4PyjCy8VrJPbmASUjd6QDL5/6i6uZayColJFE/LIqcn90CYoza6T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pasha Tatashin <pasha.tatashin@soleen.com>

Add an accounting of the amount of stack pages that have been faulted in
and are currently in use.

Example use case:
  $ cat /proc/vmstat | grep stack
  nr_kernel_stack 18684
  nr_dynamic_stacks_faults 156

The above shows that the kernel stacks use total 18684KiB, out of which
156KiB were faulted in.

Given that the pre-allocated stacks are 4KiB, we can determine the total
number of tasks:

tasks = (nr_kernel_stack - nr_dynamic_stacks_faults) / 4 = 4632.

The amount of kernel stack memory without dynamic stack on this machine
would be:

4632 * 16 KiB = 74,112 KiB

Therefore, in this example dynamic stacks save: 55,428 KiB

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
[Rebased]
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
[add to memcg stats, fix typos]
Signed-off-by: David Stevens <stevensd@google.com>
---
 include/linux/mmzone.h |  3 +++
 kernel/fork.c          | 12 +++++++++++-
 mm/memcontrol.c        | 10 ++++++++++
 mm/vmstat.c            |  3 +++
 4 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 3e51190a55e4..4458fa7016a1 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -221,6 +221,9 @@ enum node_stat_item {
 	NR_FOLL_PIN_ACQUIRED,	/* via: pin_user_page(), gup flag: FOLL_PIN */
 	NR_FOLL_PIN_RELEASED,	/* pages returned via unpin_user_page() */
 	NR_KERNEL_STACK_KB,	/* measured in KiB */
+#ifdef CONFIG_DYNAMIC_STACK
+	NR_DYNAMIC_STACKS_FAULTS_KB, /* KiB of faulted kernel stack memory */
+#endif
 #if IS_ENABLED(CONFIG_SHADOW_CALL_STACK)
 	NR_KERNEL_SCS_KB,	/* measured in KiB */
 #endif
diff --git a/kernel/fork.c b/kernel/fork.c
index e615ef736dc0..9ac9d23f5f4b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -463,6 +463,8 @@ unsigned long dynamic_stack_accounting(struct task_struct *tsk, bool finalize)
 
 		mod_lruvec_page_state(page, NR_KERNEL_STACK_KB,
 				      PAGE_SIZE / 1024);
+		mod_lruvec_page_state(page, NR_DYNAMIC_STACKS_FAULTS_KB,
+				      PAGE_SIZE / 1024);
 	}
 
 	if (finalize) {
@@ -811,9 +813,17 @@ static void account_kernel_stack(struct task_struct *tsk, int account)
 		nr_accounted = vm_area->nr_pages;
 #endif
 
-		for (i = 0; i < nr_accounted; i++)
+		for (i = 0; i < nr_accounted; i++) {
 			mod_lruvec_page_state(vm_area->pages[i], NR_KERNEL_STACK_KB,
 					      account * (PAGE_SIZE / 1024));
+#ifdef CONFIG_DYNAMIC_STACK
+			if (i >= THREAD_PREALLOC_PAGES) {
+				mod_lruvec_page_state(vm_area->pages[i],
+						      NR_DYNAMIC_STACKS_FAULTS_KB,
+						      account * (PAGE_SIZE / 1024));
+			}
+#endif
+		}
 	} else {
 		void *stack = task_stack_page(tsk);
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 772bac21d155..cd2195a735ab 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -318,6 +318,9 @@ static const unsigned int memcg_node_stat_items[] = {
 	NR_FILE_THPS,
 	NR_ANON_THPS,
 	NR_KERNEL_STACK_KB,
+#ifdef CONFIG_DYNAMIC_STACK
+	NR_DYNAMIC_STACKS_FAULTS_KB,
+#endif
 	NR_PAGETABLE,
 	NR_SECONDARY_PAGETABLE,
 #ifdef CONFIG_SWAP
@@ -1403,6 +1406,10 @@ static const struct memory_stat memory_stats[] = {
 #ifdef CONFIG_NUMA_BALANCING
 	{ "pgpromote_success",		PGPROMOTE_SUCCESS	},
 #endif
+
+#ifdef CONFIG_DYNAMIC_STACK
+	{ "dynamic_stack_faults",	NR_DYNAMIC_STACKS_FAULTS_KB     },
+#endif
 };
 
 /* The actual unit of the state item, not the same as the output unit */
@@ -1415,6 +1422,9 @@ static int memcg_page_state_unit(int item)
 	case NR_SLAB_UNRECLAIMABLE_B:
 		return 1;
 	case NR_KERNEL_STACK_KB:
+#ifdef CONFIG_DYNAMIC_STACK
+	case NR_DYNAMIC_STACKS_FAULTS_KB:
+#endif
 		return SZ_1K;
 	default:
 		return PAGE_SIZE;
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 86b14b0f77b5..8fa1c7bcbaea 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1256,6 +1256,9 @@ const char * const vmstat_text[] = {
 	[I(NR_FOLL_PIN_ACQUIRED)]		= "nr_foll_pin_acquired",
 	[I(NR_FOLL_PIN_RELEASED)]		= "nr_foll_pin_released",
 	[I(NR_KERNEL_STACK_KB)]			= "nr_kernel_stack",
+#ifdef CONFIG_DYNAMIC_STACK
+	[I(NR_DYNAMIC_STACKS_FAULTS_KB)]	= "nr_dynamic_stacks_faults",
+#endif
 #if IS_ENABLED(CONFIG_SHADOW_CALL_STACK)
 	[I(NR_KERNEL_SCS_KB)]			= "nr_shadow_call_stack",
 #endif
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog


