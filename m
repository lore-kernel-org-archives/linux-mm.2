Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03127D609D2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 17:19:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57A8E6B0005; Tue, 16 Dec 2025 12:19:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5289C6B0088; Tue, 16 Dec 2025 12:19:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FC406B008A; Tue, 16 Dec 2025 12:19:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2E44F6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 12:19:56 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B387013BA13
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 17:19:55 +0000 (UTC)
X-FDA: 84225996750.05.C0BA0DB
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012017.outbound.protection.outlook.com [52.101.43.17])
	by imf01.hostedemail.com (Postfix) with ESMTP id CC7FB40013
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 17:19:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YF7U4fgd;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of jgg@nvidia.com designates 52.101.43.17 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765905593; a=rsa-sha256;
	cv=pass;
	b=TrB2CUvhipCP8mD92tauCLDNEA0lz0hPafblnCWlS0TeVYKhPLEBpAdCkpQKL98d4hshGU
	AHtSyvo7QcW58fjmMNuUULZjSO2kvpSXc2idOyLtG0uPBQ/8OCr6mDP4Er/h4ArLgvA7/8
	DQkc0UrWdw1k26YR+ZD5D4wJ6LFR+aw=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YF7U4fgd;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of jgg@nvidia.com designates 52.101.43.17 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765905593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SEENmMoqfzX2s3shDmJjxDv6QpfaIwKKdKvlqNMOv1w=;
	b=Y4Ma9/z7PjjI9rY90BX6o3hVwhh0WEsetYUOM5zMeXSTTMWNP6AHDYar97qFpXQlJuk7k4
	S4z98HNEjOiBdsgjpWoJa/5hVtSSWnTkSFEcMfjNLV8nuxOdOP4BhRhVSd80H6EL77LRI1
	kf3s3Ctq6rz3AnVQmkGTpiK9iGDr8u0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E8ixqt5vCUOFbCmX5ZNb2E97ZR0uBlbcjd24a6/lpL7/uXzUfSRI/J3bTx8qxiQGpF23mo94Vj8PS0PiCxwEDZGAEbIqyl4/KUONSSScgcS9ezCUnXVR8wKB3v+fRHL9KY5Y4VKPFDrJuWf5Edm+dhTaFy1n7OYNzFSjGK/Rv05IlApet8ECvJopmEESlK9O6l2o5o+VTOAn8aaj8fGN4Z45JU2exXRX5HgPMEtE7TnXqxKUHcsYXhlRZs6Lls7kzzwfds9CSSiGNlW05TsihsByjjvuQ+qDMOy3x423qJ0twsQXJVlpX4xEzLlfHeoB1rH5OYomCLvmrfSVdJVluQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SEENmMoqfzX2s3shDmJjxDv6QpfaIwKKdKvlqNMOv1w=;
 b=VWog7j+rHLCgFCZYyp8VduHy2M1yCQU0Zr44gSKdcDAblsqkoyrfAIC3gXkMuXjlhvWoC6R4lSxf6aubCllwYGR674UojbrVtk9UT0B1yFyuAwH/CLldArPAzKazVx9iS8zUwIds8PUAxFepz+HI6xqRe+0zPReEr2gc5nkcBMJBr4N+S7I2E+3mixEitutgIjbM5B40RXXoqrD12uiWBV4p+fcB/Ytsy2aSxzNPVAnwrVnedpJNXXJ48B1bd3TEoWHHQzTGqHwsPWsQOdyATkHD03n5NPDeiVu0EvJntUXm9hkTbQ3215IDClqo4N68OyNiVpLeNHiOUM9GUrgkzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SEENmMoqfzX2s3shDmJjxDv6QpfaIwKKdKvlqNMOv1w=;
 b=YF7U4fgdJmqpIutoMs0B0EHfa3KzHTgZhD6ZgeT3GUTmpBvgfaBhWjY3K9OYqI54cQmiJ8w/2Ycqvthd9IuGu+cm1xM+F3QzSRdV3GkfNRLQxahF1h9rimWu87UvNGD05m99FLS0p2GbysRe6xfmm5+mZ8UMM7o8CDXlkI4Hz/nk3uNC9xr3qYQYyrrq4tVzZxV9hoReT2Hv+L8tXvnoZmCLW6rOv8UWdnT4BT69DOzAKDmSHgfZ2/j2VZwx9xUiPn7PFjTAtr7vfvLwAe2rgeAit0i66In0N8K5xELXoiEaIaLL102fkzWY/njIg5ksbp1OzoPXUaPttnC19jlZbg==
Received: from CY1PR12MB9601.namprd12.prod.outlook.com (2603:10b6:930:107::16)
 by CH1PPF6B6BCC42C.namprd12.prod.outlook.com (2603:10b6:61f:fc00::612) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Tue, 16 Dec
 2025 17:19:46 +0000
Received: from CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3]) by CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3%6]) with mapi id 15.20.9412.011; Tue, 16 Dec 2025
 17:19:46 +0000
Date: Tue, 16 Dec 2025 13:19:44 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 2/4] mm: Add file_operations.get_mapping_order()
Message-ID: <20251216171944.GG6079@nvidia.com>
References: <20251204151003.171039-1-peterx@redhat.com>
 <20251204151003.171039-3-peterx@redhat.com>
 <aTWpjOhLOMOB2e74@nvidia.com>
 <aTnWphMGVwWl12FX@x1.local>
 <20251216144427.GF6079@nvidia.com>
 <aUF97-BQ8X45IDqE@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUF97-BQ8X45IDqE@x1.local>
X-ClientProxiedBy: SJ0PR13CA0044.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::19) To CY1PR12MB9601.namprd12.prod.outlook.com
 (2603:10b6:930:107::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY1PR12MB9601:EE_|CH1PPF6B6BCC42C:EE_
X-MS-Office365-Filtering-Correlation-Id: 09c1a2bb-3baa-4d36-53a3-08de3cc74f31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lv2ANLyfbM9S79lEApsLt9x3mb673jol72aE2m/kafloEIEbaHgObKlZB9vR?=
 =?us-ascii?Q?ymVP7yKYBUwcVklLJ13kJDIJs9pUWeG4wMgYlPoX6bWrAFQ0XWn6NxHtcdhH?=
 =?us-ascii?Q?/FdFemxKDDx1Y/quXIrHnj81IoYwUFt4diU9LnhxZV80pMcQIQzaWWew0J1y?=
 =?us-ascii?Q?udi4iRKpWMFmO7G43H7se+aKuZGOzFOAHdayZvqx1Xx46pqnLrsDklEOoNm6?=
 =?us-ascii?Q?bhYqzy8U0j12hxdPuVjkawT7+EUeIT3fXwmtaCaFL7FeyA1TbDdE7Cso4oB5?=
 =?us-ascii?Q?um/U9juWrWRzCjMll0PTZo7tgF4SEM2nxrT+1TqI9PuoLbYJD60Y8TXxVc6n?=
 =?us-ascii?Q?9XPm0KDhqR1pB0JOwhJ4TZEoVn7K+Y30mnKLJ9APjBTfTk11qiUu7UyVkHVJ?=
 =?us-ascii?Q?tCfKpqt+Zn7e9LYsg5yQiadEG6zdVYyagTZCWz/P1W3zl/rfDAhwI33ZNTfd?=
 =?us-ascii?Q?tpAzBLAihw1dVJRshqinsZIYubfNlowxxh3/VMH0p0WtMaL8MnCpxCHFM2FK?=
 =?us-ascii?Q?E64Bee5qB6M4JCjzGrUGsNjNo1vrKiNfddM4sehXTEFEKtpdK0I1tM5JNWtO?=
 =?us-ascii?Q?25kWNVTEl/jbXiPonGyuGWTCkOoerd/EvZKoHhUjToO3L0IWfDBLZGr6yt2+?=
 =?us-ascii?Q?Pq6S8Db9Ftilaj8jtakJVYMJLjElOjsKGgHmJ+CxPq0VCsqhDAcPn/DPbVh4?=
 =?us-ascii?Q?ffM61DB28GON0EdT2L2GgmC155c0ygczfDM9eyEde4X0bwppRgZtEzkki5pN?=
 =?us-ascii?Q?bm4jrlKV0HcBS71eNpnY1IMFx7oMsA9XO2u1jFxHT0/HBPPSUZfz1kNkQWUM?=
 =?us-ascii?Q?TV1S26afZWzzbdLg+QnOy4QMbvXPEhgfPLT3ppyuHXNKNG9vWZbjNMWx8HOE?=
 =?us-ascii?Q?qlArk4uEPyMaULjnB4pbI5uEU86Pof0oozTqbmTLOuqftIbKeWF95TD9woLs?=
 =?us-ascii?Q?Au6FTeUn51Ra5qMqjvL/pIaPeMMRb4pxDgQL2ApN3WSinCdDUXN0DiA5rfVd?=
 =?us-ascii?Q?9wVvk6L47HDV/fxnBq4910Rqz2I3ohymJhQ16hNCadL+tL7SNZWD7gMfJBJU?=
 =?us-ascii?Q?M0ntlkOpT6l8F6MbgfBNNXpZ4dJM1Qip3eCIALj4eZUePcuKDV0InT7YkteG?=
 =?us-ascii?Q?pS00C7XK6HIqxzD5KBl7NQRvW9hfTgrHW5F9MlncniH9Kjq1H4RM+yyj2qWu?=
 =?us-ascii?Q?xe76pbRBFDUuctw/AojYf5ixyrIOz2n3TfLLr+5cAz9IR/YPxXislL+h+VAF?=
 =?us-ascii?Q?xCyRqHnn4x3c4TKV3jCkorWLJQZMcUidREoxAtgcJS4Xspq7Yp78sDey+qB5?=
 =?us-ascii?Q?Zve2iTToTIVqTbzgJUyfFfq2HtTJWtlcuJ59CtnBWt4crqgCXRjsCfV8Utm8?=
 =?us-ascii?Q?CwQyaSGJieABZ0vxi5SlCuFDdtYBoKKrtoCrCScDol5pBu7z3eK1payZDM/U?=
 =?us-ascii?Q?Y9R6MXsWAhpF+nEC68dHT2KrzOTbby53?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR12MB9601.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jpEyvrkVxS45+QxkBzp1764KedY30sDy7HZr7Jdu+UkV1Kq1QB4ycTEnHuc6?=
 =?us-ascii?Q?BF+osS6b13tR9USXxsA4k38KtEc75pZ0SOgsbFOtHBil2W18K6RmvnvgF7A7?=
 =?us-ascii?Q?Ql64yZHyzKNn0DKwgnxIOPJvXckSVHtIv35joC4/7S1ssl66yG4LcIAuVepd?=
 =?us-ascii?Q?0qu+/Km72dDIL7buWHEkrkAs95QYdeYGQlPpar2J9oj09SLKHEM4Qx2PuJt+?=
 =?us-ascii?Q?WXxRLBZ79Tlwlj2CpRWXJTANvkvRMORbZ5V4Stg4pZoh7M1RswPSz+RTcmvT?=
 =?us-ascii?Q?hczSPN3A0D+lOGAr3MHwEDin7S1zsb1sKsKAdx5KbgFhPHztRs/QUpyHNH4Z?=
 =?us-ascii?Q?ykgBpw06j98+T7ZiC9qnWK6rQLbwOCxG/yRus49WUxSHpDFP6dRMtR1GWbpu?=
 =?us-ascii?Q?JC6pqyeJujJKAcoGYArNDMEMArVyfMJ1hCOZrWq8dWGiPDIHb3q8x1gbkvPV?=
 =?us-ascii?Q?QBlLCMJJ3TACIUQJjXUoe83rf90hHJTvZazQrru8PNVlvIqB4Ndu7po7By6b?=
 =?us-ascii?Q?8KMX7s/VEk+4mvvgaUVOJoxTOb3czi/lTYfKKJe3LcWxo3jDO5N4T0vBW+Hp?=
 =?us-ascii?Q?tWxUNqsM6ja5vl+m4cLJUgJZvLwGZLb614Z5tbIa1qf4e+8RXUzyCoSNA6s4?=
 =?us-ascii?Q?u5Jn2Mqn3ODFB1mc9MmLKCCh58ykvGHkU4KFjHwFwZ3F1tfcQSyjKHcN8E1W?=
 =?us-ascii?Q?Z2YtfLj7hvkCFiE6UVtfViFjwOMvDT21SKtYCK6PRBagTpzdhnrYACOTpjwJ?=
 =?us-ascii?Q?cXwKlucBPZT5JQZU2rmQ6YL+3fTq8nM2p4y2KBJWFVrbAY6f3KVtzsJ2r0B/?=
 =?us-ascii?Q?dSmq3RRxGF03Iw9HCKCV+WGg2an0B91YRxRkCOqJ/KqBdinEdvaBlFneThj/?=
 =?us-ascii?Q?tRVaqPLQWjyxmt/V+SSR/FvMLGK9ET7FEs2Wb6saPekP/RL7t+1ow51hd+Fe?=
 =?us-ascii?Q?7e91vOEGmI5KfZAdUP/EA4t77KVtjtownSaqaXKKHHLpv8R3+1oXuJS9ikCD?=
 =?us-ascii?Q?YwiZIkXbTHmhti59BpbpYGA3YjUZHOyZtb99fPMs77YvKTSB5WqFtjJmBc5M?=
 =?us-ascii?Q?rdByAKk+Gjc6aoKCHojgdABAAdR5SU1CoVLnH18EwRyMcRKTs6k0msZ93bT/?=
 =?us-ascii?Q?tN9BzFD8ceWoYIuo31mieqOr5Y2rKJxwprzyPqeBpGhkuDultjsCGpnQx1q+?=
 =?us-ascii?Q?r7E2x5HPJEYiybWZgk3YmdMtgJAr83wCv3FvAAnUDgDu1DWJ9/a/bik0B5RT?=
 =?us-ascii?Q?vkFrCWhXDkxnIH2IDiYgtlDqXzq7uFTyA4PxcFk5vMiCTdO2LCvP8Umm+ExD?=
 =?us-ascii?Q?vNy6Jxj9LzFly/ecoA+B1YRLU3TrMZEuRwcC44aVWBLw7MfJmgx6BJASEHw0?=
 =?us-ascii?Q?NLC05lRVCYMo58CenWh/RwAtd+7HHZDW6W57R4mfHe50UFbSNmPjaDTC9nLd?=
 =?us-ascii?Q?osuWghFLQs1kkC3rTloODGHCw8XeLxtEFLfhFiiE/5b2Pzh7UEp9Jz8J8J0S?=
 =?us-ascii?Q?FaXa42lQOJSQXjUQLUIfwhbb7PimkjYFbkfhzogF6xkG3LG4smG0L2KWwpOj?=
 =?us-ascii?Q?n06t15/ONs3rpY68VIpiFHoOSuC+/kzEmlZrvTUp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09c1a2bb-3baa-4d36-53a3-08de3cc74f31
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9601.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 17:19:45.9653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dgoxk47nghoYTTcuSTwRmWTms3k1GfzEZihrWZhJlRfhM6cKIDvvkAuBD5vGqtAB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPF6B6BCC42C
X-Rspam-User: 
X-Rspamd-Queue-Id: CC7FB40013
X-Rspamd-Server: rspam10
X-Stat-Signature: 473is55tu88qy3g5tnpmwg8uhsjmt3pu
X-HE-Tag: 1765905592-114928
X-HE-Meta: U2FsdGVkX1/pKfcy2+gsRNCufQiYYm/ftx0WXedp5ptf0LWyScStVUxvQ3bikQb/x9QbhhFFlEZJGGTfPcEeRkoTLwruaSKE/0nqGqQmjBxP2np86zj7UPL2cwhb+vcKAmrktCwAtnTXviuHpBeFc9+aLs/wdSeD6SMWkFV2GG+HVH/BiteAAewEi7lYYN+SRAbSZn2/VvT6g5DuIOdXHTrMMyrJ2+WdY91KklrE3JoYMGERQEqgK41mqnvjB9Oop5IvRw2CYDB/oNnbgTbeBUGRjw2udrj/+tLAsvnLdz6hE9gsUvkick7Xx5Blnftht/D6Rv+RqrX14CM2kLt2C/S4XaUYJTl6YDyBpuZhdqVZG0roD8Gi5ZgXnCFpdOI8nHNjt8awqa06bemFoDAdCh34zZJ/tJedgcw8umprS+kVRDpYTC+lK5vA4+OSni+7cQFwJKA/06qZAvrKh1xGSkUHrTyjI2Axf40YFvKSUqMXFhtWlB65CpIu6vNegsbqb+pEt6H3m3G+aJDtwjn65CdPM6btY+/tzaWkNZ+EX3JAkx6GJ1ccvSb0DTTPCNvvjq/eWNmO14aBgq1VChGZ3jgte4VWT0a776Ut7+LansVtKIBDLBDTiX6sJj2rLRnKc9Gkk7DwLmst+vM+hFRcl8m845ImhqlphYQwdkqMYLsuRTJTA1WBCDV9tYAoB6goMHLaw0Yy27DFLx6jjwwwJc34NqtYZQvmRxZVI/PYhpEPDNZgSc/f2g/tyHccbucaHBQKH8bMPAvSn3fGPijJC/fBAvKX38RoZj5tiIBhtkUMWmMjpAp2JDXfmLPlmEBwciqj0guggUE9Oc5STpFNevlnypqxOKLiElL6KJ4rgHv6jMwJJDYmlXmrbWn5shrdMPOkhcfVTr6Knb1KFha6o45Ctyxo4luS/j3MmAIPExsioOzIyVSvWQhXfXCBoLVvAymJ46MgY5kFaIylAmw
 xPmG9cqR
 uKSU9KbuYvq4QgbZdP4NsfCHZoF+S1QSjiQD4IVzjPhiXOLG4+XOYK7XK4v7kg77/dMsB93tUMRSW2lSvaz8Di8OUpQ4lSev6kNHij4Ek8bZZxgTRzAYdO/06/HQX867RQ2dfTSiiqvtT0xFD9jqlXm0sz60s+qE4sKb9C/jARfUViD+ub1v0k6G1nrY4CLqNyE99zVfG2VZCwATWLO89VHXZ+tzJQqp2WBD2D5BSUqqT9gvGjbAQX3scW3WKKI2ubRW5SOlEzw2x0MQxydNFd/r8gsNCJsklJnpXK14+bHq7YYQlxhMj78FBk0diUKCXCwD+EpBV/zLsmSYaGDRbeb7po3j/EYMIVh8GksqRFd+oyxCdd2iHIxibbjxSsbxb/ibdMto8+XwrNhmvXr/uwddaaEp6Wwiqb7G93GLIFMNlgcoy1CsL7b1iw7oIn8/l3VhL8q9X6mJ+65AmNjbWYL5dewUCQ3c6HUlOUXQk3J49sRZI8Nr/L2RG31ndrEGbC2I4lGuLFfR2sTOTvSYKsYKVrg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 10:42:39AM -0500, Peter Xu wrote:
> Also see __thp_get_unmapped_area() processed such pgoff, it allocates VA
> with len_pad (not len), and pad the retval at last.
> 
> Please let me know if it didn't work like it, then it might be a bug.

It should all be documented then in the kdoc for the new ops, in this
kind of language that the resulting VA flows from pgoff

Jason

