Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24109C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 18:52:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAF846B00E3; Tue,  4 Aug 2026 14:52:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3AD06B00E4; Tue,  4 Aug 2026 14:52:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9017B6B00E5; Tue,  4 Aug 2026 14:52:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6637E6B00E3
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:52:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EC874402BA
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:52:42 +0000 (UTC)
X-FDA: 85064483364.28.841F517
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf23.hostedemail.com (Postfix) with ESMTP id 72119140009
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:52:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=G78mi6xc;
	spf=pass (imf23.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785869560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BNbCkzyvx9N/XZgbSIGNDSvN3Z/YrabAYl1OWD2SP+8=;
	b=QXZp/KojQMmP/p7ouOgu9BNJjwL+FSuf1TTCsN+WCP7Eo26wvi5N7A9c6T1A+DrBs1KuZ9
	swM9vregO9gBiDVvQ4/gYp3RzEdqwRaf8faRsCsMqMAz4Kkj7bOmJbRNGMVN1XFrURdWCT
	Oidp7GgS8kJDIhbzITfvlrkEsRT/Pu8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=G78mi6xc;
	spf=pass (imf23.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785869560;
	b=eHe9j9ng6Dl8SSwb7fV6lkRV6RxyPVZ7HDwCgPmntIAdN8SAGLI7kLz0G7i83FInwwSYdO
	XxOSWMT04uz97H+7OBE6mQ6lpzlpRFHGRLhIHI7sscci1Vl5sa8d5ZGYZGKNLcvOvlvxN9
	5scqFxUQdz8vjLMzhEQtVxXN9z2B1AI=
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 674IYI3q2271448
	for <linux-mm@kvack.org>; Tue, 4 Aug 2026 14:52:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=BNbC
	kzyvx9N/XZgbSIGNDSvN3Z/YrabAYl1OWD2SP+8=; b=G78mi6xcsQXFKHaZtMTP
	7FtylFLk1t4NNKdPbdey181DbLVcoXG6IcUSOJHB2ohSG3b1W5EHxqG7QUFThdyk
	8QUB3cNlvoIBHjb2pO9Tu7vpSMIHgOazX6W01NXUOcgJezLbDoG9jxTIKDn2itoL
	1D4HNtq+zGQ5ieTFBktPA1TxjrQ6L+xc4jNstO//DjJ53lRMMtYgGhMEYSDmoBW9
	WJCEvwKsECe1Ara2ZAM26KNEwUibjEzKmwB8RbQ/R6z/MOrQr5QIxeFBOFjk7lWK
	zI13yRZ3YZto9yQtJnocn7PrEc1mBrwg/TIXkGBmBz+658N5eT9NysiCkWKKVP+0
	ZQ==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4fugt12nnb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 04 Aug 2026 14:52:39 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-51c0e702df8so1118471cf.2
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 11:52:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785869559; x=1786474359;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BNbCkzyvx9N/XZgbSIGNDSvN3Z/YrabAYl1OWD2SP+8=;
        b=bKEzf3H6KzH4RM4z6ZZXwvcFBVg6FYfOHt6OyAjbhn3GmeDQtyAeOMLGgIbIiWzevv
         rnX+YNNeHkwVQobQ6eY3mNvKHJ3RkHAt1PnQ8brVyPgrwOrY9Zjyrvwy09j7Ya0vPGg8
         mxjvN6KMDC4J17i517s5SR/A6ZJHCP2MBgXsYDCFD3wOlusZ2FspD7shXstwWGyW2eYU
         xiKzvvtv2NEKENzmaG5oQOda9uAvyRGWeCsnWj1gy2T1mLVp/MCziqO5VQo98qMrwr5V
         yREbKmx6ppPep7skWSQlgGH5x961BWgT/2qCs+sSODHjLt4bpi9JyOUsXyRXcSlG4Ol5
         NQLQ==
X-Forwarded-Encrypted: i=1; AHgh+RrjoESh94/FnoPnW3VGPE09k26MT9ML/3Q24mcC/DtX6vVaODsCiJQTxsAofr4WUS7OrwTM/aeU0g==@kvack.org
X-Gm-Message-State: AOJu0YydyuvRHLH9xhFguc9857Q7Y6cC+cqDNM5gdYNhgjI8fnT+fNYV
	GrE31fxeAV5uvb+SMt+XSdiwhiCxntdCWl65Lpr1+Jo1L+adLQueHR23pj7FhlGobWbeyJrOeqy
	6BjVoeaxLLyJb1JGeF+D1wMEW7Erfp5+YuylChtdcp0ZxQVlaKCQRO0is
X-Gm-Gg: AR+sD12bZnbbHY8PDCJpf7nXpmt6Sfn4K34xS5ETRvirItZUXy3FtU/9/ShGmsT6djA
	NgxcL39XaRjbRTBs08+vVEuvZWG1oDlyXHslNkeFM/LtgYp2rJgtoWRXSALwvB1SPjYKtw+ftvu
	Gu06JhRqT2kIbAUooqGoptb84GRTI9JJGiYSKzdRrN/GNJA/hMOYtFPk5ln0ZB8TV9U3JPFVHVO
	JzOeR6GLf43hn4KfiRewOUoGwdsa2k343wGtA+Ejn0/oSvqEzrT52Dte9/+7CaUJw3GTlEv4KKv
	Y8jzv9HaQl0WHpEz3LF7zKlRi5OWXinDIhQud/r0etYTr8GA9LqEW66HUPi//dlHFteMqT6vJ8j
	51fMCXGhz
X-Received: by 2002:a05:622a:c7:b0:52c:cc14:ff5f with SMTP id d75a77b69052e-52ce61e5923mr11904841cf.38.1785869558968;
        Tue, 04 Aug 2026 11:52:38 -0700 (PDT)
X-Received: by 2002:a05:622a:c7:b0:52c:cc14:ff5f with SMTP id d75a77b69052e-52ce61e5923mr11904201cf.38.1785869558384;
        Tue, 04 Aug 2026 11:52:38 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.77.124])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fec232d7fsm2313275f8f.20.2026.08.04.11.52.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 11:52:37 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 04 Aug 2026 14:52:13 -0400
Subject: [PATCH v2 05/10] ceph: convert ceph_submit_write() to folios
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-remove-wait-on-page-writeback-v2-5-81f0ab065284@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785869541; l=4892;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=ot3FCX4ZCWU57RESMTwlWgtG0MyckOFVRrjXpb8SpwU=;
 b=G0grxSegvtpviy3zKZzUt9DT+v3NJt0MG4J+TlwxUUzGk0MBgrz1JzcFkY376tfuyfavF1yVP
 4stT/JFPkW/DHD+fGwVtZywUw2EuD32vhOm5g0FUOv0qjCb7koZ14a6
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: rNx4Dp8f8rLSzdC4tohdC9bp8KFviUQq
X-Proofpoint-ORIG-GUID: rNx4Dp8f8rLSzdC4tohdC9bp8KFviUQq
X-Authority-Analysis: v=2.4 cv=SOhykuvH c=1 sm=1 tr=0 ts=6a7234f7 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=j1J1DEHOHTVaJYOjuVnKiw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=RfODlEta0-z8xtihUo8A:9 a=QEXdDO2ut3YA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA0MDE1MiBTYWx0ZWRfX2xYVZJiPHf3J
 0CI3N6ScslPAxcchs3wRs1s033Dy+7JM+I+2zueQyJlzS4XFaojswKlIx3/Qfsvqa1CRo1x0nwP
 5QXuF6SVS39EhRgkoVNYf6vIgzeNoTGNUYZlwlJafsntzFWHUqYnTYRxujrLVOqECicfzrUJ4B9
 LaMbuawf9/AeJOjkN/5vGNW+5MgRoYcLlzt2XrsQOHgt8N6OQzWWHYNn/X/WiYqeGjPoNo1kdg7
 1HAmV1gDvDyh8hSQkMB7B3MZwDEnoORH+IZvTlK+Ex/pN/x0m1N87VIeA2JcQSM9guR+aTnK0nK
 FaP3dvtBTX4J9ypDxWNuyn1LhU+QFxrn4CWAf9ttevaS1+7H/ENw65WMeuxPKNeZjB/7WIdU8o5
 4DPEOu1/fPzJ/Cs5bR3ueo2IX7LhAJRf7uSbwfrsxuAXlxPFNWq9oUVtfXyqvPso5uxOqJFSnN4
 KirL9UGgTP3SCAvzB3A==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA0MDE1MiBTYWx0ZWRfXzQ0bQrI1sIL3
 jWbne5aD+fEKqxN/g3bvRHdzJIay/ARK5CD9+43Ugi+/GW4PQM2StsuknFWg5R8z3Z351NkRaAG
 jSz1EqPCeShaFJI/nBUTlHUMEHjXBltA8jWshgxn0EUIQ+sNn+pc
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11865
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=10 phishscore=0 lowpriorityscore=10
 clxscore=1015 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 impostorscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608040152
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 72119140009
X-Stat-Signature: aojtnbq1u4wgpj1srooxwdkw1tkruwab
X-HE-Tag: 1785869560-955164
X-HE-Meta: U2FsdGVkX18SphS/5aIZ/J9Ge8NFiMrRUmg5U065bx6KrJKF2IHKw7OvcnOMH2Vu+sIOtk+iwzg800yHyXlkB2PZ2PmMnrV95pRS8hjIIdXWVVcTTBhELxt/2gxdwnqgHIhpkyVnwILHbmfW5dJefdv79qC0TJHkT1kzGJ+AdfkTge361DPxSM0XUqY5q8Y8TH5lug1PHWI2GTTMKSUbktCNafHtF2DdEJ5XAWs4RMeeZO5NP7WW5Es29/cTd3oZMo7lG/gBoOwcPGwyDdteTOs0kMMB1HBslY93mSbXQmM4fNdZpYCpTojPFid2qC1S7e+F0LSrdS6fIqsZTdqx78JG/yxRSIAf1RW1TNH7U6Qvb0k9bpuM26+u0YvuiRhx7B0tU1rIWV4K8EfjQHvGq2ZPoNSB67q2Zz+7Pv+F+EX8DZFPOTiqXS/+AAPZs5adgEmpwkz9M0mpnw2kkOmdboLftaaVs8i4Fr2pAI0WnmfmKh5qC4HnJ2lNFrU0dAV3Is7ldQZjDjSSn5ZOzNmAm0R6J1aPBsU/vJHNIzXIUf5Ba6UJex5AS2DAg9lcdb3q7SK+GU9Cx8mz5judfFBvF20QzI5m103mDVr+HRz65iBpvrndFvJ4o0taoBrWDuxt75N02u7bg/83Wzv/b9TcpDIzPT21u14opzAdA9dGP4P0XLErUPGJ4FGklV4pyQcrXX98ngZgFihtSvWgnFWeH302LUd4Xi6XOP723BM+8U8j4DXb8uUx93Ya6Ar5VRmH7xS5kY9OZpjeTl0QDC5aBt5cU71re2P4aUutdPZ/EOBH+Q7ybSOwNUenfSWi6maa4Ue3cajzOC/Cs4mKP0Oe+mLa0H7TcwPsrGRVjIk1Vq5V7byMUzc64xRyzEoPK6l7KnNRp4Ygz4TbS5I8Ft4RrIoeOGfFXN1VLe462d07xq5ANMy+Imqzvm44xnrp7Z04WkqKOaXxM+ntsENt4ys
 JPG34gQ9
 PWKzXB1qPDpyEtzPg2FyfM5XoY1fz4i6wEWvty9AJLWChV2d9oN+z0tcL7MazL65mOIZGHXEgXBcvckcW5LXhC1ComDu8CMzN0Gx6D2AjWlb2Qr3qaa+5Adnv6uvjd97M1kQdBvyusse9uEQgF8NFw6KjGeRtWcPBOPGiPJEvrBGEKCSrtRlnDlqFl1fjdtUAodkc3bDBL0UvSwarva0SGhtTzsm4NFMxnIJ6U0UrBX7uaoGlQloSFVh4klwZgYrlP3p2RK4vynbSP+jCm54IRIdgEx8t12HS2X6OfCOTTYnRi4edaBr6m97CX60Va+Jnifr2LhTkQmvzs819NBjd7ZjzyCPWDP9sP/sbUzFs1HwG4D78Ou11yhCzRmxUWgiWD31zAXk5Vaxx7O0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert the request assembly loop and error paths in ceph_submit_write()
to folios. This drops ceph's uses of the set_page_writeback(),
redirty_page_for_writepage(), and unlock_page() compatibility wrappers
in the writeback submission path.

Add ceph_folio_start_fscache(), a folio counterpart of
ceph_set_page_fscache(). The remaining caller of the latter in
write_folio_nounlock() will be converted separately.

In total, this removes nine calls to compound_head() hidden in the
page-based APIs, while adding four explicit ones via page_folio().

Note that get_writepages_data_length() must still be passed the
possibly-bounce folio, not the unwrapped pagecache folio, as it checks
fscrypt_is_bounce_folio() to round encrypted lengths up to the fscrypt
block size.

No functional change.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/ceph/addr.c | 44 ++++++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index c81e9da42df9..a96986c503bf 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -553,6 +553,11 @@ const struct netfs_request_ops ceph_netfs_ops = {
 };
 
 #ifdef CONFIG_CEPH_FSCACHE
+static void ceph_folio_start_fscache(struct folio *folio)
+{
+	folio_start_private_2(folio); /* [DEPRECATED] */
+}
+
 static void ceph_set_page_fscache(struct page *page)
 {
 	folio_start_private_2(page_folio(page)); /* [DEPRECATED] */
@@ -575,6 +580,10 @@ static void ceph_fscache_write_to_cache(struct inode *inode, u64 off, u64 len, b
 			       ceph_fscache_write_terminated, inode, true, caching);
 }
 #else
+static inline void ceph_folio_start_fscache(struct folio *folio)
+{
+}
+
 static inline void ceph_set_page_fscache(struct page *page)
 {
 }
@@ -1436,14 +1445,14 @@ int ceph_submit_write(struct address_space *mapping,
 	struct ceph_client *cl = fsc->client;
 	struct ceph_vino vino = ceph_vino(inode);
 	struct ceph_osd_request *req = NULL;
-	struct page *page = NULL;
+	struct folio *folio = NULL;
 	bool caching = ceph_is_cache_enabled(inode);
 	u64 offset;
 	u64 len;
 	unsigned i;
 
 new_request:
-	offset = ceph_fscrypt_page_offset(ceph_wbc->pages[0]);
+	offset = ceph_fscrypt_folio_offset(page_folio(ceph_wbc->pages[0]));
 	len = ceph_wbc->wsize;
 
 	req = ceph_osdc_new_request(&fsc->client->osdc,
@@ -1467,29 +1476,28 @@ int ceph_submit_write(struct address_space *mapping,
 		BUG_ON(IS_ERR(req));
 	}
 
-	page = ceph_wbc->pages[ceph_wbc->locked_pages - 1];
-	BUG_ON(len < ceph_fscrypt_page_offset(page) + thp_size(page) - offset);
+	folio = page_folio(ceph_wbc->pages[ceph_wbc->locked_pages - 1]);
+	BUG_ON(len < ceph_fscrypt_folio_offset(folio) + folio_size(folio) - offset);
 
 	if (!ceph_inc_osd_stopping_blocker(fsc->mdsc)) {
 		for (i = 0; i < folio_batch_count(&ceph_wbc->fbatch); i++) {
-			struct folio *folio = ceph_wbc->fbatch.folios[i];
+			folio = ceph_wbc->fbatch.folios[i];
 
 			if (!folio)
 				continue;
 
-			page = &folio->page;
-			redirty_page_for_writepage(wbc, page);
-			unlock_page(page);
+			folio_redirty_for_writepage(wbc, folio);
+			folio_unlock(folio);
 		}
 
 		for (i = 0; i < ceph_wbc->locked_pages; i++) {
-			page = ceph_fscrypt_pagecache_page(ceph_wbc->pages[i]);
+			folio = ceph_fscrypt_pagecache_folio(page_folio(ceph_wbc->pages[i]));
 
-			if (!page)
+			if (!folio)
 				continue;
 
-			redirty_page_for_writepage(wbc, page);
-			unlock_page(page);
+			folio_redirty_for_writepage(wbc, folio);
+			folio_unlock(folio);
 		}
 
 		ceph_osdc_put_request(req);
@@ -1506,8 +1514,8 @@ int ceph_submit_write(struct address_space *mapping,
 	for (i = 0; i < ceph_wbc->locked_pages; i++) {
 		u64 cur_offset;
 
-		page = ceph_fscrypt_pagecache_page(ceph_wbc->pages[i]);
-		cur_offset = page_offset(page);
+		folio = ceph_fscrypt_pagecache_folio(page_folio(ceph_wbc->pages[i]));
+		cur_offset = folio_pos(folio);
 
 		/*
 		 * Discontinuity in page range? Ceph can handle that by just passing
@@ -1540,12 +1548,12 @@ int ceph_submit_write(struct address_space *mapping,
 			ceph_wbc->op_idx++;
 		}
 
-		set_page_writeback(page);
+		folio_start_writeback(folio);
 
 		if (caching)
-			ceph_set_page_fscache(page);
+			ceph_folio_start_fscache(folio);
 
-		len += thp_size(page);
+		len += folio_size(folio);
 	}
 
 	ceph_fscache_write_to_cache(inode, offset, len, caching);
@@ -1556,7 +1564,7 @@ int ceph_submit_write(struct address_space *mapping,
 		/* writepages_finish() clears writeback pages
 		 * according to the data length, so make sure
 		 * data length covers all locked pages */
-		u64 min_len = len + 1 - thp_size(page);
+		u64 min_len = len + 1 - folio_size(folio);
 		len = get_writepages_data_length(inode,
 						 page_folio(ceph_wbc->pages[i - 1]),
 						 offset);

-- 
2.39.5


