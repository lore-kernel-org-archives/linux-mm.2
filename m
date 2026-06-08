Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52C7BCD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 15:58:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 673006B0005; Mon,  8 Jun 2026 11:58:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64A846B008A; Mon,  8 Jun 2026 11:58:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 539C96B008C; Mon,  8 Jun 2026 11:58:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 43C946B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:58:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D8BB14018B
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:58:36 +0000 (UTC)
X-FDA: 84857203032.22.37F2A0F
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf09.hostedemail.com (Postfix) with ESMTP id E726B140015
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:58:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=siderolabs.com header.s=google header.b=IkdDFeNj;
	spf=pass (imf09.hostedemail.com: domain of andrey.smirnov@siderolabs.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=andrey.smirnov@siderolabs.com;
	dmarc=pass (policy=none) header.from=siderolabs.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780934315;
	b=oJ/AYQtrxiYeuX4g/bi2GRLaXFO3rhEXp+Zp2uSCydWtyXOiBbF/twUTWdjULM9YGPYAU0
	edNTCfNj3s7/xVsEVqVR4hf5K1GercyMgZ/NXjXQrpcjOGAYXsPSdv31c7NjIMjyKz5FgB
	FtWedbca2TcE7DC235aJvYUjcbe0fGM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=siderolabs.com header.s=google header.b=IkdDFeNj;
	spf=pass (imf09.hostedemail.com: domain of andrey.smirnov@siderolabs.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=andrey.smirnov@siderolabs.com;
	dmarc=pass (policy=none) header.from=siderolabs.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780934315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hiaq02sgTN+eg9Ui+NZIWW5xOwd5YS8q5QwBFbVzNCM=;
	b=q7HLh9lo1Du1NxmmGJn+fbMhogYgkkNcur2ec0DJy8o7rO/bid+PohdYrfP4kR/FwO8ZXF
	xQ9xRURW6/AO9ytbG5tE7qhz+kaaSohD6qOXeNbni2ZAWJFEixHIymrBIHgtSqVUmBjLO2
	OJZyWCsbe3rh1ulmUdp0AiJ1dT9di04=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-490b12270b3so27197685e9.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 08:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=siderolabs.com; s=google; t=1780934313; x=1781539113; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hiaq02sgTN+eg9Ui+NZIWW5xOwd5YS8q5QwBFbVzNCM=;
        b=IkdDFeNjO+TvkOA5vhGX48xnztHDJ0ipCge5RWu3IcqMPEoV8SZPInuSlWX0/XhpFW
         V/4XuYcvZVAUY3SGAvez4Flxc0LFVVF+AkCI//V0TbkxIzGn1lPMj2oFaboVGG2ebxUq
         KGWSeOc2MoXkw0Z+g+0j7TP3sa5KsjduU7YZSpDvSxhORzgctOzVWrfrL/yGncAkkt2E
         p8P2Ojak+i+usfQN5KCR6wAgHDk0hoQFeFDErDXE+i509WSPZm0o/aBhIBG7uxjIyW8d
         DffzprGeXzcej8oksbExxZztVCB/ZPlYNcpyCBLlg7P07HFOgUFnJ+Vjt9Hl8K/WKZdT
         W+OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780934313; x=1781539113;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hiaq02sgTN+eg9Ui+NZIWW5xOwd5YS8q5QwBFbVzNCM=;
        b=eW59CHKO9tbTd/CCHigsaccziwBp/Nvu40MYJUYEe/6Rk4rS52Rvwlqeb9RThcesIc
         E8rj/QcIuHITcGWuvbRCMfWskPkrgKK3szuhu/AwyCNmXi2aAttG7ylDPvbDOQmmgu0G
         Rk0u1u3I/Jx3Bwx6pM5OGi3u46Mega8g3CE76bbb72ThwZsotwn5eRy8Bl/jPUNjYKYk
         HRyundmB5fEIqPfTDN0m2XDG8udB87V7gFBPQoLrbVmPBTRuT1PtqlZxc47JG9jn2nAQ
         NHVARfsVwc/Io75ptkf2nVOPd8bQDZDpuW5OOjn/gOkP6D9lxqQfH/8bRY5Tup6zGOk5
         E1hA==
X-Gm-Message-State: AOJu0YzWJRK06TUUMcjgUZsklzkEhOZRDHovYzlHLvIm5xThe8O0oK4/
	CKXHIKcmoMIsqQ4UZfDzTJLfTbA7c1DYPvwckMeZjCMlgLzE3q1m0vWvSBgGzSfxHO0=
X-Gm-Gg: Acq92OGiR8iP6H/lSKORLABaG4bG64HH1/R4J3ppfUiP6HZY3e64EqMyPXD3/yTN2nq
	gpl7V+J1FHuivfrkbbPdwSeRFnQVZ8syiDNLkuCJHneAhVtM9vEVofJ053P7iai/HtISg/3O6CB
	5p9WCbusydvGzvZOSXbUqD1Z6xVlyTUp4c5heuI7odI8hhf3paOmZ1XpKSLU02xQeIIPgV6tCQY
	j2RN0WchWry03mw6MEQ8e/w9v+acraHD4cOh7EYiFCj2vafAbjb9RNZAJxVMj1BXDfgZACXPuqP
	1Hk3rzOEGFyAxJDs6rzmuVY1/hKs+d+a5PhKnb8Myi5Wtp31QNGbxZv45Odw7ZWR55Sa27yKLBs
	mer9yXZgp7Jv8vHwgWWGbglxGTTaMWaeKFmFiXBEsQXL7fiLSkgs3S2V5JDKHnFwxJO3X4KIeAl
	/iEjwhUcKzHsNmnXIfeX5m5OoX0zUm0iisidUDCkCia7rThAE=
X-Received: by 2002:a05:600c:3153:b0:490:b8c0:d46a with SMTP id 5b1f17b1804b1-490c2604790mr273388415e9.22.1780934312914;
        Mon, 08 Jun 2026 08:58:32 -0700 (PDT)
Received: from smirabuild ([2a0b:6204:2bf7:46ff:214:5616:96d9:612])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3cc140sm484355775e9.9.2026.06.08.08.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 08:58:32 -0700 (PDT)
From: Andrey Smirnov <andrey.smirnov@siderolabs.com>
To: pasha.tatashin@soleen.com,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	syzbot+2b5fe617654be3d8848b@syzkaller.appspotmail.com,
	Andrey Smirnov <andrey.smirnov@siderolabs.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Andrei Vagin <avagin@gmail.com>,
	Andy Lutomirski <luto@kernel.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm/page_table_check: do not track special (PFN-mapped) PTEs
Date: Mon,  8 Jun 2026 19:57:58 +0400
Message-ID: <20260608155758.1220420-1-andrey.smirnov@siderolabs.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E726B140015
X-Rspam-User: 
X-Stat-Signature: mtxhsrywd5nukundwsj8e1piuojmcisa
X-HE-Tag: 1780934314-994489
X-HE-Meta: U2FsdGVkX1/xZPUGyxgEpIyEPaSmfqaHcy7IzdzHkgklKBP/6hZsCkvgjis0cuHXdyoYft5L+NmgOWysp0zoLsfAK5r7Oa/eyTL8ZXQ1tBp//QOEbhk2dl33Mp2hvtXCSChhX9NVCrmzcw+nF8okXwhR5gmd0JZRTQ8QIFaPBa1r+kqyDZzQfoMHIL3WAN+OijnoO0tvA1m9xVnuAPUO//GGPKDmmIYFvqNZuBYQ664hDXu/hD2DHgmvgFowvF32N/0Bu6CqdnkmeIYZECgVLUdyl9HCGfsrot5TvA+V0E7SnbzMmYR0JOL+7nI96dSunCXM1AuZRXt4jSxBHMugGwce1ovnJc2Uww6FBCiaxi42JfgAGoM7JfWWxD9w9nhu5YTKmdRVXivYx1szvhyBWaxAsoanp790OH1zJHPM5mjszcN8XLfcOa0PTkfOxlDu6ClT1st8DbnZio9SoBz4hBUtD3wemJ87Wi2P+ALMcTq9RDaYUXCzIedC1btLB50FP2Bw1jkUM5TJJSMxon1dCU1wcnkWK/ahX4KA1V2XrDx6oaGvfuNr7LQwPq+VRLquR4bdAy5yBx18iV7mYAzAhbYx6fAnkHhkLNIlXvk6j9FhnRZ14PyYtKGyZjNd6QOo1t5OS2+JetUyZzCnng2A4hORGpI1lRg6I9X75SBkyA6op02BliRUcdFzuDcODKwKIVLfbddYQVtiI8YEr47GnNA+VKQWQZrWMU4gZ8BSlSwVOXCf8rqsmEbiuVGIsVqwgssxritiwHuSFX2noDjkFbtjDbeWe3U6dsB87Q1mrxCCNRZFeYUSEdLkg5zCCk6ckt/ToUYCsyKMqsSjfZtjHsURL+nkGAcVgkLR0tVOzvIV/DGzE7E0KbaMeXp/Oih9XnP+gMTRYMmGrOpVvi2UnOul/5Y4Ggg9lytrbQeOLioRVKR6bMZv9GRA0az15UHu0YwfZ/WFreTBokZibrg
 j1u+VOpC
 a3nuzACZwa1GocKbU57Gp0vb4h875NfDue5WPG8g/WyYRl60YD2dodQzLL/8uQwIJ+aqOaQz6IbIvshEH3u1bj3NZmCiiCu25rAzNSajyEAS/pEjXWb8BROfe3tmXpSwb5DF14KaZ471CAXAHapbmShDwwP7Mzg9kd+2Yxqs0rlTia1GSKlfD7gdH5191pjdEiIG3SFNas3kvNHaiISdFp5BKS5FG9vQLNjc7nmaEe10Q6iW/gdn//tKy8Ns9zyXLRmxajzXPvVM0IbIf4zwfkQGA/Ph9EDbYXxq/xQooVDX9V5eWIzYQIcipXKJN9Vrq//nOvgpMZ/BfHyGRi2+V/gSm5HaAjmDWWo3XBwEROvFnJ5ffV1x+oxtLexnz9wBYpGVRTLlcq9LA8CE9cNe9f12lAe8M4legjNYNDgmCtyMif8CA9dX4JB7muCUGPOuj4WlDNS2j8oQYc7FAuol5wjNsi4gvlYVZGjZzRtGs5PPHKd8OpMFQYXanN4bA11P/sq6c960aJemT81wqoO/qFiJG/+oTEzbtr9Tth+CMWgYp8XT4wnxVcHNJ+NlCQ/dyT41FTnJidetS1dPkWwKo+zdzlpyzEAxYR/ZcSTLu/iqo2Mxt3QKf64QyHBkuR/XR35W/jhOuwAoMKfySE62Zj3WfQibVNouTGkmD8TNqQsoJS/8xTZmquf5/LLchBnnikNh5o1olA0b5WhEROTAeSCObgksSN4ZVdV+yipIBRbP4AbPfOulwOr5cTA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The vDSO data store ("[vvar]") special mapping is created as a VM_PFNMAP
mapping and its pages are installed into userspace with vmf_insert_pfn(),
which produces special PTEs (pte_special()). On x86 and arm64 (and riscv)
pte_user_accessible_page() only tests the PRESENT/USER bits and does not
exclude special PTEs, so page_table_check accounts these PFN mappings in
the per-page anon/file map counters even though they are not rmap-managed
pages (vm_normal_page() returns NULL for them).

Most of these data pages live in the kernel image and are never freed, so
the stray accounting is invisible. The time-namespace VVAR page is the
exception: it is a real alloc_page() page that is released with
__free_page() in free_time_ns() when the last task of a time namespace
exits. Across the map / unmap / vdso_join_timens() zap transitions the
special-PTE accounting is not balanced for this page, so a non-zero
file_map_count survives to the free path and trips:

  kernel BUG at mm/page_table_check.c:143!
  __page_table_check_zero+0xfb/0x130
  __free_frozen_pages+0x52f/0x650
  free_time_ns+0x85/0xc0
  free_nsproxy+0x7f/0x130
  do_exit+0x313/0xa60
  do_group_exit+0x77/0x90

This is reliably reproducible on x86_64 and arm64 under heavy container/CI
churn that rapidly creates and destroys time namespaces (CLONE_NEWTIME via
runc / docker-init / tini), and was independently reported by syzbot on
riscv. It only manifests when CONFIG_PAGE_TABLE_CHECK is active.

Special PTEs have no struct-page rmap semantics and must never have been
tracked by page table check. Skip them in both the set and clear paths so
the counters stay balanced (always zero) for PFN-mapped pages, regardless
of how the architecture defines pte_user_accessible_page(). pte_special()
is available generically (it is a no-op returning false on architectures
without ARCH_HAS_PTE_SPECIAL), so this is a single, arch-independent fix.

Note that the v7.0 generic vDSO datastore rework in commit 05988dba1179
("vdso/datastore: Allocate data pages dynamically") incidentally avoids
the problem by switching the mapping to VM_MIXEDMAP + vmf_insert_page()
with balanced struct-page accounting. This patch fixes the still-affected
VM_PFNMAP path used by 6.18.y and earlier, and additionally makes
page_table_check robust against any future PFN-mapped user pages.

Fixes: df4e817b7108 ("mm: page table check")
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Reported-by: syzbot+2b5fe617654be3d8848b@syzkaller.appspotmail.com
Closes: https://github.com/siderolabs/talos/issues/13496
Cc: stable@vger.kernel.org
Signed-off-by: Andrey Smirnov <andrey.smirnov@siderolabs.com>
---
 mm/page_table_check.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/mm/page_table_check.c b/mm/page_table_check.c
index 4eeca782b888..ee492d5389b9 100644
--- a/mm/page_table_check.c
+++ b/mm/page_table_check.c
@@ -150,9 +150,16 @@ void __page_table_check_pte_clear(struct mm_struct *mm, pte_t pte)
 	if (&init_mm == mm)
 		return;
 
-	if (pte_user_accessible_page(pte)) {
+	/*
+	 * PFN-mapped (special) PTEs - e.g. the vDSO/time-namespace "[vvar]"
+	 * mapping installed via vmf_insert_pfn() - are not rmap-managed and
+	 * must not be tracked here. Tracking them can leave a non-zero map
+	 * count on a struct page that is later freed (the time namespace VVAR
+	 * page in free_time_ns()), tripping the BUG_ON() in
+	 * __page_table_check_zero().
+	 */
+	if (pte_user_accessible_page(pte) && !pte_special(pte))
 		page_table_check_clear(pte_pfn(pte), PAGE_SIZE >> PAGE_SHIFT);
-	}
 }
 EXPORT_SYMBOL(__page_table_check_pte_clear);
 
@@ -205,7 +212,7 @@ void __page_table_check_ptes_set(struct mm_struct *mm, pte_t *ptep, pte_t pte,
 
 	for (i = 0; i < nr; i++)
 		__page_table_check_pte_clear(mm, ptep_get(ptep + i));
-	if (pte_user_accessible_page(pte))
+	if (pte_user_accessible_page(pte) && !pte_special(pte))
 		page_table_check_set(pte_pfn(pte), nr, pte_write(pte));
 }
 EXPORT_SYMBOL(__page_table_check_ptes_set);
-- 
2.53.0


