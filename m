Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3AEAC44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 17:31:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D743F6B00D5; Fri, 17 Jul 2026 13:31:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4A536B00D6; Fri, 17 Jul 2026 13:31:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C60986B00D7; Fri, 17 Jul 2026 13:31:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9FC006B00D5
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:31:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 33942801E8
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:31:05 +0000 (UTC)
X-FDA: 84998959290.12.8C75F78
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 74ABF14000B
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:31:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DYQijovd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784309463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jGfvVz5phYfszb4vs/wrQwKbo5YfQ9htQgjlD4h0uzo=;
	b=dqf4SjkBIJHgkXLpWqxxmhy8U0WtReQnNN5OHdV6Qb6/TkIONInJlNR9OybwYrzVu0FMQY
	/FuKrpLn6l0DjPMUTNwS/0jPBHrU2/aFe0fET5qKQrhzBoX9iL+hVPw8JbBtGf61eFTsEA
	hkW+/7mzkMYD3opsPapCrConHDcFGkI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DYQijovd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784309463;
	b=NaE4JnnCIyYCGAOkp7XodQrLks4fKd3ZSMq5kMI4zRPNJ2s8EZnaIBB0oQNmiISjAD3oJv
	P6Sk52bpu1QFcRQXj/rCXHkOrMgRBXUvQca3YCOwhfo+dMgkNMtcGkvXuXZoRglz6rBLa9
	BIHvGsPx9e7cx/V04E/g4PkrERrfvpI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F300560A74;
	Fri, 17 Jul 2026 17:31:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF911F000E9;
	Fri, 17 Jul 2026 17:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784309462;
	bh=jGfvVz5phYfszb4vs/wrQwKbo5YfQ9htQgjlD4h0uzo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DYQijovd054GG2wU3z7XMoKsnqNogdfpJ+OCYKtauwMoBZtvbLhprNGmeh+1j3wkt
	 /kqqZmxWLbM2EfHqTuQPWREroE7kObjwev+cigZ3gExShhUSE05tjJ/eLczaGqQ4qK
	 cFj2JveVjO1V9Cc0nFDhAiWYGGHJABDU4EuJpvsG4w7U0cS8/Le4Pgl4xh1hR7DIEw
	 p+wyed3zInNffSwUkz/PC7sGtzuaio9mHkKltJaAb5WkHCqTvRLYGjvjVnZamvd6rx
	 0q8ZQe5y1FGmXnpocY1jnKhEZrute7gnN8qhFvMfonPTZ618WoLrJQl3KtWeZGP8Az
	 mS3L78Qs9gIpw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 17 Jul 2026 18:30:08 +0100
Subject: [PATCH mm-hotfixes v5 2/5] x86/mm/pat: acquire init_mm write lock
 on collapse to avoid UAF
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-series-vmap-race-fix-v5-2-606a0ac6d3e5@kernel.org>
References: <20260717-series-vmap-race-fix-v5-0-606a0ac6d3e5@kernel.org>
In-Reply-To: <20260717-series-vmap-race-fix-v5-0-606a0ac6d3e5@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Uladzislau Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Dev Jain <dev.jain@arm.com>, Ryan Roberts <ryan.roberts@arm.com>
Cc: David Carlier <devnexen@gmail.com>, ljs@kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, "Denis V. Lunev" <den@virtuozzo.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4047; i=ljs@kernel.org;
 h=from:subject:message-id; bh=3isjtK28wb1BiLlMBIpy71VvY1jYYrdz7YUUYuIwCk8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKi0rZJZfsl737mbpD55EnArs8aCv9C575vYr5c8sBJ+
 E1ubYdpRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACZy6irD/+hLhquku2w+zP3V
 zF6zRaj+pt3Je7ZPdoaVxEr/2t40/SQjw+fK9LjUr3KzDSfMK5f6Oj/vWOWjymcrT+ctUGHd4mP
 yhhUA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: 74ABF14000B
X-Stat-Signature: hskgmp3bo6ibtbqy91xczuog5guz5hs1
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784309463-28869
X-HE-Meta: U2FsdGVkX18rmUE8xHpp+FBRJowNAidU7qMxuouLkVMFl/hT6Olk/lmm59JRHQe++bzFeLdNFDy36SetTJAdynwCAO1fmuHjNP7kjpev8sT1x5f+lKAHvc3JY6AbdS8R8b59x0syrvLS9zUufZiDpQaLUNtFqqPTxhOzUjRm2Dpsf+IwYo62OFGpQj/Qv4NzfnvxttIwQgvViuR0/c97qln1dDj6t0G6suCT/fjFfbo1Z5qsJ8t8Ycp7XNty0bszFgOERVyHN3uaHJWfiGnVXQeC5Lih09O4AQHAqpHUponIKefxPc855dvZkcr4E8NHJGijRdzMs/Ga5c+3aRvfvD8x1rdJxNNlKADgIcxefgtN/3JcR0IQGTa2VeIq0CxGleF+9FbW1W/TrpwlfWunu5Id6fV7ysBbulrhozItdR2ElYZo4q/rDD4IpMWxy0gQCT1Ro2c6RE0JUzLHtA6rpnh+JHrcZxz2VsTu4BbyL8eQPLa09rwvUqbTE7eP16HcVkm6dMaFJC8j7G+nYTDO1H2h9aZG6oLLXmf1MroH/I4y/AT9QhZYAKqp97iAXLW2RMFXD356sQ42X5SpHLhGApDvBvi8/AHAik34ARPKf/6IXZ4XpjeziYrSKwxluL6j1EGZAa/1a9KBg6dO4GUIB9nDqZkxPGGhjlqXaBDxjVksvxSTOHhf1Cp9FFZlpNkDN3nEYbTybEbhiWYmBlc836DU4cpzvDIWmf3If5axVc11sN5+YlcS4dgSvzsEADG9xXjCzTZpExJPHHe1SpRqfcG0LShpu1/2z5J+YbkhObCb6xbgmR80LlF76oYUdOtVVb8dDe6MM2BrGYtv1RaBT29VNGaRF/bOw2bSZWRoMGvXyrlPSwfz7JFql6pbeZd5G1RurMZsXf4sxT9Q61UTXAtRja3+vUOTJVk6Ck0L93PO+9Lh+3bAK8YtsqQM5dygmCNP7xfe0F6c1cZSpgk
 ovcuH+DH
 ZvPCC2snFlAFIJSXXks/t5yo1UHjrZtayRG+s2qm/Dp6Vu/EO1Eld+WfDhE2AbjoBSgKrxmxusqeEJ2FBvDpfZK1bSDBY4PvWGWr48PTI5dTIVtU5joY80iCjTwDkSVEhbQ0+pRMfupCmFEMYNjUoo3buW7XExxE+YzlRNrkkuq0ocalG26UehZaK1k18UDTkeHuMof6+LNryrctWxWlanssUB1yuSU31699xuGsgFIaeWSDkqYIS01mvMTcn4oZpBKvV9Gai/miGboR9BJ69mR6sQj4X6QZgBEc/1nCvwmQMeNhhbNNhUwcxWXww3tA5X7705xVTfQ/dEeLJe7xO9QUguw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

x86 implements page attribute modification using its Change Page
Attributes (CPA) mechanism.

This tracks properties of ranges such as cache mode through x86 page
attributes, and as part of that logic manipulates kernel page tables.

Since commit 41d88484c71c ("x86/mm/pat: restore large ROX pages after
fragmentation") ranges of kernel page table entries can be collapsed into
huge page table entries as part of this logic.

As part of this collapse, it frees the page tables which the collapsed
entries previously pointed to, and it does so without any relevant locks
being held to preclude concurrent kernel page table walkers.

The only way this code can be reached is if CPA_COLLAPSE is specified, and
this is only set in set_memory_rox() via:

set_memory_rox()
-> change_page_attr_set_clr()
-> cpa_flush()
-> cpa_collapse_large_pages()

Notable users of this are execmem and bpf when manipulating executable
mappings.

However, this is problematic for ptdump as it walks ranges it does not own
and thus runs the risk of a use-after-free on page tables freed underneath
it.

In addition, concurrent CPA collapse operations are possible which can also
cause races.

Resolve the issue by acquiring the mmap write lock on init_mm across the
whole operation.

It is safe to acquire a sleeping lock as all the callers invoke
set_memory_rox() from process context and in any case,
change_page_attr_set_clr() calls vm_unmap_alias() which ultimately takes a
mutex, disallowing atomic context here.

Fixes: 41d88484c71c ("x86/mm/pat: restore large ROX pages after fragmentation")
Cc: stable@vger.kernel.org
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Will Deacon <will@kernel.org>
Reviewed-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 15 ++++++++++++++-
 include/linux/mmap_lock.h    |  2 ++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index d023a40a1e03..d1e63f7d267f 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -22,6 +22,7 @@
 #include <linux/cc_platform.h>
 #include <linux/set_memory.h>
 #include <linux/memregion.h>
+#include <linux/cleanup.h>
 
 #include <asm/e820/api.h>
 #include <asm/processor.h>
@@ -410,7 +411,7 @@ static void __cpa_flush_tlb(void *data)
 
 static int collapse_large_pages(unsigned long addr, struct list_head *pgtables);
 
-static void cpa_collapse_large_pages(struct cpa_data *cpa)
+static void __cpa_collapse_large_pages(struct cpa_data *cpa)
 {
 	unsigned long start, addr, end;
 	struct ptdesc *ptdesc, *tmp;
@@ -442,6 +443,18 @@ static void cpa_collapse_large_pages(struct cpa_data *cpa)
 	}
 }
 
+static void cpa_collapse_large_pages(struct cpa_data *cpa)
+{
+	/*
+	 * Take the mmap write lock on init_mm to:
+	 * - Avoid a use-after-free if raced by ptdump (which takes its own
+	 *   write lock on init_mm).
+	 * - Serialise concurrent CPA walkers.
+	 */
+	scoped_guard(mmap_write_lock, &init_mm)
+		__cpa_collapse_large_pages(cpa);
+}
+
 static void cpa_flush(struct cpa_data *cpa, int cache)
 {
 	unsigned int i;
diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 6b5c2390cc30..047f5f5e2c34 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -621,6 +621,8 @@ static inline void mmap_read_unlock(struct mm_struct *mm)
 
 DEFINE_GUARD(mmap_read_lock, struct mm_struct *,
 	     mmap_read_lock(_T), mmap_read_unlock(_T))
+DEFINE_GUARD(mmap_write_lock, struct mm_struct *,
+	     mmap_write_lock(_T), mmap_write_unlock(_T))
 DEFINE_GUARD_COND(mmap_read_lock, _try, mmap_read_trylock(_T))
 
 static inline void mmap_read_unlock_non_owner(struct mm_struct *mm)

-- 
2.55.0


