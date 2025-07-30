Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CE39C83F26
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 15:10:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A8F76B0089; Wed, 30 Jul 2025 11:10:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 980CD6B008C; Wed, 30 Jul 2025 11:10:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 848A46B0092; Wed, 30 Jul 2025 11:10:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FD156B0089
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 11:10:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CEBC158615
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 15:10:42 +0000 (UTC)
X-FDA: 83721267924.17.DA99A3F
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2040.outbound.protection.outlook.com [40.107.237.40])
	by imf04.hostedemail.com (Postfix) with ESMTP id E098340017
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 15:10:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="LW97/qoZ";
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.107.237.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753888240; a=rsa-sha256;
	cv=pass;
	b=yHUdcBp0W+6FCYG3xHGk426UONXZ6vMZS814zO+jPfJfcvYO5AijW129pAZjFxE8ctfx4F
	xTVQp55oY4MuNcjXFj+eHGyvoZ4W3iKpqtj6mNNs04TinlB6GiWyQi+OIDSsUxdruDNHuk
	DPxnXf0F30aMWpsmpsK3P1o6IfNW5og=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="LW97/qoZ";
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.107.237.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753888240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kLRIX/WJe6ehEaGVAPHcamPo+cRYWSPMnJmeq8i8tCE=;
	b=hTIt8VjIvHX8rOz6Z4OYxQDjPKCoht+1d29wUKytUEALUcQttqWKoheOieYGeRIuJODKdl
	6rkyqzf7CDbmLXDI1D9UQ1Ur1JPJzl3AKFKecjkj3+fIeVebmMX0zvb/Rj5ET5YhceeP61
	1x2CqDStZC+jMRM7VUPUEYbGSeQOa7s=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FZrGb+Z4qpIKxVWTM1S9q5mCf2hu7y5bnTr2WbEGiAgieoXFdAO3R4Xrvopo8sI3/IsZoOV5DhgQexqOilEx3GaQjJsOwC7Y1QcVIouU1CH9oByI+UklLWZldiavdwqvf1SuBxiVg2RV9i3y3Uq3VRHycfSAIJZVEy2XjtYN5lHw28M6O0xIVpgxepq7IBrDTad9DW40zcudWy1oRrgZ/M1OO7G5O6aC2eO7xbUoQzHqZB35XXnmKieKxSJS7j2LvD1y9pFBylws2YmtFJhzGS/zKRwqwP4Z6rO5z+VpJFv4w4mnTnNMgeO6CAgteEiB83rbNWEWe+AsCXir/bb5GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kLRIX/WJe6ehEaGVAPHcamPo+cRYWSPMnJmeq8i8tCE=;
 b=M6tFX7IYt6JxPUlP8TkR6NjL0hVPMNu2mCTnYaPoBl09XhFDqaLXo0JwB8d9bu2Te3fSV/OdVMexiKYHSoX3DJKw7x4VAO7IolXOlDF6IPe1IBmWZggkqgeWoCuhPJbS3R3Mofl1yIepjC81Stg+2CZPQ9lfXn2TWeUs3CymD8424bRhDqn4oDgsNouKrTJl+djLef6dar7hzOIHX7SEtGKwTLKBf8hcCGP+Y28680LKfQhHfyN+1Ir+nI1eflUvKzp33jzq8UUlmgSH8OYTopY++iw6CgZoXRUeHjC5au+HfPJv85c1yAjEY+BL4EUsxveJio7rxJLnfdUnzcUOfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kLRIX/WJe6ehEaGVAPHcamPo+cRYWSPMnJmeq8i8tCE=;
 b=LW97/qoZq3zlmncCLEaZacC58xH8UbKlV+/BHf7lpyDQSzBDNQ8KjBJsS2lYSuKFgh36FnEzOyiqd0SWqLLsMgjS5jV8sPeD9xlvBMb5QwP+DBm2tjLBhl9ZSrLFvyePuQKRbyxhJqU2EfWs4rO4/OSBQHF6a8taIvVMhSKBpEEz2LEmehta0bhxQ9bvMo2StW1jBI8Zu1XmH4OSPfasuzCI+YFEXO4rH4pa47HFCBXdD9IsQLEBPI/zGyYQc8TSDrftCrT9DTWmuSZ70J0y3vaxk2z08NgT7szdPdJ9n/lXVgbcVmITLLUzD/itD5VizWHjnJJ0eAR/D0GXOIKB+w==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH0PR12MB8505.namprd12.prod.outlook.com (2603:10b6:610:193::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.27; Wed, 30 Jul
 2025 15:10:35 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.8989.010; Wed, 30 Jul 2025
 15:10:35 +0000
From: Zi Yan <ziy@nvidia.com>
To: =?utf-8?q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
Cc: Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Karol Herbst <kherbst@redhat.com>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 =?utf-8?b?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Shuah Khan <shuah@kernel.org>, David Hildenbrand <david@redhat.com>,
 Barry Song <baohua@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Matthew Wilcox <willy@infradead.org>,
 Peter Xu <peterx@redhat.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
 Jane Chu <jane.chu@oracle.com>, Alistair Popple <apopple@nvidia.com>,
 Donet Tom <donettom@linux.ibm.com>, Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>,
 Ralph Campbell <rcampbell@nvidia.com>
Subject: Re: [v2 02/11] mm/thp: zone_device awareness in THP handling code
Date: Wed, 30 Jul 2025 11:10:27 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <8E2CE1DF-4C37-4690-B968-AEA180FF44A1@nvidia.com>
In-Reply-To: <b62234fc-051f-4b2a-b7da-0c0959fb269b@redhat.com>
References: <20250730092139.3890844-1-balbirs@nvidia.com>
 <20250730092139.3890844-3-balbirs@nvidia.com>
 <c2f2fe52-a358-489e-a1f2-5c0a6f5b4db5@redhat.com>
 <22D1AD52-F7DA-4184-85A7-0F14D2413591@nvidia.com>
 <F60614E1-28D1-466B-A434-7FF1061B0778@nvidia.com>
 <9f836828-4f53-41a0-b5f7-bbcd2084086e@redhat.com>
 <884b9246-de7c-4536-821f-1bf35efe31c8@redhat.com>
 <6291D401-1A45-4203-B552-79FE26E151E4@nvidia.com>
 <b62234fc-051f-4b2a-b7da-0c0959fb269b@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BYAPR07CA0107.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::48) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH0PR12MB8505:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ef449c1-b8f3-4ccd-3931-08ddcf7b3bd3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MEwxa2djV29TcTl1T3BPeGlUM0hrUG4zYVpNT0lsbkd4RlBWUzNpcytnQUFX?=
 =?utf-8?B?dkxWVnI5MVVpQ3lNekgrMjM0OGZURHRmcEZyY1BoSkNTdmlaekNTQVBpMlNh?=
 =?utf-8?B?Z1VZZjVtMGZzS1dFNFdsOEpScDVMMVkyN2hXN0hscFN3dkNPVUJsaGRLM1ly?=
 =?utf-8?B?Smd1Rmwzc2hhTmUvT2dTbHBlT0FtcUhsSjAvVmFFOHBoRE8vVURYbmI4WjFY?=
 =?utf-8?B?d2hGM1luUnN6eXFVTGl5RDRMYS9UT1pUbzVvWTRWWDhUbStUdTQyODhkaTEr?=
 =?utf-8?B?Y0hvRzZyUis3NlVkaTlFZ1h5eWVTNkdhaTI5cmZwOElNVXNWeW1zN2IxalQv?=
 =?utf-8?B?Nlo5ekNRZksyZTZVNlRMS25pRDF5NHBoUklEOUxpWU0rbHRrbW9HZklpYlhl?=
 =?utf-8?B?a1A1OW4ycE1Tck9ycU1qdFhvaE42amJlajUxYkdpeS9saUU1ZHpaY0NnUHBT?=
 =?utf-8?B?QjR5REtUaEd0Sk5VV3NPemNERllsQ1dRYk5TR2FtazRpZUdGa2cyNXF4c1B1?=
 =?utf-8?B?Z21rS0hkOXpkdTZyaElkcnhTdGxCajRvTTRjVEdrRTdOS3drZHBBNjZENTFa?=
 =?utf-8?B?cUpKeGtaSmpYaHhZMnpqVGkxSU9SUnpvVVhLNkx3RTlwS2IxU2ExN0YzREFH?=
 =?utf-8?B?ay9JWDZNZmhMbTY3Y3luZ0phZ1h4YWZydlhaMzdZcVBCWnRWb0JybmVWQkJY?=
 =?utf-8?B?L3ZwWjdqUXUxMTJFVUNVeldvbTA0dzFsOFIyV2tYZHhQV0F4RGhBTDlpVlVy?=
 =?utf-8?B?aGF5QzZJVnBwNVY1bXZjSDcwN2J3ZEF5OE03MEpqV0EwLzlCbGJjSEdHa3N3?=
 =?utf-8?B?WDRTYUY0VkRRMFZ1WnN0anRnOTk2UFNxVzFUU3RnWjcxK2VKNkxWd2Jmd0tm?=
 =?utf-8?B?THZvbmtnU3dtZWFrNmRYSVl1bFBjTTVweUd1OE5aN3Y4TW56RTNmZ05GNzl1?=
 =?utf-8?B?aVhuZktCZFZKQllNZ0kwY1NvOUNkY0lGWTcrVEdSeW1JOURid0VlQkdMbGRk?=
 =?utf-8?B?NWlRY1A5MzkxWHdCRjh3RW94c0dJRnFJMEh0SkZmMjJmMmZDZTJrNFlrMUh4?=
 =?utf-8?B?T2xMd1N3K0VnSWJMME12WGMvUGlkdWFtNFFBM1QyYWNCd1ViYnNUZitHNjF6?=
 =?utf-8?B?Nk8weitScUhIaGRXUEFoaysyVUhIL05SYmZMVzZKbkE0UFJRZndoU2IzdUhx?=
 =?utf-8?B?NzExaFBqTy82dHo5NWJLNEZMWUJaejd5ZnBSM3JyYkhRNkRaMDZFQ0FJNE1P?=
 =?utf-8?B?M2JvcnFHZVlmVGluVTV1dnlKYnFWYlZWRHpvMktSTndrTkh0Y1hMbnRQZC84?=
 =?utf-8?B?emx3akV2Mm90eXhkMW0xTkg0Q0lCODFlZVNsMkhDMGNDTk9aOTlyR0hsUXdL?=
 =?utf-8?B?SVBPemEvc0hML0h3U2Y0N3hqSGUwWk1rVDg3cFNSL0ovNUg2Y1ptZlBTVFBt?=
 =?utf-8?B?VXl4dWNGSlJlRXdHQWRGQWg3VkhDcUFMbUdQRGd2ekVFcGtBcVpXTUNMQkpx?=
 =?utf-8?B?V09HWm5qeGZ3a09BOHVaMHlwa1RqNXRCMUFzWHBldTZaRERVVWw5TCs0YS8x?=
 =?utf-8?B?Q1BLc09QL29oQkRhR2JzbkNTSU1kelIwZVJ6Tk1WajFmWjVvNFdMT2pOSmYy?=
 =?utf-8?B?V0djRk53ZWVJczlhUEFnQnFaMDh4SUcxWGtFaVZoblFKNUpFUHJPVzRBMFdj?=
 =?utf-8?B?K0t5ZFRESWF0b3h4blBlM05LZG5ZSzA2ak5PdEF5NmZ4RkZkcXFCdUJSQWcx?=
 =?utf-8?B?Z2o2Qzd5NDI0NkdxdUNJSE40Y3F5UFJmRjUxZ2dKRFJENkJBVTlsL2dXTW5U?=
 =?utf-8?B?NHR5MkF0em5oR2l3cXVTU0tORjBsUURCQnhjUVBoeUkwT1pZL1pJdHlJUFRF?=
 =?utf-8?B?R1lVTVNOcGloWUcydGFSY29FdHk1L1ZWMnRwRll4M1B3VWVnNU1xNzZmWW9w?=
 =?utf-8?Q?Zir0Ls0QljE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RHloQUJDc2xPa21oRXBhZW9tbkdZVVZwOERxMzhmcVoxMFRMYnFTRVcvb3ZY?=
 =?utf-8?B?TkQwWGMxK1NRYkRncXBMbGhzU3J0TWFnL0hkYTdGbTN5c0Q0L2RkRXlEMnk2?=
 =?utf-8?B?U1Nabm9tSXo1OEgrUTZsNWh3eThYVjQxRWNuR3F1QkNHQnd5c0F4WFkvSCtB?=
 =?utf-8?B?VWtmZ0JINFc0TmF4SUhZelpxMWF2ZklpdUNiMVJNR2dXRkdFVkM4SVM4L3lo?=
 =?utf-8?B?SUpzNnZYYjZLUkVoekpIZVRrYkZQRTdwWGdNOVY1NDk2SVIyallEVVBMZ0cy?=
 =?utf-8?B?MnlORUxSRlFMckZCeVg0OWtKd204bXQ2bU95d253ZkpJMlNhc3V3d3NWTmhr?=
 =?utf-8?B?WnFHSGVYd1htdnNkeUpHTkEvVDRDZjFnK2FOKzkxNlc3aE0vSnE0Q1R0UXlU?=
 =?utf-8?B?QnBINjA0bFREMDN1R2dkVFg1aFhRRG1rRC82Wm9halo2eVFCRUdKcU4xeEZ6?=
 =?utf-8?B?MkJKOW8rUjB6dVYwVVIxRUtkVWxBL0ljS2o5N1A5NTdIYk8xeEVlM1htaUFY?=
 =?utf-8?B?WmxaOXR0US9TdmV3V2RHM0NTWFp5eGVoQmdLZkNvWThEZklObCtRNG5ZcmZu?=
 =?utf-8?B?N1drdlE5b0JxZXJwYmRVd0RMVDN3VC9rZUpVMm1Xa0tabCt5T1FNU2hyWnM4?=
 =?utf-8?B?VTlLVnZ1bTBxbGFjWG9aY0FpL1hSTWUzZk9PQ0VhaHJTYXk3N0NLd1F6RlVm?=
 =?utf-8?B?NmRPWDBkRDZBeE5UMTNZWGlScFZkYnJFVEJBOWNzUmZycEY2eWVkMFJmNDNE?=
 =?utf-8?B?Y2xPNkNBMURJVVZHNThCcGhuN01QK2ZWZTd2cWNEQ2NJT3dtYWJaUnQ0ZkxN?=
 =?utf-8?B?ZENJM0wxN0tONmJLbFZYUUJ4clBFeWc4ZHovVFArU202YmtGNUJpZTNFcnlm?=
 =?utf-8?B?YlVSRXExOUJuek8zRVNTdEhVTndrbUNkMlc3TGlVdC8zZUs3M3B5UEpiRUNk?=
 =?utf-8?B?QmZKcVQzeUNCTlQxTElueFF3OWhhUGloRHhSOHFFMWNYUlVoT2RMRmNxRWJL?=
 =?utf-8?B?VGU1eEt5VDBOSWQrdHJhcmdmanphQldGaUpJVXVHZTVDTHZXVmxtOVdhYmN4?=
 =?utf-8?B?TFhJSGdGMExmdDF6clRqa3dFVTFyR2M5OHdTNWYxOHZRc2hyTzk0ajkvdFJV?=
 =?utf-8?B?d1RlY1V3bmR3N3JURFNSRm5PbGE2UWZwc2dkUDZaTmYwdE13N0tMdGFhRC9L?=
 =?utf-8?B?RUhuQ1lxUnhNSER2Z0Z6dWdYcVlwUkd6MmNoVkFlYUZjNkNzWUJ0c0s1bnZX?=
 =?utf-8?B?UVJUZG9PU2NObXZhUXdPZFpidVlRcFRnWUJJRFNpSk5YMThCcVVXM29vTlJD?=
 =?utf-8?B?cnBaUkVxM1RLZWQ5WlpSOGxCNkQrU0tENkd0UGNkZ2p0VVg3azkvaHl1ayt6?=
 =?utf-8?B?T2FKVjJaKzYrNTFNSGZnMXpRTkp1enY4bHZzS29CeVV5bGxQVXBNM1pkQXdX?=
 =?utf-8?B?RUFLdUM1R0JrMnRnYWN1cVEzN3RLNnpsK3JlbzVFY00wVkZ3VzJIZVFyNkE1?=
 =?utf-8?B?NTBQUnhURnlPUzcvZFZhNG1ORGRTaXhGYkJnVWFoN0tqaDNCVFZpVjlYU3dY?=
 =?utf-8?B?MjU1VUdreGFNK0VsNmZ4d1haTHI5Wnd0Z2JVV0pMSGNPT1lhSTBQUEgxR29w?=
 =?utf-8?B?RzNrdTVWZUtyOUNuVkJTbmZKSG9tUXBtSGx3bHdNYVh1OFRWcUdFRERPUnY1?=
 =?utf-8?B?TWJTUTdTdzFmODVJNDZnRFZORVRtS0dVVVFRb2xwVjB3QkgyUGtZRE1nUmlV?=
 =?utf-8?B?MnpuWjZnNTd1K0doQ1BZVjUrWlVvYm4xNG5hMnRCbitXRUNZZmNxUDRnRWd5?=
 =?utf-8?B?WVBnUVhkUEZ2VGtRYjNYRUZxSzVxRnpFeWpEZnBPVXhBZXN3TTBpQUtXSkp0?=
 =?utf-8?B?RTMwQU45UVN2bzR0WFR3bXdDZ3hlYzg4VjVwUzdRZTJDbVhqNDAxYUhBMFlt?=
 =?utf-8?B?K25PbFJFNTFFVHZFZ2Y1RUo3VWFMOEI4R0xIaXVQcW44UWhBc0lDVmZadGJz?=
 =?utf-8?B?Z2loZmJNZW1ROUloRExya0JqRFEyM1YxL3I3clhGckpZalNwUHhseTlrZzcr?=
 =?utf-8?B?VTBOb2ZJWFZuNTd1b2lLaDdxTXo5dmJxeVlwbVpLVVNNZmVvbzdrY0JYQ0VZ?=
 =?utf-8?Q?TpNI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ef449c1-b8f3-4ccd-3931-08ddcf7b3bd3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 15:10:35.1111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fMoW7fS1KNK97+QkI+uwC/Id1zSCG6h8LEgAOR6MBsb8lCidQ1ekrAjOq23BhMy4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8505
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E098340017
X-Stat-Signature: kbbkf4hxwe5dd1zzuhkqkjxfdqyz9zy3
X-HE-Tag: 1753888239-660093
X-HE-Meta: U2FsdGVkX18LETMeJjMcJw6L2nnmSYiqgWvtswiIYgG92afpaCBpLJDgBr6srgq0ZI9nhzAujyJu1TKE9WrHjai7HEQXhn1tNLVfuYTn/ZLUlQHNd+s/pDFL9TgAR1TOlGI3Nv/hDmu35j6nQ2rsiZlxdaIn3GujqKIqo+v6pu1TwSuxCQsC4XMMlUzeFFAKbMvVSvJC7/kByp0wgTZXb80Gk4bxxoeHHPA9vxOoVZIQ33cJlkHPWKdqk6yzB1Shv7norQNyNCdNy0ZFJ+fApE5GtfynPZskyBEDM23UkCyEpw3JzdUtJcu2S5ZW9g9TcmLxNyNLTjfo5rjVtce0EATveR5dT2lnyTfP4mo07GVyh+IcKgQHwvmX364mgVaz751qR8N4HKztAxJlIc0ZqNI6xgyo0mXhdfrkQPj4DyHjhgArahyNkn6GEWCm4ZcF4CiShrGneHTrTZTw78c1z2mFb+OP26dwP9L3gCVke6IPwtGTI5hYA293k/SOo85gbw3IsOZ2dycHY6OWIunrsn0fc3/XxLAtFewtALjnLAvExeDnPRAyFUrIIjZZCnvr81rp/DxVjc9tLm0N9/3/gsM+JBPG/cPNgu9BkyO+cwRMj7MA3CD58lBqQpyyPhRP5MwNlwyGNNARqC6t3TCcT7IEzTmlirtOGjbToHoCbwAdM7rj3mh4RbrmIq2uK2ns6fVE3qLueQ0lwZ254FzbtGYqqJIy3Y2Sxe6MGWUnRv6vOV1AVyir/Yv60vUlVS1E1pOQXa4bU/m/2Tw9VARocL9ShtQMF5Qmrssyx6xRXs19C+l6AQ1xSLBZ1qni/6ZXyacHcnVl64H3PmcypXpb5yzGe4juytBxVQN36jh3amlTqoVpIMBrQSc572+NVuLOHQLNYqbh633C8xUW6/PuzxN6PY6tsUyCkdWaiufB6ymblVvufYuPgbcD19Bli+0zZbaA0n0a4sqmsOzXVeh
 4AaxNEBc
 7Z5ukmwtI11wTQR2a/4/TAMQXh9lBCw+rJniouKWkLsfCz/H8N/q6feYi3HrD2vkw9fDXnGFSfwEJPQ4S+j7hxdPrMLdECJbHwbD699KCfhvgTtmVhPqUftY4VcB26c/p1EROTIiC8uxqPx7V8QgQ45yMTd3nqJiXwCoKkaORLW4fUiucpsuAfNtCuLxQx3/FI0eYx2vtor9VpnO7Mr6QHLxPHrKvFXeiw66AEmpCPTsKCkfZ14iogSj8CnkKLEmCCE3g0LMG5bn+nqedbndQy2PpVk2XUgKvxNL++8tHHn+khxIZOqvTD3hCm/gw/UUfonvnEtwSUH9tgLxsaS5uQmDNmC+I34byW/rjNkn9agYJIPFI/VvKJOFJ4KSJLCKdRIgsFFMdBTO5v2dkV2/b6y3/Zsp88MQ33gw2+HuAyMsUQwyXH94OmpOOk4UbXJ0qTgQR5AlOZsckMXHW6rpubd1kcFUyrU4RBm3P2tDlexxtKpNkARfBkQnmykSCizzICTQWmtcU5ULKlzHc3nGlwXxBodmXRGEVn3k4sQmRclqNe0OkY2GFTK/P3zI62x6eukjpflouHo8X/rk1qKMAZTRs6C8VQ8pt85AY/womcmB4Nx0UzxxGTq448iZk+v+vNf6uLmwu/VM/W05QcD7EleRP1cbPz7OjV6dyDano18hu3Ynw6tUMuH5xH451+f1XY2LPdlkZxb54WL1a2c8/vwxsd+hD3cHWDBdy920X4AazG0uE8+zjmSkewENUkG0b1y79OelROUgipUXZ256kES4axKcJ8JRr3scruk/WGxnZl42dqkqsodjpeJUAxgB4SCDNxlSkm9aSRuzYZw0uxXGURQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30 Jul 2025, at 8:49, Mika Penttil=C3=A4 wrote:

> On 7/30/25 15:25, Zi Yan wrote:
>> On 30 Jul 2025, at 8:08, Mika Penttil=C3=A4 wrote:
>>
>>> On 7/30/25 14:42, Mika Penttil=C3=A4 wrote:
>>>> On 7/30/25 14:30, Zi Yan wrote:
>>>>> On 30 Jul 2025, at 7:27, Zi Yan wrote:
>>>>>
>>>>>> On 30 Jul 2025, at 7:16, Mika Penttil=C3=A4 wrote:
>>>>>>
>>>>>>> Hi,
>>>>>>>
>>>>>>> On 7/30/25 12:21, Balbir Singh wrote:
>>>>>>>> Make THP handling code in the mm subsystem for THP pages aware of =
zone
>>>>>>>> device pages. Although the code is designed to be generic when it =
comes
>>>>>>>> to handling splitting of pages, the code is designed to work for T=
HP
>>>>>>>> page sizes corresponding to HPAGE_PMD_NR.
>>>>>>>>
>>>>>>>> Modify page_vma_mapped_walk() to return true when a zone device hu=
ge
>>>>>>>> entry is present, enabling try_to_migrate() and other code migrati=
on
>>>>>>>> paths to appropriately process the entry. page_vma_mapped_walk() w=
ill
>>>>>>>> return true for zone device private large folios only when
>>>>>>>> PVMW_THP_DEVICE_PRIVATE is passed. This is to prevent locations th=
at are
>>>>>>>> not zone device private pages from having to add awareness. The ke=
y
>>>>>>>> callback that needs this flag is try_to_migrate_one(). The other
>>>>>>>> callbacks page idle, damon use it for setting young/dirty bits, wh=
ich is
>>>>>>>> not significant when it comes to pmd level bit harvesting.
>>>>>>>>
>>>>>>>> pmd_pfn() does not work well with zone device entries, use
>>>>>>>> pfn_pmd_entry_to_swap() for checking and comparison as for zone de=
vice
>>>>>>>> entries.
>>>>>>>>
>>>>>>>> Zone device private entries when split via munmap go through pmd s=
plit,
>>>>>>>> but need to go through a folio split, deferred split does not work=
 if a
>>>>>>>> fault is encountered because fault handling involves migration ent=
ries
>>>>>>>> (via folio_migrate_mapping) and the folio sizes are expected to be=
 the
>>>>>>>> same there. This introduces the need to split the folio while hand=
ling
>>>>>>>> the pmd split. Because the folio is still mapped, but calling
>>>>>>>> folio_split() will cause lock recursion, the __split_unmapped_foli=
o()
>>>>>>>> code is used with a new helper to wrap the code
>>>>>>>> split_device_private_folio(), which skips the checks around
>>>>>>>> folio->mapping, swapcache and the need to go through unmap and rem=
ap
>>>>>>>> folio.
>>>>>>>>
>>>>>>>> Cc: Karol Herbst <kherbst@redhat.com>
>>>>>>>> Cc: Lyude Paul <lyude@redhat.com>
>>>>>>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>>>>>>> Cc: David Airlie <airlied@gmail.com>
>>>>>>>> Cc: Simona Vetter <simona@ffwll.ch>
>>>>>>>> Cc: "J=C3=A9r=C3=B4me Glisse" <jglisse@redhat.com>
>>>>>>>> Cc: Shuah Khan <shuah@kernel.org>
>>>>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>>>>> Cc: Barry Song <baohua@kernel.org>
>>>>>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>>>>>> Cc: Matthew Wilcox <willy@infradead.org>
>>>>>>>> Cc: Peter Xu <peterx@redhat.com>
>>>>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>>>>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>>>>>> Cc: Jane Chu <jane.chu@oracle.com>
>>>>>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>>>>>> Cc: Donet Tom <donettom@linux.ibm.com>
>>>>>>>> Cc: Mika Penttil=C3=A4 <mpenttil@redhat.com>
>>>>>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>>>>>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>>>>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>>>>>>>
>>>>>>>> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
>>>>>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>>>>>> ---
>>>>>>>>  include/linux/huge_mm.h |   1 +
>>>>>>>>  include/linux/rmap.h    |   2 +
>>>>>>>>  include/linux/swapops.h |  17 +++
>>>>>>>>  mm/huge_memory.c        | 268 +++++++++++++++++++++++++++++++++--=
-----
>>>>>>>>  mm/page_vma_mapped.c    |  13 +-
>>>>>>>>  mm/pgtable-generic.c    |   6 +
>>>>>>>>  mm/rmap.c               |  22 +++-
>>>>>>>>  7 files changed, 278 insertions(+), 51 deletions(-)
>>>>>>>>
>>>>>> <snip>
>>>>>>
>>>>>>>> +/**
>>>>>>>> + * split_huge_device_private_folio - split a huge device private =
folio into
>>>>>>>> + * smaller pages (of order 0), currently used by migrate_device l=
ogic to
>>>>>>>> + * split folios for pages that are partially mapped
>>>>>>>> + *
>>>>>>>> + * @folio: the folio to split
>>>>>>>> + *
>>>>>>>> + * The caller has to hold the folio_lock and a reference via foli=
o_get
>>>>>>>> + */
>>>>>>>> +int split_device_private_folio(struct folio *folio)
>>>>>>>> +{
>>>>>>>> +	struct folio *end_folio =3D folio_next(folio);
>>>>>>>> +	struct folio *new_folio;
>>>>>>>> +	int ret =3D 0;
>>>>>>>> +
>>>>>>>> +	/*
>>>>>>>> +	 * Split the folio now. In the case of device
>>>>>>>> +	 * private pages, this path is executed when
>>>>>>>> +	 * the pmd is split and since freeze is not true
>>>>>>>> +	 * it is likely the folio will be deferred_split.
>>>>>>>> +	 *
>>>>>>>> +	 * With device private pages, deferred splits of
>>>>>>>> +	 * folios should be handled here to prevent partial
>>>>>>>> +	 * unmaps from causing issues later on in migration
>>>>>>>> +	 * and fault handling flows.
>>>>>>>> +	 */
>>>>>>>> +	folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio));
>>>>>>> Why can't this freeze fail? The folio is still mapped afaics, why c=
an't there be other references in addition to the caller?
>>>>>> Based on my off-list conversation with Balbir, the folio is unmapped=
 in
>>>>>> CPU side but mapped in the device. folio_ref_freeeze() is not aware =
of
>>>>>> device side mapping.
>>>>> Maybe we should make it aware of device private mapping? So that the
>>>>> process mirrors CPU side folio split: 1) unmap device private mapping=
,
>>>>> 2) freeze device private folio, 3) split unmapped folio, 4) unfreeze,
>>>>> 5) remap device private mapping.
>>>> Ah ok this was about device private page obviously here, nevermind..
>>> Still, isn't this reachable from split_huge_pmd() paths and folio is ma=
pped to CPU page tables as a huge device page by one or more task?
>> The folio only has migration entries pointing to it. From CPU perspectiv=
e,
>> it is not mapped. The unmap_folio() used by __folio_split() unmaps a to-=
be-split
>> folio by replacing existing page table entries with migration entries
>> and after that the folio is regarded as =E2=80=9Cunmapped=E2=80=9D.
>>
>> The migration entry is an invalid CPU page table entry, so it is not a C=
PU
>
> split_device_private_folio() is called for device private entry, not migr=
ate entry afaics.

Yes, but from CPU perspective, both device private entry and migration entr=
y
are invalid CPU page table entries, so the device private folio is =E2=80=
=9Cunmapped=E2=80=9D
at CPU side.


> And it is called from split_huge_pmd() with freeze =3D=3D false, not from=
 folio split but pmd split.

I am not sure that is the right timing of splitting a folio. The device pri=
vate
folio can be kept without splitting at split_huge_pmd() time.

But from CPU perspective, a device private folio has no CPU mapping, no oth=
er
CPU can access or manipulate the folio. It should be OK to split it.

>
>> mapping, IIUC.
>>
>>>>>>>> +	ret =3D __split_unmapped_folio(folio, 0, &folio->page, NULL, NUL=
L, true);
>>>>>>> Confusing to=C2=A0 __split_unmapped_folio() if folio is mapped...
>>>>>> From driver point of view, __split_unmapped_folio() probably should =
be renamed
>>>>>> to __split_cpu_unmapped_folio(), since it is only dealing with CPU s=
ide
>>>>>> folio meta data for split.
>>>>>>
>>>>>>
>>>>>> Best Regards,
>>>>>> Yan, Zi
>>>>> Best Regards,
>>>>> Yan, Zi
>>>>>
>>> --Mika
>>
>> Best Regards,
>> Yan, Zi
>>
> --Mika


Best Regards,
Yan, Zi

