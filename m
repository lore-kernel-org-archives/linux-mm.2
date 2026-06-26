Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 273DFC43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 19:02:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D68E56B00AD; Fri, 26 Jun 2026 15:02:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D17DE6B00B0; Fri, 26 Jun 2026 15:02:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBB386B00B2; Fri, 26 Jun 2026 15:02:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 85FA86B00AD
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:02:41 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E7E851C34E4
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 19:02:40 +0000 (UTC)
X-FDA: 84922985280.30.3FD0DEC
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010024.outbound.protection.outlook.com [40.93.198.24])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1560920017
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 19:02:36 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VfY+iotI;
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.24 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782500557;
	b=cU0RcxBO0maH3aQIvYBFq/S/EGus2cYmKqfpqtYme0SoD71i+VzMD36C+AbRVDMQ0PFyC1
	ngDGkQFZxF9pvWWYpoOJJlN0ofDHah8OJKLlKSq7j/RRNSfZr7RLEYYPs3wAtt8bvDzb0j
	JoVsXapJxtARfQXWydPPJ7vf3UDq6XE=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782500557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LXMaRI2bRsVr8WR/Hfyf7LFNc6/CrdXlOZNi/+5Edx0=;
	b=wu8T4ssRx8s+G6KpQGoz9RzZsIOwZOeZIs6br2JBziGv1q0jT9SyASzihzSdqzTKizpkhD
	6LhGz5gyNTLmNkjiopl4kLSnneeXBo0rQLZtYqNu/Z+kpw4Blij3xbwRC4C0CwjFAzLfQT
	xilUe5n7lp69OlCB7snSxyA4UXiCO8U=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VfY+iotI;
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.24 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YJ75bPO7jCRbumq6bdL/CN5fF9NpPXv2ZBL4F2fmyh50KOwSPOG/0TDW1I5jDVi63irhCdLXV+lfgjx/ep382byh0vTd8M1kBwHpGPArYwxOyLXJZ7WZf51Ren+BlDoFrwHYsEMgzkgNGgeMPgvKwqtXPEnodLernNEENtJ5uZz2W0k5rzUxu96K7WKzlAcvxhYjmtO1nWKjSKdqkZA2faNsuZiyWY1JEd17EMhJC7rVM4BrgbqTZB0vbg0eOpNHirEKl/yA3lMNmLqRUnrpX+c3i1zmU+GTyLe2qnFNHQC2XMM4ABz9e4n8CWR6WkXvd25lcDYfKiUj6254mV5y+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LXMaRI2bRsVr8WR/Hfyf7LFNc6/CrdXlOZNi/+5Edx0=;
 b=rJqEO/WjSmZdfD8qdLKzQluMLq0bAtVMS0pQ94WecohHuPC+lDTbvVPC2GbnvZWXXkzNdCm6pY19GrX8JZN0ddq+4xuqE6D9wTzC7iBzaXF7c1feL2miEg0aTBv+Ie8gjGsEs8zNgVTx7N5x+uaCL+OJ1vMyES/qth2uXMGGTmgeyUL11aK+zcvWjtzffPDdJfLIWMYz56QZCgGjLiv7sfmcvwJmzLlDdmzPaMeMmmCVzXGb8Mm0p/RQrfvJJHwM8iF89y6KDPTbXO1eojazMZQQhQ0Ix3t8hvdkDYdoO1lNWo1qaZCYg2s7AfWV4T19a6HkkyLWSZlX1wcJW8XjXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LXMaRI2bRsVr8WR/Hfyf7LFNc6/CrdXlOZNi/+5Edx0=;
 b=VfY+iotInanG7EXj4U5+2OxCfyfELLBpRCFRjjhakcYDsCnZulAj9ArV4oPk/CaRbrXwRZXIECAHM0W6ocq8cJmxScRJzHC5SOxMMIgdXe0WMKDQ6Lt38GUYGFZMbeW1mTirsiQfo0lcFogN1RbXJhfdcNCywSBKlZrf87kdXNsXrXXqY3RMTy3zNwFdUq0RPeIAdWXKbWoHrl0kvh+xG1zt6s5kquz07ZZAYT9Cs0MVmUeNWap9AN3F9ry3nc5yBP4BEYhRLUdYbQsZ2qNuj28GY4IZis9ISfioQeNCq1VYXFk04+lLrwXKT2blFVb9IAKZhANKbYMjAU7lj7WpBw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by BL4PR12MB9508.namprd12.prod.outlook.com (2603:10b6:208:58e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.18; Fri, 26 Jun
 2026 19:02:32 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0159.016; Fri, 26 Jun 2026
 19:02:27 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 26 Jun 2026 15:02:25 -0400
Message-Id: <DJJ7PI4L15MU.2WLFRN1P6L4OY@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH 2/3] mm/migrate: fix stale list name in
 migrate_folios_move() comment
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
To: "Shivank Garg" <shivankg@amd.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Matthew Brost" <matthew.brost@intel.com>, "Joshua Hahn"
 <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>, "Byungchul Park"
 <byungchul@sk.com>, "Gregory Price" <gourry@gourry.net>, "Ying Huang"
 <ying.huang@linux.alibaba.com>, "Alistair Popple" <apopple@nvidia.com>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>
X-Mailer: aerc 0.21.0
References: <20260626-migrate-cleanups-prep-v1-0-a95933af7619@amd.com>
 <20260626-migrate-cleanups-prep-v1-2-a95933af7619@amd.com>
In-Reply-To: <20260626-migrate-cleanups-prep-v1-2-a95933af7619@amd.com>
X-ClientProxiedBy: CH2PR18CA0005.namprd18.prod.outlook.com
 (2603:10b6:610:4f::15) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|BL4PR12MB9508:EE_
X-MS-Office365-Filtering-Correlation-Id: 4aaf7f6c-8975-4e2f-6196-08ded3b5771f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|11063799006|22082099003|18002099003|56012099006|4143699003|921020;
X-Microsoft-Antispam-Message-Info:
	AvWmXCuNBjDrV1YNQzxwQtM6CxaoHhMYoc0/9XT3VLc8gqIuf9UBgtsfSHOS4k/TSacBxNcajHCe5Ycx3PkpAkjNUoijpwisfjUHpE4Vh8fpxsuDTjvxNkzwv/EwVtwkLIqZ255OwIma8qLfsQQCb8v3o1vrIWI3TvRIH2IVUnKVs4K9S4KloKMc6IBfTmNSmpwo9JgI+xUYV7WB0FT+i+UOZnq8xBb0O7RtgIRbBlOBI7rwqRVFYAFAaX3QHfS0HZ30BIu0AvfVmyK5fr6aLSNworrZ+Jf5FGUaN0uJRxWrqBzuyxmo+LsXQv6STSn0+g+684pek6nmidR6hh/s0RyNavabSHatCZd6RW3izEZEbmtT+c57wc15eMiyLghXJXtCk0p01DZjfOS+bAJLOh14uN8wE4FjGFlJmSNwq/d8Tw31Jz64FytvSBLMk0oEXDWDJAUZF9kS8+a4a0wK1++llspPIZhfALZ7kQXt1dMPpKdW/VxSCnG+rmKedJMvmdqT5BZ60X87iTm2BIcvweMdExkElT9wcPTHrLids/W+cCZDUjGfom3P8YfxJgGwfYcZIwvuNocBsgTdGn+5o3aJL3ORdwT3SfscIPMqs3mKJDIuoOEqMusoYWDP3Eh0ME9AobxUfdCqkQTcuI8G1UAit88T9CWy4TuyFpjQ54DlEBsAjOuxDlbLQHr4QGGnaQyLzSVzh8eaUyiMJVZ4KA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(11063799006)(22082099003)(18002099003)(56012099006)(4143699003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cnJIdlUrTW5iTUVwQWtSU2pVMjQzQk9VaExOSDFYZ3lqdDZKYjdGQUZUNmZT?=
 =?utf-8?B?ODh3Smd5SS9FTTZCa3d0WU1hcFdPMXJGbHJKRnUyUXJITno3NThmQ3JlY1px?=
 =?utf-8?B?V2tBQWFjWGUzKzVhejBEanNRV2NOSWRkS0JzcnY2WTZzYnhrV3BNMmZhUXpD?=
 =?utf-8?B?TkVSVU5Pam02Q1g3TnZTUDVhTzRvVVBaZkl4YXQ0SUIveU0xNkZKdG45aVVZ?=
 =?utf-8?B?Q3hKRS90U0JsSXRjYVdDbWc5VXZnczRaU2owN0wyVCtRMFJVZHFlM2x4cjIy?=
 =?utf-8?B?SnpPWG1iYS9qanhCQTlETStUUGoyV1N3RkczNEdqNmhLYmNVbVlOcjQyVzlU?=
 =?utf-8?B?Y2U0VlFSLytkYzFXc0JNK3pTMHZqS2w5M1Jzakk5VHNYZ2hOVUhqcTFQMXpS?=
 =?utf-8?B?aTJXbnVHS0FETkVDWm9TRlBNL1hJckdzM1p2cHQ0VWdTNHlWd3FoRWcxNnBT?=
 =?utf-8?B?R05YQXZRZHVFSTNUUHJoL1R1ZFlGSksyaTVabXVtc1RjcVZKN3dybm9BVlBk?=
 =?utf-8?B?ZUV2dnhHeEdETzZBYUMzNFVlbmtPb0lXTFAzTk5oOTJtUXhqRyt6SWdtcnBU?=
 =?utf-8?B?QU9pVy9NcG5UbUVZaEJqVjZJNW03ejdleGxzMS9xR1k4QUQ3YTBFRllsZVZt?=
 =?utf-8?B?ZG1JZjlna2NBL09yZHpFM2JqVmpNZDJVMFBDZHM1a3l2WmVEWjYwb3RVVUZ3?=
 =?utf-8?B?NGJWUEVIbGNiZEorNzVReUtLT0FVbzA2OVljWXZTcDE4cFk5YzFlR09vbkFm?=
 =?utf-8?B?bWkvQUZMZW1nRUpyeURSMUNmdmxOK2cvbTl2aEk5aDVYVUJGZG9tdFhxcEo5?=
 =?utf-8?B?SUdicjR6RG55RVZNdzJ3blVTc2lTYk5nQ0FYNG9Pb095OU0wR2tSU1RKVEJL?=
 =?utf-8?B?SVZMSWNrSTNma2prWkl5OHFhT01iWEJVeU0wdTY0alpMTk9FdFhDb0ZsMEpT?=
 =?utf-8?B?UUI1MC84NHN0RENRZGh2TjhIdHhOczRycUZzYWN6Tjcrcms0UnEzemxVZVdU?=
 =?utf-8?B?bTNrRk9QcEhvZ2VucXQzSE1nSXRUZXlJSWQyNndueDBYcHZOWFhldDl0cHN5?=
 =?utf-8?B?TmtMcHJCMldnN0RGYkdWQzF4NmVkaUxvNGlhMmZ6Qk5lSGhINzRIUm1ieENR?=
 =?utf-8?B?UjFtcXB3WmZ5M0QrMHVuSTZiM1ZSZzMrR0pGNDNYOHBiVVg4Ry8zUWZKUlkz?=
 =?utf-8?B?dEhLN0Y3eUVNaWlhenBsZjR3amlyLzBlWnFncUh5UU5Xdk1FbnFUckMySHI2?=
 =?utf-8?B?elBwdFArcDRDMGVZbE8zRGRUVTdzSUR0UUtrbnZlMno5L3JDVkFDNGdtOFlR?=
 =?utf-8?B?c2FldDNYQXEyWnA0cjJMSVc3ejVwT1hvaWoxay9MTjRZZ0VzMUpxalZBODZu?=
 =?utf-8?B?VmlHNUFTd0duUGYwQzQwVTNTQ21rMG16MFk0Z0YzOFBEaEFVYWlIMlBoaUpT?=
 =?utf-8?B?UTQ4Qmx6N3VQbE5MUExqMjVlTlFMNEwrSTNvTWFIRjNMYUlkZHdtTkVNVHQz?=
 =?utf-8?B?UkVxd25POTU5dEtWamswMis5R1pXVDQvbG1LQjlOOFBrd01JYmpjaktNZzIr?=
 =?utf-8?B?MkJqRzVDcWhWWUJrKzZjekxBM3NyN0JBRktEbDk5K3FJSVpCVGE2OVMyd05k?=
 =?utf-8?B?TXNIc1FQQkxDK2JxcGowNCtwNFFib2dmbUdzTDFOc092RkVtQktlSDNXOTlB?=
 =?utf-8?B?b3gwTkhnRXozM21qRTgyRlV1OEtPS0NnbE9NUStkOTdkMXAvZ25tRHVKdXdr?=
 =?utf-8?B?OFJaS2NtZUIwSmpneC9nanVLSE85cVlkUWR3OUVtMUdZSmJJc0JDSTlmU3RY?=
 =?utf-8?B?dzlrRFpFWnh3U1BKd0hEL1EwMytaeXBSNUNkUHZGclZDVm5aSlhuMUQ2RmRw?=
 =?utf-8?B?UzY3VDcyRmtwcDJiT0ZNTXZOaXRxekVUaFRQeFpNYzRZbWRHUHdQakt6MFN6?=
 =?utf-8?B?YTc1UWhuU1JIbHVnOTN6WUFmbzBSRjNmbkpVWjk0V3p1VFVNdStRcC80Z1Jx?=
 =?utf-8?B?QXk2REhmMTVsNGVGWTNNb1lFcHZsWGM0QzJqR2JHWXRrbnFMQTdlMDZmNGJW?=
 =?utf-8?B?VjJFQjdVOXJqbUxIU3pESDltRmxaekVWVURvbTl3TS9VODdNYTY5UmRJWnlh?=
 =?utf-8?B?blM5UURiZmVtcnlzSE9QaXplZEVvSnZETHdodGhyR1hTYmRTb3pHYWdqTmph?=
 =?utf-8?B?OEdaczBRTFd2ZEk1bHNqS3UwMVNkZ0c3a2xqbHlHZWlwOE5jV05FZXEya05T?=
 =?utf-8?B?UGU0RVU2OWNheFpITFBqMFlGTDJZZmYybThXOSsvdk1CVERCZGFFOE9Ea0NK?=
 =?utf-8?Q?d/XvrE+FF4FDuSMn7m?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4aaf7f6c-8975-4e2f-6196-08ded3b5771f
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2026 19:02:27.6777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uO7ZCHiku1AnT8ZAYawP9GGxudGTcyNXjtaSaowKDMR8PZZxbLly+MSAKXj022NQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9508
X-Rspamd-Queue-Id: 1560920017
X-Stat-Signature: 18wp49k4cngy68upoyuwjc9d9xbxk4k7
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782500556-753484
X-HE-Meta: U2FsdGVkX19snaocfn/yDtc/4/5+5GVlQLLEL0jQofLIYmwMO5RuBtFXx7w3qsVHrwcctS0wtDItwptpg3rTue1SRxAmcxuE8S2shXzOnzlq3U6BpMhxkUX/MvGuRlZ04nCWp6Nt8zd15Usbc+6rE1EDYxg2DPfx8ECCm6WjMEBbqY0STTHhR94PjrltNTDOsNmn/GbxWYuBPFQeLCHo+wqp88xNppHOgiNZrB2BFmuvRCEGNQYbgXZ5r0M+dxH0tCf/3PaSeZKTEqOEcz8UMcyzEhzbCg/vH+129KzwExTm+C2pFF0uoAm7Af3p+4RW6AZTZiQ2Uf7VmNF8GZrz6gi1NyAazCCdGPw35bCwbZFrL/6jC7FC4c2oFBUxs5ruugJFBWne4WjL10E7bk3E8nLzGAlNAQUDl2rocnUaHPe62OgtB4XKvInLmf4so2dig9gdA1FjHOxd2QFBPOfwS9RCVnIYljb5qeYgxmjokGHAlD7lzXACx7E56gX1NVZyTJkv+QPGN4BQYii7wGoFqgeVxOPseoULacm+XqIaR4hgnlKE7fR0W1oKSczvp8XHs2O4PdqvNYxEZeTcIooUpyIhx2Pg7155akAT3cl9Okr3iuNifL9jb6uPSTFNRwJlxagYFmkVIzLhRdllrvAgWOmdLoX8Lia0kCVwP1rNLS19+L3h+/zczFA+RnY9jp/qQCzn2Ym18jXJXH+xDvF0fjXxY5EO02HxE5JMRGq+ULWyk9wlWcDyFOdqhdYX1SJkT7JQ3vTQpXc9Tb/Aiwy+ui+/33RbGivI9JmoaZ5s0YRwAFapCEZDPaNrtPzcS4BcpI38Sqhp7kjzjDgIUqhR+DZGBSfzue0zi1YjWKwEVx2HklzeLOtOrWJawpKkOAyVEuxsT3/aVkaxhWsU6kmZllOuJ8Nk+KlvLCA8qgVm9Ek+i0lNrKPKSy+zjgpreeEU4QD8GFpng5BpNdbjV8W
 ninVbxDR
 vJk2Dl/dOla9RtcPBzCleIwayUgYT05Aj7DT/iCUV1k5b3VVESCl45C5fRQ2c+q347e6CTRWa38SI2PWW54x8eU1aWi4fdacf1dRVKxtwu9pPn5QXj3Wdspki1FhlONoRSRwcZzC6K7dUnqsG3Szu9h0zfiyio/BQdydx/Ayl+/oGd0k8HPg/Ho1Txfx+ROVZYQUM/1uUS7qM41AcElhR8sYXeUHcSNKLxuwtPdmXsfulQsEIrqL9XOjz2he9TeKEP0wVWcs2rrYSgLo937h1nXVpUNhTp7mcpL/CJ6RGGDddhw2yIQViCEw7RPc3MyK0zKAFoCO/02X3wWCM3ldITxxIEqU4ReYspnTnA/kZoJ+85Onwo/2i4J9VficCN2QVkRO3LVKU6Ovdw0SpHCW8+a58jSRjQagMHdlvSmn4c3Iei3EAPNWIwWSlzrvg2ZK3tgEKMPwKSDRnH6HNG5Ax4sRTsrGUDbLJUpQ2eJJ5eyYG6j9Jz4rSEdXP77Feq8bSfQH40nNdR9pIQ5Wq5rRwpLM8vBrpcdXdpIq8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jun 26, 2026 at 5:37 AM EDT, Shivank Garg wrote:
> The return-value description in migrate_folios_move() still refers to
> unmap_folios, but that list no longer exists. Update this name to
> src_folios.
>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>  mm/migrate.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


