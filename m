Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2891CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 21:52:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF37A8E001A; Thu,  2 Oct 2025 17:52:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCA5F8E0005; Thu,  2 Oct 2025 17:52:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB9368E001A; Thu,  2 Oct 2025 17:52:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B8C28E0005
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 17:52:36 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 18B43C02DA
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 21:52:36 +0000 (UTC)
X-FDA: 83954523912.12.746C4D2
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012046.outbound.protection.outlook.com [40.93.195.46])
	by imf14.hostedemail.com (Postfix) with ESMTP id 41353100002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 21:52:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=boJppddG;
	spf=pass (imf14.hostedemail.com: domain of jhubbard@nvidia.com designates 40.93.195.46 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759441953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e1bTBcaPvxP46ueOi0mzMYbIMIjhLHfi8JghbIzskr0=;
	b=NTBkDbgZexQhDNkTjn9eDUAOtCtOyD9rsU7cUuyS5z5qWLVDD+OcVWbJl2WSpJkc8T8uTr
	jzacQzuCa7gKwHBdFXIIYEofj0GA7LcuCIKdnXTsV2lzPpk8Nfw6jY7kGX5CwxoPjgWMcM
	wKpx9/IoPlw+qWzEe/4OHUAiCbQ+haI=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=boJppddG;
	spf=pass (imf14.hostedemail.com: domain of jhubbard@nvidia.com designates 40.93.195.46 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759441953; a=rsa-sha256;
	cv=pass;
	b=5vS4Rrh724lpe6J3KKjil4ay+q7j6NlGVSHOvBU6Ia8PlAl0ydK0ghIKtskkMsOwo0EPMt
	gyxhuEnnfQBJW5HhinZxDi6ufHEr7Ki37TX4w6YRINwyjnc/V+y8/+28MIuTb+liEb1fcI
	ClFFmypsdS09kZdFXvi5t1RZk6rJqpk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oEp59iUr/BTRXWztCeY+D1eaMhQ/XYUD90Zz5kZA+yIVmgrKHgqqTRQpXN48uxxLPuQ5dhVOV5+pGYpeO+kJwCzfvV8orzFhKrQUPDZ+XrJIBqX05BnurBqsP4ycoZAnBTReMfnTTsizI7Ljafd1WSSD79KWKAwIHrvvBGDzGEKz5hxgL/9UXU9SxR1ixPj5augUcshGcqtpea0EEjM14JZflPE5Bk4w7IPwlaEhn8S9NjHmSAVdpSf8yLEJO7Q+8VqsHyF0bUGvMpyLttw/lXWsjOd2YmXiTbTNDdYpHbk7eTqYIRd9OuAxN7nrjTVz/NOrvhro6dEw4u3/jqNoIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e1bTBcaPvxP46ueOi0mzMYbIMIjhLHfi8JghbIzskr0=;
 b=jGt49yiBo3NNdRhZHuoxSL501VZlHuf56MSqKFql0nkqU/elazluf+lqHRzT5hjUBfXhVdjI0OkhdyfOte8f773cWnWe6VUNCcgnQifddbnwl66tVs8yHGxMoo9pSvdQebKbPeYQkzFNcn6P2in3T6+cbR6O1o0Fjx6X/NTP84tCha9QsEfKPAUDQZzI7vx2CsNQ0yIb4yjz4DF5wuxQ3z1jiidlr0tMPBflC6ut9sPnBN4EJXImqs8E60Phs+82pv1EpS1ZwNRXikOKq2WpQWeS2E+kje7w8D/fUUoFOgwyAqvT1Jpx+WNCvaUn7TdJnKYCUYhWA1WBwXM4pAq4Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e1bTBcaPvxP46ueOi0mzMYbIMIjhLHfi8JghbIzskr0=;
 b=boJppddGIDM8nL9PqW23Q3XqVM3/+Gdd6DjSMLp7fR1VrcyUBAvPEMsNh4VOIAF3PtWLEIaWfqN2KKUlmrTupklwPiXUGEpM+SedHcj7R89nzx5A62voaeC5vDaopD4FJAsHRqwLqUbEBvkmny3Sn8aGcJ91Qy2RvX03FIbJHKFplm3rs5o8Utxqog75IRhSBDKt6YPRVlUWsY9sOnNINfAHR2sPGK0+U1JTnQyr6rm3npkRbP/eemg4+veqT+Ok54gAWnhTobL5kyt3gj8hXfO6K4PTp/6iXCeRZ9L47RRPf3X7ofxWlIGc9gd5frSU7UK8iywpXxbeqtN2rM+HRA==
Received: from BY5PR12MB4116.namprd12.prod.outlook.com (2603:10b6:a03:210::13)
 by DS0PR12MB9399.namprd12.prod.outlook.com (2603:10b6:8:1b8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Thu, 2 Oct
 2025 21:52:30 +0000
Received: from BY5PR12MB4116.namprd12.prod.outlook.com
 ([fe80::81b6:1af8:921b:3fb4]) by BY5PR12MB4116.namprd12.prod.outlook.com
 ([fe80::81b6:1af8:921b:3fb4%4]) with mapi id 15.20.9160.017; Thu, 2 Oct 2025
 21:52:30 +0000
Message-ID: <5467d9cc-54c3-415c-9ddd-a1ff1026f29e@nvidia.com>
Date: Thu, 2 Oct 2025 14:51:33 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [linux-next:master 13069/13300] error[E0425]: cannot find value
 `VM_MERGEABLE` in crate `bindings`
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, Jakub Acs <acsjakub@amazon.de>,
 llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 Linux Memory Management List <linux-mm@kvack.org>,
 rust-for-linux@vger.kernel.org
References: <202510030449.VfSaAjvd-lkp@intel.com>
 <20251002141925.ab86656b1d50f6e27f216209@linux-foundation.org>
 <CANiq72kOhRdGtQe2UVYmDLdbw6VNkiMtdFzkQizsfQV0gLY1Hg@mail.gmail.com>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <CANiq72kOhRdGtQe2UVYmDLdbw6VNkiMtdFzkQizsfQV0gLY1Hg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0208.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::33) To BY5PR12MB4116.namprd12.prod.outlook.com
 (2603:10b6:a03:210::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR12MB4116:EE_|DS0PR12MB9399:EE_
X-MS-Office365-Filtering-Correlation-Id: ad5d6abd-2f52-4968-8f73-08de01fdfc05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZXh5cWVBUm1rWkxvK0NkR3JjWEtRRXVlcU1FTDBTd3c0UjU0ZlR6ZGc1M3Y4?=
 =?utf-8?B?K2FGYnFhT0JLL2YrMkZYL09iRzg0VDUybFN3dmtsUGRlY0lhOGE1YWxKMjVr?=
 =?utf-8?B?K1VaWCt5RnorNXJzczVSMFpRRVBYaHF2UmJneklMbUJlRG54RjB5d0pQT2dw?=
 =?utf-8?B?dXY4QkFCSnZ0UEtDZTA3V1N6ZXJhd3RENTJReURYYXVINElKaHVsL0FTWFBq?=
 =?utf-8?B?aUtGWlMvbHJsVUZjMkRacXVmRE5OV3d0NmdZczJwWnFBUVYzblRLc0hvM1FC?=
 =?utf-8?B?RTlLQkRkZG5INGxSQUFTK3pqdkkrc1NNTmlwTUdFWTNrKytQUm5aU0Fpbk4z?=
 =?utf-8?B?VGpGbTBLQ0hPVWQzRm0yMnVFeEZEVk9jQmtsaVcwT3FiN3hyQktXdjMxZWdK?=
 =?utf-8?B?TlpTZldzallWM0xlRDN4azIxSDdKMTJkTzRJYVp5dzN6cWFOYlh2ODFEWWZX?=
 =?utf-8?B?KzRCbmdTR2llQkVTQksrS2tVeFNYc2FPSzZOVDRsaE9sd1FXUHhBNHVtSnhX?=
 =?utf-8?B?dFQ5WWd4M2Z2cjI0ajNXY05kZWJWZlZ3dit6Sm9hUlM4Sk5IaXdPU0VvUHVw?=
 =?utf-8?B?TUdKekZSZUZ4NzlHZDVMaGxLNHhZVXE5SlE0M2ZlMHJ3bi9aYkdNZmI2UUxt?=
 =?utf-8?B?UDg5SFd0VHVKSkY0b1ZOSnFPS3pvYWFIVzdMUW4vNGdSOHdTKzM2ZzJhVklm?=
 =?utf-8?B?RXQxbHIyVzI0MmZmOHAwa0orbDh6cnlLTjVrdXJ2NkxIMVlISXJVUENIaHJH?=
 =?utf-8?B?NzVzZnJQbEh2eEVsM3JxYTNhVndodUlXWEZVMzVYZ1AvTW9XdGpCRHprWmNt?=
 =?utf-8?B?cVEzaU11aVpQWjdBdUFNRm1ORzRzbzNqR2R4NXBTZzN4T3ZFRGhqeU9lWUdN?=
 =?utf-8?B?QWVPeHFaU0FRUlFuaUlNZkN4L29idmdld1g4UWxsUnFBdkFpMDdvYlFrOWN3?=
 =?utf-8?B?Wk1NU2U2anVqYy9HYnhiYUhpTWNTV3Y0SnhqTUlOYzdFbFQ0aHlCb0ZyakRl?=
 =?utf-8?B?cEF6TEZ1N0xad3Y5YW1SZG1VSmgvVXR1KzdmK3pTT2YrZGRDOVhTQWJibW1W?=
 =?utf-8?B?N0tuN1grbXBTNkk3aG9Db1BvZ1NsMHRoV3RGc1F1dXhLVjFsYUowNnAzcFdI?=
 =?utf-8?B?NnZmcmRLRWxlc1VZZWV2eWJpT3FYNHNhWHFhOGV3a0NUYjg0UHowbC9MYURI?=
 =?utf-8?B?S2FTU20rbGU5N09FSzk3d3p4VncxYVM0bEJ3OE1xSzBLR2JQZ0JLRGJsc2J6?=
 =?utf-8?B?UHkvT2JHUDBjZzRzLzdkdGRaaDhHdGIxMFB0WWEwZ0dibk5id2J5MVI5KzNh?=
 =?utf-8?B?K0xQd2hkKytjRHNlM2d4dVUyOUJEZnAxOUhFeUsyb3NmK3lTTFdwQlVIVG50?=
 =?utf-8?B?MlYwc0gvcnV2TFZ5Wjh4ZmhTaG5HNFliSmJtV2xqTTREUzRIY0NhcWwwY0xh?=
 =?utf-8?B?QXpKOVN1SEwzZnEydFZUN0hJT0tDNWl4OHI2Qk02RUJEVCtGeHJZeWM0RlZB?=
 =?utf-8?B?RmQwMmJLUGhJMzc1YnZwc2FyYVNGS013YUhpQ3J3ekpROHdiYWhrNDNsYVgz?=
 =?utf-8?B?TnRzUTZwdnNwd3huWWxpOEtFMWZkWWIwTUhsZTNkQ1RQcHovYjZhcE5BMDhn?=
 =?utf-8?B?NnVlRU54YWppTDNETDFJWEdMVXBYUXFsZFd4L0hVNFFVNnFmMjd2K0RIaHpG?=
 =?utf-8?B?KzI3dHdwMUgwczNIbnM0Wk8vYjRUQXJQQ0YwRU9SZUU4STBhSjQxcCt1WTh5?=
 =?utf-8?B?Y2E2bU9lWjFvV3Q5Z1FlRHlBTWJGNzB5OVNCZWNVVkdvTHdtd3M2K1ZMSkJ5?=
 =?utf-8?B?WmVONG1mbC96Tk5oRThRakRoQkZZbXZMWnZmdXpFL3FHK3Y3d0tZMy9SWXZp?=
 =?utf-8?B?dGhkdG1TbGxUR2hSV0JoQnR3NUE5ZnRTNjlsSVVvd1VNUkw1SkxvMW5mOCtC?=
 =?utf-8?Q?evZt/FYtMTwEb83eFjzN/n0u5ALgHk4k?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4116.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z0pCS2xHMjFhRHF1TGpqZVdML1ZoWUxsbTdOZjRKUFRpRlhHWFpWZSszY3hj?=
 =?utf-8?B?MERTREo2Uit1NURkcVVQQzlaZ0hPQ09CTExnUlFpWHMvKzhLSmcwdU9FVys2?=
 =?utf-8?B?VGJYK1ExUmEwemYyU0J3ajNEMzNLZnY5Q21ZVjhicVMrRWhzOVRlbERLUUVh?=
 =?utf-8?B?dmNnQy8xUW9QL1h5TzRuMkhQRkNBNUN0NXlEVXR0VkRSMmhSSVFTN1lDZ2ZK?=
 =?utf-8?B?ajJKSjZZbGNYZWg3UFkya0pzelVpVGNKNk5lL0E5eExOQW53NzRQSnZuT2NO?=
 =?utf-8?B?dkp0N1hMR0VxdWRDUmQwRzVEN1VEa3lpYmF6VmZFUzViajlSOHFKYmpTblpZ?=
 =?utf-8?B?NTNuc3B2UTI4RE9Ya21EcHdCZWRlaEpld2lMVkYzWUszUEt2SDBrUllnQkli?=
 =?utf-8?B?VWZ1MXlGZEF6NUxmTWNKWDFMQXUrY1BrZlZVY3Y2TVU4clprRWl0RmtRcXNi?=
 =?utf-8?B?c2FtenJ3SDRSUDJuU0hEVi81WW5VbkszVGw1RFFLaThqczMwUlNjSTdpMlVN?=
 =?utf-8?B?d2VGeTFlUnd3anNPM3pHZmxGMTlNZU5xK2lGelZoL0MyRkx2UXJNYXdiQzNm?=
 =?utf-8?B?d2NKaUFuNU9XaER5OWhDa0VnTUoyQitKNmw5QnFMNUpWVnJPV0RRUkdsd2pk?=
 =?utf-8?B?R05Rc1BnNzhYdWEwVTJHVkQ2WUlVQ2tRVWg5MThDaEpucHFJYnZsY3lFcG5x?=
 =?utf-8?B?VlRsdkdSTEk5UDZ2UEJPaFMvMmhyYXo1YkVrZm1OdkNmcnFpUjFwQVAvQmEw?=
 =?utf-8?B?aW1wMVIwRmpFM3NVcFlJN1ZYVkdRS0hnbTBLOC84K2FTMmwwN2dFclFHeCtk?=
 =?utf-8?B?TkluVStpeCtTN3I0Z21Fd2xucVpqNVdFTFJSOVNHcmVDaURYSFUyZEFocEUy?=
 =?utf-8?B?RGY0ZDRBV2lVQ1U5MWZTNUlSU2xueWlhbWJKRHNGRHJrWlVnVTQ5L1ZLZ1BJ?=
 =?utf-8?B?SC9FUkRNUXBVSk9qck5nbTdsZTVyVnl3TWZibHlIV0F2ZFNvaGJMMkV2akYv?=
 =?utf-8?B?SmZzY2RoVHRHSXhBbjBQcXBTa00yb09weVZsQ1ZtOWtWcldkT1pPWGd6NXJK?=
 =?utf-8?B?LzBvNm44ZjhUVjh2RmJJTTE1WHJ6eUljWUFhRFFtVUszY1ZxWTFaSFY2UDk3?=
 =?utf-8?B?NlgrWHRZQ0pwM25EVWoyY3BtTHpzUmlrZHNoNzNZYVdxNTlsR1BDeGQxcTFL?=
 =?utf-8?B?STA4TW5GRjZHclNkUHhpZ0NFMXZ2MTNQd20wN3JENlczeTJYQlRRdlpEUnRm?=
 =?utf-8?B?KzRTQU9WWTVvWnlEeDJTSmhNdjdja0hITW94SW9pRDhTQTRIanNYV2hxM3dO?=
 =?utf-8?B?cjNFZHVzSmQzZzJtWXFOUTJBbkxhb2NsQkpmZVpDeURmNVlmZ2thRVlVYzQw?=
 =?utf-8?B?b2Jrb2VPd0xJZFl3WWZzUmpXMkJYYnRUT2kyYXo3d3NzdVhMRlJaM0dVSnQ1?=
 =?utf-8?B?MjVzelhSbURJTUhsUTlrb0lPTHExKy94N0JyRFE0akFqTHFsNTc5ZGE2SUhm?=
 =?utf-8?B?a3BJUjJDYllWajRXaFF3anhtSklWUFVqTE9Lb3RNOW56RFNYV0R4dVQxQWI4?=
 =?utf-8?B?QXJsTWZnYUJpTC9QMzZzUVBtTzZkS210dkZhV1h1Zmd1WklXTDZkSFdKNStJ?=
 =?utf-8?B?eVpjQm1UanRMVjhwVVYzTEwyUThKKzlMb1hsUVhPNzZBTXdlOW5NbEpMMDlJ?=
 =?utf-8?B?dzQxNXJUMGNnNTV4MFZ5Y2NZbCt2WU1YblN1V1AxSnBZV1NzRDZiMTB4V3JS?=
 =?utf-8?B?SkRHUXBUVGsxK3o0WC9iMGNkZjI2UjQ5cTVZSEIvZXZtQUpybHpGTW9VLzV1?=
 =?utf-8?B?NFd3dXpDK05maVh1aGszb2V5bEtwU3h1ZEZyczE2K2NFTlBtUWd3SDgxcXZ4?=
 =?utf-8?B?WnhNR2gwUFdzSDk0UHRVZG9Bdm1SOG1RQ2w5RzZmcG9LcXdwZVNGOGVGN0lN?=
 =?utf-8?B?YUJuZnNjUG1RYnZrOUhEeHdCOGEyME9HMXBPUlhoSGxPVS80ZjBKNk9hZTZl?=
 =?utf-8?B?M05TcnZkVm56eFFJTlZoeHFyTkI5dkJENVRxTVJ5WHFsMWtXK2ttdGhvemV6?=
 =?utf-8?B?TkpvUEdhNHVrcTJ1T1VoL3hFVXhYYWZaM0xlRjR4eEQzeTFJSG1UZ2NsSVQz?=
 =?utf-8?Q?7wmE+vA2QZisjYZME8pkNJmkU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad5d6abd-2f52-4968-8f73-08de01fdfc05
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4116.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2025 21:52:30.0916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KZ+7nbnydrOPhzawcojd5uOCrMjZ6hnrXKLufdWdZixZdHFza0uc2qLjwGAwqIJzraLg0UXknu/2EiQWn/WdZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9399
X-Rspamd-Queue-Id: 41353100002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: t4a4o5af5xi6hfy9g9h4fsggqcepo6zo
X-HE-Tag: 1759441953-479065
X-HE-Meta: U2FsdGVkX1/wW+oDgsH/36OlsMVC555Gr6T/wbPcDU2OkBgkoJ46oiSPLCNjVZ/t9TJVEi2ccq2SjSnMU1CKqyCdE+zFcQCbkhHyvPeBt0jCDRVh6ZCwz/zQupkwWRm15Y04FvMfLoGOQEx3PR9eifWsgKn1Pp/ynlVj6V/foJCq4NjfQdsjlUkZInKfZG+8c58MpfnHQ/DGemi+2wyQUYlPvrMB10Fm4pInzdzLb0OWb650z28MbnYsLohwTC52ZCTa5w9LURGFJrYTkmyhc/oGOn0jpHp6t5qkIz6T20+xxdee6qAX4LhPw3DaQeuYvRveYti/xI+GUJOXyboCDjKElfLk0Z4d36Hbs3ckiA0wwNkaMTkTZTiV4yWmtbXeN1eAzc3TMKe24CZNlQLcKVlRsBExkyqMxVw/6HB4PhtbeteXJSNzMVqg/D8AOgYUIWz2LvWNMGwe9gDEkeD+37dagDS2qFXfQRqma4aUlLpwdl+UGN8g5WWQby65sUzSE4OTG0Jnbx0Bfd5vfrBZFLgM5XoW1twUFmU4MAKPpwHqH95H9YkEoPhRtKTq9RiJycqLHT/Earqm3q5wWdnAID9KvmqsZ9iFH5pQfQ4rWVIcsLceRpR3sQpbyRLKkz1JcjFWFwzNw+BIGz3Fec5ndutWfB8e2TTggO6y5RuIwFhHeCvzfpEn6PsOm0QW8xzitRIqUGcHv6zkj8sDXUzoaxj7c4/Q+xUhBJ1FjURWPdJAoeYZtUvxWaX+Q5JVfJOdxelZeOnx0druWGM96KgJit34zZPgZ5g8oAwwPthhpcBW1b5VsuD+OA5DLXLUSgkS0R/NBUCPkYbqB9Os6cMgOf2nP40P+JClciwnd0rukLApxBSnyhtdHVmBAXoWnoEDrq/h4fyurxVZX0wpAVFF9w1aYzDX6+OH7x4tJ/UaL4kvOZltgFUlSEEIPZUNOMExCZ5+3FBfm4Kc34al/9B
 H9FF9uXL
 DrCosXQrsfcs4dZCdyJ3bEslUyooS+6LQslsUmDfXx2ezgiUsUy087V2nOZjJDXipsXX3aklQ+CLHfcD18YR+yBgime1C4YUUMFgk2XbL2JFAB7lxzpehS/vwPafUANeUM+ePefjpzpOjfMbv8x3hScUzm2thhatQxTUmHDscshl3gIs4VK+LdhQnqdjZ/4rLeRyoFBdk4af9i8mkAoeaRFOL5317IKm6WUlPsnhZRehp7EhA2p8JChj2mXu8gMMHb7raxBg1RaMoC7HXCSYLi1mI19maDnocKqMx/hLZo2ZrrgCPrEQv/J0DDzDO1MnB/n25u1+IxoR1RdSSaFRk7IwNeT0UJNtYW5cJCbZ9oyIk+UpIscjmaDhbNcCRnk2hvppZjT22GJoYOBC1PgaK0bIhmGJlnYuMuDo1yAwG/iK7l4efFVJIiPJ1NWj19lnMRKGvB7UCZqlimS0FExP9p+991j/7gANDl/EHuDHw+qLr7o5LMk/ZxGN9p8VvUfcGdodRvC883dlCkYUEcSbHxUUnaDigcFDXBhiQ8irdyNDDx0hs5tvzwdZ5xmzZqzVYNUHKmPmE7N7QlVFdn8wfSZAR4jLD0j7Mu2KnIyT16SyhV3A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/2/25 2:42 PM, Miguel Ojeda wrote:
> On Thu, Oct 2, 2025 at 11:19 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>> No idea.  Let me cc rust-for-linux.
>>
>> It's a one-line patch:
>>
>> --- a/include/linux/mm.h~mm-ksm-fix-flag-dropping-behavior-in-ksm_madvise
>> +++ a/include/linux/mm.h
>> @@ -296,7 +296,7 @@ extern unsigned int kobjsize(const void
>>  #define VM_MIXEDMAP    0x10000000      /* Can contain "struct page" and pure PFN pages */
>>  #define VM_HUGEPAGE    0x20000000      /* MADV_HUGEPAGE marked this vma */
>>  #define VM_NOHUGEPAGE  0x40000000      /* MADV_NOHUGEPAGE marked this vma */
>> -#define VM_MERGEABLE   0x80000000      /* KSM may merge identical pages */
>> +#define VM_MERGEABLE   BIT(31)         /* KSM may merge identical pages */
>>
>>  #ifdef CONFIG_ARCH_USES_HIGH_VMA_FLAGS
>>  #define VM_HIGH_ARCH_BIT_0     32      /* bit only usable on 64-bit architectures */
> 
> Yeah, non-trivial macros confuse `bindgen`.
> 
> For the moment, you can do e.g. [1].
> 
> Other times, we have changed `#define`s into `enum`s -- that also works.

It seems like bindgen's --clang-macro-fallback argument can avoid the
entire class of problems, is there some reason Rust for Linux has avoided
that option?

Although, in order to make it work with fixdep, additional somewhat complex
build system changes are required. I've got it to almost work locally just
now... :)

thanks,
John Hubbard

> 
> I hope that helps.
> 
> Cheers,
> Miguel
> 
> [1]
> 
> diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
> index 5128e2f12038..918f4c74067b 100644
> --- a/rust/bindings/bindings_helper.h
> +++ b/rust/bindings/bindings_helper.h
> @@ -106,3 +106,5 @@ const xa_mark_t RUST_CONST_HELPER_XA_PRESENT = XA_PRESENT;
> 
>  const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC = XA_FLAGS_ALLOC;
>  const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC1 = XA_FLAGS_ALLOC1;
> +
> +const vm_flags_t RUST_CONST_HELPER_VM_MERGEABLE = VM_MERGEABLE;
> 



