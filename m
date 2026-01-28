Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF4F1D35672
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 05:09:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 129436B0088; Wed, 28 Jan 2026 00:09:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D40A6B0089; Wed, 28 Jan 2026 00:09:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEDA16B008A; Wed, 28 Jan 2026 00:09:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DB0336B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 00:09:30 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A2255D3743
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 05:09:30 +0000 (UTC)
X-FDA: 84380194500.25.BC9A62B
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012018.outbound.protection.outlook.com [40.107.200.18])
	by imf16.hostedemail.com (Postfix) with ESMTP id C4520180002
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 05:09:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=bU6hrTmH;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of Felix.Kuehling@amd.com designates 40.107.200.18 as permitted sender) smtp.mailfrom=Felix.Kuehling@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769576967; a=rsa-sha256;
	cv=pass;
	b=PH9dLq6cc2As+6jOQwnJFn35Dvt5KDtMwr7YlRabdQxmDOfQOyxQKDHL0ZZ4mUsparaXPJ
	bl6NXTj0Odv+MZm4+UQzl6xRPkvkS+gAldIoZbTobIUVQvgaRipIF6B32t9lqDWWrxOs1x
	igFk93oqdN3YUQjibHxJrwtKyYKkRr8=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=bU6hrTmH;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of Felix.Kuehling@amd.com designates 40.107.200.18 as permitted sender) smtp.mailfrom=Felix.Kuehling@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769576967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OA7IFCsglmmczObmfcYhr+aM5USQ0fU1uWHF3aMmT6E=;
	b=VzV91RQ0zevRzIVPQqjsDtiNxUH8cuZRl92cMODocr25tF/VXfx4Wnpum5WT6fhopjMgvd
	5W5W9zvTPCq2q2qM51fSDu9Y8sjIDST8V0+HG5bpm2AZ2f7EWdXzUULY88McL0/Ja6gRWp
	aJw5j7fVjF+fBkRoW19zzjLpSda6oBY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z2u0HZP9J1NulrWjK762zFGj0RI1X7DtOR7xjplYfbjJ+w/5kAtgAyzIrUIpahavh7x5D17Q9Le1ZxhQpJsT92eU9yjVmG8Kw7TjA66Gl0FhQD/SJfxIGDtfwr51wOg4lpJjTFIzZdpxW2HwWcXuF4zhJuJyAMAxrUS5phSVVWTdxI4YCdr1s4PZi6+ixdBfdoRLXiy9GE23sT56i+t/3gNJoxe16rr3panpO78Y0Nb//M8S5xzvlS6mQrRt9ESqcpHBnmWxP9a3mcmwJwIT8TuNMYsGTUgAX8A81HLPD+wREmbzVTtjV3BPSM1uX4JbnyQW6JIpC6jJylTc1kKkGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OA7IFCsglmmczObmfcYhr+aM5USQ0fU1uWHF3aMmT6E=;
 b=H65FKivKwNTJK9oJgLx2aVMPlz5uylI6TSTSPSWhxH7YEG5QeWCZlVKOL+718sW8bWapkX3J3jcoD2VYxmiSwN90Cl8WYXj4Fv4gjj0DK/gOMv+gLnTBCeBnGoilQoaEZnhnA+2MoSqZ8GJ3SBECqrcG/DOElAmtFtfM1HFa6H20QdaR9XMCrCOU25u/H7bYRrRnR27ldbBrEPf6v/WsDXxvw9YZBp8K/oTug88yqDqmdTAiJ/x97XeqHooSAKqSl3IHxQ6Egm+mpMrHOWalsiqUJ/mFHgWgckxzVZEibKknZZrkJkdH/AvMlVOyACwv+v+U4ZunB0vlbPKl6KwBsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OA7IFCsglmmczObmfcYhr+aM5USQ0fU1uWHF3aMmT6E=;
 b=bU6hrTmHxJhloGRikEEzBVs3m0mSkf8jqM6ZPWrcG1g4697cRq0XaUSQRveQ4gGh6ywWqcF27+SxFQyL5ED+hNsv4MGOWuCeP5w6utYRLtwwpbnILjYrt85dFQI6TCfuBlAtTnjFZcO1k35Zgnw4kTrooOTbJAX+pj2q1IlcPtA=
Received: from BN9PR12MB5115.namprd12.prod.outlook.com (2603:10b6:408:118::14)
 by MN2PR12MB4255.namprd12.prod.outlook.com (2603:10b6:208:198::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 05:09:25 +0000
Received: from BN9PR12MB5115.namprd12.prod.outlook.com
 ([fe80::230d:c588:d858:9977]) by BN9PR12MB5115.namprd12.prod.outlook.com
 ([fe80::230d:c588:d858:9977%6]) with mapi id 15.20.9542.010; Wed, 28 Jan 2026
 05:09:25 +0000
Message-ID: <c8cac97b-a3b1-422d-bb40-4e828175dbfe@amd.com>
Date: Wed, 28 Jan 2026 00:09:20 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/13] mm/migrate_device: Add migrate PFN flag to track
 device private pages
To: Jordan Niethe <jniethe@nvidia.com>, linux-mm@kvack.org
Cc: balbirs@nvidia.com, matthew.brost@intel.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 david@redhat.com, ziy@nvidia.com, apopple@nvidia.com,
 lorenzo.stoakes@oracle.com, lyude@redhat.com, dakr@kernel.org,
 airlied@gmail.com, simona@ffwll.ch, rcampbell@nvidia.com,
 mpenttil@redhat.com, jgg@nvidia.com, willy@infradead.org,
 linuxppc-dev@lists.ozlabs.org, intel-xe@lists.freedesktop.org, jgg@ziepe.ca,
 jhubbard@nvidia.com
References: <20260123062309.23090-1-jniethe@nvidia.com>
 <20260123062309.23090-5-jniethe@nvidia.com>
Content-Language: en-US
From: "Kuehling, Felix" <felix.kuehling@amd.com>
In-Reply-To: <20260123062309.23090-5-jniethe@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQBPR0101CA0267.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:68::27) To BN9PR12MB5115.namprd12.prod.outlook.com
 (2603:10b6:408:118::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5115:EE_|MN2PR12MB4255:EE_
X-MS-Office365-Filtering-Correlation-Id: ea675690-59f7-41b4-50f4-08de5e2b67b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L1ViL3NHM0JvRlcxK2JQdXA0K3drMXFXQnJIcHQreFZPNzQ1N0g4MU01Y3dm?=
 =?utf-8?B?MHl4UkFUUUpxOWdtQmRWekFROFpodk85QlQwTlNDYXVzcGlvS3EwQUZydG5U?=
 =?utf-8?B?bDhaZnlzR3NCa2J6M0Nld0taLzNKWlFnVDJPMFJNZjkvSjJNb3FNLzVwWG9y?=
 =?utf-8?B?QzZXanFXWVB4enZ1MUtYc0dIUzltY0hoYm52b2JNK0VRZE5HUzBVSW5ZSzNW?=
 =?utf-8?B?NnpyZys5cmY2RWI5VisvT1hYdWtqdTZtMzVrTUhQWjd3bTAxbTIydVlQVkFM?=
 =?utf-8?B?QmVrcjVmcmNJeURGaUcyYThMcDFsK3NXa3hKOHlxUk9xTDlQdnRLQmZXdXAr?=
 =?utf-8?B?MWhpTTZ3N1JNNWFHakhPOGozYUx5bnVnTzFvUXYwOC9WQnRiaXlQcWV2aHpG?=
 =?utf-8?B?b3hQamlBYTE2OVlUTWJkNXpQMExzSHRhTkZqTVZmajlMaVd5UkMzdDRNOFlZ?=
 =?utf-8?B?R0tTWm9SSTQ4YTJNVXJBd3plai9jUGNzZlBvcmR1UHJpS2drb3o5eitTbW1T?=
 =?utf-8?B?TmQyMkExT2s4SGNwdFI2bUxvbnh1eFJpb1greTJLekJjelBMRlQ5dzBqeTVu?=
 =?utf-8?B?RHlNaHhqbnlldElTZlR4cDZYM2Z1Ti91cWFTdENWeUJHdC9LQ0Y5WmJTdnU0?=
 =?utf-8?B?QWJJMlU2VkpLWlhuWVFzcjJqQUlCOCtPeGx3ajRVNHA1Um1GdFcxZ1VxVGhD?=
 =?utf-8?B?WnE0MEpYM2E3UFJ6NlRaWVdDRWxkNVBsOXRJK1pHN0tZd05nMXNhZEFkODVG?=
 =?utf-8?B?MDkxbTJvVzAzWUh3VGdDbXNYYlYrQWtTMGprNytXVTlTdUlqWUgydERjVVQr?=
 =?utf-8?B?MHNqMDNjSzlUKzhXNGt1K0s2NzAvRVhsWmhMQkFHSkFOalpMdlZhNmQ5YWti?=
 =?utf-8?B?ajI1ZDcyUHpuaWRQRXVsam43b0xzemtKZUFLZ2hlUTlmN1RINSt2bXlMOHRr?=
 =?utf-8?B?OURUVHB0SW8yTXNvQTkrUk8wQldMWk9vaVEzbjlhUi9qNFYvVytqWnkzV00x?=
 =?utf-8?B?ZzRnZVgzcU96NFF5V1NXb2xLM25hYmg2Sm80aVdySUYzOUlhVEJIZXZ6TGgy?=
 =?utf-8?B?Q0lvTWFMNzY5ODZsbGVxNEdaSDE2K0xuTzlBU3B5ZVhWM3NsYXJ3TUg5K01w?=
 =?utf-8?B?aUZXZGNwTDdkMm1zMkdIdDFSdUNnUnlNMTZBYXE5WTJWMkRoWlAzNllIOXQz?=
 =?utf-8?B?RWVobkp3SFo5L0ZzWm9NdmZuTDVMaVVEQjQ4NFVLVkhCVkpNdFVYRTVOZFpI?=
 =?utf-8?B?U0kwQ1ZhTUtaWEE2U3RVVW1OVWQ3cXMrQ1lmcEw0VEFiQkc5cGFNYkxDZUda?=
 =?utf-8?B?ZDFQZkdETHlHUU9FNkxveTZ5Y3VHSFU1V2VDOXNKejE4YjJDalBYaE9XNVNl?=
 =?utf-8?B?dWJOeEtRb3JKNWNLaTl1ai9IclBKZVR4YmtFUVNqWDdJQVE3VGVmTnNsNExs?=
 =?utf-8?B?RkdFYWE4b1p0VXZQYm9MZkEranRvYmFXUnBWalNlYi9FdjhrRzJ3SDVkRUhR?=
 =?utf-8?B?NHVDSFdGZW1aWENhR24vSW5rMWw1VG45R3JIOHdrUGhGNDROQU1DbUU2ZEl0?=
 =?utf-8?B?QThBR1NOaGF0Mm10Sks2R2RXQmx1TkplWGNOVHBTSTlOdDVFKzgrbzFTTlBm?=
 =?utf-8?B?WWF0eHQ1REFmNnZvSHlBS2grc21wT01RR28rS2pleHl1YW1sN05XQmdoZGJp?=
 =?utf-8?B?V3ZNeU1Gcmk3UklkSGJqZFpPUGVncjFjZkU4ZHp5R1d0MU1TNWFqZFptd05s?=
 =?utf-8?B?RjNWOUYwVXZBazIvV2dralNzcXRZemFHbnpBRXVwY0lFUUFJTndIVTdIdkJL?=
 =?utf-8?B?aStYMm1rNmpVa0pEbEdnbjlKYlhudEpSSy9iMHJSSnp5c05XT3VoMDk4eXdH?=
 =?utf-8?B?Y3Zoekc1QXJUUGRwdHZYMXNpejdISlVKbUkyWHRQNDc0MDZ1Z3JEZ2JCeXNi?=
 =?utf-8?B?dWIzQlNwLzJaY0FYN3BPQk9VeTIwRU1JNTl0OGZuRzZ1RTNCeXgrOVNSSzFQ?=
 =?utf-8?B?TUdyTmdZM1NYUkdQYkxjR1FJMXhSazNGQUxIL2ExSDVVeER0K3RYSjA3QjVK?=
 =?utf-8?B?L0xJQkM3Slc1TmpjK2hQMU55MXY1MWFxelVDUVNuR0tWaHI1SU9hdzRvSHRJ?=
 =?utf-8?Q?Xgdw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5115.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VEJhMGtrVTFNWVlkSld3YjZIeng3Y1JEWDhPalZlLzBqenBxYm1EZGVEb2Fl?=
 =?utf-8?B?K2ljeW9PWnNobWFabE4zMmpJdDIwOEtqWXdDcjB5L2U5K0xlM2NWbFE0NVM1?=
 =?utf-8?B?Slc5c2ZKWVZ3M3FtYXJLZW9sT1dtWmJWUVNJT0Z3eDc5RlN2bnJlM21YbU5R?=
 =?utf-8?B?TmFvWVhUSEQvUlNEalMyaGdrbVcrWlpoR04wSlNhVHBEa0hlbFZYSVExZmJP?=
 =?utf-8?B?Y29EeE9ycTBkSmo1R2F1Z1A3Q2s2MksvelRFSUdMNlltckVrS1Y2SkNmWm1o?=
 =?utf-8?B?NmhLd1RTUnpOTjhPeTBQT1lGUmJPbzJma3YyTVhOR05hNnVzYmdCbmh6c1gr?=
 =?utf-8?B?cjJZWnVXVUxiOVIwNFJDMmFlaDczeDFOUkJ3M04yQmdzanh3RTRmaEVhNFJy?=
 =?utf-8?B?TnZ6VjNQN1lKeExCRHdYWDRLWnJwdUhkcUxDWVl0Zmd4SVlPN2lUM0IwYjYy?=
 =?utf-8?B?OGcrZHFyemYrNWxGLytZYit1TXJxOEhuRnFtdjBJdXA5RHhKKy9KOVpVaGEy?=
 =?utf-8?B?bGcyd1dVMVlXZ2FWVCs0ZFNTOHp6anhqWWc1eW5ybGVnRkN2WEJncnZTcWRS?=
 =?utf-8?B?M29PVG9ZSUY4b0d5T3JpdVdYakVycXBqZGFBa2NiSGR6cmRmNVBBMkRGUXlm?=
 =?utf-8?B?MzA3bkVmMkxnbXZMZHE0NGFyZ2lCYU0wUUsxVDROUTlITjQxaXZmWmZHYW4z?=
 =?utf-8?B?VG16RDdLZ1dkdy9rOVFTa3hzZlNDY1NFWG12RXB1MmlXZ2pHaEg2b3dmKzI0?=
 =?utf-8?B?RE9ZYUFsR3F5UkxkdUZNMkhzM0RUbDdMQVI0VzlmR2FXRTlxemI4d1Z2TGU1?=
 =?utf-8?B?VlE4UmZBdW1Cc1NZTXVhL3FHN3o4ZG1LSklMQVgxZ2xtSjVwckVXTUsyMitn?=
 =?utf-8?B?NTBqTE0zSHFJMVdFZmh0MVhtVEpJb3ZpRytsc3NWVDFYWVJML0ZUM29uUGR5?=
 =?utf-8?B?QWJqRG9Lb1BqeTNKYVVoT21ZekdBb01iL0p4WXR2VU9PTTkvdjA5MTEyYmRG?=
 =?utf-8?B?T2o0K0wxc1VPcjlPV1lUZTVDcm5zNkkzL2hvZjlkYXdaT2wvMzNwc0pZZXdE?=
 =?utf-8?B?bjA1czZvam45V3RLdW5FQmxFbCtVWk5BeVdPU3I2UmV4V2Q5bmhNbkJzV3Vl?=
 =?utf-8?B?MGhsVkZIZHowOElwQ3Y3Q1N4dW5ndEZGYXpPakdLSTdtWTB5Y2M1ZlRNZjJK?=
 =?utf-8?B?WXIybFduTExzNkZqMlFPK2VPWHdGOUhQR2FkU3dFNGNRaUUva2NWc3RKS08w?=
 =?utf-8?B?Ry9aL1dabnREdnE2RlBaSy9EWFp6dE1rUHVweWdocEJMZTVWQkZTSGo2THhs?=
 =?utf-8?B?UkJBWDEvV2hxZFMrdFNXM3UzS3o1Vk92WnQxNHlDN0tMUVhma3BObHljUVZW?=
 =?utf-8?B?blVmeFNjWG92UlpBSHhmOURwYlRTK2sydXBXRmFqeUM5RVJ2N0hoUFFIUFdl?=
 =?utf-8?B?TXovUWpVVFAxZlAwSkI3Zk5KSDkrcXo1MUFJOFRKS3Nqb241NmZoTGRLbHpo?=
 =?utf-8?B?YmJmSG4xUnlJQ2I2emRaSDN3Y0phT0F5cE9YUnJyNGlhZzRkaW9GU2diWlRq?=
 =?utf-8?B?RkxVQ25nb01Fek5vWCswSFZtdzJCdDVycTNFUzRnbXd1enNrTkxGV3JxbWt6?=
 =?utf-8?B?Wk1RUlc4N0xHMkhaL0t3cS9CaXljdG1XQzlSNnpQVm9GSFZWQm1kQzZEdmhK?=
 =?utf-8?B?OG8xUkF3amNUNGVuZ3JBaUJ3Mzh5SkMwZExlVlR4b3BxZ09SZUx1NXNWejhF?=
 =?utf-8?B?OTdXc3hkUGFmTDJIK21xVzB6RVFGcXN6R1FOMlpha2lkTC9oL3lXYVU4QXY0?=
 =?utf-8?B?RlZlMzdBbStPL2QrUUExMlAzVmRzMmZNZjkxSFdpdVNOcEpHdm15UjlTTENz?=
 =?utf-8?B?NTd2OGNQM2ZTTWpTby9OQkI2VysrS3BzSVRuRjN1dGc0K3JvUWhlQVF0aVVk?=
 =?utf-8?B?b0NHLzFxODRpS2o3a2VBdW1XYkJNQ0VLZDgvZm5RYjI4U1ZEZW53UGd0SjE5?=
 =?utf-8?B?YjZLaGlQaStKdSt0K3RJUm5zNTU4Z2Q1dHd2Vm9sdGN1T3pYTmNKM1pNTmhE?=
 =?utf-8?B?L2V4c3pHWjFGNEhRLzdjdlp6eFQrZ0NqTTltMHZGcGh0UU56NU1jOTN4SFA2?=
 =?utf-8?B?d0NDaGgzWWxUdGxQRlZlM09nVENndlpqSTMySlcrV1MzMlZzeklEazZ4My9x?=
 =?utf-8?B?UnEzOU9YVXZFVFM5Y2dVZUtrTGp6azRja1pyWGVuVDdGU3c4algrbkcwcHR1?=
 =?utf-8?B?UHZSMUlUK2lrMHZScHFwY1ZYMElVdjNrUWc5QmlwVjNHb0t5eEFna2hzaTVG?=
 =?utf-8?B?QU1COHdGVEVuQlRxQ3lRUWpSYkZkdHpoTTl6RVdheE1PMUJSMGxGUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea675690-59f7-41b4-50f4-08de5e2b67b9
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5115.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 05:09:25.0750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fLZ9a+AAXp/CjDOzNqgpcNNDwPmjDDcyuRlHqcdbKKOH61SSqTZRL9FxI5xpfhJvQ1hlIH1CK1vMAZx8m303+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4255
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C4520180002
X-Stat-Signature: ah6pu8tbyir1fcm1qyda5kr4kqi53gmf
X-HE-Tag: 1769576967-333131
X-HE-Meta: U2FsdGVkX19Hml4NdajiquyRNqUZVTW9/7/qw8V5Iy3tUynXvCnLmIb+JZPDvVq15QMhijqFOXevSrPiLLGIdSTZOss78PvLnu0V0oE6hjf9fyIF35eFydOhd2D168P9aCjXRnvYinyelPxBocPGlHqfN+eDGemUrumYJ9bFFYPrJ1N/LaEM/8aG75a48rRY7lTApGdchlqFvyIn4jX7A1YfXfKIDsAyWB9CTdtZ+UVxsVZGBxbuTbXI9uo3mWZBC0j5Mm3mYXS3kxcsaF6BRH0jQWkuOpVHRrEWvqMYdQaojx7OtlBpzzcnkP98e60hDsgdw39P/0S77XD16pX7ADzY9F6snwGrQd9c/YoU0yqJ/meo7SopTm7TZIq+VMo/+qR9wMwvWd6pNVzp1p3oKJQhJ1CYLA8+gyTGuw2xB56dbpqLfN8PtcyqH/sMr8ADeqUZF8bT+zR8tl7infKC3pRBpHnatJETlG58B6ZnSm15U3EBeuUzDFlVre7pR7GaUg1/3MkgNS1dFWt4MjDxuTObVIXw9IGN9Hb0VMBnagnyD4LM7yb3gLaCRBE6TlMZVmiEh78x43N6bks7GsE9iIgQZIQLBcMhtoJNCezTOoCVbCIq7ScpjVVvlNC14qV7yXra+5KcIN0TS2ZpQMK/q3We5ZuLTwiPO4lCPvsQ+p9SItAhfAI+6GUACgMvexN7fqFR0V3d81/IOZy3q/BNm+xmWPiQCZLbVn0TZt6Ievhhd/dlrpKOHSU5tE/LJOJ6hKk1tLSeTaCd+xo1nIBz8oBfCpukayZIQwKicZq74CsChFIWP5j6dE2HLS6wzUmEjYDeeM/Clw7rpON/i4cQSHhsu/JO7jgVawxplc+eNgghDC30ps9nEHVh0RUioHkje5UFvkn42+PLnDzLlFwpDxMLM88bjApf6R2cdbtsLdm18c3XIszmZZ2iM2eDvFGdWj5UwWzb+uaGN+tXv+H
 g3zvMrPl
 l/zqPTEf2c1eGIRz5j1vN1mau1F1U9obOLdW7YsefrdwCB8mqutzFQeAoMl/N9WnfFvUi0X/IJ6h6oIqUTZBTQypWB4d/bOAABEhaEL2HZ5ykoZ+7S3QLT1egnOoQ9uuXgt/gN1w7TLMVF0+yeT+XdnDZKXMnI3uzfUBmxkMtdkbiD1hgZXHGBAaZVvZ9tBpf5Bzf87N9ShHzFfVkQH9wuxjCqTNHJtuB9lehKSn8CEE07XwecIprD6tCpEWVbpFaYvhlIK/2J5goCQTtDe5H6DK3RSJcrZnpT5WL88ssBBtSTmAcDn6Byg//7MZ0SZHuZGkGRHyQ5Azwrm9WAcToe51QEn5oAP9GQuDkQvm33pmJEeyPuYeejVShJBY6Jg2PgPIkU38isXQkCcp7ht6K/2TxhsghyfnrZVE/dFLR/SaYfTqEREBGM2gvZ3MvJrKLvqKn3URfwC0C8SEtJKZspMfy10sC9HFiYi/L6zB7gz0pN7qssjmcFINtig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-23 01:23, Jordan Niethe wrote:
> A future change will remove device private pages from the physical
> address space. This will mean that device private pages no longer have
> normal PFN and must be handled separately.
>
> Prepare for this by adding a MIGRATE_PFN_DEVICE_PRIVATE flag to indicate
> that a migrate pfn contains a PFN for a device private page.
>
> Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
> Signed-off-by: Alistair Popple <apopple@nvidia.com>

Acked-by: Felix Kuehling <felix.kuehling@amd.com>


>
> ---
> v1:
> - Update for HMM huge page support
> - Update existing drivers to use MIGRATE_PFN_DEVICE
> v2:
> - Include changes to migrate_pfn_from_page()
> - Rename to MIGRATE_PFN_DEVICE_PRIVATE
> - drm/amd: Check adev->gmc.xgmi.connected_to_cpu
> - lib/test_hmm.c: Check chunk->pagemap.type == MEMORY_DEVICE_PRIVATE
>
> v3:
> - Use adev->kfd.pgmap.type == MEMORY_DEVICE_PRIVATE
> ---
>   drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |  7 ++++++-
>   drivers/gpu/drm/nouveau/nouveau_dmem.c   |  3 ++-
>   drivers/gpu/drm/xe/xe_svm.c              |  2 +-
>   include/linux/migrate.h                  | 14 +++++++++-----
>   lib/test_hmm.c                           |  6 +++++-
>   5 files changed, 23 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
> index 3dd7a35d19f7..5478e41877e5 100644
> --- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
> +++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
> @@ -212,7 +212,12 @@ svm_migrate_copy_done(struct amdgpu_device *adev, struct dma_fence *mfence)
>   unsigned long
>   svm_migrate_addr_to_mpfn(struct amdgpu_device *adev, unsigned long addr)
>   {
> -	return migrate_pfn((addr + adev->kfd.pgmap.range.start) >> PAGE_SHIFT);
> +	unsigned long flags = 0;
> +
> +	if (adev->kfd.pgmap.type == MEMORY_DEVICE_PRIVATE)
> +		flags |= MIGRATE_PFN_DEVICE_PRIVATE;
> +	return migrate_pfn((addr + adev->kfd.pgmap.range.start) >> PAGE_SHIFT) |
> +	       flags;
>   }
>   
>   static void
> diff --git a/drivers/gpu/drm/nouveau/nouveau_dmem.c b/drivers/gpu/drm/nouveau/nouveau_dmem.c
> index bd3f7102c3f9..adfa3df5cbc5 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
> @@ -484,7 +484,8 @@ nouveau_dmem_evict_chunk(struct nouveau_dmem_chunk *chunk)
>   	dma_info = kvcalloc(npages, sizeof(*dma_info), GFP_KERNEL | __GFP_NOFAIL);
>   
>   	migrate_device_range(src_pfns,
> -			     migrate_pfn(chunk->pagemap.range.start >> PAGE_SHIFT),
> +			     migrate_pfn(chunk->pagemap.range.start >> PAGE_SHIFT) |
> +			     MIGRATE_PFN_DEVICE_PRIVATE,
>   			     npages);
>   
>   	for (i = 0; i < npages; i++) {
> diff --git a/drivers/gpu/drm/xe/xe_svm.c b/drivers/gpu/drm/xe/xe_svm.c
> index fbf5fd284616..a8aad9e0b1fb 100644
> --- a/drivers/gpu/drm/xe/xe_svm.c
> +++ b/drivers/gpu/drm/xe/xe_svm.c
> @@ -770,7 +770,7 @@ static int xe_svm_populate_devmem_mpfn(struct drm_pagemap_devmem *devmem_allocat
>   		int i;
>   
>   		for (i = 0; i < drm_buddy_block_size(buddy, block) >> PAGE_SHIFT; ++i)
> -			pfn[j++] = migrate_pfn(block_pfn + i);
> +			pfn[j++] = migrate_pfn(block_pfn + i) | MIGRATE_PFN_DEVICE_PRIVATE;
>   	}
>   
>   	return 0;
> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
> index d269ec1400be..5fd2ee080bc0 100644
> --- a/include/linux/migrate.h
> +++ b/include/linux/migrate.h
> @@ -122,11 +122,12 @@ static inline int migrate_misplaced_folio(struct folio *folio, int node)
>    * have enough bits to store all physical address and flags. So far we have
>    * enough room for all our flags.
>    */
> -#define MIGRATE_PFN_VALID	(1UL << 0)
> -#define MIGRATE_PFN_MIGRATE	(1UL << 1)
> -#define MIGRATE_PFN_WRITE	(1UL << 3)
> -#define MIGRATE_PFN_COMPOUND	(1UL << 4)
> -#define MIGRATE_PFN_SHIFT	6
> +#define MIGRATE_PFN_VALID		(1UL << 0)
> +#define MIGRATE_PFN_MIGRATE		(1UL << 1)
> +#define MIGRATE_PFN_WRITE		(1UL << 3)
> +#define MIGRATE_PFN_COMPOUND		(1UL << 4)
> +#define MIGRATE_PFN_DEVICE_PRIVATE	(1UL << 5)
> +#define MIGRATE_PFN_SHIFT		6
>   
>   static inline struct page *migrate_pfn_to_page(unsigned long mpfn)
>   {
> @@ -142,6 +143,9 @@ static inline unsigned long migrate_pfn(unsigned long pfn)
>   
>   static inline unsigned long migrate_pfn_from_page(struct page *page)
>   {
> +	if (is_device_private_page(page))
> +		return migrate_pfn(page_to_pfn(page)) |
> +		       MIGRATE_PFN_DEVICE_PRIVATE;
>   	return migrate_pfn(page_to_pfn(page));
>   }
>   
> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
> index a6ff292596f3..872d3846af7b 100644
> --- a/lib/test_hmm.c
> +++ b/lib/test_hmm.c
> @@ -1385,11 +1385,15 @@ static void dmirror_device_evict_chunk(struct dmirror_chunk *chunk)
>   	unsigned long *src_pfns;
>   	unsigned long *dst_pfns;
>   	unsigned int order = 0;
> +	unsigned long flags = 0;
>   
>   	src_pfns = kvcalloc(npages, sizeof(*src_pfns), GFP_KERNEL | __GFP_NOFAIL);
>   	dst_pfns = kvcalloc(npages, sizeof(*dst_pfns), GFP_KERNEL | __GFP_NOFAIL);
>   
> -	migrate_device_range(src_pfns, migrate_pfn(start_pfn), npages);
> +	if (chunk->pagemap.type == MEMORY_DEVICE_PRIVATE)
> +		flags |= MIGRATE_PFN_DEVICE_PRIVATE;
> +
> +	migrate_device_range(src_pfns, migrate_pfn(start_pfn) | flags, npages);
>   	for (i = 0; i < npages; i++) {
>   		struct page *dpage, *spage;
>   

