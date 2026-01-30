Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7078D49C92
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 10:51:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BC436B0089; Fri, 30 Jan 2026 05:51:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59E456B008A; Fri, 30 Jan 2026 05:51:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 480106B008C; Fri, 30 Jan 2026 05:51:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 37D816B0089
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 05:51:24 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F3770C20DA
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 10:51:23 +0000 (UTC)
X-FDA: 84388313646.24.171B90E
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011023.outbound.protection.outlook.com [40.93.194.23])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5BD8840006
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 10:51:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GkpJMzET;
	spf=pass (imf07.hostedemail.com: domain of jniethe@nvidia.com designates 40.93.194.23 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769770281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GjKrklgDs0kHLYuOwEAzFFY0Zk7z76an4TOf5phzNpk=;
	b=gRpK4te57mc9gCU192NV0bB5ZtVK/H3dOXC7cNfz0+05mkfQXA86tJ5c/8v+b35gtXEJ9q
	EfO7Y1EpP4MUuzSvkcDtuHnaXk/gHCPLnBYOOKbAgVdOZoXuagp6lw2QVPb9ya7W49Efuj
	RlBTS/cZCplwH6GeTqwwiOztgjFk9+s=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GkpJMzET;
	spf=pass (imf07.hostedemail.com: domain of jniethe@nvidia.com designates 40.93.194.23 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769770281; a=rsa-sha256;
	cv=pass;
	b=zqM0ShFQ4XPnl7bkzyNOks5e9xBsfyAqeT4Kan8UKablcJ6qDWsx7Xjnyz4m2MG8vmG/Pr
	Tnw5BcvzqDD7bT2gCNVuALQuSJ21gW4K3EvN97eAzi90UY3S1gGpECasfmTARo/Rq1c6gK
	8nkffUg1cE+bOdpX6DCwsvXpTIGDa6Q=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cyp9P4grPllzOXb/FDfc3P36Ny5HUJfdzXyZKcwlputJP1y1PI4eLuMGnLNsd8V3yewqqZ7wHo+2IGkyPBcUK8BUBI6yYb/NmH2J0Hr/mOkh285G1ooEhhcRUZ9UIjNBA9GCCXvHYBiVCPmMlTdt+pXcCYoYhjRYymkflaC2md/A+XvyReKuHAj8BnNqoOdiUaWBIuA6wHYzE5ezU8ivNF/j7Noxy5r2POkT2YMIeRK1Ld+OVUxJHT3htW15r5XYLZrvwJJGuXejP5ZWV7SJbeOiIu7sDkZWB0AjF5cfjd1Xr9ycd/C0oNmqz7QCjCvLr+kl0dNGrLmznabq4iWRwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GjKrklgDs0kHLYuOwEAzFFY0Zk7z76an4TOf5phzNpk=;
 b=HptKduOHXFtbUrTMrW7ZXzIb0NpvLkykUCZomR8xRE7jGSQqP20pnYSoJRXxU90lVuJNDMGDsnqm4aRkWtVlFvruxFYcE5P9M7viodqz57ROas6NqgG3UC+/zOke72SIfLaNqUeBoaqtrthjj9GhcprVrt/WpyseSJK3JVP81Ps2f2bHkaeNMQY04MhdjdCOT0qY0EVUA3RLjt4BdNlwnN4InC2OCV6tEFiIm8vp7oDl9VTd6ICN77/jcfgfQtSqYk7j6vi7NkTzfk9ps9c/UgVdVLlYCU2EDuj6Ny+EMU5lYBJZe61zi2Ad1tooo6qWFJV5/BSNS20bUg/tM78+3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GjKrklgDs0kHLYuOwEAzFFY0Zk7z76an4TOf5phzNpk=;
 b=GkpJMzETfW/TDU5BktojofP6jw4MzKMlonfoZYS3qDmQjj4x7xOqZBuFpCelfdaRNJJuiBJQrXaGf5HGdXv520LHAqrJP/bO31wG/jk6OfVh3gA7NpRHwiNfHkNNfWQ/Tn4MR70SNm2aZZG5xe/ewz/dOY2fqWGBQgwTDN25oMw6Yi/WTHYXpkZTxfyMubm72rS5fhYNKtl0xPMxZG6LENUaCYNeQfjsv7z5KcoFQA+FbtAoiL4x8i6EAIzEp2z9mJjKj/XCenvWcB1C5maVw9fdcMKBZm4p1Y67N3K+lPw3ywxjNcYtazGwCHWfVjksRMld2RZJOwtgALmld1hlKg==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 CYYPR12MB8730.namprd12.prod.outlook.com (2603:10b6:930:c1::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.11; Fri, 30 Jan 2026 10:51:09 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9564.013; Fri, 30 Jan 2026
 10:51:09 +0000
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
	willy@infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	intel-xe@lists.freedesktop.org,
	jgg@ziepe.ca,
	Felix.Kuehling@amd.com,
	jniethe@nvidia.com,
	jhubbard@nvidia.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au
Subject: [PATCH v4 02/13] drm/amdkfd: Use migrate pfns internally
Date: Fri, 30 Jan 2026 21:50:48 +1100
Message-Id: <20260130105059.51841-3-jniethe@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260130105059.51841-1-jniethe@nvidia.com>
References: <20260130105059.51841-1-jniethe@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0044.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::19) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|CYYPR12MB8730:EE_
X-MS-Office365-Filtering-Correlation-Id: d498a71f-5b81-487b-4820-08de5fed7a38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Va04YSrqMlbcSHSiieCqpd2BHJc8mKtJR0gCSW0gc9hkq1MXwvQb6nXVvGSm?=
 =?us-ascii?Q?WWVEp0kgmWKSyBgEn+i4WfHOkSUnjR4Oberxbw33LGqorqxCQvLRaq0VwMw+?=
 =?us-ascii?Q?5oWdf9OdgUz/LByCgbLe9yZRQT1Jb5qWeZWYFV/bvWuspxp1MWbxz3nA5eiB?=
 =?us-ascii?Q?hsvwY7keX5ClTYmKaaR3f6ZowUEFGq6ect2T5Wqj9AvsEzj1gtfIPXnnjEmZ?=
 =?us-ascii?Q?LzQOBWpxxdASU86CYgstXkv8YGLDTWgo9uRr3RuPkXZ3sysIINhbzsckqKTy?=
 =?us-ascii?Q?qdYyapw9FDfgwhElR/+3drvTiCqCgWM5cQDb1UPNW+4m3cZrMzEwL4r0RS9t?=
 =?us-ascii?Q?9rVtHHAcDASWhWy44RJimhQyflyyqsRovL3PjXXSweqnG91jLBXogUTF8YRe?=
 =?us-ascii?Q?0OkctFn8CjUIr9ur69UU8ddKOhT7Obe7wfnFpwY4HTRgAVosYBFnk7vMh2MC?=
 =?us-ascii?Q?cuaxz2HYxeT93/EBblh9PQRjcCFUb5LwB3zSTPOz4sE81BAun61Od6B/M19H?=
 =?us-ascii?Q?ijIJrqCbo2XYBpGzpOfRrM8AlwPxFLLmY9ADG2Otsih+ted5Z6jJtioTvp5m?=
 =?us-ascii?Q?FvNlL/tvbRXGWQqI4rQsQvR9G4d4FsKpHAVwgNDCAWtAWe35+R32IzrybTxx?=
 =?us-ascii?Q?Cz9wcBINyIpW3ei3SIMhNXJhqXl/bUxDO/3SeJUPyOMET/QOdwvIuDui5Nwb?=
 =?us-ascii?Q?iMMxtQoSmNmUnsYlmZfs86tXKK5o8fS/rvAsyJMkvB6aZXDfVJ146xOISxOq?=
 =?us-ascii?Q?YHjHvgJsCuRFrgzfWdc1jNGBrxwFG0maMAvkrkBNWv6TDOfYkWCdfE2wXj08?=
 =?us-ascii?Q?hk2iAUt41leF7azTIj6uejFL1KK8OnW4Jbt/tpRpfIlofQvkxthgGSf0unzh?=
 =?us-ascii?Q?rEtWPLa36u4ua3QBHX9J8kgqmxoF6IrtXcGFTFfQMuXCb81EgjLCqw1M8Nzv?=
 =?us-ascii?Q?l9ulXJaD8HIloZMUEMaRdGrgeM1RaFhRtPqYC2D4LuztwFEBIEL9/rEVYb4s?=
 =?us-ascii?Q?YmJQai3rebvpxkSwF02wJ+pwdwDuD5sz95Au18n/DokcKqohWbV+5tAn33BU?=
 =?us-ascii?Q?8B5nPaSGvvVJ73fABB3JSNJZNA6hHkmUNx8JVuyF08wQZzVC4/NTxlT4oG4N?=
 =?us-ascii?Q?jHve56EPfQf5pzs4pylOH2yFr2rL40FGctevfXkVWNAh5IfZh7NYeGQo8iWA?=
 =?us-ascii?Q?UByaCS9IrbLic79se9RIVkIE9FujzK0s6+1C+m0uf7xXIX2oKpCj8w8NXxHW?=
 =?us-ascii?Q?9JRzl1DAst9dkQGy/FskOir671e2HesPJtQXZcOsvv4iSkURJQq18xq7dYKd?=
 =?us-ascii?Q?FH8bXA/iOXsQjYtzOfd3RNspkAZNtDknH/Psypg+1nL69ubogkjzF2+HG7FE?=
 =?us-ascii?Q?0CtCTfdDPNN2QpOdkx6MyQPmsREx7LMq8m1iM/K3YWepNsufx/B+OKP92KQY?=
 =?us-ascii?Q?reaQFH5oj9XEFgDEbBQkSvYblktmf7v4Ea10J4fNENTC2U2zg6t6n1IEOMzo?=
 =?us-ascii?Q?E86162ejV5JX9xtesbRuFrZoJ98GJ/T846uNROxFWGMC30azNNVhoIGDBkt/?=
 =?us-ascii?Q?CoEFhwXGDgTVSzRMknE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5NGsrUvHZF3pEiPDsGkB3Av0NRaM+QhZh9qoPjLApG/KXRrVLgfid4s3f5tN?=
 =?us-ascii?Q?GDW2+514pqK8/n9MqIL0CYzEAKudUnGoNFMthCoY6jAou1ClHhXUqZqFMWqS?=
 =?us-ascii?Q?mka75cL8rjvqiKPWYe4tnbJNyM8kbhmgNwSSzT3SY8ruGUDwoA4ZBVJXytiE?=
 =?us-ascii?Q?kf9WzCcy70pPJeT0KH/wWnqbi+SLLHS3rxuyHDb02xA57ccU4J4WhEjiZ64Z?=
 =?us-ascii?Q?g1zudsDiITgB145PBh4uqwh8ESrCRP+XQBJ9fIX2pfTmaxv/ymH7CD6oDRfT?=
 =?us-ascii?Q?EwPOCpB+ZunZlloXH39CEVygIwIHtdi8LpaQ3hu9z5g75lT0z/n3pSeVdlAS?=
 =?us-ascii?Q?jmKAK/x6u+OeoUsTwDk4YxIaS17M99c4onc7TNBsn4DYfgHf6o3AKpxoyz55?=
 =?us-ascii?Q?f+s22Mpy91VCSInDHXMIBuzfgqzAE31iSzZr9HDjkDndWOTcjAXi3DAhXAE1?=
 =?us-ascii?Q?pV+HCYp34ZOCySLAnzJDkjQCNgs3D+9E8ArmwCYHhc7sg4gKcHIrGn2i1kdx?=
 =?us-ascii?Q?g27/ITZ+Zv9904FeObtRotRPHaJo7Dpf4zRD13yLozpM2RR/nHekYAhkKlcN?=
 =?us-ascii?Q?X2cajPViN13g6HEQrifdna1QLTpPXLRcelvb+1y14NaeNMumlTHOXpHT5oIK?=
 =?us-ascii?Q?2pInPIGJTvsoOEf+rqsw8yc9OZZES09mIQGr1Q9ZIXeYwYJRmia7Bk9qQyWj?=
 =?us-ascii?Q?QFjF/z0q0yTtrASsdJ5iFScggwOu/it8zm+siwf9fQTnRQDy1WU6vQ0pxBNt?=
 =?us-ascii?Q?BC83HuypRR9rDi46RXHrNJp6As/G4KjWtFu497m7cuK2VYBcZoZ5pbQIQRq5?=
 =?us-ascii?Q?Thom99wxQx5eWNjfWh+U9bcgj3Tz1xrF07YV5qCM6eVsjazbaGdi6hvJbV59?=
 =?us-ascii?Q?7/IHcEcIwfri/rDyEW2F1ds5VnHNFmwuQaIED8E2SQ6qB4ImL+RCQlfZUNtQ?=
 =?us-ascii?Q?/eoCJrqTH3lUXhYgMbv+lINBfeCXLTIt2jWmXh8dj+H3be7U+oHnd9zPq5n1?=
 =?us-ascii?Q?YPEynZmCRzZUExLdeIUOj7ZsRsqNAerLtOu6w0JZ/5ypm2qnX4QBdH+9Gtuo?=
 =?us-ascii?Q?XjLQ8wxUqv6mDe8scK4RYqlQIkOta8PQ45+PZI+KlsZBYD53QjbKt585+XC7?=
 =?us-ascii?Q?qKxQxo0RI7hHrTsFwSmul0iZE/zXT1DRqYt1QdzMqJXQKUk1BAt8AdJiBeSZ?=
 =?us-ascii?Q?wRQ3w688HAnZMuXVTRRwb/RAFitiHVyUdiQiS9G0eVGcnPaXLm8R0XLdTfwi?=
 =?us-ascii?Q?qKB755K547aJzJ0QI6sjb8hz1nbX+PieXqP/kRT2DM0g3oSRuJDHga3re6Wq?=
 =?us-ascii?Q?9aAKMtsU8uWez/OaxzrTQx4Yy1lRuZrVsHTwzFsXOiW9pnAzatJe2+Tsxokw?=
 =?us-ascii?Q?KcFamux5vllz+vviSo9CDOeyGphTDXySPn/4VBWgeNtPNztydPJsixI+DVj4?=
 =?us-ascii?Q?k6kH/32vp6NYiVpH9I2r0DvjOkGYxuAigTEENWW8FRCuiosokTkE/PDv4RMb?=
 =?us-ascii?Q?0D6GQ0hoBLVRlNgHWgfal+/P48dABqlnxEnt7b+kL+U5NHfq/dtoIpO1O6Lt?=
 =?us-ascii?Q?Yie8tnDHRQVmvECo49xUs8ViQ4+HGuuybWpP6cl1+BMUY9ftyqaYJQ5phCuR?=
 =?us-ascii?Q?ybsVILw+PysVOdMUUT4T1sUJcFNCcon0ylUiHUd8PdY0CrVCJP05lmIg11a5?=
 =?us-ascii?Q?XbrZELR3ceWt9Al7XdeIlFUgsFAn9OZwgXIKaNDuw+4qqOKS4lWwTxKG3Tq9?=
 =?us-ascii?Q?xHs8CySxAw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d498a71f-5b81-487b-4820-08de5fed7a38
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 10:51:09.6688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rcHAzz0SmBak5wyVH1GgBzV3YqpwXpZrdMnVZ6MpT6VQoQiefWOlfv4d+WZBQ83a2MTKuC4X6yeD9enjdp/oOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8730
X-Rspamd-Server: rspam12
X-Stat-Signature: woganmf4d3su3ukij1ojirfoj9wey4ft
X-Rspamd-Queue-Id: 5BD8840006
X-Rspam-User: 
X-HE-Tag: 1769770281-7192
X-HE-Meta: U2FsdGVkX18qxCrcuF4GNNTbEDADBJGa/bQeZVNm7vvqjp5BDXFJrYK+6FeCgaWFxyNiSDqlX6bo5w+DOlV63AZIKf6J6U1am85y0A8y8nSiCTF2DBE8hBFTeSb0qg8ZqEEr9T4xUGYiNnnZMn0Ud7ClkGKKpsXC5yyJLrqMf0UP7r2ueAPpsRVhMlJhs0stOjC9G01zY6NVaty4q0gTmBB2vITqKdTGu78mz2LcOqpJ3YsJWiophcwykqgu3GVRweHP5Qx5vl21IR6aGAk1wPUPh8F4Eggsi70iKHrNPOCUDkDzFeWNFtZfef+QKFWF2ZZrT4cInBSqjK3ilRNJlAEr+neSGH65HTSHilpB1pjsmUHilgOZ0Lwd4erVMgktE0oTRo7TiWtMiKK0zyFwCtN/gS2RR5OJ8A2ypFgTT5In5ra+2nveoc4qR32R4n7XpbLPDQntCcAZHE/VUj+eDb1PauVIn+tzEmcJvk14L44XWxvBcFdauKM5dz9uW099WlieM5Lhqjs6jh8tcgjXzHdAUzoTcbk+b2wSG7+WDQlJmLD2l0Xgb8lajKj/PAKAZjOrQ/Cu3OF1HyH0z7+yBxiNjv5XT8Uf6mXuIX/jjuKCpEmRs2h5HBh2+YZc0CsMmDYCSj3E+QZECIJwr1axtHZ+2NXqiQpJCh9FoGg9yDq6/MR+rMGItBUftUSNQJrCxzMa+8s1zS1v6Eg7klX8X7/uf9W/0uGClATa+fn7f+/YIQnps8W/tQ8hnuE6PbwQ+O9+TpEY8WXsP3EeELsb60f9GAI7pjJrzfpiMPugV7cLcwP8Ga4qT1MCYM3Tc3Y9hSQRdhYsipCO/7By3L43B3fYIxyqEXLudVBo6r1A883J1BEPHI/KxsP7YcFwPkLlF8oYwNYLbYLlHGcmDANRIjfmIc7c0p6EnvrT52X9Ud4oqlZNDzDN6FpDo9Ct9sFx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A future change will remove device private pages from the physical
address space. This will mean that device private pages no longer have a
pfn.

A MIGRATE_PFN flag will be introduced that distinguishes between mpfns
that contain a pfn vs an offset into device private memory.

Replace usages of pfns and page_to_pfn() with mpfns and
migrate_pfn_to_page() to prepare for handling this distinction. This
will assist in continuing to use the same code paths for both
MEMORY_DEVICE_PRIVATE and MEMORY_DEVICE_COHERENT devices.

Acked-by: Balbir Singh <balbirs@nvidia.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
---
v2:
  - New to series
v3:
  - No change
v4:
  - No change
---
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c | 15 +++++++--------
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.h |  2 +-
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
index 1f03cf7342a5..3dd7a35d19f7 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -210,17 +210,17 @@ svm_migrate_copy_done(struct amdgpu_device *adev, struct dma_fence *mfence)
 }
 
 unsigned long
-svm_migrate_addr_to_pfn(struct amdgpu_device *adev, unsigned long addr)
+svm_migrate_addr_to_mpfn(struct amdgpu_device *adev, unsigned long addr)
 {
-	return (addr + adev->kfd.pgmap.range.start) >> PAGE_SHIFT;
+	return migrate_pfn((addr + adev->kfd.pgmap.range.start) >> PAGE_SHIFT);
 }
 
 static void
-svm_migrate_get_vram_page(struct svm_range *prange, unsigned long pfn)
+svm_migrate_get_vram_page(struct svm_range *prange, unsigned long mpfn)
 {
 	struct page *page;
 
-	page = pfn_to_page(pfn);
+	page = migrate_pfn_to_page(mpfn);
 	svm_range_bo_ref(prange->svm_bo);
 	page->zone_device_data = prange->svm_bo;
 	zone_device_page_init(page, 0);
@@ -231,7 +231,7 @@ svm_migrate_put_vram_page(struct amdgpu_device *adev, unsigned long addr)
 {
 	struct page *page;
 
-	page = pfn_to_page(svm_migrate_addr_to_pfn(adev, addr));
+	page = migrate_pfn_to_page(svm_migrate_addr_to_mpfn(adev, addr));
 	unlock_page(page);
 	put_page(page);
 }
@@ -241,7 +241,7 @@ svm_migrate_addr(struct amdgpu_device *adev, struct page *page)
 {
 	unsigned long addr;
 
-	addr = page_to_pfn(page) << PAGE_SHIFT;
+	addr = (migrate_pfn_from_page(page) >> MIGRATE_PFN_SHIFT) << PAGE_SHIFT;
 	return (addr - adev->kfd.pgmap.range.start);
 }
 
@@ -307,9 +307,8 @@ svm_migrate_copy_to_vram(struct kfd_node *node, struct svm_range *prange,
 
 		if (migrate->src[i] & MIGRATE_PFN_MIGRATE) {
 			dst[i] = cursor.start + (j << PAGE_SHIFT);
-			migrate->dst[i] = svm_migrate_addr_to_pfn(adev, dst[i]);
+			migrate->dst[i] = svm_migrate_addr_to_mpfn(adev, dst[i]);
 			svm_migrate_get_vram_page(prange, migrate->dst[i]);
-			migrate->dst[i] = migrate_pfn(migrate->dst[i]);
 			mpages++;
 		}
 		spage = migrate_pfn_to_page(migrate->src[i]);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.h b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.h
index 2b7fd442d29c..a80b72abe1e0 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.h
@@ -48,7 +48,7 @@ int svm_migrate_vram_to_ram(struct svm_range *prange, struct mm_struct *mm,
 			    uint32_t trigger, struct page *fault_page);
 
 unsigned long
-svm_migrate_addr_to_pfn(struct amdgpu_device *adev, unsigned long addr);
+svm_migrate_addr_to_mpfn(struct amdgpu_device *adev, unsigned long addr);
 
 #endif /* IS_ENABLED(CONFIG_HSA_AMD_SVM) */
 
-- 
2.34.1


