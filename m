Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B617CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 12:22:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7C938E0012; Tue, 16 Sep 2025 08:22:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2CA78E0001; Tue, 16 Sep 2025 08:22:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCD338E0012; Tue, 16 Sep 2025 08:22:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B37E18E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 08:22:24 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6B11BB63B3
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:22:24 +0000 (UTC)
X-FDA: 83895026208.16.0FE8CA8
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011014.outbound.protection.outlook.com [40.93.194.14])
	by imf24.hostedemail.com (Postfix) with ESMTP id 92D8E18000C
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:22:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=j6rs0eqL;
	spf=pass (imf24.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.194.14 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758025341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EPoayDgo8BpMbRACUCVvq76qjnPN2UmzWtOZAJqjAFA=;
	b=Go5Rz2BSSV0hAAQtlBOlUjOfGL7MxyYrA2FfcfsK7HC88hsFjzdXOpEYyhjbRvrNlK41AZ
	eVDSs+SzW+2FC8rapx0IcTYKJaOHliSIuCO/cboLj/j2rXNaygh6TELLmbj9SgtU/4/s4J
	/AeUUCPRoMfBBzVTzsagRWNsP43hR6M=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=j6rs0eqL;
	spf=pass (imf24.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.194.14 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758025341; a=rsa-sha256;
	cv=pass;
	b=XBbRMyvrtHlC8QbXaMMfjb29SaPUfpSt8RV1YaNbli071eIktsaQ9qdAH2PZ4jNlf0LOmq
	wZw4/uwQra5pvcXpql/SIVe2RCZ1j3JzUM7GDvfwe9l6irjJUanzpaEAI7i4mBVDECHXHm
	+99w2AeTO8WCmfuP/LoqHyxGIv6WIAQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NqbxMkxAL06WuKGXAGlnFuCWVpL/0X5jMb1DR0KaaQq7985lDOTuYUqrtztxSCoNDZIrwXs1GRiClHJj0dmUMQOuao83mS5OvsJ9BP58R2owk938keQ+egsKJvN4BDAdfBjqiViFcdtcu+FFlEVLpLMC9ul5bdMBDDdSZissG5xD6xuNjo8Yoa72A7O7PwqF4nKfFDw/bJEfG6qe4tatiBT2wITIyFP7IYAEb32BpGhP2grqlqW/IKNRA08hxm/ZwXDYgjEPSTQ4mycQ44HOWp1e08E9fTpW+pxizLyK38w6D0CcNsCDLzld0pt4+z/w7iwNOybb2ZNTO/b7BPAzjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EPoayDgo8BpMbRACUCVvq76qjnPN2UmzWtOZAJqjAFA=;
 b=nr6PrvG/0tEDAgra2chxFqJZnl6XSupWbYjTyOzOtqjjdK5FuqR1Zt6RFNQWEcQ+QOo8PZWuUpxB1QJ2UfqZ9YjrVNbAQXG8MpV+ihczKyy4oSuX5hfI5PUzFn2i15FcJvxZljSc64sJcDVo9GlGKQ7xxgReiiWWitb3kJp4tSgRDTM04W0N8Lcx6l+DZvaTnWIaqv/tSvF2lNqdljOW9ir8BUO6mu8XTUfj7n7ysg7C4/V/e/RJHJwJO3xsEnavf/nYTgiUSYED4y7FpFsaWZx64YnNrnf0PEg7Kxw/BZGDz/PJtkDLfkUTTJ4PvQqCrcLU9EYGttywd/8/lJomiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EPoayDgo8BpMbRACUCVvq76qjnPN2UmzWtOZAJqjAFA=;
 b=j6rs0eqLLM1DYaP59Z1fY8TaNTUnc1MW3/EAEeFy/LDvyDnxq+i0d3EL8r2qedmUIIOLfW+scKUIiXAtiZuyq/L7dUTYopKyl5tx+mMaDS7T+TP6vJAPoLMq+lpp3Xm6L29xgxniSK5S+pbbk0nLQEeVcvZGU6gNTe02V4rgGcdDOh1e7Zp273YZ9R/oBUvPdf6h5YrIykme3O2iD0lSRxR3bfwHd196XIyeDaz7Wlq5k+rgdDwiWFwSkKmtB7QpHUUUx7Dy6q8+8rwRcNVUC8THBg48JKYjPjP5Td2bploHRuheD+R1yWJW1eDaaipg7W66Wc0EV5+xux9ThdqRIg==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by PH8PR12MB7373.namprd12.prod.outlook.com (2603:10b6:510:217::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 16 Sep
 2025 12:21:46 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9115.018; Tue, 16 Sep 2025
 12:21:46 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: damon@lists.linux.dev,
	dri-devel@lists.freedesktop.org,
	Balbir Singh <balbirs@nvidia.com>,
	SeongJae Park <sj@kernel.org>,
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
Subject: [v6 03/15] mm/rmap: extend rmap and migration support device-private entries
Date: Tue, 16 Sep 2025 22:21:16 +1000
Message-ID: <20250916122128.2098535-4-balbirs@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250916122128.2098535-1-balbirs@nvidia.com>
References: <20250916122128.2098535-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SY6PR01CA0109.ausprd01.prod.outlook.com
 (2603:10c6:10:1b8::11) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|PH8PR12MB7373:EE_
X-MS-Office365-Filtering-Correlation-Id: 83d24a05-ec7b-4516-da9b-08ddf51b9a7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|10070799003|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aWR6T1NQZjlRTTNaTjUwdFU5NWJFK1BUVm5hcEFEeTQ1VTFoeWhwYXhjN3Z5?=
 =?utf-8?B?NTBuQ3VCSXVsNDFpamlJUkorOGY4Wm9TS0xMSUJhNGI4TXpwTVVrZHZXYWVC?=
 =?utf-8?B?NWFjVnlicWt5L1dKY2lqeXEwN05CMFBMTmZyMHNXRnlZcS82M3FIb1BmQ3p5?=
 =?utf-8?B?VjRmWm9UQTM5NHVWOGtQNGlvN2xZZlc5TXpCS2c5N2d6bnlmejNENFB5dVps?=
 =?utf-8?B?QmVOSzVDNUI5TkhzK1F5d3Y2Uit3Yllldkptb002Q3RmcXBiOXRFaEc1VjdG?=
 =?utf-8?B?dENuNTJ4NTlseitEOFN2RStJL2cwTTdaWS9yUXd6VWhQblhBcExQOU1JQU1r?=
 =?utf-8?B?end5U0NWbFJVTHlQb3QwaXZVeHVYZjVxZ1JKQUhHV3pRUkNxNk9jVHlHc05w?=
 =?utf-8?B?YUVxclpDOTNPdW80VzVOZFJFU3dtZ1RxazRwNisxVUJkNTY5Q3lxL2g5Nzd4?=
 =?utf-8?B?WGZjdUZZNEcwamhyUWhBUEhsOG9CYWZjbUdTdjZoVzRDV2E1YngxUXBLbEJW?=
 =?utf-8?B?WEdxM3haUlMrZHhSVXRHVHVqTEtoQ2ZkcVBLc1lmcEJ3K0tlWWgzc045SmVr?=
 =?utf-8?B?Qmt1V29zaU04a2p6R20xQ1F3K2M3VWFuRW9PdnFCcWxiOUoxcHBnTGZMOWFq?=
 =?utf-8?B?TDAySEVqT0kxaTFEMGI2U240Qy9kYWJvK2dtd2NBVnpGYWQ5WkVnWUh3OXR0?=
 =?utf-8?B?MXBCdnJqZHFvU1orSk9TdVN6azFPWDA0M29hNDhPem9kWUpDa2RWdDYwMSt2?=
 =?utf-8?B?V1d2NWxsVGdwY3JYWURoVlhXVk1rcmQ5aEV1WUdjaGczWXFZMm1ESGRWd05i?=
 =?utf-8?B?VG02QUpuR0x1QW85UlJFNlVZNnd0dURSdkNNN3RuSzJzMXkyaGxwdnM5cU1P?=
 =?utf-8?B?R3l3ZW5mdUdENEp1enZITEpaa2FWb3BxTGQwbkxkU09aaHh0SklpZWt3TWV3?=
 =?utf-8?B?dERFMFovOW9MdkxSSUhKNGttVStZYnZqRXEwQkdvVGxmQUgyN0Y3dm4rUjRX?=
 =?utf-8?B?ZTB4UE5vR1NvNnM0SlArcVdrK1g2a3lsNHViQWUyRThyK1NhWHdDTE9hb2tS?=
 =?utf-8?B?TnVOVit0akhqZC9Wd3ArcjJwd2gvNkNIRjNWeHlodkJwS3JBa3dWVWJ6VnFH?=
 =?utf-8?B?TmQ4dDhPZGxKa0J4M1VvOXBIUFF5NW9tTVVXV0lnWGJsQWh0ajRWdU02Vkpn?=
 =?utf-8?B?b0Zlc2dmRlFCL2Y4cmZhbUNlK2NmRERjUTN0bnZSU0Nnb1Vya0h3YmUxNUww?=
 =?utf-8?B?MXM4Q1FsUFBUNlFGR2NUeG1TbWkwTTUvdEhhSWpsdHJrb3NRYXErNWh6cDBs?=
 =?utf-8?B?VzdjSzFpV2dOVmQwMC9wa1FCUy9HSmJ1V1crS1J5NlVjcU9vSkIwNUQwNGZp?=
 =?utf-8?B?Mkh5UDRmenI0ZWhUeHB2V1dyRWZvK05xbTM1MHlvQisvMXNqUlJxbzhpNkxm?=
 =?utf-8?B?VnltUmR6a0VpQTFWUGhpQVdaTEZudDJlR0ViRWlGb3RYWnVqdlhuemozUmFs?=
 =?utf-8?B?WFZTZS80ME14TllLdjllU1lId0p3YVFGdjFiVGRFcmQvc2djcWFkd28zQXdH?=
 =?utf-8?B?K2xiZVJkcmdEV1BzWEtTQXc4ejN5NkRoekliL2xWSTVxdmVEVGQzOUZOZnJz?=
 =?utf-8?B?aStaTGJjazUwbG1GS1JqSjlydTZaTUNPWEMzRTdSZUxKRytETGg3TGZzTGEr?=
 =?utf-8?B?bEpWNXdRTytBbDZPLzZmdnN2Y2V4WTYyUTBwY2lreEM2ZVV5VVBMcW0zbTJK?=
 =?utf-8?B?UjFydVE5dW14blhYazJyWXc1QVVQN1pOSDZldkhSQ0U1UDJIM2RUdzVHK0NV?=
 =?utf-8?B?MFAveU1rT01MRFNxNElOKzJSeHhhZTJmRnl3WjhVeVlxMTY2TENxZVAxUXc2?=
 =?utf-8?B?aC9YaDZRaEhFRytmQXFHRm0vQTFPWVRuQSt6TEkzVGtIc3c9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(10070799003)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cVdWU3BxT3Y3V3lLclhoeW9UOE1PTlprVDI3ZklvRE81YVBZc2Rkcnk0OFkz?=
 =?utf-8?B?WVh4UWV6ZHhGVnpCbmMzbEhmbUdzMmFXaFhWc3RvOGNxWGY1K0ZvdUhlaEJu?=
 =?utf-8?B?blUwYnM3c0JCVDFFY0dwOGRwMXExdmJuMFlNd1NvRXlaaUM5cWY0aEd6dWNn?=
 =?utf-8?B?c1V5WHE1TDE2ZDhnK3RyeXVuNng1ODBydlh3YmRpV3FndzZBRzVpMmtabmZ6?=
 =?utf-8?B?TFZGZTZOTi9LeEVSMndNWDRMcnVqVnY4RlNqSjlXdjV2QnJ0VTd5NkV1TUpu?=
 =?utf-8?B?a0VnRlRUNlVOTnBhWjB1OVRzNkNLVDUxdi8rVUYwMVJ1VEVEbHZLOXFOVVB5?=
 =?utf-8?B?VXp0eFk4Wm1RYXRsYzFSUVJzdFVMYjFzcHoveW13Q2FBVGc5cWcrQmMxL2R0?=
 =?utf-8?B?VE1WZkhmai9xdG50MG9sYkhVdVJvdjRZeUpxRXVQSXFCKytMcDBBSFN2LzFV?=
 =?utf-8?B?UHBCWkNOVkhzVVBUOGN4NW8rSmdnMTdxY2cweEsvRFdQVEc5eVhnczlFd3Zv?=
 =?utf-8?B?dklMYWN0dkpCVy9DWFRUQWNBVnU0VTdSMnJ2NlZaeHpyM1k3RjM5blNJVXkr?=
 =?utf-8?B?M2JzQ2tqYUVUZmRBcW4wUk5mWlVLZTJDZ1RTeWt3b2Eza3RFSytLS2xGYnRD?=
 =?utf-8?B?NmNWUldQWkM1eWluZWFEQ3ZmckFmU1QwYXVPRzd2cmRxSDBOcG0xUjR3V1ls?=
 =?utf-8?B?UHhWTUdFbFVPblZaek9EN3lTQUZjUFBhUmRBS3VrV2IzSThHWDlkdHltMHR1?=
 =?utf-8?B?MHBZOU9qQmh5amtOb3FnWU9jbko2a1krakh4WWxQMlF2M3FSMFdURU9EL1h0?=
 =?utf-8?B?T251a1dnRzgzUzZjZW9rajV0eUZjMVlrSFFTZzc1eWU4b0dzR2Jib1pVbVJa?=
 =?utf-8?B?eEpac25rVGRWOE1YZFE0bFVrTG92OEgyVXRNc0JYR1QyNm1pZy9lZHRtTDht?=
 =?utf-8?B?RVcwbmF0M2RmZzhZUlZNM3ZHUktweTRHQXpRcmVtQjdvWWxnTmp2bisyTnMz?=
 =?utf-8?B?aE9FZ1BzcVpxbGh4dnlOd3NpeGVRbUtuOTdzZk9XN1k2UEJrY2Qyc3dVWUkv?=
 =?utf-8?B?WEJUTlY2MVlmY0dRSHBWUDNNeTJFRHo5VDRhMm5ZeWpuZVBsTU9qV1Nnb2Mz?=
 =?utf-8?B?dEFFMDlxZFR6UnBuSnU4SmhJbDJVR3pLT09DeE1IYU1BcWJaZVFDV1ZYYURp?=
 =?utf-8?B?UGpCSnZVVTllWUVxTzY4YUFxU2lDWFFFbmNJZzEwVTZIR3NPWWFVaHlxenZ2?=
 =?utf-8?B?UHFKNVR4cTVObWwyNGszR2UvWjU0MzZWU0l5Q3BxeVEwcjk2ZTExdkRwTGFx?=
 =?utf-8?B?K0h3WUtQVlNoekJzNUVidXFhbS9yUEZLODA0SW9KN0t5MjBxTHBPd2xLSWdJ?=
 =?utf-8?B?Tkw3dWplTmdXYlRTVmlHWGplWWdPSU9wQUtWNjJ2R3plNm5JVVBzRExXbXdq?=
 =?utf-8?B?V1Y2T3JlUjVXV2xId25Sa3NLVVo0Tm1GTm5ML1p2QlBZUlVHUTZCME93TFRX?=
 =?utf-8?B?OWdscWVtTkdTUEh5UVZheXhrS0hZaEpmMUJMOUkrMCtYMVpzZVR0R2NGc1Fk?=
 =?utf-8?B?cVJhL2VPMFo5M0wyTUJ5d1RvWlRXdS9Yb01GSmFGNHplUTJTOEhvYmhOVnVT?=
 =?utf-8?B?Zlo3Sk91OWJZNjhKRi95VUp1MElaNzhZNFZWdlBkZDRVNFBJZDJZMU1kTXNl?=
 =?utf-8?B?K2ZJRXIwenJzYm5ZaEhKblRnUE56Q2wwYWtqMjdweTNQczBEd0R4dHVtZm1Z?=
 =?utf-8?B?dEtGN3ZXai8rZW5OaFp6a3lxaFRlaGx1a0tMRkxkY0ZFVllEc0FUN0p5anor?=
 =?utf-8?B?Vk8zMTJSb0NIOTFzMzZMTjBOL01IYU5xczc2MFA3T25waE50ZUhldUkwT2lP?=
 =?utf-8?B?Mjl3MEVxMTN6ZStQTEhtc3l6V0tBcjJYWjRqRkVxSytmTWJIZlB4cmsrVXdV?=
 =?utf-8?B?aTJMblZRUEdISnl0OCtFSUFJdkZXdVRvNlIzWEMxUHpnOHdqaWk1a3FBMTlh?=
 =?utf-8?B?azcrSStQWWp4VWVvSkhxR2hqQ0hYSWlvWlhaRTFmNEF0enpCYnhnblp4Rmpq?=
 =?utf-8?B?RnM5bUVnMWpRb0E3MDJKZ2xDRThRZmhLaUErY2NIMGcxMDBwOHc2UU5FR0hr?=
 =?utf-8?B?NHdzTWt4K09uTTRiYzl2aDFaMTFYb0JWTmtjamtJOElmUUNnZnlLemtzc0E3?=
 =?utf-8?B?OGc9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83d24a05-ec7b-4516-da9b-08ddf51b9a7a
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 12:21:46.2760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LgfOUw2OYXN9Vh5b5BbDv6/FY1FXHzEUpZXRGQxwTTLk2u5SzHUdBMouwtM+H/poEXu7CWcxQ6oYCc43iceBuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7373
X-Stat-Signature: mtp6pkwdepnzgcqzoqnt688p35ab8hmw
X-Rspam-User: 
X-Rspamd-Queue-Id: 92D8E18000C
X-Rspamd-Server: rspam04
X-HE-Tag: 1758025341-373722
X-HE-Meta: U2FsdGVkX1/A5dTZrhTqJmPQgeQd30fcdQKfzcRgQ7hB6efvtjeM6Munaz9N5ki8SJcDp8860GoSvUf+qVBwAwfnJVYjXrJ6FcEUw/ULxPCyr64Sq2NAJLJffRKB2kAWcC4+QV/HPZII+BBkPHTXkBLEr/6LjDHoqvfYgxUqb/0qzosvsRmgZ1rU7YF8q/YeTwxdj+nD2kicI5ixuJctBAcv4zcTerkYzAhBoie+Mxu/7Mo+NwiEzjsmlkVuFLFHAKxfvWTt+IieDZNOSq6B7YrW8f+G2GwkJmeTM/YD5zk5qtLfTwYfZmjatc74MJy3CLfZPgZF2jhRghx0Ny1hiLMCz9Vz5XAkkMFWWUNxVc09tOa+CIZ6trm3LV/iALTFRmRPiA6hqSuTH6ttrfBhq3TVkF64ihnxuIn5sq9eh0hcHzSGUk/9DhFXIP5AsFIU6UmO2LKDaCnM94YR61MvIBctfcGk34Oqk+FelhTnIwCkUcDW88AP4Ay4H7s7+qANMF9xSssinvSQlJjiXtMsGL87yowClCXArZB5QN/jaRVNgaX2ncCOJbVQtCYCYp/SBadZ66awEz7xT4g+dW12jhBSgc+w9b+XfvnxlRW5ooR5I5EHzWmmUSWDdm96SW0eXd5ju4K1Bnl0ccxTG7ENhf5i0NHmpX3yHraiThmClCvck4Z5G6hzO3oo6hbtdJ7U2lDFT1tu5R2+abykx9gpH1WWzKGK7TIDt38iHXEx6NVYsPT1X/P1JUNzfg4XaOyyabFu8Frfz7NxXI1Obi3yUwcIHPo39ERq6ve30SoYgTi0cPRJsLezyxAyDq3xNiAPyxMjhZteqEkQoD3VU6xREAYVKhFDH+orwu+xXWZO+6kLUbP+vjNHP325gSf25DMGMx3Veyh8Gcmueu+pe33t8kGwsxkMeGuvWxgYe5NKxjrXuu7JW7qOlYFUkzEbgU1mTDcOKL06yT6KjzgRhBv
 SCnPTZQG
 PQRUzBP8FHRbCDT1nGlVwvP6vaG1dmfRyLOKPn9TGXeZrG4CXDfWg6X6iTxYN60KvxxfM4SszpB1hR4zaYvGt0hTie98pQTpY1G7/RMygOnAlHNccb1iKq3LFbj4AxXy+8AWJ2GTEAjiIVKmR15kE8C7OfzZmI8zcoSuUlqcSCYMQilHC8/jeL9AszGY0snKNV/MVJ5XMqMQFJPNxek/XuUUfv4YkB0IOakPaS3Qywe9b7+Yf5XYe7xQFVvX4gOK5WDoXekWRMbcZCNi0aTTIhghjaIgtszPe8BfNEfsNQc9KEmKh34nHVVGqGMIoOA02Fz+CRL90EbI7ymk0FA7K0Ug5UIqj+iY7eBmzQY5P1crTqyVPd/H4xGMlY3bFusvFktcn3zN23PkF81iKFyRVO6P0Z5iLvw/EMgtVb4M8GRjhDdQlu7MtJgk0MXii7jvboPBfAwj3M+4okf5w4Vg0UWrTs14hFRxzIylm/YFuF2iy8tYdjzJU5HBtkgkMu7ZyUhVFJXt3EEkIvrJnDNcAIzpDQzAfeJyRRuT4EIpv+vbkGrOgfBqrR8NXfayo7ZfDuxT4brGi1GNsOAKxG1lpwU9YpucyrSdw18gcL6xEoKygASQXmOlYLugIRGkkzl+ACpCnz2wELuTuQkR/eSRMevCf8Ssz4F8aeRc5RSI2L9CXjAikKemcdjjK+iL73bS+iYoNj/OOJI8Ygl1XK7Ccylfp4cc9X/QIebK1S6aB0y0Yrin6YDt3nM4aokhFNq9NTKCs4RFF+OprubZxmyDV6OqYHNjkyllmkeVpj9azq1ipPFnygA2xQjghimIwgJ4YIAx5FAMehFkvnFqv9G+TuA3A69BSoAmaWMsS0V2XcjmKw+h0Llk4MB41g8p9ZKKoA4PADwdAHlLmABwWzbTH4ZK3z1xgMSyP1Y+ujvarhcEA3Lm6bp5Q7DFLJqQcyQT1b/Sz2cEHHvSO6u0Z0HNPlsfzK+Hf
 cJdWYjXY
 T0H7nTV+CBqeLVEnvOi/8OAsnRYlT22V6WdyDj22BPGAwuzFH36UpH0rk9bej7+Idb36VDYR7TM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add device-private THP support to reverse mapping infrastructure, enabling
proper handling during migration and walk operations.

The key changes are:
- add_migration_pmd()/remove_migration_pmd(): Handle device-private
  entries during folio migration and splitting
- page_vma_mapped_walk(): Recognize device-private THP entries during
  VMA traversal operations

This change supports folio splitting and migration operations on
device-private entries.

Signed-off-by: Balbir Singh <balbirs@nvidia.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
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
---
 mm/damon/ops-common.c | 20 +++++++++++++++++---
 mm/huge_memory.c      | 16 +++++++++++++++-
 mm/page_idle.c        |  7 +++++--
 mm/page_vma_mapped.c  |  7 +++++++
 mm/rmap.c             | 21 +++++++++++++++++----
 5 files changed, 61 insertions(+), 10 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 998c5180a603..eda4de553611 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -75,12 +75,24 @@ void damon_ptep_mkold(pte_t *pte, struct vm_area_struct *vma, unsigned long addr
 void damon_pmdp_mkold(pmd_t *pmd, struct vm_area_struct *vma, unsigned long addr)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	struct folio *folio = damon_get_folio(pmd_pfn(pmdp_get(pmd)));
+	pmd_t pmdval = pmdp_get(pmd);
+	struct folio *folio;
+	bool young = false;
+	unsigned long pfn;
+
+	if (likely(pmd_present(pmdval)))
+		pfn = pmd_pfn(pmdval);
+	else
+		pfn = swp_offset_pfn(pmd_to_swp_entry(pmdval));
 
+	folio = damon_get_folio(pfn);
 	if (!folio)
 		return;
 
-	if (pmdp_clear_young_notify(vma, addr, pmd))
+	if (likely(pmd_present(pmdval)))
+		young |= pmdp_clear_young_notify(vma, addr, pmd);
+	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PAGE_SIZE);
+	if (young)
 		folio_set_young(folio);
 
 	folio_set_idle(folio);
@@ -203,7 +215,9 @@ static bool damon_folio_young_one(struct folio *folio,
 				mmu_notifier_test_young(vma->vm_mm, addr);
 		} else {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-			*accessed = pmd_young(pmdp_get(pvmw.pmd)) ||
+			pmd_t pmd = pmdp_get(pvmw.pmd);
+
+			*accessed = (pmd_present(pmd) && pmd_young(pmd)) ||
 				!folio_test_idle(folio) ||
 				mmu_notifier_test_young(vma->vm_mm, addr);
 #else
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index a5e4c2aef191..78166db72f4d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4637,7 +4637,10 @@ int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 		return 0;
 
 	flush_cache_range(vma, address, address + HPAGE_PMD_SIZE);
-	pmdval = pmdp_invalidate(vma, address, pvmw->pmd);
+	if (unlikely(!pmd_present(*pvmw->pmd)))
+		pmdval = pmdp_huge_get_and_clear(vma->vm_mm, address, pvmw->pmd);
+	else
+		pmdval = pmdp_invalidate(vma, address, pvmw->pmd);
 
 	/* See folio_try_share_anon_rmap_pmd(): invalidate PMD first. */
 	anon_exclusive = folio_test_anon(folio) && PageAnonExclusive(page);
@@ -4687,6 +4690,17 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
 	entry = pmd_to_swp_entry(*pvmw->pmd);
 	folio_get(folio);
 	pmde = folio_mk_pmd(folio, READ_ONCE(vma->vm_page_prot));
+
+	if (folio_is_device_private(folio)) {
+		if (pmd_write(pmde))
+			entry = make_writable_device_private_entry(
+							page_to_pfn(new));
+		else
+			entry = make_readable_device_private_entry(
+							page_to_pfn(new));
+		pmde = swp_entry_to_pmd(entry);
+	}
+
 	if (pmd_swp_soft_dirty(*pvmw->pmd))
 		pmde = pmd_mksoft_dirty(pmde);
 	if (is_writable_migration_entry(entry))
diff --git a/mm/page_idle.c b/mm/page_idle.c
index a82b340dc204..3bf0fbe05cc2 100644
--- a/mm/page_idle.c
+++ b/mm/page_idle.c
@@ -71,8 +71,11 @@ static bool page_idle_clear_pte_refs_one(struct folio *folio,
 				referenced |= ptep_test_and_clear_young(vma, addr, pvmw.pte);
 			referenced |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PAGE_SIZE);
 		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
-			if (pmdp_clear_young_notify(vma, addr, pvmw.pmd))
-				referenced = true;
+			pmd_t pmdval = pmdp_get(pvmw.pmd);
+
+			if (likely(pmd_present(pmdval)))
+				referenced |= pmdp_clear_young_notify(vma, addr, pvmw.pmd);
+			referenced |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PAGE_SIZE);
 		} else {
 			/* unexpected pmd-mapped page? */
 			WARN_ON_ONCE(1);
diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index e981a1a292d2..159953c590cc 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -277,6 +277,13 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 			 * cannot return prematurely, while zap_huge_pmd() has
 			 * cleared *pmd but not decremented compound_mapcount().
 			 */
+			swp_entry_t entry = pmd_to_swp_entry(pmde);
+
+			if (is_device_private_entry(entry)) {
+				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
+				return true;
+			}
+
 			if ((pvmw->flags & PVMW_SYNC) &&
 			    thp_vma_suitable_order(vma, pvmw->address,
 						   PMD_ORDER) &&
diff --git a/mm/rmap.c b/mm/rmap.c
index 9a2aabfaea6f..080fc4048431 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1063,9 +1063,11 @@ static int page_vma_mkclean_one(struct page_vma_mapped_walk *pvmw)
 		} else {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 			pmd_t *pmd = pvmw->pmd;
-			pmd_t entry;
+			pmd_t entry = pmdp_get(pmd);
 
-			if (!pmd_dirty(*pmd) && !pmd_write(*pmd))
+			if (!pmd_present(entry))
+				continue;
+			if (!pmd_dirty(entry) && !pmd_write(entry))
 				continue;
 
 			flush_cache_range(vma, address,
@@ -2330,6 +2332,11 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 	while (page_vma_mapped_walk(&pvmw)) {
 		/* PMD-mapped THP migration entry */
 		if (!pvmw.pte) {
+#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+			unsigned long pfn;
+			pmd_t pmdval;
+#endif
+
 			if (flags & TTU_SPLIT_HUGE_PMD) {
 				split_huge_pmd_locked(vma, pvmw.address,
 						      pvmw.pmd, true);
@@ -2338,8 +2345,14 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 				break;
 			}
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
-			subpage = folio_page(folio,
-				pmd_pfn(*pvmw.pmd) - folio_pfn(folio));
+			pmdval = pmdp_get(pvmw.pmd);
+			if (likely(pmd_present(pmdval)))
+				pfn = pmd_pfn(pmdval);
+			else
+				pfn = swp_offset_pfn(pmd_to_swp_entry(pmdval));
+
+			subpage = folio_page(folio, pfn - folio_pfn(folio));
+
 			VM_BUG_ON_FOLIO(folio_test_hugetlb(folio) ||
 					!folio_test_pmd_mappable(folio), folio);
 
-- 
2.50.1


