Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78320C98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 02:32:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 857F66B00A2; Tue, 22 Sep 2026 22:32:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 808666B00A4; Tue, 22 Sep 2026 22:32:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71DF16B00A5; Tue, 22 Sep 2026 22:32:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 530996B00A2
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 22:32:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9B58A1606C7
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:32:03 +0000 (UTC)
X-FDA: 85243452126.01.13AB9A9
Received: from out-2z4y-a131.jellyfish.systems (out-2z4y-a131.jellyfish.systems [198.54.127.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id C4C351C0002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:32:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=JxeV8+Gt;
	dmarc=pass (policy=none) header.from=tychen.cc;
	spf=pass (imf21.hostedemail.com: domain of hi@tychen.cc designates 198.54.127.131 as permitted sender) smtp.mailfrom=hi@tychen.cc
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790130722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r5BCBsILvYpkCei8NxC2nBexoyGfpFRtjZRXstiHS3c=;
	b=oFyoZIAbG5mak9njadmEz20ZBbzPKy2OWLv0cnAl9HKBxYpEOwC1ogSU3kGfBpISazfO5l
	DFzN44FBiBnQCzMtH/d9eIdk/nFUmb+KxE1FAU2xUillZddj6sIQ5sYh3u882+fwdQF/M6
	MofZhxJadNv2elTPZvPxlv+CrVNfBKU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=JxeV8+Gt;
	dmarc=pass (policy=none) header.from=tychen.cc;
	spf=pass (imf21.hostedemail.com: domain of hi@tychen.cc designates 198.54.127.131 as permitted sender) smtp.mailfrom=hi@tychen.cc
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790130722;
	b=CI/vpY421lGJmI89dn/ro5lU0Nh051NsNfaM8vt/QFxUwO7DU+W1GUY3rd93Ch3bpfu5zj
	rIaieSpmWjZH0ZIYvuXZ/dD35gs2GKBnjX/hMWa4aHvKbRmSX+PEXqD/Tp0q3Rw/vlmVso
	mLtoUJTF8HZyi6RYGR8wxHLM+9MZYdQ=
Received: from fedora (unknown [120.199.7.38])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4hqLZW45MGz8sYH;
	Wed, 23 Sep 2026 02:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tychen.cc;
	s=spacemail; t=1790130709;
	bh=r5BCBsILvYpkCei8NxC2nBexoyGfpFRtjZRXstiHS3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JxeV8+Gta6mPvrkqBEcX7kwlYEAqpPcPO5yJBmlxp2MWLyMY9zeRQhNoPUx69Q5gj
	 fgfZCk0mgSYgRKQDuKntGl16gTZQC+q7m7a4bN2goCXzbRjOz/ZQpj0OAC5lg5l+nF
	 NxB8EjwKuB1EvIEkwzUrFZK2ZvudGhURT/E+53XQrJ4YFL9Jj/3JK2pN24rg7eMTGO
	 1UIw8wv0506cABI7dNCAoeidT4/nQTr6L8qJ7Ti85cSy7x4O96egJ4GEwjBQ9phkQk
	 3ykc0JQu5LrqD+r4T5v5Fd6Wp8VIrnICCLH0xOyh2lAv9S1VE5fjabpFUQ/nVsa25C
	 abAFNQ8fO/4Ow==
From: Tianyi Chen <hi@tychen.cc>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] memblock: initialize the region merge end index
Date: Wed, 23 Sep 2026 11:31:26 +0900
Message-ID: <20260923023126.1910311-5-hi@tychen.cc>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923023126.1910311-1-hi@tychen.cc>
References: <20260923023126.1910311-1-hi@tychen.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: hi@tychen.cc
X-Stat-Signature: ad586to8o7875notap3rhdgo1kch4677
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C4C351C0002
X-HE-Tag: 1790130721-386923
X-HE-Meta: U2FsdGVkX1+Y21zKSxkbG6841axJCJlW4e4WwojgLWVo6qLGyGTsJTIy5wHjEF6k4bngMRIBiMRfRTLCAcHSbQjcW+tPFSanDgFjgNDnPP4DbLC1cAuqfLNAUY/UxxA+zmnZp25TTmvPH2xE9HaBcJHugPVdDw7SW2kSMGNq/LZQDQofWNj/c/73JSmEDrLIi/ZucbT2vZIC8vJhuQJV9u3czsU+YzpDU0GX/7vSP8pmYEYbA6T2zsipIsl5pviKmmcdnQx8ihzENFHNYd4FK9msZay4XgsVtBNO0s0UvxNID876LK2p+2g2nYLQpaV7Z9RKyJesvCrYr0L7OGEXuAK6juzfUbE5janV4HfKn5mHmcATTRu2H4wo9mUMyDJrg6FNShEz+8zSQ5bjZBZRWqvtJBjl2X4AXITm2zcGCQvaMWygAl4UZimVUKp4fDgHxE+QaeBgXP9aWerv2SC/Qb5ytcAV2tOebfgoRX1fqFjk+Ms0haUHOqeLRUGlWhrQsFd63sNOLzhUS/yMn+bO0XA7xImOyrCtAaVKV1d/+0qNJNjtq/gj+BUSPPVLbca3bxiWU8uJL5Q+CtUiZE5qwH8OG65DNg9NazAQhKbd2PqVm2gZ2C1BE2wiZMFEPOsQgcNrzoId3ZYrQKS0RAanTq2wN/q2+TYCji5++MiM7BiSjaEvqgBjXviMchg7m2/XFeKnGuDWsZnHgGWUBTWo3DRo3dB7pjYlAHmXr5OzWkSkzHFj5m7mCurvcjyzI91rD5TpyB/rBXCb0TUgGW1rKCp0vwPVi21RUX01yrs3aFKxVYnFybX+DedaJ+qc03lEZdGexOJMzkgBka/uTznqmP4xVUe4WSF1TurdWDKAH0mmrBPYGjeOzr2R/pSlOlcFD5ZqKitURUMg0gDR1Au1cZzckqCcakpHUM8OeqVUK/OxmAUH1EpDFz5h+rgiPz4VExsZq4ai8D0/geZPFKe
 MMhlKhAy
 AZeMUneVenV9d9w1C8rB4XeeLzNJZ2uvdTYUV/oqYHnw6uJZQXse+gQFYmeKEOhT0NLViBlwHcn/4nQjPrRv4iMxxHY0TVEGgdj5+1/p/gSnGx7rXLVDGxVGBEa8Dw3AZkRaA9wpdFq3aCG4EvDdviQyUJcRkrvBRKPuoeS9VuYolYCCUNKuEnHpltCCI+J8EfJhIHsK2UwHAbDVCmNEvpp61uFTeLtkpOfwleJRRmC425A1NkPzJ0QY8N0p9WimoY1/XGPoFMhv6a5Fzmxk4bX6qBnbfcqInCdZhR5yJ8/I1n14XyYD/8e0WQW/EHI1V8M/IxSI0eCjKguNugdLf07GDKfAiHxXpGK199LxlUolGXeYzShpl6jpHPx4uyOzos1wA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

GCC 13 reports that end_rgn may be used uninitialized when building the
memblock simulator with BUILD=32 and its default sanitizer flags.

Every insertion sets end_rgn, and the nr_new check prevents merging when
there were no insertions, so this is not an uninitialized read. Initialize
the index to zero to avoid the warning without disabling the diagnostic.

Reported-by: Mike Rapoport <rppt@kernel.org>
Link: https://lore.kernel.org/r/179007180279.508753.4595268983388589280.b4-review@b4
Assisted-by: LLM
Signed-off-by: Tianyi Chen <hi@tychen.cc>
---
 mm/memblock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 22d14a637f24..aee1fe36130b 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -614,7 +614,7 @@ static int __init_memblock memblock_add_range(struct memblock_type *type,
 	bool insert = false;
 	phys_addr_t obase = base;
 	phys_addr_t end = base + memblock_cap_size(base, &size);
-	int idx, nr_new, start_rgn = -1, end_rgn;
+	int idx, nr_new, start_rgn = -1, end_rgn = 0;
 	struct memblock_region *rgn;
 
 	if (!size)
-- 
2.55.0


