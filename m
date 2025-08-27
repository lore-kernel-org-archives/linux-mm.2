Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2342BCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 01:43:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 592466B0316; Tue, 26 Aug 2025 21:43:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 569F26B0317; Tue, 26 Aug 2025 21:43:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 458F56B0318; Tue, 26 Aug 2025 21:43:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 32B336B0316
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 21:43:06 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A59FC139831
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 01:43:05 +0000 (UTC)
X-FDA: 83820839130.16.400D8AB
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2072.outbound.protection.outlook.com [40.107.236.72])
	by imf14.hostedemail.com (Postfix) with ESMTP id C02F2100007
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 01:43:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CBLssEVc;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.107.236.72 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756258982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hf9uzvMnGBBRhveWpqmnyt8zWtjJbxZuByT5Xmwvjdo=;
	b=I3NKK/jFwQTWX0OXApC2UPSuDusVo9gw/fwzy7OJEF3jv/Dmb3bgovDvXB8lWC7old1S62
	m6RpwGV9uPJOPmvmCh/ft7mls7gpqt7Yp0uhWjymOFSGpYrV2bgmYnFVdm5WcdsC+9Lv/e
	v1Cw3phWGFGX/g3SP+4euf4HRgVigrM=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CBLssEVc;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.107.236.72 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756258982; a=rsa-sha256;
	cv=pass;
	b=PetuVOZePH4YY8XhZ6NddZLMTn1rgkI6tuMnN3Gd7LLcthHaGMlcShSkPtw1QWFAiO7oTK
	ELZpY51rEihX/u+0OgyTEW795Q0obFo16kvwxvUTaAp5P5pv7Q2xIcjYlt7DrnqKVknW2P
	3yNbbclXZgWwN0aRp7VhvYw3ElRU5/4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y2LppdDqjtpu/XD2HMwD/cB6b7N1LKum+LWLggxJlJcmPh3ztv5f8Ge/rbrzX2IY3oWSeghn861TdolKrrDLqccVLnv9ozvsCaAmoqS0PW5qnU/Pm8JT7lVAYwr8tMYN/TCDufOtvNtz0cZ2nC0Tlk+bZ1CQrkw9FQWSWmbSfivumLJMjPVJLjPcRGXGkEgjQZKPbIIadgLVF0LHIBrtRbrz4TaQOeK2jHNSenqBNgA4nEMiQlQ5MkCwS0w5yzUjIdGFHlRrPRSvS/UNaMyL78OWACeky5ejWSTWriTFy9yUh9bdRX6s/Ig22h0rZTQeOfMo1fJQ8ZfCbI41rGTIiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hf9uzvMnGBBRhveWpqmnyt8zWtjJbxZuByT5Xmwvjdo=;
 b=ssOYWR9vaGVm6wD27YppJhv+kxJby9VkfUfb/X5Y0fG2PSyDPKoU74idoOx5JtqtsaYrJEUvf+sbMf3OBMJy/J7pBFGEutxU31ehMChMb5bPnh1bd5fOQKmDKvBj24K1N0pTbCvWiievqr7g2aDoJVmdfjLeBEjcrcQFB5K6U1LCavXDjDQdfS+e45qvHUNQpgTjZZ0lT7YZlpehcQ8KUOz9YH6OY8G3YPabSSDjSmSvzeVfgwyXrta/vdLiiOawS6nAaYvwQcIgFEodkknf6UC9euMWzirU+zMGn3tar7lnw2CUq+Vjb3vQrCHrCAEvLhZIxSmCdcc0QV6Io8aJCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hf9uzvMnGBBRhveWpqmnyt8zWtjJbxZuByT5Xmwvjdo=;
 b=CBLssEVcRL0GOC7NZI+w3nd0doa1pNX8jSkLq2LR9dbf4w/kXBT3a0ffK9I9Akr/zMSA7DaR47mbXI9abUX7+Yj5Gc5bD3s6+gW3A+nsBmPOHCVAAx/S1V1VDVkUVghnRX9IvHzG5ywaWgye3VCVNSAEPOqk8sQ0xvAA1B5nn62bPlsEemoFLxNbDol2R0SzWnvJiuQa64c2/ESjpFJErOeY0V/DsP1G58at5lPzWNDpQaAbfUUTEJIdmU0KIZak7FMkn9D3FwXCyfFtxuu9cN/xQMtUrli5ArTHuVk/4mWJ903CzOsZ4YYslEwwCnranjKMve+m8MwmDilOce/zqA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA0PR12MB8748.namprd12.prod.outlook.com (2603:10b6:208:482::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.19; Wed, 27 Aug
 2025 01:42:59 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9052.019; Wed, 27 Aug 2025
 01:42:59 +0000
From: Zi Yan <ziy@nvidia.com>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
 bhe@redhat.com, chrisl@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/swap: add BUG_ON(folio==NULL) to folios_put_refs()
Date: Tue, 26 Aug 2025 21:42:56 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <BA16C3BF-C843-4976-8FCC-159324B2E477@nvidia.com>
In-Reply-To: <20250826231626.218675-2-max.kellermann@ionos.com>
References: <20250826231626.218675-1-max.kellermann@ionos.com>
 <20250826231626.218675-2-max.kellermann@ionos.com>
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0519.namprd03.prod.outlook.com
 (2603:10b6:408:131::14) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA0PR12MB8748:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a35b73e-829d-4cdc-ae5c-08dde50b0de6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AC2yFEfISXUn5+E5NQiYYOyZ/yC77rUOIfD/5NF58qPxVM0DxQNuTF0EPz5B?=
 =?us-ascii?Q?iJioUEGYTX6PWmdFvY4lBgJxzPxebXQA0tsn2bQvVQf/DIjj7aUAkX3Glnv1?=
 =?us-ascii?Q?/TliEwxcw5+9ezjh35bqt46urWXLuH9Dl7uSTevxGZzOc3p3xvycckKyuGYH?=
 =?us-ascii?Q?I4Q22TvNa2CTT1TcNG4uwx3AsDehz4RwBISotiIo+Jmvo2+obsoDm4L/r13M?=
 =?us-ascii?Q?GjdTQWC+xLdy8RTwz/P8MWVP8NE5EzyesN1YM+FmiO9X6u7/hIGj5zwGU3KE?=
 =?us-ascii?Q?76P8rHnyjPsf9ExPNLURtEG/6LrLGce0PcIvsSMBQ5J6szoI6psu3yAlHCxf?=
 =?us-ascii?Q?3NWo8V4heN5Hy4NQoxxQ3ODZe7HEFHxHHL++VyTCsyv7kdQWTRG7CLFk6mpQ?=
 =?us-ascii?Q?eM2p3kq9+BlmYMaaCEF4XYcMNL+5k9OH/ojUVPxqE6FOLxBPHiweAbovSVI2?=
 =?us-ascii?Q?ryykNHnI5L8dw0fUt7/oj9L/HJvJP4L6iDNrEFSBHq8BmzWRtjQ9Vj2EWWTD?=
 =?us-ascii?Q?Xtejeq1T7b6QIPymyavuMmY7sMNFW6Ch7kN1ehshehpRsm6BDv4FB30bXDYH?=
 =?us-ascii?Q?WwtUKLHebnMQXV4Awq8S2XV1JgUTzuQU03Kcj/A/NtcJGL1YmvO9FQPVAZfs?=
 =?us-ascii?Q?Vq5n4MnYd084Z+inIYk3N7eVUEEhkuibYfOPA1qCYwuCgsVYzdgHjzWetRB+?=
 =?us-ascii?Q?4KKZKSyl58lijtzbXsag3b1pnH6Ily3X1tfyI029HpqzrUFwihc7nt6SQR2N?=
 =?us-ascii?Q?q/NuKPMZYILDxlNjWX42tHBaC/Cs/HpPmTOS5hrvN9IX3QVlYZsnhxy2WQMw?=
 =?us-ascii?Q?4M75VZaT7pVIEIKVoWTAPYiBBawn8U2W57WbXmMgUGegOxB56EMMzITW9kt3?=
 =?us-ascii?Q?vKFOd8hZYBh9PUvG14NxiUCz+ueJOp9pVPmxeKrCYDkBUsKwKF0ORoakT80c?=
 =?us-ascii?Q?CFNVFEtqXMbGyaopqBDYnEgOEbprW/Eo+LcjayevoPK1V+7TUfsszDxvmnNl?=
 =?us-ascii?Q?jnT3hIT84KDj30LpUva8wi2+/oNSOFz7tdLk3DCa1NfCPPrErU5xVqNkPo6J?=
 =?us-ascii?Q?tpNGWXxDiV7y91At0cM+BtWLWwB2rkFVFf+RMKegwzq88sTXY46MW2Ar5z0r?=
 =?us-ascii?Q?b0u8L87jdAOQMXXU9lvtfv3EK0F90lmF/edIuzvXBTiOeXLFn3ZPyf+wQMAf?=
 =?us-ascii?Q?DZXL/DQdfpRVO2gsqSDTHiRCY4qOqxgd8+4b3JynyuyAreyhR7UwWRjuH2UI?=
 =?us-ascii?Q?OkuKOEs1cSRuG4ujoHstrmGHtAZPvK9UeBgKZh41kcuqTjBqX8vCeMI3EyVv?=
 =?us-ascii?Q?pwT/dZHTIMlQfbZ7tPVlcANzG95PFQH0xsV+kVFfiZf/uuyM9prSK8j6vc6e?=
 =?us-ascii?Q?Vm/aqTWNcOqOh5Bwx4DCrWN6z4UwbeM1YqkhiSW6wEEUxyps43WinY5v7nQQ?=
 =?us-ascii?Q?xi7hH7FFFz4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GFQEGCUn/juzeS+oecjzyC42he3EdoguIdMJHhX1b9WpL08cdtXIfui6yAku?=
 =?us-ascii?Q?1uG9zpkc4lUNRP7oPrznkvwPij+dKOnq0PKk1u+E12YZVgeA4+HCGn1Oofba?=
 =?us-ascii?Q?KQYLOmHDhde+epPZAgn7pETHuzNPn/LR86SaOYsXR0xLdaII8dr5DTsslLa3?=
 =?us-ascii?Q?Mb9aBQj4yNaf1kHNpuhIo2B14btVO/wI5zwO+5C/VMBbvVRF6u53J3cDcdwX?=
 =?us-ascii?Q?5im8zQpQbPDqgAfNwTLA9F4VSvpWG2k8doYvj26pDnVJ7Qpmya9b9pWxG2J8?=
 =?us-ascii?Q?huV5H8krdXIk/Skt982ZAHcxqI72W/gbJiGvOg6WAQt9PWYnaC7uw53LfFep?=
 =?us-ascii?Q?hdyLd+p3xeq+yjecp+yiD8o80yu7UHB3Mx3gfsRsR0mOaXq5TJmZMAi2jL2h?=
 =?us-ascii?Q?tmoCXyOedFCvFWW+yEQn0GUwNApAiVxKBv3TD+UJIjqUrU7SgCKsXbfuhMAU?=
 =?us-ascii?Q?wb9QFInHJ3+ujdXyyN1kmT/dVFaA9GgcQ4X/VVW2D46qq47ZUeaeGrw5WGZe?=
 =?us-ascii?Q?ZggCnIKTMgd8b5a+tXDv2kcMHQu/S8B6BxOZsFJ7T1yY5kXZAXqODQL6YCfb?=
 =?us-ascii?Q?2IUE+APaLdAc2ML1fZ64R6gVYpiQ3HoQj4HVLv3xu7hiN92PnPA+aX8xdlKn?=
 =?us-ascii?Q?utCnSNm8nosU9MLeMDCK/tlZ7j36XhvTIdNIMCTTM6wP09XekY7Cim4IKVEd?=
 =?us-ascii?Q?C+S9MaXs5BncEMc3FrGN/kyPjc3t95+Y7TE5aUGJ5ZzDi1fwBtC9mr3ffgkf?=
 =?us-ascii?Q?mVbNWhdqFzfZlCbT4TEKWZZ7uT75oUPhF2UaZGZwKumMsJeUD1mp/b55YnEU?=
 =?us-ascii?Q?8uLjQdw3KEypq4Od9pK0+9qgFqBj9cHAzLCwL6YsWIZ697UCJHOYHFRqxWFw?=
 =?us-ascii?Q?kGLu+iPNCUkkN8l4TrnZJIbVu0Z5QnheeBJGWusm3YI5vjq14sC4YK/csbrx?=
 =?us-ascii?Q?H3d4tG0LFLC6yvwoCPl10qwNr60VyGT74HzFzhX4mg4hh3vjeMGFKCLGIBbc?=
 =?us-ascii?Q?nmrPrOUOzVmov3h0Q3tnyRY4uHr5PF1mrqFZgXAGYldyjR8GDtDHOFpasVZE?=
 =?us-ascii?Q?OoGplZbaN/xrPW/v8DJgNhF8HZtE0mbW3dEGzUzegLi4uu3bA2moz+UD4R5G?=
 =?us-ascii?Q?+G4bS9pw8TFrlyfXRr9UK28DDuqKdyBMbigqed/Jlkx+6JVIT/4oTtU2xuEJ?=
 =?us-ascii?Q?VKVXUE8C6GL12N9bs1RuoVVODVqmf0+f3gwC+o82Vb+0djENLbCT0jLzC4SC?=
 =?us-ascii?Q?Q8XPj9t+ew8Vpl9vYo5c2tRusO+rj+uIh7Iq8bqY2QhmwiXqsMjd0EIbQVUA?=
 =?us-ascii?Q?dEswH1pGgYkFv49nDPK1dySxqnStby0nHEDnZBWHMKXHARYtL8ZubNKwzcQ2?=
 =?us-ascii?Q?5xWra5PgA45esXLgXJXKl0tn1vNqSHrwphJXZZ+K/WtS8DnQbAq6aGhpcv/1?=
 =?us-ascii?Q?JGLlq6eikEJ7BiC+FnobuzYuFNYXfMbkgYwK/yA8j2pHCS6quCidl1kqrOh1?=
 =?us-ascii?Q?3ZMA3/0U2k0wdf36zzxVelFqpUoQjE2GA1+m5ijIV21lHmKFktKAT/zIcUQ4?=
 =?us-ascii?Q?uWcTJk6xRqfUfFNZgE74rgcsCmMdHKUPYuTiLky+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a35b73e-829d-4cdc-ae5c-08dde50b0de6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 01:42:59.8339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ljXErer7hNbjB0fZE7tN3y0FiRqEf3kocRDFjk5TIJFagmkwFhIZGDwoclC1JSDZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8748
X-Rspamd-Queue-Id: C02F2100007
X-Rspam-User: 
X-Stat-Signature: uy4wwp1trtuid3cemqyhgbit56yzoff6
X-Rspamd-Server: rspam09
X-HE-Tag: 1756258982-377798
X-HE-Meta: U2FsdGVkX1+d5uZoOBkhpHmEXGsX5twHZ3M0DO7Al7m1hyVrUJ0VS4ZUpzr2lKZfvjDLMfyY+8TJH40FwhtYu+iWjBnFZgX+XQq2OBqCZURYDqhiKl4j2yJYwGNI/LyRetm40crF2v7sc4efMCLeLuljhdKbpQtua3n6vq+fNuAd4mdlkHoxturwhDrsRqd0esd9mBOVgsmEsHLmcbtCmrGi04lBdmz5qK6HWOvpQEABRz9ICeYvYN7bXCJhA4lIigKCS7ZYsEQqiN9KfKcgADL1sKUZkOOuk5hyb9dvzrSHv/8ZYKcZ32aQrfDapUilnREHbNnPzI+gQkCRCBtToHqzAdvWWyD24G8Jf8MiC8E8CLC+KNHpjxfMmM6M8FzQv4upUoa/sArvlf90qiQeAVbpWi+TTkYwK5fw+dqRCtxF7qrthytAPyYYvKZELS3T6v56rvNHXRV7eKJLBkmoiB6dLJn30fBGsDWYb/oPq73s7NoaXKXwnz3yWKcf+VXk6tE5dtubqF5/C2eTIpMXAB9IqEISG6so8VWkYr/m4YG/Nyf68MT7EM9WCPVRY1lv3jbBeoSCOGrE73LnHMMb96N7JP3YKBPLKI5rSljKa/M9xKsproXu2MkyXflqfYKtBjLx0ElMfkeOKUbR9eFJEls8KjJgTDpJwGxTadZloDaA95Dg3qqscfMR3QvNydCMicdjM19iLcqi54pJJ7VJ8Fq8rbyXr4s+wfBUER4OyeYLDIYjsK1+cTy7boKhlXO5Ihh0qIn5pT5Pp5niHFDJBsWCcr8d0x2IN7aBgtW8HzubBJsaWKA+f6iCMtOFR8ha53fF3lZYWUdDvSOtgtpIOpjL89cmjn/W6/2uZ3HGhdh4YFsmk+17Q+GRy4xu6Ol8mGw/h20n+dB6zotjajTAMywEdEaCJsFfS3wSqM+VES/4E9R+OYVnOpEgtKqRMswTnbhZJzkqEuFEryLC7BH
 zEmADXgG
 j+39Cj0XVHSFzS2APLBLZmitfdBtVBy+w0H8NMXERAC3M/QfPLXs09sghLscdccRpWxOwPXrhz1HVbhRhQq8GX4Djk8WXmKPyLGiltqIJLD8FgjpFV7ttNzLE04wI3ED1iSzD5bOCtnqRKs7joONlUb/kzIbHIZwWYWktnipRLjPgngBrIwUnPkwS73sTOCEaNoQfRAZtsZxJil3OPAzDnlEk8uKoJEOjZD4pHe0G66BZgxVW04V2cEeH1YuBGjT2y5wN0expRLWyZBqFUTHv6JukAUHEVr6V6fZ6eQt0m1FqwOoQugDAMFFReDAr/Z3K0TxZMqJX6ZO+Uiih2iaGlzq5uEbA7hLS/JKNErdxZgTdhSD+JICgswbEoq54BOnRz0IJ3UoogBSnP/ZU9hj9rHx0Lfv+0fwTKHJ/bpvRq93PYMMMyKOpcr4mefXbbRL4zqUj1nWdKmU6OoEjw2XRWGnv2NjZelXNHwjpJ/bjj+lneNJmgtPF9vGRj/M0ZdKEQSwtXjdIUeSUlk897mJHiwvRWzQn+vNna+U843OJ/lj4tio=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26 Aug 2025, at 19:16, Max Kellermann wrote:

> It is not legal to have NULL pointers in a folio_batch.
>
> However, the Ceph code does exactly this, and a refactoring patch gone
> wrong has exposed this to folios_put_refs(), see
> https://lore.kernel.org/ceph-devel/aK4v548CId5GIKG1@swift.blarg.de/
>
> I believe this should Oops instead of crashing due to NULL pointer
> reference (guarded by is_huge_zero_folio(), which may silently hide
> the bug).
>
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> ---
>  mm/swap.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/mm/swap.c b/mm/swap.c
> index 3632dd061beb..07ccda00e7ee 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -952,6 +952,7 @@ void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
>  	for (i = 0, j = 0; i < folios->nr; i++) {
>  		struct folio *folio = folios->folios[i];
>  		unsigned int nr_refs = refs ? refs[i] : 1;
> +		BUG_ON(folio == NULL);
>
>  		if (is_huge_zero_folio(folio))
>  			continue;

We are moving away from BUG_ON. It is better to use WARN_ON_ONCE and skip
NULL values:

if (WARN_ON_ONCE(!folio))
	continue;


--
Best Regards,
Yan, Zi

