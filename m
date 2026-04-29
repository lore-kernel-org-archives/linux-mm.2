Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3456CCCFA13
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 17:09:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70D036B0088; Wed, 29 Apr 2026 13:09:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BD666B008A; Wed, 29 Apr 2026 13:09:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5859B6B008C; Wed, 29 Apr 2026 13:09:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4563E6B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:09:15 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 07BF1A0358
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 17:09:15 +0000 (UTC)
X-FDA: 84712229070.14.EF596DB
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11022076.outbound.protection.outlook.com [40.93.195.76])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0CF80C0004
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 17:09:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=t4zm0FuQ;
	spf=pass (imf28.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.93.195.76 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777482552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7tlHlWRAO2UmHsFvNbnNZA38HOlN2Fp5E0nYo+QXLLM=;
	b=5m2JV+IF6M9Dk1RU2ekuShxEl9N2hIB4GgnowJGhc2jFfwtuKXdPVAb0xJw/rvFeIi6qxx
	vB93BwPAns/iGstwqau1gYNB4YzlRXahN//JVRqxAqD/CGbX7hco4+Iklm1dtrJJy8CeHa
	20jqFVuV4NmduKkla3VC1857yGSL+AI=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=t4zm0FuQ;
	spf=pass (imf28.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.93.195.76 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777482552; a=rsa-sha256;
	cv=pass;
	b=Ly2GpwTBR0/jyDzXwCKz+uyp9z2RKie/akJwaCvHXM2S0eyldqQuzs40zzKer7oar4iqP3
	d+6URg0shvHeG3jmPUCkqr7NEOJB5jGkRYC5tx2yMZcjwYFwShMhakfJTxl9zO3DvtaiNg
	2RftOWnbHA0WcV98iNxu5LNwjGs445w=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ewyavoI0azou8iYv7caOliqtUou8eu+5rkpZR8Pp6r0sWC0pBhe1+3fRixv0CS7Ownwigfd3Wo7XUwoxmLuFmtJB2SWnYE74gGs9ZyXO/UF/fIPtmpTPy8pM2W2i1EZ2Vva0A5HELh2ckldQ1fJUpcs9vwkbjMS7KQd1meRMbBtgfeDMxbNqfo4yrk+uHpKfVCX4GaS99Vt+s050LwpXumskE9jtJAYdJgopNfX6He/qMIxL7+R1ffYHUWnDLiRMRXoILMybp0t9hswZTSbd6Sb7/Yd5LsuTxxM/GA6uDpm0Wu1DRT6hELC2OrtOf0HLooQxgGG222hs9+U+LfyGhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7tlHlWRAO2UmHsFvNbnNZA38HOlN2Fp5E0nYo+QXLLM=;
 b=HvB65jXxwCbCnGKtLpi5Uu9xuwtEwE4Bz5HzPUiZ75eHVAleoic4cXxsAF5ycbuJhlndMWMvAWrFMEeEuFgGbc2Rvz4dphBTnyA5pTGHPU8XUeCugojcPUL1daWtuhS2iadrGiKENBcvu9VbzJTyXe2gUFmDheQpW2/91KawpSjQRWnhc+O/yOpcld/8WUmJkH4rG4Y1LMnsbmwL7JT3mvp/5g8CdHmYVh9fMmGy+GrT94qYGPzTuxTCzhTLu/8X5iV1OAymRwPgbEcZWgnP2/QTeqJVYkJ7JUNcLe5he+h4o3VdmXR9wQ3RZdXonl8pbsBaJCABR8+ONMWuyTpxug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7tlHlWRAO2UmHsFvNbnNZA38HOlN2Fp5E0nYo+QXLLM=;
 b=t4zm0FuQ+CEbNLti2rs60K9ua3M2iBkIjGnIlCuLS6g8uN4NOXaXU2eq+8bGsEkVVXr7eELOeZfe4Hv61aK19/ixWkra55mQfDwMD++oGT6LxpRmBt95666lbd1+xlvT4UmzWEAo2Wru0RmLyvXKiVH/pIJXUaYSq7zROeD/GJo=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 SA1PR01MB6671.prod.exchangelabs.com (2603:10b6:806:18b::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.26; Wed, 29 Apr 2026 17:08:55 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0%4]) with mapi id 15.20.9870.020; Wed, 29 Apr 2026
 17:08:55 +0000
From: Yang Shi <yang@os.amperecomputing.com>
To: cl@gentwo.org,
	dennis@kernel.org,
	tj@kernel.org,
	urezki@gmail.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	ryan.roberts@arm.com,
	david@kernel.org,
	akpm@linux-foundation.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com
Cc: yang@os.amperecomputing.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 02/11] arm64: mm: define percpu virtual space area
Date: Wed, 29 Apr 2026 10:04:30 -0700
Message-ID: <20260429170758.3018959-3-yang@os.amperecomputing.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260429170758.3018959-1-yang@os.amperecomputing.com>
References: <20260429170758.3018959-1-yang@os.amperecomputing.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA0PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:806:130::13) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|SA1PR01MB6671:EE_
X-MS-Office365-Filtering-Correlation-Id: b468d02f-6f97-48bd-0d39-08dea611fe88
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|18002099003|56012099003|22082099003|55112099003|921020;
X-Microsoft-Antispam-Message-Info:
	eGZfahnj+uGAOYQBcBA3BGhwnqTN78NMCaRzFqqH9wpvNlulkUMNI5OzBdDeRzAM88dvhNpIiyUpzF+vs79zFmKgKFjK0gUHYRbIzPOjrD0KfVyjtiC5/0Gosyhlej3ecV3BRodFhFnDB2ajUU0bF/Xn2lDcqiODJqnI9g8GrGyQ2/YDeEpqwVqP97V3j6q+KKJO5cCmQkIQiIZH/eGq9uUKp6bcR/TVpNDFSIHr0C/ZafAWMuxBHLwlJLpSBl8blifWdiF3JZ4tp4DOkfcu36os4j0VlfHKv1RI0M+X7yNnqH+Wyf/c103L3mjJDjvx6TuWiEkmUtViOtmXxz3Bhm6zLpRR3nRlTjOCLUGuVRQ0jgXuCd6TyOLwA+YADmx0xV/BR30Mz13zp4kgzaMyKtS0ehiHzuJ+yX8eQskxi7YMxGD+GGkuHsWrX4KCvelUr//tslUhtPPzna53ydOenxxM+jHa43FPOdp+xec5A1xJqBiRr7UrGCpWiFSt05H/wmkOm4aXzmdTEkPaeMu/MKwNOl6GwQNbmJCKR3YGKqn1F6MroG5/fDe/KS75rdYKseLFltSt4DZ8t9N0QwE+GNeftfE+Ii8ACCBhHp8p1Hbou814COB3zm7YIg/d4buj2LnjEs4m/d9myFhjE5+hERIqPnXWrhTLCZ/WdyKedy6oR7k7ZWWc+S93r6dcA2/AOf7GFbXiBJ4g0hCJ3/zZqIwii/UiXc89X4GHS3opWf1LMuDJiRHyKxnfDIswPHRNTM1EUpzxJG585IdOIQiS2g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(18002099003)(56012099003)(22082099003)(55112099003)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?S6oSVvyXcGxjfsDpjjA+aG2UTmoHu8KlO2h0y73D4V++0tgt86bsLhLtUdzq?=
 =?us-ascii?Q?4i7IQ4jSyR7YWgTJp70wc3nyj9UK62vJdxpFSzTSzOTc59NKnVSIP567I+T+?=
 =?us-ascii?Q?p+Hj7BcJJ53j19g+MlfsXOwclEzFzulGvjTOwXx7YlITRQHM3u7z6mGdizJz?=
 =?us-ascii?Q?kjl1XLGIZxRFv2y+eZ8e/wathSX4PNHKu8IT4fKiQ5Rqldh2tFYuxk11OHRr?=
 =?us-ascii?Q?4kn99y6BWCOqqmVXWe/EURdW3SiXTllJMmLLkxBL61S19srNPDA5VZUfLH+3?=
 =?us-ascii?Q?ehU+PLiVdNZKnUiTzmbvG11DwawCzDi/QeypmGz+rU5Qibpd4f6He8+ygZAm?=
 =?us-ascii?Q?XAXwI7PhFA84EE/jToXzW3HW7e91CpPPcdEqGZQs9zCPFj3lUfnhn/0hqLUP?=
 =?us-ascii?Q?0iiIr02ZZp7SZk4w9a3wwVvVQmMwcBpP1d8AYUpxR3NXMHHMZ7vrJ43cPs2M?=
 =?us-ascii?Q?kZN12g6Oae9rgQjI/GUgZWP0G3b3ynxixT1KVz7VR2+YeaDNo7wYxr1gXXud?=
 =?us-ascii?Q?jDN4GQk2j238EN0ZzXlseGGVL1+ZjuMlQSHOMS0KoBL3lD15idgOqAwYMX7a?=
 =?us-ascii?Q?HknK3/HZ1RMRLuDMbfd544d9+fUUWoK9SPyShPahMuWwSiPQ2h5pHczpwafa?=
 =?us-ascii?Q?t+B393+00byF06hE2MxK6TtDz2Uws/8hgwmh4kfOKKUTauaOMYHJu1bZIslP?=
 =?us-ascii?Q?Sra9Ioo79LQAhiNre6uIg0TCqlLzoF6T0Lkx0sGFNCaM8zqzgNeXZRJ9bfVf?=
 =?us-ascii?Q?oJDu6crudpMgN5P65UTbUytIoZncsZySCTV7Y8yEOKHBfw4TWU46NnpB3LMI?=
 =?us-ascii?Q?UIu2Nq8dWz3osTqcM7+JxHKjrGSgoCFpbpXDLNTi/ONuB4ADoT4sWwwugXdj?=
 =?us-ascii?Q?mhxNojDslU/IO3UBCpbQBZQCIj/y0h/MQKkoRe/ddfFgU69QQDyJnEUuuW+6?=
 =?us-ascii?Q?3zJCRuAjB24dDW9XJU/QVdfiSJhDqP6Q95nFTsF7M6zvbVyhqEqvBfiqgJmt?=
 =?us-ascii?Q?DfZGjKSzjR7oJ8LhIScDw/WKHhW63EsPvG7LVRZwSZ7B+n3ycg7FaGdT+Vyk?=
 =?us-ascii?Q?2ToKMRhBdblwMjIaxcR6ZOBn4BoztObxw6P/lyiML18vRDK1zAvzqifH9Cbt?=
 =?us-ascii?Q?cC73B+KPjZTsGClY8YqBvr1ZJCXF8l3YLGfrHER6v40A2iimQguHiKFoyjwh?=
 =?us-ascii?Q?BJqyGYVoh1zCuH7Sif3ieF59gfjzZXJOLDh38qlWC5KbnAaZBOI9s5YwL8pE?=
 =?us-ascii?Q?k1wcqmxwWfsPKQUFSAYGPvPkvOW/RwUCuTBw8dNubuna5ZxQ11C3vX0WuZms?=
 =?us-ascii?Q?hr8iZKhhhQGNG8eCWW1PfOdD1SHMwaajzd+KoN8/178QnTImGsq8f0Fl3nbX?=
 =?us-ascii?Q?RQQpQDN21dE9GFt8Th27y360s67zRL8oe1jvKpZqFr5pbeDnEEgs+GR89t+W?=
 =?us-ascii?Q?AdIBfY9mmRSaZdml5WNWD1mqRAh2fyoHRV7Gwmgrsv3EE4Txbv8h8JsFo4F/?=
 =?us-ascii?Q?lHD+mxKj3w+TS6xK0HYMBmMWIkybhNuIDYH2ZK5QSd9ZOdN3fDsFOdsGVChe?=
 =?us-ascii?Q?IHFP3iDOgvEiSVtpYZdneTiuWjmMzzE2/T3Q2wQDZPW6ivgA91u/xuo5e5xy?=
 =?us-ascii?Q?7PtiHf7OOF6ImDR/qWiqN967/aSI8UjMrEcAIypxPWwHgDHWROR+AZACDhLw?=
 =?us-ascii?Q?aBVrRgPGSL4JfbYfnXWZqsu8pa90oF1/uVTPGzLUJq8w8UmsO4K0i//KwJOz?=
 =?us-ascii?Q?pim05LSSZQFCMemZmjzbGvYUewEkS6k=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b468d02f-6f97-48bd-0d39-08dea611fe88
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 17:08:55.0033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kl0fYc8kFE9rJDKDAr6XpPad3/iHBekRoKPFjHCls5jep0BIp2EMqWhISsS5Qi1mwqEnbbRkWxzHRihCF5gy5W5SVQIrlTzHJV12lDQiYto=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR01MB6671
X-Stat-Signature: t7ftripbb8i4frhdkmsxo5mg6izna8q8
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0CF80C0004
X-Rspam-User: 
X-HE-Tag: 1777482551-857180
X-HE-Meta: U2FsdGVkX1/5UrbhwnGcus5kv1GMgAyW0lJ+xf/0BZGM2yu/PZCBkH4Jm3grDDl7TRZ1N/5sNZyBpV9CMfZ/X1jxJX4Slc8aKZ8AbUnFQAmHLV9yZ0FKL/On1bLp0f56mxysMC7aVqMLP1uSdNJSoHUpVFbo9xWCjoEyW5j/e5dwMFbxd3Kh4xmEh6uGMuWs8AsZvY+F7rfttjcW+F2tSTJLD6aJPKet/rU7bArNBvb4BDtRekhNYG0koLE3QLsH66myJpZjXBz205YO3E5uBzgeOnClmgs1y0wuAGhpbaE+cCkDvdVLIi9jDPMd/CaL1PjjDH3CysYYUyzgjLzy0+O7XOacbgCmw3H2FjDMPRkjRLmYA+FXdKe8dlv0x3iiBLRRU/GSCcq3Dzvgmddc06Wdtx8vZgXbRZdrOnrKvGv3dsUBlh1GzXDuy4w9yVm0KNYqziIuW8FoNE6U6JX+KIsZxSCwyvsRYG8Ilwzx+flMLtdruthzFX9eEDW5zFxcVQlSkfbUlWXBPy8IDbPc3z2eAZSdzpqjcOgcmebYhghpSWt23phwWPx8WLq2vX2ZHcFxQ0MvBS4Iy/agx+1O4ZMRGB9Upvl/md9gHrSy/y85x6f3URNdlXJgbCf8aznj1L4hGdCUPAIoGMuImjRcXIKPb6d6/tSvb4ziUHTRmPs3DVOd0ZwsiKc5RJTiSh9KnsaK5K5kt26/OMDE41+vJ3I/0DO7xHr1Wk+UBIaacLiiOthbHDaACp+lC1Hb7tMP3lkKcCEivNCbmWjhmPY8h2qWfuWDfc5b0Wzv1gYLWXpMWQXXqUiHwIgTDQwHiD0lwQnlpgtsHQNjWLF+t4Z/aHJ2/FYYejPEwi7GdplyGH6KGrcy00eVdHSfY5ETzh1K3Hj8M5DhjggXkl4WziLPFjeOuo1897ibdqwZbXvWJu1GhXwAje7k6hiK1sSWLytJq3Yv+agLcnPfIAPncvA
 iizTr+Tr
 SQSfBlQrIsRwoRQ/7G8j3wB+IW+PXSXD2OxSWiFtB6sU+nrkC1ZEwmMThXqposezqzqhLIZJyFeXKLUMAz2wLT+MgEcu0alQoykqsLpGLtPXYynsMmpxXWMJrTR8YIl7+5M6KMldCaYwz6+3yUC5/ixFwPNghFqc4tUA83xeJyqfcdhV40t9zR3fAizaHX/ivLc+SB5KAHNRQIy64PHdv88e1YoC+bE8K3patKtc6HZUIhRrt537ffhnrWTmQ7TmCL1UyAOFJoRFJ/Wy1PpOWlZBiRpn1pHnItLKcLtCazDLpVpw1ri6hsLlWfCTJ8WlqQoByNE1cg+NPRtmvnkEJGSOYM6kiXrx4pNer2IOGY9lNutK5E9axYhqvqy7poQX0nRM5YgpghpTYi4BEzlt1uXHiYHNZ+7I/s1S92cBX2fOaeMJit2uws4iEby2NDiO2CE0yLAaad+Nuaca4soEt1qUP1cXB4WoQPqVWFC4C9WwirMahXoNvBgQUwMjngQR4csjS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The percpu allocator returns offset from percpu base address.  The
percpu base address is determined by the first chunk which is typically
in the low address of vmalloc space, however percpu varriables are
typically allocated from the high address of vmalloc space.  So the offset
could be quite big.  It may be the whole size of vmalloc space.  To support
local percpu mapping in order to optimize this_cpu_*() ops, the percpu
allocator needs to allocate memory from local percpu area too in the following
patch and the offset to local percpu base address must be same because
the offset returned by percpu allocator must be used to access both
global percpu and local percpu.

We can half vmalloc space to have either half dedicated to local percpu,
but it wastes too much address space.
So carve out dedicated global percpu and local percpu areas.  Each area size
is 2 * PGDIR_SIZE.  It is 1TB with 4K page size, should be big enough for percpu.
The percpu areas are PGDIR_SIZE aligned in order to just need to sync percpu
page table at pgd level to minimize page table sync overhead.

The kernel virtual address space layout now looks like:

+-----------------+
|  Linear mapping |
+-----------------+
|  Modules        |
+-----------------+
|  Vmalloc        |
+-----------------+
|  Global Percpu  |
+-----------------+
|  Local Percpu   |
+-----------------+
|  Vmemap         |
+-----------------+
|  PCI I/O        |
+-----------------+
|  Fixed map      |
+-----------------+

Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
---
 arch/arm64/include/asm/pgtable.h | 21 ++++++++++++++++++---
 arch/arm64/mm/mmu.c              |  4 ++++
 arch/arm64/mm/ptdump.c           |  4 ++++
 3 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 38eec71ec383..9043b976682c 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -18,14 +18,29 @@
  * VMALLOC range.
  *
  * VMALLOC_START: beginning of the kernel vmalloc space
- * VMALLOC_END: extends to the available space below vmemmap
+ * VMALLOC_END: extends to the space below global percpu area
  */
 #define VMALLOC_START		(MODULES_END)
+#define VMALLOC_END		(PERCPU_START - SZ_8M)
+
+/*
+ * PERCPU range
+ *
+ * PERCPU_START: beginning of global percpu area
+ * PERCPU_END: end of global percpu area
+ * LOCAL_PERCPU_START: beginning of local percpu area
+ * LOCAL_PERCPU_END: end of local percpu area, extend to the available
+ *                   space below vmemap
+ */
+#define PERCPU_SIZE		(2 * PGDIR_SIZE)
+#define PERCPU_START		(PERCPU_END - PERCPU_SIZE)
+#define PERCPU_END		(LOCAL_PERCPU_START)
+#define LOCAL_PERCPU_START	(LOCAL_PERCPU_END - PERCPU_SIZE)
 #if VA_BITS == VA_BITS_MIN
-#define VMALLOC_END		(VMEMMAP_START - SZ_8M)
+#define LOCAL_PERCPU_END	(ALIGN_DOWN(VMEMMAP_START, PGDIR_SIZE))
 #else
 #define VMEMMAP_UNUSED_NPAGES	((_PAGE_OFFSET(vabits_actual) - PAGE_OFFSET) >> PAGE_SHIFT)
-#define VMALLOC_END		(VMEMMAP_START + VMEMMAP_UNUSED_NPAGES * sizeof(struct page) - SZ_8M)
+#define LOCAL_PERCPU_END	(ALIGN_DOWN((VMEMMAP_START + VMEMMAP_UNUSED_NPAGES * sizeof(struct page)), PGDIR_SIZE))
 #endif
 
 #define vmemmap			((struct page *)VMEMMAP_START - (memstart_addr >> PAGE_SHIFT))
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index ed1545baa045..7708dcc1b6a9 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -108,6 +108,10 @@ void arch_sync_kernel_mappings(unsigned long start, unsigned long end)
 	if (!percpu_pgd_setup_done)
 		return;
 
+	/* Don't sync local percpu area page table */
+	if (start >= LOCAL_PERCPU_START && end < LOCAL_PERCPU_END)
+		return;
+
 	addr = start;
 	do {
 		pgd = READ_ONCE(*pgdp);
diff --git a/arch/arm64/mm/ptdump.c b/arch/arm64/mm/ptdump.c
index ab9899ca1e5f..7d5696a48917 100644
--- a/arch/arm64/mm/ptdump.c
+++ b/arch/arm64/mm/ptdump.c
@@ -389,6 +389,10 @@ static int __init ptdump_init(void)
 		{ MODULES_END,		"Modules end" },
 		{ VMALLOC_START,	"vmalloc() area" },
 		{ VMALLOC_END,		"vmalloc() end" },
+		{ PERCPU_START,		"Global percpu start" },
+		{ PERCPU_END,		"Global percpu end" },
+		{ LOCAL_PERCPU_START,	"Local percpu start" },
+		{ LOCAL_PERCPU_END,	"Local percpu end" },
 		{ vmemmap_start,	"vmemmap start" },
 		{ VMEMMAP_END,		"vmemmap end" },
 		{ PCI_IO_START,		"PCI I/O start" },
-- 
2.47.0


