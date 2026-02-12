Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 638A1EE36B2
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 18:10:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C99956B0089; Thu, 12 Feb 2026 13:10:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5A1D6B008A; Thu, 12 Feb 2026 13:10:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B11506B008C; Thu, 12 Feb 2026 13:10:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9BC7E6B0089
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 13:10:17 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4ED681B3AB6
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 18:10:17 +0000 (UTC)
X-FDA: 84436594074.19.54124DE
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11022093.outbound.protection.outlook.com [52.101.43.93])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2B1F4180012
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 18:10:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=C+aXdZEl;
	spf=pass (imf06.hostedemail.com: domain of danielf@os.amperecomputing.com designates 52.101.43.93 as permitted sender) smtp.mailfrom=danielf@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770919814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZEkPyEZ2BoB5f2ZQ+/Ajm5N8omwcM+K28wpo9uW5HXc=;
	b=ulVDOzT85HTqslnfY30EwysomFC6PhBk8xUto46Uahd4Wg4dvKZVRZb+0KXXKhsJ6sn9k2
	1rUD5iywL/RWbqNi1jvSfcOYqQmmLD+akT4bYVsPV/CNfjWxAzc0okAB5p+fbf0BcrFWbW
	Bu/KXYzKkTlKLdVmDQrcaptjXKY4W+w=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=C+aXdZEl;
	spf=pass (imf06.hostedemail.com: domain of danielf@os.amperecomputing.com designates 52.101.43.93 as permitted sender) smtp.mailfrom=danielf@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770919814; a=rsa-sha256;
	cv=pass;
	b=yG0HrCxe4k+54dGAqHengOvyYXBaK6GjDv41UmW1q2/DgOBo+mRy4Ijyo6x1HdB7mz89i2
	Jl8k+3B+h+Y0sxbq7gFwRvtcz1lbx+ugjW6n4c9jbx1Hel9Kx7H/qp7NUfZZaoj2ngdt+w
	dn8mS+qnna1i1e/qGMDr8I1WRkZCRGw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BwSnpRrlZXa28F7BTeQ5WGA+uyYiCiOQT4RV4fXo4ni1lsiJIwuHoUALbE4RlmR5WDfDbrGfosj9aBb/9ijTc1BczRKl+qJhJzuUS2qBMExxTAkAro5JFkoO4JCdVa5GdUSvBn3SX0SLr44uloUyt49gWqKDlq1BRMjoPSDed4CrdU+l+GhIejHbLH+umDO4ZfrnlS6wIDmYh8hixzMYhC6j14Oy4CeaGgJfgIwrxEOpEiWJhGi/ohSqTPLFmrPwtQYaFLw8mUeM/LKMoXBEAzImzwJ1uONqD/4+1Tp1AIOmrRQOerG/eHrXfcEAxSdFS3s/KViX1kOglO440HvwDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZEkPyEZ2BoB5f2ZQ+/Ajm5N8omwcM+K28wpo9uW5HXc=;
 b=aE1vhdHA2iSgh/Nm+NavFAUqOGqsJ7UsLwa/RHPJOlo0T2Hh6jO3T+ctRW5bcWI/6fbRSxpGGlNzwygADMpwJKR39VkxC2iPTtzdnMpuM2qG5V1O1xGZs0ERiPqoP5lWXqiyE8YxSJJewfzpSNeo+tPQPKDHG8qvtAQbj/Ly0vMEwETcQjrtAu7aP9kEU6u9svhy8jOX7zYPUV9q6V6cz+gELLjpeP2t7Z8zMwYOnilupY5fAUjvKmyXTAhZBlXb4pfXlRdDHepDTYJHrxkWjjN0VnZmxxyutd5Ulbmij3+3sSYCHYasNowAQx3PiYfVCAzr3HWQMnHk9bhgKWwQjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZEkPyEZ2BoB5f2ZQ+/Ajm5N8omwcM+K28wpo9uW5HXc=;
 b=C+aXdZEltjBW3Ic+F+WMtBzVl4NmBrSOt6KCKuEx4VctnrZEYiiDxhsW11SIadFEQk3A/7L1Wo3URkXRvC01/ekedCMq2G5q52CFuj5soaitGpirjsO5+/qLKxrRzdI6twZSWi+VbV9PZjE/Ka0TxzY2WkJgGrcq209f5OhXdC4=
Received: from SA3PR01MB8473.prod.exchangelabs.com (2603:10b6:806:397::12) by
 IA3PR01MB8750.prod.exchangelabs.com (2603:10b6:208:532::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9611.11; Thu, 12 Feb 2026 18:10:06 +0000
Received: from SA3PR01MB8473.prod.exchangelabs.com
 ([fe80::4b21:87c0:adfb:1047]) by SA3PR01MB8473.prod.exchangelabs.com
 ([fe80::4b21:87c0:adfb:1047%6]) with mapi id 15.20.9611.008; Thu, 12 Feb 2026
 18:10:06 +0000
Message-ID: <df5fe0ed-3483-4ac5-8096-447e4e560816@os.amperecomputing.com>
Date: Thu, 12 Feb 2026 10:09:59 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 0/2] ACPI: Add support for ACPI RAS2 feature table
To: shiju.jose@huawei.com, rafael@kernel.org, bp@alien8.de,
 akpm@linux-foundation.org, rppt@kernel.org, dferguson@amperecomputing.com,
 linux-edac@vger.kernel.org, linux-acpi@vger.kernel.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, tony.luck@intel.com, lenb@kernel.org,
 leo.duran@amd.com, Yazen.Ghannam@amd.com, mchehab@kernel.org
Cc: jonathan.cameron@huawei.com, linuxarm@huawei.com, rientjes@google.com,
 jiaqiyan@google.com, Jon.Grimm@amd.com, dave.hansen@linux.intel.com,
 naoya.horiguchi@nec.com, james.morse@arm.com, jthoughton@google.com,
 somasundaram.a@hpe.com, erdemaktas@google.com, pgonda@google.com,
 duenwen@google.com, gthelen@google.com, wschwartz@amperecomputing.com,
 wbs@os.amperecomputing.com, nifan.cxl@gmail.com, tanxiaofei@huawei.com,
 prime.zeng@hisilicon.com, roberto.sassu@huawei.com,
 kangkang.shen@futurewei.com, wanghuiqiang@huawei.com,
 vanshikonda@os.amperecomputing.com
References: <20260123175512.2066-1-shiju.jose@huawei.com>
Content-Language: en-US
From: Daniel Ferguson <danielf@os.amperecomputing.com>
In-Reply-To: <20260123175512.2066-1-shiju.jose@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4P222CA0008.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::13) To SA3PR01MB8473.prod.exchangelabs.com
 (2603:10b6:806:397::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR01MB8473:EE_|IA3PR01MB8750:EE_
X-MS-Office365-Filtering-Correlation-Id: c8dbf4a3-9a4c-499b-9f25-08de6a61f2fb
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|52116014|376014|1800799024|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TGxjSWhyb01pcmppMWpXclM0M3pyK2tKK0tvTXJXYTlSUkc4cGE5bG5yTGh3?=
 =?utf-8?B?Qzd5UnJIY09HeHNqZ3BEUXcweGxWQVpJS1VicHlQTHFlTGZYYWFWTGxLMUtk?=
 =?utf-8?B?cU91ditvd3ZIQjArL2NPTEJjc3hJNzVYZitMUWlOQVF3NThGaTFYN04rbnpE?=
 =?utf-8?B?T1RyVnVqTG1QWkxXOFhmMjl3MDNLaC9VMDBxR1ZBbjFFSGhPZlY2bzVvQXRq?=
 =?utf-8?B?TnVuSGloRmpLV2NzVDlwN0lFL1RSa2tpRnBBQ3RlSGlrcEowNURjTi9uS3Fh?=
 =?utf-8?B?S0hGYXZWcWFBTGVScEpEWkx3RXR5emlQaVgzSitLbEx3TkJWdENXOTE0T1pW?=
 =?utf-8?B?ekxMN2VkN0h5OU9wMy91VFYveDFmNjNORjVGbzJrbDhVRXNMMk1mSG5OUHFC?=
 =?utf-8?B?dkZLSWZKUGZzRmx6REI2RWkyREpXMThvNm82YUVMKzZXWnBqUjgzdzg0Wnl4?=
 =?utf-8?B?SXQwTEM3NVM3TnJGWmhFbWNTQzJXZC9XMXRMYUZRVTBQVFNacU9USTZ5bEw0?=
 =?utf-8?B?YUZJVzN2bTc5T0hSelJ6ZXZreTZIdFREaDFvVW8yN1MvcXZ2NkhTdm5GamJG?=
 =?utf-8?B?a1JNUjhqQXN2dkhCSzZlQ0FGTXVJZVMxUzRuSEVJSStOMVpSQ2lYVWc4K0Vx?=
 =?utf-8?B?UkE3eWsxeEVBZFpYRnBzOWhpR1lwZERZVG91S3MwQ1N6aEtQbHcwdGV3U0k4?=
 =?utf-8?B?Q3RuR2U2M0c5c3BQS0VDTnBvS1QzYzg5OUFJSGRudnIyOVM5cDlDM2FicWJI?=
 =?utf-8?B?SnZzRHpmczFhNlh3ZlJOSi8xSmlhMm1KWjRWdkwzZE1RTVJoMkhmWDZkODdz?=
 =?utf-8?B?NTZFcEVzaGZxektHZUlIOG16Q2g2bnBNRUFnQVRWM2tBY0s4dUtIcG1VSENa?=
 =?utf-8?B?d0cwdTArZFF0VTVXNEU5bTNzTnZZUis4QUpVT3k5Wk11MTlsdDZZODdDalox?=
 =?utf-8?B?b05mdW9JalFOVEtwMU5Wb0R4ZW9VcUU4TUlTR0s3eVhxdEc4cWtwUEh0MnhT?=
 =?utf-8?B?c2pKVGpOTTV5Vjl1SkZLZHliRVo4V05LdEdURzdDNmdCT2pxRTd4a3ZUdE5H?=
 =?utf-8?B?cVBsb3dVMTVQaHFtMnhWM1h2Uzc5TzN4YnFMbC9zTU91T0JPemN0bDBNcFlC?=
 =?utf-8?B?RURxVGZhdGRjOUFFTXE3MERSdy9pRDQ1R2RsZllYTlc0TFlnY0IwSS9uRXcv?=
 =?utf-8?B?ZXZDMmRqcU5uVGVKRDdUb2dtcmpjQzJOcTdXeEUrQWdkOXlCWU5KbG1BR01F?=
 =?utf-8?B?MVVIeG5ISmZOdDkya0RWMUZaTGhpR2s3Y1RtUm1JVGFhZjd0blhhRDZkY1lH?=
 =?utf-8?B?MERBbkpCYm81dVhsYllYTGdHbEp1Z3k1UnIwRjQ0VVIwVDVoZW8vVVMrSXli?=
 =?utf-8?B?NHJBNzFqOVRrNDdPVEZ1ZFJJMjRhVTF4L2dEN2pqT0l5QVBuVmIzT0s1ZTVl?=
 =?utf-8?B?ejNaNzRyRmJOeUNlTG05VFp2b1h6enIxWHhvNE93eW5yRy9mckxXMEZZQlhG?=
 =?utf-8?B?L01STG85RzBHU0tCTnAzNTVzdEZQTDVDUkFGUTNQai9VRWU2UDFiMzdNb1RI?=
 =?utf-8?B?cVNtKzhOWnRCbXFZYWMyb2tudWc4Y1h4ZUxYT0hKK1F5QzBidk5CMitxQjY1?=
 =?utf-8?B?a0FaZnduV1BnSVhheXByaktVS3dkcHFPTXpyUjJzcFJaNVlEYjB4LzVCVDEv?=
 =?utf-8?B?cDZmMDBZRFh0Wm9tb0tWajBPbWcxeENXendaOFYrZVc2cDVlbGpicEw1N3pl?=
 =?utf-8?B?OVNYV3FVekJsVm5rcHlOSU9JMitVWktrazZhUXFYcFdGakJEMXh4YzFmREVY?=
 =?utf-8?B?VlN3aXE4dGtvanlvcFkrQktRQVhVeElReXRqQXBTOVFDNSt5UjdPY2RLMjVT?=
 =?utf-8?B?elZUWDlXWStRSzgwNXBRcy9RNzYyb1g0NFJTbkZ5a1AveC9NVWhPWnIrdDYx?=
 =?utf-8?B?SEVGeXdrVytaLzJUMmowNS81YWdGVWtDbjZXRFVGdGQ0L3cveFZ6MU5PWlh4?=
 =?utf-8?B?U2VzeVJJY0JGSHF6aDdpMDNmSjl6UDE2OFE4T2xlRUU5QzFBOFRwNUZIN2ZH?=
 =?utf-8?B?bzF5TUtWbEpodmtnNk1pMW0xMHkrWHhRWnk2c2RDcVh1OUdpam5YYUEzZ3B3?=
 =?utf-8?B?UXlBQzR6WmdwbGNKalBES2lSUEx3aVlpREdVME4zeXp5c1pCVXpBckpMelQz?=
 =?utf-8?Q?gFUDmYY3MmFkWoE7dg0zYMWD5Tj/hoZ1P529uRvS/Kya?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR01MB8473.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(52116014)(376014)(1800799024)(921020)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V0tuZUI3ZlFMQmpaTEwrZWNlMGFXUjZEVEJWajQvWFZIem15ZUZ3bzNkMk1l?=
 =?utf-8?B?SnpvUmRmMUlrVUU2OFJNbEl4aW1DdTFMejhndmhvTUM1YUZVRmhMSWtKNzJM?=
 =?utf-8?B?TnRxNFZzd1NxdFZXaENBVmRHN0h0R2s1RzlKb3dnYjZCZlVRNHVEYW5IR3Zy?=
 =?utf-8?B?MFMzSEUrVDR2dXhTY05ORjFqK2taeE14N3VKWFk3cGt3b3FVdTdhb3NmdkFC?=
 =?utf-8?B?aG1ROU5YNWtnTmlxUEU4QmZqUXk1MzdvbmRMbnVCenRpaE5hdEZRTnlFcUVj?=
 =?utf-8?B?d3Fxb2gwZmYyMm5ZbktBK3VFQVZqVzNOK05LUTN3SGpoTkExOEwxLzF2ZGd1?=
 =?utf-8?B?WVdqd3IrclprSnJJK3JHR0Mza2NZa2RicW55K09UNjUrWEZYV1hmdzNVaDlP?=
 =?utf-8?B?OERJOUdJOFYvb25pa091YmQyemtWUCt0a1o1VHYxeGs5U0dVQlRpMkxOTnJa?=
 =?utf-8?B?eVFmQ0liN2RFSS95MGVZTDRmSCs3eHgyOGI2TGhDU1M1cm1JaVN1a0xZVmY5?=
 =?utf-8?B?ejUybTJOakw5REtlcFJDVWYxM0lsb3dTYmNrZ0JtQ1U4Z3oyMU8ra1NTY2FG?=
 =?utf-8?B?UkQ4blB1TTBwb3BnVXhDTzZOY1RPZkdNbFFETnZGQUNrajdoRHdRT0hOVUVB?=
 =?utf-8?B?QkEzNGwyVG8zbkZKYjVtUkdQQVkxN1ZtTkVLUzM5YWZ3VEd2UUxUSFR6Vm5o?=
 =?utf-8?B?NDBLdEpsVmJ2K1N4aXd0MHpEQ1dTTUYyQ2xuTERWVWNHbCt5RFpMZzlaMHo3?=
 =?utf-8?B?SEVTRmxRSEo0M0M3Q3lnTGpYQkQ3eTBwRmJ5YUpidlc3aDVKSVJtcnVDTFhK?=
 =?utf-8?B?cFh5aGdlcHNhTDNFQ3BBbDR2eTJraHRaUlB5dGptYmVOalBiWnd0VXNRRE54?=
 =?utf-8?B?bWdNT0MyUGpYeHd5VEhkWEszdjV6NUNqQ3NRVzU0RWRBRFdMZmlKS3RFQUx0?=
 =?utf-8?B?YmJwRXd1N3g0Umo1VWNodU9aWGIyRFBIVnBDQ2txV25vQ2NSQnpOMnB6eThv?=
 =?utf-8?B?T3Z5RVlGNCtMcno5OFd1bnJQT0hzNG1RempOc0lYUjMxbERSYU9ocE8yc0kv?=
 =?utf-8?B?YUJScFpVbGRaZlJOSWtIRy9qUFpBaWUyWTNEbnEzZTY0akd3VEF1bU50SGZq?=
 =?utf-8?B?MW9PNG9CbUg4TEw0eVZVcHdKNmpUNHRaM3ZZQWh2d2pSeWMrUVB2OGhzZWRh?=
 =?utf-8?B?Wk5MbEdqMEc5TlNGWjluV2tQVTJ1ZjZ3RWRsUFY4djEvS2J2SEl4Ym1PMHpq?=
 =?utf-8?B?MzhDWWo2ZkRsdzFGSWxlNVliUUdpUlVwb3VLdUV5aTkyV0ZLRENHd2d5VkN0?=
 =?utf-8?B?VXdreUNSaHhHd1ZCRk5iRlNmQWJySHZoQzR0d2hkbE96WUxaTGVsRlJMbDdO?=
 =?utf-8?B?LzZrS3FlRTcyeHdSUjlkSHVUOHlicGJVS0dYaEtDRUJMczIzWHNaTG5LVXV3?=
 =?utf-8?B?QXRYU0lqaWRkSVVrUnovQmkrdTJhbDc2R2ZoVUFFd29URGJrYnlqd3ViZ2gx?=
 =?utf-8?B?RDYreDc1N2t3ejkvSUh1VEV6RGJMaHBJY0dmTFora2NIQURCemxib29WKzVl?=
 =?utf-8?B?czRadzVOazVwKzNZakhVdlZXOUt5MlBaYW1NWXJUL3VZejdrRTd2Tm51eFB5?=
 =?utf-8?B?SVZQU29TNG1YU3Z5TUJTZXltSWFVZDI1Z2hVKzAvN3lMd3A0UkJBMG14a3N4?=
 =?utf-8?B?RjFwNHhhait4RVlIeTdhSVMwb3NZUEJ3c1J0L1pwRTVzUDVGTytsNWdTczJr?=
 =?utf-8?B?ZVQ2SFhsYTEwNGJ1cTlwUXhDUTFpZnRKTlNGVDBlbExVbndCaFZUWWNHemVY?=
 =?utf-8?B?c2pBY01RZTBhblp2KzZibW1sUEVVOVBGMlE4UDhMVUszWGdvQ0xzVHdnWGNB?=
 =?utf-8?B?cC9lRTBhUGlJRWZHL0tRaHNhMUtXWjhROWxTSG40aGIrZXFqaVhlNnhNbE5m?=
 =?utf-8?B?Mm4zcUhZYXI1OGRreU4wcFRqNUFUcmF0UDdpVnJPQmovV1RhdjM0S1dhQ3ps?=
 =?utf-8?B?eU1SZ1I1Q0krSmVjaXNSZjZ0bXBIaVdmK2hGRG9GOUZXNjFKTjlKZk4rblhi?=
 =?utf-8?B?dllkRTF3ZDJtU24vSnVQKzNRVmNqVWd0UDVEaTIwdFZ1V0M3REtLNGt0bVhN?=
 =?utf-8?B?Nmo3Ri9TVmZsWTN2ZUFHamdlb25iT2EvQTgrWk9NSnZYM0ZMV2tGaVhsY1kx?=
 =?utf-8?B?TlhFWVBYZ1U0ZnpucHdFVnY1RGtRY1BxZFFSdlpobDlpMjlMdUZNMzJWa2VT?=
 =?utf-8?B?aFNWV2cyWHVLanNxRzNGVmw2YnFSSmo0S1VWQzlJVEYzNkxQM1VuUGFJNDRu?=
 =?utf-8?B?VHA0T3VMOXM0aFJaQnNtK1Y0dzY4SlNzL0RYbkl0WUF4TlcxWDI2KzNveUNt?=
 =?utf-8?Q?X0v+C9D4yMLWNyORLG20Bd0K+MbGIdqLVD7s5?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8dbf4a3-9a4c-499b-9f25-08de6a61f2fb
X-MS-Exchange-CrossTenant-AuthSource: SA3PR01MB8473.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2026 18:10:05.8660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5H6gTYDjbNVjQDE22zXzsvE7lS1zvOZOSMynxEXAbrpT1jZLPayn3piFzApejItfSznzc9LytZZFdRimMVUpDCXUkiRRIwvzyIzDtHKqQWBNDRWxlkV0z0+FLn8bZWjN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR01MB8750
X-Stat-Signature: fw1z1agbwi37gwrhubx3yypk65sz397y
X-Rspamd-Queue-Id: 2B1F4180012
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770919813-454557
X-HE-Meta: U2FsdGVkX1+Nm7KoFECDgik1ZENvnjAo17G6FB2fFQR6lVrjsrL+t7B3Z55DBxVgh6/xaG6u6FBefSLUITBQ7RDXQ+R1sVyv5B9nO/KRR2toQMEnFWaqAAw3kTnY7IHpxh92rtLiHoXNMk+C2UWgZmLT1UWte01bjryPTMkod/LLZ2cNF6AVxIoFH2ghw5MB7g9hECHYUcpTz0GZZYwOa1wp37BfRIiLgdOIFvzlezFfKGsqI3ydPEGjqG46ENgtiV4jjHSWU7cCf3o4VFjone3145h2s7MbnHLsjSBaJZtFmexPFSTPVJAJvw20MGKpb1YuJo2bdm1bCq46bAma1pJfGvxI1KlSxRvuCyg2Iy8jSGbnqCAv9l593RAiUOjSVncFGiZ91aASo9jlOt9+Q2g8P4ODRJ/wbRZtZ4QPHnl3+uJdJk4EgxBxO0tv2X1990LWFY+XpFKMBDZgmFjkeHuuacwJjf0qCBRTUpbAvFDR2oNvmoYs4R+dj6NR/deryC7YIKsri/Y9JIYwCP6JgZZq2W9O9Ez4WB+1PsneqhW22wf1v8p7sBitaDAkWku06jnQ+HQDB26bGm75bwDuoUNcQVdaPUy9gx9fSyoNHNGUCzFHSzj48kGBKMPT2n3osoWRz9EhOrU/bZMmgAEMQGIQXEB1fZYtHuMrHQmc/A8XlNgbGZAnSclt/N0bk/Wz7AiTETLSsuLRrs0yx2WnnEXUkkwRF6mFTQYvLK0i3ieoeJDCc6U8lvROGKuGNxwnoOO2o7igtR0q4rGzJUx09S7hrYk6FFszVzBV/fILFul642An0bfpnJL3ficuD4tH4jhvjJYTrhyZBPnUE77kpTRMXSYEiBY4nyo3RJIJws1BFQD+Ce/BRDNN6rJH/8zZt1N62OCoHgb6i7nUF9i+9Bqk7DpLzvLvdoGdOumEtxbcMbcG0QEuM+6T0vVbYEfA9oZ+IOoc1XyvatQ39/R
 GSxbmNBi
 HS4PjqR2Yft8d18ugyQrcPVunXGx3qpOLdMiAh9OKivdhnnszQfjxgfL4jGF+cf5OJIOfTptJCx38NT0RsnD12csAYljRtlW30jN03VPActFS8xDDWv0pPwCY+IDpcyLA+SY7G9COQML8NlOStNtEF+UgEVgx4MudAxwYqJ2+Kson+EZsiE2MQ+RIonEp2WeBhJo8n5vNxlB710DLkTuDwY7g454515jcgpebkDXC8LyWeSG6rU0fRMISdaXkHKlo27ahsAMczOjEyhEhxPEH6jmUtPYLEG0YBS8/zTMVhD6UFoIyasRJLQLSNyEkw7ucMOJvex9KcGCniDKSwX8iAs1pBpu+rs6mbxCEJK/P3INSxuej7OUNAsOkWucJ2uTbiOTfIyPVR0lOu9Wv7htdz3D8egGUUSuBQjAWLC8lhL53Fw0D10107kUGI3gd9VLZWAlPhxXaXJcnhe4K7jTh4NgxawSrZ3WSTpluu1ZSQCPykxKanJFcdweyJEGegozNPKi4Ei6KgG6fFnP+/aeV/Nya5pHLocmbNbAm/yvKXfJj2EWk0cmXxN0yze5hEyhwL3/aKXc7S0I0RXjCf9QptlHm+JXjfR4N689AI4mSNCliyoT7BGvAR2NAlcJicIkilSC1bACtutCEKNYhl4mDn1Xl8dfb4fSfvsJ4BDu1262cTOYTRhmF1L2muXA8cfawKBvl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> v12 -> v13:
> 1. Fixed some bugs reported and changes wanted by Borislav.
>    https://lore.kernel.org/all/20250910192707.GAaMHRCxWx37XitN3t@fat_crate.local/ 
> 
> 2. Tried modifying the patch header as commented by Borislav.
> 
> 3. Fixed a bug reported by Yazen.
>    https://lore.kernel.org/all/20250909162434.GB11602@yaz-khff2.amd.com/
> 
> 4. Changed setting 'Requested Address Range' for GET_PATROL_PARAMETERS
>    command to meet the requirements from Daniel for Ampere Computing
>    platform. 
>    https://lore.kernel.org/all/7a211c5c-174c-438b-9a98-fd47b057ea4a@os.amperecomputing.com/
> 
> 5. In RAS2 driver, removed support for scrub control attributes 'addr' and
>    'size' for the time being with the expectation that a firmware will do
>    the full node demand scrubbing and may enable these attributes in the
>    future.
>    
> 6. Add 'enable_demand' attribute to the EDAC scrub interface to start/stop
>    the demand scrub, which is used for the RAS2 demand scrub control.
> 

I have tested v16 of the driver, and it works as intended.


However, we have some concerns with the limitation that memory scrubbing can
only be invoked at the NUMA node level without specifying the address range. On
a server system with high core count and multi-terabyte DDR capacity, there are
several workloads that are limited by the total DRAM memory bandwidth available
on the system. Triggering an on-demand scrub while one of these workloads is
running on the system results in a measurable drop in workload performance if
the scrub rate is configured to be high. Triggering an on-demand scrub with low
scrub rate would be a very high latency operation due to the large amount of
memory that needs to be scrubbed.

Triggering a scrub on a NUMA node with large capacity, like multiple terabytes,
could have:

* high latency to completion of the on-demand scrub operation if configured for
low scrub rate

* high performance impact to applications that require memory bandwidth if
on-demand scrub operation is configured for high scrub rate

Additionally, there are multiple use cases we have in mind on data center
systems for being able to specify the address range to scrub from the OS. These
scenarios are primarily related to understanding the health of memory modules by
triggering on-demand memory scrub operations to single page regions.



Scenario 1:

A memory device on the server encounters CE errors; due to some failed DRAM
cells.  Over time enough errors are reported to a user-mode RAS error service,
like RASDaemon, that trigger a policy to inspect the “health” of the memory
associated with that page address. The policy triggers the inspection using an
on-demand scrub of the page to see how many errors are reported. It then
triggers the same scrub to see if the same errors are reported again. This
inspection would indicate to the RASDaemon that there is a failed DRAM cell in
this range. The policy manager decides to offline the page till the module can
be replaced when the system is serviced.

Scenario 2:

The OS has offlined a collection of pages due to UE(s) being reported on this
region due to a transient environmental issue; any reference to these pages is
poisoned by the hardware. Newer ARM ISA extensions have provisions for removal
of poison from a page. The RAS policy manager can test these pages for
functionality by triggering an on-demand memory scrub, potentially multiple
times, before adding them back into the normal memory pool.

While triggering a NUMA node level scrub would allow us to support these use
cases, the cost of doing so multiple times with a high scrub rate would be
prohibitive. At the same time, an on-demand scrub with low scrub rate may not be
fast enough to allow the policy manager to make a timely decision about the
health of the memory module.



Being able to specify the address range would allow us to contain the issue to a
smaller part of the memory with minimal impact to other users on the system.

So basically, if we can't specify the address range with on-demand scrubbing, we
might as well just use the background scrubber.

Side note about our platform: We do not allow the user to turn off both
background scrubber and on-demand scrubber. We automatically turn background
scrubber on when on-demand finishes. So, if on-demand is not running, then
background is.
That bypasses a lot of code state in the driver around whether or not background
scrubber is currently running, because you cannot turn our background scrubber
on through the driver interfaces.

Regards,
~Daniel


