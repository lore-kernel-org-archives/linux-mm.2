Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CD05C5DF74
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:47:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 747866B0378; Sun, 16 Aug 2026 18:46:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F9066B0379; Sun, 16 Aug 2026 18:46:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E8E76B037A; Sun, 16 Aug 2026 18:46:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 28BD26B0378
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:46:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 972071C18EA
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:46:37 +0000 (UTC)
X-FDA: 85108618434.23.618E4B4
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf06.hostedemail.com (Postfix) with ESMTP id ADE2A180004
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:46:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="b Y7a2Sw";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=K4YmaUyL;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CN8cWHp7kEAssTf3TdEJt2sw3VugR1AhfU4UisSCp8o=;
	b=oKSngVAMKyI1ZIxBsiO3FzPZvhm+nGVJsIj7oR7AvNisf6+P8cKhexo80vZzj9eD0tWVcy
	Wsm5AEVUMXKG2AquNyWyRIBPa5f7re+tqg2Eo3J6Me9nzBO/0U7Vsr792zLfjVmqXkUNih
	EJkPZpfsoCn/UWN6cSA5mqeGYSUNbyo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="b Y7a2Sw";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=K4YmaUyL;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920395;
	b=l3Y0o66woM+JoNBQRwMXlHy94ONsi4+rjLM0slY3s30GtQ3UoMYJv/tjcwwmyibEzeQWMO
	9agzkPok/0X1H+UHZ/pEqZVAoR/XFlOVAAfy1PnOGKe1Njk0SsKd7ZU/5KhahzNc4NDgR+
	FLaerT2fdS+45/v9aPOOvzljru1Uguk=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 3AC3C14000FA;
	Sun, 16 Aug 2026 18:46:35 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Sun, 16 Aug 2026 18:46:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920395; x=
	1787006795; bh=CN8cWHp7kEAssTf3TdEJt2sw3VugR1AhfU4UisSCp8o=; b=b
	Y7a2Sw+PAG1xudQsxe9IGkUnqymZoX2Cq1eNOP04Yy2NUZ+C+Wkgvw/TTYv+X9L0
	bTIPxLBj3YSQKI5wPX0UCTW3kvRQokWtIAsuKRHmG7/f4nMrA3rowp1SejoQY3vq
	vL7R2RuJwZ9Mg/y17i0ueFGqj+/Iqbe/SnP6LNkN9DgyPO0cKtNkfBEpUQ4cZNRW
	CJzYSTvOciq2OCRW+yxmvYuz8ybnlpOHoek71IhEV8J9346OIytu75F4P5qdWvVW
	bvWfqbE+G4Or6OM4bUrGjDLwZsnDudWwokkRvnB6V/cf1iFF33buH6AePHJftuYj
	nQUYimQIlApAcnnuZYJBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920395; x=1787006795; bh=C
	N8cWHp7kEAssTf3TdEJt2sw3VugR1AhfU4UisSCp8o=; b=K4YmaUyLkLOHPK1ix
	7zo/Kse1Y5W5wYkKJ34DydDerQpHAfbawbISXBZxhWMSECKn0jhy8LH+rB/uNK8x
	bpN3HH27CyxXBncBUyw3BPPv2isG7iRAlKurw00e2BqR721uJF3YNXSaifZHU8r7
	r4xNshww1hWzdQNICdHdksD1Bn+OM6hsZVryj2vDYDBAV7RXTKkPiHct54oOj7Tc
	XbWqalJr3gE2mJak39cwbwhmdjFUuxsgBhDN84kzYryeLtlxznHabxambeIcjCDh
	04jJDZByaZf04YXGHIp5PkvJXrAFRCm66/VVj0oYWWCk4gg7LMsT+8wooFRykqh2
	MC4Xg==
X-ME-Sender: <xms:yj2Cakijj56NnIBnH8-m6rm3u315qZ8tEsEqx2zNd-VWNctLrS21CQ>
    <xme:yj2CaiVrrlAcATlViuAOK3kelK9oyUYUG2mdfDYRbiGdTYFC_1rZs4DmEZ5CT4b2l
    OQ7_s4NHJt6yma6XWmplaDdJ3qYnlQmSPpL9L8DV_ZEzFRcxrGKCgN6>
X-ME-Received: <xmr:yj2CaoLUcEfrt46x3EC5rnHT7bX-9z9hJyIHmEODGeI7GxZqMHNvMrjDmIM>
X-ME-Proxy-Cause: dmFkZTGQiHMMNOd1xnoN6lXQSIrGAe7MwYo75Qud3VSOh3aIjL1T4IX+wE1i/v23Y8aWnG
    m9SHT5inuXsr6fNeLF7q+XcMZ+pkZJxjpb2XQQyKrFdYKaLz7QDFEiegvQaT+Y5rGxRgjF
    euipinLXiFMtCpFgMqQP9Dwn4SHq3YG285QsMU4KB7YfRQHYWKIG6dJTmdP/7bPKv1qUNe
    3LkhBXaaROXWrLGafj+UVrogU8Abxo2OvgWTBKIlLl3SY5Eb27sggkfdoaZJgpjY1+W5mK
    IYgTH3bmg7umgeRjJmx+WAhyhWPmGn2xLzWKHa3nzXVCTdFk2+6Uh9D41+s+1+4ThvFtgo
    5zg/3qDFuCLK/R4oQt+pvC0QjgMhDXb5EXIIFWtX7kNVP0YSW/7JBU5omCjUzM7elgoUGw
    UYgSR9+whjAWV+aVhXHXy0vKt61g56d+GtkunQxxbCr1+YORbs4nmAAJkjtQwjXlNP9QB0
    tUUv+dhhvQmjNmt2ZN67pTE/IPOoWUHNvjAWz0p4ASmnGGj/aQTyXNnbyqDa8qYzTzSG6S
    Kn5NwNoH7Lf0tH8MPzHEvXuZxRUcX/tRsg0aT0y6dmAkkoI3BRUor7gvB/8xwSQP7qXPQX
    CxoSG0dqiVxgJLqTEM9syNbIXyhJihGbchjHU3rbyaRL2T/i8tCDOzBcitiA
X-ME-Proxy: <xmx:yj2Cah0qXEtnsEEkVx9sy4YWE9kmz-VLOuibILIBh13i7d1ejq5mKA>
    <xmx:yj2CaoA9Mdy1yMlzhXyqDy5FlLC_ypU7JjV58U0P-r-s4KObJauYHg>
    <xmx:yj2CatdNOcBa5w1r2hIP-TM60j9BN8Js1dDMfFxuLNPngXLevdrjfg>
    <xmx:yj2CajyjUeWUJersz7tM-fPRbCLt5kDmyDnWADQHco4alHaM-KbTCA>
    <xmx:yz2CauD-KhBWbP02PE-6mO9FSFLVFYBar4Sifl-MlECl2dNpw7Wj4XFF>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:46:34 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org,
	jannh@google.com,
	willy@infradead.org,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [RFC PATCH 09/57] mm/collapse: collect candidate windows into a round
Date: Sun, 16 Aug 2026 23:45:21 +0100
Message-ID: <20260816224609.308019-10-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 1p7777ywewreda65ozcozmhnfbb4duhe
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: ADE2A180004
X-HE-Tag: 1786920395-866074
X-HE-Meta: U2FsdGVkX1+SDBh3k/6Fi5dV+DqoaDIaWNuQfir9drtKU089qXrmHc1WrcHaOcARSPJ0JVlMAAdfVrqowAL+SyByWz5iLkUUr6Yauz+hXzIZlV79Mr68cg4XdcXa+U+Gxk/aawAyyU2cm7WpWnGJwJjok/3O05NUVSxjwH2qomZStX8UKT7k8QmSEewHc7w2nds4jFGOLnfM5G0WISeL3vf+zyrh+RLR/iV1pVS9DFwRB8NJNOWsxW5m4DA2vYgf/n5AvxrNNAodDvbtlKNdBH4Url0JCs8nfmEuOIRm7jzPspcde94c4Ps936Ak9gO4i6roeBBJ6F8w2Jgwfibmx2fan0wfK4I6p0Pc4LnnR+p+vfNxhZSbPBwdFsMjsJjxXU283+H+2QIrxa39g73ojjEu0F9JcJ4Ec1mGfkmYU6QPS4Qt+GbNxKctoIId5FduN4o3DpRWZXE+jkJ886UoFJPAFg/RCf5ZY8j5tZy0Zy6DV0Zqx3M3uqSN3zTITZKC0Xisg8fwH/ZXozfWATwtyA1pERO+sRt4CO6Zjf5/1ai1wkkUovamkcY/YUBcT2TkHNUfhs9ZVku9te1WBxU1lWC2S+GnXYCEaR3R36TU1p693cIDD1K3ak7Z4aOmCpgPBS/HB9lu7+BGgmXJc+uI88AVcUxH+LmL52gsAcPitEOnyREOd2ijoWkMEBtLyB9Dl4NNi7LjlYTu0tHkOctUcKnGQTblbJmaBW0g+E41OGVJsReq0+J++cFeejIIeugWvfCQHG86nqqHHOBZTU3Wu4mYKlF9WoXWvzUv0Gr8IL9+gio98GPDu1lzRL8917OjFV0M2ZJLZuhbrNR2h3Zh3cHF/dbRVaFa9qgu/4482Z8NswG31dv1zx81GcYq8+CTJCDTrItGwVoxxKe85wrKkNGznPpFXKd9iJarkcEBnzyDz5EZ3nBx7Z2NCu+RviBG47cSiXfy2RYhd9bPu4y
 5RrdtAvP
 ZDcz0v+JCClH79rPzu/7ylvtGunYGGLVsN5je3vacRlIgX76Z2B33/1KeGFUdj8qN/c2y8rrRulyoUF0+BhxfiuiGf1w2gTsMZ0AoONL+Pt4xAxcuVbm+oWhd+8RkOygKdFkSvbc7quc1QAUcjDVYVMtPTzn/BAH7BNMr2TnsOfv8YbzbdCHGNqxwdgO4wVpZd0M028WPJcop1Sr3Oip8eYSIJ4dreJfJzm5hLE0JpNcY6sww8Z6KebCyC/3Jcx3ndWoEY3OamgfEfcnIpv7Job/gJbd7tBE0mch7QyVxKe8mIDoKmTAlfntJ2gCHvAcEo/FQvQCjta+VYTulpqXRo8x0E86ob9FjD/b6vSlYEQ2iafF6Pi8pgaj1A20E4Md95+z9gYkdBCprfP1vKcCiapmuDnlhIGtMtp29XqJNbeRYl9qmzyJu6RjbY3+tjuu/Mvw7E42BK6dmU1E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

collapse_anon_pmd() is the half of a table's collapse that follows the
scan: cut windows out of the PTEs the scan accepted, and run them.  It
runs them a round at a time, so a round needs somewhere to be collected.

Add that array to collapse_control.  Its size is the number of windows
one table holds at the smallest order a collapse builds, or as many as
the byte cap allows, whichever is fewer.

A round is capped because it holds destination folios that are allocated
but not yet installed, and because a faulter on any source inside it
waits for the round to finish.  A dense table is collapsed as several
rounds rather than one.

The array is too large for the stack.  khugepaged takes it when the
daemon starts, so an allocation failure is reported to the sysfs write
that enabled khugepaged rather than surfacing inside the daemon;
MADV_COLLAPSE takes one per call.

collapse_anon_pmd() then gets its shape.  Take candidates from selection
until the round is full or selection is done, run the round, and stop
once selection has nothing left and the round is empty.  A candidate the
full round could not take stays pending for the next one, so nothing is
dropped at the boundary.

Selection and the batch run are stubs here, so the loop collects nothing
and the range still yields nothing.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/collapse.c   | 156 +++++++++++++++++++++++++++++++++++++++++++++++-
 mm/collapse.h   |   9 +++
 mm/khugepaged.c |  24 +++++++-
 3 files changed, 185 insertions(+), 4 deletions(-)

diff --git a/mm/collapse.c b/mm/collapse.c
index 66931ef6a6d0..6dae5e35e61d 100644
--- a/mm/collapse.c
+++ b/mm/collapse.c
@@ -86,6 +86,52 @@
  * replaces, and is switched over once both halves are complete.
  */
 
+/*
+ * Cap on the memory a round may hold in flight: destination folios allocated
+ * but not yet installed, the fault latency of anything inside a candidate being
+ * collapsed, and memcg charge pressure all scale with it.  A dense table is
+ * collapsed as several rounds rather than one.
+ */
+#define COLLAPSE_BATCH_BYTES		SZ_32M
+
+/* Windows in one table at the finest order collapse cuts */
+#define COLLAPSE_TABLE_WINDOWS	(HPAGE_PMD_NR >> COLLAPSE_MIN_MTHP_ORDER)
+
+/*
+ * How many candidates a round can hold, fixed by the table geometry: the byte
+ * cap decides it at the smallest order collapse builds, but never more than the
+ * windows one table has at that order.
+ */
+#define COLLAPSE_MAX_CANDIDATES						\
+	min(COLLAPSE_BATCH_BYTES >> (PAGE_SHIFT + COLLAPSE_MIN_MTHP_ORDER), \
+	    COLLAPSE_TABLE_WINDOWS)
+
+/*
+ * A candidate is an (addr, order) window selected for collapse.  Selection
+ * counts in PTE offsets -- the bitmap it reads and the alignment it honours are
+ * indexed that way -- while the passes that run a candidate work in addresses,
+ * like the page tables and VMAs they touch.  This is where the two meet.
+ */
+struct collapse_candidate {
+	unsigned long addr;
+	unsigned int order;
+};
+
+void collapse_control_release(struct collapse_control *cc)
+{
+	kfree(cc->candidates);
+	cc->candidates = NULL;
+}
+
+int collapse_control_init(struct collapse_control *cc)
+{
+	cc->nr_candidates = 0;
+	cc->candidates = kmalloc_objs(*cc->candidates, COLLAPSE_MAX_CANDIDATES);
+	if (!cc->candidates)
+		return -ENOMEM;
+	return 0;
+}
+
 /*
  * Is @count past a limit stated per PMD, when only part of a table was scanned?
  * Scale the comparison to the table so a partial scan is held to the same
@@ -389,6 +435,75 @@ collapse_scan_anon_pmd(struct vm_area_struct *vma, unsigned long start,
 	return cc->scan_refusal;
 }
 
+/* Point the selection cursor at [start, end) of the table, in PTE offsets */
+static void collapse_selection_init(struct collapse_control *cc,
+				    unsigned int start, unsigned int end)
+{
+}
+
+/*
+ * The next window worth attempting, as an (offset, order) pair.  False when
+ * selection is exhausted, which is what ends the range.
+ *
+ * A candidate is only ever an (offset, order) pair: the scan that recorded the
+ * eligible PTEs has dropped the ptl, so anything else -- folio pointers in
+ * particular -- would be stale by construction.
+ */
+static bool collapse_next_candidate(struct collapse_control *cc,
+				    unsigned int *offset, unsigned int *order)
+{
+	return false;
+}
+
+/*
+ * Run and classify the collected batch.  Returns false when a candidate's
+ * outcome abandons the table.
+ */
+static bool collapse_run_batch(struct mm_struct *mm, unsigned long pmd_addr,
+			       struct collapse_control *cc)
+{
+	/* collapse_anon_pmd() only runs a round it has put something in */
+	VM_WARN_ON_ONCE(!cc->nr_candidates);
+
+	cc->nr_candidates = 0;
+	return true;
+}
+
+/*
+ * One more candidate of @order would either overflow the array or push what the
+ * round holds past the byte cap.  An empty round takes whatever it is offered:
+ * a single candidate is above the cap all by itself once a PMD is (512M with
+ * 64K pages), and refusing it would collapse nothing at all.
+ */
+static bool collapse_batch_full(struct collapse_control *cc,
+				unsigned long bytes, unsigned int order)
+{
+	if (!cc->nr_candidates)
+		return false;
+
+	return cc->nr_candidates == COLLAPSE_MAX_CANDIDATES ||
+	       bytes + (PAGE_SIZE << order) > COLLAPSE_BATCH_BYTES;
+}
+
+/*
+ * Take the next array slot for the window at @addr.  A slot may still hold a
+ * previous round's values, so every field is set here.
+ */
+static void collapse_add_candidate(struct collapse_control *cc,
+				   unsigned long addr, unsigned int order)
+{
+	struct collapse_candidate *cand;
+
+	/* collapse_batch_full() has already made room */
+	if (WARN_ON_ONCE(cc->nr_candidates >= COLLAPSE_MAX_CANDIDATES))
+		return;
+
+	cand = &cc->candidates[cc->nr_candidates];
+	cc->nr_candidates++;
+	cand->addr = addr;
+	cand->order = order;
+}
+
 /*
  * Cut the table into candidate windows and collapse what fits, from the
  * largest order downwards.  Returns what the table yielded: a collapse, or
@@ -398,5 +513,44 @@ static enum scan_result __maybe_unused
 collapse_anon_pmd(struct mm_struct *mm, unsigned long start, unsigned long end,
 		  struct collapse_control *cc)
 {
-	return SCAN_FAIL;
+	const unsigned long pmd_addr = start & HPAGE_PMD_MASK;
+	unsigned int offset, order;
+	unsigned long bytes = 0;
+	bool pending = false;
+	bool cont = true;
+
+	collapse_selection_init(cc, (start - pmd_addr) >> PAGE_SHIFT,
+				(end - pmd_addr) >> PAGE_SHIFT);
+
+	while (cont) {
+		if (!pending)
+			pending = collapse_next_candidate(cc, &offset, &order);
+
+		if (!pending || collapse_batch_full(cc, bytes, order)) {
+			/*
+			 * Selection is exhausted and the round is empty: the
+			 * range is done.  Without this a flush of an empty
+			 * round would return, collect nothing, and come
+			 * straight back here.
+			 */
+			if (!cc->nr_candidates)
+				break;
+
+			cont = collapse_run_batch(mm, pmd_addr, cc);
+			bytes = 0;
+			continue;
+		}
+
+		/*
+		 * The round holds no resources until it is run, so
+		 * collecting costs nothing but the array slot.  A candidate the
+		 * full round could not take is kept pending for the next one.
+		 */
+		collapse_add_candidate(cc, pmd_addr + offset * PAGE_SIZE, order);
+
+		bytes += PAGE_SIZE << order;
+		pending = false;
+	}
+
+	return cc->nr_collapsed ? SCAN_SUCCEED : SCAN_FAIL;
 }
diff --git a/mm/collapse.h b/mm/collapse.h
index ad88b91d9a72..1159ed39b9eb 100644
--- a/mm/collapse.h
+++ b/mm/collapse.h
@@ -10,6 +10,8 @@
 /* The smallest order a collapse will build, and so the finest window it cuts */
 #define COLLAPSE_MIN_MTHP_ORDER		2
 
+struct collapse_candidate;
+
 enum scan_result {
 	SCAN_FAIL,
 	SCAN_SUCCEED,
@@ -120,8 +122,15 @@ struct collapse_control {
 	 * the collapse reports it when it salvages nothing.
 	 */
 	enum scan_result scan_refusal;
+
+	/* The candidate windows collected for the current round */
+	struct collapse_candidate *candidates;
+	unsigned int nr_candidates;
 };
 
+int collapse_control_init(struct collapse_control *cc);
+void collapse_control_release(struct collapse_control *cc);
+
 /*
  * Defined in khugepaged.c, which still uses them itself.
  * TODO: move each into collapse.c once its last khugepaged.c user is gone.
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 9823884a83c9..43f6107c953a 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -3079,12 +3079,22 @@ int start_stop_khugepaged(void)
 	guard(mutex)(&khugepaged_mutex);
 	if (hugepage_enabled()) {
 		if (!khugepaged_thread) {
-			struct task_struct *new_thread = kthread_run(khugepaged,
-								     NULL,
-								     "khugepaged");
+			struct task_struct *new_thread;
+			int err;
 
+			/*
+			 * The engine collapses out of its candidate array, so
+			 * take it before starting the thread that needs it: a
+			 * failure surfaces here rather than in the daemon.
+			 */
+			err = collapse_control_init(&khugepaged_collapse_control);
+			if (err)
+				return err;
+
+			new_thread = kthread_run(khugepaged, NULL, "khugepaged");
 			if (IS_ERR(new_thread)) {
 				pr_err("khugepaged: kthread_run(khugepaged) failed\n");
+				collapse_control_release(&khugepaged_collapse_control);
 				return PTR_ERR(new_thread);
 			}
 
@@ -3096,6 +3106,7 @@ int start_stop_khugepaged(void)
 	} else if (khugepaged_thread) {
 		kthread_stop(khugepaged_thread);
 		khugepaged_thread = NULL;
+		collapse_control_release(&khugepaged_collapse_control);
 	}
 	set_recommended_min_free_kbytes();
 	return 0;
@@ -3154,6 +3165,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	enum scan_result last_fail = SCAN_FAIL;
 	int thps = 0;
 	bool mmap_unlocked = false;
+	int err;
 
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
@@ -3173,6 +3185,11 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	cc->is_khugepaged = false;
 	collapse_policy_forced(&cc->policy);
 	cc->progress = 0;
+	err = collapse_control_init(cc);
+	if (err) {
+		kfree(cc);
+		return err;
+	}
 
 	mmgrab(mm);
 	lru_add_drain_all();
@@ -3231,6 +3248,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 out_nolock:
 	mmap_assert_locked(mm);
 	mmdrop(mm);
+	collapse_control_release(cc);
 	kfree(cc);
 
 	return thps == ((hend - hstart) >> HPAGE_PMD_SHIFT) ? 0
-- 
2.54.0


