Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC303CD37A7
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 12:35:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 318966B015D; Fri,  8 May 2026 08:35:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C93A6B015F; Fri,  8 May 2026 08:35:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 190AD6B0160; Fri,  8 May 2026 08:35:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 028E06B015D
	for <linux-mm@kvack.org>; Fri,  8 May 2026 08:34:59 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 96B1C8CEEF
	for <linux-mm@kvack.org>; Fri,  8 May 2026 12:34:59 +0000 (UTC)
X-FDA: 84744197118.23.8932835
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010016.outbound.protection.outlook.com [52.101.193.16])
	by imf13.hostedemail.com (Postfix) with ESMTP id B420E2000D
	for <linux-mm@kvack.org>; Fri,  8 May 2026 12:34:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=3LO2CRcx;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf13.hostedemail.com: domain of shivankg@amd.com designates 52.101.193.16 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778243696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lFC/Fx0XncQouS0ZwHWapaDWPe5xf7HPtcxCqfBd2q8=;
	b=aONtpI6FW1gB/SpjrAXB3rPqqSOG0APJeZD3BgJDFJUTXJacbDmrSih/LXfnRddKtdTZiw
	fbJE8Vvqd4hkYVXzvDTUMs909i27g0Ar+76H5Q6Myzd84+doLIKpE+P4xui1JsfGBW5Og0
	aStNNkGxkss0Szbdmk7LfDa7IeMQhd4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778243696; a=rsa-sha256;
	cv=pass;
	b=xjSyrtxIMUfjVfvXzZMJTiEWIO2b2QwLc2406YiS0mG16TSll8cJ4vzsOyaGEkJn7e8KL6
	lhyKomON8SzS9OCluvRSgx5Vp8WQztMrmkfQ7kZNO2UkUu8pw/nMAUXqWSgY4ZkgJlERzK
	ckHkb0cmRVOxwpLgSeG17B5jGtz317w=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=3LO2CRcx;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf13.hostedemail.com: domain of shivankg@amd.com designates 52.101.193.16 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SNHCSo4Hw7txq/kVEeQOBA9LTTlEmiU6ekYtEo5D0kqKqmdYB0gcFWjai/o5PvomjXt8ctBwFBrRrnp4c6Tqp1HnsdV4gJ+1eXcWiy0tZl41N3Q8nOYyQFlXUxOkVavHNuInQsOQuBGvAxTOwkBdZy8eyKFhwSfIPVTJ7VMpAqOyMNHAozR6Ne7nGW+PnuwT4fu5Lpe1YNDNMnwR6x4UuHF16m3/1EqtWVdrsfHfne0bBi8mHpNQqSewzuZwhBX2LpHRY9jU9+tXcmFrTN095NCDc4YoVyUFSBoygDj1pa6QwVaEGHlUuo/Wj1vZfT0MijPr5WbW0/indrQyvS3BdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lFC/Fx0XncQouS0ZwHWapaDWPe5xf7HPtcxCqfBd2q8=;
 b=bUG26dEIvBT6+zyZDuz5KJXhtah838Gnk95FHEVPL5GsWF/qlLgM60bQZ5TQW7y2Bw7uSgPmJgsmnvLxTRIr0BU2gWYCLXQLA5SLuJ6URc4DkBfmLT41QFG/T3Ugo48IaxmON4FdLOG4xrF4g9axomxnhHs77fgqLuhpz+y4z3C6BqEX8GhF6hmxBFy2I+Gf1x/ibVkg05yz1kw/QORmfhd8qIKa8ouXPC41kPyU7OaD7IGNSp/Xi33oRIbhVSDCbT/q8duEmfPLESq43yxW93adB6IJUMNoFXdEB6yiHjelCQT7tvXXG96CPefV+R4s43d/hdm1cT7kW0BoHjnzfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lFC/Fx0XncQouS0ZwHWapaDWPe5xf7HPtcxCqfBd2q8=;
 b=3LO2CRcxOaUQqlh90IlqerE5JkMFr7G7UCMLh3afzAGWNzGN9lQ9iofs+HwpXFrPC7e/qlXaYc5BP1ZkZztUbEHLpHnBSRQFD/8MEGxYITb0+rKP0QPnSsIoV7F0hQDQExjv3Nx+wWmqWR3QurIBoMI54bOYoyJJzHUQ9FzXn+U=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by BL3PR12MB6570.namprd12.prod.outlook.com (2603:10b6:208:38d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.20; Fri, 8 May
 2026 12:34:50 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%4]) with mapi id 15.20.9891.019; Fri, 8 May 2026
 12:34:49 +0000
Message-ID: <c4d00222-5caf-47bf-801c-ae1dd439ad0f@amd.com>
Date: Fri, 8 May 2026 18:04:34 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] Accelerate page migration with batch copying and
 hardware offload
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, kinseyho@google.com,
 weixugc@google.com, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, willy@infradead.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, apopple@nvidia.com, dave@stgolabs.net,
 Jonathan.Cameron@huawei.com, rkodsara@amd.com, vkoul@kernel.org,
 bharata@amd.com, sj@kernel.org, rientjes@google.com, xuezhengchu@huawei.com,
 yiannis@zptcorp.com, dave.hansen@intel.com, hannes@cmpxchg.org,
 jhubbard@nvidia.com, peterx@redhat.com, riel@surriel.com,
 shakeel.butt@linux.dev, stalexan@redhat.com, tj@kernel.org,
 nifan.cxl@gmail.com, jic23@kernel.org, aneesh.kumar@kernel.org,
 nathan.lynch@amd.com, Frank.li@nxp.com, djbw@kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260428155043.39251-2-shivankg@amd.com>
 <87zf2kvnqy.fsf@DESKTOP-5N7EMDA>
 <152b9b5d-67c8-4a13-b8a8-be576a16eb8f@amd.com>
 <87mryaqgwg.fsf@DESKTOP-5N7EMDA>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <87mryaqgwg.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN4P287CA0049.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:270::12) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|BL3PR12MB6570:EE_
X-MS-Office365-Filtering-Correlation-Id: 580bfb58-250f-463f-4ff1-08deacfe31a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	cYAAAv1W0XyRcEwZtA1spygY1QTas5CduF/pgp7JgsXTYBw6ST88m14rKxKHnuRs20QkjeVFKpQD3mT3AKGDsgQNvjWngLwsp/XY0z3AYkHy3CTb5KsvRjp4JgLHwie7h5XytSI7mGd2/KonSM7ZMKeBy6NNAFqtSF3fZ2SFGOrnS06i6YFK6VBMd0S+MTS7ONq8vzccfcKbPmrCwtnmeOEUkFJjk62S/GNyPHqlGJq4f7DzziEtxZdCCCI9MPEJs4DURUIStx2ILfUNQrLQKfgpIW7YG6Le6LIk1cqakxwInjC0uE+7JdZyHcRPY5hfQ6sAeBK1l767ZdME/cpd47CxqcEARxMRcPT2RVXHo+IIpTpY7ul7i5Sw1zZckiZpUqUZ/TuplO8qt/U1vjCrAmwTjrnrkVkGl0NSb4ZDyPBVUgtjTf/nkJeNp8r27rTp4pZPj/mfpqa98FuzolK2TFJ4WO85FfsT4aa08o9j1ZlOjgLMr3TRnEbTCqcMx5JB82/RK1qL0l/3Nj8jylPgNsZfDC6k/jHeqjzdSIP2yJtjj8e8N7kqu3tqAp5T7/W2L1HFMh5iA8H2InHCOjJdPrqfi2tePhuRR1QHMRHnUpbJtau/N4+Y17iCyWDwh/jkFUQ+FdThGlXZKYru1hCYBTf6FvyBo1miOLTFY7/I7C8lWLM+6lSNx67/cZMHeKiz
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VEQvWjM3NEtxckQreElVVUxxdVZ4SnllczdidlcwUDFQQzVIQ2JlV2s1UlZD?=
 =?utf-8?B?SDV2V21HdTFjckZrQyt6NnJqMzdUdk53Q1hrdVk5Nzlmb3F3a2FpK0M3cUl4?=
 =?utf-8?B?SDhXMFRMWDMzVFBqWUhhSDJrRVZSTENuZytNTmxCRG9ZMWJRUmh1UTc0a1BJ?=
 =?utf-8?B?b1JuNWVXME1qeUNCa1hkUnZBQVNCOEpvclh1TFZOVUI4SGpuaUprcXdiSHdw?=
 =?utf-8?B?SGF0VENLbFhSaHFMUEVOYWJ0MXdrL09MaktXQmVacG1JNDRqanZhVWYwd3Q4?=
 =?utf-8?B?WWJ4QlZhM0k5S1p2dXVtMHd5TjhKWlVZN3JKLzVHUWw2ZzJYUEs0ZHQwR0Zl?=
 =?utf-8?B?V3I0KzhVTjNKS3NINHRyVTNOdW54MzY1VE4vSERsUTBOaGJnblppby82THEy?=
 =?utf-8?B?a1pDMWRBK0pnaXZsWmVydkZCZW9WSDJxeUZuY3RhcC9SWERvdnpKblA2Z3Ju?=
 =?utf-8?B?ZnYvWVdDZ2g4enhVVkNGeVNHOFJnYy95aWRCU2EyRXU5b250V0hzUWFKeW5q?=
 =?utf-8?B?elpiM1Q1ODZoTWE0cytieDIyTmhWZXBqWnFTUEg5dVpyWUlXYjVJVkkrZkZH?=
 =?utf-8?B?YjhSYjN3UUY5Wm5DNmpKajJCV1pNUW9MZU9CSVBPQXNGZGxMeXBoTG8vMlda?=
 =?utf-8?B?eVhla3AvOWF3dlgrcFFucWNIejExZ2crQmx6bXFJK3Rid2tnemVXZWs3VzU1?=
 =?utf-8?B?TTEzdklGMVpWT3lBUVBWUmtULzlydnZRUmtyYitLem93WFJLMThCOURTSWpW?=
 =?utf-8?B?VmZEeWVKYkxCYVJ6VGREaC9QcmwrbEtrZ0orT2RqYURvU3RteGFTZU91aTZM?=
 =?utf-8?B?OE1uVlpIMHI5QXJxcjduVno5YU90eE84UHFrR0syY2kyczlqQmh1Y2J2RHlI?=
 =?utf-8?B?NlFobEoxZ2pmM2Z5RHRKVTVXV1l0M1BpTzJoS2hDK0RNVE1xazYvYUV1Tmlk?=
 =?utf-8?B?SXdHMmVqNFRMTjZhMm9rR3gxWUE3V3NnZnNhSGNaa0U0SUxRTUZNTTY3Ui9p?=
 =?utf-8?B?RnJZeDc1amNyTnpNUzRPbkt4WWRkN05WbnVZZm5QVThjZkkxSlNYOExKUGRi?=
 =?utf-8?B?WXNtYk11YmdNdWE4eTk3eklReW4rSlI4aUwvYmgxWTR5SzFOMkR2dnlSZ3Nl?=
 =?utf-8?B?bTNYVmg1czdIT25TaG43dDJwcWI0ZDAyZUpTYS9tb3NSL0xkazZoTVpxR0Vp?=
 =?utf-8?B?eGJKbTJhYlhxc1M5MUdrbVc0TmpBMkdYTWl6S2h3SWJyYTR1b3l6K2FTWmZr?=
 =?utf-8?B?d2F0bkFwcFRJOC9ISHVQUmtEcDZWVzgxSk1RZGo3L3BMdmRiQUhvSjg5Y1Zr?=
 =?utf-8?B?S0xDL0xTZGVUVG5Tc3QyUGt3eHZjMWo3ZXhleDBXUGdLempETVpVMmhjWlVE?=
 =?utf-8?B?S0RlUE5POGVmK1JFMHBvVjZuNDZ4elM4QkZqV1l3ekRJb3RybmJocDRCMkVp?=
 =?utf-8?B?aWRGVE5kazErQ0pleWtCOENrRGZKOTNpVlBlcnRPc3M2V2FkUXl6cGVwNjZ0?=
 =?utf-8?B?d1RvSVcvL24zbmRYczg5dmZUanpNMmpSOWlTNVZpWWQweUJvSjZqcXR5VGYw?=
 =?utf-8?B?VXg2dlBhdGlxM2pETVlHQ2plK0JkRUVnQjVEaURWYTdCZjFmZHhGRnVmSFY4?=
 =?utf-8?B?RW1tYjR5VW9TUlVtNDY3RnZxeFNlMkZEdDIzK2ZDS28wWFNlWlRlQlhuMEh3?=
 =?utf-8?B?OENrMFIrN3pYY24vVUt0VCtUazBPSHNXazM1amNrOGhLQjRJcmZKL3BGSmxU?=
 =?utf-8?B?RC9SckozekpjZEFneHRMc3JNZ3YyMEQ1bkRGcWYrcXRVakxYclI1eHBTYW5k?=
 =?utf-8?B?N3owTUx4QTUwWStwbVRsMVR5L1l3RllxRG0yMEgvYjVvc1pZaU5JcWFZWmJC?=
 =?utf-8?B?Q1JHWk93UEdORWhnMzgxVk81M1RsVTB1VE8rZEsxeGZwMWV0VEo4S2pzaXNX?=
 =?utf-8?B?QnY5Rmp3djhUSUF1TDYxbkFKa3JpMFZNTEk4cGxydTEzZmpNTDhtVVhqaXhj?=
 =?utf-8?B?ZWI1K0U4TXlVbFdXc2tYUlVEMUR1dTd3eThJOWgvTjRvbXNhMXJZUi9yWlk3?=
 =?utf-8?B?ZDExRm5GTWticTlXeE4rSUl4Tlh1WGNtMzcwd2FHRFNyankzcVVyOEd6Mmty?=
 =?utf-8?B?ZFlObER4RXBjOFB2VjN3ZStmWlZEdmdvVDFsREVkejduUlU1K1RKSVJ3SDRS?=
 =?utf-8?B?ZWszTFl4NVk3enQ4dkRyRFNMd0tnTStoekxaT1NZWmVUYVM4ZjYvUGZ2RWt0?=
 =?utf-8?B?TkVGdGQ5OCtNdlMwcEFxaTI2N3dnR1JWM2Qvd1FkMVB0QWdLV2tXaHpMZFFI?=
 =?utf-8?B?RXFqbkJaaThMdGIvdU5KL2YyQyt6ZFJndkhzSnlSWllEbU9JUVFMUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 580bfb58-250f-463f-4ff1-08deacfe31a1
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2026 12:34:48.9617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wU65P7ANOIZYWU01xLLQMqRLy5LlaFHAQXyvP/CHaRb2sscQqMePE7iHNeZE4g6BuRVf0BGSaAJWtzvfsR464g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6570
X-Rspam-User: 
X-Rspamd-Queue-Id: B420E2000D
X-Rspamd-Server: rspam04
X-Stat-Signature: ymi15dc8e7rhsabjc7nnfr5t6f1qw878
X-HE-Tag: 1778243696-618371
X-HE-Meta: U2FsdGVkX1+hFJbfXEX6s1IMYg7166THH2puitHATONUIRolJatEETWTMBj/gNiU1oZbFz+TrQ4ML0yfnhgfkfx5rQ7d9OyuyaorlbgB+Kx4dlHhRXKINMSTKXO0WXl4LkIWVkqNPVDOfaq+bqiUTUk5zIm1j0JzSNJEX4YSVOUUXOUmqlrpbeAARwNwKAJIPtqbrG0lS1RvUbSkqZoXhOQmistbdQVxq/24KSqbJQoOYwWeUTI8Gi7a8HfPmuWKOoIov9eaE37b4spY+BEDjdYRTTJRuIfupVRDIOX+BAT69GE+d+2GKhw9Bq1HPD3CuAhWY+YyIGqyEjXMmxNjMy3sCFSEDnFsWbqs0J+tVGFRdqZXveyOV03hnDlSK7jQDWrjVZIkowfePaVmHiZaKQ3M8AGbQcBhQmLUTG87CmO4+VUsRtmA8YjgdlWFR8K44JnGnhGTS+pMZuV55Fgs0nTWF9ucJw0/rhGS63X0KS8D4PkZu2pAlGAZ1T2Kfm9G5DRRJSA2dh7vXtvuCn/07UXWThNp9Ajb1AzsiRhRHfvIg4rV0HR/7UosEN/Vvhv52npZitnhvYFrhlt8f+fOWIXim2gPHNEWos1g1BDL9xyfOGqIfU0fOGWiiI9/izB3X+PRBrQbrvV3otEkglojvI+z7H+1JRZUhz6H2fPZ7sa0pt1kNyEibdQOeOwIs84cXkzpDrqkpKI5ab6GkNjk4MVqW7146rNsb4awqX4V6RnAvcAWkwqHo+IlpdLe0tq+RPlvHKsTwAjeyxH2kdBj/lgbO7VgYAfmPBPkUzvH0ODLDGO+YU0SzvqhN752c0ZoL0o2YNV75+zYLpWXagdZGmveKrKVZti5HnDdFRjUljmpDnlEOWE5Gw84x0uUcUWBg+1P9V3WuET2L8BdIaiekIUbZt8ghvaNhedVAc616bljUYrLVmqV+p+lJOXatvrsLpaJBNYova6B3P/C+Rn
 OiLVFn7r
 BasVnNTC7VfzJ6OENiI4IPbu5r2YyLA14wq84K+X51FPmqrlCGQSWQtguLys5/UNsEmHHsDEudwmBpwWfyabUZAMb5m9fk0qaonQ1+vmptGjMVGIziZzAXfL4j6LTwnw45Jru3LAbkw9zsK17LrPoaSRdYj9PI1dkz3VjA5y6isFvyw4hOcqyL051oFWsgyHBDbgx4oPRf1A0BTJQYaZZIlXmRNpwnupMQKLcbyV7NUgqFtaeTARGC12hSR1jPUBc52788syEgNyGP2LJq3U7+6AMofE5RKmTmE7F7nSQ8GgHaRf6mCzZGv5bN+2o0W/uR4Ob5Q13xVxcpeBAzmAmcBAkO/hUqzrjo+lSM/J/YrDqmnw47JTzvrjMMAolITCQvsYY7smMsGUpbdQq4yXTR2hN2wU/ZZpU01/dwIrl8DPWjUjbZCgOCRH9iGPT7EbC1TGWwGWh6y577vcmwNMSL5vwARHcmOZUWIBs66H4uqsEM3SkQ8hWIfqbQ6XxOMpIX7PL8/GMMMwBw12FVU3cnAAW3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/8/2026 4:58 PM, Huang, Ying wrote:
> Hi, Shivank,
> 
> "Garg, Shivank" <shivankg@amd.com> writes:
> 
>> On 4/30/2026 2:17 PM, Huang, Ying wrote:
>>> Shivank Garg <shivankg@amd.com> writes:
>>
>>>> PERFORMANCE RESULTS:
>>>> --------------------
>>>>
>>>> Re-ran the V4 workload on v7.1-rc1 with this series; relative
>>>> speedups match V4 (~6x for 2MB folios at 16 DMA channels). No design
>>>> change in V5 alters this picture; please refer to the V4 cover letter
>>>> for the throughput tables [1].
>>>
>>> IMHO, it's better to copy performance data here.
>>>
>>> In addition to the performance benefit, I want to know the downside as
>>> well.  For example, the migration latency of the first folio may be
>>> longer.  If so, by how much?  Can you measure the batch number vs. total
>>> migration time (benefit) and first folio migration time (downside)?
>>> That can be used to determine the optimal batch number.
>>>
>>
>> System Info: AMD Zen 3 EPYC server (2-sockets, 32 cores, SMT Enabled),
>> 1 NUMA node per socket, v7.1-rc1, DVFS set to Performance, PTDMA hardware.
>>
>> Benchmark: move_pages() syscall to move pages between two NUMA nodes.
>>
>> 1). Moving different sized folios such that total transfer size is constant
>> (1GB), with different number of DMA channels. Throughput in GB/s.
>>
>> a. Baseline (vanilla kernel, single-threaded, serial folio_copy):
>>
>> ================================================================================
>> 4K          | 16K        | 64K        | 256K       | 1M          | 2M          |
>> ================================================================================
>> 3.31±0.18   | 5.61±0.07  | 6.66±0.03  | 7.01±0.03  | 7.13±0.08   | 11.02±0.17  |
>>
>>
>> b. DMA offload (Patched Kernel, dcbm driver, N DMA channels):
>>
>> ============================================================================================
>> N channel| 4K        | 16K         | 64K         | 256K        | 1M          | 2M          |
>> ============================================================================================
>> 1      | 2.16±0.14   | 2.58±0.02   | 3.00±0.04   | 4.56±0.28   | 4.62±0.02   | 12.65±0.08  |
>> 2      | 2.68±0.09   | 3.69±0.15   | 4.52±0.04   | 6.75±0.06   | 7.19±0.19   | 14.38±0.06  |
>> 4      | 3.07±0.13   | 4.62±0.09   | 6.47±0.56   | 9.22±0.15   | 10.24±0.47  | 27.01±0.11  |
>> 8      | 3.43±0.09   | 5.40±0.16   | 7.67±0.08   | 11.25±0.17  | 12.60±0.60  | 45.62±0.52  |
>> 12     | 3.50±0.11   | 5.66±0.16   | 8.12±0.10   | 11.97±0.19  | 13.43±0.08  | 61.02±0.92  |
>> 16     | 3.54±0.12   | 5.79±0.14   | 8.50±0.13   | 12.59±0.15  | 17.21±6.40  | 65.23±1.70  |
>>
>>
>> 2).  First-folio latency: Instrumented with custom tracepoints to measure latency per migrate_pages_batch() call.
>>     Result: throughput (GB/s) and first-folio latency (in microseconds), median of 10 runs.
> 
> Thanks for detailed data.  Per my understanding, the run time of
> migrate_pages_batch() may be not good enough for measuring first folio
> latency.  IIUC, the migration procedure is something like,
> 
>   for each folio
>         unmap
>   flush
>   for each folio
>         copy
>         remap ===> first folio migrated
> 
> Some tracepoint should be better to measure it.

Sorry, my earlier write-up was unclear.
For first folio latency, I add two tracepoints: one at the start of migrate_pages_batch()
and one in migrate_folio_done(). 

I agree that the user-accessible point tracepoint should be right after remove_migration_ptes().
Though, migrate_folio_done() runs only a few operations later, and will have a constant
offset, so it's unlikely to change the shape of the trade-off curve.
I'll move the tracepoint right after remove_migration_ptes() for new posting.

> 
>> A). Vanilla Kernel:
>>
>> Here, n = workload size passed to move_pages() in folios. Move n number of folios with move_pages().
>> NR_MAX_BATCHED_MIGRATION is upstream default value 512.
>>
>> --- Order 0 (4K folios) ---
>>      n      vanilla/cpu
>> (folios)    GB/s | first(us)
>> --------------------------
>>      1       0.04 |     24
>>      4       0.16 |     25
>>      8       0.29 |     31
>>     16       0.54 |     27
>>     64       1.15 |     68
>>    256       1.86 |    162
>>    512       2.21 |    264
>>   2048       2.62 |    208
>>   4096       2.74 |    182
>>  16384       2.73 |    173
>>  65536       3.28 |    166
>> 262144       3.20 |    167
>>
>> --- Order 9 (2M folios) ---
>>      n      vanilla/cpu
>> (folios)    GB/s | first(us)
>> --------------------------
>>      1       7.05 |    194
>>      4       8.78 |    186
>>      8       8.47 |    188
>>     16       7.20 |    193
>>     64       8.23 |    191
>>    256      10.51 |    180
>>    512      10.88 |    173
>>
>> Takeaway:
>> In each migrate_pages_batch() call, folios are first unmapped, then try_to_unmap_flush(),
>> and only then folios enter move_to_new_folio(). So first-folio latency is bounded by the
>> per-batch unmap+flush cost, and then plateaus once workload is large enough.
>>
>>
>> B). Patched kernel:
>>
>> Here, N = NR_MAX_BATCHED_MIGRATION (in page). Total migrated data is fixed at 1 GB.
> 
> Emm, so NR_MAX_BATCHED_MIGRATION could be very large?  I think that it
> needs to be bounded.  If it is too large, too many pages may be in an
> inaccessible state for a longer time.  That will hurt the workload
> performance, although it is optimal for migration performance.
> 

Agreed, it must be bounded.

>> Change N with a knob to measure impact of different max batched size.
>>
>> --- ORDER 0 (4K folios) ---
>>      N         offload/dma1          offload/dma4          offload/dma16
>>                GB/s | first(us)      GB/s | first(us)      GB/s | first(us)
>> ------------------------------------------------------------------------
>>    512         2.13 |    639         3.23 |    290         3.27 |    253
>>   1024         2.17 |   1261         3.44 |    582         3.58 |    536
>>   2048         2.01 |   2769         3.09 |   1360         3.45 |   1083
>>   4096         2.10 |   5059         3.13 |   2737         3.58 |   2115 
>>   8192         2.21 |   9320         3.17 |   5015         3.75 |   3617 
>>  16384         2.15 |  18689         3.31 |   9623         3.87 |   6937
>>  32768         2.12 |  42692         3.38 |  18893         3.83 |  14255
>>  65536         2.09 |  81956         3.38 |  38556         3.64 |  29003
>> 131072         2.02 | 169563         3.22 |  81082         3.63 |  62236
>> 262144         2.21 | 318424         3.12 | 170174         3.50 | 129413
>>
>> --- ORDER 9 (2M folios) ---
>>      N         offload/dma1          offload/dma4          offload/dma16
>>                GB/s | first(us)      GB/s | first(us)      GB/s | first(us)
>> -------------------------------------------------------------------------
>>    512         11.66 |    160        11.68 |    160        11.65 |    160
>>   1024         12.16 |    310        13.67 |    275        13.64 |    276
>>   2048         12.30 |    613        25.47 |    290        25.48 |    291
>>   4096         12.48 |   1215        26.19 |    566        42.59 |    335
>>   8192         12.56 |   2424        26.57 |   1118        58.72 |    470 *
>>  16384         12.61 |   4839        26.77 |   2218        61.94 |    896
>>  32768         12.60 |   9667        26.98 |   4422        63.75 |   1748
>>  65536         12.63 |  19318        26.99 |   8838        60.66 |   3543
>> 131072         12.64 |  38935        27.02 |  17935        61.06 |   7178
>> 262144         12.66 |  77694        26.85 |  35871        65.06 |  14129
>>
>> In the batch-copy offload approach, DMA copy phase is inserted between unmap/flush and move,
>> So larger N increases first-folio wall clock latency. Throughput improves but with diminishing
>> returns.
>>
>> For DCBM+PTDMA setup, the optimal batch for 2M folios sits around N=8192-16384,
>> because a larger batch allows the driver to distribute more folios across available DMA channels.
>> This is where we get most throughput while keeping the first folio latency in check.
>>
>> This optimal batch value is hardware-specific. Other engines (eg. SDXI) and memory tier (eg. CXL)
>> will likely have different curves.
>>
>> Does this approach and experiment look good to you?
> 
> ---
> Best Regards,
> Huang, Ying


