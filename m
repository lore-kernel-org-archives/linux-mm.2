Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2C74C88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 02:25:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F25D6B00A9; Sun, 13 Sep 2026 22:24:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87E9D6B00AA; Sun, 13 Sep 2026 22:24:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F84E6B00AB; Sun, 13 Sep 2026 22:24:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 450556B00A9
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 22:24:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B83BC140B83
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:24:48 +0000 (UTC)
X-FDA: 85210774656.15.8B34EAD
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013010.outbound.protection.outlook.com [40.93.201.10])
	by imf06.hostedemail.com (Postfix) with ESMTP id EF91E180002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:24:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JmmhIZ1o;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.10 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789352686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VtR909bQ6Q+E0z0K+MmOpIKOSp1OMThZiLeXMQNGKro=;
	b=YtDpiySXIfDJoTl67kT2gNoRG7PfHBu3mkzAcV9g+SuN3vnGgiochXjK+f2Q1XQFWXEhxk
	IeFkToRs2LiK5Mdpk/5mOaqnyxG7XbNP95VDg01/HAQrWWumz4bNHe91obT2lek8/kRD/C
	6FUbRR1+Vb+ILW9VUoEPKMzhmmPopMQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789352686;
	b=39EkQLFxa/awwkUfrzzj2QYtAOE7Xn0vZwlT7tZX/7+2DUzMCMJlXJIPx9ggNMala0UXrX
	aOykx3kIH9PsKPoL7JX2Wx0SJ2cfh1KApFqte7vbW/p8J2IAOIjLSHgURl2UC4YAGOZ9H0
	73z8onM4c0LU57D+ccjx6MGfUMrJuQw=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JmmhIZ1o;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.10 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vAvmQ3TfVMnJfuM2O80vtht1sccQtuzzHuYOeyuvI1wSKmzyc5505Rr7eQAwULHYAP15slSXBZDJnMg8hU/5GLsa2JuiLsMOG+Y03bAcpRxNdu8FPZ17CErftTJxIsRoNv26uVGKVJ1Szu2GFroak+QHD9enzbQarEfNLTo2QuU86pcXk9XPAnUFsC8fgAv0QimD63bCTF+FX/z57EsZZnP1pk2QBsubQoBHubRhWOg9TSFthmzjd+mbJ1PnTmyqg/zIU2aOfNEP7unE/gzcOSGxjmGdCzran1arpmf6/m2gpeaVWBVlJ0zZZi+LdEN3lFMLCWLREJgnQ/APY9sxWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VtR909bQ6Q+E0z0K+MmOpIKOSp1OMThZiLeXMQNGKro=;
 b=YmNPWWKBZWym7wPi96EcVlIkY59+2X6s5Qudd+quC2Nr/qdS94cH1xl4XSz9LTsmLbYxb+r82lxAPeVbjwPDSHpZtufGn32TGPBPqW1U9X2Id9/qJ8BPSPN+Xko8qZDv36jtQ42APGPBDeK+8la8BsgpO7pSFMShFalpWwAUjRDZSIPRXd/+jVAW78JVPGq0y/MOEQY4UHJ7WMi0fiRdZkUaJidY7VYDc54o8716wv96unSLKfqTeNWIgjkFAxhXe9xUOMe4g7OPVDTqCYr7UDOm9xle2ZxEGjJHRxlXZGvuTwzry1oAoADA/RvPsUHut5C67VJqGqhZcC+CDMAzzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VtR909bQ6Q+E0z0K+MmOpIKOSp1OMThZiLeXMQNGKro=;
 b=JmmhIZ1oCwlJr7xHTFXh3bCKXYVyM+7mcy0YrsmLvIruQEUpieYBuzVD1r/yoOSB0LvBbdB2R7GaPOEyYbPb9dSCIN06/dXmNrxtVeDi+yRJXPsm6bJEfZ5sJEfJzHb02phFSR0/zqh+C80sxQ6Hs31pXA5H6lIgIJNrtx80E1xOgVckO6wHiBNX9x+MbCwN1IBmg8kL401DN0imv0KdJiridZMMEkj2pYBK5dvxA1b7xX7wLx+4lrUsy+9oAocSR54sZZ+ky2RxK338VTtNHS6U2m10fV1REU/vxjjvhDWoH4+An2qYsBpc8B013OKkn0Nuvef7whfWTSZ7phRruQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB6486.namprd12.prod.outlook.com (2603:10b6:8:c5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 02:24:28 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 02:24:28 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Sun, 13 Sep 2026 22:24:12 -0400
Subject: [PATCH v4 14/16] buffer: replace page_buffer() with page_private()
 and delete it
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260913-remove-pg_private-v4-14-848550f7574e@nvidia.com>
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
In-Reply-To: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
To: David Hildenbrand <david@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>, Song Liu <song@kernel.org>, 
 Yu Kuai <yukuai@fygo.io>, Jan Kara <jack@suse.cz>, 
 Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>, 
 linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
X-Mailer: b4 0.16.0
X-ClientProxiedBy: YQZPR01CA0109.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:83::15) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB6486:EE_
X-MS-Office365-Filtering-Correlation-Id: ebfb2132-5502-40d2-9f1a-08df12074d7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|366016|376014|1800799024|22082099003|18002099003|921020|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	qa+sMDLKj6ZR6txcfEpFQjOBSZmDa31mur1nw1M/M9KOizkExzDubtsOkyonuqXFKBUeZyu1BDyuC9CxA5Eht2l7Sa7U94CIfKp+6SvSGZWeRTEkJKCsPyM6fO2PQtV5TeKdVvRbpzyOpgTTdgCJnxwnGnM0Rm9SE1j9y23bgkaEjaZ1VxJ561layOdOumgnh2DF3uGrq1xpU/fx08SQ00maANq9eEbllqIFmQuNRSgy0po5WqFZsXVHdJlrOGb2bfRtDtA4D5erOPonIlLCGNA68x0fOnmWvQzVDnURZ4rTimcePtQDeXUF9LkqRI6cDM9nbKdOSBoghNRaHkfVmT9mep93V8iRhxzOfpTuB2WHc/iLi+pzp2+aH6B98HhK2lkJHDIDGfQsgaQ97n8fqpwFST/VZn3DFer1IJBirRdHjKOaWt65Q/LPUewstVfqRnO5huvQFru/ICNjIrJcxo74ZMLYM22xY+dIsox1N3DcxNK6+fsn/d8Iq12UfERZz4pHjBZjRlt7/FR1Wp/yUI5X8+FddeDAa4vqePfTa0eU5l35nSuSqaMHksNSDIIdFVoE1ASsbL62eK2uAmp3NtaNkVKKkanGlSzfJkNsCz8mV4EoyOI15oTIsFzfIzyhods8CRyyuHLtp89EDxhDxM69rVvuQ0vb894MxocL0VuPG1j4vKVV4IU21eQCYHBhpbiJeVDo/RMdkevotcsg+w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(366016)(376014)(1800799024)(22082099003)(18002099003)(921020)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z1JtVHVvU2NkclBDdW5udEg2UHlLc3ZoK2M5QUdDakNyK1A5NHpDenZtV1l0?=
 =?utf-8?B?eUxtMHRhV1FLbGpGSXdqamw5NzRiNE13NkNsSXJ0dUM2UUtWM0RCdzZiK0tt?=
 =?utf-8?B?L2FNcHJrT1VMWnlSU0p4NVJqNDNjZVJ4Tzd2WlgvNUtPZVg3dm01d2ozU3dH?=
 =?utf-8?B?Ymx3Z01UK0svZFRPMXJBb2hNd2pwQ1d6UlQ4cnRpR0VoeGFVbHBkMzRHTWV5?=
 =?utf-8?B?NlltS2ZlbnMwbHUyQ3dFT1JMbmRqRFNTSVM3M2lremVPVWlFL25rcWcxTkty?=
 =?utf-8?B?ejV2WEVtTXIrMGVFMW0zbFR1Z2p3dWZzaS8yUHgwVHI4UytFMkxQMHordVZQ?=
 =?utf-8?B?aU51dnJFZ1NZTG5DeE1DZVB1Q0xhdzBZZUwvR0dzWWhXc0Z0MExaT0NFNjFY?=
 =?utf-8?B?emRPTEZuUGs2blNYQ3VydkdxQklwREV4NktjZ1ExQldhRkJ3c3BFLzFLckR3?=
 =?utf-8?B?NGpSQW5hbXRJekRWcnFCOVBxeXdSMjFhcE0xNURRUUZKbGM0RmdNVUhRVThu?=
 =?utf-8?B?aFZhRWgvakwzZ0hSSDJnYUJqQjNIYWdFazNnTlVYajJVeVlHZGZHamFIU1NS?=
 =?utf-8?B?M2srR1ZmVFlhVTZCN3J3QlJVQ0JTSWs1WFRkZlpuNkxmT2FDYXdKUjhVM21G?=
 =?utf-8?B?cjNFZkIrSkVsTitnQWJFS3ZObmkyK0N1ODlUNGluK1BrL2RZVEo3aHNsVTFs?=
 =?utf-8?B?TkdEV1FJMFZMbEpIZFozMHppVHpnZnd6Q05GU3hTeVpqV3pOZVhScXJZanlu?=
 =?utf-8?B?NFZIZ25Rd3lKQ1dZUEEvVzE3RmNrMTRmeGl5RVJ4RTNuQjB3YXo0U2ZDTjhL?=
 =?utf-8?B?eHllUmlGL09JeFU3TjhITGtCSUFlSFVqYXpkMTdxRnRiWTJ1c29HVmVKR2VI?=
 =?utf-8?B?bzI4elA4MVE3R1c0bkxqQnJFc09tRHQ2bGZIUXhBSUJJSHZMQXhLTVFjWWNO?=
 =?utf-8?B?S0FYMkhGR2NwenJPTUxRT0NOMjRxZERPYjNlUk1EME41czJHYUtDWDc3WHY2?=
 =?utf-8?B?QSthZTlid1hVbU9vckQ0QkVPV2hmOWU2V0dKWjZoK2liMHRhQTJzYmNyd1cr?=
 =?utf-8?B?Zm9oY0YxRkNNaGlhUzF5aUtqSFhFVi85aXNHa3lyOXNIb3N6TnYwVDE1cjNQ?=
 =?utf-8?B?eWxLVHNsMnk5NzdTeDFzN0txS2JPLzZZbm9nOFRnSkFBWUkxbXZDUkZ6Mmhp?=
 =?utf-8?B?NTlQM0crdStyaTBJUXhDYnhrSG5FSXEwOVpKWHhwVEJVUktkdW5MNGJ0aHNU?=
 =?utf-8?B?VjJBQ0wxYUxXV1NjeGNXL3FjVnRrbHIySndRT0RCNXVGK0JwZWh2eXh2WC9M?=
 =?utf-8?B?OUpzVmlaUit4Rm9oZU12bmVLdW5EZlNnUTRwZjZBVzFvOWRWaXd0TFd0VHVo?=
 =?utf-8?B?K3daeTRtZ1BVSVBUaks0UnRzOGZwUUJEa3RkUzViMjlMb0xxV2dWM3Z2UnQ1?=
 =?utf-8?B?Q2dzTk91MHEwYWIwclBTR2tneVArZHRzTElrRVZUa2RBa3M0UGFzVDRMSHRN?=
 =?utf-8?B?aHNpQVdSU1pmeTBqWjhoU2grU290Z051Y05sRDRvcFVHdzA0dUlYbTAyaS9U?=
 =?utf-8?B?U1NxNjZiQUpXMmtSR3J4QnNMY2FOQUdIY3pkQlJsUGFzck4yZGZPQVUxRHJs?=
 =?utf-8?B?QnNhYTFaOGJ3L1lzRXdKSkhkdjliUWx1VWtiVVhwRzBFd1FKQkVqS0ZBN2g4?=
 =?utf-8?B?TU1EWGNxeTFRcmhrcW5TT0ZUekltMVNhRnZzZXg2eXBjdWRHbS80clJNNW1C?=
 =?utf-8?B?eDNmR0lvYVpQa1FsNTY0eFMwZGppVlZ1cng5cmpqZ1Y0eFVoYTNjMCtoV21u?=
 =?utf-8?B?c2xQVWYvMUpoMTVzRmxTNXUyV3I3K2g5WTJ2NUlUUTNpL2lUczVOZmU3T2Q4?=
 =?utf-8?B?TW5remJVb0Q2TUhweHV3SDR2OHlrNzB5ODJxSnJKZGp2UWJadmVLREJwZ2VV?=
 =?utf-8?B?M1djUk8yMGJQaGNnMmVSdFJoNFo3d3VRSDdpTVdtWExDMkd0a1dGY2NRUVMv?=
 =?utf-8?B?VFFpSGtTQVgvbzMyVTRIVWZsUVZVVE9KbjhxUkN2Zlc0ckEyNEduZVJDaVM4?=
 =?utf-8?B?a3YzQWY0SHljSGxlMXpyWE5vUXliK0VTY1cyem5jMDB0cXZabU96RWtENDhE?=
 =?utf-8?B?ZWtia05KSDhIYlJXSDZUbWNMcS9TU2pNSERFZDF3d2JrS0RReE10cmY3WDha?=
 =?utf-8?B?Q3A0M0VJOFN5M1NVaDZkNnpHZVZaTE1nYjNHMWZ2amJmOVFFaHFmdERBZ3ow?=
 =?utf-8?B?cUFiR0gwTmYyV3l1K3E0T2ZXMVdEMlVQK0JqOHp3NXJzb05oSzFFS2JVbVo1?=
 =?utf-8?Q?0nFtVCgLq0Khk26YK3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebfb2132-5502-40d2-9f1a-08df12074d7e
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 02:24:28.5141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I20d4jRgRAZMfTWsr85Dx7FEo4nNa9qvZROXBVqxuDxIuxKWE5ooHeBlOJ5+myid
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6486
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EF91E180002
X-Stat-Signature: 8tkxnhokh8zcyofwpbk9z7d8d3sks64a
X-Rspam-User: 
X-HE-Tag: 1789352685-409478
X-HE-Meta: U2FsdGVkX1/7upbFq+ex7lJ4FkAynqbZ+p5frgKTTBvr+MYjgxKvrf1zF/YK2dygGBuUwj7E/n+n5JMWoQ+9ApgRae3Sf74EVAknsuBQ/OCvS9WzP6dj1ZhmIYmr0LDaRouznCrncUUVLld7s9l9Ce2Q1/U8lJLI+t1tpEnJOWWvEMuSTQv2xN/4CGEdhLAxz/LjypAM87wQMmJ+YYWxuFH2ybIcIvGL1zs+jMHCqzfgSWe9X1YXOoivl/RWVLifipx9Lm8eUXouNhCcQExdQI2KItQhSvPrzo1hfMkQ2y1WMgofqzGJW8eYnCXY+/uGZCrD6CBlXQjA7OgvDzO/obtX7VJ0bfpvTUl7qHEqFh3M0+7wUgZZ0YzZu4oY3Kav2M8zbMiqDu4SnsBl0tzBnqA2Tnn7soj3DJjbh0880bJ1L4nyKEV+3Ik0uISeGZbNGTk6Oix6+I3VbouW4SbncZ/Zlz08CCAOMSfFWieqPNo0DCe5ftDB8DDqPItdNkaSMK9fyLkNuEjoUBu7BaPcP5PLbKGbiJK7pKlphBU814KBFIV4gNTtF5sxi/rzdLCbO2VTIZDxW+K9i+H+kCs+BRSKIKTP9KjhG+y1tqSWsQH2rh2ARs2XqoCL1mpiT5eu5mDJISEN6rzwKCDeOusMr6UjkB1p/BblRbs/goAM2Hj0t4LNQticofxOqTJwU0Z5BgsdkV8CWQJUv+MoNsuTHviTtDN+ulOezlPt/dHDuwh9ArMmWYx2d2Sa7WMKHMoTQg49384/ftO2mp7BKqrKErv4UjNfVxv6+RC4vFb683TZ7mfLbc03EtXI0jfmT8UQ/RjlOWPvp6CVbh4qXEo8XLKCMgaJ4a+cn+U7YOKuUysgIK+7DFW6w1zQBQ2NPMvfLqHnwoJ1jMlWeA4QQ1ndijpX9qIlMb1njBgNEdhmeKOOv+GsAqPt7lp6l7lYAm7Zs5pgzGGCwQjGeRHGf1g
 nSxNuJlW
 CUURQBwAyaP+x1EMTz+w3FpH4Vg4aJIoVxsb4bAFQomyoIzRqykihQHAohGx0kv3YlKre6D8LiCFI+mJVSSKq9obyeJcatSX2RMeQcenEN21GYD0RFTY2GFXSjv3lVdXUZJMcWixsmWSWmpEQ6h0eLrB8Yb9TJHrqe0tb8SGIadFeiDKirBD2Cae6oJYEXT/a/HkRSnxSDLK3e2p8mvbQOBiHN7I0dCi9z4De5j2AZqSPsQIl00niOzxBt2uJ/YJgauQTK/a/wL6xf/dzq7nL36guw6dLU/IgnUD6eenNBpjlTciQB0K3LYQBwLXMiANF65lpO2A5LtIx9pt8yaEDLVYE9dnrQbCfB7xpJVpmp+ZMg8VAl69Bgc1N8rKWXTZ3AwjCMzdSWTU5+Y+ekASYhVBD52L1nmDnbB2w0K2b/iTXnLYOP29biMP0k4xY/Wj1QzTBBU2nts8aTQ7uNxNEpZlxt0xHDQuux+hiqb3URfIUtA9t39T7CAQKYk2tylq5rq9EBZHKNTEYZ6jrX4xV2mnbHY6dtMUw3LB3OsnewvQ3seI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Only two users (in md-bitmap) use page_buffer() and both can be converted
to use page_private(). Convert both and remove page_buffer().

Assisted-by: LLM
Signed-off-by: Zi Yan <ziy@nvidia.com>
To: Song Liu <song@kernel.org>
To: Yu Kuai <yukuai@fygo.io>
To: Jan Kara <jack@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Li Nan <magiclinan@didiglobal.com>
Cc: Xiao Ni <xiao@kernel.org>
Cc: linux-raid@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/md/md-bitmap.c      | 7 +++----
 include/linux/buffer_head.h | 6 ------
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 84122834b6108..7b706d3e54901 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -516,7 +516,7 @@ static void end_bitmap_write(struct bio *bio)
 
 static void write_file_page(struct bitmap *bitmap, struct page *page, int wait)
 {
-	struct buffer_head *bh = page_buffers(page);
+	struct buffer_head *bh = (struct buffer_head *)page_private(page);
 
 	while (bh && bh->b_blocknr) {
 		atomic_inc(&bitmap->pending_writes);
@@ -533,12 +533,11 @@ static void write_file_page(struct bitmap *bitmap, struct page *page, int wait)
 
 static void free_buffers(struct page *page)
 {
-	struct buffer_head *bh;
+	struct buffer_head *bh = (struct buffer_head *)page_private(page);
 
-	if (!page_private(page))
+	if (!bh)
 		return;
 
-	bh = page_buffers(page);
 	while (bh) {
 		struct buffer_head *next = bh->b_this_page;
 		free_buffer_head(bh);
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index fd2c7115c0542..e47fbd0387b69 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -175,12 +175,6 @@ static inline unsigned long bh_offset(const struct buffer_head *bh)
 	return (unsigned long)(bh)->b_data & (page_size(bh->b_page) - 1);
 }
 
-/* If we *know* page->private refers to buffer_heads */
-#define page_buffers(page)					\
-	({							\
-		BUG_ON(!PagePrivate(page));			\
-		((struct buffer_head *)page_private(page));	\
-	})
 #define folio_buffers(folio)		folio_get_private(folio)
 
 void buffer_check_dirty_writeback(struct folio *folio,

-- 
2.53.0


