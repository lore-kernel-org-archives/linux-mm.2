Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70BE5CA1013
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 11:50:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAB458E0017; Fri,  5 Sep 2025 07:50:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5BB38E0006; Fri,  5 Sep 2025 07:50:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D62A8E0017; Fri,  5 Sep 2025 07:50:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 75BE48E0006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 07:50:28 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8D5CF1A017E
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 11:49:24 +0000 (UTC)
X-FDA: 83855026248.25.7EE80A5
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4D5BF1400C8
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 11:49:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kmKH5UEB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hxtbhVWn;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757072952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9IJm4pCti3DgIcJI/kNEmfTgWR/PEB8F0l52E1eiEz8=;
	b=mB89KZg1ksiRSaxRt+tFwI8f+NzCbxJSPdPIWoA032miz8xC7LuJhZlNUYRn/2WzBcKab/
	MIMZybZzuoapLDSX4yd/dw+/LuQNQQsZBmtlSO7npe7kKd8G85dEn+Hnngrr2vAMKWK/do
	2f234epM+5pbvhhGh5ukLbemELhPsGE=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kmKH5UEB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hxtbhVWn;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757072952; a=rsa-sha256;
	cv=pass;
	b=3VM+ihFzBY7VWm2c/DnjP7TGf9FChqxT+e2oN4dJOZqluMSxorCy2nSrTho+BgiugWXSxW
	gG0tMRiuR6/cl3LFswyDRZSp+IDlLJ1vmTqenzQBa/DRCN0JdH8P9Nex+Nes6h6CtvQe9s
	Jaxsou0PHNMh5iAmMeIQufOXH/M4bIs=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 585AtjGH006145;
	Fri, 5 Sep 2025 11:48:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=9IJm4pCti3DgIcJI/kNEmfTgWR/PEB8F0l52E1eiEz8=; b=
	kmKH5UEBRoOs9xAmp/TiBvDPWwwLS9TjRyEdrOq1igJ+gbXJ7p0X6O6EQJWWG8T1
	r3XXuOAA7f8XHTeA13QorvFq4wvXc9dSJPY3eLq09qYHhrvaVP6SYNZ9mgb7PRM9
	NyXG3vAs0YsxVmd8CpS8pAoZzQpt6UzfYn9DtC3/wz2U58MfK3VlkH9lyKdO4NXt
	rLrdU14TIneaEb5sPmlUeJ7L08HUGsr30or0WM5mSCx7+bcrQsSJWP4PWymdkiTe
	2EXdY77XjbBkU3wFBJ2bE2k3hsnfB9WxM5njGLgUFYzBx7KVCXOrNFwH9g9isK33
	2ghNo5mMXCdPHv7CF2x5Ug==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48yxa58339-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Sep 2025 11:48:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 585BcL2U026225;
	Fri, 5 Sep 2025 11:48:40 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2078.outbound.protection.outlook.com [40.107.93.78])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrcwhwj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Sep 2025 11:48:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sZX1mx/N28+yuqOukrjrZ1F1icWYH8+tUJYbWVD191W6MGbh5zW9obg4nZPIgaxYSUOYXa2letdadJBzJR3LNxjvTEYgiR85p39S7Ani4abUec418+6hPCVpzIBr3Gdf4RhMDYrp6YhxyhJWRhUc2Gww8MDV0NzZB4sszEun6yIPaGncSjf0IyHT4MK4+s6R8hISUTOYBqDeHra18y42vAd53aG3N2tS3pmnAQ8XxbKargoExeZugDNqWEVLh3XTbzPXuihcCdC5JU5ugIu5crxYqhklMux7aCsXglGLUe4ht5ugbJDdkyeNZLGTruzbGSu55SVaOHwxzDuSayL3qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9IJm4pCti3DgIcJI/kNEmfTgWR/PEB8F0l52E1eiEz8=;
 b=YC9L/fXNTF5R4wFiiKLRIfWwEHcQ7gS3cjMA7LMX2icLiDkV32PiAAIEtzXDks9PAb6Lypsg9eauDKKlLxJz7zF2kZbPfaQOScrc7HjgDnfEF62IcarQuauL8wWFLDMe5m1Yqnictm1ZQRNH1dFOcPS1JLATCoLM/ZUqd1dHn7FnHuE3M+86x431YufhWSpo+rgKejBKXoDOAUEju4WCS6bbOdEGHpMb+p71eKmZD62Rqihfblm5zcQ7VRzZtb3lTdn+dKVpz+OekwKJXBM+o0nHRGt7aVUX0RqRgv0eog2KffRepzoPS8perCmgvrONPskGD2bKGERShK5GMEXqFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9IJm4pCti3DgIcJI/kNEmfTgWR/PEB8F0l52E1eiEz8=;
 b=hxtbhVWnwaytD++TV0wFccOeYjreFcDx5ekQHJlxh6w/DM4bHyeVUDQ9joRa919ofyNAO7JH/flrZiFuAuKcfwhhe/npzHiDJXvySEvYoWME9DZxcMh8XNo8/92eQ1GW6tUYaTHbm+6TYbEBQjv/7vyQOTDbIMLzmNtsbPlxEDA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MN2PR10MB4269.namprd10.prod.outlook.com (2603:10b6:208:1d1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.18; Fri, 5 Sep
 2025 11:48:37 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.016; Fri, 5 Sep 2025
 11:48:37 +0000
Date: Fri, 5 Sep 2025 12:48:32 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: Usama Arif <usamaarif642@gmail.com>, David Hildenbrand <david@redhat.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, ziy@nvidia.com,
        Liam.Howlett@oracle.com, ryan.roberts@arm.com, corbet@lwn.net,
        rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
        vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com,
        yang@os.amperecomputing.com, kirill.shutemov@linux.intel.com,
        aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com,
        catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org,
        dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
        jglisse@google.com, surenb@google.com, zokeefe@google.com,
        hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
        rdunlap@infradead.org, hughd@google.com
Subject: Re: [PATCH v10 00/13] khugepaged: mTHP support
Message-ID: <61afc355-1877-4530-86b7-e0aa2b6fb827@lucifer.local>
References: <db2320ee-6bd4-49c1-8fce-0468f48e1842@linux.alibaba.com>
 <c8c5e818-536a-4d72-b8dc-36aeb1b61800@arm.com>
 <2a141eef-46e2-46e1-9b0f-066ec537600d@linux.alibaba.com>
 <f34b5fcb-6a97-4d97-86a8-906083b53be6@redhat.com>
 <eb02c281-6d41-44af-8eaf-8ffc29153a3a@linux.alibaba.com>
 <286e2cb3-6beb-4d21-b28a-2f99bb2f759b@redhat.com>
 <17075d6a-a209-4636-ae42-2f8944aea745@gmail.com>
 <287f3b64-bc34-48d9-9778-c519260c3dba@redhat.com>
 <ad6ed55e-2471-46be-b123-5272f3052e01@gmail.com>
 <CAA1CXcCMPFqiiTi7hfVhhEvHs4Mddiktvpmb7dMe4coLDF0bgg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA1CXcCMPFqiiTi7hfVhhEvHs4Mddiktvpmb7dMe4coLDF0bgg@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0509.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:272::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MN2PR10MB4269:EE_
X-MS-Office365-Filtering-Correlation-Id: ff86d802-8fe2-4908-b08d-08ddec722697
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RlhlTjVac2N4bUMwWC9lZlZTdU5RRW9RVGkvSm9CRE1vbmRBOGc5c2RhbTlo?=
 =?utf-8?B?MTdTbDRWSWVBVk9LdWkxUUZ4eGdKbWo5UWJ4WWgwenE0cTJxaWEwWTBRb1NY?=
 =?utf-8?B?andYTm5YSWVKQ3JPaHpRUkRxSjlCRi9ITk1QZGQrdWtSZ1Z4OWZaMUhPejFm?=
 =?utf-8?B?em5RYVlUeGxPNmJtSGsxcGt2ZXNBTy9pZVBhTndXcy9IM1J0NUdRWkxmYSs2?=
 =?utf-8?B?UXlsZkdZSTUvVk55NVlKSzlNVFNKaGV5ZjkzQ2xUZXRqbmF5Yk95TCtqZEln?=
 =?utf-8?B?YnFiUGRScjJtRjZQb20wd0tmMndZaEJ3M2RGcW4zbno5ZFIyQ1hkYmxXYURY?=
 =?utf-8?B?SXJGSnJOYVQ5bWJGaUVxb1NzRXVGSGRTK1ZpeVkvb3NhS1ZyVHN1M0d2YkpX?=
 =?utf-8?B?STJYbzQvYmM0QnVUUjRURTIwQTcvSFZBVGZCSHZXMzlMbTE2Z28zZzFyMXZJ?=
 =?utf-8?B?Zk5US0JvbDFFQ0gzdkZpdzVYTmFDdjArUEp1TE11MmV2UDEwdlRWV0pCRmVZ?=
 =?utf-8?B?eURsaVJGNkFheCt5N3JuZE9Nc01keGlROFUxUWw0ZXNOczFWYm4wZy9DUU00?=
 =?utf-8?B?NVRFeStsSGxJWVUxdDJ3VDl2VlpFVGFDRTBWZzVhcDN0MWdESU5obm5xT2wy?=
 =?utf-8?B?V3FwZE1lMzVaODFZTVJBUDdRRlhQQVh6Q1Z2RGFqT2lKZFdSc2V3VmNhQk9a?=
 =?utf-8?B?eWIvOVl0VFBDNnZiRlRSRTdRRGlPa1k3S2ZqT25HQWIyTEg3bjRLWVROeEJP?=
 =?utf-8?B?aWN2N2Q1alF6SWgrNEtWNUtSVkJRaUlhMG9ZM1FqdC9rZ0YyaThIaDN1YVhW?=
 =?utf-8?B?Nm0xcmRlVXllYUUrLzdrcHdrZnBaMzdtZWhGRkhpUnlGVzZ4eWhNMEtpWWJl?=
 =?utf-8?B?em0zTndwUGFBQ3RnbDU4aU42V3lOOWorUENHWTZPVmhTc0xBOVBwUm01ejho?=
 =?utf-8?B?aFNLRDdmVFlMSXRyY0t3NlB1SXZsSjNmOVNmVGEwTy9aS3dhYjZuRG1jUm52?=
 =?utf-8?B?bkxpK2VDNGpwWVRPVWg3Qmw5QytscnNHa2ZVT25xZmZWNTdRVHJXOG1MNFhQ?=
 =?utf-8?B?YkliM01ZeUZMQ3ZYVHFFby92b1hMTGpBU2NUQnJzTy9tOVp0S0p1dDJZMVpF?=
 =?utf-8?B?akhWNnpxdWxNSFBscmx5ZjV1U2VFVlBNL21zNTRiWmJ5M3ZwWUFnNzhnamNp?=
 =?utf-8?B?by85LzVZREZVamgwWGlZUnk0M0MzTXdDUjYyTG5QVmZ6VUZTK1lVVW0xU3JV?=
 =?utf-8?B?VnQzQ3Z1QzY2MzFOYkhTcW55VU90c0syVjJBeHRMZk9lZDgzSmQzZEZERHdW?=
 =?utf-8?B?dCtoVVBGTXlLcExnUjVoUHljSnl1aXNnb1VTRHVKS1JZRlh0K0VyZUgzRlEv?=
 =?utf-8?B?eVpYcXUxeWlqUWczQ01KVDQ2TWlGa2lOMmxtZ3ZGdTZRYzRDSnVBUUhZSVIy?=
 =?utf-8?B?SGxRR0VkSjVxV2lwM0hwN1RrdS8zZXcwRWlkSDRMUTJtVlM5WU04ZnlGVEtT?=
 =?utf-8?B?SVdUOUxNS3R4THpSS0tSaUJJL2J6R2dOdXFMc2V6NzNheFRCalljRGlRVTM5?=
 =?utf-8?B?MFduZEJCSmZxaUJMNW9WQ0dNdkd6eGNUcXVsdFBScUFPL0xoU1pOZjJuVHBo?=
 =?utf-8?B?UXgrQml2bWU4YU84SWQ2UEFXVEtiZEpIeHMxK25ZKy9Xb2U1RzNsOVhaRk1i?=
 =?utf-8?B?YUpDMk9vMjFYZVh4SmZITWJxSUFwR1NsSHFhejZyU3RtOUZjM2xodnpZekxZ?=
 =?utf-8?B?RGRUemhqUWZHQVJ1QXcxSnVjQ0hDNUhYSmNNNGl1dEtPWUw0c2hyYnFQbDhZ?=
 =?utf-8?B?NDMvYjAzY0JOK1VZQnBmVU0yeUZLa1pKWEdOU0xLMjNpdVB4c25aQWxadjJy?=
 =?utf-8?B?ZmJ5THZjeXJLcElQZnlrMU1YV09qYWEzZHdqajE4R2tRc1IwZnd0azZ6a3c4?=
 =?utf-8?Q?BCYRtv8B2jo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WUpRU3Y4dG5QWi9zWFcvVGVpajJJalovenNrdTN6VVQxZFRSUjQ0THZqb0Mw?=
 =?utf-8?B?TjFiMFBXZkl2T3lhN0FTZG5kTHZYNHA1WEdMOXBlNTYzdFhINGdtUytIRlNx?=
 =?utf-8?B?QytzdGNOeDAvU0JZSWRMcVFlMmRnRFVsazJod2xYQ3BINVVKVXhiWExnL3hj?=
 =?utf-8?B?ZXJqb1JTVjBuaWE1T1VkdXAvTmdrRWkvT3lXbjB4Tzd3SUN4UmY0WVduRisy?=
 =?utf-8?B?V2RFQnR4UHJZZ0VvcXpHL2IyUno4V3M4S243QXo3NEJhS0xWMUJwR3NoMVg0?=
 =?utf-8?B?S04zeml0RGxkNDNwdnNrRDh0b1ZNejA4V0J6eWZqSjJqQTg3YWtSMzJBcTAx?=
 =?utf-8?B?UlFKaWZUSkhzdnhpWkhReU5qMTBlc3dsTTNGdjRpL2F0cFlUT2o3Z0NzbzVJ?=
 =?utf-8?B?Uy80TzRrNXZvbDFWV1dBZndSMlYxdDRJK2pZN1ViU3g3MGFpVFJ6VE96d2Jx?=
 =?utf-8?B?ZHpZQkRkQ2xNaG9tV0xJTGp2R0tvbStleU5ZYUI5S0RPa3pISXJDUmZEaXB4?=
 =?utf-8?B?UW8yQUduOXAydk0wWWlrWWZOWXJYQzVLTnNqY1NpMzVleStQYXVwK3pHa0kr?=
 =?utf-8?B?QVAvaFVDalpyTGQySzZaMytPUUJEZkZIdjd2akxscVFVTFRhZVU1MCtSQlpY?=
 =?utf-8?B?Z2MvQngzNGZhSE1PQUIrVkticzNwSit5L1F0NkNiOGFTc2xORGtqWkl3OTFE?=
 =?utf-8?B?S2hQZExxVnBVUmdPY3FMb3JpZnU1VmMxblpvcmJIenZLTFc5ZWx3YStHSHZD?=
 =?utf-8?B?alhRN1FhckwwVlkwYlhabCtrOEowNFR6TVRxNUdHRWlEN2huOVh3UkwrSjhW?=
 =?utf-8?B?akwzZUdpb2pKeEZWSm1zcXpodENuWERaV21zdXJxMU5uRUNpejZJYjRFc2Ez?=
 =?utf-8?B?RHlIL0xxdlRlS1FRVzlnL015UStaU0cvTTNVVXV4QUVhd3B3eWNnZEFBYWJQ?=
 =?utf-8?B?Rlg5YXdtMGRGcy9jTWhhTkZ6VUxSSE02RkxPY2VpWVF0dzRYMENVa2FGbG5T?=
 =?utf-8?B?QWdldk9mbnUxdHBnblkxU1JkZlkvV2d1d2R3S0ZGTVFPRFBGWjE0bHRLWWh0?=
 =?utf-8?B?RitNc0VKVElmR1lXL3BFOSs3NVVrOXh2UmNkYTdVVjQ5MTFMZDB1M1ZESzBE?=
 =?utf-8?B?K1ZFYU5UTGtXWThzajl2d2dVM2NDSE9LbUpWaTE4ekk0NDRnUjd5QVBZZzFt?=
 =?utf-8?B?R1pNbFVLRk1ZU0gvdmtzcWNZUUpGYVNWeXVEYkpibzdrMWNicmJPOFZkMVFh?=
 =?utf-8?B?K2NHNGY5Uy9QOTJJVW96Z0JsWTJuSjNHRkI5Rm9MTHlScitnbDF6NjlXTUl6?=
 =?utf-8?B?NzN4TFRrSnV4VG42RjdjdWRJL3VpMWkwUWErcStZbFU4SHVmMlRpckRUN01Y?=
 =?utf-8?B?N2l6b24xUDlJSDQxeDRrZDNGcUxvOXZoSWQwWGRMdTBwL3l1T3hPN1lYdldu?=
 =?utf-8?B?THNKR3ZEWmQ0OUtldUZnbXFpR3ZKcWFGdjZBQ0FBODBwMlBCMVBKNG42UXQ4?=
 =?utf-8?B?dFhqM0ZIbkthelNUeEhsWUxrN3pRNkQ0N2NmTjNJUFZvRDcyZzdYNTk2YmhW?=
 =?utf-8?B?L29lZ2R6OU1CVnNqdVNmRGFySkIrRWMwa25qZVFJVkZSa1VGTTdqbXNZZWlW?=
 =?utf-8?B?dGRjMmw5WWZNTTFyMXBUK3VBWU9tcTExa3VXZTRPd3N6aUQzSFpuRzVuTFVZ?=
 =?utf-8?B?S2d5WDNmM2RZMHAwVjhoSVk5SllxM21iNm84c2d5YXcvRG9vZGZLN1dSbFkv?=
 =?utf-8?B?aTBHcURvSW05MEFhcFdQZ25UbGtOdWlrYURVR1l6dlFkL2c2RnB4S1lEWTg5?=
 =?utf-8?B?TUpRMm9zS0g4aGhYYk1PMHprckZGQ3BzL0NUZWx3YzFUZmZMUzJZOXlOaXdX?=
 =?utf-8?B?UlZ5ZmNYUUthNlkxUEF2ZnB4c0lkbksrUXEwUmtSZXlVY2dQLytKYm1VYVl2?=
 =?utf-8?B?QVptTGp5NWhzWWMvNnlQenNTeVBqY2F4OTlsZnIzNHVEODZyTjhOVVFEZFBQ?=
 =?utf-8?B?c0RWakhYVXhWR2Nsay9TK0VWYXR4Sk84QnhiRk1vKzk4WEtRcXdJVXowR0o4?=
 =?utf-8?B?dUp6b1RiVVQvalV1ekhMdEtjMWJIbGFOYzVOdE1FUWJIMVFGZnhzaVJVSlkv?=
 =?utf-8?B?ckJ6UVYySkltQ01GZmR4bHlnd0VwNjRDSmhpNXlVQTVmditOaWFjS29zSjlO?=
 =?utf-8?B?T1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kFH0kdQf7P7Pu8BSe6S0wDyF6yLdlqAHPt3Id/vykLTFYhZ/N4HU1ubUifhkbRhlyVnwpZ96RU5slSgil7VZKPAZrzbhGIr2EI6e1TdV1kGmEB0OHAGNNAw43YVnyE+MInyOm7jmuxBO9ecubD5rzZOLYeQ2ogLSTKSwDtRa+odgQTxuF/7MmQxCmggoza5Wv9v7/Lz7P5rPcXljti294/k8/PZjcIiffxoGpwWmkJn1Yp5SzPY+XDgXqqoRemuT9wXGiHF2rGjYL+iat+MB8B0vGdD1ekbf15zU/x6b5HM53CY8jS4Ig8uSyAoDyaIJLDV5H+5fZ4wPBfAN0wlP7447WQkh78NN88Iy533YGgV0es/kdo6PGOgaPFwekdgW1ONVukoT7A4/2wYqFQLK1XUwaH6Xl1532M0nWJVRPwm5cPLZfFxpcKt151g0uPEa7xixM48vi6yRKW8IWvbJtKsy6JMKmGqhJpdy8WvOUtZJ0QOV3yvY1xSfRYgxdCMUhyFKtxfqbIbpa9diK+UZRwuMmUZicpWZ5YvdK2X2gU3cOlqyRG/CvRdZSHHdHMQD//N2OopHTplPxY/L2Yo+IVu0upO5w2eM06qGXFYdHGI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff86d802-8fe2-4908-b08d-08ddec722697
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 11:48:37.5020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eINlHxhESQfXQIb3Y/ZV2ox+Ib6AZ34/eFvxRyRAZ2Wl6bwoTUOaqMQYAO2B2DbPyWWrXbrKy+4U6hgKY6UF9kZiHZQPgbiHvel4+hcIQ7M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4269
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-05_03,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509050115
X-Authority-Analysis: v=2.4 cv=eJgTjGp1 c=1 sm=1 tr=0 ts=68bace19 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=pGLkceISAAAA:8 a=-4uDIYMYzXv8LMoFi0cA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13602
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA1MDEwNCBTYWx0ZWRfXzPaBKKXc8uPp
 d4DwpLVsjHsgpjtcC1VNp08lazEQk93lq0CNi02kmwcEGzlEoALmBN5t9TsxF5Dly3fGXSNydeA
 XO+A0dQ/1dwBe6g6QgeIr8Xhz6g57nvR5Cxql5ZiV23jl0UcfLtftqGQiqurtxrPRku4zNGgMh4
 FsdUIiE8eZdw3gnvBeGURQavMvRRsE5VSDATfCJ3LW3rrhd1pWcvJXZKJDNO09Wj5lAmUT0BgpZ
 owrkrXO1edcDJDU0ZudT1Tn2Be23jjvS/mUmuQ0dxz0Q+nmCL3JbJvAOXv8BN9+qarFSTaqUecr
 Ean92IU5gW7YoeErcWNe/aC1YT1HTM5bovKY8GgL4lWgZoIJEZYhrz7rDxBaRYSqCN9r+jZ9DW+
 7uKUNN2LlshNcdgpW9zgfNP42sj3qQ==
X-Proofpoint-ORIG-GUID: GWdU1wNCsSDj7mhd6Vo-xhKDK_5B3yJo
X-Proofpoint-GUID: GWdU1wNCsSDj7mhd6Vo-xhKDK_5B3yJo
X-Rspamd-Queue-Id: 4D5BF1400C8
X-Rspam-User: 
X-Stat-Signature: pdag339k7aajh3phjx3yd3bzqr3rq1ng
X-Rspamd-Server: rspam09
X-HE-Tag: 1757072952-223007
X-HE-Meta: U2FsdGVkX1/bmeomgaUB9wQbapZoIt4zSJJXUjdTMj/ZGBFekTtBWYgwOcAcEAT32y5eSxoMFFq2mtIyUWiPlVLm7XbzN7Z9yJQwzmD5IHwISUbRQl5V8F7zyg6mVti57Pfqe20y1muJOHDLV7EigCtHCKHlVy+by7fdIwjBIHRTBCkunGSbOnQxAB5Fn7yeeZ7672gHQU4BExAfRdCAUpgOSpiLtbkX1h6CGXVZlFRdGvwqT6ivR/pmia5RwYXSzZ7dMNyu88epBFgcKN7lbd9qBybCqtluUN3Kilvy08Dao7+N3yJohmH8AGxdrSLvwZBF/vReq4D25ioieNtXeAMldQemYa4qNgBhLcDBTR1B0+amCwMb7YjFrnLlz3FlLpPVr833M+NooE/2O5EgvnVonvsqwgEkm9S/NcFU5UbwvS7SLO6WIh51XkdgsXF8VtGaI6IzW9DKBEQ4cSN3N4QRE36yjNTCt8GuPtW+q4ojXN/SdnOYs2VNS6iEUxWyhY0FcYccphqsxKKdSmEThNIP/1M+xBYSv1z56A6QrB9LE2cSY/OVpFPI+iGAUjZoJYToSQKCes83E8wTbzQa4o3L7RZIoJCfJP6zToDTqXvBL2x6PapAxXUrF4y/ILW7pV5ePntoKev6WT9N37P0H2JaOgKe5Bv7CqujvXzz/mgMmViIRgt9g+xOPyGdylM321/Xy9ulFi4iroUkT+fOwmSDbAP/BaP9dSgSPyqxwpiXrLsN0sWD4ZjnlZdnFbcuUeJSbsmurZgequxG2gpjUaW9Jl0wrxcW81CzqQYlyQN3hNSf10suJG5nJraUk9U/mmsE8a09fYnGWioxMrBvWnVVXcKEWPME0NfCRmHcQQGlyweQh0I+FCBYxlz1MllUiKVdrlI1jo+S1eRQZUYrQ9HE+gXUld5oYaTyKeXfbRRKZagSF0dPp1dfKR/gQrF5UFyCEGI+k+CQILqOURw
 6BJhb5gk
 1a9eQ+rh0nl9mbul6U/vKoMAtSI8DlLKvi6Hw36EU5TQ7CmxJTS6+MUZ3aveNsfrUGi07bPKXGM6H0VKJuPF+n4RHmXg0ZurS8SHBxIsOrZGoTjD24CWCY8k+2PmNYAWMk5yekBH8rSp9w6WrcwRZ/Qk4sbaXfjNpHJqwFIEgA1HYCul2SnlfJNZxPsWsRmuKeo9199zNvmLyOcnHBKgHxLHdMB6YQmO67JBpw4is8tCc9ELxPWYW9QPBfnvbW428ZYeCXz/w6/Pc5pAEJfamwKr7vugqJTAw3HaH+2hj6mlREjN0UReVksV5Y3c2caoFsle6VlqCDwm0yWuGw9fudJvJGJEdX8waGZGcGWnvlYMit7bhkNpjp8b0xwrnyq8C3SeuAeZaTty9ORqI46qGJ5eBr4dwBDfKzdNUqY139rxm/zBG7Sx74WUNdmSnySP6w1x7WzExeOTCaNedLcM4GHeWDbOHtFr8lOMfIMDL6nDb2cX19voIAasYmlTkuX0ilXro6+y5CoM4zB2cNbgITUraEYEM3EwEJZ2daN1sQ45vUxzsuypYQFmFaP9PPq7W8F0lw5UgAg2ZlT+UDyKiPO/MQGuI1GJAPnVRNjppw7gx51vAdZD+TqB+sCsasvzjNPYBzt8hi1iAd2Gg27JFacDmDMppXd9z40pGw/VWU83YV2U6zRPRgFtLh73g+040PHlYU4kRJFvTZDg1fgq4nq5DoXKrNnYsm7+91VzH+VxhB7aRSrjEKhwoV0Tf3eOapbj+nSVin16mdEhNd8ottG7GEreC6eVGe4uw+Uqzfa+7Opks2MXdUASFAe9TjnWe/l0eDNLZTgCuVGA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 08:54:39PM -0600, Nico Pache wrote:
> On Tue, Sep 2, 2025 at 2:23 PM Usama Arif <usamaarif642@gmail.com> wrote:
> > >>> So I question the utility of max_ptes_none. If you can't tame page faults, then there is only
> > >>> limited sense in taming khugepaged. I think there is vale in setting max_ptes_none=0 for some
> > >>> corner cases, but I am yet to learn why max_ptes_none=123 would make any sense.
> > >>>
> > >>>
> > >>
> > >> For PMD mapped THPs with THP shrinker, this has changed. You can basically tame pagefaults, as when you encounter
> > >> memory pressure, the shrinker kicks in if the value is less than HPAGE_PMD_NR -1 (i.e. 511 for x86), and
> > >> will break down those hugepages and free up zero-filled memory.
> > >
> > > You are not really taming page faults, though, you are undoing what page faults might have messed up :)
> > >
> > > I have seen in our prod workloads where
> > >> the memory usage and THP usage can spike (usually when the workload starts), but with memory pressure,
> > >> the memory usage is lower compared to with max_ptes_none = 511, while still still keeping the benefits
> > >> of THPs like lower TLB misses.
> > >
> > > Thanks for raising that: I think the current behavior is in place such that you don't bounce back-and-forth between khugepaged collapse and shrinker-split.
> > >
> >
> > Yes, both collapse and shrinker split hinge on max_ptes_none to prevent one of these things thrashing the effect of the other.
> I believe with mTHP support in khugepaged, the max_ptes_none value in
> the shrinker must also leverage the 'order' scaling to properly
> prevent thrashing.

No please do not extend this 'scalling' stuff somewhere else, it's really horrid.

We have to find an alternative to that, it's extremely confusing in what is
already extremely confusing THP code.

As I said before, if we can't have a boolean we need another interface, which
makes most sense to be a ratio or in practice, a percentage sysctl.

Speaking with David off-list, maybe the answer - if we must have this - is to
add a new percentage interface and have this in lock-step with the existing
max_ptes_none interface. One updates the other, but internally we're just using
the percentage value.

> I've been testing a patch for this that I might include in the V11.
> >
> > > There are likely other ways to achieve that, when we have in mind that the thp shrinker will install zero pages and max_ptes_none includes
> > > zero pages.
> > >
> > >>
> > >> I do agree that the value of max_ptes_none is magical and different workloads can react very differently
> > >> to it. The relationship is definitely not linear. i.e. if I use max_ptes_none = 256, it does not mean
> > >> that the memory regression of using THP=always vs THP=madvise is halved.
> > >
> > > To which value would you set it? Just 510? 0?
> > >
> >
> > There are some very large workloads in the meta fleet that I experimented with and found that having
> > a small value works out. I experimented with 0, 51 (10%) and 256 (50%). 51 was found to be an optimal
> > comprimise in terms of application metrics improving, having an acceptable amount of memory regression and
> > improved system level metrics (lower TLB misses, lower page faults). I am sure there was a better value out
> > there for these workloads, but not possible to experiment with every value.

(->Usama) It's a pity that such workloads exist. But then the percentage solution should work.

> >
> > In terms of wider rollout across the fleet, we are going to target 0 (or a very very small value)
> > when moving from THP=madvise to always. Mainly because it is the least likely to cause a memory regression as
> > THP shrinker will deal with page faults faulting in mostly zero-filled pages and khugepaged wont collapse
> > pages that are dominated by 4K zero-filled chunks.
> >

(->Usama) Interesting though that you've decided against doing this
fleetwide... I wonder then again whether we truly need non-boolean values.

But the fact workloads might theoretically exist where it's useful does make me
think we have to have this, sadly.

Cheers, Lorenzo

