Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4C9F606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 04:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YZ53phTq
Received: by kanga.kvack.org (Postfix)
	id E56416B0997; Wed, 28 Oct 2026 00:59:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE0026B0999; Wed, 28 Oct 2026 00:59:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0B196B0997; Wed, 28 Oct 2026 00:59:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9ECA66B0996
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 00:59:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ACDCF401DE
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:59:13 +0000 (UTC)
X-FDA: 85370830986.29.2098BCD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id F11FBA0008
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:59:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YZ53phTq;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793163552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hPBW/7zRH6GMUll1hA8NAc0pSWv7wG1/hRY77ehO/Hk=;
	b=qansRWJhnbtoK8+pPOPX2iZxAsR5l3R5jNEWbYKm2iOTL4rqCm8jHehcZzkYnbB1gNfqb8
	0LEsAj2/t/LG0fLvMxGdgP8ID1OnOlcI6SGWOridxItqh3f+m1Xwqpj91XwGOis4/n7x4j
	toCQH+RZCgLkJOFh9nesO6mDLql8PEs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YZ53phTq;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793163552;
	b=O7/fep3xTLrqfrXPDPeWGzEbEFrF/gNqlNLjC08aQOKLxF1vbfh+iMVw89hChDS5D4Z0SN
	BKXu4ZoQd65i7vhPXkjnh7nZSMZaQh6+WlsrizzJPrmJdu14gdQnbrqysButoyNabNC0os
	VXKUMx7hyCyOHpfefiAnhHVibDkqVJA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 28B9D415FB;
	Wed, 28 Oct 2026 04:59:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24901F031E0;
	Wed, 28 Oct 2026 04:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793163551;
	bh=hPBW/7zRH6GMUll1hA8NAc0pSWv7wG1/hRY77ehO/Hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YZ53phTqRYy50H9NdBl2+e6SCITiwm4R1hbz0W4awbu9Gyt/ZbaW0wmFqGd771/P3
	 qafFXo+1pFpMofv+4GBzjcHOs0aBa7hR1PgfrslTfDMlQmmR2gveO6uQ7iWE8z3RN1
	 zeNnjBheeKuuqgUgSDFoS1f5Rzs5cMTFBrWRsweiw4kbt6N/k7IUn4HN//xH2VXAdJ
	 72tDXn7BYd93Cv0SS+ZEin0lU1p7GuAlNR46X60zjWKTyfWuoOVZnZoFypHd8bALTJ
	 AbjGcd48jpCMonjyTOu1gNJ9Q/VTlrENIc/iJ1hKdo1u2Ccpk85wPOx0mGnoEDz0ml
	 a6Y4n/vRrHAVg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6.6.y 1/2] mm/damon/sysfs: put target pids for damon_start() failure
Date: Tue, 27 Oct 2026 21:59:00 -0700
Message-ID: <20261028045902.148624-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028045902.148624-1-sj@kernel.org>
References: <20261028045902.148624-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F11FBA0008
X-Stat-Signature: 17ppysfw76dsgkkbaftfwf1wgscx4t7u
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793163551-662497
X-HE-Meta: U2FsdGVkX1/sCv3SIU7fSp+YokKcxnkIj1gHJ151YZR4QWZfKUY4zYuc1TdCM3GKHYaNAU/PQq9BAoRT4QET+YwdA/8vfvHPG55K5WEkELrCuOBC8uZ7hZls1VfusaB3NpSkFrAeR38RdIjVnUSQVk4j+DOV9G4GpAm5wnwuu89ULVNvAsUzbxspZsltRYV5LajMnOle04wNka5kJrd8wl2cxutXkH1uKLIOEGp9FdgOgOqhL4dXGVuUmAibXXsoA1AxZEhXz/ZKGuXFi3V6xBmm868iwcSFs9nDc8K4EHx563DPBdlGM15wjvl86mDA0H9OhUI5ZCTOKUwN0g4AT29aylvSXX9o0dgBpfJr0A6TaoIWSoqAIGwC7HJi2HWeQnIfCNQpCriuSOl5pBT39SH3RiiRmBpG/Are2Hdqtu+O6WNErRwEjtyp/LTWm/EbV0PzGaFNFIzLE71ETA5q4/k9hOVmE7v6qGXvOJ8TXiOFkQ+P4hs/BDO88SwQGDUzUl/9YzQlDXBxieJXKSlxUfOIxNp2WAgGw0n3X6ZDYoxxMtv8rBRbjvZJZ2l3QaQIxQ4nsZPzhOFlZBawegp3IFmX5uk/I4CBTRTSo8PJ2MUG2e1uV/jbf0wU5ppandB23ZVNnU/64iZAYh9sjK29QUwj7SK/Vn9elDJP8va6ENJdBf30I5E7oiqwUjbjxbG4D3zhcgGmjtn7UZuPNekXF+G7ZhQM/VhGpC6Dens7Nnh573mhjqtU+oibRIctG2ocOkHuPgNhE7uGr4PdMkm/klDRcd8qVz0sUmlL9aDHOW+xMp91u0xF4MYVza6n/OUkvYWvgypxuk1Q4sHrlEbUi/Wf/9EIz2SbDUiZT1SLs5C8tkd9tXJmsv53+TwBZKRrMjLS+Wnz2GKgLUjViz7l0johQ9k09GDeCs5ZT3ZZB0/psles2ONBZqy5PiVt5EM6CPR3W/lTWJfEr/n/n89
 oA7bZkU7
 /NYjCjNl/fh14QAFQZEkrRKJJoydPwEPEGmeSqiK3xte8RR0GHhIXL8O7z/RHtt5Dw5+1vPBIkmiuWRVmCRV7eCX5alIMYOJTmJ5fYEIIjfwnW14Ari7PuweTPe/xtLhwV/jNUO9a6cshuGGPwt+qRz28ERpFZMoT3G8eccugh/Av4CGocSomxjzBRFSgndpMorTJuKmiUwQAvTKvvjQW18N8lHiupcy9/R7HTgsUPs0fW0kMVGn0TkvEptvHZ7TF/WMTEBfxt7m9AnilcfFk7PFocw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

damon_sysfs_turn_damon_on() allocates and sets up damon_ctx to start.
If it is for virtual address space monitoring, the setup increases the
reference counts of the target pids.  After the setup, the function
invokes damon_start().  If damon_start() fails, it deallocates the
damon_ctx object without decreasing the reference counts of target pids.
As a result, pids can be leaked.

Fix the leak by putting pids using damon_sysfs_destroy_targets() before
deallocating the damon_ctx object.

Fixes: a61ea561c871 ("mm/damon/sysfs: link DAMON for virtual address spaces monitoring")
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 46980a4bef23a..d95fda1054a00 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1465,6 +1465,7 @@ static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
 		return PTR_ERR(ctx);
 	err = damon_start(&ctx, 1, false);
 	if (err) {
+		damon_sysfs_destroy_targets(ctx);
 		damon_destroy_ctx(ctx);
 		return err;
 	}
-- 
2.47.3

