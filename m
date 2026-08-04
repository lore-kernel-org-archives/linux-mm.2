Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F35A7C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 18:52:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F5B06B00D9; Tue,  4 Aug 2026 14:52:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A6126B00DD; Tue,  4 Aug 2026 14:52:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46CF26B00DF; Tue,  4 Aug 2026 14:52:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1E7936B00D9
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:52:35 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A2A99C014E
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:52:34 +0000 (UTC)
X-FDA: 85064483028.18.B065D88
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0D7C1C000C
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:52:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=HY0pFEmU;
	spf=pass (imf10.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785869552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yedVj+u8P0Tmm47FPkrJoqBk2IvRgeJQ6pNoT7nNxrg=;
	b=Bz/XYIECgrLlXnNHNoTckMnPGHXBRh1iyYEXTKfgd3/Y57jn/t43tltCODHUHdhMg6+Qt1
	UrmUbzRcJkmrykdqdnAzArBOmHkfvY19rt/2VyDWpIzfkPoK11WakoGed2pDu4btfPDG8E
	WhRDncGiuhJE5xAkHM/9bp8VYOei5b8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=HY0pFEmU;
	spf=pass (imf10.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785869552;
	b=UCpLbHexR1NyV57DD6ACw7NLVmy2vYuIN3W/+DiruOHx69RBCGTWpEy10ythzgeR6D9Qrs
	Hv4mPGygnK4oTBBHVYwmsvm1cxto7MZogmrnn2cTcHA5/niI+q8vVZjEbMSZJGie5Dknry
	2eR/4bsnTcesyP37o1vB5LDM7E1xNLs=
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 674IY58Y2463528
	for <linux-mm@kvack.org>; Tue, 4 Aug 2026 14:52:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=yedV
	j+u8P0Tmm47FPkrJoqBk2IvRgeJQ6pNoT7nNxrg=; b=HY0pFEmU2udRqNNtUDxJ
	9RSw/lY1Vy7TzmvBYQFFbm40N4EWHwXjduXKD6rPYdsd71ltw1pMGfLRlKg+A+Tm
	EeksvS+7yGHcIeZbpz3F5DcsvH4dB6uY9vtQfupd+eVglKx19C9VuMyTDCGkvwLB
	gniMiWuNavsOszMidxOzzU/aeuza09cTtZR7VTESvwda2biUIollaTjfdJiZ3dPE
	L5PMfaZONppi5iegiAmsn14rGXFS5Ij1b+24q9tudfiyTDVE7d6zTN/lW2/GFaT1
	Pl6n3xbk8eztta/yTTrL0tVMLE+xrrmnzNP2S7pbmok6hsdSwINqqHG6Ys2BASdw
	mQ==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4fum1pgxcx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 04 Aug 2026 14:52:31 -0400 (EDT)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-8fdace20927so1462536d6.2
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 11:52:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785869550; x=1786474350;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yedVj+u8P0Tmm47FPkrJoqBk2IvRgeJQ6pNoT7nNxrg=;
        b=DAqrNhDd344/W7sNcVAJ4DCVqYwoQPZtIxbb/cT03sLwKAXttEyMJbU2Qepr1tzViq
         Gin3IAYQQfeRcIFcvrJD8NMM8+mafvMHNzIFkpgEm0jLIIJfpb0KGfOD3HZwKcfwPaWZ
         tqJhWm3bu+W3Qr8FtbYTrqbgmXv2FiK+FuYpnHVKpGF88NHvPPkThjhDTSc0/7SC682m
         bedWM03gcsOQ4ocpXMODy7j9WcTPYhqiT/o+aT0lbaUtvdaPJVQ5LET6/tCEiYHJMfth
         bJ4F5rR/Eity7300PQaTt/SZQ3Z+f0D4GBqW92f/70Zj79WmNn38TTGMumdAWW+8tW7U
         tKFQ==
X-Forwarded-Encrypted: i=1; AHgh+RpnDsdihDLaNxBYuQWwkzMMagVvvPUJtU2h5a7ma8CVPdnbOtQub0qMbpBNEPuYZP7mCaTgFz362w==@kvack.org
X-Gm-Message-State: AOJu0YwMc0pOeWbbh7iCpsEpdLbb9CUNbf3apnis6pcJCaGUhOpMLzOc
	mzCpKRtb0PSVmshMunghEwVRijdeA6swf+4p1lQkPduNWyqfbRVCzi39ymKKT8mPpYx9RGI5AXA
	9J1cMhfnMyCJrnRebAUk9MfBS7IQzWxLc8t1uSapbvK0Sp6ZWjDiLjKAm
X-Gm-Gg: AR+sD10utMkBHkdUdx56BYdcdRb1WldMi3LYapDpRHYuhrgntCdy46hCt5hEj34lCYP
	J+jH5Q3rAiXK957QD7R2Nx9ASKleeLEnn9BY3fJSrZNmreyI+dbkjJUHEpnV/XfgJV5BwnwjeAh
	NCFvlzVfeYZcSICxEvRURWtLjPsIXO6AyP+gPS2uQdMk73bbT0t5GMLo5yRMlecxKdUTGAp6cxD
	7/PzwxA3M9kjLc0F4DTq2Cx7pkpBiBVgm5rzW/7xWTZ3FcbPg97QzTzlo7lt/1ojsfro6j5kQT7
	eimyN78A1nF+++8Ug2FS6QW9Ua7COuY0DQCd1+0cgmNT4pN53rh80y8emKLSSTD6C8UzRq4MDOD
	Fc/fuHDW7
X-Received: by 2002:a05:622a:355:b0:519:8998:661b with SMTP id d75a77b69052e-52ce60c07c6mr12783101cf.20.1785869550483;
        Tue, 04 Aug 2026 11:52:30 -0700 (PDT)
X-Received: by 2002:a05:622a:355:b0:519:8998:661b with SMTP id d75a77b69052e-52ce60c07c6mr12782271cf.20.1785869549978;
        Tue, 04 Aug 2026 11:52:29 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.77.124])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fec232d7fsm2313275f8f.20.2026.08.04.11.52.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 11:52:28 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 04 Aug 2026 14:52:10 -0400
Subject: [PATCH v2 02/10] ceph: convert
 ceph_wait_until_current_writes_complete() to folios
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-remove-wait-on-page-writeback-v2-2-81f0ab065284@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785869541; l=1518;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=9zGm2Ur3Nw8t1fGAniDrK4O8Ro9h7p/uEv8uJfX+ZUc=;
 b=YhHy2DJ2mcWRFMayaQHzRWVDDTYASGlGUJSMGAN80QdBcHSVdXLZ5tByq7B/kPH+1jdGwugfR
 syQDU3doLFhB5JzGHt5ToPbjDwQSP/Ct8ZorKaIRSv2e2Bwqyj1AwU+
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=PII/P/qC c=1 sm=1 tr=0 ts=6a7234ef cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=j1J1DEHOHTVaJYOjuVnKiw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=JfrnYn6hAAAA:8 a=oBeIbaJldBQvbLH65vwA:9 a=QEXdDO2ut3YA:10
 a=OIgjcC2v60KrkQgK7BGD:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA0MDE1MiBTYWx0ZWRfX81Ic0Cfwwo95
 PBsUmUh1ann+eKiEdrXLTXXzInDRcMBAjmvO9CJL0huj8zYU1vTM08zgOJpG/+EOnMIXJkbdRue
 xAPxUnqGNv7iDEMeFOgb+G2rZATD5kn5mTF+I46SIFFo7GKd7tNcvYRkdUXRolffnH9Jjh/9snb
 dLONMbCnelQgnJx3JXQ5cnJaSr+Yx7oO5jml2WNADW2YzXMwknlGGQUDZ4Ccoc0ro6LI1NEYv8l
 kNrgC2CHeJfuixcjIXLbW9SNmYd1gO2iGintQJjoHZef2ydlFhUoRRIb0/rN9QlnGbbDCPDweVn
 I6thphTEd5Qy0uZnkoqPWv/FKkdNtjGgGwDwBzmFMclgmSd/sxT2PeXGNLB5w/tD9TB8eHo47bP
 CadYL9xaCr/H6oASAJ1pItvevn1RNIQ8NhFSRj7LC3N0l3A5gGnDKwlXvaCzmmhuVBUybYyMMxu
 oF5CCxhiP2BvDTyly4Q==
X-Proofpoint-GUID: 8aGoTIhbnqzlKHHJ6hiYng_tj3X6anRG
X-Proofpoint-ORIG-GUID: 8aGoTIhbnqzlKHHJ6hiYng_tj3X6anRG
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA0MDE1MiBTYWx0ZWRfX/ufTI7ftA2GT
 7AZRo4FdJ0KwgptRL7FuQINIOGOnjTfEWFVMlUVloaAbJQ5RL0gsAl64sqkhD6XRHK6DBEcKBJU
 lBHTj8GyOgtF2UjagWBgptzBeo76Xt5KUU9IcnmWkyyEP2Y8Ix6F
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11865
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 malwarescore=0 spamscore=0 bulkscore=10
 impostorscore=10 priorityscore=1501 suspectscore=0 lowpriorityscore=10
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608040152
X-Stat-Signature: k7adgxc514sz7o549cfpxsteq8jdnder
X-Rspamd-Queue-Id: 0D7C1C000C
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1785869551-541204
X-HE-Meta: U2FsdGVkX18yIjCES7gQkLK282DTxngp1rAmrE2H2GwTzNxb4t0TBf6TDmZOV+p1d7ZQloJKl49ZnXQN9/2bmphgOe1yDG0RJXq5u4lMKcb4OtHHyE83b0rPJzQwMO1f2S/w3OgHiDa0pUBYtn5iMhounmgHbdYxeMLsV+BBxOwuunS+MEYZ8q94OHUDBsUtDCVRuy6BZl34J8ONcidOpa67jYpdJwQ/UiM4mV+56btnA3bDh9dO6RmcMhJQX8S0Ue1sja9QsXM12wf793Sy6NCzev1Rs8GYI2BFmjOk1EXL8OdjcN9e4SYYwDAp15hczKYh+zG+7NAMxddbDXgN3LXEjO1W5yTtYYQVczHjcD4QiDnjQ69hRAYOI3t8n1eP+FiBBkjjPZwwWt0ubvuxF2PQl/5ltWj+xYn4ZLL9XQVH2Cpe81CYwIabxcbz6wKfi24YpdwerSS7pzifcVMRNKTUxOtbYPQrwETKPzY5L4+kw0CCjqdVIcDpKswwebQ0uRB+Uhmvp60UiAyhguGbRrkr70dMsrvkanLGemjdJP02t70t3gfkcbv8zv14noBkpZvgu/e+0NN6zhdvVot/pfCfV8oNfQ+3JoUBt10OpTutFw/oaSrppX4fTKx5PBFvd15+8NLWZ//PUQ5kHyszf8HrHkBHUv5xY01bZzKS+My8RxR5wpXztSlaSRs7WNKoYwvWBswB9G+vIJ1ftic0Z/42Rax6DjOBvgmxmx12mju3iuYykfa8GiLV5ldHfK1hE6x5DshZAIf/ZFlq8/DuJlma++j5RI9mdTiBsTXYDvgTpU+Q5aEKtg/X04D872J4g6zaVfCThgIUYpT7sV9ds8ZAPYJIoS4I7wxu4KDurC9JrXO1fjrWhw23YVb3BM2xtVjkhkr/U+m2gqLhSpWeWOuN7uVnEEgnrMvjRkjVqoNtCp2ssN3SFK9EjKSwuhGa39yxG/9jXxFupEAZbJm
 yOII8MUC
 uNSVK7MWCcW2Yj9HFcUc5FAJkWX2TslR3xapE59VWlGp+eWWCbOLWqsqUcgh0MxlHCRYVRPDT7PaQuNX3JNsunv84gzmnQWU9YXh3TP60kZmABMheYDdoulx4Gfkc8bJ7Tn32NolloDYu7EPwlDaMi+TqX6npPBXu5FnyZ5hZKPFU0Awk4DuM/1Aj5cmEzYNGLi6fzxMC3ECtoiciefSnfqxTdbvTUpZYfDcRlMnrNXQuoxRRD5lzZSd6I+Nu5/r0ZKb3rUGlxllvXZvrfcp8ZkA7G8cv0IOs7UPOUZqsS/IWfYThy8H86Pu7w2bIG/NtospmJAazfpNMVosozRWn2EXCe1Aj+5xvNurcUSbsUlHF+/ZucJJCdCFN0yxC/pncvxn0u1ijb7xg8ZTnDSCa0+G4JuJrPlQ32L1W86IUYQ/3PKL3iVramGDZ/IAiVfsu8zWyPSPJ+WWLU10=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Iterate the writeback batch as folios rather than using
&folios[i]->page. Use ceph_folio_snap_context() for the snap context
check and folio_wait_writeback() instead of wait_on_page_writeback().

This removes one call to compound_head() and the last caller of
wait_on_page_writeback(). No functional change.

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/ceph/addr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 8347366ce5d9..967243f425f2 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1624,7 +1624,7 @@ void ceph_wait_until_current_writes_complete(struct address_space *mapping,
 					     struct writeback_control *wbc,
 					     struct ceph_writeback_ctl *ceph_wbc)
 {
-	struct page *page;
+	struct folio *folio;
 	unsigned i, nr;
 
 	if (wbc->sync_mode != WB_SYNC_NONE &&
@@ -1639,10 +1639,10 @@ void ceph_wait_until_current_writes_complete(struct address_space *mapping,
 						     PAGECACHE_TAG_WRITEBACK,
 						     &ceph_wbc->fbatch))) {
 			for (i = 0; i < nr; i++) {
-				page = &ceph_wbc->fbatch.folios[i]->page;
-				if (page_snap_context(page) != ceph_wbc->snapc)
+				folio = ceph_wbc->fbatch.folios[i];
+				if (ceph_folio_snap_context(folio) != ceph_wbc->snapc)
 					continue;
-				wait_on_page_writeback(page);
+				folio_wait_writeback(folio);
 			}
 
 			folio_batch_release(&ceph_wbc->fbatch);

-- 
2.39.5


