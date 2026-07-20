Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 535CFC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 04:43:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 496586B0096; Mon, 20 Jul 2026 00:43:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 447106B0098; Mon, 20 Jul 2026 00:43:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E7856B0099; Mon, 20 Jul 2026 00:43:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC4746B0096
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 00:43:34 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4B9EE1406D5
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 04:43:34 +0000 (UTC)
X-FDA: 85007911548.30.9AAFC90
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	by imf25.hostedemail.com (Postfix) with ESMTP id AD576A000C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 04:43:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=windriver.com header.s=PPS06212021 header.b=EE+9033D;
	dmarc=pass (policy=reject) header.from=windriver.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of "prvs=1661a20148=yun.zhou@windriver.com" designates 205.220.178.238 as permitted sender) smtp.mailfrom="prvs=1661a20148=yun.zhou@windriver.com"
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784522611;
	b=KHeuSGrygS7hDqTNaSppm7oKNwEnG/a00/5E3gT+fmyU7TAi+RWZQCSaJ8frUlAESF9QWB
	2Y989d/Gb6e3iCJvIL0Bh9H1jfseuhLNPFgAk8kdGkpGKZIcKOG4YKDJNArrQiSiRomvXr
	ova8lbVsgQoXrhr4gx5lT7YuLMg85Ko=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=windriver.com header.s=PPS06212021 header.b=EE+9033D;
	dmarc=pass (policy=reject) header.from=windriver.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of "prvs=1661a20148=yun.zhou@windriver.com" designates 205.220.178.238 as permitted sender) smtp.mailfrom="prvs=1661a20148=yun.zhou@windriver.com"
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784522611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=96NXPEhLlzlpaO0homHzPFOEu+/nxSp8uL6Q2qMldbY=;
	b=tAg62gJPQLokwzKXgTU7yHJdLtKTuLHnaF6ltXO81bMKF3SjNutzpeBKK/SNqdmP+v0ilj
	Ar1z6UK9tv7uOBVGvUknsGGWE8Du1d5F6XfyJn/Zre4psjkLQxYB+Nyk0b2qRZxlTjBIr8
	I/IaEw8uszMFHW+znYdhDBcACvYm/00=
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66K4fPrR3638257;
	Mon, 20 Jul 2026 04:43:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=96NXPEhLlzlpaO0homHzPFOEu+/nxSp8uL6Q2qMldbY=; b=
	EE+9033Ddf/MsD2cfLJawh0Qs7oV5wJg+34LeEmusFp7kb7U0tbO9WtHCMXnR54h
	gQ4VwNUFOJ1H/YPLCbsgFgsPwc6GLIjYb1cLp6ycUlse7oOB0mdLP2j+M2KL2+hP
	v16WZ13Utj46dtSsUGpzH1tQqKuir/ZfAjcqekizHIA+FBODLsaTOu0j0vdXFlEo
	bAs9reOaZ4Nvx/i2ybcojI4JF2PEBOoOthuePV1sCnxeSvHsyBe/CWoFUiVbZLUs
	IKUH+yy9CtK+4oaYXblfPX+toL3nEQWy5yALh2AT+WeSuWCoobFBFyZBIUthrSck
	vRPSKMKWzHU3c+s+5V0Ehg==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013032.outbound.protection.outlook.com [40.93.196.32])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fga8x1dm0-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 20 Jul 2026 04:43:11 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VujxLO0nhP6r0Z3hB9QsrcPnStWV/BX4+01CuFUyopRq9JKdhprO+SLdVTktnbh0xFzGpMIqzpEsIjyDEmBp6DAJNrqtdXCJVIni9N8uLWUVrifJ1nBQzYt1QD9PYm8R1mxlCHnQ13NZnS4hqHtl/RBmpZ4OK8W7KyGMSkKdVtf0u4GaVaCArOmp89nrJ62Y8CW40yercVhF4tFxHuxLP6ebFTKLgyQZ5czl8vN7Wh7Bp8umbMEUxS88KgIVn7ysPdugIPK0cerd/w9Ut11vFS6adexlTynahJ6/yA96+RRvSFcJ352bDwGa2amlzH5OkZbXc7dmeCFxuzXfb9dosA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=96NXPEhLlzlpaO0homHzPFOEu+/nxSp8uL6Q2qMldbY=;
 b=X4ebcbC3NGHuppCHaNlL56v1ljX/vzt6KAwrxu0W3I2GC3QdbvsEW+EYcz9xK5eEoE8mFT/44eIwADyJusQBgFwWeYuhvvRQNN8ddnWFrozU78060AbemDTMoYW6zywCVwXwSOR4tatm3aidp+CQijwepSRSWyaakhUCCbhvveO6eUyEEq+l0QWITaVf+JXn4X2tNl2INGyYJiM2ryzZIf+I2/MLyGbwA3UbIDvSwit0RGwkp7Seu5Y11YGiArLZBIAYBF3vbUZ+vnENuzsQREa7UjqVFDwgQfo20QhaxzoINjhWRaaz8fnVQAD7YZXnTVrcOfYo1rzbiLoX7dQk6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by IA1PR11MB6290.namprd11.prod.outlook.com (2603:10b6:208:3e6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.16; Mon, 20 Jul
 2026 04:43:08 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0223.015; Mon, 20 Jul 2026
 04:43:08 +0000
Message-ID: <9cee6d8d-8247-43dd-8974-3104788841ab@windriver.com>
Date: Mon, 20 Jul 2026 12:43:00 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm: introduce memalloc_flags_move() for
 transferring allocation scopes
To: Andrew Morton <akpm@linux-foundation.org>
Cc: cem@kernel.org, djwong@kernel.org, hch@lst.de, willy@infradead.org,
        hwenwur@gmail.com, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260719095732.1813590-1-yun.zhou@windriver.com>
 <20260719095732.1813590-2-yun.zhou@windriver.com>
 <20260719135728.cb036d8c922c5cea1e263ca1@linux-foundation.org>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <20260719135728.cb036d8c922c5cea1e263ca1@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TY6P286CA0035.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:405:3b7::14) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|IA1PR11MB6290:EE_
X-MS-Office365-Filtering-Correlation-Id: 234342d5-c6ab-4f40-ce29-08dee6196524
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|56012099006|11063799006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	zVtjk9iS5U1OOsFWLNNFQUVWq3TCXdj+AE0J6a5XDznS3f4yfC6v0NJ4hTetEE/mA0rOjuTS/8c2Qj3stMi9SfD4150dt4/ZtZ/3kbqkXiFMeY32jTDMbF+GrzeSVvJRSQxe7oqZ/qbgjeyLHcUJTn1YaitXpK9g6Ca3sExQsUKAuk5Q08+HqXyXBe5pM3FqZV3GMgB+DfszpqKIcVZj5XtwchoBUwNNsZMFgjLFV/EmCv+E0c0vfg6ed13L8PPhmdipOa6MRqQDufZI3HOvLXPrhtMKqmyOICg8VOVykLRUFJdhVK1nZTAdoZrk8AhZowCZibxWno2Cwj2FMZ14cbyuPAdYre3iP9AwnSkVmtpDlvTsLVFTthOwBQx0p8mpROO0cJXLAl/1pkR6fJCzui1lpZSOPai20ZXi5jho+cYWr8JSlpzzVVHstdIjuvXJO/Ic6tZuVcAJPQbvThEBPdYQepH6s1MFLrY5Msd9BBDgKxzzVsxqBd/DNmelGsQJvcEvM4FQGmsZpluMQbiwHv/U4CkUlCYqXeeUMqyIManszj74QXMp+UNGZwjFMIz6cLrK6Dp3+BrXOCBfNb5arecIh4CsRlDUkutTwC39Vxs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(56012099006)(11063799006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eFZMVExUOGVVekxsZTN5YVk1T2x5NXNJWTVxT1crTENaVnkvaXQzU09LV2NU?=
 =?utf-8?B?T25lT0RCdEFSbFFiZzVjYit4M2J4eE5SS2dxNXNIV0VBN2E3SzJNQjdkaXNC?=
 =?utf-8?B?R284Y2p0MHV2cmVrN1AwbWVIekk1YUxDRG1uN3Mrb2EwdHcvcmR5clpPZnNX?=
 =?utf-8?B?UVBmUmh4SXIzUnM0QUNNNklXYUg1YkZ3N213UnZkVzFvMG4zTmhuY3NLVkx4?=
 =?utf-8?B?enlBK09RNUExNGlPT1NJTXYvRGtHc3pWNGlCWGdGRTlzVFhaSE1LcjNTN2lI?=
 =?utf-8?B?UWVOQUd4d0M3cmZjR2lqdi9FNU1iemZJL3huR1J6YU10UlpQVUpnNllkUHlB?=
 =?utf-8?B?ZWdFdzV4cmM2QkxCYklKMkZnbWtjTlhxOStDdHBPaitJdGppT24yNkNCSnRm?=
 =?utf-8?B?bzZqMWYxYWg2VWdmNlp0U3pRbzZNY3FEMG1PSG5hRGxwRUluQU9lOWNBU2hT?=
 =?utf-8?B?NVA0TW1KZ1lpVnNrNTl1bjdFUmtqWHJ6c1FRVzZ1NldKa250WkVQQ21XaEJN?=
 =?utf-8?B?SXIyZlpZSGFwQ3liaHdpd1hhMW5DWHlFTWx1THRkK2tueVdha3NHRE5CMDlU?=
 =?utf-8?B?STMrQTYxZC9mV2wzZlVvWkNjNW9aekV4ODlGaUd2bWNkdkF4dXhFV2kzQzl4?=
 =?utf-8?B?ckQ0SlJMWmpERVhJTTFkSmh6ZkhnWXhUNlRjS08rR2JvUnpTeG9qb0tFeWlh?=
 =?utf-8?B?L2RyV1IwZVdMRGxmbEJvNTg2dVVkUTI5UHhZakZWMlJwVDd1ai9FK2V5dmVI?=
 =?utf-8?B?K3NmS2NTTEJSeVZpZXJFd3U4WDZDUDlsYURsNjRPcVpnUUUweGlUZnVyT05y?=
 =?utf-8?B?Z01VcXZFZnM4cklSQmFBTDRHUHJmZGxPek93Wm00M081SEt6aGRQclpmZWlG?=
 =?utf-8?B?d3cyaEpGUWNmYVdLTnNCcWZ0dERCcTA3QkN0OVlCdmVjdjhTakk4YWQ4VTBw?=
 =?utf-8?B?M0NHbEs1Z1FmRlp1ZTQ4OFN0QWJIVTV0alM4MVM4S0ZNNVNHY2Q5ZmJkRGNS?=
 =?utf-8?B?eGd4M09RT2pPcmErckxGcVcwUWFHdyt0bDdVVXpORVVJZkdRWmd5VW9OV25S?=
 =?utf-8?B?MXZRUHpjQjllamdDVjBHclRiR0ZmdFo0d1REaFczZ1NXaDlDVzVCMTVLRlRx?=
 =?utf-8?B?Y01tT3BJU1dUTHVrTktrcUJSR0JBWTIwV3graXdGbFcyZktuWjNtamUvTWhm?=
 =?utf-8?B?MmNsWEJLMlpKb3lia25IUzZKRXV1KzZXN2ZCOG04YWNtZ1QxVjNuejIvQ1Bj?=
 =?utf-8?B?cllFWnppaGF4TnlCM05UUGtrR3o0VldaRkp2bG9zU3FLN3dSWVBBbWVIVWJi?=
 =?utf-8?B?RE1scCtqdHhoN1lMYTBtWTAxeFBkQno4UnRzejQ2TjY5UHp4UFg2U05VNVJP?=
 =?utf-8?B?cThlVFJtb2l1czVnalU0eHFZMkJpVFRiZDNDZDhhUC9EWFlPQTNnVHhyV2lX?=
 =?utf-8?B?Ry8rMjlkb0NsaVpmMzhxdDlOa2pTTGVzQWVtT1ZLdjdZdFJFeEdWWGI0S0sw?=
 =?utf-8?B?UGVoNTZCVzlqOFNxaWxzTk5XMkhmSnVFb2pRTW1qYzM2bjM0MUFXY1YxY1NE?=
 =?utf-8?B?WXlKNnN1eStra0szY0FaVXJaUUtaZGVjS0RQRWlITWxSSzRlZ2xXaURRSE1V?=
 =?utf-8?B?Z2FGUnQ1ekdGUHJvWVZZTk9YcExiZEJpa21rdzB5azgxZ1RHZ0pjMlJpWUxZ?=
 =?utf-8?B?RkszM3NkUjgrZzFORlFkNHRoejNPNGsveElXTkpzRE4vcStxeVV3a2JSNlFa?=
 =?utf-8?B?RzhXWm5vblhkRzlGSytUN0NDRWphK1pUYjRYWjZyY09LYkpqakxYR0RISStJ?=
 =?utf-8?B?dklHUkNsalpkUFlWYmxFeTVTcGZ5UjF4UUpMeHV0MlNXYzNVRm9JUC91c3NF?=
 =?utf-8?B?K0FMUVFyeXR4QUJOQUVRL09XODUxNlJtTkRacWxhKy9sS3RyTTg2aklaNnpO?=
 =?utf-8?B?R2hoOXZFZmZqOFVldmQxS3kwV1lUckZvQ0M0UitYbUFqRG5hNDAzeVNKQ2ZC?=
 =?utf-8?B?ckJHYTBUTU1ML25KcFZyRFVRU0U5NnFjNXBNcXRpMjZDZW9DdGgxZUhuUnNz?=
 =?utf-8?B?OTdEY3cxblpwdG9CM0pyRlo0OEQ2TW5NeHh5VWpLSWZDYVdSWXduRVhSbzlx?=
 =?utf-8?B?dnhMSGN6ZDFtTTh2SzkzdDVsOUVRVTQ0Y08xZTV1Qng1TlJCbUZ0S2lEZ0xw?=
 =?utf-8?B?cDdFUU5iSisvZllvZkpVMEZZTGFzUHNyaEU5N2c1ZnMrcFd4Q1N4eGl0UTVB?=
 =?utf-8?B?MFo1a2QvN1g0SWMyR0IrUDE2YThNdm1lYk1saGNTYTFwLzljeWdDNHdxWXN2?=
 =?utf-8?B?M20vWGxsbERvZ2s2dmYxRkpYZ2ZHSllKYnZCcFNST3BLb0ZKMko3dz09?=
X-Exchange-RoutingPolicyChecked:
	mcFnqJ3vjrHHYa/kuMA5m5hovXO/q8YyLjk4NegfQEMR7FJttsIXPjnACYIRiWQ9xCAEFMRNF4BmwJ2mrNQIytLegWRPu7Ym2Lyvhq/19H/wpNVFnRleIaQulgWBIudZ5Ie7O4fggLv2ZkXWplxVylrb3sPpj4lr6iTrmM+Hh11xFZcDFYwUgI9akYZH41Cd12u8cO/cc27b75vmh8llMC0IS+6UhUlGuY/1hCFRPqI6xPaPsBTPqkIJmXiy86BffCmzh18U/H0LrjJcdweBwjuyDw6PygS8rLym4JTWBopW6bbef07kjY/xURjYKHVoxl5/Wwy+5q4yShm+m5tHJw==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 234342d5-c6ab-4f40-ce29-08dee6196524
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2026 04:43:08.1095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IY1V2LY+gpkimY53ypzGBpdUpQ5U45gqHQe5OVVVYmj5v9hoxIEF4ctX7bcjDXxyYsZBIlv7Z85vzvXOcdSv/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6290
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIwMDA0OSBTYWx0ZWRfXx7JUONTElDK3
 JkKtBDMe3iGvZGky/KFolf6YCOJF2CvtU8do468iBVUdXCqQJ9S4n5B0NPSUgnC/Xohmf62CzJY
 YUeDNNBg5Ua7JpMERof5vLdZgN832O1nQbwREIa3v1lhX6SxgSJX
X-Proofpoint-GUID: YI004yyDsHTsGL7FuScVinOA2ff5QTsV
X-Proofpoint-ORIG-GUID: YI004yyDsHTsGL7FuScVinOA2ff5QTsV
X-Authority-Analysis: v=2.4 cv=XdO5Co55 c=1 sm=1 tr=0 ts=6a5da75f cx=c_pps
 a=kXeBnfu3JcJF6EwF0J+eVg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=klDOsUkWDRETUCZYPvoE:22
 a=c92rfblmAAAA:8 a=t7CeM3EgAAAA:8 a=Cixcb0HQSmRVbuXSjIIA:9 a=QEXdDO2ut3YA:10
 a=GvGzcOZaWPEFPQC_NcjD:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDA0OSBTYWx0ZWRfXzX+VYRXJNhGL
 C0UHDZVJ3Te2BovqCXqs6tMVFTRocSZN8w65Uwu9dobM8zUgN+tInaAcbcfnV0S1HRxHhfN66O3
 AEmJ0F+5y7uTqmKuGRZQ2+muwFpS83rBYIwpi9AdgFFbc1vYDc68wWoPmXeuPmSd8cKMnuDMuWv
 K3Y2Nw1Fr//kcvKnsUIpzyVzbvQomdtj+/fadP8ksTktTnOsbd62yTzneg9cOB9WFCpLlUVMfqP
 zIPh3bmuDjzkw/bvZDk153WwPa2mlsPB0iVywORDDGg00l+QcJCWq41tt5QTo0KQnk8Hu/UAY/j
 obVUM7CvVsQ0peI/3+ogE7EI9WJ7u94qIJ/l16qT8t9Yrv+5tRt0GXpXSZo4EgiO+KouRmMZvLV
 j42dbCEeyiE7gQWKHM2YJDN888prdGHILacdMB/8C0jX+z3m2cQH/6h/QVTuPPUnTancnG9HPDe
 oQH5IWvCrffgflyDRmw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-19_08,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 clxscore=1015 phishscore=0 adultscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607200049
X-Rspamd-Queue-Id: AD576A000C
X-Rspam-User: 
X-Stat-Signature: xx6amsg634tqd8m9y5y51hgu937pjewy
X-Rspamd-Server: rspam03
X-HE-Tag: 1784522609-551001
X-HE-Meta: U2FsdGVkX1+7JfF30SMAc9itYBIGklcb/p4hUg8v4iMxLzvaBq3PEuibkxu2kDtvyF6q9hGiAFqhP7C6tRaewWZ++cH+efhjr5EsvBLU6/PorAJqhnBZyWGsbJUjJRZKcXncR9xEJEcRds81FxBA1J1eE6QFKD5QE64Szm6vi+Y0mj6tVvfQHXlrcZva+zcYQdTiCI6hvMXQZ5uBn2yAXL5j0GzRHwOZdwa3ali2ge1cVOD6OeyY2G6mqaUVkNdzIZQGPBm1PtzyDpjFshGkumCfJ53EZWEPazD5ksUvS697GpH10mh+HRmxm70C8ooA6gYG7rsE9lVXX4gN6uqKWRoC2plrW0tJFsT8jGGhnNIyr1uThzv43Y8sv5O08zvKRogCMCqFnwNEW/RLhxD/S7kEjdUw57OB1eT9eW6bLIHxOhwtQ3PWE9LJSIn+bI4q9mFo9rHQzBfvcwf8p9hwaLMXBFmrktXi8PICW7Zi+5gZIBCNzIHmlaDcngL5a1N4ihgiUnyo2PkTiUkmqwFk2/dQkAyHW2vo+eMt5gWJ+lxJoMwPa5Fq12BPlAG/pQ+rkt5qkx2W3VcpZkFsHlYuE/uOc16YiDwdXvRPQLNkvbcOyYLJvFs9DFZ2IQ4XD4XGf7UZNHRSuDMFSIUxLA14G6xJC0mjnsHn28u/BDJ/U+ZVL5F+8uLIs/stA7wzerHChmMCO2/vyiQeBZhoQW25Bf/vXndQqEGMDeMB+jqdTz7dqk+im0NU2z6dAjRvJWCeVKjDcxOLFhVqrBP5v+7lmWCO7MnsK0t7TSQ8R4OpfntaEoXi2jvlToMyD7Pt32lDWYwYK6nYL1nOdVjF0J2WPTysCKD3Y+/nUbudgKQWE0flbtx0KJ8aHx+i3ifq7TiyP4zV//tdZIyxQ3oe1lsWL++2VwH6HKWplFc6UtcZTrMKZ2ga/0Yli296j6dVg+kEMjlD2wXXuHwVe1i7sl7
 IN4gPeqk
 4cggoFYKhO0sYDhnkG2BgrGS7l0X9TwpDeapEPzwK1WL/BBLGW1Ni/ub38d2fj+F9+hK9JboFiVZpEh6e3bmBJAWnteI2uWmZI2UvlqGwIU5iGds8+mhuMl0urWQkrtyOEddFmiwAJVLhTJ8ocwWGR1fbHOKPr5jg9Xs8bfxxaZEQFf1cMPNs4m9tD8VizIcr72CutTL8tYj/x3yzapRHIsEq4gvgqdTKDibKZn/KuFe8Ifx4m//n6XUXhnTwP36e1gPH/MK0jcXn1zO/hgyh8ttQzxIUAMWrujK/SWoHUjSqeHz1s4lGXNdZYp+R7eyVp1ntsXFMPkeYRgbaH6NZphfC+KGO7FOPGqhBV57zy0kVlTW4XL4ScdBSxZhERggEs+ol6/a6jRKGx1b4X9Gabwnv4ViRyIigqtv66UNDHmrSCQ0jeNe8BClLFyomutRNTZBCfYVrv1FCYJnT2y0h/77pKPQVnn7PHsIJvw84GPPDJ93eYBknFoJVyT64Mwi0Vd7ewZMs7Rsr3Ot9H6b9aC7lDpIluqb309ZZNVHd4vKSh+2AtDF/L/MOYePRrV6rM/1ecev4YPFVdXAMWEI4+4kn5gPQWu4uE44Q7nJYnVXUU6joQHfMSNnVT5hDWaSz08MazG6WvYAAuSrAEQNLvyMoLlG3IOtBSoY1han99bS7u6Wf3kVodNhmdGKlDk2KuyFUWBwN75KfFusciqbxdGb4oqgbm8WWmvu8Jyg83YWsAyp1qB303uJERz8X6NzufU4k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/20/26 04:57, Andrew Morton wrote:
> On Sun, 19 Jul 2026 17:57:31 +0800 Yun Zhou <yun.zhou@windriver.com> wrote:
> 
>> Add memalloc_flags_move() to transfer a saved memalloc scope from one
>> tracking variable to another.  The source is zeroed so that a
>> subsequent memalloc_flags_restore() on it becomes a no-op, effectively
>> transferring ownership of the scope to the destination.
>>
>> This is needed when a subsystem hands off an allocation context from
>> one structure to another (e.g. during transaction rolling in
>> filesystems), and needs to ensure the scope remains active without an
>> extra save/restore cycle.
>>
>> ...
>>
> 
> Thanks.  fyi, Sashiko might have found a pre-existing xfs issue:
>          https://sashiko.dev/#/patchset/20260719095732.1813590-1-yun.zhou@windriver.com
> 

Good catch. This is indeed a pre-existing issue, and needs a separate fix.

>>   include/linux/sched/mm.h | 17 +++++++++++++++++
>>   1 file changed, 17 insertions(+)
> 
> This file isn't mentioned in MAINTAINERS.  Could someone please propose
> a patch?
> 
>  From the MM side, probably just place it in every record which mentions
> include/linux/mm.h - close enough.
> 
>> --- a/include/linux/sched/mm.h
>> +++ b/include/linux/sched/mm.h
>> @@ -342,6 +342,23 @@ static inline void memalloc_flags_restore(unsigned flags)
>>        current->flags &= ~flags;
>>   }
>>
>> +/**
>> + * memalloc_flags_move - transfer a memalloc scope from one tracking
>> + * variable to another.
>> + * @old_flags: pointer to the source flags (will be zeroed)
>> + *
>> + * Returns the flags value to store in the destination.  The source is
>> + * set to zero so that a subsequent memalloc_flags_restore() on it is
>> + * a no-op.
>> + */
>> +static inline unsigned int memalloc_flags_move(unsigned int *old_flags)
>> +{
>> +     unsigned int ret = *old_flags;
>> +
>> +     *old_flags = 0;
>> +     return ret;
>> +}
>> +
> 
> I've added linux-mm to cc here.  Please include it in any future
> versions of this patchset.
> 

Well, got it.

Thanks,
Yun

