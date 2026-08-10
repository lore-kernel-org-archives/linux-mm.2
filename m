Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E68AFC5AE49
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 14:21:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3156D6B00A3; Mon, 10 Aug 2026 10:21:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ECD86B00A4; Mon, 10 Aug 2026 10:21:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18E136B00A5; Mon, 10 Aug 2026 10:21:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D27986B00A3
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:21:32 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 68364A019B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:21:32 +0000 (UTC)
X-FDA: 85085572824.18.2220CE5
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf22.hostedemail.com (Postfix) with ESMTP id F23F9C000B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:21:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=JRWSYZBC;
	spf=pass (imf22.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786371690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S3D6qH/ZmLhiW03zXnR3WbvGewlE3ORw28iMnvFcpFU=;
	b=jKz3oBgqBx7a4G6FZoplDuCPnMOZZUFqdJw7M5Crx1rIpCaxhjSEjKtjbnaU3/VwzSZeWq
	CDsEdJKOijeHtaqAEllWXsgxy2esCJSuCOJmuzbt97jqE/lKG8UWxTMhd9A28G0X/nxB40
	/hbVx0MVDcOKqNLT+OLqaZ8Oojr8eSo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786371690;
	b=XnF+H8ufXJ7fEqP13I58n6+j7jRqJHEHSgh+i2Ht6mtYF7ef34AG7BkRsfOAVngiozfqJS
	3h6UQFkzKB963EViSGuSMQHmW4LQeDnRniq3daMXa/QrjgYVMavY7U+g1SUFhmXRBk79M8
	3ebfo7/kYgFgkdwBQ41QHKRT6sNfu94=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=JRWSYZBC;
	spf=pass (imf22.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67ACaIKL3029456
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:21:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=S3D6
	qH/ZmLhiW03zXnR3WbvGewlE3ORw28iMnvFcpFU=; b=JRWSYZBCu8mCmTGWvbvU
	vcg0D3UlltsT26b7Dm8dsoBNf7JUve2Rf3wjD1IGOE5C9j16pqyNDU0ezcYckvwc
	D3Waz/SlkjxnyGgW33tX+qEMIzPzxINHd5uVbzU+cUrZAbcWnmSr3EnYBtYJI0o3
	ERZ5M42fdtlYu6dz7fRDYPZioR89JsquAnO5/OtDICrbd9VXEXfH5Xnk2KEV2SsW
	CLLp/Hje3WnV1q8CXfs4PsWzBTDli793kkT5BR43TwtTuTHTFNEvkFGzJuA3Uq1J
	swB9IoY0ic6g55WRvljs2HHbAugTMQ3MF97vNlXzv0SK8utjBw+zMceq+dy3G4vc
	JA==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4fxv0pvddf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:21:28 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-51c26012cd0so17966521cf.0
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 07:21:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786371688; x=1786976488;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S3D6qH/ZmLhiW03zXnR3WbvGewlE3ORw28iMnvFcpFU=;
        b=qY/AFc4UVZ1KSlvJ+SMmsKbe60ER8aUF9guqJ50g7kEPfgFfLf4XUmGWAkFaMhXoc1
         EmSXLwYrFY3ROgeBiKflCn+lVP0gjr3NqqJHynhKzBePRwDkDLJ8Z15uhn/1CqQXCngh
         inX80e6G/D0klVGIZn2l6G/fK44OPJRSSPJzXeSMNup+8QTT84xmjHdDTwtoUJoJRYjv
         JlO106hIzIjgKtuaV2jCYmmrcdsvbSgGBQ9mqRRcRCWsfNGZmF4ZM3nGSZ6lRq+e405A
         yrkbUgSfokzHguob1TT1mNuUb3GtknBI165V4t2OK5ktmJ7d66N7DlakROCrzrDCqfOc
         SA9w==
X-Forwarded-Encrypted: i=1; AHgh+RpAXS24XNjYUgYisXLD2Rae9e5MrxFq20P3umvsmQ/nXyTpF4fQJH5E7jefX8Mk2OeBQ3iOynAlQA==@kvack.org
X-Gm-Message-State: AOJu0YxuCJqapAVqIoWbUlR9gSdG1fhy5qn8nvRDTVFr6DRNarwZ3sib
	3uUfGVo1o7nfLpKAzphyWJThqsZHcX6Y92hhpZiJlfKKCkuj+StcVcQpONsZ7XTq7MFF7AH7ffG
	wan2KIQ+uHVHDcsCpG3ku9io0ruWFLrOC+NmXpTRs5IseQl6q
X-Gm-Gg: AR+sD10pD1Yb1uI3/+0TfySvQ+Nerq2qxrrzgkhrbvYpdFEPNQAGAeIvEbifz5qc9ya
	uj6nboSGhB0FalLVStIDnyQcE60CiDC58Hc6gPU1r8/uWzQI0sC5qnP1xsXjt6essOjWbS4hvJQ
	VkKSbIlL2s+kTWE+t7i4WKD1HDq3TcBtw44/gevv0by9kpit4GJqHSgpJawVq+UQ9BocqvC6dZg
	SH/tg7K3/qmik3NluyFPLi3wxFxsGFy3sxhnlhvxM9+ZBI7VKReo8J8aARY5OKc8DRM3UPuBo73
	UtagnGExolzMDcytJ6ynvqzqCTJEkUAeWJxVFWpKwS2Sv/oyQime+FLGlSBp/wJ5EHnIRfAQgzN
	ACPE6ZiKq
X-Received: by 2002:a05:622a:144b:b0:51b:ecbb:206f with SMTP id d75a77b69052e-52d4c10b153mr22589601cf.32.1786371688054;
        Mon, 10 Aug 2026 07:21:28 -0700 (PDT)
X-Received: by 2002:a05:622a:144b:b0:51b:ecbb:206f with SMTP id d75a77b69052e-52d4c10b153mr22588901cf.32.1786371687575;
        Mon, 10 Aug 2026 07:21:27 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.77.155])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48002145589sm37383983f8f.1.2026.08.10.07.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 07:21:26 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 10 Aug 2026 10:20:20 -0400
Subject: [PATCH v3 09/12] ceph: remove page remnants from
 write_folio_nounlock()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260810-remove-wait-on-page-writeback-v3-9-dd7531704f26@columbia.edu>
References: <20260810-remove-wait-on-page-writeback-v3-0-dd7531704f26@columbia.edu>
In-Reply-To: <20260810-remove-wait-on-page-writeback-v3-0-dd7531704f26@columbia.edu>
To: Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Zi Yan <ziy@nvidia.com>, Christian Brauner <brauner@kernel.org>,
        David Howells <dhowells@redhat.com>, Jeff Layton <jlayton@kernel.org>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786371655; l=2482;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=nPmPX7TOd6iviTDoGDogGRf3WQ6WG/tn7FBA7wKc8Cg=;
 b=khqDuSvEeY3iayitcAW/vunwtinABTC4Duk+Il2kJMRDY3Nq/xhyvNiLwOwy1X/owlcNbZVu9
 Ak1lnHZ3pf+AG3RpWIeXjwYuSfobiQr4Gh3ucmIBMR06VcopR7ZiCb8
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDEyMyBTYWx0ZWRfX+49WM9E1hzqO
 jbmLOvv2iX8ASRfYgy/iTKy4HOOW8CZApyImrAdFR6W8wpuuLnWYGK7RUEaXhzsPO47E3IfEwVT
 JgO+navDAT4blDahVu15dbqDm5CeUEXZhbX3GoY2/1AKAvpzUY3m
X-Proofpoint-GUID: NQMOmwf4ey753iSRzC0oP7SkYhh_EOB7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDEyMyBTYWx0ZWRfX+ejBk/3A/FoU
 Dzd/W/orpmAstyp1CML+F/lHX7rrMx85jG32RcGmC61GOArNUvqYykdySpsYsGhwIkLEk/h4ESz
 IztnJHEprlY4+rOgjA16U50GgIDXGQ0985Y/vEpdB3isMvIpFLusOeMoGm/s4vhYXOzpwGmZwz+
 FOmOnsXMRBrwe2DGMdTOzG0kdrrUj9cpMuBCajVGaAm2/ywDY7YCwN1io1X4ba+x2dWvknBkGQ8
 ke1ygka7rgOUcETCqNw8luBT9LqPrarTaun3yQ8A9EvY06Qs9EX1nUte5K1NWGsHPtuYWcviUl6
 Y/wAa772QM1b7msB3AWMosEPoFPWR+L52eS9KD03matFRLVn4a59pAE57IE890R9mSL+VlqWPEn
 RMjhSSnOh/H3bQSIoWIUIG2OsclWAY7WjENJpAVR+C5MbdDpLZnFo69AC29lUjfrvVX+9WmkRJa
 OT99qReiWv3/hiF+wyQ==
X-Proofpoint-ORIG-GUID: NQMOmwf4ey753iSRzC0oP7SkYhh_EOB7
X-Authority-Analysis: v=2.4 cv=dcuwG3Xe c=1 sm=1 tr=0 ts=6a79de68 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=zHmcO6jMd5r4EZ4U0P0LQg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=vHg950cVU3XL5QtsloQA:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11870
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 adultscore=0 priorityscore=1501 phishscore=0
 impostorscore=10 spamscore=0 bulkscore=10 clxscore=1015 malwarescore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608100123
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: q6joch5oahi3wtyfqd1m8om73zzy483u
X-Rspamd-Queue-Id: F23F9C000B
X-HE-Tag: 1786371689-624911
X-HE-Meta: U2FsdGVkX1/Esv5Y9VEyX33LN1EuBRmn2Xk+JO052QWMXZgSjJoNnOFacXBEURrQwb7wJ6JnImrW4nElrcDsKvSNWqva1czyx/2yamBgzkL7XtHr0RCTx8jLnhvtX7G675tQwEoz/OTN6te1E+0RD16nu41/kjnsJesvLUHqIF87IFeLH6chSQb2e7AF5Ih4ShI6LFz6suP45e02c93xyiGg9JZmOCSIlx4VqGVEp67o6Ihq8sFXSQYxkSByEHvXYbG9wLoyfFpYIeuysNgM+7I+P1Mrg4DcaYZ512M/oz9s54zTsm4JuOR0It5fPv+GL+Cms5kFZEyQPO4bvaskufeiI3bdQeujEBG0kcSYlxnbWdICEix3u/73OsSTQlf34lFjo+t8TtPVNmB2dV9xIsX0E4Qc0iGjOcYFBwNZg6Ah1gyYrZf1I1Njgonw14pIHILkeG0H8W3dG7CUeLR0L8I9s+0cmKbVPXBEEKBy8w7P97pnqaMI1agm2iA4mErSmC1cjgLEZmlHbX56BXrwLvU7WNuhWrl6tyNKWKGXZ3S/kViMJXGqtSYBmgE7yacZ7dCl8nDaUBm9/191i7nRqm6jkjHzlVxVT+zRmLdvbOgTF5gc58opgOgeVTHCK5iTbqlfs1XJKe7vgn3rJbp0QcqUj3NRMzca0WmUgryQL39R/J4qHrDRAjmsksho5zut0kbhpCxN2z5ke6P6IsyV0Bxqyd7r2zFG7MV+Vw1Tv5IVB2FfDRZeSRlyRClqZUrkC3zMePQdIV0mHqt4shEnYFEX2JUtSXP7ncWQygGfYDDKUZpBvLVd9SChptjg1oG5jgixhCzn+fG+f8GnUdGOp7d/kb1Fm8POgaikkDsxqlY4ADR/YjVhv8Jszm9Xe7pUy4DRtANT0CKHYg14LlDiIP36o1vVlwiRxsX6aZ9l7P0IJROXxIiq6ABfVEF8HHxvbvM2EuR9JG0j7PxNBQ3
 E39u2RBh
 aj5Le2yAsK1GMyzihpSOIoBANdzj4YGgLUpE+2Sa7hbchIkXy7aGOTsvWSQ5YE5esdx7LNwA1wTdgJS6sUqc7KH5WTKNbNewy19Z8+PI2NFgsS8ft+B1BJ57PqwI8+2qnI/CZ1J1hNGZ7LVemP3u6TPtK91yYoLiaJRuGNApUEMNgT7XhFmk0E6nicJVGbvpZBWlZCsI8rIs4p1e8Nz7Ie+GnpEbszTWg8+CR4A+s2+DMkkIa5uN+PZlHnWDaZtMa8zXLSwTzKwn95hc3TdCUALOUAS+T4BvPSlG7H/DKh4XQpKVxF93oCNEYXvc/F+OVnKkagpUhU1+F3rX+6c2jKxRTt3OjMlU9x8zgQxvqCUMq7+CDWhR0MJmiQTgGkBncruAwkafvZ3QHJjA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use ceph_folio_start_fscache() and only use a struct page pointer at the
osd_req_op_extent_osd_data_pages() boundary, which requires a page
array. This removes a call to compound_head() in
ceph_set_page_fscache().

This was the last user of ceph_set_page_fscache(), so remove it.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/ceph/addr.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index a3324da08123..ddb12fccdcff 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -558,11 +558,6 @@ static void ceph_folio_start_fscache(struct folio *folio)
 	folio_start_private_2(folio); /* [DEPRECATED] */
 }
 
-static void ceph_set_page_fscache(struct page *page)
-{
-	folio_start_private_2(page_folio(page)); /* [DEPRECATED] */
-}
-
 static void ceph_folio_wait_fscache(struct folio *folio)
 {
 	folio_wait_private_2(folio); /* [DEPRECATED] */
@@ -589,10 +584,6 @@ static inline void ceph_folio_start_fscache(struct folio *folio)
 {
 }
 
-static inline void ceph_set_page_fscache(struct page *page)
-{
-}
-
 static inline void ceph_folio_wait_fscache(struct folio *folio)
 {
 }
@@ -743,7 +734,7 @@ static u64 get_writepages_data_length(struct inode *inode,
 static int write_folio_nounlock(struct folio *folio,
 		struct writeback_control *wbc)
 {
-	struct page *page = &folio->page;
+	struct page *page;
 	struct inode *inode = folio->mapping->host;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_fs_client(inode);
@@ -825,7 +816,7 @@ static int write_folio_nounlock(struct folio *folio,
 
 	folio_start_writeback(folio);
 	if (caching)
-		ceph_set_page_fscache(&folio->page);
+		ceph_folio_start_fscache(folio);
 	ceph_fscache_write_to_cache(inode, page_off, len, caching);
 
 	if (IS_ENCRYPTED(inode)) {
@@ -845,9 +836,8 @@ static int write_folio_nounlock(struct folio *folio,
 
 	/* it may be a short write due to an object boundary */
 	WARN_ON_ONCE(len > folio_size(folio));
-	osd_req_op_extent_osd_data_pages(req, 0,
-			bounce_page ? &bounce_page : &page, wlen, 0,
-			false, false);
+	page = bounce_page ? bounce_page : &folio->page;
+	osd_req_op_extent_osd_data_pages(req, 0, &page, wlen, 0, false, false);
 	doutc(cl, "%llx.%llx %llu~%llu (%llu bytes, %sencrypted)\n",
 	      ceph_vinop(inode), page_off, len, wlen,
 	      IS_ENCRYPTED(inode) ? "" : "not ");

-- 
2.39.5


