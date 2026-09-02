Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60710C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 07:59:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55C6E6B00A2; Wed,  2 Sep 2026 03:59:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E54C6B00A3; Wed,  2 Sep 2026 03:59:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AFD36B00A4; Wed,  2 Sep 2026 03:59:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0C8E96B00A2
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 03:59:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 79128160731
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:59:57 +0000 (UTC)
X-FDA: 85168073634.02.B4120D7
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf23.hostedemail.com (Postfix) with ESMTP id C7590140007
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:59:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GdaBV6fo;
	spf=pass (imf23.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788335995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=k5YpQCAyGRMzg7W5xJsgx73Wgp3x7Yj1lZctIlmSQaA=;
	b=5BzAspL/S/sOCPnr8zLmtUtFDJANZZHdN/+dusS2OGbzHKQdy2qCHRufYtBAuIZHI/Qsk/
	Oj5/QoXRdwu1P0u+oT7AWxNHRf5LwZ+HKEhsnDZM2qnW268ARJaJHm2SMY2Z4N285gC9Fd
	/1fBQaOXcs7nFrnDG7TXQf/XP4/GRxE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788335995;
	b=M6xkWLChLIr+dhYsLzlEz6jIGJ0x/rYEYhQp665FTUIvxwh3OipzvrL0+XHVYd53c/3khs
	BFEIdZ8oO3Olqlu0u8t95GZy0lnQVShucuXAasXCaKC3qICnstPoxcFquam2sLoFXQ16Gg
	W97UpVF+08ozpoGviQzRuyCNOdClRgU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GdaBV6fo;
	spf=pass (imf23.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-c9e607d81fcso514430a12.2
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 00:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788335994; x=1788940794; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=k5YpQCAyGRMzg7W5xJsgx73Wgp3x7Yj1lZctIlmSQaA=;
        b=GdaBV6foBJqO68oXZkpDrew2QC5+P3ObD9aP46oVjWZPpvRth/HnpRv1SD3wThWvvi
         MIt4I79nLJVt/W2Lx484tqmA7X8P8A2LzXo006cdKc6FFySat68wLkSCppnn3pnG4fqY
         Hp9dx4QpWrrKdlGZmuU4/P3IqPxoQWbcgvV45VSu2cwvQFChMOAENoelPyWq80jZNMjl
         P6dDs014N6XMMA5AcF2yFatnK7tnFxt9hHgvaP0CqQvfw/YeJg5l6MiH5YaSZXpfb1f2
         OoaFwKhKMH7NflfOMC+05LBvnrDZeUfRm8vCJUwh7aY5zwXkpuPkqReBHsHCKz4NvrU8
         Emww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788335994; x=1788940794;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=k5YpQCAyGRMzg7W5xJsgx73Wgp3x7Yj1lZctIlmSQaA=;
        b=TuF1djSe9aoI6yvjCtLHJlcFg7EhtNMot1YKePciTEAPCRKGxtJ+vLojSbHgz4JOGg
         XN6JozGhkps4DDjQwH4Re7eEafTaajFHFgCN4n8+NbRNys+uZmpjwKltxN+8JTdjIjCS
         snRVjqH2c2krsdWNPGmRwtGyQlXiFGEtj8iZU5pq0FLuA5Mcs2XBWFs7DvJni7OjzODE
         KaFBq79QtD6tzEZ9xGJinXtFwnIxK21S061t8HXKBG4Vt3wRYnkBN+qYBR+C9RA1ulqK
         NkE3NS6Lm/TUSZSX9lIKXRgUThsPRa2mbb92Wn9H5oMKjgs0CACqkSrB2LB02L5DrTtV
         D8DA==
X-Forwarded-Encrypted: i=1; AKwUvBwR6vyG7hTteVm10DCQld4YJZ7ul15zApgl/qkzF+xtIcUUE6DXfjriZ+VAwWADmmXkxFDAnVZR0g==@kvack.org
X-Gm-Message-State: AFuF++kkL9BhZdRZWNoBrzYDMaQdQyzndiU9hpnHw8iW1I7tRV5fYU8B
	TSJ2CBSgz8orbApuqDGm5KseksN3izvi+UCrpQGw1N8bazCgs8Xdr+p9FqSfoQ==
X-Gm-Gg: AYBFou3GO5i9bMkZX2dZo/n/UpJZ5sHQ++5wcTHO60pdi3jFtPVWRYucpNkstNezPlD
	g2ACQSrNMdIoyTp4EGB3G3V+P6KUKA1p4u3GzQDGZDbnk0U1MaPkr3iKEDQqLutYfYIfIyE1w7W
	fvU7VuWr1+oS+00OzONr4Jnsx3neBQsEHWqNnByptF3t4INnnD0al+z23VPtQ3sDHfvF1xb3wLq
	LrShhqR0Jlrc4xmg5DH11P05HQKN35erMRMup9TLCLN79Hw/kuZfdIoYYhQrQm5IOuhx1f6y8Dt
	HMu5xXEGY9kjys8nY9C52Rchwx2tlWybj+Mo/MNg/Xn8wKf4FBAPxHV/ypdCY6OTfAVq8/VWr9T
	8GeKfLeQRNHEeV7LK12LhP3AWDgzRdMFBDf+g8+yV7B2MHXs0oW1wEH3KGKiFuv4yoMlsGhTR6c
	L1AuYCRIWNkd6iHeiqwz0QBJ4+iiCpc7jPjgv1sB6Y/GEb0bZlpCeJeNnwNd5HMUy6GgJbbYI36
	W9YaNi0bwUyamvqkg==
X-Received: by 2002:a17:90b:2705:b0:38e:524:8797 with SMTP id 98e67ed59e1d1-39aee084cd1mr4681912a91.13.1788335994476;
        Wed, 02 Sep 2026 00:59:54 -0700 (PDT)
Received: from PC-2B0BA31200898.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39ae0f28b19sm4496659a91.6.2026.09.02.00.59.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 00:59:53 -0700 (PDT)
From: Meijing Zhao <zhaomeijing100@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Meijing Zhao <zhaomeijing@lixiang.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Wandun Chen <chenwandun@lixiang.com>
Subject: [PATCH v3] mm: memblock: show all region flags in debugfs
Date: Wed,  2 Sep 2026 15:59:44 +0800
Message-Id: <20260902075944.3742866-1-zhaomeijing100@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y1se4nyh4yuotkkoiongya6d1o1fgqbi
X-Rspamd-Queue-Id: C7590140007
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788335995-305830
X-HE-Meta: U2FsdGVkX1/DK/pmCxViDPzK3/0qOKeyVnxv4JRmnEjsEXlqA8jqnk3XkTuByL4uc0Nnc6wuSTLzWkJw0X8ub91QPlx5EX0672JCaPTuOc8CE2mLkWeJXzM++FCGJpJVV4XoLJesVzw9If2oQ/VJwDM29G+tjkiTWoKjJUugXD0z+49hEXUGTExtc+3UPL0lh+UBwRf5UoiKmd2Xlq7Oshk9k49kLBdOj4XVUdtgU9ziFHrsY+YrWkj46XQ1E7vWsYKRu2LZ2WZuHjOR6rbGIQRS4ZXa5+IcALDX3hF5GYZ9t0seHJQZUWbrpU7ZgA0/WnTSYYGAoCaohPZIzH1ZnsYAm42eRZW2fXo1hUgzTuQQC/C5jvCEAVVpGGGF85avdm6pvdy3+6rCpE3KaoR4Vvx4gpNrE9NkAPw7AZeM/z6SmfC3skCUUvMppiEnwvOh8WsdF2qe1MdEVjlX/9MzefBfhTRXxoBgOwecmP735LKGFNJdFTCFhFAvzeAJ8Tjc/UxWx/BLpnFx4ASpPgCoDs00b82HarzOyL9e6Ak6HwF4pyIPmM3Fi+8qrwclFJlh+B7QsixmYIdFICMSMJbLxQ36t/NY1ML9QXFWXg2JWV8FIyiWFgHIxmnWZWw1brWcFHSJejSvw83thuAOSP/rzhH1c6eHuiTFywPo6GUcVafwDwrlX1e869zgx+oyXeuZViRlSUwBSoj22eYKy7pL09Ls6++4RrfP986znCXdP7wV5gdj4rLQlySiTv0I8B11Y50LjxEAD4mQEZdcr8bPdZQrCLBwn+TfySXXCBPfYtfchrJ/rDnrfzk3yYALGjqF9JjrKjIgxfj8t+YG5euYz4jlsg6/WkYc3z3pJ/3iTeg+iq8QeiamGvzY0I2KUQSpkDjL+pxYQ4igbHNkxVtLudCaCcB37mL1yGlPJNcLqr3g6yaEyXGONDo6hDG6bViJLO40Q/KSimIfPrVrXo0
 DRE8PEhV
 cvU1VftChRv4kKZppo4S440M9+RrkIbk4nYtCl8O1jaEjLyIuqC82KUeyz4uL+YuH5nSjQxdm1N07yHdXeXsJ2PH7/e1NC9sawjCK9nqwhirC6J3ARbSDhngTANgoX0m6XYdlAmvtleBWeSHbSrtCQQ4lM3bSAdBxyWptrBjF6zJ6leht2qy3U2w6k9QQ/VdA2qk+/2/EOUksUuKo2YgpcNl7FJMI1iFwcVca4iT1jfCE72yJ9YF5fUBHp8KKGEaKa4X/OeF9oymK1rISuV+9Lcu+RTh1guL47tyK4rrGPk80G9wxRtJ232ysRCwDzUgFFXMmCiRkt56eJFIZWteohPTUa7SoDAFFAKOAb72l/QPBnUK8amfiMJtfiUReTHFR3fFwDchaBSXxSJPEYrMj2kewEvKThldBuAvtyj6FXAjzMtPffZUhliX67pMDyPnZOsdl/ZYNtLRNnoqyceO6yPq4OBaE+0/boL5tXVshOfivTMUyAu6Dekt54axh7VNKdlZ9wv1FqcjLmM8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Meijing Zhao <zhaomeijing@lixiang.com>

Commit 493f349e38d0 ("memblock: Add flags and nid info in memblock
debugfs") made memblock_debug_show() stop after finding the first set
flag. A memblock region can carry multiple flags, so the remaining flags
are hidden from debugfs.

Walk all bits in the region flags and print every set flag separated by
"|". Keep walking beyond flagname[] so that a set flag without a known
name is reported as UNKNOWN rather than silently ignored.

Fixes: 493f349e38d0 ("memblock: Add flags and nid info in memblock debugfs")
Signed-off-by: Meijing Zhao <zhaomeijing@lixiang.com>
---
Changes in v3:
- Rebase onto v7.3-rc1 and send the former patch 2/3 as a standalone
  patch.
- Move flags and first into the reg->flags block.
- Remove the redundant flagname[j] NULL check.
- Keep the existing NONE output unchanged.
- Drop the debugfs synchronization change. As discussed during the v2
  review, proper locking for runtime memblock accesses needs a broader
  design and will be addressed separately.

v2: https://lore.kernel.org/linux-mm/20260821020910.3428585-1-zhaomeijing100@gmail.com/

 mm/memblock.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 9ce86349a29f..021db49eb7fc 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2908,14 +2908,18 @@ static int memblock_debug_show(struct seq_file *m, void *private)
 		else
 			seq_printf(m, "%4c ", 'x');
 		if (reg->flags) {
-			for (j = 0; j < count; j++) {
-				if (reg->flags & (1U << j)) {
-					seq_printf(m, "%s\n", flagname[j]);
-					break;
-				}
+			unsigned int flags = reg->flags;
+			bool first = true;
+
+			for (j = 0; flags; j++, flags >>= 1) {
+				if (!(flags & 1))
+					continue;
+				if (!first)
+					seq_putc(m, '|');
+				seq_puts(m, j < count ? flagname[j] : "UNKNOWN");
+				first = false;
 			}
-			if (j == count)
-				seq_printf(m, "%s\n", "UNKNOWN");
+			seq_putc(m, '\n');
 		} else {
 			seq_printf(m, "%s\n", "NONE");
 		}
-- 
2.25.1

