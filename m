Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3705FD29DCB
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 05:40:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DE086B0092; Tue, 13 Jan 2026 00:40:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 988086B0093; Tue, 13 Jan 2026 00:40:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 836486B0095; Tue, 13 Jan 2026 00:40:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F29C6B0092
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 00:40:17 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1FCAA1AC172
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 05:40:17 +0000 (UTC)
X-FDA: 84325840074.04.0278D21
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id AD44DC0007
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 05:40:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=BEwPZBBt;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=YC78kN4W;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768282814; a=rsa-sha256;
	cv=pass;
	b=sEYXEghv8JVrxj/xE8bo2yLv9sVUrbX/w8XoN7EKgo0taInLlcrRORRvqJHw7uJmNyCU4W
	YOpe/oLGWYBN7YV/DcjFcR/0RezhwMfVclReI/Y7HYGnrPc2g4hjL+JOWeIdujMvyR1a3c
	ZArufyUIF8g9HK2FxOp7Sy4ZkQUssi4=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=BEwPZBBt;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=YC78kN4W;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768282814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aEN2Fl9q7yTdTtBFq77q8wU/3bjfnKueXrGWAZLJRN4=;
	b=yp7uboc1qhucjC9aZoGm4KYy9MJJN8EpiRo6xu6YaLYxPiXTsS4bRNFUOoh1OMsQ3ddLYx
	EwtWgf1aH6HXzNFnI1lHzbuFp5STTZ92zTHzcSmte2+t8W4dWcW+io9XUa8im+optrtCM4
	BVHBILuqsnrSs4GyW6kG+wf2N70p9hs=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60D1hJRN2677774;
	Tue, 13 Jan 2026 05:39:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=aEN2Fl9q7yTdTtBFq7
	7q8wU/3bjfnKueXrGWAZLJRN4=; b=BEwPZBBtkbcONWmB7+PAVk2PZHA7MYqz0y
	b1KENzNFmfd4Ob1qWET6emKbivWO7B4YBG4OASeJfTgn+ZHYDqaExatZaR86CghG
	S8mUjErmZUkjgivCeDu7C6gUYgVKAAP2sjyxuPOgJOixs25pu6XWS/+sEdi5kBdC
	Lrcdja9iUV5K98os84ZbwnZIWJ2CCuRU6pryFCGBRcG69jDVKcWAjr2UJkg31TeJ
	0s84wE3oHE8Ddnn57MKio1ndWtbkPRX1TMZEFJrxCcpkBc2ewFaHoq0co721hG/l
	YzUeXgg8NUV/Nz6a3QWYrCfOhR/PDlNfTZU4+Mu/VKo3gUWYE/cQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkrgntv5e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jan 2026 05:39:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60D3tlAt008289;
	Tue, 13 Jan 2026 05:39:38 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010036.outbound.protection.outlook.com [52.101.201.36])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd782e8e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jan 2026 05:39:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CRARzMJlK/DuIY0p+fjI2SIAy1DGlHxX07N7a8hqvDcyUXU+qbpse4mj/4CtACT1SbM+X4+N4+23F0t0lQiUJxWdMenSS3zLwIwHgmHwzbpu+sZCyPsYV+KSQCaIF+e5qFUAx054/j04xrei4nqagT1suFt26cRkkL0hpB7J2wVVX2wx7KUJ0xvpkjTJwdefvMrgr3eABMaa2UZn5bFtI4HSvc4+9+T5ajrT/7IVX8Y1RvOvx760R66bplMekHTikjPawjgLc3ft3Bx6rdeXbT1BXkh310Fr3lGL44IS9y8tPUoocH11BjrFOJ8xM/BJbq0FMv27o93qwCAwpFjdyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aEN2Fl9q7yTdTtBFq77q8wU/3bjfnKueXrGWAZLJRN4=;
 b=tEwecTIt9rH4ngrxF/1PVI83PEh50j3QOdNlCDZ+oMOATs6tuZSKvrs13K1jH9h5zoZlv8TbXop0nHVc8UGLCS5btd/ILnKStB6FrnjguAfr6nyt0a7x5nzrgi6djB1+4wM48/dLUX9wABP95+C/nwuOVLMg/U8Tmvu1cA89HSIfJISP71pP5vlFOhRl9c82djuckVhld/3aeqBCBzsHqTeJ/eGPe+M2dxE8tTf1qglxIs2F4JdzgKCsNOP51Vtu7VyWNplStBw3T+FEHk4sRaKK2gAzSz+y4vmbl+9YXmGMtymWMFF+cPbXsl14vAu8CH5CvBBzOVOxi96tujXkFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aEN2Fl9q7yTdTtBFq77q8wU/3bjfnKueXrGWAZLJRN4=;
 b=YC78kN4WX93Yc1pNm/sLLGPtv3iCt4aZhDATnQeu5xsVzI2n1oMO9k+O2NTUSeJwAy0IrWfpTJN7ifW/e6/PpVew/4h02TtG9c+RyTlnFuUJSj8bJLXDrblRMlvWg85rPi68YBGWdEkn1JEx09FbpJkQSVFCj3ebdEGrNmashTs=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS4PR10MB997671.namprd10.prod.outlook.com (2603:10b6:8:317::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Tue, 13 Jan
 2026 05:39:34 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9499.005; Tue, 13 Jan 2026
 05:39:34 +0000
Date: Tue, 13 Jan 2026 14:39:21 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Jiaqi Yan <jiaqiyan@google.com>
Cc: jackmanb@google.com, hannes@cmpxchg.org, linmiaohe@huawei.com,
        ziy@nvidia.com, willy@infradead.org, nao.horiguchi@gmail.com,
        david@redhat.com, lorenzo.stoakes@oracle.com, william.roche@oracle.com,
        tony.luck@intel.com, wangkefeng.wang@huawei.com, jane.chu@oracle.com,
        akpm@linux-foundation.org, osalvador@suse.de, muchun.song@linux.dev,
        rientjes@google.com, duenwen@google.com, jthoughton@google.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com
Subject: Re: [PATCH v3 2/3] mm/page_alloc: only free healthy pages in
 high-order has_hwpoisoned folio
Message-ID: <aWXaiWI3v_PJOKDL@hyeyoo>
References: <20260112004923.888429-1-jiaqiyan@google.com>
 <20260112004923.888429-3-jiaqiyan@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112004923.888429-3-jiaqiyan@google.com>
X-ClientProxiedBy: SL2PR03CA0010.apcprd03.prod.outlook.com
 (2603:1096:100:55::22) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS4PR10MB997671:EE_
X-MS-Office365-Filtering-Correlation-Id: fddc47e1-93b2-4245-5b5e-08de526621e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Lmd6C9H0jaiAiIpBFSt0jnmJTD0l420Y3NNhHFDaDALx6crCnwo4CtD1BNkp?=
 =?us-ascii?Q?3YZ3ANSo5WeKNpmTBW8xP7HX6TXLdcejPttDySxCYsSwKcH94rRSl/kEr0DR?=
 =?us-ascii?Q?MxFIiE6gjmue/udYPfjkQFkNUr7ebgwi9yc0HyuF/HpKjPShDJa76bZ2G338?=
 =?us-ascii?Q?Tjhsv0ZINrsLKG1OiiCQ3gf3JDJKeu/V/WspcZvC/9GgHupqttQYCS41FQXi?=
 =?us-ascii?Q?kFNvJDawEQUNhimaOnW3xpdigcUuqBYZF0pdGzNBxQKCcH2m8cJhkxUIsm5X?=
 =?us-ascii?Q?5zG6J1NuihJZE4J3PVV7P37nINO1ix5RbaTxJaLtxYQqOEAFDx2Pc5DoH8Hm?=
 =?us-ascii?Q?W+AUma7Luv8M1VJdVImtDrDM8XR1HbAOGcIrn+/xS2y9zHN1PWJlSl91qOx6?=
 =?us-ascii?Q?SXUJe8X+lWJz+Fi6DEpK8GfU5VTAkjeWrrry4kLprOXxGtPVmS6dcdRr1mDN?=
 =?us-ascii?Q?PiLpMZQx1LwJzFkvvqyXT5P8SguAS5oQ/VeYy2Q6sS6SKmcqfETfijtimUpK?=
 =?us-ascii?Q?51/cWHn643N8MBBa0aapYG2KLqYw6QaHoBMsmaSSuQV+NmtPe6OWV+3QNtcL?=
 =?us-ascii?Q?gR04hnshBfdiqX0EnSFPpKax+7vfcCIuo4Nr9y7iXyeNoa0ustD5NowPDeb3?=
 =?us-ascii?Q?vEdK9BEd6Oo/5qVAiyoVclBcmOWs7BHcMUtxo9+r+F7Bm9tURVmgvK6dC6KD?=
 =?us-ascii?Q?whuRoEDCpAk1vvMQZtffmTMKvraGpiitA3FeUfWmIWXGBvXQmwjNTpnV2GbP?=
 =?us-ascii?Q?6fir9kJY2MMA3rYJwfo9y830ssfvYg/jg030PGUL/RB1J8bEy1thsiYKLH6v?=
 =?us-ascii?Q?eb16EoeBkLInUzuD2Du6O6Z+FzGLPhE8FanyF76UVhW/RJdbanVG5U6Z1/0s?=
 =?us-ascii?Q?VazmEhl2S/at0TgoGNmdS7O0Ce61xgXJ9e3QVqPpEzLrGKx+I7wfF/ZJCE5X?=
 =?us-ascii?Q?/7RhPd0IOW2/Ghr+7MZIh18H6peRTH3Yv3qSFtatpITMaUUCR/cLoO+ZGvSq?=
 =?us-ascii?Q?a2toIBlZCxZ9CQv0Pribl7GY0gvejVKl0XxytlTBYRfDgumBwEhcoKDkU9Mp?=
 =?us-ascii?Q?wvenqQYMEHl3Xhb3lSxjos3k49vaxMOJh96ulDrozwyqA7k1Nl/TBUhzurZu?=
 =?us-ascii?Q?6onmSIbRwTdJdROolaZiH7CIGbbtaF2b3kPg/wMY5a3fVbkP2GuoorCbQovJ?=
 =?us-ascii?Q?miJ+Wke3g14pi3RpAuPSdTqPEbekl/f+kCEbhX4ENpjageUc40IYqvq0IUhI?=
 =?us-ascii?Q?2xZk01/6e3AV45c3mNq9wuDV2N1F7pX5mrZwjK9eRckkK10wNfXFNgpKObqS?=
 =?us-ascii?Q?A4pDNGsyERaS7RB1+WvPg48tvOx/bCV1C0Np1Q6MucVVmxUFro3XF8xEb6fB?=
 =?us-ascii?Q?73N3s4JZgd57xwzS8+VBTL7edeHINzfeV4yJQe6A1NSmOAzDJ5m4bPIELFyp?=
 =?us-ascii?Q?Edxe3wmloP5Q7EOHxLDuuJLLIyAGHy6X3W3V2F7dGD3LUMo8fcfkHw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HlDj3uvGAKjMP5U+Ws8Yy4KI+WyISvfVNLvIJUIw6V/eWRRxdzA9buaqlLhR?=
 =?us-ascii?Q?3YT+uJf9MRJwa1wQaYZIuLF/wiOmuemGSczLyNzlAarY+5MdmCCSR4O4hU3e?=
 =?us-ascii?Q?+9Q1S0PG4pCmbFHEVnRa0wmguh+0idEub7nheRb9/2wiRrCyNaclLH9U5sFY?=
 =?us-ascii?Q?I5R0undBaCSFF2XWGWkwd8S/J0p8h50q1CIWTfELFEoJQVALzZ+qsSWKucLA?=
 =?us-ascii?Q?1IGvVQZkpPEyteWyrCxSdm0WjozolGYrturi+D5Q21x2Jqql4vYlUXFRRxsn?=
 =?us-ascii?Q?jJYlfCNoP/Aj0v9llHNehtVU6WzfDIF5Kjm87O+CRBSRZNDkJt8lRceyBKXO?=
 =?us-ascii?Q?49iQUqkhZ74V1JxnpX1RDFkKF8h0Vfu8Gj2LCxKASOrCMRRqmIhWl3xLS0OS?=
 =?us-ascii?Q?/yTgV8RTX4yH2+B2itxvjhOW6rXfseGuG7y3jacgT5oT/VoeazvlibdwynWV?=
 =?us-ascii?Q?f3y7rX1ziaj+yIGUh52hVDigPlr3SKnaXyi1EmuyK092N3XvMwLrQeacV1x2?=
 =?us-ascii?Q?8dfDzUMrrMMQCHnJ4SFU9SYs3G9haganL8lRRjT2VOPH4fc0UtWqrFMoAAFY?=
 =?us-ascii?Q?Suiwl/wSYjKkpAV/Re1+/YTeo1lNGxNglip62BziPmHtRyjP0kEvkvxV9txo?=
 =?us-ascii?Q?grM+dREGTXQ0OaajxowP3VCeWOglIOUiWFAZa7ua7GfsoMjtL0NGgLNX8hyu?=
 =?us-ascii?Q?VaxzjgYzxaaMRXOlDlKN6iyWe83mbRwKT/6fKTDF7NLTeKjWVIcbnpesriXp?=
 =?us-ascii?Q?j70pR/8th99JBjCdx1Zt5wWIG8vnaBo/unoKsdv3drIQPhU0z1k0O2hRmmuG?=
 =?us-ascii?Q?+qMV41APoA00nPsJ25i5HD1NDfL9kVY2VwdVuq8JGbD+8CVGYiJvPkJ1vsuB?=
 =?us-ascii?Q?F6+Bp2Xfwnm/QSLJ2dzRWSf1w8YxoiOWU6EXQGLaaR9vH6vhWbhOP946Ymjw?=
 =?us-ascii?Q?ReQ1hdikEduVlkNJlH7n0go64waw1FqCKLhV6beoCDSu6awy1CKrLtE7ZorA?=
 =?us-ascii?Q?lNly7MaafgnkCMIjnidrnX6zNr1PY7Sq0i/gEnf6aRVF3wQ42eI0OBZ8GFHh?=
 =?us-ascii?Q?jgZZPfK4/AxHhxQfFAStxompQOO9nv3HOhojEftXvYhxlhLgYdqscJSTGj6o?=
 =?us-ascii?Q?eljWNJs1/QCcUreVpKjrI1Q/NE/uEHSXoysMVPDHui+QFyFVzKFePe5EYq80?=
 =?us-ascii?Q?TJxhdq2IczrkGcqdRay6Kw5MqCFRu1iZemcenBlIMAUdtIVsQGdfdh2mLpWI?=
 =?us-ascii?Q?f2WBrI555Z6piZp9PrXsBDa0ncCqBG23RQc9HlH7bmB0DoJ8RBAIBPvlA9HH?=
 =?us-ascii?Q?SXGA79ukA3YXk0qIJQQte20MnrYs16N+jzaEbaecsYw/DiEPWg7LeMOiwO7c?=
 =?us-ascii?Q?GIjiDwAxHWTBASL1SEVBUiTPlTZUoVnVOIk74L1zIE4ESIm3JGEk1KvtAVra?=
 =?us-ascii?Q?NNc/U5AndE/kEISISSWm6RxLmeJw23Yr6i5PI5bgClv7OLau7Tt1Axs9uLTc?=
 =?us-ascii?Q?7oHmsaYFoA3zcB5JAgUmqWsTXGyerKkvIe+mEKU/Qr5Qxi65jX06NbgD92ar?=
 =?us-ascii?Q?EgE2v2qLX1F4ygSWj1tuM2qxdLvB7j13R9jUECjQYccOCclVFJlEaLXAdEsl?=
 =?us-ascii?Q?7LuLGJ/wV/PePnMoabOU8XcM1nBLi8KVgRRrR0Y14vfqqAt26YI5becRUkY7?=
 =?us-ascii?Q?8hzQL9nfuHMYOv6jZ6UCW5DtTo6jlocjMYdd31RIXsbhcPpvaOWw19+7NoSK?=
 =?us-ascii?Q?pwG5kIhOFw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ks0cQajcB7Anuzu+8IhBguZnb7L+3ddk/zPLzZ/6ppkkN9DC16pQ/Sk1LjeEYao4Y9mPy3ok3U3VpqeoIk38HbGpcZhwTFIpMWpKsYTLR+WuyZXOBnhK6+p3zNgJoY4vpoGgXi4+tGYROeA7kJn1dGhsacROJMTO6KcZrPbb8N3pKJqVJUTxQZ7bFdXQpBuc5Cra21TnuCL3jNW2lUvsqZiDTJs98fBli7DtF6t63q0Sm8MoxfZLgMtfgLTEUmBVThY0mPGcqt2KpJGDmEWP7YmU5sDKXpqyPqeZovqYhWi2AyHSLlHpU3cexTwfD49/NcwyeQOrdiR/MtXaJWMh4Dar6JrMOjdP9PPTQJCZTwmf7St0pPwH5b+/B60mNaJ7eO5OOKsCmBJf5XD1+jWOkqsZCsMyobZnBU7mHSkYRDl9J6U56rXYRFH/243oqQC0fZtW+V5ruzSGafjvQP5CMAThktJ6HbwVjK/sAv9KUmgXXuFeixNi3e+thwtO/FeZR2i/6HwHETeDTH8MSA+GF6t9B7Ci6g563jX6bhezcqJdCfyZ8SVWTKzW+IUVbLLn3QqGczL9ggVH4HIPqlU/X+4So/cfzPXRl24w/C/Kft8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fddc47e1-93b2-4245-5b5e-08de526621e6
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 05:39:34.5608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8gYT/IudjR+HnVugILNykRFviMdlKpatxd3ErHwlnP3sJNhCFvc2X3X8B/C9H6AkbPestDpBy2Ba/RepXnl6hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR10MB997671
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-12_07,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601130044
X-Authority-Analysis: v=2.4 cv=B/G0EetM c=1 sm=1 tr=0 ts=6965da9a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=R_Myd5XaAAAA:8 a=1XWaLZrsAAAA:8 a=HNhGhO4dleL4Q1WbMiIA:9
 a=CjuIK1q_8ugA:10 a=L2g4Dz8VuBQ37YGmWQah:22
X-Proofpoint-GUID: 1emzlSnCFZ8EgWaRSEOZnJox-roSX-jd
X-Proofpoint-ORIG-GUID: 1emzlSnCFZ8EgWaRSEOZnJox-roSX-jd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEzMDA0NCBTYWx0ZWRfXz1F+Ibghj/jR
 5eQT+iJ8EN8JDGJKYPnS7kANj/MUacjVReCpXweozJRui9GAvTDeujnIGBrkv9crwUnnocHpZ3j
 pQSPt34yETm49EcD/B+NSJAtbBe6x3S2uRjYTwtBnsVUFDEmZqWTb4VPHoDFOLHgHc+ngOxXjPl
 /p+vZJgepFKiMTA8dETlkzA9Dkvz8VYP/WnjmHyHik31xLlcUJzjI2boDylHfqL8PRIv/0i45bl
 NXSsBbjBEtUk61bniVLwNHt3OKeXAALtXDujuFPhO4tJaDxehqnmHE3eeZUt9BHa6UZr3fE+ZJC
 4+FrMzdzvE1KScUmVOcVclOa4FgcLd0bTlRhQL/QEbXIT+vXktxYXMQlcWdEUVLUXneahOUcQFS
 YxFmygNjnqDsnz3GJLYDMwYFj/wX2oHWM1CbslSC05VJ+c8kSpyc+fwMTwvrurMR2BPwnxorX9/
 fRjMTQdAW5AmZf42MAw==
X-Rspam-User: 
X-Stat-Signature: sjda4s3n37chres3864f6pqg5zniz8or
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AD44DC0007
X-HE-Tag: 1768282813-774743
X-HE-Meta: U2FsdGVkX1/mPw5XsI+7fEIKr0B4+2BWMVb54sDNKFXzJA1ESP4zjBxnHb21ASkWPkQdzJqXV+Aj6a66OMYc7YVLeP8wsSdICqb1i0iPuD/T/pxfEadQARRTTnfuYcgOrZq8zp/G2hho2miPRKgCzM0bLfiZxnJakRqBOlDoT4a1M02+HIIxunOvsJZDU9mzUWSUrAxblATAmN/uIbA72BUdiJbcyP6jJcptQeIyAiRn/uBwysw5qARiVIfuweYuILu3fgGtiLGNYymUOGrWba+CfmlF/K8eN65GLmsYpcLfx4Z5/v+K4sWB2exGbn+7BjbUha313s4AjXKFwv5oRHELHtgfxPZ7FjrgGYPvDRYMdYcww2uKn2wxNXdZsB9eQ+uFWCz0XqpJYg+fJMYX3+fp/Ldi5S2eCc+mp4b+Sb+sjkkCCeQb1xrXrDRYd7juEXL3ZpmSluuwEwIbRkVq2R6fF1aCizUkYo3Ngdjfyf8nI0EmO7epXTrb2+vmW8FxIMmpDfoi9lGE6qgVhh/nWZs7WAYsPVNZzov9PNOax/e79xGmo8OKiKOV/lc8H8nDwr6MjesRhJXJrDr7H8qgYY+h/rlSqcywKZkhmCGJezj5cqgvudaI1RTJIcAVUcT0xG+w6bndBJQ9oV+NPON96yFsffD+50a41NRamRK1y4SiKzsJy+pjSxniH+1CcoplBmEnhmsedreY4qYwQa9IH14yOlkbI1Wbxa33QXDTm670pfcQvfErYQPT313brZhpadBV0iSV2M4+lLzFAMJvAtqRV2HxEw4T2oBhjVN85/EHeTyGrn7A0ACLgRG9//zcoWuHciYFn/Ld+SMI6KSh8QsnZhi2MNhFXJSexjkTNSXD6lwKuL0W403wL2Qh+QHZ/d+tcXz/IstIghDWbR1Lmq+Q+PFzqUZW4EI1W3PO6tuNFs2Zf+C6S3z/oD5+YOo3irUMzsVWmGoEODKQcni
 irSJ71Rw
 3m8J0rZAPvWnQCEIH+sdOV5D18wYAOa47H+t+P7VzBpJhCsUlaZ351HoySZ+n2KY6PsNv7iwUvKQXVw5r8ANI1MDO2a5lUZwe4iO9jejDbLGhOHz9Xojiv0LjYwj6iQGzdma9TsVPRfRsvPP4nxIikqy+pKjxeO034ZwD49l2L+Iifrdzv1ZVsCcN7Vylx2M6l6swk2GgKwtMcwq7Y+QKZICdb5J+lULuxPqMCnQ9Bx3JfA3A8GyjqXWyZT25onz61wmUGJ/R/wTlr1L9B93tiOha/BhCU0RzLV8uRh9DDq+DfZJT2GuV4MSnUJScKbr/I+yJK5qyd+ICwPeM2BewOP2AiJOUrKvlJPdTjdl+NLZ9spufuk9sBg/Yh/vuUeuwnopZPpfS0sjJyNl0G2RPH/RGqa+FQwKjOh79tp/a/PsUgA1UkAu98suqyQ9BiSEZX4IVzV/A75ZIOzgak6kBU3ysGkYFrQpn7ZUzDV/sgIyksby9pIn2E/NpPIvmI9xbpfTWoD3POqLNi4x/iWnPxkU0SzKmvDpJg12Zhv2wFKvFfW2rkuZbLaw1mUU0SNmt2q+7cM/+VW4vd/wsLiKJH6lMGlrZ1nI2ducNpEdvQAacvzAhSHfY/syyGGoRfTKHmVRKX1dF/GOxkfpHS9TugDJqVjei5X2qo4ob5SzyRvfTv53cgPzwv6c/fq6qNrEoGXplnpX6nsmvbkx46WUh3SJsKegRaKl3SAVX3fadSG9ETPYnoakuyFeNXrmRceX0UB1qs8HwedXY3wqjKznlpECfyf7SmD9Tx/gbJJkd39NEPOyBGtuWg+5IftpQNbfASHK6AyK7aNGFs69WRJo4jOC8Ig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 12:49:22AM +0000, Jiaqi Yan wrote:
> At the end of dissolve_free_hugetlb_folio(), a free HugeTLB folio
> becomes non-HugeTLB, and it is released to buddy allocator
> as a high-order folio, e.g. a folio that contains 262144 pages
> if the folio was a 1G HugeTLB hugepage.
> 
> This is problematic if the HugeTLB hugepage contained HWPoison
> subpages. In that case, since buddy allocator does not check
> HWPoison for non-zero-order folio, the raw HWPoison page can
> be given out with its buddy page and be re-used by either
> kernel or userspace.
> 
> Memory failure recovery (MFR) in kernel does attempt to take
> raw HWPoison page off buddy allocator after
> dissolve_free_hugetlb_folio(). However, there is always a time
> window between dissolve_free_hugetlb_folio() frees a HWPoison
> high-order folio to buddy allocator and MFR takes HWPoison
> raw page off buddy allocator.

I wonder if this is something we want to backport to -stable.

> One obvious way to avoid this problem is to add page sanity
> checks in page allocate or free path. However, it is against
> the past efforts to reduce sanity check overhead [1,2,3].
> 
> Introduce free_has_hwpoisoned() to only free the healthy pages
> and to exclude the HWPoison ones in the high-order folio.
> The idea is to iterate through the sub-pages of the folio to
> identify contiguous ranges of healthy pages. Instead of freeing
> pages one by one, decompose healthy ranges into the largest
> possible blocks having different orders. Every block meets the
> requirements to be freed via __free_one_page().
> 
> free_has_hwpoisoned() has linear time complexity wrt the number
> of pages in the folio. While the power-of-two decomposition
> ensures that the number of calls to the buddy allocator is
> logarithmic for each contiguous healthy range, the mandatory
> linear scan of pages to identify PageHWPoison() defines the
> overall time complexity. For a 1G hugepage having several
> HWPoison pages, free_has_hwpoisoned() takes around 2ms on
> average.
> 
> Since free_has_hwpoisoned() has nontrivial overhead, it is
> wrapped inside free_pages_prepare_has_hwpoisoned() and done
> only PG_has_hwpoisoned indicates HWPoison page exists and
> after free_pages_prepare() succeeded.
> 
> [1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email-mgorman@techsingularity.net
> [2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email-mgorman@techsingularity.net
> [3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
> 
> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
>
> ---
>  mm/page_alloc.c | 157 +++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 154 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 822e05f1a9646..9393589118604 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2923,6 +2928,152 @@ static bool free_frozen_page_commit(struct zone *zone,
>  	return ret;
>  }

From correctness point of view I think it looks good to me.
Let's see what the page allocator folks say.

A few nits below.

> +static bool compound_has_hwpoisoned(struct page *page, unsigned int order)
> +{
> +	if (order == 0 || !PageCompound(page))
> +		return false;

nit: since order-0 compound page is not a thing,
!PageCompound(page) check should cover order == 0 case.

> +	return folio_test_has_hwpoisoned(page_folio(page));
> +}
> +
> +/*
> + * Do free_has_hwpoisoned() when needed after free_pages_prepare().
> + * Returns
> + * - true: free_pages_prepare() is good and caller can proceed freeing.
> + * - false: caller should not free pages for one of the two reasons:
> + *   1. free_pages_prepare() failed so it is not safe to proceed freeing.
> + *   2. this is a compound page having some HWPoison pages, and healthy
> + *      pages are already safely freed.
> + */
> +static bool free_pages_prepare_has_hwpoisoned(struct page *page,
> +					      unsigned int order,
> +					      fpi_t fpi_flags)

nit: Hope we'll come up with a better name than
free_pages_prepare_has_poisoned(), but I don't have any better
suggestion... :)

And I hope somebody familiar with compaction (as compaction_free() calls
free_pages_prepare() and ignores its return value) could confirm that
it is safe to do a compound_has_hwpoisoned() check and, when it returns
true, call free_has_hwpoisoned() in free_pages_prepare(),
so that we won't need a separate function to do this.

-- 
Cheers,
Harry / Hyeonggon

