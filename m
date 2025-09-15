Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BEF6CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 13:25:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 639C08E0002; Mon, 15 Sep 2025 09:25:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C35B8E0001; Mon, 15 Sep 2025 09:25:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48A6B8E0002; Mon, 15 Sep 2025 09:25:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2F9C28E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:25:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E61391406A6
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:25:26 +0000 (UTC)
X-FDA: 83891556252.15.24FAC43
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf20.hostedemail.com (Postfix) with ESMTP id D8B081C0006
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:25:24 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=ecdJyacU;
	spf=pass (imf20.hostedemail.com: domain of "prvs=5353faf606=clm@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=5353faf606=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757942725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+OeUW4b0iTtQSlBksBON64DALPlRhQHDwWoPGx/RrlI=;
	b=rIM9OZ0gdm7HwHYEbHpi4mq9zPTVNd80/Pu8Stcn10GTVAgTxkgjTiAi+ulhJ/tpF7/ISP
	kxzZP1KBG0tCtmgYzG50rM/xKstzzkutvk1UIsXr7gY63/QInIcdES6wDvoi2dWRW9chs9
	SXX9J9PGiE0niaoZNqNcdZ8u741oF60=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757942725; a=rsa-sha256;
	cv=none;
	b=F53WSM1BFsUuRsGFMRrBVGSUVn9y5u04L3ZyIH9qnZrKNhwabfNUtpghPDQDOtUDJd6Wm6
	QYK+Fpu1GFsDBXETcx7hxHpevyU8u6P+LPxhVsrcNuoV5sexeqd/k+4A7N9rQdpocngWU6
	F5Z4nxnUdQL1V+1WXoDYczged1sEJDY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=ecdJyacU;
	spf=pass (imf20.hostedemail.com: domain of "prvs=5353faf606=clm@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=5353faf606=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 58F8W13W1036677
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:25:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=+OeUW4b0iTtQSlBksBON64DALPlRhQHDwWoPGx/RrlI=; b=ecdJyacUIINV
	ZyhlyY01Dnd0GhvqwNEvWMBpYKGM3FQe1wLbjJDeKgog4pbwzQBG91o7+1k8F41z
	a8UKFkE55IZtdvJj5GCziUaWFTwT3gdZwYivO6Svem88ujafjTUKBHf8x8qsNxvj
	PdpjdGL4BhkBuzLpFYB9AhrdjV52VduTtcgsgM89Blx8YE9AGi0sL0WxELPVhIi1
	9INSJe2mHYhQBt4lv8l2HIQ/mIE0cSQ8UMRIZVhT8O9g9QYqMk/CTx3cLYqnyEPe
	TDyaBBy67BIjhp4wpLskcHTxMzVffFL+A5owFKibfECjjSsi3IydrVx90MANXO4U
	uZAlnbZNnw==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 496fcahh0c-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:25:23 -0700 (PDT)
Received: from twshared14631.07.ash9.facebook.com (2620:10d:c0a8:fe::f072) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Mon, 15 Sep 2025 13:25:22 +0000
Received: by devbig091.ldc1.facebook.com (Postfix, from userid 8731)
	id A040325C3EE4; Mon, 15 Sep 2025 06:25:09 -0700 (PDT)
From: Chris Mason <clm@meta.com>
To: <liuqiqi@kylinos.cn>
CC: Chris Mason <clm@meta.com>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm:fix duplicate accounting of free pages in should_reclaim_retry()
Date: Mon, 15 Sep 2025 06:25:02 -0700
Message-ID: <20250915132506.2889372-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250812070210.1624218-1-liuqiqi@kylinos.cn>
References:
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE1MDEyNyBTYWx0ZWRfXwOwA+48neQxI
 3t0tWds5oTrTgrXv8+JDJPSkD/MRCxQKoa1kfGBoyZbYU0ehGGa+j3g/N7N8jvUch19+IN+k7/Y
 lvugqmOhXzYxmhLgRLOqdVaoP/ivuh/Ni8u8GaCeXIwxSpeeCPMxVLDmt58DHqCQ8eRpSDAfhjl
 qHaebvGKkxAfFOywe2j8xeBuPMAAkdbdPt7KxQlnp2WIjqNKT79FaQWoGRzaqg3DXxRSXadLXzx
 AU7Ba4KPy/gERXewckF8TZqm5w3LQUigl5BLUV/JZ4fC87I/6YenDbZHm16y6+4CAAR7A8FPEEZ
 JcskpyOSzeEyx0ZW/Mcw9J6OkudMU2+QE/ot00sQar7KtfXF5oTYWxy1bqHp8s=
X-Proofpoint-ORIG-GUID: MyRFUerhY_kFxu_xc1uMSlm03pJ11F1I
X-Proofpoint-GUID: MyRFUerhY_kFxu_xc1uMSlm03pJ11F1I
X-Authority-Analysis: v=2.4 cv=LoaSymdc c=1 sm=1 tr=0 ts=68c813c3 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=yJojWOMRYYMA:10 a=IEEH_mcYg3zSNz_hGwYA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_05,2025-09-12_01,2025-03-28_01
X-Stat-Signature: iuozwuk13gdep3p36deedb13dbgiwrxi
X-Rspamd-Queue-Id: D8B081C0006
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757942724-952136
X-HE-Meta: U2FsdGVkX1+bRaGYgsduQK7IJ9SXqlfq1XUtEORb8FmlDyy3t+z+/vJVtjJ80iBOM/KnvrNUAm88kDANMKjChDqxjAlAWKmY3BHM1LDvqMZS1qW+wGsPmEvBth5rJSb9+Et2inIUDrCYM17xqdMVzvaNHa5x9ZYfb/M93L6x/UyYRXeChrFRHCb3fOzU021oDRWyVyswXGm6HVA1cel7avntHHFx1X6VEdDteAi8mcMwt7BkOtxkBi0AZbF0aqpQ/ovAopg18HyUia6cjruc2pFDxbY4iyxNqdnK/Cm9REvPtTbNcWmnXNkuBfRUkD6oJGlPXwgfDb7x3wdcr3LqlI8xBA3jB09mlMQte5sA6W4XXxx1QUdBHrXs6sVlzpwVbG45SfupUEVGZNGtpbDRZILvXORoA1DLrerap82FpyqJELBbE7old2R2FIUrtUCcZiCNm8caEICV/4QBkBW2rcWS7ZhzZbW7LSYj2MomB0/sh7aDwkGs8uULw4ATifWlqDBpA8xTEDbmg05RIRQ9VTLOPQ2YLsbo0ITwS5EqUN84T6xz8BBfP6DbHBrzMRdHFhCvQUuVtWY+IQrm4OwKLGR6TGITcW//Z8bbtZp2/M9FSLbn8/+UEMjQjaisu0e6++88R4+HYb0yQYmvXCS54Jqy9aprf83eCijdLAUeR754kesmE71Pb9G+Itam0N51XhWX0idZwnYBqbp28QNogDEiE0HRWjJgMfV9KSagL05DJBKw1UIKQIFZWWFC47Revsn6HHvdFjx1a5LxUnbV1bShdRIsMY/wyym8zcjeLgrpcsIpr1XDZdvpltsBPgiMPGrj/j6rl9fMOYBTqO251ux5ralkHiNc+WQ8H292EBiRfbMF6EMCQzhYWWohNvcvRJ8VmNiee46ZtCFCnHzaE82duAgJaaKLQ2cV2x5Zx6MTJqeAUX3l4uF9nL2iIio7jVBSVTlRl91/pVELIpG
 TJFewEqy
 qxUDqkeCrUGeVqkTp8K2wpOt3M5daLI2ACeQtUe9AltxCCE/puQRsIGoyeX2F6KopQliwcOtONxqxN64FrCEG+XU5cfmpVxxajpaxvHbMwPOY1Hdh/zXYMyDYvUY8Wz+KcswlxocnkmgoUBpNPsVUS1VYHwHwcXjUje4zbvfFe+YoRiDFu2zQlNQ5Ztp0LWtFQF5QAalHL2t/ogM4gKP+LVm1JyeB7XfS9xyeE8wBLnemJSeLowglh6OIuuuEFohZ6MZBiDiOUyvywp7aoZ5MDsNV4vxOlkD9tiQe5CwZzSK2D1qmuRo0a4jJUY5YuGabrZGlv09h0FEbCSwclfKoGIJO5ckbOOypk7ydUcmaQkdYAyhIVL1Yg3GGNg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 12 Aug 2025 15:02:10 +0800 liuqiqi@kylinos.cn wrote:

> From: liuqiqi <liuqiqi@kylinos.cn>
>=20
> In the zone_reclaimable_pages() function, if the page counts for
> NR_ZONE_INACTIVE_FILE, NR_ZONE_ACTIVE_FILE, NR_ZONE_INACTIVE_ANON,
> and NR_ZONE_ACTIVE_ANON are all zero,
> the function returns the number of free pages as the result.
>=20
> In this case, when should_reclaim_retry() calculates reclaimable pages,
> it will inadvertently double-count the free pages in its accounting.
>=20
> static inline bool
> should_reclaim_retry(gfp_t gfp_mask, unsigned order,
>                      struct alloc_context *ac, int alloc_flags,
>                      bool did_some_progress, int *no_progress_loops)
> {
>         ...
>                 available =3D reclaimable =3D zone_reclaimable_pages(zo=
ne);
>                 available +=3D zone_page_state_snapshot(zone, NR_FREE_P=
AGES);
>=20
> Signed-off-by: liuqiqi <liuqiqi@kylinos.cn>
> ---
>  mm/vmscan.c | 11 ++---------
>  1 file changed, 2 insertions(+), 9 deletions(-)
>=20
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 34410d24dc15..a9aaefdba7a2 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -393,14 +393,7 @@ unsigned long zone_reclaimable_pages(struct zone *=
zone)
>  	if (can_reclaim_anon_pages(NULL, zone_to_nid(zone), NULL))
>  		nr +=3D zone_page_state_snapshot(zone, NR_ZONE_INACTIVE_ANON) +
>  			zone_page_state_snapshot(zone, NR_ZONE_ACTIVE_ANON);
> -	/*
> -	 * If there are no reclaimable file-backed or anonymous pages,
> -	 * ensure zones with sufficient free pages are not skipped.
> -	 * This prevents zones like DMA32 from being ignored in reclaim
> -	 * scenarios where they can still help alleviate memory pressure.
> -	 */
> -	if (nr =3D=3D 0)
> -		nr =3D zone_page_state_snapshot(zone, NR_FREE_PAGES);
> +
>  	return nr;
>  }
> =20
> @@ -6417,7 +6410,7 @@ static bool allow_direct_reclaim(pg_data_t *pgdat=
)
>  		return true;
> =20
>  	for_each_managed_zone_pgdat(zone, pgdat, i, ZONE_NORMAL) {
> -		if (!zone_reclaimable_pages(zone))
> +		if (!zone_reclaimable_pages(zone) && zone_page_state_snapshot(zone, =
NR_FREE_PAGES))
>  			continue;
> =20

It looks like the logic got inverted when this code moved around.  Should=
 this
be !zone_page_state_snapshot()?

-chris

