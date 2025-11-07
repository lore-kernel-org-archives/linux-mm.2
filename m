Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 901F1CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 15:53:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4FD08E0005; Fri,  7 Nov 2025 10:53:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D276A8E0002; Fri,  7 Nov 2025 10:53:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF00D8E0005; Fri,  7 Nov 2025 10:53:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A79018E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 10:53:42 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 36A5D88E7C
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 15:53:42 +0000 (UTC)
X-FDA: 84084256284.25.2A169A2
Received: from YT3PR01CU008.outbound.protection.outlook.com (mail-canadacentralazon11020129.outbound.protection.outlook.com [52.101.189.129])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4D5B3C0013
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 15:53:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=uyS6dEx5;
	spf=pass (imf28.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.189.129 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762530819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SqsXwDfFxylF3avGzTXd8Ynrg+KWkFKB3T+mY4YOZDM=;
	b=5Vvn4hpsd/4zz1hFU9Iv+B6O31rSDqlStsPtDvnFgDomRZIq2weTnjYYThexH6tqnvZcL+
	BoaQAbWlFaDHR+wgCKVMW51qgUo5K7zUA5BU3EV72DZNbz5dzkL+JgTsEeghTcUdfRp+fl
	EWkxJE32lbULU1i+WE24K4rgDm+mWFo=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=uyS6dEx5;
	spf=pass (imf28.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.189.129 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762530819; a=rsa-sha256;
	cv=pass;
	b=DECShUyT0DzRw3a9wGA3kciTfHHbpEOsG1wgabnwt03DT0jZ5MsT8klCAdjxrjXM/lgmxF
	LlpLuAz/Dheg2VUG7l9MnLJSzlvv4FF/qGkiQE21zhdo+mX0ak8NcjH9dMO5sMnr5ARhYD
	zJ36vUJzyNeT0EsCd+zjwIf4wB+wWdI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UtSx4UiYUgms0vtNCyWlblgJGkG6tvKroNBLJmILF7cuLszQhADcRpXXSdN0Khw8r6nOAPTrzYgju/VyLaR9LLO1/w0rEYDH6PvbnJHHhBULrePY5gd/uZeIIdaCyHnjqIK3Mvm35qzq6D6+tDFjECvhh9+ABP2eKMOHlAz5XXbjTRTa6eSvWZd/6jc5oa5RyZKy3Q9FCRTidf084iMG4H2Rm7QDzP3c++MkYQH11mHRrLeBQqhWiXxmw1gRrY5EdYQBuEyeACNo0kM2WDP3/PmY4Mla69zs7gWfOpvCcwqV0cEA70ETKdsIoMFtn35tEjrEBfs18kROlVMz4fZ1Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SqsXwDfFxylF3avGzTXd8Ynrg+KWkFKB3T+mY4YOZDM=;
 b=ggep9qpc5o8UGi5z7TSBaLU+uzzVQjCHcnp6yT7EE9fW/HUiJG18dqz0DUCzi5yW2nNwFGuMYfENyjG56qsSFbEvSbmnGRtoy7KhByEtfEMtnJ+/fNj+rDJM3juYRAgdaSsV6oIctzCNceyOYYMqh2isRY1Ly4CJUZRVJN69xB6sI3GrixZkffMMrMP4kbPt6nhgFb+WXmHcHQeYqqRVb67zYh0DhQ4PCtycfeeN2MqPiBYFVZcvqtjgjGaBoLrviH8+A85cj0nzemUVL92rx91Hylt24HvvNEz/si2397tR8TCz5xQW9wNEumcTuC/WAu5JUAu+4uY+jFSz3fBrkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SqsXwDfFxylF3avGzTXd8Ynrg+KWkFKB3T+mY4YOZDM=;
 b=uyS6dEx5lJOJpzh+tafqimTLoqLdAXxqzZNdVVpjtyvbfeR7r6LAI4nvFg26pehjh0h0BzwCKWCHFmHm0XGh2CKRXl9sGenaAdlS9aqADxL8oTROwgZhynRPNAaPqji/ExXpkoClFkUUYIgd/H6+tZK7hYhcw3x0n6NEsqy31NXlNLT39rh55Kep6WxsgyuPpvpE6I+6zxU4/u1rZI0HfyvREF2Wof87GYs3VaFItpNzqojBLDJdbyK+LtQN/Xl0xRAWFjV7DBPO1GDF9frpQqVrxR84/k1/lNaPjPt3J0o/lmfA7CbsoQsLNv7/lUaBZCV+mxnoXBt96ZF9v9EruA==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YT2PR01MB11469.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:163::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.13; Fri, 7 Nov
 2025 15:53:36 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::50f1:2e3f:a5dd:5b4]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::50f1:2e3f:a5dd:5b4%2]) with mapi id 15.20.9298.012; Fri, 7 Nov 2025
 15:53:36 +0000
Message-ID: <7b76f0e4-6148-4290-a295-7ceeb1ef2feb@efficios.com>
Date: Fri, 7 Nov 2025 10:53:34 -0500
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
Content-Language: en-US
In-Reply-To: <7732c2eb-e547-47a8-93b3-1d1b4d9c27e8@efficios.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: YT4PR01CA0322.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10a::11) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YT2PR01MB11469:EE_
X-MS-Office365-Filtering-Correlation-Id: 0119735c-0cc5-4cb2-db8c-08de1e15cfb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TGplSjlocld6ZG5CN1JpSmM4RkVTeCtJV0JGMlpZRUp6WEF1aUFZeW1Wa3ps?=
 =?utf-8?B?THlScnRVbmpKL3ZMdzY0ZVovVURXUlkxVmhKTnBqMm4xWTFWNFQxR2p6b3R4?=
 =?utf-8?B?bHA1ZGFxQlpXUnk1bjdXOS9oSjRZQk55cXk1V0pmTjFubmRDLzhycW5DKy84?=
 =?utf-8?B?NTgxQlN4OEg4bEJZOU9hTXJRWkgxR0dTenRIdzVBNGE2eGNZVVlxQVlIZzFC?=
 =?utf-8?B?a1R5OUw2cXlKdDBHbERBb1JubEx2NXVrOVhUWHhuU214TjB3ZWxtVkwxTmlq?=
 =?utf-8?B?U0Q3QjF5a0wxUGxOdERIZmxwUm16UmU4em51QVdMYzhLa052Ymg4M0RkcUV5?=
 =?utf-8?B?OVI0bVNUZW8wY2NoMkpwcGxHelJ3cGlVQUFEUzZ3ZmtPYW5pWE45UjFpMjMx?=
 =?utf-8?B?L3Q4S2o0SlN0U25HRzR5dDI2UzV4d0tmUWRiL0EzMnRTcWtRSXRlUDRGYU9D?=
 =?utf-8?B?aElTL2lNS09vYzFwcFhTOGFqSzJVbDNpcTlCVkpBTlIxTDFLSjMwUHZXMnYv?=
 =?utf-8?B?MzZqRTZneW83MVFJbTdqOGhwcmJYSHIySzVtZ1BiRHFkei9Lb1QrYWs5bE5N?=
 =?utf-8?B?cE5uN2IxY0JhMnRaSVNYcnFsZHdaVlJJK2tQdnFPZUlLazFjZDZOVk1vVjg1?=
 =?utf-8?B?dGVNOGhsNERtYWsvT1NQelFhMm1ieSt5aVBhNlA0ZDBMaklHZlBSQy8zSFNJ?=
 =?utf-8?B?TEZoajczOXRVVVdpbmFLTDQ5RWNsS2xjWWxKdldodHdtNGlOeXR1N0hjQndy?=
 =?utf-8?B?MlA3cDNsVVp2d1YzcUJsZ2tRRW1ucC96QlhjbnlXb1BCT2M2ZnA3K0lxeFBy?=
 =?utf-8?B?cGM5ZER1NWplT0RNenUwSnNyWmdKdUE1WlZFZ0J4ZFNKS0tINFQ5WUV5TkVm?=
 =?utf-8?B?NEhwT2Z1c3M2NmxOZzZCN21MZjlDOUlBb0lPS24wYjBjUjB2RmNZL1hSTHRN?=
 =?utf-8?B?dVVpc3IzalZSVmxTTXJpNkZtSXpCeDl4YXRaUXo2K09TMDdINXFxNEdoNXI1?=
 =?utf-8?B?ZDR2NnhOdHFPQnZ6bGVyRTA0UzhXS29yQjJ3UGZnc3AyS3hoSnR4VXE5SE5I?=
 =?utf-8?B?aDAvSFJwM0ZXYUVDR3BLc3hNa1FKclZ6QThiNEFRVXhpQ2lPUml3Q0syS0pt?=
 =?utf-8?B?cUlkaDRNVUpraWpKWEd6QzRBRldvdmVXZ2dJRU40anZ6eUluenBHMHgyR1d6?=
 =?utf-8?B?RFpOcnJuek5ZYm9pcnpJQjJ4NjEzS2JzeE91eTR1WVlINTZibE5VRWpVc1Zu?=
 =?utf-8?B?ZjhsMElxVkJHQWtPRVd3VGhVWlRsUHZYTk04YVBQTFp5UzFUK21DLzJGUUdO?=
 =?utf-8?B?WDZFSXhXWHpjcWtwSGk3eExCK2lUYWNjS3ZBTVRjaUlnUy9XdGhpMzE5YWlJ?=
 =?utf-8?B?anlKdS9aSHRYQTlnZlVTYW9hVlljY2FOZklWZDVSMmcwN1FxTFh6dU5GNHpW?=
 =?utf-8?B?ZEhCYVc5SjJ4MFBIVWRsLzc3UFBaZVdWaHBaVyt1MlUvSGZQZEcvTVhhK1Bk?=
 =?utf-8?B?aFp6NDhQR1U2aEdvVXd4V0kxOHFRaHdaYlA0Z085Z0ZNUHVXVnE0RjhRVEls?=
 =?utf-8?B?UFBDaGtkWWRGVllvVnhBeFV5NG1xOEJhVWlhT2V3bWdoUEszVUpMMFNwQUs0?=
 =?utf-8?B?bVJuNmZhczhabGJQT0xNZ1lFU3dYVjVSeTBPZ1BhVHlVMnltUEsxMHhvcWxC?=
 =?utf-8?B?MDNTclAvOXMyckpwTEkrRngyWlp1RjVycU9wdndKWmpPaEZPYTlRdXpCSXhM?=
 =?utf-8?B?Z0tOb1ArL0ZNMHFDN0huSWsyWFYvRmVSbE1CV044SXB1ck5yNlpmbTEzQktQ?=
 =?utf-8?B?Ny9qZEJweGRYWUFOSDdxYXplTDNvVk9ZY2x3azlaMnNHQk81YW1YaGNnYURm?=
 =?utf-8?B?MHhyZWRaL0U3bGg1Zm52d0htTzJRT1BJcjFzUm1ZQm4xL0E9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(366016)(7416014)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eFM4UitFclVVdlcxamczYTJmVHJoWHRMZFhyQ3RucjhscUZlRmdHbCsxZThC?=
 =?utf-8?B?YzhGY3ZlamI3azAwc2djMnEzWWQwamdKMjZpUTU0UjlxTlVIYk5NWUFSK1pN?=
 =?utf-8?B?UXpWc202anBpVkhkSTRuZmZIU1NKVWxaV2Voa3c4aWJFS2hPSldSSHRWZFFn?=
 =?utf-8?B?V3hSZU9CYkdENk5IbUNNT2MrTkJiNWcvL1hVNWV5SUhGZUpJdkFKK3ArcVBl?=
 =?utf-8?B?cm5NUCtYMnpNZHc4RzRYQ3BaM2hpeG9PV24wSW9Makhkc0szWThHeEMzSG9w?=
 =?utf-8?B?cXRmYmw5c3FDYUtaR2o0cWN3SlAvT0hseWdCY2QxNXdCN0IzTEI2SkhZUzRw?=
 =?utf-8?B?ajZEM1lSWkxsbG93dzZMSm1aOXZRWDRvL3ZBVGJNSDF0cTR3cENyZThndm53?=
 =?utf-8?B?SGJYenpia2pFOUdXcWdLL2g1Q2s2L01scml0VU1qMUVSRTdNYVVnVkVHdk9j?=
 =?utf-8?B?SWRpVG5tVXE3ei9jclJ3bGVnR3R0UzNtbWsweTUyUFFqdVIyTEhRK09JcjZK?=
 =?utf-8?B?cVVIMjdqM0JHcXVUK0o4M3dIYzJwRkxESFlXaXUrVGR0K3BndmhscVQzOERQ?=
 =?utf-8?B?T0d3VjNWQjJ4Z0Y2REhHaVJIMGgyMjl1b29xNi9NMTNlY1krSDIwSnI2VjhB?=
 =?utf-8?B?OGpnSllmSmU3S0dnYjVIRFFaUnM0clE1ZTZhTzRPdFV4dmRVeTRsVXJOMUND?=
 =?utf-8?B?RC9aU09EdUJPbWhtWG9weGRmL0xoQnJiNWQySlQyUDE0Qk9vTWZ1dGRxb2tx?=
 =?utf-8?B?VzFVclZtTlY1TDFnWHhTQnRPcG5WU2JpVFZ2aHVPdmVzL2lITXMrNUw0RmpD?=
 =?utf-8?B?UC9mY1kvelJvL1phRkhEQkpOZk5zNFpKWlkzTFFXK3hrRDBDWWhLUk5Ub3Nz?=
 =?utf-8?B?bVVHY3llTkduc3I4bTdlUExzcDJCb2VTMHpUc2tBV0ZzQWY4NW9GaXd1Z1Ix?=
 =?utf-8?B?TGphd2N5bldVYk1RVGFRN3FvQzdPcVI3T0xWQ0U4UjhucWtTdXQxdmF2a05R?=
 =?utf-8?B?QWJHeWNxT01KZkV5RHhTUHhHNGEzY0lOWHBEYmxyUnJVZDJEKzRFejdNeDZV?=
 =?utf-8?B?TDFXQUs1TmZhYmFhTHBYc3lGR3BFMStGN3JrSHFlL0h0MXFHa0xEcCtnSlYz?=
 =?utf-8?B?di9PMTk0NHNoWVdQSG5HUUlNRDVWRFdyb2JySk5hR3g3MWUxZWR6QnlLRnR4?=
 =?utf-8?B?WmQzVmRRdmpOZmQ1Z0pMUjdGcS8zTVJuL045ZEVJTU9iUzJBYzFCRm53SVlU?=
 =?utf-8?B?RzNlczhkY09yMkhSOFRMVVppWEYzbTNkK0pkODBUU00va0hVRFZ2djlGT0N3?=
 =?utf-8?B?RTFjTlU3RENHWmdlYVN5bGp0czlrTy9yeVZ1UGUrMXlCdjRneWdhTVZqc0JM?=
 =?utf-8?B?OVBkeTNYMnY3NldnTE16ZmxBWXVNQml4VmxWaGJoUUJSTVlEcG9uaDlGNUI5?=
 =?utf-8?B?cGtNYmQzQXJHTWE5UVNuY0orQms4NlhtNjJrT0lJMHRSNjhQWWRuVmxJK054?=
 =?utf-8?B?ak1zdVgzS2FJWFZ3aWhsN1ZKSmR0cGNQTTl0amNwTzhEcHA4VWV1WU9sT3FJ?=
 =?utf-8?B?dTQwN0ZHcE5mbmZFc3N5aktvc2ZCOWNDUXRqS2lHekE1ZVpSdUM4NkJnNThp?=
 =?utf-8?B?Sy9xdlFCRFNhcWRqd0t0ZFJEZkNRZ0pLUXlYazQ5T0dZUVdibHVyVC83THpW?=
 =?utf-8?B?NVY1MVJrMjNJZklkbVFrZE5CUnp3a0ZiSngyY0loVVR0VVlsQU1JM090NFQ4?=
 =?utf-8?B?dWdQTFZqc0VhQi84STkrMVFSbit2RW5venZvRFpHY3hiQ0FtUnNWdFZyQk02?=
 =?utf-8?B?bG5IYWR4clYyc21xY2RvY3JaNUVEVGR6dmJ4RmlyVHprSHBsWDJlMU42N2Vv?=
 =?utf-8?B?OG50QTA0ZnJORGlmL3o3L3pFZjlIQVdsaWFvUkNiMEpEM0tSU1YvU0xOanhz?=
 =?utf-8?B?dEwxTDRPUzNUb0pObU91NjYrSTdpbWJMVnBBRFRVZTlHMWVyMjdLdVpVaHN2?=
 =?utf-8?B?b3RoSmQ1V1REYitNclRjWmlyeGRiWVdNY0Y0aVQ3M3RvSUdHWVVVTWJsNWl6?=
 =?utf-8?B?a0ZzTnlYdjVhRXJhckFoU1FpdHpjT2M3MjJxektZWW5TOUFwYzlQWFdONnpz?=
 =?utf-8?B?QXRmWlRHWW1FYjRLTVJXZWZWak9pVDc2eHEzQmlmQjExZEo2d3diMEp5STUw?=
 =?utf-8?B?RnB6VDNrZUk2NmRkbTN4WHRuK09SbGs1QVovdWlhdDNUUkE0M0FpUDVlWkhH?=
 =?utf-8?Q?gcx4XccAjgHoY1bkigANKqNFYPLVY8NV2giL99PDvU=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0119735c-0cc5-4cb2-db8c-08de1e15cfb0
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2025 15:53:36.2554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DK5p+Mz6O2ewRsdMTV1LgE9iVlvHAqW3V5kBv55+ywysmTowMFdtkzz1zwsHSZu8/EKUileKf4MJw8Fo0TeQEHXnXL0cSo7u9jbJWoKHabU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB11469
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4D5B3C0013
X-Stat-Signature: rw4w47mbnw5pqeso8d5q9zo14cwat7rk
X-Rspam-User: 
X-HE-Tag: 1762530819-338210
X-HE-Meta: U2FsdGVkX1++drSwiyasXG3KBV9bh/mQUfObKQbMmVrjz+NTI5kmDV0K0DdZa1830LfDLN+rK4JCqWxhxl2KM5MoqYlThvDd7QBYhmt8CcvofSH+E75nWcgvZKdcJAs7cRWW76Gn1vC8UWX0WnJQ6tlffZex53m9MvuXUsOTaYuyzw1Y93HREwssn0C0RgqfgirmHsISOzmPins45xdtR+x+dEPvnS1yKHq+MwaoEtDuyXRUFMK0YoP4Bbhi1yrsvaHm5/Ec/li+XxD7LOwhxM+4pRTZCLnwy2tB5Uw8G7HgUGe91IkyMbW4yaCegFGSkjouPoysU6dglBaGpv8l+NstwHxNzIOdXfPGcll5eq+rgQWK/uDT0UVcvhrgE+BDZO/GyytvKlepRgVnilu7+2j6JlYmTJrNKE08wapXgUKpvmdhBaK349GQ9O1r4owUokgp57zPPrMvtHtDj6FdDabuvxUH01lpxI+3dK2REdbPhWG4Ns+k+yZIXmquaYO2XFO7SqHtr03X4+XIAVqNUskbpwhFAQmR7r9JuwHjVJ39RVJeJkKsnIvO+L67yQk3eLQk1/+llvVa3qgkDaOMa9MOx7QeTTrv5iHw9XYXn6wimEAn7tdnmvMANjYmgr+4g+mJXfGAZRbV7I6mqocpCVjUJMSfI4cAKMUAZ324RxRuDqBEIVoQfY8Knj+xcq2Jkbv9uvxM/F0N5EvZGrnvkIEgQAPv3T+5UjNqEimegWr92K1nqnW5g5aDwx4DtdoyndW2z6NbAidwGuwtlwF4yZVZAYrM9D26hfSlaHSOTpy7b8bqY7aUZS+1TTlGQcNtf21Fw4K5uNSq+jrWiLINlPWwdqPk5Uf6oBwC5S4mJeGUWYb2E9mX3iS9ugDmhT/991MOynuvFbml/ZX6EcbEzMXA8Df8AC07DI2g007BQbwyXGAKaKmH4pHpfgbGBTe98B0ACfeX2i6S+SIoqOU
 jF2kGVwW
 lA0S0qhmFXP0svZwDhHhvNxSjieGRWloUxKeIlFqg+b//LP/phi0+2NWnp0nuWjpG0Jkmm9F792sino9bZUqfRpLwJmC6uFlYIOGbuMmrnKigx1C9FBPlijLR7tYqQJ+PeaoBDToRJXqAlFlXCEhBsOoSm3SVJbDOn3gfDCiooZbi9Cv/9lWE6ua5DSCvxupkI+6pl1xUON86Ino9xiV6M4Lvt2NhFAqjgXiCt8Mour/5X7W2Vkaqdrrg+KDqEndiTME6uw3NpWMVWYA0UCvDLH9xeHYpxdaeKgXebvuNHT8lcGUDZORIRPvGL0G08Gji94uzYRu1Rr8JFzKPZ4fW6aruTPOnKXT79/QN5c3buynn65wC6TYNI3gE1IS4c5v6+7nqfKjD9/UAzn4i8Tey0ftV8TN4AiKjfnvErv9eouNafIWXXPB153fDBJkCZ2Bfx6tfiCRsf94m26ZdFVbUC9sKgCq991nPTgc08YptBs6mo2k5fR/rcC+uoHqdTE9FixibSYQ77ceLdFXIvGNy+e985aGv4iCOPFkfCQaBo1RXFsWh67eNMFmsaJKR4/SUVdyW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-07 09:43, Mathieu Desnoyers wrote:
> On 2025-11-06 19:32, Shakeel Butt wrote:
> 
> [...]
> 
>>> [   14.858862][   T67] BUG: Bad rss-counter state mm:ffff8881000655c0 
>>> type:MM_ANONPAGES val:0 Comm:kworker/u9:0 Pid:67
>>> [   14.894890][   T69] BUG: Bad rss-counter state mm:ffff888100061cc0 
>>> type:MM_FILEPAGES val:0 Comm:kworker/u9:0 Pid:69
>>> [   14.896108][   T69] BUG: Bad rss-counter state mm:ffff888100061cc0 
>>> type:MM_ANONPAGES val:0 Comm:kworker/u9:0 Pid:69
>>
>> Hmm this shows that percpu_counter_tree_precise_sum() is returning 0 but
>> percpu_counter_tree_approximate_sum() is off more than
>> counter->inaccuracy. I have not dig deeper to find why but this needs to
>> be resolved before considering this series for upstream.
> 
> I notice that those BUG show up while loading modules at boot in kworker 
> context, e.g.:
> 
> [   14.858862][   T67] BUG: Bad rss-counter state mm:ffff8881000655c0 
> type:MM_ANONPAGES val:0 Comm:kworker/u9:0 Pid:67
> [   14.894890][   T69] BUG: Bad rss-counter state mm:ffff888100061cc0 
> type:MM_FILEPAGES val:0 Comm:kworker/u9:0 Pid:69
> [   14.896108][   T69] BUG: Bad rss-counter state mm:ffff888100061cc0 
> type:MM_ANONPAGES val:0 Comm:kworker/u9:0 Pid:69
> [   14.918858][   T71] module: module-autoload: duplicate request for 
> module crypto-aes
> [   14.919479][   T71] module: module-autoload: duplicate request for 
> module crypto-aes-all
> [   14.920801][    T1] krb5: Running aes128-cts-hmac-sha256-128 enc 
> plain<block
> [   14.921844][    T1] krb5: Running aes128-cts-hmac-sha256-128 enc 
> plain==block
> [   14.922852][    T1] krb5: Running aes128-cts-hmac-sha256-128 enc 
> plain>block
> [   14.923843][    T1] krb5: Running aes256-cts-hmac-sha384-192 enc no 
> plain
> [   14.939591][    T1] krb5: Running aes256-cts-hmac-sha384-192 enc 
> plain<block
> [   14.940614][    T1] krb5: Running aes256-cts-hmac-sha384-192 enc 
> plain==block
> [   14.941586][    T1] krb5: Running aes256-cts-hmac-sha384-192 enc 
> plain>block
> [   14.942547][    T1] krb5: Running camellia128-cts-cmac enc no plain
> [   15.018568][   T85] BUG: Bad rss-counter state mm:ffff888160f81340 
> type:MM_ANONPAGES val:0 Comm:kworker/u9:0 Pid:85b
> 
> I used "module_init" similarly to lib/percpu_counter.c, but I think it
> happens too late in the boot sequence:
> 
>    module_init(percpu_counter_startup);
> 
> module_init maps to __initcall within a built-in compile unit, which
> maps to device_initcall(), which happens quite late within the sequence
> called from do_initcalls(), called from do_basic_setup().
> 
> And even do_basic_setup is documented as:
> 
>   * Ok, the machine is now initialized. None of the devices
>   * have been touched yet, but the CPU subsystem is up and
>   * running, and memory and process management works.
> 
> which clearly requires that the mm subsystem is expected to
> be ready at that point.
> 
> It probably was not an issue for the non-hierarchical percpu
> counters because all it was initializing is handling of CPU hotplug,
> but the new hierarchical counters initialize the pre-calculated
> inaccuracy value which is used to figure out whether the approximate
> sum is sufficient to compare values or if the precise sum is needed.
> 
> I think this is why we are hitting this BUG.
> 
> Now I wonder where I should move this initialization. It requires
> "nr_cpu_ids" to be initialized, and pretty much need to be done
> before mms are created. I'm starting to suspect that the module init
> code can spawn kworkers that have a mm before the init process runs.

At least on x86, nr_cpu_ids appears to be set by set_nr_cpu_ids()
through early_param("possible_cpus", setup_possible_cpus), which is
AFAIU called from parse_early_param(), which happens very early in the
boot sequence.

It would make sense to call an explicit percpu counter tree init
function from start_kernel() between the call to mm_core_init() and the
call to maple_tree_init(). This way it would be initialized right after
mm, but given that the hierarchical counter tree is a lib that can be
used for other purposes than mm accounting, I think it makes sense
to call its init explicitly from start_kernel() rather than bury
it within mm_core_init().

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

