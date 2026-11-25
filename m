Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69EC2606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 00:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=oracle.com header.i=@oracle.com header.a=rsa-sha256 header.s=corp-2026-11-19 header.b=zLreatk4;
	dkim=pass (1024-bit key, unprotected) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-oracle-onmicrosoft-com header.b=tNIDw7ei
Received: by kanga.kvack.org (Postfix)
	id 68E666B08B2; Tue, 24 Nov 2026 19:19:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63EC56B08B3; Tue, 24 Nov 2026 19:19:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DF866B08B4; Tue, 24 Nov 2026 19:19:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0EC076B08B2
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 19:19:08 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8599840DDC
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 00:19:06 +0000 (UTC)
X-FDA: 85471731492.06.4A3B801
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id D8F8E4000B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 00:19:02 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2026-11-19 header.b=zLreatk4;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tNIDw7ei;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf12.hostedemail.com: domain of william.roche@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=william.roche@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795565943;
	b=yL0+30z0c88G4U+GYMB8Eo3WClvGYxPRipm1bRlT+lM+K09kGNb6EaV1fMGBpCpzOh9Jf7
	7/uVsN8GhUOjqVTEicfPrip+Z6xoBEqVgs/6Cieaxt2vJkRLX7NT4K5paMARWGcG1tpxuv
	Juvl3ZtNodQ2AjoiX0a9R3eAiSO8qVg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795565943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gok2exRVQ0WVJp7KbYwSC2DYsKLZjtX6QKGp73k7jsk=;
	b=wFQ+R8GsjZhEKGx9IiGwyWGnATcGihNiilM+ET09v9H4Stjl1v3tWUizohR0nFnu4+MfZ4
	0aD2Y55nz8JtvcMuqNu/sLFHK4lp+JAh+16VqBErZJHfj4h6xNEIl5s1DT5MjaGsxnSKLX
	DeFPQ1rijWQXvu4gZNds5Nf5D4LfrMw=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2026-11-19 header.b=zLreatk4;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tNIDw7ei;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf12.hostedemail.com: domain of william.roche@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=william.roche@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AOMbUl22593781;
	Wed, 25 Nov 2026 00:18:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2026-11-19; bh=gok2exRVQ0WVJp7KbYwSC2DYsKLZjtX6QKGp73k7jsk=; b=
	zLreatk4FRe8VJHDxuXeTrURL1e6Dvw4OtMlxGZkxdDZJ2RGZlYdR4Nu+QJLybBx
	gYcgaS7jKb3fhsCbBS8lnL1nrhZzyVbgnnzhpgm7oa0OzG//7Z6k+p9FwP19cGNd
	1bVRP8jQIXVuRe5OEbQ9fY8RRzTsX4Jk6+cYj8AumkPsForl8OCNlh+hYSS7o1cb
	Wj5tBkcKXzDsZVFZy5PsKXGHffj83pP5WGJa1rNbU13IKkAY5ldAIOOjrz5QqbVd
	6jxBeRt++BV0d38ikCcF+dqdp+kpey240xhSdMi8D0Xzgi4UkU7aqDLlE/CuBjTh
	YMMAOjHVsaX9HH6K7q6Elw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4j34t7n1vt-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
	Wed, 25 Nov 2026 00:18:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.11/8.18.1.11) with ESMTP id 6AOMYPYJ1319158;
	Wed, 25 Nov 2026 00:18:32 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010017.outbound.protection.outlook.com [52.101.201.17])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4j5jut4bex-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=FAIL);
	Wed, 25 Nov 2026 00:18:32 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=epma1/TLlXbVHpMC0Ee4mWxKBlOLxeZJ9eYwO1akAU6hSyfNAB8ZJ6RUqekYM8vC5zvOAkLppNtUqfgSO5MxJ7irFs5MYTkVEFgLN43MSoOj0r9LZHchR+y9e/IARKAAMXqfte2f2xjr5yQM/fdRHNEKnOB9tRb0rXyRR+SQr3v1VHeQoakTYBrXLbGGy5O2jwWalULf1qm5HuBOs1XlwGdk4mfNgxLwQo6R2MjEME9Msh9Da4MdXm+hiVtbbZborRYgzQoR/oXrhDAKZEMfRrv/NGLAZHSTDga95NwYaKgUuZBMuGTDUZ4o61BWCdwYdoN2PSf0Wfu0Lz++ZR0ovg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gok2exRVQ0WVJp7KbYwSC2DYsKLZjtX6QKGp73k7jsk=;
 b=DJpQPMyYjsdHQhKQFzaGR9YyO6kTUXiIJ3zQ8svYC479dFo8h1f3D5shEkxufkOsqVf3m9M1FLTL/Jc6WYKfbPuSaHljRcNDlAt32QwSmKL1zzB+PD3ityMUcFWt03HMqL1pALVrbJoEbiBmw8mqszOhHqjHIxr3RPXWoDlQ4YS70U+c5vk4dPtNI6b3vXvJSzBrmQX0a9CkhzRMxl8of4ijb7lFZApc/HrBA4BOf5GaUUPzC04RouzqIv+4rCzbqE3z9k6Wcnw95MAg+g+/q6PQpKt6SragO8vGSgr6DwPIqhXPj95DRi7Nuuc9aVcS9nJs2Z1BF//SukTgRiYRVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gok2exRVQ0WVJp7KbYwSC2DYsKLZjtX6QKGp73k7jsk=;
 b=tNIDw7eiFCch2QOZDSXpJKtxNnxz5mVK7Dnibr+mKJ0TOJ8r1Hgm/BAAWgdn6mNXXMF96OyyI5y1rOwU3OyMvNt3EJ515CombE6Dx3gR1cx0OzWWL/BDAyW7+Otyra/erdDSBhK43L6lpdgZzlE1jBr1Kq8tuEizy7uB+Y9k3/s=
Received: from IA0PR10MB7349.namprd10.prod.outlook.com (2603:10b6:208:40d::10)
 by SJ0PR10MB6327.namprd10.prod.outlook.com (2603:10b6:a03:44d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Wed, 25 Nov
 2026 00:17:57 +0000
Received: from IA0PR10MB7349.namprd10.prod.outlook.com
 ([fe80::1e7a:452e:f372:b522]) by IA0PR10MB7349.namprd10.prod.outlook.com
 ([fe80::1e7a:452e:f372:b522%5]) with mapi id 15.21.0639.012; Wed, 25 Nov 2026
 00:17:57 +0000
Message-ID: <4a04e29e-a0d9-43e9-ac90-34a36d6a7904@oracle.com>
Date: Wed, 25 Nov 2026 01:17:52 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] selftests/mm: test userspace MFR for HugeTLB
 hugepage
To: Jiaqi Yan <jiaqiyan@google.com>, linmiaohe@huawei.com,
        muchun.song@linux.dev
Cc: nao.horiguchi@gmail.com, ljs@kernel.org, vbabka@kernel.org,
        tony.luck@intel.com, wangkefeng.wang@huawei.com, willy@infradead.org,
        akpm@linux-foundation.org, osalvador@suse.de, rientjes@google.com,
        duenwen@google.com, jthoughton@google.com, jgg@nvidia.com,
        ankita@nvidia.com, peterx@redhat.com, sidhartha.kumar@oracle.com,
        ziy@nvidia.com, skhan@linuxfoundation.org, corbet@lwn.net,
        david@kernel.org, dave.hansen@linux.intel.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20261115160105.2507650-1-jiaqiyan@google.com>
 <20261115160105.2507650-3-jiaqiyan@google.com>
From: William Roche <william.roche@oracle.com>
Content-Language: en-US, fr
In-Reply-To: <20261115160105.2507650-3-jiaqiyan@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR5P281CA0023.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f1::15) To IA0PR10MB7349.namprd10.prod.outlook.com
 (2603:10b6:208:40d::10)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR10MB7349:EE_|SJ0PR10MB6327:EE_
X-MS-Office365-Filtering-Correlation-Id: bce93c29-7104-4b45-6b61-08df4a898e2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|23010399003|18002099003|22082099003|261022105027099003|261022113327099003|261022075727099003|261026140227099003|261026121527099003|261028144727099003|56012099006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	cX7AX+Z5a4J9tGl3RpNuQDKkxURegkGzIxTXgBqM327xEVGrs3GNW/0wgChDjh1pWpfD8TG2kGvIUxxwgdVfarxDEFXbTjX3sP8PGl9Juhy000h7KohE2psCJSviU3RUpwxdirKscPt1dVuyfSWobRrPBmx6vB2iP/G0DwJevYw8xAyyKEJ5ODY7ir8na91g+Qz3PO8ZpTiEx3VgZSryvtd97rO//Ipcey53xBkCtD25AV+7lXKBaZE4veYRiAtdyJd76XZbWq8qyrqZHZpVGifMnbwR2FBuGCQg792e9LQI+y/dXU8klyyIz4jcue4kPL9+QUVKlXuFfdNQI8wFug9c50GXTzqorg7PQ7mzsElFpuVSySx+6TYgCrUI+JcOB9ucI61Hle34z53QBAzj1AvfyZQSws7RW+kG648gGtfmfi3QjZwZAx8g+PJTYv8cIxfFGDDb9dCLKI3TxOKByzzAmuV6NsZnzCKkgyx9i7pmZIDKi8gbqWY0B9dwIZ565M+e7YaeTFtptxu70IIweFoCrMcdKbFn5iGiaObYCqfJxlRvbLauf1llBpjyxEJ7cp0fHhX85G843reINo0qilrwaVso17Tys3HF8OhIIhj754/JL+5s9BY3fI8Jw6PB0vG37hMtkl0fXkrQOWuITMF1hZcyb4Pg4f35DC/xJQY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR10MB7349.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(23010399003)(18002099003)(22082099003)(261022105027099003)(261022113327099003)(261022075727099003)(261026140227099003)(261026121527099003)(261028144727099003)(56012099006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QWV3VDV0Umh0Q1RLdDFYbzJMN0tQVmZtMFkzeldCSlFIZkhQZ0p6MkY4MnpI?=
 =?utf-8?B?RFYxR3FZVjQxN3RKNjlveFBIYWxUc1FudTR3TGFNcC9MRituekhOS21WWWxP?=
 =?utf-8?B?YllNckZOT0VIakFPRmpCUmdGZWNiOUt5cWRqREtKWFpjRGd3dW0wNWJZSlF6?=
 =?utf-8?B?TEh3VEtITjZQN3F2L3VtWlRqSERQY0g2cUNKa1NJWUlVbHovakpjTmdEQ0Jh?=
 =?utf-8?B?dnhpZGhzZzNWY2dOR1FTR1BHV2tVUFNsWlIrV2tqZXBBYWFGWG1hYUZmSGNw?=
 =?utf-8?B?enhGYVhPdWlEbk1ESnZaaWhWT3ZVSWNmK3VjRzVqZHpUdnJKSmUxRERGZG16?=
 =?utf-8?B?a0dmNjJQSml0REFQcnNVK3lpK3FyVU5CcmgvVW1SVS90Y3VjUjNXb3p6KytN?=
 =?utf-8?B?d3hHRzh6MEdhZWF1SGQwb3h1VUN3ZGVJUG5MdjA2c1hTYnBlOXBnd0dtb2NY?=
 =?utf-8?B?MUN3dWM5Zmk5TXExZTVjeENZYWdGOEIrRmQ4VTc3ZFY3V1MrbERvaUJzcUJY?=
 =?utf-8?B?cG5ueG1iZ3RxNy9xTCt3aHlaNnBTdlRqbGVjN2EvNTVuYVhrU21vdk5ZT010?=
 =?utf-8?B?R3U1c1hnc09JQzZkeHlaTk51azdtUktyYVF1SzFpOUxINHVnMm9JTzBrQkdn?=
 =?utf-8?B?YzRXTE8zcjR2ZUh3MTJnb0JyVE1zY0J4WjkzZ2htNlAya05xYlNVQm9RQk1W?=
 =?utf-8?B?OFNpQkg4RFFHY3JidnlFcTd0TkVYbzlmZHpsWUhFQW1xc3F2NnRtWEEvRHQ5?=
 =?utf-8?B?SzYyNGgwOWNnWER4T1lRRGtVTVU1Y1h0UlJpYThwbHg5RDdLM1l1RitFNjBQ?=
 =?utf-8?B?K2NSTmVRTklRZlUxR2tNUFBQYVlLTXN6L2UrUVdZTlVFMnNoaWh4d2ZadDZG?=
 =?utf-8?B?OFJaMzFQYUI0YjlvclRWY1ZPS1lOM2Y3TkFpaW1XR0NvVW05cFJ5WENzRlZK?=
 =?utf-8?B?SHkyU2VSSU5VSU9DTXlHZUIwUFJhRHhKTXpsS3l3dDJBUFlRRlRXdWExd3Ba?=
 =?utf-8?B?TlpDNDh5VWovSmx1YkFGTk1qWTZGTjRMTE9iZmJhOTJrM2U0cytLd3U1a1Zm?=
 =?utf-8?B?VVR2U0pLalhaK2NuTlNPM1laVWdaRmt3SFkwbXZ2VzZmckIveWxMaVlSVEVC?=
 =?utf-8?B?Z0QwWldDVGJEbzFVRWFaR2lMK200eUFibXVOMVpPNWp0VnFZaC9vSVFOOFJz?=
 =?utf-8?B?TDBKTGoyYnNkQXYyTFBSaXBlQ3l6aGNFL2dvMEhzN0drQXRVMUxkWko4Mkdh?=
 =?utf-8?B?alE4ajkwTVNMWTZEMkhvZ0FQMldnbEc0ekQxcFVTcWxxWk5HTFMyZE9wREMx?=
 =?utf-8?B?eVZmMXIyY1JWNythMjVDU1pFd0JrcDdjSGVSVis5UFl5azdkOUxBV2lpV0NQ?=
 =?utf-8?B?SUM0dmtVUkRJNVhVQ1I5ZjZKMXZUaEJBSnZlMytEL0FZdGxuNyt0ZWNZSUdy?=
 =?utf-8?B?cm9lK29FOGJqM0tYY3Q0NE1HWkQzem9zaC9pSnZ3eXVLZ1pvOVdtVG5EV280?=
 =?utf-8?B?MGF0YUJqL3BRMTlGV0pPaTUzYkFlWDFTQ3hMcGJSWHlyQ2R0Um8wVzEyTW1S?=
 =?utf-8?B?QnVTcDRIWFlKamhPOHpUMitCZUNDVFVXb0NDMnBZRjV2SjEzMVA1YjJKalZ4?=
 =?utf-8?B?NFIvbXFnRHZValQxK3VZMXFSaDM5WVh4S2ZGNkxyMjdSQ1BwVERQUjU0TFo0?=
 =?utf-8?B?Z0gwa1oyVXRzUEZ5WmwyVEJCZVZnaEczZmlSYW1mOUlHTjhXL3FUZ245RElq?=
 =?utf-8?B?elZuRWJoeENnQ3c2Y2hVenBUUUUvMytxYzZHZnpoSEJ5NDk1cDVBRjFmdGc2?=
 =?utf-8?B?ZER5UXdBZWpJTVFJVDl5V096Q1lMWDZKTnVXUkUrYnJZMWZwRTdodDZ6TTNM?=
 =?utf-8?B?YnVEaXpta2NOcjlvM28vbGhnZS90dFR1MkwxTERZYzFWWGtXWUErZlh1OWRB?=
 =?utf-8?B?clN5QUlEOU44b1ByRTJiREQ1MyswWUsraGlIVGV2N0hVcEtIQVJ2ZzkrU1h0?=
 =?utf-8?B?UW5VK3RhYWszWUJKVFd6TG03bExFWWt5eWM5cGwyR0QraE1NejlsYTl6Qk9t?=
 =?utf-8?B?MHBEMVVYQlRIeGx5OFJjNmczNXArbG1IMXNHS2dhQmRsczFqT29rVlpUUVk3?=
 =?utf-8?B?L0ZYenhEVGVKV3JzUFlIQ3A0Qm02WVV0dS8zUUxzVHZlT3VhYk90MS8reUZn?=
 =?utf-8?B?Wndkb2grUC9RRjl1N2JaUHdqSjdvM2lQRnNyTTNkVmJmTGxhK1d4bFJTUFdu?=
 =?utf-8?B?YmJ1Rmt6Y3Nzbld2SU5RcnJTUUx3SEZ2Z0dwQXFqQkdGbWhQbmpENWtiUkgr?=
 =?utf-8?B?akluaU1PaEQ5bmJ5YVZxVk1UN2tZNG12U3V6Y3NSQ1k1WVlKU01RTmpqWFR2?=
 =?utf-8?Q?hP+DdIRP5r5nCsMo=3D?=
X-Exchange-RoutingPolicyChecked:
	muEbx4r8uovPPpUYPEM9wl9BJoHuBitDmxuSzXWrItV++wwlttoEWx6cuyszrmFGknlMzJ44O1vKHduYnTIIFBk6Bt313jbcmZvWnTRDMSZAeEubgdNiPbJX5t/Brh3GJB4wPW5wtamnKlOdvv00Hs7/5NaSqLom66QolJbvHihN9paSH4QPdKlqlGsCIxZjRKqXvIsK8acHCqhaN/Kk/EiVLWupU2kBWD/WT98g1rtNYsDAs9Vz0K0DweXRlU/yRcR7zSnC5h+y2f/BiFJtmP8fx+HiojLADRoQvl8q5Eki1RbX+E6sJ1PPT8eAspTE/OF0Sia5KWW8brKiliD12A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	84JvE9/ybMxwVImjwKmD/ZgHp4ou0XEAvKxhaKEaNXL1jxFYM8LTBzR1jr6VAzC1csQlpp4m2BZt0gm1EW5zabdC7MyvZAXe1j6e4XH48hJ4F+srqqCBtdXKLeTq+MC3OlbJrzhcA3LwB6eWyIzpoeW/HRsi26+gvCt4t5MIjChYXGX0WBboI0ApHQCH0DpZsgtyVz0+AfZ2aaCFf0LEIw69GE/NHbIwcb+Ukez6HWni7N16H5t33NZ57V+gjQswaRgxYfKLnFkssuKLdB3bccFdSz2XO9Hoe/12M5+xEn10ghHV/gnRFksWdcVuA76UDuAwUPqZdp1aZxxZnXy6zBCyKZoV9hNeB5zm02qDLScUjFa/4zJn/vAWgiQzSfGIkfLJgEyVgtTJJKq+djPZMH1lKyk/9TE/JjB4XezdorystZuZ65G2jz+XIbKRgNFyWF3b1jx92Q44TXSK3xrDnyCmO2+ZzU8u80T1aqc9mpj+WcfZ0sxCLf/f31OCQtmVXd+p66TZAIEmK9T39z/yEpCwGMvO8vu1iZFxoFzRC+ucc1R57pcHZh57i8ERfJes9sNbauMeDvKFe0T9MzcE873GKToT1rAUd4/YZfj8iT0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bce93c29-7104-4b45-6b61-08df4a898e2d
X-MS-Exchange-CrossTenant-AuthSource: IA0PR10MB7349.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 00:17:56.9932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vsj/eNmuam4pLnVgcqWhBG4OQVC4sIYWcXug555g1M31wUlgPKV1n8r8966ijKJcL9ZX25+WpEpUeuUhG12Hz7Rj2SMeF4oD41542kMYAgo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6327
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-24_06,2026-11-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=983 suspectscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611250000
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI1MDAwMCBTYWx0ZWRfX6KfosVWArxVk
 9+a96YMoxmCyDNo6W/at+moopJkt1T7x6KjU3wsscK7uvP6Dqre3g6G2IY3g44N47VU6vkTPwpd
 ZvSfsP0d0RdM/LDoTm/0uy2iz9DWE1VoHfBH9ynjFikunqLPnkON
X-Proofpoint-ORIG-GUID: 8GbvswXuL7Th9c0RnbnM9IoDuLRBNhM5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI1MDAwMCBTYWx0ZWRfX3ejbZxYndD4g
 P4lFlQYOKw/xRS2He/b5i/colfvAr83Tqd0i+QIOlOnUwUS1vCmrV19SqUY/KwJfXoFUvkAGSsL
 ajU5W8k/2mmU166Eu6huemZekG55TVTj+FRREJ8rqsCiKUHc5X2ELmpW5wgJCPTKcjahMb7iqeA
 6iuXNcZbir6atUKX3Xmwr9Gz1PQ72I+ligVh+Hh9U5qAE14IaxNcfgcc0vTMbd8N5FaEEOSLFHd
 ZM52hU60P38p951/TFit2yf48bG0j00E8bcR3TyDnkgf4TXaCDHWPiLpLfu3evMi3vAwxYKQikj
 Py/3wEA6Rd9kyxvv2yyIyRyeodNAn+m/JindprMrc3a2fBAU9Jc2axby5ika1W7/QyV79mbLWI7
 PmdjDwprjDvLXrYXieqC16K486VLca1wdB/fKxnnVSyFNrtHvYYNqEOft/ChwDn+QdNWXc9Xdrk
 EVbmIcK3qq/FhwZQBk6hIVPWWBVD4sN2ISSKBipM=
X-Authority-Analysis: v=2.4 cv=Cocq4X4D c=1 sm=1 tr=0 ts=6b062959 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=jVm0pqy-w_Lvylt8gQkA:9
 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf
 awl=host:13532
X-Proofpoint-GUID: 8GbvswXuL7Th9c0RnbnM9IoDuLRBNhM5
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: D8F8E4000B
X-Stat-Signature: pet4tttxqtgbar5dcotwfoscnnfs44eg
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795565942-279624
X-HE-Meta: U2FsdGVkX19n0jTjW2eW4PG/JrfFwyJJoxj3tj3ZSRgocqjdWuDzkYG2SsHbQ96mo3+JBu9RGu6lrtt32UbgcJ+HW7k2IlXUfnNVBq3NtRV0GsW4icRRSe2IwuQh1FZ8k9caBmuyebSFB3WZxO+PminicBtZupR1KTWzA8mT4VV54nIQLiZeBoIS5noGiQT/xabap7zhKeC0NjBPnuXGnsDMgsPfJDf7VINdWaNAIaCOvRWxlAijC1b/zZ3g/HlB11O0dBua1Q7UGYGfpJ5fflP8clILxClg109PuvB1RCghGXV22yK8YXD0ParOvN3dPpYfLwPAzhrRMUDcB0SJAleC+/cwVM9/gVtAMEf0NaeBUJBHX6VvX01CnPhSeLLpoHqqmkJNEGYTXozwORPeYvkOzRl09Lz9MspUccpCCW61IQ6oQ8aSTaXE1ux6gm16vLK718QQyYYDO9cbSyPD1HAnKNEgLo0E0LnBXIIW20nNwPdUwhyoHG7Y+XzVT5W4XxRZw6c4nVAVj0uEiY7a8F0PITBjJtDvJUpns4jOCRqdA2LayLjmmvG6Eui2K/+SL2gu+bho/eDkFmkzOD12ouHLX9s5eDmTvXwYOECS81wtxrxMhnbo0zL7zIC0AwZ4EU9y9JpkfG2IaMSCyFqfzQfqWY6mVhZH2b/9xaCF011mw3yakPBB4Ut5AgihQKqwZF/c1wlWIaDqA5GzL4Xt2tNZJAeDLVPYmgLrKSxUCDVMsWP6sKX29fNpQjaIooFylxQP2T4GjE310F5McFQD4MyYvgsmsUVBBD1Zx7Lp/Pnjy8mnFsTM8W8CmTiX57VF3nc4rVfK0RPm4UXlqHzCKrt1jIYHb4qsPuFPA5TiTnzqidSYntwvdisEiGDgqpeiruFMp4AFTINkMv+8JQr4j6KHbYnffFeOSOyVcqX4g57osXdfrsj6Xcaou8rsPiwSFyl7O9Go0WPbjffdTFK
 UpSPxvso
 XTJVZs8cBj4MG69HB9fCBvK2V7gUiZgv7g3Ck8dqyNa/4tcVOCI46TXPTJGHk11MO+cQKIyfkHDOyArld6jt/E1HoO/joKQXS0oGGNffcl47bTxKBBmHEvJn4biMlbNTWB4ueNTGTA+X2TDfRfTb2Frof+80r+SpN4eMWNNuD+GQk0YujnPuLrOLJBWB6r1JgZYZP54xuCPxHE9imQiY+3K5y9+tkq5DwCUc4k65ZA9eA6NhoIExGSzg23DIIR8AdbRhaMckrl8flw8KxSUyRiua0kakzyjfefvr4/XpWBbiJwVcz6JJ2IhikSleJC/B7g4znDnF+OplwzO4b6fM+aBUPZo8HzOSJjBJs5Bv3VHrrSTtCWhGvQUvaSOGpTNXEH7veHrvvxHshxXyNU1FmYfN4dU88LwG6bPRfGXWMis4uaSH9/i+BlpKkKZDcsDNI6snIvsVTzUD4tILH9Gj3i5dtZItpkHderVwIsAFJtGFZoA+sK4Q9wn8EA49JRBFh4YwJj1TN/ppaJ4mWIhhSg39McH1JUtTeU2ddWck9LY2KEQedD4pRg3y40fBXgojNUiWzrW5jeuAqUquWaH6BeP+YtzCsU11NZIq4vmC5bdTimDvrfHiaK3BZztEwb2IJOwRLXr9grsBqmW0tUYFAownmfnyplYE4ubzVx895QjBWB2Oy2eGKLR854vTi86Te0pqeoxcjX75/jEJmnNRI/YEvSJz3KFt3KP1nj3k2EUvSRj1ygniI9L6YfO45//faflOHRSZnCqHmCtpMyYSjK/Af/p49OUOvmhsZoSTgEl/dSwg/ZVMLPxaqP7nXHuIz2VsW4TL3GbuHeMKX9nof21E0KfQ+HBW8DVeH0J5aiBwXcieTiILQ+u2EDz+PF5IR8aHxJYxQxLAl8DAbo1/NVMLI4wGqt/irvqoEwrT8F6LHyGv7rMkMPYz8+cDsGWVVRSUbGvffAHEGAlIkY2rItiLo/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

About the selftest:

The Linux documentation indicates that there is no fixed debugfs mount
point, so we should probably discover the debugfs mount point instead
of assuming it is always /sys/kernel/debug/
My March 20 version did that, but I haven't found a C test program
within selftests that dynamically does that.
So maybe keeping the "/sys/kernel/debug/" would be an acceptable
implementation, and could also be an explicit test prerequisite,
with a clear skip if the interface is unavailable.


I would also suggest to load the hwpoison_inject module before starting.
Something like that should be enough:

         r = system("modprobe hwpoison_inject");
         if (r != 0) {
                 ksft_test_result_fail("Can't probe hwpoison_inject 
kernel module");
                 return -1;
         }

Just in case it's not already there, and we would like to support a
standalone invocation.


I also agree with Chris: The default test should run on 2M pages to
have a better chance to run because of lower requirements.
By default, I would even suggest running 2M test first, followed by the
1G test when that size is supported and sufficient HugeTLB pages are
available.


HTH,
William.

