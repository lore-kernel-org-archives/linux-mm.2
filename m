Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD575F31E50
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 15:55:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53C496B008A; Thu,  9 Apr 2026 11:55:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 513866B008C; Thu,  9 Apr 2026 11:55:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 403356B0092; Thu,  9 Apr 2026 11:55:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2D5766B008A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:55:57 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C5F7CC28DB
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:55:56 +0000 (UTC)
X-FDA: 84639468312.23.71D471C
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013001.outbound.protection.outlook.com [40.93.196.1])
	by imf24.hostedemail.com (Postfix) with ESMTP id D4738180009
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:55:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QYWNrOul;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.1 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QYWNrOul;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.1 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775750154; a=rsa-sha256;
	cv=pass;
	b=NjwXeQW37y88yxPE5yxdVW/IDBsXLBw2YsrXOVEamlRBvicncfXhE4X4Jq/wuBh9v+lAkh
	4diYm0yWlHodb7fAhS++DNXLrH+bQvbub1CDm2hY2FGozEJcs/dh65vCJhakt/FFPlDThx
	z4Zg6046/FyTuXqK0gH/IVzQaf7z3HA=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775750154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tbM0ncujsEEBz8dMmG3cNM4oLK7FlsIiJjC/rxV4FhQ=;
	b=ZSi+a4LQQcMTTaytkJ2HOXYI9E2NeTSTHRizUqDx1dmfqXSCq9qvwPzQcHq2XDiw28bkOD
	v+PbEw6DI0oUUZsZziqqoxYpQQTteHKITxzHGG2zULsljHGbeS3zu98DVEq6lzGnpKS4vd
	rZgau2xLwNw20ErqD6LJvYNtiUWnOPw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UKQPSKtuzJI+hkRQAAyVS1JjOdcL65DhJpW0BU6vT0pczE8xlrc1+h/m2ivNp205+WV/cyVl6tKRxjCSASCUf5/NtpQfcC5H62tRIzzrdHDwGZ0VCOTvoqyOBYSU+/hKm/W2e8PTY/+ARBDjCGarFJ+R22TiTTGOQ4MjXMhwRMyTQ/GVwZJDgOge9FLkxgERcLB7t9/jlBOkCqn5OO6nJ8rc464Iw5jeUJ/lxiGm7hKivGr9X34Z3m5q8SejqCzK8GNnXMLVoij7guczCussjtlM4wnCMvTQAQ0DfUdx0mLLx42jsuJ9wUuBllWZYMz/NmS08OqEKPVFtAW/11bclQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tbM0ncujsEEBz8dMmG3cNM4oLK7FlsIiJjC/rxV4FhQ=;
 b=XOgNo7zAa8K/8naDpV2/mrM4FTDF5clQ7w099/QFUA9yOcFAqUOhyKhR9ZV/SuBB7U+CY0FF5BpQO3X1834tcly1T6tUUsQthctp1UG/aE5iftwa5g1/EU3osD30mJOtE67GzAJzdWh85UZfIMrPMRxH2lBUAnmMgRfE3PUAZvDpR1uKs9KcJzvCLT0RRKHae+hWgsKEobIyzwvyXpZZZzxXCCUfF+dakuVx3tTfTRJrMRAm626Ysd456y0J/MbFYXGkS13tlCvSAjxrFzyE6ddkCmeUDV/sPXu39c8awEMHW3q869nQk5LBN0luaX/NibbWfzgi3KhBIlaf6JdEeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tbM0ncujsEEBz8dMmG3cNM4oLK7FlsIiJjC/rxV4FhQ=;
 b=QYWNrOulIprUpx7xiDx03rt7bA7PU698y5Lwn0J2GD18EkJ39FWoNlZ3eZFOjC+GG5HVd8qSWVcyPXiQ4z9cjNNOu9lClJnPTD/7obcT6dgEVKFqQrcm9gmaFBV2y669AqL7DVywZJ5bf6OebDPD63w8vJ977xVNBh1ESPhLYoLGqHl4n3cKTSdLCyIKiuoTRdd1PdZQ2b2m8dd1F0h+RlTNDKL5eCCOt5DezF4xyzdOSK9yzKNwrfyuiZcme9xZZVQD5WsP1g3jTwKNLp6h6Y2SA+YIIPRevJBoYl5idE2upSUuBAOIgq5S+PA6o48UMbG7tjll1V2Spa21jr8jLg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB7330.namprd12.prod.outlook.com (2603:10b6:510:20d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9791.32; Thu, 9 Apr
 2026 15:55:49 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.014; Thu, 9 Apr 2026
 15:55:48 +0000
From: Zi Yan <ziy@nvidia.com>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ryan.roberts@arm.com,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com
Subject: Re: [PATCH v3 09/10] mm: thp: always enable mTHP support
Date: Thu, 09 Apr 2026 11:55:43 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <772C4431-FA93-4477-B1CE-3BE5EA97FD0B@nvidia.com>
In-Reply-To: <6dea717fe8c86003e7da33c9a7623b834649d5ee.1775679721.git.luizcap@redhat.com>
References: <cover.1775679721.git.luizcap@redhat.com>
 <6dea717fe8c86003e7da33c9a7623b834649d5ee.1775679721.git.luizcap@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: IA1P220CA0007.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:461::17) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB7330:EE_
X-MS-Office365-Filtering-Correlation-Id: 00329165-6faa-4436-9f16-08de965077a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ZUk/phD0mrcHhccxvbbJhPa4yyRIpPMja8fRlPj30IFgYXDWxnBynEOPUog3/neMSlRmLQwhmKv8j1feSmd1wAx6fBFM+LapPPA3nqHmCcvUxfgn9rqzYXWvdXaCLvfoViUV3EkENb801DQnGR/CmasJvJWWkIu9SBAuQ0kg+D3bmVc3moZ7jTGihDBS88Bj+9tU92vHMqjRfzfAHEvbCjK6KkE9lI4DAFFOTi7vnqbYafrHojTZY5mNWzgVJBM9FOu1mMUWSEZ2pRPQJDvrbptV8sezJvtdVBi2LlzZNOEh2I7vJxUDGBr0xCjasF35asKdilwyjF3DI/gCIoNm9jDyDUG45EUahRpXrytQ2PZADzWABqVKNH5oiSsjBeMRQwMvERRYpsagksVBEC9tBE2jBAv+GK9pmT+gxuNSjx7s+8rig/vgqP9undp8O5oVfGTUpxRP8+uIiPTArLJBRsYcHFJnwvyghzmRAE4kBoBTH8wgphs4nFcBqtxtExs0+gJflNSg41WWERzWGfQls89mQjfRedVOEcvuSl/BloEdXJEAPj9N8KJT3hHnunxX1O2dvRzRNmadfz05IqWASGHFWKcB6NMl+81Ur9Jf/IR6qiEJ2tloCVg6J4K+DQfbqbyy8K6CmK662lloxeQelrs/Dq6ggR4Lz0w3jOSMcz2634Qn3UP7Fb7m3KXdEeMDqQd3dWaywLHXITPvdBhrL9jCxwY7r1YG0K9ypYlO5yw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zaUXOHvdsl1CcoVCTaWZ2WwRcBUP6/gSuL5D1qbAKpr4K0VGU6ok+fRkw0CV?=
 =?us-ascii?Q?ROmxPsouqUKys5/bOrFr9x/UzwDlFtRQYEDE1pPrxxyYvS8N4FHM+IEPonPP?=
 =?us-ascii?Q?ToE1AHII8z/YWeuV+W5UuB/No7Orwi0+6lWdVGEcyEAEOcah7pTw7xPTMtfP?=
 =?us-ascii?Q?UyLrvGjrNj+wnXeH5IoFnq0dAPvjqDE+LMl6JsLNz9ETck9mB4eQHhwdhaeW?=
 =?us-ascii?Q?yFNnOhe8aahVGvjAiWRDR53f6DNR+05hvzFGrp0xugU4sAIM3cU+72GreUoy?=
 =?us-ascii?Q?tPeYEHLhFvKMRl6GMHloZ+dvScQ8QvQtt4nnsbkmbSqj+BscftwqMpiPmQ3O?=
 =?us-ascii?Q?67JBvK1rZI71XpaMQbAbO1k4ixuXY3efLYxo0RK/R6+ltLxHQX2JBDvUFn4/?=
 =?us-ascii?Q?gc3baBIhIIlBdGR0WNEqZy1Sh7ib5YxcyzOTsGl3tfvy79VNod+hvlSIFUht?=
 =?us-ascii?Q?O6/bMkb4+D4Du14AxrjdrqsUmA+b0n9asHNlTAToXzz1lEkeG5qf6qT2wP8n?=
 =?us-ascii?Q?OEF222tsEpY1cht5+FZYzpgDPvFRawkZ5q36NBi31hKdKL+NHuJaep93WIxq?=
 =?us-ascii?Q?CagaiFI3myPzFtm4d1SxuQ7NntAXLJzFU8tsoqN4rDcbTxFKR5EiCAZrGnl/?=
 =?us-ascii?Q?mQXsKjJ8OryB1Om9DBdEOIBxOVRTDBWJEyWCyXg7V4nDqj/VvBZrwueiAeZl?=
 =?us-ascii?Q?XA6l6XBfclzvoj+4y7c/oMutYNIVh66tDupJpYr3LGjY0mG2lckffssq218m?=
 =?us-ascii?Q?N7GXG9d2n/D95vn78M2oKjtr6E8EO3dPkj+ww20RjtAYEeuL+jgEDLSZK0zy?=
 =?us-ascii?Q?SWcgr2rFkw1rhjx3dadnGhlJjSeMlEwGyYj5SmhPtF3z+Xfn2950untXzVtU?=
 =?us-ascii?Q?EMkaGf/b6TZ3qybSZPHYeaFz6JoJZwVMz/JLspnJ7XF0/o40HlFmO2S9syVj?=
 =?us-ascii?Q?uF48u0+OTKuyHCZfRLemyKyAT10BTSUAvteLL9ZsMHgpU9OLo7uSmSwj7jZX?=
 =?us-ascii?Q?XlRecsZiGiX8EF9FVMQqUBnFgLAWBlNqyraoqKnE8+1uztVY1mR6vEFam8iO?=
 =?us-ascii?Q?ZP3jqP703XL1ZV3lycWa1nAIP+qFy8LXICGmG0MweKmpIAG8QhHfi2qG7vHH?=
 =?us-ascii?Q?ZmylA6+uh7bi4GBnhA3yD+paJ8dNPjr6uEngU4WdFt4lOXwzpktI/GlSYBsA?=
 =?us-ascii?Q?jaJGRndhL32QvicxJUj0ztUYXn3KlTyGGZ+ecsHJSU684Qj9YAF2SznngSuy?=
 =?us-ascii?Q?fBObpcJ6PKc4BpylJfeLERDKMZ7xkCbSOfn+CI+RAmk/65VVljuMLrNu5x/G?=
 =?us-ascii?Q?yzdliusYJZPlEhbTxLo35Sb+6g3JuV6sZ7i3hqCIfYgpDD9UndjKaDPvJP6x?=
 =?us-ascii?Q?7SLlk1A9q7ieja67SJ4AZ2uISgVd2XtVDbFaOMfA3BUFOLqo+XF2EbookNT8?=
 =?us-ascii?Q?k3FqmHlmzg8Yl0eMaSUhx5+zrX/zpmNiVpPCyqloY8XBy4yv9bA/u9dXmtfA?=
 =?us-ascii?Q?rkdXW04mndohO07qO2TzBGYLJFJswbA+5RL8np0S70ZkqhjBvHr1RaM0bMmC?=
 =?us-ascii?Q?zfo85npzeEXnDocEkhZlvNP6ktZLMyrn1GCfrj9ZebCjgdSVXagDvP+9ECdO?=
 =?us-ascii?Q?6YTOV/IrxrRbxA71hPfjCdFy7U2eaJVDQA5DZaP4YpxAoh3MNHmasY6/jVS3?=
 =?us-ascii?Q?2DZqJhstlwaLJ31w1C77s+aHess4N6Ks4rk3tccXkT2PD4qxYNbeAm5Y21Fj?=
 =?us-ascii?Q?R+KmDfeJ3Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00329165-6faa-4436-9f16-08de965077a5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2026 15:55:48.4831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NhsS3QN8pJQ++4zkxAjLQO9zIdnDPrsCNyhC+UdaIMD8eavjFxeUulVt2O3c2oGD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7330
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D4738180009
X-Stat-Signature: f54c1txbrag7dgja4ru7im9orqk1k6pa
X-Rspam-User: 
X-HE-Tag: 1775750153-438660
X-HE-Meta: U2FsdGVkX1/cdwiYuzATbXzDTUl73O0hwAZDt7iLsjwDx59CXTu/N8wqbFzF2mKpMWneDiIeelxmWvGakBkc2YYvyefo+DsbsFRBrETlcuZz93vYFzCs7W2tu9h6JCNi1PbT9EM3G6/c+JUXHXC9SRwGuLeLLWLZ21VzNQqAnpk0sidL2PArY68yXcYAmZYUBb+sv+ZyaLcRZz7TZtRdNsfQ+V66QyZwHzHxdSBfjdZ6GLQeZJvoFAAhY6jqjnAr6E0/RWjmzpT1FJQaJwO43y0p1/6jgNbg7BAFKf5ZpmcDf4P+euby6DYuiTTraSRz6ueSMAui/0mp3iF/iTmw0QkbxcqslTUqGsOqPTIyWlP85UOGhD2zGZh3/BnwuzeNzNvANm/BqG7hHlu/Wizo77OensgzsUmewVMEDISKUD231MO587lX00ixujJMPBlquy5+J5g74USG9dSyiWR51aQtV95t0/6ab1D24VHubqwBBPDV4o+EpFXM7Tc23xipdUK5H4kSnN86efWQI+l90OMnBOqgmXFoX775nlEYuLubvkbs7vs3Ft+IJZUj9iTrNh3yj5uGinaAGMZVj8L3Hv2SLdGJ7+nPaVwVfmmCXzXZypLTqSnsecr0OnXV/Wt2mQi4T3647tjmNxTE3yZrweFCqu8VI3ABwcFjctiNjgIRaftQ3Zjd7BTErrqsmCjoIG4Z48V984G5tCax7Qo9WSHgXWnZ5rBSePrWBleWhTJSVJL6u/f+LxcF+H8nS1kc8r1SqisyadPBj9Ui8o4V3Vp1ZUODkY+ROAN0aAOV2gzNbRNg3PO6undC0Cc0mkkfulXBqhKocfQzAwp4sjCDBM1tHMf23F44eipRJOq9RF14YP/onPNIup905fCx3Pn4flDS6HfWzpEiU/oX9yuNfd8PRW6Zoo2CwjokegSl/Oi5FEIY3RanGUQPHuE3yV300GoHorIZm8WQQi4ZMiK
 ltba9iVM
 WUmhiffhiG6qT9TNewCJxLYg1gjAgbVn2GLxZXmkZpGPbrrWLXNKaQKdFOA8g2FjmP9adQZsRjOPjL2PuF2QIY3lN1mvHsexoyToD4140wlhKm0ETDBbnoXsr/dg+0dZ4e4Hv90WpbjGqoB7C9gMCnyc1lC/7cQc/h6m7VOckM1+flJTQlKKgh6U3WTG6CQ/KeQYq+UZaQaJa4qUdinYga7D0BTXZYG5/GUDkPy2/+l/bSHFA0lvCCPWNPk5SEZKBxgtOyhddwjNfXBWXZcsv6/d49WntNH3Vjwp9yB9kEJCuGwQZbQZEF64T2VyhBl89YYU0pST92yGqlp8GfGRxoth7NQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8 Apr 2026, at 16:23, Luiz Capitulino wrote:

> If PMD-sized pages are not supported on an architecture (ie. the
> arch implements arch_has_pmd_leaves() and it returns false) then the
> current code disables all THP, including mTHP.
>
> This commit fixes this by allowing mTHP to be always enabled for all
> archs. When PMD-sized pages are not supported, its sysfs entry won't be=

> created and their mapping will be disallowed at page-fault time.
>
> Similarly, this commit implements the following changes for shmem:
>
>  - In shmem_allowable_huge_orders(): drop the pgtable_has_pmd_leaves()
>    check so that mTHP sizes are considered
>  - In shmem_alloc_and_add_folio(): don't consider PMD and PUD orders
>    when PMD-sized pages are not supported by the CPU
>
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>  mm/huge_memory.c | 13 ++++++++-----
>  mm/shmem.c       |  4 +++-
>  2 files changed, 11 insertions(+), 6 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 86e489c0a150..6de3d8ebc35c 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -118,6 +118,9 @@ unsigned long __thp_vma_allowable_orders(struct vm_=
area_struct *vma,
>  	else
>  		supported_orders =3D THP_ORDERS_ALL_FILE_DEFAULT;
>
> +	if (!pgtable_has_pmd_leaves())
> +		supported_orders &=3D ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));

Why is BIT(PUD_ORDER) also removed? I thought PMD THP support and PUD THP=
 support
are separate. Here the code implies PUD THP relies on PMD THP. Is that th=
e case?

> +
>  	orders &=3D supported_orders;
>  	if (!orders)
>  		return 0;
> @@ -125,7 +128,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_=
area_struct *vma,
>  	if (!vma->vm_mm)		/* vdso */
>  		return 0;
>
> -	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vm_flags, forc=
ed_collapse))
> +	if (vma_thp_disabled(vma, vm_flags, forced_collapse))
>  		return 0;
>
>  	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
> @@ -787,7 +790,7 @@ static int __init hugepage_init_sysfs(struct kobjec=
t **hugepage_kobj)
>  	 * disable all other sizes. powerpc's PMD_ORDER isn't a compile-time
>  	 * constant so we have to do this here.
>  	 */
> -	if (!anon_orders_configured)
> +	if (!anon_orders_configured && pgtable_has_pmd_leaves())
>  		huge_anon_orders_inherit =3D BIT(PMD_ORDER);
>
>  	*hugepage_kobj =3D kobject_create_and_add("transparent_hugepage", mm_=
kobj);
> @@ -809,6 +812,9 @@ static int __init hugepage_init_sysfs(struct kobjec=
t **hugepage_kobj)
>  	}
>
>  	orders =3D THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_FILE_DEFAULT;
> +	if (!pgtable_has_pmd_leaves())
> +		orders &=3D ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
> +

Ditto.

>  	order =3D highest_order(orders);
>  	while (orders) {
>  		thpsize =3D thpsize_create(order, *hugepage_kobj);
> @@ -908,9 +914,6 @@ static int __init hugepage_init(void)
>  	int err;
>  	struct kobject *hugepage_kobj;
>
> -	if (!pgtable_has_pmd_leaves())
> -		return -EINVAL;
> -
>  	/*
>  	 * hugepages can't be allocated by the buddy allocator
>  	 */
The code after is:

MAYBE_BUILD_BUG_ON(HPAGE_PMD_ORDER > MAX_PAGE_ORDER);

Should this check be removed or only performed when pgtable_has_pmd_leave=
s()?

I do not know if there is a possible Kconfig that lowers MAX_PAGE_ORDER
below PMD_ORDER and enables THP. After this patchset, that might be valid=

if people do not want to use mTHP but not PMD THP.


> diff --git a/mm/shmem.c b/mm/shmem.c
> index 613393eae5a9..b49a30475cb0 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1839,7 +1839,7 @@ unsigned long shmem_allowable_huge_orders(struct =
inode *inode,
>  	vm_flags_t vm_flags =3D vma ? vma->vm_flags : 0;
>  	unsigned int global_orders;
>
> -	if (!pgtable_has_pmd_leaves() || (vma && vma_thp_disabled(vma, vm_fla=
gs, shmem_huge_force)))
> +	if (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force))
>  		return 0;
>
>  	global_orders =3D shmem_huge_global_enabled(inode, index, write_end,
> @@ -1947,6 +1947,8 @@ static struct folio *shmem_alloc_and_add_folio(st=
ruct vm_fault *vmf,
>
>  	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
>  		orders =3D 0;
> +	else if (!pgtable_has_pmd_leaves())
> +		orders &=3D ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));

Same question as the first one.

>
>  	if (orders > 0) {
>  		suitable_orders =3D shmem_suitable_orders(inode, vmf,
> -- =

> 2.53.0


Best Regards,
Yan, Zi

