Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01333CD98C5
	for <linux-mm@archiver.kernel.org>; Sun, 14 Jun 2026 21:02:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 105FF6B0005; Sun, 14 Jun 2026 17:02:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 090196B008A; Sun, 14 Jun 2026 17:02:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E999C6B008C; Sun, 14 Jun 2026 17:02:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D587F6B0005
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 17:02:13 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7D39F918FC
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 21:02:13 +0000 (UTC)
X-FDA: 84879740946.18.F33064B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id EC1E5140003
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 21:02:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DnL97brA;
	spf=pass (imf26.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781470932;
	b=WbB1SabMDkl8nBf4nWC0qurJ3Y7IjV3juK81zy4KlFvOTEDUxE+450qHZw2il4/atmdWbT
	Bj+ZvrfvoMtAW6EQFqwyQhIY6gWBU9nmeQ78MNyvvYkPm+yeOfC9wgJX8gqj+2bc8MdeHY
	EBajxCfJjzXim6JNo6TfMXktyWeyHQY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DnL97brA;
	spf=pass (imf26.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781470932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=x5PL9ea68ETMoE/me7VchVD3ZaplPIV6ryZDRpLN4uU=;
	b=Eh+/JADgsnDt3CcnNsr1c8o3WpOnvnIPw+l3wjhuHFCMWIs7qJ0AEWIBBTQXAm/jnyppWV
	7wGszcZwRYDAvYF22pjNLHuCoQLH6Zo1tark4x+ci4h7MOyfeEdtMV6f7QqyxmHtl/OzAk
	Gl44WS9Nd6VGamOuAQNZva/eNPsMC6Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F082143A05;
	Sun, 14 Jun 2026 21:02:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A00EE1F000E9;
	Sun, 14 Jun 2026 21:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781470930;
	bh=x5PL9ea68ETMoE/me7VchVD3ZaplPIV6ryZDRpLN4uU=;
	h=From:To:Cc:Subject:Date;
	b=DnL97brAJwWsRnbft2pAvI6LhC44L+A+or5qP9u5r5vret8j3fO/knh/Payo1LFUi
	 ciEFh4xbJHSSzl+SrYmvlwaF0hCP2j5rNZJc3wTNMaMWbCVwM1P2f6K0fEvp3y6Wk+
	 qjNgktpemBXnmDOcOkEZd0qmq9x31Ammny8roA1Hg35bAMO7hEm17lGbIOAHUTNruE
	 X3wAhWdTRMRwToz7jU0zLKAYr/TY4xHB0M93FKFg6FiGwwqmUi9DJgF61LsWm0SXeM
	 K8Qa0dRUWC+zyEvRL/jibWjjFgvrEVQ5db03zFnV/ltJfv3j9FXFG7TtT1tI8eFszF
	 +n7kxmpgPpj4w==
From: Tejun Heo <tj@kernel.org>
To: catalin.marinas@arm.com,
	will@kernel.org
Cc: ast@kernel.org,
	andrii@kernel.org,
	daniel@iogearbox.net,
	martin.lau@linux.dev,
	memxor@gmail.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	rppt@kernel.org,
	arighi@nvidia.com,
	emil@etsalapatis.com,
	linux-arm-kernel@lists.infradead.org,
	bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next] arm64: mm: Remove misleading pte_none() comment from ptep_try_set()
Date: Sun, 14 Jun 2026 11:02:09 -1000
Message-ID: <20260614210209.2371030-1-tj@kernel.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EC1E5140003
X-Stat-Signature: 3uyswpsgqjwy144mgd3trywacqkrc3oq
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781470931-70311
X-HE-Meta: U2FsdGVkX1/4S/Ra5TjOiaciwMVdptYmJLp6eGPH0D8TCnAruJ/L3ibec170D1YL0B82q9twyk41pmUGMyFcrlAb63Gzs2oZkfYfV1OZmcTM1Q7p+Y+voUUf9D4KM+jrR3b6lNEl1vpcAZY7cuUJHlEDN4KMS2GuWJVOpHoVKLbM3t49Cg5V87VkoueXJvKMzasx/ebRqd6zIKtmVcPQHHa7glmf8569TaZsF4Rks1yCoIxVmwJ8r6XmAS5MS8SryRgh/nx3fRQsb3aq7LodKXfx0EBYPzM3ErMlSofrkORMRpthWKgsMBvRWRnLFI/nmXg/cKeUNfFO8P8XyRdEVPYG03MhNI+gMzps3gJTbACJnlu1wsMMbQqspavamKHdRExyN9QfI+NcIREAwu3f8GDlop3h6MGjTGzi47hrsFvd3muGy4NvYzZJEHJAg///KPy+WhbnZ3zvMwYguGJ5rnFm6GojjOkEFZdpKGcU8M2bZeTC7/wej5aQwTOuD1aSCbF+4fmsaOIWbuudxi3Q09DR44vpN7eD8EeN4+38UJtf3L+KNdyaL2ahXeRDboIDPAYKII9Dy3ea0nUxtUFofrivMxIr4+65Iv377Zx3MNzRDvTdah4+J/Y95d1m90mCdhQLfVqwAnXHeFcvJamvErtHDVWuCPtdKOXrJjLOF8wTgYZR6S9l55QmbV1jH79ZOLYoi3RpkgXI+fLs9pGUDuPJregAoZiZ2MYQUkklU3oRMSSLwdozxo4ZmoXcFz2Tbcn0pAbz34SN+JdlwFb1xzXaENh9iNS63sB7SyTYXV4OhcVsvjtnknDjvaDnsykcD9nz6auzKpLohkkRKcwGc9cY0Im2kSojhmh3iT2tzc4FMOOSR1TDAqRKg5xupysCH/LXC3TEH95+t65rChYXthMB0X6Ltj8XwQmEabOoSzooyo/LaT+JYzUy5b9JDN51IeyDvaDqPcLnlPSnPbW
 +lDOzD67
 WzdXfUd/yT3nVyGIY1HU52RNGbOmMgEpYhjn5Dq5gGNAtKBIIL+EaOLyxpBB27Goi/gO06ozugABbCTrGnRdE7CA7zStVJ65qA+ifXqsdMHc/zVySp5sHq+o3a1EpxXsuRQSqbCUXF5SHA4kMXPR6KvWWfspgbj4Qd0EUZa5JdVThdLL6m6Q4yydH0GDfy9aKrzlSBBfYyamSqteVre/cK8cXLc6nU72YX983y9t9BKAqSNvVqnT6if76fPxsLhL+iZX5Yqa0ZfJkwvZOMd25GHLQTnLVMqUZ8PMX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This comment was thoughtlessly copied from the x86 version and doesn't
apply to arm64. Remove it.

Reported-by: Will Deacon <will@kernel.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/arm64/include/asm/pgtable.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 3ce0f2a6cab6..b0213799ebc4 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1830,10 +1830,6 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 	return __ptep_get_and_clear(mm, addr, ptep);
 }
 
-/*
- * Note: strictly-zero compare is narrower than pte_none(), but the gap is
- * harmless: a fresh kernel PTE has no software bits set.
- */
 static inline bool ptep_try_set(pte_t *ptep, pte_t new_pte)
 {
 	pteval_t old = 0;
-- 
2.51.0

