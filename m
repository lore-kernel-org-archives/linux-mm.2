Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E148CC982FD
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 02:20:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA7B96B00A6; Mon, 21 Sep 2026 22:20:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E31A96B00A7; Mon, 21 Sep 2026 22:20:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFC136B00AB; Mon, 21 Sep 2026 22:20:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A27FB6B00A6
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 22:20:45 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3E0B7A0362
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 02:20:45 +0000 (UTC)
X-FDA: 85239794850.15.C1600EB
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010070.outbound.protection.outlook.com [52.101.193.70])
	by imf29.hostedemail.com (Postfix) with ESMTP id 56C44120006
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 02:20:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nkiJ8AHs;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.70 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790043642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yy5uJGqPs1g6+iUEWH7opy1xuyDFDoxM2krbqjQB1yU=;
	b=qC2JqawO+7XUK1xdie4QQq7R6c9wcTEU7O2IIpI3FVN/8iRwoagdtmWXbDevkCbcVssTc7
	YdET0amvlFAt/US5KDaKqjqihZlD6rmP6u/e1zKq3YG3FL2qS/u4eO4dP+MIofsINvbmHP
	Lm6MRyMNCFiPoausz8i5pSkdpk9KC3k=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nkiJ8AHs;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.70 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790043642;
	b=gflSelRK9FPZp9DqhuBFhDjH4hKsuo5m4EEf8UJSP0aEjTF3gSLx5R1pwtxUGhYFG95Rnl
	1MxXi2pxIfKfjCIw2Ag+vdTo62ayO9xePYgGZ9sEL0kUR5VfF/eMg8FASEnI497/QK1XNs
	aoGIv02330K1wlv5r8OPes44YN53uXY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wHnNgsmKb3zFbvfTdpPHteaS9y5/f9DJf2WMMSyW3I6nr4SE2ptLFFb24rErGcmx2QGjsHZ5MSo5l3eDBFiLOi9zAKcqjv5zZiZ6VIJ0TtTv/0anlUPCkgBDTkFzTn3D1jTFpaesl28hOlp2M3Qcis6MLFvHhUU/G2JRixvOVD9ZD2UYXjOTqy1WdOWRDpxqAFhYvm+NrmtCOydz+0qsKb1s33MlO/7dHTPwDaX7n/e1Z3YkIVnJ1iOf6jfGCCA3gTKmll/XQOYc0ALYH+1VMobquSzdYb1OAYALzADJ4HE2qhHZN0xglRIs3FjLUgJ4jiIaNX63jCOuhbLaFb7j1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yy5uJGqPs1g6+iUEWH7opy1xuyDFDoxM2krbqjQB1yU=;
 b=M+onhfgB7VUhVsRC8VmH+/3AHUlAT3FIGiD7z9i3JCEpJRArVP9/gzzAKvih0Fe4Gc8EBrHtE/dPoFPksMME8Eqjv6OGFz3rGL2UIi6EMNz2wHvGylMw5/J1uvz1pJOUFykJxPXGo3hjavzARhX8NWy0WfdjZD8POyxZ6DYEoZwOLELsabmJy7YGJifJuMC91bRUwM9AzVKZmOhQmVAtN+J1Ayrroji3jKTyowX5Zczk+IfwJ6XKLuThXZla7uyL9Ky2RDfNA9k1GikBOQptc/85mc9IzBxKudzKy51ASB7vW+N/jE9aR2mbwH6clVWf0myR1L7ei3YF84N30XXVnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yy5uJGqPs1g6+iUEWH7opy1xuyDFDoxM2krbqjQB1yU=;
 b=nkiJ8AHsV9gir3tRqaoSLTp43h5uhA8VbDbwgbaOiryGtykjcZtKdTnwL/eEMVWH210pkcMJ6cRzsLpO1OqfTaMIv9XQLNlPzzCJa/iuRzszRUpXTO/kF9pAudSCheES54f5MxBJkOyM35rpc4lAB6ydavufAhtisf9ck9WLrdsjVDxl9eFpwiDjdSikmlSBT3oIRZAhbf+X3vszetJTMAJ9WUv/RfLlQ3HieUFt8eKb4VoHY/SDpyuY3DkvRA1/GCj6yIlGgBpVgVrdcPgi4aePozGYYGKQ9Xb6DANrIkSZbSpBRu/TozDNVC9Wn4rojKlPigE9yqw3dJ2fncn8gQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CY8PR12MB7413.namprd12.prod.outlook.com (2603:10b6:930:5f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Tue, 22 Sep
 2026 02:20:37 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0428.015; Tue, 22 Sep 2026
 02:20:37 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 21 Sep 2026 22:20:36 -0400
Message-Id: <DLLHIE1QXVF2.38IQWBL11QXIQ@nvidia.com>
Subject: Re: [PATCH v8 07/14] mm: shmem: allow THP support determination at
 folio allocation time
Cc: <corbet@lwn.net>, <tsbogend@alpha.franken.de>, <maddy@linux.ibm.com>,
 <mpe@ellerman.id.au>, <agordeev@linux.ibm.com>,
 <gerald.schaefer@linux.ibm.com>, <hca@linux.ibm.com>, <gor@linux.ibm.com>,
 <x86@kernel.org>, <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
 <hughd@google.com>, <dave.hansen@linux.intel.com>, <djbw@kernel.org>,
 <vishal.l.verma@intel.com>, <dave.jiang@intel.com>,
 <akpm@linux-foundation.org>, <yintirui@huawei.com>, <dev.jain@arm.com>,
 <usama.arif@linux.dev>
To: "Luiz Capitulino" <luizcap@redhat.com>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, <david@kernel.org>, <baolin.wang@linux.alibaba.com>,
 <lance.yang@linux.dev>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <cover.1789695931.git.luizcap@redhat.com>
 <f74ada750d1910f8ea7e55955eb0c330747b93d4.1789695931.git.luizcap@redhat.com>
In-Reply-To: <f74ada750d1910f8ea7e55955eb0c330747b93d4.1789695931.git.luizcap@redhat.com>
X-ClientProxiedBy: BL1P223CA0033.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:5b6::8) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CY8PR12MB7413:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c450369-290a-4a05-4fd8-08df185016e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|6133799003|22082099003|18002099003|11063799006|56012099006|4143699003|10067099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	PmswGfl3+cVF1JNaDD0IHE28THODnWbCqd7dunA+SH3Qgwilo3eJ5C4iaKpttfDSLYxxKBUI3eQI96fnnTX74rw/7mwb37AWOhPSoAg1Qgnrb8P2+l6GgPe6H5/E0ZUIM0FcCwZ7n5GuXjtj5q0WGKyIrZQQSwXaHT7kAUSf+xZ/jpk9uQxhn3CNsDc+9PD8MXLm0zmC1cQ/olL4G1p/B0sm4HUUtxJqYuRXNGcyqvIQY6JhAdcPR3ie83nLXh3ezxGycJKxTgVQ/AGjkd1jdtsvuRxCInzAPgPKBKhhomjOdAbDolKWJTBiUh/VGVkVyU5q+YmjcLiwNn4CwiyuYMD5r4zNHbUP32NAQ2LHqXjbbXLTOAzWqO5+7b1v22BJW63rMrc9fJtbugFgvvDW062AppjCkfyWvcxKyLQAulisA4/wQVRmGryIlASYgBbbwBEY2hzI6OiQ8VQPUMDOsd7OiY0EBdLCFt1oFhNmL2RTscw0UfmduMNzWoT10sKZp2ZKhgJYboLLrvwoj3q2SXeWsbhbrVM/pW1zxzetdBsrQdCppXzQwmEnL0R+f45pS2M0+XlE4R8a/I5onpvx0JgKFk602h/n5Am1bl8gFGtvzePiO4UNRLwCkRtXTSgR4W7+cihUqjIg8ARiOnd5SN6mc56cATMe+UfZeUFjQk8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(6133799003)(22082099003)(18002099003)(11063799006)(56012099006)(4143699003)(10067099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Qkd1SzRPTncxNGF0QnJ0OU4yT2QrdUFoMTlwOEZhOGhQVXNaSkpCTVpyYjNx?=
 =?utf-8?B?Uk9qZDdvWWhhbXZvNk5LNlZKeTVPWFVVMkR2MTVrekhWYVBnSkxVZ0RQMTFm?=
 =?utf-8?B?MS81QzgrNWkyeS9jZVdhRjV0ZkhHOEVTelZmZjh3N2h5QnFkbXJ4VUpuYlpF?=
 =?utf-8?B?RHFIbkUwcmd6K1dObU13QWVaV1JNL3lmSXIxNHpMaEhBRDJUTE9YeDlKYTZv?=
 =?utf-8?B?WjY5MTMvZm5BK0c4QklDRmU4VTgzakNEZm5hMURtcnJnK0Z3TVYxOHJnSkl5?=
 =?utf-8?B?c0lubG85S201UFdDRVNFOEZnZnRxTHdZTFJzbm9CeVpZRExTT1pvKy9UM2J2?=
 =?utf-8?B?Wnk3WVRWa3V2R2xjb2I5ZWQzUzFZeDNHVnBzRGd3eTBQZWZ4cTFndVFEMW1X?=
 =?utf-8?B?OCtMZEhhZG1vTTV0K0FmbVBrcFZGdE14cFRueWt2YTdOZFZmOHNsdXNwQzAw?=
 =?utf-8?B?am4wTzR3YndyT1V6eGpWTDBoOWJyczRJcXZVZStTSnpEbFZ1UmU5MFltd2dj?=
 =?utf-8?B?V3VBUlFOSG1HaEFIaFd0RU9KSnVWeEg2eTllY1ZzMTh4eGZIMnd0T1ZIL2lN?=
 =?utf-8?B?ZXNMY0pzS0k5azRKbG9JU3ZmbE91Q3A3RUljNllJVDZOTit4b08xbnY1c0w5?=
 =?utf-8?B?K29Vcm10MW1tTE84UmpsclY1cUt5MVBpRlp0SUJHZnFKa083WUhTS1NGY1BL?=
 =?utf-8?B?Z0hKNHMwdWNGNjYzQ0hWSHlBYWREVzdEeGtBVHBvd0R1ZUNONDl4Y1ZuWlJ5?=
 =?utf-8?B?VVJsblFuWC8xYXg0MW52M0JLRGduTUxVV3lPMWdKa3IvcDRvY3czRUZpdVAv?=
 =?utf-8?B?eWorYXgwV2d3MTlkVGFRTXlHYXJPWEJBeFdMbEtYempXL2VNZ2ZuV1dBeUlv?=
 =?utf-8?B?eUtyL05uZUJvRjZlK25tR3BoN3pMVUZZQjJQTlJnY21LamFmK3JNWUZSUkRr?=
 =?utf-8?B?V2ZKSFZnODYyY2hsV1laZXV2a3hvYkRmTTlRazNpSVBzTUJIMkdIMDhXZUVs?=
 =?utf-8?B?eUh0UTNSNUUwQUJKMG9RWGREcHRFSTM2Z2hlbWh3VWhZMmQxcWdCdFFMdGdl?=
 =?utf-8?B?ZWJaVXhzTXZpZkhIR2lJdFZaWDdQVVJyWnNybzBhK1BpQzh4WG00S2JGM1lu?=
 =?utf-8?B?RUIvN2RqMGFDSlV5Sm13Y09PVnZQcWxiK2FOMGc0Y2NLWnpZcFlJZVR3cnVJ?=
 =?utf-8?B?STV0Si9FcnZZYkhPL04reFp4RFoyeUFsUk16REFQTWVzUW5wOWVoQitTNjZS?=
 =?utf-8?B?Z2Q0Q0lIeGhySGVhNDVzN0o5RXpSZFI3NzVoQ3l1Ti9IUm15c1U2USsrbGhi?=
 =?utf-8?B?ZWpLa0NURmNpWC90bUVlUE9Rb0ExOThHdkpxaitNdm5EdU5VWHlldXd4dDN6?=
 =?utf-8?B?bnFEVTRqbDE2MEM4NjhZWTZlTXhUZDU5LzJ0WnJpMzRNMHl2SDIra3VmYWpG?=
 =?utf-8?B?VTNKZU00RkkyMjkvZ3FTSVhSVnNKT1JuTEFRcDZUWTFZUDkrQzVwOFVWRW1S?=
 =?utf-8?B?RTkvVWl4MnIzYmdTZm0vbEp1NVBNSEpxQk5McUNaelQ0Z3hpcmdudWVTenhY?=
 =?utf-8?B?T2d6RVBKb1VudDF4NWQ1OU81Rzdid2tralBGcE5ZZ3BPS3pOMUpZSHRGTjdq?=
 =?utf-8?B?UDJteDdnSUhLcC9MVXdwSnAxQkszSzN5dER2eE9MMDVPVWdqKzZBOUZkcXJS?=
 =?utf-8?B?LzN0bXN0TllSRGxmTFZIaU1TMVZTWG9HS1FoL2Z0dlJNVnZWMzkzM1VVc1ZB?=
 =?utf-8?B?TVZ1c3B3Nm9hbHpIcGs1UkUxU1ZQbDROejd2elJ4NC8yQWd2QkNoaXQycnVH?=
 =?utf-8?B?SlBENlZRNUw1cUhUN2NNVGR2K1N3UGZxYi9hS21NTWRWd0xxNWVlblQvOTli?=
 =?utf-8?B?dk1MeHpGSUhDa0c0VHZ3cFpqL21jakNXa0JsSTVJMnJRUnJCMUI2a1VZai8v?=
 =?utf-8?B?elh2L3BxUGZxQ1hTOGhGazMyYnZ6N3NaWGtYcG1DbEQ4SnNtOUtpcWRwS2Nj?=
 =?utf-8?B?QjVTaVdPbzYzSmR2bDZQS0lCZ2xkVFR5QlZOcHNUVlIvZUx2djVjS0xacDY4?=
 =?utf-8?B?TnZmSnVXeHJpZVVDYmplZWpiZFBnRTFMZ0pwZVczQUJEWjV0L3VWcnBHYzRa?=
 =?utf-8?B?ZU1ON1Y4bmc1WWppbVFISDRVWU9nQmJQVXhvSkNOcjZTWVlkdFJhNlJYQXNi?=
 =?utf-8?B?eC9mbTZ6Y1hFZWdtZEYzTWJhdlNHeXhDZ0QvcFEzdHp2WkZLSkxieUNPQnAy?=
 =?utf-8?B?ZEIzTC92WTY1UVFMM2h3TGZMZmdSU1Z0OEV1VkljN0MzMGtuYUNuckNiek55?=
 =?utf-8?Q?uwGGysCFnFyzqpPgcD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c450369-290a-4a05-4fd8-08df185016e3
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 02:20:37.1392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NMIInO2GQ08Gwa9e1Pvh7MjznWIq5qXUmghrEtIALZqIDkfU46i7xjWvumO2fVzl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7413
X-Rspam-User: 
X-Stat-Signature: ssjncto3qigd1nrkm1bkwap4mgjw47z1
X-Rspamd-Queue-Id: 56C44120006
X-Rspamd-Server: rspam07
X-HE-Tag: 1790043642-732542
X-HE-Meta: U2FsdGVkX1/+MI8j9ItAo0KQdkZGkeECUKZ2H1EX887yTSl2G4w614ao2rP3ZX/14OtXa3P+ciYYpfFyDhaq1QIYj0RWd//24KNaK4mJGl/Hrful0ctjGpLmWOJYlW8alwxt+pn/gVBzgvERrmX6h1BDdd4/AQ1AjMfBise0EEf+D8hJ1XoPgNrBElNz1sfvJoeQnPAZHG+AHRnuP1TcOyzzrYqWQZwVkWUFpg9AxYwbfTQOJAR9gdKVNFCs607rKv9bpjB4mmF02jJ45x6AjyyN0KRz/PkD6hZAbsOZJ00HrM+OViLhzHdTI1693I2AWd2okeo21LcdGtDql3DDQ2jxWMCWlZB4NDTxzMoVfeS/gBFMI928SWYqQPr9FKpDx0ZXJxuwH+dl/pLGjmpz3VNYFfbEy1DV2bDZrGfEbZa0R/kjmrywIwPfPPFjewQQ7kzChsPeQHwqBL+pftnoU+rO6hYtKsuFhbEavffR4ScUDngBx/wsNq4tlBYehjIe/EOdxCv1vIrd2frc4qjdY1y0nJLUj+wIqQRvltEwucw7A4HxBCMyglz9ArwLRoA0VrUajzqZEnNaTsPiHBty94TLQvnXm4seEheOiEdnvShhhmtV/LPYLXwJXGOoWOJNn/kS7iMh3nBW/FQ1nL0R4CHXNuWH29MOokFsoaYp2CIsiLyomMpkSLQdJRD8gsX6m9nwVEQ4PX7Ws9FkPQxy6JkS/oFxYVT4hhArrXNApOXFLRPSMZdzbE+UK5gxPOOTOysbF8IFwKYHf5Qk+BOCoJG6Krinbni3f7C16aeIxc4bICGXv0Eo5SfQanNoSEpfTB6rTHvnNTIFzwt4GLwb701Xm8AuUNI/k7whnGPhyu/K5fKF6Jy8sp/GUzXKD0G1U7U2Syn+Y2P7NlS/9+ooxWxEO80esoc9Dms6aTuHcdAVGm4jw1lvMe4FWjA8PgF06PIvbB9xH47kbFBonk0
 dg6qeoXo
 CnaMevKsgvbi7Td2+CjEUURKzSPFIgg6Mjjvw6FC/Vu+XEsz/ht5qJdP2iQhr3OuXrNoa/yE9fH4hlgvtTwBkq2sR3OkWGN1pVGMe+L3qYD3momA80bvDKk0ZjNP2Z9uo0LTIJoSsPpufAiPBZt1cR/ZJu5+64AhRbpXuPQ+1p9o28v6kZw1MTAoUkcOiQESFiwrR0SmMs4SR32CNGe+jmPCMqh5pj+uqsE1vztavfr2jQwHG4JLfn5oDcB3Th9YyxOTC2BDvwJeIxdEG4MrTyH8Er7opuJa007r93pLhpXv+aS4uylyYJ1Z+dn7j2E0tV5Tx0kIcGkrK0mv+GcUJK0VLWi1WoBQX41XgVll/TL0MInof+VemcYWM50RjXA+5T3LF5s7WJHDt81bGsZX+ODLIUNK8sU+m3s45ogrFTbF4UA6Pq/LR8H7Hoa5xMV0Rkhaz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Sep 17, 2026 at 9:45 PM EDT, Luiz Capitulino wrote:
> In order to enable THP support in shmem today, besides the user
> configuration required, the CPU must support PMD-sized pages. This
> is the case because of the following has_transparent_hugepage()
> usage:
>
> - shmem_parse_one() and shmem_parse_huge(): Check if THP is built-in and
>   if the CPU supports PMD-sized pages
>
> - shmem_init(): Since the CONFIG_TRANSPARENT_HUGEPAGE guard is outside
>   the code block calling has_transparent_hugepage(), the
>   has_transparent_hugepage() call is exclusively checking if the CPU
>   supports PMD-sized pages
>
> While it's necessary to check if CONFIG_TRANSPARENT_HUGEPAGE is enabled
> in all cases, shmem can determine THP size support at folio allocation
> time. Therefore, drop the has_transparent_hugepage() usage listed above
> while keeping the CONFIG_TRANSPARENT_HUGEPAGE checks.
>
> Additionally, we need to check if PMD size order is supported in
> shmem_getattr(). Use pgtable_has_pmd_leaves() for that.
>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>  mm/shmem.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 776dff8a848e..930657d05375 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -690,7 +690,7 @@ static int shmem_parse_huge(const char *str)
>  	else
>  		return -EINVAL;
> =20
> -	if (!has_transparent_hugepage() &&
> +	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>  	    huge !=3D SHMEM_HUGE_NEVER && huge !=3D SHMEM_HUGE_DENY)
>  		return -EINVAL;

This can be deleted, since shmem_parse_huge() is guarded by
CONFIG_TRANSPARENT_HUGEPAGE and after the change the if is always false
under that guard.

Otherwise, LGTM. With the above code deleted, feel free to add

Reviewed-by: Zi Yan <ziy@nvidia.com>



--=20
Best Regards,
Yan, Zi


