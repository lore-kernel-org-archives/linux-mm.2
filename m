Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00A5EC55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 18:52:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C5736B00E6; Tue,  4 Aug 2026 14:52:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 951EE6B00E7; Tue,  4 Aug 2026 14:52:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 818D96B00E8; Tue,  4 Aug 2026 14:52:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 491086B00E6
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:52:50 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CAF69140188
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:52:49 +0000 (UTC)
X-FDA: 85064483658.14.C542E72
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf21.hostedemail.com (Postfix) with ESMTP id 18E061C0002
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:52:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=TPTrIWS8;
	spf=pass (imf21.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785869567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CnNADUinRNwat8S2OMUK6WgEOXqYRvhZzhuvbRl7oDQ=;
	b=WeG/ERRFfu0Qi3M9u+LmB3LHv3JpdJji1BcQxcEGu3Ttr+jIlugy8rNPzjiyZgDoLPPz4l
	8/n6Y9ntA2Uu49DPtNxTmBF32Q47R9T7zRIlXDOEpHLpO5jF8ThjZFlirYzKSkceJafTN2
	pyPYsnc3mqHSCzvHCDGTB78wAZZWIM4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785869567;
	b=bvvfzhkPDDenxKqxo0DmS5yFBGulKAu60n/gKBzdZWGnMcVhSdRchuM1ZTxsZqWTLtJw9O
	9Ung5AtlWpjVrxPKINYMmNXUIwwjRujyUysEr5HaBTWceNeUrsvfjn7s+HoMJQ3JFCmt+w
	gopsuxIjI5dGRlNAM8dUtEhhtJWS2ZI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=TPTrIWS8;
	spf=pass (imf21.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 674IYAK91998457
	for <linux-mm@kvack.org>; Tue, 4 Aug 2026 14:52:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=CnNA
	DUinRNwat8S2OMUK6WgEOXqYRvhZzhuvbRl7oDQ=; b=TPTrIWS81PZQemSMf5t5
	USmw4FdbDjyN23RSCrdvIHFD3UxdDzJM2cuFbsGXRn2yYlsFMmIjuAEPYcHTLZo8
	r+NXhE6fYTMMXA59qf892/pQaTWOjgo1ucaACTygfBYnLdmAfcDyiCHIIzbHul1L
	Tpj6OzRAv+sHcT+Zm7L1xgKT31VyonHxG9et1b+U/3e4SpnP0HtQrZIWySFMSKRd
	cP+LRLaENEs4VsHRQ7ggn5EGtWpcx91FFZAKvwna3vKScKHLt9QGl+3KSo3C1Vhu
	pgYiG/Uft7bzf2wKit7jqnk0vGinskVKijo4mmbWqRonm9FrG0Ajl6MXVEygOOly
	4Q==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fuhqba8dy-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 04 Aug 2026 14:52:45 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-51c01ff996dso1007151cf.2
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 11:52:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785869565; x=1786474365;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CnNADUinRNwat8S2OMUK6WgEOXqYRvhZzhuvbRl7oDQ=;
        b=hCEnl0xaY0MoZ5PqhcQgDIT5WLQKM9VjyHjJ56hdic0+rDv0hmDB/WXvwR3wBUK4EZ
         aoU8YJoacUC+9anRPq6s/djfSk65jr/8MjnuYJIvGEXAD8GHD20sMYEBg4pdeZJ0HeqL
         cPgwfDgjTN6ff1QIL2gdkYNgzfrVIj4P9y0IdY+9snG9yujg3YfUn4LqB/nk/hSB0lW+
         GqCV+Y9yhDNKX7AmPheX0DtTVsPsXWTfznVx5Ua2J5YyckpmX7ScPaEgBhmhNbQeykSf
         voUXPuMA9ja3z56dnuVg16Q76ycXLouCyj3y4ZpWZDaoZ6OLUPM3as11/Ttqy07bHrmM
         fvxw==
X-Forwarded-Encrypted: i=1; AHgh+Rpvh0T+otIkqZQnQcZ/vU10cCX/frqhBqKgUoYN6xqq1JORFBmO7L3ZBjMMhOjUVSb+1Z8fr6Kk3g==@kvack.org
X-Gm-Message-State: AOJu0Yzwrj6URxJWrIlI2rYBqNazg2LfCkSiS5aCX8jiaUJ8Ae0xwYHK
	L7U2cbrptvOr2zgXcjBODe4KMaQacYex1dgfr0MN/+jHErhWSaZ6stNEcroVcTazgl4uY5kvQGs
	+ruEViJB4L6L6XA3JO14NIipQ7WUXYrj+7sj9vjUXcekmE5JLTtScI0qB
X-Gm-Gg: AR+sD13uVpl6/3Tl2+lwfpNN5cRUKx28xxrwGsVhtIVYf+zO5fLOdBJgjiRVi4aSUPU
	8BSPhvmduxRXz+KEZeVn8vuA95YupWsENyt5NmUktLUkbggDDsfOH0uyoxSXoxgez5fOGvCBPqg
	70L7pxN0G0bMLBrfnsEgAOf7AK39aRInOHgJl6fgXrCPk2/H3bYw9Xa0Z7cWJvu6w2cANHIc0LD
	lbpr6I7DSSW6CQGGWz46YOm8TYfUWkh38HmxlaFvWdJYw0aXhbElhwxXNS7M6CxGVTGLJImgsmC
	UzWYGGsoelyfr+2R0O4sDASV5HStVKTMhHnqxVrzYX/2w2jFhSSoUB6WeXVCDxxHl7n4VKmkzbw
	edY7fAA9O
X-Received: by 2002:ac8:5e08:0:b0:527:f0a:ccbc with SMTP id d75a77b69052e-52ce5fa28acmr15090501cf.18.1785869564650;
        Tue, 04 Aug 2026 11:52:44 -0700 (PDT)
X-Received: by 2002:ac8:5e08:0:b0:527:f0a:ccbc with SMTP id d75a77b69052e-52ce5fa28acmr15090071cf.18.1785869564163;
        Tue, 04 Aug 2026 11:52:44 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.77.124])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fec232d7fsm2313275f8f.20.2026.08.04.11.52.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 11:52:43 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 04 Aug 2026 14:52:15 -0400
Subject: [PATCH v2 07/10] ceph: remove page remnants from
 write_folio_nounlock()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-remove-wait-on-page-writeback-v2-7-81f0ab065284@columbia.edu>
References: <20260804-remove-wait-on-page-writeback-v2-0-81f0ab065284@columbia.edu>
In-Reply-To: <20260804-remove-wait-on-page-writeback-v2-0-81f0ab065284@columbia.edu>
To: Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Zi Yan <ziy@nvidia.com>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785869541; l=2510;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=500EpqFLV6KTsCK9vzHr1t9+N59E2kCrXGhqPKPlKoc=;
 b=UBXFoH6y7LgXHIhuQeQIAJrJ0u0TLtb+QPEwzLT3I8tdP4d68PDNx+HUqFw0HznkZYJXgc93m
 lkPyciv2BfKAqFjgWwF7vCQck65jvJA4ziPdSBfbfyDO+n229Fd4GIj
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA0MDE1MiBTYWx0ZWRfX8yhVDiZXsYK4
 U2VkZPInzko/NovWsnppoVoP4qp/7K6mdXJtfIfJeiFH+T1WnI7L2i3I654Hqia5kiUPpXh8ZcX
 kuEM6Ht5keY1uuClf/M/VW7VkKPNLJsachpMy6f7lqh961nFitY4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA0MDE1MiBTYWx0ZWRfX5CvXEVtgYCkK
 5WKMNxfHh+v1YGmHt28AcwYbMzlwnEQ9dusGwI5gFnYVEMOGND+c9at0Fqmsbj0U1q5+7Q9dYpN
 lv6t6gxQLKM8C2RaoknXO7/qtELqnXiBnyMxV9Rp+Wf5+B4q7wdnK9XaYuoKavJXZB2SYE1dfAY
 AI0jmSHjC4bWav5SabhB5sOEgH8CehEyYFo3yt5Dj8NllPaVZBBM3OSqfFMqstwYhnEw3zdXwTp
 gI3/VC/RcFrM29qniAK7S8kXZimcr0TTEQqdmyV9iSlicYYJeUoC/NyHbRylw1/XC4RgDRa7K8E
 ugS3ZPrLvYEghiz/CQoFB8hw9WyJr7WoFMIs5ilc/QQR9m8e362b6LbH8ftIdwwe8ehDIYHjNWp
 Jlox//JpSiiVCyE2bg6cdobs6StUu0Pc1a85pHlq5ndnBlq4fe2BUiQYwuQFjZ+8cKKwkNX32GT
 hND5mfag7hEhLKtT8yg==
X-Authority-Analysis: v=2.4 cv=dsnrzVg4 c=1 sm=1 tr=0 ts=6a7234fd cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=j1J1DEHOHTVaJYOjuVnKiw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=xhPbJxARXHWvbxRXPbEA:9 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-ORIG-GUID: c9EvBeZpigdmORALCaK4wn9n7xD95Nfz
X-Proofpoint-GUID: c9EvBeZpigdmORALCaK4wn9n7xD95Nfz
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11865
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=10 clxscore=1015 spamscore=0 priorityscore=1501
 malwarescore=0 suspectscore=0 bulkscore=10 impostorscore=10 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608040152
X-Rspamd-Queue-Id: 18E061C0002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: t7i68mym89h9pbf5d5eryeancd6438in
X-HE-Tag: 1785869566-645288
X-HE-Meta: U2FsdGVkX19Okg0FdP2Kfs1uOZolaw8v9ZAJmUSkGoSNsqaVS3bBns+JMgSxYU8sRyTci5chOvpG1sb47iDiORouzCSDbtLejnmkrxXUXvlZjfUrjdob1xu8m8s9+CXG/xVb+JwRGn0+bjBywc/fKzkvYuBVxrRp2CYWz2876VUo/HYbPrMhZz0tXIfTGxllt6koCSu9d01CvFHh9INXzzTWMmhfBNnRIeLCNmbnhZfkAkn3fgpXPoqtCSUjuHL7KaEqNctKgGubrEjZI+Rl1zT23mFGvrv7OZpObXgk/HPsNzeMHaW1gqjCSsXmasgU08XHlVWHQcjnVI8XeHA0eCOj8aN9DUeJO09caai/x8bwdl42ejobwQKQhEKUaSW4T0dfs57XXOOycniUSb7Zup9oLXj+NYUH9R/O34+oiHrlVitmeiCxvkZmKcZJNSNhCc6yZOaBqonktC0c1kMfXk+PNXOgx9p8H98QTfQRDeCL7cIDR+6/hZ19rZvWks+KDj+g//q0UdFprf5p9y82qy7G1czZ/DerAgJ4M430i9+aREU6VnG4AJSLE7E0lQViExrlOscDDS9d+BBjtuQZ+tYHe+0sWoeLDUHUgwcDcinVKftrzL8/MLXNfVl1HNXUXrmXIgwbRAnVgPwLnIkj7ABBamNgvnGz8YuT6sT/TZmzHfTSj/6/5C0urNTOkcxGpU3y60hCPBqxifkWkY468fKbISVgucnq2clATtoAARC0Kn9qALQ3RUEpI711Y0LRnU/KvbfRabMoEAe+ePNo7kl6ISPwalnsBThm25N0q2rf0+TYsGESuEM2XawJwfwDoLYdf+IVHpg1lm/C8wpRlscKl/RkRVXmi2tyyQrjp4uNKEyrkVxlD8gkz9t1NLHODhStEGlVpGZIM9M871hX7jB56qyYIq3fN8odipTT45jWgykmdu1cNJ9Q9adEt01EzZJinxktOLVDhv27gOD
 OE13onv3
 VYd/c/58QehroGk0oX3dbSZ71us/dEjRl/PAnytPiN5J4fhtz9iR0ygxtEcRFCz8GdDi6pJmGaSKn0aJnbRxNhzQisM8fbD8gVU0anmKn4Z2dhFpxxhm/I3a5maG3j/i10CxcekNvs/k8dOcrj0WsagfojYacs+oSzONZCJneoQjBE7m8E3Zofi1HTcY5OH7UQj3pKP+ceFkSYM7jIP9M+5XqQeCBflpkpAVEoUYSyADR9nh5JQpuvvmFnh1JMaxX/ioKkX2aUT1P28LbHz5FI/7eKIRqcgXWBi/nYKtAedkuiyGncmPh1YQ6E+VA+TnIR5cWv4wFbuRILMiPXgFU8x//PL19O8PQgWhoo0fyi4OfxknCEXBS/eUEMrR8hTd4T83rff6Mhy28/Co=
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
index a96986c503bf..59e559bdfdff 100644
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
 static void ceph_fscache_write_terminated(void *priv, ssize_t error)
 {
 	struct inode *inode = priv;
@@ -584,10 +579,6 @@ static inline void ceph_folio_start_fscache(struct folio *folio)
 {
 }
 
-static inline void ceph_set_page_fscache(struct page *page)
-{
-}
-
 static inline void ceph_fscache_write_to_cache(struct inode *inode, u64 off, u64 len, bool caching)
 {
 }
@@ -734,7 +725,7 @@ static u64 get_writepages_data_length(struct inode *inode,
 static int write_folio_nounlock(struct folio *folio,
 		struct writeback_control *wbc)
 {
-	struct page *page = &folio->page;
+	struct page *page;
 	struct inode *inode = folio->mapping->host;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_fs_client(inode);
@@ -813,7 +804,7 @@ static int write_folio_nounlock(struct folio *folio,
 
 	folio_start_writeback(folio);
 	if (caching)
-		ceph_set_page_fscache(&folio->page);
+		ceph_folio_start_fscache(folio);
 	ceph_fscache_write_to_cache(inode, page_off, len, caching);
 
 	if (IS_ENCRYPTED(inode)) {
@@ -833,9 +824,8 @@ static int write_folio_nounlock(struct folio *folio,
 
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


