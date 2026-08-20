Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB1F4C5DF87
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 23:37:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC2C46B0095; Thu, 20 Aug 2026 19:37:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A738E6B009B; Thu, 20 Aug 2026 19:37:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93C146B009D; Thu, 20 Aug 2026 19:37:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5C70F6B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:37:38 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CC9781C0FC2
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 23:37:37 +0000 (UTC)
X-FDA: 85123262154.24.13F4C50
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012017.outbound.protection.outlook.com [52.101.53.17])
	by imf28.hostedemail.com (Postfix) with ESMTP id 12924C0004
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 23:37:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mqHaspIe;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.17 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787269055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PkT2g/Cmv5lzz3T57uV9HgHtD4bEOgzIJnFRKhCXZCQ=;
	b=3eFJIvgohS3Pku8vLGORRC6IwUJx36s9beBM6M12kwGFIoqwVMVglB3SGPplUWGYsePM7G
	Go3HQCE8uvnnv17BrMqtwdjAyWXkaeaVb/BAI1LED2iYKaa0EotCs7qT+wx77qAJvHJOy2
	Mue2I8ThryF13dFqedQatFCOi//9E8Y=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mqHaspIe;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.17 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787269055;
	b=ogr4zaJGsNFCE6d91lj8FdD5K8pp0k0pdxfPMGttTlxUpYbIPlf7H9/CXFNeiM4CmYkBUg
	DLZ5ON/YpRTZ+5Yppp9jycfFFR52ki+7nxAIyF+dG0EZAmQZfv4Fm4KOYF93+uKVTqGT8K
	crN3RBVd+37wl78QbHjTlgLtY2Bcmns=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R0xunk+ir3UoOgRhJ6kD2wH5EsuIXE0HW+ZmPCBJrdVXOLWTvNHD99Rt0i5NrXIa/s2TOuI+jY3UbXPX6NhoiTalczWa7iqfry4ZumKanm/TJ8uvK1EFXhYJW9wpMrWSHCGb9B11KyHwtKYTc2ydaT3jQ/HK3N6uo6jDQHG7nuRqSGxdhjbod1O2z/O3ozq4Qg/9rqEtWi4w6d6vTEJtctRfNMw+5J02ENAMH28oUsfbdV91tFbTh/XA6+ykHPKZjWq9tFnAHFIru/vnFU6jCxLKc4DRbFb8t/OhiVKVUHEv2Kv59nqZLjqZ+VWHABvc/HYAxV4zlJP5y4QmTRshHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PkT2g/Cmv5lzz3T57uV9HgHtD4bEOgzIJnFRKhCXZCQ=;
 b=R/F1i06VDKCAUkRGRZUt+YSltHk5ed1CW3rvELOP+HH5ax3GGMaUVRr+RrqkgwIyvIlDgE4crxietu/W+H3LAbci3jAA/G7XAhGickMMC14XkvqNHyyjv/nFiROk84+3so8MWoYiPqkOB1Xf7JAb03MQjatDpJi8TKI+yNTwKpm/q8HTBVrPfDtGdtnIDxt/v13b1nGq7l9835seIaA5m0YjcngFbbbTbvafoyrRt74xbCOGVycZE/xmDZ18Fq1MkEusSBbk1zaKmekv96jGkF8c2fCb6tZw+BNQL7jdKSjil0r14u5wWBq8bsrTZVjwLAPgG7MfYP35T84XtVxdIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PkT2g/Cmv5lzz3T57uV9HgHtD4bEOgzIJnFRKhCXZCQ=;
 b=mqHaspIe7yjSbRKFNmlRzCP+Zs4HZ1caC64O5VU/C8371WSYyNahbA250lvsf0OYPTlsP5DUfd51cnJBRaiJc/IktJ2NNxoyEi/2ZYa2OiPqkK6+W2Hq/wNgjLSTXBEGg3JjtQMkqE6eWe8lI+VBGSjINt6CPgwsjdmNSDwAph+NDDl2ga3Paa7IFm7AufEJtc55v6Wml8Ce/r3ScbmEj27d5ecd0oJEPc2eSpGNGhCV2Gn3EH8fW01hZkJqp/Kt6f3voXLYMi8p5KYVpah3R6IpcPLIDDip3Pi21MRjVXrH8jomCfRZ4yGfE25nDNpsQPHTNNgWeLy3D2XRED1Zwg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by BL4PR12MB9480.namprd12.prod.outlook.com (2603:10b6:208:58d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.9; Thu, 20 Aug
 2026 23:37:31 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0339.008; Thu, 20 Aug 2026
 23:37:31 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 20 Aug 2026 19:37:29 -0400
Message-Id: <DKU60290OED0.12P9UF0Z97DND@nvidia.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, "Usama Arif" <usama.arif@linux.dev>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Shuah Khan" <shuah@kernel.org>, "Kevin Brodsky" <kevin.brodsky@arm.com>,
 <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
To: "Yeoreum Yun" <yeoreum.yun@arm.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH 1/2] kselftest: mm: prevent random failure of huge page
 split for khugepaged
X-Mailer: aerc 0.22.0
References: <20260820-fix_split-v1-0-ab430c58c7cf@arm.com>
 <20260820-fix_split-v1-1-ab430c58c7cf@arm.com>
 <DKU173CETFYO.1RJA1CSOC5S99@nvidia.com> <aodwNr_zgOn55z3W@e129823.arm.com>
In-Reply-To: <aodwNr_zgOn55z3W@e129823.arm.com>
X-ClientProxiedBy: YQBPR01CA0151.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:7e::9) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|BL4PR12MB9480:EE_
X-MS-Office365-Filtering-Correlation-Id: dc053419-792a-413c-78c3-08deff1400df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|6133799003|56012099006|10067099003|4143699003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	kiKLqKXAG6ckcrBK8o+RjGhPcaIZvY2dOtq/Xg+p5TdvWohn9JLqF097s6ySyWrcM9cNvyFdp+kBcc4vJ6ZYL2jTw0M5gHAFvMJ3UqPQj8YnHJbZBvX92ko50v8qUlfzndaYbNfJ/rCJ8Xk361saGn8z/T/qrUgLKySqw78cRdL35Oylgye4p71vvt4y0dtogTHpG0bkzOo03+LrxWTSWtINAHZWn4XzixC71MWuzlg/LoFVa7XC59/0I/Tx9efcDommdMR6px60fNaddmwLHCsUkDMplwL+YzGZ8ZL9KuPN9acpWutomu+TwJXZKEpVjzxiRNHI0U45KKWhYkWzvmRC52GL6vn+ziTvUB9j9E7MVh220OSD2SglmtSshTHGRfqAUi+DEYgljYYwy9qDagBdn5E1k4Qr9Mdw5RHmCs8IriUD9/xjTPDIgvHzWLqT6TKMV9Bsh902MYnLX/7B2Nd7Az1mkYhVBHKINdxqQ1sem4EB+xV/vcK/a20pbyL6Nka8W42vcMaY5rs/1YjYqBgVbHdm5kGuGiwkar9Ugc6kXb7r8BPtwHU5sETonNxNlTApmEGd35478wRb523V8sTmCDi8dOYZqqfDuWh38c78n2p+UK/GSzGdy7hJw9NoZ1TVkCaGzVP9cC++nsRz60LmfDdDIrZrUmzl0SN6b74=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(6133799003)(56012099006)(10067099003)(4143699003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QzM3NnZCSno5N1czbFNUYTJaMWgzdEU3NkdEU2dwcHFXQ1ZJV3RrZGRxOE5v?=
 =?utf-8?B?aGlrRjVTWHU3aDNOOGQrL2JPSGdKY3VMS1p2UTNRMnIzWDFmcm5rdmVmNlBI?=
 =?utf-8?B?MzBuYVM2ME9yRk1STGJkK0ZGUE85R0JXNWJBeXFNMzlsUnFhVktITStzaUli?=
 =?utf-8?B?VkxtZW9EdXJNbWM2bWNwNjNXZ0s0bFNuS1BkdlEyRmY3UWJzTEJxaE9GS3NB?=
 =?utf-8?B?WHZaZDZZbmRxY2xpMk9WdTVodms0Y2tNK1lORHNQY29VYkp2K3RnOXZldWJI?=
 =?utf-8?B?NmxndnZYeEswY3IrbjIvM3FrbjVCNDJNOUM0NnFHZUJScVgzdzU4UnhDSUNh?=
 =?utf-8?B?RGE0WGlKbmNzWXBOYU1DKzVGNkNBYm0vMEV5WlkrTS9CRnFUdWlxbmI1bmxy?=
 =?utf-8?B?cm9yZW9pU1NpdXRQRzVHekFTNWhkQ05xUnV2dy9jaHVHNVdocE9zY2JBbG5u?=
 =?utf-8?B?bFRtRzB2amYyUVlpbXNyakFqMVArSE5uNnBvSDJueE5uZ3ZzcnIxTXRmSyti?=
 =?utf-8?B?OEM5QnNGVXpjY01KVjNBNlUxL3pzK1lXaCtlZW1va3pBNmsyd1crdFBPZUhk?=
 =?utf-8?B?WUIyZ0l0emVHVWZMOXB2OTNRWlFrL1NzbUlyMWZxUUFTd1RQaUxKdUtDMzk1?=
 =?utf-8?B?aW0vQXdkSy9BT3Q1clJhRTlPYjliQThZK3dEMDRLeXI1S2xqb3VFeE1JZWNm?=
 =?utf-8?B?dmdoOUFFemlaRFJRWUZrMDNhWEgvZlhTNDZxc0YwUVZOK3c0WkVzUjVZZHh5?=
 =?utf-8?B?cnR6U0ljdFBpeGJJandIdkpUUFhHNllVNk56dmFBUXRkWW5VUHJheG1ZVWJm?=
 =?utf-8?B?WG9TVEFlWFVLTERrK081c0M5Nnd3b1IxOGJJNmpIeTRueFBJZWFsdWxHTjYv?=
 =?utf-8?B?WERqOXlvcnR4bDlBTlpRdXpkaWpqcDlGNkVtcHhmRWNXYXNrWTBUdUJBQWJk?=
 =?utf-8?B?QUhSMlZlb21wZUdRN2hiUHM3VFdLTHkrODZoc2xVUzBNZ0JqU1gwTjlLL0dp?=
 =?utf-8?B?cnJ0bVVNVHJocnRMSTRnT1EyQUpIcGMyQ3hKR2xxdkZHWWNBdkhOeGJuOVY2?=
 =?utf-8?B?RU9XVDNJTjFPMlZvVVpCTk44NUVJTmNYVVVQdi90MVhHeW51ZUJ0YTFYcUtm?=
 =?utf-8?B?SFlCZ0g4Q0ZTaER1M2FrOER3YzFmUVVvQkg2bkU1L3VCSWtsczQyUWU4SUNB?=
 =?utf-8?B?bjRRV2MvdWhzam9xVzZGRkdkckNoUnNCK2RYd0lndmRmTHJ1VUxkS1dRcHQr?=
 =?utf-8?B?YklCQ1FEQy8xdUFsdi85NGFSaWlKOGhtbmZaWUEyU0dDUklMbVg0dFBVeUd5?=
 =?utf-8?B?NFhnaG0xZ3g2TjU5VXY1NzM3S0U4U1FNY2JBR204Mk4wYSt1djJRNHhuVjlq?=
 =?utf-8?B?LzdzQUpwM08veWF6a1l2ODBpd2tmU1h6aFFZUk4xbVA4TU5UVzVxUSs2U3BO?=
 =?utf-8?B?WW5sZmtxZWk3MFRSenRLRFdhd0ZTN0tXMTN3a3lmQ0FaMis2ZHJnRm1mYk5n?=
 =?utf-8?B?YTVlbnVLc3I1ZUE1MVJQWG5oVWQwakdBTU5TSWxXNDFlTktBaFREWmlJUEEy?=
 =?utf-8?B?a0JRYW1iaXE2QTJ6L3RJdy91WUE5TTc4ZG5sYVBEczlsdVFha0dlcklLT2Z3?=
 =?utf-8?B?SVNRNVhTbm1SSnA4SU83MjRFbTFvSXowNXFDVWRCT0FheGg1VmppTlpRV1NR?=
 =?utf-8?B?L2FSa0s5c2N5TlluNHRHUkx6TlZJK3VNOS9sTGV0OFc2ajR6b202dklSRzBT?=
 =?utf-8?B?SmxkQjZiTXMyaFZuRHZPQVZGOGZYTDBGSjdtUDhhL3pHaVhSNFpXcVB4SVcx?=
 =?utf-8?B?SVlzRlQwdnZSdlI0cHhudDVjM0JOUzlJSzhYb202ek44L21uaThsUmo0ZE9O?=
 =?utf-8?B?OUg3Y0JhTm12aFdlWDVxNm50aS9icVZIMTFvUjE2YjVWdmcrcVVadkd6S1Zy?=
 =?utf-8?B?NENSTE81VmlNZ0xqeDAyNUpNdXVJY3d2VHg3N243cEpYNEU5VzdNZWZEQkw0?=
 =?utf-8?B?THZFRFdLd0pHdXBsd2kwbGVoZEdPVG9xaFRwRGYwNzVKM1BLVFhmM2FmUTIz?=
 =?utf-8?B?WmZDVlVrNHNtZWJEU0k4UFB4bTBWZG9EQTlsVUVyOEd5SDljTXJWajloWk1K?=
 =?utf-8?B?ZVZvTGp2OUdhVmlKbHI2Qy9JSEVOMjMrcWFuV2lQUWdNVWhPYUN3TCtPb01G?=
 =?utf-8?B?OEJWUlhuNGVzZ1hrb0VsTVRRSUdZaXlkdU1reDAyeXo5MERzZDFLUXpKMWRz?=
 =?utf-8?B?bkxLU0tDNnhJdHlERDJwOTN0eFZMazRHb20zU0ltV2lhMnAwYkZsTEptOTBn?=
 =?utf-8?Q?soZF/QB+noQ9hJDuk2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc053419-792a-413c-78c3-08deff1400df
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2026 23:37:31.3311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zHO3yc+CCAy+DhLHL7WCwV1JRA6Cb3NGa7aWMb6QVno1ALQrelLNbd6lYz9X7FA/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9480
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 12924C0004
X-Stat-Signature: pupyh4z9inqz8wr54odcdw63r7jf8ybb
X-Rspam-User: 
X-HE-Tag: 1787269054-30159
X-HE-Meta: U2FsdGVkX1/WiwYVIQUDQspb0X0ZXdBrta80XlP72BEg+W2hUYLRCJ2Hdtwou8DMn+OtztWhjbPsSPZ06cObzxkpRhewBeHbpUuCU9AmvhY4Jb15FPcbHmGcAmDDY1rRu08to7zOHDyEdG8ok/TEoWWNFnm1Th9DGZb0XK0oAr3BvzSMGv+TEYh9o1Ed1fA7NepqyUFDKlBTpmrfa+pfC0O5I1A+mvLJMnHqcRdrDcBnZZ+B0eS319KM9NdWy2OKJwKV4HbW9BRRLHLP2lnRQ6wlS7/fewv6ggDWiY3XtYTwCXs+bv3y5ls+cfJ6AMhbX7ufU2SOTt8rluVdMjxHXaaxGlz5llVVew5ym8Im1wVF34fcucJACigJvOWqbK2XfejvkPNI/UjAI0FCdF4dBwGAEioEa11TbiGGJw/bRVzpOTlkShiMQjj+BVGfkMjZFqwI5orW7+Q9ETzsF3SASvWd9Vs+VjyDJrQ0L8u3gub78pd3mc7VXafVz8Ili/Ny/aWQtFSl42caGZTW4Wfu2YbI/23TQrKkyh0eCVz38wCpZGCNMFa0yrELj0HOQm+Mo0GC3W1TjU8Qos9FruKFib4mJT+L/FoFpQamNBxtYjmqD0G+29yMHjYIJVJjLZCB6IqEW6vtMn5qElXR4J5MU8do7b1ENYoz+IvtowlBhpICtep4G7WHkV1CPzyTVDgE++ai2ZdNEz177Y9xA7gJQzZ/EgRFHw4xtgE2B+M0i2ZgRXMYIpvINfadvLcYTXN7M+Yos8D30v0eSKoXRUlmikaglOjlJH1O5i+ygjmPoC+3RF3SeAH3zt0XKDtxAat3gRqwq0LI1FYmu5sQpXNbXdDxLKtCzGf1av7xHpc6/vHn78dqW6RMCLGFAuwMQ+ssBd+K/ruQoRfDLXGuDeZ/wCQh+pf5XR1pmdgefLRsygRleNKPl+7wVdlpGjPkpE7eTMSBc9OMnBnj4rDTNux
 U/odOOoJ
 tTXuQgfhVfu9GLtciWtvVvVZIpa19/Amz5dC8JdDFXk0imMuHfj9Bgtvc+8BLjfvZqWAOxq4TEGI8TLqgKmhMxOxGeP7HuYqkMwtHhy/ae70DEdyQ7SXC22MLwJkMfuD4VEIyIE3/180VkjEsUZ5/7gLcgPzSAza+i/1P/Ytu0Ys5+yIDYb87UCEO/2XLtRlc6V981GWXB/3zrWcdh11KYdV5DIyuvL6WxwnSNasaKU+kfD8av8R+G5yI1h45TZ9vamcTR0HLz1gVtELB4BaUQNOkmttjfnuYM9XSac22rIC2Pa8Hw+U8q5bf3UKB3e4Oi8YqYcan6CbrQEr/ESw+G8FICMPgMWWNd1NRYeFqnz+TYcObCBJHaQvKpvhLSu5V1S9ptANBOwB1Eu6KqqmAIFGYrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Aug 20, 2026 at 5:23 PM EDT, Yeoreum Yun wrote:
> On Thu, Aug 20, 2026 at 03:51:34PM -0400, Zi Yan wrote:
>> On Thu Aug 20, 2026 at 3:40 PM EDT, Yeoreum Yun wrote:
>> > There're some random failure for split_huge_page_test when khugepaged
>> > collapses pages into pmd again which had split by the test.
>> >
>> > Prevent the khugepaged's collapses for split page by setting the
>> > mapped pmd-huge-page with MADV_NOHUGEPAGE before split.
>>=20
>> Why not disable khugepaged using APIs from hugepage_setting.h?
>
> Well, this also works with hugepage_save_settings() and write the
> khugepaged/scan_sleep_millisecs with the maximum integer.
>
> I don't have a strong opinion but since it seems more hackish way to
> change scan_sllep_millisecs, I use madvise() with MADV_NOHUGEPATE.
>
> Would it be better to change using APIs in hugepage_setting,h?

No. I did not realize there is no way of stopping khugepaged completely.

BTW, I am curious about your khugepaged config causing this issue.
IIRC, khugepaged scan interval is about minutes and
the time between madvise(MADV_HUGEPAGE) and the second
is_backed_by_folio() should not be that long.

For your patch, maybe you want to check the return value of madvise() to
make sure it succeeds.

Otherwise,

feel free to add

Reviewed-by: Zi Yan <ziy@nvidia.com>

Thanks.


--=20
Best Regards,
Yan, Zi


