Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF9ADCA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 10:44:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 423188E0057; Wed, 20 Aug 2025 06:44:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FA8B8E0003; Wed, 20 Aug 2025 06:44:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C2C98E0057; Wed, 20 Aug 2025 06:44:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1A6648E0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 06:44:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8C6721384E0
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 10:44:25 +0000 (UTC)
X-FDA: 83796801690.07.92CD8F4
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3FA63100011
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 10:44:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PTnBbYAP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="VCoG/8Es";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755686662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=39lHsnn6DLZT4Kk+wcmJ2NPU0Y8ZC0FqxCIC+mIF1e0=;
	b=infbQa41l4ISbRgubeE75KbxwrcI8/uYP2C4nJ2Q/S2S/cN1YPdHOmU3c83imsFNP9BVmi
	VgzVNSPRs3V8QT8qPnNHzFNfkFLGvdPxVNYwIP12/cZfGLsx586YFxnEKumInTbRXBug+D
	95JzcsHGsmGK950KS9rAJ9IlT1JG1ys=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755686662; a=rsa-sha256;
	cv=pass;
	b=asW/iyX5Hahe0I0iotMSBnYlcaI5SLMq6eGnL7Zel/ngxGC3diD7ZEUPOtb7RRSdcWCvbJ
	VpDQNz1zrEAehrTAP8Q5YGjsAA6C1Z+LeqO0HD19a8c/YtlYz4qNS8e6NB3S4wrt9L3tUI
	mFHsHVQrWkcnANU2D21bnP3giCW4+J0=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PTnBbYAP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="VCoG/8Es";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57K9412X007232;
	Wed, 20 Aug 2025 10:38:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=39lHsnn6DLZT4Kk+wc
	mJ2NPU0Y8ZC0FqxCIC+mIF1e0=; b=PTnBbYAP2owqeIucr42/Fa4HOcyEcLxPRw
	CsWMBW1PzgPgnDlLtNe6GaiSYq0VW8Ek8P03UD3L067r9MasPSaSVzyx1w+YB9cG
	SHaec4E13o+la7nMV81WQnz8buSiOxN9vR7NOOD/QmHdlu1kfqC/UKrwqQAChpGK
	rx2ExAcq4+5Vsw287WxfcjgV5rXO8s8qridM6ut5rgSO2ngGf0OK55Ha6ZFzg7+8
	cYxa3YU8DWrFQ9tm8JuBB7OZaTuBKa9K41kktuG+TA8S690HCf2t84yWH1ugEkzN
	L0hE0xt/cdjFWG5HUaIw4tCUREcnLWEa8llRs1z+t5+YnF+bIh1Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tss061-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 10:38:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57K9tnqH039566;
	Wed, 20 Aug 2025 10:38:56 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2057.outbound.protection.outlook.com [40.107.94.57])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48my3qk8x0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 10:38:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hv0c+loc9v5rY810A6zb6yUOzt/iWxvAd86S158p4xDYptLrbWzJ1rBQ8Cn3sv4opYVIoom4sGG2jye/Nf9iWSuUaMBr4w0lPQjcn1WR+mrpn5WdNq2XwjnHbb4BgALHHPAzabeXGTevnsevigbLbeBbRSswa/MMmBwsg03MrJ3LRcuJha/hxdzPO54bRMblA1PyKqvDqlCom5V3FWcY4Verc6cVVEwL3/xH0RbSuFOqEJ5E4b8udU3jKZ0uYC711ZWp/NrMxvraiqh8IuXg2Igxp8hiYjB3+SUNfnkG787zWUxeXBCdtEwWB57ZT2N63rY6oVxfWLkHghAMQLJ9uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=39lHsnn6DLZT4Kk+wcmJ2NPU0Y8ZC0FqxCIC+mIF1e0=;
 b=krg9ObHUnF/OwzLk3JTevuPUKGhjn5e0xbecTvuwOEc5vkevOxamXJkZQGu0/qbMByV+Npjz0NrfJsarmS62n/62hA4GR2I8pEcFmppe64ws+SOx//DlK0Vqm+JLQuxuvEQCwp50WmKat1yw3QHPZ8i+hv5XoMX+u1kp153tAq4h3TANlqQD3k83SpPT5GiTEsXoT66x3F4zWjGEbSS9CnreIvRT6BbhJFXbFiuj72K1KG+JSJvT1WT0TkeJBeKXgm37730v0CYxMnl0KyP1wQlXXIc7nWycVHr5fZObdBP73J8MPGK11zuGe5y9mwMqasqLX2FeABvhKcWYUS5LMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=39lHsnn6DLZT4Kk+wcmJ2NPU0Y8ZC0FqxCIC+mIF1e0=;
 b=VCoG/8Es/FeTzWFo92TmBIVa91bfDz2BP38A3s51o/cGnATYnx31McUVaC2fSD9yjRQ+I+QwOO56HnD2wcrh3hwguNbms3ehnofEqe8qjSkv3OlGM9251UkNF6w8DQmd7dVRDwwgSqpZoqZUR1u3spVJIMW15kxp8dbRo/eBThc=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM3PPF0900B6F69.namprd10.prod.outlook.com (2603:10b6:f:fc00::c07) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.25; Wed, 20 Aug
 2025 10:38:53 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.024; Wed, 20 Aug 2025
 10:38:53 +0000
Date: Wed, 20 Aug 2025 11:38:50 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
        corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kirill.shutemov@linux.intel.com, aarcange@redhat.com,
        raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com,
        tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com,
        jack@suse.cz, cl@gentwo.org, jglisse@google.com, surenb@google.com,
        zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
        mhocko@suse.com, rdunlap@infradead.org, hughd@google.com
Subject: Re: [PATCH v10 08/13] khugepaged: avoid unnecessary mTHP collapse
 attempts
Message-ID: <300be96e-6029-42eb-b284-e659d815ee8a@lucifer.local>
References: <20250819134205.622806-1-npache@redhat.com>
 <20250819134205.622806-9-npache@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819134205.622806-9-npache@redhat.com>
X-ClientProxiedBy: LO4P265CA0235.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:315::12) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM3PPF0900B6F69:EE_
X-MS-Office365-Filtering-Correlation-Id: fe5ce496-9567-418c-642b-08dddfd5c20f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?v8EcEpBKKso16UXm52M9cr0Cp9AbdWgM0hcE2hGwbRa2rZtvebqJ3WMsjAj3?=
 =?us-ascii?Q?9b4VfjR7dY8+OH1ZtRh+wx1OUCl0Dk0AtRCNS5KNsVrwb4OM1lBSsPptLAE4?=
 =?us-ascii?Q?GXkVq1bmPC71K0oX8CwWpBO5rAkg0BcURRdsDcdreNilM2qltwEt7nHXkhvs?=
 =?us-ascii?Q?MZocOoDAzfvZ8FLwGculCX0ggIpqWDuP32hdAwRAT92OR4wDWvRfyLJGU+/V?=
 =?us-ascii?Q?A452wSpDopshucTXK0rnSsUm+J7rwyBZV2kK/6cmkpgkA7avB02xZQKDumIR?=
 =?us-ascii?Q?ZhgkoScyw2aubZi+4ExSmxP+xVNccRPPIDmkV7LHL3NDIJRxF/W9OIE1YNow?=
 =?us-ascii?Q?pqlQV//Szj1SisCyJy+jKHUMMJjgr+9qB3xu4f8FrkPNlmW7rET4kZNo1LCV?=
 =?us-ascii?Q?NL5YuYoJBUUTpkx8HEBCuR0Hj3jLT1CAizwWnLYE56gNNaqPS4q/8AzSrJgb?=
 =?us-ascii?Q?66J+XUq/fDb10emZdBXRuDa7PTrYR1E1LbKRmVpaJzuRt6wHN4bjc8zb/2lV?=
 =?us-ascii?Q?9Htr/Mn2J2RHMh5whYiUB468NOMgNnCpsz1oG0XmD/1zvsebOZV1CSXyS+b4?=
 =?us-ascii?Q?GXj5gb3Vuwk55rTsiYlSuukdxAVwlR4wXtq6Nt9yqL1G5qmoTqWWiYRu6hlQ?=
 =?us-ascii?Q?aQzFheADSo4HmXUUMQNKnDjV7GAan4jiUMe0FaTpr7320+mlhBppLORG8A3B?=
 =?us-ascii?Q?UsFrRRv+zWt133RFwHaNiho4oVpAPG4uZPesTr1UWSDL85L79Wze8wuuXpmN?=
 =?us-ascii?Q?BhL/sTb6ivQBFkLIDVkHmhTUpQcwHrafH3jMRaPCM2wsw2MQNx+/DRyOEr0E?=
 =?us-ascii?Q?KaGShPFUZqrH8N9s3O+IAFj5mgcNlodckCFvR3h4alRG+KvSmZbEk4qCKpQH?=
 =?us-ascii?Q?0kEsozGi9IdYBMSqrGaEVvecKltZZnwiW47m0WSj8gO6LC2H8swtVdHFZjXA?=
 =?us-ascii?Q?cVQbzA7q9KP0V3rcNbbC/y1Fzu+PYOdEms/ynHCt/ouf9VroxbPBo0w8PI4u?=
 =?us-ascii?Q?85Yg9dca3h3V+a+O8v1KgrkyrYhSVPMaqndq35Zyz04bIo6ZfzHb1inY/uOq?=
 =?us-ascii?Q?rIitJgqfmLOkf7uC6byg5kQ7bFn5k0f1p1gUK9uBs5TnSS8c6RmDbmxOAMK7?=
 =?us-ascii?Q?a94DSrgeDRk05SKW1Zn6lTanEZ2AhacY2H+8DUb7FBfzDMlnn2Qkxr8NjDmZ?=
 =?us-ascii?Q?dxJYK5j9giQdE2AiBgMFWCOHyE5qouE3lbxLkySJVYBhq8GYwa/OjNG8lJn9?=
 =?us-ascii?Q?hq+TIAFUJdJo6GxGWTGBKVMHdXBkxGVON2CGQrU6x9nkXAeJBoJeDXlXUuyn?=
 =?us-ascii?Q?5hzQiWZ+H0IK5j4xHECkIqPwre1G48nCjy/rPdP3c6Udnm8iBeK0Ay5DeOFN?=
 =?us-ascii?Q?/CfI4lDDnayFzcGAZAY6e3I5d7otmRxM5hJ8Bg15nqNbEkftsg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2Aa9GBSU0MN0WSCWcVoOlJmw6hswJRMFnp9r+7km4n4PIgx+44mGmS60zmf0?=
 =?us-ascii?Q?idbtC49jzbYlAwhvXCMw4FO8NmVbHcti/cN7uY/VIXvnGzK3O7dBm/0FU2F1?=
 =?us-ascii?Q?GjpP0KhR9WOEVkyatrXYH+nbMXZEH/aCwQFPeCaV3ckbWzyRMwGIIz9s2dQp?=
 =?us-ascii?Q?8Pcr9NY9MnBPhUotbzsEZjpKLdPEzcdKaEfx100Q6/XVxy2fvZJs7fwTqTam?=
 =?us-ascii?Q?IIw3wfu7xaI0dh2RqWJd2Ol/uvbeFRjCFx9RfTXws8hTihXF0FgILr1kMFUC?=
 =?us-ascii?Q?H6Hfhdkvu34U2bG73lMFFXAj/0buVQQK8gSYrA2DgivCo+yqd9XutnfBFLZ2?=
 =?us-ascii?Q?G1VsgV5R324cEdRCUNrc7ShPlLLkrRohfmm5LGld1n60fj3ask3wZM0cqj+j?=
 =?us-ascii?Q?oxuoInemD0hr8odFq25aEzgz7eiHIDmsFy6glX/vV21SC0cjMtXlsiw9Ff+h?=
 =?us-ascii?Q?we2RtMo/Xo7GyoVaXiRcEfFzcsfcuD/Ye4N2FzZuHV9QvZothYzMP7S3BouK?=
 =?us-ascii?Q?ja1OYUMLoPmkYmHcGeVVlFlgbbMkpnC6exyJ46kjVOavnbmoAhuD11HU0yPr?=
 =?us-ascii?Q?pWHZh32uPtC9Ae/N70VBY3fOqJfPg14qzzeOlnowhG5M91CJsnDdhLF6+gLd?=
 =?us-ascii?Q?yczFb0KckGELEwekBm9jKF2WrH4dA9q2MCRh6cQwfup8clVmCDO6P+vLRfLg?=
 =?us-ascii?Q?0zL1019R0tdtL85SWehijVyR4um8QG17bEfEawLHG4ecV0Uh0I1YM6zWBkTE?=
 =?us-ascii?Q?n4Cb4PUYN/K+CJxOCRBy9UZY1EeOgcDCHZytIfN6I0LvIZbxFlA22gJ9UbCW?=
 =?us-ascii?Q?NCT1k7WcFP1EZLuwDhxzz33Bbfy5PM/EYo01GDUWAY0sbTZXqp0KhRIR2iSx?=
 =?us-ascii?Q?DC6uq9Kz8Bf6auEwYDorJVuDzbyPvzdeZUCG7Y2ZMltumo/MmXT3r0pkWMvA?=
 =?us-ascii?Q?DVUYPwn9U8DAMRVpFdwgQoZF8ZxJRfIYXt9C0g2euqK0UqRy91ztKi+vBUVE?=
 =?us-ascii?Q?wXpMUiQnHp4LFTyqfL/ubbp7eqGr/0cY8muDMcuMkMYyOr8h4ikI6z1rbtvC?=
 =?us-ascii?Q?bRTDHLcd3oXVebB9A73Ij6OlWiL/GlZekxLA9iNBA+msfpxEMRziZVLDXZNE?=
 =?us-ascii?Q?aEXthUCSbJ7btyr7IWwxoWceUPjCyyMJXCU/1Q7EIy09Jxyh2ByENyPXE1rF?=
 =?us-ascii?Q?KDdUV+eKIXdwxNR/Gsq+94jNtHPgB5Ye7VP4TAZVvbRPshZH32QMOimlbmhe?=
 =?us-ascii?Q?yF4zaB7yCmmedbSn96i37ron70e+UOxNZtomD8EcopqBdqd2etcF4hK2XkZm?=
 =?us-ascii?Q?v+xIT7wuEjc+5Qd35LZ9KcK+fcb1y8M0KjYSGSQQbRDuP3KECmGHbxwUVqlM?=
 =?us-ascii?Q?OYyoD9+AkYI34mbetoCzw4ba6wesS5kfdvAGZvV99WnIe+Ph6v+9a5n+xaBe?=
 =?us-ascii?Q?CQyd8o7fP2s2qIQXSfcxW4K2Ufs23ucGijr9IbQ1Bm88rdnVzWF0RaE5BSxd?=
 =?us-ascii?Q?jyYtigIg4y2/PSYqiZfL0td7WGefgla6KVQGJfG2dckUH2+p46E3DL47Em2X?=
 =?us-ascii?Q?MUkCrjKTitjAuljiho5ToYpBR0FUPIy4aSmcNh0ytwOETbkgJVt0Vly5xt/p?=
 =?us-ascii?Q?qg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eyk+7Eg0Sk9c/sI3TJVcNhXoSrY3CgzN4UWFyKoSe+C9QRwIazrlw9KjzZPs+QzeQyNS0GzTf6HlG0lUtyqivcCgHcoDHYHUSbPqxidKytWm33pbkfQnCR3aw6mme6iyOYbh7WTTTL6OrkTisdZXX8Fi51X9APoqEYRaxioiAeWgs2CegaQG/hx3cAHwIg4l7aba/B51RWySNOwgfD7rChB2bnJMet2t3ifc4ywwXnRuCPRuSGnsteK7HR4ZTiEsTAeJHGgH77/60UznMdkeEdkXUL8+n80Vgd0joHq6oj20YKQqn9mdOWEgDab9WkZToQVYSMBdyCWwG5g7vtzt7FBLBUcfkAP9ZOWPKOyOTQ2qhEtoQqW8SWuU/Xp2490AMyg0vKdOxPTWNFK/pgVM+V1mnmUO1o38zpa2KqcSgb3Vbq8Hx3SF2RhC6rvkS6chiYk4VtXv1NIpv+daNZYN6AoXFlZRxV1Ni4hKaRBytbeRaJe8fdEz1idgieQd7dH3QrT7IpOelhN7JT/NqYYGGmj+2WmV+6rnrBnwpunAMZ7rl81BjHy671mxd87HHJscha3llK+vNmHMNcX77HU5ScDbb/HrNzXlXLyrrlFHJkw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe5ce496-9567-418c-642b-08dddfd5c20f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 10:38:53.4096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PJiBqX5OYTTYSyo9vnkfD2BBKTGnoQHaMIQfiUPIYdgEMy48x2mMd+mykxVRt36lhNiOHkdIHICQPqb0jlhMVfEZ5tRJn+GIF3pTo/YfjME=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF0900B6F69
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-20_03,2025-08-20_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 mlxscore=0 bulkscore=0 spamscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508200093
X-Proofpoint-GUID: BbHVXmOSppuLvXg_3ypttL6yLXJ9fC1A
X-Authority-Analysis: v=2.4 cv=S6eAAIsP c=1 sm=1 tr=0 ts=68a5a5c1 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=-UZBVonvdr6tOHmRkHYA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: BbHVXmOSppuLvXg_3ypttL6yLXJ9fC1A
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfX92SI1Cpe3vH6
 Py9rcHmION0eCkS1If5jIgPraxGjXLwWu6z1Moo2coiavfO0ep7dvwuZeH1npnIjPeL1NnpglTG
 8lJoxv7hdVGz37wGFz8dHaHbBbQJw+JL1oXk+wM1n9E0RmeFOpN6hL+1qLXoHNwMYGwERjBEu27
 jwpRZnjf4KnLHfUskqabpmBdu/sP2XmoWO6r6uWlXE7F/XIojrzP6J36pSKXkzQEMJTffZ1pp6b
 iwG4PAjpOR48t1q5Jdt395HWJyP13aNXVtAAI4wkLZqeUymGni3+0kge8ztOeqLXH+iNJeCc9TP
 d7W7AE7OuB44Ty0ygBt6Mdv4WuWK71ft9tO0y3vjX6xP8TdbzQOnXadnQ9r5UwYK+YikJbCU9XR
 VpoiSfBbrEzvWeG/J1ie9ADRo8P93Q==
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3FA63100011
X-Stat-Signature: 7akherde37arbgyowt4ac8h5997wfbds
X-Rspam-User: 
X-HE-Tag: 1755686662-890694
X-HE-Meta: U2FsdGVkX19RkV+Q74JyP5sq2i/DpQF0BzE6TQgnh33ch1SSWAKy2sC3e5PgkxklsEj4lYyDmjRMpyF6nupw8k3R3zd9hQljMyz6pe7bt/CUBHBA3OIxriUb/xp0qb3A/OpHM5qI9W5EQ1O24XhII1XOSGNEbEMMP72DT7XxmhTpODJT/lgwGHTwiaCOY/uczEkszkIizfdeK5UvfloDYi67ZAtMxGT8NQOPjWh0RbSysAdp1qQuytudCC/8gTlATA73pKe5+02f2HfSah2KXWQBJ8J2hGC1Ukwz1c6b/1jC5lXw7UK708XPOWgxmEjrobo9dAlDn+sFiHzFdY0dPB/gNP7HQKBRf/8L3iTa79O+nLf6QLBa7N0B3fwVWVJ6zHya7Hq1VtNRAdHcZCBrPID/GxxZ/wKN5/cGxJGoLXPD+WUNrFJTzee/nsTUq6gDVfJELGecvrTdtgymVKeevDhvXH7Yv4dVmgbWwvHQO26XZLnYCQLcmsSXTtC1TZicmb0q3nDSE+ffY9L6lVGmCWqxkzRBXYjk+Y3YuINIdySJZkqeUHNXdvFFJ5EBgmYtcPzBzqnKOmDUtwdNsJPNkEv5pm8Jajzy1ODfCMoJQX5gmYm2h6ERiRxLESd4IWy9gEWA66t9dINWbnztvzI9GumNpvlsS3fnSeqtJupehCydBtKynsCkKKeEMGBn/XfQii81/tXJJql8Qkq5PFLOs9J/hZzEdBAkovFU7iJkmRXd6oubIvmCl3yYkKe66CPyE2IEMjcDei2KNVFdrsIf1DZqeEGSZIUzN/ErbS3qPAeh0zPUuUohZVZBcWp169mx8B2VsieGbmxkzi2b9QG3XoYgyj0bpW25I7Ao6nFsNUl+dIyUXaeOEueyLaCvGzGnYTcfx/0gT2af6B+n5v66UH856w5UeRf04lj69zT5GuxxQv2J99a3/L9kCia+t56QghUaHedcFcZyKk5dFRF
 XyGZ8Fkn
 cMFe86JHqhPwSDt1AFsr5BwzTMLJTSP/RIxy38MZNK6rNThdZgj1pRJCYVfRDyj65ldjKhNpeqXsQXyO9d3J6dgesCoXZUclXFBalUuwctweRyoDyLdUq5HYBqImI4vrgEYBeit6KHBZfF8g8j1LXrgjESUKXob/x38yGicNmU40XaJg1cCEYRfzaGkUyMveGOYZlzIg6CZmL/A4i2QM9MA4eLk0G4BPg6rc5TbsPlsig3qweMIxK/fqA8YR8/GVrfcyXjTx1pXtJwgAUq86+MPyn4SVZXZwJsyTziwG5uBCOPFqg0elmouixpJ0LlL0QpJqcOfo7PE7btqgjeSnJgoRWvK2NygXG+3/qgtYj8JfCVZUpak84DmYaUYi2NuZljJ0kUNFuw0wnjZII7VrhRDn2nrLjk5Et85FFf1WJmzEljkSwycYKgCMxPNC4k2O1Wu4XlBz9DF8VDJ1xhIYqiMWMGPKJFY537Y/SGviMtx/0ZtrxDuZjEM+5b5vRhOOQtJOlIszO2Wrnd2e5KQNxiKl7GMpskqAFXPiEbUaxPUpVNevZkvXUCHBOqxWBkNxI3xFJEQXZYkuZPyD48DgC2bzwvLqMEQs6KsrRqcBC175M9tuJ3iuWjBEZWQSz++Dv4wZ4E0NICTjOKUpfPI7VOVjvSEPaRkLcGgH+2gu04nIdUUyk55EIroqRpl6FIQJzC2eIXVo8eYj+4sV80IwneYI0c+t7TmFtpe7q506VRWVLKYqoJxre7cUYrUp8aaSE79xqkxeQ50fUv1uTYK8mfwMxFWC7eIyfoWQ3E7OLMcyWHm/x1jproHqF5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 07:42:00AM -0600, Nico Pache wrote:
> There are cases where, if an attempted collapse fails, all subsequent
> orders are guaranteed to also fail. Avoid these collapse attempts by
> bailing out early.
>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 31 ++++++++++++++++++++++++++++++-
>  1 file changed, 30 insertions(+), 1 deletion(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 6a4cf7e4a7cc..7d9b5100bea1 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1389,10 +1389,39 @@ static int collapse_scan_bitmap(struct mm_struct *mm, unsigned long address,
>  			ret = collapse_huge_page(mm, address, referenced, unmapped,
>  						 cc, mmap_locked, order,
>  						 offset * KHUGEPAGED_MIN_MTHP_NR);
> -			if (ret == SCAN_SUCCEED) {
> +
> +			/*
> +			 * Analyze failure reason to determine next action:
> +			 * - goto next_order: try smaller orders in same region
> +			 * - continue: try other regions at same order
> +			 * - break: stop all attempts (system-wide failure)
> +			 */
> +			switch (ret) {
> +			/* Cases were we should continue to the next region */
> +			case SCAN_SUCCEED:
>  				collapsed += (1 << order);

Yeah as bot noticed (and clang locally)

This needs a break or fallthrough.

> +			case SCAN_PAGE_RO:
> +			case SCAN_PTE_MAPPED_HUGEPAGE:
>  				continue;
> +			/* Cases were lower orders might still succeed */
> +			case SCAN_LACK_REFERENCED_PAGE:
> +			case SCAN_EXCEED_NONE_PTE:
> +			case SCAN_EXCEED_SWAP_PTE:
> +			case SCAN_EXCEED_SHARED_PTE:
> +			case SCAN_PAGE_LOCK:
> +			case SCAN_PAGE_COUNT:
> +			case SCAN_PAGE_LRU:
> +			case SCAN_PAGE_NULL:
> +			case SCAN_DEL_PAGE_LRU:
> +			case SCAN_PTE_NON_PRESENT:
> +			case SCAN_PTE_UFFD_WP:
> +			case SCAN_ALLOC_HUGE_PAGE_FAIL:
> +				goto next_order;
> +			/* All other cases should stop collapse attempts */
> +			default:
> +				break;

Wouldn't it be better to not have this so the compiler asserts that you
have all cases listed here?

>  			}
> +			break;
>  		}
>
>  next_order:
> --
> 2.50.1
>

