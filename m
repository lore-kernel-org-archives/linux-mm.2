Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AEBBC87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 18:15:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9E3B6B007B; Fri, 25 Jul 2025 14:15:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A281B6B0089; Fri, 25 Jul 2025 14:15:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A12A6B008A; Fri, 25 Jul 2025 14:15:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 731B46B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:15:45 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1DB4A140902
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 18:15:45 +0000 (UTC)
X-FDA: 83703590250.05.43801F2
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id AC9A520016
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 18:15:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=b6GJhuQI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GT9PwyIo;
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753467341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8tkVsDqibtcHuJvzfl+rv3TfW9e89c9RjBvzK+Ag4SM=;
	b=PkNwBf5EVNj7qezMRF+0iKjWDrZB4MJkDFomy2oRmv/7dhW8iaznRdylt4nFajKk7v+7UJ
	NYf/8Q3g9elIgGoMVJO/JU+SI00ceD4kb/rFvqMRf5QyUd4Lw8l1C1imnGutF6/l1p/pEp
	NO6R0CEzCINKM1cTaeHbfnTm7BNKzV4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753467341; a=rsa-sha256;
	cv=pass;
	b=dvWRJfdyy4PtSJeSyd0XXqQ9Pgkia04fyUkDj6c8oZsa3SOkdr/HfxQFNmoOvBVJZIhLal
	zGsRxKf4Mi4zaqdkAXXO318V/jllrHckVuGzkMH4OVLs3nbbzgWdnORcnRcVUyANuOpGRq
	gwBD5u/EEa9SU18zmcOIHBCH/D7vPww=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=b6GJhuQI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GT9PwyIo;
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56PGC6K2007398;
	Fri, 25 Jul 2025 18:15:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=8tkVsDqibtcHuJvzfl+rv3TfW9e89c9RjBvzK+Ag4SM=; b=
	b6GJhuQIKUSHPOHSyjcuZ0GyyqhVj7bsw/AsY51DOnZw1/+oU4RGtIfriz36abG9
	wURs/aFOCc0DfqxHa1+lN7gCsmOEZThzzgjiuBwibwKmGsG/JRN1ymLjb3lZnu1U
	6ehhiysTAilFi2SIs6W1NSlN/863XXU28dz7giWAz8TNfzxQjsbUoQojVF+NrOfO
	Wi2YQ6thnPgV0b/EAleIao+5tN/+Pm3tX3CPnA2YVWEvj/Z1/YcUZ3DRHM0/nwK6
	jbOPtUk05RKi2bGMzpwEMmcKysbeszrUl2q05t76F2eA4eSCp2NzrTyCU7fU0pcb
	ImMcGIn1HAvcX9b2HGwk5w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 483w1k9mh4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 18:15:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56PI9RjB014423;
	Fri, 25 Jul 2025 18:15:35 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2050.outbound.protection.outlook.com [40.107.223.50])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801tkqjbn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 18:15:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kMf/IfqFkXXhV5Gfg+Sms/Lb9bJvDGOlht8VYWlUgZvoJMPfuB7S930+SMhjA2kQ0XLw4xde4TISU/wZrXlEd4hlmnaiummEo/q1CkNaHxTRTEPK7p+FYGxvAxx/N87TWPMzQlokYOuSV1gp/+KpP50d6dihnloA7y46CEAxgP5DXNdDjYYZXMY4so4Q7rx+lPpdHU5gg+YL3uxNvGIKP7jFtq80f/2suUzsmG9HX/Tn+EV33ldPxqU3JTHtlncwTiqkeQUjoHToVA0Q7sXTThxJdcoPVlH//bHpfVfM/50ShT5NQoXMC0mZeG0dtEVRtldxjJvYuX/BvNKFABsRxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8tkVsDqibtcHuJvzfl+rv3TfW9e89c9RjBvzK+Ag4SM=;
 b=Rih5xhkS1choc8X73Kg1lEjDXg+Mu65PANlFYzJWCPJ/OXE9asUkYzOY0ZCS7AOYfY4NQP7SE53Fw/H+o4iN/ocDbBMfxy3gyyS3hyoSyN2dAi4iHqBRXjngyI5yobxLltmTNx7/nFHgKhN5kkKgS6s6f8wt4fbXwPQuiaXJ0q48jjNVfAiuvIiLNkWqJKRHRmNuk67CcJ6oCSyegovV0Bk55/iWqi4ixG/JVzQhfJreoNeioseDBOpRhYzDtIEwf27A1MtG8Ls4b758tYT8me7cmYpi4VASNGFWC0f3lXuen9IGqml/skAKcw9VHEYZVJFppKnd4rSNQcwYHOLcTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8tkVsDqibtcHuJvzfl+rv3TfW9e89c9RjBvzK+Ag4SM=;
 b=GT9PwyIo3mAm23pLwBbxE98px49qXgRp+7o5fjIk6Z3znN/kGxpF9KQLZM/KHmz/hMBwoV48Wm3ialsWAkp6fv3VAruOSh4FkLYUKQE/PJnMGqdLyUJuU+mQZn8JH53dRHd+OBUNzP3ohuRTDjUnn1I83wVmSs0nxNlu/9ElUWw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA0PR10MB6913.namprd10.prod.outlook.com (2603:10b6:208:433::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Fri, 25 Jul
 2025 18:15:32 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8964.023; Fri, 25 Jul 2025
 18:15:32 +0000
Date: Fri, 25 Jul 2025 19:15:30 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Jeff Xu <jeffxu@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Kees Cook <kees@kernel.org>
Subject: Re: [PATCH v4 4/5] mm/mseal: simplify and rename VMA gap check
Message-ID: <d1fa842b-ba0b-4bb1-8d0b-cccaeedadf69@lucifer.local>
References: <cover.1753431105.git.lorenzo.stoakes@oracle.com>
 <dd50984eff1e242b5f7f0f070a3360ef760e06b8.1753431105.git.lorenzo.stoakes@oracle.com>
 <CABi2SkVeHWt+SKWWodXUNhXZi1Wv9YazEOGWEUJLvgPbopqBrA@mail.gmail.com>
 <ca6af6bc-1c5b-47fc-a00b-11d46867b5e7@lucifer.local>
 <CABi2SkVRmuRp459g0RBwyTbd5dACwe6AiHrpxYuPXj41MxHp+A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABi2SkVRmuRp459g0RBwyTbd5dACwe6AiHrpxYuPXj41MxHp+A@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0536.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2c5::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA0PR10MB6913:EE_
X-MS-Office365-Filtering-Correlation-Id: 8573f32d-a89b-4d55-c0e9-08ddcba73e6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S1ZUK2ppWnZ5Q2xMbWJHNktWTlZtblUzQStMY2hENWp2cEZDYW9EbHk3SzR3?=
 =?utf-8?B?OW82Ty8vQXJEWUl2ODloa083c2dBS2xqdzhBbUpZOU9Kc3d3WGh0TCtUTDA4?=
 =?utf-8?B?OE5qSVZ6VHJKN01ZU2xHc1JGRXhjaENXTWZzUFZHV3h1T3FNdEp2YU9mOG9D?=
 =?utf-8?B?cnFIbHd0U21yYm84Z05mdnU0U0FXU0FmeEhSNDloUlFFamFPR1JFQVIvOTFa?=
 =?utf-8?B?dURiYTZVZ2thL2N0NGNYQnFhYjE4eWFiVEE4T1prdzZFSmRjTGJuVDgzL0pv?=
 =?utf-8?B?WVk2Vml1S0xOWkU3UWVoQi9vMkFPeE9WSmRUUUh0MnJLZE5ROHV4QmlKWHYr?=
 =?utf-8?B?eXJQY3Jjbk14elU4SDZmektaMHczZlczZnpDdnNlK05FZUw0bE0rQVcwM0pK?=
 =?utf-8?B?eFluNWoxS3hRM1RURG9VYjU5aGppK3dUQVRQa1ZwWlJRVlE2MHNNU1hCcnpE?=
 =?utf-8?B?VFkxYUJNRXlZSjY0NWRHK0hOUjhoM2o1Yms1Zm1RL0hBMGwvVlY2di9RbEN5?=
 =?utf-8?B?QzlqYjMxQUZTZTNtTmlId3FMR0xYRGxuYjhUc01EbXYzaTNPRGx6SXB4TUp6?=
 =?utf-8?B?SnFtYXZNTDAzNzcyTVN6ajRVR2xSOHN2QitCNVNMWWdiUVV5UXc4aWlZU2FS?=
 =?utf-8?B?OENMeko0MEtLWW5xbnBOZHZidWpvWG4xRHBGS2tnUnVTL1lxMHFKWFQxek5T?=
 =?utf-8?B?NzZ5L0tOOFc0c3NPd1VZZkFXUXpHN1VEK1MrZHlYL0JNMjlNU0szeVl3Nm9l?=
 =?utf-8?B?c1hYVEtGZktseHpZenMrSmx4bDArUWxUYUZlQzhLRUVMQlZodnJrR2RMU2Ns?=
 =?utf-8?B?cmFET0wxQk9SUmtFQzdHVU9RdUkyVlFNdmtrL0M2NlhZOXJVUUVRL050cTE3?=
 =?utf-8?B?eHB1aTM5dmJmUnl4Tm4yVGZyVnkrdSs2TGxUb241S0ZiVUd5RjBtcUozYXJO?=
 =?utf-8?B?MmxyVVA2UUtZaU1UQndVMy82MkdXUGN2T3hCdkFCaHgrUm9mbmUyNnJRSDR0?=
 =?utf-8?B?SU02NEtuR2sxWk42enY2dlhaeEJ0dmtKOEgrV0thOHBHYUlEbHJGbU11djc1?=
 =?utf-8?B?RkNhVlAwWG9QQVJuTHJPUW5XZThST2pOelh6elFOVzR5alhjaVYyamxQam1H?=
 =?utf-8?B?YWN1bVhZa1hpNTdwb3krSnZSRDVFNm5ORFEwN0s5bmJvRXhqZTJxbG5tTDRi?=
 =?utf-8?B?V2dYcDRjVXhnZTlmMEpYVGZWYWw2WUF5VjRxWjBYQlhFeHhKNWhZTld0L2ha?=
 =?utf-8?B?M2IyaHNGcTdGajhCTVdjTkhwTXpLc0ZSakt6UGhGWFNuZEVkODJqVnhlV2pV?=
 =?utf-8?B?bEVIL1lsRUZCcS9mTkJDc1VjZnJwWkt2c3FWcjM3TGdFWXhyWFd6aWlaS0xY?=
 =?utf-8?B?eExmd0h5WFlJMjJUaXRqWnJKTnV4eHE0ejhrOEF0NXU4bllSZE1md0dzQ1JT?=
 =?utf-8?B?NW1EZjlYQlJxK0Z6cEZGWUtJNXhnUGMvUngxYlgvV3FSUzd5SlozL0ZGVjQ5?=
 =?utf-8?B?ZWdvZG9yTkM0Wm1jcU5KTi9wT2tDbGxCVmRtS0dTS2tKb2t6ek85TEdVZWxE?=
 =?utf-8?B?YUxQWVRoUnlYb04rNlh0Nm1MWmpCQU5GblVoZ2VCd09GazFsOXVzZXlVVmhv?=
 =?utf-8?B?QkU4Z2tQVjV3bmRqODY4QXNmZlZINTlueTU5TkUzOVMybTlhaVU2ZkZnZUNl?=
 =?utf-8?B?NUZoK3RXMmtRYnFKSWhjcUk0bnpEUzRGbWJoM0dISEtpS2QzT1pmUkhkMk55?=
 =?utf-8?B?SVNYdEJaVHcrR2FZWVZBYUpOcFYxdkdvT3ZwSHVFb0dicTRZQjZTT3BUK2p0?=
 =?utf-8?B?QkJhODh3OEM2N2dTQ0dPVzRMeGV0Z1MwZmZUQ0ZwelIrdElSdVNXTTJFK1I2?=
 =?utf-8?B?YUNlNVFIMU1FOHpCdjJBK3FpdzhtYWxUYWF5NFg3RE4rdFlWVjJYbU1BNEt3?=
 =?utf-8?Q?96HI947oOVc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RTVtdnkyaXM1bzZpOURSUnZ5bmcvUlc4S1pUQ0lFNzh0WUw2WmxnSEpncEhp?=
 =?utf-8?B?YzlPVW1wUjlKMi9BNXNWelNna1ptbXhkSDJKOGtaQ1B5cGNzeWIyVE1velpw?=
 =?utf-8?B?MHAxc3gyb21YNUV6YW9RY1NyQzJUK3p1NXlWdFYvOVNtZDNyWUl0UnhWbTFa?=
 =?utf-8?B?TmM2d2R1VkE2TFBhcEN2TVBKbTlibXE2aENIc1JodDhESWcxQ3RnUFNKa3Jn?=
 =?utf-8?B?eW9jNFVQb0FpSUtNWnE0MnUwdUI0eDZBdTRoYmZ2SWM3TmRaNTJ4eWxIWkE3?=
 =?utf-8?B?TTRwWkZMTDFFSUJLaWtlaFRjTjB2TmdyZU5LdmVlY1RSbDRNUy84REpvZGFp?=
 =?utf-8?B?Q1RnUXZ4d0ZmcGV4VGlMNEdHQWx4UzZTRHBDdTQ3NnI0ZzdKYnhLcU96LzJY?=
 =?utf-8?B?V2lEQ0dsY0swTlJXa3FnTkpQMHNrTWd6K251RHYveVU3eDNjV1RsVjdZYmpH?=
 =?utf-8?B?ek1qbGVNSm9zTTkrV0ZzdVR0Nm1DVC91WGNGcW9ET2NrdjR1Q3dkeENMMWNi?=
 =?utf-8?B?TmZjTCs2TUxud0NRQ045RVp3ZGJBcUIyVFBUZE83eUNrdmJGMzBIa3Nrbjdl?=
 =?utf-8?B?L2g1TjVWU2hpM1l4MW03V2lRUHBaNVYwTWdVS0dSV0Q3dVdpWmZUT2ZBMzgy?=
 =?utf-8?B?NUxBSFk1RkRVMTBFZmo3TEc4SkFFSmQ5a0JnemJVNWNMV2dZVGNmcHJCejZR?=
 =?utf-8?B?aFFLZXVLeDJqZVNaRllGMW9VOGM0TktVZ2k4eU1KMlpHK1lYUkxIc2lKUHA4?=
 =?utf-8?B?eVFieDlnbmtSY2NPbmpPUzVBUFczczVvUHNPSGhTbkNURFBjb1BmMEhjV3BN?=
 =?utf-8?B?am1xamZOd3NXRkVlcEVZYzhmclp2emV1QWU2KzM4enhsOXdmZWZNY2xsN3VM?=
 =?utf-8?B?SlA3cW9SenFrclBaQlFUVktGOWZGckFDQ0I0M1ZNU28wL0FmTXlTeUY1d2Fi?=
 =?utf-8?B?T21wUFArOWd0aGMva0NmTWY0SkVCYmZ6ZktkdDV5ZHZsYVRoUThFZ3E4OUF3?=
 =?utf-8?B?ekVVNHBPUS9qUmRHK3ZzMFdxbWdqZWYzalNpcFVkVDQrK2NYM0h0MUduWG4v?=
 =?utf-8?B?bUlSUWVXdnpKR2F2VyswK05NRHhmZjZCd09Oa3VtY0ZXZXpFNHNuUnNDWE9j?=
 =?utf-8?B?MTRDUXF0cWM1aHJYZ3NOaWNDZXFFTncxWTlEYVF2aTFnVW93ZVovMFFvMzlM?=
 =?utf-8?B?WVd2Y2dieGJzYlQ0ck5LVkNZRmNoUkkrV0dHRzllc0VmaXQxZzRpUGlDVXBX?=
 =?utf-8?B?OGt1TzBKTnpoN3F1M3p4K0tGTDFVSG1hMVNxMVpBaW9HT0ZDVDZTVzdaMmFI?=
 =?utf-8?B?WDl2VkVVb0FvOEZRRjRJeGN2aUt1R1pFcHBrK1RMSXo2OEhrZVo1bFVEbmw3?=
 =?utf-8?B?OHdmZjhkOXBlWmI1NGdNNlVoeUM3bytZTXk0c1kyb1BpSVpqK1E0cXVEUm84?=
 =?utf-8?B?bXJJUytuWnFia0FScmE1bFJTUnZvQlQ0WGhyY21lSmJVeS9lblc4TmpldWls?=
 =?utf-8?B?djdMMzhHSGpnZGxHcE5PQk0yWWpqZGdObEhtN3Y2NG1aSGpVdko4M3A0cnpC?=
 =?utf-8?B?eFdmRGlBcTc0VWtraUZ2OGJzK2kxZkhpZWZydFNXNEZ4RlVqQjRSQmNFaXVy?=
 =?utf-8?B?T0c0UHE4Z0VvL1NVMWFTQWVibGlpd1JKTkRlMDk3VTRjWDBHa0ZBRDBtSkFF?=
 =?utf-8?B?TDFHWUowRmNpdGZncXdCOTJ3Q2IxTFlZQTlDYkZZMkdYemhUL1kxL2dqUEN0?=
 =?utf-8?B?bEc4d3hVSkJDZWkxWWpTSlp6MUg4TDMwUXF1aC90UGFUbkpYeENxSXFoMThV?=
 =?utf-8?B?M1dYd0l6UHlTcVdZVlZmbVBqV3gxVGEwc2orQ21ndzhFQ3dKajU1R0w1YTRG?=
 =?utf-8?B?S1JLb1VpNkJGck5TbThRWjNMZ1Z2a3BYVkQyOHBBR25lTmZBcjkxTXFFZFk2?=
 =?utf-8?B?TjFSWFRRNEVMNzRpNk1jL2JOSDBPcFZzbzJnb25IWGhkTEE5cnEzSGR2VDd2?=
 =?utf-8?B?YVBnclkzbVpQSmRRRTFTN1o0YU9YenllTXl0MHZPUU1ZNklXZnJ1MGdFVDBD?=
 =?utf-8?B?b210dGVweHB3WlAwNjBDbUlGYmwwVjZKUUEvSXl6L0FEdDQwUHUzZlRIVEJk?=
 =?utf-8?B?aE5CandEaW11TEpiS2hHeEd5cU12UkVjSlpqZzEzMzFxcjJ2eFloalNYb2li?=
 =?utf-8?B?dEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	m7gmv81T13BikPPN7M3be9WpUIz27ROb3Z0GqF9TQAqFV2YE2sUYEl7wltyI4mjwyp+/Yx7kwaRg5XpkGmx4chydRU+rxm/y/Sv6COdReWg9E42MjbMn0+/EHUGAPAaEt2xbGx8bMTCFcKBbXJ780lSwgg75mQa8ZYjfWcMIU5W5HiqzGhCFQaa76bhx3Dce66UvyUG47TTmy3vl8uAipBzNyUL6U1X4R/IXX2NB1OyGKQPcNeJKM7gJdoa8MJtCeaAon7KrUFUejuPtPwFAG90PShrue2K7M0sDDRXnoNLlchT9BgYymC/e+/+tSTPZl2OgT3Sj9Dj4oBQkIJTxnHXJDMd4UqbNgwa6Mxn/Tj690slczj4M0UR+Tjhy2X2M1Hi1WS7k57OttrBBCcFggjoJAhyM93T3buExoLG7XVo/pBAD74wZPQWe9vAsbGKR/DZzdCjZkJUro58/mr3gsDB+MU32ZvWfYYVsZBfORFrkADLlysKXJHO7wG5G3tJnzqGyP6DV+z2FmbxIMEGh8sx0nn2JpKh9ZU3WoNqkHl5XpFu/3z5iz4NfJ78VsEQ6CxFdZIxxFekTX+SXO0HBmFjGBEN930E/wU6A0kBNVqo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8573f32d-a89b-4d55-c0e9-08ddcba73e6a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 18:15:32.4332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mpYnSOgGC1bZs3j4OLd5HQ/aTkCN05Eu7PaxFom1k0M6+2ieL7qTCuRgQKozfcWxxuEPLxi9hyzSb6gV1T+X3qCCIs/jHkl8eHljXsDWByo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6913
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-25_05,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=758 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507250156
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDE1NyBTYWx0ZWRfX/Hi3iL9h7GPe
 cBH4uaWlTMELM03jwLOIvy44rCs8iBubT4Y/fMGMzB99tERnL2zfPwXLbmRyL3XNKpwuc6OFrpM
 B+YJmxv9n6XJKI9APLJl3L9gIKQdXpR25MtO9Bw8q4Z2pmF3hbG1lY5E3ftB5dNNTSNMpCSHyeS
 BVqIHTjJh7WJXhaG+7sbYWA9D5GS/grrBQrDPlxLDzzQofy+y9++gdZ1Yofpc4n3LhKR71+IztM
 K/v+eZPm4jVJmQB6p7HTwZmA1VPq+ydf4xS6uVBNs1TcK7tSICp+LVblE7E/jAJHkbbW7qLK7lV
 v0KfaOcQvm6ea3Vi9iuFHhZq4jT/q8xcCmKalGHQuhnw0id3QFalOjbJnWmneErdButtg0tBUXD
 T8/1mmUsASSFoLdomvrEtvEh1ditFvYRy0HY73nKCefdc+46W+erizhmm7P4J5arOkAdZx2d
X-Proofpoint-ORIG-GUID: lylX3DKrtd_Q32kQpnj2mcYc5gESguXh
X-Proofpoint-GUID: lylX3DKrtd_Q32kQpnj2mcYc5gESguXh
X-Authority-Analysis: v=2.4 cv=JIQ7s9Kb c=1 sm=1 tr=0 ts=6883c9c7 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=cm27Pg_UAAAA:8 a=e6YWdNooBi0m1o29dCMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:12061
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AC9A520016
X-Stat-Signature: ttwmk4ow1h9frfx6o17yukt9qtxnso78
X-Rspam-User: 
X-HE-Tag: 1753467341-391235
X-HE-Meta: U2FsdGVkX1+CKPKrN/A7G7vS20AsBSNfw12XLQPasYGLvbPtx4hD61ZkY55TjMloL0Koo3tYgJb1kR9izQeLZOVWAN7/l9DB0Iuc03XwUquS7dw6wggC2XyZ8lSkQOXMPfGgCEs4bJyIH0yKQZnJBHs1l++c9u+hUvG3eUFIV8VzqdsLt+An7f7O2vV01lCZXw3SFgGdsYq6OVhS+6MqxQ8n02+tUNRNsMEqGQ13Fi1gNuQHQCaw8Gw9geUvh9Yygq5X/WFvr7IPlC8Ke9I2eTv/Y0w3ztkkbJrQyjgv8hbeeo06wPnQdPcstmHwzgRUFhFAjPtA4qtqWcw/iovLCNjUcilwCw9JJ164h10NempyGp36VXqyo7d1wwgVU9nXCt+WDhE82DP1KXTViJZ9dgqgfU6ZTuYmKEBuRUcHRKled6iouN3jnqzy9rqwc+d0FG9X6lE84njTpQrCpxove9xIjzZj1Jidol4KmnsJH0ruFJgpQYptNe2jtbsU5hx/5x1M5MS3rKsa34RaHIrnDD2kFcDdaL/WI4aljgRT6b9B8AAndAfQYJiQAANxnxD3p9vRyiI5PeGHJ2BGwAW3hrjexfx20YiwO5L2UfBpHYs3tdVErOcNZEC/4GtJqtEHBxBInnDnJ2KuEuYKx6AacbVY7G5OQrQfsVYSjQ/L1Cmv04QCPJE2vdqCNz3y1NoNroiTXswyxErEITdFhi/ZHHmBJw9nLGQvQJRTetBBfFns6p2JArgUqird5bH344fGr4sGwsJLAL04Bii+dXGKT+Rdhcr/7rcSz+jzyZ+7I52OMRZIy9GACiEwjmddUg+qNseyYE6uFPPQZAzbeT00Bx1Tk09CXU3HnN10AxrVct72B7qkcpcSAVn/unMW7TJdNLCN+oXPbwOFOKYJzkqOyU45sSceqJQ4FYJDux5uyN8IshMZEwq3x/1Be8j7h6ZAfHDBCYsbPp8v5GxklJm
 JK+W9iv+
 FMvHPXoEz21+2FeMlyypvmeQ1d35mcIlCuXElloLg0qeAUqwIzLVbBM1aAzedf0KMOAh4HEWudwNXsuRm9UtXNpVeR6xcNkDOmzc48aWUEgTsVvyQu2L7F4xBJ6kAkkkTGUT9s3AQcVqu9EsTFqngmtOjZiM+XwQjxywkU79npThz0fcDZNzPPGNLzRlYaPHuV6HmDsZwt2M+00dGpSp/D4MTayJC5s7l76hi1axTHRhpCas6nkchcWx4qmM2oQ/y92T3gxASnnivkYgeUk7HAzR3WVkVAmKur4s9Bv2/quJz1iSITi+IJk49QXtCC8ZuLc+nAU4gtqfrY0urdvsi61cuQN6TQzvp/rx9ilP1gJIP06wKcFamDJeYeKuOxWL7uUSX+nCErAp1kedTDjyj9NAAcl1SjMvgbf+Sc2uSkqVvKsLNztt5O+fAyKI0yR2sYkh1b9gBK+DY9QvTWaQnYlTmKniYlyKUI8YMKjb3vrQqt5MZR/B/akqi6OsMk4uEDYMwOK3aWwD/ctbgIlWv7yglEcrqGxjWV3rQ0h2MULRPOoU+xvZGX4fnUILrKuNEQEElqWsdeJPsCE91cCO24d/MAm7NXDAVEW0Y0yoUgJ0EHlqDv5JAw7x4UwrtetNFgSw9b2Pw4efRkvgRyw+G+6y13OzNBFm+jxlOya6lIBoghN2L8byj/OYTgwcTClVxg0VCQxbf276O6eoQfs0fJpAqLD3PIzhelz8j
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 11:09:13AM -0700, Jeff Xu wrote:
> Hi Lorenzo
>
> On Fri, Jul 25, 2025 at 10:43 AM Lorenzo Stoakes
> > OK maybe now I see what you mean, you want a function that just wraps
> > range_contains_unmapped() with a comment explaining the 'contract'.
> >
> Yes. You can view it that way from an implementation point of view.
>
> Contract mainly serves as a way to help design and abstract the code.

Right sure, I sort of good the idea, I just think it's a bit OTT for this
check whose contract is already clearly stated in code.

>
> > range_contains_unmapped() enforces your required contract and the comments
> > make it extremely explicit, so this is not a reasonable request, sorry.
>
> Technically, this contract belongs to mseal, but if you have strong
> opinions on this, that's fine, as long as range_contains_unmapped()
> doesn't accidentally remove those comments in the future, which I'm
> sure you won't.

We won't change the semantics without a specific patch suggesting to do so,
which you and Kees will be cc'd on!

I care very much about making sure we get the mechanics of mseal() right,
so I'm not going to allow such changes unless we sensibly reach agreement
that it's the right way forward (i.e. the same obviously as if we chose to
_change_ a contract formulation using your approach).


>
> Acked-by: Jeff Xu <jeffxu@chromium.org>

Thanks, appreciated!

>
> Thanks and regards,
> -Jeff

Cheers, Lorenzo

