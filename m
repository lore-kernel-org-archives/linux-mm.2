Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E461C55167
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 03:23:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E1576B0088; Thu, 30 Jul 2026 23:23:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 692B66B008A; Thu, 30 Jul 2026 23:23:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5811F6B008C; Thu, 30 Jul 2026 23:23:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2FFEA6B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 23:23:06 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A477914033F
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 03:23:05 +0000 (UTC)
X-FDA: 85047625530.26.277CCB6
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id D0C60100009
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 03:23:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=nebusec.ai header.s=google header.b=F0cz6ozm;
	spf=pass (imf05.hostedemail.com: domain of zhilinz@nebusec.ai designates 209.85.214.172 as permitted sender) smtp.mailfrom=zhilinz@nebusec.ai;
	dmarc=pass (policy=quarantine) header.from=nebusec.ai
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785468184;
	b=fW8yrQE7eIcLnL9mqX9E9gXWoJT4yo1eMklomsVxIS+CQvoCANYkoecti4EpZhgkNTteWS
	7I2lR98YPPP2/YicAMpY6K0sfJrGOjqRJINt99BPlrPDRkqZ6fFpCy2JjbEW2wc9KFNwCh
	E6wdoHntlzplIFw9zmORTQcGAsMy3+Q=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=nebusec.ai header.s=google header.b=F0cz6ozm;
	spf=pass (imf05.hostedemail.com: domain of zhilinz@nebusec.ai designates 209.85.214.172 as permitted sender) smtp.mailfrom=zhilinz@nebusec.ai;
	dmarc=pass (policy=quarantine) header.from=nebusec.ai
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785468184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=J1xR7SF+cs1ep4prKwwQVFCGU6amOjiDrNOT9EMpHXE=;
	b=xFBZEiArnSwoTz1B2D+rJAURltmu4oCW8W5uhWLfqOKHjRdP+p2LqBdtYeNh8x4cD3wT1U
	xcoQ1EhIj1jJl71jawKNb5h+vkRAKt6I5w8Mu5zkIhS5fl3Qnb/LZsza1gXqG6bMqfSpKd
	BhTXPs2kvTYihpHtYeDJyvM3Z+5B934=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2cf6d65d8a7so6870675ad.0
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 20:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1785468182; x=1786072982; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=J1xR7SF+cs1ep4prKwwQVFCGU6amOjiDrNOT9EMpHXE=;
        b=F0cz6ozmv8Vx4Y84pAzIqcMN+kKmAkBKJ9Fq3N2vPUK2Q9OurICmZbYYntYqEB1wjc
         2j/CjLacWK9u1GXW+ub0hqUyUNf531+7RgGDvuub5byVKdrUwuH7/Qcb0HqNOrVNMB+J
         vuVzxSA6NZzd+v65hMwFhR4TJHobvMgLcgJdWFT/gcIwN2Y2gFgALO4SEQgYM4/LHypl
         xr9Zgq4v2NqDsgsnXVp6XqN7B4Q68POmUPmaqHJ5+trZF4IL/lR1iGQsJM88tidXH+3v
         h9KF69N8pKg96c/vGoyKDcp6TxO40mHE2Id4tWX7VsvwrZy23WN8Fh0Fp7t9fsnNOQyB
         rAew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785468182; x=1786072982;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J1xR7SF+cs1ep4prKwwQVFCGU6amOjiDrNOT9EMpHXE=;
        b=QmrXEHDm4PH9A5qXuCVVUakhyE4ynXD9d3j9nXj4VJ4rBKPsoPvl2s+HNFYdipQFRa
         /zjTCSduY6ddNhTBVV4hJ8MSL68g6hsg6Hn+wTx8GqHUk7FzUXVjlHrNgiqslhvWC5Wh
         12piyZc+O11uTXCWgp2swnsoyUU2vCh48waYaZA2raWxcWtgnqDxaeOe+CtafaJf5VfQ
         CJ2WojQxG051eN+S3fYpSdOSeoPJ97BzizcssrwCjbucZGwpqmWCw9d8GaSDwxfx+qFi
         qYqpXy91kxr28X9RdlNmK1DY0qhzrK/EqSxYHDP14HtBONBtqu8mxpY2xWLod2QVjZd+
         ZteA==
X-Forwarded-Encrypted: i=1; AHgh+Rrp16sgVJgi49TgpVmdExuDD9FjRSJk2D43/uK7NhiKZIust1hU17NguVjrPoaSVOpAZJ14gruWhw==@kvack.org
X-Gm-Message-State: AOJu0YxA8uc7IlwV3upd5tvTKZcAtmGfVw8O+vvFkb38sql0QJ3zaoqR
	elxTZz1P05D2wElnaibAAJTvtrGXY3k0WhDsQo+NeRQClr/nGuE2+AltRSAko7C5zQhZ
X-Gm-Gg: AR+sD11YePC/52pma3UK1MILqkht20CYC8n3B3nlwb9EypHiZPH2LuAgIPZXM1D1DP6
	gVgpcZyOlpyW6e6n5ZaCg5dhy1D4fATJJD+UEf/0npRPWRvujty6wyBiuBn2N5NjWorGx2v9alx
	jiQ0Qf7FIhnAi1mR82fXlkEkvb5FzcUsCObwLGgDHguJHfdKD85mhy0UIhNmxjBTOlI85jLoSf1
	F0fDjBLzPoCWdgxbsUVsa8nNjVURfU3ApQao5kEg0s6i4U5XsqpiwcZVwMny46JoL6DyMY3Y8LI
	O6oHEEBmsS8OlbIbwy54NaW0x7rbzDZ0hyZ5G/DvZWfnu3tLbsgGvFX0UxOTHvUV4DOchmgwpXq
	iUiU5t5SaaXYJpXmv83tJ0cS4Z0e0JRo9qRHJK/JO8bfJKumXhGNlULAnxgNSfD7RVdYscIOjP8
	HUJhGJh1hCrruowt5DWccPbKDZjcHEdcRUMOaH843zb8ey1T22qd7vgx5TdD3hINTqFOhX6bH9C
	ElQ
X-Received: by 2002:a17:903:2f0b:b0:2ca:bb6:e7c6 with SMTP id d9443c01a7336-2d046ee964bmr4704625ad.37.1785468182406;
        Thu, 30 Jul 2026 20:23:02 -0700 (PDT)
Received: from Roxy.localdomain ([203.175.14.58])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d047abcadasm870605ad.51.2026.07.30.20.22.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 20:23:01 -0700 (PDT)
From: Zhiling Zou <zhilinz@nebusec.ai>
To: baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org
Cc: hughd@google.com,
	akpm@linux-foundation.org,
	vega@nebusec.ai,
	zhilinz@nebusec.ai
Subject: [PATCH v3 1/1] mm: shmem: reject page-aligned fallocate end overflow
Date: Fri, 31 Jul 2026 11:22:51 +0800
Message-ID: <1929a466735dcbb9438936ff50b7a4fc2332a8a4.1785377919.git.zhilinz@nebusec.ai>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r6epc15wcoatmwpa4dttpjnuodqedxdd
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D0C60100009
X-Rspam-User: 
X-HE-Tag: 1785468183-908310
X-HE-Meta: U2FsdGVkX18cKH+igd3EMr12Mja40xmcrzb42Ncuo7WcvL+bjcootbGFQ9Qk8rSNycP86+AOxFiffp6EmKVofaZQLLX1heI8dvZFIr+7yys6wMBxAmv2HAq/ZQqkrqad7SV5PVCvbF8evckCTw9QseN5hCf1LfEr+tnA4vUoBOe797+jI9VR/vNnBF8/NUpEdeIGNd3wwdKzrngj0q38UmqhgCp2CCw0BIPqskivwGOr1tTdgwIu6JDDWQYI6CQdRzuyIP+jA3882UOZu9RT8DwpD60xErXDSxzhtbXx2CDWqQWSVaHdlh2GQ0WpB7XU2au9HaRGaH0ACyN7MVdgg+8qOd8NngmYgBH/zA5JjD/m3MYewjCkG09dw3++jBBMr/Ppc15fBgss3zLwpWpJN/KIvMndyouHg/66bfLiDOXjpdHYB+xdNPgZK3doKBPGk91Ax5Auba31rUQ/BBv0s54lfXduMlRCgLL+7B96XS2OREuo5hNFTaauSpMJXrXhAlTXFaSeqb6EhJUEAd/QiyRQCeN5Zv3VR1Da5WMnrWYJGeS2POY1kL0GdZ+biFTz+5yeydFhamSy56FuqgNt0phE7ui5u442U/cqoBski+3UQiOetwgsZyWjPG93+6zTtoSB0pAFSNCzi8UVvCVUzlf2/ybERw1leewIuShLgj73GnBMCrhCoKYFGkN3eSpVwY90F7WPlw0eL1bN3c/fIBfOirYur+Jrtv6UBk+m8xhVRamKcGRgby9NrF0X5a3UJ0W67DgIMsyrD/H5xJhvo8JYt4jHH8RwCZA/65uQtlxZJH5wM4FijQ4Hi30rRI8YhprMZg2yuWrZ+PcNlETZrgTdCQ7bCabJS0MWuGFj+SSJToAujgCAMwtP26BGikkKCHCrsOAbdsmC9zPipzeSYcIA1sjBq36uawRFm/9EmMjrGLjg+ZDiHt9oXl2xuSa+m7mF+9FxqmCjJ7R5tji
 zGvzZ2Vo
 hSGOQ/+jrQViN7O/bytY86KXAan15NbXGtva/fJMNOfQZK/mBjjoVncnRcWuC+27g7i9uJKQUhV79lAnoF5diFrioPZv/wCKks4vXuo0QVhrs+F6ebvwSVsAcfVMAduWEhWsdGpXgWvfJLdotMYpKYPbjQhbk36HNgIGHAYGf8IuT/DMwtoSdKEDziY6PWCo6lXS7YRdC3nxc/VTnMuFYSGcH1pG3UI+kpU5yk6xMGq5gI5PwN089RuNUZlC+oiFl8hlyzNlAJYuQ80vsa5OcABbN32fnd5lwNAexZMkaLI4V1ZE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

shmem_fallocate() validates offset + len with inode_newsize_ok(), but
then rounds that end offset up to a page boundary before entering the
preallocation loop.

For a valid request ending at MAX_LFS_FILESIZE, such as offset = 0 and
len = LLONG_MAX, adding PAGE_SIZE - 1 to the validated end can overflow
the signed loff_t used for the rounded end calculation. If that wrapped
value is then converted into a page index, shmem_fallocate() can enter
the folio allocation loop with an invalid range.

Use check_add_overflow() when calculating the page-aligned end, and fail
before entering the allocation loop if the rounded end cannot be
represented.

Fixes: e2d12e22c59c ("tmpfs: support fallocate preallocation")
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
---
changes in v3:
- drop Cc: stable
- simplify the fix to only guard the page-aligned end calculation
- remove the end_pos cache and keep the existing offset + len uses
- v2 Link: https://lore.kernel.org/all/87a63846fe9873b1e26e8a7dcafcb21aa8d709fa.1785309651.git.zhilinz@nebusec.ai/
changes in v2:
- drop the RAM/swap-based range rejection
- drop the NORESERVE full-range accounting probe
- use check_add_overflow() on a signed loff_t rounded end
- v1 Link: https://lore.kernel.org/all/adcf644e780706c220809b7a41e6e496d2181806.1784947149.git.zhilinz@nebusec.ai/

 mm/shmem.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index b51f83c970bb3..ff99a22ecdb63 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3602,6 +3602,7 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_falloc shmem_falloc;
 	pgoff_t start, index, end, undo_fallocend;
+	loff_t aligned_end;
 	int error;
 
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
@@ -3658,8 +3659,15 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 		goto out;
 	}
 
+	/* Check for wraparound */
+	if (check_add_overflow(offset + len, (loff_t)PAGE_SIZE - 1,
+			       &aligned_end)) {
+		error = -EFBIG;
+		goto out;
+	}
+
 	start = offset >> PAGE_SHIFT;
-	end = (offset + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	end = aligned_end >> PAGE_SHIFT;
 	/* Try to avoid a swapstorm if len is impossible to satisfy */
 	if (sbinfo->max_blocks && end - start > sbinfo->max_blocks) {
 		error = -ENOSPC;
-- 
2.43.0

