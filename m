Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80996C44529
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:36:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BABF6B00D2; Mon, 20 Jul 2026 15:36:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56A5E6B00D3; Mon, 20 Jul 2026 15:36:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C26B6B00D5; Mon, 20 Jul 2026 15:36:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0CEE96B00D2
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:36:06 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 876E31202C9
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:36:05 +0000 (UTC)
X-FDA: 85010160690.20.BCE3703
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id C93ED180003
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:36:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=b7VKair1;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784576163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cmMfaNN8FH7IwFGvNgQFqVAtbOqtT0oL84O+5IPA/hE=;
	b=ZQ/D5H7ngDWx57g1BWk0N+ayqNZPDcB6Y6sZzub1GWD97sErgwXdfP68AUae3qH1RMgouT
	hmXWaE091ZogvShvGpdXpYDkmDwCZ2F+CLzVFwbbTy0jlovlplA9u1P71CcM/TE4DUMP59
	1WbSPkvnC6x/qoXREJ6zCpu+6VPBSHs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784576163;
	b=b5fhinfVVSkh9fqo/Hca9Xnj4s6VBA/5cipiwsYJSQ3hVbpOl9ZthIEmSjFTHBstMGoCvD
	5t6poVhHFPVGfaH2sxpRT5sH6h+OdgvQdbUCHTqP4r6hFnYp2uyQ6wUqjetXd0QiMed62Q
	K/8e6MSmvoND4lX2ZqM4CfwmoKlZCOM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=b7VKair1;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92e6c4a867cso465818585a.0
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576163; x=1785180963; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cmMfaNN8FH7IwFGvNgQFqVAtbOqtT0oL84O+5IPA/hE=;
        b=b7VKair1P5HtYQ4WG1ESuvLsxjy3ryQtNDCTRnf9/LEoinfPVypHISPolaJCZUAUkh
         wgXG2wWSN9UKpvs+M2yqyhmbm0sAJ5U4xIpBr65CvrsyC+9AmLyMpnjRawFWz+U8vFNS
         /MgSzqbn+LHx6OjvjdDZKUvNwynJkBEH0CeWYYhTRXCPJ/zKsHUY0mCVRFwjIVzmHXFT
         dfeMegnsJRoHNY6Jq0G5VQE+QxMJW3X0GuIzM3Q7MLb4YYvNkZ0nfrnxJ/QTILmsv2W+
         1jE2Bypxa+5h0aD4vqUBWFu2BdvpjoCXjwoAfkipQHvtFJUGLINy+6vpf4YiOvYorDj3
         CB9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576163; x=1785180963;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cmMfaNN8FH7IwFGvNgQFqVAtbOqtT0oL84O+5IPA/hE=;
        b=j8Xgu7cvdDjahfHxmUOrwvjIf5ALlSJ+r1nhavaqQWJoincj9lORKce+wc+gJrmu8p
         JnI3misDphKhFEbVjHe6gIfBRBTOZ0LNT5vVDOnO4kMJXK0d8g0s1UfLRrBtO9uX3aNB
         r5F1aPsL81nz6A+zminisupU0+B6xIRJw7MttnAV30/oFS7mGF8h3F0Y9So3ugBQear3
         V5bY7cgrgPDRWK7EV9V00gYtVf8nRPByaq7zEtpf81ss63IEgfWBOEV7D6p0OkBY/b1I
         3pSfoPKwwGZAorvaEfiPOQjew2s9YCdw2NyOeO8fgCwk7/+bOO6j3HWbUROriuJ87oWp
         CdQg==
X-Gm-Message-State: AOJu0YwONtc6mU3neYRFF5EEl7kHivRjSLefeDMNyvZbiC4NDn0S3Qzm
	Mj4wbusPRojXdyT6GM9Dm/WX6yJPl/fAOyMgn/r2fNEpZh9eaykHamP1rfY+jsq5jVN8W5MqGKs
	NP+Ka
X-Gm-Gg: AfdE7ckG9rKhJ0BgjdOnLfbwjwrip1l7qwOFd+dIhA5+p6UpcKlzaVK4TEdPqA1Pzo4
	GnqJy5VCzh/u+/kT7NcaJyJ1IH1kSXla+3r9oLfObEJx4SQWShp83dODzAhg+9gkcLue959cj6c
	RFf7QEpS7x8h0Bc8MXlrEm349uQqAneL5Vli20YyHJGP4n54N5iNEQ0k5FgUEvv5FC2Zjgpozbz
	aE/Fucg1W0/9yD+Q/IDWqWs3qj0RtbStnQqtheV+OSO8a98PYiNnlUwBWmZk5JX6h6MxAGpC+Te
	ZoETsoBZDhsWvrJsfmhJb4kbgZE/zcTfA+bO7BQvVrSg3wByy6Pnkc5LQxJQnwWJE8dFtFwt3ne
	+TRqUILWCwdQ+x5O9fiOXt1/QJ0dPLQVV3JU1qbE/yXAqKtgCf6iRi6Y1U4BpSFEofmAGm6Q5M4
	4pz7IPKQysDKXi1/EVqGX3L1sXslHi7l7LydS+dNd1rxaGDxl02oeAbFHrSpLZxxA=
X-Received: by 2002:a05:620a:4620:b0:92f:279:5953 with SMTP id af79cd13be357-930b3ea8f3emr1530889385a.27.1784576162881;
        Mon, 20 Jul 2026 12:36:02 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:36:02 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 32/36] mm/khugepaged: base private node collapse eligiblity on actor/cap bits
Date: Mon, 20 Jul 2026 15:34:26 -0400
Message-ID: <20260720193431.3841992-33-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9ze567o45331r644k4a9mxipp77icada
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C93ED180003
X-HE-Tag: 1784576163-515275
X-HE-Meta: U2FsdGVkX18WNUBJdIEIHHh/gqSpNk0i/A7tkJCtHfQq259P5dG51Gu3P+uEMDUq+8GZAC7AmP7sUwwHYXUDncXhZ0984nzIg9b/0fYklFFHejAZTcdgvuU5x9rHQG8W6342vOgOjmEsyepmVnhbfjTP2jCJnPArxYj3HdY8mkhmgzXO7pVZjLLsf1NlH8a3wTHMLlNkov0TCgFkHveiqwxraC+YCU8UqNIvrkwWarb0JVgpJagB9idzleN+2hw0u0bn3TCa6CoqRruT6rMbWTTCR4aw6/WSFZKcvpRzkSPYyBfJDVbhfev8OmG489IIHy6cOGaGFPIwiL5op2JhuCgkpRmJ5dhMGtS2ev5u2DZheIIBkz3nOAECncFaUMucxYP1mRZAdrKScKRpzTZZ1Flqd22qZBNFJlOIpKb8pS0IRCDpZUxlXtpjb635VAIp4VXdhwdiKB1DuqN69kqEz09PPrGzYKP9w3Q9FIGjUUok1XGCk/JmJkiKO3ZN3WlNikfYk2Q0f0ci9WPkVKK41KNRXUzDDV5spwhwLd2aOKzQxDkMbfqcuCDSEx+/ZiP9rGKggjKS5Czh+fTUWuDdUPOadtMf37+9vYVhMRDBMfjKD4YJimgjgIeqOsGHUA2P3gU9DFYg4liVjams0DmQei6/iQvJGAFrzV7Uo8qQaP45gbfAWY6GtqtiubAKvRS0VRECgWUG+q3zIw0gCdLq85eqB5a7FmHURv8omZMhDKgFdC63t6gXK8gf2jlM6v0sjp7UWpZ6m9Q8xJieB6zMPcue0j7eDEksN960bNoS9fXUaNto4qs8EyLDCpc1eV8zYUottobM6mz8MTdzMFYlsrQihBmNxMlwtT0Vwn28uQHfzA12DUA+bkQRXgEMKMGurSFf1t2osWXfKJxrYHI8mnGYbUtSliAzVKL+5hHfWem4MiO25gpL+anRuDTKj7FKeDK6d7PHA/4UFHX8w5f
 WDzIrlV2
 g6m0dTzjaAOMMTp7dd/VabSzY9kFP0JIa82qmkEhK6HOlYMHOfzzYz2kVNG3tIUrRAiGVSOY84B/fNuGo3V+vkrC/ubBUVpJSufRxsb8lIDxucasarSnthr3AvwNDU4NTXgwonWXQHzmZGxCICQvWnfrzPzGdvqE2ny1+sK2f1PK4lKLPMh6ySIKew5MHORP4Jb1vyMequaoKwjFbv7ENZPvLLk+3zed3gEVulzu28cNS3ChlpArOfKSqM8TkuoFSmbcUQAbfJDprYnonMzRP0UTBfSdR9PHLTpB4kzkeIWhurG23Z4B8+JjUKdWBM9rIVRnW9HmkYoMl/YOQJ5F0r7yb/URDihtBxe4EPP1MyvB8QCpU1GoRNjKdIGE0pLBesFj5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Collapse can move base pages across nodes.  The khugepaged daemon does
this transparently, while MADV_COLLAPSE is a userland construct.

Isolate private nodes from khugepaged exactly like ZONE_DEVICE.
Never collapse private node folios silently (the owner may not
support migration).

MADV_COLLAPSE is user-initiated, so it is allowed on a private node
opted into CAP_USER_NUMA, consistent with other userspace interfaces.

folio_allows_collapse() encodes this: false for khugepaged on a private
node, CAP_USER_NUMA for MADV_COLLAPSE.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/internal.h   | 26 ++++++++++++++++++++++++++
 mm/khugepaged.c | 16 +++++++++++++---
 2 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 9621eb127c28c..9dbc5752cd3fe 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -136,6 +136,32 @@ static inline bool folio_allows_numa_balance(struct folio *folio)
 	       node_allows_numa_balancing(folio_nid(folio));
 }
 
+/*
+ * folio_allows_collapse() - may collapse fold this folio into a THP?
+ * @is_khugepaged: true for the khugepaged, false for MADV_COLLAPSE.
+ *
+ * Collapse is a residency operation gated by the actor calling it:
+ *   - khugepaged never operates on private-node folios (like ZONE_DEVICE)
+ *   - MADV_COLLAPSE is gated by CAP_USER_NUMA
+ *
+ * Never true for ZONE_DEVICE.
+ */
+static inline bool folio_allows_collapse(struct folio *folio, bool is_khugepaged)
+{
+	int nid = folio_nid(folio);
+
+	if (folio_is_zone_device(folio))
+		return false;
+	if (is_khugepaged)
+		return !node_is_private(nid);
+	return node_allows_user_numa(nid);
+}
+
+static inline bool page_allows_collapse(struct page *page, bool is_khugepaged)
+{
+	return folio_allows_collapse(page_folio(page), is_khugepaged);
+}
+
 /*
  * folio_allows_longterm_pin() - may this folio be long-term GUP-pinned?
  *
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index fb4378cc17b10..5f20839857738 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -700,7 +700,8 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 			goto out;
 		}
 		page = vm_normal_page(vma, addr, pteval);
-		if (unlikely(!page) || unlikely(page_is_private_managed(page))) {
+		if (unlikely(!page) ||
+		    unlikely(!page_allows_collapse(page, cc->is_khugepaged))) {
 			result = SCAN_PAGE_NULL;
 			goto out;
 		}
@@ -1241,9 +1242,17 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
 	gfp_t gfp = (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpmask() :
 		     GFP_TRANSHUGE);
 	int node = collapse_find_target_node(cc);
+	unsigned int aflags;
 	struct folio *folio;
+	bool allow;
 
-	folio = __folio_alloc(gfp, order, node, &cc->alloc_nmask, ALLOC_DEFAULT);
+	/* Private node access: khugepaged never, madvise with CAP_USER_NUMA */
+	allow = cc->is_khugepaged ? !node_is_private(node)
+				  : node_allows_user_numa(node);
+	aflags = (allow && node_is_private(node)) ?
+		ALLOC_ZONELIST_PRIVATE : ALLOC_DEFAULT;
+
+	folio = __folio_alloc(gfp, order, node, &cc->alloc_nmask, aflags);
 	if (!folio) {
 		*foliop = NULL;
 		if (is_pmd_order(order))
@@ -1687,7 +1696,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		}
 
 		page = vm_normal_page(vma, addr, pteval);
-		if (unlikely(!page) || unlikely(page_is_private_managed(page))) {
+		if (unlikely(!page) ||
+		    unlikely(!page_allows_collapse(page, cc->is_khugepaged))) {
 			result = SCAN_PAGE_NULL;
 			goto out_unmap;
 		}
-- 
2.53.0-Meta


