Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37953C982EA
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 02:29:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB0E26B00EA; Sun, 20 Sep 2026 22:28:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B38206B00ED; Sun, 20 Sep 2026 22:28:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C6E36B00EB; Sun, 20 Sep 2026 22:28:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5B5976B00EA
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 22:28:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DA58F120562
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:28:53 +0000 (UTC)
X-FDA: 85236186546.10.3575C6A
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012045.outbound.protection.outlook.com [40.107.209.45])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1ADA840004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:28:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Jfdyn+lS;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789957731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/eTALpAQfzanx0Wt/brzqMsVsOXGlL8Z/l1Df3SIQbQ=;
	b=PpTAlerOP9e6oWyLfRZixe4YSt6ViZuOALFN0rhc6e26EhmhKyaeLdAZu8MIpqcvJUGbnF
	AgpKmGRhER/Esls7BR0vx5+IGsIimNGAN415vifnQc0UvPXp87V5ALKnuKaxQRI817OzKu
	J5x5133yrOGZPVVDq3PDPpNT7rDgR/4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789957731;
	b=XLmek7hi7r+jDZRRCPg1LSrPknYBdsDZrD3Pilh342pMBE06Vv5Vi0V1Mmakd3qX+5RKXs
	kDM2iO68WzA/QCEnWdWGunLNZTIeOILbbidinEmZrz974JEWkGAz9zvwL0LpCfvdR3NfPN
	k8hUDUvEFCSRVjVZcpwCEvqdYqQfqF4=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Jfdyn+lS;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QprOmjD6+8FZ5Kelci6St8kk0l4lqPvrv74lEMANtVg8F03bUaksvCUAfu4H8AHQGiv3q13CyzcK4sR4UMjEBVQaY4+QI1uTjHoTez9eXoJnzvFVsNy09sdFL+/P42XrfqmFqXvLExQJNsnpGz1Zg/c7wVZVVI4978HIOngQSm20BTSxJB6TsxQ5la/LYLkCgspVU27zkG54/bHUAG/dieifHkV4gKfkmuHRNks+rtDxqeVC4FEy6FAsh0fmO/weuCJsVg8xXi6KVXaCOwW+Fj3/8Eu4JcCDDkK1WsQ8B7U+fhFJ1xGG8b9OHkdWmNsuj+1TcG2kRPqNbDY6Jrhmyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/eTALpAQfzanx0Wt/brzqMsVsOXGlL8Z/l1Df3SIQbQ=;
 b=GUcb7xSu+xBRYJEOzDTzscPEGtekuJD+go924ybs5GAhYL1xNMEsJLugpLHz2ozW8f7g3QWrlRRc3/2+7m5yxp6H7lJcASIotrcz/y1LpJaJcdQ7kUUHPNX77qPTsAqMIBFjHAIyVJvq9d0RZDhl1mmoXl0t/Vl37NVX2HsN4Ij9xZ/cehbHH7lwE45+IVnpyjNGFk5OmvOs7BVWnQFZAIKzKAW/uLoOk6JNBrt/QA5Ku1uA266qIHbAZ1vJTOFNaEg5VDaQJ2Q5HFn62FyzKPLeP7WIN6E3Ywo3ISFcQq14USE1sm4MWbI1LZEfL12cxTFL6Ou1BFzTJRHFC0MtXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/eTALpAQfzanx0Wt/brzqMsVsOXGlL8Z/l1Df3SIQbQ=;
 b=Jfdyn+lSZfdVz/dlqJi+CdesaoENFoft5bQVYS5FJ0yOSPgvbGP+IWVfz6RwnxTUQFE1imrAd8d6KPT/Dd6fnpKWSzNsQOLFpQrNay+MOb65oTjRrZFnvlFCi9p0XGLua7t587wu5p9So8o4hPqjbL6XUduRznTB99elQ+aEF7gFRyIZ5prtODNzvOvGCilIc0+jc7fN9EhhNrWOAHXpS35P9XlN11mYsTsE3NrjySyWy1CLXXeVAvuUId1+xMf7wjPrlNUpvy5aic9hKbgcUB+/35yS0YK+/VjKMRNfFSPG/TN5TUCpX1UsbnOzTt0+SOVrkAyY4lyNN3h+WIKUDA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB7719.namprd12.prod.outlook.com (2603:10b6:8:101::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 02:28:37 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0428.014; Mon, 21 Sep 2026
 02:28:37 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Sun, 20 Sep 2026 22:28:08 -0400
Subject: [PATCH v5 12/17] ceph: replace PagePrivate() with page_private()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260920-remove-pg_private-v5-12-bb68b6a21869@nvidia.com>
References: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
In-Reply-To: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
To: David Hildenbrand <david@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>, Ilya Dryomov <idryomov@gmail.com>, 
 Alex Markuze <amarkuze@redhat.com>, Viacheslav Dubeyko <slava@dubeyko.com>, 
 ceph-devel@vger.kernel.org
X-Mailer: b4 0.16.0
X-ClientProxiedBy: YQ1P288CA0001.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9e::8) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB7719:EE_
X-MS-Office365-Filtering-Correlation-Id: 53474ef2-bc39-4ca9-9bf9-08df17880aab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|921020|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	wET2D4KG6ONFhTf6tltir08ZtCTK+/xyXN9U8vx/bOtIy+eMfuUFifIUwk/Qwy8vPFi0glewsxc/XQSlqa7EXwecWcnr26bRFDKmnA7eBQRwB5hAh3D2gBJFts5ayTbe1cGOai+naJZKZH32FIgcbi1/Afw9L4/XawyLAN5MeSa4rEeACurzTCja9b08UNZhsJvmDrJUTQa60rrWepgvg+o7x9/Rq1wurQ0Qj0CXx8CdOLiE+8CdCbLDUSHPPh3cuROKyVENT65JXnhJgpWhfkPVULSAuMK0fWpernDeLzfhLuReqQJLd6pyhvG0lG7Uyzp8UfgVSq+OSF+syqlVk4SLPcMZMwqS2AB/H05gjIRIR8ZBv9z6JxNVGqC5El35bLAayx8SLyQiwnnOzi9VbHq/JAwFCAdcsPgMQxzCZPdhg+61xlYoB9tHaieWyzLrmd6NrZB1Byu+iEy2Cl/dhluUoaxru33BujIf+4+pqtM44uqRx/ES8eUf2IKE/ca6TOSFzmUOjFqU/7/2u/MgOgB3K7BHHTDsz8HCaxQr3+H3z2NPQZuLv370MlG3M3gd7qFcZjgfSgiuRsiv26OU6c5nwwe7YhnRVIOXprNSmza90UMFuDNbCrrUBLama6yIyvUovMNEAI/Bp0bVIMw4EVPEJVVUt6atj31NzuTontqfnDh/rcwvmUwuP9QSH9WzVtgNmZZlOTGChQ4q4xtuuQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(921020)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QkdHMnFsNzdtVGRDN0xGZkx5SE9XeGtUSnRsWVFUSXJjcjRqeC92QWN6ZGky?=
 =?utf-8?B?WnIvdEtkTEZtZGsybVZTQkpqc1Z5Rk1TSFBHOHJhZktyUWpxZnc0dVdQYWc3?=
 =?utf-8?B?VmVTemJwWGlGV1VWZEVQOWxIRkJqYXMxQVFkcVo5aVNRNjVGQUwwYmxONW93?=
 =?utf-8?B?NXV0Y2o4NUZNZ2xrZjduRXcwT2RjRG92dnVJSmxGMnp0U0k2TzRVZTlablZL?=
 =?utf-8?B?UWcxaCtyd3kzSFFxdHorMVJURmpyZVBJRW9lTTRaSXZzUUZTUXgzM1l3ZHlx?=
 =?utf-8?B?MUx4bS9qNDVhY3dOY04yUU1XNnBDU3NMdm54UTM1ZERsNWFFaFhWRm0zcVRu?=
 =?utf-8?B?NklzNjZVYzBMOFlUUXRGTW5qTTB2OXpPVVFUNEpPS240djdoQ3Rzd3pBRXNQ?=
 =?utf-8?B?Y1hpTVdyeG1GTng1S3VhYlNCZTNRWmJuSlY5c3pYNmJGRXM3QS93UWZZbkRD?=
 =?utf-8?B?Z0JpdHBqTjNrTmorbEVLaHhQL3JJMUJPMG5MaXAwLzJnMmJ4WEloRGwvSm5K?=
 =?utf-8?B?M2c0bW9oWGF6dmZzeE9LeVZQL2tZUDEwWERGSWIyQmN3UERVcFVTbTIvclln?=
 =?utf-8?B?Q3pGVTZvWlozMlZSZytSdVF1blV5RExXRG9WajVFMEl3bk5MRVNBR01Va1Rq?=
 =?utf-8?B?MHZIY2U3bUVmeVNyQkxXSTU1RjlHNmRVWjZ2ZkkxTXVtditpZERBRS95aThY?=
 =?utf-8?B?enpFdmNGblpET0lOcXN4SGt2MUU4TnFSazFhbnN1ZzJOUzdyd3YzOGJCSUtL?=
 =?utf-8?B?U1FzaEE3V05KYU83RXhUS25rY1k2Sjhvd0hZVkV0WFIyYmsxR2xnb0FVdjNW?=
 =?utf-8?B?ZjYxeVNQbHBJeTl4T2xhUCtpb3ZjL2MyejF4cTdsb2d1QmtOR04xczVvblp1?=
 =?utf-8?B?elpjT1V3Y1VuYnlpb2RQZDNnY1BkY0E2TTBXTnNVcDVqWjZlNDBrMTE4aE9l?=
 =?utf-8?B?UWV4TVQxNUZZUnVBeXE1YU53UHFFZEYraWtJSkVUTGNTSEUvdTY2cVZnTi95?=
 =?utf-8?B?YkNNOExibFlVaGRoRlMzU0FWS3NGZU9WSHRqVk9OcGY1a2l3bDFVSVdSS1Vy?=
 =?utf-8?B?clN2by9HVmt3Vi91dllKL1Q2TituQXpnQ3BtKytJWmN2cFBVN1pYYVh4dkcy?=
 =?utf-8?B?OXYzZUhRc1I2RllCZFpOVW5hUlpLd0IrVHhOOGdrUkV6aWhRM1o1akwxMUpP?=
 =?utf-8?B?R2tZV0ZBK3dOcWJ3MndnMGI0dWh4ZWhQK1YrN1lmeThpbENhUFMyYUpSdC9i?=
 =?utf-8?B?cmdxdVY4UEhUakJUTnFSelNJVVlhVitJUnUxVVkra05ZUUV0a2wrcEM4RWlM?=
 =?utf-8?B?eDg1YmNqcWpFbXVUYXJOc2Uxd3hIUW1Qc3lCckxYekg2OWlzb0tiYVdIVzc1?=
 =?utf-8?B?cFJEZVE4bFlPTWZpK0xZNjJDY0lKL3ZLbCtJdENQUTB2eWFZRGlrK1RrblJX?=
 =?utf-8?B?UzRlRzlLQkRybGtmL2d5aC9tSlJGUDFkVnRucmpjZUNtZVBTSjNqNE8rNjR4?=
 =?utf-8?B?dGgrbDVMeXRIUFFaUUdNYzM2dVU5RlVRTGI0bmMvRGMxRzZoWDRSYldleGVo?=
 =?utf-8?B?eVpjdkJCK3IrcmJ4TGljSmwwdWhLZDdickZyTmJZakJKci8xTFRaWVJjUW03?=
 =?utf-8?B?VGxRTGFyZGVPSDlmTDA1dXNCUTNSdWpWZUFpSnRySW8xYWRTUGxXSXlLQzc0?=
 =?utf-8?B?aHYxUXpDV2JPTm5yRDNMS0VIWjFBS25yZ1V0Vkh1T2wyZmpXRHAzaTJCT25Q?=
 =?utf-8?B?Q0lMVTBodDlzU21va3VZSWxxcWFTcitlSllFRmNHWE9CMTE3OFNlWGlXYVFm?=
 =?utf-8?B?QXRSRDBVYmhvWGtMSlBTNUt4N3JlQlgxWTR3QkgybmEzTlhyQk1XQlhCY0du?=
 =?utf-8?B?SmgraklaUUk4aTJ5d3NRbW5NVDVPQVBIMWlnQThXc1lvNDV1Zy91Y2NpZms5?=
 =?utf-8?B?cFBmS051ams0VldsNVRmeG9rUjhjYTdiU3oweno2SVl0RFhDdjFCNHdZSkV3?=
 =?utf-8?B?TnlJQ1NUSWtSTkVKVUNOdzh6dk5BU0ZWUjY4cFBjd2FveEFFckdmMGtqSzV0?=
 =?utf-8?B?YkVyaERoQXY0N295NzI5VFVDRXYrbW0zWml5RW9YcnRSbjFPb2lneGh0TDdZ?=
 =?utf-8?B?K0wyNnVOWGEwUUdPU052N3NKR2pWQ1g2emQ5MDNsZ1J2L2dTNGdZa2lYZVBx?=
 =?utf-8?B?K0NaTGxQYXJhNndVS1UrNUhPMC90YlpiZkoyVHNhZTU2dUd6NWdxQVhpcEhs?=
 =?utf-8?B?OFp0WmVyVE5nbE5hSmdCQU0wS1dzUldBZlliUXpFQVc2eWRGRlZvTUNCUEg3?=
 =?utf-8?Q?ezujp3QRE7CX6nn1NG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53474ef2-bc39-4ca9-9bf9-08df17880aab
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 02:28:37.4031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HlxwPal1CmgQHNJg4LUJt9lfQ76mTkTAV3Yn1jVoekJv/G0r0Pg6Lmq3HmoUhaep
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7719
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1ADA840004
X-Stat-Signature: 76pgh4jqhuj7d1ntptcha8gsa1kkewyk
X-HE-Tag: 1789957731-370232
X-HE-Meta: U2FsdGVkX1/97Iv/kUswuxGm6zGPGoTofO2i47NOBq67WKUQSnCuouQOm58yLMnxchxes54DfY1gKfPjChXS0nArYceSfT1NsKI6AiqdnY685lGau4TbWaZNg9BXn8GK2u2bv0MrO75cc8v7QJ0H87XBnz4Q3UQLRIGelu6rjnjvAyA9JZNofmZ472MrTT4khjBsXDF0LVTGQpZE2iPuKlGaGZZI4hThmr0uGle0dA/+Z43AddfwouTFZqnB+xCivYvHSfVSFmlg7g/YAU9ygMBm464Xm12vn60Wif7UkAuMSyWvInUxAxiAYqh7ClPQrhEeztbQ3b2U3xif1ty+FGMVbugyCRxQOtx8ycHdfYnzDvzD9TDMGrV4tPue64czMHdaN0bPB4xG+L9mli84PGKrFmvgqrLvNW9NaaX2GuUHqd0LvtGwfkL7+3pQiyPAN/djnICEAsyLSNhTrxMxo8y1YWL59bv6kL0eVLXBrTvie0WM4hlpt3QOtpB9ndc5+bi1e7AvbdabhzTZgx34IrCF9UVb0AP7Dcx18RAnTOtTbbK2FKl3mBXRU9FLEttVYXlNI8T4iDX3EUVQy19gjcUMbLbklzU/Ckad1bYLTXBLTuzD08d2m/v+uIACURCtWUe6xZexPvAdi6iI/pcJmOQYboKsXuayPSMz4k2srWX4T4/0q3JTnmfI+0A/jI1n4q3RpH3SCwDLmmNFLWm6JwgjHAtgo/cn6EjGA7iPLlFyyEETaqgQj7iyM5J3kiWNTWxAhUcPPcIuYhH55DSeGG7x6GHExOsd7ooNNaYqizI+gYwqzJFmQkgbt0P7kZoQujxV7+d6nC0xGE4vSKMqUHwmmSsw3zSAHN6Bp9aBzJVw1TRxaIShpxfh4UBV8dgBYp4sN8eSGHL+AKXc0iJj5jdAaqXLyGmvFkxEE6mOJfqu+qLi/P7cqZan0MeC0gLa05pwReddLmu/VCvHWQz
 sjAa0kuA
 b/RJVKbdquMuiupTgRuacbTJ08eGVc5v/u+mX5a3prraEc2w3eQtGSVdmPcg/Vf3RDSMH63aspf705IG7Na/sd0EjLGrNj/LUxWUgfHoC9LcEIkrFGNbLKHl19DL44jTvJMGE9esTu90qhUkKNR55ME3D3dtApkyqXvFU7qyt7+11JRibE5H7xNLTf6S9KiiYqN9LCIAkn170jMAC3qQ6/H+8NVSRVbSQosq9LJjVUpvQ1zGr1TVGy9oIEdRMI92AvkfbYim0YwgwK0NtBkIdKRkpBv/guJafpXX5ysN1+z6elPV9AoKuHS/nYzdLlvPh/GhFJbfatbwbieIsIGaa+aL/11ujyeXXzoYNyrwhWHsLLTbQSYa3M3h6ZrlDDg9Q9S+y2Rfj8krwNGvEmKndye0XFSDfZu9M/cffvRR8+1paPhv536eSrpKmC34sC2fFa6ii8yuMH78Dj27/3iMOoeDmtiYuhEkm5xuT5pCbssx59phT/EJmpMECjb06NWPMkZi1dE0O2kWVGPFDs2EtSgft5+mZfvkWRQTKOAsS+vdvmKMNxV5LfBsU+2AtkM4DmsE5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PagePrivate() is going to be removed along with PG_private and its
implementation is the same as page_private().

Assisted-by: LLM
To: Ilya Dryomov <idryomov@gmail.com>
To: Alex Markuze <amarkuze@redhat.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: ceph-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 fs/ceph/addr.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 657c2cb0f8811..1aca181d28c62 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -70,9 +70,7 @@ static int ceph_netfs_check_write_begin(struct file *file, loff_t pos, unsigned
 
 static inline struct ceph_snap_context *page_snap_context(struct page *page)
 {
-	if (PagePrivate(page))
-		return (void *)page->private;
-	return NULL;
+	return (void *)page_private(page);
 }
 
 /*
@@ -124,8 +122,8 @@ static bool ceph_dirty_folio(struct address_space *mapping, struct folio *folio)
 	spin_unlock(&ci->i_ceph_lock);
 
 	/*
-	 * Reference snap context in folio->private.  Also set
-	 * PagePrivate so that we get invalidate_folio callback.
+	 * Reference snap context in folio->private. Setting folio->private is
+	 * what gets us the invalidate_folio callback.
 	 */
 	VM_WARN_ON_FOLIO(folio->private, folio);
 	folio_attach_private(folio, snapc);

-- 
2.53.0


