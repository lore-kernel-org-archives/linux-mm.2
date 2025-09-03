Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32200CA1007
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 01:20:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83D208E000E; Tue,  2 Sep 2025 21:20:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80D588E0003; Tue,  2 Sep 2025 21:20:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D54B8E000E; Tue,  2 Sep 2025 21:20:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 572108E0003
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 21:20:24 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 12D4585BA0
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 01:20:24 +0000 (UTC)
X-FDA: 83846183568.03.0A88BD5
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2054.outbound.protection.outlook.com [40.107.92.54])
	by imf02.hostedemail.com (Postfix) with ESMTP id 34BB180003
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 01:20:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hGH7A5MA;
	spf=pass (imf02.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.92.54 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756862421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bsxabITWCDNliLb2Qf6ZIQwj6vqvFNnextKhJufStxs=;
	b=ba3PG/DyWR2/rVFAxGRl+lAg5/M8IZMBxESpwMZRNKpYsh75ypkrk7WREM0U2yDpDWqvJb
	M9mUCMBl2NEJlbEKAR3nQxtWST9noWC4VdNo4EnNm+jWWbiZMBNvVNvSHxf9/l0JqmZi7L
	ZxWpyxmVwhTcYi6txsyR6ugNcZWqdQ4=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hGH7A5MA;
	spf=pass (imf02.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.92.54 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756862421; a=rsa-sha256;
	cv=pass;
	b=EKXY51X7Y7MaQtV5Byl9SjgpgW1NGjann6IuJhtOM/CDnTsC41QA8PHzAQUymF9e763L5d
	OUYYdoFdV6wETJX6KhFb3pPNib0hU9eeX8t10KsTdO4isn8huQZlosqQso9yiJRe7Pj8hD
	IPIWrcM1ta5MORp+ubZLVthRsVFZPQk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bC446KWBoPsW4fFgX2jUNtpKmohWirFRudSj4HChiQNtoddIRq2pC1+zYvHIc32ffCnQmZ5gAbLdn9/KsrRbF0GLEajyDnYidCreD1A9Vm0RN6gvrf3veQji45ZAFefP38irHnOia/O6Dr5DAFTBjKYQx480NykKUjOjfeyK1lrhtAtwzDIBKo4ddI11IcOJXldXt1FIHB8lLlJ/TjLBAnz/yLcThkiuLPdpzSvSJDfc9Tf/1QGtq6e6+Xrcdu/OSqz1Fyt7cp05aYneexxEq4p66Sx78qLfm1YdBuMXvgfErousShoJQie5r6x8DZiPmFu9LviboF57sXCsmCutWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bsxabITWCDNliLb2Qf6ZIQwj6vqvFNnextKhJufStxs=;
 b=A90jPesIRpbuCeNeMsu0L7VKRMDBUkyAbCKWyUbsXJ2YeZpwNa/LObBZ6XO63bSndM93LSS4eQKoT6PxJSJQjRcQL/zmA8IPdm6AaAGjmHEV4vtrKSZwdmOAM7QJjiryYfQy9qGwyW1Itu8u8Q0G0SGOoDMxErPEIUc4Uo2/8U+nfb2AxTt9CDfKKIWV9SW3nRd5fQgmp3BbCZ2luY8WcSXpqmIhx6161JwYojVUo0XMSYJaCchr8U3ZubGVP5UNU2DR1K5j6fWHuimnTDl6XUI6hJ3bZWkW6li2MAG8F2mwP4Au4VO5n7F6rkKNaovfngrY5hnppwX0h5KPmmwvBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bsxabITWCDNliLb2Qf6ZIQwj6vqvFNnextKhJufStxs=;
 b=hGH7A5MAy8BOW6Wxa1wH5J5Hy25bqrAOFfpsvtaYL5rl0H683gAMKh9BgPM7SiwR5y7K/H1W80Nv8GuzhY9ft0BkdWsn7O/IqIDonda5f69pue+1L+qf/BtuwKPeZjaWhx9cjOtg9Fscamgpe11xrdRsYEEKtKPo0A5tvjFxXb1DzQQFvmHimAkXxEQFJBYrhRmm5/vmewLfH71T3CM8FHqVX1tgrPp7jWN0HtcSVqTH7Gzv4nOyjOciAPpTSH9gWxolcplFDPGVlLAIQIvEtJTGxhd1XR41uuLe9Q1NDNuCBQn/fB+5JEAm+Zi4Z9+GaZuXzHbZ0GjFoy4zcUhrMQ==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by MW4PR12MB6708.namprd12.prod.outlook.com (2603:10b6:303:1ed::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.34; Wed, 3 Sep
 2025 01:20:08 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9073.026; Wed, 3 Sep 2025
 01:20:08 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: damon@lists.linux.dev,
	dri-devel@lists.freedesktop.org,
	Balbir Singh <balbirs@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Ralph Campbell <rcampbell@nvidia.com>,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: [v4 10/15] mm/migrate_device: add THP splitting during migration
Date: Wed,  3 Sep 2025 11:18:55 +1000
Message-ID: <20250903011900.3657435-11-balbirs@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250903011900.3657435-1-balbirs@nvidia.com>
References: <20250903011900.3657435-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SY6PR01CA0017.ausprd01.prod.outlook.com
 (2603:10c6:10:e8::22) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|MW4PR12MB6708:EE_
X-MS-Office365-Filtering-Correlation-Id: 87fe22d9-6fbd-4d32-a95d-08ddea880567
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TERIZ1N6NVVVeWtmaGNhTTdITjMydHROOWkyVTJPRWFDZFJoeEFUK1h2VzdY?=
 =?utf-8?B?MEVpLzVVbVJzQVlSNGRvQ1RrVTlUN05VckZoN2dZT0cyNmlmN2pHN2JOL1B6?=
 =?utf-8?B?a3NTUDVBdTBRN3FPOXBlaE12enMvNmpSU25wOTJjSDMxVndVaWZRNU53ejZX?=
 =?utf-8?B?ZWVjTW5zUkxEd2RGdm9UZVQwN3pKamg4UGVnZlVDaVMrMXVMeG0xWExWbE04?=
 =?utf-8?B?ZHhMTnpvanFCaUhLRi9qRTdaaVVFRWYyZkkrSWdjVEJaNEN4QnVwQ0V4M1RK?=
 =?utf-8?B?OWJTUVJLdDhqdm9TWWd1N0ZIQWdQeC9vaVo2VXFhN2ZIM1UrYkpoY0JHeERw?=
 =?utf-8?B?ekRvdno0MllMR2cyV3VoRThmVi91TmpLMkt1Uk9HQTZ6bWgwMkNRaXFtWlRM?=
 =?utf-8?B?RzRmZWZGeHhpaWVKdk5SSzFpZWtKelZCdlpONjlQVnU3d0h3T2ZPbU5GOHBj?=
 =?utf-8?B?YWFTWUJwQWVGSUZ1NEpvM3c2ekMvbEpyWmV2NVpIdTZSb3BuaGtlVG45UGxR?=
 =?utf-8?B?OGlHTlpMTW9Ya3BxYzNDRFZuZms5dis4THdGeC9LcmEyT1VvbWRXZFA3SUln?=
 =?utf-8?B?WkRtVWVYNlczQUZCSk43elkwOTNLSXdwa3FGb1NFeHhSWmRLY1J6elV2NW5z?=
 =?utf-8?B?d0NLbEo5M1lLT1ZsM0pFemJLN1o5SjZTNTBUeDBYN3lUR1k3NkxocERzRUpO?=
 =?utf-8?B?d3c4MURhUWxtam1WQ2Q4UVdZR09za0NoQ2FWQlN6Y3h5WitlNlJqWTMzRVU5?=
 =?utf-8?B?ZVBPUHltWFJYb2QxSlhKVzdXL3RrakpVTTFOMUxBWElqTExBYktZZDJ5REtP?=
 =?utf-8?B?MVpMbjlqL3c2NjdyK3RJVHhncERVa2M3ZGVzOS9oODBFcy9sWlhXWlBYTXdZ?=
 =?utf-8?B?d3RhUVlOVDgwQVZoamxRYndCYkQ4M0ZUM2RsMDlld3BKellCeEk2UG90Rnc2?=
 =?utf-8?B?Qm5vS0pDQlZxbmRTVVREOGFWUXFQTDhBUWhCdWpWZTVPVFpJUlVsYmsrMDJI?=
 =?utf-8?B?TFlCWDRlbnIxaHdKajZLUXZyR0ZkVGI3MkdoQTN5VXQ5UkpoSEdxMis4NFVx?=
 =?utf-8?B?ZXpHYnoybGZCNUQwQTZacmlCWXp1bkd2VEYxUE4zelJyT3ZSTUFRL2VuWmdM?=
 =?utf-8?B?cU91VjZreXhnK3o4dEY4V1FleFRwM3BpY2N4Q2orYUE2NzZmUUpaUzlZeC9z?=
 =?utf-8?B?RFdmUENjRW1oU2tMZTJBdTU1YTRkc0hOekpOUEpCQ0NDV2Z6QTZMN3RwNXUy?=
 =?utf-8?B?b2taVFB0bDBNUTVOeTRHUjUrSU9lYWppYmo1Tyt1a003NHU2eXlkWXRPZTFa?=
 =?utf-8?B?QktEemNVc09hTkdjcGJDZFF5S1IxQ3lFa1hKb29YTlMyblF5RmRraG5BVmpu?=
 =?utf-8?B?WTlqMFlad1hBMWJuRDdYN2xyQTFsSG8xejNkRVZzQnlPZW5UT1VVT2d2U0Ry?=
 =?utf-8?B?K0p6d3owN1B6eFVPQTlBLzVlQjNsWStFNkdBQWlzdEowWjhOWHMvTEQyU01n?=
 =?utf-8?B?OTFSdWllN2hVOEpaa3V4TDFwZjd3MytsaHRsdjEyVjdIeENFQXpEc3hRR1Q0?=
 =?utf-8?B?cWxZWldSK1dabDZSSGlxaFl1S2pIZmFrcmN0ZWpSMVFkeERPTzI4TXhwcTY1?=
 =?utf-8?B?dUtHVXZ0UHRhWVJLZkEyRm5xaStEZ0ZHaUFxdGh6T0R1QVRPaW1ndStPNndU?=
 =?utf-8?B?OEViR05KMHZBWDVHSTZ0TFlwRTQxZ2tuLzk0WjU0aWI5VS9EcTlqTzg0Z1Zj?=
 =?utf-8?B?M1JyMDBGN0VRTzQzcHdjR3E5WmlNR3hNVHlydUxyMjdlTGNaMUgrUTFjWm01?=
 =?utf-8?B?Q1pYVUdGSUlPeVhHVGpxeU9zSXVvb2orbVRMSkFodDFlUzZiTFVPUHpqYkRi?=
 =?utf-8?B?anRsdDRRd3pRWVU2Mm00bkhEUzRnenFTMXpqVUtQclI5TlNyN2NWcG5FYnM1?=
 =?utf-8?Q?YWFFAzvFBv4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Yzd2Z0ZQakd1dW1BbzU4NlkxMi8vQkZYOHZnTUpENnlac3RGcEt3S2t1c29k?=
 =?utf-8?B?dWxvaUtEV0poRlhXUlhUeGRkRkc5ZUc1ZThKSkFCblgvQW9wNG4vOHoxTXRa?=
 =?utf-8?B?a01jNlJUQmJnOEk3Qjh4bjVGTVFlTEc2T2tpeU1xMlpEWUQ5eDhkc2s4TnBs?=
 =?utf-8?B?d1VPcXJwL29UcmszaGFIWXpHTWxaNVRFRThMVHhKdEQ1eHlpbGpQWEZOV1lM?=
 =?utf-8?B?VUhaeThEMUJXaHhjTG1MTTZNdEt1YUZPRXFMVVg3YWRoZG91eHU5WEJLVzA0?=
 =?utf-8?B?N3NpQzd1TTFHRC94cWt2MURzTWdIVkxDOTFrOUhlUTVkM0VlNUd3WHhLYUpo?=
 =?utf-8?B?cnd5Zzg4SVJ1VW4ybUtnMUUxSy9ra2JGakxFckNvVlhGdGtUVHdPdCtIdkVr?=
 =?utf-8?B?Tkl5V0lPV2twb3ZOY29PVVI5b2NnYUpoY0QvRkVIR1Fqb0NqWXBMbG9ubFRu?=
 =?utf-8?B?UTNCYXVlNmZ3ZG5BK0NOL0NKZlVDNjg1SGlnUERlRVFWRjVkZ3k2R1hlVmFp?=
 =?utf-8?B?NEY5UEhMRmlOZWZIQTNyckZQbThiM2JNZWNTQk4yU2docU84RUo5eFB2ZmZF?=
 =?utf-8?B?SllWYk9uY09XSWJVZ2tibWdDclNuK0JLSXVNUlczMTJINFk1VzBFU0NMZXJC?=
 =?utf-8?B?Q210a2RCWTJ5N3p3NlNWcWQ1RFowM2Q3cXZta1gzeWhpdDMzVWp1ZnprazVG?=
 =?utf-8?B?RXJDWVNaTUNCS3JpVWRKamFkMW1IMUpsRUJ3UGFidnFWMGRHSTZZVmd0VU5q?=
 =?utf-8?B?WVZhdU0zb3IrMWt3ZVJzbnZWL0MzNXJYMGM4bFRIWWl0WnpxSGVWN3E4b0dh?=
 =?utf-8?B?WjNkdU95QnM5SXIrWEZFRXBHMXNVb0JOTG5oalFTMXNRZUZwR0hXTGd3VWdz?=
 =?utf-8?B?Y3lsZjZwZE1Gc3haUTJlQ2ZvM1A1Zm5hRjNmN2wrbyt3QU9ReHZnTkhWdGhv?=
 =?utf-8?B?L0xZUTVKRDc5Sk5wR3pWN2NhcVhzK1k2OTd2QWNkU2piWTg2Ym5LVDM3a0hH?=
 =?utf-8?B?WWpoWlllUDhwdnZTRERGMUVodFVKUzdtcVV4bFNtNTR4dkZOVXc1K2RCVmVK?=
 =?utf-8?B?TUxKRG4wUGlEc0lHM0dyeFBrY05PTTNQZ1RXY3VFZnZPWjJ1M21QMU5NcVd2?=
 =?utf-8?B?dXppbkV6aVMvS3hQTko3SE1RSkVaWjdDbFJBQ0piUEI4NjNYRHRGdTJMWmNn?=
 =?utf-8?B?aHV6YlNaOWY3d0Y2cDNlL1gzQ3ZLa1JkU3ZIcVFPS3dNeVR6ZWlGMDFkdS9x?=
 =?utf-8?B?cUMzTkoyL0ZqTDNDNURJMk15SHRkMXQ0bGIyNzV0VWh6b3ZMVnRRTjh5dFdT?=
 =?utf-8?B?L3NaZjlJMVBBTzdCV2JFbkNoOGQvQW9DSzVxcHdTVlFTMGdrR1RnM1diWHNF?=
 =?utf-8?B?NlNGc0pLZ0lvQVptc1N0NmtIdHR1QW5GVEhsVEV5b2MrVjA4TS9jc0s0akhX?=
 =?utf-8?B?VWVRSXhvbHpVQ2h2ZG92bWQ0UDlSTE0yMy9mWU8wc2hpQnFLMmRTN3NibHF2?=
 =?utf-8?B?T2RHNWg2eHdDY1BLd29PRjVtZVNDbjVxeDdmVzQyL0NzTnBaNUJHOVJRT0to?=
 =?utf-8?B?QjlKS3lxVzdwaGFKVU5oWDVNZmxpUUJKSGpxdkFlNTVVWDVqNE1xK00xbGNM?=
 =?utf-8?B?cjM5T3lFcXo3WHJWNnlvUytnM3JlYkdCeTAyU3EzVDN5aVFGR1pBQnlwWjVa?=
 =?utf-8?B?QzJVQVpXU2ZsbFVtd1BlS1ZsOEtlODd5ZjU0SjM0eTlNWVFYZGdmWmswSmRw?=
 =?utf-8?B?USsyckZFeis1SjI2c3pyeDdURllVR0w1aUhndzByZHA5UWJQWlh2T0s1YTF0?=
 =?utf-8?B?SjRSbEs0bE1XMlVKblNNV0MvZERRamh0R2lJQ2grSkNHREV3MVN5MWMwT2dl?=
 =?utf-8?B?OTJCc0lLK1lCR2FpUnlGajA1Q3JXWXFoUEgyWWo0djRqMXNCVHo4S1ZUZktL?=
 =?utf-8?B?a3VjdmliNnBlZkVJWTBMTEFFdkovaFNJVEorcFZ6bW5UWmxzQnNLRy9rNmZD?=
 =?utf-8?B?bGdHRlIrZWtGREM1Y0tPVml1eDd3cW93YWo0M0tyVzBrTHlyMjVkSFRhVE16?=
 =?utf-8?B?WjUwNWxXeEwwZy80VXdycDlmUDdOTmdQVWdZcFpoS21NdDl5NHFkOGFJTE5O?=
 =?utf-8?Q?bzi9mVeh8LIW+HiEOqtWDGJZt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87fe22d9-6fbd-4d32-a95d-08ddea880567
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 01:20:08.6442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8fJVOIa7b+O9y/v/MW5s/QLWNu2Man1+R7FRojs695iNxIbKOpCAmjCJDNj5baliovO3DEFIcHW1wbxk6up6Ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6708
X-Stat-Signature: ktg3qo1h6byaq4eex6xwj4u111pjr13t
X-Rspam-User: 
X-Rspamd-Queue-Id: 34BB180003
X-Rspamd-Server: rspam05
X-HE-Tag: 1756862421-177047
X-HE-Meta: U2FsdGVkX1+vDix+3od2bCOQPaFKdb8zC6DFXmNMi78DFWwqylxdAV63gQdfA0mWYYOwcZ9GU2jp9lROz4X1VmVG3tBLAg04ZJx1T5frZOzsBINUoJUhKuKfVdqhNUQhpZke/e9YIB3gKvHue8Rf7CV3WZTGAcgi6RaYWTiGy1b6Psh9iaGOtVL3XxtTAYodxVDbfUNAedDss6Exgmc63n6m5jMmgSrA2nhTY2wg7i4xWIOBXMFR3cxA8sSmx4EtATvz4sbKilo8ReAT4DDPSYcZBcEYvqMd7zsNiQ8MANxO1RCrI/rGyUv6eBioho3ryyAJOSvQ/FwhmuO0NWJON9waojD1DumxaLfbA4DF9ouyvAFgtY2gzrr8D8oCXN0yc5aS3X4ghLhwwfceyffZX1+9y+CLDIKShOZO/HuOrZFJ/RVYVVpIuwMeiWqU/FZmwzvtoIppw0qTEFiJFtEj7mVXVkOMypOjjbxdLdjE9E6IMHGIPdJRAGewGu01UFgdaN48vgpMqLUnLiIw+g4glnSQoUp8FqwSCumNIDbXpxnut3ixLS1BUxZkPT0+WHKaFflmPq+G/R2r6DMc8fqIO6w6ckb0rrw8L+cXrC+ihSWq+0alXLXGo8bwmjUs0ZZ2Q1KS/Eo7l8dcMOnjT4b2LLRH0y/1hQkRenIC+gZxF+/awHVNYvmySchx18rmprSGqR87gJ0RqVKonsl897RbSL0JaaUjj6zygcYWi+tHb3f1tC3LOYXiTB5Zmrm3EZ3r4YHUXmZ+3vajaPY6MNUeYOE/8LZ3QHLsvf7a7A/Ex30LKMvzJ9L8efR+3WIoA+30VmOkdiGnC5dB1kSu6y04xqCBvbhsaqmcRtM1erPlDvo4r1akGpsQUOitMno9ODkJ9nAzCr26P7gVZ8OnDYGZK4WmDeefYq/YVV6d+/9tJ6lLuUPIbx+6/eF4oEjBHmSpjQXFihXE2XegdWvkFXE
 NPP2nMUC
 9QIDvyUHqYRDCKNzA5DPG5J7l0bJbTIlFn5E786FMIIYgx73YWPoCSK5F8g46fIfDKltub/JmatbWpDlQjlDuwOvp5g5JPUikpCeEJ5/svd/qHiYiEZ5syQQVt2d/tQB7hRW0/oQx3iBXq/94y/sJ0q5KRMzc5MiviBE4behFDUF4fXQWh4d9aVbNFuIkwRMch6cuy15HDErRT8Ujk5b6MBMDQpb75YN1y+diIxcdSEPKSGccA5OtBokmW2jYFELpLG6ECBlzzPt90mw5AZ8zHxYXOcRxW6UICQEWPpBc7C7fEIB1mpYIS+CU0mFEg4Mb2y8buOYkLKPtXyUqDbhqFKFUSWqRTFYmrR2Lf5knUxMkA5hGtC8p56A8kUrQEOKyZoks4rYCNBAAHMC5/nG2df+VHkVvJTSeI8gn9nvstjcl7+Y8RJXAsiPYPrwPqjyxUEEBt6RjHBuKDkH8fFXM50NQ/0JtBUiDuWehyGYsNf/Z34ZiJ+o0xdZUeO/qSAHnvoIl3eo75g5q5UJ+PbGqxx1eDkQnTiDb5yp3+IMuNZ1GnTRRDfg4Amtb0p6gGQx3MiAMFveXgbXscaspsIqOKaWWyqjw7sf40CAgLeWUtihqBcDdCUDXOfBopHDCEWnAAfIsISS+tkSldgtHytEFlgcY/JWrkVlYYHEGiVCqZPqGEAANodQuHu9GRJX/7H/JoDOptNm6M1ji4R9bGruOy4Mk7pr1b3G2TKQGFh4IHZtAiNgsVs5R6fXyuyIPHYKrmVct7kGLtZwUOnMSMrCKE+oOFwhNwrdFOO2yPBFpJHfYtxbrx7tgiZFULMrWFKBG069mNJEgY7Oo0gmXxr71DSkxJdeQYqh1jw10sDB1ZvBXjVcEh0pj2Ee6KzHW46lXcLJNmwm1dJv174CyCow/WdI4S/F+jU7MzidKVMrBz3rB5vq+/u7Mzbj/zRutwb3Qran1Q1exPQC3/PJZC8m6mU+R+QtM
 L5pTljeu
 S8TrRT4UBXWXDb8wNT9CLCp2Np4Drtyn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement migrate_vma_split_pages() to handle THP splitting during
the migration process when destination cannot allocate compound pages.

This addresses the common scenario where migrate_vma_setup() succeeds
with MIGRATE_PFN_COMPOUND pages, but the destination device cannot
allocate large pages during the migration phase.

Key changes:
- migrate_vma_split_pages(): Split already-isolated pages during migration
- Enhanced folio_split() and __split_unmapped_folio() with isolated
  parameter to avoid redundant unmap/remap operations

This provides a fallback mechansim to ensure migration succeeds
even when large page allocation fails at the destination.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Francois Dugast <francois.dugast@intel.com>

Signed-off-by: Balbir Singh <balbirs@nvidia.com>
---
 include/linux/huge_mm.h | 11 +++++--
 lib/test_hmm.c          |  9 ++++++
 mm/huge_memory.c        | 45 ++++++++++++++------------
 mm/migrate_device.c     | 71 ++++++++++++++++++++++++++++++++++-------
 4 files changed, 101 insertions(+), 35 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index a4880fe98e46..52d8b435950b 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -343,8 +343,8 @@ unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long add
 		vm_flags_t vm_flags);
 
 bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
-int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
-		unsigned int new_order);
+int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
+		unsigned int new_order, bool unmapped);
 int min_order_for_split(struct folio *folio);
 int split_folio_to_list(struct folio *folio, struct list_head *list);
 bool uniform_split_supported(struct folio *folio, unsigned int new_order,
@@ -353,6 +353,13 @@ bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
 		bool warns);
 int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
 		struct list_head *list);
+
+static inline int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
+		unsigned int new_order)
+{
+	return __split_huge_page_to_list_to_order(page, list, new_order, false);
+}
+
 /*
  * try_folio_split - try to split a @folio at @page using non uniform split.
  * @folio: folio to be split
diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 9c0ddc6ec2a8..375ecefc1388 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1611,6 +1611,15 @@ static vm_fault_t dmirror_devmem_fault(struct vm_fault *vmf)
 	order = folio_order(page_folio(vmf->page));
 	nr = 1 << order;
 
+	/*
+	 * When folios are partially mapped, we can't rely on the folio
+	 * order of vmf->page as the folio might not be fully split yet
+	 */
+	if (vmf->pte) {
+		order = 0;
+		nr = 1;
+	}
+
 	/*
 	 * Consider a per-cpu cache of src and dst pfns, but with
 	 * large number of cpus that might not scale well.
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 259224f78af8..1a11e009b85a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3467,15 +3467,6 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 		new_folio->mapping = folio->mapping;
 		new_folio->index = folio->index + i;
 
-		/*
-		 * page->private should not be set in tail pages. Fix up and warn once
-		 * if private is unexpectedly set.
-		 */
-		if (unlikely(new_folio->private)) {
-			VM_WARN_ON_ONCE_PAGE(true, new_head);
-			new_folio->private = NULL;
-		}
-
 		if (folio_test_swapcache(folio))
 			new_folio->swap.val = folio->swap.val + i;
 
@@ -3704,6 +3695,7 @@ bool uniform_split_supported(struct folio *folio, unsigned int new_order,
  * @lock_at: a page within @folio to be left locked to caller
  * @list: after-split folios will be put on it if non NULL
  * @uniform_split: perform uniform split or not (non-uniform split)
+ * @unmapped: The pages are already unmapped, they are migration entries.
  *
  * It calls __split_unmapped_folio() to perform uniform and non-uniform split.
  * It is in charge of checking whether the split is supported or not and
@@ -3719,7 +3711,7 @@ bool uniform_split_supported(struct folio *folio, unsigned int new_order,
  */
 static int __folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct page *lock_at,
-		struct list_head *list, bool uniform_split)
+		struct list_head *list, bool uniform_split, bool unmapped)
 {
 	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
 	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
@@ -3769,13 +3761,15 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		 * is taken to serialise against parallel split or collapse
 		 * operations.
 		 */
-		anon_vma = folio_get_anon_vma(folio);
-		if (!anon_vma) {
-			ret = -EBUSY;
-			goto out;
+		if (!unmapped) {
+			anon_vma = folio_get_anon_vma(folio);
+			if (!anon_vma) {
+				ret = -EBUSY;
+				goto out;
+			}
+			anon_vma_lock_write(anon_vma);
 		}
 		mapping = NULL;
-		anon_vma_lock_write(anon_vma);
 	} else {
 		unsigned int min_order;
 		gfp_t gfp;
@@ -3842,7 +3836,8 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		goto out_unlock;
 	}
 
-	unmap_folio(folio);
+	if (!unmapped)
+		unmap_folio(folio);
 
 	/* block interrupt reentry in xa_lock and spinlock */
 	local_irq_disable();
@@ -3929,10 +3924,13 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 			next = folio_next(new_folio);
 
+			zone_device_private_split_cb(folio, new_folio);
+
 			expected_refs = folio_expected_ref_count(new_folio) + 1;
 			folio_ref_unfreeze(new_folio, expected_refs);
 
-			lru_add_split_folio(folio, new_folio, lruvec, list);
+			if (!unmapped)
+				lru_add_split_folio(folio, new_folio, lruvec, list);
 
 			/*
 			 * Anonymous folio with swap cache.
@@ -3966,6 +3964,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 			folio_put_refs(new_folio, nr_pages);
 		}
 
+		zone_device_private_split_cb(folio, NULL);
 		/*
 		 * Unfreeze @folio only after all page cache entries, which
 		 * used to point to it, have been updated with new folios.
@@ -3989,6 +3988,9 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 	local_irq_enable();
 
+	if (unmapped)
+		return ret;
+
 	if (nr_shmem_dropped)
 		shmem_uncharge(mapping->host, nr_shmem_dropped);
 
@@ -4079,12 +4081,13 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
  * Returns -EINVAL when trying to split to an order that is incompatible
  * with the folio. Splitting to order 0 is compatible with all folios.
  */
-int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
-				     unsigned int new_order)
+int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
+				     unsigned int new_order, bool unmapped)
 {
 	struct folio *folio = page_folio(page);
 
-	return __folio_split(folio, new_order, &folio->page, page, list, true);
+	return __folio_split(folio, new_order, &folio->page, page, list, true,
+				unmapped);
 }
 
 /*
@@ -4113,7 +4116,7 @@ int folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct list_head *list)
 {
 	return __folio_split(folio, new_order, split_at, &folio->page, list,
-			false);
+			false, false);
 }
 
 int min_order_for_split(struct folio *folio)
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index aba0cd7856da..eb29f25a5015 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -911,6 +911,29 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 		src[i] &= ~MIGRATE_PFN_MIGRATE;
 	return 0;
 }
+
+static int migrate_vma_split_pages(struct migrate_vma *migrate,
+					unsigned long idx, unsigned long addr,
+					struct folio *folio)
+{
+	unsigned long i;
+	unsigned long pfn;
+	unsigned long flags;
+	int ret = 0;
+
+	folio_get(folio);
+	split_huge_pmd_address(migrate->vma, addr, true);
+	ret = __split_huge_page_to_list_to_order(folio_page(folio, 0), NULL,
+							0, true);
+	if (ret)
+		return ret;
+	migrate->src[idx] &= ~MIGRATE_PFN_COMPOUND;
+	flags = migrate->src[idx] & ((1UL << MIGRATE_PFN_SHIFT) - 1);
+	pfn = migrate->src[idx] >> MIGRATE_PFN_SHIFT;
+	for (i = 1; i < HPAGE_PMD_NR; i++)
+		migrate->src[i+idx] = migrate_pfn(pfn + i) | flags;
+	return ret;
+}
 #else /* !CONFIG_ARCH_ENABLE_THP_MIGRATION */
 static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 					 unsigned long addr,
@@ -920,6 +943,13 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 {
 	return 0;
 }
+
+static int migrate_vma_split_pages(struct migrate_vma *migrate,
+					unsigned long idx, unsigned long addr,
+					struct folio *folio)
+{
+	return 0;
+}
 #endif
 
 /*
@@ -1069,8 +1099,9 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 				struct migrate_vma *migrate)
 {
 	struct mmu_notifier_range range;
-	unsigned long i;
+	unsigned long i, j;
 	bool notified = false;
+	unsigned long addr;
 
 	for (i = 0; i < npages; ) {
 		struct page *newpage = migrate_pfn_to_page(dst_pfns[i]);
@@ -1112,12 +1143,16 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 				(!(dst_pfns[i] & MIGRATE_PFN_COMPOUND))) {
 				nr = HPAGE_PMD_NR;
 				src_pfns[i] &= ~MIGRATE_PFN_COMPOUND;
-				src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
-				goto next;
+			} else {
+				nr = 1;
 			}
 
-			migrate_vma_insert_page(migrate, addr, &dst_pfns[i],
-						&src_pfns[i]);
+			for (j = 0; j < nr && i + j < npages; j++) {
+				src_pfns[i+j] |= MIGRATE_PFN_MIGRATE;
+				migrate_vma_insert_page(migrate,
+					addr + j * PAGE_SIZE,
+					&dst_pfns[i+j], &src_pfns[i+j]);
+			}
 			goto next;
 		}
 
@@ -1139,7 +1174,14 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 							 MIGRATE_PFN_COMPOUND);
 					goto next;
 				}
-				src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
+				nr = 1 << folio_order(folio);
+				addr = migrate->start + i * PAGE_SIZE;
+				if (migrate_vma_split_pages(migrate, i, addr,
+								folio)) {
+					src_pfns[i] &= ~(MIGRATE_PFN_MIGRATE |
+							 MIGRATE_PFN_COMPOUND);
+					goto next;
+				}
 			} else if ((src_pfns[i] & MIGRATE_PFN_MIGRATE) &&
 				(dst_pfns[i] & MIGRATE_PFN_COMPOUND) &&
 				!(src_pfns[i] & MIGRATE_PFN_COMPOUND)) {
@@ -1174,12 +1216,17 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 		BUG_ON(folio_test_writeback(folio));
 
 		if (migrate && migrate->fault_page == page)
-			extra_cnt = 1;
-		r = folio_migrate_mapping(mapping, newfolio, folio, extra_cnt);
-		if (r != MIGRATEPAGE_SUCCESS)
-			src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
-		else
-			folio_migrate_flags(newfolio, folio);
+			extra_cnt++;
+		for (j = 0; j < nr && i + j < npages; j++) {
+			folio = page_folio(migrate_pfn_to_page(src_pfns[i+j]));
+			newfolio = page_folio(migrate_pfn_to_page(dst_pfns[i+j]));
+
+			r = folio_migrate_mapping(mapping, newfolio, folio, extra_cnt);
+			if (r != MIGRATEPAGE_SUCCESS)
+				src_pfns[i+j] &= ~MIGRATE_PFN_MIGRATE;
+			else
+				folio_migrate_flags(newfolio, folio);
+		}
 next:
 		i += nr;
 	}
-- 
2.50.1


