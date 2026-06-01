Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB3AACD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 11:04:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 616616B0321; Mon,  1 Jun 2026 07:04:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EE206B0323; Mon,  1 Jun 2026 07:04:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 504136B0324; Mon,  1 Jun 2026 07:04:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3D0066B0321
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:04:57 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DD9E31C1E29
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:04:56 +0000 (UTC)
X-FDA: 84831061392.24.0F691E7
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf18.hostedemail.com (Postfix) with ESMTP id B98D61C000E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:04:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of tanze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=tanze@kylinos.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780311894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=yomM2Y8UxQkX+yxythbelhWi1wXbnwWPsaH5WCedIj4=;
	b=dNNJjD4+Ic2ASD7Nc62uRZp9SjYyXK8MPlAxFkq0YTlL+GueBqGXxfGzyf2oovcBBSDaC0
	xeqaxNsUgEvN5t/EGwLq+7rfWUjF7JU1k0uCGy0cYrJZmxeaPpG5d06rAvRYedgmsHeyjT
	I3kxbyuaL9mXuM8cSfAA59M7pDyLd5g=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of tanze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=tanze@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780311894; a=rsa-sha256;
	cv=none;
	b=tNpirA8ieo45ZBE0TSEptwBUWd+dDFpafYzslMOu5JyaaufzUMgWI+Zy4uOmoy+TFbyi4W
	9m65WnkZaWTTTo+4J7Fh8it1516bgbfUR/1z17K4MpqLBLalS38Fl55wuCiPYXMoHsXjUy
	vAMC3hX5Se++DSdVb7ppf4reEv38x+Q=
X-UUID: b45cba625da911f1aa26b74ffac11d73-20260601
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:7a8b01ef-ce7f-4c3e-afdd-9491e2c62b7f,IP:10,
	URL:0,TC:0,Content:0,EDM:-20,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-10
X-CID-INFO: VERSION:1.3.12,REQID:7a8b01ef-ce7f-4c3e-afdd-9491e2c62b7f,IP:10,UR
	L:0,TC:0,Content:0,EDM:-20,RT:0,SF:0,FILE:0,BULK:0,RULE:EDM_GE969F26,ACTIO
	N:release,TS:-10
X-CID-META: VersionHash:e7bac3a,CLOUDID:5f975c8c3e6bfe6541c7eecfa5b962dd,BulkI
	D:260601190449W6QGVN2M,BulkQuantity:0,Recheck:0,SF:10|38|66|78|101|102|127
	|865|898,TC:nil,Content:0|15|50,EDM:1,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil
	,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:
	0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_AEC
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: b45cba625da911f1aa26b74ffac11d73-20260601
X-User: tanze@kylinos.cn
Received: from desktop-od00ebi.localdomain [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1277608410; Mon, 01 Jun 2026 19:04:48 +0800
From: tanze <tanze@kylinos.cn>
To: linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: willy@infradead.org,
	akpm@linux-foundation.org,
	jack@suse.cz
Subject: [PATCH v1] mm/filemap: use folio_next_index() for start
Date: Mon,  1 Jun 2026 19:04:23 +0800
Message-ID: <20260601110425.44784-1-tanze@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: mpp4ftbmatcndkheb4sbene9yxkmyq38
X-Rspam-User: 
X-Rspamd-Queue-Id: B98D61C000E
X-HE-Tag: 1780311893-254532
X-HE-Meta: U2FsdGVkX18NXJf9w8qBqTtGbxyZz2z7XLZib/2pJAhgTjDHqPqg/Vb4igchBh0pC7jp/fuHzSZoXJOt2/2AoYWLFacBkgErh4IYQ3czfL9NIFHzMx7azOInrU/E66Q4w29eJ90GYXn553oOu2VGbIJWgRycOI6MfWcU5WB0tOxUOa9XcbOQYyYG+C5wKm42AgcEPKB5jux+HMQwtnb49U/Q80CiZeFqYwssQrnVd2GKm+LX5wpIbG++hU3ei1BAuISqtjWewigft9P0sa3N0Gis9rIIw6klbqs76fx95wpPXkYMC1lI6ox1XU/gK81hzafw6Kg5/JMuzqWjASzNnFesLYHR+pcab5Z3u5l4ydFEr6NIuA+CGifs0EU36WDswteSqZwWTQ4W3c2Qo9ZM88Ni6WCnDeygs+oQ7DcLzbjv3NfgKdupmpTIrqbXt6ob0pzAjyv7FZ56d2cYLGNM1ynll5xfkajne/Vtwe0RxKABJnMhPLD6Ssjr+8FzYoTWmO4pbBgsrnyDlTgyct7Ia6SEzJFHN3aNcX55dALoQrCYG2D3Hvu/3x8XX8Y0EXs15ViCybe/+UH1Liuczzr4icdEv0M9lzbwLUgHDAR7d3jOdSoU450BnlAopOajYv0rseB511D2n7h7n3DiZFlYbfA7iQJ7gk2HLBGb+XI4mQwuYQXLIQU2SAZ2M2cc+/X1mCO6wauQhVKcL4IWwPkY8QcA1cZZmnepqNe77/6UB461V3CJl4U7A+/aPAo/8KeNylp+sfLKuMyZ8a8Z3U7jOG6Iy9IvhyqzFujJpgw7ZDZITuSH/Bf4wHcBY9tNKwmdXYm8NaHYG8XRStjeboaGQVQBm8AHbGhBx4G8TpTlLygUVkGynbqkwZiz8g+y6PlBkfli2+tgCn6Z6e1q3mq+uw7jcLx2p372x3pOpj+A4wKUU6dxvL/fIMgFKkFHwfIMbSTJ23yIVnSexfLwUbi
 sLevybnQ
 DT8vYCQjSMdSvVL+xjpSDdzxJZ4kkDMCc7b9bh1i+CNKFFb4iUi/x6CJWrD2BjubqfZhm4efEevbLW2OQuXXH8MGaOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use folio_next_index() instead of open-coding
folio->index + folio_nr_pages(folio) when updating @start in
filemap_get_folios_contig(), filemap_get_folios_tag(), and
filemap_get_folios_dirty().

Signed-off-by: tanze <tanze@kylinos.cn>
---
 mm/filemap.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 4e636647100c..e233d4a003ce 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2283,8 +2283,7 @@ unsigned filemap_get_folios_contig(struct address_space *mapping,
 			goto put_folio;
 
 		if (!folio_batch_add(fbatch, folio)) {
-			nr = folio_nr_pages(folio);
-			*start = folio->index + nr;
+			*start = folio_next_index(folio);
 			goto out;
 		}
 		xas_advance(&xas, folio_next_index(folio) - 1);
@@ -2344,8 +2343,7 @@ unsigned filemap_get_folios_tag(struct address_space *mapping, pgoff_t *start,
 		if (xa_is_value(folio))
 			continue;
 		if (!folio_batch_add(fbatch, folio)) {
-			unsigned long nr = folio_nr_pages(folio);
-			*start = folio->index + nr;
+			*start = folio_next_index(folio);
 			goto out;
 		}
 	}
@@ -2403,8 +2401,7 @@ unsigned filemap_get_folios_dirty(struct address_space *mapping, pgoff_t *start,
 			}
 		}
 		if (!folio_batch_add(fbatch, folio)) {
-			unsigned long nr = folio_nr_pages(folio);
-			*start = folio->index + nr;
+			*start = folio_next_index(folio);
 			goto out;
 		}
 	}
-- 
2.43.0


