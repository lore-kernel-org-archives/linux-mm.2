Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1CDFC79FAA
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 15:16:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BE136B009E; Tue,  8 Sep 2026 11:16:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94DE06B009F; Tue,  8 Sep 2026 11:16:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E78C6B009F; Tue,  8 Sep 2026 11:16:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 59BC66B009D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:16:49 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D2818C038C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:16:48 +0000 (UTC)
X-FDA: 85190947296.08.D08D2E2
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2DC59100008
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:16:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=pi2SEGTT;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=VmUjVNbI;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf14.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=pi2SEGTT;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=VmUjVNbI;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf14.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788880606;
	b=0wyTgZkMnPq/07Pvn4wtLI+HbPoHmqixbo5q6NZmEOInPFrLc9YmLydZex+CPfmsgcpLZ7
	ddFXMxqmpHm666Z+LEqSA7sqr42x1mrGy7+idPsz7Y094vrN+FpX5b5+OnmC50CZok2+4Z
	mUKAQD/CDdqypsk92aJ4+E5XnEzpq6w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788880606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jZDBZEDHHg8SYIZt8YZAuqtQEWKDYqBFdIUGpOfM1ng=;
	b=VoMPOd4zHy/nm01zHf+icNFH2bZpIQc7qzaVYqX22BMjri0oYFkXZYAGhoBFBQW2oqlufK
	cZKVHtx5XtfVxwQ/faTAaltdox8tGFbZqIjgxzmQ8wpk2sZlG1ysLLI0CMBX+yekK3ZXdf
	6REv1nj95pJh9PIOVV2mfkPjyfvYPb0=
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688EYqhX2420937
	for <linux-mm@kvack.org>; Tue, 8 Sep 2026 11:16:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=jZDB
	ZEDHHg8SYIZt8YZAuqtQEWKDYqBFdIUGpOfM1ng=; b=pi2SEGTTQ3BGzxs7ah1L
	v2Q4FGn8fd1y6BTX/hVySPBNMfu34Pyg5I6AczMna0PydZJ4KnwOJSdvqZFzekd6
	LR1vfVFEhSaCiJc6KFf59RB8DZnxJnp2yE8cxGnja/jLGmZGR82PEtLSZyvTL0og
	5lFxuBd1ByPKYHK6FuUe393kiyB7OUywBvAWrXvCdA4BVroFPPdubZLE0iaSr0cX
	dlw6PArfthab3j8BNdMqq5hChipn6lO821E5zA1Zs3h9gTXGv+hrurQtCoTRmtFa
	FGLYkf7t9pGA0/C4o/xGnblYVaoStnvEy3iQ3LpScPxzsOzwtbeeiLQzcFejHqx+
	Cw==
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com [209.85.128.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gj4d5d7r6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 08 Sep 2026 11:16:44 -0400 (EDT)
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-879b1d03d5fso36039897b3.0
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 08:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788880604; x=1789485404; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jZDBZEDHHg8SYIZt8YZAuqtQEWKDYqBFdIUGpOfM1ng=;
        b=VmUjVNbIrIaAxoSnI9uhpVntJFdbhPlKg0MmLUpz6Nleqk6lNcmOqkQXleQEpxhSyu
         DLVQ3T0/zHTMPkl/Qszg8Ie7zChZCRw0mmns3Z1Z5s6CBnyd5Vujey8Dqyh+C62BvfhR
         UQh6pqyPVoNx9xPCVRZbaC0uN+F+ePg77YcEaTSTqaIOgw87viXQMvJ2A9OO1I6QqvtH
         Ap4QfDTDUCWzhzR3CBmlXYFmUnrN/rFw/Xt2sVOaMdbiqwpTpZw9753GMzBwkeJ655b+
         q/ueLkPM0kXyKJTat+7xvgF0eXJdQHjkoQ8O3aAv1zCBuQ4+YNz2zTuClkiwjokFiN2x
         EywQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788880604; x=1789485404;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jZDBZEDHHg8SYIZt8YZAuqtQEWKDYqBFdIUGpOfM1ng=;
        b=DQBqgBz09Jbdu/gr9HHi0LGIWuqZB94d0mjMI71+S6/cC3jmnfrR0w41mp5nGthNfH
         iw9ApecqstG2Iy81ieYwFdi9OQVUJZIbEuJvngrxt1uWlR1hBGUrGECN7RQIoRiu5G1t
         CdpwCghD6WTwlNAQ76EXwIrZgVjJhtCAVQ4aEaQSik421RieXih4HcdUhpv02YlbE87E
         574riLUxWjpVAat6ahFbhgPB4XbaBqw1ETSzcwPRh3ALm4VxTAGMD1VAlArCKnRzwcZT
         JJCGM7j4BurSPsgrXNG8gPBSoBXo2QosYGUc6wySzs/d/L6sRG7W/S/04bCxYie8baWb
         gjnQ==
X-Gm-Message-State: AFuF++lKYSrtVjjEmShFw8e/DiEP6cu742KWD75aXAediY1uXBqYCnmn
	rLZgBhvoXVXGP3uL0K8Soc+n7Vwg77in1Zk5nlBjqLfUzaIwlwdninbJ8Kw2ImvG2rFOr3U5Azs
	P0ZwO33lOfp6++1KLc+xe0U170cVyp5/lpeAF8LqnmyPQfDoJ
X-Gm-Gg: AYBFou30xnLU4/nmXTfZh+SLVgLF6tMj8JpQyxoqOnNUDgXdRavhfQet2BCw3UoUMLi
	64OTIdu5y1hVjPsueBv8AbODuPdHdYcwUN75vU75wmwlPO3KlMqTfaAVvpVsxHTjBnSl3a09ncT
	ilnBa5HaaGB8RPwXaySTQYa24lMqwqSp9p0RNbUKWFDm++bOgDtrYb7rhWOT0dGGVmW2+mqNn8E
	P1HAdZGRtvSaLT49+T8EuhPhaX8KtLDwI9AJFde6blPxYAWKI+C/eFNavvxDY9N5+GBEF+dB+Ik
	IzQLMsBTgaAQUCfTDU4F9xF2G+RGJQJPURJoengNFmtFvBn5Oo6TYZwDbUZz+LeIMmrtIjmRua2
	SH3WjoDa5YKtOMlQwq/XSaj0nKl2J4ueRowHo/SfFGlmzGR1yZbGPzw==
X-Received: by 2002:a53:a0c7:0:b0:66f:c1bc:87ed with SMTP id 956f58d0204a3-66fc1bc8c18mr5315812d50.70.1788880603847;
        Tue, 08 Sep 2026 08:16:43 -0700 (PDT)
X-Received: by 2002:a53:a0c7:0:b0:66f:c1bc:87ed with SMTP id 956f58d0204a3-66fc1bc8c18mr5315741d50.70.1788880603125;
        Tue, 08 Sep 2026 08:16:43 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-177-174.net.columbia.edu. [128.59.177.174])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91040673ce0sm122105496d6.25.2026.09.08.08.16.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 08:16:42 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 08 Sep 2026 11:16:31 -0400
Subject: [PATCH v2 1/8] mm/swap: add folio_swap_entry() and
 folio_page_swap_entry()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-folio_swap_entry-v2-1-ee6d01dfa5e1@columbia.edu>
References: <20260908-folio_swap_entry-v2-0-ee6d01dfa5e1@columbia.edu>
In-Reply-To: <20260908-folio_swap_entry-v2-0-ee6d01dfa5e1@columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
        Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>,
        Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
        Jann Horn <jannh@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Yosry Ahmed <yosry@kernel.org>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788880600; l=2036;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=1JS3V+JXyWaTrz9bNNi6UKDOHKnZIpXXTUnttstZ0Is=;
 b=w9CAxnD5RZ/nskXa7WUspsk5TqZ4u0clJSlm+62svGyMiXevHQW2C9NobE10fXR3pxRsqiJna
 uE3QKWw5vWDAR4klvdmTEM6ALzGzAN5N5NtTGukn08tXaIj2hcLErkj
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE2NSBTYWx0ZWRfX8JBTE7a/jbZf
 7HllU6y5jhfzQo4r2+GliN4F+mwMBdQMQqB3zDjHix+1PJv6H6BwY3UilHxAonLRrZTKUrbyCWC
 y30i83cqLyprYyjqIXAZNTfpOAL3YbBeMIhOYl+8VHC3etmKV/7BzOTOc8b9zGJxgcAShJt4g6g
 I/fS8Bao0d3nRkBKu4BHO02UKHFBGdfpgnr5wrXCrRdDZt14/YmqAAjfV7SRPqBRXvSOyVzTkTm
 1nkPMwQki0cYX6E+rEeCZcBSqCN86kQKUUFR+4epOGUqcTSSka+fNKv7jhW4jW1SW8SP3OuwZlH
 Ftpc+iYAsmdejwH/OrcGEZHyDfcbbM9+xaUp7kleewv6fL3iYs10ZmlVIOYy1f+Iq1ZC1Hc+hyZ
 QhtRTIocUjVoqp4nasXRwlodtvtoAggl4tG9CEPKEmzf1Pgq9g4EyjD1pVQXGx5z5BcaQOpW55W
 /SXHpvYu86VU2exLiGg==
X-Proofpoint-ORIG-GUID: k8zj8u-pHU4f5F9nh7ljWk5_rtuG086x
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE2NSBTYWx0ZWRfX/a8vg3DNkZU4
 IpNPXD/1dCK3GP/RztI/eyuT5Tibnd8ILDv1iThGSrY000pVxk+8Xc6HptTK7el0Q65fjSBvmtW
 yuhLTmlhm5Xijt77qDEBw16v2A2BWchtqn4SYEmv9i8XDxCLOXXb
X-Proofpoint-GUID: k8zj8u-pHU4f5F9nh7ljWk5_rtuG086x
X-Authority-Analysis: v=2.4 cv=BqCtB4X5 c=1 sm=1 tr=0 ts=6aa026dc cx=c_pps
 a=g1v0Z557R90hA0UpD/5Yag==:117 a=HBUb3goEnnz3w2smY6d+Hw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=wCX1QjJdxvQAooojgaYA:9 a=QEXdDO2ut3YA:10 a=MFSWADHSvvjO3QEy5MdX:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11899
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 adultscore=0 spamscore=0 impostorscore=10
 lowpriorityscore=10 priorityscore=1501 clxscore=1015 bulkscore=10
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609080165
X-Rspam-User: 
X-Rspamd-Queue-Id: 2DC59100008
X-Stat-Signature: 7n1ffqbcpr8gwmo4xuokk6u8bxupr74m
X-Rspamd-Server: rspam01
X-HE-Tag: 1788880605-347010
X-HE-Meta: U2FsdGVkX1/TAe5yh2QejHiSqInk9t0+/S0n2vksWJd+1wh1OqLAyrzYY+bqVEzlNtHAGiRelaEcsWfwuZ6Ls6BOb0rebE6rF0duGoq4A9sy2rd8BklelzJL89oJxsjiwo5Td017Nz+/V5SPkthjk/hFr0TVSn/68UrL/nqxfttKsv0j4u3uXm4v0f2jvZt01HcUUZ7rb6MgfcRUWu5phmFoDlef7XnfQRuMUsDbyiu1TFmbn+mu0yrsSK+V45Lsrt781ptJ5yuQEf8eZsF3fnTV4stbJIQ/0w8JpKKOyigHLC1E/nxkuyynfpaAJE6/fb/i7a0sZwlEtHeutilevO5EVW/g+WEFX0TlRxQtkKzzY2bq+i46Mf0BR+j7PP/zzWltcVX9cYtwHWjKg8PJC5I0aq2/HdStkFYONNGgiKVBC/k5eYLtMo2SaNvG8X89hkh/t553Q0z6WRplP0bvJ6O5Kf2o935xzKViAWhCaA8gjcrQcmWQ+d4SR6ZNS3nNZMVnkDXZY8yUEWk868W6nggOkBoVW3QD1CYdAd2cduNHxf/XBd5vQme8pFaABD3YgCjQWXePmhig+iHPVJvvIUpnCnn/RpYaStbCH6w9A+cMAt0gaby0Q7McXXnzgmbjqD/9ZLBhGwrKs4qtD7w2mhkSJXQT97dZXgwcfc6sx2aOYXgLLgkTsTlhZ8DogSU56F1iJfLDVZQCgdTLGdpNbHjLy8HctKtnhj4s/ZNVWotni9SLnBMmR6PVyw+G+YcQTHXV0ceeAHOg6WL1hgUx8VUThpLKHMAYxQfaVOAlK0Mgf2Aj69aqXi3cLVD4MyRzaoX53fXdUHVexMKiyFTC4oA4Q45jdO9L2I58VenOgU7w53dZc7S5uX1OZIHnmqwgRfL6XghcXTNfOwkryfYJNeUslPhI42DspjGd/b8aTQQCpitRTwEisbyV3S64UWYkL4k5UMa7cyX00bHqgrK
 WCyONrkQ
 xRdPamfZIqnUIXZfxOqp/cSg1lS3wEY6HKJVr28lF2obowNQkhsYd5Ox0T1i3kyTmjzWYvLjy9hKSX2SxF/zRaNMrvCJgFT97+u0zfEjZlmQH2bqFOLVYeh0zHbC8WMy2sANrZXqP35Tizvs2ixA0+Y5JtNlzdRbcv43UhZ30lzUsc4tmWSqn7jivJRPJ4cjIjQQqY2uiCF6Pk9stGpe8T1QIdhzPrQ39UHUfJbHeWdgFllNIX171ODpHoqyVcBsHmW/unSZjLPQWnoNPuCRjy+3OepUDAZbh9BOOVYm5KBE3JtKa6pM1n3l5JphDJaeeFxTeP0Dmjhivy/wRc9L+XSjwdAM+z2uo4cTj5QIOoqyN+u+j9Zqdko4QZj6qbtCyV5XCasKPtBWI2W2fbqM40gbGi0x/9mIoh6sqxSdZFO0h0Xs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A folio in the swap cache occupies folio_nr_pages() contiguous swap
entries starting at folio->swap, so a page's swap entry is just
folio->swap plus the page's index in the folio. page_swap_entry() hides
this behind a compound_head() call, and callers that already have the
folio sometimes open-code the arithmetic instead.

Add folio_swap_entry(), which takes a folio and a page index, and
folio_page_swap_entry() for callers that have the page.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/swap.h | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index fc290e29e4a9..1d979e76e78a 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -272,6 +272,39 @@ struct swap_info_struct {
 	const struct swap_ops *ops;
 };
 
+/**
+ * folio_swap_entry - Return the swap entry for a page within a folio.
+ * @folio: The folio.
+ * @idx: The index of the page within the folio.
+ *
+ * A folio in the swap cache occupies folio_nr_pages() contiguous swap
+ * entries starting at folio->swap. The caller must ensure the folio is
+ * in the swap cache and that @idx is within the folio.
+ */
+static inline
+swp_entry_t folio_swap_entry(const struct folio *folio, unsigned long idx)
+{
+	swp_entry_t entry = folio->swap;
+
+	VM_WARN_ON_ONCE_FOLIO(idx >= folio_nr_pages(folio), folio);
+	entry.val += idx;
+	return entry;
+}
+
+/**
+ * folio_page_swap_entry - Return the swap entry of a page in a folio.
+ * @folio: The folio containing @page.
+ * @page: A page within @folio.
+ *
+ * The caller must ensure the folio is in the swap cache and that @page
+ * is part of @folio.
+ */
+static inline swp_entry_t folio_page_swap_entry(const struct folio *folio,
+		const struct page *page)
+{
+	return folio_swap_entry(folio, folio_page_idx(folio, page));
+}
+
 static inline swp_entry_t page_swap_entry(struct page *page)
 {
 	struct folio *folio = page_folio(page);

-- 
2.39.5


