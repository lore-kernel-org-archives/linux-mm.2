Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45E35606A338
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 18:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mqRXX/u0
Received: by kanga.kvack.org (Postfix)
	id 3B7BF6B00EF; Wed,  4 Nov 2026 13:28:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 368BD6B05B1; Wed,  4 Nov 2026 13:28:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27EE36B05B2; Wed,  4 Nov 2026 13:28:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 032BA6B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:28:51 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8E216A0826
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:28:51 +0000 (UTC)
X-FDA: 85398272862.02.165ED93
Received: from mail-yx2-f8.google.com (mail-yx2-f8.google.com [74.125.224.136])
	by imf29.hostedemail.com (Postfix) with ESMTP id B9CF3120004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:28:49 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="mqRXX/u0";
	spf=pass (imf29.hostedemail.com: domain of dennylin0707@gmail.com designates 74.125.224.136 as permitted sender) smtp.mailfrom=dennylin0707@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793816929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZfV/MIPNusOwxGNpLw6806W5l7124cFpZSpiDn2muzo=;
	b=OyqGeOHDv+mlHv+TSxSmlf1xDJXiKvSgiCGXDQ3bvMnQV6y0gxktysCrDVkT4qEtCQwGZZ
	3sBPGBUeUKcUuQHYbWOmdTLVxHMQaWhe9ouEa6UyhCFNJTe3GTpanB8M8qRowl9KD5Shag
	APBrgNbCE9watplShXU3tOi1zX8LJz4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="mqRXX/u0";
	spf=pass (imf29.hostedemail.com: domain of dennylin0707@gmail.com designates 74.125.224.136 as permitted sender) smtp.mailfrom=dennylin0707@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793816929;
	b=AyDPN0DohA/YG8S1+msMSVJnqhZ+bXoxp2NoQPe5jb2E7GVrMJ4Mt/j6SADN9w02ojNjnD
	U08lxlcAQUlRLTis6BFDrSctPtDBp7Bp+t2YZLQODsqjkqCw3Xeta66a/43U4HMKgv35BD
	gZ4+GrJzkfVBFRF2xNyIlFlSaqDZ3ns=
Received: by mail-yx2-f8.google.com with SMTP id 00721157ae682-8ae660ffc4fso3682547b3.0
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 10:28:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793816929; x=1794421729; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZfV/MIPNusOwxGNpLw6806W5l7124cFpZSpiDn2muzo=;
        b=mqRXX/u0M6pKFLvZieKYzl5okGfLN6McH8OqspsqD97iJHIRAjOotv6jUx6Rgq2ipA
         pORzERZV4kSeTXCpFY39bqNlb/xtTISLIbisQkTUpcJJSSsF1SeEMmPr2/1gNZ0+jUJS
         SvHlBS0iqX3/8aYS7HHB99F/J9/n+Qqg0Bi4UJ1E3y1o13By6HMndUh3Ktu77iyJ7mId
         qICzZgkPGxrf2wPJJIgkWaFjBH1rXI2IS/N6Kd71rYnjDF3nEQ74Io/qVfprj9i9R2fO
         vaPNaIeeqW2NIZQQWhiY9ZleI9rfi1vg5Ov07U3V/dqtNZNH9R2TuWAP4xPR/j9ieHw+
         TVcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793816929; x=1794421729;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZfV/MIPNusOwxGNpLw6806W5l7124cFpZSpiDn2muzo=;
        b=aisF9/voIyNQcsbvURIae1GmjUL16Pfq+MA1bCURW1e/dx7KjcT7u5TDpp1bi6ieog
         9XKpSrEpO3kmqS/WHWEOiGX7TpSPJLMdI+HnxB8MijD9RBNJN7nveX3NNeUaqhdz65E6
         DhpnG7GnpljFXTQa4/QEQdfqCIdN7BuiPFCQ5vXy3eVsjSEjDCDXb9J134fXYgy0T10S
         jmH2SmypeMGnsEOO4+YcVXULaC3pTzUm0djmlt5RmBqxIV4fdJvjNW7FKTHDjwKJaXLt
         DvBpDW4/yBCXTHhkwSN0JElsB8mSSfV1dbv7Rp0iuuGeZge4gzsm2C5E/IxWi25n7zGW
         nR3Q==
X-Forwarded-Encrypted: i=1; AKwUvBwe23GErD/lwjnGQOnGMe/Rd6LjcdUo6li3zH5UGTr6NyuX7n4PJzEsVbEtNXvCJsQOcAVXXlz/zw==@kvack.org
X-Gm-Message-State: APuU4Z9IuCUXBhHgiGvRJuK3csols1dXKQQF1UKTkk6QdZybJ/iCix9z
	l4LOo070NAWTczMM8zHyFM7Onv2gL94EVxkiDh73Qnd7BYbu4+ZHIRm5
X-Gm-Gg: AYBFou3EKnUpEJtpBJehaQOLWBrjxGpasSxZWR4ZrCL+AIxI1U+SG91E8Sz85b36Y0K
	WBMjLCkb3YNeKsjSNydoXMmtISvbUQP1UUdMh8zPvj+VWr2ZPDgzTEZNQm9kp/iLIcOFvQA0FvG
	CSSMKuPyxw1mp92nXI4LHlBFHIeVtb9uIlDD7Uouk8PjBvl0FaEBUzlur1BQd13+6z7Z0S9H3ua
	H1jP/WWVqnjQA+zxJvKkUyY490wUHyRDOkjFlwTHbh73le8N9QK2jx/SUd5imA4bIiS5MIRT5ZI
	SvMD/ZGDg2mERj/eYCgg+AWnIskXSP5jENmHlZidCR6u4jWa/wpwDrReACo98lOGPdC7haEa0RL
	BCJ9Xuq+XeActyZXloAkc0YzD5TFsKtRnPI2hcDuFy5C44X8NuzQoHcfh2F2/o/z3ohjLnFQGmz
	GMTHPlEfBfjmtAXMP6sj8RMvaRs3y+d9H2zpC/Cp4JKs9yt5LD9G5O8avbMJ7duUPZGOlQkVncH
	rcWA1fWx2HkYPba2eJxMeb+avWj5feTBOMcGrwIDXGeAy76/wDDN9dIt9H13auGoZh53U5biheH
	MlI8gOa1TaW+NOY8PENDRNawRzNCiBgSUfjlhueYhVIPhhnr9Xxko0VW//OAuE3GfKJuuBG6/hU
	s2B//nS/HEDyHjaQGEnr5cTS6ZaatGcxIeiJveZ8NWDrODSNqFutqaw352HI=
X-Received: by 2002:a05:690c:8f:b0:8b0:acc6:8e89 with SMTP id 00721157ae682-8b2b66ce839mr104568597b3.11.1793816928629;
        Wed, 04 Nov 2026 10:28:48 -0800 (PST)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b3099291d7sm24336017b3.16.2026.11.04.10.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 10:28:47 -0800 (PST)
From: Hungyu Lin <dennylin0707@gmail.com>
To: willy@infradead.org
Cc: jack@suse.cz,
	akpm@linux-foundation.org,
	lczerner@redhat.com,
	tytso@mit.edu,
	hughd@google.com,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hungyu Lin <dennylin0707@gmail.com>
Subject: [PATCH v2] mm: skip empty finite ranges in truncate_pagecache_range
Date: Wed,  4 Nov 2026 18:27:00 +0000
Message-ID: <20261104182700.88789-1-dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261027211505.22044-1-dennylin0707@gmail.com>
References: <20261027211505.22044-1-dennylin0707@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5ddyejh1fusi36q6i76jctmk9u38ste4
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B9CF3120004
X-HE-Tag: 1793816929-288430
X-HE-Meta: U2FsdGVkX19kqrgWF/mxGWgMygO/jj60FAlPih690uLTRKXGjjsZaC7VYzQ/Viv0/CNBr67N26A4NIC+dkN28jl0zJgrY7kYjjfwljTHIGl66h/KbTPbjLZj7k6Ydz4RgaTHLkO0ohseeDFSQDQLZ/BfekRgoXSvKrDuxsJQGaCHAQecDfRzvzYtV+SWEmfLanj/BcJPV3D19iQEy73xQyqFEmGaqEX7EvhyLOMuZMJeF/4MSoZaeLZ1a17iMvEMi48gwmTGgxVKGHwHRnrmlRKCupQ1uyCd8ng/c0DtwFDfciKQqZ/PIanSkdQXQNhjrOnc4WpxhDwKUnfjpqPZtZUPxy4O6sgUqXUGudGjp4wa6xvapb8k3haieEj8+aGkEp7Bg/P6uKFJPSMvAsYLTUE6abmsKAxq2DCZGpSs7yevL9A63DQj8j9Hwy0tt8lIM9T0I0h4ZhDlEMJKQ1WcU+Bz6kpJgE496HGKAvrUt2lDKupqhwYHMoPNk6uoU/F0sCz6VIJTEVBR/kEAcOfDuG16YHx6aVMLGKzCGORZ5uF/nIw3w5DOTFSPx9+KKFCtbVozQReUQn8nls/qdmlcCRQ6B5vbVi+Rl7rXau+rOD8HoMhiG41PoCb/bsJr6e9FG7mQCBy+EHa6RyvUbaLfF0SKwglGFy4798ZJ+bOb1CBhPJ0zpbhfME+vBMTJdn/pfM9fpv6IfIkrUnDXWhWrdZwkkfh9GpwtILHrdI5GaPlv1pLLePxVPvNM7XSObORppVg+W2oY6q/X73LRVWOFBOAL4LErainqcM4jDsdYfZ6gU2Cy88+wmK1B05lV2V0iKDWV7iy0uIxMagN4K7jH0bRQ1V6h+BC5P2q7vvT5KoqFo2+9VbCm1G5qwfqf6AH9bjc2aMFc++3yp1LcNbAm2rRq77O4Io5ZRTeXlABfiOr6sTMTID+f/UdgocD+2TuENc3rpUMoJOmDlXH+er2
 +Lj2zkmY
 63qebvAnW0Z9Mx8Z1T19j+dpW510mTszM2PYLwP0W2RqLY9mFzm8ew80qbXQxaMre9HtICgsb5Cqz45g1NB1PGmqKiGqBwHZIIw6qYZE/avARPKhdCABr3O22KtZZLi41bHQ27oz2nUPt9fJIAkv6EjFnBFRsF74MwMscfg6ySaZ5TH+CmVIb+ACFk5GUCh8tQu1l1e47Sp54eD6Q8sgaUJCQSZ++LNSwC81tbUN6ZUF4nIuV01PTEssyHPga6LjAmr+NI7GjiXz25Fw43Z6O00H8/hFBZSaJ3BprG+0yD+wK98oAA+AdWkozpWDFQtUKnpIzLc9WNeqwLrX1/+oGiviDyEllIFZFDkrca97jdh0vpVJ7g0SBEyhTt1K1PLy5AT6Q28lhBPa8BGlk0iaof3ZkBq9G+PJlcimzvrzzWutYyC8rxAtdTp2VUD+ykeXVJOIaqpYT7/Sa/G6PH0ECptDNcnwHtiZIyDQI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

For a finite range ending before the first page boundary,
truncate_pagecache_range() calculates unmap_end as -1. The unsigned
comparison then treats the empty full-page interval as nonempty.

For example, lstart == 0 and lend == 0 cause unmap_mapping_range() to be
called with a zero length, meaning unmap to EOF. Punching one byte at
offset zero in a mapped FUSE file can therefore remove mappings outside
the hole, causing unnecessary page-table work and subsequent faults.

Set unmap_end to zero for these small finite ranges so that the existing
unsigned comparison skips the empty interval. Explicitly handle lend ==
-1 and lend == LLONG_MAX with LLONG_MAX, preserving EOF handling and
avoiding wrapping in the endpoint calculation at the largest inclusive
end.

Suggested-by: Jan Kara <jack@suse.cz>
Fixes: 5a7203947a1d ("mm: teach truncate_inode_pages_range() to handle non page aligned ranges")
Link: https://lore.kernel.org/r/20261027211505.22044-1-dennylin0707@gmail.com
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
---
Changes in v2:
- Compute unmap_end directly as suggested by Jan Kara, keeping the
  original condition for calling unmap_mapping_range().
- Handle the EOF sentinel and LLONG_MAX explicitly.

 mm/truncate.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index 733d2713a87..2c1f4a6c336 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -945,7 +945,15 @@ void truncate_pagecache_range(struct inode *inode, loff_t lstart, loff_t lend)
 {
 	struct address_space *mapping = inode->i_mapping;
 	loff_t unmap_start = round_up(lstart, PAGE_SIZE);
-	loff_t unmap_end = round_down(1 + lend, PAGE_SIZE) - 1;
+	loff_t unmap_end;
+
+	if (lend == -1 || lend == LLONG_MAX)
+		unmap_end = LLONG_MAX;
+	else if (lend < PAGE_SIZE - 1)
+		unmap_end = 0;
+	else
+		unmap_end = round_down(1 + lend, PAGE_SIZE) - 1;
+
 	/*
 	 * This rounding is currently just for example: unmap_mapping_range
 	 * expands its hole outwards, whereas we want it to contract the hole

base-commit: 05441d697f7f9a927264f4058cbbc6a03dfcac9d
-- 
2.50.1 (Apple Git-155)


