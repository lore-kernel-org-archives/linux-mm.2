Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B994DD5C0C3
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 03:10:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03FDE6B0005; Mon, 15 Dec 2025 22:10:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F36F36B0089; Mon, 15 Dec 2025 22:10:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E361E6B008A; Mon, 15 Dec 2025 22:10:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CF3F26B0005
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 22:10:23 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7E8FB13AF70
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:10:23 +0000 (UTC)
X-FDA: 84223855926.16.763F749
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011004.outbound.protection.outlook.com [52.101.70.4])
	by imf06.hostedemail.com (Postfix) with ESMTP id A6E0E18000B
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:10:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=nxp.com header.s=selector1 header.b=ho4ZWENG;
	dmarc=pass (policy=none) header.from=nxp.com;
	spf=pass (imf06.hostedemail.com: domain of joy.zou@nxp.com designates 52.101.70.4 as permitted sender) smtp.mailfrom=joy.zou@nxp.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765854620; a=rsa-sha256;
	cv=pass;
	b=x/kE6t4gkEBXwJFsNA+yX6x5oMVVLuf6tbmrcnaf8FUDO8NLtMDJI5ibKudgCp0WDW1tT9
	Z6KljshsbOlHrZlHeKE3ILQkLQvey230h4dPgQrItXmRhw1E/CM2/1f5LEQXRCMBuPGl5y
	yMY8qV7/qpkSjsXTxdJXqkRkj1syugA=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=nxp.com header.s=selector1 header.b=ho4ZWENG;
	dmarc=pass (policy=none) header.from=nxp.com;
	spf=pass (imf06.hostedemail.com: domain of joy.zou@nxp.com designates 52.101.70.4 as permitted sender) smtp.mailfrom=joy.zou@nxp.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765854620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uH8vCpBVQh67JYIHqoHYiIvMUI2c2wUrMgX4pTjsyhg=;
	b=J4/7LyrosFEOqHl07RuscAXglkrem/z3+ygPvwCDC/h+d7/e26Iiq8j9MCqaTJ/p4RVyWO
	3oBuP7yR9bFqfR+A1Q/E4m8E8tMGsrzUMfbP7L5GptRFpZUUEKeVvPo7DcDvgPT0S/VRJj
	JyA0aqTrns9jOuSsZw1vNyyQmjMz9Iw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JLWIFCHyuelKyf8f6nPd8100qFb+lwYiPXwbytCZ0qH6FhZ1UgQFnTJgbUlRpRGnK9lHva5EKhUX/owX9qQuRx2rDhsGz0pwDQ7KvGnMcDbNu4yjiM4rQPyNizD1g2plL6NdDlqPxasvRrE7EPRkrL0RTzk9lm6/4+gJ3lNZCar+AOilyXLwngvzz7d/GS+Vv65J0IpwE4wCHegm9Dh/GZEXwZRvfn3iR0cHoeL2G/zL2bHt2JgR4IWQV02EDoUnLpkHs9RwKJKbiPO+lqQXHwonP5uLB8gP/+Ij6Lkv/cpHGX+1x9DVmPFwEZ72GBI+81JmPw19paMJHzXVx0SrZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uH8vCpBVQh67JYIHqoHYiIvMUI2c2wUrMgX4pTjsyhg=;
 b=unT0udXrS7TFSZN8hDBBe54bAV4k9jBYh4I14c3GrBGIQlr8SapZfzvJqJ76zknT7psVbXC854AM+0I42feeigM3P5odmKeOpL2TeYCE9UX7AwJdJG1XQ6vsOa0H77oM7Zo9QvL9bM586MpkOLyNTVCiujU4RHFvS7jlLwWvSjA7r3IZcSHRG7JifwgDOYomwH3I56Z/7UkjFWiE5fHfBwqQcNrkkcB2pZ6rYm/bhRudNkNwER+CRoNk4+jgE6ul694zVuoMKfeb6JXK0Rj3G+iqJ09ZdA+Hpj5Z8inPnCvjb/sfBG2PiH4Af0U4CXnnIjpjVM+Z10j2GxiXOjPTGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uH8vCpBVQh67JYIHqoHYiIvMUI2c2wUrMgX4pTjsyhg=;
 b=ho4ZWENGHBPD5LAK1QYxNufCBsqfMit7VruLj4qQVIxhHcTlyBX1ESoBiBGi4RJAxi6PNhHklWrNz2WJx3w64bl5Kt4UySR0UzdJxCHBhXdcx5cevF92ICQ3BkTPgm6ocxvW6LJIdKhiR/fIPq0wrXld79ovBA3oRSHO/vkcBL9vpdyWl7ODJ2esIvTlQCC8/6+WsDtqTULautXNVxNGDnvhWpB/HJ+yVESB/NRxKFvESIoa33Ge0LIGkqk6qTZAI2Fq5vGFTo0jxuNy2s5k0CaP2Qe6UW9XZJ9G7TV0m86K8aXi8wVAWIruw8nmTisr95TMETDFZ2w4YpyHiDowEw==
Received: from AS4PR04MB9386.eurprd04.prod.outlook.com (2603:10a6:20b:4e9::8)
 by AS1PR04MB9430.eurprd04.prod.outlook.com (2603:10a6:20b:4da::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Tue, 16 Dec
 2025 03:10:17 +0000
Received: from AS4PR04MB9386.eurprd04.prod.outlook.com
 ([fe80::261e:eaf4:f429:5e1c]) by AS4PR04MB9386.eurprd04.prod.outlook.com
 ([fe80::261e:eaf4:f429:5e1c%4]) with mapi id 15.20.9412.011; Tue, 16 Dec 2025
 03:10:17 +0000
Date: Tue, 16 Dec 2025 11:09:59 +0800
From: Joy Zou <joy.zou@nxp.com>
To: Oreoluwa Babatunde <oreoluwa.babatunde@oss.qualcomm.com>
Cc: robh@kernel.org, m.szyprowski@samsung.com, ye.li@oss.nxp.com,
	oreoluwa.babatunde@oss.qualcomm.com, kernel@oss.qualcomm.com,
	saravanak@google.com, akpm@linux-foundation.org, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	robin.murphy@arm.com, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	iommu@lists.linux.dev, quic_c_gdjako@quicinc.com
Subject: Re: [PATCH] of: reserved_mem: Allow reserved_mem framework detect
 "cma=" kernel param
Message-ID: <20251216030959.GA87745@shlinux88>
References: <20251210002027.1171519-1-oreoluwa.babatunde@oss.qualcomm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210002027.1171519-1-oreoluwa.babatunde@oss.qualcomm.com>
X-ClientProxiedBy: SG2PR02CA0006.apcprd02.prod.outlook.com
 (2603:1096:3:17::18) To AS4PR04MB9386.eurprd04.prod.outlook.com
 (2603:10a6:20b:4e9::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS4PR04MB9386:EE_|AS1PR04MB9430:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d704e83-e0a4-4ed5-2fb5-08de3c50a356
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|7416014|376014|366016|19092799006|1800799024|38350700014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DPB2ni2BWtdDmD/D2FqeZuAcCZIINC3NtNLpcJaQ5hz81erhwOxByeIQesEi?=
 =?us-ascii?Q?4/7lSbmBj8j7ZaMsf2ibw6981m0kfn0QWkhof3wrAN5RPveWbwY+dZG1A/A6?=
 =?us-ascii?Q?5eQ5FY3Ti4WuWVS78ANTcM0yn1iFoPn3Wn+QcWPfmxxTDkou34qYM4dC3iSs?=
 =?us-ascii?Q?VwQGcG4l6zB5KkYQowyrpUQx8ZDOy2GVy0T0PnTWdf05miPRedqnUVRuchHp?=
 =?us-ascii?Q?VMlPsM0dvcN6Edi3MeG2ZptLKX9oYDWsPvHpE8Zbp4f/kVSFqtHpOA5hwdoX?=
 =?us-ascii?Q?Y39lj9c+O5DKo9OeWnA3ATWOUHB7XwXLxzhkrEq+2aWohiYQKikHncDnsuSK?=
 =?us-ascii?Q?ToE8lK3IgCZ/lnvX9jNY1wTm79nfABLXDFl8mekxtoqBwlvTwZsjVuo5Lgo8?=
 =?us-ascii?Q?kdl5aoQE18Un5R9G4x3Q0COVPs/SP5fxrT745ABOPneBklN0PFyxAve5c+IO?=
 =?us-ascii?Q?zcJXl5CC1E1gBDnTSNDTsWrb+L+VvyjwrwAvaDc+Y4HepRfvpdpHSZxJVCBm?=
 =?us-ascii?Q?7hJ1tSTFCfTB9oVtKSqSrtCnQ8nrI06EWtFLEp0mDbrgjnJVc6SLhl2lbBrA?=
 =?us-ascii?Q?aQ5qq8GXB+6ZaDkUywywYjoHHkAi5yHfu+MlGlA4fTxcLe7iFdKXFHOGpXKu?=
 =?us-ascii?Q?oHfGzPCjW9sH/f6ZvKzh6hGIAKH/lo1kgh+QF5EEXWBQT6r5JFiaNXgIPEj0?=
 =?us-ascii?Q?FIJNen7rYs5J6zDkANg97/X420CvDDUmNeRJQWLxL5t+fWtlrU+z5UhvfBA4?=
 =?us-ascii?Q?SFYWvs1SxKSQ1tQA/vsa+VJBIWzkD1Lq/TcEzILbJf291nnm2z03YA4xFVsg?=
 =?us-ascii?Q?5rt5xBt3gmv92ROjxYPL63JM1G2Ni0U4sttjGuA3Q8VN/7FI/qBTchO5qGSW?=
 =?us-ascii?Q?TCw+jsJkrNUB8kKPk5NWXNThN6qrClRxijFy8Q4z4AshJ3d92Rn9g7wRCXww?=
 =?us-ascii?Q?JNm5tavBrpMc2B18bTE+7zUXDI8qMsmz7UDusn2Q6V9I//yk9XQdr3NGhwtY?=
 =?us-ascii?Q?ED72tFVt8/WjXBZHCwvCt/sovOG/wHV3A3D/kZOtQ3v1BJdmChuU2lnyxLZs?=
 =?us-ascii?Q?1sdo9vzgF2U+nQ09n0KL8YriNVmE18G7Pag3leuIEM5tjCCT+VB3OQcZvzHo?=
 =?us-ascii?Q?WkfFa+5R0d7dYxvXH27v0bnCS0krfvetXxc70h3rHLz8xwYKIqBVapEREEO2?=
 =?us-ascii?Q?++iPnTEckaky8X1TYOCMKOsyQeHJGr6fWgxTZw6G3YTTUMYMTWvjrS6kstp8?=
 =?us-ascii?Q?D4eXRXIbSJSJuE+SjJpnb11Fc7L1XxMy/JpaTmcHpcFzX6EJzlKGaYbPo+72?=
 =?us-ascii?Q?XjFl1x9X4P5k9Y7vCd/a4JCj34OS02chKOoXtfjQpfxuUKrhnKWWmF0Hw5Af?=
 =?us-ascii?Q?eHZtgj0S89lDkRsVJIw40BTEtrMSsxcJ1r6N0tC3O55TSTH1OvCeuY9dgf5Z?=
 =?us-ascii?Q?xU6U+XjaQnBlVixfUOZzAqEp94lL//Z7d/MeNwIOhYOdoBAgnX6R6DJ86/JL?=
 =?us-ascii?Q?kYSWdpeLkcYplWCcxNijggC/gGVo2uKme8Os?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR04MB9386.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(7416014)(376014)(366016)(19092799006)(1800799024)(38350700014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UjCrOQv/mWVcKlNuvyAzjXkhcpgoVWWVBfkVGZYTNTRZrUCm/DkjqdNPnSAE?=
 =?us-ascii?Q?ap1sBDfj7Y9CKZoUA/hk0K+e60J1S11+tiMSUu87d0ICcwsz6lo5c6gGh950?=
 =?us-ascii?Q?l7Xaf0AdCL4BV5VAkErBcSei2SlRRLXe5rkvAk5ozfj+oG9ZOXcWeETDNqP+?=
 =?us-ascii?Q?9Hofm224Mw25+F8EBphOaMkb6pD/mdEpaumR6Y2SPmlIFe3ukSoC/ccsjER7?=
 =?us-ascii?Q?XrCRPOfbRgwi37fFRXcsX3yswC0QU+jOOVW66OnPOOMSTWNS4iFY6cVIKDf/?=
 =?us-ascii?Q?4i+ZPyR58BqOCqHdtvuvDSNiye8dK8oee+XDChrA357zqZOfdSgth78Xl64o?=
 =?us-ascii?Q?qf1/U9nQK14uTcV1zno8bNrrxYVYtkscdcLFjjG552TomHhlFheUgQaAg+QP?=
 =?us-ascii?Q?LTf9gb80ieZV97tA3gQ0P2xJnDOL3wC6675Tp7sSf5DF6Rr0tz3qRK5QWsAV?=
 =?us-ascii?Q?yl6Cn9rDEzf0M0vrGj4QYv6+Wued7gVpnP5P0YCDoj53tx+8LIHhIGCyX761?=
 =?us-ascii?Q?hv49ZnkVY5WzHgG4Obhq4RRvXHCvdmJHlxKNHcudgNXjtBZHg+oD/vkBHH8K?=
 =?us-ascii?Q?A9iIhQ5qdL/7JFcFKxBsIihYDLJUugTgjIKGm3woRLd82k/Se/x2fwGR1/7p?=
 =?us-ascii?Q?pniFvrym3ZkU8giOYGAy88F2BIPj2gIKfKu53HeglyuTeuenEE2mBJFviBJs?=
 =?us-ascii?Q?n7SwlNqkAPVqPh02lN+m8TD9NBBDQfd5LCde/2PXxwnzfx5y3YkJbTthWGnM?=
 =?us-ascii?Q?a0AtwZSovvoiQ766q468tNNvWDNNovxVE/uCCnaH4yqQV48fw4Ryc/Fir96f?=
 =?us-ascii?Q?jmT8hdEEZrUD7tAd9xgPLU0io3XQ6PoHiIfyU0G6Molmd6KtkhJwBLbEi0Zo?=
 =?us-ascii?Q?DxsiwHO6/9c6Fuxh1gpoMneugAlPL9w2/VNdhHIRkhFbqSGal88ljHW4Hgha?=
 =?us-ascii?Q?OTfaSC7DwjaxoQ1YpD/S3ykfSXLOXE3yaB3VyKGG2B67XyP0X3REj3WVRoQ1?=
 =?us-ascii?Q?8nJdQ8hHPJSV4M5fASBtSSWBijRPiy2Szs5O+0dJrpLreKfMkmyuRppX8CoZ?=
 =?us-ascii?Q?dZ5/P1GovisfbAaY4qzP2jaYMsDJFGj2h6jZ5M9w5fc/cmp/DVYSQZ9RS9a5?=
 =?us-ascii?Q?vwdZJuga04FMb27qVerdIhC3GgcU1IoFwOBG+rE1bFQ16HXhWWnFp8PgVRct?=
 =?us-ascii?Q?EcWuhhpZbI/oX/kYpBSEpGsJMf0QAg0VFpFWpNi4cVuVch4FQgFaRInyKg0f?=
 =?us-ascii?Q?2EV5PF/GecKnE5qYSJP4txL12feZK/8sJkazgyZ2OB6oD765nn7Nk8FndO6H?=
 =?us-ascii?Q?5Z3KnqTCWaTHxf06pr8Bim7vJa3aav5UCN939vNoctwv2VOcJ5BRlAMBDzYQ?=
 =?us-ascii?Q?sjzl9WJpLPlSUZzK30eh9uxVWVYsRwOHaDiIkKxFurfllu2QyJj6a7xTrxyJ?=
 =?us-ascii?Q?0gIekLNOZkY9eKlnqjZOR5cC+wFS7V0tsNjP8rKB++tnpHNPWUT08DKMEBig?=
 =?us-ascii?Q?oR3EgB6g8sSZ2EGIXGUyk8RgsGYN9cuv1oJfsR0U7ij/mUzmodM4IKf6P1oN?=
 =?us-ascii?Q?kWuqcvHa0GCsErL7DpuaJ/L37nXN1W8xgs6YyeOX?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d704e83-e0a4-4ed5-2fb5-08de3c50a356
X-MS-Exchange-CrossTenant-AuthSource: AS4PR04MB9386.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 03:10:16.9963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4H493FMbVRazd/CYx5HoO0w9eSbAlbRXe2c/pB72oRccOTfgQ0VghLNM5MlHlkqk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9430
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A6E0E18000B
X-Stat-Signature: i4e69p14txuerniytjposp9sossgc1en
X-Rspam-User: 
X-HE-Tag: 1765854620-437695
X-HE-Meta: U2FsdGVkX18aCQsIcK2EMXNvEj1iHU2FMM2Ra0DCnh04QYSCkKgjtSChhpTOmV18PfSIHg7Oj5XSvoCX+J9kTQau+rzDcQrIM8DlGw0eqaU5vUF0ZSlLoZULvKuS1kqU/8sSDcdslh0g9xmJ4QXdUWTqLgZGCzCmkaC8Ud2WwlOPdJ4Ol29WTWWFqbCWE5LojmdCQS6d8h4nTtGPgvjqZyMHKtbtp7GDFERhSvDZfQmvf0s2BT7p3E6QxxCuWS7ywwpsBRWRa/7/n/OXVpnLUZALMEysMmDgjQVrSaHRObCvRqmzgt2AoxwgkC6ueAcGjMTp5gSCowUgStPLq+riiAJ0TmwlMPGYWKlmS3H9V9bdtcDrIOcWBisf7s+3j8xGeYIA5Kh3PGJCGsQm4Otg8Xr65QbMJ0DywGpKMvhHYL52tSqVgQdSCxgU9qrXacrz3MYKELRNZ00eRQo1ZUI2ERsWAhVD2/xSw3yEks520jYaU6iVQJBIUyNFwmyoplr58W2RGoqjPj3VpAnY/SkV3qLUY0H5J9tvz7xwfCGbH+d46sxDrO4769gfFZFJkZFgtasINkxYK0pDoVRRsI9oWajZq9S5VGXA0RNi8KbUSuq4l+wGKmeTRA2a1HpMJPeraUCQNTrjVdg2tj5hlE7R7shDbTfTHUT8eDbU8JcjHB45ibcUTyfy1KdEi3h4SUZUH6fiz6oia8Wvbyo1rrnz1J6CnOuvwnKCtsI9i9yuwClud+9rZAfXbWkvDpTU0xaHHQAFqNiZ+JQ+mnHQjwPm7H34cKGEFSS0c4/vODGTObcNbTgYxuLKTiHmRExR8DDegPGR85Q7T4tkZjGlveQ/IF3KzTdfinVJa1E+6gspBNcizWBJ9kXnD0PzFyIhEbD2P0ZxytufzM44BSlw1u0Y1C0et34kBhuLSNz7OLYKp2RejA6t/y7Z9MbXzIsJEEVFZ8R+7/7ITVp659hAEiC
 maA9us0z
 VqZiPjcnzcXsT91F0/Oxpv9e2CVBsJ7mcrntqDSOK7DW7VwZXbpWG6OpfJ/xYb4KbaacueZXnqgUDWUSfmC+SwawlnWBIyaj0BlLmo2SaQnl96+f9so513T3aDy3C4BR4pV8wH2JkXfAmtnhH2WbBWsz9adqRH+Cb8ZZ1X4ifTZIK0zuGppN0SfQ7am0p15HNpK0q1TvKKauvMa/px874adl21eFJT/YOEv7nyUitm8c7TnnyngWfpbaXPJ5bzM+75R3cb3SSoVLVP05Gd/G0VbnqoW1+HVcQenjbLEYMCnNR9cgFC7/1FcZQHVxvp3joD/kVrlkNGrdeet856a2txTxb3gCjCUA6XyD1kt7BFdSZs+kOM8MPVPILb9Ye+jmItTGOiyxphr5VhoIM0MqDQifDjTcXNiaZFFoK88+BUYNBiGQMHmfo3ft6Q3Cg5Q1LL9Cg3y5g7gxj2FFtDLT80IXTN1yn/ub4BGb33fpaZKWuK7PuUx0OaHFwl9+bp7QxeXopuaRv36+Q1GQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 09, 2025 at 04:20:27PM -0800, Oreoluwa Babatunde wrote:
> When initializing the default cma region, the "cma=" kernel parameter
> takes priority over a DT defined linux,cma-default region. Hence, give
> the reserved_mem framework the ability to detect this so that the DT
> defined cma region can skip initialization accordingly.
> 
Hi Oreoluwa,
  Have tested i.MX6ULL 9x9, i.MX6ULL 14x14, i.MX6SLL EVK and i.MX7D
SABRE-SD boards.
  Before this patch, i.MX6ULL 9x9 failed to allocate CMA memory when using
"cma=" kernel parameter. After applying the patch, CMA allocation works
correctly on all tested platforms.

Tested-by: Joy Zou <joy.zou@nxp.com>

BR
Joy Zou
> Signed-off-by: Oreoluwa Babatunde <oreoluwa.babatunde@oss.qualcomm.com>
> ---
>  drivers/of/of_reserved_mem.c | 19 +++++++++++++++++--
>  include/linux/cma.h          |  1 +
>  kernel/dma/contiguous.c      | 16 ++++++++++------
>  3 files changed, 28 insertions(+), 8 deletions(-)
> 2.34.1

