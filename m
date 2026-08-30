Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A59E6C61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 04:19:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B2FC6B0088; Sun, 30 Aug 2026 00:19:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58A5B6B008A; Sun, 30 Aug 2026 00:19:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A03B6B008C; Sun, 30 Aug 2026 00:19:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 27C486B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:19:17 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A934240256
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:19:16 +0000 (UTC)
X-FDA: 85156631112.05.982B6CA
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id 98A46100003
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:19:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kq9hbcwK;
	spf=pass (imf14.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788063555;
	b=ahHgnz2GUjruMsJdW2wvwc7khN+JXeCR+6jj72FiA4rLP/2PObwkTdjYkIGYXeR0CqPI9W
	He1c7JiEaILWBN7dhShPN7F6Ke7KAibfBeCFmnsLt+kZ8YZYumJnpVcnO1ijvWfQc2xFSa
	2mbf9+GPQDtk+x2LeOep3Lk3gb1o1Kg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kq9hbcwK;
	spf=pass (imf14.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788063555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dejHJnjtKaOM8kEBucRI9H7VqzSRiRdAVrdQgRGUFkI=;
	b=rXD8mPmFHh+WSAEUwpQdvR8VukvX0z7tXzpo7r6FGGgoc3wUUCUB+mAPbsThRgNa3QTGh0
	V2oOljhq2bjNhEXBxW1fQLUF6nOEvTpCO4i67/vvy2FI45k6sUURpXuYqC9iZSi7Aikv2B
	rdyDh0NK3MAHSSmIz3uu/zCOk6065X4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=dejHJnjtKaOM8kEBucRI9H7VqzSRiRdAVrdQgRGUFkI=; b=kq9hbcwKXkJ4J1vRrFYKTsZrzz
	6lUCw4ImNf0uzG7wmavDvL2d1b1zE8A/RpsFFBEd2KjgADVNelaeu+Cc2ft0JaNcevE7WuveiN7Hb
	tuuPLC7wUk69v4nkxbWpYMUDTfv9hB1Rd+51IvuOI4rXruVCB/9lK9RX1+qkSSlUe/PNQoGfnKbnr
	FbqvDhWB9HA1L6PBoHuVyoe3P+DiWEWuQlRK2pYw1HhzYEuIWWYCtbW/rzc5y5iVbW1pda9V9RBwl
	edUQp11krj3umqsJsfHJRhphqubpVr29NMhHxEytCZURqMJYmtIFItwO3XcpwP+SOtdsg84LGxNjv
	2q6HPnXQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0X0Z-000000000hb-1c0i;
	Sun, 30 Aug 2026 04:19:03 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Christian Brauner <christian@brauner.io>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	"Theodore Tso" <tytso@mit.edu>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ntfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6/9] ntfs: Remove redundant FGP_NOFS from ntfs_wof_collect_dest()
Date: Sun, 30 Aug 2026 05:18:53 +0100
Message-ID: <20260830041901.2668-7-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260830041901.2668-1-willy@infradead.org>
References: <20260830041901.2668-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 98A46100003
X-Stat-Signature: 9wpsw5jz8zjdrgwy8ej79jzwntc51ajd
X-Rspam-User: 
X-HE-Tag: 1788063554-882552
X-HE-Meta: U2FsdGVkX1+jNdYobgyVVwyLrm3Bjq/7a4UuNDeGK4XAshbPtQR4KdeLmsEAGKHz4UN8vTZ/cYa5lJLMlCy9mxki2cX4hM4IT56grDrLsUJ7946G4R19IIczC6JxA/Lvsv4jhRFxskMseo8HpY4GH5zFJOv8ztAjrU5CniM/fIwfxGOuqsdBhhwly3oXYOhOc6FqX1mv9XP9BjoM/kKHbgVCE/7DIQOQr6pieVrK8hTgXi57sHwGjv11HMAVlBC7r/Jq8cFz26Ot5vLjWSRxvHSjaxSzvmgcM6eyYOZDjZWT5kulXC3tBuJDGEJBVxVdoX0ga605VgRH4at5J4A08G6J+TB4otZJ1hixFWGk8ALvIlxh5j8t/Ck30RbPUbssc9SOIZ36KTcf+Z4qvGBgewciL2qQ3SoY5P9b+tqHWvwCc2RMsuGHCpdjIPiafkr0JO8l1EjjetG7ASA/1at1POShUt7THOm6TI2kZG7pqfttA1rKTzxMJNooyUQEWVN2gUdfh53QUOCu1jYcNDUG34veXkCAIs2SnoQ8njsaAP1nh4ouhd+Z4gPAUvEwSQJqpouYviWf400rICwjpebzNGblYmL/FhAP2ncD11L6dgmTS+7p2yPjzVNOiiAxieeXNq1XsNy3N4pU+LWg7F8U0gW3x7n6T/rh8pBAhTXVvXou3PSNHVVsWU0qnjED7gLQCeoIdoQMSrUqi+mgbmNqjBG6J5TWxjpcG4d1Nunf23SIYRDlmxqTNRBlsWlsdE4F0dYPq/PoTB3EMAVR5+Zs0Bzi5/y59M+gE7VD4gjYuS2mHjJ6s3umZBvjDDrY0oSle6/rSRvLJ30TszzlCEX9w2uqoilgPgqo37b0+V2hWJ93/Wy3/uFggQpiSv0TQuMDMRW0BreLHcRUYsvxLvVZfv4MafegeNGM2UC3qqiYAgtkRDCtIcJ8JrliFUb+s9cQDg7j/ZLR8L7xGCcEyZJ
 uZBsVWC6
 xhPTEpaqzGui2EMN5v1c+RxH+G8swpja2a6YmNmLbkypXYlLEQCfDKFGgmsZYjAd//FAaoFIs9WxwcrV5XWQcrHsaomqlUvQ/d285hakj61o7Gi4836FWGE6MrK3uwNQ2cHzXkHE9nuGXtMDhV0jAt5sEYziiemVr+rhZwv5dnexhFwhjh/fafpgE139syn5NxVJnNMX+zTubi8CHN1lgWptlXD9uTuplcXVc8LvQiFHq4WOs8WeRUAWA3Jrg+8W5DNZsj7CfRd6D5ueu134d1a0VAVNlKcgdNDjACkxXt9HlvqwIlidOD9uRtP4BuaQqy5lJmfB8hRLUgbK36zL+6mc54+LAzKYqM9vrk0uv4P8UOWbcneaEH7bZ6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The flags already include FGP_NOWAIT which prohibits all reclaim, not
just reclaiming from the filesystem.  Use mapping_gfp_mask() instead of
GFP_NOFS as this will preserve flags like GFP_MOVABLE.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ntfs/wof.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ntfs/wof.c b/fs/ntfs/wof.c
index 8f84c2212eee..c981b4a3b695 100644
--- a/fs/ntfs/wof.c
+++ b/fs/ntfs/wof.c
@@ -464,10 +464,9 @@ static int ntfs_wof_collect_dest(struct address_space *mapping,
 			folio = target;
 			is_target = true;
 		} else {
-			folio = __filemap_get_folio(
-				mapping, index,
-				FGP_LOCK | FGP_CREAT | FGP_NOFS | FGP_NOWAIT,
-				GFP_NOFS);
+			folio = __filemap_get_folio(mapping, index,
+					FGP_LOCK | FGP_CREAT | FGP_NOWAIT,
+					mapping_gfp_mask(mapping));
 			if (IS_ERR(folio))
 				return PTR_ERR(folio);
 			is_target = false;
-- 
2.47.3


