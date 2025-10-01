Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B529ECCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 06:59:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CB098E0012; Wed,  1 Oct 2025 02:59:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A1E98E0002; Wed,  1 Oct 2025 02:59:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 042558E0012; Wed,  1 Oct 2025 02:59:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E0F3E8E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 02:59:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 81F1913B823
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 06:59:49 +0000 (UTC)
X-FDA: 83948645298.09.4C882F7
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010055.outbound.protection.outlook.com [52.101.61.55])
	by imf26.hostedemail.com (Postfix) with ESMTP id C0279140007
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 06:59:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CAty0vu2;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.61.55 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759301986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FWo606w0uN6afUD4g0ujAef37GuTFqI1pMoRgjoRWEo=;
	b=Lw/DTM1wMgWKwIdmSHM+rI6K4HvnrRuNsEGrZoILwgnuVTI6LdVpFi746S/0RAOvfsgKor
	X/ILsdvPLeVLQ8OwG6UKj9xscC/2ATepNvPVuMrQeP2a6U9ZEjy8CPTEn7KMpj+DNelbGB
	oNF/ksRGTLuQ0YAeuSoT+851xZNqyRk=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CAty0vu2;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.61.55 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759301986; a=rsa-sha256;
	cv=pass;
	b=fq/mkmb8Dp+69RxidVBbPabVJ8kNKoCHtPo/+lMXn5/t0toTXLYCAyMdNO0hfEVzsrxg8h
	U7GtzFFxQ1w5C8/0KosnzA0nXBBZma3wx3HkjAO2t4CHLEMwlihjTJqWS6Yok5f4WcmEgF
	u7tlVY/7Oz/R8Zrr9wrRQ3kW4Gb+7Fw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bHomHcGu50aofqJld2I3z3pvsicqHT4eRxXkAFPZOt0s8gbgGWXbe7CDjS11O6kmWr333VxfEdL3WxGF88KhAcPSDw6IBms5pFlkoamEhHPnu79pCvDQ2WZKH2LXcGJDx6oBlMK8yPlUDpILAYwOUgwoBdD2fCB8OEgc1vw+U03gRUgxbTic0IWM4+ftHr1bHzmW5FNldQfXRcYx0v2M72WMmbHJCxfjrskNHL3gFWYicdQ86bMbBa385NNDzacEdhdbIO3K1ZRpFK26DAi5x3zijd/z7mqqX4SNv5zKeSS8v7y+25PXqy9l8AFQfGfuuquiiuBnh5OfsqjSUVwjQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FWo606w0uN6afUD4g0ujAef37GuTFqI1pMoRgjoRWEo=;
 b=QJfpeX2h9B72fi7/fq3dHc6iBxKwVDjIuO9WqNjbwrzNpstsscaIUvQ1nFYA56Wuc4OpXTFAgmVs/9r6FGzeJx3EgKcJ39HHIBjfRMtrQUH/ZeZARJqZfXCzm5Fwqzc8oOqcxL1SSVZPmBeBuf2La9hq9UIocZQ4HacdhpgabTfpfmwMhlwUVuSPLMETFET26wlAbeGMYGDHpmjp43JstHlAKx7vlw06R4YJXdBA9w2bEnnCeh+OOyCsJiCioNDAanlFnTkTQ+r5bdPurU/r8P7kYJsOfscq51dKMW+xm1a+ML+2vStOQ6a4neIsXCV8VDsQJ1+yF9wh0iDXf94XhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FWo606w0uN6afUD4g0ujAef37GuTFqI1pMoRgjoRWEo=;
 b=CAty0vu278syAIDmetbSmElkm1fCkuzvO6+GJ1kWJk3rFuLG0E3I9EeVUAoJJZw94Azjzin8meEHLlKc3rc4BStiIYdyJYiMVXvx92V/DOHmaBlI+NM08FvobhfUmFWNr7cy7yiQpfz+FBub/2DVXwbOrntd3Xa3HSIZMuQS6RkbdqQgMfbGqSkobo3DnAN0+ARy+gMgboxVwKlJk2FKJFT4x/slboeWYtcbmi/OoL/RKqZAZhPSOrqsBQCQIMb7uKEhY6ziPmUO71jVGIS76AP7XKMyUw3FtMjf9NNqdPNtni43O3QjVJYKRiwih7LloFUoUTZuVhEicnJ3u8K/iQ==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by BL1PR12MB5779.namprd12.prod.outlook.com (2603:10b6:208:392::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Wed, 1 Oct
 2025 06:58:03 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9160.015; Wed, 1 Oct 2025
 06:58:03 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	Balbir Singh <balbirs@nvidia.com>,
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
	Francois Dugast <francois.dugast@intel.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [v7 01/16] mm/zone_device: support large zone device private folios
Date: Wed,  1 Oct 2025 16:56:52 +1000
Message-ID: <20251001065707.920170-2-balbirs@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251001065707.920170-1-balbirs@nvidia.com>
References: <20251001065707.920170-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DS7PR03CA0095.namprd03.prod.outlook.com
 (2603:10b6:5:3b7::10) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|BL1PR12MB5779:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c37edf8-6ab3-4d8e-e653-08de00b7ddc9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|10070799003|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WEUrQUh6dTdnOTNXMWNTQTViUFdRRGZiTVhGSDlyWVAvNEY5QzQ0cTlPdkIr?=
 =?utf-8?B?NEhPVVBOZ09SUnVVZS9MeTcwMEI5K3JBMlVVUlZoRFVjUkQxYnNvOXFPdW5H?=
 =?utf-8?B?Qmx0dE9nUXBOSTUzdnlTQ3JJUHZieXAzcnpJWThZZDByZFV1VXlFS0JOdnRC?=
 =?utf-8?B?RmtpYXNrQzlsRkMvSXZkKzNmZzNSUm14T3BxQ1RxT2JtaHNMTzJmb092d2I4?=
 =?utf-8?B?cmhEeVRkUVdMSzVORjBWRGxYM2p0VWRETEtwR1NwYjlFTnp3a21OUGNPcHFZ?=
 =?utf-8?B?eHhCSW1yQUhNRit6cVB0ZUlQaEh0ZnMrNzBYNm9YdllsdWhoZGlzb1BFS3Rj?=
 =?utf-8?B?ZmNURUU3VjlFUTY4dEdEY3pORWQ2cU93MXNHWkpTcEFLT1FkbmlURHdnUjFw?=
 =?utf-8?B?MWl0UEFkTGlHV1orSFhFdW5yQjNUUkpzNHJJeS9aNHp6QUhPYlRpL01YQ3Nq?=
 =?utf-8?B?RTF6YU1LblppancwNURCMUp3cjRCRFExMVJsa3pTQ0J3Nm5CakUwODQ5UzhL?=
 =?utf-8?B?bm9Ka2dWU21NdEJFK04rN05tbFNZMmt2ckhPR3JlYkllYVBXOTFqUjBaRm8z?=
 =?utf-8?B?T2gxL1IyN0tLbkMvMWpPSjdBTk54RWU2aDZjUnVaL1kwTWlad1RXR21saGRC?=
 =?utf-8?B?Y0hraHNFTE95K2x0UzlKZ2RmU29jT055SDB2c212OTd6YlBoNXUzc05vN0NM?=
 =?utf-8?B?Y3dScnlNTWlYWGJ6Sk1DWit6YXZ5Q09mZ1lvOGxMVXVBUDc5dlAvb1dmejNt?=
 =?utf-8?B?MzZEdkVyVmRDOW9kZHNqbkxYeFgyQkdtcWFYb3JoaHRkZFgxZ00wRnExUkNt?=
 =?utf-8?B?ZGswd3RwRHRvUi9qYWNqdmhoc3lzMUY4aXBGdGVsUVB3TkZITGdFOGg3WDVh?=
 =?utf-8?B?Wm5CMGRnOFUrUzNqY2VPQVp3bFdmMmZDQmxGKzBDUGtWcFdFc2RUWndqQ2lG?=
 =?utf-8?B?RTlDZWRNelltN0hGaEpjTjQ3SjlSdTRwYWtrMU50eHBQak1jYnZ2TmZzaDFK?=
 =?utf-8?B?aHdSMkxuM1grVGlSOTZoM3BRdzdFMEtCLzRlZjZvNU5oaGsvRzNRby9oSlFH?=
 =?utf-8?B?UkZzU2ZHa3g2bi9TajB6WkpkcFE4eEFoWUZoMDJHL1l3cmZWRFhZa2ZrWjh1?=
 =?utf-8?B?UUN2ZUpmMGFpQW5CbWRjTWs1UWdsa3pMVkxtWjlOZEx0Q2ZjWjlzR2wvMXhD?=
 =?utf-8?B?MmZCMTZ0UEpHQ0JtZ1VSN054SFNyOE1XMEU4OGdDYndVbkEwRFZ4T2c5YjNz?=
 =?utf-8?B?UXQyZmxDNXBMVHpKMHRjWFFVOTRocStFNlRaRVk0M08rYm13MEM5dlRFY0Ju?=
 =?utf-8?B?c0xlOFpYNWdZWHUwTjVqM3JTcmk0V1l6WENNY25sckhxaDVKQUxJV2ZMQ2FN?=
 =?utf-8?B?eWZrTGRPa0hJUG5DbW1ZY012VUpBeDZMZi9sVytNVFh1VFErV2RsRmtiOTlz?=
 =?utf-8?B?N0xKMGFuYUxaeklDbDB6LzN6bWFrR3BuNm1FL3NWekN5S1JLWmgwb3lOajQv?=
 =?utf-8?B?algrcmhIRXdLMFlRNDZMSDZRd21jVTdvQVNOZVk2WXdrS2k0R0lkZXg3dHVr?=
 =?utf-8?B?SXkrREZZMkVyZ1N0elYzV0szRFhyNUxZMnRlRXp2QXVIQ1hhYlVQaXBEU2l2?=
 =?utf-8?B?MElKZEF2QVNCOEkrMnV2V0hnSytpWmErUEZmeTQ2U0FvY3pneG1tUHNTemVI?=
 =?utf-8?B?bW51d2FQK0hKOE1DNkJVWlJXNEk1Y1cyTUozYnFJa3VSY0VyOXJOZmhsdHB1?=
 =?utf-8?B?em9mWGQvaWdjN1ExRHRJdjlHQ2tLbTZEamZTVUVTYUJ4a2c2eTJnKzZCU1Zt?=
 =?utf-8?B?WUxqUmhqazQvU3dGdkxNQit3N1FWcE16OEM3M1FrMnUzR2RGT0dtbWd4V0VW?=
 =?utf-8?B?VUl1bGpzR1lqQjFSVzlqb0l6bTZyWTk5RHhVa3pOTzgvZzlxSTJoZmxEV3Fx?=
 =?utf-8?Q?wKpVqy5jUtbu8rVdR+xK9C4nHJbl5c26?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(10070799003)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RmFaN2tVRTZHY0ZramIrRFlKY21BMnRBNlpXNUxsaEdLZzFTaEx5UlpBNVN1?=
 =?utf-8?B?R2dybnZWaGpYdmtDK01hWEpUMHB3WDduKzBPK2VOQ2lDU1ArYzJTWkVpUFRw?=
 =?utf-8?B?di9aUU9PMkxsbmZQaEZZTko4OThMcnFOaTJZNXQ4aFVmU1FWSWNiK0VCMlho?=
 =?utf-8?B?dlZlbTlyb1dIS0RUUTgxN2p3UjBiVmw3bVNRUXVrbEhyblgrYTBvWHFxZVZW?=
 =?utf-8?B?Ui9tWm9aeCt6bXM3MFJWTSt1aDk3ZWcrbXd4LzRrYWJmNDlXY3B4TVdNZ0pK?=
 =?utf-8?B?dUJsOGhaUEQ1MGl4NGoyQkNvdEpZN3pKTi8ybEQrZUE4akU3VkVsK3AwQ2ZN?=
 =?utf-8?B?YXFmSGNhLzVCNzJ0Z21FUE1BQ01nazVGS3loaDIxTkF6OGRZWDF2Tmc4ZndQ?=
 =?utf-8?B?VWpOTGdjQ3hlbVFnQVJ2RndHTW8ranlOeC81OTBSNEZJc29EOThSbU5wZEdY?=
 =?utf-8?B?aysyUjM1a0xDd3RpUXRreUZyeXBaZTdYb0lPSDdJdGs3bUcrUm5qazlueWtM?=
 =?utf-8?B?UTBnTjNwR2hueWJGYlkrSWh5RUlhZk9PZ1BOeGdGMDgxRFpsMXo4Q09jUkNW?=
 =?utf-8?B?MFM3TCtuU2FBb2grS1BYOXd0bXRVVUh1R0lGWnloblRMSmViaEJPN0kxMkpQ?=
 =?utf-8?B?MzdmN3JEaDRlWERWMXdlR0FQdmVGWmNLMWVEUkRaaHFLU2RMblV1clRaZmg5?=
 =?utf-8?B?eVFFNTRIQ0NFVmkyUDlySTY1azhuZFdTSEVmWWVaa1pYd2hmQlhjRHdSY2xM?=
 =?utf-8?B?Nk5ub01nOWlNRWNIdmNEeko2UFgyR2dmQjl4VzlLdVVHQUVvNVZwa1JQQW1G?=
 =?utf-8?B?SDg2WU02VndFVy8wK2JYOGxrQ2x1Slp0dmVxOWllNHZBUWNmalF4eGdHSWxH?=
 =?utf-8?B?UTJ3OVN1endYTnA0MnJOSVlQdVhKNkZiU3o0VFNERUJ2cEJWNXBxTHNsSFI0?=
 =?utf-8?B?bUUydzdrRld5K2grUmdQSDFpL3hGREFoUzF6VHhHSWhzdzJYMitnMVlSK0Zi?=
 =?utf-8?B?d29WMmE3QmVLQjhFR2djNjVWUUFMdjZEK2FGOEN1cUpZcmJKV3B1NzJ5MXl1?=
 =?utf-8?B?THFIL3YrQUhnUzhvR1pVam1iZjNFRjJWVWN3RHY5SVdla2pJdXVxbk1oY2dH?=
 =?utf-8?B?SXRESGtVTjZoTE1rcmFRbXdnSnFvWXlBVFdaT2xCODc1bVZ6bkUxUjBkekV0?=
 =?utf-8?B?bjAyd252UHFLN0pwUHpXZ3h6M2Jmd3g0byt0Ly9SelVWWjdjZmZPTk9yRVMx?=
 =?utf-8?B?NC9oYmR6R1dGcTdGejNCSjRJdWlQcmEySjNZc0VXUUwwelBiZmNDOUFhdm9L?=
 =?utf-8?B?akZCOGYvWnZoUUpLQ3g4ZHdON29MOStzK2NNN0c3SkNpaUtYckxLTTdhNllK?=
 =?utf-8?B?dVFUSVFGM1NGTVB3UDFtT1R3bkd1ZEpYQTB3ZjQwbExScHNERGlvYmF5NHEx?=
 =?utf-8?B?ZkJhcjI2WXMzOWordi9vbGovbUpmL25VN2JJZWRZWEJQZGdFVlNLRGkzUExW?=
 =?utf-8?B?UDBRTytuQ25oZ3lYc0NSdy8rL2hFVms2cTlzRnhiOGx0QUFpaXN6OHd5M2FN?=
 =?utf-8?B?U2JYU0hmK1ZEQ2ZMSEtnUXU1bGZsNE9tZ2ROR3Mzakx2TXNETjRhZFVNdWEz?=
 =?utf-8?B?c1RLZ1F0cEY2S1c3Y3ZDbjlsdmhHMi82cldwdSs0L0QyUEFjK3hJR0Z6SkJz?=
 =?utf-8?B?dWFsdjZUT0RpODgybjdGdUJBMDd0MUxIcVAvbGRQOU5YTEpTOE9nUXdPNXJ4?=
 =?utf-8?B?YUpocFZWb2ZmS25rTlVWZFI5bjVIYUlvUVhsQyt1WXVNdm85bUxTQmcyekdJ?=
 =?utf-8?B?OElaSTVrN1l3Mm1CNEVuYVY3ZnFkdjBHNTY1SGI0UDFHWkpWZkt1RzVxWW1p?=
 =?utf-8?B?L2N0UEp3QTNuMU5NMkE4cnRHbTVHNGZTbStLVW5XRVI0THNOZEtCMS9WTGZH?=
 =?utf-8?B?ZHFFQVgvajB3ZDU2TDdqY2Z6UFVGWGFlK3pJb1hsdFVaSDZvOGVzUnhRMUR5?=
 =?utf-8?B?R0RvclB0V3QrandFNkxyWEVqbXIvbG01UVpGTzRlM2ZkQnlOTlF1LzF1akZH?=
 =?utf-8?B?M0ZWUkQ1YUsrM0FWMkdidmhJK2l6WHJqL2hJNGlRM2YzK0IwdWRJTkRSQmtv?=
 =?utf-8?B?bXF0M2Y3bUNGNDhkNGt2YktRY1VVS0txRGFyaDFjeU5LTmZMa2ovS2grbjg1?=
 =?utf-8?B?RUE9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c37edf8-6ab3-4d8e-e653-08de00b7ddc9
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2025 06:58:03.6552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8FX+YqkyK1iVapQjML2pgrbv3O2RjLNFXOl9rX+9rxTFHqRcS5sNQit8D7VB+lNlOldQfWlCCvsF/i9A4fAlqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5779
X-Rspamd-Queue-Id: C0279140007
X-Rspamd-Server: rspam05
X-Stat-Signature: ssrq884b95y46d6ydxm4kbkig93wmd41
X-Rspam-User: 
X-HE-Tag: 1759301986-32793
X-HE-Meta: U2FsdGVkX1/8npOwK+ulZZlI+79BuXFoPK6FmbzGZq3TUO0S4e1vTytB4Vtrm5u9wau9XquurjkhWQYy2MCrcrl6dhsNYkyTHXgoVj368h03Y8l6aNKnczq0pddX8Nj3VF24b+4Vhsn2N3H8hYuu1BAOcummTefVoplo0o+BIO5Hh89FujjH1DWH+J9T0w9h5tKzOJziVfyNk5yfftX0pxz98fFU/vmvf8rSCFn5ZQWSB7ZZylHXRPE0I9SVlu9S2Yr/CS8LxTfPVip4ipOgJMqmDp+lBJXKWEFRjcRqoHMEcWefe7P/uQZnXvY4VDA3y5L5ISct4GMMORdFe8a69Aj8JhHU8NaIR37hAp+oKUSZ9YImbcSC86xuGRcnnER06FV5h+7S0FbZ+y0cohHdb7iqI8sCk2UDLC8Bx7yJnhmCMKZhwVHk4pUelRb2mHP4qSsA/RtNtuzGDR+DTTOc9PVGkEu+QhOD79SLYIOc6NihF6oRxGcxLg5s9pGYlxbsz50Ma3XoZjhJxslleXFbwRaLux4YkJg/dqlHj40Xe/tAf++JPmRZONkN4cvJkqg8GUjazx6BpwvPrTPEZkHZzYRLAL66A6fUNzPQMhJ+B/ezwNEnDzOs5TsucfE5niil/kdg8pASzlvVMdlRU3fYxJRgfRNk/VYN81d5sm1iBCSHvt1VQLCs3eQy94lo97pUKO2DsALa5DCedZ3TmLwv5QO69N0xUVCW9kjHsmCfItEmcl/KUPmD9BhCfDE0qCj7F/0K3bUZWt3/ANvV2Zi77351Jiw+gm24bAisaWhk5A2HB9N1yQD++tbEL3A8p5KKbKqStQshHotm/g7qQkNlgYDYeTW+kR4Cc7g8gtVrUjrmOloXtWCSFQP3V4ODllkuiPgtlu97t4CcxakkKuWswU6lUMuYYS9CNSwgEO6gMvj8dnR0UAmzeYJ+RG/sKMh0iGpMq9ln9j3n94P1i7Z
 VA+VaHUE
 WEbwdl5nRrbih4/ET3/LqhFpn7XPH0cmmi0WLBVEo8NAfqLnaOM8xtR+mkcDxWDs8mpd6wTqHkl5I+oGVXP+sDJTr6os1S8+ba1BiLw9t5Grs8qzJ3hUg7xhEe1dWET4qSX+CI/SRd47YimW5iZf1ZWNxT2bglEFAyFQkFUGHOFJE23vXycSWsbc9L2klxdv/GSA4REQUAiwxd9ZyWKo3xDznqtXDFaTJgT47jR2rSzGUaKQacI0TTkTlkhH7gP51ZVo+xNQabVFFm+J+pZJJrzjvxDTxpleMDBUpLpq9W4rvsimOvlWkcvQjGKW20ss0FHej9CsTjHTlHAzG78xa83SPhYQLuTL01ps8vLbwuXNxcj22T2mKaZyRQIZtWIX5TE073HV9NboldYpjly91Gm5ukp8r/yCwOxSUkMfJXXWOFdeGOgll2xZDm+4oLvnhlK1FJnWURUFcGewSfvxKI1PsPYBA7Rer+aCEbIPsKAN67/QKux1EYsQ3OhptU14doPj68eDuPWQq77g63VfS5OrnTDDVKQWB7TlW9zdKZQbiLtOmOuYxp2iCGd9xnfV+j0glVforqO+4YuXPoUfUZO/keiVDm915jp81IFDXxAasLfZ+GeXRijcAsHltO//pk9nCUMdLFUGaD7amsJ6Fjcli2kx1iz0rxx+e+Pzc9+GZq7OeH6cMnGg3eK+L+EcPF8HEijlE3YXnAbdzQXjaUQfGi+HY0i/+8kL9Tev3isNXyR4hnzCy9w3OC3optC/hTN6IIBRZKQjVWfQaTV+iRYIfePpp9A/0seR6NI1uIHXNX0HUZfVNbtFrGstiI8KLuV7akvincgnrccZ5n2J/WIWKGcE7LNPd2Kwy0G4r3rw0L8ge4HW2OPkExDqGUDLyL/dC9F3kzuBZxWxIobVHSJwiz4pauBWnrlQKAwNdjhNKHzYuA8wvBhNB1lAEcrkJVCYPKDjNf2kuzn+MBer32Rfd8I89
 nFNartED
 Nteo7m3GZIwz55wvoWeTDVMH1LL0u/hnoQDVRc/vGEkhQ6i5Uq+qLlAja3c0n7eg936WwJ3CCzBBKfdaYEJVD5cvbApQgF5SINQyPnDWo+alcaoBTdf3ftDF2o5raHtGvpDV/p/XDFIvCNVEtAMHfBcJyCWmJUxqM6NxVLmHfxY1cxeEK0cVi/GkZMWsa0jiio+7Rqdd2y8LkgHTZqrzBJGDNHNHZ+YrWkUktFsUS7m4sOmvKxuk80zbpFFpCxxTOdl96Aj/53I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add routines to support allocation of large order zone device folios
and helper functions for zone device folios, to check if a folio is
device private and helpers for setting zone device data.

When large folios are used, the existing page_free() callback in
pgmap is called when the folio is freed, this is true for both
PAGE_SIZE and higher order pages.

Zone device private large folios do not support deferred split and
scan like normal THP folios.

Signed-off-by: Balbir Singh <balbirs@nvidia.com>
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
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 arch/powerpc/kvm/book3s_hv_uvmem.c       |  2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |  2 +-
 drivers/gpu/drm/drm_pagemap.c            |  2 +-
 drivers/gpu/drm/nouveau/nouveau_dmem.c   |  2 +-
 include/linux/memremap.h                 | 10 ++++++++-
 lib/test_hmm.c                           |  2 +-
 mm/memremap.c                            | 26 ++++++++++++++----------
 mm/rmap.c                                |  6 +++++-
 8 files changed, 34 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 03f8c34fa0a2..91f763410673 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -723,7 +723,7 @@ static struct page *kvmppc_uvmem_get_page(unsigned long gpa, struct kvm *kvm)
 
 	dpage = pfn_to_page(uvmem_pfn);
 	dpage->zone_device_data = pvt;
-	zone_device_page_init(dpage);
+	zone_device_page_init(dpage, 0);
 	return dpage;
 out_clear:
 	spin_lock(&kvmppc_uvmem_bitmap_lock);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
index 79251f22b702..d0e2cae33035 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -217,7 +217,7 @@ svm_migrate_get_vram_page(struct svm_range *prange, unsigned long pfn)
 	page = pfn_to_page(pfn);
 	svm_range_bo_ref(prange->svm_bo);
 	page->zone_device_data = prange->svm_bo;
-	zone_device_page_init(page);
+	zone_device_page_init(page, 0);
 }
 
 static void
diff --git a/drivers/gpu/drm/drm_pagemap.c b/drivers/gpu/drm/drm_pagemap.c
index 1da55322af12..31c53f724e25 100644
--- a/drivers/gpu/drm/drm_pagemap.c
+++ b/drivers/gpu/drm/drm_pagemap.c
@@ -196,7 +196,7 @@ static void drm_pagemap_get_devmem_page(struct page *page,
 					struct drm_pagemap_zdd *zdd)
 {
 	page->zone_device_data = drm_pagemap_zdd_get(zdd);
-	zone_device_page_init(page);
+	zone_device_page_init(page, 0);
 }
 
 /**
diff --git a/drivers/gpu/drm/nouveau/nouveau_dmem.c b/drivers/gpu/drm/nouveau/nouveau_dmem.c
index ca4932a150e3..53cc1926b9da 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -318,7 +318,7 @@ nouveau_dmem_page_alloc_locked(struct nouveau_drm *drm)
 			return NULL;
 	}
 
-	zone_device_page_init(page);
+	zone_device_page_init(page, 0);
 	return page;
 }
 
diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index e5951ba12a28..d2487a19cba2 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -206,7 +206,7 @@ static inline bool is_fsdax_page(const struct page *page)
 }
 
 #ifdef CONFIG_ZONE_DEVICE
-void zone_device_page_init(struct page *page);
+void zone_device_page_init(struct page *page, unsigned int order);
 void *memremap_pages(struct dev_pagemap *pgmap, int nid);
 void memunmap_pages(struct dev_pagemap *pgmap);
 void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
@@ -215,6 +215,14 @@ struct dev_pagemap *get_dev_pagemap(unsigned long pfn);
 bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn);
 
 unsigned long memremap_compat_align(void);
+
+static inline void zone_device_folio_init(struct folio *folio, unsigned int order)
+{
+	zone_device_page_init(&folio->page, order);
+	if (order)
+		folio_set_large_rmappable(folio);
+}
+
 #else
 static inline void *devm_memremap_pages(struct device *dev,
 		struct dev_pagemap *pgmap)
diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 83e3d8208a54..24d82121cde8 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -627,7 +627,7 @@ static struct page *dmirror_devmem_alloc_page(struct dmirror_device *mdevice)
 			goto error;
 	}
 
-	zone_device_page_init(dpage);
+	zone_device_page_init(dpage, 0);
 	dpage->zone_device_data = rpage;
 	return dpage;
 
diff --git a/mm/memremap.c b/mm/memremap.c
index 46cb1b0b6f72..e45dfb568710 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -416,20 +416,19 @@ EXPORT_SYMBOL_GPL(get_dev_pagemap);
 void free_zone_device_folio(struct folio *folio)
 {
 	struct dev_pagemap *pgmap = folio->pgmap;
+	unsigned long nr = folio_nr_pages(folio);
+	int i;
 
 	if (WARN_ON_ONCE(!pgmap))
 		return;
 
 	mem_cgroup_uncharge(folio);
 
-	/*
-	 * Note: we don't expect anonymous compound pages yet. Once supported
-	 * and we could PTE-map them similar to THP, we'd have to clear
-	 * PG_anon_exclusive on all tail pages.
-	 */
 	if (folio_test_anon(folio)) {
-		VM_BUG_ON_FOLIO(folio_test_large(folio), folio);
-		__ClearPageAnonExclusive(folio_page(folio, 0));
+		for (i = 0; i < nr; i++)
+			__ClearPageAnonExclusive(folio_page(folio, i));
+	} else {
+		VM_WARN_ON_ONCE(folio_test_large(folio));
 	}
 
 	/*
@@ -456,8 +455,8 @@ void free_zone_device_folio(struct folio *folio)
 	case MEMORY_DEVICE_COHERENT:
 		if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->page_free))
 			break;
-		pgmap->ops->page_free(folio_page(folio, 0));
-		put_dev_pagemap(pgmap);
+		pgmap->ops->page_free(&folio->page);
+		percpu_ref_put_many(&folio->pgmap->ref, nr);
 		break;
 
 	case MEMORY_DEVICE_GENERIC:
@@ -480,14 +479,19 @@ void free_zone_device_folio(struct folio *folio)
 	}
 }
 
-void zone_device_page_init(struct page *page)
+void zone_device_page_init(struct page *page, unsigned int order)
 {
+	VM_WARN_ON_ONCE(order > MAX_ORDER_NR_PAGES);
+
 	/*
 	 * Drivers shouldn't be allocating pages after calling
 	 * memunmap_pages().
 	 */
-	WARN_ON_ONCE(!percpu_ref_tryget_live(&page_pgmap(page)->ref));
+	WARN_ON_ONCE(!percpu_ref_tryget_many(&page_pgmap(page)->ref, 1 << order));
 	set_page_count(page, 1);
 	lock_page(page);
+
+	if (order)
+		prep_compound_page(page, order);
 }
 EXPORT_SYMBOL_GPL(zone_device_page_init);
diff --git a/mm/rmap.c b/mm/rmap.c
index ac4f783d6ec2..9bab13429975 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1757,9 +1757,13 @@ static __always_inline void __folio_remove_rmap(struct folio *folio,
 	 * the folio is unmapped and at least one page is still mapped.
 	 *
 	 * Check partially_mapped first to ensure it is a large folio.
+	 *
+	 * Device private folios do not support deferred splitting and
+	 * shrinker based scanning of the folios to free.
 	 */
 	if (partially_mapped && folio_test_anon(folio) &&
-	    !folio_test_partially_mapped(folio))
+	    !folio_test_partially_mapped(folio) &&
+	    !folio_is_device_private(folio))
 		deferred_split_folio(folio, true);
 
 	__folio_mod_stat(folio, -nr, -nr_pmdmapped);
-- 
2.51.0


