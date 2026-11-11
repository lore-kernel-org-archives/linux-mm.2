Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A41EF606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 21:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=t5sK0DVe
Received: by kanga.kvack.org (Postfix)
	id A48876B05B3; Wed, 11 Nov 2026 16:15:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F9356B05B4; Wed, 11 Nov 2026 16:15:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C1416B05B5; Wed, 11 Nov 2026 16:15:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 675BA6B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 16:15:30 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DCDAFC0447
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 21:15:29 +0000 (UTC)
X-FDA: 85424094378.25.A7B0A79
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012017.outbound.protection.outlook.com [52.101.43.17])
	by imf21.hostedemail.com (Postfix) with ESMTP id 06A2E1C0002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 21:15:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=t5sK0DVe;
	spf=pass (imf21.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.43.17 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794431727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GcuRJmfhHEBE5TyuhOQ91Uqf1/3c2UeMK9MFRYr348I=;
	b=c6mVSKg1Dgjup0vXIB6rMTR7vf/BFN1zeWMc2PL8f5zdiHGy1IS3SVXytVFtLxUYdxhoOH
	C+HgttIpRRJHy5juuDctHZZD7eR7m6gS+KNOcD7NbRrlSNbQsfukayXKbSVeM2MXy30+4n
	M0C6QIchBMiVv8C8DuwSJqZO2wpAn6A=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794431727;
	b=Ka745tfuA1RREMcgN9rJVE25OwqxWAZMmVUrTGyu1W+WqOW3NIj2j8ps2uscCj4wqb1qal
	ltwieMrCxZX9DPEaqYlrjs2vT2Hnx8r9OL0yGb2kXxBbMA9rkJM4iF7EnCcZbfCtcCWY8X
	EenTFUMR80SN6cBK0bSoYKkMu1YXwQA=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=t5sK0DVe;
	spf=pass (imf21.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.43.17 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xb4v1U8QRUBoCTiC8Mn9EW5tE7bo76mx2A52qbRjqjdo3lzmYQX6buNgql61KHvMiV+zmGta2iShtfcANcRE/ezUKdmkWcv9kwF/WKkmWT6N4Yg1QSioq4pZtVY45j/OTk8aTKa3f/jEsUyk9DNrT/QKf6a+zaSsjifJkWMzqPQG6iyyKyWjpH0GyLRXKpz45gLnLkshCGm/lrV7QsqRyYht+yjkZdDD3x3kLD0Swggo6jt6H5nNOKB0w+FYZ+5Pafe92i0Hy3WlQsouiq1gPEPQbzaUdFCUx6icgJWj1TxyQUYnUigx16JrMmn4pNk84oQxc/epk1u7PH9RRx206w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GcuRJmfhHEBE5TyuhOQ91Uqf1/3c2UeMK9MFRYr348I=;
 b=Lb0FdoPTJlONtgMxUFFIx/7kCpgfqV7cnLtQJVrIznPUPVGYzohSmvghHLBLcs3vnwxDSozFMhQYyADxeAHw2mHEUfeZhyFPDOhClexFPqOh7PD4mV3w+tlTRlrziEuTs72ghKduHyHwnUFLdVVKO8PoQzZxfTc98fqorL1SjnMqAQnwvDFqtMltTFkmtmMSZiwpoBm0/UzyEhIt5OhmuRXUIspJ+NtXBlBkG9zeazgeBu9aD7aU8oOykVz8qscrg1/j6hCfOriA85HNDisNmMgBK+osZUtxMeU5V7V+HkE9UFsDrXAMqMzMyNKStWfTi5/2XS1CdSbnQ4Hh5ouGGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GcuRJmfhHEBE5TyuhOQ91Uqf1/3c2UeMK9MFRYr348I=;
 b=t5sK0DVeLjPXHhus3oLXADtmfSiy2LMOIzLMUieWh6a+8eogqWxsVIkNZGRL5/hGSJDHuhkIqv0xRaZRzr3TZoDtPzEO6s8I4O11X/MHVa7trYMUaWwLlvmgt4pO30IsKqkNApWTb0Og9icOeEfz/aowgcB57KYpJSiskdqKnEJ/IQg+Y6Wh1JzqgRrNHhcgvLv9Kx3uyx08iZgVaeZQJ83SVyqBzmjW0N2gJKNL425D2i5EWhiT4OpkKLaN+5QHA20L9n9KEpLRjxa+1Z21UFuqDbIriXwweHmWf9UmQgsexcD1jMvNynVU51fYcy5L3w/a8OfN4v734/MtlG3OBQ==
Received: from CH3PR12MB9730.namprd12.prod.outlook.com (2603:10b6:610:253::9)
 by CH3PR12MB9456.namprd12.prod.outlook.com (2603:10b6:610:1c2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Wed, 11 Nov
 2026 21:15:13 +0000
Received: from CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128]) by CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128%4]) with mapi id 15.21.0615.007; Wed, 11 Nov 2026
 21:15:12 +0000
Date: Thu, 12 Nov 2026 08:15:07 +1100
From: Balbir Singh <balbirs@nvidia.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
	Kairui Song <kasong@tencent.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
	Chris Mason <mason@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>, 
	Mark Brown <broonie@kernel.org>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH 10/13] mm/migrate_device: refuse to migrate shadow stacks
Message-ID: <avTYIXME2I033p9w@parvat>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-10-3d2454362e8d@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-10-3d2454362e8d@kernel.org>
X-ClientProxiedBy: ME4P282CA0008.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:90::18) To CH3PR12MB9730.namprd12.prod.outlook.com
 (2603:10b6:610:253::9)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9730:EE_|CH3PR12MB9456:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f355f30-d647-46fb-f66b-08df4038dfd3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|4143699003|11063799006|56012099006|261022075727099003|261026121527099003|261021121427099003|261102123227099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Dst/5E5NTGSUMT/xrFXRrPBjBpFuFuDqZjjAagSt+6wU4PECULKrkDfeZlaTgybqhJBe+EgJxBrHCAFoDDm/6zGqi7kI2Et+bJfMxTqSpxpUrz7lYz1A8fQ4th+UX2iyb0voA5So2K7w/Y0J35YQ5qZz+md4tyaK8AXDOwqZAtKqwhKseoY/kpxF0DOOLEpXPltP5t1NBlQIsD+Szwt8tyzflOhuRrjpcZszyJVxO/8gh0Xf4LMvG2Sp8QBjJmrg5Wuq1vm2BIdQ8zT2GG8z9Sm5LeeRCaQEyLdPZwzUx50A6znywv0UMvsb7kDef8cparW0L6F2O1X65er4cXGppodfhVPZdbGzfxIuiz6JxR1UJiBgyjUNodLc0DRW45URZ7cXBvn2nc4tQ02WSb1BGlfcjLappTNrxThhrHQx9CcAaRjqoA05RiVarVy2XoLql8kco7Fbg4Oqnz3AGSgNLt2lZCceEHP6//uoSff9o9C1D5SL/7piCRfEhNx/tbnqeWrElJclmzRghOlmHDN/ETVES0f3RaJLmPwoPwoWjZR2+AgPiH34WNQmh3Qk5feW5QrIrIVYDwBthLm45dzsQUYGyweJjhp2zDQhw/5ONVJseJODctrWIWhou7M32mm9aJeDKXqwkavedStzrovpnU2fF5Snp8Zen7RWRwLcUn4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9730.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(4143699003)(11063799006)(56012099006)(261022075727099003)(261026121527099003)(261021121427099003)(261102123227099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kYi+Qx08rtrDz1MDNyKLTVSPy+V08cYtHrJsZ/4pXuMKy6g4bncpSpiu3Dh1?=
 =?us-ascii?Q?TSHLTYLn1Fg7vwnXQeIsi5o66ZW8VgZiEYq0kyJRNk1FOqzGI9x6Q0Z/3vBf?=
 =?us-ascii?Q?vMvNxIyo5DcbGv3UxeTZH0rBjJOvOkAjGEWrzw5MsF/gwsnbLRAeqCdIkrpN?=
 =?us-ascii?Q?qwa83h5xvOkUouKlhBkBcnWL3NYkanNtnHZhWAvJ89u2A5OFli+5sdUE1D2h?=
 =?us-ascii?Q?sJKnuDWqTq/x4UKcjcWgbiQrxFDk+CLGF1yWUjUgHdcYnItuvfigos2hczZZ?=
 =?us-ascii?Q?4/F5JDJkaziXFtggf64zLcHAD5p0uWYw7puoxWLrhVtr3jHJxkFHS3Mp/PMS?=
 =?us-ascii?Q?l4zT8pQac3HYFonn5YpPKeeTZ4PI8tLt7VrLf3HvpGblyuao0x9fGCPWF5Nc?=
 =?us-ascii?Q?eOjCLpLbYFUm3pUJ4Z7PplPuEzJJSoY2yHFc9irzuhHuPDxsy0o8YUpk1zEr?=
 =?us-ascii?Q?buQaJDMGoZn+4vqfzw13LrBzkb+zppzJS1TsdcEjtmGdR9167P59+Ql6Ei8E?=
 =?us-ascii?Q?mTHzFIlcp6whcDuTKwozEd+gF+pqoG6bUapPnodg2DPu/gTLp5Q80wFxA32G?=
 =?us-ascii?Q?raMsTtUGLwp7eBrXE7KeSrZ/a6fpS8twTLETs55MrToed3WOR6WLkFo7rIzF?=
 =?us-ascii?Q?sDKWgVm/R5GvIBU9afn2TW/PACCPaA8cYc6AlVAzCu+x0exEqYuKU8dwbe1c?=
 =?us-ascii?Q?mdEDxxDoYH/9dN8RNg3kFIcW/EKRccdYxUZO28ZGihPiQSBWqL4/WLQRX6XT?=
 =?us-ascii?Q?1R0J8wE5/uk2n3/gpHgeqPiqoIz/nK9U/0EKQhlUJmWfHK8jR5OZzdyyYtwf?=
 =?us-ascii?Q?kvyDsdcEroPQc6P9WM/+MKOIiSM+yALZ3oqzLsSi2t1fk+f+nPD1Wu53i/0w?=
 =?us-ascii?Q?2FZG9SEXSoy18Of+kDnqKRMuygpTnj/XNMG/WGEEZBnKAHTJ99oMY6yY72Tj?=
 =?us-ascii?Q?m1dAiOsk4RjYxocvF+jclyObGYS0D531cMfn6vuw0i300d5/g3IGbIIRNpiA?=
 =?us-ascii?Q?TkdiguDbVTsXFKr452AgmCQ4HjIZiimE8YOnJq2RxXrnxkJUmORtiObI/MKj?=
 =?us-ascii?Q?Y4+Fputvzw3i3OjesYjzP3kPdO66OFkW2RhAbeWIQfT9aUxwU78WpP9ss2Uw?=
 =?us-ascii?Q?ywoSdJKt78bv37luZOsMqIOWSa24f6dRNz10COjqNt+EUkjeaWfsSllrm26f?=
 =?us-ascii?Q?3qXgTpsqjTZCSyKEzK1V0+DAWw3GKaS4IfAUV5mZGi8K1grmkF5XKm6WlHkZ?=
 =?us-ascii?Q?+Ll9Vy0irSG+dv2k25IfF6u0PpUfDmC3srP/0ShRLw4CFezF/q2YsVVVxoWQ?=
 =?us-ascii?Q?Yt4zjHKpCkuJ4+6AtLAMzOK2+JWVqGa75JEit4TNgwxhQlhKXNFwCCGmXDXq?=
 =?us-ascii?Q?kPg5vq4b4e5PYZdwXX+TXTvBK4MN7bisadAXlCfuVHT28CUMbGlYqhw1qyo/?=
 =?us-ascii?Q?sdvXz5RQ7qHgFjlkQn7d+ScNohK+Np2mI3ZNlRRhb6cYgmlL/19NHp+V8PWL?=
 =?us-ascii?Q?4EbMZNZcGW4Ft6+QA98A8/CNYTrBzOsQcvcqCfEzbn6i79Eg9GPdndtSfJaz?=
 =?us-ascii?Q?RZ1UjvcDciMiHQm4ip6BYQ+3TZpaqm/JQu7XDKgiYK6+yRfLyZPwPOz0DAYb?=
 =?us-ascii?Q?cvaqbFJ06Xwg7+kqGq9drrSFxBq4AN19yO51dFx/VLAbBBYq3Xddrc2YDdvN?=
 =?us-ascii?Q?aXTYFwS4mS99QP6j0VbvOtxs37gY8TC1MZXs/SSCi3g/aU36GyjKCcxaVCNI?=
 =?us-ascii?Q?C3oCsKpAUQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f355f30-d647-46fb-f66b-08df4038dfd3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9730.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2026 21:15:12.8654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nBbLPHLmVHq8g7o+vvbAV+2Z0cwtJ8wuXQ7zYpe1/nZRwE4NRJRePOIRpNbGtxMYK+9eTIGlfgsh+S9zuF75dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9456
X-Stat-Signature: e3dugbptrq37pq6acb53567tgtk4zokx
X-Rspamd-Queue-Id: 06A2E1C0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794431726-905335
X-HE-Meta: U2FsdGVkX1+1Aafbw92YJNRTUc3UWoo8MXs0Nq2GgeA7Yw0XVgnvWfrOCf9ahTgI9zdr5tjdfS0Z1yxJaUH42g0HcfgMViBhmsP010OuTKO02BHapKKRIBUgjSKxZLmeJ3p8lG//2ybmIgriJh1Mg6kTT2sZktBveeTbCMukRZWU52P5X8Jn5lYBIlL+iXrTgCY7G+7/UCZcayWpHcC2R1ZQpN+qeIP6yNp2f0MeDLqyNHUtQ/MjNS1UpLiwwtiB8T+loP9Og2OC8WqoQ7myWoqKk0+YB/O0pEhDczvClwAm1o68nhU6rfUqCFMlwlJFv8E3Aub7yRE9/FEP33xty8YJ3aPPCNIDb4w/ASjQYpmnfcJxoVYsV9n51wL4xBAv02tZafsesUmCbvJPNXwQUCMCpYxUwNrHsJngC1yXQW3biNZsgX1+yPIR7UZop7YslIkk/0UOswIBGKIL/OPy12XRqH3SQDDuwayCwv3N9jbkCQfHRdRX8E58moWtm9bCcLv7mv5LHZpdu88u9Cob3VLa5jZble8EUHV6o/6KkY2J3Yclv1QUDib73p4eJQhBYDv0SqRTEMta3LFKgvG2Iweoj2qWjeYX5l3xclKwXn7Kq3MJzn/CJvS7TvuOm42+udpirSEcE5pEDHszAVjUiy1hjjVa3lHkOCFqBLXAVS5QdhgyBFHB9mSi9cdgDQoeZ3xzCiRH/BRalY9CJ1Ztqyw9HBurVowtyTK5YdZGHl6s63N5sxjjDNruc+VBVujnuchDhUjmyM8K1izl6FMgZdNJVhHwB9lbEf8qAAiGlAXXBNiSyR3B8yOQ4ARYaHI7mCN8S5cDs4cn0VDFdjg1CrNN3l0Nkjzxh6fFHuXKQDVx+mLhNygpcNBZoWVAlDHNA+TTjmmO+aS7nxNQcaY6j3DTgHiQb+IjvhaOuxf6eVj9IZ8ed0daZmNCZ3FK9pLE8avjUt68YdbsmF0WGrT
 VDYiPMAG
 xUvxEORefhtKnbLS3N5MDpL3rTWM2V5CYsekvVnpoTnWSujX99iUrDpjPWYgx6Pqa0SUruJ4fJH6XiGGBJQZlmOi4PkxuJ1uZHLUXvGFx+Cx+YdkPxpAydcSX+hbFecJiy9O61c9ianeFkzO1dRCaiZPO2qXz/Qx4e6byAngyecBUgUAI3Qcd7IVydGZiry+IAsGZmft6waGMXioPPHu/+1NTvRNoRZ9BbooxhR8J4d/BKxpO22u/LX5QWax1PEFhRaHBxr0MF41DokL3N6LNIr6nJwbZdCFKWoA+eiBrwklqf/CNAZfVBx0QB4FSS3sRoe4TNRDkfbvBt5hywYhr+QGjzXSlPAj4BAY4qY9Fhkmpn5wcR3Ie38SLn/J44YHQW3DCopW5XkgT2oLhY+gynsMpxNBlymdNSTnDAwY6Q9NILWAsraif9QXcXypGOIuE2IeAOHRDh1DvPz4jcOH0quUkKR5a3KXX5t/fPWPWgY1wfKJUzWV2e2AKVLmBc5/ts20verxDt0uoUED+2hj41gJtqV8DwgITdFPDaIaZL2hNqifZqv4E44nsnenGY7lOHkul
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 06:13:24PM +0000, Lorenzo Stoakes (ARM) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> The kernel blocks ordinary writes to a shadow stack. But pte_write() is
> true for a shadow stack entry, and migrate_vma_setup() sets
> MIGRATE_PFN_WRITE for each page where pte_write() is true.
> 
> Notably, the nouveau GPU driver takes that flag as permission to map its
> copy of the page writable for the GPU, meaning that the next CPU access
> migrates the page back into the shadow stack, and the page then holds what
> the GPU wrote.
> 
> Be consistent and disallow this for migration.
> 
> Fixes: 54007f818206 ("mm: Introduce VM_SHADOW_STACK for shadow stack memory")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ ljs: removed unnecessary comment, refined commit msg ]
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/migrate_device.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 5fe11dd01291..a59864f2e9a6 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -759,6 +759,8 @@ int migrate_vma_setup(struct migrate_vma *args)
>  	/* The migrate_vma page walk has no hugetlb support. */
>  	if (!vma_is_mm_backed(vma) || vma_is_hugetlb(vma) || vma_is_dax(vma))
>  		return -EINVAL;
> +	if (vma_test_single_mask(vma, VMA_SHADOW_STACK))
> +		return -EINVAL;
>  	if (nr_pages <= 0)
>  		return -EINVAL;
>  	if (args->start < vma->vm_start || args->start >= vma->vm_end)
>

Reviewed-by: Balbir Singh <balbirs@nvidia.com>

