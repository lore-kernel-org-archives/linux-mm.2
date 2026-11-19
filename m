Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42EEB606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 02:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=exaZl6bG
Received: by kanga.kvack.org (Postfix)
	id 46E5F6B063F; Wed, 18 Nov 2026 21:52:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D0756B066A; Wed, 18 Nov 2026 21:52:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BFD66B063F; Wed, 18 Nov 2026 21:52:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F16176B063D
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:52:09 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 802121C4309
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 02:52:09 +0000 (UTC)
X-FDA: 85450344378.16.AD40C56
Received: from cmccmta8.chinamobile.com (cmccmta8.chinamobile.com [111.22.67.151])
	by imf24.hostedemail.com (Postfix) with ESMTP id A4E5B180004
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 02:52:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=permerror ("l=0 does not cover the body") header.d=cmss.chinamobile.com header.s=default header.b=exaZl6bG;
	spf=pass (imf24.hostedemail.com: domain of xujiahao@cmss.chinamobile.com designates 111.22.67.151 as permitted sender) smtp.mailfrom=xujiahao@cmss.chinamobile.com;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795056727;
	b=yESoxRE633BqU970Yst6qM/yUc8lk2mrQlCmMihqyn3yLBvenXjZ7+syLluC6Np0J34X9t
	Owb+YMYSnyn8nhvaYoLysquBMydyJcOtE3hn/ecEMqF4lL2AUZx+/SYgK3usqcX03hEopH
	iccU3l75OYEtONYgqWHyUNa8fn1tV9A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795056727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0aPRA4hpiTz1kk65aoPPE1Fyhse+uJcCQXxjdxwawZE=;
	b=NMeWu5eUwqn6wWsJaskv2+DnXvXSWTZMpW6/Q/ezy6KewFYtaUxQC+y8RibfKIjtuTdkhv
	8m8C8JrOEFc076HDtrYbOVigpYmzVV7q7q9xkaq+TuLyaOg0PbkXZ3EmYv3wZppB+lNLSU
	JfsaXzhd5P6Dkd9sizVvlG53yF2MEhg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=permerror ("l=0 does not cover the body") header.d=cmss.chinamobile.com header.s=default header.b=exaZl6bG;
	spf=pass (imf24.hostedemail.com: domain of xujiahao@cmss.chinamobile.com designates 111.22.67.151 as permitted sender) smtp.mailfrom=xujiahao@cmss.chinamobile.com;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=exaZl6bGXPTmhuXRv0ayXIUs5qcodj7bz/4qOEuJ/vC9nqxUfX2E1Df0kJY05Ed7CIfW5b2w9mQd2
	 vGheyZW4ToLKwfHjdVhD699P2SBdMVCgqoC6ohb1hWYLUfmm9n8ZyursfHUqSFRsrNFdDxlzsH49N7
	 k/wp0jR+HoB1iZs0=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app06-12006 (RichMail) with SMTP id 2ee66afe64402c0-e556a;
	Thu, 19 Nov 2026 10:51:45 +0800 (CST)
X-RM-TRANSID:2ee66afe64402c0-e556a
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from [25.255.2.225] (unknown[10.55.1.70])
	by rmsmtp-syy-appsvr09-12009 (RichMail) with SMTP id 2ee96afe643e04d-ecf5b;
	Thu, 19 Nov 2026 10:51:45 +0800 (CST)
X-RM-TRANSID:2ee96afe643e04d-ecf5b
From: Jiahao Xu <xujiahao@cmss.chinamobile.com>
To: Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, David Hildenbrand <david@kernel.org>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Kevin Tian <kevin.tian@intel.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, Samiullah Khawaja <skhawaja@google.com>,
	syzbot+7666ed2c3d42196bf7e3@syzkaller.appspotmail.com, Jiahao Xu <xujiahao@cmss.chinamobile.com>
Subject: [PATCH 1/2] mm/gup: add memfd_pin_folios_supported() helper
Date: Thu, 19 Nov 2026 10:44:17 +0800
Message-ID: <20261119104417.312237-1-xujiahao@cmss.chinamobile.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A4E5B180004
X-Rspam-User:
X-Stat-Signature: okoonwwf7bd8q8bdppn6y81i4qucnenf
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795056725-531434
X-HE-Meta: U2FsdGVkX18HiS8TOFXaBQca7EaBjEjIy5x8INvfxyKUzjDx8qf6r38KwSrepGj6NWWUcsFf+yvzc+vMY+HZlN5pdW2mUF/wqz6qk0LboIsrEcl7UxRkMSOex/AuJx4WS3ZKNrhvMkquhlAzTk/9xg3SGG/OfjX2ypzj7jQlOg0nn4MBT06bw9jUuL/acvG1YoNTSYwFhn9D4cWU562xKJQwaJBNtVkL6HuPonwkPnLG+TetloaCxk2AEYGdvHwbsl7dTnaPFaIp6EMyhbhRqalbPRmFYXPXjUxyk8ymijGvhKVNqwG23e3XPyjJlOwbnH/+RCLtR1BZMB4lTbDLLkjPdF0lAriKzRTdCr1/Se3oRPPfNqVQoJJ1VRf1xn4zjlHWgjdwDGzJl1KAtQE8fyGKyBJcuV6qNv2vM50q2P3d5H2Alk8KqQkqlkl7Zh496UIJb3NBEa1Ct3VNWx+0LaIY1avm1ciD56OfhDJWnN5NfqQ7h7sdrDG1k/JSHb7TBiNqvN3Oq5awQw0xopH6eAhIrSi1ARETiTkd5AW2QYUOw+Lf9WEEBHF1wQdWozwuFyJsXorfrb//ZAcOdF0dWqsiaa0N3GQ5o0+GPaP+38pwxrpo7f296oFZ9nPYAD5+nFnfq+xKsTX+ngsN5xspt3ciXGVa6WIxllQvxEjghSebW9VVkcDinme0Wmed6ouqcQ7ZI7hJg+15KufIfapT0SeIKIZoXFCheLgDee6VjZJayrgk9VKZy0gMYQHSAblnSi5PRr8/eGOluxj4iNK7S5XoyTaO/vbARkvZC1g0omtNrWQ/FhmZSTUMkTVuj/x69gW5ig3gF/QBnY9OH2eK/DUmBIa3hFRpM+TpAHpzTzPvMXdlmdTFCYoN06OPxoYjTkNlCDZu007TCl/MPUALnJ8nx7ZwsshI2pQpHQnsAhoc6htKhVb633a/2cS0y9tvh60KwxPuIIQbfNtr3jz
 7nqCZazi
 u/igBwOjPWhWMCkEEDMIW9lm4Bs/8JFFvMBJAChWF5FNtga4ZNKvRD5PjFogzjKcOItUzOIwluxb+MZ15IskGgcgIXGzGlrKaZDXXUAsTXjJRDXMjnRqehiwgLTBcM/qv5oiyvHjGTcQKWABuOn+4g0FKtMxhIwPKyw5bbKHgIa2L9dGOkHXzw2M4gCoX7/DUzVs5I7C9UYCBBA5wLk3t1Qm/RcypBmksNzatccGyL3oQlT7m26U8E+K5rMVS9mWXHBVG5ii0Ja8IoR7RlH4poi1/QzCZrInMHSatYN01/9ZOwvY=
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
 include/linux/mm.h |  1 +
 mm/gup.c           | 18 +++++++++++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 040cff643..e401edc93 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3600,6 +3600,7 @@ long pin_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
 long memfd_pin_folios(struct file *memfd, loff_t start, loff_t end,
 		      struct folio **folios, unsigned int max_folios,
 		      pgoff_t *offset);
+bool memfd_pin_folios_supported(struct file *file);
 int folio_add_pins(struct folio *folio, unsigned int pins);
 
 int get_user_pages_fast(unsigned long start, int nr_pages,
diff --git a/mm/gup.c b/mm/gup.c
index 7605da0e0..90ac51207 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -3449,6 +3449,22 @@ long pin_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
 }
 EXPORT_SYMBOL(pin_user_pages_unlocked);
 
+/**
+ * memfd_pin_folios_supported() - check if memfd_pin_folios() can pin a file
+ * @file: the file to check
+ *
+ * memfd_pin_folios() only accepts files backed by shmem or by hugetlb, so
+ * callers that have to validate a file before pinning it, or before taking a
+ * reference to it, can use this helper instead of duplicating the check.
+ *
+ * Return: true if @file may be passed to memfd_pin_folios().
+ */
+bool memfd_pin_folios_supported(struct file *file)
+{
+	return shmem_file(file) || is_file_hugepages(file);
+}
+EXPORT_SYMBOL_GPL(memfd_pin_folios_supported);
+
 /**
  * memfd_pin_folios() - pin folios associated with a memfd
  * @memfd:      the memfd whose folios are to be pinned
@@ -3493,7 +3509,7 @@ long memfd_pin_folios(struct file *memfd, loff_t start, loff_t end,
 	if (!memfd)
 		return -EINVAL;
 
-	if (!shmem_file(memfd) && !is_file_hugepages(memfd))
+	if (!memfd_pin_folios_supported(memfd))
 		return -EINVAL;
 
 	if (end >= i_size_read(file_inode(memfd)))
-- 
2.43.0



