Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41E1CC5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 19:15:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 852656B0859; Mon, 17 Aug 2026 15:15:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82A656B085A; Mon, 17 Aug 2026 15:15:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7408C6B085C; Mon, 17 Aug 2026 15:15:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3759F6B0859
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:15:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BF1941C1AF6
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 19:15:43 +0000 (UTC)
X-FDA: 85111715766.08.D6F9CE4
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4CA0640004
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 19:15:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=aQ2iaOWu;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="G9M7V2l/";
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf11.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786994141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GWf7W7btzDJ2DedURkbQJEOrdsj9qNB2OmbEzhz1xwo=;
	b=ICEj2GW+saJmzRFOyinO9QnulJhW1qpj/Yg7p6vC0q5iPEtp9a1yvQVnFYAM/Wse2GMEKV
	FIyCMWhH7reAId57JFiNKa/77WTm1dOUFGVcD1gKkf7/CdGrz0lIfOohtXojWVHa2BdQMw
	CIVk4oyYr99tPOYePyar9SNhDoErLQ4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=aQ2iaOWu;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="G9M7V2l/";
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf11.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786994141;
	b=wL76dUn6ofFUCyWh38tx3IXDSluQqRGAiqPaH7gOTezfBh7al//cvSRFVxYKIAFxDRzMbG
	R3SUEKxfiPLJN8TiCXwsQFFMGdYxTaut1ykA10kCdBl+Oadw0z/AsRYvcDAmey3P75Ub5Q
	xmpa0vr/MHCvJDozvR1raWg3IzQVY5Y=
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HIYlEC3617257
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:15:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=GWf7
	W7btzDJ2DedURkbQJEOrdsj9qNB2OmbEzhz1xwo=; b=aQ2iaOWu/u9y5uDpTyJk
	mg63Q43oqYRBLEtM3bWQdOMGQBnMy/ewC6GuzPhp4gssH294S97auQcmFiFDjGWv
	I6MHFNLOkvfeRi8xBXTzbgU+S34m96INXoYVTJtqIKpvMFbqELHEM04yUPhHn1Q8
	A/R4xZyBdvl6tzrqDd89Hj83LJSAckC08fdZ5KW6RxoY9mzgRGhGQwLbdKqmyJY+
	kOvaQsdXalqU5ECHyfxCLy45SrMcZe7hLbtkcYQhaKSUcMWsaH/u09BAgjlxxAi0
	0GJxkbF08m7yAvyuL0AA7bPuGZW8+sL5md58v10GAM/+CcXWDe/BZAmvvr/kehSY
	pA==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4g3kbte2qr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:15:40 -0400 (EDT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-936aa34873bso343721285a.3
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1786994140; x=1787598940; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GWf7W7btzDJ2DedURkbQJEOrdsj9qNB2OmbEzhz1xwo=;
        b=G9M7V2l/FbHa+2zvSj7utMoaBEU6AqzZRqeVLSPTK76lvRaFvrmX8wa+rf3/Y38DVt
         DDcV75qQNkGZ6AM4VmQYdlNNRN10xCx1pP/tZvKEaN9oJHSCD8o2Nl6xxSKFstkDoItQ
         IQejgDoO45X/FmaVuk5ES8lrj0XE1B4hU9kqR9mR4AEYcwWg+5Td7cFeS+pnGH1CNr6B
         LIgH5BqKkzrOJnwrniaFT6MaiS9kCZSyOS3p0sUSsn4aI/sm1rSiZ0OIolSKax9MiIkJ
         CmX6FGA0heVm/PpGuJII2u1zA6TRzYdhYbXE1L1WkKeNtmf+lvk/lm53mDKsYyHY/89l
         jg/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786994140; x=1787598940;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GWf7W7btzDJ2DedURkbQJEOrdsj9qNB2OmbEzhz1xwo=;
        b=WsiorClfj17NOqUy2+P88K8gl+AEpEJsS7ubYcCKWVJkTJfS5wxfkAkKsgpA5IoxnG
         9Xz8mfCu9Eoqv3+2qiF8Rbk3pkyFMP3G9KLW4Gm2J/aVCkjyUTGyK52Rjv0E9+rLNUJ0
         hrgrrVslws8RJpxHoTp3FiELz2UR1Zqo6SjYxCK8z0138ki1dGWtwyUpU/YHTw7T66JO
         u2NvAY7MA6qIbepMV12sCdmk+LrZRQWLGzPKeHtE2RpFZCAo7mmgplIiUKJW+ZhD1/xb
         kQR4wYgDl46l+C731BkC82cwcaK+/0u2/Juoo175SfqwmdPuhN6YzB//PdNym5RpsG8C
         l5ag==
X-Forwarded-Encrypted: i=1; AHgh+Rojx/Pv7AUT9DZs9Z9qv/QnM4JxXGwy3ve73U3zZrGhkGZadzMs0sR6HOZMiHQCSKyuFTl0c69yUQ==@kvack.org
X-Gm-Message-State: AOJu0YzdL2S7uWmJ0bdgHL6ZDz9+OJJg9u9oF7YZcVLWgDewyjv7Hajq
	gqf2DLl/nju06/rEZFUTrAboGl95L2csHAwVGZz/s74ew2gm/b8LxyMT7QkU2QqlGntJzYbgEw0
	UJ4Bc2gPn4lhzk8+KxTI3wHoM+oh3zo8Oa77LWHEoXUp0J/X0
X-Gm-Gg: AR+sD117uTzMvIOIu0YBnrzkVUHfLHTn9n+CyzDHFYF+niFIVMCcqD8lA7Uy5yt4Sp0
	UxKAYOoZSdc/Pep0a7jFIibCt7ZRAUhq0lnm3RbeouPw4pQZjJSeVOB1gdh8BXpAIsGEIc127Rc
	FUz/W53S4zhGMMKwqtXSDOi9wEsKKVBa3jj5FPQMp9iAE43moqPtCzIzaPWZqgo41EPeHC0ZdrR
	p/sh4gSlEFt/baFr1nj0wFy+Diikhper4g3p0t1ld0uQ8AHKK8HGhhBcRuOjC+40lKPr0zVzZwR
	KprAuFBS9ymaK9YxEVxO29u6g24TqCTLFeXbfC/xoHVHD68I4gjcKEOvC+hlWM0VmbPc+QWPmrL
	9uFdkHgLV
X-Received: by 2002:a05:620a:a18a:20b0:936:31c9:6c57 with SMTP id af79cd13be357-936d2145af8mr2163068285a.7.1786994139714;
        Mon, 17 Aug 2026 12:15:39 -0700 (PDT)
X-Received: by 2002:a05:620a:a18a:20b0:936:31c9:6c57 with SMTP id af79cd13be357-936d2145af8mr2163060885a.7.1786994139218;
        Mon, 17 Aug 2026 12:15:39 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.67.107])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499961098cdsm194692085e9.6.2026.08.17.12.15.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 12:15:38 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 17 Aug 2026 14:55:23 -0400
Subject: [PATCH v4 07/10] ceph: remove page remnants from
 write_folio_nounlock()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-remove-wait-on-page-writeback-v4-7-0e5e53d47eb0@columbia.edu>
References: <20260817-remove-wait-on-page-writeback-v4-0-0e5e53d47eb0@columbia.edu>
In-Reply-To: <20260817-remove-wait-on-page-writeback-v4-0-0e5e53d47eb0@columbia.edu>
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
        Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786992937; l=2482;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=Py9gUMYDLXU7l1TUEJ0L6HzvJXCNw6ptCakw/+crsQc=;
 b=KnKavewnMLt7GfgB/b9gNamxCvAKCVliqz/Nl42GLPbGPgNz4HqeqCOPrXbTI4+qdxkMA50j4
 O4CmW/Hz5AbBwj/z9IrdWPBS9SXjRb5arFT/T2ZJwzAs+6gmLmK7RuD
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: L-5XsV7v-6qqumC4Jgfpi6Giaae2XvSg
X-Authority-Analysis: v=2.4 cv=McdcfZ/f c=1 sm=1 tr=0 ts=6a835ddc cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=+gpNN1aRt999K7yrv1sWlQ==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22
 a=vHg950cVU3XL5QtsloQA:9 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDE0NyBTYWx0ZWRfX7X9Zk9P6zwAw
 bI0XMsoscpaXZ0VQeJiGVeHYUgqR2Njwtbcjo2ujiwusG3Va5f/WmTENZbFCzVkxXtsp2wGWPYe
 V9Z5Yih+wnybcbAC5ZPe9jpw6S/gQSV8HaZzVwpR4xHB1AVrP7yZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDE0NyBTYWx0ZWRfXyC6cpa+zJ9ni
 dEJc3TKz83WKJRA5Ylwg+gMHUBdfPcndZG9Bso3Hll/QQeEntH1Qgy2qDWm+n211uNWatzQ4kDP
 Qnuf71594NpwA7qQ4f53Qm0PiiJoRCMqEPSCyHWp79F6U7d36fufJltC2cQh7dBI3IQUDpS2wPm
 kt51I0OkrqtKQU5ip/H4dxuPn8kigFLq1+o4boVzfGsbPEkbdTVAuUSG2Y/KHR7Se0d0ZLdDzv7
 0cJXOqB4fPTMezR2bdMsk4BgC1sx8RQLQfUgLZJLUOAnsFR18IF2Mg6otDbOd2LkJfvlF4ybl/+
 VoKa9viTd8k4Tp2Lds2srKWJjpnT5IrKxAVMkBSOpyAu9RSIfN280ADr3utmttlJY8ZgUo0L0pm
 0V7Q+d3iJSdIxEzDvSiqfvU2C0ibm4e0e2/tFpz22eysOeznjKyQxMpRAtQnoYoxo9xL25+f4wy
 B0BAo28sqNaSTM5/WRA==
X-Proofpoint-GUID: L-5XsV7v-6qqumC4Jgfpi6Giaae2XvSg
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11878
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 spamscore=0 malwarescore=0 suspectscore=0 bulkscore=10
 lowpriorityscore=10 clxscore=1015 adultscore=0 priorityscore=1501
 impostorscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608170147
X-Rspamd-Queue-Id: 4CA0640004
X-Stat-Signature: pn5ps3ixcpguy6susc3jeps6k5zfeux5
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786994141-978736
X-HE-Meta: U2FsdGVkX18ObYsRhahOFA7KvSKuHKtk8IAmm6ncqUJe4qaHLvMHHBM+X+SyzvsLyYY7QNyadqFSgoc0O7aF6iH8nEIhpcoJNfBR/i8FgGQLV86lNiyOmvEcMiPWt4az2LpS0NDvyADH4SKrXQC3g3odut8WXxoqj66hkFs9abOVHarD/XRu2S8jv04Bc/dZ02twnTKdvsrnQpQ1e0pSswud+C7iW0g02gLNuN4kekhPYRIwIP+Oi0V/uUSCLud4YRaE/mKyR/eh7ebp7FbM7BY8hWt2BR7m6S8tv08+ElFUTgADigTXnqCZXluryl0XUV2uzEegmhRrKf4ZStQXe9KjuM5s08Autsuvc04ecpLDjIULvOAFqxEBOjdkBixAhYzIE7534qmG9WdEDuAjEq8ddPVx+OMUX7+Mr2IG5l4GOQ391fqkh7RmHApL57OBfQv1A9eYN3jH+g4NqmrH0t5De4LWvhXsIti5ImEkbUdYU2ZnjD3GRGHIb/Ruk4Oqv7DSN5bCTfGtvC2GTd+Rygsaj+cErG42glsbQoGXKgzS9tOL1Rh51FKsdLpdNllP8TvT20AT2F9CZXk2r77mMvZ+fNfYZZby2uoTBR9ZjB1cW3QsXj6Vwc9DSPltIPrMdYRQSKu2rLDLRfoarycgFBgXJ4J9FepW184vru8ySzZm1OnvWaMEGM01dvY6N2RJN2IKwQGRvBmDEtBaCHViDNI7t7VuYF02Ldld5PfZJp/tm/fceoGK2xgdF2SeljLER9srIYVgBwaUlZPYdvE9qyfqpPp0aGqbtxrSqRz9Fb/7x5X6Dk56R1Th052srTVHnReAj8oKokvUbrF6yFQMOHs31VCjAWa6oKGFRU/yD03XALh+uXhnNRrIb8MxZfcr6YdxY5WmtVgg+yAJKVgvR3HWFgc8at4wVBrindyrCwmtkRv/WzsdvSZGKnj0W7TfgGEkYR7LoabAA9tkeO1
 P1MQG9vc
 OE4uP+ekwt3ffP4YCC8frBpPq4t82WkuFkzJzPDIwfA3fqduNuwt0DJn8LQtCHT/un5wq8ssZ2JRzpDZd76mBXBVy27BfY2vTg7k5Nrst/BIKN4EW7Wd4Rv+JKAILAwV3DA4b/LZWoZqj/U0VoHgVpTLPZMCqK/D+aKJ4otAHR/fv+4mmla81CJd+0FJ6V+gcY+DaEvMU08AnRb2JcpMQgJ4OK3Md5zBA8HgrHwmgw8c1SXkpF5L4VO1GOl2HOIbsML/WKKLHx7fMupi8CeIfoamnlFFBhCZnmghsa4DNL0JyQEYAc77v7aiJ+jxaKX8mB2r5Bb8J2jd5UsmauwwsLMwUD5kILGMxuJkFF/KJbDX5TzFEvkLu1kwsoIxh3Nu8uqXhdlFQ/F44ZR1UeoalW5VM868ywA+f9fFXo3jx9TUF1VL0aRLQiYbxgK0DZ+FnulHr6mrZ5+gKDZNHeMYeTK/1ZZW2EQbl/N/p7mQcoT5i3CoUjrRsvUVXKQRNTBcpPvuoKUdwTBP3sGRkUA1nOHFYSUl8tAryP2zO3nOlg7rSxR0uHaZNkqfgxKSYGSIn2q938TS5KMBJO77JnHo4LL12+eHTyPSMs3zXDXNYw7fzh8s=
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
index 2d89d3d51bf1..756d44eae838 100644
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
 static void ceph_folio_wait_fscache(struct folio *folio)
 {
 	folio_wait_private_2(folio); /* [DEPRECATED] */
@@ -589,10 +584,6 @@ static inline void ceph_folio_start_fscache(struct folio *folio)
 {
 }
 
-static inline void ceph_set_page_fscache(struct page *page)
-{
-}
-
 static inline void ceph_folio_wait_fscache(struct folio *folio)
 {
 }
@@ -743,7 +734,7 @@ static u64 get_writepages_data_length(struct inode *inode,
 static int write_folio_nounlock(struct folio *folio,
 		struct writeback_control *wbc)
 {
-	struct page *page = &folio->page;
+	struct page *page;
 	struct inode *inode = folio->mapping->host;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_fs_client(inode);
@@ -825,7 +816,7 @@ static int write_folio_nounlock(struct folio *folio,
 
 	folio_start_writeback(folio);
 	if (caching)
-		ceph_set_page_fscache(&folio->page);
+		ceph_folio_start_fscache(folio);
 	ceph_fscache_write_to_cache(inode, page_off, len, caching);
 
 	if (IS_ENCRYPTED(inode)) {
@@ -845,9 +836,8 @@ static int write_folio_nounlock(struct folio *folio,
 
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


