Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAAB5606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 21:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oZKP33Cl
Received: by kanga.kvack.org (Postfix)
	id 42E726B05B5; Sat,  7 Nov 2026 16:45:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4062E6B05B6; Sat,  7 Nov 2026 16:45:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3434B6B05B7; Sat,  7 Nov 2026 16:45:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B4466B05B5
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 16:45:43 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 94C771A03EC
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 21:45:37 +0000 (UTC)
X-FDA: 85409655114.21.0771267
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id EF538140003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 21:45:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oZKP33Cl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794087936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WPf2icVK/e9KPEuHFkG431PIxwdSKi/zxFeSHw01Gc8=;
	b=T6dv9vHM+LabEP9ATNjmYpg+mPJYSbFGJVynOWNnsIjspmT877u57/Ivd07vkue3Hyr/6R
	RctccErHwfn+mG1WGnD3PK+HjTYoHIzSLeWNrrQarBUzVVl2loVIEksYmjmqwozrnKNXdd
	V+rr3AJy25tuSDahBxq5a1mPxKEzyEA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794087936;
	b=abR7+Sg+bfr8uTa1lPVm2PovOTpayq8/PiqDHddM+YGXjQUXvLA+c+CK9HXmK4mVdHKlac
	r6f9CefahYLvHsw//VBnTaBPnWUUFotJVrE0NB60nZ4kFj9+E6AVaxzknmvwOEMBUwbury
	69KZOl+tmoZPHqYMWr29baX1c7V6kgc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oZKP33Cl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3FEAF4465D;
	Sat,  7 Nov 2026 21:45:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D01531F008A1;
	Sat,  7 Nov 2026 21:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794087935;
	bh=WPf2icVK/e9KPEuHFkG431PIxwdSKi/zxFeSHw01Gc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oZKP33ClNFoSGATo0q5PTPN25UDr1CaEy9FVsDI//fftn/U6S1OkqegWFde7R+wZ3
	 loW/lpUpE0rMV5fwDFFGtNzvdSoxyUXb9ddSvQ+q/1mkMsdUfbIyWK3W3ql66P/fJN
	 bwGEw+jGHG/RiR3ICsvqqK2IJz35FgjhfgJz+Ws+BAYaMBshWq9MFSivQc5hwcbqxA
	 0Rz1CC1HzXce9xlIeUzij/vABIwGyeWo33PV5GSKFw7I9J+JrLSTLiv6rDdlS5rkne
	 WUiGWRp1IzZHIqCYrkQx8EHjBoBG4iw/8IJc2uvBgM2jb0BN6jcZP5Bl6eIyOMLX1g
	 l7YOmN3YWjJ6w==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6.12.y 2/5] mm/damon/paddr: respect folio end for DAMOS actions except STAT
Date: Sat,  7 Nov 2026 13:45:21 -0800
Message-ID: <20261107214525.304638-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261107214525.304638-1-sj@kernel.org>
References: <20261107214525.304638-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y6nswehoehbfp7amycehami9tu9d1gk7
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EF538140003
X-HE-Tag: 1794087935-272580
X-HE-Meta: U2FsdGVkX1/6uM5FJPe+kObP/aR3RBunSRbQpv8cVrCbHeCiJZ5WBpwR/RkHQm3QtBsNiqM3KCB9YFxAOXEzDf/AZsxp+hyQuZVfSbBAXEBVdf6SV1L8ZmvX5TspCQW1riqs9VTRVNzAr7nPaqmdrvUlUVylAg013tba5/FlhRYi/o6w4kmotMhIB4mmcft6N18MSABNDGYwQ21bzQQxOOfUE9A6j3Zl3itvsHcSIiHfRdHD9i6LdXEDnRi+Y13D0DJqaeSdBRm9ukjnozFRpCM6sfbDoQVBVGk38BmyPCIYGtF9LFqdJFRnZ2+FTI304mUFD6hOOTAThsvPupwkWN9v2YfyO+2tze0Z8F392NDj02MipgvyR9nOpxcGcIRogYPa1MdyStIWVo70ij5Ed6U59nuHXUcmuFNyw43owkco1ae4SkgbOvXdkFu7VE6PlrHjBz/GmrJG/CeQsTO0keqyDLWl6dlejaM+8Ww68U8OPsvPEVOEgzv9NYRykptq5/JYaXz8J0HdcesS2w2NGbN5vPUPu/GXGaJx77GGdDH7wRwC+/AGC+ptqEiPk2D23qclu4FMn4QFdnhTPsnlfr1ShLAbbXAvq6pVW8AghtaV5ReiMq6QteSvnZoUZ6kx5E3r+JP0+sMkFSnOd4vCebZ9q8adft31w0FTxlUyfdf5wFu0kAE1nwIYSzkharymLHUH0PqIfMqL5cp+15vzV9HiuKMTK9S5gBGIbN1A8e4wIilTaZGD8xjdljpBT15k2+TsCn2vilwFhw9iygnLNv1HQ8EhTPuyVRceDpNftEnIhBU7YQiUlO4Avtwi3XztqUHpl6pU6sgBIUovKdMfbcLkQjceBSJTT07Pq89vi00TFXYpIKQxotFrEwwHw54aUkR7MW8NHMOKN9qel3LO1DOqEL3ktUpJR+W6QP22mwiJ/NpJ/9P//0yQsH+NPSmZ4q88jbxrNFqZ28OpIYO
 TLgX7dmi
 xq1ooKFhKlfYEcZrdm2vdlndPpME5mvkGqwM8MXeNyWBVJl3iDAHUNGOGT7A9WQTrpLAHr3NFJKfVHQ1AoCiLb/UXVHJbV2MCHI3MwFwda8laLFhD9IH+2xZYddmLGKjdAXO1Efn8dRHNRXJB0tYV79HML21d4VJe2X1PgCDIGRPJLythFS2SFJIWLc+2oU7i+4MR76jzqQiU4nofPLletd7M6KGizREFVGHdDvrx5X/E/CqhKlMQvYKiWowRTZkpG4agaGdXhpt7Os/8xMAKO3OKh1XZ9weLh71el30YTNDBw93w9F7Wteo0Tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A few functions for applying DAMOS actions including pageout, lru_[de]prio
and migrate_{hot,cold} in DAMON physical address space operation set
(paddr) collect folios of the given region by getting the folios of
region-internal addresses.  Then, those functions apply the action to the
collected folios at once.  The collection starts from the region start
address and advances the address by the size of the folio of the address
until it goes out of the region.  If the start address is in the middle of
a large folio, and if the next folios are small, some of the next folios
could be skipped.  Fix the issue by advancing the address to exactly the
start address of the next folio.

The user impact is that DAMOS action is applied to less than expected
amount of memory.  Given the best effort nature of DAMON, it is no big
problem, but it is clearly a bug that is better to be fixed.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260901131850.98037-4-sj@kernel.org
Link: https://lore.kernel.org/20260517234112.89245-1-sj@kernel.org [1]
Fixes: 3a06696305e7 ("mm/damon/ops: have damon_get_folio return folio even for tail pages")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org> # 6.15.x
(cherry picked from commit 1613ac9edf385c35f171a25610e2706a7e6afad6)
---
 mm/damon/paddr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index a6b1de97b1e8a..6bac269cd679e 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -273,7 +273,7 @@ static unsigned long damon_pa_pageout(struct damon_region *r, struct damos *s)
 		else
 			list_add(&folio->lru, &folio_list);
 put_folio:
-		addr += folio_size(folio);
+		addr = PFN_PHYS(folio_pfn(folio)) + folio_size(folio);
 		folio_put(folio);
 	}
 	if (install_young_filter)
@@ -306,7 +306,7 @@ static inline unsigned long damon_pa_mark_accessed_or_deactivate(
 			folio_deactivate(folio);
 		applied += folio_nr_pages(folio);
 put_folio:
-		addr += folio_size(folio);
+		addr = PFN_PHYS(folio_pfn(folio)) + folio_size(folio);
 		folio_put(folio);
 	}
 	return applied * PAGE_SIZE;
@@ -483,7 +483,7 @@ static unsigned long damon_pa_migrate(struct damon_region *r, struct damos *s)
 				folio_is_file_lru(folio));
 		list_add(&folio->lru, &folio_list);
 put_folio:
-		addr += folio_size(folio);
+		addr = PFN_PHYS(folio_pfn(folio)) + folio_size(folio);
 		folio_put(folio);
 	}
 	applied = damon_pa_migrate_pages(&folio_list, s->target_nid);
-- 
2.47.3

