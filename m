Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 558D7C5516F
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 01:24:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AB536B008A; Sat,  1 Aug 2026 21:24:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 835E56B0092; Sat,  1 Aug 2026 21:24:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D5D36B0093; Sat,  1 Aug 2026 21:24:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 35C906B008A
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 21:24:36 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1EE2D40294
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 01:24:34 +0000 (UTC)
X-FDA: 85054584468.04.ECE4AB8
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012016.outbound.protection.outlook.com [40.107.209.16])
	by imf16.hostedemail.com (Postfix) with ESMTP id 37A90180006
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 01:24:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pztXLPe5;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.16 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785633871;
	b=e+v8my9o+YIA+KhyMUBWom94OSoVtAAoPKR7BhzgCAwtU4ejRgyP6i57U11xYFhNgEh277
	lvd+6L/OlhrWherQ3R1p5hUZNb3cR3O/8VqQFuR2zci10R1jhSPSpcAWNV2hIsRz5YIChQ
	pB7DBBJ3b1ta/3i+yAzDB5qqx9vNNVY=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pztXLPe5;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.16 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785633871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/dve184dRKBcdbil6sKtCHstimONll/8S0M0bj98lGU=;
	b=qWArhNCg80xrOO/NvrFypDQtKmAOlDvWCjwfUw7mXf5h1ESRC3dZqMuzKp27abPsfytcvV
	7um3wqvhEBpKreov28Zhxw03p6T4UD/oGXL4Yuwx0rpRoXLNyTvMY3nL4oQZ4fuOIDVFm3
	kwuh3LEkYaPwJfu4UcraMzJbcuxSt1Q=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XEVNIPKAqOIV9mPMnFjfnpvdbGwMTKWLPGO4LhReL0tHq6mHWSYYwVUOKL8Miz2KQabLfSzuwh7A6EMZiHGn3VvwqGf766VePfoiuI/g/oKJVDp9pZmVESwcX0NBOrgPCLgigBadgLDjXdjrnl/NFqOIAFnHso/2V1pps7CAPKCBj2G+T+Txmny9FXuRXGl5toLLV3EyvVtl63qwEf0+7AGS1fPJw5B+qJtJz7wXisSPJDvO54/BU3g56B4fSzJm5tnm7w0CD7d/jw7XkNolMG2OMszhjm4xZtyfEWqZ/G/wh6os5B81D5b7aphTRjP5lKp+3ke+PPDKPPb2r5MkUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/dve184dRKBcdbil6sKtCHstimONll/8S0M0bj98lGU=;
 b=IfsnNxhPaKZ4h/3EheHQka7tTyLaXbLejvGPfd0WdpLGo4KRkor9h/8i7l+AVoaUOiGNOWe4u9jQbEMX9fiyohSUz0RgVNKf+HdJ3sMRvCSw5w5glbmZo+Ig1AE3kWJQwmNG85/qvo6TICRoC5ROaA4l13JXfSLoUXrnISAoDPYaSWPRkhJ2KQQzSn9a4vOqGJkYonPji2IgGOaa0Q+DL0M1fPE1DZCK6UHxmFk9rzROT++LG+pRTZNbenlDrLRcd1B5RiCvx9KFTSrV8JRj/BYuor/Bx8OAk5d5q03WRIl67ZsPst+ch3Q++BuK5vSZHMG0dDRIBdpeyrV3uxAZIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/dve184dRKBcdbil6sKtCHstimONll/8S0M0bj98lGU=;
 b=pztXLPe5k9J0syXAUdpvNVHcnb2ztarvoesmwJ6WM/kxSKfqrt2MxPh46o9fw8cgcElsRWhqFZGP7oyorkoTByeuqciSZfFxc5Wtf1GhFsiUh2+bEIqrk8sqeNa6g32yhL48WgBy+Csd78vi4YiK5ay7GAdJwWJIwAKIKFkApzAnslJnEPfTqPdQfJXHyGEC7QWXvHj+f4nTRVDjmiXRWS6lZy8LHTzv3lGc7qWBKGWr/anfciJ635RHNjqEZDAM0bW+KK60Hwb2tzOQpK9l6ZJY2JNR5r/WkEgBBgLPZ/fnEd1G4rGAsRNNRJKX6rT8HHIw8IwznMLWwslBSw9EuQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH3PR12MB7497.namprd12.prod.outlook.com (2603:10b6:610:153::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.17; Sun, 2 Aug
 2026 01:24:23 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0270.016; Sun, 2 Aug 2026
 01:24:23 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 01 Aug 2026 21:24:18 -0400
Message-Id: <DKE2DI3F363X.EBNM12BH5C46@nvidia.com>
Subject: Re: [PATCH RFC 03/14] xen/grant-table: stop setting PG_private on
 pages for grant mapping
Cc: "David Hildenbrand" <david@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Muchun
 Song" <muchun.song@linux.dev>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry
 Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Gregory
 Price" <gourry@gourry.net>, "Ying Huang" <ying.huang@linux.alibaba.com>,
 "Alistair Popple" <apopple@nvidia.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel Butt"
 <shakeel.butt@linux.dev>, "Kairui Song" <kasong@tencent.com>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, "Juergen Gross"
 <jgross@suse.com>, "Stefano Stabellini" <sstabellini@kernel.org>,
 "Oleksandr Tyshchenko" <oleksandr_tyshchenko@epam.com>,
 <xen-devel@lists.xenproject.org>
To: "Usama Arif" <usama.arif@linux.dev>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260731-remove-pg_private-v1-3-142c97ba3562@nvidia.com>
 <20260801144223.1599317-1-usama.arif@linux.dev>
In-Reply-To: <20260801144223.1599317-1-usama.arif@linux.dev>
X-ClientProxiedBy: CY5P220CA0011.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:930:ed::14) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH3PR12MB7497:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b51436f-178d-4c7f-8d75-08def034c8d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|11063799006|4143699003|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	GTL9MuIyFml9pJZkxR0sjs63KiJ3J+8GxVms+5aX0KtiKCEf+rQ5nG4tkJfvp3E7quVqmCgj0IKvlia372YhviX9j8HIRIrDOeC0Mborl8eTLQbGn1CRGcDRGZhFwR22XgQrg5sTQsnzRabvETE68xcsgu3d+AU3hUrW3HFiGR6Id0BRsiXVuQ6jCnBqdGdkxkn0kVyAhXID7YiUAyij1VWUHcZ6so3tbtC9sS4et4CYdlgkCRdjVXQj/9A8T9YNMEHYGwoBm2DIttalgxf3TjLQQ1AAM/wDTQWLPJIV2FppBfOnu4ooyC8INrfddZUsretpTCxy/Lh+GTlYl8/+dnvhsPFphs1XEpg02TblypTdKLyiTdLSCIZ64VWaMsDyHab5IPJG35XWoBTHMwjQvc2ghW7iRXzzL6sr7P86amfCZWqiDEXUZRPtu8lO8na2Prg+C7v6KKXqxA4s3fStYA4C88zZT9oh5tzTJYcimKzqb5XFQYAiRaWVuT4HZwf+Pc97yTJy+DBiad86t86VWi5Cs9VSTNolGB7HE1S0cqE6/OSgT9rtJZCMfqaEqT6MAEZYxdLBvyfxYEMpASB3saK/wLtxieDYhZ+Ztd83KZOlzEM250hUXF63m3miyX1XvK3LhFRhgkjPPfBwtyf6UNh2ArldG9LlBh5OJeyt41Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(11063799006)(4143699003)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YStDN1BLV2tpdk9Kc0ZORFJCK1o4eVhZdDdzN2VrQ1o2RzdxUTFuTG9QMGJP?=
 =?utf-8?B?VHFUbVN2SFJOYmFmbEhURWM0QTlsSHRQRWtRRTAwdUphbjI4YlF1L20xcTda?=
 =?utf-8?B?bmwxb1NKSWYwSXRXdFRsRDk0b2twZEhYQkVZTU5pVExOZ0JwU0s3amtrWTd2?=
 =?utf-8?B?cVQ1UEZmbDM3Z3IzTVA2aWtOVVVxdzJDNG1QS1BrRFNUVUorTEhrYmtxWUlX?=
 =?utf-8?B?Ty8wa2VVM1hnOC9nVW9PRmgwOTJvRHdsMndXZkNKeDdSaUd1MjlmTTRLS29t?=
 =?utf-8?B?czlRYjZJM2tWaEQrMk92RktmbU5OSFBqQ2JSUk42T0FFcGhwN3ZPdWhybWY4?=
 =?utf-8?B?bmh5SklIRXJKME5ocVlyU2tHaWNJYjg2MWFYaUc2Kys4aUJMK1dMWW5KUzNs?=
 =?utf-8?B?NmxOcUZsK2orcFhrMEZYdE8ySWZXVGo2TGM5dkZsdmp3Ti83ZmpIVm80T0o4?=
 =?utf-8?B?MCtyWFlQaWNaMFk3ZEZsaXFkTVZ0Y0RCekx2STdHOEV5Mk5CeFQyRmxlS1VZ?=
 =?utf-8?B?Q0NycW1zUUM3MEptTXA1N2Y2K3p1U2dydWluZXNyQnVHZUUycEwzN2ovQVpp?=
 =?utf-8?B?REZHYWllRzBDOVRBTExlRmgySXdYUjdmYzZaMlJ1TTF6eUtidGQ5L1IxQmpr?=
 =?utf-8?B?NzgyZ1RqK1NKUGRPeHZJblRkNkpsN0NaZkV6TEJRQjFibHltTHlJOHptQVB2?=
 =?utf-8?B?SElhN1JIT2s0SkkrR3lpY1dQczJzVGk1T29XMEdKaUFJb0wwN0dTRzArTnlZ?=
 =?utf-8?B?a204TnkxcVNsaGNMbEhwbUxkbnIwU2k5U1JMZWNlZ1NudUxTQmQ0QkpJVmN4?=
 =?utf-8?B?a2tPK3ZTZHI3R1pXWkF3dkN2dWFpdDlFVjZDUWRxVG1xYUdtMithUXh1bXFD?=
 =?utf-8?B?Y1FIYlFZdVJSVmE4bEZoeGdLWmlvZlVkQTBNMjNQa3BHMExTZ2N2NmdiaWFn?=
 =?utf-8?B?RXF1MkE1K1ltSlVqZEZ5QzBNV0tWQVh1ekNFeVppNjRhTFZxUXQ3UC80OFVa?=
 =?utf-8?B?MGlQb3lJS2VUSTBiRXhSc0o0NG9sbHNrUENCTUVKU1dhUEtqSUtlY1MwVWtQ?=
 =?utf-8?B?U1ZlbjE5NVE1N201cHNGajk5eGxza2YzMmppNHRsMzN5OHVheHljNUlseWZU?=
 =?utf-8?B?RnEzS3FXRE5TV2pnMnovQ05qc3ZWaDluUmhYVktBSGxpOG5Bai9jZHRuRTVQ?=
 =?utf-8?B?UURib2c1VGRiNG1hdE9vNzgzMVJvdnd3TTFGd0I5TG9hR0hPenBoTUo2OWh4?=
 =?utf-8?B?V3hmTHpzVlc5WmdFQlpKZkNjbGE4MERyRlg0TDh2bGkyNlR2a0FkQjZqZ2k0?=
 =?utf-8?B?eWltM1NSbEZTWGRObFk2QWxrdytxOG43ZENESkRiUmVSWkdQNlBZK1hHamJG?=
 =?utf-8?B?SlhWRG0wdXJ0aTJ3eUdKT0cxSVFVanFKRGlOb1ozaTVmVUtYREcvbnFUL210?=
 =?utf-8?B?SmhhOHdrdUZqOXRoWnNDOVAyVmtUTng2cEFSNVprQzRBeGp2RTl5VVFEWW91?=
 =?utf-8?B?ZmZUTlV3Zk9DaW9JYlBwa3krUzc2N1U2VVFpYkVQRGVOM1k0TkFOMy9RY1FU?=
 =?utf-8?B?Tmp4M3lUN0NEUXZQWCt4YUxsZXhNYm9ucjdkclBHY1V3M0pqYkFST3VKbHdq?=
 =?utf-8?B?dUJEU2s2aHU3akEwVVhUemloVzg0R05SYUx0LzExdzIwdmd3WUdHUnZjVE5E?=
 =?utf-8?B?UVhIT2pObmhvZGhmMFpMVDBsWWptTzhZd0VyeWpJd0xlcDllV3k1NG1rRElS?=
 =?utf-8?B?T0dyMmVwaXJNbEhlNlhNUUxuV0dEMVg1OWR6K2thRmFIV1dlSDJEVm93R2o0?=
 =?utf-8?B?ZDkvSTJUL0lwemFuTU9TRFN1MGY1ejdlUkxPdzRwS3gxZnZLSlBZNjFsR3k2?=
 =?utf-8?B?bmlUL1A3WEFPa3E4U0VHQlhRTVFxYTkyeTliUEFqdjBUT0ZrOUVLVUVtT2N1?=
 =?utf-8?B?ajFHakF0SWxKalE3dHZSUCtjNm0zOGhYWStZMk8yc0NWUERYZWlUMEZRd1lu?=
 =?utf-8?B?MWJ2b2xTS1YyTkhHaDdQZHR2eXdaK2M4Y3RYRzdYYWZoaFZveEw4cFIrUE4z?=
 =?utf-8?B?RWdkbkRJUTJWSVdEL1I2SHJPSjJMbnNyVkE0Q0RJRndjOGFTekNTWERzZjU2?=
 =?utf-8?B?eWwxVzhKcVFCNnZmRUY1VHNFV3c4Y3BBMzZsVU1nczFpQ3hGYnNCZmlUMU16?=
 =?utf-8?B?ZnBzRldxbVJ1ZmxVT0pSNHpadHRzVHRJWFAvSWhVUVZhcHdCSkpJb29sOUYr?=
 =?utf-8?B?SEFTN1VzNDM0ZlorVCtoSXZhMkhQQXpZT0kyT2dkckhaVEFudmRXVjF5K3hV?=
 =?utf-8?Q?5vUglnHOG7PTctab9d?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b51436f-178d-4c7f-8d75-08def034c8d1
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2026 01:24:23.2424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3PUHSVb9kPk6/DlsZk4L3x3wkLtYhelcslgc595NElzHQWP4c3rG3dXU7IPovngI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7497
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 37A90180006
X-Stat-Signature: qunp76zyrqgmo8pjfkd79e3q9afdboop
X-Rspam-User: 
X-HE-Tag: 1785633871-72227
X-HE-Meta: U2FsdGVkX18zo+vjlu3gixBsqqhY/h+z+gXL/KI9OJubfk2YLe2iv5SAP+GV/6gzUhVOXNK+1mdPTu/s3p8OX/59u04l3p6vmUawQ0xv5Gr8J+4XpmpRGWDx+YBpm0cYBeiAPfowWlZ65vG+e0lNuN0aHQARMCPefOCMfHBU5uwbFoeLDMknWo9hCbmo1mSEK60D0619KSYhmXRBoHWLNQyyHcVUwDDxU+QceH+ex4SA83u37AyBfGeFNsGeFD7f8qS7ecN+ybBzGVhFfVAM79QVc5JryYU8CR4UY2ZPqaNppjLs+1sHzIrwVJYuZqEodvt4Xtzzk6NLgTXUfZ0gw1c6sEaHHNMCAXQZ4OUJ5rGoP4WoULzAKQ7nK0JzqWHfW7ClCDeEgOzcyW2ng9ZsNwvx7njWn1gg7IxjW6GYPktWrNn2j5SG0XI54AgiRyJ16j/F+5fZML9/e+V0Kn2XHrvDan4CVGpasT81kfeCWqw2ZYa+/CFJiuXow+TE0cuyPds/jHmZi+kcBTdbxW9SUy0W5XR/0joBNzRyhFuiXqG2tYNn1z8Ft7OVzg9OWqPBFCH7aBheiIZvIP9ZbBDcL4VNHjVdzTfGkAkzdBu+bbI7wbu+TpV7tx/nEZGjCtFks2cHLdohfy3OmjYsX/BTk7tr/tjkeJQ5Y2mG7MW0xm6VJwKTh4b4YfHj53bg8LrKPxBdqWtR4IHh2CW/gb352eaVCBifGeI2q6TdOgKKAYRbzWTvPKdVLDuTrgvAGWc3YV6aVya2jlvqMDVZH3+rf1LRPkDU/NKJuqr6Pq1iW3e9E1xBs35oBF2qJ6JGvO2Jz0dVr9kq9tGADJpbTtEuvvShgbTDcz9H/cPM8hjRE1BRP64ZbnC/BD+E+5RRPMHCxdt9GDeUuUFMwzzXnPJ+/775a8PE7yOJCZ24vh8JnRe3uWk5BIMj4WeLFSyGYKEhsj4/exyahboJ+tqgcmk
 N1HYNX/d
 NmqmxlTBWYRfsnjILoix/BbvSXKte4lV73pbWdtMuumWVLZ+iPT5XqqgWcQkd5Mnr5aLgpC1Ewu2PrsPNKRs8f0SzLve55HaI/dMN4vysw9F/FU4k3xC3JNU215LwGI5L2raDdbdRVKrZYu5lxllEOxFn6vgc+xQab1/8BTkjJ0HYdrIGJAkPKVo4ZPMQ8QyJKFRfls1WbGsHlrB+V1JnqDRquL9NDdEfGxUXuF1AXng/CcjkMjszPHUFCDdB319EpuvdlmpqDcwiqfbs4CMgYW+sK1vAhoJqOIfF4PMajPw0oWKqEK7enW1qXXiQr8HSbMFX5Wyqt3yFjAQtR8ZnSQtKBitXUNG0DuDF9+uH7F4xROL13hm65zjsi3D5yr2VNgQzazIauRsibE7v+9tylWGPAy7g9KtU13EEkXTqUp8KYmd2XU94F5t3M/SEEdJBpOAckPb3XP5ZzYngutfGwLd/g8zjWJAKD/Ff6vBGJ2B2hqEj0AG4blpN80yzg/NSXjZRFKQ7eGvcXsz5oqKptrY+8BlfhXn0S+ARRxoGc96ZMv9yPrThM66+3+tThQSdbvHjAW4AYM8b6l9VVWFB6JJkPVZh3V6qJLiYfsBLIWh8Zzc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat Aug 1, 2026 at 10:42 AM EDT, Usama Arif wrote:
> On Fri, 31 Jul 2026 22:13:26 -0400 Zi Yan <ziy@nvidia.com> wrote:
>
>> gnttab_alloc_pages() stores xen_page_foreign in allocated page->private.
>
> in allocated page->private "for 32-bit only".

I will remove "allocated" in the sentence. That should cover both 32-bit
and 64-bit cases.

>
>> On 32-bit, a pointer to xen_page_foreign is stored; on 64-bit,
>> xen_page_foreign is stored inline. Checking page->private !=3D NULL is e=
nough
>> to tell whether a xen_page_foreign needs to be freed on 32-bit and
>> page->private is zeroed unconditionally on 64-bit.
>>=20
>> It prepares for a future commit that remove PG_private.
>>=20
>> No funtional change intended.
>>=20
>> Assisted-by: Claude:claude-opus-4-8
>> Assisted-by: Codex:gpt-5
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> To: Juergen Gross <jgross@suse.com>
>> To: Stefano Stabellini <sstabellini@kernel.org>
>> Cc: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
>> Cc: xen-devel@lists.xenproject.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>  drivers/xen/balloon.c     | 5 +++++
>>  drivers/xen/grant-table.c | 7 +++----
>>  2 files changed, 8 insertions(+), 4 deletions(-)
>>=20
>> diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
>> index e7f1d4ca6d753..7f47b0ad05607 100644
>> --- a/drivers/xen/balloon.c
>> +++ b/drivers/xen/balloon.c
>> @@ -182,6 +182,11 @@ static struct page *balloon_retrieve(bool require_l=
owmem)
>> =20
>>  	__ClearPageOffline(page);
>>  	dec_node_page_state(page, NR_BALLOON_PAGES);
>> +	/*
>> +	 * clear page->private before giving it out, since it might be used to
>> +	 * store xen_page_foreign info.
>> +	 */
>> +	set_page_private(page, 0);
>> =20
>>  	return page;
>>  }
>> diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
>> index 35f879dc5dfb8..cc348ba2e0786 100644
>> --- a/drivers/xen/grant-table.c
>> +++ b/drivers/xen/grant-table.c
>> @@ -875,7 +875,7 @@ int gnttab_pages_set_private(int nr_pages, struct pa=
ge **pages)
>> =20
>>  		set_page_private(pages[i], (unsigned long)foreign);
>>  #endif
>> -		SetPagePrivate(pages[i]);
>> +		/* Data is stored in page->private on 64-bit */
>
> On 64-bit arch you just iterate an empty for loop. Cleaner to put the
> whole for loop in ifdef?

Sure. Will do that.
>
>>  	}
>> =20
>>  	return 0;
>> @@ -1031,12 +1031,11 @@ void gnttab_pages_clear_private(int nr_pages, st=
ruct page **pages)
>>  	int i;
>> =20
>>  	for (i =3D 0; i < nr_pages; i++) {
>> -		if (PagePrivate(pages[i])) {
>>  #if BITS_PER_LONG < 64
>> +		if (page_private(pages[i]))
>>  			kfree((void *)page_private(pages[i]));
>>  #endif
>> -			ClearPagePrivate(pages[i]);
>> -		}
>> +		set_page_private(pages[i], 0);
>>  	}
>>  }
>>  EXPORT_SYMBOL_GPL(gnttab_pages_clear_private);
>>=20
>> --=20
>> 2.53.0
>>=20
>>=20




--=20
Best Regards,
Yan, Zi


