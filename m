Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 057A5CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 11:55:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2793B6B0005; Wed, 13 May 2026 07:55:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 250ED6B008A; Wed, 13 May 2026 07:55:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13F766B008C; Wed, 13 May 2026 07:55:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 051F06B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:55:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9AFA0160B47
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:55:16 +0000 (UTC)
X-FDA: 84762241032.20.9D1A31F
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011017.outbound.protection.outlook.com [40.93.194.17])
	by imf24.hostedemail.com (Postfix) with ESMTP id A7ABE180008
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:55:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=WQi6riJ+;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of Christian.Koenig@amd.com designates 40.93.194.17 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778673313; a=rsa-sha256;
	cv=pass;
	b=A/ncH4XEZDYQrJdTccUETd2NyO2nJ3klk1dV9QZyiah2s7Ge8B6LSfZDDIdLvX+Y8eIIZ9
	Vg9Hp6NYaiddI7mlXivL/SWiHfk9FBL6dG+Y9L5P5HOaH/Hbgbx2+P1HO90ntteqv6uAjH
	FHAd+Ht2Uz4GPEJd1f2hVucswjY67Wo=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=WQi6riJ+;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of Christian.Koenig@amd.com designates 40.93.194.17 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778673313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6MC0slR6NG74jO7RF23QEW0A0V7uir5WrVgG81Je8xA=;
	b=fKXHttfh5Y/no0DJ2PDFNeFIYYjDojv6LpVJUDpaT4Q3HEcskV3M4Uxw/lJYh/FnkjNX78
	/wDSJILL//hytYfEPe4zDdYzm5/MPnfdt24a7upqprQDNTNLbVGGvINICmm6NIsEeK1J10
	jyVVfHeXINKo+7xiAj89nK1OLsFcrnE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZSk3WVd4YXBFW+L0mg1AhitsWGJ/g6eI88sKfeugdzc9YCT9ZqjsEYQinh8PAeZm2T7dNVAgaB36F6a/MO2LpcmZG8C2LlBCV0HSl/q+sbR/72MbBNxbWj6ReYbg9epIJI1PSgw4nrt+jcvm/jQQElPI1MxuIDl234jmphV5IHE4InZdZkc2hxl28Cgm29OMK/JD+WWBInTqs7eejwD59d5fseANKULkibbx6MvvoFq6p7ej8IXE2E++qHYkwkvejlk4x98J+SMul45CDskoJPLNnyf3fFASTAjVTXfoYrstY7OYqVtQvrbhYZBcx032UqVcC0E1dHv0ONzVvUAoHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6MC0slR6NG74jO7RF23QEW0A0V7uir5WrVgG81Je8xA=;
 b=NGmidA7sbxoNJC5Rj0ddX2PGM7X+zMEOAZbUDUUPO2Yql0eDL917DNuhvCpnFHnw0F0SjvNiFhfUdcj/KdaLvM8l/iJ50jRi6UOwInnltknvIsVXFBYNPZB6lf95TYDltdUqm3LxR4J8kS45PFMl4K1s+XeY2aufPk/ngRwgknyaIzb8s4Zl5R92+n6liYCg6gAjdHlg13ppiP4amarbZ3juU2rChVKuC9Qei2TDOb2DTQtOIpiHHVkSOOHEl6cuhsHVxUdoGCNc49gEjFzzXhSunxZOb1zBO6mCSQQ/ukI5qb43tDbu3v2ul8UO4iJCZkzQIBjQVwACIwijtABlcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6MC0slR6NG74jO7RF23QEW0A0V7uir5WrVgG81Je8xA=;
 b=WQi6riJ+fKNQomXi+Y4T2VTLIyhQyNylCaVpL8EBY+kN4nqhjdTSqXqflZRt87+MzIhGhBgnsnr5aUnNqPGT19E+P3mwgxCgv4BWfENAbEmil2D8Y3/VxpDozFaAQ+0UM1E1WY8P3BxjPs43yEsZy5/z/yu8SeLA3Xe7pN3KM3w=
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by PH0PR12MB5632.namprd12.prod.outlook.com (2603:10b6:510:14c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Wed, 13 May
 2026 11:55:08 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%5]) with mapi id 15.20.9891.021; Wed, 13 May 2026
 11:55:08 +0000
Message-ID: <0ba9bc77-ace1-4077-a193-4540880b242b@amd.com>
Date: Wed, 13 May 2026 13:54:57 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/shmem: add shmem_insert_folio()
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 intel-xe@lists.freedesktop.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260512110339.6244-1-thomas.hellstrom@linux.intel.com>
 <20260512110339.6244-2-thomas.hellstrom@linux.intel.com>
 <f14d99d3-c1ff-453b-a280-17b8c4d5af94@kernel.org>
 <b4800086347aa3b27edc42b6536cb3a2b76a1aa8.camel@linux.intel.com>
 <26479389-459b-4cc4-914d-e7d29d5e5cc9@kernel.org>
 <c6b4031a-5625-4b1b-8a51-6e47241d32c9@amd.com>
 <bbde0793-fd21-4a9c-b85d-f13d8b787c50@kernel.org>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <bbde0793-fd21-4a9c-b85d-f13d8b787c50@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR03CA0098.namprd03.prod.outlook.com
 (2603:10b6:208:32a::13) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|PH0PR12MB5632:EE_
X-MS-Office365-Filtering-Correlation-Id: daf8ac23-46a8-4d13-b856-08deb0e67a7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|11063799003|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	aKPDTlLFcoauDeV7g6AYkR8UU1p+0jowkuHMzcFgs3QrbyMnZ+KzIjEk0OGvNMXAml2kR8lBPC35algAND+pMXl9/98B/UKFAWlBT/yTq377OUG+tMuH1nWZ4ycKuFaMRL4OHmBymupLg3cnrCfjjFifYwxbXqDC/yd4jYXDEDewinK53PBkO3kGG6d5PLBToKp3E1yf0g7rtPD1hv+Y8VlglRF7i0devcyZmH5F+OJFF/aRclJQFQCs+eVZoUyxbW3Tjefm6XqFCJPMKDXMgWe46KZwcDjAkj5Ig5nWZ7fhmXYZdAVZOfooX93vYDfkuXD5FjzX2xgbHajeKo920bnXNitEh5TII0bG7g/JnJEN9cK8tD24I6I8I1bYdmISTb9SQdT8ZPV9pDWW6yu4yAsqJSHOhEIROKgCJ5XOtiShcLU4IKLcILEVnUlPdEytXPqnD+wT24GOCTO7/cqay27JHk1UC0ZYMJtQ8oxdsUYy2hEkb0VLKwpkTPPgyoF7+p1uocKfZpL0JfP92kSn1rQO9Oizlwp7AfDQ83XIgRSEfBESvRyeEhBmOTB1GdOg/BPFtoLL+CPhB+DxZpoOTdm5fGj0wrEQ3IoytHuw8+l3fd/gri/mgvvXU2+wU0woDvGy2oYUOME6FLDnn9F5og0QgVkDC4okApHXJXPbRYq+P/HIDSBXVc7qGv6S5hYy
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(11063799003)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RFFoTzFnV3JvUk9vT0Z4N0p5UTNvQThWVGVISmhpNlV6cjNMM0p6TmhHQ2pi?=
 =?utf-8?B?RHlsVUhta3JQVzVOK2xBbVRUZmpQWXNzRDE4ZWhGbzVlUnM4Z0IxdXZhZW9Q?=
 =?utf-8?B?eXRSZkcrNDNmbG5YQklQNkxtRGZNbTNoVithY1VjYzJwTFFmODZlMzZuQXo5?=
 =?utf-8?B?NU51UmdPMFlaLy9ncDNzanVCNVZhSXN3WndkUEhjRFUrejI2dVBiejBIWFYz?=
 =?utf-8?B?czdRT0ZpME50aGFIVGkrQjNwWFB2SWlzK2x2M2FubzI3bDBXMjlLVFl3aTVE?=
 =?utf-8?B?TFMzOEJ6TDFaUndSY1ZuQmlwalpNekc4b2JzZ1FheS9IdkNDcUZWREJ0anNO?=
 =?utf-8?B?d0o2bjgxK0prQ3dhcy9yTzg1NkVSYWZsVm5NcTJLdHB0TmdCaFRZUWNoTi8x?=
 =?utf-8?B?RHFEOWk3N29MeGVQVUxvSEhQajNrbEl6Y3VVdlVHVVNHdFFHcGpIM1pwMGw4?=
 =?utf-8?B?S2F5ajZnQlN4UE9ZWTg1L0h6R01xb1ZLSlpJelVabFdHWHE2OFVDOHFmNFIv?=
 =?utf-8?B?Z0NmUVFsVkpvYldmbVp6N3dhaS9RNFhVc3VVbXoyd1c0alFaSXhiSEIxNm15?=
 =?utf-8?B?ZkpLaTh5Ri9BWXoyU09FWlkwVEs4V0FqSjEyWDdHZVNTRWRFTElWb2xaTXEz?=
 =?utf-8?B?OUhJS3EycDNBUHJJN3I4YkhENk9JS2xqV2RZUjlMamI0dHJnZUpoeXhBN2VT?=
 =?utf-8?B?N3Q2WU1hRXYrSHMxOWVUOVBqVzYzeThtU3VwSzNYY2IzWUFSUXUyL0JJYzVZ?=
 =?utf-8?B?SlpYOThUR1pEZWhlamIyZ2xFeUx1cUwxNktkZnMwejVra0dOTHNIWWNacVdD?=
 =?utf-8?B?ZDZ1ZTR2YzF1ZTMvT2wvTzM3a2h4RFIzZ3Fnc0RwZjdoaUlsdVFGRFVVc1cz?=
 =?utf-8?B?MXdvekRodTVFTnYzTGdrc05JbE5pYjA4K0FhQmpGeUtwa09qbm5UL0JaaHlv?=
 =?utf-8?B?anQ3b0RMbjVOWEp6Z0RJNmt6SFZEVlE1VXE5blhlQnVuQ1o3YnpxOUczdmh1?=
 =?utf-8?B?VzIvRXM0MTg0N1gySHRoaHRIekVqRXlpTU5kcE54a0VVYmpQRVV0NXIwamVi?=
 =?utf-8?B?VGc5cm1ocTFCQkNQQnZPRzdzQWJJQ3o1SHQ5WmJWU0IzZW5iaDlzZXpOMkJI?=
 =?utf-8?B?QjJ1VDJNMzh4QWhuVDd4VlI5YmtMY1RMa3hoRUoxV3R0VW1pek9UZW11L216?=
 =?utf-8?B?b0xRRW84U25SQmVsbEZZWEtZWmRBMnp3bmlsM0lRK1crYSsvVHc0SENIeG1R?=
 =?utf-8?B?S2d1bzZ0ek5jN3IyTWlvVktFY2NqQXFIUldYZyswcHV6ZEpvTUNYRndxeEov?=
 =?utf-8?B?WGdzMTZ4OWxrNUlGa0FITG1YV1BrSGVKZUJIVEt5NEpnaEMyNmRsZVM4WjFT?=
 =?utf-8?B?Z0psMld2Z1dkckJBRTNBR1R5bWZKQWdnbmpxemEvTXU0bUxTNEFKdE5JK21a?=
 =?utf-8?B?UDcyUkNpYk1LaWlYbFNZTEJxSEFDdXlMR0M2R2RBbHpadTFnZS9JMzFwNU01?=
 =?utf-8?B?YTU4dURINWpXQjVFZUZnZEdXZml1WHhvZkZDME1pdFdXV3hCbE41QkcrTGRr?=
 =?utf-8?B?UDJienBLaURuRGtXUlBWb3RUcVRsT0FCY3hJYjJYM1F1UDNjbGZmRHZjdSs0?=
 =?utf-8?B?amNRTnJBcUg1MWNOdmpHSDBNdlRiSDMxRTIwdVhPNmtPakE2cHhzYWo0ZFFi?=
 =?utf-8?B?T3hCTkJmOFVnNXBlNVNvNkQ5aXB3akoraVZmOWRNdkk1WVk5citwckt6Z2Y0?=
 =?utf-8?B?RmVVa3oxcVRzdFdnU3hZTmg4ZUZSS29MR2lJbG9IWHJxNFBueWI2ckk5akQ1?=
 =?utf-8?B?NzZlaFdHWGNqUGd4eU1GbTNETTFWYW5BY05HSWVwRm9CVFZjaHF0REg3ZjBB?=
 =?utf-8?B?RnI3Qm5NenA1dnIvUGZuZjNvN00vOEVmY1RLTTlZUXd5SjA1WjdxY0lZaUxZ?=
 =?utf-8?B?OHdQRWtrbWphRm90ZVc3OTJWNElOWEhKQndXclFyK0RCRndXeW16RXR3eU5o?=
 =?utf-8?B?TEJ0Z1cxZk56MktCMFZCWjk2S3FFeXZ4Zi82Y1gwdHB2ZFBpazRjbHdDei8z?=
 =?utf-8?B?VHMxWW5qM1cyb2ZFbkxpd3FseTgvS2NwSGpmSHEwUk9PZXJLajVTTUFLdEZl?=
 =?utf-8?B?elRzT0ZScmNGWWpIUUFxbUdYUkVYM0Vlc1d3K09NRmU5YTYzZ3p4U2ZnS2t2?=
 =?utf-8?B?aU9PU0ZENXJlcU9jeGtoNVRtaStlKzIyNlhSM05TTHluRUY0eExidk1hWmlX?=
 =?utf-8?B?M2pENE90M1M4R3pFekJhTUpaTEJVc0RINWszcXN5b2RzVUs3a3RRS1JxL0Vx?=
 =?utf-8?Q?eEmjRkbCJzIITJu19K?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: daf8ac23-46a8-4d13-b856-08deb0e67a7a
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 11:55:08.1133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lCbnzpenvg941jQ6zh7askGQYq9xoSE1SW+dVLtXuFIdsxUKtETFtHOrFqlLbUC9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5632
X-Stat-Signature: 36yiupe187454txsj4ngd6q1k8k1o1fr
X-Rspam-User: 
X-Rspamd-Queue-Id: A7ABE180008
X-Rspamd-Server: rspam07
X-HE-Tag: 1778673313-451369
X-HE-Meta: U2FsdGVkX19sEzOSeJr0omW7hFtsECRtIgatyksdY43Dq/gd97FpOK+mDRChVzCyU2YvEWkr63/H6Mcg8nl3TwN6ljc6VNic1Pg0iIJtAuAYoK8zToFR/NPHyH1IrXIkMv8Q3QnXOgJSzhYEBKcxC06RQQs6t4yXLIhwZhJz0a24WurDzxiogmu+p/LV2avh0QJbKZFpjJidvLpyz8CB4Az2uaiWoBdAlx5gMot9y09yjBTFIJdI0A7Th8ZB7XZ9zAJno6lE45tvOUd3jyWrlB14dy3zGACLiQdh3Y3yp7Cfxw5QneZ7fhgM+k7VmvhaLbXjgBvO/2K+mNKfqHjwCgN4XWbRpCAz4Ccr89tVKo8fntDSxxA2gotx/iC2DktcLLBXcfhJqHE8LlIX5bHM4IOU26gMgKEhjOOui5R4ZE12VZ2mhChLd7WSw/fdkqP5VV9m59T7qzLWBTQKS5sYuONd9JQBZgIi9FQfw6z838A4FE2aAzGMzqkpqgi6/tqtwIA3vEwYObvnL3lhfC7/l3kmWZx34fTUWKNkSwKpMuOyxT0FvxnVksnCkdUVjpvGTWbJQ+E3iC7gGRyRBA1X5ODKkR57HRUZLLRIj3RrPLqXm/MpinEfLZXTS9zWMZbgBRjL3DUCzqW9XpolvivhgY75ZummOx6BGWqTgjAnuJydMlJ5NYWJ+huu5H4ZwZsGZJDhUfkNroIPz8vmynd89J9cAJgaDNdS7XQB3RfCezIWsM4DLU1+BmeJOVAvukVCCYE5pwCPFjnJsPZys++0HKiJIqak7Mrnpf+ftb9nQluk3HvcgjQ9CYKPCIURnXS7moRD5CJc4+s9kovQpdOzgrfwTCkNIxsgeyDqMdP0nCjf+NtUxDP/M4WHt+ajtLlLMVyOk2Ub/a2S2gdUM7rtQrJmmhbzQM4+eKnub41ljjoBRGYGWFdqW62SmU4QyJj4/aimz3egc4//hudzgM+
 7wiv4dOy
 MaZ98h7cp/XFCICJJYjs02is0i1RnhJq0PeplrZgaBOOZtzYrulpt6f/jQ/yRzyU3nDO+FGzrk5M7oQz8EBbrMztzTXqiX045l0TAWz8MO9euxy+BPqGLYY5WIuLcE0I7gmsK0tgu/OeH2SwWbgSQd4T/8fCC+7XEIUcZLVykg4YkVS2GR8op0/kKRssf9KIzmQ9sm/eT9oIRRerLbi0k1beRJJrqRRbZ/QrfVmQ6cAlaobRiJvn1KW0+0wslfGLuc4Ct7kRd3YQCK6FaXJncVgg/wZ3uL5b2aFwgl7rvbj8i5Kt28aOnEz6mBwqxp2T0q0Csw98yORjn1WFQlYF37PzjfVMM73THPJmKgtwYuzxEt6KPpelMsRTOY82h2rkvgemQc3joR2/y4HFeBoEv0Df+/QG0bYK8/+UrWI+ZAMkHj8sShrykpzStOLspP+N0N5A711EWbwW+V+Pu1/nm7ZoYyXopbR7vD16vp0V16iKBwn330m2YVAlUNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/13/26 10:37, David Hildenbrand (Arm) wrote:
> On 5/13/26 09:47, Christian König wrote:
>> Hi David & Thomas,
>>
>> On 5/12/26 22:03, David Hildenbrand (Arm) wrote:
>>> On 5/12/26 13:31, Thomas Hellström wrote:
>> ...
>>>>
>>>> OK, can eliminate those. Is VM_WARN_ON_FOLIO() preferred,
>>>> or any other type of assert?
>>>
>>> VM_WARN_ON_FOLIO() is usually what you want, or VM_WARN_ON_ONCE().
>>>
>>>>
>>>>
>>>> OK, let me understand the concern. The pages are allocated as multi-
>>>> page folios using alloc_pages(gfp, order), but typically not promoted
>>>> to compound pages, until inserted here. Is it that promotion that is of
>>>> concern or inserting pages of unknown origin into shmem? Anything we
>>>> can do to alleviate that concern?
>>>
>>> It's all rather questionable.
>>>
>>> A couple of points:
>>>
>>> a) The pages are allocated to be unmovable, but adding them to shmem effectively
>>>    turns them movable. Now you interfere with the page allocator logic of
>>>    placing movable and unmovable pages a reasonable way into
>>>    pageblocks that group allocations of similar types.
>>>
>>> b) A driver is not supposed to decide which folio size will be allocated for
>>>    shmem.
>>
>> Exactly that is one of the major reasons why we aren't using a shmem as backing store for TTM buffers in the first place.
> 
> What was the problem with that the last time this was considered?
> 
> shmem nowadays supports THP (e.g., 2M) and even mTHP (e.g., 64K).
> 
> For internal mounts, it must be enabled accordingly
> (/sys/kernel/mm/transparent_hugepage/.../shmem_enabled).
> 
> Some distributions still default to "never". I guess if an admin enables it, you
> would just get THPs.

Yeah, exactly that is not acceptable. We have some customers who already use that approach through udmabuf, so we already have some experience with it.

And I can't count how often I had to explain that it's a configuration issue and that the admin has to enable THP to get decent performance.

> If "distro default" is the only problem, I guess we could think about how to
> improve that. For example, just let internal GPU DRM objects allocate any folio
> size available and supported etc.

Mhm, that sounds not so bad.

I think what drivers really need is that they can give the order to shmem_read_folio_gfp() and get a folio with that order or -ENOMEM as return.

In other words we need to enforce it and if the desired page size doesn't work we can then still decide if we want a fallback or not based on the use case the driver tries to implement.

> Would that make it possible to just use shmem natively? (e.g., how would this
> interact with shmem features like folio migration, would that be workable with
> DRM objects?).

Mostly, I mean there is still the use case for UC and USWC memory but at least for AMD GPUs that is mostly negligible (we need it for a handfull of workarounds for HW bugs etc...).

Thanks,
Christian.


