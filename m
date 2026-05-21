Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54B63CD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 09:07:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADAAD6B0088; Thu, 21 May 2026 05:07:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB25D6B008A; Thu, 21 May 2026 05:07:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EF946B008C; Thu, 21 May 2026 05:07:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8EE066B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 05:07:36 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2C112C1FC2
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:07:36 +0000 (UTC)
X-FDA: 84790848912.25.AD0FFFC
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7254C100006
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:07:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vFui4xFd;
	spf=pass (imf05.hostedemail.com: domain of thorsten.blum@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=thorsten.blum@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779354454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3/utW7ixOXqEKWPMA0wnZDzgH8XeOxNri1fubQ6qmsY=;
	b=VDZlb3tU//suY8JYgV9xWU5FIviTuhNC8xomUQmCVEtDTFir8Rh2v0dj6poWsiQgKBtncg
	XyOIvuTeWjIXtpNHWd7bzV/6qULecGfjHE5aJDxz93mzIgmdTbR/nmcIYPzrn8b+YIR6x0
	uZ4AKYut4eekkSXLfWcdDa5D3r2FMKo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vFui4xFd;
	spf=pass (imf05.hostedemail.com: domain of thorsten.blum@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=thorsten.blum@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779354454; a=rsa-sha256;
	cv=none;
	b=CTEoCTiV5rMzdPmshY5xvLbbhM2rzasrhmlFl9xJryg40y8sJl9aY7qctfoVI/CtEYrPWv
	5E0buGEKwMSsOdn7MwhatKMQtfNKO8MwlMytQ3godes8IZJJV8JhTwBgfSySqWpWdCe/LI
	LdH3Wv+LbeDklY8wefZHgnvPRGRLNzQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779354450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3/utW7ixOXqEKWPMA0wnZDzgH8XeOxNri1fubQ6qmsY=;
	b=vFui4xFdv/MVk94/qJvKag4tiAguASd2cIasBMA55++kaWuLrcPoBd/gbpre2QokBeEHKJ
	GjcE/ixsBPRTMaR1dpZBsYwhhylp/J6fEnR2JIRp40u1gxMEdy5y6pIEm0f81GJbVCajSE
	mi/pCTVR4K4Ve1TxvPfJm3hDXA3KJoE=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Kees Cook <kees@kernel.org>,
	Andy Shevchenko <andy@kernel.org>,
	Yury Norov <yury.norov@gmail.com>,
	David Laight <david.laight.linux@gmail.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Thorsten Blum <thorsten.blum@linux.dev>
Subject: [PATCH v2 0/2] mm/vdso: make offset_in_page() usable without linux/mm.h
Date: Thu, 21 May 2026 11:06:56 +0200
Message-ID: <20260521090655.160282-4-thorsten.blum@linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1896; i=thorsten.blum@linux.dev; h=from:subject; bh=YgA0bvDDsg2aT23TUlbqLxOb60JWbCeIkZgzZ8KQBHk=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFl8p/X5V63aEiF+L/XRldluVhPa/nbejix8udki6t2x0 oYT83JPd5SyMIhxMciKKbI8mPVjhm9pTeUmk4idMHNYmUCGMHBxCsBEZKsZ/geE3BT6lGzxOCn8 W8NC70N/hbNlfjcE6WQuypBNF1vAEc7wT0O9J1bl1dMU/UcMcTPmWEg+v1q27H21iuymsCr3dvv 9jAA=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7254C100006
X-Stat-Signature: auqp5azarijyb6fp77onxot3hrjkqing
X-HE-Tag: 1779354454-757137
X-HE-Meta: U2FsdGVkX18CClmtg+gRGjcZX7CokuvicMA2Y6PyCPlzOI0782cvKlbS4SZlYwJIafsiUcAuVBiTOyQ3qgbkv+KWtZDHzqQMzlxk9UdqP0LTPxpT5SoHNgPn0tADJrNMLhakIpDK22w5uCbmbpRFZTkMAAFpAKfr/z+NuP0cslElIAw8tqH0AmmcLOkBSjMVQJD+4wR/WH528gj9lgSccSXwQ44hV5k0vZVwEaw+7CknLcbLN+UlTFoUxvW4xfQax1LQUkqlv0orIJt/uKh6gJ0F98SoUh1EEW0rCRAsFzB9hyK1SaaNxNDqnDGkkYrjos0OrQRhFRcKrv9UnHVCLtdg2Aauxq/OreyYxgxoJA2QmVuS+r3/VFDJxbbFc6gv53Ns1ianCaRnrOaRrH4ee7jDAI2dhzAbJsq7XJXOe3vn2F/yfPiXlFsURC3E8TA4CKw2fvgvIVIjsNTXNZDcUDF+g7/y4BUq1RohBOYhjpkU8tK5HveN0wN8iq6FyF5dfsRJ3PwBhZSkqXA7ttooPhfdykUPFJ7QP+OpW2KbDqhGtbbQtNfc8U8eudvPbN4yPFrFftMM7VmaUHoDF7r02v376vX6fyeXFbtblQImSQCpDaJqIPB8OdX5LGTl/Gz3z0qoSdGY0uQi36BP1umpSGyiCJoFiY32ddltU1JYCnpBYSqik+S6Mx9LUZOAMP6ntO6rG3aSC8m48soCLKwcKHJSBGgV4cQexf3ynOr6BX0pbfLQnK7OYQQ89UVpmlpgK4JciPC5IRi1sOEF2VNw9QHGd0/sXRRY5y1TTUqWSw31fnG17YKcgTbphhpS+ExmgkZi0ie9DjHRZWwggMyF/0+BiJYlkSi89lz8wnLhy7FACMLZW45lOVL9ouQiDyTwkgq+j/X8r+nF4dnsLZki7byoWXYQPDDnWa3D9806dqUQNVwiK3rmkhhXbwOe8/Owl2Ez/dlnrjwF84Ezz0a
 rGj3rogw
 qpesmO8bUb22Javx9IV2aWtzoHFfeewwh/PQs1H/Vmwh182LjFsVIXwAUmx2rk3tYPT2oseFAaFhfAGKoHRdfNHBghIjvgugPeK95omgFQdCoS/qkQpDxdB1sckamdqkimZ6M+HSQxkL+hSu4xxwSWTG41TYl+Gofhmqe64nugHNs5zqVEYti51/GOm0asC4LY3vsvbvu/FOi4HWIIpzxyMIjU6tdemDxJKkVXi41ICzN1jzzgKirqBP0V0/6p9VbzwOsqwo4UBtJ9sDP8O4FIaXo5i0a/JxlRsnEOeoNe6eG3Z+jwVHKeij9yo3J/rz1CoizeNVwSgYU/GE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

offset_in_page() is a small page-arithmetic helper that has been around
for 20+ years. However, page-offset calculations are still open-coded in
many places and in different ways:

	(unsigned long)p & ~PAGE_MASK
	(unsigned long)p & (PAGE_SIZE - 1)
	(long)p & (PAGE_SIZE - 1)
	...

Some of these open-coded instances may be due to offset_in_page() being
buried 3000+ lines into linux/mm.h; others may have avoided including
linux/mm.h, which is a large header that pulls in many others.

Patch 1 moves offset_in_page() from linux/mm.h to vdso/page.h, which
keeps the helper with other low-level page definitions and allows users
that only need offset_in_page() to avoid including linux/mm.h.

Patch 2 shows a concrete example where including vdso/page.h is
sufficient and including the large linux/mm.h would be unnecessary.

Existing users of offset_in_page() do not need to change because patch 1
also includes vdso/page.h from linux/mm.h.

This series is based on akpm/mm.git mm-nonmm-unstable commit
d067a83c8063 ("string: use min in sized_strscpy"), which is also in
linux-next.

Changes in v2:
- Add a cover letter and drop the bytes_to_page_end() helper
- Move offset_in_page() to vdso/page.h as suggested by David and Lorenzo
- Use offset_in_page() in lib/string.c as an example since
  bitmap_print_to_pagebuf() in lib/bitmap-str.c is being removed [1]
- v1: https://lore.kernel.org/lkml/20260517123428.1181981-4-thorsten.blum@linux.dev/

[1] https://lore.kernel.org/lkml/20260519163058.953690-3-ynorov@nvidia.com/
---
Thorsten Blum (2):
  vdso: move offset_in_page() from linux/mm.h to vdso/page.h
  string: use offset_in_page() in sized_strscpy()

 include/linux/mm.h  | 2 +-
 include/vdso/page.h | 2 ++
 lib/string.c        | 3 ++-
 3 files changed, 5 insertions(+), 2 deletions(-)


base-commit: d067a83c8063d1bdcbd9af8e1326d846f85138b8

