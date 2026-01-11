Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49432D2502D
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 18:05:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE30D6B0088; Sun, 11 Jan 2026 13:05:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA41E6B0089; Sun, 11 Jan 2026 13:05:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 989086B008A; Sun, 11 Jan 2026 13:05:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 890CD6B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 13:05:08 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 23E168D2D2
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 18:05:08 +0000 (UTC)
X-FDA: 84320459496.10.0ABB577
Received: from YT6PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11022109.outbound.protection.outlook.com [40.107.193.109])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2BA5020008
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 18:05:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=Y0PfWHHB;
	spf=pass (imf03.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.193.109 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768154705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NHkPFP2wevVk2oUJaUNH+ZB8HrOY9GWCxVB3hWa2pPI=;
	b=KJE5NTACe51bKHIaIGBFnmqfHjUvrBSZK1f859IBBHtdAQ7e49b48BzQtxLVQVh6PkUwjn
	4gjc0aFyHjCUAGfCMKVgLiaFaW1DabZHzEWoJIDd0shKhpoZgoeZBpZc3vFXgeNifa0C29
	urY1vnJubE5UmmyWLgQVMn617QQxU4k=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=Y0PfWHHB;
	spf=pass (imf03.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.193.109 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768154705; a=rsa-sha256;
	cv=pass;
	b=fw8EKqjvcxE2UrEa4ucaGlwK1zutK1Sme6GOl95mNb1Buo+1Dvw/9wNVmtMrA9HtNCQiVR
	VWFhSYddKKCshEaV4bS/7mfuPXdH0xymf5gWy79uOto5aAyw49GHArr58Y5lSRk+UYp/HH
	PwanNtuCc2tUEJQamvVVnobt+BhktUg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D60mvegTtvJsBhZBv1z+z//mEeo6Mh81FSbdJZ2sP9inlSz0g2geTE40W5UjiGxHQ4QvmkiTuNirKoaJeY3psmXPQrxtCM3Gt7E79KF3f3DlAOv5wdVucWbJIIeEGyxKYFScX3p/qmG/OFWkhiUwFHcGG4gyr0dLa4sx/j4ztGGqPiwFmthuEOqaPXgdZ5gcTSmrZrKMi2+49PE27bZLt1uuf9c/xxyUP8IZvLYBoiNgnMuRhpOAeISwK8ghb8xmWNyRQGEx39GFCv3yYGS0GMtUzcmEN3QDFqvF7tN7b+hjWgol/eztKnXFtn1xfNAkPfURJESaG1icCu/nG/ajVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NHkPFP2wevVk2oUJaUNH+ZB8HrOY9GWCxVB3hWa2pPI=;
 b=Eaeex4/owq1jiIEEfUvT4dneJj11gRpvSCooaG/gEyaznHJJ7mZrtzIS/dcf9bdTO07uvlI+0+TwBAYZmyL3O7i5korJubE7yUqAyyXViJi/HLlmN+wLshL35eARHmUSy3YucCn+og7XDasytak/CvB6dVEwDM46L3MBJStQKoze4fEc1dJlbqxteE4uKUHbSlOXghocQ07BBZeQZ+b/HQFz4nKc/WKH5zfekCyM3zINsA1n+idvNypsjebqcA6lTt01nPIUAaNTKiXPBbrjl++FWRRKyRYl/AwC8XbqHdDHWNZzPrqJiBTOqEYret5MXrMgbROAjwPwYhX+gtOj3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NHkPFP2wevVk2oUJaUNH+ZB8HrOY9GWCxVB3hWa2pPI=;
 b=Y0PfWHHB4ver+uBA/2fQp2noH6dT8O+mXw7OvTif1FLSuRXHWRYN144kWhi7WqWVt10Pz2R5j5BvqBvRgm8/5owvnNgubxVbQ1xeZkJz5E/JwxBnJx+I3bWRJwNxF7x5XPSsLwBTzwaTEtzGfQeZWEnEubvHfsu2gzsOcW+NnUTf9da4g/vsKqn4OFWWztpaH9IxnU75W4DnF9VhfufrsuwqMJqQEDAqWf+8o8kwF82p8G1UUraKdnQn910KfDwzOI7hOLU21WN8O7gDZx5Zb9fagfI95tGQuB9eOU6uOYXC8tPkjl7tU+GzTVyibl8CyVYrXxQF15ZiDXOm+uL9hA==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YT3PR01MB9563.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:8b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Sun, 11 Jan
 2026 18:05:02 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1%5]) with mapi id 15.20.9499.005; Sun, 11 Jan 2026
 18:05:02 +0000
Message-ID: <6fbb17fe-f2b1-4233-9834-5a5020cd87b3@efficios.com>
Date: Sun, 11 Jan 2026 13:04:59 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 0/3] mm: Fix OOM killer inaccuracy on large many-core
 systems
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
 Martin Liu <liumartin@google.com>, David Rientjes <rientjes@google.com>,
 christian.koenig@amd.com, Shakeel Butt <shakeel.butt@linux.dev>,
 SeongJae Park <sj@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <liam.howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, Christian Brauner <brauner@kernel.org>,
 Wei Yang <richard.weiyang@gmail.com>, David Hildenbrand <david@redhat.com>,
 Miaohe Lin <linmiaohe@huawei.com>, Al Viro <viro@zeniv.linux.org.uk>,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 Yu Zhao <yuzhao@google.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Mateusz Guzik <mjguzik@gmail.com>, Matthew Wilcox <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Aboorva Devarajan <aboorvad@linux.ibm.com>
References: <20260111150249.1222944-1-mathieu.desnoyers@efficios.com>
 <20260111094823.6fcb1fcceb7cfca2dd37b66e@linux-foundation.org>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <20260111094823.6fcb1fcceb7cfca2dd37b66e@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT1PR01CA0089.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::28) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YT3PR01MB9563:EE_
X-MS-Office365-Filtering-Correlation-Id: 2693d6a9-7fa7-4edf-6d2b-08de513bf07c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bUd4NVVFMGdrUHI3dHRmWjRtT2VOZmVCZlBUY3NnNXcveTJydXluS1Jtb3Mx?=
 =?utf-8?B?dXlhSXdHUkE0M2JVdWRKL3h5TkY3ZDg1bk1uaVlKc3pyaGdPSElyajkwTGlz?=
 =?utf-8?B?d0VuaUd2cjBKRXN4cE5GbFBFdERvMWRoMWh4LzNjcStRWjJyMVp1OGJvUVJG?=
 =?utf-8?B?cGRQRGV1MnMwKzJ1dUxZTWlFTUt3d212dGhodXFobS9peWM3ejBvWGY4ZEZN?=
 =?utf-8?B?WDBRQ0tJS2ZyYjV0SE1oRUlOVVlCNDhHRmdUeTU5bGJqcW9mamZteHJ1SE1v?=
 =?utf-8?B?dmxBT2ZMZjI3a3VkVC9PMUJ2S2RJY09UNzhBM1J5ODlabXNxOFh2MTBFd2FB?=
 =?utf-8?B?M2dyYys1eS94dTNROTlYZVVjUFJDOVdvZHdlNWpGL05OYVNoU1lPdVZTRkJx?=
 =?utf-8?B?eFZaNWp3bEJrL1VzMEF6NjN1dXdjVmMyak1zK0wwQjdvVmNpeDJPQ2hRRTdq?=
 =?utf-8?B?ZXhXMk5LRStmbUMyTHdZekdzMGRJWkJrc2Jick41WWIwaHQ5MUg5QzNBN1pw?=
 =?utf-8?B?L0UwYzl1MTF0WXdHbWhnekdZN2EzbHRBY0ZSb044Y1dYQUpkT0ptNnRVUERC?=
 =?utf-8?B?YS9raEdkUTg5bmNWQU5XbUU2bDNMZVZZVjRiRlBreEVDOFY0TC8xcXN4M2Rk?=
 =?utf-8?B?cVRUOU9kcGpidHZSSkg0akVUSXVydG54YVpVb2NWdWhEWEE2YTdtRGFyVmpp?=
 =?utf-8?B?MG44Z203Ni9peFN4ODhoMGs1SkYwNFphRGJ2Qmo2dkk3T1BuTEF0d2VXL3B6?=
 =?utf-8?B?QUFXMHl5ekNFOVJQMUFDMFcyakZEMmFCYTdCM21WMlBQbGlYdDdyRlZHdTJn?=
 =?utf-8?B?RXZlVC9jS25FWmNvMFhGUlRWN3RLWkozM0hEZktKWjZJV3hmTWJuREw3dHNI?=
 =?utf-8?B?djUwdmpETFlZMWozOE9yNlN5ZGNVdll4aG4rK1h3M0U4ZU95K1BzUnJUL0JN?=
 =?utf-8?B?RmphMXcycE9CQlhqb1VjZWQ2VjltZGJxRmFXbXdMZ3ZDU3BWY0JTSEZrNVZE?=
 =?utf-8?B?bndQa1NEaHFxY2VTb1FrUGNLaFAvaWJ5b29nMEd4c2c5VFhkSXFJSHM1c3VR?=
 =?utf-8?B?SjQzdk91M2xvTlZkNitxdU10Q3h1R3lqRTJwTDBVeDkyRXpIVHRxR3d0R0ts?=
 =?utf-8?B?WWxxRzNjM1RTYWIxS0tSVm1PWWtXbmZlbTM3dVQ3bG5CTXV1ZFpKQjNqKzJY?=
 =?utf-8?B?TFIzdlJTTTZ6NHhpcmczTEkxUnNWWXNvUk5yK1YrOFJrSUM2K3g1RDB6TW8v?=
 =?utf-8?B?Ti9VQUptTmU5UEhSM0kxMzJ1NHV6TnVqY0lUSmI2RjJzUGR4cXJ2aklObmMv?=
 =?utf-8?B?NGhncFRGU0w4ZUFaZGp3c1o2NithbG1nODUwQThmRG9ZWCtRWllGT1V6OFE4?=
 =?utf-8?B?VlErVjQ1cEpTeEF6eUhrM3VRdUtqdys4MTlOMGJGbkhqREgxZTlUZHNrY0tG?=
 =?utf-8?B?RWJrM1pEVVNiaDArYWplTDFHVEhUaXc3WktyU0ErMEpzM2VjK3ZpSkFQOHBu?=
 =?utf-8?B?QjZrdklQY3N6cXVCL1EyVzRhMkU3ZmF2WlN2WTBBN0R5UVM5U2ZwczVqcnVD?=
 =?utf-8?B?bG1mTmNEL1psYkZqaENjSlFxN2FwQlRQSHlQbzBkV3UvVFB1Qm9lVjdvTS9G?=
 =?utf-8?B?RVh1aDBrV1YyQ1kvNE9CVEpnSkMzeFFzWTRYNWNoZGN3MTRJd0NpdHQvbjRs?=
 =?utf-8?B?aDRSS05pY0svMkpOVldjSXR5WnJ3MElrMnNzUUNyNGxPbThsRmdUU21lS1Zp?=
 =?utf-8?B?cld4MHNDby9XdXUyMHFySWJycGhOVlZ3V3kvc0thbC9rZmtaelg3clNxK2Nx?=
 =?utf-8?B?WFloaFp1SjltNHlPamwrZnNrRmxzNU10Zit4cHc5SHFxTktMbGJHbDVmam43?=
 =?utf-8?B?RzVoTnN6cjVGTUwxY0NWZFJ6YUo0bWpWSlhTY1NjekFqVGc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(10070799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?blYvMTZuQm1oT0NXOW5ZQnV3bHphZ3kyeWNJUGxSWm5penQzVnF6bXJSMktV?=
 =?utf-8?B?eHBTRGd2QkxzKzFsWm1zc08rS3gzdHNTSk4zSjhDOGZvRHZjN1ZpSCswd1Zu?=
 =?utf-8?B?dWFPSEh4d21vZlBYNGUrT0ZYaHdrbEI0V1lmR1lndmN1Mm80d3h6S3BDOSto?=
 =?utf-8?B?ekdMSmUzdktBRXIwSmdKcGFZNjRFalcvOVRkVEJ5OGNHWmQwcDI3eHlUWDhN?=
 =?utf-8?B?ZGlPZ2tpUmRteWQvQUprWEVjSUs0UEMvdFNhcERmN0t5dE9OaFlJSjcwNkJD?=
 =?utf-8?B?ajhIa1R0S0FhTHlncitTQU15dVVRUU5kVDR0QS9zMjdxcTlGQ0lRU3k1M05L?=
 =?utf-8?B?U2RwdDFoNWIyUnNvUmNZUVBDQ2tKZU9BQnVoNVY3TVB1YWQ5L2FxVUk1NStn?=
 =?utf-8?B?OXhHODBSbVNTUVNmdS9ETTRCNVZFVVA2bUYrcERzWXhpaWRwamFraTVmK25x?=
 =?utf-8?B?QW4xRmsxbGdPd3pFc2NpaDJIM010MUJiZzMyY1V0VUMycXY2UUVVWmdDc2pr?=
 =?utf-8?B?a3NDVnlyTUd0Q2VZTWRGejJxYmpCQ2FoSGQ2NkJOdGRkemZTZVlESkVPaktm?=
 =?utf-8?B?Vzlidng0alZsRWFuYk5Pc2ZIdWhzbitPOVhrWUp6S1J5YzJPN2ZXQm1SU0do?=
 =?utf-8?B?aXQxb0hVMEt5TnhtMjUyQ1IxbjBCOHhLZGN3TEpVQi9PMmpXeVNuS0FmZERB?=
 =?utf-8?B?akg5MXM0YW9CSy9xRXVtNWJwOWxuaVNKUW1uVXBhZ0dTRHRXcDA4MmhQUWtG?=
 =?utf-8?B?YlAzcStyZlBydHRDNVNzQ3pURjFhOFhFOC9BK0pDbnpML0Z4dDQ5OUxpSnMw?=
 =?utf-8?B?UUVDN09JMUdkbWp3cDRKYWgvUWdCY2RVaDNrNmV6QmlHY1BwRWlIczloQ0tN?=
 =?utf-8?B?cWNBVjFoMHN3RTBOeG9yMWx5VjJXS2QydmtqbUR4ZmMxZXNmTWJFVmJiOVQv?=
 =?utf-8?B?MmJPOWp0czhuYzNyMWR0eUJySUdJMFo0Njh2L2NDWVc2Sk91dHVpWGhMYjR0?=
 =?utf-8?B?TGU5TGNVRFV5VnlIRHR6a2NwWXd5TXNIYis4SnhTVk0wRXVwOHlTZytIaFZa?=
 =?utf-8?B?NTArOUI0NS8xR09nOGttalhIYjRBUksvaFUzSzZiNHUxSXpmUG9oMFh3NmQw?=
 =?utf-8?B?YUlvMmtwNXB0c09mNzZYQW0weXJ1Y0luc3VLZVlTTjNxbVhia1ZRME9QZUxs?=
 =?utf-8?B?SkQ1K3BxWm9zZmZJb2dzS2QwT3BsMEJQUWRWUWx6YTdQeHhqQnhaQkk1dGF1?=
 =?utf-8?B?WXRGbjYwVU01dmE1S09rdkhTeTZnaWc3a0tPdVE2NFVpWmxzaGFCU0hzQlVy?=
 =?utf-8?B?aDJPMjhpN2YrZHkxcWhMR2tFTHVwZStrQ21GR0J1Mm9uREZwZFA3M2ZsRmd6?=
 =?utf-8?B?N09iMW9UU3ExRWlKdUVVYjFnQ0R1UFRWR2VmbEpZd0FBdmgyM0ZGbkNUOU1Q?=
 =?utf-8?B?TVZHMnlQRE1uRld5NzBDUzNJaURTUUZTb3dqSzdNWWkyQzJEWnEyQ3BVRnZC?=
 =?utf-8?B?cTFiOXoyTGh5NDBJQmdtVE9MMXlFVUNlVGx2cS9sVUtQaG51Q2dPYzExSXNF?=
 =?utf-8?B?N1RUSXFRMXR5NUF4UHBrSnQ5R2hRaU1rUUtNbEEraHZXVFBYZ1NxTWo5bWcy?=
 =?utf-8?B?QjJVdlhTN2VrbjBHOXEvK1R0bVU0ZXZPS3JON0ZSOUZLdERtdURYSHNld3hN?=
 =?utf-8?B?RHh5alVaVkF1Y1hpQVlhZkhSWWI1Zy8xTVBuKzJVSjVvUFVnUHRJUmYzV21H?=
 =?utf-8?B?dGlWb0dSQUlJaGMrNFp0amhDb2Y2MFBCSVN4U3pHVktRSkFHL05kWHp4RUVl?=
 =?utf-8?B?R3RZdFdjYWxDUXVMUnJJTVJ5T2Y3K1J3T0FlamVUeWxYSS9vOFBDWFVDTGsv?=
 =?utf-8?B?bU1TdVJMWEhSSDZTT2w4VFhiZnEzNFJzQ1RtZERucjFSejBSTm9iYit6R2RX?=
 =?utf-8?B?WjhvRnhtbUg1R0Rya2t3cVNHYTdyaXBEVGZSMjE1MG0wbWFFUnd6VHVsZ3Ju?=
 =?utf-8?B?cWI4T2V0MXRjNk91VVo1SWwvZVZGZEcySHRSZmFnM2I5TmlXMmNJeHQ4ODlv?=
 =?utf-8?B?RTJTZTNkVGhvNmlSU0F4M1gxWTJyaER4bU5QVlFrcUpOSkVEaDNWaGRZempv?=
 =?utf-8?B?cUN3ZkVMUDBTVXpOT0NyTDlBWUpXeFlQR2RNVFEyODBrYzY5NlZXVVUzOTRh?=
 =?utf-8?B?YmFlbUFNWUdLaGxBVExJVjhCTDEwSW9oeVNwanI3bDZHb1dGZ2p3ME80RS9H?=
 =?utf-8?B?VkJsN05KekFzZjRDYzNnRXJsRVc4dTFCeUtpRHJiRHFuT3Yvd0VaWDdTRk53?=
 =?utf-8?B?U05nc3A0dG81dzgxSTY4M0I2RzdDUjdramdjcytFS1VxcTFPUmRsNGFPMmQ2?=
 =?utf-8?Q?+4QFbys/Ic7aywKxCEocs9Q/NC8GCELEUGqTZf7JRbJLg?=
X-MS-Exchange-AntiSpam-MessageData-1: rD1a8VGTomENGAwitA9DkrkLB+kN/8cXNNY=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2693d6a9-7fa7-4edf-6d2b-08de513bf07c
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2026 18:05:01.8267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V0RCdXfOP5G7eEpwGlzdJEusEiZQFNHXg+ONqbCx4OHYRoHlDAn55bk9LBDsQ3jB47UWw+tk9iQlp0zRVE/kWGlKhPsJXCImrO9SvUS5pz0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB9563
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2BA5020008
X-Stat-Signature: 71e6by7kkyduq3eoxyz4ubi6ugoek5xj
X-HE-Tag: 1768154705-355121
X-HE-Meta: U2FsdGVkX18lAAzVlW9VeMabCWv2iYveZQowTGZk/x+j2cQ8NMCp+YJ3jQWAc/+smUfgDdulQQk4Dhve0QZlHUBaclbToI6bFLhS7muyFGK6VJkiK24tYD4GEkwEoy603zmvclqzqFFeGtVZys7kS2DGDpSZTPswDFwA9egAB923+F+HgErbGDQnpDghhxt+iEchBxf5jN0tn48tWPbhOMKavNvRoeUcIA7LvtelXFUj4liuz+00SqTOpd7OQlIJYeYg7ZZRZNtlVFDK1cnJu3A+iQ+tFNnAdzVvGv7/PoFuQzLBqIECfuXZrGyXIAIhe4cag8QA4cRRawbizk0kfnptIJHWjdyJwykRelOmYDg3vSSgIt+5QsF2Ja8C/bNHGylBkhCkvPNCChErvVJlFpC+4APOq2PfskSP/5mS3RI+UaPZ63D2U29IDXMwuHj1FlObs5WFbUI/DbHcbIJ5SbgrGDtFrR/45wMQ8ubB+Ph3ijoox8hQouYiYxh71C0ohP1c2fF7ONCBigQowZ53ca+2KI5F4CYc6Wsi0d9Y35WRCPi5I/x7oD+nHJb2bhPm6/dAz/6FyR9d+Scd/8/GM5BUxvdm8Lid+EG68YyhfA0FZHn26TwnYKoNxE03tMCBLwktCwGzpopriN+BPvL1U+dVOoQMSn7zmeqP63nh8Uyc+1XhOoc1Vx8Y+EYSHYdUqJFuSQD5DOpFO3sGJl4zE9t2q4Ey5jnuhaE4nXFZ0+6qn/jEoAOnQ4EW050ugGA1cWP1W+XWVwoHoNfWd8PCKAlB82+bCpAoHOmH+xRSmjXMWGUgq/CtJcXGHW22yat3JRi6vE2jSu0P5Um97Kon5OsdYOr8CJhYxWNp5zHM2Snxi+0NAQV+Gx8imHyylngwdtaK2rsWXEAb8a3XacOGGdWfLF7CZNcEg56Lri1BKsAS4f9dUSeim0j+noie1NgaP+4+1Gtvb0CNgp0RqI+
 7yIFYTxm
 ApvIynN8ac6NCbHuvhyDExuqpJEGRkhQB3+XO0Sqtg7Z38am2fRaPZcmdw+k6xnwrtOZ4YacQ5nlB7ia9DZ8/pgYR/URUoiHbopBHfqHtGZIy/MSNZqRmej1S/gpn2c6W4H9hX6mOrurJg4xRUkZMSYz4pzmo3Ns5s80+da8PI8RVuuCI4ddrAOac9/EHR7PgLxDSKxiSmz40jQwVRmc/q2bzu5DopWH72La5cYWm+H8Ppc79sct+qLJVNE/JUhtpjWihLxEFqb1bfeq0KMcYxohWZtg7R0e7fCRpqb23v17U1/kbFQuWyiC3jachtzsRSw8udvhCI3clyQyVbAlqDx0GzXlXHgj68FY64c9f+ObQKG+fK+TrXwrzCggzQa/Z/b91iIoqIYseAiROTrzOtfv2mFqqYJreNHIaQ53ikvPCJlO+vwuq642p7coEZ0UsJ+tzdgqstCzw/R47m09JkWbJru5BdWFDkHLlrXa+wXcXs+2y3T2HmVg7HuzgdBDDGHh8UKCztwId5sHlXcdWc3dy21deG5QX6KWzkWdiSlT2h+Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-11 12:48, Andrew Morton wrote:
> On Sun, 11 Jan 2026 10:02:46 -0500 Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
>> Notable changes for v12:
>>
>> - Reduce per-CPU counters memory allocation size to sizeof long
>>    (fixing mixup with sizeof intermediate cache line aligned items).
>> - Use "long" counters types rather than "int".
>> - get_mm_counter_sum() returns a precise sum.
>> - Introduce and use functions to calculate the min/max possible precise
>>    sum values associated with an approximate sum.
> 
> May I ask, as an early adopter, what is your overall impression of
> the Gemini reviewbot?

The review comments were all spot-on. This is the level of review I
would expect from a good reviewer who spends a significant amount of
effort digging into the proposed change to make sure the type limits
are OK for the intended purpose stated in the commit message and that
the intent stated in comments match the code.

As a patch author, I find this feedback really useful. Is there
an easy way to get this feedback privately before sending out my
patches ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

