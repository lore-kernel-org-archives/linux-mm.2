Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9BA5606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 08:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=k3oFSgVT
Received: by kanga.kvack.org (Postfix)
	id CA6A96B05B4; Sat, 28 Nov 2026 03:56:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C582E6B05B5; Sat, 28 Nov 2026 03:56:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1F266B05B6; Sat, 28 Nov 2026 03:56:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8694F6B05B4
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 03:56:36 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 099D080628
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 08:56:36 +0000 (UTC)
X-FDA: 85483921992.22.695DE12
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013059.outbound.protection.outlook.com [40.93.196.59])
	by imf17.hostedemail.com (Postfix) with ESMTP id BC76340005
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 08:56:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=k3oFSgVT;
	spf=pass (imf17.hostedemail.com: domain of shivankg@amd.com designates 40.93.196.59 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795856193;
	b=zfWcO6xNIAMNr/6bBu0jEcF/xpjtT0NnIeaIbPox+Ottc7UOCExJPislMrqyMjlAa1zBnL
	+2FDJkaUlVBCNt7IpXe+ZEidKxXv/6mJhoiA+HbXdriu2nv9KmoEO1Mo8DxuyEdZw6RKcF
	bPAXQDeJt3ZZ0+58vtYfQpfPEFyfIvc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795856193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HYrCW/3aRxQPXS1bEZyMmNgmWdWj+LIA5TxThrO1Wls=;
	b=qbEslIBgiynEdByLRabD7/Y8ddetxXB5zJDZ7Zfl9w+uAzWNsjoiZ3aaIAnk+qrzPFoFkC
	6m0jhrpkvT8ZxHq6AQxvqLrol/cFXssdorWwjbmKMj3vh7S0Mb6gZK9BZsOxjc5eO1v4kN
	XefBjznJd016JsOgsX10CJF679WY95g=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=k3oFSgVT;
	spf=pass (imf17.hostedemail.com: domain of shivankg@amd.com designates 40.93.196.59 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uuRLKn4GR20dtfKskgCze+8PjSoyCLAAWlCh0ZrFwufwjxWK5CitXpiCFb1nEFG1Ws1KhHX5n9Qko3dYem4cvQK7vH+iTVUcwJoTSXtlRN1wtoDhoK+wbSdW2VxgbbLjV1URUoAZGbChtUdRZV7ckoDpDVQ/qd408QOM/0QhGgHb5Wk0dS3KX2llpJb4YrEsCh8n5AryvMmXbZeRB6BprXvq380ecZpcnQcgV1PnwR9fKz0tqJii/7Ax5AL24ogn2l8WqjWzsoOxDehfkscETeOz12JDrMQ1FHBSQocbNxt4c+D+D6wvd1b1cCKTpYzlX6KH1c6/vWJrLPvfKnG3eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HYrCW/3aRxQPXS1bEZyMmNgmWdWj+LIA5TxThrO1Wls=;
 b=a1QeZZdQI/YUxB2h4QFmPfQY1zyLepp6KDzRDK/XmqArIL9yjwR97HAoklYvujfucj/DVIysmcuv6Vl9HyilqTy58P7lqsbOWXwPo38GAvEVg2dXrxk55Dh+uzBSSdc60QFuR1bVU2jtIKIBN/rc/3RArmQC9kUC4U8JgYPlxxZb0WPkrrf1aouZwx054zWzrPkAGw5k5wcY01GvWBj6a+stlF0nJCio0AFIFXQ7CvCA9E1N0NOWDk1YjCPTPZlWYmUiK7AEdYL7r49LDkcGoMmB3A7Fqz6Yy+2t4w2PkoXG3gz91YOO1WBkkvfQWWSV/Xx9FmRwmU9hhLF9Twx/zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HYrCW/3aRxQPXS1bEZyMmNgmWdWj+LIA5TxThrO1Wls=;
 b=k3oFSgVT7Hq33Qui+3yjLrHsHvCkflO9EuU46B9gkv1Uk48vquuSMh5ZyWWkvfmIytAX2oUePs95i1omg+w6Mq3CeHIIg/FbBc13hSXArp+ZZUQSCTQs2StszAb+ZpggUlPxelgB4JmhbJtsBaYhUW9YARcczEFZb+ekRn156AU=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by BN5PR12MB9463.namprd12.prod.outlook.com (2603:10b6:408:2a9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.11; Sat, 28 Nov
 2026 08:56:28 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%6]) with mapi id 15.21.0662.007; Sat, 28 Nov 2026
 08:56:28 +0000
From: "Garg, Shivank" <shivankg@amd.com>
To: "chenwandun1@gmail.com" <chenwandun1@gmail.com>, "ljs@kernel.org"
	<ljs@kernel.org>
CC: "rppt@kernel.org" <rppt@kernel.org>, "byungchul@sk.com"
	<byungchul@sk.com>, "vbabka@kernel.org" <vbabka@kernel.org>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"matthew.brost@intel.com" <matthew.brost@intel.com>, "david@kernel.org"
	<david@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"surenb@google.com" <surenb@google.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "gourry@gourry.net" <gourry@gourry.net>,
	"ziy@nvidia.com" <ziy@nvidia.com>, "liam@infradead.org" <liam@infradead.org>,
	"mhocko@suse.com" <mhocko@suse.com>, "joshua.hahnjy@gmail.com"
	<joshua.hahnjy@gmail.com>, "apopple@nvidia.com" <apopple@nvidia.com>
Subject: Re: [PATCH 2/3] mm/migrate: batch PTE restoration in
 remove_migration_pte()
Thread-Topic: [PATCH 2/3] mm/migrate: batch PTE restoration in
 remove_migration_pte()
Thread-Index: AQHdfXKa9s4qtW1l0kK2O914pu/kqbdDMcyA
Date: Sat, 28 Nov 2026 08:56:28 +0000
Message-ID: <7a04fb96e91236be7c97fe688d360a02dcab0fbd.camel@amd.com>
References: <20261120032949.2036731-1-chenwandun1@gmail.com>
	 <20261120032949.2036731-3-chenwandun1@gmail.com> <awBjoC-YFf6KPYT1@gremlin>
	 <fa05e353-0786-42de-96fd-8a9b1ee725ac@gmail.com>
	 <b50cd305-3528-445d-bfa6-e4d7ada43b13@gmail.com>
In-Reply-To: <b50cd305-3528-445d-bfa6-e4d7ada43b13@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5259:EE_|BN5PR12MB9463:EE_
x-ms-office365-filtering-correlation-id: b99e719f-743d-4d89-b72b-08df4d2d7d9d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|4143699003|18002099003|22082099003|10067099003|11063799006|56012099006|261102123227099003|261028144727099003|261022075727099003|261022105027099003|261026121527099003|261026140227099003|261021135927099003|261021121427099003|261021123027099003|261009223027099003|38070700021;
x-microsoft-antispam-message-info:
 kMos6kwMMWhzGI6vtuaj+w6fdiWFBIJOtHvACXnEovAxodvEUwHcooCKTdGBgs8MePZAps7/zFOMWq5/KY1DI9Y70sz/4Wf8ayon++kwnx5IB9q2K7K2ZfTR0q2CH/f19fc9AzWpMKunOQUHJGhgQVbLHCg1xzvanktBi86ESYNI/D6iWtc8z7K1N3D6idci6wdHRNmnSy9f7qTdguvFBRQQD8L3RDDFEAb7BrIbXVPkic2wnTdIiiBLRCC1sUTMxEfRRiTxPGDRpEj3Y5/5HlHzqO9RudgmKEAoZIjwONmnM6xsFjy6Z9X+e8s8I4jpA7z/06wbUdqYecesdJT0ipCeLoU35PgETlT4GOwjmL0xpNuKVbaQ4fW/dSAiGTjUKIJmL15oXAksOPAerLci0kYhcoiE50vroRXvuhXCHEpKkawmOgQe0KMzWtgJlbhPMFZyxJ20QIGXIfrua45VcELWX9digTM5R2OmYP2J1geUiI0TP1uns59LX7Kc1zg/Z0QDLBbZNTalHDRWHJ4jd4y9DIVH3/bWXWj4pvGaD653UOW5D4fECyWv9eyKUu1ZcRTFj5PNrECc82O01Dq+YwMZN3ptLP/ZKgsoZjnWLLiakkhDXIqePRoDlKgvgbaq9mRT2Vy6YvbXjbLM7/LwDMIA/AhrLoZST50gyXImBds=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(4143699003)(18002099003)(22082099003)(10067099003)(11063799006)(56012099006)(261102123227099003)(261028144727099003)(261022075727099003)(261022105027099003)(261026121527099003)(261026140227099003)(261021135927099003)(261021121427099003)(261021123027099003)(261009223027099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bHU4ZjJUU1d3TTN2UGl2alkyWjhMZS9lT3RoVnVaOThKUW9oeUZmWG14aWp3?=
 =?utf-8?B?ZE9kTkVXOEMrOVB0eHQ2bktMWkFoMG1GY0EvbmduaEJGM2RSNzVGbXN5SnF5?=
 =?utf-8?B?bEpUVmtJZHl2c0JXalRoUFUwRHNNQ2sxQVE5RTgvZ2xISkhrODhId1NBbWlH?=
 =?utf-8?B?RWY0UmpUSUdJdzZOTFdrTjl0dG9FWmMwenA1UmhodTkxYklTMG02U2FTdHIz?=
 =?utf-8?B?a0hMdUtqaU5qKzlOUERtQVhyVC92bFVQaTdRQjkvZldhTWMrbnJHSWUzdjlo?=
 =?utf-8?B?c1NUam4wSlJkc1piSWRrank1NkIzK0ZjZ2l0NXo3WWtlRGpQc3FuQzk2a2Vu?=
 =?utf-8?B?THVUMC94dlF3RlErdnR6akR4ZWhYRHBQT2dOc2p0SjFaK3A1QkhSNHJDSml2?=
 =?utf-8?B?dWhYWHEvOUVLeWVjd0dUaDF5Vmg2N3RrSHBKN1BGK1VhNk9odi9WamIrWXMw?=
 =?utf-8?B?bUE3cHNBQXBaOHF5aVBLSzdYdFRGZ01veEpaT3NOa2FwWkhWenBFMW5PeUNF?=
 =?utf-8?B?dERERE44dzJTNVNqeFA3UmFGZG93emdkYUN1Nll3bktmTGhjdzBudGhlclZN?=
 =?utf-8?B?bWRkeEIzVURCc285Q0g4N3dYVVJlK0NIZmQrWHFGd0ZlSGVhZVgybDVFZHNl?=
 =?utf-8?B?QWRCdnQzTGZ0bEF5RXpUV1A2dzEwdE1ZdlB2QThYMzlOdi9oTVBrNUdPYkhS?=
 =?utf-8?B?azFFaEV5VWNJbVQvLyt5eWhWVVpOWFdNcmtIckx0Tm1TbHgrTGp6YVFpdmFR?=
 =?utf-8?B?T1ZNM1p5T05LL01wUkUrMDdBc08wN21HVHBteUM0Qy9xc1hMbmFXWDIwbVYw?=
 =?utf-8?B?VEhRU3JEWmJ6U0RLSmFWUGZML01lb0UvOVAyU29wZ3RxRDlxUU5tMy94TDRa?=
 =?utf-8?B?MmhmQ3U0NUs1R0RGNGpOQzBIQUJIc25GNWRYaElDMU5WaXQ2L09YMDlqdXpw?=
 =?utf-8?B?QmxER2FTWkszTTA3bTd3QkpwaGd1dU50d00rVnBtUkU2WUlHZnhaS2YrL3Qy?=
 =?utf-8?B?Ni85OWRtRU5NYlFTbTlPbWlZR29tdEhqL3FTR3MxTlBXOFFOV0IxTE93N3Fp?=
 =?utf-8?B?MnRzRVBBWVBnYTRkYW5SOVp5ZzFKeHVTdkVLMUlBNlplcTZPQWxSaHdaazVJ?=
 =?utf-8?B?N3FMUnhKaDQyUG81NEl6SEFjWmEwWVFUdzNWTWxOc2lTcnlzTHZuM09GVi9V?=
 =?utf-8?B?ZE5ZdHV4blRhbHJGQ0Q1ZjlNdlpPK002cEZ3MWxaZ3U1by8yRldhNm85NGlu?=
 =?utf-8?B?cXBqQ1o5YUI0R2kxbTc0OWVrUEJpRGg5SlBPRzgwaElEUmdNQzlnQXE5bGZp?=
 =?utf-8?B?L0IzQTV6LzREWW0zaTNSUlRYRzNBK1EvbEZrR0Zxc3ltVmMyUkN0WlJqZUNm?=
 =?utf-8?B?RGU5dGQrTnk5QUNibG1iaVR6VWNDcFZTR0tLdnRNK1NUc1MvMWdlTkpwRTg1?=
 =?utf-8?B?Uk9lQm5iSllNQUo0aE5nMVdkZzAzY2hHRWg5RmM5QXFjUEtvZld2VUlyblg5?=
 =?utf-8?B?UUUvMm9ULzgxVjdYRkdQeStNN25BdVp5OXNHMGdpV3NLZUc2MnVjdE1FWjhV?=
 =?utf-8?B?QnZwSEQzQ3ljTVI2bmswRzdpT211V3dVOUFoYlFreW5ZeE1QZFJsc3NZYm1k?=
 =?utf-8?B?TUZvRzVoU2pRdXZ4OWlPOUVHVndIUUhsYXdvcXBHQlltRC9lR3RWZzhGWFho?=
 =?utf-8?B?anBpQjYra1RkTExSMXdMUzI1YktDRUNvanIrWUpjWlUyQzFFVlBuMVVaZ0hj?=
 =?utf-8?B?TktrK25oQzVFWjk5Y3BTYVhSUEF3V2cwTTNZcXNUd1FxWHkveE9vT1YwaG1m?=
 =?utf-8?B?UDhhZ3hGUzdoOGtpV2Ntek1yN0pXRDhqRHEvYVVpdG9MNEcyZzdEZU8xQ1U4?=
 =?utf-8?B?T1RuZ21FUlArSGdCUmlIRHVTSktwMmF3T2FUVENHN3pxRnQzeXQrNktCZGhl?=
 =?utf-8?B?TTljcXlNenp2L3ZkVmJyK0NhdTRuWm1rZkhnbVJmWUVSU2NENFMrYkJvcTdL?=
 =?utf-8?B?VzRkSlI5MnMwTnFnRGJneERsd0NPN1ZrazdzTkwxN3V1a3JBMVM5S3BPSnEz?=
 =?utf-8?B?S2JzRFNhUWR0V243MlBDYXVkeHA2czhOcDVxREl4NFY3NHJQSEdQUSt0VlE1?=
 =?utf-8?B?U3NQVEhTN3NMV1VRaGdkRjkvNVYvU2g5NVk5RmhtVGg2eXk2ZXV2OXRqOS9t?=
 =?utf-8?B?MTV4Tk5Jd2ZSYlJkWmxCa2hJQVp5VTc0d28zcUY1M1VsZk5sbUczdHVjUUdk?=
 =?utf-8?B?ZzJlaVkrTkZ1RDdrc0xNYklGcjJLZ0tRV0sydXZrV3d6bHR3Nkl2NE9zVnRs?=
 =?utf-8?B?QUhkZUVWY0pya1RZUk1JQ2hUa3h1MXB6S0ZnVEdnUW44cE9TOFZJdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A7459A2BAFB5E6478DB328B500121C96@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b99e719f-743d-4d89-b72b-08df4d2d7d9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2026 08:56:28.5680
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tU5P1e2kcOyl3LnIatRmkcvWozZ7UBvXxwQnk4nX4fjQG9viCUUKjuisphy9hBHHObX88Ijy1GikdWVxahzFmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR12MB9463
X-Rspam-User:
X-Rspamd-Queue-Id: BC76340005
X-Stat-Signature: czhbfcwcy3qzu6p619kj4s51uka9bw6c
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795856192-851849
X-HE-Meta: U2FsdGVkX1/xLxCZRnHMIqE5hWH9J1IeR27NFpiKxlOF+hIBFw2HKlNO7iHD6YB//oU7jsQcs/L70CWnTIzo1xuWarioLJ/u+W6fQuisy2dECJ6BqNkR5bMG+WtGZ9f8OHtGLESTbw6T7kjSYB1/Pf2Zayh5FxlfL4tB3nXk3YpMqWQNcwsNLpN4Zs1Eb/4cvrc9XUltWDBxFQfSwEIYl9jMUDaLCMMCH9k5rPF+wE1d9RYVHAFTJNDG3hmA3sHho9Z+qPWJkZq9n/80/qDsKokUFjFs3C4YfjAbbrgKu6wj/jlxy6h1DDWa3iGxwrxGApbTkAD/M8dHGMN/jGz+7EdkVAjXOIwYG7wSomUNQ+7bOL4HeMGKew6CkWXM7rWMRzphv1X52m9jxzCsnNAje2RU8TUiRTzivXHyD5qqK5ADeGa4MReTGdfEPvnNROsGzPKN0Z1ln2l8dhx0ObM2yvloAKyH/ydEDr7rFVD7y+3gi6L+6XBAfCXLHP8DF+WhQ2IZFB6yKuAIAN2DoKNIyzNiAlrtBMbngeccEvKdXIETuxsi1tt0Ve1YF1/4pPPcC8aCmTWQyyFCKty/J3U4kf94NwpgGZJnA7pf6jG0iW62JR3L08meoViCtLxpYmRT6MV7V0Lmaxx+YgOJH9pdDGhV1zGBKlXU6+SdPdEX4Pkz3VAc/MSWJT3RGRumj35aTDX85kIQIX87Rku4rZtl1J/38PVFHdjX6orDTV9AMM97VmmdqAVMMTYP23+03QeqO+yTP1J/nsM0GimxBalbFK+GWOeVL98d6zlokEjeKGnFBcpeWkBR4/hq/kWt20cA8yZc8YzKzRrTmuVFBxgM2ZVACWLVlTb3Ej9ZkCQlsb1FHZjWvSWs6QIqXVvUSDaDFYv1Iz68qT044w71s7w+EHNfnWgG3edN53w+E+zMU5+WeVSiD/ELFW0CZQ8nmLxf0qtJNSHjp915+R41KWN
 nSXcFyr+
 G6euj2KbNJgamH99ClaS2Bj+q137p+gsiuSaR01lABfMbTUwWlGV42tMCOSPDChkfUzFKeBhU66yoL6ej4Mmf1sFX47ySWtCv/sYIPasv7yzaty0P96X+z3j5YSeOaNAeeAq8sHyCWLey/QtSZd8dgi/TXGxgr65jZKurv3/M5YQLC22wYzl5QHqI5Ck870cwkKsIMatpbH1geS0cYDbl+0fESiUH2arrj06mauC+QbmO3J10KmZngL8OcN0N4gjvJnYAVQ81f+gr0xjCHSgFzt/ghKL0lXyUhHL1cGbUsXznkiMVelmOwlGVAHWFCRiuy2s5vgM1Qnn0ntc4aDmPAmuS2S793v0grQkWIuklemnXGQAhIdEXC1wg/mX2WAakmPtFwX2d3boitxNe9eROgebHWzYSvam1KHrn2CSRa6lygPImyYlWBqsEVgqxaEGmZgcHRY7xuofyvKznndxbwWnZUqkKq1Dv0kh1iw3V22Zpg4DaIKl+MHaiyCNcQ6JC7VONS9JbQDaP+AJgXOflcS6/SqnCXzikJ18H/6IbwkjQLxI8MbCYzl1CtX4WQ4fwnVj/4tTOCwTufS6VI8mMzA15+nyWrC1ySItR3T5jCaPzVJRehb8Vwichu6jMBZ7jO1J40lFGorH9M11v707Hr5sDcp5XTLWqfkh9Nsmpd3HoKJ2Qc6KB3a9qqV6D91u3I8vGY85WGUeOB6fKG+rx3sirT9Bl7i+TRKnHwXbs6ydvbdS+FTldNQyY97sGJUdm9pN3wQoGofenreGP8ALGPEB1FsTZ8jM7mt9tAlFftJqp/c9GW/LvlyETZK3YM+RfFJxHUHvS4uV9skgqNrRZ/dXS0eTVOlEiCppkNzxqz4zhpyDiCP4kj9UI9tQKCv8O1JBePK7Ak2k56SbTkeXiCMlZx4EsAtLFLAZtDoelPFUcVfCg3aTsUSStXZUSW8m2bP8koKKGfUrGUmRrGIldPCUO7L7d
 vuuCES87
 HQ9UBoIMfOwd3q+3pQts0IS7/9wqsSrFM0QvqrQ9vuk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

T24gVGh1LCAyMDI2LTExLTI2IGF0IDE0OjUxICswODAwLCBXYW5kdW4gd3JvdGU6DQo+IFtZb3Ug
ZG9uJ3Qgb2Z0ZW4gZ2V0IGVtYWlsIGZyb20gY2hlbndhbmR1bjFAZ21haWwuY29tLiBMZWFybiB3
aHkgdGhpcyBpcyBpbXBvcnRhbnQgYXQgaHR0cHM6Ly9ha2EubXMvTGVhcm5BYm91dFNlbmRlcklk
ZW50aWZpY2F0aW9uIF0NCj4gDQo+IE9uIDExLzIzLzI2IDE1OjI1LCBXYW5kdW4gd3JvdGU6DQo+
ID4gDQo+ID4gDQo+ID4gT24gMTEvMjAvMjYgMjM6MjIsIExvcmVuem8gU3RvYWtlcyAoQVJNKSB3
cm90ZToNCj4gPiA+IE9uIEZyaSwgTm92IDIwLCAyMDI2IGF0IDExOjI5OjQ4QU0gKzA4MDAsIFdh
bmR1biBDaGVuIHdyb3RlOg0KPiA+ID4gPiBGcm9tOiBXYW5kdW4gQ2hlbiA8Y2hlbndhbmR1bkBs
aXhpYW5nLmNvbT4NCj4gPiA+ID4gDQo+ID4gPiA+IHJlbW92ZV9taWdyYXRpb25fcHRlKCkgcmVz
dG9yZXMgUFRFLW1hcHBlZCBsYXJnZSBmb2xpb3Mgb25lIFBURSBhdCBhDQo+ID4gPiA+IHRpbWUs
IGNvbnN0cnVjdGluZyBlYWNoIG5ldyBQVEUgYW5kIHVwZGF0aW5nIHRoZSBmb2xpbyByZWZlcmVu
Y2VzIGFuZA0KPiA+ID4gPiBybWFwIHNlcGFyYXRlbHkuDQo+ID4gPiA+IA0KPiA+ID4gPiBBZGQg
bWlncmF0aW9uX3B0ZV9iYXRjaCgpIHRvIGZpbmQgYWRqYWNlbnQgbWlncmF0aW9uIGVudHJpZXMg
d2l0aA0KPiA+ID4gPiBjb25zZWN1dGl2ZSBQRk5zIGFuZCBtYXRjaGluZyB0eXBlIGFuZCBmbGFn
cy4NCj4gPiA+ID4gDQo+ID4gPiA+IFdoZW4gYSBiYXRjaCBjb3ZlcnMgdGhlIHdob2xlIGZvbGlv
LCB0aGUgcm1hcCBoZWxwZXJzIGFscmVhZHkgY2FsbA0KPiA+ID4gPiBtbG9ja192bWFfZm9saW8o
KS4gU2tpcCB0aGUgZXhwbGljaXQgY2FsbCB0byBhdm9pZCBkb3VibGUgbWxvY2sNCj4gPiA+ID4g
YWNjb3VudGluZy4NCj4gPiA+ID4gDQo+ID4gPiA+IERldmljZS1wcml2YXRlIFBURXMgZW5jb2Rl
IFBGTnMgYXMgc3dhcCBvZmZzZXRzLiBzZXRfcHRlcygpIGRvZXMgbm90DQo+ID4gPiA+IGhhbmRs
ZSB0aGlzIGVuY29kaW5nIHdoZW4gY29uc3RydWN0aW5nIHN1YnNlcXVlbnQgUFRFcywgc3VjaCBh
cyBvbg0KPiA+ID4gPiBhcm02NCB3aXRoIGEgMTZLQiBwYWdlIGdyYW51bGUsIGxlYXZpbmcgZGV2
aWNlLXByaXZhdGUgZGVzdGluYXRpb25zDQo+ID4gPiA+IHVuYmF0Y2hlZC4gVGhlIG5leHQgcGF0
Y2ggZW5hYmxlcyBiYXRjaGluZyBmb3IgdGhlc2UgZW50cmllcyBieQ0KPiA+ID4gPiBhZHZhbmNp
bmcgdGhlaXIgc29mdGxlYWYgb2Zmc2V0cy4NCj4gPiA+ID4gDQo+ID4gPiA+IFN1Z2dlc3RlZC1i
eTogRGF2aWQgSGlsZGVuYnJhbmQgKEFybSkgPGRhdmlkQGtlcm5lbC5vcmc+DQo+ID4gPiA+IExp
bms6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvNWY5YzQ0OWUtNDNiMy00NzMyLTljMTQt
ODE5OTQxOGNhY2UwQGtlcm5lbC5vcmcvDQo+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IFdhbmR1biBD
aGVuIDxjaGVud2FuZHVuQGxpeGlhbmcuY29tPg0KPiA+ID4gPiAtLS0NCj4gPiA+ID4gIG1tL2lu
dGVybmFsLmggfCAgNiArKysrKysNCj4gPiA+ID4gIG1tL21pZ3JhdGUuYyAgfCAzNSArKysrKysr
KysrKysrKysrKysrKysrKysrKysrKy0tLS0tLQ0KPiA+ID4gPiAgMiBmaWxlcyBjaGFuZ2VkLCAz
NSBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQ0KPiA+ID4gPiANCj4gPiA+ID4gZGlmZiAt
LWdpdCBhL21tL2ludGVybmFsLmggYi9tbS9pbnRlcm5hbC5oDQo+ID4gPiA+IGluZGV4IDlmNzhj
MTI4ODJjYi4uZTZlY2YzMDdkNTMyIDEwMDY0NA0KPiA+ID4gPiAtLS0gYS9tbS9pbnRlcm5hbC5o
DQo+ID4gPiA+ICsrKyBiL21tL2ludGVybmFsLmgNCj4gPiA+ID4gQEAgLTU1Miw2ICs1NTIsMTIg
QEAgc3RhdGljIGlubGluZSBpbnQgc3dhcF9wdGVfYmF0Y2gocHRlX3QgKnN0YXJ0X3B0ZXAsIGlu
dCBtYXhfbnIsIHB0ZV90IHB0ZSkNCj4gPiA+ID4gICAgIHJldHVybiBfX3NvZnRsZWFmX3B0ZV9i
YXRjaChzdGFydF9wdGVwLCBtYXhfbnIsIHB0ZSk7DQo+ID4gPiA+ICB9DQo+ID4gPiA+IA0KPiA+
ID4gPiArc3RhdGljIGlubGluZSBpbnQgbWlncmF0aW9uX3B0ZV9iYXRjaChwdGVfdCAqc3RhcnRf
cHRlcCwgaW50IG1heF9uciwgcHRlX3QgcHRlKQ0KPiA+ID4gPiArew0KPiA+ID4gPiArICAgVk1f
V0FSTl9PTighc29mdGxlYWZfaXNfbWlncmF0aW9uKHNvZnRsZWFmX2Zyb21fcHRlKHB0ZSkpKTsN
Cj4gPiA+ID4gKw0KPiA+ID4gPiArICAgcmV0dXJuIF9fc29mdGxlYWZfcHRlX2JhdGNoKHN0YXJ0
X3B0ZXAsIG1heF9uciwgcHRlKTsNCj4gPiA+ID4gK30NCj4gPiA+ID4gICNlbmRpZiAvKiBDT05G
SUdfTU1VICovDQo+ID4gPiA+IA0KPiA+ID4gPiAgdm9pZCBfX2FjY3RfcmVjbGFpbV93cml0ZWJh
Y2socGdfZGF0YV90ICpwZ2RhdCwgc3RydWN0IGZvbGlvICpmb2xpbywNCj4gPiA+ID4gZGlmZiAt
LWdpdCBhL21tL21pZ3JhdGUuYyBiL21tL21pZ3JhdGUuYw0KPiA+ID4gPiBpbmRleCAzYzM5ZDMw
OWU2YmQuLmUwMDBlZjc3ZWE4NyAxMDA2NDQNCj4gPiA+ID4gLS0tIGEvbW0vbWlncmF0ZS5jDQo+
ID4gPiA+ICsrKyBiL21tL21pZ3JhdGUuYw0KPiA+ID4gPiBAQCAtMzU4LDYgKzM1OCw3IEBAIHN0
YXRpYyBib29sIHJlbW92ZV9taWdyYXRpb25fcHRlKHN0cnVjdCBmb2xpbyAqZm9saW8sDQo+ID4g
PiA+ICAgICB3aGlsZSAocGFnZV92bWFfbWFwcGVkX3dhbGsoJnB2bXcpKSB7DQo+ID4gPiA+ICAg
ICAgICAgICAgIHJtYXBfdCBybWFwX2ZsYWdzID0gUk1BUF9OT05FOw0KPiA+ID4gPiAgICAgICAg
ICAgICB1bnNpZ25lZCBsb25nIGlkeCA9IDA7DQo+ID4gPiA+ICsgICAgICAgICAgIGludCBuciA9
IDE7DQo+ID4gPiA+ICAgICAgICAgICAgIHNvZnRsZWFmX3QgZW50cnk7DQo+ID4gPiA+ICAgICAg
ICAgICAgIHN0cnVjdCBwYWdlICpuZXc7DQo+ID4gPiA+ICAgICAgICAgICAgIHB0ZV90IG9sZF9w
dGU7DQo+ID4gPiA+IEBAIC00NDEsMTcgKzQ0MiwzNCBAQCBzdGF0aWMgYm9vbCByZW1vdmVfbWln
cmF0aW9uX3B0ZShzdHJ1Y3QgZm9saW8gKmZvbGlvLA0KPiA+ID4gPiAgICAgICAgICAgICB9IGVs
c2UNCj4gPiA+ID4gICNlbmRpZg0KPiA+ID4gPiAgICAgICAgICAgICB7DQo+ID4gPiA+ICsgICAg
ICAgICAgICAgICAgICAgaWYgKGZvbGlvX3Rlc3RfbGFyZ2Uocm1hcF93YWxrX2FyZy0+Zm9saW8p
ICYmDQo+ID4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICFpc19kZXZpY2VfcHJpdmF0ZV9w
YWdlKG5ldykpIHsNCj4gPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgIHVuc2lnbmVk
IGxvbmcgZW5kX2FkZHIgPSBwbWRfYWRkcl9lbmQocHZtdy5hZGRyZXNzLCB2bWEtPnZtX2VuZCk7
DQo+ID4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICB1bnNpZ25lZCBsb25nIG1heF9u
ciA9IChlbmRfYWRkciAtIHB2bXcuYWRkcmVzcykgPj4gUEFHRV9TSElGVDsNCj4gPiA+IA0KPiA+
ID4gY29uc3QgcGxlYXNlDQo+ID4gDQo+ID4gV2lsbCBkbyBpbiBuZXh0IHZlcnNpb24uDQo+ID4g
PiANCj4gPiA+ID4gKw0KPiA+ID4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgbWF4X25y
ID0gbWluX3QodW5zaWduZWQgbG9uZywgbWF4X25yLA0KPiA+ID4gPiArICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgUFRSU19QRVJfUFRFIC0gcHRlX2luZGV4KHB2bXcu
YWRkcmVzcykpOw0KPiA+ID4gPiArDQo+ID4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAg
ICBtYXhfbnIgPSBtaW5fdCh1bnNpZ25lZCBsb25nLCBtYXhfbnIsDQo+ID4gPiA+ICsgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBmb2xpb19ucl9wYWdlcyhybWFwX3dh
bGtfYXJnLT5mb2xpbykgLSBpZHgpOw0KPiA+ID4gPiArDQo+ID4gPiA+ICsgICAgICAgICAgICAg
ICAgICAgICAgICAgICBuciA9IG1pZ3JhdGlvbl9wdGVfYmF0Y2gocHZtdy5wdGUsIG1heF9uciwg
b2xkX3B0ZSk7DQo+ID4gPiA+ICsgICAgICAgICAgICAgICAgICAgfQ0KPiA+ID4gPiArICAgICAg
ICAgICAgICAgICAgIGlmIChuciA+IDEpDQo+ID4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAg
ICAgICBmb2xpb19yZWZfYWRkKGZvbGlvLCBuciAtIDEpOw0KPiA+ID4gPiArDQo+ID4gPiANCj4g
PiA+IFBsZWFzZSBsZXQncyBub3QgaW5zZXJ0IGEgYnVuY2ggbW9yZSBvcGVuLWNvZGVkIGJpdHMg
aW4gYW4gYWxyZWFkeSB3YXktdG9vLWJpZw0KPiA+ID4gZnVuY3Rpb24gOikNCj4gPiA+IA0KPiA+
ID4gSWYgeW91IG5lZWQgdG8gYWRkIGZ1bmN0aW9uYWxpdHkgdG8gYSBmdW5jdGlvbiBsaWtlIHRo
aXMsIHBsZWFzZSB0YWtlIHRoZSB0aW1lDQo+ID4gPiB0byBwYXkgZG93biB0ZWNobmljYWwgZGVi
dCBhbmQgcmVmYWN0b3IgaXQgZmlyc3QuDQo+ID4gDQo+ID4gU3VyZSwgSeKAmWxsIGRvIHNvbWUg
cmVmYWN0b3JpbmcgZmlyc3QgaW4gdGhlIG5leHQgdmVyc2lvbi4NCj4gDQo+IEkgbm90aWNlZCB0
aGF0IFNoaXZhbmvigJlzIG1pZ3JhdGlvbiBybWFwIGJhdGNoaW5nIHNlcmllcyBbMV0gY292ZXJz
IG11Y2ggb2YgdGhlDQo+IHdvcmsgSSB3YXMgcGxhbm5pbmcgaW4gcmVzcG9uc2UgdG8gcmV2aWV3
IGZlZWRiYWNrLiBUaGF0IGluY2x1ZGVzIHRoZSBwcmVwYXJhdG9yeQ0KPiByZWZhY3RvcmluZyBh
bmQgdGhlIHJlc3RvcmUtc2lkZSBQVEUgYmF0Y2hpbmcgZHVyaW5nIHRoZSBtbG9jayBkaXNjdXNz
aW9uLg0KPiANCj4gR2l2ZW4gdGhhdCBvdmVybGFwLCBJ4oCZbGwgcHV0IG15IHNlcmllcyBvbiBo
b2xkIGZvciBub3cgYW5kIHNlZSB3aGF0IGZvbGxvdy11cA0KPiB3b3JrIEkgY2FuIHRha2Ugb24g
b25jZSBTaGl2YW5r4oCZcyBzZXJpZXMgaXMgbWVyZ2VkLg0KPiANCj4gSeKAmWQgYWxzbyBiZSBo
YXBweSB0byB3b3JrIHdpdGggU2hpdmFuayBvbiByZXN0b3JlLXNpZGUgUFRFIGJhdGNoaW5nIGlm
IHRoYXQNCj4gd291bGQgYmUgaGVscGZ1bC4NCj4gDQo+IFsxXSBodHRwczovL2xvcmUua2VybmVs
Lm9yZy9saW51eC1tbS8yMDI2MDgxMy1taWdyYXRlLXJtYXAtYmF0Y2gtdjItMC0zYzU0MjRjNTU1
YzdAYW1kLmNvbS8NCj4gDQoNCg0KVGhhbmtzIFdhbmR1biA6KQ0KDQpJJ3ZlIHNwbGl0IHRoZSBz
ZXJpZXM6IHRoZSB1bm1hcCBzaWRlIGlzIHBvc3RlZCBhcyB2MyBbMV0sIGFuZCBJJ2xsIHBvc3QN
CnRoZSByZXN0b3JlIHNpZGUgKHJlbW92ZV9taWdyYXRpb25fcHRlcygpIGJhdGNoaW5nKSBhcyBh
IHNlcGFyYXRlIHNlcmllcy4NCkknbGwgQ2MgeW91LCByZXZpZXcgYW5kIHRlc3Rpbmcgd291bGQg
YmUgdmVyeSBoZWxwZnVsLg0KDQpSZXZpZXdzIG9mIFsxXSBhcmUgd2VsY29tZSB0b28uDQpbMV0g
aHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtbW0vMjAyNjExMjYtbWlncmF0ZS1ybWFwLWJh
dGNoLXYzLTAtNDExMjk5OGZiNDcyQGFtZC5jb20vDQoNClRoYW5rcywNClNoaXZhbmsNCg==

