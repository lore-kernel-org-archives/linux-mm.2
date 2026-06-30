Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 932B7C43602
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 12:51:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 892C26B0125; Tue, 30 Jun 2026 08:51:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 843EF6B0127; Tue, 30 Jun 2026 08:51:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 781CE6B0129; Tue, 30 Jun 2026 08:51:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 59C416B0125
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:51:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EA664C264D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:51:37 +0000 (UTC)
X-FDA: 84936565434.27.0D61E62
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf04.hostedemail.com (Postfix) with ESMTP id 36A1E4000C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:51:34 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=SlOukZyT;
	spf=pass (imf04.hostedemail.com: domain of yanzhen20011121@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=yanzhen20011121@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782823896;
	b=xpas3XCXNVSCeKNFfcZXfEwSDSPQMjMVSquQtV93GJrjESlYR5+gvTbXZEdXGFM4+r0+XW
	U3461GH/jWabvbGT4kDAxQlWLrsCaENqpYzXFmHXhyi1SSXmXfR8XB4B1z5B1ybW1rzmyF
	F2Ahu1n093isZtadOjn9ugLa2eejUQw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782823896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y0vPmYUBULcu9w6m1I2L1iLW9ulxs3q8zoEGbABUjQo=;
	b=WXR+yhnE3LDeIlaC2lN9TLsTIrwcDpFzib7BKwJdCLevBlL6wsVYB541tZK6/MuYL9eJ/G
	pmBLceuQFol6L4sP1FZIwDu6bosfw/2xmOIQhBtWU1cHXxC/6FV6+fNGN0Irl6B9mSAx6J
	kbOUjM94SfwIWU0rCsJGfKI5X3TWJEw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=SlOukZyT;
	spf=pass (imf04.hostedemail.com: domain of yanzhen20011121@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=yanzhen20011121@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=y0
	vPmYUBULcu9w6m1I2L1iLW9ulxs3q8zoEGbABUjQo=; b=SlOukZyTkNunO2MBis
	N4mfiIHbCYanHitBhIBONgTnsQUjUHPnbTP/zZvO3hxAmd+yC70Vb2nmqacpoj8f
	MtwUNUZUnnFQ8qnjKkukjUrs0M3o+jrTmtN90pXELyj4LWt1P8qqPtgjuwMet+YR
	GbJEUYxOedzVLeuZnbYtqH5ZE=
Received: from yanzhen.lan (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wD3VyOnu0NqxxByGg--.14700S2;
	Tue, 30 Jun 2026 20:50:48 +0800 (CST)
From: Zhen Yan <yanzhen20011121@163.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Hugh Dickins <hughd@google.com>
Subject: [PATCH v2] mm: fix mapping_seek_hole_data() overflow on last page
Date: Tue, 30 Jun 2026 20:50:47 +0800
Message-Id: <20260630125047.703170-1-yanzhen20011121@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <tikbuxxazkmz5obcf6llp342vn7bi5tlgbbnuliw4jlwndj63e@jkp5g5oj6ug7>
References: <tikbuxxazkmz5obcf6llp342vn7bi5tlgbbnuliw4jlwndj63e@jkp5g5oj6ug7>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3VyOnu0NqxxByGg--.14700S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7AF1UXF1DAFWDZr1fXF1kKrg_yoW8trWrpr
	95Cr1S9rWxXw13Ar93JwnrJa15Cw4vyF4FvFy7Gr4UZFn8GF12gF90ka45uF9rXryrGF1j
	vr1qvFWjgr47XaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jYKZXUUUUU=
X-Originating-IP: [114.215.250.79]
X-CM-SenderInfo: h1dq6xdhqsiiqrrrjii6rwjhhfrp/xtbC0wiEiGpDu6gWvwAA3E
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 36A1E4000C
X-Stat-Signature: s4h5zsafoji3ty34wwezt85ko5kw7tc9
X-HE-Tag: 1782823894-882392
X-HE-Meta: U2FsdGVkX19RHMQEL+Wb3zn6E10lF0KgsUZOJY7jsNTp3vj4MIIo2g38/PwPuYTPf41eWefKUjNHHwMg+s8G1bJ1sWXL8hkBd0SQZgAYs82OECDuxZKh8ARRaykmj5UTdre3qpTFrXZoge9CDmmPBJpQMWbCJgYC12QbZQjE68zgeMqg0uVwlnrkucptmE1BLKCIF1NkGW/GTwT6JsVjPEESFjlsNYrwEYoj/aNP9sPFxTkLwH5uNcO96/yjeUBq0bhzZFw3MYNeykoJIiBjUtptpD2MBFN8R01+KtNtMLRZqAMQZJp+BhZrJKtPE9+ij/u7fefGw2yTysuk2vO3cfvnwCohn2NziNBeJW1xFh01d21ccqbndiRJGFO2Z45YHugm9IByVvxfNun1q6Z0L6DbMP0zNErzY0R/Itp2TqQR/1k2ntGzn1NNucZ/i6r+v7B/gs0etMN52Jj3U1HMfNWIfcmdz2QqbD4ii5iBoevy+k7ffXl5wyDAgBmk4oOVYzXIWeitGQipAWWvXT7MtilzvTgspuj7vjbwhNWUZZ87sLlfrBsNLtV64kOqNw6eTT3ete2oYEDrF2pmTeBlUS8Yd8PA1UnYb7zNkKyG0t1vhBqkxuT+oJJtRccobuusC04kXy1svjxbXwTAhjvPGLqOIc2emU8K8nd08lWSPLde+SBbnMQNlsxOl+PCfDjZoyZtpQnXEyVVMGrkYWaPUrEW5rl0C8PfOPe2PCpktnVpVsTkxb69wfU4W97TrSGa8qLpQ9iXVpOmk54vsuymQVPl1W4JYzg9cCbjDUnDXUFFwSjRY6IP1pct3aHTk9qLiphe5yVadvlG+cRSfZ7G+hyOZNMnshggDYpGY5jPyPT8xtUiVRVMRf+Pn1yQ29N6XO4cM+B6NXO8XTAd3wipX0HN9cutNIzhcXZD1fshHtWQbJHKFUQGK+d7W/ZyTZcIp0/4s5W/5qreED2vdXb
 rmiUX7ZQ
 HM+2F8JXQYBarD7fQ14MuBcWGF3HPGdsjN3/+GO9i2MhnMuX0pZFfpC1JAdh03dJ9ez4uU+nynBCAwBlCn1nRy4uheEc0Pc/kPjnot29HgxmIplscx3Sdji06yGyVREiKcjp5dEvxnEMB1Whj66TpNSM61LxbarLyyv4/WJil/PgKXFlcz+kLzhR+yn/v5c8EEY6Po8VIyVuh2yzhmWfKM/6DPYT8sxjinykB2z1Dk5QUwzhM+juV2wF5Vf4zm4FcPaBWttTGMEYrRyF7prJRPvl9eWmZabHI7lsQ/vFtMyKNNmUS8B7PWPEh98fXz9+0v5EWj/9sTo5AzsMDYM6qEGrYuLSnvBJZ2AUYxd4yaSHa7YSohPrD/Al4EsBNDNk5XQ3Hu7a8tITZpe7l0QPukjpdrEJsxR1V+wVt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A local unprivileged process can create a shmem/tmpfs file with
i_size == LLONG_MAX using memfd_create() and fallocate().  If the last
page is present in the page cache, lseek(SEEK_HOLE) on that page
returns 0x8000000000000000 as a successful offset, which is LLONG_MIN
when stored in loff_t.

The same file has readable data at the last byte, but SEEK_DATA from
that offset returns ENXIO.

The overflow is in mapping_seek_hole_data():

  pos = round_up((u64)pos + 1, seek_size);

For the final page below LLONG_MAX, the next page boundary is
0x8000000000000000, which is then used as a signed file offset.
When assigned to the loff_t pos, this overflows to LLONG_MIN, so
a subsequent "pos > end" comparison does not catch it.

Keep mapping_seek_hole_data() inside its documented [start, end)
search range: compute round_up() into a u64 variable and compare
against (u64)end so the overflow is detected, then clamp pos to
end when the rounded-up value goes past the search limit.

Signed-off-by: Zhen Yan <yanzhen20011121@163.com>
---
 mm/filemap.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 5af62e6abca5..b78fd88f2638 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3225,6 +3225,7 @@ loff_t mapping_seek_hole_data(struct address_space *mapping, loff_t start,
 	while ((folio = find_get_entry(&xas, max, XA_PRESENT))) {
 		loff_t pos = (u64)xas.xa_index << PAGE_SHIFT;
 		size_t seek_size;
+		u64 next;

 		if (start < pos) {
 			if (!seek_data)
@@ -3233,7 +3234,11 @@ loff_t mapping_seek_hole_data(struct address_space *mapping, loff_t start,
 		}

 		seek_size = seek_folio_size(&xas, folio);
-		pos = round_up((u64)pos + 1, seek_size);
+		next = round_up((u64)pos + 1, seek_size);
+		if (next > (u64)end)
+			pos = end;
+		else
+			pos = next;
 		start = folio_seek_hole_data(&xas, mapping, folio, start, pos,
 				seek_data);
 		if (start < pos)
--
2.25.1

Sorry about the previous patch -- the `pos > end` check was wrong
because round_up() overflows loff_t to LLONG_MIN, making the
signed comparison ineffective.  Thanks to Jan Kara for pointing
this out.  This v2 uses a u64 intermediate variable so the
overflow is correctly detected.


