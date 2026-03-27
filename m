Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6374210ED674
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 14:30:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1F376B00A3; Fri, 27 Mar 2026 10:30:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F61E6B00A5; Fri, 27 Mar 2026 10:30:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E5806B00A6; Fri, 27 Mar 2026 10:30:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8007B6B00A3
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:30:14 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 229EEBE72F
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:30:14 +0000 (UTC)
X-FDA: 84592077948.08.3557A1B
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011036.outbound.protection.outlook.com [52.101.62.36])
	by imf19.hostedemail.com (Postfix) with ESMTP id EBD371A0005
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:30:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dE3Fkcq9;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.36 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774621811; a=rsa-sha256;
	cv=pass;
	b=6bIZhS1T+56p0maFLRAVcQQKLlLqSBVHyi7KQmdFblVYbEjDwN38LeH57DZLWY6zu+dCBM
	lzcgZWnwOfexDKCv+ZN0ZQWEq15DdFQyUClSYH+UVUbJa4EoaR4HxIGqm35J1a5WAgfFZH
	7ihKTrARJxOKtxOHX6RAJ3XTAdK46+c=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774621811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uV9sNwooFdTYDvyS1NgVjGXpnJmZRu2QWoYaAstrwMA=;
	b=R5d8RuyQanIeAND4p0wFDIjy+AadzXZ/MDdLVOJV/EfMLhmSIvRPPMyJTVpr8xMImz77t+
	C79Q/Bt6DCxcXO4JOjphG2q81SS8mzt+MQfwS51VQHt1PaZDRcUsW6byO7b2ggMONYFXbS
	tqFi3blzP2UbIqW0xJow2ASpwKxzXe8=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dE3Fkcq9;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.36 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rrV4mO7bzBpWXEB4zIyFwmFwNf5lw7O9ogWucc3cDTzl6+aEnQKU/4w+/scIoenLgEUbzJy1cHPGOIVhTYe/4tZjL5lMm6ON8/9FctL/5uQrW0icvIiVrYFfiDWxaXdJE2RX8GUvbKakJn7A3q6WMe3JyUg+3DvawFZq77KKzcb3GS+GEctYTET9E7oPaSmc8K6vmquI7oGBiRs30Jv97BxUJzFAGHlUOn3eeqBtyDa8M4k7G+p+9i1eCsvDJJ+HoKZHaZ4PCPNqt10GLw6OL2wnRZ73ea92sD26ynfmF6RDyzbrzMrSzNW/1LbOo4vcDj0BRA0r/1GBbuVZd/ot8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uV9sNwooFdTYDvyS1NgVjGXpnJmZRu2QWoYaAstrwMA=;
 b=YxZd9YsBjkPfxFkghGqcdIo6B+cf0oHaeFpsGQV07sS7mQL0JHrVeYNGQemCg8EcrQiQ0N1bnB3q7720PtFT1LW+y7Ez7ThTU/5dYcvlTlLaykeqZ5WFd65aot/4jGExD+vIvCxBUA9SCosr8dK2WVhN+6JGvBYwXQZst5ZBFzUYeMtNtc70RxSG5eh7vJeRdsljQwNAsGVeoaBIMtM7uQbAXmHanIdgb4kX27yD+lnGg3CgbMbbIfIBNsajK4UpyKMIVqWS+HAcmyIBl27e8zMwaj8dHkPh7EF1KkCUmieaZYkd+ExnVBcmEU+crBeThdG5A62U3cgJ7R4oAeI15g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uV9sNwooFdTYDvyS1NgVjGXpnJmZRu2QWoYaAstrwMA=;
 b=dE3Fkcq96PpwbkvoS3FSE7Cj5UCSdA3H0JXXfpjw0JvrNSYpk2TKpVKLCJ5aXBgvdw+3dURhZXxw1jQzuYiI9WvpDEIBmG0IbcwaHosnVg8cdLeegx381suV2A+1gNWGeH2OiwnSxWM4P/XO94vBkSqLA5WU9rLxuKGWWge+ig2iQKGNomWUgLPO3uIHm1k6c4TJZbCStauffu9n1byyEesGiRz5XDY58oabwbJNH5crRCLQdGFArbadHp3iZMZUM9kIIPSu52TFN7YJBOn98slGNyfY5xRBRCuVvmXOyD542SyS97f5LWnADKfJIprMcPJ/GYPfLvgjDUKhfTEDMw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA0PR12MB8350.namprd12.prod.outlook.com (2603:10b6:208:40d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Fri, 27 Mar
 2026 14:30:05 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Fri, 27 Mar 2026
 14:30:05 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 00/10] Remove READ_ONLY_THP_FOR_FS Kconfig
Date: Fri, 27 Mar 2026 10:30:01 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <D447F353-36BE-4353-BF06-E4D521BC5372@nvidia.com>
In-Reply-To: <4007802e-f87c-41a4-8dcd-9af867eb3fac@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <10748785-08a9-41c7-bacd-88f05fdf1a88@kernel.org>
 <4007802e-f87c-41a4-8dcd-9af867eb3fac@lucifer.local>
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0049.namprd02.prod.outlook.com
 (2603:10b6:207:3d::26) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA0PR12MB8350:EE_
X-MS-Office365-Filtering-Correlation-Id: aaf7b4b8-72e5-4a70-15e8-08de8c0d56ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	73KFNNyeFhHs83Hdb69b629pxdIRNp9I4TnXerzgVNqLecRUipneZB9PZ0BdRymiIELEKrpDXnirWDfKBJEakn3qeBvXaV6pq/HNH4xG8g1p4YcuaeSOZ2K22g5J8Y5UGrdKscQrrKXFP+klbzRf6PDvEps15+ALcljI9Fq285VjN5tGjOsggUr9Q+sMt9cnYFBWHfkiDKyt7EU9AH4rSTH/fznkfRjRZhVUX4BEj7+befzYUnG2OCk9c1t+dRsLdDrcnRgnlXkUC4AXduyLREuBS1cev55bwcXh/7IZnxpZRxdl/bzFAQBT4Z+4bULswppIaCNJBnJvWhrFpcyfDKpz22zF7TEgKkU+z5fIbv4twLeQLKlmCnB6Rc3LIH0VrUJnFYmmZ3OVaYmKzItAC2lkhNDKmsgFrhR1U10RWBh0CFsar4gq6U/gqVKz/yEcZ64TrvQBENaZLP4/PkQ4OSUxB1QYHPiNQr6LQabCoJfulC+I37DQqkQi7grhhGmkjPXbICqdJaNsrh1vEp0Bdm4XP+n3usGyMb/0yeibecmd3S7+dv1cDAGnDUjVY3zfXmVvT2pwQFltIN+AyNwC8U+c7OQAomyHr0p9PrwK9CfXxctqcrYV+xhXtaeDM+5VgsyBFrQmPb5FlABobeKbts6MOI9SQm75Q9fBMnvsqBomYRtV6DIVk6N1lPn/gjLJ1hJHqbZ9jtxvyd5oXPuKDioXffrTgkJY50PFLuka06s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BXHel5xSON5QECjRbvgwxOMKbqdRgifk54tjcA6z1Vy3nEhI1UxaOEP3ZQlt?=
 =?us-ascii?Q?oodXdrU0mlhGNSj0hDTVrAJ9vy0gG7OT7hiuBNzi2Lfa/gQHZV28N/lxro0u?=
 =?us-ascii?Q?By9CM/qdVV9dnAAXpAlia8b+oJFDfOFEwwpCP8qrx4ekl+oMY2J0Dz6D2lv/?=
 =?us-ascii?Q?wwW1pW+N/wrhtrgeQeo6/AFwuZKtZAPkrP7D5tbubP7JXEwgBFjX4HeBFCgy?=
 =?us-ascii?Q?ThHqiJzhv9kmm4qvmvhgtS5hazFMA1yURZMzwx6XodSATWqouu4GBOQ2hAbV?=
 =?us-ascii?Q?ma+i8aGKZobTmKK6S0nq2e8jRW6Z7vg6Zn1+eeHvCPxpknhVCr3n6C8z0Dln?=
 =?us-ascii?Q?0Uw87Ss16UcRt9PauiKtp+Knv+6r9GfSbPFRlCfvCLX2go0FrAqRDQIAKYlF?=
 =?us-ascii?Q?+JrSXJ2tkhks//QjL3fiowYsGHinSAfNha+2znwG15I7OAEoNcCtJVTS7Fid?=
 =?us-ascii?Q?fl3RsgNxHyB3eQalZUQBiJhsC3CVW9tnjaTI3zed/2Q/Wh4LTeSwyxpNBZzt?=
 =?us-ascii?Q?2IRAAXaaWkXEapon60Qf4Dtqux9ecZCU74/cyGqjP9M4Q238em3HICCQ2DhR?=
 =?us-ascii?Q?PMgGw+8Um+8B28fJXAc8xq+lbK2yVlbvVs5uCF1GqpJdmfRB2ILxnjjTFN/h?=
 =?us-ascii?Q?dPa1AqEv0jwj6IO4XRk3bsLcCZAwFmiBsdWuMhl7Wg/043w435e1Lvoc8tHT?=
 =?us-ascii?Q?fJXdoQG0Jki4jFwsb28VpDIWQDMV+k8nJcqKocQk0aQeAeGMu6k+czSezgtd?=
 =?us-ascii?Q?5HsoQDf9O2QLFJ+GF8w+evA29LrN5wpjZHNsrzot36rBLrl3V/pFpBTcgj2V?=
 =?us-ascii?Q?G12berb6Him1Mc/Muenywb2j6MBPYTF6bDBNIr/c+B9DTwKHymGlPzeVJ7Jl?=
 =?us-ascii?Q?6ph3uv1jjRCi7YD7a/hmHxfNCsqoSX/OqZ/9l2g6bLL8cgUZWi7yCGMnck0v?=
 =?us-ascii?Q?rZ3MzNjX5/VvOAwOCw7+9H8yi6EvfxVdECtaK5xvKNw8kkQUWoHaSMfswC5/?=
 =?us-ascii?Q?5TlqjOF9g1z/RXnXUwbrjmwXpncMKgP4LUpI0ZirrZpjqjY2RpCN5SyAaqJA?=
 =?us-ascii?Q?Y6qZl+lkDXRY1Kh+UpB5BA68P6iUJutkLnikSjwIEznCU6rVAgZ3SU0d050R?=
 =?us-ascii?Q?GCDo01ZA/xW/1pEa/VN2AYEb+fP6d12L/DsbrNzxBqcdVNPpEMDJD/XvQool?=
 =?us-ascii?Q?qGpNT93593WCOAaPbk64ygqiSNTn+Ayb4RiJjkSVHwKIm/HlYR2DyKs8Xh2q?=
 =?us-ascii?Q?Tmqxl6OVNFBsI7uSGqKP5gw/ZIP0fBuaxpHFes12XNhG/AEnrs/b9CNb4r2+?=
 =?us-ascii?Q?/O4SPdV6NlU3iH2MZ/zKTUqLFewV6/5SiXIB+RDN6vF74rhveLXKRqQN17ec?=
 =?us-ascii?Q?hqwFyjMMJHNlOVgOwoP7OHrTqRe5i20FxwZo2Hm95Lgb6P6qSz7KvwboyxcL?=
 =?us-ascii?Q?kc8hUIgTXmme1aNTjRHnPQyDYWmMF90rnruihuwMqEo/xDnT81stUFT3LMIt?=
 =?us-ascii?Q?oZxML45dkBjVO9uqZi/XX+HuA0VKRATN+RDYEVHhINQjbCpMxBV8voj1+nfx?=
 =?us-ascii?Q?OW745vW9gZlLthKFbHXUjG183O/WBp2mTTxB+jrJIg8OnFA02abiA2lFyf5q?=
 =?us-ascii?Q?rsOenHllpQI/WdVI4vKUl5Nlq/jkHjR3TlcrnPvtT/feeC+0BbQZ/rS7AeXn?=
 =?us-ascii?Q?Mwm7w3hIMDm09toHsuzBNHyfBiex/HsrvdSE3nDB9RQzLmA0pvo384E4dKoy?=
 =?us-ascii?Q?UKV9vqJlPA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aaf7b4b8-72e5-4a70-15e8-08de8c0d56ae
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 14:30:05.1463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YpMsWHPatnH0HR9zsmY9983jYC8woLQQue+UoTPymrzTFCksKwKImfwgG+8lrMrU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8350
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EBD371A0005
X-Stat-Signature: r4ytdeefpkfkp9e3ay5p1jpcrrda8pde
X-HE-Tag: 1774621810-22080
X-HE-Meta: U2FsdGVkX1/Ci7XlgobBCjawci+6+/VPRdv339zFI134BLqrJ11b6r2lrGMwliebfdPW83z5Q8xC6VurTi9maJfhtj7CpH2kfOBp7JOi1J6t12naTCbU+rfvwk3Bl4prZ7jD4NpWVKhAilGplSaY3dBu7po+ValcZOQLPIqPDqV10pWrhBEBzpPQcKA55aid5qtz7PmQw5RViG+E2k5qT72/hAKIp84W2x7UZBBlsIZ4xT6OozX79R0UTT0j9fIE0OyN+PgKqe8ZuCtRWQXpsFSQRefJS3W8fUyzH9W2ydTbJSlbEkyl1WExBfLyNHuHy3mL/1YgwLBM4OTvNCSgLS2vaPh5Z7OYZOio634ayTUfls5JGEDFknd79CGT0YOIxkpcYxHZrGeu3METI6lyedxwcC3H2UP4V6i4J8oPznuPm3ynLl4TDGcyFkw94rIT6ObR0NPXfHer/MFjOMCU7AkldIL/1wJKIcNBLE4zNE2lyjMBv6OC49co+kEOFVxLeeoLeKqpTfzlnOM3to2Ycj3KYtQYbREqFTOLlOa2pi73dh3Q4kjl2Yw2BSFTIFFggiDrMcJDsv3F47n7NCBnefLyOAq1NeTLyW0qpk3UjX1CAF2snj75AclvGmyqStrjKqkFuSSPwAkOVwj5WRyxcRgJYt+FS1GNEp5V3cNO/Y8DH5X5WXvR/9YohFHwJ31ik1Jb3xp0toNN3YSY8drRiOINw2Gz32Ty2sNhj6S0fBI3gFKm9r3PU27bEg/gWcr778qYXKbzU2d5exuCfv75+Rr9dkmX7LHweKJgeWc0Gn3BKYda+rloMtxYlbqId9QQlReSQSF+47ogPprqb9Xw9hbZw8QHgjtcTcPomP0eJkaFjRlh9902SX1eQDBiS49YjMuvp1WEdGqyLPo5WTPUeIia7HtxP86kMz0ury2ldEvypPkaLd/ObsafsRg1dkWRPNYQwEJZxPCv7KcQfRZ
 tOj7+2f4
 pGW5/8XEminH0Z0zIydZnKQyZY3+403bDrgjtBbP20FaT1KMaUb6YYG0zHN9g0oa87oPbijBsrbXytZXhW6ikGD49d5kytxmAXrRzQZOSufnnh8rwD1p5D99TamutYALSYl180yihKUz5q0sDkV18ek21aFdDURvFJtM0fO4bTCvRAtInWYWddFdYDj5NLJBNBB+dx1wkza27+XrX1NYpoy1BQCgWTlacKcqeQb+9C2ItOtuvY0+PqDBa3NT6Mc82cNecP5fllKmcRAigxmkw3NhzmqfTwmZYsFOxsqn01/UyKb9j+rGeX3yRtbAdkVSHR76dFUwcXzMGHSrjZvtebHinCK9CvCh95d4XRAhvskvcQsf+5Wy/j92fsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27 Mar 2026, at 10:27, Lorenzo Stoakes (Oracle) wrote:

> On Fri, Mar 27, 2026 at 02:46:43PM +0100, David Hildenbrand (Arm) wrote:
>> On 3/27/26 02:42, Zi Yan wrote:
>>> Hi all,
>>>
>>> This patchset removes READ_ONLY_THP_FOR_FS Kconfig and enables creating
>>> read-only THPs for FSes with large folio support (the supported orders
>>> need to include PMD_ORDER) by default.
>>>
>>> The changes are:
>>> 1. collapse_file() from mm/khugepaged.c, instead of checking
>>>    CONFIG_READ_ONLY_THP_FOR_FS, makes sure the mapping_max_folio_order()
>>>    of struct address_space of the file is at least PMD_ORDER.
>>> 2. file_thp_enabled() also checks mapping_max_folio_order() instead.
>>> 3. truncate_inode_partial_folio() calls folio_split() directly instead
>>>    of the removed try_folio_split_to_order(), since large folios can
>>>    only show up on a FS with large folio support.
>>> 4. nr_thps is removed from struct address_space, since it is no longer
>>>    needed to drop all read-only THPs from a FS without large folio
>>>    support when the fd becomes writable. Its related filemap_nr_thps*()
>>>    are removed too.
>>> 5. folio_check_splittable() no longer checks READ_ONLY_THP_FOR_FS.
>>> 6. Updated comments in various places.
>>>
>>> Changelog
>>> ===
>>> From RFC[1]:
>>> 1. instead of removing READ_ONLY_THP_FOR_FS function entirely, turn it
>>>    on by default for all FSes with large folio support and the supported
>>>    orders includes PMD_ORDER.
>>>
>>> Suggestions and comments are welcome.
>>
>> Hi! :)
>>
>> The patch set might be better structured by
>>
>> 1) Teaching code paths to not only respect READ_ONLY_THP_FOR_FS but also
>> filesystems with large folios. At that point, READ_ONLY_THP_FOR_FS would
>> have no effect.
>
> And also please do some cleaning up of the mess we have in the code base if at
> all possible :) I feel like we're constantly building on sand with this, and
> should treat every major change as a chance to do this.
>
> Or otherwise we constantly keep leaving this mess around to deal with...

Got it. Let me read through feedbacks from individual patches and come up with
a plan.

>
>>
>> 2) Removing READ_ONLY_THP_FOR_FS along with all the old cruft that is no
>> longer required
>>
>> MADV_COLLAPSE will keep working the whole time.
>
> Obviously everything should keep working throughout any version of this series.
>
Ack.


Best Regards,
Yan, Zi

