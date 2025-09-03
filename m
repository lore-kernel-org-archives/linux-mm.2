Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39CC9CA1007
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 06:05:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90D948E0003; Wed,  3 Sep 2025 02:05:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E4F68E0001; Wed,  3 Sep 2025 02:05:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D39B8E0003; Wed,  3 Sep 2025 02:05:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 69C628E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 02:05:19 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 00EA5119DE1
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 06:05:18 +0000 (UTC)
X-FDA: 83846901558.06.34DBC48
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
	by imf17.hostedemail.com (Postfix) with ESMTP id 53D7C4000D
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 06:05:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="gTonD/Ws";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf17.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.223.61 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756879516; a=rsa-sha256;
	cv=pass;
	b=A4n3hmmfswWoFuelhKaHFxKzZgwizT7B+TXXfKXwqekRI3SpzzTFNSqNz4wPskoRvr1HEa
	Z4DPrzUybouBRGnLul13sc4jqqhwCRhLr6Hg8Qx0yjuLUuYLNkU7GQ1LGb63jfq9ErL+5W
	PqriApFLLs0ynjIV5dCswK+LoSyFyyU=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="gTonD/Ws";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf17.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.223.61 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756879516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oc/wKvk/PoR66Pla0Q57gR1wBuIbcwgu4qYhO2KGP28=;
	b=BfLSD+FjAbt0gDwxmdX0+JDeDeaKb327a74CNfFqrDhiZFVBnJYcm6B6RwTf3LUpkDRq+y
	gckIemnLyp4FrSZlVQMBDw0sjpSonxz9z87ibBEhaAjLLFYTiHUTFm1X31Rq04g+SlkIm2
	STrEZ+AKQkhZOALFjT7LSagZX4WGGt4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AW6F8XaJHpyRMLxJGwi1008aooVOxRCkdQhmfmcyjhXcV7c2qdiVkkdyrXw8ivURPLVFfHKpfzGYHGhAEfurfp/kQXHj8rpcIe1+lhDdE7ngObuKVWOBC2DHNgSB1SV4UNA8O/PikV1NMfHIAFQLjfszf7qK7S0SdLWl43E0dzlR9hJ8Okm5Ej5MP/EU6z0uZ0/CvwI4zVGZhQY0fc7sQpLNYem1cdDaZ8T+rynLBQ+2D6RUFC6xBetUbpYQvF717H1HuShpAVMStBA+Bu00E59WomZKmglcsQrC6JdxnJkA9Af5SYsiLVEbeg9ftK5TdGbOSgZ1tIr65CvhPTdI/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oc/wKvk/PoR66Pla0Q57gR1wBuIbcwgu4qYhO2KGP28=;
 b=YUhSg8w01L0jebAIPRT1dZY6eU9LejgOuFORHiWg3s/FYh6/tGBBXm68XtBHVIJDomgTcesCa3oViqod35R5uw9fnoqU2upJsOQ2qDM8U3WNG6xofrTbW/vGHlpbKiMKgeYxz4LGTHYre2Sk4C6WDj0h87+YkVmuV5obLM+j1Gs1A750eSYvu3X15Fe5Dc0s/NmKRQtYzqR+v8gj2WnGNUF4ejMwzyI+bp1jzfyDPyr/d6THX44EjgH59x/zCNkR9mA8+Te+hVWEE/pJgpNz7Mg36P5lZJjyCrN9ueJw32qzvA1O6a+0Dnxxg+0P4SCjKV/i09dhQAJPlPA9nbETNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oc/wKvk/PoR66Pla0Q57gR1wBuIbcwgu4qYhO2KGP28=;
 b=gTonD/WsYX/MURlkbzFGyJgwN6wdgsJkQ7MiaxCpP0a4Mri7YAzjvzkYTnkeexDN0ej2oEq4edHJZ59BfUHuFGJ1WEKJrKaTNLELilxTonPqrBGy5rnlyStPmG9TDF/qMN/eo3gF0j49BvmJmYuL7HgGLgTsMxQ+Lx0P2iJ8EH0JRhzyYR8yfVOsUeXMQId61fRPNttA1GpBV37pKxx1bECfDunEETEZn7/JuJ+mXwKe54qJKz0f4rRdifUQPS9ViRO+9DfTKmPmq6qMoqkAe8LOBXY0lD6CW90Z1ZsnTylZ0qQSBe+pLavMa8kAoEvm80C22+dBdDwge7RCL2qohw==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by SA1PR12MB6704.namprd12.prod.outlook.com (2603:10b6:806:254::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.34; Wed, 3 Sep
 2025 06:05:13 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9073.026; Wed, 3 Sep 2025
 06:05:12 +0000
Message-ID: <6a178e78-9ccd-4845-b4ca-1e84f7d31b91@nvidia.com>
Date: Wed, 3 Sep 2025 16:05:03 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [v4 05/15] mm/migrate_device: handle partially mapped folios
 during collection
To: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: damon@lists.linux.dev, dri-devel@lists.freedesktop.org,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
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
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20250903011900.3657435-1-balbirs@nvidia.com>
 <20250903011900.3657435-6-balbirs@nvidia.com>
 <ea6caec5-fd20-444c-b937-6cab61198c46@redhat.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <ea6caec5-fd20-444c-b937-6cab61198c46@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0142.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::27) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|SA1PR12MB6704:EE_
X-MS-Office365-Filtering-Correlation-Id: b4177503-d4d4-4df5-16a2-08ddeaafd7f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cnNmZXVjVStGZWFiMUFTK2FybUZ0NFBXUTFWNVpDdklGOGRKYUZYcnZ0ODNN?=
 =?utf-8?B?eU1TaW03Q2xETjhITzQxbHlVcythS0hHSHNydjF6YXYyZ2JhekJpajNxRGh5?=
 =?utf-8?B?S2N2UFQrZzBVUTdLYTB3YXYzS3VKUUpIZmY3NllPMXpOQlRFOVF4ZWpvdFgx?=
 =?utf-8?B?c21sOG1kS0hsQ3puQ1lZZ3hjb1lWQk5USGcrbndpNHhjNzdjZkgySi9zV285?=
 =?utf-8?B?YU1ucWR6djZwQ3MrWFVOazBTT24vZ1VQNmkyNVVQOVVpRFlMYnlFejQ5bTVL?=
 =?utf-8?B?Z3krQ21kenMySmwvOVNPY1Y4YnFDMkF3a0R5WlgrM3VGeTNnZTJIUXZDMTF4?=
 =?utf-8?B?WklHSFZ1cEo5SS9zWTdEVWVzTGhUZkRVelN6Ly9kOGd6T3VhVkR5THRucWFm?=
 =?utf-8?B?eDVPRFloeEhpY3FKMVcyUUdqOG13Zld1S3JnWXd3RklFOU9zRWhuZ0QwWHVM?=
 =?utf-8?B?UkpnOEl4TDBSYlRhZU5CWklHM25EcHRvelRzbm9WenlKRnBPYUdKd0tHeDEw?=
 =?utf-8?B?dU8zaERDeHJYV3d0d2I2QlJmbGozQTRqcGtzMnFWRURjaHpzcjZ1V1BXSE95?=
 =?utf-8?B?RUtObHFZM0FrYzJ1RHJteGhMTktmcHRrdnFsNWEzQXorMWNkQ0NqaW9pcnRu?=
 =?utf-8?B?YVRxbVNZNGNKOC9iQnlTZTNxaU9lOHY3eTk1dmloNk4vTEwzL00yclFVUlJZ?=
 =?utf-8?B?SHN0NmxLbUhDalJkVnZsMUQ2RGtQeldKM0hIR2NBMXFBeUdHOU5USTA0bFpz?=
 =?utf-8?B?NXJQRFNPRExJN0hnbEg4Rmhac0tDRWtpbFZMdDMzSnhmcmtvRXJqRFdjRnl5?=
 =?utf-8?B?WlZVdncvWnhFSzVaWTBuSDVIRS8vWWY5QmJLd0Z1aU1mQWxzQnloeEN5R3dC?=
 =?utf-8?B?YXR3Sk82REt3YzlCWmpoczlMYytxakwxdzAyOFc4SzVPczZWYXdQMjRQZWZE?=
 =?utf-8?B?V0tpWkNHOWFGRHQ1UUJTc01ZbldpY1RiZ3ZZWlROQzU4NlBIUWt3N0haazc5?=
 =?utf-8?B?djU3aERsZjZNQW53WWU2TEYzZm5nT1VQcnpVd01SWHlBTElZMy9qeTR5cWc4?=
 =?utf-8?B?Q3ViY3M2UitjdFYveDJXN2x4N2lwZkJiU2pTaVdsMXo5bDFHaWp0cS9KZ3ho?=
 =?utf-8?B?OWRabGN4N3YremgwTWtpS2hhTXRKQXEvN0V2VzBNcmJNcFZieFNGZC9JWEVk?=
 =?utf-8?B?Ky8xbmVLK3BsUjU0ejduZkw2R0FKYTU1YUxrNXdhVzRLYWlDVWpUT2lCcWtF?=
 =?utf-8?B?WjgwOTdXUWhxQjJuZlRFWXRBQnB6MUZyVjY3UDcxbWFjM0djT1hGTW0xMm1C?=
 =?utf-8?B?aHVDeVZmb2M2Smx2aVRRRzRXTThBeE83Yy83TFNhUEpsWE5NcDRQa1paQkJX?=
 =?utf-8?B?dEQrbDdaR0xRL21LeDQyZkMxeWd4d0JRbzcxNHVBMTlpZVFpMUxuTEZmZ0Qx?=
 =?utf-8?B?aU92Q3kvelk4c1UvcU55eHdEejZJRENXNFZEL2E2OS9obHd1NVVTME04SjRU?=
 =?utf-8?B?Ny9ORXZYdUVOSDQzb042YzZLKzJ0bUMxamgxdlRSN09nZHQ0RWdYbVVocjRF?=
 =?utf-8?B?UDRCdWFtOThhb0tVK0FPWERxRjBUYldwUkxsQkM1TWJDRnJRRlpkYyt1M0px?=
 =?utf-8?B?YzZneWlYaURSOFNNK1lYNjZrZ3FVcklhMHdHQXlrd05TdWp6MmI1MmY1Zm9a?=
 =?utf-8?B?L05La0lPL0tUMXVibjY4TlFuVFpZa0p5aTlvQmlqeW43TUd0TzZ4c1JHQ2Iv?=
 =?utf-8?B?ZUZpTDY3cWN4d3hmT2FSVllYaTdaeWFWYTZLWnJKSFZnUjB3c00xSVozUFVD?=
 =?utf-8?B?aDVQeVhESjJRa2hNVmp0ellCUFVYY3dxZEdvVXZZTkFsSlJueEFNVUpBcGI0?=
 =?utf-8?B?dFJQUXVZTzNZUGkzU1FFVGpDZUpybG5lODJkRWZMcDlUc2h0TURaVGgzZ3NB?=
 =?utf-8?Q?Jf1w8/oUWnQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?anBUNmhWNGNLM2NTc0pVQktUM08vajFheUF3cld6TUo1U09UckVCbnlRWDNT?=
 =?utf-8?B?VnQvbnRlVFgzaFR2QVZDcTR3ajQxVXJUdFhhaEFNR1dPV1ZoQzVoZWljOHI1?=
 =?utf-8?B?Z2FqZ2JvbTJFajFVT09mZ0dnbXlycG85M01xbDFwc09HWWZQRjhOT0ZrMTV3?=
 =?utf-8?B?QnllUzJjZmFOWUcrM3Nvc2YyZi96cnpEVlM0azFFUWpLREFTaFk4VmVXNFdE?=
 =?utf-8?B?SlJlSDUrdEhaaGRQbjN0YUFCN1ZtejJRSzF5NFpqTXl1RVM2Q0dqMERscHZL?=
 =?utf-8?B?Qjd3V1p0eHNybi8xcGZYV1lrdEFrT2NtYjh3R0xUNjVTY2NzczNWVDlRVTNn?=
 =?utf-8?B?b1dMRmRVQjZtTEVRKzJxMjllYUhSTVI3UURvOXNOa0FOZnA2N0NyMUQzUnF2?=
 =?utf-8?B?cUpWa3g1dTJtVUhsNEc0elYzU1IvWTRVUkJKTTNRTllGK0JDMzNmd0VieDdC?=
 =?utf-8?B?ajdGdVJpM3VlVmtmSnYrdDgzM2tUdWJ5aG84QlpIcEpRZUI1aG5nSjlIMjkz?=
 =?utf-8?B?SGt1SFVJTklyZUZXR25pZ21leVVJZ1Z5cnpQVkFVeVNRWUtyWTkwVXY3aEhL?=
 =?utf-8?B?RjJmbnRHWmdiQnJHYWIvZkdXcS9hdk0wSm84Y09PY1U5a0hyeXUyS0J3RDNs?=
 =?utf-8?B?WXA0VWoycDkwM09RdGk2ZXhNemdlTlM0WjYrbVVNU2c1bzk4UHlkNEFScUJF?=
 =?utf-8?B?MFJIYVBDMmxYdVg4R1VTNlZaWWY5TTRlbExhK3BWajFwMThpODlpZjQwdUZK?=
 =?utf-8?B?L3hzeVh1a1dJOHIyZy8vUWE5bFBDWlNFaUc0Zk5VR0IxTWt1TUJnNU5OTFRo?=
 =?utf-8?B?ZXFEMzZxdDhHd2ZrZ3RXL29xcUp0NkppdzBMaDJuNGp6UzdhRG9ldzZFalV4?=
 =?utf-8?B?b293eUZLZyswcDJUZ2IzSTA3ZUdRZVIvdmg1cFVIYUMzYXhBRVdaSFFpKzdv?=
 =?utf-8?B?LzlpL2dYcEwzeEl1VmZwYyt6enZFVVRSS29ML1h4TlA5cGs3ejl2U3NCQWc2?=
 =?utf-8?B?UDZZSVpvODZIZU5KSlRPdEg0S3hHSkMvNkpZQVNURHpjQWJxWUtVR0hINTdM?=
 =?utf-8?B?K2FvQ1dUa1YyeGZJUFZoRDV2bnNpVUE1VlluYXMvMCt5bStqVGNFSDZKMXJE?=
 =?utf-8?B?Vy82OGJpZTVyZ01wbTF1Q29RSno5NmY0ZkhMcks2Q0p4S005dExHK1VoeTc1?=
 =?utf-8?B?RTN3SVIzQi95d0tlSkxqeldxUDdPK0Q3dTNzQU01ZkozejdnUEVKaSt5U0pK?=
 =?utf-8?B?L3MvVjJCQ1lDMmlLdW9XU2lWRTFTeWF2aUczQm1ZUCtGRkJPa0NkSEZaVi85?=
 =?utf-8?B?WHpIbERJUDhHRlowY0REV2tKanAxN2FXd1B1ZlFXNU5XRHM3blJaazNBeFhM?=
 =?utf-8?B?RFJEbmpFSi9oZERrRVJSQlRtUnVsOWJOZjluaFd1NUFZbkdFK0RndjJRbGRX?=
 =?utf-8?B?aTdDUDdQVzAvK2h2M0pOeStDMXVJdDUxU3F2VkRQNXF3WGhxUVM1NUVJZGRS?=
 =?utf-8?B?NjNWT1ZNaU50aE9WajQwenpNRzN4OUkyQzdnT3dXZU50SnJRL1JIcGswcU94?=
 =?utf-8?B?UjJvZDVsUzBNbXpvSmxyL3VDU05KM3lKeWJQR3p0d3FEZFJ1d2FoVkt3WDl3?=
 =?utf-8?B?OFd1b2JSNjl6OXNtMDVsRUlPMzBhMEFQczdUWnQraW14Qk5nRDU2eTUxSGow?=
 =?utf-8?B?ekQ1NGZoaGZhRzNrRDRzc2gwa3RVQ3FRaEtGQWx0N0pDSGlleUc5c1BUMEEy?=
 =?utf-8?B?cFo1WlZsYWhMSHduSUc3ZUs4YWhFNzZHb3lpRmpTVjFZbzZ1RXEzNS81R28x?=
 =?utf-8?B?eFRzUTR6V05ieWcrczRkTkI3NzJOQnhHMjNqUmYvWEpqcDZxMUFMeUlFWG53?=
 =?utf-8?B?SENZczhyMFdYY2pOb0kzVWZtQWxFNFFrWU0wUmVETlJHaERHaUxHRUZ1RjRZ?=
 =?utf-8?B?WnlvU0ZPZm4va0pRT0U5NEFnd1BPQnhFQ2liNVNmakZRSndET2tlZmRpUVIy?=
 =?utf-8?B?ZzAvOFN0L2YrRkVSY0VBUGM1Qk13aXJHS0ppZXVqT0VPMVoxU3JxZkVTamxo?=
 =?utf-8?B?Y3YyY3NGdEd4d3ZLYVo2c0gvYWh0WDNDLzRta0VDMGRYQzlZSTV4T28rQzNI?=
 =?utf-8?Q?O6GoMQ25z/Ev383WFQjOWMXkx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4177503-d4d4-4df5-16a2-08ddeaafd7f4
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 06:05:12.7310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a7qCnEM7QG53cSyh4EJ4Na0KAJIOCsDqatY4eZL+gvXJuldiacht6KymO82HIM4Cagro4t8EnnMXEoCkRQn88g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6704
X-Rspamd-Queue-Id: 53D7C4000D
X-Stat-Signature: tj7qhmcnommx9suf3dfawdkfc58xct3s
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756879516-944593
X-HE-Meta: U2FsdGVkX18FozgLhg10aBT3TXiEt4LbkedgNfegnZ7TVbJghhZt+1iJ5cgJ3U5aEhAk5qzsPKjt4uJY+UJXx9zk805jP+niHozqYAK4Vg1+Q1EdCSLtPHitWeGME7xRkoyfciwNIlfEdl7FfIpcYRs56BxzTG03XieXrzDKFz5jCr4Kdd4HTjq9oLYJA4z/QWauya+yOuC+IHt3kH96d+1ND0VRgpGLbNz1yCbGyxmCY0Mc5ePBNcJjhjOKM1k5MXq/tbNWtKu1YHcwhkw8Lo8zcqSB/AratU9TEhQKNmJe5T/rsaiMdkufoascRU8I3j+V8Dh5hfSiS/r/4cQ7cp/jGpiAKEgJK5mujGeTn5+/vjSvyp/uX/dpXtzh/pY/UMpVnPFw53wsDgYc1CpsnY9hkVLwkqpu/Uet02oDRm8nMd73K6Oyh/iryN2NbaIq8lf/wtt90hmzx6FTeKcQDoziJYds7c+1bM+KX8pl9b8esg+fN1IlznucsTp13xEN8FDYARkAxwgFt4pNNjhyWuOW1qieIUbjGzAmQpd/xs2l/f54hN9DaHPtnnOujAVotINSLo/eobhYWsARUPilrCxlTSrfIOybSllqCYfIoO7vSU5hmo1xKOZoBt2ZsMGRXjVfMqXAk3UymFHptiINe5w9XDSg6OSCFJCYgDIuunl58b8Rc9PUJ2YXvZCOd+IOfTbZ3BtxH+n3kfkjAcWSaFO/+qWY8F2b0WXavfcZbbC5FdDfRndwIJVLU+pRWQ9nTPCQDth380ExXW7daNULyD1ZOBpce1e4qmDIEOyBNkMec929iHO9iVedxGLrpa4ubJ9CbZq0bHZg4unqtRn5aELelgRomiNN6nItCuYhJmJT65/VfQOgDsUrcCQgq99uoYgI6eSoCL1AaA2wiXYBi0VNA6l/DIdwYlt7YXGNZj3Kdr6MQUXzCcoXcajoqKeK18LabcZ1VOPh57FGWwf
 aF20WMZJ
 y1Oe8aSBDMvEPHibOnGGjFm9uFu53Ko34J8ZAuw1Rgn2uA/t1QLpoWmgGY9sj0Ux5POvA7oy/kFTe6xRXtTRfikB8jw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/3/25 14:40, Mika Penttilä wrote:
> Hi,
> 
> On 9/3/25 04:18, Balbir Singh wrote:
> 
>> Extend migrate_vma_collect_pmd() to handle partially mapped large
>> folios that require splitting before migration can proceed.
>>
>> During PTE walk in the collection phase, if a large folio is only
>> partially mapped in the migration range, it must be split to ensure
>> the folio is correctly migrated.
>>

<snip>

>> +
>> +				/*
>> +				 * The reason for finding pmd present with a
>> +				 * large folio for the pte is partial unmaps.
>> +				 * Split the folio now for the migration to be
>> +				 * handled correctly
>> +				 */
> 
> There are other reasons like vma splits for various reasons.
> 

Yes, David had pointed that out as well, I meant to cleanup the comment change
"The" to "One", I missed addressing it in the refactor, but easy to do

Thanks,
Balbir Singh

