Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 030F4C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 18:52:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C5356B00D7; Tue,  4 Aug 2026 14:52:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09C696B00D9; Tue,  4 Aug 2026 14:52:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE3496B00DC; Tue,  4 Aug 2026 14:52:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A6AC86B00D7
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:52:31 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 288B7402BA
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:52:31 +0000 (UTC)
X-FDA: 85064482902.23.5F5DBF2
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf15.hostedemail.com (Postfix) with ESMTP id A0A7EA000A
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:52:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=L97s7PyH;
	spf=pass (imf15.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785869548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6cEcAm4InXbaEDJaVpQUaZztPzUmrUXxaK7Mht5hSMw=;
	b=IMSw9N0Hw6XF3wG2s7SHmIccWpftGJtDvY/zLk/tCkJ6s2AF0dwuWYDVmQeCdzo7k3DUzW
	yCXC03Z2JpW4Y3xcqTRFQe7Ren5Jywxc8ZAYLPyVNChLjb50KKIwVBYUXW7BGutvReIVdf
	W+OxZUZFFJBwY0DYct7PIlY4L2nWcpk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785869548;
	b=8kc1Fz1yXdDz++oF5SiF9+Rz0Xb3nMvuPk+qXW1jX7PBJPPMCOFWpqZBLILPBo9Dh3DDUn
	27b60fQCIbUaKS0jxcD1M4x/ySVQsHVWeZvcpvK3r8REazcNKxqBntiwLVA4OqOwEMdHFi
	V5FYg0i9TbMvTCAHQtqtbcyk3Y3RCEE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=L97s7PyH;
	spf=pass (imf15.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 674IY9h22213065
	for <linux-mm@kvack.org>; Tue, 4 Aug 2026 14:52:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=6cEc
	Am4InXbaEDJaVpQUaZztPzUmrUXxaK7Mht5hSMw=; b=L97s7PyHs9MoxkJbnlnJ
	bob3e54A+PzjFbMJqyEpOSP83Qfu462DaYwFPq0SP6TG/IgGCWXhz0Nemgz1N/tQ
	YxEwK2Ez7Zn/m+S43x3BhSZWbb6ZajJUC/gMwuvpP2FqyHkUKrF+Ptz6Y0KAsw0m
	m4ix2vYWYNqBphFd0e1bSmW/VexIogi+V3XUJMixmM9cePya+6IrVwLnmDMcFSrV
	V1BOmk472SN3Q8+N79xBqvJtO1+AbYwc5WkRsjslFsVCPZsVPhI0vn1wIauvO5kZ
	PjLcr+yUXpjmpwzW/8wej/OKEhWliJKDw7BL6BCdFun7MLDAZev+Hlbs119SpYSs
	ig==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4fukgqs6a9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 04 Aug 2026 14:52:27 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-51c12e43b98so1217191cf.1
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 11:52:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785869547; x=1786474347;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6cEcAm4InXbaEDJaVpQUaZztPzUmrUXxaK7Mht5hSMw=;
        b=eS0GuJa2T6PSvpVn5HTjRccZ7F/r3KCKFPZ+6R3pNCrfPNUvYI61fyhbTpfdzElXgn
         2aW8gM2qmIz1lfyeDZV+ClGG2kBmDWZ4bGtpQbutA25YthmLT8sT/H3oTucENwuWRkbI
         0jG4y6PRv12iV3Ux6wloCdHz8Nf1DgmkRcU0oLpOuLbayikn09zTIl4K9mEeYQqeBDRk
         2RLVeGSYKUgJxBqrFwcVExFPJEya0m1Vk6dcpk1gd1cVcyONEJGKspi+qW7H6HabhPvt
         8M1tsLJ+aHAaxrB5rmr4MaymPjWxYMCBJ59kzc5i/mwX8J/de8rIBnPRBsWy6ZXRXAex
         R0Hw==
X-Forwarded-Encrypted: i=1; AHgh+Rr5QUJJEich6eOgFwpG19X7To+e2Pg6kSYhaxSfEX17E8xVR4Z1ETt784lgPmvxGIaGvFPHCWf64A==@kvack.org
X-Gm-Message-State: AOJu0Yzh4z8KFT5BxHUPWPr+prlzduXF3f+qNFLtQBEViP6rsiJl2VO3
	vfjX7KFui/PMh4Rv6r4ckIZo2ygB8MfT0TRFh6Yb8N4FAGm76NrYRRG8CvcAy9gMlPmfp4xwdQC
	VBp5tNgWReXz1KzGxSAHYPmit+u/fukYx7MQtyOCd42wy4zrpESUfLYGa
X-Gm-Gg: AR+sD11p1gcQznueRd3cJdKPJCsK7ueCDptViHnp8BEVjZJEYkyWVvfCWS/+5Sak5S7
	0MoCTtmLPXIS5Y5FQVP6esE2mT21MmDXCUmWQ7fi5VEhznZ78lIsWsG7kQD2QsJEukgemHgRQOf
	MZi7tL4GUUc5kZhHj7waYIiOfvt+MXa3IEHBfQjlmbqeyi60P6Eipg8yN4ZVKWiJ7oGNEezLDTu
	9WCuIoSuVZHae1ndYQn/JughTkbG6BFb+dadWP8wnmPxh+Ha8oBvyK8wDOjwyJCkOFjJlTp6ID8
	hGI9+bKAN/A91PYvR++/sMX6XLwYuHvv0wYvITLb9U78IH2RCbt2UitGRDTa/dwMbrp+a64NGYE
	oEgCz2SQR
X-Received: by 2002:a05:622a:258a:b0:51c:ba4:d837 with SMTP id d75a77b69052e-52ce6033864mr14931681cf.18.1785869547242;
        Tue, 04 Aug 2026 11:52:27 -0700 (PDT)
X-Received: by 2002:a05:622a:258a:b0:51c:ba4:d837 with SMTP id d75a77b69052e-52ce6033864mr14931161cf.18.1785869546719;
        Tue, 04 Aug 2026 11:52:26 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.77.124])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fec232d7fsm2313275f8f.20.2026.08.04.11.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 11:52:25 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 04 Aug 2026 14:52:09 -0400
Subject: [PATCH v2 01/10] ceph: add ceph_folio_snap_context()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-remove-wait-on-page-writeback-v2-1-81f0ab065284@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785869541; l=1926;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=g8jPUs8pg/UEHyzRirqPZNurckpVqv7a3bIwEUEkAXw=;
 b=kPzJerCbpMCCBKGAtZw8eKWb6/5ZVD4+Ug9RVQ0xo6KmV7nNnkpdLDMCwQucUV99QtMamuOod
 lxHS1F8FsRxCiL9AoDQknGXRMPSE1dKxItslwY4r9TZxB1CubxQ3RQW
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA0MDE1MiBTYWx0ZWRfX1XfWZ43lj/ys
 ldVxw3ENfWn41deidLW2gEUAA8sokXaqWLWtP1y03DrmkTA5EB6AArZhUz13IF8cWJUezkyrzkp
 vcxjigh79SCZMhbMlhiQD9km17PYF85GBdzeUIpZS3tlCUwfZ0Xh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA0MDE1MiBTYWx0ZWRfX2HLEe3Ji6t6C
 km9Ie/2o+SXjnZ3McqOxiWGSxeZ2wz4GmRLb05HrkASNxpe8tRiU/ft7rQmBOs3Wh3UgGLxmTzV
 LO9SmHtotYCV9xL1KSVVd5d26zCJnzl9itW2r6E4AWQGr3ivCNKtTy13SaCBJrTQFwgf5y+NZwz
 Ij82b3apwJKnyYfRIDEEaL22a+VGbHbTEDIfDu1JJmYX65fxPgR7rhYNbbUbDFJe1hP6ji/u0Lo
 glzWMrrbzPAe8so1XEKHneZk4i+lnoR30wsu0fjTHaikVVOxxHD5BqLErCs+rP7abh7OT+D4Ygu
 YcFCvkSHHVswJLkyVfrCizT+On1BHUcSO1Q2UQcJ2fV97fXIzgoZaAsbpHT06lOl+E53eqE2be9
 UnaDmQv3qjgpe28m7eBjfc/YjYp6sbL3+GZr/CcmamXWq0XfYWUkvfMOXg9m1rU+rX6TDkEp4xr
 ULUs6DeRUwVQfStcC7A==
X-Proofpoint-ORIG-GUID: 0L0MmC82sJgbaOssT9DvO3bRYK-OmZg_
X-Authority-Analysis: v=2.4 cv=X+Ri7mTe c=1 sm=1 tr=0 ts=6a7234eb cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=j1J1DEHOHTVaJYOjuVnKiw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=ALYDsW89DncSylXEcn0A:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-GUID: 0L0MmC82sJgbaOssT9DvO3bRYK-OmZg_
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11865
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=10 impostorscore=10 phishscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 bulkscore=10 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608040152
X-Rspamd-Queue-Id: A0A7EA000A
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: hosy34r8cqk3n5wnyw8od7ac49dk6fqy
X-HE-Tag: 1785869548-72334
X-HE-Meta: U2FsdGVkX18yTNj0he4cOMJ8mVmGp28FaYdlkdJzhmUdZdfzFy8oa9H5exZv1Z1grSlgDf/iaelKS+CVla7T5RQ0j65gklmeolJJay603+WT2tYFkjGAaZYNm2unoCai+xmG7J5QzciQzlGeYNV2+Wy+DMrLkj8eFq3N6rIIiYPwKQ4GF+3/jeiQxRinJ2ppdMOib9XY9aeP9edrcBpk3vfY1j+8XwAvCCrnMGAZoUZcVBNPUUwgMejvvYochMb9RPzjuJ5yb9TC4W04/91nTnpX9+PqBW2fDk0p3TbRwUmXoG75sRmmC+SiM+m7qtsf0B5aP8vlKfOCkijFz04ebVenSZP+ShdhxQbFDeV3VXs3CFdrWwdchumcOYjQ7z0WoM3J6Rl3qa5ySVHnbrlrt1J5XYE2FDkeg/uXOqIyTTBO/Ski9boyLeYusogcfCY5KMxey0whMilJmYA3b0o+/jmnsfP5qu6yiW60WsLPXnPP8Ng02JFbc3xwcGi3koJv9FmzHNMQ4odhOPqxrHlHdZ2xdlOCKlot8+CepeErh9padHkNPvb1EnoOt1rW6qaggtcCAJVGqn21FjIfqLVFNeYssvbsmBm7LZwLIE/zTPqckIa0/Gwf5EOdx8eFgtX4wSjPDLScZV4f1XbFmrKNIDYnMj8hr6Rhqyo99W4uq4ksAEsedQrvt5KXmExXwXpblIi/dPsqHhfNrOdmKlA/p6Efr81M0dafLnABrNkMsKaUMJME355P6iSXPQXJZld7FeLzAnHU09oEQZlhO+YSre45xCwfx1jloe6z79XzXKxBqKTYFE4QqFUQfqHG7z6dLzJcVnSHg572kjdWX2mGPHOKZ1AEKeLXB239VuHjTaN30+SblFXapz3WC8Gv/r6q6a3KGiXjQwft72a66SDxtr4awNwLXgSkGecvUPj8euTfALWDZhH/TCgo2KnccbFbjKJMRnX8cjgv38HqItn
 4Nu229wP
 fmPBbJstmInRWCprTn5JBaNLeTxZTiHWFa5psmDPpz8ytOT3oz9XbXw4OV6TXNha6cRE2pJsjSd4UcVGgI43SgGrc27uPXh1M9CfNy6o2Tnr/Ho7jMAk7MUJ1Ysm92wI/KB03NRQf98m9257K0bcLkUlMrP5qNyUDrj1vD6UF1iRY1xBaZ5Q1yVQQBqQyYmo5SYrQHF+NBoD9AKptz9c6dtDfZbDJwgcqgVHxYZameVadUApGtvh71QUe/cPUmP6gsj/T3TiHZhMAZKSmcPM6FDd1Vusaupp8D05z4p3hu11RTfOB8RmnFa8GMW7+/omCMLW4eoLOoj0UbxYHl4+4McaXENMkAH9MHMofqrNCeKP4E880uvL+FG5O/QoEZBD4IjTQTXZy7L2mcfc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a folio-based counterpart to page_snap_context() that reads the
snap context from folio->private directly.

Convert the three writeback paths that passed &folio->page to
page_snap_context() to ceph_folio_snap_context(), removing three
open-coded folio-to-page conversions. No functional change.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/ceph/addr.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index e2da3ab9f808..8347366ce5d9 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -75,6 +75,12 @@ static inline struct ceph_snap_context *page_snap_context(struct page *page)
 	return NULL;
 }
 
+static inline
+struct ceph_snap_context *ceph_folio_snap_context(const struct folio *folio)
+{
+	return folio->private;
+}
+
 /*
  * Dirty a page.  Optimistically adjust accounting, on the assumption
  * that we won't race with invalidate.  If we do, readjust.
@@ -749,7 +755,7 @@ static int write_folio_nounlock(struct folio *folio,
 		return -EIO;
 
 	/* verify this is a writeable snap context */
-	snapc = page_snap_context(&folio->page);
+	snapc = ceph_folio_snap_context(folio);
 	if (!snapc) {
 		doutc(cl, "%llx.%llx folio %p not dirty?\n", ceph_vinop(inode),
 		      folio);
@@ -1171,7 +1177,7 @@ int ceph_check_page_before_write(struct address_space *mapping,
 	}
 
 	/* only if matching snap context */
-	pgsnapc = page_snap_context(&folio->page);
+	pgsnapc = ceph_folio_snap_context(folio);
 	if (pgsnapc != ceph_wbc->snapc) {
 		doutc(cl, "folio snapc %p %lld != oldest %p %lld\n",
 		      pgsnapc, pgsnapc->seq,
@@ -1824,7 +1830,7 @@ ceph_find_incompatible(struct folio *folio)
 
 		folio_wait_writeback(folio);
 
-		snapc = page_snap_context(&folio->page);
+		snapc = ceph_folio_snap_context(folio);
 		if (!snapc || snapc == ci->i_head_snapc)
 			break;
 

-- 
2.39.5


