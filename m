Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A69ACAC59B
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 12:22:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5A458E0016; Tue, 16 Sep 2025 08:22:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0AAA8E0001; Tue, 16 Sep 2025 08:22:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD1DE8E0016; Tue, 16 Sep 2025 08:22:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 954FE8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 08:22:39 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5F9ED56593
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:22:39 +0000 (UTC)
X-FDA: 83895026838.24.122932E
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010001.outbound.protection.outlook.com [52.101.46.1])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7A2AFA0010
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:22:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SYlsqZG4;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.46.1 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758025356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LNs4qXlKokoHweZ5M3XkPDDF1g4skarfVVeDV1+gXvI=;
	b=25F4aow/L+P/1R1PD34DxQuD2AzV7IOwRrrUcrQ8QB+t3WgJz7PmxD1IJkOJWKTR4hFwSB
	ytyqkFLLu99iear2SxeLxGv23pzy77ZkG49BtFPHNaGV3pWywypYfSZnGT/gC1rDvAk/nL
	fNmvk72M403/mE5KL9oHmr5nVsgDUAQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758025356; a=rsa-sha256;
	cv=pass;
	b=Q/iMEIk/azjT8tPBHdhgdXOr+TnkTZy7MLixiScZ9Y9EBZMvD/EKFpkcd56bYLl4CeI/85
	qfndmRzZLFas12YEu8ht224VS0DjXSVYZR9xRLxxSV5an8ts/2Y+EUyY8Ibmn81OFrWtMD
	/sHRj2NqoZB5Tzsbv/2SOAQhkkwgwGk=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SYlsqZG4;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.46.1 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fe73V/toIq+dlCigXv0PLBTuwixOoBN9sgH6DiVF6Fiy3FpAJCRmiCXbwr60KlPLoH7WfuBzdkUpeiBtjgl0AbyxYhQQ2hg/rsj+EIQ1y/GF8zFb9whAGDBPsUcYMh5xnKTssnkB9GOic6osq4bwC2V1p2b7E0CfJdendvAvFOx7xClRhB/WIgbEvTo7z1KxbcozWDRmN7hLrqPgvpcN+nlgABp3sMhXIoWteVhYwFfAH4eiMVzxeux/EDemzOxAwhKyG+Ih2/WJBifD0uy49T0M0JmeKBxqJkoDyWB2rxqKHLsyFkAnYaE7wf3ccoz1nyQQ6rVzUeybB2PWa86oaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LNs4qXlKokoHweZ5M3XkPDDF1g4skarfVVeDV1+gXvI=;
 b=LySPJdGdG7GPqdyNUUsXteMtG7YojlpZgR63PLBI0ZyHxSzI9N9DZFJapFHT46oV9MJAYQYHCMoPTM9ikG98e0P/7rkiI33i6Y3CZ9KsEBOxU3j1v9ZQXE2URHZRltWgh/BJdd/Uf1k6/il3IasRJZmZRRunWZVjqCBdi1B3u0a2QAGhH6+zECEewamvBrqOpP9V4SPcESLJBUWtT0irXYRJHD4iG2/qkJaZOr4lmseERntqIWXE/KBMgXcngFmDrTwpueozX6NIvG1Y4lYAlXoaqxVmzKcW5VNHjB7UFRQciK1XiMSWDx7NWQ6mmS6bRd8i64n8OVAoXtET5A4YJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LNs4qXlKokoHweZ5M3XkPDDF1g4skarfVVeDV1+gXvI=;
 b=SYlsqZG4afGqN7vcAAWVl4Ip/1PwAClMPdB0mrK4FCassxWnr8CyoS12xgcc7UuU1uZCjA5BN5JfWmrHp2MH8kFWM7usFA2mDwOxquDM/kH+j6Y8ojZ5Mb36bUreElk+zEHNDnokujaW4mUt/hrcqGskC1hICQE1xom16o5JGU7pCbjxgAEW2qaFR2ihiCxBO9qSnic8R8EAx+6fVOckeFsbRtkRTMAdhmWDRA1R9wtQ0vpDM2mrNv0CnlD/MVmsKbdgisGjnyd3l4vFB2TpX4VLQkV82Fe5kHimJitvX9k1worqHu+MPCR1YHLt3qx+XVRT0ajT3V89lmSL2DrcRw==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by DS4PR12MB9684.namprd12.prod.outlook.com (2603:10b6:8:281::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 16 Sep
 2025 12:22:22 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9115.018; Tue, 16 Sep 2025
 12:22:22 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: damon@lists.linux.dev,
	dri-devel@lists.freedesktop.org,
	Matthew Brost <matthew.brost@intel.com>,
	Balbir Singh <balbirs@nvidia.com>
Subject: [v6 13/15] selftests/mm/hmm-tests: partial unmap, mremap and anon_write tests
Date: Tue, 16 Sep 2025 22:21:26 +1000
Message-ID: <20250916122128.2098535-14-balbirs@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250916122128.2098535-1-balbirs@nvidia.com>
References: <20250916122128.2098535-1-balbirs@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0005.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::18) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|DS4PR12MB9684:EE_
X-MS-Office365-Filtering-Correlation-Id: 569ed9c5-5cad-4026-0857-08ddf51bb02b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|10070799003|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mO/MJ4vHSC+hh/eRbA7SZx1gXNKJvbP2sUeIGhR84HXiAGGlRuyhidldCb7m?=
 =?us-ascii?Q?9M28TmrbbSfP2dzwfvn4KWxIlywaFASiUa9Mfm6xRJbIuxnJXCKCQ94Rkbrk?=
 =?us-ascii?Q?tvJAZnFvUXJz3gJdcyTFkdK1hCp7Qokha95XTIywWVmxTJSnmKxy5F1JAjUQ?=
 =?us-ascii?Q?csvTEzw97SlX12fDS+VHMvlhuf+ImeWdaNhUBYk+5pzKOoh6ZOVeCv5M8S6S?=
 =?us-ascii?Q?5vjDm8pRQ7pAoktKtxlrDtdeFsc6fD7SZycNdjoXtk2L8FRFRGvdpynAZ/wn?=
 =?us-ascii?Q?1vtVodLw7BVDv4lw4y+FXUyw6VKGjFU7IRWw4wrSO7mTlq01pkZSXuqj+yQ/?=
 =?us-ascii?Q?b4kb0SAFjtRKR2OyZs/7tplCGzpcM8nIZ1OUc3LIJN0VcB7QDTN3qjoWACjv?=
 =?us-ascii?Q?Lo+8oIc9QUzl1voOkoahnSvDcclyIHXYPALWnU+iD9dwmBfdecwkrBbYbZvt?=
 =?us-ascii?Q?lxpP54oLa3gbJ+cgMav3+wTl0VhVvh4M25Z/spfzsaOXZz4ERntkdvq9GOJs?=
 =?us-ascii?Q?h+l07myPESsREue7Z9BOKbCNQ8lfXJBnNDa1Ne5Z31oN07y1NG3ZHKcdmZnT?=
 =?us-ascii?Q?gHqPxvSXriorHcmMxkWaECRVLLwKuOkuK6R9oHOg6nJnkl6/i0Wox4uv3VxO?=
 =?us-ascii?Q?BcDX9GL3BQVfWy4TWVLctcrwpW87d6mKC/ZrNyuxzzjGW/VPZR0FLWHG3KKq?=
 =?us-ascii?Q?jP0dbtVaDB0ma/eu/BEG6sdTgNuQaBMJ61EYlTwJfyq3UV5sU/dXG/iLKqBa?=
 =?us-ascii?Q?6H14GpYz5eeGOtm28brLOGI+rE81fg2jGLeAT2iYctjD+Ti8KwPE7bkHmLxG?=
 =?us-ascii?Q?IH3kyaOHpsnCJHZffq9HAnEUtG9OE87cxIJDkwekJKN061dAFvAp0hTxshQg?=
 =?us-ascii?Q?0uFOZGqZCv+k/WOV8ow+2CwJ2MVOVs+bG0EEOwlg4rC/pzR4n5ZryjENqRL9?=
 =?us-ascii?Q?cVBIQmVgCKIc7I3PF2Vw9jZLw3G20KTvvydeTA1IJBOxFfB5cBPyvukFHJRO?=
 =?us-ascii?Q?5xjRgQcPhfgc9HxuhNc8a0mnWGxnQ7afEaQOF5CsCZ5kGv73G/ufpZ9YD4+o?=
 =?us-ascii?Q?MVLHr4bFvvcQqJvDrQdAGh95jLwNP6w7eRfcA/rTcwn5MSFkyrP3OMRgEZvY?=
 =?us-ascii?Q?irD+K3rK+/qfgVZ/0DTdHDuB//vHP1ow4QBBp4/IO0+kJc9bL2CnYYcshqjZ?=
 =?us-ascii?Q?gRVzRRxuLEdN8ZH86kPrLwMd3QV0cR0Pvpm1Kv3a1Yn6BB9CVkQJlnRQhf9k?=
 =?us-ascii?Q?dZJiFCzR+wjYDnzgbVmMwnPPMIt9ngxipcwypTnFGXbAYqKRKp/+vF4YMliR?=
 =?us-ascii?Q?44jgGtAqs4HlOzOARjMAJYuPFdLBAwcoi0DO3YOT6/ghHB+cfrq+lmh5fzxj?=
 =?us-ascii?Q?fzXMQmJmtuQaQjdGetfZQTtcxgvTlNShlHBBiftUEULBhAnKWw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(10070799003)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MCUp27qNla3EsTjfe0feKse0tbEJ8gxeJ3TSUbr05+22Z/3bhJ5fnKB8JLZp?=
 =?us-ascii?Q?tULpcx/1H1rqa1HidnHKAN7AOLRojnFeOQTtUglUnpP5vm2H23ZWrv9yvOa2?=
 =?us-ascii?Q?4h5u3/frR8aG/7J+gviWEoxX+I+9Bn3N2kaTFRCsKbnz3cF9gnxGEuo7Qovc?=
 =?us-ascii?Q?fcKZ91FH6eFdaswkPYErvOcZZCeoi5WQwvDtbM0SSyhYAFggSIFGH2CmSjAE?=
 =?us-ascii?Q?FHEEF+iwksLUIFghpGC6UMSyb5LEoMP6mpK3P5euR7yfEJvv5r6oi3ACWwOK?=
 =?us-ascii?Q?2DX8nVVu0FZHJ5V98UsCtnCg7D+zcF84BWQiV63ur7Tc4Zv/VOv/ZMjTjXN7?=
 =?us-ascii?Q?T5cGNs/nWH+lt0RZydr+uj+/3WfvD3FXnvbr5vlTjpXD9XajDvE8RqhwWxGM?=
 =?us-ascii?Q?xDrbPoKgn84ofz6q5rF9zmonfd/qSaDnk311bhPvDE8bIB40nvWA1tbsYXaj?=
 =?us-ascii?Q?TW8vm0u9xnOhZAyQI3YKfIKfOcBGxMJb2SMx0xr/7liSRfu4RRoUg4VkoxVb?=
 =?us-ascii?Q?3LoN1W3R1/CfkfmO8WYIqdMz1Hj3TJsuzh/nhbs6H7WDBDRUCmxvZ0LYXIFi?=
 =?us-ascii?Q?wIj2EyMmUFU12g5QEscxXMryVDI5cmq8zeeY6IWKfrsUq8kvQzqT0cV+smQb?=
 =?us-ascii?Q?VVGv0gDRVU+oTErPAFTcgwvvifuYDfHGuAPTPKBqJsFrOJsnONUv6WFTWBeP?=
 =?us-ascii?Q?6fRYs7XyDJJ48UHCxb0vDbBZlTI062z0vNcAdEfcG752SO22HtmdwpxHlq9Y?=
 =?us-ascii?Q?YJfhXdGyglW4f+GmnjSNv8RmYDPD/rCEevavLVBgdhA572Af9taRjuVoEadX?=
 =?us-ascii?Q?oRft8LHmV8kt18FPA1Y4N2FtkGFIe/irFPDa5srSMtU1A9wNN+um5WuCRwTM?=
 =?us-ascii?Q?fTq0fH0zcZqG9h9BSIw7TNUNtom5OcmTd1/7V41ih8L73Mp2Zj535BLCVMAn?=
 =?us-ascii?Q?w3sX1c/zUG+P4WKhSb4TzAuniFFf0ALzApNPGFdI5pUx2Uvw9zUU2KiGWAuM?=
 =?us-ascii?Q?Q36RFcRTKAL8AO6HklaydrrrAeknOz9Dh5xwgXNW52pB+xZ2pC87Eq6Ttudt?=
 =?us-ascii?Q?NBTkNUuq6iN47urM2dEFA6+vwzZTxcClcF+77jF5RioRhxdvbdt0tYx6GcoQ?=
 =?us-ascii?Q?4uIJWg4NiV8fsm56m7rTmGIOt//PD0HQMlgqto22DYzGzrTs7YmUEsjPEThN?=
 =?us-ascii?Q?JT2VLK3SPJ8SS+IvbVIe6vBXEaOtyA2E8r3QC7kcm2Ia3aox5bDlyNdVR+VK?=
 =?us-ascii?Q?LX/k7TPi+X5nxVDPwLWo8Ok1MgsjmW599cDGrvqGYqP2MwS/OAOfoOWvrdLx?=
 =?us-ascii?Q?f5ddCXvhIIp+RqyOEkpv8WW6MfLUYZvgo5sv+w7qhz/yOgWss4+pn/H6UXZV?=
 =?us-ascii?Q?x5ehayliq4twcj/pKst5L/NZOdzjxb9UmWKj+URho8FD+mnobFpkAfbaPygh?=
 =?us-ascii?Q?XziUcgmd44m2DUqvpdioBHlkInwwGxTCiWvcfNqz2zH8M67xJ/Hs1C1Y1NdG?=
 =?us-ascii?Q?/fi6R8leOaO6bLvMo2mE+lG7osJAbOIC+Bo2EWJH0lX+7DpxoNnp0NZd5P9E?=
 =?us-ascii?Q?AD2eqPjuBqYAOVyP1zJMiWbTlqwn9cP62A+D/hg+Vi6pyBvbZswCuoWP/QDi?=
 =?us-ascii?Q?Bw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 569ed9c5-5cad-4026-0857-08ddf51bb02b
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 12:22:22.7558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZNJEV52SQlfzhLvhDxOwWLnshIET6I6R2YEKjuNc5VYbs7S5428Tn6SaXWWXqJJlvH1oXjLoQiSPv8oiD5LElw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9684
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7A2AFA0010
X-Stat-Signature: 3qc5wwp3cfy4j9bhq7ius5ebr1jj4nji
X-Rspam-User: 
X-HE-Tag: 1758025356-977103
X-HE-Meta: U2FsdGVkX19Wp+z+wdedpkkEbSR7dWnWDhJEXdly8oVsKwlJct7/xARFE9ZD2sJ2jv6r/VZoYAdO4TUAuYHRlEOzpuSh0qGYVwU0exrOSzSxcXajt8EkKGbkTGaHZx9TLB65MAPuDwhr+0+wceABWEoNGGbVQPZ7Z14pZz2bsZ6pVbab65Cow3ykeUH81SNJu0mGKCHhdqj3/Mb6BWMSqkMzdOSpo21Vy2j+w9xLGWsteY8k2Msr1q2cKt1DGV5NChm+QnmdzKGBt4qDdSQEKhgYcSz5AeUmYES79xLl6ZkhfhHstNqCTk05Lfk/oOVBE2JWS9psKj6Oa3eK9BrZaFvivaNue7owndAMbSzbXDriijYne2XRfYUs+rTjKLb3bbKDfL8ZkdPa6C466ZTIMiP4k8V4kji9HvsVyY6dMncZDTIXbNFTf5OWDip35Bp5U+omshUX1Nd5nkvWC76Ee+2YzkSlo0SBBzGUxm8wU++D6jo7qf82qRN000f9E4RYN4vkMTwqv67XodsEd+9X8UkgNPUzG5zo5jtQApv651aCNe540d43VrKj03BUHptFE4XQ0qrL/WFv3ItPyhR+9CAdrZ8Hkqd3zeyQOmQNULwxKasqDUmoUi+F0gOUFEOKw/k31FbEB0bmg54Xqnfla0qELBswfA1AN7I9K6uPa4Kx2P9imPjuV7oQMLMArvkSh8DTyH3i8NsK2zg2tiybZQTeAfW821AXkUs1nMS5YP8SMYHBiBZMjAba+kWJMFutzJVBs+Rwa6U5Ij7yBsWNg5pOxEfyiyDY9bW/j7FgldMbaM9RQ5gljFg5XTAvxFCqpcv6KhigOFXsU5IsIAhxxmzBO2sgEbpoBQzxptaNtloGQX37nlZs+d9IwgGNBes0VZ7zYJ/uhAzMgtObuzufL3rRrtxAbG/cySXqRB7IYvV0wr2apm9gD6OU6/IVXGl+QWGlsIDU2m3EAfxWq1/
 aumIPhgJ
 4ZM0PlNhRDfUW53vL59ur2yfjLXiGTtFBqBoIA58fstCCEIbyR66+J4rhY2gT8M1OLIsF2EUsgz0g3SiB/8i0S1IiSlzjIf9huqyax2YxlhRvKyhhSboszpDxyDaakW5HM6pafyhNA7vN4FgFoDtGlssJSV0WJlasioX1aa1VNShN+kUw7WCw0fnPTY26mGW374A3Neuv90tq1kneGIboLVAPvYRLknW0evmXguFa+80SxYeev9UB/0ZluqdqFEpmtRa6QoEfUXGEikTRH+3jr6cOxubeiQyhvEdOozIeZJZxOQ2RNj6qF6YhJpyFJpbslwaQdzYy6H89K2/EBxuk4ezIYH2wOpjqpUPjOGHE8aAzJxBfwrgSsVfEAWAg9UmIMCHbWo+qBGsbcSzHMi1tGWJR6I5Dy0Tv1UKFxq6lxb5KUHObUi/itNTp7GMfNnucH+JINoASktz/KazKKNbPt/Ds9towIPpqCz5uWYDiiU2ke2/g82cTzqaP3Gx8Hd8cnT0HT9CLbG/AF7KLTJbN7ep4AX4DaU8Vh2a+IYGxrZXiWJka087zbpUizIcdIV3v2qe7BaF3mYBXqnO7CieKY4mpL5mKiNgXblqATV09q2uTkmQcJGz3z8Vw3ukXvO7yl5hUaI/5yKPxNvDeN69Wymle5dul78MoXZ0K
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Matthew Brost <matthew.brost@intel.com>

Add partial unmap test case which munmaps memory while in the device.

Add tests exercising mremap on faulted-in memory (CPU and GPU) at
various offsets and verify correctness.

Update anon_write_child to read device memory after fork verifying
this flow works in the kernel.

Both THP and non-THP cases are updated.

Signed-off-by: Balbir Singh <balbirs@nvidia.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
---
 tools/testing/selftests/mm/hmm-tests.c | 312 ++++++++++++++++++++-----
 1 file changed, 252 insertions(+), 60 deletions(-)

diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index 339a90183930..dedc1049bd4d 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -50,6 +50,8 @@ enum {
 	HMM_COHERENCE_DEVICE_TWO,
 };
 
+#define ONEKB		(1 << 10)
+#define ONEMEG		(1 << 20)
 #define TWOMEG		(1 << 21)
 #define HMM_BUFFER_SIZE (1024 << 12)
 #define HMM_PATH_MAX    64
@@ -525,6 +527,8 @@ TEST_F(hmm, anon_write_prot)
 /*
  * Check that a device writing an anonymous private mapping
  * will copy-on-write if a child process inherits the mapping.
+ *
+ * Also verifies after fork() memory the device can be read by child.
  */
 TEST_F(hmm, anon_write_child)
 {
@@ -532,72 +536,101 @@ TEST_F(hmm, anon_write_child)
 	unsigned long npages;
 	unsigned long size;
 	unsigned long i;
+	void *old_ptr;
+	void *map;
 	int *ptr;
 	pid_t pid;
 	int child_fd;
-	int ret;
-
-	npages = ALIGN(HMM_BUFFER_SIZE, self->page_size) >> self->page_shift;
-	ASSERT_NE(npages, 0);
-	size = npages << self->page_shift;
-
-	buffer = malloc(sizeof(*buffer));
-	ASSERT_NE(buffer, NULL);
-
-	buffer->fd = -1;
-	buffer->size = size;
-	buffer->mirror = malloc(size);
-	ASSERT_NE(buffer->mirror, NULL);
-
-	buffer->ptr = mmap(NULL, size,
-			   PROT_READ | PROT_WRITE,
-			   MAP_PRIVATE | MAP_ANONYMOUS,
-			   buffer->fd, 0);
-	ASSERT_NE(buffer->ptr, MAP_FAILED);
-
-	/* Initialize buffer->ptr so we can tell if it is written. */
-	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
-		ptr[i] = i;
+	int ret, use_thp, migrate;
+
+	for (migrate = 0; migrate < 2; ++migrate) {
+		for (use_thp = 0; use_thp < 2; ++use_thp) {
+			npages = ALIGN(use_thp ? TWOMEG : HMM_BUFFER_SIZE,
+				       self->page_size) >> self->page_shift;
+			ASSERT_NE(npages, 0);
+			size = npages << self->page_shift;
+
+			buffer = malloc(sizeof(*buffer));
+			ASSERT_NE(buffer, NULL);
+
+			buffer->fd = -1;
+			buffer->size = size * 2;
+			buffer->mirror = malloc(size);
+			ASSERT_NE(buffer->mirror, NULL);
+
+			buffer->ptr = mmap(NULL, size * 2,
+					   PROT_READ | PROT_WRITE,
+					   MAP_PRIVATE | MAP_ANONYMOUS,
+					   buffer->fd, 0);
+			ASSERT_NE(buffer->ptr, MAP_FAILED);
+
+			old_ptr = buffer->ptr;
+			if (use_thp) {
+				map = (void *)ALIGN((uintptr_t)buffer->ptr, size);
+				ret = madvise(map, size, MADV_HUGEPAGE);
+				ASSERT_EQ(ret, 0);
+				buffer->ptr = map;
+			}
+
+			/* Initialize buffer->ptr so we can tell if it is written. */
+			for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+				ptr[i] = i;
+
+			/* Initialize data that the device will write to buffer->ptr. */
+			for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
+				ptr[i] = -i;
+
+			if (migrate) {
+				ret = hmm_migrate_sys_to_dev(self->fd, buffer, npages);
+				ASSERT_EQ(ret, 0);
+				ASSERT_EQ(buffer->cpages, npages);
+
+			}
+
+			pid = fork();
+			if (pid == -1)
+				ASSERT_EQ(pid, 0);
+			if (pid != 0) {
+				waitpid(pid, &ret, 0);
+				ASSERT_EQ(WIFEXITED(ret), 1);
+
+				/* Check that the parent's buffer did not change. */
+				for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+					ASSERT_EQ(ptr[i], i);
+
+				buffer->ptr = old_ptr;
+				hmm_buffer_free(buffer);
+				continue;
+			}
+
+			/* Check that we see the parent's values. */
+			for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+				ASSERT_EQ(ptr[i], i);
+			if (!migrate) {
+				for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
+					ASSERT_EQ(ptr[i], -i);
+			}
+
+			/* The child process needs its own mirror to its own mm. */
+			child_fd = hmm_open(0);
+			ASSERT_GE(child_fd, 0);
+
+			/* Simulate a device writing system memory. */
+			ret = hmm_dmirror_cmd(child_fd, HMM_DMIRROR_WRITE, buffer, npages);
+			ASSERT_EQ(ret, 0);
+			ASSERT_EQ(buffer->cpages, npages);
+			ASSERT_EQ(buffer->faults, 1);
 
-	/* Initialize data that the device will write to buffer->ptr. */
-	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
-		ptr[i] = -i;
+			/* Check what the device wrote. */
+			if (!migrate) {
+				for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+					ASSERT_EQ(ptr[i], -i);
+			}
 
-	pid = fork();
-	if (pid == -1)
-		ASSERT_EQ(pid, 0);
-	if (pid != 0) {
-		waitpid(pid, &ret, 0);
-		ASSERT_EQ(WIFEXITED(ret), 1);
-
-		/* Check that the parent's buffer did not change. */
-		for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
-			ASSERT_EQ(ptr[i], i);
-		return;
+			close(child_fd);
+			exit(0);
+		}
 	}
-
-	/* Check that we see the parent's values. */
-	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
-		ASSERT_EQ(ptr[i], i);
-	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
-		ASSERT_EQ(ptr[i], -i);
-
-	/* The child process needs its own mirror to its own mm. */
-	child_fd = hmm_open(0);
-	ASSERT_GE(child_fd, 0);
-
-	/* Simulate a device writing system memory. */
-	ret = hmm_dmirror_cmd(child_fd, HMM_DMIRROR_WRITE, buffer, npages);
-	ASSERT_EQ(ret, 0);
-	ASSERT_EQ(buffer->cpages, npages);
-	ASSERT_EQ(buffer->faults, 1);
-
-	/* Check what the device wrote. */
-	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
-		ASSERT_EQ(ptr[i], -i);
-
-	close(child_fd);
-	exit(0);
 }
 
 /*
@@ -2289,6 +2322,165 @@ TEST_F(hmm, migrate_anon_huge_fault)
 	hmm_buffer_free(buffer);
 }
 
+/*
+ * Migrate memory and fault back to sysmem after partially unmapping.
+ */
+TEST_F(hmm, migrate_partial_unmap_fault)
+{
+	struct hmm_buffer *buffer;
+	unsigned long npages;
+	unsigned long size = TWOMEG;
+	unsigned long i;
+	void *old_ptr;
+	void *map;
+	int *ptr;
+	int ret, j, use_thp;
+	int offsets[] = { 0, 512 * ONEKB, ONEMEG };
+
+	for (use_thp = 0; use_thp < 2; ++use_thp) {
+		for (j = 0; j < ARRAY_SIZE(offsets); ++j) {
+			buffer = malloc(sizeof(*buffer));
+			ASSERT_NE(buffer, NULL);
+
+			buffer->fd = -1;
+			buffer->size = 2 * size;
+			buffer->mirror = malloc(size);
+			ASSERT_NE(buffer->mirror, NULL);
+			memset(buffer->mirror, 0xFF, size);
+
+			buffer->ptr = mmap(NULL, 2 * size,
+					   PROT_READ | PROT_WRITE,
+					   MAP_PRIVATE | MAP_ANONYMOUS,
+					   buffer->fd, 0);
+			ASSERT_NE(buffer->ptr, MAP_FAILED);
+
+			npages = size >> self->page_shift;
+			map = (void *)ALIGN((uintptr_t)buffer->ptr, size);
+			if (use_thp)
+				ret = madvise(map, size, MADV_HUGEPAGE);
+			else
+				ret = madvise(map, size, MADV_NOHUGEPAGE);
+			ASSERT_EQ(ret, 0);
+			old_ptr = buffer->ptr;
+			buffer->ptr = map;
+
+			/* Initialize buffer in system memory. */
+			for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+				ptr[i] = i;
+
+			/* Migrate memory to device. */
+			ret = hmm_migrate_sys_to_dev(self->fd, buffer, npages);
+			ASSERT_EQ(ret, 0);
+			ASSERT_EQ(buffer->cpages, npages);
+
+			/* Check what the device read. */
+			for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
+				ASSERT_EQ(ptr[i], i);
+
+			munmap(buffer->ptr + offsets[j], ONEMEG);
+
+			/* Fault pages back to system memory and check them. */
+			for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+				if (i * sizeof(int) < offsets[j] ||
+				    i * sizeof(int) >= offsets[j] + ONEMEG)
+					ASSERT_EQ(ptr[i], i);
+
+			buffer->ptr = old_ptr;
+			hmm_buffer_free(buffer);
+		}
+	}
+}
+
+TEST_F(hmm, migrate_remap_fault)
+{
+	struct hmm_buffer *buffer;
+	unsigned long npages;
+	unsigned long size = TWOMEG;
+	unsigned long i;
+	void *old_ptr, *new_ptr = NULL;
+	void *map;
+	int *ptr;
+	int ret, j, use_thp, dont_unmap, before;
+	int offsets[] = { 0, 512 * ONEKB, ONEMEG };
+
+	for (before = 0; before < 2; ++before) {
+		for (dont_unmap = 0; dont_unmap < 2; ++dont_unmap) {
+			for (use_thp = 0; use_thp < 2; ++use_thp) {
+				for (j = 0; j < ARRAY_SIZE(offsets); ++j) {
+					int flags = MREMAP_MAYMOVE | MREMAP_FIXED;
+
+					if (dont_unmap)
+						flags |= MREMAP_DONTUNMAP;
+
+					buffer = malloc(sizeof(*buffer));
+					ASSERT_NE(buffer, NULL);
+
+					buffer->fd = -1;
+					buffer->size = 8 * size;
+					buffer->mirror = malloc(size);
+					ASSERT_NE(buffer->mirror, NULL);
+					memset(buffer->mirror, 0xFF, size);
+
+					buffer->ptr = mmap(NULL, buffer->size,
+							   PROT_READ | PROT_WRITE,
+							   MAP_PRIVATE | MAP_ANONYMOUS,
+							   buffer->fd, 0);
+					ASSERT_NE(buffer->ptr, MAP_FAILED);
+
+					npages = size >> self->page_shift;
+					map = (void *)ALIGN((uintptr_t)buffer->ptr, size);
+					if (use_thp)
+						ret = madvise(map, size, MADV_HUGEPAGE);
+					else
+						ret = madvise(map, size, MADV_NOHUGEPAGE);
+					ASSERT_EQ(ret, 0);
+					old_ptr = buffer->ptr;
+					munmap(map + size, size * 2);
+					buffer->ptr = map;
+
+					/* Initialize buffer in system memory. */
+					for (i = 0, ptr = buffer->ptr;
+					     i < size / sizeof(*ptr); ++i)
+						ptr[i] = i;
+
+					if (before) {
+						new_ptr = mremap((void *)map, size, size, flags,
+								 map + size + offsets[j]);
+						ASSERT_NE(new_ptr, MAP_FAILED);
+						buffer->ptr = new_ptr;
+					}
+
+					/* Migrate memory to device. */
+					ret = hmm_migrate_sys_to_dev(self->fd, buffer, npages);
+					ASSERT_EQ(ret, 0);
+					ASSERT_EQ(buffer->cpages, npages);
+
+					/* Check what the device read. */
+					for (i = 0, ptr = buffer->mirror;
+					     i < size / sizeof(*ptr); ++i)
+						ASSERT_EQ(ptr[i], i);
+
+					if (!before) {
+						new_ptr = mremap((void *)map, size, size, flags,
+								 map + size + offsets[j]);
+						ASSERT_NE(new_ptr, MAP_FAILED);
+						buffer->ptr = new_ptr;
+					}
+
+					/* Fault pages back to system memory and check them. */
+					for (i = 0, ptr = buffer->ptr;
+					     i < size / sizeof(*ptr); ++i)
+						ASSERT_EQ(ptr[i], i);
+
+					munmap(new_ptr, size);
+					buffer->ptr = old_ptr;
+					hmm_buffer_free(buffer);
+				}
+			}
+		}
+	}
+}
+
 /*
  * Migrate private anonymous huge page with allocation errors.
  */
-- 
2.50.1


