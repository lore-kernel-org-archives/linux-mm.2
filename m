Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21F21CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 15:44:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5874E8E00E2; Fri, 31 Oct 2025 11:44:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55EC58E006C; Fri, 31 Oct 2025 11:44:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FFE18E00E2; Fri, 31 Oct 2025 11:44:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2601B8E006C
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 11:44:57 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D88524A1D1
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 15:44:56 +0000 (UTC)
X-FDA: 84058832592.30.965838B
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011033.outbound.protection.outlook.com [52.101.62.33])
	by imf28.hostedemail.com (Postfix) with ESMTP id 02E64C0004
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 15:44:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pWt5TLKs;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.33 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761925494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mG5csVTfqqch1OO4TKNLD8Fap84kyZcJgKJQFGPLET4=;
	b=JCLoGhND/+P3ncQPEW8/Bb/cbk94Uz0SGUpuzc5muNAUpxSrt61jA92NP/2hYMpQGaZro1
	P7PhG1sIQpSx6lSLT+w5PI+lUd6W+COBMwbHBh51zavHD85Pn28B9W4spSMhahlEU0SQ2e
	6jopTcHWv5DEY48dzS1P3fjA+/WPeBE=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pWt5TLKs;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.33 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761925494; a=rsa-sha256;
	cv=pass;
	b=gMJUDw+dUVwOhtzbCfuUpPQJpatwUHbwP7panyPHWwGNe0mPaKVzikrfP5pV5eIF7nuuUk
	F6jmWRWnik5y+FF0ST50kjlVylE1VdrCE841LCqnivIO2o9tfOb+ulfCvfju6kL+Ydu6os
	cjqxu5CmF5YW14UaN1X3pP7oab8GhQY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qHORo/AIJBAemuLFwIwKnfeRuJXy/Vq6azRfX9xPRdRZy9FgfS1vRXtZ+2umMLTh3PP8TclV/svUgqszEzIs0cSGiW+gQH/FeARuQOLC80xnTwrSZI9n5mY+7Z5frVPhDQ8qmCPLbP7fVW3tEV0CxP8PG9q1WlvYVegrmpP+U1DjU+gHhib36J4DkF/FqzSd4xMQSms196d3u17yA8fRfFqC9pepZtIuDksVXEjJWmQqInb0S7WBUzNnH7+UgwXqMg0YW6bBJNWz4eGlWIK6XT8GC8DZp4DImptnIjJikKEX2UM5ZkWs9SGh6dlS7G+yH3ylOhx6LVJqfZtbkJp27A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mG5csVTfqqch1OO4TKNLD8Fap84kyZcJgKJQFGPLET4=;
 b=JJ6Eay8iPczZ0v9y87Q9Ev+LTo3s0iGD3Wbimtfrw4obXzNxm8uMyv1wPpHceXqDWOB5Z+iZjLzX+LIh8JfTj7LrdW8iKFk3FctoyC1YVmvlsvim0fgB4mvm7cyqYBM35pdlKQ7iuL5QPwHJSj+cY6G5qsJBvYO58iqExRt+7TiXXMQ2WWbYgM6Tx/JoTd00aLktZZiAYVygr6mcO5zmqEQGlF4LSgZUTHFgwmIeM5L7gatS9ndUocUdOoWqHPFe4OTBIhZCHMTvG3DHukJ9hhuQ5HiBau6ahdnK9tQzCiyVri+XsSvWextRTc6+qQKFX7xG61OdRds2dowJCIABZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mG5csVTfqqch1OO4TKNLD8Fap84kyZcJgKJQFGPLET4=;
 b=pWt5TLKswgYWGFfO9SYfXgh2W+vm8d3xfTuBU7ky2OfdVQZjXgr3uOWEjtPMEvdHKP1zOP93hNVTe5HLaMqjou1e3t+Q8l5e+xrdn/2nBpDaa0CMeePiYhsX5fE1Pq0W2CtAexIuLofuS9TF4XKHDtbfzqUFjOgf31NOr32oVn343EX197eOtdbl3HGmASrad7t8Y3SAxTAHg9NnUDHTX1UxlFpPY9JGb0POD32mPynrl3W/txrvyt+Fvq+SGjzLDnfblRJD0l40K61J8qjD34x/LutIIo15ws7/hJa6mw9iQxuGk0X57r+/lu0j+y5jWa/D9Ra5qMz5m9QxOLofaw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY8PR12MB7730.namprd12.prod.outlook.com (2603:10b6:930:85::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.15; Fri, 31 Oct 2025 15:44:50 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9275.013; Fri, 31 Oct 2025
 15:44:50 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: linmiaohe@huawei.com, david@redhat.com, jane.chu@oracle.com,
 kernel@pankajraghav.com, akpm@linux-foundation.org, mcgrof@kernel.org,
 nao.horiguchi@gmail.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Yang Shi <shy828301@gmail.com>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 3/3] mm/huge_memory: fix kernel-doc comments for
 folio_split() and related.
Date: Fri, 31 Oct 2025 11:44:48 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <4F8539FA-4D4F-4A96-87E3-F2AF20B80D11@nvidia.com>
In-Reply-To: <20251031025551.bmt4wh6e6tmhcr4i@master>
References: <20251030014020.475659-1-ziy@nvidia.com>
 <20251030014020.475659-4-ziy@nvidia.com>
 <20251031025551.bmt4wh6e6tmhcr4i@master>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN0P222CA0023.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:531::27) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY8PR12MB7730:EE_
X-MS-Office365-Filtering-Correlation-Id: e9b18074-1f68-4c95-cace-08de18946d60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?F28Yq3mKkIRBOYqRjOy3T5Oppd/BrjjqCWzkh41a7liSzv+8OLzW5UDakywa?=
 =?us-ascii?Q?cmNkg/d0BTd2jcSWdFyvfWmxXUhkLguz+lzFJrplTD4kgbbsqZwNZe+3BLJA?=
 =?us-ascii?Q?eVkQMl3QKzP8fZ50WV6U0Wlt2YjoK9AivlTAUgN83joykMhujdDIIOTuL4Kr?=
 =?us-ascii?Q?HF4x07hCTPmzd7nNU/0nc5m7AyIEzbWvoiH1yS96+2hp/dc24YgDxqBbLxAI?=
 =?us-ascii?Q?LWKTVo46bQbskuzPiclU8tpKq093F1yP3mGQGyYuXKtNsps2ZJHfGVgnvYyx?=
 =?us-ascii?Q?/quiZAHbekx5jL/er+6DeM7XL4Dmg+Fkisny5/ncTgUQIhaNXU4LJtctayIp?=
 =?us-ascii?Q?dZ3Lc/W9rEJ7xohAdGlFHApmCywVko3Lg/1dP8W1ln5RNu0ukMgCjxpMmXas?=
 =?us-ascii?Q?49+2GqIHEW82hZyeHY1XuJB+KvipLEu0+0i+EJpcBbetqk8QsbvA281X5MO0?=
 =?us-ascii?Q?esn/fjYBS7y09x8FAVeSVTrBX8I9GD1BKYqCHsuIvC9ZvD6U6IajkSQogwd1?=
 =?us-ascii?Q?eAWhUT6cL1vppWbPbWUwGtTiP0MfwR/Q/D68QmypOiOQZC/nDYIjTTmLa72V?=
 =?us-ascii?Q?qXL1JCHnrpifSaz1d+Xy/hrS3ZyTzBSxo3AmP6RoA8YjuPSlj3SjBSxjL9+N?=
 =?us-ascii?Q?GqTLXU0FRUxWluE/4aEK5QAu+24+ZZtd5StIyBPU/C51aLwvFdeg+lsS+0qG?=
 =?us-ascii?Q?QQ768IP8Qilnx3+WiS011JVQaN5lRK9b3svNNNcPKIBKRnPn2bbM8ZLAHiV3?=
 =?us-ascii?Q?XOQ/KZg5QsbM+n/FgBNZB0NE/6JmbJqdzKSNmwJFQkqpaWOGkovyW+BzQzgE?=
 =?us-ascii?Q?gkVbelzhMOSuy9OKTimq1PeXV1gYRy27f0gUG5/E/nvlsMR4EBAE7iq7q3BE?=
 =?us-ascii?Q?bYcJTAuyPUKiC4ieRVxonJDIbcsfbXpDgwoIip/27DR/YyRJNaPkzPXp+5E+?=
 =?us-ascii?Q?CPN0LjRRfVonc9MFIi7hBFfSApcyVvZhZaXFPJn94KA9nQXLOkjRUT02cDQ5?=
 =?us-ascii?Q?Oqx0m+ZErSHKEXxyqlmExp6HodJFW8fZXYwfgKME8cH7XU0P9qk8Szv+Y2W/?=
 =?us-ascii?Q?VSwNnt3+jaysYglV7ev+xaj6jCohgNvrJ8IiAzkQE9z1T4qYyODoyD5MFUXx?=
 =?us-ascii?Q?QznEMPO1aIvFeGJthR9r0jWze0usEhe/mojBY4ZqXd8Pd8qr9A89Y+uJC19R?=
 =?us-ascii?Q?g5auTXFVIB6kJ++e7Sh3sP+fJLaMpwYQqfNt8CB5kTGsZPzwC81wOD7yCHC2?=
 =?us-ascii?Q?gBhyzkyNxzRqiJT613S/HUJ2UFywvTdWnT2wU5py1sAuaw6xFld4eIBz8Ukl?=
 =?us-ascii?Q?6mkkbkFbp0mgUsdnyrj0zRGngVYS9Z0ezWbZQA40TEt8cXtW8gHXeUDJ2uk6?=
 =?us-ascii?Q?TIZLJDOLT1VeM94PIdzshur/WSSTjAknU9pCdcPISlA/eI2f8+I/DKFZqmPa?=
 =?us-ascii?Q?9HYLHzkRIqXF1pfbmhBw6E/06p7RKLHh?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6n9pXa8VTSTd7FSIDKUsKoTKij4hR7TqI8rzAokIF6e044nMf2qxQ98Ios3a?=
 =?us-ascii?Q?dxQrsiiI050QWmLGCw7r1SoP3V9v/cJmcy6NHQ0YU3jxR5JR4mUQGRyJ3mVH?=
 =?us-ascii?Q?KClZ2YFxN7y/HsZxUcbiwQ/oRYsqcvr6llF6QZMktkiib2d0mjNzYsC7fEiR?=
 =?us-ascii?Q?6PvvYI/uxBwcG873c/VInLKSEQ57LGMAiNe0gJeB7BxXcm/BhUmQnJ4mwW9r?=
 =?us-ascii?Q?FsMYy9YqtHlmAdyh+LMjAEHl+dD6DGRvf7g/zOeIUlTpKbuKMkQ4SUZl5dBM?=
 =?us-ascii?Q?taNmvy+hZ61a20ZVu4RJk3FQs4k/xu8kmCTIorbykmIcodAn0ZxHdj3WzFmp?=
 =?us-ascii?Q?y98x5bRea24wM2ag3/UCoKU334F9sFu1NQFJdRUfxI5Sr401VuAkDa0yLB7K?=
 =?us-ascii?Q?LBAiYhCAOIt6WI50ovvCvwZy47aRt5VyL6mBnQ9oUUAZk6Mio09VkE40UTlY?=
 =?us-ascii?Q?phOZz3MRgtnimizDvYSVNXioCULPDl88L7B7eGP3nu7S2X2xRaxHk72VRynz?=
 =?us-ascii?Q?uQ9MFyBNFz8cAn4AjPDkgTIZd3r0ACpyQo6XQUsznMtG5ZwmCOk2sRlmeLLF?=
 =?us-ascii?Q?tqPx1t7j7aPqgEv1g9hIOv0bdgp3EW4T99qoqSj12v92AQdxqcmjSI9gARWP?=
 =?us-ascii?Q?DHWeKew9q2uJ9BvCUe9qFqyn1bElvw9PTPkOHpZ2ZW/DlUByyMqRxqlGfwUg?=
 =?us-ascii?Q?9JaKkYPwj/CxK2w495LXuoLdK76HbA0601tPqY7KMDE6VRaqBZLjD7ojrq5n?=
 =?us-ascii?Q?JJ+1W0XHEbl0NxL7SsMXQkVFSyZzKzpmT4R5IlwEDqYQmLuKr+13KDh/Tv9U?=
 =?us-ascii?Q?wikDW5E1XX6AvI5AXrs7AYci+3+5Pb7OnxuQTMTjNj06FjH865OFYyPcjFob?=
 =?us-ascii?Q?dS2z9PZ5So01NZbuJ/U1lhg0AI3vgrsi7GwK3jA1vJExQVt2v9crjwaQqwes?=
 =?us-ascii?Q?q5htJQM/jgUOAFY/hK0uUXkXxK1l3Fnh25IOoQqDrt+d/qmQHDZarOjLFd1Q?=
 =?us-ascii?Q?OL8Z9VWJ1jhiz+g29eaXACC6Yf/xjWhKqmWM5xStBO5oXBbmBHIYUFH8ZykU?=
 =?us-ascii?Q?XbrZUqtczlmaKKZS5y9v1AJjYVpAyxkM2VrMMkKbAn85CT6gKWg2BFfxxSeH?=
 =?us-ascii?Q?0esw+CB760GcLY8VYEzw68hmbMUmbbcGrrg1l6ITHsu+jXozR37kGtORWoSl?=
 =?us-ascii?Q?3G0yRsAuyxW5l8XPBAzeKaSx1MxUHBEjcoWaq9utldZRsRxvc7XX4wS2leOE?=
 =?us-ascii?Q?KCxCzQzv/lZTFvjXuT4yWfAchDS0WBjSZ8/CCPZ2V577nIDWF2Lp5CyqhRAO?=
 =?us-ascii?Q?Rtsv9DYTKXShY8gU9zsvds/eZFoK8HGRgIDXLMlY/OekcHPQKg7O1lxclgCr?=
 =?us-ascii?Q?XjLKP9NC9wxoxyIn81XeFsfhDF3CsXk3SklTCEfA0UL7ufcQqxiafcVr5Yvw?=
 =?us-ascii?Q?t7Wgo4po51hzvsjG/N+8oMATkrZNwJOYHq/6ZjNcOMQs099fIKVQnilfKp6d?=
 =?us-ascii?Q?WjxK7VYq/i64ysj+HwrbHw7Mg5A8UJHDl2hfGoOYVpA5WtjFX+B1P53R60m0?=
 =?us-ascii?Q?YlHLV8eh/jCFnClxzuW4h1MdVh2gt/5oIftfG8O/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9b18074-1f68-4c95-cace-08de18946d60
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2025 15:44:50.3707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9ghtVA9a4pbWbUmPEOUHkYkTaXZOm26oV/e0BMnNF5ythO6GPUOt24bWNuU3mEzl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7730
X-Rspamd-Queue-Id: 02E64C0004
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: cdohfgf8x9qpcq7osxh61ejs1hsigqip
X-HE-Tag: 1761925493-932237
X-HE-Meta: U2FsdGVkX1/kMaqPpwgzEsVPITz5nELUnfrZU6YeWlO/IJZyV+5v9oI5V4R5UVkvPbg9rY3Zkz7psRaoQQ3OL3FrvwL9qL5oTeAwCcqWG4SCZ8JY7O8bwZEZpw4tZ5PZg+i39BVLhikuRshTnZpB8eSZiH/9Pfp6NI9Nokn7QeMf8aLA9zpN3LNyK/US0lhkE7xAQ4mfg0HAz4a9ncXI/Htx6fFTncwY8uuFZPzxVHW/0VU54nPXA85TXWBdW7TnChlPJLgP/VA4weK3c0wD9QCczd3Mw4+nqBXGV8iNrX71xhga07o1ztkpy5yRQdL98pntUQAcMLPgF+epR/mtyz2QzfmD14I77bf4JUqUoWSXbzxOUmp8Jh6wTgd6X6BIeci4pSf3vnppOzljcgnIW8wsleN2MG69b2WcihZSno3nfO6uKujp5lTbVobgwC66Wn5+MHyDc65mPPSkXfdYr0wALvCEWuYP6Qa2Dq+wiH7Gbdr80V2wfQstfSQJGMXS9d9IyBhelCrYXkQT5V20IIlYQYnmcC6cZIw4gZuCLwenvSJIG4WJMJGmVLdJXIE6mpwFPuzyHb+iRqh8ZHn/DWYlHH2T+Vv6KxEVmhRdfYdl3CB4iW4bZf6ZH5Nk6b4witxRzXSBFKvIzF43s7ksP0c5F+Lbq3hUVzq8l7RVcITzc00RYhgbKkqHO05TOI5z3KHG/TUvlyu5CGDUP4f+upq2hBgB9wVicgLdvJxZpQULYJwbxoLqOOZe/kJ2isePXPtzaI8BW3VJGhsrrrr29QWQUHriXRQPQVMb+AKVf85W61lRuMYfAzJqkL4yYiZAAlqo1W3ZyqOoQkd4ePVw8ch8KudHJwx8xYW6N/XWnLfWpA7ra86I0E1iGekpBvb8tklkio6HiT8dviUS09V+5yOfsw0x+Ymz1RrQfNJrzgFdGVDhr/q7xOOgyCMr9NTF+ffELBhL0YGXolU+ncM
 nbpLGjYd
 YvqsWCtfddghNqwDB+O+cmEw9vveNRF0/AKoSwMM8wK4r8oSHV4kjrkBGKWZ5MlzWG8TtY3jOJhb+M8Zb31dzkd5Vwx/TS9ElIGBegYCM3isx6rQafrRgUvgUDxTvMFmEz+VkCCoySJjayzQjLdHP+XXqxEXZTNlGJ8gBGcRJ558EZnzYACXufSoMbz+tPSKaSRWYOe/UrDmoHVhLKD60mk0SniggJmr6Bqtv6ebr6EYnxndn8oIUGNTGd+2uKQibFZ/rb3eSRwLL7QaBtUWm/NEH/3/P/H8R0TeDtuSrGnQ7dt9IrK2k6D3Q0xrClYA6mawT3+AhCJ6nymfpsHNjaVjw/FbQImKKnkhxOPqfOIWj+QtWlQKIgjIi8xWXUMTmKkOKHMEefdNssGQmodMmgfM+od5Ecd/RsSZlwewtb1yeRp5nOgbpO127TIJPABNqwU+7j4kQWiI6++rPPzm5e0PIwgOlUqjpS7cuUc4ZYZMfIQnRUlKaQaGOIu8GQjrFOm7vG7V2Peg6CQS2QLgulF7vPTlimF8unY0oC3SmHp5PIw0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30 Oct 2025, at 22:55, Wei Yang wrote:

> On Wed, Oct 29, 2025 at 09:40:20PM -0400, Zi Yan wrote:
>> try_folio_split_to_order(), folio_split, __folio_split(), and
>> __split_unmapped_folio() do not have correct kernel-doc comment format=
=2E
>> Fix them.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Acked-by: David Hildenbrand <david@redhat.com>
>
> Generally looks good, while some nit below.
>
>> ---
>> include/linux/huge_mm.h | 10 ++++++----
>> mm/huge_memory.c        | 27 +++++++++++++++------------
>> 2 files changed, 21 insertions(+), 16 deletions(-)
>>
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index 34f8d8453bf3..cbb2243f8e56 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -386,9 +386,9 @@ static inline int split_huge_page_to_order(struct =
page *page, unsigned int new_o
>> 	return split_huge_page_to_list_to_order(page, NULL, new_order);
>> }
>>
>> -/*
>> - * try_folio_split_to_order - try to split a @folio at @page to @new_=
order using
>> - * non uniform split.
>> +/**
>> + * try_folio_split_to_order() - try to split a @folio at @page to @ne=
w_order
>> + * using non uniform split.
>
> This looks try_folio_split_to_order() only perform non uniform split, w=
hile the
> following comment mentions it will try uniform split if non uniform spl=
it is
> not supported.
>
> Do you think this is a little confusing?

It says "try to", so it is possible that an alternative can be used.

>
>>  * @folio: folio to be split
>>  * @page: split to @new_order at the given page
>>  * @new_order: the target split order
>> @@ -398,7 +398,7 @@ static inline int split_huge_page_to_order(struct =
page *page, unsigned int new_o
>>  * folios are put back to LRU list. Use min_order_for_split() to get t=
he lower
>>  * bound of @new_order.
>>  *
>> - * Return: 0: split is successful, otherwise split failed.
>> + * Return: 0 - split is successful, otherwise split failed.
>>  */
>> static inline int try_folio_split_to_order(struct folio *folio,
>> 		struct page *page, unsigned int new_order)
>> @@ -486,6 +486,8 @@ static inline spinlock_t *pud_trans_huge_lock(pud_=
t *pud,
>> /**
>>  * folio_test_pmd_mappable - Can we map this folio with a PMD?
>>  * @folio: The folio to test
>> + *
>> + * Return: true - @folio can be mapped, false - @folio cannot be mapp=
ed.
>>  */
>> static inline bool folio_test_pmd_mappable(struct folio *folio)
>> {
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 0e24bb7e90d0..381a49c5ac3f 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3567,8 +3567,9 @@ static void __split_folio_to_order(struct folio =
*folio, int old_order,
>> 		ClearPageCompound(&folio->page);
>> }
>>
>> -/*
>> - * It splits an unmapped @folio to lower order smaller folios in two =
ways.
>> +/**
>> + * __split_unmapped_folio() - splits an unmapped @folio to lower orde=
r folios in
>> + * two ways: uniform split or non-uniform split.
>>  * @folio: the to-be-split folio
>>  * @new_order: the smallest order of the after split folios (since bud=
dy
>>  *             allocator like split generates folios with orders from =
@folio's
>
> In the comment of __split_unmapped_folio(), we have some description ab=
out the
> split behavior, e.g. update stat, unfreeze.
>
> Is this out-dated?

OK, I will update it.

--
Best Regards,
Yan, Zi

