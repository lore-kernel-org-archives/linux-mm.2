Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18C22CD98DC
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 20:51:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4082B8E0008; Thu, 13 Nov 2025 15:51:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B84F8E0003; Thu, 13 Nov 2025 15:51:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 259A58E0008; Thu, 13 Nov 2025 15:51:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0EDBE8E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 15:51:32 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D2B178572F
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 20:51:31 +0000 (UTC)
X-FDA: 84106779582.14.567AD13
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012029.outbound.protection.outlook.com [40.107.200.29])
	by imf23.hostedemail.com (Postfix) with ESMTP id EB17F140006
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 20:51:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="Vz/DL13j";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.200.29 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763067089; a=rsa-sha256;
	cv=pass;
	b=Acpuz7eN2nFyIT+UsKdhbwbPo5CZ2216A6lLHfjcJeOWR7YF4d1jJyNqrMO+eHkHsh0a3k
	dD/GSffbT2kkR8V0SpGmpcJvxpAW5twSmgw5HZcTHN2MBi190kDziZ8kMdqcSx59+3TQBa
	zxKSoJLA1b0cmETS13N0Rah4YJe3inQ=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="Vz/DL13j";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.200.29 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763067089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3apT2FV+o1jh/Z2zj/um7iMWbcT+Bnq1/5ZejIaso18=;
	b=TxJefSJ622Xqi/XrH2OCzxMFbt5E627oa3lJtq6d8vm8igErSev9XO2ZkQUSYQV0oRCNpw
	00poLm5zIAtlN1PqsQnVDooGE4Qy+ZjKP0Sb+Pt01uiCVrg5wq7iXDGfvuupJHaZLz+4/2
	TH0nF0VpMeiIQBpER4Sv8PjWnfL3gis=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q+4mUp5skha7mmha4uo/l7KIdcQ9eA4qD6Xkl0WFNIriJVhazrnFQGkkODPiBbB+1/vY8F+EkvVH80p596nEJ5OLfNAgZNzwfWPcLcSAU18ixDW2NyLvogGSzpW4fcBwxezSrNIl7gW0qihwWR2NoSoMCGaWwa4twA9gQEbC64BNDrJgqEbxsf3YIap/FSGLOcVVronlYXyXqeJPuBIXADVMoK/ydDffItnGpqx8lmaPEUGUg4YFUpep+MEGjsdKYLDcMTaINyVeBDKELYgZu+NfPOP/AA7HKz0tT+z+ME355rRPvleez63pWi4j1qSadeKEcByuaV4bRPQbNdORYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3apT2FV+o1jh/Z2zj/um7iMWbcT+Bnq1/5ZejIaso18=;
 b=pFk8KK1Bx3k16MnX7nm2iiO/qXvre3eZ30aH3nlkX+rB6Ejt+u2tvQo5dFTqK2m5ea+H0h+CJ1NEA9jVxJmT6xosOf/kXG/YrCbr6Ku1T0aZJrpISP2KHTm93FwaV/ngbR3i2gFrx/eoHIeRXyUaRzyhLdlJ2KIM6ud4plSaLv0U8l/h98hk68o4JJywF3nsJZZZUp5jV2EWptsXY2K+p+7G63ERb0RIwUxsSIaFr7fNK3RQv4vAbhwOlJudh+MxenDZ/oFqYcM6AQfAovUmdzr3dE+zftMKbilYrKVRPhZZCvE88ne4F37E76qI73axDJ5/OBYxE9vHs+DNM8bE2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3apT2FV+o1jh/Z2zj/um7iMWbcT+Bnq1/5ZejIaso18=;
 b=Vz/DL13jSWLKw0BYSbdWSU9cXLWJCCnKTY6iUFnWehqpuJhwn3yFskLhJP196skfK+PcPgjAehw/EkGB+4SamW7fJfS6KyY4p358d+ZBKQFHlWVib6kp9GB5tK5okhyt29J4Y1EZyq3Y8h4j59tchW/23pAURrRK2XPSI8PK9HBRsw8k3R1NZQGyz/Q2gfkEjGuou7JccjiAxN0JRdUUQgtmE31DALPO9zUKqtnuLGY/drwUlC+IfiJYBUwyvig1KQg64TVazsdyc7bZOtd3CfllvhseRwlCES7E7hRIyJ33al+aG2oJ8Yba0wQ4QjKtrfW0f+x9gYYATgm/iJhkNw==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by MW4PR12MB6998.namprd12.prod.outlook.com (2603:10b6:303:20a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Thu, 13 Nov
 2025 20:51:23 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 20:51:23 +0000
Message-ID: <e902daa9-d756-4523-9488-9ab7256c02f4@nvidia.com>
Date: Fri, 14 Nov 2025 07:51:15 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fix gpu/drm/nouveau: fix return type in
 nouveau_dmem_migrate_to_ram()
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 dri-devel@lists.freedesktop.org
Cc: kernel test robot <lkp@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20251113051322.1753532-1-balbirs@nvidia.com>
 <5bdd8b10-171e-4171-a1f2-43c029dfd8e4@kernel.org>
 <7d5ff6bf-9e44-41da-a9b9-c5424c569e98@nvidia.com>
 <48265d08-df2b-48df-959b-d2ed1407ceca@kernel.org>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <48265d08-df2b-48df-959b-d2ed1407ceca@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0P220CA0027.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::18) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|MW4PR12MB6998:EE_
X-MS-Office365-Filtering-Correlation-Id: 3671ac69-58e7-446c-6b3e-08de22f667ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dU8wRlVYVXpUZ1RRdTE1clN6NUVQd0R0dmtROTBjcG5DQ3RGa1JZQ3V5di9W?=
 =?utf-8?B?TkdqWmRxTU52T0JvdnRkMkNGREpkamFUKzlBZjdYZjBZTWl3ZFl3TFlUVmNi?=
 =?utf-8?B?eGI1K2xYMFVnSnZVV3lBbWNzVTllTUk3TkZvdU5rMmpqYmNEdHJ3cU13aURX?=
 =?utf-8?B?bTBGOEZ1WVI5S3hEMHhUMlhBbVlZM2lwdEFaL0lmYktsOHVqakJLTmhBQ3Rw?=
 =?utf-8?B?VWVNV1Z3RGp4enVNK09vN09tUHhJUWRLM1l6YndWcDBvTGU0U1JpeUgxNUo3?=
 =?utf-8?B?ckNORysrcGlyeXNueEQxanRpWlJ3VjBPS2RDeXFsM1pWbzV0OUZPcUowSmxl?=
 =?utf-8?B?U3V4WWExV2pqUWNRQk5wSU5MWjE5bDJNQUhUNUMxZnlwbTNpQmRKQ05CUGFm?=
 =?utf-8?B?b1pDQjRydCtIcDNvSXFTUE1acFhvQSswZzFxc213MTJPMk5UN2gxY2JwaHVM?=
 =?utf-8?B?d1VNUFltaGRZSnB5QzNhT0I1d3RjUWs0amU0WWhkOW1GVEJNTEt0c0dXOTNq?=
 =?utf-8?B?U1BKMUsvem9EUFNZU2V4LzVwMVZtTVczNFNqZUJYVzRTSXV6bDcxZHBWQWp5?=
 =?utf-8?B?dmtyL1dnREZaQ0cxWWZaMDlXc0x2YkZSWEI0MjJ4c1RFbjUreGdlSzNPNlNZ?=
 =?utf-8?B?L3pVcDNSc2VLM3ozY1hjUmNWNGQxOVhQc0pLQy9hZzBrY3R4M0dCMlgyWEQx?=
 =?utf-8?B?YzBEczMvanR4S1ZtVTNTc3lpRmZudjZIUFU0WEIyaVZzQXRXbk5GVGNwSjZ6?=
 =?utf-8?B?WERhWUJzdGR0aEg4SUppRSt3YlYxb0ZTcTRDWWR0UHRxTXZ6UnI0d3djTFFN?=
 =?utf-8?B?MmRCbUpVMHJKSVFSaHFvZERrS3IyNUIxdnFVZm0waE53VDkxaWs4SngrdFMy?=
 =?utf-8?B?SFlBbnA1MmhiWmtlM04yd010T0t3d0ZDYWdrQzhLVnMrelBxeWR0VE5kTUIy?=
 =?utf-8?B?djZPTGc1Q25HUmtFdjAvYXlJR1hkMUFHUXFMUmdEOVZ5WER1VWMxd0tMRUJP?=
 =?utf-8?B?aWpqenVkcytFN1JiZHhkUnc1VlhQUzRSd0xyczA3TVJGeThXWGVQTVc3R1Rr?=
 =?utf-8?B?WmcwLzZ1R014b1I1U21XTXdHQ0RFN0d2QStNQmRRc3RYWThqSkRoc084N1Fu?=
 =?utf-8?B?SEFXaHlUakxDdVgzQmV3ZWliQ0Uxb2NiMW5YTGhkeEUvUVFKbE16TEFXSDRI?=
 =?utf-8?B?Q2JqS0RNT3hzcGNPOUxkTll2YUx2bWNkbUUzK2hRMStlSGhoc2xwMytwaTJ1?=
 =?utf-8?B?VVE2WTh2anpkUkwwd0VUMm9wK2dSK3F6OWMvbmMvL3NSWDZVbnJrZEFpMVo4?=
 =?utf-8?B?TUtsaUM0dUVFMEhrZ2ZwelhaU2JLNWZzalFNdWllK2dtVTJOTEhYazRCTCtp?=
 =?utf-8?B?K0JnTGtJTjBFc1cwaVdDQzBaR1YvZjNycStuN1pCZUM3L3gvYVRQMzQ4amtu?=
 =?utf-8?B?M0pJdHdZVXhZanhSeVBMekVkR2VLeDBxYnZmWHV3cVp3NUpvVHQzTTJ5dUxk?=
 =?utf-8?B?N3lRNXdPUWpGZ2NVall4dG9ZR1B2dUUxekV1WUhvNnlJRFBJanhhMExDeURE?=
 =?utf-8?B?OGI2eWRSVTEydEp2UGVhblV4TEp6dnYrdFFXNzhBR3Y5SzZ3QkdVeWZEZlow?=
 =?utf-8?B?MmNKZUZIemplcGdPT3MzZUVKalo1cjVMTW1nWUdEK0xSSFVsQTZIUnNVVHEr?=
 =?utf-8?B?bndxdUtmMis1YUlTNTl6aFNIZXhwRnJDZzlndGhudnJRTCtmb3E1SGZXWkFH?=
 =?utf-8?B?QXNtbEtQQThvR29DWWtiY3VYSFQ4anBXZmpxY3g1OHZoRHEzSk5OUU5BK093?=
 =?utf-8?B?REJlVmJ0YTRmSUpPcG5lU2tNaHczbUV2Q2htQUdkdWErOGZ5WllQYTBVNG8r?=
 =?utf-8?B?bEhTRGVvTTZvYnBOY3RPZktSQ00rVm5zYkFpV09FK0wzYUxISmExQkpPak5R?=
 =?utf-8?Q?YIlwb9DSfiJYq5MZAqSNSQ4zYBmzhE1r?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?clZqSW9mVzg5cGwvM2o4VGRjWlJtUC91SUFpUzRSZlROTTBFMlY0anhiWkRF?=
 =?utf-8?B?QXFjVU0xeUZPNmJiZlJiRGgvN240a3VWREVodGZJVTNKem03T1g1Nzk1QmY1?=
 =?utf-8?B?bm0rblFBWFZ4WUlQQ1JnZ0NINVNTek5KSEJ2NTF5N2FUclc2b1pjUTlTMmRR?=
 =?utf-8?B?QmlqVTViS1owSXNKaE41d2s3OVdkY3NsQ1cxT0F0MFBlRFZCbi90dHFBNjQr?=
 =?utf-8?B?aXNnVUhRSEw1SFRTcE5kL0xTSGFLVm0xU3p1Y2lhWDR2SVRKdWdVdUI4UGpl?=
 =?utf-8?B?SGY4MTNVdFJTY2xsOFQyK1pGanFaQU1qbks0WWF0dWkyb0xyV2VqRHB0QTNS?=
 =?utf-8?B?VEtTTW0rUHFvYnRJejJ4SEMrK3dDeDB1VDVxaGZta1VMdzI0M3ZuVEJ2b1hk?=
 =?utf-8?B?OWJOamp2Y0h5ZUF3TmJrN0QvWVBERFQwS0JNbW8rTlpIU0ZwN1IweDJsTHZm?=
 =?utf-8?B?VGtzMmYxakhJVWZhNldhSVBIMHVyaGVuSzRobWk0bVIzVXhwMzdTc0pqd2Jo?=
 =?utf-8?B?dkVGUnVCbUIxVkVyaTNIVy91R2xFS0NOTE1YMFFFOForNlhsUGc2L1hLSTR1?=
 =?utf-8?B?WTJ4SEFiQVFGK1hwb3d1Ky84Z2J2dmF5Q2ZhRG5lTnRKd0Q2R2xkZ0ZsU21h?=
 =?utf-8?B?b0g1cm1Gejk0UDd0ZnhnNWhzUi9JekF3YUhOSVBiMHNlVGJuQVZiRU1iVUQ3?=
 =?utf-8?B?cVUwSVdQTGxLUW5FOURXdVdiRm45T05ISW9NUFJaZU9EZVBoTXpjNGVYTFFR?=
 =?utf-8?B?RlBPdFJ0MEtGdUYyQm91dXRWbmVyYXRTc0tjbUNINjU2Ujl3ZSt4cHlhWUt1?=
 =?utf-8?B?ZUkvSmF5QXo3K1lNUGdveDBrRi9FTHZtTUhCVlp6YXFYK3Y1N0NDQ2ptMnRO?=
 =?utf-8?B?dzlYRFBoVDBPSlROR2c1R1lkMVZSWU5xTGl6TUtlWWFCUTVkUFlMYXBSZllh?=
 =?utf-8?B?Mk01NW5pbXZYMjgyQ0FEaUkvWms5ZUJZWXA4YXVnMTdWNzVXNmVidU0rZ0tC?=
 =?utf-8?B?dnFKYmFxZlZvaVRTdkVpVmxpOXUvOW9IYnNkMHptRTllUldkZ2NTQ25TWXpY?=
 =?utf-8?B?YTFvQ0UzYURNZE5kR2dOK05WbGpQK2RiUVRmbVh4d0RKN2FSZkZCeTU0OCts?=
 =?utf-8?B?VEZpM01PQWViRzNhY3Bib2lGTC9vQ0o0eW9FOXg3Mzl6R2dvUVNYcGkzSDcy?=
 =?utf-8?B?ZHgyS3RQZTZEVEhVb2ZNR0t6T3dkVVRYY3dzcm1nb3RYalMySElOWm9pV2hZ?=
 =?utf-8?B?UEsyVXgvVEhxS2NHUjZLMElWdkpjUk9HTDZZUys4eHhHSnE0VWdxR2dsMzVl?=
 =?utf-8?B?aVRHWDhFRXprcFpSYm1MUExMU2tjSU9nVGtyMnl1OElmeFNkZ1lqTFdpTjVR?=
 =?utf-8?B?Z0NsNlRZL3hWeUpROVRWdUJkM0RNTFNNaXd6bDQ1bkthdElpdDgrQW5hVklC?=
 =?utf-8?B?VnpwY1JBaW5kQi8zZHFSN09YS2NrM0h1aEhCTVBKVGNKUHVjYjZaR0NiODBZ?=
 =?utf-8?B?cloyLzlWVnpFMFlLS3lzUHhZUjYxNWxrMXh2RFB3TTEwMVREVzh2UStmWk45?=
 =?utf-8?B?NkhLOWR5UUkyZnB0dUlJVDNwUXJpOTY5bGhVK3lzaDJ1R0NhMncrbDJwMHlq?=
 =?utf-8?B?bkVsQjlJWVBJQW1vZ0VjWXZjRVFSNHliaFcraWJJSXRXS3V1OHFSQjltdlVj?=
 =?utf-8?B?Q2JRaXFCSUdkMGh4TEFhVUdxU2twa012dnN5Z0dLaFBxYno3NWRnV1V2T0ls?=
 =?utf-8?B?M0FDVXFwcFVRcmIxOFdGMG5WUjRXcjdJa1FLQVJUeDlCUEREZUhPcUpONFhm?=
 =?utf-8?B?SGNnaHdydGJQY1ZCTnFBN2F0aVdBRzA3V0JpWWtZWm9BME4zRlZHMTZsS1JN?=
 =?utf-8?B?OG1qOE9PWkZjT3BlUFdDcmxXWjJrUG9XQzNmMUMydUh1TkcySUpKV3M5NUpH?=
 =?utf-8?B?aDVaU3NHVWlSampNeUl2bS9WS2tJR1ZMdmdubVFCbHhPTFJPNUx3WmJZWnow?=
 =?utf-8?B?c3RMeUxXbGY2RHFVVjBKRU90VXhKaHIyZ2tERUNVL3NleCtyaXBCT093UzJY?=
 =?utf-8?B?c2JqZXpNUEFpeGl0N2x5c0NlN3c2ZGNmSkdLT21EcmMrSXJ2c0E5dnlYRHhy?=
 =?utf-8?B?VnRpdndiRCsySFVPRUFmTWgwaVpkcFYxWVUzUXNRb0xuaHhxMmRpdWpOUUc4?=
 =?utf-8?Q?PchwKAZUJYxb5OqzCkrO0vWhJkKmPHUQX5i7BoeXsDeN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3671ac69-58e7-446c-6b3e-08de22f667ef
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 20:51:23.6010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xzPCghhn5yc/Entqq2oomJL7UFbFrdVLbk5H2gjpO5E++I/ztPd0toJ9O+PwT/ZmcqVmTmdo5BFpTTJohlRCPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6998
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EB17F140006
X-Stat-Signature: fycrbn349xdg9dzmkywm15x6n6ntzdih
X-HE-Tag: 1763067088-930777
X-HE-Meta: U2FsdGVkX19iXdEHxYg9VKKyhuS8JeFWzCF1OrEMXWUa4nsRwmFMDpNfW4Ng7PBkegqN1sqLGjtbWzhFycE7d0TcHhQuXhQIVCPtdaOY0AG7N8ysqBV56dpCjnK2pKEu9KiYj02RtlhehlBIFXbG5RhRprG56rioYdMfhsV/3NLOfSIe7rIw5E5T8IcW3c5C6/nW4d7my666PXicpyqiWWebJP8AK4v/LP6T60tJ2K9JWGo+ISlCgNzota3l2uD7ixaITpKbK7/H9/yy9wREhmWLQhNuDc15GkMCFh9hSB5mqBKmgDzuWY1tKRtpBP/pxo9D+1WqHgprCGMxSbH8uvrPsvgZ0I9jD/JuBGJmtrwKWWBu//oJ/KfeAEzTcQtqiGfH7sIfp5sNFKM7CsOR08La5u3V8vUpyvVeLiAvMbYH8Q4xpr5VVqU3E/kn7s9s1rrQ2hMaNZ7F4asKuRp5rzkq2jZIt8VvOhvidEa1rfmNiAKjOp1q9649qVfmwgComRNcJ6gS6mlUZ2hYbddZl+SYhI7QpF3Aae3B4bX7lpxKrhxs8kmecG6r3ctwhVT8vAArjp+UqsuswRWT5xzR9UQXTA+RrlFwEJuXcA29CScFPyC/BqdYZ3dLICg++EBxst5QaJARrYES+tISy1AGaogQGMwjQChx0J0kzVpQAe77p4C6ktGg6JkDlkMc68EQOvK7MuSS8+Ob8oD6y8n9RofFymv0eY8ykKFhzM3Q4ny7DRrhdq7fgSCP5uUvs2GWA4b+BLRDsj8z5dBHrnGxvriwxl2Uw6t3gL1f3nBag8HD2H8TNQqWFf6LyPaVmbLrffNtTz4RKatoN6cdxhgC/wfsPyGv7D3KQwSWh6oKKS2W6hcNjbp4viijqi1YFCJk8FXg6bLCZVixhbb8/cMht2jdE0BWhV3sHp27wchVb7yuCJ44s4RqhHoSi0E1DO7kJZPOC3f6eSMUtL+P92H
 JACG/a3G
 fKtMdCAGPyW6ctBfzqckgUe4OhIVu6Q2CQ7vYo3Ph08p+spu61Tqh2lAy7qguWOQUVmJfKdQdT5SEPu+F0/BJTQwLDpSoNiq4Jv7+CigcBB4enPpWxlFomaZkfIdbx8y10XqnHFPePXO3kMplTQHCyZZUcEzT0oP4nCJ5XqxH69dsTvTDDG4AJ7mZqBp35JYCsTwzqlGjK5OJYJl0smipoqzw7br9/0VVjtRZUzk0kNclUam04BsqsvpItesgvJWyXkGLwuSIYh67zAFKY8bCU4p0W9aUX3SRuR5JlXxTBSSFue7YEmJCeQyZ7azI9SlNyNB/xRFGq0U+hc9dzGpyshkoZpycV1C6m1R4EQL2+xXgbleeI97ujXJbuxkDenFwQqr/bZ4bRHcc6KYaFBZtoNseEyqKUhZbdv6uI+CaHSE/FXs8LB7d9B46FlxhnJTyFehhgmWdcAzxuVzrV4nnf+wQ9S7udoqbgaQrA1QNOKTQKz4PKC2dlnVtvMkKDi1eR0QtDKtQ5tLad5R6vV06zfCfB1vICYmfqJaIssxyrQCnfyO7KOiqwzgf0oHyzYHWiJWDpzOhh7XbQ6Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/13/25 22:50, David Hildenbrand (Red Hat) wrote:
> On 13.11.25 11:31, Balbir Singh wrote:
>> On 11/13/25 20:09, David Hildenbrand (Red Hat) wrote:
>>> On 13.11.25 06:13, Balbir Singh wrote:
>>>> ret of type vm_fault_t is reused to capture the return value of
>>>> nouveau_dmem_copy_folio(), which returns an int. Use a new copy_ret
>>>> to fix the issue. The issue is not new, prior to this the function
>>>> called was called nouveau_dmem_copy_one() and ret was used to capture
>>>> it's value.
>>>>
>>>> Reported-by: kernel test robot <lkp@intel.com>
>>>> Closes: https://lore.kernel.org/oe-kbuild-all/202511121922.oP20Lzb8-lkp@intel.com/
>>>
>>> It's a sparse warning, is there any runtime effect?
>>>
>>
>> No impact really, it's just a sparse warning
> 
> Okay, then please
> 
> 1) Make that clear in the patch description
> 
> 2) Make that clear in the patch subject.
> 
> In particular, the current subject is weird. Should probably be
> 
> "nouveau/dmem: fix sparse warning in nouveau_dmem_migrate_to_ram()"
> 

I did have "sparse warning" in the subject and checkpatch complained that
tools should not be mentioned in the subject, but I'll give it a shot with that.

> Change itself LGTM, although I would probably call it "int err" or something like that instead.
> 

Ack, will do that and resend

Balbir

