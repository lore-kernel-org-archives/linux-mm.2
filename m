Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F674CD8CA8
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 00:16:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 316496B0005; Sun, 14 Jun 2026 20:16:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A0526B008A; Sun, 14 Jun 2026 20:16:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 140AD6B008C; Sun, 14 Jun 2026 20:16:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F3A386B0005
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 20:16:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9ECF61C41E5
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 00:16:57 +0000 (UTC)
X-FDA: 84880231674.18.15D4BC7
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012062.outbound.protection.outlook.com [52.101.48.62])
	by imf27.hostedemail.com (Postfix) with ESMTP id B95D84000B
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 00:16:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=tV9YBYdj;
	spf=pass (imf27.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.48.62 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781482615;
	b=MqlhyzZRMwN3c+LpCIGEplJUUArEojtbNI8WsnNw29wHhFo5qIcXyrX3EOF1/+XELQ5lX7
	+5VT664TmCR8GZ/ItA/Gr84N0LIEoKiQ+xd4pdaVbZR4NfI5gbX1yVN1nG0wI5Wn7eZZSJ
	qzZ2/TdkVITXgVKSo+T61hZxzLApmJI=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=tV9YBYdj;
	spf=pass (imf27.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.48.62 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781482615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IsvmiMuXmpOcEyJjEd3gqK54xf+nXDz6FZ9/ZIK5T2A=;
	b=iA+mlxYeTGlg6RFv1/NUXH8y023aycfICrnz3RP7FKIgtxPJz3f3cRNcrVa2pe6oQayI+Q
	/UKAJtoFPTNhGhniaeKKt6mGQfQcyRcW0CbyYNOjRZA9DTYez5fhZBn0xx3X9GD3qwSY9Z
	7g2aRREwc12MUK+YC6jZ4IuERy8RLZk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EUBmEn7mmw0Ec5Or79Q3CQoprmEGqPdOnRsUyIv41JGpF/bbnXNQw69pBqosbRg9XPVnoLlVvkh8fSK8eyS9dsR+fZc85TR6WUdqN7KGdXB6tOux3R3vqpr+x7Q38wPTdytPnK0z7Bl3SkZeJgQFgZLei/+zi6+sR+euAWhsff1p16C4hgT9sNk6+k+qgqPkMmTaaQoLAYom+mndaQsFElbPm9MwK+o+76xntau/hQDMYmTWxPJwvC4VUm7a09iw/5ZsGzwSSBitYxVNpx13K1ugmjhfmS7HgIy5kA5mm4zDc5X438HSOJZ4wMFcNVm6VL2BPKPiBg2LIDRR8pDkeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IsvmiMuXmpOcEyJjEd3gqK54xf+nXDz6FZ9/ZIK5T2A=;
 b=aLPt/Mg6B8K8p7rt5HJHulGyEtPGGHYbyRG1g6KdPKuJFfdRBjGJD6gwa+dH7FXoyY5kLf0v4ylZiiaGYoaqRpT8j+uD9BWSJ9xqwAtmNEcUy0+Hjwaoj0ez9sY8DK3DOO5eWeCkqwTWZ8qEiHqRvRm9E/bispMmNMxYNYZzvk/c+Nmgv76d+pLXD7Bj0SpwNKCgydX1rYZ/drOycDJGkbBOfE0KMm+U7l/y5L7tWUDdo23IZMIxw0Fj4QzV8cLqLE3DybzJYBYvB7yGv1TiLFu+t69m/InJiNL7sKfpGPJQbzQfLEM4G3oP54lGkyWbrjGlLYzznzTizFfg7iVQ7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IsvmiMuXmpOcEyJjEd3gqK54xf+nXDz6FZ9/ZIK5T2A=;
 b=tV9YBYdjQO/4ZkQ1xc4RVXao8yOLUCxj2UOTRDx75dCfAyY8qzEW69SbKXLFhUChFuptMAEmdhEWX154ub/tIAJ6AasQannV7ON70uPSeqD2N8Y0w0RTFV0psDuNJAC6MX1uj69pHzzmTotUQA3CTdkioTtaC4aA+2GGYWuVkdkJQ49ipdqNnDJd1AKBRht+B3uWRgmvfIP9lOG1yQk8DP/fUvra0ARbVVrxCmGc5iakmM9LnHhbjT6MHUrrKqnjtATq1Tw+648duqTHVZilqw0TDcCP57NGsOotKsjyz5FtKThJ6oJTwuCMayv9EE4a3ab086gJnCeUNt6c9paW2g==
Received: from CH2PR12MB5001.namprd12.prod.outlook.com (2603:10b6:610:61::18)
 by IA1PR12MB6652.namprd12.prod.outlook.com (2603:10b6:208:38a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.16; Mon, 15 Jun
 2026 00:16:47 +0000
Received: from CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe]) by CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe%5]) with mapi id 15.21.0113.015; Mon, 15 Jun 2026
 00:16:47 +0000
Date: Mon, 15 Jun 2026 10:16:41 +1000
From: Balbir Singh <balbirs@nvidia.com>
To: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Ralph Campbell <rcampbell@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Alistair Popple <apopple@nvidia.com>, Alex Sierra <alex.sierra@amd.com>, 
	Matthew Wilcox <willy@infradead.org>, Sayali Patil <sayalip@linux.ibm.com>, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] selftests/mm: allow PUD-level entries in compound
 testcase of hmm tests
Message-ID: <aivB1jLODH1W_0yt@parvat>
References: <20260611034102.1030738-1-aboorvad@linux.ibm.com>
 <20260611034102.1030738-2-aboorvad@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611034102.1030738-2-aboorvad@linux.ibm.com>
X-ClientProxiedBy: MEWP282CA0100.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:1cf::20) To CH2PR12MB5001.namprd12.prod.outlook.com
 (2603:10b6:610:61::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB5001:EE_|IA1PR12MB6652:EE_
X-MS-Office365-Filtering-Correlation-Id: 8cb3cfab-7916-4042-4759-08deca736358
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|56012099006|4143699003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	IsZzQv76lRQzUAkQbQkQpO6e+LqmN5om85hDONUN40nBqI+aGaGpqw7ryinxsV9JJNyZMsprF5aef06prMAokg4+Yi749e/2srJpV5d9kuUsJZUdwPrxMB4CP4iOm7HyFmg0JK3eHV2Vb1pJbiX/MZNP875xvc3Ty3miXyJNjCYJXuM4F75saJ1gOGGvbhyFmQ6bPDguKCGFfevee/KoFHSKjYAyDDR3m8ovURjGewW40PvUruOEUExyvsOExQPN50AZfQhLRueIpIyuREhApAGxQpPEMUMDCD+qHvr6hRDR4IwmPHyfReSKZsKJQv4G5yejP7xf5xyAeW6Ar5UwXI1pYAd5ZrgYoHFAyx5pa+YNdjmPJvjrZ+rJe9yxISCpUaWHf949DbHgvYynd4NqBiymILHkVnQ194YvOkRPMWbJzloc0uMcB1u6xDcdsCcX8rQeILP0PJqAs8jFSXn7Ny12DuDFgng7uGyrUJ5zKZNK87I2alZ2V4TfqkWgfSWreCfUs2lZusLvjnBKnRTRXfuK5VwaF3LeGIl561D0+CgkGOwuZJJAjA+7iEJ2H8uoVdDFICs5DdpKaC/WudIb4gCK4Qb5ZTcmM7OPKVm9R/L+fYGEEAqT8fiL/vyMNTmVfYLNioIFcNzI2rj6aSPpNA5QOPHv2wO+7gCwsqLjJsAR2SApfXAbZJi2LwYOT5bd
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB5001.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?80RMFtVfY6fBbzGSokrJjxRGCTwJ0n7cPEmnsUjJDgBZnw/gL4H4Ssgx9CwZ?=
 =?us-ascii?Q?5cd1XidMM5Gkr+F/Tsot6MdoZ1vcQdiXx/MAoHGT7qgBifv5B0RUX9u/LTx4?=
 =?us-ascii?Q?soiMJFHaH++FeyzISqHowcjJ+IEdyZEL4pteV3rG5kFxmQ068xNN6YduYYWB?=
 =?us-ascii?Q?d1TR7dvo+/a02kjwsyTAavarkduop+/nqeMjf3SDm3MfpKMtZ+VWzFTHKBth?=
 =?us-ascii?Q?Wn3s3Kfd64NO9obLMyPdskJ6vCTHdmqDUtamPhTnddfQ1SHQmiUNCKS8SKES?=
 =?us-ascii?Q?19Ta3+g706mn9Pdo5vMJCUN8hGDhMKChD2UbrH55vmIfvgskjwHBbmQcNEeS?=
 =?us-ascii?Q?DrWlCcTEbzToQNm6j6d4jDnAnr6Fy0Phv7WplVIYwBmIvjDvjGBmMg/dbBOu?=
 =?us-ascii?Q?UYKasdtOrUy6oyvtUz3KxrcY5VFqhZQWEZ2e7XZLg+9peBPwLV32IvP6ATdN?=
 =?us-ascii?Q?xOn9GLokWaxeb4UlUPu+701dxu9Sq8mkgTj9RXJ1dsrqZSGp/c2VtvVjz2OP?=
 =?us-ascii?Q?O++PQglbST4ZQXKzPnzjqy1H73YunhwhZfsVvOHoFBoi5cSf8LG8+CC3AAGn?=
 =?us-ascii?Q?44kdLs8hC1UpUPGwZypr8+AGB7gH9d/+ZQePgX1WRpZJRdYDFdFbWgh/GXyo?=
 =?us-ascii?Q?aOHfpnyowas0IUZG6AZwxGRDP3nqo51uduZFKUZMmLZfGUUiMr7R/zbRJSyV?=
 =?us-ascii?Q?elJ59XFua8ZHieE3ro59abTxnQAjQ5mj1V54wplbaFgin2YPQNbAcOTd3G0k?=
 =?us-ascii?Q?LcxYIosIe0gtuRFwN1IVDn++nUymjLQ0oDR+wEn3u/wl9vQeovWotUF+d0be?=
 =?us-ascii?Q?W/utZMG9PYf0aUEe+Occ2VdQniXEHf0jB3X/mT6ATD/8un3HfqWBcq3r5Kd1?=
 =?us-ascii?Q?ejxogGboP6/B2W+1fLnydzg+B0QU1SZt+kpqBa0V+KkkohNp2E8HREGzdWTr?=
 =?us-ascii?Q?ObVEYcHiVfSiY/tV+4Nn/4lWQcsZUchf6RqjA32Q4kmlTyTOI9PLHtMUM2yM?=
 =?us-ascii?Q?it3/EO1TENyrIGuC02rGBVWRxlxjrEM2IQaWIe8sRT9UT+9ILB1+OCx72H7+?=
 =?us-ascii?Q?v1Dzij9NedbfBUaTf/SKcCATMUI+atvBPes44z7FX7a0q+3qBNqYqNImD5TC?=
 =?us-ascii?Q?nY4DGr5Ycwr14MHNtQn1UkWK2DNDVPEqCS8Y9cPFOAiY7lA2fihiUWPAp/xZ?=
 =?us-ascii?Q?dY2KBblHxID6MzsIRRBwCwuv9QPvKmppbxzHLUNcSv1nXYdICPaABjoBp/CR?=
 =?us-ascii?Q?vcTcE98ho4RIO7T5vpHC/iIy8K7qos3s9SCbiS57+7trktlLGVz4dBEIPgdx?=
 =?us-ascii?Q?cJmkFTFHm4um37tHr9ILmWXUVjLESXRwJ9NEydd6JjICDwCY1f8AxXiVbcU+?=
 =?us-ascii?Q?P2ktTBckrE8HYHmWhrtlSiwJGUic6IfGH/+U6UMCbeAIEvH4Jsil5t4HSVrc?=
 =?us-ascii?Q?t3TQAYgxmCH7dMj1zODJ2t00MAI2iwcWZNwz7pyXCFbfxNOaTvXd5GWuJPHV?=
 =?us-ascii?Q?KUwmkgzpCw/zhzCxHg/FM2S20wmnRq2tX49ki2S6UK/h+6vPJwxJ4F3qRzq3?=
 =?us-ascii?Q?AHF54zlQUwaPP0PXDPCRR/fzs/JQFiFWGv+Qfu+NYQkDjw9IAi/3J2DOmsBP?=
 =?us-ascii?Q?lmuS3ARSlTRPi8sSx4XhSdAD9pECIavzz/tSyrrfFPKZoViOJ81/4E9KrDsD?=
 =?us-ascii?Q?NQJgkfuPHCGPRmUB/7I0ea3OkyL5O9NucKZpIiJlrjYXWF1Unq+Hv3CF+i9S?=
 =?us-ascii?Q?bx0BBAlzAw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cb3cfab-7916-4042-4759-08deca736358
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB5001.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2026 00:16:47.2174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 55dNAUjIEbkppSnTxnG35cP8kKitGK/6j/DasgOlH3c2l4GSe663uUWcrGR9rMu0ERAIv0uJ5OUDmZwR/YusZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6652
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B95D84000B
X-Rspam-User: 
X-Stat-Signature: 4ke9m49qhd8usqrnygsja33dyqtx7iyi
X-HE-Tag: 1781482614-739832
X-HE-Meta: U2FsdGVkX19mWnhzIfrGa3RZ2rUCWAfIT+2W594laKHKso3/oNPu1aSJZZsTxTB9tAWpKAqRKJD9wC3ad3dCyajbUwaBte4O/lwPIpy4/5RgnF+lKNqp/N3YlaF8LBUrzi6uwU900G242IMWL6iAsdXqUhWxCWDgVF87mi2/0p2paF1cTENMuKItFc4VEj6+BxzbwOwgngPZMHeN5xLCrf3+O/Ua9m1X9gxxKUQsk77OzhUHuxvwpjnt1/b0rYkBOwd9z+gBuegueK5VlPVwukFtrHZQZaDvs7fYb04akL18dum9FzkJmZKXxEorFVKvNcejkdbzfGH3p5fumFrOFQf26M/ssp+e50q+dm4l4uSH/oJ+qN3k95VLPRFWnOYt7m/6r07l51UJzxkLBYvVC9ZjK6Ad8MVfp4xabC31RY2DBlFDH6wkDwPNZppfqMeXjMAAt9ZIwQmgs8zcdEMjCD+s24ucxemysLiDwmWeVFREK/ruqE7JuLBbBuNrZtYQXz7NPshxHr8nmu67QrVHOcvAcmz+WMjbKUjqecBxBc/DjBmH/vynhIIurtLX3uE1EK3kpTUoWPABuKuytonlRPi1D8yGDcAyrjPtzWRHtl7ynXw3R/6JbjPclm11moHUyFyPinMxszPzGz6lMGP1b/muNeU6CrMu/FFNsr0mLRbdxiLxNSKHsBnBKhSiZHMQi1HIgGbkVxF6A9hsIPuJmYIWoR5M9njYc/ag++RSk1AeUWs7TvlLDu0OU26TN+tOqMvmXNr9p5Fry8aYHRp6pGxSpt5LD57V1PkAECbFX5kUDXaRP6rIgDTZU9ily5j2Pp/7un+PpHg7t8ANMBDuWBo34Z9nG6cL/OM8fJC7Nu2+QDDmGuEaN48mRDXtQVS5arAyqfyX0qJvn55iDBE4li2yePH97yykhvcEmnpyhnc7DI2ly/ZhIQyjkntlC7cLbNNAV/hsyW6cbx3RrF8
 WHe5kqc6
 2RenWh2d509pXmi6BnIviPDmyGNduYv1bY1cUswvIQzo4PRcxSfDsr+kk3Ha8VafqjJ/xINb4Q6N/M8MOQU+7BInHTQpv9No+thsS1B5xnbkfv91HtpTFY43hDhKsNJ1FDwzexLYF/SCLM9X5anVbJT2h0QK3+Z9qHlZKpV60TZQi15saYrLndLbp+/fMZPmh2dHYYSnfFeEeSLlrJGKhvM6RLSIF+DM7DoINEPyA1wsZxu+tH/DrKMuwo9eN87Mt3MjERTGruui2jt5lhb7HdU+XvdG5pWviQxbbkKabUlaTn73v5rzdy6JHS3XGrJY7sMNhRkJID1iWp5ViwZF+rwz6BeE9McIB8vuog9xRpkYRg/2FUszTHfrwdDNLGwKthBIRZf8HzBX4VPZXx/98TtJukDuHs0PY8j+Ad/PP+1yAurszPe6u35JeYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 09:11:00AM +0530, Aboorva Devarajan wrote:
> From: Sayali Patil <sayalip@linux.ibm.com>
> 
> The HMM compound testcase currently assumes only PMD-level mappings and
> fails on systems where default_hugepagesz=1G is set, because the region
> is then reported by the device at PUD level.
> 
> Determine the mapping level (PMD or PUD) the device reports for the first
> page of the range and require every page to match that level exactly via
> ASSERT_EQ(). This accepts PUD-level mappings while preserving the
> expected/observed protection values printed on failure, and rejects a
> fragmented mapping that mixes PMD- and PUD-level entries within the same
> range (which a per-page OR check would have let pass).
> 

PUD is not supported with zone device private folios, the fix should
be really around default_huge_page_size(), using the default pmd size.

Balbir

