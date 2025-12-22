Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0460BE6ADE7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 20:42:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65D666B0005; Mon, 22 Dec 2025 15:42:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60AFF6B0089; Mon, 22 Dec 2025 15:42:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B88C6B008A; Mon, 22 Dec 2025 15:42:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3A8726B0005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 15:42:35 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DBE248A3F0
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 20:42:34 +0000 (UTC)
X-FDA: 84248280228.27.AB7D4B7
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id A662B120012
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 20:42:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=WSH9fnuH;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="JOfxz9/R";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf29.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766436151; a=rsa-sha256;
	cv=pass;
	b=6mKR54NP+4LoaRSPBcHesx1s8qMKRbnMxhH9z0lTr48pEKSv9Eyz2vXhD16078vGciNE+v
	FdRAojNujNL6g0vTHoxnY6KQj0NoscEhWkC2FFCAgtZwx8iLv4dM0az5X9LpZj59G0RhRw
	1EagIexyIGbbaO9szyXRffT2tKFrX6s=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=WSH9fnuH;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="JOfxz9/R";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf29.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766436151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4RFLATpCPhJIl3v9jaQVCwqYmkD6VXNi6Hjjs33CrxQ=;
	b=qomtGnJXdXxVxeB4G6JMW5v3Rsu8+8vEzXx/dQsR3HEXjVK4MUEomSORpXHcb7L8WCFx/l
	OfL6ObZgsuPNF3RbBfsb+giYjDfYXOAky0ugcs64Qtgi7iYIGBfkhdneolFMFxE7TZQv7b
	aAAlUOTOtGWLy9EGlApnZgSJiYVr1HQ=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BMJDnrv2873820;
	Mon, 22 Dec 2025 20:42:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=4RFLATpCPhJIl3v9jaQVCwqYmkD6VXNi6Hjjs33CrxQ=; b=
	WSH9fnuHQF3RRLe2Z9+GCVp1rxHALnNPTJPni7FXJnsDlsbQF5e9oYs5cnJrxMXK
	ShrWfK6/v8N//TUFVBdEJ0tmvQBggPHfS5P0AjNo27kRrn2nuAPtVXe8jIkXPFen
	JaQbGhdStP2PQzyEVZ3RtpADt4/8QflC6HHPB/C58I0VwletTYEjuNivproRgJtV
	YS6o3kf6TD0v+inZKL0moqOCYHKmsuWplU80NesyChTytrJYVNY44Y74Tcmc4hlY
	5zwj2QQQYndZpGlXc6dGCAVhD9QS/WMeK8clMP/4T2f7A+x+6D+latERkR9BmVV+
	gh4Fz6IxtES5PC3PfSq0GA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b7by985yu-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Dec 2025 20:42:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMJC6Dh040041;
	Mon, 22 Dec 2025 20:32:36 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012069.outbound.protection.outlook.com [52.101.53.69])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b5j87qpd3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Dec 2025 20:32:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qcrgnIKSaftwuGwgR+xL7YAhVERHT4fNvMpIXCGovFzkoXjKHe3+9WwGBab3Fn9+thlKmYDjefYAjjMP1wD47o8Ci+nRamwViW16iEhmY3MvLqkEvJ2fCF9M/mqEL2Agr2PU9E9DfbNMt8JEn/ADJ/APuQuAX5cI++c08hjMbbO3mdQlpt0Jgb4lK/tzTierzx9nZyck2KwHb7oPrnVJ668jvDRGsL5aSG3+iUWHEqFIwoyIW1dpApWZpFDssf6/i6OidwDPpcepkHFvt2v4XV6NJZhB9+LHcVRTOp2rMDnzKDhYpDe8zJKjKUXoCzlCf32i4bPE+hv4eiWll2WQuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4RFLATpCPhJIl3v9jaQVCwqYmkD6VXNi6Hjjs33CrxQ=;
 b=xsKrDm2hjAgugVVep+ZQcyduPs5v1VK5ZMRWIAh3QFzEbQzCs+66mZAPJQM7mwHjS89P854+8SWmoxA5m1oxlJIfHjqAAR7n34Ien1sS1JinXA9OgfwmyQpbobjOzK+PjQ9d15gxaTlJU9ew/AUP3Sp4w7/AvhQusL05y1uXJWyw7JAm51Z8+loUFNc1xEdkX3+/R0j3KUvVpeKn2yepuSFKhge2R9eM/31rOBMJCpb/xMZyfkssrOFb46PVnMx5RlVvheZzkdDpZvoMl6ruzTBPJusrvpYj9wJcIOObCIqL7G+uwjOtZCUPaZx+Xz+apMeBbPYgcKcgGvyeCV1Oxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4RFLATpCPhJIl3v9jaQVCwqYmkD6VXNi6Hjjs33CrxQ=;
 b=JOfxz9/R/e8j7svoxBvpHw7P/DKI7zSkGynaP0WJZ/wrZQHbx6vwxVkklIdBEk3YkPrk/oHvOrIt6I0723lKUYKb7pvoIFvtQfprW2uqIaXt+7VQyOjjDjPoMv0BPvQwEvk/WcSSdlNPQDSFDI71Bnz5P5/z1FJVoVyBO+OhlKM=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 MW6PR10MB7639.namprd10.prod.outlook.com (2603:10b6:303:244::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Mon, 22 Dec
 2025 20:32:33 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f%5]) with mapi id 15.20.9434.009; Mon, 22 Dec 2025
 20:32:33 +0000
Message-ID: <456efb44-6dbb-4436-8273-9cd532d468d1@oracle.com>
Date: Mon, 22 Dec 2025 12:32:29 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory-failure: teach kill_accessing_process to accept
 hugetlb tail page pfn
To: Andrew Morton <akpm@linux-foundation.org>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
        linmiaohe@huawei.com, jiaqiyan@google.com, william.roche@oracle.com,
        rientjes@google.com, lorenzo.stoakes@oracle.com,
        Liam.Howlett@Oracle.com, rppt@kernel.org, surenb@google.com,
        mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251219062819.2499399-1-jane.chu@oracle.com>
 <20251220151301.b0ec3c1aa6527b0b1bca1e4c@linux-foundation.org>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <20251220151301.b0ec3c1aa6527b0b1bca1e4c@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0P220CA0008.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::17) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|MW6PR10MB7639:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b59613e-59d6-4226-988c-08de41993c39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ekVOYTcxeFlORWloaTVoTHFFUHp0ck8vM0F1b0xyeGFnZXRTTnNVNkEwUHVj?=
 =?utf-8?B?YlZIZXMvc1owRmxDQ2x6STBmL01CQTZOTDM0RE9La2xpOS9BUTJ1ZlV2T2dS?=
 =?utf-8?B?djlIaUVjamduOEhCMzlUTmh5TnNxb3l6QlhhSi9XTVBHSVV6R0wvRFc4L2NL?=
 =?utf-8?B?VmJjeW1aQVk1YlI2Z2pwOVZSTkl5T0gwWDROa0RNM2Fha1A4cWNEb3lsZ3Jv?=
 =?utf-8?B?U2t3Z0JoRlR4aCtOVERDVXV6dWF1dnBvaGIvYVpnT2doMmhKaFd1aWxUZE5p?=
 =?utf-8?B?bHNtR2RvODM3R0lFdVViODZpTEVpYVByQTYxcFNuMW5peU5yTk1keFBjb2RH?=
 =?utf-8?B?MkE2aWp4b1R5bklwcEwwMHFjcnZmRXVhSzl2ek9GcTNEQU92YVA3SlpINE9P?=
 =?utf-8?B?SnNSRER0aEJ3OEVnOC9ERzZLYWQxUVhPRUxOQTJmWDhjYkd3c0R6TzVSYXhF?=
 =?utf-8?B?TTltZWpKeUhTMDltODM0TmFLT29Rbm9seEdWd1pmVzRHODIyR0QxVHhXYkVV?=
 =?utf-8?B?b1NVVW5RRktScGVpNE9Cb1JTR2NRNFhNMTlaajVrSlowdWRqOURNS3JMVThM?=
 =?utf-8?B?OEExb0dHNUwzZjFYSVNlNmZtTVRzM0pOUitHMHBMVFZ3cmtjZGZtVElmZFov?=
 =?utf-8?B?NzZqcE1QemhKb3FXN1diN2owUjhKR25HS2Z0WnRpZEVNbUdqZXBMa29HWEhQ?=
 =?utf-8?B?bzlMNlhhQ3ZERGFIYU9SRHFzWTh6SE9sbjVTRmxOTmJtcjZMWkxQR2trY3JK?=
 =?utf-8?B?VG5VQ0x6ZEdIb3l2ZFpHZElGcmNvREJLOWdPTmdrbmlITitMZ0ROYlRaMC9P?=
 =?utf-8?B?RnM1aEZRbjBLb3dReU9SMkU3NnJYakc3ZGFtQUpGR0xBSUtJNUVuSkFTencv?=
 =?utf-8?B?SlRuNTAwNTFNVXZLOXpWSmlVK2I4b3hUK1VsYVV6N0JBVVUvR21sL00wRjgv?=
 =?utf-8?B?eUJicWFjMytnNzM1WU13YWc5RCtieU9ub0tUcUNOdnlBSUIzbEZIVVFiVGwx?=
 =?utf-8?B?QlhocXk5eE92VUlkdkNjdldXREZBNklZdVR4M01YR2xkOWRWN1hSbGhtSUZx?=
 =?utf-8?B?VVp5THp5MTlXZlhaOXZUYUVlOGZPYUNVWmVwZXo4UitYbkdqWWFvMlFoQmRy?=
 =?utf-8?B?dE0zKzQ3TXoxWmpYS0ZTVHlOSGZhclJuaDlGaWpYU0tIMzBKRE4xazU0L2sv?=
 =?utf-8?B?ZEQzbEs2dGdzYUxlcGVXN1pORWxGa3cxNXhBbXVYdjJ4dDduUkp3RFRGUXV6?=
 =?utf-8?B?Vytta2VzSGJSMlp1OEhlMWdPZGlJNERlSHA5NE1aYi9DS0hSSUZGcmVJMDRl?=
 =?utf-8?B?SmVqQldneThyMGZncGxRRFdacW1JWlNGUWhxMS93TzBtL3VsS2Y2SjJSQ1Bo?=
 =?utf-8?B?QzQvMGx2MXQxeCtPanRxVWVPMmE5LzBHTVllb0xaVWN6VGhIYzJZaklQY3M1?=
 =?utf-8?B?a0FrZEw3aFRwTDhhdDhEVUIwb2hHTFltN3ZXbHRlcTRMV0pCdDVZaGxEdHBU?=
 =?utf-8?B?ZUZOQnl2VkNBMjVjcXNPVGVST0c3OUFuV0hYQ0VVOENQdGRMbWJQS0x2WEhK?=
 =?utf-8?B?NHY4Vko5dkNiV3V2cThTS29Ka3p5T0JVcklRZFovNnhXaHlaS2VZQlo0RWZs?=
 =?utf-8?B?UDRVUFNJYzBSME9NUFk0SHJkYjIxcDBkUkd5eHkzdHNnRjlMSjN2cUZ2ZitM?=
 =?utf-8?B?L2trcXN2RVErSHBWd05UU3hqTmFXUzE4U2YxSTN0bVUvelJON2hTZDZLVjN0?=
 =?utf-8?B?RGRZZERzTVZZQk4zOFZLVU5HbU01ZnV4b1dyaDh2SkJwenhyb0tpNXp1akhZ?=
 =?utf-8?B?eDJiY2N6RW9ialB3SUpZa2hoV3RjTVRoYW5VSTYyUFE0UjF4SWZYd2pJbHU0?=
 =?utf-8?B?dlFzSDB0dUxoT0xoMEpIOWhSeTRoOWlKMGhJVHhZNXczU3BhOHRTRHI3eTFu?=
 =?utf-8?Q?1n+XT+GqqQUjF29IhStZ/JvdKE9MgGQs?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bW82M2pDMm9GcmNDeSt6d2Y1ajJ5WHQyOTBJOUZUdWxZYy9OT2tUSUsrYXFl?=
 =?utf-8?B?K0l5cFc0dzFxOWphNWQzR2xWUHhQWG0xUERUZWlScU9uM2EzN285UmdDWHhx?=
 =?utf-8?B?bE1UNFZQNGlrR2VsRDdkWWhjeTBHSW15SlJIY0dIMUh2UlRZdWR3WEpqQnB6?=
 =?utf-8?B?Z2F2OUc5c0dZOGo0VmMyZTg3T2hMbjZ4WXhuNVRJbTlpZ1dFZENDejJCQVJx?=
 =?utf-8?B?ZTEwWHNyTXNSVFgvbndMQTVHMGJRWXRORGwwSml5ZitPa1M3cDVLTDNWemEv?=
 =?utf-8?B?ZlZTcGR4TGJBd3ArRit3WFNvOG9OZWFzb2tTNUUxZnlHaG42VUFLR2JPWkt5?=
 =?utf-8?B?UlpPdzc5V1loOWFoVldUVXlPZ3E4VXVaV1NIRy9NNU5rK1I3eFN5RStUZXBJ?=
 =?utf-8?B?V3BLQXlsb2NNNnJsVU9wVzNqTnkxT25MTlQwOFNYb29KTndsSE8rS25WNGJw?=
 =?utf-8?B?bjgrZlJzUktOV1NraEYxVUxmcDkxeTVYSWErNjRITzY2V21wK0VUM3djdWM5?=
 =?utf-8?B?ay8vbjlWWTlSdGw1Ymd1YmNxcElJQ3RubW1EcHdmNkZmeWNOVG1ySlRHNUtF?=
 =?utf-8?B?WVVUdkZZV3VMRmFkc3h1YldOK0hGaHA5THdlV0Qwb3pRNkxBZUhWR0hjYXVR?=
 =?utf-8?B?Sjh3M2h6dzFxNlNCRUQzeGNhZWpUZ3VGZ1Y0NVh4TCtBZUdBQWowNTZEcU1m?=
 =?utf-8?B?MFl3WTg5bDY4cTFiTnlDRlprOXpBbnNyM09hRnd0TmUvVGxpaU5EeldTV1Za?=
 =?utf-8?B?akxsRWpLMjFLaDFaSzZ6TEViSW13NU1iM1AzVVdFNk93V0FGTFNQZkxtNXAy?=
 =?utf-8?B?ZUVWNHVBZDZicUltTDZOVXFoemFvK1I0d1JCOE1LMmJycTRpV3hRaE5JSnRJ?=
 =?utf-8?B?YVBKOEw2L0FGVkJnd2JsVUU1MWFuamR3QnZrdlBhMmtqZEV6VUV1ekRoOUxs?=
 =?utf-8?B?czJBUm5mV0JSR29FQndxUG9WYlZ2WXBKOTM4MzRhdEVTMWZxQkN3U2lWNUxi?=
 =?utf-8?B?TmlRNFV6dUhkSng5OEI3SGl1cVJFN3hLYnlCMXZaN05aR2dCaGxGTjNXSjNn?=
 =?utf-8?B?aEtaSFpGbCt0VGx2WngrTjJZc25RZjRvcHBqVTV2TnlMQXMralNQOW9hQ0VF?=
 =?utf-8?B?blZiMWFFbldvaXA3MStBOFZQRFdjVzlhWGNZdnZvWGRZTEdYTWcwUm9rUTUr?=
 =?utf-8?B?QjQwN0EvQWV0a0RsVXVZajJROU9JL0FZTFlVSVNtbldiRzdOVThacjIvVHNo?=
 =?utf-8?B?RTVQL1BFT2NJYjJtUFNlUkU2RU5yN0duOGFwVGVpdGUvTnArUkF5SUhSL3c1?=
 =?utf-8?B?a0VlOW5HNm1SRUlUd21hSXNiMkNLZUJtNDdBRzdvWG93bVFCMStlWTNaTlhE?=
 =?utf-8?B?cnBneW43MlJXWXlRcTZzRmw3bERhZk9VajNtNkNvZ2pZN0VZZUQ0VXg2azZQ?=
 =?utf-8?B?cnFlbGpqVFc2SjRlcVhHSW5xV1k2ck5ERHh3OWZuWURXSmxONTBkYlh6Y3VN?=
 =?utf-8?B?b1JlOVhQcmdEdWhQR1UxcnZvdW1RUjFJMnVSYmEzN3poY3R4bm9QQXI5Rm1Y?=
 =?utf-8?B?b2hqTTZRdFhBUWVlb3FnTFlienkxOWJEMWVBdTZsV3VwMXFLS3NWVktzZ2xE?=
 =?utf-8?B?d2tUTWRVcWgxUEt1VHhpQzN0RVNRS0gxNEl4K1IwM0dYRURyTVpOWnd1Vm9h?=
 =?utf-8?B?bU9tOUYwSmV1NmdaQjRqMyt0ei9odnVuSGdzc3hJaHpIQjlpdDVMbjg0L2hw?=
 =?utf-8?B?UTNvT2wvc0ZRZG1YVjU4T1hoaHRqdWtJOEt2SjNqWGdGVFlTVWUvTlRFZVBq?=
 =?utf-8?B?eDRhbXdSOS9hUlZYRVFBeEpTV2ZQSTdMa2ZyTWhwc3hHS0NSYVkzeG8wTE9p?=
 =?utf-8?B?cTZlV3BhUW1aSzN3UUFML0ZjUTBQQ2FFa1dwd0dwWnpUc3poVDB3eC91MU51?=
 =?utf-8?B?RHA1K1NiZ1FVRnRoNE5MSUFiK0pNOFpPU3FZeUMyWW4zaytodVV5RzdOOUZ2?=
 =?utf-8?B?eDlCL0pKL253ajFVK3NvZVh4bWhwczh0UU1NSHl6T1d2a0laakp5aXdJaGkv?=
 =?utf-8?B?K3ZzOWVzODJMd1RDSjF5VkJ2a2lmSW0zbCtHZUxIcGZzc3Z2SDg5U3NpWThj?=
 =?utf-8?B?b3BBWDhsU3RiOXdJSkRSNlhqU0VSWEo3eGZpV250dUhnS3FSSGpYVm44cUd5?=
 =?utf-8?B?Qkt4TnVOTjNCWjN5U3RESkVpOWZBNnpLWWVjOUFSRHdyUEtLcXJYdG5SMHFY?=
 =?utf-8?B?RGxoYko2ZVZuVS85bnFyVmszQXdoNEhKM0Q2bU1lQmpSWUQ0NzhRd2R4aXA5?=
 =?utf-8?B?bVRueTNpWlhmZlBML0JyRTloNXkvdFVsTVRvTy9Gd2J6d1dQd0tEQT09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Vmn5ON6eIpBqkIFEpriZ/VmNQZTYOsvwRoxlKkHp/Ym4Y6mSWM2XQQPev4LQK+HA/lj+KrqfA88KjU1LbiVi+v/Y8pfmq/yU+gIKN4g80Lyw7F2+JFB5rneQPBtkyeJsa4V6DbLlwl4qfMlwtS97CPwvzmAw9ZVZhVDgm4klLr9iy3KcXwC4l3HbTtYUm2x8m4T/yLHhWeyMKeHH1H11uiyqBuwygGObGwdJJIj68JpNhUivJVFxaxVpfLUw32Fa22Ugkgc4S0eT07gXoCVEpPRB8RdFCqdDIXywZZQdfpUnBVnoigO7/m5QzQq28+Wf4ufuxVeN3haicwvs3NHm8ER6ZjzByp8E/z5Wyh9FLzglHhaZmH9duQoUO6WYw/MX6W+E1fuHCNaE8xuM2DJpLpJpVAQufMK7C0PNAfwwqYVVfI1K7mL6xFzM/FvAhUQFJPp4qzUxV59OmLHccJ6GVUq29SuUVySos4BvpZoAa4dA5ZZsA7tewTjEDpteneCUt/Z2nMripEupD7jrIV1bArbdd7GChvEZ1Wi7Mdn4Pm1OINInDcmo9FvXUb3wOlYS7JI/kWebSHxk07H75KzwVxID0JSNz/8qpKBExxiexqw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b59613e-59d6-4226-988c-08de41993c39
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2025 20:32:33.1825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A9lzg1ggNbxFUoZX7w0dH6aIOtz3FCU1jZzjMdpzbG5mxe4HqDd4TQs4JG2EvIsqEh6/qvA5TMS2kTtP6ZSfBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR10MB7639
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-22_03,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2512220188
X-Proofpoint-GUID: ivKhnSHVnhLP1To5xCP6b48lUG7vI-fK
X-Proofpoint-ORIG-GUID: ivKhnSHVnhLP1To5xCP6b48lUG7vI-fK
X-Authority-Analysis: v=2.4 cv=ZI/aWH7b c=1 sm=1 tr=0 ts=6949ad2c b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=H3UEhRBmQiwo4kdA2VsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIyMDE4OSBTYWx0ZWRfX/rMGLZqCg8bv
 2Etbz/q/MdiqEBopRqz2+LDyDKlub8k/30mjiDPsTM1B8HsApvQNFWacI1ufnFadXG9jttG/kFL
 08MRp0UFm4YppUiiQCVyDxYuawmzxUfkkOT3MDqawDG9GM0GDrBy5ovThPhU/4B5/RWF6iTpwgv
 9ASVjfOPLpqm4hwSMXAXOV7VnhYgMsFI1dRFRS3JO23G0+FNAe/bE0Off4u824kWCB+IzC12qKU
 xKxBtofguye+hajDaJG8fnMXJbkr3X715e+Q2l5Nvf34UESa2QTJeSP87fAi8BYNRnYHhfBdVma
 juVZe5uRCynCrL/vAwhEAw4WonJorRig2uVWi9eZ7uQ7mxnqpMjcw5rYZXForDgFi/5Z/2eWxoD
 ELKjojVZs9LcYURkJ4Yb+xihojauJwYTW1RYFFlUF21mdCbByOF8/BjhqoMUpeYMiA4Fm7Guv17
 KlSO5KQ5Xd7NpPT3h7Q==
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A662B120012
X-Stat-Signature: igcq1r9xz6goahiqxup3o5pjgtmyg11s
X-Rspam-User: 
X-HE-Tag: 1766436151-999452
X-HE-Meta: U2FsdGVkX1//pPSU2nwyYpnr4AlWI7XHjKg5SeFDR2ImfOA6D/IpSTGg0OlfPsh9csZ1N/K4cMeo5E12fg0XagnIoVH+umQec5r//0hxfSCIBrBsuvkeBV9wGVyF5Mc2PrEmFCx/e2C/TZ/r5BeuwkL5TyJJPu1oUwHAx3eixJZv2wZyLI931sq1c2xoeQTjSg6DvDF2YhhWrEmaXKVoHJuUowMUQJQQSAqr9DxVMLZ9RKWHJrHEDblkFaueWu4Pawk8RcHp4qY3+SU+AkxvE1Wzd99pe0xOr14bXYaU+A9SM4+xdzDi2augX6CS4UAIDFJvkH+njkhDLXthebrpIBEXjLwgAMLVDF3wViNu+xSufLKWr9dPg9MGI/J19WvnjFR/voKhqYa5p2G4sRE7uojWgPek5pZG6o3nWUAnNGWU0lRknw8kzsKCQt49S+QwpNLLaSH5PTHrDBQJKu82Yb75obll+3D+O2A83hP8OdxbTRYiukMUP8v8hB4lsUbzWqym8ZhELz8lgDq621myqf2UicFX7FjkCSrlfrACPHqYkgI93lwjVF23aHencVC81PyInfGHl3peV6ygjv7Y+8v7gkD5G6vO8qkGNWnCxTC7iJbZPiWGiejEoj8Yfo1Y1mSnGY4IAE+Sv9KhrARNI3OWIJnk2F8XjLcfguXRaQOQulxqqRaO5mvScvimgMhRsIroV/XrJ0KqzbxFWjhRKBUSGoG2WRVk6Ebs9gc1zTxmi/Vp4Mm0s0SeQmcQuEEq/Oh2i72Ej2zYqPPuZE61kedxaE8liSyOva/GSZ3Shnep11h1hDKjktDHE3edjTC8aWaraIxUpLwl6joskZ+rfDM7Kitq3NpcVUf/fQI4lCgOYVUR6XuE6qkJrzATAp2spYbom8NM0Ico1HUp/+89vp29YvB18T3iCBCM7DuQjfvYYTgfzTfisgTXxkqBCtscQhW8ZEPV46QLgKbibEt
 A6spmQr0
 KsuzfQq5+UrHYmgenhGPPNx8/Hm3C0L84vukL1/XxDsaOJlqqvMg3mye2fJLfBrXRPnNh1qKbMk1gbk7G2QcTsAAUAXkdwvTTwzNmkxDYdcCzLvYD7rOB/VEf2/ghci6jN3xv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/20/2025 3:13 PM, Andrew Morton wrote:
> On Thu, 18 Dec 2025 23:28:19 -0700 Jane Chu <jane.chu@oracle.com> wrote:
> 
>> When a hugetlb folio is being poisoned again, try_memory_failure_hugetlb()
>> passed head pfn to kill_accessing_process(), that is not right.
>> The precise pfn of the poisoned page should be used in order to
>> determine the precise vaddr as the SIGBUS payload.
>>
>> This issue has already been taken care of in the normal path, that is,
>> hwpoison_user_mappings(), see [1][2].  Further more, for [3] to work
>> correctly in the hugetlb repoisoning case, it's essential to inform
>> VM the precise poisoned page, not the head page.
> 
> This conflicts with your "mm/memory-failure: fix missing ->mf_stats
> count in hugetlb poison".
> 
> Also conflicts a bit with "mm: fixup pfnmap memory failure handling to
> use pgoff" but that one isn't cc:stable, so this patch (which *is*
> cc:stable) takes priority.
> 
> Help?
> 

Sorry Andrew.  Let me try rebase v3 on top of my other patch.  Will also 
take a look at this other conflict.

thanks,
-jane


