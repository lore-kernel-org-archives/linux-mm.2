Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F049F589A4
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 12:11:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32FE96B0005; Thu, 23 Apr 2026 08:11:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E1246B008A; Thu, 23 Apr 2026 08:11:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A7D86B008C; Thu, 23 Apr 2026 08:11:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 065D46B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 08:11:02 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9B3748730D
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:11:01 +0000 (UTC)
X-FDA: 84689704722.17.73AEAED
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012035.outbound.protection.outlook.com [52.101.53.35])
	by imf15.hostedemail.com (Postfix) with ESMTP id A9E66A000B
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:10:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=y1d8U7rZ;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf15.hostedemail.com: domain of shivankg@amd.com designates 52.101.53.35 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776946258; a=rsa-sha256;
	cv=pass;
	b=m3YYZTM+Xzw784qJNwjmMhqVZ5Xqi7LUJ9i7EjFIVBVcELY5GeJcqJoKwilLBV2BxrSd1d
	eT88WGiRw/2UHUo09hSz+Gf6HMJDcYCrWLkPtSirmrlwAzHuYWrUZCkju73bEV6gB3B4NX
	ZLOF0T4NkxsCULk1OE6LwqjKQsMJs2U=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=y1d8U7rZ;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf15.hostedemail.com: domain of shivankg@amd.com designates 52.101.53.35 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776946258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0EOlZPt+U2iBdfPGbcXDVIu5DScxMx7KxXdxhH/Z8Sk=;
	b=gkb3zTsejK8OA5pIFV8xCC4ytVQLbDrEfpJf9M3+C+ue4Xe0l39L9dFRbFQBEFojjhAh9P
	UM8iU0KO/NwMxplgkyxa9qPLGsD3Hw+26y/ZS8KcdZG1gDqFfP4TPaRlMl5q82JDMJRcwi
	24cUIwuhmSvNU3apra18L7mhvOm5Nkk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=trZPYL7fR1BEY5zad6yK0REjUj9o60gvlvamrcquMa5Rxy/jtNc6XsTPRAXCt0c2T/A1HwVsJwdKhZRwy/3igWrRIyz67SIa4XA6PzlUGo68qaOamWwlEBcIfKgokjgkXEzyN4W4M1DIa9VCWTr9Wi6GkkPHy1CgR5b7Zq7aD0im2TAcFup15rEWQAGUZDr0KPijIzr+u6uPcIGtGPQNTxQIYVIyerFSmVp7Z9UAk0zXcAlRmGL11xav0Yo7oDTnP04qM37US3A730XmhC+7vKb9vdFmobMsgnGXa0a5WgpkZ4wKotDNExlNXN9ne+lOF1ldJmMz9kB5RY7Mac285A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0EOlZPt+U2iBdfPGbcXDVIu5DScxMx7KxXdxhH/Z8Sk=;
 b=BunKe38rCkGmxPZ/kdVUfNxD8O0l6THzBD+E80pa+aF6Z26hdnxH24KXxGqd4uSuIk9CJ1zwGPciQxwus8/jF+uZTS9fP7odkXUccizIpVvZWbUp28Ni/WQ/5DlbaEFryJS1DElN2kewyL+Sv3Qa7WMg/8JXJTzJ6iWghaf4FhjkRT6euweim7aR6P5OKwOOghCAekU5+hvIgFeFqc3PDEW0Qt8ZhOXvk5CSY1La5coDYuI/WR4FWHQWbr3wYV2PIZL/Hi5m6K3FG4LsMorDzHmdMu5kOHGsbvs2XIehGut2a0arEFZCdhPwzTnqlqJG/dGE1PLt12Ay2Z1zbiaeSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0EOlZPt+U2iBdfPGbcXDVIu5DScxMx7KxXdxhH/Z8Sk=;
 b=y1d8U7rZ0ZeLjcLUg9iv/DUgtrE7CfJGyCOC8qesHIaYWDKsXQun/atI/Mh5CbXL3TabebUTsB3qAmNHYwDojBc9DYv1TmmNtN7dD1Zrt6XErn2xiDUIjXzt1xct+UCipVhze+szCeVA4I92k4+p6Is2zPEEI/ESYGaYQsshsLI=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by SA3PR12MB8763.namprd12.prod.outlook.com (2603:10b6:806:312::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.18; Thu, 23 Apr
 2026 12:10:47 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%4]) with mapi id 15.20.9846.021; Thu, 23 Apr 2026
 12:10:47 +0000
Message-ID: <396b4be1-376b-4aac-bd1e-2854c88b3757@amd.com>
Date: Thu, 23 Apr 2026 17:40:33 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 5/6] drivers/migrate_offload: add DMA batch copy
 driver (dcbm)
To: vkoul@kernel.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@kernel.org,
 willy@infradead.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, dave@stgolabs.net,
 Jonathan.Cameron@huawei.com, rkodsara@amd.com, vkoul@kernel.org,
 bharata@amd.com, sj@kernel.org, weixugc@google.com,
 dan.j.williams@intel.com, rientjes@google.com, xuezhengchu@huawei.com,
 yiannis@zptcorp.com, dave.hansen@intel.com, hannes@cmpxchg.org,
 jhubbard@nvidia.com, peterx@redhat.com, riel@surriel.com,
 shakeel.butt@linux.dev, stalexan@redhat.com, tj@kernel.org,
 nifan.cxl@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 akpm@linux-foundation.org, david@kernel.org
References: <20260309120725.308854-3-shivankg@amd.com>
 <20260309120725.308854-14-shivankg@amd.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <20260309120725.308854-14-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN4P287CA0118.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:2b0::7) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|SA3PR12MB8763:EE_
X-MS-Office365-Filtering-Correlation-Id: 30bd1cb7-c326-446b-0b3d-08dea13159fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	d2Z+8qTje19G6MaoRaqanKL2LHILQPUkNBpixTVRmcFDoRlvDiQ68Qu6LyWDhTG2A4x5sc8gzB6oZQutPKUmzsmgn843Gdy+duUkWtflDoh1c6pHBoJlMSKW+LkdH8+Bj9vO9aPpsOxpCh4QovikZxvr+sOONw1TMoAmoW2UPCK/xbyvQHr7OeMj2tExXPJyMenePfz3CVdlDiIflKBcZ5KrLjnGW4Zn3EFRJzKFmW5Ca7DZ6OTqrKpcWCoubrZitccd+TfT6Ebs4mZ+bHtYZqKN3rX+NL2IMUGCVfuNwB3lbuRAUfdPrJB4OpxcWiUmx415OZfikpVg6y4AlhOQ9sqVnEHihG+mZ87/kN3khurNqMOqe9mHVr4PbNLInZrXjX0mPRuAIVB5cnWRy9QX8J8DZ3u0og1KDgw0QlDznZTNHAb5uFNixsRpsm7lF12eVG+te0Xq6QryJlvYu8KenlmBwWgfRLrDpww3DMpV8hRBEB4jy9f16oUbO5YnBm4l7T2WJSKD2Ctw5niz+RBSW5KeiD2nYgJfpKHNmWjVxxnFHB9L93Mr0vybSXFuBXjruuAbp7/fgQOK36DjyQ8IKObJ1BYi125EFl6A+VqISNhGmp7jG1nIUWuN1HRuwhlsuqqXkhpnZtuyGv5lll/iBLWg4jZFFpF7dIAb7LKNDMPwhMFlrhb1hPsRMtk3wAJKjTBlQFmxQYLH5bONJZqjjAJEFrSn75u6IEZtIOasl7I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Mm84OTh1NXB1ZGRTS0c5alV6NVMyempvRWJNSDdwcFo5N1ZSaC9RSzNROFhn?=
 =?utf-8?B?VFlXeFdWR1ludldJVHhndXJmVkpxWjhRc1k0UGlVY2VVQ1orYlRoby9IMjlr?=
 =?utf-8?B?dVVSWWpPRkc1U0JMV21BdndrUzJMQXluTTAxd2lOY21IcWxLU1pWeTVYSHRB?=
 =?utf-8?B?S3FlVWZoMUNGTXdsYm9ZSzdtTUcwOXFDTVQ4K2pjL2d1V3FVRXI1cUJkZkRQ?=
 =?utf-8?B?ek5rQzJzczRXa25ONklCL3dSMTdnWFVud0FsOGJQbm9tVWxFcTJSOGxzRUFM?=
 =?utf-8?B?R2NiM2hQcnRXaGoyY0pabVZPeXArd0RVYlFoQ3Ntd2paUzJtcUU0ZU5TNkpX?=
 =?utf-8?B?RDdsS05heGd2OEVJYnVzbjhxUUNKVmNDS29hZGRlN2xWdUpMdWdqVVdnaEJB?=
 =?utf-8?B?STBnTk9zR1Q1bG8rNld1eEtVR0pGTndSUnQ4SFpOek9rcFJQL293ZHpFcjc4?=
 =?utf-8?B?NkZTM3V6SFFrYjlldU1FdXVBallrM2dBbzJuWWhPNVhnSFJISFJxSEN4R21E?=
 =?utf-8?B?WWtoNitoTEVXQjBVTC9lRmFRTjJPL3NZcHB3dWk3N3JlQU9lckdNTXBvb2Zv?=
 =?utf-8?B?U1RkWExTK04xdHd6cW9BTjJueTU4b3VsQm1jZUNyMXNNZmdFTS9Ha3haMkFD?=
 =?utf-8?B?WGhBWFF6YnRqMDdqMUJ2MmdMb0YyeWVCWUxNeEI5bWNQNWQ3Uk9kN0RSYVVp?=
 =?utf-8?B?Zkw1WE5aSHMyRWw1K1I0WXcySTIrVUNtTXA1Vi92c0FKaWtLVEEwT2YwM2Nn?=
 =?utf-8?B?ay9TUWVNWTlOcmlVZTV3UlFuMUlsaUovMDZTaFBCK25lZG55MkZHTXhGUzVI?=
 =?utf-8?B?SkVqNzRBc2dWeGlnUG13bERUMWRTTUxwcHJZN2N4ZkZVa1RGT1oxVGE2allS?=
 =?utf-8?B?SkNtSTFFYWFJVlgrQWd2cGhZNC9MSTBuYlAvcUY4S2xUMjAzQzk3RDRzbnBv?=
 =?utf-8?B?NW1NNUgwV2Iva2tTcW1xa1ZPUE0wNFJ1ZG9jclFwSzZYSkdlck1OYnpkU2JU?=
 =?utf-8?B?RVNBbitqQTRaNzUvWG5YVnFKNUJtRlVURUlESTczdytEM3ZDMm9tZ0hTa01q?=
 =?utf-8?B?c2RNcm1MVVMyOVU2VVhaMFc4alZaMitZUWNrQ2hwdDJMUmRqREFkb0taZ0RO?=
 =?utf-8?B?YWFsZWJJUXVHbUlTRjZRN3dtRlM0T0hrejczWTVGWlpPQWtsRFBGK2pldDlz?=
 =?utf-8?B?eHRibzhuTEVaRVloRmtDZkxOOEZQLzZiMTYxNDVCdVdLem11Mk5ERnZoZlFl?=
 =?utf-8?B?NGNab0RiYm0rcTd6bDhqeGpwbFRudlBZUXpOYXlCeVczbEU0UWdmblFYdXVq?=
 =?utf-8?B?bjBkbm9lU3FpVE9rZXB6b0MwUDlyOTIrUGtVNXFwaU52czFENUIwdG9RcSt3?=
 =?utf-8?B?bnBGajVWMkRTQ3dzRStkLy9UK1REenRxM1pPcFA3clI2cEJwOG5iOUNWMWha?=
 =?utf-8?B?WHJyakoveUFmYmE1SVRwSEVIb0FaZlhsT09ETzhmSS9SS1ZNc3ZRZHZKV1cw?=
 =?utf-8?B?VDJzeFdLY0c3cWJlck01TVZCSVgvSGJDSm50ajZHaWFJVG54cmh0QlVndDFN?=
 =?utf-8?B?UUtqTVdBWlA5VHdiTkoydnJCNURrZVQ3ZmR5ODBKTlZrZEhYR2N5c1Exam4v?=
 =?utf-8?B?MUwvckViaHNqM2dDeTgwazlST05jQmk5MWVqUVZ4T1VqYVppT2pjeW1XV3gv?=
 =?utf-8?B?YWV5enhEMG1XSXNNVnhaZTV0Y3V5U2FJbTdIRTFIMEtNZVA1TjlJa3BEZjBP?=
 =?utf-8?B?NW9EOTA1YXZUaUFoc0hRNjRhZDViNHFDTDI2SmFMc2Nwci8vTXhDUElvalVG?=
 =?utf-8?B?OGdBalZOK0MzRlA0YW9XbFlORk1raVVFS1NTWFVXOGVsVnVYU2hxak53ems1?=
 =?utf-8?B?bHFqSkwvSkFhWUNYbEJHWU1jN0hlZGNEczB0NGMyMGNIYjBzb05Rdnh0NFBQ?=
 =?utf-8?B?WWdSaHQ1OXVJRHZxeGduZ2NYR2lDUDVWSnJ2TUs3dnl2a1FHdURlenAwVFVI?=
 =?utf-8?B?aVc3aURNT3czc3RMYjFVNFVYakJvSUsrNm9ZU1ZTMy9YVm1FMTNUY3ZUNXdQ?=
 =?utf-8?B?ZTFHSy8rOEtSaWgwdGk4OTlpUmFZRGcyTEtodTVXSnd0dksyU3ZyT2crL2JM?=
 =?utf-8?B?NnVaZ1N6akhFbExPQy8yVVZjZ2FOTml3ZlhaN0QyTkkvQkphelVVRzZNeFdo?=
 =?utf-8?B?OGZ4OGc2bExJOWpZdnNJWW04OVpvcFFUQUlYSG44dGdFeG5ETHphdzdqMWNt?=
 =?utf-8?B?cTYzRVhld1YxL0o5T1ZlNWpOT0MrQkJpT0kxbFVuZGRUYkR1bldSck1Tc3Br?=
 =?utf-8?B?WURrWTIwUUI0WThoNkFtWC9VMEtWdXlUSG1CdEtwTnpPaG4yTGpWdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30bd1cb7-c326-446b-0b3d-08dea13159fe
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2026 12:10:47.0112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H03gWHMa7A7XISAwnz3WxNweDeMSrDcLeBGpz6QhKgtkmF+k9pRpnZy+eEmB8mQgPJgK32luRzstcL3DWHrojQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8763
X-Rspamd-Server: rspam10
X-Stat-Signature: s3gzu758c7ykfc7k7dnuoxqp8mijrd53
X-Rspam-User: 
X-Rspamd-Queue-Id: A9E66A000B
X-HE-Tag: 1776946258-323584
X-HE-Meta: U2FsdGVkX18XxfDyHpCJNiyMyyhV3CUBIHSpS9Psj6G4ozgj//C8OvHir5zkMyCwWr2kRay5/pM0R9a6h8PgehVCdE/h3I+cHhjUKL7ikbKCI/voUR6ZVPgjYTp/EYqSE1WYUwJNyvKikRVw4VVrFJAeo3OQdFXDKC2voPpx6mYwabucmOIDFv79CFJyKrL7lamkV3VimnkJFMR1MaX0KLAXxQmhp2J5sbL83zKA/xN0iEh4JuSdOXpKW78gFJFcDZKqZgN9gMrZOQpOgtXWz2Tz6MhOVIgcfDseBcCyDXdhO0OL8SNEXBi1EC1Z4TlXHLFjQMmFxVHXdo1HI8QKZAmR4g+9lT8cjE59wG0gzqxX0rFCrj6AXMW10wWbRcN7Qx0pnmqxIv/eQcrnnn9dEtj9nUuLZzugqfOS8Jzg/QgY/+IG01fAfZSw7x4raPOXCK+C5CE51XDtiKct62EDCowlFg2LqrZVjqenp1891IWHhvVtRho54SNHsdfVBhnOaFJ4Mto1sken/4UZaQ0D30mxNnlYP7xI1GXE33uc9+h0rzO5efSiSef12L0gsmCcOVrJjCqhM5NsmHqeQ49vvvYHoKkETohU3rd6aim5Y5EY54naRlJwcL1MbdGYgtkUyAxM8GYv0oV/Za0fRzsgpVVLwXO8Npncau2Rv9Q/Ts5zSENM4WcLlpIctDgQR1nWMdeWdDk5YNvqfZ/B6R5TaFw5zC1nLaI76jGadWt3zsEJWqRpPWpvDmNuf6SeE1IEmaCdPjWPF+m+B+raWpGyg5/bT2T4C5wVAQmJrE4N6RV2aP3Fu9xgjHLXMHShCqmFtZDeo6C6NisSZRLrzvMTYvPybd5wQpx27Hss8cBRpqD7+BSD+ehw9m/51RDKTTO8Cg7JSXoLITMaRnhk8lxjCmgruCDLfcbwYKTvM2VZH5SitBRgr4K7SLkeiKH1hhtM1tbTsJC6z5JumzmnfHH
 phPIqhYU
 chc8J4mfrRtwNxXIFCcioO5EWrZZPEKaj0Wp5tT7soiUdHorkuXkez/PbCEXFa9rYNC+UGU6C2J+h4AxqJ1bo9vbKXsZkpHkIcyBjvAR5BI4DAjtn48c9uijjX/86Jy/vLi5q9mc7uDXfVeP0ijSCrhddfKonttH2XhstvDUsHa/g3SFUty152xDYffWIQ2Z9AopTVXJgPWLWNwg2U0/DCHJ57aBoO2+628yLsselfEXJF0u+OgXeDPWcUr9nRfyZBUeTCcRgeqS2vIK5lZTXpYV6M/1nyfQnz2arpjyPgnksb2j5xIrdFJVAS5x5MXVmOu/QsxzvIy79PhulHTvE30owISJQy7mRn52RkQw/aZBUtzLON7YZ7Vg1wBJNxmGtbbuuUKPYmgvjjSS+rFldTLYxSA5rqfX1AWccYaGyYakbab7USfxJYMcnf17jn4liX87QEFM5wQOFaBuLWlBECkbEaqULdUblyT3txaS22/p9DO2Z0jq8E/spkF1mqYUhC6XmOn5v+a2bz3Cq4ThkuRXUnQcQtAeQrcjlKwX//hPlHvI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vinod,

Following your suggestion at the Kernel meetup in Bangalore (11 Apr 2026)
to check 0cae04373b ("dmaengine: remove DMA_MEMCPY_SG once again") and use
DMA_MEMCPY_SG / dmaengine_prep_dma_memcpy_sg() (I added a
device_prep_dma_memcpy_sg hook in drivers/dma/amd/ptdma/ptdma-dmaengine.c
for this experiment; not posted).
I ran an A/B comparison against the existing DCBM path that uses
dmaengine_prep_dma_memcpy() in a loop over mapped SGL segments.

I'm using the move_pages() workload to move 1 GB data per run. I do not see
significant performance difference, and results are broadly within each
other's noise band).

Throughput (GB/s, mean ± SD), ITERATIONS=10:

Page     nr_dma_chan=1              nr_dma_chan=4              nr_dma_chan=8              nr_dma_chan=16
order    dcbm          dcbm_sg      dcbm          dcbm_sg      dcbm          dcbm_sg      dcbm           dcbm_sg
------   -----------   ----------   -----------   ----------   -----------   ----------   ------------   ----------
0        2.33 ± 0.17   2.26 ± 0.19  3.24 ± 0.21   3.18 ± 0.23  3.29 ± 0.10   3.45 ± 0.10  3.29 ± 0.13    3.49 ± 0.22
4        2.77 ± 0.21   2.99 ± 0.18  6.26 ± 0.99   6.75 ± 0.12  8.01 ± 0.58   7.70 ± 0.64  8.22 ± 0.89    8.72 ± 0.87
8        4.57 ± 0.70   4.75 ± 0.83  10.64 ± 1.97  10.94 ± 3.52 10.30 ± 1.22  10.36 ± 1.24 11.27 ± 1.21   12.47 ± 1.66
9        12.71 ± 0.09  12.68 ± 0.08 27.13 ± 0.15  26.89 ± 0.27 46.50 ± 0.73  45.17 ± 2.46 67.25 ± 1.42   62.78 ± 8.24

Notes: order 0/4/8/9 = 4K / 64K / 1M / 2M folios
	dcbm     = per-segment dmaengine_prep_dma_memcpy
	dcbm_sg  = DMA_MEMCPY_SG / dmaengine_prep_dma_memcpy_sg

<snip>

> +
> +static int submit_dma_transfers(struct dma_work *work)
> +{
> +	struct scatterlist *sg_src, *sg_dst;
> +	struct dma_async_tx_descriptor *tx;
> +	unsigned long flags = DMA_CTRL_ACK;
> +	dma_cookie_t cookie;
> +	int i;
> +
> +	atomic_set(&work->pending, 1);
> +
> +	sg_src = work->src_sgt->sgl;
> +	sg_dst = work->dst_sgt->sgl;
> +	for_each_sgtable_dma_sg(work->src_sgt, sg_src, i) {
> +		if (i == work->src_sgt->nents - 1)
> +			flags |= DMA_PREP_INTERRUPT;
> +
> +		tx = dmaengine_prep_dma_memcpy(work->chan,
> +				sg_dma_address(sg_dst),
> +				sg_dma_address(sg_src),
> +				sg_dma_len(sg_src), flags);
> +		if (!tx) {
> +			atomic_set(&work->pending, 0);
> +			return -EIO;
> +		}
> +
> +		if (i == work->src_sgt->nents - 1) {
> +			tx->callback = dma_completion_callback;
> +			tx->callback_param = work;
> +		}
> +
> +		cookie = dmaengine_submit(tx);
> +		if (dma_submit_error(cookie)) {
> +			atomic_set(&work->pending, 0);
> +			return -EIO;
> +		}
> +		sg_dst = sg_next(sg_dst);
> +	}
> +	return 0;
> +}

static int submit_dma_transfers(struct dma_work *work)
{
        struct dma_async_tx_descriptor *tx;
        unsigned long flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT;
        dma_cookie_t cookie;

        tx = dmaengine_prep_dma_memcpy_sg(work->chan,
                        work->dst_sgt->sgl, work->dst_sgt->nents,
                        work->src_sgt->sgl, work->src_sgt->nents,
                        flags);
        if (!tx)
                return -EIO;

        atomic_set(&work->pending, 1);
        tx->callback = dma_completion_callback;
        tx->callback_param = work;

        cookie = dmaengine_submit(tx);
        if (dma_submit_error(cookie)) {
                atomic_set(&work->pending, 0);
                return -EIO;
        }
        return 0;
}

The memcpy_sg version does simplify submit_dma_transfers()
(one dmaengine_prep_dma_memcpy_sg + one dmaengine_submit vs a loop).

My current DCBM path issues dmaengine_prep_dma_memcpy()+dmaengine_submit()
per mapped SG segment and sets DMA_PREP_INTERRUPT + callback only
on the last one, so the IRQ/callback cost is already one per batch.

My understanding is switching to dmaengine_prep_dma_memcpy_sg() mainly
saves the per-segment prep/submit calls and hands the provider a single
multi-segment TX to program.

Please correct me if the benefit you had in mind is something stronger.
Thanks for the suggestion and for guidance.

Best Regards,
Shivank




