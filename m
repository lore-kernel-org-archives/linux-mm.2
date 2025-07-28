Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42B3EC87FC9
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 13:34:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD47B6B008A; Mon, 28 Jul 2025 09:34:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B85376B008C; Mon, 28 Jul 2025 09:34:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4CDA6B0092; Mon, 28 Jul 2025 09:34:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 92FA86B008A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 09:34:53 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 485B1B7F98
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 13:34:53 +0000 (UTC)
X-FDA: 83713768866.23.840058C
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2071.outbound.protection.outlook.com [40.107.243.71])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6ADCA120007
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 13:34:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="JrWOTZ/+";
	spf=pass (imf29.hostedemail.com: domain of jgg@nvidia.com designates 40.107.243.71 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753709690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cQGzwWxkdNMAsebqaDhowvhD8OMZhYvXJHwf+aj4YsI=;
	b=XkWUyb6Cbn5rXv5a2GJkUybos4Wtwr61oRzJLPp5X2wEH7shFiJPdMBQObfiOWpRlbOMrW
	k11xSlcNDdVZ5UVgHDVZJKiehiClesjV58KyaU1y7bXSShq0WPrOlSbkdnve4D5pqlOQSo
	nGmoXY7HCIc4Kr2K8us5mNpLSzuxcIU=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="JrWOTZ/+";
	spf=pass (imf29.hostedemail.com: domain of jgg@nvidia.com designates 40.107.243.71 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753709690; a=rsa-sha256;
	cv=pass;
	b=Yn1ZyL4zpzV1BCcWWMt1OU6BmmyuUqFZG6xdn3AUPJuSyHtaO53RLwc90zux2KqGsb7o3p
	2yBHtB8oSsuvYF8h6L4BoSOM2apDlJiVe0oMrr0HrCebxVzpvBH9QqTHnlKhAZyj/aLsMt
	t4k5GifCInjZMJSqkVCpV9Mi0THOxO0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nMuOC4YMpqFKNEpFIjVkP/cNivFbUNMjj41b1lHVuyBUy2KwxfbZ9bRJpK/i9CWascl6FIIlKmJzitLZwCPzXqjO1iZn9X7CJCiD0zOnSgpCavu7FvjorM1Fs7I3zBlLl049X5ylm5ju936N7ksbVqsaw9xQB2EIy9bSCDE6cYEYTHiDQOdarSOqYlGkKWSQ/a1xgGXPXIUfRO04tgkDEn8MVvFLvYiWAF1z33OB2JDbfOtyFMgKrLIEFjKp3gc6PQ3DbtlYAsQH8aoCuzjNEub/FZZOCs51MGtEDVQ4TjHHcvpG7xoj9oWb/WwIbYm0SBTiyWCNQ0b0Rsyqw4FQBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cQGzwWxkdNMAsebqaDhowvhD8OMZhYvXJHwf+aj4YsI=;
 b=NFKVFzhsZVwkxazGnV8SIlOZG89V0DdheB/bfL1AhCMu/Db2cBYlLuCeppkjAebLEvFAOgwG8ZWsK3lK90FsAhzgORmbbHGGpB3h+izfENL5XvGH6Rzt2rUBcnuRsEMWnlfvywlm084rfEFL20ITV3DfILcdgSUTwbOw4HH5FhVEydfLAVzif6jwLSV+G34B3mhVBgx6V88eAti0V7cxVWRwCldPnd++C3TuVW2R3a1LdbxwC+bud+eTFtzrvBj0a65oX7XWbTR3m7aigTiiClD28zM3odabQcgh7CMcavBkOUX1mT6Vx+hyNz0+XTtoUNE3aG4n0jEE6m0OjgY10Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cQGzwWxkdNMAsebqaDhowvhD8OMZhYvXJHwf+aj4YsI=;
 b=JrWOTZ/+kDZ9z6M4rw6vUW91os64cFQG9Z7mj47Amsj2jiOuK1JF0VCzPR4ogNMXowmzKco4c+kpak5PfGz2wITKPLG5j7k80lJPvZrwqsuKCyFLP1SJtlSrFqHMq4PBaPiRp+DgaG4tYqKeCLJnhGVQgaB5PEnHpSJVvMy7ZtczZJ+rrTjqoC3RKL2hbY7qe71K9pp07jTxWEcv1vEOo/O6p1bSVZu56lNDyCXNUvM/M6suTCnJbc0UGpscAWEHJKtKCTk8YHshrwqHPyUEls9DMslQc6Is+LORnXa0XWTbCpAa95HVdgZ0lR/TfxZD532KNf/143aqLsqylU3azQ==
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB5855.namprd12.prod.outlook.com (2603:10b6:510:1d6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.26; Mon, 28 Jul
 2025 13:34:46 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8964.024; Mon, 28 Jul 2025
 13:34:46 +0000
Date: Mon, 28 Jul 2025 10:34:40 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Matthew Brost <matthew.brost@intel.com>
Cc: Balbir Singh <balbirs@nvidia.com>, leonro@nvidia.com,
	Francois Dugast <francois.dugast@intel.com>, airlied@gmail.com,
	akpm@linux-foundation.org, apopple@nvidia.com, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, dakr@kernel.org, david@redhat.com,
	donettom@linux.ibm.com, jane.chu@oracle.com, jglisse@redhat.com,
	kherbst@redhat.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, lyude@redhat.com, peterx@redhat.com,
	ryan.roberts@arm.com, shuah@kernel.org, simona@ffwll.ch,
	wangkefeng.wang@huawei.com, willy@infradead.org, ziy@nvidia.com
Subject: Re: [PATCH] mm/hmm: Do not fault in device private pages owned by
 the caller
Message-ID: <20250728133440.GB36037@nvidia.com>
References: <9ae3e014-c7d0-4d58-af0e-925bcd9e4cfd@nvidia.com>
 <20250722193445.1588348-1-francois.dugast@intel.com>
 <023ab16d-f3af-487e-a7ce-929bf7b2fe3e@nvidia.com>
 <aIG+gqY2YRqBeKlh@lstrano-desk.jf.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aIG+gqY2YRqBeKlh@lstrano-desk.jf.intel.com>
X-ClientProxiedBy: YT4PR01CA0249.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10f::16) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB5855:EE_
X-MS-Office365-Filtering-Correlation-Id: cec72e0b-b640-4ede-e1ea-08ddcddb845a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Ky9uL2s5VUZTVTVMOXd0UUhrNFlBODVNSTRrcVZWclJ4UENvUHNwdjhyNlpk?=
 =?utf-8?B?MXA5enNBSld1K2dFMEE1VFFmWFU3S3ZzMExuYkFrR3ZOclBoK2RTM2RDWnYv?=
 =?utf-8?B?SThydWlEL1pyWTRjelRXTHB5L2krK3BEU1czTXI1S0p0Qjh2ZU81R0g0amNZ?=
 =?utf-8?B?M3Nqclpxb1RaSmprWDg1ZGRZRnRXandSM2loVGJxZWl4RE13YVZRREFoQXds?=
 =?utf-8?B?VEZhSzVleXAwb21YMHdqRENUYy9XOE8vWW1qTkhJQ3k4Vm94U0gwdGVvWUxo?=
 =?utf-8?B?QTBmaENqZ01WZVNXSUZjYWF4WVc3MU1OSDdCaW9ML21qVWVXVVBUNko5cDV5?=
 =?utf-8?B?OTM4d2YxLzg3WXZIOWxDUjA5bi9LamZhMURUb01rTXFCcUN0dUVBbkMyNWtU?=
 =?utf-8?B?TzVKd0FJUHNQOVo3WFJoUnBtbWJtY1Nqb2pPSVFUc2t2NWZoaERVaDdDRUgr?=
 =?utf-8?B?YnNBSk14UjZ3dkxiWGk5YUdWbnpWNS9jRkV2SUhXN3dZcGhuRHRlbzl1THZV?=
 =?utf-8?B?eUdsTDlPVVJHZkc0VUdtZ1VpRVhmOEl3R3VNYTZ1VHg2RWJqSmhLTzdFWVZC?=
 =?utf-8?B?R2RXWmVLTUMvcFZvYWRJR3RnSVpsOW9pVkZ2U1ozQlFIUkNvQUcvYVBzalZT?=
 =?utf-8?B?SWdYWENiMGtYYnFlN3NrRnlUeUJ5YkQzVS9SWGcrOVI4b3BiL1g5cXdOS3d3?=
 =?utf-8?B?VWlVNStpYXNqcmV3aDErN2NlcnlFOXFhWmtyOTkydXl6L21oZktvUVdrVEtW?=
 =?utf-8?B?VmNjM3R5NnloV0lheXdnMHFWazBNMjgxWDNkWm54TVY3a0xVQldRcWR1N1Zz?=
 =?utf-8?B?OUJKMENpUXZhQmtacVg1VldzNC9hOVpsbnhaVTIrZzFwaVRtbi9sS3dUTmJB?=
 =?utf-8?B?dXZzVGpBYkdTeFh1U3dUQkVGZ0d4YjltRVpUZG4xc3FlT2ZhVEdDdkNEaDlB?=
 =?utf-8?B?bmJwZ3Z5d1JMM003SlI1dU1sMnd0NG11Ynd1NFljcW1nVURCQ081NmNIN0dh?=
 =?utf-8?B?cEVZMVpOYXpyTnJqVzB6Uko2cVBJeWVxSjA2RG1VdTE4cmQ1eWt3VkpUN2p2?=
 =?utf-8?B?NDFINEFCL3JSMWg0NUtCWmZUM0VSOFdlTERha2VrSENUNzFLLy9pNGJVeEw0?=
 =?utf-8?B?eExac1IrbHcwbXdyeDkrVG1mWmwwSjFGSnlhSEtSN1g2VDg3RkY4RFNHRmJI?=
 =?utf-8?B?UDN2M1ZkRmp4SXNEc3RVaThLVjhRMXVxdFNRV1lUWjdUbVhib0gxZ3ExOGsr?=
 =?utf-8?B?YXZMNStucHdZYjlLQURDZDVVWUtMMDZEdFVVcm93aGNPdWdFNm5sS05LVmk0?=
 =?utf-8?B?SmJXb1JyamZzZlp5RXh3RTBzWGd3aklGNUFweWR5blB5Q3B0a1RITFdNbmFy?=
 =?utf-8?B?SHZCakRvRE1IMkpWZS91bDVXUnlPQlE2MCtBdVZUYlFsYVV1elFrMEh1VDQ5?=
 =?utf-8?B?RFU0YjZCMjJ1WXY1ZzRHdmV2ZVNLSkZiWVFEODUvT1ZuWHl3Vm5KUlB6K0kv?=
 =?utf-8?B?N1d2WStFdENoYmdEZElMYWxHcE5ucldNRkk2QU5WNTR3VzlEaFZObEZlTXlM?=
 =?utf-8?B?Qld3RUVoSWtkN1FwdUI4ZEw5ZjJnRmthWlh0R29oVlkxeDVWR2JXUDBRQjBI?=
 =?utf-8?B?UTRWcFBCVWZIMTJpVTF1MCtDWTJkbkdNQlROR1RUS0hUU2RoYjJQaU41ak50?=
 =?utf-8?B?NkpTTldnaXBKS0FzMHZQWjAxVUk0eHR5ZmcyTU0vRU1UamtMZDQ2M0NLRE9s?=
 =?utf-8?B?SVJRYzdKL0k3clp5UFdnK1kybnNxVndpMTRtOStBc1FZYXNWdXkrWjFKcmZO?=
 =?utf-8?B?ZHJnZ1RPdytJWFhPQnRPbFlnaVpLYXZzVzljUTJ4MThuWGVnRWUvQmRkekVE?=
 =?utf-8?B?YWR2WmJQWjllb3BVSHhtT2xvSjFsLy9tdU84dkFhUnZ5NDZVQzZQcURKSjZk?=
 =?utf-8?Q?iG13pm/Ca/g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Tk13Q2tTUUFWaEM5UEhvMjJRUGkyZi93bEZhR3Rxb3gxeDJCbEhWaDh6clRv?=
 =?utf-8?B?QUpKUVhVak1FNjAyaWhHM1ZKRUtmNmtlN0YwdG13N3JkM1FDbzNKV2RHQlVo?=
 =?utf-8?B?dndMRzZRMnQ3bCtUa0VtdWpQWFZIOHFFV21LYThmYU5DSFk1a0s0RHhWWVZz?=
 =?utf-8?B?YnQ2eWNpOVBoaGoxb3VLcUtjWEpnN0UrVDMzTXo3R1lGZjNweEd0MXF4Wksr?=
 =?utf-8?B?bGdKMnQwSzRnRFVuWmMzZFNDRWF5cTlva2RybTNFNExiOHJvcUw0ZjJicmtu?=
 =?utf-8?B?YWd1QTVSaVZOQ2ozZjRLdHFZZGh5bWlLOVhGTHRkVi9ncVJPeXU4K0lRc0l0?=
 =?utf-8?B?dWc4N0lnNG1PeFV2VkJFakp0MEsyVzFpSUlwbVZMQ2hwOTZic3E4VmUzaDVF?=
 =?utf-8?B?cVN6L2EyYlpjSzhlYmxFaURmZDhLZHVLUVJtSEZvU3p1dk9IUHpDR3Vsak1t?=
 =?utf-8?B?VzBSNER2cUtCSVhyWkcvL2dPbGRnN2dhRUlvK3RsNnlYaEFRUVQ0bXFKVVU1?=
 =?utf-8?B?eEpDbVB3dXRtYnZuQUYxZ0FWbkpYZU1nL2tPT2FmSGJ5WVBoaUdldjJtUHRh?=
 =?utf-8?B?eUkzbGtCbGFWSmxyNXJuOHBMVWhkWHJQaGtKZWM3cExDU0JWUkkveHpSdVJS?=
 =?utf-8?B?b0lMN3ZlR1RYdFNuQW9DUCttVkdTbUZuZUUwdnVvMEdJVUk4U1REcEZsbEtQ?=
 =?utf-8?B?dlZUc05jUTJqUkRYaGEwV1R3RmtyVkE0bUxrY1lEUXNNcitQMUh6WnJXRE9j?=
 =?utf-8?B?NENXUURaa0dFeHA4SGxIWVZDbmNpRjFTRGpNcVMybHFFOVhSYUNrMGxuS3B2?=
 =?utf-8?B?VFJOS0duc1RKcVU0eSt4SEpqSWN1TEFLNW81S1NYZWxXK0h1amdjOTBNOGtv?=
 =?utf-8?B?bVZNRmZ6THQ0dzBHRG5WM1kzT2tIVW9VbUlZK2N0V2RxN21yUXVqbWlhMHRD?=
 =?utf-8?B?b01rcm9MaWtWOUJVcmRtb0lnKzhxRFRyODJWeTE3ZnF3Z25IcllMU3VFWFBC?=
 =?utf-8?B?aTNhellYSU9ranJXUnp2QnVFTW9ZNGVKZTN0SHdSdDJoVFA1TTRVZzBnTGZr?=
 =?utf-8?B?eCtsUk56Q2NBU0U1YjNXeXNhZVlqbCtXZTUwV1F5blhTSnpsR0NiOHh0Ly91?=
 =?utf-8?B?Qm45SFdubTY3WTVSV2puK2xoNVJpWHpRUWI0anE3bko1ZUg2TGxyRGtoVkZG?=
 =?utf-8?B?UDUzRm42aGJrcXU5VG91TmRKeGxUM1ZtUSsrVmdYSlVFQzVrRFo1NXZnZDRW?=
 =?utf-8?B?WEp2SUloczBnMUJBMk4zeCtpZUR1VUlxa3ROT09hT2JkQ0hEdDlrRnBMbDVS?=
 =?utf-8?B?NEJFUyswQXR6b2NQZ3FTYTB5c0ZHRnNrUGNFYU5lU3cwa1k3VVdtWDAxdTdR?=
 =?utf-8?B?citZQkpiQTNYK3BJbDVlbW1VM2hpeTlFWHczWE8xOUxYRk1QZzIxeXpiMVJm?=
 =?utf-8?B?bE5kVnltU05YdDdkM1grdnNTYmpWbHdIK2NoRyszZ1RLOXlRNmVmTnliMnN2?=
 =?utf-8?B?ejdiT3UzSEpQZWgrTHZuanlNa1V2TGFiWWgrTHRMeHdvM3kxcWVibXZ4ZkJQ?=
 =?utf-8?B?WjR0OWdnTjRWWnRsVDU1Wk5jVmlvWDdqRThKem5SMG1RaDlyRlp1cFQ3REFj?=
 =?utf-8?B?ZXVDdTN5SFh5WDNCZHVVZEVhMlA5RkVlMDQ5M1VtZTJ5dEpDYVp5UWwyWWxD?=
 =?utf-8?B?K2dUaFdER25iYmhvTFJ3SzVNc1gyeGJ5UVRXNmdxanVicTdSMHVWWXAzM3JJ?=
 =?utf-8?B?TmlPTU9nQmV0aVYxUUJrRE9MMEd4ZTdrUTRRZEVNdDFEQSt0ekpNOXo2R3dM?=
 =?utf-8?B?V1JsSTdzYncwNWdqbWlZYTloejMzTCt6ZGJra1VGYzA5OTR2RmhUa25qTHFn?=
 =?utf-8?B?S1RldEVyeWdEYlRRaUNKSWFwQ1hoTEZrYlZQZ1dQSnNKZDdtNmpDanIvSmhS?=
 =?utf-8?B?SzdHQ281Ums4ZjhhRVNlenpRazROR0loUHhQenl3eGluK2ZFbmtUbXdQYlRD?=
 =?utf-8?B?TmllM0pwb1pGNGFpYml5cXBCekljN0s2Um16N21mNmNQNXhGc0twaE9IZ3BM?=
 =?utf-8?B?Z25obXFxcTZ5TTMwcVJnczBVejJIWkErMFJ2bVBrYnEwY0VFbUhzTS9aLytZ?=
 =?utf-8?Q?hpRc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cec72e0b-b640-4ede-e1ea-08ddcddb845a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2025 13:34:46.1312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aI0oWvm7czm9Q7nPVmw/oMJjOyT4NXc55bJruHyI1IOdhttmKt3p+4gOhwCszLwN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5855
X-Stat-Signature: iso9iordtuo9ygfdg8xy6xmk7rsu9mqx
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6ADCA120007
X-Rspam-User: 
X-HE-Tag: 1753709690-732758
X-HE-Meta: U2FsdGVkX18MIwlCt3+iMb9i/sCiU5z0f7AmYqwg9pTGzFzPQsNaGWiec9j+c6KPAluGO64MX918VrluT3G4hgLaxahTIfLvuSbcSIUj1r2YVbyNiNy6EyaJJ27oUBN/4rvUo26KuWGO786xrtvJo363uzAg94htWSd2qqQfpEVmZN6yBo4x32auYNBRQBMrAqkW/7poX2DIURwzB9ray0rQbGMCcRi09KHC+YSh5V4QJBbeyDnQ40nqln71+UFfwfBGmNUMQmbccrAJ1mIEPLLFmtKviEAiG8q/gtNubV5wjrxKCTKBwEeOVPLqiX/KXRPIgXoqjx41FKDAF5M0IPdZVTJDletgFX1Ligq8Q0ac//9747B+DDMj01/fzv0PNPs/y0UR4WGPkdNVEV1nDPdnblScJeDrsny7Hf8b/7PoPqZ3B64qt6LmcaiGiQ9VhX2fHC4GpjLaKszz6q+LLa2T9IBoPuZJm7JZnvg+bZYfYmE0xWeajj6Evi64X00HicG4M9T8kRt6NcWvJjYlKcJpQMFgGwBtyDLhrOPuBow18JT5/1YnufFVmuCCia+F1H/jHVixXEqwmKucQ3KQfau/Aie0QOGrKVakeasJnZAdUVgHpOjJKAO6+OGUeYl0kz5Y4fMjbm9zVsZF6Alqy/L4Xtd2o0L9F1U0j6Q5MypUzjm3CkftqiKDzdYQVxUs15leggYzqeK9GmRcUxjYz+Ybt1ji9HwZmn44tO28zoF45otYEcGTYl6wgc9kTYQ85vEdB8NIq6S+tAActFME3NIOIBFjCiYyvila1knT3ClI9q5lKbZiPe3I/3NP/IbaNj1IbFXR5lvCohQIFZyY0xm15KVGxXVphfsKmtVhIP42UHfE4KpVuK1+ReHCxEVXMd76brssnWB7/PX8kboQp4PckFkNPgxJ9M6d8ybHK37ax4WFKnWB1upJwe3UvrfrEFc0Obr2cC8F0pQHXrn
 TO+qSAvM
 02k0PocBnQs1zla/7ZrQtuOfcLubZ2vrVBIQR2smNebQAvFoQcjLIGeWyZKwU+gFpP5PeJ/AfsE0sqYjss60GmLWJXej8TQ4rLDsgNUrzdLTRN4crhHyiA480odqHMGNwEbucq+5dnWa4fx4Ombn4NiAwJgi8kXzT/9AsMu2/yQ/63BbEEEWwwwdXRyDbCryMSjvHZjKvckSZCeclB7am2XH9Q29ROdkeBh5RfSaWHYXSjuizbw1y1E7/L71fitJnRR0iNSAMWIuYSwCPxf0uR6HSgg+m5ePkhy/xkMqgj+DPlYEUrJIwZwqHWVURhL49A8TJyeoRRUzu613jN9Eco3UAngaMQoxfmZOGaEjBq8CMmxZ/MU7GffRtsTTcoKIbs0g0U57vc2SccWLzcE8xxDTz6YY4Fu8PRXOIx0zGfV+okVomnHhI7WwtilPOEwKqqdeIVqlA3eZZr8xML/gXhV6r+F5hMgkjpv1nItQiWB5oqrFMnuasjM/sJYaB0VQNOEmFyHxnPsWgkDJ/SJUiDQCv+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 10:02:58PM -0700, Matthew Brost wrote:
> On Thu, Jul 24, 2025 at 10:25:11AM +1000, Balbir Singh wrote:
> > On 7/23/25 05:34, Francois Dugast wrote:
> > > When the PMD swap entry is device private and owned by the caller,
> > > skip the range faulting and instead just set the correct HMM PFNs.
> > > This is similar to the logic for PTEs in hmm_vma_handle_pte().
> > > 
> > > For now, each hmm_pfns[i] entry is populated as it is currently done
> > > in hmm_vma_handle_pmd() but this might not be necessary. A follow-up
> > > optimization could be to make use of the order and skip populating
> > > subsequent PFNs.
> > 
> > I think we should test and remove these now
> > 
> 
> +Jason, Leon – perhaps either of you can provide insight into why
> hmm_vma_handle_pmd fully populates the HMM PFNs when a higher-order page
> is found.

I'm not sure why this is burined in some weird unrelated thread,
please post patches normally and CC the right people.

At least the main patch looks reasonable to me, and probably should do
pgd as well while at it?

> If we can be assured that changing this won’t break other parts of the
> kernel, I agree it should be removed. A snippet of documentation should
> also be added indicating that when higher-order PFNs are found,
> subsequent PFNs within the range will remain unpopulated. I can verify
> that GPU SVM works just fine without these PFNs being populated.

We can only do this if someone audits all the current users to confirm
they are compatible. Do that and then it is OK to propose the change.

I think the current version evolved as an optimization so I would not
be surprised to see that some callers need fixing.

Jason

