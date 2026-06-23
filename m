Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B118CDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 06:53:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BFF46B0092; Tue, 23 Jun 2026 02:52:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 396C76B0093; Tue, 23 Jun 2026 02:52:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D65A6B0095; Tue, 23 Jun 2026 02:52:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC6A56B0092
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:52:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 79E701C1B89
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:52:58 +0000 (UTC)
X-FDA: 84910260036.03.45C6860
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf17.hostedemail.com (Postfix) with ESMTP id C9D0340002
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:52:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sp1zu8td;
	spf=pass (imf17.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782197576;
	b=BbIfrGrUc74XGO+AyBWZbRUiyJ+vYJvilnUyU3lAf6e5ZLcAQ3teCOYpZrhRVYMBMVP8dJ
	oUt5rmmwYFTrvS9Lbxo3aD8ABXcyGanIU6EqRWEKXFIQGtdXS7ylCjaFzXJf0qOc/pK504
	zVUMMpD/aM7yka/ObJIoy6KLNdzImBM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782197576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jPNS159ESiLc3aJuAx/S9sR8HFRJb+0xK69O7GX3r4I=;
	b=SRBDhxgq33ddxkkbiUkL7zXHMerv79kcx2V3LDQif7avogs84ONu/YHlrzbPeM0CtvCEuf
	rgO42M49+wer6f6+cGuBRFstBhLFF+nN0F17ntS29NKIujTAuyjrms/jRJEMNM+OliQ4R1
	3b5nbvTHbUkp9qMvFRbnXM+p3KO0PNo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sp1zu8td;
	spf=pass (imf17.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782197575;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jPNS159ESiLc3aJuAx/S9sR8HFRJb+0xK69O7GX3r4I=;
	b=sp1zu8tdq9oO+WZwW6SuI2/1y47k5CnnpYNdbwbYtFQMEMzDcngpiHEcnauaeoEHNPceBs
	hiAM4ITGZNmGx9ql8hoTeL5Lq/MNNlmEl2okJSB2NaPsKf1BA3NzkFmG38SKV+r7zzxkpk
	G+zwhY+jh3C9hg4TP5kXxlQbH9xMPzU=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Ye Liu <ye.liu@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] mm/page_owner: hoist CONFIG_MEMCG to function level for print_page_owner_memcg()
Date: Tue, 23 Jun 2026 14:52:28 +0800
Message-ID: <20260623065234.31866-4-ye.liu@linux.dev>
In-Reply-To: <20260623065234.31866-1-ye.liu@linux.dev>
References: <20260623065234.31866-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: ecsdotwj4uq99xqqjzt8dxex6363qai1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C9D0340002
X-HE-Tag: 1782197576-219059
X-HE-Meta: U2FsdGVkX18h4ew4DL3CCgDZxvYbmUxiY+mLfpSxJTozjsfXsEOB6HCVgdW4uN2ZdNV6Bm8S47N2M5gB+O0XPYsXq8sIz5Ib6EuhzEkeQvbtR7so510YDkKHNTICL/SoNUg8z1Pmfcd/wbsm5yDX60K5SrZvnjMPcF/qfE/0lmSWbzLwCc62n0BPhNcZQKOGsG1xBSW24OS0RzuAGNRjt+c46S4Mxx3Eu2eswWs+81GPZbimFIO32MI16YLMyJdy6Rp7VQBULih1fCc7FMc3zWA+ufNFPqR3x3izP2hwcHSqYF7hi1SNiQ6fDI+EPS2zFGrEpB4hNmU3ujRblycteUMDnGAHcTzz40/HHJF+kgpMKua1gHFQDvk3p4vU0g7d8WAzXbr182hlm++3N7MwDArI3RAVFV34k10dtWY4sIaRzumDSyTD4bR1nopuKw1BmPvhqJQKLiSAueQW8zsL77N1ThDMjF/Dsa6PCv3QpJBKNwhSrkRLm3IU1NyQXhy4pRt5seoDluJ7jBbwPPcYCB1noSyJ3Rh8yrORl5MDNPyombMU9MIPYZGr5e7zNImgIz/pptlA40Rt9/uh2O6Mb281syHD9qvJ8NLkAe/zNzH2vV3CTcRBSbJB58ti66QrI9AQ344bxAh4wzHrgnf/2EbZ9WyBzN8I2PsKE6wSCGnISTKdTNvAc1Q2VrqBmM/5VzYtZAKxrDxs59OQhkpE57v9cWgGvmN4VOBZIwi12aBiOOPndMEPcmpVXfLD4U3vUC002dmOEPOr3uOunSPBIBPTnW8R5FeP1lQFuNKP/JCDjUWflvmKE7e/4gUmnBrIJ1DMZayDpfCkIElzvN+yWGylT+FWTrft9MrjF6xokezm4NSLscZZzkRURnXChX4WNeJQ75aXtUh1FdFlCPYJkltz73fErECPsYtyheM0cOKQ8YaWT1v2myKilwp8m8umgIpr3wiy3XUHlDSEflN
 k14T7luk
 cMzj1SH0b+NYpmNusqJrA3VnmNP6wDwhqdKMl13fr1mVnN2TpTjtFKtqPw9UOZmkYbBTVKBZgwb/dMM9VBJDCtQrYmClCQyMdZu5Ci3lB0FbGxE8oEsXgcqJhBny6VSWKZGh8+7/7r7tv2tYzilpkMXgk3HcjT08jSWYF5v4ryCeBoVMGtwB7pZMYSJReQH7+oDR+pEkdGQq7VgF9DxT2FkYPlNS+ipnnsnxsOhS7LfedBejd26J8Tl4EiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The print_page_owner_memcg() function has CONFIG_MEMCG guarding its
entire body via #ifdef inside the function, which leaves a no-op
{ return ret; } when the config is disabled.  Hoist the #ifdef to the
top level so the real implementation and the empty stub are two clearly
separated definitions.

No functional change.

Signed-off-by: Ye Liu <ye.liu@linux.dev>
---
 mm/page_owner.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index ebafa9d7ff07..5d8773c90cd9 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -529,13 +529,13 @@ void pagetypeinfo_showmixedcount_print(struct seq_file *m,
 	seq_putc(m, '\n');
 }
 
+#ifdef CONFIG_MEMCG
 /*
  * Looking for memcg information and print it out
  */
 static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
 					 struct page *page)
 {
-#ifdef CONFIG_MEMCG
 	unsigned long memcg_data;
 	struct mem_cgroup *memcg;
 	bool online;
@@ -563,10 +563,16 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
 			name);
 out_unlock:
 	rcu_read_unlock();
-#endif /* CONFIG_MEMCG */
 
 	return ret;
 }
+#else
+static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
+					 struct page *page)
+{
+	return ret;
+}
+#endif
 
 static ssize_t
 print_page_owner(char __user *buf, size_t count, unsigned long pfn,
-- 
2.43.0


