Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B336606B12C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 08:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=DhgOlSo8
Received: by kanga.kvack.org (Postfix)
	id 269E56B05B3; Thu, 19 Nov 2026 03:40:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21A636B05CB; Thu, 19 Nov 2026 03:40:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 131106B05B8; Thu, 19 Nov 2026 03:40:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E65E86B05CB
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 03:40:39 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 62A5B14094F
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:40:39 +0000 (UTC)
X-FDA: 85451222598.13.FBE4C91
Received: from cmccmta2.chinamobile.com (cmccmta2.chinamobile.com [111.22.67.135])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4DF74180008
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:40:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=permerror ("l=0 does not cover the body") header.d=cmss.chinamobile.com header.s=default header.b=DhgOlSo8;
	spf=pass (imf06.hostedemail.com: domain of xujiahao@cmss.chinamobile.com designates 111.22.67.135 as permitted sender) smtp.mailfrom=xujiahao@cmss.chinamobile.com;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795077637;
	b=QF0Wop3GZBt3BDU7eAyM/s9IDN+MmNbhui1jTtbICrQZ13iVCuercyB3S02TcP94mTVwIz
	edgke0TrD0w78jMiXLHiRyXNs1N68Q7V1nyBHVy+JHfq/3lpxMr3kPnX+jBOyP0wo6ngWv
	rgwCVCDbgVAIrPOBkI5Ctubed7UiRCU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795077637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fypsmh/yalmylSlR4JWqGqknVIfjPZ3AfNYwQxJkT78=;
	b=ORMlZM9HuAFjzz4Bo+vmpe0F2pJX424EXBKMc81t0dMbNQpdoSTdmH5owZzPA4zPbWGvm3
	2kkGZ/HmzuXoKkZAw4RukKlCMV4X31ADndQcTzUCUiDZIjffG1eyf4aZgeYQVQUhMyArSD
	SWmaXoI9rieQE9LbefPyq5zdPkET/mg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=permerror ("l=0 does not cover the body") header.d=cmss.chinamobile.com header.s=default header.b=DhgOlSo8;
	spf=pass (imf06.hostedemail.com: domain of xujiahao@cmss.chinamobile.com designates 111.22.67.135 as permitted sender) smtp.mailfrom=xujiahao@cmss.chinamobile.com;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=DhgOlSo8ucLm1RtvW2+pJEPUAmE0+8OXc+rtX1kNNc8cEUFMQ4PmvjfhO/B6i6K34xdCRsxK8bPp7
	 58zcZlhPP3bM7P2B8jpD1/k0Y2gDjglHcZGZ151gN/upTiCxvxLZeEDdg28+nKnXk/RiHeSY2+sSq6
	 Hj7iQpjZlHxhgDik=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app03-12003 (RichMail) with SMTP id 2ee36afeb5fe415-e8358;
	Thu, 19 Nov 2026 16:40:31 +0800 (CST)
X-RM-TRANSID:2ee36afeb5fe415-e8358
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from [25.255.2.225] (unknown[10.55.1.70])
	by rmsmtp-syy-appsvr04-12004 (RichMail) with SMTP id 2ee46afeb5fe31f-f6eb7;
	Thu, 19 Nov 2026 16:40:31 +0800 (CST)
X-RM-TRANSID:2ee46afeb5fe31f-f6eb7
From: Jiahao Xu <xujiahao@cmss.chinamobile.com>
To: Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, David Hildenbrand <david@kernel.org>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Kevin Tian <kevin.tian@intel.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, Samiullah Khawaja <skhawaja@google.com>,
	syzbot+7666ed2c3d42196bf7e3@syzkaller.appspotmail.com, Jiahao Xu <xujiahao@cmss.chinamobile.com>
Subject: [PATCH v2 1/2] mm/gup: add file_is_memfd_compatible() helper
Date: Thu, 19 Nov 2026 16:35:31 +0800
Message-ID: <20261119163531.788514-1-xujiahao@cmss.chinamobile.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ps8orimqc74x8j49g4opcid3k95eem3e
X-Rspamd-Queue-Id: 4DF74180008
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795077634-844922
X-HE-Meta: U2FsdGVkX1/wJklLIW9sIVCxoP3ncYNQGoqpLEjT30/J8C9ClwTqhJSEepy/xX56N4ObK+PnRWlDrY6iFpkGwDr2ZbXRDYANxkYxqYhDFYwcIgLba5GTeJn/Ha0GJNxYk+Dly2ngYH6BTj7kSWG4kEqbKEWb6PFD+Kjmy2I/+BTdM3uSFxrq5ewNB3WnUQy8uf+8jdGzbM6VipCXH8EVz2nJf0Uo2TJ2sotg+uJyR8MvXIoUPoOHubxim3arn5pYw+7JkfwzjnBaIvXfeQ9ssHlb3O8Yva01Pkx/g7OFQq1jL/ZPmcbQyGEN/Q5Ms4MIpfpviOr/x26pqaaYIUCkkayUmI+fV6DxvojAe17YdH56v5aWml7Nt63zwDkI3TUDmd9Ra/88orpg32EwZ6nk2GwFFKBeOSXn2WDKnb2oS73HOi/QcY0UKtBbW4qX6Wju0YTi1h7tLYd8AGXI7p93fkZKK0MPzxMalgUuYusjW9+DhZLvG1UJrqk+UtSvtwxDUJZoM2fAi4o4pliP6oth4QUvHpcnrd175jGakOrR0IKKAllS4e+5+HYzF7E2w/Kbq0IrgN4CODEY7FANnhNSBomlPnT+V4nhKhDf8uHr6IyT2csMVcmn1O9P1T01gNEA5+kaLRNaAYem7Iq5pqy64dQo2fD2GxU2bbxaUrXq4BVSMLUWV5QzlGzpzmKhPH+wi0XH/0FNzZmMvEd2+N3hQ4vhCX2Vp+Qoyim03tE8lBTuqziXeGW93WXKQI4HeE7DVo312kg5dcLxlPHvIVIyg98ygI+qpmRU68LfuKDW/GcjKgreUDQA9V6DI5cCek2/fxDyt7AUZgSfJoI3DPeskWmYRc6lmmSgV2q+ZMdb3rGT+GHV7g0D4c+E8gLohLecVKn6w66FFMOz5MWC/8rkJ/xRI3g1DphU4BJJP3SSi0v8aKjJ7g2ze8n3K7IZm/bgB+my6q+pQn1WMhj+KM5
 fPeyI9Un
 2L9BuYihR5zb6W6+T9UENWtkFS38WwtyrfkimXD2SiYo41GRY2azQjogplU5JiV+QVIvQuqviwBEcyRlatCSRIPtRKW13PvEu7Ja9ouxiVpRvs4Fauy5LrhEiEa0uWNom1p6TfL2A/AWlNQTzlYEc1rt3hk201qmvVBn9U7tHMeDTmPpWATtDxC/XWTD4L8kHlvvAVwXxRP5wUaFwPJsNvkIZSaivv/hLxrZqYTBDMViZU97ZYl7tSOH8vF3MC7h/R9UNCOYUlmbxlRoj7nf7vxGpw+gLbkrazeHcgLmJsEQ7ZI4JXi+qK7kWvV5CyDvp1jDd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

memfd_pin_folios() accepts only shmem and file-hugetlb files and enforces
that inline with shmem_file() and is_file_hugepages().  A caller that has
to know up front whether a file may be handed to memfd_pin_folios()
cannot use those predicates: since d3710111839d ("mm/shmem: make
shmem_file() check the file's inode") shmem_file() is an out-of-line
function in mm/shmem.c which is not exported, so modules cannot call it,
and is_file_hugepages() on its own is not the same question.

Provide the check as an exported helper next to memfd_pin_folios() and
use it inside memfd_pin_folios() itself, so that a single place decides
which files may be pinned.

Signed-off-by: Jiahao Xu <xujiahao@cmss.chinamobile.com>
---
v2:
 - Rename memfd_pin_folios_supported() to file_is_memfd_compatible(),
   suggested by David Hildenbrand: the predicate asks about the file, not
   about the memfd interface.
v1: https://lore.kernel.org/all/20261119104417.312237-1-xujiahao@cmss.chinamobile.com/
---
 include/linux/mm.h |  1 +
 mm/gup.c           | 23 ++++++++++++++++++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 040cff643..dffcc0b5a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3600,6 +3600,7 @@ long pin_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
 long memfd_pin_folios(struct file *memfd, loff_t start, loff_t end,
 		      struct folio **folios, unsigned int max_folios,
 		      pgoff_t *offset);
+bool file_is_memfd_compatible(struct file *file);
 int folio_add_pins(struct folio *folio, unsigned int pins);
 
 int get_user_pages_fast(unsigned long start, int nr_pages,
diff --git a/mm/gup.c b/mm/gup.c
index 7605da0e0..da8a2c29b 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -3449,6 +3449,27 @@ long pin_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
 }
 EXPORT_SYMBOL(pin_user_pages_unlocked);
 
+/**
+ * file_is_memfd_compatible() - check if a file may be used with
+ *				memfd_pin_folios()
+ * @file: the file to check
+ *
+ * memfd_pin_folios() only accepts files backed by shmem or by hugetlb.
+ * This is wider than "is a memfd": every shmem file matches, not only the
+ * unlinked ones memfd_create() produces, and file-hugetlb files are not
+ * memfds at all.
+ *
+ * Callers that have to validate a file before pinning it, or before taking
+ * a reference to it, can use this helper instead of duplicating the check.
+ *
+ * Return: true if @file may be passed to memfd_pin_folios().
+ */
+bool file_is_memfd_compatible(struct file *file)
+{
+	return shmem_file(file) || is_file_hugepages(file);
+}
+EXPORT_SYMBOL_GPL(file_is_memfd_compatible);
+
 /**
  * memfd_pin_folios() - pin folios associated with a memfd
  * @memfd:      the memfd whose folios are to be pinned
@@ -3493,7 +3514,7 @@ long memfd_pin_folios(struct file *memfd, loff_t start, loff_t end,
 	if (!memfd)
 		return -EINVAL;
 
-	if (!shmem_file(memfd) && !is_file_hugepages(memfd))
+	if (!file_is_memfd_compatible(memfd))
 		return -EINVAL;
 
 	if (end >= i_size_read(file_inode(memfd)))
-- 
2.43.0



