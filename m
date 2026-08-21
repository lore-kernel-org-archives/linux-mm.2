Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D071C5DF8C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 19:27:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D396B6B00AD; Fri, 21 Aug 2026 15:27:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEAE56B00AE; Fri, 21 Aug 2026 15:27:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB2106B00AF; Fri, 21 Aug 2026 15:27:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 959906B00AD
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:27:09 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1DEA3C0201
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:27:09 +0000 (UTC)
X-FDA: 85126259778.22.F795665
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9319F40005
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:27:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=hKNAlr+8;
	spf=pass (imf04.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787340427;
	b=gVtfxMaHK5C5PQW6+U0RKsT/FEZvT66oD4WvicjARUtGLzBK3DuRRlJIyVFx96+TOcTG6L
	D/CYa4ltqkdTqTOVnIyWJP//27fS9caZa03XItwCve8PZ0Gp/9aZOTJtaMKAqSRf/7SPg7
	1fVkG+HVAHoX2CdDScM6u8n9zoZMAxM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=hKNAlr+8;
	spf=pass (imf04.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787340427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ySvyaqBnJby490O44Q0qs0efkhX6UCzOyNrGR/pLA+A=;
	b=2YadcdzYQsTkYuf5kxzfMqSfysvpgzSS64mMTlhtzNVWI8SKEellnDz6qlkPailrqXBOdB
	OKLtt2pgtL3wfhjFgSpLhJUfxmJiM17rKk8aQXtzyujUQIpZ83GhIOkaVfF5Wx2wzmXJxl
	vek7pPc+69YSEk0L5Cyc78Y4ricPQog=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ySvyaqBnJby490O44Q0qs0efkhX6UCzOyNrGR/pLA+A=; b=hKNAlr+8anoTJUphOAb5RwFLj+
	DVr+GQIEDDnvqink6wk94R8x4ThlEb8OyVBCSS7GpSBkGBCSZ7D2DAlL8DL9Mdyq5ZZSo/U86IeAJ
	ZV2Xd1QSbxRYk2996ok+56kthBfg/VkgsRTTSHoIUMFLLupRB3KQyMk4lHtwdjc7sg/+TWojdNxi0
	NE+HtBZW7e6iCOOveSu5jVcJPNvVo3rdOSee0RXl1YMftEk2SoCI2pX/2rvWpzDSakONrUB7pW2Iz
	zeypJ+k1e73WjMUacFPAyBYgT3W0EwM0LEjoQWvDJU1Of24jkUvXJ2skOqL7ifoFhFd3lu1ojO/NT
	TXaHLa+Q==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxUtO-0000000E0pv-1p6g;
	Fri, 21 Aug 2026 19:27:06 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>,
	Joe Perches <joe@perches.com>
Subject: [PATCH v3 16/19] maple_tree: Change two GFP flags in tests
Date: Fri, 21 Aug 2026 15:26:24 -0400
Message-ID: <20260821192627.4085470-17-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821192627.4085470-1-liam@infradead.org>
References: <20260821192627.4085470-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9319F40005
X-Stat-Signature: u61wczemutd3rkfoojrbonhnsbj6scjx
X-HE-Tag: 1787340427-876989
X-HE-Meta: U2FsdGVkX197a8E8S7Qmj9uLKdz6WdRF6GyoWjj8Ud1cl52dhVDkVj9Kvi3jzJzHb0jiFS2DwWeMMGDlfFsh2+tK4rtBNdkeF0kKQ422jNdAsfsuSMtnDpghtBxJUuMB5ECu8h2RgXCqII9hPfpYI2FMEqRF2xqgoyDc2z57LyvqT8cEiPJKMpfgOr4r+YYabnyhWubFFTDLMYzSNNcpmf2fNI5woRhBphUynhndXtSDCYyRRORJrgpubX7LC0ZohOo8anDsU0T5cLSnOj8yA9SnIxYik2nTY50wvoNNvbTYmzU+82730VOk2P499Gyn1LCK5VaMs3OffEfZBwJRmW33HufQWK3s2jHOXTvjS7AFdLH2iW2ky5Mm9RJ/Ak+HQC7D20gTQ9y+iJ88kxjdDTFB939D27AWx/ifTIQZGfL5vy5kgDU6hamaBrN2Mfpsp5VHi8P1D+04KGjjmGu9A1RR93ybSVQ8k5aztyBLHkHSq0ufmHbw4N69B2VkL8NPy4LkaYr+qhBG302WqJuw2FRpb+hCbob5bEjclrndZp6wNBBXK2+TbYIqZt1hyvhHmpcCIT12WXIeJMQzBvubc9C4mxLoeSB31geazWRqIHoXMOsj9GndMKwnyys0MGZooflciejql0IbKHBkvl7fhMwlCvpcqFPv53iDnfZwAVkRph5BomzAp0Lvr0W6pKeHgnau7+mRCYv18MXRe4gje7C4v0wtNhcOG+UjaYf1QksJIrF7luz98D8fSJ8jq3vHddmZxR1Ke7CCI5XYYTFkoAIBwW0alXQGaspfhRcLAVRlyHiSTE7oxCI7SM9F17uTFvGabdEYsSKBDxQ8JHawcoZ20lDBT5YY7QatSmpxOJiHRVOWgWiLqRr4rTI1TIjcyhKKikXu3I+ktqLHGGbwq6bwB/mXr5rB+2l/MLdxI4YU5r8tCOhVJohy3ay+VCwppqkM+qPRrUoHcEgPhe6
 nU3GrkEK
 RAYevfW21ETPAWcMM4Aw70EN2WfjH5yW6xHElsaq7pSny+oS8cZZoF4wXtc7CSoaRnG2ZNCNvSwjYVNIPwKMmJI7PUQDmkoB8oeKJv/O9DEH6f32OO+p4PkVwxmW1/m6KUZ7ZFXhCe8FQhT2PnEuR4FpkbslDMFfRh58DojsHGsKpJ+t3gWO3m6BFRCaRKWk/coA4P+clRiicWLNi6/jytU1Mr50zfp+Dt7DxylJ1LReyZprWtZF8htWb1uMW5YiDJ1/7rGSVJLnPQO8CzQ/7g4VTecvgp8CEGZsPvNOpvUpOUTQSIVkdwmMf4sd/VLzamUdo3/TOjOwQOAQf8JEUzmGPB9+BCps/h5x5PDzic0OUhf5qurXs+/kLDFJMrJC6Z6J0eAsO9wVWKNrpVSR7WfBIRVGltvn6ZKzEYEAKAO+GJvQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The GFP flags in two tests are obviously incorrect.  Make the tests
correctly run by updating the GFP flags.

Link: https://lore.kernel.org/all/d9cbb89faa5bdb71d451781d214a51ce8923a83e.camel@perches.com/
Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 tools/testing/radix-tree/maple.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/maple.c
index 0607913a3022d..d967e76a3c065 100644
--- a/tools/testing/radix-tree/maple.c
+++ b/tools/testing/radix-tree/maple.c
@@ -35234,7 +35234,7 @@ static noinline void __init check_prealloc(struct maple_tree *mt)
 	mt_set_non_kernel(1);
 	/* Spanning store */
 	mas_set_range(&mas, 1, 100);
-	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL & GFP_NOWAIT) == 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_NOWAIT) == 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	MT_BUG_ON(mt, allocated != 0);
@@ -35257,7 +35257,7 @@ static noinline void __init check_prealloc(struct maple_tree *mt)
 	MT_BUG_ON(mt, mas_allocated(&mas) != 0);
 	mas_set_range(&mas, 0, 200);
 	mt_set_non_kernel(1);
-	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL & GFP_NOWAIT) == 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_NOWAIT) == 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	MT_BUG_ON(mt, allocated != 0);
-- 
2.47.3


