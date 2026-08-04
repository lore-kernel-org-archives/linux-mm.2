Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7DF1C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 18:52:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E81086B00E0; Tue,  4 Aug 2026 14:52:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E31376B00E3; Tue,  4 Aug 2026 14:52:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5D506B00E4; Tue,  4 Aug 2026 14:52:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9121F6B00E0
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:52:40 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1D31E120274
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:52:40 +0000 (UTC)
X-FDA: 85064483280.08.3C78FB9
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id AC4951C0019
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:52:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=orP4G7rp;
	spf=pass (imf20.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785869557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HrfnottRt8RY51efcxtpgPFZmS0xvtqTx86D5p3Srj4=;
	b=kM5HB+hDd6zBu6VBp65pcWtYyPUETOWgn3+f8oJ7K8rstGlFgxAWHjqBtdi+SB3P7unPMJ
	F3dfNDq7x5GyJhKZqf0XtEcnyMz7v7ptciQHJvpHwWXs8/njvu3EOjs1VizN/vhzkumsRG
	djm+3uJVKLrX2YsR6YaaO8xxXP6cmUo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=orP4G7rp;
	spf=pass (imf20.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785869557;
	b=R6ol7HRuaBKAuuRSBzNm/QFmhkRTxjN440wcHgqxbE60kIHLiq22RkCxSbY6ZHatT22Fhr
	SRq/CIUfw/25fH/2fOyuxBw47Qlia7KutXmVCi7Rdo8Vc9xCLbnrIpzJl0KJHrc9TYzdVB
	mB/LsskTFAoIVOns2lqWKp7IcixuyAs=
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 674IYALX2213085
	for <linux-mm@kvack.org>; Tue, 4 Aug 2026 14:52:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Hrfn
	ottRt8RY51efcxtpgPFZmS0xvtqTx86D5p3Srj4=; b=orP4G7rpYSxdzMQRVI2s
	CNyB6CtqRdTN4aTJuVK04d5E17G1o69HkG4AzD6u25O7ICHVAZE1GAnPopsdyqlz
	iyEgK1W+d4mQrqW6wQPKmYyhwsDq8xaQ0BCY9MVXLQ7qP1kit5mu1YDzDB/zTZ55
	l4UTwwBxgv4xVduEYwJjWpcOTKOYEuVX8njCXBYWgkdbMzosk2SooZRuZ4Aui8Ff
	rRtRKXDjvsU3TSD/ENPpuNcIuTp/ZRmDHxxos47Q6wzAPrNS5PyC3txKJlhy/i9W
	HBzh8TqfoOMSESAk7aRsw4AZ5ZFn+Hw7ybz19RafXxccwpo4KILa6kXk3ys1Q2wT
	gQ==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4fukgqs6b1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 04 Aug 2026 14:52:36 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-52b4f6ac06aso1663851cf.1
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 11:52:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785869556; x=1786474356;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HrfnottRt8RY51efcxtpgPFZmS0xvtqTx86D5p3Srj4=;
        b=JcZTePT5mnExZ4EocTceWGuZA4nqucydDuY76cdEI8pwyimhoEzey3i3b6ciED3Ue6
         VI8v0TMwesHiD2Nv295Q2buXuIHCCZNJkkoIRX8doauoYTvi+IjICGpzZKspkHXfj3NG
         1p38hWyKdXNSJlAheItYET2nDv2qqB0Yc9ESaG2QuKZZnFqQPfY7SX58TrQG/XMrewS/
         7NP60nKckutE6Lcp10HjpZ0Dw2RJMAt8RuCZOPCjuEqGW1f7Wbo7nXK0BRM9gUWrp8k/
         2JZBw6eoyo10WAE62LF5WW71w1uQG65lozrCcy28FJUR/01tuahhJd8SaiTMHx/QBM39
         iQNg==
X-Forwarded-Encrypted: i=1; AHgh+RrBCdTKVZ2ryDSkFDA2NwgPZgh2TXU5mMNeIJn1/AiBOTOf9dUEbPLC73SOlYkoCthDTjVjdnmRgQ==@kvack.org
X-Gm-Message-State: AOJu0YyKYYlZk20jXrc656Eai2LkBo5yfx9m2DNXJt1e+bzmfzO8nZTg
	y/Ozh3RgHtJS8TLOrkbWlYNGT7MekTaSpgD8qs2/FVIIgkJ+wdVeReW39BOtZkJ4KUdEHCrAUKf
	EmaHjlFRYYSH3bULiLrXIj4O/ZxXbCfmh9rPEcdtYnHF1K6vUON/osNEB
X-Gm-Gg: AR+sD13pgmSCRq8asx7u1DOhr2ZwFHFk8Hg+tnpxyuLY31EYlV53loCH7AbONzJLnrO
	rSXGcEUDkfsN0DGTGMlRJJ3OXWgAANWFKnfjxeo1vOzGAxN8E1VVHSMg5zh/6w7SGggA5Qhfy86
	nFj37RB77sr60cct6rYfU3R0svf0icdVu7eWzHux5iV3SQ2LKlO6JEQFIVxvVTsi28agJTpz1ix
	zKk8vU3QA7vvqUyWYGBt8oKNaKmhU9bsUHszyUAbqdaQ2GSeSqZ9QFJ3E6lCiDHZjlssbBUEyk5
	FUQJXlADNyIC454x+i2m/es51ubBl9OWcJJSoB/ntS36DDUon+9qmI7qHSIAVM2NaQdVn2lRlRs
	HnDAwbSlS
X-Received: by 2002:a05:622a:4d89:b0:51c:22c5:daf5 with SMTP id d75a77b69052e-52ce62c6cf6mr12809211cf.38.1785869556092;
        Tue, 04 Aug 2026 11:52:36 -0700 (PDT)
X-Received: by 2002:a05:622a:4d89:b0:51c:22c5:daf5 with SMTP id d75a77b69052e-52ce62c6cf6mr12808671cf.38.1785869555591;
        Tue, 04 Aug 2026 11:52:35 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.77.124])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fec232d7fsm2313275f8f.20.2026.08.04.11.52.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 11:52:34 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 04 Aug 2026 14:52:12 -0400
Subject: [PATCH v2 04/10] ceph: convert get_writepages_data_length() to
 folios
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-remove-wait-on-page-writeback-v2-4-81f0ab065284@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785869541; l=4666;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=ZLn4GmbBBs4DJzpxg5iY9HTTJ6Xur2Gxm1ww+3ec0uo=;
 b=oth0Nf14fRObazwrdx6pe7EJlKObc8Y5tWmZKRvFAWjLufDheiwH1ZkewJyJhwIs0DUt/Y4AV
 KJKOHQot2zAAS1u1iOv6yf/vIMfhsOm9h8XHLJdtoZigFowDlJQvo/J
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA0MDE1MiBTYWx0ZWRfX1vtUvzkVC9yb
 gDIeIspAvn61EKYKGlIQdDzjducAMt6yxkqq4flgXFbAFnIElf1IIQ5W/NRQc5TMJpXc4JlKJsR
 VvuY5EwRwSLr4+dg1I/xg0Odepf7KuJQvymPjGjfmkADgVfruRDa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA0MDE1MiBTYWx0ZWRfXxYsNKRrF20ev
 j274JKnDyQJr4l8mDssdy3qCqtsWQfwAvjTUixHg6Jdxc3ghmX9ZTpFDFUPy3V2i0YWaNeNbTb2
 dnVToGkMX88RMEpVRFNzAzOImPuzEbJehrrJ6E6MHRUA+5Ow3Bh6MELOyixWEiXNco12URr6ttS
 Q9j9LnoS+Wk80V24w/ginZn2DKSFFRQBNHgXLz2DNHjHIFMud9ao2lKbul/Ymj9jRaKE3SYVWEB
 5JgVgdmxRpI2Q0T5dwYVHQa0lCSf3QYDUBP1UB4nssE3AAvYbWthH2ZVn7HnpbXyfLMccpMn1Qv
 FYAMEPYNprQCC4YiItjgfVRVZG6c3GhAmOC1iqM4JKmg90Bv3N7u2ATYhBdybgJ4AYcGKFOwxPX
 hOFzPqEoR2IPu4yvslvrJbRqaJG1A1RcAmOVxH1sdx1C6v72t8Cwh+DZGWJEMZWB0p2LdoG0kPV
 mzGuzELt+MY5VsDXUQQ==
X-Proofpoint-ORIG-GUID: VesPt0CllD9JKX1d4dNS86g0GRnH4yvU
X-Authority-Analysis: v=2.4 cv=X+Ri7mTe c=1 sm=1 tr=0 ts=6a7234f4 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=j1J1DEHOHTVaJYOjuVnKiw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=4S3DF5rXG3rfafK4-1MA:9 a=QEXdDO2ut3YA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-GUID: VesPt0CllD9JKX1d4dNS86g0GRnH4yvU
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11865
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=10 impostorscore=10 phishscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 bulkscore=10 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608040152
X-Stat-Signature: sgm3jxns81ts61w3rtgo9o7ppcttt4n5
X-Rspamd-Queue-Id: AC4951C0019
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1785869557-435012
X-HE-Meta: U2FsdGVkX1/JTjuQHPfwUGVMqpABDsbJ4I6LvmD58JKS9eXoJPbi45B+tcJ3u0CFYwC7/4ola07pcJzDWfZSvWWbFG2zwnfi2Abk8BkJxsBcaEmtpr0kmQmgdQ+rjAhaH8nj6CABuS5NTqduAC17N5GGZdw34ZcBW5kZZoGXWhFJH2dF5dj26+3bKrUWXmJDq7wLrHv2aQNNcAG7J6mLcruSqpnX17/apN8WUilEKpMGR3xStYJQPB04w4/zysobCwHsAnr5hKM4L4kaPq3BCgmZjSd3Mvl/q5evH7yrqmAkBrTZ6JqcFbWk1gSb5pHGt6J0e1rJcfo+PevOQY22pc2qv1bcFo7K/7fawSLvGEuisCkADCsAwPvtxGfDHHQ9P2/Y+BxwtwkIdu1heqng2iYiA4pTsNVdazTxJuCy7JTsgUxRXli6tJZeYOj+oMVazoNMefwOk6piespnQzrqjSvq9uVAj39bbHuxgilf+gRPufNWN9HZaptgwU3iobXUX03XiHPBudbLwNmXSdYOhhwLxdZzcjYrQk3FpcTTiXTIzv+Ysl1hQc3mF2wfmdyp+zXYPzaV1qNidyhd/HxD0lsd1iNamlKBLfWLWncgJ9gUxqsHOkGvhp7b6CXwLYtIyEVKQG3QaKuQBuAYj0+2Uc84R+kO0iDNyJ+pZ2/BZxhE3f2WjEgofw64Ol7BdycC4tjAa3DMeN8+C1vIB6mN9mXSDp8yZWaY/sJPAU6ry7i2eOOZvV5vqS8EnCmnth7szf2ZL3LbrRxiU1P1sbv+i3HIgiaiqa16JN74VDRCd0tdiRKgeRroznvMNiK0JYxgaUNHDocIQLjb6sBnmxRrJguIDaRIWCvdw/foT5AQ1inFgHGshyu4dlZMQuljO+W5i1ehRzP/cZu9sI0JwCATHHkZ0Hq1RjZVl0oXSZ0IcfvgRAtW916Mz6lhEOIAmy2AF0oqE/i3w7SrgwcM6Dg
 8DgA08sy
 ZyShsFDxfFpnr+zaQPrtfMRlsk8Ii+6H0cIRJwzLDnyWy48Rb9lw5/xARwBhw3nlycLOlC8aCqLLLZiFy1A5pQfEkRy9RVkyovsVdZxIjNUeNwzBePhGgcb1ASrWuEjDUK0CJ2Jwjrp3EqvnOrbkcGWzAr611u4ybWrxox8rf67e4gtaiqbbxkueIL/KPU5Cfh0q5ue7YTXCGZavCMZIgXpxwpyQhq3czzPdOcax4gO60wrV8PyjjT5tEquNAsxiLz6bZoXIBFVGwCalcT0f3zmV+Gp1V/3ZDzg3VsH7qPg44mF/9qDlV8m2nHa4uc+Xa09+YaAVNFEqdc4ktnibYemzAuZqH71pNL8i6RZifgj/d78FAVyeltZ3rI3frO6IuR3MVvzrLhCUxZRQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce ceph_fscrypt_pagecache_folio() and ceph_fscrypt_folio_offset(),
folio equivalents of ceph_fscrypt_pagecache_page() and
ceph_fscrypt_page_offset(), and use them to convert
get_writepages_data_length() to folios.

This removes the last caller of page_snap_context(), so remove it as
well. This also removes a use of page->private and a call to
fscrypt_is_bounce_page().

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/ceph/addr.c   | 25 +++++++++----------------
 fs/ceph/crypto.h | 15 +++++++++++++++
 2 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 967243f425f2..c81e9da42df9 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -29,9 +29,9 @@
  *
  * There are a few funny things going on here.
  *
- * The page->private field is used to reference a struct
- * ceph_snap_context for _every_ dirty page.  This indicates which
- * snapshot the page was logically dirtied in, and thus which snap
+ * The folio->private field is used to reference a struct
+ * ceph_snap_context for _every_ dirty folio.  This indicates which
+ * snapshot the folio was logically dirtied in, and thus which snap
  * context needs to be associated with the osd write during writeback.
  *
  * Similarly, struct ceph_inode_info maintains a set of counters to
@@ -68,13 +68,6 @@
 static int ceph_netfs_check_write_begin(struct file *file, loff_t pos, unsigned int len,
 					struct folio **foliop, void **_fsdata);
 
-static inline struct ceph_snap_context *page_snap_context(struct page *page)
-{
-	if (PagePrivate(page))
-		return (void *)page->private;
-	return NULL;
-}
-
 static inline
 struct ceph_snap_context *ceph_folio_snap_context(const struct folio *folio)
 {
@@ -692,7 +685,7 @@ get_oldest_context(struct inode *inode, struct ceph_writeback_ctl *ctl,
 }
 
 static u64 get_writepages_data_length(struct inode *inode,
-				      struct page *page, u64 start)
+				      struct folio *folio, u64 start)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_snap_context *snapc;
@@ -700,7 +693,7 @@ static u64 get_writepages_data_length(struct inode *inode,
 	u64 end = i_size_read(inode);
 	u64 ret;
 
-	snapc = page_snap_context(ceph_fscrypt_pagecache_page(page));
+	snapc = ceph_folio_snap_context(ceph_fscrypt_pagecache_folio(folio));
 	if (snapc != ci->i_head_snapc) {
 		bool found = false;
 		spin_lock(&ci->i_ceph_lock);
@@ -715,10 +708,10 @@ static u64 get_writepages_data_length(struct inode *inode,
 		spin_unlock(&ci->i_ceph_lock);
 		WARN_ON(!found);
 	}
-	if (end > ceph_fscrypt_page_offset(page) + thp_size(page))
-		end = ceph_fscrypt_page_offset(page) + thp_size(page);
+	if (end > ceph_fscrypt_folio_offset(folio) + folio_size(folio))
+		end = ceph_fscrypt_folio_offset(folio) + folio_size(folio);
 	ret = end > start ? end - start : 0;
-	if (ret && fscrypt_is_bounce_page(page))
+	if (ret && fscrypt_is_bounce_folio(folio))
 		ret = round_up(ret, CEPH_FSCRYPT_BLOCK_SIZE);
 	return ret;
 }
@@ -1565,7 +1558,7 @@ int ceph_submit_write(struct address_space *mapping,
 		 * data length covers all locked pages */
 		u64 min_len = len + 1 - thp_size(page);
 		len = get_writepages_data_length(inode,
-						 ceph_wbc->pages[i - 1],
+						 page_folio(ceph_wbc->pages[i - 1]),
 						 offset);
 		len = max(len, min_len);
 	}
diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
index 79cb563fd887..948c8b5dca06 100644
--- a/fs/ceph/crypto.h
+++ b/fs/ceph/crypto.h
@@ -162,6 +162,11 @@ static inline struct page *ceph_fscrypt_pagecache_page(struct page *page)
 	return fscrypt_is_bounce_page(page) ? fscrypt_pagecache_page(page) : page;
 }
 
+static inline struct folio *ceph_fscrypt_pagecache_folio(struct folio *folio)
+{
+	return fscrypt_is_bounce_folio(folio) ? fscrypt_pagecache_folio(folio) : folio;
+}
+
 #else /* CONFIG_FS_ENCRYPTION */
 
 static inline void ceph_fscrypt_set_ops(struct super_block *sb)
@@ -262,6 +267,11 @@ static inline struct page *ceph_fscrypt_pagecache_page(struct page *page)
 {
 	return page;
 }
+
+static inline struct folio *ceph_fscrypt_pagecache_folio(struct folio *folio)
+{
+	return folio;
+}
 #endif /* CONFIG_FS_ENCRYPTION */
 
 static inline loff_t ceph_fscrypt_page_offset(struct page *page)
@@ -269,4 +279,9 @@ static inline loff_t ceph_fscrypt_page_offset(struct page *page)
 	return page_offset(ceph_fscrypt_pagecache_page(page));
 }
 
+static inline loff_t ceph_fscrypt_folio_offset(struct folio *folio)
+{
+	return folio_pos(ceph_fscrypt_pagecache_folio(folio));
+}
+
 #endif /* _CEPH_CRYPTO_H */

-- 
2.39.5


