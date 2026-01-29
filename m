Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D60DD73E80
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 17:32:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B6816B0088; Thu, 29 Jan 2026 12:32:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 164FC6B0089; Thu, 29 Jan 2026 12:32:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 045996B008A; Thu, 29 Jan 2026 12:32:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E76D06B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 12:32:37 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9379657397
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 17:32:37 +0000 (UTC)
X-FDA: 84385695954.02.CF642B4
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010052.outbound.protection.outlook.com [52.101.201.52])
	by imf01.hostedemail.com (Postfix) with ESMTP id AFD2A40007
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 17:32:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=CZhi0E+k;
	spf=pass (imf01.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 52.101.201.52 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769707954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FhZOkT3+mg8JxR3lXaAE42kujW1OYwPsVuMZMe8O3rg=;
	b=8dxFGiwT4hHkmLFQYKmMzV6sJGf+rokFIK9b9fcjAwy6pM5k9kP2vvFTfDym8AbTnh0yuQ
	QR8ch1HrVrx5CZyNCrUZu0aE1f66FLmCN8Ao35hgTH0C/O7+ghipKC06Oo+7KjKgU+wqts
	3+7ZztE8Bs2FML+ICSRcUo9vxFyXiFY=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=CZhi0E+k;
	spf=pass (imf01.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 52.101.201.52 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769707954; a=rsa-sha256;
	cv=pass;
	b=0Y4rTotKrpibd6fiK6JTe3NyYTsK1/8HnZYgQg8iDXWu3/qifPmXN6vOUkmw/Irz6nIgK0
	KmnNEi+Xc5lJbXCKZV6qRVe5xZ+a8v0JKoOvY6CdViQ7hZfX8l5/gDWb51uvBgylWBOOdj
	gLaE0iu5oRS68RpCIjAPd1jCN+Nnigw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CcHrIVC1mFaHeg5XGPjLQxiITlfEf13grC7ipZ839DS0QOhP3cMKqfAdBKPwJ9PNWUnTh/q9RhAnu09yXjQrC72lGOqQWlSTohj6AmQZH/AnRwaxrXQeDeia1O8vNAYy1uKuK2MF5sQ43BDh71hVWv++AXvCWzeV3II2gvCYw6OgqLWlajMURQw1WIlJ3Ohwg16DxiIpJqzoekWtURcskQs1PqVELYuZdWmqkrXdKVYB5pjmJhH6xU91mDnwkYwtYmNZ59GrdouNaA0EuzA3YIg61UKlE+bcwwqoY0Tv0n0zJTUnL6a1z5B9eAODbDPMYDktnJmWVo2rKod1KExCjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FhZOkT3+mg8JxR3lXaAE42kujW1OYwPsVuMZMe8O3rg=;
 b=LlgVOPtFQc3ndk0j5EAoZ8HtDnc82QTM0+nbXUYIDC072MgWipiuHNpjqILXf5QiMdSCXfgc89fATxSz5ntlOWje9F0naCYkNuPvtsDJx3igD8zCYID58hQ7OsZ47zrcchvd5Jt/73xdj9CEIWRP1g0Du3t/ODrwI0g4UAgx/L7CTfrFNk2p6ew2rhiVXINsqM/4g6qt2RF8+JyytvX7siPR539qzZrBNftUd2Kc+tlO76D1oP+ij9/cs4f1GaeTZkVXc39lfwz9j75ML1C+dpKGx932hGplbU+82ynOgR4ZE2/4ZKxmo2a22AmcCSaX/96vH3obK2Ob4BBveNtCwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FhZOkT3+mg8JxR3lXaAE42kujW1OYwPsVuMZMe8O3rg=;
 b=CZhi0E+kHzk/ed8A67+bEF1+6WlI2P9zF9pIbIAVQ23CN3RmwbiVrw0GypQaq80jotd3GP3hDVNrhrQynZ6nhFu7XsBU0n9XuCcQga0KyuMQqYEDktFsE2EL/SPFY5D4DWTgdbkahG5to1U7IbnUgVTdsGaPiAbUZCRdi+JFWCM=
Received: from CH3PR12MB8660.namprd12.prod.outlook.com (2603:10b6:610:177::5)
 by PH7PR12MB6585.namprd12.prod.outlook.com (2603:10b6:510:213::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.10; Thu, 29 Jan
 2026 17:32:28 +0000
Received: from CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::87aa:52e5:4b72:d5f3]) by CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::87aa:52e5:4b72:d5f3%6]) with mapi id 15.20.9564.010; Thu, 29 Jan 2026
 17:32:28 +0000
Message-ID: <1f588ff8-e3f5-488a-836d-5e33cfd37a51@amd.com>
Date: Thu, 29 Jan 2026 11:32:02 -0600
User-Agent: Mozilla Thunderbird
From: "Pratik R. Sampat" <prsampat@amd.com>
Subject: Re: [PATCH v3 1/2] mm/memory_hotplug: Add support to accept memory
 during hot-add
To: Kiryl Shutsemau <kas@kernel.org>
Cc: linux-mm@kvack.org, linux-coco@lists.linux.dev, x86@kernel.org,
 linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, ardb@kernel.org,
 akpm@linux-foundation.org, david@kernel.org, osalvador@suse.de,
 thomas.lendacky@amd.com, michael.roth@amd.com
References: <20260128204105.508855-1-prsampat@amd.com>
 <20260128204105.508855-2-prsampat@amd.com> <aXs09b7Q8wmHMFNQ@thinkstation>
Content-Language: en-US
In-Reply-To: <aXs09b7Q8wmHMFNQ@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR05CA0003.namprd05.prod.outlook.com
 (2603:10b6:805:de::16) To CH3PR12MB8660.namprd12.prod.outlook.com
 (2603:10b6:610:177::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8660:EE_|PH7PR12MB6585:EE_
X-MS-Office365-Filtering-Correlation-Id: 45ba96f5-6a69-43e2-fd48-08de5f5c5fdd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z09INVY3aHlwcU5nWEhMeXhraWVPZHFEeTNWOUN1STliN3VaTC9MdzFzWmlL?=
 =?utf-8?B?c2xBWUtXMlg2Q3VhTnJzUnEwUVlNZUhOTlYycmdEZmlPMURVN0VRYnpjcTd1?=
 =?utf-8?B?N2R1VThYU2kreS9yYVJJUzlXdlltaHJjaURrbEdtWHNkZjVDdi9TWVloUm9Q?=
 =?utf-8?B?Sk5aRHJlaXpxMnZYb0JxY1U4N3FhUjg5bFl4Q3pRMkxQTmxCdDdQcktXendM?=
 =?utf-8?B?T05NSUZaRnpCc0RjRjh3TFB1Y0JVY0Z4K3dYYjZodUpJTzdmcmNYcTdCam1M?=
 =?utf-8?B?OGFyVGgxVy91YXBMMHRrWm00aUFUMWNCU1BWWmhHUmNaekE5aHJXbHYrT09N?=
 =?utf-8?B?ZW91QXdWd1RmUFFKb082L1duOHcycVgyeXNuU0ppQS96TUgzUUkzQ0R3Rlph?=
 =?utf-8?B?eGRlMjJGSnhJWnFJRzRucHphMmEvWjRkKzBjcFJ2c2xPU25PQW93YlZPSTdJ?=
 =?utf-8?B?eHNlY2h3VXkyN05DZkxxaXUzY3ZKdWlYNE1nVXQremNTa09QYzdvUjE4ME9J?=
 =?utf-8?B?SUZ2NWxqMTg2V1IzNXA3VDRvbjdycWk1OWpNaWpXZFZPNFhsTzYyUkhkcExp?=
 =?utf-8?B?M0FZL0FwcGZBNkZtT2RnZzZwU2tuVFN2N3hpZDI4NXFkYjNrNTRnZEsrektz?=
 =?utf-8?B?a1hlWGZCbW9lZEFJSkZ3ekVWSVpyUXFPbEJMQXdWOGhhRG4vV091VHc1WGJK?=
 =?utf-8?B?cDB4NjhSTWhsUmJXaEZCYnBLdUhQdTBBRWZyTUVrTFpPc1ZocWpDRDlwZFZG?=
 =?utf-8?B?TVdmSmtYZHdGSGlmSjQrbEUrMDFpN3A5OXRxelEzelpOUWZ2b3hVTG9YSW81?=
 =?utf-8?B?djFoWjJEZmxtRHgvalVJZDNtY0lSQWwxY1FoTzNxR3pCN25LYWZrbGZQM1lG?=
 =?utf-8?B?ZTBtc3BvV0R5VGg3MmdRRWlwTzBKZmk0RzdoUUcrbno3WmF2VWxNRUdVaCtR?=
 =?utf-8?B?dmtXamRpMFNRWEN4TjFvM0Ewa2YxTHRvRm91S2JWSU9ONVVZQjB4NVdsdlM5?=
 =?utf-8?B?WFVGOHUrVDl4aENZb1FROVU2b1N4emVaemh4ZWVXb003UFNlZ2lHTkMxSzFH?=
 =?utf-8?B?Vm8xc0NaMThUYllKS1Y3cHp0VVVuajYyVVFjd0hFQ01jems3QjlHb1lHYnhV?=
 =?utf-8?B?TUw1TTNZeVBrWlg4WFM5eE40REpxWGc4SUloaGc5ZGZqdms4TGJyNk5MSkU5?=
 =?utf-8?B?cTNURGNIdjgyNTdlUnhVNEM2OUVaV1JqcHFGZys3N0dpR0M3bndXajRNWm15?=
 =?utf-8?B?N00wTTRIOWhxM215L2V3eXZ5ZFVlVEVHRFJ6dlUwWUVoaFJUYitLMENWWW9x?=
 =?utf-8?B?RE5sb0xDVE1aM3BiZnloVFcwcnFRbjNRNTlXdjBiVlA0WTh6ZGkxNy9JZ1gr?=
 =?utf-8?B?TnU4NWl6eGpXek0wbUhPQTJRMS9WRHR6cmF3VXV5NU9Db2VWL0tacXRuRWEr?=
 =?utf-8?B?S3NLdXhoTUhLK0MvdDhCQnNRT0wvajVaNk1YRlR0VldWYnByK3EwM1RqNERu?=
 =?utf-8?B?Q1Yra3AzaG9YMGNGY29Oa0ZUdXpMUy83aHpwQWpiS1c0MDMralJpT0duVmZK?=
 =?utf-8?B?aVJDQUxuL3hmT1VRckJHaUVjcndaV1ZtRG5lVktIbmE1dDJyY0JOWWdXRGxi?=
 =?utf-8?B?MFowTVZLbWdOalhoanpEdXlZbnJiT2lkUTlDWm16Qzh5REYxcUNMc1A4aTNy?=
 =?utf-8?B?UHd1cGg2YWRWbnErVVZEa2QxSGdCWXpDemtKaGx1Vi9GNC92VGthaDR2dWpr?=
 =?utf-8?B?NG5aZGV1b2xIT0ZjODJKbnFrZVRzVGlUcFk4ZDZZNXdZY1kzYzk2eDBEc1VT?=
 =?utf-8?B?K1BoQTZ5MndWTENtWkFQcHhuNGRhSysvMnhPZFdsZlJzd2xxUXRXK0ZEc1FE?=
 =?utf-8?B?blVkZTdaVGJYMjNlM0JPMTJDeVZTb3NTcThpWnlNWXh4WTZrVWp1c3ZaOTll?=
 =?utf-8?B?VGxsYnRzaHVqL0pGbFJESnVGUG1raFZ2d2ZEekkvYWlWanRyRU8xOVpaVDEw?=
 =?utf-8?B?YUNmREgramhTTEQ2eHR4L2h1eXQ4ZWt0QWVram1ibmNRODAwRW45ejBzdk9V?=
 =?utf-8?B?RklWV0hSeXVsamRVSXpNM09tK2NiNk1HV3BFYVhDRjExbUhHalgrcmo3Q0FR?=
 =?utf-8?Q?Jcqw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8660.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UmlTMmEzS3hYSG5ZRFE2TVBobko2NVdwZW43MHJpMS84WVhFYjFzYnVNeWZz?=
 =?utf-8?B?T3N4U0F5blQvRFUvNmVhWWdqU0I3eVZEaW5MWFlPeGRYajc4Z2dnOVRJUW5I?=
 =?utf-8?B?OU1HLzVBS3UrVFRYcVRaMXcxNXdBY2paMFE4WmE2RzZ2RHZZWTJKRVptNmRY?=
 =?utf-8?B?MnQyRnd0ZWxmOEtyMmpFZ2tzbjlqWXRzZzg2bXZBWVJCTEt4cU5XMUhYNVE5?=
 =?utf-8?B?RjdvTys4YXJ3bG9HbTE2VisvRGt6cC9HQW5VY3BDeVRtNjVmakFHaG85NjhM?=
 =?utf-8?B?RzNselhmb0Z4NC9OeFBMTldPd3RYTlMzYnVyUnBIcHRXZm83UVdCZUIyYXJP?=
 =?utf-8?B?TS9nUDNRNmVJZ3JqYnprdXNTTzlKWmpNWVlGLzdmYmlUaEk5LzlMWlZhWVZ1?=
 =?utf-8?B?a2NabmtyK2U2NmxXZmdGQzZCNFE2MkhJMSt0Tk1paHZXc2hpb1plbDVUOUtX?=
 =?utf-8?B?Vm5DTUhEQXZaSGpaYlY4UDZJVmNWb0pPbzQyVFhrWHVmM3kzeHIvaGVXL2p2?=
 =?utf-8?B?dmxNeUhZd3hOc0p3a3Q1aUFEOWhuRVYwZmhOditac01UTjV1K3QzeUJJSWla?=
 =?utf-8?B?ZlZ0ZUd1WXNhcHZsQ3I0TmgvbFZhbDRpTTIzbTRNek9Fdm9vS3JHa1pGeHpq?=
 =?utf-8?B?bi9RRUtVb05GaGt0V1g5bkdsOGpQK1BnenpnRHZnU3VZaTl2elEraW0rOVhZ?=
 =?utf-8?B?bnRPaStxRTV1UDR5RWQ0U2RDWFNESDVINTkzNld4RmYwUncvR3BzWEUzYU04?=
 =?utf-8?B?NXFEcG9lNWJySXA2K2J6NjZQT0xkZUxHbGEzLy9LOGdsdHRCZHh3TGU4MG9B?=
 =?utf-8?B?b2ZNdC9UY2V3UFQ5a2NUbkhWdW01bHpHWG9nUjNJZnRJcEJPOXJhOHd2azVw?=
 =?utf-8?B?Vzk1Vm5QanFLd2hRMzgwWGJiZzJLRVRNbVVzeTNNa0N6TWZ5QnJINEp3Ukdo?=
 =?utf-8?B?YXVkS3BPM1pST0k4MDR1dEJwWVZsc1d3RUFzcCtrN2t3TGJSQzdHT1VWTGtK?=
 =?utf-8?B?WHFtYXlSY01Ob09JdGhkUGxmdEJYVlo4SkFmdk9nSENFWkxjakNwY2tpZ3ov?=
 =?utf-8?B?WGtlMWkvd21yUW5FdWhIQzJHQnNVbUlMd0MwSW44R3dqZVc0V0JTMDVJTTc5?=
 =?utf-8?B?M2IwZDVhWVh3bEppNFFqcmR2ZktIQ1JyS2lWWW1TZjl6V3F5WTJGM1ZGVWhW?=
 =?utf-8?B?V0JSQ1hpSm41MFFHM1c2czQwSzlFWExxZW5WTHN6OGROc3hOeVBOMS9WUGpJ?=
 =?utf-8?B?a09jZDFSNTVOa29RQXFqWkxDQzJTUmhXU1VBZkorNE4wSVNVNVAxMHRKclVi?=
 =?utf-8?B?N1o2RlFlbXY3bVljcldxZ0sxUTJINHVYbEtraHNlNlFmS3NheERQY1VsTS8v?=
 =?utf-8?B?TjNxU0xuM3VCRHBnbC9PZ09KTWo5VCt5SWd6RkM4UWJqRFpvSzl3a05ZNVd3?=
 =?utf-8?B?WWJ1QmJBQnhGZzdxMHRNVGZralJlSjB0bFFMVlBhQTlWVFZzbmJNcytDRCtt?=
 =?utf-8?B?Y2FsU3V3dEhzYUVLUVhPM0xMNFFhL2puQ3ZHbVl1YXB5UGlWY3F4Zzg4SzFp?=
 =?utf-8?B?R1VISnFBTEp4alV2c2o3Z2FJcVBaUTlZeVZBZ3V6ODNLWVhpTXRwWmJSQWZ1?=
 =?utf-8?B?Q1hibXVPa2ZYWXBSRkhCUjRVQ3JOUThaa0YySGVNRWtwM0dMUUdHTW5CUlMz?=
 =?utf-8?B?RFdNeGlNTEJoT3d4elU1V0lxUnp0TEhLUDU1K3lTSEYreVhOSDgwTnVOUHo5?=
 =?utf-8?B?TFg0RW8zaVo0NjUyN3NyU21sRFFaSThpTUdxRExVVzRweDhuLzZkREtQbmdx?=
 =?utf-8?B?WmR3a2JvaGp4SXdEVW40OHM4WEQ3ZWZRdUR3dG5sdG9yczhsdjM1eW9rU1NR?=
 =?utf-8?B?NjZLeHZSanhOS0V4Vk1LaVdMbVg3SWZpZjRUTUV4aFFSeWFJaThZM05oOHhH?=
 =?utf-8?B?ditFS1NVVVpNTFVhYm5kUzRqckE1WXF2TE9CQW9CV3Y1bTJlcFVLaXQ5TzYy?=
 =?utf-8?B?eXZ4VHFqTlRmVDQzOWpMdElGVnNuZTI4WFQ5bG80aThWM1piUDRvYjExL2xl?=
 =?utf-8?B?OGYzUWdUWHlXTG91a1RvTTd2OWFQczNaUG5uQlBwZUZwem1LN0ZRbGorMzJ6?=
 =?utf-8?B?WTlmVUtlUDFrbk01VmRVM2JMWnMzNGRXNXFZRXpZYXdHQXdSeElOMWhYTEZl?=
 =?utf-8?B?ZlI0QTd5S2twdlF1YnZJMDBobytRRHBGbko5TFlncUFqOGlzZERoMkRNNlNl?=
 =?utf-8?B?S0RKRVZ0TmJFTldJdUFSWUJ1UW0ybWNFRkdTengxUk1CVUdRMW9xbXV1c2o5?=
 =?utf-8?Q?o/jHOjQenl5h5WG3/D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45ba96f5-6a69-43e2-fd48-08de5f5c5fdd
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8660.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 17:32:28.5696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rKN8obeSl2KbYOd+utUlVRkNsQxCSkJztvTxSbLNrutOvi7t72FmUktjVSGVNV7b9i/IOTEhXk+URvBN3cEB+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6585
X-Stat-Signature: o7hw69tknmhksjohquxf4fo3sz4k7p4k
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AFD2A40007
X-HE-Tag: 1769707954-971418
X-HE-Meta: U2FsdGVkX1/R+SgiQB0sXM8ldY3/1db53vWB+8ap8aTNs67z7azA7i4qhxqldZGx5ub75oBH98jo7FdLHrP5EqRoFnBUhs5aF7LOipnOFCJGKwFsTk3/oBCCruQNdfSeMJ3gcxypO7N3aY8lHZsP5GPHcDtyKTRyiUvUTG0qS9IXzjwJ8+DWG90CBYQbkQELcKBPrXcL/oqQ6y+6qRFmoDvk+Ge2Xdj6zeOmeAi1c8JJ9PswOmQs1ewn3022izidyc9761mkLjqi/M0UgHf3w43yc54aQdwJ7x7GU7wayQ7K5i2Pb5WpdqDw3AJhdmOt+HC3YR+12DfEtnvIRiFNOh4fOoFxz4yH2usdVMRFZ96wtY8hL04DIenTDTFevCb9KjA95epGMOWv7UmHitAWfvHysDZwzcbem4PGPgRbp0HNdyH8QnkHa4hQ15S/wp749Y1Fd8XmCOb2nI8D+jvawyoDe2xxgD1F/cgXTjLfZpSHw6uqWeGwmprKJ1PW75WVduM70XbCKHhXj7vLPeX9x4gg55PG9LRI6qpUBaUGgDH8tk+vAblBnvR7LG0Xsp3GhZ1eqJTx83ABi5dkGrLTGYtZGSluL82Iayum9H5nV8eJC/sR3PhTh4Owh7stOjYtkvJ3NBV26JuA+WqBNhaBnpmTX8V37RxDvaZedPQ039kMb0kE/zrpEsZOVJhdhGZ1UgqQBrd0ouMCGmHtb+30HHhsI9Nl5jw+BREd3akDYSHrpHEFcBKAbJg9/YOGgvwlSUWfXXvy6ae1vJ2bDfXneQV8yN6qhqvN/kMR7S0aFmYbbf/9EQyDA1gzg9gOL0s1uWvpc4MCo7xcnjXoPNVBw01SDPJ+W4WKyY0p/RVCseVcp+yL0rJyxtjaB0cYkg+e30aTLLAIntXHwwMGlrLGjbG0S2JPtJwg45E5obhXwCn3FX6Ut/D9jm4LPfCUHi/3Pv8hB52YepjqGtmoQcF
 6Fq5A/MT
 UOLsWD7jB1kf/7nCO6uY98mr49gbR1tRlxXsFb8xee7IiWIRKuxb1hvhl9rk2XpayLjFWyAdtAWlWR7eVg3hAB+wYnbM6L/M0t8fnmN8+q3o45Sc2ski+TDzEOm3qOfum5tpFwepKA5t2a0alkpgLvteioFX+/+Ri8pYL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kiryl,

On 1/29/26 4:35 AM, Kiryl Shutsemau wrote:
> On Wed, Jan 28, 2026 at 02:41:04PM -0600, Pratik R. Sampat wrote:
>> Confidential computing guests require memory to be accepted before use.
>> The unaccepted memory bitmap maintained by firmware does not track
>> most hotplugged memory ranges apart from system memory annotated to be
>> cold plugged at boot.
>>
>> Explicitly validate and transition the newly added memory to a private
>> state, making it usable by the guest.
>>
>> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
>> ---
>>  drivers/firmware/efi/unaccepted_memory.c | 18 ++++++++++++++++++
>>  include/linux/mm.h                       |  5 +++++
>>  mm/memory_hotplug.c                      |  2 ++
>>  3 files changed, 25 insertions(+)
>>
>> diff --git a/drivers/firmware/efi/unaccepted_memory.c b/drivers/firmware/efi/unaccepted_memory.c
>> index c2c067eff634..5a4c8b0f56c8 100644
>> --- a/drivers/firmware/efi/unaccepted_memory.c
>> +++ b/drivers/firmware/efi/unaccepted_memory.c
>> @@ -209,6 +209,24 @@ bool range_contains_unaccepted_memory(phys_addr_t start, unsigned long size)
>>  	return ret;
>>  }
>>  
>> +/*
>> + * Unaccepted memory bitmap only covers initial boot memory and not the
>> + * hotpluggable range that is part of SRAT parsing. However, some initial memory
>> + * with the attribute EFI_MEMORY_HOT_PLUGGABLE can indicate boot time memory
>> + * that can be hot-removed. Hence, handle acceptance in accordance with the
>> + * unaccepted bitmap. Otherwise, perform the state change for the memory range
>> + * up-front.
>> + */
>> +void accept_hotplug_memory(phys_addr_t start, unsigned long size)
>> +{
>> +	if (range_contains_unaccepted_memory(start, size)) {
>> +		accept_memory(start, size);
>> +		return;
>> +	}
> 
> No. This is buggy. The memory has to be accepted regardless of state in
> the bitmap. If the memory is ever unplugged the bitmap state is not
> relevant.
> 
> So, accept it unconditionally and mark the memory accepted in the
> bitmap.

I see. This makes sense for acceptance since device_del would always fully
unplug it.

I still might need to keep a version of bitmap handling in unaccept considering
the case where partially accepted (lazy) memory is removed.
For SNP, pvalidate is not an idempotent operation and we must only rescind
the state for the bits that were previously accepted.

Also, now that I stare at the unaccept_hotplug_memory implementation, I realize
calling range_contains_unaccepted_memory() is plain wrong. I should rather be
looking at the ranges and handling the bitmap + unacceptance.
I'll be sure to clean that up in the next iteration as well.

Thanks,
--Pratik

> 
>> +
>> +	arch_accept_memory(start, start + size);
>> +}
>> +
>>  #ifdef CONFIG_PROC_VMCORE
>>  static bool unaccepted_memory_vmcore_pfn_is_ram(struct vmcore_cb *cb,
>>  						unsigned long pfn)
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 15076261d0c2..2d3c1ea40606 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -4504,6 +4504,7 @@ int set_anon_vma_name(unsigned long addr, unsigned long size,
>>  
>>  bool range_contains_unaccepted_memory(phys_addr_t start, unsigned long size);
>>  void accept_memory(phys_addr_t start, unsigned long size);
>> +void accept_hotplug_memory(phys_addr_t start, unsigned long size);
>>  
>>  #else
>>  
>> @@ -4517,6 +4518,10 @@ static inline void accept_memory(phys_addr_t start, unsigned long size)
>>  {
>>  }
>>  
>> +static inline void accept_hotplug_memory(phys_addr_t start, unsigned long size)
>> +{
>> +}
>> +
>>  #endif
>>  
>>  static inline bool pfn_is_unaccepted_memory(unsigned long pfn)
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index a63ec679d861..549ccfd190ee 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -1567,6 +1567,8 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>>  	if (!strcmp(res->name, "System RAM"))
>>  		firmware_map_add_hotplug(start, start + size, "System RAM");
>>  
>> +	accept_hotplug_memory(start, size);
>> +
>>  	/* device_online() will take the lock when calling online_pages() */
>>  	mem_hotplug_done();
>>  
>> -- 
>> 2.52.0
>>
> 


