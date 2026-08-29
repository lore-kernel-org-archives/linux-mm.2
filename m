Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C48B2C61DCB
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 19:09:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA1846B009F; Sat, 29 Aug 2026 15:09:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C51E26B00A0; Sat, 29 Aug 2026 15:09:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B40F86B00A1; Sat, 29 Aug 2026 15:09:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 86E8B6B009F
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 15:09:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 03C09A28A6
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 19:09:42 +0000 (UTC)
X-FDA: 85155246246.14.CA8513C
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6CBD44000F
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 19:09:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=bsbIw8F2;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="x6doBr/D";
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf17.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788030580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Jpug6oWTGrHeweZlqYEb+sOFZBCujX66E+4i6PuPxA=;
	b=d63i7UALv/Lm0I9nyK8QSLUIL89TOoPWUR/Xu5zf0w7c/oPewY6ssGl6niSmcQKYmElOT1
	0/b4gV+0WkBE3zPStth+oPeRM285pqBR8WYKQJSOkopvjWRbFubK//66/6zNlNsitjotsp
	/0/3KL2Xt5Vqq1e8D4sxnorcZg3vcWM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=bsbIw8F2;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="x6doBr/D";
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf17.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788030580;
	b=UKQqq+kUXbeqdAdVn3mAqvcclaYb+LbAYYwsl+XBr8ef/y1A7+6kbFQsP1UtvN7wc66wT2
	36gUA7EhCgdCXyNQ/ze01htJaQ5TurWith3sj29ZDpiAwArFOsJ5Eobj2e5kamZ6lfEYFk
	dRKH6V2XgO685eqN1Ag0bEDFaDxR76s=
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67TIYqvf1324724
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 15:09:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=7Jpu
	g6oWTGrHeweZlqYEb+sOFZBCujX66E+4i6PuPxA=; b=bsbIw8F2ayaMsOV2QzU9
	C2PLOJKWGm+4XRx+SYenC+eFfeyKSFFFbQG/A9J4eH5zY9h3M2boY8Wr6Zsco3b9
	9G3hl9KB0wZXSuPAPtKV1SZuNtTMye7n61iYJQpZ+YD9pUPrcKx+JA0YaMu99Dq2
	cbSjWjp/CMAy7h7v4P0NDzI0UQx9z6S/2dTqWzczKw18KhMOn5K0RcduIZuYIhxJ
	Unu4/OCmAQzu74p6qhzsAe0mX1fv5zcLe1+92SvJ3JEpn1lAOWEQgD09JANHj2o4
	5Yd+pTWgPBibo/uon0ap20LGqpYEw2izxj9My/hlCYWZi7OEHc4HDCo3Bs23Lofl
	sQ==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gbqxhb5vp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 15:09:39 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-52ffe24490bso13420551cf.1
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 12:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788030578; x=1788635378; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7Jpug6oWTGrHeweZlqYEb+sOFZBCujX66E+4i6PuPxA=;
        b=x6doBr/DPWE1PMramI963VQTCgUehFo6ip2E7Xy5frH5noBgfSz8e8KmkaJkHLP7rk
         wF1QrGlMU+2BkKn9hjOXMvo8bqsX6K059cxinnCEBWdVluq6xPmyIjmpdZukCU0JYNgi
         qWA60Jw/Sf0mzRNuIVqt/cMyzyZnW9Cb8P8YBUTmmB/I4URzRWZXdb78JKRBKEBv8NEp
         ozlFIGM/0D2G/8lMY22Vj8IBHOPJJUc4PH+WbLhme3SoHCsXbYaRUguC6S3i25KxulQy
         Iohjsrxy0lPCDCQ4tKBOIgORxApbejt54/tsvaM96rj/1o77OgdHZLItwGX3E7xmDfhZ
         YDgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788030578; x=1788635378;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7Jpug6oWTGrHeweZlqYEb+sOFZBCujX66E+4i6PuPxA=;
        b=auap8bSqvex/JgaMx1Wa8fFsAeiwrFxf/ooe+MYhADoeeXO+7M/zwAIfYjEEv1vnz3
         bAvvvFA1fAesHOnGbViuiG8Wt0J5jYLrpucPHZL9DXMM9LJGvj5c6lLtr1NgoMI2rz/c
         FurOg3Ka+lvzd4KkuKYBMB91N6Gg5ehy6D/AiIXWk9UnkyMB8awhNSEBJqyI3UYLoz6C
         MQxlCLGIb0kzI2a7iDnrC5xPy7sCjOf6fK5B48q6LEKIL9H9Fd5IAqJi69mWh42rbXad
         QYkJ7PwJ0wArDRHTUKumRkhJjZ0gjKAgGjEUKmpCZUs5LmfT0foaENYCveMpZCYkBjM2
         CEcA==
X-Gm-Message-State: AFuF++ksBlTA0rPUz+7rYT7QOIeo18xHRZNLenkGuBBnvQ18ldmgU1WX
	MT0auAvZvtb+xHcHlzOIShlpWpMOU2O0HexAIZmb4ClYVw2dqpAuNHG+WXcOSHi9PvCNn5ODywJ
	zp78tayAp3oGTLdiMFjyAgSVvZMzdKFjE1inQHAPDms7YbNG8
X-Gm-Gg: AR+sD11jW4aJMD0xEwI/PVKFhWm/l9EzFKiOWNsl9TDjsxyck9aYOdhoQP/DK6VW6xI
	zZCpr6/seytB3XDke4lSUvRrPE8evMEGKv0uXCs69jdSMeGdC1PJ0QPTOIZ/p3Z3HoGh6Ld3/yp
	yvMthKF9uKSJLK0gBXCG8DGdYwDXqT+ZL5Ht407RMPFITVcHQb1Lh7iSun2Gz4oyLvCimWxwZYH
	3smgPNjIWRcPm2xUxc/ccbH1Vu1jVy8M2NGocX4ACYKWj5yXcY24v+G8kRDZT1FXWwYEcWtpo7P
	CFa9ugbX3NvAEIYvdx6rSjCY7QQbzeTFFruwamqbzWaAjU9PxfDSGvtn7Ft1AhWq3iLEMVwbbhw
	1O3IfA3lBDz2rXFwhyk2GFkGXN96YW5sKYyKsj/Ghbg==
X-Received: by 2002:a05:622a:389:b0:51b:f857:cf82 with SMTP id d75a77b69052e-52fb93d5114mr170604501cf.8.1788030578219;
        Sat, 29 Aug 2026 12:09:38 -0700 (PDT)
X-Received: by 2002:a05:622a:389:b0:51b:f857:cf82 with SMTP id d75a77b69052e-52fb93d5114mr170603841cf.8.1788030577780;
        Sat, 29 Aug 2026 12:09:37 -0700 (PDT)
Received: from [127.0.1.1] (bzq-79-179-7-133.red.bezeqint.net. [79.179.7.133])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b963c3c0asm239150095e9.10.2026.08.29.12.09.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 12:09:36 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sat, 29 Aug 2026 15:09:05 -0400
Subject: [PATCH v2 6/6] mm/swap: rename __swap_writepage() to
 __swap_writeout()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260829-b4-page_io-folios-v2-6-649728091117@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788030553; l=2860;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=G2ktRMgJTq06/55atnVs92oo/YszbeBoCTRq3W3l8TQ=;
 b=qi6e6/ntBcGd5Bt7IXAXtAUQphoFd5rvFHZ7YLCPOUHK30NGdCqvHAyO1e+iqX6QuXa87zECq
 p9V0LAWsCfxDlXWKV2uzpPOr/45TeS1J/jv2H/ASXR9LoR7RlBCqN9V
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI5MDE2NSBTYWx0ZWRfX0ChpSSGFUW5T
 qIFGMIBpXZqdQDM3k4cEMU0vRzr0IsJK3p4q4v76nie0YUy5eXBsClD1P5zm4y+O9JFcvx+Avau
 Lv/UdTsSWG4XQzuRQzFkM9YUXXmJsmWFVYPhSkzIE9T78mIZaqId
X-Proofpoint-ORIG-GUID: BWbqr4RMTVO1QwFKs-t5ncN0CVLmU-5c
X-Proofpoint-GUID: BWbqr4RMTVO1QwFKs-t5ncN0CVLmU-5c
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI5MDE2NSBTYWx0ZWRfX2vrtkZrwSvVR
 ec2yAg3hJ/Yu8slTGPIGEhVjZ0Sl1DljPCengbE1D0IV2QGhmZXmVJbDvZsuhEztLm5xXf05XMO
 ZV+srAUAxEN2al1uYN57OSoegcUC4E8rTCH3hmWn17JMEfAphgbgzEEGpJExcD6pI8VBslG6ZfH
 p6l+yksF6nEvjbuMe9V3NSn7bQbgAh0tCO7OQPLD8RIw0LcDFcOzstDAULPvvzAwYJNz2MAAB/3
 ac+DApCZYNl6G/lHI5TC7IYZqlsQVd1XakthIq6ZOOCRKUU1wtKyvvAfzjj1XIIb6b+ZygbDgCt
 zfuiVh0GW3OAPlRFWxkbPIZA6T5DZy/OgkmepBjLsFbP7gAZQJhZk2WcRofX23REzoCc9iXknO4
 MvYjeF1ImaqukXSNRMCgmoHLnoZO/WVuMOFdkb2SuN2f7YO2so9Kp7opX/LVUU5lqrsiVD46OBu
 VC9QTFy/O7RXBjGWyGQ==
X-Authority-Analysis: v=2.4 cv=MJpQXsZl c=1 sm=1 tr=0 ts=6a932e73 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=LRATYcvZeiQrLRB5MfbBvg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=An_WYHtdnaDCoZj6waEA:9 a=QEXdDO2ut3YA:10
 a=kacYvNCVWA4VmyqE58fU:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11890
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=10 bulkscore=10 adultscore=0
 impostorscore=10 spamscore=0 suspectscore=0 clxscore=1015 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608290165
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 3pqyah8s8pdrih6yub3hnz1ck8y65fjg
X-Rspamd-Queue-Id: 6CBD44000F
X-HE-Tag: 1788030580-662531
X-HE-Meta: U2FsdGVkX1+62Ocwn1v3HzHYuD/LQT9DQHgC2tUa8JgsGMQ2BH9uuOOkKtcU/ALK4KuWT2zWU4mduHKH/KuAO6RPorb1T4/McE9bSacZ/YytzZYKvx3FQIyC/GsgsY6appn31yfliCMhnhagg4OxuXnU2XBTKqbcPQAQ9wVnQJdpoDgso6RzCukUYk7aRdU10cSvpR5AH8xMbYjBKlKBlGpr3wrox5fbgLaEDXueQ8IDw8Q5wfjcdtfLNXHMFs/QPtWRrafrT2qQLQiyIT+A6WZe3C6cJLoWWtke2aqvtdJuKAaMH/XTZA6VueTpyq5y/RjZNXy3senFmjjNoT+sL2hJSBUDjoAp0Ho7G9+SGjnV+RVy3kkKxb2q1znwpI5tJnjLVitSoi8MJmCbQPf+G915i0JPmSoU77+Ufrg1BmTDxdMHmyg4lt7DtozOYI40sOSglwNIShBjeRjYKOiimgp1ti6lnyXdzmSvgnSWgBOSbI8PSdvGTUhD/5k4e7hYOr7nthQg6VF6/llFgusyu8LaOsrGd65/ygwtaAWicUTwnNOHI8ZsK6vfTR74LueTbooWbHoympVdn32kin9r0/n+eRvC0qdSA+5yL9wokQrcifLYPs9IsPvvfQhPa/5mSM2T7R1NUBB7YY/Z5C1b2AExkj/x1eT0YHwHBUopj6EYgUmLJ2CT2WLC0sAY3KUWgFlkSPZ1fzvA+FSafQnNyRDCpDvsiyuVPHSWROEYwt5xVSg0FZFYT2b3sLUrRMW89CmzwazT9x3tCGEOhvWpGm3+a/28HL003OyiGkmjaBTkAr9sgi3CwdtNEBgb4CNcXD64YYBOwpDF1cYLyNN5AQ3U6NYvtly1fOl//6JIOm188qyfF0/VKh+hfCogzGwpwAiEdufo15waCisxXlZ4OF3pz5FQux7kVvZ5pr/lWuucPQLwVmPL0oVAUaeRUn7Ps+8Czlg6aNFvZDeNtIf
 haLZM64r
 xrs3u2TxLOnbjrCJL8bRTHysNtM7rBccumSQSY+rlNbYqLXsQDcdXdjtrOLvv6ABo946ZvPJi2dRd0zn5yQ8Yo+CfqDSod80gSvqkIlSRiPtjbwPXzWot8D88fy9YRo2QCT1eFFY1h2ZFGdsNVP82WPDj7vVnQKKrqWQs1qc5Purd3NyEHbDm/NnQbw5QudyNpipViuV+r3j5/cQQslOzR8awPUSZ6ZtiAfcTsopXk03tPqUfm/v4Jt8Isf6c9T2+DWVfdK2buraDIrcLNlgzBr1+nDiVCWT7p66QbgtFDp69L2Ji+HumXyj6lGqRI9iEOosfi0J+1CqItknL0uUilssfyAh9iW6as3I3IOKo9WzZazrisCKKh95+vh2Xvtaq7u9g6K1EaL6u/WZzoZyGL3mueQWzSl54+9zCvZEzWEwVd98/+m7aiLayg9yhEpjNNW1VdP34lDWOjwZyTzp8pA9H3N5kt4sug/zbK79MqgJZ0Q0EqVGUJAFEKu16xzkkas9t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 84798514db50 ("mm: Remove swap_writepage() and
shmem_writepage()") renamed swap_writepage() to swap_writeout(). Rename
__swap_writepage(), which operates on a folio, to match its caller.
Update a stale reference to swap_writepage() in swapfile.c as well.

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/page_io.c  | 4 ++--
 mm/swap.h     | 2 +-
 mm/swapfile.c | 2 +-
 mm/zswap.c    | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 36466159cf19..1da4ff484f09 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -248,7 +248,7 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 	}
 	rcu_read_unlock();
 
-	__swap_writepage(ctx, folio);
+	__swap_writeout(ctx, folio);
 	return 0;
 out_unlock:
 	folio_unlock(folio);
@@ -369,7 +369,7 @@ static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio, int rw)
 	}
 }
 
-void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio)
+void __swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 {
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
diff --git a/mm/swap.h b/mm/swap.h
index fddba7a87500..0b5d507739bc 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -258,7 +258,7 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio);
 void swap_read_submit(struct swap_io_ctx *ctx);
 void swap_write_submit(struct swap_io_ctx *ctx);
 int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio);
-void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio);
+void __swap_writeout(struct swap_io_ctx *ctx, struct folio *folio);
 
 /* linux/mm/swap_state.c */
 extern struct address_space swap_space __read_mostly;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 51f5a525bb61..ab9d45dbbef8 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2989,7 +2989,7 @@ EXPORT_SYMBOL_GPL(add_swap_extent);
 /*
  * A `swap extent' is a simple thing which maps a contiguous range of pages
  * onto a contiguous range of disk blocks.  A rbtree of swap extents is
- * built at swapon time and is then used at swap_writepage/swap_read_folio
+ * built at swapon time and is then used at swap_writeout/swap_read_folio
  * time for locating where on disk a page belongs.
  *
  * If the swapfile is an S_ISBLK block device, a single extent is installed.
diff --git a/mm/zswap.c b/mm/zswap.c
index 37f34e406c8e..88a1a74f9185 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1050,7 +1050,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	folio_set_reclaim(folio);
 
 	/* start writeback */
-	__swap_writepage(&ctx, folio);
+	__swap_writeout(&ctx, folio);
 	swap_write_submit(&ctx);
 
 out:

-- 
2.39.5


