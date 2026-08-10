Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EDAAC5B56A
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 14:21:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49B786B00A1; Mon, 10 Aug 2026 10:21:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44C6C6B00A2; Mon, 10 Aug 2026 10:21:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 362066B00A3; Mon, 10 Aug 2026 10:21:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1327C6B00A1
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:21:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9DF4A401B6
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:21:29 +0000 (UTC)
X-FDA: 85085572698.23.1283887
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf08.hostedemail.com (Postfix) with ESMTP id EED09160008
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:21:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="dLmpK/OL";
	spf=pass (imf08.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786371687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IVyh2I0xknPiazMq45DWF306MKF484odlddz5jbEe2k=;
	b=wZEyY4lTTpq5EEWXf6y4ToGtHglQpW/acD+LkCRnTxFe9IBcXs0OVVQ7wKI9JV/RuTMz9w
	8uWh5D9wBy2fIZCxyoaTRiHLnyN7O6naS0fbmhiedUpJiSB5tkxtxn+bZpH6csU/jSYUUP
	1hbLYOZihpPyawmZu/xxy2kya73wTmw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786371687;
	b=kMM/sffPeLGg25Cd9K/dAY++ZMgsa5BGNiNn1Ug6e6+JYredj2pIptHkOXziGRT68FIgfO
	6fdZ2mxICTiB7/CcPUlstbhYay9QHcOEOblOj6JZi1cqn42ZT/HwE8Bf7EBTq/ND5E/e1a
	H3gNxK4OO6xXHbyvJkLoK4Pzf5NJIMc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="dLmpK/OL";
	spf=pass (imf08.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67ACbNnd3845103
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:21:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=IVyh
	2I0xknPiazMq45DWF306MKF484odlddz5jbEe2k=; b=dLmpK/OLQz8CU/TbBRcD
	wffnn2Mb6OYdhpCnoHsIMBQCQxCM2lOU95CMLabWmepCtZvxKZAhrqWQh14IpFyx
	zuMHFDaY1FvGUWkLbUOavcfk2cvFAdJsSGZGuy4wGxHZYk8PuY0HEdt5+pAv/zYI
	M77KIk9rNd6/lpD9p8mUMcv9ZqdeJnMahAHeJgkPYsqr8TqEDhVdnWVN1AxT5Wqn
	AId7tMIW3zmi5qNzbCmq+0Van4AMFJuZ2a82w3pU6fsDl7cBmHwlHKVGENOqvo0m
	rEQoiWjLBF3P7s84IxiauMhiMiJpt7yb9IW58R3+v/vu6liLLu78R69CEDr4FqW5
	Tw==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fxyb9bkum-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:21:25 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-5174a23afcbso23008601cf.3
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 07:21:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786371685; x=1786976485;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IVyh2I0xknPiazMq45DWF306MKF484odlddz5jbEe2k=;
        b=hNZ0ceVlqeKi5dFnMp1HkK8Hu9eIzEHi4jr0jDhxx5NXHTaqY7Y4AAfng3popAOHL2
         pT9CUzOSKLb7DlM0wJmmYfoIvwxu9rHpsbc0lEiJoKnOipwcPeaKyEuf21NllE7Pl6MA
         7HWrabwN95xpDte71BexEGJyyj/5IY+NX/Z0hiDs9wuSlR9Vl+Dd/NsKZ+svybkj1mQm
         w7oV1vm2N0Awdft3WZO6tJLb4s3JDYtsFMmn15U035YkaLOeETfZV9aleA4jaSeKIjj9
         EdYmnnp/5rCM9yudXK/gXCjDPTKjhBbq2s+xYFvdh9IbxrowPps+uc/sVImCziSXGq6q
         cJ5Q==
X-Forwarded-Encrypted: i=1; AHgh+RrAVGWYSmx+EGgn9BB8JazDxorr96GIOJdaQ/Lh6IK04F5SkubkGyC/igIsDfKYjxzV6x5a1OpLaw==@kvack.org
X-Gm-Message-State: AOJu0YwtJ3YPe93mXyEPQFeNKuQrP8H5hyulHGW4VxqY1j5CAQZveuLA
	wMOrxCWavk6HPrwDZPgdK3kPVHo3dAgCuDNbqJy/8U4o+xxAhHCG+J0NdrMys9xEPFIpBgpXijM
	SaE55Z5s8OHgS+imu7hJAXI2gV4aXXmtCtcnvIJeJENdo6cFm
X-Gm-Gg: AR+sD12d5MdOVxGOiAIhu5h9UYfDPoL+rpXhlqiVLTIMO5S9Lzt6pP0k5PwxVnl7wEE
	vOWjDm9QMRtfi8/rJlFA/EWZXxXYAFSAMgtS9R05+OxiwVAgPpFByEVF52Fiyud7dqlxm36H2Uy
	xqxuR2CwD2wGsO6yml2K6jTH4tmJucArGSDeXDVhn1L1q9bsQgAv7wZJtDPNHjbo0CqnlJkC/93
	WTmP88GHFuvacxzINWTgVIoLhQBl46pImYL0Z7ixy0XNBnjee7OjQQbEIQw2Nb2MpLo1Xky1wbp
	t4HregnspCztdpWe/sDn4Z4Zppy3bfIM3HS+Cq2qX/ITGkL60jQjh8vVgJA1HWDHJCWye5qSMo3
	FTwrpvwnv
X-Received: by 2002:a05:622a:c8c:b0:51c:2340:bbdb with SMTP id d75a77b69052e-52d18fd59d2mr274381401cf.26.1786371684854;
        Mon, 10 Aug 2026 07:21:24 -0700 (PDT)
X-Received: by 2002:a05:622a:c8c:b0:51c:2340:bbdb with SMTP id d75a77b69052e-52d18fd59d2mr274380581cf.26.1786371684393;
        Mon, 10 Aug 2026 07:21:24 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.77.155])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48002145589sm37383983f8f.1.2026.08.10.07.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 07:21:23 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 10 Aug 2026 10:20:19 -0400
Subject: [PATCH v3 08/12] mm: remove thp_size() and thp_order()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260810-remove-wait-on-page-writeback-v3-8-dd7531704f26@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786371655; l=1262;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=GT6KsnFlFKH28GmoGfMAppH64tmtgEJSjAsPDSSVHww=;
 b=byVHWSYhAVOyPGElt43i+q4xX+4IztrMsjuV0Aj4ZkDgjduVsEwlE1w6aC03ZvxffCRtw3I34
 YJP87fwzSOrBu/eta67oEU9hFHy2ow571dm4QIVUtQyq6PukSc9Oav4
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=QKxYgALL c=1 sm=1 tr=0 ts=6a79de65 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=zHmcO6jMd5r4EZ4U0P0LQg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=VwQbUJbxAAAA:8 a=5wpFShScvf9Uq2YMFBAA:9 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-GUID: N2MEk4bZQwkSxMcByOnpFsDJ0axIZJ44
X-Proofpoint-ORIG-GUID: N2MEk4bZQwkSxMcByOnpFsDJ0axIZJ44
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDEyMyBTYWx0ZWRfX8mFKmp6Bib5l
 E88xJf8XAOoaVhynCEDLV8kqp/3vkX+2gx6Nfau0lhmesd3a7mAoFX8XmVS5Depc/0PbMcjkhgD
 XeC89bIV7rGIxESQgsuD+MhPNEnQPZvNaf3A3GFGtyA/8Wv4lkSK3o1k1qvMKnhagqOpGsTgMNd
 XfhtO0SRywVLVcHcJ3BZIAlSkHMBHZCiULAui8dVwNwNvpgT6GzYbyAS5tGvbLFaMIs5f/6hOBg
 r0JtJcS5jmC0dqnjUklQX7UJuNvotQzGQmGMqNxB9pWH0O0LKR6/rIwZv4c838rLGF5kmzpGNYt
 lFi78C1vRBrD7h2oJHuaHT1razJsNbof12cRuBF8MlXCyOXaE7nx2Ts9jIupePJuFq6hihGHYDQ
 TWbKzu8L9oVeV6a4Go16m3/G9hhpmIRCTLS8MJ4kUhiWXgT6WMkTD3FvivB/yqgEUcRO2kgItDg
 Qz1AsDplYgTYy2gbyEw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDEyMyBTYWx0ZWRfX354CfPUwniH1
 H+0or2iQRtjE3raYzMi6AFcqDg0J13CB3k/dDszCUoJ67TROroGDO2C7hMZ8/hxd/Ij1wQNc/MK
 FoTS5ve2aFX8Jhfle19S2A9vz2vWsiRkri0CfsnuLrtOC1tEGLM0
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11870
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 malwarescore=0 lowpriorityscore=10
 clxscore=1015 impostorscore=10 adultscore=0 suspectscore=0 phishscore=0
 bulkscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608100123
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EED09160008
X-Stat-Signature: 9y14cica4wwee8x4d7bbr3ao5yux99g8
X-Rspam-User: 
X-HE-Tag: 1786371686-791790
X-HE-Meta: U2FsdGVkX187GN/wZz9DojtT41+FLMrS0yDJNoVoRzeqVbU2oZa4/6UuO2AW59xvROy4/9g7JXCYoP1AGEZncOmOqdlkAO3SHL/dEWOVAqtHF0maTCYRmKLQVXfOeYlUT81yWSTaYG8hN2mT+4vUE/h50mpLbyVae0NAVtPO6iKXtKVE9+sYfvkqIgPWNhuac2fk03HYlTLQ7gJ5QwvHdUCE2b+Hn/JK2mRG11CbjwFewJxo1wDUJ9uUUmEvk4S+OOojlU6bOUb9DVlQhgVxoKtkxUdqYOt8IUUK0+Cf3vIIPQZqFQCT7xqfzWGbsr6QyPE6uYRhApKug3UPjE6a1iVas1Y3c7aJNH+ELDbym6OEqVV3ymKx7k7Ex0zJECu8/EtNDKN/2W+u1fegCLLju+2bL1Etgerq56aOueAQpGj+JPNl2+eIaYq/bkRovp5Ao06QKMvWTjEICLfU4x33a69OFqWhwDVHMSvq38FibPrsTfeO1t/mA1O5nSArJmwIGnrJ2rAYblNXm1HClpNDBU+tmVRGlrSaaiLq1Zx85j28K0CinuByQukgY9PNBOG/TPBCRFrFgobur2O9Ti1K8Vp0hk6Zmy/y3XxfAOWdzqABwVVnVMCgyu077AYP8J08j+bLqvOkcsTqXtr52XeGfzWQt5898IbyA7y36kl7yx+qjutm+F1oZwM8uPhsLVz+t3m4w/FIHhGH4dwsX2fnyOt2RBzPuHB6scJOzvRihNOgDVNG2DrvxTp9pHg/TtB/eQM4kFcVNUxmb66zc6Q1tvyXWRrYuoFain8im1owgVJOiCeArg1CMI1u32jtEbvksQJ5HKK+cTW2fQkIR/KD3fm8V9qxNDSvSmYDwjQzZ/Q3MCNKSDkom11YdE38IYsFxOlLh1hma/EGdp+FBvmVNR1NAgwqtzOMnfYU//mAdB7l6bV/EZR5dtaZ9/WEmybypTdFKP+nI+dF8pCpLaF
 uEieDbZN
 xe8xHjRZ8k+ehzcNoVyzPtKpqn5Vw5LoRRKcfaHpsTYdSXkqekL+sVECHIh3XZB4BY/tb3elB2yvvwIigwYU9BFZV1516qw/AHhlF0vmDUw5aK6cGD9wAEPVnubYM7FWzoS+110nWyc4JNlnZyvMxGEPOWDH3QUJ4BE3UKHOKsQv7ZxBBHpPyHr9EEjuFrkodXv9sX0U1+GrULO1nN5OTSk0Q3aYRxKp/btFT9KRNeopvWLujcE12IZE1rlLq7aio3+1Iq+Mk1VfHiDloEfhrRFQVJobJuzARhBDknptiQmGX4dAk0rksujVUudv6n5UFyDNyKRchV2lksTfOTZ4F7vndUnIkI7UBE/GuipMrvpPB4HSLwFMQUlJvaCbQUHSL9ngmq9hSuref4q45tNJHjuMSdFN+P4aoJhLI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The last callers of thp_size() have been converted to folio_size(), and
thp_order()'s only remaining user was thp_size() itself, so remove
both.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/mm.h | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 485df9c2dbdd..48e821454ca0 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1966,27 +1966,6 @@ static inline unsigned int page_shift(struct page *page)
 	return PAGE_SHIFT + compound_order(page);
 }
 
-/**
- * thp_order - Order of a transparent huge page.
- * @page: Head page of a transparent huge page.
- */
-static inline unsigned int thp_order(struct page *page)
-{
-	VM_BUG_ON_PGFLAGS(PageTail(page), page);
-	return compound_order(page);
-}
-
-/**
- * thp_size - Size of a transparent huge page.
- * @page: Head page of a transparent huge page.
- *
- * Return: Number of bytes in this page.
- */
-static inline unsigned long thp_size(struct page *page)
-{
-	return PAGE_SIZE << thp_order(page);
-}
-
 #ifdef CONFIG_MMU
 /*
  * Do pte_mkwrite, but only if the vma says VM_WRITE.  We do this when

-- 
2.39.5


