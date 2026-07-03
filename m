Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE9B7C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 13:47:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3EE56B00C5; Fri,  3 Jul 2026 09:47:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B17356B00CB; Fri,  3 Jul 2026 09:47:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A05BF6B00DD; Fri,  3 Jul 2026 09:47:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6A17A6B00C5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:47:56 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E70BCA0162
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:47:55 +0000 (UTC)
X-FDA: 84947593710.22.F641A2C
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013043.outbound.protection.outlook.com [40.93.201.43])
	by imf05.hostedemail.com (Postfix) with ESMTP id ED60A10000F
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:47:52 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cmVAUhzW;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783086473;
	b=cDD07WbOFyeiMicuC4CNGU3+pwWzPUGkIJ8GfW5o4ycq6dRr43bG5fS4+1OWp1NoDKjEyA
	GascFetxtp8sXwvv8DrbpMu6KHbAWWBIG6FOkBaO3FyzLPxba7ZfPDurF2khZ3BY0z2eqd
	vOJwZcjrDUYTuzYvLJyTBpKY3voieAU=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783086473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8HGrC8PL622Eg0PiPKw5iXyTJHw7+ZMdkZc+yIecsa4=;
	b=4m4laUxSSzpXzq17bpiD8Foy7Og5xlmJmziWc5afdnU4jKNSW0noUzoqcKEich7xl1Fk3v
	1pjUfknXjVbwMJymY48QPk9PR9vAIMOnfT4ycJHymA0cdvkThSPXa1ICijfucgou9pUq8S
	HwP4wqIw5+X55aJQCv/KcpyH76gY4zY=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cmVAUhzW;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=udUoVCwCnWOjnwn5zUfzlcVQptO9iuYZ3FacpJaZ2zkox3eeNZlhYiJaeBUyfdZF63mSZTLFu1dt0RyWid6KE/xUXCo+p3xMFW5pzQ1F5zwwsTeHRakbIXjCyAXBcvFPNId1jt0L3bxrOS1r7xhxAmiIxLoDx1zuifVy+grVD9JeC61hFm/JvliEGP9LuFLnQmIxznGPRqIzZn8ZuD3LbxdzpX0S8sIdUD3V/gtarc+xSWB9D7ur44xDFT5n7V1L9r2ZKU7Is2wQ5eomeR5hWF1nlwQaSOFNk92j9Fe7M+EX0TlrYwsvDFM601DdbBAfRKEIwHOvCYLbEcsXoSQSbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8HGrC8PL622Eg0PiPKw5iXyTJHw7+ZMdkZc+yIecsa4=;
 b=L3vsUX3DbqO99estxZB5nb+jhauys4NeJW1lazkc2P/3p/8ePWMgiKkHdIUYWwMPqKwCH2MHSw7WJMHzMrorkD+4fIYULKB/SBy3pD8D49OvQaOsbkIhFn17zVBFz1cGKZRrUuAoP6HLWWbBcGzF9B7ulsw3ZFueGiNRN8On9vzt3tUB817roMJgxfJmuhEN0v+ysRUOIlOxpiCCgGY6WoCmupS0Y+xHBSPZujAQseHgnh3vhiPSVF9bcr4MpHH8372e8kNCKj+vR7ewUy4S/oeFBMGO/4wfx0D6WjRf4EzwOukylMFsKjsadS6GxfMbaj8BdOTEFqhFj/FyJjUrNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8HGrC8PL622Eg0PiPKw5iXyTJHw7+ZMdkZc+yIecsa4=;
 b=cmVAUhzWa4lk5/I3842PSomLF3JMQjm1ynhjDdR/wz+Y7POWpFkZorlovWbB3ToTPv3woHVcLplb1WtlMreTvgLdITZyUw/AFP+v84OwQnwVVCFiULZ7Ru4uK/FyXFOb6sWIbuWE7/QjxRay6jHoKklWU8qYhxbvaMZj/39J2fqHNtPYjGPh6iw4stwtMkczEYSvVcIXq7F+nDA6Y4LtVIELDO/PjM7CzpNxjAWk9lbS7tncCYUXvxCZn/iaTO7NIpNc2kNwsMub7H8Dlb+Y33nxfFF6zpsUFxt4jnx13IdpcLbBQPDMyPFc03GSoAm+nhFOc/jl42SNB6PorrC1bg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MN2PR12MB4111.namprd12.prod.outlook.com (2603:10b6:208:1de::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Fri, 3 Jul
 2026 13:47:47 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 13:47:47 +0000
From: Zi Yan <ziy@nvidia.com>
Subject: [PATCH v2 0/5] Keep tail page private zero at free and folio split
 time
Date: Fri, 03 Jul 2026 09:47:45 -0400
Message-Id: <20260703-keep-subpage-private-zero-at-free-v2-0-2970fe777dd6@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAIG9R2oC/42NTQrCMBBGryJZO5Kftqgr7yFdxGRiB7EJkxrU0
 rsbiwdw+b4P3ptFRibM4riZBWOhTHGsoLcb4QY7XhHIVxZa6k520sANMUF+XJKtX2IqdkJ4I0e
 wEwRGBKtQNaaVuvVOVE9iDPRcG+e+8kB5ivxak0V9159d7/+wFwUSQuPQHIz0SobTWMiT3bl4F
 /2yLB8dNwuO0wAAAA==
X-Change-ID: 20260603-keep-subpage-private-zero-at-free-a1e1435025dc
To: Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>
X-Mailer: b4 0.14.3
X-ClientProxiedBy: BL1P223CA0041.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:5b6::12) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MN2PR12MB4111:EE_
X-MS-Office365-Filtering-Correlation-Id: ab6a4fd2-7aa4-4819-d614-08ded909aaa1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|921020|18002099003|56012099006|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	HYRsEemxZCblM7+vy+2r0S6O/j4bxHPW5t59M6j1VaUAW2LhRQYRHH9i68A8/Gpaq5/SRM+cr5so7W1TWDOqU7yi8ISyK4RI+LgX3T5YpsZu7a2BNjtwyYt42yay7YLRXQ5MRt6hBDtHfCPmutEC5hdvr1Fth6NcX5/2fmjPoE344C4GREWUfpX6IB4kABkqeUsNTZvIsqL6T5Cf3pgrT3fShhstCkgkxsQ7L3psooA8s1prmxbq7kyMTFt7astynHd1Yej8QMAr3Q/fD/XIiWt171ylFU25lgCeZ7fKuBlJpcHYaVqB0TIao/bmE0L/G3lQO2hT/3i1an7cjfQYkQUiLkr5v3neqWgbE/cMXJhiD1eWUkSPe7h+8SKqrX4AR6DMMtsdj5QlK4OLH7l1i6QgQ5izniq4zBh2LzJTcu3sp7ClgtaFm8wMyoi0eFE4WHkrOkixAs+gX0GF12DJU9jrBANF6ZLYwSRc9AGEVchsUPhxhA8bmbHEZmGd0JkKfc/pSphACiSWsP2cIOehNsqU+8ltCfMyjrRCwe6XyU++14oTwJOJC8oD7Z81QhFjDcjR4z4rS4ck/dpFzWXrH6X7KEgy7S5m+GiwJTPFDPZDnNfYqUgwGeNG8C97+RcmTkXf6/PSyrVHm+T3G4+Pl7ZbXdyj3f/wCRNSD0iIXdUO0Smw9ugYc68wQn6iL3EQlRbxds9wpVnOh3g5jY2iUg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(921020)(18002099003)(56012099006)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ek1wNk1nSitaSkFUZUQvS2UzdGVWWVhSS3RXSDZkWVR6cHZGdmlaUWUvWjgv?=
 =?utf-8?B?NHJXaUhyZURkMStIVDJlZlJFY0RSRWVTeWxNRXFQbDV1Zm9SMkp4NzZyNVJn?=
 =?utf-8?B?c0ZxVFZYWUN4VFk2eWlCMHN6cUh3VVI2S1NHRTJEa0RWZitPanBEdG5Xa0Qz?=
 =?utf-8?B?OUNxWmtLc2JMMnRrYUF0cVFrNGl5UEo5NlVzajlCeHUyTzhTZjZMSGNFbHdk?=
 =?utf-8?B?OHRqa3ZTa0dRWDR2K1JwenZ0cGNyQmhtL2RpVWdhdm5leEhzTGlScVZYY1dl?=
 =?utf-8?B?c09FTFRJZE1kc2tKTXlCbk11bmthNjdiMm12VmRVbjMydWhIMWRRVnV1V3cz?=
 =?utf-8?B?R0ovTVRCYmtDdUtsM25makVaQU1kUVFjd1A1L08rNVdBend1RmhTazF2Vnl6?=
 =?utf-8?B?RzVqZE5pRXBjQ3pxcitIVDV6U25VRXo2elpQK0NvZXFlR1pTQkhNVnlwZ3VF?=
 =?utf-8?B?am9XWmlleHNwMDZ6Y1prV2FNdzJpbG5DY0x2TGQwWXoyZW1LR252NzZ0RlRu?=
 =?utf-8?B?M3Y5NFdnL1hML1VwQ1RmVC8ySUg3cERCMVg2a1lqcHBQQmNDN2ljckYwd25q?=
 =?utf-8?B?aG1XS3dkTWJja1JvYzNCOG9pQjluamJ3ZnRac2pIcnBZVkZ6MnljWS8xRkRo?=
 =?utf-8?B?YjVoNXVyaFo0eTBPRGtleXF4OXFnL3B0RmQ0d3V1WDc5NHg2YitLSWhHaHJD?=
 =?utf-8?B?UnlnckF2S3N6QVRNS3Q4aUxCRTZyNElFdGEvTjRmN2dncEFPeUxUcXdWeno3?=
 =?utf-8?B?djh4RzhEa2w1bURoL3U1TWtxcTlBQTRxMlBybnpKSThmWkh2djdrTEEvemZO?=
 =?utf-8?B?N0FHT2h6elMrOWZNQWNxaDRTNmtmVHg5Y2thRy91ZXdqVDJiUk8yS2RIMUp6?=
 =?utf-8?B?cWpBWitHcWxLSVpUemppb0tmbmFQL1Y3aVJOVHRYcXZjWTR2TkZMN1ZHMk10?=
 =?utf-8?B?WUVwNjdHbTA5QWgwdFFJOTZESkpFVFRvbFJVRjlmaXd6MVRLaEZnM1FJODlG?=
 =?utf-8?B?V1JXRmczaW1VZFh1cFBJS1dMem40K1grbGZzeEw5TUFOZllCUkNUcWxRejNM?=
 =?utf-8?B?V3BxV1dEdVU2KzRLWjN2bkpYRXIraXNLTDA4TnJqb3hIN3hhaXNPL0VXT2ox?=
 =?utf-8?B?alMzeVBrUkRsdUlPemsvQXNaV0ZoVTdzSXJCZTZweXh2c2taTnp2Vld5WkhG?=
 =?utf-8?B?dzBHTEszK0xQdnRJZjZjc0t2Z3JaMGFIVDFNYkU5Sm1oUnN1UzZtdkxtN0JC?=
 =?utf-8?B?K1R2YXM5RVY3ZkF5aEoyQkcxRmJNeUJIYmtRYVNqekE5NENjYWQvdDBBWitv?=
 =?utf-8?B?SEVjaGVZWVpyVWFlaENBbFhmc0IyeUN4NElvVHZVVVlzUWgvVktYYUpIMTJl?=
 =?utf-8?B?K2RRSlFOd3RjNDM3UkFVMmNER3JmalpOMTZkUWZrU2owVlNpaDBoMkFYbnNB?=
 =?utf-8?B?cGtURXhuZkFORFNXRXVGZ2dQU3ZYaGNOVk5EL0VtSGZWN3ZaTG0zRlVvQVdW?=
 =?utf-8?B?bjVocVFIYlNZNVc4V2pLWHV4a1UxOHJQUWNKdVB5TndIOEpsYTV0b1phMWhL?=
 =?utf-8?B?VnJBNFQ3aW1LRzdxWXJmaHNqVzFoZVgyN29jQXMyTGhTc3FpdDBaSWZLZWhs?=
 =?utf-8?B?MlNGdlZ0cUYxcEdTZndJbTM3UzJtYjdpaHRlSERlQVBHOW4wY1NrYTlvU2Mv?=
 =?utf-8?B?dWRQdmNLSktMeVhieTRaTTl5dGRScHY3MHpHcUNiem9KM1piYUs4ZE9JbHYx?=
 =?utf-8?B?cnFxSExUcmROdTNnRnpBdXlSVUpTQlJYU0lRNTJhM21sTHdaL1l0U21memZM?=
 =?utf-8?B?NWpIRGJNRXArdXFWcEl4YmZsUUczb3JBaVE4a0k2YnNHaE5rbll0TEd5blU1?=
 =?utf-8?B?d3AxQXVJZkE1VFJyblUrVGlSdm5UaWduTzhvWEE3cjRyOWkzcVpTL1R2R1hS?=
 =?utf-8?B?NHJuek9qV0prR09JclNONVZQTGo1eFkxVFF2aEkzYmNiUVR2aGVOVmM4M2hC?=
 =?utf-8?B?U3BYSzdIMy9vZkY2dXF4RDRYTmhreEVFZi9qYi9zUElvTXkvcElkVFcraXdX?=
 =?utf-8?B?cWxtT3NBV2RSdkJGUWM4dmVOeVpXcEx5U2RvdEVyemRaM2sxT21MQytPOEFN?=
 =?utf-8?B?OVFKaFBYazNGRTljL1h6bERoTStxdUkwR3FMUHFJT2lRSS8vTHIzQ1crMC90?=
 =?utf-8?B?ZFFxTnhLbUtsdm1iWjViV3RPWnptZ0RObi9GKzRydkpwTnhrMWdDT1QxTHBl?=
 =?utf-8?B?Vk9aRk9RR1pYeFlhblpVK2dpdjVoRjkvbXhiMjZndnEwcE9CSExUSzE3VFhs?=
 =?utf-8?Q?CThGB3Nz3yNLfBMX9c?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab6a4fd2-7aa4-4819-d614-08ded909aaa1
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 13:47:47.5111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1eGS4296d/1TRRZNtOha5i0OgtX+aWBqeprB0WKe9XzpayhCr1LdIU/zzfhX4/8B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4111
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: yp7pqjqg8jjb183cwrg7cxqf7s36oidd
X-Rspamd-Queue-Id: ED60A10000F
X-HE-Tag: 1783086472-233345
X-HE-Meta: U2FsdGVkX1/+NjfHnYJgCgXm+P05C6Cy7kVw+nhI6SfH0byxhae20D97XoHDPl6OStgG6vD3YJGD5AsCoIzh6pcmHBnmXW1THg/I+oMLNaYmtc0XY4bsE44I5X8oZA1ug9wjtsjlWTqNNPg+dk+R/Aa55BhycVQZuQ0PdJPoVlT3Lok7TRH8fAug2bhYz5iHr+vfrr9YOl7tKLiLt6OOSv8K32tz30enh1pbaQhlIyhp0PZE9Gm04Vw0pFVb78SJ7FedbQzthvFQfKe0e+YIvLSj8+ve0Z5rs7ZoYixyuO69MwA0sSLf9hNYrE3w4SW88NaTtlkiSF4EXTKIDpiwgKmPSuYk0x78VAoDz4AEQ/fzTVDK1KvtoeafFx8Q9Q6IAKffMe/KJ4HOPnCPquapBbgyXGh+vhIeEF2noXzfgOTjuz457vV0P45Nw+GLiLVFTnavZgxveFAfgkut6bagw3+mVIEsyZ2GttL23tSQ6lmpRHRVG+zAOm0ca86pARSOzAgie3oUkTxXPcEuAEyFhkGvAIXjTwEbZZHPCVVLxBaJoXe3IP9f4NLewwRs6FBnqA0hUinpr9M9jRf/pfmVdZ3hyXXfamOkKZ9oiyz8WzhWKU37J06INj+d/0ppJXUQ3/yAVxaoXgYIgX8boxDZp14drG4wc4J9tt0sfUztflXOm17fQdId89NXfJ0MGsgbswkmUKe7PGvYVRmu8zBqL9nJpOBt/MieI7RyJHtJO87X9ulw6HU469o0fCgZ1a+UQ36Ilm/IpAwKdgFbk4WGQXskj3M+PYwVXsf8+v0DDHdjX6IP0oSuQnF+tVm7UIVtPaipohaclAupW9lcAdvcBKkfLzIpwWwUpD9WyJ+71YZzH7LGkTIPxOiSZLthonbkh/nxoa6wBcsmz5lbK3rCiIQtHd707H+zHldVM019xuDxtn4LAuTu13Gh7A77xDAayQyBIT6/KYSpHEwOoGQ
 oZr9vD7K
 77hmpls6mr8kwpSMagYCRk2oDasrJKUe8w1qkCS/+1UeNo5Ullt6xkEfB6oCQdjIX5xi78v7dAeECe8jaWRWF7ANq/UvTO9q5rjr6zH9cx5aqlgNBE3FV4DHMvyBU5fq3tKD4oh7/KvtpJntHXiNWPrmgRtXdVV4C9eJvv+lh0Ki3a/1K+2I2sNwOkPYnjBzJmkCrGWpXjqbLYlrdH+erxBmWGAQO2xn2fyMvrOuaFVP1rjxB6/fKidXD6mSGVcBRc72qB81NbO0EUMQs6Nxty0Ee5pq/e63OsEbOI/2DgRRY2dv/LN0uy9+Lwi+g1Vh+Lw5q3g1gQRdufjiLdcx6Wg5ECfp/UKhWdKRm6wLxL4b6fKrq4PC9ORz8j0+asc1EMvDAyIi42id2BMRb+u4SgMJRdUlfOMADtEWfHDovNxdhBMcte5rIZRSUBxPkmnG8j2zo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This patchset makes sure tail_page->private is zero before compound or
high-order pages are returned to the allocator. It also checks tail pages
that become new folio heads during large folio split, before their private
fields are used by new folios.

It is based on mm-new.

Note on ZONE_DEVICE and DAX page/folio
===
ZONE_DEVICE and DAX use prep_compound_tail() to reinitialize folios, so
tail_page->private was reset before this patchset. There was a concern that
after this patchset stale ->private can appear after ZONE_DEVICE/DAX folio
initialization. My reasoning is that no code sets ZONE_DEVICE/DAX
page->private, so their page->private stays zero all the time.
ZONE_DEVICE_PRIVATE page migration only supports anonymous memory without
swapcache, so after the migration ->private remains zero.

But let me know if my reasoning is wrong. It can be fixed by adding
->private zeroing code in ZONE_DEVICE/DAX folio initialization code.

Motivation
===

page->private is zeroed at page free time since commit ac1ea219590c0
("mm/page_alloc: clear page->private in free_pages_prepare()"), since we
concluded that it might be too much to ask every page user to free a page
with ->private zeroed. The holder of the last page reference might not know
whether ->private needs to be cleared.

For compound and high-order pages, tail_page->private can also leak to
later users if it is left uncleared. The page allocation path does not zero
every tail_page->private field, so they can be seen by new users and cause
unexpected issues[1].

Check tail_page->private at page free time, and check tail pages that
become new folio heads during large folio split. With those checks in
place, prep_compound_tail() no longer needs to clear tail_page->private
when preparing compound page metadata.

Overview
===

1. Patch 1 clears all pages ->private before percpu-km frees them.
2. Patch 2 removes setting page->private in compaction code when a free
   page is taken out of the buddy allocator. cc->freepages is indexed by
   page order, so storing the free page order in page->private is
   redundant. In alloc_contig_frozen_range_noprof(),
   isolate_freepages_range() is used to grab free pages from buddy
   allocator and it leaves the aforementioned page->private set until
   either split_free_frozen_pages() or prep_new_page() is called. That
   stale value without resetting triggers the tail_page->private nonzero
   check once set_page_private(0) is removed from prep_compound_tail().

3. Patch 3 adds back the page->private check for tail pages promoted to new
   folio heads in __split_folio_to_order().
4. Patch 4 adds a tail_page->private check in the page free path.
5. Patch 5 removes tail_page->private zeroing from prep_compound_tail().

Link: https://lore.kernel.org/all/20260206174017.128673-1-mikhail.v.gavrilov@gmail.com/ [1]

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
Changes in v2:
1. added reset page->private when percpu-km frees pages
2. replaced subpage with tail page/tail_page in all patches
3. moved implementation details from cc->freepages patch message to cover
   letter, since it is too much for a patch description.
4. used VM_WARN_ON_ONCE_PAGE() in __split_folio_to_order() patch without
   fixup. The expectation is to catch any violation during development
   phase.
5. guarded tail_page->private check behind is_check_pages_enabled().
6. replaced tail_page->private reset code with VM_WARN_ON_ONCE() instead of
   deletion in prep_compound_tail
7. the pre-existing issue in alloc_contig_frozen_range_noprof() is under
   discussion and might not be worth fixing.
   - Link: https://lore.kernel.org/all/d44ae8a5-ec70-456b-92a0-ce7ccabf6917@kernel.org/
- Link to v1: https://lore.kernel.org/r/20260628-keep-subpage-private-zero-at-free-v1-0-f4ce3930d10f@nvidia.com

---
Zi Yan (5):
      mm/percpu-km: clear page->private before free them
      mm/compaction: stop recording free page order in page->private
      mm/huge_memory: add page->private check back in __split_folio_to_order()
      mm/page_alloc: make sure tail_page->private is zero at page free time
      mm/page_alloc: remove set_page_private() in prep_compound_tail()

 mm/compaction.c  |  3 ---
 mm/huge_memory.c |  7 +++++++
 mm/internal.h    |  2 +-
 mm/page_alloc.c  | 13 ++++++++++---
 mm/percpu-km.c   |  9 ++++++++-
 5 files changed, 26 insertions(+), 8 deletions(-)
---
base-commit: e031e55776cf9193b4720a253e92539ca536d224
change-id: 20260603-keep-subpage-private-zero-at-free-a1e1435025dc

Best regards,
-- 
Yan, Zi


