Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC73DC982FD
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 02:08:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9873E6B00A4; Mon, 21 Sep 2026 22:08:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95F076B00A5; Mon, 21 Sep 2026 22:08:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84D4E6B00A6; Mon, 21 Sep 2026 22:08:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 504686B00A4
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 22:08:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A86B71A0350
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 02:08:06 +0000 (UTC)
X-FDA: 85239762972.07.0AB98A5
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011064.outbound.protection.outlook.com [40.93.194.64])
	by imf21.hostedemail.com (Postfix) with ESMTP id C6DE61C0003
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 02:08:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=b16N3E8W;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.64 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790042884;
	b=T5T0Yr/NFbXlrQIZLlY+miMlv0cVptuF8qpAX22QEbxRg400WOlfyPavxqc+Hslvq7/EO0
	SXLe0g18Y65l+MQP28VZ000eWXCI5O1ZDNWo3nYqWBE6Ln7Sg11ExsXB/DSslkU1G5k3N/
	sKDIbce4Xka72+Q7h6rVNhW9NqxF7Yc=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=b16N3E8W;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.64 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790042884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xFN39LQCEX3Ac5Si5PZ2vXx6j6554BWx1Y31QFhZbP4=;
	b=Iv4kzrwPuz7Ueg9wItqsfgXwtyeYEYoaUaTnPcEKi0DTnByPK5b4eLgP5jaV6bITiWJnNf
	Z95WlbYSnqXaCmJAIgChuLAZ189q/oq0YBgAqZhlpIMDKuoqbgAJb4AQBC3H4nGJqAZ2bw
	55ML6WTA/j91patGD1UjoXD8C7OsrRc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bYDI0PKP14fImTrtBDpB+GVakvdgXkYGxn8fP33zr3Hr8EThXGT0sUG4r0TvSjmd9bHAQlNLTxCFEhwHzao0F28aC8rMdqctIJYB8d8F7a6RC5gIJnpcJpQOIDq42E923LHurnb9z+skP3wXw3lM31dTXlX9lf7BUNCfDPriw4CAPj/NajpWjL83iunIAqlWJvh5J8ir3avO/sGiMNMeVz14EoQ4DihXzpVrUt4wNgKlghWH6hkHgivdfg5f6dR+1DxIbVOb4ii/8OswGs7olw/vSZbC+E7jdauXf7Wv3UVZ5BzthFeteO8bnSM8ayb1d5NMr45+m210q6X4pS4xDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xFN39LQCEX3Ac5Si5PZ2vXx6j6554BWx1Y31QFhZbP4=;
 b=xAxYWNrhPj8QgSpnaYJ/sCPZfO78itii5RhOxDdnItCCnw9bjt0tMe7snJtNLqY4Yzgy0Ayiu9uE1IRdFdYGMcIGmgguxLtbB76xgqyfvkTuobc00dX0n81xxisT1tpcFnJryig56cuoMqfE+UtnX7Kd2j6U+5lnepmn0bi+PSgyUnffqcU9dkRu9HLJmXPWJTrFqklHzVjclA+HZ9OTGrD6KzkXI8vGD5EP1qcF9aAkKcZ+kUmTlvtdQTEiPnmqb7UjHdL1Nqq2H7YAG/yArti8kkFGZlh2N9hhEczrSQw11xcNvMdyXG7pbZZQklJJ4RA8t31lkj5O8tIjZaOMtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xFN39LQCEX3Ac5Si5PZ2vXx6j6554BWx1Y31QFhZbP4=;
 b=b16N3E8WTXjXUAE0S0olxPKUFEDNDypG9Q0YAK6e669m6+eYADazl+P3kwdbOykrGKgeNDTTP4f/VRkoTuz14JG56jNu/vOuXCFlaOEuk27FITkYTl9m9zSsAsmBHGLh8R4/284ZFLytMWI/eZgtUiMeza2FdvenFjvYwwr54ko9FbgHtfSJ6NZxZ5s5Z/pgrcpMg0bTvG7QUOch0BEGE+qsF40l3jtHAodqefnK0SlYQYs/f9D6bPpqI2Ie0UVPFAV3GpZA64n87Pv+D74axd45x2JGnPplXF/hU4xFb0eaR1Wpscq1Xkv1eU5w3xiTU9xgJfDcgcYHwKLHPPAOJQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS4PR12MB9588.namprd12.prod.outlook.com (2603:10b6:8:282::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Tue, 22 Sep
 2026 02:07:57 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0428.015; Tue, 22 Sep 2026
 02:07:56 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 21 Sep 2026 22:07:54 -0400
Message-Id: <DLLH8O7B34X1.N9ST1FNGK0ZH@nvidia.com>
Subject: Re: [PATCH v8 03/14] mm: introduce pgtable_has_pmd_leaves()
Cc: <corbet@lwn.net>, <tsbogend@alpha.franken.de>, <maddy@linux.ibm.com>,
 <mpe@ellerman.id.au>, <agordeev@linux.ibm.com>,
 <gerald.schaefer@linux.ibm.com>, <hca@linux.ibm.com>, <gor@linux.ibm.com>,
 <x86@kernel.org>, <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
 <hughd@google.com>, <dave.hansen@linux.intel.com>, <djbw@kernel.org>,
 <vishal.l.verma@intel.com>, <dave.jiang@intel.com>,
 <akpm@linux-foundation.org>, <yintirui@huawei.com>, <dev.jain@arm.com>,
 <usama.arif@linux.dev>
To: "Luiz Capitulino" <luizcap@redhat.com>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, <david@kernel.org>, <baolin.wang@linux.alibaba.com>,
 <lance.yang@linux.dev>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <cover.1789695931.git.luizcap@redhat.com>
 <f0b6d8a8036ee6c2aef2a63e9a03d94292a2c599.1789695931.git.luizcap@redhat.com>
In-Reply-To: <f0b6d8a8036ee6c2aef2a63e9a03d94292a2c599.1789695931.git.luizcap@redhat.com>
X-ClientProxiedBy: YQBPR0101CA0278.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:68::12) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS4PR12MB9588:EE_
X-MS-Office365-Filtering-Correlation-Id: c1d25505-6c52-4a31-4843-08df184e51c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|6133799003|10067099003|56012099006|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	wwWknH21qgVpSKzYW3RgyfCx77RR7GMu9Ovd+/lGkQQ4LHhHmuJdTOU3KdtbuQ0DsHoiJKPWf+x+lLoU2oG52axMGcGPl9TC1/9tvYEM70wSUSzqtkO/O1+j1wgg9wIjZwr9eB/RWS1eLgVFDrGXXX7FrgDqs4dDOSJxdIb//mBkrY3LXcGUJu/yA/tHcGMclAEfyfvx5PCO2IQxD+DD0dy3CoFC7Z07DF0bx5aiqn2sr1RYnaPEmy3mVVQWx3dM7VzBHZMF83MhQL65qhzLuMOuF81xh7v7lqIpSlL3muZcQNA/2aBAjX1d/nvv7RJPgT3V21LLyCu093kS6cXRe2GTich2uyHTPVxtPAJHzTCUgr8P8oWSXUy/JSe0jZqMoJcl1x4+35oNOGBIlVB05ArpCMC8TBdW+PUIpX4zrIXy67fYVqBMo9LbNR5p5vAXQ53EeIXcjEZ8jJeCnnQ7kV8qcw9f1rxewfKBBTqHlhpE1YuPR9Ob+7M4QT3Ulaa6flPtKc4LpaUWqGcE5ImIwbuF9dpcJWYv8VIr/cvUhvS++NAXid35RNJ4tJh9D4dPyVSofjYg7dGmi61DTdvQbAODi0n0ahmEY52weaVj/glICMXTXmVUEO9HOumgtkkmY24pp0B5Xm/WlSmd4jbpUMPH6bq65zSOnGFqpvCetGQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(6133799003)(10067099003)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UisxRjBjekJ0N05xVFdlSnhLdG1SMVIwQmVzTU44SFRhd3owSTd6Y0RhdXVR?=
 =?utf-8?B?ckdueVYrVG0rMzlRVFU2aEdieGh0b1B1enVaVzJ2L2JWeUlGUzB5UktDSEJi?=
 =?utf-8?B?ZFlKNTFXOE8reG5wRDM1VDhyOVEvL2x1aTJ2V2t6T3J0Zjd2Ky82UFh5OG9u?=
 =?utf-8?B?Y0M0OWNPeGNpRC9wZG5VTGJmdnF2RXhmQTVLeFpMcmZyZjZlRS80N3ZBVWtD?=
 =?utf-8?B?ZGdxdjZiKzJxYW91a2lPOHliZjhCZUU1UW5rNm9wLzNNQ3BZLzkvR2c3NnZG?=
 =?utf-8?B?S3U3Yk15cTFTZEtqNVBLbUlzV2lxamVxOStPVDQ0RXdJRGdIRnBvSTN6cUUw?=
 =?utf-8?B?RFFtRUJtbGVnaDdHdWFSY0hPRGlLRGRwaFJIVGZBWTVDTHhTMXF1L1kyd0VZ?=
 =?utf-8?B?c3lraEQ2Tll4TEpXRFZYV1FNWlBaYzNZTGlwVjBYUDNhOWpiVWxTK3FBNWhE?=
 =?utf-8?B?Nnd6MHo2cmVSUTM0TTZZRFRwY0tpV2lXV3N5a2M4L0hwSVNPQWtnTWFENjM5?=
 =?utf-8?B?eEptWHVvSGNUejIxbmtWR25RakVlcnNXY1NickNadWJMQzN6RkhDRDRVNmJS?=
 =?utf-8?B?aWdWNXgvV3k3UElremo2VytVZmZGUVR0QWJWNjFTVHFjNGhnYlY5S2VsNHVs?=
 =?utf-8?B?bFFkTEdGTWp1VWlnUnZ3RkNjRWsxUG1wZ0d0SGQzZW1CMCtYcC9MN1VINEtk?=
 =?utf-8?B?WXBLZFAzNTZSUkF1NU1CdC9hN3FMRVQwOTM5YVhEc2pxZThtSDU4QXEyK0Yw?=
 =?utf-8?B?L0lJSVpneGJUSDh2MnZibHF6NmVhUXdYZDVDOEN3SmwxdzdRdVJYdktadVo3?=
 =?utf-8?B?eTM0US9INWQ2Z0lhUTFuV1ptRnRJUHhKQ1N4YkVYYUwyNXVjcWw2M3dHVlQ2?=
 =?utf-8?B?K09jcEg1aGZXSW01NWlFMVptTVFyZm56THk5U29rTVladGsySzk5TElmakFU?=
 =?utf-8?B?VFlrcEJNMlBGdVhnaXRaaUp2RkNMS2J5RzdxVUVsQ2ZXQ2xia1dIWW81clQ4?=
 =?utf-8?B?OVJMbHJHV3pJWkc3QmR6alRCRU5qeG4reElMOHVVc1VFcmgrR29EdE40K202?=
 =?utf-8?B?OEN6enVLTEszSFJGbXY0enVtZDhadUdQMXhmSnBRdnVSc21zSzQzUTdQVGFG?=
 =?utf-8?B?cThPRC9pWThRejJxZVhRMmVMZUxOQVFzbERTZzFQdmJKbWJhaUF4QmtMbUcx?=
 =?utf-8?B?aVkxbGFvTUNBNm5TdlNLWE16SE1sZnUvNVRMa21iYXlWM1liUFg4c3lJSjNB?=
 =?utf-8?B?cWVuaFIyUmludHhHQ2FFVnNtQ21nako2RVpiUFhWckpEQ1FFOXA5MjIyQW9Y?=
 =?utf-8?B?dVNBOTNpazB6SUlMMHVHWlB0WWZzQmV1QzJ0WUhRUzI3UHRSa0tPVEs0TlQ0?=
 =?utf-8?B?SGpxbGY0MGx4SGV6VElvK2pXb2F4ZXNMQXNqaXNETzV1SUlsZFVyR0FkZ0tO?=
 =?utf-8?B?ZjZqQWUvWE1Bc2NwMXN4VytNSmh5VzE2dDYwemVMSERtU1JDK05IbTRIUjFu?=
 =?utf-8?B?cVE0RENJT1M2TVZ4eGIyNWtJNnJQNVJZWFdldWZQOGRjd2xnNXJ1Yk1wQWlp?=
 =?utf-8?B?YmRqeUxEb2oxUy8zS1JKUGJTWjZhNktwYkhVUVN5dHJ0ZCs2U1hXc2lMcW1u?=
 =?utf-8?B?TkNKVC9MeitwZTRFKzR1TFFWRkZzUUpVL2VoUityODBEWDFIMmd3UlJVczFJ?=
 =?utf-8?B?Z1VjTE1VSTlIUUk1SWtPTzIzT0Myd2xGMW1xWHhudXVpQmNhbVRrN2UvbVcv?=
 =?utf-8?B?QkNtMG5RM01BN2ZtK3lJU1pvR09ENklWVE40MjFicm0rTlgvNE9INzBtdG0z?=
 =?utf-8?B?cXRwZW9MR0Z2d2dnRDB2eFFPaE5ncXZld1NHV0Z2QnlvNW5ST0dRZ0hGRXRP?=
 =?utf-8?B?ZDU1dk5ubU5kN0VwVlp6VWJmV0w3WFJqdzg3UVhISlNJR1ZUTVJnczZYSFJB?=
 =?utf-8?B?Q05ycjQxcTQ4Qm9zYlhvaE9tUGdRYlkrQ0RYdVc3Q2RBcm9WRENFQzBDTytT?=
 =?utf-8?B?OEc3TFV6OFE1Z2I1a3lzb2ZZL1FtOTNtVzEwS0g5dzNrNGtJbFpUT1pHOElD?=
 =?utf-8?B?dHZpWVRGUlpBb2hRMEdGRHd3NExBZ1IxdmozYTRCQU82SW5WM2dFSWc0QW42?=
 =?utf-8?B?dUtjZTFKTlVTS25jMm9YeDNiaUJFYXdpYldBSUtJMWhVRHhZdGZscjl4Zi9a?=
 =?utf-8?B?SXdxcnhTeklRZmxVbU9YY3JoVHZnUEg2WVlESjF5SU1YQjhDc3lwYk8weXpt?=
 =?utf-8?B?L3pOMkpMNCsxa3RiQ2oyd3VSQ3BiV0Z2d2MvenFXczdTUjZYL2F3NnBuTmlk?=
 =?utf-8?Q?t1UPPfU7XsopMKYFAs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1d25505-6c52-4a31-4843-08df184e51c4
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 02:07:56.9485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BmdPkzGfhqYUjQALWUd2UhG9FfRBeznT4+Ux0JL3XaJMlMc3fLo+oBpkhJ1JANcH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9588
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C6DE61C0003
X-Stat-Signature: 8tmnr1xprxgdxxut48qpujpn5ougmk55
X-Rspam-User: 
X-HE-Tag: 1790042883-204630
X-HE-Meta: U2FsdGVkX1//iiIPswwpE6fpfudjS+BcD2bfrJTcQPo4Ma46dcgTZOniCN3qVczOZD58ZC+0PbjiVTQLK2KUg6JZvsZSkKY7AjITkJBH60UkjmLhXQTFsonruqNF49A4zoC3tpjk14AZVggzlaB7XO8qLCb6y6vfI7yf7vJxowlQ+0gaj1yLZsz5TLu14EVvTWwdNcRoTzOxv6W830cjocgq27tTR/l4dbSEBgkzRZhplOQCAosl7g1FO/qITr8Smea3+eGPoWzck+hca5SS6zbBQOlWm710B0OwHyCuJ1dVVPQEWVsyt5k3WetoMelIpAz/lRb2re5gc/hfUjHJsOuu5AEVu09fQ6J83gbuWgvz60pdIMIiSdsXVTdi8rdjCIlnknqaktqqTy4x4HHRH17gJu+hQLioTxVF3ps9STwBBnv4ZOfLnkvgOxv7heGW+kOoTte3abr9KH2aw0zCZUxE7eEeHlus0udGQcGpFfz0f5pE6CVlwrIZHzbfVyMh946PODCEGPT89HILC2ORpBaOdqM3Njpaz91I5/w7Uqa4AEPrIpUM+4RD4ta0NgbcJlEuErX2musDr6M+8KqBXedOu5GdRV2pIg5aLNZTo5Y2uEyz1kIfFeecTEauIraG7vGDMPVtrEfuOcpMQ1xI7/POB9RWSeGRIgWv3IZPoKTsOF/KX8LS7l2Cvss4epVffxamUfd1YtMcbzlAyImdlnkKPy0b/MDyArDRb27uVhIJNC+8RAAuTpwVLgHjd2/XG5FAAnAIMYGjs3pkznsP3W6AiAN3Mdu40fY4suMlWR/52+sDeo8ueqDkh9b0foVDxEzpcJrnM7FAHa9eULjgllWShxOE7ZWYAO0gcrPb6C+jJZTS0VqkV0PPtrLqW5dA16CUCcrVi8rD2g7sswjgASYka7T5f+mQSBJIF7O0EaDCvaElHnTbglb/oSzxFpszlMspA4Se0C4LmpanlY3
 oFik3tIR
 3CNOioe8st+SFDWGllCg6WiKkJgKffnJf7FuR408XyBvinpZWdmB4BU7hPFVJp5m+ltnWMy9n1GOkGPov9Jv0NqnNPACASjaOkYu1uVUBOTxK6K4K7oYnTWAPs1SaFe5f0kOk6rvJ4qDuQ5XBn9iZhfs2RephLrx2WzWVvQ0bOhKFMMk8/HeJ7y4WsvHbCYPFRvnAkunGnMJ4GknmNHjRdc2quZNIGeRmxXopmWuFdpLNHHk9WLJ/LbtCaJJ05NYUzR06IUFLvlpEEaq8X0RJze/SX9Q6tPbEcPaINfMFBonI0QxR0orEJhezJBb25TdJmxVS24XgveBnY21hRKY352ePopn2r/6uZKtR8tNao5/LGnsYyvSXEYwGCI2WINIZOZKRUaqKEaYL/UJPOMq+80vGgNDt4V42tN/SiUrl511vdexstUHA86ZtEix0slBUHqPj9gv51e55RhPR808XU+2MVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Sep 17, 2026 at 9:45 PM EDT, Luiz Capitulino wrote:
> Currently, we have two helpers that check for PMD-sized pages but have
> different names and slightly different semantics:
>
> - has_transparent_hugepage(): the name suggests it checks if THP is
>   enabled, but when CONFIG_TRANSPARENT_HUGEPAGE=3Dy and the architecture
>   implements this helper, it actually checks if the CPU supports
>   PMD-sized pages
>
> - thp_disabled_by_hw(): the name suggests it checks if THP is disabled
>   by the hardware, but it just returns a cached value acquired with
>   has_transparent_hugepage() during boot. This helper is used in fast
>   paths
>
> A better design would be to separate CONFIG_TRANSPARENT_HUGEPAGE
> checking, which can be done with the IS_ENABLED() macro, from checking
> if a CPU supports PMD-sized pages.
>
> To this end, this commit introduces a new helper called
> pgtable_has_pmd_leaves() which offers the following advantages:
>
>  1. Well defined and clear semantics: it returns true if the CPU
>     supports PMD-sized pages and false otherwise
>  2. It always returns a cached value, so it can be used in fast paths
>  3. It's implemented with a static key: it's a no-op for archs not
>     implemeting it and for archs implementing it the static key is
>     changed only during boot
>
> The new helper requires an initialization step which is performed by
> pgtable_leaf_support_init(). We call pgtable_leaf_support_init() early
> during boot from mm_core_init().
>
> The next commits will convert users of both has_transparent_hugepage()
> and thp_disabled_by_hw() to pgtable_has_pmd_leaves() and/or
> IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE).
>
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>  include/linux/pgtable.h | 17 +++++++++++++++++
>  mm/memory.c             |  9 +++++++++
>  mm/mm_init.c            |  1 +
>  3 files changed, 27 insertions(+)
>
LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


