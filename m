Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FB0CCCFA13
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 15:40:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA24D6B009D; Wed, 29 Apr 2026 11:40:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A52A16B00AD; Wed, 29 Apr 2026 11:40:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91A6D6B00AE; Wed, 29 Apr 2026 11:40:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7C40A6B009D
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 11:40:12 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1E6798AF92
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:40:12 +0000 (UTC)
X-FDA: 84712004664.10.01EAECE
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013024.outbound.protection.outlook.com [40.93.201.24])
	by imf15.hostedemail.com (Postfix) with ESMTP id 42A1EA0006
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:40:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=MMh77L+0;
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.24 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777477209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vn2dczErsC8qeX1wtXLk/pBwqBjDwmV6AUEB27Shw6Q=;
	b=A8NCMP9dM70Q/M93vslMAdND3BlS8L1boaWvEpoQoJSSMh9PUM8zXUMmHMSp6XFCTi6m1Q
	ULrrbSBwspE+MdTT/kHnBRsrbmdjDXbyYK0UZ4Kfhzv/DWwS2vcKrD5+0cdeO62xzCfvaE
	imWtsO7ViIYGPYSGmIJ8cFlUb489z4c=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=MMh77L+0;
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.24 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777477209; a=rsa-sha256;
	cv=pass;
	b=byBqeBhqqDvDvXoRIXD6us0L3ninTlAQmLPtwCjt4HD9aqG+kVLqiNtNRAlpkieleNgpPT
	/V0JxFocb7Gpc2SaI+VkK78dvb6WmQvhwM84gE6sAR7u6xwdlwTfZSGDJvjVm2D3SXvtoB
	aWQqh3d4029Bn5DO9t7KXJtmCJBhW3M=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ycfudVsftVWCzC+682DyZ82DdjY3FMQHDZrEBt/a1lQvy8JbA5DO7+upLy/Z2y7wAvqdGXGCef99vivU9ujsmbCy28Fki9Io2DludeSZS35JJFAIW7WF6qp5ahw/FUBfsLK/89rqmKPUKw+aP1ms9rceJxBg1LU9KnfGoedU58U2Xpn3vgPgQjNY3mYzkOLy1uZo+csoLQsmv1vvonU2gZZVUK4OV1AQGFE+lFfenLv4j5aUcMh/DC0qv0Vy15AaSlTa43yrktwxSDvvyDJubMzc4QhhBox8+o9jOfvVuZImJoy9G/7fjSkJno5zZplLXJ5D5hQbXWwmCgl9bjmFDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vn2dczErsC8qeX1wtXLk/pBwqBjDwmV6AUEB27Shw6Q=;
 b=y1cikAXmCIwLCYVs51nUHdj5VFArcH/KT5n93KeioXFmqz+xD6lmybe4JuCKDL/j5gJb19Bbn/C8i7EUslhu6UjC3LoOR1Ic4X9C4tjUUA4O0jLz4TQjkAZMnlqFxE7ZjAfzCnkQogOwDYjNXWvCHo0xiLP7Z+Yy3AQE5hP76wUlVTxoLFZHmxortDTpACEgZ5rhkVuKkbByVENByt/Vw2t+FSbZa6MRk0OryN3wXEhZxDoGBm7Fo0OBnT+VXjIrPJWFuiJ9DHm4dzxps12plDGX6MhUSHqJaPAOSW02teN3R8og+Dg5YrGMVHTzi5V0GVzVBp5w+r0VOcZ4jTVxsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vn2dczErsC8qeX1wtXLk/pBwqBjDwmV6AUEB27Shw6Q=;
 b=MMh77L+01WeWGvU4HWgbOdT7vfxW5jKOHC6m4vChZzJeA15ZQqbnNGpy57+8ttwBIFOmx70bSlmaEWximYFKjsul54yMxHIKIJwPyTXOaMzpS2K/YfradYvXMkPYQkcsXvHF/nQVGJKFPJ/PZJxs2n0e+Dkg7j708Lh1kgQVHN0r7oXUuMVqMJhgMMTsfJ309zcHB3vpf5lFCzw8RX0kk080vH4OEu+vCeITHl263JXrTxhFQmAs6UgFMlO8QfvRclshjHvhVRxkY85VVUNJgJf2IDMAx5VF5DeD+cjoSRIyuktGtX3N1kd5BLz3Y34XBYGhlzof5f6bh0bSuLFKDA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ2PR12MB8881.namprd12.prod.outlook.com (2603:10b6:a03:546::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.15; Wed, 29 Apr
 2026 15:36:56 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9870.013; Wed, 29 Apr 2026
 15:36:53 +0000
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
Subject: [PATCH v5 12/14] selftests/mm: remove READ_ONLY_THP_FOR_FS code from guard-regions
Date: Wed, 29 Apr 2026 11:35:35 -0400
Message-ID: <20260429153538.727855-8-ziy@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260429152924.727124-1-ziy@nvidia.com>
References: <20260429152924.727124-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:5:3b9::9) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ2PR12MB8881:EE_
X-MS-Office365-Filtering-Correlation-Id: b64e531f-cd85-431f-8659-08dea60523a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 asrQPcs+iM9G821hxUECi348sWwgqR+MZVi0mW41b4eoc06HBPHoM/wwyOTpzd9Uy1EwsDa3OeB/82wTFvZJ8PHQcPuOk7IfddaBZ/qcwvYzRzjtM2l5XqJxLIYRwIJ+YPBlEMzJbwk77IStWAMCGClyQgtDhroOYDsZ01wEILS1DWzfrL8lI49xyrWs9C7hEAacLc1F1LwrUPg9Gl1NfWPbDeokXqLV2rWxh3XbWlSNsf7RcdwNkGVM3IRiqTgBKib9nCiTfZ9YODy6RYA3Z24Syn3ncUejj/VV8A/SO3zl5bJyUUs07wuVgwgVhaMIkTElxBKI4RK4qc1sMJlH+vWOuO6EnejNBLJkAH5qBEHSdDvuLzxuQj5ggEeooMOdy4e7lJUhqV49QjYbxo8Tco0hR9QHOFRgd7UI5d4jYgqkAh2ZXpBZnRowxIRxCCfQrYEB+RcSp/3/J1YNMaCNW0usi/8noMaEBIUEbljiu8oKuxoVE1181WstoJ6tNQauO5BfM4m7bhwOQ+R5IbwKIQXP21EfSFBCE1Ip4J07Rp6SlA0uI+4VhACkqN6W2w8PU5B8A1vYs+opN4ykZ/pgXPGWqXNDp589yjClWbnDuOs6gBP+CATuLMGo2ivnb2u3xKByP5zsZ7w4EP2+vZNcuLkD3qnSIxaWrVgjArFKZrKMmKEPeTFzSCJWJLY6uwuT4bSyCBO5lvFrSNHYa1L084htOSD9RV0E8hRxrg2AEok=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?WeOI/dQy/+paj2O1l6lF9mTYZkavm6bfdxjuuPrXdy7VcBgS3HGy+SKcDarL?=
 =?us-ascii?Q?dpwXXbly9gdzsDs6A9Hfjg23GErYq+vVhw//z0yp3EPXrRIc7Axu4jIJx2wq?=
 =?us-ascii?Q?ggcCbH5R2V121/Dbzzf0EBHu1Krppsb4J2daXO0j57Vb+9zkwaRbo2ZEW3vK?=
 =?us-ascii?Q?lZ8nQ4Igrp3TabGfttSs/EV7ulPoLn5rl97qFuRuwOc/xksHitqgfNDbzL4Y?=
 =?us-ascii?Q?AXZtN/TsjA5+qENVEitzaPx+eqvC9TcUt3S0AWeno+EoRCMbUHyXr43T0Wkx?=
 =?us-ascii?Q?/qmnZAhINA4iFq9Rgys4tDcPG0+jRbCnbO1cNi/ALQd1UztMlgV1dGurrKIN?=
 =?us-ascii?Q?t65Hu8dgB/DbyX9G63G0sBHvdhl8c1WiSG3jXE3i9sogiVBkpV6+9dqvgVI/?=
 =?us-ascii?Q?02gfNLx1RG2l8iNCi9CDAw9pCPfmI1Lq+BOo+mXqlTx5dBRHcHJhhZkgY6PV?=
 =?us-ascii?Q?EVLAdnMH3myIXI2x8DjG5jSQDWcUuUAASxzjYOyLvy0+rJxCZqihj9VL6d2t?=
 =?us-ascii?Q?OkZHfBeXgolTJZwvWzcr75rDz4FrOusgx1VgUxJQlpEDU+PrHvVjBHQsWZSL?=
 =?us-ascii?Q?I/EuKGpH9ExXNWpgWtM9MNWqvuVrTGVkxw11TCXxrhuM91RaThfXbNa7sQU3?=
 =?us-ascii?Q?mGSiCIqnj3pfzTLvNvNXbr1bqrGRkBBYyUvK3jmW97vl+RHkqtFGrwJDXDo1?=
 =?us-ascii?Q?tth2FG5kPZEWS4BcpIMP/qmA6mWbyweyVQ5WImHUshFHn+2Xs21+BdW0FYgC?=
 =?us-ascii?Q?usRkzCXKVF3sUX9jfQHK99OHO7rUPkIuPxw4pdgI9LrCO/dRcnk81FptLbmz?=
 =?us-ascii?Q?wknsZmhhhutqGWI1+NMM49TMmA7fNG0WxN5BaTVpW6z3GX6+lNS07WXwvHCo?=
 =?us-ascii?Q?FTDbBmqhYI5pkR/5tWo2AMOoZlonhadrjwF/Jxuc9uJrLUWh3eKv4gABSEwb?=
 =?us-ascii?Q?pT6Ae4M4f7xLLmaXsFZcWYOWwKDWRnVSZ/nqah1yDWdlSRnWUEvh24tg2G3m?=
 =?us-ascii?Q?MjJxFRV/4LlFCfdvEcwFt3Uur2VA5RTT5D4iOGeDH/nOqWc+WSUu6jZh5ENN?=
 =?us-ascii?Q?2Y0DHjISqDitIeTXs6xBsS8XRZPuSNjqKazYCzSurXQpnYAfkn5BCehBCcNV?=
 =?us-ascii?Q?K7wuFJOntGRMOSNDb/6kuJb/U5WtiCTXotC+Luv9H1MoSMBuAD0METe6Gw2b?=
 =?us-ascii?Q?8O52cGutdy6nAnWGN6MkLnkaWBd23gMm8eQ7aF5AdzWlQ66r1Ukg7Q1HlEJF?=
 =?us-ascii?Q?cs44OfWI5PKp6PC8rrpap+ErdUmK2VMsy8b2waeZrQSw3Tje2jIR0c4ly55v?=
 =?us-ascii?Q?UobTGqCVqONF87eB4Z4zumf0D5F/2lOT51Ks/e9yDsIqD8yLt638aE6ayuwI?=
 =?us-ascii?Q?9D59ELgjd5/33lPLp2kVdRAjPLDEOC0qeLXC3ACNQ1SibyNWDmL0ZLPozWtq?=
 =?us-ascii?Q?1Qp5ZHnMFOzjF/KJsU/oArESJX/SCFRKf9KFjtUEBiIxg06XXxdr2fgGr6yI?=
 =?us-ascii?Q?mpEI/ZVZjMpR3U/8QTkZmtvq7R5Hak1K2+74A3aU7x1ifRu4dlBj4Di1a0xy?=
 =?us-ascii?Q?Gy2JFT89zm2aeLQseT3RwuldHV+8iBkv4wAMlfAG9U15as+lQ/cg9xnY62Hh?=
 =?us-ascii?Q?h+udLcRiTR5w1FsEVNGdJvS1h3oLg5TI1Gqnxyr6jn6M9yDMSbBQHPGYpxeC?=
 =?us-ascii?Q?7arg4pNu+oyVdBhXHnUSFCFhzBSFixawpkOZpvP61ecQWb5z?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b64e531f-cd85-431f-8659-08dea60523a0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 15:36:53.7158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YhCoJxCYc+gBl+YtRhQ6HbV6v2r0FysGTRRKCEbzZd4ueSruauQMDv20vuOeLdbU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8881
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 42A1EA0006
X-Rspam-User: 
X-Stat-Signature: o6n53ehjutps5enp4bqq5zh6uda3kmbr
X-HE-Tag: 1777477208-647379
X-HE-Meta: U2FsdGVkX1/Ag7XO3egD+m/KR6nfZt1cYXzIXg+8j372xYwgmZbjRI/yWGnh5YsEOwSzxiYKcym31Hc2CMAXxCjFbHKM1C3ddbBoXhCS7zEP3tMNwUFP+XpO7ZlTjQw3GGD24Moi6BetoVsuWlq6Vcx1T2ow8xHXCKXGqq/7dqDbfy8FR27DTdaLJ0vW4aaWpdMvFX82Z3u36Hz6FZaMN6AQSKNhAqj99p7ecT+kOr7dFx5XRmvoVaOcfNHf46DB/SfzE8pmhER9E++ohGMSgdWPWfhH8suek8oFcF11ms3fveNCBNph3ZXD/pKs/Rr1UQRb6HAnYdtRS1OMcYuBYGv1xbC/7RjfSvr+HdJKHNHZpTrurYyDUeYXE+hixZU6lkv4nPGoL1XcZY/GpD4IGZh1/jrbXyOEXfeiXZdC1Q6nDhrDmH0XTE+EczTcfgrlNZXsRWksLpr23Unh1afPtzX1oMDf4A5kfIMzO5/nx+Ftw6K00E7qbxvPnyJA72m8FCHrKiKGzQ36IrKcDCXp8wwm0drXIQlMuYjTLE7uMuJAcqmndQJqWwPojCVHiV5OTPtlt+AgYqp90A6sOWNk1sRzPBTdFgxoNVlbh9ejIftXQ0CeWvbdI7HAA/VcPweuw/0UKxhwkK2e/60je/vyRdTgkzXFg4FDMb0+hKLVQ6h1hAh/mzdtyzGOgYvNIt9bV9bA+/Lfxp0lEwWRhiXgXxJneqZUyOY92vmqitcMAOC4soXOqafcG/7HhYzzq+MoD/w0D+E46yzsQnciLKNq4U146Ik6BHCanHMCID6vFYLKJRRwi0lu/DpTCwmz5VPIfVBvVnJRBU/7NQeVfRxuiMAafZXOWYALvsXKbFMvVcgFT7ixKxVqBwD8uBXXnv6IqknM6EeWqEj14553XugvOXYEqU1OK3vwFiGvoVVJCVqX1t7VJjPP/cIb8nq8iJhPrg6Pioe2/8SrEnvGGmn
 Z2btMpCi
 d1+cfBARLelwLoZy9E2lUqpwXHb0IS5XRHD3rmBp16IPeW396XgWQpSSkPUNXSaG1fXxxoODhYgVgavHjazLQKzHE1CbPVw7UwkJTE+n95+WvTUClE88WkuMh7ClCFO+xbfPB/xwcUnCBHnJFfLirTnkk/JgpdvNRRm0JIlwzojtiOzsrOSetRK7YaBJmCSrt82PUinnhtxqPaOEjuxx+BUpwonEC7104OXJ+BxpAdPaaYmMS09JF8TpWHIEqFHkjbPfvH4JKdmFTEVzyimQN+nDidiVyQYungNinosO1j4URjT6HwuH/aUO4Ok/axmKE+25EjQYGPfRZdfBK33aket8Ih+rxAxwe5jAyaty1dGJWDezj6FPY5/86ewJnUVxh0cXRv3AlZAEffvUXlnZYDgJuipJRgMHaBv8VXy58uddLhazqUKMYjM+xJMc9zWqAOe0D4NYpeo/1quY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Any file system with large folio support and the supported orders include
PMD_ORDER can be used. There is no need to open a file with read-only.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 tools/testing/selftests/mm/guard-regions.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
index 48e8b1539be3a..1176398919537 100644
--- a/tools/testing/selftests/mm/guard-regions.c
+++ b/tools/testing/selftests/mm/guard-regions.c
@@ -2203,17 +2203,6 @@ TEST_F(guard_regions, collapse)
 	if (variant->backing != ANON_BACKED)
 		ASSERT_EQ(ftruncate(self->fd, size), 0);
 
-	/*
-	 * We must close and re-open local-file backed as read-only for
-	 * CONFIG_READ_ONLY_THP_FOR_FS to work.
-	 */
-	if (variant->backing == LOCAL_FILE_BACKED) {
-		ASSERT_EQ(close(self->fd), 0);
-
-		self->fd = open(self->path, O_RDONLY);
-		ASSERT_GE(self->fd, 0);
-	}
-
 	ptr = mmap_(self, variant, NULL, size, PROT_READ, 0, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
 
@@ -2237,9 +2226,10 @@ TEST_F(guard_regions, collapse)
 	/*
 	 * Now collapse the entire region. This should fail in all cases.
 	 *
-	 * The madvise() call will also fail if CONFIG_READ_ONLY_THP_FOR_FS is
-	 * not set for the local file case, but we can't differentiate whether
-	 * this occurred or if the collapse was rightly rejected.
+	 * The madvise() call will also fail if the file system does not support
+	 * large folio or the supported orders do not include PMD_ORDER for the
+	 * local file case, but we can't differentiate whether this occurred or
+	 * if the collapse was rightly rejected.
 	 */
 	EXPECT_NE(madvise(ptr, size, MADV_COLLAPSE), 0);
 
-- 
2.53.0


