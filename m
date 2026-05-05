Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A906BCD3427
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 13:39:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1BBD6B0005; Tue,  5 May 2026 09:39:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCBFA6B0088; Tue,  5 May 2026 09:39:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE1B96B008A; Tue,  5 May 2026 09:39:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AC9326B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 09:39:37 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 40213A04BB
	for <linux-mm@kvack.org>; Tue,  5 May 2026 13:39:37 +0000 (UTC)
X-FDA: 84733473594.06.9E6D6EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 837B4160016
	for <linux-mm@kvack.org>; Tue,  5 May 2026 13:39:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="u4ju/N3J";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777988375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Zww0TlaPNwftxYrUDGORE2fD+OJ2RxOxynq2pm6i6mI=;
	b=m/2DkPQngLX8Pz16ZCw4XZv+PdOGJBL/3RukBjOk5uTD3zqCjzzpgGEKzO3mRwz7FaLs0g
	yPlhXCtf4Cbo630KKK5cnoDXWiKxV//LPYeSM3+dgV/DkHwVFdqkbkkKMhMmYseD3QoCtP
	8AwfiNc5YmLz3CdjtKBr5DgxLQIaQ5A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777988375; a=rsa-sha256;
	cv=none;
	b=h4KgUieYjHDxn+kL6VpyL78ZCUH8XSxW2nJKDwHmM3Uq6XCvj/BvZ2jsFiW8IDnQjjREhO
	zntJy11t5TyoGYZsCNX5bYql3onUt0+YxjuS/OFUF62Huy++LLG7k1bLdrrL4SV8lbBVY2
	Hzc1AzBwYIvUGI6GT3X+6bEyiDZdEJQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="u4ju/N3J";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C471A6014C;
	Tue,  5 May 2026 13:39:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82566C2BCB4;
	Tue,  5 May 2026 13:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777988374;
	bh=yP93zuXO35JzbFR2uaIJaF+ZEOQ/IPJfbTeZRtoTuh8=;
	h=From:To:Cc:Subject:Date:From;
	b=u4ju/N3Je4WfXZbx4x7zuV2kiqhpzgJ2pdsonvo3LwA4my/a98rxYGyA/i9J3HtOQ
	 el2hHy7jyflpq3tf+c5/Bu6F54DSRThQL5yXeaUuIVIy/oPfgzJ+0jdgXtzeell1zT
	 H7mJKg2IJni55kxpBoZ32XMSqtbNcvWauE7dviTNodsUEQ0VrxujP1lE59Psy3qYHa
	 yUXEh+izXbfU8pkeRkvG8Z5L3RRNypobg/YdsPZTu9iWgUeKk9v4bB3ESGRt9wAOaX
	 t+td1/ZECCYP47S68qfO1dZx0iCEEGuTQKcuHtEaDNOmk4GcLE3msdOCkVRRFxXF0i
	 fPi8754ZNHbAA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jeff Xu <jeffxu@google.com>,
	Kees Cook <kees@kernel.org>
Cc: "Pratyush Yadav (Google)" <pratyush@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Brendan Jackman <jackmanb@google.com>,
	Greg Thelen <gthelen@google.com>,
	stable@vger.kernel.org
Subject: [PATCH] memfd: deny writeable mappings when implying SEAL_WRITE
Date: Tue,  5 May 2026 15:39:20 +0200
Message-ID: <20260505133922.797635-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 837B4160016
X-Stat-Signature: kc4xity8jbto9a4n3bjixya1csq5aacy
X-Rspam-User: 
X-HE-Tag: 1777988375-800036
X-HE-Meta: U2FsdGVkX19C7RZWLZNEelI5Rx+H71g+NpV/rQh25VmRva7DU8r9xCXZxJFB2VgH4m8Qybeu3AllaedQIoxnkQj7dSiJIlUU16kZ0zCPZU07MB3/pbrLAgkAX1JGPIgpcQrwCnf4AXYzPdJp9Y/oGiV/vGnfMxoTI5CJ9bArXlCzNOERCc3g+xZYSv+JP4PX+A8xL+ITs6F1Tc0XPag4OATDnjEpO6k570exUWGo+QVScmnHtHA5t59MbWub8TeBjAcKYa0UtbLysEAJIVl80++OeU5jK92Lz0BKjCLbsrJEHmNN8998C8AmIQAPDHmofUrceQ+TeOpqSXkGXF4IrvegV0fCFnRqKH10mH/feaOsIpExw+iZ4KNICFyIUZE3ElhQxrJ2iGfnPvacg/psjQTYcr7DbBJUKqGar7VmXU+vVgW3JKNPVa9rar+wkfMzUVttD8FcfMj9GGA0Hnem8UAmNy8P5Afu1h5eP08aYMcjIFFdyWE6HJvIQtqOIqXtx2A6QczY0r9oQ6tYAkaaY5ELqx4ipfZoWFC6eSkiy3+oQHB+SPciC49h9b07CfsdIX4deh3yKYRJNOBOzT8QP4j9mT8xk6wjHWcXOjgVgkq5Uub4COZJMnuAJc4z5L1KJ3ytV8lnSfPDA3GQnUVD65D+guwvEruQP/2LE9CpoSQekRD1vWIpeWyK4A3vyzSJHbAZr3tSu44aTMaJlw9g47KUPNe6iokDCATcKDjCJdf3LYWVny/eDa1tuq1ATyOkJUfBnrBF6ViV2ClMXDl70C3DlFGZRQ1VQgyqSh79WAlmH8WNMO89EVpNM7JF89+OsjjIF6PHv5iZUEIpvLGBH6h4b+C9qKA1hbEsf1RxvUWW/asNvFMcA8is9PfGU8PbMRSzqToj7PL1Qy8/noF1RnkHLHyQekyfcxmIj/BEXCp7jMC1MBs7U3Ldo+wma4N2JRQjqaMqx8qw4ne/ywH
 I7jMod6s
 +eOnzo9VcuHywQA9ne5FTc8kva1GwBXqFF5pE0D7dynNhmw4utMZd5XjofyVaFxvLXjVuBJWvVYDnaxJfW343KQ/PWLKGPVakjnpBbPXw42EmMtiiJdZLCgKeWXDPlzMDbA9LFFAUdBUKuF7+mpe9GyiztjofWQAO8NpNISTxgq8wzqX9fi7wuQBQBDLjwvlKRn2yH0TjfbvkuH62OgpABkBNAXCR8ltbqqIk94qUP7hN6IJrzJ+/RtUB7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

When SEAL_EXEC is added, SEAL_WRITE is implied to make W^X. But the
implied seal is set after the check that makes sure the memfd can not
have any writable mappings. This means one can use SEAL_EXEC to apply
SEAL_WRITE while having writeable mappings.

This breaks the contract that SEAL_WRITE provides and can be used by an
attacker to pass a memfd that appears to be write sealed but can still
be modified arbitrarily.

Fix this by adding the implied seals before the call for
mapping_deny_writable() is done.

Fixes: c4f75bc8bd6b ("mm/memfd: add write seals when apply SEAL_EXEC to executable memfd")
Cc: stable@vger.kernel.org
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 mm/memfd.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/memfd.c b/mm/memfd.c
index fb425f4e315f..abe13b291ddc 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -283,6 +283,12 @@ int memfd_add_seals(struct file *file, unsigned int seals)
 		goto unlock;
 	}
 
+	/*
+	 * SEAL_EXEC implies SEAL_WRITE, making W^X from the start.
+	 */
+	if (seals & F_SEAL_EXEC && inode->i_mode & 0111)
+		seals |= F_SEAL_SHRINK|F_SEAL_GROW|F_SEAL_WRITE|F_SEAL_FUTURE_WRITE;
+
 	if ((seals & F_SEAL_WRITE) && !(*file_seals & F_SEAL_WRITE)) {
 		error = mapping_deny_writable(file->f_mapping);
 		if (error)
@@ -295,12 +301,6 @@ int memfd_add_seals(struct file *file, unsigned int seals)
 		}
 	}
 
-	/*
-	 * SEAL_EXEC implies SEAL_WRITE, making W^X from the start.
-	 */
-	if (seals & F_SEAL_EXEC && inode->i_mode & 0111)
-		seals |= F_SEAL_SHRINK|F_SEAL_GROW|F_SEAL_WRITE|F_SEAL_FUTURE_WRITE;
-
 	*file_seals |= seals;
 	error = 0;
 
-- 
2.54.0.545.g6539524ca2-goog


