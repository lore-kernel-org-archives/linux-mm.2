Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 977C7CF6BE3
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 01:57:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C4A86B0088; Tue,  6 Jan 2026 20:57:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 065256B0093; Tue,  6 Jan 2026 20:57:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E549E6B0095; Tue,  6 Jan 2026 20:57:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D23236B0088
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 20:57:10 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7130213C80E
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 01:57:10 +0000 (UTC)
X-FDA: 84303505020.08.2773A14
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id B20E0C0003
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 01:57:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="ix/rMvav";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=bvLp5w3F;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf22.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767751027; a=rsa-sha256;
	cv=pass;
	b=pX2DD00ujcFj4A1gNAap3UmSnvNm8ZtfPqqr6Jzw2P2f+3T2I+qj/INv4F2j6ipcy/L39V
	B2n3wmX7O1X8zLmm+kh4AwKzzx8s8q4cqfqamGxxmrukKnkxf6+bX7mlRo0/Gre0cMUjCU
	YEGvCyW+2Hkzll/+O80ap/8XeE+fiXE=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="ix/rMvav";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=bvLp5w3F;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf22.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767751027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tqTd9PnTv+y7ePT5bYjh/wa1gZyBxESIv8q29QYGRLM=;
	b=48/+jmVaur2E23bk5PSPI/e1phLDVHw7hpe5cqTcSrQMqCUOafJjQOXs7h2egEVV3NrvjY
	uK2B0ndX5WzF2Kxv+i5kxVbJJV9o/RiLBcbsj6MVEagfZpQA7V+9VzSUtzSmfiwf7XhXLW
	SMtArFU0v4/pQrT1T8lOs2tszDhjxUM=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6070Qqm1778465;
	Wed, 7 Jan 2026 01:56:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=tqTd9PnTv+y7ePT5bYjh/wa1gZyBxESIv8q29QYGRLM=; b=
	ix/rMvavBJG5frjEmGi2vcQ5cjQM66OSaOUG2o2TciY4eOLBloNgA8WyjxNMW8vo
	iH3mgkIRbSpZ7LyOB68EKaG/TaaKaEqZMz2wziLxtatSnFRAiW+H6FcS9rbU2a9b
	wYToobXiEvugdNP6hi6khSSZCew3qJ2z302PXdtw36c7RnmqJFmAhQTzSmNtns8k
	QxTbZu+HD+a1TMouraExqL0TkmrWjpAKokqPJxssxInbBBHNobtQPUvadEIIy+tw
	1QR9vTFjH6U31N+U4XuWICn9u2ECsCyZ/Wg2QnNV5jCwXuYcnARcjtwWKnztqAXK
	oE5S4AhE1jfT/bmd0OpVQw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bhcxhr2hx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 01:56:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6070JMYC034049;
	Wed, 7 Jan 2026 01:56:58 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011069.outbound.protection.outlook.com [52.101.52.69])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj99vqf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 01:56:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YPpdXRY5GgMZk6GoTycu+EgHFxt4HCYK4RSYCVBRweQr2I/JUY6NCEWMjj3Dwsl6fjmUISHJqkO6lGlxEOUsM0X+uHS0aSG1PqXsuQxuQe2DrJRTpRIuNsmKZAs1UKj2kbnsv5AK1SzgPksvLqlcHfjgRHeVrDuIvtmTOFO1fgSOFC6IN4hDZqUE/mr3QN57e191L9XS+1lSB+/wRx0gKpY+QBwqyQQaKvlWBAQnMyFIQpYHdCXuAzAhCwJByV1rJklFFwpcE5eaZjTfNQgnyFsZe5UdnqVoBUzSEPvKh5sKtTEhMMYDENryhN2XPcAU/frnAlkPYcTOquBJQAAeGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tqTd9PnTv+y7ePT5bYjh/wa1gZyBxESIv8q29QYGRLM=;
 b=GNORu7qLlrKOE17OYkKc81QRyNO5kxSEoYEW0q0r4QOGMUT/IjVCbcgs1HzHJzyklnoNTjoJZObPJUOsDWAsi2e+XH0ekYWwB0/C5kPp9aSRseRgAmz6KYMYwQ6vU9ec0jsOJcxDt4GtlIk7xRjVw4oaTylc15dj/K7pPLsZkSxmXe/lvv3Xc/ZQmCeN4oe+3ctGe7olu6gBF1P8ACLcoHBzRaZwXel3cO9BIJrVfzqsNY9SV37PJe91Z9wwXXm7IBlGdFS/1fkWpKMap6GZkiGpBHmz5R6mJiSSs11uqrAHRhLEgjYa05SwYKpFfK0ZDOnY2xPjD5MlGkEG0aDG6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tqTd9PnTv+y7ePT5bYjh/wa1gZyBxESIv8q29QYGRLM=;
 b=bvLp5w3FuGLoL5wt5PWCTUapIlLG/TwmyyliLBatzMhoF8K2mRRg9Ito/2yy+hm18zj0jAVtBpeRLCi7yPyB18CDNSIkkeWJCh7ATyPoJIkLbTnUsOuIIt74ZI2o+4nUBHwCIiAPBgpvETPHGvaGDmq9RP13DCsdMx4PWVuAkVU=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by MN6PR10MB8144.namprd10.prod.outlook.com (2603:10b6:208:4fa::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Wed, 7 Jan
 2026 01:56:55 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 01:56:55 +0000
Date: Wed, 7 Jan 2026 10:56:46 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Thomas Ballasi <tballasi@linux.microsoft.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-trace-kernel@vger.kernel.org, mhiramat@kernel.org,
        rostedt@goodmis.org
Subject: build error on CONFIG_MEMCG=n "error: invalid use of undefined type
 'struct mem_cgroup'"
Message-ID: <aV29Xj2wo786xVn1@hyeyoo>
References: <20251216140252.11864-1-tballasi@linux.microsoft.com>
 <20260105160423.23708-1-tballasi@linux.microsoft.com>
 <20260105160423.23708-2-tballasi@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260105160423.23708-2-tballasi@linux.microsoft.com>
X-ClientProxiedBy: SE2P216CA0093.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c2::14) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|MN6PR10MB8144:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f4040f5-44e4-41e3-9277-08de4d90085d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R2JQOGFYYUk0b0c1cFNBWWJydEFRUm1GNHgvVDA2NVdpRHhrRDNhYWlGL2pW?=
 =?utf-8?B?MDBySlo4WTZEL2k4NVhDc2dBTisyVU9qWTZoNjRSelZjRnFveCtpaEhVRENq?=
 =?utf-8?B?VENiMnFnSVVEblltZUU3eEQyYzFxR0p1NnNLb1BveXlwUmp6OXY2WmViUXBX?=
 =?utf-8?B?ajJ5blYza0llNzNyWmthYk1FMUUxZC83SUFSK1h3b0xsKzJEM21RaE02SlBu?=
 =?utf-8?B?VnFtcko4VTNmR2NxVHI1M0xLNmdXVFBlM1N6dUNNcE5xR2sySVNsMExWRXlP?=
 =?utf-8?B?OUVIUk1WckJXMU9rNmRuSVN2bDNJT0dncmU0QlVRazRRZXNkTFFtRWFrTXhi?=
 =?utf-8?B?Q3B6bXlSMmRhK09mSVFFMGtvUWJLdGV2RENKM2NXa3Nhd2QxTFRkRXRBdWpZ?=
 =?utf-8?B?S3pBb0pMQUJOVDZVV085bkphcExzZDJKdmhtNnFUMzNZSGI2ZTluYmdKU0pK?=
 =?utf-8?B?Y01xVm92QTgwRTk1TW1xNGVSdFgzVGFwNHpmZEpLRU5nUFExU2RhYTczdFNv?=
 =?utf-8?B?R3krVjRGcmRBYXd3UmZjZ05UZE1OT0QrUEdUdldycWxkSmRlM0JTeEg3SjYz?=
 =?utf-8?B?QVNEMFZBT2NuOUFUN05EWm8wdW8xUk5HMnc4d0VmTTFKMFI5cFJOQVlXTXR5?=
 =?utf-8?B?bm1ic0szOVdFcDRzZ2tTV2NXTVliLzdDMVlqeWRSQ2RLRHMvZUVLcVIrakdt?=
 =?utf-8?B?VFJlT2N5WGFIekcwdm9WeU0reGVTUmZKYTlpMUhJYU5lcEUvSEx0RWRQVzFY?=
 =?utf-8?B?NjFRV3VTWkdFbTVWamhRK2IvWkM2cksza0NvQURmN0ZKV1JsVzhkQldxS2ll?=
 =?utf-8?B?T01sakIyTVdscHFoeE5wdkNVYUIreHRUcEN3Mytjem5hKzd6QllMcmlHbUFx?=
 =?utf-8?B?b21DQWVVYmoyZEFCRTZlZG1oTkd6YS9iNDEwQWpEeVNpbGhMbEdzSVBnb3JT?=
 =?utf-8?B?TlZKRDdRUDVZbGJpN0NxQjEybzZ6dGZzaVRFY2YyS0JRRkxjS2F5UUxQYVlv?=
 =?utf-8?B?dStyeGNSdy8yVDVpSGJHalJKM2N0aERYK0puV1JMK3M5OHRHS2NIUHkrN2Rh?=
 =?utf-8?B?NldjQTNXaXdlZVludnBBOVpaVGs2cnNkYTRQVm1vRWpudUowREMyTStxZWp1?=
 =?utf-8?B?ZEp0S3VBTjVsSThpVUtvcThrUUtIRTFkalNieVg1dDZBMG5EeHAzWVZtT1Qw?=
 =?utf-8?B?Y2VTZDZ4WlVENmpVV2dvc3NSMDVSSGdGZ1J3OU45RXU2aVFwV3p3Tlpuellk?=
 =?utf-8?B?cnBHaVpiTFZDeDJUdDM4MjNNUFRmQW0xMkpQb0U2cmM0VmpQOEcxdmR1MjFF?=
 =?utf-8?B?cEsrZmRKL2s0TW9SN3B5WXVDOGxNdXBrRkk1c3Zsazd5Yy9wL1YwNElzb3FB?=
 =?utf-8?B?emxhZ0JVUzR2aDFxVHlOK2gvZ2JNV2dEZktFZTRPaXVVb1h4T3pJckJaV3Rz?=
 =?utf-8?B?Y09GNTRXK0dYSWhXSHlOT1NCQThZR0IrTkpWcFR6UjZTZGlwYXRUZytUYzl0?=
 =?utf-8?B?WTVVcTI5dVcyQ2dtZ3A1UGI3LzBNUC9YbENRTmdUQ0JwaGhDZmlyR2crWHIv?=
 =?utf-8?B?NWI5ZEs4VXRZRDdTTXh6TXRlME0rMzliRTVjWHZnYk1KbUY3OFJXN3F4aG9W?=
 =?utf-8?B?emhMcURYQ0ppcFFkRE52elh2QjBmNWVvRXpxNEVFMWoxK01qWEF4UCtjZ1J3?=
 =?utf-8?B?TkZHNGNuRExOYUxKOFZDdWFkV1VyLzNTMXhCUDRROVZOSTVteFY3aTRBbE5n?=
 =?utf-8?B?RytiQzJFczlRT1Nqazl1M2dPT3Vwanl1UEc5Q3pQcWJ1dFQxQnBpUE9QemVL?=
 =?utf-8?B?SWFMZFg4S3hiTENGMEU5cHorUkM0a0dNVDV0OVhxK0dqTHQ5c3M3UjVsaXNu?=
 =?utf-8?B?ZFlXZzhWYUR4YVNJV1FsQm80cnZCUkdxM0d1RUhFQU9LSWhGVUN6d1dDbjhF?=
 =?utf-8?Q?VV6RvMBWHWrFt8gay4UHec+m8ldzaI7E?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aHBRWHAzekd4QXRXbGtha2ZmWkFreTVKbjRBR01UUHlvRHUxK1p2UU5oMXF2?=
 =?utf-8?B?cTlwWnRrbHgwbmZoTGVGLzJNb015c1Y3UGxsVzJpSGd2UGU3Sm1ma3VGNjY5?=
 =?utf-8?B?dDc5NldNbURaZTZxV0NmMVRVaHd6aTBNeW91ZlZvdlpxKzNwQUtNTlFxbVBU?=
 =?utf-8?B?Zk5nM0lIZlo4eHNnOGFWYVZpbmx3dGhsZ1VUUGNlY1JDVi96UHN1Sk1ZdDJM?=
 =?utf-8?B?WHJBbDk2dDdGa3hBeFlOL1N0MkhJYVR2SFlENERzeHQrSzFQSTUwUXVEZ25q?=
 =?utf-8?B?eGhDc20vTXczR2tFMWF2OCtsMnJZUlJ3OWROYkhpNlM3cGQ0Tm9XRFdzWmFN?=
 =?utf-8?B?eFplUFMvQTRXVnU5dzFaQS9BZU5ibnc0akEzbFo1QmhRbWNzZ0NxeGRseC96?=
 =?utf-8?B?eXlqaEpiY3c5VWhlbDJjQ3YySG93U01WVk8rMmZ6akhjNGxqcGRCYnBmemZs?=
 =?utf-8?B?eVBoZXp6U1Q0UFBFaXBJdDJLSmUvbCtUdmFJSGZYUlRwTkFBcUNRZFdaczhN?=
 =?utf-8?B?d0pBTU9rb256eTAzdWFMV2RQLzVRU3B3eFducFVjWHhjT2dRa1lsWkc4Q3d5?=
 =?utf-8?B?Q3ViRHk4aExWcG90Ky9BKzNJU3JneHZyNWxnU3FrQXk1N2hnLzdVUXVqWWFp?=
 =?utf-8?B?UzJUYmEzWlhEY0ZOb0I0TldDV2dDS0F2eDdGaVN1ZkZiQ2Y4T2FsSzZEaTZQ?=
 =?utf-8?B?b0pKdU4vWHkveHpnOVRnYXUyWVRTcFdqS2RmeXBVdCtIK0JVRXZQa1N1OWJP?=
 =?utf-8?B?d0w4OUF1UUJuYmRDQ1NubldVZ3FmVmEwRVV2VHVHMXJJSHVVSWlUVE90dzA3?=
 =?utf-8?B?bWF0RHhkb05KWSsySGJrcjUrVWp6K0tEeE4vVVUxVVl6SjNodnFRb25kUFZL?=
 =?utf-8?B?Rkl2NUx5dHp2R2FwbW94dldma1dNM2lKZGc3c21INmhaZHlNYjFaUDQ5UGQy?=
 =?utf-8?B?a1BCMFB4ZXR0V0hhSFliMVV2T3RhTTJBaXRTVTc5ZHNHUWJzb21iZTdqRTg2?=
 =?utf-8?B?SGd6eUNsbUdMaWFPekV1c2JQR2FCMjJEUDhUMjZYUVQ0T0pHOE5BRnNEaVNl?=
 =?utf-8?B?NzIyWmMwS3NPZ0RlSUtIUlFtZXNxcmF4cXdmRzNMenUzUVVkNUZLUlUzeEkz?=
 =?utf-8?B?Qkp0THFrUFRUTnBLNm1CbFhKQXNmSnAzM01kSjdUaWNEbGVYeG9CR2NGMGk4?=
 =?utf-8?B?SDZvTllWMW5SdXFHNGhwLzIwNnFBVzlNbHpUY3E5eHUvMldtUmUwRHRKc0kw?=
 =?utf-8?B?VFo1ZDc0bHgzenJoVU8zWVlJczFzTStLTXhNUUY4MEwzZDViMHNBR001WmN4?=
 =?utf-8?B?ald3NEVreC9DcDFmbGJLbkUvS0JSckVxSFc0WDYyRERaNWNiK2dhZjlQbHN6?=
 =?utf-8?B?U1VaOUVKMlRuSVlwbDdGeVkxcnVCM0M3TnMyL0dDbm1uVU83cmJ0MWVIV0o4?=
 =?utf-8?B?S1l1MmNCU0NVY09ZdndRb1Q5aXFBRW1tVGtPUktFcmp4Q3lUd0ZhWk1qT1Q0?=
 =?utf-8?B?S1pIV21oQU82ZldEVXJCekE5SSt4dDNMYU42WnM3aHlOQmJjM2JwTDFjTUVv?=
 =?utf-8?B?ZTBMNm9Fc084REp5RkprM2tyVERSZnlTQ3RldVlLbXRTY0RRYU1YMXZhdDBW?=
 =?utf-8?B?clJMRFFNdmlKc2dmSDhwWmg0a25UaHFwemRjMUFTdmF3Yks2QUdCbWxhdXdz?=
 =?utf-8?B?VXBLYUNDZ3lzTTBLTi85ZzRDeWw0VCthOHB1UFA2Rjc2WDVxWXJQOWhWQVRI?=
 =?utf-8?B?Y1czN2FVRXQxanRNd2VVbXA4cThxQzZSamE4aFZyNjZaQ0tJTk5lR2hCNFg0?=
 =?utf-8?B?Slo0ZFd2QWFLQzd6MkdkcXh3WXZLTHMxa2JlcCtmUWJtTDZLR3lsemZQbkRG?=
 =?utf-8?B?a2c5NE5HRk9KK1h1VVVTbUNhMFdWUisxaWxRZ3NrbzU0WFVvOUdwZ0dCby8w?=
 =?utf-8?B?QjRoMGNNN2NtSm1WdmZBVGZmY0htL1o4V05OTUhzYnY4emNkVDJjdFlMWUxZ?=
 =?utf-8?B?K3dxYnp0MngybUVSdVc1K0JXdVFJMndSTk5tMVRIOXVLeEV0RDhZdG45STJC?=
 =?utf-8?B?UzJzdDgrUDdsTUF0Zk9hcVRDWDlmcUtrOEZHTXk0clZPRWN5Vmx3enVoaVQ1?=
 =?utf-8?B?QnpYMVBFeFU3UnczV0ZxNkE2MVYyNVorOVFqWXR3YzBJQmtCOXVKbDFDQVN3?=
 =?utf-8?B?RTU3UkhWcmtuRGk3Rll2K21hVHBRaXhkdWx0VGg5ZFc1VFRhb1ZqRS9IYU5E?=
 =?utf-8?B?eEl1Nlh1ODVJRW55RGc2QWVQMFhveEhLV3gwN0UzNG1WN3l6VjVxUUovYmVD?=
 =?utf-8?B?NlR5c1U3MDJzYThUMWtiTUNoM2UzSFdMTkpVOGF3RXNHLzVmRERUdz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2IXnYSxIvlXMzIiGxHtNi4sCz4MqjIv3cbGmfFb2Tgnf1WVcOuylLLGRK9nTxsWFKbv4kysXpJzISL6jTDgVRoel8AVvHU3mF0qoTyt/e1vSTGKGxQJUZyp3aVReXQd13p9YG/B4RPHDdQQd0bS7TnNWUee9CJuM855ko+KIJOfn2FJCkL61Iga8DItOoyfDRcBSddzb0pb8NsVtX7BOmViD2BC1cT3NYg89/OPq7HB8wuKUuXfHAT2p46nOFxxGt5TyG+kAfC4sfqsx7EDn16LC/VoOCTlChwlYB6AwXF1BER7d2FiqPOfvr8a9rpJvVrNwY4s8HtUIod8+LWa1XJmjD8pmE5t3QJUnwobkkslqs1U5H7tSVbeUsV7fkpltydR+nAKTrykQZL9gqPavmD6Y+ssPlK2/Pk1mTAKd0sjOvlUizZGPKVs70Wa3BBXFT27Bl3koLxyyDodTDqAxZewc7rmNyoDJJQZz5+BRHI63wVYv9dC9WWe+IRtYSxZDUJSEAnPGEV15ETKxI9w1M44zKOa78la/v9Q3KPhbWSPqehSHt42y495tZnixYQKwkT7c98p/Fab1XMx4pXosMzym/Lcp3mJMu+Tm2vhsLNo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f4040f5-44e4-41e3-9277-08de4d90085d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 01:56:54.9028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZlM3qWTu3zdJQEANk7ek/igqg5kHF9VlgrXrFQi4zb8jSUArk6oBeODpoimX9h/V72/QjCz1O+s5GbByTRx8xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB8144
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_03,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601070014
X-Authority-Analysis: v=2.4 cv=NPrYOk6g c=1 sm=1 tr=0 ts=695dbd6b b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yMhMjlubAAAA:8 a=v0LIXEgrRPRinlxJrn8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA3MDAxNCBTYWx0ZWRfX0bLn/Bp0gjhW
 Mt2PiGRe74OklPocK/thyroboPzUKm39Hp8Gge4/OCrn4aYfLrLQOYaqf63PY8ZTwN57dJdJgVa
 /IUTYxEf/AYYQSAJDcufPdx6gfqSoepc80M3gZws07iQPp/Ry3BKLAPNsPN0rDiNeqKzygS0dd6
 eWXrkeopcbAGtnVAqaIterVG9N+4WhCe195biB/jwlVVvsPcG9s1WgUpfP7YFCdpkojzGdoGW6D
 hCb3egz485QJTIOqvblPprfSwyKtFqpEnYheS6YOQIey7as1f4XQE9gMvjGB6shL/3r18MbVS3x
 eP8p0V8Ywl7qR7gW27nmmQBB2HvFIPQ1cdCQLrCSGgFoAoy2XxKTV2tijn93fZ52wwUvWDt+/4c
 o0kk522cjO4ZUURoL6dXm7h6J3eSN8hSiZyghT4TjQdQXIjpFxEa9ugjGCqNf7wdLbXL6VE4aJs
 bMscEZAKpKkIzD3FSXg==
X-Proofpoint-ORIG-GUID: VIWoxtYPTpqexMzXz0j4HGmbQDlVhEvQ
X-Proofpoint-GUID: VIWoxtYPTpqexMzXz0j4HGmbQDlVhEvQ
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B20E0C0003
X-Stat-Signature: zakh1y4774kca6w1rtr1aapgayw1rbr4
X-Rspam-User: 
X-HE-Tag: 1767751026-393227
X-HE-Meta: U2FsdGVkX18z59UYIi7G6Doaynh5N6aQxdTZuSdXnvrCB4GpvK5JAIbfkXG4bzMNfVzW5/iyRr/I93A6WEzsbWecibeZx5LXHVcBVti6LSA1otWztY4ixXpbMdJ67LQdwY5TZtaaoAyuG/w9JHlXzaAnG2bLpd8zA6NaZZ+puXh4QpVAVxpLB1RH+Pn+6d/9NYzvzfTfyH979wjXpApz77RaRWjCWTfVdWF68gJ4bmNdEdK0Wsmt57GZ+H8G/1OOahu2E76ZtFDdA9SnvO8PmWtjJP7QpqHyob+EfQwkMmoMo6pVmSh6o8rY1W1pzetcHecImAcGfrK6PQ/plUJraCymMD3cGGMaTFpxJzzfjmbSF/S3EN3c51snlyUROk7l1qRvw3CKv5Opj+GjIufIH/v0SDVm8iYwjMsV0mwafS1l+YeciCNT/s40DKORPSr8sSXZyMOhx1TTLcdHRk7uUWatvHvQge54KV1zCGZzZvbs0+/FHX2FgQplEhEmSRh+BULSiCrdJQOF+98ohcuw3jvR12cAlgnPi3YEoGH0Xfnt70RYU0twW2eR5fjJ9aE60JPI2gGS6iC4jSH19iarQ4PxkWE57oZO/9MvnVis/1oPHtaRmnh2R6NG3UZaIHoRtE77wWYShHSZeyv4v9PM7BQMJYx+Ynp+lxGPVUbKAFXaR5sGtp24MPJcQylM/XUkD7mpyRmWsRWxaYq5BVrGWt+HUHN8k4RPnEQ2H8vw/xanRamFhqfG3A0V2B6wcjfYfMMWVfpkN3/eJvlWZYQ8Hg19CayglqqSaGUEG6RNkK3Q9n4i5Y1NRmKeFBsDR7ONcKQvbmwHCuU0a5Ecy+ZJzye+cD6H38nCyVF0/LFauWcZQpwH5rJkVDBJsMFSx8ro5j5DVqYvXkfTWsZAGHfNuC2rwdoip4vtiF9xcEpjeCdFwiDHQDHxsrRaOziBC2oiuFoonDlQciyi50+Zs6D
 1IXkKSeK
 vI/gKE2HCVGv+VwlGj9sJXWDHSc0bk6HqiZXOkv2sw3GJCRHuBWxJJkzLet74y5lABQsg5uqrc5TcYFFmX9G9WnNOcOPxtH18AYTxrpYfBtTXTiP5RIHgrbe0/Lo8RIp4orPOgM+NhEcmIyaD/LMDXT5wdt9Hkqev1mdMUAIZNDAX4BDVh1MV8w/aEwkrL16/3hiPWYspF4YFG+zKCq5V7FUi6NtJCWR5Dm7yD/apiteaBshpDfRmYXDVx+rwwpzq2NZguSwi85izHBrb+GdGWGlrfxqsYVuHErMBMgQR+EuHpmJvSVC2UmRnyY9jP8Z51cjQW4g8uLUiZgEITSMpxlu1PVkvhokWV3d7s+7CbakilCcwWZUNzY3FZL3rs8dU1C/IMJ6ZT601FoYCRdc4B0I/dmk879wBVOP11j1iBATb+ir5hSzSRkYouCZ9shMbcUnkMOmQC/rC2jUmK7zCRVS6QvNwNT6p7uu1cPoeql9pqv9DDqgsD32bn+wqYrn4k9Au7Sv9EpFoJaBr3Y3IHRehBnicxfwfalVfdks+DKRNAiaAhGQXOt5t+MgvnLEF1B3ulVfHj1QHdrj2aJvVqmPwKQPtY35FxI3kB9U8Bw8kW//oWwSXCgQrJG31MzGAR9xpG+7k2zXdfaQhdlfNo+SvEauXXI4JIg6n0DzETt+tyNMsh6jq06su5SyZr82yRfR7XCDNGtnHqwHKg0j5NenmfiD1rsKh/fA/MUrqhKYk10j6Huw6bX7Vgg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 08:04:22AM -0800, Thomas Ballasi wrote:
> Memory reclaim events are currently difficult to attribute to
> specific cgroups, making debugging memory pressure issues
> challenging.  This patch adds memory cgroup ID (memcg_id) to key
> vmscan tracepoints to enable better correlation and analysis.
> 
> For operations not associated with a specific cgroup, the field
> is defaulted to 0.
> 
> Signed-off-by: Thomas Ballasi <tballasi@linux.microsoft.com>
> ---
>  include/trace/events/vmscan.h | 79 ++++++++++++++++++++---------------
>  mm/shrinker.c                 |  2 +-
>  mm/vmscan.c                   | 17 ++++----
>  3 files changed, 56 insertions(+), 42 deletions(-)
> 
> diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
> index 490958fa10dee..93a9a9ba9405d 100644
> --- a/include/trace/events/vmscan.h
> +++ b/include/trace/events/vmscan.h
> @@ -208,31 +215,34 @@ TRACE_EVENT(mm_shrink_slab_start,
>  	TP_fast_assign(
>  		__entry->shr = shr;
>  		__entry->shrink = shr->scan_objects;
> -		__entry->nid = sc->nid;
>  		__entry->nr_objects_to_shrink = nr_objects_to_shrink;
>  		__entry->gfp_flags = (__force unsigned long)sc->gfp_mask;
>  		__entry->cache_items = cache_items;
>  		__entry->delta = delta;
>  		__entry->total_scan = total_scan;
>  		__entry->priority = priority;
> +		__entry->nid = sc->nid;
> +		__entry->memcg_id = sc->memcg ? cgroup_id(sc->memcg->css.cgroup) : 0;

Hi Thomas, this is breaking CONFIG_MEMCG=n builds.

In file included from ./include/trace/define_trace.h:132,
                 from ./include/trace/events/vmscan.h:569,
                 from mm/vmscan.c:73:
./include/trace/events/vmscan.h: In function ‘do_trace_event_raw_event_mm_shrink_slab_start’:
./include/trace/events/vmscan.h:248:68: error: invalid use of undefined type ‘struct mem_cgroup’
  248 |                 __entry->memcg_id = sc->memcg ? cgroup_id(sc->memcg->css.cgroup) : 0;
      |                                                                    ^~
./include/trace/trace_events.h:427:11: note: in definition of macro ‘__DECLARE_EVENT_CLASS’
  427 |         { assign; }                                                     \
      |           ^~~~~~
./include/trace/trace_events.h:435:23: note: in expansion of macro ‘PARAMS’
  435 |                       PARAMS(assign), PARAMS(print))                    \
      |                       ^~~~~~
./include/trace/trace_events.h:40:9: note: in expansion of macro ‘DECLARE_EVENT_CLASS’
   40 |         DECLARE_EVENT_CLASS(name,                              \
      |         ^~~~~~~~~~~~~~~~~~~
./include/trace/trace_events.h:44:30: note: in expansion of macro ‘PARAMS’
   44 |                              PARAMS(assign),                   \
      |                              ^~~~~~
./include/trace/events/vmscan.h:214:1: note: in expansion of macro ‘TRACE_EVENT’
  214 | TRACE_EVENT(mm_shrink_slab_start,
      | ^~~~~~~~~~~
./include/trace/events/vmscan.h:237:9: note: in expansion of macro ‘TP_fast_assign’
  237 |         TP_fast_assign(
      |         ^~~~~~~~~~~~~~
./include/trace/events/vmscan.h: In function ‘do_trace_event_raw_event_mm_shrink_slab_end’:
./include/trace/events/vmscan.h:293:56: error: invalid use of undefined type ‘struct mem_cgroup’
  293 |                 __entry->memcg_id = cgroup_id(sc->memcg->css.cgroup);
      |                                                        ^~
./include/trace/trace_events.h:427:11: note: in definition of macro ‘__DECLARE_EVENT_CLASS’
  427 |         { assign; }                                                     \
      |           ^~~~~~
./include/trace/trace_events.h:435:23: note: in expansion of macro ‘PARAMS’
  435 |                       PARAMS(assign), PARAMS(print))                    \
      |                       ^~~~~~
./include/trace/trace_events.h:40:9: note: in expansion of macro ‘DECLARE_EVENT_CLASS’
   40 |         DECLARE_EVENT_CLASS(name,                              \
      |         ^~~~~~~~~~~~~~~~~~~
./include/trace/trace_events.h:44:30: note: in expansion of macro ‘PARAMS’
   44 |                              PARAMS(assign),                   \
      |                              ^~~~~~
./include/trace/events/vmscan.h:266:1: note: in expansion of macro ‘TRACE_EVENT’
  266 | TRACE_EVENT(mm_shrink_slab_end,
      | ^~~~~~~~~~~
./include/trace/events/vmscan.h:285:9: note: in expansion of macro ‘TP_fast_assign’
  285 |         TP_fast_assign(
      |         ^~~~~~~~~~~~~~
In file included from ./include/trace/define_trace.h:133:
./include/trace/events/vmscan.h: In function ‘do_perf_trace_mm_shrink_slab_start’:
./include/trace/events/vmscan.h:248:68: error: invalid use of undefined type ‘struct mem_cgroup’
  248 |                 __entry->memcg_id = sc->memcg ? cgroup_id(sc->memcg->css.cgroup) : 0;
      |                                                                    ^~
./include/trace/perf.h:51:11: note: in definition of macro ‘__DECLARE_EVENT_CLASS’
   51 |         { assign; }                                                     \
      |           ^~~~~~
./include/trace/perf.h:67:23: note: in expansion of macro ‘PARAMS’
   67 |                       PARAMS(assign), PARAMS(print))                    \
      |                       ^~~~~~
./include/trace/trace_events.h:40:9: note: in expansion of macro ‘DECLARE_EVENT_CLASS’
   40 |         DECLARE_EVENT_CLASS(name,                              \
      |         ^~~~~~~~~~~~~~~~~~~
./include/trace/trace_events.h:44:30: note: in expansion of macro ‘PARAMS’
   44 |                              PARAMS(assign),                   \
      |                              ^~~~~~
./include/trace/events/vmscan.h:214:1: note: in expansion of macro ‘TRACE_EVENT’
  214 | TRACE_EVENT(mm_shrink_slab_start,
      | ^~~~~~~~~~~
./include/trace/events/vmscan.h:237:9: note: in expansion of macro ‘TP_fast_assign’
  237 |         TP_fast_assign(
      |         ^~~~~~~~~~~~~~
./include/trace/events/vmscan.h: In function ‘do_perf_trace_mm_shrink_slab_end’:
./include/trace/events/vmscan.h:293:56: error: invalid use of undefined type ‘struct mem_cgroup’
  293 |                 __entry->memcg_id = cgroup_id(sc->memcg->css.cgroup);
      |                                                        ^~
./include/trace/perf.h:51:11: note: in definition of macro ‘__DECLARE_EVENT_CLASS’
   51 |         { assign; }                                                     \
      |           ^~~~~~
./include/trace/perf.h:67:23: note: in expansion of macro ‘PARAMS’
   67 |                       PARAMS(assign), PARAMS(print))                    \
      |                       ^~~~~~
./include/trace/trace_events.h:40:9: note: in expansion of macro ‘DECLARE_EVENT_CLASS’
   40 |         DECLARE_EVENT_CLASS(name,                              \
      |         ^~~~~~~~~~~~~~~~~~~
./include/trace/trace_events.h:44:30: note: in expansion of macro ‘PARAMS’
   44 |                              PARAMS(assign),                   \
      |                              ^~~~~~
./include/trace/events/vmscan.h:266:1: note: in expansion of macro ‘TRACE_EVENT’
  266 | TRACE_EVENT(mm_shrink_slab_end,
      | ^~~~~~~~~~~
./include/trace/events/vmscan.h:285:9: note: in expansion of macro ‘TP_fast_assign’
  285 |         TP_fast_assign(
      |         ^~~~~~~~~~~~~~
  CC      arch/x86/mm/extable.o
make[3]: *** [scripts/Makefile.build:287: mm/vmscan.o] Error 1
make[2]: *** [scripts/Makefile.build:556: mm] Error 2
make[2]: *** Waiting for unfinished jobs....

-- 
Cheers,
Harry / Hyeonggon

>  	),
>  
> -	TP_printk("%pS %p: nid: %d objects to shrink %ld gfp_flags %s cache items %ld delta %lld total_scan %ld priority %d",
> +	TP_printk("%pS %p: nid: %d memcg_id: %u objects to shrink %ld gfp_flags %s cache items %ld delta %lld total_scan %ld priority %d",
>  		__entry->shrink,
>  		__entry->shr,
>  		__entry->nid,
> +		__entry->memcg_id,
>  		__entry->nr_objects_to_shrink,
>  		show_gfp_flags(__entry->gfp_flags),
>  		__entry->cache_items,
> @@ -242,36 +252,39 @@ TRACE_EVENT(mm_shrink_slab_start,
>  );
>  
>  TRACE_EVENT(mm_shrink_slab_end,
> -	TP_PROTO(struct shrinker *shr, int nid, int shrinker_retval,
> +	TP_PROTO(struct shrinker *shr, struct shrink_control *sc, int shrinker_retval,
>  		long unused_scan_cnt, long new_scan_cnt, long total_scan),
>  
> -	TP_ARGS(shr, nid, shrinker_retval, unused_scan_cnt, new_scan_cnt,
> +	TP_ARGS(shr, sc, shrinker_retval, unused_scan_cnt, new_scan_cnt,
>  		total_scan),
>  
>  	TP_STRUCT__entry(
>  		__field(struct shrinker *, shr)
> -		__field(int, nid)
>  		__field(void *, shrink)
>  		__field(long, unused_scan)
>  		__field(long, new_scan)
> -		__field(int, retval)
>  		__field(long, total_scan)
> +		__field(int, nid)
> +		__field(int, retval)
> +		__field(unsigned short, memcg_id)
>  	),
>  
>  	TP_fast_assign(
>  		__entry->shr = shr;
> -		__entry->nid = nid;
>  		__entry->shrink = shr->scan_objects;
>  		__entry->unused_scan = unused_scan_cnt;
>  		__entry->new_scan = new_scan_cnt;
> -		__entry->retval = shrinker_retval;
>  		__entry->total_scan = total_scan;
> +		__entry->nid = sc->nid;
> +		__entry->retval = shrinker_retval;
> +		__entry->memcg_id = cgroup_id(sc->memcg->css.cgroup);
>  	),
>  
> -	TP_printk("%pS %p: nid: %d unused scan count %ld new scan count %ld total_scan %ld last shrinker return val %d",
> +	TP_printk("%pS %p: nid: %d memcg_id: %u unused scan count %ld new scan count %ld total_scan %ld last shrinker return val %d",
>  		__entry->shrink,
>  		__entry->shr,
>  		__entry->nid,
> +		__entry->memcg_id,
>  		__entry->unused_scan,
>  		__entry->new_scan,
>  		__entry->total_scan,
> @@ -504,9 +517,9 @@ TRACE_EVENT(mm_vmscan_node_reclaim_begin,
>  
>  DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_node_reclaim_end,
>  
> -	TP_PROTO(unsigned long nr_reclaimed),
> +	TP_PROTO(unsigned long nr_reclaimed, unsigned short memcg_id),
>  
> -	TP_ARGS(nr_reclaimed)
> +	TP_ARGS(nr_reclaimed, memcg_id)
>  );
>  
>  TRACE_EVENT(mm_vmscan_throttled,

