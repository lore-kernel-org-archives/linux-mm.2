Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30A8FC55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 18:53:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1DBC6B00E7; Tue,  4 Aug 2026 14:52:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF56F6B00E8; Tue,  4 Aug 2026 14:52:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE5CD6B00E9; Tue,  4 Aug 2026 14:52:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AAA446B00E7
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:52:52 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 368F81A023C
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:52:52 +0000 (UTC)
X-FDA: 85064483784.10.BFB9E8E
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf05.hostedemail.com (Postfix) with ESMTP id B615C10000C
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:52:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=pIZFL8g3;
	spf=pass (imf05.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785869569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Z1d1TlXkyKgDoQf2U27ofqIWC2kaIkUryg1X3S+EV8=;
	b=NwxRst5XL32SkfKLJ6qWDPQzbVnr6xwA9YK34QaDcZx4T94btbDviWdYT+7dTqURbRINWc
	NnMQw5164NNt1aMgw98ZMAo3efaVPPUif8Mz4di7nWQXqToOtghDpN8cVONuFhHBPai1ZC
	GzRE1MKnIYVna5iNCe31xaBxZcl9Zno=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785869569;
	b=BaqHKLYsGL8jyyOY99ExKQNaQkXqOgnCCOLdcoPGmIzjXf7UHs9EWI+NAj4Io84i48B8tC
	LcFgx9SIUiPwBglu3h8Hz5CsJT7om3qnt6PtVc136ln9ia8hbRxqQqxmHKe1UuJOCUIEKB
	U/aIy2lLcd+wOu/mK62Vw5fIRkCfSkM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=pIZFL8g3;
	spf=pass (imf05.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 674IYHJr2598069
	for <linux-mm@kvack.org>; Tue, 4 Aug 2026 14:52:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=5Z1d
	1TlXkyKgDoQf2U27ofqIWC2kaIkUryg1X3S+EV8=; b=pIZFL8g3JUUeHvOt2OuV
	Wu71CXApi+WoFTVDKHD1/CThuPssXvgEf8afTE4woSfTDzDNlkbR7bk4I/MCT5yv
	v9kWn3cFllgIgzjvUCyZAozYejIzx79Na2hpfKysxhU6pXFutU9fZVq9NU119ojp
	QfitVEAY13o0BBon33Upj1u+6tGk5seoagnigVWhuX/VSZDbq7xi0cDKcJkhISh8
	XSdacnrucuLydFB0ybrv73TudiDvxphvALvNgkRHZbYd3o7VtCmzMGOqxbJwQzt4
	cz974U1Kl7j5Amd+MWNKejjew4aWTjtQtU0d9XOkhdaQ5yGSVOx++XuCVNNlGUjy
	WA==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fugvvapf1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 04 Aug 2026 14:52:48 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-52769fc3f2eso1292531cf.0
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 11:52:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785869567; x=1786474367;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5Z1d1TlXkyKgDoQf2U27ofqIWC2kaIkUryg1X3S+EV8=;
        b=BAauB9IgjE7fylTISdrPcSnSNJcNy6obiQtddFhawRy0Su2On0nHxX1G9b2Pj8REgU
         CCl/pyO9nAe8dl6VHkfAt6WzyvxR39IcuoYXT6WJ+C1YF/tzXA/5NOJfatAhWq+P9Y6C
         6wdl0MGGWs0pGCZRGWdVR/6FcOzVjUGH9Lo3YwEWV0EMESRvgznVs1eczdgcE87UIyMI
         ISXK1UmG+yDbSyUnOaSEHajGTBGSDw41Gnog5K3DSWvikChJOMHlH0JwTjuM6JuVwCmw
         hKc0cJo+TiMmhNSEiQPT/cTaMlejdw1o8qry/ZPhJqlLOSk9TJ/q25qaLQDyHt0aJPaD
         ukWw==
X-Forwarded-Encrypted: i=1; AHgh+RpfW62iCDEbJc7KJxLsGvi8Ik/7VGrpUJGLXqJKoUPdFV2EQKj93IjsPoBOvKnc1cki3ySG8K4ltg==@kvack.org
X-Gm-Message-State: AOJu0YwXxRnV3CGuAcvCFlfoo7GHjJtw72S8Kb0XEUaAVAROvlqx2TrY
	IxnfQ6hRnzz9rQK5ZZG74w+cAKDN3k3AW+idDRoz8lM3LPaqvj2aVsRZ2PoI3H+BAhv8/yBxR0d
	HqJTm05Z67PKGGj2EH5AfJM/laDJws560EDyr1RyEMMxqOflbI18jyEHm
X-Gm-Gg: AR+sD13Hflfqdf5f1ful92ONQOBu7iQqixN22GccZhs9UPZ4Md1vHgFFkYu4cgjGimw
	WQ24pq1n1UmtvwXzW5Otz9AJhO1LsYg3f/mn8WrgvCmLzfftf4ICV9iKKo8gZSi67IKLNW/q3iL
	STemV73xD+Czp/auS9821Fc21mnqUuE5YHJe/niUlWvKHi35OUAo834khUpyl6nMnyWtayYt3qD
	NxIGVnJQcq0yJlWRKpT84iNTLfhAumWda6NAGD99+ez2IDrBi8i0RNtUG3QNt3iPZZvuHNKP+57
	JaJ4YObk3wH+VrJKE6NGXxZfuEPCPxCBIjsBsscqute9ZpiZL6CgnLYQrzgC8g3I2DnAAsdzego
	Gc4VZUkk4
X-Received: by 2002:a05:622a:4811:b0:516:d60f:6438 with SMTP id d75a77b69052e-52ce5e01448mr16271491cf.0.1785869567604;
        Tue, 04 Aug 2026 11:52:47 -0700 (PDT)
X-Received: by 2002:a05:622a:4811:b0:516:d60f:6438 with SMTP id d75a77b69052e-52ce5e01448mr16270781cf.0.1785869567080;
        Tue, 04 Aug 2026 11:52:47 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.77.124])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fec232d7fsm2313275f8f.20.2026.08.04.11.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 11:52:46 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 04 Aug 2026 14:52:16 -0400
Subject: [PATCH v2 08/10] ceph: convert page cleanup loop in
 writepages_finish() to folios
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-remove-wait-on-page-writeback-v2-8-81f0ab065284@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785869541; l=2329;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=VtzqiAKIaGHunrdK+84+1QbqamvLCcoJ2tsGqghPxR0=;
 b=RyGOUa5eKloJbpygdzbwT4OucEq/qVhavJ6tD6H5WtS+DuBoeRpiGXKJb0kfgATrw5uo/X1hn
 fWUMpT5dvtsBAAGgVN8auf5poVNA6xzYJwPO6B0z3lte5+1ZD1v8SZ0
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA0MDE1MiBTYWx0ZWRfX4lJdPll7b+yx
 pWa4sDGFrTp06aSZnEIpn3+lgS2p1gWrX0bwW18u4FrzA0xhkNzEQ5kBugmM7QJc1IHQ1WJ7Ilg
 4G3c6ipZ/tJYcuqefi1JTtQB5owjFZ0yymJqbPXQjfQfcpdAUzafHNpl8blGUHbHqolniidt+HT
 9HZB7dHLlcC0bibz4R9F4mI4scuaPKaliBcJfYDbtYgkuGqkpAG/Yd627XV4TwHGPSMv8mw+sd0
 LwJ1mCiKuPemivp8sibiYdvU/udEnrpKazYGVzMn9eaSWyCgvrdrDDnVdS1kVETS3NQ7w3qrUd0
 UT7N1keMi8vbCJdhi8dStL0VP8tc1YGWNfvOWJh26vMAdGG19Jk0zo4OAZh12JTgi4EH8eHmDIP
 +h65mcQEhYv7UEgdXZVHATTghPC3v7DvbXYWoi6Tq8CMI5mkv4Mc5nM8aUnPuC2oDgkYD9PIkfu
 bLuixQ4UaTeYjtdaV3w==
X-Authority-Analysis: v=2.4 cv=ZpLd7d7G c=1 sm=1 tr=0 ts=6a723500 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=j1J1DEHOHTVaJYOjuVnKiw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=PHYVD-oPFUEr7kX-Mb8A:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-GUID: 2cdZbMrJ-jN2ncGmp-L6uPA-INmSXRmN
X-Proofpoint-ORIG-GUID: 2cdZbMrJ-jN2ncGmp-L6uPA-INmSXRmN
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA0MDE1MiBTYWx0ZWRfX4pMU0SjkDiVh
 zYv7U9eSzZcrGlX3cMdGggABV5zOKaPgDhnJ2Gu/TXWGJ5un6ewxhxnGecLlLWYwghI4cmjdHpR
 wjFFEQSVQs7R0ka4n4pUdM/e7doMT3zXGBUZeOdUAp8vWdqb6JXx
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11865
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 lowpriorityscore=10 bulkscore=10
 priorityscore=1501 suspectscore=0 clxscore=1015 adultscore=0 impostorscore=10
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608040152
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B615C10000C
X-Rspam-User: 
X-Stat-Signature: xcpjo7snh8b9xtcakohdoam6kt4sqa1a
X-HE-Tag: 1785869569-939563
X-HE-Meta: U2FsdGVkX19BexZlG5TqlVYviUMgLBTCXNTe+yJPOiwwbAt0Sl6IrUwffe7S/eoZXaW6RhzDJvKUOE5RLxYYjZ/UmNHHvD6h343txBPy/UnPliShCgA3xuzS3S2XRwHJhokn2gTIuIUcJyacwqr0WMiPj0iBE5fk5ZcYDLmVSO2OnQh4W9MzUh7EMHR8Na4z6ZVke6pbLcPB/XZexaViFFEvhWVTkj0Nmuak5HFljJBc1M2KZSjy1bJlJeE2EMcdoT4uzwmXeCN7h0J9oVdiWWHPU8+b/VdLSzx3Syf4S5OnAxPceaqZF9JcyEPoJsqLNvnE7Z8CWIc0IA4dg9FzWdBk2pfd1ZsqT9J2CNWBv+4HJ5fgeREc2wl4lo6pGk+UpK5ONd+G5+32pUp4aux/KkGC04EDj15ZavMA+xLDqYZ46XUc6+qXUIh58442aV3kJApPlRAnf5CRql3doD28ragIsLXNIbIPpCmQlppJTS65g11EKDwUxMYZfAR3xZSRysfHY8L5KK7alFU3IqWv+wBPuYNrZEII/yxlklK8XovsIl3HS0yHdEZBrYJIHH7mXaXBIOjgyfaQrNyDttaDNrV+vnSJ5+7KQXFHioazfHIgetlc/QPeXeqPcTyVPal8yxWNSrUykINDPF0Xsdw7RDHjthTpMtDISDST8Bo3ccHTxaJGUfuFNG1aB8nTFEJsCifEyYtrf5j08p8gkKuYHN8xtczzVFMQn9wYINjTkWeXnQY70syAIUzPJO8ESO4XFWSb0aTlGz2zebV+aSvIZX/ikcYk2dgG8fLopR4s+lhhVS2S0G+06GLCn/cGBm1JNjwcYLdnxSqst50bgRFQ0kHhaOa//Gik7250lF/JUPneVGKYI/j3BYtakBapqOgEUsOkW21QzLFbwaBpCvG94xgS8wUaOVc21+pgnInFo4h4NlUdvMm28ktkdUiPh2NjwIvhr91agCiNejUnxUi
 IcjDw3K9
 SiT4RN4rVIJHA6og2EQdFyYU1TZ07cmgm8Rh6LCXMlkA3wB+gwTvo1aI2ZR6u5tGAH2RAghTX/g2GQPuNv561nkMULBPuM2OeXjI7RayjnQoaiOO9JZyU1MjTxQIgm4eqA0CUv+YYGTWQMI3b1BoYBASgfBRYQ03daWVv8QA8L5Ipu32dQjtOZoAiWzGHqOOIICPbsiHkl9OpoDw4VqB0ih1HzgjR5pCPy6Nbbz7BU3txplGpu253ZubAHegYHFcFTIQZ7LZOp/iLtUUFDQMenOdd+tIrmMzVHAznTuO0XAafShPkvqDjrsMYvx/7QjOgVpqOLsqGyDE2Md/R7/8B+FvEjf4vMbeI/Q9SEC+CjTijqSIjzX71qrcuROFJLHaF6QzKyA9f9S/G/Dg=
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

No functional change.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/ceph/addr.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 59e559bdfdff..eaf5b3f6d13f 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -896,7 +896,6 @@ static void writepages_finish(struct ceph_osd_request *req)
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_client *cl = ceph_inode_to_client(inode);
 	struct ceph_osd_data *osd_data;
-	struct page *page;
 	int num_pages, total_pages = 0;
 	int i, j;
 	int rc = req->r_result;
@@ -943,31 +942,33 @@ static void writepages_finish(struct ceph_osd_request *req)
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
+			BUG_ON(!folio);
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


