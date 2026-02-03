Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1064DE7FDFA
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 00:05:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FB4C6B0005; Mon,  2 Feb 2026 19:05:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A6026B0088; Mon,  2 Feb 2026 19:05:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 087F76B0089; Mon,  2 Feb 2026 19:05:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ECFD96B0005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 19:05:55 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8B8871A0326
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 00:05:55 +0000 (UTC)
X-FDA: 84401202270.09.E3D7E0E
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011029.outbound.protection.outlook.com [52.101.62.29])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9CC5C1C0004
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 00:05:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ut05zN+T;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770077152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MyD46pDIZwqUvOkyo+Oh1ZG5FdnEADKeH5sUNu7jlDc=;
	b=OnnRqpJmg+JVHS3KFaox+4OCtK1WXXxW5H8n6nfowx/byhhic34XfCKdNeMZj3rYETx8VM
	YhuqF0ITxXsRMQ6k4vc4ppKgRrBWPAZ+oMYHP20rGitiPorEMRb0B7nSRCYe9wd3Rs4akE
	N+4166FCgf0NX5iQBxzLWJombc0dy6U=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ut05zN+T;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770077152; a=rsa-sha256;
	cv=pass;
	b=pZsNqUhe4fB/9OtCyKXP5oGMkyBD5yh9XA7tyu725AI8fNHEGfIhKrFNCIWsUJ+Ivc3q+B
	NSrsg6bX34LWMa7u2qBwE1/hj2GeypGgT9ZzgCNrF0cyIUMhSWS3m+LGZmxZeYFY8PiCZ1
	jokr7DLXIZtH6X5zOgnbBipyjtjSr3c=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DpJz6gSTQpsrV8PpDl2593eyq1CSrnL5yTOwGaHE6XTLw129ByiiSm4dun1BMBSxEhlherNJ/EVOLhr16U/a9QxVrJwi3jo70ftQpumRiIQTdXKZALez/DPclXtTN/3GSwuAGx/nfHe04oA9GH0i/j5X4JOsXJQ24YU0Z7X6J4KXNNuYDr/JuV5YWzS60i1ic2146dBf646vEQR//I7v0r6TKJVMCelebV9HNk7JePZ4B/3zszOVmq/6Ljq0G5l1KN5/YrCXXlmLgdbx3a0k65zmNbaN+mXnK57XBk/LrNuvjZtFgJJ+Wlwqerd1+kkMB1Ejd5mG/P4gFHzLGbIXXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MyD46pDIZwqUvOkyo+Oh1ZG5FdnEADKeH5sUNu7jlDc=;
 b=QOpdK0bJitktOp4Xf938gp26lkusA/ZNH9dqWf/FJNZvt1xJ1+gjWsZ5aDYJXq8VUT2zdIkUZZ7RBqTh+u/DQ9OoQJHaix9yVPpfBxWxZnZi9ktZa3gM+8+pz5DSoda82TU0OGCsAyLvpBFnUb9LTNmjBcc9Cq740Zd0iQ0LRtgyZ0TdmZnk9WN2Z65gdzxFUMsO/NuFfaPkNWbOC9eDGkczWZ22dMUUDUGvfl7Z9eVBw0EbIf3mN9UXow+FyNjNdZt+wCAcfd5IkcOUkUX+hCmdPeSHhpmXBMT302kcu2UQzH+RmZElZwzCkrNdbewBgAmwhFl69BC5FPRwD7P+1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MyD46pDIZwqUvOkyo+Oh1ZG5FdnEADKeH5sUNu7jlDc=;
 b=ut05zN+TbmX88R+PIPHm7uZfnpqXfyAyrLo+Wd7kF/cidqZw+rCNjDZoo/0UHx4eCoKjb9zwk/rWcC4OKPYktJayfkl6b8J//Q+IxR/LGva3uf+qK3MQgAcdywYIq+f8eglRCvAZZUAMmNUDTGM+mu0l7EgGmOGdA0idp+/FH7VPXzvKJx3yieakHBnLa6O7ncPJKLhr+AfGH1FhMFuFjYhXsMgTTTwiv8qv33KJyuz0LSPGzvsNzoSOJ/Di+RqzeTLlgnFsxVL7ou0tSeHSYEDaIp6ei22RMP3EWBjhn/yL3PNTORW9ef5I0YWNXWooi/hEVDUGfQd6y/kh19gDHQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA0PR12MB8906.namprd12.prod.outlook.com (2603:10b6:208:481::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.16; Tue, 3 Feb 2026 00:05:48 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9564.016; Tue, 3 Feb 2026
 00:05:48 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: david@kernel.org, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 riel@surriel.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 harry.yoo@oracle.com, jannh@google.com, gavinguo@igalia.com,
 baolin.wang@linux.alibaba.com, linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: fix early failure try_to_migrate() when
 split huge pmd for shared thp
Date: Mon, 02 Feb 2026 19:05:43 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <DEDED3EF-FB7A-4243-8065-F2D73B1FE444@nvidia.com>
In-Reply-To: <20260202235714.5wvxveurjfdka5pl@master>
References: <20260130230058.11471-1-richard.weiyang@gmail.com>
 <178ADAB8-50AB-452F-B25F-6E145DEAA44C@nvidia.com>
 <20260201020950.p6aygkkiy4hxbi5r@master>
 <C620202F-685A-4B9E-B51B-078EBE5BF0C4@nvidia.com>
 <20260202235714.5wvxveurjfdka5pl@master>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BYAPR07CA0046.namprd07.prod.outlook.com
 (2603:10b6:a03:60::23) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA0PR12MB8906:EE_
X-MS-Office365-Filtering-Correlation-Id: 84984f15-068b-4d25-39f6-08de62b7fbf0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bmPP6853QgR3RNSlIUyTYRW2uLS8hNj+ZrulZzs5ZSNjWexghvLuQ4ri7N4O?=
 =?us-ascii?Q?eo5z4psO2eYP1d1rNGNLljV1ZSTiWl67e7rtBVseKB95Zxa0KJqkpwYEPS/o?=
 =?us-ascii?Q?hbFS2tr1bqiUaLmZk9/gP8B5d4Lg+pbsRV5pCoKiY0AWBcPDzmCEtMG+XxVo?=
 =?us-ascii?Q?zSSkneziLPrRZJgdNoRtZxqjCsblhiy6AO6vYMs57VWzlGV2RNU7G6p0hEFp?=
 =?us-ascii?Q?tJ3bTPjuWRU5REiBQ+PX+PvdApv/mfXEQVMi/VnQxphvZbQIEc+WN/362tUU?=
 =?us-ascii?Q?yR/ZArtgJ+Gch1ZtFNQS/gDGNpJJouF2XuOksWMV22INum50GknK0VLAyx8k?=
 =?us-ascii?Q?dCkhHKOp0WH8bGkf2/j7++jCjk293QwNKFfBLSmtUjJOGEVrd0PGCnR/QZxf?=
 =?us-ascii?Q?CNsYANgsEfcKR5dy9XriqqLAylxYSbdiNp3c3V5545o+cfJ3V5kFSs5Nwv6T?=
 =?us-ascii?Q?W+nDZtS+1bBEth8qy4NdZtk2OhI1x2YzcrGTGCX7WI5PHHdXzNEowqTP+5XZ?=
 =?us-ascii?Q?dF5/wmAzULZVAELFbWunMdXm2+t7HEdGlGGa5trQUo33zqGjZFNWrVTO77B5?=
 =?us-ascii?Q?FKHvOX6yeeDZwl7/WjiAWBjm7es4ibQHZFkyE1o7dK+RTxCg5knlW8RbuNXQ?=
 =?us-ascii?Q?zrTtKDc7zIWHSFfPjI8I2S+lP+Sl/CHC+Sr/DRRxbx0wQFAeAuqvZv4AiPus?=
 =?us-ascii?Q?SWZCZMhMb1H+qmfgt8OgCy7obp+mDXwAVpc7fcN+C10U5KFj4m5mKxqMmLH2?=
 =?us-ascii?Q?HmENiXGupT1EjCl2QPmNe+LFF/AjBHKobDpPCITkVr5uaZickfiZpvfwkmHU?=
 =?us-ascii?Q?A2Yv4sLJ8eQlDDchDXtAszcQmEZkqxW01vqXbKOpRZ11FRi93hKVPzYbiioz?=
 =?us-ascii?Q?E4LaZDIvdX/uSP1kNUuaSiQF0eptxPZDFb+CRWNAGpDuRK53oLn9e9I/OsjN?=
 =?us-ascii?Q?2VLNLzDdpt+xA8cGONBPiHF19VUuJCv9o9SaOM/WiJZSghfgXcJN1ev9F52a?=
 =?us-ascii?Q?s/rOfwmHcx/1a+5HkCzn7dTutEmC+tGWf2nmIR6jyTL5yQs/chVw2B6ksxTS?=
 =?us-ascii?Q?ahWtvGA8io6aCeXxCWI1ngA2arUmf9xMhNBJzrHhOU52FKPINJrr/RgtTXcT?=
 =?us-ascii?Q?rX2+3IF37jc3aKWm+9PykGxfrA3cihXcIs1cq7iCnZtQoFboiElk0a3y5x4M?=
 =?us-ascii?Q?QOFTtA0Jcs54Ap/Vc2d4azWc48jW8Q4jpgK74m4TDyQ0ohfdnb3yGMhNGFmY?=
 =?us-ascii?Q?Ev6ya6C5cqUERU9BpbY6goAlYa778Fa5l5PUMA+xPyvMmxt+Yeb0dz4hhP+J?=
 =?us-ascii?Q?y58yy0PVYHTxQyHK9JXwpaTU82/0MSL/XRN/bag4eW6LzuZ4nPchjQrt2XAF?=
 =?us-ascii?Q?+nsKStUlcFyYeeI9964P2emONyMO2PBTRSDNuqml2UEtjhDDzqbOPUtsZ0Uk?=
 =?us-ascii?Q?eqWBR5PIqwilBADe+ol+UMuFqx9aYV6qpTd+d1JqktgGGb3/KcMfJbjzS1/b?=
 =?us-ascii?Q?+djpKHDhg6BkuhJtu8oG4g0TKss3iGsOXlUzX1KRVdyJ4L8LyQpL6h5I5PtC?=
 =?us-ascii?Q?PpeZcsI7OJ6Qg5eoeDo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wbb8mO2t04cvyI2PCz3PCSsoHp/sYEfdT/wjtSje9238brZtnMNcBaB++zQW?=
 =?us-ascii?Q?cvhjJ+NCNhq8Iw7s+8GxEBeoahDCSDKqReZymjmvvu834t5kS3Ee20sqJx3M?=
 =?us-ascii?Q?DvXIJqpZmSZfOUZwThVrik9kRk2+rDJIm5PvLywQtjkSH3Kx3ye/Mp8EH3yS?=
 =?us-ascii?Q?TM5dVazMHThsZe9lsXCNCYTI3/YULY8evFT2skmAzMRtGnBTOxfoYMtTBIxo?=
 =?us-ascii?Q?kFsUHIdictpgZ96DyNcPQw/OXHusMJFQIzq1NjY6ziQpC3/YHKtY7lT0nFTY?=
 =?us-ascii?Q?7jvvCyvdMEpVd7qyaksdAp+rMqEa3giq9NmtvNghtQOPS7EYzbUdJV2pRHks?=
 =?us-ascii?Q?cSNKAhKSxrKXaF3/l00t9IS+hWli3iVcsriBeLLPtsZlx7Od412hT0FqmWVg?=
 =?us-ascii?Q?pyvYQ4DA6FezvbB5mACYyRoWDHudfkZRTDtqkFfU7A4JCpOWFfLH6NUknJ9r?=
 =?us-ascii?Q?JRJijLhkvvP/tolaKE97E1emiCBJlp/70XX18xeD6AJyl5r9Z1YVYH7K2aea?=
 =?us-ascii?Q?Au6+AR4cu2UzBHJ0P7CmA2UClYHOXnE/GDiOLQvJgsRyZMo9/iMwxpUi7Jz9?=
 =?us-ascii?Q?zSPWwDarLHRjP/bmSpHnaRBxex0VQuc5PaEWoNMDg8QLDe4CqwPjarJY8XfK?=
 =?us-ascii?Q?uKVcjlotg8LszNuAaj8DMPO2nGiZI1UFrszF6D5DOMNe55ImCxQn59ms4a+W?=
 =?us-ascii?Q?hN5jT+uMHQlJ2zagQXypNuZDdAtm+IKSdW4uONBX+e/1NUoHA6dE6rdjLlUR?=
 =?us-ascii?Q?tpDUBTZjdFC4GWyofy0usjnhSe/zrrlXwqYb8oY86FzCmYKmRInYcSG3XACd?=
 =?us-ascii?Q?bZ2LkmWET6y2nf1gzJYN7CiCOlplfO3OAYRRnOm5bWX6p9klu/t7tcq22oju?=
 =?us-ascii?Q?24hQDGJDYO7MnQAH2Gbhh8SI2/Eqf44xI/i0cREvvwhKSlYRVo08JA367uBG?=
 =?us-ascii?Q?Ap6E5/R5wNCG8t0x2Xqg0UuoL729rcTrD4FYS2ysGlxPOWkg5IIIH17nNoPm?=
 =?us-ascii?Q?U6szJX75TKeEq72W4xctvCGD5RGgchCviucR2wIwn1Bt4luwgXYqAhvL1R+T?=
 =?us-ascii?Q?fRGPhrMi1GP/9I7UPcM5VNFtiSfY7m9vJyAiJLTsxXGZJEDYCQF36xXfwKYc?=
 =?us-ascii?Q?B+9bcapHq+i7Y+NaWKxBB+JPSkLNi1EtC+G7xRFVpwChGKFrYXg9EMiPq13M?=
 =?us-ascii?Q?XaeijOJ9bF9HL0bCrPiJwNuhQoqDS0JsRCtO7esDWCCOWssdn9qpy4SnZMdg?=
 =?us-ascii?Q?EGKlTXFLsvsDiVisX5u9rwwUEfIH0ybKQFAXU+ypLtOwa5zrKXTd5bMuoGKb?=
 =?us-ascii?Q?ImpdF+RiktJ5dypIX3+Czk4iv99A0f0d72uFlqntc9O4JVftUH0oDGNYKsoA?=
 =?us-ascii?Q?ErypL5M/VAeD26fuGPZpiU2ISzBclziUaqkIgIR/OOijeXy/aqVKASgCmzhn?=
 =?us-ascii?Q?l7SYTiIArYcyXVGPKoW/RVrOA7lVRyeFLZlLAioC7NRZ7iozwrLc7umtEuqq?=
 =?us-ascii?Q?tG7CrUm3SdpiftF0YXkKYIl5vQqKcbyKBgGYLGM7NqJWQl3fWqSwtKkRjzJ0?=
 =?us-ascii?Q?crkEZpL5Dz1LgR5oo0s9+FtcPCnBytSewMLZdBOfr/u9yPrdyHSuhH77Or8W?=
 =?us-ascii?Q?fixekxz2MVLi9dJL5rlckR1FmhYqy0O1R5L4zQ+n+yk24ZGn/egF/T6UU1IW?=
 =?us-ascii?Q?krDWicTyN8nxNfVOFvU1bO5SJ8395ovT0XIsEVEfvJXQUv3A?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84984f15-068b-4d25-39f6-08de62b7fbf0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2026 00:05:48.0953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BCkTACvxCMwIdN2hz0ZkS0ud+dfPlx3AnJvc8O+BvP0itPJuHzZgABACqpPVGBYX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8906
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9CC5C1C0004
X-Stat-Signature: md55k8d4pojnar91ns1umcpxcp57j7pj
X-Rspam-User: 
X-HE-Tag: 1770077152-946720
X-HE-Meta: U2FsdGVkX1+LjNARKBrPc32N3zEDk47TXLJ2RFFZ9domJ935pijJxNxMhbVNPxWUb5SyU4rXdlj2UD4o+S1gBg/EX6xQ9ARzCVTtxxk803c6fu6GUhGrDnu+mdqMPP5OMY3SRmIKEk1tzyIc3ecNOrPd0b3G3VK7vMtyXT+yUFI2duWYPMrDlBJkBZyDJZE5nnC+5Z315xBrX7jhyGNYaRCm9zaey69/I87q9s8B/aSvifsZe2jio7onsn4VIkzzonEvnwH4kjQOQgGMkVqYd5WvC78bgghFP+2/KIyc4VI6lj/UsLm960htDfSlZaoY2HiY+h3rXpLwUVWXRaChvFLITG07RAnnkrf+fMuH6q4VKaHm4MwH/2d5umeywBpWSsUrhCgfz/xG65xLJfCkvLaoAfbF4MqP2Yud9FKCx60bmEoMQvg17RZqG6M2vL9mXyRFsl68feOKUU1gO+4NJmOzjby9pt1JVZ6t5mZQsAbbpPWRMpyiwcHJ25F6LjYNUDaGroDGTJBdSwJqJ6pWWjmzpwtqDmxcBiUO9k9LW210POlBrTt/0Cgx8vllU9xEklkUFn0BqWNhmJrZ+Ur2sIBHhuIwZgapjlIYZxPlbBv3raeWCldmIlSR7+a2ORigWNhylFsEAaChdBo2dmD3XVH4SVoH0V2HuQkBAtTgJNgX1gtRxYZe2FqZ8GrevA46s/B/AO4fG0s9pAzDekw/hn3Sr/I/kpRelX5aMkoc+ktbSES9+39Y7OPl5soNF1suTsMnyPrDXGyWu2HicABdl9flIIbtZudHjdm8yhnIV7Vy1f7STTwAq2lAGEkzdoGtdLbEXHOLWZv0nI4pRTbzYpy+jTGL9tDoP+nyTAvVW9I2UkKDLHRuZ3iKgADIw9sMAvOjk+7X5SxzJ42m5Hxe4M8nXhREbQaXdwhQwIPBcOEBMI3x4N4mZq3ze7VXXQKyVAR5Hn7lcvnF1nNNK7Q
 qZwlRFJU
 lX1JkJwLQ/Sk7Chw5H/48G91+vDNYgXKlnEZZM6Y6autaksDRZCtcDC6+jqY7DzjgqiCX6ah4XetXk9dE0y3fciJUZsMSw+IQgOJHSDtY59bzxtT8d6MboZ/Njpa95BlNY4Qy05JaBPk7XSg5CGwdrCvfQJU93XeIrNas+Pz5wJvFd8/7CGGfSSc9MBL/CiRJYLbzByb4iZn5lWMgJMN/vtwDkM7HQW640vdy19KzJBMETl3BzaGHRYI7wjCrErqeju4ZqwZ4iqYLpAFN7gCaf4UabsxED+tef6hq2iq1CLszeoeulwkIgQOAEhdXUJuaUH4fAcrYhiag/JY7duPnVquKQxLwW/tDz5R4CtNp4fvzT+8DJYGHwar/A4OGC+iPCaowdhzMtuGAK0lIWtpWDwzo/3n2nTwenAvaTKvyAbPgt6xvMvW0EgHrWK2e/33GNl1i1yMkkk4tKQkc1Dhi3BxgHDP5J78L2JKlk45P0EMprHxysPlgB3FtclSyYaImDUekpxV8GjoArlRe2/oNF9yOMCPVOo5bHs1QlkoD65NMAa/2FIUkB1Qksd/2+Ul8+hSVS6L0LNkyMKucC22f7d1IpvEmUVPT7tOpMcSg7oG0ylB94K7jWa8YyGcjkgItPhKH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2 Feb 2026, at 18:57, Wei Yang wrote:

> On Sat, Jan 31, 2026 at 10:39:40PM -0500, Zi Yan wrote:
>> On 31 Jan 2026, at 21:09, Wei Yang wrote:
>>
>>> On Fri, Jan 30, 2026 at 09:44:10PM -0500, Zi Yan wrote:
>>>> On 30 Jan 2026, at 18:00, Wei Yang wrote:
>>>>
>>>>> Commit 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() a=
nd
>>>>> split_huge_pmd_locked()") return false unconditionally after
>>>>> split_huge_pmd_locked() which may fail early during try_to_migrate(=
) for
>>>>> shared thp. This will lead to unexpected folio split failure.
>>>>>
>>>>> One way to reproduce:
>>>>>
>>>>>     Create an anonymous thp range and fork 512 children, so we have=
 a
>>>>>     thp shared mapped in 513 processes. Then trigger folio split wi=
th
>>>>>     /sys/kernel/debug/split_huge_pages debugfs to split the thp fol=
io to
>>>>>     order 0.
>>>>>
>>>>> Without the above commit, we can successfully split to order 0.
>>>>> With the above commit, the folio is still a large folio.
>>>>>
>>>>> The reason is the above commit return false after split pmd
>>>>> unconditionally in the first process and break try_to_migrate().
>>>>
>>>> The reasoning looks good to me.
>>>>
>>>>>
>>>>> The tricky thing in above reproduce method is current debugfs inter=
face
>>>>> leverage function split_huge_pages_pid(), which will iterate the wh=
ole
>>>>> pmd range and do folio split on each base page address. This means =
it
>>>>> will try 512 times, and each time split one pmd from pmd mapped to =
pte
>>>>> mapped thp. If there are less than 512 shared mapped process,
>>>>> the folio is still split successfully at last. But in real world, w=
e
>>>>> usually try it for once.
>>>>>
>>>>> This patch fixes this by removing the unconditional false return af=
ter
>>>>> split_huge_pmd_locked(). Later, we may introduce a true fail early =
if
>>>>> split_huge_pmd_locked() does fail.
>>>>>
>>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>>> Fixes: 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() a=
nd split_huge_pmd_locked()")
>>>>> Cc: Gavin Guo <gavinguo@igalia.com>
>>>>> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>> Cc: <stable@vger.kernel.org>
>>>>> ---
>>>>>  mm/rmap.c | 1 -
>>>>>  1 file changed, 1 deletion(-)
>>>>>
>>>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>>>> index 618df3385c8b..eed971568d65 100644
>>>>> --- a/mm/rmap.c
>>>>> +++ b/mm/rmap.c
>>>>> @@ -2448,7 +2448,6 @@ static bool try_to_migrate_one(struct folio *=
folio, struct vm_area_struct *vma,
>>>>>  			if (flags & TTU_SPLIT_HUGE_PMD) {
>>>>>  				split_huge_pmd_locked(vma, pvmw.address,
>>>>>  						      pvmw.pmd, true);
>>>>> -				ret =3D false;
>>>>>  				page_vma_mapped_walk_done(&pvmw);
>>>>>  				break;
>>>>>  			}
>>>>
>>>> How about the patch below? It matches the pattern of set_pmd_migrati=
on_entry() below.
>>>> Basically, continue if the operation is successful, break otherwise.=

>>>>
>>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>>> index 618df3385c8b..83cc9d98533e 100644
>>>> --- a/mm/rmap.c
>>>> +++ b/mm/rmap.c
>>>> @@ -2448,9 +2448,7 @@ static bool try_to_migrate_one(struct folio *f=
olio, struct vm_area_struct *vma,
>>>> 			if (flags & TTU_SPLIT_HUGE_PMD) {
>>>> 				split_huge_pmd_locked(vma, pvmw.address,
>>>> 						      pvmw.pmd, true);
>>>> -				ret =3D false;
>>>> -				page_vma_mapped_walk_done(&pvmw);
>>>> -				break;
>>>> +				continue;
>>>> 			}
>>>
>>> Per my understanding if @freeze is trur, split_huge_pmd_locked() may =
"fail" as
>>> the comment says:
>>>
>>> 		 * Without "freeze", we'll simply split the PMD, propagating the
>>> 		 * PageAnonExclusive() flag for each PTE by setting it for
>>> 		 * each subpage -- no need to (temporarily) clear.
>>> 		 *
>>> 		 * With "freeze" we want to replace mapped pages by
>>> 		 * migration entries right away. This is only possible if we
>>> 		 * managed to clear PageAnonExclusive() -- see
>>> 		 * set_pmd_migration_entry().
>>> 		 *
>>> 		 * In case we cannot clear PageAnonExclusive(), split the PMD
>>> 		 * only and let try_to_migrate_one() fail later.
>>>
>>> While currently we don't return the status of split_huge_pmd_locked()=
 to
>>> indicate whether it does replaced PMD with migration entries successf=
ully. So
>>> we are not sure this operation succeed.
>>
>> This is the right reasoning. This means to properly handle it, split_h=
uge_pmd_locked()
>> needs to return whether it inserts migration entries or not when freez=
e is true.
>>
>>>
>>> Another difference from set_pmd_migration_entry() is split_huge_pmd_l=
ocked()
>>> would change the page table from PMD mapped to PTE mapped.
>>> page_vma_mapped_walk() can handle it now for (pvmw->pmd && !pvmw->pte=
), but I
>>> am not sure this is what we expected. For example, in try_to_unmap_on=
e(), we
>>> use page_vma_mapped_walk_restart() after pmd splitted.
>>>
>>> So I prefer just remove the "ret =3D false" for a fix. Not sure this =
is
>>> reasonable to you.
>>>
>>> I am thinking two things after this fix:
>>>
>>>   * add one similar test in selftests
>>>   * let split_huge_pmd_locked() return value to indicate freeze is de=
grade to
>>>     !freeze, and fail early on try_to_migrate() like the thp migratio=
n branch
>>>
>>> Look forward your opinion on whether it worth to do it.
>>
>> This is not the right fix, neither was mine above. Because before comm=
it 60fbb14396d5,
>> the code handles PAE properly. If PAE is cleared, PMD is split into PT=
Es and each
>> PTE becomes a migration entry, page_vma_mapped_walk(&pvmw) returns fal=
se,
>> and try_to_migrate_one() returns true. If PAE is not cleared, PMD is s=
plit into PTEs
>> and each PTE is not a migration entry, inside while (page_vma_mapped_w=
alk(&pvmw)),
>> PAE will be attempted to get cleared again and it will fail again, lea=
ding to
>> try_to_migrate_one() returns false. After commit 60fbb14396d5, no matt=
er PAE is
>> cleared or not, try_to_migrate_one() always returns false. It causes f=
olio split
>> failures for shared PMD THPs.
>>
>> Now with your fix (and mine above), no matter PAE is cleared or not, t=
ry_to_migrate_one()
>> always returns true. It just flips the code to a different issue. So t=
he proper fix
>> is to let split_huge_pmd_locked() returns whether it inserts migration=
 entries or not
>> and do the same pattern as THP migration code path.
>>
>
> You are right.
>
> BTW, I thought PAE stands for Physical Address Extension and confused a=
 while :-(
>
>>
>> Hi David,
>>
>> In terms of unmap_folio(), which is the only user of split_huge_pmd_lo=
cked(..., freeze=3Dtrue),
>> there is no folio_mapped() check afterwards. That might be causing an =
issue,
>> when the folio is pinned between the refcount check and unmap_folio(),=
 unmap_folio()
>> fails, but folio split code proceeds. That means the folio is still ac=
cessible
>> via PTEs and later remove_migration_pte() will try to remove non migra=
tion PTEs.
>> It needs to be fixed separately, right?
>>
>
> Current __folio_split() logic is like below:
>
>     if (folio_expected_ref_count(folio) !=3D folio_ref_count(folio) - 1=
) {     --- (1)
>     	ret =3D -EAGAIN;
> 	goto out_unlock;
>     }
>
>     unmap_folio(folio);                                                =
      --- (2)
>
>     ret =3D __folio_freeze_and_split_unmapped()
>         if (folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) =
{     --- (3)
> 	} else {
> 	    return -EAGAIN;
> 	}
>
> You mean after (1) and (2), we don't check folio_mapped() and continue
> spliting? Hmm... before continue split we tried to freeze folio with ex=
pected
> refcount at (3). This makes sure there is not extra refcount except in
> pagecache or swapcache.
>
> You mean this is not enough? Not sure I follow you correctly.

Missed that. It works. Thanks for pointing this out.

>
>>
>>>
>>>> #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
>>>> 			pmdval =3D pmdp_get(pvmw.pmd);
>>>>
>>>>
>>>>
>>>> --
>>>> Best Regards,
>>>> Yan, Zi
>>>
>>> -- =

>>> Wei Yang
>>> Help you, Help me
>>
>>
>> --
>> Best Regards,
>> Yan, Zi
>
> -- =

> Wei Yang
> Help you, Help me


Best Regards,
Yan, Zi

