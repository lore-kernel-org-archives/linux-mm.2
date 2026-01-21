Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFCEBC44508
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 17:58:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CA206B00CC; Wed, 21 Jan 2026 12:58:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B58F6B00CE; Wed, 21 Jan 2026 12:58:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 290796B00CF; Wed, 21 Jan 2026 12:58:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 177166B00CC
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 12:58:52 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B8A961B091F
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 17:58:51 +0000 (UTC)
X-FDA: 84356731662.17.04059B0
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010017.outbound.protection.outlook.com [52.101.56.17])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2FFE2120060
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 17:58:49 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HJrQ9Uzw;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.17 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769018329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k2nJo/IyrJBs96t+Sqn8fMULveLev4TsZBQ6SbPIUbQ=;
	b=G0NYRvv7VhYrnXdUKK7mcSRbosuGuM+xbuK50Jp3Y00RwQeVAndjc3XzSRyfWMuYcBCmfM
	wQ0SeIjNRhsY0XHuWAcj0Kgo0v+tpTX48MwA8jhYOSpqYpcQXao9Ma/M4E2iwZY9p1XW08
	sBIbbYpU++NjkCDX6uJq5j5Y7SpYeUM=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HJrQ9Uzw;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.17 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769018329; a=rsa-sha256;
	cv=pass;
	b=L342soxbJD5FjuDd2cKYh/tVo3TQi+hGYbpFpbMASso1KlmI/HuTVuaLpTFSINsoI1FsIE
	Id+fuZ7iFa/+Qg5yEgQJkmJrbmiANivVw2Pqx7ou7cBgVzazAHlGGcJbbUlxbei/XFqts0
	wAdVCkubtWTln3FoxLwogMHpDK0RCDU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Grj9uWmeKK/8ySYRmTFidj0jejCoP2SR/xW/PGEow5MGrrnoUY7zLYv5moBWOnG6vM3Iuvg0ERYZWb+N7tqEkIS5W1JP+rscjJ48T/m6od6MMw9q6m0pkg6KdlKISjlTSDb9wFoyTdZNamwv6qjXg/Ph5Xh/oBlwd0b2IOoITUfyC+Xp9QIlL7sBbRbXPoCYdx85ClQdaNYD8Ka6bJlS9TfNfPIcdUTZbQ4+GULwTPFZN+D+320GYkDyqoxSE9ZTalwPE3Mn7HizZZfO5943q6WqD5kKbd1h0KEHZ9Ugsx6/4DY60U7btNnNgef0rXgRNI3yhE/MxugqsxZsHwbteQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k2nJo/IyrJBs96t+Sqn8fMULveLev4TsZBQ6SbPIUbQ=;
 b=phYaPYTZGiL+Vf33dtJjVSC9JZK+FSSD89VCAKDANmsLjUED+VKeqiuw1h+fqxReZLlgWlIfqBGSZB6yurAfUERXFKi9Kluuov9swOTisdz3gKPm/iwh1iMPLPpusOhTYT08extlqUQyoEGi3iy5xQBnNazHK72uKhVVf158tGlQuQaCOwPx77XaEQsRSdy8BWU/k/YXV373ZnbC7kdioH/upkcdyZPsNSwk1+M01dhuInPhrQdsDlIW0Aj8EyKjBovFH+kZ9QR0D8fXo14xE/AEXROVzUT3wrs9Kw55sEzXAqeidIKQE15l0yZf3xJhps6hjDV23PMu4avAzlSQvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k2nJo/IyrJBs96t+Sqn8fMULveLev4TsZBQ6SbPIUbQ=;
 b=HJrQ9Uzw4le0r/Hs/XGi6rDJpVAEfzbzJ3yKXl+mY8xtbTfOB+mox/QYZs12Hm7V9zwqYawsvcs3AUBoTLuOAXx45QEphuoNt+aBxzu2JXZYUJxwItouMbMiRidTKsfRvPM2dh8GRTUi7WUFTCpRS5Ze08attY+HEV+MG9HxQG14WH97t+etMrLguCzLb4xBm3v55E0UuWRZVOAJnKlgeW5eN3+0WHPxhVTiLVK/UUbygVfVDjgg/bbLBGM2Z3+YQA5tg3crgXZdTaRow1D6leL949f1z0ZEMzvRu911cZmXpLckgs2kufMITFY5bs0eUpFiyHoL/3yfltuYsTFYAA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS5PPF5C5D42165.namprd12.prod.outlook.com (2603:10b6:f:fc00::64f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Wed, 21 Jan
 2026 17:58:43 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 17:58:43 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv4 07/14] mm/sparse: Check memmap alignment for
 compound_info_has_mask()
Date: Wed, 21 Jan 2026 12:58:36 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <B752281D-4A31-4E2D-945B-FD18016B722E@nvidia.com>
In-Reply-To: <20260121162253.2216580-8-kas@kernel.org>
References: <20260121162253.2216580-1-kas@kernel.org>
 <20260121162253.2216580-8-kas@kernel.org>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0049.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::24) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS5PPF5C5D42165:EE_
X-MS-Office365-Filtering-Correlation-Id: f0157925-7b1e-4910-83cb-08de5916b6e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vzMYEIZNuRGrCK3JgUt48hCNyM2axq0L3Wm7Il82kt31Cz0aLZHvIkZ/UTCK?=
 =?us-ascii?Q?UUulaBbH19GVuAb/e5A/9x2I9jgE7JiRobzRdHuhpj5JbUsUDETIpj3sRD/O?=
 =?us-ascii?Q?hMTAnL4h0M7uSsE9Z92rF2jtW6FU79OYxs+TUP0tJV+bsxB9PT34gauvKKQf?=
 =?us-ascii?Q?LMaR/6+jFxLFsSVjA8LdifegMyMquBpNzfbeuJXfmzCvE8d7sq0KcVsoS2MD?=
 =?us-ascii?Q?aXDvIi8vRmg2473pqRiadRo+P5YGQ8OJyhxUwGfTkUeO0dcx7oWxG4tHfKW+?=
 =?us-ascii?Q?AdB8vQ80SVYIY0wrsd6P2pTFSBV0TOE7RZVpKrOLd6Z9JJ3JX7UdTEqS9l5/?=
 =?us-ascii?Q?7L6pd6+K+U74Spvx18AWM6xj4xMpMaVG3fwECrFkThRheOZC+QKtr0EBrEOS?=
 =?us-ascii?Q?41MXYpeF5vzEBxTqN8ExqsREOawM7T3AMy5vXxFmg4eLbi0+cgmER/r1FWZ1?=
 =?us-ascii?Q?mkHZzLsrPljLQUgpOGE9DUlnjVdhlHVNU28yMDRnaqhIUZpG6LL2I37B4rC1?=
 =?us-ascii?Q?E0NdKgY+3CdYAz0SH+6kBMhTdUu/w61u7rmdo839dz+Jki/DkEOFQWOhPcIp?=
 =?us-ascii?Q?vB4QZdRHO2tUIH1VK8oVLaNUMBs8o8NmBqhXNEzRwOmv4k+rEcz4g5w8yFq9?=
 =?us-ascii?Q?3+UGyaGViBAvpG5xlIhYX+NEwKNvXNIVN5PsFMzW9En5euQd0o5w0lirE4dq?=
 =?us-ascii?Q?d6WNmOQ4kEPjrl1G9VrxeCnsqvGmM28LxnxFYIiGd8Wv81XSATg1cj8cVap9?=
 =?us-ascii?Q?OtDW9xi/Gcd+plpon2GiYuXQ9FWYaq7HTkBy2qmxFYpK6f/MWa7y3Su0qOtB?=
 =?us-ascii?Q?W9V9/NURIx26WeW/vZILeQXVC2mg3TYvD+UHMLwEwGGkD79yT2Ms1IgcDB+w?=
 =?us-ascii?Q?++mH+wtG+5MYuHFRXXkZfCAHE13KDO0KX1lrMQhZOhsNhYFtRDKraULVLNDq?=
 =?us-ascii?Q?Y++u2ur4tbnZqscphBbww3G4EoYzu+fisoDL+w8U3JuJFlqQYavfwkh8L4Hg?=
 =?us-ascii?Q?DZ3CRuvv7vrTcjd7NU88ZZe7GDwTgTPPBA5ejT3TFX5ojJk1v2ei+NfuxaBj?=
 =?us-ascii?Q?uVT0gfNKuBmusmk+2GpxWoMUER962xSCsJjoFsasTlOM/k2EBuqA1PnIaCvW?=
 =?us-ascii?Q?NJOyx/1iggclNeJMrv3+W5t1jMukwCaXqkfXkMsGmP9N8nxlTURphtol/zQu?=
 =?us-ascii?Q?hO9VhkirtRaaAl9B5hOa2Mim3NF10r0EYZDtpuz2/XeKaMaDj8pBIcwAU668?=
 =?us-ascii?Q?8BHs5yw/0fsEkf+LBPaRegODTm9qVK+qxu+i5ls5Oln1xLc0ui5Ve4rXubHe?=
 =?us-ascii?Q?oUgnejgBEq6W7whLcbttiRdbYxooNmhTSTi+qIx7d5KHgo4j+X55aoqqRA9F?=
 =?us-ascii?Q?xQg4RI0Ywywmt48GO2cAHIlSjbfiRhXIRf6u5u5iUvN1p6wQmcl4OtryiJ6U?=
 =?us-ascii?Q?Mx2j8eTJxLJlU2rdV+Xvc3XRd8kKUVQayGfzqw1zu38NdpIGrw7OrNQHHPBA?=
 =?us-ascii?Q?WC2lg2I9pJ9yng+MVbsc5Osl4bMIzHJL1slni/NJAyp1dS7q5dWf2mfuxw75?=
 =?us-ascii?Q?eQDfRB4yOiyenO32xqw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0Ntro48KmNf1jFC+BqttgsOl/4jKqPMiBFUpBaRpMXsthbasXtojXj1USp7e?=
 =?us-ascii?Q?gzkA6duBu0/Ne9GdrWzxyJf72pCxdjByiNXxeG0FS4dQr0JHM5adtwcH3eTV?=
 =?us-ascii?Q?siz1aQybCo63yEghOq9y1SYV1GSM/neHzkTyU9f9XRB6ifmH0AhheqVSH72y?=
 =?us-ascii?Q?ysRem7Xcmbz3HcIisu3aY/kR/9+tXfyxI4bsMBSr8djyGz10TiNMR9auphRT?=
 =?us-ascii?Q?j8UgVNSdXwpJ/DV1KayYFBJCDatQHEf12eu1mdEVSO1NozwAGKVMEgbMAPdO?=
 =?us-ascii?Q?LMw07BhI2zG1opUQD3LUwI3xcLzE3rihVJ+/aruVNy9W/OkOr6zVo1hOxeA9?=
 =?us-ascii?Q?F2QJggUoXCJ2LMQt9sFt3M1GoJK9LSZr8YooGnNmwPjD6f8+GNMZI0LY65kt?=
 =?us-ascii?Q?UnPsxyePKzBE88z+ExlTMCdnhlnoPggBF80M08XsAhcWIQYiUs+LJNTIqme1?=
 =?us-ascii?Q?fWAV2F49BQBJQb/2lL2avELVEQKkAJB8c1MkhBkCdK+hxRrOQMPJnxmDTAnK?=
 =?us-ascii?Q?vtmTCMAAb2oenHt/1qiWvHhwxaiCi94qoDreg7NdYC0HanZAmtJXM1WeEEJY?=
 =?us-ascii?Q?9+OEMDi9ZAyBkT8vACGmKrcUj2hV43MU/J4RusjxV0EPuqLm/8Amo/C7BTaz?=
 =?us-ascii?Q?nUGVS6/nBaa9iaoV8K9F4w6PEV9aJewpcfVMXMn88o33dEcwlNsmfvQsLvZf?=
 =?us-ascii?Q?01itQqampelYt0MxnA39LgLIv/YCJc+nC++KspteSJdZHDYf6bdmLTs7CbPQ?=
 =?us-ascii?Q?ajHPQHLTBnNB3/wBDslEqjBqGy8Jx4AVFwv3DhsXUWSRtDT9dmX+pkDv/hgu?=
 =?us-ascii?Q?9S1tlnrN6/vY1oOuIBzpdVhvjAqgYHPgsrpKxipFmNuj8bYh/smIZmUpB6Rv?=
 =?us-ascii?Q?YHNCQOD8WuYot7DVHclnG5c8zOTAOu2gGe9+pUoXbdUssorMIddUHHEQWFGi?=
 =?us-ascii?Q?oKLeMpRJh5ufRfAwJNXKs4EPmCz4Y8tq8oqtXlzRiiTzI4I5AkYp6KIG3MYG?=
 =?us-ascii?Q?y+s0H8VSeecaZXDpx40rk4MY5ID2vdzIFY0ME+DCfhLcZ6Mztm1IkvR74qIC?=
 =?us-ascii?Q?5lzYzqJutEign/g9vu1TfJFNKB7AFwB6ARYLZZFH67K4mfd1gIEI4tZpfoO2?=
 =?us-ascii?Q?drUkMceWefEaD4QpDA9G2sGsVibfP6WhNCxNcfIeYQRgmrqxARBye3QHUs+6?=
 =?us-ascii?Q?3pZaf2aLWkGsn6AmWbEDq2y+PW3FewS2KKur+l+UspvRxV7peWVohu0DBm2C?=
 =?us-ascii?Q?525mENULJ8AYpLABH0/mbN/hVYDYFk0V7zHyIECzHIqLGN/Mata2r9kOx4Cj?=
 =?us-ascii?Q?iUybiGjtfDqKpA//SreDdNvccA69XJfqs6j91I7Nj7yGLSvpXr6qp8oaE5QB?=
 =?us-ascii?Q?jdhjZ79Q8J1F5HK+aInJ6b6TRbxZoRYwy/hr/wTiZ8CkanwfZlEZTa6Cv+QU?=
 =?us-ascii?Q?1gD98ESqQqWHR9DHMVFHV8GmL30+lFf+OPqatqe9/1d2PRDZBnqcO6ZUqTHH?=
 =?us-ascii?Q?oyS7GpCYCwUIXJqZz1RwDXYQhW/pXhnPYAIX8ZNRGRAYur/lFS0qOEL32D6W?=
 =?us-ascii?Q?867KYXKI0AT4ynV/x0hUfohxY7mOXUuSof+xQlZ3RTeqx9wL0kalbvrKQXps?=
 =?us-ascii?Q?09uiq8vxHYuO/htTJiFF9UMZr1hW7dTnA5bbAO5fPcZpS7QLfvYlbILe9eNO?=
 =?us-ascii?Q?zuke5K5Qnhe1QVt4dGh+HP+IC5Twp3mnu+9IowzT69ipckhw5gbiZ62VPO/Z?=
 =?us-ascii?Q?01JPDhNpOA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0157925-7b1e-4910-83cb-08de5916b6e4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 17:58:42.7106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lKiqkKri6+e+s1gg1eD4BV1mX4R2woVi98qO1HiElqItPusfGxWlkuUDj+1OiQlz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF5C5D42165
X-Stat-Signature: qiay9dmw61uu43euo5s7bmwkms9py8zn
X-Rspamd-Queue-Id: 2FFE2120060
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769018329-948232
X-HE-Meta: U2FsdGVkX1/WrpKymBaW4u/C38f4ryVPdQuvBLfF84kKF+B/f5k34dv1rINXEGYUWaeI8vf/7NtvdMIJPJCY7pXeMdG8M9qTTjrLtuOeiXPDTd1fhrZ2xOuX22hut8Y4716M5o5HcAPSlTXcpVp9JkVGR968QgfuhLl/mxyHnheXrulw3Hfsn9s5wmab+XEtOQij/EeQfxvWQ30faV1C3L9pJeYoppMy9GCgPQ/znO/shYajgGC+awB/XW3q7c1kw8fhmo7xRpPmjQexmSrhcrAaboQjoGi4xsNnzCZ2/FsWFgvLheoQZSShXcDgJMoatQsQtKm1vdjhYDFcpwmUAAqVzgOVe7IRdCMFzBQJ5owkuwKw9V0nJlRDeHaAA4ve5SDVS3x4XsaHRx8mrJzm28bKFoylYtfu9krqLeeCSMZhnfemLa6/kjQVCUngGbYqg/WnkgF2egsMMXdWF3vYBBQYlNjoh+qo6j9ZShpsDWZxwnNZ1PkN2g0MbOTDAd9r97XXFqjD07DymlNP6K1Z8Ihyzl5GLKJ8+DrZE1jC46wOXCUuwrWxVKt2ArrkBnBaOlWH6fC0ZMxSAEYx0BDYNPDbQNBKXZ6ukv0fTCIoCFIdcQFWfDiQU9xSzi8N4Fq2Mc9pm+dlNmVTdmIVOUErQup33ZDQgYEJE9qwCBN4ey3PDn1d5vSniuDbIntOJS8kOHZ7wK4Ix1UVza3I//ZVIY82S9PwafbxWJH5Uf7bq8LweZ0cRd6ffBv4JEm3JNt/FeeQeQWEZRWMLFDl/P4aY4KhKwfT16WZNshK+xeQqYPzEILX1rfhL71hroD39OI7ZlSPeFz6VnaaAaTVpnNuxfnsgKBlnt7lFSJWPkfO9TfTnD2O07qLuKOmi0QQ0MeW8E2VDK58FkZlGGWnc8JeKwx0EsktUoE2JXwvhJJplYcwmwUqt4JIjI9/MFje4xw/G5+1jOR5jk8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21 Jan 2026, at 11:22, Kiryl Shutsemau wrote:

> If page->compound_info encodes a mask, it is expected that memmap to be
> naturally aligned to the maximum folio size.
>
> Add a warning if it is not.
>
> A warning is sufficient as MAX_FOLIO_ORDER is very rarely used, so the
> kernel is still likely to be functional if this strict check fails.
>
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> ---
>  include/linux/mmzone.h | 1 +
>  mm/sparse.c            | 5 +++++
>  2 files changed, 6 insertions(+)
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 390ce11b3765..7e4f69b9d760 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -91,6 +91,7 @@
>  #endif
>
>  #define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
> +#define MAX_FOLIO_SIZE		(PAGE_SIZE << MAX_FOLIO_ORDER)
>
>  enum migratetype {
>  	MIGRATE_UNMOVABLE,
> diff --git a/mm/sparse.c b/mm/sparse.c
> index 17c50a6415c2..5f41a3edcc24 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -600,6 +600,11 @@ void __init sparse_init(void)
>  	BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));
>  	memblocks_present();
>
> +	if (compound_info_has_mask()) {
> +		WARN_ON(!IS_ALIGNED((unsigned long)pfn_to_page(0),
> +				    MAX_FOLIO_SIZE / sizeof(struct page)));
> +	}
> +

16GB is only possible in arm64 with 64KB base page. Would it be overkill
to align vmemmap to it unconditionally? Or how likely will this cause
false positive warning?

>  	pnum_begin = first_present_section_nr();
>  	nid_begin = sparse_early_nid(__nr_to_section(pnum_begin));
>

Anyway,

Acked-by: Zi Yan <ziy@nvidia.com>


Best Regards,
Yan, Zi

