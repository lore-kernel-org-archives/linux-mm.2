Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8578C5DF98
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 04:42:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98DFC6B009D; Sun, 23 Aug 2026 00:41:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C86A6B009F; Sun, 23 Aug 2026 00:41:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71C2A6B00A0; Sun, 23 Aug 2026 00:41:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4BF096B009D
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 00:41:59 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B69C812026E
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 04:41:58 +0000 (UTC)
X-FDA: 85131286716.19.103BBC4
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf25.hostedemail.com (Postfix) with ESMTP id 06056A0003
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 04:41:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Pcf6htPu;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf25.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=xialonglong2025@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787460117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rpJ8lj+pnCjeQ7J7KuEkjV/sMqGkbWtnr3XBGPFmpoc=;
	b=qTYunHOGB2tN4wyFlV6ewuPitZoWvwTdrXpNDiFpElH2yVsAwVRo8HXpQwGTdGhZ85yhg8
	mc3zhAr/UH4jGC+gKmdftpH/kZGWzACWPMLjNwufcC/Em2TZO+nLJSsqB8AGyZNiEoBoFF
	pWeWHwT6XDb8pk2fp1fa2rmgUcaAE+I=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Pcf6htPu;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf25.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=xialonglong2025@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787460117;
	b=f53Omd6hulfXszdQFfM/Mfl90NLv9Hk8yoLsDR8ozzXPYq6zWEti8oC9CnkYgovTw+GYn+
	3qduFCDFIoeN8HJxcjYqvyae0+ZgTWlF3mWK263d9+MESulmajz0t+OMEP7wGteGTRvgCG
	j9GtQYgrbXibGl6e+M6+9ZOj1iDlA8I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=rp
	J8lj+pnCjeQ7J7KuEkjV/sMqGkbWtnr3XBGPFmpoc=; b=Pcf6htPudBQzdQoW2s
	/XVkCZKemfMRGKJRUbUhwIdGZOB9wrVOrwywLGG4gNn3+wtgVADeWlBuMByW9Kf2
	YZMfGItNvkD2thWf3eLGpuOvg9G/nRKy95GarVfl3CNqtorghmoWNwoS5Bi+XY/L
	vuf4uLCZtYsywGqyGUa7kAg54=
Received: from XLL-9950X.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wAXH8z4eYpqyqI1Qw--.15058S3;
	Sun, 23 Aug 2026 12:41:33 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	david@kernel.org
Cc: mike.kravetz@oracle.com,
	mhocko@suse.com,
	linmiaohe@huawei.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	xialonglong@kylinos.cn
Subject: [PATCH v2 1/2] mm/hugetlb: do not dissolve gigantic pages without runtime support
Date: Sun, 23 Aug 2026 12:40:51 +0800
Message-ID: <20260823044118.1097121-2-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260823044118.1097121-1-xialonglong2025@163.com>
References: <20260823044118.1097121-1-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAXH8z4eYpqyqI1Qw--.15058S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7Cw4xCry3Kr1xKrWUuw4UArb_yoW8JFWrpF
	WkWrs8GrWUXF9rCF4xJr4UXrn8Gr95Xry09a4xKF43ZFnxG34DKrs8Xa18tayFvw1fJa1f
	urWqqrWDWF4q9aUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j7mi_UUUUU=
X-Originating-IP: [2409:8d1e:e12:7fe:fc27:3a72:bb72:5709]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC9x3a02qKef2ZCAAA3W
X-Rspamd-Queue-Id: 06056A0003
X-Stat-Signature: 8d7z933im9kusujokntoxn51ws4k7r98
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787460115-708212
X-HE-Meta: U2FsdGVkX1/xVbmbGNvKD2vohDUf9PN/GxkI/lOIV2YWGbYWdPiTI5Kn+iBOs9hjm8U3xVqiIXiDn2JBbR6ZM3taovniHln5K4e/bO/IWxcpuDS596jDYf9bXkxZASOhsTJ1ABqU5QV885VkDaN8m33n6edZrxTWYa8LZ6FaVMLlu5euPHgCQOFeQYX0hyuGsIuwlnqtvFiT+b4bg+LJL2eYWsjT7fjGIeRDbfZdIYOEnr/eHyPWtlFPhcNiWZH4sVg79vJMVhdtzqZCgDjJ/VmT5b+/Lm7zyL6etivdl+YGxzceBGS+rZuXLHDnu0oPE2cEUS6XSnAahUxma/8LcaZMeLiit2G4q0oU3o9PQHNz3ktOkhlRflQMbGmD7zaJMtAVLFdnKCrXwveu20OKtB/1kBhlDz2vzafwzPMI40Kax+KBe/3Pw1iZBOMdWzwjyBnsgiNh8VH6sgeT4LLZ7v2i3ff5X7I/sFBg6D+jrKSXZlyqKQrDtgWZlv0DEyY3Td0GX/BQAmVjpaMvitzjMsBmNkz2PtcVcYI7vMP+XL/CgTwbzReb0sGb35EVG/Pq7oq4AeLFgy91LAI8K2nDkgqSA0GgkmzgdrIiVtNnfTzb2lqSWFE4VxfWWJp0lpsGpts2u5xHQJFeIfQyM8OfLESaMp59RRdWuR+AIiQxfw3fpToUIYNLMIpSyhQRxoFpKJqNZ4qzPlkryYl0jOOxxDyaFPgyDcImICx7QPzGrWlvjujYwE+wVJXnLJUH5TBnWNtSLJni4weFq8I/vMyhYKMIvgFPhwUwe5pxwT8PDx63YqtuKeM5DfP8eNBJ2WVKzo1wRc2+2OD2B96LinethCYnbbAJdBOaazQkBk4VN1ZYtE0eChMIY0VRdoz0YaPLGmmJWb5+LMOUNRI55yC0YCXhoqaiNnwjdQVz+1m4th2yD1pD16kVhvRVi3tlUDb6HG5SmXyZLcUYhkEx1Vq
 a2dmCXwm
 AlsZQgZYxhgsjiMO/C3oS8v+4duU21uR40LSP0Ijkgb4GfJXXesQ1PHATsLo5uT4IzqbNWvZSEo3WVfcbZ+Zy54CwCo0OqL2GLQXMz2ATpHTpu3ohL7/Jcu9pXgHmokRfCs3aiqcrHmHfpVsYyb2J/hKDoIVXAU4lv6GALJS/wGttw0avR6YGHnhTZMWoCIFJlnGqoPUPMMm4r/giJTQHlRvRc92am2RDsEiEzhMFsQgZlCSfZz/BgN6DqRcFiCc/wqBEW0h7n/RF5ikVBj9L/yFo9Gk83lc32mWuM05KiaoYTefCAX3nskVQ5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

dissolve_free_hugetlb_folio() doesn't check
hstate_is_gigantic_no_runtime(h) though remove_hugetlb_folio()/
update_and_free_hugetlb_folio() silently bail for such folios, so it
frees a still-listed folio and, on vmemmap restore failure, the
add_hugetlb_folio() rollback corrupts the free list.

Fixes: 6eb4e88a6d27 ("hugetlb: create remove_hugetlb_page() to separate functionality")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
---
 mm/hugetlb.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index e93c4d2456aa..8b9cb476a41b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1977,6 +1977,15 @@ int dissolve_free_hugetlb_folio(struct folio *folio)
 		struct hstate *h = folio_hstate(folio);
 		bool adjust_surplus = false;
 
+		/*
+		 * remove_hugetlb_folio()/update_and_free_hugetlb_folio() bail
+		 * for gigantic hstates without runtime support, so dissolving one
+		 * here would leave it on the free list and, on vmemmap restore
+		 * failure, the add_hugetlb_folio() rollback corrupts that list.
+		 */
+		if (hstate_is_gigantic_no_runtime(h))
+			goto out;
+
 		if (!available_huge_pages(h))
 			goto out;
 
-- 
2.43.0


