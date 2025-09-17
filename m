Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76B66CAC5A0
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 16:32:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B11A08E005B; Wed, 17 Sep 2025 12:32:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC15F8E0002; Wed, 17 Sep 2025 12:32:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9622F8E005B; Wed, 17 Sep 2025 12:32:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7EC428E0002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:32:13 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 18BB61DF755
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:32:13 +0000 (UTC)
X-FDA: 83899284546.10.3BB16D8
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012009.outbound.protection.outlook.com [40.107.209.9])
	by imf06.hostedemail.com (Postfix) with ESMTP id 20F8E180018
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:32:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RTQ5S+sJ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of jgg@nvidia.com designates 40.107.209.9 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758126730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b32zUIOjVzOhyXoC1fxXNglfE2mM4XOaMSItNlitTjg=;
	b=wlUjaHC0NqpN80JJiOOJM+YSzo0WuyxJhavWkD4O1SbFXP157JuqYG6Ewo4LLKGYx07kD5
	2ZScXE+Hq/iWtp7lOQHMqx+S51VXyCK2mobrqvEHiAtyD6hXm4o4Z+1IJEhC0qs1wTQxDa
	nBVwEU4Dig06jod6uAwSr/bf32O5UMI=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RTQ5S+sJ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of jgg@nvidia.com designates 40.107.209.9 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758126730; a=rsa-sha256;
	cv=pass;
	b=qsIeQbgiSM4LGB9wuWuX0ePT2Cs5ONjYIaSK65XIYhuqI1by8ofdOd6ZUH068H7GWkykV0
	dButYGNZotm103OUp/AuI6NcyzsOuJFfAwrj6LRGZdFcY76Mn3q3H3DNZH/vfiqHoP13Xd
	k+yHA2nnvrrpatAbNkYGWVuoqsZPwcs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SmkYNZU+ANe+q60D0h8c92EyLF6KHCRrL1swgFViZlMSr9OJ6YYOKXCk6uEUOaYiOAcAPpLvk+9sRkobuMWKenMmW+rkDMZJjf3zitoitUo7nVAbKcxX989Gv2x5e9WHYGHXvVIOVbzGZOYkRw1gmBFhk3KPSGmsTqeI8COFacLhEIx0+y7hDfHVY2I20tpAfqdkqT8IbL3/T1D4PcVBCkOD1lqpTUEqCV5FIgH8WIrX6PcTomy/RM9UN2orhBkEM5FqCLnF4SnZ4Ow3U9dAeNzgXlgkAhQU7vR4Wu9+caO9XPIz05g+9EMwzGNEHAbgRlUPNBEAJmoP8cMaAqW8qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b32zUIOjVzOhyXoC1fxXNglfE2mM4XOaMSItNlitTjg=;
 b=TwAjnlRaR4FWISIz5A3ZFMyVdzsdCspt+R1MF58sOS/Vs6FZh6mFJcpekk5S7IpwoPvTdBMX4asn4xuQA+E5W1dtOm9Wol03BbZQGae+UmcfnOCsd1zvn6GqJVRIBbaZtuPeau9aa+v7vHb5goZCqH8IJn+KQY3tUNMkagJNXwXCd6cWehO3S1QSoszkPNVaPbpp25j0SxZy/QY9JYkhrr5pLhBhcqT/+tmC5fGNOnvixXetu50dT59Zj5/2hJjfwtM7SbiSU2v66y7uVDOpADbvOT6jljfwGjnMoRxnnWcKMZRNGgiw2AY5ZDBPg6OpKThS3zifwC9AO5MtcmDlew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b32zUIOjVzOhyXoC1fxXNglfE2mM4XOaMSItNlitTjg=;
 b=RTQ5S+sJVrNGsHr53VPQvic8okjugTSb5ih+eaHAnzpzKiZVfA8Fp2E7gTqO9WouATMpHoA3F2cGjT7PlZBWAzpIYnQ1huUEFYoy1oZsZfVOHGgZFt+GTSfnXalikE+yoQkr7ZDuYljNixR5cfiKGX5W7rO6bmo+A5fdplScJhdR8gqcqY+jFVyox6U97991VAOjwrfLaA8m22iZC2yM6MEQjWc9S8Lm38xWRnA8Lu1ZLu/9SbNYcbtqwaWp1CNqeRJU3wWOoIDY01L86jvBM0Q9/+LipSRbsU4C0mMxZfGAPSYKM+PHnuIhgDl+TckjkzOEoS40O78jO4FjUp+cNQ==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by CY8PR12MB8316.namprd12.prod.outlook.com (2603:10b6:930:7a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.23; Wed, 17 Sep
 2025 16:32:03 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9115.022; Wed, 17 Sep 2025
 16:32:02 +0000
Date: Wed, 17 Sep 2025 13:32:00 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Jason Miu <jasonmiu@google.com>, Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	Joel Granados <joel.granados@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mike Rapoport <rppt@kernel.org>, Petr Mladek <pmladek@suse.com>,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
	Steven Chen <chenste@linux.microsoft.com>,
	Yan Zhao <yan.y.zhao@intel.com>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC v1 1/4] kho: Introduce KHO page table data structures
Message-ID: <20250917163200.GC1391379@nvidia.com>
References: <20250917025019.1585041-1-jasonmiu@google.com>
 <20250917025019.1585041-2-jasonmiu@google.com>
 <20250917122158.GC1086830@nvidia.com>
 <CA+CK2bBbSSyCDAAgThDSSwH0WdOeHz-eVgB-1bdiwsDtTSE5pg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bBbSSyCDAAgThDSSwH0WdOeHz-eVgB-1bdiwsDtTSE5pg@mail.gmail.com>
X-ClientProxiedBy: BY1P220CA0011.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::11) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|CY8PR12MB8316:EE_
X-MS-Office365-Filtering-Correlation-Id: 7627c97b-2de4-4c26-3b30-08ddf607bb6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NFJUWFJiOFpQVjFUTjVyNTZ2VlVuYUFnVEc2VHVScGtYT3B1eGlTRDJyc0Q4?=
 =?utf-8?B?Rm52Y1BubFFaMmY0UGpZV05UVDNDRytqYUI0ckVWbUs1OGIxbk0rT0ZGZ0tZ?=
 =?utf-8?B?cUVnbTlxRzRURU1jMCtuMXI3TWdSZHpML3NzTmFMa0NmZTI2SDU2dkhGZ1A4?=
 =?utf-8?B?aUhwejJrS2RPSVZhV0l6dE9PaUJCRTRVWWZUMTZYZUdsRnJiVml3Nzh4bS9G?=
 =?utf-8?B?cHNaQjh5QVNUc0owcjUvek45YldsVGFmTGVvM3lLb0FZU2lGZXJQNzJiNnlD?=
 =?utf-8?B?dlUvcjh3ZFJLdE5sTE10Y3YxSCtsdDVaWTJuTldhdCtNZmp2OFRQRlJBNDQ5?=
 =?utf-8?B?eHlXWU1pdEJ0bitoY3kwYXA2Rm5RZDZTVEw2NWRMaXYwbEhueUdWY0hTQmJR?=
 =?utf-8?B?VC9ZRG1tcUszeU1zTStrb1M1NzI5M3BYN01sSkFET3p1SGtkaGZhZjM1eC9M?=
 =?utf-8?B?VEthYi9HaThyK2xpR2FmajIxM2dxeC9EMi9SUExxQUp1K3k2VFUxaUlBbmNY?=
 =?utf-8?B?NXBwT0ZDK0o4d3kzT1BIbUpOSkhNcXoyYi9aT2t2WE44Wm5UL0hFK3JyeUpU?=
 =?utf-8?B?ems5RXZRRnJ5WUZBYUM3VE1XaGJUK0lVVUh4OTRWYm9NS1huV3ExZnR2eFJa?=
 =?utf-8?B?Y1MyODluODByZEhHMTMzRjlRcm9OOVNvT2Fzc3lBcHRYOS9pLzJsaXExRm91?=
 =?utf-8?B?QlJjWjhXNmpLSVZFZ2hMVXFBZExVWk1CT1FuQ1pXZVB5QS82d3pxcGhCZ1VI?=
 =?utf-8?B?MldseTdUaXBhYTZ6QkNtZXpQdVJZeUhvR1hhNmxTeVRkTm5uaUJ2a0JrSlpl?=
 =?utf-8?B?Q1JWbjJodWJ1S2ptY2lzRkxScllqbWJIMmJuTFpZWXlEYnhMSkkwc3VuKzRv?=
 =?utf-8?B?SXlFTHBGSVI4aUZZcmNEK3pZY1NjS3lvRTNsQUl3NTkvMUR4bzBDSHdlUDh1?=
 =?utf-8?B?VTJxQUlybzVENTZySExEdkZQL05kejI5ZGkyeGRLQVRwb1ZxaFlTL2RvbUlC?=
 =?utf-8?B?eHRxQmViNnpMV3NNNTJnUmhUM1lxWGZ3eHZOR1pSVS9lQ0NuVE9DSHdyZE5x?=
 =?utf-8?B?b2pnb2tvbVJpQ3l3T05rd2hkYVl2ZnhVWG9XbzJUSmlJZElTd2hGdzlwVXhV?=
 =?utf-8?B?U3hjd1N5T0dxby9JOVZBOUMvOXYxYzBydjc2WFVZR3NCNXJ5NFE5eHVZL3VG?=
 =?utf-8?B?YjVFN1haUWZDWXQxZVg3RVljWFpjS2JialVHYTM1SE9wYTJIbnBzSVN0eEpN?=
 =?utf-8?B?QWQ0TEdHUlZmeGY3bFhqcnF3UGNqbUVUd0l4ZVZMNU9xeGJlWmpoOXYxcXpw?=
 =?utf-8?B?aVVkOG40eTlUM0NMM1dCQVh6YkJZWVd4Vlg5L2haMCtIdmk1MG9FWFBSZm4w?=
 =?utf-8?B?bm9PTzVPaDczYnpPdC9pdWN4eGU0ZE9CRnI1ckZLY2lzd29memtsUGpuVEtj?=
 =?utf-8?B?cmdaQ2xyZjNZTktXaFYxL0JwSFA3UXhGZlh5NjlUTEthOFJhNXlXd1lKdFB6?=
 =?utf-8?B?T2JqZjc3cDJHa1NBRkEwUklCVnRkZTFVOEE3ajc2LzhkaFg4RHZFRklSSkRI?=
 =?utf-8?B?T25PWUZtZGRSdGF3ajZ3ZFNaR08rb3NwRW14OEhxOGo2dXJmanUwS3NaOGo4?=
 =?utf-8?B?WmF4YnoxQllzZlA4b0oyOHBVSHVYK29mc3BIamg2WU5KLzVLRVVESi9ISE5Z?=
 =?utf-8?B?UUVhRGZjK3pHRVE3K1dNL1o4MEJvaVJOZmNkVjY2MU5neU1sR0FBM25kYzFR?=
 =?utf-8?B?aC8vWmovaWNJUU1SSk1keFJKa0YwcW1BNEx0MzRBMDR5WjdnMUh4T1hwRjJF?=
 =?utf-8?B?UStyQkVsWWRTVy9wVEY1MDZDdUo5emx0WDFVT2dWTjdJaFFCU2I1T1Y5bVNZ?=
 =?utf-8?B?QUpmTkZnUGdTOENnT1RhUGg4RHZGZWxGc2R5MmE1b2xhRGdyWVNWOTlvdHQ1?=
 =?utf-8?Q?w9Y1qxNyDrY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N0lDb2ozaWtwaWdFa3RzRFZ2d2RoL2ZhRDlHNVdFZm5HOUp0UG5lY004dkdV?=
 =?utf-8?B?RDJMZjBkbGNtcTdmMEo4Wm9aaU5jR2NXMDJjeDNPS2JUc0llZURwK3gxS3Qy?=
 =?utf-8?B?ZWh6TmNac2lLYncvUlRtNkNSUHFpcnZqdmZCdVl2ZHM4cStaMTM0WGVGQWlW?=
 =?utf-8?B?Z3NYS3ArQ0cxWWZiOWx6eHRHeWpOR1dBaW9tMWJpdVNIOXlOazNjZGdSMDA0?=
 =?utf-8?B?Y2lqQXNBeFV3ekZKRVNlNU00OGVqdFBoa2NZNWlMSUtJdkU3dkhTNHlmbDZ5?=
 =?utf-8?B?MHdwNEdDNG1XZzd4RkRuUThrclhaK0hPNTAyRTU0c2FlRm9XRGRSNkxsVExp?=
 =?utf-8?B?S0hBam5NZmpqcGlhbUxlcTJ4RXJ2YnZ1YWROVE1LN1JVQ2M5UFliYU8wWG1h?=
 =?utf-8?B?bXAwUXdGUmEzR3JUNWx2d2pkYlg0S1FKeStpUDRZbW9QSkpDcEtCS1dvdm4x?=
 =?utf-8?B?RDFqem0xVXY2M3pWTW5FZ1ZhdCt5T2RmRHdZdjlEQi9nNXl2VHFEQWk5Qjlk?=
 =?utf-8?B?ZXhWcm5pVFhFVlhLNCtNelNkR1hIZ1Y3YUJqZnIxKzJSS0UzWHZvWUJ2Smta?=
 =?utf-8?B?dE9ldmo4S0sraXRzb2Q5TW0rUThjUm5zazhOVzBWV3hGaDFPOERZWGhjem5Y?=
 =?utf-8?B?L0NhWHhIL1ZTNlpJcmU0ZjhqUmtjN1huTzZ0d0VFOG1sek15TFdGRU4xMk5T?=
 =?utf-8?B?RExHSEUrdnRYNlMxdzVHdkdTbmVidEdvajRyU2RaZnplZDNEWG95N0xUK0p5?=
 =?utf-8?B?WWlXYzBiMjdFeUNWZkVXdUU0MGNwTXZ0QkEraWlNKzlRcTlhSXh2QU9JSHNJ?=
 =?utf-8?B?TmpNRzNQS3RHQkw5OXBHc2hSY3JZNmJPNm5ZTW4reC91bEJRL1lPTU5xeU5q?=
 =?utf-8?B?dVFrcXVUTDVhU2tPb0JWb1VsUTVCRGloSys4cll6SzA5M05URkhaK3FRZXY0?=
 =?utf-8?B?MGhvb2RtSjRNbFRDV0E2Rm5DSTlvQ204VENTd0cvUTdQTGQ5Q2xYN0g2Uzdj?=
 =?utf-8?B?aStOTnhjQ3ZlR0pOUnNNeS9rQ280cUtxODlsMDBpRXNrZFdRejNlUC9NZktv?=
 =?utf-8?B?RnNTb01xV1NOYXAwVmozdkRuUDh1U1J2UUtPNkcrWk5jb3V5czdIQWpNaE1E?=
 =?utf-8?B?QXYxVElBVFpHbkw4VDBIQWRRdGlxQzR5MzlWWUthUE5sVW4zVSs5UlAwWFVh?=
 =?utf-8?B?RjlKOExlSWF1YnNXbnJHWVZZYVI1TkJwWjBLRVdpMWt6RTh2K0Q3ZDBGWEpJ?=
 =?utf-8?B?RVh0YjBlbS9oUWY2T2NlWCtxVlowV0dEYmdOS1hLbTZwRDA5MnJYTG9zL3pk?=
 =?utf-8?B?d2FUM2x2QnZSVmhpcEhKa29UTVIwbFpyejkvVzdEa0xZVW9WaUNpTVl2WVdM?=
 =?utf-8?B?MGU0cnk1ZHowMWhxdmFHb0JHaXBUbHY2dHV6MDRoSHBWdWdJQUZiVUl3SWtN?=
 =?utf-8?B?d2p2MTVzYVVCaThoUmhKYktEUWtIZDJMejYwdWs1djBVLzY2ancrNUc3K3Ns?=
 =?utf-8?B?bmQxQjRPVzVJME9sWkoxUWcvUEQ4WmNjTmV1Y3RYRWs3K2hnbUk2QXRQRk9G?=
 =?utf-8?B?cG0xQjlpbFFtV09XLzczRWhMZFpKeE10c05sbGJGK3VmMU1RREgrZEFpZ2Uv?=
 =?utf-8?B?ZlJ5UlBva2phYWQ3N0pHcmpuL21QTjk0UmRXSTMwdXJIdzVvaTM2S3pONlRx?=
 =?utf-8?B?Rzl0Z2FpbXFKNU9NYXZKclNyWXVXQ1Q4RmExb0ZxZHFSY1FvYlZnZkp2NmZC?=
 =?utf-8?B?RTYyaEpYODFvbWZHR05JMTgrd0EyR0JXK0pwZnVISm5pWEFwOThKMXZ4clZW?=
 =?utf-8?B?YXVGTHM4YldxYkJoWkFlZWViOTN1TjBmU0wzY20zK0NpdGxVNzN0MW80TU4z?=
 =?utf-8?B?TVRVdmxMSGtxS0RiVk9DOVRqY3F4MjU0WXkxSjdBMzhORUdxdWRvU2dCT0FZ?=
 =?utf-8?B?b0VKN2w3bVhDd2dDZnI5a2c3M1dNRjk5QjlPWkE5cnpIbDFBODRhUmtqOUdu?=
 =?utf-8?B?MHVZNjg5dzlJWVRUalFsU09XTTQwazNWaTVPdS9GQkJUMWVKYmozMkw2VFg1?=
 =?utf-8?B?eS9kYWdDV0t1OTZmb3FSbmlZakc1eWxuM0dsaFphM3VCWWp5aWU4SUl6S1hD?=
 =?utf-8?Q?DNz6BRs1qkd6ji42y4HX2+t/H?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7627c97b-2de4-4c26-3b30-08ddf607bb6b
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 16:32:02.8273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E+8aUUqV6a10j2l/Ytt4P2MoWvAnQw8RAl0zJGRneEIgPdyriVlIVr494ucPSYLV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8316
X-Rspamd-Queue-Id: 20F8E180018
X-Rspamd-Server: rspam05
X-Stat-Signature: yfgqm13fb9wabsqw5u6hnfzy3z4wskry
X-Rspam-User: 
X-HE-Tag: 1758126729-894908
X-HE-Meta: U2FsdGVkX18rLfrTj/cQZ14s+0hg+LfvuORfEbj1BnLd71ouQREYXRNLf1C42fP1G1pgmv3QNFa4mMHt/VWLYQ6A1mLbncigRDOUJXgLVfBSVl0zhS8hg4am7LNYLcIJ6jmJvPjxLA9ytbXn0N/omnFn7Wxzndm037euPOTSnUbtxYQOIw4XxfX9OQKPoyfik8Px/i1SlBHU0mWRbYkA3+Q26ZH8Yrrwuih9yEbNbBHtKPE4yuoB2hsL4OLDCx9H3+uGBa13W8H58lC0IK7PQ1iYZ49wR62rosuyYlDYujQn9mlVXjDs4hyE8sCr1knFFLwKR5RplEVsn9NyKr7NXADTIpqowUkHhKg2b3LQoScPmSDyV6+mHXdVfMZ4wJ6s42YvDcrKPcEXO06oUvbfMySla1LRLIQSdMhS4od18NB3ValoqaHsekjhXjjz6jvQJSUwZF1+tPEfkXsOwyjgTQMP5VlmYastTGEzMDHjIcOHj9SheRloZvHitWYyB303mfsG4BbVKsgS0z+v7quaFypLhhpPRfCOjnYWJEJMIyyfOJc2OUSVpFkdxqYPgw/p/C1AVXH0AGqxe0M2RwOKnU5RLDFi55l5qmaH8KZb/g0cxm1PCeq0/HgslYh0PcTKYDBiBwO0ICIouWRMcd5DjjLmf0LkB2+wMjFUzP83B7JzSCh9K9Gud4W31QI3K56r9c3N8gaUgXhIP9SQ5fl5BSAm5HY+XdGGrqlyEsWFZyPU14qXEx0D1MsLoqK5zJKkKHysoigpfC60Roxm6p2a9wTRmtF8bE1T2Rm+JD1ZAZn7ntkpnWJUeRB1q40KEu1tt+B4Y/NDDoGqjhfnYCirwhxlBSJKUvJelnFvlKXtzz3llyiknspHPDn4Q0v+cNTzq1o2T/Jqe0MHPaav6Nb5vFl7M/osmQGQD3GNRGZnauht3yriAcCHWoIOgPYIm7GPqzoxnabADpXX/t+K6Ly
 FePMh1s5
 EAACx+hb1IQxRhA4nBqFWFxboOSDE5IQ2OG8yyKjHgIXMEVIyYOXx/cpsDvhVFw0hAHECCcffrkeGDB5MSSQM8qycemSQQL6S3B9JBbTD7+Qyibey6hLMkOqm5ev9SZHY6UbQjcHl0J/z9y2WQ7Cyb+xodyLpfgBhLyhdQ3Zl78ZUzBbxarZzuhDBxsLqpH8WPzxajXaWLFcZeL+kK1GNC2GAyAgKUcQaeB0IXizLfOv2vF3a+4BAPrWDbIZ5ugXP2AaS3crAqRJ5SnRe+1a6mNl74nxABCuCJbGliS4We95RkHMCA0Gifel8CejZRzWOt0NApjXedJBLavxC/YqcQG0JnxzWOK7wuLkcmsHh6nRb9pGdxzEvKyS/3DEUHL/9GV/ihVTKpABXGzQtrDP92j8kWnnWy1RkqxFxyGicH3ivGCUAYH2nogl49sZkDww4bCsD/wtA+qYq9Yj77tI1gN1kRTjDzqOhDTfBTCjux8Eu7+p5s6+oent0QhNUpsrMYRnKP4aINeGxlZ3F3SPhBQVv8VMhsLVzKXobKB6qTJNTXLI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 12:18:39PM -0400, Pasha Tatashin wrote:
> On Wed, Sep 17, 2025 at 8:22 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > On Tue, Sep 16, 2025 at 07:50:16PM -0700, Jason Miu wrote:
> > > + * kho_order_table
> > > + * +-------------------------------+--------------------+
> > > + * | 0 order| 1 order| 2 order ... | HUGETLB_PAGE_ORDER |
> > > + * ++------------------------------+--------------------+
> > > + *  |
> > > + *  |
> > > + *  v
> > > + * ++------+
> > > + * |  Lv6  | kho_page_table
> > > + * ++------+
> >
> > I seem to remember suggesting this could be simplified without the
> > special case 7h level table table for order.
> >
> > Encode the phys address as:
> >
> > (order << 51) | (phys >> (PAGE_SHIFT + order))
> 
> Why 51 and not 52, this limits to 63bit address space, is it not?

Yeah, might have got the math off

> I like the idea, but I'm trying to find the benefits compared to the
> current per-order tree approach.

It is probably about half the code compared to what I see here because
everything is agressively simplified.

> 3. It slightly complicates the logic in the new kernel. Instead of
> simply iterating a known tree for a specific order, the boot-time
> walker would need to reconstruct the per-order subtrees, and walk
> them.

The core walker just runs over a range, it is easy to compute the
range.

Jason

