Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E5B5CCF9E9
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 04:53:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4185C8E0032; Wed, 29 Oct 2025 00:53:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C9478E0015; Wed, 29 Oct 2025 00:53:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 242C98E0032; Wed, 29 Oct 2025 00:53:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0C3FA8E0015
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 00:53:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A5AA949D30
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 04:53:03 +0000 (UTC)
X-FDA: 84049932246.10.874B040
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010039.outbound.protection.outlook.com [52.101.193.39])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9262D40004
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 04:53:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=RildmiqY;
	spf=pass (imf07.hostedemail.com: domain of Suneeth.D@amd.com designates 52.101.193.39 as permitted sender) smtp.mailfrom=Suneeth.D@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761713580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KqUvFkeErNjp2bEZZVnFHna6L8H6Jpu+luFi1oS3SF8=;
	b=LBQQkEkwPcm62+sQdotnFiBFl6CSE0C2f1BjlRRQcZ5FiMAq+sw+3Qd4E9y3u18G9w0zpM
	KH1E29eLFKcjLKonmL9owf6ZAiSM6Z+kVXnubjwwMj1//sKdkyshLhHbL4Q6C/HYTTkMUz
	Pw6SpQP/Ira3oMfO0IDnRgngZSwSz1c=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=RildmiqY;
	spf=pass (imf07.hostedemail.com: domain of Suneeth.D@amd.com designates 52.101.193.39 as permitted sender) smtp.mailfrom=Suneeth.D@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761713580; a=rsa-sha256;
	cv=pass;
	b=PG0gqUsDwIIuZTRB6sFtQy0ZSMDi1J6uG5EA1JzyCgJAGBHlXHkwbKi/Y2uDAPUq/EbP+l
	UwfjES104iq6sZEOho87tdgSc9WmBLIosmk8mrzQzIzLJVe5Y3n4myasySAva8MZcWYnEO
	HqzDiw4TFgLCpJG2UOqL8GbsQ0dgy5s=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nz4Mqg2QnWuaPl0H82WuzlT0Nv+O3YPiLso90y36qVU/PDt3T0uVOwqgIMcRKCpDjDCFc3wnjBS53043q6Uu0bSKtoxubn4D1HpGSM5ekPleRnO7ZQW9FFnxfYNaXP28jlJ/fDntPTqxPH1fqyjBI3+tJS/V1s6gC0hwM9jZMusab98QTVdl3rb2kT5DNAqWuC0zazeRqXdqjhW2NaQ+pubv4ED6CSC8ocm4ChEqHKgtu6HQ7oO9aS2kiJ9MoXszWGAu/3LxHGTSNNFsbOTpuZ0YqwMwRi5G5Rqe4yABks7PZzidHmssy6YNWi608i4p7pZSM5qd3mUY2bJbOfZcJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KqUvFkeErNjp2bEZZVnFHna6L8H6Jpu+luFi1oS3SF8=;
 b=lyUjUISrFnO3dYMKAw3UTGzLjbviUDYtDh3YepiYB5pRM8w+9URQ/V3bz2sxIm/u2ICWOP9PUEdcT2FLXkpL/I5fIa6r5Nv6mchVmmbnZvkcbC64Q+e1I9qIZk8j6MwscQ3Q5hxqqxQPTGAZFgfokVP/BsFgqiVZkpJkx4+lYykC7aNI2RNggYKClZ9uMzHu6btT+CvMVWkcvrvC977+GDv2bNptOyM+Dtuwh+1/bc9NC9Xtwk6mI28MvEdQjdd/In6MlJ81bG6L0303CmKUya15wE5gyUUgKYEhusjj35hssH5vYByPR27MC5GSZiBniTfXjJjYF/npqsPThG4Dbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=shutemov.name smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KqUvFkeErNjp2bEZZVnFHna6L8H6Jpu+luFi1oS3SF8=;
 b=RildmiqYGPHDpJJAHLTAdKFMOZGdKfHiXmp+nbE62uNYvi/u9JgYDTKcKFEdEJrEQdq+1kDSHFVO9P2Y1yxkoe7eYUkTC7jxRTo/vnB7An7hbsSn3ju/SuR39mvJ9yxL282H4x+riqINC3KiPYX7oUq+cqWh3T9ZBo8nKqDSOnA=
Received: from BN9PR03CA0177.namprd03.prod.outlook.com (2603:10b6:408:f4::32)
 by IA1PR12MB8192.namprd12.prod.outlook.com (2603:10b6:208:3f9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Wed, 29 Oct
 2025 04:52:56 +0000
Received: from BN1PEPF00006001.namprd05.prod.outlook.com
 (2603:10b6:408:f4:cafe::3c) by BN9PR03CA0177.outlook.office365.com
 (2603:10b6:408:f4::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.12 via Frontend Transport; Wed,
 29 Oct 2025 04:52:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN1PEPF00006001.mail.protection.outlook.com (10.167.243.233) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.10 via Frontend Transport; Wed, 29 Oct 2025 04:52:55 +0000
Received: from [10.252.200.214] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 28 Oct
 2025 21:52:49 -0700
Message-ID: <b4093bcc-39c2-4cdc-a0d8-0c30ee8e1000@amd.com>
Date: Wed, 29 Oct 2025 10:22:46 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "D, Suneeth" <Suneeth.D@amd.com>
Subject: Re: [PATCHv3 4/6] mm/fault: Try to map the entire file folio in
 finish_fault()
To: Kiryl Shutsemau <kirill@shutemov.name>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, Hugh
 Dickins <hughd@google.com>, Matthew Wilcox <willy@infradead.org>
CC: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Rik van Riel <riel@surriel.com>, Harry Yoo
	<harry.yoo@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt
	<shakeel.butt@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Kiryl Shutsemau
	<kas@kernel.org>
References: <20250923110711.690639-1-kirill@shutemov.name>
 <20250923110711.690639-5-kirill@shutemov.name>
X-Mozilla-News-Host: news://nntp.lore.kernel.org
Content-Language: en-US
In-Reply-To: <20250923110711.690639-5-kirill@shutemov.name>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00006001:EE_|IA1PR12MB8192:EE_
X-MS-Office365-Filtering-Correlation-Id: 24d0c053-8c85-48c0-8a76-08de16a706a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QXVyM3hNcXVpTG1MczlFdloyQjJkQjBKNU1ua3NCanNoRklNU0xQRTVYS1BL?=
 =?utf-8?B?b2x3QU9TRzBpSWRIeGQ4azc3aHdIcXVXS3VuYTJZL0NiNkd6ckZ2MkUrWUJr?=
 =?utf-8?B?MVVGbDVzbkNpTjl1SWllM1FaeVVQd1FTSjZDc1E2YTVlUFdVNjAxeTdGbnd1?=
 =?utf-8?B?YjFLcnIzamw4SldhYmpSNjJyWU1kQXBDRjNDcys2VklpbXlsd25USUlBbkRV?=
 =?utf-8?B?MitxSUZMaVlhSXU3YzVWb0pteGlvSHRUWXIvQ1luY2xzd1IvL0NnLy9vQmJk?=
 =?utf-8?B?MUZrbW1YOWxtQWxSOUhvMVVnbHRtTW5LTUkxc05oaGNlcHMxUTVnOXVPdFVy?=
 =?utf-8?B?a3lISkZqRE1lWnpvNmRJaVBINmhOMkdsQzNnSmRMZVZmYktobWRsRElpY1hO?=
 =?utf-8?B?d2FzdGJnbGQ3dnExNXB3Nzd5bFc1TEpVZHUvK0JRT2lLcTBiYkZpREdYS0cx?=
 =?utf-8?B?MmhBWEZ6bHpGdTVYN3gyZ3d3em4rWjcxZTNmeEMyMnRCbnJ2ZlBrc0ZrN3hv?=
 =?utf-8?B?bzBvMWlDbkJiSUsyd3pnNklMR21yeFBmc3R5VW4vQzhnSzdtWXZ3enVqS1hj?=
 =?utf-8?B?UDFtUndrdnBUUDFsNUJNWkwvZEJMMFlRNGdLY0tEM1JRTkJjV2d6YTVSMDJp?=
 =?utf-8?B?UUJTZlg1OTR2Q2k0UnNLQkZac3VleHFkbHVZelZHbm1ieXRhRHV4R0VkYXMy?=
 =?utf-8?B?ZjVKbmF6MVBoeVZWWTVOVVVCdWdobXJoREo2TlZYUVV6eFJocDM0S1pZSFNW?=
 =?utf-8?B?ZDh4Y1Q0NlcvN25qYkdmS3R1eGVONzZBVC9tNEJzM210Ui9Oekl6c1NCdk5r?=
 =?utf-8?B?eXdZWlJMMjU5alpteG4zb2lLZzdjV2ZJdUtTcnBvM2VjKzhoUlAzWFd2Q3Bk?=
 =?utf-8?B?WnUyQzFtTnhuN2tPbkc5VlUxNkwvZ2JwaFJhY3ZwT29nNWdTejNJamI1a3FB?=
 =?utf-8?B?Uzh1NENXUFg2MWpEYmp0WXQyNktWVVBCb25nZEN2Z1Z1ZmxaZ3dwdjlyZFBv?=
 =?utf-8?B?R1BoUzBDc256bE51UUNKVktSaE9YS1pRRWhGdTNtMlJQWm5nczFYOVRJYU03?=
 =?utf-8?B?UE0wQXh5TTRvcDh0Skk2UkpxNnF2T1ZTcHI5NDB3ODBrMWVuTk1lZkxSSHd0?=
 =?utf-8?B?YlEyeGU0cnFJQS9pVGlBaUtZNkFyWkhMTVliRzc3a1RoWmJORkN2a29ZNmhF?=
 =?utf-8?B?bXpjUmFGdWcyUW9xYVBsbnYrQW9HWm1GQzZWdVY2NjJmRWplNTIrT2l2eEs0?=
 =?utf-8?B?NUVuSW5rWm12OHJvOUErOUhJSWFZV3NRWFpqTk5pT0JKU1ZPdDJ1cW5EYU0w?=
 =?utf-8?B?UHdmZU1VUktOUnhOcXR0RnUrWFgxYTZnNnVrN09jN1NSYmJFRk4xK09NTTVp?=
 =?utf-8?B?dys0S01YWWkva2d2SmttVXlSSmxEWlhiYWlUOVdMeTViZnd3K0hkSG1vVWVl?=
 =?utf-8?B?VGMzSHVUc1Y2WG5MTm5kR1FEMVlSRG9mWnJ6RE5zb01pNFo2R1pBV0FXdVNM?=
 =?utf-8?B?dHNDcHpnQ1VZNW5tUmxVdzh5N0pzTTlxVWx5dEdWbFRNU29CS3M1Y01tYm90?=
 =?utf-8?B?bHVuaHVsMGhwR3c4L2FqVWpwMzJ5ZGpjOVVjVFlScllScVRoQ3RHMGpoVEFm?=
 =?utf-8?B?d3JtRytpd3dTVEh2cWxNWWt6UGFqWkNwQU9uZ3J2dnlCL2FGNTFGT2pHdnVU?=
 =?utf-8?B?WFR3Qnp4MkQ5NERra3Zrbk5BKys4ZUpuK3J4Yno2MzVrYkxUZW1mTFc3QWJ5?=
 =?utf-8?B?SXUxY2FjeEJLSVRiNkJpUk5xeUhrTVMxdHhPYTc4dm1jT0d6YnNxWHp5Zks5?=
 =?utf-8?B?ZTdRQ3FHSFNXSTc4Q2VFeXM4QXpwbHdWUjA0amZ2Wi81WUFSbUVnVFdhNEQ5?=
 =?utf-8?B?WFdUa1NMQlpEVEFIdmo3OVUyeEtEY1dhWXd2N2lDNGNJUGdtcFJ5QTM4Ti9H?=
 =?utf-8?B?Y0hpQ0xiNVhaR3dESkg2QTE4RmVFb2ZFbGMrNWZxS0R2ckF2dk9hV09BYWVP?=
 =?utf-8?B?c3YreHlJZldmbFRYVU9WMVdSMmhWUko1RytaRDRuNVhJcWFJM2RheVVva2xL?=
 =?utf-8?B?N0pOUWRJYm9HeG5kUTF1TzRMaEl1akl3dEFJTVBnTjk2ZEZadGdSeUlTczRN?=
 =?utf-8?Q?dG6ag0s34PmbvCWxYR1O9lhJA?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2025 04:52:55.9639
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 24d0c053-8c85-48c0-8a76-08de16a706a5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00006001.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8192
X-Rspamd-Queue-Id: 9262D40004
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: tr7ipz49qt3og4wrnintk4rpcg9w64w9
X-HE-Tag: 1761713580-934595
X-HE-Meta: U2FsdGVkX1/IeAjfRKJCI2d7+FvDYOwwlXvyQcsDHmq7V7gaAUWNASGvsYCy4XD5rB6mWzazCnH2HCqWeRCdeB2sRv0Q6rNpzNt6jzPRdGeG9oat1rB5Mcozd+asE3EqLZ66wPnnS/W1Uiw8MSq8PD0OlcTzpnxeFJbvld3LVHyoEuDatVL/5dypb5MrIPiVtDa3aA2KAjQd/+WYo3vXYAjN3CLjvex1ToSnFtEKU8dJdPfJkQvXTlitjK1uBNOXkwqncXf/Ii0VJ4oU2WRbAB14tT2CMOOop811DSVsd4OecSgvZtxv0BgZKXN/FTZbDbKrmQ+aNDfTrEtS/Rx3IpMOjVrLmj87+WXujsHBz0PlxPD6vhDy2vC6zajmJluc72DLzM9OgoiQruFZE7s0xgvIzUColTOmImIPTOD/8ZV6qjxMNpkD/jTrCeGmeEc+/OBh/Kfan41CaYJTZmJkFWF4LQhFzuHuS2LC5vPmEUjM2GtbPkuebdV8sUTamCqm3co0cPP3+ifZ53yi+zODwhLsYofccWydvFC99cq6ukA5iuisUgNdxk77k2HYJAwW2vUigx0E/SXrve6FLPIFQOetrqMdhHDLuaXHyb49RJnmh8jaI7+s1RpWvcn4JWD4Vr7Iq2UF7BDWH3E765fy8ilYMlYTdjR68OVNadstcsSTAhpfEM1O1BCeo7w88N06tSsV2U1O5bHkqtw38O10fH/5PYFSABsp4pfI0HGh5zeMyINPQ8BY8fZBbLracp+2Bm7hSf9J7jivuDCyIQBgBpnOaZM8xz3T4840wrL2rLcVqziYho8LIQjNxmhfj2QlQRSfco63ocTxmePP6DP55PK36cmCGOGkItjzMklju/s76y3OHTn6wC5EQ/OL6iw14ziqtNhJjzDfOpbHNk2tNnk2IF3ZfYVpEbe6mTDRufAW2xZX8heO7hiAnOzbRFXZPgLofxStZdWxMSUAjTS
 tWJIVOjS
 EHoN1OLZvEDGHE6W8Cgr39r3RTUTL6lZxMANEM//JDqNIQKvEt9XNcLftQwD00YDlnPCB2sCdgWz7KJz9JZYJkMYptH/LSGImKjM5Pqp1juz4USE4gN1vhQuWQxYu9om+S/NitnBW17BaVeHowJM4Rq3kiWJCrzqWgd7wrXym57EY/XGU06h48iU7MX02SpbNXsRFL4tn/vblIS0t4zsEt8tNkidxHK7rerbFkDW60VlDKnSIhj60yOCSG5mMrc709A9gckLQmU6guYuSkUhlnNXwEZbzEr/hiNpHx0DIxjB1CIhJVdZt+uNUcS2JduVi2g7Lqst5vNCySge3FHJYpdVcvma3wygPtkFZx4yGXVfPCtTxKkWGcExirsDVBPD2zS/NXK6TgjFj2Mb9+E7PXWMgvqZYAEhwlwnwfwybMVoDtHJrsAHCi60sFBeObPlthzEORBJks4gLejL15FPPFslyK9rztpPuqN/TIfR81JXhnR4lJYA9txquVEdv5VVafnrhVPE6XPMyZNPwGeyGxDuUyEIYiErf8yc7DA0jZyMzclv/SXXQ8otf6Z7PyjhQ1CLsEIGVMztMU9m9fZZdkgx9TS2KYwIR2n0zhSHhMpXej+yo1w1/dEdv/RGjtKx4shsa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hi Kiryl Shutsemau,

On 9/23/2025 4:37 PM, Kiryl Shutsemau wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> The finish_fault() function uses per-page fault for file folios. This
> only occurs for file folios smaller than PMD_SIZE.
> 
> The comment suggests that this approach prevents RSS inflation.
> However, it only prevents RSS accounting. The folio is still mapped to
> the process, and the fact that it is mapped by a single PTE does not
> affect memory pressure. Additionally, the kernel's ability to map
> large folios as PMD if they are large enough does not support this
> argument.
> 
> When possible, map large folios in one shot. This reduces the number of
> minor page faults and allows for TLB coalescing.
> 
> Mapping large folios at once will allow the rmap code to mlock it on
> add, as it will recognize that it is fully mapped and mlocking is safe.
> 

We run will-it-scale micro-benchmark as part of our weekly CI for Kernel 
Performance Regression testing between a stable vs rc kernel. We were 
able to observe drastic performance gain on AMD platforms (Turin and 
Bergamo) with running the will-it-scale-process-page-fault3 variant 
between the kernels v6.17 and v6.18-rc1 in the range of 322-400%. 
Bisecting further landed me onto this commit 
(19773df031bcc67d5caa06bf0ddbbff40174be7a) as the first commit to cause 
this gain.

The following were the machines' configuration and test parameters used:-

Model name:           AMD EPYC 128-Core Processor [Bergamo]
Thread(s) per core:   2
Core(s) per socket:   128
Socket(s):            1
Total online memory:  258G

Model name:           AMD EPYC 64-Core Processor [Turin]
Thread(s) per core:   2
Core(s) per socket:   64
Socket(s):            1
Total online memory:  258G

Test params:

     nr_task: [1 8 64 128 192 256]
     mode: process
     test: page_fault3
     kpi: per_process_ops
     cpufreq_governor: performance

The following are the stats after bisection:-

KPI       v6.17   %diff  v6.16-rc1  %diff  v6.17-with19773df031
-----     ------  -----  ---------  -----  --------------------
per_
process_  936152  +322   3954402    +339   4109353
ops

I have even checked the numbers built with the patch set[1] which was a 
fix to the regression reported[2], to see if the gain holds good and yes 
indeed it is.

                           per_process_ops   %diff (w.r.t baseline v6.17)
                           ---------------   ----------------------------
v6.17.0-withfixpatch:     3968637           +324

[1] 
http://lore.kernel.org/all/20251020163054.1063646-1-kirill@shutemov.name/
[2] https://lore.kernel.org/all/20251014175214.GW6188@frogsfrogsfrogs/

Recreation steps:

1) git clone https://github.com/antonblanchard/will-it-scale.git
2) git clone https://github.com/intel/lkp-tests.git
3) cd will-it-scale && git apply 
lkp-tests/programs/will-it-scale/pkg/will-it-scale.patch
4) make
5) python3 runtest.py page_fault3 25 process 0 0 1 8 64 128 192 256

NOTE: [5] is specific to machine's architecture. starting from 1 is the 
array of no.of tasks that you'd wish to run the testcase which here is 
no.cores per CCX, per NUMA node/ per Socket, nr_threads.

> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>   mm/memory.c | 9 ++-------
>   1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 0ba4f6b71847..812a7d9f6531 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5386,13 +5386,8 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
>   
>   	nr_pages = folio_nr_pages(folio);
>   
> -	/*
> -	 * Using per-page fault to maintain the uffd semantics, and same
> -	 * approach also applies to non shmem/tmpfs faults to avoid
> -	 * inflating the RSS of the process.
> -	 */
> -	if (!vma_is_shmem(vma) || unlikely(userfaultfd_armed(vma)) ||
> -	    unlikely(needs_fallback)) {
> +	/* Using per-page fault to maintain the uffd semantics */
> +	if (unlikely(userfaultfd_armed(vma)) || unlikely(needs_fallback)) {
>   		nr_pages = 1;
>   	} else if (nr_pages > 1) {
>   		pgoff_t idx = folio_page_idx(folio, page);

Thanks and Regards,
Suneeth D

