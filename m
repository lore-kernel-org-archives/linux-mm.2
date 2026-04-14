Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE254F9D0D3
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 14:24:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E66E96B009E; Tue, 14 Apr 2026 10:24:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3F486B009F; Tue, 14 Apr 2026 10:24:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C91AB6B00A0; Tue, 14 Apr 2026 10:24:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD5846B009E
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:24:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 78A3AC185A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 14:24:17 +0000 (UTC)
X-FDA: 84657381354.01.453E718
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4FBAD140008
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 14:24:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cGCPFRti;
	spf=pass (imf26.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776176655; a=rsa-sha256;
	cv=none;
	b=LieFvAr/O2HaDDUQAE06jBBO3UPb7RICZ7ftYqFXKYXI7kFa8hN8PV1HaqkjXLP9hXlva+
	9UD5p0bhXWE08YPvsHjeqEm1pLHeAhNUmSRhiABhgFYMn76lNNnkafZrdDkLiGfhuhfQ4O
	mJdA0qVrosncJV+KWgSN0dQc4gOS++o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776176655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UDQ89HHsqZH4YYQy5QYt/0LTuL5fEe7aAoqhBbI6fKo=;
	b=YpOP3fVRFcZrrPzz7/ZyeeT5HH9nm1sT1yWLNTHOIo141X76ahkC510z/xWDuJDTHL+5s9
	inahKBOKrDPz7qnIXPzID5XpWSWOIUFqxUiCrwIhriursZ2BN3w4z4gIlSlcaXv1bIJcQ9
	2u3iotXvRJiLgdFRu3fWxopVZsZjJYQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cGCPFRti;
	spf=pass (imf26.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 081AD43957;
	Tue, 14 Apr 2026 14:24:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72AE6C2BCB0;
	Tue, 14 Apr 2026 14:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776176653;
	bh=oOUfU0VXNyHpbUZg2Wz9Ad/eUIXrqX/a1NFbEQbuFDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cGCPFRtijZvEvu1HXnZmA/JE+X1We8vOVr6IiVlOdHpVjH88vQEJbD9DlqBaTXQ1a
	 79oW7Ww9Rx6Fwm+7BbASpPRXsIMjxev/3PjmWHKBflqHcuTaBT4e3sIi76vmYj9hsq
	 2Y170gaGDn2IFT2Xf8F3Fsd5Kd1VDaTZ+zZ2AdYyObc9/E/s3YWIlr0SeeMLPp/H/O
	 kaS89/m6unbSicheEjUdxo/sbaUN48PDWOHfW1Qf07miVgZciaHoNzKCIklO2N5M9w
	 XP258VvGz9r3sl1W+wTtqETUUUTLZFelL5kTyT7xSf/yjIWbE2Q+a0odF5TGnDfNjN
	 y4lwvjyks/H2A==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 9EB9DF40068;
	Tue, 14 Apr 2026 10:24:12 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Tue, 14 Apr 2026 10:24:12 -0400
X-ME-Sender: <xms:DE7eaRJsSqUyKkUujdh5oHCEMfuxxrA3QXSu1wgzsKfCgI-Eos2C9w>
    <xme:DE7eaUGNQ48Rum9mswU4fXgpqLXR9t405IKOfZTwhdrv7zxHM_XYRUR5bOgatmHgC
    d56XNG-aEKeWKaU214rNTRJYe7eC4bS0sIK6YSdrxtc_7nnljnHgow>
X-ME-Received: <xmr:DE7eaezchvjcbOyJ1q4PWG9cqTm81Yy52V3WStDVsCWYLJI2g0bVzLdPMPuvfA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdegudefkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpedfmfhirhihlhcu
    ufhhuhhtshgvmhgruhculdfovghtrgdmfdcuoehkrghssehkvghrnhgvlhdrohhrgheqne
    cuggftrfgrthhtvghrnhephfdujeefvdegkefffedvkeehkeekueevfedtleehgeetlefg
    feevveeukefhtdetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepkhhirhhilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqddu
    ieduudeivdeiheehqddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghessh
    hhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepudelpdhmohguvgepshhmthhp
    ohhuthdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorh
    hgpdhrtghpthhtohepphgvthgvrhigsehrvgguhhgrthdrtghomhdprhgtphhtthhopegu
    rghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopehljhhssehkvghrnhgvlhdroh
    hrghdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepshhu
    rhgvnhgssehgohhoghhlvgdrtghomhdprhgtphhtthhopehvsggrsghkrgeskhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtoheplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtgho
    mhdprhgtphhtthhopeiiihihsehnvhhiughirgdrtghomh
X-ME-Proxy: <xmx:DE7eaZhQLnLO_Dfm3ta6I_-g5-mBiDi4wTk_x7AjSAdFMbBNPWcAMg>
    <xmx:DE7eaTLVn3Bs7uGdfEReC3Z-pcEkaKgVWbLYijLzN5Ugl1SwZOh9Rw>
    <xmx:DE7eacCJgvBPdnrwIvAKoGdRB8WFzSTLoIolIzXckarWkkbTRINl5A>
    <xmx:DE7eaURvo18OjfXDw6oxglQ3Z9k1BiyqjAQd2XIoLYMkJTgrQbudnQ>
    <xmx:DE7eadrGQPUzV8QZvZNj92j1e6CsQA118JxIR7FwKdyEVEj7q4NDyOTB>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Apr 2026 10:24:11 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [RFC, PATCH 09/12] mm/pagemap: add PAGE_IS_UFFD_DEACTIVATED to PAGEMAP_SCAN
Date: Tue, 14 Apr 2026 15:23:43 +0100
Message-ID: <20260414142354.1465950-10-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260414142354.1465950-1-kas@kernel.org>
References: <20260414142354.1465950-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4FBAD140008
X-Stat-Signature: b5hqq7kjx3xnhenbcq9obqb1ud15kw9p
X-HE-Tag: 1776176654-444403
X-HE-Meta: U2FsdGVkX19qdqUkmgL0FpU3hPhBk2ZEvyuiQqpRslBKcZ3x806hfx9UQjspksjXMgWmRTs61xf6ygTtqh33rk9pNDf1coG0Gqe29aePz6TPWB4U3GDcHa4nJ3WHtPBg1yb2NHC4bXRMQ51g9iVLNKNvWjb4Px6aw7DpdOX465UkUR0CvFce7BFitg/JkZ8KGwfe3qJzdZ2tRQojU9wSw2b265V0QkEmuVPHl8WCke66V27IflY2DpuIqJ0qpE6imXCrNqlO++SzQO6HhWAJz7yCsCI6TiJ1YhnkebxodLUmPJn64u0CFgVD7kEj2AWuC3SoAEHbSo2rZUinrATTVpIWySQ9Ja2UtAwUFH0z9uE8fSJs6Uzghp7rIDKI2Zpd53iYwuV6carXd4hhzIE8GWwztyUGQbbt7hL85q7YO8AlwR6uSdr2mgmMil5oJveSECX6b5XayPDDlJqolul7m+2A/vIiJic8AP7jfOVp6bcLVIC3R/Aenl//KbsZmn/oM6cynl593pJ2yhcW7TmbOW07At6BY2f+X1u1EJwp0VlpdFsADqA0rOq6EebnhyNSMW484urj8aFGeBWTvwv+mQf1W49w8wKfbAScJpfBtV4N3lCNGE6bmUcNf4dYARzW9lMztekVyalg85YgzOvWjxQtl7jY6Zi5cJ1x9uX+hWCI/4P3ZUx0Q/4REth6Io6G7eRRccLN/Ou8J9EeZbiDUCnZUzCJTfbzfRPY9uizdPiqjuQGid9NY7k0s+J87xjE75vxznVCOXCGXzWP8+a0Jl2M5FjuTyVXvb5rkZLPt7pe3PNGGdX3R9EeVBFxoR+WC4UD007iS5+t2amavznpREONiU4Hslkf5NVHhXWmaJqqegPRuZPl8wIRHADHoZfeH7e9t/XJNYjIoNKxQVRGIv2YLif6ZOHymsxntu1xz/9dM4bKEbRv8U3dHH0O41NxsnGxu04G7LagI0veoWz
 Z2FM/F81
 zlIb9iJUsMqKUIRuSl0UkqoQaZi8druLg4FqSCQTDU/aTp+9k63ZLxAU61x76E1wxEIBN3OUL8DRsW5nG/jdsj49Z3qlJ7lFoEIaEh/9HVWrTAfYQTsGS9FfXhwtKq6gaK2ICp51SwYyUHwAFT3um5lTU41YcO4Qh9961nBvXsin4oCshzfNXogaUoEI4C3jn6jjbtNt0u2FqLXEt61xUOLNYwa9i6RHdAXIoISweF+KQuH8maN9XGc6sBrDMLvZwex74LFM/CPWSVzyB6ip4aZbYadD+ih2e57B1tjGoIiOlHKu7xOgx7ny2vg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Report deactivated anonymous pages in PAGEMAP_SCAN results.
Only set on anonymous VMAs (shmem cold = !PAGE_IS_PRESENT).
Both PTE and PMD (THP) levels handled.

Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
---
 fs/proc/task_mmu.c      | 11 ++++++++++-
 include/uapi/linux/fs.h |  1 +
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index e091931d7ca1..fc42cfd5720a 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2329,7 +2329,7 @@ static int pagemap_release(struct inode *inode, struct file *file)
 				 PAGE_IS_FILE |	PAGE_IS_PRESENT |	\
 				 PAGE_IS_SWAPPED | PAGE_IS_PFNZERO |	\
 				 PAGE_IS_HUGE | PAGE_IS_SOFT_DIRTY |	\
-				 PAGE_IS_GUARD)
+				 PAGE_IS_GUARD | PAGE_IS_UFFD_DEACTIVATED)
 #define PM_SCAN_FLAGS		(PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC)
 
 struct pagemap_scan_private {
@@ -2354,6 +2354,10 @@ static unsigned long pagemap_page_category(struct pagemap_scan_private *p,
 
 		categories = PAGE_IS_PRESENT;
 
+		if (pte_protnone(pte) && vma_is_accessible(vma) &&
+		    vma_is_anonymous(vma) && userfaultfd_minor(vma))
+			categories |= PAGE_IS_UFFD_DEACTIVATED;
+
 		if (!pte_uffd_wp(pte))
 			categories |= PAGE_IS_WRITTEN;
 
@@ -2422,6 +2426,11 @@ static unsigned long pagemap_thp_category(struct pagemap_scan_private *p,
 		struct page *page;
 
 		categories |= PAGE_IS_PRESENT;
+
+		if (pmd_protnone(pmd) && vma_is_accessible(vma) &&
+		    vma_is_anonymous(vma) && userfaultfd_minor(vma))
+			categories |= PAGE_IS_UFFD_DEACTIVATED;
+
 		if (!pmd_uffd_wp(pmd))
 			categories |= PAGE_IS_WRITTEN;
 
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 70b2b661f42c..af5b28901800 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -455,6 +455,7 @@ typedef int __bitwise __kernel_rwf_t;
 #define PAGE_IS_HUGE		(1 << 6)
 #define PAGE_IS_SOFT_DIRTY	(1 << 7)
 #define PAGE_IS_GUARD		(1 << 8)
+#define PAGE_IS_UFFD_DEACTIVATED (1 << 9)
 
 /*
  * struct page_region - Page region with flags
-- 
2.51.2


