Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2BF0F483E5
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 19:07:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 263E86B008C; Mon, 23 Mar 2026 15:07:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EE916B0092; Mon, 23 Mar 2026 15:07:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B66A6B0093; Mon, 23 Mar 2026 15:07:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EDE8B6B008C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:07:12 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A9181C3C89
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:07:12 +0000 (UTC)
X-FDA: 84578260704.04.43B923A
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013029.outbound.protection.outlook.com [40.93.201.29])
	by imf01.hostedemail.com (Postfix) with ESMTP id D41084000A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:07:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=D5BMohQF;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774292829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LHR1TMF7RnPBJKP58PdFFFmtsYveJ2teBIQQDxcTryY=;
	b=Xfqq5orxjjSeQoyPXa99WCqCc33bf+nnLuYYuJxRHCO1+lbK8W/D28hYZjcfJZwIaKpell
	9gIf3HvQOfV8NjyTncciJSmKoaYbiuNctLiqndCFZnTcx9r9A1UN2Zvxgv2ZBIKiLaXqSC
	35NhGcRl4pEAhXTfB6I4ULJGaPW9tqk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774292830; a=rsa-sha256;
	cv=pass;
	b=vUg1lCwa72Hv06DnSOnrYZwmJtmvMKY49CKUS+q3WTWbLeiWVDmSJHyfMX26LmGjJWm38F
	mlnD8F8Z0UH2Sx7zi6RyLctjYw1zr3c6HqKlllVijox94m8C1PPBqHijQjzDeKJEoH3Mw3
	IhsGpIk1CWE5r1iY0AbzVkSVA13StMs=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=D5BMohQF;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gbhrpS4RP5mSP1kcYxwyUnecEBXnIece5MD2T8J3dVo6KSgDNWz2TNfwSWgduXgjWsYJRS1+/G/KDR7bLj+BWyoEhFSeQF3vqJbNSB6N/k1icwBhd1cAW1gpt4oACo5eLxlXeXi4CEVhRhF+fwlPpESZefh4kXpY9S6qFqUQKh0HWbtIVUtbtz1BhR4aaaSThci+tsaoUWIG+nVWpcQjrM1gJB50/NUJejioWbU0j40htQkBmHzK8FnBO6aVSbJntxByaaeke0E/W9/iasci9Li/Z8UceR82iUJJpf6rMMS0KaAWPIj0YauMpci5oMYc7B5VRjse3PsHoeFr1s8psg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LHR1TMF7RnPBJKP58PdFFFmtsYveJ2teBIQQDxcTryY=;
 b=w8mpkHdaHtBKK9PpZg0W1yTOEQvRvdhLAomsjq/b8WlygB/rARE77ZHePjXCgKH9+F8QI1FYOfydAxrfPjvlasgxBbsO2uPckU3rorRJir1hVwQNKCTxjI2EMvxHMwLzO+D6GnrFPtlAoxCjPh5O7j56BAXcGTDgtR9fCTVWFpQFpD0gvVXPwhC8QHwfKfRIyonctp+1YOVcoM7zMJL+p02WVl2Zk4F5AoO7rm6142KPfRJINgFTj/0tg+WMBAcv2Dpx/5rCbIRgtDJJrO6hPlsO6l1kBOVAmaD1OSwUjYYE+/NGNQcWEvvPBFHQtTO0KI/U38Ld+H8s6xk0I0ph+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LHR1TMF7RnPBJKP58PdFFFmtsYveJ2teBIQQDxcTryY=;
 b=D5BMohQF5eO5MrHAQaOx756FuIu1qX0TDYi50zuVRnkqyjJtwbPapOCqg/Go6gggSTDXVIzWO8r6Hv8kJ07HAJJg6pDzgeStqibh2YiqS05RQ9nwgKbfGY8EuGEK0UJ7+ge1j4pf59m6BPjV6SpS52lUF1JieOOyuSJGRnEW9GwOSFHQhGR6k6EZwY6Kp/hFZOwfWGOoZm8PppN2xKVIUoZUPiSn102Vk9LyU7slmPujxsbxx08NsuRp6F5D8iq97zlZ9ngs/+aw+bPAx8D5fMuzB0zDZw86TtWbPJMLsPcxSG85KpSUgxYvizOsAaYYHu1EKJQWdXYCIBNoIGDweA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SN7PR12MB6813.namprd12.prod.outlook.com (2603:10b6:806:267::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Mon, 23 Mar
 2026 19:06:54 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Mon, 23 Mar 2026
 19:06:54 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [RFC PATCH 04/11] mm/huge_memory: remove file_thp_enabled() and its caller.
Date: Mon, 23 Mar 2026 15:06:37 -0400
Message-ID: <20260323190644.1714379-5-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260323190644.1714379-1-ziy@nvidia.com>
References: <20260323190644.1714379-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR04CA0006.namprd04.prod.outlook.com
 (2603:10b6:208:d4::19) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SN7PR12MB6813:EE_
X-MS-Office365-Filtering-Correlation-Id: f6bbf14d-e605-49d9-9698-08de890f58b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	VKkLhW7BshBjUn53ZwItXttGhgiyXmczVdF5GGxb1ePuBVJjjJCCt8fkrvYnzdC0JnB8IxlUkO4OEGSWXaw8UtbukIqPHkAtc0JqBOKklv/8f2YlkcBa3Iac9p4RpzLyKtaMgcL87INjXA89LRyRqM8fczhaeNNUPpP7IUJZ6lAJ0F3Wi0TeEhlPsQNUEoAgPqgHWrMhqUhFJdbLEzVUdI7h/thdE5NhQjGBm8EP8yD6VOBAdyaqd2xwA+TVs40HW7wWu53j3cuMN5hv+k483rrkacpYzdHtYiSopm+p+wH8wZA0iDaS5Olj5UfPKw3w355j+4TEdHqNhAtCOibsLaexq4XeVUSZopGIfi6E/Orw/d4mfcQGR9no/oC4y7hrRQCYbjwGmqgHgyC0utoTp9us9CcRVDZOvQKrBIRyfNCt4ETTH/l7wIvhtMZWzJWGmMFgJDucM3c0YsVj+sKeqfFDPdZWvCMU25Isx7s7DYMDEEEDYqGbmx2OreAbBDWwlUvRGN0naoNXWPDl7nC+JK3+sdWvTl6RtFj9jbt6vUx8umlUYECKZN/VzmUg2EhxOS54j7VFvZrRxmQMfh3QE8peyiROjVlF7RUOWTQdGj6TvOYSaurzYP1G68Jck6X5Rsnb5kOPmfMloXpvLJkwZLd2FvRxc8j9AvR0FZN3pYMttepFDe7YLZeLxTUKLNjHl66SbA+ej/gcT8SHj+joLacSSW+XpGVCrCDdneIPujs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iepoZgp7HUBP6bKnrv62JcLN/Z3IkcefkL7j+ycFSUCEnWXSuzxOgAihO4df?=
 =?us-ascii?Q?5UYQ+Ov5dDqQCRCRO7QCG5rwClklZ9rnnRS/3EfC4vb1qPou2B82LMgKbTLt?=
 =?us-ascii?Q?1fEDSKd0hl5gL04BT3Ese3dh/vFJxby51DyAfdt90jSbmem6JFtXMqrgaRJh?=
 =?us-ascii?Q?DHfmSpf+J6XWGYgUso3C9xQpr7ycwnxzwLZ1irNhSLv39sKanM5dzpHZG4jp?=
 =?us-ascii?Q?i+jpMPmEGzjyH3SMeDCSxsR7AOD9D/h1HINkox9v7O8d8oHunYvR9YkUnmMh?=
 =?us-ascii?Q?QTyCxWexciPz2+4m0vwFMrMsj/62syVFdXYA63nx8QfZafgHXoxnRyWwhKTr?=
 =?us-ascii?Q?jvPpsiu7mlHxFk+CgBJPW3VcqGfxUVF0didqE9nI+698kbJuFLoIna8+++Bv?=
 =?us-ascii?Q?DEuM6sUIgC1JesrSWCBMmPnSDyNSTR9UeEMkkbF9+z9gbaPDTttIcAKb/roe?=
 =?us-ascii?Q?zOG6SSCXxUd+gjevmm3i/vbSxziG497kybcV3fdrXrLWNE49/Dgz1xskAggC?=
 =?us-ascii?Q?N/+DX9WA74RKPfpRE6yC0iicBwH59eNmIYZHRG1LjapQK/FpGKLTBEc3t5c4?=
 =?us-ascii?Q?EbHio1d9FwW/3T9QRBas+bAe95YT4yLRgnQP27XBwBYLKC165scRddCIWJU1?=
 =?us-ascii?Q?QkKs5crcIgysE6f1zr/DNaUU+cUtY23KbO5RwgpzUd0tOcUi0PvO54bL74zz?=
 =?us-ascii?Q?DnsaYGx5A95SWDbu+/aCQ45TV+O/9zsKg6KosWAs0DWPK/qKoU0SLCBn39xV?=
 =?us-ascii?Q?GhgyzKP9ATt6U6wZUFdpIZhDt/UX23DrotNc92KbuRvVtUbxz+nqicZdpmoP?=
 =?us-ascii?Q?3R5o6C4O91c39Pk8ySTOhAc7BtOZcdZzXs1GHGEbezOgNHyV8tftbfBfxGdb?=
 =?us-ascii?Q?SydG7+rlDkDUjvim3VC8iP+XmI4NTV4PLGsJSFdY80X+hVAeuWOzgUYiGv+7?=
 =?us-ascii?Q?Uz6EtNQ/Q4mSxbtq45PIPf58y5cFmbhFCxPbDH4Va19lE1/yprAT7RQxP6dX?=
 =?us-ascii?Q?aZghYDtcOASfdlS+2ATXyz/n3y9k3MajgZZ+sDe1IAsw1aKf/VOkuZfrOjMn?=
 =?us-ascii?Q?lqMbgfp7zhW64vzSEF9GNbK7ehZfrdj3JwQf53JCu3eG0Ug5v8lJRfDXAT1p?=
 =?us-ascii?Q?cPODnk36yDwlx54mgpDVzPtMCcVdpbjLdy/Kj77jpsZc5oZrIL9yDsUmqq6b?=
 =?us-ascii?Q?nSV23oEd/JJqtVyqvMB1gjWBOYfYujhTo3knRz+LxudY19IFWaZSm47DSBDa?=
 =?us-ascii?Q?xrrccUt70QtSSC8otNNN9HVpsKQYSMtL3DWhbsJt4Rx6fypDfyvG6AY2aaV7?=
 =?us-ascii?Q?lqxJSt+YlXE+mDsZwEH8mWR4uZcbnyLLVMTT18fDBBu4F786HRuwnpH6mqaI?=
 =?us-ascii?Q?uoSMGcztLD1lt9GMaSPPpLK/GU1soahuwuV9/gpBVERLFnOG3oYT/koI5HLh?=
 =?us-ascii?Q?9pW2SByUL1CQStpzMC7b9WW5/hsuj4xCBUFpREGz6ZDZ9blQKIxdy/6xGusc?=
 =?us-ascii?Q?sN3tzlkch43TYxXdSShtmte7n8vU1OzNUbcJvyrIca28Q2C04+rSMS6zi6uB?=
 =?us-ascii?Q?GH3GvI0HmTymAWug/0ZOokTe96natQ1ObuRRrajfisTITVGDkAg1Jdpxdn9N?=
 =?us-ascii?Q?OBeBjP5h0mSOqOeBkdWvJ+M+4nqcoO+qq25lE+ofh8dlDkjTzfA+vMmsLJyz?=
 =?us-ascii?Q?07N2seP133RGuGvWsINIBuTq89FYigUta2VBoV/B6Psz0yLo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6bbf14d-e605-49d9-9698-08de890f58b0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 19:06:54.0173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vxYIHJhmOAE/bTtP70khXGFjwewncPRIawBR4j/L59pYDOxNQ0XmwaazcJruNGaJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6813
X-Rspamd-Server: rspam12
X-Stat-Signature: 96n54r63cqezrwp6d7kh81piyiocecpg
X-Rspamd-Queue-Id: D41084000A
X-Rspam-User: 
X-HE-Tag: 1774292829-871455
X-HE-Meta: U2FsdGVkX1+F8ZQSLpDHbmt+VDdlL/zh49XW3WwrIER+EaXqE4Lx1+wBZT3Dcch+HULEbKwBIfjVy/PG9O6dlEPMHQBijEe/ldJ+5Ni2CcO5G//MgDn7URj6DD5S3y731VwH2FMmR7FmPiTttvqyEJDuctKWMQj+389+FzuEQgx0ciCfa185MwL4ztFfH0upC1+BZe9388M64kNG2a0WQ6TFmSW6LlJHGeqMIl7x3Qgw1bGCObz589Q2DggUukpizUifL9mkgm16Ag+tD7H95KvFnotVauCDuevGnHtRubjq3qGGPCBmgxjgCYzuqGqjB9RXoFuKyGm8gXRyCQ6XMz42oBeFJM2UCHo2uT8bXLGev5bRpl+CndOYMyjmjLux9xqDTnrE6NCeMyQUCM/Vq6hq0rVoBOso/CfJkhzZa3cvzFpxiPBUqBoYHUb2Bb/RUs+Gs+uaZ1MizzXL54ytnqTrC5ogkz9IU2+JjBBFv3ovLLr09HbMkI2YX/mVXEYK+tacH5A6T+aPHngu6VhgFsIlwQlueTdzqhn7kIsrCPzS11lMvyLpJ0ZQYXqFAR5ZpOWL0MR7E7mtqMTs0a4K/rN/mfLXekZNgx9fHgMfMvFvYv/NJV3dAcSz0JeA/yGZ7g421jxFsWa0WU/NRRujVKmuTw9SjnS9fD2J9t3blEgpX/UBDkafY/wignbH/mrHTdEsXA8KCaEKLIY68tCa1RwlRlao4FDd+M38ysS6K+ug0XVgDySFfHo3f3cMXct+u0wWksD3vaTjzDAKkaTAWRCjxUor3HrAt7ON9GGV6++OOUfztbhwHcYdVqYTMabEYxUeG0RWev7qX5le02gjV7ss2hmDjVhPoiNSplUntULwQXAART0x5fyrubpwLrQuYHdruv/CgGowY3zgDwdMuelSbqvpsk/d51JgGoiH/pbnC21GHpp8XiPWKz5XecYCd1IEGy4Vnph1vnQRFg9
 PlfRDZgm
 Qikw2HYLJdjyf0qEQSPkhEwqGJipT1u+v9sLWe41FwN0sVASTwAO3IHJ2CKwaityBwIZBJXtlLC9oLwlwsvq6bfK0nGUJccRjCQgV0rmB2GmePd4Jcp/4rcFh1t41Oq/aD+u/SUiMTlNCHC+kT4GeWNjBqU6szG1rIN/66OtT5MprzafHBvYdfIDJyc/vBjSMabaV3WSwCJ8CLS8oo8/osiHut1Mj3Alrg3R1tFJotBSRssMxdU/1XlCSkjIJBtzjO0Rz32MhEKlHWivmqMw/wk7hZxCA8zj4TmQS1pQKG82Y3hzEotJz5E5n0KLa0ewAKwiSplOhOpc7mISrhHW88fHGMDTarMARmn1bQ1+dedkCY3S3BEAPfY9mwMOVNXnNipMM17qopju/DVU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It is used by no-long-exist READ_ONLY_THP_FOR_FS.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 54b3d21e4cbb..de4a1e6ce376 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -85,24 +85,6 @@ unsigned long huge_anon_orders_madvise __read_mostly;
 unsigned long huge_anon_orders_inherit __read_mostly;
 static bool anon_orders_configured __initdata;
 
-static inline bool file_thp_enabled(struct vm_area_struct *vma)
-{
-	struct inode *inode;
-
-	if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
-		return false;
-
-	if (!vma->vm_file)
-		return false;
-
-	inode = file_inode(vma->vm_file);
-
-	if (IS_ANON_FILE(inode))
-		return false;
-
-	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
-}
-
 /* If returns true, we are unable to access the VMA's folios. */
 static bool vma_is_special_huge(const struct vm_area_struct *vma)
 {
@@ -199,9 +181,6 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 		 */
 		if (((in_pf || smaps)) && vma->vm_ops->huge_fault)
 			return orders;
-		/* Only regular file is valid in collapse path */
-		if (((!in_pf || smaps)) && file_thp_enabled(vma))
-			return orders;
 		return 0;
 	}
 
-- 
2.43.0


