Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A629BD59D99
	for <linux-mm@archiver.kernel.org>; Sun, 14 Dec 2025 20:15:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F4236B0006; Sun, 14 Dec 2025 15:15:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A5106B0007; Sun, 14 Dec 2025 15:15:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BADF6B0008; Sun, 14 Dec 2025 15:15:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 476646B0006
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 15:15:30 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C026213C2D6
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 20:15:29 +0000 (UTC)
X-FDA: 84219181578.05.7A15F23
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf16.hostedemail.com (Postfix) with ESMTP id D5CE618000F
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 20:15:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=fbcsFsti;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf16.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765743328; a=rsa-sha256;
	cv=none;
	b=15bjiDQdhGrQRuky7E7IxKj8/sAMF7TXKuy9w9xvW6tiPE/3l+3a99+pP3T0RDg0q5sMMQ
	r/+I9KeIa9bRHluOqQL7z9jzKkDX1ryNcTt/ByVFYA0bOSNxwX4FqA68un23bnA+r0ckIy
	dfYBonQ6eijuFg9z+SNPeK3phTu+Ncg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=fbcsFsti;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf16.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765743328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wf+hP/wJ0kmY4WYWXtteUdFJhqygC5K0r9t7p/QpVCY=;
	b=sQYDzCj42rrVVM20tfYy7YAQYtTdp4ZltmhOIJ0yw67r3Inw8Jpy0SLXtc717q4gqcAN/6
	d7uos2+Gt+VJARBJBHPTbbeuEW0lWCcXabdToue/6JFVb2CY6eOc9cuHzeMYn5FA32Gs2o
	QPKOarYFvbPBWq9n8Y5ilViKq73Ak+c=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=wf+hP/wJ0kmY4WYWXtteUdFJhqygC5K0r9t7p/QpVCY=; b=fbcsFsti6IdJsGVSqn3eUw3SFz
	gdF/RElQa7Qkit9cLyGCPZugG1L4L1W5iBQRDMPdbm58+dfv9Vpo2vM7BVR6QXUcJyshiVtZ2pphS
	pgV3bcaxgh462W0BAtYfGx1b/AKQlDJ1UyC2u/O9LC28Swg4Yqatugzo8mbxnB23h/mzL2Ts657Sj
	xPB1G4R+UO3aXpwzG0g7u1Iqom6GGWv1OoNF+YNFK4e6/ncIvMWlI8kN9OnxF2HZZqyhA6amggZK5
	WOnnxtysriPpE4TQl8QaLwLN9wX/BB5dWQQGasqy6dWzI1tlFUZtAllVdHRJkcEV0V0o1hwufoRDJ
	pvq6bAag==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vUsUy-00000002iHT-2oOg;
	Sun, 14 Dec 2025 20:15:24 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-mm@kvack.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH] mm: leafops.h: correct kernel-doc function param. names
Date: Sun, 14 Dec 2025 12:15:17 -0800
Message-ID: <20251214201517.2187051-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D5CE618000F
X-Rspamd-Server: rspam10
X-Stat-Signature: 9ismumro4gkbts5icoc8y3xnyz93bx5r
X-HE-Tag: 1765743326-424178
X-HE-Meta: U2FsdGVkX19rDF2ZM8Cz18zA4p7KDSoeJoiXINuUMCmfi/cs9ZDPIXKidwSXFGyvHQL1pvzwPLRA3X+vBz6CQaALBP9Ix4ocFPUKe+V6LqK7hg+d+NUiCvc4vmf+65GjxQUKWBt9e7gNrQCRCKnuH5Dzn+2V6H+e76gU7D3O/tXg9nu/f8KRUba0hHUKVbLxVagc+OtORvoGbL9bpbsPk5CfuhXcdqSj4WyNjR/t5roZa6m8lwKZbyMB/a6C2/w29Wbn1Or5rPkBO3IZFqCzq+HC+hvgUzdunohyEBrT6gE1LltDZgYOcc463QrYDg+mp/KFDshWCqjrwuq0w+lUIhzpUYe2YX4Orl8sWe2UScmljuoT6D4J7VCPlWfVWPvpP2DNyLSO1dl6SRGRcFIl7NdMNhChmuV71oePt9VWfdBSZ7mWFTMbXfEcYER9y4zpWZIMm4gVjvLLjM06Luy2lsphg+NxIHFNhac/I6hpAhlUdaKv8XP55v13aac0UnY48qedVo6oAgfNxPbaZzM4Vw46LnAC45PpErJxdDYN8tpEZ5Q9K6nmqmEa3ePI6Sh+gu5FgKiUe9qafjzftRbL7qNSJnEZPmNCEkEyhkTipwTjXA8EvztZAsoDVZC0c2jj1oGLyqCziFtuYqi9i+9l3aRw3bW2YaA9i9lEy/1uURnY/LllRd0dCLNswMypp0AOCJkRNmDfuZ5lYX7jXZI33jbODTiB4WVXZ/MogkSGEXEjnYgDnHtAXG103Ljn0S7qXK5cIrkQnR1CZubZEvxisfL+19ufulmPlofbgYoFN2FLaVrklD1n6nYe/mXxXD+7j4KjYhZ3Hv7v9ueZ80y+DUgn+IefBFl3pNknkSfXsZc8BfZ14/KN2O7pqm4BMAL1YFBIC85lKZID2gQkITe+THajcISBxsfuANU5e2ycORXoa5fT+bZXxSMkJRS8vWv+hkGpJiMcXoYUEGc6Jwv
 vKw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Modify the kernel-doc function parameter names to prevent kernel-doc
warnings:

Warning: include/linux/leafops.h:135 function parameter 'entry' not
 described in 'leafent_type'
Warning: include/linux/leafops.h:540 function parameter 'pte' not
 described in 'pte_is_uffd_marker'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
---
 include/linux/leafops.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20251201.orig/include/linux/leafops.h
+++ linux-next-20251201/include/linux/leafops.h
@@ -133,7 +133,7 @@ static inline bool softleaf_is_none(soft
 
 /**
  * softleaf_type() - Identify the type of leaf entry.
- * @enntry: Leaf entry.
+ * @entry: Leaf entry.
  *
  * Returns: the leaf entry type associated with @entry.
  */
@@ -534,7 +534,7 @@ static inline bool pte_is_uffd_wp_marker
 /**
  * pte_is_uffd_marker() - Does this PTE entry encode a userfault-specific marker
  * leaf entry?
- * @entry: Leaf entry.
+ * @pte: PTE entry.
  *
  * It's useful to be able to determine which leaf entries encode UFFD-specific
  * markers so we can handle these correctly.

