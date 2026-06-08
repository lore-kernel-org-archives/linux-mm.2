Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AE08CD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 18:16:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73FB06B0005; Mon,  8 Jun 2026 14:16:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CA8B6B0088; Mon,  8 Jun 2026 14:16:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5915C6B008A; Mon,  8 Jun 2026 14:16:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 47BFC6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:16:56 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F32E21C091A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 18:16:55 +0000 (UTC)
X-FDA: 84857551590.16.66BCAD4
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012052.outbound.protection.outlook.com [52.101.53.52])
	by imf28.hostedemail.com (Postfix) with ESMTP id 336CCC000E
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 18:16:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pyJ287X0;
	spf=pass (imf28.hostedemail.com: domain of jgg@nvidia.com designates 52.101.53.52 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780942613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RUTd2xA1KKZAEmmoQLOFKXaRhtJfZSQH3HwyE1mkmgI=;
	b=eLRE49A2AZWKpiaV0ncMoqVqjP6cWnNOSFu7G7cKlg/ZRHcsJkTj6n6WStFxfeah6d3C5Q
	dMdPSq2+bhMJQT6TBL0MLDIImoej9PcNQnbSe967XFt60JYMehbic/xfRwGYw+C4NhwHAo
	oXvFvASmrQWjbY2eNCwHFVaCnv7fecM=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pyJ287X0;
	spf=pass (imf28.hostedemail.com: domain of jgg@nvidia.com designates 52.101.53.52 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780942613;
	b=0Jl8XM/DMkwGBK2QmtWF6XP7DUzZXRKbW5cNv86ds283xoLdGFae9YfJhrO3b1UxFFnCIc
	AkOMhGnpv6yZk1/EQZX7+DQTgshFo2quZf0etB9Uq9ngP2scK50lTFOYTCmEMxPf5k21OZ
	pgahB3yWIWG7QIt/gx7JRJCKm6aVIbs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jEF3l3d/Kn6MH4K0vvtyHSAEXmocs2gMHT8WlbRD+RKlTd8/xHhDXfmuY8cH2t+hzCfUl9jG9ca+mdnyF/kqUb9iS9s4bozAST0Qx1fGqJ3oqtLajfCZNRO+H6dW3709Ta9LZWZ1bWEahwn/fYrtZ6CQwRi++r7N7jpTr5xOLk+404aE1xCvTHcmHvSyw1C6w46h8myx+jRJY8ziLZmie7OyIumx0tTpO73ycOpC0MxizzBXe+QmLfNa88iB78PLKatGf3BfXQqkgaoAHtnxtsZYGJc3rJNKUqqV18ba4z2/PsKxIGYL4kMFdLQ+GbVOszWcBI+lHGMV1m8tNbz4SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RUTd2xA1KKZAEmmoQLOFKXaRhtJfZSQH3HwyE1mkmgI=;
 b=BoVsqbp0OsWvzOOcno84yI2yaFYW/TgvCH3Jp3BOPEDJdJDD65uSW+56Wf+uTSFnEJE1byPuQ/TVvkKocYWRkx25ucvKqZ10oNDAZXQq61IVPkGFnLlvx1mjvV1PbCVVcz75SX5hfaq5KvlmsBHJEp8i8e2FyGqPAMAf7+Bi3UflaZU4CbKtlo0KV28kVZuQxpN4pCvRgpTTDwxFq2za4ttSda2qZtFI2KrcMQdkbUsKSQYccB2ip8CmNdO3/Z8QVaeKKTtI7N8UHTeynjFsqehZ5zMWpGVcm8OmQx+7iiUuChGdwkxss6sRhtn7TEn+rrb9X8yhhNo8XPh+IrsvEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RUTd2xA1KKZAEmmoQLOFKXaRhtJfZSQH3HwyE1mkmgI=;
 b=pyJ287X0sSlgsC1fj6cKPBJf31gmEtEQuPKLnCsyM0VDJuqbiDW0vef4Rvc69kG0aCVCpdJJtjNAQIrumXi7Sbkm/bmhGYvA4h684wPxt0E+3dxNiD7g5DJt6oCdzqBnvyAx19FqBQmdIpJZPjKW5zDsnrsIun9GzLSiRv2Ofp0PsvkU+SPMQuYk1MCYmG/m2K/PbGG3iVPf0uC+ckzoMaMEcBzIlMpy1LVliJD6m6mYSzajzegNqWbFs8IShhHAt+8T26MijqexxlMHUHzUa0rqTBUrMYAFoNTlcK87RyruLhRgoqXD3FSZ5IDkASQ93GmrNxZ7XONW9JU3DnPsdQ==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CH2PR12MB9519.namprd12.prod.outlook.com (2603:10b6:610:27c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.12; Mon, 8 Jun 2026
 18:16:41 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 18:16:41 +0000
Date: Mon, 8 Jun 2026 15:16:40 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pranjal Shrivastava <praan@google.com>
Cc: David Matlack <dmatlack@google.com>, kexec@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v6 08/12] PCI: liveupdate: Inherit ACS flags in incoming
 preserved devices
Message-ID: <20260608181640.GO1962447@nvidia.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-9-dmatlack@google.com>
 <aiXWmR-ettxin4LC@google.com>
 <aiaeOVomxQZhoM3K@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiaeOVomxQZhoM3K@google.com>
X-ClientProxiedBy: YT4PR01CA0101.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d7::17) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CH2PR12MB9519:EE_
X-MS-Office365-Filtering-Correlation-Id: da483ad3-8fed-4778-0706-08dec58a16e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|22082099003|18002099003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	S1wpMTpXdj9au2i9KYtZt2LR2lhpBTbyB3UjfjPUoCFIpI9Wy2kUbRn1J6O+aNJkEKtyVwmgOso6L3837FsU87JoQ/AFW06/mVUxaPFrCnYNjzD1pCXDUZ8xeweL3ExiX6gnwnerIIemX/TV8dJQ5tTtrRXzN4Ldm4ttzD5Je0aSiLOn3lehqTdffE/01kQ7YKfgNr4ydjZAd0egMDKiyyarAuhkMrWuMlwqiIwn/zgtQlXyUJdH5jNAAiU797inamr4/BMwNrOQYHTRNY/Q0BxatSWWkw2JCC1bGVDu506sStF3xrBOFRJfmNAKRx7pX/lw0PugAltzyG78G+4revqjQ+uEpFRzkKkYkgBXZezQWPXEvv4eMY8Wu91ZTsHiP/zdRAnC+1YMxexRaNDLpPpzrd7cT3vY/26oIVZhCJzeW0UATPd8c7xjTNhXULuQqmWzM/pNIQxcWxi4ALH2G8MA4sly4W5IDQbNVs2pGjT0DqlFA2inSwaTDQo8GifuwBQxD/9Leya3DNH207pE6cybicHJZWeV4xWTQ8zuB6eSvdgX71T0KWM8NRVY/McJauSZhNFmfYE56qmtaKFZXRRTwFdGZ3fGjqSoDOXuKw+4ETEIQDsEEW9cfHWy5KLlq0tDVxAfGzdw8Sr5UHngkbPlAKPM32D4scGhVibbDIUqcE4TiBQKOhA7UeiF+9zb
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(22082099003)(18002099003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?v91zFJUXVUAWEFYtnNkQS4FJ7wNBmHiOV7u/Hv/eT2w1V+qb8Z6hnZGRD6fB?=
 =?us-ascii?Q?J72B3xtm4EuwTPxSHZK2CD8WDJcy6f/ENZ9Hm81b/eexbB+IVLOL3llo1WXo?=
 =?us-ascii?Q?T+mM6caXTe15GWhaQPG2K3sBPE6IaDgD5jYgbFJF0S7tM95nTnPzryzaMn7m?=
 =?us-ascii?Q?TIW2Gdh/q0EzD+/PS1RYNpcmV4ocYLyX8s+5zo26spTMGao0Z0ZgMaxyGzGT?=
 =?us-ascii?Q?8odloDRVELlM4I5XyXZg9053MEwSQkcqNU8t5AyyVskST7Y5kflLw8bVj+tG?=
 =?us-ascii?Q?jRT7ItQp6wvgHRw+7+48Lvss1czupZa08Og+8gbBP+sOeGdhuvOV8dWEtF4m?=
 =?us-ascii?Q?h5GVnNaOa1YuZJhajX2RvGPq3KNGfYhX3FzSuLBPB0LWLvSalG+3B/8vSBla?=
 =?us-ascii?Q?Lou+3R1rqfyaNGclCLnR5KhskOclFUhPuRh0c/Uxo+Bbu2xYLCkrjZT3Bt8e?=
 =?us-ascii?Q?rTK6jNgL9XYYGj08C0CC7ni9+O1tRni6E5KkcXxCINAE0Kxfxx6O25W1sIn4?=
 =?us-ascii?Q?XKPqbpEhnF8EJpCffHyoK8iyaPsYoBZEeyHtJXqsuqYzCLmk2FF0rfmf0i7t?=
 =?us-ascii?Q?9ihrlnfmD2maj2NYeQDWgX+GQsKtJUVLVyRsxjuHZ/L/2kageh2yJa7Ticco?=
 =?us-ascii?Q?ZzJTmFIithoNq1PY1gW9lcM0To3HEdC8sQN2yjJgHhVALPFrrsspfTP/Q1HB?=
 =?us-ascii?Q?x4lFSICPYG9x6NJgyxI9cs5TtOg5Wdk0J8/uUMK5/S9OXQAPnbn7M6Qe4ZK+?=
 =?us-ascii?Q?KfiogHWOCqEvBUXwhxoHn9Hdcwys3IeGN1mC5sXcNl8Ii3rtaOk10ZIB/PFP?=
 =?us-ascii?Q?XsmNxX6MP6QLP8i5KD0DEAiUnwkZG9ics+yQo+pmq9FEaghBiDUeCpdN3KFp?=
 =?us-ascii?Q?aPIHHVlELVK0cwgejsqzQcZOjNL1hElOP1b1fe0obQJHHBxTfqhc3/8a3TMD?=
 =?us-ascii?Q?LH/p1y9rrPJPsUuB4XjZjqvpI0FuXj3qZQmLfYdqtBwHiL7CsptLjguCaZgJ?=
 =?us-ascii?Q?a/DDYicrztZwp5wuq7YMiFjrqW02Imm+zs9Oo2/f5O+gTwAhv1NiieXWNTtO?=
 =?us-ascii?Q?o9+veeYtr/HA1vA7wdHD2PghEMM5wL25k1EF3wDxczJJeZONQm51C4noe8km?=
 =?us-ascii?Q?opL/nq2oWXhj36mEkvyFy2jMqFZIlweuhkERdEWWLDoW2bPYJPsEuU55u/dx?=
 =?us-ascii?Q?m6yxTrA+7YNQdwIQcOMxKs3sGrFVci08PV/e7Ic3vlEHXaUo5viQBIqGlOV8?=
 =?us-ascii?Q?xPuVd11aFYXRSjx1v+Q4rEqHAYzldGCysy31Ikm3OaW/VicL4ySfRF7auCFG?=
 =?us-ascii?Q?CfIywBfRLPJPiFo4PfJAwGUqopB6rTPoUnq9cuUpcsXYlAYhVaU7DVuLsdYY?=
 =?us-ascii?Q?UXt24THdVpG1oqJ/qgq+74m7aQfGJ0knsIoGT3v3qNNrOLxqhvrVTRqnIc1+?=
 =?us-ascii?Q?ZhaUbCQM8q+e+YsMjlLiN7H8J72TYyXIy2vaGubB4ReWQFDP3L5hZmpzS5/d?=
 =?us-ascii?Q?W870ODPH5dAOQaHDxPH7tOxjm1UTauzyMjkwAVcfqjhcXFxMTXjOiataWRGt?=
 =?us-ascii?Q?x1nyPsx1/1kwKHpVEML6rP+aCP2zIw7PM/7AKPugsPQnMmnpA40RZMt8ApdA?=
 =?us-ascii?Q?w8MnumOvSIsz1orAh1QEpiixsjJjsCmEegWeJN1a03sNz3b6hxPjuOP8KFAs?=
 =?us-ascii?Q?vc/nxLCjYUHqFyDZ2zFxLvdKUDQndYZGxFLcsN8/4DZx71iW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da483ad3-8fed-4778-0706-08dec58a16e1
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 18:16:41.4447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: idmy3wVbR2K+gT66+w26tRJQZYYhpCnjt+2WCjmmjhAi+RM6WFOS9A8GBVJazp+Z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB9519
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 336CCC000E
X-Stat-Signature: ga5m54cugxgb4z7cask5jq5s53wote53
X-Rspam-User: 
X-HE-Tag: 1780942613-904082
X-HE-Meta: U2FsdGVkX1/efjthWvfGZi+ycY/pGvkR/rJ4G6/hcbrVxiNqKVOCYNG3RUtc31qlteiZ11twCcUN7n8n4bn/iX0p2s0BUJfLm7CPJbw5dwU5TkswewB6CuoQDYw2kml/CyF5ne2O3knC5ZZ4s34x21jz5Q1grPNsBmrXwtCiyFQ6JD2OchQRV3gMQFni+ueenn0DfdD1U6Pw0mNRKOSXcTG0BcETM07SKXbXnTcqWwVe5fi/skdfFSuUutbKmNVsW7wrQZ/dIOLYp9YosHS6elgHf+UKX/2z3Xp2Hhsk+3iL8HJ4BHEflBY67VN4eZKDhQv0XwHGn8aPkoq9A3H5pKEqyMR7sHOHutl1n1Exbh3A2N6OOliNjGfVEfFdN/Z9ZQSJWrHGL2poLS/y3KcP7drBimVbk3pPusMq2yzNmRe7lyIrFW/MTThS9gyYzzBfBR9U0uUqX4G7xADWJ5PqF+PpQvJ6iVvVm7oCjRS0zCagTHNSTL9Pk1GhM2vCNR6aBHDEs71KiFFEiZgrHktwM3Y5iiihg0rd0OpYmA0earLYe1eke7alMZPRO9abWJndPWl+izAUfurPSCGaLRpTeOYIYKRMVMnw2AK2Vznv/HqgvdN0akGMqtyiVV4rHt5n6D96749ABAPp7ZoD+TWkyyzQzB/eeCVx7QTzq8hsA27aJs83UBod1h7CTaO64CcI1/Py/fpJW2kiXwSR5d/e7E9VWG5JPG31lMmM5FCN1bxgX9kLYYp/yUyL7HrCGg14d+XrwrKbtDOscJwwWQeaE066Lf/B+TcP6NZzSb4VA4GZKlWwr9FsYzt0rOFIjBY33o2NpGRDSI0u8DKAyJN0ozzHwesd8Zf6u9R7r634hZd5KHn0obWagvQXNP8h2HEs7SfKVuLSkFZVGtva0OKQv68prmsVhNRExsa32lBWCiwMbPJhi2OKTygvDbfvWpA7ZDXpQPt/9XjHOzQQwKB
 BGrzxOP0
 PZg9Tg0VhgSkttFCsadprc7vGUKFGHHOWCSrBLrp1rp8xeNWB6v7fVOjTyvFWkaRPBP9ZQyVyu01ascWZpJWq8Dyq/5EAB4+lD9+BnJ/kPUC/Jt09h/bGKXPitLneXNnotq2XpA0pBESYKNuvZQhyxvCajWMSyyez7H2JT75vFE5+07QEKY4aT4pG8IBlpmPq0Ua5MufgjgsQLWivpCBxJ3RwaaMtnSAZf+CRsMtG/s2tIvcSY7DgcLqq+13jgmQKgskot2D6UN2wdbLJWo140DDGc8fhls+Z+5uGc/pOjfIjIP8f6XHj3rxrhmH4N1yaYnFJB/aF0Wgsc0X6pYyJ57jw2edZMEai7fXko055bJ6FkOdLzmrWbWUn95+bBxRswTf2zkwhdqVPuyPf+6m0uBBKRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 10:49:29AM +0000, Pranjal Shrivastava wrote:

> My point was that a FW exploit can meddle with the bitfields of the
> ACS_CTRL to spoof and mis-report the ACS flags.

Devices can also ignore the ACS flags. I don't think this is an area
where we should be worrying about devices being actively hostile.

Jason

