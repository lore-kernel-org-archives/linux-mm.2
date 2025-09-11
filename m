Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E04A4CA1016
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 09:05:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CC648E0007; Thu, 11 Sep 2025 05:05:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37CF08E0001; Thu, 11 Sep 2025 05:05:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21D928E0007; Thu, 11 Sep 2025 05:05:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0A3FE8E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 05:05:53 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A716B85DEC
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 09:05:52 +0000 (UTC)
X-FDA: 83876386944.02.6E74B40
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id 33C32100013
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 09:05:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=O4IXuryS;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=G1VHilxv;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757581549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BGBqCTpvnDko8BmRtssOWGS0++Bu2LhlqtGVxWK1nuk=;
	b=FDIMdMjVVRAP1AHNZMZSnIzkDJwu3+ffLHHVCjD/BD4LPPNUAsFuhaSH5dIC8DhdpvBo03
	PFEu4wTE5/H5z1KLEfObEInUA3Scv/+QbSb1ePCpTMkeThkQGXPzhu5T6WH4meMfMbLoKM
	HJL2BBvMIS5tVbtGVzBIMK/Nc51TmIE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757581549; a=rsa-sha256;
	cv=pass;
	b=0FpiMFEcsL1e6/M4rsMVD4FNqFBstuPCsp+ur2dh4pIqALjl4Hp1r3onG0QELqJOtKOd65
	pR9+LYBVjdsBSsoB9aNG+5mdfARQZc80JDXGDnw54SRnar83QGQUHURaOmkMCau9okOa1m
	cAn067/vpjsVzIzQe844HEI1onPnDTw=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=O4IXuryS;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=G1VHilxv;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58B8g0sO030274;
	Thu, 11 Sep 2025 09:05:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=BGBqCTpvnDko8BmRts
	sOWGS0++Bu2LhlqtGVxWK1nuk=; b=O4IXurySxD/otpMyKf4gNmGi6omXHoZrXb
	CO2hYpRGKNwCuSgCghD5tyjY9ebc/0vNVJXExXJPKbO4KKG+5PTv3+tikgCqMBxI
	Lp8iflNEK270XyZDIxJYxFQez6HgUhYStp0tN+w/h6YuILiG+aM4sqD6vAbLtAR7
	4uu95uO6IDH3BQYF0jIb7UfxKTyhrnzIXsjrsc+0pdmtPKt6nFrBQaWw/crKiGKg
	9fI2UJNpI7VbEgzKax+hlZ63QKWoQYqnhTxL5mnNIcjCxh3vKLOsGPsrtga9A4dj
	q5hpAsZYuiGPtr9trWzhBIcuImoikeN3uSee1XDGHWoxKNWNt3tQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921pedwwp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 09:05:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58B8XU5H025911;
	Thu, 11 Sep 2025 09:05:42 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012031.outbound.protection.outlook.com [52.101.43.31])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bdc77nn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 09:05:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cGdFYBoAX49hpDhlm8Dj6ocWmlGPHOeJC4N4nVsu18thsPb7lqgypvVPAewM8r2bHks3RFi7nZL9Xatax4bI/YqtK0Ql70y1PJlh+9lDvvIKJHRWR5/Pf4w+P3HzPtZK8U13sfsvt6XBiKUKAni5D1k8VypqagDLxi8gSzPiJimZ7MXg+PQKhyljrQ1ZCRVhURVF4uloydzd9WqxQm0ZGi7vLP9KMjo33xyqUQl+hpx223ZssQ4HJzy0eTSQ+KbZNny6zAQmaJ/2vcWyR5qF60vkZAiGz6hVTNXpTBtwb0r0vsWrum0affwTkSFveu9nbCAFp0GKcBOgNSUjcsZUng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BGBqCTpvnDko8BmRtssOWGS0++Bu2LhlqtGVxWK1nuk=;
 b=OMKV9W3/Jd6nW9tfUDDujNkwdc4QS1iyMspnBoyYVVMXQMlKG3O9oF+sQpa7+g6FNvlHU/eNEjiDhcxzWpWsr6EukbAh3phZzPMSRVCEfJ9CQPDCgPAPxUOoBmHDxUKflBpvISqUb8zfkeR0n8It+RO0ZU+8jTAyO1O7DjF7I5AVAnuMADp2cfYGQzREPNLxKmqPxwH0daapnUexOCvT3yurtGb8DxfL25xDCl7l+uPkIoteDI0UopuJCFVj23T2fQ9CApGHN6Sejg/v0P7ZxkyKp1y/zubAle0RbwER08VbzumKSxgelm7Ff91wdcDYEpkx45T7R73O8CjoJdq4sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BGBqCTpvnDko8BmRtssOWGS0++Bu2LhlqtGVxWK1nuk=;
 b=G1VHilxvQMsYqkZbrn2UDNnqcU4vPU0N4SNBtynU3n5Y91I0BWAmUsJHJTUVbQMhSf81FkCk65/kw2J1Yfub+Hb/xXAbUMf4ipkL/5rUjVNDEWIV2t65I7rR6y+q0XzOlxuvdVWyg6i/IZDwWmnN5FOqvlgVGS1Sj2c8yet8//E=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DM4PR10MB6160.namprd10.prod.outlook.com (2603:10b6:8:bc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 09:05:40 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 09:05:39 +0000
Date: Thu, 11 Sep 2025 18:05:30 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH 03/22] slab: Remove dead code in check_slab()
Message-ID: <aMKQ2iACohiKkDXQ@hyeyoo>
References: <20250829154728.3397606-1-willy@infradead.org>
 <20250829154728.3397606-4-willy@infradead.org>
 <aMFfLqkXcZTNv_p5@hyeyoo>
 <aMFjYbaUaQq1GA4c@casper.infradead.org>
 <d82c935e-1569-4ba7-9e9e-13b22dc2e4e5@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d82c935e-1569-4ba7-9e9e-13b22dc2e4e5@suse.cz>
X-ClientProxiedBy: SE2P216CA0098.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c2::11) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DM4PR10MB6160:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f6c4402-edc7-4778-ed9d-08ddf11260c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WGHDX+UHsqXtFsIX2DGz0Qjg9oYipoO/skzyFukHKrxwlxakArZI7uAFEjNM?=
 =?us-ascii?Q?/OKyk6DJ03YJ2nuArOU4KwVASNmUvR4wil07BeBEpA2MOll3Wuxg16xKsKUn?=
 =?us-ascii?Q?WQuuNrV6sXRKyhYyD4BvU/dhmQmwzC5FxeghyRSX++jEAXcXHwWDHJ64DNnj?=
 =?us-ascii?Q?aFZGHruCaKUpwMA4cqTKE2bOWwoProR+z1oFGbgwpTv3RkG8qEa6dK1Dq1ju?=
 =?us-ascii?Q?qEDti82+LicXxuqe76nCHMxZCp76eZEsMRTkIATsvbSsnRetYk3Kvdpvband?=
 =?us-ascii?Q?Q854ynjIz5aJx9sh+LQmo/hwM7e+qzhU2gTJCV+QQHeIL7YoyLfbriPkt0Vj?=
 =?us-ascii?Q?Fn38kDXKA58a70UfDRVWpmmcUicpfm5LXm8qBHFFSyJ3EmAxJ3zYa+o2v2D7?=
 =?us-ascii?Q?lYi7BM7fX0d4s8829Y9c/Dafb/wuJeE3MH7QGMTW3wewgKcOh5XCWuLvxz2C?=
 =?us-ascii?Q?eKp+ekI9/WpTdIQIJqY42QxUY2l8Vok2icRyOP5zIBsy4mI1of+AV1miMYvr?=
 =?us-ascii?Q?BfcfqDNN01YZiLfYi6yTktbf9+ilJFFQJNUDziU9WTFDn6mkKRlg25f1iZ4S?=
 =?us-ascii?Q?pAcny9M2LJDbayBLU8X7u5jhFluf8h7E88dXseg1x1ZpOp/vejQmmKSOgs1C?=
 =?us-ascii?Q?+qjUp2Io8F7dOzRSHjPrDPvcbWS1Ay16hHUpgQigIGvHXr/W0FDjca+c+sqT?=
 =?us-ascii?Q?nhQ10XsNOcG6PvzPjzZe7Za5KdcxawlsS98pil6V5HXAW2Uad22paKK93/II?=
 =?us-ascii?Q?WIRR9hFgZaxdb1nKpqAbaEKQ1/UQA/iy0F/JvhD2FtIF5yiVJy4y9XNo1L8N?=
 =?us-ascii?Q?f0O/fLpn/3JUMo4jRUB6aWjjmr41X+o/bD1+xcgfCVfNama1H3SwkNlCm1FU?=
 =?us-ascii?Q?p1j5RD6hklNBWPH3/F1YKziTR7Bl/D/S+vuLgLZ9eDxsZiLoPakfe6u2e626?=
 =?us-ascii?Q?Pdmt+gie54TjAOM6MGjiH5BOaMz19jFkDKe8A5J9qFPO5YEGd/3/CvMH1msi?=
 =?us-ascii?Q?8EbqrcFIPAgsJxvqLj8Lic86QWcKyxZsxwXlvrCvRlM9NAu7Dtn8cdfX/btT?=
 =?us-ascii?Q?oZiWoZurwgVP4iH2VD37vwt4R2jBLP652K4IfrNDvvXt9md6+5LsPqgfFkpe?=
 =?us-ascii?Q?INCxXhMG+jFk5QWLZc6BYQrePGv/vVrma1rGui0jUIooiBA7gwXTYdmuNRgh?=
 =?us-ascii?Q?x13+nvO2kO3Kzg97M9g3og+xscidS+xGxxUXaUdM/Gtz9m95zZgp8gaiAfdy?=
 =?us-ascii?Q?DBKQFD86AlWFInt1sCW2Nob5CWtaIr0MUkzLCvEm1jj0+Nn4i0IgoDtBUTU4?=
 =?us-ascii?Q?HnBXG+Ce5DJ3pkBz8mFw0GpVnvCXVGYsWYh9xCKyIqOA86qQRsZ8mDWGiAUK?=
 =?us-ascii?Q?EM8e2rjxcBMTGSaj36Zd4l1+2F7scFx0nhXUYu+qnfbPj/RkjxJLXVNPydEa?=
 =?us-ascii?Q?65RJ0uFat08=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vK4SISqJzjYx9l/8IwsxcmQJ/GmNNNUMY2lkwLkanXnkeHnTrjH1mU9B1wfd?=
 =?us-ascii?Q?Y6ZCg6g97IWBpiOojw/cXqb3mh2pLqEvJiE/f3BJAEt2LBujS0z02c3FTH56?=
 =?us-ascii?Q?dc8f1vz3z7YLMYRNvK9+r2I3JcJ1g2mfuFuRkwtyWjgPfaDkNcxkv3T4q9bZ?=
 =?us-ascii?Q?SM/7b/12bKx3Xil3oyGVGS6KEfgO++VFYwSnRfj4k1pYt9u2Cbg/4ycoY4fg?=
 =?us-ascii?Q?KyGN4IvYey3mhitxhK2aFXpsfK7EesGRVBg2+7a8e0tVqchSrNcnQBKb79fq?=
 =?us-ascii?Q?+zfVPYM4gHhErPMnoubA06rOnbWCqhkO+Y3PjSD8gNV37PaF1WQuERSlmpM1?=
 =?us-ascii?Q?ZmTrpaxfP2VTpy/3LRhe1vCiyr0iOSHAyv3R+7g4mA8i0TC0YAl5Sc0c7S0O?=
 =?us-ascii?Q?kUOlYNJncpCJWJ3vRBAdbiYhfUdjbVHy+X0gpWLqCoPzGnh24YiW5rJ/oKku?=
 =?us-ascii?Q?t7UWjWyQnIKDio0C4mc2gp3KKIlftdIy4W+T9BYn29T8T5BdBjc6UWO+awSb?=
 =?us-ascii?Q?U+rVWkNg1ItaBHUMkLya0CkC5lezDAfzd3odb8Qx9hSN5DchJL1rZvc/goNR?=
 =?us-ascii?Q?S1mVxUWT0CaASAArWjiFTM9i4N04A3MbCxM5nDr6EaS2Cq25erCzvX9DucDw?=
 =?us-ascii?Q?1AE8SQwefikjmywVpnazp+rTIs7uNDpQumtn7iu6VQFAqLwL/K/7IHUiRQMk?=
 =?us-ascii?Q?HGYNoBU/HJNaVZA0okQy/5R3HSKAWBtO4Rh3ImE2Io8jUo78znpV7rytinnJ?=
 =?us-ascii?Q?9Z2sqwCLoeXT+Mccx96jJ1kK3bh/zsjlB0zyYDRQ9ptoBoBwvOR5FBfjDeXY?=
 =?us-ascii?Q?ZBCUUuMn2lEdxrn3GVUMTxj/dWNMBe/0Fm6y+/pzK0iqKaUJ4p7aKtEEQMK/?=
 =?us-ascii?Q?VF78V6okXZ9ZAEXqMR3tD6UyM2HmBn2Emi/njEjO0bKrrNiVAX/IUuebd0ok?=
 =?us-ascii?Q?+z8MYKVqQvO0lYtwU1MBoVhv8YmX0AVN4BnHgoiWwoDazrQD4N8GpZ75WCnA?=
 =?us-ascii?Q?+ZU5q3/TiP0t/dpqjlAOtjJ+zjFbeBv1OvLui50tA/ETsoZ4l0+zu7+7y8fA?=
 =?us-ascii?Q?Hnbtq4+50kupWtzC9kQq2fCuoEkGx4eIURDFxVlaV5pZ9budn1dvkFLzWAe6?=
 =?us-ascii?Q?oISpqi2pcmG2zmh7dEJBkLgtjlZl6BqdoJ4DMtpETrTDDez80xMKL2e3Mn/Z?=
 =?us-ascii?Q?1udTKQ6DZChxAEfuZoXfGPTUbysJr6OJZgUGwm3TuzQ/2HWHKraMLlbvZX2e?=
 =?us-ascii?Q?uMktKI0xzoWt07vzVd6aq/LYdpAVJyw0SEDMT9GBhunJvcrEqD0VKEyPaxqW?=
 =?us-ascii?Q?DIazd1mv0PBMm2cKv6Ve5OoHwD8oH2CTKXm88+BI3hcnOLaLJxphdMHUFe7m?=
 =?us-ascii?Q?G+81P0WJD6Ci7GDHfN1BPgfqqPg9fahiPPXcBRYWPyvDgJgYmz9sxBa1Mx9n?=
 =?us-ascii?Q?kad2aw4WtaZkhyBHoyZ1Qt8OhkwOGpXIZBjd8176qcNWCUH7S1nXi9m/zUd+?=
 =?us-ascii?Q?0ZP8hfuk6O0x1m/ayRCJ5PRkTFgyWP0UnjIAzmC5lMEGKz3xOmycVQeg0RaJ?=
 =?us-ascii?Q?QC1tR31x4h6hVbt01CwfR0u9WkXWiaVC2lEZySv1?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Dd+KhLSHFfx9JHYyV6TbeQE7aFaFA4vbzfzAYIJPo91FmSJQkwaaKcwJm8owUE+3dcsiBKwPJpM1MLfjDUHdoLDL/vTZpZE3yzmt7HqFrqLGb/ZBVyHfA94yxo35wITou0fIxUoJpOrpWhY6IpxSG/Ua0QhL5/lgCTNBRm1ENanBNZ0KiKfzP/ILwvnz9mXfD42vtYIxuUub95Yrlb4Zy1iHSzS3a+D0OIXOvRvHy9zJ5dy9q8BRpEzMs6Cs5F9mrEfZ+cer1JNIUrE33zZB0D8Yw2rQzUq7MU02vDbmQjj8McfDWc/tCmSKgDYGMg3pBoiUw675c3pE2zwrbzrI2Qr/vbXK9DLVn8EhsvU+MEliolP2xi9i9CGQKY89q7VwyVJFulDMCMdVaATxrNzyGWmDEWmzv2qg46bpTHdrTK1TEccMxU6YR7h2AOlNZRKV9bMcevH1xUew0O7Q8mPkM4u3BOMwt35bSHOyCzUzV/T3kFSCkRtYFS7bCUBnGggkQEcvEQFSvaFxLzU0nzWRK8evuWRYF919ABaTqg7YpNQGsZrm1Bv7WMgKe6KJ/gfnET7Ctcles64UIFcNcIuyx0G9Dd6ibYtTkSG1jTC6C5k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f6c4402-edc7-4778-ed9d-08ddf11260c3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 09:05:39.7253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J/Ic++1OkhfddqV0E30RzQn7EEsuWT1cXhrIjPer06PItr7KJz45X+/yZvJOemkEZz/2/iwH2EpZgtTEz+sSBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6160
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_04,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509110081
X-Proofpoint-GUID: ctf9AGivNQbDJS-E9qx6Rj-FNOC2uyI8
X-Proofpoint-ORIG-GUID: ctf9AGivNQbDJS-E9qx6Rj-FNOC2uyI8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MiBTYWx0ZWRfX0V6LOuR19mh2
 1Noh0Ea6SxQrWYG0IT/LMU2UUwMDZ0F17FYt8edsK2UATTT/zCoewU6P1a5bGs2z2OdFD/pglHu
 aykHTku9ZnrMJcX1FRTdrSgFfVp+P7F7vGcAG8gDr/21OaZ3IHZe9Yonm7/c3ZKwCiZcesWgogg
 YmxdOkO18T74vIP10Zi/o2yVe0Jm9zdPyfOeK1vfd8LHp2udUnRKcS/uXDi7CkSrK9mJEHNxp7t
 byI3px59RtHyD2DKX13sWkveSaptjz14/LmPAlOB6YHaOl5niPQqBi8OItjQtar2Ix3d3tTliFX
 HjXxiPtt97yIQlb5aHpEdhgcho+WJazFP2tcC/6Ur95rW47Ir3tihRK526YVAuSbXuEKlzfwuPO
 3EiYO157go7F/EFLn9HY4Y5pZ42stw==
X-Authority-Analysis: v=2.4 cv=b9Oy4sGx c=1 sm=1 tr=0 ts=68c290e8 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=wyJNoOs3WvMbPCdKTvkA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13614
X-Stat-Signature: ebcm4it6mybqsd1hkfa8brts3jaoyqz3
X-Rspamd-Queue-Id: 33C32100013
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757581548-492798
X-HE-Meta: U2FsdGVkX18sNVKmSvd7IQd1pqqEa6BFPxE9SF5jEuWmMchORYUhqWiIhlMzPHE2jQJKlU+LaLXoiRC+I/Rh1gUZhAbBxVKFs4tL9fNofqbp//G/fPeSKq6N9sFmWXSrIX/USfzW9m8eucJiqJ/vTwuQeXbTz9C0NU8KmTASGIdrtCvlCSUKfUY2PBIXYcW9z1IehOrFqvlHa9GNdMH8ne081UtElmBr0VpKYoU4jwNLwjWQngY/BiPf0XWFSv2ybIB7Aa2QhVgZNf1BDEnyUuJrLlkaHID1QCf2/Mtdgaf7pgqHvo8wzKsYPA3ZwpDiOZj2sGBIE9O1crcwoCfPe92yptNyb9b6q01HeALoncyOWT5xsnRV4946VmBYyUOoxeGwcwKJJB7pYu1FHFBhQ0yCagmjJmTURAky0735UAVfMeAtxDCmVQ177gVxOGPLOAjpT7X7GRLgLUDF48kMmwbYfCTZX8Z8P8LsFG5nGVnvtBhhCWgVaTXwCJmjGxY6MLbUyzG9QpUw2kZ+085E6cLJG+kFnJqXom2rhUuJBmLpp0aoGe5tY3ZOLRHneCbzYyzds3vkVY4e/vYhZsL1IMt+mjD6FAjQS9LPYY/saB/s/KWQFWZTc7aesGM2GZlYS6rofVTn5Pe1GYovWpPUmivti+o1Bs0yE22Y0oiMQwKUV/05NsFSSHNMu/tWEjKhmeCTgzMOW6t9/xdfnc3fdooHUUFVuQ70fXaKCWsvWxdJny45Zla4CcV4AU0rWTS7S8pmP3Hz2lcB13uhwDnpz0hhOoZA43jNtsUpareoZgwmWhXxgyZDkHiSygyAIQZa1J8VTg9TfPhNBX8aPAdO4+jfr/tKWIpUq7AIRdFV2kgRJNSUL2QJIV364wkJRJ1A08trtON1HrJXxhxFa/JHrE4d4jirTMXhzOaA8Da7Kue7kXFIMKhGY9OXnOWx42tuQ0Naiqv1/dTz4eMAwSv
 Th68hlk7
 i0s5zr9SKDS4kWLz13ZzYFcg5+CSG/ofwPpNisxWHYlCLOY/PXZRaHS2TKE5NhSMK2rxKbJ/99+KDtaJ8DDHzc+4qdHA7CDT4qZtMkg2Fp/LpFvGJSTyrBjhM8dddbx51lKXsYxUt3lReY+cQyUHqIMCDHQXPjQ5fjOVOfi2QoC5O7HNItsDT/HcyfUr69egV9N+l/pSSxxSvJDeKahyIVEOHhRrbEzNrnyoEALILuTQb/OD4DS95e00lFGuW8GW6EAI1GOW1dSqNT0KOQoEpBRzDrWQlxYnKxrSOZCVWme9h+tNpFj2Fvjq0uGspDmhCzy9WJKUxo+otQnT/37Zj/rQTFnEgPMqCmQkTJhyOsuN3m3m7UxMZJMIc/wNgkGfYrEQMrzBznOOzLvh4JQcKQptHTnO+VTyDEDVud7ztMs7Rba1kNcSn4exQrJxCdP/1UXj7W6P4GYPFUyg1cp0seJxeP98O6RcyA1YV0JLBvMYFJYv/o/gSAxd+lZY9hg7v/R8M/9TJ2diMbgeapZpjsHPpx0I2q7dp7hmMf1caycCErfgQ/ncHTlL+c8at3uIoOAS2FMFf+lhYex43ZOEIoeZyAQvBkdD3sz7kJc0SduwsRizUPzi8mYmjKUc+XOCI+IMip2ZArYWzL6a91hmvcBO4CTNBGTT430F34ju0SliAHr4/Lg9md5cQYvXell7NRnvWztaYTT9ndRY5BC1jg99iBDzzkEpaF/YKNSAuXp36ondrHIva8VMSx3JOmWy1SRv/C7+PT/ztHGqwB+HJ+YafiglxZqrUsp/G9+2TRfU7Xtk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 11:12:49PM +0200, Vlastimil Babka wrote:
> On 9/10/25 13:39, Matthew Wilcox wrote:
> > On Wed, Sep 10, 2025 at 08:21:18PM +0900, Harry Yoo wrote:
> >> Side question: if someone wants to (though I don't see much value in it)
> >> iterate over n->partial and check whether a slab is corrupted and no
> >> longer a slab, should they convert it from slab to page and then check
> >> PageSlab()?
> 
> Your question sounds like a hypothetical scenario, but that's actually what
> writing to sysfs "validate" file of a cache does, no?

You're right.

> One could say that in
> validate_slab() we don't "already know the slab passed in is a valid slab".

Right.

> > I don't think so.  There are probably other objects allocated from the
> > corrupt slab, and they might get freed at some point.  If they are,
> > we'll want to handle them gracefully (after all, the caller of kfree()
> > probably did nothing wrong) and not print a warning suggesting that
> > someone's calling kfree() on a non-slab pointer.
> 
> In case of validate_slab() it wouldn't be triggered from a kfree().

Right.

> However once struct slab stop overlaying struct page/folio then we simply
> can't have this validation via page/folio flag anymore, so it's fine to
> remove it.

Totally agreed.

> Maybe there will be a different way to reintroduce something
> similar in the memdesc world.

In the future, hmm... 1) check lower bits of the pointer (that's how
we're supposed to check the type), or

2) based on how we implement struct slab allocation, check properties
(ok, a bit hand wavy) that only the pages we allocate struct slabs from
would have.

-- 
Cheers,
Harry / Hyeonggon

