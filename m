Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7775CA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 07:33:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 732638E000D; Sat, 16 Aug 2025 03:33:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70A318E000B; Sat, 16 Aug 2025 03:33:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D1C88E000D; Sat, 16 Aug 2025 03:33:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4AF868E000B
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 03:33:08 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ECEDE58A7E
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 07:33:07 +0000 (UTC)
X-FDA: 83781804414.04.FC0A22A
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 857FBA0008
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 07:33:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VsPT1LIV;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Kj6OTDGs;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755329584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pyppO8HSxg2d9xtAgiBgS8X39BBC0+aNfNthiKusoUM=;
	b=gSA2KLSEPAjvnnyTPYg5/5Tx8JBEwMr62EDg2N3Aa9jMrwaBZxCmpgydaIe0HCFdhnOPmA
	P4T+/XBA/5JU6LDVcVCJOsmxe6SpQ+U9yLusT0ZclPfZdXvv1tRltMiq3A5E2wNI4xROTn
	gGNI4dr/VjS2EwgSLlYnIJZ6AJ2VWgg=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VsPT1LIV;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Kj6OTDGs;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755329584; a=rsa-sha256;
	cv=pass;
	b=6mvnRgbtDZ0RI2cO6QPO9gXkwYk9d83zjjBOZipSGYO98TlwZf6wjLSacZX9/A+p2qekC0
	4WIleb9f+lM/puv4iJYhVSjlATcyMl5CHj+aGIibfSTLwQ45MijkvBBxytzLacOW+LjAbt
	n30gRKvQhqsX0voqORshqGojyw3rp6U=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57G3g1Bl016230;
	Sat, 16 Aug 2025 07:33:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=pyppO8HSxg2d9xtAgi
	BgS8X39BBC0+aNfNthiKusoUM=; b=VsPT1LIVvLyycPZb0UCdXvFwCR7d4oX5d0
	4BSc7vmCFqjm0zwzfE3PUv2SLcp4rtXLYoWL5XBo8BcMIbymFL7/sKcpCFi32mMn
	el4O2XJYBqtcTtJ+YTWm2tWc9C9HD8hGgcmdxQguNWl594g9ZAMlhKO9rGX7Huvu
	XIL7Lf7q9B5VSJp6T4AOZO4I0/w660noGjSYimQTbxhCaTCjCd2iOicZvgc0LirN
	KXX7UzB3Y+gIV5Q7p3mS0vNW9V/Ji+9hMsiqfenDBK+U84OVmHYgfAaBUlSlpBuB
	rPiJ7wNMevHoyrQel4PQa4zE5P50TvaDb2PNVUL9SHaEkaJlmm2w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48jhkur62r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 16 Aug 2025 07:33:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57G5C7G5011686;
	Sat, 16 Aug 2025 07:33:00 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011036.outbound.protection.outlook.com [40.93.194.36])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48jge77435-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 16 Aug 2025 07:33:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HlZMoYaKxtwEAS2Z4A5DszCgOUxwL4tiH/PaJoX4seDGn1zjx2yItFAyZI0k87mJnsahXHrAbJKKUdH4o2CGDSsE46XPO5qezziG9OxLGTmJ3v95UzD5+PRdhMdizKlPG+11hdcsCec1bB9/QXDTkMvjaNp+w5IVIV1DFPKOXx7boLqdj1wY7+hlhEFexPFSGozgNshErsHVe7k20HuPyDhmFcvTjk1wq5mbDW3uRsxN1ebr7sEAse+mjYNJgN3wYtYuTxnCkUz8I7Zeo1JJvfRCrvmNt1LzcBnuVmyukaG13ydSywEjoVt0KgkrVvt+FLwyWVu+dMjsoUe54HA91g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pyppO8HSxg2d9xtAgiBgS8X39BBC0+aNfNthiKusoUM=;
 b=cajeogDwtV0KSS899W2cGN9KjArf46ygCgMwBAbFMGlcQZsNo3CrE4ovr5Ek1FJg9nBTQA2Dccq5dQzHIfFTkxEESYBM7cYWdz9ejxd308sDntybv7bvSu6wNfK9C1+ePbyDy4cOl1AlKA22t+KzFYL5TGbGrshmF8gnwfQlcirk8wCbqdP4GH1Y8CzmVVfF2eFe6hakPOcOit629fErAb6xGFfQecmxu7Mw65ydWYgp6BxmFI596vRk84lSFyOn/5LGrKR8G/57HZJ3Zd4cmHNQVTw0R4YPF6SdKjn5ycvm39CyOxQvwNObln/2thrNoFDrbo7xbiNwqPxe7aabTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pyppO8HSxg2d9xtAgiBgS8X39BBC0+aNfNthiKusoUM=;
 b=Kj6OTDGsKHhbFTQZ1qjcbd13TPE80pXPYWooqJAn1MgY3yJaV0fIiNvBOItWrZ+WyAgrpsVT9CdjI7S7Yi9PnkuAsQhr38YSH3R4uegcO0w39BjkbIozAn9rMqvd4chRmS/kw3A0WMAxLiojdwObjAO0ZqZT+OaBmAsRV8o5jEg=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ0PR10MB4814.namprd10.prod.outlook.com (2603:10b6:a03:2d5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.17; Sat, 16 Aug
 2025 07:32:57 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.014; Sat, 16 Aug 2025
 07:32:57 +0000
Date: Sat, 16 Aug 2025 08:32:51 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: syzbot <syzbot+4e221abf50259362f4f4@syzkaller.appspotmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, jannh@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, pfalcato@suse.de,
        syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Subject: Re: [syzbot] [mm?] KASAN: slab-use-after-free Read in mremap
Message-ID: <402e154c-9aad-4644-ac72-fdb94f0aa66f@lucifer.local>
References: <689ff5f6.050a0220.e29e5.0030.GAE@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <689ff5f6.050a0220.e29e5.0030.GAE@google.com>
X-ClientProxiedBy: MM0P280CA0024.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:a::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ0PR10MB4814:EE_
X-MS-Office365-Filtering-Correlation-Id: 35c5c48c-a26d-4681-04e2-08dddc971e97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?a5cpT3NXtZUyg1DiEZRzDbPSjCLnU1tZQ8TL3Yneodj0n4vULS9eauuedl4h?=
 =?us-ascii?Q?Jh7TcyUJr/nK0rO4YAchV7gKPmjlb6UDh5qnhHXI3fQO+HyOcQjvYTQ1Phzj?=
 =?us-ascii?Q?6xXHgxtYe/bWLt9xeai+yl/IJ1hI2i5X1qz4IjRVBByCGmKmHt132e9ORChD?=
 =?us-ascii?Q?Zel/zrk+vQfjjOFE4LznBnmuo1Tc7c/EsXYcMYBjt2jDbkhFOBeioBk3cgoX?=
 =?us-ascii?Q?R36SM8xAHkywtAkXc5lu7aHlHJqYhemY1Rpb/M0krDi60S395yh+EjZJ0w+a?=
 =?us-ascii?Q?c+BXIg/bWMw8lamIfbUtZ6YUcY/BZcWTxNOlO5qWaIFRImeVVblZkBT8tuLM?=
 =?us-ascii?Q?rCgMSU6PmfLJhqKx1llH1eEc1b/5c3fV+IK77HaJnZZsYCooNFE2tq1tqdLJ?=
 =?us-ascii?Q?Ezoj8y4Hyawf22VKOuZCD6y788NNlnZ1LY2QB+PdY8ZXYAQnGTyLLl/F8Zg9?=
 =?us-ascii?Q?J6PlYFrSY8u1K5eorkCsQx8cYL67ofuf7WV5lfh10HU/iGir1i/ic8N10YmO?=
 =?us-ascii?Q?faCvk5l/iBDa+iMzo+icFZPalS2mj93s/EsVmZufrmarQWsXfCL4UkFkab6n?=
 =?us-ascii?Q?MpnJZgHuSSt3TM3IWkxOUajgq5hN1hfL3M0+MbGqLBdRIH59Ixsx3ehYgqhJ?=
 =?us-ascii?Q?bgILE/kdpdp/s0QHOLQGK7mqAvLwMJxZzUvLDThRhSLo+4MZpzSAa5iXUKB2?=
 =?us-ascii?Q?jKnbNremPn+HjeTPrQqmWolUyt6J4jkgEvpMzN6w/0tdMpMi3+GzZW7TL1tW?=
 =?us-ascii?Q?lZfqkDNLUbwn6xu2XP64pwPAvMSbwF2WBSOyzMMaGwajBgSRhK14Bw/+crsq?=
 =?us-ascii?Q?A9G9QwGX7laSfU4A8hOrJEefVV9ZhOvKcPj0hJf+mVhxzQpQcoVpmjqHDZHr?=
 =?us-ascii?Q?iCxCmJdhotuHJ+1vCZBQJ1Dl90WQ5nw5+0gy+n0qPaivJlZ2ziKCaCpxfgGt?=
 =?us-ascii?Q?fTBgrYMPJJgEOpmdAsRyhkJE53EvQ1YMQ0TDmLEzXTAvL1Ff96TzF+W83IjF?=
 =?us-ascii?Q?04Fps2Nget3WQRqc1wHvuiyEIS5szOw5dzCwxt6BjZuJkFVpNMVAlMuyFb+u?=
 =?us-ascii?Q?xVpt4tfMbE7dcKRVM04BKS/zh1cqtU5cIcFsJcHctvX8O/TlaELijy/BAkk6?=
 =?us-ascii?Q?45dFepLFyMFCJthuTi8lP6c5NwDJTUrQRwmcADstRLUKgZLMTyO8s2h0uBPT?=
 =?us-ascii?Q?lP4Esy/2Om/ZXSqyMq1X4HB/W+QhoEjPFHK2BIwcdH5TTOAyoFNdWjAwnWZF?=
 =?us-ascii?Q?t2AiccI17L00ln+80quPqFYUffC2tIbwG2ywSZwZ0cgotK6qX+psXShXQLdH?=
 =?us-ascii?Q?Hy4XglIVMVV6Hc0+qUZYGWUH2jJh6mTY96nn/Jbr4TPY8aGW9SCQrfDlbPO8?=
 =?us-ascii?Q?xGOOvQhxKSNZLwn+ozi7ODOPbOOF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vaBd8f4mdJiMMLDxvnIlMw1mhK/rBVLbiDlg2qQigxoIIKtZKymJEqbpJJnh?=
 =?us-ascii?Q?vdBkjt+j9vUp5clQ+yPIQ/lCF+B3/0A/nl0Xbc2KvPKgMyett72YmurfiEW+?=
 =?us-ascii?Q?5aNx1gFjM8XG+BowVlSXegTjcxfja1qC2xzW9af3js33TnwSOR3g6cU2ljO5?=
 =?us-ascii?Q?c1O/ILkOLfxHFv/uG0dI1gnNDxyQHIUN/yU7oBncUOHu+8GepzTGCDN023kr?=
 =?us-ascii?Q?vqmEWjZfwuBcTNM08SfvPplOscWbyku7G5WODjtT1twQT65DfV1MwyO2AcTe?=
 =?us-ascii?Q?WKrAkd16APHfiBPUzNTej74N5erCPpcGCTTbcY0Esv0X75gIinb5pa7XfSFH?=
 =?us-ascii?Q?Z4et5stJionc8YG90V9unWkz2nDXKu9GzeKU2uOjEGxTuHs94PilAtRflKpC?=
 =?us-ascii?Q?9ezCb+6wFd8bSUamWGcdLi8YrIdUQusKNVYXrIc8QszY6XU6ihTWUM7dvxf8?=
 =?us-ascii?Q?RxaM9xM0hBZKgEzYKXxF+ts0OxtIXLUdJy8cp0Ea4LPaKCQqMuJJHJtWjfFO?=
 =?us-ascii?Q?HrdddSciLYZiEwgjflubjViEad2cO7HCPyPs05D6NBIwaCYBosRfnBjMsxS/?=
 =?us-ascii?Q?gwEZaVa5HxZNhAFJX0bekLTIWE2sURNnB//FKfVOSQP5HgAqohMeRFqnCZgs?=
 =?us-ascii?Q?Tl/JoTvbDY+QBkjoM+Kbn7tbrnwPiKr1bSQuU6if0ykdM3TkG/+xOmDXLDQk?=
 =?us-ascii?Q?S9qzEPHR3W00gS74RPwsrxxGelnNrlko3U9BcJPhvQtFm4BJQPIJeyT0tGER?=
 =?us-ascii?Q?0D+kHgT+4w0ckPoPNHj6a78e+SKEcuP9GHH4AzhysUYe6x8kJyIBS25hLW5y?=
 =?us-ascii?Q?30qFDo3xDES1hqoyURSL0FB0bnYBVjZF+APyosqzrYcdy3AWNqEc8RTGfgO2?=
 =?us-ascii?Q?nDXjGcbgfleTG7HnAVO7/uzjGNzP1wPM+56pgMGFZtzwZ3hBfZhjSeuTNo0z?=
 =?us-ascii?Q?CM3AfuuZfhvUpRQgx9ZlbniOvz6hDaVgZWgGL2daYfNiQH7vLOgFrzgN5Ebt?=
 =?us-ascii?Q?btvptfrrYDa+YR3xQaMal3Etfb9PjneukKeGVjTIv//NT3Cbq6b19lBXGlfv?=
 =?us-ascii?Q?amAaVx3i+Qk3yXpskCYulhlcttTdt8XgFiKS3M/i55/qEH/8IdV/+dBKGyPE?=
 =?us-ascii?Q?WzBXiUdpnt5U9FDJWtFtwOxL9m+vD174biEUc21pWHSx/LUE+KZiwFZPT//p?=
 =?us-ascii?Q?f6xo3IfQf3zgIOjCbLYZagou+0EkXKSYKXEIMhKPzZvSMdTVlQFuM3dxRFof?=
 =?us-ascii?Q?7CPygWgvVuSPjVeqIBJ3IoMbaacTebozBgIvor8fyX0jpBinz8N+R1Wr/mlj?=
 =?us-ascii?Q?jLg1HLEBNuQOr1jEIMUAaJqRNx3svaTwq+s9k17WY2O0Amu+pnjUn96M/wAj?=
 =?us-ascii?Q?kq+GH3AgXD9wHlcyQWvzn2kKa1n7lBEhwuLW7EyRiwInFsYsaZ9SYRIypbok?=
 =?us-ascii?Q?ZhOde5OPx7hb92HyogeymSoVF4gRcwqmrDbf1VzasgU3WijVSh5GOTaC+5QB?=
 =?us-ascii?Q?Q4XHlwJyoOFPsrZadx9LEvR4tYdAS2XupLQM5V/B2FA4n0gZeBnPe1o/5w7H?=
 =?us-ascii?Q?rssa4kA6UsRAIgAc1N983joJwebJPKDrzTHzFfEo3WX4c2ldIGpYyxKczDST?=
 =?us-ascii?Q?Fg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	L4bcqZZjLnRaPl+O7gis6OmF01jOseBHKHnK3YwfwlVQNp5QG3TPRr0sVcerlt4YmQ65V0pFTP/+uzBQW0e+nNLzdFFfG0TGm2vqZU9C/BW7D3L8opQMlT1l+a3PjwlJ5Gc3/D5gMuACWFexttAxSVm8MpBr87fQVKGs8c3/YdMSzMBL5js+Pg9seisPVIQHZ44wr3lKPoeXsiAuPj++0dn37RwRmD7iZNayzxsITNdJgrT7rU7LqKB1F0QLfFSwLSGNpDhUUR2vUhNaw8pE9hPqUmoh8WKuX9n9cnfW1LYT+RC1zkMEaU8n9YVctdZ7iq3QMYqzXt/SJubDcYqZyml9tLqGFLbBowxZuHhbyixgN/50GsA6hXIbVk9UMqOSu7QniEBFoZ7j0NNwQiYvc/BekRfR2hFE/jQSYcksTnRSbEeQWr68BKFOSgAIYyRrn6tuJHk1hWRypsOvd2FGy2yk0b1f6LwOP5W+CnXTn7J0IhivWxKTLkVbIWwplfI41hMVDi2RlcCugulQQVasU8hNvbkRdJG5TALNoihwiyr8xKJzZMM7rfuxM9kcQmDamTJzmUqFFueOKRTwNqNFm7bL9RWpUHxvReBvDqrX9AQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35c5c48c-a26d-4681-04e2-08dddc971e97
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2025 07:32:56.9614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ocCK6PBm+UtVkDuUKX0R9uOwCsal/KqW8sjVJ4Iw3uyHnEc0UbQqU+nhr+dvZnWuIOPJQ276xClv+PqPkoFtT6RdP7IHR07NCIAWuUyfX/k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4814
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-16_03,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508160074
X-Proofpoint-GUID: yFILYYlOLgOzzDKX6DWgMEWzuw7c3Z7I
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE2MDA3NSBTYWx0ZWRfXxf7XtCjPy0W3
 4eLti8QSif7KpS1muVizFjxXBB2pMPGjpU8m1G95AKFKySEdwehG2LERrYBPdsLV5Fdunggm7TC
 x2BgZ5iA2K+UtNae3ar3ZGOr8iVFDjcV6J+jHo/ZCT+wYmkx/PTFSMzmASSQEQ+VWhTmcEseBOd
 bBAnt7NWkxW0WifriGSQkx289r47VBFH4fFZJleMrpjDwxP7lp+pzG5CuLJ2CCOuNCNjNqKDhnp
 te2fsWdUx/USIFnBA6+zd7SfoS7smEFT9RGDwZI/kNc1QdNi9WgpfFP1hhRUafbfQcCrgPWiOaM
 6Lqo1ZrBgHHahtkDN1KG3z3Ef9n9OPlY7qMf9v4Qz5l5utJGlOXcprJl8Bz56qTXQ2t+M1/wXyO
 rfxrLJcdp5trTEKZFNPcnfDOWQ0OXGxQSy8Ln9HsRt+UR59/AIyz4C70UDpYbnf17S5dEtjp
X-Proofpoint-ORIG-GUID: yFILYYlOLgOzzDKX6DWgMEWzuw7c3Z7I
X-Authority-Analysis: v=2.4 cv=HKzDFptv c=1 sm=1 tr=0 ts=68a0342d b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=edf1wS77AAAA:8 a=3g80flMcAAAA:8
 a=oHvirCaBAAAA:8 a=yPCof4ZbAAAA:8 a=hSkVLCK3AAAA:8 a=4RBUngkUAAAA:8
 a=WuZ5YgenxvoZpPQchJ0A:9 a=BhMdqm2Wqc4Q2JL7t0yJfBCtM/Y=:19 a=CjuIK1q_8ugA:10
 a=slFVYn995OdndYK6izCD:22 a=DcSpbTIhAlouE1Uv7lRv:22 a=3urWGuTZa-U-TZ_dHwj2:22
 a=cQPPKAXgyycSBL8etih5:22 a=_sbA2Q-Kp09kWB8D3iXc:22 cc=ntf awl=host:12070
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 857FBA0008
X-Stat-Signature: dntumd6a44is6h1shojistmh7yt8snkk
X-Rspam-User: 
X-HE-Tag: 1755329584-296004
X-HE-Meta: U2FsdGVkX1/enIJ5YVxXfge1p3e7TWkX9gSdqLpWB+uf1YITYkJbSfPwDPXi33BoOm95Fxp0sel5mp8ErTXbtSTDw7XnFakHeGW7oICntxVLewq3AKMcBKY8ScP1yll1cWSe2WKHF8pimWQzsXntHuBwghiVo3AZLXpTtbpHgSgkFu4iFeP2BVKPksgp+04M0cwrwaT7aPDERYohcVv85rHvGrwgC7omlrTgEXgGnXFEkD+yfS6GC8rHKVIKJZVJzYZrGnKy6MHu1wNUfzp4jDDNVdrEvTp4PQ/tmESlK2qAKlKQSpR0f9sqWvpTDOuQp+E1E+IPTX+5PBbFNEUgG0wfdfsW7AJjukoBMikiJjM4kO8ZJjzT+JlzTMOPv1asuiVw/VGEBnDbL+ObnkWBmXL4yxMjsAAeHO4zC8ydiDlzp1lpd8DTRNtfEMux7m9VrXzMtw0Vzmt4z7ni+Kzcx4m082X5g2JFKi2ga4UraRW2jJWTuub0Cb8/vG8n+i2pMxe+W+NGvc/edWolOKxK97Z94Vf5yNu06QE778JBHcu3VlHZ1ZiAvjEqQ0XXgQPiVttxpJXFncg282wU4SI5FxDyba1Sqg81NgGF4mLHpEoGu0R2rIj4S55snMMcn4bdrcjL1hBrMFAuaODrnUyLdY7hU34SGyzhkcnvDLXPI7Ju6XrAtj8DW7yQ9Rg9uPgDnvfttCgMHB3ifmGZ5OvunshYo0jJLyCANR3+xGJAtV7Fo/CyR7v9NV72w1NXsdzn1Thcq5ILYW+JctsUQu5eWS99/r8sfBSONvyYZMr1/auRJlVCKElSrNRehe3VkPCTeLWuKSO/s8B90kWV9JEfmjWQRGXrf2Kmyf++B2zgcXotn8ghV9gwVgsV+8RNgGx8Kuc0b0UWcfPRMSbocGjs8v+LhpEydJlXg2iSFpvyccMkw1/m43luHQBm9eF3/nqR8zuB1qw9bP7bwimXRg0
 kWfhjRMy
 dJB3Lij8A/5v2MJIaLTG9E8mXjx8B2maMXCoFhk0h6k0/TgSaqTcuOIpYU6OEjAyvumieWFpBkXm6CSDvUIfHIbzESeys23zdVnRnaFChvB5oQsPfyDEwQj8PDa0TeYFTCW9KKECKYm5RA5TxyaAO3d3LSmnSDHmRpVJ1+fPOf9ghGS7TCx7ldgSQxdgNP94Q8DnpT7MmiTd4LsvWQ9Cm5nBUYh0jamUJNR6LBCVdXbYhilQ9GOBPlVdratDYZ5M2gP90sDNB22EPyQA6Vf5XrfQPHJMQ3H76ZUKsfwsuy1390WTvD50JLZ1qaKBoLX7CTVDEDPfbIEBNmcnWUgw95scl/T9UZQNeEHQe/gcrX8ePdl+S8AUzH78Eq32vNqp4AavVO/mDGypkuubcdPl9B7KErbB2J0Gk/RbU550/LZ7gDju2HjLLYGv8tmianIavwSMAXKd+K5jZe5MMPFn2ZmR3x5k4PU/Jv6IRUB+NCqyYKGReQRWie+rfSQKpV7r80pyxAJ2aRD1drLx1IWaN9uUTzg5ZqtpYmKQqEQ1gQGaeP7UkqGL4ZhGorp/Bh+9biFBPnWiixrArN5BimliJprMcXPC05YKxUqJodV0xL72fDLokjEq1kUhmKqNOvL0VF7kf0BBq1Wg70tOv6jXxkKzS3Bgv5CMEUTVLC7PD0urTQnnabOPD3Vk0BmgLusFCH8QA3z+2uqUBCQg11kyu3hfpxj+anhQ/Grm9GR3xRgzqXI24cEQxR1SeterTdoU2M+JbRoXUITbsfO9/UiZSQpNBF9+TX9k29YuUdJsMaPc3Gf3WOLMqIObQuwMUtF5tmgRa2Zs1P+tdm9QQe4HMCTvunOczuE11Z1Xx+vGWGQgur04DGiF4w0nXnxHh/ikQBkGcyCpeTS9PJX1bYeJtAeb1tmE385KQjIDwz6N8hmxZS2CA26008IAj6JKeNTlvX3dFsuQF3bJbPsc/SXjzLceYMUOW
 DVdv8Nft
 WeCxmiCrjpXBqkIU/Ui0SqihqbY9y9hduDrsCHQeiPYMDX6Tf/VN4MMsi/G6gzIixBiNM5zQEQQ/GIAcurKhc1jTuCT6hFOh5A/h9VTr9nS2cy6yZc1cpnG5ni0LW8pcMT61sXwnqWyAZqSC1qVW+0+KEUvNv6kQpuo2dOXJUgJq8GxuLzjdERuSol4FpwLgU0jI/k46ARjuJFTyz4njjWOecgK0pyaDExa8oIWui5CEYMo7ogSxerfvo0XfqfwkhCwjqTaXQTxLBOCcTexdTcpBZaQkCRQdqWaN9eS4bIP+XxjBkBPmTR1oVDVN0pV/WFTTzwxWyvqs88RmhbchbR1E2cH5V7g6beTLNf6/UI3R5lF5mtLxUPGL3ZL9gJhB+ixS/fpXnxNrUunJ9lzA9FmmM9piYqzdmU8W0xfk5BoJ14xGsZoBIYgQWU8HVJp4FmKsehWvQ9oyOhOSdImp/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 08:07:34PM -0700, syzbot wrote:
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    931e46dcbc7e Add linux-next specific files for 20250814
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=16a66af0580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=bb7fbecfa2364d1c
> dashboard link: https://syzkaller.appspot.com/bug?extid=4e221abf50259362f4f4
> compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11fb3c34580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=173c2dbc580000
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/68e3ffeee4c1/disk-931e46dc.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/3cc40de4a0c3/vmlinux-931e46dc.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/aed3e4f6a518/bzImage-931e46dc.xz
>
> The issue was bisected to:
>
> commit d50dabff4d1f2c815b2faf184f5d6db40596e2cc
> Author: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Date:   Sun Aug 3 11:11:22 2025 +0000
>
>     mm/mremap: catch invalid multi VMA moves earlier

Thanks for report.

>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16fadda2580000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=15fadda2580000
> console output: https://syzkaller.appspot.com/x/log.txt?x=11fadda2580000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+4e221abf50259362f4f4@syzkaller.appspotmail.com
> Fixes: d50dabff4d1f ("mm/mremap: catch invalid multi VMA moves earlier")
>
> ==================================================================
> BUG: KASAN: slab-use-after-free in vma_multi_allowed mm/mremap.c:1623 [inline]
> BUG: KASAN: slab-use-after-free in remap_move mm/mremap.c:1884 [inline]
> BUG: KASAN: slab-use-after-free in do_mremap mm/mremap.c:1923 [inline]
> BUG: KASAN: slab-use-after-free in __do_sys_mremap mm/mremap.c:1987 [inline]
> BUG: KASAN: slab-use-after-free in __se_sys_mremap+0xb33/0x1150 mm/mremap.c:1955
> Read of size 8 at addr ffff888074738558 by task syz.0.59/6077
>
> CPU: 1 UID: 0 PID: 6077 Comm: syz.0.59 Not tainted 6.17.0-rc1-next-20250814-syzkaller #0 PREEMPT(full)
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xca/0x240 mm/kasan/report.c:482
>  kasan_report+0x118/0x150 mm/kasan/report.c:595
>  vma_multi_allowed mm/mremap.c:1623 [inline]

OK this is a pretty easy one, we're reusing a VMA after we may merge/do
something else with it, silly mistake because of rearranging things around a
bit, will send a hotfix.

>  remap_move mm/mremap.c:1884 [inline]
>  do_mremap mm/mremap.c:1923 [inline]
>  __do_sys_mremap mm/mremap.c:1987 [inline]
>  __se_sys_mremap+0xb33/0x1150 mm/mremap.c:1955
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f7fd678ebe9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff51cbeae8 EFLAGS: 00000246 ORIG_RAX: 0000000000000019
> RAX: ffffffffffffffda RBX: 00007f7fd69b5fa0 RCX: 00007f7fd678ebe9
> RDX: 0000000000002000 RSI: 0000000000002000 RDI: 0000200000041000
> RBP: 00007f7fd6811e19 R08: 00002000004c3000 R09: 0000000000000000
> R10: 0000000000000003 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f7fd69b5fa0 R14: 00007f7fd69b5fa0 R15: 0000000000000005
>  </TASK>
>
> Allocated by task 5972:
>  kasan_save_stack mm/kasan/common.c:56 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:77
>  unpoison_slab_object mm/kasan/common.c:339 [inline]
>  __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:365
>  kasan_slab_alloc include/linux/kasan.h:250 [inline]
>  slab_post_alloc_hook mm/slub.c:4180 [inline]
>  slab_alloc_node mm/slub.c:4229 [inline]
>  kmem_cache_alloc_noprof+0x1c1/0x3c0 mm/slub.c:4236
>  vm_area_dup+0x2b/0x680 mm/vma_init.c:122
>  dup_mmap+0x90c/0x1ac0 mm/mmap.c:1780
>  dup_mm kernel/fork.c:1485 [inline]
>  copy_mm+0x13c/0x4b0 kernel/fork.c:1537
>  copy_process+0x1706/0x3c00 kernel/fork.c:2175
>  kernel_clone+0x21e/0x840 kernel/fork.c:2605
>  __do_sys_clone kernel/fork.c:2748 [inline]
>  __se_sys_clone kernel/fork.c:2732 [inline]
>  __x64_sys_clone+0x18b/0x1e0 kernel/fork.c:2732
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Freed by task 2999:
>  kasan_save_stack mm/kasan/common.c:56 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:77
>  __kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:587
>  kasan_save_free_info mm/kasan/kasan.h:406 [inline]
>  poison_slab_object mm/kasan/common.c:252 [inline]
>  __kasan_slab_free+0x5b/0x80 mm/kasan/common.c:284
>  kasan_slab_free include/linux/kasan.h:233 [inline]
>  slab_free_hook mm/slub.c:2417 [inline]
>  slab_free_after_rcu_debug+0x129/0x2a0 mm/slub.c:4730
>  rcu_do_batch kernel/rcu/tree.c:2605 [inline]
>  rcu_core+0xca8/0x1770 kernel/rcu/tree.c:2861
>  handle_softirqs+0x286/0x870 kernel/softirq.c:579
>  do_softirq+0xec/0x180 kernel/softirq.c:480
>  __local_bh_enable_ip+0x17d/0x1c0 kernel/softirq.c:407
>  spin_unlock_bh include/linux/spinlock.h:396 [inline]
>  batadv_nc_purge_paths+0x318/0x3b0 net/batman-adv/network-coding.c:471
>  batadv_nc_worker+0x328/0x610 net/batman-adv/network-coding.c:720
>  process_one_work kernel/workqueue.c:3236 [inline]
>  process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3319
>  worker_thread+0x8a0/0xda0 kernel/workqueue.c:3400
>  kthread+0x711/0x8a0 kernel/kthread.c:463
>  ret_from_fork+0x3f9/0x770 arch/x86/kernel/process.c:148
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> Last potentially related work creation:
>  kasan_save_stack+0x3e/0x60 mm/kasan/common.c:56
>  kasan_record_aux_stack+0xbd/0xd0 mm/kasan/generic.c:559
>  slab_free_hook mm/slub.c:2378 [inline]
>  slab_free mm/slub.c:4680 [inline]
>  kmem_cache_free+0x2f6/0x400 mm/slub.c:4782
>  remove_vma mm/vma.c:468 [inline]
>  vms_complete_munmap_vmas+0x626/0x8a0 mm/vma.c:1293
>  do_vmi_align_munmap+0x358/0x420 mm/vma.c:1536
>  do_vmi_munmap+0x253/0x2e0 mm/vma.c:1584
>  do_munmap+0xe1/0x140 mm/mmap.c:1068
>  mremap_to+0x2df/0x7a0 mm/mremap.c:1372
>  remap_move mm/mremap.c:1879 [inline]
>  do_mremap mm/mremap.c:1923 [inline]
>  __do_sys_mremap mm/mremap.c:1987 [inline]
>  __se_sys_mremap+0xadf/0x1150 mm/mremap.c:1955
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff888074738500
>  which belongs to the cache vm_area_struct of size 256
> The buggy address is located 88 bytes inside of
>  freed 256-byte region [ffff888074738500, ffff888074738600)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x74738
> memcg:ffff888030d7f981
> flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
> page_type: f5(slab)
> raw: 00fff00000000000 ffff88801bed5b40 dead000000000100 dead000000000122
> raw: 0000000000000000 00000000000c000c 00000000f5000000 ffff888030d7f981
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0x52cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 5248, tgid 5248 (udevd), ts 24347982328, free_ts 24338159697
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1851
>  prep_new_page mm/page_alloc.c:1859 [inline]
>  get_page_from_freelist+0x21e4/0x22c0 mm/page_alloc.c:3858
>  __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5148
>  alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2416
>  alloc_slab_page mm/slub.c:2487 [inline]
>  allocate_slab+0x8a/0x370 mm/slub.c:2655
>  new_slab mm/slub.c:2709 [inline]
>  ___slab_alloc+0xbeb/0x1410 mm/slub.c:3891
>  __slab_alloc mm/slub.c:3981 [inline]
>  __slab_alloc_node mm/slub.c:4056 [inline]
>  slab_alloc_node mm/slub.c:4217 [inline]
>  kmem_cache_alloc_noprof+0x283/0x3c0 mm/slub.c:4236
>  vm_area_dup+0x2b/0x680 mm/vma_init.c:122
>  dup_mmap+0x90c/0x1ac0 mm/mmap.c:1780
>  dup_mm kernel/fork.c:1485 [inline]
>  copy_mm+0x13c/0x4b0 kernel/fork.c:1537
>  copy_process+0x1706/0x3c00 kernel/fork.c:2175
>  kernel_clone+0x21e/0x840 kernel/fork.c:2605
>  __do_sys_clone kernel/fork.c:2748 [inline]
>  __se_sys_clone kernel/fork.c:2732 [inline]
>  __x64_sys_clone+0x18b/0x1e0 kernel/fork.c:2732
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> page last free pid 23 tgid 23 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  free_pages_prepare mm/page_alloc.c:1395 [inline]
>  __free_frozen_pages+0xbc4/0xd30 mm/page_alloc.c:2895
>  pagetable_free include/linux/mm.h:2917 [inline]
>  pagetable_dtor_free include/linux/mm.h:3015 [inline]
>  __tlb_remove_table+0x2d2/0x3b0 include/asm-generic/tlb.h:220
>  __tlb_remove_table_free mm/mmu_gather.c:227 [inline]
>  tlb_remove_table_rcu+0x85/0x100 mm/mmu_gather.c:290
>  rcu_do_batch kernel/rcu/tree.c:2605 [inline]
>  rcu_core+0xca8/0x1770 kernel/rcu/tree.c:2861
>  handle_softirqs+0x286/0x870 kernel/softirq.c:579
>  run_ksoftirqd+0x9b/0x100 kernel/softirq.c:968
>  smpboot_thread_fn+0x542/0xa60 kernel/smpboot.c:160
>  kthread+0x711/0x8a0 kernel/kthread.c:463
>  ret_from_fork+0x3f9/0x770 arch/x86/kernel/process.c:148
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> Memory state around the buggy address:
>  ffff888074738400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff888074738480: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
> >ffff888074738500: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                                     ^
>  ffff888074738580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff888074738600: fc fc fc fc fc fc fc fc 00 00 00 00 00 00 00 00
> ==================================================================
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
>
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
>
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>
> If you want to undo deduplication, reply with:
> #syz undup

