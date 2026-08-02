Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FC0BC55162
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 16:53:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14A816B0096; Sun,  2 Aug 2026 12:53:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AD3C6B0098; Sun,  2 Aug 2026 12:53:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E69DB6B0099; Sun,  2 Aug 2026 12:53:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ADF096B0096
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 12:53:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3BE0F140516
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:53:46 +0000 (UTC)
X-FDA: 85056926052.06.C76E4FC
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf05.hostedemail.com (Postfix) with ESMTP id AD66F100009
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:53:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=lsnrTEqo;
	spf=pass (imf05.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785689623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YgZD12vF5o4SjGPupBE5NOIO7mg5JBXcQDcfIckANSI=;
	b=iNE0va3pVbvBp7YzU0RhljsyGtm3XWhaVghrEU99joBNB4ugNZMEm2Bc1jvE4rP6IIoVTi
	vj5ZMuvx/0k1W5zHBeahHnaaDAhWK+c3pmoQdIVSmTDhLOkW0c4bduUaColy/wlJ2NvH5B
	q47dB1uM3iR9TkHreMSrI/xC34ZvEmc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785689623;
	b=y0oRNrD4UXa8nCGViFenCXVi5Hyh2CZdO/5ZOdTHkrotwiCQXDmoXTF5q/sLaDdCA/6bTs
	vLjaVXn5WS5bE1Pvq5wEdwo4PT5RR3pda1eEhBP5I8k0c1GsALCgAq0l5cAWBRehhWpfYX
	f978pBth8sRdx7SDUoxudPsIquBUjeI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=lsnrTEqo;
	spf=pass (imf05.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 672GEaIr1598383
	for <linux-mm@kvack.org>; Sun, 2 Aug 2026 12:53:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=YgZD
	12vF5o4SjGPupBE5NOIO7mg5JBXcQDcfIckANSI=; b=lsnrTEqo2LT6TEG7vP9k
	kxCnydT7i+KLPh3FM6khNDUcEeh7r3bpmjw4ho9//jQfGfwp6l4lpPAGmI2+/TLG
	gmpB6U/NZJNclhxo/IUGUl+WvenUkYtiYHIuBHI0Hp+E1lyqCa2V4n/S83pOczq4
	sjDiT4+xNLyn231+Gw3p+g2UC21cwg/k+RqhZEIY9L2NP99I4P6rfUH2rbwtjDR3
	wMeYR6qiBnRcnBRpPdBRGimZHPeEZLHfOL7V0ZhfqV3ggSNQiXi9Bynso4c8VuhW
	v7lwlMkbpF0w4g7sxcbaukGlhvOHCbKXU6wbun8NU3jkGMd6KZN6oYWqP6Nv8/K9
	yQ==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4ft9898410-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sun, 02 Aug 2026 12:53:42 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-51c1a9764f0so26914721cf.1
        for <linux-mm@kvack.org>; Sun, 02 Aug 2026 09:53:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785689621; x=1786294421;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YgZD12vF5o4SjGPupBE5NOIO7mg5JBXcQDcfIckANSI=;
        b=Bf2RTveLOIqFu1dNSwdGGVBHg/E6QwkvxXYSv0X9KODrCXT5QCEddy9VRfqxlI0SxG
         iQoLnzLhp1zC7FuaiU5zFsgk6CtzbDk/8TAEuwNOVePbYT1ZPF6Azq2dWUhQqHSxFCq8
         9SxOi9+CaI4eUNtbBQ2oBKdmQy22rFMu3/mWWRgAX15wjGhvOiqDxb0Y5kRx5cArfBrE
         k6TdcMjb8BfBf+QA9RKtvRgvcHHIS5A8bKyNfw4Kt/Y8UqC3zqbSJS7ZxId7RC5WS2xD
         9gSei95JjSCU8FAq5oqPZOiP2HMm6yaSihrv+lTNxJemTo3FZO/7CC9nEXnNeD8+km/5
         UyHA==
X-Forwarded-Encrypted: i=1; AHgh+RoiDSnE2EDFE9Z0jcQUWHMUHWjfoBYfk3JeViEXbzHysQNmUN1iHN+jSovAeNW1UhnFziSQSv92pA==@kvack.org
X-Gm-Message-State: AOJu0YymxgX1Ft/XOHNgrTjhWzNxFxyyHI165JbvMhYW+siOJrJMkaK8
	DK5SuLw/rEDyTBeAT9Ms68ls3tjdyB4TFzPrdElFBDDJF/FWRh3awRQq3Y2bQm01qtUNAHuHfxe
	RB4S9teo0ShVdi4jwHnfgZxQQfk/DGuFcDZeHjgWgU4m9UG3W
X-Gm-Gg: AR+sD11OWQOvzCkXQhXnd97w743gkcwoW9QDYDIqiwnvfjweTfNLb3BunCVIdnFhqtz
	q5KS3vfIiPfcvGcEnhDp5OGmneDp8X9IsvcIJeQ2ywVmqp6j7/VmuNWSvyjXfxAeF4mKFKs3l7w
	YffXEKo+IpI9FdKSiJfAIs2HGWmLlxa+0iqj3OYZED4T/pkXSkGZJ+tQ38zS8NKuBff5/Gc3dlh
	kGgRh7nOCareOglsamXO2qqq3VoewubxiTA06RaEc+EJfUC5yp9Vmi6iajlvyTNSQMqcMoV56mK
	wSt9/8mi4fNt+Jv22M5OPIiMdgvRyy/bHQ1gYELTKBNnNxK60Z9HKWEX4M4/9O6BGhqJR+o9ZAD
	mnub6DtvRw5GM40sffnogAYxF9jRIdU5uHDjSIaIARKhTAWq2mrA=
X-Received: by 2002:a05:622a:1247:b0:51c:844f:28da with SMTP id d75a77b69052e-52b56673bf2mr163448581cf.5.1785689621475;
        Sun, 02 Aug 2026 09:53:41 -0700 (PDT)
X-Received: by 2002:a05:622a:1247:b0:51c:844f:28da with SMTP id d75a77b69052e-52b56673bf2mr163448101cf.5.1785689620984;
        Sun, 02 Aug 2026 09:53:40 -0700 (PDT)
Received: from [127.0.1.1] (CBL217-132-158-98.bb.netvision.net.il. [217.132.158.98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd45a0c8bsm24064574f8f.34.2026.08.02.09.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 09:53:40 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sun, 02 Aug 2026 12:50:05 -0400
Subject: [PATCH 4/4] ceph: remove page_snap_context()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260802-remove-wait-on-page-writeback-v1-4-6c35d6b3ad36@columbia.edu>
References: <20260802-remove-wait-on-page-writeback-v1-0-6c35d6b3ad36@columbia.edu>
In-Reply-To: <20260802-remove-wait-on-page-writeback-v1-0-6c35d6b3ad36@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785689606; l=1958;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=E+7MzW7ymcOmm2fAOpewcVRXAlWP28GQ8bwE/xkarAE=;
 b=CGrtCZzmymnOg0P1AnYYYJJhAxmkHbTbgJSoW9X6pUAWQ24AQTP1LclOZq1dzmzHdLFh9Byxb
 fftOg/3aKaoDeb0vSDcCi66HsuVSw4joSRlXCjwpzGhun32idb8IvRp
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAyMDE1MyBTYWx0ZWRfXx45UKZ8LKlMk
 xrRtapogkOAcjhknp2ITRAgBeAZDXera/RadNbMPWuER26FVU83lEKSAH3gpmw+T1j2jC0yZ6RB
 jbkXqipbkB779KH9QyjR9dTl9M4UynByuKwpAOy2dVFJ3GFVXxQQ
X-Proofpoint-GUID: P4W5UNuKzXApWfgYoMcr9AKX1vxm0omg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAyMDE1MyBTYWx0ZWRfXwhH/L/Scfppr
 jctxcMU4KOgTd6f4PdJFhIgGR+vW8wemHUzSLJTZzeAMNZO00g+jjcerVK1Dq0zJYYqXS0fxG8t
 Nb1G4fCvulfkAoyrdb5x29Fi3fGz8HF59FlAnC5K/uqm3+9+ubjTklGheVhhDMOJ7PhDA7G5z9R
 9HsE6FDanjIWFzdNJ6AW5UvLlPkQQeVfL+PWsVjthhp/WfwP5AXS5EYl2xwd9212pO+y4S1f0ux
 e/jLtnaTl0/Rs+3Oyj2PLZFoq4ryajLvyI/2kqrz2TaPjSlr5K4KcqOxHUmbYImd9bN8A7Hdm1j
 /GKgU3Mzoj/K+ALUqGzDZDTQ5iFUWoj4/5qumtnPnDD9BLBoXH6zYbZ+Z7NL+TGl3Pt3YHP1dgy
 rWA2O078pJoo6Fb9jNfhuHIPznt7yQCzDiYWi8UO67x40iV7wCqCPDPcuRxDKLBAEY9507MwFSA
 p5hEgQlp5FUjf5NSc4Q==
X-Authority-Analysis: v=2.4 cv=G6ss1dk5 c=1 sm=1 tr=0 ts=6a6f7616 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=C4zMR0+CEq2lM/mtmjScOA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=7ovMhKOaTh8UDYQOW-cA:9 a=QEXdDO2ut3YA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-ORIG-GUID: P4W5UNuKzXApWfgYoMcr9AKX1vxm0omg
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11863
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=10 malwarescore=0 suspectscore=0
 phishscore=0 adultscore=0 clxscore=1015 lowpriorityscore=10 bulkscore=10
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608020153
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AD66F100009
X-Stat-Signature: jcpidco7cgga3471ukrkjw9rwzf7x39t
X-Rspam-User: 
X-HE-Tag: 1785689623-237372
X-HE-Meta: U2FsdGVkX1+vnC7PtbTj3HoMMfGnErK2ynw7K9Hp2NjQ3gwnhDk1w2LTePIvasMkP0hVgR8zVtz30sOXS3SVex8cfmwF7kVoir2jXE4agtYrc5Oxogy43+ceZJ6h1lmP76k8HKXOBpFyge0KA5mkmF2rjC89EMDwpcKjT0QyGCf9mAbrHjGURFR0xzBaeTfikbQNLZtACKja4/DfQDsNf2sUggmyaCGu4/FMWEiPVgj+14+yhBNlTjwDlVx0IEcp0d9SWBlTPVXW0IljlOKtNcqXljxsssgz7aVhmOcqKOg+rtaEJqNvR4mAC3N/4kRFX/Xfm9ctGh1HlVq1kzC8bwK5g+6ZnBEnbZBO6BEgACWlbUKkqSZ5hq+bK8wQkZmiVxVbH5FXg9I2FvyJ9ktP442mTxGV1h0lPx90xUcdPZKUM1IEoG9oJIrJkbFzd1VL2zeCctfk4xp+07RxRk5FErkMwKtwhdbx8zBMiQkF2rtUe42aJR51KKgnmzkP+qwngk9a+sXEPR99TRiDL8V2kD39cAXyI3zGeUqVcCIKfblFjM/hph9S6IBIcLLqTkOyVYDzwStJkP3CnmCZUh1rO80xSPn2tysixCSRQSm0/QamNLN7CIecjIxZeia5q4ugsQtl7HWoD1lHwc4BYmiDsFMBns4Q781FdPjvzNOGR9kMEtXCjM6Px+KVLNGMYiNeEDYSUIc8GAfDMRpOiewzzsMtnHSZjMbkfdmltnXoFGdfDFT/2FEztPkV6lcpo/zc+t7iuozhS+BdQlYbeqehA1gXx2dkzg9TDakgvq37tP4m36J4zftuYTmk5sgIcYuI64AQji9h1mIpBYYLGhAdGyLTWakyu9Mv7rdHRJFjamGVzXnObsCOonZDUR6ybz2HUZ5/edDEPRCMkl3rmzbU/HZCM3lLuiJsEjEb6OSXw0XbyQmKyb+vfTuXkprepZ+QStPK12jfRkmEC+pTt45
 bAMiGg8R
 wP1CCSwJ7IQC1/qlW1+MWZW/89WCTthX+Ra2if30jgYZL7l9jU1aPQlCkQVheMBrf+yQ0F558+d4ws5Zh1Ogd4JBEj736gvWPEFSecB9RSJKa05xoXRckZDiGiSIy2EGqsnWIyiqKLCfWTvz3s9pOSHpAM1cLgIx0Lo/0NyfgmMQFWFcMPHY2WVWt/CUXvrrVY4mQii/fYrdRLeDkhIkbh+GTnK87G471IFSIWYVtHArWr41VJSnm0TYvEGPPvOgWXZJ4cAtEUdZfCzI+8XPcYPWnvdKF60t/BcnFT+viN4/ljBLYvA2ASao+qgLilNHpY74cfmyvLh7gMOuUdEz0g2qNo72bLQ7P5gMHzrT9/KZWdI9JY40Jk7se4dSNNf3/LYHpJtmkHF7zThs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert the final caller in get_writepages_data_length() to use a folio
and ceph_folio_snap_context(), then remove page_snap_context().

This drops the last open-coded use of page->private in ceph's writeback
path.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/ceph/addr.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index f4aaf9a5f196..702cf5fc1eab 100644
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
 static inline struct ceph_snap_context *ceph_folio_snap_context(struct folio *folio)
 {
 	if (folio_test_private(folio))
@@ -697,7 +690,7 @@ static u64 get_writepages_data_length(struct inode *inode,
 	u64 end = i_size_read(inode);
 	u64 ret;
 
-	snapc = page_snap_context(ceph_fscrypt_pagecache_page(page));
+	snapc = ceph_folio_snap_context(page_folio(ceph_fscrypt_pagecache_page(page)));
 	if (snapc != ci->i_head_snapc) {
 		bool found = false;
 		spin_lock(&ci->i_ceph_lock);

-- 
2.39.5


