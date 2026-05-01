Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5634FCD3427
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 23:39:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4118F6B0005; Fri,  1 May 2026 19:39:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C30D6B008A; Fri,  1 May 2026 19:39:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B1586B008C; Fri,  1 May 2026 19:39:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1AB696B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:39:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 41C021402F7
	for <linux-mm@kvack.org>; Fri,  1 May 2026 23:39:41 +0000 (UTC)
X-FDA: 84720470562.20.3713FB0
Received: from mail-oo1-f98.google.com (mail-oo1-f98.google.com [209.85.161.98])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3940D20003
	for <linux-mm@kvack.org>; Fri,  1 May 2026 23:39:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amlalabs-com.20251104.gappssmtp.com header.s=20251104 header.b=G5GD+WrI;
	spf=pass (imf03.hostedemail.com: domain of souvik@amlalabs.com designates 209.85.161.98 as permitted sender) smtp.mailfrom=souvik@amlalabs.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777678779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2qFO2NeB0Skobdzpthr8c1Mn9L79Z6O0Ds9iXE6n6s0=;
	b=g2ulsL9FZ1EiJa3ukL9OvJ7NCYQjZ7k7eUHNfYkDm2sQgwmHCKVgpFYhacOBo9vim+mBvw
	cjplkuSi8nQhyAFCYsou4CVuUzjy/I8TMbtLmR/YoGwPL26wgd0GwLLXlEtFsAxpFvQIDq
	OT/ZVVu6OuK3mg3eV+azgBZjuX2zhYc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777678779; a=rsa-sha256;
	cv=none;
	b=qMc/kJgHSTf0V/6Bv5vJYppnmbfSg5LgkNofyOExjhQ2RnxXfGSlQGIhpX4aQgyRLj7ca/
	+DdZgsMKZVYEEsvhd8zwglJOyEFk3/dyn0K2WMGpQX3/XGg+PslIGMoKWR8RIIuwYDDfor
	FnuHon+GEaf39fMT2XROIl9Atz45eXQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=amlalabs-com.20251104.gappssmtp.com header.s=20251104 header.b=G5GD+WrI;
	spf=pass (imf03.hostedemail.com: domain of souvik@amlalabs.com designates 209.85.161.98 as permitted sender) smtp.mailfrom=souvik@amlalabs.com;
	dmarc=none
Received: by mail-oo1-f98.google.com with SMTP id 006d021491bc7-6966f99716fso1214807eaf.0
        for <linux-mm@kvack.org>; Fri, 01 May 2026 16:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amlalabs-com.20251104.gappssmtp.com; s=20251104; t=1777678778; x=1778283578; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2qFO2NeB0Skobdzpthr8c1Mn9L79Z6O0Ds9iXE6n6s0=;
        b=G5GD+WrIWpK30AsHHv3sdmJX6SJlJom9Q8/vZZdnVwcfY49qKqUjq/32OUL0x1sAXI
         g+y3ABw8r1bxZgN0fqws83JTJMDXUnpHnIqSsWRIT+FD5xUWILWH82l3eHdBGJqozrfz
         I7/tpKvdJbwDU+jKKjw0xt8BiTohYaaXEaCcnX65e0vkk3UTeOrWC0tNR6MZJvW3Tj+m
         /ySGLkroEJBdyZcHdQ9D7hyTb6tF3r4VorB9ZTXg0TTHpngrSvQSUtdyIJNF5pJAlWrG
         cK0tFxGIJEBTR5ZSQqDFq2Z9PdtSLsJ0LFVYZTQy7ZEzGffa28IeXwluT+E4XBH6/o55
         J9cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777678778; x=1778283578;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2qFO2NeB0Skobdzpthr8c1Mn9L79Z6O0Ds9iXE6n6s0=;
        b=D9OT0tJfc0npyFMeIrL2U4965xR/CHikZZ5Wbe1ACKPBcMjrEPQr6iCqTJPQXuGLAS
         E/poErQ9ruCu2L2AbaMaOMpvkTvmEjAoEl7RgS2PtETrGFTG5YpRG82v4NLxJ9CURXMn
         1jvJ6KVOjray4awzHd21oQgzSRUSJDZZ7gFLGIETpQd1Qs8anTeEv7CIqIsFd8gNit1X
         g8AwSThj7KqwmwbYg9GPNghpqDaxrewLH2kZ+fou4du4KSogNhZ+jTe7kxYhxbOgUA0F
         c7Xuf3K0pt3hHwN77AGokIgpS/S4Ly0ZvP2wdTmmiFVMNN0jzxNX12h/PiScbA1FI2z8
         CGrQ==
X-Forwarded-Encrypted: i=1; AFNElJ8VeS91ncltwj/vFBMEGPNX4hZbZ7WBCIhffWQDrHA5bySKb5pVERa9DXhITeSgcHOZ+mzUgmn3VA==@kvack.org
X-Gm-Message-State: AOJu0YweV0fdb3wtjIpznJggWVJlLIKC5b0XjXURQxULhg08r6t1Ak+Q
	z5/Cjnns69SYuZ2b+N8/klc8WxM//7kHVYMnmwDrplWvN7U8RIEunDPz8h7+94+vOdgpk4PB4Ws
	uLBLN/UbJbZGM/t8kMfrweWcNsFAae6SAFlLz5/Q=
X-Gm-Gg: AeBDiev5pICEiwuTJlUVUTE9uYXgYQ6LKyhGxShSWAHp/LJ6k00nu/LBfw2ZY8Z/S8U
	GGjIvshep1bi66gvMs6F32O97vXQgNCZjOd5py7mEHHrTfStRfwgSyTyEIAtWCItkrGjfOOIzMx
	+Wq47s2Olk9SPmYkpSAM+cLU+uqKVie6AE94Llexb6wYqJcbOOoK5bTjjjfffT2v6Cx55i/f2vU
	8/Fn8A3x1mPK1Jk7u8ANtIvUPYl2OkLPsidqWq74y3LcOvllqKiaq9nAZkoS0RUZvxq1I8BnGYp
	J8REa+sFHJfMUrKQP907ivhLCCAnv78EYEfFS0QdFVgL2sWewd1TTzHAxYzs3fkPWnqQ3VlO4zE
	yqwv+9pSMD79TMVqWbIGqArD26KuvVLl4fCulx3DIzKmcLfavh7GeppVTHMUMcIum7GOb6mlXZV
	9xfUt+Gn+G
X-Received: by 2002:a05:6820:61e:b0:67e:160c:36ba with SMTP id 006d021491bc7-69697d6a089mr608506eaf.48.1777678778004;
        Fri, 01 May 2026 16:39:38 -0700 (PDT)
Received: from amlalabs.com (104-10-255-95.lightspeed.sntcca.sbcglobal.net. [104.10.255.95])
        by smtp-relay.gmail.com with ESMTPS id 586e51a60fabf-434549400e9sm365539fac.5.2026.05.01.16.39.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 16:39:38 -0700 (PDT)
X-Relaying-Domain: amlalabs.com
From: Souvik Banerjee <souvik@amlalabs.com>
To: dan.j.williams@intel.com
Cc: willy@infradead.org,
	jack@suse.cz,
	apopple@nvidia.com,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Souvik Banerjee <souvik@amlalabs.com>
Subject: [PATCH] fs/dax: check for empty/zero entries before calling pfn_to_page()
Date: Fri,  1 May 2026 23:39:33 +0000
Message-ID: <20260501233933.2614302-1-souvik@amlalabs.com>
X-Mailer: git-send-email 2.51.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3940D20003
X-Rspam-User: 
X-Stat-Signature: 96tyn41ddwukfxtg3nok4obqsowbera3
X-HE-Tag: 1777678778-907604
X-HE-Meta: U2FsdGVkX1/84ROnV00OOsidsHsAtScljGO9oRLGARTYTgk4J8/jCEngeRhHFKFaz7VYBXhzxOE/j29rV6dH1L3itSLhja93niRurlV4G0hMIjrY0P9QCF0TJI1x226oc57pAubWrPl9tdqH2ExIDsdBIfhvswUoRwWVW9GYRjL1igvh/M0g03GAODVty0uy6dIhLhUk6Q5+6UR14u8qdWA2rPyRtrxic1+YyHmkRw10hU+b3zyJla7eu4k7qDf1zeuQmQrPV1P48OlcMC/a0fBRP5x8FKvQGuKraJWJqC9qUB83i4UzgtZS72KGPHkqskqEzm0Ua1quZRWUzArXP0S0w6xvR9yV8ZFSrI6v88ftXojx9a+c62SMu65d6uB1RkZmBWjC5TP6pmEl0La6/5frDXT/89NX7IPt8s6CzFPnCkXZLguS93batssb+uCOtyAEhO+BIoLAnX1WybLBB0SFSxAOiN2h1ycMio9ry//nrG5va7udgvCTeifZ5uhXQf5KrTIzWs7zur8Uu1ls51LfZVmIesbNmn627hacwdvX7ZddBL1BJsb7/jZWnJlNc8btM8XcX96cZh4qu9g+LVvC3UvzIxzxKuFq42vD2dFpPzdhqEAYOx5MGSClImnsEZEgQGJ7r4CWIYdPMpmXsTDLf8LFRJnN0WW9QZBhYNf5ziZpzg07WSXaBLv9zHa20gN4staduwE62IooX6T0RPzRcKaSUFuyQrwAk8NswncrIxQTArk0ua9rpyaL1bFUzc1EI72S54ASg7uppQlvQOJXEC2NJmxDkjKESuIBojGgiIKI3sD/1f3XEJc0KUCDCsRRIc0wpYxPRZBXv/9SkhkiKoIZV3jJpDn2i43MUCCdeXY5hrMSENRZGuTrYium/ucAhOlywZoj0E4+ucY5RgCup+XnqUTttqG5VGxHHxcAJeSn8LAqDLN4isUTapxsJW9IHbgfuIWtOe7uAJu
 L0GgIKR8
 yp6Vu3bJh0ZyC9Mh2Xt80GGt6rbZCUiHliZmKCPlXXxXQr5qYLlLLIQUBrInlT5H/GSuCyU+r/6R4rDZZGrUFbXLONLJCVkimmWK78cizZKpqDW6VTA6JuH2L2bAgUzoratpP1v14Gyzfo9OuPI+32eq3R3g4+OokY2XvJwiyWkFM16F1P/OuNXrEs81c611UEYD+X4XKXUw1oXj/RCs4ftmCHNUvRrQSvH5B5Uhfwm0gaDB2lk4WOGO4Iu1n/QXLx8IPWVDHG1f0vyu+X6iHVW1a3ZdgabO9MZTZUxfW5O2p6YGOtMk1/WSv25QsNawydfKjhgtr/AA/48jKLkP5cznpUUYVct7idbBvnxSs38FwjzcU7Jgt3O8CniGi3s2LE4U2YBllKwx3u+Vu3zIuLynJpdBYFYMC6EI3KwTb7oSoceKFnhhDJSEewZ4ggjhUnoJmtzhJHYIO2WckM6t8frVNVmjqjuQ3fN4gimhHPvCD33pIWIxQEwJdQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 98c183a4fccf ("fs/dax: don't disassociate zero page entries")
added zero/empty-entry early returns to dax_associate_entry() and
dax_disassociate_entry(), but placed them *after* the
`struct folio *folio = dax_to_folio(entry);` line.  dax_to_folio()
expands to page_folio(pfn_to_page(dax_to_pfn(entry))), and page_folio()
performs READ_ONCE(page->compound_head) -- a real dereference of the
struct page pointer derived from a bogus PFN extracted from the
empty/zero XA value.

On systems where vmemmap covers all of RAM that dereference reads
garbage and is harmless: the early return then discards the result.
On virtio-pmem with altmap (vmemmap stored inside the device), only
the real device PFN range is mapped, so the dereference triggers a
kernel paging fault from the truncate / invalidate path and from the
PMD-downgrade branch of dax_iomap_pte_fault when an entry is being
freed:

  Unable to handle kernel paging request at
  virtual address ffff_fdff_bf00_0008 (vmemmap region)
  Call trace:
   dax_disassociate_entry.isra.0+0x20/0x50
   dax_iomap_pte_fault
   dax_iomap_fault
   erofs_dax_fault

Close the residual gap by moving the dax_to_folio() call after the
zero/empty guard in dax_disassociate_entry().  Apply the same
treatment to dax_busy_page(), which has the identical pattern but
was not touched by the prior fix.

Fixes: 98c183a4fccf ("fs/dax: don't disassociate zero page entries")
Fixes: 38607c62b34b ("fs/dax: properly refcount fs dax pages")
Cc: stable@vger.kernel.org # v6.15+
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Souvik Banerjee <souvik@amlalabs.com>
---
 fs/dax.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 6d175cd47a99..6878473265bb 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -505,21 +505,23 @@ static void dax_associate_entry(void *entry, struct address_space *mapping,
 static void dax_disassociate_entry(void *entry, struct address_space *mapping,
 				bool trunc)
 {
-	struct folio *folio = dax_to_folio(entry);
+	struct folio *folio;
 
 	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
 		return;
 
+	folio = dax_to_folio(entry);
 	dax_folio_put(folio);
 }
 
 static struct page *dax_busy_page(void *entry)
 {
-	struct folio *folio = dax_to_folio(entry);
+	struct folio *folio;
 
 	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
 		return NULL;
 
+	folio = dax_to_folio(entry);
 	if (folio_ref_count(folio) - folio_mapcount(folio))
 		return &folio->page;
 	else
-- 
2.51.1


