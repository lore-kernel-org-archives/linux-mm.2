Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0567FF8875
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 10:28:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 375196B0096; Wed, 29 Apr 2026 06:28:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34CDB6B0098; Wed, 29 Apr 2026 06:28:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 263486B0099; Wed, 29 Apr 2026 06:28:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 16A0C6B0096
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 06:28:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D1F871B6BCA
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:28:21 +0000 (UTC)
X-FDA: 84711218802.20.82B5D7B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2795FC000C
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:28:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=T6QBMkrR;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777458500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vHFqyz4u20K9AHtpBMP6v8sRjSSAqiHGmoK6SbI/Xuo=;
	b=KxscdEzqft5A5gbfX5e8Q3wRofRt2uQuok8lABIGQ6kUlnZi32N/cCIfkYPSAT7hDNovHi
	OWuGnslQGA84af9f+K+sCDRaVRI2KtOjdLMfPQNH34WvKqu0dmw9M09/EHZWUrb+1jmcRo
	dEUm60R5opgOhWdSpHao7CWf/lxo/K8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=T6QBMkrR;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777458500; a=rsa-sha256;
	cv=none;
	b=WKwICYNGmOWnoCP7J5RP5u7bWY+CCWAdrFCd2wGC8udv8gw7g52uQM/BqvVr/coVpCOjG1
	+esxGTnuFqRhCv2nrvRWizyTp44+G45KkycTT+ZGe4MyyRfV+yowCiOWGuHN1XoaPfebCC
	cFkJZhXz4mzYtX5kTD6UNxh5T0wGD20=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CBD562A68;
	Wed, 29 Apr 2026 03:28:13 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id EA4B63F763;
	Wed, 29 Apr 2026 03:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777458499; bh=Wk7w9lhH1k+YWbLTG0ALVUDnoHIRsitzS6tZ9UC4swc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T6QBMkrRy4jK7cyGHC88StfkMlvC7TKCLOf4uKVKSxH0q5oOE7SFbPc/FukftUdc5
	 s1nYC8B8aMvQLMUmQTHVG4LAktohXf0VpI1n02HmiFkLc7jEpu6EsiGLIfUCkWBrPh
	 ya7TyfdwFxyc1myoadrkLjQOXFWQkf9o6I9zkBfU=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	urezki@gmail.com,
	kees@kernel.org,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	arnd@arndb.de
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	tglx@kernel.org,
	mathieu.desnoyers@efficios.com,
	linux-arch@vger.kernel.org,
	ryan.roberts@arm.com,
	catalin.marinas@arm.com,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH v4 3/3] mm: skip KASAN tagging for page-allocated page tables
Date: Wed, 29 Apr 2026 15:57:04 +0530
Message-Id: <20260429102704.680174-4-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260429102704.680174-1-dev.jain@arm.com>
References: <20260429102704.680174-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2795FC000C
X-Stat-Signature: m986km4aubernfrhfbhhgsdteh8dt5ss
X-HE-Tag: 1777458499-239600
X-HE-Meta: U2FsdGVkX19pP4Ed8AUjug8DO4UkFmYGQjY0gj5dv23dp3GLhbaqxU73Mc6d9BANofTs1NZ8aDJrKZofgHHXp6DaXc+q9rY5zt9XZIgMplHfvktVrju1nkOnW/i5q5lbNy2hnSYTs4kBIMG0xEtT4jyul03nDJbtAk7hTr+D+i2PqCHubLpmgMRwfrACRBj1+iYJ8miZqK4u4Hv2rLuNLYqsaCzEkBV5SgrkF0reUf9ZkVzxePE/NRpY0EPPE69OG9EMM7OMISvbnoHUIkwXVqV2eMtlWPvonucBUPHtjAkUZUTVJOFPPcnZkm/w/CAyv7RXzvOrZVAabfbAh0tuxHwJb9b2zCHoNWZ8k0pM2KKPP4PgS/OMzhXqSZHXfhSpg7mXJuwdL9V4u7GtSvZU442VWc1TpEmItDNLDpONUGTxeGj20MfiQlBFkr0SKP1YzT3kIPqe/uysE0DNLMj0De7gsddJiuU7FqFH9sj05sFXXOWaeP9+7AEhhbxVTUNhDU5JveCtqSkYyJqgghw4fhqSJtLFFM6Kcq/N0rDSWGymDoZt0bpzuA20FEGyXNMWMnEJIsQ8vM0fLZL28594sQ5y7fYC6aStCkATip/KHcq5j21bj9SJIIIJOUrG/EujHA5VJVryd2bSJ4SIDZbgEJn94vY/LmkeIvu33RTc3fCLpYjTuCNNTeQVuN8hV0rjypR2I3kHAn3V7X9+brvgoYdlqBI1f9agi5ahzaXhWIV8a5p591fo9Z+bPLL4YESNuaLqnJZl+IeY5Im03xqC4oi98BS/NszP8GEhWdYTR7AbEMzZCY5GEjq7Pt+GhfIuWZdXkdBmHUPLnbHZi1maQRnNCJXrRZXGJuFG1crBTzENK2QCpRT4u1zXdYpldMMeo1UT6WT4euEe/u4HThtEaaclKLBYXSXZVKHz4OyALz3aVAenODWrkDgiBj3bppw5E7SbNKW7lppY9189F80
 tiAFMxmE
 Uszws3mwvOfheOeGILzrC+8L/7+aQx8ajd1kWyl3J7+Qz0KDe2ZojfV0mYw4IROq/sFMrx53ocyLzz3NkgXWuCQ2+YEjzrVq3r+4RJoD8a7g4mwf9DP6beqtQFHR7MPJghpjrHq8OweMP0mXnJajVYn73P6wfajSUOk927zaVLibw4xWiKbpf6ypNncARfsd798XKUvJh+l6YFeDH+ATOoEw4Bsnc8cCQq90FmGI9saWG6QitrVlOnDP5MtpeAziiaaB+ICqBGR/VNa8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muhammad Usama Anjum <usama.anjum@arm.com>

Page tables are always accessed via the linear mapping with a match-all
tag, so HW-tag KASAN never checks them. For page-allocated tables (PTEs
and PGDs etc), avoid the tag setup and poisoning overhead by using
__GFP_SKIP_KASAN. SLUB-backed page tables are unchanged for now. (They
aren't widely used and require more SLUB related skip logic. Leave it
later.)

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 include/asm-generic/pgalloc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-generic/pgalloc.h b/include/asm-generic/pgalloc.h
index 57137d3ac1592..051aa1331051c 100644
--- a/include/asm-generic/pgalloc.h
+++ b/include/asm-generic/pgalloc.h
@@ -4,7 +4,7 @@
 
 #ifdef CONFIG_MMU
 
-#define GFP_PGTABLE_KERNEL	(GFP_KERNEL | __GFP_ZERO)
+#define GFP_PGTABLE_KERNEL	(GFP_KERNEL | __GFP_ZERO | __GFP_SKIP_KASAN)
 #define GFP_PGTABLE_USER	(GFP_PGTABLE_KERNEL | __GFP_ACCOUNT)
 
 /**
-- 
2.34.1


