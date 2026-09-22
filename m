Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32267C982FE
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 01:32:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A52B46B00A5; Mon, 21 Sep 2026 21:32:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2A6E6B00A6; Mon, 21 Sep 2026 21:32:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 919386B00A7; Mon, 21 Sep 2026 21:32:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6987A6B00A5
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 21:32:00 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E483E14032A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 01:31:59 +0000 (UTC)
X-FDA: 85239671958.04.5C2FA99
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011052.outbound.protection.outlook.com [40.107.208.52])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0313980003
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 01:31:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=o+kUUKmp;
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790040717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gYlph9QeQ/YuNvweVwGPcZpIqdapi1MCW77wcBORG50=;
	b=F9Bdkh9Zi65GhXle1yiMt8egyZC64i9q7soGPASaLuRc+UlxRIpxns3xJNKLopv9SXAMiZ
	b2BfuLj2NLVKrChtaeFqJ27eJZOTnttOrXX0Ua5uVwPUOMwuv9ddEgBfbmw272lDk2Hqc6
	HyjZTZQ+pY2Y1+2pV05ht7dEybOXXvE=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=o+kUUKmp;
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790040717;
	b=LMwyl0dxGnr91HZE6i6+t3bLy+jeLtZakPMpDmIGLGVv7zSrD+PVCgzLKEuHT0ENJOTUyp
	WFHU+CqPzwJZBIyaOkjBXhB5ajGX+kNscQR+x0rJqN04AlPdb4cB8Dqq+rVsJH9BownjS0
	7Q1111oJd+Cx+EsWd3nE0MaoDWWYgBc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YzH48cpEnV6Ib0M4t1so7tDMFQF9X/BfQu83/xaoEzOquowr264a/LRSRq/pQzgpGgEnGWU55iJHX83lTX1WcTq0q78FKuAnonrIw7aKl5qEUBm8VjV/n5NSBaGbyxskVROylNARpyaCe/G5dRLlB7z1FvQPp464kCZenqC5cuqkOb6M1AsLru/Xa5XWnEMPKT/dv+DXuLTV+Bh4hbBFR240/sx5/BUco8pNqnpzi8nAjGefuMWpjhlJU0O+t0m+HKEcdnvoRswxTlLzZKhNsEPLX21wrNYkzrhwhDrbm9Ahzce6hiDrRz4yv0i6M01v8tVmLvogVLVZ0ULblVTm8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gYlph9QeQ/YuNvweVwGPcZpIqdapi1MCW77wcBORG50=;
 b=hd2gZ1fAoboXmg53QVowgfrJ/qCZ8LN0/IZZCRhXjHEXw9AcxoihZYMxO7/fJjWZGz3t1PjkEvUj7SNtNq1/Czesbv5Rac3MzT6TpX5uBqgQdpo0YDELnsfZZ2BdrcUzKzrM951fwK7WN0VH9Y0EePi+lQltXHsZVsLd9vtWP/vQtGOB/1DfRkCuO7b8oXelXJ4KcNiaCbShFw6WUwz581B6WvjF6b1XFIis64zoYOMcryg04drlQ8qMC/TuRdOHcEnvrEqtW3j2OtopWoFkMSOWAFW7npLDRrQ/Ow++sNo+mtsUMLq6gf3NEKYX99mNa5MneRUFrmnqN2GxawPSPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gYlph9QeQ/YuNvweVwGPcZpIqdapi1MCW77wcBORG50=;
 b=o+kUUKmpkA8NbbbPeesMybPXdswI3Od8bHSLqJkfMF9xq8tzDd/qX1lEIqdKfWFqjKGiRgeHrR7T4p5v7srVQv6qOFwis90Z3oOzQ8EO9x0p2tmNOte+e05XPSeYYX9Yobx50Dnpdx+PH8r9U/hfxnZ3cvHbSjX9fen7oERxbn1YyVm0trhhGmFQM0eeZni47tvVqQrR/zS9xUBc5EeRbvDF3aR+0HaBDisT4F+p4/A3OuQdWpnTXYaMwvk++s7KFmbaui2PHUm3kI6KOGVlsMRADhBp5/xB58YCRdb2dl0CWGrQmFIjUvNNBZok0ItO5s+VvDx4Rnr2npU9TvPbsg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CY8PR12MB7340.namprd12.prod.outlook.com (2603:10b6:930:50::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Tue, 22 Sep
 2026 01:31:52 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0428.015; Tue, 22 Sep 2026
 01:31:51 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 21 Sep 2026 21:31:50 -0400
Message-Id: <DLLGH1Z3NNZ9.UQWNPS9LB7PO@nvidia.com>
Cc: <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
To: "Yeoreum Yun" <yeoreum.yun@arm.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, "Usama Arif" <usama.arif@linux.dev>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Shuah Khan" <shuah@kernel.org>, "Kevin Brodsky" <kevin.brodsky@arm.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v7 3/3] kselftest: mm: remove check_huge_shmem()
X-Mailer: aerc 0.22.0
References: <20260921-fix_split-v7-0-d25ec991159f@arm.com>
 <20260921-fix_split-v7-3-d25ec991159f@arm.com>
In-Reply-To: <20260921-fix_split-v7-3-d25ec991159f@arm.com>
X-ClientProxiedBy: BL1PR13CA0080.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::25) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CY8PR12MB7340:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bfe70b3-365e-4ac6-2008-08df1849474f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|921020|6133799003|10067099003|11063799006|4143699003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	5iX5yAlwQkphaTb+SC1J1qe5jElxCTMW19xN71AptBU2FafmVJc1J/KPUXDwQ5kCKQ/3n9QGsf9VyDvv3Td/yIsACAQd0EdAekw3oBMJDu66+ppo3FLmezcfzQGZfDNCen14OC4YVxZONrf7lENaycwWKE6TylITeBtHas0rRX/vz4N3B8vuh1kI1YtYYsrWx937jUXhb9rt5b8Ss+Lgx5Ze6MjrvG+10AFID/Sey2OIdXUHHoTLJbifwuE1EwQn0xei9gEm8Vv0MxD1Z3Ve1kC/hx0vlP9FRmxlmPAsSWk1B+xh8BTvPnWridyxxrJVRdwHHEwxAS/wHXsGy4eWwyxFyY9OoB2m1xDIqW2SfQhpOPPeJkOwkuMOOanZW4vgFNgQ2/m70ITOnjsR5/I4M3eEDWh//zf0Pmhv4GYRGEjFkgPKe0MVk9GQpRza93Ibe0qeQ8/cEHGMJH4zwr9xQOqqurP3Csr0gaLu2ec7y8McPM3lHMouXG3hLsxZZeF0lH6FHy27Wz/fflbtGohT7/TYlqk27XxMze74fDqfQhfwA9T7l2niNhCzGjnH82sQ7uYaWaUIFhmuOz+0gjI5WTmFl8UEjS0g+WJWKDSw83O5X7OluV/D9raN/iJYifvZcrv3WkR0/ylrhVRVkmDXom/Z/WjddJz7HF1V4K6x4KsXDuTNoSv7LZlnNcB7dEHS1Ff7BK5Or1hKYRvjcNB/gA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(921020)(6133799003)(10067099003)(11063799006)(4143699003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bUhMZkkyVjB5Z1E4R3g1OU9jcTJLWGNRRXlYSWFUcWVYcnBibm1iSXVNMWZ5?=
 =?utf-8?B?bWJsQllCUFNBL3plK2NtS0kxcnRlOUsremVIQWxGcXZWNW04ZHdhWVR1cnNw?=
 =?utf-8?B?YnE1bTgyQ1dWWmlkUm9OaDYrODJCVEdjNkducS95dkNNd2dNYVdIc2dsRzRo?=
 =?utf-8?B?NVZ4T1VRYzRQRDFBMVZzOHdSWnV1Tk5ObTIzQTh4N0R0NXYyTTM0U0xOT0hn?=
 =?utf-8?B?MW9ROEIvTUxOaTE0MGhZampoRzNUYUJyUmNEbkMrMkdtWldoVmJPVTQreFU2?=
 =?utf-8?B?dEFRL0t6b2pGSkpRL01qM3J0L1ZDaHUwTVozZXE3dHBTcFIxTUlYYjVicGkz?=
 =?utf-8?B?dCtuOE1zNHpGWE9OeXczN0srRDAzd014ZGM3R1ovb0xBZ2Z2eHV5NVV4Q3px?=
 =?utf-8?B?bXdUa1N2NEZ0ZEprNml1aE85MEtvb3JwMUJBU3NHV0hxaUpwbEthVmR6Y2Ey?=
 =?utf-8?B?cGQ0V2hMSjkrRmVuSWtCNkU5SXBpZDJkSXdmcXViZStqZ3lER0h0Q29QeVp6?=
 =?utf-8?B?TVlZMU9VT1ZUOExnWTMwNkFsaEVkeE9aSUowNjFETm91UzlHM0ZmakcvUDFE?=
 =?utf-8?B?b2Q1S2JjbnRmTUVyV2tvbnJqdDhwallIbmc5MWxtbjhZRWkzODJQV2xKb0xB?=
 =?utf-8?B?aDYveHhYZ3hObXM5bUg3QU1DbHUrL1BaM1FRUFloTkJiUW94STBuT0E0bHg4?=
 =?utf-8?B?Nk5JTWNoY0tzbUI2YzZOUzlFZlhWUnRPZTB6dDdUVVpEL1BkdWtYRUk3TGt2?=
 =?utf-8?B?UGdrV3BSU096alJnNGlKOGlrRFRhMXJWVlBXdWtOQS80VHNnM2lKbkVNTm9W?=
 =?utf-8?B?WXllc0cydEduNkJpaUJhS29zbzBEWWY4VGtNZncwNFIvMFYyRVg4a1kwWDU0?=
 =?utf-8?B?S1dYNXpoT2NSM2R1R1FLVEVxbnRhVFBKZU40b1hoSFYrdytHL1lLQWw1dktS?=
 =?utf-8?B?aElOYUs2N1VSdVpkbE5pYXBkR0FhYzRVREwzMFRSb3BvclUyNWhEZmt5Q292?=
 =?utf-8?B?UkozSDkydEJ2bzlRWm5DZlVUVXlzaVJGL2krNmVJci9HSi9nKzZEekhNQ2tR?=
 =?utf-8?B?Z2hnQ2o2UWVuMDcva3lSMmI1K2pHdktrcFk1TEJiWVp2aHRTdlI4YTNWcldT?=
 =?utf-8?B?c0w5eThnMEU3R0RSTnpwS0JHOWVDSDlnOUc3TVE0aFdFbDBUdk9uQnFvNk8y?=
 =?utf-8?B?bnhVamNqS0FwSWhoOVRlLzI2eGllS1p1QjdBMXBnSkhhejVTZ2puaHppK3li?=
 =?utf-8?B?Z1NiZkw3NDYrTFZkdlZXRGNCVHZoQkVWbjBmak1iSjgxSmptdEpNZkptMzR1?=
 =?utf-8?B?Y0xkZ0UvNXlqUnpuSjJISC8zbFNkWjlpVnZzNG1uenVwYmI5S1VheGc5K1hU?=
 =?utf-8?B?WUU2TkFON0c2ZDJFaVRCNGVlVjlTdmc1VXZ4bHZZbTBEK2hGU09QcXpqNEtM?=
 =?utf-8?B?YTdBNmJvakxwOFBpREE0b1Ayay9JaS9HTXl5TDVtZmxoMjdteWh6RVdpd0dY?=
 =?utf-8?B?cU1QOFAraWNSdEpXUFVQdGJVQ2ZPdS9vTERyMndxcW8zK0MvUSs5UE5Yb0JS?=
 =?utf-8?B?anltTnlnbjB2K3hKbTJsb2ZKMG14M3VjL1hOQjFrSnQ1OSthSHJ1Y3czdTg5?=
 =?utf-8?B?cmUrRysxSGU1aWRtUlM2UTFkYTM4ZDRINEFseTVjeVUzbW9NZGE0YUQxSFFH?=
 =?utf-8?B?K3lNS09WY2pJcUJDVWpZaGVpRHJQYi83MndobXJHOWhjRlV3bm9VUWZQZmRw?=
 =?utf-8?B?MjRLOFhTRjh0U2tXOE9ad01mTWRHNmt3RmFEMUIxZkFwMjJGVXQ0OENzZjVy?=
 =?utf-8?B?YnlMYnJjZmQrM3Y1a2J3UytBQncvQ0hwVUhsUFA5ZktURU1zM3NuVDdwcjcz?=
 =?utf-8?B?SFVRZDBMQnFmM21YZWM2dmdYZ0EzU2hwemtWNi9KY2tkYzhLVzhmZml4c2h3?=
 =?utf-8?B?ekNvZVJnL0tSb2Y4SGVkcWtiOUd6TkJXZjlSb3hhaW9rUnAxT1ZDSHdsUnBZ?=
 =?utf-8?B?Nm1nVXNBM1htNCtPNVdlN2EzRDdKeU55MlNXNzhtVS9pcG1nWXg5UFc4N2Vi?=
 =?utf-8?B?MWJTc05NcWpVVnBncVF0RXhRUDRoOFFteDhDNS81bUZya0UraVo2UEY2WGtB?=
 =?utf-8?B?UGllRUY3ejBRUmVBeWVtamxubXZmc0lLeFlrWG5uc3doc1dUaDVUYzgyNGVQ?=
 =?utf-8?B?MDdwcElTUCt4RHVUME1PQWhoNHVQWDFjSEdmdHk0ZHBWckZKdU9YYUg3Mmxv?=
 =?utf-8?B?bmhDNmpWLzhucnh0QVRRQUZPcTV2d21QdlArbDBZUTlDQi9IdVFQTTZ0NFo2?=
 =?utf-8?Q?E1DPo8OayrFsruUXgT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bfe70b3-365e-4ac6-2008-08df1849474f
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 01:31:51.9144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EBiMjUdVvguskyic58faUqdx8wd6DzCPp6PbRoZsjL8N4GPFpJ4Q7zh0WsvEwyge
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7340
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0313980003
X-Stat-Signature: 6gpc57xpojxhpu8wizi3thc1doiy3kfy
X-Rspam-User: 
X-HE-Tag: 1790040716-889682
X-HE-Meta: U2FsdGVkX1/GWS8+G3twaxqNfud2lWmdnZJWtKVPKByFasAkKCdnvXMsCTEcLJQKCr13PXtA83fk7nImHo5kRP0L0EEp7VGIqaGuk/JWEIQCvsJsHsX516hfNfH5S4Nv/jS+7NiOpWlN638n1D26VXbIfV90UqMoF886LmA1CI8fT/vS5/LqHZB57iqD8wg6JBSlOGJAK0hTCGTC+8tI+7e8DV1qFE/yO6Welr2enpCcUwYGyQkiWfGgjNN93whzuTu4Lh+Xl0A/lInVHhnWn2sTQPZv3g3cK0T/e7m2QiXHCalfK8HlYa9WzQsFQ6iDKXvaq4EwNb1ZtYu6e9wG095RK1YC3SN394fKJCFbeSIXNwoV7Jl3KKx8aZiWbMU9b6k5moQ2cn2bHz0w3oSrafFZvJBWoSG1aFDlt816C934OTDl2gk5DIEeJzHHZ0SlU1v3l3bgPFp8W8SV2PV7prS4iensyQ1ovDLy+XOu3WCulCv6dITFb7d4IvmOKIoRCUJiIVB3vjECY9otuW30y8Tbigv9pBCMpHQucHLWOfffAV1/yt7F+WNLBFcgYAcJhjngJZRR/diuKl/SpZLzPVbBsQ4DaY/S2j2Q1YGKbfOfsJl0C2u277mmUxY9LBQpuGqvFawbC4ySVVi2mP16HMnxq5+J46dR8nBDWYe71sIYV2Z2FYMz8gVHutXi/JT7x3djL8LR190bKrfqT21gfGgMLYuLq0Qy6lTmmrCDQwuJR+F/ZHnkASpUvokRza0/DPGLaEZHlYOR3tvwFBwuq7NvtkAu6zINhVSgDgeUWzele/tnFUCm5l4gPxH22kuPd5WNQwdUTbpxtgeadf7ksRQCR/Vs3bzNOHO2W6sQZRMO9of73iSfgxAhYBTHPeiClw45kHE+A3xvfdhxjwXd/BpPnskD/QKhLm9lzZgvDCjElRDYigy66UWwlAZmuNnACEChCoSYBTV126G4a6X
 e9U6ZwA3
 zkGsom24WxAiMru4mR2CUu8sgR/fWavaFU3xYBSkT0QSLAG16MxvZUs7XXXsOLfRx7T1tajRCgA+SqOLqu7YDBtG99KB4iX5NPcaotlNFIne4vMWbWddRFEGZT8iuc/1g1pN3V3PyQlaA/4ZJ7k5cfT80v63fydvuoWgN7wA2qMv822X9DgEc4YOeHsxZwFTQknmYDQBum/dgLfFpAlBc+hk2apkxbjU+h/5yPOQtyG0IoF7CieX+pbTecvAB11zcyeaPzbMAEWOPhfP7K4JZBp5ZTyEoFNX3A5A9xwve/2RYmD0HaIO5y1lD+Vw96c+OejgbrE63tXfmZL4OXoU0PEyRcHkzWo61pygWk6tCvHYDeoD/80KyFPqEkSJJ/7Hmw0flb/JPRPr2gfrp/L4ZioI3OvUP1PCu5p2XEiM/p6qW2sP2EbqTJgLLDpIGDbxPJRGriiet6ZxDbh+u++ZrjlWr5lln5C3UjEv22aGQ4ZI6bFzWnhCZ8TWfmI+iNKyxBH2g33zhKbvJYraW+613kfipzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Sep 21, 2026 at 6:40 AM EDT, Yeoreum Yun wrote:
> check_huge_shmem() was required to distinguish shmem huge pages because
> /proc/self/smaps reports them using a dedicated =E2=80=9CShmemPmdMapped=
=E2=80=9D entry,
> as opposed to =E2=80=9CFilePmdMapped=E2=80=9D for file-backed huge pages.
>
> Now that /proc/self/smaps is no longer used to detect huge pages and
> /proc/kpageflags is used instead, it is sufficient to distinguish
> between file-backed and anonymous pages since the ShmemPmdMapped is also
> kind of file-backed.
>
> Therefore, remove check_huge_shmem() and use check_huge_file() instead
> and cleanup khugepaged's check_huge operation in mem_ops.
>
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  tools/testing/selftests/mm/folio_split_race_test.c |  2 +-
>  tools/testing/selftests/mm/khugepaged.c            | 38 ++++------------=
------
>  tools/testing/selftests/mm/uffd-common.c           |  4 +--
>  tools/testing/selftests/mm/vm_util.c               |  5 ---
>  tools/testing/selftests/mm/vm_util.h               |  1 -
>  5 files changed, 9 insertions(+), 41 deletions(-)
>
Makes sense.

Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


