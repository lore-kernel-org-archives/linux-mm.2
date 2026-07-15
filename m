Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52A70C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 18:05:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 633496B008C; Wed, 15 Jul 2026 14:05:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 596106B0092; Wed, 15 Jul 2026 14:05:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 484E16B0093; Wed, 15 Jul 2026 14:05:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0927B6B008C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:05:46 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 772291C013A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:05:46 +0000 (UTC)
X-FDA: 84991789092.25.0CC6017
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11022141.outbound.protection.outlook.com [52.101.43.141])
	by imf13.hostedemail.com (Postfix) with ESMTP id A527720008
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:05:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=vGEY361Q;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.43.141 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784138743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e2t0BTW0L0KAqYei4Xv/1VSaBkyJwgz1/HwudPiGu9Y=;
	b=sw3tpnn5zExGnZ3g6Qxzoxgn82dNdV35TAFJdnx3UsJRQktVg0TTJSZC9Ur4m6Qxd/cbmg
	BlVJs1Iwvi5ZHsSzYuwsP7M/9t7pfmgbaDjjbwUkgN6fHG/7ZEZRW45U/qvrFaHaAJh/gT
	mbEJbusIEKrJR3kVwHkU/pl6lWHO1og=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=vGEY361Q;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.43.141 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784138743;
	b=5BXzegzq9tH3DOP1SU9CDnbTaGawlFjH77CoLqcPOsLnh2WroUazBnMHe1NCYkEL/1WkoK
	KS0siexMOMyRGnTZf+D0HRAxcmqxBkVsSli9Y9uQdQmIUc6jIhUei3qE5TKZ2RP0Wv1L/M
	WG4XrD4TR3J2zA/kLSjAY69mKbHCmDY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eHnASWd8vyBC8va4caUr6TiSAo+5XhvERLlvBrjlJVz+l66uh8CSW2AJSrREIy0/24LJU6aHxws458zLMFm5p6yxpbQxPvqxw5KJkLWqmGlBw83+fSrybbjXBuQ1i32Dr6bMqVNzdflqdDLf6xiLI+T16BOybwIzZCxSlO6E/jrDBMIK+wWJZ3IzzlYWPGz7VdOjWAEcPpJaN5+dEOhXrjOg20/FwBt4tFQ84FTVFVWH/55KNRzzDVDlWlEhbSLjYpS1IitOVYgEvvsx541zdLELs5D2mZAT/xV+7c0t2e/Pidu4OE6ynxP9zjmx9ex0fCHDxGGZaYUXkJhbNxSVMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e2t0BTW0L0KAqYei4Xv/1VSaBkyJwgz1/HwudPiGu9Y=;
 b=UazEXMSm+Vj8e7bgTyjtpQX1nCa19+AsVoCLWZbLVDINvDVPtTD4DJV5FJOliQ/fqu67OESeV0LNgEmtcwibQtw1UthRMJ5yYpN4xqdaJrEN62B2By9FDLb93oP+JCGapovy2Djl6CPQYnM7zmUrzOTN4VSewERpyhbODQK53eSZQy/jvkd9+ODS+H2j9YgOUesq8pH23uZ9VqsYcB8GV3TftUp5TH9P9+aqe5moLsUob4u+DKtVku5ZNL65nqWWh0faEdbZ8PXX3tMuaghwK6Q3tfM0waXR/cmoXB8F4H5PNIHFObJ/Tx/rJa+zXHTEzOXT140IFzlyb5K/wExpfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e2t0BTW0L0KAqYei4Xv/1VSaBkyJwgz1/HwudPiGu9Y=;
 b=vGEY361Q8Ha5nj1T+MJfsCVXK1y1S59gyrDxOuN/rEBIRfDt3rs4sm9ZWD9YXaKGMqYsTbadoZNyZiA6oQaVttEAskCNAMYVBmfbACdZNILjVUjgq1Y/FD2cAQADxrWzgR1wShjHiDoptFTPz8oU1/2aXU9I0uW7eFRxf/HRZuA=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 SJ0PR01MB6207.prod.exchangelabs.com (2603:10b6:a03:29d::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.12; Wed, 15 Jul 2026 18:05:34 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0%3]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 18:05:34 +0000
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
Subject: [PATCH 02/16] arm64: kconfig: make percpu related configs not depend on NUMA
Date: Wed, 15 Jul 2026 11:04:04 -0700
Message-ID: <20260715180455.515692-3-yang@os.amperecomputing.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260715180455.515692-1-yang@os.amperecomputing.com>
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CYZPR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:930:89::18) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|SJ0PR01MB6207:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fb3fa7a-2e40-498c-3e96-08dee29baaaa
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|1800799024|366016|56012099006|11063799006|55112099003|18002099003|22082099003|10067099003|921020;
X-Microsoft-Antispam-Message-Info:
	bvw3/TQKLJ9gglh9ntO/D9ggaUYgfbwBQ7ejbyCdpdL5G7TFH/JQmNsZ5CwVi1dG15dPCUcrEGbAgKUv0iNEQ7ay+ZUfeOj/eMJyjR+RavckxdpTLb31Hn1Bi2G7myt/tF1lGGS8Nd5SEYkZBFuxepIOWWbPrFPmAd7MTwbw897B0eXLMEoWBi8VjxoQ9i3Ar8+QTk72uyC40wZ2MikV1B7RwsIBGib/rP3NLGsvs0owzJuEz6vt87b/vCntvzGNvHmRf17nm5HftNQsBnXlkuEuTkT3Hm4o7o1LAypmMbi2v5Xn1lWdTxK0/o0yYw0xYh74S3rgcnpdK4NWmlG+h+JbHSyii1FbTl2AcKeCa9MKfkKUJjyT8iqTRviRFkpyp0W4GKY1mF7emoeE2+vDJ3adfmZNlp7N+t2aDrDEtIf/VbOS2T8+sqs9hVB0HojVHhlDmltD39zBK6htAuqyQ0StJ6QenbFg9JlPeWCq9z9o0DgIPI5ZpO1oXF0I42tBxWfSZvHLObAKtYdS2xgQ3hZD7zv0CAXXZLdg0uHg2f8NzbopPaFhtw/HXhGlz1muXzVBxqjV0dvYWvL3IpHIt2axvZVx+eHkUqEQRWbVeZfy2wHSrbJV2mZIwX6XLoExKz76fH7x7hR/5wwArWY+xHsTJMC6KuY2nRtTwVxeqOUPYY+3QFNWS040AIc9lvma4VaracfLrjXMbn2uwsPZ/A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(1800799024)(366016)(56012099006)(11063799006)(55112099003)(18002099003)(22082099003)(10067099003)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8sIQaHKMbPBNFzkR7JW9TdMpiyEs1UEylBb9Aza00mlUJSkM6WvuO7g42jam?=
 =?us-ascii?Q?Q9iR3vD5c5mPitO/eRSX6UAY7N8EwcVjdC/m6ira/SSFxL+jU1r3I7vzNIIC?=
 =?us-ascii?Q?KDCbX5NIa4v8XXz6XQxSOlakkXnKpvDBLDWVNRbjEIyHGwroiGe2pG+3A1iX?=
 =?us-ascii?Q?Hfunv/tRvgFrIF/PfEV0gX5DryQbRp9194RJNxnZ/byJUEUYVFqnpDAkoAKd?=
 =?us-ascii?Q?Z4VuUPGvd5DK0vS/wCP2qejZ92lhMZuIay+xt0GzZbtV2upt9cnMEXsmyJ10?=
 =?us-ascii?Q?xb/rfRv5UFzBp3dhdeV1tZMz+hqGKgAddSpPjXtPoMFAFP2YJ+MGFFTTJNiw?=
 =?us-ascii?Q?FzLIThYrCM4U+0CIpnNHzMlMZwpuztpLeSahuW9gK9EKOlA2v2f+hEl+CqXR?=
 =?us-ascii?Q?w/YcgpvUdk/Ddjqlr9hdgiSsfZi1eeNHC0R6u8mxNvJkBzfs5v3YaiwgW8KU?=
 =?us-ascii?Q?kexuET8bx4tAACTeuaNyGIxUJleN0qp5yFyOu+zgsxxERvKGd8CdykFdz2+8?=
 =?us-ascii?Q?OimmMd/VZadOyyIfESLx4d+8y1SixsB/dWNZWGysPEayhgR/R68nll2Ac4S/?=
 =?us-ascii?Q?Cs2VHLFLljO2ZaqYSVGNNCDS1cHnqG4F0v7QNx90uBMCdsCILAaDjcL2bbZR?=
 =?us-ascii?Q?XqWWq/vg9LPKJXOlJMECnnMoykZNVYFGikwVkyHUt5FQA5Px766OzBST6JZ2?=
 =?us-ascii?Q?Rr5z5h7jP/G2P8MC2zPiqQAKFCO4BNYsdtKEB02lNrdhyzMv9sAFFkVk5Mtp?=
 =?us-ascii?Q?CaqM91FwrG+KE2wCdQ+fXIQa7SS9vDWufIYazsDclT71tCcumb+iASLq0j4N?=
 =?us-ascii?Q?MVCyZpabJqE3DhGGEdC0tUBBDF0x21R27LCmEuS7Bs38aIy1zh74u7Y5tP4t?=
 =?us-ascii?Q?pMR07I4XW0231qfG1FCwN2lS1gggIhJ7hvU8uUB0XYxZoz8gX6NncWbjqT5Q?=
 =?us-ascii?Q?GPh6rBIzeBiURr6qXT66tnRiY2/Ugk/U4DPKFZydurQGiRpCYRJeaaHEt1cc?=
 =?us-ascii?Q?VMBvoxw1sq9ygCYqo7sm6YAfCm1JK1mVUyw8AmG0GucfOjkyxNkT1VnUNuNJ?=
 =?us-ascii?Q?IiWCuCSjK2tRRw0eShDFqx10koCj5eApi5tSw/m6BQvbm89BS8tKojjD5UPW?=
 =?us-ascii?Q?xjgr+uP78Y+vHyqNQKybDw5sAnQSh5ZaKvNC5GB0lMe3PDyyQ/aso+ku0qUw?=
 =?us-ascii?Q?XhyY8HDwwzQ/vg+UgzGE2Ioe8alfvspc2kFf7sIX9l+zDnOeRZGmj0pYSLBi?=
 =?us-ascii?Q?67xQxxwbUJQ8SgmcoVYBMokIOuqddA0D6l9NkBtQBPLPzxEPLvemO4O1PiXe?=
 =?us-ascii?Q?li+E/DA6hp4YHaUg4JDA131nzirTO1YLObpETzq7N5TlacR4lBKzrMoZDo7O?=
 =?us-ascii?Q?HjJS9DtfrdH0ALHgduog3B0MYnhx66jSmfiUqEctLHSD11UYoSR/7km4mwmt?=
 =?us-ascii?Q?2HREAr8htkDotTIRPsGxBvVTTZXF48SVaIzUiNJ3dqE31w0uzcMIGr4qhFDq?=
 =?us-ascii?Q?hKHNprJsUSklXvOt1Xak5a/9ua4of5D+Hap6IQnfvyquQIpQbi4pOb7xbpOE?=
 =?us-ascii?Q?13k+Cr1EMuB2i06bXJPGewVh6HdCtq89sPgXFGhl7qnqVXRoeDLl7uo3DR+u?=
 =?us-ascii?Q?eqgjuARFZul+ibNxEBtmjAGbTJDU1TEdpsA1X7kBDqSJgKiu66JxLe1adju4?=
 =?us-ascii?Q?+zBLQkTmz6D7WS0ttnw9Oc2Wvd1ILqhdkht3jzDGstzo7Mq4H624UwZ4Q36J?=
 =?us-ascii?Q?yzeSluiTCHv/fy+zHEqCSjFImlziLz8=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fb3fa7a-2e40-498c-3e96-08dee29baaaa
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 18:05:34.5653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 33VfcPOiSP9nmCRigjHinJoK+xKOcPHTTZBZls7rqS794WA/RKCvsz6/SBvre48/Uqn6E/5emdDe9pAR0NnhYDJJDgjUN/icj1xw448xJH4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR01MB6207
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A527720008
X-Stat-Signature: q6e76gq6r3q5tcoqg7o1iqnwt3tns66h
X-HE-Tag: 1784138743-671960
X-HE-Meta: U2FsdGVkX1+fKyRxgHzp/Rz5Vf7rOjRo4APqw8OLBXWjwArQ17ixVvYqIaS+Rdb6Mdz+7rLxHa7GnnNWIcgQijpLt6COHc9fjPj/12fnRq0SDprxJiJ+Vk36iGnok+lN4tInX/VLOYH+TvIhgX+9mAX5DF91mCkOXOZrXEir6HIK5qZB1XOBCpK+hSh8k/+3IZsiMNGnTroWpZ0V22XrLlpXD8MUeoYdFO87m0dqGFLu8YWZDT9htuPcPOKKfmHyviS4JN07pmR2VKxmrMTZ3YAK682AcAOPCj0RN5qpMNlfZ5crUfD1yfemR8oWyzeLdV4qRpq2IkrbZEN74LpYeMytiRaaRn7Za58rkaRwEtcf91d8+IvHbJH/YzhDutz5OWdLEEyLFVwo0xGwFDscYLbI9devBgGhfgcLFRr2t3ZzEIKphT5/+siwecs9VGoV5xyLjZ8awRYJ5HmHzH7+gD/Gex//amLBjaVcnWUD9yYk2VWZgdNjSorK/kGmgj2tRzscC/HYLyg8x2jnRPRMB8jobNkCkmxixJMCZurlHB+7Y07rL4QkhUHj4t+m8g5DL8U6j+3GoN5wYDycAqiAN99upAJ7LJDQoV3ycH/8k9eVzYteOxEEOYRO/9UgxbbJ3jKXcNqO6bPimauv5J1QP+YIIUe7lqvx/6HgVAM2TzdofvVLrMyKhoRuvb1Kzj9Uv423kWW6jwLtde70wKbV101irBnQuRaywk4hF/vVf4vXCBpD6qJ9L/E8MWD6wz8Tpm0XKIEsUm8/A8A/L8t0ASaejmKnHpPjs+upRJsnXpTPA6AawGJOgt+T7CmG02+vhbdXbZC7wwtf9z/anaurxXjP/f329JMLuyrkXjGmo77jTw8Wu0AqpUHWysZ8ZE6Hi0LDGiItCJ8dY1s9tDWDoBj2lMWgHoko1Dz+bEib0EntI+O+uZWJQDWMBz6gHDni6Daaj13vrjqzkDGknY5
 q+u8mWlu
 P70Efr6l1ClvHOs8Iy3XO6JlQUMZ3cvFboTW6h1MrmKCDh+bT4++ZKBLBep3TWyy+R937MrGq55V77/7IJP19B5GTga5TxJQJkzxKHFQ+nBmh/sweATvFqj9RIZpXvcHJYLCJIfepJZj5DGEUUKHMNsTcaI9uH6lV3VcFY+e6oliSWg1TZbWpgnlU2N6v1/cKpNFJ3oXo3wbKwoaNPNJuHzg/3/4n9M4vqZ6fU0fsmGjcUgBMm5QZZTr9F9Q5VR48i3G63NMLsiRyXl7jZna1OEhCog5vMtnlEQUNk4mY+lQgj0WjR344ccCSJUFwD6MWfLYm/hFTQkpHQ/Bov+jp2RMGFlD/Zhy2jWwgzwbkghZYf7YJA6f/VPV1ns+JlLGj2NfNuvLCy7c8Y8/XluNLhtstnUzPlrPs2U7wlXLKguhOi04b3en0X+NewQce7cS5ONuS413D+WUOMkgHT+kNavETSZMDAwCDjLeb6aluzmFjg/WwXmODmmruv9de0HCUxz11
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The percpu set up code has been moved out of arch_numa.c, so it is
unnecessary to have percpu related kernel configs depend on NUMA.

Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
---
 arch/arm64/Kconfig      |  6 +++---
 arch/arm64/kernel/smp.c | 10 ++++++----
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b3afe0688919..2e1bd79a579c 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -224,6 +224,7 @@ config ARM64
 	select MMU_GATHER_RCU_TABLE_FREE
 	select HAVE_RSEQ
 	select HAVE_RUST if RUSTC_SUPPORTS_ARM64
+	select HAVE_SETUP_PER_CPU_AREA
 	select HAVE_STACKPROTECTOR
 	select HAVE_STATIC_CALL if CFI
 	select HAVE_SYSCALL_TRACEPOINTS
@@ -239,6 +240,8 @@ config ARM64
 	select LOCK_MM_AND_FIND_VMA
 	select MODULES_USE_ELF_RELA
 	select NEED_DMA_MAP_STATE
+	select NEED_PER_CPU_EMBED_FIRST_CHUNK
+	select NEED_PER_CPU_PAGE_FIRST_CHUNK
 	select NEED_SG_DMA_LENGTH
 	select OF
 	select OF_EARLY_FLATTREE
@@ -1581,9 +1584,6 @@ config NUMA
 	bool "NUMA Memory Allocation and Scheduler Support"
 	select GENERIC_ARCH_NUMA
 	select OF_NUMA
-	select HAVE_SETUP_PER_CPU_AREA
-	select NEED_PER_CPU_EMBED_FIRST_CHUNK
-	select NEED_PER_CPU_PAGE_FIRST_CHUNK
 	select USE_PERCPU_NUMA_NODE_ID
 	help
 	  Enable NUMA (Non-Uniform Memory Access) support.
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 0dab4e9c97e4..28ff889658d3 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -819,16 +819,18 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 	}
 }
 
-#ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
+#ifdef CONFIG_NUMA
 extern int cpu_to_node_map[NR_CPUS];
 
-unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
-EXPORT_SYMBOL(__per_cpu_offset);
-
 int early_cpu_to_node(int cpu)
 {
 	return cpu_to_node_map[cpu];
 }
+#endif
+
+#ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
+unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
+EXPORT_SYMBOL(__per_cpu_offset);
 
 static int __init pcpu_cpu_distance(unsigned int from, unsigned int to)
 {
-- 
2.47.0


