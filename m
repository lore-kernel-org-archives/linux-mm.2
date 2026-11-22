Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4829606A69A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 18:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=XJfaNmp3
Received: by kanga.kvack.org (Postfix)
	id AABC56B05B7; Sun, 22 Nov 2026 13:45:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A81866B05B8; Sun, 22 Nov 2026 13:45:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9223F6B05B9; Sun, 22 Nov 2026 13:45:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 53A066B05B7
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:45:05 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7D2A5C0757
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:45:04 +0000 (UTC)
X-FDA: 85463632128.26.63DE3BB
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf10.hostedemail.com (Postfix) with ESMTP id BE370C0009
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:45:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=XJfaNmp3;
	spf=pass (imf10.hostedemail.com: domain of 3LTgDawoKCAot3ry4qr3yxqyyqvo.mywvsx47-wwu5kmu.y1q@flex--jthoughton.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3LTgDawoKCAot3ry4qr3yxqyyqvo.mywvsx47-wwu5kmu.y1q@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795373102;
	b=SIy1SyPk/IZ5BfZi+Op3PLP9pFemPh0SgLwIfgEVuP6EAav3LhCN5i5EK7hjsdyl9wLDx7
	4HKDDfjv9W82jFl2nQnzDuuEHnYqtkWJ9uZieR8gdm0TENzbgbvxHv5gApn6G7HDnis95T
	6iC6kDYmshUQEHhTTEP2SBmHHZjNrdo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795373102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=reL9mYJK/1m1y+g0uNeijZFVaLlYnX3xPlUy2DZTb6U=;
	b=pHTmDETBRWqdVaMjGXi0MLB6+e4tTK5qBvGRtAGTcbDQIEuqgEsuH98gr1YrDrmNGy6FB/
	zTUWcb1z2ZQiZh2OBy3wDY3Q92AKRAi6B+fSURzccERmFi5ClcHrfQd42x09WuEr25HqYR
	d2vAqYTJ9SKaDiCU2CiB9qaICk1zAqw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=XJfaNmp3;
	spf=pass (imf10.hostedemail.com: domain of 3LTgDawoKCAot3ry4qr3yxqyyqvo.mywvsx47-wwu5kmu.y1q@flex--jthoughton.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3LTgDawoKCAot3ry4qr3yxqyyqvo.mywvsx47-wwu5kmu.y1q@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3ae19907a31so2468246a91.0
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:45:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795373101; x=1795977901; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=reL9mYJK/1m1y+g0uNeijZFVaLlYnX3xPlUy2DZTb6U=;
        b=XJfaNmp3ty0mDu33lg+NLDTnoOvIjMuUeVehS9f/Rujs+INHEwjQWRqaGes+pAbfxC
         aAS67HdNwKpyHK8HvhCqchqoZEuqnrMWgKGNLikUeHe2XPuJ9FDfDfB/gP2y3tRzoLbE
         kMnxhjs1/Y53TYSJQrYuQFag6eroHs8M2BD9JVp77RN3HFbH3RfcrBO4eBnNvaezU5Vn
         7u3scB63MusBlKRMmVtEklFmfpyU14BqEkLpRiv8Vp2M2wOnXPng9IUUnkrB9bDO1Eum
         EKXX4Resn6jxa6+9Obu6t8WBuEwYnmghw51rLaSIlocx4OXynCmD7GhkyRPyadi7lkZA
         loJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795373101; x=1795977901;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=reL9mYJK/1m1y+g0uNeijZFVaLlYnX3xPlUy2DZTb6U=;
        b=QDSbsVOrAhuriMHh5/xlzZ9E54CNXlmS3WGTPyn3Jtz10hw4mnDfw3nVL3o+WyeLly
         8vm9Tkcw6OYeZDuGDDylgg1loBfI/yq9Ft4NWiu4V5T5KPOEf+9cmuO/i5OWAw2lC3aw
         ZvEi5PwywLIk5FEBeEc3WTNJZA4IUh5F95iLsrhwH9tz9l6EjN1IoNmQRJuy1OQD9ShE
         v0KvTDeWkLBSnI3ZQF4g2tmDW8MGzzMvGhycEBO9vU2aUbCDsC08QZEm/ifGf6gsXzhs
         /jF1K6E5kHDiZ4XJeqdQwk9/ByD+UnfM58/U7IpDVI46v8y4tD+5q6vHDz1O+c6A/UXx
         chog==
X-Forwarded-Encrypted: i=1; AL+hErEhh+do3sw6HsCITrtg0lSgS1H/8GT+QXdrXiB0NIbWTqbphAL2udws1RGmnvQb08tXpPtD9HNgOw==@kvack.org
X-Gm-Message-State: APuU4Z8U9muV/X4IBQ0OzFZYSXQTe2lJIzfDuCDGLw+0Nls7MiE+ALCl
	wkd5BzJgZ6SfifofZVD4BYcraYm+T+ANuPvFlWQ28Jx/KVlTIGHQnsHW//zbaDsndupyf1jeYdu
	Hfa3Yg5rHe9NvdbAtHJRB3g==
X-Received: from pjbqa11.prod.google.com ([2002:a17:90b:4fcb:b0:3b3:d1d1:2aef])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4483:b0:3a4:b509:88bd with SMTP id 98e67ed59e1d1-3b41c7bc7ccmr5465023a91.2.1795373101199;
 Sun, 22 Nov 2026 10:45:01 -0800 (PST)
Date: Sun, 22 Nov 2026 18:44:37 +0000
In-Reply-To: <20261122184453.2668189-1-jthoughton@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261122184453.2668189-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261122184453.2668189-4-jthoughton@google.com>
Subject: [PATCH v3 03/19] hugetlb_vmemmap: Leave pages partially HVOed upon
 restore failure
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: BE370C0009
X-Stat-Signature: 887xno5awbm3q15a6h3ym489w4uxuij5
X-Rspam-User:
X-HE-Tag: 1795373102-802896
X-HE-Meta: U2FsdGVkX18D411NhbUaThuHHNMx0r/d8xs0LyN/qYnCfY1MKW3WHjBDLYgo9/Fqv2THRXyIQZmfPIUJCnHGUU1lLHiZGLmen37zF2zwrydw5zL/81ysuxqWD+Oy99er5jHhZOMWCPfxvABox5ltSFrkWdI3adbZbnhp0vmuDIUmu+IQBPXtSQaYy+EnLLysP6rKj2k+YvwrUIgld03g7HC79k/t4JiweTh9xClpE2pNm3vqRa1ZmQc5Y+Qghl3EyVxAVB7A8WM8ZiM1C9IlXfvU5sYA2EhiB10jqHlcxjOKVQ6WppqlcvWi40awmtzjHuit4po1YoczkgEswexl0jdddsNSyJU9D5afQ1IWz0gh45IiKbyWsp08kEFNznZ9mGYRNXq9sqbTg/J2Fzgyfcn9Qb8IlIkp85v5oxZcWzHWJ5O8Z/wnePbkupb7faHdTSQbtM4+Uz8alEhnLMtTVhEK17eO6PydVN2zvOnDSqxmYuVEMiJudMLkj4+Uv70YHT/+4RXaXoZQrgENVl23fA62LD1NCx6rJTtvlyykA0qkYaa5u+seliVgkuA6nyMQeEtXUtZj40hWclEWsmHnVbVvrmfsM88oIXmfoz8qlJbCDjBxW58zF53h5+7GitUZrp996dSUzM7N9HfbI8ae89qe0c+fnEA7mjEzjbS/VdssEIOpH/cIIfPunyGqinL17OsKw0/UvOkzMbE5UuZkVtBzDcfFKc7Fxwl1bG6b8HlkO0d1J43lOP4lHLVu6faEhb5eO/X6XnSHlnx/ccQPKGTIfQMhPFKF+Js+zNU7GWwXxqLczI6nU9Tnj63eiNdxL9Z8npoQPinzeDcB1A1o8/zN+NQi00mlF60YvWn7r324QfTRZun2ePo5Ym/vJ2k3PsAQMzHm2MB2RVjU0UePEDbcQXpgEXb8Pf9cOynER8cPoyWnUU8sESCf9ZvPie+Za1zVAQCs2wdyGar1JB1
 0cZry2po
 xgFYNFSdZn2tFuDTwvOtp5DbkjVer5xSXnrnyd4FX3NAtxdRMdHSram46F79IcfjaMBX/wPLFzvwB/TLO6wRFJcsIqJdMrYzz1b8spZJiRUnsOKr9oGE0HJPGGY1wEHqacSxKIXWbJNCBN8jwWehe1nvCdnQ/9b0+mbp6toWP1iRCiTUORuzC1tgp3M21oJtZpyu0eZTB+Iln91U6JcCa81RtIyDELaeSoUG1SdFGAY45/bXSfQraOrPi76+tr28IHrJIb7SjBVxK4TKiEHQyhRcw6tBxnk9wLFzo3dqSsmSe9UYQ1SEGDdcbA3xBfOmB9PhDQBc31AvMr5TMKnR0gkMk1H5EJ3VmmttTjU0ah3HFYx3Z79x33gQWQMtIlOGT00mE6+Rna8d0tCey2vLtrBn/VNU98rQZRhKeK5tvmVCy55EeqtytjEiwbBV/SGmk7yx4uXte6gPP8ARRlV3nuVMzcCAnDVYciZMZHZa7Kk8mIIorGWsAxTqzMwUSM4XsywLUvvZW66zcbeLmlUOySmkyDmnQB50gMo6EVEMzZzwU0ODuEODk0arVqkPuehMBrKpqvEfPbhm9NOcjPmOKktO4x4bdxe47S6XVGxtMqgz8i9K3ldwk86AzbnMtQE5iB48eJokdh7dT/bH0FmNu0vnAY3bCnSq2dRBOTiV3J2t7tE4oKP/DVdEXLuFtEURw5EYtTl/8D18WPWbAz7LLDhFFgMrimZ4tcETOOuWK59JeiAyb0pKqVHTaIIMojP0wvA2EeiqRbdVH9SX0p6SeKPceeUIldJ8ng5mxstKuuJ9yHhWPF2aJUJyFR36mspsHFDCOigTg5nO3nDpW2ItBpQInvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Right now it is assumed that the restore routine in vmemmap_remap_free()
will not fail; that is, if we fail to fully optimize a folio, it is
assumed that restoring the folio to its pre-HVO state is guaranteed to
succeed.

Although vmemmap restoration may never fail in practice, properly handle
such failure cases now. This will leave folios in a partially HVOed
state. In a follow-up patch, failure certainly becomes possible.

In the event we end up with partially-HVOed folios, make sure to:
  1. Leave the HVO page flag in place.
  2. Free any unused vmemmap pages.

Always pass the vmemmap_tail page to the restore routine to avoid
leaking the non-optimized vmemmap pages for a partially HVOed page.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 mm/hugetlb_vmemmap.c | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 7be08c68c2f1..2e9cf8d39c89 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -274,12 +274,22 @@ static int vmemmap_restore_pte(pte_t *pte, unsigned long addr,
 {
 	const struct page *page = (const struct page *)addr;
 	const struct folio *folio = page_folio(page);
-	struct page *src = pte_page(ptep_get(pte)), *dst;
+	struct page *src = pte_page(ptep_get(pte)), *dst, *tail;
 
 	if (unlikely(!vmemmap_optimizable_pfn(page_to_pfn(page), folio_order(folio))))
 		return 0;
 
-	VM_WARN_ON_ONCE(folio_vmemmap_shared_tail_page(folio) != src);
+	tail = folio_vmemmap_shared_tail_page(folio);
+	if (WARN_ON_ONCE(!tail))
+		return -EINVAL;
+
+	/*
+	 * The folio may be only partially optimized, so restore only PTEs
+	 * currently pointing at the shared tail page.
+	 */
+	if (src != tail)
+		return 0;
+
 	dst = vmemmap_dup_page_from_list(src, walk->vmemmap_pages);
 	set_pte_at(&init_mm, addr, pte, mk_pte(dst, PAGE_KERNEL));
 
@@ -325,6 +335,7 @@ static int vmemmap_pteify_folio(const struct folio *folio, unsigned long flags)
 	return vmemmap_remap_range(start, end, &walk);
 }
 
+#define VMEMMAP_REMAP_INCOMPLETE 1
 /**
  * vmemmap_optimize_folio - optimize the vmemmap backing of a folio
  * @folio:	folio whose vmemmap pages should be optimized.
@@ -340,7 +351,8 @@ static int vmemmap_pteify_folio(const struct folio *folio, unsigned long flags)
  * Note: The caller must hold vmemmap_remap_rwsem. If TLB flushing is deferred,
  * the lock must remain held until the final TLB flush.
  *
- * Return: %0 on success, negative error code otherwise.
+ * Return: %0 on success, VMEMMAP_REMAP_INCOMPLETE if the folio is incompletely
+ *         optimized, negative error code otherwise.
  */
 static int vmemmap_optimize_folio(const struct folio *folio,
 		struct list_head *vmemmap_pages, unsigned long flags)
@@ -372,7 +384,8 @@ static int vmemmap_optimize_folio(const struct folio *folio,
 		return ret;
 
 	end = start + walk.nr_walked * PAGE_SIZE;
-	vmemmap_restore_range(start, end, vmemmap_pages, 0);
+	if (vmemmap_restore_range(start, end, vmemmap_pages, 0))
+		return VMEMMAP_REMAP_INCOMPLETE;
 
 	return ret;
 }
@@ -402,7 +415,12 @@ static int vmemmap_restore_folio(const struct folio *folio, unsigned long flags)
 		return ret;
 
 	guard(rwsem_read)(&vmemmap_remap_rwsem);
-	return vmemmap_restore_range(start, end, &vmemmap_pages, flags);
+	ret = vmemmap_restore_range(start, end, &vmemmap_pages, flags);
+
+	/* Not all pages may have been consumed */
+	free_vmemmap_page_list(&vmemmap_pages);
+
+	return ret;
 }
 
 static bool vmemmap_optimize_enabled = IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON);
@@ -526,7 +544,11 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	 */
 	folio_set_hugetlb_vmemmap_optimized(folio);
 	ret = vmemmap_optimize_folio(folio, vmemmap_pages, flags);
-	if (ret)
+	/*
+	 * If ret == VMEMMAP_REMAP_INCOMPLETE, the folio might be partially
+	 * HVOed. Leave the HVO page folio flag in place.
+	 */
+	if (ret < 0)
 		folio_clear_hugetlb_vmemmap_optimized(folio);
 
 	return ret;
-- 
2.56.1.809.ga0b61035b5-goog


