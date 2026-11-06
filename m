Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D35E606A33D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 13:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=AwPcqUUP
Received: by kanga.kvack.org (Postfix)
	id 6ECF26B05C6; Fri,  6 Nov 2026 08:23:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69D906B05C7; Fri,  6 Nov 2026 08:23:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A43D6B05C8; Fri,  6 Nov 2026 08:23:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2EA936B05C6
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:23:57 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 97471C0D7C
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:23:56 +0000 (UTC)
X-FDA: 85404762072.25.700BAFA
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011043.outbound.protection.outlook.com [40.93.194.43])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9AF7AC0008
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:23:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=AwPcqUUP;
	spf=pass (imf10.hostedemail.com: domain of Christian.Koenig@amd.com designates 40.93.194.43 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793971433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fOmaNonFZFAaWHDxBB2Vj3hDQfjhHvYYDThqbDxY020=;
	b=GEX8AAg/ed1OR7DyuyllIXJumAAER3elDd5FPDFKrAfQLwBKM8VwL6gJ/QwnKVpwGLv7gN
	DcBp9Cg4lR8uBEmIk4JzR7NK9bMZCtcgnyyNRH+Q3YxTT+PRRCaMZNCoYIqCE4Y5ko2Wkv
	Hr1jC8KpLt0XmaC8FJoSDdg9YpnlF90=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793971433;
	b=HPIgAZyIw5aXX+Ndw1y2B4m0ydfO1cgmNSfe0htRsbblT+0kcmXW8/dhQKHBBw2XtQa97J
	TmJqBJfZ67yY2WtHODBCgK/aLASA6n4yME+nB6gGEQYia4wMUwfF7H6wyZNoxxBztfTQq7
	ST2UOdujnkTAQidX9IkXNPq7/oTN9aY=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=AwPcqUUP;
	spf=pass (imf10.hostedemail.com: domain of Christian.Koenig@amd.com designates 40.93.194.43 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kWMIi/hU9ezwW87sGioNr6QM7bmy0JI6cQhqZ5D3QWQOzzbe0efQFVFShmyHl/We3yFy9MguV1AlDvTk5dksXW+ENh2j5eK4OiBgP3XuH2aBnfL/gTmdzsqqlEAOEcUTBjsKhoLLSrdq5tjJlnNDTcfQt5Ct10SLkpBsaOliy/C2mOdUKpNrMX20Y2hy9z+Z+zz9UACtIOWLB1t3AfOWTYj3LAEWFBoTImex7faRzH66ERdcHLBWjT/+KNAcnKXGifkfWSgMmjK8nqj9AggGqzslYCLOf89XNSrCJP4fB1W88sG2UR8kcBH3EEocrjM9z0I6iMbrUIcg2gx8knRFPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fOmaNonFZFAaWHDxBB2Vj3hDQfjhHvYYDThqbDxY020=;
 b=DgAtjcJOECbF6jaGLwurHAJhZa+dmgLIo/x0jVms5XPxQEv6QbTnXjzE42jWPF/kRbqqTQnZ5XHK61YOZDVc+HmM43npsYhmRBjr8s3co2lsnjKjK+zf7lfgkNDpqLO1BtrAgLkVgDLluiuFjkX80y8laJQiPVKvHmWd4+c4rbu1jPye2T/i1GE3SX4a6wqU8A83A1NwrZc6b2tSbyu3MZb/DjEuDFYWBnmvsoAZQfTKaE74VDojAeUkhL+vf6LHNOaytxUL5DmmJ5jxzx0eCEjhAIFJ1xmb4rl5GLNwoL8BTXAapFbCeP7otbvDsSFylenTaUuRvNhVaJBjkUtgVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fOmaNonFZFAaWHDxBB2Vj3hDQfjhHvYYDThqbDxY020=;
 b=AwPcqUUPGt8QeerqNG+fQJcUxT7oEb5Wgaeut5c6GpvYBAbnPY/oLxP0NA9oAZk2A9gXEO4Y9tZmq+0F4OzsCaLpjKKeTMBGFVq3UTIMnQhA6b2t91wR3G/qJTDoqHxUi4/bazLykj0oz59BxxBHWnYUQYpp3z+x25VCBOKnk3U=
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by SA1PR12MB7411.namprd12.prod.outlook.com (2603:10b6:806:2b1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Fri, 6 Nov
 2026 13:23:49 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0592.009; Fri, 6 Nov 2026
 13:23:48 +0000
Message-ID: <1e18fcfd-785d-43cc-afd6-d181bf8305eb@amd.com>
Date: Fri, 6 Nov 2026 14:23:37 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] dma-buf/udmabuf: account the page array metadata to
 memcg
To: Tao Cui <cui.tao@linux.dev>, akpm@linux-foundation.org,
 dgilbert@interlog.com, mkp@kernel.org, loberman@redhat.com,
 jmeneghi@redhat.com, kraxel@redhat.com, vivek.kasireddy@intel.com,
 mst@redhat.com, jasowangio@gmail.com, eperezma@redhat.com,
 stefanha@redhat.com, sgarzare@redhat.com, rostedt@goodmis.org,
 vdonnefort@google.com, mhiramat@kernel.org, jgg@ziepe.ca,
 kevin.tian@intel.com, axboe@kernel.dk, "T.J. Mercier" <tjmercier@google.com>
Cc: linux-mm@kvack.org, James.Bottomley@HansenPartnership.com,
 sumit.semwal@linaro.org, phasta@kernel.org, joro@8bytes.org,
 will@kernel.org, linux-scsi@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
 linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, linux-trace-kernel@vger.kernel.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, bobbyeshleman@meta.com,
 mathieu.desnoyers@efficios.com, robin.murphy@arm.com, mason@kernel.org,
 aesteve@redhat.com, tjmercier@google.com, harry@kernel.org, vbabka@suse.cz,
 cuitao@kylinos.cn
References: <20261106131829.3228926-1-cui.tao@linux.dev>
 <20261106131829.3228926-3-cui.tao@linux.dev>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20261106131829.3228926-3-cui.tao@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAP220CA0018.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::23) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|SA1PR12MB7411:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fb6e644-f33c-4419-fa35-08df3c093106
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|22082099003|56012099006|18002099003|261026140227099003|921020|261021123027099003|261028144727099003|261021121427099003|261022105027099003|261009223027099003|261022075727099003|261026121527099003|11063799006|4143699003|10067099003|261102123227099003;
X-Microsoft-Antispam-Message-Info:
	yVehWQxb23fNlY6cZG25ymaM88tPsb0efFJ9cDoqVjMa1yq6YQlC3DHWB5GcV1dfNKuJsEZOUZwoRMqfdNT0yjZc4WgoA8w6dJGqxcYtpSFEWZv/a6leh3fJiFrVULWVxELiV0pEOCEm/7pgyf6R7I8cg+2wIvBwd9kK0H0Un+nDMLLRT1fc1C443DobJYnqW9Syv9toX4Wr4R8hB/W21Yj/zUi+Enf2Ao0QNb7K2wpdd2osMTBPwzjZHe5vIGVWYoN81Il3178JEx7U0ZqTPE4dsYVr00VSwnUl3yx/Z6jqvSfQ1Ap62w9VdN7WI9cWHaqbJodLbRTpV1tD6+FQ78MR+jyLJolacV7ZVv2HWdRLDrPBmRTqO5Gg0a8cRc5o9fDwyLf3qD11kJbUdcEtFHbFnVQZ0iDIOPyoXTBfcETF/CB8eLJhWnMeqdvknJTTjXOEyv4jYvCgU0ols+Hxai1VYchrYrnIFv3qoj9MjjWwMnp4jjTL9bZvuMqDvokxmViuajtQ11eAu8TI96oBz2eH5YQ40Ag1rL9wzK7wt/bp4dQ/KoA3oD+NfKRakGLHS1Ir74MuHjjfofrm3oGOE3d5LQoUyWumTcdCpUMQ3lXxBErpfvntHHdkLQvU0QMvGGPFI/L+FvZETGK9fd1FXGi6N4qjtbukvWx3dHIus2GCCW8fXE1x90zU2IbZprDTxZ4yt2FdiofLeFmJjDtVfQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(22082099003)(56012099006)(18002099003)(261026140227099003)(921020)(261021123027099003)(261028144727099003)(261021121427099003)(261022105027099003)(261009223027099003)(261022075727099003)(261026121527099003)(11063799006)(4143699003)(10067099003)(261102123227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YzhZa0U0STZpYXhyM29HWnQwYjAzdmpodG9OcXpYK1QzWnppVDAyMk1ENmkw?=
 =?utf-8?B?RjJ3L1dRVFcxTjRHekdONkdrY1AvdDVickFQU3Bac3BQV3NucmFLcklrZ0hj?=
 =?utf-8?B?NHF5VjhaRGJCalRGbWdQaExjZEUzSnozajJabUhBdmNIUTVRWVk3YmNoWXRz?=
 =?utf-8?B?TG91S1EyOTd3M0p2WCt1QlE0alhNei9TM2RuNjNRQUNBcVBwVUVZd2NoSFBs?=
 =?utf-8?B?SjNKV0NpSFU2QWNGamc2TUplRjh3T3UxOWIxbU4yZUxSK05iOFhtODl6bUtO?=
 =?utf-8?B?L2hBL3RZa1hCOHZvWlRUNnNvejBOOVpvc09oTUlhKzNJUGdhNWsxRnBkM1dI?=
 =?utf-8?B?V1lqRFFYa29MbVcwR1Z4ell6WU1LZzdmak1wcTJISmpFVmpSSUhyNlhMM1Fs?=
 =?utf-8?B?UDFBcFZBa1BXemE1elJWelVyNUJYc0FMVWtkRmh5cDByTEl1ZEUzUldiL0x2?=
 =?utf-8?B?am5hYmU2NmRRbzlJTTF6UTVReU1NZGZFd1pCL2hWOHdpaUs0bXV3RVl4QVNa?=
 =?utf-8?B?MUpDTDBqeUdTQldhOGFxbkRrWGVxTXVKSmlVSS9GRkJUcllqaDh2K3pDWkZZ?=
 =?utf-8?B?MTQwQTJIcVdha21sdkJUVnZpR0NLdWwxdDBHRkk0ZmpJN3g2c3laQlF2bmM0?=
 =?utf-8?B?S2dDWitxM2QydlV1WTBxYUx1TTVUOVFZcnUrYkluUjFYSEF2K2xXR05MUzhJ?=
 =?utf-8?B?emdPZ1l2dW05MTZkU21DR05DNko2c2taOVJ1OE1hSm4yTE00dUlsWGRtbTgx?=
 =?utf-8?B?MXAvTzVYeHFCeUM2eDFSTUF4SDhWWXdwT3FjUUZvbDRIZWtEUnozSkxha3Z5?=
 =?utf-8?B?SjZ0UGljc2NidjFLV1ZpVDU4b1ZkNUJpK0RubVE1Z3BqMks4V0VIZm1RZll4?=
 =?utf-8?B?MXRyQ0taWmIwZzdxK2ZPbVJPNnpDYktDL290RWkxaVBzcjVZU2FVRitvRmE4?=
 =?utf-8?B?cWRZYWtZdWhRa1BRdk5kVUlEUUk3Wmhla0FwMFBkMHNSdHdabjNNZHdtVzhY?=
 =?utf-8?B?OVhVQkZkdUFrRk9OZFBnTXN3eDNjUWdlZnpMRnFzR3RYVGN4OFhEMUtPcW9m?=
 =?utf-8?B?SUpNd1B5aWxIM1VOZzVkamNmbTlvdFlTQmhxZ3JFQWpuN21DOUhxOXZxZUpI?=
 =?utf-8?B?Qk5Ia0x2WFFIMHUyYVFLSDB3SjBaOExnbkZrenBkUDBDZk42ZHdLalk5dUZo?=
 =?utf-8?B?UHI5TnBwT1RMY1JCQUJjRU16bm4yTG12N0hpQmNZbGN2eTdSYlFKV2hGSE9F?=
 =?utf-8?B?OGsrc0lTK2pjSkZqeXF3U1NjYy9CWERUNlk4N0p5RnkraC9BN3hKdnAyTnVZ?=
 =?utf-8?B?T0FlVksyendkei9kYjFjdE9Nbkt6RjZnZ0l2bEZ6RVhsT05rMWRLbExPU3Ir?=
 =?utf-8?B?dGppZkkvaG1yUXVuRUFHU09YSEJreTFxc0tDM2ZHd1pPcWh0Q2x1Z0pwN01V?=
 =?utf-8?B?bll1VCtxSnQ1eVJSdmlOSXk3aTFPV0drTXpYY2pSYktZZEFjLzVpNm9XNTky?=
 =?utf-8?B?eXZQNmJwdURjS0tLR1ZvZTF5elFFS3V5K3doaE81dm5WTVhVMGVVUmxuUFhH?=
 =?utf-8?B?NlJTOWtTNW9CSXF1VHFTQ1hCYVRWRklmVGtLL2IzVzM2cTFqSTFUYWJpVTdp?=
 =?utf-8?B?a3RXUksrOE8vRktYbWVoTFVKZUZOd2hNeXdlZ3ZZdzlaMU5sVmlZa1FjTFBJ?=
 =?utf-8?B?bmF1UENMZTFmN3hkaEhHMmFRQ1phdldYampTT3N3S1NaVXp6RnM3RmN5S2xr?=
 =?utf-8?B?TXBjcEF5STB6clcwMFA0N3dnT1UyMjZJTmhySlR3WjNtdlNvVG04MFpVV3li?=
 =?utf-8?B?bmQwVWF5a3hSZzYwL0pyaFlBdnFxaDBPdi9DMFBwQkRKS3diRGsvMTRaWnhK?=
 =?utf-8?B?eUdYUzIvMHNINHc5eE0rM3NJQTAvZGJVUDBJR282WHlVYnljZ3czbE9PNGhR?=
 =?utf-8?B?Z1pDTFZzaUJyNWw5S0N3TGI2cnlhNFF4LzJzbXJDZzdWSWYrYS9Mb0p2K3pi?=
 =?utf-8?B?bWRuQ29VRHJoU3YxT0JseTRPU3lvbEFZYVVyR3cyTjBMNlN6bFBPM2VhK1lJ?=
 =?utf-8?B?M0NKY3c1MzZWMnNna3RrVTlYUVFFUjU3YXgzRkFpK0UvQ3BFL0FmbnE3YVJo?=
 =?utf-8?B?RVh4M21aUnNRN29lT1MxbTZqbDNpOWJTR1Vhelp5Q0V1S0E3SktyK0tCY2JX?=
 =?utf-8?B?V1NsVEQzSkx5dTB6VzBZbmJ6Z0lIZWREUG5OVUFYeVFuYkdWejVHa09TNTU1?=
 =?utf-8?B?VGRydUVHTEVpOFU1MVhQR2I3d2k0b0YxdkV3S2RyK0VUSGw2ZXpNeUY5QmFQ?=
 =?utf-8?Q?dorWEJ7Yg/YeCR+hXU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fb6e644-f33c-4419-fa35-08df3c093106
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2026 13:23:48.7204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HGqaZF9TFD5MGfLNY2M2aF8bGqm4/NCZncx/jRFR5z/Hbo8SG4BB1DfR00KRl979
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7411
X-Stat-Signature: qa9toyk61q7u7rjfbmhmdx9pckjc3gb6
X-Rspamd-Queue-Id: 9AF7AC0008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793971433-353952
X-HE-Meta: U2FsdGVkX19XCVhpx5T8n/p/EDr/pLqgwjvElcoKBGaVXVhZG0ajHsLD5X2xmGjj2o/xP35bE1lp0sal97PazdJHZghPp637GNyDR1t5yUic7mGgjjWmzToeRDU4m1d2Lxult64O+a5Ee35QbhoQLrlVe2lU4y/6JjjuoeXey93mUyfG1t4WoxhJMTpNvyUBoh+OyWlZ0Cy5689Xtyi9IY6oeWxmmYVi1jO6I/XzSFl4EGK0oYmfnZbHwM1PRVfrHytUxRCW6wUCX7qCnb4PbHUE1saDWDeclxqEMJNoYfUnZGeCA1tKUrlWcMS0l63GE54koPB+nJ2XY9wI0UL+hUXWnAl2htfX+gIwJhYCXlbV2n6LKAjoDUvGpw78l8D4B82msXczCwtI2gqTKU5BqcByrDXUkmPKa8fJ6K1NYGsoceRlG/WY1wBzLWfPsaNuYrRuBYraXEjCpOST7T+wxxNS8ziolStk+0mfCfA0pTeRLTxfEYp4LB2y128bMWjPGE0iqa/hUeQXyv/RVsdiKrnX2w+mYNX61iHd5nIQLibKrOyZGukyuW5au7LALsubXHeI4lxgfN2LYsLeGEFJMsBYCcNol/cnPQzw1Da40dgqCQDmg+KY2ep80PT+L6Z4zTKW4uyuCEvZRgtjRIk+hTE0ZMJzbtaCKzqEWfO9hy3NgNJWkLU+IMNzNxW11nhLib8kxBXv7fP3ZAlCkKUPj7yCwQzLj/EfS8TFECDs7tXLcss2aBDc2Sluj15zul5W/m7reR1Wbfch9Q70zl1NfP7Bx7P5e8FrgXf3dR1JaKirC6N6EzvMgh6xieolSbPFg7sxKEIIoOuwIU2LrnLhz++uBbCeKe+zmjVEkdCGHOG7ASV97AbD8eQ1qmeU8K2NfciKRQY6/vYtoa9060UAm4XA/3ylDX3J/PsV9vgCMLS7hH3ZNIUcs7y32cYotH51qHdN/IyaATOItGvZzgm
 qgbpMviq
 e137X5POUHuPh3UpkCPVhXHSc4iBF3X/sgAGRqY5uuIKce/qoCRkvkjx+83N0V2ZPF8I+FIE+Nba+Xk4160iHP8Ygvf6PhWAY/nHdNBx3z2XfWk0HOF7DaKQg4D2eDzzaqNwKEHEl7FeluklNmXVRrlmXSB15NthX4Vemvzp4VcQVOFexHfe9j8FRRPaHWeCy3bhJtkCh7dJ70YL/SZb4AqyqxoPvZOix6fj9DNY1rTTpDdQ5YOtrD9VmnCJr0Gg7+dCpvOnmYjnVEoap8ebMJ0HisytQf/59B+NNGmXAIDNWF0HkfvOpatrVl6WnYaIrnMF5ny3IYLsuiHRok8dffJKcmTXBisOymFHg/SSQ9QdnxiwuuzgRt5aZ3TsPt7MFKSbBw1lUajXXWBD7nqHy9P97GqvetdOyJJN/KZmEXaCsmuFsNQ5hcpfHI1or1G1lA4Qx2U/H9uj29gPgQ4Y4QfgASt50H/8xEX65l8mtp+8+6065M/ldGYthf/OpwEQ7ji8O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/6/26 14:18, Tao Cui wrote:
> From: Tao Cui <cuitao@kylinos.cn>
> 
> udmabuf pins the pages of a memfd and hands them out as a dma-buf.  The
> data pages keep the accounting of the memfd they were instantiated in,
> but the bookkeeping around them does not: the page pointer array and
> the pinned_folios array, both sized by the buffer page count, plus the
> transient folios array sized by the memfd folio count, are plain
> GFP_KERNEL.  A 1GB buffer costs about 4MB of uncharged SUnreclaim
> memory, and size_limit_mb defaults to INT_MAX.
> 
> Charge the three kvmalloc allocations so the creator pays for the
> metadata it induces.  The system heap in the same subsystem already
> accounts its buffer allocation; the data pages here stay with the
> memfd.

T.J. needs to take a look here, but I fear that this might break uAPI.

A lot of the DMA-buf resources are intentionally not charged against memcg.

Regards,
Christian.

> 
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> ---
>  drivers/dma-buf/udmabuf.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
> index df6dd0046242..40182c82df6b 100644
> --- a/drivers/dma-buf/udmabuf.c
> +++ b/drivers/dma-buf/udmabuf.c
> @@ -190,11 +190,12 @@ static void unpin_all_folios(struct udmabuf *ubuf)
> 
>  static __always_inline int init_udmabuf(struct udmabuf *ubuf, pgoff_t pgcnt)
>  {
> -       ubuf->pages = kvmalloc_objs(*ubuf->pages, pgcnt);
> +       ubuf->pages = kvmalloc_objs(*ubuf->pages, pgcnt, GFP_KERNEL_ACCOUNT);
>         if (!ubuf->pages)
>                 return -ENOMEM;
> 
> -       ubuf->pinned_folios = kvmalloc_objs(*ubuf->pinned_folios, pgcnt);
> +       ubuf->pinned_folios = kvmalloc_objs(*ubuf->pinned_folios, pgcnt,
> +                                           GFP_KERNEL_ACCOUNT);
>         if (!ubuf->pinned_folios)
>                 return -ENOMEM;
> 
> @@ -387,7 +388,7 @@ static long udmabuf_create(struct miscdevice *device,
>         if (ret)
>                 goto err;
> 
> -       folios = kvmalloc_objs(*folios, max_nr_folios);
> +       folios = kvmalloc_objs(*folios, max_nr_folios, GFP_KERNEL_ACCOUNT);
>         if (!folios) {
>                 ret = -ENOMEM;
>                 goto err;
> --
> 2.43.0
> 


