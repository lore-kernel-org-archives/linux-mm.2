Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F38FCF6A88
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 09:05:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97A056B0092; Thu,  8 Jan 2026 04:05:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9510E6B0093; Thu,  8 Jan 2026 04:05:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FBF56B0095; Thu,  8 Jan 2026 04:05:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6B57E6B0092
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 04:05:26 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 152FFC23E2
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 09:05:26 +0000 (UTC)
X-FDA: 84308213052.22.1FC89FB
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9CCF64000B
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 09:05:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=E2ANWv6O;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="X/PievSv";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767863122; a=rsa-sha256;
	cv=pass;
	b=qRDN+Xb6c7mrzpqPNiXkvEyVr+bN4CiTTU6prRpZGn0FixUVHt82Pm5aO9vdl0WxmnhCiF
	dM3N+WcYrJ0SwGKL7Hcic23LE+nWJHWLOKVsqWHiWaR46VQO3ceRT0DdpXI3l+8cweaU9S
	isFEIoi/an240EiUpf0ofsz1Gzrjhmk=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=E2ANWv6O;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="X/PievSv";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767863122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6dOaFftYlAY4zNa8UyOvdRgL5D2Fy0oKJF4V4x9J+HM=;
	b=juxOsZEmf+NzZ4QMas44D0acbiTi/nv4QUeL5Fq8VK5eEoUabMnu7or+q8JEbdv6xI0OFm
	itZHPuFIA3h1XOZSE/6cVkVjm9W/GhzAMJw4Rqn/zNpku9CXnUJYrMs2gjO8/d8n/RfiiD
	IAiRW0lt+kb4Aeh67ZeMD7s3mBVO/cw=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6088uZje4152064;
	Thu, 8 Jan 2026 09:05:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=6dOaFftYlAY4zNa8Uy
	OvdRgL5D2Fy0oKJF4V4x9J+HM=; b=E2ANWv6OXEdyT1//NyVAPpCxK2YU7ZyRSK
	fVb7KCKlZ2M+6j0EtIlp6cxfjpFFDihOSWo2Z20MwD0oc3FWjwlkvy8JyH7IKqtF
	Z7hvy93pTBn4SqZRWT2sXkEnLeqmdavehxV/RRnbp+LjU+fCuSQwk+6hpdcmOxyS
	KwxqLx8d8+1vu1i2X0gcDfC9aqaR5MGGXMd8H5mvcKwlXL9wob5vdDCTlJBY/6we
	GNj4Ln3nOTSUm7EMQdVw+TQB6Byblzns+/elWR0rPD7tyuFp+b3rurL6UqRpBtOb
	q8rOxG/09e8KM6SB6vGS+kVFhWIn0c6K+M/Ry/bH24qO+JU7KMWw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bj9gw809n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 09:05:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6087eMMK030832;
	Thu, 8 Jan 2026 09:05:17 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013049.outbound.protection.outlook.com [40.93.196.49])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjevx4v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 09:05:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=czBuB9gxIBjaDbzlIHEVAD6524hWS0KuguZXLpKhanl5USaMFVYa2qNtNDYvYB9nUvCw+k+WoxeNOASj4+9ot7xnFSKPbHxvTDlwYT2Tr88wI0waPm3e71VWrQdZcVvqEHM6WDoQ3yv2VZDtv3TBFscOUG9rQ9+PIEIClEYvVx+lPhnge4lAT1qknryICA2sJEv5cBlKiH7a8M0k8sKqhKaCdiiteRnZ+prTmkE/gC/URqKOAXzxf7QAw/JdMNiXq/1dUrqsthXVWoLsv7wSTFffZkuVErZkYp3Qn9ixR34kGsUfWAfw9gNwqDLqFb2kTUEZ4Ef6E3Mij5q/h1n4hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6dOaFftYlAY4zNa8UyOvdRgL5D2Fy0oKJF4V4x9J+HM=;
 b=Nmvp1VF8e0ThvpflG5ujGDoOziv0fgZDSEJIhiIqlvqXN8aZCBLGnbS7HI2VPFr+HGTH81y3Za3UAqWSzeXTO6d+k/tBhr0l+zauBiGjPf2LnpUoCSGG8Xq1gAoPHPJGfRKavF+wZcz9bPAM8kvtNIiuWAsNMm01ypQv4A8GDBNzMQM3eacGveeCw/Mxq+Li5MWuuFkwEeBa3JF2IAwr+Zv6kR+7y3rrAakS+5BmvdJws1QksKphJPLqaJZ9LO5TzU5xKIQWVBlE+H35mD3FMlvkl2Hoj/FFmhch/rKNXb/GKKfF4AvcidZWSOxvy6KTStSt0WkazVBGkGw7ThiyDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6dOaFftYlAY4zNa8UyOvdRgL5D2Fy0oKJF4V4x9J+HM=;
 b=X/PievSvaaJxVcVtqDNqTAytQvHZvlM6BOLQUZoKdU7sSjN1zgou7x1E3/pmwrmhBjuCDCojLsQUksqfO/zAOZss9LEG9wFSYxQ+nkcLm28UGk40l7K4NCh1fzetXYfQ1tB/Ypw5A+/xWUI1POfOhfIiv5PRpiekD6ane65Q1hc=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ1PR10MB6003.namprd10.prod.outlook.com (2603:10b6:a03:45e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 09:05:14 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 09:05:14 +0000
Date: Thu, 8 Jan 2026 09:05:16 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: SeongJae Park <sj@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        David Hildenbrand <david@redhat.com>, amd-gfx@lists.freedesktop.org,
        linux-mm@kvack.org
Subject: Re: Finding mm patches to review before those are pulled into the
 mainline (was "Re: [PATCH v2] fix AMDGPU failure with periodic signal")
Message-ID: <1c758937-787a-4afa-983d-e5b89578b101@lucifer.local>
References: <f6pged4wdv2qrpwn6uiqeampyi4m64xoey26eudw56k3txu6oi@3uwgwbyfrlwm>
 <20260108062637.82125-1-sj@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108062637.82125-1-sj@kernel.org>
X-ClientProxiedBy: LO2P123CA0037.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600::25)
 To DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ1PR10MB6003:EE_
X-MS-Office365-Filtering-Correlation-Id: 29fab515-ce59-4528-88c4-08de4e9508e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7Igz09wZng0FRC1w3+FhQMJtce/Bm+47nuv3/3OfHTRwCRO9ACHXWFLUKLO5?=
 =?us-ascii?Q?NTWx1w9Gd4VV9EUi98Y5sqy93YGHG5EOaxPNR2LsUjk2wZMgMculmEOgEwBm?=
 =?us-ascii?Q?yuEMYWtb0PYJJmoI+pFqhjxe00fKScRy64oEYchoz610jY4rEcKlV99OJYpm?=
 =?us-ascii?Q?Px6CJF8kZYu1OzEjVpfcNKrojIGvv8n0lYf8ftGht/pePo9CDvk6U/+8hbao?=
 =?us-ascii?Q?4oR/KFsG17BS8XYVOm1WVlKHJ0QmjTPAss4zmu/7kgsacQRubYMIpcOIhYIV?=
 =?us-ascii?Q?+oyajAXvYP8VGsyJSZycyiH4EyBrzNgzcWxoheWukzWtQ1V3Rtm0crHR6yz6?=
 =?us-ascii?Q?sIC8xlGmS8BTAbGN7flIeXbRNXaR2kxZBuccq3l1K7y2y5HHE9jxv2i7S9sx?=
 =?us-ascii?Q?8vmhpKIqtsQs6ncNONOi/wcWCWaI4qEDEUAxqeSelzELV4l4DnrtSPVafnJM?=
 =?us-ascii?Q?fb3IiUtwH81Kh0TAwkd784g3/v9nF06n9pII/OeOSLcB5sgbLuePCMiGhxPI?=
 =?us-ascii?Q?RXX2NZCmghXznJpvu4HQYmW0Z3B3r1Sv+0e9Nu2SoJmz1CMdET5kz3S00hkm?=
 =?us-ascii?Q?RUT25djHvGmMb8OtbTIiEEUBKPJgVPBaKY02CmaYSU8i2U9T3ngLl0CpZp+g?=
 =?us-ascii?Q?Iieaz8iGUWbUX5dVX9p3jbRKiDHFLDAKaCpx4zwjZD4mvxyc6Tg0TluzKfMs?=
 =?us-ascii?Q?fcB9TcD58yVQAHLD/WDGB87RJU2XAqqQ1DcW2p2WTMTASEYMsuFRIkBhlHUv?=
 =?us-ascii?Q?vqHkktAd9SYY3+f06ZbWMKOBEG87bIqF8RglzZV80lB6buw9KYwj7obNfyR0?=
 =?us-ascii?Q?QXrYUZZX/GHASGpepL2xKq41YAG+HqnqHV+UFzFKrNOXi+Ug1uWKldagrifq?=
 =?us-ascii?Q?WCmuQjl63hdT4m0gmWtiIWrZ1Yt+ZUmU2iznkmxpynzS61KHR14oaZNIOnrl?=
 =?us-ascii?Q?V/wfBgyEotPd+DTZwVEo+1I8vwskltDpAdfMNQuaZimOkkgqwvSYoLhG1H5w?=
 =?us-ascii?Q?NmugeVrb2SNYKqyBa9w10vrFTyVapule9SXcESDvQx9RdaaaZE2XUvi6obWm?=
 =?us-ascii?Q?OQbliCk4KhFvsCkgYE/toEUJ/Mrf5+S22Pfu/aKBcNxez39JjIdmIHVFH7/I?=
 =?us-ascii?Q?2dyMivEI51K3D/m/A08GEVDe4wtkQjaDrb8f1A/e/5zBb/qo5nK+exOr9sfC?=
 =?us-ascii?Q?P38tOUEG004Xq9tF9tUaAvuIWAU6tlGmqqKne9NIenC9DQq415D3qpf4B2sU?=
 =?us-ascii?Q?xAlY6zIqig15ZsUWQ9EPHg27RNavrM/WMrnDP1LtKiOApfaMFqPf/Ri0HE+E?=
 =?us-ascii?Q?LuJIwg6PaybWjzNKcO1C9Q2NbvMA07BP12u1Pc7uFRDCf06Am89rIWg6qTOW?=
 =?us-ascii?Q?tsRQhA/c82GPvfd0RL3pEjgRyrURyJEWZg9neyGVpcYw/qlBOf5lpeQvlkdc?=
 =?us-ascii?Q?D6sUlQ5oktGlZTxAMXP0+WMyAgGiXAOU?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wrMjxaa2hKFEAs+lQ165438MlAt8iJ1GGUxfR2tCY7o4gDVvlULwgwFD/iKS?=
 =?us-ascii?Q?boddj43nhmhZl3RGuAAHUwOzRIHk2C6RoN+yzbfLC3ycijGBsODtxPYCkxQ9?=
 =?us-ascii?Q?4S+fqN2bbiK/W/XCA5gJhz9itMr0mZPnQzUn2FC0w+h08fHFEd6n2dAmXAXl?=
 =?us-ascii?Q?WW8tAus79Z8YJZDkshzL7frkv5goDWS/GkFes96pKXaNqAKQnBI3a9dVFcUa?=
 =?us-ascii?Q?z1DGXy3mdtjDqauND4d24zRBdh1ip6L2kaV3FFmV7cIp3kSqsJ+8qCCgiPe3?=
 =?us-ascii?Q?TJ5RO+iu/JRmveQV1ymdAnswQqxzM3fR3jPrX5JMMayTnquBBgXApNBI2J0m?=
 =?us-ascii?Q?AdVrirwHaWgtEv5G4nQH+Aafy13LpKsLSm4KQZiOU1bshBULTTc0kYbz7IYW?=
 =?us-ascii?Q?dCj+nTXxA5fXA0yPX6vy/LXeonTzwg1lMM0ezbgDHYho5XIEJgUpVG1eGTEj?=
 =?us-ascii?Q?GqZX0Ed75uNKyh99O5U4e9SXQFuCoB1P1qd70TfVELmhbxALRlAQg2Gr6KD8?=
 =?us-ascii?Q?p+EHQFTlsRs5FDGlnDVfsUTRNF7cOvgVlyssmFafPi0vY1JltqYhsbPcwkMF?=
 =?us-ascii?Q?jECjQjnG44tSAz4m6RCaAFg4xWp+Qz7csn43SPiSqjVfoMSCGfUznixMaB8F?=
 =?us-ascii?Q?23EpIr8AmXfzQY1KQqPvm0X07eKbq5vRCUIzuN3CG8vMxTzLEAw+gwmFUO2U?=
 =?us-ascii?Q?jaIlFYxB3MlwqSQJNmF5nFEqQMmGLmw5bzTRboQPAKGz4c0/LonmQNqa1OdP?=
 =?us-ascii?Q?hooguXdsaEdpYytRITay4aVLayEzLLEZ8IKs5IJONwP4znu8fpWgevREWCQJ?=
 =?us-ascii?Q?e+3PiH9YJScEb81rlHqM/xia3K9QQFnw1FkHCPUdRV0cjBEabpz+m+KH6OIm?=
 =?us-ascii?Q?1oLkeUNnxTSnpC2N0jMm9FSxo0+5sW5H1cv4uPBHgwLoqPO6bvV2EvPE+gbQ?=
 =?us-ascii?Q?4pfE5k8Vl+Kn8BWKSV+PfLXL22vatIkOhAL8erg5mhHD0wzSx5G0jMuU1hUS?=
 =?us-ascii?Q?3GqOfTsb3j3dU8gSRRDDeZntTUPy2Wb7Trx/efgQenmAhjmfijA6zjdDa61B?=
 =?us-ascii?Q?D7VXrcmun4BF7FibukzXcYZz8ki0BVN19gIQ6cr7hj4aEAkCqNFZydbGCRYm?=
 =?us-ascii?Q?YjZO4CI0wSklszKfUg2qwywZdoCGcruseOw9Hme22Er8uid3LmbITml5alGN?=
 =?us-ascii?Q?2dpRrKKEoS8sM/FKcG8xUCXCSP891vrioNWah/dj5XQefqRFV1EsWpJFJjs3?=
 =?us-ascii?Q?lX8zUcIGoPBWo5hGN2DsmpNqCrtFHoMPHCZKtDWXQHY/ZE+ivc1n3Zl2EfUf?=
 =?us-ascii?Q?NKOomG8AkR3omxNufLRnT2gogltCP6CAytBturZ3mmqSHCafLxwNUj/Hjg4P?=
 =?us-ascii?Q?wE6kWeNi9iqQe9oM8UW7WqXrS669MUBOtzjgFjyyhAUj7GfwHZU7UVdCpOAS?=
 =?us-ascii?Q?2wc65JkiLukzJox1DX8dMGU7JE9S3b/rtg1ayNNJjNdPIya494rQ/zmEwByi?=
 =?us-ascii?Q?yFHNEU21Ih221rZefWXnhiMrcptfUWfKMpUOpQOIEdRhc6srRIAa8f/7sFjM?=
 =?us-ascii?Q?hSVi8+kvIL1UySPYTIXN02CWtmRmDIQouc8ytk9UfK2ihnFSK4RMPcHwvDrv?=
 =?us-ascii?Q?AKkNFsXdSbNT4XGWFXGPpB00P6InF3fcrX8oD4AY3o4EJwmVWqyWUDYvh7z8?=
 =?us-ascii?Q?LHL12EQFn1+zJhq35eKUetyJLu3Wjn/Kx749RMSqm00tscI3VpPC6RSK11lW?=
 =?us-ascii?Q?0AKK/8Whqo1Va14tZI25irZB/tyQtT4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EZFc+j2pr+4nt/HnL/JQk24OEaBisH37OEXxO25vfJZ+0A4E+m6VOMBtbhfKqRx3bUi4QssC6HGSLW62c/WPUFovU1mp0dIfYpGOmqtwecwWWidL/pnH6uiCtMACO646vrXSiipAvZyga561LmH7arVPzp53IW5QbkHTt1kbo2ieUd+GbptHU8CSRl20s1TmQbeZiyjyKq5HN+jhRrmPFH3L3ah2Lt0/G4E/U8joCBW946STZamWqiRUn1XVr2+BQ/OyYpqjgOhfku4HlXz75Th8OlfbZ9NGLPXHpGhIM1pRrxBErCXfHh+W3YR0yFS0lHt2/QRsozittU8FuqNCZ9hecD2J0b1b4AF/nyqJh8oyIixLtdnebA7Yntl4PQ+sM5X6wXtrTHU0eXSAsP62I5AkqwL8haggIJWxbLpnScBYWL1ewgZAq5N6Tzq6nKwzslNmIT61fx7UcQCRVSTin2D67Qwm6CR43i7bt7SbB8VjnXTeQINbgltCAtRHb8pmB5vU1t7LiBzFNSkvcggVxZ8o2oh+ZfMC0cpQnd9yS6/NvHcrRCjNlJCUxylvEQS3hik7NwOa3OKEP+zY4WyNT0xmrqHVvJxenb9vPPdsmtY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29fab515-ce59-4528-88c4-08de4e9508e3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 09:05:14.0311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MPWTcDI8+R+VRINVf6EW0va71TRy+2Fh7aPCPh6nF6WAgF0AJqeLSOpSQVRZHBjlLNREJaw1c0K7q+NR5A+vHwvEzez3XVnNDaF+eRGmD4Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB6003
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-08_01,2026-01-07_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601080060
X-Authority-Analysis: v=2.4 cv=EanFgfmC c=1 sm=1 tr=0 ts=695f734e b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=dUeNrQMZMwbCEp8BcdIA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13654
X-Proofpoint-ORIG-GUID: q1K0xyFiwctl8ewdnGA37x9NhF8dQpgm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA4MDA2MSBTYWx0ZWRfX+h+8JOW8CLVh
 H/TuOANDl/Wvzq2wjwVZZd1BS3fyXSS7M0o7sni1qBZyFdDjc5ncWasez1eGW6SwbR3iGxD2Y4d
 naHuvuhn8N6GkUWVk0CBdS5XRy1bnO7GzhvwuUqPVagXY3f1Jd1HkmMvEmxTsq8rNzRkkJ2ee5I
 cZP+CTngtLCsQ3pKLqnt/w4K7DYCQ8HL4FxtHI2vhynDj8uodlgpQDKYJ3JvY3o7u/M9B+5Mo/w
 4R7ZNvrlXFtvuQgEv19PDIxnmGm69uw/4kbIPuq/dedmByOGxycuQQ0uL5Ee9N/fpDSk7K4qw+9
 j+RmYZI2dlda7Xe/Rj/NcZagsl8qhD8AmYqkeyJOSuTcNrsjcEqCTpRJx9nlQjNxvKY455ezmKr
 i7Jw5dMTDcIZ9BeH3zBSoUoIRD18Uwn1vXuJ8EIT4Y1JYXuQ371gkQ7oNm0qT5ap4/3CIgFkwlA
 2ifbr1aS0gKT/dCCHK4CF+p78kilaazY0x+GVKxQ=
X-Proofpoint-GUID: q1K0xyFiwctl8ewdnGA37x9NhF8dQpgm
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9CCF64000B
X-Stat-Signature: ozgmsa5kimb5h4cnohfqdc9mhytk1ycr
X-HE-Tag: 1767863122-814223
X-HE-Meta: U2FsdGVkX1970iHoINtPW9vFGGXKcFQ3XvSweEc7XtYUS8yBvO1HUig8+hq06rR88pVPu5G2Z6yX7XgEHsKpkkETiFcHEFbVhpNg5jj0bcSr4pnXvzr12sVOjdrBuTcC1OkdeNInZNwXJ6sIGtVUbUX3v9S6FDirh/4ppNPaRJbbnHHXcerr+w6aMDGfqXmuJ2ZOUyI5K5LqIzksbB0f9PPDukXP6umvkQnUz8m9J/Dh2cPmxyKs2CRtczelWQIy4nS4bqjPNpxoK3D8dTb/KbEnER6Mc3TuRqZ7yzECDbqFV2gJoPwoiInSeX53gQ8mMRVf4FTrCJf2Ai+yFSbqJFqqr1Qx5+lF5fChYBcHZmkCQ5X1cDZg4Pb257O2ylDsqADyoYolqU1w3j67H/ue2H/RbiOzJy0B0tA3iq97y7WfpadB3zpVhcHT5rA7eIsxlXIgNlI22+nVhQQqXf7DoAAxmOKEE4T0/uZeslGTdNqzUv5hODlEPUDQ0KAXGprDf3B9tqT7altG27wIRicCZICTU68ZciObvSUBQJ8W4Xy9NRfc4mTwAQCWstGqAR5SXCrKSkIUKUtmYmjtbN+oQbR9CKReTgBgmWeiTf/tyyEvG8/vNZOeNjIh1apIZ+SsfwfJ3QfoYHMq23+0cVFBkWqsjp7bduZ1Wtni0xSDax85sAcUB5IIOzhQCzyHLc20UE2gE3KFTM7Dxr1GhiRxPGPkYhqFV7NLJBhMmKsevPUKd7jlOQJrgoWMnpe0VJHM2jMOBLSrGhsotU7ZrjTbB0QuoW60+ybnwuRTTsDLJYqLPV2cl53kOTHfmRa6Jl9gEy+1/9Ng9Wjx+5Ese6WkMgSHoyUJYATF5SPbDRJf/hqmk6cXLUqaBNSoxaLSe/E50FHrRXPpmGOJbv11YqFwGRdhlHaPJkLPoXicLoHuTw/WZXNbopM41aJWaWQ5gD0MKzEJBv1Q/vadnxndFwj
 hglIPsCs
 CwX1M0xAWi+cT/kaCZMQd87WDouyji9T8Io1ln2bzGMf5MBNjMCKTC5heH3K2wxHs8yKSIkDpNQMOxSQo2wk9GrD1E+P0NUMuJ7tt/9YBOUD04ou4OAgUlbCBj7qp6y3Zf4SH8neLtgm5ZuujpoqF2mlNIM5EYpnxc9ZxSYnzUuHsTCb2mt3Tk6+2XfQzwwWuNmpqdXoDQIMptveIQYqVP0QIzlUFKFL7TLrLC2NyKCaYBPmOhveksvbSEwPfMC3XPtzsHdRmF3uQQSRGNr172CXaCis9bJZxe3UgmiPtyRPWIxOqs/A8Zfy6W2PKT2JTqpXEoZgrVGVunlvI6P6JyAb6YLYa8HDtkZiWsct38s60pjelJpQ3fCf6MSauyj3Tdox5hqIAt8cD97mcaytxivHhzRj/Rk/XYaY0PDtU9cz9xitQ68DBtMZ/rDlJOfmxIXTg9ni+Ie/HNLBP+1c0jh1f+2f1lQFALKeN0kZQghiGhk3vgjMme81z9kaBh+JE82Fh7Lfr3sCllnaLC6Tu8GJDky5Erj+BEcd8wVVwStKccp5rKPWo8QXB5aHJSc4MilgTEdMW8l9R6J3npjIythkfc7MRDtXQGMExe00u1bocOd6OJyan8h2dWA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 10:26:35PM -0800, SeongJae Park wrote:
> On Tue, 6 Jan 2026 21:52:25 +0000 Pedro Falcato <pfalcato@suse.de> wrote:
>
> [...]
> > I understand your point. I don't think anyone wants to see patches falling
> > through the cracks. But we also don't want patches to get applied without
> > any review.
>
> I can also clearly see both Andrew and Lorenzo are trying their best to make
> Linux kernel better with only good faiths.  I always appreciate their such
> efforts.  And both their opinions make sense to me in their ways.

I mean, sorry but what? This makes me think you haven't understood what's
happened here.

This patch would have been merged _without any review whatsoever_ given the
circumstances (no M/R cc'd, the original email not replied to and from 2 months
ago).

I don't understand how we can be both-sides-ing here - treating merging stuff to
mainline without review for the _core_ infrastructure of the kernel as a bug
tracker is simply crazy.

Anything that involves merging stuff to mainline simpy to track it is
insane. This is core infrastructure, we shouldn't be breaking mainline in order
to track stuff.

Yet again the whole thing is set up in such a way that reviewers have to jump on
things, rather than submitters having to - gasp - wait sometimes.

>
> >
> > Perhaps it's time to deploy something like Patchwork to help track
> > outstanding patches?

I mean they're not outstanding, they get merged. So I'm not sure how you'd track
stuff that way?

All of this is predicated on Andrew no longer merging things without
review. Otherwise it's moot.

>
> Nooo...  I'm too dumb and lazy to learn how to use Patchwork...
>
> I believe we always have rooms to improve, though.  One way to resolve concerns
> raised here would be asking Andrew, someone, or some tools pinging relevant
> reviewers of patches that Andrew wants to add to mm tree.  But I think that
> might be too much request for a signle human, especially for mm, which is a
> huge subsystem that many reviewers exist.  And because the reviewers have their
> own tastes, the solution may not fit very well to all the reviewers.  For
> example, someone might dislike directly getting such notification mails in
> their inbox.

I mean no, please - each individual sub-maintainer might have series they're
well aware of not being reviewed yet.

And again, any kind of tracking is really not meaningful if we just merge stuff
anyway.

>
> In the past, I actually considered making and running a tool that scans patch
> mails that not Cc-ing relevant reviewers based on get_maintainers.pl and
> forward those to the missing reviewers.  But I didn't make it because I worried
> polluting someone's inbox.  I should also confess I worried my electricity bill
> :)
>
> As an alternative way, I was wondering what if reviewers consider mm tree as a
> kind of compacted and curated version of the mailing list.  That is, using the
> mm tree as the useful place that we can more easily find patches that we need
> to review asap.  If it turns out there is no time to review immediately, the
> reviewer can always ask Andrew to wait.
>
> Finding such patches from mm tree may be much easier than doing that from the
> mailing list, since the number of patches to look for is much smaller, and
> writing scripts for that would be much easier, since we can use our favorite
> tool, git.  For example, I just wrote below simple script to find such patches
> for DAMON from mm tree:
>
>
> '''
> #!/bin/bash
>
> if [ $# -ne 1 ]
> then
>         echo "Usage: $0 <commits>"
>         exit 1
> fi
>
> commits=$1
>
> review_missed=""
>
> for commit in $(git log --reverse "$commits" --pretty=%H)
> do
>         commit_content=$(git show "$commit")
>         if ! echo "$commit_content" | grep damon --quiet
>         then
>                 continue
>         fi
>         if echo "$commit_content" | grep "Signed-off-by: SeongJae Park" --quiet
>         then
>                 continue
>         fi
>         if ! git show "$commit" | grep "Reviewed-by: SeongJae Park" --quiet
>         then
>                 review_missed+="$commit "
>         fi
> done
>
> for commit in $review_missed
> do
>         desc=$(git log -1 "$commit" --pretty="%h (\"%s\")")
>         echo "review missed for $desc"
> done
> '''
>
> And it indeed found some interesting patches for me:
>
> '''
> $ bash commits_to_review.sh mm-stable..mm-new
> review missed for cb844296e68a ("mm: introduce CONFIG_ARCH_HAS_LAZY_MMU_MODE")
> review missed for 7bc3a776d611 ("mm: add basic tests for lazy_mmu")
> review missed for e8dd7a6b54a8 ("mm/damon: fix typos in comments")
> review missed for 999d5100ccf7 ("memcg: rename mem_cgroup_ino() to mem_cgroup_id()")
> '''
>
> The first two patches are false positives of the script, but the last two
> patches were somewhat I actually needed to take more care.  Thanks to Andrew

I mean thanks for putting something forward :) but we'd really need to avoid
false positives and you're going to need all sorts of parameters for this to be
any way useful.

I mean we have people sending series in all kinds of ways, and if somebody sends
a v3 for a v2 that had tonnes of review we don't want to hear about that.

And for instance a huge series like Nico's I _am well aware of_ and don't need
nagging about.

In my opinion this is something for each individual sub-maintainer to keep track
of, and really submitters need to get used to resending if necessary.

I think the point Andrew was making here was to track _hotfixes_ especially, and
so you'd need to narrow down to those and really only those from at least 1 or 2
weeks ago that were not yet merged.

But we also can't do any of this without clarity on how the trees work.

Right now it's totally unclear how and when and why patches go to different
trees.

So any kind of effort like this is predacated on a bunch of other change
happening first, and I'm really losing any hope that any of that will happen at
this stage.

> adding Link: tag to each patch on mm tree, taking the followup action was also
> super easy and smooth for me.  I like the results more than I expected, and
> decided to keep using the script.
>
> And I now realize this approach would also work for people who didn't list
> their name on MAINTAINERS but still looking for patches to review.
>
> Even though the idea and the script may not work for others, I just wanted to
> share this, only hoping it helps finding another idea, whatever other than the
> Patchwork [1].
>
> [1] No offence but a joke, Pedro ;)  Sorry if it was not funny.
>
>
> Thanks,
> SJ
>
> [...]
>

Thanks for the input overall, but unless we change the default-merge policy all
of this is completely moot.

I imagine this will have the same impact as my saying I am no longer going to be
using/checking mm-new, but I'm pulling back from review quite a bit while things
remain as they are (you may have noticed I have already significantly reduced
it).

The current approach is unworkable and I burned out on review a couple cycles
ago when we had the insane influx (esp to THP).

So while tooling is nice and all, you still need people to do the reviewing.

And while mm is 'jump on it or it gets merged' it's just pushing all the stress
down to the people doing the actual work, no matter what tooling we use.

We need to change that in my opinion, but I'm no longer hopeful that we will any
time soon.

Cheers, Lorenzo

