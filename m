Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18462606A33A
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 18:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=mE9H7XDG
Received: by kanga.kvack.org (Postfix)
	id 1D9F76B05C5; Thu,  5 Nov 2026 13:41:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18A7F6B05C6; Thu,  5 Nov 2026 13:41:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A08B6B05C7; Thu,  5 Nov 2026 13:41:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF4576B05C5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:41:05 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E40941A0A0E
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:41:04 +0000 (UTC)
X-FDA: 85401932448.19.75A6F2E
Received: from mta1.migadu.com (out-110.mta1.migadu.com [95.215.58.110])
	by imf09.hostedemail.com (Postfix) with ESMTP id F34BF140011
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:41:02 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mE9H7XDG;
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.110 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793904063;
	b=bEMVmz1PnpIbEblwke3clSbPglho1jhsLP23HXBsDUKPyw7VgownkDk9PcIEvenUZJ4bBg
	7aAKG32IbQctRFlNYrqhIj2B13qeW4OU1dJ3q1agj6yLKA6iASd34bOZ0Rv4fYefu6tMWg
	gTuo3mAHv+J7hVcx7Cv9UeCzMQnpGvw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mE9H7XDG;
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.110 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793904063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/8bJMm/sgf29qfCgUJsD1PwhcylKtHc9E7GXw05kMnY=;
	b=bYUoBF9tRpjxXHv9AtgL75gqOM4GUvfocPErhZjcdeqzxlOPxCVYLmKJbZC+xonThtRU4/
	ZiEPiF9hO29GkPt1qEdLnyfEj1E9pScIft24LfRuw1Vke2w2H5VLztJBVDM3XInwj7WiYS
	ab1mqnQf5kLCL0lY0G9cyZdnoRD+n5k=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ESJRx81IWR2zPX4rBwYm4630w/5tlX0IX9UcfPNoYB4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793904061; v=1; x=1794508861;
 b=mE9H7XDGX5gZLKl8/Qea0rNRfsm+InFi0SzcaH1jH/6cJ+ggs5etjJrbdnCI5rvMN6WjOx1M
 hIoR7upbHUOTKhD2B4mmk9RgP+Z6882D2gtMqPjh/i4BUFxqe4Ch/3Cb+ArOEITFXDFg/g8Chmp
 I6FlTjEUM+fRUGKEevlucTik=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 59e87fb4a13f42e8;
	Thu, 05 Nov 2026 18:41:01 +0000
X-Mizu-Trace-ID: 59e87fb4a13f42e8
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: chenhuacai@kernel.org,
	ying.huang@linux.alibaba.com,
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
	stable@vger.kernel.org
Subject: [PATCH v9 10/32] mm/migrate_device: avoid leaking folio references during THP splitting
Date: Thu,  5 Nov 2026 10:38:54 -0800
Message-ID: <20261105183940.2236717-11-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105183940.2236717-1-usama.arif@linux.dev>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F34BF140011
X-Stat-Signature: 1u8rwjhrdjd4qjfophyq73p5gj6r3qus
X-Rspam-User: 
X-HE-Tag: 1793904062-111739
X-HE-Meta: U2FsdGVkX1/sl5ZZbaeJ+JeXSEBFM7DJga1nEfh20BtcWED8uJB91r6CbBFNbb5ojDQJ5udsWR4G96QXF1GfPpr9eAN3JERUQatoTlo3jQyKgXmT9r3GFA1YQDfiSuJVrs3wqMxrl5x7WrKUD2Kb6mVyT861bPR7hzCgWLwreW1UbZnvG+aCjlWHkQoGeV39Rdh2LGxnekyE3EwsPsHlfsqY6Q2y+A49wxa5d+PdPksfKtv2kh/o7+5e+osVizeq+CD/o04hZf9HBkC+ZcGKPxA0JOC5epWqY2tAwxh2yKZKi4Qu3TgXTRxYVrHP5sYyMREVS/MLrbqk7YAZFnRxdSk7LgWTrRgwTLCO7mUY6rJDNHE+84jMTpBjexeeE8Zjp6srNxvaKd5Qhl32K0U+s5FHe9KGeayt/qrX98ziI6iUB047Jsbpa0kdtLNg+V3IEAv8fNAJtvltGmfUXyng60puy8bMW2g48hTEyT23f82GAxCgIP8tUYW8ycFvN8RD5vOAv2keOi+UGHjNNvMrLbWyOAkGxZlCYipvFZmCjyyFQqus4i5v2oEqC7I4Hs+WPdTmPFNXZSnbWT+3P2kiuJhDcka2dOtruJ3CS2Thm0ssIV9P+sFkkmKg/ifFZVZPbdDu3NuO0or43G4aFHz84SN2BQEalkAI2J5EQ2hWWn3Csa/pHnlb4FcZc+0YqBUdQCEOUMWq+GJUVACVU6aeSvXsGUPPlsW65u93LWoiCCxg3ABxDTCowfVVKYmx4ZMYW4h1DqI6otLlodCESuf9lfr98H5tHtJQitjYC/QtN8dqtP5XUE2N6TsFzmAvAmEgX7yn+xyYchdO2WRcVFEv4qz0Tebweugn4MqzplVTH4Zd0mu/C1B4HxUVpeN3rM0r5SSaIQ+eBrt5gZVPNcd5s/OwwthWOHLZiHv0osT++YsxuFGFyAceGsyWL6ozWal5JdlcFiV/S9nZT9Xdtaj
 qcv+Z2fQ
 AULDHBlvMoqq89RFaV4OJNv9a+LqIDbm0q7c6Tg0d7k/5N1u0+Zwf2eoVp1yiakgjiZKFVYAYgImEzFTg5Y0ZqxX/xKJrr+6HURR8MOUrgdSYJyvVWwqRuGzfAmBS3+1yTubTU0HGuFpQ/trQU7hP3Td4Ew/LokUjkGcbaPbsofqImsHR7bYOJNj6UlymlhHCQslq0ZlRPIBDL8B9purU3enSC6/v70pUzOQhNnguNS95uRoC4od7U/50o/qo5GgBdBn1+Lxx8f+QkI/iGzMfC9LJiq3fga4h0QYRX5Q9ioOI9wk1a1LmiJ1Yz2OqzgoE+Meh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

migrate_vma_split_unmapped_folio() takes an extra folio reference because
split_huge_pmd_address(..., true) drops one when it splits a PMD.

However, migrate_vma only holds mmap_lock for reading. A concurrent
MADV_DONTNEED can clear the migration PMD, or split it into PTE migration
entries, before the split helper takes the PMD lock. The helper then does
nothing and leaves the extra reference behind. folio_split_unmapped()
fails with -EAGAIN due to the unexpected reference, and the reference is
never dropped.

An existing migration PMD is expanded into PTE migration entries even
with freeze=false. Use that mode and remove the extra folio_get(). The
reference already held by migration keeps the source folio alive whether
or not its PMD migration entry still exists.

Reported-by: Zi Yan <ziy@nvidia.com>
Fixes: 4265d67e405a ("mm/migrate_device: add THP splitting during migration")
Cc: stable@vger.kernel.org
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/migrate_device.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 9e19fadfa65c6..3286bb8a4b73e 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -920,12 +920,7 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
 	unsigned long flags;
 	int ret = 0;
 
-	/*
-	 * take a reference, since split_huge_pmd_address() with freeze = true
-	 * drops a reference at the end.
-	 */
-	folio_get(folio);
-	split_huge_pmd_address(migrate->vma, addr, true);
+	split_huge_pmd_address(migrate->vma, addr, false);
 	ret = folio_split_unmapped(folio, 0);
 	if (ret)
 		return ret;
-- 
2.53.0-Meta


