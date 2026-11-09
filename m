Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B867D606A335
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 18:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=lNU/lER6
Received: by kanga.kvack.org (Postfix)
	id BBEBC6B05C7; Mon,  9 Nov 2026 13:26:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B20F56B05C8; Mon,  9 Nov 2026 13:26:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 972B06B05C9; Mon,  9 Nov 2026 13:26:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 655F26B05C7
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:26:00 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E5070C0774
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:25:59 +0000 (UTC)
X-FDA: 85416409638.21.7B1C264
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3536440002
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:25:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="lNU/lER6";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3NBDyagYKCHskqhyynfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--lrizzo.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3NBDyagYKCHskqhyynfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--lrizzo.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794248758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F900AAsyhWSGfvSMjAgbbzmK+pQvO8F59zHwAoO/xyA=;
	b=DGQ3pK2JuBAayyzpJ0J2k6d3sOb1HRxzOSMj7+BCry+gX8SYMHeB+AMNGyOb7SeBa/TaTH
	Myu1bJtOKQpyKKfdLo4N8/7+R++frs+0z3r7iPrX0tRVjbic0L6eY2Lt97SIOgQglCoYiB
	1gmwvrGno66U2j92TFctSEQ/jbbgCuM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="lNU/lER6";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3NBDyagYKCHskqhyynfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--lrizzo.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3NBDyagYKCHskqhyynfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--lrizzo.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794248758;
	b=oOJOFvp8FofGEKkS0wWY9clW65JGZKCARqTe1AvabSZpJwKeB8kXzbVYor9DFIxWf6DO3o
	L5gzIJqKtD2Gj/i0bh03F2etDXOm0PC79PzRxNEQKbj+LhQ9ebiSPrx0PDda5RLskpdkJG
	zKvcJH54GAcYJboyQ/FELnbu064EChc=
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c37b2763f1bso146262566b.1
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 10:25:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794248757; x=1794853557; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=F900AAsyhWSGfvSMjAgbbzmK+pQvO8F59zHwAoO/xyA=;
        b=lNU/lER64IiZ68z/IwnEvBcWNjSfTjx8JtBaYzaKZKcKU9MgZVnfAmzMlQk2Im7ZfT
         U9olxeMSlDyI2x0JlgRmF3g0oKu7MgKZrk8gQnYrDHoYcSVXyV4EbgOT5I0vfk5ma1Hj
         G8Ze8mix/Jt6gv7pVGHxHskKGz3xYaHZvfBcKuiPhCMTBpRg4pLegBd70tIJuvbyE9Hw
         WZfdCImnlh4IFgXVuLEGQPlPIpH17fvWnQhSGQzIAEopdwqukhddvstAjqX4YlkNbe6u
         jKR2kmOZlWblZbJsAaPCsPMB7ZYLX/pLwODoUTy0RXc3/vNXeJfFWxi6OCJQwNFhzCSA
         WtiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794248757; x=1794853557;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F900AAsyhWSGfvSMjAgbbzmK+pQvO8F59zHwAoO/xyA=;
        b=bMveo5NXEJMw4sWnhitKOWix3+Wks33/AaoTIexdlQyNXbZJ2uMNRtrK7GTWDl8YyO
         w5fGKT/R1aRb2P2pADbsQGFWuL55Y5KRy0iYC2hycDpmixus9/rahI7sP8LRJKOG7Fsy
         WBzF9ahu/TeqDqTw0ick2gG1J83V8/WsNldMuhWI8Zr70Gwpiq63IKTmrL3LVLjKhnb6
         Xxl9M+ULoMRhJzFy5nKTpes3qrVjv7g7uxaCU0RVc2dyOJN7PYlelF34JWZ9bEcpftVu
         W3WeVyoge8G9uU5s7PWF/zNh2tbF8SH0zDzFAgU2l+dPKYsWH5P1ZQ35590Vvu50parZ
         ISkw==
X-Forwarded-Encrypted: i=1; AL+hErFLQba9GjASjuMIc+YoMWSriBDkazUmfynMSIIDk0LpkhNkNzwwKbf76EGjGu0uTAawmIJH9Pl1IA==@kvack.org
X-Gm-Message-State: APuU4Z/yQ5AVUGbASrZBqBLZYjsffwJJCojDiG7WLT1Zg0CmzG1qX50t
	r+hq9CO4XemrKrVAX8qOSkshEF4RYj+EuTmhan7G7dkr0G6tv+aU2i7DQkn+h33/K4tTZM4mm7Z
	ZGjaDDw==
X-Received: from ejjj18-n1.prod.google.com ([2002:a05:6938:a092:10b0:c33:6983:9d2f])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:3fa6:b0:c46:bbde:734b
 with SMTP id a640c23a62f3a-c50495f02d5mr16406166b.32.1794248756683; Mon, 09
 Nov 2026 10:25:56 -0800 (PST)
Date: Mon,  9 Nov 2026 18:25:27 +0000
In-Reply-To: <20261003212241.3432303-1-lrizzo@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261109182533.3594984-20-lrizzo@google.com>
Subject: [RFC PATCH v2 19/25] iommu/dma: Stop recycling old PISA pages when
 allocator waste is high
From: Luigi Rizzo <lrizzo@google.com>
To: Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Willem de Bruijn <willemb@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Joshua Washington <joshwash@google.com>, 
	Harshitha Ramamurthy <hramamurthy@google.com>, Alexander Lobakin <aleksander.lobakin@intel.com>, 
	iommu@lists.linux.dev, netdev@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3536440002
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: u5hdg4kujd7bk4mguqhrngoehjsbun6o
X-HE-Tag: 1794248758-512152
X-HE-Meta: U2FsdGVkX19+NoO8FUJ4yc0GcDZc18OSmYccTEshGWfkqBMtVx0AxkXPMvDj1p1twp7cDgAg6VMi7YEQqUOOsMWBhVz4DDsyMpQ4IiEjjy71G6hHpv7PI0ftLoihNLHMdH2gr6IEGliXUmF0SvDpQRVDQwratKZ+lE4Ic2OR/H3kG3rwZqD4c4+ChQ0REMc/hOo9kADOVaB5icXB7xUuMgLWEYWwTPp5SSPeaCmMI5FcsgbdK+WFy75Zeqia3AyXPlB9TLU4lLn3562MtA+RUcN9ZXxk4Ef4XduoFT4U4HrJIoxyV/49xrByS6n20HiYWyHRBlUaZ7/brfE4hu/mMQa4U0cpzku8S2F6trTWJ7WIedTLEiHyI8zxO/vvHD/Ugcf/JUXPL2fZnYsqfhh4pPJ+vRuhf71jkLCMf89HqzWhEegkSCk8em+4Ka4dRDACsD7Lmrq8WwGI+phd9bV2tCMllnM9z2t8rfLBtZXYgZXZ3JTwt3UW5eOJmbnX40TgxRtPgnaRv3xawPsyE3qlNS5HH55E/DGkq7FSe0X4G0p621RuOAvk4Ndm3e7375nCsXWRE6OyGdnA3ugdpN7vvEZKxgzsYFIuoSipKCnD9Ej/ao2umjymVZHtUVxl/JfLTmjsJ+LQYGaDXvUV9SaZ2nw84VtCNMNQhOoixuyAPdRIxVbfc6kg6NG0c8/WBVXQbPgdpCb5585ffcXsUyqzOYTFPl1vp6wN7BhfWEBWzIhQoRbDOWkAg0QSsM4KXhsssG5LgbOWy6BX2DT2D7kQvIqDao3tYrV3AcUjC1e264+y47Mn5u5jp0QG+6ywyK9g16/vskt7QnsW9BGe1zyv9e1Lzu0bKjesUsX34mRjt+TFK7Ebyp6ZWHEcBM339B/LYti5H4ixjgItbRMyKcBBylLn6858dLP0Kc+tWDasidfmNY3uj38R7T7OkM2O1DXCpAf0vWqmYvH1xPrZE/W
 m50ScQsF
 brRwJQmks5vFTmDp1dGhdPsAw8Iu1l/UvlzPChnCDZMFYPQlbLQ4JCaz1eJQFFTQyH0fUqvtS4OXCH8tYtTlOeQuFCYYC+gYajQgLMtTGJ9fHzDMSWSjUP608CE1fc/53RSGeya5x86+Tnezdv3PSYJRqXKvh8ktUj+lbyVhIZR1oO6zJijIaMvvvv9y+I3uPIRdFqh4wRU808lxMFoe5ds6fFyuWabmBshdZ/VqXobRDwojgCMhaxvAWWT0A7jJ1SNsjEAxYqxC6uop9EjGm4AEHlsD77ADOX9WAEvUtPYs1+QSXVby0up+kaI8FJfVsb5icqlATjjFHL5lUXmzkKnAY2VrnSqf+wZw7IcJXwSwAfog7uIz0tOaYUM1bn+al5GfWnnuoKzdf3HgYwOzXR6M2a1FMjqNEA+I6kdtmIECxhonGF6KQDTc6MGe+MJFZMqrVnU4P0vh0gPXCDkZcia5nCoHeeu+SVqed2Epb+0LmAOG09HpDZwpKWLScXMi8aNZHfXVUFBXTCfZXE8enSdp37EtZx62rVzHFo5opYkjmTzIryVbtZseTd0CJgtrbC33aEFnKXSHa0WUwjDP+S+iZp2ILQ7e6g4fEmyfHYDSisoztfHc4cpY5/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When a PISA allocator holds many partially used 2MB pages with low
overall utilization, callers that recycle blocks in place (page_pool,
per-task TX page_frags, and per-CPU block caches) can keep old 2MB pages
pinned indefinitely with only a few blocks in use.

Record @alloc_jiffies in struct pisa_meta when a 2MB page is bound to an
allocator or taken from the allocator's idle list, and add two module
parameters:
- pisa.wasted_pct (1..99%, 0 disables): wasted block percentage
  threshold above which compaction kicks in.
- pisa.old_ms (1..100000 ms, 0 disables): age threshold after which a
  partially used 2MB page is eligible to stop recycling.

When both parameters are set and an allocator's wasted block fraction
exceeds wasted_pct, pisa_page_can_recycle() returns false for partial
2MB pages older than old_ms (except the head page actively being
filled).

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/iommu/pisa-alloc.c | 48 ++++++++++++++++++++++++++++++++------
 drivers/iommu/pisa-priv.h  |  2 ++
 2 files changed, 43 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/pisa-alloc.c b/drivers/iommu/pisa-alloc.c
index 1930135880d2b..5054a96f0f4e9 100644
--- a/drivers/iommu/pisa-alloc.c
+++ b/drivers/iommu/pisa-alloc.c
@@ -74,6 +74,14 @@ module_param_named(idle_ms, pisa_idle_ms, uint, 0644);
 static unsigned int pisa_compact __read_mostly;
 module_param_named(compact, pisa_compact, uint, 0644);
 
+/* Stop recycling partial pages older than @pisa_old_ms when wasted blocks > @pisa_wasted_pct%. */
+#define PISA_OLD_MS_MAX		100000U
+static unsigned int pisa_wasted_pct __read_mostly;
+module_param_named(wasted_pct, pisa_wasted_pct, uint, 0644);
+
+static unsigned int pisa_old_ms __read_mostly;
+module_param_named(old_ms, pisa_old_ms, uint, 0644);
+
 /* Max pages zeroed in each scrubber run (0 = disabled, capped at PISA_SCRUB_MAX_LIMIT). */
 unsigned int pisa_scrub_max __read_mostly;
 #define PISA_SCRUB_MAX_LIMIT	65536U
@@ -399,6 +407,7 @@ static struct pisa_meta *pisa_pick_dirty_meta(struct pisa_alloc *pa)
 		meta = list_last_entry(&pa->idle, struct pisa_meta, list);
 		if (meta->nr_dirty) {
 			pa->num_idle_pages--;
+			WRITE_ONCE(meta->alloc_jiffies, jiffies);
 			return meta;
 		}
 	}
@@ -603,7 +612,7 @@ static void pisa_return_block_locked(struct pisa_alloc *pa, struct page *block,
  * pisa_page_can_recycle - Check if a block can stay cached in a caller pool
  * @page: Block head page
  *
- * Called on the recycle fast path (per-CPU cache, TX page_frag, page_pool).
+ * Called on the recycle fast path (per-CPU cache, TX page_frag).
  * Fast-path cost is a static-key branch plus a READ_ONCE() of module parameters
  * (~1-2 ns when compaction is off); when enabled, it does a lockless RCU +
  * metadata array lookup (~5-10 ns).
@@ -613,10 +622,11 @@ static void pisa_return_block_locked(struct pisa_alloc *pa, struct page *block,
  */
 bool pisa_page_can_recycle(const struct page *page)
 {
-	unsigned long bpp, in_use, free_blocks, pfn;
+	unsigned int compact, wasted_pct, old_ms;
+	unsigned long bpp, in_use, free_blocks;
 	const struct pisa_meta *meta;
 	const struct pisa_alloc *pa;
-	unsigned int compact;
+	unsigned long pfn;
 	bool ret = true;
 	u8 on_list;
 	long held;
@@ -625,7 +635,9 @@ bool pisa_page_can_recycle(const struct page *page)
 		return true;
 
 	compact = READ_ONCE(pisa_compact);
-	if (!compact)
+	wasted_pct = READ_ONCE(pisa_wasted_pct);
+	old_ms = READ_ONCE(pisa_old_ms);
+	if (!compact && (!wasted_pct || !old_ms))
 		return true;
 
 	pfn = page_to_pfn(page);
@@ -638,6 +650,13 @@ bool pisa_page_can_recycle(const struct page *page)
 	if (on_list == PISA_LIST_FULL || on_list == PISA_LIST_NONE)
 		goto out;
 
+	if (!compact) {
+		unsigned long max_age = msecs_to_jiffies(min(old_ms, PISA_OLD_MS_MAX));
+
+		if (!time_after(jiffies, READ_ONCE(meta->alloc_jiffies) + max_age))
+			goto out;
+	}
+
 	pa = meta->pa;
 	if (!pa)
 		goto out;
@@ -657,12 +676,21 @@ bool pisa_page_can_recycle(const struct page *page)
 	free_blocks = held > 0 && (unsigned long)held * bpp > in_use ?
 		      (unsigned long)held * bpp - in_use : 0;
 
-	ret = free_blocks <= (unsigned long)compact * bpp;
+	if (compact && free_blocks > (unsigned long)compact * bpp) {
+		ret = false;
+		goto out;
+	}
+	if (wasted_pct && old_ms && held > 0 &&
+	    free_blocks * 100 > (unsigned long)held * bpp * wasted_pct) {
+		unsigned long max_age = msecs_to_jiffies(min(old_ms, PISA_OLD_MS_MAX));
+
+		ret = !time_after(jiffies, READ_ONCE(meta->alloc_jiffies) + max_age);
+	}
 out:
 	rcu_read_unlock();
 	return ret;
 }
-EXPORT_SYMBOL_GPL(pisa_page_can_recycle);
+EXPORT_SYMBOL(pisa_page_can_recycle);
 
 /* Return @n freed blocks to @pa under a single acquisition of @pa->lock. */
 static void pisa_free_bulk(struct pisa_alloc *pa, struct page **blocks, unsigned int n)
@@ -1195,6 +1223,7 @@ static struct pisa_meta *pisa_pick_meta(struct pisa_alloc *pa, bool zero)
 		meta = list_first_entry_or_null(&pa->idle, struct pisa_meta, list);
 		if (meta && meta->nr_clean) {
 			pa->num_idle_pages--;
+			WRITE_ONCE(meta->alloc_jiffies, jiffies);
 			WRITE_ONCE(pa->idle_jiffies, jiffies);
 			return meta;
 		}
@@ -1218,6 +1247,7 @@ static struct pisa_meta *pisa_pick_meta(struct pisa_alloc *pa, bool zero)
 	if (!list_empty(&pa->idle)) {
 		meta = list_last_entry(&pa->idle, struct pisa_meta, list);
 		pa->num_idle_pages--;
+		WRITE_ONCE(meta->alloc_jiffies, jiffies);
 		WRITE_ONCE(pa->idle_jiffies, jiffies);
 		return meta;
 	}
@@ -1287,6 +1317,7 @@ static unsigned long __pisa_alloc_bulk(struct pisa_alloc *pa, gfp_t gfp, unsigne
 		spin_lock_irqsave(&pa->lock, flags);
 		meta->pa = pa;
 		meta->prot = pa->prot;
+		WRITE_ONCE(meta->alloc_jiffies, jiffies);
 		/* Set PISA_ACTIVE after @meta is fully set up. */
 		WRITE_ONCE(meta->flags, meta->flags | PISA_ACTIVE);
 		pa->stats.page_alloc_cnt++;
@@ -1454,8 +1485,10 @@ static struct page *pisa_take_contig(struct pisa_meta *meta, unsigned int nblock
 	}
 
 	if (meta->on_list == PISA_LIST_IDLE_CLEAN ||
-	    meta->on_list == PISA_LIST_IDLE_DIRTY)
+	    meta->on_list == PISA_LIST_IDLE_DIRTY) {
 		pa->num_idle_pages--;
+		WRITE_ONCE(meta->alloc_jiffies, jiffies);
+	}
 
 	for (i = 0; i < nblocks; i++) {
 		if (__test_and_clear_bit(off + i, meta->clean_bitmap)) {
@@ -1544,6 +1577,7 @@ void *pisa_alloc_coherent(struct page **pagep, struct device *dev,
 		spin_lock_irqsave(&pa->lock, flags);
 		meta->pa = pa;
 		meta->prot = pa->prot;
+		WRITE_ONCE(meta->alloc_jiffies, jiffies);
 		WRITE_ONCE(meta->flags, meta->flags | PISA_ACTIVE);
 		pa->stats.page_alloc_cnt++;
 		page = pisa_take_contig(meta, nblocks, align_mask);
diff --git a/drivers/iommu/pisa-priv.h b/drivers/iommu/pisa-priv.h
index fe1bff0bba322..4d04bb191ecea 100644
--- a/drivers/iommu/pisa-priv.h
+++ b/drivers/iommu/pisa-priv.h
@@ -74,6 +74,7 @@ enum {
  * @list:	Node in @pa lists or per-node reservoir (pisa_node.pages)
  * @llnode:	Node in lockless pisa_free_list for async release to the buddy allocator
  * @rcu:	RCU head used to defer release to the buddy allocator
+ * @alloc_jiffies: Timestamp (jiffies) when the page entered or re-entered use
  * @clean_bitmap: Bitmap of zeroed available block indices
  * @dirty_bitmap: Bitmap of dirty available block indices
  */
@@ -94,6 +95,7 @@ struct pisa_meta {
 		struct llist_node llnode;
 		struct rcu_head rcu;
 	};
+	unsigned long alloc_jiffies;
 
 	DECLARE_BITMAP(clean_bitmap, PISA_MAX_BLOCKS) ____cacheline_aligned;
 	DECLARE_BITMAP(dirty_bitmap, PISA_MAX_BLOCKS) ____cacheline_aligned;
-- 
2.56.0.542.g3ef89b7020-goog


