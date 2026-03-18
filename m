Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED57410854D1
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 09:08:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B41E6B0141; Wed, 18 Mar 2026 05:08:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 365426B0143; Wed, 18 Mar 2026 05:08:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27ADD6B0144; Wed, 18 Mar 2026 05:08:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 168456B0141
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 05:08:57 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 94C1A160626
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 09:08:56 +0000 (UTC)
X-FDA: 84558609072.06.38BF63B
Received: from SHSQR01.spreadtrum.com (mx1.unisoc.com [222.66.158.135])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8D6A8180002
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 09:08:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=unisoc.com header.s=default header.b=FvGN5JM3;
	spf=pass (imf16.hostedemail.com: domain of zhaoyang.huang@unisoc.com designates 222.66.158.135 as permitted sender) smtp.mailfrom=zhaoyang.huang@unisoc.com;
	dmarc=pass (policy=quarantine) header.from=unisoc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773824934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Bw+j2EthuoNgAdy4WkrHKYeKPDOSVmy7VPuUpiShHc4=;
	b=FPOakICLzEdCLytyHwkdxIZOLi86Os1PkIB2Y+Wg9xy6Q7+KhzqSiJ/AIGdwKR4hgTSt/1
	c+UZKdAzne7r3ByOso7IlXP1B9+4b2Ho4BrGevZ1eYgcZ9UF8xWMJcLUV4oabhKdnORbX4
	pqCy0E4vejEj8F/EalL6NiImUSnoT80=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=unisoc.com header.s=default header.b=FvGN5JM3;
	spf=pass (imf16.hostedemail.com: domain of zhaoyang.huang@unisoc.com designates 222.66.158.135 as permitted sender) smtp.mailfrom=zhaoyang.huang@unisoc.com;
	dmarc=pass (policy=quarantine) header.from=unisoc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773824935; a=rsa-sha256;
	cv=none;
	b=b+rnhPpi87UwU9uN0f3k6zBWgFPyvvJmkVFdZMAnUZjiUQrcLZ/36aZyyR+Bw0D/z37EUL
	9xXWY/eRxjVJU2fj2Ajo49nG50V9iYjgTpEhM0QCt634SDQRNwl8TpPI7L6J3scj/WWjFD
	I4no+ZEHaFw+gVat8GsIQvEjdJ22BXM=
Received: from dlp.unisoc.com ([10.29.3.86])
	by SHSQR01.spreadtrum.com with ESMTP id 62I9778V062842;
	Wed, 18 Mar 2026 17:07:07 +0800 (+08)
	(envelope-from zhaoyang.huang@unisoc.com)
Received: from SHDLP.spreadtrum.com (BJMBX01.spreadtrum.com [10.0.64.7])
	by dlp.unisoc.com (SkyGuard) with ESMTPS id 4fbNG92rCDz2PGnwH;
	Wed, 18 Mar 2026 17:05:37 +0800 (CST)
Received: from bj03382pcu03.spreadtrum.com (10.0.73.40) by
 BJMBX01.spreadtrum.com (10.0.64.7) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Wed, 18 Mar 2026 17:07:04 +0800
From: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Axel Rasmussen
	<axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu
	<weixugc@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Hildenbrand
	<david@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Qi Zheng
	<zhengqi.arch@bytedance.com>,
        Matthew Wilcox <willy@infradead.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        Zhaoyang Huang
	<huangzhaoyang@gmail.com>, <steve.kang@unisoc.com>
Subject: [PATCH] mm: skip dirty file folios during isolation
Date: Wed, 18 Mar 2026 17:06:56 +0800
Message-ID: <20260318090656.1748509-1-zhaoyang.huang@unisoc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.0.73.40]
X-ClientProxiedBy: SHCAS03.spreadtrum.com (10.0.1.207) To
 BJMBX01.spreadtrum.com (10.0.64.7)
X-MAIL:SHSQR01.spreadtrum.com 62I9778V062842
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unisoc.com;
	s=default; t=1773824851;
	bh=Bw+j2EthuoNgAdy4WkrHKYeKPDOSVmy7VPuUpiShHc4=;
	h=From:To:Subject:Date;
	b=FvGN5JM33Mg7aSWxD6tIwBvBDR01T2ReejqXl2gcfWCfkueVHtLEgy9ZLXnSI8uw7
	 HcmgHtwLoc/S5aIB7IiuQ/7pYICH4/cHUvzy0CarItO99fGyvKvx6ePTWYdxYRz7YL
	 z3IgrHhjx+9xuLyugp2Qe7FVdbRcZ0QMrNoYeOaDgaXj0ZdrpT16eGDMUKdDgw+NoK
	 A7ixq92Nt8r0M6efvS34nftmrWeMwPwqpd6nkGbNKNm8x6t2319q6I7Rlu93SRbgzM
	 +l4C2qMrzyzMofRp/N2ZJEJtMd5o7Coacsp1btcoIccDtBG2Rdd4G/lUaLzgaiH6qj
	 /NHOQcs9pjc+w==
X-Rspamd-Queue-Id: 8D6A8180002
X-Stat-Signature: 8rgzz1az4qrixd9pkrnssdsc7qnokmwr
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773824931-915632
X-HE-Meta: U2FsdGVkX1+gU3/lF+MLBpYwVtyfN5+Yo3Mf/UVzgIzNCfqFKtD1TWI+DVmn+OD7Ia5C3bAM7w69VO/3HJu7N/6wPycFto1AF4MKv0EpeidmS3edzu7k1/ZoLJ9waLqcjiiTmYlsAB08II5Xv7MUJRAXNKFpa8IESGJf/b3XOxk/ZNgyFHWiJxmeTKQXJ0/37Cf6gj/QNAqjbHI2sr9Kuue3u3K4prXPt0Y1ECpjroCVI2IC3WPSGdEC9n9JF8iupPyI8OsGN1pmy+fJ5Ql73JEh+7RfiwRDLZiDaBwzGSdFkTEqwTYBBBHiiGLeBo9OFF9PryVkRgG2+nezEonxMy+Yz6sT/bHJpy5BABnI5SPWffGlyGT4xJ1RZGGJbytqiQzDtXi/6HMGjo498VRca0twktWbruLux2HywDqzBRj1iAFmrXbf3iqAC3ri1QTS/IJVyoatoJAvGFl6g8gzhk42yxfzFoo/fCxU2dk8q/XTzFWeKgGORVQl6w9r0vQfJeUw8vsw5vKSl9q9XjbsmEZBfaOjdaGI94SlEIYDx34QkpSK/eZGeBay5hkR9Yeez6lRRfEoUeBGdx4mSnvASCPfekHqn/ubvZCSF+LmNMH0mvAuqsKGC8hFFzI7ULYiLIQyNL/ROjZaB9PjhRRBjxfVS6EKKmqKhCQluc+yCEVLR7IFdyUtmgTlPqPoT44YAWdc9+jkblCH6CXLWyW95gOGLxvXgt6IJa3d9/jVxskAe+7/AWGt9OntTGsgsuNJNRpjtS/ebYPfv+ZhA6ICmBlvUgT3EMfyc3IKzAWtxgSbe4AuPwZcCE9aKWnqxWWgXf73M0wmoaA3Ue1bVo/pVVqNUlocUN25IBXjMCM56hk6+rszaGb+oVGB8nPzYWTTROc413cwnvwdbuJhLKRTydMJgWBvqZN0jDVL0sW2S4VyrjJWJLM11CrJ2ajTAGvjX+Kes++Xfnmwvt1odet
 Mtrdyw15
 5GimD0A7PZ+oQFEUQ/IF4faf3USi2NsqIZfBALUyDbeK58wpUKgbdqmQx4xbGvc0c7MV9nBjQxqpfUZqEwa1lYLTBSzCXCllozWQvqpOdMfDJ7/Mn7jzoDVy7fG8gKsv9ffP6pwtExJoCj1GTOZvUwgtBgXRhn6xjrEZadZrstxFXE55BW/gfu3WhXFe3zqFjYWLiK/N9I6nvbVjTnySqGAi+onbDVCOOqpVKDkYXzfNOeb/il86fT6/+XGLckjqBuvRCJU5ePWLJhDsCv3YONWqKi+5AzrIOFELk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

Since dirty file folios are no longer writeout in reclaiming after
'commit 84798514db50 ("mm: Remove swap_writepage() and
shmem_writepage()")', there is no need to isolate them from LRU which
could help to improve the scan efficiency.

Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
---
 mm/vmscan.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 10f1e7d716ca..3a029dede5ce 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4507,6 +4507,7 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct scan_control *sc)
 {
 	bool success;
+	struct address_space *mapping = folio_mapping(folio);
 
 	/* swap constrained */
 	if (!(sc->gfp_mask & __GFP_IO) &&
@@ -4514,6 +4515,11 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
 	     (folio_test_anon(folio) && !folio_test_swapcache(folio))))
 		return false;
 
+	/* skip dirty file pages since they can't be writeout */
+	if (mapping && !shmem_mapping(mapping) &&
+		!folio_test_anon(folio) && folio_test_dirty(folio))
+		return false;
+
 	/* raced with release_pages() */
 	if (!folio_try_get(folio))
 		return false;
-- 
2.25.1


