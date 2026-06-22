Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D061CD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 13:07:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C1B36B008C; Mon, 22 Jun 2026 09:07:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 671F16B0092; Mon, 22 Jun 2026 09:07:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 514CE6B0093; Mon, 22 Jun 2026 09:07:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C6056B008C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 09:07:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A468840165
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 13:07:43 +0000 (UTC)
X-FDA: 84907575606.03.0F812DE
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf08.hostedemail.com (Postfix) with ESMTP id E50A516000B
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 13:07:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VRA4A8RZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782133662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=z3wp3qDNeLDwzCm9eD9hHpUci3sq6PvJ0QUokiq7Icw=;
	b=G/Utp9/IvFoZ0I+jNMsV7a7+f7RTLCKS2X9eVclV9GYodU45T6wH42yiPM7UxDqfRDS8nw
	H3udQ3uOySVBKPoifee/oU1zY+bCM8NV/qi25gCWrPU8wyz6Uo5NOoYnaIDguMmxJHAqOu
	BF29P2n8d+qopCBczWJXTxdd5oK+Zpk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782133662;
	b=aFEEhGOHQ62C5HWmuA5w7wxXLhHQarV/FoGtVz/p9N2fJSqNswCnUEMS85F7EeggPpzkob
	fO7+NELX29XykebED303n2lbzB701zNoYGJL7bxNRscSNhta7LfnK5cqd7YB6UMlZV8WSn
	PGML/3svvGq07sB/5o7tCGbA3VXTeSg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VRA4A8RZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-69775980397so3708693a12.2
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 06:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782133660; x=1782738460; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z3wp3qDNeLDwzCm9eD9hHpUci3sq6PvJ0QUokiq7Icw=;
        b=VRA4A8RZqd1XSmT3MmibnMKegLtIXmbMxrQW0pJZtPbZnzevPNoeFKL0Lzj7OVROez
         qN1ti6AHf/9JtAEpLcTDpoZ19kv2PnLmKLLMlGkSecC9QqCxFzukpXqLwxlgHwahC71c
         g26Q1x+LRE/XyqJwcYAJyIv3rxtRIocRYYdLIWEHeBOemWuZVxrRTACsPHoDwF9zknfL
         yOzvI5YMTCIkSXIbQjMf9JZ4QZM6BCAJOt5uw/u2YKVfFyrhxSxhVSHN1INrCo9r8sFK
         +0DrYIVqjyz/XpqkhpHgVy3jfV0oXEJSfTtR43OCvYeDHLgbtbWSG1UW6HF0JUf3TyQA
         7uuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782133660; x=1782738460;
        h=message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=z3wp3qDNeLDwzCm9eD9hHpUci3sq6PvJ0QUokiq7Icw=;
        b=TIB/2C/Zt3OxvUwLoOIoGG3dbnT5RAWaWMKsuSVPWCB9+PZJQjoFy02wkRqb67UAA1
         IlSllHry9mR7LYJ41loEjITIYUvATL4BlOZVyxcb09KJiKyaCM/4YueNeh0bh0cYG/dc
         MkCMRFSUp8nCWIrudsRYnFifnsg2yybVeGDsPgaLbPztej6DukbSW3WT67KC+d37IM+L
         j+d/fprNoigIPja/ARcIqRoXcdmL/3DqlZpkbsJD7fQK6G/+74CALYyZ4Vxb/iI598tI
         gWZOfyQu5VNvQqIFypIy6A/mOuYO3XlA+/D561AqXRCBeyIMg+JyUkmp4YFEzarmH80q
         6PyQ==
X-Gm-Message-State: AOJu0YwM+Wo1R4OXO1KMjQpzKgB19Hgfv1Eciy79pUeT79B+fLQB/KZo
	6Rb84taI6Q9A1KbiUW9udB4a4FOXNY7L2yL0RCdeDTvIeZaVjcUdZ66j
X-Gm-Gg: AfdE7cn38XA5Ce94THzvRMN8N6nu/mSrnEOTJYPrmuUP2P5MdG6+6CSqzduKJX9v0+H
	fTTMkq/hrr8peM9aGMxFglR7Oc8aZ5CUJk392+Mz3BlfXpQzrIbuwNQu9PKl+EX5nldMIjm92P6
	E7S+H5M/iaZHPZpc1vhncz02zkpPtoJP5xUjn4+XXWVm0MXLw5NJHPBSjrVwBtOw3z1VyDPLXRo
	DlHsCZsEYTHuHzp2O1kSBSReO8M4po5L4rPOmODyX65Oa5XxVD4FUHNDdLDT/J0KlioGtTW5R7Z
	eWDww/nfpmU14B0y0l8YR47E3zcIxQ6BfQ/Y6V3aMuKCPvqqK3UqBhKtdpfw0Uaj0OWrwqA/cEA
	QgYShTPjNi0UEKDtdyGiQy+4t5m439ouwRjHQv/NCvibfwOuyw/ZJFtHfA5t0owfuwf1P9oe8lN
	tgfpMRRmhZo+o=
X-Received: by 2002:a17:906:9fc5:b0:c06:1310:21cc with SMTP id a640c23a62f3a-c09901dce24mr813472666b.47.1782133660090;
        Mon, 22 Jun 2026 06:07:40 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c0c610e55aesm360917766b.52.2026.06.22.06.07.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Jun 2026 06:07:39 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	sj@kernel.org,
	ziy@nvidia.com,
	balbirs@nvidia.com
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm/page_vma_mapped: revalidate and do proper check before return device-private pmd
Date: Mon, 22 Jun 2026 13:06:51 +0000
Message-Id: <20260622130651.23359-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Server: rspam10
X-Stat-Signature: myby86iez9uz3an1485jeqqgf5mw3ysy
X-Rspamd-Queue-Id: E50A516000B
X-Rspam-User: 
X-HE-Tag: 1782133661-280723
X-HE-Meta: U2FsdGVkX1/UcYPKU0ViWAz+Kk2ofs1TZPesqZaXdwrEImRLQkpk3KXs7NmV5wW1R1TJl0pWECivnwZVhG7c33Tpabu3gbzl/A9sWpoiZkjCH4TNtVdYrIHGI+hb/wPnZ7I/gXFEJWIDhvnyWR+jH/tjtAJmjN76JrJD33AbVi+xK039+xYKtHSbIujfBIkx7SCF5ixIO9jnkVyww4QjLmeB7u7kKV3pc8/3Jta7mEsaq1+Z9IaltLb7NPAQUu+eIAo2iu/O501LGinDpSGKlSapoHMy4y8xbfN+CcHqFF+f5/gjWBTfwE1bCXcx8Ll2cSLwxKRUnKV/j7K6O4y0WVjvMvD57NsIeIdZKea2SDtmyS29Y47asC8GruUs30oxj3w6QlO/eJE5Q4g4JAbDHB0w49wfqeltKOMD0lzfKjtzr/+4q9zazDG17Y6JJrtHwzWgm5wSP28VVpKsabZNYYO9yvGXAavHbKqbh3ATUOoL2ogzow1dYQ3i0uyNP3wtEe6Unst9XwMx7cEfglvVnMcQFd7aP7a2lCK/LjB3cBXjr+yD5bTSHfHlQiHjNfxIBCen0pzfQmvfKImnKEritjafOKmEut16mC9wtu/xMtgvCK6brTmMiM3r4FWzuVkIXQtxs3RdY/xeb7iyD7LBQopdkDt+Pwz8v2A6YjMfqHKSCIVXgUa4Uusu8DxxKeXn9VGQPT+CWznU4s1Wx42kCk/BM5WYFEZyMo00jbEHG/Sq9tU/mtM60bbXI6ekxY8wwqoD9NWPpHkRa3nxZx4DM9p4B7tD7P+HC5t8JJvwn0a/aclHYTQ06n0Rl7AhUXCXvvo3C2XW9QM4i141Y92hma731qXvbyPu62qWEojofg9v0Gg93MHpQJfuBzAfokISMQuccEA7iPiqzI73dSdhP3MdlD+T/J8wOQ+DREGBGF3fSdTtUl+Hr4K6dugnVvC81OTKdmQ2x2cFesdyfe5
 KeoA0In+
 1Qvd7whLRKl5JwzRch1ZuONM4F0boQu+olZTk/vevjC5ce/KZd/RYI82AmjjWfNfSZjBUPrLrlIPQ7KYLCpjpRbrZoAnEMFutc6CpNayhUoigNopx8LsH1AEWIxAIDI+sxo5uydrQW2/C5mKISgIpOO/syK9oZnS+LGHMbp09vtbWkPknb3HO7+Dj7L7xmWuBqrPhZ7atCV5rToud9G7Kqcuyol+fRPq2pAo0SNDmWoahqBw5wJe5CsvZxYhOMAu4hXgrA4uXXlUlKU5EMiP0abjKoLJ5qJg2mu1GaA8OnreJPA6MfRpJ3AqneaRD4kaGYt0gNobAYYDlAxkDlvaWe4jd9p00/zhcXGZQn+9Nsoqbdc7rW1G09D5cp2vsn6r45Pgd+VC154iyLhlG56qkv4mzxKgqxNurGlJ5CD6XPQiRpj5Rnwb8OgEzE7WHfkGIMlMzRW9/pho36HRHavirtLUDfHhniHYQ8o/sKWscRLz9zlmOs9EwFHS2xCAtu4XG9e0bEUFD65AoAKqMvTfIm4HVN1hyyBhTvk5KxTvQ/KKObfw9k5aXwk2em97WVE3GSsCcvEbypu5eJCUCpKUegLUOkYRAg8AQxQeUJdtG17mIAdhU80niSf+7lAnNocflCy01
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For pmd_trans_huge() and pmd_is_migration_entry(), we does following
before return the pmd entry:

  * re-validate pmd entry after PTL
  * check PVMW_MIGRATION
  * check_pmd()
  * handle on pte level if split under us

But for device-private pmd, we just return after pmd_lock().

If a softleaf entry is present, e.g. device-private pmd, the existing
code simply acquires the PMD lock and returns success even if
PVMW_MIGRATION is set (indicating a migration entry is sought), meaning
that the caller can incorrectly interpret the entry as something it is
not, causing data corruption.

This patch fixes commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration
support device-private entries") by following the same pattern as
pmd_trans_huge() and pmd_is_migration_entry() for device private entry.

Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
Cc: <stable@vger.kernel.org>
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Suggested-by: David Hildenbrand <david@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>

---
v3:
  * remove cleanup part, only fix the issue for device-private entry
  * refine user effect description based on Lorenzo's suggestion
v2: https://lore.kernel.org/all/20260616063436.20455-1-richard.weiyang@gmail.com/T/#u
  * specify the possible error case of current code and user visible effect
  * besides fix, cleanup the pmd entry handling based on David's suggestion

v1: https://lore.kernel.org/linux-mm/20260508013728.21285-1-richard.weiyang@gmail.com/
---
 mm/page_vma_mapped.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index 2ccbabfb2cc1..8de3c6b82df6 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -270,21 +270,33 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 			spin_unlock(pvmw->ptl);
 			pvmw->ptl = NULL;
 		} else if (!pmd_present(pmde)) {
-			const softleaf_t entry = softleaf_from_pmd(pmde);
+			softleaf_t entry = softleaf_from_pmd(pmde);
 
 			if (softleaf_is_device_private(entry)) {
 				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
-				return true;
-			}
 
-			if ((pvmw->flags & PVMW_SYNC) &&
-			    thp_vma_suitable_order(vma, pvmw->address,
-						   PMD_ORDER) &&
-			    (pvmw->nr_pages >= HPAGE_PMD_NR))
-				sync_with_folio_pmd_zap(mm, pvmw->pmd);
+				entry = softleaf_from_pmd(*pvmw->pmd);
 
-			step_forward(pvmw, PMD_SIZE);
-			continue;
+				if (softleaf_is_device_private(entry)) {
+					if (pvmw->flags & PVMW_MIGRATION)
+						return not_found(pvmw);
+					if (!check_pmd(softleaf_to_pfn(entry), pvmw))
+						return not_found(pvmw);
+					return true;
+				}
+				/* device-private pmd was split under us: handle on pte level */
+				spin_unlock(pvmw->ptl);
+				pvmw->ptl = NULL;
+			} else {
+				if ((pvmw->flags & PVMW_SYNC) &&
+				    thp_vma_suitable_order(vma, pvmw->address,
+							   PMD_ORDER) &&
+				    (pvmw->nr_pages >= HPAGE_PMD_NR))
+					sync_with_folio_pmd_zap(mm, pvmw->pmd);
+
+				step_forward(pvmw, PMD_SIZE);
+				continue;
+			}
 		}
 		if (!map_pte(pvmw, &pmde, &ptl)) {
 			if (!pvmw->pte)
-- 
2.34.1


