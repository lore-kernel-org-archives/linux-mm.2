Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C4E4D1D483
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 19:46:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E59926B0088; Thu,  8 Jan 2026 14:46:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDD8D6B0089; Thu,  8 Jan 2026 14:46:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C94056B0092; Thu,  8 Jan 2026 14:46:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B338F6B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 14:46:15 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3B7ABC15DB
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 19:46:15 +0000 (UTC)
X-FDA: 84309827910.30.4C0A86B
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013021.outbound.protection.outlook.com [40.93.201.21])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1C4F340002
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 19:46:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=mwatL2s7;
	spf=pass (imf01.hostedemail.com: domain of Felix.Kuehling@amd.com designates 40.93.201.21 as permitted sender) smtp.mailfrom=Felix.Kuehling@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767901572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YxwGImQRPxL+Mb1cu1lTexsoyMd/BdGGPeJO9Fk61lM=;
	b=kPguWlqKXCyyfyhyV8KvZ8xoxghQUI3clcrs6ZtFcvfbi3Zd2jCrSjChvL/eUOw9B3kSqq
	LbFGDrkNU3qmdHJTfHTUFR2sVvZjijUSMvwG0R0pnTrcca0IunTbcG7Pj+1NMyndp0k/Qx
	a9S/VNz1zy/NSZt4114Cnqen60rGbmg=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=mwatL2s7;
	spf=pass (imf01.hostedemail.com: domain of Felix.Kuehling@amd.com designates 40.93.201.21 as permitted sender) smtp.mailfrom=Felix.Kuehling@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767901572; a=rsa-sha256;
	cv=pass;
	b=ulp+HaO/iDtqi4S0cq5q+HQaKloxUcQrWE95jiq06VhnZwDaxj2gW/H28Port9Uup8vTn+
	IjsS9issbG1IbQtErv3z+MK3RRlKiKSCN5c/nTbt6wPIZHT0IXvVRL7Hhxs0RooISwF4qa
	I9H27AHyhPerbKM7RSFiiGXQFDYfwRE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kgr3BC5zgGGHQgJ959hkgAXqgIA2aGZ2+3J/CfwJcUc3YOLMhITGyJIdMhb2jDjMxnlf/9vNM6/tmVwHo7tClj81P3WVP361MXspVNQwZaUbqSrdGzDwtfpCjd9oOZZTPzoBWp045ZKJmBlJKLjfpo7W3Ii40mf3bsBhnUUSVi/ImT8HRbr+kew/AQRseornytcl3aaxa+BG1TPZSVfkLVV3lMd+NtSUlbuCpa+j/gOj1HRRI1CxYbwUSRmGM2jnOZajr+0kdN4bMtVp9tJWyK5afDHrML6OWLVUShoCQkiGsUYjHSCY2EB4d/xhB6H9FUCHriFgftUUH2s/hdgIYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YxwGImQRPxL+Mb1cu1lTexsoyMd/BdGGPeJO9Fk61lM=;
 b=MmuJPSpu9oUUgS0ZVg/pthZZVHyVoYJimfn37UYUGGCzCmkqItsUVwQ7w5mcxXR48PVtxRf1OMSucPqmTKSr10XK5CpZpCatptDgztXlCsVIkeCnpiXbH/mySUs4qCgnMUvFdZhK/0GpEwNdCLcJ56jlDV9ucIy0c1Zhx/uM2biu0FXLFfrqcvna6C3ZCPCeH2nneag19SVbECqpOlnIpalDt+d/LNNOVb/2zfTaph0S/BjmeDvCtOQ5RUoqTmLV/QQo+47Sern1ZNYrWF23VAb5CVViPhqU9+aJQjpHpA4OYJpSywzCV+YFooFmU9xHYlyy2rJLtEOEfLfxUGmalw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YxwGImQRPxL+Mb1cu1lTexsoyMd/BdGGPeJO9Fk61lM=;
 b=mwatL2s7wB7mtjz0wY5dt3hpyKo1KciOGl9zTCyGwJqnKMGjp7Uh1v0rb9kIe48ykWbDy3OXdFewXWLSCjCyVJ2u1LABerCuXoR1tglOL77SqYHs0NuMDj3vfysNxPsb3PWcAQLjum9PMFThSmQlNt/cWktWQz55HtqIq0KrpPw=
Received: from BN9PR12MB5115.namprd12.prod.outlook.com (2603:10b6:408:118::14)
 by IA0PR12MB7628.namprd12.prod.outlook.com (2603:10b6:208:436::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.3; Thu, 8 Jan
 2026 19:46:09 +0000
Received: from BN9PR12MB5115.namprd12.prod.outlook.com
 ([fe80::9269:317f:e85:cf81]) by BN9PR12MB5115.namprd12.prod.outlook.com
 ([fe80::9269:317f:e85:cf81%7]) with mapi id 15.20.9499.003; Thu, 8 Jan 2026
 19:46:09 +0000
Message-ID: <64f0d21c-1217-4f84-b1ce-b65c1f5c2ef1@amd.com>
Date: Thu, 8 Jan 2026 14:46:06 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] drm/amdkfd: Add batch userptr allocation support
To: Honglei Huang <honglei1.huang@amd.com>, alexander.deucher@amd.com,
 christian.koenig@amd.com, Ray.Huang@amd.com
Cc: dmitry.osipenko@collabora.com, Xinhui.Pan@amd.com, airlied@gmail.com,
 daniel@ffwll.ch, amd-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, akpm@linux-foundation.org, honghuan@amd.com
References: <20260104072122.3045656-1-honglei1.huang@amd.com>
Content-Language: en-US
From: Felix Kuehling <felix.kuehling@amd.com>
Organization: AMD Inc.
In-Reply-To: <20260104072122.3045656-1-honglei1.huang@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: YQZPR01CA0105.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:83::22) To BN9PR12MB5115.namprd12.prod.outlook.com
 (2603:10b6:408:118::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5115:EE_|IA0PR12MB7628:EE_
X-MS-Office365-Filtering-Correlation-Id: 55be9875-de09-40bd-ab34-08de4eee91de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QWhCYU1CTXFHN1RFMkRjcGVkUWoza2hYWWYydXU5cW1QMXE3cndJUXRrWWxN?=
 =?utf-8?B?S2VWR0sxNHl5OG5TblpjOVg5RHN0ZzRCcDJ1dndEUmNNcW5JaElYb1RUZExQ?=
 =?utf-8?B?R2diRU4yc2NPVCs1K0xiNnpablVnSTZwSVpHMG9MejBCNFg0bmREd05JZ3Vt?=
 =?utf-8?B?SzkrSHZRTGs3Kzd4YW9DTUZPVEJiWG1PQTQwcldwTGUveEp1ZjViUitEaHhv?=
 =?utf-8?B?cnBYa0VZNy9tYlFkWnkzVTZhb0EwM1prSytPWkFrM3ZQcHlyT2R3dDRnb0pY?=
 =?utf-8?B?S3F0VHpkUlQ4U1VIbFc5eVRkemxNS2JJUEUwWjV6UTY3ZEpqOGdGcG16QWV6?=
 =?utf-8?B?VjQydS9DczFzTzhBWGRkcndWdEdNWXZoNFUwZ1FQSjV1RHh3V012eTFPZzRv?=
 =?utf-8?B?SUE3emdyaFFsd0M3YkRiRzNMNVB0MVVwNGRVNEVxZjI4dHVQOFMxYm93NFNx?=
 =?utf-8?B?NXJNZXlrZGh1K3RjZUJJTUd0TUR1Z2liTkkrTWloM2M3b3E5bENzTlcxOW5W?=
 =?utf-8?B?QlpsSUxTUlBUeE9vMStLbzdrN2E2ZGQ5TWxkZkpRUTY4YnUzdUhObTRtWElM?=
 =?utf-8?B?NkVFMmFNMVVpVDQ1SzRLK2x0ZjFScC9nazMzcys3Q0s1K2R4dzFacnViemNY?=
 =?utf-8?B?Uk1GMzJ2SGxGYjlrQjVmSDNkb1JYby93SXJMZUNMV3h3NUZKSnVBMG1xNzhj?=
 =?utf-8?B?SUlWZnR2cXdCMnRvOFJ4Z2pWUXBLUEdacmd4VXpDWWlVVWs2Z3Nvb2w0SFMz?=
 =?utf-8?B?SHA5UGN2UEVGajRpcjhxaVdOR1dNb3Q5Rlo5UzlGcjI3eEQveGhKUitYZmNS?=
 =?utf-8?B?OXovYmgxenZhdURIalY3WWdtOU9JaVZkcUFIN1IxWDNqRzg2eFJtQXdjZWta?=
 =?utf-8?B?Y2VJQ3RrdmhtM2xwbEt0dTB2V2lmamN5SlBkQkFSdG5YOUN4blZrZUwrQjRL?=
 =?utf-8?B?ZlowaG5RekpTVTZZYmplMDUrdFF1WS9tYmFLeFVwbnBhdGtXaTB0d3Z5UmFY?=
 =?utf-8?B?VStxZ1hqaHRiZ0NtZlU5TjRQZWpKQ1ExQU9PMHZqdHF1OWV1S2ZleWNyNXZh?=
 =?utf-8?B?bUF0bVAxYnVIdStNem5YT1luUzFxZVU1SGFTSThvRWxhZ1puc3duMDYvVm1o?=
 =?utf-8?B?MmpRY2lPNzlOR3dPQnJlViszekdPdlhpUW5FVUZ1UEZqbnlhZk1YRHp2MDVt?=
 =?utf-8?B?SkNzc2hMNFd1K0xuYWlaNERNZVRmeHBkaVZvaHN6WExPamhUUHg2b0plUFRS?=
 =?utf-8?B?M2VxcVJvcDFXQUVPUEhNUjNZd1pyMmw4eXJ6L0JoclNLLzcrcGxsZ0VpdStW?=
 =?utf-8?B?Zmw2QTI4YzZKcG5ZUXhIZVV3aXY2RG1RZTlGWFhOdE4wT0NoelNiS1dhK2NJ?=
 =?utf-8?B?aGhabktTUlVkbWV1UktOY1VURTRrWWdub0x3cEVVM0JtMC80aXRRZW1iK0lE?=
 =?utf-8?B?dVNKMDZuaHZYV2pONldBTFcrRVJmVUgxZEk0RlNoZDdMS2UvTk9WYktVS2pm?=
 =?utf-8?B?UENkV0ozWm1BeXVoZHMvaWVVWWRrc3NzcTlDRE5hVUVSU0d3bXM2TnVpaUNn?=
 =?utf-8?B?SG5CSCsrRmVFUDhzM1IydHV0SUJsTnZHTzFEZWt5bTVmQXRlRkEvSm9nRTRY?=
 =?utf-8?B?ZTJGNjA1QnBScngvNld3TXBabjY5OHZQRmw3cTJ0UnFaZnFtb2hlS0VLZUNh?=
 =?utf-8?B?Nk90YkFjdXBoeVFvYlRhUVJBZVNCS2U2RGpBRnl3WGl2enV3QlMrTTFJckxw?=
 =?utf-8?B?QlFQQjBrdjY0MFh6ZjlqNHlHMDJiYk83SzlhWTNHNEhsbjhwUjZqMWNYaEIv?=
 =?utf-8?B?bnZPKzMvZ0ZjWHVHdGY1eGpUTHFvMU1wWWFkZFhXdjA2VGxwZFhTQUlka3d4?=
 =?utf-8?B?cW15MkpQQTNtMzd0OE5zdkR3ZmVCMnJvNDA4eG1QOTMzN3hQMjNlRFp4UG1q?=
 =?utf-8?B?U0JzVlJvaEtUVWFCUklPK1E4L042UDZhYjRvWmhWNXFwdWlLekdUQzMwMkVM?=
 =?utf-8?B?aGZrMkRBWDJnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5115.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dHNkSFcwN2Iwa21ucThnR3NmQUU4ZUdOaUYzZHU5WWV6R0YyVmxaS1NlNDNh?=
 =?utf-8?B?SmRIY2FLRDlUdTRwODV5TytLUnBpU1Voa2FqWmNXRHR2cmU2UHlRN016WjVJ?=
 =?utf-8?B?RG42NTBkTVJXeXVGL1ZrRWJ2S1BaU0JzL2tZNCs2YWQ5ZitOTHRrdU94Z2V1?=
 =?utf-8?B?ZWdXbU5ua3paZ1JRR3hoN0V2MnB6bGJYL3JkODNlbjF2NW5iTXl0Z1lMeFRt?=
 =?utf-8?B?TjVTaDFkNWhlNkIzUGJWd2xQdGZHb0lqRmhmU3FWTlc3NXlrRmJOeFNUSTBJ?=
 =?utf-8?B?Yi9La0Q5TDBzb05XOFQ1Zk9ja3FRcFkyd3pJZDMrbkxDczFTSmNZa21MTFlv?=
 =?utf-8?B?YUFRN1hwTk9IRkFVNFNEZUo4Y0hFbll1bGw1aHlYTEk1NTNPYWNMVkhuSUZW?=
 =?utf-8?B?OE5OOXJyZHBIcmR3ZjNVbDhxYUdYMVhDNTNGWjA2SUhNQmVqcnF1a3c3a3Fi?=
 =?utf-8?B?Yk5Va08wVjBMajViZ2pPNkMyVGJaY0tzUFMwc3hqZEtkcGIzOUJpRHV3Q0NG?=
 =?utf-8?B?QmdMNWI4cFlwT3RIRlR1aGN0QVZKNVB0VXBIeEJYbi9nTDF4dzFWdURNaGtq?=
 =?utf-8?B?TWVkMFpvdWRWV2JVYmZkR2hKNS9Hb013ZUhBK2Y1ZGt3R3RKOVNrZ0lZVHlo?=
 =?utf-8?B?YTRJd1ZydnJXU1k4SjI3eXFuY292SG13ZUN5YWVIdUZwMjBVRmxwSEFRTjZi?=
 =?utf-8?B?Z3d1aTJKQjJ5RktDTnFUWnZkbGtOaTNLdWdTRjk1ZTU3bjlMTUVDeTdWbHJu?=
 =?utf-8?B?TkxSeVMvd2NEc2NGMkZsZDMvTE1PV1BCWkxEY1BGV2xXSllqVE1TUnVjdXFu?=
 =?utf-8?B?bDFBOVErU1FSbW15b3JuME80TlhMK0swR3BkKzNod0R2YlBjV0dPV1drTUdR?=
 =?utf-8?B?ekw5YXVmRDRkVytVcUtBQ0tlSm1wLzRJV3RVVE1aQlhwajZDNmNkSVNwVXJH?=
 =?utf-8?B?VUh0SG1VOWRHMURFRjM3TFdsZ3ZQcDdaU3VaRXJxL2h6SHpldVNOMzJnaDcy?=
 =?utf-8?B?V0FMblNPYTZ6N0hsQlI4Y3lxRDNXTFgyVWxiYXF1bzJWUTVWTDNEcFI4YWFJ?=
 =?utf-8?B?VExUZzJaMml6OXZKVURLS0p6Yno1MkI4U3NtS3VMY25RR3BuRC8wQ2JVZ3V4?=
 =?utf-8?B?ZlU1SFY2Q0ozRUpEQ3paUkhMZHNKV2hhY0RReUw5anV2dGw0TzZUcEVPeDA5?=
 =?utf-8?B?azM3TU1iMXlWa2YzZDhMYmVZb3dyZU9aUnNKcHlHbCtmL21HWGlJUEx4ZVJE?=
 =?utf-8?B?dHc0QkFjRHpIVXBySWVsdE10Q3dBdldBaGN5b1F6MlVKOVIwbFlMdmhmWjJw?=
 =?utf-8?B?MTFNeXRxWFJ6a2NrTndsVmhMTUZHR293NTRPa3l3RGdKL3FmMGZGY25paXpT?=
 =?utf-8?B?aHFXd1dTRUdQVjdMWGYrR012VGRHQXptekZZMlRJNEtwTGxoNndyeXpYeDQ5?=
 =?utf-8?B?V0ZCclY1SnEvNjVrM1BidkV2SGpXUUk4T3JMMzRzdGdDQVd0ZkdZbFkxZHZU?=
 =?utf-8?B?dWZvWlRHSzhiQ3FiWTJQb01tWGowQTU2UE5YZ1JIM0JwUVpuMlFDVm8ySytP?=
 =?utf-8?B?cHh2akxvQXNFY0ZoNmpUUnlGWVZvczNuSDVvbWUycndOeUdSOVh3ZEFvSjBB?=
 =?utf-8?B?SzAzTkNKdFNFMjgvK2lWd1J0bVlmeWRiM2ErNEIvSGJQSnljaUIzVThCdCt6?=
 =?utf-8?B?c01QYTBMWlI2QnBCSzlkcDNqaGROazlmSWZLMHFsRWZnQTU3TmhFbUcwY04x?=
 =?utf-8?B?azVpaEFhSmdtSFYvVUJ0ZmxscjNFaEwxZXN5MmRxMUhzVzRXU1FFaHZEZmti?=
 =?utf-8?B?OWR5MGExVHBwY3A5dGdrNEpIVWk3aUpWVENjSnhvN3RWVFhLVUNzelpadmN1?=
 =?utf-8?B?MmQ2MkxCUVdZRkNlWkp4bjdNakUxS1JYM2YyUWFZRWJrWmJvQ0lUTkVmM2dB?=
 =?utf-8?B?bnpsbkxwRUFCOEJ0dDVzcGxlSTBScm1pTHZnQVlrNmJMejVwQjZXOWtGQklY?=
 =?utf-8?B?eEV4bW1KakFCTnd4b2lhcVhmVlhHMnhTVC9Jb3RzQTljZ0V0THE0TFl6UnU0?=
 =?utf-8?B?c2Vad1RWQTBRbU9MV3ZQc3I2dzZoTFNCeTdNbDh1NEJYZkFNSTFVajJGWXdC?=
 =?utf-8?B?WjFSK0xOL2JXMERUQVhlUU5LKzU3L1hJWEFZbmFERjJub1V4RFBVL3p1WStF?=
 =?utf-8?B?NGpJaTYzZFF4Z2JrM1lEUEtJNTNuNFhHQjdEMStocGNxenhlZVIvZVcySFg1?=
 =?utf-8?B?RlIzaHRrd1RDWi9HUVVrYm5YTDd3ZXl4UnBkRXBvK0N1S0d1UFdZMG05K2FW?=
 =?utf-8?B?STVjSWpHTDZmQzhnclp1ZFFzdEVRUXhxUG1aYVRURThCR3FaNzlWUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55be9875-de09-40bd-ab34-08de4eee91de
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5115.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 19:46:09.1116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TNu3C3wS669kpaMROr1/M5hDFHNRACvMdOYuw9XdA3S56173NaMs64UHv9h/qJhdsBYOSvH58motx19dB17JkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7628
X-Rspamd-Queue-Id: 1C4F340002
X-Stat-Signature: gxj57beofgyf6uywwojuqc13cfeuaryc
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1767901571-492237
X-HE-Meta: U2FsdGVkX1+t5wPiQ3a+svI3v2BzwXz1WOYmtL/bAmzU+cvgbkviiCPMbvvC9XWeF92II82L4uAZIymLdhZcacFnLDONZ9JWFT/ZDSr55GCeLo1lacCf/H5kKHaN74ZAz3DN9Icy0xWFwer3bVFXnaVoAYtrJvIgLI7STZXLyahC12pQtSGHU8l2/c4PVataQZ406w3N6rBuBip2TFajeyB6OJ4hY5k3S1hEhipVXOSW+gBkf+R31BEb5EyEanUb+ztlyhvCs4clzBq4n0OQY/zgRMAurv8EaiH0asn1sZOMSDy8f14/qLbwQ3btM2hBM3EhTce6x8suYABE84QBylRJvb+HZxwJCKVExkdfjsBlLFaCAqX6x/H3ZSAIXJL+Jq3y6rRF3UT7MqfCZl+BB0FKeqv23SgJISvJOLNSVF2WRSlG7A0R/SQxbXq2Zi9Lmjj4LrjdnjiYRSwRT/yYQoKvjaNY+JocrAEmkxkKWXEmKFCQQBbD6H0yPGCtVTQLxaRrr7oEqx7siLmsClOWjMMeQe0ir7/0w5g+yjtEO6m6rQpQaBfYCmzLf/DvAlnim1zGRbu9zFy1Z0bgqNjhdqvTN5G4RWvyaCqmR1WnrI7gNWu5cLeO32fUzmnObAQbVO8dC6SBi9VUkqIZ5c3nDpPAfKD95+XUnHEDppVlAwOCC2gHym9ns+MSqZng8RsdY+KwOkVoj4Q+KuDleGpCVd2dXXP7WlAzPN32agJmFZKr0gFNzcTQ6rKdXSokn5taYFWHXSytd1F3pGyB8enzC9m5B7SmMKi5NdgTthiOK+M6dfMtkDvwz0/FVWSutnMVuleXJwkQX19xFQYtK4hNhCC/2gDU+4PZRUYmXYXxK0PgQTFfqTc90bFl2TkMfzJM1FhbiwcwzX2XXGfFsmt+uVqE+pmJPi99TCwkqGTFB2sEoiARBCZHNcdYrOwnXwWMHQW3dfA2F+BYqLWEebq
 AZgZWQNS
 Tg0pJ30efYGD0x9OxgGtul4w8aH5PErtr2WHI0Eo+Ug1LZdkUSRfH916NZXCxcAVmtvtY/0Bpj5jnC5Gr/4dPD4OdTWMd6tj7lxssGLAwnQzvrB10USQbD13GSld9vTEEFFPxMT1gANZz1+5ynfyvUajMMevv2XGIIksXWa9jT2ZY5Svw3ifP2+wZN4lb66SXwesmVQtV9a392e8DO/PLwXKlm8A0FC0P7W/m8KrEWIwdyJCfPu9ol9EQwvuFP6rVWVf14dKR2cUK68af1C8dylxmtlyKrSr9Y4Ri9QYKIk7lOSzvhdAAxv6nb8Hz+5nqdLGoKbgviV+yNfapiAlTG2/O6BSA/nO5K8goxZHl87BTpqMiI+bXJMTm9inFY0/PFW+cC6OEY8XNejqYVgA4B266+ZczjwchTI/RSNRNUTuii8X40QgyX3zJoYM89X22JNX3PL/vBLaH28vF5x+UUnrKdgX8DJ18YDjqVVLan0V71HkzANjq2xgA1lURaoAoGJFp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I don't have time to review this in detail right now. I am concerned 
about adding new KFD API, when the trend is moving towards DRM render 
node APIs. This creates additional burden for ongoing support of these 
APIs in addition to the inevitable DRM render node duplicates we'll have 
in the future. Would it be possible to implement this batch userptr 
allocation in a render node API from the start?

Regards,
   Felix


On 2026-01-04 02:21, Honglei Huang wrote:
> From: Honglei Huang <honghuan@amd.com>
>
> Hi all,
>
> This is v2 of the patch series to support allocating multiple non-contiguous
> CPU virtual address ranges that map to a single contiguous GPU virtual address.
>
> **Key improvements over v1:**
> - NO memory pinning: uses HMM for page tracking, pages can be swapped/migrated
> - NO impact on SVM subsystem: avoids complexity during KFD/KGD unification
> - Better approach: userptr's VA remapping design is ideal for scattered VA registration
>
> Based on community feedback, v2 takes a completely different implementation
> approach by leveraging the existing userptr infrastructure rather than
> introducing new SVM-based mechanisms that required memory pinning.
>
> Changes from v1
> ===============
>
> v1 attempted to solve this problem through the SVM subsystem by:
> - Adding a new AMDKFD_IOC_SVM_RANGES ioctl for batch SVM range registration
> - Introducing KFD_IOCTL_SVM_ATTR_MAPPED attribute for special VMA handling
> - Using pin_user_pages_fast() to pin scattered memory ranges
> - Registering multiple SVM ranges with pinned pages
>
> This approach had significant drawbacks:
> 1. Memory pinning defeated the purpose of HMM-based SVM's on-demand paging
> 2. Added complexity to the SVM subsystem
> 3. Prevented memory oversubscription and dynamic migration
> 4. Could cause memory pressure due to locked pages
> 5. Interfered with NUMA optimization and page migration
>
> v2 Implementation Approach
> ==========================
>
> 1. **No memory pinning required**
>     - Uses HMM (Heterogeneous Memory Management) for page tracking
>     - Pages are NOT pinned, can be swapped/migrated when not in use
>     - Supports dynamic page eviction and on-demand restore like standard userptr
>
> 2. **Zero impact on KFD SVM subsystem**
>     - Extends ALLOC_MEMORY_OF_GPU path, not SVM
>     - New ioctl: AMDKFD_IOC_ALLOC_MEMORY_OF_GPU_BATCH
>     - Zero changes to SVM code, limited scope of changes
>
> 3. **Perfect fit for non-contiguous VA registration**
>     - Userptr design naturally supports GPU VA != CPU VA mapping
>     - Multiple non-contiguous CPU VA ranges -> single contiguous GPU VA
>     - Unlike KFD SVM which maintains VA identity, userptr allows remapping,
>       This VA remapping capability makes userptr ideal for scattered allocations
>
> **Implementation Details:**
>     - Each CPU VA range gets its own mmu_interval_notifier for invalidation
>     - All ranges validated together and mapped to contiguous GPU VA
>     - Single kgd_mem object with array of user_range_info structures
>     - Unified eviction/restore path for all ranges in a batch
>
> Patch Series Overview
> =====================
>
> Patch 1/4: Add AMDKFD_IOC_ALLOC_MEMORY_OF_GPU_BATCH ioctl and data structures
>      - New ioctl command and kfd_ioctl_userptr_range structure
>      - UAPI for userspace to request batch userptr allocation
>
> Patch 2/4: Extend kgd_mem for batch userptr support
>      - Add user_range_info and associated fields to kgd_mem
>      - Data structures for tracking multiple ranges per allocation
>
> Patch 3/4: Implement batch userptr allocation and management
>      - Core functions: init_user_pages_batch(), get_user_pages_batch()
>      - Per-range eviction/restore handlers with unified management
>      - Integration with existing userptr eviction/validation flows
>
> Patch 4/4: Wire up batch userptr ioctl handler
>      - Ioctl handler with input validation
>      - SVM conflict checking for GPU VA and CPU VA ranges
>      - Integration with kfd_process and process_device infrastructure
>
> Performance Comparison
> ======================
>
> Before implementing this patch, we attempted a userspace solution that makes
> multiple calls to the existing AMDKFD_IOC_ALLOC_MEMORY_OF_GPU ioctl to
> register non-contiguous VA ranges individually. This approach resulted in
> severe performance degradation:
>
> **Userspace Multiple ioctl Approach:**
> - Benchmark score: ~80,000 (down from 200,000 on bare metal)
> - Performance loss: 60% degradation
>
> **This Kernel Batch ioctl Approach:**
> - Benchmark score: 160,000 - 190,000 (80%-95% of bare metal)
> - Performance improvement: 2x-2.4x faster than userspace approach
> - Achieves near-native performance in virtualized environments
>
> The batch registration in kernel avoids the repeated syscall overhead and
> enables efficient unified management of scattered VA ranges, recovering most
> of the performance lost to virtualization.
>
> Testing Results
> ===============
>
> The series has been tested with:
> - Multiple scattered malloc() allocations (2-4000+ ranges)
> - Various allocation sizes (4KB to 1G+ per range)
> - GPU compute workloads using the batch-allocated ranges
> - Memory pressure scenarios and eviction/restore cycles
> - OpenCL CTS in KVM guest environment
> - HIP catch tests in KVM guest environment
> - AI workloads: Stable Diffusion, ComfyUI in virtualized environments
> - Small LLM inference (3B-7B models) using HuggingFace transformers
>
> Corresponding userspace patche
> ================================
> Userspace ROCm changes for new ioctl:
> - libhsakmt: https://github.com/ROCm/rocm-systems/commit/ac21716e5d6f68ec524e50eeef10d1d6ad7eae86
>
> Thank you for your review and waiting for the feedback.
>
> Best regards,
> Honglei Huang
>
> Honglei Huang (4):
>    drm/amdkfd: Add batch userptr allocation UAPI
>    drm/amdkfd: Extend kgd_mem for batch userptr support
>    drm/amdkfd: Implement batch userptr allocation and management
>    drm/amdkfd: Wire up batch userptr ioctl handler
>
>   drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h    |  21 +
>   .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c  | 543 +++++++++++++++++-
>   drivers/gpu/drm/amd/amdkfd/kfd_chardev.c      | 159 +++++
>   include/uapi/linux/kfd_ioctl.h                |  37 +-
>   4 files changed, 740 insertions(+), 20 deletions(-)
>

