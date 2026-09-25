Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11F13C98306
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 05:06:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05E686B0088; Fri, 25 Sep 2026 01:06:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00F326B008A; Fri, 25 Sep 2026 01:06:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E404C6B008C; Fri, 25 Sep 2026 01:06:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B839C6B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 01:06:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 34FE3803EA
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 05:06:55 +0000 (UTC)
X-FDA: 85251099990.04.29BB29C
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7AA1640008
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 05:06:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nE9yQg9Z;
	spf=pass (imf27.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790312813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=bTHdBxfhS/8AwdrGP71aETufCPYtjaKQTmoOMEZkDuQ=;
	b=E1bChVlHTjzPnwOFOdxxeXJThZvVyMGzmmcqSVRnL65oCIZCQUYNjR4Fd6QKKbluwG8FYK
	3hGFOmyiGWKPo0y5GDutSs4enlTJZ/zGgvUdbv+VmChSsxPaCPEG1IPxG7I/OYQGoLEld5
	TejmS7fVFZ/bCOdxSXda0Nz2vbcxVLM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nE9yQg9Z;
	spf=pass (imf27.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790312813;
	b=1ZpdopYqrjacBfNj3c7uf3xCEb3mapr/fV0QG0F16hXcnY49fvO96cxitPkzkQTpLMNkPm
	tA+gZR+/BxKPf3TAudlM2xIqh9UpCFJjkssKZos6jvZlx+wvE+IWmfNiKEofHHWj0Dr79y
	A2aua7hVHxfadvpI1Q9C8k2ytA9e4/U=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912e64ccso2935045e9.0
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 22:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790312812; x=1790917612; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bTHdBxfhS/8AwdrGP71aETufCPYtjaKQTmoOMEZkDuQ=;
        b=nE9yQg9ZhZ/Gv1VL2y1hg3K2H4X4CIyW1MCEkYCwV0nLlvsh+6mZ3JqYwj1mF7Q4AU
         4IDtYjE0gzKP6/icyFUB07JkHwXiCW5AOQ8HLtHQn9alFt5utSEfjiP7AeAb9Ixq90zv
         dVxQqsj160bT6ZdXtJudps9iAEPYf0fNfj27t6itJNT3k3IzD/q2z5HBk94EW75p+gBN
         yifQ6iiy8T9RCzwnZqESyIjBaREwbg5LFqPzBHQv61xoqGBOl38GVfC0S/GBg1sVOXmQ
         Pu8Lqd0C8wCrZMSRTeVyeYa5JeqgcHjlaF+xE4xMP4sYuZxQF7RuhOc7Q1MAzNITGJvB
         3zKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790312812; x=1790917612;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bTHdBxfhS/8AwdrGP71aETufCPYtjaKQTmoOMEZkDuQ=;
        b=NVtj29QLOb2SPga7xcNFw1eWiWDw9UnBIc4DFEH6daFLEjTIvhX5uj+K6XPPCPbl+0
         8fJYzBbtseUWWPPcbLjIQQfspnUEK7m2MNNXjTRh3W8c07C3Wi5iY8A1JxVWlKyJfKVM
         86csYDhNmGYcNa8jaDOq16JJrSsYCQfagkMhtDUtKqo0tmakqFz1Uc/kH2xtQZfIKiX2
         E6kXUAd5LmeSMhcqiW/mx78fCcPwCoFlkV3mGsoiSiiCMUkaIHn4KC/l232ZNsukIN7u
         Qq7JwqPF0ShlqN+hv24lxuebcvpKID3YKDiKKzw01vMGwUopwElFGTyz1EwogRjxDw4d
         oAwA==
X-Forwarded-Encrypted: i=1; AKwUvBy/VMMGcpOVWbc5+gHAgqxykdSAOLUAjeVytHaAmJYoAA4mr1lCgQSzphzC0dvZ9u1xKhsahCiYMg==@kvack.org
X-Gm-Message-State: AFuF++luAP3RvQuZzPbSHsYPNxklFPQ+sKOvke6uqF79U3Z73LfrEK7M
	Zq9Sb6ZUjx18BVN0EApbMfpI6TV0tS+ySHSbHERJo23INbeh2Vf2Y5ZC
X-Gm-Gg: AYBFou0dNhEg7BrAr2IAxgh3LwLJ1rVkA9tHLZRQVq0Nn8FgOfuu5q1a/DefAgMsI3d
	HDhjz6VDFhsK2x/are1RytLTVQctRXkygcmauPJgel2GovD8HA2E1rJWz/M6MRBesqqUSg4K5J9
	RUW4a1epGjxeLY3PrNQLAx89hyOqAHF6Q5f+Jd0lhrP7QcZHPExZyrTXyrZJvn6uloFmgWGElAU
	QRBR1ogs/PHHR1HS13VBFnzw4s5orpMetP/1w5LtuXKhuaWdXhY7oQnEv8IvaAJaDB/pKzUw3KV
	lPEpWJT0KPrDfarOirX1DOJW4iYC+x1sPx/zAJJS7xIoVLhWPBTFMgZi/wrVA8OP4pK3waUc8Gz
	vF+/zlmwHlVxGG+s6MIkFc6Gbuv5HQQbZ9ViLP+XQEAB3N4q3mYpR3934drTaU4CRJOu6YR1VZ0
	fWL8WKNgqG1eNee7NTFeULe8TUuEoQ7Zyq3iF5R6nldFQuX1+al5H9tvWsgi44oQJYiuiNmD7WH
	95Zhg2qsoCNjzG3AmZtJNk6gP+J0f9T+rB9Iq8B0r0WqUxPSC+tqwAkz+/qoRplJVI6mWA=
X-Received: by 2002:a05:600c:154c:b0:493:f140:c3fb with SMTP id 5b1f17b1804b1-49fe66cab86mr77104535e9.7.1790312811460;
        Thu, 24 Sep 2026 22:06:51 -0700 (PDT)
Received: from localhost ([188.234.148.119])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ff06bdef2sm29882305e9.11.2026.09.24.22.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 22:06:50 -0700 (PDT)
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Vishal Moola <vishal.moola@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	x86@kernel.org,
	linux-mm@kvack.org,
	regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Subject: [PATCH v3] mm: don't schedule deferred kernel page table freeing while booting
Date: Fri, 25 Sep 2026 10:06:47 +0500
Message-ID: <20260925050647.86913-1-mikhail.v.gavrilov@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7AA1640008
X-Rspam-User: 
X-Stat-Signature: ekws8z9zuxdtmtxed66puny1mo9eziyr
X-HE-Tag: 1790312813-553748
X-HE-Meta: U2FsdGVkX1+XnfrtCLdsfjc8F2EOwQseO0JiAq5T/GtVpplUbsGxbXKkXFeHhThVuY03QHX78wHwlug672FeEBjHeDrOTBQ6hgfebaqgtON1g/uBk1rLY9wIhLLT/69qXV2U2q80hnNQFva89El3jYnpkLAqv/Z3JokzBaexWab0Ga40GhejPU5O0l/6Cbgr7m48DlUFPJd253HmJpRF0bY0fv0CHittB7im4OZViFFBTmKn+lTWYFnCfZ0Lo5uWYSVCXjAEDHdgcez3J92jJMcuHzAfOQ0TU7hK5jm4bJIchGLiwhGk7aA/zxYID9gouPNZHUmVBPuGTtSk3RvgthuTOzLJ1UbRRa7nd0G2GeBsdCHXz9iZhmZd1P2clTjoVAVipC19VkpNsXHlYSQ9l/QwUQ0E1KpGHR+UY4KMpzHI21qDqPousFBh3vw/T+7MM+htnIIS9UvECaeahWGGyl4S8/URawbqExdJvpUfRlQjtTgyzj4rYeUHjUynGVam2GEbnIEsZsgXA65TfBCcA5oTqw/xZUZa2GxjTKDZfiR5YoQiLhvxb9d/WRfaoWmTCj9j80c/CU1G9lOZ8I+ur6+/KfIKeDbDW8U5c11KuRDK6hV1oBKj6MsSuH1BmdNaMVqz6Jmzb/1kaj5iib6dUwDokz5YUDUacMu2z9RrurfakwIc64XVbsnaV/bKlxA38eOTvPfj8JwSHFIL5p7YSdPL23sLzvIjsSv1FlxWyav02+w7ooYZJPZepQMRX3YMtGqe3/Ke+H8+zeby4mkDdW9PsVXDYtVWUKswibDuHvI2rlGWOojKazCxT8Ys/UHg8Ii/4RybXbrehOkUdcLiy1fhWv+2pVGojqgkOzVXAppnP3CJF6hI46iG49AZO/6E7nbgUYdERmAh1KjTEdH1Ivozb0xcF7SKK9/9Kaa3bk307wbv5JA8QTd5a4Swg3knkBQMXs0+ahj9PSp3x0g
 u3dqd6N6
 vnzMTdW9CUFkaDJiDYKtm4APPdeFqE1fMi9VTx9NAqoReaXIeF7SkqM/3/l+JWChKutgQJXjbrsgLV2Ymobsy9ygQ/L7Mujaf8BSuqvP5WbSG/VqBbq+yzFYs4BbgZvMB+tH8vNbKLqbWMraKrcK7pu2fjK4jow5dNJKdXcK8e275dfmt+shPxE3MVJyTS+bpizKg722p7/gxppkoiAWVmiFpr943zowXj5FoQs9dnVRkejzN1jEKgxov35+r64wUIIN7kTwdaZGqnHne3oUOie1/Ko5PuJKHpqbEJiFDFluW8HaMxS7Zdgv+8s0o2yP8/jQlh6Sh6IlWCPXzHXz9Wm0/6Oik5NGlvS7E+JntHoUi8Wex2V0hImME4dAUjGFEo4HhJS53lpDW3jlDOg89EgvKgQ0ZVUPrXdluDNMvTTpnE4wezd7xFd8Pk5VvUGHodycGFFTqSmHgVshezA2NlLizv1rS6iCvOUlZtZonri5KptVV3X+gVMVf6OaQq/swAatCKHasM9efwEk8aKzR26iUPDiaob6Z0HiBryBoKK5eb97FYVs7qGiEdyMyceWLL409tfCkKQSN7EP9CoD7QlxGHqbSHFVvNRWuX+b6L8dTJ1c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Booting with a boot-time function tracer and a filter, for example

  ftrace=function ftrace_filter=pud_free_pmd_page

panics on 7.3-rc4 as soon as the tracer starts:

  [   23.531178] Starting tracer 'function'
  [   23.675800] Oops: general protection fault, probably for non-canonical address 0xdffffc0000000038: 0000 [#1] SMP KASAN NOPTI
  [   23.819917] KASAN: null-ptr-deref in range [0x00000000000001c0-0x00000000000001c7]
  [   23.964025] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 7.3.0-rc4-fe2ec83746e5-with-fixes-v2+ #195 PREEMPT(undef)
  [   24.252248] RIP: 0010:__queue_work+0xab/0xf00
  [   25.981629] Call Trace:
  [   26.125727]  <TASK>
  [   26.413912]  ? pagetable_free_kernel+0x20/0x120
  [   26.990283]  queue_work_on+0x97/0xf0
  [   27.134382]  __cpa_collapse_large_pages+0x501/0x6f0
  [   27.566662]  cpa_flush+0x394/0x620
  [   27.998953]  change_page_attr_set_clr+0x321/0x4a0
  [   29.151729]  set_memory_rox+0xa2/0xf0
  [   29.584018]  create_trampoline+0x431/0x6f0
  ...
  [   44.343347] Kernel panic - not syncing: Attempted to kill the idle task!

The boot-time tracer is started from early_trace_init(), which runs
before workqueue_init_early().  Making its trampoline read-only splits a
large page, and CPA collapses it again right away.  The split table has
been a kernel page table since commit 9e4a3ec3411b
("x86/mm/pat: Allocate split page tables as kernel page tables"), so the
collapse frees it through pagetable_free_kernel(), which queues work on
system_percpu_wq - still NULL at that point.  That commit is correct in
itself; it only lets CPA reach pagetable_free_kernel() before the
workqueue that function relies on exists.

Keep putting the table on the list, but don't schedule the work while
the system is still booting.  A core_initcall schedules it once to free
whatever was queued by then.

Fixes: 9e4a3ec3411b ("x86/mm/pat: Allocate split page tables as kernel page tables")
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Link: https://lore.kernel.org/20260924064321.23787-1-mikhail.v.gavrilov@gmail.com
---
v3:
 - Schedule the work once from a core_initcall to free whatever was
   queued during boot (Lorenzo Stoakes, Dave Hansen, David Hildenbrand).
   late_initcall would work just as well; workqueues exist from
   workqueue_init() on.
 - Keep the fix in pagetable_free_kernel() rather than skipping the
   collapse during boot (Mike Rapoport): that would only avoid this
   caller, and any other early free would still need a workqueue.
v2: https://lore.kernel.org/20260924092307.22813-1-mikhail.v.gavrilov@gmail.com
v1: https://lore.kernel.org/20260924064321.23787-1-mikhail.v.gavrilov@gmail.com

Tested on a Ryzen 9 7950X with a Radeon RX 7900 XTX (lockdep, KASAN),
7.3-rc4 plus unrelated local changes, by booting with

  ftrace=function ftrace_filter=pud_free_pmd_page,pagetable_free_kernel,kernel_pgtable_work_func,kernel_pgtable_drain_early

The boot that panicked without the fix completes, and the trace shows
kernel_pgtable_drain_early() and then kernel_pgtable_work_func() before
any other kernel page table is freed.

 mm/pgtable-generic.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index b91b1a98029c..cd227fc05d2d 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -438,12 +438,30 @@ static void kernel_pgtable_work_func(struct work_struct *work)
 		__pagetable_free(pt);
 }
 
+static void schedule_kernel_pgtable_free(void)
+{
+	schedule_work(&kernel_pgtable_work.work);
+}
+
 void pagetable_free_kernel(struct ptdesc *pt)
 {
 	spin_lock(&kernel_pgtable_work.lock);
 	list_add(&pt->pt_list, &kernel_pgtable_work.list);
 	spin_unlock(&kernel_pgtable_work.lock);
 
-	schedule_work(&kernel_pgtable_work.work);
+	/*
+	 * The workqueue may not exist yet while the system is booting.
+	 * kernel_pgtable_drain_early() schedules the work once it does.
+	 */
+	if (system_state != SYSTEM_BOOTING)
+		schedule_kernel_pgtable_free();
+}
+
+static int __init kernel_pgtable_drain_early(void)
+{
+	/* Free the kernel page tables queued while booting. */
+	schedule_kernel_pgtable_free();
+	return 0;
 }
+core_initcall(kernel_pgtable_drain_early);
 #endif
-- 
2.55.0


