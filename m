Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F813CAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 08:54:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89E3F8E001E; Thu, 25 Sep 2025 04:54:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 875978E0001; Thu, 25 Sep 2025 04:54:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 764BD8E001E; Thu, 25 Sep 2025 04:54:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6447B8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 04:54:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0C63E85CF6
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:54:44 +0000 (UTC)
X-FDA: 83927162088.18.6670E5B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4805340005
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:54:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758790482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=+bHQorvdl2VGsXJwnvdwpUGu9FIfqf8vqwAgG8oXvIc=;
	b=05xERT9T01SQnF8V4t6V0418u3RzhwsuQNfnznaCGq3ff/QpdNo195tcYufsJFvP7j7fmR
	FTTb2G//CtRPUDyVs8q8TAtw4wu6o9SsGf7356ILgha2il76TOsiOzcaqoiDlM+Ot/MY63
	gr4WYIjeOjmawszL/CHtIK90Mm7200k=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758790482; a=rsa-sha256;
	cv=none;
	b=k+6uHeQgc8bc4IO2XbYxs5AwZbqqYkWwVai/9xkdWpkr0hbrg+1AgEZT3UB9Vin/EcUQNr
	sUJPTCTPlDMeAnAF58SvJEtLicuUXF3bMIdW0YM7UHjbjr1QrnrMMzSVYlh/rFTIc1KXjd
	CdMVlznh0fcuEg8i8Xq6MrUiOZwhv/c=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 147321692;
	Thu, 25 Sep 2025 01:54:33 -0700 (PDT)
Received: from MacBook-Pro.blr.arm.com (MacBook-Pro.blr.arm.com [10.164.18.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 19A693F5A1;
	Thu, 25 Sep 2025 01:54:37 -0700 (PDT)
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@redhat.com
Cc: lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH] mm: move rmap of mTHP upon CoW reuse
Date: Thu, 25 Sep 2025 14:24:29 +0530
Message-Id: <20250925085429.41607-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4805340005
X-Stat-Signature: ipiucrtggt4uy1o94ny3cceyhf3auh7g
X-HE-Tag: 1758790482-483656
X-HE-Meta: U2FsdGVkX189CvSkaQC8qo3TbTyH0ZNrF2+qJxMko+HoBZHL3UeBvMH5nAlAKuAmqlt/TsQ0tCKFf/kQuQjaJhdRLXt2ZbHQwlsPlM45S2zNbDKDhIxQKtvpNSvOzaIt97nFDXhacaOkB1zrBBrSi2tpxQ5Zl45ctt11MK6U699Im0Ic7BRCH2Qmp62zEANGz6CP+oywYaUk5/3ciJKRp2t6LysUDaIyQbvyhJ7Dr8qAjWf40Dx4uvCYeZ32XZ0Ben87U2jR2k0PqrQq/fxfhcnDIGfBMVGKrtBOTmxXnYnFuIGSVPLkKvKFmvQYI7LyNMTJFI3Lp1XYc/cG1b4caOX8Ro5iEHBUsNZRYHzOgAS7Sx620HNw413Xc9hcu26KOZOLqaJwVddS5iAf929p8hJy8vupVwOM+md2ITYTaci9EuL8IxbBGowIiTV15senMEF534AO9hNLSnQlOCBRXyoasU/P30g3rTkVwL85AWr7MkcDcF0fI/YrVHrDe4TxT8C6kqSyUlJzZ9QpHoL/ASHL6IvBZy5jAlGnKb36whkg2xRKQNhlwhFsb/oDBbxb2kxq44fZJE4omV2ZxzWJ0+fdaB+u63ZqHHVNY3sUyYCMDCetO0aSDT9OdWuAN5uR3ZTGlcVvuoK89YqeoeoTT2QtyxFls3nJrPsdoTsnnj9eDfPVs3NoYLZERWgpq+veIBU6Lb3LHS8q05pwpqqIh30RkgKkGkactu0ngdu9oGDfrAAbRYVud6UkZzXqnnU4xs9hY1qp8aKzrDXLo3O8RYL980yaln/OgliGZZdKfGYmoNcBdRU6mTUMnui5+jbU+665FAQKAzwyxhBwsKiqhtEs8j9pFqFPrBxYaua1cNY8pk/LQ+T5M/qH1m+HxUt6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

At wp-fault time, when we find that a folio is exclusively mapped, we move
folio->mapping to the faulting VMA's anon_vma, so that rmap overhead
reduces. This is currently done for small folios (base pages) and
PMD-mapped THPs. Do this for mTHP too.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
mm-selftests pass.

 mm/memory.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index 7e32eb79ba99..ec04d2cec6b1 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4014,6 +4014,11 @@ static bool __wp_can_reuse_large_anon_folio(struct folio *folio,
 	 * an additional folio reference and never ended up here.
 	 */
 	exclusive = true;
+
+	if (folio_trylock(folio)) {
+		folio_move_anon_rmap(folio, vma);
+		folio_unlock(folio);
+	}
 unlock:
 	folio_unlock_large_mapcount(folio);
 	return exclusive;
-- 
2.30.2


