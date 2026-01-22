Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C52C9D3EE60
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 13:02:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 839AD6B019E; Thu, 22 Jan 2026 08:02:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B6E76B01A0; Thu, 22 Jan 2026 08:02:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 532036B01A1; Thu, 22 Jan 2026 08:02:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E7B56B019E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:02:35 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F0AE81402D5
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:02:34 +0000 (UTC)
X-FDA: 84359613828.25.F30C248
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6D989160013
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:02:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=oq62KpqZ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RMEIkI4s;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769086951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0omcCeG05KRpcGsbKGwuo55GUCBvKXjddLZ8sGvO8sA=;
	b=Gyas/pKtgeB/BBMbaC27ljbOJosuoni42eFwUWQ5MqhHRPydXJkHcHqJksfI+a2wnSzqiK
	KUz6QnE62REjT4ZlPrv41i5IHxc73ucYt3HnPEn3WSeriNMKfiLH8ONdmYBXwu5tXnr2q0
	yDJg072uaoJvjMNXG7asGo70EKYPRqc=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=oq62KpqZ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RMEIkI4s;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769086951; a=rsa-sha256;
	cv=pass;
	b=EoXahu5GuvKgTUbnbgysWsJh2Cw0HRWu3RuoznqSFKyQC93CAsXmNJbgCYaWlrrdYUEh0O
	H12f7JyuAmlz708O2dLNbPBWkJ1Al1gXLqTcSbiFLlj3gB7JA00WjtMUtGMcXdebbk8NAb
	9fwoMcBWwJEc0/xRmB+d69aWPlV0LNg=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LNL0OJ3266582;
	Thu, 22 Jan 2026 13:02:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=0omcCeG05KRpcGsbKGwuo55GUCBvKXjddLZ8sGvO8sA=; b=
	oq62KpqZJw0f9nPd4jlOpB+G7gBipqb2OUxrabBfd8KWf/XQeIDcjXjaZ885ZARR
	TOpE3QP+Tr1w+EHLVC8zdvczJZ/qXBQcB3NLDvwv5xz5KzcJrDxhJzxaMXcyWdVQ
	mJfhzh2Ewdy/IeZsRo6/udtuXe7KJVsSBRxeaeVYWk0Pi8vAoAYMJz9RYkFfaxSi
	w7W+nmvv/KS5xgr53Isapiu0T+7AyXoN+tB47zCKQQ+rxU6ikQa6AiiDwXAhu6GK
	BCgXkes7Rl8mhpZNSSDRU13WYE7KAn0519euJcp+1nS/Dc0gweCkyc+i94+9WsKb
	SnEvXah6VGx+KECoFogvow==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br1b8fp77-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 13:02:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60MCSauv015510;
	Thu, 22 Jan 2026 13:02:17 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013060.outbound.protection.outlook.com [40.107.201.60])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vct7gd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 13:02:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=byjo0qBhHVz0Z4B6l/o+0KoO/ZQEW5LoTq0YSm6w0uQ4uHC46lYm+ux7kErDz00kW42U9niuApoVAHAuRMM4nTmNr2Z3AYgwXWVgfGZdUhd4/Dk87zNU7sueRWc1lsyHqsMNek3lf035z+2WNTVgzsY3mLgYb84LBUX4FetHi0udVs3aPdtAYEDTLxuGTb0FTnKHA2Sjjod3Z/dPpu6S2Yy5tPpn0ajiYFIVHEmGTr9sQgAKTbb08f6Ry4pnCJyA5V4WM+pPXuDvWrV6oFFNs7mamuJmeGIfpESyRO/8DghNq2HcBWFNa2ioAzRyREq504eAfHfVdmjKJW1HM1012A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0omcCeG05KRpcGsbKGwuo55GUCBvKXjddLZ8sGvO8sA=;
 b=wMmfA2Hm40fRB4oU9hEHRuliE7tmmVhkbWITkNGy4ENUL2xnkhAx8V6IZJck30UZnr1e+Rr8/Dx5vCFg3R9WjPIvZoBjmI0IIxEeKtKoWJOVAjLwwVDkiJri9odsMPJWnnAYXoUCNPEbGay+BolftR1fAfIdGPsvdhLmH1hT3uuDe4nHS8vaLBfZmp1Hj4oxgWg9TF7I1DrLi9PsvFG8VoPg3cvWbq01Y+BXbogfsMp8EFTMnhfW2SgdYvCiWrrYJuXfsDG/zg/LUa9ISx7jDkP4K0WhRpxa6VjQRHu4E/56gJTENzr9IPbtT0foQDN3rd0oAMvKn/JnoIR6jQObAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0omcCeG05KRpcGsbKGwuo55GUCBvKXjddLZ8sGvO8sA=;
 b=RMEIkI4smHSrwkBQ92OnEjImZKMFKcEMWysP5GJn+BPbesITS1NDjNyX/93OQPKnWDBYSIpXBo8iPfDdzOgZb7XD5xoaGfGAdSBJFno0sp7enUDfXMkBFmI2zwvt51L4KBBk2KAC4dWcUFcQ3REvXpT3o3AFpJqG9cYUkE6KCLw=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by DS0PR10MB8198.namprd10.prod.outlook.com (2603:10b6:8:1f4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Thu, 22 Jan
 2026 13:02:14 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 22 Jan 2026
 13:02:14 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v3 06/10] mm/vma: clean up __vma_enter/exit_locked()
Date: Thu, 22 Jan 2026 13:01:58 +0000
Message-ID: <f1981963e3c9421b6ffef19f15d87953895cd0b5.1769086312.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0021.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::33) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|DS0PR10MB8198:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a0d77a7-d92c-4346-6c1b-08de59b6767b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RkV/fdWtGZQ38lSrfpL73fRiEVKOHIisE7RX//owUGG4y1amWhf6ZeV3STj9?=
 =?us-ascii?Q?ycbJDTax/PQY9h5TsEIVkpEx9uo6ToLqBLm2hTtFj28ETd/oqh8vOzTXU9HE?=
 =?us-ascii?Q?0q89/e+6noYYjRlV9WJUJOGMsN57GqPzlWHOdmXNExtGu8ip5LfiTOFyPHd0?=
 =?us-ascii?Q?UmvEcvKfDRr8AzGECKPzC6Ot5byYLbjPkBl6OQ+oTrNQkHGL1jNyIeHFWhDf?=
 =?us-ascii?Q?djMk46zFKJhjT1dWBZClZHhEknnl7X+Qx+TOOPMzoguxK7ZIWo9ib1HW78F8?=
 =?us-ascii?Q?1iTuc2XbeRKKw3ltiYS7l73jn6yWCeYvO+HoHuPY/SWgpY4no8OU2y1cLDnm?=
 =?us-ascii?Q?XM8P7xPAq5wcaddJRX70HXHDmwVXaQAyqG36qy0GdmvaXZ0aeKuKZbZrx1EC?=
 =?us-ascii?Q?wl4aVC7sS7KKbMgfHbABwWguMQvY/vX8GP/zep0o0FIn9jgglBYqw37ZnhO+?=
 =?us-ascii?Q?qbLYwt8hzvXLoMbiDcBpOdlIDKldeQRKbACGbI4vVoaNbnSnYx0sxd5k+q4/?=
 =?us-ascii?Q?j1zgy1C63/xZn5KuBCrnJFtdebxDiOfNUpbgCB4I1QGKXI+Gc3RK3lNOBBeh?=
 =?us-ascii?Q?5cdc3qC4/rly9BESJ04a052PhTd2mN9z6GDVAA2YyfqEt4wF8IDoatd5Vup1?=
 =?us-ascii?Q?rOeyJkE+8gxwPivwdZO1+Ab/SZ9WCTLy+kKR9F/gsCQcT5xzjqSM4y8Y8ZGk?=
 =?us-ascii?Q?TAK9ReamNWl4uWJt1lLRsljTTrF9rhv2t6alci+Enya9oK4x4aHHAwkynZ86?=
 =?us-ascii?Q?h3VgOHAp1/o0OeDQE1nfZrLtzv9eqIyHwWe4aTEt+uDVIukKADGXnDLDYvmI?=
 =?us-ascii?Q?R4ljOM142Z9npV/eflPGw2jW36f3MGvo297Tlw1mnmB2+JkxzYGuq2PM1rb9?=
 =?us-ascii?Q?1vCs4xnRvfZBnNwAnRLf/GyH8ZCwxKRIygrEz8J+Bs2shAS1UdKP7ciTxEtF?=
 =?us-ascii?Q?l7tW1HDAcpRX0hkD+9T1iTEnS6UOiMnL1iMfoOivyaUzBFBwinHbhepI1P+8?=
 =?us-ascii?Q?Bs4/pma2IlreTWeuyjyUWmTYhxJIVgb5G23JOmyWlX0BeJZ84NsfEdtQLcNl?=
 =?us-ascii?Q?iyWfAQSVqEXN7M4YKJPu13r2i6yo4nZX6otpuQ01ETkLGPnIg7NbOsjGIzFJ?=
 =?us-ascii?Q?h3LVpcIt8kQCQDonhPTqWjYBa+ktpM3F/oIkTRGiv4yB/F9M/JhQxdSjs5hH?=
 =?us-ascii?Q?Y1ARhgYt32QKjO43gvxg+qPdopI+N/hXMqf9beuvJ5QVAC5vllOytcdltY8O?=
 =?us-ascii?Q?3qgbaFRDqoALLsaP/peNko91BP4S06d1TBZRlRGC+HSfAYwpwL0McqvNm3T3?=
 =?us-ascii?Q?sYSptcrVJ9xiZfH3nxOZk3WSjPv57HUSQa1OYsYgaIO9Bvm86fQR5dxEzXBV?=
 =?us-ascii?Q?qIyvswUbTTm8tzl32paIKbh2t2SxtXxVOmX3/XUO5EJIDLhw9YPH/1Z0DBWS?=
 =?us-ascii?Q?/AOGdYRSu4XFqVeIV9O4VOR+j1vct1iomCgWEoCCCO6JXSDAL9/MJvPtUB2A?=
 =?us-ascii?Q?TD60C0847VeLRhUs+6bNSw9TJW1o8+qA1QLaC8bR0YHLG25OZh421flo4+NV?=
 =?us-ascii?Q?C+KLp14x0gQ+hrGiwVk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?z7dtLJPXIaZbg8QBKIOptRPOatIHgI15YAgnCgGlebrDse+ZwioQ3VTR13CZ?=
 =?us-ascii?Q?nS30d2bxb/Rtd2bJ6qqaYlFOOyNszYY8Nlspw+7DjJU8QB/Mizzng+lNt2a7?=
 =?us-ascii?Q?tOXpHoaG+lO+oV7d6RHZWOgJ9nPLEyxOEc3Kh71PCyXtpgIa6hatw/N9g84x?=
 =?us-ascii?Q?+/6FP+DtPyeqcBInV6JNkzXBxyxnRv00kpEVvCskApkO04h2zweyPjrwkUk2?=
 =?us-ascii?Q?778WQ6g7H7iLVRqbbW4DuBuOSUd4njOYkBfH4srLnC9eDJw8Wn0LEt6xsGir?=
 =?us-ascii?Q?rCmqbSrjYjsEne6olpfgTgHE8uz7zlVZVtPMLB4j2NRGDAyLrjMAVLRoSli5?=
 =?us-ascii?Q?r0x40IlKs9jeVlCdw6QPVzkiEYd+7TaRxfYaJ7ngggg/tZBarJUc6vsNFtfJ?=
 =?us-ascii?Q?VZn4dOuE2ysP9TYL/CU2lAWjFYG6HFd/My3WPMnHkC57KSvCT7MK5Fk5u15k?=
 =?us-ascii?Q?Co0QIUXxTUYBcl7lbeMGyi0QBpbncGrIEMHORkWg4OtQX8syzOpzwLXOnoXJ?=
 =?us-ascii?Q?dgJ8iGSMSk1hlXN+17tizEb8xzsbOpPjZH/xXjCvq9Hz0mWxfNprUqZc1ZBO?=
 =?us-ascii?Q?R5iTG1djD19rXkrPpRbCexkM+sbwD8ntOrsFgOxQQjmmHDMm6lMb2Wlq+YL5?=
 =?us-ascii?Q?hdrUWUQ2iNoV/ZVOa55rkj4cNTOkbkoSVkMZzE+ICSFKM7birCCUiRNTE0xy?=
 =?us-ascii?Q?wy6jNl4ntSe0IeMpd4d7ecbMbC7kvkEeb9e6AZbsZm87xbfzph6i1T3I68RX?=
 =?us-ascii?Q?pbil6reOyWKER+cjqmQ43lx0QbrgxIODdJ2Y6/GOupfkIdxrqluXN8vb2X9k?=
 =?us-ascii?Q?QvadEyPrBSfbzUdxjjUIsfmPM7nd7CxLbvJHzf/agk+WTf/mes2wk46U72Dz?=
 =?us-ascii?Q?F4fAaw3UnT3NIOnAbXQNB9zeYpD3v9yIMm3+sl6glcW4y/C9D77ljZzUSFSB?=
 =?us-ascii?Q?yL/tTxacxe/FGF78bNz7Q0Gh/xSGUOYAwL8yCjMuwi6saml+3tPUwUZ9cvNt?=
 =?us-ascii?Q?zzNB3VGTpMjlmkkE2EobLAOLsbSjLn/eZRZ6220Ph427fNpX3IeWEz7fsxyH?=
 =?us-ascii?Q?e+iDhI8MPkk9pm5yP48xIZl5bxiuLFhgaZuGhiVGuIUXFR9i0I4BJ3575Dxq?=
 =?us-ascii?Q?9U4K5z0TiRdduMlugVVCNBzKaj5nVoCkfusoDSsEMrdBn1zHYtQyc5L70GyS?=
 =?us-ascii?Q?Ews8B28RGwOkXaKhcPX7/KNkXYUgeaHTV8H2fLdnHskcCU5InX1EcmBPO/sF?=
 =?us-ascii?Q?HyI1V77X3PkPb2XW4b74SAYxzDlmd4VgWXDa8u996Khc/1OizESz6RH37uog?=
 =?us-ascii?Q?XRkA527gJJ5N7eLUYxwBjnOhV+uQclrJtXO/92eOQt3/NKD5smjuEe5ZxS/7?=
 =?us-ascii?Q?AXt2eMHcAVp7GsvaqQb3s6n0a2Eea/Wp61aq7Enca3uDJxKPZ/U+vN8U9sxv?=
 =?us-ascii?Q?svvi2aivJ51dUK94ycnJ0VpiDWwQj6v2MGK2bumIYY3unSkHD8jAj2sEVf+2?=
 =?us-ascii?Q?zsh5kX51/XQmZlLuY3NI4LyRByJdyZcwLfCJEj3qS94k2Bcgzomvr8S4fhAv?=
 =?us-ascii?Q?u2QtUQe1EGWDCK7yv1+47HE1n15SND206FHiOvLjdMPoVd6zQP/7UIoPKi5G?=
 =?us-ascii?Q?Pah5EgWbm07fbIAM6vp0dbaiDLqHGRVWvliehuIVkj8MOuTkxBwUB15kVhzS?=
 =?us-ascii?Q?gYa8o5IwFNY6bIMNJKCZYJbCXeUqJuzJ9mKU/JFv+BtaSj+PDVWgWOZPi7ji?=
 =?us-ascii?Q?xO6fjU7x3AS03L2PXkIAApdd1aPxTd4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ISjdyzEmHEF9l4yRM2i6UGAugMryhs2YlrjHPvLU3v49GFUq0c3xoeX7smGqLSLxBkGKgqixFwIVaNFumFGg8U0iVLhnOzRGmsVBg3DnI9hN0mfGR201kwglnOwoUuFsHgCCUmXQJ17MbZq2unsmkUX0FV2tCTMD+WIybEdr3BJC+KkosBMoMBeIa4NxzvHFI1FyiWrXKMve6De7XDyhhlX/nD0vUko0famMyiiRB5LcALoLZEG2nHSTDiMWvhlfuwDFuAzwjKpzryVV0KaHNO97prwSmQsE45Vy5Frd6NGAq1orWHeGuTwPwXW5Y7fCQPv+5vfSj4kBPW7dt6teH0KB9wgjsw6V7THEKGNQY5YH6QUuoJUPLx4COBVFXNLkVNdOrOA83kNVXNajgDNJTin/byLj4AZkiFzwgGw7l0h14fxHRwfz02QEay+bGvPW2SFKK0ugoQ97tmpOJgRizFKD3/qRCVrsdxz1eNdeMrKR41s9NE8+zSkkf4xH+QpAkpPwdQbbUzB+PmrLCbjxJEXq9dzTZpkyF8QG3GelJRfXdQqiLNtXbj/Qd+g2LvYZ/QLZkaASRkM93LjtEy7O2QOu4qNQ9MWTUUylFV9/NDE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a0d77a7-d92c-4346-6c1b-08de59b6767b
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 13:02:14.1007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ynjn0alwasoiKJl6G2ncOwRydvoIhwoOhOtWia/DCkN0mk5o9qiII+x55iiVH9fXo4LKbgO1bdd1ZU8aBWamc23dnTyzbIegMyNvCxdyGG0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8198
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_01,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601220097
X-Authority-Analysis: v=2.4 cv=WbcBqkhX c=1 sm=1 tr=0 ts=69721fda cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=Qfc5p1S1sjZ_rCI9KBYA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIyMDA5NiBTYWx0ZWRfX4HuLlOoG0Bpc
 Sr+7W5d4OMhBxFyc5FN7NRO8emLdNEdTq1gMjCYej7u/24+zLgkT1krWx68KgHukrrvSDTMMw3I
 mTXQTncSclyS960hj81ggV0D3/uoAxn7O15vxL+6IwR/n/Z9+PcrY9DkhPlwy+9QunDks3GVv/L
 CloPUkmt45oGHDB+yeddYX8nF/Q2ok5CgnwsctsMgKEtGN4jepiB+S7KjoghWDOGywQho9BTtp6
 ef4qL8bz8mcyic3v5KVHyc6sw9kYnEjbv5JPxFp9wqo8ry2A0oiZy1lF+vNOJ3A1HRCaWlrn1Ez
 y3tFMrCcKMdBN/fmyzW6kR6bdswiQ0abVb8WlrNSwXIqeR5EImu7nCRcC/MBEpqysLt/D7rHOWf
 H4ra/CoXSJKFjwpWGbmiAigJs2eN7I/nwXTWHnFerimgWNmrrXit8X9eKMwpKkM81RQ1t1Nd/f8
 82cmCLwRlEE4/NVlCfA==
X-Proofpoint-ORIG-GUID: GBhTocysMjmLMakwYqRZQvWz40n60i_6
X-Proofpoint-GUID: GBhTocysMjmLMakwYqRZQvWz40n60i_6
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6D989160013
X-Stat-Signature: sntzb9jjxhjckax6ywwqwjbrf7bzuiqg
X-Rspam-User: 
X-HE-Tag: 1769086951-568870
X-HE-Meta: U2FsdGVkX19TpODjg2GmD8neES0Vxta5XfzQxo8xgGy7OKcLpg1OK+8N4+KsBxhJ8yxI07o+tIOWoTM+t8KcY38F2CPEFAliY9HNCtiUu51KJcorpkSwOlL6Gk68BvOabV1KU/v7t1KWPH3mFaDLIX+Z4w2DOTwqt+VjhU93uM7jqtcNwoCMvbqxQ3KCd0UbhHt44AemDrLMwp/pYK4sSZ61CmXkgYSLRvLeRUFzzk5vmtJvEQHU/GXpamxtfGa2Tj7pOsMlFs5+zskaarNk5maBLRj1S7R5lkzpc/eDl/RbbLSPk9g6nM4Zp/S0JxQ80+equtx6aVZaWGNpQlg7QH/rgwPlcNn6Mmc8jHUvhXTcAGoruYPWVwpx8UtdikAXOYNiOVjxCu8P/pSyz3q/0b81L1wFc8zgS0q9a2aEpnLj/Y9fv66BigfFCfzmex8FmD9dWJCdSS5MRsAPUDqf+p3ZvZpu9n9GdcvgjjTDEBZLmahMlL4NZa58Stes2IkDmiEhLtvLGm4FtqNHFxSwd9vdx1KSoRRrdQAE2BeGfRtN3IlQbCSUrk83LeuWz423tcmsS408E5n/wA1aUL6tNke2mlS+BibEoETWyqDPhbLJVafB3XvEAVOAvGqn3JNtU9rrLflsqiLBQaSnZlic1fNbrHfWZ6tLBLrQRnKtkw9/XFOE5ymsw3AfnDMMSTeJz2vJkDWIzx8RIYkTWyjJ1YJoxPMTUH0GVwDo4R1Ms6CFdrR9fWkdGk/5h2QhrHQSvtPY199O6eWc3vWBkRRRBr4hFUlMBSiFufhTQudgsarWcvlo722sIaexRHUu2L3PctHiCfNrrCKSoAJ9d8KmPUSBBEOVTGHwePwFjZY6JAwXOmknybI0tANZCp15hsoQCVpjEc8ajX/2OqZRq3BlQzCQAzfibc/nZ/Whx8Bf6lo9OLo72A4m+Ou6rTfBfi6p6Bsek6Bm3dGD8vevFbC
 nCwdTEGp
 WSWndgVFewlz5hhoe9GAoepwt1ImgjOGjfJGAGDH6feHB4xacUwSamZ8vSPppYKoUIAES13iQRRm4ATxfjlO/wfM3GVghBrJn+Ea2DZesGACgSc/+rPgojnHwfzBJP4v4e3opcqPATuUR01vy4Ss09yInhVEIZKyN0yNFLbpcX1VbK6LzTkpPkLyP0BizVNzQ2rRMYi8tlnduAMYcz6Lpp7eQESmlleiMk6l286ptXUw/yxWSDuCxrwgFOglgELeYtWxB1nUfFNW/M7FTaYgjlCXkw2pLr03HmYSkQiX821hL14maskkQS1Vv2wY83OAARRRKLfUjhVmZfP2gRZZvkgMH8cjS4DGiUEzROFeFxvBHoVztkyuvF2xvUuapPY44hKhkVDoMZ9CLr7OlfNHA2/bwjffKKxLDxjPKdzhw7chO3Zreegcku7KaxxUG29ZRwv9VgWwpFU2ccBOEvjUCTvHZR25IZ8ABn32ChauvVEzqx//GJT3hVSigPqw1biT05yKEUnQSHWKanQJ5fPRPUogGw6dCvYhuzVAFVL1sqHUa2H/DlhxqVhQiySTRntp3oXSBSxqxhFviQ9tjcMkzm3KaK8XsIalLjrTthJxXIpi6YAWwHP7BZdfSgHadm1eMPJp8rJYmqQHJrvxXgLdR0IqbwP+J/H9gyLjeg9zOMUK1VvkEdypVoLbsZIM6kzMFm0j1ylOH5EjwDCqDYddK0lvQbhMiwZLVAJUh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These functions are very confusing indeed. 'Entering' a lock could be
interpreted as acquiring it, but this is not what these functions are
interacting with.

Equally they don't indicate at all what kind of lock we are 'entering' or
'exiting'. Finally they are misleading as we invoke these functions when we
already hold a write lock to detach a VMA.

These functions are explicitly simply 'entering' and 'exiting' a state in
which we hold the EXCLUSIVE lock in order that we can either mark the VMA
as being write-locked, or mark the VMA detached.

Rename the functions accordingly, and also update
__vma_exit_exclusive_locked() to return detached state with a __must_check
directive, as it is simply clumsy to pass an output pointer here to
detached state and inconsistent vs. __vma_enter_exclusive_locked().

Finally, remove the unnecessary 'inline' directives.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/mmap_lock.h |  4 +--
 mm/mmap_lock.c            | 60 +++++++++++++++++++++++++--------------
 2 files changed, 41 insertions(+), 23 deletions(-)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index da63b1be6ec0..873bc5f3c97c 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -209,8 +209,8 @@ static inline void vma_refcount_put(struct vm_area_struct *vma)
 	__vma_lockdep_release_read(vma);
 	detached = __vma_refcount_put(vma, &refcnt);
 	/*
-	 * __vma_enter_locked() may be sleeping waiting for readers to drop
-	 * their reference count, so wake it up if we were the last reader
+	 * __vma_enter_exclusive_locked() may be sleeping waiting for readers to
+	 * drop their reference count, so wake it up if we were the last reader
 	 * blocking it from being acquired.
 	 */
 	if (!detached && are_readers_excluded(refcnt))
diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index 7a0361cff6db..f73221174a8b 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -46,19 +46,43 @@ EXPORT_SYMBOL(__mmap_lock_do_trace_released);
 #ifdef CONFIG_MMU
 #ifdef CONFIG_PER_VMA_LOCK
 
-static inline void __vma_exit_locked(struct vm_area_struct *vma, bool *detached)
+/*
+ * Now that all readers have been evicted, mark the VMA as being out of the
+ * 'exclude readers' state.
+ *
+ * Returns true if the VMA is now detached, otherwise false.
+ */
+static bool __must_check __vma_exit_exclusive_locked(struct vm_area_struct *vma)
 {
-	*detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
-					  &vma->vm_refcnt);
+	bool detached;
+
+	detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
+					 &vma->vm_refcnt);
 	__vma_lockdep_release_exclusive(vma);
+	return detached;
 }
 
 /*
- * __vma_enter_locked() returns 0 immediately if the vma is not
- * attached, otherwise it waits for any current readers to finish and
- * returns 1.  Returns -EINTR if a signal is received while waiting.
+ * Mark the VMA as being in a state of excluding readers, check to see if any
+ * VMA read locks are indeed held, and if so wait for them to be released.
+ *
+ * Note that this function pairs with vma_refcount_put() which will wake up this
+ * thread when it detects that the last reader has released its lock.
+ *
+ * The state parameter ought to be set to TASK_UNINTERRUPTIBLE in cases where we
+ * wish the thread to sleep uninterruptibly or TASK_KILLABLE if a fatal signal
+ * is permitted to kill it.
+ *
+ * The function will return 0 immediately if the VMA is detached, and 1 once the
+ * VMA has evicted all readers, leaving the VMA exclusively locked.
+ *
+ * If the function returns 1, the caller is required to invoke
+ * __vma_exit_exclusive_locked() once the exclusive state is no longer required.
+ *
+ * If state is set to something other than TASK_UNINTERRUPTIBLE, the function
+ * may also return -EINTR to indicate a fatal signal was received while waiting.
  */
-static inline int __vma_enter_locked(struct vm_area_struct *vma,
+static int __vma_enter_exclusive_locked(struct vm_area_struct *vma,
 		bool detaching, int state)
 {
 	int err;
@@ -85,13 +109,10 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
 		   refcount_read(&vma->vm_refcnt) == tgt_refcnt,
 		   state);
 	if (err) {
-		bool detached;
-
-		__vma_exit_locked(vma, &detached);
-		if (detached) {
+		if (__vma_exit_exclusive_locked(vma)) {
 			/*
 			 * The wait failed, but the last reader went away
-			 * as well.  Tell the caller the VMA is detached.
+			 * as well. Tell the caller the VMA is detached.
 			 */
 			WARN_ON_ONCE(!detaching);
 			err = 0;
@@ -108,7 +129,7 @@ int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
 {
 	int locked;
 
-	locked = __vma_enter_locked(vma, false, state);
+	locked = __vma_enter_exclusive_locked(vma, false, state);
 	if (locked < 0)
 		return locked;
 
@@ -120,12 +141,9 @@ int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
 	 */
 	WRITE_ONCE(vma->vm_lock_seq, mm_lock_seq);
 
-	if (locked) {
-		bool detached;
-
-		__vma_exit_locked(vma, &detached);
-		WARN_ON_ONCE(detached); /* vma should remain attached */
-	}
+	/* vma should remain attached. */
+	if (locked)
+		WARN_ON_ONCE(__vma_exit_exclusive_locked(vma));
 
 	return 0;
 }
@@ -145,12 +163,12 @@ void vma_mark_detached(struct vm_area_struct *vma)
 	detached = __vma_refcount_put(vma, NULL);
 	if (unlikely(!detached)) {
 		/* Wait until vma is detached with no readers. */
-		if (__vma_enter_locked(vma, true, TASK_UNINTERRUPTIBLE)) {
+		if (__vma_enter_exclusive_locked(vma, true, TASK_UNINTERRUPTIBLE)) {
 			/*
 			 * Once this is complete, no readers can increment the
 			 * reference count, and the VMA is marked detached.
 			 */
-			__vma_exit_locked(vma, &detached);
+			detached = __vma_exit_exclusive_locked(vma);
 			WARN_ON_ONCE(!detached);
 		}
 	}
-- 
2.52.0


