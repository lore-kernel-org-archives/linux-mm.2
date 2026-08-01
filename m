Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7858EC5516F
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 08:49:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 759AC6B0093; Sat,  1 Aug 2026 04:49:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 730F86B0095; Sat,  1 Aug 2026 04:49:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61F4A6B0096; Sat,  1 Aug 2026 04:49:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 404956B0093
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 04:49:07 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BF755C0267
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:06 +0000 (UTC)
X-FDA: 85052075892.23.836918D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3214EA000B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UvYSySO4;
	spf=pass (imf25.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785574145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VDytwlFka2XgteZcjFz3NL9UyNyLHY5oWQiN224IM+4=;
	b=ERclzWcZ1vBF2AxnO5n1MTyEx7ChQHphyNFdLs//57rDb+jv5O1WdpXj60vW1rCDN17Dst
	P+icArTI1aYhyFTgUM2SplMwamZTTG/6QXKYm4+1OmOD/pRFHC018/KPqFMP0gPjmX7yFs
	PgmELN5LtGj5oMJZX1XYlzq9R6dubzo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UvYSySO4;
	spf=pass (imf25.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785574145;
	b=JIJ8vwMQO7dnogkD+uT+9cwyKLftZrgo8qgvhSHChqCj+yDutoMerIWBCq8hDAjtUoi9X7
	suHZa7iIy6cJGhSTOGO05AJuBsfYGHXOKaPI87E964u90Byc4hf4cbxvcPlcZKN+7odRXZ
	sxdcPOAHQ8lez96zcnz0XiWGtNwhPoY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C6EB960AAB;
	Sat,  1 Aug 2026 08:49:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71EDD1F00ADB;
	Sat,  1 Aug 2026 08:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785574144;
	bh=VDytwlFka2XgteZcjFz3NL9UyNyLHY5oWQiN224IM+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UvYSySO4TLvSk1mw3YaXs6jmQOVbFRFdQRu3X5bDfvjRQ72cgybXB7Y3IOblxHo1F
	 muuhq8erjOcS9i06CLCNRSMXr5fM11M5LNNO3WEivU/oXpwhJKQPQmAlt5XDMTuthj
	 YDdyePsobgv75AUTTE9cBkmONcUHRjppU1yp6tbDHTfCK49aDtTfkUtCBdsxYpKolc
	 m6h6ZJUD53xUxpdpxWEU25b0tgVeCd2ah+wwuvlFbteKhpk9UStzbh0levXJI7j6zr
	 Q04Y4QQOy9MVLcUCXNe+Nu8O5i3mDbyllv//Bc90Y4uAIx/NSLUknuSPeABWWwxU1f
	 7u5fDE7yQ8XuA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 05/22] kho: store incoming radix tree in kho_in
Date: Sat,  1 Aug 2026 10:48:14 +0200
Message-ID: <20260801084833.1897543-6-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.571.g244d577d93-goog
In-Reply-To: <20260801084833.1897543-1-pratyush@kernel.org>
References: <20260801084833.1897543-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3214EA000B
X-Rspamd-Server: rspam01
X-Stat-Signature: nttnfke63ss91wf9jbtn43k9khikfuzd
X-HE-Tag: 1785574145-668148
X-HE-Meta: U2FsdGVkX18+lYwuVM5L0UwYJ6LXJcfXE036lS7lu0775mCAiQitKkGz2sAAj6//zydEWZXkGsYjDjKC0eVhetS4nhqt42pYTtz4lT6N6GBFm+kfohaczzZBwv7IdjKuRIbFuOxtQBdpJYyK6lxnUz50V9Y04qg/2k3odi7q2+2HsBQPRhqsKT9x9JJJTUg0XK3BlVE5eQj4vvan9F9mJtxDqh0j8dU5+1oDYVGAtaH/UP0Sn9v1i+hy7+1X+5tBiojlI3XbAjqEjd5jHewr3ZgyWTxd8EHCD+OyopZDKZoxhusxN+q9/vB/Qmn5JQMRNe4tTsxoLQtzAufh98qoqGRvbzI4LpNoZPdXWCII6pn1YHgHGtOkNJRwdjO1lKRpX5oY43cWyneuMlPzqTWR5YdH528Sd8XpJ7/DYzrIcLqS/Ok3ZcmbR5Dgvf5oAb7m4w3eTajSdvD+2f+8LkBJrHFAVZb8XoYeQBAiutzUEDwqalRdLL0WtUIHvMjyyS42gzhA9wVHrd43GI9PoK3hL5ymWI9N9zCjLn21BEk7a3P39DgoHsgf/WoBvO6LriflHYGdYydelxK24iIclYgZfLQ7NcfRaGRLRrznsrfo5RtlYY6q8Epq0Drv/BSfcm1aeXytUz3iiHZOyKRV30B9JUWFfH2CHLU4nCsGQkA2tAED10kQ1CnYRa21SVplu1G4PHhxisER0a7J7B62KoP5eg0djc00/2T9YhSy7umquc74Fd3jePJAheBCp4JhRSHvG9M5foVG4IM6//uIMU7+4T6jtehwNPoVpAAuLcpEqvBt/l3tDCZZwAKaHHvVvgXqGyPfTnK7t/UXm8m04ZbE3AAuj2T/Q8yRexyVZ+8iQ1RTas3zgQOJJc701eGrPR2eh99RbhI2mQk+AxXySSrrrhdGnAC0MSjxo5h58YqjMVQB6lfo//TI1w27IoVhRGqHTbjGjWVIV3m67CYLCGA
 rSvgm7FL
 rE1TLVp6oaUFyXFy34/P+jzlrdlHY3SrfTnC60ax+TcKO+D0gcHNTxXlCL2Y27yp2wDGeCH97qjX04NRSwTXHb3+OSfKc+leYZ518o1uZoPayL3KwEpBfHKXNnz+Zs4chlm3lsmfi9cQ1x/mFEZxXZph/pmbPAkDQ+ghYOkiDr7sJGIjU3K8ynUlJgYSd4Wd5jlxpJ4gxttkD4dL5QQD1eQXVqasY/cAALIlAcO/Z89Ju+RrOxh0wp/YlZ3tzCh5pGfY96+qBKaNouqRVgB6tIgZ4Dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

This allows other functions to also use the radix tree. While at it,
also use kho_get_mem_map_phys() instead of duplicating the code to get
the radix tree root from the FDT.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 32 ++++++++++++------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 5c35c11c273b..b53ae68ca087 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1337,6 +1337,7 @@ struct kho_in {
 	char previous_release[__NEW_UTS_LEN + 1];
 	u32 kexec_count;
 	struct kho_debugfs dbg;
+	struct kho_radix_tree radix_tree;
 };
 
 static struct kho_in kho_in = {
@@ -1416,24 +1417,15 @@ EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
 
 static int __init kho_mem_retrieve(const void *fdt)
 {
-	struct kho_radix_tree tree;
-	const phys_addr_t *mem;
-	int len;
-
-	/* Retrieve the KHO radix tree from passed-in FDT. */
-	mem = fdt_getprop(fdt, 0, KHO_FDT_MEMORY_MAP_PROP_NAME, &len);
-
-	if (!mem || len != sizeof(*mem)) {
-		pr_err("failed to get preserved KHO memory tree\n");
-		return -ENOENT;
-	}
-
-	if (!*mem)
-		return -EINVAL;
-
-	tree.root = phys_to_virt(*mem);
-	mutex_init(&tree.lock);
-	return kho_radix_walk_tree(&tree, kho_preserved_memory_reserve);
+	/*
+	 * kho_get_mem_map() should always succeed. If it fails, kho_populate()
+	 * catches that and never sets kho_in.scratch_phys, which stops memory
+	 * retrieval.
+	 */
+	kho_in.radix_tree.root = kho_get_mem_map(fdt);
+	mutex_init(&kho_in.radix_tree.lock);
+	return kho_radix_walk_tree(&kho_in.radix_tree,
+				   kho_preserved_memory_reserve);
 }
 
 static __init int kho_out_fdt_setup(void)
@@ -1640,8 +1632,10 @@ void __init kho_memory_init(void)
 	if (kho_in.scratch_phys) {
 		kho_scratch = phys_to_virt(kho_in.scratch_phys);
 
-		if (kho_mem_retrieve(kho_get_fdt()))
+		if (kho_mem_retrieve(kho_get_fdt())) {
 			kho_in.fdt_phys = 0;
+			kho_in.radix_tree.root = NULL;
+		}
 	} else {
 		kho_reserve_scratch();
 	}
-- 
2.55.0.571.g244d577d93-goog


