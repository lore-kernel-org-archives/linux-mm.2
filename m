Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52331C61DBE
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 19:09:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D4E36B0092; Sat, 29 Aug 2026 15:09:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ABD06B0095; Sat, 29 Aug 2026 15:09:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59B316B0096; Sat, 29 Aug 2026 15:09:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 28C916B0092
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 15:09:27 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9C0861A0163
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 19:09:26 +0000 (UTC)
X-FDA: 85155245532.14.86816B1
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0031A180006
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 19:09:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=BrcJ8rPS;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=4NCVRcD+;
	spf=pass (imf16.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788030564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2plosek4FqZnkL3UCaYJ0f9rmIWELlqNc8zdmdPP/o8=;
	b=Dm0wim4NegjQGJedPnEppfehw4IRYcoIRwPCXou2cf1ynO2x2ZBz9YZg8c4rJPpf1q2Q5n
	SwKiyYZ55sIgrKpmCfnvav6xVumtsnDbYx3DlKX7Ij7sIgPdzMfNxVwu6mGsoZEuEE4Z3E
	JOcFp4VtxNKlLnFZnN/zoiTdllG/zrs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788030564;
	b=V0Q/Z5kqLDcyKUfVSwTi0N1ZyjXZbkI3tfI5Kz+AZlGpe5SHDzHrdxBp+/WgRAaQb7+NUV
	R70YP8Upvsc2a3jmFvLlqqm+wzFV08ju48Em2MUOtH8ef+o9tIzfQfs1OIw6daTNsH8dwh
	Z6I0Qkj0G10CX0X6NBS9NLONOQQyQ4o=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=BrcJ8rPS;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=4NCVRcD+;
	spf=pass (imf16.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67TIYweG2730301
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 15:09:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=2plo
	sek4FqZnkL3UCaYJ0f9rmIWELlqNc8zdmdPP/o8=; b=BrcJ8rPS5yZmX+HHDhs+
	5Gt5klBGYmqbGrMkzQHlrd8OTj6qYw3dPhlgw/SlrAjuu5tfyXjD7ISVKjRiUCTu
	esDWg36CP3Z0xhCPcDM0A7WR5E+DdBkyYOHgvEgvHYQl83SnRzslEtHlmwjhiBGV
	3zS1Bg3U/hToW2iEYslWceXO6rk4tvS28yhxxL6YX0ugg+JmIqPhvcu7Z6QJixf6
	l6uBt1bKj5652rsEIUTnEc11jbmaL78zkd3PydGTe2h1kObc8aCv9Mo3t5+0v+bJ
	f+R0dqvzKdKAUhXbmU2Q34ikXvZoD+vENeni+1AdsMysmEd4DWiYi0J+0cBIHx/e
	Yg==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gbvchamwt-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 15:09:22 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-52ef04756caso29508851cf.1
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 12:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788030562; x=1788635362; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2plosek4FqZnkL3UCaYJ0f9rmIWELlqNc8zdmdPP/o8=;
        b=4NCVRcD+/djBRI6vcnwrxOrop3KSZQb5Wl6kcAq5jcK2yv38H9hR9Gqn5xpoxnxCZn
         SELGZ58fbQ6qR2y6ehEg/948ks1hjunQXpDeACdVxZdrR37/MM0ERBPZxhsYtIrzxq3T
         wGZ6b0OvtfNvBUsFa0TCqICqvn0hb4VFjYk8zheJqKEOMqd7WwGk93Na0ptuJzGrNyL9
         1ok8bGTQWq+jPlEYgCbR3W+GPrdeeTqPeYwf2Zsx5QS/GAbzG45w+sSUK0eORZiGKeMQ
         g6SCUnM1J8GkuoD5u78uBz7voJuXWV2jopMC3SSgkcKgnQ52IkBuNHhoTG+JZ53DCDfV
         ONWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788030562; x=1788635362;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2plosek4FqZnkL3UCaYJ0f9rmIWELlqNc8zdmdPP/o8=;
        b=edtSWhhL9182bRCes0Ucc0HxPxRQKihs8iLm3aubB0Rx9mv13M3/HA1O2Lqr2YQNRn
         uKYr56qK2TNl06h+K/2TKXEJw86h3h6PmikqzR0c0ra09bGHiZSZnaj2pmF17QzDxKIJ
         0ma99PRKjFFiEPwK2AytzbdtZRt/e6YqqOMGxndqCQfuS0FMegU65nHZKh264xpVPJWZ
         wTTIyKjvLDlT/lqlt/J4ZBsuzkvmzM9H0sDL2cL3SENtic8MulZaXLTYR5ODY0+m3JnC
         c0Es8j2ytMPr0VwAWI7CHhuwTKdCHvaXU/NB/X5M7BofSffMirNHNtfWN+E693uAYdjX
         EiPQ==
X-Gm-Message-State: AFuF++k/oHjPB/K9Cn5k+yp5/BIDrq80+Jxw1wyECRlgAuirhRGnU6ws
	/oxXK1iGQXxk4WbkFLjrXou/Cn7o0m9i/vG1T/Q63fsNYFw/4wd+5jVF8GzVVQDNzl75k5R1mG7
	YHoZrvCcgZZILuB3kJMo3f+XOjn5vzbsbW81kA9qPu+MKM6Z9
X-Gm-Gg: AR+sD11BdSRR1meducvHSz3pwrI8322HvE87f1fiXO/NZCSmea1I8uZEkayA5mjGK4A
	DdM2m3AtmbOrg0qvZfByqBGWDrhqdK+Hhj5axj/EO+/vPqs5p0LhppQx60+LFLP3MkTNJHWdIg1
	GzSZ0NrXKtcfzbXoE4ule4DATfuf4bjyA62I9uDw9uYeXcl7vwUCojPOlrkgogjXn0bvqaZTrVY
	6DC/wUkKcmgSOirnTKr8xcfiEryUTImdqWdwbRN4cwZthqqasyFIlP+EUpY1m7aT1QpT+F+KE1N
	ZYlV1lLSXJjbNLagEpt/r8Eyv5bV23W/lEHkKg6uumR24hIkAfmwRyrwHYIYuD0pWf2HFkYCJZA
	rrm5PfElLiPrAmt+j7l7LqNbYuMgI8Libt/RJ83uluA==
X-Received: by 2002:ac8:7f11:0:b0:517:78c7:d93a with SMTP id d75a77b69052e-52fb940f275mr189376421cf.16.1788030561673;
        Sat, 29 Aug 2026 12:09:21 -0700 (PDT)
X-Received: by 2002:ac8:7f11:0:b0:517:78c7:d93a with SMTP id d75a77b69052e-52fb940f275mr189375951cf.16.1788030561276;
        Sat, 29 Aug 2026 12:09:21 -0700 (PDT)
Received: from [127.0.1.1] (bzq-79-179-7-133.red.bezeqint.net. [79.179.7.133])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b963c3c0asm239150095e9.10.2026.08.29.12.09.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 12:09:20 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sat, 29 Aug 2026 15:09:00 -0400
Subject: [PATCH v2 1/6] mm/page_io: convert write completion handlers to
 folios
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260829-b4-page_io-folios-v2-1-649728091117@columbia.edu>
References: <20260829-b4-page_io-folios-v2-0-649728091117@columbia.edu>
In-Reply-To: <20260829-b4-page_io-folios-v2-0-649728091117@columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
        Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
        Chengming Zhou <chengming.zhou@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788030553; l=2005;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=bu2FKT6Zpidj2DaPOQ18Cz+j6n00zUJsobxVdi/Srlg=;
 b=SPYQA88a1LAIj2ZZnebxGr/3d/I52y8G1s/0Lon6h/WCJaTMjUdonRWdeaHSGfbAeW7dGmWcG
 c4+4WEPqIaHDWVvjeRp5+0FHnBusNxXIl3AcpeV6qrFoa3+y46ooI4L
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: _2uR0BsezvRN_gn7y-wy6hHPQ2cRdhaO
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI5MDE2NSBTYWx0ZWRfX0f5QRjAjbY1k
 ++GP5WAxU0yN19f7TY3eNSZZqo1fH13C8CiRvyk7YRcYrXjltvsL9CvPGJXUDqUONON1083jCtl
 YPbYmOFUgsBzrDbx8x3UR6mCep79XVDC/d+RbHZ9YYAlhdbSwdL0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI5MDE2NSBTYWx0ZWRfXwbk8wyuC9cVP
 CmDxvDQHtxEQn+etNcbil/fSCCjcX/Ro8UZHPB9tRIjrb9IhG8N6VuAsk6GW/A4cRvTbDkMnMUU
 a5W8rtt/JaBcXuYRxswklq+jzgPdYvhG9cx7FuwcFledsSnOg/H7u9e2nzz7aw5oKfp8bbreFxE
 cw28twhS+074/2f4OSv8DfYQKp07xoau7nHZzu8CfOzfg3qNafl5WQt99v1Hh3zJBKH/K1vK/ME
 43/aDT7pP75v6JWQUnSWHtdr7X+/35r3K3bHDFVDpyoHdmCdVOAR30NHbc7SkwQ/Ine5YGoqSSc
 3g65rVcgEs6L0Vk+c9PAJE8b+KIor/gn6tkNApUMTr7gl4tf7cD6w0EwJM9UIOdA3FkHrpthhGC
 jGoXOkWO0f8b9Gf5NGLMn8ao5Ozx+5KKo5ZJkJSf/cto3cy+SWPkMgByaQkoBmaqlOirRgLCSQ2
 d1oItvFTtoc3yCbg9tg==
X-Proofpoint-GUID: _2uR0BsezvRN_gn7y-wy6hHPQ2cRdhaO
X-Authority-Analysis: v=2.4 cv=cMbQdFeN c=1 sm=1 tr=0 ts=6a932e62 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=LRATYcvZeiQrLRB5MfbBvg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=ufHFDILaAAAA:8 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=rmnECYv2iy4ui3MlnykA:9
 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22 a=ZmIg1sZ3JBWsdXgziEIF:22
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11890
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 bulkscore=10 clxscore=1015 priorityscore=1501
 lowpriorityscore=10 suspectscore=0 impostorscore=10 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608290165
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0031A180006
X-Stat-Signature: ztui9o7xmz7gknbnwagqpx7nd8gn1dh8
X-HE-Tag: 1788030563-142464
X-HE-Meta: U2FsdGVkX1/1UE8Vnti4DZKX+XYd/LZSkB5zZLoL09fz862v+63a0so5LsTrlCvMDlOX8BvSahyJX3x49HWpm/5r40ic6/iYRxzHSKuqqHkkzYEXuZHD7PB06JHf6IUrqr0IrmqTOiVDmwB5orsxL4WoSb4TyZxohuIlKv9jigXNqYQu9GGVSrLjrlQBkmmR4+f+xE49eT4ql38lSz0JJtoIVHR4jvnLzgNmm5/Sme+8fw9wCGaPLigeMWN21FPnvcaC96BIaWsvZicJOIaREW4PrOkewtnh7/zHtbWKlS5XiRhJDXxxqeQBhK8C43+kgbvzVvRRYJnaIB9A6wwb6NbNWDAYn/aqp4AUHRJJUYrptTtO2WpLUJsvJzl5pGApKSlbj0+VwpuS5m1dkz4wA0QeW76zuAnsf6ygKm0u0l7pic/rF7bCOrWbxZXh2Pd/bAA2E6zXztvwMa+w/+YQij5NbN142DqmYeTqQTYagkdn8757dBEa/sDpQkBLJ489Sxjf9IAc+UvYv7oBZorCK2+t7T25LkY9CuDU7ElCxV1SVX6N3p/qdKMRxqGq61CQyKaIT06MDEYXkqKIfw+RQAusPfamAsFAsIsWxWzLhXfAeObyvPeqEhu1n7eyPCUJ8+hj0G3og/oOe9u9K8Zi+5lyQXgrQGpB8t+aHibnlBujzbuAbiS9QSe6/JzkYBaG5Y7xv1joNTsGzsDLc4Bv0anNPbkUPfGyzaURVrSM0XOyp7dPzJt/K8svs7k/DXtWhboX+FWR3G5lWUNZXAlxhq7WTIsf+UQNfFv+XTk8uKdMT89R+hcTrWSmXf8lxVBSkGPGUBbWWPQy8Z+gjmhrk5djhXcNnXLAeUXv2t8j/yn96i78GXccyFuF9BNLGYJQR7lIHfaze6JZMQUtscZHCeSmYEOb9qtc2YeEisc4d8sW3E4FxMhs64fuu4xbvVOmBvPka1UcKfIGFbmBtdQ
 LF15lWp1
 tmhc2KqQo12l6yX4Do70/yHHlb36InEubo4reeWMplQVF6vP58j6qf+aMbhoNxNMrIVQr4R/leUsjMkuY6ah6qnzSQ3tXcli+/JtojCTNUa4JEwkD/Z3eW9neCOomDKj8126o6gR4UkodQ8C9/mvo5Cue65h/wGXj6JW6qtCuZKWwp7yXW5uHF8EnXAthcNxaudJ73Kncu7y6GLnMw3ERdz1yKeDc/JMDHV5CIDhLr48oQg2kh4HwyTe0cLfXel1kWA5qdHBY1bHBBFo6NfIWALBQEtyTpD3hXrYyemF4386CbRmMokB8GI0SgW5CE2B7LfkJcziWwIUWD6dosEI3VOrOB0KlXRHBqYWb8445VzcLW5qU7q8Ze+r+zXUK9wWxELd+rrQFMkrYT43IesY7+u+IB3fKsNrphQPpBlE1nAtAGLj2nbZK80b1YDS/xuO5NQQMHZPam/rZMBhNXJmRiyFOda+kxHjQ58nuR/JhGL3PjoRaYO8HeXXUufTAHPxvNNUqrOJvLhrVe32Chq9zXrHzDaNO5yGZvuqJ+WAA3kU7v9nk4M/Hx/Fvnap+tGL5aKsR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert swap_write_end() and swap_fs_write_complete() to operate on
folios directly instead of going through the folio-compat page APIs.
This removes calls to end_page_writeback() and set_page_dirty(), and the
last caller of ClearPageReclaim(), saving two calls to compound_head()
per folio on the write error path.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/page_io.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 88962571cb93..fbcf58ff292d 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -497,13 +497,13 @@ static void swap_write_end(struct swap_iocb *sio, bool failed)
 	int p;
 
 	for (p = 0; p < sio->nr_bvecs; p++) {
-		struct page *page = sio->bvecs[p].bv_page;
+		struct folio *folio = bvec_folio(&sio->bvecs[p]);
 
 		if (failed) {
-			set_page_dirty(page);
-			ClearPageReclaim(page);
+			folio_mark_dirty(folio);
+			folio_clear_reclaim(folio);
 		}
-		end_page_writeback(page);
+		folio_end_writeback(folio);
 	}
 	mempool_free(sio, sio_pool);
 }
@@ -514,16 +514,16 @@ static void swap_fs_write_complete(struct kiocb *iocb, long ret)
 	bool failed = ret != sio->len;
 
 	if (failed) {
-		struct page *page = sio->bvecs[0].bv_page;
+		struct folio *folio = bvec_folio(&sio->bvecs[0]);
 
 		/*
 		 * In the case of swap-over-nfs, this can be a temporary failure
 		 * if the system has limited memory for allocating transmit
-		 * buffers.  Mark the page dirty and avoid
+		 * buffers.  Mark the folio dirty and avoid
 		 * folio_rotate_reclaimable but rate-limit the messages.
 		 */
 		pr_err_ratelimited("Write error %ld on dio swapfile (%llu)\n",
-				   ret, swap_dev_pos(page_swap_entry(page)));
+				   ret, swap_dev_pos(folio->swap));
 	}
 
 	swap_write_end(sio, failed);

-- 
2.39.5


