Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE257C61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 10:33:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D4776B008C; Sun, 30 Aug 2026 06:33:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9850C6B0095; Sun, 30 Aug 2026 06:33:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81CBA6B008C; Sun, 30 Aug 2026 06:33:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 53D426B008C
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 06:33:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CA39A802C6
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 10:33:36 +0000 (UTC)
X-FDA: 85157574432.13.1F0BFB6
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id 572491C0003
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 10:33:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=od3n6sZL;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=jobffsE3;
	spf=pass (imf20.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788086014;
	b=vtHDlMCBRpBVURbi05IUiqyHMH1MvgdHveUdMhvNhdNBl83hEK3mTEYQmZ20iin8D7tjd4
	UOstvJYh9Ue2ujANoDqTk/qo/3ooxeRzJzc9Tt4ASoYEzrzEEI+2bgufjxZPK3upFTl+5j
	n5Losffzm395lO8fvvj5NiQn5NysjfM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=od3n6sZL;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=jobffsE3;
	spf=pass (imf20.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788086014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R68iMyJd6AJlpHo53ZebvYn2d9eNAhtoRa8wwiiATKs=;
	b=C7Mgvydkye2y8SYj7r23ugv6UWP1lAmTtqGBkI9cVJOHCZENEZ6AWW/6QG4+y8sYVDr8Vt
	faobIirYd3twpnVTJwVUjXEex5rytnBsYDAmldD9JO0J/N5cpBNyl2LVMpa7qsXAJz1BNC
	Y1cJQXSz9SOJZ+vUIbkhiIKQpcfoit0=
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67U7ebQV3085320
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 06:33:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=R68i
	MyJd6AJlpHo53ZebvYn2d9eNAhtoRa8wwiiATKs=; b=od3n6sZLRUPnU+YnQR7e
	OuLdyhPo8cy2+fXS17e1+5Blxw2+fKiZFkCarwG3rxk8l4Myi+THxnUBr2c3hrT8
	6Nnuur/owIf/VBQv1PXqxEo+w2B4ivKxiAxN7/zertyChKR03we0Q9O+/FED70xp
	zw/iy+WrbaW3EjgWNqq0VpVjtbOQi3vMoamXq3kk+kW/B5LVz2Qj6QL1aWTigz/I
	A/MfPVPMghtFnsdTJbOiDVsnhDOTwFwNjEO6eW0xo7XzKivFEvMSCxJwjiCDurLx
	k9wQjO+FrsFhkTCNEC99EIZLapNuGfqhNvFPvm0SF6ffSLb0Un+UsfEjh7G0mKCp
	LA==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gbrhq5130-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 06:33:33 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-52fb8f67601so31886011cf.3
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788086013; x=1788690813; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R68iMyJd6AJlpHo53ZebvYn2d9eNAhtoRa8wwiiATKs=;
        b=jobffsE3ccYtscw/6tog1fAmm6xxlLG/0YOuysnZ5eAmND3VtDycrRioRKYrD3t4GS
         /tmDN5zYwHcimblLWm5uL+qGqWa9e5XdxnIL+lpEBcNWP7VfNtTY3PLqpeDH411lsjna
         ATo3N5uXx5CnCd9E7dHQluR96EKFW3X9uREz0Ye72qwHtONhWRn6zMi1WxtdBr4m/Ofj
         IkVb+pf836tbeurUX5htasNbwdZvX0peglr6AJRF84FZRVtPdPtgZiQmERq/+AeIEUn8
         Dq1V4+OGhE8xoSOAOYJqDrhEYQmcaoK9z6bEMD8KvwL0gWp8QsKjl7k1CHuXL+SCLMFA
         lhng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788086013; x=1788690813;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R68iMyJd6AJlpHo53ZebvYn2d9eNAhtoRa8wwiiATKs=;
        b=dj1Irq9sZ4Ejf5NpU1AOa5doA9i66KPf3u/STuwhKBflNs4CFqDzZXzq2u0W0xKlKg
         Ma8y0bWWB+YtH9r7S7XCXe2WAXvcRnuwGifKiZTHVxK4ncxiOxp1hyBV54t3h/0Y72p0
         4DlGGybxpE6rwxocC6mkQEE6W0Y9Lon2w+zGGmOSvn6ANTj6IoAN3qHcLMbR2mVj7P9p
         DlsgfsiBreApZlIzAIzAJ6ZJciaI6zfSZ9Dk4GBe3aViobjBwaQ6eWl2MhlmOLVGCVtV
         NI5Osm1aB11PcKBLQey3GIWIzcNoX/dnQ8WY0AN80p5zRTiPGdGjwo3l8VuA9GfW8l/1
         Jghw==
X-Gm-Message-State: AFuF++n+6vWucI+6tZY9+GegkhapcZQwUJKnouYtzxyjOnqh5Llofw3i
	lnHXXuGJE/AAvGq4lsHfdNwtlXLlRm3A1se3vTT+uVZtca49xJh8T+0ByUjY9CQ6iqOJREORSlG
	dFf3z7giTJ0yacBOS0ZBCSPbK26YsGJgae/SH3v9jACZmHwio
X-Gm-Gg: AR+sD13BoAIOD9nwf5gDRDLz12hrlXck9GfP3Za7Asd7WxPTbXzLFUtyQwf2FDHY8sb
	vY1chKXraL9zYODA6/ny9pZqLjboyOgSnhUpFElaRV0sDfphKRgC93mlr5CbxDpcfAvK3EelFUT
	zmFC+DAYzZdc16c0mfy/eRGMRVmYc9dpSnxDwH1jRpGPmfYvepsCn/YuxMOD9/zeyhJIe0FvtwM
	NcD9h1aTCi6Dw5wEi+nSCfkKW0URN4O3U4WpO6Cb2DWs5nEKBmpv2hdlfyR/wwDwy/Bkt/4x2yD
	1rvwBzqYMPYHiJcjA1XoA0Y4kWcalROINgoH0cobB5iKIU46H2Mb5hSIbMXFoJxOUgBeqml8iLm
	AQVEx97oOxwh8vsNyjM5GW/L/OB9YbZ6ZbQ140cFFfg==
X-Received: by 2002:a05:622a:258d:b0:52f:b495:e9a5 with SMTP id d75a77b69052e-52fb96fee36mr249069421cf.37.1788086012729;
        Sun, 30 Aug 2026 03:33:32 -0700 (PDT)
X-Received: by 2002:a05:622a:258d:b0:52f:b495:e9a5 with SMTP id d75a77b69052e-52fb96fee36mr249069061cf.37.1788086012274;
        Sun, 30 Aug 2026 03:33:32 -0700 (PDT)
Received: from [127.0.1.1] (bzq-79-179-7-133.red.bezeqint.net. [79.179.7.133])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ccf5a580esm69304005e9.3.2026.08.30.03.33.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 03:33:31 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sun, 30 Aug 2026 06:32:24 -0400
Subject: [PATCH 2/8] mm/huge_memory: use folio_swap_entry() when splitting
 a swapcache folio
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-folio_swap_entry-v1-2-7786b52acbc8@columbia.edu>
References: <20260830-folio_swap_entry-v1-0-7786b52acbc8@columbia.edu>
In-Reply-To: <20260830-folio_swap_entry-v1-0-7786b52acbc8@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788085997; l=817;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=yJpb5yXsQPyDh9y91Xv6B3Jj3WvQOE9ZIIlAoBgKruQ=;
 b=+ysgi6e+YYzjba7Kbk8hy7m2fCoWccIAS+tbJjxQB2LPO2V7RurTdl/SokK8TRW1vJuuYPC8N
 qxEfHy6xQmWDblwBJG6de6eaGjYBHD+8C3L2bA+kHiwPqHj1nUSnpgI
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMwMDA4OCBTYWx0ZWRfX7x82xk5ameCb
 +WQ1qidzu3uPBPQp6l+vmASHb7yqY/oPW75QaL+PsLnCA27S9elncl0TGtx9pULv8+6HgMYRBZq
 15Fgpwg3OBcuDTUdF9xQHa87Xqx1oIEaVHxbhgutyaGK606s4xOnd7LUlgcBWr35C9nVYZUUU1E
 AXnY27HVaONeWvu/xNUFhPUZm958u1Qj39EWv/beF+nZEJDPTLpIa5sNZXy0NkMtBZopOmafAiZ
 rpJmZ7bUYho38JQ0VnssdcYVcihRhli0vOOs3yaIwPvcpldWLbydxl7hN6MsRlCjG0sxRgn02iA
 UGZM7Cn9rHSfv2vUdYV56R9ubu/qWqIMv/CO7IXBwDRaG5QFqTVPGEUmiepc/u86slkieGqeF5L
 psuNvJnB6IllRQqm2GfLdMp5pnj/YXDCHwb4PldG7B+270DJy3A84Bwo98pVZ4iHotBeyhkm1Iw
 vfKWxw1rsKa/mjkMJ7g==
X-Proofpoint-GUID: PoFlD3mjO7c_LRAcjlcMTogz4-oZ2zVH
X-Authority-Analysis: v=2.4 cv=PeDPQChd c=1 sm=1 tr=0 ts=6a9406fd cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=LRATYcvZeiQrLRB5MfbBvg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=AaP-W-LBM3jM8pgIlokA:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-ORIG-GUID: PoFlD3mjO7c_LRAcjlcMTogz4-oZ2zVH
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMwMDA4OCBTYWx0ZWRfX4I6DPjrJ+QC/
 /WRgAJs7XcXWVQnf7JeR0/3VvHU2lJVgGCEPTVS862GlDsraTHs98/9ZjNryH9wUuJx6OJpYS74
 H4zPHbXg6Ue+m3UZCWK9oK5syg5q7BtbyQ9aBhOWLXNhQHk4Vkha
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11890
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 impostorscore=10 clxscore=1015 adultscore=0 lowpriorityscore=10 bulkscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608300088
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 572491C0003
X-Stat-Signature: m5ktxnzday4eoydgy7zizij7tj99iaa1
X-HE-Tag: 1788086014-346068
X-HE-Meta: U2FsdGVkX19i2vWs77ZrcXCVlRWqBPb2qN5FRY9OCAvyJZHwjVaTZchxCSZcGpNXDB+hLMYmz5xl15QjNA/5higsqjLsLf+D5kbmJ21PM6GhT05bzBrQ8Hs9/qDtP2C95y6fv5Qkco9asS+bLrzX+TX87TAayEr+TTR1rP+356WEvaOyogs1fuVUt2FeSxG0qHenrk/JeWNEOIG9MABjeadGYlf6IdtS9ztOoYwVD+pRdQ4RCtc1MJB7dXBbJOeioN2PcIPNWi6Ez6zLXqBpavjKI2XzfDJaTUNOLaRqEiOGiXIngxqmaTouUMABDFLz8kZ6hrV31VPsHIdjmh7RWj/2Xei5MACbOoAxS22ACj4b9MNC50GgLwgKyBTkYuweqQmQFO7shnmey6/MisENbJkhE57B5Yx1xrqa6+LClvRYRUqQlPErcl/hX3i4HTwJtz6AfiMw/+SM7JpvylzhHVFJKWrAOVAFBK8JYu4cyXuLUNRXexJRjjnrl2M4rhqK9XVDAXjxkL6xO7L/2vM6m2JoG7vRDg315la7yWsLICvP/vAxwCbXQM4DV5fEdBRvPjXADv/T6RpEu/Ai/oDJz2RJdoSkcZ3jT8BpcoV+IfIzJVUVqFpdY7FfDnss9BJVs7NMVA1z6FQ8nKBAoexr4SneDDlFvA0DgHqgIa3sNgZ4b0R6sUp+Tac/e5gFZMvWS49eJYsRUAA8OoTLW3ukXFTfsAvRETBSej4aM4l4kL+/foDBfKCVwqlNLmgCIJgDXj9X7rsrk7TLTl/9xHJVX88c0WJONUki/Gkp7owzZBNmoH0AOm2tgatNkVrUSihJ2wu939l0BHEINucQuOOJf3mANwHTShoAfWV5HURgniLO951lwhe/9D3C+ZF66liCx65H6LSI7PoiIzesRQ6Aul/A5YG3/ZW9wukoTPFmeifi/5YlcmWlhcsJ3qiqxOJclxh78RurEvebvYHf9az
 J5FgB4Nv
 qbBjxBKIUX2lHJ5SBaDNLZdW8yZ+piKTjfn+RaiqglQxKIV85BlZHF9u5TKQ1GJK669KBKHu3CGQPQv+/QR7NROUcmiaJYjZcE7+OwJbEVbBMSBBKLLSPMrbXaOLX32tSOvqBY7qOBpdmttYeQZdl5se1HGPMVma/PqoUB/d8SEkkcevYPKR1KorHvumkRspn7DBL1e031HkbV1CXE+00zP8e1GZr/VPrfLWPGKog6flOJbDUbpK0FPG3a5itadOc0kz2f/WqNJpwA37appKXAv/bjqdc6BIswRvB2Ohbuu/GyaMmUfPso+i2dMEf08mgmB/rxUhZZyHF8x9ZNjopVcPOoKeBj63BNwa2cKdKzazcxqUB66eJK2R6rClLOVYAv7hidk+iCgApYZcXuTb2SskckiILpD+zd1GTEx1KwEcsGNw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__split_folio_to_order() open-codes the swap entry computation for the
split-out folios. Use folio_swap_entry() instead.

No functional change.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/huge_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 54494c3fa983..03287f995d92 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3760,7 +3760,7 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 		VM_WARN_ON_ONCE_PAGE(new_folio->private, new_head);
 
 		if (folio_test_swapcache(folio))
-			new_folio->swap.val = folio->swap.val + i;
+			new_folio->swap = folio_swap_entry(folio, i);
 
 		/* Page flags must be visible before we make the page non-compound. */
 		smp_wmb();

-- 
2.39.5


