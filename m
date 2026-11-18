Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 562C5606A330
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 20:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=selector1 header.b=BUflXr28
Received: by kanga.kvack.org (Postfix)
	id 70CD16B05B7; Wed, 18 Nov 2026 15:40:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E3F66B05B8; Wed, 18 Nov 2026 15:40:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D2BA6B05B9; Wed, 18 Nov 2026 15:40:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2D38A6B05B7
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:40:23 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B3E1812089A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 20:40:22 +0000 (UTC)
X-FDA: 85449407484.20.7EFD8A1
Received: from YT6PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11022120.outbound.protection.outlook.com [40.107.193.120])
	by imf21.hostedemail.com (Postfix) with ESMTP id DBD4B1C0005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 20:40:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=BUflXr28;
	spf=pass (imf21.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.193.120 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795034420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d8rquWTazZ5G8aGa44Uo1MnSmHARaJ15nMAitm9qRQU=;
	b=KvrnS4kQPqEMr5FaGCNw4KIDwpv68iiYHYbgDgpq4q+rP8qLtwViGuL/K9xzqUJpz3F5VD
	hB7J16Uq9cqqL0HCLR00zhCnUHftJicxpuE6/4sOqGFPKgktnia0WTcOGCaJnayQKBSxZT
	fq1VvcRxfqWyR8dRCcfyJKUhKk+sttw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795034420;
	b=uU5iY3HYbJBr1LUkpuz6nXaE2uEqLGjixPkEXRausx4T2zK+0GGLZx/4k+sXCFC9blXBgD
	+FoAdrnqMSa3vhzmrO/VC9HfHAEf8i2E5PaRQNVJJX6qcfI6yflkCDfbhG3yRiMExp+Wcz
	HWMxxAZDDLlihStZ3dx5M9EWp8eqVMM=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=BUflXr28;
	spf=pass (imf21.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.193.120 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oKdWDC4AEBk2Hcf/+7yXG8kZ+O8lQe87nnHRZUzrqqs8aKgxlc47T6G3UxAk/u7yVjAHLmut17VwKgNMjEf8H7wK+x0VPY7Hu8RYoZg9zR9t7ll2C19MVi1rKdKLD39ffmMwM2zUvKD5eMnOPjTgb2oa/xH8//eAvS0c0gkF46bsd+Z2VHHWxyY4p+xydW6/umy1rr5vplE6oWi0/I0IjBMKb+OQlooTgFPxE0KeFjdivMAGm5ZGuxxlu5nDd6UiprfYrB1EslAjyFknftIpdf60CmAy2fSWI5lMNcmZ2dqz0aKPVOh/27pNepu23UnM/EVhC9asjKS+SyFoauSIJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d8rquWTazZ5G8aGa44Uo1MnSmHARaJ15nMAitm9qRQU=;
 b=mwSdsyfnZmUyOYRKkas9xHfL7p9Rs3o+Y4S/26CKfsAkG6Zji6TDTyPZfpCERb767m5R0Tu8x67ZEafm92JlmRmxXZcDTm66qxrG4AM3BbWcqg+oHJhlaok/MVe/qM1RXydY2PohqwU0mYTVO33VzUlCflmJ2GP52YZmdTL/CpC8VXMgkfohHQWwKr/BjOWu7fUjL17L6GYyU/Z/Yr0YTknh1V78x6zg/xT/9of7d9p56C5LOIqjCDTsAi3lmamlBlCuR6j/SqAs9uhkCGq8JZKRL37pNr7A3Ikc1/xFkG08FlvZGiMBftcNncXJPTAv0LAExMhAIsPBdJryTfLUjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d8rquWTazZ5G8aGa44Uo1MnSmHARaJ15nMAitm9qRQU=;
 b=BUflXr28xaoI3uHNG0lO4VDJWrUIhZZs4weFVsBrxUad1/uBnR3WM51vwGP2GGKPIjgBa+hk/b3YTDiuVwvwK7VMQbVKj9pjHcuif1VoWKpkZq28+6BPxOeN10lM5ZJTHhd8CwJiE6SBCTAGKXaeXPaODAKBRyjHRwIqQG/XTJcrchqQE/6Vb93iEG01201a7SFsmObBjcDgUMdYyPe1vvh54lYAEQJqU5cWhoI6LuKV84kY4RSwIYvfC+QZR5MYDYKMw7lzpZZIe6qp0cMDyOJBWZxpMou9nqASnljeDjwH29FfXNYgGJJ5Cjdau3QNvjL7uHhrfL91g1xeWH0oXw==
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10) by YT2PR01MB6029.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:59::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 20:40:18 +0000
Received: from YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc]) by YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6b9e:a901:67c5:7ddc%6]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 20:40:18 +0000
Message-ID: <049bdfaa-2e0a-4536-9552-a6d609f1e3a9@efficios.com>
Date: Wed, 18 Nov 2026 15:40:17 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 16/17] selftests/rseq: Test affinity changes while a task
 replaces or drops its mm
To: sashiko-reviews@lists.linux.dev, tglx@kernel.org, peterz@infradead.org
Cc: mingo@redhat.com, juri.lelli@redhat.com, vincent.guittot@linaro.org,
 dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
 mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com,
 paulmck@kernel.org, boqun@kernel.org, shuah@kernel.org, kees@kernel.org,
 viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, oleg@redhat.com,
 bestswngs@gmail.com, xmei5@asu.edu, xujiakai24@mails.ucas.ac.cn,
 linux-mm@kvack.org
References: <cover.1794932121.git.mathieu.desnoyers@efficios.com>
 <ccc2a6c50429b1ad9c8d5cc45ec8e58c12df7fde.1794932121.git.mathieu.desnoyers@efficios.com>
 <sashiko-outbox-221459@kernel.org>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <sashiko-outbox-221459@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQ1P288CA0021.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9e::27) To YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d0::10)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT6PR01MB491026:EE_|YT2PR01MB6029:EE_
X-MS-Office365-Filtering-Correlation-Id: 8207e728-fac5-4185-de7f-08df45b42870
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|6133799003|22082099003|18002099003|261009223027099003|56012099006|4143699003|261026121527099003|261102123227099003|10067099003|261028144727099003|261026140227099003|261021121427099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	2e/XpcRoqa618ESVIc2RbVKcE2VzMU/Nx+S0tHd2+u4NVn6lRra+Y6Db8IdVzBacfwKEFp5vcjRg/sddyU8lD8mhVlup2ImTEGhTH2wh6S1LX/iSLJ1G/O/Upt7sGlvRj2Q85W9hlPqVkhY4/YixKOHZ/7A1H71yTMgIv1iGBNqZNP1imhxkFTmSyBiOmS4skylb0MtFzU3IEjtCi8w66VmUCmOpaM8fXYjM5uA5rD3TT6MM7LAVzpNUqGO0zCokmKve0Xs/P6u2cMjIL8TXw7nCG5lTWk6YqVlUd9cEVD+qP+aRuo4mh/fkl6K6JLa5c5a1q40FnKm/OuxYMzUUTJQ1nLuwEvBc2PTYvhP6GQC7J44KTDrb+0BTL66OxAXOsN2Ut0th6B4iVWlLXBe9wh1RcwWSzrj+fP8+roD0o/fxNY0cCDBjOS4w7QdQS7MyMC04Vz+G3gdnhwC5RvwLyz8EbSaqx2KfVj3kBIXdCsfFmrjmxZ9QZfyprS0Rkqd3u9FfEcsLXJl/b8DM10r0qcmAly5Ft61P++FJQKdjnPWsDCb5N6HdVjDpr/wnBURrtORrKlCCAzR6dpHR2yx3jzhr0GrU/TCgJwo3l3Wuleo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(6133799003)(22082099003)(18002099003)(261009223027099003)(56012099006)(4143699003)(261026121527099003)(261102123227099003)(10067099003)(261028144727099003)(261026140227099003)(261021121427099003)(261022105027099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MmhuZ1cwSFU0Njh0Y202YVhQSkYzSENLaWJTQWRwMDVIRHJERkw4RUs0cUhz?=
 =?utf-8?B?ZG9MTmxjVFIyQkdndkhpT2o0dFlzeC9RaTIvaUhyeUpPb2FNSUlMWFZPWW5R?=
 =?utf-8?B?TGFHZWVsSWJCbEhGRVpDRTArZmpiRGYvVHdoZTFrdlIySlczcUhlbkpzQlhj?=
 =?utf-8?B?WXI4d3VGak9pdVgwZnNWRXIwSGcyeCswUEF2MndqWTB5Y3RIcGhJVU5DbExo?=
 =?utf-8?B?OGdBVGgyellnQkQ2em1PLzdiQ29VMjhsWno3WHhGY1R2WW40MXUwcHRGYm52?=
 =?utf-8?B?eXhKdnNGcFcrNFo4eGN1SFN1MUZjV0NmREhZdk14NXJldkdyMVl3LzRRTmtS?=
 =?utf-8?B?aTBqV2tQUkFXUTU0Y0pJVDdYNFJ6emVWajREcGZtZlF1VlNDajhERWE4S09w?=
 =?utf-8?B?M3JaaUNDb05zQ3B5aktlVTFpdUlDaHZwK3ZmVkJyTHI3WWF5YnFJRVNZS1BR?=
 =?utf-8?B?MTZqeGNrNjBzS1U5cWRKN0c1cHVPekVIcGs5VmhqWDFnUHJBWGdIR0dyM2Nv?=
 =?utf-8?B?ZXMwOGRiNEI1ZHJmbWg1QjkySXdGY3BvZm5mNGNBcmJlNzJGQTMwTVNFS1Nm?=
 =?utf-8?B?MzEzL3hzOFIwODRLZGt1NTVURlg5ampTOEtNRmg4akxRanBzV0MyQnQ3cFkz?=
 =?utf-8?B?eERMNHYrZ2hIMHBFK2pPUGNVaVhuWGlFWkl4dUNSTU5uOXhkSU50TzN6WGV3?=
 =?utf-8?B?MXEra1B3K0ZVZDRIbnIrbkRRUFhQTlVhazhVdkZqL2ZXZkZvOVhKQ3B0YkV1?=
 =?utf-8?B?RUs2SzFnL0hxYk40SmFtakVjNFBCL0QycXZ5TWt3YkdSeW14bHdtby96VDRY?=
 =?utf-8?B?MUhhaEdqbUt1QmtrTmVmajFwSGpNVWNSTmZXTmRidGc5U0I5YlBPYWlpUVlL?=
 =?utf-8?B?OElobWc5ZkRaYnNBYXlXQlBGcTY2WUZRbnhNcnhjY0JieUdweXZRbVJwTngy?=
 =?utf-8?B?VjZmdzBlaEU2STR6RHFITE8xKzdoVXM5ZWw2dlYrTEg2N1l6MktlV3lGYW5q?=
 =?utf-8?B?aURkcmRtbm9JVXNxSklyc2U3T0o2VGd4OUJ6VEc5SHA4eldHLzVFYzExVkkz?=
 =?utf-8?B?QVN3aUNMLy80VW5GT1hZWHVLKzBPK3Y0QmdVRGZoYnpaUzRCNnpERkcvUlZW?=
 =?utf-8?B?czgzYkR5Vng1ZmNSUThVM0NkV1d1R3ZuVVV1c2I2RHdxMzIxM3Rtc2NjcTYz?=
 =?utf-8?B?YmZmdFhWenVzMit6a3pZWEdDa0JTb2pheWU1dU9VL2I0Um8rZDRRWlhoNmZs?=
 =?utf-8?B?WldaVjdXNDY2NjlOVkF5U3kvZENob25YdHNVZlRiYmxhdFNIR0dxd01NdndI?=
 =?utf-8?B?eGRxeHVZM0IrMUE4b0pTODhLQVpSNHBZZXhSUFNud3NTQzBvRVg5alRJbjlD?=
 =?utf-8?B?d1Q2S0pHTHAzRy9xVDN5TWxrNmhhbDgvYjJhOFJ6ejVyQmpuNHJzWFBGRXRD?=
 =?utf-8?B?WEtSUXJucUFPZ0tSQ21YYlNFNzA1YVhva1NEalNqVVlNVGVaYXhtQURIOWx4?=
 =?utf-8?B?eXdSVkZEY2RBSmJXR2JEU0IvQ25DY3ZuQVdjTUhLdzRWZjBFMWtYRDFla3Fh?=
 =?utf-8?B?VHJYYjZ5N1lVSUtlVUtQdDlsQ2tHZzFZRmZnZnVzTWNYeFMreDNFZGxEbURh?=
 =?utf-8?B?OFdMQWIxMkdxNEVkRC9iNU9vYTM3YUxhQ2F6K0pnVGJGZmVNVVlnQy9JK2U5?=
 =?utf-8?B?Vjh5V00razQvY2xleWZSa2JVaFhCNjQ2c0ZxZ0kxTWRXUmVaeGs3Q0g2ZmFM?=
 =?utf-8?B?MTVBUHVnN2pJdm9ReUxZczFlNUp2UWZUUVA5RlFBU1ZiNkpQdCsycE91ejI2?=
 =?utf-8?B?RXRiY1NXR3g4Uzh1Z3c1bXdYb0JiUUVTWFl3Sk9SZ1dxU092dWxZbWZjeTQz?=
 =?utf-8?B?TGZ5WjZxb0RhYWVOTDgwdnBrV2Q3RG52ODhsdDJ1VFZUTGxzY0IwMTl1SEUx?=
 =?utf-8?B?QUx0MHU5NHdPVnlMTU5YTUI0OFAwdi9ETWdRUkhiUWQzZFJycXI4ZFpnMHVK?=
 =?utf-8?B?eWcxLytOTXZUNXYrbS9qZHlnanJvWkN2MklyQWZma1JGUUtzZEllc29hbVJ5?=
 =?utf-8?B?Y0hOWjhzbmw1Z2RiUEFJY1RTaFBlOStYdnRnSy9IUXZwMDlZMkh5emlGcHpn?=
 =?utf-8?B?eFIwbzNzQTI1U2c1YVJwOE9IM2k5LzdQRDM3ZG9MOG1LNUNzNnFsUm5yUzFE?=
 =?utf-8?B?WXN3M1N3N1lVRllOYWU0amF2QWRyR3NyeUFvU0tZL3VHdzlzclNpdnloV1Nn?=
 =?utf-8?B?MnFRUGdBaytIRnh6U2VlWlgyT1RSL0krYzBLK2NRNDdrZktHeU5ZdEJpYlBl?=
 =?utf-8?B?eEdpOXk4bCtyRDE2MGZlODdmZFQyREJ3aFdqc2MzcU16Mk1zOFgvVEpJUHRK?=
 =?utf-8?Q?ZY54BDv6KwWKdbKL6+l5M8FllYYgo50nr8Dv7?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8207e728-fac5-4185-de7f-08df45b42870
X-MS-Exchange-CrossTenant-AuthSource: YT6PR01MB491026.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 20:40:18.5646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: npHnAiuLajxrSSnyfIkrruZTJv9X+P5hPbpUlPz2im/JheACzP/ADGDAKGWgbB94IF2UFFx1gi+4ClpaBnUBk8HAmSbh3uTQE3r3XHsrlmA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB6029
X-Stat-Signature: efgh4khzwg5r1xu3n1xzczfr3fbung5i
X-Rspam-User: 
X-Rspamd-Queue-Id: DBD4B1C0005
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1795034419-641846
X-HE-Meta: U2FsdGVkX19oaKbwaeFfS6GCfmYwR3uxAfCbO+cx1T8eKRliYvWU1xQmcqcfoA9xVvbdz0KyHDJ61QtEUVUSmML9G9RnL2qRD+k0GtmU1Lg69EHXQ72WUnmmeYFJRqYIRVQsVJod3iQLVnT/ZtxkW3S1wVbVHBNHJM6VdiiJOicmEopH20tG90/3Kn5/yiCDlGdM/6QLniDMYjtjkK4cPJnNOLQyx+4rmG2bjMfXv5mlJQktuch/6CO3tvvTFkaVUBIfibl2j3zFHpsIQz7P9ZhML/UQNBSNzu8v2M8Tk80Q+EGWiSbQ/AbjPxheZ+btedWUDBovzRq/5xcC/TqLC/uw8ng3ChZB0PItZmHRTObX9ON/nx+jheMp5CJv4WsBYkJnRcdPcBabmFoD8bpsyBiLBhjvvO6E9hR/ajNdCyZsGelsr75z2iia/rCJJHuoVioX+iHou9EVcamNgkBCPIKwSDVvvcYiVhyEdOCNTfqWpHZqSSfsx+/M2+NthQTqRUizqD6kMTvg+rVp9ZsHkIPQTrdPjSegN8LdKUG9tj/rtGsXiOS0lrb/q50vLoRYgHTqDIMxutyLNMU81Ru91D3oP29PXrem12bCVrNcyAP9EmQoUQBA7gyaynDIuh2+SgpNx/aLgVMblGffc4Bs4mjL9k/nJa00i9ZHEh1bN1iYmIHmk28UK6ap4gsFltb3DivDktziXtTsWg51MbXgdtJ97AP8xRm1M6mEL5BKSyCUn5Umbw0XPHc+EwhLrxNnj24386C8QQqfpATUUfSw2frUGgR56vBS0AWJDCh3e9iWPicGPtSH7l2RZSzZ9oMBGPLH0Vrt7dS7xnaWhumkratinNfeOTzbdKfFJNR8PN+aE2wUtcBAnojen21EUNjLP2u76MRZsrccS3jzGw7X69nTf8iQJZqZH2P2Hq1gmRQUr+6aa8ZsYvfdAhZRdY3HmWkhkr4YHqQ6mQhAxD8
 OHOrNjCG
 svxN2douU80V5vdtiS5sqPKw59pWR0oYENgAY8/8OSmHIby4RMNRbxobGcUd2ceDpSay8I6T+B58XQLHRTf8B9BdSyfsLs2rY0KNQzD1IhUxZjwSBvv3HPNPTMkNSDUeiCJZbGQ9b06vIgvt2vKG5S15Eb/fvEoIns90RyQ9MTrjaRch0NUjMdJ0tQR9vzp2Qd3IvlxpICL8VBGL1VQOIqtVJeS9bSxXlx1ZUpnjNsc0JfhVhleOXOKiMcsIVdVkeKNApMuOqZUdMdeXDPDN+laj815ACzJTP4XE/Hc506O7rteJjNpDXCgJZKGpMdm+b5pbujsqV0m6y8q5v5vYpJTsvKXEqGNqZSvudF8Jp1w7dGzGtFDrH5eTgqXCTtLWxJUXYlyAYvnGU1T/vic/3e5jybrkMbblxe0fabmf2ThDcupTg6EPdH1w+owG7XxUaAbsWIdaDx+7DhoNs3dzkhVN1EVXTs+e+aMexJnYjdK38ibGk6FvW6gUpqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> Should mm_cid_teardown_test also be added to 
> tools/testing/selftests/rseq/.gitignore like the other binaries in
> TEST_GEN_PROGS so in-tree builds do not leave an untracked binary behind?

Yes. The next version adds it.

> Does incrementing i before checking target cause the first
> sched_setaffinity() call on a newly forked child in run_exit_case() to be
> a no-op half the time?

Yes. A child inherits the pin to CPU a, which is mask one. A change to
that mask returns early, reaches no mm, and still counts as a change. A
child that exits soon can then get no real change at all. The next
version restarts the alternation on each new target, with mask two
first, and makes i unsigned.

> Can victim reach its end timestamp before the parent reaches waitpid() if
> wait_first_exec() and forking/reaping the setters take at least one
> second?

Yes. Its end is set before wait_first_exec(), which can wait up to 5s.
The next version adds that wait to its end. The case kills it with
SIGKILL anyway.

> Does leaving execs unreset after wait_first_exec() make the execs check in
> ksft_test_result() always true?

Yes. The next version counts the first execve(2) apart, so the check
needs execve(2) calls after it. In 8 VMs, the case saw 594 to 758 of
them.

All four were found by reading. The tests passed before and after the
changes.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

