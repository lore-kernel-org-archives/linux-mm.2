Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C04DC43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 21:45:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 610096B0088; Sun, 28 Jun 2026 17:45:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C0FF6B008A; Sun, 28 Jun 2026 17:45:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43A9D6B0092; Sun, 28 Jun 2026 17:45:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 067C66B0088
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 17:45:38 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 43D35404CF
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 21:45:38 +0000 (UTC)
X-FDA: 84930653556.28.A355FF1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id A87FC40006
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 21:45:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ScNyX3oa;
	spf=pass (imf04.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782683135;
	b=u2rwqWRdZLRNBk0ECdAEGoSSdmKrbF9CzsHT2IgYrK9ucWLIm5x3aXtikfJl115pvRq0KV
	nAEgmUDXBrOaBhu9lCwrkagTfeCvPa8Ctc8hDKfFh0uOIBum4VHxDZgGLYiMetxbrG1uG1
	0+bSbLkpIMmE65dvxpleDVUq3fDeVeI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782683135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SiJhyXhNBfsAzo8nGoH5kDNlW+30TFjfN78Hcf1BrTc=;
	b=VMY/gV8uqG35szxTdO0NNUSbwxs5dod1sv3VVc69/7jFjRbEG+Vyu326kCORx0Eis3F+1B
	tdiODePtaZnXGzD4rZnoFchDl2zLeCxN7ftpb4OXF40yTNXpAeB3QP28VUodJSxPFEs+z4
	sXdbVnZHZy1AzyNxZDz6btO62VZWguo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ScNyX3oa;
	spf=pass (imf04.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782683135;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SiJhyXhNBfsAzo8nGoH5kDNlW+30TFjfN78Hcf1BrTc=;
	b=ScNyX3oaWvNeraRba9l46q7kmnb7+N15lswlWZQ38h8drBfBhswyLvHcgR7jBuioPa/4Rr
	4Xp2B/Y44glPYPQ73sQn1IVkWy2njGYrEumVsGwkLY6S/GQqmyheHbUk+7Lm+HRLaaJTV+
	SKn5UCnwX3eCHLAReN42poUXrZiPe5g=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-78-6p7Oq2RYPBmL_NoIrVg3cA-1; Sun, 28 Jun 2026 17:45:33 -0400
X-MC-Unique: 6p7Oq2RYPBmL_NoIrVg3cA-1
X-Mimecast-MFC-AGG-ID: 6p7Oq2RYPBmL_NoIrVg3cA_1782683133
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-47132f8a98aso1238210f8f.1
        for <linux-mm@kvack.org>; Sun, 28 Jun 2026 14:45:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782683132; x=1783287932;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SiJhyXhNBfsAzo8nGoH5kDNlW+30TFjfN78Hcf1BrTc=;
        b=CwasSj9P0P2bEXIGhcrqfXd7D8XJBNxsXcAvmk1xh/z/kO9nrfgeOdlpOqY3Zqksvb
         pUOdux0PnT3NwTNGqK+Z7v6OHC/cU89hZbTQN3KI643Af6/ncbyYfvn0cNAzZXRBazUK
         FI1DXhuGuzmLzwPg+4qjktPl1zGGJZonJRnxm/OPIpongeU/IL5bE7PiLbc0A0X6NWMY
         Br1vAHBTAAzZjToBfa6wegz5TZ3QBK7D/KgpvOL3WMaHrNoczQuRyMR+RIHRrG1gzU51
         MEcxUHohd3HwpA6kEfK7TM6YvpNUEugeonO0iYT7FupvU0+vXXhGvvLzSHmzdU8h2QdN
         qIcA==
X-Forwarded-Encrypted: i=1; AHgh+Rr3EbpJZSldT3q+K7sAf9BmEc5N7cyDfdRlv2DGRgRlXm3Kzp718tUgQwrWiBJu/1KsvePdrngbdg==@kvack.org
X-Gm-Message-State: AOJu0YxgX6ra5Yuz0+EcIT/7yp5MuLuoZEThhtmJ2xHJFLukSPDkh92p
	usgcjdP0Ar68K3bcbDFM8WYbMEuGEK63x7hfuBJjsU+ko94vKWZmkent/6BuMqR1L29Dw9auTtF
	GeBCQ9nBwhh9zyWtgqaVgxo7toZM8XPnzvoNX/GGblZ3JcrMcqSnM
X-Gm-Gg: AfdE7cnGFTov52CJd2yBStCuXkugUwAAH006OELXwFvZQzuPOiFTrfRxYnqFVMxIMC3
	kL3cENffWlyMuCpoyyu5GZu/ofiHJjPLJbT0t1X+0VyLYcEflaay7WAwvk9yVtN7nWtJ8JMZzDn
	kn6o7oqdJtPfFYGxALSDNnhLSZsMEEMXyGwe65qZH5qFo/d4uHAroff9QmrWcttKj5nNV+R3KfB
	rOJaOJ1sZGThrxezh1X0KPQD4PQI8PO/a/x2dKRUUvXnfwBmjwjsG0niZ7P/UXZajb0vJwibWZ+
	uhhBWQwe71yNoG1kwgxZAKJa+qBtWh4+R8t6a7ZS4Kitz1R2rMA30arRIQe0YP1OLY8lKS3pFa8
	0
X-Received: by 2002:a05:6000:4285:b0:45e:fa7b:a7d2 with SMTP id ffacd0b85a97d-46fb6bf2caamr14037826f8f.7.1782683132439;
        Sun, 28 Jun 2026 14:45:32 -0700 (PDT)
X-Received: by 2002:a05:6000:4285:b0:45e:fa7b:a7d2 with SMTP id ffacd0b85a97d-46fb6bf2caamr14037797f8f.7.1782683131891;
        Sun, 28 Jun 2026 14:45:31 -0700 (PDT)
Received: from redhat.com ([31.187.78.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46f978dc0a9sm20747231f8f.15.2026.06.28.14.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2026 14:45:31 -0700 (PDT)
Date: Sun, 28 Jun 2026 17:45:27 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andi Kleen <andi@firstfloor.org>,
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	Rik van Riel <riel@redhat.com>, Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>, Byungchul Park <byungchul@sk.com>,
	linux-mm@kvack.org, linux-cxl@vger.kernel.org,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH 1/2] mm: memory-failure: use RCU to fix HWPoison flag race
Message-ID: <e2d32b6bd7322f855ec8ae4ddda4b5ced27f261d.1782676497.git.mst@redhat.com>
References: <cover.1782676497.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1782676497.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4noHLCASWVzjr-Ur4tlut6JIMrgZTeQP4KXPatqP1_k_1782683133
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A87FC40006
X-Stat-Signature: x4auehaq64syap4rftb6iuix3eewxwzn
X-HE-Tag: 1782683135-401053
X-HE-Meta: U2FsdGVkX1/8na7T9NP89QlTBskG45MU5owxReTVNaV9WE0ddCj7kUDhLY56dyeVSVlMZkvGFWRQMlptueaw1DFiT/J9lXILjN3hqemotWxwCnl9TVcCIkxCTrlUbugRCVmBtEYYvJ6ui95HSV0O6wXKtmFC4onGa+91Xe+2wsY0+CQhtn7qLPWokBQnfC52dXYcrkol7H7Cr8QYE0Bx19BILLHVSmnuNggkfSP2JliAKYR5RQCQM1TM/AgRgMusHADn9uL28IMuRtjcR7Q5wbOB5asPTvRD3K/9ukcS/biv8gA7M+ieT3KQODzNITJ/rcHKfLQdp9YhDAESVhA+IkcUEE+mwb9zxos3mCDHnoHifnzbwo2GYHkGN+pHOavm9AXNMQRwrRH33a5oTbF4nblxKVZdylz0tzPrakGGG8ZoREkZd6FCw983D48OFspWHywoEaR6iT/d8WcOoWmuI3keAgNrFsG5iA2YdvUHwaj+v8MkzbtkeSmgA39m7Fmrg+wAXSmkLQ9ygEtBr22seqMRGwhiTwFTo+dQ+P0EwR4/3BG77dzbo8T8kFhTO22aD5kTBPoUwjNPq4Hfr7+Z6lf/bwVI5hNtDrP8b74v9zhp7HY29dx4hz9aTI6YcCbR4+3ivH/zmfw3B1xCSdX/+D9RbS5BmWLNLoIhWe2zC7lPGZZ2E5QzlcHT+wrdpMmb3CqyD88sqgIJfXyMY/webhkc/QyfLr7wYW1J7IesDj2PtvsbC9l1UROhNJU9guG5ECJaSFIVpwzIsMwWLphXXP4kfgSMFoGWt6PuuScHu0dLBrgDxPtuhb1kK19lSC/IDSddacGNlMxgCwMF3QTCfALw+utdwr0GhSE95+FN8eXZhMM7oA4/wIZWdNDCRt4HNov/P3jFEgKyTglIDszAHEE7wt+Pn2bvkNm2p56umosbxqI+l6g4tXkiN5ljnvTuS5vjorckBhdmKEkn33i
 27sDi47k
 ZoXXSMVKriRITGfgpKlmXjd4aiAKX6DTVfiTFSHcdkV7gY6ov4Rgg2KLTtDRxhitxPZW6keKKUdNoJfVRSg1GD3UUsZn4anqQOspGS7+oQfP2klHyyNV0UIhII7A1lLEda/KF9eKJ2LsfBES44GlKRH2MDEZUnCBvEXnAlcCcLpQo59cRdskxAmjcVRU1GDJ2ZBvxdtwTNB2erY8dEkd19gJSjZqEtJMkDX9wf7lQXo8DdpRCm+HyrtoZXSEZi1h+NUsTtZlFH5pxxkCcxPfbvX2JmTGybT0nwd8t7iUI/9FezX3jx5TexpfcMNXWCmCdz1wJtYAxTFtLVpG8GbYEciykdOCAiFVezNI3Ejb60RGpkAAc2uRTVLD0OiwfvC1j20PmukGih5FL4E7MFsvTGmeCbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Non-atomic page flag operations (page->flags.f &= ~mask, __set_bit,
__clear_bit) can race with atomic TestSetPageHWPoison() in
memory_failure().  The non-atomic RMW reads flags, memory_failure()
atomically sets HWPoison, then the RMW writes back the old value
without HWPoison - clobbering the bit.

Add synchronize_rcu() + retry helpers for setting and clearing
HWPoison, and convert all memory_failure() call sites to use them.
Follow-up patches wrap non-atomic page flag operations in
rcu_read_lock/rcu_read_unlock so that synchronize_rcu() drains
in-flight callers.

Note: the MCE handler in arch/x86/kernel/cpu/mce/core.c also calls
SetPageHWPoison() and is subject to the same race.  It cannot use
the drain helpers (MCE context cannot call synchronize_rcu()).
For recoverable MCE errors, memory_failure() is queued via work
items (kill_me_maybe/kill_me_never) and will re-set the bit via
test_and_set_hwpoison_drain_rcu() if it was clobbered.  The
mce_panic() path sets HWPoison for kdump right before panic() so
the race should not matter there.  The MCG_STATUS_SEAM_NR path does
not queue memory_failure(), but the affected page belongs to a
TDX guest whose CPU core has already been marked dead - the page
is not subject to concurrent non-atomic flag operations in the
buddy allocator, so the race does not trigger.

Fixes: 6a46079cf57a ("HWPOISON: The high level memory error handler in the VM v7")
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: Cursor:gpt-5.4-xhigh-fast
---
 mm/memory-failure.c | 54 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 46 insertions(+), 8 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index ee42d4361309..351f8bbda248 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -76,6 +76,44 @@ static int sysctl_enable_soft_offline __read_mostly = 1;
 
 atomic_long_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);
 
+/*
+ * Drain any in-flight non-atomic page flag operations that could
+ * clobber a concurrently set HWPoison bit.  Retries until the bit sticks.
+ */
+static void set_hwpoison_drain_rcu(struct page *p)
+{
+	do {
+		synchronize_rcu();
+	} while (!TestSetPageHWPoison(p));
+}
+
+/*
+ * Drain any in-flight non-atomic page flag operations that could
+ * restore the HWPoison bit from stale data.  Retries until it stays clear.
+ */
+static void clear_hwpoison_drain_rcu(struct page *p)
+{
+	do {
+		synchronize_rcu();
+	} while (TestClearPageHWPoison(p));
+}
+
+static bool test_and_set_hwpoison_drain_rcu(struct page *p)
+{
+	bool was_set = TestSetPageHWPoison(p);
+
+	set_hwpoison_drain_rcu(p);
+	return was_set;
+}
+
+static bool test_and_clear_hwpoison_drain_rcu(struct page *p)
+{
+	bool was_set = TestClearPageHWPoison(p);
+
+	clear_hwpoison_drain_rcu(p);
+	return was_set;
+}
+
 static bool hw_memory_failure __read_mostly = false;
 
 static DEFINE_MUTEX(mf_mutex);
@@ -211,7 +249,7 @@ static bool page_handle_poison(struct page *page, bool hugepage_or_freepage, boo
 			return false;
 	}
 
-	SetPageHWPoison(page);
+	set_hwpoison_drain_rcu(page);
 	if (release)
 		put_page(page);
 	page_ref_inc(page);
@@ -1756,7 +1794,7 @@ static int mf_generic_kill_procs(unsigned long long pfn, int flags,
 	 * Use this flag as an indication that the dax page has been
 	 * remapped UC to prevent speculative consumption of poison.
 	 */
-	SetPageHWPoison(&folio->page);
+	set_hwpoison_drain_rcu(&folio->page);
 
 	/*
 	 * Unlike System-RAM there is no possibility to swap in a
@@ -1801,7 +1839,7 @@ int mf_dax_kill_procs(struct address_space *mapping, pgoff_t index,
 			goto unlock;
 
 		if (!pre_remove)
-			SetPageHWPoison(page);
+			set_hwpoison_drain_rcu(page);
 
 		/*
 		 * The pre_remove case is revoking access, the memory is still
@@ -1878,7 +1916,7 @@ static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
 	head = llist_del_all(raw_hwp_list_head(folio));
 	llist_for_each_entry_safe(p, next, head, node) {
 		if (move_flag)
-			SetPageHWPoison(p->page);
+			set_hwpoison_drain_rcu(p->page);
 		else
 			num_poisoned_pages_sub(page_to_pfn(p->page), 1);
 		kfree(p);
@@ -2390,7 +2428,7 @@ int memory_failure(unsigned long pfn, int flags)
 	if (hugetlb)
 		goto unlock_mutex;
 
-	if (TestSetPageHWPoison(p)) {
+	if (test_and_set_hwpoison_drain_rcu(p)) {
 		res = -EHWPOISON;
 		if (flags & MF_ACTION_REQUIRED)
 			res = kill_accessing_process(current, pfn, flags);
@@ -2420,7 +2458,7 @@ int memory_failure(unsigned long pfn, int flags)
 			} else {
 				/* We lost the race, try again */
 				if (retry) {
-					ClearPageHWPoison(p);
+					clear_hwpoison_drain_rcu(p);
 					retry = false;
 					goto try_again;
 				}
@@ -2441,7 +2479,7 @@ int memory_failure(unsigned long pfn, int flags)
 	/* filter pages that are protected from hwpoison test by users */
 	folio_lock(folio);
 	if (hwpoison_filter(p)) {
-		ClearPageHWPoison(p);
+		clear_hwpoison_drain_rcu(p);
 		folio_unlock(folio);
 		folio_put(folio);
 		res = -EOPNOTSUPP;
@@ -2761,7 +2799,7 @@ int unpoison_memory(unsigned long pfn)
 		}
 
 		folio_put(folio);
-		if (TestClearPageHWPoison(p)) {
+		if (test_and_clear_hwpoison_drain_rcu(p)) {
 			folio_put(folio);
 			ret = 0;
 		}
-- 
MST


