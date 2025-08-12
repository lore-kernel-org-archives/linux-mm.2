Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C930ACA0ED1
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 02:40:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FFA98E00AE; Mon, 11 Aug 2025 22:40:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B4E48E0045; Mon, 11 Aug 2025 22:40:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1506A8E00AE; Mon, 11 Aug 2025 22:40:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC0C98E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 22:40:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 990A914017B
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 02:40:34 +0000 (UTC)
X-FDA: 83766551988.07.2A561EA
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2042.outbound.protection.outlook.com [40.107.220.42])
	by imf13.hostedemail.com (Postfix) with ESMTP id C32CC20003
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 02:40:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=tAZRqEdX;
	spf=pass (imf13.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.220.42 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754966432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=pvshuiX9AHNai8LBB1yIKl8N+GR6Lxj+xyxSogLOnNE=;
	b=UFPpLiq05mlnmUJnwKUslT4kk18Aqm37vPhNbvxAdl75qrDNeVohUR1oLCbY5LQ9Y0e64w
	s5NXDilThKLiIGhZUIZQZBigySK72jvtV7acaYpF3t7TKblpWdvgbdL/XUIBGHJOMh/H9w
	gFbVQmi5uNLy1KRyGHnWvKsvv96k7Jk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754966432; a=rsa-sha256;
	cv=pass;
	b=RTYSvUQqBXqs7D3hi/Ct5ZeIlo6VlC/HPl3IW8g4LO27LZ3l2/c0O1sX3pJMTiaHx+fm40
	RRiI+LXD35ap/rZun5RnTKhfQJabL8tONnGw+tCS01t6PHjlQqDK+JuTUXfldSl3agsWU4
	2ZEwrPKvR0VX8vf5M+TXIa349el7WL0=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=tAZRqEdX;
	spf=pass (imf13.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.220.42 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RH55tKweJs0qbT8UUiKR9CAV3B6nzo/X5ctXfmjlTXTkFSW+yOzebGjyC+g8IP80TtsnhzNf+3enoYBo/RYq6zs2pTbXG3b2mFw6TDi2yPxudUhEuP4lFY4GCc2YL/zKNE0L4fVPWMnygDjc18tDxNNsQCE6uqnHAPjFvua9b9DTQ0ht+7vQmOcqrfZs6akJsnxCzZWo9NIF2Z+6kJp775++PrOD3NBrB906JTwsA6wwtOHKrpvVijkW5XMIFULz5773wSq+sIQ1V1MQDcGBUvEX38NwPGLhDp672mLbcYXB2X/TeUN11e4rP8ZVk7lgcoFhZr5yMAEE9zMjX+l4PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pvshuiX9AHNai8LBB1yIKl8N+GR6Lxj+xyxSogLOnNE=;
 b=spwB5u989/7/8dtHEIO0WW6kbjfz1/BPoUBvMCEGl5dHcxI/viUO4A1woeCoBCDa/1UViKLzUlmkL5G1PJsao6AwZsWPpJB0VLWVw6WsO4oooyrJksoWnOX4SurD/xkyauqsi9gKw52WlEnPTejbPUMtClgxUwAOBLxyIj5X87AIcfv9xVvfkCgxJcm6rCj0/wLEIw9Y93b0n2KetGCpOFq3A7+h4WrXe+PRZP/Q/QL3e6coeilBzRhMqq0Omsw2U4cZJgMBW1GIuwTIfn+WfRftfl5XktFQjTEa9573lGsOXr3lrXIhg4zC3lRPsPhklwK1CsmSoG1Yo04eVwLDYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pvshuiX9AHNai8LBB1yIKl8N+GR6Lxj+xyxSogLOnNE=;
 b=tAZRqEdXC2WKQ1wGB1LxIZnFS7r9O9o+Jji8jFEUVN/I1BzTSjbwIsGmCkcWLLv1lKsLpdz0JJopn74v1z+w3Y90KMVzFOaTiTKd1HbGZGkTs+ON4Okfvn2DnHdMkEdz5L56+drIKgooDQTBfP/FWNEW+Z1x/tbDWNaaSZJa32nzDnqTAr3IVdgejRgWYZpaZWotNirUV8fqJJ290eXXxw0gey88PqVu/cff+P5B5FsRaOrqrr4646cLBlq/L+Di9JOD8AtY9U7X3xXTMqY7y/y8Fr2xsMeBOtAiimWOYvymGhEj9Sbm9w4EywpliKRq7HZKpCJTvmGGQz/Ci3tvGg==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by CY8PR12MB7172.namprd12.prod.outlook.com (2603:10b6:930:5b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Tue, 12 Aug
 2025 02:40:28 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%5]) with mapi id 15.20.9009.018; Tue, 12 Aug 2025
 02:40:28 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [v3 00/11] mm: support device-private THP
Date: Tue, 12 Aug 2025 12:40:13 +1000
Message-ID: <20250812024024.690035-1-balbirs@nvidia.com>
X-Mailer: git-send-email 2.50.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SYBPR01CA0005.ausprd01.prod.outlook.com (2603:10c6:10::17)
 To PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|CY8PR12MB7172:EE_
X-MS-Office365-Filtering-Correlation-Id: 26715339-41bb-46f7-db1b-08ddd9499912
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?THJ3QWxVaTFGMy9HNklyT1EzeDU1clo4bWFVR2ZUVzZZMm40UTVGTWNEYXQr?=
 =?utf-8?B?ZVpITStQUThiRmlWeVFvOEc3YTF4UjFtZXc0NWcxS0hVQTVrenE3M0l0QnZD?=
 =?utf-8?B?bWd4Mm9CSlk5eGdTd1d1K2xpTGxFUi85T3czQ2xJZzRmaFZobDczeWZkQ0o2?=
 =?utf-8?B?TkxXZll1OUNkdDhTaGNFN3VBWmk2UDRiTHhINnFsVnJwT0ZkNmcydlZtL0Ra?=
 =?utf-8?B?TlZSSStJcFlOK2xFRFEwMjVDZmhJMUZ0bm9oc2VYMlpUNkk3enltUzdjUDRN?=
 =?utf-8?B?MGxKTW5WRGNiOFpiVjd3UWhoWm1kaXdCSWdJcXYweXFGaVQ4cVRuL09LaHNB?=
 =?utf-8?B?RnlIc3c4MHhPMHNFcHo3Sm9Xb3NPRFJtUSt6QWs0aUcvRWkyaC9vZE9xTERB?=
 =?utf-8?B?ZG92eExHblFheXdnU0txYTBPQXdNdHk4Q2Z4V1lmclVQYy9udHJKWmlLT0Q2?=
 =?utf-8?B?REpheGRSZ3pyc2xmZWsvRHZkTUhjOGswYkNOeTdER2lwc3hSVVcwNWRCa04x?=
 =?utf-8?B?ZXl0L0RRVGNqSElsaG5DcTJQTlJhTnlHVk5UbzNGVUZ2N0F3bGpDbG11Misy?=
 =?utf-8?B?dlI2c3FXYzJReTZuYWlESFZkcnpod1hKNHAzd0FSNXlHZG1xclJMWndWQ1Jw?=
 =?utf-8?B?MTdTbXRUUE1EUE9yYWRiZDkxbUkyc3RNbEVpTERYbWNvRjJ2d0hiTTZJYUJ0?=
 =?utf-8?B?djdsNkJ4d1ZQNUpPWCtvRTMxek11dTdUYnAyUHkvWm93MEIwZzd3Vnp2dUxw?=
 =?utf-8?B?bGwwUDMxL1Q4d2FpZTlIdzBxTTcrVEw2NllyY295QW4waFd6VkdFSmpPNDhi?=
 =?utf-8?B?R2FpalhFdEZoT0FWL3kvRWRQbTA5ZW1lWStieXJHemxjdzN5aEgxdkFzcCtk?=
 =?utf-8?B?SVBJN0cwT1h1cDBKSm40YXl5L0VxVFhUcTNxWHBPQ0VIL3RiUGNMeDBucW9v?=
 =?utf-8?B?dldhVXBDRkVldStLVzV1eGU2RUVwU3JjdHJGNTcwUThYaHJZVFZGWXBkWFRv?=
 =?utf-8?B?SWJaNTJQTkdJeWc0MFBTZFdhdzlRK1NSYnVoNE9SaDE0VmdrWTR1NDYvS24w?=
 =?utf-8?B?S2c2S3B3dFpMTjFsdDhlMElCZE5WbThwT0NzSGJNeUwrMHVKYUEvcUtsNVdT?=
 =?utf-8?B?VkdaL3Z2WWNsRDhHWGQ4Q3RnNDhiUE1KVnh5TjR5ejgzZTJ5S3VHZTJMWWd3?=
 =?utf-8?B?bXBoalR2aTFaZXFnTXhyVmZXaUJDVlNoYXNCQ3EwT0UzeDFpbjJuWmdtV1hy?=
 =?utf-8?B?OU8waW5Wc1h2V29heEVXOE82bFdraWg5ejJKNkh1QkRvaDZZOHZHdjJjdm1R?=
 =?utf-8?B?WFRab3NEbHRHN1NJRkJueWkzNkFScFFocFZzRS9qcEVkSVI3VGRUbDU2R2E4?=
 =?utf-8?B?NWo2R3RxWGtaZmlnVFRPNzFicEw3MnZ3UjVrV3RPK2lvb2xLam5FKzZsck44?=
 =?utf-8?B?cUVqK1RpbW1XNGNNejJ1OEFwaGlMOVlNK05SSk9YMjIyU2VwYmQ4UzRtekYv?=
 =?utf-8?B?bUplellFanBXWTVZQjRqUzNqNjFhQ1lFcW55aDQrTjRWdGtKWnI4b2FQN0J1?=
 =?utf-8?B?QzJrbGxmeU0rTWdzTGh5K0F1S1lva2hCdlFPbHlUUjlmNDhzWEZ2SnJiUmNq?=
 =?utf-8?B?WENYbWhDL3VhRTJCUTlZeEx2TjA5Z0pHNnJQaUFDeE91cy95SzhubVNBTlpr?=
 =?utf-8?B?MHhPREdMek1qU1NCdjV4dEQra1pYOEVHeFlaQnBiRE4zZ3pIRkE3MzVpdTVS?=
 =?utf-8?B?cEdoekk5NnB0VmlHUU1qSGwxVjVoRjRpYVJwcWp5OGJoSEtZY2RUdFJKSGxs?=
 =?utf-8?B?QlljYzVKeE9aNzJmaUp5S29NRWJURjUrYmlkdnVDVzJiUTBmV3gyMlM3SkVw?=
 =?utf-8?B?azlzZHloeFBmdzVpY1o1cHMybGY1Yi9MeGd5UmVDVm9UOXRQUktQNUlxai9q?=
 =?utf-8?Q?ufDkSlMZ9uw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ek13OWVTRXFTeFp2bXA1VkV0ZzhlWjVjR2V0TXVOdjRMVEttMnF0dW9jMWpI?=
 =?utf-8?B?dVNoZjFZVFNCdmVNVDZvSU5aRnF3eDhMSG9IWXZaMm5wSkVmZitJMmFtZFVN?=
 =?utf-8?B?OEVmQ0JVeVE1RGx4TGRzNW9lK05LNmc3QVRyWG5BRXMvcFhMcTRaTTlvKzdF?=
 =?utf-8?B?ZmNPWVFWRzVEZk1mdFVCSDZ5bWdPZHJFNkppR2FlN0VvUGpDMHBsOGJGMDVz?=
 =?utf-8?B?OE5GSzFJZzhnSnZ1ZUQ1dGVCVkhKaTc4MkZPZEJCQjVGYlgwSTE1QnhjdE1i?=
 =?utf-8?B?aE1QTG9BalFaQW8zVmQrRUgvQWNpNytLQkF1QkxzZGtsdWFwUVZMV2pjM3pu?=
 =?utf-8?B?Mm5wUjQ2RktLQ1E5bG5laUx6NVJacDFyTTlFMmxUQWR5ZnB0czNEbGs0SWk5?=
 =?utf-8?B?UDROREROaDZRUHdUZHc4WnRDekg4Sm1wVDloejVoQXZDeS9pRy9TejB2OHRQ?=
 =?utf-8?B?dm01U3ZSUzR2NlNBTG42blBCY0d0aytUOHR4emJiMUZlSjNtM0NKK2ExNHJw?=
 =?utf-8?B?dVN6N01oeG92M3FFYm9rU2tUSEZpVlZETlVYNWpvRXVLMjZoY292dHArT2tz?=
 =?utf-8?B?RXhqNlM4cmxSWDJmMVhoOVliL3ZlSWhRd1BPWWczM1ZmVWo4TC9RNzhhQ1BY?=
 =?utf-8?B?WjF3c2JmTG1sUkxuWjk0NFJpdGRyWWlEVjgzZ1ovMWFQTlVabEN5T2I5VDhW?=
 =?utf-8?B?QmtWVEVsSE1uTFMzc2tmSVhWNW03Nm8vV2ZCT1FZNVJpd0xNMENMOHhwQmpm?=
 =?utf-8?B?NUdHd1REYmFMYVBwL21VMk4vejlSUkhkMnhsSW5UNVBNb29kVFJydmp2SXJT?=
 =?utf-8?B?UjZPMDhaNU8wUng0bkNwdFY0MVNPUVQ3MTRYT2hLT1VPdGNzS29kdkJhdnpV?=
 =?utf-8?B?dUJqNlhQcUZ5L0ptZkprdFRYaVVsd1ZTbFlzdmtiRFVhS3paS1JOMGV5ejJR?=
 =?utf-8?B?eWNOY3ZDTUh6ZEdQajU0MTlKOUx1a3J6UHl2N1B6L2Rxd3hqekpseE1HcXNu?=
 =?utf-8?B?ODlVNkVLWHk2eTRUT3Rpd2xZTG56RDg5LzJ3ZHpXVWh5TGlpWmlOd1F4VnJa?=
 =?utf-8?B?WHdaVlZ5VktCcmxPY25Dc3NlVnFYalc3V0wxMG04aEJMVnlxNklYS2YwOGlV?=
 =?utf-8?B?bSt2QUIreXlyTmxOcDcwaWozQzBtUWZESHU0UTVYSEdqdGtIbHZXakduZ3RY?=
 =?utf-8?B?cVQwS2l6OHF0TSs0VnRtYXpJbTNhakl3eEFPZXJIV1RVZWhYTGZJOExNeWdX?=
 =?utf-8?B?TGthTTMranh1cW1tc0pXekdsS0xjcXFBRlBQenlHWU5INTdmUk5TN1orQ085?=
 =?utf-8?B?ODYvR2tTNFRSMTBLMWdmVFlOYWlPbXJIVmdURmVFSGN3alpqMWk2QnpSWm5w?=
 =?utf-8?B?ci9kcXBERnFLYjh2bm9WRi9HWW9PaGwyaCtKektLc243R1FKemRMOWU0YVk5?=
 =?utf-8?B?aHpOclRFMWg4N0E5TnJRSVFVeS9UVVJoWFNUcGZaVjZTRlJPYmt1Y3dRRFRT?=
 =?utf-8?B?dTZTNXVPZVZZSVRiYXE1eUNCanNaQWFqck9BMTF4bHoxQitrZEtRSkhjY204?=
 =?utf-8?B?UXduWmpxZ0tXemk3YzYzdUNyamR1L2g2dG9DdDJTUXZlckJGWUVYWmlua3VR?=
 =?utf-8?B?YWRSanNHV3BtV1BMSElJdUt2VE9JbVNwMGdpRmVGenowTURPOE1PYzlVcmdD?=
 =?utf-8?B?cWpmejJLZm95UXhpK1VMZGErTVhTelZ6Ri9RdmhaVEMrYWVnS2dEdlQvd1JD?=
 =?utf-8?B?MzlWVUF5amVFejZhKy9EdVBCck9QWDB5NEdrcWdFenJMeGErOU5tQ01qZVJ3?=
 =?utf-8?B?RlhXWXdlc0ZidnhHZ2lXN2xLOFZtOStUdXpmZVNZQWgzT3NENEM5eGNZRTl0?=
 =?utf-8?B?UjhEbVpBTUZiR1BlYkE0N0QrVHlQUEFqcGtmOVJvM0ovYUdUbnVqUHVnZ1o5?=
 =?utf-8?B?NFpCcGNvS3FkRys1UEVwd1VYRzNNSVNFb3VDaytSWnpRdWNqUENZUlFwQlpi?=
 =?utf-8?B?N1A1dmpWRVhSbGhNTVdLS3VtTXpjTmsxODVCMWxMbjVhM2RnRTc1NzlRTWhl?=
 =?utf-8?B?MHJYTlRKalROdWdQV1JpWUZKZ1Vqajl0Z3hNeWlUQTcySnc2YmZWbVQ5UjVI?=
 =?utf-8?Q?G24HZ21U5gV60CYIhn4dorhY4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26715339-41bb-46f7-db1b-08ddd9499912
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2025 02:40:28.3277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KFnwCPUqehX+3knecfBegdBMVHgjdIRety6b2yw7rr1SOVMBr7FI1jp9Z3UhaqMtQsUC5OA5GKuYouWnSJ0aOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7172
X-Rspamd-Queue-Id: C32CC20003
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: jgzq93w3xd5qocyqux83hj1ppj53nzg7
X-HE-Tag: 1754966431-387912
X-HE-Meta: U2FsdGVkX198QgninVhwitsqFLSu8B4ETkRJtm3MTjcmLmmX/xvVMtxBLOZwxgHWBbJkDPRhjvCOZ1ZGOi2QRX9PxzKCkEDQt/UiYSl+KUKySS8+FrxKL4O8VFpTAbFpulRUkwgWVj8PS1gw/mrcDnSMzylbOB7mz/SambLeXtvqi6zWcy3aYCF9EcApniOL9zAZgjuPD9sz7Sgu3i05HFFSG7+AHD86vNOJViNo07cMcEPvTaGiXNThqZt0b815NHubUDvJkmjEGpu7eYFwyI5+mUloTeAnSd/SJ/yk2pAOXFdSvVTLfNIcumGkoURYoIuLIQmla8fQExx//yl9GqcKGVV8/McLi7/ZB7e8WBL5SQn1qLAdjcwOzBbN3y7eiVKgjo1Ms/IjhptlssJCgfcHPnRhDZwWvN/G0dZ6EWX2akFFrrvEo9FaRG8NWCMik6WcITh3IO3w9jGYzNt7lkJ+kyRpWUPi/QdsocRp8K/43Gyml9wgRudeyRvylc4VzYbYdsqDNT05byeS9LWfGVyK2YMm6BmIxv26XRfqy1EazX24JlXTOXazt0ZAEGzP9n6l2wfjDE6a77K9jVPj3CS73v0OmZBptceh0NKLKhq20VLvTJFHY+HXeYV3NUqIUUvqJDKwXqfEAooq7w3seSWg8ehiQ0B1C17yfGSO0mIQ4WrVXUsjwRNv/vvocK9jUSu1k5Lx9q2qW07gV8+9MWJvsyrVc5X7rhJgluyWZD4fMIkvEdQQjjMR1dIPGP3Om49UPcAYbpSYwSjUw3lI6lddL+w+73zbgkOArTqRhJ9mq4whM2z4z86gD18zqdX9mg6bM5FA+pmWW6yekqegL8W5Ooof/PbdI7ypMLCDEUhDQq5nDyDzW3VubGZqJjv0rsRkHgpcl1BkPMOw62N0uq4ITIl9jO1SAA2ORf6TC1dIJwpQ/eyED4RtBaTvjsaeq+74CUmzo+ulJxksaJR
 5QyRfV/6
 kWBEVspH2DeThhnAolGpPKgtcUWFhRSbWe/7d9pyKmA6fd/mZr2tuIPqahnqZO/roM+e5Ny8/p9CUnjW5omZz3IIDvcDlRIPXBFLuCbMHmKNT5OFnIyU2fe3FYNDpwmrY6YwMafc9b5S7LqAOdENqDDXxy1IPCWzoGmHp+9opwXsbbS0FQelriKsR9rIOT9w99YlG05zAsrEHrBL8phf8bnXy19VnYrQpt0xHTcFqndx5Tua5OUO404QeqjmV+NrASIbi2SwcFB1TSYWIbEwAS36pYGS4seFwcRvsTmwS+ZPcJhlR8eZ+XZWDCctA1D55rPMmziLwVb4M1MefFq0Oorpjw5ty0rocR+varsz6VTvl+Wr5TbMZb8BGrPGDcojctWhf65vN1Z6jVdDxhlZOa7hDhjF/O2xQ0f42P1OYarlK90OtZT1bndQC/Obj5chEVLUCETWdwIDapWhYgh1zPdy694tDJ1VukJ0Z7bXHaKTQCUlx16dbgF4AcpfQ48C7+RSzuuFuBuQt1eMl3Q+cQ8B4Iwe0N9tDvsta+FmmwjwgV4PF6lUir8BCiNTQNc83RJYJDb8DXZvwfrj1EaKwfHstFfBsFCG/Rs+5LrChXFOTEEZLoRZrJjrp7rbMfffJeyjgSO29d8UcReyMJvDySITOf01EhmgFu7KQpQw/eFTXxARvsQ62vHUndd5IMWkyOUulN2qNODq+UMchlsA4Y6Cr51DxSAjpSEQ/CoXlO3GcoU7ByNtP8Rj8K2oFSNcQaz57t6JBl/E2sLh6xZRcEkJZGGBVyGFP2LakpHB8OeO7p/jmSqlsnj2F6Hn+q3L4t727W1FzqsRGaN345NQrU9PiiiPH1MlWIzQq80OZxQkdIh8yViHlRvq5mca/d8XwaNAU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series adds support for THP folios of zone device pages
and support their migration.

To do so, the patches implement support for folio zone device pages
by adding support for setting up larger order pages. Larger order
pages provide a speedup in throughput and latency.

In my local testing (using lib/test_hmm) and a throughput test, the
series shows a 350% improvement in data transfer throughput and a
500% improvement in latency

These patches build on the earlier posts by Ralph Campbell [1]

Two new flags are added in vma_migration to select and mark compound pages.
migrate_vma_setup(), migrate_vma_pages() and migrate_vma_finalize()
support migration of these pages when MIGRATE_VMA_SELECT_COMPOUND
is passed in as arguments.

The series also adds zone device awareness to (m)THP pages along
with fault handling of large zone device private pages. page vma walk
and the rmap code is also zone device aware. Support has also been
added for folios that might need to be split in the middle
of migration (when the src and dst do not agree on
MIGRATE_PFN_COMPOUND), that occurs when src side of the migration can
migrate large pages, but the destination has not been able to allocate
large pages. The code supported and used folio_split() when migrating
THP pages, this is used when MIGRATE_VMA_SELECT_COMPOUND is not passed
as an argument to migrate_vma_setup().

The test infrastructure lib/test_hmm.c has been enhanced to support THP
migration. A new ioctl to emulate failure of large page allocations has
been added to test the folio split code path. hmm-tests.c has new test
cases for huge page migration and to test the folio split path. A new
throughput test has been added as well.

The nouveau dmem code has been enhanced to use the new THP migration
capability.

mTHP support:

The patches hard code, HPAGE_PMD_NR in a few places, but the code has
been kept generic to support various order sizes. With additional
refactoring of the code support of different order sizes should be
possible.

The future plan is to post enhancements to support mTHP with a rough
design as follows:

1. Add the notion of allowable thp orders to the HMM based test driver
2. For non PMD based THP paths in migrate_device.c, check to see if
   a suitable order is found and supported by the driver
3. Iterate across orders to check the highest supported order for migration
4. Migrate and finalize

The mTHP patches can be built on top of this series, the key design
elements that need to be worked out are infrastructure and driver support
for multiple ordered pages and their migration.

HMM support for large folios:

Francois Dugast posted patches support for HMM handling [4], the proposed
changes can build on top of this series to provide support for HMM fault
handling.

References:
[1] https://lore.kernel.org/linux-mm/20201106005147.20113-1-rcampbell@nvidia.com/
[2] https://lore.kernel.org/linux-mm/20250306044239.3874247-3-balbirs@nvidia.com/T/
[3] https://lore.kernel.org/lkml/20250703233511.2028395-1-balbirs@nvidia.com/
[4] https://lore.kernel.org/lkml/20250722193445.1588348-1-francois.dugast@intel.com/
[5] https://lore.kernel.org/lkml/20250730092139.3890844-1-balbirs@nvidia.com/

These patches are built on top of mm/mm-stable

Cc: Andrew Morton <akpm@linux-foundation.org> 
Cc: David Hildenbrand <david@redhat.com> 
Cc: Zi Yan <ziy@nvidia.com>  
Cc: Joshua Hahn <joshua.hahnjy@gmail.com> 
Cc: Rakie Kim <rakie.kim@sk.com> 
Cc: Byungchul Park <byungchul@sk.com> 
Cc: Gregory Price <gourry@gourry.net> 
Cc: Ying Huang <ying.huang@linux.alibaba.com> 
Cc: Alistair Popple <apopple@nvidia.com> 
Cc: Oscar Salvador <osalvador@suse.de> 
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com> 
Cc: Baolin Wang <baolin.wang@linux.alibaba.com> 
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com> 
Cc: Nico Pache <npache@redhat.com> 
Cc: Ryan Roberts <ryan.roberts@arm.com> 
Cc: Dev Jain <dev.jain@arm.com> 
Cc: Barry Song <baohua@kernel.org> 
Cc: Lyude Paul <lyude@redhat.com> 
Cc: Danilo Krummrich <dakr@kernel.org> 
Cc: David Airlie <airlied@gmail.com> 
Cc: Simona Vetter <simona@ffwll.ch> 
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Francois Dugast <francois.dugast@intel.com>

Changelog v3 [5] :
- Addressed review comments
  - No more split_device_private_folio() helper
  - Device private large folios do not end up on deferred scan lists
  - Removed THP size order checks when initializing zone device folio
  - Fixed bugs reported by kernel test robot (Thanks!)

Changelog v2 [3] :
- Several review comments from David Hildenbrand were addressed, Mika,
  Zi, Matthew also provided helpful review comments
  - In paths where it makes sense a new helper
    is_pmd_device_private_entry() is used
  - anon_exclusive handling of zone device private pages in
    split_huge_pmd_locked() has been fixed
  - Patches that introduced helpers have been folded into where they
    are used
- Zone device handling in mm/huge_memory.c has benefited from the code
  and testing of Matthew Brost, he helped find bugs related to
  copy_huge_pmd() and partial unmapping of folios.
- Zone device THP PMD support via page_vma_mapped_walk() is restricted
  to try_to_migrate_one()
- There is a new dedicated helper to split large zone device folios

Changelog v1 [2]:
- Support for handling fault_folio and using trylock in the fault path
- A new test case has been added to measure the throughput improvement
- General refactoring of code to keep up with the changes in mm
- New split folio callback when the entire split is complete/done. The
  callback is used to know when the head order needs to be reset.

Testing:
- Testing was done with ZONE_DEVICE private pages on an x86 VM

Balbir Singh (11):
  mm/zone_device: support large zone device private folios
  mm/thp: zone_device awareness in THP handling code
  mm/migrate_device: THP migration of zone device pages
  mm/memory/fault: add support for zone device THP fault handling
  lib/test_hmm: test cases and support for zone device private THP
  mm/memremap: add folio_split support
  mm/thp: add split during migration support
  lib/test_hmm: add test case for split pages
  selftests/mm/hmm-tests: new tests for zone device THP migration
  gpu/drm/nouveau: add THP migration support
  selftests/mm/hmm-tests: new throughput tests including THP

 drivers/gpu/drm/nouveau/nouveau_dmem.c | 253 ++++++++---
 drivers/gpu/drm/nouveau/nouveau_svm.c  |   6 +-
 drivers/gpu/drm/nouveau/nouveau_svm.h  |   3 +-
 include/linux/huge_mm.h                |  18 +-
 include/linux/memremap.h               |  51 ++-
 include/linux/migrate.h                |   2 +
 include/linux/mm.h                     |   1 +
 include/linux/rmap.h                   |   2 +
 include/linux/swapops.h                |  17 +
 lib/test_hmm.c                         | 443 ++++++++++++++----
 lib/test_hmm_uapi.h                    |   3 +
 mm/huge_memory.c                       | 297 +++++++++---
 mm/memory.c                            |   6 +-
 mm/memremap.c                          |  38 +-
 mm/migrate_device.c                    | 567 ++++++++++++++++++++---
 mm/page_vma_mapped.c                   |  13 +-
 mm/pgtable-generic.c                   |   6 +
 mm/rmap.c                              |  28 +-
 tools/testing/selftests/mm/hmm-tests.c | 607 ++++++++++++++++++++++++-
 19 files changed, 2039 insertions(+), 322 deletions(-)

-- 
2.50.1


