Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2E0FCF45D5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 22:23:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D87F6B00A4; Mon, 12 Jan 2026 17:23:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 382636B00A5; Mon, 12 Jan 2026 17:23:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 268346B00A6; Mon, 12 Jan 2026 17:23:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 161466B00A4
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:23:49 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AE61E1AF495
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 22:23:48 +0000 (UTC)
X-FDA: 84324740136.30.02B4027
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012020.outbound.protection.outlook.com [52.101.48.20])
	by imf23.hostedemail.com (Postfix) with ESMTP id A8E4F140009
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 22:23:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=iOYm2VqL;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 52.101.48.20 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768256625; a=rsa-sha256;
	cv=pass;
	b=gp5vmT75o4xX/NRZo9KIrNjYPrFmtr68tfW0//ReL45H+CS2FK+Z7Vaep521I5fVrq5KGf
	krupzp/it8/ah5W73i4yNtGGO8UrvK7248vI0jFgij5zCVzv4BgAiVCdU7vKX7fp0hxfDx
	hpmhKCFsgioi5mUXVENP4A7o9Vh2VtI=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=iOYm2VqL;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 52.101.48.20 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768256625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hx6OO7oxE3FMPUKqk2IrZ8bQ2upvJOuH8wLpZhhRTX0=;
	b=j2XWpd4ZZNjN3xC7DJyPjW8PBaDE4x7bB6TXyuUNiRLp5c0M+cwc8CxGZqtGhPXYE+EXwj
	l/GeQR+aHxDJHfJNgTnKg9k73WXpOLDCSw6y8qJQzoHzQCwjjfAy2KH4n0XgQgeQmnjgDf
	+wHgHyhWyZNNdIXIiuyZ/oSbqalFZoI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T2JUqYgrGtOknJWln71fQ3bhN8Rk7glLdAJX+4FwTXHzZZE9KutBDs/brAbN5vPOm10UTMmrtuXsjBlW0Lmz6mryAnCU+iR46SM3N8jUSB/THNuhAVjx71ORdD7K6sAuDJynVGMGsuwUJWyq2jCsnODJEOyYzmyTg9yZm5UWSvv4EFQwxXKQwwLgfqtZkgDPNoKUUbhvjAqKILpzUay338IFi62hMu0W0EpNR4jFrFSPJW1+AQnk5xXIPYsTXKVPR8i/sibo0taDOiujaYwbR6NNO8hA54BaTecucA/8lg3HrmHGa1h3kuUgGm+5SgSCfG87dtSwpqRyqyYfsOgbnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hx6OO7oxE3FMPUKqk2IrZ8bQ2upvJOuH8wLpZhhRTX0=;
 b=fBfwKboxnyZHByeUK2+oBWQISKkzmXK5ka4lt65Tzc20hFCsqf71dXDO6mCRtiS9lm6+jcXbU+GMMZx/uZLNlBKKcqmzgO9drPTGHZNxXXrZ1mAbCCDF8g3iVUb2p2Mf3A7Bzt8Pyvhcf4rYOvRJB7l6VobrvQQJOReUSyDiba1af93+KlIP0f5ArgD/lKDqE1b12+KnKQJa/KyhfeUNILajHylTwVx91LNLJs6/Cf0RibuAscOodvQ/2AG7dmZlD0IE6jxjzkroRqsOItX2P5FeEeqTkXsVPaN1pKhY/iI5dTu+TZwj8NQJe+ZMs9+0Tpd5g7K+Uw4dOFdAv2W6PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hx6OO7oxE3FMPUKqk2IrZ8bQ2upvJOuH8wLpZhhRTX0=;
 b=iOYm2VqLMas09JNAROTyalqAPdcUf7gozAzS3sS9tzI3OEnLdDfJOhXAmfZ3Z/Ju4jXl+bIPqfkqOVryjnHxpioBOGhWARn2Bc2XUW+5iibfMfEJW/rIH637LdWhuTiyTptJb0V4ZNohQcBw0J9J8z3kfOzlrbrP99f52vHY06s=
Received: from CH3PR12MB8660.namprd12.prod.outlook.com (2603:10b6:610:177::5)
 by DM4PR12MB6085.namprd12.prod.outlook.com (2603:10b6:8:b3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 22:23:42 +0000
Received: from CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::222c:662:e585:3404]) by CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::222c:662:e585:3404%4]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 22:23:41 +0000
Message-ID: <2f9b180b-c221-4631-93d0-c131332ef178@amd.com>
Date: Mon, 12 Jan 2026 16:23:37 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/memory_hotplug: Add support to accept memory
 during hot-add
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-coco@lists.linux.dev, x86@kernel.org,
 linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, kas@kernel.org, ardb@kernel.org,
 david@kernel.org, osalvador@suse.de, thomas.lendacky@amd.com,
 michael.roth@amd.com
References: <20260112202300.43546-1-prsampat@amd.com>
 <20260112202300.43546-2-prsampat@amd.com>
 <20260112130401.a857fac6abcf104ea9bb5c68@linux-foundation.org>
Content-Language: en-US
From: "Pratik R. Sampat" <prsampat@amd.com>
In-Reply-To: <20260112130401.a857fac6abcf104ea9bb5c68@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0007.namprd04.prod.outlook.com
 (2603:10b6:806:f2::12) To CH3PR12MB8660.namprd12.prod.outlook.com
 (2603:10b6:610:177::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8660:EE_|DM4PR12MB6085:EE_
X-MS-Office365-Filtering-Correlation-Id: cbe85e5f-2bbc-45ef-8047-08de52293db6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TmtxUzZ3bDFkSlg4cVRJOWdMdGcrK2NGZ1FrVGtBeVFzV0xncDlKRFJmTCt4?=
 =?utf-8?B?YUljUXZPYVdlYW5GaWloRzNMZHBXeTlGdThSZEJSNWxKM1IvemtGM1FZWk9y?=
 =?utf-8?B?dndpRXdJZlhRY2pOUjYvQXJmMGp6Z1ZwWURPeHpocytad0xRV1RmMHNrVElR?=
 =?utf-8?B?SDZvNXU0TWRNdkM2cFllUHJtSzBHQVRVb2p4RCtLbFN1MXkvWmdXcXRPQUhC?=
 =?utf-8?B?MGlNRGI3cCthTDJ1VkNhWncrRTFNSVUxSFZJM1pLMlF3emMwTC81eFlsbDJn?=
 =?utf-8?B?bEhkUEtJY1ZrZmUyS2l4UVgyYVRvaXppaGJCTno2NjVBdEUxVy9KZm9CT0N0?=
 =?utf-8?B?aVhFMFYzOTl5akI5dlR6ci9jaXNWSE94ZmdyV2dlcmszRnlDMU5ubEI0TUxI?=
 =?utf-8?B?R2o5Mm9aZ2ZkanZCek5kWDdMSnJqSDdaeEpZODlqUm5pVlhMZGczelZ4Mmk4?=
 =?utf-8?B?WFRWN0t3NWZGQy96bkRuYlpaS3JLaWRxV2I3cmVNSXVOUVBZRjMwUWltaFpO?=
 =?utf-8?B?Mk43aXk5M2w2aExmVU9SWWxKSFRPVUN5QjRMSVZ0Q2JTSDQ4ODZkK0cvRXNP?=
 =?utf-8?B?ckdsd21HVXBHdkY3MCtLcFBCSTZ1dHp6Nno2bXNmOTRSdGhGTUNYRUxnSWtG?=
 =?utf-8?B?bkpWMTRJZ1BjMmRMNmY0MFdUNGZYdXh2ZXBmK0FwbmpEekJkSjZXcEVaUjdV?=
 =?utf-8?B?VC9EWS9kT01RdmsyMS91NjlJQjdNR0VnN0FhS1d5ZjJYQjVCRTgxRnZ1Qnl3?=
 =?utf-8?B?NU9VOVdLUGZTSWJPR1pwS2N5d24vQXoxQXBMKzhmcDBtTlZ4Z0dUS2tLZklm?=
 =?utf-8?B?eWRIelU1RWUrdGlpQnllak01SUJoeHlwbDV0bVVRVy9RQml3ZjJUd2NuWTFM?=
 =?utf-8?B?TnFYQnVhVHEydzhpemg5TFhxYlM1ekpFNjltdUdqSjFZSnU2QUtOV2Y3VlI0?=
 =?utf-8?B?alI1eCtFLzdoNzF2YnRGVkh3WFdMTXBZQVUwTkFFbExEbGk3SDMzQ05HWUhM?=
 =?utf-8?B?OWk3TFdrQnY5MHRUK0I2YkQrb2gzOWY2N29YUmlRTDFYTXFSVFJtREFGZ08v?=
 =?utf-8?B?Y2NidmZNU1c0b2xtRm8zN0NMUitBckZ2cWNIUjhqbExaV0o5a0E3aWRBaTV0?=
 =?utf-8?B?Tld3OVFoaTk1c3JRdUdzdUYxazdBV2x3RFBUYzFvbS82WnYxR3FTeXlwZmVR?=
 =?utf-8?B?QlB2T2tyT1I0aGI0ODIrbWdxYlQxeWkzdldNWVdvRVdVV2lKdnRFREJUYzBV?=
 =?utf-8?B?dE1IblY1dnAwL1o1K1BwUG96NkdWd2tLQnF4VFBORGV5UWV5OVhjNFQvMmxy?=
 =?utf-8?B?WEZMRVh6L0ZLZUdnaGFrOFVpb2hnZ1FiU240c1Q2b0tHNWdNQWFKVkpndlJx?=
 =?utf-8?B?M3ZDN1BhbTE3Zk41aXVkNFpuaGl4WDN5d3hkbWRyQ1ByeXlYdTljaWozS2lv?=
 =?utf-8?B?cXNLUFMrZWdBRXFTbVhoVnNWa2N1NURMK25CaDBGNHk1aXVSMDROU2tpckNF?=
 =?utf-8?B?ZEpPUk1TMnZtcEVpWm5oSWFtN1o2SmVSNnNyRE1mNXFtSXljcUpiM0xXSDVO?=
 =?utf-8?B?NVZ1YXFMZkl5NS9CZExYa2w1VmdsL3hsd056dHdJQ0dTblU3eFhLRzBFVTNx?=
 =?utf-8?B?dlY3ZDdxaTVobnhhUFU3Qnl2RkNrS1pBVUdRUmY3Lzkvb09NYmlKZ3pRanlZ?=
 =?utf-8?B?UDRZV1JvNmZUSGJXN2V1QThSRjUzaW0wVFBPRWY4Q3VodGx0L01tUGpSRlZT?=
 =?utf-8?B?ZGpJVk9yMkx4T1h4eURCV3JaY24yaVVlVGRqTTAxSFFIOFEwQXVJR2paU2dM?=
 =?utf-8?B?NXpWVnpPL3J0SDB3OFRxSnh2QXVkMGZHUnVjRU13a2wyNFhlQUcyVmlsYnZR?=
 =?utf-8?B?K0FuOUZ6R1FGelZmTDFKeVRtYzZMQmoyTDR3TC9XYnhYeFhYQWVVNko5cU5v?=
 =?utf-8?Q?A/BxTLE7APKzJx8XrdIuAAf1gBwUabnU?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8660.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d3pMeXRLVllOcmhEQjVpU1Y4WE9neVllRGZuNTlEMGc2eUlxOUFVdjh5SFAx?=
 =?utf-8?B?UFlWNjhTYkxzU0ZlZFZKZzJvbitEQmxleENzbHl4RGJJa2Q3U2cvSVBxRS91?=
 =?utf-8?B?S05iNlhXeld2Q3FObE9JQm00d01UK1RJdW5FWFM0MjBBZDkzV2lHQ1lId0RG?=
 =?utf-8?B?V01ST0dBZkV5a2VISitNV1BHWGZ5Q1Y1L2VrTmhsYlhqZ0F5T3didkViZFUr?=
 =?utf-8?B?aHlJb3FoKzBURGJqWll6KzVUb1pYUUducGl0M3BKWWFaUDhFbDg0a2FwelBk?=
 =?utf-8?B?dEhMeVVxdkpmUmd3eGlydTR3ZE5LbXhqeVh4ZWg4L1VEcm41QkM5RVEvWVcv?=
 =?utf-8?B?d0hHNGJOM04vWUcwcGpFOEZkbWlTRUlQUnRJeE44dlBzZEZMN3FLQjExekFV?=
 =?utf-8?B?QTk2V3hQMDlDTFVSY2dEUElEWUxwVkQ3UHRyUk4rRXpockRyaDlKUVp2TlhE?=
 =?utf-8?B?eFl3eTNVUC8vbTlFdFpyQ0p4Z1VyTUdtd3FGbUFZbG11SjhNK1BnOHBqek1Z?=
 =?utf-8?B?ZTBlaGk0ZzlYS1Urc0JzbmVndld5eDgxcVlERGJwL2FaVHJoZzdZWWVFNmsv?=
 =?utf-8?B?SURRSUJzcis4S3dNdWVrYlpTL3FSYVFtQTQ3RmwzZnJqdUtyZWIzM1ZTbHVU?=
 =?utf-8?B?WDQ3eStWTWxrQjg5OVBCNk1wcjNJYnJKSlBkWUdxNUJFQ1h0VEpoNmdwTDlM?=
 =?utf-8?B?bzVuTkFlNzFhRmozeWlKc1RHSnlHU2RZaGUzNEh3eFRiNVBhSWc0clF4Y25X?=
 =?utf-8?B?L0N4Zkk0SWtoU0liN0lRTkdqZDZtNzVvMDZYaFg0UnNvdDM5dGIvNFNOUi9L?=
 =?utf-8?B?di8rcmUydFFjNTBnNGtrOW1DcUhWb29paXh1N3VYYXdXbTFEN3RKMW9sVkFt?=
 =?utf-8?B?RnppRkRDUFFEaHVBdjUyaVlRcTJ2eWVpSjZ1VGkzdDc3aEJvbko5ZXpZOFRO?=
 =?utf-8?B?SGJqcnAzNWhCTWk4VzdjNjc3eDRlemhYRmdHdy8xQUVGZFh6R3g4c3NGTHdW?=
 =?utf-8?B?QkpTOFA1eVFaWjRSdEF0WTVTK2pTVWk0RFdaNnF3UkJRaURYT3YyNmsySnFW?=
 =?utf-8?B?RDBxRVZMVlIzTUg2akF1ZkZOOCsyZVRkSEVJRFo2MGpWcmhOb3RpUFBxNGtr?=
 =?utf-8?B?KzA3ZlJIM2l6UjJHSHplbFQxRjl1QXltcTVpdmpvU0tWUTJVQXNaT0VzTmt5?=
 =?utf-8?B?STNuRkFPVWhaUWYydzd2WTNMVzJ1cE1NZFdXemFjeVE3VGw3VW5CNlpMUHNk?=
 =?utf-8?B?NzladjBQYWViVklHZnY1Yk4ySU9mdEZ1UjlqKzZQbzlBemtyYUtKQlduK1Zp?=
 =?utf-8?B?dXJIZ1lNb0pjTkFuQ3lBU1lqUSsyWDl5aTRhU2pDclZsYmNyRTBOMG9PQ1li?=
 =?utf-8?B?YldrOWpSbGxjSWNFdzlERk9yUmVyVW41L3JwdEM1bGIrV1NtTlVyelFyekUz?=
 =?utf-8?B?ektUNmRMS2phK3hvL2VqVWt6Z0RPU21kdzVHNEsvaHh4WWk3SUJRN3NRZzNt?=
 =?utf-8?B?R1NOeDN4V1ovMGhpY1JReUpGRjAvajVnUlZUMzArU2ZzeUF1ZjAxbnVIc2tR?=
 =?utf-8?B?SWZsQUE5YmpidHF2d3ZKdkFIWklxOGUwSWVRbm8zVTFLTjNsUEJDWUJZdWps?=
 =?utf-8?B?c1RsTmltRVFPc0FHS2pkeUo5aVFyVFJZajRWWkJtVWN3VFdVd21XSll6TWQ5?=
 =?utf-8?B?dEJ0S01iNDNiVU9ZMGp6YlVwOW9BOU5UZXhOejFKZnlnOHorY3B1cGNDdXlj?=
 =?utf-8?B?azk4T2cyejZ6VEVBNzI1L0d5TVd0K3VvOC9ld1hYdjA1OUxUS2dONGtUc3Q3?=
 =?utf-8?B?RkpGWFFkamVhSm5CTi9IZ3VvS2FMZkYvS1NjTVBnZUhhVGhzcndlb0NkQnEv?=
 =?utf-8?B?a2hoTlU4d0Z4RHhnWVUxUDkwY2hnU2dHSDZVZ2lRV1FJcFlncTBuZlY3TlIr?=
 =?utf-8?B?cmNhdDBYdzY0WXljRm00RTZOdVQwVjh4T1lRYTFXTk9zZ1FQK3BEOUlyY3pu?=
 =?utf-8?B?Z1NLNlQ4Vmk3RVZnWU13OVJla1FSdTgrVWFOU2RNSHpvbERuZXV0c0UvMHh0?=
 =?utf-8?B?dTdSMkhtVUY4ank4T0xCMDMvQnhXcVJaS09vN0ZVbjhQMXkrV1BDbkl6THBN?=
 =?utf-8?B?QktIK2FvQ3FKTGFnd3hIcTFqK01oQWhUL3A1U2s4RzZNRCt2TUlYVUtZQmQ1?=
 =?utf-8?B?TDE0NThySTRvNCtldENGUkUvQ3ZNNUJTNHA5QUpFYzgya2dzL3UwendmdzVp?=
 =?utf-8?B?R0RBSEpJd09OU1M3RW9sODVEQko0cjg3V2hmbjUwZTQ5UFBSaGFWZ3kvdkY1?=
 =?utf-8?Q?pFXo5DHRnJ1HIif2uz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbe85e5f-2bbc-45ef-8047-08de52293db6
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8660.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 22:23:41.7860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XFwCrUUhMoj2KfZbdC9AA/DwxPqEkSSkXAABo2ZpzBCTG9z7WFqyLIHzyWMGyts1eOxAaz/iiB8NVKIojsGvwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6085
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A8E4F140009
X-Stat-Signature: adzxn1t6inn9a1auc6zbaji8xojmsbf6
X-Rspam-User: 
X-HE-Tag: 1768256625-231758
X-HE-Meta: U2FsdGVkX1+cvwLZbdPH3wuBHE3CUDg/wUsWcz139GQQpIm5wtEzUaASmRW9O4rCnYl6cMAr5G6BYrZ7pQ9D8XVlHjnhVa7m+oz40DBT7WIrTZhKrfYQpoI5YyixCOqCVJs2Qe14PXEosqGjYVDwGvt3eWpw0McQoot45T19YN5okEss9s3muLccuKcTS4O55mEh62sbt6JpO5lppsTE8ablGDaq/JwiteEeRIelfMK1kI5ufupoapdDJ1vXrjDjuBBLmB6i3omkUiwaxUEun3icSp3rLvyiXLWFzdWEI140haOWZchb4d/OlcaHVz11r4Pm1AkMJFIEoUGu4dkBpld7VSRy/tMQc2kBg9kOIknCwWzsq2liy7o8nFU+Mf+RSgwllO2W9wcN/OnCtvzLq6w4Xui78T26vETU2/EY4ptuxriwderUfhipYQGPzHh1UhS/UWQLqJHV0cEEh+r7r1nejJkzumTTQsoZUIN9FCk8nHC/AWKxhghic/7GJjtYYf8lPIMfsIYpSQ1KAg8SU9yg2rgnY/c3XOzTsbU4Ibd1AYUGZ+GuNEB+/HdvJsZ6Zx4H13YsqvgwwXLIGmr9F+iDCqx+qt0rzs9f8MPkbKDMXLqtaft/zJ3EsJxwbGpV63toWH3uEl+xQdK/rLUroArwPyy6ezPUZqKhLUlqyznprv1b0Eve9uTv3+/fXU0+TKeAjkzLP1hW/uQCdocc9BBnYXZaogQ/qPNvNMx2HlM1Y5DdyX5F3Pz82x8T0MBZVsQU5d8KRPCrg/1uBsp/b4eBIPVCDIXfm0m8MTai2a2nuFXLufccC4dPWJ/tbCL4d2fWC+uCa2mcCPluGxpbi8if5wp25AHr0GqjsXr9R17VzsKvzzxHW/ijScUnl4LAyQRh++/3JX0h7h4nmzowf4CiRbekrACrO+IZRo3BmDcUrIzCQjqzhhSIJSFNdfRdgCH3qANaofoiYxzsZmg
 o31/7tf2
 9kwEra8rg2VE97unOATz9a7mkLExqqhGgINq+XgpXnsqzXHvtSyN9Lhkqlh7QJ5p+8F/jKZ5Gs4lRg0pVoZr0rHP/YOwyDMN32rHmyl5YszSFRW92HcV4CzPVrPwFBCs8pyHQLbdlOF58Ux0Zj2UgYmXwLwyD+Al0FOw/9MGqQoGJFA2fiwb8wF+rd0sn5RsTZ8F9TaicXShJd9pSV36hyF6YFurThTFMMXAs5Nn9GSCn8xEP84oI7flLvbztdZw0NloiAsMtmt48Vokd4sY+pZiNnUq8X5yU/XJnEuLzRAQj1nysP1vPVV/ToIkT128dnH7Lzo85Z53rhdgndpUiTBUg+OR74Jf9vOC23Bz571pGW0hxhUVHu74CJYBKRaV7jHRqZBeAbUBph5J47oQQ0gI/O5QVDO3zbYde7VlYrgLXtLv59xCrnyaUvwjYSaTWvqYbfl1deCTMefF5YXRT3ygNjB9UAaCaVj+M3rsNRsEmv5YWeoR6A4CrZFUKKAZNCDBUVHm5jfUhxLccf408ENkwVoFRLumENyhrt+eW+FxBTwveKoTbcTiHuAoXUxUWghlj2uMUE2q/udTATnDebCyaQB2XNW01MridsNXVtrZMQGFIAKgEqHdctdocHdOIeY5bySR8Iu28JWr789g/yZOGJIqaQFqfOit8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/12/26 3:04 PM, Andrew Morton wrote:
> On Mon, 12 Jan 2026 14:22:59 -0600 "Pratik R. Sampat" <prsampat@amd.com> wrote:
> 
>> Confidential computing guests require memory to be accepted before use.
>> The unaccepted memory bitmap maintained by firmware does not track
>> hotplugged memory ranges.
>>
>> Call arch_accept_memory() during the hot-add path to explicitly validate
>> and transition the newly added memory to a private state, making it
>> usable by the guest.
>>
>> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
>> ---
>>  mm/memory_hotplug.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index a63ec679d861..8cfbf0541430 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -38,6 +38,7 @@
>>  #include <linux/node.h>
>>  
>>  #include <asm/tlbflush.h>
>> +#include <asm/unaccepted_memory.h>
> 
> This only exists for x86!

Ah, I missed that entirely. Thanks for catching that.

Probably not the best option to have a generic unaccepted_memory.h as well.
Maybe, I should have arch_[un]accept_memory() definitions within mm.h wrapped
within CONFIG_UNACCEPTED_MEMORY instead so that its cleaner.

> 
> Otherwise, the mm/ changes are minimal so I volunteer this patchset
> for the x86 tree ;)

Ack!

--Pratik

