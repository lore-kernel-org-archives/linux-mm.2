Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F1E4EF8FE6
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 13:32:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F8536B0089; Wed,  4 Mar 2026 08:32:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A6176B008A; Wed,  4 Mar 2026 08:32:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45D486B008C; Wed,  4 Mar 2026 08:32:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 33F686B0089
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 08:32:51 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EFA3DB9D1E
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 13:32:50 +0000 (UTC)
X-FDA: 84508470900.30.E50DCC7
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9AC4E140011
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 13:32:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="ZZKxf/vH";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=EbpzXacI;
	spf=pass (imf23.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772631167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0JF/DAg66MA84T+Nbz0uwvsgwYbYsHPATQ23p6xbz2s=;
	b=6k25iZZC9N9JGTqVOUiVUH0MJYFaDJg/AvCIbfNCXbBnTUwOm2aIC3fikA0AXePQlnUf1w
	XTGf445Y3xn2GKmBNcu+NMz2WvyVuyMn7Zi0cCH99VCUAXD0w7cSuwXUICs1yz/UwREagj
	3PcgqKV4Gjw/I4RKToMd2TwWpTmNocw=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="ZZKxf/vH";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=EbpzXacI;
	spf=pass (imf23.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772631167; a=rsa-sha256;
	cv=pass;
	b=yNZsoE5fugOqErMzkeY5v+pEugxp0LDl66Zsx8ZNalOczlwgkYhBz5e1UWkMWx3uT2aXFr
	JRfNWdrHIvHc0uXyBAHkmuElPCyikn6cWiIMLVG3YI/aYq64IM+Gv4xTbY/l4UktVQv/m/
	DzLLsa5Bp1NaXhVbauDT8rBqmUUK6xE=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 624DNGrB2766913;
	Wed, 4 Mar 2026 13:31:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=0JF/DAg66MA84T+Nbz
	0uwvsgwYbYsHPATQ23p6xbz2s=; b=ZZKxf/vHN1vZcKTYFbwylZqs5JX5hAFa4I
	Bu98AdSlAsZq7VjeB3bsiPbk2G2N3qCeEagMX/pLIR1ewCIVvxJUxqZoW+N9I+kH
	CbTdGdXOnXdLNll1Zu566nP1M0T0ILh8ZduM6gQoUUufkAMBlr0slRR8T2h7dLSS
	gqMbMQtlIaEZn/dfyipteGojITFr2lBFPIq1dAXUaSUkRxNXiLJJN5Z5i/623nZx
	1mhnWZHeZCU8OfZhgOYbxoQg+j8KXGrTRaLg1HvG0TXarxaTRXAHHhpxfpeORRax
	7j4byllv/fWpOIZ2kymU1XkUCv411QexPIlUEyV+T/UFTeJkM0aQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cpnk0g0m5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Mar 2026 13:31:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 624Bljsu037027;
	Wed, 4 Mar 2026 13:31:50 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012053.outbound.protection.outlook.com [40.93.195.53])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptbhgp7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Mar 2026 13:31:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dnkuex72hgjCEHkGBhH9F3OrKkd3FgsUrlff1dzHvMELLw3UsSJ3M43kGW+IFO1UFKvxNz7JRLa7hD8jfVnvuvGll/myYnvbTfEA2VIjPCgt1/OKRFVviVcwvaduay9McX64i1RkN3x+cbkeVKCQ83DtgaXoHgnZI86W9PpNn4LcaGyR77ZoI9SSajdQM7T+lpHFKl1W0DPMeIHphXjXRTospto3tR0CrxCsAfFVz9nEQmNHVBbAIBm4RP1yzfm27MSuIrkAFzF/e2Hya5JV5Jf0y6gur2BXMCPN1A0dBrr35aAsiwhmxxEChgi9f+i2vjnHTIZGA0OHdRyt7EqNpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0JF/DAg66MA84T+Nbz0uwvsgwYbYsHPATQ23p6xbz2s=;
 b=eu/PXehhS3I6RgZPxerzaD9F2m/PZ+mpVqtUImPL6dYOneq/JabiL1pvQ2eWCiCRCpA9L7Q2rUw0CUAKgFiBp8GhztiDjYEF/NbWhADhLAsQ6A+zmwAgUfE7j8Shvm0WeyxqJigYHyXInAmjQBRee9pivfdOsOM5Ww+w+IWo4njHybOpFqjsf5dwsqyH55qc9S7bhvacp28hDlufL8zDc3+y5I/BP05ifR1bmJhoUO4RYN0R5W5IhiLxMPOFUFKaSKwNkQpgdeEbvoForESHYp2VApi78q2W6mUxNlN0peR3VUHramyNFv38CZkMZM2/szZYFlxpt/heayLbqjgg1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0JF/DAg66MA84T+Nbz0uwvsgwYbYsHPATQ23p6xbz2s=;
 b=EbpzXacIu2lt3PdGIY5PlhiiJZaXv1b/km2f9LMO4DhHnLYCp3vvQQHuTneHd/1kzn100V3KChwyBcm7gbjCYF0FHd4U60oEjD+71YFA9Kzq1nrhpjI42JAmjx23VsYdmVZaTTeHRF781PFQfbtRXN1db6LcI0GoGkzKis60YOA=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DM3PPFE51A5CB22.namprd10.prod.outlook.com (2603:10b6:f:fc00::c51) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Wed, 4 Mar
 2026 13:31:46 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9678.016; Wed, 4 Mar 2026
 13:31:46 +0000
Date: Wed, 4 Mar 2026 22:31:41 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
        Igor Belousov <igor.b@beldev.am>
Subject: Re: [PATCH] mempool: fix the race condition in mempool_resize()
Message-ID: <aag0PRXyEN-ansub@hyeyoo>
References: <20260304131214.102588-1-vitaly.wool@konsulko.se>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304131214.102588-1-vitaly.wool@konsulko.se>
X-ClientProxiedBy: SE2P216CA0134.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c7::6) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DM3PPFE51A5CB22:EE_
X-MS-Office365-Filtering-Correlation-Id: 5973da1a-dfad-4046-a95b-08de79f261be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	RfZY9H4cfX9vEK9OSPcOqVgE4GLA8iffOQEvSx1RBDWTKwS86/95Bs2pxUazVmXR/fQN37k4PixcAPvNVju3gdDGSwJDfCfjsa0NNaCqqaQ3S7Q/Mclwaq2oiAq7JkqF12QBL8dCLWigBKkPqpaKmOEdNxprAgdIwXghTVpsRzT4AjugmCRnL3+yNsDv5yLqxAVNxfMFbIdTG0+u/Sdc9BRX7Uu/MJTiwoiAr0XW44WCWB5e9qzl31uuH9TjQHHX8xRDW8nQmzaaUd4883jSiNWD9kbab1foqBS7d8fB0o3aWaKt8lBdro7ntIAqF1OZWRWdh6ACxyKjLsQypvB2vWRtisNsq6gMHG9eLnEowORCsWJl9MW8w1O6rpo2mfj9Rqtg98/ApO2ktaxHPANtA/RCcxfwftPFXJNibAHIM+8wWFGKM3c557Ds8Tz3dgQar4zUGb8+NN+AiI0dar+FmDP/JVNqfsUiWMzvUv/JMiO1Mve/oTTeIQMCbaxYsXyV8Hqdzcwn0HjPXQ6hqXR4JVQ0KDYl7oOoO0Z7umGU7/f+tvRF2ehDgBq43xznayNO/teERtz7X4OjOpdU603BTYxWLQButAuGiDnxovGBnpSlTciAYAuHDh8z7F+R0NsHVWdGtgdkaQ+w3q/CMo5P/0A4jKGirkcuxYeXs21JgqeMJOSUIAvDD0SxaFoMRvFjQsyNX8P0Ui+qbomISZ+K57tk49fCZQ5DZ0s7d4Op3mE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Smk3l+enQmcDYUjoI6FWsQMazxbVODylp0XC1r4PpHoisSqBJBqswwn+E8Wz?=
 =?us-ascii?Q?jBpHvh163nglhOaM1bt+MtA/arjctozp9/0hX1IyDSFoRK+utrG6Isu8OzQX?=
 =?us-ascii?Q?Rz1M/iuwFI3fLTNVvvq3KUo4+Yn5n5Vc4ytMFYwyALkh6vu0PP2VVn8UIQbJ?=
 =?us-ascii?Q?5s0bEuQLN+ZiFGqgESpepaOjJLiqTCz8asnhWFqnAHIwybMq3u1Z9cdFw5ei?=
 =?us-ascii?Q?tGK7jxqmDXA6ufiGoSbklfzET2lKnlAMswzXr2e377y5zYzspwzg7DWxDvOp?=
 =?us-ascii?Q?n4jolHaHmrZLAoRIOP917IDZujCJsH7fCKMDKIj2eMGgSivSGrACa980iFhk?=
 =?us-ascii?Q?Tux3o1AMDCCqTjAnne2pP0ccqzhq5RatwZF4voSm0t3B95gZaBDCuf4efXfb?=
 =?us-ascii?Q?KeSN50nNwHwPJLOhbADTRnQ4Gpbq6V9t2wX1UnnNFaFoceC0+Y+tXNdh0f3a?=
 =?us-ascii?Q?asLn8e5XJwSDyVbBhUsc03bnej5q2q35EfEytdOI+EbsqLWFm8G3l4T+Mi3N?=
 =?us-ascii?Q?GQin5E9rneQqhyzUZX1EXEfvMKMbQ0fDQaCUyKw3VRAr3AGJvgSVKtauMNn8?=
 =?us-ascii?Q?N7xO5ofoOpCJxaHYN1AnVHzngV4ixWthqb9LTV+horsGXajyel66LvEUYFu4?=
 =?us-ascii?Q?du/xkcs68v2/yYL4N9Xf4htzdVvP4lgK2Jfi0VOwnJ1OuQ/x6fVvt6Zr5inw?=
 =?us-ascii?Q?YS8iyoVOgRyqmTlBlLgkuI/qVHY6zgG3zM1y7oYBf2GdwGr0KZpPqT4hMXBk?=
 =?us-ascii?Q?ioRRJH95LvEIq95UuuriDGaOLaNoyv3v4y8/w9qI8u69XOa9r9v8Tiz4Oun0?=
 =?us-ascii?Q?kbmaUCOy6eMu5UnDkyOc2cJKlP/6L1d3fCeTN39UaAz8BCNKhhGnch/iYpog?=
 =?us-ascii?Q?H83ip4tZD/hqqneKbqZADLJy3qB+gZ5puSlTfsE533rtWE+X9r7fNMs7Vc2/?=
 =?us-ascii?Q?jci5fjv8hDN+Yy4LV6RAwJjmZNcV0sYq1sBlHUd2HYAMzcZGHqYa69i4Gn+N?=
 =?us-ascii?Q?Y9VHD5PDUHTUJTvuHAHP5/ru17jg2F/hPcZpBARJrJTMmZ6+gKd9/TX62W75?=
 =?us-ascii?Q?OcDGRUDLyJhEamIaAls8C8g0W8NE2ukT7BpCk/m1TaIWot8GPaf0Yb2vAt8M?=
 =?us-ascii?Q?BTyA21I3OSa1RUxye3xIpUGlpyGDIe8w7MgKgu1G9v5iU0HzKVszf+SJejuB?=
 =?us-ascii?Q?3xGp5Rd7PO4lh3VTxlTgq8KK+Meg9UlJOucdjIqtdoTXoco3GzIj2p+ohqAh?=
 =?us-ascii?Q?rBqpzFuUHT1MVDE+AWAiALnqGt+1C467eDsbT52/MNBJKIItfVW/atHpinYL?=
 =?us-ascii?Q?eqR8K1VlXpTJlOGkWhLWzEmao/bNBOiCBjFjbWyepUuzsB5MqwHLV8rnziJ3?=
 =?us-ascii?Q?YgE+dGmh1axSGtOwup+yEa5ys5TO4gyTpSu/bUtS7oU5uZztYFxtnt6J0DT+?=
 =?us-ascii?Q?a0fYDhEKnvA/1SugIqH6OR1DHX3WvQNEmUhJIkyK3yg64Q9+U+9htjZEdXUL?=
 =?us-ascii?Q?Ajyez+/XHc0HPO7x1IfKFQCciAc/qZ/8sfonnELJ140mmBBMQfS62vPtMLh2?=
 =?us-ascii?Q?P6SGZCOiFzjmlynBgYxiJI0RUxtml2lkWHCu6EYjPTz3AlN74zvE36mNphIs?=
 =?us-ascii?Q?mpOaNkJV1ijKYcKpsKX+3aUvn9M9DtlhHKMBd2Av0N8QrBsO5O6sKfB5ylHc?=
 =?us-ascii?Q?fdWBoL+U2h1QohNH71W8lWlDI4ZlHDeN3IlnWDgT0jEF3Ndv9L+t0HppkyEF?=
 =?us-ascii?Q?21+yYEV6+A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vSS3PNByw/Mzbx5Deii38TcqZKdDQnXaSym49Dk4e6Yqf/Eg0kLvAq6TfrDjNGiZ065BbqUwT5fbUKA5VP/ybmP6L94v0JmcktTGujPYoXYV3HiKbtBq23jkek3wiG7HGNrLWj888vyOHIkTO7Fsyf1ZrhQhU0lW5aKaBmMPH+xepCEs/1GIHgmnWqUf4aNfdR1UVARrJMBaEuxzeNMl1rAN2w0+YSakVQTJQcyrPLY/LVSVRk8iRipD+tve13H/qe1RpuHUA/Iy3/Gn+s7AWRAS62naICZ0/26tH3+P9d6ijtnOLxYf2OJ0s+3RISSigl+p/Qk/IgBWhNYqUwuBM75sEY0BRsSVpFPYjgq3NdqKNNAp5+/AASJ1P5sQfCrtgAhBcDWzgBcv0i7DbzqhZGLpLQx3BFkTg7vrjcGSfSJeJ2NW6G0gP8lZT0vhxmqIxaOqgvq9qTu6LEgwScpQxxc2VKT8o7dUqFRQA8SiFeqxPpY0nGsaatA7K2t8IxlcaX5B5K6qkrnsPJTjYV1UZhSK0ju8Iywyol79n9DJE3QwR+dG4FqbU/xxpWaV8QCpKK+iPMOD6fL0QodkTQcokywXSUoeoY8XJhhvYJ1iOVM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5973da1a-dfad-4046-a95b-08de79f261be
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 13:31:46.3616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DXVXk38qNLZ1zYOTA6HG8Ie5NjY9l6Jr7auU1tk+6Zjt4b2mXc/UGtGQh/szpF5t714Pqk7qp+SfzgrK/S8Z/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFE51A5CB22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-04_06,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603040108
X-Proofpoint-ORIG-GUID: n8gpgow7nEcfTWWm1HitLOjQ_LqzDU-o
X-Authority-Analysis: v=2.4 cv=Hrx72kTS c=1 sm=1 tr=0 ts=69a83447 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=_c3tWjcbQbBi-e1vEIwA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA0MDEwNyBTYWx0ZWRfX9Dd4K69trnSm
 UvP2M6JG3Q72sJnqPOvGD4HEfmp4yujJC0Ksbgvb3d+oA1pKC2veh8qaJp5aYNcicmB163jQ7Aj
 a3IXIes5D0AMHymXcW8vZWsu2X2VeNJrrCphrglGs4L1YvDPDY/YmBxoiwVVGjIhHwnPj49q0/k
 hj72sSrJUImrotkQ4wcC4KhO6EZjA3WIC/rVne/Ex+sEYB3h+7XzHelH5AI1XI3AoKOqJXWQ0Hs
 UJPm6nv8aGPp37XyFiqcZuOwbOcb8ko0dGhpRhtc5V9KWtpD16qeK9NTpi20likZgC9Wjd2P0uF
 /wXGRFLv2Bnw8EwwYO3/RmpS0WKQnBfMl21kTCtMeDLz1xr8IRSSVIWGRh5iODSXO+0sVST2G7p
 VAqX5mEqIGd0JR0o255PbImXZvLgIREbYE8Dk1skLQoaNgJmmgJOZ1Aw97Y68Yz2QDb0O7PkMFt
 UJCqw+QPtMFzftKyLdQ==
X-Proofpoint-GUID: n8gpgow7nEcfTWWm1HitLOjQ_LqzDU-o
X-Rspamd-Queue-Id: 9AC4E140011
X-Stat-Signature: urdfzwnfeb3m3ysctroof5nz31pqyjz8
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772631167-123453
X-HE-Meta: U2FsdGVkX18bHRQsPhfXP99IG49YnOBmKcqmuvjiP6zn8XyPEK3ptR8wLRslPEFHsxRE0q9ELdCBey+u9tt9Gs/gWAdWGMUmtTrrDBhMX8n6UbYhWxQW9vUVK9tUHpHODWTtAxsfX03mQci1TN2Qe4ljc5/cIsiUfJxSZ02McTxaqZsiFCqoID/7K9cN/gGbTPDkan97sOHuIjOoBs5K1zgWp+C3+5HVLz91ReJSw4j+d/akT43cyFw6gxgQVITUHqyEPyWTanoRzLh5SmZcUjY0OdypFV/KiZcgyvxGZro2ZpFouq3UhqEqwogGgAXORqAEftNmLsmEVP+46lFXbc5ug5ljn7cXb7wc7Kj1ZIwJPdpEyjXtMEcQEiOLO4j0VhilyqkCP1N0ik1I2g3A0dK4STRUQPypyBsFFW6YBwxz7DqCmE6dGS8BFr/UEwApj69h7BOOOX6uPNbMOC6UsU62LvUWXuRUZvSZ1GSGNyeaZzPvobtsLfwiRePMRdBypHKPGcYYJ5dJDtqTc8TOkzKV0uzTVZpvbBMP0oXrawxA8KXy27LEZSVXpG4Hp+FiWtUYqgGvsruv+oaQnBJIvuzaixwt1jipM8bR/aK5lw200a+0Y09Bv78Usf5gmSRYNgBMtLrNPHeCDbO2Dl5A1ORjxYmLWkAtxVE02K5Ifl5ld4K1wBsHkHgo1JOo64ZJZl86MTvT8nNeAvDJYFYeoYaxE0AYcC+zcQZ8R0KGRdr6VEDpF/eGQDHnsA1fBJjmYO0iC6lr5h8vjuq+s5AatkHaZUh3fNGEcPzSAgzCysi3k8CwOp0YLQ/1t/XA/bZmucDM0kG4rPhvL1PRbfw1mfR356tBMBVDYFTVZlX5E8GWM75kEnGqSWWQCKPjcbf0oXA1vghgRiC0BaGcTA9cTn7sNh/DUpGUyb+BQ2yyuAp0zpMj3zmWurz4RYO5PBL7q8yr23cftQ7wAxt5Cc1
 uIgn2b/0
 ZyKaE5/HreRqp1bEeJHNZ6daNoySn5vRZAja495/sMFcEWu2vw/jWa5pKpcO4o16Q1wdceHDSmYqXU8kdG6tbgyskgaYul2JfpTBAOJw5DspSpINt3Px0lJ1TYF9m4gyeV12Q/Ij9OMVRAIr1Jamdb0KtPz/bkEREPU4nWwOXF+Nclm4yKCgNsCXx8vyY6E1fUcU4Qk33jqvdn4x6lc1ezCrp39xdJBSNxImPzdG14LShFoL8WY0G6atEFdYnfnPUwU6fH1JYYw3rMkwdyeRriggr59pcozrqrPU5CGd1dGU8CCYAyxgje5NovmvzeENHQAQleiauZ9aaljq4peK6fugtQsoJzYf5FMyqoStHl0hpm1DMTqJaQeMT71NDDAmmwX0LWvlnq0arVs/ZjRQK7C9jbzOgfCl++dG4MGKPxR7tH7wlw/BZfyVTPYbmvrdeweaCO90dDBcYw9V9xIEe7VrEDtcVjK+4sCjMAKy/KlAeV/wiS37ldIz+Bviv2rSRhXdOWPGTbXGa7kMvFd/05IKxpsxEhta3AcFZ51WupCcZ68dAJP2O4+u3Ju8KDXdi+MxX3+91UWy61tVEiyohCR6fMBZ72aE1IdppAzvVhmdP6+svRdtyzcjfyKR4fc0dUbwgUBaHgrbHHQe4Dgrc9EkbHUYvc5fuV5Is
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 04, 2026 at 02:12:14PM +0100, Vitaly Wool wrote:
> From: Igor Belousov <igor.b@beldev.am>
> 
> mempool_resize() at some point has no valid elements array for a pool:
> ...
>     kfree(pool->elements);
>     /* here pool->elements is not valid */
>     pool->elements = new_elements;
> ...
> 
> If e. g. mempool_alloc() tries to access pool->elements after kfree()
> but before the assignment that follows, we end up with an undefined
> behavior. Fix that by changing pool->elements to new_elements first
> and then freeing up the old array.

Hi, is this from code inspection, or a real bug you observed?

I think pool->lock should prevent the bug you described from happening
and I don't think using xchg() is necessary when updating fields
protected by a spinlock.

-- 
Cheers,
Harry / Hyeonggon

> Signed-off-by: Igor Belousov <igor.b@beldev.am>
> Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.se>
> ---
>  mm/mempool.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/mempool.c b/mm/mempool.c
> index db23e0eef652..302d83cbeac1 100644
> --- a/mm/mempool.c
> +++ b/mm/mempool.c
> @@ -384,8 +384,8 @@ int mempool_resize(struct mempool *pool, int new_min_nr)
>  	}
>  	memcpy(new_elements, pool->elements,
>  			pool->curr_nr * sizeof(*new_elements));
> -	kfree(pool->elements);
> -	pool->elements = new_elements;
> +	xchg(pool->elements, new_elements);
> +	kfree(new_elements);
>  	pool->min_nr = new_min_nr;
>  
>  	while (pool->curr_nr < pool->min_nr) {
> -- 
> 2.39.2
> 
> 

