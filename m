Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDE41606A322
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 21:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aUZd5CWG
Received: by kanga.kvack.org (Postfix)
	id A546C6B08EF; Tue, 27 Oct 2026 17:15:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A05E06B08F1; Tue, 27 Oct 2026 17:15:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F4556B08F2; Tue, 27 Oct 2026 17:15:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5DC5B6B08EF
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:15:50 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 73398140B0F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 21:15:49 +0000 (UTC)
X-FDA: 85369663218.28.2738CA2
Received: from mail-dy2-f5.google.com (mail-dy2-f5.google.com [74.125.229.5])
	by imf29.hostedemail.com (Postfix) with ESMTP id B6470120009
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 21:15:47 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=aUZd5CWG;
	spf=pass (imf29.hostedemail.com: domain of dennylin0707@gmail.com designates 74.125.229.5 as permitted sender) smtp.mailfrom=dennylin0707@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793135747;
	b=nGfnOTpo88MS9V1tSqlzPfys6gVjfULGzSzUWsDEidwTSmhlB5GcJlaCXM3iNmyi7aUGUI
	/vqst/k3eSEPVgsuMMjBfKP/mRUf8HkdnmdT9FbWGgQ4cQxIcJAcUrMeF866P6zSXuj6Uq
	vKZ4cfgMztpDUeIqgQmU50BwFYGasyI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=aUZd5CWG;
	spf=pass (imf29.hostedemail.com: domain of dennylin0707@gmail.com designates 74.125.229.5 as permitted sender) smtp.mailfrom=dennylin0707@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793135747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=sa7iGCeELZtURXOiW2lc5z/VEpz0Jw9PHYIzUSekpgQ=;
	b=cnQUTD+nmFGXmIlYB6A+Lla8V8RqjtoMwb+NnwaI/YziK/rmvorchT8sZBKgPaELX6pQy8
	aZNlC2TCRiFoGcRDJ7M9vhxk9e/bmvuT9lVqJdsxkKbcZAF/a2zoWE3NGLQyATHygcNbWs
	VYUwcZavRUiXIQbj//BYjiIulMoKTZg=
Received: by mail-dy2-f5.google.com with SMTP id 5a478bee46e88-3535a54c09bso214678eec.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793135746; x=1793740546; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sa7iGCeELZtURXOiW2lc5z/VEpz0Jw9PHYIzUSekpgQ=;
        b=aUZd5CWGfuc4oxCXwt97ci56z9CkAep4d05+5PEgBs3yd1nQ5H1hbnZHZe5IOP1Y/k
         Zq3CtI3KCeoUkjort+W7+MpoikdvW0CP8O5UOZZShsVrCv4Pv7CJODB/bXnNoAthZHCY
         PmV5u3ckeIsK3KID8hGoejJ2HZt6O2c/vC2Q+EgaGhIeVdRF0Ya1rDMXIK4q8yONRwNi
         EQwKk5nY6zuagYW51rZ+GGHunoHSZSVkF03p1QWXdewmAujSu1gxX0bDaduNqaXt5jDW
         aAyE7R26yIMVc97apCMrAxrB7we1I4dMBug7w+p8mgP7j+swC2JDynPHhqydz0c2D/Sp
         yoQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793135746; x=1793740546;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sa7iGCeELZtURXOiW2lc5z/VEpz0Jw9PHYIzUSekpgQ=;
        b=Fs/OwzSoMYAvwPZb/SgoWHiACpZoJl7ehX+o76DH5vKiMentmbhsXpAiuUCUwW/+D0
         kO2pm6JrS4vx8vOCrPi2u5+vZ76ik+JHSDJ2ARHwIoFS4ubd2Hs55AJ3mcRsWcHs7yLd
         /ooh/9WS41n3QZBSOR3mk149tkgQrzK1wsLHnb6fj9JeKGBlgz1n81eYmjvnurVafSIm
         0FjNXA7Ju5OMYtZk2t17+8pqkgD8Gp+/ROqtaKg2C1BxROeRohbx6bn5x7QkgVnFI45C
         W38xyXKvLajbV55FVR4sSkHeNlBTCZ0ZtIdff3OZet1M2ciVflY6h5Sqg7+j40BJ/MOS
         2plw==
X-Forwarded-Encrypted: i=1; AKwUvBzv6hzq+Ca9Wpbrn3CzjByXLPeqLZZ4j2NROpeLLj6Pg322eDzxjmX29ECbNYfAUDN7RHFfe7TW+Q==@kvack.org
X-Gm-Message-State: AFq9FYLNlqbuitzYjCN/tCJ8esBT3SNR+qleNCoxiSoBddvDJTo14zr1
	ZZp6Sw4/noLD5xrm2qvq02tV+y4lyRCpUkJE5XSg+SJCDPniptwQEeJo
X-Gm-Gg: AYBFou0mRi8LBsG0Ufuvi+eBPk6CAOJVsuMOk5lTurw8K7ty5SM+uT229DnrjW2YPqc
	WfDYXSGQ4H9qisvpqWTjKjl9i27MDPIZ52Bt+xOF5FmcvV6hb77thaGDWF8+xexwuXXpiuHcNqu
	cGs0JCkH35XO3KNJgTqcF0cE8qU+hOmOvYPfAVCjuzlFbPgaI1wd3vRBjFdKhrIF7eG+u5EMZZ5
	Mn4gqK9urZEqhMKuNDm/Dtkos9GA2HpnSfUpKxBfvuTYIlgYUUQVUU/HdVZxrSjEivrXoQ2tFMz
	wrm3qlkQxYi6cLQtphdBsxpEyUSvLQMYPyDYrpe0WCwXW3qtgk1E48+aux0jWB13bqWGKvXoWKU
	VzAol8PJsU0Uxn8MsU4Hjpl/fWL++QXqxEUV29ezRi2nDIkeFTPm73XEKlLbewOB3aLyF4eXYru
	Dw2Fn9BmrPEAb3h8ztFpBEPjZcK4WfAWAofQ0hExRlQEoWNNpxmHzQN55n9Nc6n0oU399vehkEx
	Z1QfPWpqZSuukjr3Qu8LYRydLebwaOnDrOIQZ7cN6ecSCxuQCMXj8g77sIuLPpgjhEWr8E+biBy
	ZvCqUX4=
X-Received: by 2002:a05:693c:2a17:b0:36a:1bac:6bf4 with SMTP id 5a478bee46e88-36a2039cb09mr845127eec.18.1793135746335;
        Tue, 27 Oct 2026 14:15:46 -0700 (PDT)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8c576ebsm35750827eec.3.2026.10.27.14.15.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 14:15:45 -0700 (PDT)
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
	dennylin0707@gmail.com
Subject: [PATCH] mm: skip empty finite ranges in truncate_pagecache_range
Date: Tue, 27 Oct 2026 21:15:05 +0000
Message-ID: <20261027211505.22044-1-dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xc1rqkoarcjdmrc6py7n4hom7yd84pzx
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B6470120009
X-Rspam-User: 
X-HE-Tag: 1793135747-310830
X-HE-Meta: U2FsdGVkX1/Wseh7vdRYiR53EA0mldfRQLcIe/fbE0PhGpy3Oly87tVUEHbBPxWmFZsf5nMESP/hpv49n3/6FPiXeghYTQuq7TzlV6+h8eiCevDSiP/eozOC7tkq8qWwTzmw8zU9wC4h5rh7ggoZJLPPmIO9O5UcW6p0PNCaSDqaGIlP5kBL8iRzndBm8CaGiJmvlrFTQySfWjYlucns4ONXL6boe54qzHr1L2eHzPpkhO1Xq4ZAHeBVQ0OnYoC5WUWAVaTaTGNkSoLwJdoqyR7eR2Yrc+KgvUkNyt2BnK44Sn1elijJIYPOTnCSWhRiKP9Ae7eCi/Wepkn753fLUVQ9wzgVVx0cKFFBbFg4N/+d5TrVGHFv3bfcutDHVAqX3mb6+RYlNMA/YDxoSs1bxpncGzsMJtl1iY7/xqfzfrkZ0IezOczKdXuuMsxFJX3o2Lg4MlgXrzhE4DDfaujDWN8ny6JCnmre9niehjFlAjYEV7GsfNKH5q2Y0xzyAgYpkspWq3WbuJUyQSH0DYCO9qZ54/ZtGvrqbHORbdMLu5azGt8kcoN4rc4iXHViT5bd320De1iGsL6BpjfDxueqBHtR1JxjtEmCBN39LGkRj6xrBf895WAGq8aloZ3EDLRYGgMjf/7gfporsfO/bUoZo1fO2in7En1zmHNnuQ3jX7oZP3ZqK6vptotIW7lztp7k6n0j4q2NayamIsw7h7eMcAM2H8mGFqlhTHTO+uvfoxdCuKGg7q81sedLwVbhaymOkiAKmeqJicr7bRQPy64254Kz0X74X6WUwUsxu36YVxD2wrZ0D9OcGen8rdAJWsUa0hvAqVNe8gP+x1wMkI23quAEiH79P7ikPnLHDIskjOiEFg9CyCknh5IzKNARubWADjnbu4RsZQJb23iiRZ69vmq3laeptzW3E737zaY7HiVCTYqwiFdEQ0vW1zownkpMx/jb6kiSpbRsMAgKKjg
 aLRP4ixc
 tQldXv18mVzhGq+7AU6M5EyjPNNM+E7SreC8zuxGU9skkFYSwNOgCvdQ+KMmaiUWqdRs43nHyNyaUNrhkYv7jRXXcQieNxNHT0hKcg5uza/C2qfIKS8MwZ4TxVgsGeKJ8ld8IikMxLSv0Sj8Y46DB/zS/xdEJT7gX1P0jM3OIV4V40xqMq5uz5LbItUgg5KNJ0K591LJBLe62TSQrxCp8kP0aHq/POBavRxTFmwro45nILQ2QAGHgKjOXbF2kdcK95jHBXcQsnJKvVYq8MI6lpSOIDZRy88lyGtvgwizwB076caxPosQWVB2GJAEj6XuZA3nLeHIMPA5Pf3jZ/9DtPfJ/GGbKPyM9mqXVo1erjNOorsVdGdFjkghtviub9XS7BPsOU4L7jF6rtTZH04zx7YYYFxYkfZEjSF2vtxz+VA+Z1bexvy3iOKusvfbmXDqQj/9d0hki1Hk9QZM=
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

Compare the exclusive rounded end against the rounded start, while
explicitly preserving lend == -1 as the EOF sentinel. Perform the
addition after converting to u64 so the largest inclusive end does not
introduce a signed overflow in the comparison.

Fixes: 5a7203947a1d ("mm: teach truncate_inode_pages_range() to handle non page aligned ranges")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
---
 mm/truncate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index b58ba940be47..43c6cf99027f 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -919,7 +919,7 @@ void truncate_pagecache_range(struct inode *inode, loff_t lstart, loff_t lend)
 	 * once (before truncating pagecache), and without "even_cows" flag:
 	 * hole-punching should not remove private COWed pages from the hole.
 	 */
-	if ((u64)unmap_end > (u64)unmap_start)
+	if (lend == -1 || (u64)unmap_end + 1 > (u64)unmap_start)
 		unmap_mapping_range(mapping, unmap_start,
 				    1 + unmap_end - unmap_start, 0);
 	truncate_inode_pages_range(mapping, lstart, lend);
-- 
2.43.0


