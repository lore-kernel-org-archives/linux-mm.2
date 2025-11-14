Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2D8BCD8CBF
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 02:11:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD6E88E0003; Thu, 13 Nov 2025 21:11:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D86A48E0002; Thu, 13 Nov 2025 21:11:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4D5C8E0003; Thu, 13 Nov 2025 21:11:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AFB3E8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 21:11:32 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 30EC9140233
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 02:11:32 +0000 (UTC)
X-FDA: 84107586024.26.5DAAEAC
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010026.outbound.protection.outlook.com [52.101.46.26])
	by imf09.hostedemail.com (Postfix) with ESMTP id 57C7A140006
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 02:11:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QQ1iADLn;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.26 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763086289; a=rsa-sha256;
	cv=pass;
	b=1GHrYpv583EpcXRK0QOH4Fdhoh3ARsjD2CLvjmTeiwvon6heCQhG4Pr1/Ml+j8aa+JLaq5
	/IBTWoh7C+gWtMuDHQA4PLKGoefjOOzghzOreAyWpmNJ7qV43mn/RtZXJYwU2GZtHqKwvG
	RFv7Hg22bZHPGMQWiSiqM48UkYAhGfc=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QQ1iADLn;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.26 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763086289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8xMxoFyB1SLKaDRN/WrumEc7KF2HKZJEZW5ll7y1wHE=;
	b=x/ysZx5Gvi6F/1b7hA0IkBGlZ7Ob7OFCQApS5W6nr6+DJzSBJoshtv3cXCNsmt/45nLXOX
	VzoaiFs1JxsXna2JjMR3Ckd5G2cRv4HJ1bqJH5gtBqFVi9kDdRKj/KzydcBZbMebF4jYOz
	lQiZ2Wkd5j6fI1QaAsDSMFwh+aiskGQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ebcCEL795OhYRbPOUMuaIPqFBGEEpux4Qx4PynIzabX6/KDzNcXptaDsJFXxnHjLEADurzABeswAr/fp8cJ9r9BPdkaKSnpyq+Pt+kdl/SdQP6XOE4Z0P6stReMibxwJs0Uu59sK5BcHsJms1peUQ0u3nCmjZ2l5tIWaGhMtvIHNDbJcvgCIpgEJSQd9TBIMkYnDyobMgUuqY05lwUCrlaqMxaTc1wGSP8Jo2tm2BZwUYHarLXhcPcoTGnJjbRX41lg8Adl+aUCGHHrC2tUYfpw6wzawj2NCQJqPcfnH0ge4wSq5IGM2nbz6EGfdL73jH5BIhp8965OsaYUSubMJ9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8xMxoFyB1SLKaDRN/WrumEc7KF2HKZJEZW5ll7y1wHE=;
 b=KV0IY0rH2f3iik1LLediRraZrMGh71Mo4S1YO5CtkBO273J90BfQ3bzbXjyProZF5hofJvjtLLRFWxdAPtJpTM/7JWDiiAqhEmM9/oy7MFHjWrZz7s8PkWaS2L+56wf7gdOHcaNBMUeE5oLgLEIubjN7LHlghUsyFFIgJkFcQcJrBmU7jciE7F6J6owJNpiqDJJa4uvFFVYl6spNO0jaTKk1JYnV/bYtzS/PjzvzNAmLM2tBw3FVSBE+pPLh9hmhwg7fVRTFHDANb9vc+/F5/Q3JWYxY0CAxAz+hjl/u5qINJw/2dwr2XZ6jLz8BoQt3Pl9+D2J9n7GBrAbxbzlgfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8xMxoFyB1SLKaDRN/WrumEc7KF2HKZJEZW5ll7y1wHE=;
 b=QQ1iADLnEVkJXDYiczandM5jZyWQomqLeFi9FR3fxU5W9p2HBtjjt5dkU4iYCOEpn7jmY0wJKMBGo7K3yokT48ItokJKaWU3v4UQJRkvcwKeNz5gwS9QhexADgjjtuV/7kCNpaoU3rQVOmyDAtn8o6lWuktwq54/E4wMGPUIKeKHMVZDbBEAgKZwhpBck099sD/MXwHINDtUxbaaZiKtBYUkEM8BrIQvty+B9P9gDswbw3yippqD0GZRbo/+91q9JjtjfeFxTzcOvXRCFR42WQ7jz2fLmgIU8wZvNyzOMlEL3PmoseWJ3uultencnxVJ8Hr+P4lCAva/AtQAU5y2wQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SN7PR12MB6789.namprd12.prod.outlook.com (2603:10b6:806:26b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Fri, 14 Nov
 2025 02:11:24 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9320.013; Fri, 14 Nov 2025
 02:11:23 +0000
From: Zi Yan <ziy@nvidia.com>
To: Balbir Singh <balbirs@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 dri-devel@lists.freedesktop.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?utf-8?q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
Subject: Re: [PATCH] mm/huge_memory.c: introduce folio_split_unmapped
Date: Thu, 13 Nov 2025 21:11:20 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <210B3EB5-F24C-4A4A-896F-1C9B30A7C6F5@nvidia.com>
In-Reply-To: <20251114012228.2634882-1-balbirs@nvidia.com>
References: <20251114012228.2634882-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR03CA0179.namprd03.prod.outlook.com
 (2603:10b6:208:32f::33) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SN7PR12MB6789:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a65dfaf-466b-4160-e09d-08de23231c21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z0NGVmRQcHlJLzJqa3Z3TmFmUUZ0ODMzbVNKNjJIN2EwdTRDemFVL2dUV1Na?=
 =?utf-8?B?MmtOUjFLakF5MllmdkdpV2hYbDBuL3EwMlBiUXNyNkFzdGZCdWE2U3BjM0kv?=
 =?utf-8?B?c0IwK2FhOFIvWU8yUTVSZWxhY090VW9zeDhrejl6WFYwNUN4cWpUeU9NNFBn?=
 =?utf-8?B?NEM0RWhKNCtYR2R3bFlPMVZsMGhhWXgwU2tmMW16ZS9OaGVscmFTN1d5UW0w?=
 =?utf-8?B?YU53d1Zzanl6SUhEQzRCRnVUa0dMNHlWM1J5MStyS3dENHd6clhDeWlCdmtR?=
 =?utf-8?B?ZTI1OHNacHZFVVk4QlMrUGMvOTZ5V3F5UmlSa3Q0bFVjN0crbFpTRFl0ZXpY?=
 =?utf-8?B?bktONzhTNmRlRUdXQlpNSGR4dW5BY0d2WVF4UysyUk1IdnNNMEtjTFNkZjhM?=
 =?utf-8?B?Q0ZSYmY5S1RmSjZlZWtOOEhLK3orcVJKNDZzS0MrRzR0WDN4cDRNdEhYV0t1?=
 =?utf-8?B?Mk00NDA4V0piREdFdHEwcGhjcEJrWlVmMDI2UjQrazI2YVR3bmlJUHVjVjdJ?=
 =?utf-8?B?U290QUNIVkRady8wblJWcDNaSWNIMERDYkFPOWZGbmlvMkhwOHFDam9iUVZK?=
 =?utf-8?B?ZmlEMFF2NVl3M2pEN04zYndQQzA4S0ZOVE40WXdnUXlzRjhJMDh1N1NEMGhZ?=
 =?utf-8?B?TGd0b0VsZmttS1RhUFFvVWh0bzcyYSt0dG9mWUJ4dlExeG8rRlZxYk9VOXlm?=
 =?utf-8?B?ZkJqR20zOG5OR2RFT0hpU1F5NFU4SWFCaVRjaWsyaVFLVjA2bDA1cDhqMDBQ?=
 =?utf-8?B?am5waEQzamsvR3h1MmxFL3A2Zzc3UzllajVEU1MrZnBWZTk4azMvSzZhWGR6?=
 =?utf-8?B?UmlNQ05uRnpNaTVzWm92SXhBMkRWZmlyZkcyUEFadzFYa3pwaHMrV3pmcm8y?=
 =?utf-8?B?K2RrUkgwZi91S25VUWg2c0ZwREhNZnd0UTRhUmQzU2ZpLytqWXVEekovMFV5?=
 =?utf-8?B?VWVFWHlqU3FuZjkzT2RNZUM3eVJaYmFWUENiaFMzMy9xTUprQWZ4Uk5RSllw?=
 =?utf-8?B?ZXl6VFR6MnFvTXZsMFQwQUwzTjVIcnJQOUxwTTNQams3Y2VqMDMzOFBxRDE2?=
 =?utf-8?B?Rk9zZkNYMXkxaTNpZDdQSlVvQ3M3YnBKbHltVmJCN2lGZ3NaTHBZQXdwVGsv?=
 =?utf-8?B?dkdlQ3VoK3pDdjY4cExuMlU5T2x3RURGQmtCRlFTdXNYSEJTQ3g1ZkhpQ2VH?=
 =?utf-8?B?OWYvRERVdFVQbE16Rnk2d3BBYUJLQ2ZXdUVRS3YvcWNtNFI4T01iOWhaQWtj?=
 =?utf-8?B?U2pjYVA4dEJnL2lCamk2SWlFcmdlWGJKOGVoUzRrWUR2T0djd3hJS2E0WlJJ?=
 =?utf-8?B?aFpuN0UrY1VpenJHRXJTcmdwTHBJNi9MdTVGNUhSMlRJdVVDTklqR0czTWVo?=
 =?utf-8?B?Q3UxZlF0dDdOSyswRm82ai9jVzdKUExaTTRtOTl3empEcXJkeWlFcGQvOWkz?=
 =?utf-8?B?YlJXbFVDeUt4aloyd1FBT0tKMDVQMHdiZGY5K01aV3lrRWZVbFVORU5nclVi?=
 =?utf-8?B?MS85bGNFZndTWVdkWmtaSTQ4ODV6OWsreEhnU2JxcWNGc0RZTDF2YlFmTDV2?=
 =?utf-8?B?RnJLc0svY3lubjM1NVRuanJkczVEZWtHV0dQZzU1Z0ZVWElkbkRjYTNlTTFi?=
 =?utf-8?B?SmJjYkQxWi9BdE5IY2xOWnE2REQ2UFArdHRhYzk4bCswU3MzQjd6Y2ZWM0F1?=
 =?utf-8?B?TmRaWjlFc1RrYlVGRXpmeWhwNFlYNHFNVVBlVFlGM28wNjJnQTl1WWFKQjQz?=
 =?utf-8?B?ZUI3elRUNE05b1pEbCtvSjVhYXJCMmZMdTYwRnhUVVpVMHNGcFJ3ckhPL1U1?=
 =?utf-8?B?ZFVZcWdQMk9BWHdlM2p1RUkvVDdkSmY0STFvZjhqMnVGTnpTR21VdjhvazRY?=
 =?utf-8?B?RTl0YjA0MWNMZWxNby8yT1QxcHpVUVY5blVpUG1FYXhYRmlKTDJaQ2JoV0Ni?=
 =?utf-8?Q?r1U1+mq+LtGsnlo3XbGejbbRovg8gGZs?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WENjNXlQcThqcTNqOFdPaGliUDFGS25Sb2RnU2NjcUV1c1dNR01yZXZWUmpq?=
 =?utf-8?B?MVRXZUdMNmpkcWFiKzV1OTVwZkVZV3hlTEU2NVAyVlNhbDY0L2UrT0R0Ujc1?=
 =?utf-8?B?YytVQWk1UEJXazFQcVJXV09lYXcxNVRsenY2VzkrclovTjlIWnRmbHhpWFM0?=
 =?utf-8?B?VFZGdUhjVkVTU0hkTk1GYUhqSlI4dlJzeENHeWZBaWt2dmR1dzFNOHFlOFhH?=
 =?utf-8?B?ZXBnWnVVeldudFhTbkZYaFlJMXNJMHNpRlFqMmxrUG1UNFJnODREL1FDUDJW?=
 =?utf-8?B?UTArYjJQV3FZYkRqQTBtZ0Q1Z1JaS2dEZkdwL3NZNXozaVhUQ2JJWTNoazRB?=
 =?utf-8?B?UmRFenVCcmJsclhRelNFaXZuc3ZNZkpYVndqVS80c0RPVDBUUTU4V1hpSS9D?=
 =?utf-8?B?YXlIRHBJTGR1ZUp1RWcwajRjUUpZZDNCUWRXZ05DbFdjYlFRV1lMSjJvVTFD?=
 =?utf-8?B?WWxsbjIyUS94dUo4NlROSTVDSWlPMEhmZWRjcWIyMGdJZlBSaGVYZXpOZGJW?=
 =?utf-8?B?YUFjekJDZ0I5WjFvNW9KZ1FVL2RaNU1nRXE5YVlCSTZPYXRKM2NkSEZNc1g4?=
 =?utf-8?B?MW9wRUxOaHlXSmxtWUl0cjkyU2NwVTVEbDdiU3ZsTndwVWdrcGpZdXBKN2Qz?=
 =?utf-8?B?WDNsY0luZFpBTThHcE52VGl1emhWN1BRQzFXVm1JWkFpa0FhdC81YjloQlhS?=
 =?utf-8?B?YjY2b1J0cWcwbmFqbTNuc3RBcVlFUnAzekRlbnR2cDQ4QWhCRG1XSjk5YWs0?=
 =?utf-8?B?TTh1WlVHdFo0RndYZzV3Vk05eWFsQUZINll1R2dqYmU4Tmh5RWc2K2RNd0hl?=
 =?utf-8?B?eEtmemR0Si9tMTdDRUFwMEZ6eXdrRjJrNk5pSTlwVytlRFNTT2E4RHJLOHdH?=
 =?utf-8?B?VnNBQndPaDYvbUtuR3FWUk83S3pPZkVFaWt1azZLemczUWJlRTRtVER4WTc0?=
 =?utf-8?B?MlZFRndGY0xQazlrc1VqeFd3VTFUYkY1YVNqMEdPeWJ0bHdPenRFYVo3SDc1?=
 =?utf-8?B?aTNhUWVpVUZ3bk9wTTUrVXN5UktUTEhBbVhwVkwxUzlvbW4vcFNzbVVLRVdk?=
 =?utf-8?B?MW9neUdqVnNpM1hOYzlqbDNIZFpvVkVPRXlZWkd4eWE4NnFhQzY5SDVIYkZN?=
 =?utf-8?B?Sm9Neno0ZWpvMmJORDN2aWVXTFNVakE3cVFmRFVRamUxS2tMYVZaZ2Fremxk?=
 =?utf-8?B?L3NBQnNtb0VEMFp3azhoTFhyeDRiRGsxTEdlVkpQVUpHQlo4eEs4eXNzU0Ft?=
 =?utf-8?B?b0RlRjFZWURxdktrajBTTHozcVA2L1FpRWxZamlPNlRuVnlQYUdzTjA2Y0hY?=
 =?utf-8?B?eStSa1c5c2lBWHVxT0dDamQremJYZGpKUEE2eFRic0Rod01mdmFHanhsaEQy?=
 =?utf-8?B?ZmgxUllNekdscDIyVXJXc1NYa3BPL0w4ZFRUUHhLa3J5TDA2dzdmays1eG1y?=
 =?utf-8?B?eFVDeGRFNFkyU0JxbHJXVzB1RU5xR2pzYjVDSEtOMGM4OUJQRnl4K3c1bExQ?=
 =?utf-8?B?bXFRanpQb08rWC9hUVZraEI5YVFXYWJlcnVlK1lERFI2WGswQWl4bkozWXk0?=
 =?utf-8?B?S0NPVHo3anhXVXArdUZVZmxpUXlWeFVxSEdWSFFIWVRCZ2lNRVc2YzlUcExo?=
 =?utf-8?B?Rm4wTEdiMGJKVWxQdFE5anplZEptM0FUcmZ0VEZQZFZrN0lZdUFEVUk5Mmp2?=
 =?utf-8?B?UW9YclFhdlkzbmZITjlBYnBRVUJhNnlLaVVxT2p3OEJScWxFam5FNitFM0tH?=
 =?utf-8?B?MkoyOTc0eUMybEEyU1EydjlwQ2ZIaHNLK1YzRkNhK2VVTGJDTG5sakNNSFdS?=
 =?utf-8?B?bUR6eTlzRWIzaTNPT1c1M1JXWTBvMDFkNEdReEgxb2RCMUtQRUNDWGRNU2R6?=
 =?utf-8?B?ZUdMaGN3VHlXUk5lVitCR2M4TGtrZVBOVDErQnIxY3MvaDdadGJJejhnWXQ1?=
 =?utf-8?B?TXZTUmR2QjNGNE00WTRWZTlXRGJubEdpaGl1T2FhS0E5ODd6LytpZEQxZmFC?=
 =?utf-8?B?V2VzOGdjNWd1OFR3RFE3Z0NyWnNnZlhFUXdWOUt2N3ppUUtPY2puYzAyUE51?=
 =?utf-8?B?MVN1Umw4VUtBd2xuWERRcVJiZzBTbVlZaktTOEpvV3ltWTYwbmI5LzVwdjhX?=
 =?utf-8?Q?a0t0zCImE178Vq5AVuTxeROH/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a65dfaf-466b-4160-e09d-08de23231c21
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 02:11:23.7269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wyxUd85dNpQqB0k/x9j+IvyzPcUYk20OYjiEYTvEFeFHmtf2LzYtVhR8PZjd5+sG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6789
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 57C7A140006
X-Stat-Signature: aphmp3c3bu54qz39dxrsrmkfm8hqi6z7
X-HE-Tag: 1763086289-654797
X-HE-Meta: U2FsdGVkX18YaZAMDQTiDZeiVJesOuu5QC0+HWYeJm/7SoMOW4JR4kxBKF3s5uh3GDkXZePFa0ZTBsU37bvThdvcZQw+I2tPA+dHSXgEX4/Irifec3Exe043rJ3pqaWsPPT9fALmnQmjTp+6AJ3UrcCVI38fLD2ToJWI4vRxOVN6UoUCOZYrU+sjyZyLVDHng5Zb/BIT6fQkcw/0W/QCtgR5iGrcXDJaJgW7MeBpU/42ICOxqxaEThHpGgoU9I1c/8Zgm/hO6BgMJbRkkJ47kEwtIqgKtNacWtPQ9YnB4qVffS0ki+xCXuTF9nFijKb/RZhCQ7KJjnS4RuLi/+3CgwAY57WYFaCvFk7U4LQn3rnh4OB9Cedxwcf72XLrZ9JzNbsDf1+ecI0pZmNVnKMfOygNwB4FkC2BB/FhCb637PLko3BbKgsGDuPNUjsyOls7cMIbNn0yUFm7o8/2E48Y/IGP/l+C9bsij9BRC4gFfDRbNjpCwiyRJN/gYj+cfocySk7+dfFofjKlXeMclaGvf5lpVhx4EGTDlpXiM0U0od4u6dirs30nMiDdnXfHEYF9zWvKReDZ2uz8DnjVQF6te80+6OVk7vY1HU9kgJDuURLqrQNleer+MsK0w28zbhaca5cotEA1832HJpFQOEpW90GZNP8WqHGsL3pQ6pkMMij/ICDe7tNqZbDihLpO6es/96nqTZpq9HGL8C1xME9KfjrGy3oc9USF32Ro2lFdQUDqMT6dR/Nh+V6rEyKq6bVxz7Bu72+lvExElpWcTHNQ66tdKwRIhnTbSDCtmcUAcVbVVTkKkhYH7YhaZtsdmQAueYgR3lwCYjZ8tBcaBwuu6s2yvXmMJ91VEterTJPsZoU0MMmVF48xUW9PETS/ez/avhRYhebOwst9V6i/qE3g6ChUWKAoB2l/ANWg36WJyqlNfC9BSY3WE2Y0oisdIh4QFguBs7iWr9BexxY0Ebm
 jsZ1m1Qh
 BPBhwBtqsl+AEfxjaxdaeAVZjnmyThr8+KNqAZprSn2SvtmDkQCsm4BboAteVNLjGdMF0lQ2Ds5BWa0dl7nUSqFbW8tnKAxpga4E4NmAL8hXGcAyRIcXYi9OukRfstsgWwdLsz8k9rN0JgLa0LQCotcrIy5Y2E6bLjBxxxIAZtyYImiEmcrBqEkBiRZimLxcBoK4qpM0zT/AflhVt7e/P+1kGc4JfkC4dSriomB4zOOuH6Uf7w+3q5OWvSFcZpBMJo8DOLZeY9NvvoSXBYDrs+0NbQ4fGYjvcxXOBpPDVHUzrmP/EvB+PmfiNIqHoaB6Kxl0deifX5CQ4nJVgTrdfjxXrN6jQJz2fyvUo5GP2pnMSkaJd0q94i12He2eOchaWtJDTcBaSKQcyuGOOKgzRoADb3P+FvbQ6tSjWIjFRzhlP471h9/2+ktkWPsEfOSQ8cE8KnM99Dl1ybQYPL6X3exUP5gq9y/3IZ19YMxoqwYu5KdPh2hes7hyESRBFyp42/kXUX4bC20zeNz9E27NXh1wxvpAkxQX8AsXSvAiM2qjVnNQnE73s/DSIOQcJdZ4nht2k1LlfdYEWGV0Npq+Wy3RRcH+J89KleM3r2puRiz7FqNVO5QVcKwjC7wELAHlREP72aPKjZS9t3AqCEiA1USruSTqdwduWgwekthVd0Zi9zAOcP0ojpaVT3uByGMClg93+GIQNgzhRl5L+iLqvYtimC4nOajpGWRk1Qneancl22TZg+Uk7j28YzdY7r+lH7nzSMtfT1i8wgrdXOjLps37ehJYVlFcgpAJQE9dFuXiQu/3VZKBze8bFOffWTaO8DVXMDl32coa1z1pGXlpjOp+WKd87kCgTLp+r6q9gHqDLYC7aG2evw2eR88gbf8ZjnfIFngKnXiGMXV1IL+LF0Lpe78qCkxXGxEqr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13 Nov 2025, at 20:22, Balbir Singh wrote:

> Unmapped was added as a parameter to __folio_split() and related
> call sites to support splitting of folios already in the midst
> of a migration. This special case arose for device private folio
> migration since during migration there could be a disconnect between
> source and destination on the folio size.
>
> Introduce folio_split_unmapped() to handle this special case. Also
> refactor code and add __folio_freeze_and_split_unmapped() helper that
> is common to both __folio_split() and folio_split_unmapped().
>
> This in turn removes the special casing introduced by the unmapped
> parameter in __folio_split().
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Danilo Krummrich <dakr@kernel.org>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Cc: Ralph Campbell <rcampbell@nvidia.com>
> Cc: Mika Penttilä <mpenttil@redhat.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Francois Dugast <francois.dugast@intel.com>
>
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
> ---
>  include/linux/huge_mm.h |   5 +-
>  mm/huge_memory.c        | 332 ++++++++++++++++++++++------------------
>  mm/migrate_device.c     |   3 +-
>  3 files changed, 191 insertions(+), 149 deletions(-)
>
LGTM. Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

