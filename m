Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7522FCD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:24:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC8096B00EA; Wed, 20 May 2026 11:24:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9F7F6B00F5; Wed, 20 May 2026 11:24:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8E4F6B00F6; Wed, 20 May 2026 11:24:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B79FA6B00EA
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:24:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8FD614032C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:24:08 +0000 (UTC)
X-FDA: 84788168976.17.0BDF2A9
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010043.outbound.protection.outlook.com [52.101.56.43])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8F97018000C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:24:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=GYdeLWt3;
	spf=pass (imf06.hostedemail.com: domain of shivankg@amd.com designates 52.101.56.43 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779290645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Md8FMSdpLhIH12XXHeJME+HIXzKZJk/4yWzwuNdiQ6A=;
	b=q3UCGkIyWTbjNbe6xbG7lp3fGjiAS7TRX3AxRaz4F3P6mFyrGarBizQfA8cQ7Bih9wXPTJ
	Avvm0qaRoAPjG07nc549ogFHigl23MEDSKfRhkuciK5pkzKj5ODZMIwzLnX+VJgAqiugI6
	zjpL3Ab1UvKvC/O52F5MNTHTJBx9ycE=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=GYdeLWt3;
	spf=pass (imf06.hostedemail.com: domain of shivankg@amd.com designates 52.101.56.43 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779290645; a=rsa-sha256;
	cv=fail;
	b=jpRSut0k3JmpUPj0wtcBWruzM3j73qqRyjSzWqrEWtiqi3/UrNHF5Z3j5XiYmketJkC/OJ
	OBrL2ZVK4/HhtbnnFxoIpf4TthCNVd3NMCHUwGJXlu/VLF+O4aQ/PxAnxoYsRwKqUF+sDY
	sw964ufpZdUrwy0H9JSlC64StTmQBrI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e8ms2tDO7qPBK1Le0Ask06cGLaGrdb+c6F3rHEPht2MtWTDm87uCtNVZYlvqNTTuq70DNr9DfIM2pHo6Yb2Vr5bMvbFGopBqcBArwVWz2YrqiJ7k6Z8QgSYnfpnk+4Rp2uokzXXagmekpMQOzDvHZUfy8G4L/Le8tq1zeI/lzSs+zCpYpX3uGHbzfID6cs+s5YWnLCKQngz166XbihTAU7RDrL4HltSXuQW11X7hYJwFunv7Et4i+JzGLfKdBaZEo2wDAvFL6MePZdwtu8u82gRB/xWm6eXawKco3dfsILzeUEsqPbA3WmAdIhFtGT50ZzbHXqFcSRxhb9O06WS7Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Md8FMSdpLhIH12XXHeJME+HIXzKZJk/4yWzwuNdiQ6A=;
 b=XfGWHMogR6eSQ7yOClR265IJ7n5AdaO3HqxyoouCJuXnBkBlPNhcM08J3kgdg3gJdY6UcxU+G245Uaqi6ibK0EOMYkrGsV/yhrCTY8YW5JhP6QMGTv7RfJkfPDgTN5DLx5gi3SJk10wj1zpvudR4hy6wk2WVVYD6KZaLavmKLJO5ZhZ5hY/j/r9uTeBHdJdswoIPcY3ndkQ5qPE0PR9Av3MnjePgTPgaZPdTx8gRAhVM3jh5wU21VM+3ufEi+tCtQozLs7u0SZ/MH4Vo8DGIfiDGFAeubL2eZpzdJS6TTAYYVwy3aSdjuqlYkxouqPXlUedTJP5R0HRLFgZ7Wn2B5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Md8FMSdpLhIH12XXHeJME+HIXzKZJk/4yWzwuNdiQ6A=;
 b=GYdeLWt3YtB0H30lFuc2MC0Oi+hWYb+4s+aoKsMD2MEOL53qQQGq9Y+alJzRWUsW0+5SGjngiCDZkoAdVP4DhX6b4euVIAsCbQooJ95jTUidp5WxKoFBnT7v7mUz8Kzc+u3w9G51SHSV0tQVESr+6Ma5E6UwvPHzU0TuC1PIb58=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by SJ1PR12MB6171.namprd12.prod.outlook.com (2603:10b6:a03:45a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Wed, 20 May
 2026 15:23:54 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%4]) with mapi id 15.21.0048.016; Wed, 20 May 2026
 15:23:54 +0000
Message-ID: <1302e988-df0c-48fc-952b-71e3af230659@amd.com>
Date: Wed, 20 May 2026 20:53:40 +0530
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
 <c4d00222-5caf-47bf-801c-ae1dd439ad0f@amd.com>
 <87cxz5rpi3.fsf@DESKTOP-5N7EMDA>
 <22157c87-1465-46de-8e1c-5d99a90152a6@amd.com>
 <87a4u5weyo.fsf@DESKTOP-5N7EMDA>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <87a4u5weyo.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0117.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:2b0::11) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|SJ1PR12MB6171:EE_
X-MS-Office365-Filtering-Correlation-Id: 368bab30-9720-4bbf-f79f-08deb683ce0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|56012099003|22082099003|18002099003|11063799006|6133799003|4143699003;
X-Microsoft-Antispam-Message-Info:
	bZ3Gx/aRJdgyqaS0Nhw7rm26cubNJ137wp1TLVEcGGqJ1dtW7rF8qgZZl1GgJ2BXdHbHgCznq3J5QPTnQ54SZEkFDoHYQ9l8Qr0Q6+n405K8Tl6nH+tWDasuqrlm9qhvpMB/iiuf6WCazcBgTEgltwuB3G01hdGQW1SrmDkx1htozbzxmgWfg2TUdgPA55OI/GCg2xxoqmiM/nlLldm7o+q3kHbzoJxDarOm8CG9dcPuul9P5qKdEsQWdwp04Nj/CI2XC19gI5Y/SKn3QRfBYKN+Z7d2ZqvX3bHEhcfHhqVBBFPj+fFTGDuvRbvjtAmHXm8xN6au9+m7FlHEMA3LHUXf7+Adw5WlyMDzVXF5tJ6DsCaI1xwiCxyT/z7DFZhehOQDmTVmU3H/lLxhh9ietpMWvv0jvHJRXrEGtcRCa6sRjQMwBDRcTB1z6jzjp3vNGt5lGje8p54Ph/l4ytUvZRUXcgVJfEoqpJqkvKnowIcx4QC5i3cAbEXGm91hjZ3clAluqmvD8PkvJs7OB3YGpZJWiUu0gZzDXRc99ygg7r+xY1kDNAu5t7AWfsMkzuW2/n1rbsj5RQi72aqD9SzXRFej7+rsoYGVNM5eIlFuqlH1fMDVYlE/NebM6NN8t5hDST3PmP01zChogMR6fxVAmMuQmxSuXGdnClChHC66vmfAgbf96luH7dEO+mo0LcYq
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(56012099003)(22082099003)(18002099003)(11063799006)(6133799003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bmhhb2RkOTF0U2x5ZkcyRXJjV0pid0JyZ3hDV2dTOTEzd2piSkZTZmhMQ1J4?=
 =?utf-8?B?RjEzWWlRLyt0T1R1TkQ2L3RzclNPbSt4TWE5UGM5U3dXNjU5UzNMSWFsaVFo?=
 =?utf-8?B?VTdab2trR1BrSitYSmw3TlgzSk9WZW5BdXhKQjB0UlZZOW1ZY0J2Y2dLUGQ5?=
 =?utf-8?B?TWRyV29jSnBTeHovV0VUNFdmQVdkbjRMZDVTa0FaNlZWRHVOMzJvVFBVcmpB?=
 =?utf-8?B?NTBxNHpKTkJOeEthN0I0QlB5dFNKV0MxUEI0Vy9yQUI5dFB2Lys2SkNKNDdC?=
 =?utf-8?B?Zm5pSGRBa2tXL1ltMERFREhleFRaZDRCb2xwaHJ6U1JQMUVnS3hpK0hJaDVK?=
 =?utf-8?B?UFVQVGpPZDVVNEdCcEZsam5nTnd0a3MwVjI2K0hxbVVEcld2MlQ0TkpJQ2R1?=
 =?utf-8?B?NlR4Zmx0RTRVM1N4MDUwSUpWbUZPdWN2a0Z1dEVCbGw4WWh0KzBZdldlNWw0?=
 =?utf-8?B?elFnMUQ2RzZpVWgxNXZLYmJJdnpUZHlvT2tySWhpbTNySjl6cDJOVUFPUUpw?=
 =?utf-8?B?SlJxcnQ5Z2FQbWtKQUVjZWhrRDJRU3ZNRTVUZUljZER1SjNBNlQzRmc4cWU1?=
 =?utf-8?B?SGw4VXp4VHlldzN1TkltREhOVFFzT2J1eTRJV2lLTlkxWW1vbldGWmRkRU5O?=
 =?utf-8?B?d0M1TlBKaXZPOU5MTFExS0tVdEVxTG45THREZEV3RkpFa09tNTZIeXFjWVZU?=
 =?utf-8?B?NFFUM20zalQrc2NiVDJ2ejhxazhXKzNoTjF4Q3VIUkRzQU1Md0w2Yk9zZVlR?=
 =?utf-8?B?WE9DMGZtbFZrSG1Qd00yZSttNVBEYmV4SUg4Mmk4M0lkRFh1LzJ5YXg1YXQ1?=
 =?utf-8?B?QTkzL0dpNEdZa1ZOcXRnL0FtUG5ESC9nazJxZURDTEhoa2dwa2Vld2hMZ0tr?=
 =?utf-8?B?dTlJa3pPeFdNOTlSUDlsT21jVUFIQVZQWGx2WURFNU1DVE4zT2djYko3WFkv?=
 =?utf-8?B?V1d5WkhXNEtUaTlpdWh6eHBMU1ZOSnZQcTMwbTZYeUVtUktsaUpUWDRqRjQw?=
 =?utf-8?B?QndOUW5DUHBhWWM1eGhXNUFDM0tiZmdtdlRWSUliZFIyREVpL2pIOEw1MUFL?=
 =?utf-8?B?ZGhJR2tIc2FqdVArT3RMTURLaWZWTFFicktPSW9PZ1JwNk55R0RlVGhFbE40?=
 =?utf-8?B?T1ZJT29SOTlQZkMwZjJUSGtMelk1TUs0YXo5T2o0bGl4U1Axb2txbnJLL0ZN?=
 =?utf-8?B?NWVEelVWZHVnME1oMDdZeHEzK3Nhdk92U0swalhGcWpFMXIrcEhtSzNwZjFq?=
 =?utf-8?B?TW1VL0wyaXZFL3dtdWE4UXI3VFhlZDVlbFVOUjZxWlZkeEFnbXpoWCtBVnB0?=
 =?utf-8?B?SFJCTlA0K2ROaU5zcVpPMFdscGZlRC9tanFLMWJhUXlzUW03Z1lTNjMrQVJP?=
 =?utf-8?B?WXdTUlBlTCt4NXE2UHNLdzJROWtnSjZUZ0VYV2Rldm5STHNNVDR6T0ExQVJM?=
 =?utf-8?B?MUgwZi9oRU5DQUE3ZUNhQnB0bitZVHFqeElMSUUzL3g3Mkd1K2taS3psbnhL?=
 =?utf-8?B?enJqbTRQYTdtWW5nczBOYzBoREJ5Sk5ZV0tSVlNSTCs2SUgyQ2p5eFhGUnF3?=
 =?utf-8?B?eFdFZUt2YVBnRnZWTXJBRGgwMk5PNXd3UVNDT203eGF0Q3pWeDFtUUdBc2di?=
 =?utf-8?B?U2F3cWRYTm9lTWE2S2tHR0o2dlpibzNlSm0xQk9CZE9rNWVmbXlIZmdFb0Mw?=
 =?utf-8?B?MnVkVkRjWEozREJEODNzblVMN1FKd2JIcmpES2xKUTU0dnFPNzIwZm9ZOHY1?=
 =?utf-8?B?WFRDTGx2Vzh0bEI4VWhxZ0Fqdno3dDJKejR2VHJqUFROaDlvdWloaWQ5NzZD?=
 =?utf-8?B?MlFXR0JxQVZjdWgyZ1A3cW00YW9qYlhiNWFibmhMZ0F2b1d0K1FqNmMyak5O?=
 =?utf-8?B?d3hua0IyaGRabjFVaG9hbEVxQ01xUmlCQ1lsZThzLzdHd29mWVpjZ1FaZE9i?=
 =?utf-8?B?akJLM1oxLzllbHJtUkM1WkRZei92Yjk3Q3lFUnJNQ0VLTmhncldLV3FZZ1Bz?=
 =?utf-8?B?NTVRa24zZmg4d280YmhUanBDQ05RaG5ReWJlUlBBeGkwQnpZYjlKTk81SWRB?=
 =?utf-8?B?RW4waERmWVgyZWM4K1VkWlFRVEc1N1c2Qis5UjJsbkxuVHZoc3BTeWc1UTJq?=
 =?utf-8?B?bC9vUGtObVJKNzRIOG9WVmxxUmdzeFBRMXlWM3pVTktSWE5vZU5zMURzNEd2?=
 =?utf-8?B?UGYyUFJONnMvZmNYMFVqSXkwMGowNzlJVU9RaklOdVRPazJiTWZVd2hUWTdy?=
 =?utf-8?B?WVA1VnI2Ykh4amFiMjJYSEZHK0RLSVA5NzVwQzB0djNadlBCeXF0dm15Rmxx?=
 =?utf-8?B?Z24rZXlaWXFjQ250NXJ4bWNzcmhNSE55ZzJCOHRkNUJOU3VIOHJFUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 368bab30-9720-4bbf-f79f-08deb683ce0a
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2026 15:23:54.7885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: teARA8SX2kPfP98fLEqJCTE6PFkLsP90JeX7rZkaSi1+TLwlP8K7IM+kPWFmG6nreqaI3Sb23FPtLFhAvtR/wA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6171
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8F97018000C
X-Rspam-User: 
X-Stat-Signature: esc341ezw5qy8aj8q7dp88jggtxud3e9
X-HE-Tag: 1779290645-889555
X-HE-Meta: U2FsdGVkX1+WxCLgtG3kPlclwehUwyp2lLCE8aSPOueEhayNt4dAYEQ/iNKEDFGCsJ9NGNLvySYzCwqm5IvgBmZ4TMvW0T53e0yLKmW/0fkuCOfTTbXiIgLOiRHJc9Glgde6QyQbGWeCUfpIT+Jlc04q1DS8ml1CvyyZ7l9THxTL519TiugeXBpRpu9+t9nFnvDvQUJ40uOSyq53L9fbiwJH5kX7NzIb5LIzdkNiJ5ezsU0QBpAKJ4IZS6yJpzcGZSd2hXt8AkGvo+YCnf53VotH0IHffsTluikW9144jenzR3a23x8HR30NTdvBj6sQOavZ4cIOr2j3RXZbP0lwtwbB2lo+o5aewTwdv31VRoUKZ682zJHeotty0Ai2ixc4walwYV9CNocIlluKzfDEKYSVvSR8IA3orB5KECObpdkQwzATylkMx1EGvca1JzU34DxhWeG+TmFq18gwI1DmMQa0xdYy/eJ8Fvgj90iRH/iCCk6bZorRUcCnufu8qqvXNPMZDgcL+pTqjiWufqT+haGV9riU/YDBcg3AMcCMgv0qXaAQ8kJ3AKHPFEcbZxwY6DPuqjhXex+EDrPNzK4Ouw0opkoUMrOGInJpgElxZSxqM+ILzzWuuoS2mY+2M8BU2k7+ZJXcvlJl8tqDDywpYHdutIOJ7OMF9WP7wCiCBOOfAayHRqif60Cryb9nMk+lVEl8dhPwX3m/EMcNvegRKJTNxi5lLj4KXqCGzqCeb/2BA7F+zXaqDqDFI1MZ+CaX9W2wboaRQISgUnEMEYTXgqENeG4ACplozIEVZ12TnKDn/4yCF1p6cUPYhvYAVJsfpr/njjorcnIimFBUdKiCsIA9oEKcG2yfvhMu1XgMLfx9GAYoKRrBTtuosoxUuZqnA9vg2ibzDWNUoZ8n6OQy35cxknWwxnsvSNO+T/slIZQ5iPTdoJ5KkRDLe9mrnSzk6g3Z5LiofzR5/IkHC3r
 NgGil8z4
 enks1JsWioDzBfHPDf8xbiLZaw6wUSFCH62vMrFf3wtEt8+//B/CstDaBTAbmktBYvfffmGC9meCaDfyOwAmcvwGDNnb25uVXLIDgR+DXKSd1O/abQKsq19RX0V/LDjKwk0flq4ZuXdibdW/qeV3iMrXZX2TeSX+EiIr5NKe+b6Z+949Iq0ApjvOFDFaluPAcwYFnPMy1cA34bo97v8A+Eshy7SadM8AJwwZfAbPSG0pqpSz23rWIVmGXoHphoz0v1jX2CZ4BoIT69wcMNyiQpNwAQ4sxDwyRu80Gouih5EEY80AF9nQ1bCEM1zq/Ay8XlexegEmFXUHC0pszRbFbM7RW61xDcRTg3S43jr8XOnAivmfahzDGII/bouMdCIjYfwM+vce+95j3HpAmZhDIXgFIWTzJKBmsbenIdOm1+TTXnv330AugYlBCcVbIVHULpaybXoMcgQOoOJ79Z+iht5f/KGaXkzM9Kytz4cvF+Zl1lgoUbLwgY++aA4MBp8sfS5wE7APnj6CJGVBVqWZa/Sb2qEIqm7C9CHBe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/12/2026 7:45 AM, Huang, Ying wrote:
> "Garg, Shivank" <shivankg@amd.com> writes:
> 
>> On 5/9/2026 1:19 PM, Huang, Ying wrote:
>>> "Garg, Shivank" <shivankg@amd.com> writes:
>>>
>>>> On 5/8/2026 4:58 PM, Huang, Ying wrote:
>>>>> Hi, Shivank,
>>>>>
>>>>> "Garg, Shivank" <shivankg@amd.com> writes:
>>>>>
>>>>>> On 4/30/2026 2:17 PM, Huang, Ying wrote:
>>>>>>> Shivank Garg <shivankg@amd.com> writes:
>>>>>>


>> Thanks. Below tables sweep NR_MAX_BATCHED_MIGRATION from 512 up to 262144. On 2M folios,
>> 16-channel PTDMA, the knee is at N=8192-16384 (= {16 to 32} * 512 ).
>>
>>>>>>   8192         12.56 |   2424        26.57 |   1118        58.72 |    470 *
> 
>         2048         12.30 |    613        25.47 |    290        25.48 |    291
> 
> IIUC, N=2048 already helps dma4.  And, the latency looks OK too.  The
> good batch size is hardware configuration dependent too?  If so, we may
> need to add another migrator callback for that.

Yeah, right. 

>> One thing worth flagging on the "bounded default": at the upstream cap of 512 pages,
>> migrate_pages_batch() receives at most one 2M folio per call, so PTDMA can only use
>> one of its 16 channels per batch and the offload reduces to vanilla. (DCBM offloads
>> one 2M folio to each channel).
>> The larger-N rows are what exercise the channel parallelism for PTDMA case.
>>
>> "SDXI"[1] like memory-to-memory data movers should reach good throughput with just 1 channel, 
>> and thus may not require increasing the NR_MAX_BATCHED_MIGRATION for good throughput.
>>
>> I'm not tying series this to specific perf default for now, the design review (batch-copy
>> path, migrator interface, registration, static_call dispatch) is the part I'd like to converge
>> on first, then tune the threshold after it. Does that ordering work?
> 
> IMHO, we need some performance data to justify the added complexity.
> So, threshold tuning isn't the goal, whether we can get better
> throughput with some bounded latency is.
> 

Fair point. 

As you pointed PTDMA-4chan gives both tput and inaccessible time improvement.
PTDMA 16-chan could be preferred by some who value throuhgput more.
And this is different for different hardware. So, I think another callback for
this sounds like good idea.

Thanks,
Shivank



