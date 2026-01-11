Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA42DD2502E
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 19:36:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D33D6B0088; Sun, 11 Jan 2026 14:36:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 356CF6B0089; Sun, 11 Jan 2026 14:36:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20E976B008A; Sun, 11 Jan 2026 14:36:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 093476B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 14:36:00 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9D538160F5B
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 19:35:59 +0000 (UTC)
X-FDA: 84320688438.26.FFB2A9B
Received: from YQZPR01CU011.outbound.protection.outlook.com (mail-canadaeastazon11020129.outbound.protection.outlook.com [52.101.191.129])
	by imf26.hostedemail.com (Postfix) with ESMTP id C73CE140002
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 19:35:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=oogVaY4u;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.191.129 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768160156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6fUbCL46RWJ3qDbhpWd6ACHTs0IR0FmYlBazmO19X9U=;
	b=yeJYq8yuuFCFy43BHKUuW4SQjuIPejD8gEQCJDa2H68HeB3QcgMhBvgXVHXSUkhXav4lSz
	jlIQy6BIbCO6BkmysvK8AIQkp6DzDWZxdDW2nVQMgjc/nwnNbNKUzs5qkiW9Knsp2XsbvC
	P7jJfXVxeqYBgHMVLuE2qARKQ8f5HY4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768160156; a=rsa-sha256;
	cv=pass;
	b=UqNYPAfpjz8Mj96jlW3AMpadwsVF/c1jYTMsdcYqPUQIotZWcRtbwbUDJ+d7VAdrSK1JQC
	bzjuRe+32EmfSSf/fXgbIbLTw/DfRjJHNL58knWLYZkfhEAO/NyGrNHmgmpwUoDzpXuSfb
	dAKuIyhGVh6XMHS/Mx07wI8C7uQr4fI=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=oogVaY4u;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.191.129 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KRK9BFHnsJOveLlkoIURPSd7tScRI6VcQ2Njo3vlEPdijqZf3JoFjWU1Y4OTLVPSe3oCqZs4SFgb+04jWq4yau9q6zE6wjlk1bKZqOR0y6WvLGWYlMSEMN0RrowkkosBJvKDq+pH2qxSaSuKhpF4EUzXNDNWZ92JpLd4JovRm77z48fk/Xfnds7miFHRjDsNyKPEAC9flVLJikE/Xd9hM4X8GKIIRJCvFFmBfWeQ1IGfrLPk+YkvUEATpRzvmnnnlc971BCK0O8fzzIVANDKKWW2c4qYE5fbR5GwRZzqKzU18VUJ/UU/TPuK0Rm80hq/ai7mQ/DP8lEJSCNs6QkdAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6fUbCL46RWJ3qDbhpWd6ACHTs0IR0FmYlBazmO19X9U=;
 b=sFRIvLzrqfQX3oxz2NZOjawojwto6ZQyDC/dKljDDFi2/9H5TWLwteobwDDWIsmAJoa97mEFOvD2HNHXwzZHXzuF7AJM2e5XNAd13+LOl/57SxdQyBEVtXGMIL94wJMpPhHNNvbaB1CAPnXqjs6JNVLaTvOSKIlTqbadnXONwWddVkRGkBsAzBUpbg6InsTIJIKtbuOjdQbxHAuTrKap9BwIkJWGqivLprRk0lmrevmlhQDsM+o9Au2G1yFdMlBKsCXoNxmkr5XqsQ30SYBVRJxH6sOZbBGLTNt1G0AYA/Hp8rZqFqH3NPBz+VY+eVeJi00TRlFN/cv3/lS0UiEdKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6fUbCL46RWJ3qDbhpWd6ACHTs0IR0FmYlBazmO19X9U=;
 b=oogVaY4uGyA/tBSHBRi56Q+YoyuvbTnWCaJfk8mEJ/nQz6IsziaKSg4mtZYVhflPQUom8p1DDbKsruipP0WqdEEtoa50G7GBoRV1uO0I3cN+3jP7gexQfRTwT83E+W80EeBPE3mcVsPVtAKvYYS730ltAoiMX0qceLmDDcRObxBBKKp/EI/P0hhrJrwGsl/uMH8pJq64r8nxmQeycHYPsop4ijUwInjkGuIed+3Mua+B+HCjI8NC6TplO+F7tppZRhqxEs+4TQSr2HoR+c/g+oBV1GIGkBKPQQDTEWS3kJqeXq8wKKiwBoi0NEah9w1VL+JMbxi9fnIilOyoJRjU8g==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YQXPR01MB6557.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:4d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Sun, 11 Jan
 2026 19:35:54 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1%5]) with mapi id 15.20.9499.005; Sun, 11 Jan 2026
 19:35:54 +0000
Message-ID: <3fe19ca2-0a8f-4d34-b651-61a5554e159a@efficios.com>
Date: Sun, 11 Jan 2026 14:35:52 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 3/3] mm: Implement precise OOM killer task selection
To: kernel test robot <lkp@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 Linux Memory Management List <linux-mm@kvack.org>,
 linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>,
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
 linux-trace-kernel@vger.kernel.org, Yu Zhao <yuzhao@google.com>
References: <20260111150249.1222944-4-mathieu.desnoyers@efficios.com>
 <202601120124.RK3AWOwu-lkp@intel.com>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <202601120124.RK3AWOwu-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQZPR01CA0061.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:88::22) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YQXPR01MB6557:EE_
X-MS-Office365-Filtering-Correlation-Id: 52b2c22a-74b9-455e-91f1-08de5148a2da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|10070799003|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SWVFT1c2WWY1V21IYXRWWk0yZkZrckxDK0FySU8xOUFvQVFNY2pBaFhPcHdT?=
 =?utf-8?B?TlNLLzFvYTFwNmQ2aTlNeHJ5QUNlUm5TM2JZUmk0OEFwRkp5RGdvVldWVk1t?=
 =?utf-8?B?eWdyS3dZVUdDYW5lYkFRYVdLOW05VlNnSldBMHVDanJ3K2ZmZzlkb1R1ZFp0?=
 =?utf-8?B?RStqdFlrN1djNlhxcjNuZGg2M1lId3ptYmVEOGFaeEVRa2U2QXhNbHkrTmdR?=
 =?utf-8?B?R3VjTkorV3NTMnUvbGVCVzNpNGlhS2RUUmxINnpiU2RHeEtWTU5aSlBONVJN?=
 =?utf-8?B?Mk04ZEw3LzIzb0w5MEJ2Q2FZSjZKUXlETlh0Unlzc0g5NkUxUU41THJBSmtT?=
 =?utf-8?B?bHNoZWpYZE4rQnRLbkkvaGNGcXpybTJVSS94dzJYMGdMYjhVeFI4bVQzbGlY?=
 =?utf-8?B?T3RxbXYxUERDL2loT2lrWGhySTFPelRiUkZUdWVNUy9ETVVXekxINWxya0xm?=
 =?utf-8?B?WXNMbWhoVWM5NWRYWHp6a2szem5KSGdhMHE2bGVwWEZuTzN1cGdhRE0rZjA5?=
 =?utf-8?B?NmtXaVM3eU5HdTVIV0Njei95aU1MRlZoMFVlY1QzSTRFMDljcTZBMmdOL1BF?=
 =?utf-8?B?NWQyNVNBdFNvNHRPaEhJV3VWdXVJSmRsNnZZOE53MmZXZVRzbUZzWVE5OFVV?=
 =?utf-8?B?Zk1EVm10VFpGQUNsWjUvMFdwSVBON1FRZ3dBYXRlYWRqZk43Qm9iV2xBcEFE?=
 =?utf-8?B?VVRZdEY3Nm9Ocy9mM2dYRlFucU5yWGFZemllbmhVbkRhYmdaV05VZVRHaU9I?=
 =?utf-8?B?eWx5bFhocVRQY2pjZkpuWnBCcTBrV2NCMWtVSU0zdnM0b1NVdndTOXhhQ3FS?=
 =?utf-8?B?SEs3QndHVUZDaEEzYWwzYjZZVU5tZGxUc1Z5SDQ0R0IwR2JKRTRmVCtTcERF?=
 =?utf-8?B?N3AvczROd0x5MnJjY2dNaUZTVzVoZ0x2bTk3S1NDQW9MTnpLRXFMOFZwTnFi?=
 =?utf-8?B?TmlQeXZYcmhQV1AweVFaQ2hsSjl3REZwaWEvYmJkdXVNSCtyZTJCaWtVazkz?=
 =?utf-8?B?bVNjdDFEK0paZDE5RHkxaUxIbmdYOTd4VVVvOGxlb01KamU1N3BGZ3Avek1X?=
 =?utf-8?B?WUNRK1dHOW1FbkhqSU50aDhsU2E0cmdqU3RJam5uY0VQM1I4MFNMRmFXekNs?=
 =?utf-8?B?ZTFoamRJRWVsaGVwZUZQdCs5NmFvY2VaMkdHWDQ3VlpqTjM1QU5GU1FDenly?=
 =?utf-8?B?OStlNS9NdFFjblZ3OUwrM1ViMHh6MFRFeGpCQ0M4bHhFaG9wenErL1Y4Zm9t?=
 =?utf-8?B?S0VGT0h5Z2g4c0FwSVRqTE14ZU9EOGZtQnBHSHNxS0hWN1AvZGhJY3RiOWxL?=
 =?utf-8?B?ZzdpSkRWTkYyamJ2UUtmMVlNVk1zdHpVdkduZVhXakRFRkw3R0tEWmhRSjNP?=
 =?utf-8?B?ZHlwMXVMMytCRSt3YzYzcitsRmZHWk95VlhOZkh3YVFnWXFHb0dNd2RDeGZt?=
 =?utf-8?B?ZHdxQ0llYVJVNFRTNSsxN0k2OUFFYmk2NG84a3RKdWJBM1V2dEl2TkxFd2h4?=
 =?utf-8?B?L1BPWGlGZzlxbEh3ZDBvS0xVYlNlME5DQjAzYlIrUzRTQkUzaTlkbjNSczJj?=
 =?utf-8?B?MjM3V0NYU1hyZHpCLzRpVUpublZTNWRrdjV6aHRFV2tJUjhRQndOTVlzNWxs?=
 =?utf-8?B?NVN4TjFJeGZndkZpelJvb3h4Y2dXSCtnZlJJS2JpOGNLRXdJbkxEemdLZjFr?=
 =?utf-8?B?RDZmekxBanJ0UlNNSkZzdnBrWnBwNkNkS0V6a05SNGp0bXV4NW1hWEpFaXBS?=
 =?utf-8?B?VWlvV1VyZGZiUkFJVGlsN1M5aUlDV1A4K2VacFlWdE1EcE41SkxjVFAxbnc4?=
 =?utf-8?B?QVg3MkxqTjVRQmk3ZmxvYjNqaDdNOHhYMzhkRzBZSkZKb3pMYk5XelNvbkRi?=
 =?utf-8?B?WjZoeE5VWUppb3F4RmVKdEJxOGF6NEtWMDFOckZoNjVvcXc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(10070799003)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dURMbStJTVpSRXl0MTJ5STk2MGMyejBTNXNjNjlUYjg2bnQvekJHY0RJVDMv?=
 =?utf-8?B?dzMzSWcxODBNSjN0czBrV0QvTGlqdXZoQVVJM0xKL0M1ekRsaFBOb1Q3MVYz?=
 =?utf-8?B?UjhuNUtQOEhVUEdsWnRyUk10MjB5ZE5ZZVZlTzBPbjhTb2t4L2VFaG1GWWJ3?=
 =?utf-8?B?ZzZ1UHJreWgyNFV5dTFGQ0hzQlRPb3lId3NxdXJINmVjcHZDOURYUTFWZ1du?=
 =?utf-8?B?Z1Q5eW9SY0VsV1FGTlJmMklweWF4blRmMnBqNzlIMlF2cXBSVUdNazZNNWta?=
 =?utf-8?B?Q25RdWxOdmVzV2xiZHNGN3Z3bTV3aGR3aW9Mb0ZURmFSNlpQZVQvKzZjNFJS?=
 =?utf-8?B?eXREaVA3djJPTmY3YWxxTllYaE9SN0RRL1UvNjhxaWdIQzVpRDhDY1pXSjZF?=
 =?utf-8?B?Z1prSnUvdDhtaFZ4ZXlvblFwZUhCOUZRQVYwUFNUZ3JYSkwzMWRrNHdVeHNl?=
 =?utf-8?B?Z21mVTJ6YTRhbVZKMk0rZWpQWlV5d2Nwc3dVQ0hTR3BqaGxuVytkaWdnaGpV?=
 =?utf-8?B?Z0d2MUh3Y1dORzN5SXBJL1BlNFNMVUUyVkRHNTQxNmUwYzVtak53N2Q1ODRv?=
 =?utf-8?B?QmNTMjJVZzhnV00wV3ZxSWVwZHhZUXUrN1dDeVRGdnB4TkVrcTB0Z3Z6Mm5x?=
 =?utf-8?B?R3Z6NnZUVnNnY2JBL3o2eitWNVFWaGNvR3JlS3hlYWJvMEVHTW9zTkFmSjlm?=
 =?utf-8?B?Q3N5T1MrSytTOXF0ZytTRzZWS2dlbzUvcEpTQXQxWGoraVc3SHgyV0tyTEVn?=
 =?utf-8?B?U3Vnc0dkZFB5M0dTb2NOM2h4ZkI2dWltL2p4U1hRdmFhUTJJcGJkODNNWWhX?=
 =?utf-8?B?U240UkU5NndISWN6WHMzK01Vc0hPL0o0aEVNbWxMcVdweDQ2Snl0eGF5Z0la?=
 =?utf-8?B?SHY4RVlCYVY2RlBYK0hUWHZuMUJPK01Ud2lhVDkzK09lbzEwbTRhNVhQb25Q?=
 =?utf-8?B?SHV5WG5xY3Y3c1l0NHVFQ3lMbDFyNURaTW9mZURhVDVsQ0hOK0tDczdIZHNp?=
 =?utf-8?B?RW9qSzc2K1AzS1lENC82MDJlL3Nwdis0SEpLbzhFd3loWW1VK0NJTzZGbWp1?=
 =?utf-8?B?ay9uL2tJVW5hTTVXaW9hWU81ZE8xNUMyL1ROZUM4WEoxYjJ3RnFFYlZxL3pa?=
 =?utf-8?B?YnVnbVJnMDVZQXJUbGhTOXBYMzNxMGNoS2hOeHUzaGdLY21XOExEMUtKNU9B?=
 =?utf-8?B?bEtiNkFpallINlJiSi8wVDVXaDlGdklzNVc0UGM2dUoybUd3L2dSZko2Q0N2?=
 =?utf-8?B?WHFCeW5UamNEUUFwUjh5MS9rVnJuSVJ4YXJpN0FNNWRUNHZLZzQwYlhzWUta?=
 =?utf-8?B?NFFXQnJqWk9ZbHVIdTBQZm1xVWVqN1ZQZ0ROQjluTm1QaTNoRFZKWE5GMkhT?=
 =?utf-8?B?d2JpaWxyakEyM3dqeVlTQ1FjRWpEL1NPSzFpL2NmVTV1eHJpMzVDRVlJekRm?=
 =?utf-8?B?UFpxS3p5ZEthd2VnMzlWcVlXTWZoVTBZZmFUOWlQOVRsUlJvdmFYWG1laDR2?=
 =?utf-8?B?czJ0ZWREdmp5d2JZb2t3MndHZnhmcGloQTFIZ0lWOVhPUHVJcU00SkRFQkdB?=
 =?utf-8?B?eWJPMW1RWlB1dzZyS1hMNm5lem10bG8zYm44enV1OVZ3WUhWMGxJWUtQcXY4?=
 =?utf-8?B?cll3WG9OQzUzaU9lKzJWUGJOdHYwa3lNc1RWdUNvRVA3R3F2NVBjdmpwVWpH?=
 =?utf-8?B?VEx4ZlRCQlgrWlN1RUlBY3lqZnRLS2o1V3UrQ216OWNpNTRFbmcyclVyS0NS?=
 =?utf-8?B?b3FEZDFFbEV6aytBRCtiUUVFRTBhS3BwV2Q1ZTJheFBCcjQ4aWJSclUxOVY4?=
 =?utf-8?B?cnZBTzlWNm1NKy9RVEFYeWJlRVQzZDl4K243VkxhWmdhVlVhVWV5dkJZUFh2?=
 =?utf-8?B?ZGtSYnZHMEMrMktsSTVCWnVjYklxZCt6SnpHbGJHSStHQ1hmOVJhZWJqb3Ry?=
 =?utf-8?B?a21nb0x0bVJMbW9aZVBDK3k2ZFhRaHpHNk41TVlJbXcxaW5LSkhVdElXcFJW?=
 =?utf-8?B?RVQ0cGR3dVRUZmZEcXZLeDViMHZXZHlFMk9hUDlEU0NqaU1OTmFZMHhuNGlT?=
 =?utf-8?B?bHFkN2lrcXc1TEZ6bFhoODJiRnZqaTNpK3JNVzFaMUlrM3VEMEVBWHhVT1l6?=
 =?utf-8?B?VDh3MnhJRURtWTc5VTRyNUhhU1dZN3dIbEZSK1poQXRtM1NscEc1a2FIL2hF?=
 =?utf-8?B?K0g0cmcwMlRtSUF4RjNwRTAxNEIwOXJBVEhLV3JXbk1uZXM5UGYwS2hGRTJn?=
 =?utf-8?B?SWtPQjNDNEFXTnhqSVBtZEdiT1RJSm94c3lUaEtIb0JtRHV5QmdESlJqNGxx?=
 =?utf-8?B?S040VGxOQ1ZvQkxCVVRvdkorYkIraWM2Q0VvbVVjbnoyQWxRRkQ4bGROMHl3?=
 =?utf-8?Q?ubXmV9+idw8yyEnsfz4mzFE+w/8MK5BIjamYzNV8iZYfg?=
X-MS-Exchange-AntiSpam-MessageData-1: GBfCxajuRCsAMlgwTrr8eo5PestvBjak3YY=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52b2c22a-74b9-455e-91f1-08de5148a2da
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2026 19:35:54.5950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kvn8II6NTAloTvVlFEQhBWD9Q/LBZTKXij5kGFdlIK+AFsZVUwsKJYY7QwwoFh48NOjOz7or3ZNQNbQ/cADZE5DZaFUT+hCG/rGnY1lhPPc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR01MB6557
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C73CE140002
X-Rspam-User: 
X-Stat-Signature: 5oiw4mo6w5tikzkbans9fmk8rs34i9bb
X-HE-Tag: 1768160156-729598
X-HE-Meta: U2FsdGVkX1+aOnmGxxw7CpSzLfd0u9bAqOw3MzF6J80E9bY9uWyxc4nQmhHfj216AzRhXicC3Kihcyc8m+tHLs6mqpVdjyW//xLqY3hbh4WCuXimq2P5NYSVqynaz3/JxmRx5abO8TaM1g+zuxNEXfS9Vwu9u05W1CswuRPT3bhALtuut64Y/gTGB28SDlPEU2dRFKCFkKgbVnYJKDdn2anf7ipWhC+5M0TE0suLU1p37GNbbkB5CVLoqGkVGEYyxjCquMmTCGH87vCemHsuNmjS6+UkoS4tui7CnpWd+T3cuIJ5DICyCqQWFlopElNxs57RBppe5cvaZzd4BlAVd9gzRNJlfvxx0AlFNTpNLsqPQul+KL+0X6G2Ts1bUkV1Gkir6WuvpEoB8GvHOiPvUCMMw+B0mHLvWP8c486F7NVEdeYmOj+dTO/A+V2rUraT5VRvqPYInmldMLdTStDFMfRwCjQEn5r80DqcOsGasnVOeiaH5LnLD7XVrglRdimQmi71PbrJDMBqXiOPUKKb4T5mnAEsQo22uGqVIbV6mw16o+LWFv35c4WOR6qRuaWFirV1p/nfIt4qU7DZsnjHq4wyFuBbUlT+hzKKjn+fQthc0v39dwPIKjlpP0YYkBQw1uNgl6Kxt9ExDR9bSD7FiYZiZTshI1gyIIlqXV4AOp5UsLUyAcK77WeCdz1EFtInnXPfDsf91kXGfdNZJtpdQwovFDQjcz9CLeYA1scsNuHvRrxUyLL9Yly0uP8XasE3ei/GheK/z/5fWiNdxrBzt2Ilc6xua9Pd6w8Nec4a48N/mCqmApglrryuUWHhyIEf9U/KFVg5PjJbztmAFf+g3VoJ7Ilf3HZadOcO88iXFd3yOpnxA0Mh3a0bZe0eOCdsRgVGsNx2XorEEOh/HT7zH68H84y8IBcyPyaK+epAMpUwPfT/O8c6brQaBviWyeVVqKHA289XOJqhVQCYhUN
 +OVN/wFw
 onXL+74AE8fmVuSwg3Qy2EXyVgFuEuHj5H+65MJunPRfqIhhxcrnDE6fNUmFmcPlLrRgjU50WAW/VBrbWNs5xLmHAEAwO3nWxT0LpBKblqugHC0uJiimMF826rpwHoObnnOMDjwkiCGATNCY3lgs7YpafWkCbZEt/bi2zvahhwGzIUk8sHG1D4ew8GlF8gYq1Z8tQSYXc8XCzaqCCWSTXafJEksTqSEbOLUJyRtG0U7V3iGfkjHiSfahIENYauw//RKgRFLY4KqMNhXKm7eZg5e93NHgoOE/ASel8hCcOWiarYBrn1AWMxJ/arykT2H47YVnyOcghEtBT6BHSh2KBdMd7Ez0WyjNe5zdUI4be6iNyXZWDffaTM11ldNw3hRkimldMoE16wQ+OdZme4wqk2bjFPinrM2Bv05iQRrY26TEYaioib2RRZ66dxClEaPBFDzRMGh+yp/pUSy5EP3FIZ/Ut91DXlTqdfy/Y4w63J6C4vbT74fQeY9rF/VkHOZN+1u7XCu+nWCp9O+1VY2Ylc6EE6jqMSSFDztG95mwKoV3gtsnI7xIyq6/p6Sc7b5CLGiPUqQ5hjFMhrhkZdFhm1W70Rmnb3+p0DcDpNUJt4vtl47qVXBhxUVJHs05LGPPxy9u4AszPGhYORg9jlC+h1mT/idzdEA2zDggMmgYtfRFeCoIzqBAGBpyccidK8ywUmQVS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-11 13:03, kernel test robot wrote:
> Hi Mathieu,
> 
> kernel test robot noticed the following build warnings:
> 
> [auto build test WARNING on next-20260109]
> [cannot apply to akpm-mm/mm-everything kees/for-next/execve tip/sched/core linus/master v6.19-rc4 v6.19-rc3 v6.19-rc2 v6.19-rc4]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Mathieu-Desnoyers/lib-Introduce-hierarchical-per-cpu-counters/20260111-231206
> base:   next-20260109
> patch link:    https://lore.kernel.org/r/20260111150249.1222944-4-mathieu.desnoyers%40efficios.com
> patch subject: [PATCH v12 3/3] mm: Implement precise OOM killer task selection
> config: arm-randconfig-001-20260112 (https://download.01.org/0day-ci/archive/20260112/202601120124.RK3AWOwu-lkp@intel.com/config)
> compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 9b8addffa70cee5b2acc5454712d9cf78ce45710)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260112/202601120124.RK3AWOwu-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202601120124.RK3AWOwu-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
>>> kernel/fork.c:637:6: warning: format specifies type 'long' but the argument has type 'int' [-Wformat]
>       635 |                         pr_alert("BUG: Bad rss-counter state mm:%p type:%s val:%ld Comm:%s Pid:%d\n",
>           |                                                                                ~~~
>           |                                                                                %d
>       636 |                                  mm, resident_page_types[i],
>       637 |                                  percpu_counter_tree_precise_sum(&mm->rss_stat[i]),
>           |                                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     include/linux/printk.h:534:35: note: expanded from macro 'pr_alert'
>       534 |         printk(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
>           |                                  ~~~     ^~~~~~~~~~~
>     include/linux/printk.h:511:60: note: expanded from macro 'printk'
>       511 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
>           |                                                     ~~~    ^~~~~~~~~~~
>     include/linux/printk.h:483:19: note: expanded from macro 'printk_index_wrap'
>       483 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
>           |                         ~~~~    ^~~~~~~~~~~
>     1 warning generated.

That's percpu_counter_tree_precise_sum which needs to return a "long".
Will fix.

> --
>>> mm/oom_kill.c:351:6: warning: variable 'points_min' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
>       351 |         if (oom_task_origin(task)) {
>           |             ^~~~~~~~~~~~~~~~~~~~~
>     mm/oom_kill.c:392:22: note: uninitialized use occurs here
>       392 |         oc->chosen_points = points_min;
>           |                             ^~~~~~~~~~
>     mm/oom_kill.c:351:2: note: remove the 'if' if its condition is always false
>       351 |         if (oom_task_origin(task)) {
>           |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>       352 |                 points = LONG_MAX;

I need to change this to "points_min = LONG_MAX". Will fix.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

