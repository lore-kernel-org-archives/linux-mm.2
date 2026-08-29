Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F640C61DBE
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 17:36:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DA786B0088; Sat, 29 Aug 2026 13:36:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38B486B008A; Sat, 29 Aug 2026 13:36:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27C6A6B008C; Sat, 29 Aug 2026 13:36:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ED9576B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 13:36:22 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6CF3CC0164
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 17:36:22 +0000 (UTC)
X-FDA: 85155011004.23.E4D0945
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9F29C180003
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 17:36:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jydn7J2X;
	spf=pass (imf24.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=qwjhust@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788024980;
	b=JW1W5LMakesIKC9lenShgNCV/3EqtHbaUJdHTYWbbpGbVukGFBq32vJ/Em24n05aLjFFwO
	WMJnrHmz38kq6zRKkbBWAuLctZ2E1VSvihoXO7ADeyejaGdc/kpDhwlZglIr4FqwH53TU9
	Jv7dI8dWmCqvtq2qk9sOMLJEcNITAnw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jydn7J2X;
	spf=pass (imf24.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=qwjhust@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788024980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+bZl8fb/65j4ubuzPzNdm3TBI6GilXwgRUv7xSKODXo=;
	b=3Uk+ViKckF80xt1/pTwfqyUtYyytyJhvVhUB2RF2hVx2N5E6aoftmbJgld5+qmT+Bt5muH
	dPQnFkPKCJZwOkcXeH9uOh1CU9vbZaTjJocrxuVevA9YcSIMiyo0mR0ohQLAWoc22NfoOz
	rkbKgVyWoHhYqN0dlRo/ImUi5Ch1eos=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-ca80d708489so1427490a12.1
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 10:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788024979; x=1788629779; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+bZl8fb/65j4ubuzPzNdm3TBI6GilXwgRUv7xSKODXo=;
        b=jydn7J2XpXYtxAU5kHqY5ttPV1nwM0U+rdJRGcADQOUuQlm0CeHsVI9Vm77USSS4zQ
         bDMRA7lU+lvQuT7ja0KPOFmJY/Ne+kh4RFoErN9hO11vmHYQYxV/s2U4A9eqta1Aw2RS
         uxg0As9OPeH9vuhDGlDGKzxNxBuGzc4SyR2Q4bT/rOrv4/q3SO2kd9090Kh+kKFhLwlV
         FqXE3lecGCc5JTbpnQ39ooDaTcpVFUKsbRa6XTctmmCK2VqfA+FrvFU2drPlOKBpoHH2
         odCUMnsaTzc5v6LpPL1ZLcvsP4kHX9uNkTavso3E0dry2uYkjOUY8rj3VxRg5tTfznZK
         JkzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788024979; x=1788629779;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+bZl8fb/65j4ubuzPzNdm3TBI6GilXwgRUv7xSKODXo=;
        b=guWiWFy7Oj8v26M6dKc+I/Gr5Y/Bx/mITDTM56bLwFZRnPErc7z4PtU6QgGD7yZ3Yh
         hFS+0IqwTminMUEDiyVzCaWmKjvuaI5rFxOUx8dWawHnFZ8WnTZ5favtYUWE1B+4StmB
         gk0IM3TT52VMGTdjhgsH3yK9itaJNxXsI8AvnB6ysD5e5GvzwQcTq77ZIcYhxsGUvmRz
         RqHvD7wNn3cbRv9GQiMBlDZ0PQqINYsEEwp7m4iOLfQIKsobeV08L6hh6u8tHqr991kb
         UdQY1VX9sIuSdzJr2qJDgt+DXJrZzeByXuYaBXspo1pS6m2aDaQtbhvffzKl6A5ggWXX
         kWzg==
X-Forwarded-Encrypted: i=1; AKwUvByb1zriz2+PG0Gk2z0NDw4AYjjNChRX6PCGTLqVBcrk8LXBCbwRMQhLdx/m08EqDZEch0uMkK7JPA==@kvack.org
X-Gm-Message-State: AFuF++mpZRMdpEIeB+TEDkOJriGPjMcZfjYDE+QYNofg7zgvL323DqL1
	StVrs2K24tUE6ZVLqeizZ3ISevRNu+4qTq+cZeQodPuirvLzn7k6RWhZ
X-Gm-Gg: AYBFou2saxOELlyNDSUOFrtajMn7IfZM80cLXDi5vIQ69/PjEzlezSNbVW57Le9tB32
	dYagceKKH5QJB7UHnZF40So3Oc2UsQH0YlrYQID6gI0CjApfPtl9euunW4UQ2u2W1dhjWIfUl3w
	5gxbDzJP/V9POEVERGxixZraQQMuv28qNkzY6YH+hhMU93myuTXovsOLNNHFxcI2q3a1STcgMeo
	Hcb+aAliKJWGkzgg/VaGY2YkWvaKqDavDziNiL+F0Wi9aW0MIRCvwZe5g8TTyONUM5puCqL3eg8
	nEcd+F2afxHrr0qfHT704S9+pSTXbgwGlXuARESJ8zBEjmhetiZg9IQdE9c7A6mw9u9Cyqa2A3O
	D8L/DDkzNL+EQt52RuivoVCkmARIYB0EzJLqqM25FZ7EVfC5IU2OcPeCGnPiVGZsHHD0bUt6eNr
	BJD/O1+piNHUjvX7TO9RAA386H32utE2nXE9ZaaDoNnWtbM4gHOraSIERkzP6sm5nVv0cGqMYMm
	jand7lTpQ++hyn/ImLu/kwnNjSQzy9S
X-Received: by 2002:a17:90b:4d88:b0:398:9bd3:d6d4 with SMTP id 98e67ed59e1d1-3989bd3d8c8mr6030350a91.14.1788024979256;
        Sat, 29 Aug 2026 10:36:19 -0700 (PDT)
Received: from qiwenjie-ThinkCentre-M760t.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396dda36ed6sm7634942a91.2.2026.08.29.10.36.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 10:36:18 -0700 (PDT)
From: Wenjie Qi <qwjhust@gmail.com>
To: willy@infradead.org,
	jack@suse.cz,
	akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	baohua@kernel.org,
	axboe@kernel.dk,
	trond.myklebust@hammerspace.com,
	tz2294@columbia.edu,
	qiwenjie@xiaomi.com,
	qwjhust@gmail.com
Subject: [PATCH v3] mm: filemap: retain mapped dropbehind folios
Date: Sun, 30 Aug 2026 01:36:12 +0800
Message-ID: <4aba05e1a2c3b61cb337d373eb9b7a8db4ddd822.1788024049.git.qiwenjie@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <3fa43eaca792bc0bbde4b82a6c1fcdd3f528b398.1787999152.git.qiwenjie@xiaomi.com>
References: <20260820142956.1414337-1-qiwenjie@xiaomi.com> <3fa43eaca792bc0bbde4b82a6c1fcdd3f528b398.1787999152.git.qiwenjie@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 69zq8ugmgauneppgmtmnwk8amw1eko5f
X-Rspamd-Queue-Id: 9F29C180003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788024980-839612
X-HE-Meta: U2FsdGVkX19rNSKs0X+DVsnrB3NYFbOx8lewNxK1U27GJmrg2a1G7UdEnQMuzf1t3kJpsfyOLcN4o/U7BPM8zcobnYNxflYafFv10emQeOw50rMO9rWMLFpyXADILCLtYp5qLdCEIXrXf3kVMZgy9OhOcsjZx1ZXLeiMAHTIWJZJdnZlDcHGO0t71mAb9x1VwgvL8xiWd7W46zgd8x4GgD3uSsydKoKS6D3vG52JRqm5vQF6fMSvVtuFFx2IZw1f2Eu9OdvNIKAqxeKWALfpOK15KT09hcdlQKQdV+y0IrUm67+xUrQdCN6gppfgj9MIlWMUK6sTYXN5LQF950N+6GhbSYZD/3yQuNmi7/IaNr2zOJbF5yJhg6VxmSziXgilHT6jV3FG5dBfvOA0DirVPVBqQyM7tMlqhvxn//aXwTItphq44g+OO+sLdoWXDnWO5SAIEcfeEZ55r4/oydeyOUvv6rY3aIaaaAzr2/V5G2lgIK9DMR+IT+kP0ihN6UUj/8ESVDD/tZvdFnD9Ey6LaXb+WLjmuZJx4LiBfcAHPgARgZrBNyigQPSjoPKA9iZfgVomtSErH/j1LhPkinRHPsMfnxrywlp4GHAdaTPjERzG8aV4LjjS/cBGQeQhGcK5pOqh8sOo7MMn0VxyE9tk/vcjIyfJJdK+SA3ombprjbyT/eNhQYhH5IQRSgLm/a3xyDObFfhhCUyptUa9Tdxygqt3a/J/C3aqWd/HqT6XZdYDRh1Kljk0z8/AG+sBh4cNSgWXSRIcaRL/54/l6G1xrlRqg/NscduAE3Et2WyhFaacRqQxXuVZcVmaef7kcwonmDRU/EEmdqJFBtXOME5pNyZV2BG3yRxfd2wMMNAMIcl4KLfC+DIRdO6iYG4ir4bZD9q9dUlAcsMtcdPVAQzU/VRGaLcX80zw06VomWk8eP45V9OJb3CS6tuovfQWHq1e9PPgfM5WQsrUkYYTfrK
 I9y03t0l
 eqDgHp4eKOhYvnwKQ3QDzD9iJaY2eUflSdUzB23tGeqIgvH8OFZPokNx+t0sBjfVdrZ+sWNNYTy/X8qk8LwH8YthV8PPzfXvPxMcEm4XBVQltjruAT3IrBLe44u4HyX2FoW7Wr3lHyKwG7BYGCXNFnXS+Vb7M/kkW5Z4HVg7AuTwkfKwewULweD97flnLbWd8eSmEMIncTwytF+EKF+hmIaHImP77dSrGsWkiQvPaJ77TaYO39Xkt3ChEmtVHkd9QziR6YgpLF1U6tcbNgcKT2HE4y+o1LQw7eLLZDWh87YBQxKyqDD3HOY669iQjP1h25n82c/MnXj8OHudA4TZ1Km48rzgcPEn23AsCtJLigrzQLH9qr8BhavGXCD2zLJzUG1nJeT3x2mhHHtjAjGiJkaJXUHxluHAJqykNTwqPgRcy9cwkacyf3GjRXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wenjie Qi <qiwenjie@xiaomi.com>

Fault-around can map ready dropbehind folios without going through the
normal page-cache lookup that clears dropbehind. A mapping represents a
competing cached user, so retain the folio instead of forcibly unmapping it
when writeback completes.

For a mapped folio, folio_unmap_invalidate() can call
unmap_mapping_folio(), which takes i_mmap_rwsem and may sleep. Retaining
mapped folios avoids this path when folio_end_dropbehind() runs in
non-preemptible task context.

Unmapped dropbehind folios continue through the existing invalidation path.

Fixes: fb7d3bc41493 ("mm/filemap: drop streaming/uncached pages when writeback completes")
Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Tal Zussman <tz2294@columbia.edu>
---
Changes since v2:
- Explain why retaining mapped folios avoids a sleepable unmap path.
- Add the Fixes and Reviewed-by trailers.

 mm/filemap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 6afec636881f..00fd89cf6f55 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1616,7 +1616,7 @@ static void filemap_end_dropbehind(struct folio *folio)
 		return;
 	if (!folio_test_clear_dropbehind(folio))
 		return;
-	if (mapping)
+	if (mapping && !folio_mapped(folio))
 		folio_unmap_invalidate(mapping, folio, 0);
 }
 
-- 
2.43.0

