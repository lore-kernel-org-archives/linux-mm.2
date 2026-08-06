Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9B51C5AC7A
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 22:57:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C9656B0099; Thu,  6 Aug 2026 18:57:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57B1C6B009B; Thu,  6 Aug 2026 18:57:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 469146B009D; Thu,  6 Aug 2026 18:57:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE87F6B0099
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:57:51 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 43DEA805C3
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 22:57:51 +0000 (UTC)
X-FDA: 85072358742.23.F0978EF
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf15.hostedemail.com (Postfix) with ESMTP id AF6FBA000A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 22:57:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="h/OnXk3F";
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf15.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786057068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZDta8H4TbOGgmN72HYVLiwhdlqK4+Bj7qpHNP2qH6Ts=;
	b=XHKXWFdcWCqG+tOtU2ZoCABhQJsKLU3M7IN+a7RdYEOhdI8Ykp4VG7njyRTY3tEaMs3LEo
	K6xOWQ0CyZaubl+OhJ7sCCsuR8vtbW/rsJZqBpny1RhbRk3xK8JcpcICVXMF7LFuLKDN7j
	5gnwyobtYJyKpb6tVHdaEaMkWSLI1/4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="h/OnXk3F";
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf15.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786057068;
	b=vwOUO7TMwWfj/VQMI5iNBfEtwHcvbUWhgjAJ/xMvCKatZzjeQGSTG9PWqoDscKcqAamJHa
	xd11O/llDwpPEKn9qu6SjA8Sgbi9zRuV5OgLDRBK7LBFJKRYtrlBYOKmmdyH/8uhs8n4Gl
	5w4RBtFmtnLtuiJD6Eft2ugstH8g990=
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 676McDnF2012317
	for <linux-mm@kvack.org>; Thu, 6 Aug 2026 18:57:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=ZDta
	8H4TbOGgmN72HYVLiwhdlqK4+Bj7qpHNP2qH6Ts=; b=h/OnXk3Fj89uY5PtrY85
	IlCszdClJvEoiyta+unbROaUf1Kr787Tsroo1XCVWI9Hvhu5dTloNXw+NYUSYrju
	ZhLLkBKHAZBBi7mRYDDI4fkW4SgFJ6jLCSOU7qvI8lAu5wm85tBU/mLHFyNvjsKx
	9eeq1u1WrcayOVQpPbQKiUFlC0BvScmHDaMBrTaLH4XxkIVPTRhzJlTg0MSDQTKF
	aqiyb79m90F24QvaeFH/h6ka26pl41nRk4ZoK6ZtRJx9NnPI+oe9OzVUKEtDi2ey
	3w/ZQuwDpCTqNGm1vAtJ1k6TCCousF0OZJA4BTLD0ZvoxnMLvajfH3iRJTWMlBI0
	7Q==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fvphh5vs2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 06 Aug 2026 18:57:47 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-51c01ff996dso30967751cf.2
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 15:57:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786057066; x=1786661866;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZDta8H4TbOGgmN72HYVLiwhdlqK4+Bj7qpHNP2qH6Ts=;
        b=a9dj7xyIZ6Mdei7JuFBQcUPUBUCXn5o1jBhORMS2EJoBAiS7BzK7/sInL6B+cJYkLo
         8guX3pEwhDhzfwqvgQ/E3zSc3TJjwT66G/mwY4GBjwmkcCU5EYFowR/ykSWw6aY7LGTE
         4QzT/14eBep7tf27MBHtyKY0XqMPJigCrIo6MfZY7BYGCg0G0DFKJjfnXSgwXuGrB3Ms
         QdD9M4Jo2dneqzq5/ZZbr2vzQj3s3eCbbEnzZlIRDvKdCVYNP+VvMmvx/doKUiSt0I6S
         HQSY4EYQ6q9seTJFo0J9LH5JfTJTlOBM7EX5tquoPFfM/4dDUUnkLr9IpROvEvY3Y02Y
         WsSg==
X-Gm-Message-State: AOJu0YwS/cS0EC2G3zsiUj+6xVKx2ptEkPfjKRu7DLWaCgld9pPutwkd
	fMMuRlj9H+bPShaE/YOqmz294e53Tq2S4FyROmvzxFiXTHPO602msvQ5g4vL0d80wnFEjLgQWNI
	lVZJw8WTbhFnyNV6/IS0qoBIbwoPWZOBHcLz/pqmkdEL9GJI8
X-Gm-Gg: AR+sD11WObN1jwgUs/nao3g0dRSfwsInl52k9pIWZW2Pe1el5EGG9DOiDYW1T+bl3Tn
	e2IfX/0Ayan6KfS78m79IyMoClQVYUYg2c7IoX8coSGlIq/WPQYjjZDNkIh8E5uumMpZ2xYXCjV
	PqcOtrv0SLYlRLQ+SEnQDOBPRJQDyV33EPI27Guh3dGgEZ9nGstf0Q1Zc6AJQw5phMXYIopNoJS
	1iaLZEz4Fm1LT3fAHrusGFGQ1uZQQlpWGzUxnNx2rZM4zCIvtm0tT/gxiixXKRg4sCcDAg1StQQ
	nwceuCj9pSaIRtVGdP16B0gdB77uuc2HQBz88cNrGFt3AnEjOb4kID1AMIQgNRxdDqj2dDH5dnX
	zNuiDkkyuW7qb
X-Received: by 2002:a05:622a:181e:b0:51c:1e2f:1281 with SMTP id d75a77b69052e-52ce61b5415mr198604181cf.42.1786057066338;
        Thu, 06 Aug 2026 15:57:46 -0700 (PDT)
X-Received: by 2002:a05:622a:181e:b0:51c:1e2f:1281 with SMTP id d75a77b69052e-52ce61b5415mr198603751cf.42.1786057065855;
        Thu, 06 Aug 2026 15:57:45 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.78.43])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47ff7b31975sm8751344f8f.33.2026.08.06.15.57.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 15:57:44 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 06 Aug 2026 18:55:36 -0400
Subject: [PATCH 4/6] mm/page_io: rename bio_associate_blkg_from_page()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260806-b4-page_io-folios-v1-4-0899bac3b826@columbia.edu>
References: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
In-Reply-To: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
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
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786057045; l=1577;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=3OPG7b3tK7Cq1uVgPCHfhGHZH2DVy12VkTYBlm1Q10Q=;
 b=uAJqj8fj4Pssj6xRZUaea+p00ZtkpOIYz1832PDFM8eZM0eZVI5/ukn6uTxSWKgj+B6DWJeI3
 6SCnyv5iT+nAUdM/9+ieKtQ5uAJbriU1HnQGE9K51NKf+aWDBW6pcEm
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDE4MCBTYWx0ZWRfX4ROo9BRvLTko
 Qhkn4fKaNmb/RHFEs7a6yrmzLoXXmUHR0s8uGC5nd/x3RzFXJE2EIQGXLbh2dTwk14lYj6IeWm7
 kgNti9rSSojB/Gsjx5r6xnJM2+zsm/tGHbwauBDAcM4O83kXVfCiUAgkKXkcqG11h2lh1dp28Q6
 O1U8B140kRjGck+DSpOnH/M8pKBEy+gIUfD5fP/vk5alzMScqYWRsEOuVDIZLM3lXQNS5oHcKar
 BB3BRcHFgIE2VWD7B0xhhh7+IpvUrWYDO4PyJw3lef9AeLDm+P1kO/c9U/Uj0NzajLjOpWmzeXH
 gCKA58BTbG7HkaAJNzmDZb+nATMYwAWcazhlj5/TSijs+M39vqPcpUxVBtx22dFEd8CYJxsw77R
 lGj2G4pxb5XX0rxUgOSHj90d1VkolB34vuQNxxvKrec/cgX19E9R2QAtk3zwj1r4IYzzPuZdLqI
 69gvYWb12E+QiOXoLOg==
X-Authority-Analysis: v=2.4 cv=EoviaycA c=1 sm=1 tr=0 ts=6a75116b cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=z9N5oyD7lR4RENIpbqURcg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=d-08HifAjaWcUkSzOnUA:9 a=QEXdDO2ut3YA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-GUID: KXy3cg9QIU9Zog1tXGy_EwGneNk6Znhn
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDE4MCBTYWx0ZWRfXzIRCUt/O3eHj
 vl51qpgBHY0fE1Fsb37TtNYIXnpOSft6QE8XATRN/bajISoUbTaljKEqzAR/og2QhQHsFujWXk+
 HS3MIso4yvx19l1AMWKF7Xn3tU/14eoBnoCY6WBcmg6NAsUrUwZM
X-Proofpoint-ORIG-GUID: KXy3cg9QIU9Zog1tXGy_EwGneNk6Znhn
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11867
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 priorityscore=1501 adultscore=0 spamscore=0
 lowpriorityscore=10 impostorscore=10 bulkscore=10 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060180
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AF6FBA000A
X-Stat-Signature: ds4fwk981ynckf7xfnfdm9j9tg3xtfgu
X-Rspam-User: 
X-HE-Tag: 1786057068-81386
X-HE-Meta: U2FsdGVkX18LZ7rZRHPaNOjrKIpopcnVgqWjhIFOOPSTFJ4FZPtuHrRx9SvF/gcvT0YIELs2OKG1prn8KFg6KAhgJO9v+hesZ3aNf3c8N3mfIeUv2ITd9Sb9P8fP/LbEFmDGXnS/r4xF2t6rZs99bp4SYowlcHDKWB2E4zoetta/Xce24V2/Te4nEZcObYeZ6voEJ+QWZhPhq8MrlyU/WDRoKCOOumGtXj66BP2sTi/W6g3/VFd3+iLZJHRfT+xk7MQsWTEN5e9zWqO7W1CzseYMGkpXPw/Qx1HDpIbWU1PwfAxpYIaR/j+vsKq36VrRqV6NmKNczDZ48IQUitRO1KRCHcjEKH87/wJ1ft36RBoLus4I+Gw7c1cDVb5fCYAI5ZFo5ANygLXFeuio80b66569g8iBG9ZGU5nb8QG0sZycFJ0PT0NDmZSenxYoXuf+/HV4NVglf6b9hjIoRgJsPFqruqQnsnWzHt99yo0IPb/GMru43IHJzqnWpFHc/GvYXbE6zxvReYSRYh7B1nEMvz8OEqvS2jDiPfcObS+ZqG3eM6l/cSCZIAdueT2myPYGpzXIsVrLnd6V9iI1TC9HF3Fiiz+E0SP8tjQGix23a11VG8G/14okJHr1p1f98TGq1chxSZJ3VUk3ciulrELZd0qVgaaNo+/SMCgo8EnVAEBTNbdJTLcfGEG7umLnjgxrc13E6sgGTpmRDv1it15pp20MYatq0VrqghitJBnY6ZHbmtCZnxqwSi/c12UaIVsVdy+6jNQ5xjqWI+GoMItsBT9QOmFMKrEk6Eq+k62M2O4dANfTe/NVRTwvZd8DSirdC8XRhlpxnsq+FHgTE/r5IIE5ypoVaOOg7rZuJyvMeU8uZclnW4InyHsXfsW5Nng2jbGSjrdf+ZI8z2ZidWMBEmampMZZSLA5mqDoo3uyA/51e5PZ2HmpC9nlUKqVpmgyVEvZbO+61P6DNzC/Aqk
 5KpWUx1V
 AR7/NTL3jueCcSfTQIjRVuotbMVOt9ZeI9/pimJwLkhNmXuvpC2h9+KEhZp1A54q+HQe+icK1XtwzDpEK184plFStbEDudLLM+kGYZDNUlii7VD3Po6Q1Rnwt+NjfNhkwn0dEJ0Ug3IrUpXObEXZwY3hX8WFFc0nObhOma96OuYrfdDDhcIjTPGhUPf13Xb0Adhhc6/bnvjrQku3fiQokkg4z2lUj5dPDNcBSmFDZQv12IQpLM0GfXBrmj6gE8fWp8Xr6TLUG2q79ip9i1esJWI/+3y1akOZBTrWlNYxRpgznpUUEK00Lr069SYTAHaFlj1Ae+tPaKAH2intex3GVMct5hdl+I2fxrMHvByIy7yS8MtBSYzXeFWQO2SgEgt4XadgPjLEBF6rfIrU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This function takes a folio. Rename it to
bio_associate_blkg_from_folio() accordingly. While at it, convert the
macro in the !CONFIG_MEMCG || !CONFIG_BLK_CGROUP case to a function.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/page_io.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index c6d0949b3f1e..8573f7b8967a 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -276,7 +276,7 @@ static bool folio_blkg_can_merge(struct folio *folio, struct folio *prev_folio)
 	return can_merge;
 }
 
-static void bio_associate_blkg_from_page(struct bio *bio, struct folio *folio)
+static void bio_associate_blkg_from_folio(struct bio *bio, struct folio *folio)
 {
 	struct cgroup_subsys_state *css;
 
@@ -297,7 +297,9 @@ static bool folio_blkg_can_merge(struct folio *folio, struct folio *prev_folio)
 {
 	return true;
 }
-#define bio_associate_blkg_from_page(bio, folio)		do { } while (0)
+static void bio_associate_blkg_from_folio(struct bio *bio, struct folio *folio)
+{
+}
 #endif /* CONFIG_MEMCG && CONFIG_BLK_CGROUP */
 
 struct swap_iocb {
@@ -595,7 +597,7 @@ static void swap_bdev_submit_write(struct swap_io_ctx *ctx)
 			REQ_OP_WRITE | REQ_SWAP);
 	bio->bi_iter.bi_size = sio->len;
 	bio->bi_iter.bi_sector = swap_folio_sector(bio_first_folio_all(bio));
-	bio_associate_blkg_from_page(bio, bio_first_folio_all(bio));
+	bio_associate_blkg_from_folio(bio, bio_first_folio_all(bio));
 
 	if (ctx->sis->flags & SWP_SYNCHRONOUS_IO) {
 		submit_bio_wait(bio);

-- 
2.39.5


