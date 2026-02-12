Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51B19EEA84E
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 21:16:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA97D6B0088; Thu, 12 Feb 2026 16:16:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B81096B0089; Thu, 12 Feb 2026 16:16:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A385C6B008A; Thu, 12 Feb 2026 16:16:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 94E8E6B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:16:27 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3ACF31A02FE
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 21:16:27 +0000 (UTC)
X-FDA: 84437063214.25.59B3803
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012070.outbound.protection.outlook.com [52.101.53.70])
	by imf15.hostedemail.com (Postfix) with ESMTP id 59B5CA0003
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 21:16:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="fDnp/ppX";
	spf=pass (imf15.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.53.70 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770930984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hJVMNujcrMar2ZVsEAbN1w1NzwWansg9XtoRTWDRio4=;
	b=G19XByjnnLsDx8fqkX7OCSzCWvhm+OCttpnYazyqgkpCZtiY6c5Ar1wHFZEhdoa+sRLXaV
	NNo97m7uOidxijfxTlneqc3P/YDcmtLQOG/I2+aez9YhcWtcbrM11xD/T1MPPYxZAjU/Zh
	VGSp8qXc4VosyymemyAGIwnmIT7L988=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="fDnp/ppX";
	spf=pass (imf15.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.53.70 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770930984; a=rsa-sha256;
	cv=pass;
	b=COg23wpPUta8LvLVmXzVt7ipduoYFmjWYtfuPGkRK31T7D+lvBWb0KePTiH6KmvjKjEuqe
	E67BBX1NPaWok8KCl0CuovxYEAwzwGQzyArHJYIDv2oBAqBDNHQCDYO0oWJnTKErRNrcAi
	j6swurA8x9FKeUbakdG2ryvbAOirsUk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K25nkDaxuWmEfOhYCM9o7QE8pLCcFLugXIL0ZTOuDruvsp1AvkM+zt8GIh67oCv8jEL/TjrAXEuVxErLtPRF4saWKVrFkHEgypia66sx9CBS5oxfW9OEnBpsBzJt95vXHm4fpaLJgtT725vJxlIZRnYAwdNTV4OsHHtDkYENAAchg1QDdM7s6lUOFeEu2Lsdwa3/Y/usXTGknNPk27t/2l2BD9ZV3AAy14crH4zigDqIUdF5HEUE76U1Cl13QDHSSyrrgyJwaignBh5w7zl2Hu35EIhBG0SHuLKygWAVXS2tUN1B+6NaifUv7FRI6yfuM14FvZ6QK2FLls4u7GimTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hJVMNujcrMar2ZVsEAbN1w1NzwWansg9XtoRTWDRio4=;
 b=loBYGPSq/aozd5UQNOWxVVYpzU7OCh/M43R+XB3vX4UTeAlKNTBed0KV5aEDjyGPnvJ/qiwXeTLQAjF5R8cBMfH8hkwWo9EjoCoPVLwyZEtmMApo3MRyUHOuDo+kd2vmmN1PFTXRkfL/scLuQfnDxkRaIMfXeDZMmOM9+kwooAz21tBuwYnA2410IWJeZi5N8Y49N4N0fGqUcRnPLupgtg4jmqiz411nU7v4W7lUV1tVGfZDZ8j1bfXp86f0PEMoZ99CSbRwDnzZG0ERFHpNAVvEskB72+bvBVsFqKYR77Hmbe+L+nZRhgiw1lMST6sa9H107IwVchUB7zy9nWEwkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hJVMNujcrMar2ZVsEAbN1w1NzwWansg9XtoRTWDRio4=;
 b=fDnp/ppXSY27miyGWCuDe/HrYmpE8/voUJg0G6NkP4OzYq+O79GAmHzyB/bNrc3/hwkYszJKMB1dpiHd6cdyAR5WwNzE16sWvNkwVbM+3ZlAa+elKrqBjlSgvnEQ5A0k3FlFM31uzFlfmDKBbycZ/BlNPFlomdRNMRgdgzC8pdaHcl+hnZvAiQ5qEj990H5ROzNZQZHA6QxOeJPPoi3Z8fSlkwnJtxa3cNXA8fNsOaAMcUnnRFJvZRsBwWvEy5BEINwcRkS6OBJBmJXyZaVJvl/vMfvutr52rEkGQcKK1Le52bY9tiW5JIQ4jHt/LjPI7pKUteGgpKL+tyFMmP73lw==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by IA1PR12MB6457.namprd12.prod.outlook.com (2603:10b6:208:3ab::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.13; Thu, 12 Feb
 2026 21:16:20 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.20.9611.008; Thu, 12 Feb 2026
 21:16:18 +0000
Message-ID: <01499626-347a-4258-bdb1-c1cc67172cd2@nvidia.com>
Date: Fri, 13 Feb 2026 08:16:13 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate_device: remove dead migration entry check in
 migrate_vma_collect_huge_pmd()
To: Davidlohr Bueso <dave@stgolabs.net>, akpm@linux-foundation.org
Cc: matthew.brost@intel.com, apopple@nvidia.com,
 thomas.hellstrom@linux.intel.com, jhubbard@nvidia.com, jgg@ziepe.ca,
 linux-mm@kvack.org
References: <20260212014611.416695-1-dave@stgolabs.net>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20260212014611.416695-1-dave@stgolabs.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR03CA0007.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::17) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|IA1PR12MB6457:EE_
X-MS-Office365-Filtering-Correlation-Id: bfa06ef1-b68d-405a-349b-08de6a7bf63c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VTM4L0dPb05oL2dhWloyU3RITVZnb1NoMXhhaXBwVzlGR0l0VTBUWHoxMXoz?=
 =?utf-8?B?YmV1U2NBT1pRb1I0dlZOQWZSaWJKemFCdkNEKzE4dWIzU0xWWktxaHJBZnhJ?=
 =?utf-8?B?QkpHT2pIWHVTek5KNklwQThoYWxqelNsSHV2S2JwR0JWZ3NHbUEwSm9pWFhv?=
 =?utf-8?B?RUtPb2VZNHh2OVY2K3JTZXA2OGQyaFIwT3EyZTIxZXhkUzIwU1Bia3A2NGFQ?=
 =?utf-8?B?WmJ1ZkNxZk8vU0h5eVh2Tjk1ZnE5MFFkT05jWVVGNzRGUlRscDVVZ2lGVHlL?=
 =?utf-8?B?V1Q1ckwyUFVwUVY4QU85ZGhaQUtYWDBwNTNwblVUSzAzaWxaTnllSHZrU1Vz?=
 =?utf-8?B?S25MR0o4WVNDZWl4VjhZeE5IZDY2U0E5WVN1OGx1OHNiOEc1VGovUnhYcUV6?=
 =?utf-8?B?TlZ4QXR6OUJ2VDBBaUZnVWxYMVhmNkhwZVpPMVMxejV6WGFXaUVtWnl1dGpF?=
 =?utf-8?B?MFFTUUNDemUzcE5XTERrK1dmOGtrTVZOdElZbU9aUFFHMXhlMDVuU0lEV0hV?=
 =?utf-8?B?cmp1UFlHdTlIU1RRMmx1clF0dmNDMXdvRS9UeXVkdkZJU2ZWeHRMd3NtS1A5?=
 =?utf-8?B?V2tucVBETnlqOFNxRGVNazBKZUZnTTdzWm9yTzdwTkdiZWZnYXJHMlZXSzZI?=
 =?utf-8?B?c2p4Y1gvU1BDU2RIVXV2eXZtcUN3YVppWm5wcGtNeWU2RXB0NzM4dk40cS8y?=
 =?utf-8?B?Z3NndWlUL2RoUlVTN0ZPYjRNUmdHalM5Zlg2MzBHRVlIVFc0dDBFY0x1Wk5y?=
 =?utf-8?B?RTczd0hmajBSeHltZGFzck13YW9MTG9TaWVZR2QyeW82eGE5dFluRWFoTGVV?=
 =?utf-8?B?UmlROWd1dkdjbTJ1L3U2UUw3czRNOW5YQVZjQmVaQThLNVBMRkV4MlhmYTJ5?=
 =?utf-8?B?TEdDVnBUcjlZNHdjNXNXaDQ1U2MrblVoblBud0lvNnl4bVpMbFpNTE02ZEhr?=
 =?utf-8?B?dUJwb29VUUwwZm96SnVsNzJuSytHS2doRnZvSDlFWkdINUQyelVZeFppWU1x?=
 =?utf-8?B?cHlKNzNPQ2tuSlFieE42SVJORE1WZW51ckJienJzTzhtK05lZFRwYUIyNVFy?=
 =?utf-8?B?ZitiK2RiV2h0SWtHVjNxbmdVeUR3S250R3VJL3gvbmlST0g2ZW54QlhFbzJu?=
 =?utf-8?B?WVp0MG9BOWlnMm4rVXhWQ2RpMmR4ZGFFcDlKbEF4dDIyQmdZaEFEWDVTejgr?=
 =?utf-8?B?bzZyWjVWald1VkRJdm52R0FmQUN5UU4xNzR6ZUZlRzVaVFR6QWpmQmw2cFdq?=
 =?utf-8?B?QlQxeEUybkFCNzVEOUhSeENJV0pmc2NhVjZONGp0blVmTzJnYXN1ajZqeDJL?=
 =?utf-8?B?L1BldG1xcFhsMldQOEluYm5nZUpkTEE5VUNpN1NoVzk3ZjVQalArRk43Zjh6?=
 =?utf-8?B?V2U2QzlSMU9ady9FZWpNaEZDNWhUQ3ZISUpkYTI4ZGxjT0FYMG1DWm1uM2JI?=
 =?utf-8?B?VVlMcndOUmdoTy9Sai9sYjU5Z1Q1UTNSUVhrNXFxcUFnODRMdXlxQkY5aGRE?=
 =?utf-8?B?YzhWQmFlRmhHNWUwc0NROUs1R2RZNkdLRlhMTDBPZFdGYnRKQ3dSMWFIb3VJ?=
 =?utf-8?B?VzRjTmd4VVFhVkRFSWlXeW5IVGxBNTNReXdiVmIxWW5RcHFkYVVta1h4aGZt?=
 =?utf-8?B?RGlDQk1GTVJrSktjQllIRER4RkxsZTJ6S2NmQk9Id0FXVWdkdnEyd0plS0Fz?=
 =?utf-8?B?RXF1Q0g4eHJxUitYLzNUbk92Z2N4QmIzVi9SZHR2K004dFVxN3lYOW9PT2tC?=
 =?utf-8?B?L1pIRjhlaG83MDQvYVkrYkI2cDVYWDJJak1henJVSVJaWE1wV1RiTmQrVVRs?=
 =?utf-8?B?NkNjVTJ0OTAxQXlpbDgxR1NVOU9tc3M3dTZXMVVVaWhpU29TTi9RYUZ2Z2NT?=
 =?utf-8?B?QVZSTEk4Z1BENStPcExuenE5aThtckNCRk1NZFNob05PekRIUU9QdWg3eWF2?=
 =?utf-8?B?eHdYVHo0ODBoUC9jbVRCQnZEeXZUSmY0WlhyWGZsVDkrK3ZmWjNRMmVTemdx?=
 =?utf-8?B?UXhUQjlvc0FhTFlGZHkxajl0SldYbHpkdXpCM2t3Ly91bDgwSUhlZWJPQWlv?=
 =?utf-8?B?LzdFZTc2YjhGR0JJWGJETjd0V3ZETkdLU0FGRDhkYVErb1FLcS9uY3dNWDRR?=
 =?utf-8?Q?/9mo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M2kreWdhUHZXZno5MTN5QzdxUlBQV3FDSHhxc1JqV3VzRkw1SXo2YzBYVjBz?=
 =?utf-8?B?ZUN0bGJkU2tHRVQ1VDl1MzByUERIL3k4aHNVQURCWkU3d0t6YzBlVUxaUHhZ?=
 =?utf-8?B?UW5KVEJBU1U2UE1pbzhwVE9Paloyejl3TkdJNHkyWk5qRUJad2lXenR6TUVj?=
 =?utf-8?B?YnlPU3dHL2prMDRrMS9tejVmT1NFT24ra3oyeDZqUHRUdWNyTkJIaDk3d1Vv?=
 =?utf-8?B?dGM3SnlhdnZ5UnN3SHVncXBVczB0T1lSWUZvM2dVWmdVNVVkV2RwYVFkclI1?=
 =?utf-8?B?cXZaWnpSRkpIRWo5SXhFYW9GV3l1WmZIVlozMjNudmNtS2RZS09uOU9UbCtQ?=
 =?utf-8?B?V2pjZWFOM21oSldldzNydWoxUXpldTc4aUNMbk1IQWpHSlF4K0laMVQyQnRC?=
 =?utf-8?B?bitEc1l6SmJjS0pMbUQ4U3haSlNNY0VQSDBYWWtMMC9DZ2lqb0x4Wm1PaFdF?=
 =?utf-8?B?VUU0YlNFSkZuYlRyNytEQUlvV2VEaDB2RDF5QTMwUktVY0xNcGhOVUtabU5w?=
 =?utf-8?B?RWFuaU1WaU90MGFsQ2RoT2p0a0ljNkUzOHFpNDZLSHFyRktKOFV4dTJ3U0lq?=
 =?utf-8?B?UVBRZjNiYW84MUh4Z24vVW9EUEZweG90bTJYWS9FcUgzTThYVE9JZHY2OU1I?=
 =?utf-8?B?REFmcTd1NHh0N3A2WHEzb0FMRUJXTkFORG5PbStOUm5pdktPUGJYQVBtRUpn?=
 =?utf-8?B?UjRucnJwQ0ZCcThnU1IyZ0xMTno3T1pKdEh6My9sSHRDNE1YRk8veEdJc1RE?=
 =?utf-8?B?ODRFK1JjS1RxSnNSalRSRHJ4eUw1UnNCSGNPbEV0N0UwNndoSnp5enMxbmhJ?=
 =?utf-8?B?MC9PRk5rZXNOejBTRlpFZ01VTTBLYUR0Z2ZFL2g3MUY5TXZ6YytJeGJmMFlW?=
 =?utf-8?B?bEtWV0lxOHhvTUtwUFBPcDBIYjZzQnFtdnByT1hiSThYYm5iaGdTdm84U2sx?=
 =?utf-8?B?dXpKWFZnT2YvK29qaWZiU2p4ZlJFVThFTmkrY2UzQm9QTVgrRkpyeEx0N3B3?=
 =?utf-8?B?ZElQS3FNMkxZR1k5MHFyeXZGUnd5UnFxZ2xrTFZuMEpreFhLUVo0RUc0VEVK?=
 =?utf-8?B?NlJKR3VzbDZCOGpwcTg4UHorUzBSQS9kT2JCK281WEtteVJFV2hqMCt6Q3Vh?=
 =?utf-8?B?R01MUUhwYVhvVk9INEEwNHpEVWFJbHZ1dkxqL0txTGY2NEVxVFd4N0t5MkhS?=
 =?utf-8?B?d2M4ZmRFb2JqTThwemFPT3dLVVVtMy9VbS94RXZ4WXVmMWZ2OUdyV0d1YXRm?=
 =?utf-8?B?a0tReUtxcnU3ZkRXaHpJdCs2QVI2S0N6aXg0anp3SEtJU1JEamJiZkJEY3J2?=
 =?utf-8?B?bFB0U0tZcE5FL2lXeVpqdndLblptSzZJK2kvUi9CZlJ5dUJzVW1NZjFRUG51?=
 =?utf-8?B?ZUN1Nlo2S3Bkc3llWVRRRWlxYTh6TENoNzJCV1pkQnR2bWN4WmJySUorVGtG?=
 =?utf-8?B?Ky9iYkJHTGwyejRQSFp1Nkw5cTZLb0R5Z1FYVlJoK2pmZUVSd3RLVUQvUDBs?=
 =?utf-8?B?T3dvNlZqeVpLMCtId2xSUnFZQy9TNTlkTVM4MGFLTkkrNVhTYThaK2Z1dWFT?=
 =?utf-8?B?Y2dYUlY5QjFtWGppQTNjWmJGeG9keTg5eGhXMXdPQnYzTEpVK3hSQXZNaXY5?=
 =?utf-8?B?YkRLSUEyRnhMdU9TVnppeUZzVWsrVTBxTWgxRVhHeHJBSmxPaURxUzBhdDI1?=
 =?utf-8?B?alhKN3FjbUxBekUvVVM0U1ZJWHl3Qzh2U3RXQlFQeVczdThlcmhibDg5MERx?=
 =?utf-8?B?VnRuSTIwQ2dtYjVlQW4wTVkzRWg5YXg0RW1PejBYQmlSaDBuQ3hCNU1UYmxF?=
 =?utf-8?B?STBjMk5ydzZnTGZTcVFEOW41U2xOUC9MeFdOdC9PRk1MQlVvb01xRjZrM01B?=
 =?utf-8?B?MXg4VlFvUSt1RzJwUjI3YVQrMGdDM0JWamZuYnl2aUduUE04M1U3eUUyVEl5?=
 =?utf-8?B?dUgwMld6K1llZ2tEUFRabzY3ZzZjbENvaUY1OGlGOWNobGpvWHZVWGlGNGNm?=
 =?utf-8?B?T3MwN1VIeForQ0IrTWZsaXhNRVFyTWE1UytsU25DVGdUVjRJK0FVc3dVekNq?=
 =?utf-8?B?Qmkvem5TZDhwNVZpM0hqTVkrVDdSWHVDZ3dlbWpBSFMwdHp4NXNlb1BKSXFk?=
 =?utf-8?B?V1U2SHZYZkp4dnYxamt3UVMrQ1VNNlRKN3UweU5ZQUdaZVFTZldyWmg5QU93?=
 =?utf-8?B?cnJVZGpEYjczVXQwQzduNWh0VWlWMVg5aWxRbGRDaFJWRE5jRUloVTBXbHNU?=
 =?utf-8?B?RE42MWdBUTl3THpGVmdvdWZ3TkNxOE4yV3NFcUR5aktPNkpxYmRlUXhPSFly?=
 =?utf-8?B?TTV2R0tabG1RN2VNUkU2YTdIeGlIakFISWh6eXdhS3didjg3YS9CNVlvNTYz?=
 =?utf-8?Q?TpazPORI4yPoEkbt3Uq5DfnYXko/errcFaxScDeN5uC91?=
X-MS-Exchange-AntiSpam-MessageData-1: l5t23DSTI17odg==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfa06ef1-b68d-405a-349b-08de6a7bf63c
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2026 21:16:18.2918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kw4Dl/vdO9YvHcXD0wEhCSmF0rhSSrs9ejhdMOn59NhhmoFnqQcxIqojvqBJPSjRzHrISK41mq9iJYsOsIo/vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6457
X-Rspamd-Server: rspam11
X-Stat-Signature: 5uyth1yyb9qf5hs976cmxop4xztrz4co
X-Rspam-User: 
X-Rspamd-Queue-Id: 59B5CA0003
X-HE-Tag: 1770930984-647240
X-HE-Meta: U2FsdGVkX18UFCc3xSgPCNGOibMDCRi4Wpx9LbXM+jKm+497ok0U/pI1RzxmznxhnOylkAE/6DOOr0ELxjQ+l/Kq4hDSibYBKTKBoJOgwdVtDDh69KxKOzhssgti9fMmYU+VIokhyrMHGoKOH9sQY79WAeLgLradNJDDDah6UUrIIpHseNN56w//HHvW5Yk2gFNj8d77uDerfqIpNVD6o9HpSpc5SfcSTAipWlQgp+eU4GQCjidelvhghgl7BXS98qQs7yx9p5ZOp+cIXgn+APAhmmFU8FEluMvZ4W4BSja6nm/2eUMlf4ERTL2+BtC4EWHwfv62FWxa4Rpw/YjCgXquuHzTDLpd5mruhm0f4xGuMRbrAX0NFPx6xfEaVvEGo7pkvratbuiC6BQQPz4IJ/sYqPuRW/7vecKb84tivjeIY07UsmNNkf3Y/u+UE+egeZAUDvmw67ZOZiIOMkzz6y5f2LFhvlA2snbVCmAbfwkw+0MRxvs/kEzNz7KaaJ84itXNCYSkTCGqI/WyucSuS05v4+3gU10rbiLlob79IMioe++S0QkNmhWH2SmAlJDsJgPe7WS30tLt5ZzOqx+wTFxNAlv0BfaqnCeL8Tx/xNVxLypcNs51R5SkuQb3dnl4RMRJWagunuRJD3egeF6Pp+wl6knu14XoNYi9UXKaWqxP2lme0wuQgZBgLCGflgOT0a5I8aCFuxUgDZOHLCkulieVkFhfI7zhsl01/aGQnJm26L1NKMdArD3NKhGXCusBjprxFyZpavrckJD0QlqACOS8HZii4TwYj7HKI12BzD5I1cnbrxKlq4R28uoLPgWzhioprNXNYidSAPhQGuP0xMPT2zRh6+npscpyZPIpTZyhxGiLLlHHG8+ZVPKwahNCQWZTiOJXYd9aCe3vr8nfM8YUDpu2684XytdFbvZqDlZpzJmCorTA2vNEJfxEFFaGp23X9YL2p/9pITYGeS3
 ujIXl7w+
 OZLXEp2rtOrc8CSrnJTy1nBo3AsPbaiBNia8l36incn4ywfLsoCzB1iaV6ji3ZBGHzJaY1beHSHZY58AnQGZ38K+VRDwjJNtdJbt02H1k5l8n0rX1rcxpC7TxgE/ROueN4PxaiK7/m+QM2lUxLtwUNd1z/YqG/wU6EA0JnDftW+pQRgXW0yzDth8rTu/Su2TMLMS6Ns0y7Z5ay06mhKQRMnpMYAUdn8XCuZ1CwOAvWEqVAAcs8uUUYx1d3iq+F/Ytpmu+2PTJw++AvEYpXZ9ZdBU2Ib0FkKYBMX+c/wy9h7JKAu0jQHp1mKlhaoABkGoQz/FCeIC7WrEkW8HM3baBCiE51aNXahd/XPYnOu9s0xzyVW4yL4ho6dO8RUpSMdNzM60SycCLNRhCL2lXJvuZ0m+H7niOH9LM5P13D8YmFetEhNsJMYcLT3gXLAT7qenSqJ/HjjE6GAwijjMwSwkHILBZb10CBCV2nDYKOujBP5TihjX1Htym0/n3nmFeoHXUWxn9ZkhbwjCoN3gvX10n0jQY7TSgwKjDUnLaRmrkhiRbl2PIb2kwv/bLdcGTRAVpkejmnDJniZdF5IZeK9esu0fA9w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/12/26 12:46, Davidlohr Bueso wrote:
> The softleaf_is_migration() check is unreachable as entries that are not
> device_private are filtered out. Similarly, the PTE-level equivalent in
> migrate_vma_collect_pmd() skips migration entries.
> 
> This dead branch also contained a double spin_unlock(ptl) bug.
> 
> Suggested-by: Matthew Brost <matthew.brost@intel.com>
> Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
> ---
>  mm/migrate_device.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index c2855235fd9a..b40c1d49677d 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -175,13 +175,6 @@ static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
>  			return migrate_vma_collect_skip(start, end, walk);
>  		}
>  
> -		if (softleaf_is_migration(entry)) {
> -			migration_entry_wait_on_locked(entry, ptl);
> -			spin_unlock(ptl);
> -			return -EAGAIN;
> -		}
> -
>  		if (softleaf_is_device_private_write(entry))
>  			write = MIGRATE_PFN_WRITE;
>  	} else {

Acked-by: Balbir Singh <balbirs@nvidia.com>

