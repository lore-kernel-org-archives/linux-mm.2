Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85B12CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 08:06:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6A7C8E0012; Tue, 16 Sep 2025 04:06:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1A238E0001; Tue, 16 Sep 2025 04:06:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B09F68E0012; Tue, 16 Sep 2025 04:06:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A5078E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 04:06:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 43F89BBE58
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 08:06:29 +0000 (UTC)
X-FDA: 83894381298.09.EA60E16
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf27.hostedemail.com (Postfix) with ESMTP id C92F240005
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 08:06:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of xialonglong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=xialonglong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758009987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=IYV8J+dK2kbrPHIOMi8Vhxl/yERmTA6vK22eAeBBX5Q=;
	b=zaQrLhRft4q8oDGjBztQtX/6MZh6BP0yN1PvhKjac6I8DBGh+5SGyLDibrK7ZHP+nzF8hY
	ulkp3kAH3AQ56WSuaibvpnPoK2GShNdbZkFQwPQriMZt2W/f3kqSGr3igZjfsNOnM7XMIZ
	f3Xo4wCreNkovtHMEp+nXGmb58FKAGU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of xialonglong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=xialonglong@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758009987; a=rsa-sha256;
	cv=none;
	b=XfNwedCwYZCaXWqZUrP4mBKcRn03Amqk3BYiiHzi+9t31pFnNNTpqWq+fpzIFJOV0Eg0yw
	1Mw4dAtmrkMlA8yLz8o4uY7cfWDMLQ9Hd42T1DK7XNCHt2dOCy69wATImAmVyWV0FkA1Uj
	S67j/VOcRve0uXMwJBWj5zCye6Dc638=
X-UUID: 04c7b0de92d411f0b29709d653e92f7d-20250916
X-CID-CACHE: Type:Local,Time:202509161557+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:525affbb-c15c-42ed-a3bb-ed388d6ce25d,IP:0,U
	RL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:25
X-CID-META: VersionHash:6493067,CLOUDID:dd8cac28ab574c40f89e524f978907ea,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|50,EDM:5,IP:nil,URL
	:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SP
	R:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 04c7b0de92d411f0b29709d653e92f7d-20250916
Received: from node4.com.cn [(10.44.16.170)] by mailgw.kylinos.cn
	(envelope-from <xialonglong@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1339358385; Tue, 16 Sep 2025 16:06:15 +0800
Received: from node4.com.cn (localhost [127.0.0.1])
	by node4.com.cn (NSMail) with SMTP id A5CBF160042A0;
	Tue, 16 Sep 2025 16:06:15 +0800 (CST)
X-ns-mid: postfix-68C91A77-166109859
Received: from kylin-pc.. (unknown [172.25.130.133])
	by node4.com.cn (NSMail) with ESMTPA id 3C10C1600429F;
	Tue, 16 Sep 2025 08:06:13 +0000 (UTC)
From: Longlong Xia <xialonglong@kylinos.cn>
To: akpm@linux-foundation.org,
	david@redhat.com
Cc: xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Longlong Xia <xialonglong@kylinos.cn>
Subject: [PATCH 1/1] mm/ksm: remove page_stable_node() and use folio_stable_node() directly
Date: Tue, 16 Sep 2025 16:05:33 +0800
Message-ID: <20250916080533.2385624-1-xialonglong@kylinos.cn>
X-Mailer: git-send-email 2.47.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C92F240005
X-Stat-Signature: nqcmjukfckqro9pgf4bdop7h9q1mhpyw
X-HE-Tag: 1758009985-618563
X-HE-Meta: U2FsdGVkX18wE9cV97HTQ00dYwIju3sVkHq5tJPvgbkWvx5k7ZviY6ErJzPIi3H44SLJ8hf7JYov9wDPdHIwMeabKN+BzTG4pbe0d3gPjEiacbkLfbgc5KuSNrMgfNFLCfQoZHMMsGqfwyT9mN9wi/gUSEZBeMj2uuZB1Dytw07Z5XKMcywiphZfbbn2LmRsUnvQM4mh1Lb2XcEu6xsqrCbbE9eV5hQTRQA4pLBwDSaEXLew6fBdwTuamVuU7yEpsPBqY1W6496HcF/33cNICsAU05g98fyZAUp7jlBO5ZzA06c4fh7pIKB2Tyg7CKiwd3v4semyCX2GiqupKOXe7/VhfS7zMT1k0N6zgVWr+J87AV43s4aWj22Dro+hRmvznHatF3jSaJGjNmZe2meVM1w2cQGKP42i3gL6oOm+66IEVtYJ2X0jztzjGsxmSwpoLrdGBVgR4oQUMF4xn3oFZhr0TZIAF4Syl4m/I/8GNiy2CaUrMVVyxBgwsjUjlUMtz+h0YEyl+J4pHol/FzKl34bsor9he5dkczVnunSB1pwa+s4Lyw2QEA879loY8rLUMvYRrriFbZnLUuDMlID5nj7SzXgbp1NaV7URFAxEiXxnItv51b/bE6TeQwXBiMW3gbhIhs1usKVXJzBnpoFM/ze+Rm2H6rW53juc4UxRu5rBQmN1bf9Jfe/MCVZ2ELo6DbrWFSdDmrQXJR0lv6YlbTE2t6B51SRVGj7l5OFtTpPKjZpbpy+VESkswf+LnIETyd+SvMic4fIfvDJi1gKhRSEE8YFdJqa1VwJ/WQX56uUHlfLpJq8hMEv6EXy33an3pFigHDoxad5AEm9l438/R15UvsOkxMhsPvavreOrRvkZ+5eiSWM9WWKCNwSzGQoGsNKpsFDpe5ODlmPyHSVTLWXybj/1qLo1tQP3XlbDxr07o4cLrbr/EF7/sndfdfJ6xj6ncXWdW+eseAGQrNK
 LU/L718U
 ZCjmWYtZaeTELOmJRVFK7AWNqs70BOjKIrP4gUH3kW4YwTlLIcMMg1b255Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The page_stable_node() function was a trivial wrapper around
folio_stable_node() that had only one call site. Remove this
unnecessary helper and call folio_stable_node(page_folio(page))
directly at that site.There is no functional change.

Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
---
 mm/ksm.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 160787bb121c..eab5348d19a7 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1061,11 +1061,6 @@ struct ksm_stable_node *folio_stable_node(const st=
ruct folio *folio)
 	return folio_test_ksm(folio) ? folio_raw_mapping(folio) : NULL;
 }
=20
-static inline struct ksm_stable_node *page_stable_node(struct page *page=
)
-{
-	return folio_stable_node(page_folio(page));
-}
-
 static inline void folio_set_stable_node(struct folio *folio,
 					 struct ksm_stable_node *stable_node)
 {
@@ -2233,7 +2228,7 @@ static void cmp_and_merge_page(struct page *page, s=
truct ksm_rmap_item *rmap_ite
 	int err;
 	bool max_page_sharing_bypass =3D false;
=20
-	stable_node =3D page_stable_node(page);
+	stable_node =3D folio_stable_node(page_folio(page));
 	if (stable_node) {
 		if (stable_node->head !=3D &migrate_nodes &&
 		    get_kpfn_nid(READ_ONCE(stable_node->kpfn)) !=3D
--=20
2.43.0


