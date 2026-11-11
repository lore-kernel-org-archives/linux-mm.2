Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A462606A33D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=PL1p69Rn
Received: by kanga.kvack.org (Postfix)
	id 9FCEF6B05C0; Wed, 11 Nov 2026 18:04:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D3D86B05C1; Wed, 11 Nov 2026 18:04:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C3E26B05C2; Wed, 11 Nov 2026 18:04:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 564796B05C0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:04:27 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B37D6A7FE4
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:04:26 +0000 (UTC)
X-FDA: 85424368932.15.1014856
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013023.outbound.protection.outlook.com [40.107.201.23])
	by imf08.hostedemail.com (Postfix) with ESMTP id BA4A1160002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:04:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PL1p69Rn;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of apopple@nvidia.com designates 40.107.201.23 as permitted sender) smtp.mailfrom=apopple@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794438264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ITfXhxIBCO5tTSM7ICylR6LU/HFC7o80IHw+R38q4WM=;
	b=rTlR7MUSeymbPFri1Y4thGddgBdvPvUeeLNORgvL9OinfCOTjj6rDi2MMnEIHTPFv08ORt
	j646vyCSJUC5OjsUpda7oe3CcdfjpBW9o5TvVFjZsgy4G9j9GC/4LOaBwaIYgoZUzwhe7q
	frV7CNgeynlVFMC6l6elpiX8S13BA0Y=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PL1p69Rn;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of apopple@nvidia.com designates 40.107.201.23 as permitted sender) smtp.mailfrom=apopple@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794438264;
	b=KMW9gTejy+fArChgkcRTr4A9fwV6XJQuDc1TyEOdoMIYOcW+D5S8d2xHDvdyR2jQdvJVlt
	H9y0nLrJ0pl4svumVuQ/WMSqYQdAthLaY1pkFnM1ZF28/hkWlQHwI650YzGZCKgEQh4qKU
	NC6+/QYzDbWH40+1v1WfdPhmnrgSjJU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T2sbTOlgB+JUUfTCsJGC2Ngs4tI043RoczoT9BB8K6QT8gG/WZCV/+k2487OOcyY7kBpl4VyfXFnIrtL12/GDuytUXaS+mbGxQ/hwgnNn2FDTi79KPP1R03k+ovWbFIAo29dhUiII6Ek/0c7ze5ZXyp4TeabJCaDVqkZOM7SgMGrItyxH68SbAIP5O+MHmjRd5jw9GKqjZWxUwfIklbwOuX9lZZLBxfAF4cbv5Lk6Pfoo0qQftF+/e+pi9MVCCBwLtjvXzVsEoHAf3NPn1O4pQRrRNZw/ugejgURxa/Tt3AwkOWKjk2wqri1b4JMZxScy4bz5qGMZ672zviKvzSomQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ITfXhxIBCO5tTSM7ICylR6LU/HFC7o80IHw+R38q4WM=;
 b=PofoueYqmC/k1pR2aibBiCmpANUwecjuhZVytaLQmK6GpLOrzQ463UC5dokJs7lH7g+dqXqvi3iziu+Wvyq6e4KYrJxfPPFTdA6E+4LVF+ojN2c4SGOR2pa9po52JmFVXR4yairiHzW1t+8DDaaioieL8IJuWm1+PAKkPqSq0WV2frujGbxCq2qthtIilEOmU883RoUQ5QmbUW+b+ywLjTiyazLS5sAHXvOR68LSQ7MYH+1JurbzOMZ+A5ccSksNw/AP9R+58UtzJx2TIrf0lG6nPox3K4KLu++bwrrP/+XZw7jj+eAxZSOzsGkB7QnpUUxcBzNcdTgpPp18Xxgqkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ITfXhxIBCO5tTSM7ICylR6LU/HFC7o80IHw+R38q4WM=;
 b=PL1p69Rn+VHYUtmnFSzU/bIdX9pAG6mAUVsKBroDSyp1fkR0q431QGQMNT24emAMYMvL9NeC2KGNFAhNl8awAphqMjIerpyEWD7jc8JHmxXfbu3c19d+/8o60/pxOsMmfYgFJ/XAxYCFI42ICfPaZaSvG400kDjasJWNTAdWX3nLJinBrmvqRpmRVTWiaJju7eJ86yx0EPZAimS48O+P3TogetvegUQzHwdyg4+d3mhNjuuiOEIymx9Qb6RYmQqINNGOB78ZoGQEnqzYz5/dV6xlppBo6Zfluv/sQDXPprFszLYtSOS62HTkSCxXrKhSOkyCdOtTu3XEP4SRYLjkVA==
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by BN5PR12MB9463.namprd12.prod.outlook.com
 (2603:10b6:408:2a9::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Wed, 11 Nov
 2026 23:04:15 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0615.007; Wed, 11 Nov 2026
 23:04:15 +0000
Date: Thu, 12 Nov 2026 10:04:10 +1100
From: Alistair Popple <apopple@nvidia.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Usama Arif <usama.arif@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Balbir Singh <balbirs@nvidia.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
	Chris Mason <mason@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>, 
	Mark Brown <broonie@kernel.org>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH 09/13] mm/migrate_device: fix use-after-free of the anon
 rmap
Message-ID: <avTzHDlCiaNSzhtX@nvdebian.thelocal>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-9-3d2454362e8d@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-9-3d2454362e8d@kernel.org>
X-ClientProxiedBy: SY6PR01CA0049.ausprd01.prod.outlook.com
 (2603:10c6:10:e9::18) To SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR12MB598757:EE_|BN5PR12MB9463:EE_
X-MS-Office365-Filtering-Correlation-Id: a372b873-5470-4e2e-ef6e-08df40481b66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|7416014|18002099003|22082099003|11063799006|4143699003|261021123027099003|261102123227099003|261026140227099003|261028144727099003|261026121527099003|261021121427099003|56012099006|261022105027099003|261102130727099003|261009223027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	sz7a37t9M+6PQJ37zFelNevW/60Ok6y9krBD05srJsV5RZmDNoHm8tJsLSM2LYv/oSPi0+BwjWK1cD+LrkDJe000EK5WpJP6qb+sOSIvjdKo1gP8VxSEGeJMLA5fTJBycgkft2pXrw20wVWfbFT3xF9b8ox9imC3W/DR+oMcbpdRU1XsxUs9m98FMxjEL8FuPNLw5wzKFogiLFTU9gNXdXdLRn3gAUewRfOZC15DU3whu+dnw3UXXVbk33eK0IIFbFafwIH/f3WOxvgqMZAsIeQNZQwV5i7D3cxUHEH8mJ7HqbKN3abhygbO1HEVeS6ZK9y/T9vtTQJeFBA41pBKDXLQMVZPgsjtudzL4YEp5TyGfWErrCbZksO97x7rpk7bBO1FGdgdNXn+Xv9M2gBIxGc1xwx5VDrFGYzv/eOdXqZS8C7xljKirNfvfHi2VCVt9G3Sm2+Qhq7T+evbCKtXN/prdXRGA3l4D55iaMA9SsnEc3N5d3B8tQl7DOAMwBS5ub8HgYfxiaCroc5C46boNAgVkjZkWiFb4Hp3U+KvTRa3q0i7dFdpJw8bwUh4Sik4IBa+qjdv7UmcUMg7CIbjQ0Gzhm7xxgGVtP3/mOfCwRQEr2Vipw8gcCDobsDAbt6wkF2OqOCdeWnJ7UdvE1QWFaFVAqhflp7hKI6ajQiG+xE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(7416014)(18002099003)(22082099003)(11063799006)(4143699003)(261021123027099003)(261102123227099003)(261026140227099003)(261028144727099003)(261026121527099003)(261021121427099003)(56012099006)(261022105027099003)(261102130727099003)(261009223027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VQHeYejFZsqvucv6ZCgSM3My/ZlpAOwhA83l5Tcx5mYorYRYGnzyDhPDd2D5?=
 =?us-ascii?Q?5oC9CnrdeL4icfZoaCl74KHEWDzomcjucEgOIaLk+OzCvviawcI2BdM8+t4b?=
 =?us-ascii?Q?07NyXhqT5oihxtMJZL8TJUHbr1QgqWCcR6J4KBeIe0UV6bqMRdL77pZbzD1R?=
 =?us-ascii?Q?RdI+xTtwgl3y7usEPi1n/xc4K8QIv1Q6bZ/tLJnF08gu+Ko5zSEs1SknX3H1?=
 =?us-ascii?Q?JWRZwkZcWlKqbrjATGE/L1dH+hrWoIdew4fTK/sjeWVLJgVY4lKUhb7cvzY+?=
 =?us-ascii?Q?X5JvhbYNwxhjEfDacDkMtS94PFQwnIXhbhpbSuUZd+AO6FqoIxANRLwJeyDX?=
 =?us-ascii?Q?0gafgByX5do8Jih0THVIIbVdkYUi42g2CF1Toj9NSNP9jJ7H2p0B18X7cvlD?=
 =?us-ascii?Q?ZuXuK91Z9qZoaVKu8VrFSh/t7hlgj0CSLS7qakR1taTStGujeA4zWykHbJfz?=
 =?us-ascii?Q?cNzbe2+E+iSXsCBcz7uqt0G28JaITWddU1MQdecufPLiXbuOnoHvfClHAL3k?=
 =?us-ascii?Q?jynnL4UjGpTmyPxtvXJVa27F5YkqnMSrSE2pPAHJmxohkLf73oVZnsaDhc5R?=
 =?us-ascii?Q?bZl66a15xKq2A0swLnrESvaAL4AZegbHMRjXfVpbu0NO5NvYIXckNrTuLP/C?=
 =?us-ascii?Q?Xyabpw86cySw7GG8RWNiLV2/fPvSuKIueAgb3X/eNgAj9RL0lDIiybO9RMcJ?=
 =?us-ascii?Q?YHOyBQFGML7q56JzQewNyMcN3B53N7K0h0aklL0MqheYuAc76po7HsA0nu0P?=
 =?us-ascii?Q?YSFbfJRPztWsBNc/Sy5P8I7ouW7hhl3L8HqxhaOOWcQbvnuIn2YAk5GT14Lp?=
 =?us-ascii?Q?r6RLE9Y9X51xXwnLXpn+We0/aRTtpWwQpl7Iv1hLYIymvxAkp8lMPZ43Msg1?=
 =?us-ascii?Q?UfpkkQu3b+vXYGWl5zJBGM2gxRkF0A5ZM1Avtox3wuFMM7PSvfyyesN//Se7?=
 =?us-ascii?Q?9s0zJ0GVT4H+sTAPJyvTH2AY28w/LkA/IwnrF2u6vlitFVgVLF5RI3m+sN7j?=
 =?us-ascii?Q?2xs3CkFbWFX0WzLhCBdYum4Z0zcZeB5nOS9wJ5SCUZu9DbFpFcjN7Qawe3Y5?=
 =?us-ascii?Q?jeF8tvkaWZvOpTe60ILYE1UWHY+0TQCqTqkbIVBmeTMr2YO/SoykMJEyEYM8?=
 =?us-ascii?Q?FG8fTy3btD+kTs/eRmjT/zWA0XK9GzLkk3xP74yoJTzSXKoj9rf1Rsh70336?=
 =?us-ascii?Q?U4+Moils0szyYaF23E+SAQE4UM7sX8teyj5Yjq03ju5qKgNAnH7ItYagO7E3?=
 =?us-ascii?Q?mUS9Sgth6wReQTiPutvN2Sl5QFJCSc8XAdFWNGyNPfLV9MYBUK2Gh1lhPeHY?=
 =?us-ascii?Q?yjcKEP3G6PvvpEFjRNVGX4BLyBn6qfIA6D82UnHZnXYZ4e+dQXujXp105aHI?=
 =?us-ascii?Q?yAY3F4R6PSCIPXfx2IWG6nngRPP9QHXYC0bQnPcBdWvLbEcB6FxnKEO7uHqe?=
 =?us-ascii?Q?mlmGI3Ad8wpCimEMEXjmBONIqP8URDDWYmxn3nTisXFPi0xHBr6PX08oeQCH?=
 =?us-ascii?Q?W1aPJ7E1tXehyWDz4Rj2Rki8o2RoWFGwWbF5iLVkIxnjg78oOMikjxYOHyLP?=
 =?us-ascii?Q?5NACpialCEnELyrQ5h1brzb3rjaWWXanVd7gmYzQq6KeoE5wZto7Q30vXygE?=
 =?us-ascii?Q?/wKdoOFfmJZgOmv46PNNB3rL8dTgLKKdBtpJVcBQFysdnwUnqPOy0GTDd20P?=
 =?us-ascii?Q?Dx4YNc0RgABSVY9CI5/UU7i6nQxN2SwH1jpzoojTVInu1C4vC11wM/VbilfP?=
 =?us-ascii?Q?OdTk9ginXQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a372b873-5470-4e2e-ef6e-08df40481b66
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2026 23:04:15.2123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QRVM/MEWPZaUwYx0BKP2GhiyD3HbfdIyYwJsiGkJOivlMa1rNsDrDhOM/auVCTIcEGFoK8Szo1Cy6vmp7Gz6ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR12MB9463
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BA4A1160002
X-Stat-Signature: 3hj7amqhtistzi64od178s6rp184jjcu
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794438263-151279
X-HE-Meta: U2FsdGVkX19DIVjq3Q/x+DDF8APMJ/s5mrE1vzIbuwSwEb5WtOSf2UxjkwSph25UxQuUv6wpR1t6WkzLljQ8xxv4VdEK9HQTXACEsaW8weYvvLMu1zvX7D+2njNFOs9c7yeWcQlAjm9TX2SndoBNHrrSNlDvqhoeGryi8vwws9DTJupr8kZDWOWQ7Ubtm8S1uTAE0qaeFHRZ9/1dL/bgDI4gTAGx+wRIZmXywfuCqcTHskxz/jGaNBU5qkUD8sRsx/VMnI9umVG4ilD4nPgXVftYXmVpOxwy8Gf+z7XBvu0yOZ1wMUr5L01KsBQ+U4ZCDIRfioUjxLgfq1apDBsEnBm+Yt4X8P35/Z8hEsjqpZu0yzZLzv1QL6+XH+D+Jb4TMFPcYcp4e/MB/2TafvaPVoR7lrUFOlTA+F5A64QmVgy0uqsDzgPprYpRAkIqK62836jzpy4LwvYe+kcRlcv0wTO+gk67vfFIZUMLILh5ePrO8eIvncblGw2fGrBALSnnObKGp+Ltis8LxQERFuVK6/w1vZMBAyoR0lzacQelwysdlASJZgf6q97Vy+pfdT18gCUhbBon/FUJO52DcHAjvzvFW3kcuWteRm5gfm8Ay7AHBKc8axcUcO9b35WOODfFN7oqM0Zvd2u4kc8BIX2NgK+VgVoQGK1xnjA9gsyA/PeiCXI5j9MFpcLQs8Uy2djmtqYkxvtd6R1baTbe2tig0txy9KdHmHKGCiGNA4jbr65Z1IDTOZhLpCqHfUTyKFefW3NSOQh18753yd6fqOXduWkJGmPPDhwqGohuSQlenpXY54A3P29GLTh+1wPlLZpmYjhtC0kstikVeYfnnAeTuJUsjytUhYXYLofX7UkvUkhH04ofCBzoIqQm/rMSsqEq4d5r5E0QoEJ0c5VPkbMAhJRUWAED0XL6n+JAqR7f/dhnBaORomvnIOw6nPH4sasBPbnE6y/2W0zqRkBM3YP
 JnZlp3AZ
 x4Jxt4fTHvmHkqGUhxYJ/myksFrMYfdZGVWpuz3eINEhzY+JdqvBzKsR6ydrVlD+pUPQlCO3D8pYBFWfXPjaldN1NQ1+XtRYFcgSumKNwXR+OpcQ9pIKqld1l3wGHwcwQtB6T4qVGIPrr8WCzyGPuc7yc7uDTjESR3ZS3XbNhTQggEaHgqNGqRSRkhAR834C/wYxxkIhKPnb9+JT7qYeuRIDd6nVEjmip4Y4q4q1t3uO0sgrfYBGX26ypPyw73Dhw12xwavyYpRKXEZQzMfIwi09CeCmmTUHsGNvsb51Af5VE34Gkazn4N1VYwdiPAhY3toZQ/WNjm+8CXKnTNW2VkQd+fKLzDFIOIUA+cn6665EStRu4SSmR5gxvlL6wae4ZKX/bfV64RAPJCU0lzz9+VQFgUo7qenP60kdAAP11BsTjq0VK/ziziRgnt+QUZCVKkZY5PyiHgLisDVwVU4qsaWr0YR0HXpPhsrzXd/LE7CwGr46zTQB1CPvXy4UMrERvCluzehJvAQcducY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-12 at 05:13 +1100, "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote...
> A munmap() of anonymous memory can result in a use-after-free of the
> anonymous rmap if a concurrent device memory migration occurs and the
> migration runs without the mmap_lock held.
> 
> This can occur for a long-term pin of device-coherent memory, or a driver
> evicting its device memory by PFN.
> 
> Consider:
> 
>     eviction                        munmap()
>     ========                        ========
>     migrate_device_range()
>       migrate_device_unmap()
>         try_to_migrate()
>                                     zap the migration entry
>                                     unlink_anon_vmas()
>                                       last VMA: free the anon_vma
>     migrate_device_finalize()
>       remove_migration_ptes()
>         /* locks and walks the freed anon_vma */
> 
> If munmap() runs before try_to_migrate() instead, the folio is no longer
> mapped and gets no migration entry. The walk still runs, and follows the
> stale folio->mapping to the freed anon_vma.
> 
> Resolve this by pinning the anon rmap of each folio which possesses one in
> migrate_device_range(), migrate_device_pfns() and
> migrate_device_coherent_folio() before its PTEs are replaced, and
> unpinning it once the walk is done.

I was going to ask why this wouldn't also be an issue for migrate_vma_setup()
which does something similar. But in that case mmap_lock is held across setup
and finalize which I guess is what saves us there?

> A folio which is no longer mapped cannot be pinned and has no migration
> entries to remove, so skip it rather than migrating it.
> 
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: e778406b40db ("mm/migrate_device.c: add migrate_device_range()")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  include/linux/migrate.h |  1 +
>  mm/migrate_device.c     | 39 ++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 39 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
> index 78424b3824c2..c6cce7925b9b 100644
> --- a/include/linux/migrate.h
> +++ b/include/linux/migrate.h
> @@ -136,6 +136,7 @@ static inline int migrate_misplaced_folio(struct folio *folio, int node)
>  #define MIGRATE_PFN_MIGRATE	(1UL << 1)
>  #define MIGRATE_PFN_WRITE	(1UL << 3)
>  #define MIGRATE_PFN_COMPOUND	(1UL << 4)
> +#define MIGRATE_PFN_ANON_RMAP	(1UL << 5)	/* mm internal */
>  #define MIGRATE_PFN_SHIFT	6
>  
>  static inline struct page *migrate_pfn_to_page(unsigned long mpfn)
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 7ebd02ec303b..5fe11dd01291 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -552,6 +552,27 @@ static bool migrate_vma_check_page(struct page *page, struct page *fault_page)
>  	return true;
>  }
>  
> +/*
> + * Pin the anonymous rmap if present to allow migration entries to be safely
> + * removed. Returns true if the pin succeeded or no pin is required, and false
> + * if the folio is no longer mapped.
> + */
> +static bool pin_anon_rmap(struct folio *folio, unsigned long *src_pfn)
> +{
> +	if (!folio_test_anon(folio) || folio_test_ksm(folio))
> +		return true;
> +	if (!folio_get_anon_vma(folio)) /* Pin the anon rmap. */
> +		return false;
> +	*src_pfn |= MIGRATE_PFN_ANON_RMAP;
> +	return true;
> +}
> +
> +static void unpin_anon_rmap(struct folio *folio, unsigned long src_pfn)
> +{
> +	if (src_pfn & MIGRATE_PFN_ANON_RMAP)
> +		put_anon_vma(folio_anon_vma(folio)); /* Unpin the anon rmap. */
> +}
> +
>  /*
>   * Unmaps pages for migration. Returns number of source pfns marked as
>   * migrating.
> @@ -633,6 +654,7 @@ static unsigned long migrate_device_unmap(unsigned long *src_pfns,
>  
>  		folio = page_folio(page);
>  		remove_migration_ptes(folio, folio, 0);
> +		unpin_anon_rmap(folio, src_pfns[i]);
>  
>  		src_pfns[i] = 0;
>  		if (fault_folio != folio)
> @@ -1335,6 +1357,7 @@ static void __migrate_device_finalize(unsigned long *src_pfns,
>  		if (!folio_is_zone_device(dst))
>  			folio_add_lru(dst);
>  		remove_migration_ptes(src, dst, 0);
> +		unpin_anon_rmap(src, src_pfns[i]);
>  		if (fault_folio != src)
>  			folio_unlock(src);
>  		folio_put(src);
> @@ -1384,6 +1407,7 @@ EXPORT_SYMBOL(migrate_vma_finalize);
>  
>  static unsigned long migrate_device_pfn_lock(unsigned long pfn)
>  {
> +	unsigned long src_pfn = migrate_pfn(pfn) | MIGRATE_PFN_MIGRATE;
>  	struct folio *folio;
>  
>  	folio = folio_get_nontail_page(pfn_to_page(pfn));
> @@ -1395,7 +1419,13 @@ static unsigned long migrate_device_pfn_lock(unsigned long pfn)
>  		return 0;
>  	}
>  
> -	return migrate_pfn(pfn) | MIGRATE_PFN_MIGRATE;
> +	if (!pin_anon_rmap(folio, &src_pfn)) {
> +		folio_unlock(folio);
> +		folio_put(folio);
> +		return 0;
> +	}
> +
> +	return src_pfn;
>  }
>  
>  /**
> @@ -1431,6 +1461,7 @@ int migrate_device_range(unsigned long *src_pfns, unsigned long start,
>  		nr = folio_nr_pages(folio);
>  		if (nr > npages - i) {
>  			if (src_pfns[i] & MIGRATE_PFN_MIGRATE) {
> +				unpin_anon_rmap(folio, src_pfns[i]);
>  				folio_unlock(folio);
>  				folio_put(folio);
>  			}
> @@ -1474,6 +1505,7 @@ int migrate_device_pfns(unsigned long *src_pfns, unsigned long npages)
>  		nr = folio_nr_pages(folio);
>  		if (nr > npages - i) {
>  			if (src_pfns[i] & MIGRATE_PFN_MIGRATE) {
> +				unpin_anon_rmap(folio, src_pfns[i]);
>  				folio_unlock(folio);
>  				folio_put(folio);
>  			}
> @@ -1509,6 +1541,11 @@ int migrate_device_coherent_folio(struct folio *folio)
>  
>  	folio_lock(folio);
>  	src_pfn = migrate_pfn(folio_pfn(folio)) | MIGRATE_PFN_MIGRATE;
> +	if (!pin_anon_rmap(folio, &src_pfn)) {
> +		folio_unlock(folio);
> +		folio_put(folio);
> +		return -EBUSY;
> +	}
>  
>  	/*
>  	 * We don't have a VMA and don't need to walk the page tables to find
> 
> -- 
> 2.56.0
> 

