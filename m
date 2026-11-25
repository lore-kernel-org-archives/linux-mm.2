Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6660C606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 08:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=E/UTdTUe
Received: by kanga.kvack.org (Postfix)
	id EEE8E6B0932; Wed, 25 Nov 2026 03:34:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9E806B0936; Wed, 25 Nov 2026 03:34:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8E696B0938; Wed, 25 Nov 2026 03:34:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9A7156B0932
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 03:34:24 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 05DBAA0E6C
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:34:24 +0000 (UTC)
X-FDA: 85472979648.04.4D60E35
Received: from mail-pj2-f3.google.com (mail-pj2-f3.google.com [74.125.227.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3206C40009
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:34:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="E/UTdTUe";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.131 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795595662;
	b=glxsCpMPHCzI3FCuW/C7XZaWass2ZRVRsY5RSXcepdFGoVeedpOh6arsVwU83t2mZGhC9Q
	OCjCLFPgpd1RFUmFiPKOgWdt98qKu84N7bLzCOJ1SgZMZBXW6Xf6DRza1AH2P0PvCFL3MZ
	86HMhyYFGjpKurEaI+m3Ja+mqv8OP1s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795595662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=UGXh90dqgeqyP/Nvzef1rwxOFBPyEnrVXo7ndmxkPP0=;
	b=1OCtNzk8QEDWavIAm10YJaZ9bS/uESVqsPoJZ6lnfR3cF6S/eOBVdzMbSTafVZzdKii5jG
	RE2jibm7hCSFQo7sRUTyPoWYaF1sJfgMmuVOsOoSxnzq/VZgoluofiqsFuMsjZammFBDmN
	WfIWKG+1Yt0jtfT6Fu+HtKxO4+v8HVY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="E/UTdTUe";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.131 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
Received: by mail-pj2-f3.google.com with SMTP id 98e67ed59e1d1-3b497279bf2so222617a91.1
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 00:34:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795595661; x=1796200461; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=UGXh90dqgeqyP/Nvzef1rwxOFBPyEnrVXo7ndmxkPP0=;
        b=E/UTdTUeFpdJuGANpgJSIrg/2OZnoxQ6mQixexUQwLEYa6Prp2P9dSwRFsGvrnuyqQ
         V4LlhAq3VpgzbrbDFNQ52OQsx17GuEIh8FU0m+KrY3AuuMQOApkOUzsb/OeZYIFmO+VT
         ho5i5PF0tHeEBFxVBu1JZS+1ieD/fEbZc7JJY+7yi4UH1N0fvdgyvvWU/6lMZHrgCx4M
         pMDGKw/Sxt+BVcKvYtv6j0whO4Zc3obkCbZ5sKugsXXAi7n3khq/yiPB3uVfwEm3+OJW
         BbDiK7eGyaucFXDnS8jIvYrZ0MVZoUxpymB3lCKdZYanVnmJ88Yn1KY8KwhwkNSBX707
         6V+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795595661; x=1796200461;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=UGXh90dqgeqyP/Nvzef1rwxOFBPyEnrVXo7ndmxkPP0=;
        b=bucYfVXv5/fwmxdUCEUqZ28q15al+EcI91u9g+snQKhW8by+K3NI5KjuMn41uxAksm
         k34fTV69qlUCdG6kpqsNnmQFGlh1gBUTE8DhlwJXIPq5mIEynCWidTu/pvwaLmoFt+fY
         /MlZXTylhKEIekfJ3hO08kMelEmAR1Pxvr1A/GKEcWA1vAE7oT4t+x0SjAH2f2LAv5kV
         lhfrqL3LdbyMDvM0e2dqfAm0cLfC18RIepru02F+kpcZk0PeS/t2b1acrUdaueW3ReEk
         iOTS81E9LZktvycoQvrchFeEG6gZa84/tSW3yP2RZiHy1cZjIGyQyhhCt6luiA4lBz92
         lvMw==
X-Forwarded-Encrypted: i=1; AL+hErF0cTuG9h/iCFdGkVfr5/5Obf4mwSzEWSHGQBylM0ZWe5aZ63enfM5IJdcX5mxgT/btERw/mu4lgA==@kvack.org
X-Gm-Message-State: APuU4Z/iJ0Qwzmve1pEJ2dgGBVvXuHicPCeJqv+aKkQg7O6n13GA5i2r
	kykCYjsdHqzKBw6zcjymDvqi9cTy98VJcGGJsiN40vT+v7rgKHkrqbPo
X-Gm-Gg: AZFdTZeH9oq76m9Hqc228ecLTVVTAhwxrJzCSoYjLfRpYz04FnzqzyuCEwQT8YmEgYq
	fj2pbBCGlXaEEsyY9c0tpZfI5NxiGwSlb5z9L7WxePCEiWwoK1YMufGjjGpLX9u1PNpKndYQmaD
	CyHmo580ebHFxt98uMzWqrpI1kvre4xChUmfhz4xJgKi3ZzsoyFWbrMibtdxxyCtc0hK5yczHJP
	y/4JF0wfPdJY92vwZnflPIatRVLWw7CPtGOwO5t6OaSivKwzKI/4NttZrWKyO6OVjcCEZG5W3Ha
	6T//W98ZPXLJK6Awm2S6LnNlBpwy7DXfsFrCHeZAd+++aFdprM704FKMfVWu8zRR2bdVpCB6v0Y
	IEF7oCRgjpMippMS6emIc0ZacTlbQOLDZc3oduyRrn1n6oLYf33HpqjaZUvI1nd6sPhfKzSnEFV
	XsYGexHmxOjeU9UMSafgzB3gKXJQDwpX/QXGw6D0SdEhTii7GFFFxi2DTXSVOKBamc/rx4Wj/L8
	Hbn3J29fhgehhEOHVHNfmcGSh5AI07tmGVpgAk6vJ549QBHpyznfq5aAo9oma3Hd5s9JxQdHZoh
	CqeNw63RW72BfU146VubzolTUudsUyPJmLoOykjYNxzHHgK/CfjcebCKsuNmyhHnKymG5DXV3+T
	JrTW5xUQSrVu9kG2HfXVmsnysOVwz1gz8rn3z18WxcGha2wei7znCTsvSNOh+sQ==
X-Received: by 2002:a17:90a:c10e:b0:3b4:1356:5c66 with SMTP id 98e67ed59e1d1-3b41c8df703mr11653441a91.13.1795595660626;
        Wed, 25 Nov 2026 00:34:20 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b4b0f482bdsm10995933a91.14.2026.11.25.00.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 00:34:20 -0800 (PST)
From: Aveline Noir <jm5905938@gmail.com>
Date: Wed, 25 Nov 2026 19:28:49 +1100
Subject: [PATCH] mm/hugetlb: serialize subpool release with folio reserve
 restoration
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-hugetlb-subpool-release-v1-1-7398c24d09b0@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/12MywrDIBBFfyXMukNVSF+/UroYdRotokFNKYT8e
 zXddXku95wVCmfPBW7DCpnfvvgUG8jDAMZRnBi9bQxKqJOUakS3TFyDxrLoOaWAmQNTYdR04Su
 fhRithWbPmZ/+s5fvjx835cWm9lx/6F3LFI3rE6Xjf3uWWCpFSyFFRqOwK7BtX1TDUHe2AAAA
X-Change-ID: 20261125-hugetlb-subpool-release-ba8e9e7005dd
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: 3206C40009
X-Stat-Signature: 9rm19p1r3qu1jend96ozzw33zwti38bm
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795595662-925736
X-HE-Meta: U2FsdGVkX18rnG1C0rbMs/AaY36BA8CdVqhpj67rax35o39q5yLfxBmzqtpuIhgGGQAEAt6ED3mAXkH7ngOtKJe+q/jDkGN38MVVCQRUO6hGx/q5DtqsxyCAEROES00wYRooCCGHunon9tDivpcq4W+wlak7fgfuk+o/fdvEBUji5R7SJTxOCgA+5eWPYB+ll2BM8HN9gffUFCC8A+OQ1JJfz5US02+54arvyGpQkPu9sakAhmoT+1PQF2yIpqINHg0QhYzgG0624fGT4FH6drBoWskEhBXo1j+XwtWadzvJeDS+Vwd/1SLhCwLytvvZq9GeF26ABRMWng7RCdm0TUoF0NBTMBtgSd/tVT57Db1nw4aHKLJ3dtFY76JjCGiEKTjUFjzUL7E7z+EVnoXJxS0tMjvhukY/AFZ1uT3vM/ZzKPMJ2re3knQuZV/oGBNxD8XCVnv4L38wOLWJS9EZHCXPFHNaB2LL+NMWwbQqvXOmw1C6BUxa5zljmbedBrhBAW1Qax9tE/hO3q+ode8zghJxqiw+snsRt1owJWhSwyIpVBJj4SddV+YKLHsJj0xecU4+8YYBp33XtN1Eh53B7nJwPqN16h6x1vy3xHSYx9I2LQ1u6p9b+OLBKzUH/md+AM/KAbMdHMIWUYTqCT7UuDMQk0AKdAVACBWs6B7TUkInZ0AX3OiWX3hf1WAU7f3QCK0lvFKRK9+RFmbiw97IoB/p0EbKqXruDFA6fzc5uRiOltymcgXG2O6Ykw5wxq8XaL74oa11OqBxK5gzWWrE2CdsjO5rCafx3IzDtheD4zmPAe44ExDRisaIABezwaDXfh6hPznksqigeK0chOjB4L57T5P+zXC9w1ucmzJCmBdiK2pCC8BxIjTlvajBkX1KO28NHeQqQ/yO70UtESLYqz4e1JxQNQ1/yWgEJDJJunEiyK0Le4oFLidgQeTF5HxCSQQQ4HQZ0gsqgqayFl9
 0I7jqWMZ
 +cTmny11ZOdVWB6IcLDwyBGqtj/nUnstRzMLfbA+PIEK+sofpd0NCm9pgkxT1m7BFZcpgSI9jDbKjZVCQBkFAInPivIQhZ9efLshkhf3ne4RgflRr+vj4el447ENjW2HqxGmOHW0JrAe7j9GsUSPIGgK5oRwyTfg/RyeXutQhuZqp5CsSFnKLH6/P10SOYdiVIWpL9+YkFjncRDsmu7ngohZ/GCMbZ4zvnWH5N6lgpFt/CmhHIRoh9ne+C/zEyXw2uk06aHsB1wbNA7f4PhbBd9Rl2ESn+0Kz1bWNIQht3+0PolQ1EqqiCpYWoIwntjyqvaL19NbHx0nSb42ZFXOrBDRnM4sjxrW6cMW6ATMn+T4UfySwvB/He8t/4GYDNf2HGUde/Op0GZcWdjaGihior6B7BwONK/Dqgz6RsKi0g2ZDxV4SZOTY5GptDn35+wCVNbR/iP7zd08bA8NNBcUkQ794+WSGiFXb/T1X2bRpRF2d+gLCFWUvSpWK1n8WLpbOcA84KhXhxkBNb1wJiWRLUFqH0But32pqOdWn9dN310oGPHMQKTSy41Bm/uRRMGT41fbk7YML6JBdYdxnGTkjW7cSe9ToZTNi9XUtiFYBHDCmiHcI4M8TFEmYxyDX0eq2JbtA6qI3iOAdHQ56j8lRkJnktvaLoLbVhYfaGhTwnNF52HNoGC8vioDzlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Freeing the last folio of an unmounted min_size subpool can invoke
hugetlb_acct_memory() from atomic folio_put() context, where its IRQ
and bulk-freeing paths may enable interrupts, reschedule, or allocate
vmemmap pages.

In addition, the subpool minimum is released before the folio's
reservation is restored, transiently underflowing resv_huge_pages. A
concurrent allocation can consume the refilled subpool reservation, or
unmount can release it, before the global counter is restored. Under the
available_huge_pages() clamp, this underflow also prevents collecting
unused surplus folios.

For positive minima, take hugetlb_lock before dropping spool->lock and
restore the folio reservation, release the minimum, and collect surplus
folios in a single transaction. Keep subpool accounting outside
hugetlb_lock, leave size-only and zero-minimum puts unnested, free
collected folios outside the locks via the atomic-safe path (which
defers HVO work), and skip zero-sized minimum releases that need no
global accounting.

The ordering came from 1c5ecae3a93f; the commit below made it reachable
by enabling min_size and releasing its reservation on subpool teardown.

Fixes: 7ca02d0ae586 ("hugetlbfs: accept subpool min_size mount option and setup accordingly")
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
---
Tests passed in x86_64 KVM with KASAN
---
 mm/hugetlb.c | 123 +++++++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 90 insertions(+), 33 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d0e66fb30622..05c34ca44a15 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -128,6 +128,9 @@ struct mutex *hugetlb_fault_mutex_table __ro_after_init;
 
 /* Forward declaration */
 static int hugetlb_acct_memory(struct hstate *h, long delta);
+static void collect_unused_surplus_pages(struct hstate *h,
+					 unsigned long unused_resv_pages,
+					 struct list_head *page_list);
 static unsigned int allowed_mems_nr(struct hstate *h);
 static void hugetlb_vma_lock_free(struct vm_area_struct *vma);
 static void hugetlb_vma_lock_alloc(struct vm_area_struct *vma);
@@ -166,7 +169,7 @@ static inline void unlock_or_release_subpool(struct hugepage_subpool *spool,
 	spin_unlock_irqrestore(&spool->lock, irq_flags);
 
 	if (free_subpool) {
-		if (spool->min_hpages != -1)
+		if (spool->min_hpages > 0)
 			hugetlb_acct_memory(spool->hstate,
 						-spool->min_hpages);
 		kfree(spool);
@@ -263,21 +266,17 @@ static long hugepage_subpool_get_pages(struct hugepage_subpool *spool,
  * The return value may only be different than the passed value (delta)
  * in the case where a subpool minimum size must be maintained.
  */
-static long hugepage_subpool_put_pages(struct hugepage_subpool *spool,
-				       long delta)
+static long __hugepage_subpool_put_pages(struct hugepage_subpool *spool,
+					 long delta)
 {
 	long ret = delta;
-	unsigned long flags;
-
-	if (!spool)
-		return delta;
 
-	spin_lock_irqsave(&spool->lock, flags);
+	lockdep_assert_held(&spool->lock);
 
 	if (spool->max_hpages != -1)		/* maximum size accounting */
 		spool->used_hpages -= delta;
 
-	 /* minimum size accounting */
+	/* minimum size accounting */
 	if (spool->min_hpages != -1 && spool->used_hpages < spool->min_hpages) {
 		if (spool->rsv_hpages + delta <= spool->min_hpages)
 			ret = 0;
@@ -289,6 +288,20 @@ static long hugepage_subpool_put_pages(struct hugepage_subpool *spool,
 			spool->rsv_hpages = spool->min_hpages;
 	}
 
+	return ret;
+}
+
+static long hugepage_subpool_put_pages(struct hugepage_subpool *spool,
+				       long delta)
+{
+	long ret;
+	unsigned long flags;
+
+	if (!spool)
+		return delta;
+
+	spin_lock_irqsave(&spool->lock, flags);
+	ret = __hugepage_subpool_put_pages(spool, delta);
 	/*
 	 * If hugetlbfs_put_super couldn't free spool due to an outstanding
 	 * quota reference, free it now.
@@ -298,6 +311,28 @@ static long hugepage_subpool_put_pages(struct hugepage_subpool *spool,
 	return ret;
 }
 
+/*
+ * Return with hugetlb_lock held.  Take it before dropping spool->lock so
+ * a refilled subpool reservation cannot be consumed
+ * before free_huge_folio() restores the global reservation.  Keep subpool
+ * accounting and waiting for spool->lock outside the global critical section.
+ * The caller owns final subpool release if *free_subpool is set.
+ */
+static bool hugepage_subpool_put_folio(struct hugepage_subpool *spool,
+				       unsigned long *flags, bool *free_subpool)
+{
+	bool restore_reserve;
+
+	lockdep_assert_not_held(&hugetlb_lock);
+	spin_lock_irqsave(&spool->lock, *flags);
+	restore_reserve = !__hugepage_subpool_put_pages(spool, 1);
+	*free_subpool = subpool_is_free(spool);
+	spin_lock(&hugetlb_lock);
+	spin_unlock(&spool->lock);
+
+	return restore_reserve;
+}
+
 static inline struct hugepage_subpool *subpool_vma(struct vm_area_struct *vma)
 {
 	return subpool_inode(file_inode(vma->vm_file));
@@ -1761,6 +1796,9 @@ void free_huge_folio(struct folio *folio)
 	int nid = folio_nid(folio);
 	struct hugepage_subpool *spool = hugetlb_folio_subpool(folio);
 	bool restore_reserve;
+	bool free_subpool = false;
+	struct folio *free_folio, *tmp;
+	LIST_HEAD(page_list);
 	unsigned long flags;
 
 	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
@@ -1781,18 +1819,22 @@ void free_huge_folio(struct folio *folio)
 	 * reservation, do not call hugepage_subpool_put_pages() as this will
 	 * remove the reserved page from the subpool.
 	 */
-	if (!restore_reserve) {
+	if (!restore_reserve && spool && spool->min_hpages > 0) {
 		/*
 		 * A return code of zero implies that the subpool will be
 		 * under its minimum size if the reservation is not restored
 		 * after page is free.  Therefore, force restore_reserve
 		 * operation.
 		 */
-		if (hugepage_subpool_put_pages(spool, 1) == 0)
-			restore_reserve = true;
+		restore_reserve = hugepage_subpool_put_folio(spool, &flags,
+							     &free_subpool);
+	} else {
+		if (!restore_reserve)
+			hugepage_subpool_put_pages(spool, 1);
+		spin_lock_irqsave(&hugetlb_lock, flags);
 	}
 
-	spin_lock_irqsave(&hugetlb_lock, flags);
+	lockdep_assert_held(&hugetlb_lock);
 	folio_clear_hugetlb_migratable(folio);
 	hugetlb_cgroup_uncharge_folio(hstate_index(h),
 				     pages_per_huge_page(h), folio);
@@ -1806,21 +1848,29 @@ void free_huge_folio(struct folio *folio)
 	if (folio_test_hugetlb_temporary(folio)) {
 		remove_hugetlb_folio(h, folio, false);
 		folio_clear_hugetlb_temporary(folio);
-		spin_unlock_irqrestore(&hugetlb_lock, flags);
-		update_and_free_hugetlb_folio(h, folio, true);
+		list_add(&folio->lru, &page_list);
 	} else if (h->surplus_huge_pages_node[nid] &&
 		   h->free_huge_pages >= h->resv_huge_pages) {
 		/* Free this surplus folio that is not required globally. */
 		remove_hugetlb_folio(h, folio, true);
-		spin_unlock_irqrestore(&hugetlb_lock, flags);
-		update_and_free_hugetlb_folio(h, folio, true);
+		list_add(&folio->lru, &page_list);
 	} else {
 		mod_node_page_state(folio_pgdat(folio), NR_HUGETLB,
 				    -(long)pages_per_huge_page(h));
 		arch_clear_hugetlb_flags(folio);
 		enqueue_hugetlb_folio(h, folio);
-		spin_unlock_irqrestore(&hugetlb_lock, flags);
 	}
+
+	if (free_subpool)
+		collect_unused_surplus_pages(h, spool->min_hpages, &page_list);
+	spin_unlock_irqrestore(&hugetlb_lock, flags);
+
+	list_for_each_entry_safe(free_folio, tmp, &page_list, lru) {
+		list_del(&free_folio->lru);
+		update_and_free_hugetlb_folio(h, free_folio, true);
+	}
+	if (free_subpool)
+		kfree(spool);
 }
 
 /*
@@ -2502,26 +2552,18 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 	return ret;
 }
 
-/*
- * This routine has two main purposes:
- * 1) Decrement the reservation count (resv_huge_pages) by the value passed
- *    in unused_resv_pages.  This corresponds to the prior adjustments made
- *    to the associated reservation map.
- * 2) Free any unused surplus pages that may have been allocated to satisfy
- *    the reservation.  As many as unused_resv_pages may be freed.
- */
-static void return_unused_surplus_pages(struct hstate *h,
-					unsigned long unused_resv_pages)
+static void collect_unused_surplus_pages(struct hstate *h,
+					 unsigned long unused_resv_pages,
+					 struct list_head *page_list)
 {
 	unsigned long nr_pages;
-	LIST_HEAD(page_list);
 
 	lockdep_assert_held(&hugetlb_lock);
 	/* Uncommit the reservation */
 	h->resv_huge_pages -= unused_resv_pages;
 
 	if (hstate_is_gigantic_no_runtime(h))
-		goto out;
+		return;
 
 	/*
 	 * Part (or even all) of the reservation could have been backed
@@ -2543,12 +2585,27 @@ static void return_unused_surplus_pages(struct hstate *h,
 
 		folio = remove_pool_hugetlb_folio(h, &node_states[N_MEMORY], 1);
 		if (!folio)
-			goto out;
+			break;
 
-		list_add(&folio->lru, &page_list);
+		list_add(&folio->lru, page_list);
 	}
+}
+
+/*
+ * This routine has two main purposes:
+ * 1) Decrement the reservation count (resv_huge_pages) by the value passed
+ *    in unused_resv_pages.  This corresponds to the prior adjustments made
+ *    to the associated reservation map.
+ * 2) Free any unused surplus pages that may have been allocated to satisfy
+ *    the reservation.  As many as unused_resv_pages may be freed.
+ */
+static void return_unused_surplus_pages(struct hstate *h,
+					unsigned long unused_resv_pages)
+{
+	LIST_HEAD(page_list);
+
+	collect_unused_surplus_pages(h, unused_resv_pages, &page_list);
 
-out:
 	spin_unlock_irq(&hugetlb_lock);
 	update_and_free_pages_bulk(h, &page_list);
 	spin_lock_irq(&hugetlb_lock);

---
base-commit: c8117bff684306f5c1f959d055cc2b24dd67b1eb
change-id: 20261125-hugetlb-subpool-release-ba8e9e7005dd

-- 
Thanks,
Aveline Noir


