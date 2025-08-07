Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFE6BC87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 14:43:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 613F48E0006; Thu,  7 Aug 2025 10:43:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E5218E0001; Thu,  7 Aug 2025 10:43:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FAAC8E0006; Thu,  7 Aug 2025 10:43:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3F6558E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 10:43:34 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 02840829C1
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 14:43:33 +0000 (UTC)
X-FDA: 83750229948.03.11FAA13
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 45ED1A0007
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 14:43:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=btSVvyND;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754577812; a=rsa-sha256;
	cv=none;
	b=VkvF16ZpPIeX4WqOeQN4x53OlK2nzZLXwWgVJfmRN6MJKSzdxScd+2s2ZuiHKB+a0aHQaA
	txTBvo1k9hTImzKo+YZvmCiwER+6/0lW49WDWZXvs0SVAzjDbqosQRSH1WbNyWVylDkBnW
	SclxOHIV/dLF/VLcLWeg2lvEbUlV+AQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=btSVvyND;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754577812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4hm1cBxL4CiOFlgRy+2RR5vulmGkLMB/1ZOnWypg050=;
	b=BQTYsocc53s2nZmauX70keZbwiyfWw5INLicOpU7OuRVsc2AyV6FZRjmSYrj7nnae6a53o
	oyYlevrlGEWqtQUFC+tEH08nwvRwBChrAsPCFq8V9T6DDAlv+FaMnpVki3T7GnuaVRIxY2
	RwRl8fAGXcVkg585D7/LGDlFiWCrRyQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754577811;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4hm1cBxL4CiOFlgRy+2RR5vulmGkLMB/1ZOnWypg050=;
	b=btSVvyNDDJNBG/bPzrLsNT9ib9+cluoUk5/wpkNNJD62HNIVxXo5BIPC0UwvxpWzAZswPR
	r13eJV6xZyKbzSUSttK2720fvrezv6XtYHnkMvP4NGtE4R4SMdOxsNBD0/RPFT+NjTS3FN
	pq2HKEpoXCfJWE4zs7RJX89CTQtl9ps=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-682-VCRoputKOFGGr0R1NpgjoA-1; Thu,
 07 Aug 2025 10:43:27 -0400
X-MC-Unique: VCRoputKOFGGr0R1NpgjoA-1
X-Mimecast-MFC-AGG-ID: VCRoputKOFGGr0R1NpgjoA_1754577805
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8F09919560AF;
	Thu,  7 Aug 2025 14:43:25 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.68])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 242641800294;
	Thu,  7 Aug 2025 14:43:23 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	hch@infradead.org,
	djwong@kernel.org,
	willy@infradead.org
Subject: [PATCH v4 2/7] iomap: remove pos+len BUG_ON() to after folio lookup
Date: Thu,  7 Aug 2025 10:47:05 -0400
Message-ID: <20250807144711.564137-3-bfoster@redhat.com>
In-Reply-To: <20250807144711.564137-1-bfoster@redhat.com>
References: <20250807144711.564137-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 45ED1A0007
X-Stat-Signature: 9dp5f8q6pabqu87tezbtcuox99jm9fru
X-HE-Tag: 1754577812-932711
X-HE-Meta: U2FsdGVkX1+d6GYrMuPUXLJS4cOpIW6oFinGvJ/PervDAQ5ZqlTGDG04SnY0YLeMR+c1oHm0/M9IVZ+umU9wViBYA4+svNkDJ5coGHWPbIXyfbXYjfSZTcXkT9qzZfSdZDn3yHw+TuS7XIOMesxXk/wUB0gTbgZNIqW0pa4MZfqZOQ5l8jqg4RUPRPi1hekgWiwuP/yqbpuqKvxwuReoVQBWXzVMX8AfPszIiI5ysKl0Qg67n5kndSIJmSPWlG8DfeX2vpvwy3x147mxjoHYH05KyKlnpbnGXuAzllVAwS2i3qMDvSyB4I6GTXVqLHRWfnGXAoWkQ/y5gQ5kTx4h+3R3d0ChXYVYsrosaT0+YtH8vXCVnig6PJ3506ZHm8/ynlTu1amDfDgJ9bl5Yegah6KoF33+hQn66IDu+AfTiOKaAqfsnDwSx/zgSgG1AW3+w+ODyCrdV4wwzpHxGbYe2LNDTOP0/YlJPW2vUCbqu3CECHU1OpL4pGRVusTwmTo15o4J82FT1hOYcI9k7rdUEjpf1aaN9MY3kKBIy7WGN6i2+GFUf59BGpLQMdJoeweeLCrfqvnCGhIlZSeeOsa6c0fdTm+qgGfLesdyFrhcMrArjyNsfxxksP4uZGu3RB1fdv4eg6uDJtMBvWHAJx9RcBtKE6je/njaBF5tTngSpWUZWEHDu0ITph6JQE5hWtFhE0lRh86Cai6EKb/XfL10ajsoPpIvULby3Q2fgILtq3IdB6SlTGqoxJeBjeCQVDljvNghH+x0XbEZFTY9ptwuQXOGARwTmV3ya3KaTZzzhwJMunlnTIBtySLbZAHusnugJrqB3g1V5w+X6yif9w9gNQijIUp8SD49QkQaLmbh698dVyJJzmCfSb+RKZc1L5Wu/93X2zwmEoUiezU8DtiTfhpBrVeHbYnl6rrHTmbSym9kRDUaQUBrMtQCKAQY/4jkQ4pWhIfILLt33Udmgp5
 rKfUDqEq
 +D9bvzrjBOR86LPY4gAp9+Z/beqSvTRMfsAN1NAzny/2Xwg40u7mQSvyMJKoZhITCwTZvBrG6JjPYzcHQvgXVMjIgH5LqmdHgrpURfN0ehT/3WvRc1eeH9mqGIUdUjPK+VO9HkHsnoipd0bRi1YU5IEn26roTUfK1Id7N25hR9zkYtIzoxLhxf3VOyQZ851/bOafmsU2iABffKszNACgfmnPLdQM/40wAJ1+Yr/a5YMKdZgNzjq5LCAgbRAuKN/Vr4L7gvViz5zW+HT2Y5VISqj+anrF6tc2CzCiI4FWdiyd6pmVhEsJdAPkiEqQHvbl2clLUAVa/GICoJUd5Ek7SUP//o1kdgVoRPw+/XOcpzq2Xjo8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The bug checks at the top of iomap_write_begin() assume the pos/len
reflect exactly the next range to process. This may no longer be the
case once the get folio path is able to process a folio batch from
the filesystem. On top of that, len is already trimmed to within the
iomap/srcmap by iomap_length(), so these checks aren't terribly
useful. Remove the unnecessary BUG_ON() checks.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/iomap/buffered-io.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index fd827398afd2..01721f10cf6e 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -812,15 +812,12 @@ static int iomap_write_begin(struct iomap_iter *iter,
 		size_t *poffset, u64 *plen)
 {
 	const struct iomap *srcmap = iomap_iter_srcmap(iter);
-	loff_t pos = iter->pos;
+	loff_t pos;
 	u64 len = min_t(u64, SIZE_MAX, iomap_length(iter));
 	struct folio *folio;
 	int status = 0;
 
 	len = min_not_zero(len, *plen);
-	BUG_ON(pos + len > iter->iomap.offset + iter->iomap.length);
-	if (srcmap != &iter->iomap)
-		BUG_ON(pos + len > srcmap->offset + srcmap->length);
 
 	if (fatal_signal_pending(current))
 		return -EINTR;
-- 
2.50.1


