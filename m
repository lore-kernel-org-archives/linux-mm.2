Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7957C606A332
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 22:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=shXhWoV8
Received: by kanga.kvack.org (Postfix)
	id 84D426B00EF; Mon, 16 Nov 2026 17:08:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FEE46B05B1; Mon, 16 Nov 2026 17:08:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C65B6B05B2; Mon, 16 Nov 2026 17:08:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3C4F96B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:08:15 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9883CA0265
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:08:14 +0000 (UTC)
X-FDA: 85442371308.20.7129C56
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011057.outbound.protection.outlook.com [52.101.52.57])
	by imf26.hostedemail.com (Postfix) with ESMTP id 98EBD14000D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:08:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=shXhWoV8;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.57 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794866891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L+sHDg2bJR50cXoNHg4HjH5e3Mflo65JEPLyXauROeM=;
	b=6814Pwe/Vgo4VErYkzGbUU3AIqCbKEvEUHFBoOwpslO9GIq+Go8liBaQPagtmgFRtn8Q+U
	oAsnbY60RZmtL1dDyH+nFkRpMzWK+Lv4rQWl9nmEh7D5G8JZsuKLHuJpn/uSNFccF/IhNy
	SIFjjXDRrOImSGmPm9mSRDkGMDlBLTQ=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=shXhWoV8;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.57 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794866891;
	b=6QV0MMrYXe46IyAat2t5bULRARpSDSnZTVH32FAXSjBMINzEEWIQ2o1JhWIEq3yA8DSURz
	h5ihauV1Yr8APnTJyo4EvdbaD6TkiRevu2vbgM70w1KhfpxSycZ5nnuGQ62ARmFAJ4bVpQ
	UxxnXNLk2dfc1IASfMg8btTzeYZYPsk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NStpwSWzMWsglPucUYlLbk6WCm47Ifmt2ljnI4tTkZZr0jFRMgiWoRuSiIOXT3yU3HpF/d0qamWesHnlRmvdVlH5gXhse1I4I8ZA6DyUPl3oYhncoEDpclLGKwvxgJ6+F5Hftcanb1P3L2yj4dxBP5Zj1U/2peYSFvDdMUnwaX/cr1fmSZi3rfVFHGRVN/FaPJEBANqMOfWEAkfnF6qpOonUKpz6ixGzbZZFlBoe0H4C5WHPnUbkLu98mDRzKu5JZ10yst8QlhgoBRsQ0p6Ex9LzpQz2aXtPVXZtws3Fi97vRAacPZp31WfqW38XE8JBwfDX5MrQwwaNp2+YuSS0bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L+sHDg2bJR50cXoNHg4HjH5e3Mflo65JEPLyXauROeM=;
 b=swpJTpZT41ahbJkWMtYRwv4y/G1tOMOyrbN8pwBCj7GxCTwhrAjvhOybgt37jN9KtdtcDUYj2OLK6yWk1pYwO3vBNfRGJz+vvNc0VW97gfxxfelBdd0sU37SoXWdnVkiHWYm1oRMNY3rcGxG+/nIhz93j22DpXG2xklRksS7eYZgulWjbBWEA1VpHximqGVVSF+AJZ0OucS40h/Q5Ke4lzBXkrpsj4+AmcWQcpbt/Jk+q30fpahayrcusXPSigYezhRfzKo6Xm77F/tcfq2IXWAe/9r7UflEYU5TG8sPqgWYzPLbLnjlvEe5/p3TkLu5pglX56ZZ1FZPCjEC5oRZ+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L+sHDg2bJR50cXoNHg4HjH5e3Mflo65JEPLyXauROeM=;
 b=shXhWoV8A3n5xB8U6qNS+2SqlApMWGnYpcD+KEQQXYy4d50il+kHapq9ALH+5da8Lna/zoWT8evJwRcB068MCCS/7+GB6L6r45cdsO++/kyoneQnpKHSIuwga1rvNF422yyAAkVzOMtFZxUzi9sQYiMdSa/ANcY7rgzoozTRfgFgI3TOrtJmZSNa0SOqpRM6T+gispEVJhEGM9/d+RVzcSsuTlPWEWUDQElF9aUhA2F/siDE61rn7xZhZXU+vSDio0rjwTxEMarS5+92uRtBAoMQFiEgMoIs3mDi7g4MKGBwdRSrAJ62c1f4ZErVlDU/cHeqtC1JSiMVBXONhMn6vA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CY5PR12MB6298.namprd12.prod.outlook.com (2603:10b6:930:21::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 22:08:02 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0615.009; Mon, 16 Nov 2026
 22:08:02 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 16 Nov 2026 17:08:01 -0500
Message-Id: <DMWZ7IE01AWT.1G38RVHZQFF9R@nvidia.com>
Subject: Re: [PATCH 2/3] mm/page_alloc: move the kswapd node skip check into
 a helper
Cc: "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Brendan Jackman" <brendan.jackman@linux.dev>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel Butt"
 <shakeel.butt@linux.dev>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <kernel-team@meta.com>
To: "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>, "David
 Hildenbrand" <david@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20261113235238.3595412-1-joshua.hahnjy@gmail.com>
 <20261113235238.3595412-3-joshua.hahnjy@gmail.com>
In-Reply-To: <20261113235238.3595412-3-joshua.hahnjy@gmail.com>
X-ClientProxiedBy: BL1PR13CA0106.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::21) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CY5PR12MB6298:EE_
X-MS-Office365-Filtering-Correlation-Id: b043b15d-555b-4969-a60d-08df442e152f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|18002099003|22082099003|11063799006|4143699003|56012099006|10067099003|261026140227099003|261028144727099003|261021123027099003|261009223027099003|261021121427099003|261102123227099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	MWbW4X1dfXnabIVmLd1CFhdLI4TpGgiWwAOCRA5MKziEg1dvVc6agIGd1wuFWODVKBf9NMdSiYqJgHR7AjHSI9JFmNk7Nq1sbKXB/CZ3YgwFzbuBN/FzFPVNFiTyR2gtQmVMhbdcWTWGfJJ3IzeiM2T/ACCGaHH5sJIRXCEEWChjnNLevolozHEuHprtuIX00KsCHCsOS/UG7cbvahzmNH2dqaiGoOHqO+PuXeCfwgAp9uIYR2AzfQfq0uzOejreqbmYrMiLDWIe99RerdvmVwjC50q+qSesCsbGtfJccNpp6cm7PpHnzDV8iFBSw6J0rRVVygcVUTFStcqttFxPhxTiIRYbaNFqBeb79UPvQzkJlulVfzGft73dnxjbMmo2Nzqqv98sSDQd4AAXbagTsIt5gqXdwIPXUcBpReSPOSfasH2xjVIpksscgUqzt5YdRdp7I8p8yTV287b8ZwkjM/n1+mhHB7mDylU7+maDvYu44oZt29gvbG5Msj/VpIWXr6g7BM7NVcluPmAV8VS4U3q+hngTZVdfKMLPLRgxj4dbTda9OTwx9xGFrxUWElTwWoq8OQkWjBdyWcNrU/Tp6Vj5+Ul1s8UoLmRDUoQ1Jh/Q/OcxaZqXXbFh0YChBiZwbGvF/iTt3UnQ83R33Oa1QlLzcIYDzSW/Cz6Pf5MMmGM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(18002099003)(22082099003)(11063799006)(4143699003)(56012099006)(10067099003)(261026140227099003)(261028144727099003)(261021123027099003)(261009223027099003)(261021121427099003)(261102123227099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SHgrd3lWMXNMdGpFT29FZVNHbWROejRRU2JCM2t2MzZNbXlVaXN5OGpKREps?=
 =?utf-8?B?MDNiRStQeVhLV3NMWTd2eVdJTFNZdHNibnVyK0paNHZNRnYrNnVEZWVFL0pj?=
 =?utf-8?B?ZXJOMEhBczRXbms5Q01FZ0Zvd3JYK0NDdlhsdWxvcDBjcW54RG9CSEUxTmlv?=
 =?utf-8?B?NEFGc2NWVWk2dGthb1djN2x6VXROR2Nrdk9YYnlvcFFXNEdyUGtKaTgxSFpa?=
 =?utf-8?B?QzVRQUhsTVVvSC9sbENUTVNIa1VMQXo1KzZmb0pHbncxUDFFYWdSRURhenMv?=
 =?utf-8?B?N0tOM3FtU2VodEZNL3FHZll1TURaRnRBd0NCZEVSV1ZIb3R1UGJjMEE1bGlk?=
 =?utf-8?B?UkxvVEFsYnk0SENiMW5Vd04wc0pRWnBaZ3ZpNFBtZ3NJNHZ1dlp5WkhRNFF3?=
 =?utf-8?B?RzRtMDB3RzY2eStXcGZzRXRFWnBrMU11UDg5TDFQQ1FzTG1oSzRLc0dOYTF0?=
 =?utf-8?B?b1hSaFZjdUZRaGJablBrS1hEUlZtWTVRcUY1MnkzQjNpV0xwSWNlb1ZkYTRZ?=
 =?utf-8?B?RENPM3NNQXNrMVp3WjZzQk02Slp5Rm5ZNzJmOXQ1MktRN0FISisyakxuRitr?=
 =?utf-8?B?TmlqTE9RWlJOZ1VmOHJkaUJIa0NRRzBVUEJNcm81ODFOWm52WncxSXNxUDhL?=
 =?utf-8?B?WDJlSCtJSVdSU2poa1dNb1YyeUNvdUNtMnpWU1F3TEJnUEhTcURnU0g3NnM5?=
 =?utf-8?B?RlN4U1NuRy9nbVN0Q3U5MFh3a0dsbXpDVEJrLzg4eU5Qa1dzR0h5dlpJeUxH?=
 =?utf-8?B?RzVpUDBqZmwwRENzM0dDcC9FU2ZtYlB0NWU5dG5weEh1dS9KRGNCREIzTFVv?=
 =?utf-8?B?d296OUNSR2h2L2lFQ0VDK3hLcEZheWkxanEyYldJaGJBdzMzb0duOUtMSFVO?=
 =?utf-8?B?Y28zQ2RKa2VYZDAyTHIwRmxIb21SaXU2TVk3VWlJWUVlaFNoRkMrVlpKR3Bi?=
 =?utf-8?B?cmZQWE0xdTBlNUxyVGJ1dGRJOEx5SUc5R090ak9uS0E5eVRWZnZmY2JRenBn?=
 =?utf-8?B?VVZiN1ZadUQvcjU5b0FOdGNXRDdjM1NqYXUzY3FrYWFnNko3NDF0dGpsdFU1?=
 =?utf-8?B?UDZEOGhRL2twS3FERlVHdkFjNWZpNjNwSlB2R1lGMmRiUG9JdUxMbnlXVWJk?=
 =?utf-8?B?cXVjTGxpMkJWS1lVWWhwa1M0U29RUzI0OStXVjl0ajU5NXJWdjNycVB3VFBw?=
 =?utf-8?B?V0h2d0JxRkdWay8rTW1UZktULzR6ckZLR1FUR3pnWEFOaWJqMDZBZGlzcVI2?=
 =?utf-8?B?czNpRklrN01GUHRPWnVHbmk4L1ExVnhNR0plMGpDaSt0cndlMzRoNGFEVUU5?=
 =?utf-8?B?L1NsczNpUWN6ekM5UzdLRXk5MGpCd0xhUUdQOUtPUFlpQnh2ZUoxQ3A2M1pN?=
 =?utf-8?B?OWJRYWtpeUk2aVd4NlJ3TkgyZXF0ZFFGbExjamFGMXNHTVBGZzlEMjB5TDFn?=
 =?utf-8?B?QXpKOEpUM2RLSExPMDByeVA2Y01NVWRDcjNSdFdvWXZEVGJMN1g2ZkwzTlpK?=
 =?utf-8?B?ZzcxMXVCWWNBOG9DUWRBOVdJb2NsNVlQMVAxQzBGMnBJTXd3ODlmVFkwdFlz?=
 =?utf-8?B?K2NDUDhYdHNZM0h2K01rYWVMcTlwZ2Y2MndhRXhqQ1hZZkhFQjhYVnhrdW9j?=
 =?utf-8?B?MXpIcTh4N3NBUlhKNjVvbndPM0g1aDN6RzIwYTl2YTZMcnd3KzFER0NmNTBT?=
 =?utf-8?B?UUM2SVNlb1dMcXhTUE5hM3dKdit2U3ZmR2Rra1NXbXYxRzR4eUhBZEVobzFO?=
 =?utf-8?B?Q0tsNFJicWlNV2xlMnA4TFNhZ21SRE93TU81MjdFcUt0UnlYWUFYL0ZZcVJI?=
 =?utf-8?B?WUd0N3FYb09CeXVnZ3Z0Mmlwbmk0cVJxVFBkNUcxT2JVTURWYldwRis1d0ky?=
 =?utf-8?B?Wm9ZcDlvZTdFaGlHSFBCWGRWeTljL3NBM3Zacys3M25YVldwOXRoMmhoTVVq?=
 =?utf-8?B?ejR3bGRaYklLaHNjU1V1WVUzMEFYRXVXUmJ3eFFLcGxLOVFoTDlOeE9ob0xV?=
 =?utf-8?B?MkxaTDd0RDhtK0FLd1hxZk1wYlNNUnBiaWF0UXBHMkM2SWYxaDRGZXA0ODdw?=
 =?utf-8?B?Z0FOLzlKWW9VVk1jZEdmSkVPbDNTeHprWmdtQzJNeXhOUEJVVFAxc0ExZlJ3?=
 =?utf-8?B?RjJVNXl5MzZadGVPRWpPN1NhSmdTdGdmV3NmVVRYdnRKV1NOd1p3VTlwREZJ?=
 =?utf-8?B?eVZvbkV0eGUrMTBGRm8wWkVGZFJXU2dxbjlzZW1UdU9JT1B4MUdBQlhNanYr?=
 =?utf-8?B?NjNKRmpsMHh1N2RzbE9zQzlFZklFRHJnbWxPT0ozaGdMemRmNDFGRG4yY2s5?=
 =?utf-8?Q?7gV7tPZN3bAwo1zrE8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b043b15d-555b-4969-a60d-08df442e152f
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 22:08:02.6665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gJWFog7buFeanKt+ujcdLGAnYV56TizsUa3eUGc6R8OPF57rDVDCheoW8OjT573Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6298
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 98EBD14000D
X-Stat-Signature: 71hbd6no8ihbm8zxa54cofzb91by3ti1
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794866891-248277
X-HE-Meta: U2FsdGVkX1+XR5KnXe8/HciljwejWvzt6s+Lg1/gwbrEyvZJyvr5dG8pxR8yVZ+UcKfbq9yTKtUWJJB3vGFDjGmQ7f6oidBhHzLhVE+KC8mfNAXXxVI7BSYDibCYWjduBi1CzIJoBp01v2jHeFDnd+hchkyOB1R6bdgyJyPe5POjXNoKGacIx8aQm0S6dzR82Ovnh0NbgueyXFcL9FaEElMuyo3ZbOQQgqOMPgcDDE4dIXQ8h734sIgW7AaRs1KBoJsE5Qqkwc23+Rm/GkzPgyqItWMeI98Kc0QnFPn9BmUOk5zg3Ek34rB5iALHKasaQu1XYF/PK5vvYWtDs5Hm86cAN945DXb86ZJC9s6oovss623/Lmld8/MFa5iLFqm3Kcos0sIZOMUVAXUztopB94ZRJqZ0ZXrIZNt8J/R+vcdVxRBauqO5HUUKLhNHnbh6UT1IxoHAMoak9O23V/mDXFm9dI26Rw7Uydjk3iR9uUPWPPKdgRJi3CmNsUTvPLM8O2CBFOvpkOzXPTFlAK+TygXUKqCBqfqnXnedFtX29yNzFqmzv5khtrs2//MudUnZyBhr99QLw8ywyxwfiIkXwY2YJR/byNPaiiglUZ1Gex5uZWnGscfGk7DThGgLl7kmV5F9W8jt5j6gV7oYM+vmY1Io4/8BKdgOsFdSbjwGbD5jmVh3WOY1Kn0u2DljEt3HwLCAJ1Pq4Fb6twU+cgW8BUtBdKbLpniLh4Qc/xpvzGSxE7wFLZAtMKjSN8NwI3NebCfO/K723Ha7fjBIi8WXYoJIm30zyJBOyIrycGhCSBmS92b6NkASBd/0fJ7P1RzN/2AIvSX2MYStOUreE7iB4CbOMbNhE1bEw9CUv4xcfNeWYd+76YLiCrZwv2jOaA/xm8dnMEaMOVt2T216I6+lsUHvaEPiy+qWCfkYOGuUwErTnIYcoGftVHf05WU4ToWQKjmfruphYPTS7cenwhV
 gQYWNaay
 2rUVwihoYWNREfNCZRj/MMMLNvZHetHsOfxD7Kw2YKh1Wav43SnWB1ahDXqVe/aUcrejubL8uhUu5yh40ZT7qDyyd66UIx3aVNiZosY5gawAS3mDwy26xjJTBsQGbAsQz9CMKVzj8fi0G2Jv6OZV7zu/OA0lGXnih26Y5xZys1f7QWTuVhPH5pNpYe0LNKMAP/fbcdHxbQP06cIpPe9hOsU6hC4brbvzD2c7HYGy+wZwVDxHeEjYp8R5Ufk+G1bQoNxW9YxqMRH+nUl7STZ1YxsfFYG/BQpMQmObJ5xCDrd4pndS+tTmfQYZZVG2uoEGL8XQIthFFb00MNX1nzdj7R8EEGu4jVqcwS+tXNf/L2BwOQGpnqb7tVnccFc90VtnKmWGTds2TCVmJmUGsrkK0aeCMT3j9Z7G3z1trJ8VidZ4cQlx9EjG14MrR3FGhyYEYYS8FCqgv/JPhu/Fd928wx37+zHykhpJWn7cw8QlXER8URxLw8z2K+j6yPVDyedWkExjGMjRz61BIIuoF8wjSbe5N16RUZisaOgBj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri Nov 13, 2026 at 6:52 PM EST, Joshua Hahn wrote:
> get_page_from_freelist() checks many conditions for each zone, often
> with a big comment block explaining the conditions.
>
> Move the kswapd check and its comment into should_skip_kswapd_zone() to
> make the zone iteration cleaner to read.
>
> While moving this, also resolve a checkpatch warning which complains of
> a waitqueue_active() call with no corresponding comment explaining why
> the lockless use is OK in this case.
>
> No functional change intended.
>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
>  mm/page_alloc.c | 44 ++++++++++++++++++++++++++------------------
>  1 file changed, 26 insertions(+), 18 deletions(-)
>

Makes sense.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


