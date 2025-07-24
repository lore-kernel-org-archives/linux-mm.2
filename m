Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5AC1C83F17
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 03:35:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 255478E0040; Wed, 23 Jul 2025 23:35:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 205C68E0002; Wed, 23 Jul 2025 23:35:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07EF38E0040; Wed, 23 Jul 2025 23:35:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E43918E0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 23:35:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8908AC029D
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 03:35:52 +0000 (UTC)
X-FDA: 83697744144.24.C6466F4
Received: from esa7.fujitsucc.c3s2.iphmx.com (esa7.fujitsucc.c3s2.iphmx.com [68.232.159.87])
	by imf21.hostedemail.com (Postfix) with ESMTP id C6C181C0007
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 03:35:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=fujitsu.com header.s=fj1 header.b=bMFWoYLg;
	dmarc=pass (policy=reject) header.from=fujitsu.com;
	spf=pass (imf21.hostedemail.com: domain of lizhijian@fujitsu.com designates 68.232.159.87 as permitted sender) smtp.mailfrom=lizhijian@fujitsu.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753328149; a=rsa-sha256;
	cv=pass;
	b=3MoxHLabgJhhS3P7eVfYhHpWhVIe+3flNCDxWaTlOz4jHjghS5SlH1UV9ySOz0mMl0/eU8
	QTDauz9SeShad2aUXC1dXpX54mGpOhCkYtALcKsODkqK0FVWnrBy1JJ5lXb/fqLB4dp/nI
	5qDXCYo2rewxjkyXIj+it0IaKlHBCvQ=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=fujitsu.com header.s=fj1 header.b=bMFWoYLg;
	dmarc=pass (policy=reject) header.from=fujitsu.com;
	spf=pass (imf21.hostedemail.com: domain of lizhijian@fujitsu.com designates 68.232.159.87 as permitted sender) smtp.mailfrom=lizhijian@fujitsu.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753328149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6a2+GWUb2aAUImsABa3Z98ARsn+CHsbMDiGAHV8nTo0=;
	b=ELQqMqZhXglE1fTtGt2thUku3gfqDb5k+uUr+ktNsZue0OGYUtKusPT9nUgSmC93aP6YRH
	oyKqI0vlFetbUtH+Wv9nHSFBsXW3YyVxVO9LzuzaQLEeRWw5hMGRXicc4RLyTjicNgH/eD
	VXKPCYprFFkUZgV21+YvRPpnFra+uRk=
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1753328148; x=1784864148;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6a2+GWUb2aAUImsABa3Z98ARsn+CHsbMDiGAHV8nTo0=;
  b=bMFWoYLgQQxKeLMSuDjtNTDQoQX+se9kmn46rGkutIj4kOi5mdZOJYGK
   Hibr/t3RLhI9hb9eHlh9IUoGS8pdEggvxBa0gED1d0vefpjhCZplkNi4z
   uzzGwIUiXCjTTluomiSY77CWKxCZJSCCAoUtGCR4HyXMpf2VfSsteafv+
   KeYxUqCei7WgbYIi57ObfSRlMXMwZchq+JxcHuYBI9TKtTYY1i9T4O1BW
   MzYrgOmgmrMHwtDIV7xmzaHJrnVC7f/F7A5E4+e5Bz7xV1T7ztOTWWqxL
   02hnyj+BplkBE9Yod0HBWsYADaqVuUNU9k2makloimTE/PtI+NYtvMb92
   w==;
X-CSE-ConnectionGUID: GbLt9rhwS4iqzjAM69bW+Q==
X-CSE-MsgGUID: 81smMSfzTAa0nKxaH76D0Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="162421624"
X-IronPort-AV: E=Sophos;i="6.16,336,1744038000"; 
   d="scan'208";a="162421624"
Received: from mail-japanwestazon11010061.outbound.protection.outlook.com (HELO OS0P286CU011.outbound.protection.outlook.com) ([52.101.228.61])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 12:35:43 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KMM3ykibn6d+A7/J0gH9me3dXI8uffl6g/kxt6MnYPStdkjfuuOOZB729NfuDKm+4gf/4I4Gm87f6oV86pJYMvku10J/UBk1RuaqqfWhz7wazPf9cimVh3gOh+B5wJJJBpew7ZYSSHxhjTrgtGkHad6a1oygOzXgmNuYD9Dk97OAEoJhQPpsQTsy9YD4VyvxdiuvEgdOj43K5Xoh7S/58FwIDktLNt7IwO4ZnacoaXxolTiDr7BPAPaAJADpBDHFlqYPnNe5GOSLVOqdaIM4NT3r9RMihVTmGPnbUcJbPP/C7uKrNEKt4MwYDLfHIRiRYcJb87vRMtwGK2QX8Ea7cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6a2+GWUb2aAUImsABa3Z98ARsn+CHsbMDiGAHV8nTo0=;
 b=m78MCwY0RPIVON1Oup4q6UW5/eG45oOukVm6waNgasPNdlg5Cga4rECBqzPB0b6vdbv8MmWRRtUAVC7APBr6BNH+TlOjTmFO34TARHfhYuYntTAgHIz9f9j0RKDupp/tU/Toyg8c6RUTAZ4U457wwz0d5d3CmU6PeiQJL2cu14Olsu/V/NViqAXL4wLPROympPngrBFslbVvE805CHAxd9Vl/FH4GDyQKT3gOCHtt7rAQVit5Ja0xpIJCo2mXa8688UzcTbDo5VjeRY9MkloSPMKAvQfwy9dBWb7HYfPJ145dUWmEbJWckxJzg3t5FjeImRX40dmpCIaMCdtNFPRig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from OSCPR01MB13050.jpnprd01.prod.outlook.com (2603:1096:604:330::6)
 by OSZPR01MB6598.jpnprd01.prod.outlook.com (2603:1096:604:fa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.22; Thu, 24 Jul
 2025 03:35:40 +0000
Received: from OSCPR01MB13050.jpnprd01.prod.outlook.com
 ([fe80::a874:ac57:8f02:c2d5]) by OSCPR01MB13050.jpnprd01.prod.outlook.com
 ([fe80::a874:ac57:8f02:c2d5%5]) with mapi id 15.20.8964.021; Thu, 24 Jul 2025
 03:35:39 +0000
From: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
To: "Shiyang Ruan (Fujitsu)" <ruansy.fnst@fujitsu.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"lkp@intel.com" <lkp@intel.com>, "ying.huang@linux.alibaba.com"
	<ying.huang@linux.alibaba.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "Yasunori Gotou (Fujitsu)" <y-goto@fujitsu.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
	"vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
	"dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>, "rostedt@goodmis.org"
	<rostedt@goodmis.org>, "mgorman@suse.de" <mgorman@suse.de>,
	"vschneid@redhat.com" <vschneid@redhat.com>, Ben Segall <bsegall@google.com>
Subject: Re: [PATCH RFC v3] mm: memory-tiering: Fix PGPROMOTE_CANDIDATE
 counting
Thread-Topic: [PATCH RFC v3] mm: memory-tiering: Fix PGPROMOTE_CANDIDATE
 counting
Thread-Index: AQHb+xNKslR9U6zgUEK2IjSEBc+XtLRAoeOA
Date: Thu, 24 Jul 2025 03:35:39 +0000
Message-ID: <ecc1622e-1076-4c03-9e1b-44aa701e6a5c@fujitsu.com>
References: <20250722141650.1821721-1-ruansy.fnst@fujitsu.com>
In-Reply-To: <20250722141650.1821721-1-ruansy.fnst@fujitsu.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OSCPR01MB13050:EE_|OSZPR01MB6598:EE_
x-ms-office365-filtering-correlation-id: 83ad06d9-ac38-40b8-14eb-08ddca632921
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|1580799027|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?Y29KOHlOek96dFc3dVF0THBzbkdydFN0M2hZTW43eTdCUzFnS3JMRUE4K0F0?=
 =?utf-8?B?ZzJqeTNZWE5zdHFiN0hTaElmWjExVWpuVjNZT2lmcWZEUzc5ZGd6NENZQXFa?=
 =?utf-8?B?VmVmMENEVTFmSENPY2QrUURMcmdiMThvdDZzU05SOHRFL3FpL1NJVWpwR0h6?=
 =?utf-8?B?dlZKNEd3cEVmbUVCWml6eUNpOEtKZGxZbU84R2QwbWJqTmJ1ekY2UDBlaTU2?=
 =?utf-8?B?elFXSkhrM2V1dml2MzdkUTJMRHpQSmFtMnBZUVRpdnVHand3UCtEY0RLSHVv?=
 =?utf-8?B?V0M3MXZ4RUVjSFpVZCtiQnZLU1ZYTFNaYkxkVWwrRlBpU21ja1JsZCs0c3hS?=
 =?utf-8?B?QkVSVUxpU1dMcWRUbG5rd0wyanlMWW8yRlNKN29XcStpelRnSk5kUHM3b0ty?=
 =?utf-8?B?bVArdnRTaDZuZjR5VTJvV25tQzNUWlU5cE1MMEpMQWZDd1ZPVk9qODQ1UE4r?=
 =?utf-8?B?TWQ1dG9hNVdkdytRN1MvVVMwckFVYjdqLzlEa0twVHVuZVhoYXFodHlIMDB6?=
 =?utf-8?B?V1JpM0ZadlU4bTMzWWx5b21oYkh6czl2OHpROUdhaTZRT1lpV3pCeUlrcU53?=
 =?utf-8?B?TXhUSlFZMmtXZkFTTGtkMThqRU5UR0ZIUnNIRHpneGk4NzlYdk1MMVZDK1R0?=
 =?utf-8?B?TC9IempVVVg2RFZ3amEyU3dGeVYxdVpVZ0gyVWxWVkRSVmYxdXRLQmFjRXpG?=
 =?utf-8?B?MmVzWXF2MEdmSGNzWDdSWXBaZ1N3bmlacFhDMkF3ZUtLYzdFd3A4WUZkV1dD?=
 =?utf-8?B?bTVaQUx2Um5hbDRBSVdTVWxsaDZVSDd1cHdIWTVYS2VKSUdsS01vRUkzL0pX?=
 =?utf-8?B?SGxqY2phWVhZbmRXQURnU3pIRjNaZC84UDR6UlZFRHpsRjUzUjcvQlFLMHUv?=
 =?utf-8?B?SXREZ29VNFlnSlgyL3BWYnU0bCtxQ1lMdDE5dEZPcHVoZVBTOUR0UHVacnB1?=
 =?utf-8?B?SDV6RVBXVXhyZXlzR3hTWXV4MU5Wc0d5L1o0TEVlMWNqVEc2Sm54ZC9JeFAv?=
 =?utf-8?B?UTFlOW5uZy9sQ1JjQkNoT3JQMHYwU2RwS1ltaHJYUFd6MnRxRzNlc0czaWZK?=
 =?utf-8?B?aS9TT3NMVE9xd01CSTFIZ242SHVVOVBRcFZ5bmtrbHQ5aWgwanMyemlkZ3VT?=
 =?utf-8?B?S2p2c1gyeHREQStoRDBMc284N29DUkd1RDZrckhRWmpNa05VQVhGbjVTMXNJ?=
 =?utf-8?B?M3IreENMVHcrMHRTc1h5bmJlb29wRk9SeHMzVFJLOWZQRkR0Z21qbHRMQlpL?=
 =?utf-8?B?bmdwNlVXbnpmNXY3eWhYM25BK0Z4Vy9sTGFlOVVZeGhnei94SWlMWUxXSHhv?=
 =?utf-8?B?Mm1selp1VnRJMCs2SHlrRzBOb3ZtZG5scE5jZU04eldmVWRxY3hBbHdqajU0?=
 =?utf-8?B?UWZWVzJJb0M0d28xZ016dTJHZ3JxZC9JbXA1dExDenFBQk83VWRRa3kydTY3?=
 =?utf-8?B?RTFtUFFrclVQa05tYUlGWUgzOHdoYkJGT2pyTllkMVV3enpNY2lwdzY4SjVT?=
 =?utf-8?B?dGdRcTlZamwza0swK0hTdkRuREV0Y29QbTk1WDRHUlZUNzIweEJFTUtjMlpJ?=
 =?utf-8?B?bUxPZVNNV1pPYm1DVW1xUnhUVy9wTndyYkttYlFEbE1sSjV6WkxuakhIaUZ6?=
 =?utf-8?B?MGsweEU3YTEzdHgvcmtoV3ZsbTdDM2FOcjYzN0g3Vm5BenpJQlRqZUdqTTh3?=
 =?utf-8?B?cGxTaDd4Y2hhWkZaNytRMWZJQmVEMWVwc3NESzlaNm81TFpmNkljT3A4Um5R?=
 =?utf-8?B?Z0hmU2JadzhNcVFTWU92Yzc1TXFRb2ZoZVhIeDU1WkdsZWVzTkRxa2xuRWY5?=
 =?utf-8?B?S0VNTzhNU3phSTI2VzJxVENqaDFKR05XSENjZHIrVnpGSUo1VjJNME8wL1pk?=
 =?utf-8?B?Sjl4RGdNZjlOcUU4Y0hONDFVSnZpRGNHTERrc0g1bGd6QVZHVnJIMFh4Witq?=
 =?utf-8?B?THFpRlVMd0F5YWNERmthV21Ody8xUUk1YnZCbm9BblNEMjUzTUNBNE1MVUdV?=
 =?utf-8?B?emNvUERmQVJiZjJDaVNQTkM4ZmcwRGxwOThqYXpZdCs1OXU5KzRUdmhmQkRM?=
 =?utf-8?Q?js2aVl?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSCPR01MB13050.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(1580799027)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SnJMRXpHYm14djVDYlNhRy9ZUjBTSEtYbUtoNEF1amxrRzE1R0xBK3pDZ3da?=
 =?utf-8?B?T2t2NXpyNHZJVFVUd1hqWlozNHRnQW4zdWNHTDVidGhTYytIK1NwZ1JiNDcr?=
 =?utf-8?B?VnRVcE1ieTJvMlhUU3dIR1M4ZFQ5TlJCR0JoaDRPdEJtS0JyTWd3QkpUdG5t?=
 =?utf-8?B?c3dCTmUrMFNTU2VnakEvRTYxdDZreENGQmEyUURDK3Q0S0svLy90djQ4SlJO?=
 =?utf-8?B?aTJma2c1b3dzZGl0bU82QnY2RTI0NWMxRnNESjBLZVNXWWI5a2hiY1JyNUV3?=
 =?utf-8?B?ZERSRHBJaDl1NG5KQjB2cE1qZnF4NCtvS2RyTjZIdTFRRGU3aFVIOUIrUFpX?=
 =?utf-8?B?QjJabTJ5L1ZibWpCdDVqWU1lY05pSHlwMDFLSFFIYVQ4a0Fmbk80OERZdE5X?=
 =?utf-8?B?NkpDT2xpbFNiRWlENmt1aE1xQ0Y0a3N4d3BzUmJlb2xIRHc1KzZVbURvSVNL?=
 =?utf-8?B?QmdsMTQwMGg2VEU0cnZQN1VmaFpaOWY3VTZnZ2REeldKSUdGY0VCV2pTdG5Y?=
 =?utf-8?B?QzdhZzAveSs2YTM5eXRXelIvWU5pUU1kMWlhNkt4d054MkxOcm5aam50ekVo?=
 =?utf-8?B?MDZHMFZ4b013YVp2MXc5OXpjeTZFWXNmSnZ6MDZLdkVFQStRa1h4VFQvam9i?=
 =?utf-8?B?ZDFTVUVCSUtjVGEyWkd3MU1haGFDNDRjRG0xeDZvQzVxbm9hZnhzejkyeENJ?=
 =?utf-8?B?Y056WDJIZkJLUjh0aUt0SlpOWGJNTFNnNFl2cklYa0VxVHNPVXVHWGFncXFr?=
 =?utf-8?B?WSsybFcrZDlpbFcycGFpbGhHU1BtUnpZQldtODh0K0FRNE5SSElDdytuVmlZ?=
 =?utf-8?B?NWhMcXU2QUZ1V3pYVDl0MmtmVHJ2VktLaFFKY1ZXNnBKQkw1Mnd0SUYzNDFX?=
 =?utf-8?B?b0V1WEJ6L0pJU2FDNEREMUZYcy9QV1ZKZ3QzTGM1ckRlTkxtdmY1RFpwZFAz?=
 =?utf-8?B?aERRTzhxWnUycDlWSDNRT3VKQWtTUVA4d05lNHlMUVpOSnNBMTFST3BhbVRj?=
 =?utf-8?B?UHNwd2NYd1p6R2UzczNtdVZ2RlNMZElaT3B3UWljTEtPaFFyTmdyMHhyNGRq?=
 =?utf-8?B?NUs4aHJGRmZxSmYwZ0dHY092VGFPaE5TYUJZTS9yRncxRGhidVQrZzg1Rml1?=
 =?utf-8?B?TGV5SHBnY1VsbTRJWmE4NGVjc3dSY21OLzdxYWtvWER3MDFIQVhMTGc0L2NQ?=
 =?utf-8?B?QThLQXZGa1dvOXgvYmozQVo0QjgwWDNxODl4Vi9UMDE0OHI0WkJJK0ExSS9B?=
 =?utf-8?B?ZlpPNjB5ZXdQczBZaDc0dUhBVkgrMVlYNi9JSitqdHE0bGNrL0tzWmtFL3RW?=
 =?utf-8?B?TnJObHVGY3prQzc2a3VuUExEWVE0dmpXNVViOGZqU3M0eW1ObmppaTBtNGVt?=
 =?utf-8?B?bTkyd3lRb3REVU1TRzNsTEhpWlZJemxuU0xoaGNoWjV3aUJhWTMvT1BQLy9G?=
 =?utf-8?B?TTlNTEJWbUIrRDNVRWFHTXFmdHdNRUR2bkk5ek1jcENmNFlDZ2VUNkNNcEto?=
 =?utf-8?B?b1cydFRYSnlpa1AvRGRZNW1ON0UweFYxZWZ2Q2g1WDNRZ3hxWWhBRkF6bjhG?=
 =?utf-8?B?RjB1d1RENGM4a2QzTm1KbjBFckVucklLMUE0TEdEWFNrVno2R0RyamNRZTdJ?=
 =?utf-8?B?ODR0MStIZmZXU2NvTEdSaGM1NVd2UHZ0NUd1V2ZSdlBjbGFJSGFTWndrRkhN?=
 =?utf-8?B?MmlBZ3BkcWIycWdmM0JjMEpCVFdsbHhTVGZEMEErTHhiYi9YOXNISjZYY1J3?=
 =?utf-8?B?WjdXbnFsQ2x4QnlRVzhaN3Z5YUJ4eHYrMDVmL1Ruc0daZmc2SGlHRFZrbllQ?=
 =?utf-8?B?d1RlRXprV3BMcGtHRE80eVhBZWlXUHVXZmZxZ3FWeTJwK3NxZ1ZMQ3hza1dx?=
 =?utf-8?B?d0ErMXNBbFhzeUNESE9zNG1oZExTRUtlVStMY2ZFZjRrUWpTUFNDU1ZhanRJ?=
 =?utf-8?B?Wnp6NS9lWnZnTWVtTWZDYTBXMzBFZzFGNGJ3dk5RcWdiTFNvMmpVQnJEREM4?=
 =?utf-8?B?QnRiRzVYeFdsTXluVTBIUXVvaXJqWTlPdE13ZnhYSlVMNk9MRGpNQlAzb25V?=
 =?utf-8?B?N3dWNlZHWFF5bkpLU3BQcXduRTBjbG1aQU52dnMrVXVXV2RMaWhRQUpieUdu?=
 =?utf-8?B?b2FFRDF0dXpaZDZjcmhhSlU3NmFBb1JlTlh0bkZWNGFCTnpNeDFuRFg0V01F?=
 =?utf-8?B?L0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B174E048B1FED04E8288A4C7ADD52D14@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qmS7bYt4VlpWj7SZaFwxkuqDNq+VagPGssaYvrKo4CCpQZotIICMAc6LsdNdMyrkXq8gCiKFMCTF+iFPLXVqLBAqe5+k0cLZmY5iJ31227mrW7lWqtJ/QRTAkMVQWjsdEJ+OVXcuZRmK+LolzO+pnSRHNXBLQy1LTVGgLCleme7flWILEwj5R2UhbUWgM7RLqMTH1jjp5to/RjgUZaiNficUg9QP0WmOmFQw9zpOpOlKEcIAF2v0oZDNHrXy5NkGe6wXhLUtTWO52Ac+xZt9d6sRtvajGixBBCurhQMqAMjd7E+EIh+oGVyfGysDYBqzzQpQOJ7zrKoSb8QG0xc8hISaotxvi7T8d/o444Q3v8iBY5cutXjMIv9JcGn8mLYT89MAdvu0ITUtHOtSFCtrp+UeuAfaX6ux7CQpBQpNbIdO9A6kglcU57evST2QPLGb7z6u2BNdwZEecvWlFbnoH6fs9koEklvW4XGDsDeC6h64k+8LALLdhMpc80jgtWdlTrKLhS/T+vicmvtXllqe3Re3GODzWH3U9ODIj7jwU5mWKISDoRvhvbgFLJ/NVyigEd8l5svu8kcP80UU8znJI1u2vpapvfEZW9SHHyBqAwkxtuTZVPBimA/z0uwLfgEn
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSCPR01MB13050.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83ad06d9-ac38-40b8-14eb-08ddca632921
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2025 03:35:39.6533
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x9CpeDtF9C7i/JYUMZjwYJQSHFb6QQBLcNOqRrEQ5XjT4Tfoqw0gLcP4gmLshHlb28x7wwXOJmfW4gN4/edo2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB6598
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C6C181C0007
X-Stat-Signature: gtc3ezq7iiwk38h1yeig3jhwmd8gqbmj
X-Rspam-User: 
X-HE-Tag: 1753328148-668517
X-HE-Meta: U2FsdGVkX18axcUcND5fcgqfnJVst21zHbATmjwkYjRoztn7slIHtDkk0ch+jYNojucBfLHoNxis19W5GTO4a62ZLKO1Gjg3Zdy8n+IbjM9Xs7/70OaeSi7E9uDwAvdKazAzE5Ui3iVYLCTFIQGfpaNVLBdlYS27W5AtS5og7Jc6ou3XfM8iGgEQo/wfZekMKdeG9iB90kn74j9fJOFvhoVgvsfe85fZPpp3M5AqfKw9ppN9amG81j/dgBIbV8JUAN0GuoD2NZEgRt9VA4REqehtmNdpou/ZJru78c5AdYApwJhg70IO5aqnigeNux+pgTW4EHLza4jPOHlD9WR4Ie7oaHg1yKAqbCdJwACnx6GMjUrQBEFpsd10Ofc/vUjmKWeOiausoiArUQ4izsUsPuFFCmIs4q11LzRv8g/Vvepm2lokc4rVSQa1wS1vIRJj3dM4nE+L2sMJ0x59hLkoovFE9d2DTRpV+5FqAjWPY8h7y7nkBor3yvTry74KSReZ2rAMbUvpbtJmV4F7w4rktGxjKqRG/g29EQDU2ynKtgUyxfPyKAJkEBGpEINDoSBEhWmVsEDaDV+2G2GSyhdbvjezQw12NW6P8NLY3Wtpwz1Heqlmb1U+87RYE6NryjsxjmrBPg0q1Qu0XDXDQrLRP4c02T1Ud2psD9c4Z8J7vQOPPFWR4KXNCedNewU0a/zkkpjVbrcYSIrYDDqJ3+jengl9S0K+p+0nUDTNBXwAjDSXZFbCRjaOZvqsl7C8zXDPqjLpF6NN6JPorbyFBYOqQAsCPd9vSkZvMflvWYFIMBLC08otTS4e3/xXQA7By61m0ysOEzveuFaP7/0wAuBN1LzTUJdW6n0EZ57HLo5XvaozN80EtmunMSs/p0td7REllQ06gyA26HAtCjBfr6zN/hrGpv4XEuJ/H5LUMNSashuaUCvkEBMWFoa7RBgQmMubxiFe/JpVOYPfZFhJJ9s
 WmFLjugA
 8GnrRXmS+HYPVpFDXOGPlhvj8aL5ZMIZ98NHMCjpDutRksYGDGpXTx6cBmI68tL2fetTnsWS5g8Wfh/YTV4Qhv02bLDPvEJQX7H6kJaMUunNGqlG33qiBVKtG/wEvwyda81Y/XMYTUwQyjoIpm8rpQWvY3y5BP2D9N7zmQJW5e7IqURcuSy8ztG3LK7DMhqfdvR0SrH+mJYHQi7yu8jxCN+RKa3YgdFAmhbVuk1uib3OGUXdd9EWwRoru5OeWrBF+czTgFNP2P+RtNntIWcsCpSUZA32ruC8j4flvs4v+VhrXyL6CeDbtFOt/4c/wgA/o9sruNlFHKY3op5yWkH1fRhsu4Wb7k3FP8EChP6oD1xeH7hNOYW8y5s6feSEqPpx0THLgrwUNV+15UDWiijH9pVcnaTYVZxzJvIb986cv0RK43tT5CMXMtQcvaD79T0d91hA5tBFlTVsPEwPf1Tpd+sb2t7RgCsrq5RDDoEmtOnWpLak3Iq0ds9f64JyyciEiyIedmt3cBrWEtVdhuhdM7np6185FVifkCPiMiJ104Yh+H16aZ7wghpRSAeTpYFjk/APS8Bz6IFbySaBrfC0GE9Zp8NCLJKGmC9drkCkiBKtIFFyaagGT0rYPkonK8OUbYF3E3aY/atbl5NW5zONMPc8eX4m8gc+ABNm5ieQk6v5IvrUOlAAhybPPxpzLTWhWlxmxPcEuUYOzNPBmpXWoBKDXAym8yx+kKxgvv0tlqGVP7q/lylFKQKEGZzytnUR7vkjBNpGJu8bJUgzr4Miy8WyXULW9+RH6qFmlcU54qkLmu2txR0VkW7/NJvUd1KjDxNhODaFvZZ8UJEtSS7RniUpwSv1qPv4P5CPq8Bufoy7P2d40nuc8PXqXHA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DQoNCk9uIDIyLzA3LzIwMjUgMjI6MTYsIFJ1YW4gU2hpeWFuZyB3cm90ZToNCj4gRnJvbTogTGkg
WmhpamlhbjxsaXpoaWppYW5AZnVqaXRzdS5jb20+DQo+IA0KDQpJIGJlbGlldmUgeW91IGFyZSB0
aGUgYWN0dWFsIGF1dGhvciBvZiB0aGlzIHBhdGNoLCBzbyBwbGVhc2UgY2hhbmdlIHRvIHlvdXJz
ZWxmIDopDQoNCg0KPiBDYzogSnVyaSBMZWxsaTxqdXJpLmxlbGxpQHJlZGhhdC5jb20+DQo+IENj
OiBWaW5jZW50IEd1aXR0b3Q8dmluY2VudC5ndWl0dG90QGxpbmFyby5vcmc+DQo+IENjOiBEaWV0
bWFyIEVnZ2VtYW5uPGRpZXRtYXIuZWdnZW1hbm5AYXJtLmNvbT4NCj4gQ2M6IFN0ZXZlbiBSb3N0
ZWR0PHJvc3RlZHRAZ29vZG1pcy5vcmc+DQo+IENjOiBCZW4gU2VnYWxsPGJzZWdhbGxAZ29vZ2xl
LmNvbT4NCj4gQ2M6IE1lbCBHb3JtYW48bWdvcm1hbkBzdXNlLmRlPg0KPiBDYzogVmFsZW50aW4g
U2NobmVpZGVyPHZzY2huZWlkQHJlZGhhdC5jb20+DQo+IFJlcG9ydGVkLWJ5OiBZYXN1bm9yaSBH
b3RvdSAoRnVqaXRzdSk8eS1nb3RvQGZ1aml0c3UuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBMaSBa
aGlqaWFuPGxpemhpamlhbkBmdWppdHN1LmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogUnVhbiBTaGl5
YW5nPHJ1YW5zeS5mbnN0QGZ1aml0c3UuY29tPg0KPiAtLS0NCj4gICBpbmNsdWRlL2xpbnV4L21t
em9uZS5oIHwgMiArKw0KPiAgIGtlcm5lbC9zY2hlZC9mYWlyLmMgICAgfCA2ICsrKystLQ0KPiAg
IG1tL3Ztc3RhdC5jICAgICAgICAgICAgfCAxICsNCj4gICAzIGZpbGVzIGNoYW5nZWQsIDcgaW5z
ZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xp
bnV4L21tem9uZS5oIGIvaW5jbHVkZS9saW51eC9tbXpvbmUuaA0KPiBpbmRleCAyODM5MTNkNDJk
N2IuLjYyMTZlMmVlY2YzYiAxMDA2NDQNCj4gLS0tIGEvaW5jbHVkZS9saW51eC9tbXpvbmUuaA0K
PiArKysgYi9pbmNsdWRlL2xpbnV4L21tem9uZS5oDQo+IEBAIC0yMzEsNiArMjMxLDggQEAgZW51
bSBub2RlX3N0YXRfaXRlbSB7DQo+ICAgI2lmZGVmIENPTkZJR19OVU1BX0JBTEFOQ0lORw0KPiAg
IAlQR1BST01PVEVfU1VDQ0VTUywJLyogcHJvbW90ZSBzdWNjZXNzZnVsbHkgKi8NCj4gICAJUEdQ
Uk9NT1RFX0NBTkRJREFURSwJLyogY2FuZGlkYXRlIHBhZ2VzIHRvIHByb21vdGUgKi8NCg0KQWRk
aXRpb25hbGx5LCBJIHRoaW5rIHRoZSBjdXJyZW50IGNvbW1lbnQgZm9yIFBHUFJPTU9URV9DQU5E
SURBVEUgaXMgaW5hY2N1cmF0ZS4gSWYgcG9zc2libGUsIEknZCBsaWtlIHRvIHJlZmluZSBpdCBh
bG9uZyB3aXRoIHRoaXMgcGF0Y2guDQpGb3IgZXhhbXBsZToNCgkvKg0KCSAqIENhbmRpZGF0ZSBw
YWdlcyBmb3IgcHJvbW90aW9uIGJhc2VkIG9uIGhpbnQgZmF1bHQgbGF0ZW5jeS4gVGhpcyBjb3Vu
dGVyDQoJICogaXMgdXNlZCB0byBjb250cm9sIHRoZSBwcm9tb3Rpb24gcmF0ZSBhbmQgYWRqdXN0
IHRoZSBob3RuZXNzIHRocmVzaG9sZC4NCgkgKi8NCldoYXQgYXJlIHlvdXIgdGhvdWdodHMsIEBZ
aW5nPw0KDQoNCg0KPiArCVBHUFJPTU9URV9DQU5ESURBVEVfTk9MSU1JVCwJLyogY2FuZGlkYXRl
IHBhZ2VzIHdpdGhvdXQgY29uc2lkZXJpbmcNCj4gKwkJCQkJICogaG90IHRocmVzaG9sZCAqLw0K
DQpTaW1pbGFybHksIHRoZSBjb21tZW50IGZvciBQR1BST01PVEVfQ0FORElEQVRFX05PTElNSVQg
Y2FuIGFsc28gYmUgbWFkZSBtb3JlIHByZWNpc2UuDQoNCg0KVGhhbmtzDQpaaGlqaWFuDQoNCj4g
ICAjZW5kaWY=

