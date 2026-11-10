Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F747606A334
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BpmD5XgM
Received: by kanga.kvack.org (Postfix)
	id 42C096B05B7; Tue, 10 Nov 2026 07:32:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DBF66B05B8; Tue, 10 Nov 2026 07:32:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CA1B6B05B9; Tue, 10 Nov 2026 07:32:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 063056B05B7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:32:31 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8DC8140223
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:32:31 +0000 (UTC)
X-FDA: 85419147702.18.E49E1A3
Received: from mail-pj2-f7.google.com (mail-pj2-f7.google.com [74.125.227.135])
	by imf08.hostedemail.com (Postfix) with ESMTP id BB0B5160011
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:32:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=BpmD5XgM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.135 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794313949;
	b=i8pqyeA3VcrBRPycDtole+L6zVC4N4WGlkZ2+e51oJhZAyI9bFnbJQCP2x981xXHaeNf0z
	nVWYI+qhgPp6SCkKT41zArFKIb1qx04B12QNAXqZKxEjCELcrT3i04Ekm55dhRjxBR0teY
	eEoAaQvdf5pmcFLVOAZBdeOVZuZvv9E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794313949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lmxqKZZVg8hW4bTmhQL70087cSnpYuyKRLOfUsTG3fY=;
	b=lGQueQZndDhfg4GnqG0qvmx2pwneDUHw/kOELvKaLyXupF5I42qxvDbpe4h5UTH1Dvzvm2
	4Frenb6UPbV/IFMJD7rlbi7BFdtbILV8NBSZC2FV3h4eVdzxZSLNtAV4DfdP5t9AxW33AZ
	B+0RgxXCNNhlgyKxwXzxxV33lieUHu0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=BpmD5XgM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.135 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
Received: by mail-pj2-f7.google.com with SMTP id d9443c01a7336-2ed14ad20b8so9617775ad.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:32:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794313948; x=1794918748; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lmxqKZZVg8hW4bTmhQL70087cSnpYuyKRLOfUsTG3fY=;
        b=BpmD5XgMCpHwG1VUWORp0vvaAjOSzZfTDUdDBbCt51t51CvaZCaiUZKsWOhtTnLgtR
         +HY9dAGc/EjEuW4gXbeRaC3FomHAzQwAVfulgELMBjjMTr8iZpXpCCoh250eYMYRWROQ
         sudRHuT6725DvuhPXVffxUodbCljYLe71NbUSX9ixdOYGiOMThBIUGHlO9wC29Wb7nZC
         FB2cevw13JtZ/rWqL05uL50UQSNqln/78lH1mjbPsD+4RZH3VuHNqYEAAvWydNSGJ6kd
         SsjUEpJR0PKTJl0PmZxJj1qkXEqDKwmnCzzNUUCdtdu923kioVt5uz24gWvdWmSHQnv4
         l+zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794313948; x=1794918748;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lmxqKZZVg8hW4bTmhQL70087cSnpYuyKRLOfUsTG3fY=;
        b=ZSmdWsMoWh2sEPyt9+GHUEhSZ6VTMFPwYDRFkukLhfeDY/h7JKecSRqt07jwgGuyEk
         dW3uoyBPxl+El6NoQf8DZHS3+P8bvgA6t9mgN3JSzlCM+6Sao/mQtSTJ/YOw+z2YfoL0
         WtC9I4TycZXGDLwFbg4kr0n1CDceO7d8O58mmZmu354LfaVPePmwD8oAo0xuAVBkpSxr
         8FJ+XZMbEQPaqsdunuWo8PVG0B8HCR29d4TnhYptFSys1AiVPqWiUurTTptFSDLuSjss
         o4JK3RptGaGfrNbT5bvVc+P0ZRyrs02sXPOHVCwROi4FtcOl+XUrWM2e6tYGdT+/Bl30
         T3gA==
X-Forwarded-Encrypted: i=1; AL+hErGkayamzrAzn4ZC/9zWM6h4Uab+w1f4e14hMTqEKDOTszNY1RkwLpLTK05vFD41Y6HNILkmmf/L2Q==@kvack.org
X-Gm-Message-State: APuU4Z+4XEc6aEC38HDGjgqvqA7EiPztXKeGuEGhjP21sy3jGnEqfFmA
	gnj+/1dy1DH29FtbqWWar+ICmBa3kCdS8clSaQmCho2+zEUOckdDI11V
X-Gm-Gg: AYBFou3UNyWSRugMok5WybUm6Dy1Do+IGvi/hEN7fBiGGChUpv+obLcXw/3xHo506Oj
	KKBtzgYk323YxNsUbX+Lnk/g8tl6dRct7J4mkNe9wWzYDEjQoyDxPYMr7UA5w8+kNvmfPrsoi87
	neWkovh+WczupBL5ToI/TKf4cOCeQS1guIXkiVpq8G6/TePz7b/nM5d7/BGaazJa2NizTHcKJ7h
	rd0wa+CbdltS+GDyN6tRulPCxuM2BaSc364AXlzk6P4RWa+V9u7hieRQO55jeldHSL4Em8K9ZOx
	v3O95BuLo6ba3WOuwT0oMUx+w5fmLvxB4Uqp4TWzNLolJUAQrBI0+Ewq898spd/vl1gCWn+BtxL
	pWD+Bmuty+12EAybTPKu6GzRzAVoATficoo6k4MZLPyUmEjM3iOeGO6FymJX59ygAmPKyvoyGfn
	XdIGQtS4c3BaVDDQjj4UvSiinNBHlg/nhNzlBulaFGm4V8k/7AFZ5MgFUIOhHIO9bH1nxLWAWaD
	RxDj+GF10Ld4dwRQqkfw2J7eNUw0pisVJJz3zC3hh5Doz0JI23LtJqoSR1P9CU6rTL0ick4cr6U
	BP5jCl+kkyn2aTZpCMtj5xtUQuARgDodUiICKNchpg==
X-Received: by 2002:a05:6a21:3d8c:b0:3de:79fe:13f with SMTP id adf61e73a8af0-3f18efad460mr1762586637.38.1794313948383;
        Tue, 10 Nov 2026 04:32:28 -0800 (PST)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baa506bca4sm815282b3a.0.2026.11.10.04.32.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 04:32:27 -0800 (PST)
From: Wandun Chen <chenwandun1@gmail.com>
To: david@kernel.org,
	hughd@google.com,
	akpm@linux-foundation.org
Cc: ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm/migrate: improve mlock tracking for PTE-mapped large folios
Date: Tue, 10 Nov 2026 20:32:18 +0800
Message-ID: <20261110123218.1579490-1-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BB0B5160011
X-Rspamd-Server: rspam12
X-Stat-Signature: xgjw91u384ymghzyfh7e44qr3nja7da1
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794313949-160054
X-HE-Meta: U2FsdGVkX1/wqx5dqi01J0S/lkd/dd2q++U/VTwSqccYcYutIL3qkO0QTX/8Qy4yVuoN5LrgGP/DUjxdVHN+eGo2n0iav3FZj6VALtJ6F/0E6s8RItiPQ30ALIMJZKk3/cw0kYaBGTm/g9b/RwtvI/O31ufe13pdWEsQxPAOSrXrFlC5mqY1rlW7DqdnBcsI8vdM9W468lzY48SVPzx6wDCryk+TG78Y6ugi4iNKaEf97O3uZ2LKrw4u2E/3FeWolZlFEoECIYJ3V3a+MRYb+ja3iCr8DFcSmKe9EA5pfU1I8YZPdhz7co/5LCBQ1yCMzADiUcdOgQ1gqUpFXMtpo6L6OZwW9NOXdTguq6BKr2E6Ss3j1aVPm770OJV397OVVGNbDMmMJTuGNmb+xseihgrtS7eDMZL/L/xVwm69mUkNijzRcvBM8rtr3zxYuagY+XGaux1zT8qhxCrgmLpIvUEt8TdYQPnFat6WkilMz9AnBR7LmgdMulchDPwCn0JLVrhnaioSIHGVZO97xjLGdquniLE/ybv1LbKcSF1KkXat40qa/Cgg7fxis9yhytaeNqTv7B1A+3w0l5FKR9T6C4/Cx4quHA09tfR3L0gD3nt2tOeroR5FIm6SeS+5xp7kLwF95/1XPv0wdchrsI5RLXLjlMTnyoG5ZDGEga5tKsLKteDXb5gaG6o75XLS4EvKu2n0TB8IZHURziNjI/JfEm5v8w+b4ByfiiOuuVloDbH99OSr2oWqEsoMTu8IVqErwxnLfTgL+T/CjmIn96iuzKVEWlkEii0mQY22O8NH5sDku4mHXVDihIfU+oYMQXUinorDwasdoynpUvJXjYK39RV3wpWLat1FRJPEkw0O2H96J+tFqNWQvjhjixBK6qMJ5YKzZ4dwx+YHJ9gCzNtY5iTikQP7gjMOaZWbQEd2q5ODdMqKIrvFdAHA4RwqvI23uw6i/x+4/PkfwgIecaU
 9IqBF/bc
 UNM67iNOk1V1V7dz4+MRLKq6DDYccBPSxlYbY24BD3zxu2EqygwpN4PZX3xuL1T7sROydAtLBFlTelMV3wOm76hLxRyC7uXPkNgfqSMxjQVENk8CwL33hjS+bcZEQRMMUYH9U6xbCMDJcl454VZnf2/8Mj20QqxBOLhaO8ZCsao9HN86VMTJqfVsWRrQNdeADYubAFl7G1lC+w+fETdsYK5UaiOdaOOPPtFj/CD5ci5gEkI2o5k8ExocpAFF+luFS9AEvVUPflP+YXLfgmPMb79PQLswlKfiQWkvH6Co1F/gJPigyJcbcSZ7GB3pOA1u9tjgsZJKdaJP5ThoO1qnz9MOicFKzA1MGtXbddU6TsLAJ59tXGviIWHSfXYU3pnfvd8tJ+auEQSlmnR99945TqmEwKVbLhOyT5pWrinBrrKr3ELiJnR20lUOKOkbhM8e6S55uvn4/ZqQvkI2/elM00kUatTvhns3iEL/zc92O8fumKhRPGP6XGso1P+5MGgWzYCrWCWec6OZq4VYlGq2gMliWU29808dhTUPrY6gvknf8YUo2lJkwQwnI3mGJ6l1rMjknWu62LyCiH+HIzKR5KbFRn2S4yaD485/wDOC4nGvACA97j8CH4cIDdy3rfVRKEXMVcrwZSfApZTsby9KH79zTDOutGUuE1iDjbLe6VKM7J5Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Wandun Chen <chenwandun@lixiang.com>

Commit ab521b4142aa ("mm/rmap: improve mlock tracking for large folios")
mlocks a large folio when all its pages are added in one rmap operation.
However, when a PTE-mapped large folio is migrated, remove_migration_pte()
restores PTEs individually, passing nr_pages = 1 to the rmap helpers. As a
result, PG_mlocked is not set on the destination folio.

Reclaim can restore mlock in try_to_unmap(), but Mlocked in /proc/meminfo
remains undercounted until that scan occurs.

Restore mlock once the full mapping has been restored in a locked VMA
under one page table lock, rather than waiting for try_to_unmap() to
restore the mlock state.

Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
---
 mm/migrate.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 94033c222e04..140e291d4587 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -353,6 +353,7 @@ static bool remove_migration_pte(struct folio *folio,
 {
 	struct rmap_walk_arg *rmap_walk_arg = arg;
 	DEFINE_FOLIO_VMA_WALK(pvmw, rmap_walk_arg->folio, vma, addr, PVMW_SYNC | PVMW_MIGRATION);
+	unsigned long nr_ptes = 0;
 
 	while (page_vma_mapped_walk(&pvmw)) {
 		rmap_t rmap_flags = RMAP_NONE;
@@ -446,9 +447,16 @@ static bool remove_migration_pte(struct folio *folio,
 			else
 				folio_add_file_rmap_pte(folio, new, vma);
 			set_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
+
+			nr_ptes++;
 		}
-		if (READ_ONCE(vma->vm_flags) & VM_LOCKED)
+		if (READ_ONCE(vma->vm_flags) & VM_LOCKED) {
+			if (folio_test_large(folio) &&
+			    nr_ptes == folio_nr_pages(folio) &&
+			    !(pvmw.flags & PVMW_PGTABLE_CROSSED))
+				mlock_vma_folio(folio, vma);
 			mlock_drain_local();
+		}
 
 		trace_remove_migration_pte(pvmw.address, pte_val(pte),
 					   compound_order(new));
-- 
2.43.0


