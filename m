Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92675F9D0E8
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 17:15:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C338C6B0088; Tue, 14 Apr 2026 13:15:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0B8D6B0089; Tue, 14 Apr 2026 13:15:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD3AC6B0092; Tue, 14 Apr 2026 13:15:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9DA586B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:15:16 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 447FA1601C3
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:15:16 +0000 (UTC)
X-FDA: 84657812232.08.BC41B7D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9DE2DC0014
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:15:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mpHF9b42;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=PzsgxuNl;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf28.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776186912; a=rsa-sha256;
	cv=pass;
	b=qJPwARf/h6yeiktqwfbw9SuvPi1TTVqIkbG65QyAWcFBoeM7JVGJI0HL8JRukMEfND2Jqe
	uNOYhHk8muFWfUEL5cyhyci+dtvm+mA7uKgSUkW9t8zcrmmM3g8Ec52ps5BG/9r9Mi3R70
	XfqmIm40O2xlDwc2BgjdW0ycYZaW0lQ=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mpHF9b42;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=PzsgxuNl;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf28.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776186912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TnDs3Z/fjgqr+roYKQSud3WzIMRpBO5Lw+uaTZB3PuY=;
	b=MPdDBjAzOI+nL6SrEVagbjJOFglcOp79fl8i0sV8ADFfWB1HoLxTlNNvm0Kr9RgohHcERZ
	lH5nVV/Q+ZT+Ew2e16omJdsKy3SBkmuCxGE5XFjysSHjBcSaTH+6heqpLVPnPdMncDa+xU
	5qdYuUqV/oJo6uj7qAx2cePhM8Mt7eA=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63EF24pk1674022;
	Tue, 14 Apr 2026 17:15:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=TnDs3Z/fjgqr+roYKQSud3WzIMRpBO5Lw+uaTZB3PuY=; b=
	mpHF9b42xladI914oP+5xk3RpRZqH4an/gus/4SznCUjmH8gHLMVjcmSy1JIYWAx
	IXC8ffqcclgO2IZKc2cJ3B5LaQSp0wN4YxkGJSGuy7HaicFRZfVHaZHFjI6PLOv5
	z84ADj8enmztQU7dY7kXWq2tdP1hBvhmD6xlki9AGkrxqGlRuQKg4zTrRoT9wy9I
	aKKg//DgYbBl3vlHOZQe5Axcbyn+ZeQXtibs0Neo26qfY1Z3NNS+PdNFnnwvROT+
	TFfTS5LuJtntOsoRa6aGehc92psW5yb1ky6ToFfsKqAotIZODiQw7BqPiD+r+0bb
	T9LxB8k2Ep0n989X49YxiA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh85jkaya-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 17:15:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63EH9NMR031227;
	Tue, 14 Apr 2026 17:15:07 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010055.outbound.protection.outlook.com [40.93.198.55])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dh9jpj1ur-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 17:15:07 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qBDxRrI/AVp9fgbRPd6Qt8Loupr8yDSboWecd8u3F1bQB50IKvZc6ZYGY3qqGFpcjFTW1EKn+m/+aX3n9QuzOGZ/mnudViTkNYSI6gZ3+3DFft/4fIwe9W19H7Qkq+lrlz+Xn2XrR79dzhbW58LLhdekXIhwqIwG2G7WeWLxvxQkHB0CDF090TaKuuVR5xzQCBGJwdOB9lu9SX9fOSz7VuNiJlgZDuwMgriePy6nXkWCXc/0cTIK1BMaYcti1jvHhoGjRazpBQqAgQkUZhSqB0o9hEgOdHfc1mRi9CA9SX8Lk/98rbybG4No30S6VTCItZsrILqYjk8faJQUfkabOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TnDs3Z/fjgqr+roYKQSud3WzIMRpBO5Lw+uaTZB3PuY=;
 b=y6skRgL7EaV72OHnQ4IGnWCaQRtyGRtgAWUuO+G4i1ZaP1Injc4TA94d1WvU2EtZlzN2N2lw5c/qGf77EEOS9B20P4D684Y978b3NqGT2RknhEhNDXUz5O3mc0RtAhBkUmS2ErO519NBt8DRsit6HA3mp1igEcs4jmawCgp+/j68E+9vQtV8JUQ5f30nAAo/eEzYEdjwHIKitkJgYW6EbZRK6TB/JKn7qniq45TnO+N9sywLhmEKLf1pwL43YwX0ru6WoLJ4t7gCORv/eERYH4znsvsTh6ILWuGi2vzg5TrU9GAosX/Yv2/7k2sSjUrwK3VtT5/jhvM0RFW/IA+ZOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TnDs3Z/fjgqr+roYKQSud3WzIMRpBO5Lw+uaTZB3PuY=;
 b=PzsgxuNlkEM3/ONuuyQCEC2Y+BFSRu51fi4CkQxd0DiaF2S1M8UYsclIZ/JqGBLJikVIuJhHlNXi0Hd1caiIknqIZDdXywtGRymc+8ye74pgbgW61zCEe51cBm0QJI+l6Fwefw5GWrIpAriZ2pQaxq9CijaHzt4lJ3Uxu3IMQXg=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 SJ0PR10MB4622.namprd10.prod.outlook.com (2603:10b6:a03:2d6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Tue, 14 Apr
 2026 17:15:02 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f%3]) with mapi id 15.20.9769.046; Tue, 14 Apr 2026
 17:15:01 +0000
Message-ID: <cf9b3f9d-99fe-43b2-8dad-10fee84dcad1@oracle.com>
Date: Tue, 14 Apr 2026 10:14:56 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] hugetlb: drop vma_hugecache_offset() in favor of
 linear_page_index()
To: Oscar Salvador <osalvador@suse.de>
Cc: akpm@linux-foundation.org, david@kernel.org, muchun.song@linux.dev,
        lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@kernel.org,
        rppt@kernel.org, surenb@google.com, mhocko@suse.com, corbet@lwn.net,
        skhan@linuxfoundation.org, hughd@google.com,
        baolin.wang@linux.alibaba.com, peterx@redhat.com, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260409234158.837786-1-jane.chu@oracle.com>
 <20260409234158.837786-5-jane.chu@oracle.com>
 <ad4Og_719Yq4yshf@localhost.localdomain>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <ad4Og_719Yq4yshf@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0200.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::25) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|SJ0PR10MB4622:EE_
X-MS-Office365-Filtering-Correlation-Id: f982a8d7-757d-45c5-d694-08de9a495cf3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	8EFhcyxyJBOC2YX178/k+gOE4BuqcgOnupFVP+s/QNOJXJrey1HiPeIQ/3XU0zmFI6Nr126N9RSO84apPsikkgmPdcNZFbW/NZ4HX8T53IHOazfJd2lk5TxE5Bu+q8LfG22ynUrFwU5+SgnOyQCyiCMeh/aNE4LwLriIiU2qVhRA5Rvfe0aQr5Asxdt+UnE65PPAdYDXdYTOQ1zxvNwy52z8RTTQe+AVkEpA1QNhfZ81Jjo4aMnAcV2icngbmesxsB6O27qBoS+hETOPNiWv5Mpb1q1zUFUjnlMYhhNaX7lSuLFO1O0X33TMTz8ZEwPwp3bLrDuwbqEUomLEwv0txVJOhviR2pJJUUbpiQKo5SNJAZ0qzUQJpAJdxxAlkH2so4S5/Xnd3fkf5WFHUuWwSKjLchLWrQuaRueYepaENQJNyL1RoVvB1yFdfwUuIo6+tSV8hooQ0zN9lv0v5AW3GBRLqmfvV+Xrf0LtM5q0m4957/KZyUYrxkSdLG+0KAH4AV1tUqlGH7Ka9uzS1KavHt9q+hWA3GiBQbySPcfDWR5bTixtss9l14Sg6X/hklhT6dgkjev8DfjU7GYsdFmhB5pqqZGZb1UtmyIwmivQeSRHlf8VfsrQFc3DfIOrdQNNWRxapmjBnjy4yxMZcZaf7s3LJwWuWb8QOIsJsb4p9iqan9nrbyQ4enVZZmQaZK3+bR36xVwMMiByfG31GBdQ9KJwNVPyx2ULeyakBom6CyY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?emxMY2poK0dER0JZZlZtd092MGZvU2lHM3gzank2U1AzeTBqUk96N2NPMWlv?=
 =?utf-8?B?VmFYZ0JMWmpJTExRNDBMdllHODNhTzJJWFcyNkJUSnNoSm9INXlPWUh2VzFY?=
 =?utf-8?B?dXR0ZC9VaTRTY1hZbDA1TnV1dGxFcWlOR0UzdUR2dFFzcmJESWVyUlErZkc0?=
 =?utf-8?B?RWxYNnVPMGx1aEgrZlRQRjhGaE0wZzNGeFp5eTZ3WUxPMHA2UzA2UXkwc3ZX?=
 =?utf-8?B?eG0vTU51aDRlb09jdCtMMTdUQ3AwNnF0YTdIb1VrZFRzRzlFSWZMRWU0MFl2?=
 =?utf-8?B?WThmMVU1c3p0T25rb2lnWk44OEFMTkZaaE0reXUyL2QzV0ZVSVJxS1NaV2pO?=
 =?utf-8?B?aWtqVG9OZFdYRWVwUE5vRnRydUVRc0d3cjBzWUtaYW51K0lKQmYrSFYxSGxE?=
 =?utf-8?B?M1JNa1NkVFBrTW9mUGxCS3RvSWh0VUYvUHNBdDIvK0Vpc2h3alNSdk5RbXB3?=
 =?utf-8?B?ZXZqbDRjSEtLN01tUmVkVHZTOTk5RlpYaTNQR2J3TmFFaUdUYWdvd24yTHkr?=
 =?utf-8?B?L2s5ZXVtNDFRQ1dBeVQrT0Z4TWEvREk0ZzdGS1RsRUozUFpnV0FoSGwraG1V?=
 =?utf-8?B?TGI2SjM3Y2ZVZXJVdUNRa0NKZlpvUnZ4eEZkSXlPelFOVEdTQ3JHMmxkelRO?=
 =?utf-8?B?Q01iOXJtNFg4NTJocmYzcldXbkI5TXpaN040WTVtK2lReTBtYWloR245dHl3?=
 =?utf-8?B?MWY5QU1GclFXWjJtZWwzZmxIMHlCcmdCK3p2S3VyeDFNQWUvemVqeHl0alRX?=
 =?utf-8?B?OW1YbUw0WVgyUVBueEdBRitWalgralJ0R0R6S0NNS1J1NFNFNmtYS2JtVEtl?=
 =?utf-8?B?Rm5JQmptckN2aWgyeE1oaWl4Ulh4RzBCNmZZR3U5anRGc1l6TEpmVUlaOU5i?=
 =?utf-8?B?cWdnZHBCZXRwR084ZlRnajlXWDJybFhPUVNkdG9uQVNzSnVsdnh2TFFqQ0Rm?=
 =?utf-8?B?dUZPTHpMdlkwYnVGTW1PRmVickpvQmhtZzV5UmhEeDBnV2tRYURjT0xmU2NY?=
 =?utf-8?B?Rm5kK3o4L2FBUXA4KzhZZklsWWZWZTFGV243QVRKeVBiZUtpaUUzekpMSVQy?=
 =?utf-8?B?UEloL3FNUGN6ZVhHc3JJejVBL25iOVFpVGo4MS9EL3kwaEVQalBRNkNZQzFu?=
 =?utf-8?B?ZkFKWGR5elRGcnRrTmU1Y0tCbFJ1VXd0b0ErV1Z2QXNNK2xBc1o5VjBoSExr?=
 =?utf-8?B?MExScHpzOVNoVlFzdGFORng4dXJiVDNWWU5pWEtuVUY3TGxnclE2UjBNWGNW?=
 =?utf-8?B?UHYxTldGZklvK1Q1dzUzZ0lWSUM5amhyaTR4bHdtZ0VaVldDeDJUY2Z2cnAy?=
 =?utf-8?B?M2FyVllKdjRuWEkvVEc5SU53blVqd1ZENjNoMmlSZC9DeUhzeU56YVg5Q29o?=
 =?utf-8?B?S2toY2JNOFM0Y1l5b2t0aTZodGVZMExRRnpVd1BBRXErSTFYR1ZZUjFHa1pX?=
 =?utf-8?B?R29vYXlqM09xR1E2VjZaZE5iZVFYbDQ2MVhDMFB4RngyN1FYWEF1eFlwTllp?=
 =?utf-8?B?cXduVHhTSktXM3dOODVmdmpZNTRXTmRBRm15a1h3US9hUkxGUmRQMFI1RUpK?=
 =?utf-8?B?R3kvQzkvQTQrblZJSkFzcjBrWEI4NGw2WVNva1M3SVVyNklxYzRLWXNWMzdr?=
 =?utf-8?B?NmJ1T2d4U2ZqUmk5cmkyd0xNajhCL0NjUkV4em0weU1wYnRTdnM2NkZ1NVZu?=
 =?utf-8?B?a0NrOFBpTVZqamJ2VFlxYUhsdnhYZTQ4akFlN0VHRUc5clo1cWNFa09MZWoz?=
 =?utf-8?B?RE54ZGF3VktzWmhMOHRWOGNqQW52U3FzRXpCOS9Jb3dJVzlnNzI0eXhjSHVB?=
 =?utf-8?B?dGlvdVZzR3Y4MmdGNzFJUFZnQlRveHpZR2FnWEJGcjRaa1A2UzVHUWpYNlFJ?=
 =?utf-8?B?WlM2N3VRTXlHYlFqSUFJUTQzVTNsWDJEYVIwaWtnZGpuUmJjTGZZY1dUSENx?=
 =?utf-8?B?KzRVRFE2V0ZnQ0EwY3BVODNqM0hxK1g2c0cwZkZFZ1B4Ynk4L3E3dS9TZUx5?=
 =?utf-8?B?aUoxQlJhc1lha2NEQWdsY2pjaVRLcUxFdkp5WS9UOGxGZTQrN2JKUDN2OGNC?=
 =?utf-8?B?VjZ6Y2oxRkNVRE9xWXNMUDMwVmFnVWtva2xxei82NzdZTlA4MFJLZUdVanF6?=
 =?utf-8?B?Q2VRQkpuQVYyV2VQL0xnUjcrVmhBbWM0ZVg2MGYyT2NnbVovTFF4aTA5ZWFJ?=
 =?utf-8?B?MVpQL0oyZjV0TDFxdWZuejc1eS91MitML2NHeEVEYkFKZVpMbzZGc3gwV2R5?=
 =?utf-8?B?TG9lZXZJdjkxUTFxbDB0V3pLeFlGMDZvUzBUOXRmSFh6UUV1cE9GYS9ZY1gz?=
 =?utf-8?B?Vll5a1hmTEpTckkwVHhSRi91VHg1djczMTNLWkx2TXdHU1lXSkN4dz09?=
X-Exchange-RoutingPolicyChecked:
	C6EQnNUXbIDgbHnVQRlzHEBT6SBy4DmdYlxcgAtGWSI2VlWEazlawmOJkFNq+Q/eFpbeyI2oe1BNSBw7I8Xr84tAjFQv2L6vpIje4ujGjGoMkbqhGqaYk9rHwSAvxlIX4IEhoCsYD0Wdkw4Es6EZ+s4KKwHY0mx4bQgk9hwTEDCW0XQ+ZZD+IllWSMgcIBDOkvvaT4Af7OgnnjNgkUYJvnJzc8lF5w2+Ek8C7FRdJn9AjssZ+A5m+kcgyI3v7F3kX3a0GmNrCe5ArOHjyEubAae58cZ6LdpJe8m3lNVSRkSXWxa1MO7cvrMGn9YbXCE/IEFFjsXyG+oY1x1hkOTqWQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BVSkWKQuhUyH03MpQ70HEgvjqT1srhCroQdFGb3Ft+kgNk+mLzEaGIvqvs13oNEI04mwfZEeXu6szmFOWQfhw1OJ2yzeTOMdDfjNF7MMNBgrG62Y1Dv/uJgn+j6Glm9+6VCVr86yZN/bq4iGKZwrJxN4UcBg3rk1XSKu3nmzTZBb903XpG/F/Gyjmt7fBwNC7Q9PNt+qa0rqI1sPeiso4E9eMWBmhXlCQoX9UWPZDvtOWnX7pRCbssCmvhpgRmVTHQRZ7mbFlIXC+M/kQlQUK7NoHlvqHw5bXEbfcYZ59pXwiGJNyNSvclUyG4+lttgV0imxyInKrhtxaVsU28RmMSJeiSJLUjcojNXb31nS8AV1N2ufAYqOOatpvTOLoGW8pe68evWONWs4ico4vY7M5FFLd+VLlLPkQXnpiOSQdEJWj4tWzUcT3bss0ccFXhYuA5bmQ99VRUuQ0hDCqSB3bNw3fNQdp6QLLoyXSwQ3iVHHwPBcKgZpRj4VGTsPjWpEigiN9WlBPGeLbvXM399Y0V7FEzR8qXQqXoRQCDIdbCpKTouj7Ako1PqIZjPCZNc6LGb8Mog04MgeD1zyd4WeHFMbUX6ZGcX2n1Fmulzixgk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f982a8d7-757d-45c5-d694-08de9a495cf3
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2026 17:15:01.8771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Mxn9+kyi6Yqb3smGXkSD/PMTGNWH12LoHPKblMQhYKzs+nw5VRWs/772UtGNDBWKij6TpP2inlX5J4aaPn5TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4622
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_03,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 adultscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604070000 definitions=main-2604140161
X-Proofpoint-ORIG-GUID: IBv9eXWX4b7xtgoRYfnolxpX2X7ErEjQ
X-Proofpoint-GUID: IBv9eXWX4b7xtgoRYfnolxpX2X7ErEjQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDE2MSBTYWx0ZWRfX/qaKWPHjVGg6
 xijl+q0MZBLD9/Num/ppUA87kEbRpSSbfBVAsqhqzaeTtKOofXFlVEXVAPCqvpjKjGK9bbfT34+
 Z/Rd0PjKx7ztCVjyO7TD98wrCbuTJX/PySndbdYNitb4OVUD3XMHWcQ3mqAwvEnmkDqD9x1v6EV
 8wsFRZh1O3o8vciyA3YpzdR0lJwpNi9Z28eANVIhd5Ijg4g7tb6AN5KqsIDhrLx68RWO0IX0OVw
 iAekxyFZ4HpST5YaNYsfrd8eLRA83h0Qz08iN2jSxIQYq0sczANnVRXS3zZ4d6wDTQz2URgRnBb
 RrAL/2gIFr+7Kbp0HjlySOo2cjLsAY97a3foK5iITNQZaZqEbK+tP7smDy4ijT1sUrkdD+JsZgb
 Qu5dtlEWkLbqLR0oDmpJyXsGbTxWxLf0x/k4bGuV2UI/C7osqx6yGlzqOgyxLPNL0m6XfjR/Lgj
 GzxfIlaQRFednZsWdHA==
X-Authority-Analysis: v=2.4 cv=Co+PtH4D c=1 sm=1 tr=0 ts=69de761c b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8
 a=Aoxhh0V9jOZzV2ttS6QA:9 a=QEXdDO2ut3YA:10
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9DE2DC0014
X-Stat-Signature: gqnozgun6ti9xqdw3pwnwx75j635qy8i
X-Rspam-User: 
X-HE-Tag: 1776186912-921530
X-HE-Meta: U2FsdGVkX19tryJl426vIRaMwZ+LikAzTJAcfdJtmqhSiuYFS/7wMgRZ6LTxl5//z9yPWEwRzAl13L6bKFQCvDv092/wToQTuRA683Nat4P0tk1o8XqODG268yuMi0BB+jgqMhiML6jqoUEOMXCjKNG93MYMmBQa4XQDukW1ertzwW85pGG94FB3xLwXfb3NP/tMaoCm8C2AZpg+tf/oPSfDoPuhQllnX79ZFv2FdDTDjevKSXauGsIZwJtHttt4/7R7pE7r9xZtOKp0iAEOktHwLGW68wHBWT02yD5xjyXaUzXkeqyVLF8yLygW1E3Kr/ukF6mK3LUcQGGkDpEtOwEujMifHqiSJ7IkDRUUVP5TaMsTF40OPtVEZD0QpHI7cVal/DwlW91gv+Yr3f818GZAr4V/kFdc9MLZg+beOh3GyWc/tpGJCFNYG7CNBVrm0WsVbqnqmcePAaNkebmpGRdEkLgve8RQYW3VZPxY8qkK0PrhmTH1Q6XfXkHIKxustGPqMMYZCoUvFbVpHc6e02U7n+3JU0B0VVRCY0xBtjQ8kPWgQXNt6Ic9T5iMlNNWT2k7+MAgTILA2QTV1z1RVpDsWVb6S61kIEzp8IAxx27Gin5PcH5LgswurTfWJqbdzsRfPKZHjTh09TWAVvI9AH0m4BRXagJ7T21rMN3igIMWIFSK9XtBu7SLjW3/VulA1/DDVuwc0gSPDVvDg+3H8IaftmntQIsT5sgAtOGtD2RVSKqvpnC2OkVpFlAhnQU0vg0kRcTcIzl3qlC267+FYqjpN50PIx+NXKK8NFd7Hlmm+qqPcW8+i4bFn709/U0uhXQ/I8vj8heuWCzeNk1taVyIAjPgFSQiW17+EZmjXqRJeihilMeI0nITTI5ZCZesmRHPKTfOqhAeLoZnoEisrxBlnJUChOjLmDgiC28Gdk6bly4xRJ7k4w0eIYQVcb5Ag/qETNnrcjvl3CBfs1E
 rODi2T5O
 F9PtDj58whqrEAVwGhYoeA9Kgk2zYI7maLPuHUJmr3CCcNNY7jjey8DIylhI4oxulpQb1I98iJyrww0AlkJR+uMcakBDH3/0YqmR4yiJrxzzxzaHci8VU2EuG+oV/HJEjWy4o2TG03YBE7iFDz2msmPrRBjfP54YlJSc8mGUbvNUWuPHCVHWjpSmw4SXowGzo5dMZ8GIKH2EfXqNGPAMui0Gr485S8atUl48dhjhLGvuo0+33YQo1eInH/WmHq76EeQTUwqalSkOAKxyOYxjYWI3+98xNWWcb2YnhEXY8OCWsxpqxtui4cVvVJP7XMlQTb/z8P0/+PwXgkz5D2DrMG49hmeS94zCHycxg+0RmVpIs13QimNpW8zY+dS+PqOJIYMrYRRTOH38MihqMjsKVtfiPwAkWlWWsl84mByZcZ8mnmmNlI4MjonKhqdG5KABYfpr0CQH+/DcShAgzBzO1LJlDSzJ2jrr5LkslnIpDeTqfPQ9cDu4In9MTBZKhnRANAROK+e91NkqbHUiFEFcWUUQ+hEOEMBTwMAZJ+4hdA3E5gAHdFuFWcUREKySas62bDI2kS9/vSoZv+ICRTRisGsI+t9yFMiz9h7Ae7NwR5dgKPXWL4zzfwbwXzfeFF9yH7SvBybGjcVrbhB/e3lF7q1zItLnzi7ynkbcoyc0JHGBMm8wlzGt6naxTRf0dZLYlYhZCE6frENWRuXmp5zeI0KwOUueYtGg2/6kaiY1R30EvN8w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/14/2026 2:53 AM, Oscar Salvador wrote:
> On Thu, Apr 09, 2026 at 05:41:55PM -0600, Jane Chu wrote:
>> vma_hugecache_offset() converts a hugetlb VMA address into a mapping
>> offset in hugepage units. While the helper is small, its name is not very
>> clear, and the resulting code is harder to follow than using the common MM
>> helper directly.
>>
>> Use linear_page_index() instead, with an explicit conversion from
>> PAGE_SIZE units to hugepage units at each call site, and remove
>> vma_hugecache_offset().
>>
>> This makes the code a bit more direct and avoids a hugetlb-specific helper
>> whose behavior is already expressible with existing MM primitives.
>>
>> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> 
> 
> Looks good to me, the only thing is the conversion to hugepage units
> which may not be very clear to the casual reader, but you already
> mentioned that you will add a helper, so all good.
> 
>   
Yes, will do.

thanks!
-jane
> 


