Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81F94606A323
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 23:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=JMcH7k6g
Received: by kanga.kvack.org (Postfix)
	id 8F1A96B05B9; Fri, 13 Nov 2026 18:53:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C2936B05BA; Fri, 13 Nov 2026 18:53:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B24A6B05BB; Fri, 13 Nov 2026 18:53:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4E71C6B05B9
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:53:11 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CA9621202E8
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:53:10 +0000 (UTC)
X-FDA: 85431749340.26.109FCD1
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011007.outbound.protection.outlook.com [52.101.57.7])
	by imf30.hostedemail.com (Postfix) with ESMTP id D0D0580005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:53:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JMcH7k6g;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.7 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794613988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t2y/d/vQIA6R1WRjI8fXgDyPNluTyUMT37MV/zsJD4s=;
	b=292qIJE7s4lYuJhbDO0hlB39iwjeju92/kuAZ1/J+9pcW6u403rIkuTiCXDdkeiJ/mygIj
	IRqu02Y5tXPWk9JbGODyAMhKew46CBzM3ZqXWgvz4HdDKYAjC8NZ6JgejNXd3Obee/G6cS
	G6lpTiXey/1uzDPotFtuJjhNa7edSzA=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JMcH7k6g;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.7 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794613988;
	b=hNBrEV/J2EncJAxom2V2N1TZL9u003xmZ6wVvZGNLwheDqLPX+qKN48bpqxpW73FhIOkA4
	tG0r2Hrhn3p2oeZZJ550m64zLAX1LzxaDz/s8XtSkfjyWAm++E9KOZIzY4PvDOzLIDAL1r
	otTMdC6fytnZRWIKXz8xrWygOR7j66Y=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pGSt1ac2lX/8A6UqghUQlGzTgGwrDkiNliJEsPCpyRR+ODYxKQxefrwBxmy2NtQgpjs6HuWDtKrgfIcoY4FU8u3jUQuslGWkFnfdLcKzBc4TqkoKjC21qua0OYYSKGDXiT1njdyP/DIJir+mY2glJEcqatmwZO6UluyNDiPscZnTDPSVXaplnAwnr/TKtMhOGnZJFnjNj4gDY3RE1UZmu3q8AvpFMRl4CxFvRKDPEAtslhjCkkTz4oKnFLA0G9aMASpfsOQvpWVO9bDmtszVn9Wa1SN1gehhdddtthJzKWSXiCs4KD1gfHCt153cftXPkRPGOlPjZ1wBIP0tRSN2Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t2y/d/vQIA6R1WRjI8fXgDyPNluTyUMT37MV/zsJD4s=;
 b=MpAG4n4jXCjKdd/AM9sZM6iL0dmvRt+zlRK7GQfExHreyOk4aEtixdT3o8+cM+IdsRmJavMQaK6N0Apv0jKIH3c4p7F47tZigPwMJW9v5s1OqyQqeeUEMaMEjL7H++tXS0JOXeXGFqtx3yIY4Q2PkCgMiN7puVA/viDEmDkPGb1igRSBv6ROmbD+gvV94LB9SmEvEk4AxibGJqvFR5YsjX8+lCFMgDKfYgwVQuPftNObh/c4y68ph2rUs6u9x09uGrqhV8Fbxv+zNkEW5ivtkhmRsnisEbIDwppPkRjzq9Ems76vgKqcIaB2b093WsHa9X8q8qeYSWD1D1E4TdiVxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t2y/d/vQIA6R1WRjI8fXgDyPNluTyUMT37MV/zsJD4s=;
 b=JMcH7k6gViEenvxbzOALkVgZqMdxrFgwFOKRXfRkJwnmuiS6fWtql1i6efXbm7XDJrQZ5ZNC8dqrMRG2b1u8Y6KsuW7fFD2+iBb7dHdvaDqu+YrKrY5SE2pgQszjuY4pY1J+CgVQlvqo38I/ZibJ0yBySB9ZI5uDkTM5n6xCdjiTfwEVocWvsA2NEap2kGZ6wRC5RHWVlg6vOu03CbPnJZMjgFLjaVP3zFGKDyJfRWqXdzkyOjWEvOAqWHXA5tNTmJJ58MuQ3Xa9m73Dm+2CYeCRoP7AsoxsnXbh8+MTis4ZI3lRgXkA5LWXRHLDjTwVlStUozJgqm4AGjTCgYch4w==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH7PR12MB8826.namprd12.prod.outlook.com (2603:10b6:510:26a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Fri, 13 Nov
 2026 23:53:01 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0615.007; Fri, 13 Nov 2026
 23:53:01 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, sashiko-reviews@lists.linux.dev,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>,
 Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>,
 =?utf-8?b?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>,
 Chris Mason <mason@kernel.org>, linux-mm@kvack.org,
 Borislav Petkov <bp@alien8.de>, Mark Brown <broonie@kernel.org>,
 Dennis Zhou <dennisszhou@gmail.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH 10/13] mm/migrate_device: refuse to migrate shadow stacks
Date: Fri, 13 Nov 2026 18:52:59 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <913B74C2-B1B6-4ECD-924C-4EE94C351463@nvidia.com>
In-Reply-To: <20261113144316.57192d4ab088e7fc64eee47a@linux-foundation.org>
References: <avYJ-CxBEpdO1Wmu@gremlin>
 <816E22E2-C7DD-4DD1-AAC9-F51F4D1ED71C@linux.dev> <avdveCV9uW1zwXXd@gremlin>
 <F185BA4F-F26B-48EF-AB3C-848D72FA630D@nvidia.com>
 <20261113144316.57192d4ab088e7fc64eee47a@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: BL1PR13CA0127.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::12) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH7PR12MB8826:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f3c03b6-4544-45f1-76a9-08df41e14015
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|23010399003|261021130227099003|10067099003|261102123227099003|11063799006|4143699003|56012099006|261022115727099003|261022075727099003|261022113327099003|261021135927099003|261021123027099003|261026135527099003|261026130827099003|261028144727099003|261026140227099003|261026121527099003|261021133027099003|261022105027099003|261021121427099003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	bOhhLNSviuKHIdt7jZ4aaTgWxD3SIdAQbcUQFPkXImEN8+l+6MbA9o6V9hpQ0gjXzQVkIDiFQk7iIZytWCEVZmtNlU8t7Su57da7UJ6pxOitWEoBnmSAazyKnY7MKCKlBGGWfvW5Bn1WGOQUD/Rh5eaM2h2VNTDc7QyNvDKebjib5iHysc4uVgRFJxES8ayipEPFnf13hzJ5TxmO45iL7wW5ILmEc5ZR/dphg2/dWrQBJfIN4AZsGdCDuAq9kFdWsAZfsnC0SloHbjTQhM4qJfhzztjCfxx9pVsYdq2n+kv1vO3kmU/d0GgVA/Ttt7YahDAGxHHZJ+xCIWopfKQd9etE3JoO4qNyCxwWTkwweoY39897yG4EZLkEUB1m56tjYp0SDtruHEM7XevUI5Nyybq4yfQh+66RFFl16b+IsxEriEHS7rZr+ARBUsqjUsrxJvHoztFJ+5Pdd3jDZiUj0+apB2cdo332zLYQeh5qIxHOgxr76pOKtgKgvCfDk7q00q6/VWg6HURUB+e+AGG/Or/4D6mmyNAnA3BHnyvEpz5UbC2lSrbVMfH95L2+32xQJgtncOEVufhtIz1qI44t84z9ABHKm5CYqfTkyRYIkmDftrUrX7RDaUnfMBjtOTd/63ZKJ0NTNjj3IMCCnZyclyIhExPq3rM7KpGlmMD1uGA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(23010399003)(261021130227099003)(10067099003)(261102123227099003)(11063799006)(4143699003)(56012099006)(261022115727099003)(261022075727099003)(261022113327099003)(261021135927099003)(261021123027099003)(261026135527099003)(261026130827099003)(261028144727099003)(261026140227099003)(261026121527099003)(261021133027099003)(261022105027099003)(261021121427099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZHl3OXdnYi9ud0lhdWN6V2xuNjdiTWFEd1dQaVFEbmUzSjB5V3ZibVQwQ2dI?=
 =?utf-8?B?a2xvaVN0N2d5YlNEcUFEZytkeU1zejJsc3piKzhxMlJOSXFnZVpkWVNEdDlE?=
 =?utf-8?B?d0hDSURRWmFmTlM2R0JDdU5vQ1p2NTVCQW9uQzlQZFA3L0lSN1N0dDkycHlT?=
 =?utf-8?B?a29Nb0FlOWhlR2E0RGhBamxENlpjTGZsMXpGbE9JVFBmVndDVFBvZ0RYZ1R6?=
 =?utf-8?B?Tnp3Rk5iVDhseDlyT0pWaVUxVHd5d3JzUWhBN1VBeVYyaGIva2tqM0p0NVh3?=
 =?utf-8?B?L3ZBWWxVOEhrczJ4RnhMWU4yRjhwaCsvOU5mWnppUGVHa1lEd3VFZTlyYnpn?=
 =?utf-8?B?TkVFOTJNaEZLK0pVVWtzbWk1dVV5WE9SMXFFTElzZ1hLNmlWTHRxZXYzZGFV?=
 =?utf-8?B?cmJNVklmNUE3ZkJNamJRSDhqbGxseDkySlpWUytFaGovTVMyRlFrYkVXd2lt?=
 =?utf-8?B?VzlhRGtIeGtUcmwxYnd2N0wxa2pEZHY1WkpWZDJ6c29qWDQyQVhEb1gxK0t2?=
 =?utf-8?B?eHptL3NyQjkvbGJtV3VwSCtVNnVTOEU0ZUd6SWtNdmQvNW55R1NXY2wxZzd1?=
 =?utf-8?B?NTVWc2gzTFRjMzFVREZ5RTVFNm44RXp2SCtHU0F2TXdTK1V4ZjR3b1EyQ1d3?=
 =?utf-8?B?czMvRWE0UzZzb1Mza2Uwa2t4bkZEalNHRXBZR2RkK0xGSTNmb3QyY080azZW?=
 =?utf-8?B?b2xCc1prMkI5SkUrbDdHZTk5ZlZaak4zcE8zdG1pZm5FNmhKRm8zSUdHSUlB?=
 =?utf-8?B?UDdSUSt0Yi8xL1VyblV1NWdzR0l1NWlYNWE1dDRjOGJDdms1SThKVXNTOUd6?=
 =?utf-8?B?ME5ibk1EUGNRS09tNWM4ejFOQTZRUTIzaENOYUt1TFExNmsyaXczZmpGQ2pZ?=
 =?utf-8?B?WENpS3FIY2hmZ0t0dXFzZTc4VGlrMmQ5T0o5c0wxQ05ielBnWGo5b3IxdC9Q?=
 =?utf-8?B?S3RFNklMcS9EcVUrT2t4U3QrN2QyYzFST1dYQXJOTmt4UWxNa0hrRFN5Yk5k?=
 =?utf-8?B?K0IzOWphRzZUZzFZU1d4TTk3UWIyb2FQM0ZpajFNU0M4b0I4bFNHUzBFK0dv?=
 =?utf-8?B?SVdrNS9ESUV1M003V1YvaDJ4LzlLSGcwYXJmRkpNekFjNUZ3ODBBWWhEM25F?=
 =?utf-8?B?Z1ZmcUhkSTBlQW1KMUVjd1d5RG5CcHVMaTJDZUtmWVN1UFh0cTdNNmlLNTdK?=
 =?utf-8?B?eis1djRoUDAxTURDTHB6OEdzYzk5Z0NpY2htL24vcmlyZG9FMXdRTENrRXp4?=
 =?utf-8?B?c3ZpMDJabUdGTWk3bnFGdHVjUnZ5UnIrTXFhRmRSblIvMUQwMUJjKyt1ZFls?=
 =?utf-8?B?V1hwcm5YMXFTM3E2dldhV2xhOHJQdlNRazJaODBsSkY2aEtoUEVjV3FFY2Yx?=
 =?utf-8?B?Uk1mNXVEQi90T0JmeUhGeWFMYWtMZ0NYZjBsV21TT1VjQlB1emdxOG1NYWRj?=
 =?utf-8?B?eU54c2kzTmxRUmRWdjRnM3BZdDQ3V0hMRUQ4cy9WZVc4aXlBY0gva3ZRTitw?=
 =?utf-8?B?czdWYk5pK2ttWVpQYWlEQWovaE04YTRGWUdTYlpQZWVkZXdMSGhzeFZNQjdW?=
 =?utf-8?B?aVlxQTBndzU3RDJOTmVNakxRdGg4SXhFK3VpT242WlJhUHRaYjdKSEIrNmk1?=
 =?utf-8?B?UTZRN1dveVlWRWQyYWhTSXBKc05Fd0xRamZueStoN2RaRWxITUlBTms3SkF0?=
 =?utf-8?B?Z2o5YmsxMEt2aU9GTHJDcmpjdmhqakxVTTZPRWdnRDRYaFM5KzlnczdQRm9K?=
 =?utf-8?B?bkpZam9ITjJUazdyVGRtS203Q05lK0dVUi9yL2VEMTRjdi9OckRBeEwzVEYv?=
 =?utf-8?B?S3FWV0VvL1FJWTVsVmR0eGxYSG1sV21nZ0U1Mk1OTlNzb2pTNGs4N29oOEo3?=
 =?utf-8?B?eXFwdy9ya3lHYVRML1VoOVJSUTRvVHFlZkNhcmpieWQyakVxUWRuVENGMTBh?=
 =?utf-8?B?TXlDVnVOc2lYekl6SUN4TFp0Q2tWK1pTVW96RUtGZzhocFVNZWJlMERsT2Jv?=
 =?utf-8?B?eFpOUzZMaXhwWU5ldEFJY01wWmRpWDRFOGJIVnhHdk1aZFVtZmNzV2Q2YzMz?=
 =?utf-8?B?dklUQXVXZ1djZ0VwcUNOcFlQK1NSTVBUM0E1UlhZSWV5YVBhQ1llWnozSkN4?=
 =?utf-8?B?bXI3RU9uNGdGUk15OGFKWGVFTmpkbXlOVmQyb1hsdUdLVzVBN1JmeE1nelh4?=
 =?utf-8?B?S0pNcSt1cVRqTm1HcFgyRlFxckhkYm5kdHZuSVF2T1hxLzdiZW5GNWtzUzh3?=
 =?utf-8?B?Ui90a0tmYlFOQkhENjRHeG1jMVlFZ2N0aHFSYk5aTkExcmZ3SUV5R3M2MFpO?=
 =?utf-8?Q?zRb9rP/cdRmRuTISCG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f3c03b6-4544-45f1-76a9-08df41e14015
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 23:53:01.0132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ud58Vpu4XJS7cN6i1m/g12bMIjxi1Y3CEuFae2Qix/8kotHlusCys02uGTf7IWqa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8826
X-Stat-Signature: 61kswi73m11soyetzqd8cywujcjdngga
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D0D0580005
X-HE-Tag: 1794613987-580611
X-HE-Meta: U2FsdGVkX1/dhc+XqFPuaI2HwIcrhCis3L4/9w6qxuQFATrsrZRNyhWOikc7K5QlZGTi0v1avn1urGUB6b6opmdOKz+/k0CCWDb8hw7jy27hcwozjllu6hq9nITOpBa+wXV4v/Bx0wb5wJJIwbdrUyjeUPH8omaEmch6TCMpBRUcnFlbNsEneXeELSP3n3d4S8wIKsZLqsMrwULU+1tEME3YpK1rs+cOTrgwWE8mFUMxgkCTA5mR7AQ3XGOV6JbnpAwksTNdWngZrfBqDLttCYvwvncyM883foXk3WMBDWxh/q2XMAan1Pwipk2fX8KxUe/PsR6XsDSAVpK7UpIs5fcZnNHNIm/bCWaPdJuZT7ph42DjdHFf9Ph7bWoEBxoPNe1H9S8YwDGu2ixu7iF1eA5LwAfKvpoT13aA6PhekGi1C0SzNeWvjZfWhOPfQGorG2dnGMl5AL4xP0jsbWqDIwZ4LmvmuayQQ4PgKp12JBpMv6xXh7ze0n7Pzs6r9452Xb+5sZ8zCU2U4f2Umb+3pN7KXdYPuWujS/rnECT5sAJnIJ4J8povAe9Lr/pxnveWk1wfN5/ezy1iXTnZRweqc6ysrPot43vuJPaTHDFrg1WWF8C/TDjUBnoaZVuMfGaO4V6ygryEFmpea2eeAU9xVQiBeYnuOgUZ7gpL1Xyltu2sObAvVVP70uBVw2nap9LzuNOhI4QXo6Uvhx2jqwN5pNtTgj9pRlG/eGDOMfSnfvPfpIAgvhTzM11QUV7v1RZ1nwPV0Von1wS1KdcGx/cWtfgPKn5HCAmI2/QDhz8VMDlhejPeYxuvwdKECRU+a7oAcz/n5js1MsS43Bk1n01MCqcGwkx9naQAMzSuqxIaluev34IIKCcK5Zj/JHtaI7L2W8Qm/GHG9PYamnXvjgHWCyF+Qc4AFMaOdOuRQTRdp3rqAsT6dWSM4i6EDW8nSG1NzvGMVg4uFrVFnj1Cgku
 ghQCXTs/
 sHsrcpCqjIt3lvEsbqN/qT/WgKGQMTHDV7gRLlsH0URSmSyqsf2OzV/zxzpBDLmM2LyoRMuzSYCMWLW3J8/IvWLQLR6GcnsZo6ssDLh5yyWsO+uQhXuaeY3xZ3CzCtc26NxnDxDSFecygDjZIIC65IafGVxczbWL2LX2lY6CRRlBzoQ8q5053fXbsNG0If+WuUZ8+li0y9IXsXH0vJXg/MjsCDf4LzgmJozEnQyFL++S3/vf+vVAYt2EUe4J9o/lhqPknmcRwE0fbfipGsY68mOqznF8xvGQe/QLKfvWC30wX6e35UrA6R9UCZQF2EGDg6fBgMkw5eK1Vx5H/LqG40vgEfdsULg5Gpsk7Ft6yS9p1NIzS1DOXXLmo78DAYyesSpj9rHcIlJFVUj7MUtrM1nD1blD84ajDJ0QRtvB/T343Ul8Apv4yC51KI3z6ONgpavU13AFKK6ZmBWfs96CoB9F3pvBpKhQzNplNvOaClF6WSE3UvFxR9J40UOspM8+ygQDx4uvgo2GSPg7PilG4DTVxzWTnfcBD1GB+NHGOJ269FhSkz3A1DOP8Vqrw7PL78RFzvJQSMWcM8/GEiSXBGGEWXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 13 Nov 2026, at 17:43, Andrew Morton wrote:

> On Fri, 13 Nov 2026 15:20:45 -0500 Zi Yan <ziy@nvidia.com> wrote:
>
>> On 13 Nov 2026, at 15:17, Lorenzo Stoakes (ARM) wrote:
>>
>>> On Thu, Nov 12, 2026 at 02:53:44PM -0800, Roman Gushchin wrote:
>>>>> On Nov 12, 2026, at 11:03=E2=80=AFAM, Lorenzo Stoakes (ARM) <ljs@kern=
el.org> wrote:
>>>>>
>>>>> =EF=BB=BF+cc Roman
>>>>>
>>>>> Roman - see below - I was under the impression mm was not supposed to=
 receive
>>>>> 'unrelated to this patch but' reports? Did something change?
>>>>
>>>> Yes, sashiko started reporting pre-existing bugs again, but in a bette=
r way:
>>>> strictly once (per bug)
>>>> only for the first non-rfc version
>>>> somewhat related to the proposed patch
>>>> not more than 1-2 per patch
>>>> not exposing security-sensitive stuff this way
>>>>
>>>> Obviously the goal here it to increase the chances for the problem to =
be fixed.
>>>> It=E2=80=99s global, not mm-specific.
>>>
>>> (Sorry only just saw this!)
>>>
>>> Ah, I thought it was an mm opt-out.
>>>
>>> In general they're spawning a lot of AI sloppers to go off and send eve=
r
>>> more fixes and causing ever longer days for us, it's quite a noticeable
>>> impact unfortunately.
>>>
>>> And often they're duplicative of already-sent fixes so you can see the
>>> conundrum with this :)
>>
>> I wonder if there is a plan to make Sashiko identify duplicated fixes
>> and send an email to point out the existing patches. So maintainers do
>> not need to do that manually.
>
> Yeah.  That might be judged off-topic for Sashiko but it would be a
> useful addition and it'll be cheap.  But as usual it'll find every damn
> thing and flood you with semi-on-topic info.
>
> I've been training my thing to do this - fighting fire with fire.
>
> The main issue is teaching it how to get reliable, high-bandwidth
> access to git and to mailing list archives - LLMs are often blocked for
> <reasons>.  For the mailing-list problem I gave it last-resort access
> to my local 100GB of email archives.  Gulp.  Dovecot's indexing helps a
> lot!

I am using semcode: https://github.com/facebookexperimental/semcode.
It has a mcp plugin.

>
> For this particular patch it went nuts - indiscriminate information
> overload.  It's usually more useful than this!
>
>
>
> In: "Check this patch.  Has anyone else attempted to address this issue?"

My initial idea would be just to check Fixes from patches and group
the patches with the same Fixes.

>
> Out:
>
> : Subject: Re: [PATCH 10/13] mm/migrate_device: refuse to migrate shadow =
stacks
> :
> : This looks right to me.  I looked for earlier attempts to prevent this
> : and found fixes for related paths, but no earlier shadow-stack check in
> : migrate_vma_setup().
> :
> : The original shadow-stack series taught migrate_vma_insert_page() how
> : to install a shadow-stack PTE.  That handles migration's insertion
> : path; it does not decide whether a page may migrate to a device:
> : https://lore.kernel.org/all/20230119212317.8324-20-rick.p.edgecombe@int=
el.com/
> :
> : 6beb99580bc0 ("mm: Don't allow write GUPs to shadow stack memory")
> : blocked ordinary writable GUP, while retaining FOLL_FORCE for
> : debuggers.  It does not constrain the permissions handed to a device:
> : https://lore.kernel.org/all/20230613001108.3040476-23-rick.p.edgecombe@=
intel.com/
> :
> : 3c58f641e813 ("userfaultfd: prevent registration of special VMAs")
> : closed another route, where UFFDIO_COPY could inject chosen contents
> : into a shadow stack:
> : https://lore.kernel.org/all/20260618095017.2553004-1-rppt@kernel.org/
> :
> : Nor did the recent VMA flag conversion remove an earlier safeguard
> : here: the old VMA_SPECIAL_FLAGS test did not include VM_SHADOW_STACK.
> : So the proposed Fixes: target looks appropriate:
> : https://lore.kernel.org/all/20261013-b4-mmap-prepare-vma-flag-sanify-v6=
-36-1aa3c9b139f9@kernel.org/
> :
> : Alistair's hmm_range_fault() question deserves a separate follow-up.
> : That path also turns pte_write() into a device-writable HMM_PFN_WRITE,
> : and nouveau uses that flag when mapping the page.  The proposed
> : migrate_vma_setup() check does not cover HMM mirroring:
> : https://lore.kernel.org/all/avT2FNTZoEuijEZP@nvdebian.thelocal/


Best Regards,
Yan, Zi

