Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84FD2C88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 19:02:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3826F6B0088; Fri, 11 Sep 2026 15:02:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35A256B008C; Fri, 11 Sep 2026 15:02:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2490C6B0092; Fri, 11 Sep 2026 15:02:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED3716B0088
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:02:36 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 232B440324
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:02:36 +0000 (UTC)
X-FDA: 85202402712.06.22E6752
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013009.outbound.protection.outlook.com [40.107.201.9])
	by imf24.hostedemail.com (Postfix) with ESMTP id 496BC180009
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:02:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=irwF5Xye;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789153353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Xh1w3YV2hQfhKVSxY3cSeZpqtKum2MvHG4418AeW0E=;
	b=KM32yV2iGrgPekUOsIN1hTBhN8v9g11ZpBWE6++NsYEZb71BM7pJ22QIukAsQk6m921Qo5
	wCACb73Q1KCMyTzgFQihjwSq5nU9xpuoxIb1jFCjptPVO7uJcHVxYQc5kHcmJNfen5kHab
	vbqizmxA+UDnjvpIZXNDzCgfALAMtxA=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=irwF5Xye;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789153353;
	b=mP/TIgzrSH7RthhuieRggMxvlpmb/yYL4V9tAjAFnl4QKLq30wSXLUSbAfRxEzdzJa8jB5
	oS7TgE3A+0GEbEDNE5R3560Jo6pci4QVsQs1rVLiyFxBw6Pg+X/vNDe4za4SLizMgdbhkq
	/aftVftCK3ytlowjaHVMEXm/j3OpV9U=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IY/69zgWdkviM66F5o8HHwo1+SU56CUehwtGx1+9Ba1TMtyO/pKFlHsJmKweuaLPRAt4aGLb/Uis8FphoFez92PJZuHIRyaIPXgSkarSA4ima8rTL0ZECe4zol9gZwPXjulsNORC4Pu9DC442VIq5sTVSlf8L3a2+XJcmwXpxM8bNpd5KR++zI5zZoizM3OlGHbc4kY5DUcnniTRg+CvoR5n5tFjQVU97B2evkN61SJEd9z+0QJ9n9jd49SXyMH9pwdnYCcC0pCSOQ+ocTpm2DN6M1Y0DfJDt6VZqkT21ZLDThcHvPlr7AxrJrLB+wPF+VO7FWrtIPRJBy7qq9bamg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Xh1w3YV2hQfhKVSxY3cSeZpqtKum2MvHG4418AeW0E=;
 b=sVYPLp8Mok/sQq5HoAdr7UjFvxuFOmtGlI0LTJXt7Yp22yfHgUDg6NIvHHTZFXQocL7ADjYAKLBffGmmXjnx/dpl6xsm4rNcwvi2X46GvwboQi2l1YmWLyog79doYBkIPb3M2NYMUuG2Qa0oETiIZdnKRgvkrfceyQ2hxU4DLJ/oRXJzKGHUxUNUuRZ/VhwMYM2RRIPxS/eWUF5KVT+6cg1NV+rrYiH9mdFTzZ6NMb779P1B5XQ+TfJkYAYycbAW9AJh3dzt52LePwRQVPA6y7R9owyBZcV6VnkEKrg850E2TQvMZ2wQBCVtXWtaM9OWJpoOxymGso7k1VRMIP0/rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Xh1w3YV2hQfhKVSxY3cSeZpqtKum2MvHG4418AeW0E=;
 b=irwF5XyeY0tYiBrOJMRJIHQnrsPLCDaLsgyPX8rul1M1GazgI03SiutX71t9XnBhMz68boIC/zwdpyNtMLn7f6IPYVMJp+IHPnr1NJ6o+G9kV2bicC6icDE15Q1rqbLkgDpWx3swjA2iXSqJdM+SocK7FqTXZZeGnT3fbD5Rb5qXRbNAHmUAKp/qJv/Tdg6hPUrT6m6cXzF3Gjt5WTQNhgIBOTJ9lxMQXxsDpr4j1AwsIeTEWD5Bwb3WKuW5dXN8lV4ArK9dTzaMitab5WgB+9bEFmolSb1BsKHf5YEv87tHxSib+J2E1pzdV5oOc7t/GIG/0eVPoaFOyBWbAnit1Q==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA0PR12MB7532.namprd12.prod.outlook.com (2603:10b6:208:43e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Fri, 11 Sep
 2026 19:02:28 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Fri, 11 Sep 2026
 19:02:26 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 11 Sep 2026 15:02:22 -0400
Message-Id: <DLCPXEXM5YQ3.GPN2LX0UL19T@nvidia.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <kernel-team@meta.com>, "Liam R . Howlett"
 <liam@infradead.org>, "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts"
 <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry Song"
 <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama Arif"
 <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>, "Jann Horn"
 <jannh@google.com>
To: "Kiryl Shutsemau" <kirill@shutemov.name>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v2 11/12] mm/collapse: declare the collapse interface in
 collapse.h
X-Mailer: aerc 0.22.0
References: <20260910120238.2529819-1-kirill@shutemov.name>
 <20260910120238.2529819-12-kirill@shutemov.name>
In-Reply-To: <20260910120238.2529819-12-kirill@shutemov.name>
X-ClientProxiedBy: CY8P220CA0013.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:930:46::9) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA0PR12MB7532:EE_
X-MS-Office365-Filtering-Correlation-Id: febe8884-b048-418d-1006-08df1037387e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|1800799024|366016|11063799006|4143699003|56012099006|5023799004|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	pq8iqTNLvhS7brvSCGfF4JD534byC2wH43g6zzjcTGWrgmwc4xMYihfrvUUBXODm5zfa22P4UBGqKUCMG9DdiMg03BTs6nf2cfIlkLcrnT+0M85+J4LXVy7qz5QR59zG/Sq5thkDadI3gtE75P2prdD1oZpcF6WLioSW7OgSoGKwWw0efxjnS2hBg67HdVfRW9kk71AGWOZ5HrVYLwFugC9WvcivhAbFw2279qFqKzUGWtAVgqcpM0MwQ82a9RG+CBMe6zT03cLAHfyGIP0RP8ue30Mt+SUnYxPe16SwTPxcg1F7ViiJRQ5C4nX6uDSMOfhAMPyRGWYk0WrdL3l52UT91Y6OMf0+L4Ws3kRkxBXgayF72ZmidMnfXdsElM6y/266UAgWZBeaJIVSRtU0erNfQ9X3ex3ZLPUxg2eOlXcIpq07R3OMQpp39tQw9eAFjXaERlBU/Z0VZt6CvJoejJmLN8zhj7pB6xGInMMvYU9i0oM4GtKAMIBQpg2E4wo85ZooQb1VzUu1+5lmkdwXXCtntVhWLJor3DZRSoLvg2HVx7J0i9hmaiMBCbDUaqzXDEMCDnQgLifw7kfg00f5BiKZyucPQLtfqQqPju1aq6s4nfc4205WPtQ14Enlju1LN44tg+y1gHU1mnMlwncQyDdW41xWcbcE4xAUdm++xxM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(1800799024)(366016)(11063799006)(4143699003)(56012099006)(5023799004)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZU10eWlDUXdzWHhVU3dVZ1BxNXBJRmxySU15bUxGd0QrQWRqak8welJjeXZJ?=
 =?utf-8?B?ODhpSTk4YkNHeXZBdVh2QVJXV3JCejNIdWRtMTdWMlMzeC9YUTVPZ0VERDVO?=
 =?utf-8?B?WkNiVEpmSy93ZXBkNndrNG83OGt6all6MWlzK3p3WUhDeHFjc2tkOWc3dDVG?=
 =?utf-8?B?L1M3Zy9TbGY3VmwzREhJOUhHK0tyOTJ3OFJUZnk2M00zMEcwaGpYbTFVNnNl?=
 =?utf-8?B?TThMRnovR2doTkdobWdYanJVOHdBZFRIcE9lWkZqQ3FUZC9LaUdJOElMV2lp?=
 =?utf-8?B?NXZmRm9OTURRQS9kaGx0bi9VZFFxV3RWRU1MdEpocDF5NkFwcHlCT2pjM2hK?=
 =?utf-8?B?bWY2NklteDJsa2t1WGdjbXlyOHZLNUovaktUS2pYZmxCdnh2b3ZpdnFaZ09W?=
 =?utf-8?B?ZGpLYTAvM1pHbE5WNjgyZUpPY09uei9wTkRpWW02Q2p0RTlwS0lFUHpEc0hp?=
 =?utf-8?B?NjAva0tOSVZiV1Y2am1RaDVIeFJoSGZrUm1vUnBIYThqUnk1aVpLRmZmT0N0?=
 =?utf-8?B?ZmcvZGpIeVp5NG9wNi8zaWM2aDdaaUV1SHBGd0RmUjI2QUNUVFRQMUN5N2o1?=
 =?utf-8?B?ZmFOaGlKOUVvdVkvTkJjbEozYjhOcks5ZTkvZ3d1TEZSRlpzK3o1YW9GZm95?=
 =?utf-8?B?RVdRYWoxTjFOeU8wZXNsZndwbWFCa0Y5cDR3TEtaOGVTOFBPOTdjR2c1aVZP?=
 =?utf-8?B?QlllUkJTOERLUnpUdHZHekFyMVpTN21jbFo0dCtRZTkxUlZRclQrM0JDR0Ew?=
 =?utf-8?B?dGNQUjcyMGgwR1hwMzZwUFlVSnBkU0JMZGpnenpZazNWbk5BMklpR1pGSFY3?=
 =?utf-8?B?TjhPeUZ0WjhRMzdDVTczWkdhQi9CSmJLRWdzMEJyajZKejNTVy9JSUFOUEJ4?=
 =?utf-8?B?bzR6ck5IQkpZTUltbGZsQnVpTlJ6SnNjS2ZkZ0tQSFRxT09ZSEtxb1BaTm9G?=
 =?utf-8?B?eXhlVFpxTncxOTZ3RnozTlpJYXl4dURPVnViVjlIejIycldEQWppMDgxUFdG?=
 =?utf-8?B?dlV6VmhzcWRTZ2w0bWx5Z1F0TElrcytZRTBwc2N0M0ZlcDZvU1hsQmhDYmNR?=
 =?utf-8?B?QkU5OWNFRUloWFZPYkdnVTRxWkZObU9oMzdsVHphRHdYUVgrOWVTaHZXbHpk?=
 =?utf-8?B?VjlkaWpHajJ2WXF6OEZWbXdqclF2ckNuaEdGNzJYNzVra3BVYXVIZjVCVFhr?=
 =?utf-8?B?RzdiWWNzRERFMjI4U2d1VFJuSzBuSy9YN0R6Ly9ueDJpVm9Sb2V0eVJORzJz?=
 =?utf-8?B?KzFUVDlBNXNYRmluRWR4Vkw2SzhjUUYvMmxBM3Jwa1hpaW9nRTBBY0Y0dUpp?=
 =?utf-8?B?REd1ZUNGOVZwMG1lSnJZWmJlbUNac0ZPUGkyUmc0TmZHU29pNVRHZ3BwWmZi?=
 =?utf-8?B?K2hoREd3UHdqc01lWkM2R2taT1Z3VU1aUDBDcWdFbHRmK3J1T3NVdCtKMmxF?=
 =?utf-8?B?VjIvRzl2YjMzQlRLTlRlSW8rZXZXaU0wditiUElMbXVQc2NUZGRrczVMcS9S?=
 =?utf-8?B?aUc0TFRCZXB3ZXlRVlBQRmh0VTVoRXIzZXphZlQ2bHpDMmFEeG0ycUFlUDQz?=
 =?utf-8?B?U1Vkb09NNXU0NVRNZDk5bVYySVkyWHh3b1AzczlDY0dIem1naWdsZG8xeU1o?=
 =?utf-8?B?d050UndRVVgrcTlxbnpkM1NNTjg5WEZjRFd1K2h6d2tkemhUUDFLZDg4Tmd2?=
 =?utf-8?B?UVk2UU9ES1hhd1FwWGRSV21QaWlodHJya2lmRFpBejBaOVVnWFU1YmE2dEh0?=
 =?utf-8?B?K0pNT1JxWmU3RHp1NlBvLzJBdDZDeURCVjI3a3pMeFlDL0xrbUUrbmh4VDFK?=
 =?utf-8?B?RzBjdUtSb2dBd0YzcHhZdVhKaFlVcFBBMkFVNWUyeTVDYU9YMXAzZWtiRWRV?=
 =?utf-8?B?Y3YwK1NFbWtWWThnaC9vSHNHaXBvRGNESlI2QTFzSmRjS1lQbWFodytyaXhY?=
 =?utf-8?B?TngxMm5meGxSeE5ZQk5IUFlRcGdRcXV6Y2JVTkpJVXVadWxYMnZyb0xYTkUz?=
 =?utf-8?B?eTBBK0N5S3lRWmlkUHBFdC96UG9SSWxNb1VDSjdWVjVreEpXQW0xbFZqQ3pO?=
 =?utf-8?B?VVo2Rk82VzRvSzZ0UXVkRjlDaWZlME0reURTSEJ5WG1nVDJ2UE9RVlQ1Zmpx?=
 =?utf-8?B?cEJIbFkzTjI5cHV4WFYzWUxLNUVabmNyVC9tWktQa1MzZjcya2U0OUtMOUdY?=
 =?utf-8?B?cDVpaXJNN2N3YkFiNlYwUHY1UU90TjErUnowQUNqc1k2TWxBUHU0Vm5YMk5X?=
 =?utf-8?B?OEhYaFVLR3RVOE9IRWdTTyt4ekdJbnhyTUJMRGRtMTQwU2JVZzdhOVlaVjJ1?=
 =?utf-8?Q?8Qhq92M1NnDjQEPuPX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: febe8884-b048-418d-1006-08df1037387e
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 19:02:26.8773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QkEPRKCH+w463WzRArcGdanYdUSeViqV2r3u0mJrn3W/5RiLmfXobvnxEEnc4SjX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7532
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 496BC180009
X-Stat-Signature: prpdaeame53yuq558nnbqabepcyurjqy
X-Rspam-User: 
X-HE-Tag: 1789153353-605001
X-HE-Meta: U2FsdGVkX1/i4ZnZJJlxtd6yT7sjgUc7jS9bkFIhhCvMUL1t06Lf9D35iU+BljGSn3VtCyisw9hr5og1++dWuzSWp4irUPzyo5D7VjC/e1wZ7HZYlB/FV4nPJYZap7XSQyAfSC7Z35ohIu0brjkiRfraRy+8gjRILWr2So7wEREeVcj95D5osWrBtds3seY5xXOjNGCo+YyNKbt/p7RIor1JRJ1b6Z5mx70VQBArvgXKvFBtpDLLpYf1inOTkOoPoOwj4AawR9jKSFoTpY7uwG7AEYUib3j/Je7iOM4oz4Ep/yRsCTymWQPCgvc/bhjgU7MkPdURgMvfICSLtoKRkX80VgbodRocbAz8vXwOH2O2IW1/mAVIBmxMbFIr+s9+lMkwH8kSTlCpEjstAMaokhck2cLmZYEXm+YmF1khF8KVySAJrz6pJIxtkwVbzZuGbdPd41LqeSfCK4/pm74lntHrrj8WI6Tk3dsn4jYt7nBfyKYDzST4X/btBcdu49TBOkDpUprzfjCT8rQGPWrvwZSVml5vwtmUFDHHKRh0R/DyhUnFxiR5uCA92EEAbl6zrcebYEy8zYBk/BKQ9hDfaZt1aeRylZ2GECacQInohsYUzmANleCC+5ksZBuorvLI3TXbEN8ABDFT2cicWoAbpKnWoSQNl7jKnOriXJdx0pGEfkuJu8NRcqNzAA0BrXEtSWDLAVPkCtxC1F1Fm1ZQO/Lq8Njs1OKFR2hfFSB6olEk3gMCP3NxjmspQ5vqzsFHacq0YY1XL6z3T2NYiWRBoubT322JHqn9vgrhJ5VUSILiaWSvN2XzNaW2FdPIkzMwFDbHQtUzHuoZ0DmMks3FpQKxpdP6AC2QwJ8oMgl3gDUiJ6wdke4zYx5mdtDsLMJ0mTsshO43GUWnnL7qRPUs3QLNpLIDz4pZqbU5WJe3jRE/XlzFb8RjNixz7Y6PELyX0FiguE/oDB8ZR7UKN3L
 dgTiBnCg
 DX4uxMDdTXox+/Tix+ZLMfl5ZIQDY/6lQ365tAiZL2awmGogTT/oZTAA9+/Kwv9ryiWAJ1kNzgj4k+vUK5ek6+UxulxMhs0BcEiAkFPo9/StseHGY32kzMgb4PvYtuzLze0nscYDSnAZfMedmflAoDouUWnsiktpyjwUONABYeN9HPV1v+ryej73oSs1+K9J0pcMm47wI+fxO9r/jI7ig44vxDA8Z8O6HKKPQnkfTjS1OY8IyBHTfatKvy9x7UpdZQwbML/jDW6bIgm1fiPsWjXuhjTBWaKYzDer1ZISxqBYmE0uf9aZKkM2vDdYms66iTle2oRSSThbaA1Jgv9Z/Fna4ilu73NwBVpe6sLVM8PmKal7suIl6ou02w3pfK8fAohcaPdV6ODk+0h6lMBUEHR69EA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Sep 10, 2026 at 8:02 AM EDT, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> A collapse takes four calls:
>
>   - collapse_control_init() - set up the control a caller carries;
>   - collapse_scan_pmd() - scan one PTE table, under mmap_lock;
>   - collapse_run_pmd() - collapse what the scan found, no mmap_lock;
>   - collapse_control_release() - done with the control.
>
> All four are static in khugepaged.c, as are collapse_possible_orders(),
> which says what a VMA allows, and the revalidate a caller needs once a
> collapse has given the mmap_lock up.  No other file can ask for a collaps=
e
> without them.
>
> Declare them in collapse.h, with a comment stating the order they are
> called in and who holds the lock over each step.
>
> hugepage_vma_revalidate() becomes collapse_vma_revalidate(): it is part o=
f
> what a collapse offers now, not a helper of the daemon.
>
> Preparation for implementing MADV_COLLAPSE in madvise.c.
>
> No functional change.
>
> Assisted-by: LLM
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  mm/collapse.h   | 44 ++++++++++++++++++++++++++++++++++++++++++++
>  mm/khugepaged.c | 18 +++++++++---------
>  2 files changed, 53 insertions(+), 9 deletions(-)
>
> diff --git a/mm/collapse.h b/mm/collapse.h
> index 346859a2184f..1ebbbf63fb25 100644
> --- a/mm/collapse.h
> +++ b/mm/collapse.h
> @@ -106,4 +106,48 @@ struct collapse_control {
>  	bool scan_retract_only;
>  };
> =20
> +/* Which orders a VMA may collapse to, zero when it may not collapse at =
all */
> +unsigned long collapse_possible_orders(struct vm_area_struct *vma,
> +		vm_flags_t vm_flags, enum tva_type tva_flags);
> +
> +/*
> + * A caller states what it allows in cc->policy and then hands over one =
PTE
> + * table's worth of a VMA at a time:
> + *
> + *     collapse_control_init(cc)         once, before the first table
> + *     collapse_scan_pmd(vma, addr, ...) per table
> + *     collapse_run_pmd(mm, addr, cc)    when a scan found work
> + *     collapse_control_release(cc)      once, when done with the contro=
l

This is a good overview of the workflow.

> + *
> + * The caller holds mmap_lock for reading over the scan and passes an ad=
dress
> + * within @vma, aligned to the PTE table the scan is to judge.
> + *
> + * The scan returns with that lock still held.  It only reads, and almos=
t every
> + * table it is offered has nothing to collapse, so a caller walks a whol=
e VMA
> + * under the one lock it took to get there.  SCAN_SUCCEED means there is
> + * something to collapse; anything else is why there is not.
> + *
> + * The run is called without the lock and returns without it, taking wha=
t it
> + * needs in between: what it does -- allocate, isolate, copy, flush -- i=
s slow
> + * enough that a writer would wait behind it.  The caller gives the lock=
 up
> + * first, and with it @vma and anything derived under it, so a caller ca=
rrying
> + * on has to look up again with collapse_vma_revalidate().  The run reva=
lidates
> + * for itself rather than trusting what the scan saw.
> + *
> + * A scan that found something has to be run: the file side takes a refe=
rence on
> + * the file while it still has the VMA to take it from, and the run is w=
hat
> + * gives it back.
> + */

It might be better to document each function individually about the
requirements and what each does instead of putting everything above.

> +void collapse_control_init(struct collapse_control *cc);
> +void collapse_control_release(struct collapse_control *cc);
> +enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
> +		unsigned long addr, struct collapse_control *cc,
> +		unsigned long orders);
> +enum scan_result collapse_run_pmd(struct mm_struct *mm, unsigned long ad=
dr,
> +		struct collapse_control *cc);
> +enum scan_result collapse_vma_revalidate(struct mm_struct *mm,
> +		unsigned long address, bool expect_anon,
> +		struct vm_area_struct **vmap, struct collapse_control *cc,
> +		unsigned int order);
> +
>  #endif	/* __MM_COLLAPSE_H */


Otherwise, LGTM.

--=20
Best Regards,
Yan, Zi


