Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C274CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 16:04:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 888138E0010; Fri,  7 Nov 2025 11:04:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85F638E0002; Fri,  7 Nov 2025 11:04:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74E668E0010; Fri,  7 Nov 2025 11:04:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 637DC8E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 11:04:13 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0ABB65952F
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:04:13 +0000 (UTC)
X-FDA: 84084282786.28.5832B22
Received: from YT6PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11022141.outbound.protection.outlook.com [40.107.193.141])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1AF70C0011
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:04:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=kFSVVlp5;
	spf=pass (imf22.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.193.141 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762531450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gg9X8dKBypMP8P3NSrFv5w7QvXv16WoG0aoqrDHXtJM=;
	b=nnD3+Z8Az/lp2yJ3IGHhhPxfXpxsi44tF6JgMt90F2XioCdVhB8yQ/wnsZKsaW1x+9AHwp
	JUzh08CCbqQ6LdKNMCY1VSwPOnTIAtdkMnh1BnLWuENjWXhIqOEPYIOEmGSypj+sfm6EGt
	x54iC1FHwyW0T0StYedFyiFJOsBNcRc=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=kFSVVlp5;
	spf=pass (imf22.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.193.141 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762531450; a=rsa-sha256;
	cv=pass;
	b=nq+WZ4M6F04DNiyq+Q+4uyZJRo4bVSWojs8qKs4jw611DOw93ZquYAuVUs1k6/CXGC0d+H
	Tbm15Z1wATgxt7WahOkRSzRfEWnHnAEcenVhnzP0nvLqQR9m1XpnGPsiDs3E5r22V28kRo
	kUYbJ6jM5nSQbya2/zHhkGXKyXtFWAc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j6/VVMHUJnfb2rgUg8diUl/3DV0m7/neuRPzvuuTbg6Sg7vTXn5XD8LDhyiHnubZpHo9c8HFSfXlc4rNpt34dgPdOromGox+GZMjSQsr0N3eQf3eqAIMnAXgzRMVEMoBeVN7O/TAmi2PA2g4Y/WOe4mrq/yZht4sZ4YPNcZi348gqa/VTfZ9IlpKFsnhZ/8Xu3eVW5dRa4ZgtcaaytUTglNwzmiMLw9Org8Z9iGAW2TeBo0q96QbF5CBzg5PQnFKmrXGTUuKukJORxgAkJAG6koI0uHET0JboTWflJ8hPoYnQu08py35S9VkMqrrefAC75u7uoOpui9vIxdcyoIXsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gg9X8dKBypMP8P3NSrFv5w7QvXv16WoG0aoqrDHXtJM=;
 b=aJMNxiJp8Y1eMAI/sySEazQWzGTfXNK54IT/66X99RJU64KWdMLfTMhOxkSf96BYGTmLdQw8JQniwNdkUpPr1/Zpiue1r4UnSl1NR6Ov9uzQhvWDyg58W9wWPFkRmxobuLZYTCB5b27EFTTSfQjCZUWIqlbAQ1cd9BTxUn9tK1A/wmENf7GqDqVGAJkPbDIRq/xxVdNSmgIRMAFQSVLAEdKAwcPtsm3IgRIto2dxh7CNq5mb1iG46v5hk/jMNXK6nBK7Ya8qefVGNxJAameDeMJtyzVAsIZWiebYf1Fdu+0+f0qdwrNey+fUlStHxn06h6OIEZduPbi0Jyg3C9Aq1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gg9X8dKBypMP8P3NSrFv5w7QvXv16WoG0aoqrDHXtJM=;
 b=kFSVVlp56Au6YUXIJD6eJytkEuuYUlB5CxQ/JjHMeY+lb/azot8VVe6+oOCunWtqlXKAdMtKx8ZK/is+JBJ8QdO3Sh3pqKQY+RveGkK5mnmSosArImoLuFUBphg6kSvxt8vbxgXVxcHgYyYMU8Fs6DQrOZxUdQyvJ0W1b9UQdUUbVVrzNSjDqRvX6Eak4Cmaw9rjrik6dU8HX6LORedRT6c7C3w90LCZprfauPXvFe0fFg4axR/2AT6EqrM46hzf9hhlHSJZhJ+ve0AyF2bCztaBvXO1bfn7cfNn+Ip6oVLXXnMCtmaUMsTBN0QWzLeRX140LXG2nmbgIsDvvJUDHQ==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YQBPR0101MB6555.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:4a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.13; Fri, 7 Nov
 2025 16:04:04 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::50f1:2e3f:a5dd:5b4]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::50f1:2e3f:a5dd:5b4%2]) with mapi id 15.20.9298.012; Fri, 7 Nov 2025
 16:04:04 +0000
Message-ID: <81258c9e-1436-4a4f-9343-ef574b8b0de6@efficios.com>
Date: Fri, 7 Nov 2025 11:04:01 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v7 2/2] mm: Fix OOM killer inaccuracy on large
 many-core systems
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Shakeel Butt <shakeel.butt@linux.dev>,
 kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com,
 Andrew Morton <akpm@linux-foundation.org>,
 "Paul E. McKenney" <paulmck@kernel.org>, Steven Rostedt
 <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
 Christoph Lameter <cl@linux.com>, Martin Liu <liumartin@google.com>,
 David Rientjes <rientjes@google.com>, SeongJae Park <sj@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Sweet Tea Dorminy <sweettea@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <liam.howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, Christian Brauner <brauner@kernel.org>,
 Wei Yang <richard.weiyang@gmail.com>, David Hildenbrand <david@redhat.com>,
 Miaohe Lin <linmiaohe@huawei.com>, Al Viro <viro@zeniv.linux.org.uk>,
 Yu Zhao <yuzhao@google.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Mateusz Guzik <mjguzik@gmail.com>, Matthew Wilcox <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 christian.koenig@amd.com
References: <20251031144232.15284-3-mathieu.desnoyers@efficios.com>
 <202511061432.4e534796-lkp@intel.com>
 <6hmgutxgdchs4qz6hprwsecwoygwszn5ywixxrvnereilegcsx@mxroaotaw2me>
 <7732c2eb-e547-47a8-93b3-1d1b4d9c27e8@efficios.com>
 <7b76f0e4-6148-4290-a295-7ceeb1ef2feb@efficios.com>
Content-Language: en-US
In-Reply-To: <7b76f0e4-6148-4290-a295-7ceeb1ef2feb@efficios.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQBP288CA0004.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:6a::17) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YQBPR0101MB6555:EE_
X-MS-Office365-Filtering-Correlation-Id: 5178c4a2-b118-42c5-1664-08de1e1745e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aWM5UkFmcWhTekFZTlRNNHgwRDR0WlNUa3A0NjhhcXJyS1JES2NKS0VLeGpw?=
 =?utf-8?B?NWluRWNOUFVoTytieGFSZFRsTytFZjd6YkVUQUo5NU5BcmtVUDE3RHloQkxK?=
 =?utf-8?B?ZXJCSkI0aVRYaFFsTW43QVFINzhpTGJwcXcyNHdlMFZBRDhRM1RxWlp4Vkto?=
 =?utf-8?B?NWNyMUU1bW9kcW1mbGlTb0RWY0xDRWlSMEMzbStmYkpWeWwwWktYNWlrWUxR?=
 =?utf-8?B?MWpQTWdSOFNyNVFLNXdUNERmd0xsaDVRMWloVWF0aXlUM2ljeUVuUU5qSGVl?=
 =?utf-8?B?M1d5M2VjS3dIQXlTak01RFI3NzFCeFdDSGd4NHRRRFYvdUxJQ2VUS3BGVWxE?=
 =?utf-8?B?QlRuaGpTM1FqL3NZUmhHYlA2dzBnRVgrSTQwN0RsWDJhQU80UTRMa0dNQjVI?=
 =?utf-8?B?ZUUyS2hPRWZhWEtUai9ldjk1YXA3VUJvUlVGc2ozUUQrbHZGQzJQaWxmTU9N?=
 =?utf-8?B?YXpQOS9KNVgraUpFSmE3a3RzV2tYeFpTMlZnbFI2Rkk3eG5oZ09TN1F1MHN4?=
 =?utf-8?B?STV4OURHMGsyRzc3VHVWM0pZVU9jb2xpU0ZlSnl3RGRyZ0lFMWdITklQd2pC?=
 =?utf-8?B?blhmYS8waGJhemtsc24xZmd6OFZpcGFNRzcrRU1vYUxiRjFCV3NFOThKSGE0?=
 =?utf-8?B?dmZFRnN2c0hZQVIwNGpoTDlrS3hJeTVMZnp0REpiYnhiZTN3d1h2YjRsY1F3?=
 =?utf-8?B?NmdrZENOd3R0akZKeTVPaWdRTytLYWZsSC9XUXc0ZUE1dGRjWWpzd3JBNW9m?=
 =?utf-8?B?UkNheEZQUm9JcWNDVUNLZEdZTVpJWFFlZTNkQ29JbU80TVZhTFBldEhFamZO?=
 =?utf-8?B?SVducnRWak9iNHpTb01yS0xLWk1ZbWJ0V0c5S3k1dW9WUFJxWGE3enJVeXFG?=
 =?utf-8?B?bzl6VmtMc096V25IWk9TRGlpMXMzU0FOVlloV01mOS9qcXRGRHJTVWt5c3hy?=
 =?utf-8?B?QWpmdnZqQVM5MHZZdTZVSERrMk1KQmo2cnQwdmRzKzIrdWdMc2p6N0NxaGg0?=
 =?utf-8?B?NE04SVJ2dXlFbFk4QjVzTmJlc2xONlk1OXRtTUhBc3JNb205Q2RUb25vUzMx?=
 =?utf-8?B?a2FHSlZLOHBqZ1g2aGFxNkh6MlErZkI1MDFPdzIyTkxoSjhud1dMdDJXbFl2?=
 =?utf-8?B?VmV4UVYrUnU5SC9pMzJneG1ZTlNRNmk0ZStwa3FLU0lXSEw1d2N3d1o5dmdt?=
 =?utf-8?B?TDRKckowRWhJcFg5aHdEb2tFNUNiay9KeUhLLzZMT1JTUUc4NTkyS2xwQVRT?=
 =?utf-8?B?Qy8venovdlFDMmQ5V1IrZzBRMUZVSnBuZUtrWDZVUGtZOGVUU2p1MjkwMXd5?=
 =?utf-8?B?R3N1ekR1NUYvOWlxVWdBbFNSb1k2bTVyVFUvRkQ5cGJHZnpZNkJ6M2IxbW5U?=
 =?utf-8?B?cVlielJtRW1KSi96Nno4eXc5bXZPRWZRRVFsNmY4Vm43bnJVWEppOG1HS2RO?=
 =?utf-8?B?QkJERUgrdFpNTVFUckFFaHg4aTd4Z0FzRzhONlYvdXExTDRoOUptazNlOGpB?=
 =?utf-8?B?RUZQYXZNVEpLZTY4d1JaWGRJSkRmYys5QnMyTW5YT0lld0t4UERFU0dRUXM5?=
 =?utf-8?B?eDNXSHpPZElpRTUwSGhXZGpQYzMwOGw0TWhjbTNIbGpsdUhvVTFXc3A3WGVE?=
 =?utf-8?B?YklEbDNBUmY3U1B3QTlxYmVrbjFMU3g3VlE3VlBUT3hWME1KbUM1am1SZFlw?=
 =?utf-8?B?U2pZU2VKK2lCaTdSajFwb2M2OFdZVUNyMGRNekpDWXF1N0NIOHlkMmhMZHRa?=
 =?utf-8?B?UDZPUU9nSzNFdWNFS3JRZzZnZ3dId2JMUXovblQ3TkF6QTFJM1lhRHFEeVlE?=
 =?utf-8?B?SG84WFdTSjY2N3JnYTlZNzdXY2N3YWFRZ1E5WnVwdy9sbnB6ZjVOaGVIamxi?=
 =?utf-8?B?aEhnRWg4MGluYjBvWHJ5eG5xRnU5dVZubGkwTGEvUHppdkE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(366016)(376014)(7416014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WEFXT2x6TmFLOHowcWN0eW8wOEd1V3ozTFA0cUJKdHR3ZXcvdC90ajRlSVl1?=
 =?utf-8?B?QjNZeFlSNG1UM0RUM0J4OXpCNVRCOTZCczhkVVU1cGZ3OUtMeUFraDQ5dDhp?=
 =?utf-8?B?ZHdhQzhVK1BqdXZzd3JOQkh1U1lEeGZuL2ZhbU5WdGRBSHpNS1EwV1pqU3BG?=
 =?utf-8?B?elUyTjNCVlVGd0ZrYWMxTTNIUGQ4dS9oUWUyZlMvYkpjUVVoR1o1aHlkR256?=
 =?utf-8?B?eDVObTdVbkgyQ3RQYk80b3BLUVg4RlBsd0V6bFhtNDNDME5lT1F0bGtBN05l?=
 =?utf-8?B?UmdmbG1HSTZyZWFJaWFPVUlZdVhqSGJpOTZxZzJxNzJqeTgvN3pPWmp2bTFh?=
 =?utf-8?B?R3BjZmlTQUNaL3h2VWx6YkZIYmlUajk0dFdhMDdJMVN6d2IydHI0Y0ljNk92?=
 =?utf-8?B?UjRHbW9XMStJaTdQVllTNUlnR3RheHNvc2RxSk5Kbnhjck5ON0FjcjFqY0Vy?=
 =?utf-8?B?M3BSb3diMnZ5aDczd1dNNHBFS0pGWEJudFBxRXZDYytTc1pydUJvRjhrZGhr?=
 =?utf-8?B?eFVxNzFoaVBwS0ZFZTJvQjJvbXB5d08yMXYwNHBQZlJ0N0kwN0lsczkzVnBt?=
 =?utf-8?B?N01Db1JXVnJOTm8yTnhMSnozdkZpeU41YnNPVS95bzdFTDhhY2RYZGVVdkdB?=
 =?utf-8?B?Q2VlbDZBOFRaaWNpbXVwWVNTTU5RTUZMc1dlQUU3cHZUQktsdjJudG0rMlVX?=
 =?utf-8?B?b2ZPRy9XellKVnZ0cmMvb2tya1NOVk95eTBSendMTmdhNm5FbzRCWWhBQ1NQ?=
 =?utf-8?B?Ylh6bkY5Nk9BUGo1ci83R2ErTU1yNGFIVTJ5SW0zQkl4eWlNR3JqQmw3NnlV?=
 =?utf-8?B?Rk1Fd0pHczZhWTFINFgrVDh2S3l6S0RnYzNXS3JlMzB6MjdFangwSVcvbGRs?=
 =?utf-8?B?YytabE5WZTZOWkRzZXBZeXp1aXlSRWFJR2FaWFpOWHVLWGhEWkZvbCswYkVu?=
 =?utf-8?B?RU5xejR2NG5xQmsrOFRvQkFubURvZG5mdktnNHJTWXJHTEZ5bHpkRU9PZTJH?=
 =?utf-8?B?dTZNc2lJSm9MbER4WER3d1IrRXFuRUZBc1BxUW94OThiL0ppc0Fndk9xTG1L?=
 =?utf-8?B?THNNUkpPYVRxMTZobmt3VjhhbWxkUUtYdkp0eTl5T240UHZ2UmM2L213MXRz?=
 =?utf-8?B?ZHRwb1FvTDIwYjZiUDh0SDNiQ2ViZVBuYTFGb0lvekF2Nzc5Ujhmb0tzSm5q?=
 =?utf-8?B?ZW1jbHRNQjZhd2Q5NkI1bmpIb2NqbjFnOWErU0I2MUNpVDNVTFRoRVlKaS8w?=
 =?utf-8?B?ZVNEMWhoMDgvTTN1T3daa0lpYlQvRDl0ZlFyd1RrZ0NvYWxOcXVDZHBOVjZ1?=
 =?utf-8?B?L2pzcDhUWnVycW1tVXE2TnZxNzJ5OVB0ZlFKUlJ6REJRSW5WeWlSNG9SUWVq?=
 =?utf-8?B?MURXdEJFaDVwOHhJVGM4MTJoL3I4MEM5bmlFRGduUVIvRTFYT1NSMTU3TnBj?=
 =?utf-8?B?bDA0OGx0L2xoRXo0L2VLWlVaS212WkExS2dubG05QUxjKzdmaVU2N1FpOGJw?=
 =?utf-8?B?T1lHeUluVkEyRkN6Q2FJc2hHVmYyZE5DYXEvdGdlbTBVT3VCcW1RVmV1TnNV?=
 =?utf-8?B?cEV1U1ZLOTQwTFlQS0NYeW4yQjd4MVVZRWExZlJOaVphWDM3S0phaEVueWI5?=
 =?utf-8?B?MkhyVE4yaStKNk8vQkZjWXdzZFpLVXNoYVo0S1VnQVFWNFhLSVhYcEFsS0JV?=
 =?utf-8?B?TUNFQ1dqM1NqUnZIUmJocUhlN0g0RU55a09yYWlIdTVCZ2FpOUtnWnlieDRJ?=
 =?utf-8?B?K0xVWGNtVTJ2K2NSRUo0c0luRiswdUcvSGtHc2hPNERrdmN5NVBPdTNOOTZm?=
 =?utf-8?B?RXFzN0hxUlFJR2E2V1VCYUYyeVBqRGxCU0NyUUVDVHNvQUlQUmt3dnRMK2Zz?=
 =?utf-8?B?QXczZTEyZGZ0OHpTSGhnZXZEMzJ4NUdzcUtlUHhOYmZyaFhuRUhtMDBuQkkx?=
 =?utf-8?B?RjJqVm9COVRiK0oxZ0ZwcUR1NU5HTFRGYjBGd0dGK1BLcGdjSFgzdmduYk1P?=
 =?utf-8?B?MUNKeWJvYVdVVlZqYTJvK0RQREJsWkRHdjhIeEhZZEFqQWNFZ1NEdUliREJv?=
 =?utf-8?B?Mnprbi94c1ZjM0NsMzZQdkpDVXBMME9vdW5yWG44cGpvYkFUdHp1dUJLVVN2?=
 =?utf-8?B?eWR2aWZZR0g0amxtWjdKRXo5S013NFR0MTlyTUxCalpVWVcxTmJJN3RwbEw1?=
 =?utf-8?B?aklSWWh5RThJNmRGRS8zSnJrWWs0U0JQcjAzUWlPaHFQWTZxRWY3RkhHWUVM?=
 =?utf-8?Q?YNx3RNp09GXelGdWUS9D5iroCHAtt5UlEJbUfVLX8c=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5178c4a2-b118-42c5-1664-08de1e1745e2
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2025 16:04:04.0454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bmfJ5RJT3UY0SFcu6Rait5p1qx602k4/j818EITzgz/K9QsghrbzTnpiCT1y6UHKRdyUnXQ9OyAwDFxgfi8bMf9EawpoPyPMA05QIEPlwk4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQBPR0101MB6555
X-Rspamd-Queue-Id: 1AF70C0011
X-Stat-Signature: uco8wgh4gw41oh1d9drc6wx7a1r89u3r
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762531449-710210
X-HE-Meta: U2FsdGVkX182UmhGUlM3dBPwt3QS0UKabvU9zMoHnmX/LF1FoINMk0ARggr2KvkxEBwgrc7xA9ijHLXsOSummKaI9I/1GOOTa11hmbcEdJQ8JaFDZZ2/vbzkUnNpFpE2nx2MJvovTUlTfouqmenOgVsAmeHz6tfwO0BTWruJrfqrxa4dSbk35U1CW8aDCltYW+ahIXKMrj7N3zF5WQhoXdGa0WrtEL4seAwxHCf4e/0NCjfYPzvFmRxFlsS+z0o33rGKZsFoycPPgKjexPKCHXleAD5mx1vYGGQFay+YzsryKPr4hew/RsW/aLTX9842EqFzIEXJ33/J5m6AVqOnr3Cc7Un4QlG7ZCyQ+T9F1R8V583ol75Ag0syULKTnI27TLiFKKqfdQWWub3LqkRyBFAAiRQJFVzdJMsMScoBnIAI9jhoF+nVBNhtr5QOPj50pl9suPmEUDVBVCH1yNiC7pZuitjrsaMxHbBoldYErQtCZDxEhRvKg7E7r/l0xOYYWQN/FI8nAV7X2vw0b/cMogr3jAGVYT1OOAxZzde9JjL2T0SU2EwP4dXoprzyDfFfmLOns3BFEnzG2bi6QP3NJowewXAqet0cvoghSbnmpnk3TCVXqUeTGbzs5RU3n8W1yOdYMtNZwSAm8wrWtEEvgxwP2JBfaiJp9SN2CXpd3rzd94K8sQ+Rqxrl02X0MupW2na50x5xGJzAB95f0l349P1ZfBctFfjEkG4meyQVUHNa3FkzEhql8OlEa/6RY5/UCpx0DpPAXTmxfeaLoIv0Gc31Vfdb/sH31R3ZvnxoGt+Sg6QPDatIuw9V4WrrvM9LBWYYFiyC2F6c6WDGxq27q33zSCsak0uRNds/b+Fk7L0jFFPOOujuBsyNQQr7DZYKjcwoJ6b9gAvzwMXcGTg5ty2n/B4lOLZ+6IZxZZJnNmGaPgmAFQJcOG/WbGx/1p74XNSJcP2/uTw8fISB98e
 6COFVyjo
 Lr5Z10ybusELjsmpd+82a9Qipr1noNWmoYTtw/sftvNMom2dCqK5vMItSChGqSfTvPkVksaOZkBN/GZ8KqnydEcXY8EN56Gj9UiPpxOwASNsan8cdSkbEilqvLwaAQ/aP+nBNzBRwIecv9bahxKOWaChaBGFEoz8xEApBrArtTARFILO3kP1CwzXUqMUO5hCBLbK9iYpdJbWp67GPtmwF/AhVabyuyyk0MtKU/b/MguD/rod+IXU1WYLOHrZDwvORqoly6dkSQbWhWup98DaEFnZldC2N3D7/FrDMHgCeDxV6peXubFY1DwP1pWMI2ffehJKPZq4ORq8oRZzGuiPh3WF5Uv2F98ez3yHoY/UcJr87BbDrbaA9uGSRLLSj8H9gMb32D0ToY1N/QsHv2hlbvspFQga+ZPvd/Lc3VvntHDyRcFP+1co6mM/oW9mY+5CaJEKsaEM0K5qPVVd69aS+z44ZxxnLDWBr/+8ddQFu3KLz9x1Vq9mlRzMii52QAYSl994oUtFkiOVum9K6jjQ1isrbkAsfKHqZShoc8WR1Qi5hd/6aU9TFSPW7vpf4QnDpW4ty+eS2iDXo+9WIWpks3AbNOCvtrWmldcBPcRqNHis+hAg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-07 10:53, Mathieu Desnoyers wrote:
[...]
> 
> It would make sense to call an explicit percpu counter tree init
> function from start_kernel() between the call to mm_core_init() and the
> call to maple_tree_init(). This way it would be initialized right after
> mm, but given that the hierarchical counter tree is a lib that can be
> used for other purposes than mm accounting, I think it makes sense
> to call its init explicitly from start_kernel() rather than bury
> it within mm_core_init().
See the following diff. If nobody object, I'll prepare a v8 which
includes it.

diff --git a/include/linux/percpu_counter_tree.h 
b/include/linux/percpu_counter_tree.h
index 8795e782680a..40fcdd6456b6 100644
--- a/include/linux/percpu_counter_tree.h
+++ b/include/linux/percpu_counter_tree.h
@@ -41,6 +41,7 @@ int percpu_counter_tree_precise_compare(struct 
percpu_counter_tree *a, struct pe
  int percpu_counter_tree_precise_compare_value(struct 
percpu_counter_tree *counter, int v);
  void percpu_counter_tree_set(struct percpu_counter_tree *counter, int v);
  unsigned int percpu_counter_tree_inaccuracy(struct percpu_counter_tree 
*counter);
+int percpu_counter_tree_subsystem_init(void);

  /* Fast paths */

@@ -191,6 +192,12 @@ int percpu_counter_tree_approximate_sum(struct 
percpu_counter_tree *counter)
  	return percpu_counter_tree_precise_sum(counter);
  }

+static inline
+int percpu_counter_tree_subsystem_init(void)
+{
+	return 0;
+}
+
  #endif	/* CONFIG_SMP */

  static inline
diff --git a/init/main.c b/init/main.c
index 07a3116811c5..204d9f913130 100644
--- a/init/main.c
+++ b/init/main.c
@@ -104,6 +104,7 @@
  #include <linux/pidfs.h>
  #include <linux/ptdump.h>
  #include <linux/time_namespace.h>
+#include <linux/percpu_counter_tree.h>
  #include <net/net_namespace.h>

  #include <asm/io.h>
@@ -969,6 +970,7 @@ void start_kernel(void)
  	sort_main_extable();
  	trap_init();
  	mm_core_init();
+	percpu_counter_tree_subsystem_init();
  	maple_tree_init();
  	poking_init();
  	ftrace_init();
diff --git a/lib/percpu_counter_tree.c b/lib/percpu_counter_tree.c
index 9577d94251d1..05c3db0ce5b1 100644
--- a/lib/percpu_counter_tree.c
+++ b/lib/percpu_counter_tree.c
@@ -379,7 +379,7 @@ static unsigned int __init 
calculate_inaccuracy_multiplier(void)
  	return inaccuracy;
  }

-static int __init percpu_counter_startup(void)
+int __init percpu_counter_tree_subsystem_init(void)
  {

  	nr_cpus_order = get_count_order(nr_cpu_ids);
@@ -391,4 +391,3 @@ static int __init percpu_counter_startup(void)
  	inaccuracy_multiplier = calculate_inaccuracy_multiplier();
  	return 0;
  }
-module_init(percpu_counter_startup);


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

