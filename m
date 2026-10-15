Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14536CC6B38
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 18:14:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 283366B009D; Thu, 15 Oct 2026 14:13:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BEF66B009E; Thu, 15 Oct 2026 14:13:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 011456B009F; Thu, 15 Oct 2026 14:13:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF6166B009D
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:13:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 30E1BA5C8B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:13:47 +0000 (UTC)
X-FDA: 85325658894.07.B228C03
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012036.outbound.protection.outlook.com [52.101.43.36])
	by imf28.hostedemail.com (Postfix) with ESMTP id BB97BC0006
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:13:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NkKxiZuX;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.36 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792088023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IEqsCkqaYkWu5OZuS9wQQNLA6Vv19xX/x+/7IITAQPk=;
	b=tKcjmjSYOMFzj6cQlJQGEOsl3hCXFnWrPfXfp5jxUgQjRYfkq4iUGxWmMPTYYBDhOdqOpa
	PFRfjTph36P7M6Uz7JPiZR2B3MkShm2WXsvVj5xe4jvSWbBGv0w6IQraQVk2ZPgkBDq2st
	FXbdNj4nQNoCqVbK+8d7W0h2L/+9yUc=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NkKxiZuX;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.36 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792088023;
	b=gCcEZkwFO3GyLBDvgbtwY3fwu9rjOc6otgWSeW74J7PuxISeSSk8c7nsbrGqsi+kXvCE/r
	SsR/shEGOIG/Hxn5kbnCQDZ8hsBYZv2eH87Fwu4obsUHbfUGc0rlkyRV96I6MgfwCu+Ka3
	+CMR6pu6onyZx4sBh8FXhlBJTCboj4E=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z0Ku00z3j1C2W5o74dW7UKyZNGsbooQw2p63HM35hLWQhzHIdPR29NUTQ8AcNXxAcspbK5g2fVOKkyduJgGTJ4zH7s1rGu8lYCEd3QRnjz45vLu+6LhE/0JbstaVPmJNgfSZFWsFipqtdOlBKlH0INFC7CdGEadpAKsQtFH36gQV4rQxSeXlPaphhltyvTASOnrxvJT6S7rhhP/AxWDagdvB0YLnFxgibQEDpykZFjA6xSmQ6JByZt5pscSAhgZLrCOLevoXjvua+I9rNIjJNOb0FSgcaLgZb1ouSL05ijnH7xIDW1VW2z5BpC2vkThNuS3sdzEYkG6WCr9CQaLZvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IEqsCkqaYkWu5OZuS9wQQNLA6Vv19xX/x+/7IITAQPk=;
 b=Auv2l6XUhAbejkks/u7Z4Vd5USVqhZ4tCWl+WjBCa/69Lg+iJPsSNE0AELEUEvJIB9piwEYqKdtchQLHhkmh3O0LTojs289NGxPqXG9MOi7rsv00zZkWYJK9V8RGm5k8QC3zeYS7c2IbU1TmIqlm7cBDJS0eF+OqiMMm4WR1hbzPEx9Hg6pAmQjpNYtD2UlhDL4mSar8CKpsgTNfOwKpchbQtFUI04FOnw3+cx3nSqmCjbplfSqNex1Hkzk1199ZCqwkWoNZx9n1v6Pqx9Z/sEv9S17XA231Tf/9QpelsUMn/Q3x6Ge8BLdsGYJG1x9smuyOlU9FGkOi1C9nPKHInA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IEqsCkqaYkWu5OZuS9wQQNLA6Vv19xX/x+/7IITAQPk=;
 b=NkKxiZuXAjfNGOS/tupvhltvFizyBgB6HDuA42mRN85ZjEJLulWMGbvGIfoRa9lFMLGPK/Ige3WvhrDWG8dxiwqRu76BPheHChpIDyudUfwjwLyMFmkSkC9THJZoCUHGClgh4zTdDw0zl0Zl8/8PZghFGzXE+iDwWJ6Y3SqUQdzlwyBhx+5ZlsjQccrAhGikOGe6JVrs0XJurOmvWdJlzfaiKWSPs1ZGZJ7T7DuMB8uRzF6pow3TkZW4nwYUxv1Zdo7KMq/ne/qjjxWlM/fM582vUf1/NLQ2MXUtb1d5rhz19LkdJnDDbnh18BcmGMJiPDTNUTT50+pwB6GmKYAf5w==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB9058.namprd12.prod.outlook.com (2603:10b6:8:c6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Thu, 15 Oct
 2026 18:13:23 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0472.016; Thu, 15 Oct 2026
 18:13:23 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Thu, 15 Oct 2026 14:13:07 -0400
Subject: [PATCH for 7.4-rc2+ 7/7] mm/rmap: re-enable discarding lazyfree
 THPs at PMD level
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-anon_vma_uaf_fix-v1-7-7b977303b42b@nvidia.com>
References: <20261015-anon_vma_uaf_fix-v1-0-7b977303b42b@nvidia.com>
In-Reply-To: <20261015-anon_vma_uaf_fix-v1-0-7b977303b42b@nvidia.com>
To: David Hildenbrand <david@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Jann Horn <jannh@google.com>, Kyle Zeng <kylebot@openai.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>
X-Mailer: b4 0.16.0
X-ClientProxiedBy: YQBPR0101CA0244.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:66::16) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB9058:EE_
X-MS-Office365-Filtering-Correlation-Id: e6512b67-dcdc-4f82-a816-08df2ae80042
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|921020|56012099006|11063799006|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	RJtm44WJdxe/1BraaYiooPrEjOMo/25ZNYPw3+/7bgDu6YiOe25xXWoOPi9KrtZ9PH1J0EZpVGHwHd2+qbJy4LOLXKICyxjBTS6Te6QhrW4zRzROr0SYhSWDWBKYOclEHbV8SaxKRWt1FVawJQez7XIM21AZOQ2Gh9eby6y5/FKYXHPdgrEQutFaNIPMprwJRioY98BwGN83jkH2GtFd06JTgmw0BSQwP2dQuHisgErNSBa9SDRVCLynkEz8Xp0RCXN2A1qdaQCtcHD00zZ8JXVlNVCas2SBjz284Em+TMojcI9LbcChpnJzVPWu1Nuo1Ura6mkIobQp18KZuwpLf9o6awm4ZhzXvE46Kt0e9l66mS6Y1zwxr3autxnRZpamOeCk4sPhp5/dVbMNA9n62tZIqZd6qFhvWaBQ1OeomJ2NXaQu5BnD9Nq23Fo+Sv8u/Vxrw45wToBowZOqYtXz7C/HUMvWm3789e1k/P5UwXryrqxiPPeZGpESgmZ2JPuUhCrv2xssi9gYBRiQOU08WNi/9L3rUEEHnSN+CLX/CmD96iBjDb1931m04pgGTbJqmHtaAKQodJQS/6+qophpuEYzyau75mk+zz4X1ytqSvyd0DYc38vcX/gx3xaSUAIno8p47Y3u4IEEzNCP4XWg024R0epSNipVuQH0scZJpR2qpgyoTLRu6E93feUPXmauMdGND8dwzh7B9zcyG6Qnfw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(921020)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?KzNTeEVYYUR6ODdlcmdVanErZnZHRG4wWFlLb1lUNkphMkRaZlFYemsyTkVZ?=
 =?utf-8?B?Z1NhNWlCdXJPM1ZzZ2t3RUlyd3BxQWQ5a0V0MzZrUjBPRWNsU0x6VDRJTzF3?=
 =?utf-8?B?QmxPK29MK0wzdUZOWDlaTFZlMFlrNDl4TXF3cXh1bU5TR3lwa3JlbFhVV0NE?=
 =?utf-8?B?WndrTTNWYVA4NURnbFNPUy9udVhTRkM2Y2VUWG5MaDlDdTFlWlI5SCtaRVNz?=
 =?utf-8?B?d0oyU2tjeE5pVUkrSWVkZGllS2FXTlJQVHMzanV3UEpJUUtkOFpWVmRTY05t?=
 =?utf-8?B?ZDdRODhjRVZpdm1vdm9Bd3IwaDVQbVI4MUtmSHBSUDFCZkNLZk5GeitnZlRw?=
 =?utf-8?B?Z0JOMW45SjUwZ0hJWEJHL0dnYjJrckdQajhVL0w0M09XSVRGdnlWSGlrd3gx?=
 =?utf-8?B?TEF2Z2srNWhaRDJTcnI1WmtqYmkyUHZjdzlBd0xTeWlLTGVMUWlEUWNjMXhW?=
 =?utf-8?B?aDduVzdleFBSVVF6cXFlQXFqemREaGM3WGRoek9iNTI4cXRDZGY0dXFLN3hz?=
 =?utf-8?B?TWt5WTJpQ3U5a2RLNDZFSjhUQlFLSWdQNHpkOUs4NGVwbjkzdi82aUVFMnRm?=
 =?utf-8?B?aldFZFZTT3R5VGRncWZTUFZjbXZhYUlubUN0L2oxdk5RdWtRV2Z2RGF3NlFJ?=
 =?utf-8?B?YUNZY2tUNUpEY2pNcTZYYXdkMVJJeFNiZWFsT1dNTjZCSjM3TmFDSW5UR3ll?=
 =?utf-8?B?RDBaV21PSHI4cFB0RUVNOGZZMHJKVzRpTXlKM0U2Y2tIWGZqd1pTWVgrZG95?=
 =?utf-8?B?akRMY1ppMnlyLzF5c0wxMVhkNXVINU9lWHlFZ2RXQ0FBWXZwMzZiRGl1UUVG?=
 =?utf-8?B?MEIrQVI4NzhMNUo5TkFCRTBDem1rOEJjR01wYnFFdlhBc2Z6VitxbjM1bXc1?=
 =?utf-8?B?a0dvamtheFU1Qmo1Vk9Cd2pXbjRlUnowQmJYSFQzUUI5UzRZeCs5eGpzS00w?=
 =?utf-8?B?U2NUMzZlajJEVEUrdGpIZTk3TDNnNTJBOXVlZkNxaHNEUE5Yd0dyY1RQKzdL?=
 =?utf-8?B?U0lpSGRUY0N3RVM2UmZpd0Z1YUJPSTlBZ2VYaXM5Zk1FVkxjelgxRmduem00?=
 =?utf-8?B?cUxQWWlDb2xtQlM5OVRwMjZFdGNMMXd0VEhBN3UzOEM1clRoeU16OVkvdWd4?=
 =?utf-8?B?dGNIMlJ3Q0Y1M2h3d3FsVjhZQ290YVo0T2RZQkdodG9uc0d6RmQydzRzbnR6?=
 =?utf-8?B?eUc3MlMvUXY3bG0rL2RBaFZyYjdjaFZiVDFRMS9FaExDek5CVzNCM3hOeERO?=
 =?utf-8?B?a2pRTkkxc3dxK2x3blV1ZmtqMDNWTS9mYkZLcTMrb1BBWDFqZjZ1b1N3Y0ND?=
 =?utf-8?B?bWJjc1BlK0J6Rncvdi9ibHZnSWE1Ky84d1ZpQXRrbFkvRHlSa2VjVXh3dDR1?=
 =?utf-8?B?TXFlNjNmL3M4ZjIxZldyYml0akFPRm00cldnQWJRWkVDMTJ1ODVZMFh5Y3lZ?=
 =?utf-8?B?eXpmZHh5b3FKeG0rZzEvVXhkZmxBSlR3QzlCeSszc015Zm1kcGRjSno3YjJP?=
 =?utf-8?B?VnJmVkMwT0pRSmhKVFhvaGJyZEpKOUlWcUVsU3JtQlNuR2J1cFEvMmtLVDdV?=
 =?utf-8?B?ZDh2VWNNM241dnFjU1lpTlkrYVprV3Z3Q1B3TFNrV2NoZmRJSFh6aFE3Vyta?=
 =?utf-8?B?TUdUcnFuMG96QnJtOXEvajUraFlsU2wydWtvRjdKbXF4WExlZmtOZlRIY1Fz?=
 =?utf-8?B?UmhDVFlFUkRtR3pHejJ2WlJHQVFmR2NxWUxRUitWQ2RrZnFDb2JQL09XbU5J?=
 =?utf-8?B?RUhKWHZMbFVta2g0bkgzemprc3prRWUraEFhZ1E4S1NsNTdTTU41c1lKOElv?=
 =?utf-8?B?cFJ3OXFnNU9PZXU4L25sdllueEE4dVBpRngxOUZ1bDF3bE9vUUk3bDlOTFp1?=
 =?utf-8?B?dFA3anEvM01oMXQxcXBOU3Vpck5xQjVVclR5Y203NFlPR3lGMk10TWZZYnFH?=
 =?utf-8?B?akxPRHB1MlMwOGxUaDh0NThKTE4zbmpFdVlad0dkSmFLekdaU2hsanNBYnE0?=
 =?utf-8?B?R21IaGpVb1FmczFPVlV4L2tBN3YyU3k4alJ1dWhZZDc3L0lUbXBMN3RWaFZM?=
 =?utf-8?B?T2Y0bThKYWgwc2pZcytYTitldFQ5U0tUMUc5UzNEYkxud3AyQ05VMU5HRE5j?=
 =?utf-8?B?Z05hK0dLejF6aWNhbkluem84d3V5cG0zbVRqNTB2UEJtak5NNHlONkJGTHFX?=
 =?utf-8?B?SENkV1NJUGtpMFh6K0JVSS9QZXgvRVBZZGppVHZGUnV0TElXTDNaY2t0UWZI?=
 =?utf-8?B?MWV1QytVQXY4SnVvdDcxRDBhZjNUQ0VWZ2ZrOTRTMjk0RDF4ZkdhOEJjTkpS?=
 =?utf-8?Q?mwF6vHv/d6KV61kqLa?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6512b67-dcdc-4f82-a816-08df2ae80042
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 18:13:23.5769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: USHBwXWftIUg4ADgyi1wV7ktmQza4PVGmp83ibFY2qJJ219mERAtil4XemalrZHU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9058
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BB97BC0006
X-Rspam-User: 
X-Stat-Signature: 96hatq4pgmorbuokc14grfx7w9bans5y
X-HE-Tag: 1792088023-36876
X-HE-Meta: U2FsdGVkX18whoTZeN4Zkh2Aa7oRaGhMoOOY9PSnRwQ4KBMCveOFQpRlH2qZxT+iJmJYczJDJOvhTQaJg6ra21hdCZfrPei8kCBlYAdfYPOvEAo2zvOWQMQjbTISLI8nttmQ2m0ZYd8t1MpGWDduwZXXFXcYVa7y8RHcFzSh2Z2/94hlQ0sDumvWYRr6fLK5RJDvUFTbxVyGlpzvB9gfPX38Hl4E3qUOmz+8vDKNF4RNuBSzoGkumQ8bLsAnkBaJmEk1DEp2lzSX5ayCziTfQ88D/gAH7QfcHUnBx+mrphteSZ3hv336uucy/5150cFXb+NzILMP+gPudvbs7ko82sT0mbXXaMFJ/+/UJibKOa8RYK26feQdx92qG8sf4B4CuLeLtQudKljZA4WJcZHLQTf/dfNY8ikj8Wf6DPY5V0yy9CU2YzOymJHZgkxs9Ju5tXHeRsXOeoMrOO6yoJ49wDHFlLzyD8wYAMbjJ5XiYvKDhFUW1UnFA36sV2Wz2NyQnWuGt7+m7X0c92OII1Yyxz0haH3KDw0ygJdPHix6NEPOLZEP4cPj6pZuLlja5t34dcL4IFwdPmc0pSFUbYi+oQq7dScVilcgPG6dDJUsogindP+FgHPBXw6df7I32RFXPzdXt8hVFysxm5r8Nk8a3eBxy8lFZ6vdrDWfO9Z1siH54tHpwv13Om61DpmpBgAzdfBuYPjxLi/PVp+KvqFnCrnuQQQHgygsxFDNa64gvPupj6zbOusnwyrfc9RT+/zN+ZqD4dGgGy8Tij4gLjIM3T6KOoXTB6mG0vI9Ms0GPXydtrjjPC2qZAK/coMtmgjZdCayBrkGsBOXxkA1M6BO6eK4EQOIL92AeCqgWP2bqEO3CwUfMg+xeRIa4pTync9/gwCYVZ9jIZZavDiMaI8ogmT0wc2NUJi136DCzUl3RLPR+yuE1w8Yudhj1+fm6a7LrgU2CPjEjgPYMWuAKy6
 MFSDe6z6
 ddrNwNTp5YP3xe5TeCn7aJPEuR8rEh+jk4NE9E9jPDre+gBKOyOARUOcv8oTQZ4I2EAg8V9BfqGFlKU3MUikFg1wC7Nu1llM07g2Us9KgKrCrTfJPxoByVOhfcuACrvIWwQmz21cx4Pz87ZM2QCVsCgY83qgdAKNEtAOdajKNrwlz1OfSAJRKKm1rPKJmFs/p2s1P+EuTlhWbuhLciTynAlne9ul15CORYTp3fbR8KcvN9Fyt2Smmbez7Vppej5Mdf4L4z+yl6KB5KB/8o7rfQEfYl6enA+9n9dE11zKuQM5ezxcW7d7k0d/5rcX76A2+KT4DcgOwinKotbmGiCRNwECdyGjGa314TaPAMsWpDqE1GjNfNAeJqf3kedm0NFeNu7jED79JGxxa8L2vSc0P7R35pDiSTCFpjrRAabGHlfm3fEBSfvDD17rtIACDmVwAqHEOplpMtQiT0BaSiApipaiU1E5DVGVr63SYZhh/aufzhMKBXCMmtxkSwrGwAK6GHe4P5cu4hTkGkkWzZyvwaVy/dziLq+sTONyzyscIE1zjI4Jvoi+R4ff4pF8MGfb6AdWLq1fSGeTze2IKM2Z1PZ59dYVf7mBSNFy6UAWHcJ3HhGveN9TMJb0jFfxGBidlP26bel5m1aXGDsjpxmbHmcb4lRUwc8UkbuQRcK+VYvlnxeijaNElb1vy4WKtBvG7wyZrh0NjY1cZbSU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The patch "mm/rmap: don't discard lazyfree THPs at PMD level" disabled
the PMD-level discard, because it cleared the PMD before checking whether
the folio could be discarded, and munmap() or mremap() could skip that
transiently none PMD.

__discard_anon_folio_pmd_locked() now keeps the PMD invalidated, not
cleared, until the discard is committed, GUP-fast no longer follows an
invalidated PMD on any architecture, powerpc page table check no longer
counts an invalidated PMD as mapped, and sparc64 keeps thp_pte_count
balanced when an invalidated PMD is set again or cleared. Discard lazyfree
THPs at PMD level again.

Assisted-by: LLM
Signed-off-by: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Kyle Zeng <kylebot@openai.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 mm/rmap.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/rmap.c b/mm/rmap.c
index 1131b76bbbc28..805db93fe0428 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2275,6 +2275,17 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		}
 
 		if (!pvmw.pte) {
+			if (folio_test_lazyfree(folio)) {
+				if (unmap_huge_pmd_locked(vma, pvmw.address, pvmw.pmd, folio))
+					goto walk_done;
+				/*
+				 * unmap_huge_pmd_locked has either already marked
+				 * the folio as swap-backed or decided to retain it
+				 * due to GUP or speculative references.
+				 */
+				goto walk_abort;
+			}
+
 			if (flags & TTU_SPLIT_HUGE_PMD) {
 				/*
 				 * We temporarily have to drop the PTL and

-- 
2.53.0


