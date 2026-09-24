Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E530DC98314
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 06:43:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC9F06B0093; Thu, 24 Sep 2026 02:43:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E53476B0095; Thu, 24 Sep 2026 02:43:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1BD16B0096; Thu, 24 Sep 2026 02:43:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 973EC6B0093
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:43:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 33DB71C1CC6
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:43:29 +0000 (UTC)
X-FDA: 85247714538.09.49C001C
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8C87C120008
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:43:27 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m396F3tx;
	spf=pass (imf29.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790232207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=sd81Spa/YxvQixpMcNxhaEy6XglgEfTWtaXZ4D7EaWc=;
	b=CfLXGRcmZ7WQO8My8AufvU5VzvSdUK59y8Vcz/4HIpoUj1mR6ZwJKAnKZG4vSh1zc9/4qd
	JlsOZ5ajAE+0O18A7D6LYDscUuodHDnlUNLVFQrPOyz54ph/nHzWoVUWFQVIoPBCQDmz1/
	2c1cGWMcnyWz4hsKOyhSaRgERpRUYSg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790232207;
	b=iVypAOlm/fta9pDx/dYUPWZeh0xXHPKz3NU8OQZe3OCrhM6ZSCvUpSkOc/OjsUap62x4/b
	7n3afhzgXeerpchFdy9TB83k69ShifsvmYMdJBUpjyiN969G6vjmGRh0ZheIHPxx8jLOfi
	lfKWKzuPuZYZIfoeagqL6GlV85ykEfo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m396F3tx;
	spf=pass (imf29.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912df756so12703045e9.3
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 23:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790232206; x=1790837006; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sd81Spa/YxvQixpMcNxhaEy6XglgEfTWtaXZ4D7EaWc=;
        b=m396F3txl5lo24bU0MJmnUCRcfMzEVn3RMbZMRiYiweEiPUDgAoKJ2XzngvIq9Lf91
         Est5tZj/xnWznyj7d3rWxPNPkFaQ5iFjjXcp7/BcO9wlYG9NY6bOb+vb+9S2W/pjngL2
         cn5mRmzHsKz7MMFvREd0kXU/pySYqeuiQW/Wdh1fS0su/Q6mfDYv5dcz0PUz3AeuWRLh
         uo14UASDunkReIcuzU21qGlh4Tcr9yF37vZlMmyXNDeTwwmkRym5Kb0jFraN1ey1cWbz
         RnRXsHHP+o7Fj4mw0cAbAjSZ4fmqW48wjBNo0DFsuHmlpVYgGb9a4mwGLfn8vvaPC4bR
         gZpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790232206; x=1790837006;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sd81Spa/YxvQixpMcNxhaEy6XglgEfTWtaXZ4D7EaWc=;
        b=EAn9h5elmbEyQXfGv2vAlILDv4LZb6NvQL7G98YeBdatT93UoG+NNdga5rqJNtIDeB
         9ZayzbGdPyj7YBpXo0KK6wMQl38j8cy6VaEgZlMt6adteDUqLH05cEeUsurv5ch3zHJ5
         XJuSr4/6HUUvZa0lU3tBHMZCk8IC1pXoGJ/HqesHYqS1fvobLvzu4TJwyZGFr6Uagkm2
         93GorO/yYSb37K0uqAe9TQRyEC8hticcO2v5EsZeCOZyPbXnK8mzEo3eQwPPMkv5S8Vp
         bTSiNqv9nfH5Zk9IYVAri+WZd6TvpbKNNi8zbXk7Uaqj888m/asIz1P18CG8n2OJ740k
         SSkg==
X-Forwarded-Encrypted: i=1; AKwUvBzMKBxEk/BtP3fglYIZQEKT0UshLOP3WpwyzFeJCEU9Ml3Fatujz0nlSS3Ysfir0rtclmUXPU6yew==@kvack.org
X-Gm-Message-State: AFuF++mMGb8Gg+hzYxOnORjg3ASMLdoSPuyubARIeKzMOB5eQMDmLvnS
	wcKjRSG2Mcv/N6SDTy8okNWvPSU2tH2X/6/7xzSc2CdSVAEX66bid6HL
X-Gm-Gg: AYBFou0CW3FqZYRR2tuNLrbWxeEG2WBa2gf+ZOXRNXXVFtlPKZ2pMtrZ4VLs2Q1eUvo
	wG3hdkxD482LT+YwxJOkU/bY6GF3CmenT86/6j9k4b/sfpfcRyNjvvOvZOHBiX+Loq83YULrtID
	LcXee42Ygv5vCg8f8pKIoNUU1eJX9F8DvOF+7u3HFNlLxmOQ0Hhc+jraP5cabTaNZ7nZ3/w43A0
	czDO5wXTSlh9zvzGC3fE1ilbyB9PJlzG7BPoZ2Uo9H0uTX4BUm6BBxuIsETXIhXT8VCAd6BKJbR
	Hp9O3VI1AYo/2UGcmtnHM3Ih5caSxodZS1UoL2YcsdyS6jX9HuTCw8cQKvH+vyAoq3PeLFgifn1
	swdc+2NdIGQ+wYzqFBnjmPeq3wS5rGbVt4nAAvgdM+4pJlAPaKXs/tqinwBzwBF/8grN06Dmxco
	7X+8NyTIMsHnwTVJ1hueVFyJCB0m/diIdNM96SP3ErWCRRvrUn7cI+0WyUYF3cQWvorOjB70yfF
	d2bS/Lrw741g1LGAr+AcuHvAF8VYelZG6QAhvQ1A7tRlWiXc+7ig14B4dZyar5txLTPzUA=
X-Received: by 2002:a05:600c:8b22:b0:49e:6fd2:a45 with SMTP id 5b1f17b1804b1-49fe66d81fbmr22703135e9.16.1790232205833;
        Wed, 23 Sep 2026 23:43:25 -0700 (PDT)
Received: from localhost ([188.234.148.119])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fdf99df60sm90788905e9.1.2026.09.23.23.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 23:43:24 -0700 (PDT)
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
Subject: [PATCH] mm: don't defer freeing kernel page tables while booting
Date: Thu, 24 Sep 2026 11:43:21 +0500
Message-ID: <20260924064321.23787-1-mikhail.v.gavrilov@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8C87C120008
X-Stat-Signature: gr45hn7mt6b1kguni91x7tu1698tq63y
X-Rspam-User: 
X-HE-Tag: 1790232207-942739
X-HE-Meta: U2FsdGVkX18hSrCYM9MVtMIWq7pIQlWGdlEUxKQB9Y67zyUaT2l7fcsJCfW/U1ouZnX+/58OBxiJ+JCWHGE0OGwYBo8sfXck3ZaeSmo5Hw3y/bpTlV+9DSVwH01x56hqsSDuU95doYg4MmxMcsl1PWAky3LHKaXtJq9XDY+bJTPyhPz7so+pbzAFsiQPLDLZqy0R/8MuWzhia89UBczAlakjj+ex70itgnnedSvVB+NdKMVD4EfOG0IK99CUKVria+1yH3e8XNDEDvFl4okbVabb4JvJKoG1ilb8ji8V/dIej8KWuRRy+eCCndtAaOn3N69r5CPPx//sOHhq9l3lQ2xVVBmQR0SGSirfpi3MVW+nGIX/DikafmyuQgb1ZFjxzVCNZOIsbmWDqRvD3VTgbMsHzkNIPewMpz4PoXhRvKUVaZyWLUn0kBCDJIW0+Zwy6CpwvxYi4AEG133HXbgjNT1TqfNsZ5+fDh8KlDfXvCHmf+JJtTrQvhlHr4OpGhs973KgjVTsQsMOHzJ7zPb6ivOSetg15ydSMg2b1bxoi8LVZqaca3irxVfzJ192qgrWAiKcuq9W4X8jVMy62cGW6HSzkvmHrrdBJizpK0Y/asJo+cMrOzmiJPYgnaav1AW7VaZA2oJGwbGiHjcrZK/t5TQVELpNNM761kP39qPuDxMbbo6bI2H4UNR+aoXn4r6sXTP3VUvOMPauKQXGdPZAQvNDeB+ah+hsfW6jZz7RjNdVrgfQnGxbdBmYaDo47sOKjBiAnrocAa1pdZ+9EkcNabT8RkBuGjA4flQvAY8eWrQM3YXK++CQIkoHmtJPDQfwJrz4BsYHKVADN1Iip2Wq3TOkhjrSII3sSPIXojEzTUAO+JghzJopbz3AoVwSVHdbmFxMEJBeNjJ7ZguJQYRdtWhQ6LHmeffOFJXNuIeT3Dq8tD2qZ/azOZTwsQxMSkwPCjzUXrr9p+gmtNYtvNZ
 KnKwm1oO
 EIqj0iLfcphUsk6Pc8CvIdSDKlQbDrFPCsAd4mOIaIs+04z2GA28RpqnLqEr8jkFSl3WFFRcICAHV2OF3+tGGyG/EiyWkDT0Rh7DLQeojV/Wbs0hTJoSOFtHs2+wIRtqPcV4tjIn/s96SzMu1AvYvcONPZaMV7GNg5G+kThxjyoYHJKzE8m0HKQHGzP3eZMUmXUYpoNzCluYcJpMhrxVRzg7Ngv9ZwJKqWHa7KDGHGFciQGOef0ZxCl5EX3fpKmWDQeJruElSDHCXbh4Da8vZU7X6V659pUaja7KTtfexyU6FeO4i+qRM1o+t0zXxWgJi93wlTD15piegA4xxF7U2NXcEs6zwDyBBf/JE1eUFZFCL3hWZzbZhP6FC7/+E58sxXae9StgWaIFnQJi85mEshRCxs5AnipFIvBhIh/iQnlgDB8rrTSq0RP05o1GgPfyYbpKx9uRmTk8SAjfhTTWNGWSbRwLpYXHTsY/LoiDQRuDLLUypB1/SizAqRA23MJ8W58y9QJsROvfCJ1g8+8PwLsTowxvVM/Qi4eJFwy6kwY8I0VWD6yr0hJBHrA39uerYhcKVUKBwtM0vBEkk9K4S5IQNrxyQ//FEn23dc4VpSe81mmNMgCiwVrkxsdAZfXMtl4X73wWV10dvijjdOReU0i2twg==
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
system_percpu_wq - still NULL at that point.

The deferral exists so that IOMMUs using SVA can have their paging
structure caches flushed before a kernel page table is freed.  While
system_state is still SYSTEM_BOOTING only the boot CPU runs and no IOMMU
has been initialised yet (on x86 that happens from pci_iommu_init(), a
rootfs_initcall), so there is nothing to flush.  Free the table directly
in that case.

Fixes: 9e4a3ec3411b ("x86/mm/pat: Allocate split page tables as kernel page tables")
Cc: stable@vger.kernel.org
Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
---
#regzbot introduced: 9e4a3ec3411b

Tested on a Ryzen 9 7950X with a Radeon RX 7900 XTX, lockdep and KASAN
enabled, booting with the command line above plus earlycon=efifb so
that the oops is visible:

  7.3-rc4 (fe2ec83746e5)             panics as quoted
  + revert of 9e4a3ec3411b           boots
  + this patch, 9e4a3ec3411b kept    boots

With this patch the boot-time tracer works as intended and records
pud_free_pmd_page() being called from vmap_p4d_range() during boot.
All three kernels also carry my pud_free_pmd_page() v2 patch and
unrelated local changes elsewhere (HID, sound/usb, Bluetooth, debugfs);
none of them is on this path.

9e4a3ec3411b is also in 7.2.7 and 6.18.53, together with the deferred
pagetable_free_kernel(); I have not tried those.

 mm/pgtable-generic.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index b91b1a98029c..2d9b4ba33b46 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -440,6 +440,17 @@ static void kernel_pgtable_work_func(struct work_struct *work)
 
 void pagetable_free_kernel(struct ptdesc *pt)
 {
+	/*
+	 * While the system is still booting only the boot CPU runs and no
+	 * IOMMU has been set up, so nothing can be caching this table and
+	 * there is nothing to flush.  The workqueue this defers to may not
+	 * exist yet either.
+	 */
+	if (system_state == SYSTEM_BOOTING) {
+		__pagetable_free(pt);
+		return;
+	}
+
 	spin_lock(&kernel_pgtable_work.lock);
 	list_add(&pt->pt_list, &kernel_pgtable_work.list);
 	spin_unlock(&kernel_pgtable_work.lock);
-- 
2.55.0


