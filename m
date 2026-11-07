Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA402606D805
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 22:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j/jSEPMA
Received: by kanga.kvack.org (Postfix)
	id 0F7696B05C4; Sat,  7 Nov 2026 17:25:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CFF96B05C5; Sat,  7 Nov 2026 17:25:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2B2E6B05C6; Sat,  7 Nov 2026 17:25:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C729D6B05C4
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 17:25:16 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 587C44045D
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:25:16 +0000 (UTC)
X-FDA: 85409755032.21.3940A21
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 87770140004
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:25:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="j/jSEPMA";
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794090314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OWyVCq4+WgbaMf16pDGURTSB8zAUbf5GDLFCZh0FtAI=;
	b=xFNffWyJQBi8MsnUt7OMaZjiEONWd4e9yCRePGeNUnMiRxfm1XYdchE6GNVhwxZ9l5Aty7
	HQ4l+cm6l3+83RfEfm8GU3AzGaNW+n/wFb59p+OoIXf3VKAj+Ohy6eSdpeYwJ3yr9vXsxy
	rVCesU9+fYc97TbEzi/aDGCHbG/nPyg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794090314;
	b=doW9llCcuF3k1Dw0GATFzajTKXEhB67tED+OB6V9XlSVchyMNTANhEArOeCb5Nt3iiRvN7
	R3mbChmD5lQAxYy9aZjRgtQpoi0RLVJua0b8WT2rYsUlg8Kq2rGWnJhLTaVk5vsfwoHmQe
	IBlCA9BMYsjCwV4MRpKrPbx0TAZFPH0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="j/jSEPMA";
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BE6924392C;
	Sat,  7 Nov 2026 22:25:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E38C1F008A5;
	Sat,  7 Nov 2026 22:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794090313;
	bh=OWyVCq4+WgbaMf16pDGURTSB8zAUbf5GDLFCZh0FtAI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=j/jSEPMA663ptEOJg2fMwfdPC20unbDRzEFPmCCOUX6RbI2fLyEt0loXnWk0G2nlh
	 58eif8uVbcsSnHYspoPlCCQ+VHc40nxVEuIp0hxepYy70IRhiBheFNaVRFt7c/dX3x
	 0jQ6d2kz3UrrYwgDdeqp8yaRG7TTL1SHO9qAXCgqoAtkRhQ0eK0LyOahuBV9CFZ94q
	 Jn0bpw7KzhGBo03Mg3LWjF0U/aqFY7uYIFN7fdC2H/OjwuZWkcn39egWKwTzGKTtwa
	 nyg83xPy8Qwek10es1ropcbxwt91AIVlbFO+lvcNgYVxYXZ1V6GwqEXqe4ps0ML/eR
	 ZwGiY3zNu3XBg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 07 Nov 2026 23:23:41 +0100
Subject: [PATCH v2 5/5] mm/gup: limit pagecache folio refcount when
 grabbing references
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261107-refcount_overflow_stable-v2-5-c38f6809b106@kernel.org>
References: <20261107-refcount_overflow_stable-v2-0-c38f6809b106@kernel.org>
In-Reply-To: <20261107-refcount_overflow_stable-v2-0-c38f6809b106@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Song Liu <songliubraving@fb.com>, 
 Rik van Riel <riel@surriel.com>, Miklos Szeredi <miklos@szeredi.hu>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Hugh Dickins <hughd@google.com>, 
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Kevin Tian <kevin.tian@intel.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
 Robin Murphy <robin.murphy@arm.com>, 
 Steve Sistare <steven.sistare@oracle.com>, 
 John Hubbard <jhubbard@nvidia.com>, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
 Josef Bacik <josef@toxicpanda.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 fuse-devel@lists.linux.dev, linux-arch@vger.kernel.org, 
 iommu@lists.linux.dev, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4862; i=david@kernel.org;
 h=from:subject:message-id; bh=uo5BeEwtVcyMk0MrrIUhmjG1HPh/LU5gGAlW8CtFyoo=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLeL2Uya5+/+O3KF0odGVferdL2LS6d//zBve+fJ984L
 Fws8mF6XEcpC4MYB4OsmCJLUPB9g5cv19VWu/Exw8xhZQIZwsDFKQATuXiVkWFD3DubS4FVUrZZ
 ulf+/rp5sPH8PgdtPr2T37WXRFQF1WkzMrx67fAvI/PRHMP2oLQVvJdcuEsWL5y4zybjhbznVev
 KAg4A
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: z67fhnkdtqgr366nhmdcn84r5uyxtf5p
X-Rspamd-Queue-Id: 87770140004
X-Rspam-User: 
X-HE-Tag: 1794090314-757421
X-HE-Meta: U2FsdGVkX19JFuQ0AQtvehrBG0OGIXya1IBS0n3TINFOBTljJV+a7uWOKwB4THdHD5Heu13i1f2Ms4KNDYf6sWIb9PbEB9NmPRt6C4KXVMCuYQvGNPLQc4S3h6AB+uSFsOZmTcFnm8ihn/A1SCmT4AnSSPuasuucyeszXZdmmPBWyNh3H8cpUKREjJB+YbB6uHA6hkqUSw2o9irzc8KaDdMVY7y6gi00JxKgkfrxECanE8GMhJzl7G8nFhu76z0qS6xUgQqYKX0NRAEx1bdNw9QzVKnJU5c3clsJYXHfjVM5BTJOS+Ovi9e6Eyy0EgXepCcWoZHOEIKzxGR7dyK/RhZYKHS6LPbVba2yo93vfKj4A6gxjy7XhYJuFYnB02zdcB7SnBisJuQSouToaUF3tNUJ7x+R/LHv604FLIx9pwcPR7DS2gMh8V7PwZPdAGzy2GO9bkq6ob0IkUj9ihaeUhMiXG5tyllXhmsBeavp3LnPzLzGo9OAEFRvGmMMVDkw9LSs2zkn7rZ8brTRQCBlsqi5cKFQccSIhNIU8RZTK9IYUykzUrG40Ek84LJLllbM8FtsLdzqzauqMSuU1Xsd59GRbv/1PAJPf29aAhIztrzdPY9IIHELOMcMPPWlXs2vVlDIdxaPo+O/ZrJdjMYW9BRsAbJMlw4GAGNPJiv/4rVS9xSb7i+WRgj3UTD/GabLzwh7d3salAWCGGQr/T1c4TOiO+7wQ882uoe3CMWVpF0SUC5eYO+64tthy325UAhhg3Sw9QeqzvrJfwR9YeQ7VFgU01MumAyx/M4fAaq9Cv1gAZNS8dVuIhegfL5NH3xrKaWHAxSd3Z6L77ckIsAnjSU9nFhj8Pi85khti3fowx0IYzye4Z2IkPhU/1f99EVmjVtI4FY7UUHhDOsgc3ydT4oKJjqYZfralCs4dlK7GB/+uJYXU6khZgufNZ0WhY1/Z6giNAsjbn2n6D+o0xe
 S22u9Q4W
 qjejCe/CWbrpW0YpM7uKoLm+FjT6QkRtGcNSKn9e+8S0BbOg5mxNNDhOBk/YDMQpN1oMIre7PhebiGtRIssaEPIc/RL2c2asNbcxdo6bA8NY1TslH4RhuduhX0NIuAY0tD8LHNsHKY4bNHzUxfoNg/TRJnwQcujl1Z7lL0+WzQJ6ZnFtpsq9fakCKIoK7tko2YN+1FB2CC1xxhzIn/Mo4DpdgLlIhtO+aYMFVwy/y7iPCFcRp/WAA4nHSLjSxhUpuqueSXtrytUbIECVNN4mLE93boUEYODObpBwY/K9fdcq0QtCWQi7m62lLrYir7hc1Psi/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Let's add a folio_ref_count_over_limit() check in fast and slow GUP
before acquiring additional references or pins.

Keep it simple and use the check for all folio types.

Don't check capabilities with IRQs disabled, as even unaudited capability
checks can take locks. Refuse access to the admin reserve, so GUP-fast will
fail and fall back to GUP-slow if possible.

Also propagate try_grab_folio() errors when grabbing additional
references in __get_user_pages() and in memfd_pin_folios(), so hitting
the limit returns -ENOMEM instead of -EFAULT and -EINVAL, respectively.

Keep the existing invalid-refcount warnings.

Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/mm.h | 11 +++++------
 mm/gup.c           | 24 +++++++++++++++---------
 mm/util.c          |  3 +++
 3 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 244bf5d441a64..f62820cc9159c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2246,6 +2246,9 @@ bool __folio_ref_count_over_limit(unsigned int ref_count);
  * Check before adding page table mappings or other significant refcount users
  * to large pagecache folios (!hugetlb), to avoid overflows.
  *
+ * Also required when pinning folios without a dedicated pincount that use
+ * GUP_PIN_COUNTING_BIAS.
+ *
  * Checking other folios does no harm.
  *
  * This check is an approximation; we leave some headroom such that concurrent
@@ -2938,12 +2941,8 @@ static inline bool folio_maybe_dma_pinned(struct folio *folio)
 		return atomic_read(&folio->_pincount) > 0;
 
 	/*
-	 * folio_ref_count() is signed. If that refcount overflows, then
-	 * folio_ref_count() returns a negative value, and callers will avoid
-	 * further incrementing the refcount.
-	 *
-	 * Here, for that overflow case, use the sign bit to count a little
-	 * bit higher via unsigned math, and thus still get an accurate result.
+	 * Use unsigned math so even an unexpected negative refcount is
+	 * treated as possibly pinned.
 	 */
 	return ((unsigned int)folio_ref_count(folio)) >=
 		GUP_PIN_COUNTING_BIAS;
diff --git a/mm/gup.c b/mm/gup.c
index 2ab42fc6834e5..522049f2b8663 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -79,6 +79,8 @@ static inline struct folio *try_get_folio(struct page *page, int refs)
 	folio = page_folio(page);
 	if (WARN_ON_ONCE(folio_ref_count(folio) < 0))
 		return NULL;
+	if (unlikely(folio_ref_count_over_limit(folio)))
+		return NULL;
 	if (unlikely(!folio_ref_try_add(folio, refs)))
 		return NULL;
 
@@ -143,6 +145,10 @@ int __must_check try_grab_folio(struct folio *folio, int refs,
 	if (WARN_ON_ONCE(folio_ref_count(folio) <= 0))
 		return -ENOMEM;
 
+	if ((flags & (FOLL_GET | FOLL_PIN)) &&
+	    unlikely(folio_ref_count_over_limit(folio)))
+		return -ENOMEM;
+
 	if (unlikely(!(flags & FOLL_PCI_P2PDMA) && folio_is_pci_p2pdma(folio)))
 		return -EREMOTEIO;
 
@@ -1482,17 +1488,17 @@ static long __get_user_pages(struct mm_struct *mm,
 				struct folio *folio = page_folio(page);
 
 				/*
-				 * Since we already hold refcount on the
-				 * large folio, this should never fail.
+				 * Grabbing more references can fail once we
+				 * hit folio refcount limits.
 				 */
-				if (try_grab_folio(folio, page_increm - 1,
-						   gup_flags)) {
+				ret = try_grab_folio(folio, page_increm - 1,
+						     gup_flags);
+				if (ret) {
 					/*
-					 * Release the 1st page ref if the
-					 * folio is problematic, fail hard.
+					 * Release the folio reference we
+					 * already took.
 					 */
 					gup_put_folio(folio, 1, gup_flags);
-					ret = -EFAULT;
 					goto out;
 				}
 			}
@@ -3538,10 +3544,10 @@ long memfd_pin_folios(struct file *memfd, loff_t start, loff_t end,
 					break;
 				}
 
-				if (try_grab_folio(folio, 1, FOLL_PIN)) {
+				ret = try_grab_folio(folio, 1, FOLL_PIN);
+				if (ret) {
 					folio_unlock(folio);
 					folio_batch_release(&fbatch);
-					ret = -EINVAL;
 					goto err;
 				}
 
diff --git a/mm/util.c b/mm/util.c
index a906dfa755ff1..f2c6b222e3ef7 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -798,6 +798,9 @@ bool __folio_ref_count_over_limit(unsigned int ref_count)
 	/* Background threads must not consume admin reserves. */
 	if (current->flags & PF_KTHREAD)
 		return true;
+	/* Capability checks are not safe with IRQs disabled. */
+	if (irqs_disabled())
+		return true;
 	/* Use the task's credentials, which filesystem overrides cannot change. */
 	return !has_capability_noaudit(current, CAP_SYS_RESOURCE);
 }

-- 
2.56.0


