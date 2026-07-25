Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81153C531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 21:05:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C1436B00B7; Sat, 25 Jul 2026 17:05:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 671AB6B00B8; Sat, 25 Jul 2026 17:05:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 539D16B00B9; Sat, 25 Jul 2026 17:05:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2819E6B00B7
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:05:11 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A1A4CC0371
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:05:10 +0000 (UTC)
X-FDA: 85028529180.11.2A9843D
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011012.outbound.protection.outlook.com [40.107.208.12])
	by imf04.hostedemail.com (Postfix) with ESMTP id C094A4000C
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:05:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=sM0oaQqs;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785013508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xTb0ZX6sMZbCYVFxjPpNd4DR8hD1l4SGa9oEf+cR8y8=;
	b=O5upLoNwQO91CUwTnlihwrL4OOckB2ydSLVj1OhKWSLI9lWo2GZX6s7QxloyELar37Ccav
	6PMhC9IPPZwcRPwDsq+ncufhlue92rodMTyBccnWxczNCDM3u9XhEYg7R1uM4uIjpu2fLN
	iFrEKEwPVy4Sozh0JJPfV6Ckc8mxxcQ=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=sM0oaQqs;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785013508;
	b=G/ZAAlcx8Rc44Swxhn0XcG9Jau00jwflMGZ1wsZzHBn4xUYESGahMpNyOL5C7wucEcl80v
	JFfeBrc+m238G1YnzHwVnsN4JVxPTTflukQ43iy7dtiKgbFQgz90oBCm3iUxH+6SGJeD1V
	u2BT0aiJDS5JSWc1WOVj/G0UD2ND9Fk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JYmUMFqf7xDWoCFKNcQ7+Xa02TABGvnjODG+joAOq0/0emRzFDLQOQ9fz4LfpmYJZoM5E+0JjEhV/hySZNCSETqYlL0O9N5OfgI2PzbIeeV+n17mzoysb8ok8WvMVQqeLmGvbN3QUG6EJIpJnP9QETPbfaqI5n90WCaLoYRYMeDi1anCVOHIGdKph3CryhMyo4luXByMajwGprdkMsVpTz4vL8QtmVCzTwpzx4dv2yKGdJ3NE1YDBPL++FTRD3IuNi+C0sEP6lwv8fQOB+lNQRuNQHVxiTo07kXVr3YlL9kdxLnOS5RuBlHeXmO9XiUKWJRBtYpKQnV1Z/jlA3a/cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xTb0ZX6sMZbCYVFxjPpNd4DR8hD1l4SGa9oEf+cR8y8=;
 b=EVi89jIk80gBgqNXAR11AJgqJnzAFMktSXMJ0FPjZknlRwH1FQWEZMY0+HSWEl/5CABbgzSm2+ZEADII80Q8e0bc/CRly3YdYFqvzCBKjX7EWzxdx2SwWgqPPCphGc39Ew4kESA7xM+hyL2nZZhDl2JKHPsMZm/t802dTtHe458l9HYauW5uC/pxy2cFIRs+/D/9Oy4Aj/PjNKs8NxuA4YDgFd0jT5eJP7gRLvQGmDFBvdHfICxxZpd7ThLYiTr6ROJs9ssU7N3MrHsmDHXvdhRfwpXP1ontSIMwsUUXRp1iU/8QnGToQkYkiiAGYhWexgIis/y2wx7HgsO7+43qCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xTb0ZX6sMZbCYVFxjPpNd4DR8hD1l4SGa9oEf+cR8y8=;
 b=sM0oaQqsA1NgR8SZ7PbqOO3guThZerUds/IQqzTkVTluGKETKWIaPJG3w10L1qUPoY7aLrDLGiz+1owFoLR1Tcrgz15aeNWiXWVxY7tof0yZISbw5MKrpcdA/gutXntx1E+FcUkbDHACmZhTaJox3xomQNmBYutd53mkGPMrcrEklDvfGqTIELvgQ9ZQmtMbrcOOYSkYyIJFBfNPLcbPlQoTbeM+dM45OX+trZHuavssbaDzf1y4zHMyUHrbJBn5YHlvDMYRd4jRbS00BYEsNIN6IhKqz9u/DPR8ZwTJneswcJjic7zcA9/ZNi3X97uf3kgj+6BddLveJxe6aAbSNg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ2PR12MB8135.namprd12.prod.outlook.com (2603:10b6:a03:4f3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.12; Sat, 25 Jul
 2026 21:05:03 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0245.012; Sat, 25 Jul 2026
 21:05:02 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 25 Jul 2026 17:05:00 -0400
Message-Id: <DK7YH5O0FS58.3OTH04TI72U0Q@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v2] mm/migrate_device: Clear stale mapping after freeing
 swapcache
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
 <byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
 <apopple@nvidia.com>, "Balbir Singh" <balbirs@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Arvind Yadav" <arvind.yadav@intel.com>
X-Mailer: aerc 0.21.0
References: <20260724082702.2531024-1-arvind.yadav@intel.com>
 <20260724214307.a50ed52cf78fdc73bc42f9bf@linux-foundation.org>
 <2b2fe98d-1a7b-4aef-a1ff-0fbe43339180@kernel.org>
In-Reply-To: <2b2fe98d-1a7b-4aef-a1ff-0fbe43339180@kernel.org>
X-ClientProxiedBy: YQBPR0101CA0272.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:68::13) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ2PR12MB8135:EE_
X-MS-Office365-Filtering-Correlation-Id: 6afe3135-916b-4740-5539-08deea9064e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|4143699003|56012099006|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	IdWSJapSe0/BrLYFOem4uLOudk8H/gV8f7EPiOwhu0YVeqsJ3vkEY/oTrkHkGKW1lLjO4jI8iWSIRAQcypwnDGyPaqFB4g0QiAHypBD8NXQIVqt34l52VcfSXRHwSuwuKSGpP4H4HCutDRZOKSe9oMZ8hJXcln5jHryYFzEWATHrTVWV6jms20clM06ngHL0+WjdBRBHzU3WxKN47dzbFUP7gzthudJDeqrnN0XpQYFaHR9wjfj+B+rqFVFfEw1eMwNqLQvrsjc3zZUF+JjmsSlVp6Tc0k3TqXpQK+Z1wbkMTEGFdS8tGAXB6q635Qk/AD1PQ4IqdkiHAHX0hmlJhz+2S751pAXCcVEqsVjPwikd58w3CEYUUawEaR0Mi709TwoMfp6cbCJRnVe2czJIJo5+RAfqxXq1F3oAwv3PgHhO0FFJWjCrRNgSYSuONAJ/m/GqQgD5jun4KLTEgfJy/diLjXAl4k2Y+FD2fFASyoHqrjG4zxVpG9RQt+9MPaFQU4bWT2dfZYzzGS/wNPejdGYo9JeOsQWGVW2YL1+EPypM3FhIMc618yR918d0MbSKGcwebXnHfq3X1dtvD9WsFAeSiOLzOU7tVQYk4UiQ9ZzVdYiwYQPIObXAiQJ8thEauaivoFElVN6kasGfywQbJZhAJgKgoNb6QpFRGrXjymY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(4143699003)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Ti9QQTlQenlOSGlEbW1FQXpRTmxYWXpwSC9oLy9tZTlQRlVocVBXeFMvSUgx?=
 =?utf-8?B?VUR0TzNSK253R1pUYjdiRnkveXpDM0hUUUQyN241b3lzdFQybk10dy9SVm5V?=
 =?utf-8?B?UDhVS3dIdkRKc0x4VWpJRlRYZ0JsRmFrc241K0Vsbk9iVW11OG1UUktVYVpz?=
 =?utf-8?B?OXBadTJ3WVBFN3dMbUY2WktmNGF1WXFEbWV6MThvTmlLczVvaVp5Qmh3V3lO?=
 =?utf-8?B?K1k0WW5LMVZvMmxBUW9VaUN6YmZ5V1J4MnBrZnVack8vR1pzaCsrajVMalVv?=
 =?utf-8?B?aXRDNUFFeXRrMEU1VXRBOEQrQW8wclJGb3VrN1daZ2NWNENqQzZmVlZxc3U4?=
 =?utf-8?B?d1RHRm90ZUlWb295UDZ2WStTWVBycTJVMDlSVVlpakQzUkQ4MTZVQTV0ZzJ0?=
 =?utf-8?B?dno4QktzWVdIRnoxSEhGdmpsVDN2U2NRM0hLdml2TnV6N0ljY3JSZnd6TjU2?=
 =?utf-8?B?OGplQUZwVXZIQ0dTWmJVNEtocUIySUZmTG03WktEQkdXb2d5bEd6Z0t6SXo2?=
 =?utf-8?B?cWxEci9tWVJ3KzhQazU3UHp4aFk0bUcrY0xVL3haM0wzVXcwSkNHSXFjaDFF?=
 =?utf-8?B?bVhudkhLTWZ6VEJWNzV6VEwwZjkrS1A0eDQ3dGozbDhSbkJqTlg2R2F6TTlj?=
 =?utf-8?B?SHRZazJ0MUZQK0U2czlVRUt3a0QwV3RuL3BzckhENk9oUGN5SlhhS2JqTXln?=
 =?utf-8?B?YlVVVkJOSXdKYjBjdjI4ajlwUGM0Y2VUeHlOcXJwSFRwZ1JhSWdjNlV0N3hX?=
 =?utf-8?B?Umw3UnR1T3VsM2syZStjYmwyWVhHekluMWJxSzJvci9adXpsVmI1NFc0bGwx?=
 =?utf-8?B?aVNRKzBBZmdCOStkbFQwaTRrcEwxYXU5ZCtNTUwxMGgvOENaeWgwWkFEd3ds?=
 =?utf-8?B?cUpRZ3FvUWlnNnJhbnpxVWp6Rk93Z2syOWt3YWJheHArRE9LK3RkS095anZ6?=
 =?utf-8?B?RVNUSVp0UWJWdkpkVnZoZDJxRHN4MitnZEo0czdXVFdaMWg5TTV0VWNXdmtq?=
 =?utf-8?B?dVoyMkwyTThadVltN1FOTUtZRmhSK0hBdWFmMmhQYU5uK21nd0lJMExhT2lh?=
 =?utf-8?B?OWdsWWJ5NlNRakdPekpUN201YVVIVDh1TEt4NFZHdTM0NGw3Ynk0SEFvdUlo?=
 =?utf-8?B?RVJHdG42bDJmekVaWmw3cWdZT05IRlhtQjQ2dWsyclJFTU1vSUIyeWpvb24w?=
 =?utf-8?B?cUVqTUdWeFp1aTN4UEJySkNkcXVoa0JxQ1ZxZU5uRW1xczh2VUNRckZSVkNW?=
 =?utf-8?B?d0l1bXNiQ0dzSGlFemd5Y3ZmTTZTYWVSRUpTUkc4bmFSalpzK3hsWlZWbk5Y?=
 =?utf-8?B?alkrZmtwM2s4SEM0ZXVQZ2kvYUh4M2VPWmhxT291cDNkK29xN0hiL0FmQ2Zl?=
 =?utf-8?B?dlAwaWJNV1ZBTEdYV3JtZUZadlZ2WnVVN3JOMkE1R1Z2RFJvWnJWdjZtcTVh?=
 =?utf-8?B?cG5yeEg3WUU4a3NoSERaU1h6OVloQzYwVFhEeW52UUlnT01nUnNFdlM2UlY2?=
 =?utf-8?B?Vm9KOUEyR0xPTGNGNXNNN1AwVXlHdzhMN2NNS3JGU2tYOGpWQ0EyYUthUS9D?=
 =?utf-8?B?bStQbDd3aFlCeEpmaGY2THFONUZmbEpwRXpaL0pVOFJkbndxRzJXemFwT0VY?=
 =?utf-8?B?RFltRDIxVS9OZGFzMi9FZnh3VlNOLzhmcTFkaGp2MFFpYWpiUVBIb1IwWWlr?=
 =?utf-8?B?dU5Ua3NFUGxIaWlaTFZrbHhrZUl0UG1HdzUxWExUTEFYYU5ndFBuZE1Lbk9x?=
 =?utf-8?B?dXhFNmFQKzBuRXoySlQ4dEdGakJVOFg4TkRrKytVZkNNZnhwdGVaTzVjc3Ba?=
 =?utf-8?B?QnhwVXkrOExHa2w5M2VGcG5HOTY0WGIyTk00LzZoQksyWEVqV2EzaDNKM1lo?=
 =?utf-8?B?ejMvTndKRDJwVVNUcllsNXNnbGp3ai9RWTc0aFNGTEVMbkpPb2k5V0FBTFhU?=
 =?utf-8?B?cEdJUnRiMTk4Nk1zUmRlNEhRZGp1SUR4bFNqWmlSQ2JYY1lTb255UHJ0czhJ?=
 =?utf-8?B?enFaZlRwaERTaDVoVXJjeE0xbzZXQ0lrMktiMCtkZGNLSXNoek5Sbk5KVGhp?=
 =?utf-8?B?UjFMYkVvb25wdk52NmJBc3lvT3VtZ0h2RzFUQ3pLVFBEc2NRRmU4bGorWEUy?=
 =?utf-8?B?NFZwaW9LNEc2NFQ0b2FNR2xuNTFUZWp2UVdibVA3TWVOUUx0elBuS2pkUlhW?=
 =?utf-8?B?RGJFeHVza3BsRDdVVXBxTVFKdzZoTmNINElLTlFZS3JrdGZpbXVDVDdnZndB?=
 =?utf-8?B?VHZ6SGd6eVJlZjdtQ3lnVmw3cGpkaGk4R2RDUmNwNENqditGaGFlUnJBVU9P?=
 =?utf-8?Q?P/XnLngl5saeDR+e9W?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6afe3135-916b-4740-5539-08deea9064e4
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2026 21:05:02.3185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WA/pgfZvOteYRrF1MmbpccqFkFaE27JmOPY+/L4qgk3fwmbrEV56QI4fQCIAE27B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8135
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C094A4000C
X-Rspam-User: 
X-Stat-Signature: 6wqjr3tmyopn7qwsffjix6xxdui34ptz
X-HE-Tag: 1785013507-960340
X-HE-Meta: U2FsdGVkX18p9fWmgJ8xFeChPlg9uAcbQnn1WlemjRM6Yx/kSDcEx99A8bu4uZRH4LKr2cvwxUUECrBtMTTjd66PJaD0uB/ZOzw/XsqboKEwHApbxDyqaaf0aRkbFFYAKO94Z6aR1wwigv143MZ7zI8+L3Utqopp5PQ8ClXO6sEfRkGQZicpOTyBiigUTmqBJM2LXUsqLsFaNp1GmOZ3CBBrHrOyShzecH92s5Ba48ninfcNJinf6uQkDPuyoLzPo8iWJf/aVxUhekTS8n7Z+Tr1/j7r5aWD+JWkxkLCfMnC98Dq7daBA7j5yGflALlngFC3iirntDcpehnKrg7Xcz1L4cCYmalZepsxafOrtAJyrEhxdLrxzCKqRH/f4qzGjJQ7EdQQs683Vy6AphFW8QhzhmrFqCgsUE3lUXdfWIm9hRFjTHZo3nEEzVi6gNGG0stB6mvsatBOLLrqDDVScr1rha6V6cgAPJUsJT3/6vOaX9P1c4U7qyJMU5g+zi0gaOus5rziyYC070m63G/7mrUvwcvbzCOwtRgcSimbQFdO9VQrULuAIgr6FeXWwYCQcl5NTQMFU78L0Iy9djvjqT5b12hZqwiovHYIo40RfpHAPqXHBdO+Re0cuTKAiAgQV71WE8CoknvYpd3eORR1b41D2qCre5JOaIaJpyyCgVVjGCKpF8QSNiaVzD2Kmpu4fleCZxwgvdZxyJ6Vc2MJNi+fpu6vFRl/xAeHk33d5CjesAbmlF3MTKGXbt/NKlU71ryRhiDAmnKtNZGF6o6bzm9ee4F3HWkSusIYpSiV6CNEpRNPbdHNd08dy3IJQCnfptWVOC9GNcmc+N1Z1YG5p7zbxmlsvnoTiAUNLjeVWk3Fy/NH0J4HF1k1Bce8n2+ncXHLbJV2pEB/fx81IcqIvp77Pl2cllvAajaRrauLAm0RNR/3OhhVEN4jHKASBdngpijuasQK1h2Wx7l3uGY
 E5AuDM3n
 IwzmJUpjlvluy6qX0ANlt09mY4Ohpvy0/bAXGiyXvjhjZItb+r/Uee6+vFp3GnB5BMvNUPk/kWlw6Ey0cgr1Rdwvwv0CHjOAHGQ4ZB2AwAd0BQxScHMkyLDhfU6xStBHzxpiLGTi/wa6gH7nhQ1pVKVFja0F1+k/QWQkWCl0JqbuLDL2ZQmzAIKjQSsormKqv5474fI54ndxEEUqegbGrgrNpEAV9OKd4DQOe/NAPUsrLO2Rnj1P7JPsj/705FjwGRtsaFZsH8uBlXftSmpr+SkJLSoxSK/IGnCSGa3iKOKnEwVd9j0qPftgMkg/KBlad8P6HkhBo3jqbEr98h9UJkbRyWZFydc/uuvOX7klxo6+aq2iqm5NOHL17XC+I0d9Zl9fkK4oLlU5FLRaehDTVW984YJyLXgQN8/3iNHg3GO57Jr2qUSdWqUUNLx+QB6t5EcNuX9GbLkq5imsIGGuyjgPJgVrg1jzhO3XcbJAOrRXRNeECRcGjyjFYk/AhcT7wb/frAQa2S0a/biTtLNrwIUOLYlBlJye02g3EQKUGxOFNMe2t+MS/bmR7S+s4OubzGciGq2wcd4cyZWs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat Jul 25, 2026 at 3:36 PM EDT, David Hildenbrand (Arm) wrote:
> On 7/25/26 06:43, Andrew Morton wrote:
>> On Fri, 24 Jul 2026 13:57:02 +0530 Arvind Yadav <arvind.yadav@intel.com>=
 wrote:
>>=20
>>> __migrate_device_pages() reads the folio mapping before calling
>>> folio_free_swap(). When folio_free_swap() succeeds, the folio is remove=
d
>>> from the swap cache, but the saved mapping still points to swap_space.
>>>
>>> Passing the stale mapping to folio_migrate_mapping() makes it take the
>>> mapped-folio path after the swapcache reference has been dropped. This =
can
>>> cause an invalid swap_space lock access followed by a folio reference
>>> count BUG.
>>>
>>> Refresh the saved mapping after folio_free_swap() so the current folio
>>> state is used during migration.
>>>
>>=20
>> Thanks.  AI review might have found an issue with this.  And one
>> possible pre-existing issue in the code which Alistair and Balbir
>> worked on.
>>=20
>> 	https://sashiko.dev/#/patchset/20260724082702.2531024-1-arvind.yadav@in=
tel.com
>
> Yeah, this might need another careful look.

It seems that the pre-existing issue can be fixed by resetting nr to 1
after split is successful. It should also complete this patch. Something
like this:


diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 18d097c388530..4a77b6c86ae4f 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -1193,6 +1193,11 @@ static void __migrate_device_pages(unsigned long *sr=
c_pfns,
 							 MIGRATE_PFN_COMPOUND);
 					goto next;
 				}
+				/*
+				 * reset nr so that only first after-split folio
+				 * is processed below
+				 */
+				nr =3D 1;
 			} else if ((src_pfns[i] & MIGRATE_PFN_MIGRATE) &&
 				(dst_pfns[i] & MIGRATE_PFN_COMPOUND) &&
 				!(src_pfns[i] & MIGRATE_PFN_COMPOUND)) {


--=20
Best Regards,
Yan, Zi


