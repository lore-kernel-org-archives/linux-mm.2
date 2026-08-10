Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A58FCC5AE49
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 14:21:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8459D6B00A4; Mon, 10 Aug 2026 10:21:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81CE06B00A5; Mon, 10 Aug 2026 10:21:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 732A46B00A6; Mon, 10 Aug 2026 10:21:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4AB3A6B00A4
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:21:36 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D3183C018D
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:21:35 +0000 (UTC)
X-FDA: 85085572950.25.486AF47
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4C7621C000E
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:21:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=EkS2ZwV6;
	spf=pass (imf21.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786371693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IS2KdOnhS+pv529qUIIXEsI3D6umDLAIzYcLLhsfZ9U=;
	b=DVGo9EPtkGK5ABiOee4QDKispQBYx8m06W5fJHjjOKFgrpPRER0lgMuQ22smM8LQ9jVZhU
	1iRg9etQR+2IzbDIHS0rf6hJ5+r1oUhFv3cEItj3IWjxd46BWHehL0MG95TmYd7Vxl7MTS
	SVH4rKEJFHHRDfnNzqfuIhhBocIrku4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=EkS2ZwV6;
	spf=pass (imf21.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786371693;
	b=K/QlHd1Rv0UJkobokXOTnSfNkgIFY6iI+XSY5JIRLTANlo/5eRDXFG7L+1zc8hYNsyQOo5
	d260lrTQwumaKRuiU5PMzWutngNvYmbC3CZIkUxYX8nz5BWV5OFP4RrP6EEJh+vYZRkGcn
	G3KnLtP/RfOqIVZKLqcGzqrPVyiybxE=
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67AELQ4U3539177
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:21:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=IS2K
	dOnhS+pv529qUIIXEsI3D6umDLAIzYcLLhsfZ9U=; b=EkS2ZwV6b0f6O3aHEd2i
	RANZAvOHFeRb++OZt8dEvJ9SYK6C6bR+Z3Fge/Llme7CX+RLXehAh2eHaxcIDAWP
	qPoweieRpg7zjREbedTtlOdIRp5LDL+B0NE3WnO5pe1b+vmynjIHoSwZXqPvHYof
	k0Xg+94f1zCZHd2NHGouhJGEL3poCkMLZDsCvV6amfAvAly1QOVo65vxtx8KN8Gi
	xfVMTaR8tF1idnY/zoWMWja+gY9um/BYVaBv3bB/Fav/WxU7gvQQ069ZXpCLvAWt
	qxaYENigWI2V5jr+KF3sYtmWbrCw5Vs34qiCQtGiQUOHVpAlBoTTS09RhvLOoka1
	wQ==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4fygb6g04a-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:21:32 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-5283df62d68so23088531cf.0
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 07:21:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786371691; x=1786976491;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IS2KdOnhS+pv529qUIIXEsI3D6umDLAIzYcLLhsfZ9U=;
        b=UxVRdAh6sQTrHKEPZIaf0awJnL9Wnozqqfn8VLQHFZfJE7DPUnep/KHwHjuCn7v3Qv
         6vr0IBXDBHKTyx/OthFIZ1EMab9IyoIHCGTPFKmJb72bwMB7hSa5f2hCUz6YGprtD3mG
         DNGiwT58lfbId9flqFSu+/RAsfKWlyy6Y5gH27H8xd/IFRAtn2svTi4Nfp3BlM39i3YX
         iXOQJfkQP7OX57gJ+diEvQ+vwMeGE1sstdMopmrYjgS6xG/St0uO4K4Bmk5b2aF3Ua9m
         8hbml6kz+OUM4gGSgfX6ar86+tesMnljzpvHCc4HR3eZ+mF0c6iUTbxOxnMUP6joucFS
         HXbg==
X-Forwarded-Encrypted: i=1; AHgh+RoIqb1YWL+JrRugRAOefyg9MEO7kJfzOZcJHKB4Izo8fSRe34ri+pguzKfcsxdUK7XqJEYHG2gMzg==@kvack.org
X-Gm-Message-State: AOJu0YybPWzmLQvatStI4uE20ZeB6OZQMMwGWk5OqnD8a6go1RK5Dv00
	5SXUvnwfs77tuHFHp9s6L4CDaS/9ztuib5CilhMITrE8CLmjeJkmFAUrt1oVt/tZwgMIJvReSUC
	X+BwBLELfq5WloAhXJmRhC50URf/aXkuOb3FJzUdZIrXofPFq
X-Gm-Gg: AR+sD12G5OnduQJAoMb3inrMnpclFh+kD5FbsAq2cumryJGuL+JLR82iK63VejpgXin
	Yq/D83T6W81HXzvz4MStW0/eiUNDj79g9QazxvfdfNHVJnbb7RbaHrGhBrf8EFxm2TEd7sww3oN
	cEqjalG8kuBjBTl5AvHaRa3JWSck5CDzs/jIXsm8XxymXqs4Zih5WRodl4R4e/QWUr+LcLe2eM6
	gSNeB9SRqV7Bwxu8hO4vFwqegAw1BznpjTZoKtTlk8vDwOm+N3LUi8c+z77BXBwk4BTJucAlT2N
	n3QLiEMh8kOUNIkpFLsPvdVEs/y64oqRwbzzdzqPQ5zzS8hvN7/4j1XQN1yEQ6OVyixo+WkgEq9
	PTyvz88gW
X-Received: by 2002:ac8:5803:0:b0:516:dbf6:f8e7 with SMTP id d75a77b69052e-52d4bb7c738mr23828301cf.17.1786371691369;
        Mon, 10 Aug 2026 07:21:31 -0700 (PDT)
X-Received: by 2002:ac8:5803:0:b0:516:dbf6:f8e7 with SMTP id d75a77b69052e-52d4bb7c738mr23827171cf.17.1786371690810;
        Mon, 10 Aug 2026 07:21:30 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.77.155])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48002145589sm37383983f8f.1.2026.08.10.07.21.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 07:21:29 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 10 Aug 2026 10:20:21 -0400
Subject: [PATCH v3 10/12] ceph: convert page cleanup loop in
 writepages_finish() to folios
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260810-remove-wait-on-page-writeback-v3-10-dd7531704f26@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786371655; l=2393;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=ar+8uUIKlAkAAFvZ1bMinInPdLeZqUCbyUCUmYHyjco=;
 b=ghqy9OZjRc9FePPnWqoKALFu+1yEbRsD9SmCqfkGncI6FOr+Ae3idCTnHhOGXi1vizO9BKSFX
 eZ1AFKyjHVlDx2T3q4hy/XrfPLIc+/L7SleRQUkxj9VLrFPVOhA3JyX
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDEyMyBTYWx0ZWRfX+/XWCJFGdw+8
 d7LzDtH/4jCwoL7fdUBwpFfY5o+TYVO9NifjSIC2/s4Z8o6jRqhwzwgrDzM2D2g3KHC7DCglsc0
 RRzuuyaFj3L1QLdux9V9ilsbEjffnMzKnGbA0kiFK7iTu8GNzWxD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDEyMyBTYWx0ZWRfX7TIoIlkX7LbV
 QSlWl4M/2c/tAjmoRuVDKCtZPQAws1tKejP7KHobr8byF4SFixQQBBI11g79QuADG+w7+xruQX0
 sNmduzNt0JtDy1atUTapxah0MviRv9rj4ockfkpTlhqny1nGdImg87KYb93Z9tJBNLLsu6M5n/r
 gBFkkyshTr81Qy2V0/Ax0Y285hc4j+Y/fwVchU2vAboQt6aoBghuE8UIJc3Ly6wNqtLaTzLaZOe
 IqjJNQxE0wloaaabptSciCtKSeEV5J4rQrfUHo6DPm6vj33PKDmuja3a5I4y7sPAjE2NUCWko3/
 f77s4V3rCb9WImy9riCzuf1gc8AhneCP4f7UXl37HUrFCcsxR9B2Fpsr+haywVJqCNlwRFXmpKo
 RpqKy1piySePehQCO897VFB2BUGb2cqnol1iLvaGXhCU9BG24d9+2ZvS1riUEF9gT50dpcopdHg
 mptnodq2azqaKkyQLLA==
X-Proofpoint-GUID: p9gZWN4Sd-0tWge1waDj8J4YEc8sssD1
X-Proofpoint-ORIG-GUID: p9gZWN4Sd-0tWge1waDj8J4YEc8sssD1
X-Authority-Analysis: v=2.4 cv=MuZiLWae c=1 sm=1 tr=0 ts=6a79de6c cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=zHmcO6jMd5r4EZ4U0P0LQg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=PHYVD-oPFUEr7kX-Mb8A:9 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11870
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=10 phishscore=0 lowpriorityscore=10 clxscore=1015
 impostorscore=10 malwarescore=0 suspectscore=0 priorityscore=1501
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608100123
X-Stat-Signature: obrpwzk4mzfmkg8u1shrbjqbp7q4ic3h
X-Rspamd-Queue-Id: 4C7621C000E
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786371693-800169
X-HE-Meta: U2FsdGVkX19o0r81kje3tRLrMhGVz6gWQpYu4dD7VrLhg7jV+1s+4PcUi5/K3I3EwZHZmIcgPUIZkT/30IBPdyziLbcixyRNZTXDYxzr6xXI9EWZVo9uCcqxhqB/ZX1D++/SaWiPVHl8LpwYVs58IBmhBCZFQM0Z99SIOaTMjhiG+vkJHlQXkivGtcLwiGvrPGu00JehXw+mO006EjQuksW9cnhEl//Q1HfQ2zEu0BBYbI/7UX+dVU5toQ8lXKiNvxDBrzVla0TE5Y1JNxJ6eTt5TPoaUq89bQ86TFsxoxQZB0HVWgLZFBIljN2HqrVwtwGlnKXOY2wmFPXKzAuWZyDjz1tHMswachkvD+QjiTC9XeBN46YHHcRayySqgvA6JevCzfr1qZhdJ5cTUHWK6pdf4vikYSKxHSF+hRTGtBhuRorfvGsxXWEYlao4pm5fGdAkODpmtKnMGIHd8Tsiqz39TZ2vusdcFogU+SG6VIIIgFwxkTnfrE8PXjqzoqIcwp2vQmJ054w8d0RGPRn2xxABhUjl/XkJujGsQigcVQKO2ij18Y4WhP8WfugOfKI4wOcYznTqAduPgHIr9bIRVhLuLeEYJxf747VNo0GaTAJISeCDoagtUJ3qDyOjJqtI9vrZ4UZjHfoh6fMm1fbQp2ERyaYq1YyRFBC3MB7IcCL0/+sgWcC4X8gDzRwK2NEsojBDz8/ToCsqS8zjrr5H3vCNwSCl7pIkApihzTfZuyjsvin6GmkrqUOIELyALS9hFjt56csNIbqtlIEM9B5w/bkQLqRnnD7y1fBHsAsg6uQupTNv6UkaLgT7J/t8D3HYhbpoxge3GaUP24J4p+e81AJCkuqjYWhnYbynZfIazShBeWyA/MXJ1jC17V1/QoZw+nc9Ct3tjndDIk9EHhN+nZCsfUXgZKl38Q5doDkFU0KEKRhEGgtY0w7V2RVePgXeZ4afrx4d79qoIPD04a2
 Sbdfql5t
 JDYKIwxDIK6rp1YKwfRCZ5FY6a+Xr42BhSqLkZBsVXfzQNsCl8mPfWXbI+p0JjE6LaT7GEz3WKT0RM6DtZeUwxBtPYiUGNc/g7BMbZim+qKe7Q0IAa2j69flpC6e5fj1FXpcr5NzvXmDBBg5R2AYuD+Kb/wIhoZbEVG14bDWnkFdoKJkH0gSMtC+wdE9O90arOkmwzj9VZBpuHm3t+a/SFk5b2Skpubj64rxru4cMhUDowz6fw1HcwJR5dwbkZ/GRCMvrkCWD/bOBX3e0FzxHDC8OytgWLr/i5GUq01hipj/0EcNGKhX7kPHkCEmRHNRBXSVW0OpO4hwQcBgSYRSitiDaxWJH9hYHV9fftqdKRlniCh4mMRXrh1cG4QOiJnD1pZI8KWCZ38SC+cY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert the page cleanup loop in writepages_finish() to work on folios,
resolving the folio directly after fscrypt_finalize_bounce_page() has
replaced any bounce page with its pagecache page.

This removes a use of detach_page_private() and five calls to
compound_head() per page, while adding one back via page_folio().

While at it, remove the BUG_ON() in the num_pages loop, as it cannot be
triggered.

No functional change.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/ceph/addr.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index ddb12fccdcff..708343a8bf35 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -908,7 +908,6 @@ static void writepages_finish(struct ceph_osd_request *req)
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_client *cl = ceph_inode_to_client(inode);
 	struct ceph_osd_data *osd_data;
-	struct page *page;
 	int num_pages, total_pages = 0;
 	int i, j;
 	int rc = req->r_result;
@@ -955,31 +954,32 @@ static void writepages_finish(struct ceph_osd_request *req)
 					   (u64)osd_data->length);
 		total_pages += num_pages;
 		for (j = 0; j < num_pages; j++) {
+			struct folio *folio;
+
 			fscrypt_finalize_bounce_page(&osd_data->pages[j]);
-			page = osd_data->pages[j];
-			BUG_ON(!page);
-			WARN_ON(!PageUptodate(page));
+			folio = page_folio(osd_data->pages[j]);
+			WARN_ON(!folio_test_uptodate(folio));
 
 			if (atomic_long_dec_return(&fsc->writeback_count) <
 			     CONGESTION_OFF_THRESH(
 					fsc->mount_options->congestion_kb))
 				fsc->write_congested = false;
 
-			ceph_put_snap_context(detach_page_private(page));
-			end_page_writeback(page);
+			ceph_put_snap_context(folio_detach_private(folio));
+			folio_end_writeback(folio);
 
 			if (atomic64_dec_return(&mdsc->dirty_folios) <= 0) {
 				wake_up_all(&mdsc->flush_end_wq);
 				WARN_ON(atomic64_read(&mdsc->dirty_folios) < 0);
 			}
 
-			doutc(cl, "unlocking %p\n", page);
+			doutc(cl, "unlocking %p\n", folio);
 
 			if (remove_page)
 				generic_error_remove_folio(inode->i_mapping,
-							  page_folio(page));
+							  folio);
 
-			unlock_page(page);
+			folio_unlock(folio);
 		}
 		doutc(cl, "%llx.%llx wrote %llu bytes cleaned %d pages\n",
 		      ceph_vinop(inode), osd_data->length,

-- 
2.39.5


