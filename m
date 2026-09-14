Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92DD9C88E70
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 11:43:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E626D6B009D; Mon, 14 Sep 2026 07:43:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E39E86B009E; Mon, 14 Sep 2026 07:43:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D50DC6B009F; Mon, 14 Sep 2026 07:43:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF4966B009D
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:43:51 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 31F2440336
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:43:51 +0000 (UTC)
X-FDA: 85212183462.03.D99DC1B
Received: from mta0.migadu.com (out-73.mta0.migadu.com [91.218.175.73])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5820D40003
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:43:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mIEWS7Dy;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.73 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789386229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YuZk/VnWGjK0mkaqRncTg/54L8rsEeJ9QQmj2aCz3iY=;
	b=TbTbGoP6isSdUBd6vjBPEI9jurKYihf5pBD/EwBUrXWWGVHkE51d5LJh67PFjoqPvfMjoJ
	y2XZPzzbnBZzwKWdRQwnccMnmKg0/RiY1MylMoFjoIB37vWjxnpoGGtym3TDFS2JDv64DK
	Dw+jb0KorPhgpptktVSVBGB/w5SabBc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789386229;
	b=gfUTzIPX4LIrzHbW+YmF7HOEe0Zp/DGHf699CRR7/q1oGaTP1OdO0ZfaW76G6aZ+0HX8x1
	b3Rh8K3MwW2fJ9eTO4JhBoyLxQUgPngrKwBvxyNr6QF29HMyOnyJuHRMqs/qU0Hw31e0ea
	/EkEGfzWN94KK/DPlZR7vB58kjPUqcs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mIEWS7Dy;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.73 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=BtQeHE2SZzfUtIrg0bS6PVLMNQTg1JxKJHlqS6nP29w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789386228; v=1; x=1789991028;
 b=mIEWS7DyI1HdBqd/B705U9Wj33XGUsvSw68vua1JedC2RDHy5PMVlkOqsKsSaQV/Uk6WP6Rh
 ngqIjQTCecZMPwCFSl+E3CgpcLAOS8cTxcJMGTZ05gCN/wrIngCKU9qse18Hw9zjlNRFvthXvif
 scBfxg5hIHRkp51mzpPAYsc4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 3c083accddd22eea;
	Mon, 14 Sep 2026 11:43:48 +0000
X-Mizu-Trace-ID: 3c083accddd22eea
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH v7 04/29] powerpc: mm: add PMD swap-exclusive helpers
Date: Mon, 14 Sep 2026 04:41:56 -0700
Message-ID: <20260914114320.12988-5-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914114320.12988-1-usama.arif@linux.dev>
References: <20260914114320.12988-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 9d6eym5u6ebsmts88g6gqyyz6fp5nmyk
X-Rspamd-Queue-Id: 5820D40003
X-HE-Tag: 1789386229-954974
X-HE-Meta: U2FsdGVkX1/uP+5jiUPMXtNidL3HpeOBhAja5BWK4V0WhPZtcjdq7lm3gzoTIDJLTkoea96ZIOoGIt4WqHVtCUy6lgDHfO0PRFW+6IOH4qp7Coqgt0tLZ8cMO7XvFcOgKsUztwX9GnfCh5lKqm+Vo1d/zaZkXN0/CM8v2y3o4ZyFXyZ0t9VM+nX06xdb3N6dg9afZp3Hxrt94gYENS1Uobhtmre88VwEoWCpQ+f8yvwSqgppplzgE+61b4vMm/Hqt00BRgsTLxjFjLn1UNq5lTL0O4NUQI0dcbFSHNiM5XiRfsG3JvuWhF60IdQJ2SY3NtJ208OWe5xjtl3X62yRxJmCsTzUoraNwsXPJQrzgsXh6gWv///JuDzth8z5NAzlpEhfUmGnldTGLCB1gvPxYIMTc5XCUFTLCF3bFgPTh0HaWLTpcjYUY5tBXRVgwwL9j9ufyYX2yQOUPhVm4POVN7WljcjCdB/NMr3K26WItMB5yMc1xfFIcaxxpqORC8UewZdi6lsoKKu5WkidxsXS/JUjA3qly1vS0zWR6oNoz0VDunEbINSLkcnSI8CSxjlU8iHxWhhAtTA73W2fw8dHWWtkT/qGLgtoi5YqtDjr/AsFT9xkZw5k6m9wYNJZLDpGR3UwYY59eKjOSX2NVRjZotpbXoxNtza2hscjbA2vUJfMutq3unEQ4Uqz8RcNUp6SA8n1Sh6K9dOp6jqVZpovcQ1dW8b5jRCKoEEJUCcjDySNRfq2Mhyfs+e5pTDPzwoGJwYPMfxfwPSrFnkJ6kxmj1VKz05AbdsGgiuwdcBkjQSUUPnt5xlVX48a1cIhQRaI4WKTMbM/4Ug1RsJC8FwNMsL/sNaHytaV7Ntp2G5mGsVJhx25oAnqa6UpWycQWlSWDO7DOBPv4Lthm845JjDid9x1pUOLxREFv8zWcVqUSzrFRTr3UiFze8hthxQWAAx7bjCP2uG98Bsg84UfAr+
 Y0BAQCcs
 5wJVfMz2mmqT9StGkAqjy3K3XUFwaiqrgcsmF/Ww9QJUjq2AK6ofgA4Xkl3fi6RZ/mXHnVFmerrhs9duQ54MWaOs7uH2/U7KLFs4eI82N+wKRhPBoQ5c7Nqz3EvQ5NYxwBgWGoPB6NFgbmkwUXjo7oo0W/LxCiofKIiP26IyvRuCy7SErJAq+Z5dXoklw/ilIczKCUjkAPEVpuO6VM/z6jAu6jktRjFOVR6hobcrUMEd/P3QLawV8FuQrJYYcUeBcEFqr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A later patch keeps a PMD-mapped anonymous THP mapped by a PMD across the
swap round-trip, so PG_anon_exclusive now has to survive in a swap PMD and
not just in a swap PTE.

book3s64 builds a swap PMD by running the PTE encoding over pmd_pte(), so
the PMD helpers use the same _PAGE_SWP_EXCLUSIVE bit. It is also the only
powerpc variant that selects ARCH_HAS_PMD_SOFTLEAVES, via PPC_THP.

Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 arch/powerpc/include/asm/book3s/64/pgtable.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index dff8790a047db..28943ef3c1c80 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -699,6 +699,23 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
 	return __pte_raw(pte_raw(pte) & cpu_to_be64(~_PAGE_SWP_EXCLUSIVE));
 }
 
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
+static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
+{
+	return __pmd_raw(pmd_raw(pmd) | cpu_to_be64(_PAGE_SWP_EXCLUSIVE));
+}
+
+static inline bool pmd_swp_exclusive(pmd_t pmd)
+{
+	return !!(pmd_raw(pmd) & cpu_to_be64(_PAGE_SWP_EXCLUSIVE));
+}
+
+static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
+{
+	return __pmd_raw(pmd_raw(pmd) & cpu_to_be64(~_PAGE_SWP_EXCLUSIVE));
+}
+#endif
+
 static inline bool check_pte_access(unsigned long access, unsigned long ptev)
 {
 	/*
-- 
2.53.0-Meta


