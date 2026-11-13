Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F306606A882
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZSatrfhB
Received: by kanga.kvack.org (Postfix)
	id A8E1F6B05C7; Fri, 13 Nov 2026 16:26:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EA286B05CB; Fri, 13 Nov 2026 16:26:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77D056B05C9; Fri, 13 Nov 2026 16:26:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 24A2F6B05C6
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:26:42 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3679B1C2B63
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:26:41 +0000 (UTC)
X-FDA: 85431380202.29.C985A39
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2CACBC0003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:26:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZSatrfhB;
	spf=pass (imf28.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794605199;
	b=YgzcjVB3cDGLvMEuFqeu3Mf0c0FicylTp47a4Njp+/PMJm2fa2FPiQcOTyzB5BeFb5S8Fe
	K7W3yGGayG5xHAE+mq0/wHqQ7lj/S30N5F/WU+gBxk2O6qmA5uaTgGZDc1SskQ07WTHtb7
	vuOD3OOGuJsomG1+BzSxnFf6rSbk/YA=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZSatrfhB;
	spf=pass (imf28.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794605199;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e3++s3veCOvuSG66GMLIoHWuPEpo+kSr6b68ALtiz4s=;
	b=Ofq6oBhy4tOCPrd1YE52i6IJf3kHpXYmDkJgHgiP+IUQcRNhRBn+AuCRfg1Ns5TJTPfv0y
	r+nt5udOcj3pxyYVB2bhBcdLxjzFR4goVOELpta1M1YJpbVP9NZ2lNc+4i7JSQT3dokICh
	n/tG7JCyLxVPZLnpr3u4afS29P+ZVwM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A5D6C634D6;
	Fri, 13 Nov 2026 21:26:38 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794605198;
	b=wPujZV01OzoxTQF+Mb7rklM8iSgCLNJ5ngwNtK477usfzlJNTJxepNIQRFxzJ65fFVEK
	 B8mwjXmtIIBKqID6g292/UDZL+NvN0EtHK64FFmBtBler8cQwOEEvRLuMI6k7sDcjQlp+
	 9+wYHz7Um+nx1mVgjmDHKqusZrL9ruBeJUEjG2tS2eXQMrsSOZNaR/6hNy4SpZC7c9LKl
	 1Y1yEpFO11dKg0kZZb+pTi0iRV9bu4myt0pgZBYVGm/p6eNf76EkIQj5U90G9tkJjZxvA
	 FAcmeNGMGz64gbED7mOOqK57QS04fg99gJvPX6OHqlV6HTzQ8KEQanzK8QCuOLaW93g==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794605198;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=e3++s3veCOvuSG66GMLIoHWuPEpo+kSr6b68ALtiz4s=;
	b=m1XPXh/Fxj83kPv/+v+tZPogJxpBKNRXzqGxJv833dFIKnyw0b5vyqxWkILSXXTas9+4
	 PEpdShw8W7agSaCZpAtwSlLckEkqmDXe/Bn9DcROVeCE0eUpqMMK0O14wljoJs4HMRSfp
	 YeOlH+wV3v2UCbne1xUcAQALbWVkoaiElwkyv8/lXFi6SKgUU6kxlewQg5XVLSzMXyl+1
	 wN0V5k7lR8XmIPONZww0D7RbMb1JNn3BCH5Fj4rQ+4idaE3xbxNXbEPlO6wIzqFn6C/g4
	 MippUpkbDULIigBITnUji0gQm4D7srbytabHjf4bmMmsLueSTim232pssdarLuugH2Q==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id A38641F000CA;
	Fri, 13 Nov 2026 21:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794605198;
	bh=e3++s3veCOvuSG66GMLIoHWuPEpo+kSr6b68ALtiz4s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=ZSatrfhB5vChYsYtYb6zRdq80aXdh+L0GdDQC8st85gRm7/ah2tEOEWl88JPBoQvp
	 11JAmIshEH88oLRRM0c7ymKWlpUOS2NaPnypfvhsvigjfpGwRw83raOGSZucv3zTnM
	 Q4qbZ5tipwLVHnoX+ydEi7457tDWjmUC+a3+IhXUGDPtfjNLI4BURol9htkfW1/iLc
	 /7j4mX2IHrndph6fh/kRZtUH3qC8tfMqVLOB1nYTxSNdgMBE7512evLf74guB0PjOP
	 ydfQq3BmIMCzTklypdLl6OqS/bvr9ImYVbnIT0Nf2gn6e6THcbJHxM0l1bBsist9pW
	 aWAgVVPUs+rvA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 5DF2049B26;
	Fri, 13 Nov 2026 21:26:36 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 14 Nov 2026 05:26:22 +0800
Subject: [PATCH RFC 6/8] mm/huge_memory: rearrange split routine handling
 for better optimization
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261114-swap-thp-split-v1-6-dfa8d4fa448d@tencent.com>
References: <20261114-swap-thp-split-v1-0-dfa8d4fa448d@tencent.com>
In-Reply-To: <20261114-swap-thp-split-v1-0-dfa8d4fa448d@tencent.com>
To: linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Matthew Wilcox <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794605194; l=2082;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=Ywh5u6CH0UvNagiKhU1WNU9qFNY87IWayR40Afi6yCI=;
 b=5BjTzAVdQpgSdWyC+wp+tXTzTaCfmBLbicy3sBWh0+gsjfSSveiCBn0OAOViPC/pMoDHBKNFM
 dILf8SHbE2BB1NmVgVtErkw8dzv+fl3VR5SvpYPPSoY5MiKaULg5b9m
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 64jcxt7dsgset6s4ooc93fcmxxi1scta
X-Rspamd-Queue-Id: 2CACBC0003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794605199-177876
X-HE-Meta: U2FsdGVkX18Y+wZr0DPaJk+gwC43d071bjfHQ48Ad76Ka/3bXesIHZw8h2EG/sOxjHsi9Z+V93vEpfZEYl+0wzU8mJWNurUa9TXqbMTp76DbhrEqPXHijmzjDZUcGbCW279cOSjovneA2GwrXfcFtqCPLzIfnRqNrBCGuBqsRZREgRvmdNKR7sqG1KR2ST39gr7hPPJ7dBE/oJdUXfiG+n79KfrzvdkSXy70M2pjSFOeBpR+DSDeUpDJnvcOvXKU3csnVHAZ6lr0UwVkpvup+AyYoBbiAiJb3q9Tx1qVSGvZNEQ+jluwdbqOplyJQ9sIeOvJNx6QsPIWjiGBzJlBF+dDNV9fl/9pv1g0odnlxcLxEp5Tyf2lh3A7tO2v9dj7MzZis5weArYl+iob2udOkuq3wBnrUWZ3ylmDaJwIDpuHLq96oawaeuPXnqOfz4Tc0lBhOeSnLaiAKTbhgSLeVrWVl+2g4KVFJP9lpMtGrxKlXbYDRxSGobGaPbYKBTkH4zyhRrt039tFuK66h5ZxDIkwgNCtQ0t9cDJYddBG5bc11Tu4mPOTmHuRnvmcDm0ziqBxyUUXUpZlJ0bfcbgv/Pw3RH4L02Ne53sWL2NJeAaO9JXEJPLyK5YPgSTCYI03/kheyRTVisdtPF61yYlQmtSHOaK2UuaRK2xbeHfjPksslT4zM3Ww2d9Bj2fhgeDoObRWTpcltq4apxnNzMLXPr0vd+u6S1wHytdsGF5i/tJoII4hyKXVNAhazZCfszHA6aWFgDKhAlAaJMdN6fai9w5v8c+eKncyTfF6p1jBdTwTx6zDnL6giGDsaKtanMJSHUQbz7G0CSANhX9JITy+y4A5TiD9STH2dE7K8TwVz94/laFcOs0U3wxC+Nj9dTVK9ZznCJxbfg++0avR95FDq+AcY76rMFWN4tNANSzHbWWkrVSagPOKyflzrkz71V1xRvwzluqunRAnr2appm3
 18RePQbA
 H+whl7L1WoepXkhj+9dpEE8cg0haB1hk95vS9MqnkstYaQiJvSMV/O599gMlYiU0I+eECNDaBDgUvlWernPQJ+p2snEeQF/+7nA0AU3uQwDRRE7vSJy4p8D51ZJk9jVfVbhz05J9mZlc1p76QvOt3jqvPmGer4L+NbLzbyuzOvGkB4z7zvveohTTNrDYz/mUE8bJCQxhvzdAZGxBUpYYiInurP4H1Lw7s4IvgFVWz/5bS+bAHAlOjrA34ZSump+4ZZ4YaVbPk1qO+PfR91uv3vrIzUZIQDC+48HKwHq6/AH9loju5w6q2/l9wJmhefeoP5MP6U3LLvYSzJWTM9LT0XFF7K4VMiC81DCTI3Uej8GsFGcfVOxCA7uOWd3wBsn5A2C54E/TKsai73kH+kepdM2OwP35SpONgKHG7pOoDPdXxPSJWiDeGSsWB3mDkJtJBPM8BidMM2nazRuaw6UbbNUn70OYiQ/KWhV3Sx5NGKzG3kvzf2Iuf2OnrzMPNAKij227tUP0v34mpdrM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

Anonymous folios never use a mapping or an xarray, so combine the is_anon
and xas conditions into a single if/else-if chain.  The compiler cannot do
this on its own because the xarray split calls sit between the two
conditions and the anon mTHP stat update comes after the split helpers.

./scripts/bloat-o-meter on mm/huge_memory.o (x86-64 KVM test config) shows
__split_frozen_folio() shrinking from 1077 to 996 bytes.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 7270baa20d80..e16b93318613 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3929,13 +3929,17 @@ static int __split_frozen_folio(struct folio *folio, int new_order,
 	for (split_order = start_order;
 	     split_order >= new_order;
 	     split_order--) {
-		int nr_new_folios = 1UL << (old_order - split_order);
+		if (is_anon) {
+			int nr_new_folios = 1UL << (old_order - split_order);
 
-		/* order-1 anonymous folio is not supported */
-		if (is_anon && split_order == 1)
-			continue;
+			/* order-1 anonymous folio is not supported */
+			if (split_order == 1)
+				continue;
 
-		if (xas) {
+			/* Split can't fail at this point, update counters now */
+			mod_mthp_stat(old_order, MTHP_STAT_NR_ANON, -1);
+			mod_mthp_stat(split_order, MTHP_STAT_NR_ANON, nr_new_folios);
+		} else if (xas) {
 			/*
 			 * uniform split has xas_split_alloc() called before
 			 * irq is disabled to allocate enough memory, whereas
@@ -3960,10 +3964,6 @@ static int __split_frozen_folio(struct folio *folio, int new_order,
 		pgalloc_tag_split(folio, old_order, split_order);
 		__split_folio_to_order(folio, old_order, split_order);
 
-		if (is_anon) {
-			mod_mthp_stat(old_order, MTHP_STAT_NR_ANON, -1);
-			mod_mthp_stat(split_order, MTHP_STAT_NR_ANON, nr_new_folios);
-		}
 		/*
 		 * If uniform split, the process is complete.
 		 * If non-uniform, continue splitting the folio at @split_at

-- 
2.56.1



