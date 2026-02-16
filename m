Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0113E83823
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 19:00:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 558916B0089; Mon, 16 Feb 2026 14:00:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E5CD6B008A; Mon, 16 Feb 2026 14:00:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42C116B008C; Mon, 16 Feb 2026 14:00:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2F32C6B0089
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 14:00:04 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BB504BE430
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 19:00:03 +0000 (UTC)
X-FDA: 84451234686.18.0ACBDE3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1F501120014
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 19:00:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OhrvYoaV;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771268402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C/dKMkgdjI+mYgJARn4sBz+QeKEfxgv8U21+9jtU7M0=;
	b=fRZgSqHMRKRPh/kOb7V5Me0Q+9F3AU6GDQnXnDBkWDpW+diHwxKg3sOL8O0PmECQrEobqJ
	cjbtC0XXUeI0bXHV5D6JRZwBaGwP/+eSabLT3O3dTkAS/uU28Pnfl77bhircrxrUuJOEtC
	YDJxxDwVvo3TiNnx3FetyekaGKVrozw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OhrvYoaV;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771268402; a=rsa-sha256;
	cv=none;
	b=lwJA7CkSlUaPnFuMTA0ihtiuRV1i5PS5GmCrj57+keA8mfigI1AZJGNf1rUGqhGXrriqia
	FZq+mK2J05+j/WY/9icIhWponhQaMK6qAJ4gm+eJ0zp6cSdlSss75+wCCyCWjjkIabhgPr
	LcxQA4D0M851F+3ZiBZg44/HHx/KHbg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 88F9160145;
	Mon, 16 Feb 2026 19:00:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44499C19422;
	Mon, 16 Feb 2026 18:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771268401;
	bh=6Hh3KYw2Jyb1btkJg7DMiLM+J1fGkbsEdPXZYlYEctY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OhrvYoaV8utxpqTBno7SbwJVX0AU+R7vbcXf+xXIJS/M7LfbjsrGjyg7hefx912jU
	 h7aAkI7h2dJTIHUkFGciVaMnHvtGJnHwex2MjrPSU0A8PLd+lFsmTPGBVh5aoKsZUH
	 g17wZ0SmTm+fvGPCvJ6XZlkUx4KTWjNK/ktTwNTvRRtGxbf4e4cOrFaxWT92RWogmt
	 CXyjVnEnhA4+I4jMzg6zzL1snyXnjK9e8V3QWjI1JGPZIKaPNvK3/RDDRgoCHgHmPj
	 ZzJxAo0ixeA0nQFity8fNEte4xt0YGsiS9B0R/ZJ3mwnclbsdMGvOXlnalX4FdMYmD
	 +35c/JPjEJUxA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] memfd: export memfd_{add,get}_seals()
Date: Mon, 16 Feb 2026 19:59:32 +0100
Message-ID: <20260216185946.1215770-2-pratyush@kernel.org>
X-Mailer: git-send-email 2.53.0.335.g19a08e0c02-goog
In-Reply-To: <20260216185946.1215770-1-pratyush@kernel.org>
References: <20260216185946.1215770-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1F501120014
X-Stat-Signature: i67rf3ocstowe9yk5ib9tig4xhzcpmzd
X-Rspam-User: 
X-HE-Tag: 1771268401-583496
X-HE-Meta: U2FsdGVkX1/XZgJm099LBWfZnilJQkY8LK3Mlu5Ogai4dkuIASrsLrA6mGhmWjVgqbpLWnzYhbsQ0Ae3fWpz+jQzbb0xR97NF0FOMGHIkC0MusNni1NqQZ25mq37J7reE77jY+CpHYwEANMDNd45zd9sKbJ+J9P/dxL0MNfop1yWNOAxYY7PtkviKEilJ6B7Oo1KaBriU/4tD/QMw6zC6UEIXWgUV60Ax8+1eRlbgVDJcGxbK5eQLHs2BKUgPAKTuCvlVWI/7R8si1Cd/jGPrHLDptQZ5EuZ1l1m3vj5BRPagi0Azmou5DiAVarh+haFGtL0aGOYEux7TUcoL2GggXdn35hHIxngxRlci0xDC+tSFv4p3QCJu7kkaH4QZ5mewybtn7SW27l4icok1wkxdJf+E7nZTkOALJlXrhySHkcNstKv/dTajwIVeKRoHhe5Hf3IDx4aHdele9brxrH2pOzNFBWq5neW2+jQt9/pE9kFBQJYb4hmnW4tew6T9/Z2vYit+Il8tCjaoFfpwetBQGgdHWlvwXrdYoPE7KFgP8aJghM3zUJRCKIr2NWlbK4bTay0gMN8kwFhctQ0psCORlk5d17HzWM4uTLhywVu3oTySv0FsCQJjFx5YsPv6/+ha2Q0Xtv8zog9A7AEo2ywlsLtgmV7wO/VekG5L6NkK8VJOfRr11jDjnjXqyCCH4ZV5NN3VuzgElmWP9peoMuAfh1Rvpm2ATqwDdgBamKRBbCboruc22i2qYbmWwHsCzhJKadPj9ThgmdzbdG9g1RmIyoSD1K0UDf3r0WLdlKrZkCu6rT1glKFM6sBzqL9sG6TdtvwPsG5vGqmp4VDZ5FsGT3/4IY3IWp30Tq/35u8JGUbnVG+PzJJSXC4AwsP3m1GFOCPqtBSsTVjCzJpZv3HiCbJyq0kiovV4EHVFCwdtDSU5CxLEE6smPuEoKT/itiei6BZFhPb+b6NP5IeiWq
 Ot3wk6GS
 /hiZDZ30uMdgyMegJG+hS6WPQxEIRt5nLaqWoTmUpzZJnkAPgX/jNtZBVwtsZ+dsfuIdiOn4qTH8qqtnBYX+spgqCtoShjsVYEBMZbQ4yLascX/5Z7XmV/yJfneeosxbyw9QIM9GznVnreYgXnNSm/Mv/6qUdZ+mGmDATDRmwjsN+hC8djkQqLTTnz5aRdfYIwESzUyZN4g4IB8/fuvUUgNHIkrB8KxPmk9Q6ThdqbKv57HoxyArLi5GZtEOJXLRb26hcJme8o/u8b5hqDFjqxDTJvxAMiZjR4u9v+4+BH1yQ+gMZ7P13YhuTs4v/elcZSa0M
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Support for preserving file seals will be added to memfd preservation
using the Live Update Orchestrator (LUO). Export
memfd_{add,get}_seals)() so memfd_luo can use them to manipulate the
seals.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/memfd.h | 12 ++++++++++++
 mm/memfd.c            |  4 ++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/linux/memfd.h b/include/linux/memfd.h
index c328a7b356d0..b4fda09dab9f 100644
--- a/include/linux/memfd.h
+++ b/include/linux/memfd.h
@@ -18,6 +18,8 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx);
  */
 int memfd_check_seals_mmap(struct file *file, vm_flags_t *vm_flags_ptr);
 struct file *memfd_alloc_file(const char *name, unsigned int flags);
+int memfd_get_seals(struct file *file);
+int memfd_add_seals(struct file *file, unsigned int seals);
 #else
 static inline long memfd_fcntl(struct file *f, unsigned int c, unsigned int a)
 {
@@ -37,6 +39,16 @@ static inline struct file *memfd_alloc_file(const char *name, unsigned int flags
 {
 	return ERR_PTR(-EINVAL);
 }
+
+static inline int memfd_get_seals(struct file *file)
+{
+	return -EINVAL;
+}
+
+static inline int memfd_add_seals(struct file *file, unsigned int seals)
+{
+	return -EINVAL;
+}
 #endif
 
 #endif /* __LINUX_MEMFD_H */
diff --git a/mm/memfd.c b/mm/memfd.c
index f032c6052926..46c5508beea4 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -228,7 +228,7 @@ static unsigned int *memfd_file_seals_ptr(struct file *file)
 		     F_SEAL_WRITE | \
 		     F_SEAL_FUTURE_WRITE)
 
-static int memfd_add_seals(struct file *file, unsigned int seals)
+int memfd_add_seals(struct file *file, unsigned int seals)
 {
 	struct inode *inode = file_inode(file);
 	unsigned int *file_seals;
@@ -310,7 +310,7 @@ static int memfd_add_seals(struct file *file, unsigned int seals)
 	return error;
 }
 
-static int memfd_get_seals(struct file *file)
+int memfd_get_seals(struct file *file)
 {
 	unsigned int *seals = memfd_file_seals_ptr(file);
 
-- 
2.53.0.335.g19a08e0c02-goog


