Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6F77CCFA04
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 02:14:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C6008E0003; Tue,  4 Nov 2025 21:14:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89D278E0002; Tue,  4 Nov 2025 21:14:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77D448E0003; Tue,  4 Nov 2025 21:14:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 61A1A8E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 21:14:42 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D488155A6D
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 02:14:41 +0000 (UTC)
X-FDA: 84074934762.17.2E33137
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013064.outbound.protection.outlook.com [40.107.201.64])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0CC3A100006
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 02:14:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rlF3xrey;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.64 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762308879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iiH6uBWmf68Z2v4RS3I9fbGOQYJxL4TPvr+sisHe+/k=;
	b=BPJkYFYrjkHOerJMnQqP49sLqyPYSUhx3kc9veCrSWA74T4RjPyFxL36ic53A3eH/XyyWc
	jMyoB27CkKRv9zdDhhMQfQz3VSofB/Vpc7eM2Bd064Dvuf+JBaHbnydto+VnZxfW6lfSsl
	K5kruvAAbWK4tTnZMt4FiIS5rNHuN5o=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rlF3xrey;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.64 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762308879; a=rsa-sha256;
	cv=pass;
	b=t5x6WTiT3QhDAv8MsAjr7THzEgv4WTokGjvyMDm7JR6qEWH05gLmH9zTVoN6+K8GFzWf7B
	x3EX6p933o3qdmSc6yqYHYniG9lfZikrGtZVtoXEtaL9nWy8ECQ36RGlb3gFoQmfGBS7uG
	e8xSApvWEKpmMCLe9UlaByvVlFucvqI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VTeins9qm+FnhEVx7UvSNbCIGE3Tn8Nx6NY0/tjkNQbo4DOVjRU9w6d0xXdkCvZcF/LnR+WGWSK03/d+arno+C8Ann2woW/ZLJq90yF7UbR1rtPLHOFmHw+vpiwvneePPdDqtJhX6AlALkbtsitq9kneuejcR7XSO4w3SvR1QE73rpYuqrDxEz5+OK9QqBzai8EjAd00M61XV+OioRX7E7K1eL6BF6VBOs8oiibb+5NPrKTPt2bkvXN0O4rYKg0EZmUKqKqR2gAIrUEaqxx7Vol/9B22ibTV6S5V+ggITD9tOrLwQniJJ3tO22nKpEEoCs0LC6MCmtPJU5A8ycaxyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iiH6uBWmf68Z2v4RS3I9fbGOQYJxL4TPvr+sisHe+/k=;
 b=v/0zvsP7z3clk63Uq2mxc9D+OWULNAAGveSzeVGj/fdaQO/lUmJP5dL2HXP57LwyCwAqtpg2QVnqleMay+vCQRbbl3Bo2L2BwhZksOgfgKYqrLsMUCaJCalC75ZMmQIGg9tJ6lhTwTNyJwWvH0E0NgzEhOrKKKXtHiuN3SLQASDWUljTKi9ajrtng6xruiMfTZ18dZc2LVTI4VYIVl7CidYSJSD4C9oLJI44GKQ8tIsYgqx/ot5YLTIKIVrlUFerneTzXRXSB5ox9Oghj6dAxL7lEGe22ppD3zYAvF0+amO1QWUbNfPll0nXXB9R3Qiym7AETM1WuFuIEmfTwItkhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iiH6uBWmf68Z2v4RS3I9fbGOQYJxL4TPvr+sisHe+/k=;
 b=rlF3xreybUFLpK6bgvYmLG4ZBJzZwI6M9rcdwdksI8dfC+BTeZXOaACCjpczKuekCRWXpyY5XKGFxxTBUIwbFuKbT5VOpv0QUToDjyUhgrRNPGqDPw8nQFY+N0yZk+44WMQcyiJMRyCHb054NY6WzwgjOOpyRO1uSUE0oxbyh1TU6Uzj3K9mpkrOWZs1YshpV93dcsSmtJeZ26nd08Q7r39xYArkxZREq4tnMtp7U7tyzAtsgWvLIASCmMNxW8k9rz/qOMQWmDnsE09xHh09I0LQm6IwCcXFLRHQeHCtNBfLAojzFc5GXqMDk42yWqoqmEQRgiqvNFhhO9POOLQZxA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB7020.namprd12.prod.outlook.com (2603:10b6:510:1ba::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Wed, 5 Nov
 2025 02:14:34 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9298.006; Wed, 5 Nov 2025
 02:14:33 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH] mm/huge_memory: merge uniform_split_supported() and
 non_uniform_split_supported()
Date: Tue, 04 Nov 2025 21:14:31 -0500
X-Mailer: MailMate (2.0r6283)
Message-ID: <E1772F62-C1FC-4B67-A47F-7A1A6581C89D@nvidia.com>
In-Reply-To: <20251104075326.hqktuvois66j3cdk@master>
References: <20251101021145.3676-1-richard.weiyang@gmail.com>
 <CF5DECC4-7C92-45DB-9931-A1E35CA3C0A5@nvidia.com>
 <20251104003618.adfztcwwsg26gmvd@master>
 <016650EF-DBFC-4C7A-A707-8FC6A0F93ABD@nvidia.com>
 <20251104075326.hqktuvois66j3cdk@master>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0427.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::12) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB7020:EE_
X-MS-Office365-Filtering-Correlation-Id: a4c8d56d-82af-4546-cf34-08de1c110fb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZmVtQmI4bTVXNTViTHA2QU9sZWJNRTlrelpqU3dGSVZEcDY4K3VhY0Y3U0hX?=
 =?utf-8?B?S3VUQ1A4amRwbUE0UFdjYTAxWDFyOWVDZWhCWXlIeXI5SmFCNTlQaVl2TVB1?=
 =?utf-8?B?THdBOHMyd2xXb00zcUNnWGxuMmQ2TlhIeGZDNmR6NlFvNFRFd0s4K3JmRXA2?=
 =?utf-8?B?aENsZ0ZkbnZIZks0WGlOQk5NcElpcXh3eWdkdXE5ejZyT00vTEUvUEJLSWRB?=
 =?utf-8?B?V3Jpay8rVjlHVDFiME9NODRlTGdsZzNSVGdOUHp3RTd1Y1grdHdGWGVFaWZR?=
 =?utf-8?B?Sm5FSTRaUjgrTk11ODI0dGRvT203bmx0Qm5WR1Q3MVQ3V1VqMUl2bm5NOURX?=
 =?utf-8?B?REpLVUd4T1BNS2M0aWF6Y0hISCtib2xrQjR6c2dNdUl3WlRtR1dqQ3YxNGF5?=
 =?utf-8?B?QWlPU2RLSGVFaWRScWxlcTdGTW1ZVE5JdW5DK3Y5L0ttSThWN21ma3lnemVI?=
 =?utf-8?B?WWw3cXFvQ1NFajNqUkg1emYrbU5RWU5qV2ZGY0RNL2NyYjh4WkYwUmNMdTg5?=
 =?utf-8?B?dXJYalRlclVjbjFiUHFyUmZxa1NKUDBWM2hUNVo4bENiV2tJSlNHQk5hK3lP?=
 =?utf-8?B?OTI2a1l5L1JlTXNPTXljVXhkeGJZaCtVUkNWWGFmVkxkQ1BCQ0JhcmF2c0Uz?=
 =?utf-8?B?dmQ4UjdSWGl2NS9nL0F6cG1EUlprekkxc3pPRk5CR2lPYWJsd0dUM0txcTNr?=
 =?utf-8?B?ZUpuTzZYN0lyWlhVTmF2QmVOK3NhUU12OHJaNFFINXFScnBNTE5kN0VWVWt3?=
 =?utf-8?B?Z1RUdVJ3UnRMZHBXeU8xcjZaYXdBdkR2RjhYYW5vUERYTDRWY2dSWHpHaTlo?=
 =?utf-8?B?b2tLdS80T2dCYmg1by9CZHJabnlvWXJBWjBWWkp1R2J5Z2ZQTkpOQkpsQWd3?=
 =?utf-8?B?VzczTi9ZN2pxUFZCbXZWUFdUcjRIWE9yMWVDdUN6WDF1K25CNnZpOHFpZEdO?=
 =?utf-8?B?QkIxaHNnZGlldFVmdFdDNFAvMTd4YjJXZlJVMm5aZmpQZ0l6OWljMDdWZkNo?=
 =?utf-8?B?QkN3bWhHbFRyTHh4dSs0SHB1TUdtS0p1amZPVldJMDI5WklCYzNLSTNRb0Q5?=
 =?utf-8?B?SmtkVXE1T3J2UEhxNFRRUksvZzZ6bmhkUmFPTzAxUzh5MTYzNDBQNDNvS2J4?=
 =?utf-8?B?d3l6NEVFcWc2SEI4b0l3RVliMTZtUnJoN1dYaVU3cTlpWjhweHpSd1ppRDhr?=
 =?utf-8?B?VEh3SEFidjhURUtxU1hoU1lVQmxFN2pXQ3RrWlI4dDBkWk1YRTJ1bXR2cHoy?=
 =?utf-8?B?YmhqMlVKSmM3ZjZIUE9DMmM5a1hXWnR4S0E4NE0weTZvQ1J2V0V5ZnV1ckhI?=
 =?utf-8?B?OURQODFrd1RYU2RPTG81RjZUWExoZWIzclFTaTlManV6VlkxZzZQaGNNWW12?=
 =?utf-8?B?NFVDcGNIU1V5dFkrZmE3V3drK0JUTW04OWxhZEtKUjlMenpIL2VlVy9QTTJr?=
 =?utf-8?B?NmM4NjFScUFXRXBlR1RVRUFpMzQ0Tlc4aUs0TXpNSktTdnZVbXhMaUt6UVJw?=
 =?utf-8?B?VkVwM3FFcDhoem9jZzVHMkFyQWJ4STVhaS9YcllMV2MreGwxMzRhSHlsTmlW?=
 =?utf-8?B?cTBTdmc3MVFkNE9KTUI1Vng4VTZJVDJNZGxjMnMzdEpzRDNnZTFzbXMvaURl?=
 =?utf-8?B?QnBXUDN0SWg0ek1kRGh3Vis5MDM2SFFpMUcwWFF5M0NUNS9NdUpPTk9QTmU3?=
 =?utf-8?B?OWl4UExtRGdUa2YyUXNTcUtjb2lwdkgvU08wQXNTUTQreW9IdWt0SkFsUi9j?=
 =?utf-8?B?N29YVkFsUUVXR2Jvek14OUFCZTlBaUdwVHZNU2RsaG5CTzVlYVUzTVZQZmpV?=
 =?utf-8?B?dzdERERRb1RsRjJSOS9RLzQ5SVdVcDA2LytGbVRlUjhrZHFJWk55bUhrSUZ6?=
 =?utf-8?B?SHZlWk1leG5EQzI1RThKSm40Vkc3OUtjcXd6UFVibm5kZTJwY1VLOVh4ZE83?=
 =?utf-8?Q?FchQysJlTLHTXEiavldnZ/eBq56JueNq?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZVdjV09FbTVGZnZTSGJGRE1ITW5kb0svaUJHUmx2czFFQVVHdGdHdUpreDVO?=
 =?utf-8?B?SXI4VHlhalEyblZyM0RxQjJJcEN2Zm9qVUc5QTNDeFFGbWRweWZVdkNzQXFN?=
 =?utf-8?B?SlhXd28vcEY1TVBUak1EdkZHUjRoTklqell6cnZ6SUR2NC83QkcxTkdmT2p1?=
 =?utf-8?B?T0pib2lyd2hNdGsvTnRQVkQ1UGVITDNSYUJqSWl3U24zR2pqSVh1VzZFbDAr?=
 =?utf-8?B?ZUwxY1VHOU05SlZNazFsZUQ5bEhKQmxtYnJVVzhSNW1tcXVhdTlwWDhhdGZF?=
 =?utf-8?B?MHJOS3E5UTEyaHVYcTBucnhmbXRVUW80SXY3VmJERElFd2Zoa3NKK1p5T2ZI?=
 =?utf-8?B?TWFQcGd6VmpYVFNObEZnZ2FuUHFwdjFjQzBCdUczNkRZbFZraUVLbWk4RjND?=
 =?utf-8?B?RVdYZHFteG9OZFg0aHdkOXNUZVhpZ2IrZWRnMEM3OVcrdVJFcTBBenprR3h2?=
 =?utf-8?B?LzhvZDU2TGd0Zm9TK2pkUkhtVndlVlJOM0NkTW5JYzZDWFJPL09qamJMaE9p?=
 =?utf-8?B?bFBWa3VmWDRjcTBhdlFlenU0TFh2TzVXQnhrNng3d29tRVQxUEVJdzBBcEhW?=
 =?utf-8?B?LzdiZjA5L2F4OTM4S0trTXBrYXVoMjNpTEVhREs5emM4c0MxcmlSSmJ1TFBq?=
 =?utf-8?B?OXc4aHZlUWR0TDhiMXYvRllOdWRka0pUaWFuOGRJblRhdE9Mb1FJQVhqbXVu?=
 =?utf-8?B?SmVaRDg5NFRrV29IMVkzdlNqcVpiTFhHRjdhTUxzeVlpcDRYWUxtRkloc1py?=
 =?utf-8?B?Qk5KTVZFOS9yendsZmxvamg3UkRFUzJxdE9wN3dyZ2J4Y29jcDQza01RVzRx?=
 =?utf-8?B?bUdpZDBSdlBiSisvWG54S0dCMTdiT01OdDZ1MzdURlh1Zmc5TGNjQStSOVlQ?=
 =?utf-8?B?czRYOFkzZHR6QzBxU1FpUzUrb1JCejZ1R25Dbmk5NW9MNWJaT05VOHlwbzBa?=
 =?utf-8?B?Tm4vVCtpc0VvaGZpSWVoeWpMamUzOFFHWHNhVmhTOGpHMjh1WFNnSzI1MTR0?=
 =?utf-8?B?bEROc1VodmZHWTljbGtKY0o3ZkNCZEZQWGRJb2hyK0F4cEJaR0ZObDhBbXNw?=
 =?utf-8?B?MFFOMEtrMnN6VmhuVEJzY0dFaHRuWTNDNlNsWWJ2NjJxUzhpazZibnBlbExU?=
 =?utf-8?B?eldxVXdpUFdIYUhQSlhPQXdYaUtNOEVWWGhpTWp5SGtVaUl3U3hDaGhaRnpD?=
 =?utf-8?B?UUxGZXZRZlZURDYxbGNFeDY5QjlWMXhjZHVBcEgrWVk1Y0I2VkVGSFl0QVFz?=
 =?utf-8?B?SHN2cGlYb3Uwcm5DUzFnKzE0SFFQczVDb25Sc2hDVTJKaGhBUG03RWJ2ZnVB?=
 =?utf-8?B?dzh2U3lIN2RycXNLLzczdExJcytpNW0zOXlxOGk1QkRmWk5rM0xMTFIyZXBp?=
 =?utf-8?B?NzdCSFZrbkt2bjhOS28rblpseVUrQUJaWkswdFV5RjNBK3lST3VnNTdVOHVC?=
 =?utf-8?B?dVJpVHRpSS9XMVpRQlFsTFFTa2R1NW9OMTU0cVJzbUlDUDNUN2lJcE5DallC?=
 =?utf-8?B?bG1ucGtvQlBnODJDRWEybXY2K2ZYTDFIbjVDZG5lVG05NzNOd0NHQlBibTdF?=
 =?utf-8?B?YmloK0NLOHl1MVpvNzNoSGliRFVHOHVGMk1ad0M5Q28zTUVqN1hGZmFGSXVT?=
 =?utf-8?B?S05HTlRjQnF3M2FMNFo5NG9RQnpQK3QwNmpjTmFBY09mM1AraVQ5WVRINFBl?=
 =?utf-8?B?cFJQaVduMy9VWnFNc3IxWkRPNlc1U0dwZHFRd0hNL2MrcjlJQnRHc1NTeGNL?=
 =?utf-8?B?dE5QNFU4MHdjdExQd08xQitlMUpvMDNORnB5aDJ6U2tIT0haM3NxZVNTTVVC?=
 =?utf-8?B?WmYwVVBNODVOSnc2THZEQzF5UXc5ZkErNUJTL2haU0tZdVB3QitXNU9rQUJ6?=
 =?utf-8?B?QmVzdnJDcjhQcmlMbGJzakJMcnc1NHN5dGswYlBSb3VGWElvQkxlQkI0TXJY?=
 =?utf-8?B?VnhBSHphUlVlNEJUNG1LbmtwZHA4ZVVtdFk0MGJ5cGlTQW9CMUJvbFFFOHNO?=
 =?utf-8?B?RmxqT2VWNlhyWFUxUHc2QXJtdTk5NEVuSWtEdUdOOXZKZWZtYUVLZnpBSER2?=
 =?utf-8?B?S0lBcjM0TS9KdWZvWWM2Z0hDci9tc2lSUWxkMXdSRW5FQ0czcmN2NTJscEo1?=
 =?utf-8?Q?xsjjVLKbOXztVh23ujuPEpYp9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4c8d56d-82af-4546-cf34-08de1c110fb6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2025 02:14:33.8251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SjLT6e4tOxgxZCQ9w1V/b+ABaouK3dAhlqhJa95G4fkPQ6MVbCSL4y6X13aLnvGH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7020
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0CC3A100006
X-Stat-Signature: yrzxeycqagamg7j3ictai3u7tft5jay1
X-Rspam-User: 
X-HE-Tag: 1762308878-820137
X-HE-Meta: U2FsdGVkX1/qYeZHUircUu6GaCx7RatieVkHDm9jBUev6JkxTwPP2kefGyko7SQHfwrV/Easncf+4vOJ+ArjwElp5yc1LGyRfjyydeqezK8HQEEUA8Se1xSYcyNpeConQ+/lbZ0/TmRAkQcikXitGTUyv5/HDUleDDqdSzV/pVVW183/OoVffzAwcTJpffvze8l4SdeiLpIK4u1te8pMwO5JQDdwbd/BGoRPYmwL+XVJ9SjI70w1Oe2pH51DaRBdx83cQ5uL1b8J792khYmG7ymGBR3C5VNJdl/uLCnz3AKQCDv2+CPba7LGOciRMlpPvDunKWB2vxGNdKaHQwoRI3rVCDaDc+sWAozRb14QdqmiDo3/Ylh7MQD0JgOvoYFV20LpHAGu7xVdJSIRnV7MK5tUAAL4b2m3tk4CS9NGlNY8vGB3Z8JHA2pLBxwg+sSWfH+4MCw3Ez9MTKGKfsp2PymXa8BpmUtU60Q6rsVbswaiJfN0k4vFlw1VtuXHi6L6z5KpaLj/iHg7mLu0xPG6diBBe9xrF9aWeelNI2h+kL1joZIZp2buqQpbnIWn2iG2Qjs5h4k2Q3/qIUcsKEQHVuf3QWJbgsGMntiFb0RiGXe59wO4QcKD8FNUr9LDGYvTHTZy3enWFVR6OqS5QykegGqcN5uWkVKmR3yc7mYjoMAMZkt9vLpaqo8RBe5FVLWA6/89HdXBw6Ivf0CytQ4NoCyRjNp/sxxsv2NskK4xEa9MODF5nmTe8KSP9+DFGfpGut2SO1+0o8pSBNE0nDXDp9IhLwmrSGozLl+aCkZOgzNY4I3EWZSb6U9WGepDvpZo5Uav7d/klV9vB5WYc2GKmDJLPfeOPmuyWYnuKhMI+DDQ8eejkl7RyzeCIH2DqiDEeFa8YSOYMYiweepaRnPjV6yBBHmRxswLZicVjZd2JYxzHPfnm9+zZslumdFOz19Q8rYLjQJB68AbQrr/aVw
 +KVteC9e
 +tl3d75MvWL/1BikpCHJFTJa4RSiwdyQathy4Bv6bu/h0m+Yli7VQb36NnbWFGq7BumdrMwjx5nGFLQPQHFLotYb+PgbfOD4Dz4li31TkAr4Y/YMhPosu0bep1Udp8glRxaLO116uuYcqn75966PIwkRsdZSQBXRyMBHUu5iYtFC6a3wXNsPyYHlnDCxERBFfHMkRfPPv4EQLUy+O7AxEqpt1XnKBjpWuREQetFIuv+dq3wNVgL1xiclixZMEZjThzKD+HPDe+XWq2Gna++uWAQtBC4DxW/PSzR+ELSL9N1HqNR6Ut362BlUKrfS+RD7ZIbJRxPOa/61HVY29KBJKUGQ/RL6P+5la2oRzvQxtBOJFoN8T2HLPKjfZwXuCPEaMS+7dM8T0Bk0xl0pHtdtBdlwOPhHoSTzCmWaVX/4abUD5wpKkx6Z8qvV2eWTGMTj2BJvXQPNWxiy8i0syOdPmoGabueYrFEVIv7xUz9jrjzU3K4Q0hGRflv2JGFmaTE2dK9N+G7xF9kWXvBzoujLYSVvfx/s1rtFC4zdU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4 Nov 2025, at 2:53, Wei Yang wrote:

> On Mon, Nov 03, 2025 at 09:30:03PM -0500, Zi Yan wrote:
>> On 3 Nov 2025, at 19:36, Wei Yang wrote:
>>
>>> On Mon, Nov 03, 2025 at 11:34:47AM -0500, Zi Yan wrote:
>>>> On 31 Oct 2025, at 22:11, Wei Yang wrote:
>>>>
>>>>> The functions uniform_split_supported() and
>>>>> non_uniform_split_supported() share significantly similar logic.
>>>>>
>>>>> The only functional difference is that uniform_split_supported()
>>>>> includes an additional check on the requested @new_order before
>>>>
>>>> Please elaborate on what the check is for.
>>>>
>>>>> proceeding with further validation.
>>>
>>> How about this:
>>>
>>> The only functional difference is that uniform_split_supported() includ=
es an
>>> additional check on the requested @new_order and split type to confirm =
support
>>> from file system or swap cache.
>>
>> You are describing what the code does instead of its actual meaning.
>> You need to describe:
>> 1. what is the difference between uniform split and non-uniform split?
>> 2. what order does what file systems support? Only order-0.
>> 3. what order does swap cache support? Only order-0.
>> 4. why can uniform split be used to split large folios from 2 or 3 to
>>   order-0?
>> 5. why can non uniform split not be used to split large folios from 2
>>   or 3 to order-0?
>> 6. The logic similarity between uniform_split_supported() and
>>   non_uniform_split_supported() and they can be combined with detailed
>>   comment.
>>
>
> Here is the updated version:
>
> The only functional difference is that uniform_split_supported() includes=
 an
> additional check on the requested @new_order.
>
> The reason for this check comes from the following two aspects:
>
>   * some file system or swap cache just supports order-0 folio
>   * the behavioral difference between uniform/non-uniform split
>
> The behavioral difference between uniform split and non-uniform:
>
>   * uniform split splits folio directly to @new_order
>   * non-uniform split creates after-split folios with orders from
>     folio_order(folio) - 1 to new_order.
>
> This means for non-uniform split or !new_order split we should check the =
file
> system and swap cache respectively.
>

LGTM.

>>>
>>>>>
>>>>> This commit unifies the logic by introducing a new variable,
>>>>> @need_check, which is conditionally set based on whether a uniform
>>>>> split is requested. This allows us to merge the two functions into
>>>>> a single, combined helper, removing redundant code and simplifying
>>>>> the split support checking mechanism.
>>>>>
>>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>> ---
>>>>>  include/linux/huge_mm.h |  8 +++---
>>>>>  mm/huge_memory.c        | 55 +++++++++++----------------------------=
--
>>>>>  2 files changed, 18 insertions(+), 45 deletions(-)
>>>>>
>>>>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>>>>> index cbb2243f8e56..79343809a7be 100644
>>>>> --- a/include/linux/huge_mm.h
>>>>> +++ b/include/linux/huge_mm.h
>>>>> @@ -369,10 +369,8 @@ int __split_huge_page_to_list_to_order(struct pa=
ge *page, struct list_head *list
>>>>>  		unsigned int new_order, bool unmapped);
>>>>>  int min_order_for_split(struct folio *folio);
>>>>>  int split_folio_to_list(struct folio *folio, struct list_head *list)=
;
>>>>> -bool uniform_split_supported(struct folio *folio, unsigned int new_o=
rder,
>>>>> -		bool warns);
>>>>> -bool non_uniform_split_supported(struct folio *folio, unsigned int n=
ew_order,
>>>>> -		bool warns);
>>>>> +bool folio_split_supported(struct folio *folio, unsigned int new_ord=
er,
>>>>> +		bool uniform_split, bool warns);
>>>>>  int folio_split(struct folio *folio, unsigned int new_order, struct =
page *page,
>>>>>  		struct list_head *list);
>>>>>
>>>>> @@ -403,7 +401,7 @@ static inline int split_huge_page_to_order(struct=
 page *page, unsigned int new_o
>>>>>  static inline int try_folio_split_to_order(struct folio *folio,
>>>>>  		struct page *page, unsigned int new_order)
>>>>>  {
>>>>> -	if (!non_uniform_split_supported(folio, new_order, /* warns=3D */ f=
alse))
>>>>> +	if (!folio_split_supported(folio, new_order, /* uniform_split =3D *=
/ false, /* warns=3D */ false))
>>>>>  		return split_huge_page_to_order(&folio->page, new_order);
>>>>>  	return folio_split(folio, new_order, page, NULL);
>>>>>  }
>>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>>> index d1fa0d2d9b44..f6d2cb2a5ca0 100644
>>>>> --- a/mm/huge_memory.c
>>>>> +++ b/mm/huge_memory.c
>>>>> @@ -3673,55 +3673,34 @@ static int __split_unmapped_folio(struct foli=
o *folio, int new_order,
>>>>>  	return 0;
>>>>>  }
>>>>>
>>>>> -bool non_uniform_split_supported(struct folio *folio, unsigned int n=
ew_order,
>>>>> -		bool warns)
>>>>> +bool folio_split_supported(struct folio *folio, unsigned int new_ord=
er,
>>>>> +		bool uniform_split, bool warns)
>>>>>  {
>>>>> -	if (folio_test_anon(folio)) {
>>>>> -		/* order-1 is not supported for anonymous THP. */
>>>>> -		VM_WARN_ONCE(warns && new_order =3D=3D 1,
>>>>> -				"Cannot split to order-1 folio");
>>>>> -		return new_order !=3D 1;
>>>>> -	} else if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>>>>> -	    !mapping_large_folio_support(folio->mapping)) {
>>>>> -		/*
>>>>> -		 * No split if the file system does not support large folio.
>>>>> -		 * Note that we might still have THPs in such mappings due to
>>>>> -		 * CONFIG_READ_ONLY_THP_FOR_FS. But in that case, the mapping
>>>>> -		 * does not actually support large folios properly.
>>>>> -		 */
>>>>> -		VM_WARN_ONCE(warns,
>>>>> -			"Cannot split file folio to non-0 order");
>>>>> -		return false;
>>>>> -	}
>>>>> -
>>>>> -	/* Only swapping a whole PMD-mapped folio is supported */
>>>>> -	if (folio_test_swapcache(folio)) {
>>>>> -		VM_WARN_ONCE(warns,
>>>>> -			"Cannot split swapcache folio to non-0 order");
>>>>> -		return false;
>>>>> -	}
>>>>> +	bool need_check =3D uniform_split ? new_order : true;
>>>>>
>>>>> -	return true;
>>>>> -}
>>>>> -
>>>>> -/* See comments in non_uniform_split_supported() */
>>>>> -bool uniform_split_supported(struct folio *folio, unsigned int new_o=
rder,
>>>>> -		bool warns)
>>>>> -{
>>>>>  	if (folio_test_anon(folio)) {
>>>>> +		/* order-1 is not supported for anonymous THP. */
>>>>>  		VM_WARN_ONCE(warns && new_order =3D=3D 1,
>>>>>  				"Cannot split to order-1 folio");
>>>>>  		return new_order !=3D 1;
>>>>> -	} else  if (new_order) {
>>>>> +	} else if (need_check) {
>>>>>  		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>>>>>  		    !mapping_large_folio_support(folio->mapping)) {
>>>>> +			/*
>>>>> +			 * No split if the file system does not support large
>>>>> +			 * folio.  Note that we might still have THPs in such
>>>>> +			 * mappings due to CONFIG_READ_ONLY_THP_FOR_FS. But in
>>>>> +			 * that case, the mapping does not actually support
>>>>> +			 * large folios properly.
>>>>> +			 */
>>>>
>>>> Blindly copying the comment here causes fusion. The checks for
>>>> uniform and non uniform look similar but this comment is specific
>>>> for non uniform split. The =E2=80=9CNo split=E2=80=9D only applies to =
non uniform
>>>> split, but for uniform split as long as order is 0, the folio
>>>> can be split.
>>>>
>>>
>>> Per my understanding, "no split" applies to both uniform/non uniform sp=
lit
>>> when new_order is not 0.
>>
>> Not exactly. For non uniform split, any new_order value is not allowed.
>>
>>>
>>> So the logic here is:
>>>
>>>   * uniform split && !new_order: no more check
>>>   * non uniform split: do the check regardless of the new_order
>>>
>>> But I am lack of some background knowledge, if it is wrong, please corr=
ect me.
>>
>> You are changing the code, please do your homework first. Or you can
>> ask. After go through the above 6 bullet points, you should get the
>> background knowledge.
>>
>>>
>>>> Please rewrite this comment to clarify both uniform and non uniform
>>>> cases.
>>>
>>> Not sure this one would be better?
>>>
>>>    We can always split a folio down to a single page (new_order =3D=3D =
0) directly.
>>
>> Not always, the exceptions are listed below.
>>
>
> I mean uniform split to order-0, maybe above line misleading to non-unifo=
rm
> split?

Right. If you mean uniform split, then write uniform split instead.

>
>>>
>>>    For any other scenario
>>>       * uniform split targeting a large folio (new_order > 0)
>>>       * any non-uniform split
>>>    we must confirm that the file system supports large folios.
>>>
>>>    Note that we might still have THPs in such mappings due to
>>>    CONFIG_READ_ONLY_THP_FOR_FS. But in that case, the mapping does not =
actually
>>>    support large folios properly.
>>
>> These filesystems do not support large folios except THPs created from k=
hugepaged when CONFIG_READ_ONLY_THP_FOR_FS is enabled.
>>
>
> Want to confirm to see whether I understand correctly.
>
> We have two kinds of file system:
>
>   a) support large folio
>   b) not support large folio
>
> For a), we can split large folio to min_order_for_split(), uniform or
> non-uniform.
>
> For b), normally there is no large folio. The large folio is collapsed by
> khugepaged when CONFIG_READ_ONLY_THP_FOR_FS is enabled. So we can only sp=
lit
> it to order-0 folio for this case.

Exactly.

>
> Not sure this one would be better?
>
>    We can always split a folio down to a single page (new_order =3D=3D 0)
>    uniformly.
>
>    For any other scenario
>       * uniform split targeting a large folio (new_order > 0)
>       * any non-uniform split
>    we must confirm that the file system supports large folios.
>
>    Note that we might still have THPs in such mappings, which is created =
from
>    khugepaged when CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that ca=
se,
>    the mapping does not actually support large folios properly.

LGTM.
>
>
>>>>>  			VM_WARN_ONCE(warns,
>>>>>  				"Cannot split file folio to non-0 order");
>>>>>  			return false;
>>>>>  		}
>>>>>  	}
>>>>>
>>>>> -	if (new_order && folio_test_swapcache(folio)) {
>>>>> +	/* Only swapping a whole PMD-mapped folio is supported */
>>>>
>>>> The same issue like the above one. Please rewrite this comment as well=
.
>>>>
>>>
>>> How about this one:
>>>
>>>    swapcache folio could only be split to order 0
>>
>> This looks good.
>>
>>>
>>>    For non-uniform split or uniform split targeting a large folio, retu=
rn
>>>    false.
>>
>> You are just describing the code.
>>
>> non-uniform split creates after-split folios with orders from
>> folio_order(folio) - 1 to new_order, making it not suitable for any swap=
cache
>> folio split. Only uniform split to order-0 can be used here.
>>
>
> Below is the updated version:
>
>     swapcache folio could only be split to order 0
>
>     non-uniform split creates after-split folios with orders from
>     folio_order(folio) - 1 to new_order, making it not suitable for any
>     swapcache folio split. Only uniform split to order-0 can be used here=
.

LGTM.

Thank you for updating the comments. Looking forward to your updated patch.
>
>>>
>>>>> +	if (need_check && folio_test_swapcache(folio)) {
>>>>>  		VM_WARN_ONCE(warns,
>>>>>  			"Cannot split swapcache folio to non-0 order");
>>>>>  		return false;
>>>>> @@ -3779,11 +3758,7 @@ static int __folio_split(struct folio *folio, =
unsigned int new_order,
>>>>>  	if (new_order >=3D old_order)
>>>>>  		return -EINVAL;
>>>>>
>>>>> -	if (uniform_split && !uniform_split_supported(folio, new_order, tru=
e))
>>>>> -		return -EINVAL;
>>>>> -
>>>>> -	if (!uniform_split &&
>>>>> -	    !non_uniform_split_supported(folio, new_order, true))
>>>>> +	if (!folio_split_supported(folio, new_order, uniform_split, /* warn=
 =3D */ true))
>>>>>  		return -EINVAL;
>>>>>
>>>>>  	is_hzp =3D is_huge_zero_folio(folio);
>>>>> --=20
>>>>> 2.34.1
>>>>
>>>>
>>>> Best Regards,
>>>> Yan, Zi
>>>
>>> --=20
>>> Wei Yang
>>> Help you, Help me
>>
>>
>> Best Regards,
>> Yan, Zi
>
> --=20
> Wei Yang
> Help you, Help me


Best Regards,
Yan, Zi

