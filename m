Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A070606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 02:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=T1lHctiH
Received: by kanga.kvack.org (Postfix)
	id 26C9F6B05B6; Sun, 25 Oct 2026 22:06:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 216416B05B7; Sun, 25 Oct 2026 22:06:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DE136B05B8; Sun, 25 Oct 2026 22:06:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D42556B05B6
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 22:06:54 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 442051606A0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 02:06:54 +0000 (UTC)
X-FDA: 85363139148.27.E5A27AC
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010052.outbound.protection.outlook.com [52.101.46.52])
	by imf23.hostedemail.com (Postfix) with ESMTP id 43996140005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 02:06:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=T1lHctiH;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792980411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=tLYzlahOzn+ec1ptD/AtSDz2evCST8cIfBp4StwHE2k=;
	b=FSUA1uS2XjsXSzguSVElHPJEeOvW9s69yi/0X20vUeAdGwJar6jtCopD1cJKZjjVvXDJql
	18QPAwR78ZJK9CxSZaCy2JNRc4X/7qPsg9Day/xE4d+V5M4Zb7mhMnux86qa4NT8sz3JIy
	Ds1Ap/GUPBJggUjLwMgb4ApRC7kSZG8=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=T1lHctiH;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792980411;
	b=W9M6xP/iKgpYW4Y7WI7JZUDrEiVJ1ARQIV+1mWYyweMYx21J+BB2x7LZijH1PDX6vRFcjT
	KKa5wqP1yMRgv06HkEATJqhJxcpzVW/0eIqLtY4airXp2tl7tFh3h35vTC6R2ptrE9M7rd
	5I2WadKoctYnJKgCfrkOrq+6DsdVN7Q=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PDvCdcCV0nyGiRJK2ycvHisrQIr5G7u5Ib7WwJYSwk+d39uvdxfV3RQamgpLGZdqTtcWYM/JnUAcFK061WoANl3II39hfG28bhBAeDmm6+Pso18jMW1Bts/+4e9fqulEJJINWTehI6G0i/e3opQ7grNnPi5sll+XROeVFyAJObXwS/rbD7DKsardjcATwpVsRgKwrG5Cj1DfAevyqfBH/wSNiW3iImr6vuw/Xx91lrzG4vR36bPX9AueFjgdpVhHeUHnQtDMs67ozWF2PV0VRhqCki3ABDNhD4QdXdD0eijR1G3x5eUlk3CuydJkKFMh7kIfMl406iGXUOBsPO/Ycw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tLYzlahOzn+ec1ptD/AtSDz2evCST8cIfBp4StwHE2k=;
 b=f7gEECWnecy1MBxFqnnU10IO7f7iVH+khj1jNRXcoruubRhvv2+L809OuKNOT/x59sCziTS0PFgmRvN5EQq6cRUOi1H20yieeM9u4RtdEfCdAb4S+6qj4e7Ximwv5801jX4J0O8ouoSXerVCEEV+Kw/oebowc/RbUmriB7OLk8a3vmcQSnBJ4udn56n6N3OovCymHKtgL3KEjLqxMXpkbAC7St0d8xPtB0KeLbihjGf5vIQ0+6BkVgeDW74ryQUTplLc+DZ3erldPpWePIzSvWF4d6kAWdZ5tqn/+sfPnzoJ4pQnt9iaPQuuQpNuWCVm30wj76b11ZlR5SX5PZOEsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tLYzlahOzn+ec1ptD/AtSDz2evCST8cIfBp4StwHE2k=;
 b=T1lHctiHr0LwUlE+nWNqG77eX4eYibCHQp1295mcfa6JduFyqCkdvPz6sgJe6UB6WJKdNrM95RpABp3S+KsN83iSgR4IajNPWGIhNnme4cNWUirE6tW3vCpR7rFph/xdm7c3eOTUWNAFLN3byQexxiBn50pOj8NOLLDaTg0wLQZkGGz2BxpsZjuePX28n1P0gm4HtpTpmjM8wXypyr/QJHGm1W/q1bUW+Uc3iqErkPIwOX24vHIWTNPDPMLD4oYyiFZ0fM0G2TMSi7h6JQH8wuBa2EG7TW0ZTiEpfjxC5seNXhuUQWy5MJK7X//3P/BOB3GHW+C+nwnuDJuFYzG5ug==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB7560.namprd12.prod.outlook.com (2603:10b6:8:133::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 02:04:51 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 02:04:50 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Sun, 25 Oct 2026 22:04:42 -0400
Subject: [PATCH] RDMA/uverbs: Don't return the shared zero page from
 rdma_umap_fault()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261025-fix-rdma_umap_fault-zero-page-v1-1-186255624f1f@nvidia.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXM0QrCMAyF4VcZuTbQFazgq4iMtE014rbSrkMce
 3ejXv5wzrdB5SJc4dxtUHiVKvOk0R86CHeabowStcEa63pjDSZ5YYkjDW2kPCRqzwXfXGbMpGO
 X/ClG544+MKiRC+vh51+u/67NPzgsXxT2/QNszYabgQAAAA==
X-Change-ID: 20261020-fix-rdma_umap_fault-zero-page-6fb7dd665bce
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>
X-Mailer: b4 0.16.0
X-ClientProxiedBy: YQZPR01CA0184.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8b::18) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB7560:EE_
X-MS-Office365-Filtering-Correlation-Id: 8163f3a2-0fc6-4bea-d372-08df330584d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|261009223027099003|261022075727099003|261021121427099003|261021123027099003|261022105027099003|10067099003|56012099006|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	CKN2o9m15IR+KZbqjDLyEM4DlhWUH+5Ml2emggiLjEad3UTZ8CLiOjO0uM4jxWES715FHe/1dJczOfBukAluJJxg+oMmOLCGfjUlN4DzmzmdUHqjI7sjw61jAmfduKJODp/3TKJpvfkgrk0lce+TlnmQeYVHuJnAI3T1dFZcXShGXN0j24Yq0iNNxiv67g+cNqKx4f5umBmD3+tUUEZz53ONBMTOwJUQlDjbx9GTCzsKboVHhhWjzf0gNezywwiPPdw3XfLnNWSXjdQL5Q4TemX7CohbcYcplTQ7Lcp+zhqdcskKSv/i3FU2hGWkRYq3/99FDT9rTILylKN1MzeavCL31wEaDetdcmduOElLinPbda4cyf8WaPRTV0TZCJl2E2Y0r7uyfkhzVTvERRRFabN3I1XutfMtMz2W+2zB5CF+tQ0yQ+BgkrHZF51g05+d8dF8BQWR/OOsMeQKxUPOci7G6ijfYnINjsV7Hn6BwC6/+z29HjA5icdRI7FlOHkWC1onf2CViLEpgJpBOOKlWK6VdSb8/7O/kS22UIB6kG7Bzpim6CFvoNBG3FJ7ezzWM014Rryan9BlS+e8fP1hTiXYVUYSPCZnIzAaY/9qUOC2lNaVzJ2d8bkZhGTrFjG6YvfEgZ5uZINPVYa/9En6B0XOIRsdobgahM0umJ06BGI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(261009223027099003)(261022075727099003)(261021121427099003)(261021123027099003)(261022105027099003)(10067099003)(56012099006)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YXVxeHVuQ1FHQldXRXp0V25DOGwzYlp5T3VNYzNUOHRiZ0xRZGp6NFNmY0Jl?=
 =?utf-8?B?dktXVjYxVjdLaEsvTnMrMU9Cc3JlWkJtR2dUVFM5QXRNdnV2M2RVa2V1eHFD?=
 =?utf-8?B?TmJ4V2xRek45Y0tJWHk4REtDb1V0ZmVvQWJwaWMyRGd5ODJjZTVqVWxBbjBP?=
 =?utf-8?B?TVBZb21kSVpKVkJEOHlPbkV3K0JlbnA2c25NYTNMM0tqMjlucHZxSG92Nk5t?=
 =?utf-8?B?ZEpnVW9Wb3Jyc1E2ZHg5T3ZwOXEza1VES2Nvcm9XVnVYcDF3MVE5R0NnYU55?=
 =?utf-8?B?Z0V1MXlFZWJWaXYxYXNzTlBiWGFUaHZ4c1ZLTU1JRTVUK1NVUFB4eGlDTzBx?=
 =?utf-8?B?VlRrSFJ2akV4OWV3ZjQ4MWlaRnVIN1pLb1BQdzV1STN5cE04OEZYZkVKMXhm?=
 =?utf-8?B?eEVyMVRsb01SZ1dmeWN4RjlPem9GdzdlNXZFdk9la1dNRFFZZFVaSU1IN2Uw?=
 =?utf-8?B?bVBQd3BJdHFHTDJRR1k2azJVbmNwWDhLcFZMK3pQWkN4LzE2Q2xPWXNrNUkz?=
 =?utf-8?B?MHBSWCtHV2ozV2tNaGFZU1NjSGNCWGV0UUhVcTFmWWM2NEp0MDBBQ01IZUZo?=
 =?utf-8?B?UWxNbUpGSmJkWnFneTBoNHB1anZlelh0dlBGcVhRQUduLys5THlVV0xuTmIz?=
 =?utf-8?B?TDZWR3cyTThHTXR1eHNCNDRsdkQwZEUyelowUm55U2wyMUNsYWN5RWRPdDFl?=
 =?utf-8?B?S1VXdkdKZ1p3a2liWHVPZ3BYTVkvaksrUzFrNEFKVUxiK2pWSUxQT0syM1pn?=
 =?utf-8?B?bThrc01JbXFXYjhSV2w4ZnpnYjRsQ1NFb1daSGE4dzl5T2hHYmNUL1htdllL?=
 =?utf-8?B?T00xUDBiL2gwdHJEY3VFSU1kakcwYzROazI4K3FZV0dKS3dxVVFucS9sWUtQ?=
 =?utf-8?B?YXppYUhQN0RYZzlPRW9MMkRhRzAwY0xGaW9rS1FQVUpPRmo2V0xJWDBBbHFW?=
 =?utf-8?B?VUtrS2toRllPeDJmRUpNeFkxSTdZc09FZTJJYmlvd3RqT1pLMjk0czhYcjdD?=
 =?utf-8?B?RGlxb3l2NGptZzM5YndzSFdBWXhFeGdUbGtoR1JRTGxrZEdNS0R1RmVqcVdD?=
 =?utf-8?B?VWUySjZ0YUpFYURPNVR5YTRpUGJvQmU3Wm1RdG1ZdE1DUjA1L1FudHp4VTd6?=
 =?utf-8?B?dGFRd05UNlBBZU5nVkFGSHZxb0I4Q0RYVTNWcjhyMDZyREdWUUVrUnMxRFNB?=
 =?utf-8?B?ellJNy9iNmM3VzZDUXpFTmFzS3RLTkxySzFQZkdVZWFtMHkvVVd4TVA5QzZT?=
 =?utf-8?B?dFpBRDJQZVdzZktkVDBCVHk1Z0VGVHN3bXY2U1FvK1hVdkFoU3R6cVdCbmEz?=
 =?utf-8?B?ZTQ1NGpHcENjTnplSUdMczB2eHJRNlFqUDhvdUMwcHE2K2ZiZURYV29wNXUz?=
 =?utf-8?B?alY0aTR0OFFLbG44TTBFN2JWaDFaeHpJazYvZm9oeGRoRnloL0l3bjhHV2xI?=
 =?utf-8?B?c2NKTnVnN2N1L09nRllxK3dYeFl0N2RNZktUeVhpWDJUUnJybmVndGZrUlQz?=
 =?utf-8?B?L2huV2c2bWkwNEZLUGZPcVpmVFFZNnVpc3FKUE9MTDJiQTAvamIzak9RbWRv?=
 =?utf-8?B?WTFtRkUzUTdOaHJtTEY1TDdSekN1ZzJFUzNnSEpCdCtGVDkzRFZNcnVlQVRM?=
 =?utf-8?B?b0FadmVSelU3Z1h5bWVzeDlVR05KRmt4SnFxM3hLdHJCWjFZa0dwYWxjd0tV?=
 =?utf-8?B?R1BYQzJmbFNYMGdOMHFmQWFZL2o1OVRhbFZQL0tnWDNjRjM1SlRDN2RnbWdE?=
 =?utf-8?B?VHd6eDhaUnNOZTQxQ3NvNlVCQjJUY2Y1NmllZUk3Wm9YTS8xL1VvYlRRTnV2?=
 =?utf-8?B?VnFqcHBiMTR1blpWY2V4OVVSaFk3TTBXa3NaK0xISlBTRkhhMlBJLzJXZk5V?=
 =?utf-8?B?S0xVaER0N3hiN1FGUXpGWndPTHQwK0xEWURNdnUvYkhva0hLaDFjZGxvbHVu?=
 =?utf-8?B?cENEdkdOR3lWclBSU05oclEyR28yblllNUNGb2toeFNXZnpkTWdsZDBQT2t3?=
 =?utf-8?B?SzRVd2dyQzc1UUNudVFheCtMbUJyZFVSV01nZm1KT1BpTzhhTnVhUHZCbUFa?=
 =?utf-8?B?YWQzSHJ4bWlIL0RqYklBMnZxTlZmeEVyQlloSDRDTFIyQStJcjdCcTlORVM0?=
 =?utf-8?B?Q2g0MHhXME9XbHV1ckpIUGxIU1BmUUJXRlZnVWJtMkd0cHgxU3I4MHpzY3cz?=
 =?utf-8?B?YWVjRXlNL2krZWlZMlZWc3dtSGZSSzhzZkZSS0lvZ2JTYzViUnI1ZjJiMi83?=
 =?utf-8?B?M2ZWdzRqQVVHcndWSk9KRE1OcG0zMThvNElxMnhneGNmYTBhUUdqZGQxUU9M?=
 =?utf-8?Q?hy2GoXPB/oH5OkQqdx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8163f3a2-0fc6-4bea-d372-08df330584d5
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 02:04:50.7427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EyBAInxq1TLAqTXwWV3jPevnPRzj/I7PM12BH9Sf85IXo08q0w4sgchKnrQlVrko
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7560
X-Rspamd-Queue-Id: 43996140005
X-Rspam-User: 
X-Stat-Signature: u6hbm95happcim633fo37mdjdg39d4yd
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792980411-496125
X-HE-Meta: U2FsdGVkX18+2Hj3LvTkUo8LVCXJKvNqfMuxB23REeKGsnD9svW3r9LpOJWWAKvcr2eE77jheaC4xNU8LEBNI1YdcGnjfeiyREwbIbq+h/R38hdV1ZH5lluLvBZBgW+4p0+lkjpe391ycTiAKjMIJj9TXQaM61TQlU1/1F+GaUhFv4fzM6kH6SruXQnENByODp/j4uQbnEFL1olbaXq5mOprDdH+9HAULza7cXG5WihkuuOhuPZNf4DcrUBjfJZkasSSw0ID4SSJQFro+aKnVHEnOl4ah0vQlJxAvQIOggXuev2iBDJecC4pGHfPidJvk/7azsmAtIsblI8a9mHxvmO3ECaqQYv/gpYw/Td9IQu/Cw4MCz4qE9eVJqiWGWVhK1ojR2X7EpXV1fi57DiyIjtTMLlt+uB/l4t7SemLLnHGeHQ/x9hwXyNec8s7STfkJLpXtToDK1IkEGbwfPItlCekwkFkGsoUJ3LGUpMGZA1szNfY4nm9O8yU5baM8b47RbVd1EWRqmYLQY4edUnXqXmqP23NOfmrIFS4WhrWeCJx7STef1k/1oMDFiFb5MJp2fpdn5yzkZyB2mdmjd/cQkIpji8cSeRyvj3mR+8deyk+RxYRdurFm7y6WGYHgJ6T0TOWfzh7Ru7MwmU1c/zi9JsKiyCFzHinuZ/1QXdy8w0Y8P9Xy5+qIsSKoM2q+iE7ne/SPEvEvkrIgiCOYLyep6bh47fG30ua5Hc1Bg7LE4nre1R9Z03fICI631kYQTSeidMavh3xVgK41b7fvV5hFBIPlcT4e6dRkgU0Vu35oJHEZQIWQDf5KDhygQ2xk4V81OUrh5lmgyw8jgSHnGCLA01QiDtEDrDBhcZy/WyvMPQ0w3ZM8DPiGHKDplcmvcJjbGy3HHPpGxRdDkq5I7XwevRWynYiPMvKHJe8NOXJCfoGA88jOnrV6j4C5H2g9DvmZwFNBTNo0Ye/OcY+jL1
 PATR5sw/
 adV6Mr0uT/MYWAXY1HPF/YGcr7TRTaXdVZKBRM3DFTzN9Ji8pmH2S5AKAZAOXdrWdam6flNKSJzV5mJp8HQhvBROUFurYFbf6V6AAYCN8Q9agegcwOuBTcFIkHWW2dnqkqWE2eslugdPohf72tj8tNp7Mp9qVVQWgFTRfAqusgIB2obo38P4ZXwGk2xtu8zg0V3y/rRhPTyjSOg4y42xBeFkKvpe+TkH3K4TuSC2EbKCq0Gx7I6HBn62mIhsbu6fbgH8pLFiH0zUfJK+RmQCErAOhZ6OxP4g7s5bLQeLiGdDoSNnIR3/U+NqFYEhTrw0A3Nz7MvLepAjsiNvZ79FLNDMzHfHP0Y+kTeSHap5NGVviTpU4hQ1Ng8oYH/jS5hSX/MkGbdHTKXBE/2aO7z4glYLx7cSOsGv4AskR3y3KB23/rSIMQ1x/V9cjbrhHVL/tAjW0nS4aAD5RvOTiM6Sw6fuC3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

After disassociation, rdma_umap_fault() returns the shared zero page from
->fault for VMAs without VM_WRITE and VM_MAYWRITE. Such VMAs come from
rdma_user_mmap_io() in drivers that clear VM_MAYWRITE and they are shared
VM_PFNMAP. A page returned from ->fault is mapped as a normal page and goes
through rmap code. Two issues:

1. shared zero page causes VM_WARN_ONs in rmap code,

2. normal pages in shared VM_PFNMAP VMAs cause accounting leak on arch
   without pte_special(), namely the page refcount, mapcount, and vm stats
   are never dropped.

Map ufile->disassociate_page for VMAs without VM_WRITE and VM_MAYWRITE,
with vmf_insert_pfn(). The page lives until ib_uverbs_release_file(), which
cannot run while a VMA holds a reference to the file.

Writable VMAs keep returning disassociate_page in vmf->page, thus its
accounting leak on arch without pte_special() needs a separate fix.

Userspace can see two differences after the patch. A mapping without
VM_WRITE and VM_MAYWRITE now reads what was written through writable
mappings of the same uverbs file instead of zeroes; after disassociation
both are dummy data. The first fault now allocates the page and fails with
VM_FAULT_SIGBUS if the allocation fails, as a write fault already does.

Fixes: 67f269b37f9b ("RDMA/ucontext: Fix regression with disassociate")
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
The issue was discovered during PG_folio development when making sure only
rmappable folios can enter rmap code path.

Alternative: map the zero page with vmf_insert_pfn_prot()
===

Read-only mappings could keep reading zeroes if rdma_umap_fault()
installed the zero page itself as a special PTE:

return vmf_insert_pfn_prot(vmf->vma, vmf->address, zero_pfn(vmf->address));

It does not work today. Commit 7b466529307be ("mm: disallow raw PFN
mappings of huge/shared zeropage") makes vmf_insert_pfn_prot() return
VM_FAULT_SIGBUS for the zero pfn. vmf_insert_mixed() does not support
VM_PFNMAP, since vm_mixed_zeropage_allowed() warns on VM_PFNMAP.

The first version of that patch [1] did not change vmf_insert_pfn_prot().
Due to no in-kernel user at that time and complication it can cause,
vmf_insert_pfn_prot() rejects zero pages now.

Fix to writable VMA path
===
A new vmf_insert_pfn_mkwrite() is needed, since vmf_insert_pfn() has a
narrow failing scenario. When a process mapping the disassociated page has
soft-dirty tracking enabled, vm_page_prot becomes read-only;
vmf_insert_pfn() then uses a read-only PTE instead of a writable one;
fixup_user_fault() is used to write to the page (e.g., KVM with the uverbs
mapping as guest memory) and fails, because it does not take the second
fault to upgrade the read-only PTE to a writable one.

LLM was used for investigation and code development.

[1] https://lore.kernel.org/all/20260917121010.60966-1-lance.yang@linux.dev/
---
 drivers/infiniband/core/uverbs_main.c | 44 ++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 2a046c888dfab..c3638bf031b15 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -725,39 +725,51 @@ static void rdma_umap_close(struct vm_area_struct *vma)
 
 /*
  * Once the zap_special_vma_range has been called touches to the VMA will come here and
- * we return a dummy writable zero page for all the pfns.
+ * we map a dummy page for all the pfns.
  */
 static vm_fault_t rdma_umap_fault(struct vm_fault *vmf)
 {
 	struct ib_uverbs_file *ufile = vmf->vma->vm_file->private_data;
 	struct rdma_umap_priv *priv = vmf->vma->vm_private_data;
 	vm_fault_t ret = 0;
+	struct page *page;
 
 	if (!priv)
 		return VM_FAULT_SIGBUS;
 
-	/* Read only pages can just use the system zero page. */
-	if (!(vmf->vma->vm_flags & (VM_WRITE | VM_MAYWRITE))) {
-		vmf->page = ZERO_PAGE(vmf->address);
-		get_page(vmf->page);
-		return 0;
-	}
-
 	mutex_lock(&ufile->umap_lock);
 	if (!ufile->disassociate_page)
 		ufile->disassociate_page =
 			alloc_pages(vmf->gfp_mask | __GFP_ZERO, 0);
 
-	if (ufile->disassociate_page) {
-		/*
-		 * This VMA is forced to always be shared so this doesn't have
-		 * to worry about COW.
-		 */
-		vmf->page = ufile->disassociate_page;
-		get_page(vmf->page);
-	} else {
+	page = ufile->disassociate_page;
+	if (!page) {
 		ret = VM_FAULT_SIGBUS;
+		goto out;
+	}
+
+	/* Make sure the page is usable, like what __do_fault() does */
+	if (PageHWPoison(page)) {
+		ret = VM_FAULT_HWPOISON;
+		goto out;
 	}
+
+	/*
+	 * VMAs that cannot become writable map the page as a raw pfn, like
+	 * the device memory it replaces. The page lives as long as the file.
+	 */
+	if (!(vmf->vma->vm_flags & (VM_WRITE | VM_MAYWRITE))) {
+		ret = vmf_insert_pfn(vmf->vma, vmf->address, page_to_pfn(page));
+		goto out;
+	}
+
+	/*
+	 * This VMA is forced to always be shared so this doesn't have
+	 * to worry about COW.
+	 */
+	vmf->page = page;
+	get_page(page);
+out:
 	mutex_unlock(&ufile->umap_lock);
 
 	return ret;

---
base-commit: 21a7f44fd0765fcc5194130b28767786eba1d1e7
change-id: 20261020-fix-rdma_umap_fault-zero-page-6fb7dd665bce

Best regards,
--  
Yan, Zi


