Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FA52CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 01:19:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EC846B0312; Tue, 26 Aug 2025 21:19:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49B996B0313; Tue, 26 Aug 2025 21:19:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 365556B0314; Tue, 26 Aug 2025 21:19:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2302C6B0312
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 21:19:48 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9AF68139650
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 01:19:47 +0000 (UTC)
X-FDA: 83820780414.17.C4645BD
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2051.outbound.protection.outlook.com [40.107.93.51])
	by imf16.hostedemail.com (Postfix) with ESMTP id C85B4180008
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 01:19:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="b/42tkxW";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 40.107.93.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756257584; a=rsa-sha256;
	cv=pass;
	b=Tu3OiNq5j3aB4sjsFFI3WKIz6njW7WgnifezxhKI0bEwCVNLbpH4HhYpItHshqTggbZEd9
	WUQpD8bFEthtsD2L3nqgxLqDk6ZWj9LRLlRxl2zH85NL364s7L+dJndgOvmwSxS4GGCQSY
	kVHndNZbxfXI1GvBeBq6nN4xv41l0dA=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="b/42tkxW";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 40.107.93.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756257584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YW57HRQRPlJpx2r0CKrpKtxXPJNRDTMUyD0iWuB7lCU=;
	b=woQIHED4YtWU98x5yDxzIp5nvqewhEbZ62J5u8MDuWn1xmkTE6eQ8fgwR5YcMqW7D41uAs
	zeW75NONj2P3GkmgTaX+k4vdCz+SxUfZX+8WrIG8Di5EN0tuQRhXcIs3i4DyXTcQZ/Kxrw
	3/YkT0gRLfXF42Yzhn7jfB9Xa87Yoy8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=usYprVQuWEPG1iNQC5F07ieBfCbOB55/3MIBRwlwHRn9khY+LDjctYCaEAMK2dCp4Tsv1ei48x6JM9Xa+DbEW96e+eERA0wyRaK4K6UyYVjtQjTVDlnm40pbo7UAaKRRLrV/X3th1hFRG67UGSqixdyxH3pXn3gWCfp8ZHedAqEhgp0PeIW+2iGdzwvl8upwZUulnTPM0dNmHsRXjdoPY7OqbMniu5Q2S7PBLHq+qEYyNiEGW2pvAUccARDS3Ww9kDx2U9qJezBfQwXYbE6lfirR7aJFTwc3cAwxEth2u9pbaOetINznfJCh777qPrknDYwwPLdORPsibm7mMMUbsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YW57HRQRPlJpx2r0CKrpKtxXPJNRDTMUyD0iWuB7lCU=;
 b=D1YpUtXw+eDzs7NohfIU2BuzDJtUEbeMfFl6Wza/TAg+Z0ViMFlHDG8GgR9wu5IpxyALFY0JVN3iFEU2U1frpfPhFE6XLPFAQMjRtCuZ2c7MljUyVlhc9noP6XTAqtRXQ+Nej/AkwayL7i+FbsVHWWqKRCgI/KztinTRWMs+yROSA25TesylBh9ljp3ex42qqTV+3SKpJ7tL7GdFMja84b0P/EOZhE+Evx6b9xSssH1+Eaj/uK/nWlRcVQROHapZSGZq75r0+msbpqd3ol48c16Z8yhOntu51x8npPSVWRq54qRg9rg5zjiyEO/2Hpx0a3Z1uYDvdU41RDbsq8eKhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YW57HRQRPlJpx2r0CKrpKtxXPJNRDTMUyD0iWuB7lCU=;
 b=b/42tkxW6VcUQCBxoUWySaTs3UMQnaIb1ZovDy/n5m2kRq0YSCCROc6MegPg9NfRGskP7bmgpB/nvIKUAKVA3VnNb6fWhI9FclT2pldwY1AN9HfJ2gKS54dYzRx8w6N2oTVUOYkvnOyYMbAQnfPhRutiGncRdQf4LDNJkbTjie0cOHeowt51yQora+FM2etmgJd8/OMGnVFCcd+aoiZ3GdAi44zioSPqlW6uRR68cTW/JoCC6FLmXfWdd8iSU7gfO5J3ePcALzwvHkFcg6hy0cZNvz5o8YKqYS2bpfVWRItssu0J4X8W8lDJWssROc2ZJmwpLiUM+PBCSe2blisTCA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB8310.namprd12.prod.outlook.com (2603:10b6:208:3ff::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Wed, 27 Aug
 2025 01:19:41 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9052.019; Wed, 27 Aug 2025
 01:19:41 +0000
From: Zi Yan <ziy@nvidia.com>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
 bhe@redhat.com, chrisl@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] huge_mm.h: is_huge_zero_folio(NULL) should return
 false
Date: Tue, 26 Aug 2025 21:19:38 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <733CF0F6-6936-4765-8EC5-2430E683C717@nvidia.com>
In-Reply-To: <20250826231626.218675-1-max.kellermann@ionos.com>
References: <20250826231626.218675-1-max.kellermann@ionos.com>
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0034.namprd02.prod.outlook.com
 (2603:10b6:207:3c::47) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB8310:EE_
X-MS-Office365-Filtering-Correlation-Id: 0825f29c-5f1b-4d46-5ece-08dde507cc7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?77e7OMtcWR8wqemBTZitbkYg4JkUS7o9Juvni1TFEfovJNn7UpoPJLXdKW3v?=
 =?us-ascii?Q?1xLtrBMCEnqILsvLsUDcU2Yttgb5VEtn2hd752X82cwxDRNuUmkAHdR4q+IJ?=
 =?us-ascii?Q?pT9O4b3jnWRDvSkYEQ4/3n6rLlqJmG27LX+ZrYqR7HzO0ug3Ft14VeIdxd4A?=
 =?us-ascii?Q?9sIBskRMTUzVYpwye4Xm3PIUuKVTR+YVrTEy1d9LUuu1zJkCngRFNcUYcyoH?=
 =?us-ascii?Q?Hr5JDRAseOK7coRAJ1vKbkRUfNTIehKV8ZZsNBFRtPdg66rlqmeXg0q2wuiK?=
 =?us-ascii?Q?y3T2xBtQquxkbyvw19+FJvWBv0jDX+mGPVEa1OIIHc74UqIKkeveQlvrgQ1a?=
 =?us-ascii?Q?cqUvti4/uip4rlk6ZoCTPs5Qo3cBUhKidSlGPcHR0QtMKIbaXwGRIz2iw4bJ?=
 =?us-ascii?Q?Er08jESABJNZm28OQpAo4c8mevCSePAv6USnna5iPHcUq3aNvvBH333sS1cC?=
 =?us-ascii?Q?1pfDCyJjW3DVGruG5YGIo30vIit9XYCF53v9gK3GTxp7UncYk361ZatqJCw8?=
 =?us-ascii?Q?EyqiQO7dq/lZnQXy+he5+XKFuml72uYkEr+LSJ2ys3TaUcruHyn/H9uKJT5s?=
 =?us-ascii?Q?0A+FoDZ/2s8BwNEITm6Jub/uG94XUFHsrOrIguLHzuyDVPzVRehluqFe0QnN?=
 =?us-ascii?Q?yXCQsm5hso5b9dIeGqh7uq9DV3Z2ijU/44L5iCg0qyWXD1mJjeAA55Xdt9BO?=
 =?us-ascii?Q?jtaKXmcHPbsLT+o4QZhLbUfuBJhSX8IEczGjST2irJI5NiTBMQVwQKFQEDV1?=
 =?us-ascii?Q?V/YlpXkPCyHquILcBNh9QWmzyBlrUo09kpubeMGs+ujTnLB1erXC72uWyX9q?=
 =?us-ascii?Q?bik/IqCtXz0ZB0kd7oR62X8s1xoK3Q+S+urQDQekiLhzLgs34mKRm+2umDM0?=
 =?us-ascii?Q?WeBB/OHLf/l90a/89aQiBlmgpKrGcYukgDi8A8U1DcQ+/deRoCp+u7zs2BMi?=
 =?us-ascii?Q?uZR1/nXW9ZDQ1AMIDw06YAPDjaj6wWHFYjE4pVy0AK4MswCGVRR2fZVYtcAv?=
 =?us-ascii?Q?wMFiZy+4vLSI+miejm0Hi0IPyGtLqaVDMWyoBoNemxUD7j8V/Kneb6e+Wg5f?=
 =?us-ascii?Q?HHO1+6LhFPhluxlpOssRnvG36et3/weM2nR69yuvOqBfr7lynC+3TR2f7RQt?=
 =?us-ascii?Q?dOQr08vKJhm0OMpFrpUMcEHMRJxPxkjndVn42FAGXqUh73J7M4a5g2X3tC3C?=
 =?us-ascii?Q?9FWQTgKOLvzcDw8vUnT2YJ1eyH5/BweY2eeZayt4W+B0HPsYMUxCPCYEo8h9?=
 =?us-ascii?Q?zjrgMOq+B65hyo1asu6AW77KZQ2IhnNNb586hCirI7CpFisHoBpZMoSmrfxG?=
 =?us-ascii?Q?bpL7g9T66tHj21/z5bKpWaBaVDFH90MifEohsxttSZja787/vE2iDm3zF4qL?=
 =?us-ascii?Q?QADubHhzN3PKogVT77Vw2oh6em/69l/otkxDsNBhU2yMUXZNstMkOdgVvIm6?=
 =?us-ascii?Q?aaQY+uRTFkE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?34gHNsQppYyxG20f21d88fzztv3Lu+ZhLAALer4oMXbnK8G3rDiP0rwzcibn?=
 =?us-ascii?Q?fAjuyIDTyfzzhORd1pEJPJkFb31B5xzTkbQzmazSsjhRs+v3W9bPkOfR6Qnz?=
 =?us-ascii?Q?5cAZsFjqZI15EuxgKUNRrtVmxA9InpO/IvwzzGBJhck62APL2h98P/hwropz?=
 =?us-ascii?Q?VRlBC9Nj4uOW9EJCzEdfXVUGHjkoGkdTQvFqnWgjZqxbYB+UHAKqPrigafs/?=
 =?us-ascii?Q?ySG0JsUvf8uLTM1KmLIRdKt/N4h5pgeBWHEFQYp/VwB/DqmUJ0ehJ9xcNt/t?=
 =?us-ascii?Q?gxkaLjW8zaZ0QJWQmMBA/s9unjTw6+qMDw+uHqlP1yeHlULoCzqf0394iHkc?=
 =?us-ascii?Q?cJFiW1/Z6cGu4K0CbNpMflcJKhaSomrIHXxONHpetMWhD+4zNg1gzQ+bXV6c?=
 =?us-ascii?Q?hFz0kE7MwQMvbbK78Y5k09T6miayJX449oAj/+kr/IuNFEKultqGFimNEe4E?=
 =?us-ascii?Q?RIwLMx/XTl3ff/rXrzWQwWAITrFoVGPtVbkx4lMd8uEtZ1VMbr6spfsCe2l6?=
 =?us-ascii?Q?4VgUXcBZFiRTU9KdcYKzhGMefJrN7bgsTVdxb+M+zcWWxR0s/rAgqduE4Cfw?=
 =?us-ascii?Q?wRgV9s33pkjmO9XIKd0ZbfCBvPg0WA+lYQsu7vIYiSOO0xWmLBsoOCpYBBdP?=
 =?us-ascii?Q?oHQJe/dx++m2rXGYDY+7yMMCw/4LrA0EsGLthorhPjTOLRvKRnsV4SeAb351?=
 =?us-ascii?Q?ssLAVETxjYVcmte8aDVCahgoatd58kzh5JMa9CQEUjA66a+Xra3VvOp/LZEx?=
 =?us-ascii?Q?rtQBzZo87edYZ9LmrcmjtnDxgdvU/yvhl9QzpllZAcvNkAamb4pJJovq+u+F?=
 =?us-ascii?Q?++MhdZF28+dYem5eHjkSxsUdos8uluOG4El6+V2hh7UqktJPRHB2qsE7vZhL?=
 =?us-ascii?Q?bMR5aftr9fn/gvtR2+1vl9xgphiazp3BSc1R6XSvq4B8xZVohzwAlXNIADUd?=
 =?us-ascii?Q?AS/lc+KzY58Xv3tEECqh6ROBtn2cxYueFUUjFI8hhopi9Vl5zE5Q4Lg11jL4?=
 =?us-ascii?Q?cICwuvPYv+C2S5MOdKx6eKR0zYG/DRLwujfkRDpQAA+ZktB+NGMuspWci81m?=
 =?us-ascii?Q?GEykeqTVlUm2pP/EWlPXpgUoUr7onaMRxHgPkXhQ5BDBUN+7tC0MEzF4N6jG?=
 =?us-ascii?Q?O6TfCFsA8CFUz70guMTIwkIRbL/aIZulrqHUFUqDb1mknlP7hSllgpRf8qkz?=
 =?us-ascii?Q?1ILm9gl/aF9wvSAveUrOW4gEUuwmheAbizfl9wK4ZHJtK/XGJ5MQb51mlzCN?=
 =?us-ascii?Q?H4J2115zCXLPNskUr5JjlFUqM8TbzVm/0EiwLO2Bl/sqpTP8Mp3cbrMYupBy?=
 =?us-ascii?Q?5Rd3sripxXEczS0ARzcINJVd+PUrAHvFi85cJAw0Yz+YuYYtXf4+mvVRPWzu?=
 =?us-ascii?Q?y6zA6OHMwSJJnnXb4iP0kpJ5lKyXWi90/wVmoWSfsb0O3/lnGHxtpgkQG8sd?=
 =?us-ascii?Q?LNZ4MQuQ62qAxct1aRF15lpgV/Pz59WEfaqT6PAPW6MT6yyhip99EvyiSlFJ?=
 =?us-ascii?Q?kxqhLbVLD3WzXEZIOmfFw600nGmuzQFu7f5+viiZiBntCRagcDzCHizBHu1X?=
 =?us-ascii?Q?3O5EMlXozBi3si5NxtzIMBskc2kEaYofdX3RfTjX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0825f29c-5f1b-4d46-5ece-08dde507cc7d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 01:19:41.6245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /x62agihYJUWjhv8WHd45blFXa6mMME+g2n0TCEQFaH6ytNC3DOfbf+fPEuiefIp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8310
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: C85B4180008
X-Stat-Signature: p5r61z7owo63udsuohxhjkp6m5qc7bhb
X-HE-Tag: 1756257584-658407
X-HE-Meta: U2FsdGVkX1/Qz2ATIQdgYSNNR0zGDXTzG2KZPfC9M0pMaICf6JPmhrHwuCBgEAFv9jBoFzbi/5ERX/KS7O044hybpbA6ClcmMyRyacg09qFktMo86T9seu3ybHeXt4i6JsrMceMYbKcCNrDealw4heIsRgbpPGLHpzKw6jjE23oIyNPlk2BmeD1t/QW3SJ2k++VANA3UL+xO4CiofzBkoJ4HO04q0rvGzDmw1kmyF7OcTolwJXq2ibNCUaWDxYquGxOpDuTYyL8MWeVTjFnpuTq78JPGid+twIN/U3l4phaB+rHxaZQTi0KcHKwtdiSFb1t4Mn+vQ8VlitpZBK5OvIpQ0/UgHk+gqJsi3dhjEbMaNF6bRZSxoGfELY13LzFXFXauFwG80tbVylkv2qFayzX3LVWyOGqzJ9fRZtxs3HIEpojZwCxXTRWQVUgHvXRJ7jE5PgmQ5F9W8eXIWnJqFpWDqtaR1/lw6ZNt9cucv7rGKw+8Ojw7AL1STf87Yx9XvAqU8CDsiHyQATKuR+r+4B4TJ2DHsucZw67/p4HlnICK9U6R2VBcoUTrExvsBxB9AoGOBJIf53MIvmQOzXs2f8PuUxJLdOEUkWCEFEltpQvZrw0f6Fn5T3w3RI8/766ffUz4yrPyC54vcfuJ8EOi6XMWlXF7ROrLuU1MSGZjreHOkSZaCB97A2Rfkb5EMVqOdf2CvG6ZR7QW5gjCJMJnHZ90+ibLgDYhnr2rd3jPSVeExUtTg3TzacwDWWGyUvlA8mMmzHr3hEZeUWc4uQXgHz8e9fpt8rSG4L0CoU6BYJLq1FxoGajhYkfGFutHyOUt5DnGtJf5Oo+P4SusLX7UnIVqM8wpzDLlWkDX1RHKnr8pjMnCnbemnGw55AUasITkiNCA3QK5uvVyh3LY5pv849k4/Ql6fnD074KQtQJXPIR6MC79eYPH0Mgr5c1W8H912CKnLVi4txSnD3xn03O
 Gog1eblz
 lr0/tAqQkuJib++k9cRf2P6baxAotGizm3/qI9dSMCAdiMOezO4+03gkS8hhPdXj2lcDL9lElc1W5TtTEh3EMKTRaUfOM8hZkd1+/RO2sAwG73QqG0MepN9vxCJ1PjRSuEmkm8WfJM58s9gVMhCCEhG/szedhr6lTeRxymq3wDAhtr4nN4MP2/xUoJ7cs/ZuBLetUCBN7fNApB/fG8wgn0grPHtJfG1tOhq9OreNg/r5QIODKR72pX2Zu+FwimBNhOIcp3Ypiuw9PfY4Jx1f8Hz3WcgEdQ8S7zzujtl3HQ26XBwcFdRypm5p81xKIHDhc4ZtS6hqkPfNTEdsgExWjhRJCw9159R/Kis6jl8PcgKsmlhc796EndYMPQKSgGbjn9/cLLuohy+xFTty0fe1O+iivpTL6+I18dcIW+Jvu67Ar4OFtX6f/27/y6RbwPkHjkVXhRTzCtmSBwsU4Mq2rZp43ZAp7yJDzsqKFxPjurfAFXQaSH5KyzBGGd3sU62+QT1l6YWGK/PX9Mw8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26 Aug 2025, at 19:16, Max Kellermann wrote:

> Calling is_huge_zero_folio(NULL) should not be legal - it makes no
> sense, and a different (theoretical) implementation may dereference
> the pointer.  But currently, lacking any explicit documentation, this
> call is legal.
>
> But if somebody really passes NULL, the function should not return
> true - this isn't the huge zero folio after all!  However, if the
> `huge_zero_folio` hasn't been allocated yet, it's NULL, and
> is_huge_zero_folio(NULL) just happens to return true, which is a lie.
>
> I believe this is a negligible corner case and I don't want to add any
> overhead for this; but in debugging kernels, it may be helpful to add
> this check, therefore I put it inside an `#ifdef CONFIG_DEBUG_VM`.

IMHO, we should make is_huge_zero_folio() return the correct answer.
Adding hzf == NULL check should not add much overhead. So removing
#ifdef is better.

>
> This weird side effect prevented me from reproducing a kernel crash
> that occurred when the elements of a folio_batch were NULL - since
> folios_put_refs() skips huge zero folios, this sometimes causes a
> crash, but sometimes does not.  For debugging, it is better to reveal
> such bugs reliably and not hide them behind random preconditions like
> "has the huge zero folio already been created?"
>
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> ---
>  include/linux/huge_mm.h | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 7748489fde1b..e4c617c0b445 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -479,7 +479,12 @@ extern unsigned long huge_zero_pfn;
>
>  static inline bool is_huge_zero_folio(const struct folio *folio)
>  {
> -	return READ_ONCE(huge_zero_folio) == folio;
> +	const struct folio *hzf = READ_ONCE(huge_zero_folio);
> +#ifdef CONFIG_DEBUG_VM
> +	if (hzf == NULL)
> +		return false;
> +#endif
> +	return hzf == folio;
>  }
>
>  static inline bool is_huge_zero_pfn(unsigned long pfn)
> -- 
> 2.47.2


--
Best Regards,
Yan, Zi

