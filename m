Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C88FEC1128
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 20:03:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC1696B0089; Mon, 23 Feb 2026 15:03:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B996B6B008A; Mon, 23 Feb 2026 15:03:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6DDE6B008C; Mon, 23 Feb 2026 15:03:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 919D56B0089
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:03:26 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 46C831602E2
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 20:03:26 +0000 (UTC)
X-FDA: 84476796012.28.E5DF9E9
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11021080.outbound.protection.outlook.com [40.107.130.80])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3A25D1C0018
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 20:03:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=LKPRgJHv;
	spf=pass (imf18.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 40.107.130.80 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771877003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Db4jRs/EFk7zsEF/qDorpLvIMXChA5tbTmpkO6HO7w=;
	b=KXKTcEwRUYdDebldGpCh6BgjZYx/9eF/9xizTf18AmI/NT4Dq7zTqxImXXa6HAZ4UmaNVP
	zz0/QLw8/YBTkk2FwAQJQYUbvtC3D31RdLb5zv/tK9aTVgbL/lljAhaJcNtl26kmzwpy4p
	7BrqAvBhX1aLoPXH3bFGjQ8tEunfUbA=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=LKPRgJHv;
	spf=pass (imf18.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 40.107.130.80 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771877003; a=rsa-sha256;
	cv=pass;
	b=kcElE8y+TOCY/p9VRQ3fgPZb8f1xezG1zpW/mn4h0nh8WD6H1LOjPRz2aQ6fhy+1rHBe0+
	sFTaLAC+dTTNH7kM9LHfBqbS6R79yV2sWOa/tKsGmgPuDb9EwP71tS1+dSp6abjKvwE8CU
	HBu/eUMxN7GX1Kx0j/pTGOKtrvJ3qN8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=impuRwSksNpI8sX7det7zd/C9xDshsD2L3BRGoN5nTD1E9zFaxd2C+LvT4ZDBy8UOI/inpcwBCuD6RwJ0MpP1V+GKJDioD0UNSjPNTM0zjvy6F5jFnGnNZD4ybDFGKPT+gS92XkYlifJA8e+jD6ApY8u5KUKo1CMFWdjrHo1e+dhQcWZooW0sWt3DkSSDQK7bwTbus/CpkHn1WJ1vSHug/UbyrAnvA40U27fcxMJcqJnmzeNYV+7C0Z6m2IKVqkXGSdV/WVvQe3M7htUTsVDE3pIS1Jd9+aKsvMwjrh/Ra00UADy8Cqx0iTkw0ItsWJWSpdEhGJ6LxYhIWQwLBAZRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Db4jRs/EFk7zsEF/qDorpLvIMXChA5tbTmpkO6HO7w=;
 b=tOPWUMGKgLBrZ/LI/XrllFTn/BFVVXwM2bO5Dea+HOoOlx5eVnQtvcGIZ8CrwO4n/Afom5cxIG+UMjPW9By6zyk60dO1/LDTNtk4kdNqYz8zdYpxTzGKEJCjEqc3M5jeEI+DoKLbP0721K1ocsmbDcXc5e1Hu5YTILs7BsFsitaADP1re/MZHBPKdKTMqal/PkrOk7ggTTOfn5z5glGJl7RJsFYe8Oodii3aHbfcu921ukxmz8SrOxdvuXXFj+Mitb9bff4xu1yyRv9euGH7RS4yvBdE2y1c/QEydXRHOuLfTCoLVQzLMVeB3WzOzEESR5GFt26tc5aP+wOAFHRHtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Db4jRs/EFk7zsEF/qDorpLvIMXChA5tbTmpkO6HO7w=;
 b=LKPRgJHvkYPfTI/YwGa0+60Qa2enzdlQpSbF7XD4yyui5xwIy0TQnEokH/+RadKar8cNwC9trBYwLpg/QED+/L6U4u4rPob3UIwooGNxaPb+PL+npe1j+naEzJRX2slY0Bq0JKiQ18W1KhKRJL1EIoHfUvGj/Ku+4Mrdknxr8EpUg+KX8iGVbUBP58zd7CO62VffyoA0ih6o1ZVeRzXCqMwdVjL/G8mDSVWi+PSUghuPUeRjjkb0pT15yowDDW9lVYTxNeXjD9XluJJUkdF6X1Mjwkx/+iPmjA4GJXwX9h5JO6z1Kkn55b9x/eBBJfA8MzSNG8gjl1M1zby7sUcK6g==
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com (2603:10a6:10:471::13)
 by AS8PR08MB8874.eurprd08.prod.outlook.com (2603:10a6:20b:5b8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 23 Feb
 2026 20:03:05 +0000
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::3470:51d7:36e4:36d2]) by DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::3470:51d7:36e4:36d2%4]) with mapi id 15.20.9632.017; Mon, 23 Feb 2026
 20:03:05 +0000
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To: Christian Brauner <brauner@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Jan Kara <jack@suse.cz>,
	Oleg Nesterov <oleg@redhat.com>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Andrei Vagin <avagin@google.com>,
	Kirill Tkhai <tkhai@ya.ru>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	Adrian Reber <areber@redhat.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v2 2/2] selftests: Add tests for creating pidns init via setns
Date: Mon, 23 Feb 2026 21:01:23 +0100
Message-ID: <20260223200254.4104651-3-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260223200254.4104651-1-ptikhomirov@virtuozzo.com>
References: <20260223200254.4104651-1-ptikhomirov@virtuozzo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0163.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:67::8) To DU0PR08MB9003.eurprd08.prod.outlook.com
 (2603:10a6:10:471::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR08MB9003:EE_|AS8PR08MB8874:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e6c6a06-90b8-45cb-4ce7-08de73168ecf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|10070799003|52116014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UwBQvCKym5H8RF6GdkVCU0B0y6L7ESpqcfhiIT+NHbNqL3FCg1EFfInRLZcx?=
 =?us-ascii?Q?3Du4foapjXDlYPCteAwPrmrFWD/B/w+HKx+mfUtoRuG7eTYNRt6Z1aTp34CI?=
 =?us-ascii?Q?y5n8aODfvYsq5CRCh1NRMphgBB77irOYte8wuto6iluSwsDE+2wbfmf0ztWD?=
 =?us-ascii?Q?UcM1kev43YLgPqh/YUXjn3uxR0LZiydd+1r9kntDj+NoZeUhb7wIjkV03o57?=
 =?us-ascii?Q?qZuO6x9GDdaDwGKsZttpuK03rY+8q1S2jlvfzx7J+oMjj5+Otoyddtny8I+/?=
 =?us-ascii?Q?4Mj6zKPP86ECYnQbF1i2x0yWi7PZvT8WWB/mh2UpDAh9nFby1m65bny6WoQz?=
 =?us-ascii?Q?fyNJSndsz0+EVDFC9GgFTHTaA841etYk7SdIJtWtgllcgDCsa8lolDkz1k6o?=
 =?us-ascii?Q?41NwqPTX6RvNVs5pjPjRZRjppVQxkZFlbMdFO7YH2uSxntMV+6vnH43+XamS?=
 =?us-ascii?Q?2HlnIuz+iAxc0oGAHdcQWrI1AOmOLKd7CoLslSmXxoI/npt/0uEd2d9aOeSK?=
 =?us-ascii?Q?YZ3O6zeAODmSRqt+3KT7ui1/Q8aLXxmdEep4VqDwZxWKZi39ap83ukwwr32J?=
 =?us-ascii?Q?zSVpDHzu8hB5xZfxxwycyGUESn3EQ/7/dkL4c1KAslJtYYQnjyHs1jDQh+EB?=
 =?us-ascii?Q?ClxZc76ntwn5URJKqkxYs9rSU32ZA66SKTk7Rx8IQIH6w7DJ+afKmVJhr81l?=
 =?us-ascii?Q?4+bC5pxU6QsXG0kleOoMfCPgJb+PIVEvOKdAzjOhdY1hUINzmuZ2D3TDfFqd?=
 =?us-ascii?Q?kA8Nh3nLhuZ4rbDtNa+2rW6Wek4J3PVeNioj26rT0mw862mU9t4SnG5UAeCp?=
 =?us-ascii?Q?MD5QAJI45JE73D6uJoLmyIsR1N4Ozvp9MMpHh5peLia2DLY2xdceSMktfp9f?=
 =?us-ascii?Q?rQYEu/p79KMcynIfqUDYo5HSBBrcH0bbWLau3/CbR0VgTHw+Hn5DL56ch4zr?=
 =?us-ascii?Q?CAtHRds7XUF5XX0ic7cSXeLFsoaecxcRgK6mmTXRW/MVyEzqzBRH0zo//Aut?=
 =?us-ascii?Q?J7+Egpx6A7mfpfDf0oZ4o0AMIbpgivM1GIqlTyohq/j387UWNFPstqepdXb+?=
 =?us-ascii?Q?SlgUxaLan1cg9VcwFsCBcILtjsJANfYejNOtrJUdtdeoTh3bZ5LRfOWwqmqZ?=
 =?us-ascii?Q?kUZ0j1En9qQet2iYCgtEDYo6AQv7SjnQ7IxiTdep7l35Do9Yk1hJOR7MRh88?=
 =?us-ascii?Q?NpVvQNk/RrKSyoyx8ZH0yms1OjgdQ7gLp47xJU4XSBcs4mafLF+cN5TivxvU?=
 =?us-ascii?Q?wQqZqlD0Q3aY9fdJgOm4+SIAPqMGqS895H3aT0wanJVcF6jS0hFe1igFU5XG?=
 =?us-ascii?Q?/hmZ7ZPooI1t6VBDRYZTcaVUBAXC4hY2m0x1aE1z9gxNk7s0JmFv2jjyEpg0?=
 =?us-ascii?Q?CQw7M/wPv4tMbkhDTyTTGXv/xAjVya7Uyb5La1z7zRTCt51nrhngUmr+wdfp?=
 =?us-ascii?Q?p1kS0DpRZRGg5y/dQcDiLyLmQomnfcc37+s1sVM386zEQ62Rc+o+sJrHrTEV?=
 =?us-ascii?Q?v2rZ4fpwL008dtEhLBEIIQ9IRoOb5nUjYWZRVmyizSAZTmLJmNmA3NK0Ddz1?=
 =?us-ascii?Q?5Adas86Sn4uqqYMwZTI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9003.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(10070799003)(52116014)(7416014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?93BoL6WeIspv+4uip6sttoGl+pcH2wfdVuHCgmLY6cZYn29SUSyw5Dhj+HjN?=
 =?us-ascii?Q?iOM6Xe+0tddSCo1UCENtIQb7vG9qnZDGACvo8IajdUkult7PxfGRzhDxzcvU?=
 =?us-ascii?Q?wys4gXqWmEDMHtJIHZFHymCARl0RDXLweDxeraVUK2PeZ7yuvmoFJl9grrkv?=
 =?us-ascii?Q?UCaBJfE23s/gqIpAyF0s2KSUvJTMyfHui5qRy4i6ylKLQ/dRKMzN9vhmxUhW?=
 =?us-ascii?Q?nNSvL+CyvEqnviEp3wU44o1eZEryhOpRdz6/EVuBAS7TwVCcYOj513OLIuXs?=
 =?us-ascii?Q?7b8QSeILVWCLlTdWIRkJwmZYb1WH43QrjfET6oRelUiWZ5pSmbmtYu5EucaJ?=
 =?us-ascii?Q?sDJ0wKa9ZNVxAzyABGgRvSIbcAF/vagi9d5DXWmqaD7qS0wowbWrdORFF10E?=
 =?us-ascii?Q?BItgXABNUEDoZWpfy2YvIphsnSmodgI0xLcnHiSHGBTyiSX7c7kFpAOH6MZh?=
 =?us-ascii?Q?DitAF9o7jCvhN53rqt+9D3WcTH2FMAuXfsiNWggw71cbjsi7dmHNcC5329LG?=
 =?us-ascii?Q?ycIOjLPNP1GfBABoKOV0yYZwb8Jluud7xa37eeNZr/NModuh80jjZ2dlfcb+?=
 =?us-ascii?Q?VOJx+Lwi7R2H0+sNXbiJFrKIsw7+E+EYvLXqSAs4dAgMUeVK3NR+W2isiRak?=
 =?us-ascii?Q?EuxwICJgYrRzLZV7qCQTfbg+NljVGMLBMj0gTqUzmk1Uq1G9wL0BJe8FehXM?=
 =?us-ascii?Q?lIn1SmyU3gPOaLtiisdIhufd6FXk2gwsAtVagpLt2FFFRRqh05AlUo/Uoqqg?=
 =?us-ascii?Q?BFHGbQogf/xy9820kN7BqUQCjeyCUpCkoABdGRGybpvmAssG0rwUUomEAd5S?=
 =?us-ascii?Q?EUrUHpUtI1BczzzLPkJT+KwPnD+6QbbPHc4UB94f2h/wqw4igRdHJAiPU97c?=
 =?us-ascii?Q?jebc4WETZkqBfnH11B0uXiozx5LIsaFfsVgZRqdhhbfTrkelL7J0NVa+JXgL?=
 =?us-ascii?Q?9aT2ONnq2ZafZFSL4HSoCLnyoScux1S/fuF6kZKmgF2ugx2NgxRPWyJj05zh?=
 =?us-ascii?Q?7GlUxvR5wAEDt8m3+uvoWZqF6jmBBqw1vvtRM6WaxxfTqNkCumn/snZ2ut3k?=
 =?us-ascii?Q?qR2OIcLJGaGo81gHPs51OsxY3sCxNVruWuXkv5w2HQFnha4Y4tUn3t3rXu9N?=
 =?us-ascii?Q?XtI9nyItvb7UZLYbWkVBih+2SBQEw0HxMNTKtr4SbeN4eXiV+jRA7IXO9h4D?=
 =?us-ascii?Q?TMxsKrbK9j/oINRHuPEJkz1fUqDn/DMVj5V/x8zQ9mmrpK8cmPK3cs5m8ppJ?=
 =?us-ascii?Q?N59rjaooxCsHHtcZGAIKwEIRzw9XXxKeV/ci1RURXqn/o8W7LgCA7+wgBmRI?=
 =?us-ascii?Q?nqOChrPX7Y7i7lx6RQu55qjFjmBVpyWMqbVApzCKnQq04ZUz6mFo6/CRU54C?=
 =?us-ascii?Q?of4M+5x2t2lQXIzrccQ1K4l9hubBz67B4RSKZPgVpEXIOWW5y1CcYLhcNqJl?=
 =?us-ascii?Q?2VDuFJ5vl0ZR7/MfHfjTj3Y3RVKRMjkM0REiMOAj0d5xqX8pXDhBKnvQwUpW?=
 =?us-ascii?Q?UaykabGfMxo7B3dXCHvhZEg4efMMEm1pwsOLdzoNyWFbUf+5lDxhvJLGZ2qS?=
 =?us-ascii?Q?SF2o6az88zpWxFCUUOc62eajcxnmpzYSpsCCdIOfubBs4dJd7TupMUd22++n?=
 =?us-ascii?Q?E00bGkRmrkqCPDrg0lNPgXTd8VF9e8qa1q8Wg5TyclY81PVoS0V4lFdztVOt?=
 =?us-ascii?Q?TIB+aREYv5lXTQdgNG0PvvliBsaXQM1+qV/tB6e4pE60Nkl8JuaIcecqJVev?=
 =?us-ascii?Q?dBIwNkJwzSUPCQ2rpm14Fm0gyh+ZQ34RqixyVx6FGgU7V02v/6Pz8y3RlB66?=
X-MS-Exchange-AntiSpam-MessageData-1: uApRSeVIiBWZQt1jCJoeqNDRuA5cKRYYrO0=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e6c6a06-90b8-45cb-4ce7-08de73168ecf
X-MS-Exchange-CrossTenant-AuthSource: DU0PR08MB9003.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 20:03:05.6727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uib7fSrSDMOjyDjy0KUB6N53FQYeve20KwBWj52Ozm3HXvJd4YKxXurMUT4JXU4o8LPDHihIi6rJ4FH6yxnBmQHT3W0wiR/XeRpBBtGMeUw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8874
X-Stat-Signature: 4mapm6h6ycdhhbxsictk3cx44hwbwudo
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 3A25D1C0018
X-HE-Tag: 1771877002-760931
X-HE-Meta: U2FsdGVkX1/BlGm5xiy4RK+h4vmwNZzWIyLRyH8juN4ytDkhoiBACSre32FsJfRg9EGmvnAOXSaz1mrDJYViqjZQF2bePhvhI1kigLZu6nLc3th2f+UueS2ANP8bDZsioz4J09+Zrs9N0MQ8ynzEL+bLlMZrLN8fgVlEJ/jB14QuHhbJfEsKCu+ypVyMySGEKNAVK7pfg9guIvaLZKs6twNt6yz1+xV+dHPltphqXKLJtfxZygPovwvz88rkVn1ecDXYyD/jvLaTRi1ndliIxoTKa1z2WLcflqJqhFHHzvzj3A63UDeoF0vZIAfBAU3QNK7H2YOViMgnc7Es+i1FBFUz+aS6rCekbO84IHMM3Jts5AtJsnYbsalcBSZY+6PBTYXbBYMKy2Iw6LLTq+RYljPl1pZ36nd8QsxfL3Kt4wwg10HOkVQXCySsKsOF6h2TLOW8A1eHd7ix2OPjRxsDDuynJ3stt4d7Tz4KoHaC1l7mYNvWn4Zv2vCQj+kxeKGUyGm7c/54ERUuOcd5SCrM+rsMBBYwgTnRjENfwx28YCcfqsStTkBiObQKjQHWRaAFYwt9YGDoRgSZuDvCC7qq9MObklay4oWIBDBexQoYLxd1b0osG9xi/JSaZ1G6QXOrG8KpGIDj2WVQ/AVd+xomKWmx8rAIlfPiFbd0X6dW1cTgyTtOaRTOGNxDtEJzsjm/s/CdarZtDzq2bls/fDMzJpj9GH8pt5EsTwFjbt5bFEZdG8IhAgAMk33IGPbJJxrEssmPS4E9pelGjfWylaauW3aSSwK7jtjwO6hwqFyfYkH9yqXgmxpCUp0hNPYeSjtYgsz2hG8Mrj8uE6ZMQGm8rH/PK4Xoo1hJrUHH0hAU1vTpBehUazaox4DuGUzuJtghpmj1OoAH2gkAHBSMP7jUlYBc6rCHSiaSDOIG2X/67g1REws2nOedbbvbkXh5ix+g9JXfCaep6Zfpzo0OVSP
 RjKNFes8
 4AxHKsL6EFqBxkjxQ8zEb3jBKm+aRq/fqWZ4l7uCWyss85WBUx+Iy/xVc49fLOuM48CJOqaG3r4a9GDWCKEeJ3VNQq98epHSUHaQ7kjUgXa3oLJ+pl7ssWKB2ZvbwNTu4/O6SlnAz++yEHIV9R15VqdezHtISOBWeLpry2U8kO5KIG8Gk6dv8nC7kizYCsW6JQnyhsBAyg8pCQeJkn6ChXPDuDhFv4lMSniB9/bkJoQSgkbLBU7TF4EFR4VYaj2YDOiBn3Zw6xGAG5Yl1ZHMxIz0gITCtKpOK3HEwQCUxA0dGgVpymCFcE5nkdFsJ4oWF0twDd/wfZB0cExWAneQft+a5lBo2Pc8U/7nOJFcK2diwcV0vfjLKDK1qGE3Y221ZdYVglpFX8jJYDXyBJhQkWCbA2otA+5W5mcZxYkII1uBxCa8nCStrOTSwEw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

First testcase "pidns_init_via_setns" checks that a process can become
Pid 1 (init) in a new Pid namespace created via unshare() and joined via
setns().

Second testcase "pidns_init_via_setns_set_tid" checks that during this
process we can use clone3() + set_tid and set the pid in both the new
and old pid namespaces (owned by different user namespaces).

Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
---
 .../selftests/pid_namespace/.gitignore        |   1 +
 .../testing/selftests/pid_namespace/Makefile  |   2 +-
 .../pid_namespace/pidns_init_via_setns.c      | 238 ++++++++++++++++++
 3 files changed, 240 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/pid_namespace/pidns_init_via_setns.c

diff --git a/tools/testing/selftests/pid_namespace/.gitignore b/tools/testing/selftests/pid_namespace/.gitignore
index 5118f0f3edf4..c647c6eb3367 100644
--- a/tools/testing/selftests/pid_namespace/.gitignore
+++ b/tools/testing/selftests/pid_namespace/.gitignore
@@ -1,2 +1,3 @@
 pid_max
+pidns_init_via_setns
 regression_enomem
diff --git a/tools/testing/selftests/pid_namespace/Makefile b/tools/testing/selftests/pid_namespace/Makefile
index b972f55d07ae..b01a924ac04b 100644
--- a/tools/testing/selftests/pid_namespace/Makefile
+++ b/tools/testing/selftests/pid_namespace/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 CFLAGS += -g $(KHDR_INCLUDES)
 
-TEST_GEN_PROGS = regression_enomem pid_max
+TEST_GEN_PROGS = regression_enomem pid_max pidns_init_via_setns
 
 LOCAL_HDRS += $(selfdir)/pidfd/pidfd.h
 
diff --git a/tools/testing/selftests/pid_namespace/pidns_init_via_setns.c b/tools/testing/selftests/pid_namespace/pidns_init_via_setns.c
new file mode 100644
index 000000000000..7e4c610291d3
--- /dev/null
+++ b/tools/testing/selftests/pid_namespace/pidns_init_via_setns.c
@@ -0,0 +1,238 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <fcntl.h>
+#include <sched.h>
+#include <stdio.h>
+#include <sys/types.h>
+#include <unistd.h>
+
+#include "kselftest_harness.h"
+#include "../pidfd/pidfd.h"
+
+/*
+ * Test that a process can become PID 1 (init) in a new PID namespace
+ * created via unshare() and joined via setns().
+ *
+ * Flow:
+ *  1. Parent creates a pipe for synchronization.
+ *  2. Parent forks a child.
+ *  3. Parent calls unshare(CLONE_NEWPID) to create a new PID namespace.
+ *  4. Parent signals the child via the pipe.
+ *  5. Child opens parent's /proc/<ppid>/ns/pid_for_children and calls
+ *     setns(fd, CLONE_NEWPID) to join the new namespace.
+ *  6. Child forks a grandchild.
+ *  7. Grandchild verifies getpid() == 1.
+ */
+TEST(pidns_init_via_setns)
+{
+	pid_t child, parent_pid;
+	int pipe_fd[2];
+	char buf;
+
+	parent_pid = getpid();
+
+	ASSERT_EQ(0, pipe(pipe_fd));
+
+	child = fork();
+	ASSERT_GE(child, 0);
+
+	if (child == 0) {
+		char path[256];
+		int nsfd;
+		pid_t grandchild;
+
+		close(pipe_fd[1]);
+
+		/* Wait for parent to complete unshare */
+		ASSERT_EQ(1, read_nointr(pipe_fd[0], &buf, 1));
+		close(pipe_fd[0]);
+
+		snprintf(path, sizeof(path),
+			 "/proc/%d/ns/pid_for_children", parent_pid);
+		nsfd = open(path, O_RDONLY);
+		ASSERT_GE(nsfd, 0);
+
+		ASSERT_EQ(0, setns(nsfd, CLONE_NEWPID));
+		close(nsfd);
+
+		grandchild = fork();
+		ASSERT_GE(grandchild, 0);
+
+		if (grandchild == 0) {
+			/* Should be init (PID 1) in the new namespace */
+			if (getpid() != 1)
+				_exit(1);
+			_exit(0);
+		}
+
+		ASSERT_EQ(0, wait_for_pid(grandchild));
+		_exit(0);
+	}
+
+	close(pipe_fd[0]);
+
+	if (geteuid())
+		ASSERT_EQ(0, unshare(CLONE_NEWUSER));
+
+	ASSERT_EQ(0, unshare(CLONE_NEWPID));
+
+	/* Signal child that the new PID namespace is ready */
+	buf = 0;
+	ASSERT_EQ(1, write_nointr(pipe_fd[1], &buf, 1));
+	close(pipe_fd[1]);
+
+	ASSERT_EQ(0, wait_for_pid(child));
+}
+
+/*
+ * Similar to pidns_init_via_setns, but:
+ *  1. Parent enters a new PID namespace right from the start to be able to
+ *     later freely use pid 1001 in it.
+ *  2. After forking child, parent also calls unshare(CLONE_NEWUSER)
+ *     before unshare(CLONE_NEWPID) so that new old and new pid namespaces have
+ *     different user namespace owners.
+ *  3. Child uses clone3() with set_tid={1, 1001} instead of fork() and
+ *     grandchild checks that it gets desired pids .
+ *
+ * Flow:
+ *  1. Test process creates a new PID namespace and forks a wrapper
+ *     (PID 1 in the outer namespace).
+ *  2. Wrapper forks a child.
+ *  3. Wrapper calls unshare(CLONE_NEWUSER) + unshare(CLONE_NEWPID)
+ *     to create an inner PID namespace.
+ *  4. Wrapper signals the child via pipe.
+ *  5. Child opens wrapper's /proc/<pid>/ns/pid_for_children and calls
+ *     setns(fd, CLONE_NEWPID) to join the inner namespace.
+ *  6. Child calls clone3() with set_tid={1, 1001}.
+ *  7. Grandchild verifies its NSpid ends with "1001 1".
+ */
+
+pid_t set_tid[] = {1, 1001};
+
+static int pidns_init_via_setns_set_tid_grandchild(struct __test_metadata *_metadata)
+{
+	char *line = NULL;
+	size_t len = 0;
+	int found = 0;
+	FILE *gf;
+
+	gf = fopen("/proc/self/status", "r");
+	ASSERT_NE(gf, NULL);
+
+	while (getline(&line, &len, gf) != -1) {
+		if (strncmp(line, "NSpid:", 6) != 0)
+			continue;
+
+		for (int i = 0; i < 2; i++) {
+			char *last = strrchr(line, '\t');
+			pid_t pid;
+
+			ASSERT_NE(last, NULL);
+			ASSERT_EQ(sscanf(last, "%d", &pid), 1);
+			ASSERT_EQ(pid, set_tid[i]);
+			*last = '\0';
+		}
+
+		found = true;
+		break;
+	}
+
+	free(line);
+	fclose(gf);
+	ASSERT_TRUE(found);
+	return 0;
+}
+
+static int pidns_init_via_setns_set_tid_child(struct __test_metadata *_metadata,
+					      pid_t parent_pid, int pipe_fd[2])
+{
+	struct __clone_args args = {
+		.exit_signal	= SIGCHLD,
+		.set_tid	= ptr_to_u64(set_tid),
+		.set_tid_size	= 2,
+	};
+	pid_t grandchild;
+	char path[256];
+	char buf;
+	int nsfd;
+
+	close(pipe_fd[1]);
+
+	ASSERT_EQ(1, read_nointr(pipe_fd[0], &buf, 1));
+	close(pipe_fd[0]);
+
+	snprintf(path, sizeof(path),
+		 "/proc/%d/ns/pid_for_children", parent_pid);
+	nsfd = open(path, O_RDONLY);
+	ASSERT_GE(nsfd, 0);
+
+	ASSERT_EQ(0, setns(nsfd, CLONE_NEWPID));
+	close(nsfd);
+
+	grandchild = sys_clone3(&args, sizeof(args));
+	ASSERT_GE(grandchild, 0);
+
+	if (grandchild == 0)
+		_exit(pidns_init_via_setns_set_tid_grandchild(_metadata));
+
+	ASSERT_EQ(0, wait_for_pid(grandchild));
+	return 0;
+}
+
+static int pidns_init_via_setns_set_tid_wrapper(struct __test_metadata *_metadata)
+{
+	int pipe_fd[2];
+	pid_t child, parent_pid;
+	char buf;
+	FILE *f;
+
+	/*
+	 * We are PID 1 inside the new namespace, but /proc is
+	 * mounted from the host.  Read our host-visible PID so
+	 * the child can reach our pid_for_children via /proc.
+	 */
+	f = fopen("/proc/self/stat", "r");
+	ASSERT_NE(f, NULL);
+	ASSERT_EQ(fscanf(f, "%d", &parent_pid), 1);
+	ASSERT_EQ(0, pipe(pipe_fd));
+
+	child = fork();
+	ASSERT_GE(child, 0);
+
+	if (child == 0)
+		_exit(pidns_init_via_setns_set_tid_child(_metadata, parent_pid, pipe_fd));
+
+	close(pipe_fd[0]);
+
+	ASSERT_EQ(0, unshare(CLONE_NEWUSER));
+	ASSERT_EQ(0, unshare(CLONE_NEWPID));
+
+	buf = 0;
+	ASSERT_EQ(1, write_nointr(pipe_fd[1], &buf, 1));
+	close(pipe_fd[1]);
+
+	ASSERT_EQ(0, wait_for_pid(child));
+
+	fclose(f);
+	return 0;
+}
+
+TEST(pidns_init_via_setns_set_tid)
+{
+	pid_t wrapper;
+
+	if (geteuid())
+		ASSERT_EQ(0, unshare(CLONE_NEWUSER));
+
+	ASSERT_EQ(0, unshare(CLONE_NEWPID));
+
+	wrapper = fork();
+	ASSERT_GE(wrapper, 0);
+
+	if (wrapper == 0)
+		_exit(pidns_init_via_setns_set_tid_wrapper(_metadata));
+
+	ASSERT_EQ(0, wait_for_pid(wrapper));
+}
+
+TEST_HARNESS_MAIN
-- 
2.53.0


