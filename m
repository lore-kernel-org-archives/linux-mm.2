Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4BDFC624DA
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 18:30:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1A516B0096; Thu,  3 Sep 2026 14:29:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7D1E6B0098; Thu,  3 Sep 2026 14:29:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D61F6B0099; Thu,  3 Sep 2026 14:29:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 689246B0096
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:29:57 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D54901205FC
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 18:29:56 +0000 (UTC)
X-FDA: 85173289992.29.43F5A2A
Received: from flow-a3-smtp.messagingengine.com (flow-a3-smtp.messagingengine.com [103.168.172.138])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0342E40007
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 18:29:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="n uyJvhm";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=ICPXCBfE;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788460195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G9VB0sdKC1XKz21nLpi2URn5ZyQ5pGM/85eGOTZORQs=;
	b=I0A8ks10YR8FaQDB+KicC1tY1REzxRcXlCjj4VbTr5oxhysMACtb1EpAY31TEtkcLQnppO
	Q1WQ9tR0oIS2uRA7zljW2+H7HmQQqWrNc16FRrMSpS4KiTDfqIyImp76XP2DwUA/FQLZQ6
	MR3NmxYnQB3SO5EpUrui943JsJEh11I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="n uyJvhm";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=ICPXCBfE;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788460195;
	b=zDffvT/9dpmMKAsZK5ulf/ojgoylbd01OUJQe1/UrT1CwSZ0xytjnSU6bJ+zjnRNf909D9
	AZ47L5I3UZzTrwZ9WGRNz/CQ+DN/kGy54qzmuNwidxF7jwb1wJ6fB0HgVhGXuIKQIl9tWZ
	o04mWo9Wa7Sg5yYxpnL1pqMbc2r4+Ng=
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailflow.phl.internal (Postfix) with ESMTP id 7103013801B4;
	Thu,  3 Sep 2026 14:29:54 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Thu, 03 Sep 2026 14:29:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788460194; x=
	1788467394; bh=G9VB0sdKC1XKz21nLpi2URn5ZyQ5pGM/85eGOTZORQs=; b=n
	uyJvhmfYQRHlIHNWbptwLQ+0wR/mTXr50Ep4IVzvnBN9VJAGlJfwTEEGbOSmD0sj
	8U2wKGhLv9SdB8zvnkG1GrKXEoegcSc+yGRCvoU6QlwwoNX0JAYKZqUevNj2kVtI
	G+6hWtTgtgr0ZXHhfFigDUYk2bccnYjGouRAjiRntPappxQmXaLRAqHktmdqEwGk
	82QA4MLyofmVulSGwYjzl9+i8FoCN+6TsusGfW+AfcJKRjfH3bFdWDD1sxUm/PMR
	f3t9i8yR/aq1IBkipjapx+gFYvWVRlH0Ou4YkXutcTEN/usEJiWvt5vM41gG4oNd
	beF9ced3G57SHnblDGYoA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1788460194; x=1788467394; bh=G
	9VB0sdKC1XKz21nLpi2URn5ZyQ5pGM/85eGOTZORQs=; b=ICPXCBfErnIq545ty
	MYKmeRgwuDeQC/flzKJo3829hY3s8E5hZ4FX7tuxaW0UFig94Rj2yI1NQBVXq5vh
	7z1NLgeM3bikWeZqc6wVqhLIJPpvVRZ343ESwgBIlvXN6rWuJKvWieKEBnQR2R8J
	DdJhtRA81wb+lpJ+rK3zPgjpSoIqZ7eNNTEk9kif/pH82rKSCgblKNbfgQ0C9prX
	LBayyAyHKW1RNd5MOYwr/Yo30POrvtSI+pQNz9HkKGf5kCQABlHCFhe7kLHoPikP
	JJhMEAKRJjUn2Ug+cbIr7RAcBb6xgrQ2D8X8lWiB5BTzgGiBvM0TFzBHYsHBOCjK
	FQYHg==
X-ME-Sender: <xms:oryZatARA4foFu2wbRyk2avQuS5Sr-L2PRKfqFq5xhLcOmK7MIkRnA>
    <xme:oryZaskswPEIJK4OhJESs-L9fMAonkUcueo5D89YibfrT3-hRGzzkB8dFP_4NMKkR
    RHUcS3ZVlZhQMjOIszC95DRbq091bACFRzzWQYyzufp_7tLBiFUT6vY>
X-ME-Received: <xmr:oryZarh842RR1VPqOfuCMrHgqcJ2VuEyH1PUyabb-RHmwXOap5YKzz_1Vf8>
X-ME-Proxy-Cause: dmFkZTFt7tpQ23d6ma5ZKwjaUeV/XmiCXSwfUJTD/UMTaTx+tQ6P98fG4/H3PFA7hJFxaU
    SY7i6N6X86D7HaHpdbLHvMivEhulOmq3NoSfdg1pBrJA6v+lfq2ALheALUZjz6o7Nf8BIz
    DWIHLTWCbkC3w9bMwM7vsWb978omVdOmMplVzO2fLHjMRy1E/CxFkmf+2uWv7frAXfMOWG
    H/vdAXIPTaxMrzbmklMnL5PmRnZSJQIp5M1ihNDwszNqcLBuKJXCEkMPvIWqkfKnePof3W
    BlQ363pN/8dtwFHD474IAw0kAsBZ9JYvF7V9lEJnX7ro/M4XAHwxRodQrXyCYUn1NLN+Uj
    NdPYldr8Mq2IRZx0YyuQhIoiitm1QZtl4Syt/IqGnJWW5uRScoV3lGNcaWi5MYWySny51c
    TwILw9eVYuCxGIrYrqLo3zB0wXMnvyhES/hTXL4WkawgjP16PklJlBhJZkkqHSu5ZSeipJ
    vNQsPjbp1knfB3s+6DOtSIcyjNQSo+fvk74i8TsMuVFro5h5T4RQZDS/9sWdiKOQTAS3KJ
    Q+KPaFI3YoSacqM82ZxFZTjYhHPwfNu0Ug3d4Hx5T5s+kXfQFEYWmgo290U3VCybc+7Eq5
    +rvAeQmDrD+p82sLjT/fTXuwlbtObV0rjSi9zthMlSSAgvNSR/aZPKslN9wg
X-ME-Proxy: <xmx:oryZalewYzORhqKbB5Zj7WbERpeBIRt0Q3-YYYvHIBh9mD0vfpU8UQ>
    <xmx:oryZarD6ZJIAT5DzD2JxzFviaA5RLK0tpScfxtUS8sDJpcpIOIYLbg>
    <xmx:oryZap51vTL3PUAyrokmXqDyzMW3G3hHAzP8MALPWzBlvgdU8YoFhw>
    <xmx:oryZaoxgw26mMunJmi0SmpSRs3-71ZLeVUddZDvAvYBdgbwHZ-nZYg>
    <xmx:oryZapW6Pnnpi5qOYIUW4M92_I6galdmzyJT-n5zEjsg3YjBTzI1ZuiK>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 3 Sep 2026 14:29:53 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Jann Horn <jannh@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Usama Arif <usama.arif@linux.dev>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [RFC PATCH 2/5] mm: add a_ops->dirty_folio_range() and use the mkclean dirty harvest
Date: Thu,  3 Sep 2026 19:29:40 +0100
Message-ID: <20260903182943.662461-3-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260903182943.662461-1-kirill@shutemov.name>
References: <20260903182943.662461-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0342E40007
X-Stat-Signature: st6fae8tra343i7tto6g31wbxb6npem9
X-Rspam-User: 
X-HE-Tag: 1788460194-16361
X-HE-Meta: U2FsdGVkX1/htZlmyUzWU3naNrtiAVgXBjCYMFJIfZQVi0mQBEpSH9Jks5DMINL3GRhWQsl3OzjSd6Mg+GlKPdYV58dDk+FB/xF20gLlKHoKECYip98WujLgnIDPEyzV0eIQxzEWO0dAsb75Sb6pD1b0jC9odK68Xj1sfV2qowP2VmWbSPr/PKKwvM6RmewfO4g0f8jNr5HbhYzNsGchsR5P3rYBlgG8HGcSJ9wPuAEBn9mpyF9p9Jt2nxf1XTfD05+RS9qISzHhfxqIWbZbWzdZc1POjIkb9r7lwoQBBfQf5L7qcKQ0YBFYuwMJ2ICGZ6AgaF+3nW2Bq7jyV99MVuUgY1d4FINNdC6CLS3TvI0jzXySUs/1WQMmE6KC++9y5V/GqzMUoyrVXsA1AFn3629dYQE4AfoU4istwAOYkqHtL3hAv3xqiukYkwkWKAEN9AFPwLHh6Aep5LqY8uNlee2IQ6nlkho+A3kq+bY+1yyU161otaaDte4jY91Bz69zZu8dKkkWaBnX2VycKGxz1/zvnUMCOUS7pvDKSFb8oJMJ5dkq1w5mLqcC6cNq1pQ+bAdtqEl54IibL/WNcoQline+kpqyb0zIeFw0i4bHU7IC49kZU+RSXPCNu6m3dGEHVR1YmtHzxINy+Kj+JPmsCg09LiMcsGgEu74il6J9VuFjLN2QOUyD+zCOrRddcy1pqOV+WLFPmK+k9sR+9bOdQRr1CmSfWpthtCZdK8zu2ABgS1cKdkbqPPXBhbZg82gl/PSSqFtDsu4GfxJB6aydfPeCAMIZsrJJ2jgNIuZ7igd0rp7+FA2z4ukDahk4tRTL4EHl8eP2TxNGBlwrFhDjlL5oxXuiOudrnCXioSgp2JtrWVmFDA9e8jqprzSNTP9C1LbYBMNuSA/i69Q0ciy0vuo8CG5GZGNSS1hpzxnOSQnWIFoBciMe5C7ysVpcXasquesF5bcmNOoxpNaf/ct
 dLanI4jP
 ve1MDwtSk7zBNz+4LdWGwMcHFLsmZDnZKmMIwcoham1tLMhsy+hTg2Nja3VSWsFgwU1bf14/m6EbnhRfXS47GYx7Ye2NAOzDe1KhvXqGa8bTAXVz/SYOfrWOQWr2EHpwcDhCdfMVTL/Nf0Ek8MQuz+M6BaQQlsV5F4LU1/OwzvNO5B5xFR1aIKES6TO7nIZ9FNQLRF3POOzFQJcxubHG0VIvsez0u5KLeL321ePa/0/onC3LXSTkMK8yjgolgbGPrbJX7aDFlIPAikxoZ2e52T+kjKQVOX29kSoPx1GIhcqRzZ2ALfL8y01XJLoduhfXMtWd+EsfuvkNgvO/9kgdzEiFRjwIq6HW7R/vEEkRcUOU2VOPVsPteinqdNkbqXQoNnvRHugaZBK96LUX7DVmRrb+Bez8kHZbqWYZz7KI+KQowPMbRasUvEWS4P1V/RAaWk14Ggzu2ASMsvYE+KBLNuHiSWz/TFbpR20FC3jOx/yzhds0qpierTYvYsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Every way of dirtying part of a folio through a mapping ends up at
folio_mark_dirty(), which has no way to say which part changed, so
a_ops->dirty_folio() dirties all of it. A filesystem that tracks dirty
state per block then writes back the whole folio for a single stored
byte.

Add a_ops->dirty_folio_range() and folio_mark_dirty_range() to pass the
range on. The new operation can express everything a_ops->dirty_folio()
can, so folio_mark_dirty() goes through it with a range covering the
folio and a filesystem needs only one of the two. Filesystems without it
dirty the whole folio.

Use it in folio_clear_dirty_for_io(), where the page table dirty bits
were being turned into a whole-folio dirty. It now collects them with
folio_mkclean_dirtymap() and hands the filesystem the runs that were
dirty. A folio that is not already dirty still dirties whole, because
the clean to dirty transition needs the accounting in folio_mark_dirty().

Assisted-by: Claude:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 include/linux/fs.h  |  3 ++
 include/linux/mm.h  |  1 +
 mm/page-writeback.c | 87 +++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 85 insertions(+), 6 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 072d8cd09a0b..1d98b6c0b880 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -406,6 +406,9 @@ struct address_space_operations {
 
 	/* Mark a folio dirty.  Return true if this dirtied it */
 	bool (*dirty_folio)(struct address_space *, struct folio *);
+	/* Mark [off, off + len) of a folio dirty */
+	bool (*dirty_folio_range)(struct address_space *mapping,
+				  struct folio *folio, size_t off, size_t len);
 
 	void (*readahead)(struct readahead_control *);
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 87feaa5a2b78..7628262c17e1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3337,6 +3337,7 @@ struct kvec;
 struct page *get_dump_page(unsigned long addr, int *locked);
 
 bool folio_mark_dirty(struct folio *folio);
+bool folio_mark_dirty_range(struct folio *folio, size_t off, size_t len);
 bool folio_mark_dirty_lock(struct folio *folio);
 bool set_page_dirty(struct page *page);
 int set_page_dirty_lock(struct page *page);
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 6c9c7ba89b8a..39b54c25a9fa 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2751,6 +2751,21 @@ bool folio_redirty_for_writepage(struct writeback_control *wbc,
 }
 EXPORT_SYMBOL(folio_redirty_for_writepage);
 
+/*
+ * Hand a dirtied range of @folio to the filesystem.  ->dirty_folio_range() can
+ * express everything ->dirty_folio() can, so a filesystem that implements it
+ * does not need both, and a whole-folio dirty comes through here as a range
+ * covering the folio.
+ */
+static bool mapping_dirty_range(struct address_space *mapping,
+				struct folio *folio, size_t off, size_t len)
+{
+	if (!mapping->a_ops->dirty_folio_range)
+		return mapping->a_ops->dirty_folio(mapping, folio);
+
+	return mapping->a_ops->dirty_folio_range(mapping, folio, off, len);
+}
+
 /**
  * folio_mark_dirty - Mark a folio as being modified.
  * @folio: The folio.
@@ -2782,13 +2797,39 @@ bool folio_mark_dirty(struct folio *folio)
 		 */
 		if (folio_test_reclaim(folio))
 			folio_clear_reclaim(folio);
-		return mapping->a_ops->dirty_folio(mapping, folio);
+		return mapping_dirty_range(mapping, folio, 0,
+					   folio_size(folio));
 	}
 
 	return noop_dirty_folio(mapping, folio);
 }
 EXPORT_SYMBOL(folio_mark_dirty);
 
+/**
+ * folio_mark_dirty_range - Mark part of a folio as being modified.
+ * @folio: The folio.
+ * @off: Offset of the modified range within the folio.
+ * @len: Length of the modified range.
+ *
+ * Like folio_mark_dirty(), but tells a filesystem that tracks dirty state per
+ * block that only [@off, @off + @len) changed, so writeback can skip the rest
+ * of the folio.  Filesystems without that tracking dirty the whole folio.
+ *
+ * Return: True if the folio was newly dirtied, false if it was already dirty.
+ */
+bool folio_mark_dirty_range(struct folio *folio, size_t off, size_t len)
+{
+	struct address_space *mapping = folio_mapping(folio);
+
+	if (likely(mapping)) {
+		if (folio_test_reclaim(folio))
+			folio_clear_reclaim(folio);
+		return mapping_dirty_range(mapping, folio, off, len);
+	}
+
+	return noop_dirty_folio(mapping, folio);
+}
+
 /*
  * folio_mark_dirty() is racy if the caller has no reference against
  * folio->mapping->host, and if the folio is unlocked.  This is because another
@@ -2844,6 +2885,41 @@ void __folio_cancel_dirty(struct folio *folio)
 }
 EXPORT_SYMBOL(__folio_cancel_dirty);
 
+/*
+ * Write-protect every mapping of @folio and hand the filesystem the parts that
+ * were dirty in a page table.
+ *
+ * Without ->dirty_folio_range() there is nowhere to put per-block state, so
+ * any PTE dirty bit dirties the whole folio.  Same when the folio is not
+ * already dirty, because then the dirty transition needs the full accounting
+ * in folio_mark_dirty(), and for a folio too large for the bitmap, which the
+ * page cache does not make.
+ */
+static void folio_mkclean_for_io(struct folio *folio,
+				 struct address_space *mapping)
+{
+	DECLARE_BITMAP(map, 1UL << MAX_PAGECACHE_ORDER);
+	unsigned int nr = folio_nr_pages(folio);
+	unsigned int start, end;
+
+	if (!mapping->a_ops->dirty_folio_range || !folio_test_dirty(folio) ||
+	    WARN_ON_ONCE(nr > (1UL << MAX_PAGECACHE_ORDER))) {
+		if (folio_mkclean(folio))
+			folio_mark_dirty(folio);
+		return;
+	}
+
+	bitmap_zero(map, nr);
+	if (!folio_mkclean_dirtymap(folio, map))
+		return;
+
+	for_each_set_bitrange(start, end, map, nr) {
+		mapping_dirty_range(mapping, folio,
+				    (size_t)start << PAGE_SHIFT,
+				    (size_t)(end - start) << PAGE_SHIFT);
+	}
+}
+
 /*
  * Clear a folio's dirty flag, while caring for dirty memory accounting.
  * Returns true if the folio was previously dirty.
@@ -2875,9 +2951,9 @@ bool folio_clear_dirty_for_io(struct folio *folio)
 		 *
 		 * We use this sequence to make sure that
 		 *  (a) we account for dirty stats properly
-		 *  (b) we tell the low-level filesystem to
-		 *      mark the whole folio dirty if it was
-		 *      dirty in a pagetable. Only to then
+		 *  (b) we tell the low-level filesystem which
+		 *      parts of the folio were dirty in a
+		 *      pagetable. Only to then
 		 *  (c) clean the folio again and return 1 to
 		 *      cause the writeback.
 		 *
@@ -2895,8 +2971,7 @@ bool folio_clear_dirty_for_io(struct folio *folio)
 		 * as a serialization point for all the different
 		 * threads doing their things.
 		 */
-		if (folio_mkclean(folio))
-			folio_mark_dirty(folio);
+		folio_mkclean_for_io(folio, mapping);
 		/*
 		 * We carefully synchronise fault handlers against
 		 * installing a dirty pte and marking the folio dirty
-- 
2.54.0


