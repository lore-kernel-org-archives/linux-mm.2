Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEC58FF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 10:27:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E37FE6B0005; Mon,  4 May 2026 06:27:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEA5F6B008A; Mon,  4 May 2026 06:27:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFEB46B008C; Mon,  4 May 2026 06:27:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BDEC26B0005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 06:27:55 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 56B794010C
	for <linux-mm@kvack.org>; Mon,  4 May 2026 10:27:55 +0000 (UTC)
X-FDA: 84729361710.30.F9762AB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id A52FBA0007
	for <linux-mm@kvack.org>; Mon,  4 May 2026 10:27:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JFUIFciU;
	spf=pass (imf25.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777890473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=PLRTjFWBKckG37I6yYxV0GSOFolcA5HXN3IZ90cH5NI=;
	b=HyZrkM502TKSrKfahxi4Z10pGRiBOwqrUpdr0N5SF2l9Xs19bIPRok7WiUfKhGSUtHp3Im
	KoeSDaINiM3wm+QdRQnl4sP+8VwBB2k8f9bAn4rFwD5LhbtLgqKit7qNuPgBRbUwAOKIu5
	TYm2jImadHX72hnJRwVLoZviX3CGwN4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777890473; a=rsa-sha256;
	cv=none;
	b=Bm9eqU35v08kGKkmrMb6mLMrYZl6EIGQa5lP9pBkMYo2r1TgwGA5a4SKjERS07FxKCsKPI
	t2wA+HMEVDycHguLgmfNakwyZ0ZSnytDeV0cJ2dZ1Cdmt/JfcQPTqjashOocFgaVikcQEr
	pYET16cP/OZWT6PMuq/97nCr+6aL8C4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JFUIFciU;
	spf=pass (imf25.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BD08942B1F;
	Mon,  4 May 2026 10:27:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EFDDC2BCB8;
	Mon,  4 May 2026 10:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777890472;
	bh=Lm7HRhztFy2nXJJI8dsLt4KOHWAxV7mNAACnnwK3Ulk=;
	h=From:To:Cc:Subject:Date:From;
	b=JFUIFciUSLwWOa7NdBlXoMOUqRJnXRW3JpBH7bb0mQP5HKAnyucIXhWo36zrzUid6
	 xhxoFasBn98GpjRnkeBg+dWhXW/uUPdy8wWqoYQnyrV1FR6IMJf1xBw6bnut1ffovc
	 0a18Svg8rvBHBtEDIMTMGlkCQfT7F7hWF2zdIGVe8oGQuflhBX0vTC1evldtBn9yVA
	 2/RKkrbLLZLiavZ9bdEbjEdHd+2FOBwHg601JZHamnHDrq10naFpBsaplQNTNh/Ys0
	 CNy/poKpl2XOOlc89xa30jvq+64VR6YgLr76amDqOI2l1/gsrDRaSu8SZcuOM/d1cb
	 Gur7ELofq+kYQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Clapinski <mclapinski@google.com>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] memblock tests: define MIGRATE_CMA
Date: Mon,  4 May 2026 12:27:40 +0200
Message-ID: <20260504102742.3833159-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A52FBA0007
X-Stat-Signature: nu8sigqa68a8rhjp5t5bdwwko5anqryo
X-Rspam-User: 
X-HE-Tag: 1777890473-661404
X-HE-Meta: U2FsdGVkX1/hCWNjsDmJoucygAGSI2VLryZvU3hYSqTUNN98blC9CaP6lqlJ9lzJaisk9fGcpJkiB+KZIjafb/opVIlQJLL1j1F2ltsdZUorgVMnIfbM7zC7Hy+8ETVwphHt7aHsxI7q89SgycxyhBTOVBJs/RdWihuwP249gbiYBEXLottfE2q90yr4mwZbPS+RQ4H6AB7uNd9UceC+xDNfGSNcnhZPlYr+dFoJYYUlwSjLIMJddygBUoN8l7HcNvxev5tbIFeBuP0XfzRk0+HvHn6Q4SL99hBfdcHQ02ooWPWQP0cLE6Pvl0GD94NIRDjQ6wwj4JrtbeXMX24H0pYicbIYZLtqQYXH3O1/ECh0D0jMUF3idViLkdxgux7EORBIOAE8b+PpLbDZ38S99NlXgg4/CoMfMJT3FiCGmG3i6MoMLvNbf2id9lQ+qVS57ejOHMYwVRab3789pr44Q8QzUlaFGDTm+JObxKOphAHwCABcLbwkoWEGqrGJ6ZSQrkbau8Ov4NRvlV0PLtimewt1PfQ863N3dEYAtg6ZkEiT8k8eZheASbODHm0Z35VRsh+3sBN1s5ONEhAXtU0wDfkQp0IzuXsJESeL21xJ3R0KssC71P7N0+9jpHu/cfz0fFIICZPGm3EOaN+0iH949CgUvKhRHHM4afLPEFUiDO32S1m47ZiqAfQX6uK9KGaZBvH8gTTFI7TfxY7EUCh82BqgD9PFGj6hviGObihCmFuNeJthg9WJoQb97+AvAuNJo4vjJfTYInpGklfOHcl2EJJrLGR/V8eWJBuGyTgfkAQH9f2amQwZlpi9sEhoPUsH7e5goSuKiJ9Dmr0pSzzoaTvwesxV0N4yeiKW2VZd97FVGkJImDeP15N2RUNlrlE0qp6YfBTjX9iHu2aRKADHa+8jW9a7DsQIITeOBu6TRMo1NYsvij244jUwerLTQrhDhhuNqpYnVB0x/uUvoF2
 4rw7Nooz
 xt/vbhU11FCkTlbSBLn0MR94VCoLr8nnoFQ53TZ1rDGtYKiccgGXsJliYk3f84JWmqUhN75I2/suDveagYFj00lWksEMTX68ktq0l/0pOdEXz+F2xyHDaOB+vw5X6SsrPKu++oNfuCU8LQW80r52ahKXJCluKa0Mu512DDemyMyxP9ZKJkn4pf5ADL03ESFQ3EotckYeJ6Z/bexsIUPd0lPgqqAlVbY917ovnWJVCKJdz1L4mQpPE09TGHe2sN2ApwINOZBqs4bKrWzy0ayOUQJc6DRzEVRGQLArCYrdsp2PCGO9ZqzlmSPuj/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

kho_scratch_migratetype(), defined in include/linux/memblock.h uses enum
migratetype. This breaks build for memblock tests with:

./linux/memblock.h:634:73: error: parameter 2 (‘mt’) has incomplete type
  634 |                                                        enum migratetype mt)

Fix it by defining enum migratetype and MIGRATE_CMA. As is the case with
the other headers in tools/testing/memblock, do not bring in the whole 
thing, only what is needed.

Reported-by: Mike Rapoport <rppt@kernel.org>
Closes: https://lore.kernel.org/linux-mm/afcdDm4aAJvNaQqH@kernel.org/
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---

Notes:
    I didn't add a Fixes here since the commit hash for the deferred series
    isn't stable yet. Anyway, I think we should fold this into "kho: fix
    deferred initialization of scratch areas". So random bisects don't land
    on a broken test.

 tools/testing/memblock/linux/mmzone.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/memblock/linux/mmzone.h b/tools/testing/memblock/linux/mmzone.h
index bb682659a12d..8d934ff5b080 100644
--- a/tools/testing/memblock/linux/mmzone.h
+++ b/tools/testing/memblock/linux/mmzone.h
@@ -35,4 +35,8 @@ typedef struct pglist_data {
 
 } pg_data_t;
 
+enum migratetype {
+	MIGRATE_CMA,
+};
+
 #endif

base-commit: 74d1099bb4edfca3ce6edc61dbacbed96720034c
-- 
2.54.0.545.g6539524ca2-goog


