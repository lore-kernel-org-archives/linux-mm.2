Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC451CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 13:53:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EF8E8E0021; Fri,  3 Oct 2025 09:53:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C77A8E001C; Fri,  3 Oct 2025 09:53:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DD1C8E0021; Fri,  3 Oct 2025 09:53:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2BFDC8E001C
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 09:53:52 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E67E6BB716
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:53:51 +0000 (UTC)
X-FDA: 83956946262.23.B8C362A
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012041.outbound.protection.outlook.com [52.101.48.41])
	by imf17.hostedemail.com (Postfix) with ESMTP id ED98B4000A
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:53:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pW7oUVoD;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.41 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759499629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=37Fxp31Qg4Xw7xrBy/pYbBqd9F0HUtp6PN+s5xgymEg=;
	b=C2Zms0O3Eytv0o1v9ZwutpCumgr6pJkJwxNMufEUkPpDaHByFmlszfJXRToi6zX9iRoFs1
	rBb7VY5OtftXtzUjCcRsAYwszA0PsH9ofcIx1G8ICRwZwceKOZO3V/Y6TFiB9XD+2U60hX
	sqEhQUs8yhKFDr5mfR+KlJgkj5MSe0s=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759499629; a=rsa-sha256;
	cv=pass;
	b=rKES4lCM5b9jYXgT7+qnrdWost50jioT9066cGQjbedpnpKRkDd919G3oUzXsELxmALc49
	oo0h4z8n2UTiauVpVGUYiLGB+lsyaichBIPE0cE02MQ4BAwrAM+TcW3/4nRKhO2d5itr6O
	/MnUp1GewtIlIm9vwpMqs/inNM0shCw=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pW7oUVoD;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.41 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ekk2OTs1lRvp0e/e5w9Noytdi393SGAf0bYh3Wk3h0tfLWo1wczSm4fjbp1bJ2vJP/2ri4F2vRvwDqJdy+Kvmp2OhBEqj/bVN0tsdf49IvbYpKW7xSHcGKjOXAEwn5JB8m3Vn+lLx1ZZAvrwPr+se4X06wKo8TjZWciubugCEY9gfJHBkBrCXdiLKBg7UJhxgPBZrHdM/T/VmuZplVitmrloucmSivcvalYTZR/LkbLSvCyewNfvKrJGjUMV9RXMSrOJFxqwHR/bFtUt4o99GfbI7hDN8EfrPjGvbI/XiV9XffaR/c1VShcJh+nirawyZHbRYDOMfZ5QIWFLXabZqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=37Fxp31Qg4Xw7xrBy/pYbBqd9F0HUtp6PN+s5xgymEg=;
 b=t71nmb04sBTCCP7PVsS4yCNChLlhdReAmHNPrXXa8r+sz1oDYK/WIMdyKInEZrd7vSsX5/OqwmdiZrqtd3WyVcmPkzeNNRskqjrqASPA9mN1B80oTj/R8hrsa35ILA8ou00HKZ/hDyVg8dUY8cIckuiuli+kZDItFczahaFlJjKXct8W4+R1AFx2AjwvICipH5c3U7QcDFc7dxCfSIU6RlL8AIMu5KJ3QFYex+0Yo0/7g8jplf4n8AgD7UBl45aw/RRS8zXEGhic2oyqS0UFOsbWzKMpZFfpon4aCfDSkjb+bRqYisyt996V2N03XhDK3VecEzyQTsIfzwYV3cTvdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=37Fxp31Qg4Xw7xrBy/pYbBqd9F0HUtp6PN+s5xgymEg=;
 b=pW7oUVoDzLDzvzIT/6ezLibjCOknt1dYw9c6EH3kz8I6jV/68l2XZ95vfbUwvIHdAOZ6QDOoOBhnLaJFIia7e1DuArEjf5n+CFyat+cq3bIe5VfxP/gmqkvLDTIp9zL0BTMfcGPRJRKEsKSE3nONek1hK55IRE2H8+Z6WykAt2GiGSjGLiEobQG2qT37CcffckF42k1VSCCcCb0LNaGzyp2xaoiPHrd+wkM9OMQz4BnvjI9d17IKBVQlr80QTPkU8SKaonQ+EGTZXOHqade/QUbybk0qy1AEkLw7dq9vExuvLgSPTw/tT3nojtHaNhxYn6fNonqlAaUElRoB4BT1BA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BN5PR12MB9512.namprd12.prod.outlook.com (2603:10b6:408:2ab::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.16; Fri, 3 Oct
 2025 13:53:40 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9160.017; Fri, 3 Oct 2025
 13:53:38 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, wangkefeng.wang@huawei.com, linux-mm@kvack.org,
 stable@vger.kernel.org
Subject: Re: [Patch v2] mm/huge_memory: add pmd folio to ds_queue in
 do_huge_zero_wp_pmd()
Date: Fri, 03 Oct 2025 09:53:36 -0400
X-Mailer: MailMate (2.0r6283)
Message-ID: <FEFD7299-2715-4C0D-A2D1-C745FFEEA965@nvidia.com>
In-Reply-To: <20251002013825.20448-1-richard.weiyang@gmail.com>
References: <20251002013825.20448-1-richard.weiyang@gmail.com>
Content-Type: text/plain
X-ClientProxiedBy: BLAP220CA0026.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::31) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BN5PR12MB9512:EE_
X-MS-Office365-Filtering-Correlation-Id: 919a7cd0-b3fa-4fdd-b9f6-08de0284410a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?E7hX76FiaDqZaBNUJ6ZL1e15s34hTNB2htIBHRF71R2gp4Rx8nLlMUTCl+Cv?=
 =?us-ascii?Q?waaCAGC93btUpjLsFAGtt1kU4d3C92mZC7R/Vq/RMx7PXhx3uOaphlEVlg4k?=
 =?us-ascii?Q?kN1WL7+AAr4Htu5i+XTyeVK+FVS7v4fb9wwAcuTVoZNDSbptD6tgFAj7nlAc?=
 =?us-ascii?Q?Me4xXgQysk5qax2OQc+YkLKRJVEWfXRo4UQjJOrSl+3J5aj3txNTyvYHcXyY?=
 =?us-ascii?Q?WNtY4xWnZpviEvGqBxR4vIhwConjzXOxaYB837BHhFAKfgwH42S5edJedzRd?=
 =?us-ascii?Q?RSVnLOuAUXFdS2WftbtDwPHM89KLk6x3TLQviW7FS4cGi5n1nt2h84woyC9f?=
 =?us-ascii?Q?hRa2z5qgCXPRUPgGEPeIKJyu0GLcntycXwekYP7Z59B4S34MiR0Npaa5QflH?=
 =?us-ascii?Q?8o9kV2FBsF06SD1vizfb5Fri3j2mV/Ye7ldltLvL5xJ1vlbCSDS77gI73pzu?=
 =?us-ascii?Q?Klfn0XYmUlfipRuM+/sZgekLxbdkILNNAmEGeGqhf5nIVJK7n0o61NaBqn5F?=
 =?us-ascii?Q?xh0RIXEiD5Vg9qYptY/eWxPgyVGHIo5mKZZycHiOWaYNdtviSfOUxIXBtCQE?=
 =?us-ascii?Q?66WsoTo/pN2oLsNyK6PCp1n9rh6H+kdYD6q4cegk5aSLXpdfCcrTkGg4HNFc?=
 =?us-ascii?Q?WMOSfrM/wfhFGoV/Iabx5MbRIfxrJz4RYBOzPjnCA7o1ZRBR0cUXrwMZwXBz?=
 =?us-ascii?Q?y7SWysdFhmQU/l1nJkG/r5LUsDxL9X/Hv9NuoTeNOE9CP+hq3SzxcY/SI2Rt?=
 =?us-ascii?Q?d8gmte82lGLe7jSXC/RyX4ebTy26KenLt90DpotkVbFs24NjpwZP28EDoQQp?=
 =?us-ascii?Q?C0l/u406W8OoskV4FRDHhbrwcRrQ3RyfJ8DnX4knQFL9lIwjDub3dIljmk3s?=
 =?us-ascii?Q?eupr/IWiSvVx2rF1ICUYVJEorPFINM+w8Twf/+JGUDwPHZ0yQHBJCCJkPpxP?=
 =?us-ascii?Q?Cdds2iNORK6Aj6+p45rx2HamKatapfKWbsL+gJl0TB/5ey/CoE86enBiJoKF?=
 =?us-ascii?Q?L3oq/MUdvcolMN3QvY+FaZamI5M2VbwwaetrRfZ3kyRyrLOTlSDiDlvpU+az?=
 =?us-ascii?Q?T7iPA5UzqeXb+qZGyqgoQ5xCyjGaYj9djNldT/VW56hoR19eKpy6nAkNHgG1?=
 =?us-ascii?Q?LpJ/r8HzrlTfGyhw+npXSCfPr3po7zfQegh1KXlP2uUT+yp3dwSVxXpqC7m1?=
 =?us-ascii?Q?VhtXNJNc4WuftQ9z7WVhmAKOVTI/BWBWM8ORVlFQj/chrAOc2sOL6v0t37ea?=
 =?us-ascii?Q?MHcOEKejWE3g7i+l83j/iI+Z5D2kBfKPqzF4+IZKznB16OGnWbo3f1OjHMFY?=
 =?us-ascii?Q?LEYdkYRuj1dZdfzD0r7zALDbCWIQLfl6UrLvrByknvwg1RCYruNjHNbYdcmz?=
 =?us-ascii?Q?gNI0IRw40vPBNRtnNcujfvaSQTnGWNA/nOb/q7QiHqXMGaDvDv+2xCL6dIit?=
 =?us-ascii?Q?1MPjV1Mg5QVuwXjCQ0TuQ1Bxt13BROXL?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TeHE18NyAkcvyQosT7ok3E0pyDGsfanalC55yj1Q/IEnOoeZ3XT88sikPx5g?=
 =?us-ascii?Q?fc5wc7F11nh90v3olgWl1swtrgGE/gtVFEDfTfR3BACvfQlWMOWNtGHDemD7?=
 =?us-ascii?Q?rodlg6ionhtLPAlH5R2loBsPcARoMGFHCKzBvUYhHaQKoHbnG3fF0YXjlDM6?=
 =?us-ascii?Q?jUJdAx6MQxfK5rtT2TTgKjGPM5mDJdpcusYvqKzpSiUlPQdaA+6xR8eol9Ck?=
 =?us-ascii?Q?PdGz/KodnpdQ7OeJ/Ki+rmgNdV3BrumpqFsdi3PM733qKiFl/72jRV7bFK1s?=
 =?us-ascii?Q?4BoKmuMHPxzZCLQalxBFhlv1/4EHeP0EP8RblG7Icwz/ORht82wUAZISzvmt?=
 =?us-ascii?Q?gCkVYdU/+OQcGCxlT4ryUd4NSTsQ8nMOZrrM39eb9sIAp7X0sUXWjCeRsFN3?=
 =?us-ascii?Q?ucdW2d/eILsJWSDbJMkFUSsr837wuVCTKa4UxNCAktUCQmLlwtx2HzSIm/UG?=
 =?us-ascii?Q?qzgyUR4FJaVe8vDmdYBeTqFrVUwqMnB5RRu9t3QZYdDbZXfvOk4KsUMBr9CZ?=
 =?us-ascii?Q?9pu3ppspwoLZppQsT+2sqwxf4SKHudTG/kV05S54mspQGdC8wQBGTMNtAyr8?=
 =?us-ascii?Q?v5kSZxZ+XlIIAmNlHsueKm3gzhmwmeGTxSuuufu4xeD/Bzd9wA9fRNvhnn9N?=
 =?us-ascii?Q?Qjrjbm5To4awVC41zTaT8rQQZiWAH26wyq/95UwqS04yPBT23KMads9aFi6s?=
 =?us-ascii?Q?K8CYtzmofpFG32s8nQPhjO+VJoJAZIHACQK4IPXvQq4ZwvJzneFblC7VcjSe?=
 =?us-ascii?Q?PP/0Z/x+sUstP/RlaguICx1RYbGcF2ChU5JmnMLAyQuEGDe1wclM8FRnicon?=
 =?us-ascii?Q?KnB0WB8sN72Vpa/57b7/u8AJiU5/LjjCs132kkXw77MXD2/VTUHuQktBRaZ1?=
 =?us-ascii?Q?9kTVgm+PtusMaTJtAcvd+tRyRV8Ot9Bjz5pulRXMpX0vesxEBC1bwekEZ8Og?=
 =?us-ascii?Q?FgxBJliuiSva5yiGkKLaXiSp2gpIvXSyPxu9duKOuvEV2/56uwBFeJycTFYV?=
 =?us-ascii?Q?PyoFGVDJhWcVzDHZtnzWoKVYGYZLhagqnpylifKDrC//NYZacU4JlWG5k3Hm?=
 =?us-ascii?Q?OBwL489I8sfwly77b63Oaz7zo3+mFjcxKY8ZtItQHPE2LJgeWE3UXk9h6I61?=
 =?us-ascii?Q?Zeja0pwP24VE5TjBRwONT22mkLNcjNqisguatPJkQrGtsetIaWUiBgx7/kMy?=
 =?us-ascii?Q?PEsl0VCXwj2rBjDvXWrSiXGAuRzAS0XI8APXIu5T4YG0SWxWU5snhXE0h/FH?=
 =?us-ascii?Q?goKfpnFWa42LObZMFnuuHpvy/r/oN9XFG0e+Gyi4aMWUfLrj36f2PxnA284s?=
 =?us-ascii?Q?GVAiwjxLg7H6sEQSXBzODqeGbazyUxQJryg+7UF5Pd5hClm5H91IE0uPQ3nB?=
 =?us-ascii?Q?etmre84qAKMiwK9VPbdIA4kZdjqpEvWWCM2UGCHBBC7JGMuRSS52GB1yYZpG?=
 =?us-ascii?Q?JnvGB1KaBQLEGcU7ljSuiNhw8rgEOI0MP5KhWCA4OB077aRa6ueOeQYqXabw?=
 =?us-ascii?Q?GUEtsDRayLd+fWUz2HF8P9mBtB+z7uVNfZwCTXyqcHEvFqDf5nBOJ7P4Fm6o?=
 =?us-ascii?Q?dGCgbKDYfQuFEL2IxPoRmqd3Nc6k6cT2X2u5ESzx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 919a7cd0-b3fa-4fdd-b9f6-08de0284410a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2025 13:53:38.5335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Msa5FVnlstFJsFTW1hOW2ag4Y1m6SQDKqhe0192nfyx1LT1yZ2JqtVASYmyQvec
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR12MB9512
X-Stat-Signature: ngjzytqpxuhdnspdj4uq4zmzr9dbhx6c
X-Rspamd-Queue-Id: ED98B4000A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759499628-783338
X-HE-Meta: U2FsdGVkX1/SyK89Ha7WpDXWdc3kfQCZHTF2Ku8bVejqLyeUPa3N14XPXHkzVTkpU84NDE2zgDsDr9oAZbC8B79XBg8KUN2KrzQ9QMlQ6CPSNun5WEQeZvg5BUXvfgy77TfL7Udk6ofz5fnoHCxFFRgAgR30PszEydPPd9HdlIUheC7D9D0/NQp/g2HuAaK9nbKwvOm3Rx3fa69Wq98t1ftpl+kJlEXZ9aRuCydB2sVUqE05Upuq9CSKo8EPE1JzLHmJVAAUWLUVSbd88gJREFnNhHJvmrQtkf4IfBhlpyEBu8vZ3H6XDOExJE7o8j6B6VRUVf+ABv/+TkXJ2ZeY+0nfUirWwkBCpa0JRTStHVf0RJ2QbCuJLotj1Ai1ZJTtzkoGI4hsxA1s++t43nkEobNg+bw5+Ag/F0Cpn0dCKIZqKC9FqfYxcTGBqZg3ZVpotC4+soDi1ZHBGvA3znQDIg6uuRkj6L58f6OfkJfMXK5kFXrnHP3p+T4xvGfT7nNUKn+ajF46n64sw/K4T1wwGVhfWE8pl8yKL3uSmNEdL7NxLhC5hqi7Meg08Y/4GAwykLa7UNaIOz6RMzUsuroNaO0rCI9RtgIqiC8ftFL0wgDsIJChWKbbTou4GHb0vmQBpgTIbEmwU5MNEN5uiXBdkyzaIn0oG4Z7hTsdCg1VpVPWFGmIZ8jGxW7MMN7bv9//pr+n6RvXh/IkFiVWHGq2WLRR+khHv9wtzXXSqdcpS2O+F/3g7gicRqWT0ru+GcTMgBegA6YpFso5SwdrHNaTvdpOkK8HGsslY2yaAO6ZzqXhyGkvZmUfXg7SE1mpT0cMFpFWQhagA90WqiBrPzckMs3BSMPqNcJCLtD6beos9URvqBY0oPUcTu9oU30gyLIYsmic4k0jY0d5VV8PjO2UD5vEzYjeRfnMmRDpu0oKaZhhIpUVkoGbS/isXDniXn8BSe5LTlxsEtEEjXJ//Wz
 Sz3oLgr6
 hqg0Aa/gWArEw34LBmQl2sZAMQYU76iYNLSHUH8HuDs/fMen65MnPttZTZ6wM3NxdBWPeaVbuQtzvXRn8ZQq3Xh5n8m+OzFlBxCkLzdYuCSGpE2Wtg/WpcjbUwrQ4ZJ8DFhtmpp0+mX/9s9HjBbbK8x8gP3vIaQzISTFsUhg0l1AOY0nyNw66oyWkbVzYQdATI/NUretMwZJEw+nmb/BcOHcc8LMVyCLg7J2NcYjoOwEjehTtfWvxyaAUvHpLPEpG949/NxA/LJ88a6BBGeTotr6PYCLUm8d/VZHStPX678zlXqscuAwZJ5dIadh44RxrLpRao4YJ0aH+NSS5TqsRVKIGlFPOOU+iahh5ZpCanOvQlV3C4bVXloH2r/XFyOEIhfKx0LTdJ1tFC4oIZSZbiPi/NtIi0Ep9q+vhaipLiEuxRMxuVsxd/1BHNrewQx1U4MxHHeKHs04zMKX/kLbzHloemkJGQlIVlB80Hn/+6SzpXYAR+57SKsmxmWLDQM3ganEBvujex3yUCLZkUNEIBpOoJp15l8f5CRmwaTSwsamNR1QmKFGCTMbNhQzZ/eNlGMPFrR85EcVZYiN/uKqf80eEVg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1 Oct 2025, at 21:38, Wei Yang wrote:

> We add pmd folio into ds_queue on the first page fault in
> __do_huge_pmd_anonymous_page(), so that we can split it in case of
> memory pressure. This should be the same for a pmd folio during wp
> page fault.
>
> Commit 1ced09e0331f ("mm: allocate THP on hugezeropage wp-fault") miss
> to add it to ds_queue, which means system may not reclaim enough memory
> in case of memory pressure even the pmd folio is under used.
>
> Move deferred_split_folio() into map_anon_folio_pmd() to make the pmd
> folio installation consistent.
>
> Fixes: 1ced09e0331f ("mm: allocate THP on hugezeropage wp-fault")
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: <stable@vger.kernel.org>
>
> ---
> v2:
>   * add fix, cc stable and put description about the flow of current
>     code
>   * move deferred_split_folio() into map_anon_folio_pmd()
> ---
>  mm/huge_memory.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

