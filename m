Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F2EDCA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 00:49:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D69628E0003; Wed,  3 Sep 2025 20:49:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D40AC8E0001; Wed,  3 Sep 2025 20:49:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2F1D8E0003; Wed,  3 Sep 2025 20:49:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B19B08E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 20:49:20 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5A0BB1A0939
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:49:20 +0000 (UTC)
X-FDA: 83849734080.29.24922FC
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2112.outbound.protection.outlook.com [40.107.223.112])
	by imf15.hostedemail.com (Postfix) with ESMTP id 819F9A0004
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:49:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=dtQcn3ah;
	spf=pass (imf15.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.223.112 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756946957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YDTEyE6j9iNq9rQ530ue73eAqD+14Rkt4yQxh1AotEU=;
	b=BwDRx4MB/EMPa2ICZpw2JYJkrQClKJmfOjEivKwfRzu5lp7YoHcnDfH9wZepKZpoi3Mkv9
	RGmnBWiuRApBHqHlbx3GHMIa79JGeEDwYxqoATPqguW8iUFvuSk3QQD92JW7+DR6nL3ymT
	DqU0IerRF0gZYWvC7ypu2l6vFdb9Jgo=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=dtQcn3ah;
	spf=pass (imf15.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.223.112 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756946957; a=rsa-sha256;
	cv=pass;
	b=hXfPuMHcxNpxzwpqEsY9aMUgLyQ/UQ/rDFHURP2SN5w3aLW0p4ma2B2aTnAu0ebWMnD8R3
	g4v2TekdTfcJJogB2nZiRWtyfKnLnSljrR/HTc7+6zo7J0h1CoU6G8wymhwiX8UzG56mRu
	hBi/jQ7gXbhep1lmPs9A8/xMHcd0ogU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iqDN8OjeZLMYHQKPbR87g4Si8p+xdnNYJScZk6cXfqIyo9XbHr4BKU1/qLioL3jKT9ed6IR+CLZMe0y0BUvxsg4gtf9GKqiY129MSoJQSyPmQlPyPNdsPzUcrU8PHyd45+R6y4gZbA0Gwa0eKtdlcF5ZwLoLyzNQz20SUGiO6Ap5dHzKaAoa2aOajQXjkhp4adSZxrCoVVrHjjmu0haJAHmeRXqu7aJgK8XyTmfp0UCcofmBHk5lmHVwTyssnOl57Nc2KY0/bGxrKnCrGFpLeN+cWNFfSquA7Fkpce3pMDdQF491G646vFhL/NKfqtXNhKeEh5+lCgmokiPv91o4MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YDTEyE6j9iNq9rQ530ue73eAqD+14Rkt4yQxh1AotEU=;
 b=nt2Sx6ArDMMifBNm4ZXKMzHESRaZdTNun+iV8GgLgiiRrzb68eZIw89G2QI8aQggbgWuzCvATo7cWnbbSc5GIJDB5VoVCOMBPiXxF5NYOw07Hb/Uo7LlqSRSu56g8cKYIcFejpS/GEukxyjroML5jRLCSCAfsfS4NV1cXG5bHSzMCiNicv/WqWLgWBfREBDXqp9ySiIfhvGXWkJ1OqPTbiYhtSYVW+PCoHsb5WnzEBEcgMAKxrF9NL0d92hS/LmFw9B5KRvQdPU6d2D0lG4JKxuVbxR691cgJjzmeDg/bWMcDqqqvQVL1ndGA/OuyE/P3hB3ekS8ULq1tqa2K23Adw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YDTEyE6j9iNq9rQ530ue73eAqD+14Rkt4yQxh1AotEU=;
 b=dtQcn3ahfoPEpQkrIgAMbiPapNnV8BkRBx7zCy2OMfft24FI0sxkzAy5mR279rw5z9fIV3F/xCcjM26l5uEaQ+rz6SkUpaVCfPYPVwnzv+J/VnrZsZtOZTP0s4lqLy9bpUfDIbi03q2DZi0cW4Kpjn3iuI/yEmmeRP8VFMf5izU=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 SA1PR01MB6735.prod.exchangelabs.com (2603:10b6:806:18b::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.17; Thu, 4 Sep 2025 00:49:13 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460%2]) with mapi id 15.20.9094.016; Thu, 4 Sep 2025
 00:49:13 +0000
Message-ID: <077c2bab-5b01-4d2f-b1ff-c54487e7abf6@os.amperecomputing.com>
Date: Wed, 3 Sep 2025 17:49:08 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/6] arm64: cpufeature: add AmpereOne to BBML2 allow
 list
To: Catalin Marinas <catalin.marinas@arm.com>,
 Ryan Roberts <ryan.roberts@arm.com>
Cc: Will Deacon <will@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Ard Biesheuvel <ardb@kernel.org>, Dev Jain <dev.jain@arm.com>,
 scott@os.amperecomputing.com, cl@gentwo.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20250829115250.2395585-1-ryan.roberts@arm.com>
 <20250829115250.2395585-3-ryan.roberts@arm.com> <aLh52smiWpVMCB6v@arm.com>
Content-Language: en-US
From: Yang Shi <yang@os.amperecomputing.com>
In-Reply-To: <aLh52smiWpVMCB6v@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0085.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::30) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|SA1PR01MB6735:EE_
X-MS-Office365-Filtering-Correlation-Id: c3582dfb-8aca-4b13-f958-08ddeb4cdddd
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M0NyamNGUVdVZkVmb2ZGN2lsVVJLOUVPaUVHb3JlQTVhdUNPNlZIWXFaWkMv?=
 =?utf-8?B?d29FeitqcEJuanRidzR5OGRIaW14WTQ0QitZVE5HaTNXYW1xQ2tNTUM5MU9v?=
 =?utf-8?B?R21ZWnk1aHBNUm1Ud1FOMlpVSEpxOUNQRFp6WVZNVmVybjBJb0s1R013M0JR?=
 =?utf-8?B?Ti9BeXRIcVlwZlcrak8rNjJIeG4yR1hPU0NncWVNVU9idFo0SzlRUmwzKy9n?=
 =?utf-8?B?cmk3WU1ieGo3Vlp1QWpCcE1DRVl6cldGTURlMzd3U0ZCR2p3R0pyZXJwTlpL?=
 =?utf-8?B?MnZvK2NYdG8xVUpxdWdEcGJsRVU4c0Jpb1dERU1aU20zL0VNOWNzMWk3eW1n?=
 =?utf-8?B?a2k2WjNaTnNhUE85MC80YlVuNHFENjBVSERhQndzVXlmRFhYeVZRNkM4TWE0?=
 =?utf-8?B?enhjVkQzNUllbHZib1Z6dUN6RkpPS2Q2dGNmSzdVb2lYMGdiNHNVcU92ZVNC?=
 =?utf-8?B?V1Zyc3F1N09POHkrMkU0OEU4Ujc5SXBBcklMRjBXVW1qOTlHQU9RUjQyZTFH?=
 =?utf-8?B?VllBK3kxdEcrQXNQOGw0NDY1ZlAvLyswWmt5dUN0NU9qM3ljRDZqWGlRUFZG?=
 =?utf-8?B?ZGl6cllYU1YrYzdzaFlHNWFFTDgwWHlvVFBVRE04ZENsYWtrU05CL0tXamE1?=
 =?utf-8?B?MkVrdHpDVUtTWXpJN3ZLY3ZRNnMxWVZ0V0dBYW50WjR0d0EvY1N5QmNCZWts?=
 =?utf-8?B?bjNScU1JWDBER3l0dlJxSDQ1VjJQQXlmQjZScHhaSDBmYWtGK3VXWS9HSmZ0?=
 =?utf-8?B?SnA1NUpsL0NKS0dhN0U0WEtKZmI3SHVUelhNc3NNeU4zU2ppOUVpSjhIR0RJ?=
 =?utf-8?B?TWZPRC9ZRnF5NnhtUWNwRExJczZNQTloOEhvQTdKY2p0cW5Jc3VOZUtRaVNr?=
 =?utf-8?B?T2NQa3kwM29UWEY1OW4vdHBXcXM0VWkxU1lTN1VuZGd3cTNlQWsveFdWMUxq?=
 =?utf-8?B?YitZMk1CMERXblVhbVFHNzl0eDVjSVJHMFY3OTBuR01WUEE1TVdqMFoydk85?=
 =?utf-8?B?UGJ0c05mMVhQZlgwZGdNam1DT3hMZXRZY1pjRURTODczS2ZXWUZiNDZ1ejdp?=
 =?utf-8?B?ZDNvRjVBOXUwQkYwN1EzZzNheGNjdDNSejFQbVNRVGl2MnNpYVBwa2lUdFd0?=
 =?utf-8?B?a3l0VlFCck8vVG51VVluUVdXNjg1WTVxY3lVcE0veVpZOVRzUHQzL0J6YUNZ?=
 =?utf-8?B?SWlSU3dOSzZyRXU0RFFQWEphU0dDQ1RtYXIyV0JVWTBMYW9ROFpmQWFCVFJS?=
 =?utf-8?B?OEt2Q0JRQjJpTnRJRlNEM0xqMVVQZUxMajdKQlFEd3VYQWJQcWplREI1TWFB?=
 =?utf-8?B?aU1kQVFCVnlWMnd4VjQxb1pKY01BdzBwQkhwcHZQc0FlRU43dTB1aUdRc2pO?=
 =?utf-8?B?RHppV09DVTM1M3dFaStlWkRzTmFTUjlVUys5dWJGcHM5RktEZ2tsTERSbURv?=
 =?utf-8?B?QVpPY3dTVW13SUxCaitkazFDejNrNEh4N042M09KRkNVUXF5NmFKb3YzM0M1?=
 =?utf-8?B?TWt3UjVxTGNIamVoTTdoK2NRTnlFRlR5ZmE0aGt6YlgrQkhMb2J3LzlSalFt?=
 =?utf-8?B?K0RxaFFLSGk1NVA1WEIvQU51N0tvTXgwT1cySWZGTDlONVlsczE2NXp3ZWdB?=
 =?utf-8?B?N2FyOXU5cDBham5UYllDZ2pUT1MybmtRTjJ2UHFBNFBaQnAyNVp6VHdDUCtV?=
 =?utf-8?B?NXlNeENqV3pZbXpZbmlqSG1OSi9McE01cGp0K09ZSnFSWXE0RnROWDlmbjha?=
 =?utf-8?B?L0RTTDBzS2xmTjBxempNMjJsSlhrdUdrMEcrSVhXeXRXcHlJWndIcmRoZDJI?=
 =?utf-8?B?TkNodGhOTmt1SHdXNDRqQkVXaVFENyt0Sk5lVmwzNHpabkJxcWJDaFVGKzE5?=
 =?utf-8?B?VkdhNmpLcUQ5aWdoVTlsQno4ZVpmaS9acnN3MysweUFWWGZOeTYyZHN4RmhV?=
 =?utf-8?Q?UJiSkjzuk9A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TmMwRXJNOVBWTUNVOTRTTUxRc1U0VTRUMmxaS25Qc3BjYUJETWZTZDB0TmN1?=
 =?utf-8?B?VVRxQ0pJSG9DMHdKY2lzd2UrT0hhRlJrVFdGdUhkZG9iSDNQaVlJYmZUUFEz?=
 =?utf-8?B?My96aUh1eDhBbXFNVU9WaFl5QkltVlIwekMvNXFkM2pmQ0tZcmxvQzFXZGU1?=
 =?utf-8?B?a21rUjFYeGp4SS95U2Y3S25SS1BNYXJWUkFHeXlFWXUwUUltc1NVSGd2Uk5W?=
 =?utf-8?B?bmplaGFlRE9PREhYR1V2U1dodGtYMHJ3bm1VYjJDcVNRNjRnUnlmNnNrSUdv?=
 =?utf-8?B?WU5FTWFiYmN0eXRKMU5MVDJLaVpaTzI1WmZ5NnhZdnRnM0xSdzJ1VEEyTnJU?=
 =?utf-8?B?YjNrSzJ6cnlxY1pRdGdQOHBkYzl6bzA5dk9Lc1BsNzlLQkpTMmtvME42blZr?=
 =?utf-8?B?Z0pValE3cjFVb3NDeU5TTkszOW9CRWhJdGJJQUdWRy9Ddkh6Y0FtRW93NEdY?=
 =?utf-8?B?dkZlWXFVb05kL1FER09hTnpva3Y5OGZmemtGWUdqZWZYRHg3dmNPMDJhUWZ3?=
 =?utf-8?B?bklxRWI3aHF4T21MdHpucXFGbllMc0lCYzRHVXNsWVVwa1ZZVDcrK3E0OUZx?=
 =?utf-8?B?T0pHU1NDYmRuU05IOUVZV3VNVjJpS2RjWVFEQmRuMHphakpDeHdsWERiSSsz?=
 =?utf-8?B?VGhQWDdiZGxMOFFuMjJpZFNvTCttRm5UNUR1YjdMYnFvVklYallkMXNJRk5s?=
 =?utf-8?B?QUs5SXN4YUcxRjBBNDRUMWs5ZGxUZjBmVVVwbUFkcFUvVTdnSEljaGFEcDdr?=
 =?utf-8?B?OVFoeHQwNDZmR1dtQ1JiVGNWbG1QMFl3QVZJWlNXb2hHcW9kaXhqdFNYcG1y?=
 =?utf-8?B?WmFxUmdZZE5MSExtL2YrR1k4akxMQlpuNDdoVyt3RTE4OEtZMkJjSTdQMDY0?=
 =?utf-8?B?L0JFVyt2a1ZMTnphWEZvNlJOTjhHdTUySG8yRUlSU05MNXp0Y0JNMTZsQnRY?=
 =?utf-8?B?Z0xUYnU4b285SjIyeW5JNmtTa0M4NXJRaklwMjMvSE9aOFZndEtmcHRVdm1C?=
 =?utf-8?B?cjFWVHVPbEpzdzY0Q0RQcy9TZ0R4WTNHZ29UWmNVV01FYUVuaDI5MlF0a1Fw?=
 =?utf-8?B?N3ljcjUrSW5TVDhmM2FkdXJDdVVTTWR2N2lSamMrbDBwcGFJc1JZZy9vS2Yx?=
 =?utf-8?B?bWwxVkVYbUVYZEU1Q1VUcTJpT0ZHN3BGR3RVSHpMa2JJdFlaRW9WUVBoMjBS?=
 =?utf-8?B?TXh2RXo1T1RMYjRyelFPMEkzNk10MjFMMDBKaFBkbi9ZakJwWjRMTDROZzBm?=
 =?utf-8?B?YUxzT0c2TENFb0tXMUVtS0pJdDk1TDBZNkFTdTBpZ2pKbzBiZGdGTEt5UHFE?=
 =?utf-8?B?azllNWgrTWE2Z0YzSEwwc25lRlpiK2xSb0N6a1NzR3M5bHBpSTdWS0JPQkc1?=
 =?utf-8?B?SktmdVpoWG9SOCtuZHpuMnE2dmVxczhLMDllOW0yYUVjMWZxcXltdFJMVDN1?=
 =?utf-8?B?QW1LaHZrZlRRK2JhU1ZyUkk5dkw2UHhqd2xwQmJFL3N1TS9NZURlUHR6a0l1?=
 =?utf-8?B?YytyWDJscDE4MUVnQjNMNE1yYUJGblZhdjVSSEhVUFRXSmVtZVFpUUlpL0Vp?=
 =?utf-8?B?bVdsS2xaQzRaWFJ3RjZoZHZBblFrcW1sdDJWMXBVdjB1ZUFaY1Z4bjVjbUY2?=
 =?utf-8?B?Q05HZWZtYkl1ZkYrY0dpSld3bzJRWGhUbmdxSTZQZDkzT0VmVXRhRzY0bzBo?=
 =?utf-8?B?Mlk0cVl6VXV6Z09Nc25jcjdDRU1ReFpZUjJUTXVkYVJEeG1NTVdhK1I2UjV6?=
 =?utf-8?B?TFc1Qm5zRDJKYjM0VDBPT2E3aWN2eTloQVZkSlNEWktXNjRpVWxtRHV0UkZk?=
 =?utf-8?B?SXlwWTBLMnduMklYdW1CYllmNWhRUFhucnVMRktPRTNEamVPSnhuaDF1aDZw?=
 =?utf-8?B?bHozTFNqU24xZFRPdWxFTVFWVHdKaHhDK29HRVhxazhGbVpIUU5ib1dhTUcz?=
 =?utf-8?B?ZFFHSEdXenJsLzdYSWVRQVpTMDM5dEI2ak1mS05NOGZkK2hhcSsvN29NejJm?=
 =?utf-8?B?ZVhkcm41NXRlZHZYQXRYTVlXRUdvWTNOVHFZWFZ6NXBiMllSQy8zMzJOQzM0?=
 =?utf-8?B?Y2pZRU1tWVR1bHhZNmFoamhTZjB0SERnNjc3VUt5YU1hVWFkL0d1TkpYdENG?=
 =?utf-8?B?ZTR1aHJVSnBYMGczSVdyNVlKMTVVbUFzbEROLzh5a3BlUkMrSFR4VzEyeGZI?=
 =?utf-8?Q?Z5YHBjs/+GK27ZDsrzmgmrw=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3582dfb-8aca-4b13-f958-08ddeb4cdddd
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 00:49:13.5109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cBGtlF+7Fae4jd0lheGJnRnemCA29OaciK0aNoozQMgzT9Rfe3IeFLkzcAmqILy+Ulx6I5CIm2qPn+cOhGqB2Vg2AqgO5GOsMS+SwMwecQU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR01MB6735
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 819F9A0004
X-Stat-Signature: g6rt1gnrmunf848uiay3tr4cbyw3y3fn
X-Rspam-User: 
X-HE-Tag: 1756946957-83227
X-HE-Meta: U2FsdGVkX19UPCccxjoX/RZVM85jqJEsnWraZe45O8i9FqsEs4dIP36AE3EbqQHENjS/SC1yws6qvM9E4HYHfwlethPsFu5LHpg20WA40gHbRSZcvU9xiRCbg3D8V44SY8fpOPJ2dYK/fUBjbBFQimAswTiFQQ2hrLHw+5Qw0y7xnTYQ7GPv3qjiZjjL10eTROXM2XNGuQ5IcEvzc0WikxFep54rmBVu/cO/6iSpyBV9qHaucebtAMza4C9wf+7QBPHvtTzISI8miDm3S88cOIU5C/zISmYcHxqUu9Id0lTx8jmWP5KzkDKe4AJ9lYr8VvWKP8AnTgrYkejK8IfKgqRrFGA7OZrALRmLPj5voEhXCfiQDk/x2o1lgZN07xUECkTYY0O2Lji5Vmdnp2ner1J/r2GJCQHXan6PVCyUncqgALhK6THZwZt+vXEIuOCNR0Biws1/2KF23842ygOIIK+mHofsystPw0wqK3QDJQtbne50iLOSkrxwCzFuMSWhPzYD9Ms0ogYOCRpQqqyiA8SUNM9unkc1NCm+9XrLwDdKhQ2vOQcR2xJpX89FCZN6a0NHwKib+CTUOySuR7ZatCo7wcnF4F4sn51TUT3Htag9ktdduGdqzgpaob2oKxjl8IMIxk/panlRFmFRUyZc0JZ+6MzmQ3NslWm+ZCDZbqn9uWUE9CCmGbryfkbJdq3OaE45CnPq3dALIPMwvid6ubD/AfR2UJ/dUlEre83BjU5KXRwfkPmJwEClI0nIMa7mOc7rJRhX8PhJXrnWg84XP4KQxQKnRl6YoTt7taz6gDiWLAGrCWD7IveeF80DKXMby3FEwzQGzLVpBb/bkd5yzTC0hYljNDV/rJYKNUJm4Pytcz/i2rHE6jaowlomnX0HwIcZv6Hk+Hh6Cxf9aZCgfP5hJoRhwsMWMTW4GtT2OzYalcBr6lB5ySMe2VEPrlf4zJKuoNOYqCKdYnhqDL7
 T8+A1RL2
 +cEOs8XWpBxJduLu6K/AR7e315v1oK4MArtkxbUAqBjD2NmV3eZS3JVVHAslxIovoC4LYBFbJn0cK+DCg2joT4zUKpAE9rI451x2Z1RrOlV1ILA1R+dfsQRemAX1DLvwoy4tLOQWxRmhlffx9IBk+eHLkUmdHrq3d/n4I5ezAYKfCqgfIC2JXCOl//qnjtZARIlhkW9VSa097KxhCMN90Hp8+BmfywR8yb9B2ZReTiGXMiCnzG6XkWnb0fi51aR8lULf/og7TQywodynkJUBYdzx/Z8RvU/Uzdeu9sQt1Mvr4U/hAagZvXT6/pb/b1I9spYYzDyY8DEDOXAunN3te3YNj89Rnc+k7knqdZxYyTqimbgDWBQbhHbnZ9pFlU4t0AZgkm95O8JyStrjUTo5mGnGWAkH7RCBPHpL8X0wTfUR5FOgnX6TcDlBargpDNjAflZz8IVf/EpCnVZXpLGdqIiLUEbI2e/PlFYyQZgtT7LxdiQUCgn5mvMfLOHwJ9uek7Q7cOdCrN3svuXzTSfXz5CaNE38Y+UXzav9LqPs9uLp/mpEulHfy/ZVvMQu2Wy2+sNC0tk0yhba+CLaJ+0RX3oEqKkZcoqMeAZtKRAT7Se4AhjDBQ8z2yMyqmrHqkiwbne0HIWHAnfkPpc3Et1ahojaLMNkqlWNUEA7kg42+Ev1HRYzv22ijZv7cCyCRoFwblHBcATCS0clmxpxrVUlB240mUNXynro406TEobwqEcTTDIJyDbEcFJW04v/eNM99gw4JcO7LwrR8XqSlrheOlqNAJ5nAVvZJe6lzO9ZqxsVv6fw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/3/25 10:24 AM, Catalin Marinas wrote:
> On Fri, Aug 29, 2025 at 12:52:43PM +0100, Ryan Roberts wrote:
>> From: Yang Shi <yang@os.amperecomputing.com>
>>
>> AmpereOne supports BBML2 without conflict abort, add to the allow list.
>>
>> Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
>> Reviewed-by: Christoph Lameter (Ampere) <cl@gentwo.org>
>> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
> Here it is again:
>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>

Thank you!

Yang



