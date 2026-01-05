Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91FC6C2A072
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 09:06:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCDF16B00FF; Mon,  5 Jan 2026 04:06:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA6716B0104; Mon,  5 Jan 2026 04:06:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5E016B0105; Mon,  5 Jan 2026 04:06:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B3BCE6B00FF
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 04:06:38 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 405141B791
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 09:06:38 +0000 (UTC)
X-FDA: 84297329676.18.729B075
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012033.outbound.protection.outlook.com [40.107.209.33])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3806640004
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 09:06:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=SfG8Aoey;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf17.hostedemail.com: domain of Christian.Koenig@amd.com designates 40.107.209.33 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767603995; a=rsa-sha256;
	cv=pass;
	b=cNo95bxBcNsZ98vu2wIbOwVtoiGDpeotc1Nro0B8H4LaP3pmFH8dpIP1J0lqTan5eKF5rU
	ybV2naTN3OAYtVkgFA2PA7nvMb1jHMmWFp7FvGpQwmF11KtQ6p5cgSry/NXEr+vR/jbl+g
	9/7mdzcsdfgT2nROKlraH1Sjktm//P0=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=SfG8Aoey;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf17.hostedemail.com: domain of Christian.Koenig@amd.com designates 40.107.209.33 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767603995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=06seYA0Pi4vyfJ7Yxw0LxaC0/JEAPs+eJvGdfDqXAjM=;
	b=5aAH9WxLHD8pEzbNt7Mtq0o4118ZfwJlP3Bxo5dkvNi8rRszGYAqjhHnUdUBYqytVFSU3i
	P6d0PhWxL1obBZhJtzikxZEG5ca3uvM3s2ni3ojSAMe1NP3n4ITBO7ZIdmIBEzii/N2NtJ
	UHYwIBh/Nzl4LnoanbY9Z1QBzxe/+DU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cnccky87ov7Gzp9XQLHcUnhONnZZj2At/AcOkhmZ5O2YLX6jazAxnivFt3JkCkLpNS9tGiCQs2EKKtOt9ZeyBEd6yt3FH6mckLqRCJrX/hIxn/dvpV8KqOuN5XspuJgWJWqazh4qZcd5pHnk6YYfCtKjzIv2Mf9JftiVM9YsTCkvdvNnR0TOKAqkNuM5ZFnR5R19jarpIJaib8p/lrOhNjP41BSl3d02upq7naFTdY41NpWjyqtzJZpcE7Qxp6A/CTQc6CDbP+QhVtAZmp2KoDzKSZDw5dCPHZMlhKKSpuF/tDvOYwnALsBHDKWmCP6GBQproyH3hmodQJxcErviQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=06seYA0Pi4vyfJ7Yxw0LxaC0/JEAPs+eJvGdfDqXAjM=;
 b=e/ygQ+WP4bv0p7soKFfEg9F5vsewhdY00Isj1Y9JGzg1D+eZs+PfwWqLakzBGOVfM8XJT3gD/Iz1WKrjX2VGrMq1P8N/upAHWApztH+yZC2ozGwJmTNbEICY+OoVq3UZx69ZjnGExj44eRHD8Pms8RbY2G0erPcRM8nFh1UQP9iGkUrYG6vQ8AMBfTYS8XmTrsCjdm4sx/4YXJsP3i6DGwjLivS4WwvDjH/XHBLFBNyghdKzEf1ZFfhW2kbM4RAhmbY7gsizePK0DW6npySvx4uGDcPoMtS/Fu8yOVcI9apgPrcCSEtN7QlRb5ie4KX+qTwBqdxj1eSMzLQfS7A6yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=06seYA0Pi4vyfJ7Yxw0LxaC0/JEAPs+eJvGdfDqXAjM=;
 b=SfG8Aoeyv0UYGzvCBQLhLEgYrXNNo/YICqlZcf4bR00oqfbvdKqgZ0akPsaq3fg6QJ4vERWPS8JR3t7YW0wKWzg03vFyevZnekMyTsDn7DJBfTZ3tkHE1UU0oqQ2VINE4AA+iNmRnZNLxaW0CYthzS0pbReg56ww/TFkhCmyRXA=
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by BN5PR12MB9461.namprd12.prod.outlook.com (2603:10b6:408:2a8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 09:06:31 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5%4]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 09:06:30 +0000
Message-ID: <38a52c10-f931-4af7-a7e5-224bf629b875@amd.com>
Date: Mon, 5 Jan 2026 10:06:24 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] amdgpu: don't report an error if the process was
 killed
To: Mikulas Patocka <mpatocka@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Alex Deucher <alexander.deucher@amd.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, amd-gfx@lists.freedesktop.org,
 linux-mm@kvack.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>
References: <aca0147f-61be-30a3-eff5-cb981222aacc@redhat.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <aca0147f-61be-30a3-eff5-cb981222aacc@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0209.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e5::8) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|BN5PR12MB9461:EE_
X-MS-Office365-Filtering-Correlation-Id: f59d7a1a-8632-4b8d-d6f7-08de4c39b696
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cFUvWEhlRHNUdG45VFY0cXB4VVVZT0tqMTUwV0Q4QVpmREY5L3BuWlRJV3Ri?=
 =?utf-8?B?NXJLYkpnT2EwcDdKOXIydVN1MG80dkZyZUNKTDBtSjkwR3JZaldXcDBNOCs1?=
 =?utf-8?B?amR1dzJvTHZQWmlGenZtRHh0NzEyQnkxNkRrVk1LV1dYSXZaSm9KVFV5My9i?=
 =?utf-8?B?SGR0NkxtVVM3Q1dPY0J0R2oyVkovNHZRRUl4UXU5WnYzUXU1cGlYa0p3S29V?=
 =?utf-8?B?YytPUmxwUnVlR2N4NG44WUtVK2dKM0srbjNGTEFPN1NmcDlPbVhGY3JxS0I0?=
 =?utf-8?B?NEJPeVJaUldMekVCVm4xZnBQOHVxbFo5YTF0cWZCNk1zdTJVN3VyNmtDMzVT?=
 =?utf-8?B?amlnbndOSFZ0UmZDbEg0dmxaN29KZHFvMUdEc2ZtclV0Mm9FZXNac1M1aXZK?=
 =?utf-8?B?OXF4L21iSUo4c0xaUFh3LytFVGpHLyt4cWl1ZlVuOHNzVnEwS2UrN3VWMzYx?=
 =?utf-8?B?eWZ0SDFiaUsyS3Q2YXFIUVZPaXhESWxLQ21XRVp0RlEvd1Z6L1BjVWV4eVA0?=
 =?utf-8?B?aExpaW54eXdXWlNtaHVPaEYrYTZDMzdrWk9CejdqcVBSN0hjelhkalpNZXBn?=
 =?utf-8?B?RUVTeVVlb0hTbU9TTGh4eUZNUWhTNVlYUWR1Zkx1STFpVVk4eUk1c2ZPUzJM?=
 =?utf-8?B?WTVKT3ptV0RvYytQVkRKY2pOK2g1VERnMXBRN0Rsc1lvZ3R5L3IyckFHUmlP?=
 =?utf-8?B?WktWVzhzWGZVbUI0VDFkeEljellUZDRlOWN2OHJIMWdXMjNLQmxac3hXajNj?=
 =?utf-8?B?R09xVmlzNnB1c1BlbUdxTEh6czRCb29aK3A1aThJNERHc3UwOVpYNVdJdFJr?=
 =?utf-8?B?MkE1YUsyUCt6TDYxZEltMlhWbWFYaThXU3RLbDRCaS9NMW93RXBkVXhKaFlV?=
 =?utf-8?B?OVdNeXZydVY0b1NDV2tTVXZiS21kVkl4Qk10aThxRzFrRUVic040YkRSbVQr?=
 =?utf-8?B?bUNZTnhOQnFkMlpFcE53dlRaanFPMWI5MXFJcjRBSFVjb01lU3ZDK2hydHhR?=
 =?utf-8?B?ZkFLRkFXQ0dKNzR4bzRDeFNnUVNKd3o5ZkVCRm55NHlxWDZBTHVJMnlWcFJO?=
 =?utf-8?B?RHRydkZxTWhUc0ZiTkhyT1VYNDZ1V2ZGdEVqY3VNN21sUTFqZmVmWmJkVFlH?=
 =?utf-8?B?Q0d0TDh5c1VvdFpQVXlLVlcydnJKYUxWK0dDTzZSTjcyWFhaTDl0a3RTYUZ3?=
 =?utf-8?B?TmlNRnhZNjFkZjJid0tQUm4xbXlrZERad0RRdjJGaWtPR3plNEc5eTIwRlBZ?=
 =?utf-8?B?YmZKTGZrcTJDNUdheGJmTlU4V0lqN0t5elVDRVcwbXBBQmY4ZHMyTU5tM3po?=
 =?utf-8?B?Qkg0dUhoWWplTjRMTElnTFFIcGpLUkp0Z1p0NzNnRkN3WDVWTHdDVVhzcm52?=
 =?utf-8?B?SzR1Skp4bXlhQ2E5Q29LbnNkMWdSaVlFZTgvRnZnYjVLNlBPaWJ1VWRIazRT?=
 =?utf-8?B?VmFTcTRQY3VWZVVrbnNTS3BPY3VQTEJMZ3Zwek5tZUQ3YmhObUJEMVhXU0Y5?=
 =?utf-8?B?WW5GbnBpU1lNWkdqN09hak9JejlXcFB1NW9saDlCdkRmM0t5UWZHcGQxbno3?=
 =?utf-8?B?MjBFMjZKMXJQbHlsWlZWMnAzb1JBUG1pVmx3bzZuR0ZGRzRaNFl6NllLUllw?=
 =?utf-8?B?WC9XZjA4c1VCa0tyeVFEVW1VbWpJMFdFeXl5MUlCTEIrOXMxKytjSk4vTzV0?=
 =?utf-8?B?RC9sdm9BNHErNVovZ29GODMrUFhTVCsyRUhQdVlQV1RyNVdLRmpBV3pRNXRu?=
 =?utf-8?B?T1FnRUxyU2JmdG1yUHlENVJNYU9Pd1Z2eFc5R3d4TGJHd2N5VzkrZm9pWFl0?=
 =?utf-8?B?NEZRQS9sN1VvNHBSNW1xd3Vwd1F6b0lPWDZsYXVjaTdyeC95Nld6SWx1SE5G?=
 =?utf-8?B?VzRpNk9iOGhFNlk3amxYN2FvajZqZWNrK2VqNmZ1L3NSUUE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eXlMTVR0akt4VUlzOWVwOGRraFVSaGt2Wk1aVGt5czN0Nk1yZGxxbnFoTnkr?=
 =?utf-8?B?cSt4dzhLMnFrY05Ra2hIdWlpbWhGa2ZsOTNIbW1XcjBOZzBoR3VKRXd5bkta?=
 =?utf-8?B?WVB5WWY5MVdmVUJZRDhFT0g0ZTFGb2xIakRNeTYxR1VGSnNJQ0I5Sm0vNUx3?=
 =?utf-8?B?SVkrL3hQaHRIKzkxVTJidzhJUDBFWk04YklHL2NvSmVhY09CanpJRXdydXQ4?=
 =?utf-8?B?Z0FFQzBhKzdycTFTTXNVS05KN3N5V2N5eG9hWGVSU25iTnN4L080NkI2dEJo?=
 =?utf-8?B?RU16MTZPVndxNTRmckc3cFUxdU14UklEcGVRZHV1cVhWcjFvZXBMb2REL2d2?=
 =?utf-8?B?OEV5a05rbXRTRzJ0b1NWNzFiUXlCWkVNVU04cXBMUWo3UzRGRG1qSk10OG9W?=
 =?utf-8?B?allsMTAzZzl4S1lvRHpkbEZUWWlUckdvS0VJK2t6VlVQQ0NMS2ppSnFMd04w?=
 =?utf-8?B?OVVPbkFncTVpb0E5YjkreE1wMkJ2NURsaFY3WFVYa0MvWHkxbnZWQTQxMkdp?=
 =?utf-8?B?VjZUZVJNTlI3VDFwN1lzMis1cGJFcWZOR0wrai8ySE9yOVFSMzV0Nm52NytQ?=
 =?utf-8?B?dXRWYzFET1JXaG8veURVS0o5TlVlenNjY1hQS3Q0ZUpSQjR4UnpoS2NVVitV?=
 =?utf-8?B?YzFMQUZZUFRaQVU2Q01wT0JSRHVrR3c3QmV4TzRMT1dpVGJjT3BweEVIbUU0?=
 =?utf-8?B?VjM4Y0dLWFNWWXhrdHlWUG1YeForM205V3VsbjQ4ZjJ5SmRieFEvYk5kUGtw?=
 =?utf-8?B?RE53N0VTSmw0UmRHWEw4dmM2NlpTUHprQXY0cm94cUhOVmdLekdJRmIxbk5S?=
 =?utf-8?B?aGIrdjZ4ekZxUmxWUzNDR2d1dkREd1FqWHZvMk52a3BkTHNnY2FjY2tVbjVM?=
 =?utf-8?B?NW1QL2NTMm8wTHU0M25nSEs5VFhxa0VqZjJYVjFSM3BHUnRoeHR0TzhYRkpV?=
 =?utf-8?B?MVE5MkRFT3ZWeEZ5OXI0OTkyVDdpU2Z0VEhXT2wvK0xLTzFQL3Nya2NUbmJ6?=
 =?utf-8?B?TXZUc2c0cFprMzhrT0U4TlkxMEYzc214TUdYeGduS1pXc1RhN1FnWHNIbFcv?=
 =?utf-8?B?VUlaaWxLUlROUEZNMkNhZmd4aFFkVmwxeVhrSm5CL3ljWENCejVOMFpSbXEx?=
 =?utf-8?B?bldSTWRmbEU5cGpDbE45L2RRU1YwbHExM0ZoMndLMVE3SW5JalFMV0Z5STVF?=
 =?utf-8?B?QjN1NVBvRlhwZDdJTHZLVHRuUW5vMXpNbmRPRm5mdUVPazJIc3M1T0ZXYW1j?=
 =?utf-8?B?YWN5VzRBeHIrbXpmNHlVREQ3QVd2VHRqMEFnaVhXbS9hVnZyeWxUZG1Wb0lq?=
 =?utf-8?B?ajZEUHNXR1pkeWIvcGtYaVV6czR0NysralpZSWd0bko2cjhLamtWeWdOMklt?=
 =?utf-8?B?SXEzOUZTSHJXVWsreFB5UkFMV3R4UVRmU3A1Z2Vtc1krOWtuL3NlSFFTU0Ri?=
 =?utf-8?B?OGYvZXdCcWFrOWZYQXUwYVR5SVBzSU83bWd3ZUJCZVVSTmVWcms2eUtPSFNW?=
 =?utf-8?B?WkZ3cFlGU1FEcG4ycW5Ha0N0c2ZRY1A0a3JaamZRNGFxbVNuUWVobTVPSGRy?=
 =?utf-8?B?c0xibi9jelh4d0RLazZFRzdlZ2dTQ2JLSGxiQzc3NnBRQ2kyV0ZsZFQxbS93?=
 =?utf-8?B?MzBCVyszNzlQRjJhRElqbUxqQnF5V21JNE5EUUZ5UDJ3cG95cUdSYUtWR0gw?=
 =?utf-8?B?R2JudGw4TkVwWjdYWWtCNTZ5bFJ4b1U1U2wvcVQ2d1ZGdmVoMDdlYlFCb0pq?=
 =?utf-8?B?SzVGZWdBa3dqVWhmY0EydjFid1BKQ0xzbkVNSktRZ0hTZHhudHdMSXNiNVRE?=
 =?utf-8?B?MTVRNUxIZk14akx4RmVCc3MxdzBMc0UzaTR6dXh5Sk10Yk5BSDBWcVhkWEFB?=
 =?utf-8?B?bytibXlTNExGS29HVG5mWTdBb1kwakwxWUlHR0RVcGt5b2h5Szg3QXVpdEVq?=
 =?utf-8?B?U0hnZzgraURyOEg1L1hTMHBKdEg5WW1lWmdKNGNycTE1SEpYRzcveklqT0xx?=
 =?utf-8?B?OHZLeHpndWJka2ltWndwZ0ZhTzFYblFlRkpML09zc1YxSVJ0YmtWeEU5OGt0?=
 =?utf-8?B?cVNRRkk2UzBBMmNPUHRFV1VLaE9ZbDZkMk9LZ0dKbU1yWjBKd1ZudWhhMnEw?=
 =?utf-8?B?U3RQaFFJemYrWEdjd0hWc1paRUdBM3RRdC9tUFJBQXQvS2x6ZGRjOVAyUlY0?=
 =?utf-8?B?WmtOb1BUcDZYcFU3dTEyT2FteWJNU1dXY2tOczhhTmFoRTFXS3Z2UEU1bTNZ?=
 =?utf-8?B?bU15REFiMjVDQ0VxUmV6QkVTck15K1J4cVlvWmNFOXFOZGczRVFwaXBkbjVO?=
 =?utf-8?Q?8mQ3vDDAhKcHXQ/aSD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f59d7a1a-8632-4b8d-d6f7-08de4c39b696
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 09:06:30.8490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aQwl5n4asZvhdwLs0g91Mre+YNaKMkX65v2CKAfsKMGwmEI5YcDYA4gNxnRP+stt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR12MB9461
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3806640004
X-Stat-Signature: xqzyhiui3mrgsqx3butzuri1gd66ywaz
X-Rspam-User: 
X-HE-Tag: 1767603994-289528
X-HE-Meta: U2FsdGVkX1+KuhU2WFCbbsFqmdW1CA0C7mB3fGiKRag6YOb52F7QmizyL1Y92yf1pZN4Gj5xeeiwmgCC30qlC6ViCyD0A9ka48hDdq1KS7XjzF6TNAJujSnhjlikAFQjJz4V4LPcZ/IxjzUqN4EKD1Fb2WytmU4/XJSYL5yLlq5qq9p1xHKTios3BRbpHsxw5ognDbQuq49I1b82egGyj6vijM8iQWPRBQ3mhb2EjZPc/jHdxIcASa+Ayv1tnTlYf5l01ibXmthW1Xl/sf228zySllViRl35zKil4apdSnW5u4ZLLHsLbTusqiuHfA9kXqvpBu0GJohh4jrayKo1rEZqinHheqThGgyGAGhOEJ19ylJjbUN1C5ILv05U4m+s2SfQ+8DRc1JX030oZHhbfzF2dmof/Ay2+OB3rNa9pnMVZcfQHxgkgidLOuz5Lr6wVuHKJ5y223Cfjh15lzry9UxSqJB2riX0tnF7W+JEZgwZ0nXbyhaarPYVr2sdrtw9jSv9jOBHJ3dHYOVN1Cf3SH391MkPkPuZ8iFuV25jiWt4aYJlwSbuOy3uk5V7Oy/zsDQGsYvBCRumr9msPrA9f800jLmJMfo0ob7Pki+CL51rT64HB1MUIzL6MR+v4EBeRtsA4SMISJwHpnO94qgM9kfMwHY6XrmTS+omKB7xieXCQ2JOZgY0Onsekm8RLqFZZXsMamtGZeZdlOIWB+1nMUbnB1F7fgbV5BY9xWMkvZpBcyC4wkm2EEjxfWJWysH8q0rdna2sYxQsgntn3d1Qony2fWGB8MlZjzLNTSvsxWKG72yXWHzZI4HGtU/RYorAsfnNZCKb6pc+CR60V109USRaFI029l40Y8shrVXDWJS3z8v++DXSx8QEjksJLcND4sqEDsNKBihJDu8qJ689+GgNAxLizWYdhdWj4ii6xampn3TFpq3F1+WS5A1q596UdD8Nx/YwxJNFqpQcfnQ
 tTIsn2zt
 TDRPJJl7ZXTkrBy4ji4aSdiCYZUND7WgI97XPvUBmJdHSdncMWJh3gCSDbnDVRRWu1yYl0QmV6+QDmbniO7SS93U7FrdaB26SAtY2aioy9EIA1iy/d0sZVBtWUHCdSBKxUaWBMZH2NFMBCJ9hSCAXnu3pX8Uargl327ManpDz1U/+pY/8JTQZfMjODJ/nlQA2vnnD8NxVbrzMLRf86jktoZKxZg3DpQdrePrw5M6CCDFkCHQeJzEi3ciIZG0Og4Wh+8q7WwMn63cbzDNtKAoKin3cAJ1bOvi7XfH5risd5Vx/iAypcumMCfj7I53g8mBpNErAKNg1jjhNGfezogtn365T6GPn5kZuwd//OjRIDW3sRU4ikEzDOwYBphGpS4m8Hw2FIjFt1CG0K4m23LTpHzM3K351UHvrLTNGElq30FEBtq0edE5bZnW8KzwmbAkY8HJaa5Xgz5jaRIqkj1vQMjsums/z1oVa5CJyPHvHysjnMDw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/4/26 22:17, Mikulas Patocka wrote:
> If the process was killed by a fatal signal, amdgpu_hmm_register could
> return -EINTR (the -EINTR comes from mm_take_all_locks).
> 
> Don't log the error in this case, because no error happened.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> Index: mm/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
> ===================================================================
> --- mm.orig/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c	2026-01-04 21:19:14.000000000 +0100
> +++ mm/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c	2026-01-04 21:19:14.000000000 +0100
> @@ -1070,8 +1070,13 @@ static int init_user_pages(struct kgd_me
>  
>  	ret = amdgpu_hmm_register(bo, user_addr);
>  	if (ret) {
> -		pr_err("%s: Failed to register MMU notifier: %d\n",
> -		       __func__, ret);
> +		/*
> +		 * If we got EINTR because the process was killed, don't report
> +		 * it, because no error happened.
> +		 */
> +		if (!(fatal_signal_pending(current) && ret == -EINTR))

The usually approach is to check the return value only.

> +			pr_err("%s: Failed to register MMU notifier: %d\n",
> +			       __func__, ret);

But in this particular case just remove the pr_err(), it seems completely superfluous to me.

The only reasonable user error here is that we run out of memory and that is noted in syslog quite extensively anyway.

Regards,
Christian.

>  		goto out;
>  	}
>  
> 


