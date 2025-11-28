Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EFE0CFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 04:42:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B5826B002C; Thu, 27 Nov 2025 23:42:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78D2E6B002E; Thu, 27 Nov 2025 23:42:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62E1F6B002F; Thu, 27 Nov 2025 23:42:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 500476B002C
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 23:42:57 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 08CE0130E06
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 04:42:57 +0000 (UTC)
X-FDA: 84158770794.04.A1256E6
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010003.outbound.protection.outlook.com [52.101.201.3])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2DDC9C000A
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 04:42:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=TSISMFgS;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.201.3 as permitted sender) smtp.mailfrom=jniethe@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764304974; a=rsa-sha256;
	cv=pass;
	b=xahuqSRoVDWO8t1Roq7gGG2g0+McwWXvGXEUWjZYpVWyzOzD+CK1R/PePeBPS6EgHgEDXT
	3ZTgQp11KyM5ZRprj+JazKKgw6aja/EIzakmuDtAWODJchJoLhxsKP0OB0nTZcPmLWSbyy
	Bd7+TB0QTv/9nGzcBlrMBbKva8PoAm4=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=TSISMFgS;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.201.3 as permitted sender) smtp.mailfrom=jniethe@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764304974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GY0dbfjKjUXBulNyR9nzUSJvMxAlo02giuEdw1eVWCw=;
	b=rcFR6GMUI60pOQksZ9wkZyo1zYtSqZWWxrHrYOP0QsnjeQyPuN91g6529OheRoZo+mPrGY
	rLB4k//Vm3kJFMFgpnjiGDZA37gkuOqaUxaDCCs8kbHm1v4W9yMY/mGqp3Ocog1/+I2u75
	NoSWJ4LIOcoXgVQf2cUq7ee0195yTzk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kv9nUqt20ywrh+twP4Y2qe97Kcy0BicRK20Cp1SCFHHwca0Q3dhNOv79GBz0Wy8j4PvaGiBkMf1WcyGh0rODMe28aeEI1TS7Rfm8wOaxFhx+KUvB1s8k3Or4mvffW5beu2osAQlp93wQxMWvukaw3tJwgItPaCaH8vbKONhbuHWgboLQTU5z1jXMcnDqAgQh7cGtuILY9+dO+PJfOXxzNVPtnkH88rIHgJEyfiPoFS2tXYgDh+zOQ087ZmNcZwsVUUxetz+U9oLl8ecR4nXfRNm9WHJve9NASeiFYz5A2jJy7sA1IY/hCwgkj+mOuKZokPss6rjIJgWrC1nKZRWNkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GY0dbfjKjUXBulNyR9nzUSJvMxAlo02giuEdw1eVWCw=;
 b=jp6OJKl5tS9r2jsk7E/fjLxUFDmHpd9ugGl0VfMG8zGjXAE2sG5nfJPNU9xsMLW9PJ4Ol6hzpoczFPGWvh8YkhAoQKB+I0lvy80RHGWVWVsNFXr/5RQT8qj7yKKzVMla1BQ8l7yrjZHYVdpISPjaabnBXqQS7duZo11zAmo4aqz2ZyEU+KIpWpTj50TCGVf6hiQqE30sFafy5WC1TUEj4nzf8XiUdKEK7UpmkvrbLStgzVJYactZjzsch2//1wPM3EzsLIkPJAGa9wlZxAs2K8N2FLeVAYjdJ0/zZt8uuuzlivSPTziC12Hz2X0XLpLdVfheM5K+rQ840l0wP4lLNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GY0dbfjKjUXBulNyR9nzUSJvMxAlo02giuEdw1eVWCw=;
 b=TSISMFgSNGa6VhifJ5YwrlUC9YwlA8ELsSy4IAXB4KFCX94j1n92tvWd1f6DpEtOCT7bSpGE0A9z+zQrQBY/yp0yt+BdoynlRKpNU8gnDjl1jnEuXwzn7SVbllbUYbJd9pUUhKRpQ2ENoFVjLRxbKxLLOytFUGs3fxyl+whiqc7j2YAGXDCFU4fxyzhBSznnUjn6NiShpMDEDxArJdhHwsggtq4SMimZwOo/CshOCg/7sxqQN8PX7S9ZgLncXd+L15fTXmfPvn8SZRHYi9CqtlDKowLmkg0XZpq+WD2gPE3MqAjbRD1C1OZGW5HVqINqtgm+IZcxGTC8+Zexf0vPiQ==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 MW6PR12MB8735.namprd12.prod.outlook.com (2603:10b6:303:245::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.13; Fri, 28 Nov
 2025 04:42:49 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%3]) with mapi id 15.20.9343.016; Fri, 28 Nov 2025
 04:42:49 +0000
From: Jordan Niethe <jniethe@nvidia.com>
To: linux-mm@kvack.org
Cc: balbirs@nvidia.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	david@redhat.com,
	ziy@nvidia.com,
	apopple@nvidia.com,
	lorenzo.stoakes@oracle.com,
	lyude@redhat.com,
	dakr@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	rcampbell@nvidia.com,
	mpenttil@redhat.com,
	jgg@nvidia.com,
	willy@infradead.org
Subject: [RFC PATCH 4/6] mm: Add a new swap type for migration entries with device private PFNs
Date: Fri, 28 Nov 2025 15:41:44 +1100
Message-Id: <20251128044146.80050-5-jniethe@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251128044146.80050-1-jniethe@nvidia.com>
References: <20251128044146.80050-1-jniethe@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0024.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::37) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|MW6PR12MB8735:EE_
X-MS-Office365-Filtering-Correlation-Id: d792c4aa-11a9-43e5-350c-08de2e38958c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pQuRGMwITgR4XOiqEfQIWaYOGBxJJpwNb21LalUpB/zzx1fuiIKU9jsMzU4O?=
 =?us-ascii?Q?Vx85APTARqRsIzmD+bx0VDULmhu1RqyAP7Ka9+G34C1d9HpHNdSLGgEMg+5M?=
 =?us-ascii?Q?+CpjvVwGVZEQ0hJ6G0AGv3MsubUeCEhq7uMpV+IkyTYQTvQxG9Q+qDLTatqX?=
 =?us-ascii?Q?6pGXaRjLpCDokV87AWnoE/YNMPcLNVKDyaZN3m09B0xY4bV27137/s2x9psd?=
 =?us-ascii?Q?l7oH9eh600A7OP8LOWp8rI2+AjJcrCZ2t03erC0WCB+ivOpVZ80Tyo/fYe62?=
 =?us-ascii?Q?ORQxluGOikxOCtRueWdiLq/ZEbQivwc9k0WRtdN8a95YI5FyU4te7BwcnYcr?=
 =?us-ascii?Q?jWHepvKict8YnKi2ht1jf/wXNtJImpFKObTNDlOzOpYVr3L7XHvpFOJpAmU5?=
 =?us-ascii?Q?a2HFmOWqSBwb3tCaJon6AnEhdCr0BCor/VBPUhaK4TguQ2eD1ghAgIolVoL9?=
 =?us-ascii?Q?NXVK9DQYWT5Ryhm6luZ/JUw3gJTlMl+TIcrn1D68gfTqw8PjCbHpZeOzorfM?=
 =?us-ascii?Q?aYcD56fGiO26q7QkCv469ffWu0UQVvUo+5P5G8hHhK3DQHL5frIfZ+BajBbQ?=
 =?us-ascii?Q?/Au2L0Fj/6uv6kuLjnJeUXyTb39vf1dXAYhFHiYO8SsMEpqIA0Tndwa0ihNG?=
 =?us-ascii?Q?MN7uZbAv2DLeYNtlXL7q2G4YR+LMQ3CB0Prcg24xTIbtGROvdFn6z8Nym4w+?=
 =?us-ascii?Q?VcjgK2BU8sAveW06UxcQbKOY1a4ygG/CfwkyulyGA035jYGsKFwu4ZhcYzYf?=
 =?us-ascii?Q?Benqjw2tBiiQT3Vc3I42gfQYuTQEk1RkKDkXEtQJ4W5vGuxrKZl14h6psoTh?=
 =?us-ascii?Q?8gjw1oLvtqZt458LqFZj49M1C4SP9Ng1VhOG23QsbdIljV9c/Zat/HsDrlcb?=
 =?us-ascii?Q?47KkuwciQSmTz5C8mPyIN85psKkKngmJMhlO0nIt84aVKxnd6gOSjh09n3xv?=
 =?us-ascii?Q?Lj3Z6SGLgbHhOl63fYV3qbQVxRQrvGqlFsPbs81Ot7o5Zo64mPDlF1GadNyL?=
 =?us-ascii?Q?NMZ5Ua8lmenMZ8PhfCeCoGfS1O/mFUoWu1VN1T+oQHbrtgDDJ+DCfPJazNLC?=
 =?us-ascii?Q?6oKbpqDsSSkkZmmxVRM61/ijXbhbbCCEOPPMu9j/Zuyb9EI2H1o49/zm4cpP?=
 =?us-ascii?Q?mUAICHqrqJ1xRlmc7kD8QvofJ354eHedoNZ4lZ6F+Om63Obc0vMiziMRI6wJ?=
 =?us-ascii?Q?SBmFFBotMzVJqwIFfuSAAw9i2jm6fSDDQskbCQHlBMOCbhVTtuhWUMOiMM+J?=
 =?us-ascii?Q?nqINNb7SYNTaVhGNpW3OesxnQ7q31t6QoGPiRb7UcT7b3dykBtgDeHIVDZIX?=
 =?us-ascii?Q?0U/V73tFPHYfo0CbXD++1F5uCw9e0v20q9ivn/YoZRvVqVk0bCZOYiKXlXVw?=
 =?us-ascii?Q?eAgoyoNBi3sGxlvIJDP4OfRFVD8+vaM6wB+TRE97A8to7VuzGST/5uIUGbz4?=
 =?us-ascii?Q?NOWUx6X0mOmHIZiEbP1SKJxFRBpvgZ+N?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cs2Xr7qQO4PCj9DRJLde3/7GvmJIaFuD5M/7wqTtFxH2WkugGeCt+JxC4GIX?=
 =?us-ascii?Q?pVrRhmYLCD/jQmN1k9MKTYh13g/2ONSsU4fMEvgzmzTFL3dbNX3/dQOEha3d?=
 =?us-ascii?Q?39w+HFXhz2gPYr/IXEmHDGkUKeXrTKKCkJh8uxm2rnYalTtIHdYc5hUcxigc?=
 =?us-ascii?Q?kT9rgm4nIQF+3H4e8h8rceNq/WPwDcEKU+QKIPqIlh+HYD4U5GdHiMLzrKcu?=
 =?us-ascii?Q?YzDez4FPKY/blYgm+AHkjrGwuAknslvw04Jc31WfVK/EF+W/skp0uLkOaOaR?=
 =?us-ascii?Q?u5dJYhApqBQ8phIcFVwVJqm9074l+RKRJWuDEsoO12wb8SjQW/QeR+8ORezZ?=
 =?us-ascii?Q?whWmzuumNfJ6cJ4kZL5ez57bSV48PTkEqKHBIaFWCiLzV1+0gV75VZ0g5uUm?=
 =?us-ascii?Q?BjhfrpOUUPLOwCObrdEBl0g5Q46WaVIyWkZZGUqmFI9gPLIytByAoPetkAQ8?=
 =?us-ascii?Q?VEXDxcIVxfszKO0SMeYDSoWAlAGiF672dBFbtMqlmadApWEZ88EAOae3Xj6k?=
 =?us-ascii?Q?RuSXs0Uk6UORRcjG2Bf4eYOZi8Vpt27HNAbHKpmnPJgH/FsTDFNHtG5P/+01?=
 =?us-ascii?Q?nlqNTTS95x96H5KtZtbBHOACHxeHYUuv7cQjkf4E+nIYul4zm5LWr9OTQDX4?=
 =?us-ascii?Q?vRdPnW8jCW1HEBT5QPaZA2wMPojvrlfnSPae6JsbadZmOz2yZVf+0Mt7ajbJ?=
 =?us-ascii?Q?zUe8i9KNu5dlATxT3SU3lEw0jH9SqcjrQ3IYo+X9lY10bCnt5OExD/QhAW+P?=
 =?us-ascii?Q?7XJ8RedmR9a1x5KX4By6sZWAVoXamsoJRwZshg9RDe8QbmH5QWkiACc01weX?=
 =?us-ascii?Q?rH0TL2jTFBxzzvlKcTs767VOx0smTln0YMcqQ9+q3Az3+Juc79tByWvICn3y?=
 =?us-ascii?Q?LkZG5NMVteDxecbiXotb56dg+wl6uZiE3c1CN9hasXdI/ENcN++/HNqizcWg?=
 =?us-ascii?Q?jwEVcdpr5CNJP/ei6DXrVMuklpBbzCL8PQkNqncFTx3QRihz/xZ/6WaGBsyZ?=
 =?us-ascii?Q?xcTI4kCEFJW/PBxYYFbH+6HTqKbyWb6RsnPdmrjne8e9NPi+SDCwc/LWgmIj?=
 =?us-ascii?Q?7R78SaoGREv2+bVpLbIHQCN0Q7jc5dJ7uFZT1zmLbuXKK9WTCqqcIhaP4e0W?=
 =?us-ascii?Q?t4JMdadfMtsAguK/aggxwwSntKtZDFhALf6A+Dml/QmWQbjlrm2af4fw5n/u?=
 =?us-ascii?Q?kWZ9tnir3C+YlTixY1YOixzUxIsTyMQUPxFYF88fHJb0FUDUaIhj3lS8rg89?=
 =?us-ascii?Q?0dvb/nmg5DDoEyGChDxNGp3CAQe+09ndNZ/9aF4hwYyjTG72zR75cQxfnVvD?=
 =?us-ascii?Q?S8OYiO2V2jQPtJW/28YiVCcKEId5i1HMAmbCwgZLZHFDN37W1SX42Lyqzwz3?=
 =?us-ascii?Q?9+4E+5FDaBEZSjG6B8lLMmAGrpAMGNqxl4E4gXoPiDkg3ukQOv0Vgpruc9J4?=
 =?us-ascii?Q?rslc1dBnW5gKv/ACACim9YvzEM+jZWnLDn+BlU4iKs+FVeH8EppbZd8SWgas?=
 =?us-ascii?Q?CsCIkKdTkZnJOnnh56u16FbBZW1WzBzlWTGH8d/PvvPCw3jdB4xxIEyRBTTY?=
 =?us-ascii?Q?H+4i1m0fNmfExvDKgcUW1utHL5T3jyy6UdWBa6uA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d792c4aa-11a9-43e5-350c-08de2e38958c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2025 04:42:49.6489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kWTgNaeYhfQ3tAHdJEfRo3C7l20kaNnIvcudhowfDDZsBYSukx9L0w59kKwFydQkx9Y6UdaQTUuwkxQby200mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8735
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2DDC9C000A
X-Stat-Signature: 6wrmgez9deisgbngj8knyf5memtekcw6
X-Rspam-User: 
X-HE-Tag: 1764304973-501777
X-HE-Meta: U2FsdGVkX1/vcsKF2J6MKY/um3QYrpNh4IwC0Z+oxsV8cw4zNo3looucYxdpk7FSmGQgBtAzxdiO4V35uj/WGJqMr3eh43cFM79hhmcLeYhwxA6U145/dP07xpQSTHTk3OkT3O7ovCAvSB/zKOdLfmmwUoA8UeAXspDklwMRD9bLr92Z9h5Cb0DBdVV4VWlv7pU5PuAkLCfwb3399nxJsjxvJVfIN3JE3rP7SZXGgkTV8z7o4LmRGByl2NmeXGJna/MBc93b80o15FmGzkyWTUFqBbDuprENTs2epA68duefbvc+MadqZlj2eedBll5vKH7PYs9rIN5VBu0ykf4cIdgulDj9v59pe8FfPLWIARdpTHaN0TKwP/6YY8pF25V+VoDKNUjhT4UVJ2P+cgTq/gLQlLo3IsfRfHnyFhDh0r2i9xwLOcZy/XSLKp1GPQ8oFhS8K0ey4zwjRrBafXRzgFX1qvlChhBP3D7HnIJUqV8Zk0UXqUlgO73DZ61gDDrpOUD6lXdddMAsfHpItj/BIYd7ADGLLUFYyD6nQXMlDTbwD/yy3rMo6GokFNULKPkiM4alYeVUzTkw2ESOpiteY4wKKryx7YB3tgVcDY4gf+/ccR/woGTMSFDLk+cj2Zm99KrUVuiPvGU/sxTaSxvGK2OjJqXOwB8yt62v9/s1yDizuDnHO26EZC62ybXBWRvSKGX7vpjtmTUwgFVfcHNwDUX3/3zuBbbzRkMxIw3dRhuU7Ra8MpNdDluX5WJAFiqTvYI8Jf9jld8KajALBat1O3KV5g81bwYjetjlTeskCwN9buoXPdkp8LAhOAAaVlGl3aIpkU7Pu7e3pBOI27IJaz/1wSAB/Cg9e6FqGb7WTKjdN8fmbeRoze6gs8fBKgfH8Pv/YBACgRUd549aXn3kMcXQjNfthqGFpfSQgRtz5jyLafqSxbcBb3lOnzaiBQXqYRXYVFXnAyfN2zCAWVu
 Jd7sDUyv
 hJvisbHkL5PCad3hEtQIY8GVv/oc3IM/TxhqRI7zf0SH2UAHRM0Z6ykk198azfOLtNwJud2APBpqYZhJim/89PydODZhDID3E84RIdTCaCr5UffJY/itcCz4JTTaQz/4TE36UgTMiEvHTYfjAnKE0ReHaNoXoLKTx+Atw6gMJKfvfljWbLYiau1tsM+dcxRfk8zpTWp9vnRYlTGVCrpdCht/E8GSUubm8LdiyL9L6IXcsmVJGOD3qCPpJgYPHmsXK3DoYo7pEu2ZsnH+Qc0jjOBFn4nKx1ALnZeb+djSYXoR34Fq4ZYfmI54ELMnlbU7kmKB6BfqOgkdKqZYXr84585WrXlTgysErVUvZq9nRjeQPWjQ2a78clsHFGBWxtDa35AL9xHoQuj5WjeqZfg897W0Qdm6VhSY7zaYJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A future change will remove device private pages from the physical
address space. This will mean that device private pages no longer have
normal PFN and must be handled separately.

When migrating a device private page a migration entry is created for
that page - this includes the PFN for that page. Once device private
PFNs exist in a different address space to regular PFNs we need to be
able to determine which kind of PFN is in the entry so we can associate
it with the correct page.

Introduce new swap types:

  - SWP_MIGRATION_DEVICE_READ
  - SWP_MIGRATION_DEVICE_WRITE
  - SWP_MIGRATION_DEVICE_READ_EXCLUSIVE

These correspond to

  - SWP_MIGRATION_READ
  - SWP_MIGRATION_WRITE
  - SWP_MIGRATION_READ_EXCLUSIVE

except the swap entry contains a device private PFN.

The existing helpers such as is_writable_migration_entry() will still
return true for a SWP_MIGRATION_DEVICE_WRITE entry.

Introduce new helpers such as
is_writable_device_migration_private_entry() to disambiguate between a
SWP_MIGRATION_WRITE and a SWP_MIGRATION_DEVICE_WRITE entry.

Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 include/linux/swap.h    |  8 +++-
 include/linux/swapops.h | 87 ++++++++++++++++++++++++++++++++++++++---
 mm/memory.c             |  9 ++++-
 mm/migrate.c            |  2 +-
 mm/migrate_device.c     | 31 ++++++++++-----
 mm/mprotect.c           | 21 +++++++---
 mm/page_vma_mapped.c    |  2 +-
 mm/pagewalk.c           |  3 +-
 mm/rmap.c               | 32 ++++++++++-----
 9 files changed, 161 insertions(+), 34 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index e818fbade1e2..87f14d673979 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -74,12 +74,18 @@ static inline int current_is_kswapd(void)
  *
  * When a page is mapped by the device for exclusive access we set the CPU page
  * table entries to a special SWP_DEVICE_EXCLUSIVE entry.
+ *
+ * Because device private pages do not use regular PFNs, special migration
+ * entries are also needed.
  */
 #ifdef CONFIG_DEVICE_PRIVATE
-#define SWP_DEVICE_NUM 3
+#define SWP_DEVICE_NUM 6
 #define SWP_DEVICE_WRITE (MAX_SWAPFILES+SWP_HWPOISON_NUM+SWP_MIGRATION_NUM)
 #define SWP_DEVICE_READ (MAX_SWAPFILES+SWP_HWPOISON_NUM+SWP_MIGRATION_NUM+1)
 #define SWP_DEVICE_EXCLUSIVE (MAX_SWAPFILES+SWP_HWPOISON_NUM+SWP_MIGRATION_NUM+2)
+#define SWP_MIGRATION_DEVICE_READ (MAX_SWAPFILES+SWP_HWPOISON_NUM+SWP_MIGRATION_NUM+3)
+#define SWP_MIGRATION_DEVICE_READ_EXCLUSIVE (MAX_SWAPFILES+SWP_HWPOISON_NUM+SWP_MIGRATION_NUM+4)
+#define SWP_MIGRATION_DEVICE_WRITE (MAX_SWAPFILES+SWP_HWPOISON_NUM+SWP_MIGRATION_NUM+5)
 #else
 #define SWP_DEVICE_NUM 0
 #endif
diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index 64ea151a7ae3..7aa3f00e304a 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -196,6 +196,43 @@ static inline bool is_device_exclusive_entry(swp_entry_t entry)
 	return swp_type(entry) == SWP_DEVICE_EXCLUSIVE;
 }
 
+static inline swp_entry_t make_readable_migration_device_private_entry(pgoff_t offset)
+{
+	return swp_entry(SWP_MIGRATION_DEVICE_READ, offset);
+}
+
+static inline swp_entry_t make_writable_migration_device_private_entry(pgoff_t offset)
+{
+	return swp_entry(SWP_MIGRATION_DEVICE_WRITE, offset);
+}
+
+static inline bool is_device_private_migration_entry(swp_entry_t entry)
+{
+	return unlikely(swp_type(entry) == SWP_MIGRATION_DEVICE_READ ||
+			swp_type(entry) == SWP_MIGRATION_DEVICE_READ_EXCLUSIVE ||
+			swp_type(entry) == SWP_MIGRATION_DEVICE_WRITE);
+}
+
+static inline bool is_readable_device_migration_private_entry(swp_entry_t entry)
+{
+	return unlikely(swp_type(entry) == SWP_MIGRATION_DEVICE_READ);
+}
+
+static inline bool is_writable_device_migration_private_entry(swp_entry_t entry)
+{
+	return unlikely(swp_type(entry) == SWP_MIGRATION_DEVICE_WRITE);
+}
+
+static inline swp_entry_t make_device_migration_readable_exclusive_migration_entry(pgoff_t offset)
+{
+	return swp_entry(SWP_MIGRATION_DEVICE_READ_EXCLUSIVE, offset);
+}
+
+static inline bool is_device_migration_readable_exclusive_entry(swp_entry_t entry)
+{
+	return swp_type(entry) == SWP_MIGRATION_DEVICE_READ_EXCLUSIVE;
+}
+
 #else /* CONFIG_DEVICE_PRIVATE */
 static inline swp_entry_t make_readable_device_private_entry(pgoff_t offset)
 {
@@ -217,6 +254,11 @@ static inline bool is_writable_device_private_entry(swp_entry_t entry)
 	return false;
 }
 
+static inline bool is_readable_device_migration_private_entry(swp_entry_t entry)
+{
+	return false;
+}
+
 static inline swp_entry_t make_device_exclusive_entry(pgoff_t offset)
 {
 	return swp_entry(0, 0);
@@ -227,6 +269,36 @@ static inline bool is_device_exclusive_entry(swp_entry_t entry)
 	return false;
 }
 
+static inline swp_entry_t make_readable_migration_device_private_entry(pgoff_t offset)
+{
+	return swp_entry(0, 0);
+}
+
+static inline swp_entry_t make_writable_migration_device_private_entry(pgoff_t offset)
+{
+	return swp_entry(0, 0);
+}
+
+static inline bool is_device_private_migration_entry(swp_entry_t entry)
+{
+	return false;
+}
+
+static inline bool is_writable_device_migration_private_entry(swp_entry_t entry)
+{
+	return false;
+}
+
+static inline swp_entry_t make_device_migration_readable_exclusive_migration_entry(pgoff_t offset)
+{
+	return swp_entry(0, 0);
+}
+
+static inline bool is_device_migration_readable_exclusive_entry(swp_entry_t entry)
+{
+	return false;
+}
+
 #endif /* CONFIG_DEVICE_PRIVATE */
 
 #ifdef CONFIG_MIGRATION
@@ -234,22 +306,26 @@ static inline int is_migration_entry(swp_entry_t entry)
 {
 	return unlikely(swp_type(entry) == SWP_MIGRATION_READ ||
 			swp_type(entry) == SWP_MIGRATION_READ_EXCLUSIVE ||
-			swp_type(entry) == SWP_MIGRATION_WRITE);
+			swp_type(entry) == SWP_MIGRATION_WRITE ||
+			is_device_private_migration_entry(entry));
 }
 
 static inline int is_writable_migration_entry(swp_entry_t entry)
 {
-	return unlikely(swp_type(entry) == SWP_MIGRATION_WRITE);
+	return unlikely(swp_type(entry) == SWP_MIGRATION_WRITE ||
+			is_writable_device_migration_private_entry(entry));
 }
 
 static inline int is_readable_migration_entry(swp_entry_t entry)
 {
-	return unlikely(swp_type(entry) == SWP_MIGRATION_READ);
+	return unlikely(swp_type(entry) == SWP_MIGRATION_READ ||
+			is_readable_device_migration_private_entry(entry));
 }
 
 static inline int is_readable_exclusive_migration_entry(swp_entry_t entry)
 {
-	return unlikely(swp_type(entry) == SWP_MIGRATION_READ_EXCLUSIVE);
+	return unlikely(swp_type(entry) == SWP_MIGRATION_READ_EXCLUSIVE ||
+			is_device_migration_readable_exclusive_entry(entry));
 }
 
 static inline swp_entry_t make_readable_migration_entry(pgoff_t offset)
@@ -525,7 +601,8 @@ static inline bool is_pfn_swap_entry(swp_entry_t entry)
 	BUILD_BUG_ON(SWP_TYPE_SHIFT < SWP_PFN_BITS);
 
 	return is_migration_entry(entry) || is_device_private_entry(entry) ||
-	       is_device_exclusive_entry(entry) || is_hwpoison_entry(entry);
+	       is_device_exclusive_entry(entry) || is_hwpoison_entry(entry) ||
+	       is_device_private_migration_entry(entry);
 }
 
 struct page_vma_mapped_walk;
diff --git a/mm/memory.c b/mm/memory.c
index b59ae7ce42eb..f1ed361434ff 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -962,8 +962,13 @@ copy_nonpresent_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 			 * to be set to read. A previously exclusive entry is
 			 * now shared.
 			 */
-			entry = make_readable_migration_entry(
-							swp_offset(entry));
+			if (is_device_private_migration_entry(entry))
+				entry = make_readable_migration_device_private_entry(
+								swp_offset(entry));
+			else
+				entry = make_readable_migration_entry(
+								swp_offset(entry));
+
 			pte = swp_entry_to_pte(entry);
 			if (pte_swp_soft_dirty(orig_pte))
 				pte = pte_swp_mksoft_dirty(pte);
diff --git a/mm/migrate.c b/mm/migrate.c
index c0e9f15be2a2..3c561d61afba 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -495,7 +495,7 @@ void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
 		goto out;
 
 	entry = pte_to_swp_entry(pte);
-	if (!is_migration_entry(entry))
+	if (!(is_migration_entry(entry)))
 		goto out;
 
 	migration_entry_wait_on_locked(entry, ptl);
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 82f09b24d913..458b5114bb2b 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -235,15 +235,28 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 				folio_mark_dirty(folio);
 
 			/* Setup special migration page table entry */
-			if (mpfn & MIGRATE_PFN_WRITE)
-				entry = make_writable_migration_entry(
-							page_to_pfn(page));
-			else if (anon_exclusive)
-				entry = make_readable_exclusive_migration_entry(
-							page_to_pfn(page));
-			else
-				entry = make_readable_migration_entry(
-							page_to_pfn(page));
+			if (mpfn & MIGRATE_PFN_WRITE) {
+				if (is_device_private_page(page))
+					entry = make_writable_migration_device_private_entry(
+								page_to_pfn(page));
+				else
+					entry = make_writable_migration_entry(
+								page_to_pfn(page));
+			} else if (anon_exclusive) {
+				if (is_device_private_page(page))
+					entry = make_device_migration_readable_exclusive_migration_entry(
+								page_to_pfn(page));
+				else
+					entry = make_readable_exclusive_migration_entry(
+								page_to_pfn(page));
+			} else {
+				if (is_device_private_page(page))
+					entry = make_readable_migration_device_private_entry(
+								page_to_pfn(page));
+				else
+					entry = make_readable_migration_entry(
+								page_to_pfn(page));
+			}
 			if (pte_present(pte)) {
 				if (pte_young(pte))
 					entry = make_migration_entry_young(entry);
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 113b48985834..7d79a0f53bf5 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -365,11 +365,22 @@ static long change_pte_range(struct mmu_gather *tlb,
 				 * A protection check is difficult so
 				 * just be safe and disable write
 				 */
-				if (folio_test_anon(folio))
-					entry = make_readable_exclusive_migration_entry(
-							     swp_offset(entry));
-				else
-					entry = make_readable_migration_entry(swp_offset(entry));
+				if (!is_writable_device_migration_private_entry(entry)) {
+					if (folio_test_anon(folio))
+						entry = make_readable_exclusive_migration_entry(
+								swp_offset(entry));
+					else
+						entry = make_readable_migration_entry(
+								swp_offset(entry));
+				} else {
+					if (folio_test_anon(folio))
+						entry = make_device_migration_readable_exclusive_migration_entry(
+								swp_offset(entry));
+					else
+						entry = make_readable_migration_device_private_entry(
+								swp_offset(entry));
+				}
+
 				newpte = swp_entry_to_pte(entry);
 				if (pte_swp_soft_dirty(oldpte))
 					newpte = pte_swp_mksoft_dirty(newpte);
diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index 9146bd084435..e9fe747d3df3 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -112,7 +112,7 @@ static bool check_pte(struct page_vma_mapped_walk *pvmw, unsigned long pte_nr)
 			return false;
 		entry = pte_to_swp_entry(ptent);
 
-		if (!is_migration_entry(entry))
+		if (!(is_migration_entry(entry)))
 			return false;
 
 		pfn = swp_offset_pfn(entry);
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 9f91cf85a5be..f5c77dda3359 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -1003,7 +1003,8 @@ struct folio *folio_walk_start(struct folio_walk *fw,
 		swp_entry_t entry = pte_to_swp_entry(pte);
 
 		if ((flags & FW_MIGRATION) &&
-		    is_migration_entry(entry)) {
+		    (is_migration_entry(entry) ||
+		     is_device_private_migration_entry(entry))) {
 			page = pfn_swap_entry_to_page(entry);
 			expose_page = false;
 			goto found;
diff --git a/mm/rmap.c b/mm/rmap.c
index e94500318f92..9642a79cbdb4 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2535,15 +2535,29 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			 * pte. do_swap_page() will wait until the migration
 			 * pte is removed and then restart fault handling.
 			 */
-			if (writable)
-				entry = make_writable_migration_entry(
-							page_to_pfn(subpage));
-			else if (anon_exclusive)
-				entry = make_readable_exclusive_migration_entry(
-							page_to_pfn(subpage));
-			else
-				entry = make_readable_migration_entry(
-							page_to_pfn(subpage));
+			if (writable) {
+				if (is_device_private_page(subpage))
+					entry = make_writable_migration_device_private_entry(
+								page_to_pfn(subpage));
+				else
+					entry = make_writable_migration_entry(
+								page_to_pfn(subpage));
+			} else if (anon_exclusive) {
+				if (is_device_private_page(subpage))
+					entry = make_device_migration_readable_exclusive_migration_entry(
+								page_to_pfn(subpage));
+				else
+					entry = make_readable_exclusive_migration_entry(
+								page_to_pfn(subpage));
+			} else {
+				if (is_device_private_page(subpage))
+					entry = make_readable_migration_device_private_entry(
+								page_to_pfn(subpage));
+				else
+					entry = make_readable_migration_entry(
+								page_to_pfn(subpage));
+			}
+
 			if (likely(pte_present(pteval))) {
 				if (pte_young(pteval))
 					entry = make_migration_entry_young(entry);
-- 
2.34.1


