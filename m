Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA557FAD3F9
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 03:49:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF8C66B0005; Wed, 22 Apr 2026 23:49:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D83AE6B008A; Wed, 22 Apr 2026 23:49:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4B6B6B008C; Wed, 22 Apr 2026 23:49:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B0AEF6B0005
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 23:49:29 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 38212C1B78
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 03:49:29 +0000 (UTC)
X-FDA: 84688440858.14.AD29E95
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id A063340003
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 03:49:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Box8lWd1;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776916167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7PaKaC670Hp3LVutSNXYORhFj1gPg6ub1Uruassy2CA=;
	b=Byt28r4hLBYFfey76SagOUG3WY8zsXDur9NxMDBulzDu2O7Zs/g3+6ZT7DuMrhKoTgnvgf
	nio49yX4RRs3RNnpr0V+aay7g6h5aCSFerfa7HHnOd9S627S8rLJTOwFy9gfLrT1wbhhop
	M6Y34O0O53kEbcN8yFl3ujA2filP/sA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Box8lWd1;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776916167; a=rsa-sha256;
	cv=none;
	b=xs+X5RSB+vhnqRcgF1Tz6C/gREy6uw37QExVB7lkfp/Zax/0kA6Wk7sf2n7RX7TLaw+fs8
	EP2utoCc+hVNDnkFfQO05Uuc2eGIawJc/w3gWt+AmxfwAzo+1Ozthu0frizrNW7Lc/YICD
	tIJzqnmkK/L8b1mVOcEzw/z5+iklLkQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CFA2560008;
	Thu, 23 Apr 2026 03:49:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD14C2BCB2;
	Thu, 23 Apr 2026 03:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776916166;
	bh=bmU+ipTDgo8Yb73l8Rsll0rbHOuXNPxzYHiFb0POzww=;
	h=From:To:Cc:Subject:Date:From;
	b=Box8lWd1nUR1kOkHZy0puKvCs8XzgT9MrMC0xhugU09LYn0+k0MFaVqS5K0VtE54l
	 niQ3j44LggsoEJiml7x9jfx7JP0WeATZx89eottOFM7537jog1K0HNRP5FBtNNAFjm
	 f8/TemgT+eXxOj81rGRJlRuT9la+6q/EMqPfHSRlrYe32RWHjmVsZZxNYuIFBPMfT+
	 OMmcDlhA3XrZaTB/PDI7Apn1bkbhN5wvodQvglCyv+jmPObT3stwuOfY98UbjvSVZX
	 EmCEX6ZMcTZOYbH0M6VB1VlBN/Dg9PailqO+i8jgOhBUR1xNB+ovWSqtpm2ZgxT3En
	 7yeAMrF0BagTQ==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	"Barry Song (Xiaomi)" <baohua@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Youngjun Park <youngjun.park@lge.com>
Subject: [PATCH] mm/huge_memory: Fix outdated comment about freeing subpages in __folio_split
Date: Thu, 23 Apr 2026 11:49:17 +0800
Message-Id: <20260423034917.8234-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: x36j4q5bm4j9z6mzexgru8ngyusfoz66
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A063340003
X-HE-Tag: 1776916167-377448
X-HE-Meta: U2FsdGVkX1/3NJ1TW7p1gAb9FSOHSIpB1YP9NEQvA+ddkMU7X8D5DWNfxO/Lcr7HJdHneCqOYIH6M1N0Mz72kR8PqAp7Ot8KuRXnBHNFqXFGmZz3O9gNCNap/089qYbNxuVo4m3WLoR7U5X6sc4hC2modFeglT0KGYoEjGlhnmQcAFG90FhI3vOJYwKPBbl8Aqm79RD29KZIS+iE6OVyLRubhDTEGjM25c7GenrH+zL/aRAsEuugC1LHfcn5uxws4eNxgiLPMYr5SU2ytUieJyI0X80Q0tHu2tJ9UNQYLybNgkNKoBkvGsD6CRu+DyvGbJChaH+6GvZ/frUyJmj3I5uYZXF2nlTBhsiZZGJE0WIR6g7pWYH/1rFniWi8V/VwWxNHwz0Ccvdf2u150S5VCZf/JipNVssxODXKtE8QZsEiVWxm716F/cDFZIovYxEkkkffc9h1e4A714WPMxouIJ+vt/dfX0MMMOZZ6iq9hZ7gaQrQQx48FqeRClVRCyGsVxcmiRi76dRjAahk22t/crIaJEekDa4syewX/uff1wLlPIFWSt5G6qd1KsjFPB7RZmQxwc3TBJ5EozaxhNqDCB4CALI7Eyqy493UeJLoaMBX9+r2O9Up2IvBtSRbWgbqRat0zpG6U27Yh4j1ky8gjFq6LdY2LS0//TQwD09mnQ8jrRt6IegOhR6jHBUl9SW9ZgdiVUXruBzvbVXNNEP4pzAnrO8Y0tyc1vX/NmHOZ0OyazvjUnQ+WQVj5Lf2LVTEncroV0nqyHlBLUoBs1722Nv6lsM1PIEM/KX+VQEI6P5eBd9yNOeTZ5U4rUbjOZaCBkyJhzFJMcLNK19pgLn6VIzGg4e3uq5rHZL1RonVgPt1QTzb77Q+/D0rEKMz6bfo3+DiDgUgWksZSpte8QQNDnbpveimi6picgu6/lErliMKWjMNFcWBGfeFWmT8X/l0L1h9YuUm2bTqxhrY9Mt
 AKgpIdCP
 +DKfNJPBnWlkS49FZ2aEZY+W9WkSJ8+Kc5QCaeULm25NBR/gR18xl7qgIcIvOhKG986I1LCuyFbIecSqDYmwgNvXzNDF8dzczrCuraBj3781D6Aozn2yj1WOmSPm0d4DxRpAGIucdyGbekSmfbz+C8Pc63WEktAqi6fLUBEutQqwq4Q/fi4PG3iSbYsJgoNQXi+zby/n5t/SCy+bYIolt/0FqZOtV6KSiy+1z/tl1e2R/kHAYLm/rMaam5lW+Zz3iHBDMiUaY9IRvKVPkNW2LF+WJ6wJiMRGfbAhC+NNgSScNHS9IxH3aXO3zB497VHi4S0GCaED62TEvpQ/7wT2NLi74jUxdU6zm/9vo02EEHSL49zStAcajxM34gIE1oC7FJYf8y9FdS/CDVxKK7sbNx8yfGsDNaH2V3sLr/IgCwZjeWJva8CXeUzo+lzJF8MKNvFmWeCiuWQ1roRMSg8T8F1HNkxUg7qtnIlApi1akc9X/pkzqCfWrVSDmI7yqidOean8Pfrldxh6LYwEUgCgzvSDPnJi3U7P1J6RuKESrVtHmRQybTPm9gL5v7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The comment appears to be outdated. First, add_to_swap() no longer
exists after Kairui’s commit b487a2da3575 ("mm, swap: simplify folio
swap allocation"). Second, partially zapped folios are now always
split before folio_alloc_swap() to avoid extra I/O, following Ryan’s
commit 5ed890ce5147 ("mm: vmscan: avoid split during
shrink_folio_list()").
Fix this by making the description more generic.

Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Youngjun Park <youngjun.park@lge.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/huge_memory.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 970e077019b7..4586f3ccb133 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4190,11 +4190,10 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 		folio_unlock(new_folio);
 		/*
-		 * Subpages may be freed if there wasn't any mapping
-		 * like if add_to_swap() is running on a lru page that
-		 * had its mapping zapped. And freeing these pages
-		 * requires taking the lru_lock so we do the put_page
-		 * of the tail pages after the split is complete.
+		 * Subpages whose mapping has been zapped may be freed
+		 * earlier, but freeing them requires taking the
+		 * lru_lock, so we defer put_page() on tail pages until
+		 * after the split completes.
 		 */
 		free_folio_and_swap_cache(new_folio);
 	}
-- 
2.39.3 (Apple Git-146)


