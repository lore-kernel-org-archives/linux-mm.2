Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBAB1606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 06:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=OwBLaZmz
Received: by kanga.kvack.org (Postfix)
	id D7A666B00EF; Wed, 18 Nov 2026 01:07:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D52A96B05B1; Wed, 18 Nov 2026 01:07:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8F566B05B7; Wed, 18 Nov 2026 01:07:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A26C06B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 01:07:05 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 356FFA82FB
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 06:07:05 +0000 (UTC)
X-FDA: 85447206810.07.FD22DC3
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf03.hostedemail.com (Postfix) with ESMTP id E7DAA20004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 06:07:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=OwBLaZmz;
	spf=pass (imf03.hostedemail.com: domain of wangxuewen_ky@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=wangxuewen_ky@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794982023;
	b=TTFPf7Pmm1m2XG9WgC234PFjE4fUdC1EuOFF1bW4iqyo9IPw2vQVKtppN/QO3/xUW3obgj
	OHNFPIRrv708/oe6EUYgPExEJ3tjMufxecnIXexRoxZOgYQWhl7I+G2jKVCj+DysOFR9aG
	SZLHsFBiowR7M91nfaArvFj3qH/Elbo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=OwBLaZmz;
	spf=pass (imf03.hostedemail.com: domain of wangxuewen_ky@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=wangxuewen_ky@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794982023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2O/0GxFTdaVqIt+Fh1ZdEiw319MytGrC5ThQaqmf72I=;
	b=4KHetFuJj4lBMMcJdG5JHCjAeNFPAR9anuhAACPTx+zSVINNrXRtGBY+ij/JE+2gTvMXZF
	UxGCV0JxCjTwCB4LiRRTQZr29SRVHbtpxnsO0aEZqvFO5ih6fGbK76iHKywK7LotYl5rF8
	OMIisAHpXtUP9ZtRa/tyxWSfYXqGN1A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=2O
	/0GxFTdaVqIt+Fh1ZdEiw319MytGrC5ThQaqmf72I=; b=OwBLaZmzFpmY1aOtGg
	50Wyv/UM//zVBXv0x8LG9ob7u9Tu1OnDeb/BYUC7ES/d9XsJssK+X4dm9RKsuOqj
	RYW9XSkaOYWz92gSyQvBJP1DRecpFkyWdnJq9tDW+gyoIC3Yf/3Ii/Ipx9UhKlP/
	DBp/QlXyAIpzcxzYc+/TR1EPM=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wD3HwjJP_1qmvfEIw--.16665S3;
	Wed, 18 Nov 2026 14:03:55 +0800 (CST)
From: Xuewen Wang <wangxuewen_ky@163.com>
To: vbabka@kernel.org,
	harry@kernel.org,
	hao.li@linux.dev,
	cl@gentwo.org,
	rientjes@google.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	rppt@kernel.org,
	mhocko@suse.com,
	surenb@google.com,
	sj@kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Xuewen Wang <wangxuewen@kylinos.cn>
Subject: [PATCH v1 1/2] tools/mm: slabinfo: fix inverted numeric sorting
Date: Wed, 18 Nov 2026 14:03:16 +0800
Message-Id: <20261118060317.1802620-2-wangxuewen_ky@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261118060317.1802620-1-wangxuewen_ky@163.com>
References: <20261118060317.1802620-1-wangxuewen_ky@163.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3HwjJP_1qmvfEIw--.16665S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7AF1fCry7urWxJrWUGrWDtwb_yoW8Cw1UpF
	Wjy347Cr4v9FWUCFWUCr1jqFWIgr93A34Ut3W0kryDZwnF93WSvF1FyFZxCrW7XFn5Xrs5
	uFykJas0vry5ZaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jJ5rxUUUUU=
X-CM-SenderInfo: pzdqw5pxhzv0xbn1qiywtou0bp/xtbCzgscBWr9P8vi8QAA3s
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E7DAA20004
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: c4umptr33gym7r7fixgebpnh9ebkzf77
X-Rspam-User: 
X-HE-Tag: 1794982021-645791
X-HE-Meta: U2FsdGVkX18Gln5RujiuV6ZOyNs/zixariXfLvU00/QUtJgBb2IQtiXcj3GN+lauZIDlFSHkxw91tGAWe1I6GIxcmYaW56dz4JM0rUL7P4eZlxIAP5ZoYeSTaiXhCj8kXFjQW7ToULyEsYLhHQYxm3XCLyUw6auQDqE3dGjIMPKX0mXZ1FFpi0+YG48gcgqFp7wZVjHOyggBIEOyJnmBo1y5p7BG9lvkIBt40OjSmDwnIZ1uj3iOXmhahL85Scysf6eg2PRbQFyZHng65xy5/xcNQPVuSyUN6lCH2Zrd7SJUrEUh42lLT2Uj44nqcl1q5NrT5Fn0lPl1pCJl96v5iORq8/ffeeWoHSzaAL2gTrfE7Za3KQcxEl9uh4rfw+NkBHh0p+lJGIDefTNhpBg2eNX9LS0DQeKTpXAaX9FjQIMm2MS9v8IxXJPuUnUfEw4FTXNcCA9mmQtM94ME45b1T1YgVIzGIsuGcPLyTN0ZEbAben59dA0jmr2JHYUASFhwVnHgiZlbewqFID8apjLVb/BR3eWi5PUfnwXSA9o08kv/xbQThpFGpOZWQfG3Xtugzkr0EIMCduBVYCO95Lf7rCkJ+dJnKibDm1RMxBUY11oNh2bvGRkV5ezEap8u+LclJy7umBIT8mQZl+oliS3Cc4C0gUfZHzBwKdejOyjN4ikcn+XTuN+fgQbBqi9m4v6w66PQLSwsJOjXQ1K2lrBtuZNaP8quwjxj4OLLDJ4pBYkKsG0WZ0xILKChQUnD96An3OdgyaudjFpADfiuoL6DyQ+AhuMjZcJL8v3JhapDKmpYdKDxe9J7GuD4oqnw9d71DPXFFrecapg6V83L11v1Kgp7W96kbqkvHlo/r85vb9A3gJkZuMPC7lZIzf/qPEkXwTbcvnO8n4Y1toVAJtK6rrQrXHCltM3sntUyCftS90OuSmvGz0b8iR/mbIc2jF7ZovGpvzdN+Rm6J4a6mto
 RGciEj4M
 skEftxFfZtGk83k6uQrBzXNpn9BLgKrfLiApzYJr1obOX9ZzpzsF0GiAzPCH4HmMpyBCBs//J7V/L2WcCE3iRrDyysWUqtNmwl59i/6NzB+YJ2nDj5x3NXKdvTQj15JHsxy+VW15/iB0o+EZIzVO54pQZKkwSL7PH2DqqeM8LFikmdvwcNNL+gwky1Mvw/ImnEkg+6lkVr13x1fg2LBQLWPNCvhUn0K42xqFXJ2PGNvA2MInf1w0Q9HCCYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Xuewen Wang <wangxuewen@kylinos.cn>

The numeric branches of sort_slabs() return either zero or one for
unequal keys. Negating these values for -i never yields a positive
result, so the sort does not swap entries with different numeric keys.
For example, partial-slab counts 30, 10, 20 remain in that order
with -P -i instead of being sorted as 10, 20, 30.

Return a positive or negative result for unequal numeric keys so that
the existing inversion works for size, activity, loss and partial-slab
sorting. Preserve the alphabetic tie break for equal keys and avoid
subtracting unsigned counters.

Fixes: c09d87517298 ("slub: add slabinfo tool")
Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
---
 tools/mm/slabinfo.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/mm/slabinfo.c b/tools/mm/slabinfo.c
index 48d1ee8b0e81..3e62a2fccaeb 100644
--- a/tools/mm/slabinfo.c
+++ b/tools/mm/slabinfo.c
@@ -1075,22 +1075,22 @@ static void sort_slabs(void)
 				if (slab_size(s1) == slab_size(s2))
 					result = strcasecmp(s1->name, s2->name);
 				else
-					result = slab_size(s1) < slab_size(s2);
+					result = slab_size(s1) < slab_size(s2) ? 1 : -1;
 			} else if (sort_active) {
 				if (slab_activity(s1) == slab_activity(s2))
 					result = strcasecmp(s1->name, s2->name);
 				else
-					result = slab_activity(s1) < slab_activity(s2);
+					result = slab_activity(s1) < slab_activity(s2) ? 1 : -1;
 			} else if (sort_loss) {
 				if (slab_waste(s1) == slab_waste(s2))
 					result = strcasecmp(s1->name, s2->name);
 				else
-					result = slab_waste(s1) < slab_waste(s2);
+					result = slab_waste(s1) < slab_waste(s2) ? 1 : -1;
 			} else if (sort_partial) {
 				if (s1->partial == s2->partial)
 					result = strcasecmp(s1->name, s2->name);
 				else
-					result = s1->partial < s2->partial;
+					result = s1->partial < s2->partial ? 1 : -1;
 			} else
 				result = strcasecmp(s1->name, s2->name);
 
-- 
2.25.1


