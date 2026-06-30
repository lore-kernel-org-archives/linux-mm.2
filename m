Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E27D7C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 04:09:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 311516B00B5; Tue, 30 Jun 2026 00:08:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C1F36B00B6; Tue, 30 Jun 2026 00:08:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18AA06B00B7; Tue, 30 Jun 2026 00:08:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C723B6B00B5
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:08:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0C2711C2AA8
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:08:32 +0000 (UTC)
X-FDA: 84935247264.17.54542B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7D35B18000A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:08:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dc7YelDd;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782792510;
	b=cV2woS2XsJJrou7JshLjfg88fOkcn6DsgZnrG889PO+dL+YIDQKw8Wep/AMQuvuw7lEtLm
	Jj8MEPKd7pEV8wWDr+pDh1DpL6EBG06beT1j+7/Uwjx+2SSVTBDjZY/eLd1e9dFT7lrnmk
	p1m4nimDqVdo0bHlESvjuQdiXw4Z9O4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782792510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=skYRzDOS/foSXvMB2iD1p2qAPqi0rQnLSDGnJ62RQnI=;
	b=b8G98hNQghdF+SdKUnTnCksixmE9+/DyBFfLf477YQJchs94SCvmE/cWL42HydLYSPCjw9
	C0eduXmuo0wReTkSfdy/t3sk9G18WaGREDLzBmwWd/kHm5TgX0IKN7t9lJBwqITsOQDlDh
	0xMk9JEc2uw8oJZ4fdficrKnvhyviKU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dc7YelDd;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D216A4194D;
	Tue, 30 Jun 2026 04:08:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60BDA1F00A3E;
	Tue, 30 Jun 2026 04:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782792509;
	bh=skYRzDOS/foSXvMB2iD1p2qAPqi0rQnLSDGnJ62RQnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dc7YelDdA6DB63nkfnz7k8p0edIKaHqIlj53qT4gEzVtO+rbRBUrMI8rsysDHpjve
	 G3r34GU1jSeUpNC/gd+t6fuSjnToMBoVCS7CD+QzgZHCAHWXRN7cRBxrIDwssbHkeU
	 S/XiPHXppFVamRggngbQv0dJGBnB/tGuEKyLgJtH3sXRnfCs4eBSNbuY+NlzkmxkK2
	 nZVsGU89NxoOwbFysBiyXsZ4AUz1GJOSM5NNSJ7mIvDekvOFTuY9/nZ/QpSzjEDF27
	 N+kHG4hOaOqVGD6b2rAqc2TDGDVKgEC4YipicJMw4a3aNM8EPyymK+7Tc26QH+SDQV
	 sYMkn2INmSsvg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 12/18] selftests/damon/drgn_dump_damon_status: do not dump nr_accesses_bp
Date: Mon, 29 Jun 2026 21:08:05 -0700
Message-ID: <20260630040812.149729-13-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630040812.149729-1-sj@kernel.org>
References: <20260630040812.149729-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7D35B18000A
X-Stat-Signature: hgc1zmbqsogn5k1x4mwsefri3mjbp9w6
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782792510-769696
X-HE-Meta: U2FsdGVkX19F0gcf8kz303MGt9Zm1+RKJLtd/DndZ2KDNLt9a3PiLiovVtQssWY7LnLkcAvrW8aiFQbTeVsmDgIfCKjSKAYF1HLRnk5QA97sB7O8bv5Cxl4vpQCwo/ppG4NFT1ghLU9HPfEllKpdfcjzMNDH3Kqy3ah7FOMAkCuwf7jfVJ/sY5Aachsy8DPnr0itNGv+Oo8tmhOUzCIsLUU/U3wZE4RbsfpuE6LLpfWnnByw6HbO8kLXOcXuPTgv7JclS9piAFYrkXo8IuilN52zsGJk7SUreReURkidcKCPGh0mKIdwV1WPk0kCkueDwBB6JSzzILUAz8lgzF369dX25pKX0ZJea73rXrOPMxmLvRg+HsP2rGFSYCBji1Ib5nBNP/toVoH8FoPKezVS4tfCrKAtPmzdH0PRtGeayVt/pBaiWdKR9d8VJuJj/YAqDF6ikFBcR5G0MogT+uooX0ytjytl2wme6BeD3EybcPfcObaFiHIjCg4d0qz1tuEZYesojhjmxfKmMP4yWElusjWnYi7kJDUnVi6KZ0f3AmCL/CcK26hQLjT5ybUaCS1fXvBknGzYqNriG2zyJSN8y8JJBC4Yh0O8RNbDlvb5yJv8oy2n4FO3JDkUxdocUyfV8+hd48JhoYnATHU3KTupo07hzeyivg13w0ZBw8TDtvz6thjoOUJl6R+LHP/TWEnScSlI7xZX+C4BtBQiLcxwSL8f8o/IqPQCpAaYcoQNzr68Y2lU8Qs3NgQqrW7qfU0C5FGt5kRB+5w8LYEL86W3QvBLwo02wSwm/IliWJPCemWwV0Y7LYDv2SAHVBLLMBGGphlzWslYsP0D+usTx4QRR63NRVzmgmDhAFkVeJ4fAbprbuAK13BZ7vRlLqpa8LPmMMICTNA/WmzN0aMtR4cvOm3Xe9wy31EFibzfy6v+aX+t+PoicfrP0I7FLzTeNMAf4XlSfgUmH14L+EHcuL/
 T8Q5/+xo
 NxidYqXXXMuGHG3VI+UtxGmmeNZLwVRh3u+p7e/Xc2+QivloBPv/SHb73j1ShlWFq+DzRZ429nS4iOdb6C78nOaMDDMG4mctAiL5JETC4zg2l67kDLZsi+CI2OI6GUGaRbAcaH9hoaCI6yqa/6SsJzn2jXk32nqFasmxV0L1vxaFiDkl9+91b0UVp+qRYfZH1jMR0UFN2PhiZJiJevteVHi5MIwO4CcuTUmwZ9WtzvvodFvkvbFIiM8WdRd4S/nAim4i9hUsDUdyLKzVoWde9YCwJUUkw6+3z40Pj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

drgn_dump_damon_status is dumping nr_accesses_bp field for future use
case.  nr_accesses_bp is not being used for a real purpose, though.
Hence there will be no future test for it.  Do not dump it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 tools/testing/selftests/damon/drgn_dump_damon_status.py | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/damon/drgn_dump_damon_status.py b/tools/testing/selftests/damon/drgn_dump_damon_status.py
index 26b207e44268d..09552e91bc782 100755
--- a/tools/testing/selftests/damon/drgn_dump_damon_status.py
+++ b/tools/testing/selftests/damon/drgn_dump_damon_status.py
@@ -59,7 +59,6 @@ def region_to_dict(region):
         ['ar', addr_range_to_dict],
         ['sampling_addr', int],
         ['nr_accesses', int],
-        ['nr_accesses_bp', int],
         ['age', int],
         ])
 
-- 
2.47.3

