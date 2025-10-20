Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9443CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 14:31:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1587C8E002B; Mon, 20 Oct 2025 10:31:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10A028E0002; Mon, 20 Oct 2025 10:31:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3A168E002B; Mon, 20 Oct 2025 10:31:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E1BCB8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:31:06 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A6AF81DD60D
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:31:06 +0000 (UTC)
X-FDA: 84018729732.08.C986E78
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id D80FE1C0014
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:31:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k7+ZDnsB;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760970665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uKomyafRExUlHbpakJlA9iaA5ZoDv+ga+N8T6SBGRFE=;
	b=y8cbgqMkdWIH5jHioglJIi+53Pf79i+GsugZnzjR9Ty6q3yd8XbRDJOhSASvrOy7OctMbY
	NLT90Ik/8IeveR9t0PDTX9PfPR2/C6E110rdazaTPJ02DuZxwkU2bxFqU8fWmMLrLj+aan
	hdcBAw9vw8fHfRqYCKaVLeifCbYDHGs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760970665; a=rsa-sha256;
	cv=none;
	b=YjOervW3BjpMbdv3YmVHVhJEb+FCukZxlvGLtTEtA6fEYkQi91tRUUd2wEIxPP5dFNGkcu
	3wsENT78O+/+/dcIsVnM5eU2qlkwBTfHTSvrwYDNN/cBm7zAEXZGMrRTBT1Hc/OduD8SC6
	DnV4GzErGtfi0c4znhIzdqoqLiCoPLc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k7+ZDnsB;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C45E144278;
	Mon, 20 Oct 2025 14:31:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA76C116B1;
	Mon, 20 Oct 2025 14:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760970663;
	bh=Zgh/z5OAav7Q4sWyHwtd8KQU+ZJ/UY2frwfkFs/0zg0=;
	h=From:To:Cc:Subject:Date:From;
	b=k7+ZDnsBo6sHFfM7V3XjA540jxwzbjD7wpXcvDjXgBZHceYe7SmphByUgNxyioXn6
	 /B1Kqi83dvd9U37KNqP4f0HRQne1lyscHCkndUZFgy1BnAVUSjezJEsGhrdzko8TRv
	 h+ObONN54XTBZsJrK7hx+95DhdoOV9eIKkGfbC1bW6wga4Ej96JLoSOi8I+XWbOpGV
	 QCxeSUxmBXxZxZNduGonaSKD1vmACPpz+T2+/Nx+7okTyUcWO9A3AMvy33UsmYqTN1
	 d8jAgOo9CjZrSA5ZzeH8d/Tf0j0E6kdVKlwBXMBkBsxC9EBgwnxOu4uafllhn/ILPI
	 0D1gykG+4O5yg==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brendan Jackman <jackmanb@google.com>,
	David Hildenbrand <david@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-serial@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm, vc_screen: move __free() handler that frees a page to a common header
Date: Mon, 20 Oct 2025 17:30:55 +0300
Message-ID: <20251020143055.407696-1-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: mwoksmdaaboyb4e3rgq88n7zrut9at3h
X-Rspam-User: 
X-Rspamd-Queue-Id: D80FE1C0014
X-HE-Tag: 1760970664-159825
X-HE-Meta: U2FsdGVkX18vCWGvpqUQCG0+ukdh9vAFqGWcnramo41q7XcCry9Nu5+dK7gDEbS1kGrfFF8tLpIw/DaLHCcoOGmbTsrNV5kdtzZNxC3c0uQUh1JAh4i2Wkkrs1px2a7E77BQRGiEWT8BfJA3XicwWM8IzsstpHZeHOHw83S8pMHeH5llEKxV1Z+gVS3BgwU59feL4ZJA2ZtYJB49cF9dnxKkGkERXJ+SP5B9gBVcRbWx7HvZXZgriYk/TKfbQ1Su9+HJfYBybQ5GTWGRJg5LvUuUbQlBiVTkktEp6TDrT24Gp7mdVhUqnc06uGrj2cChxNw9QXVmHBaG5mb90ltZGadT1yy/DLUN2iT5sOzj3XntlKX3pLyPE1ACGQoQPE4GIUj/1r67TW+wfoC6OIU/Fqn4pRCmGSckogCatYW8KdbuJcQSIMv2VIICWfR5o8jBuBqF9C7jQUnPTdJJ7lW4Z0+baMZmC1c36vrFeO/dfUHyuQ0Lj1Sbsv8s+lMdD4gJn73gstn/NdHn1Rp6XwjYihHPvuVcfrAML5d+GewNjZEZXW6gcqxNraYl0NvcklBEWBLQhS6YADEUd3N5PusyZsw4cl2SfAq4Cp37d1zDKm8JZUYPDvtCobEu3q10wHhJ00Gu4K+St9Oa6nm+CUUuS+MibMf5DOfYII+mGw73gyAFy02sQEDQBWN6i5JeXqhg73Laa2HBozRcIjDFt1GPrSb+3QSQlHkkRah1FmK05ShFXCaqbt0vTwU/gtHxZYXpnq8EL4NhdoAMHQuipM+iWRRCKxrp93WfNc+bGRhJNfGnyyAXMGlY6MSdAGFfx7tt3FBu+XPjGTyC565OG0EXAYvy5hPDe9bXaSw6TAQcT8ARatWV9eD85OGpW8S0bJJIfbA3AihymkZo93U/DpYHDmB3XHt7V3shM2thC7ejCfpFGAGBU2SffE2akQPsBWXre2OJgZeKYmz2inz0OXm
 VkvbNhGz
 vAvN4bxpEnuYt0UBxRx5/QYvJWVwbzv4qe0rKH+G3dTF5cf1l4SS41xiv9CpPx8oz31UmIqkCMV19YZQSscmUfr3ElnaAO4Wm93aDmrhkHyVDBmTFraP1XM0E6pWZlsWkmyirquLeB9Km6uT+M+UeNTbNqMDxQDlIg+MlhqtVTFIGnJmZIIEYpwej1q6NoReldR6VrjkljFe0OYrDrpWn+iD1l1vX9KA304czwMkhGWduxRyZxyR+jKloKpnGH7ZgwwehrsZsBJf8zvCvcVcPvTD1/ImviVDcD0HEw49vROfwoXlJiFvBZW77j9OKmXmRpAvK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

vc_screen defines __free() handler that frees a page using free_page().
Move that definition to include/linux/gfp.h next to free_page() and
rename it from free_page_ptr to free_page.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/tty/vt/vc_screen.c | 6 ++----
 include/linux/gfp.h        | 2 ++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/vt/vc_screen.c b/drivers/tty/vt/vc_screen.c
index c814644ef4ee..d2029f029de6 100644
--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -53,8 +53,6 @@
 #define HEADER_SIZE	4u
 #define CON_BUF_SIZE (IS_ENABLED(CONFIG_BASE_SMALL) ? 256 : PAGE_SIZE)
 
-DEFINE_FREE(free_page_ptr, void *, if (_T) free_page((unsigned long)_T));
-
 /*
  * Our minor space:
  *
@@ -371,7 +369,7 @@ vcs_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	loff_t pos;
 	bool viewed, attr, uni_mode;
 
-	char *con_buf __free(free_page_ptr) = (char *)__get_free_page(GFP_KERNEL);
+	char *con_buf __free(free_page) = (char *)__get_free_page(GFP_KERNEL);
 	if (!con_buf)
 		return -ENOMEM;
 
@@ -596,7 +594,7 @@ vcs_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 	if (use_unicode(inode))
 		return -EOPNOTSUPP;
 
-	char *con_buf __free(free_page_ptr) = (char *)__get_free_page(GFP_KERNEL);
+	char *con_buf __free(free_page) = (char *)__get_free_page(GFP_KERNEL);
 	if (!con_buf)
 		return -ENOMEM;
 
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 0ceb4e09306c..93a6a532f10d 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -385,6 +385,8 @@ extern void free_pages(unsigned long addr, unsigned int order);
 #define __free_page(page) __free_pages((page), 0)
 #define free_page(addr) free_pages((addr), 0)
 
+DEFINE_FREE(free_page, unsigned long, if (_T) free_page(_T));
+
 void page_alloc_init_cpuhp(void);
 int decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp);
 void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp);

base-commit: 211ddde0823f1442e4ad052a2f30f050145ccada
-- 
2.50.1


