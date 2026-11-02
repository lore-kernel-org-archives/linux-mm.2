Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9B56606F3D9
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=hOqrlymY
Received: by kanga.kvack.org (Postfix)
	id E7D246B05D6; Mon,  2 Nov 2026 09:56:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E54D36B05D7; Mon,  2 Nov 2026 09:56:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1D146B05D8; Mon,  2 Nov 2026 09:56:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A8AC86B05D6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:56:03 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4166716014E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:56:03 +0000 (UTC)
X-FDA: 85390479006.26.B99F538
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012012.outbound.protection.outlook.com [52.101.43.12])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5C25BA0004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:56:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=hOqrlymY;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of Pankaj.Gupta@amd.com designates 52.101.43.12 as permitted sender) smtp.mailfrom=Pankaj.Gupta@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793631360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lIVbkyBoPKOlLf7rFBhrSkkCYfabu2G2BRcAA2ComWc=;
	b=FobBzSMnCCjufvl15wznnmhgRXpSF9IIOhUCA2snjPGDRnYW4hC4MgUEZyP3etHAWXX7sN
	o6BvjeyGrwC0vScAlpYW70AMbnlxhHBr+5sJUtRsmiskforzCYpM95/W0W7yl8XahvRDiC
	tikJSecqSy1+w71lI3A4KYbflNey7KQ=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=hOqrlymY;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of Pankaj.Gupta@amd.com designates 52.101.43.12 as permitted sender) smtp.mailfrom=Pankaj.Gupta@amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793631360;
	b=3WXgHdBLCU1wBSYQtStaOGmnXCCg/VxAGxcuzNUVRawR9XJeISKeZrMq5uhQou6kwAhTov
	NpYFrFU7W5AcIMHNaKUj4zJJ2+6MEwsFi/NDMu/KASERw5EkoLDTMK4qhsq1WPo8BzGWVx
	dVKm+lwhSzw+d3i3t0fiF60+WqEA5Ww=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WHuaWYSUq9WRKWaVBKVQjfZuTWvTpdaa9BuCOTH4QwbYq0EXtfZvGQYgQisjQ50GZPGL6nRdDtzOKgyrijTksuvJzWlNc3fn9X2D0CPqkvrhgM8Nl52WW9XvszsGGH147i358c11CsmTLQQvFrFY7DClpLEFqL9oRtPWY5F72dDifYM3+1xW+3tqMpSbHC+lQcmOlpitp9EgLFWpLxiE8EsguSemqGcJFV8tajuEC3+iEz5r5sz++k5VpzHD4yn0N1fXw3Gu0kR1WDX47/rRKasIewNcojjp/9MqHyB1zcVUWFUb/zc+GOfVLBkI5wulVmjLCERwt6j9JhONNXwllA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lIVbkyBoPKOlLf7rFBhrSkkCYfabu2G2BRcAA2ComWc=;
 b=ckZiydH99tecK8+bTylFPhcGdjKy41hDVecaRw9JgtVZoFtHu+4SSZbJUwGE03XArUiCAXwTPGcXzQynrvkJHht14T+fKBPQx8QkdP4uUF5dbqFKonFCmnPtortYeYxGg369dmvGk7ndTMac2jGC1cPDmW7zG1FZ/mK5s5Ygnvne0v8SiTLAR6hgtNGlCckL7/pSNmkO4Rmp7ZYj5Q6qNAbofebg2ZChiwyAc9xV5vIBVRTIPw22cc7q9raiNbRdb4Njba460Q5z1SBjj6eASBWQpMdpPx39n+aXFi6RRwFMKMa4k+VmvxHntZ5TTn1HU6BLf/ZnmCD8f/GLoXIU6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lIVbkyBoPKOlLf7rFBhrSkkCYfabu2G2BRcAA2ComWc=;
 b=hOqrlymYOsc9WbYM1bAI73MoDqORj3Rq+vt+LbeQm54ouBjyHI0qrSnNIZ45rJgP/zGjwpWrr1PFXskcqzgfDmYtn0r7BtRAnNgRLutHjdtaU+OGb6ye4OKObhfyJJ+ayHUV1P9ekg97KYTDFKSY6RhVyGh6G4Af9r6JH5aOwYk=
Received: from DS0PR12MB7771.namprd12.prod.outlook.com (2603:10b6:8:138::6) by
 PH8PR12MB7135.namprd12.prod.outlook.com (2603:10b6:510:22c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 14:55:56 +0000
Received: from DS0PR12MB7771.namprd12.prod.outlook.com
 ([fe80::9a3e:791f:33b6:3d8c]) by DS0PR12MB7771.namprd12.prod.outlook.com
 ([fe80::9a3e:791f:33b6:3d8c%4]) with mapi id 15.21.0569.010; Mon, 2 Nov 2026
 14:55:55 +0000
Message-ID: <0c88652a-0b0a-4092-9c4e-d4db8f89bd74@amd.com>
Date: Mon, 2 Nov 2026 15:55:50 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/cma: accept memory of multi-range CMA areas
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Kiryl Shutsemau <kas@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
References: <20261029-cma-multi-v1-0-2cbced8b5cb7@kernel.org>
 <20261029-cma-multi-v1-1-2cbced8b5cb7@kernel.org>
 <a25827d8-83ee-4e05-8c55-4e6ca8a498ad@amd.com> <auM56dTOXCb70vzz@kernel.org>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <auM56dTOXCb70vzz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR3P250CA0006.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:102:57::11) To DS0PR12MB7771.namprd12.prod.outlook.com
 (2603:10b6:8:138::6)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7771:EE_|PH8PR12MB7135:EE_
X-MS-Office365-Filtering-Correlation-Id: 52db9caf-1c1f-4461-f750-08df38f165a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|261021121427099003|261022075727099003|261009223027099003|261026121527099003|4143699003|11063799006|10067099003|56012099006|18002099003|261102123227099002|6133799003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Fbue2BdjLNEGX0G24EzncbWBnK/TiXFm/NAuYfcBxistVLlV1s9UEM5zVlVJBr2wRIWbUJPPe+NLypiK1Rf1LO3xJlV5g/qnT54r2BcDYlCBwQ4RUiOgnxaM5oft7KBlixcLXtpiqmfchJlCJCiDw6Bwv09gRnMsNGVlZ6iAkqsA8i+isX22CFpDkMXEPnAn9D3ci7/jHJPEiRXSc05l+t3V1L5z/zbSBn1lHmcerjbQMonz3ha5wdikR+GtH7zQkFoNWzLHQ0hMSZmnqP0oogkh5uL5DcdHQ82vfBHLAL4Dhbl5SiQrUvIpfdIRTSRXZLuifzQeMvWZNXp4WTeMFb69BcaLNoBEHeABzfVIFp9JXAyhTmi2UCDKXzyhhqaF7Si98Qd9nb78xC5r8jLiKeM45W64ouzJ+f8pQfYhF7KgAOK0RQFWhKUT1S+7vJrsczJcYxTIFd3tQWsV1TMDAD9cB2ngHAZkLCbyljUfvGfSDHAIcwemrzdPHmE4VYcQxV8Lpbd/dFifvUOSh39UuWPjBdPU9bkwNgUYKjOfVD4mzbBXhbXlIRvFdxrseprQmbw21YT5CzY7v1Ev8gI93tnksJDYUp32pT3f1FDuF6G6j5naqd5bnLeEbgnDivFS
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7771.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(261021121427099003)(261022075727099003)(261009223027099003)(261026121527099003)(4143699003)(11063799006)(10067099003)(56012099006)(18002099003)(261102123227099002)(6133799003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U1lHUXBGdFliWUZ0ZitUUXhWajViQ3B4VTRCeUZNMkZxQVcyQjFxVlArY0ZX?=
 =?utf-8?B?cXU4OXBWdElnZXo2UnRBRjlieUlSbjIrWlJIaXZ2VmVlTys3M3VLZ216ZEtl?=
 =?utf-8?B?UUNDODVhMjdqSG05elFrcGd0aDBWRjdtUDFiQjZHNnZ3MTlrWTRyZ3RWNWY0?=
 =?utf-8?B?NmR4K3hoeHNHV05pcks1SVJ5UjFicnoyNzJjaytveDBObUpPWXNzMHFIUmNY?=
 =?utf-8?B?UkRhV1FNS1RuSG5IR0hOOGJYc09HQk1xT3NvRnZUamt0b3FhMWdONnBXUyt0?=
 =?utf-8?B?Z1V3bHgvQWdsYVBoWkVISitnUWxBWXY2TnNsMVMyV3ZLZzBIYVpvaGJhNk11?=
 =?utf-8?B?S2RhSDZ4VGpEeXFmVFVhTUdNdjBzdUtZTnZtNUVxQmRPeTd6NVdwdTE5K2Mz?=
 =?utf-8?B?YnNqU2hzdEtSakpVajM4bjhEMUpiU243WUVvV3NwTWdzRjZ4Z1Zma0V6RFlj?=
 =?utf-8?B?ZkFMWkxqWWRuMFo3YTZJSW9jVlVkeW9HWTNGYmVYZGhFdW8yVDVaNUtDd21M?=
 =?utf-8?B?TXBKOG9rbUNWdTZZak44VXNQalJoNmZ2cnd4SHd3Q0YrQjFzWlAxdXYzWDRi?=
 =?utf-8?B?QkdReHhJek5ncGNTZzNLdmpmRG5TWDVNeERucUhlTWo4M3JNZnVROFVrb0xH?=
 =?utf-8?B?R2NlcHJUZDhoK09NNm52WmVhVnhxd2lNbHZ2emhWeWRnZG5OL0NTTm8zVExa?=
 =?utf-8?B?elNyTC9aTitLTTk3MUkvRHNSczV2QWpOSENXanFRU1VFOS9WZnAzd3VPT0R5?=
 =?utf-8?B?N3dCUFQ3bzFJOHZsQnBFYzVXTGxKL3BwMGgwczduOVZXYXFqb1NzQ0ZrNEY3?=
 =?utf-8?B?aXdSS2ZBbWF4V1JVdEczcm5ncXE5YzQ5cnJVOXRPdFUxaXFjQkVpbjk1ZTFP?=
 =?utf-8?B?S0tzNmhnNDhIYmJmay94T3J6eXp5SkFrWHg1NVI3REdzWlpIQ0d1azRxWE5B?=
 =?utf-8?B?aGYxR0d6ZWtmVDM0b2tVY29hTHpEWFRmYmdPV2pSTzNoU2JwaFNJeTN0bXc0?=
 =?utf-8?B?KzJaeHRobHpWODhQMnQ2TUlzQXBacmswMGVCbkdUT1pKdFE0YW9KWFpibE55?=
 =?utf-8?B?RnV3dTVIS0duNS9lNDQxREp0TUptUEhFdDVKc0dwdTZPYzRKTGxDZy9hYUE0?=
 =?utf-8?B?V3M4NUtaZmpZYlpXM25vamxhek8waHBJUUpQMjAxK1hqdWRYOXlHWmFLd1g5?=
 =?utf-8?B?VzVRSzY0aEp1SmVYQVc5TGd6L0t6ZW5pVGptQnNBb1YyaVZxT2Y2dzdKZUxl?=
 =?utf-8?B?WkZpWmhIYmFnUmZacElVL25yRWxrdmVqN3pWZW5OMEVnSld3U3M0TU9SYjFL?=
 =?utf-8?B?NFJlUHlGTjV0dzE3ZGFkN3FEelRwUmQwcWZtTDRDS1lySzFteGZqaUFQSzRY?=
 =?utf-8?B?QUR2dXppTmZ4MFcyTGpTbDh2cnorbjRvelBtS3BQZVUxNkgwekM0ZTZwZWcv?=
 =?utf-8?B?a2hHalptTm1RcExyME9PVXZQV1JIZzFFa3VGaGMxNzJCRXNDWldkcGRqQmNT?=
 =?utf-8?B?eWx1VlU1UkorZUY2ZnF5ZDM3Vm5yb1pFMHRZMDlqaWVjcUFZVnBNZndaOUVi?=
 =?utf-8?B?LzZwWnR1YVJpanpNeE1hTkpocTFFd0VxSFhzYUxzMGthZkZxanhxR3NBV1R4?=
 =?utf-8?B?bEZPR0c1a1BqNXIvcG9hRUF6ZUNHYXU2YXVqb0liVDBENHhvYzFDTGc2c2NF?=
 =?utf-8?B?NGszUzkrOXdEQjNuM3F5aVRIbTFJWHh2UzJQb2ZGNGxKejhwTE9oQVNsNUEz?=
 =?utf-8?B?cXdjQStINjF4SDBEb1FVbG9GRmhaT2ppWnRSREJESFlEVWJVQnljbTV2bTY3?=
 =?utf-8?B?YmprdFRYYWU1WDc0dkdPcHhwdVBtUXBlRHdtMzN0Ti9tT2dxVTAzSFZtYmh1?=
 =?utf-8?B?YkRaT2w2cUFKdW5VNHhCMFdFYWFjRCtuS0k5Zm5FODVUR29BYTNka3pDSDhi?=
 =?utf-8?B?YU1idzk1R0xuZjhVMU5iUnIzdGRjbDhKcWRzMmVSaGxYZXdyeEJKS1YvSGxm?=
 =?utf-8?B?OFB3bFNMY3hwOUlJQ2g3cVRlbzV6dDh4QzBQSkJRRjZrbVd0a0dPaWVtQm9z?=
 =?utf-8?B?dm1tMFdYaWh2cUttU0MzQnJhcmo4LzFLQ3g5OEl3SXJBQnNsN0UxR3p2UFV2?=
 =?utf-8?B?ZENadlNIMGQrR3hJbHFWTXRXZ09Ed084U3pRN3VWMU0rTCtZKzRrZnpXdDlI?=
 =?utf-8?B?N1cvRFUwNTZtQ01SNmJNQVczd0xFWEMrOTkvMUdrOVY2YTBDNEFKREY2QmZk?=
 =?utf-8?B?Z0ZRVHFCcXdJKzE5S09VbDFPNkl1ZU03Vkc2Rmh4RjJBK1lUWGZFNjNMZ1JR?=
 =?utf-8?B?YXhYbHNTNnpJakcwdldRZlRlV0VENVdVelZLUG5STFRsRlNDYWVmQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52db9caf-1c1f-4461-f750-08df38f165a1
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7771.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 14:55:55.5944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JI416M2Kcv7pJgrwqVOjh4mPdcLnZX8bRuAKb1PxKhVI6jC6s00XjtSZTWaJBejn1RS3c/fBHbmzRgMvRj6VWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7135
X-Rspamd-Queue-Id: 5C25BA0004
X-Stat-Signature: d8qod46y1jtr3e9ecs5wc5mh8677r6tm
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793631360-268046
X-HE-Meta: U2FsdGVkX19WRuw4PJHj9FqSlA0jZfRQ0RMq0C7B2qubunKvmhO0K7vDvbVZOPWgj6/b4Po98LKHOO/Lv6VFXDKfRL7nNHlW0s1WRD+wxe42ZbT3h8sA7N9SPLXD6m8D828ks1MESRgctuz6dj2HhvgbCdQ3EvSuE2tMLs4wQhvqeJ2aBn8Zn14NGCgVORtJWGcxh3SObij8sfHj9ifZdKO3wPEG9/sjxWVnt0N3yMwHCmjXyymv02I1j/FRugHTselVdmNC5gIdwbKeWyo08QEL7q3y+qGgXs33Z8LYqN3ABGI/1+KOzMfbQMy7MYsMOI1dCCIx6LOQdky/e5gEAu7IwyeVJxoTWe/009pNvg9/VWAgqJoSA9tmIwI/e2Q1XSmVOBLzw5rEpgcn4IBlZ8cDlzUaL2G7e3XfFYCYfVFB/GCQ1GYbI6NYokm29QzXXtFwBFLkdUGimw7KbpvbmFzAEtcBWJ41Sg96l0ZO6H4Fude62xl1hhvwaUlWoxmmQfRAw3yaZS1HrhWpEKtnWNtyw95wiikCYSIr+faCNah5xwRRVH7mH5NyPPziv3kLxTrdDGqgfx/jdL+6ZyBb8q/AKbPxEh788+eShvqE6pll6C0+n5SPJcB8L9MAT2rHDyDavYHtgWJkbfoLvnoE3j72RHDL4QxrEGTS468gdq1KQLcl/vWb8VZsC/2kNsQcbOGXBYK9DsW3p1CZGEsDkIgvHBxq+dhehNxJkSNZg9oGrGUxE2aPZy8oP572g6iaK153RjsWc/Al3hCSzAFWwPCCL/XDrTBXHt+fHZpLWIwkmBv06iG4XlIOu3K1R1bLiALmCMzIDWXqnjN1+uXZd7es6iwGax50UUAv0V1rHumjkq/6dpWwsw4n3RoNDPRpTiwTFUoT0EuP7keV9jkc9SZegy5AYtclAO7NxQNaPTnCxA+5i0mr1siBWtqKRVz0cG+iGxyplDqXp1cXZAv
 3kALdeKC
 S7sTvSa2xzMTHw0gZj/pW5HvxHcKZhXSRehb0k73VzlbLbAHFNnQWV1i7UphVWB1mOEv4NEuLZJwapjEzdC8LDcOEOWs2hXBBaiGP2YdD+oEX1ijg6eBphtxAnFDI6728MAgzvyQ6Y65hW5DlAWQSzF8/EH7W/Nnq8OOfpi4sqCgxwKzACigLwyhshG5QPb2iD8k2DPkCQ/+tbsp9GxJI/+gK/MlQhKGjyG/PSN8nzw8siCKNt+vX6Qva0RR547zaUTF0rGGaQ7vdX3ok4oXBPARoHICfro1iFFHgWZDe6wELsrLszRS3lGMmfBuAvtdreUnUqnSdK1aXY79cVWG/TFi9tyuuTnUTaVUJWQY4w3ausD4cdNLvCttOg5w/Xx7vleZEEMCB6Gv0JwygfPorEuiavwip5BQmrRDTCUZJoz9cFzL5EHneiLEMAOacK8RYXimsPSDd9gUDJrMiysy4sORUdym5DAirksAJxpHVTmYbS1YkEYaUKd1KLuiM6h5wjHQe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

>>> On systems with unaccepted memory, memblock allocations accept the
>>> allocated range, but when cma_declare_contiguous_multi() uses open coded
>>> allocation of multiple ranges, it reserves them with memblock_reserve()
>>> and they are never accepted.
>>>
>>> These pages are released to the buddy allocator by cma_activate_area()
>>> with __free_pages() that does not check for unaccepted memory, so the
>>> first access to such a page in a TDX or SEV-SNP guest is fatal.
>>>
>>> Accept the memory of each range when it is reserved.
>> Fix looks correct to me.
>>
>> Any easy way to reproduce and test on SEV SNP?
> I think running a VM with 16G or ram on a single node and with
>
> hugetlb_cma=8G memmap=2M\$0x2ffe00000 init_on_free=1

This triggered an unrelated issue for me, I sent a fix here:

https://lore.kernel.org/all/20261102113127.161823-1-pankaj.gupta@amd.com/

I was able to verify this series with:

hugetlb_cma=8G cma=2G@0x200000000 init_on_free=1

Thanks,

Pankaj


