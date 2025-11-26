Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38D3DD10377
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 03:53:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99E816B0029; Tue, 25 Nov 2025 22:53:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 971486B002A; Tue, 25 Nov 2025 22:53:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8603A6B002B; Tue, 25 Nov 2025 22:53:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 720706B0029
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 22:53:14 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0E10016051E
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 03:53:14 +0000 (UTC)
X-FDA: 84151387908.21.8D4460B
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012042.outbound.protection.outlook.com [52.101.53.42])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3EC6440009
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 03:53:11 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JwWFGkSF;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.42 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764129191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kFbpwDaqUX1Wl7rOcJh/umOGeURYgcUSv6WMoiUHZfI=;
	b=PQgJNlPA1az1QUYH7m23R8dmxZqVy/Ag1imS9spzLnFWmT6Fx3O1W9+GMcdTj0pJ395efs
	9/sQg+i82mn+63pkjGP4cmnFSGrWlwNZ5dBdlpx7oQ6eatqYkw4VBpP5aKD1cvL96vRF7T
	WQbcTsE2+8fF7xElnwGRNW9A38QCXnU=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JwWFGkSF;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.42 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764129191; a=rsa-sha256;
	cv=pass;
	b=44OCSe1Y/WyhfLT2HBtMn9hRfkzFs+6QH8PT653r9xzjaLrLaI5yOVbDBZa4VbAWNyGMgZ
	5EbIvJdxKAzOaS7vyf6bEWnpWq4nY5fbFiLarqRC+fK5jwxQg7I2EZbZi5E6KVRTkpEVjB
	2h8MK6OvFCzHD4q+wt13TZ7wvlt1iGY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GxGZ/ybWgmMw7gxIVmeNG6HmtyNNx4Pvpf9IlXBOD6gPnFkceadS1OdrjZbofPOk/YIzhuEPgX1GTEvN4KKKKpWrfBd0z1Pr0LdjLY0WIEcCddXLrSaKWiRObFtZwOGyIcGzcSBpnhrOovhfi/SOb4RGwt1bMzAlbWsd+LyYsX942PDCz4x817ZvhzfjN2DNCejI0t+YFHaAZC7kxFPz6yswZpIJ3UYuv73/B6kURrK4Da0s47uD1bzSg+lhyTIHFfXB7O3sbmBCpuyr3R6w5YKSHzFdF2BmmpBJvmbxbRtcmngwazPkUoOtoUgbvnmJxhufVUk+iOXidYfYlCZYNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kFbpwDaqUX1Wl7rOcJh/umOGeURYgcUSv6WMoiUHZfI=;
 b=C2BTbWwvbgsnlkAIKVlngIV7O0NQIZAhxOKzzuxG08pd5OwntcbHU/Vu8JLFIIVPIsq2dZw4cnhlAJV1Lv4xcU8m0/PGgSiRR2lqUs802urAQFaVFU5Xpwos8BQmwFRCoHKWjbauRMOAG/THkq/brAx49EZbkfABsX55COC8or8NHAyBQsepK3mDa5ozvPP0l2KdxBw8G1MpRgeGx39CDszl8rQuCFuLF5DB61RsCiKisl+WXChx1XHLtIb/7vkdQcvsXfOpc54L8844nyZ/hcsMeL83tIEsu8/YhbGb6bq2SadLPzatFZXXyLIuz04EA1iHvLXtcloZdgYrAqmqtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kFbpwDaqUX1Wl7rOcJh/umOGeURYgcUSv6WMoiUHZfI=;
 b=JwWFGkSFo12NC80v7E82Wbk8O9MjDAaH4gwgais+uSZz4ifIYYU8ExUHTlJAbvlqtvCcLMKQTppQFJqjExDaGTfcwsDsG+TUC/y1RGxQRQoW026gbo8fMEiAtyZb99jMzthw1MVS1K3qj+KZd6M2Q7f+YmKWonf4Ww15xOo6wDfnDvM8qAExIvgYWwn7JVvh56FTmeshbEaJUqx5Rz7gxzzcFCKRwIj9A0taAp4ozuWjl+P97Y5NxYbWvBs3suINduhVPhtZAkApo9ks9ieFIkAMfd9fQ9azaCFw5sEde8IUeTVy5uH1P+3bOLtWBUYL9Q6FYt3rqovrQj1yFHvrvg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV9PR12MB9782.namprd12.prod.outlook.com (2603:10b6:408:2f2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Wed, 26 Nov
 2025 03:50:18 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 03:50:18 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Balbir Singh <balbirs@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/4] mm/huge_memory: make min_order_for_split() always return an order
Date: Tue, 25 Nov 2025 22:50:07 -0500
Message-ID: <20251126035008.1919461-4-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251126035008.1919461-1-ziy@nvidia.com>
References: <20251126035008.1919461-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR05CA0023.namprd05.prod.outlook.com
 (2603:10b6:208:91::33) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV9PR12MB9782:EE_
X-MS-Office365-Filtering-Correlation-Id: 81c48b46-eaf1-4402-c830-08de2c9eea45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UvOGEku2uFVlhzmy6y9f2ZqTX68OJoBoRmwSuCrG23sWQiEE/Px9f2Hn/N6m?=
 =?us-ascii?Q?K3nXhboIrtg+NCwdVxmt7JrgUslUjxHTi0cnrw09LfDZKGi440ImNWzayDIM?=
 =?us-ascii?Q?MPRWTbpE/iiJU9YXoGYZuUo4jrE5J2aRAyT5sdtmeul9sKV3yLtKTnVXazVr?=
 =?us-ascii?Q?wDCN2wik1AceQY2BpUkrIN4+UjdqOZWzuxfdH1IohYsC66KhAUPxiZ2Wg/PU?=
 =?us-ascii?Q?DIcGdeE0ScYNBCePBd0PmEPowodrkEjOuTiRlr8h32Gog/q6UB2WwSWQ1Aui?=
 =?us-ascii?Q?+cXY1wkZ72S763gwDzIJ04VrdxrK5MlGdnOKWjLK2sEawAwoo9qqos8S+YFh?=
 =?us-ascii?Q?DVGCq+BYE2A1O3ZnlHNUfJVlREBd4pqTrFk3ZmbgYFPiJrv1p+b3/YdVaD/P?=
 =?us-ascii?Q?G752Y5BE16Z49B2xUgqf+7a0Q3Iv45P90x27Dr98wjSz5SVzeDbVC6XrY2Cs?=
 =?us-ascii?Q?jxqUOTvQ6BrqOfiHn6jbcww9KqlIq9SP9sivRebvGIfIGzOYVA0DwXrMf+7N?=
 =?us-ascii?Q?KWazwrnlqmOMO7FJoNBAO89kyeaKhnRQ5AdLNq98V4aobEMLOH7HIZGixScD?=
 =?us-ascii?Q?OOriiUzilTcBMgMCMDnCdSBFZ4tpfzMU5stL8jBom7pEy9s1aAj8VunC1QDc?=
 =?us-ascii?Q?IEIjn6+sYO/r/kkgN3/U7DNmcogwIj2pJYoNMo757EGK64R1szqC56gJwn+H?=
 =?us-ascii?Q?p7OzAUW9sq3esfTCZXBpQ2kjuY28ykfjvgmHB/yLaszk9bV8+At/r9q2YBwi?=
 =?us-ascii?Q?XzNwh4wVP+Das+IfX8sPGT50wsro0vqSFb4CamKH5on2sGpWPJqx9XJpbDq7?=
 =?us-ascii?Q?+VJkpZ+Uo13ZaP0xHNeJWm/EgQl4zoygNXpZ8T/PcuzRqOZ2DhS7DjKshmUH?=
 =?us-ascii?Q?Ah4yqxL1/605eb3pw9+9A5OMSfKyJcGqyWROhPLRUorAp99VPyA3DAr1YKip?=
 =?us-ascii?Q?AxNnpkWFKawEaR2fnJR8FkVDP+JMtnM85XCRNytmTPfbtyKrSWZW3uOZyEGX?=
 =?us-ascii?Q?LSnsGikHApI8liSNzrEiL/pMBDKfWJoryjcPZ4HEz3wO8oa8QRG4HjBeCgci?=
 =?us-ascii?Q?eZd4iE89m7e5/6yc5Qtic0V2YPMFvKTCkSsdNfpH0kvHg10gLp1ZU0TcKDIy?=
 =?us-ascii?Q?YrEckBBPCrWsw+VsKAEnA0I6q2scIBdcHgPNFTq7Hbp3nscaN2mrOBgEW8T5?=
 =?us-ascii?Q?R80TGTpYsU8/8IZoF+I7QPBIA2mD41bNon7CJdfVVwWFA5oFNBBob/nRsTGO?=
 =?us-ascii?Q?u1FJAM4umnHYdK1Xada4LFfr9IA4MepXGvS5E0j610rDBKcEo3y/8CME3tzV?=
 =?us-ascii?Q?PNJ78zpzigApldNLYSdDZaioyCFeTlFCUauvC+9hQDWDTlfVxPbOebYPAR8n?=
 =?us-ascii?Q?2BzBZcMRoNzo0m8M5Qz0iw02j0eUoapZutrJ0JJjpBPAXf0new3QKTfTLO8+?=
 =?us-ascii?Q?mXh46ic58Lu0yGpfgK6Y/Ob3uP3Sg5X/?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4k8p/Yni6T3EHb0IHSHY7THvWUGAsUAGmBOt7yV1YIppkygyxMkJ/gDS5Gp8?=
 =?us-ascii?Q?utVzDaD4jUz+ZgNr56Mo4KbSVojaj/RL87VrDN+T3nhRQ/DRqFuN7bNGa8P9?=
 =?us-ascii?Q?AdWp+efscCrhC7pjUMjjLnI7LI5KIvUGswNXyOsgia1IDYjqwKzyDAwg4LAu?=
 =?us-ascii?Q?jQ8KXGjOkttruHM8xzT3KPbf1e5ooDcTg/P78grcSCCaTKzDxkxbbuJ1U+32?=
 =?us-ascii?Q?glqQQoR2yQIpJAvBHV80rpa8rSCX5hLQ2InVzJy+SBCnjQnwlaBN26tM/Mvs?=
 =?us-ascii?Q?y+DrEOpCt4g9lyecPaRkMG6K3A2UKWJdac2Gzwx3Zfq9jUcJWdeBT2v3vhrK?=
 =?us-ascii?Q?ilGWP4YTJMl4WQhWAvvOZVrq1Sss8VFe9fC7gDuXTFokldlvd7n1QtJR29AT?=
 =?us-ascii?Q?ejwJZMFoLha147zEahN36O7ExOeLFVWveAUBxvW3KMe4toaBlN9ROxc3G2Mo?=
 =?us-ascii?Q?DDu628GIvZQM5BZgDUVpGU/LxYkzQ5zqqfd4XoUg/k6DlnRDhgti+I94k4JC?=
 =?us-ascii?Q?oDPoMb1Hh3WfvYCwSVFGuFZrJapCenxeIDpwH1jk8WF5jxAIU5wGF+9pFZJc?=
 =?us-ascii?Q?rgoAWN8JocFxT/I+O5diPEAXiyjrQDJsvpi3Y8Cp/k8e478xtRLx2sYBp1Fm?=
 =?us-ascii?Q?BultR84ynpKl3/w1llbTa2Dpd/E9HW2aSkQR2Mzpal1gV29wNpXFftVNg8eD?=
 =?us-ascii?Q?+byY6fVf+IvNOKAniOM4uEkEfGfx4wHLpQp2dI8KWtjHI89O89TKuFle8Ukg?=
 =?us-ascii?Q?VKJEXJvG7dpjwiM+OIoW0kiQp2xQmDSj5NPeJntecs6A4Q2G4ohnw31Iw+yN?=
 =?us-ascii?Q?NiMFd6fIkXkw3DvxKLQlw+XkEGyXkP6T+Qn0bGK35ligq+nxSWjZaAA0KcfM?=
 =?us-ascii?Q?29MQAabE+PnRLYEkKz9NGnaC+cH4oy66uSITq2RKm/vSUc96JjJLqRqAs1kK?=
 =?us-ascii?Q?OhukWwVi9s6aNaeuy4YFr4RBvGVL3HG37PnfqI+eEjSG0seu4o14F6NpCHgz?=
 =?us-ascii?Q?QNRU8Z7e/rY60ZJVfaU1bWX223WfWqdUsI4rRsd1t3I73Mp3sDZ6AbbaRwST?=
 =?us-ascii?Q?L7Lj6XHS8O8vJ1plzlGa6W5kx9Wnhe28AAYZ21jN6IrOD2pHBopCeD2IqtlM?=
 =?us-ascii?Q?qzMZ44N9KnZtb8DxiU/3BHsrm80cgXqMfU8gFwS8BIBYsMiceT9IUclgehF8?=
 =?us-ascii?Q?fM1hFq7MpG/r9SIy7lMd8/zA08FUED3jhazDlLPmacEwPfuEg4cikoMImqAt?=
 =?us-ascii?Q?WPY7wRIlgcJnbSHcuah0nZ42oIZvxNxV3yUprpaMNIKX/0EPSpQxZE6kxHTe?=
 =?us-ascii?Q?pmcNoSyq8DSReCRp94MxuJpKySaadD8YeEuY0kjPAN7e8xZ4HEgz8osWCWNB?=
 =?us-ascii?Q?mHNoQMveHDf1+tpYB/8vj4u04VXMRgXjMcwuaPGw0rPNjzwCJAg4XY+LP0Ta?=
 =?us-ascii?Q?i016drstW+VFlF+3j4arxHCK0jpSokjpNzEpSrKEAkTC1HIxRdQi1nPoDZ2K?=
 =?us-ascii?Q?EsH/RLK4IZWUmjx7DRc9DUqnXNnuItbumzxn1TvqjrMeM88TU6lJCZuGlh0r?=
 =?us-ascii?Q?j9r+ws3yoSSI0UZoGr6ZSUJUXA6xuazDehZVfatE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81c48b46-eaf1-4402-c830-08de2c9eea45
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 03:50:18.1146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m76J2xqf2hQc8tnwisWYLfXq9o+iGGTjftXkB1vVMD6HMdy0X+u+vf+Mi2SxX2bk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9782
X-Rspamd-Queue-Id: 3EC6440009
X-Rspamd-Server: rspam02
X-Stat-Signature: 7815aixcb78u7gmtjzkmqrmipfue9jea
X-Rspam-User: 
X-HE-Tag: 1764129191-12505
X-HE-Meta: U2FsdGVkX18XzrVG7xX6KILMfrtfzd0eiSCM9/PALmp0INBE2dSNIQMdGH2Q33iFxB+dSXtkx95Lc3z/Maw6GEYnthT81xijeHu84nnHc/OoyRh6fgmB0kSLgTtSkEm2fKYHH9Gz6moFbqCnCW8UzJZRhn5lIIyTWz7JyD6f/ttQKj4ZJClcKDdULUR2C5MTvA9nFbcsBxknrJU6xHgcr61391ipxJpc4P71Lbbm602NkzbSXWyyti6asbV0Ae+S5JCtiu6a2xC8mRZk7iU+Av02TbhpT4CVrtZVRc5zImUJ+jnr5fpR6+W7hbGD9m9KKZO1UnpA4/CgpAUT2HFETCFoXQF42W6I9xI+7uDnREo+R0kfnj2xH3H99PmSrtWKDpi+f/KHcjXm0k1IeopVTup39qK+hFCAGzPMN/p5/KKZQ8xFBoWenFbfLBjhlnMaPaKq/R0XVBcqMXtM9hIZY4HKlyWEKhWcA8m8qneKGam21QwwHdDEMJNTT+y07eaAFzWizaBoYr4repXw0Sqtcddu+ePd1WL82xSPzDF18BUwZwFifonTb8hl4x35syxK6jaekGByEcqu5Mh5SzsmZdWN4vwWUUheFkozVG5L9XK8mnQ1X4ej1+lbgA7TPq95xJ1vio65LAnTNGLcCkN7L0MU4PV7HG9D6KTSHMb92o3oMJEIRxlKJ5wgu48YjMhtaDtsOeF6cz6mVhRGqTKsKNS61k4RfFsxhttFyKJ0xfAgVU1wK9cSbqbzmoquVS/f0siVKRo7JGfnD/prPchGJSsmqHT58v0uWT3zEIipPo3gkxbAms2eJpS1AbkyICr0LWGhSV5lbg38nYbnkS4+Wx4glI6qWewdv+nUa9O2cEdThG1REb7nNUstvgAlI/eUmmnfW1v3OF0ByRd/BZoPwO44Xijmc8Uu7h4RPVy+yyu96yC3qolo9q3y2kjAwMByyNB2ZRXoinsfTATeHQi
 9dDw73wn
 SBuapcj9l3XuLRCozD2Vl9E2dhQkoNmx07/76jJ6gYqYHEnsp6cCmUadpeEQ3Rk46pIsEz3IJRcHS05WNQ7/6CYwPNQdv1yS1ZbguGKTBcCYYgDb3WPeXNSMS3E68fV8iCUM9bWBej7lfcZiXZMl2X4bz4zGi+OrBbeLXeehF3Rb0EecNXWC5r9wH6xs8jAIJEevO7mPMic85XxF4k0GmNGSvlIrXHW/K1DsOtoPqYcfXGohJvN8SmLQGAnI0w5WC2z84V4yZmvcLlwnkKYcgQZfUM//SuXeC91BHuASUq4YqxWtIA8nMWup9j2qsU2ZgvQPtgjKMz6NO5mnXQJ6j4efj7+2/u3R6NtzXWbbI3cIvHmjEcK+G0riQbPa6oAZXviTq8ZtCOyOjCy3Gp5E5e1y11nvq528JBw1BqtfCiuka5kpzvO5qejOzaHzKKFI9jIyxMHQspM7XC16wMrp7aLL38n/wooNTY5+DmsZRRKf58ymXw2GJySN7oos9RZKAYSA6ug7dPmaaIFBvQQoas5wKoOOsrE1jXzgJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

min_order_for_split() returns -EBUSY when the folio is truncated and cannot
be split. In commit 77008e1b2ef7 ("mm/huge_memory: do not change
split_huge_page*() target order silently"), memory_failure() does not
handle it and pass -EBUSY to try_to_split_thp_page() directly.
try_to_split_thp_page() returns -EINVAL since -EBUSY becomes 0xfffffff0 as
new_order is unsigned int in __folio_split() and this large new_order is
rejected as an invalid input. The code does not cause a bug.
soft_offline_in_use_page() also uses min_order_for_split() but it always
passes 0 as new_order for split.

Fix it by making min_order_for_split() always return an order. When the
given folio is truncated, namely folio->mapping == NULL, return 0 and let
a subsequent split function handle the situation and return -EBUSY.

Add kernel-doc to min_order_for_split() to clarify its use.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/huge_mm.h |  6 +++---
 mm/huge_memory.c        | 25 +++++++++++++++++++------
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 8a52e20387b0..21162493a0a0 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -372,7 +372,7 @@ enum split_type {
 int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 		unsigned int new_order);
 int folio_split_unmapped(struct folio *folio, unsigned int new_order);
-int min_order_for_split(struct folio *folio);
+unsigned int min_order_for_split(struct folio *folio);
 int split_folio_to_list(struct folio *folio, struct list_head *list);
 int folio_check_splittable(struct folio *folio, unsigned int new_order,
 			   enum split_type split_type);
@@ -630,10 +630,10 @@ static inline int split_huge_page(struct page *page)
 	return -EINVAL;
 }
 
-static inline int min_order_for_split(struct folio *folio)
+static inline unsigned int min_order_for_split(struct folio *folio)
 {
 	VM_WARN_ON_ONCE_FOLIO(1, folio);
-	return -EINVAL;
+	return 0;
 }
 
 static inline int split_folio_to_list(struct folio *folio, struct list_head *list)
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index cab429d8fe83..3d2396bf5763 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4221,16 +4221,29 @@ int folio_split(struct folio *folio, unsigned int new_order,
 			     SPLIT_TYPE_NON_UNIFORM);
 }
 
-int min_order_for_split(struct folio *folio)
+/**
+ * min_order_for_split() - get the minimum order @folio can be split to
+ * @folio: folio to split
+ *
+ * min_order_for_split() tells the minimum order @folio can be split to.
+ * If a file-backed folio is truncated, 0 will be returned. Any subsequent
+ * split attempt should get -EBUSY from split checking code.
+ *
+ * Return: @folio's minimum order for split
+ */
+unsigned int min_order_for_split(struct folio *folio)
 {
 	if (folio_test_anon(folio))
 		return 0;
 
-	if (!folio->mapping) {
-		if (folio_test_pmd_mappable(folio))
-			count_vm_event(THP_SPLIT_PAGE_FAILED);
-		return -EBUSY;
-	}
+	/*
+	 * If the folio got truncated, we don't know the previous mapping and
+	 * consequently the old min order. But it doesn't matter, as any split
+	 * attempt will immediately fail with -EBUSY as the folio cannot get
+	 * split until freed.
+	 */
+	if (!folio->mapping)
+		return 0;
 
 	return mapping_min_folio_order(folio->mapping);
 }
-- 
2.51.0


