Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AFADD2F33E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 16:29:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD8D26B008A; Tue, 13 Jan 2026 11:29:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A85916B008C; Tue, 13 Jan 2026 11:29:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95DBB6B0092; Tue, 13 Jan 2026 11:29:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8684D6B008A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 11:29:18 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2E6091A938
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 16:29:18 +0000 (UTC)
X-FDA: 84327475596.19.2911955
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012060.outbound.protection.outlook.com [40.107.209.60])
	by imf28.hostedemail.com (Postfix) with ESMTP id 470B6C0010
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 16:29:15 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VlVbgTwZ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.60 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768321755; a=rsa-sha256;
	cv=pass;
	b=W6+sJvJ1XW+W0xVNtlwkCP6BmNyNhblEPScnbyFBZDrWhBdXM7rzG/ZLLEs946yO6DvpdA
	8pxCZJiMofULgEjowSv0bVuW9pgSccvEuaSBl6K8ZpOVtuSBgHLLeQP2W2zDPgfPGrRv9R
	l+D9/BB1xlrzBYyG/lbxO1R7EJC8STM=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VlVbgTwZ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.60 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768321755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5SmIb70XK/BiC2ixcpJIooBTBiPiaIKjtk0AcbnZiFM=;
	b=FZ86VHPOEdtcOKPAyXZswh0Uimdd8c9bccZIdz1ax12VMzC2tfGHpdK4sJiRp54KAj0EeL
	81+qmMuvBaquzkHz/+/QDz8rzXAS1ZHWr98ZdGnA/mYsiFP3/IxbhQy5LokwH7/XUdQKYH
	jEsiKqenNoEoatqWGmJCeh5lvlEbYtA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WpbiAFdWUN8tWBWSqh2jqhP/hA1aNJULKkigcnu0VfO7tLA5lWfj3LVsuDNuOxlevznxzE+/YobHv/6ZY8FVIbCpoLfnnZLlUg2pwjgFLaPXoWNb9/4WsmxNYwjdsX8JwOBog6Jo1JKEV9kutTj0aHJQTGwO2kYVxFrUAlLjIp24fs0YFskuWeCCvlpla4r0W+2iHWJydzK05JsXIgb87FNbKYkHisw1qZJHLw+cOHfQVRkeKGKxaxGZsBCx1omqAZLR5kqPmjSgc0pMUv4vvRKzudJ4mlfsTuxxgwXgtvuU00AzgAS8AiGzklkZn+BVeo3kjZcApdMQca1XhTwcEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5SmIb70XK/BiC2ixcpJIooBTBiPiaIKjtk0AcbnZiFM=;
 b=D+Dhrsme35jNn2oala8gHjujLLWiAtPBzZh8X3ua8/F19KdzBbhM8i7IaWzToKJ4/Yv9pw8j/uRoZBeJ+doqWxyV4wA9EtDew0LTLGdZPkusxSR1F/rAu8ENFAAMnOzFKPSHogtmU6lCxYQbPfTHbweXDnQInpyNKXL4NVQa6i/OZqjKgbRecbGUZnWSJWw3xvEDXFrQCN1hgEBAJsLcWj+G6tvQAaEo9J6CL00OQpdu8jSVGEgvJ6R0PvPGJi3oXn9zSQi8emhidVkB7CoQ6dR6Hj/i0tgruukz9k18D9sa9hiwFbD9poQqSvPFOzE6Ajd7m7OcPkC+VlVO0W7eVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5SmIb70XK/BiC2ixcpJIooBTBiPiaIKjtk0AcbnZiFM=;
 b=VlVbgTwZhyVz0ib+TErTap9ye38ndqgURcdyNfcv0Pgq747WMZg0w+pL/5iKl0aCTak57o4GZOmBMWODP7W00YN+xRUJWKVfTRG6oojflxsZpwaUfU2/vizqD4KFSGOCpPT3PLa2yQlT8CN/rkmR9SuajJ8QMl+76KyDHBQIvAosu2kqsV9QgrE9gH2xQZZBEEFy3nZIybpj8zMwzwGgCwl7Q5eKnyVBvwjFzS2uZVdyETyC4hvqDdi9LGiXw9pvcEQL7Rl7Bpw+91jgfxYeByWiMWiecerT4hVCmftLEWAz/hCGxMQsCaICBZn+POBT/IQpeDuglUYXhsJfD/CH/Q==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV9PR12MB9759.namprd12.prod.outlook.com (2603:10b6:408:2ea::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Tue, 13 Jan
 2026 16:29:12 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9499.005; Tue, 13 Jan 2026
 16:29:11 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 sidhartha.kumar@oracle.com, jane.chu@oracle.com,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 4/5] mm: hugetlb_cma: optimize
 hugetlb_cma_alloc_frozen_folio()
Date: Tue, 13 Jan 2026 11:29:07 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <B5B632B1-A4C4-4A5F-A125-FAAECC1EC304@nvidia.com>
In-Reply-To: <20260112150954.1802953-5-wangkefeng.wang@huawei.com>
References: <20260112150954.1802953-1-wangkefeng.wang@huawei.com>
 <20260112150954.1802953-5-wangkefeng.wang@huawei.com>
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0038.namprd07.prod.outlook.com
 (2603:10b6:a03:60::15) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV9PR12MB9759:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bb32d94-fe77-4db3-01f4-08de52c0e25f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uyD+3s7/6wxDJyuCsz14AExMeso5vuJBzD173EEc3wsMBv6GcdpH3c9kNXxu?=
 =?us-ascii?Q?XrYl+76OypfmiSpIzicfLUZy+4dBCjTE7YZQOb+m0BPj7aBo5Qyi4dHpe6U6?=
 =?us-ascii?Q?1C1I3vjXDSmlXkdPhHcT1u3y+911n65/Glm0q+Ku/hRsoB0h28pdyGGnuFji?=
 =?us-ascii?Q?s4kgl0cC/33wKlllrh4lUkf8ZC/uo0odozkDI1RC+EXxfMOklpLkExg4+mgs?=
 =?us-ascii?Q?LyxD99WhIinYn7/hZtDmxuIzsLAGuzqYJeXL1Tl1g9emjpQ2fxgTjOhwL2E7?=
 =?us-ascii?Q?8XiZQTMCb5jzRwrSYmzmAsMmbKNPPL4yUvRyAp/10CibIJ6dDExiDM27GWhe?=
 =?us-ascii?Q?wwgieHQzWXfKi/UXZLOYnJeHGtrXeaJqv6aeRJ+tNJ9pCHmorlissdIeAjFe?=
 =?us-ascii?Q?BS8ShaVYIjw0dkmpXGQA1AeW4MQZ+jEHvoKP3t2wzbFSHhyyF/C9k+oszOr5?=
 =?us-ascii?Q?uDViSWnSus7jvF6XGy2eU/+S4f5tUwog5IusAQ02iYVpHshRubkqAksIl2DO?=
 =?us-ascii?Q?uCcBK9pydWzjTGY5Qqs62t23jCvO+dbojPBwgDGXiX6vTjlIMbHEKnTAZvm6?=
 =?us-ascii?Q?bivWxxqJ9fMgAfr4j7pAM8NMsIrkmpBjfb0AN5GcGtP/Ex8KirM92ldwl8K0?=
 =?us-ascii?Q?3TMjc23yjcEW8G6VKmGRtE49v7ETP+BOtbazoXPscdLKITRah3WtekM6sZD7?=
 =?us-ascii?Q?jhM0kR6Y2EpHoBHRT8UTHbcgztYNAhvK0m6GNZPNx0ug0SJ7O3wsKDse9rBp?=
 =?us-ascii?Q?xBSsHKQDffh7uKoM7+LN7qF8bWhahO4niNfhvrf/IUrTY0GzqIjiTlcv2z2t?=
 =?us-ascii?Q?HtEnmJrK7unQCB/AZkdMoyo7juuxRXoluv5SGJad6IHJwoE+6qhIDGOnpK0+?=
 =?us-ascii?Q?gtMoy3JwLDZNupbIs+VNxrJe2DEjX7VXZNTCOg1xBJdr3x9gADTG6adAOY5M?=
 =?us-ascii?Q?paLnBY4TWICbynpK9DEBhoEmomG2dofbHat0nI9P6rV/Yl9RslTjJSLGTa9M?=
 =?us-ascii?Q?BrJkbYfutgoZG5pFeRIp2qAtDNI0ELMewQnXbcsUWeWvolivWxkwq9fWthM8?=
 =?us-ascii?Q?37jAxGeQoFQDO9EafTRNlHPEgeabCsFQGT3mJgnUDT5RklYKYmn12oNfjPZb?=
 =?us-ascii?Q?mgH3SXgav8I6WSBV+OCp5AnHkk/rC+Hl3qMh9G/cKTuAJIMRxHSNznqRvHGr?=
 =?us-ascii?Q?2x+SawS2y1it21+4OYLzwhd+eVMZUtck4/J02yDfecCxaXc67Kc+9CYa1enq?=
 =?us-ascii?Q?mMeJAauiNEh3sKJ3KXfVvdGiXLR8mgy9fYd9o3Lw29v83i+Fv5pTMuGU6Pnn?=
 =?us-ascii?Q?TxNm+cXsmiGJ+WjrJTJgb+2nklT37dvHZPuwqXymBPkVmNAYvkQPidE99m1b?=
 =?us-ascii?Q?U/zckzzU7FeRz7C33nrDV0Aurme3mTh4I+csvioqw81KIEwu78oqfL/VsU7r?=
 =?us-ascii?Q?WCETm8uiRzEnf2lakuOWiQu873BriHJj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eUtjawnHndFEhjSHr/OOsg/jBoJmdeAI/ZZWHuyGLRxYINHLySRj3IHqKBVu?=
 =?us-ascii?Q?2wuxTGk+kN9ePG8zqWzw2ZSmQKYIKJXVX42mnW+pvHoBGNUFlbzDB4zSYB0W?=
 =?us-ascii?Q?Q0rGxHUGoug0A1V1PVBYX7GNLbBitSsg9nci5XuZxY5oVgE7/EgWv5Crmlj0?=
 =?us-ascii?Q?AuQNT8tOhxCj7A3AHJX4fverYTv+cOV5fhJR+ivfNM+fJoYkSRJbqF7Eukwf?=
 =?us-ascii?Q?qrf+qOXxnbZpNUjXlszIlESEmg6r+vMxwo4CWkxPlpZhVrIUSX8ZCW/xd2H0?=
 =?us-ascii?Q?gtYh0HwKPohEeLHo7FtEuvafU3Rhlpk37p5R/OBQ1iCA95MJq2FLZRTik8nj?=
 =?us-ascii?Q?towSvJanhbdTH5UEaxoLrSqna5XQ4xerz+e4PU8M7yPWLLWUJEbNlft8KGb+?=
 =?us-ascii?Q?FLvRYaNIz6laY3gPa8x+/ZkhE+kLHn0dnPMzwmdAb1BR+wXDqsfmRsNgFfD+?=
 =?us-ascii?Q?SYjyOdJbNE+LFQsekLbWELlwzsJ2gqKZri62KytQY4PFrUNQOKvnCYu8rHu8?=
 =?us-ascii?Q?EFlv2yYFZbpGvheEgzMJJAOdgohQZcUlxPJv51jZxh8+MZ3UwGiex3wtVLmD?=
 =?us-ascii?Q?EaoIaTEoDTaYWSFO70WUHyv3KycwycqDfkPYmVjYcZ7v/tnAwq35nA26Cala?=
 =?us-ascii?Q?Y8L5uuKoJqEBJGCiBJu2vM8thiqqHN0bmz1o0ONAf3CuOWGGXMvlNEnw+ghy?=
 =?us-ascii?Q?VK2U7Ipo2NPJ9IUco2coYBQeIKjmZtZggaYDjrMIcBwUmke6Lxv/x6wE+ekQ?=
 =?us-ascii?Q?2XDnL7Tn/JsAthc7SlCNqtEzJImKD1lNwG5kBqJqlZCJDDVcrPd46nq8+YH7?=
 =?us-ascii?Q?rNanAVzOJ2lv3FdJ20hnmpmZHUhNJ7fxIx0QBsO6LS0/QuN3GH1ejQOauPL8?=
 =?us-ascii?Q?tYrGU90W95P3oVGYmT8rWVrb/pukJce8mDckbFb8ouTvfNJJ2jFT6VT5IIMG?=
 =?us-ascii?Q?L7mrgMYOJWEo7fJbA5NUCu719endiOblv5HZbcbPxccJ0MA6A8+Kk/afsCWo?=
 =?us-ascii?Q?2i5FbnYejLdxbWA4pcamZ0WCldO/exS2Uj5sd0WyUA2J3bwhjf8AAOIeL4YB?=
 =?us-ascii?Q?rxJEZIhR/Et6vIi6ixANXz6RC0OwhuVJBiujtM71LeyhbRPT4SRx6VLCWZB9?=
 =?us-ascii?Q?DOlFmk4RmJJimk6EhGdNm39Sm1R0RpXdE8C0Kl5hx0iIrywShoHWCNz8wGTw?=
 =?us-ascii?Q?M/3M2AOfP0Psk3ZYSpTPujyj1aJcZZEAw3oGqlIpdq5VgqDJkBNFi4S0UOdY?=
 =?us-ascii?Q?lcyXj6l8ZFYyAuGo2cMIl4nYfjy6WID8ZIPPGJQ3lfe37CD/st2LjBZtkldM?=
 =?us-ascii?Q?5OjzDBvUjneOrs9sbrB6kP7JpNDCJZpyIDpY/59U+s9aQRFAFdIEQL+sxIkz?=
 =?us-ascii?Q?Nva62Uw2woA5FjNLzsMWaNsG3BjhooUTGmyzjVYRYaA7DXeAf4gvY6mBkKYk?=
 =?us-ascii?Q?zu03V7wuY6c+mBK/uiZqWaUREbiStmfLyeEIJsmcNmz6S/0TFiqsEwh3bxFq?=
 =?us-ascii?Q?ek/XOlm/TWlqOutuFpCT9hZ571u1WBV/3VRwperkz2/d8hWDcFSWo7KnfGcZ?=
 =?us-ascii?Q?4He9wJLRb5LZ2eqYUcV1cq+j8ZA1pqB20PtiYaVf5ETwxPaK2taaMBarRZGY?=
 =?us-ascii?Q?Sf3VWcuzQMnUcyb+Xaf9u7sG+7DvAAyQxVJtr7lcxF0MZBY35kBfdmX7cCMZ?=
 =?us-ascii?Q?b+sGuc2Z3Mp0iShyxWXrp5U14QymXcqyhy6xNI0/pXZk5VmFWgrkFbfy/frL?=
 =?us-ascii?Q?ZnCp7kTcIw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bb32d94-fe77-4db3-01f4-08de52c0e25f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 16:29:11.9369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gm+VHXxsQVTCzM7vls9ppiL7uNEGMQ0qFAmUlnXlUE+r4jxMdMlVtvFBY0i0/82V
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9759
X-Rspam-User: 
X-Stat-Signature: xg54w3rfcupookkc8nr7nhxdk1myqxj6
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 470B6C0010
X-HE-Tag: 1768321755-156909
X-HE-Meta: U2FsdGVkX1/MemUeqTqrEu6qpXO0i6D8hec3igsJSQLxMvq5VLBXQWF5xaZNF+A3BeiiBa44Alx0wspwqfBjqkBBoI0OQojFCJrUfNZihrhN8lSe7BZBoKR8l0EoDHaOUMZ0ZgQS6nSd036ZnVFNZGl3smmwqrhsJIeM4SdwcNS7PMhq2+oct+UVfST8V5NS+sv2Parvx8fpPQDFF/T7rqtnFrofMRa8njBskZy3JVfsjnrtW5RO4RCqhC45S1Nm4qlQBGzmhSpCpX6GYjtllmGhU0BXTT5paZgKfILeYww5rLOtpHcDR2i9cRG90Cz8zGsrgytaOcfw6t+uqbcTGiRq6OdIKsS37Y5GBdaGaVLnDo+dpurxo4uOxIE0+LiFELk6LSgUnsd6nqv7nCQTDnLrxMPBIgbFUZvjl0nEg0JfXBTSgOPbdh8BhnGZSgdQCYU2/H/BWsqPlYaOkd8U8EEgfoqfdzfw6720dU38wJmHOoQTXUlDi927LLrGDvaZWon2a31tJLEc6PR4FIuJ1Qa33EFVQt+LfcR06e7IcNbenbfCGeqge+9UZQvWbIx4UIcTaX11+WKKzbDlnp8Y8axIKxyjcEHEdOs/1O0V4jPfIaTI8elovRBKfP7bfU3fuEvQ/I8Q8HJyADmF5gm1Kof/R4UpKcLGFoJNuoKPDciSgF6Tj5y5PpxkATPVG8l1fBalx7CSmGHAujamEGZAeNbItoJjKPB0BAqkaCVuVIQVL2HCnalvqXhJ7ujNfNNtoNNP0lF6OCergk2gT+/iPfzL166AF8vS3deDFzARPj3NKqIYxSYiptq3lG/DGUjNSiWamno+hrMuH0BKAJCxavO2vOWRU5yZf/qOPNFRRjq6Rv6C9994xUIF5/8KiPI3CrrhiYshfZn6AiNI4/lZrWzdYDaonOBqQmyZ50tOdLIQaUFhrxaNZ/9fvOIhsZlb8I+VJ1MklG8u0Ekw9iG
 Wn/Tsg1s
 UN/O8nmv4xTLm+sWapLUSJv+hQRQRbDkRCD4EcxOn22HrrO/p+wAcZVWDJsN64pNGGBIatS6yU9KRDZ9qs6uyxKHnFfBLkzCJ7iKx7prVrjlYFjbSr/xXm3+fNpdVTHW6zoGo3/g1tsca/NSr3Cg5LCqeHR1L33wkSIEP/R7k4glMGnRWA9T1yrC4gs2H+6bGU/f2uGkQJmWnFZ5TvdjQLaC2WmMduIYyMlyrC3J7ZVLeY7ZeEO1gJgjF4Td1j+c8zl71IjmVYdsBEsVMdpxQb0rWSUa6+RnL4BMFg65wFteNrTRkKTJe6NMPWdl4+FiQdBtu3RUoGKKxXG21N1Tojhkw4GKi2BnUs3+iCeiZh1X4xOItPdYS2/epFr371sACj9NLtBH60ZOITrCKK1f02D6yfYoav1zt513ElbqGB1tQJWYDrHkSyjiRHQASgnoP66QhJdXDk4Ijq3TwNh20+TL76rxaB3UQqk+t
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12 Jan 2026, at 10:09, Kefeng Wang wrote:

> Check hugetlb_cma_size which helps to avoid unnecessary gfp check
> or nodemask traversal.
>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  mm/hugetlb_cma.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

