Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9C5ED25B48
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 11:51:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 298CE6B0089; Wed, 28 Jan 2026 06:51:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 258F86B008A; Wed, 28 Jan 2026 06:51:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FCC36B008C; Wed, 28 Jan 2026 06:51:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F0E3C6B0089
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 06:51:46 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 83A41160623
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 11:51:46 +0000 (UTC)
X-FDA: 84381208212.07.0A5AE5D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7BC78C000F
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 11:51:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ALWHGpbf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=g7zlvA7n;
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769601101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o3n5pToNRQXDKrnkahdQLJuJpB9kHiRot5XGYGiRD/A=;
	b=kVq8X5vMvSj71vIGjs2OjHXOaFIrAPivf8vg5Ud9muWJ622lUODALhpT311shr91pXdrPE
	k3HvkmhX/vjuYLJWPs6E5AHY2mce4mDnC1AF19BcIZI0TddJBRDE2qeWzlY7A3Ob4U/tKU
	FwgaUmgbLk8kBDi/OHeWZ3CjCAI2VXM=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ALWHGpbf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=g7zlvA7n;
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769601101; a=rsa-sha256;
	cv=pass;
	b=QAlG0tPzZ6ypXzhuDjNyzVGzbKs0QPxSh87Z/R/B5RvYXZZbbO1S7FmCZjtv3KOgYPF668
	4r5r7GPn6J6c2p7cWRbt7gXagGuIyD2f+LyDkbgtXt1aWpwZVThIPMrZHbWGTrOiB26MGq
	YSOWIHJfQ4ydgTFeGg7xmVV8HXn1HCo=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60S4CBMD837976;
	Wed, 28 Jan 2026 11:51:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=o3n5pToNRQXDKrnkahdQLJuJpB9kHiRot5XGYGiRD/A=; b=
	ALWHGpbfaxmkvo/ORkYMprBRSs9nYwwrMnsaB1JxNAt09Cp1Oeu1ePc8n8uSYQ1V
	tU6A1p8tmXMmseaVxvLSn5QynZA7IZuhHCfn7SLUXivzq9/mkkm8vCf3zst0vSJP
	QsWmRI6IoBC/IaxSJVv1VJ2IJh8E1Vn3AV/NKWMVZtCQw4d/96Xe0KX/02TEQGe4
	nGvGFXZBG441Rb9+PURV8OmWoFTwB7PLGWqo1RPZFWOHmvnWp7Vw9Dtm8OfyF+K6
	UPJbw1HxV8V9MulNgkLxFwug1dAzQCmq1jMQpmdZefQOFqZaZ4udcEGnByCPvBNr
	3xNuVnzzM6r255XA0ZGs0Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4by378h7ef-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jan 2026 11:51:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60SAEDYx036018;
	Wed, 28 Jan 2026 11:51:28 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012064.outbound.protection.outlook.com [40.93.195.64])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhq36ba-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jan 2026 11:51:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SkXeKkLYCcYitR5ccESiaREoZVwtLL6gY+z+t8sogFgLCde3RbTr1iGQWCKTVBph40TOScKs6YHazyKHLtCy5BmvYj0Rnuq7nU50fUJoGmdML8TPnbLCm7eT6e/Rkpsae3ZUd21eAmtyLBc6pXCBRi0P8vvlh2jHT6kDHSTxmVPy5Rbyduad3C+50ZwNbrMDrEqvXeHfD0PW6d5dEhOWSwSSVLUlsLJ0KW/jW1HGmMj/NV1qHeYt6EloPs3T1XG0AiAP4/BLmzZxGfucuxlFbw5fOYyqkoX2do17E4RTw3ZvQR6FrCM1ba5DgQNdhGJztrHC2Z1u4ECXMKhVTUBAaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o3n5pToNRQXDKrnkahdQLJuJpB9kHiRot5XGYGiRD/A=;
 b=HSuqG57GBbH5qiLK3MHNDFFuc1CJOIv8i3apVQNQqzR1J790D7UTuH1BDeLxnevBeHb/EhGh4z3LzWBlMWwKNH8FjVxO8wUKzVfqXtp/QkerHwwA+MRv2yghSJ6wFTg02Su3f4/xe1BFDyzni0YDitkStEehwIxP/8YeONiScAFy2my4QeI4X9RvK7ieyiBLBHTInc90YaWmxOd5zz2PbjjCg7HuwMOB6tDvO9a1sG++IUYEsKQm718hsFhQo3qXiL45Muat6l0aqhegjF714PgOFvc5iPKlvSQHILIFhsOQjwhliXlRDD+Zi/7Uo8qSPNCYZKzD5RhIzfbPKPHfig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o3n5pToNRQXDKrnkahdQLJuJpB9kHiRot5XGYGiRD/A=;
 b=g7zlvA7n7ajYYsOt9h1Cb1WHWR/BpGkeeNySxjD5FslU+eAkrYXStVt8nR8dPM9wsb/1nUVVvMsRykvEdlKAWmKBcPSmFA2ofFJHWfTlEniyHQDV3zI1zz+8MmwBMYH7D+c81s/mBImJkUkYo07h4Uiey4wW5G8xOYm6ptDGuf4=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by DM4PR10MB7402.namprd10.prod.outlook.com (2603:10b6:8:182::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.16; Wed, 28 Jan
 2026 11:51:23 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Wed, 28 Jan 2026
 11:51:23 +0000
Date: Wed, 28 Jan 2026 11:51:21 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v4 08/10] mm/vma: improve and document
 __is_vma_write_locked()
Message-ID: <425e3040-0522-4af1-a7b9-c9ad04e017e8@lucifer.local>
References: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
 <ef6c415c2d2c03f529dca124ccaed66bc2f60edc.1769198904.git.lorenzo.stoakes@oracle.com>
 <47eafa10-6d13-4324-830a-2e7cf4e67f2b@suse.cz>
 <6444753e-1df7-4732-912a-0ea441f76cb1@lucifer.local>
 <CAJuCfpEBHsuGJFAGyXdASpaV_FY0_RBShKZM3QA_9z7ZvAtu6g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpEBHsuGJFAGyXdASpaV_FY0_RBShKZM3QA_9z7ZvAtu6g@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0604.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:314::13) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|DM4PR10MB7402:EE_
X-MS-Office365-Filtering-Correlation-Id: 0761e4f1-f2ed-45b3-fc9d-08de5e638fa5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TnhQVDJJdGxDWjZqVnkxWTA5WHQxeUllVitSSVVTM2ZxRHc2L09JTUxyN2Rp?=
 =?utf-8?B?KzA5UHdHeS9zQWFYZmpnSEtIek9HRDVITGhNZjBMQVBPK3VQb1dOSVZSTE9x?=
 =?utf-8?B?UGtMcHdPcWFTcTd6ZjdCdW5WbUdaTVZlNGJIV1N0L3RmazFZbmlxMGluMi8r?=
 =?utf-8?B?Vyt5L0dqdHYzSGhqMFJ2Q0dlT215d3RSTGppRitFeFhuZnQ2ZDRkdC85bSt2?=
 =?utf-8?B?YVNJRExjalNXeTRBeGI2M3NRQVZMbkV4Qm9BQUJqQTRiWjB1c3MvYjhtcVU4?=
 =?utf-8?B?aXE0K2RIRncyU0Z5c3JXZGVJUDJnSlFLUVU1UkllbmlQZkhMbzhKRHRxaGlj?=
 =?utf-8?B?ZjdSeVd1ZUwzaFowNWl0aGpTaVV0Tzd4N29nOU9MTkZXK1lSdWhlVmUxOGhy?=
 =?utf-8?B?YXgxRlFsZUFwN3Q5bGVRWG80V3hFR09ZbEovNFAyb1h4bXdOT0ZOeGNCcStD?=
 =?utf-8?B?YzF3MElEQnIwQ0pZZXRtUXJ3K0ltWUhWTDdEdy84LzRkK1ZEc1BEQ1dwNjR2?=
 =?utf-8?B?dzNMcVdrRGxFUWlEdndodnU1UjlrQ0RQbS82RjJjY2JPanNueUN3RUUyV0dk?=
 =?utf-8?B?UUo1NCt3T2ViUWZrL1IxUlI5d25pSC9hSGtlVUFrbVUyc3dGWUwrQngxNnNH?=
 =?utf-8?B?cEYyZDFqeThPdWdON3hadjFIdlBtTm1HSzNvb0dUclhZN0dLK3lhT2cwLzd5?=
 =?utf-8?B?S0pqbXRJek5oRWUrQzkxaHg2bmhrMi9iaXV2bU5FSTFxTHpnT0NEUE1CRUl6?=
 =?utf-8?B?MFVlOGFGeTgvQmxZVFlvOXlqSEt2eWlweW1xblhwVjZFUjZQNUF1TEVTQjlD?=
 =?utf-8?B?bDJXVVh6S25ndlRsemM5Yko0WGZJc2ZpeUM4dU9DdnZ3d2N2bzJUSDFlYjY2?=
 =?utf-8?B?aWx1Q1NBQzVrRDVmZW05ZVgwQW05M3pGREhaeHZ2c1FueFo0Um1DQU9Odm1s?=
 =?utf-8?B?TU5KQW5rZmdDSlhnb1lFbk9FSTRkWFVMOW5VTkpIN1ZGTGNLRnl1QzVkL250?=
 =?utf-8?B?ZWpDWHVSR2pHajRxTHh3cUo4UFhEbWVKQnVLaWV5UWl6WDNWVkVVSThNU3JZ?=
 =?utf-8?B?QzRnRXNnMUNRc0poRmkxblM1dm5Pd3AxaktMdFdOUW85VE5Wc3VtbEJYemxG?=
 =?utf-8?B?bGpPZUtjV0tleUMvTmNCR3NmVUJhcXlzQ0lmaWFxRTVsUmltcStXWVZ6QlVw?=
 =?utf-8?B?cjJpMjhScG1zRlFvMldxVHRleG1qQUhOQ0NsbWR3c3RqdUE1N0paQlNMSFE5?=
 =?utf-8?B?cjVJdkM3Y2ErZWNCZlRuejZlUTQ0SGdTU1ZQV3o2M21ET0hycTVXOFl2Mlhj?=
 =?utf-8?B?Syt1cHllOERWakQ5VWlndm1tTi8yckVYeHFOWWJzaStKaHZCNkNRcXUyUlk1?=
 =?utf-8?B?bTI0QjJZU3NINmdSLzlZQUZRTDlXaDNEejZnSlpCOEZYVk1XZXU4YVZFeTZ1?=
 =?utf-8?B?VWZEUldadlpiVWlwSy9idnBmcUpUcFFhWXNCSWhDVmQ2UElNMHhodk8yQ2Vj?=
 =?utf-8?B?aGppbkNUSUc4Njc2citvY0Y2VlZqRG5rVWJkMUE2b3pxNVpPaUhPMlJFY0Jk?=
 =?utf-8?B?S2xnZGlwcXQwOXRnOHp6bnlVSUNsczZmOCtEa0pvMXY0WFc5K3d0MkNvMEFU?=
 =?utf-8?B?czIvRnc4azkwSnZQbDBodEF2Q05URzhWeVE4RWNpQmJja0dIL05qY1gxTzVn?=
 =?utf-8?B?VVhpV3cvT000aEM5UDhxN3J4R1RTUkFESDNIUzdBcUhpWUtmR2hxOU5pTW1i?=
 =?utf-8?B?YU13eHdVZzhCT2EzWjZXSTJCWGtibnp6eE1JZGxkSmQwZHRMTlNRbUFGeVJP?=
 =?utf-8?B?dE5KazE3U3lNWTgrYjc0dGNCQy9rNTNLc3RXOXhxTXc3YzNLakFIVFJqZXA1?=
 =?utf-8?B?L1hzZnQzRlZFcjZYWGFpcit0Y1RLR05GUDZBbWdteTRCMWxzVG12R2RvUFRH?=
 =?utf-8?B?WGhIYXBZVnlFamFZbmpsbmdhUTVIa3NYK2owZjhuakpIU3BodmZ4Ti9pcHNS?=
 =?utf-8?B?T0psMG1seC8ra0dSRVhiTzhqVHc4R2R3MGJqUXJHd1Z4M2ZUTDcyaEtzUzZ5?=
 =?utf-8?B?bVkrYU1OdXBJdlQrRmdyN0xab3NaWXdBb2k4L1k1R1VXT3doNEMydlVFUHVk?=
 =?utf-8?Q?5ypk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NkZaaUttcmt3UXdwQ3lMM1Q0UE52cHVZYyt5QUlRNmZGaHcwM3FRVSsyUHdR?=
 =?utf-8?B?bUhndmtjMXhzMlp3ZjhZTisrNUUzWWo4eFNacVdKN0oxK21pTVpDdGd1NU42?=
 =?utf-8?B?UkY0SHNSU1RMTjIzQWtjVXpTS0xuYXl6TWVUVWM0RmJ1SUwrZHRoZkg5dSsr?=
 =?utf-8?B?TG5obDlTNFRmQVQ4WmxnTUdyQ3VkMUhQRzRPclY5MDlEMmZrZys1aEJpdi9y?=
 =?utf-8?B?UkhTS2RsbnkzWFpsbE1ZZUxWL2h1ek1WSDYzNzhMNjRCdVRUM1hhN0s0N0RZ?=
 =?utf-8?B?MWozRkIrTzViMTB0azhGWFRqUE5tYWRUR0ZqTGtKdlplNEt2aUJDM3RnZDhP?=
 =?utf-8?B?cE9wN3RJYlB2ZFc4WjlsRFpvRXJoNEYyNEtSVGVRZFhyZFZpSm0xdlh5NFU1?=
 =?utf-8?B?WGFBYjJtVUM0SXlvalZQdk1pWDF0ZGltMFpGZ2gvU0Z3b20zVC83bnZzNmhT?=
 =?utf-8?B?MFdENEs3VE92ZnVXSE1zd2dwN1VpS2wweUU4dDlhcnVCbHV5U2F4aUJwOTNm?=
 =?utf-8?B?TnZDTTl5UitqblJ4a0Ezaml1azV0ODJyenArVzk3dWt6ZWRxTXBJNDJIQThS?=
 =?utf-8?B?Y2xNc3FteGkxTHoxbHhTaHh4TURmWldHR3phZmFNL3VrNWxnYjFvSDVtcE96?=
 =?utf-8?B?Q2ozZ0hDSVFQdkYzd2E0QVpkcGlPS2V6cnRJbXRRNjlUd0kwZHZRajJYNHA3?=
 =?utf-8?B?NnVra0lxQmNiSXpjY0xVYXhNRzlhU0t5clU4Ykx4OVYzL3VJQW5DQkZUeGNX?=
 =?utf-8?B?U01mSXRna1NJL0JYMnBOcDhvNm5NeVZEVFZqTjlVUE93M3puNk96SXJISFZG?=
 =?utf-8?B?NmFtVEpQT0ROOWVlWjlYY0NNS2FWeTJkd0ZvR0krMFFWMlM2OHFySENUREdh?=
 =?utf-8?B?NGJRNXJnZjFER1ArRGlJb0pKZEJ2dHVpZ0c1VmtBZFpVaWFYaHIxcWRPQXl1?=
 =?utf-8?B?eEgzUjdjczhMZVljNmx1NmZVT2N1OUJpTlVmR1VmeHZvZzEzTUwzWEdlUWw5?=
 =?utf-8?B?RWZ3dlowNE13SzRub0ZqKzQ2UVVIS0xOelM2R09mRThMbzQybktJQTFZdHZJ?=
 =?utf-8?B?YTNqUGcwSGJHV20ySEE4TUhBSUJkbTV4YkF4ekRkZENqSm81bWxhc0dyL3Ez?=
 =?utf-8?B?OTFnVGQ5aHJmdDMzSExXdGdna3NNOGovUWxQaUVRVnBaUTVKMTlWT0JpOG1X?=
 =?utf-8?B?ZThLVFNEU2ZIdkdwb0JRZWtNeHNDWEFSSDFWU1dTc0hjcnBjMEZwbnlHR1N0?=
 =?utf-8?B?c3lrdkZtaUxTNGhaSkZnU1VFRTgxN3Zaa3NoSFRGakZLRllJdjQ1MEpJWUdp?=
 =?utf-8?B?V055MzcrUlJkaWhxWlhYMlJvZC9JK2c4bmhxSG05T0xKZVpPYnU1UlNHSFhq?=
 =?utf-8?B?anFPTnZ0aTdJSjdsODdFS0RCZ0tGRVVpdi9QTUhhM012NjZ3ZlhOVWdXY0RG?=
 =?utf-8?B?UmRPV0pZUldRVWhaNG9NaHJmbFY5OE5SNW14bUJ5U0dkL0RFMHNpaHdvc2U5?=
 =?utf-8?B?aXlUVnJ0K1o0QXlTN1B3TmJHR0Vqa09GY3FwWW0vY2FXd1ZRRVRtQUN2b1di?=
 =?utf-8?B?ajh5T2xKQ1ZpdXltTWo5Mjc2aGphR1BSZjJmeWJEWW1jWU14ZHBlNithUGE0?=
 =?utf-8?B?WXoxUDRxZ0RhaXUrNXc2Q3ZOVVlLK3JaZSttVWlrZTVDWmMvcytHVE4xRnE5?=
 =?utf-8?B?UjJGS241VjJxLzVTUk1MZm4rUDlvL3JRQzlzRU0rZjNRcGM0WHgrQzNQSC8y?=
 =?utf-8?B?d3puTGl6VFhwV1BHWWlrQzRENjZ6MzZ4cHd5eFlyYk96VUpaeXBLQ1QzQ1lu?=
 =?utf-8?B?Y0t2N1BEUHRnazlJVi9JMXNsQ0VBSHMwQk9CQ212azBMdDk4YlBnK294OU9Z?=
 =?utf-8?B?Q3B2TGE2WEJDajRHOHAzM0VxT2kyQTl6VmlRZEsvTkNoVWttOEFaanF4ZVVr?=
 =?utf-8?B?NFNDc3pBNU96UzJ5Q2psbkdJc1RHY2JXZUdVVGVyYXlWNEFCNW5SMEZmbHNu?=
 =?utf-8?B?ZStSLytjeWRjbStoL3BxeTZ4S2V1Z2g5RUlOaXVGZTl0LzZQZE5qMG5xbVFG?=
 =?utf-8?B?Q1owdENiQkx2UGJxRDRZdWRmdmd4ZXptbHpmOWFoK2NJQlVXem9hSzdUTDhJ?=
 =?utf-8?B?UzRMSHE2OEVoOXVBM3l1UVBkL1FSV1VNbjhneEo5aHc3TWxQZksrb0RKbDNU?=
 =?utf-8?B?K1pjOUtKQkdTdVByUEpsU0dRK1Q1ZXNHT3NjOU1uK0NpdVJnaXdoT2VWZnor?=
 =?utf-8?B?NXpseVNidzl4SU05T3NraFgyQ1hCcHNGNFdoaWtnMndPeWhjRGlLM2NTN3Jv?=
 =?utf-8?B?cUdaZlpvNjV4d0h1aXdUYkZKQUZubEE1cmFuNjRoZHJRNUI1QkE1NDRwMFNR?=
 =?utf-8?Q?KE40hZLp43JUmMsg=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5BjWuvSgJphdGZn9x+KG6gpCl55lbnKQ38wAUp8M/sIF3oABol+1YxjW91zyQxwnWmN0YEdVM1hMllTZ2c2Cvlwv5oZfG6s6JMHSZUrv4/5/nAo4TKReoPuWA5s+8/BNqapft9H6agRKojBDPkQ5fdpJqn1SbIVFqoUp4ssMCf//VUHHVIWMKhSBUkhQRyQYA+kl8xj8fHnwjHx7czKrYHJa8tUpuULMBMDNftOEj7tnBlBfxwr/GawVf8A1sBFMxjHPFIxQHtNv2A13NApjGXOXLa5uk0Hniufij2q7s7nbblsfWCUmB8LfAPhsnKcYKEJnAT5aFEZtIFUU9r0ZHOOZZumbCLCjGDCpMUE8t/f08vfcH70LQKhH/MyCsq5LAHBxVO77r1x6aaJgsPTVhocJ1eOJGv5PDwzMUvKQlW4uaPotw/prA1I6U3+o4lfgteIzzVZ7MMNGU5IIgWVpvlDsJ0p0OnwmgHmR/n64PLheCUZWfsei+tr+zTFp9gUYDJCExBi1qSPulLBiEXLwWGJoTYTZT6xnA+4j9Sxx5lNKXgJ/KFpZzEqcRF+hbcTbWy03sgwppAaQsmZFkdapHn8wf6dB+r7DUw2DhoY4JWs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0761e4f1-f2ed-45b3-fc9d-08de5e638fa5
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 11:51:23.8957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G9T1ojqjVEyFSReI35nvAgJ0+Ynk/fkoS4ZnFmAFSzIrDwsNZGRkPCYsm9s5yueX4LEjKDJ1zOg83azsZLVFmQtktA61KqDAd71iC6AgYZk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7402
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-28_02,2026-01-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601280097
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI4MDA5NyBTYWx0ZWRfX5fIUY9ZVbIeN
 6gpDzpOfcu8TJyta7rgzor50aEkWC/LlOF/n4JRtmjqLs3LW4ZWVGchnWwwt4AHdIUJTWqjWi4v
 +ECwd5GWMMZJ74V677NgonuR/XSHD2onpQuEoXks914HQjL2SenRNXu/fhAqQ+EnSzGQsugpYY+
 YUuSDZ/1FkgfTvxWVb67f5HwG5jT4Qxq4fbpDMw+EckWyLzjOBzGjdC0iL9JZUCPCOKHNUUcY/o
 kYxSgvksFRjNvznHxTwtVlD0swFkvWPGaiJ9pER1Jhn6+Gw9D1mRIEkvtJkxkn3dS9XcOCO8B53
 s22M7ePmHB9q8p1P7ITNfbc8Z7QwPff9cAxSPj2TFacfuugVFo3+Es8RADFHB9FC5b6UTu8Nwtn
 xguwwOiSmxeH4BJY3E0NBFmX9ZNhMHuhiAGGRxeYN107JxAG9GJbi/mX8bQ+DglHJcD+ouhtsfy
 KtI95MPXt/eNO6hyZEz9YjaA6wSKSgdnvXiBYilE=
X-Authority-Analysis: v=2.4 cv=a/o9NESF c=1 sm=1 tr=0 ts=6979f842 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=dzMpxfCzW8yKxpKOoucA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12104
X-Proofpoint-GUID: aaVHLYy7FljPmEC4-WjMnemquTfCjFF6
X-Proofpoint-ORIG-GUID: aaVHLYy7FljPmEC4-WjMnemquTfCjFF6
X-Stat-Signature: ffmz7maaj46gg1eyoujtaaca1nc4siyb
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7BC78C000F
X-HE-Tag: 1769601101-716557
X-HE-Meta: U2FsdGVkX1+o+les8TcdcMpRNwwSkUXv6NcL4Y6epGDwNyq7+Rq69w1+maS6Wzy8NyCf4CMGCM4kn9pmeahMqVwEJ4w6jvNEDoSD+QLPQBeO4QXtKF4HD7mARQ1PaWrOpy1o8R8qv4GoNDwb43qMWzaN7q+c7WbxXYUO9vSY8B/sn0GTM1kNLiWis8/qW7UJOu3ux8pZryJqtM7FesrhJL2xT7e2gugUMvB6B2bJjwaj/B33LjzTBnLTFI5JFrDdgmGJ5Mu/G+sdySUpXAPNlGjExf58BsJeQSYvDIkHVVW5oHGXLGpxjguRNxfw+MKWvnNX1unni+IGC8BdZx5jCqGhpu1lKQQ9Cxi+GwM6qkROTPdv9TSjF1VcJMcHi4bdSNNtDlvEqKsDMTWlFrOT6LetVLqTzteP8prd42eVstu0l6fP4qslbWtHGZp+Dgn1C5Z+LyaNyAXC7lCppTGAO1SBy/Je2UAvOHb7TWW8AtgnH5wu24OlfwcJZyARHj7Mb/PR112xVZanR6rZKDjloMZQwf3I3mQcilFt6DHBiyWjAtYS9sGc2DFInYBdC7853D5K8jWT5O6WiCiTB0TNDLr0QZz3sNH/MTcUOhRAT0MrauNSETQ/2ln2f4YdIcsgPsokv6ZDfEVA0Slm2myBhRx6qMf4BQjIvnMfWbzrUzCw+Gbw9i5GfAjQH11LgKgBmUP3rJGY8CNPGa4v6yXJoS8xsLHkO0It4qp7UVIuBi6k/hffo/3uflSfrsDWvODm/fGl0/xEbk3Z9NEvNMal+ypxALg9zmIrlB5MZyBJdW615wMaDGzzSxsjX6drPX/wrDsq1UpRX9PxTPOh9q0uIbFycXtjX1OlYVZmUwj3y4pAdpD5OkmqWcSD+Sa3HyEDmioyxRekeakUcAATpL1StvauB7GFEmfE0ILlpdG4jZ10bUFsV0LNLrCP9/bSb1ky3DlQz1fqfZF5oKEQTst
 1Q1r80u7
 ewtNQ9HWVE7SzSfCbPb/1fqFTFQ9fBvfCNBPnpfNdjZt3F1Hdm2zWyBQeoKCezrc4S6Vbv24MT8H3HYZLtd+P7gVq4OFyz026YUeJ7H2y2Ijzz9mDJRTXrxPtS0A6lEbjCJHiktrhCcPg85KjJPmdDyMg4VclAhNZPDgsencB326H1iE2ghpNExq71bp8984sU3P/U4r7G0d1biEu8QCF4v/FwlAnMvaCKhIY4gZGXRCxje4qqUW7ZOr5+qQr5OdSgEg70nm706U6R0QUsCR+dBul+NVxlPPrW3sIQs4d1gb2bCIp68/xAeGtXFfDhWixtitxYsb16j8FMvA+LlHpWf80/6wTXF/1jm7hwUz1Ag0sHlxK7Sdu9VFCd6SWM0DYZsmMD/ZVWNVjqW81sbcXH4u/9PjwUssKpQAbVk/McpKuzBgaxdXgw0MIWht7efgj6hQ9PIH8Nuu8WbMQtiV8NRyKHQ9segRKLsobnthvFRMv1VlDqAnXe/GbFXZeiu+17RyQUKlPZIG8rDgHRDoRwO9w2Jq6O9BimyD0U/2ug9bmADVWsV63ZsC2AtB4rP5ZyZlH9RcHDg5N7X17nme2vQCEqDZ24kfCzQKz/SbSHkiUZWKu3/gLIOqNnpO9j2sXteCUKneVLirKyNoJ4PiW4Ccgc3W+ALz9KOQ81V4f/2vdXtn8Wza9uzTpRYLqMigcmQ7SMkTg0TuzStDT+JrXqQ1wPClOy+RLojRgRgycWxjXDEfQ+aXgUZgKhDj7uwJ3d4eJk0iP83YqWsJXCQX2evPcu649io3+T7TfaBVZtN2ePrAkKCqMlr2uwA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 26, 2026 at 11:21:29AM -0800, Suren Baghdasaryan wrote:
> On Mon, Jan 26, 2026 at 8:29 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > On Mon, Jan 26, 2026 at 12:30:04PM +0100, Vlastimil Babka wrote:
> > > On 1/23/26 21:12, Lorenzo Stoakes wrote:
> > > > We don't actually need to return an output parameter providing mm sequence
> > > > number, rather we can separate that out into another function -
> > > > __vma_raw_mm_seqnum() - and have any callers which need to obtain that
> > > > invoke that instead.
> > > >
> > > > The access to the raw sequence number requires that we hold the exclusive
> > > > mmap lock such that we know we can't race vma_end_write_all(), so move the
> > > > assert to __vma_raw_mm_seqnum() to make this requirement clear.
> > > >
> > > > Also while we're here, convert all of the VM_BUG_ON_VMA()'s to
> > > > VM_WARN_ON_ONCE_VMA()'s in line with the convention that we do not invoke
> > > > oopses when we can avoid it.
> > > >
> > > > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > >
> > > Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
>
> Sorry but I have one more comment below.
>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Thanks!

>
> >
> > Thanks!
> >
> > >
> > > Few nits:
> > >
> > > > ---
> > > >  include/linux/mmap_lock.h | 44 ++++++++++++++++++++++-----------------
> > > >  1 file changed, 25 insertions(+), 19 deletions(-)
> > > >
> > > > diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> > > > index 678f90080fa6..23bde4bd5a85 100644
> > > > --- a/include/linux/mmap_lock.h
> > > > +++ b/include/linux/mmap_lock.h
> > > > @@ -258,17 +258,30 @@ static inline void vma_end_read(struct vm_area_struct *vma)
> > > >     vma_refcount_put(vma);
> > > >  }
> > > >
> > > > -/* WARNING! Can only be used if mmap_lock is expected to be write-locked */
> > > > -static inline bool __is_vma_write_locked(struct vm_area_struct *vma, unsigned int *mm_lock_seq)
> > > > +static inline unsigned int __vma_raw_mm_seqnum(struct vm_area_struct *vma)
>
> This function returns the mm->mm_lock_seq.sequence attribute of mm, so
> no real commection to VMA. IMO it's better to rename it into
> __raw_mm_lock_seqnum(const struct mm_struct *mm) and have the callers
> pass vma->vm_mm.

Sorry missed these comments.

We are only ever referencing in terms of VMA's, so I think it makes sense still
to pass a VMA ptr, even if it just references vma->vm_mm.

I think the name of the function also makes things pretty clear, given it's
called essentially 'VMA['s] raw mm seqnum'.

>
> > > >  {
> > > > +   const struct mm_struct *mm = vma->vm_mm;
> > > > +
> > > > +   /* We must hold an exclusive write lock for this access to be valid. */
> > > >     mmap_assert_write_locked(vma->vm_mm);
>
> If for some reason you need to keep this function VMA-centric, then in
> the above line please s/vma->vm_mm/mm

Ah yeah, maybe if there's a respin? As kinda trivial thing, if that makes sense
to you!

Cheers, Lorenzo

