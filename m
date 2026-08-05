Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90724C561E6
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 15:31:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 598046B0088; Wed,  5 Aug 2026 11:31:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 548AA6B0092; Wed,  5 Aug 2026 11:31:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 463EF6B0088; Wed,  5 Aug 2026 11:31:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1B28A6B0088
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:31:37 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7EC59A0515
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 15:31:36 +0000 (UTC)
X-FDA: 85067605392.06.5E7F91E
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010029.outbound.protection.outlook.com [52.101.85.29])
	by imf06.hostedemail.com (Postfix) with ESMTP id 867D4180008
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 15:31:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=X0vAxUUL;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785943893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fgQcfCYiQTWT2t8vRSz0AaxD3ZlYNErg96xus7HzkRQ=;
	b=qZlZ7BxPKWRurcd0Febje2B+wHuqTkbZdQ9fFUUnL5pTxOcnfZy8c+e03CsXkT9NHPf2Rt
	u2EYgPhD5bqDBASnavbIYR9qHTckVZFDQu86WaSZ2CFmdroC8CV4c8WuHWhLtQpEn//ZS9
	J+HAWfis+lRuYtGGUjMYReO6JYrw8Zg=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=X0vAxUUL;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785943893;
	b=aIZUKcedBbTr7GcwU+5+t/w3/1H5zglu0xijAhR8qFtHJoaZvnwmbXLpX/xpVXyWriQ/ap
	DTk3sh1tDewgGsySNGDTe947pKCEJMbswgLCn/OV4w8gEyTrGDolYxh7010eeBDMyYNryx
	ARowG5EzcBUg4uJDu+Sk6V5TYw6Mw6E=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nacN28NIz4F41dGVdah+wKdjEeZfE6uMQ9IXsuULc7JJRLsllToA1jD/K2vpDYPrk1Y92HUc+t/eI+hv0RKHqatgXnuV/OFI9+N2q5EQw0WbKIdlK5+r9RrVf9zriGfnYiG5zEg4+5oqsSCWA9cmMRnE58JrSzMI1JP5zVWWI86MX9NgDqIoqwVSkE8amyAtj/Dg+Kdos6f0QeoRenDYPnF605IYgUGfh50L5lCfrCBLYxj2dxiEd3+DG6mkk41z9RJPVyrl4jOZXkqSUBgnwtfCJihOOVA6Z1hq4n56R5EAmN90Wr5erlGgMzMapiDewHYh/B2mEVhGOcltZ0dMSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fgQcfCYiQTWT2t8vRSz0AaxD3ZlYNErg96xus7HzkRQ=;
 b=HG1VDtGY36+YjpzY1O4Q8wQsfbZERCikN+rBmT5PmbCGjAFml14csE+c7vFEWHfTabndAJMtmLE3izD+LbrlyyHtx6Mbj9OXcvnXdevLj/njJnFx0xbKzywu+ZfRCFoSK3qiBpCJ2dz0fdm0GHty3EyKKZdSI3b0XBCuY5KUbWEoLoE6+qYR5YBFsxTYP3LQf09vmY3S1TEJ5WmHTEFbnwrgEGlLe3C+WXXzO+uVeQEgdVXnu6pJPy99Nnqk14PxCOoyD9PWXOrYTLp5EVhC2/p0lWlpJTpTBFXdDS9eAwjWp4pwSwHtO5Wa5UlBzdpg+p2xrZXNx9WOO8BdrceTSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fgQcfCYiQTWT2t8vRSz0AaxD3ZlYNErg96xus7HzkRQ=;
 b=X0vAxUULwMLWUwZz/2eXnkpjJU6I2MQLYNCxxBs7IrRFflRVrOebruiiq/VoVl9UzFt3YkoxpqsaOjZOQQHU1e4WfSrF7VqVh2IXIBwkKwMwTJ8u3LqLmsTkrOoztZWvq9RoVfCyTyxMYZ6d4/TgZcplf9MKEZFNUbrAxVv0Z+jTWL7Stk7OM7R2ySJCybwuNd65pSP8gb0H8bKTrHGlKcI4mBlPQCB9gH9VE/Q7QpYQ7YSFaUX+1HC+vGjf6VheET1+s3/fgE21jFKGVhjpJjzHP9OWAWXD8dCdZYCy0xEmhdXLZQ7Z60SfnRAwGE4nv6zC+flvpD+IDmsCBVKyEw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MN2PR12MB4440.namprd12.prod.outlook.com (2603:10b6:208:26e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Wed, 5 Aug
 2026 15:31:26 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0292.018; Wed, 5 Aug 2026
 15:31:26 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 05 Aug 2026 11:31:25 -0400
Message-Id: <DKH49QGMDJGZ.1GN8OC454DA9U@nvidia.com>
Cc: <liam@infradead.org>, <nico.pache@linux.dev>, <dev.jain@arm.com>,
 <ryan.roberts@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
 <usama.arif@linux.dev>, <linux-mm@kvack.org>,
 <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v2 1/4] selftests: mm: extend the check_huge() to
 support mTHP check
X-Mailer: aerc 0.21.0
References: <cover.1785564857.git.baolin.wang@linux.alibaba.com>
 <f2ad5bbe868dc7ed8642842ad2f9751a1ce79f70.1785564857.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <f2ad5bbe868dc7ed8642842ad2f9751a1ce79f70.1785564857.git.baolin.wang@linux.alibaba.com>
X-ClientProxiedBy: MN2PR03CA0007.namprd03.prod.outlook.com
 (2603:10b6:208:23a::12) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MN2PR12MB4440:EE_
X-MS-Office365-Filtering-Correlation-Id: c73a562b-4123-48ae-c2bc-08def3069cd7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|6133799003|10067099003|11063799006|56012099006|4143699003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	Se7QYCejr/5L3HhyWHhPWfVGYVPQEeu9up0T49KMLGLNqQ4MHQwpIE7lVf2x3yjyexYGbczprHy2uN4EYpKd3VC5vmN87rj47WzN7nhrybggbtqr0819xEGyfyPPL7USIFo+dv4xo9cQ+H8+nYvnxShP8vOqkk1abmZ+32RjrIZaKEiv/B2BeVhd9y7AzixmFCvPNkoP15lEcrwXklIa+4qtXa51BprUeHNKpqlY5q7/GsDLq4Tx2M5scO+KfHt3dHkSIzGqxOigD7ghW35vJluC1TmtAShkdmxUtrgs2Exu0mPvc+dnaxbnd+ulKkC6BGXlFg/ayDRfHhGEE1Fpyzhtuj1NZZb0OI+K3Q6CtY2RFOjdEhbi6kSjXBLzMgYUhFIwaD3QOntELbHrHLA5nqE50fWQlFxPo4Z8raFh6xJjOBgHeuE9KcLRnpVUc1coe1GYxDae4CSv806kT7eRtIqfKSyXWCzqI24vu8bSKoyGR7ZCzIVB9Um1yVdZJPtgciRrY1cmJf3E63vPAaYS/I/c1u2FaTfmmNX2NJ8CrVIbdusTW4U8UTrYl1nQdVxdVvpB5MiSkdAT8o2Oyr9BCGyVPxCagFg3eClPkUbB4LAPkmZSgceJqszb34rilBm8834T47iMLvAsJOPbaPJBeUjv3gVdjnuVhaDrlah4OpE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(6133799003)(10067099003)(11063799006)(56012099006)(4143699003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K0M3UWVUT05hY1VuRzZxSGo3VG80c1ZhQ3l0YnVEdk1Ob2QxUmlpeG9GTDR6?=
 =?utf-8?B?d25vTGlpYXo0TGpSRzZ3RkR2ei9qSlNQTW13L05Id3YwV0FUUytRK3FGMDEx?=
 =?utf-8?B?Z1hSTUhwWUtqNTQ0NzhpWDEwRzBhazhVVTB0a0VvNmk4YVp3eWx5ejRjRDMr?=
 =?utf-8?B?NWdKdEJoME0zTHZVa0ZOcVo5Nkdib1QwTGVsQ3l0Q3E5aDhRazg4SlpEdXlu?=
 =?utf-8?B?N1duWHJ3L0hZNUg5TDJFNTN0OFJGNmFRbFdFQ0xFa2YvdXpDUVRMZ0RnZCtC?=
 =?utf-8?B?OXB4d0hBb1I0RXZ4a1c3QTY2U3lYKzd3NlhvOGMvbnI5dCtlQ3FJVWpHdzJu?=
 =?utf-8?B?T29UWVRDYVNuZTd2M1huRCtjc0xtRjVsZ2pCVDhFZktRRWlIQW5vc2U5eXZm?=
 =?utf-8?B?c2ZnZGN4aElaRlF6cmxYeW92UkQ0RmNIMlJteFhDK1NHK0ZuaDlsR0VxZHA5?=
 =?utf-8?B?OTA5RmlXN2ZwVkRpeVBHVXdINE5PNUwwckZ4M2g4Z25uc1MxQmNIQ3NXYU85?=
 =?utf-8?B?WUxoYjhMbXErcTEvQnBwZEdrVk9Zd1dkYm94R0JsTHpMTHRTMVZJVjdIT1lT?=
 =?utf-8?B?YVdrbGJpb21sbmNZMCszVzluZ2tmbEw4TXVLMGlIajh6ekd4bVVhcXUzVUpP?=
 =?utf-8?B?bSs1THNsQkI0djBzc3l1QTZuaTZUZEZTREk3eWEwNlNQQzhGUkVFaHVyeGR5?=
 =?utf-8?B?M25ZL1A3QlRFb3ZOTFRSZWJEY3UxSTVpREFoN3lzVzUvZVZsNGxJWEI0QU4x?=
 =?utf-8?B?T0RHa0w4WkF0VWcxMWR1a0dhY2tjc2hSTmJQSlRrRWl6VmhodFg2R2hxUVBH?=
 =?utf-8?B?R04rNUtXajJSbnA2Y3AzVzVCOS96WUR0aTB2R2d4a2hEejB5bGdqYkF2ZUtL?=
 =?utf-8?B?eG5LQzd2TXZxeklUS2pxT2JCcS9EeGxYMDJtck96bE5rZG85NU1Zb2NGNkI0?=
 =?utf-8?B?aGsycTRSTHZhb1ZjUlBMNWVqaTg3N2VkYVArTlJJUGU0VUtJTTFBZVZQcEJI?=
 =?utf-8?B?K3NFRjFMcDNRMEtWWU4waFZOWUc1NlhEOUx0Szk3b2hJWVpIZUhwVG5BZk5J?=
 =?utf-8?B?cHhTSzJkT0lVVUlXUkFzUUpod0pKUHpmYzU4ZHVRcjVETjk3dE1HV0piUi9r?=
 =?utf-8?B?dXl0SWRYQjcxcldOZDlVOWZ5MHNheDRmbXVXbW1sSHRGN1V0amZuVE85cDVo?=
 =?utf-8?B?bkhtK1N3cjZKQVFlNVJDRnhkajFpYU56WTdGbUpza3B1OXpqOUdnbjE5bWxx?=
 =?utf-8?B?cVgrSW1VTUFPSnNuV3B5SXpCWExiUCtQcWM2QXhMY2dZVy9mK0dOVHRtd3J5?=
 =?utf-8?B?RnEwL3QyNWJOMUdld21CeGVMNW1tVTl2VUk1R0xpZmF5SGxiY1A4eEllclI5?=
 =?utf-8?B?QzJDNlJudytFYmdwVnV3aS9MT3M1VnZHclRMZmR3TU9wVDdDeXdwdUJHSjZU?=
 =?utf-8?B?VjhqTmgvWnRyRXJrSDVyRDZ6RW1VY09HS2s2QTdRNWFPTWxxY0d4d21sSzhP?=
 =?utf-8?B?a0pMMnhwbFZKZEJRR0g5d21OVVJxRUQxSmpnb1Rybzh3a2FMSDliSnJCQ1hs?=
 =?utf-8?B?cXZrNWRjaUN4NE1tanBKUzNlWm9BWnpvOUhPWUJ3OWpXV0xGUUdSZkJtbVlS?=
 =?utf-8?B?TFIzajArOGQ5ZG45amliR0lScTdDd25NNHR3SVZBQ0YzMStCeHI0UlhwWERh?=
 =?utf-8?B?YktEWHdnT0lKY1V1Yjg3L1hYRzM4Z3htUmM2cjJuKzgxVlE5cXhlYXYwcTRB?=
 =?utf-8?B?SGhHWG9TcGsyVUxyL0k4ckdHMG9Dd0czZEJLMmcrMEFYMVgrZ1R2NHg3NFl0?=
 =?utf-8?B?OVhhMXJ6cHFjOU4yd1RhdmFhQzk0a2ZJK2VnWUZuREhjaUJYYTdja3dDMnhR?=
 =?utf-8?B?ZHlrckRHb2tjdEFDMk12eXhxVmhhNDZaL3l3VVdpajNmRG1JU2pvVlZmSjho?=
 =?utf-8?B?OFlDcEo3UUZMd3VwUU9VcExBYkEzdXNjNThXVDhWbjB5TmZPOVM1UUN3NUNU?=
 =?utf-8?B?UnhJTTh6K2FndHdDcXIwbnBHTUFJMXZld1N4RzFudWRPNG1sSHE3M3p5SDN0?=
 =?utf-8?B?MCtRR1E4R01XTk1ORTRDVXIwQXpwclgzNkhybm1ZS2I2TTBQa1hHWTl0UDY3?=
 =?utf-8?B?T2tBOFBGamt1TlNLUmdUVEpuektzQ0huWmdsQjl2MzN3S0NXUG1NY2loVDdp?=
 =?utf-8?B?L3RQckl2Y1RkOXlxcEhzWnlpQUlwS3Zjclk1MVJHQ2theW02WmxyRU9hWEpT?=
 =?utf-8?B?MEF3ZVROR3IzQklEaGQxa2hJemtzVW1CbXlzMmd6aVJ0Ty8xVzNwWmlDUHFQ?=
 =?utf-8?Q?hCc+S65Uv/2BtJb7Kz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c73a562b-4123-48ae-c2bc-08def3069cd7
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 15:31:26.2115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J/++cOp/cwKT4cGyQZOBbBNICFLuZX4I/kdnuAfxZ6x8t58WJoz2Wn2/KCUDVdj8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4440
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 867D4180008
X-Stat-Signature: c11bxynp8yoa58cjzzfjrncd3y83n3t4
X-HE-Tag: 1785943893-476669
X-HE-Meta: U2FsdGVkX18KbvQ6M9wUn4eR78HvmpRKPxTPL1EBikS9JbWLKqajafTqsG5JvB92Nf5IN1IXKDJIYlxQaNxSNyxN9yVuOaDgfj5HhN2I3TLXyF7h1OzWOS2KgbGZCmWHC6Bx3eClyDPMYqH7z2sA3eURV1s+O29oarhEChmTs4eYUMPuovD5//XMMHzxwgEMM4HD26q9YI8pTW3acY7j+2hGg6egdiT6TAs7UfGGg7q0cO3SJfz4iOQ0eC7A3IUA6Dp8AAXTx9awsn25Sre+oNy/uBz1RvKns8Sph0WfZkxQaBlENiuNcrjfVJ+WqerbokrnltNfOm9uBIF/T1QJM77qNZzWmKUrvIPyATbc3fTVksFQ+N3+EUSL+n580NqJRC5qoSFd1cSv/q47hmuqXALnyvNy3byArD9j1Q6KL1E6Qjdt5LXaPBltY0SzKuPrX2M8yEKq13qsePvfTUcIMQOrHpFYUqOIYp1RTAX5BI85H9Dv6o8dFLW2roZj/F6gPytW8U/fYZBPbfK9swUnG+dndOK9cmhtpMk2F6RUDUeF8zHV0ai/Ja87Xqhs4v0fWBhl6yvHnB8BMrVbx2xmCsl0N+kxWUxpT+G9ry68EOiCdi3j9vvFNrCif9Dw6wdlEp4o2S41w3W6Fjsd4FFAhP7jR/+Dvzb0ZMIA7cgnN4BtS4RPD/+gs7EMfw6cG9ILo1SRVbKQvInD/tJsqxI8om/VnOgjPBI32LwpImNEtC6vxpebcpZIeiLwchiyUKzJs65E5xuLnFJ3SwFPaH5LEJrVRMbc5KYDfm7FEq42NpALx9fLrb2MTHVnCZxHQUgsdXYSEXESQzBW/WbBUYmbBR+uAgrZLrIuXAGQ4QDLw2F/M/eWMHTgzVvfQO4Vd+Rq+niwslstUP5fNbyJG7RR2IFDNBWOVjQRESiUZlL/cGcLgQ2B71RgBR0X5A6MBY70I11a5Ox4eX48bxnAfsN
 Xovb+nlN
 7sa49jJ7SHCUZxjI6GcRPscLuZQDxeGEWM5mLUgf8jjjjDNO/Q/U4MLGJlzSIC9qtQVVGjEgjZemcpcI32zrC1j7JNksgBpDvT3//tvqFhv4raMNCcnZhRB1BA550s3fGxLTQGkLZuw1/nokN36z9GcZUi43UnQIAaCFxF/IYvuMk93IiQr6BnYzx3A35O526iw/GeM31w9NDh1J0/nHvRWFOcbhbQSKZD3vYyPG62rH9uQCohYmtEVb/f22Djf+gy5Wzbkya9Qtkr/flgB81/oWsSmPD+lkQ5jf5s4iCjgXztUsrV66na/CHxdbJfpXkzSO5s/w5iWJFyiX05bNC+u5kRxEAPGymm8Gv2U+Vl6gope63IQjk8feeOZ/nYWZ62nc+HTk6pd9emkMkxLmlmHnzgoSkLacIMKyktki0UEwZnawBHuMDClyCSJYcoxypgD7eDA2paBb3KdnsG4E46LvXWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat Aug 1, 2026 at 2:26 AM EDT, Baolin Wang wrote:
> To support checking for various sized mTHPs during mTHP collapse, extend =
the
> check_huge() function prototype to accept two new parameters specifying t=
he
> address range and mTHP size, in preparation for the following patches.
>
> No functional changes.
>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  .../selftests/mm/folio_split_race_test.c      |  2 +-
>  tools/testing/selftests/mm/khugepaged.c       | 66 ++++++++++---------
>  tools/testing/selftests/mm/pagemap_ioctl.c    |  2 +-
>  .../testing/selftests/mm/prctl_thp_disable.c  |  2 +-
>  tools/testing/selftests/mm/soft-dirty.c       |  2 +-
>  .../selftests/mm/split_huge_page_test.c       | 14 ++--
>  tools/testing/selftests/mm/uffd-common.c      |  4 +-
>  tools/testing/selftests/mm/vm_util.c          |  6 +-
>  tools/testing/selftests/mm/vm_util.h          |  6 +-
>  9 files changed, 56 insertions(+), 48 deletions(-)
>

<snip>

> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftes=
ts/mm/vm_util.h
> index 7799154b67ee..c7ae28dfda63 100644
> --- a/tools/testing/selftests/mm/vm_util.h
> +++ b/tools/testing/selftests/mm/vm_util.h
> @@ -90,9 +90,9 @@ void clear_softdirty(void);
>  bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t =
len);
>  uint64_t read_pmd_pagesize(void);
>  unsigned long rss_anon(void);
> -bool check_huge_anon(void *addr, int nr_hpages, uint64_t hpage_size);
> -bool check_huge_file(void *addr, int nr_hpages, uint64_t hpage_size);
> -bool check_huge_shmem(void *addr, int nr_hpages, uint64_t hpage_size);
> +bool check_huge_anon(void *addr, unsigned long size, int nr_hpages, uint=
64_t hpage_size);
> +bool check_huge_file(void *addr, unsigned long size, int nr_hpages, uint=
64_t hpage_size);
> +bool check_huge_shmem(void *addr, unsigned long size, int nr_hpages, uin=
t64_t hpage_size);
>  int64_t allocate_transhuge(void *ptr, int pagemap_fd);
>  int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags)=
;
> =20

I get what "size" means only after I see Patch 3 where
gather_after_split_folio_orders() is used. I think len is a better name
if not addr_len and its type should be size_t to match
gather_after_split_folio_orders()'s signature. The rest patches should
have the same rename and type change. Thanks.

Otherwise, LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


