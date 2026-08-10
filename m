Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3875C5AE49
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 14:21:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22B5B6B00A6; Mon, 10 Aug 2026 10:21:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B4146B00A7; Mon, 10 Aug 2026 10:21:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 055E86B00A9; Mon, 10 Aug 2026 10:21:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CDA746B00A6
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:21:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 590D51201B9
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:21:38 +0000 (UTC)
X-FDA: 85085573076.12.CC2841C
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf06.hostedemail.com (Postfix) with ESMTP id D66D3180012
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:21:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=qjq+35LT;
	spf=pass (imf06.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786371695;
	b=kvxkYKnxsfZ0Rai+B2fJ/zT/3Ui7nSen4zLVZHqxF2PP5H6KU2C7gFyqwG8/pHgPKNvgqF
	sFZEDIbrMYuUKFyi/qEi84rLoP5bNfMMsk46ajf8ZQ9ez2B2PVmnp2N7ORVMV4iFXhk5jO
	hvIdn8w7H6/nvWmASnwjsrod2t/kzrA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=qjq+35LT;
	spf=pass (imf06.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786371695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aLyblFTyCRkRNvHlbjBlieXQYnfG93Mvps8LThXIpPg=;
	b=im2FoiMI5A8cYh+wpO0v7/3wzjf4Qrql6o1BKX67bcFVW4CxZmqhO4mgSvd+zFonp3dnMi
	XiCT1oiWGDVJAWKCfp9KTIpbxHcjmXxjuhHGk7U1jVKaQ7BxNwpYf/hYTRgN/89wwp+Wt0
	WE+uANX2Vx7erx+En4+CnSmDbXE2/io=
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67ACaFnI3010838
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:21:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=aLyb
	lFTyCRkRNvHlbjBlieXQYnfG93Mvps8LThXIpPg=; b=qjq+35LTpjf9J2w6F2hB
	vecXljYKiBnAzD5aenYJHzWhsNXgP9xHEliMM9O37gGKVD1vf/Se7su7wn2XbkLZ
	rD2Jym0BqslG5QgoaHVZ61V0B0C8zhmW1wU+QrjXQYIDVxiVIqKgSDWpi/1WUXHy
	ywTqc3FxNJY4ahiAjXPHYZJOy9kupo/J0IxL1BEaXBInVqdm6ONnvUYHFuTpUBSM
	bfA8k5gOrjl2wE7RFonKnU2MENdTTsZEevpboN2Rq7OQug4eKv7jl7Smq6U+kCzG
	b8RYvB92ovczaQwSBwLkIJDnlZxH21dFvqcBi4PRdU3TYYLfd7kGAt4/+bWKd9of
	HQ==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4fy0rkudg5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:21:34 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-52cd0374265so38076801cf.1
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 07:21:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786371694; x=1786976494;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aLyblFTyCRkRNvHlbjBlieXQYnfG93Mvps8LThXIpPg=;
        b=TD4EaiRzmR7S7/vVC2eNbYux0ZpOFW5FakrnA35T2/raQH/N95A50azHQ7Vlfi+h8V
         TdiuUIRH1Rz/rhfNTBHg0Zsujcca/ovpXy1gF6Px3cOQl1tKQUuSgr/WBsym4Dvftw8g
         qzaYTZERk8c12qXr3oaXWok1njulyG4k6QZeMy3BYEtAOzAaV8zmjW47SEqNFnuO/u31
         1OOa6WRY6j+U4gLkla6htj2QTawFKi02tBQQRt9lUoiGFkAOKdCDbiIwDdVOxt5xM6nP
         jD+JoJiIi4/rYJxZlbWTdh0bojvpHyzE1TQj03cP/N0UzVCagQFwHY92ckReMpSg4+YF
         My/w==
X-Forwarded-Encrypted: i=1; AHgh+RoTqDcwuqrdznAdcKof7Osw7akC+OVgF2NGL+G47iBbH2jAzfO59L2i3UGJUxFLwj8PkUxdhcGKlQ==@kvack.org
X-Gm-Message-State: AOJu0YyNBA5CafMf7Ko7pQ6TgXFMR8C6ssTkwKcd1JpJ8imkIzsqFxEu
	yVHID1fFJhTyevi6MMehIi7q8soDv7QpMedvX7EgQDa6ZxCBqPna7EHVExyFwxUmDZkdccy4C5k
	O2X8L1qDdMfZpzjYyqsQdkiETnK4FHci/mxeYiBRaDxPr4SNz
X-Gm-Gg: AR+sD114GfwjtASaY9qR0FWRIO9rtHUceVd3Ww+dW4vNhYXb7B2CH0XynSDVjJbpd0a
	RoB4Gob7wb6iuUE3A3cfQErnk9xD7x1r1XIcmSiljsTDt/Cv918mtE9IV8FMZf0cE7jurEQyMNe
	cNNelwqDzmzDrVgHPv2hEGixTLInuic3ry61Aofw2SAY9aT1hSfT88Snl8O+j44ajKj3OFVCKzm
	UF9GW0CSW9PSMi+me2SGmHqHXzk43IuKjLOymqfFV2fcORw5wR2nNMnFJ3qqngMGkdta19TeH7O
	3iSS9QZboI08a1IUpqdaXll1usKbS5eR5IABz8+jkwk+eIPTm+lhWe8RGsktbmWXYAPddfBbu2x
	sHkeAfJLh
X-Received: by 2002:ac8:6f0f:0:b0:528:3ae6:14d6 with SMTP id d75a77b69052e-52d20a50232mr221693431cf.36.1786371694410;
        Mon, 10 Aug 2026 07:21:34 -0700 (PDT)
X-Received: by 2002:ac8:6f0f:0:b0:528:3ae6:14d6 with SMTP id d75a77b69052e-52d20a50232mr221692471cf.36.1786371693979;
        Mon, 10 Aug 2026 07:21:33 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.77.155])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48002145589sm37383983f8f.1.2026.08.10.07.21.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 07:21:33 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 10 Aug 2026 10:20:22 -0400
Subject: [PATCH v3 11/12] ceph: remove ceph_fscrypt_pagecache_page() and
 ceph_fscrypt_page_offset()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260810-remove-wait-on-page-writeback-v3-11-dd7531704f26@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786371655; l=1581;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=eEBEQRS44uRWq+68HnHuSJkJWcepL1mJ0SSpfrhNU80=;
 b=igitKHwKICJe64WLGnQtJ7juQTX89Q1kNusDsmkgFURVamzkBrRPYcM6WFXlcOnjVGCWu9jAc
 HjyznGVPVaGAnp/iTFafK7Se035x+xGTYGst6RxsqK2bKINK75nE3GU
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDEyMyBTYWx0ZWRfXzEWxGy+aOAn9
 5rLPnVPW4gfVsV75c+GnQVqrn03wceEilUWob57CcTN0d4nt4xvD+BXPJYlUfEkNljZQBFKpvu2
 ZRiKPDGWUMmvcWAtZkLeb9Y240M2r5aqJ5yLfpt2IKniov3zlmCcewgCjzBDvbXT5y7EI6OheeG
 epqG/uHhckHfpEze+8wwbaBkW6ZdimYEkqZt2UNP5SuOno9oVivko0ZWKouC1yqq0bXc9/07yeS
 Yg/LT41ItUsvqUQqyLjBCEiuEc7KVPKF1wV75/un87CfI1nULjkXTXAvvDxcrKlsLPa5Kpd+5si
 SPqTNdHvA9aTndEOEs9s12xjeikj5ybMKPKWDQ+JKdMaK+Yftp0QjmISzt/2r8t5O9hmDFwLvwO
 Z17QfDBkktpO/Z64cYy0yq6wl4biGDHckQ24tm9ywMzRXgabZktQjd5k0HnZYxGA7prtdXZUznd
 8gdvREncXIhQ7Oy+Hkg==
X-Proofpoint-GUID: vdvZnlzkM5u5AHo5ougq6IIMaDxefdzt
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDEyMyBTYWx0ZWRfX6QdW7chzHNZW
 5zioDHkjjTtT9+aTjEXEzTWLE3gATcUvErHL8MPRGuZ+vKF9ChTJfgg+w60YQSw6FnrvM9Gmik0
 NGO6ZglZSUkagAD7V2qr0LmKXY4cIrfHR098AnD42JLJXrZhtvN4
X-Proofpoint-ORIG-GUID: vdvZnlzkM5u5AHo5ougq6IIMaDxefdzt
X-Authority-Analysis: v=2.4 cv=WPlPmHsR c=1 sm=1 tr=0 ts=6a79de6e cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=zHmcO6jMd5r4EZ4U0P0LQg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=jfg2DRd2ap2c96lsYj8A:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11870
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 priorityscore=1501 spamscore=0 adultscore=0
 bulkscore=10 impostorscore=10 malwarescore=0 phishscore=0 lowpriorityscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608100123
X-Rspamd-Queue-Id: D66D3180012
X-Stat-Signature: b6frwstocw5isbi7oug4cwcwdhknpou5
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786371695-229436
X-HE-Meta: U2FsdGVkX19aEI8AbJ93QtPt7VHpZ5E70ot1Ja22b/SAhJwhbIRiCDGk9n/xmljuvRDrmW5iBJQ9E4stL804ydMLcp+F6VmqCysKQXAu2wz3ToMLAk16jpZMhYjEupNXSGAr+wetAiDFRiLPvhWo6oUmEpKT/hGuXV5QnE1qXaF4jWuzeTw+BnIq7nENFlWDAfueWYN29lLiNC4FLXCV5A0ecq7k0voJeBaELWbo/U+y6ExyDZRzgcOPK+iZafEMyHX5Clwha4MhALait5VnuDjMO/ZPRqv3qw9VRKoWl8bXEZSVBMVve/UDmoOrRwtgwsERAUaeZb3wJS2dJhToOZaW65SzTus8+qq7EUK+DrrWqR96xm3KsFJ05mIvOJBHM0YV2VzPIheF/9gRa0284YcuZGQp8USUCcwFMbgXd65uwtGoWnjrMYGUN2W55OrCkz/9IKcy57L4546F1EYhdnVkN4jMq/MdQuTPJ5odtxH9L/Cve8S0yW2njXkXka5msW2y13oOdCJ18CJVYpbPrRZO/nD19MOXIoUE4wTGEEmhSEaDu0HD5IzlX82m9z92DNHLAeFF00mXd3ko/9NDEFpqowjkzEtHGxa7hKj2s1NLjKEZiMlBwZypaSSHp3X7SVIB+/NbRu9npKHGQNyAGFUxuXaWJbrT4gF4nt9/AnHTeyQLJjiBg9ANXcbe+8fcoGkOh0RBYDQy2LqhCbUTqP6duWrMH97tzbCUVlQbgvlty6bvCcxyD85c6mnNMeS4QkbTIA0rUX3FmiNoNpifRkRc8mYHUTmOS24cLXwv0nqkuEc591rXkKW0pq2n5jKCS3GD5/wV4kQ9T1+koxm7u3f+5v/cXRY8Up4MamnSDeJe4o/I48hTmsuaMMXP05CLLjj1OdeUMdrlj8BY+Djl/cIMVjezL0/jhQhdxAhZ5Y3yMN6sBpLVC2B/zgZJy692KrTL5Cq27w8TNfIPfX4
 uIksSBKO
 6iFwlDR5FJyT9k6Cd8ioByBFsEW8bBhXOldEfUkTt0GaztnHa/vxDB8CMCbcc1iMxcuhydj99I/Vs3D9aaw7joeYrnZq6NGFv4N2fNHPLZ9a8PjhDv2Zuz0ERXJWKKdu7ev6fcqmSYf4yFH0m0ZC+ZjrKh6z3n4TQIe/m7ODLtZPDDuMvMoXRSjjQorPDOlcTOVi9pODsgTpayNTPPF/XiDNjuusEkkM91YGkVjfXep7BWFekA0Kh1HyZmjJkfoPiKySPQlsgRp4R1hQ7b/V6Zku/TsdszZvEyMhcMyVbdWTf3h26qjyFWYQ6YRcvfgJqloRU8OdREUqoTSCI3ojyi8CY/ue8RT7LOq99BRWYJirtXuRTjHskBh2hQpaxiYbuAmFe6b0qKIUKitq2j7Gp1CwswV9+ROsHJLlsUCGQ8boKtgv3zdx6WqCeui43n4NHhq8n4EsGvCUzRJyeGdIxPftH6/ZKxOgaeWR6F+E38+EJUbGHElG/qyG/vlt2ebA+hVi9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All callers have been converted to the folio equivalents, so remove
these unused helpers. This also removes a use of page_offset().

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/ceph/crypto.h | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
index 948c8b5dca06..d199dc8410fe 100644
--- a/fs/ceph/crypto.h
+++ b/fs/ceph/crypto.h
@@ -157,11 +157,6 @@ int ceph_fscrypt_decrypt_extents(struct inode *inode, struct page **page,
 int ceph_fscrypt_encrypt_pages(struct inode *inode, struct page **page, u64 off,
 			       int len);
 
-static inline struct page *ceph_fscrypt_pagecache_page(struct page *page)
-{
-	return fscrypt_is_bounce_page(page) ? fscrypt_pagecache_page(page) : page;
-}
-
 static inline struct folio *ceph_fscrypt_pagecache_folio(struct folio *folio)
 {
 	return fscrypt_is_bounce_folio(folio) ? fscrypt_pagecache_folio(folio) : folio;
@@ -263,22 +258,12 @@ static inline int ceph_fscrypt_encrypt_pages(struct inode *inode,
 	return 0;
 }
 
-static inline struct page *ceph_fscrypt_pagecache_page(struct page *page)
-{
-	return page;
-}
-
 static inline struct folio *ceph_fscrypt_pagecache_folio(struct folio *folio)
 {
 	return folio;
 }
 #endif /* CONFIG_FS_ENCRYPTION */
 
-static inline loff_t ceph_fscrypt_page_offset(struct page *page)
-{
-	return page_offset(ceph_fscrypt_pagecache_page(page));
-}
-
 static inline loff_t ceph_fscrypt_folio_offset(struct folio *folio)
 {
 	return folio_pos(ceph_fscrypt_pagecache_folio(folio));

-- 
2.39.5


