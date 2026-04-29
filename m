Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19928CD13D2
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 17:09:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 734476B0093; Wed, 29 Apr 2026 13:09:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70BDA6B0095; Wed, 29 Apr 2026 13:09:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D3636B0096; Wed, 29 Apr 2026 13:09:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 488C36B0093
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:09:29 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 14EE6A0182
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 17:09:29 +0000 (UTC)
X-FDA: 84712229658.05.6F60992
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11020136.outbound.protection.outlook.com [52.101.193.136])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5173980011
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 17:09:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=NjnbyvhT;
	spf=pass (imf02.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.193.136 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777482566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MxfzNhIjfExThWkgUt0zk8a+mQdo0RqgXJvKFp94lE8=;
	b=ceNu046/wOFX3QvcZ0Hs55llBfk8M5rnI6Ya+QtioYsH/TL+nH2egwG9TtUB/N96notJ6M
	lZcOllMJtsxoEMjf0zsEoS8TEzzFK0nhkPNmB2daWk9AtwEkq+mG9DFdDHwaa4EOR+0yqV
	g6WBP7zC5XtwuewdMnPRnYB87sXdZ0U=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777482566; a=rsa-sha256;
	cv=pass;
	b=Bb7Ux3r7gj8N4jEq4DjZwfB9ZArG3SsgNFF//GkdoAB7bmLm7wDrqrOy9NzunaNWee4m56
	BkWewt/dIByD/UNzRdq/xbXSG5k2qQsG8v71fEEGS82kacDT9U5mX2ySwnfznenSub4nFX
	wXiJN0GfVbLdKwMeF7O9BYXXHICWD7g=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=NjnbyvhT;
	spf=pass (imf02.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.193.136 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eVV74fFWtTSoBFD3yS4qno5s30VFApeRnZRNOpXYKsGlFiF5/oAHk4X8y+P5r+SoN4KHaL6tyGlhYy7vHHd4eSVLiFP+ItKwhgwf2rLD+rHwMKINFpipDflZBNESvAEAZMFynNfWjX2B6CNT5B9aDvC2nJd5zatyB8uMGIEW69E1lPeIGyP//g1uWY5JcMeL4S0a4W42a6fc3Zp3QTmTsFuJIrYFhKN1/pL33cOJmu3kws+u05jrpw/sl54JO6OdD3Y5Msk/0BLcYizW9zU+wepip3+kCT8djG7bPTZIEG33xtpmuStIZ435cKQEHcZvFm38JeCPq9bqzJvyBpFwNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MxfzNhIjfExThWkgUt0zk8a+mQdo0RqgXJvKFp94lE8=;
 b=R0mdbjOzDqLDO9SnJZ1KfmS3TWfp4XL24CNvAQhpfxhgD5wPNlBsso6G7gGvmlevAlvENSgXXR+WaOMPh39pjSZ1PBabkpzB/OsyGimJ2wAjZ4PRuilt7R6gFlyBcVXOgeOLQLtJL+r73g4ZDjeXArQrZvR4vrdMesD5L1449RZZAhIQyOoSzDLzRkYSG/myjomCq7B9zTtQwaUNQh21itQ8pWhaf7te+yoC/16Ej9G0BuSA5p7cL2OEH1P0xRDjxxGv6bNgfn+8ORRRmQAoFomVAr8Hwl4MB2rmSomKRJo6yx38JPH6nVL6ekipp8suZMiVxsBt1TvxnWeghcGfqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MxfzNhIjfExThWkgUt0zk8a+mQdo0RqgXJvKFp94lE8=;
 b=NjnbyvhTG+3d7wedYjVJ4OJIGzUwW2uFf7IA+lSi1ItKNXmfZ+MV/BAbHahPnvaIp/WGIUv3LC4oZ9rE1f9GKBr4ZVzd0U+ecNhSyYxnzzEkmjpDHS4YPs5MBOToyvExcnq4xswkWTE/CKIckCCY6b30tbnJg4UAX5rIQjo8gUY=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 SA1PR01MB6671.prod.exchangelabs.com (2603:10b6:806:18b::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.26; Wed, 29 Apr 2026 17:09:05 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0%4]) with mapi id 15.20.9870.020; Wed, 29 Apr 2026
 17:09:04 +0000
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
Subject: [PATCH 07/11] arm64: mm: introduce __per_cpu_local_off
Date: Wed, 29 Apr 2026 10:04:35 -0700
Message-ID: <20260429170758.3018959-8-yang@os.amperecomputing.com>
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
X-MS-Office365-Filtering-Correlation-Id: a0219fb9-afd2-4272-1b9b-08dea6120454
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|18002099003|56012099003|22082099003|55112099003|921020;
X-Microsoft-Antispam-Message-Info:
	oMlYUcGBvA/C4xbnuK/Nz3KnJeDqz12RmUepXa/6VIrxo+22D/yXvCqedOpFAE+JHx8JqKVW5Z6LjnvUCn6tSCUjOSRD0DQwxW0rYto2+JEVbPS7ysjgd48+wO3rtQtrIlaa3dJyOTRna+sm3S5mcBRH0P71pp3g2vs0kN82uaXveKBekZfikeDiSFRWsiFdEmqYxPuolQhsZ0otnIBYDPBAkRdtitc5tajpYZF4EmH5HsmqWh25qc4nw44wAQ/72o2sg7M6Ux2/zOkR0keSA2RgvW0Ff5jLJz6Z8J0Eg72dFzbSXbW1vVwdqDk4VMRgOVoO1loKz5bYaQpoiZLUKrvzGpk556Op0TP/+FArh1CBAsFXz8fMJIcADcUgy5jSt6X4NVbjuxsIYUpbKd+EtGmLq67l8MWGePkc+EXNBRjXeX7n6UfBYF5A2EoPmRf1EuJ4rx/H2KonTohy5/Xo3AUTHbcYdvnX8XS/CQNIUd/wcvglCxNScVaT0ic/pZGOie8xaBKtVqi3ExNlG8JKDuOCW1SDmfj+KI6+S2/1zHEiiC0PtpqJiyx2h11hkVss3MTNFZdwj1xUxa22+umDheYlYXGPOVA58SH3oh64vRU218ShhO9zOu8TQ0KQa2DYZJFmbBrNd8m9ZikAUmHugFMm7gl9YCLJE+7q0Ssd/y8GU8uabIRkESt6s5YCvGnLUxTiONNH3NkFBclPa7ufYlMyent365kPVzux1FXVdQc9vMN9v2Rk3EUDdAr2rSWV/fVpH2nudh4bInCVzyvkGg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(18002099003)(56012099003)(22082099003)(55112099003)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7C9rYz/hjIe8RMMnnFoAXNOTVP+4dJAd0wacNYefaja9WEGW1FII4iXNTx0p?=
 =?us-ascii?Q?tJleopt75ckCpUONbu3e/WJBEAKO0N8SzHTMcrDwdcFuE3XuiGUWtoknmhV4?=
 =?us-ascii?Q?9XpxB3Z9yZ6+dxBWySw+eErBbrKR65Tucbh1N2o+YGv21wmGXHucA/bAOUvR?=
 =?us-ascii?Q?9DHeRmcSmdh/316i45+si4NP9yhJViFdKvbA+8YRHsVmEUPNHVuUKeZ+g4jI?=
 =?us-ascii?Q?0p+tYi3jm/6Xjnnoj7sGZD4pDNnhvEEvU1VPw61CYbIUf7W27hBmS3+wKlZL?=
 =?us-ascii?Q?GMhajOw70A58TQBSoJuygDq4DacyiUHMINKee6dG7EW2i7v+ZFUkc24oVV0b?=
 =?us-ascii?Q?iGZWedAz0bw8V7QBMarg20JFtwFIG6hXY5DvJP0JNuAuvP/xhLHhqIaatmMU?=
 =?us-ascii?Q?fQ6bzxL1YN7GQOlULFqm8zqjzxkEXUMVkXE/H9Ti+Pgu5hLockhX6mASXWW2?=
 =?us-ascii?Q?9lyB4d4RRC1jAp90nOh8JVKGbocwBiepHFdNqZa1ae6OqIdTwinzXGTzH6Er?=
 =?us-ascii?Q?ty4QlmUyC9HZ4j4YBL+GSJ5TAccELKbWRqm2wDJzxz0aWMFryJgEYyFqk/SS?=
 =?us-ascii?Q?GQzh2Q1Ltlv425AfZisMz1tTyn9XBtdXykPRd8XxfyzAFKZ4lVhragjbp5Ck?=
 =?us-ascii?Q?A0dEu6zTQAHV+7SfVj4f7Sxg0YV7GBOjd8aMFjXP1jl1AYC4E8d0QQHcNt4X?=
 =?us-ascii?Q?Wcqii862bbdqbXimW//pRClhM9YH9a1geFutR16MiLC8KKj6wf3j73a2Ih4c?=
 =?us-ascii?Q?m2hJjcHXkTKvdQuakv447NSAp9uQONB87iPp9nBocFXPJUwLvYcz6bxEXIYY?=
 =?us-ascii?Q?4/gG5wALyPupjKH7YCqZ2p5bLa5kkis0SCWLXJUpzIMu94eZ1DTL4LQsujQN?=
 =?us-ascii?Q?opAZ23Gj5EdquO3LNNa8eX/asLa8j0YuDP26Xwz5bTc7mFZvAuccclCm9GZI?=
 =?us-ascii?Q?xTB6HceBZmSyNeGlvMQPzaFDi37MdXyWr9G/zyvbve/21TuUs/5sKsOQF3NE?=
 =?us-ascii?Q?e7AItwqJvJR16HIblJxH2xn/WFRUWO3JovxBYj/Ne02R3K+Dn4AmRi7iaV44?=
 =?us-ascii?Q?etcnbyqsJsMUCj2fJcf1lQSxFVk81CdT/5YOsMyH0SBHzpucDcxlgvpn61is?=
 =?us-ascii?Q?aUdnIDy2htHGhavZei0a3963cbD0SDHO+4dnTTA+t0nCuoBgUeoTDPfSnxy6?=
 =?us-ascii?Q?cbifjW0TFqDKHMebOf6yamQVEycjEmlQeLhFvdM7HU4CVL3zS01gYCPEgvoj?=
 =?us-ascii?Q?4PZcoclRSoCbSA34bOmCfuYjYUg6E1p1i1Jq5FO0/KuCWC4QB+DPRgNn9pju?=
 =?us-ascii?Q?8bvqzVIJ7uAT1l/goklR22B+Dd0CAHqSxA+b3FjdTGle+Mqgrda6Yy0LMLef?=
 =?us-ascii?Q?cHeS+cXeK9oR3Ct8RKS5zBPp8vuUOgttgaOIBwpcdagDd31zYaPGYaPGDKDo?=
 =?us-ascii?Q?lcIYOpC9+It3+UNuz9wK6H5C0Xw2O1gsRGLzV0gMlyWRwG8HKMKgu4Rc8x2B?=
 =?us-ascii?Q?kriOiEx2GaxwM0ulczZCgdA5sskpWnQGfWVVVyqv9X+q7usytL6R/V9wfu+d?=
 =?us-ascii?Q?H5zwOQuw8f2s14oiF2E6dq0e3s0NlypyA/zxYT6CobA+skTomPcoKB2cRSdl?=
 =?us-ascii?Q?KHvQMrSHZERDY2ddbniPSkRPZiFIqk/7CGon/vhrr3XCt2qqdyVCSy+YCKPM?=
 =?us-ascii?Q?ZmI1vWAxjYpeRo3oIm8dU39N0DjzXYGSMphNfc2Gm0ilNv49JFx+51r85J6m?=
 =?us-ascii?Q?FgIgeCjKaGz9fUApAKlRl5wURfBJq2Q=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0219fb9-afd2-4272-1b9b-08dea6120454
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 17:09:04.9141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3zkdk+7WHtuuLCx6shVmewbuXSZJ5cWSgfOSPP56v0XIHmwCR61tEY5n3iFkeeixspNOIFV7X0hGC1iHrLatjqrk0pgsHu142fdbt+h0iLY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR01MB6671
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5173980011
X-Rspam-User: 
X-Stat-Signature: ztq15zg98f1byrt8ytk5hfwqd1tfp57i
X-HE-Tag: 1777482566-877056
X-HE-Meta: U2FsdGVkX1/P3YM1MIDVzZi6qB5moXmYGX0lwfb3/ert8kHK0GlA4QF8eP4V5yr/ZG2Lmmg/1A3ZgNM+GXs1BiNiYOh74gp/LXto45zZscCBNnJmHNnY9dME67es2Um8lxpJlyA9+bMDsIcqAzln72R1AbSpBM2NRe5rrv8qSzifshFehTiBOTGbuHvWZcK2A5KsoQ/uPtD8aATs63KkgxDDu+M3kE2Cc20ciY5YaO/7obpAK6A2tHs/GcO6eaNzUeXU8sQVVdy728tlMoxhlUwzO8dvKmvordvd16j0fOJnWPFNf9UOdxyMEAop/mobOT1fVEVmgDODVwGEkfY1uON8ndjWx3qG5JTv9zh9vJXGy55P/w0xtebTDeUlWS3WWQfxlqlmm65feKk5m1+0ozyiNJkzWZhtU8xjcsgJHUdC+ugI2Tf/NxAxwqAeYxYHiA91MoSs+tMIhrkJr3jYNP7GNbuS88veCGmW4WnI2EXeOozrHhoHoV2kZTbkPWsSDHTnEE9aNRMnap8ysSCb6Yd22t8hlNoY2yP9j7dpMyAIfyg/yPzbnJld0hxWd4mAjOYEevnIvu7PJpEQqEnM7u5nmw2Kw0MYnh9xlXBWGZKqZMogK4N1C1BnVWWiEmvNn2ds6D747foTLI2yXj19LDBssCrcMqocrRq0v4LPq6hZ98aeC50hZdUsjJcnGRs9EBEVi8FPAK0IfswJe2l9SfkdVnmaD2T9Vj05I9rpxWwFanGmyu/8wk5TGy1hgW1oC8jGyrEkMgtOh99sZE3wTGFn9+JUimrwBzw7toMZtPrQVqibF+pYO7Pb/bw4maxbbdLY1RDwdMrXQaprKYglH4pJR0hfxia4+BnaUlz2qssYXWTPU34RVGdETtf7R49wboV2xqMWXBZGLs3OZrcWWSk32ABWie4IoUfS5i27g7ZBHfHab9Hgo7cykRikBkHSjyu5HyIZMQcmDrEcPHY
 Q+NdYJTO
 7lwIbcE25JDYGV2lGcmBPjC+v4W5kvZUcf4W5kE+nWeJT1K0S54hn2MNAk+EpBCog48yPVBPiWTIt5yYzANR5ALpRQQnY6BzG4qQXe2m5M6p5QKElSliQD5XjVsryeGY+/qqaSF+i04VyJN2iIT787SiavQeJfgSTt/RNlwvobDVtJH3R8P1VCvsrhRKj13TDpWDDfdU4btOuCM58Bmi5+dgw10HUKn6d9DrHvmZUC8N1ROGm2zWbiCaqwhql2Ci7+AMmSBeGs0o96l7I11Vv9cgXT1cuq06p5MajkqrVs2bV9BYgT5Bjo77tHCY5JqZ9smca+YpK5/MGp81x4uC/JF4fT2A3fKy1i7n9bv+sObh/0MitfMfZlXPaO48onYdWYSS3lz2UPDUZUFsfN9ZY/kUZfaQHdpmKf0mDjeRUxJ0XcwViU7vU7B1vUfptVxX8Yqm0+Yb7AbUKGt7RGy9HRRe/Jw6DAzdKg52jPo5gc7/x2aSDc4l5Y1+bhaTr9v1v9EIwvJYKS1LHiDzQq0CzaN4hARmAS6pCmm4VeWufA1ogWzY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

this_cpu_*() ops will use it to get the local percpu address.  It has
the same value for all CPUs.

Also introduce pcpu_local_base, which is the base address of local
percpu map.

Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
---
 arch/arm64/kernel/smp.c | 4 ++++
 include/linux/percpu.h  | 2 ++
 mm/percpu.c             | 3 +++
 3 files changed, 9 insertions(+)

diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 4caa6ebec12f..62afabf86ba1 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -825,6 +825,9 @@ extern int cpu_to_node_map[NR_CPUS];
 
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
 EXPORT_SYMBOL(__per_cpu_offset);
+/* Used to calculate pcpu local address, the offset is same for all CPUs */
+unsigned long __per_cpu_local_off __read_mostly;
+EXPORT_SYMBOL(__per_cpu_local_off);
 
 int early_cpu_to_node(int cpu)
 {
@@ -847,6 +850,7 @@ void __init setup_per_cpu_areas(void)
 	delta = (unsigned long)pcpu_base_addr - (unsigned long)__per_cpu_start;
 	for_each_possible_cpu(cpu)
 		__per_cpu_offset[cpu] = delta + pcpu_unit_offsets[cpu];
+	__per_cpu_local_off = (unsigned long)pcpu_local_base - (unsigned long)__per_cpu_start;
 }
 
 static const char *ipi_types[MAX_IPI] __tracepoint_string = {
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index dba050f5b548..e29ebd265087 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -74,6 +74,8 @@
 
 extern void *pcpu_base_addr;
 extern const unsigned long *pcpu_unit_offsets;
+/* percpu local mapping base */
+extern void *pcpu_local_base;
 
 struct pcpu_group_info {
 	int			nr_units;	/* aligned # of units */
diff --git a/mm/percpu.c b/mm/percpu.c
index 5148c5ccf9e3..17d0c2b0de5a 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -145,6 +145,8 @@ static unsigned int pcpu_high_unit_cpu __ro_after_init;
 
 /* the address of the first chunk which starts with the kernel static area */
 void *pcpu_base_addr __ro_after_init;
+/* The address of the first chunk local mapping */
+void *pcpu_local_base __ro_after_init;
 
 static const int *pcpu_unit_map __ro_after_init;		/* cpu -> unit */
 const unsigned long *pcpu_unit_offsets __ro_after_init;	/* cpu -> unit offset */
@@ -3297,6 +3299,7 @@ int __init pcpu_page_first_chunk(size_t reserved_size, pcpu_fc_cpu_to_node_fn_t
 		ai->reserved_size, ai->dyn_size);
 
 	pcpu_setup_first_chunk(ai, vm.addr, pcpu_vm.addr);
+	pcpu_local_base = pcpu_vm.addr;
 	goto out_free_ar;
 
 enomem:
-- 
2.47.0


