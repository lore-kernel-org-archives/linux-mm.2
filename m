Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 083BFC624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 15:14:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B2326B00AD; Fri,  4 Sep 2026 11:14:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 161C16B00AE; Fri,  4 Sep 2026 11:14:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0292F6B00AF; Fri,  4 Sep 2026 11:14:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CB4B16B00AD
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:14:32 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5E4CDA00FB
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:14:32 +0000 (UTC)
X-FDA: 85176426384.01.31EC7D6
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011059.outbound.protection.outlook.com [40.107.130.59])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7DD5A40007
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:14:29 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.s=selector1-NXP1-onmicrosoft-com header.b=hSLWPtw7;
	spf=pass (imf04.hostedemail.com: domain of frank.li@oss.nxp.com designates 40.107.130.59 as permitted sender) smtp.mailfrom=frank.li@oss.nxp.com;
	dmarc=pass (policy=none) header.from=nxp.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788534869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JIw76RXo+luzq9xhJz/Jzk0+qva5uyRVF9WAiRPTK+g=;
	b=G1d/nkcSicYSH66HSqR/kXlqhtz7pI31dk954ZNMkO+jubuUWli5imFeSLiZPj0O+5orRg
	Wo8TXdWRYw6CqRiaw8BsRkpnuPFLipvrO9/SW5SH9hEAZB+Wc71bsH9m5QUK6ZVyUrF21t
	5Me/dzo00bYdXML7NUHdxGw+c8ghqn0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788534869;
	b=lDfKRvlrlgSHHoIdi4lBoqMjE1hycsHv5MeJ+0xXRXtOpWWZEdJ9oMXtNKgu1lrcICsCOb
	FXejgpUQoGSoMGRKtvblJ0I2gtsiUbiCLcMdqDT6PzCsBQt5EfNZamw5uvmZrQD55h4l/l
	IjDOgyjaKjbSrfX4qUcci/ViWlT+88Y=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.s=selector1-NXP1-onmicrosoft-com header.b=hSLWPtw7;
	spf=pass (imf04.hostedemail.com: domain of frank.li@oss.nxp.com designates 40.107.130.59 as permitted sender) smtp.mailfrom=frank.li@oss.nxp.com;
	dmarc=pass (policy=none) header.from=nxp.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DEPfWL0P64HKLZcibKyuSHva6hMoh322Z1Sdy10dU3OxyU972fNrvOg1aMGo7mXsXmgytI9S3CnHAyMpQ9aXIYUzI0132sR1DWylyIHIa5MnKSGVONxMe0kny13CWBJ+eR5MQEnXUNckjf8r7KNuAHK3AYeL8jMxbI+Uh8z2Nws2tuC7N6HJ6i7isNg9ogzUWOSCgP7bqlL7E9b35I9sCJm21Jne+GhP/DA/9h/BUiGC9BFnqKjegX9G1zEglROkJXBbfhsV7OokcyWwSm01ESZlJhO9vIuGDv2BXjrhviIj/hZ44T1MtNyef0J0m8xThIq2xlLvjSb6rDp0bqtXeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JIw76RXo+luzq9xhJz/Jzk0+qva5uyRVF9WAiRPTK+g=;
 b=ZqKb1dqS48cWYyfN2NZGBFKJd4U1Z8dcQ877czeXf7KWpwj7XAy5bsHa8tiLo0+RWvDdwQ88EXmhm2FBguUKYtOVyrgJxBHnXTBEry4GSAZnBI9Y75EmUACR8wnmudMwj9A91zaEVzPyzRyL/5oFVQiTrAjrVbXOBHE6mcMAQXCBSpcUkzc3Oma5xJNvfupyCdnYIt85lpbY9YkxyKrVPZAz5/BEvefdm0n1hCXTMY7NJWm4/4+lXnei/CcQ3vWXsRZ/jBz6z2LuCF8u12ZhYQPhozHSCW0mtfxTcogEJbzA7FZZ4tnSp1EZD4seXFE9Tk1W+mfLea+pBQGwwa4v/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JIw76RXo+luzq9xhJz/Jzk0+qva5uyRVF9WAiRPTK+g=;
 b=hSLWPtw7hdowgmg3TQn9pendXr1OyhB5e0pwN15i0mThC5Qdh8NquQu6b7k8s0Q4gETwFWOtzdRnwymIZ/hV8IRLAfN0JLnVQvLRZzRoi5hNU1mi6IMQ8mA6yTQTFLNtL0qEyprH6iUz3ZcuFC0U6++IiBXcEwiy8CwGBctemKVXnEt/zB8efkCh8FDEcG1wW3PFrvtzMAQe6E5pkmMHT5oUxPzEOIcatp60NbDkOZQ+qDxOIX7eWyNxm/w8OTkmVhYuZGEPoeTkAg+ZXOU3Q9I6Nlq0njC55XRzj8yow68kbNoRMhNMaBxSHcr2+XXDJ8foQrz/fIn2tfpX1Wtj6A==
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by GVXPR04MB10875.eurprd04.prod.outlook.com (2603:10a6:150:220::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Fri, 4 Sep
 2026 15:14:26 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0360.008; Fri, 4 Sep 2026
 15:14:24 +0000
Date: Fri, 4 Sep 2026 10:14:16 -0500
From: Frank Li <Frank.li@oss.nxp.com>
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, hch@lst.de,
	harry@kernel.org, imx@lists.linux.dev
Subject: Re: [PATCH 11/13] media: nxp: imx8-isi: Don't use GFP_DMA when
 calling dma_alloc_coherent()
Message-ID: <aprgSHd1O4WqrvX2@SMW015318>
References: <20260903111836.1777265-1-hebaoquan@kylinos.cn>
 <20260903111836.1777265-12-hebaoquan@kylinos.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903111836.1777265-12-hebaoquan@kylinos.cn>
X-ClientProxiedBy: CY8PR12CA0024.namprd12.prod.outlook.com
 (2603:10b6:930:4e::22) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|GVXPR04MB10875:EE_
X-MS-Office365-Filtering-Correlation-Id: 9799afbe-792e-4e28-48ed-08df0a973434
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|19092799006|1800799024|366016|11063799006|10067099003|4143699003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	b+6q5+pm+bGPZXq3/uwekXBJLM+109D2Bd+mvWHq564rCo2xkMRJ00Ir9bTDeXNNiEHAwtbNBIkoXUWoLGHeUYTbJHKxJOAJ+2KJvEHsDkfPsv985AYtjvOKa4jW2fwKohrVCi191R6ewILSCRVTEWwqQBo57GIvTJBg2Sg5FDowUhYRMhqXaYUsgnvPt5jMvIemKCRMIt9xrHaSJG6S+BdQ9fVwZgvQiShBtGXaFYAJrthnhlsBNrN+RoGu6aQGUMXIv61W2EWhXpI1P3CWKtVrn9dp4TEDTXvmP7ORjjwqrFIwoj3ksTr8u3D7BcbIY7yXKzTgens1IVmUK7z4z65yVypm4R7dEtPtxxmtWw2gUDWBfgUlzUNbvbwdBixcU6/UY2ETJqCO4s11BX3pza/TppNqv2TDPwhnfh66zbSs5r2vSKJ2IUJ1r2z5Z6aElQ21GYrjrG+90DLywOUfNcEtH65p+GXvUJ70S4Fhf2ehUvq6I/PjD89ppkvi+tFOvcGC64lhdT+6X/j936p3eXffsq+nS8ugQNgZa+VMrFjVBmNzsXNonCcE0y2L0z3QFhGOrJ9SC2O785mJxxGMup8cL6KRsXB8I+lOtHDagl1f6mzlQoIQ5tDUZsWkxupLj1tIphwf5Kpj+xrgmV0AHEJaar9tAzV7dxcTrbfqnZc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(19092799006)(1800799024)(366016)(11063799006)(10067099003)(4143699003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dffxY0JLi/kU3gmaQBhRKTKC33C6L81evqPyLJMquPOdjyqQxZ9BmZ4GOtXo?=
 =?us-ascii?Q?xh1NMJv9tuMRs01O+TP/h16yiAUzaFJqIe2LEffzF57YYVVtb2SuMjzXnqDk?=
 =?us-ascii?Q?U0M8Qr4Rzeb13iFjJ87Xh1OOYBqSKVyoEfjOi332yN0bAEo3RSUtE9xtgMSk?=
 =?us-ascii?Q?F2y6MW43sAf7wMau1/ur22gwmVfq73cLSykUpUSB2A8RhO65Hovnd4fp0IQb?=
 =?us-ascii?Q?ynnSWQYIcmOcJ0IJHcGNLBgAjWYbeVaSIHcHd+MK80irIY5MXCaMKRdqp/Jx?=
 =?us-ascii?Q?X1EA4Lj8LcsymhKPkWT4Emj3D+IJ/6kw+tWMX7FmzXlZCIV/kUBvcEmJZ1an?=
 =?us-ascii?Q?yaIW7qNcF3/mrGos7rathRSNMBXZz53KFDe5pubiaAh6hPadL2nMLeH1I79e?=
 =?us-ascii?Q?sATQCMHs83WgIvAm4BMCP9VZaa0oLNwufCX7zjt6E1B12euopg29YjxlM9ei?=
 =?us-ascii?Q?Kt1Xq2BRlKmOq5ue4dcx1QG+d17SfvAZEoIFgx/5OslY9zjHlk3lgodWNq0f?=
 =?us-ascii?Q?bf4nAGUJg1NemJw7l6zsIUeHrBAqbcdIWGMDZnBQkeDGkaZ+bUGNYXvtmyAv?=
 =?us-ascii?Q?CcHVj3lWTLx3nU5nXkQdoxJPtCyo9HyzucdHvieWYYw1vr056cM73ZEy1uD4?=
 =?us-ascii?Q?e2J0AMsJSxPGwzgpLC2J6eqiA8kqQnQ1rbaUV7lp4J6QRLqfh2xfW2wwuEKM?=
 =?us-ascii?Q?r+kuhFqEfm6XbyiH4f132zq7CVfAJJQqCwjdu4TePN9+LG92/BcnBja4jfL1?=
 =?us-ascii?Q?PibpjUeg012c7bq4ljYodGxffsJ6LkkcytYtvbwguO5E09VWti4qC/5UeFAP?=
 =?us-ascii?Q?QSn5BSMFeZTkwecDKlumPxOoG/qV6fDWeg2OLGuZH6j7ksuMHsbkf4cCTdyV?=
 =?us-ascii?Q?mWshnmM4fwO5ZzxmD1CszkNtogQnL1MZK8/Igq3zu9gOLNvHVObPX2/v2+xG?=
 =?us-ascii?Q?a6rP1WU1kdZ7sv808Zrn9/UGIIaL+tQXLWDadrlswQTG+B5RNPmX4Vx23fOa?=
 =?us-ascii?Q?BM3E6eVzJNbWPI0m/xFqxQJxM4hGhaxCahMZ3ubFpF+/YLvuPbomojnVuC5Z?=
 =?us-ascii?Q?CBQBqwlIbgVMvcZH2WMb8IGPa8io/D6k4gWrhvGFpD8disfpeVJIXaupf5a8?=
 =?us-ascii?Q?jyO82aX/2oculWsQNaYhuKc95qyu5HOltJ5pB8mRreGoUNzqtmoOZ37xqoyr?=
 =?us-ascii?Q?Fc8G6oyREIN0SmhMssWegzbbQ9BBkNdQlCnoRoivXexnMqRprzJzI/483iYS?=
 =?us-ascii?Q?UtDFDbZIurR1C9UVkXEQjmOwVls8YCL/hv4rGznh2HmjLmkq8PnV+hhWRAhk?=
 =?us-ascii?Q?RVryxZpH9GePnxSco1qvNmXArao73pDBn+uTQ5Cq52sutHta89wjDd7u0Zpa?=
 =?us-ascii?Q?EGbW7mruhq/E1/n7HLmgWGu068WKzpKUodAhLwy+OvzvBpDnw/gVdNRhjdU4?=
 =?us-ascii?Q?r1VpWt3KaCHYHA2FbhDcmw3+Hom26AfPAA5Pajg1B1Bnko3fjgwvsjbsskSw?=
 =?us-ascii?Q?JTaCxjL8kDM/vBmBINtbrlJVvVtx+MHkw2/gZm4LYRXUuIPqfZgf2vF3rQun?=
 =?us-ascii?Q?3cusGP7hAYSlCW37S/zYETth1IkjNo990XH3rDJ24NhMoub4WzjGYDbF3Ism?=
 =?us-ascii?Q?5wKHR0GlzsumOO5yh0Z/RgsqxJOj8vIQnt2HluMx0x0VECOGo4S3Lqvmq/Ek?=
 =?us-ascii?Q?Ct0DzpVV4uDg5ggP4+Hgvx8aPyTMu5woJKaMWsVl85OYupqRCrZ+w9GJPoZr?=
 =?us-ascii?Q?0K4s6e2UMK/CaFezGjA3scIiboIF8093lBURIv4GVBrR6Ymscw3/?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9799afbe-792e-4e28-48ed-08df0a973434
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 15:14:24.4836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6uLJlKdWRwY6wt2MdNZdG1W+4enrPT/gief/8qyvdOBxfx5GbRZuFglCpB9bZQjuHoX8aRyIYx9+o+T9vd5WX3nSiLBd8flTP3zMjnmu6XZ8bjatTmoFYTsAf47VPE8o
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR04MB10875
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7DD5A40007
X-Stat-Signature: 6qmm3g44i6xwfoxkzkh96mtgsytz3pay
X-HE-Tag: 1788534869-715052
X-HE-Meta: U2FsdGVkX19tTXZiXuvQrvHKTZM5sgJlgxcZTyg3VLlt4JOiichQk0IppBVWHVs92atJiyWq+LHB08ygcH1ila47wlIxLTQCAwDfaTpcHhW1pRUP+CUoHbKoyQbVsCOvDJaW8xVwMl1UKswvrs+puMjvcauNTY+zdSoHbw1o6r5jcFT0nRUP2gkAK2ftEmQoCH8RyMzH148JtLeRlZBzlgXOZxRxueaQfXthBen5uWzZNwD0krhpPqSORXmOeAEe5cBw/C6bpbhaqG+45OaE0WUL2sKFvUKXAhkXGI8CaGIs/JI23un4/wmO8j86hEMbnR/EOZ+wszibow7JoKAmvXH36lgtBkmvRChqUmLPLlaGnKFm1mRVgNRHpa92YT9Sj3opoOcas1jMK3RF9nR6kUCvK5C6As/xVUPOu9QG+rZ/aEVK2rTpNnyA4C3msJIywkwCbvvpmiNIcnvoqP231VEjnw0n3pdy05h5ly7mLvDL09HS2yVoU2xHDgmpck1GH9t5Gt8XN0hFxiqM0NE8WPv3z0R+POFDkjTp99xXX/EibEjaz7OBgCymdyBCK949knR44vuOfZca7q4j4lgQP2c3XhSRXWCkvlBJHHCxiPfOPByuYT5zj1FUTcL5/kelMgI5dffiFgUNCXCHkcvAvGncCQ5bdnoA4n5WG6Mw9F6dyADuMsWQM9Wvdt80ezpt9Tgz7iuujiQ7yJWcMQQyzW7lyOjkWqtfLJB/BLFJErQl6/Ymp/UmsFfIgP/+RnEgoI18PoeaYtzK+gjq36OS8ohhhkzitGBkRjog5ebRyv+mnHuJ/RPQ/Bm4WM6iHWWtj2cAqusb2jnyZ1xWYG0WmGz0ydi/GUhkVXphKCfFODSdREEWnJJX1z1TFdO4CJghLWk9mXWbY2YQoK2EWRA3FUyGFGq1H4SeU2h6h7lxzFQDg92eZ/JHi77EdYeFI3YWVmPgyjRXHOu1Px3Dmv1
 yrZLQeMz
 pMycnUjsA7wRw8VJbcLVoZz5hXDGSf2H/WXjoDGZs6bLXSK6Zu55OHCaZBc9GdYlT2GVswyFFZ1KhRomp/sg2QkbIHNPny3nf/9OKQAE0hZoTzUym+qYiLiza67TO+BpLBEPu4s1fZXegE7jml0yGmWkLAFIBuc8aVe2EqJZHDdakRAvNTXYa8QBpNKwyJ22qBw6wcJ8Hrd7VHRMMqIrMWXZGawW2/oTy3YNnZ1S2sBjOhCbmP1/hqJoGbl4rvsQm2TZ/hMFKgNYIikmMDF1Rb1P8f/GnPK8NL5pyoWMzFktP3tqQGbLeB5TEJuuEBEeyAoCz64f4ouADNunloQByvOlgCLaiPhEzZjr/BBBS4uNQPW/FQUKHiUD8Ls5z9p9oTFI0rUpsnF54CLH4nrD1eDTq40niz/fktwGkxAaoFLpmrA+EZH7NEr56/OJY1eDcZOMdywQBLIZOCTRm5neycOXdRA4UhaD2HJIsR1nCYnxzJ/u4ThxttiROVYHPtXZXt/ZIbKPxhESXDt2unEOcfrQU67F7cuA+5CVc6srek1+bhRHILdYmW5w/DpqwUVhqXdhmN9v6LpbgWFA3EUGi+oEfdG6mHEYEDTJvTzePte5i5dM9LbbaER2x8zXjNNwC9H8n17/exmGzCCNd4VWWAEpgroMy2lQk5u5tp87VUAh8Hmk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 07:18:34PM +0800, Baoquan He wrote:
> [You don't often get email from hebaoquan@kylinos.cn. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
>
> dma_alloc_coherent() allocates the DMA buffer with the device's
> addressing limitation in mind; the DMA core picks the zone from the
> device's coherent DMA mask and ignores GFP_DMA passed by the caller.
> Remove the redundant GFP_DMA flag.
>
> Cc: imx@lists.linux.dev
> Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> ---

Reviewed-by: Frank Li <Frank.Li@nxp.com>

>  drivers/media/platform/nxp/imx8-isi/imx8-isi-video.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/nxp/imx8-isi/imx8-isi-video.c b/drivers/media/platform/nxp/imx8-isi/imx8-isi-video.c
> index f45c2aae59ce..fc907d357149 100644
> --- a/drivers/media/platform/nxp/imx8-isi/imx8-isi-video.c
> +++ b/drivers/media/platform/nxp/imx8-isi/imx8-isi-video.c
> @@ -773,7 +773,7 @@ static int mxc_isi_video_alloc_discard_buffers(struct mxc_isi_video *video)
>
>                 buf->size = PAGE_ALIGN(video->pix.plane_fmt[i].sizeimage);
>                 buf->addr = dma_alloc_coherent(video->pipe->isi->dev, buf->size,
> -                                              &buf->dma, GFP_DMA | GFP_KERNEL);
> +                                              &buf->dma, GFP_KERNEL);
>                 if (!buf->addr) {
>                         mxc_isi_video_free_discard_buffers(video);
>                         return -ENOMEM;
> --
> 2.54.0
>
>

