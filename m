Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8974CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 20:31:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F02E58E0010; Wed, 22 Oct 2025 16:31:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB2C48E0002; Wed, 22 Oct 2025 16:31:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D53888E0010; Wed, 22 Oct 2025 16:31:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BC3948E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:31:20 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7AE6ABC330
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:31:20 +0000 (UTC)
X-FDA: 84026895120.29.9ED57D0
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013061.outbound.protection.outlook.com [40.93.201.61])
	by imf13.hostedemail.com (Postfix) with ESMTP id AA90520010
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:31:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dsdD7wTh;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761165077; a=rsa-sha256;
	cv=pass;
	b=RM7dju1Vwt6OnLzjwy6zDWVJWK7fHi/4wB72MbenP6Zql137WzL13M4JaSfHx2c0VU5CI8
	1SlUFLV+SC15qlSTw39aB8wz5bbov+Hq4o2MUXWV4LfFPZzUNAFqwvVBQ34QDJlKe9DOJn
	eLp8qhQnljj17jrS+uRqlCe1BZ0SRmc=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dsdD7wTh;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761165077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cLSbDcxoWhtERvefg5aSKshEB6rCmszazK4vPKGkbeY=;
	b=BsKIjB77bt4BZbC3CpGHKXTTZR4Yyc+Kno2c4CZbY4Shjo62TEpO1en+sWB/LolOXtuO98
	HZNm5Mb+QyibmN0ANT+LKfvogXjtsNqelX7+CQHv6W23llFjG1RuWphgUYPYPYorsntd4R
	vdpLufbT0fLkZUyk2pKKGXTRz3Pjh8E=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZEfQIXfHDg+przje8O4mxnRk50togb8V5WbcT5/i8AjhTfJVmrCg4Y2VS0plTMWFWOe6ZQeNKgcTG37/5SnzUKoxtJyuEo/2yjbWlZF9AEMfht9kYc9gN21YqaQtzL6dj6nwqyMyjkSLNjTLqT2pWffTL1rIafa99P78wt6bed/IaHvAZCCnKmtoOy6j2pFLpeZzlUTcIQzNMZgWKW/CmJ1IxzkCWiH1bAb0v+86Z7Z1BgV7S0AN9+MR79rkdk6uiPm02fwmK1dOKYOpf5ZrsR3GJd2C3brHXiNf67jCLNxPHtoJU98Iiq1ucTnwT+kT5CkjTeDyZyNhb8YmmhAkNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cLSbDcxoWhtERvefg5aSKshEB6rCmszazK4vPKGkbeY=;
 b=dxwVcSRgBTFTTf3NqAqsGDJs4Q4Et2qPiGxsj6JLGdzLhSuHIALzWjuha0s1IyFkd3ANB4peCgwr0R0rcRV8VhnXDa+PH5f0m3fMwKsV//YBHMGYn3WuqFmwPHo/SqNHgKrBhMgqwoTQmFPs3anUcGpfKUx5Pj3ntpl1N3E2UKc4/WYDF1IM+BlXGZZI7+Rt2+Y+WkGZPLvXbj6jnylqEoignoMvlhEDUHqlL6PGoHcUk0MkHJMqDSR/qgM1t8aj2wWDVGZH6FesSb/fm9D90WOJa4NM9m3z7sV1dLieGkHp4A6Oi1Oxnz6+R+fBcCd/lZawPMODJbM2xgUmW5pEtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cLSbDcxoWhtERvefg5aSKshEB6rCmszazK4vPKGkbeY=;
 b=dsdD7wTh9K5ElBOK81DDylz8ZJnD/oisZnzDpiqjaglXNuHfVfDak6u5sFsbP7ad8gYPv74VUrH4FP4pVEgVsZ947a3PFT4swZN3ktkXDeYC9Pgjw2fdViIYUX+ZC3nVJWeII8sLIKjnP/jPKzmC31uQ5v/9Qpolihx+G0YTUhLpT6hAsx1nCPyyYsOxrdzqBpj+sPyq99ym8cCdlvBJlOOkUIAycQgNeXBejv8XfRmQ0E9ungNy1XQ2rTsHpBcjsiZG+8PJgiJgNkeV55TwdIE3vpwihHTLPZGZBshIwD8xUy3o7w++2PyuQpiM+quE3vZEyD0ekSUsZ7zBUz1t6A==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA4PR12MB9764.namprd12.prod.outlook.com (2603:10b6:208:5d0::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.12; Wed, 22 Oct 2025 20:31:15 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 20:31:15 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, wang lian <lianux.mm@gmail.com>
Subject: Re: [Patch v3 2/4] mm/huge_memory: update folio stat after successful
 split
Date: Wed, 22 Oct 2025 16:31:13 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <F4C0E254-8A92-46A4-A17E-FB2D6044E27C@nvidia.com>
In-Reply-To: <20251021212142.25766-3-richard.weiyang@gmail.com>
References: <20251021212142.25766-1-richard.weiyang@gmail.com>
 <20251021212142.25766-3-richard.weiyang@gmail.com>
Content-Type: text/plain
X-ClientProxiedBy: BL1P221CA0013.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::11) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA4PR12MB9764:EE_
X-MS-Office365-Filtering-Correlation-Id: 579a38f7-633f-49d4-1f15-08de11a9f299
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?I9+XlaE9FSXy0zAdAitTQir6qUZmeEHyRodG5Ft2d6f+1W6+l5IkVA1tAaBj?=
 =?us-ascii?Q?G157Zn/qKLyA08Jd3ibXOs6CmH/ZiJw9J2CiAsxUOstGrfpxRDuBJmx2ffY7?=
 =?us-ascii?Q?lU8dROxko6S3ieTACZkWm1k5QDtCI815Vy16UHi79i09VHNGaNA3MK2X2IB6?=
 =?us-ascii?Q?7uMzjzgAWg5Mcq75bd6wVTGDyYQTJxx8ockLHhzveucVDu4VTIEsBce4k2bl?=
 =?us-ascii?Q?OJbXndFoiu84XlRUeYeuhoFvdtLfHG/wdT18jERbEyCy6NmlfPaJRU1QErKr?=
 =?us-ascii?Q?SnKkKW01IuTyJSMMcm3uaq8/GyIjXdeHdSkxh6B16P8H+bZBKIJW/0z/50cn?=
 =?us-ascii?Q?oCNxac7guU/U7GvDEvMXEzKHNmxhc5FXvBK7fBIeZLif3CcyBdQvqDrZNZ3D?=
 =?us-ascii?Q?Ww2DmnAHbVGy35RS6juSWEogG9nT6cTFqMD89YmKrMU/ab0Pj2tFAJv1/Mqw?=
 =?us-ascii?Q?UuwLooP+yUMZ7r6ERbsoCZ8s9/4joQTZ1uH7QuC4bXfH92a5V1rXesfE/aQw?=
 =?us-ascii?Q?Jt7D0v2mjIl0DY2OH4R2Tx5GJqp2dkXSYwHvwvu9bbKD+6XVWFgt32RbQ9u8?=
 =?us-ascii?Q?ucMHkja4RIa3EPngRwWAUq1nfmYclNBnirINcnRudx+G2LFBF91cav+ul7M5?=
 =?us-ascii?Q?c8+J+zNPI3Lkdj3tlJHsOgMG6HNTE2PuGGAa7RDKxXQtonobXpNTkVimpbPv?=
 =?us-ascii?Q?1WZYIAiIOcDI1G71+9S3TVJzn/jzc3iOvStsvpyXUU876lJqU2FnF0kVkZwB?=
 =?us-ascii?Q?b5W+4PELsVv/Yedow+OUTaomH/PQm9AWGwJG6b10VIgXwwiM4vIbyddNuQia?=
 =?us-ascii?Q?VTWReXfOL5qUE3KEVCUzyYHUFVws2Pq1/BuwvVP7l/GvcKiRHBIlfk6AbrsJ?=
 =?us-ascii?Q?ihCnaB3GQdvLDDLzN8wfHvdDHAVHmdFjp7+BeQXC9ovLkuTgNW03lpCWDQva?=
 =?us-ascii?Q?1zffmxH0D8jwttql6DP3x1bZXgrWUJ2V////HAOBuUu129BNS8j4M85i1439?=
 =?us-ascii?Q?oYSjwWqalCQ+gn2nBar7t6rXwlQ0nzmu8QyxIjn0MLXP9cQZyaMTZduR2RM4?=
 =?us-ascii?Q?L5J4fg9O+B9bSlR+oSdyA74SqJXoFCQn+6nLcIMZHdfdRVgF0jUV7w5SGelQ?=
 =?us-ascii?Q?i2U0hAvgEEduP/q60Fb+Pzb/ecZ7VgwvuQmI6NGW0AyG41flgYZSAGtT/CRm?=
 =?us-ascii?Q?aRiPImQKVERcICYNfSPWAAb1TAcxcwYsK7JzFJJI0pdPA6BIBsrEReLOu6U7?=
 =?us-ascii?Q?hG5VR5bfao0KZjO9DAC6nSQ6+w4CHnXAF4qKawe2DK4W7jpY8dL777I6giST?=
 =?us-ascii?Q?MWGEynN824R+N8a/14h4H2RuSCA6BDIMmaHdwdVC0qBYMLFrsJr6VLG7O06/?=
 =?us-ascii?Q?W9HfMoSAUjK5qI1uxvBpN7E8F4S7RvTG3aChCrD7tm68npJnQtqlpHxSO+b5?=
 =?us-ascii?Q?i9qRFhgL0a8omuCRqtUmpj+kEB0j7a9e?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HuhVPfx4iBaGKWcNkypqEd2Miqe2MGRxr2NEGGc0uwXpbvul6iWAnorbbj9r?=
 =?us-ascii?Q?vVnHj922u7v0q3JFUmFyNoJKtfq1eeyh+Z5PV3Oa4MNgOjNczVhLA+3EYbgZ?=
 =?us-ascii?Q?L/PPPofj18LF0kyN1ApKCM5NJvLkqODQCL/OwuGac6HaQEfi+CND5OJfW3U+?=
 =?us-ascii?Q?FLMva5SK4kc08QMsafGP56k4Cp3/ld6iQHTy+0KA2x/KhLgWX14BC4xXWFEy?=
 =?us-ascii?Q?RVSE94AUW+etOYIkBCJi/oZ1iuKfaRt95JV7YsUXqa7DHoAwdMXpNkevqLXb?=
 =?us-ascii?Q?jInjbByYpsDyL92HIG6kJPub6ce/PnwJjwdHUiVLeyRdBnZM/Fqh3De4eTsw?=
 =?us-ascii?Q?B3sGTFh9WVIe/pF8KLYDBeaVcHLrRkV9Ob0d+qwhwEAkq+SsSoycOfVXbjvB?=
 =?us-ascii?Q?MJZs/T9sku5Wq3vlprOddCllYOgn/OrVxol3Va5j+wnAh+4amayoxF3w9z+x?=
 =?us-ascii?Q?ZibgqHACblbhr4V0VItfhnF3vyv3aSjBKBB/hGhAuirHL3FVua0zi8N++Z5l?=
 =?us-ascii?Q?e/favKl1IjjsZfCR7ZEaslipx8IgvJuSM7XylTYnkl+RQgkrd50zoAplXGGh?=
 =?us-ascii?Q?h8XzTFwIakOli92mxE/i9TNpoGTenUfCAaFwL5sVhs31nu2VbOdF/jM1nj71?=
 =?us-ascii?Q?aGzLrpRwBu8THZi+vY4dZcR5q5OO5ln+ov8Y/CXTQomyBNBPsRtGpsv71P80?=
 =?us-ascii?Q?1U4vBXGHFuREoM8JW9juPBs3Bb07KTHIIVbGHK+u3BRzeJBuoiNgywSdiLIZ?=
 =?us-ascii?Q?rDqNfvXiziFEO3cuuMuniehdSwBHsEzlfO8SMbIEQgooAa64Ja/exMB+lWuj?=
 =?us-ascii?Q?eAdpeQoGYzqo0QTmhJsRuSF8GRDyabPIW5jJvfVq1Ns0kVWOEUfKKvtHkhAO?=
 =?us-ascii?Q?LpGFfYRQamWNmrSftRP7lX4fgqFlNOcsgBqD+wJ62gv/J/Ylrn/njlUn780t?=
 =?us-ascii?Q?gfMfw6h/uH7cGjDQYtSkUKBbDeCNWmASu6o/kWBNKabMi0fU8eHvDpRQ0/M6?=
 =?us-ascii?Q?HYM7O9dMmebqz7ULcsTh3NE2C5DgRdLL0EzGufxQXIMcg/W6Nj9zfanHR+ct?=
 =?us-ascii?Q?HdAuJ2MCCf9j2BRdyrOIEap4JRX/1m1q6tlSFxJrNvlbR+iplVHWyXSTxshS?=
 =?us-ascii?Q?4xcWmNqH0pkEgisxZuSL3ZljQMNQ6JzPNOd2UpgFbVAIL51x3cy6kKlY+X0V?=
 =?us-ascii?Q?2i8GgYDHhasvVbzQ2TDT4LkIOJM1C9+nRhdfDZZjLU/RxHj7t0MD7RHFmB5S?=
 =?us-ascii?Q?wvYIkNqcuAAQULwYwJktTVraFCGLVo92sJIZfSEPOtYWcggDcLmLtc62XHkE?=
 =?us-ascii?Q?h760wHER++HGmJoTQJEYSPJL3BwFAbxAq8wZ3f9ITgD4vM2G3VnSosJDEBt6?=
 =?us-ascii?Q?BPNuWDNJI3E41KtG5A0tzwlw00Vvh0niKDCH6jt/eRjGdXZysl7ySaWstEXS?=
 =?us-ascii?Q?ayOEnXpshLN55igI+O8Oz3OMe18Xbgr30VjaOljiTaXnfwKLKfyX1oQDtTzq?=
 =?us-ascii?Q?lTIf/Xlp0C/A6o8+JU1yEM20Y2jX61atr4dkU6JDnSjqg2cWhmPMQnT5oYZ7?=
 =?us-ascii?Q?aR3bMHVmwWKxSBYmaXKSqMicP5Tcxkzb8WjXnsBM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 579a38f7-633f-49d4-1f15-08de11a9f299
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 20:31:15.1874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 88a7z13v/w/ZGaQE8ac80vwqQRJYY/19I9XMIRJW6VGrOaq3VFXcaxQd9dlf1lmL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB9764
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AA90520010
X-Stat-Signature: fpptne4fe6q1abits767j6c8m7tc1x3b
X-HE-Tag: 1761165077-746864
X-HE-Meta: U2FsdGVkX19EZ1e6uVs6KLj0TmkbpJzlhlDDmkMLUL0pLX6p7ecxPkYNCJ05H8yTWN0ZWFq5U6yke94jhwpzgYmzZhsSzl7DyM5rr8biCbwva9KJ1csWypEdRlIClvqhz9KWr25JB1wkWdo5wOixUfu7oLpmcSg03OOJc/0VG9ibU19z1ywUzKduWm/xSklgINxtSLVedpE7I3MC5tRUmPjJjbq1Uk/fqOmV1eawwOuBqliyHcRN3VGifgU82r86ULVpmewHC4anQMovtPCWLO3OKbql4kE033YQfN7Y8oU2L8itXKbVvGuW1zyEVWff098wr3l/+RCEY2Mz7GBi7SV6cV+bl9Vctkkp+gyNS7XXOMBt+X81iczwckdr7VyR5hNyTbZRmqNwKb3OF0G9m5cBp1PLwMxIcU7AUeElYbCjXZUsFV8VV4cxh1lRIshUmv8c8z9Pm9nMmVu9rDLtCtOYmBmQLfWkVVH06a5XvorD+qhLXFg5xWbOjmFMGUTlsUCOzZ0GQ871hHVsHpspzlHk+owv/6pf5k/8BsYz6sEvZCgyMgyiSRfLP9pHLgfxrOxYZUOIHc4zcQgpJPagnw72+ASPV9MgwJ5KlTU0YYhZItjRuDIzg5oDnlJCQ7/MPmJtO1/drBs9pW6+t9cNiMjHj66xNj4xEqWsrrVW2se4nMdKTX/9i0TMR6+isQWYwaRKQUXd+S2AgBlRsRZa7QCeSVruWVmOKhWg+3SImmikc+ryd5TKVhvqZCNqsxIUvmbZC6E9aj32So0DGY4WzFqW2AL+qR5oq9lwinELXMkauYnKrwRMxo1Ivuin8IT8g8eQkqnXYX+NKwDJ4Pf1lrB0PZ+q21h6YKa/b036FrlfxaQk3sJKnB7PGfg8V4FdGPbOYIkh/cMFwkL+8IS3qvkXbe33fK9SvPplJPczc2NQnu9lnQL6cvSxhROPRL//iM8vNEvwoA/l20jwny+
 17JN2Ppz
 m1eZ9KkN+FHCK4w3TcNFI2+8owEt6rvvjQ0c+ZY+j1gmHnq8i8f6Ry9CdZewPEvr/CDmGJcpEOj0b+oervQbkTcrAeMx74IUY2UjdSYdTgUxX3fCh4nie2zirZHEnYErsHiWLJHYQpm/oR+Vl//uPAmf9g2jjq/9TljuIt3gT7YHI+0XY+7KcS5oDsn1vs/wrWZe9jh1FXzAX/xrd24XYFBJvW5zn049WhSRfzfu1CHKtoU4MItJJeLn5VECJ9p1G9SN8DgKS9uafiyjLnNG6hsfblX/1hJX8COeyoTL3Wy6hTCKdSLUllJ1W7TBvQJPS9Qt2KdZxu/c+btvF0C7zuod07ccYfr3bk1KmAkzN3fyX9F4G0el3BqEH6I5DgohGDnlMuXn4xPuWcCsnuZ6HsudOibBPo95mrg0H5cvbVqN+Iyl576g0FQhJ45STwLahDDX344JzHKcx1f8d/vjzRa9hfGXQfGmwoucyz5w5aJ+wrCw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21 Oct 2025, at 17:21, Wei Yang wrote:

> The current implementation complicates this process:
>
>   * It iterates over the resulting new folios.
>   * It uses a flag (@stop_split) to conditionally skip updating the stat
>     for the folio at @split_at during the loop.
>   * It then attempts to update the skipped stat on a subsequent failure
>     path.
>
> This logic is unnecessarily hard to follow.
>
> This commit refactors the code to update the folio statistics only after
> a successful split. This makes the logic much cleaner and sets the stage
> for further simplification of the stat-handling code.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: wang lian <lianux.mm@gmail.com>
> ---
>  mm/huge_memory.c | 44 +++++++++++---------------------------------
>  1 file changed, 11 insertions(+), 33 deletions(-)
>
LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>

--
Best Regards,
Yan, Zi

