Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B46BFCCFA13
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 15:37:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08C666B00A3; Wed, 29 Apr 2026 11:37:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03CAA6B00A4; Wed, 29 Apr 2026 11:37:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6DC66B00A5; Wed, 29 Apr 2026 11:37:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D838D6B00A3
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 11:37:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5727C1C04B3
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:37:16 +0000 (UTC)
X-FDA: 84711997272.17.FF4E4C5
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012058.outbound.protection.outlook.com [52.101.48.58])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7E482180010
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:37:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="M3f/CyU7";
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.58 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777477033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QX1aU4EqwCBDllByOfhSxQpUavRQJsNTqcPvSiPKQwc=;
	b=Q31nQPDGav8ZDX47Z8KFzqtwpzo1gu8/kr/lD8ftM7YaNi61PReWRJ3q5X26OSeysVkCtw
	RkUo9vYzgJs9kC/HrObAmbGjrfdWayWLDJTUadJgEY7O1xxomd8yaNcOpKHxJjF6lJ/1wo
	0LZs69BXGKtE+ONUrfWjGek3Yy7Me+s=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="M3f/CyU7";
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.58 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777477033; a=rsa-sha256;
	cv=pass;
	b=4OipmHYstX/i+6DUxMSBgezZolIWh58FFnvnjUxkPgbjWToz29FFEKz1gagwv9FbG7K1NA
	rsCaID+yEFXlk6j549fhMFceEi77I1H+A7q+PtFgWIbUVqu/AlMo4qUW4z8oSbCQpSIoap
	2Beg1aXyOGcn/JZWVEmZgkgXvPgvD/M=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oJzl3+5hMUrTgb3uekzM+l2cuefxLZ/BlzfCOdS3SjASiEr35Ei+aHIIjmej/8en1u1ZTsCwPeOd3NSKCTKv/yxOZNJEzRcooH0kpbHAnocu5J/5O9HrbY7VOkRLvM3AifauUD/BA1QqewedIzmvA5q5GuEz9KGX8wMynFP8XKG5UgY269dOmzg1IqqFahi4T3qafchee80Bc9svPtgGLUm/bN5imkWgJtp/sS2logPKQVfmPQtyRbsd2JfV+oOhmD0K+pwc1Uz946M13YtguABcUDZ43sIMwH5XqoNFQ/xaJ954QK2qco15hQ+C3WTCWTBa32jhZ1ZEeozWZ1aa+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QX1aU4EqwCBDllByOfhSxQpUavRQJsNTqcPvSiPKQwc=;
 b=lO6hLsIDBvc6pbfoF78e1oGzkPBllqlUpG7tc+Hpx5B7y321zZfUnwD3VKllvh+8LMVFUE9wrdTclEPzIePj6eiDubynyOIfyfaPmsV6hQZJ5hZnmIxasVMyHvSi6It7ApSAWxzGHs8snvbHdmgrJwnjRteX1hsZHkY9t2aLG/CZoA5TF72HgUSmrs40oP6ubIjwbXsWTWt9lFAJIo6Q3eVt0Gv/5vL7paYL8eGzDzhueNqxSV8OB7/k4YBvzljDBGFDJECAjS80RrTWRFXrrtBtWd90WyLJ/ywOP1gkzYxYRtLCXghPWF0jZ2LFF1yWBUQUr/mjBfzZlhpIRbo4cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QX1aU4EqwCBDllByOfhSxQpUavRQJsNTqcPvSiPKQwc=;
 b=M3f/CyU7opdJHqcvt9jhfQjdcmm2AZ6e1u0nHqssO202xcGogBUKNJI4iw9xToVp4wxfYZ60mgkqozISZAU/u9314Q4v8l4Oa++avayQNVBF470mmHA5gq/aO99XZ2k9sKN/CZOg/Ku290uqFDsOOfFY5nqpWokwMX3ElDXD9/11SpGAToqz8FKLM8iOgUtL/Bnp5s9mA9kdVNc/WNx8P6H6sBIK+hpgUiEYfjEoQpjSc71yAdOpmWOf4yUhzZW33PmMvwxYjvLMkOvoLAlhBl1168uq7l23HwHzhwhC8QldivOGGHdO1KyfJDub/8IIuj81Md7X5LnIRE2+TxpScw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ2PR12MB8881.namprd12.prod.outlook.com (2603:10b6:a03:546::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.15; Wed, 29 Apr
 2026 15:36:50 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9870.013; Wed, 29 Apr 2026
 15:36:50 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v5 09/14] mm/truncate: use folio_split() in truncate_inode_partial_folio()
Date: Wed, 29 Apr 2026 11:35:32 -0400
Message-ID: <20260429153538.727855-5-ziy@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260429152924.727124-1-ziy@nvidia.com>
References: <20260429152924.727124-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0002.namprd05.prod.outlook.com
 (2603:10b6:5:3b9::7) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ2PR12MB8881:EE_
X-MS-Office365-Filtering-Correlation-Id: 255ffb88-71a1-4b8a-31d7-08dea605211d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	74TfPfXoeWDkhze7Nau+R8NG/vgGZ6LwxxY111EsYiEx9ujLtDkXCmw4cfdwIeciAcQ/rA24xN6ODmocqJ5M09WyUMIzjmJtXHbt+FPglsoFJjOY1Hyl1oOjBbsdVyneG6IPsbb4C2unNHf7vBWHvJav2sfwV12NTkhaVTCnhKGXFCGtfnhOafcU96C51dzsKgB9v02wbO/HpWNAMDUakIYtPUqGmngPQq39BEbov/5aLdrsQQycOoJgEuLdXihW0mn5cEwmxAsbh6e9CmDPKCn4pka1DRo6LYUkv6SACOmOVwyEu/O+ncQD9C3gNRWM7IQ0C4n3xchUCvOd5ZqJI+IMU+Gi48e94to64MwG7qb0sAGuIHoozNUdIfd2jNNQBr29xPdNrijHT8yM2mBmcj6JoGP/RT5qxS8PKpSn/dbrLmbRoDoeD5O3FpnY+EqLQ4IK4Zmmdtgy8P+3SM9e1k/lNq/P9WXjT0ZWQbjf0/cnPiAE0itW6L/T1NtgMTsvV2DMYvRy9SF8ynHUWtWmLroxkGvPYLZRmNWi+J9k02HtLQuHPmm8Ip4vqOQMpJFFIMaouU5DENcj5rCPGLCcHv9xsEXIhv99lsgVz3yUyf8yTg16E7b7D8cPqkHNQ4kWrf6ctuEUB+nMShEOphzwD/zRekT+ufUxtKDyjpQUYUeARu+WuyUhTbkd7scEe/ae6Oduh6ogkEkgMyTNJgoN4zeOtVC0oWp03eR6wIobH/s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?s+D2RX0Ryy2FGIneZO4k7Vlu9tDqphHQJ1dKZ8v5iFOPdo56PhCEx/jVd/ay?=
 =?us-ascii?Q?9RwIZcJZw6eusr67VrHz5qjxjduxfEU/8gcxfOO9VlAwm7r5Hcwsxr8tnWpI?=
 =?us-ascii?Q?7mLxmI+T6D//TTnBnefMe2QXX4Ld+g3MIA7petx47pkEpuRjbC1zzSo5yPsr?=
 =?us-ascii?Q?YhzBDfIk7HXWSk5/n9GD+zC8zgMHTywrOJk/erWW1eMd/kgX/15gRItYptmv?=
 =?us-ascii?Q?3gGxCDGZxxQF2eFVq/eX/BXK1Tabf9AUX0zY6+lKry+q9lTqHV0PucOjVzsI?=
 =?us-ascii?Q?JEqM0eNDQ2Lfy3J6INMG7WElKrZAP0TeyBRv9dYq3KQMv8jTdiTZ67EUk5Ds?=
 =?us-ascii?Q?81eOVpup/siQNnWkGD+43dZVAUQNIByMHWKBH3NV3m2GhfUzkeyI9NJpB/U+?=
 =?us-ascii?Q?HaflLzF28RI8Igp40hOmd+xWg22oq3bnEraTjFXkIzRsF7t0q1FgygtRjxuh?=
 =?us-ascii?Q?NSojGJUu6D+oZF0aFCEYOP9qnEzQdg2Xbh4nty8jPaLPK349n2G1LoC5+Tl1?=
 =?us-ascii?Q?7dEQbOu/6EHxkRgs+ouiQW5i0Kdtls1aa9VG5hIJbvVfdmmNlTunR/UXmv1C?=
 =?us-ascii?Q?dIlRwe+OZC3XKaZpDvhsp6i/fUdOsijqPx12xL3V2TsPS9Cf2qWZRfa4xu/G?=
 =?us-ascii?Q?VACjm5jpcAzHQ7VEhzVXvcHUXsXe0WghUMcWgWyzdbYb9iKfujtdLciffm3D?=
 =?us-ascii?Q?P2RfXI7LYOEkHt0Wn3LUubR6Zd227lmevZE1jsKXHeQSE+YHYNWO5ruSJxmK?=
 =?us-ascii?Q?DfKgnrfv9FMI997L7IreKfy8wXhyeKKBlZydtl2hZWZ9RYcSdOqNm3Ty5b+C?=
 =?us-ascii?Q?40I2YGASUu2A6vWyCwLqZMzNvVYNnlcE60f5zoDTlxQjrkFuk8hxAWylhq89?=
 =?us-ascii?Q?UNa3OeYr15R2ySWWfMJq0WFEnwwdIfXeBoxOBLcpd4Hfeu29+6mvvhghR4GY?=
 =?us-ascii?Q?UTmEUhTbBcWehk6+/J0ktDyIVC+xUZDbWD1FzWVFJBX607dbMBZrghXWkWwu?=
 =?us-ascii?Q?g6Sztg+AYF0bX1gM9le51QFv4DqlCbvsa/Ut5S4uv0YVJ5azVJmzHbc8n8Yx?=
 =?us-ascii?Q?s3Pv72bLa+1i0xYXANSUl56q88gu+NMTdt58F0/yG9m21MvpyZppiVersc28?=
 =?us-ascii?Q?/ee5MGVJPLxxUfatZnRmqLUpwPfFnLaXRzI5MX47Aq5ZH1JJ5YUSR39xfbQi?=
 =?us-ascii?Q?MgU4IXPqASWQzzBH338cfpaHqPYgv5UzL+mi6ZdVpmnkt1qQHOwptTqTWFGh?=
 =?us-ascii?Q?y9aA2Ck3ycD33VdL6QpTm3gPJUMTq+yL14UU1kxvo3fcnc2ibVOxhVEBttyH?=
 =?us-ascii?Q?+rsTGDaop3L6k+H+52jO//Z6WAv48vivclxPgAJkl8S1vLPM0YHD4auvXQ5K?=
 =?us-ascii?Q?xWxn3xiZ3aaf10kBasqFIhSE/nXodHdFgb/QDASQQaJQXFEwVXisV7F4oChZ?=
 =?us-ascii?Q?A4P7jW+h+LRbCEWmm0byMssNF2njXvoxbPwfVqsEZJyn6LOtK8u84pDYK5oQ?=
 =?us-ascii?Q?1iC+7DevfzAGV29cONo/kSS6wnTIJLHzX4znXEVlMbyWW7OHjX1aGy3BvLpT?=
 =?us-ascii?Q?D1zorVsnk9UQ4R/Q3eN05txp9dkwo+RkMrfQ2OKn6Y0GZBSUfQaMA40N/Owa?=
 =?us-ascii?Q?mHfXymCVNDW141ozQ0c22iWa9t4hgA0pMyK7ESeLJEvdreyZSP31oBJiJRJP?=
 =?us-ascii?Q?rRWxATIDaLYdvOZp4ewUXTTlsbfhQGqchVy7TrtYeWaIf9rO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 255ffb88-71a1-4b8a-31d7-08dea605211d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 15:36:49.5171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PPtFN2JM7TjjctFg+aG9TBTQ7tQBfFvqZhFYw/Gxp5kNbRdlEkNRbApviGU7yDwL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8881
X-Rspam-User: 
X-Rspamd-Queue-Id: 7E482180010
X-Rspamd-Server: rspam06
X-Stat-Signature: xibdh4jgm851i1tddkd4eg48hgrxpowj
X-HE-Tag: 1777477033-910819
X-HE-Meta: U2FsdGVkX19BnRgmsidqvKrCb3B3pAfb9EiF0+AdLwVP57mGnpP/4g8zZJnCUr5MWilx288tFZpDtVPoTjV1v5FS6CkVPlGPWrxCxfHW8YS/AIRMlbELMtPSVClGoN2Kibw0+py6dqP+MVbGcSCE/OrrI1zz2FlAwkTXmb4gVQ4rWDnMztJRvXEHxcq0TPHbyhdEB2qr1Mffu/J/867mqJm8XgjzmJPEoNUwa4pMlyWxwix6Gp7WmHt2V9Ppp0Vf2cmbTJEmPhtXQHKdx7tzdswmM7xvQcwZhTA5aSymXkTLNzqXuK81QD3FRn9L31ZGKYpLiuSaGpnC3Wx4N9dd/mf29P/+V7dkbj0Eyr1/xTwVVQPYsWpmH5IsYwlj32uLPPNKlD+Wfh3HlSmxihEev3IHvzzEGuQNw6XgpFXYx+IOvh4xyT1ECjPT3jA6IDEPgRx6IF/mpa5r64Or+prK/HUx7xhv3XNe7D7bFejzafVAdsk2KFaXoN6umoIxJQWrmVbHPrcPdskW7ftO3ESc6No7vuF4LYjOfxpfEfcgMyVupYXCYNQJYVnRYMQGLlyJCnAvNB3obxEuzjOGMVfuR7zeVShvXa/FJWyE/nBJwiyJMOkeD5AiGDR/rUUrhHeRcXf+iLxGthaqC5VOGlOtNIaIBD92OhdNYFK6DX1MJg1xq86uJXXXmCiJcuGIqxD+Hr8yf4IAgHwknMHWClBl8i2R1ETl1Fhu08j1Nhety+rwB+VGigEMm6tvNsI0xHZ70yaFCqOr4hM1IfP5gAWf4UzxdnA5L6Tyu1Ssyawn1X7BH98tr0UCUj4gs8x9rFTPRSvGYUF764GPkCDG5n4jXU1l6kXI3kWDQqDf5XefkrkEWEBMytRLgH1RW+usS4ke62Wh8cwIxDf55rUT2KJ3FtVncr07D3sF8+gVvOTVCT+a+6BTTOjEgvOoDyRYeLf5Qm+Us8RaU96p8DWjgmL
 38RrmG2o
 rWFIA2MP/SSY5NJ/usZ36N4JV/vsgeyyE8jd3lNTpFdFn9gp1viOZkMv9jAAbaZK8sHVzNz4YhlaKurGaUk6NjUPwiFpeE+CY1oLKaP3YiU796LRCiVS4/cYMt9qPzLiWrSLReUnUUYu8Dcc8btE8R6oqgE/RPrAdpLP9UKYZBbLJhVLlSY8/U2U8W8eBvPGeSKHzoCF9FGEntisz/M1bWD6uwAfyho1OG6fYWG0pkYUczNFB+cfxRd7ZoKKoHSYmLEvikFL4hzBne9M3EIzpNlxJm7C/gdWplL/syMaa+RP3jTB2AFK4wd/8hHoQGglxFBkKNqLlacNrgAZFjJYX2dtL2a0JkQOWXq4umH8qOt8MR4ZER3dxazCvL5ngw6glKIBBmyUbggEHYA+/zsMJvu/QqhJakacay+3Kq4SfUOUHhvIgFNs6TpeT5gwcEpNMh+FXq8zgRBvaWjXiV7slFCDHYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After READ_ONLY_THP_FOR_FS is removed, FS either supports large folio or
not. folio_split() can be used on a FS with large folio support without
worrying about getting a THP on a FS without large folio support.

When READ_ONLY_THP_FOR_FS was present, a PMD large pagecache folio can
appear in a FS without large folio support after khugepaged or
madvise(MADV_COLLAPSE) creates it. During truncate_inode_partial_folio(),
such a PMD large pagecache folio is split and if the FS does not support
large folio, it needs to be split to order-0 ones and could not be split
non uniformly to ones with various orders. try_folio_split_to_order() was
added to handle this situation by checking folio_check_splittable(...,
SPLIT_TYPE_NON_UNIFORM) to detect if the large folio is created due to
READ_ONLY_THP_FOR_FS and the FS does not support large folio. Now
READ_ONLY_THP_FOR_FS is removed, all large pagecache folios are created
with FSes supporting large folio, this function is no longer needed and all
large pagecache folios can be split non uniformly.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 include/linux/huge_mm.h | 25 ++-----------------------
 mm/truncate.c           |  8 ++++----
 2 files changed, 6 insertions(+), 27 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 48496f09909be..127f9e1e7604c 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -394,27 +394,6 @@ static inline int split_huge_page_to_order(struct page *page, unsigned int new_o
 	return split_huge_page_to_list_to_order(page, NULL, new_order);
 }
 
-/**
- * try_folio_split_to_order() - try to split a @folio at @page to @new_order
- * using non uniform split.
- * @folio: folio to be split
- * @page: split to @new_order at the given page
- * @new_order: the target split order
- *
- * Try to split a @folio at @page using non uniform split to @new_order, if
- * non uniform split is not supported, fall back to uniform split. After-split
- * folios are put back to LRU list. Use min_order_for_split() to get the lower
- * bound of @new_order.
- *
- * Return: 0 - split is successful, otherwise split failed.
- */
-static inline int try_folio_split_to_order(struct folio *folio,
-		struct page *page, unsigned int new_order)
-{
-	if (folio_check_splittable(folio, new_order, SPLIT_TYPE_NON_UNIFORM))
-		return split_huge_page_to_order(&folio->page, new_order);
-	return folio_split(folio, new_order, page, NULL);
-}
 static inline int split_huge_page(struct page *page)
 {
 	return split_huge_page_to_list_to_order(page, NULL, 0);
@@ -647,8 +626,8 @@ static inline int split_folio_to_list(struct folio *folio, struct list_head *lis
 	return -EINVAL;
 }
 
-static inline int try_folio_split_to_order(struct folio *folio,
-		struct page *page, unsigned int new_order)
+static inline int folio_split(struct folio *folio, unsigned int new_order,
+		struct page *page, struct list_head *list)
 {
 	VM_WARN_ON_ONCE_FOLIO(1, folio);
 	return -EINVAL;
diff --git a/mm/truncate.c b/mm/truncate.c
index 12cc89f89afcf..b58ba940be474 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -177,7 +177,7 @@ int truncate_inode_folio(struct address_space *mapping, struct folio *folio)
 	return 0;
 }
 
-static int try_folio_split_or_unmap(struct folio *folio, struct page *split_at,
+static int folio_split_or_unmap(struct folio *folio, struct page *split_at,
 				    unsigned long min_order)
 {
 	enum ttu_flags ttu_flags =
@@ -186,7 +186,7 @@ static int try_folio_split_or_unmap(struct folio *folio, struct page *split_at,
 		TTU_IGNORE_MLOCK;
 	int ret;
 
-	ret = try_folio_split_to_order(folio, split_at, min_order);
+	ret = folio_split(folio, min_order, split_at, NULL);
 
 	/*
 	 * If the split fails, unmap the folio, so it will be refaulted
@@ -252,7 +252,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
 
 	min_order = mapping_min_folio_order(folio->mapping);
 	split_at = folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
-	if (!try_folio_split_or_unmap(folio, split_at, min_order)) {
+	if (!folio_split_or_unmap(folio, split_at, min_order)) {
 		/*
 		 * try to split at offset + length to make sure folios within
 		 * the range can be dropped, especially to avoid memory waste
@@ -279,7 +279,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
 		/* make sure folio2 is large and does not change its mapping */
 		if (folio_test_large(folio2) &&
 		    folio2->mapping == folio->mapping)
-			try_folio_split_or_unmap(folio2, split_at2, min_order);
+			folio_split_or_unmap(folio2, split_at2, min_order);
 
 		folio_unlock(folio2);
 out:
-- 
2.53.0


