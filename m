Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21023105F78C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 11:12:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 846CB6B008A; Fri, 13 Mar 2026 07:12:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E6C56B0095; Fri, 13 Mar 2026 07:12:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69EA66B0096; Fri, 13 Mar 2026 07:12:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 550FF6B008A
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 07:12:07 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 277EF8C82A
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 11:12:07 +0000 (UTC)
X-FDA: 84540775494.24.659FF2A
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11023109.outbound.protection.outlook.com [40.107.162.109])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4C1FC40006
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 11:12:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=kUloM4or;
	spf=pass (imf07.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 40.107.162.109 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773400324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B1o3xBsj7q4cpla9Ocgs6Kp0/biHrZZ6yne4uA2YsRs=;
	b=qHCE6hztfjAqCqGkx66rw0v15mNTrhjEYlYewXt4oN1Hcvu/68spJYBU+p0Cwk7IlVxMOY
	QYhJLMNJIOJ1W0lh/7icmZ3rSn9Xt2D5BtUwzpwdqCmPzLZjrS+y3vU3JnPnNGXaZfACBv
	rJtTjQtbXglb56N8M3pn1uWLcOR1G4M=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=kUloM4or;
	spf=pass (imf07.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 40.107.162.109 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773400324; a=rsa-sha256;
	cv=pass;
	b=HJ8ZzSdKxAwDlq7URgENvPTlOtKtLlJ3lmaxJeP3Gv2c1G2pDHX0b7cQ7aIQACNWJMVYZc
	fbZkznJ4qoR8elC15dSUoNmjEP1Fxyo9S19c13mkrNmwROVjD84dMO3C2kTAR0rzWunNQs
	48KRprE++/3jz1rqyjuljVdBtl4TsfM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JqYL7P8ogVVUNpCuMiWGZ6KbaqpdJq7hzN9tU5p0CSd5+0BOqHdEjYDsuSBz7irR6hsVjP48ELcBVE3mjROzQguQIkS2c8pwMDhqz9wfTRd/PSI4F6LvOKgvDNcJ0Wl2d6hV2AA1r1+nciu55xU7Y4csX+gWu2xzuVnztnRzq3DIzggiMvSCBVTczRUHg1ddRME2RmkXbnuTKN0kvSOyZaXpYWJMecj2GoO5GVthL6vy49wm9LAmZohupz36x2z1gDwL20CJoNx8qKyxL/VZz6M01NvR1GFzdZFUPWUCF7SJg+yXTF5LLCgXl4F32PV2E7B7DyYKhun0BSjXZIIQFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B1o3xBsj7q4cpla9Ocgs6Kp0/biHrZZ6yne4uA2YsRs=;
 b=hBGzSVcBrG7Av7cszHhYZeQPYGXT/D4JQC31huFLwDUjBF4Nxnah3s0vjWyO25la58EADR/4rGE0JK91OMzdpfL1UdD8O1j61xjUez2CUzDBdC/5Tb8bp4lN+eN8Av8B5r6EJsFA+wZqZcBUwkrMYVU4S+GvAScPPjLMU3+I5El13tiX11Tr+aEwRdlAIf+mvhT5i3kzHc8b1dfyL+57iQGQtjZwGhyP/CL5KYHdQz3ieeKNPaha1vrK1vccAwLKQooU/9X0tbuabhQj029KicpRFAqmeLW8BCU0B92IlnKHhQHGaGKAdkQLRtfXf1pV132vHvdiszPQ2u4ttRglKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B1o3xBsj7q4cpla9Ocgs6Kp0/biHrZZ6yne4uA2YsRs=;
 b=kUloM4orDiiGZVLYPhByCvhnUDdN/vcd1A28xV2m+xLEdEh5LfiAWcO2BlUTvixvmcEHMbvu3sRtVsG4NcTKp8rBEXXJW0Ib/Ib+1I0CY7+6QEDVYc1iRZaAkYxoJZz5/8fmwpRlaZbzDdFCxjCRYTxzA5UNyouxp6B5LsZFAXGk8sulg+N+2+L0/Hx5vgXdSJogtHRIxPhz5BzVMo8m/KNbST3aYVLGhXeZX518Jk7QiVjN6ALWtAIgm2CBdraXd98+YMYjRVCq12yN0Haa59TRT+hmuIkIGuXENNjT/UqM9LvYT7GEzXoCtHRW+wQ0A0NMmERdw2o4Iv6pRPemIA==
Received: from PAWPR08MB9008.eurprd08.prod.outlook.com (2603:10a6:102:341::8)
 by DB9PR08MB11361.eurprd08.prod.outlook.com (2603:10a6:10:60e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.12; Fri, 13 Mar
 2026 11:10:32 +0000
Received: from PAWPR08MB9008.eurprd08.prod.outlook.com
 ([fe80::e9d0:437c:714c:396a]) by PAWPR08MB9008.eurprd08.prod.outlook.com
 ([fe80::e9d0:437c:714c:396a%5]) with mapi id 15.20.9700.013; Fri, 13 Mar 2026
 11:10:32 +0000
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Brauner <brauner@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Kees Cook <kees@kernel.org>,
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
Subject: [PATCH v5 1/4] pid_namespace: avoid optimization of accesses to ->child_reaper
Date: Fri, 13 Mar 2026 12:09:39 +0100
Message-ID: <20260313111014.2068913-2-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260313111014.2068913-1-ptikhomirov@virtuozzo.com>
References: <20260313111014.2068913-1-ptikhomirov@virtuozzo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0190.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ca::15) To PAWPR08MB9008.eurprd08.prod.outlook.com
 (2603:10a6:102:341::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAWPR08MB9008:EE_|DB9PR08MB11361:EE_
X-MS-Office365-Filtering-Correlation-Id: 4424544e-d550-4caa-6070-08de80f1245b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|7416014|376014|1800799024|10070799003|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	0QAIGY0h91XXjqZNGMqhbdcvb87eR1ixPEnghR5dR6/hoZyFtWXxEk7xcpOn1+vYISYY6SEs+F7hrTw2PzhypVsbEIz5flnW+r9j96IjpUV1a2iDuizo7/Kv4uv0MNi0PHXvFmxRF6zm8rBReNu4tAs/6TptSbZKU8YKlJZp4JiF1DESI95FAzbg7ASFyVHOvyT/f2CTyIPzE/5VL/HA7sB0uV+Vluyopbt6+vA9EmzD4mmkibyHasf5rA9p/eSXBB3wM91oAGtQV1aSH/DeFQnX7UHb1FlVJ6na63WHXW5XubWzxrNM9HGLiEDxa/nstSVNfSDRJHOrfqXYjB/IpY1UDZm4ahJMFDSPYjX4uDlFgq/LqP8EUKronUEb+IjRnl3N/20R8AO4Yip9NLVXrRL10Z4dGrm+t5WI8Lj4hCoGh9eQvbfJ7mkhU3lxFw3i3vR8G/VMuFdXYoh0Mis2RmY6KnQ9+wggXEyrH42F+k6oIxVOPrgyNZm+RI6sSH5Ws6hAEY68Qa0Ohb3zsQOOL/6lQKA1PUqvo/IQMgrKbvZLI1lZRomC+VEOEauriWeU21htobOZf2YJ4HYkodmV+SOW+E9B9imuhbjVpDsgUckepkVYsRuFpWEkQH83cjeGH3L5q5dINvFi9NkVZaYW1088/T2tt2LYbTNPNNm1G5Pqlr6v6Humr2q2q6CfbYRa41F8BAsoX7+jqQn43pS+b54FhpSFDnF3ysv/lTPlS/g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAWPR08MB9008.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(7416014)(376014)(1800799024)(10070799003)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6xHLHYquRvnF+503QbCItN2SpNhrhXGS4NZgd1WjeuORCAtgmkypyAK3GExp?=
 =?us-ascii?Q?1Tk9tkry5Vu9e9jvboe3oXDIrmOmAbVkxbbXaFdUhCot5tWflKGvOuhTe3Yo?=
 =?us-ascii?Q?j/nrpmqKQP344r8qRU3xARFZSBFDCSFWrVYvk07xdOt+4ArEnN+FYSy0a+Pc?=
 =?us-ascii?Q?XQmuQk7WE2v22cVyCObhTZoparR43JbodU1Y/Jrtm0TruF8BusOBxP2zpv9w?=
 =?us-ascii?Q?naxwrm2tsMUCB8lgRtsBxihW8V9+IX+ei8k+nNwot4kHtgMGLzql4Pj2EcvI?=
 =?us-ascii?Q?9PSV0b2Slv9tZUfTASYZHhi4QEHktFOmJ9hzQ86ZaA/9Tk3D2au2UttOCuy7?=
 =?us-ascii?Q?HunRDZbQXucMvjgF7CZFCWGi8KvMyqZs00u30QVGYUuMPuxWort0pd3Ayl39?=
 =?us-ascii?Q?FOnP1wr5dTDzGtU7K/hSorqozy8pvdet/Nnv7BY9WKqeAXkP38ZHUZcFAPGP?=
 =?us-ascii?Q?Et8tcs3JBv3ImVyjUU5Mkm5ARAbuUgDozu3aY05rh/q//WDYTfNykIQw63t9?=
 =?us-ascii?Q?pkO9T1A6srjy2i9CAuDo7AG4Z0DHGt7vmiv+R63CAwtMpqGBUz73YMyKH14o?=
 =?us-ascii?Q?0Y4P697Cn/WIWCT7v8AIKcMCAK3S7iAxr2AsDYIYFPULJji4eTGPNmLXS8T2?=
 =?us-ascii?Q?1Pvof6wtxfKCsJ0lkGFj6rDk3pjQF3XmvDxRIesqNNT2UlNkSBTj2ohq2KSd?=
 =?us-ascii?Q?fPJ92KKAIYblwgIu8VpbEEnmHjM3fnQ83UswSTMTm3W/Cka1Iw+JJc/P+Xri?=
 =?us-ascii?Q?gSl+BTCpfVvwGHzs84w6zQjbzaQLEp4lXprTT/RUNE6h3rxuzIX2r0MhixSt?=
 =?us-ascii?Q?sc0NMliyWCSb95XR8e5sN6T3mlZL6TvILmkr61tNQotpgXyM6t/qZrsyPaCG?=
 =?us-ascii?Q?a6SlfCA2WgVrw5Kke7ZNhpJT7wtNqW/5eytvrEn0R+6746WLC4UKsKw9AdUn?=
 =?us-ascii?Q?gCxhKDlZ4AOshn2NCNNPloX8XlZdmlwO9UVwzOYgS69QQob6TBQm055t7HBD?=
 =?us-ascii?Q?YAjrPE7Dl1bHQWudef3nfcnGr0dDVOA2jzeOm4s7AWgQXS+tpHmSHq4YzU0n?=
 =?us-ascii?Q?CfrIb74m1RZRhRbfaO75YcbZ3XJ7L8YhPfbMl+Gv2NI39hLC7wNUal/InNHk?=
 =?us-ascii?Q?iWZCAWcjZSbh51r+sniEkBhM0PJtmGQ1mL/+KK+/jZgUoJAJNQGHyLBqMUaM?=
 =?us-ascii?Q?xAkCVF5jFT1rvn0x75/KrKST8kUJCO5RUhOGYOkJ6kIghLjU+oXKPu/MV4Bm?=
 =?us-ascii?Q?XVs7J59GGc8iDlwrMT58mSq5lopdXmrv4SepVQ5MV1ORiouJ2DGiD8s7Qdxz?=
 =?us-ascii?Q?zRur/wIbAlMAnj16eq61e0KgOVyWdQqtJfUqwElsVh+qtOfOEDOokh0l9zHV?=
 =?us-ascii?Q?16oEeklsBrOSqV5VcDZnmxZhlWdP81nz6PCByMzV9BKeqhwDQ2g4jvDIrvFk?=
 =?us-ascii?Q?4JR9CtGR785F7vwm5eQ+f1rub+OGplAv6Ao0dS46/2aPcU9GrBoGmeygmxQy?=
 =?us-ascii?Q?AiKa8Z6B3ReQdQi0fnZ5Y8Sa9aHmv6e83xu2xbdtimZyPPf6m2b3LsV+7GyQ?=
 =?us-ascii?Q?iOa/AaNE52gn3+ybSb94uZssGc2Don/x9RArBNrYqeubiHiXxeLLEEI9HmMY?=
 =?us-ascii?Q?32bmzLvGqBbD0zxSJw+z9JpV6tR/jAhCXqnqhLnSBemkWHiN9OIJ8UPBkvaX?=
 =?us-ascii?Q?/iBhodTgsTuy8mnXcr6DbosGl7sjHvWbvqav1LqsId1xY1C4XiG8KfQYMumb?=
 =?us-ascii?Q?z60S8+oh52Q64pJAnKHR/NT+jD4mWa4lSO2lSE98LsCO0NSSpefZOnxrR80y?=
X-MS-Exchange-AntiSpam-MessageData-1: KygUmPywrYe25qIUNULSCxNjt0sWeJh5A58=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4424544e-d550-4caa-6070-08de80f1245b
X-MS-Exchange-CrossTenant-AuthSource: PAWPR08MB9008.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2026 11:10:31.9824
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PhwuRf0xpvQQIXY6XwSBKBDeI+3gfxJko0dLRvLk2IsUwaKAskzAFSJdbDGBapOraRnWdJGyPNBR54UpY3c4dMglae3x0NgpcW/qXh4bwKA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB11361
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4C1FC40006
X-Stat-Signature: jnbcot3rcigmysb9mck4pn5ya4q61jbf
X-Rspam-User: 
X-HE-Tag: 1773400324-998082
X-HE-Meta: U2FsdGVkX18xo0TtKqE+LBLYOk7V3AIB6aJuriYiPG4BbpPCQWWIWi0I4sWMmR/Zz1kpZt+f2ZbsnFfqIsFH+Fne9mjn0R3NSiGXvs6/AGMO1hpbtElRnLwE5DBSzaJferJ1/+z/oLzSIAOHIwZDuMPReSJAt3oqRdWMrl90kz+ioFB56DQyDGOHH+sudfHgPPgRK55I0S6oTg6uWTDreKsRpqPkEWogdGHnzIXv/3xaqo11VckAK398xjK7Wz2yQ0I++4+2oqpagWCuEdXuAthHlEvJOwv0HK/PyMr4KHng59NgEoVmJHitXdzEbSNMs1ImZ8f3f6h8fY2DnEBrJsy2jM0yzMY5APUBTnhwpb75z0pox5/WMOXMyRYetSHhQtyVHOtuHLnipxTC1YUTCS13HsBxHVcV8uWKFunVOUW+XmqubDIJHB/LYoQh6uiiHXXGBvnMxZeWIGuSL9+qVNaxFIbYLpTUesXHAsdeLDrtGK+5NR2es2Cg1AI4owC+/J4eH008BmZINC6/mUQJ6H9aVyDWQiNM88+erfXl08xXjgsnMdEcaJCJPc4UqCNWk9FX+Ax8rBFOQS1g7beh880jwxBV6V70Kz70vIY0BgV4ypwg52XOhmlmVmzBeRFw884ir5PaO4wsNEVDzjIXl0rIIbLuNwgVycwJ++eB2FfrZTeq5SDeQugX9RbJtI0xYrf24rJYf0ipdq4cjkObKVRm+X0qmoVg773NQUCJWr4gHU1J/oLGXuFC53cODpwkr/U604vVR1fqmCBiganU9D8KTnLa6C8OEIgAvyMZeng4dDpJoc0kR2f5g/bUHDsACIGnnOvKXZZGVe3jHv7GEJHiR3obf0z20GTfmyT4l+XzuXB6YGq/hyPNnigJRHUR3qE5mg7mg9ORpVyt2IxksQx7sb2inGUqnRF2PyZrBEquMXUwoyS+eCjauzq5cRRvI+jPdrhaTGFZbXc8fQd
 DwApJjY7
 +Wo0YrzfTUAXHJ7E7nebUbpTPKVGTiHJMALAMUUErMhoeOwJkUk2sooaVTuCkOkmebSQBPVNr7jJB2DqlXFLgHTuoPAIoQsGVvujIrcLRLSS5oXFcTVY8U84/rqIL6v7fB0bEK+NsNHKNkOHAbzhixizhW5Qih0C8/gAjLjgx7ovOd7OanWmq/4qVFPqpfcsRW/0sY+7rZjPe2YVd7d31+zlpmmM59qnNb9AAgD5UbrktHTb/aRFiySZGMSeJo8cWWJzLcA+ve2/IftrqgNrn4JvjAiQ340/EVCjNtzTf1SjHrDn245TjG+hapzD0erTlQrz6wd+glge+S6McoSRVujnR7umZQVJ7O/Zq7dpVE7TkROuVJNBPY4lk4fWeQQXb0QPc++tUbje1gff0byp0NSlo58rT1D5tkeYsdUXnv79i4t3DJ06ntxFa1chcl5wNgJ6mXE7X0BzfD9LH2hyCZm7W2nH4Dz/Cs2eboAFx3yFV8dm/+4/qkFhmixchZ+0zkEfHxpotRDrrPnMcRejex4tXYHEUn1ICf1xm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To avoid potential problems related to cpu/compiler optimizations around
->child_reaper, let's use WRITE_ONCE (additional to task_list lock)
everywhere we write it and use READ_ONCE where we read it without
explicit lock. Note: It also pairs with existing READ_ONCE with no lock
in nsfs_fh_to_dentry().

Also let's add ASSERT_EXCLUSIVE_WRITER before write to identify to KCSAN
that we don't expect any concurrent ->child_reaper modifications, and
those must be detected.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
--
v3: Split from main commit. Add ASSERT_EXCLUSIVE_WRITER.
v5: Add one more READ_ONCE for access without lock in free_pid().
---
 kernel/exit.c | 3 ++-
 kernel/fork.c | 5 ++++-
 kernel/pid.c  | 4 ++--
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 1f32023d0dbe..25e9cb6de7e7 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -608,7 +608,8 @@ static struct task_struct *find_child_reaper(struct task_struct *father,
 
 	reaper = find_alive_thread(father);
 	if (reaper) {
-		pid_ns->child_reaper = reaper;
+		ASSERT_EXCLUSIVE_WRITER(pid_ns->child_reaper);
+		WRITE_ONCE(pid_ns->child_reaper, reaper);
 		return reaper;
 	}
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 7d369a8a2ad0..19a75a041e6a 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2428,7 +2428,10 @@ __latent_entropy struct task_struct *copy_process(
 			init_task_pid(p, PIDTYPE_SID, task_session(current));
 
 			if (is_child_reaper(pid)) {
-				ns_of_pid(pid)->child_reaper = p;
+				struct pid_namespace *ns = ns_of_pid(pid);
+
+				ASSERT_EXCLUSIVE_WRITER(ns->child_reaper);
+				WRITE_ONCE(ns->child_reaper, p);
 				p->signal->flags |= SIGNAL_UNKILLABLE;
 			}
 			p->signal->shared_pending.signal = delayed.signal;
diff --git a/kernel/pid.c b/kernel/pid.c
index 2f1dbcbc2349..bb2bb6c16498 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -128,7 +128,7 @@ void free_pid(struct pid *pid)
 			 * is the reaper wake up the reaper.  The reaper
 			 * may be sleeping in zap_pid_ns_processes().
 			 */
-			wake_up_process(ns->child_reaper);
+			wake_up_process(READ_ONCE(ns->child_reaper));
 			break;
 		case PIDNS_ADDING:
 			/* Only possible if the 1st fork fails */
@@ -218,7 +218,7 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
 			 * Also fail if a PID != 1 is requested and
 			 * no PID 1 exists.
 			 */
-			if (tid != 1 && !tmp->child_reaper)
+			if (tid != 1 && !READ_ONCE(tmp->child_reaper))
 				goto out_abort;
 			retval = -EPERM;
 			if (!checkpoint_restore_ns_capable(tmp->user_ns))
-- 
2.53.0


