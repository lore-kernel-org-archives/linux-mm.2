Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB3CA606A325
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 14:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=V+YsIzdF
Received: by kanga.kvack.org (Postfix)
	id 21E5D6B0B72; Fri, 23 Oct 2026 10:11:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FCC76B0B74; Fri, 23 Oct 2026 10:11:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E4FE6B0B75; Fri, 23 Oct 2026 10:11:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DDF0A6B0B72
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 10:11:47 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5F97080260
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:11:47 +0000 (UTC)
X-FDA: 85354079454.13.242BF81
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010002.outbound.protection.outlook.com [52.101.85.2])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6B0F9140005
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:11:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=V+YsIzdF;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.2 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792764704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pAVypVJD19GfxJvtrpPmnKZf6BSh6ruLhL5zsFi89Es=;
	b=S2GqdTZXmjJVmGjd97Qrzr/BGVe9c22hMM0uFRxTLb14Hzvj912gksGviCMFXhUW43QIgO
	9P79Pcc/Ys4lj5BUwWY7TncBGLP9l2RaJHxlKIokCXeJfiavAT5Bz848jmxlkVXA51ulzF
	dH1KD/eARguwKRTGiIijcamk2EMH8oY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792764704;
	b=Y3HqB2lsRNvra588jgGva1ohV4aIHEsvOMjYQaKFGJwgGZqY60Ko0/ikzVj9TJSJHyzPVS
	7r8wnbwTpZnLhwosefBf76m84CGo2xq8Zb1WqE1awV5zSqt9tvtdZ8hhoZ4FfmKfhqKsMS
	hodgNgyNVJS4Ple8EpPbSIr/SlWxvbw=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=V+YsIzdF;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.2 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=omLbtH5x8vsaklSTDrnEPNMCgcxXGM0TeaEr4RHUH5Z9IwS6UdE7vi4nfs4FSTd8feO1Jyf8SlEssfjXD4O/ttzG1W/4UZmOaKSw1JcLREbac7EhfcRRo+9fb9GLntIIqn50lGmomV3I9C5CipMtnXWAaiovWTDWzsjMdnmuCZ3TP8shdrmpwW0voEa0W5pvAtt4s8jwXBKhAwWPsriVvfoq5WX623jHmA4VlnXt/9QnZZnnz5o0AVJaJ11bFPAMhSTSQpMm3UWZWXtW36pHKs5U+/afGXyiOK8NDyZrQlr3dxEIKPrts7GHxd+vxIq2CROXdthOntD6+wJMg5C2mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pAVypVJD19GfxJvtrpPmnKZf6BSh6ruLhL5zsFi89Es=;
 b=RTatXclsLP3QP3Hfn7Q1l5zTLY29GfS/OUfzcsjNJnkLOQuHd+uPJQBUDFQEotJf1+NQ7vvBE0Gvy/uyoRf2ixcnVKYNmcx6aq5pspPDK40X7BXludCRJhByjT8bVE7YbeBdooSNNOKc7PTcXxBzk7fM2ICwgZF1tZz/1/5FFpkV4v6x93e54chZSOzPUPDwQCbaFlP7Ei+rcqtYWqZHt/95yQafEfsGLG+4rhc1WL8Se3+v03LsixHZF54Pk2ktlqy+JGkO7Tuh6M3EyniMvLrQ4RY+f9o88d1QsKxTawsliVmeR73x5yIC//24rXuhyTXHui+y/Iefb0fQzMoeQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pAVypVJD19GfxJvtrpPmnKZf6BSh6ruLhL5zsFi89Es=;
 b=V+YsIzdF4a1RTBDzOHefSw0jqsC7vvdLVRN4ag8wis/MfDs0yWziN9flSq4+1665Am68D2HUj8doyGwDCj3xOcL3ng9e7iExLsPcStm7vHgf0erIik/7ceWB9SVZAIKEaB3H6cFVrdsB9MWMR98Dz86A0e5WUdLIagmp3bzHKQ8IQB6L8pGUD4jv93yTkthZ0pPDvGcWKPD94/7cU3WNzU4ejOO+bHnLF6HWumAVs6pJa+0/Jpe+q9jJSOrmAKO3FPUWHdij5tPQwR14KqCtECOUIFaSSOZo9uA1NpEbpfdbQILgriqdcA7OvtRG4nmEvMRn74u+wR9ZwAu/tDMoRg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH7PR12MB8427.namprd12.prod.outlook.com (2603:10b6:510:242::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.19; Fri, 23 Oct
 2026 14:11:36 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0522.017; Fri, 23 Oct 2026
 14:11:36 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 23 Oct 2026 10:11:34 -0400
Message-Id: <DMCA1N4UNM7G.3JBXJHJE6CQ7V@nvidia.com>
To: "Matthew Wilcox" <willy@infradead.org>, "Yafang Shao"
 <laoar.shao@gmail.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH] mm/migrate: snapshot the source nid before the
 misplaced migration
Cc: <akpm@linux-foundation.org>, <david@kernel.org>,
 <matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <byungchul@sk.com>,
 <gourry@gourry.net>, <ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
 <linux-mm@kvack.org>, "Huang, Ying" <ying.huang@intel.com>
X-Mailer: aerc 0.22.0
References: <20261023023226.29783-1-laoar.shao@gmail.com>
 <atrUeGPZgoSACpOR@casper.infradead.org>
In-Reply-To: <atrUeGPZgoSACpOR@casper.infradead.org>
X-ClientProxiedBy: YQZPR01CA0115.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:83::8) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH7PR12MB8427:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b8c91c5-e1a5-42f8-495c-08df310f8cad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|4143699003|56012099006|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ATADS5bkGqOFKP5e7DHDmfPJSxttrIR/yvhphIzyfpy3ogj9HABwIB2j5vbEelb4YB4hHtolzKsjhHtxqltB+8x8drfJ7V/DBMs8hC09/BwGihYP2lseUQVgoQAlmjXfHVIFirrF9fIgg9b8Me6Zur06SqK4i1JpR26oIhVL8OixTVE+9AI05HChUfM7RQlG4pABcPAhRufWYqpvXgQCdlw1Wp/VYw1vvlqtG2YpgCs95dWKX+EyxtQgX1jIux69Y39oc927Ab274pmb/wY0r79le/zvviRzv7V/Tv2wMsY2JRsq1ZSexdz24f00iiBSB//rprCvAtAuL4dzpsvIuaCriTAlk4sMQ22UP5zIA3+SpCE1Sf2X/uEpOgIWDPqA46JkExXCYJsHJmCsdX+OkmdaJdc2cJErT3OsZYJYS4wLKcMlYA8yvyd4A4gb93u/qdwJxw7M1vOJnB/9KKq/pB/X3wPwu2K2wlBx+v/rXoI7G1eaEcksUa1B8aIZg/rUce+dg99eMdzgxM+q0j6HE/4GEo3d3RqdunwPwCwj7DddpGerFF+WmyeNoGlrBJU9ZAlsIcLJNfOe2XuwfY4gurL7vhy3VBL0z9FdGPNdJB4MpOuDufym4IUOyn5fYgEqRFsh5gPkqMtW5ndJFrtHyhaay3r6VQNHEe2K+XIs+1k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(4143699003)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZTF0ZHVkdHdGREpweUNNd1ZrNU5Rbkp2T3JGNVQ2RDBiT3d0M2lZd0t5aHhu?=
 =?utf-8?B?RFpoem0rRzZHU2t4eHlWbU56ZjN2SVJqeEp0RTRCTitFUk5DOGtzb0w0bjd5?=
 =?utf-8?B?UTJLcFkzOGNidFZEUG1ldXRkd2hUSEdtcE1uU0dUYlo2cmtlbFdrem85am5L?=
 =?utf-8?B?Qyt5R012cVBoRHBYRnFHV1VoQ0l4anUxa0xHT3ZFckJYZW1SU3hwbithU2Vi?=
 =?utf-8?B?T2hEWW92VHJhMjhzbmdUdURNOFZDNDNXVlNVYVZzMDUzS3VwWlVqMm93Smc1?=
 =?utf-8?B?M2JRcTdXL2NzT2tKOTc2bkRaeDNzZ0NqRUJhL3QxanJpenQxMGgwY2prc3VS?=
 =?utf-8?B?QXNDZkVqOTlLd0s3SmNrNS9tT3NlSDZZOHI5Zm5vUjVkMzV6ZzBrNDd1bXYy?=
 =?utf-8?B?NjRCTlp0MVVMcHdDTXRmR21QRDQvRGpLNWJnbEkxOThEMnBsbGFqcGlHQUFL?=
 =?utf-8?B?MFA4bk9QcU5CVjQ1MUttQ1lCeVd5M0N3QWlROU5sVytKRFZ5TkNtQ0VkY1di?=
 =?utf-8?B?TzVVbkhwVGxDa25VUG4zVTdBU00wMUVwWEdKNHh6OUtEN3RueElGQUcyaWZR?=
 =?utf-8?B?QzJ5YU1WZGI3V0x2djNSQ0FMb2owQVpFM0o1bW9LNG9hZjZFSTBTa05VREZh?=
 =?utf-8?B?VUh6VFR0WUJmZEtBM3lidkV5SlBmSk9UWm14SEdOaEkxQXR1ZnB1YWM4eEpp?=
 =?utf-8?B?OGhvWWl4NTBBcmZwNnFmTFJheGRhY083QnVkdVlqb3Z5aXVBRWhlNlovV1ha?=
 =?utf-8?B?REh6c01wME5EUlJGMkxlbGpmZ0hKdTNLcDhLZERrQUs5QjZwY1JmRkwzS29R?=
 =?utf-8?B?czg3Nys5S3o3WkJERjhzc09iNEdWS3lDNVVUWi91b3JPcU9TdkRhRXZuV1Vm?=
 =?utf-8?B?WnhqWUVTN1ZvMDdHMUUyR2Y5N29qZlplMjh1a2pmYU53OS91UE9BVlBMRGF5?=
 =?utf-8?B?bFEyajlVTkhsSzRFRTdoWmhTRlZjZlNWbkg1OSs2VG50MmNqUnFuUGVYL0ZM?=
 =?utf-8?B?QTVJNTN6ekxnOG1Oa29rQldBT1B0cktxYUYrTDY4VGk5bEtVODVmOWl6Ym5N?=
 =?utf-8?B?VnFDRHZpWlNJQmg3alB6bFBsekErcGFOWHNGakVCMm4xZ0VFbWt1aDE1UEE4?=
 =?utf-8?B?TzRaZWxCcVpoTWsycVBvb2lNUGc5a3d1cnNyeno1YlBHeStySTN6OW5rN3Qv?=
 =?utf-8?B?bjFjaXVieFhBVmR1dUF2SEp6WUFKNEhVT3lqWUJmNFI3Vmx1R2lOZk1kblFY?=
 =?utf-8?B?eVZOajN2Z2tHMTArck0yOFpvR3JUMTRHTEpLcXNVZVhlYzlhT3lKMXBZWkEr?=
 =?utf-8?B?eDJodnA3OFFXNitWSVdnTGVmWVVkWVVZZUhRRENQRUxVTituSW95NWU4eXI3?=
 =?utf-8?B?ZUlqa2JtQWxjaEFSYk5WQXo3dzk3SWNNemRMU04xWlNrU0RURGRkeTNCWTBJ?=
 =?utf-8?B?VGlzVjNyYi9NWW9taEQ2eXJSbHozVjNWTWhXa3lwWEZPZVZhYW8yS2tJUGtt?=
 =?utf-8?B?WEoyK2hkcFB5OEluMkNHS05jZTRUalROSkIrNXltWGt5eE1sRThEbFBJTDM4?=
 =?utf-8?B?dUxTYm9xYXRWUk81bU9Wa25nbkVnUTNJQ0RiTFc5QWJWekJpMXI5c0kzSGw3?=
 =?utf-8?B?eTdPdmRBQTF6NjRzTDQ2QlhMVlVNS0hzVnhXaUVGaEJhVENQWHZCRndlYUw5?=
 =?utf-8?B?MDBJOGMwSHZrenozZEVVQzN2dnhSYnVOU2IxcDgrM1BJNmpybHczNU9QSnNI?=
 =?utf-8?B?ZG4xZmlEaW1VVG1uZDJyYnB2SW9KM2E2dFJqOVdoTzRJa24wd3lVK1g5ZDNV?=
 =?utf-8?B?NTQ3RlArbnZtcm51SXdoTjh4TkJvb2RwRkMxN2N1VEhJT0JUT1ZHbmFWQnZu?=
 =?utf-8?B?cHYwdHU0L0hyZWY0SnFiZmQ4bDlnbEtCdkU4aHFRTUwyNFA2VzJ3U25JOHl5?=
 =?utf-8?B?VFhqU3FPbTYvajJnQmNhNmFwTkRueWxyanJtVmVla1BPcGZSWmd2MHIrU0ZZ?=
 =?utf-8?B?K2o4THU1UFVaMXJ6eFdhUm1xdFpFWGVkbzJhT1JsSkhaVnpTT3JzeC85bUF4?=
 =?utf-8?B?UUZXV1ZWZXZHMll0aW81VFV2NHk2QnZoRjFVbkYzeWZpSnQvU1l5bjNidm9l?=
 =?utf-8?B?WjlvbzlEMVViT0pWa240aG9PRElMcDd1V0hHTDNBMjNNQjNhWGRjSEdYMEZi?=
 =?utf-8?B?QmZob3NaQnR4aU5XaDFpdklSM3NGcnRndlpDNGRvWXFwTnEyOTNQTjFUUmRp?=
 =?utf-8?B?ek1OWEl0OGk3bU1EWGx1bHNqRU5oWlRZS3NpdnM1WEVUT01IMDUxS3NPL2tn?=
 =?utf-8?Q?18nOuj7pSCrDOvgd9K?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b8c91c5-e1a5-42f8-495c-08df310f8cad
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2026 14:11:36.5523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UhjftQzhFqLPeacwp+FXivGGwaYUzCmx1bnxzBN8o2GwNoi9bxKsFPXjtUzXWkfV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8427
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6B0F9140005
X-Stat-Signature: ii7eykqprigyx8jeuxf6gg1mgrqaf9x3
X-Rspam-User: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792764704-42295
X-HE-Meta: U2FsdGVkX1/6StkMcQW8UqW8+Plk1l2mFrhwTO/3BzXQybblP6Kzct6oiriVrOKGhzxBCEI5QQEQ6/zWqBFgle/He+kWVPB4Dp6YIKKOKbFmC0JgLWXEmZcRdbkFPQvRbTyO6aZfx8vdpfs56rNS7uMH2DsYYdCLB9BFajRn6Ah2MbJdBf/lqmajX18c6dozIvztcXHPGVtj8PMh7dFh1fqUUPUl2PRbpgFtVDYWGWE0xa+U9JlVuOgJ2YAHUcogVk78pX4fOg8pCOP4MVccooLBmPrHyHVmS0i/CS8w+b+onN6M8Oyfjd/mpGd6uqa6w/uEbrfWvSiU2snJeB846Nyj/dR/7wH8rA0o6F0TXx6roGaUjWU+96hJqC4Tvn5T4C7YgUokF1LHIZ5FVS1vHmNzRkfoIHE26WVT9IYPF6n6lp2Xhght+gomhJMm/3yD86LbkFTKRzCau90HUsMX34+aIc8UbpPgyZ/pflKe4hFUjRZDD+erM2zPK5n5MNoiyp8nIBpaF7ov3maAiOoXFnv4DTK9q32mRbqaRDZQJMOa99AMCvzgXVa5mhDxB3K9sPwCB6CcC91D/FE/Otl+jDj33uPnWiwZj5tY5q862ceguosrHDpvTUgqFufJt15nY9lmoMkMx8nskEs9vRGTLePuY/auiyO92RS4Qkv/bItQM1YzCmn7Mc/ilKKDkOFFEYsjOIbHMU/BOdewUEb3IISIphJaUor1EBln56yJ3rEpy/ulfGJvVdO2F77tiYIGguSUHDomfy7oW+2Yyb+UG/+AtspdkH7JrtEEBYMwjbN4ySxz7y/Ut0jjah0H8pEqjzgkmEstwFeejBE9SNPothih/st4vuob+K7K37lk2WtxgDUvvHtFXLezHUBRFe+ce7cJTuG0AFMOoJ0Gml+5QkKsnEgTcVDKFsuhtdYtQgRJ9HjZLkdxysj7JjGOTzBCvKYR8PCHy/o/s+2Gzoj
 czg9Dwcs
 1aa2BTUMuk0pKHziMnxvdV1oj3m9Nc4fOk3TuSFESv3mGsdycJohodRquY9kHMrIwfgRqctByNFnCfMkO8pr9iB6mZ0VuoV+8MMLNnKEYp/3oDC0cNPQBy4DE7ufwH0pw0vVSpoNZ8WgUx9Wfv5r9kERNS3D5rRcmzYdGO+2OhAMgNp5tZXArn+zpEVGAyKk9dO8neHN1ZRuaT+UNHxtjAHZ8SalUnrz98JxurYXMNOarqIBx+mfw7lx0vAONvKga6bqlGe0sqoQEEl/c7ExyHlxUtmTZnKkjDfaHVC+QRsl/Q8wYPRDZ6qijMYpAwYnGnYmscYGyKM1yd6UPvCCpgBiBBvmkEGQQJJKRRVDxwPrA0kTKxNFhxASh32qC8psOc1M2ghp+RLtT45WvwC6zrk0KsLLYHsa8Sb5CrOkrWBzmn0tGrREKkmwyiMDgOR6yFoMT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu Oct 22, 2026 at 11:28 PM EDT, Matthew Wilcox wrote:
> On Fri, Oct 23, 2026 at 10:32:26AM +0800, Yafang Shao wrote:
>> A successful migration frees the source folio, so the folio_nid() read
>> in the promotion counter update can pick up a reallocated page's nid.
>> Snapshot the nid before the migration, next to the memcg snapshot the
>> function already takes.
>
> I don't understand how a node ID can change even after the folio has
> been freed.  I don't think this patch is wrong, but I don't think

I agree with you in the current code base.

> there's actually a bug here that's being fixed.

Strictly speaking, it can be seen as a benign UAF. It works, because

1. folio->flags happens to be the same as page->flags,
2. folio/page nid is stored in the ->flags and never changed.

In memdesc world, after a folio is freed, I assume folio->flags would be
zeroed since struct folio is freed and calling folio_nid() on a freed
folio would give a bogus result (yeah, it can be mitigated by not
zeroing node field and each node has its own struct folio pool, but that
makes folio_nid() implementation dependent).

IMHO, this patch is still worth getting in.

--=20
Best Regards,
Yan, Zi


