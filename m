Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11F0DCDB470
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 06:55:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3319C6B0088; Wed, 24 Jun 2026 02:55:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E3596B008A; Wed, 24 Jun 2026 02:55:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F9266B008C; Wed, 24 Jun 2026 02:55:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F1B9A6B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 02:55:00 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 69E038CD02
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 06:55:00 +0000 (UTC)
X-FDA: 84913893960.25.D326D06
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf30.hostedemail.com (Postfix) with ESMTP id C4C2580003
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 06:54:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NfjRsGoV;
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782284098;
	b=8ljyis2rmopAeDVEp60VKbKLP3hfZ9T6OIBfuxgzz4VB+Z+wCNFdiyArk8b306OnCCXeZy
	OdmHMMs2SbQ6BFnfLkM8CTS4JUsEreerw6I3CmL8x/0UeZ7M0JO9ZvIqpjZ+BvUx+jQkDc
	0Y/DWcE+I5x0R4CAPGbjhZtKdRB4dhg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782284098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=FgXzFb3dVx+G0VhkHfJ6LeyUsAoRLr+Nz9RsQ6xstwc=;
	b=P1XfyjKp7zaD13TRGFp+BdHcBJzTeM3yydBtM0RYaqD1mzvXx7EGNRI/Dr8Qkbxz9t3ecE
	jIuvZ9QtBuoAcaAxfAQBLfjz2zJRZrNrSioJmILA1yEHHTN7axxHI4yqKpRVL9KUaRC8Y3
	UD59mWIFlJHJYdfcuB8BzKXtyKUFf0k=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NfjRsGoV;
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c07ea058c0cso135835066b.2
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 23:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782284097; x=1782888897; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FgXzFb3dVx+G0VhkHfJ6LeyUsAoRLr+Nz9RsQ6xstwc=;
        b=NfjRsGoVe/ox7ESGSX5RRHARQZPcYb6/Feoez6uRBDXKQmsHOd5kvjFP5VnKBanKEN
         yPHr5wWNI8FRPBcyvGdxU5fkCTs8R63KwE5kIqxJVBu5htm1YzspOL64hcfnqmNNIFAS
         /znn8Lb1F/4vCpSwhaFW1Vozh+LW5siKwQw+uIzXMQ5NbvavuXVgaOVp0rWKxw1IcHiK
         XuYnDn1hHkP2rXTC/UyLnY6SPYcVX1VEj0xhLskrI4X251JwgQSd5d2QG67r6r8mDq2I
         X0D9q2zxXU6dweYhosxrUmYg4SS0UblhWFjALV+U1nW3UtC3z246CCWNS6ekkGT5e6r5
         w3sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782284097; x=1782888897;
        h=message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FgXzFb3dVx+G0VhkHfJ6LeyUsAoRLr+Nz9RsQ6xstwc=;
        b=JD8d/h5YyXfe+mB4K7nHjK5dBvlIEngEQutY+tbDEQSAhDpcaMBs4QCDAExUpTqJS4
         aL0AA64w94EWC9O36bIJrHQApQd7Du89adLBzQEbx8SiHIPp9e6JbPaj/qcQi/IkURr/
         lZL21s+Gf4lccCqxotFj9vgeOc6chk6hRkqDVU5MS/2pxTGnC/3B6Hbxz45w8F6q78ID
         KtxQU0S+tABd78gREMlc2qzwhsey2HAFVAJzkGM/eCGFAYEqSH6XrBTbrv/WHeXljvgX
         J+7J5nwXOWrhdrcrRcF32QeLSMXvgmoqxd/+VWSwWbRfyETnSEcY5j9Y1M9Dtcdaciaa
         Qlmw==
X-Gm-Message-State: AOJu0YxD3bR7UUFDHtUMYNVCbFtk7cMB+viZAhSDhvdJJFy2szMmBy6d
	ABekqkzzxJO2QqnuZ6tzjdaVvR42ZbDyWlmlaOfeVf3/OvYuUOaWXsq0
X-Gm-Gg: AfdE7cnrIBOG2rir/hMKqH9r6Iny3OfzAx3rqXM4468Y4iwAqGWkrswRbQgz24NdSMI
	KTAti8pEa4FfSA7wNqp7H6/SxInFwU/1ctMtbk/+SzwL0O213WJr0TwSsQvc/vpj518Wo7OIzw7
	skYCRuGMTaoP8QiQ1RpgCabO+Ah+qwP0Oh2sNRZVNnoInQjoW2iF/s4tYqLF8jgWXmD3hl40yJa
	OrI+QIAU0905q9C1Wt0NgUXsL/PZjFhksRV4MHtB/rjx0XA9u0KijZ+DwY8bF8kNDae653SgK+b
	A1bLYiSFiaa7XZaC5Xg774TrQ0Ys4hHpxfOIqH1X6M5tptGOAuipi7nWC8vrT3cYkr9tCkhIkQZ
	R1irxB6ak6PaJ5stWf9N0ZAiKoNjEJoj+9XDfGK5+HV8IP+qeMvA8js/cQ4uEeaoFn4ygmSPgJE
	Iz8lYXZvlZrlU=
X-Received: by 2002:a17:907:e895:b0:bef:db4:296e with SMTP id a640c23a62f3a-c107d00be34mr326784066b.10.1782284096711;
        Tue, 23 Jun 2026 23:54:56 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c0c60ac98c9sm606560866b.29.2026.06.23.23.54.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 23 Jun 2026 23:54:56 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	ziy@nvidia.com,
	sj@kernel.org,
	balbirs@nvidia.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Wei Yang <richard.weiyang@gmail.com>,
	stable@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [Patch mm-hotfixes v4] mm/page_vma_mapped: fix device-private PMD handling
Date: Wed, 24 Jun 2026 06:53:53 +0000
Message-Id: <20260624065353.1622-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Queue-Id: C4C2580003
X-Stat-Signature: cot1y84uc64tiipsuubzhneb3anrpd7b
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782284098-452689
X-HE-Meta: U2FsdGVkX1+sWmCZa5Tv8UKpVVg6epaBPBo7CxT5o1Ys48gFhZ+vwbxZapaKAOqRm90jy9cdnDZ1stvODZ8vQKbdc8YPCkdDCTy4K7Lmzofg1+fexn+lH2aFlL8EM5F1a9iryuBu4oPAA//OGJtCi0ApqsaZRtNXGMpiyJHyOBiwdtafnM7H5mXwGSXf/F/IUrN8HUR1HVieUksAkjzdBe2MY6C2ZEKCuzwIl5l/tpV9cn9OsRtvMoE04+0RReC0CpSwERcIKN8l8YTUC038InChk6RQJRLwZzvHD6HJgqzKn/8CI7Dl3qRsP71/BGyqxqGUFKXkzPp0SiPgcE5CVhOdGTGV0pFEk+m+SRMKeFyTG/1i263ILmHkujucXOplgWjBIdwKlnBeeZf8Kaj69w5+MEU4WNz14kcvwFX1uI7+BSYmO0J08m6TlEXCJCssaLFoSeNnmJFTByR2y00UsO60oigHoCjXAwA+hVsRfPXAXwOLxEIAk3/0nBwJ5rDlDcPi7CpmuxDO9+n/2fiaJ7D4oeTSHfzij5ARAEi4MOLbSIn1xQdL5nwsRtkWIJKGFc8VAV1s9vrXfoLrq8XW6ymjRDa25zVFk/yyUMJtO6vlv5myG+9aWAK1p/V4RV6/Yrdob6RZ2adkQHASowtVrEsNi7FnTzWMDvVeOw4ay2IzTaNM3sAWoH+GuKLbKBMGUmW2anPhbpoJ4gZiTAp7wcG5E279fge3ZAUTZVEQl3DY9felsyYd3l+K+bKnv9AtHv8xCb7yi1988o/hAI6kSALyvL9Idlaj5Lva8jFr2KYxGBCMuDsgWXUYHe2lb7ZIwHvUaoQkH4Y8us1+fjdvm78HObtQ7UTFavd8Ej8UE4Wo564Hd9sqOETJVGDOdwyRXGcuKY9wsqKUGOcOgCro9gU/T3PA3xE3u/ql9CpzwITcMmvZ84cjvNNwLdSr3myoM5jXIcZvBX17vnQVJTA
 bgg09l9s
 eG8rGzhTYGUB0jDZm2Okk5ljIGme4UesL4f2zOgXjgaeQz/p7vf7hJ1VPkio3sknw7tuOtpn23eyKLYcKYWbu9BMtkcfe48REuyDnbqpcsC+6jJdiy3L/o9706ay9K2kQEJyiZwGnPc9EBoGfkpUxYYPpwZlpeIddblpLcl1KkEPnDpkHQ7tfM8GINKPsGJMrMqVbOjSlJe8euLpMH2Ug/qq/Bu2HHcvoI8cYB8nOdrqJoAxLnrwY8xv0He1ORy742VSGIfvMZEWc7RQQ0gWfVzW0yB+UDLyJEMjsK8S0t+SgsxaF5tn9qE23YFQjystmkIomMChrbG2X6yeifx5cykQ3ppvbIqAZocFMGBT0fYfmwsHvcjrIyU2wYQ1KA+h0rdpdxnR27cQ0QSaCMmHn//IQgSK8gux0AJEgwt02Ga4Z72yte+oysJDSd974QCq78xkRG/drXusdzWDk4rfqSpX/JtBNJV+5zrgJ+8SwfMRoL4ach29db5EMt25O/NWfW3B/jfaQRlXDoJzRUhBHT3pMsYy9AcrdrVe21nrpyt4+SaBuuno+eZIKrnKuzFHKgrMdVarmjSInayvpecNC6rU4zq0Y+B3kjvWSXPKV9q319NZt0fM7kjoHjP/2K4dIzTYB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
device-private entries") introduced the concept of device-private
PMD entries, but did not correctly update the rmap walk code to
account for them.

As a result, when page_vma_mapped_walk() encounters device-private
PMD entries, it takes no action other than to acquire the PMD lock
and exit.

However this is highly problematic for two reasons - firstly,
device private entries possess a PFN so check_pmd() needs to be
called to ensure an overlapping PFN range.

Secondly, and more importantly, if PVMW_MIGRATION is set the
caller assumes the returned entry is a migration entry, resulting
in memory corruption when the caller tries to interpret the device
private entry as such.

In addition, commit 146287290023 ("mm/huge_memory: implement
device-private THP splitting") allowed device private PMDs to be
split like THP mappings, but again did not update this code path.

As a result, we might race a PMD split prior to acquiring the PMD
lock.

This patch addresses all of these issues by invoking check_pmd(),
ensuring PMVW_MIGRATION is not set and checks whether a split raced
us we do for PMD THP and migration entries.

Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
Cc: <stable@vger.kernel.org>
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Suggested-by: David Hildenbrand <david@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>

---
v4:
  * refine subject and commit log based on Lorenzo's suggestion
  * put pmd device-private entry handling in its own if branch,
    suggested by Lorenzo

v3:
  * remove cleanup part, only fix the issue for device-private entry
  * refine user effect description based on Lorenzo's suggestion

v2: https://lore.kernel.org/all/20260616063436.20455-1-richard.weiyang@gmail.com/T/#u
  * specify the possible error case of current code and user visible effect
  * besides fix, cleanup the pmd entry handling based on David's suggestion

v1: https://lore.kernel.org/linux-mm/20260508013728.21285-1-richard.weiyang@gmail.com/
---
 mm/page_vma_mapped.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index 2ccbabfb2cc1..17dff8aab9f9 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -269,14 +269,24 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 			/* THP pmd was split under us: handle on pte level */
 			spin_unlock(pvmw->ptl);
 			pvmw->ptl = NULL;
-		} else if (!pmd_present(pmde)) {
-			const softleaf_t entry = softleaf_from_pmd(pmde);
+		} else if (pmd_is_device_private_entry(pmde)) {
+			softleaf_t entry;
+
+			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
+			pmde = *pvmw->pmd;
+			entry = softleaf_from_pmd(pmde);
 
-			if (softleaf_is_device_private(entry)) {
-				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
+			if (likely(softleaf_is_device_private(entry))) {
+				if (pvmw->flags & PVMW_MIGRATION)
+					return not_found(pvmw);
+				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
+					return not_found(pvmw);
 				return true;
 			}
-
+			/* device-private pmd was split under us: handle on pte level */
+			spin_unlock(pvmw->ptl);
+			pvmw->ptl = NULL;
+		} else if (!pmd_present(pmde)) {
 			if ((pvmw->flags & PVMW_SYNC) &&
 			    thp_vma_suitable_order(vma, pvmw->address,
 						   PMD_ORDER) &&
-- 
2.34.1


