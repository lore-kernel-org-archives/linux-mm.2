Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 018D8CD5BCE
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 11:56:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DB988E000D; Thu, 13 Nov 2025 06:56:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 564A28E0002; Thu, 13 Nov 2025 06:56:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DEB48E000D; Thu, 13 Nov 2025 06:56:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 21DA78E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 06:56:59 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CBA3C12E6A7
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:56:58 +0000 (UTC)
X-FDA: 84105432516.04.1FAC65D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4A7C7140012
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:56:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hLA+Y6Yf;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=W3xu4zNE;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763035015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U2FqTNTKJn+ilrIp8KUFv8foXlWNP8unCHHc/yEmbvY=;
	b=yqw4Pz6WTr5ztJpSTPYQo+GenO/pm2xtu3JriaCQK2T+FLysUCx2iXL7xQOaxxeAK/dbUo
	rRhfvNqpz6txN4qzAJvm8/6tZ5QnB7M1tiTO5jEpOl08xVbMLtbtISCc7BoTFI41d6mBIi
	0N0IqQufXPfceVWW+3KX6/lk/DHAh/U=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hLA+Y6Yf;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=W3xu4zNE;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763035015; a=rsa-sha256;
	cv=fail;
	b=d+I8WFpYrsOEqP1Nl12uI9esYnOK/ExtK5m9keuAALgsGZibIrU/7mxxy1Y8rom29eWeDX
	YqL8nTIF1CJRov5f0tnUwv+lvfQ/5Sepims/5YdzTO31N++L00ExdjPo1DMTujfiKCxUbi
	+1EiCswYxE+1aSv9ss9TZMyyke2aPyQ=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD1gVhp019554;
	Thu, 13 Nov 2025 11:56:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=U2FqTNTKJn+ilrIp8KUFv8foXlWNP8unCHHc/yEmbvY=; b=
	hLA+Y6YffDLQOcPOSN1Y2/Zx+9ROWHXZ1oWyetBu/HoHkYEV7xpBpc/bL0n1cERK
	dB+izicIFGTbRtHR9F7dT3fp0xGEMgNSkyVfx2tYYO9GcPpJgM7owztZ5tZ8hnhR
	dQXn7H15uHA+HOQefXBsrZuMDmIe5OHd1pN+s0icshGpTFhSpCFQqDVVpVHJu5T0
	QRa6Rd+sNRV2ETDM214mHRBGh9FkAitFwybaU8kbzNotyktgXzOQo18NlAOR9/Xy
	T7niDUNi+aDrAwilbNnFWAR8sJPTzsHSMq1ZH64dtck6fs113lsIqQNBqu8pMvx5
	wAQReO3qhPxcBpIcLhgcuQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acyjs9jxb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 11:56:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD9hexP038522;
	Thu, 13 Nov 2025 11:56:46 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010011.outbound.protection.outlook.com [52.101.85.11])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vac11qh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 11:56:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ag1DHyPrJeWic5ZPc+vJG2SQU7K2+wFk7/JkvXZk6MF4gB+CskJJC/0Jdhb4+tymt2CtWZa5hAIt/YWPeW98cyOfdHzO1s1HB4HdfmCp6e5mbetICXr8eW/IlqYNBFxrcFu444iCizLvAm4WZKFGvehdvMqCSm6gGzAnqII7bEItFV1+zb1m/jarnB+OuiRccFzi6R0sGaez3djlyp8Ik+ShNKftCTgw9Tz2ehK/ggjzFCgnWxCMGay690vdlso8gdZXCIroQ+2mYOAeONCqIdOvJc33PFsWw0ssg0yLnt6P/PHGwW9rdAY/6KL5Lqt3D44w6UW8wR1MJM6ud5uWTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V16ynmfE4LghLYlX8eUJVQSObzI+1GpBqfXmIY+jr8A=;
 b=E9InjfeSgMsAh3egdtLkQ0QLsqr5V46megbEnmeclaq857QC/RmoImV5y455JHuAK7+IYkav5nltFV1LeqcYBgtCM0zGiubXgEoKDDAjOlaKFRYqoy5fo1o1GAxWm7Kfrgt3Hux4cXKrXo/skx+24Zhzp3F5lsrdOrtjE9ljbFX+QT2DPSe1tjApgbaph/NYy+3+n+/rroaWDeJGtEfBvWHXxvsrG0QcGg6kTXc9QKp1jnnGtDZvQQKkknMVfqWZ8Ozx8YLtSR0nMCliQ2AGnpdAdXVmZ17mV+0/m3lGxPS2O+rz0GSzKYWWP43uQH3dfD+s4Nw9XHbik8AGpqSbFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V16ynmfE4LghLYlX8eUJVQSObzI+1GpBqfXmIY+jr8A=;
 b=W3xu4zNELzjnXrH4zrezG/lL2inT1Sk+YZSy0+HImPGN1yQXR/WPOFW9+scv5Wo5SbQKuGVEwknReA3eAk9oIsHbV9idXncXSlEyIDrbKNX77V6EIttAjQMB7GVvMfoZGmI7T2DJL3XCuy+FcuphSDF3u9m0rixOAGJVjY3atGk=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ1PR10MB5929.namprd10.prod.outlook.com (2603:10b6:a03:48c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 11:56:43 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 11:56:42 +0000
Date: Thu, 13 Nov 2025 11:56:40 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Balbir Singh <balbirs@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        dri-devel@lists.freedesktop.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>,
        Oscar Salvador <osalvador@suse.de>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
        David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Mika =?utf-8?B?UGVudHRpbMOk?= <mpenttil@redhat.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Francois Dugast <francois.dugast@intel.com>
Subject: Re: [PATCH] mm/huge_memory: fix override of entry in
 remove_migration_pmd
Message-ID: <ed523668-92a3-4eaa-a999-4fb7a43e197d@lucifer.local>
References: <20251113051352.1753714-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251113051352.1753714-1-balbirs@nvidia.com>
X-ClientProxiedBy: LO4P123CA0597.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:295::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ1PR10MB5929:EE_
X-MS-Office365-Filtering-Correlation-Id: 56a3a8f0-789c-4768-d33d-08de22abb66a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?9TNMjGTL6yS8Yxa77++BC4x/+vWHqUJazajyNwPSCX6RMK/+LrJW8458F/?=
 =?iso-8859-1?Q?7fHbwzhtkWZU3BRxTJg6tQGWj58qnUuc658FUtMexIBpPc5uL9IPegIRDR?=
 =?iso-8859-1?Q?hQ1APn3r4vO4Z+eopB/5nGTRX97GuvBg0GicalivVPrMGSazxHcnbIqz6K?=
 =?iso-8859-1?Q?Ey5UzYn/r/Ag9cnb3q6jGMMXxXCnGmxHlInn1wxKCDeknaTcle7tFGMDsk?=
 =?iso-8859-1?Q?N6fnRGR3Wba6UCggOxuUhH5aSz9vPUL3//k00cZ1BMySRSmj4eJEMY/oyV?=
 =?iso-8859-1?Q?rCL77A3G9z1AkieasBVr5oYQ2uh+yeIDmlebfL+LNK+VjKY7X47PBnmRed?=
 =?iso-8859-1?Q?HLCIuFbVxTANQuk3WkaD21W5teuqLVIWTgnM8Q9N0t3Ryyx2blxwT2x4eM?=
 =?iso-8859-1?Q?8pPIE4azioVd4MeSfOv/W2RRH9EUmckLcc5pHYT0LIJK59VV40+6hKXNkU?=
 =?iso-8859-1?Q?KFqiCESuFAMJqz9KDsk8iZNus9E0sBHp7pGSStOB063Sudaku3w6i9q8UR?=
 =?iso-8859-1?Q?wTCbl0Y+FOLS4oIcHxXf+AZI6J+o1eSv1nZwGi+j9mAPFVK27e06a8JVwd?=
 =?iso-8859-1?Q?lt/24v2MvJNDYYLsaQD63qD2KuuCTeDCC6KY7blnItaWgCw6HofQHQTTec?=
 =?iso-8859-1?Q?WlJ25ohcp1u/PDmUDpJSZGU5MQO/JzAqZTkiu1Gq81Tw5LOLigDwMTNOyt?=
 =?iso-8859-1?Q?UVi1eExIYBGnrZMjTMLIM1inJCMD0wUWX0LJ0QGJC8gBGe6DCZAM6jzATh?=
 =?iso-8859-1?Q?JBrIfEyrSM8eEmEEwgkG5Eson3NdK0CCFMRau+oAOXUfYoEpHDduGd/nGi?=
 =?iso-8859-1?Q?EqE2+YIw7H9KtGDMl+kUz6I7B9fMwycjP/oR6ZOuLRxgBAW49rwdXL5oQv?=
 =?iso-8859-1?Q?aOnjnXTpE6BZxwvJJlyKH2GYgqbnbrWgQVkNxokt6/AuUYe9FFLtKw198Q?=
 =?iso-8859-1?Q?a8Lm7bAxQTf63etKrzVj1BVX1+dEeNehEMlydQwgXutTcaUzC/DkDZTU0f?=
 =?iso-8859-1?Q?Fow9lNKEXC6AalARgBItcZrWD34+E8yAMXX5pAsXH2jnQENUvijfyBriJk?=
 =?iso-8859-1?Q?HNgu/Z2tYo5K4kSnzMk8S7PYfjQ4qoZ2dt1MUhMV1VRE4RIm9rp2PjQl9q?=
 =?iso-8859-1?Q?m1zxuMHXaHOlluVSSL3EAZIlidYkVdOcZQCtSurx/dyEp8bOuBfJYxetuv?=
 =?iso-8859-1?Q?o0IKTNry4B7U6UtMt7zcYTVF335Gr/g6LHH/z+IDOqIXu1wvNlmY+/vvWz?=
 =?iso-8859-1?Q?1DPM1OMrS80+2tdD/B70suGx8vdQExXY659/Fw6FKdta7I+f8AjI/3t0fb?=
 =?iso-8859-1?Q?UgVZqOz3BstvDhsTCTzBW7ARregM6bLBWBhYgh6MsVm3x18Z80mYV3NBOT?=
 =?iso-8859-1?Q?BjiMdYighQmwaHspQkMZozkxb5HnFZMco7aAaYbVRoUf+0dasbxKhcb9E5?=
 =?iso-8859-1?Q?6TRLtqegOf5f6/Y42yby70PQpFxWIGLGcKtgMk/WP2yLodUHZlswPuenmY?=
 =?iso-8859-1?Q?GmjOQBvlUekoJjjq4VxZsC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?kTsegbAYjvWdXGtZDHiT902U3ViaoAivwktEhi5YWC7oJCk6IH95VrSHIS?=
 =?iso-8859-1?Q?NMiiw4txnqA/ILtH6cCVbMQjpj6D1dRcn8fHShjlqH7GuTKSJB7qpASISs?=
 =?iso-8859-1?Q?yml8PLoxGbXukC2p2TQvHBXIopne8OtObBpdqRzxb7AV+AfGIc8gJPwDam?=
 =?iso-8859-1?Q?3MAVtTBCEpusOwWvPB/xka0/7cUF8uwpzjQrZASmqthiN18Mt+T2Nn4iNL?=
 =?iso-8859-1?Q?I/2z3wiyR0dtMQLOz3jsDMDe2AZgxBh0j9SHzevBBm1WC2jxP2WZODb6Ph?=
 =?iso-8859-1?Q?cHQsOG5AIXKrutWn8+TVooNGR4Ce0lRyev66vbT7h8xFYiJ0H+9abmYt7E?=
 =?iso-8859-1?Q?S8MoVWxjYOAHndr618kawmQ4X5sCZUHAeiHhd59wvDIUIw33G/1fSB6Z4k?=
 =?iso-8859-1?Q?Kr0I6Yt+7lMqUorXB/ztmOy9mTnUpURtZMOns3NQ42sA8Dj4+bK7zYp4Q7?=
 =?iso-8859-1?Q?iCMCOmVWj3FBeFOdwR+/Rc438SRYgqSRF66HCkkKI/VhvC92aiJekol5kT?=
 =?iso-8859-1?Q?v3XUH2AkFn7q0Wpc8yf7Mo6/NKI1tn7WTiBonqkl4oXM8j2TEAjxWI96+w?=
 =?iso-8859-1?Q?mRwQbhTFoDuV8denLSMskRCF17JaC0Esh6EdVYk1mGI0rm+5EaN/lmJwCv?=
 =?iso-8859-1?Q?UGklF8ch9MDxMBTnXZn2bHmK2CdT+dQnVLLfMdaLxJ8ZbN1NcOaYdc5vSC?=
 =?iso-8859-1?Q?U3sMP7bMgtvtjS3utl+Vb6GB4oyaZ56/PbgS4WTWzYoclz9jKRBlOtBZoo?=
 =?iso-8859-1?Q?gKeUsr8j7Ym/HdCrNSSCQa9636ilggBj8doO3VHVTy8MUYOSk+V0150Klw?=
 =?iso-8859-1?Q?RvirwQ5JE2gp7upz4oAepQplvgmqUqriTUrpCUtxrKpQBhsT7EXz7nRzKD?=
 =?iso-8859-1?Q?83awmboL8UEKO0xUcvCwMXcX0NEBYGy4/joJmvl+D3MaaYOod4D90ejenI?=
 =?iso-8859-1?Q?A0CwH5bYk72I2FCO3L8KfBsqK/CvB+T7159Hg/x5gHB/Pl+DxkhOYafNNd?=
 =?iso-8859-1?Q?FTuE0tlkuxWWlG1wUmuBaHcBxsCbNVNJda/NsajnnupKQ4vrRhxW8w4Orb?=
 =?iso-8859-1?Q?G9ryaDGNxt41eLAl0HcyA1+gnoX7tPV/h+NTuRWCaQCxt1NOSvzPtUPiSf?=
 =?iso-8859-1?Q?oNPs6Q2FsPBvHFqf0lL0N2OFgkoM/v1m3vKxK68FuoUCVZ0wpytyhKVG9K?=
 =?iso-8859-1?Q?28ePC+3T0hE1ft1JkX95mGNEvkowQs3Q+hWNxb0Bn7DWSbYOFHhjnjTCjy?=
 =?iso-8859-1?Q?cB9YJ5Rx+A1uDD6q6fckRLH58fJ1JfsGOOShqLsy0Ho73bn/tp1MS4U9do?=
 =?iso-8859-1?Q?qncmHRBm/zIPBrIMIB1RbXqIMBcGYgzFJQ34QTrSFnjZ7XU1iuOSo+P3hC?=
 =?iso-8859-1?Q?6JcV/r9pJ2KgcFNyjpGdmCxRte/J9bS//vgUpgG+jpyEMMFUKmzJZhx6MI?=
 =?iso-8859-1?Q?fQy5w69qSN0ZIV9+VWHbGfd34o2/XRV1LtlB4036zTHir+vchoXzzBz7Bq?=
 =?iso-8859-1?Q?pRkEdmWwkKHrvN5JyUbHX9xp+ST8DPiC3LRlZQkP+lhY4sE6lEA0RrOt4M?=
 =?iso-8859-1?Q?0lbz+7u8HGE7hAitYC5b0E+aU3ecYNdwJ/aIqJuzrWNpqK1kuiZhbBcyXh?=
 =?iso-8859-1?Q?53CW3zCy/Ks/FzE5f1AcFqyuASVYA8RTnj4KwIwGrhgfigfFkcLVkD8g?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eVumEmWhjjLKV2afwWHIBY6kzVsiNm18LjM+sXG/2YL8aqsUoLEj+6Y7P6JSYS5PNf6KqHUG7e61Hf+vVl2uSrtOSA0XT19gzBsn2WBEOvvZbVqjOyN6fnVsKpBKB87cUvnP8SShHh3k4mCyKXksyLBNu1lAec8fV2dGT+kawlaoith6i7dGItJt6vqaVtBNHPHhCPtPip0xtoCEnGSOjlpNmcdKJSSSoNCtTcvgdPqjAIiaYT0+tZ+hlM+stCB/dII4mPrrNvGvlLc+YzCGVAvRiIE6AejrOLTNDqCY93dz1YyYLJEpeHHoMWlskWRoCoho0sqMqz6L5UoW5EsNi+F0eoM3G7v9mYCUlZIJ6xa6l1uEghMQSxJoxmDv7spMFjaQ8yVQFf+VF+FXzfo8Dp0sTNNF6IRPzOD+wmmRe4ZpGVT6G4Up5cwhUjz00QS7N9Aq0VV2Ype9tR14elpBwiYWwhqRrTNO+bXjItFe5O29CHm4pDk2jf2UEkqY33zXLGj8xXko/dL3cn5HsUkcdT9Ww8dn/2yGze4MbQ+Oqgkxco1cIUvKwkdKxJ2iPT1tVgcP7Q0t8mTa51q2yq2F23VSgivbQjmScPXTM3Tcuvc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56a3a8f0-789c-4768-d33d-08de22abb66a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 11:56:42.9131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 43ceJx/yurGvq1VRWgHykeD6LqvcHPWzPzpRqvSs4gqztmixnpOF3P/iT9TBBe8rDZkIKRF8J0rekqnVmqzhZMa8oDe4uY0HYuZOVcla7Dg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5929
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-13_02,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511130089
X-Proofpoint-GUID: ektsdwQCj8iccRg2goFlJTbESMLOgcuH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDE0OSBTYWx0ZWRfX5Uhhwzj24YmP
 wDoCCF8DqPoHyuPQgX4i6FPE7T4idh9FJ+eRUK9rZ9DsAvybMTqmJaWJCD/4DdISdu4ekFuy9K/
 Lg23/k82FGNE1g/Znegq34LjGahMTERMk0Mv2E95jdH6rc9Gf8djvsfbBcmu0BGPLudlCId+2Zl
 V/pfm+1+5EBxsoFx2SBdNJ1adDxsMbf5w++pMJRmBm9Hjv+uoNCsQx8AL/9bjdZ0gJGm8FZ/bCO
 uUvtdH2cx6jm7CSfvDk+TAtloBYmPpW9OUwT7P0P+rgtYDWLpciApIMBzHYl6Du39OSUH+C5vNL
 Mis8ys8AoHQsfvu03tUqikUBqthbwKlQAjEYuoHE1UBrUM62eS9Co5rqs7G3ezbpHze1DvxWS6q
 CRuU+JzuT3kluoRrYpwgxgldEkhy5A==
X-Proofpoint-ORIG-GUID: ektsdwQCj8iccRg2goFlJTbESMLOgcuH
X-Authority-Analysis: v=2.4 cv=HLzO14tv c=1 sm=1 tr=0 ts=6915c77f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=Ikd4Dj_1AAAA:8 a=pGLkceISAAAA:8
 a=ph6IYJdgAAAA:8 a=tHa68p0SAAAA:8 a=SRrdq9N9AAAA:8 a=yPCof4ZbAAAA:8
 a=7CQSdrXTAAAA:8 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=bHux5yGTfcSghLejmC4A:9
 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10 a=HkZW87K1Qel5hWWM3VKY:22
 a=ty6LBwuTSqq6QlXLCppH:22 a=ufIsyHvWW7FwcMbVRpPq:22 a=a-qgeE7W1pNrGK8U0ZQC:22
 a=nl4s5V0KI7Kw-pW0DWrs:22 a=pHzHmUro8NiASowvMSCR:22 a=xoEH_sTeL_Rfw54TyV31:22
X-Rspamd-Queue-Id: 4A7C7140012
X-Stat-Signature: mgsdnp319qcc6nsxw7rkc1zut8hr7kkk
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763035015-54353
X-HE-Meta: U2FsdGVkX19YzKvwx5hZYZNVl9hTZE4PEcygcL0Kd2KweTAU/DMIcV0ayAZX+iNnYXPcHeVLKgL/SaSTjtyaSm88mtp1soyUAmZHXQUWI2Azpt31CxD380TUIj6DRAdi8xYPeUdQo/UClI2DzQ22mbgQJmsHI6dLqN4ThkzQTsB/W7ynsu0h8ftWagqOf4tATgZc6WfXZFqsA1cr1cniCtnnMX2yXHbPnTy+XaKMF/qxAbp5WK2MnqXn/c/4l6fxo3X+r65fOUIhpicM+tBXqeOATBTsnr4dC5QwpvHSqsl0V6yOvulkiwNU2gNjfPyfS+t7t8YH/B+vt9eqGFfHcDxrC+Ajin9szm9JGcEEa/BNIwH9BV2sIyqIcPz4PlEYTOwJ5GgeUmnNU4LE5egGwrwVKcrnA+ALgzKCs1iLuHTM7FUeAovRxybXmV/STsKvidMpL+OzkoLqWKCZYMqFNU/QohcrMO2TZtHETcygKnF2Wfd2gj23E8XMLNWEsxQ3OmR3XWb6M8alvh3nlWRJGNc71XRVdEapgy0VpPmsAlA0mBzVac1DoJEOnALgRiLINk7t8LA1ikBLMGf1ip3EtMwsyqim6nhAqWdWdXOgyX+LhQo9K9EEZUIqjViuS4cbvTV5FdAKjHOX8T+Snh2GBTQS3sGnU7MPPGlVmxjDpVKObDWR6cY0g10CmXbOhL6zvB1kIKoTaROpMPzn0ZHyGhBlAxI0iJUl8+AW9SnCULpU0UdsPPXq6oKnhuN2zPFzqLrGgHx52h0SQ3sokLJBaRx3uuKiBnoGqk2IsnT2t9fHB5Z2iHVhpEezoRXwozJyBOHj5LHIt0IdYzkUHUdspSkPKCBPr1K4TV28k/Pwkx12AkCUtshf4NwMSl68thnNvczCgF2/g1tBA+UoVgMM09iYDagCm73hRb5XsqkSS+C23XoG1YbYzxmTv0sHwrHVtKAC6zmyHpUKaJ1Sfc0
 Pc+W3sk2
 w/WTNAbOcsXnTxZnAfRfEPAlebXdeyqMYj6aOB2OInT3IiOOye+hdEtfjooL+Tq99lUaNkQxR5u+XcWJLZu+bbVK5lbzlVhx0xCfOJWNVJPjTpx59c/VmoF7ZSSrXkspbbFdAODJL5x/liHhmkIxjt0OuP9GqHsTfUB7rVRz03enUhgJDlr8TBCBdbNjgYekOfJKSW6wmQ9WUPZw/lDDBgpu+Kb+8VWN/6Pl6+JjX44kPy6Ow7O9LfPH+UlyHLR06N9foUDExOua+cH2R0LlPjbr0I2JyJown5k7tT8BAxjabr2L0FVRgbbMFZfhN9tBfpzyUEwsLo5nXrnpftWDFZnxH2/jGNe7tFBqhCI98vHlkzGCpRmPUFY0fu2ZN+53T29DQmuiObqLqG6DLdYKrK8NRcACM3PWGDC1/E5cZcnHA6NQz+NvpSieAt/TZ+HZOXP1U+HvmZjgdEhGaIRnSDl6Va5eXS7dUk7/fLhhxYTMHokzOGjefvvWhgzdndtgKDbCYKCR7nEa7FnE8S4GSm0CHyqgrWMfKUwbs/vPJ3OvnVaOxdb8NJWjMi0gNLxeX2GMVNcLOc0lRs5VgrbdoDXjq80wuv2CxIpr8Ue2wOHqslNj4Isu7BaRkKMR44x1go6CjVn/j1d1Y5rmy6nF1NjRhBkUBceuLdAUQ7kq6Mnhuwog7onQebHo90qRA4I3TaEMFbFrB9S4/NYpVCd4qGHFwnfjsUVRvFXx99wGFaQrxIYO1sxYOCyxg8525d+Sh1HbdkiTwoDmVYx4GrGlRRq6alsciYxmkG+eefbEwBA8qUZg+eJsAmLJrPoyw9966ZXmgwgiL3bC7L6EZZZZbNE0vPG/OLMsvOsYihNM4cxoPKB+vUSgwFkidY60qd0RJhvdUWwaRcIXMPp2RSnUD6f1WMDAfvTBwdNIXtuS0AkqT3CRXysoLY5WULgKSq+UQG48OpCx/wi0nGCtbIa2hVeUHaqwl
 cVZWHdH3
 KQcCwlbX1IvHC/WlXIC2iBJNilQuUMV47AVgNEpCtZDWR3iA81LkfSZtVmYIPak6Wz+3WmAwXLkoqwK5RN+QrD3QIYlRWPPVO0JrZwqu7wnYXv4I9Vc8q26mQIxHYEPprxdumJ6Q1Lhqm1j22lWVgkiWRqXcB1eyKLkOC/1SgAm2oLxGdPirt0YB1qmn+GudkWF4RtB9VrShfdm2KHf/NWfSs5ksKg444zqCZxBvACijBuTdsMh/KMsdaVuBrVPYQZ8rvec85N77LlaAkBLZLWj9N/RO/6B0GsCVVXykfzYFSTBVCccicA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 04:13:52PM +1100, Balbir Singh wrote:
> The softleaf changes exposed a BUG in remove_rmap_pmd() where the
> migration entry was being overridden when the folio is device private.
>
> Use scope local entry for creating the device private pmde. Make the
> pmde writable if the migration entry is writable by moving the check
> softleaf_is_migration_write() prior to creating the device private entry.
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Danilo Krummrich <dakr@kernel.org>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Cc: Ralph Campbell <rcampbell@nvidia.com>
> Cc: Mika Penttilä <mpenttil@redhat.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Francois Dugast <francois.dugast@intel.com>
>
> Signed-off-by: Balbir Singh <balbirs@nvidia.com>

THe logic LGTM but we don't want to have a bisect hazard here by having the bug
introduced earlier then resolved here.

I think better would be to do the fix up in the original series as a fix-patch,
then maybe point at this one as a conflict resolution for my series?

In any case, LGTM so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/huge_memory.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 0184cd915f44..e4dadcb9e90b 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4850,7 +4850,12 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
>  	folio_get(folio);
>  	pmde = folio_mk_pmd(folio, READ_ONCE(vma->vm_page_prot));
>
> +	if (softleaf_is_migration_write(entry))
> +		pmde = pmd_mkwrite(pmde, vma);
> +
>  	if (folio_is_device_private(folio)) {
> +		swp_entry_t entry;
> +
>  		if (pmd_write(pmde))
>  			entry = make_writable_device_private_entry(
>  							page_to_pfn(new));
> @@ -4862,8 +4867,6 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
>
>  	if (pmd_swp_soft_dirty(*pvmw->pmd))
>  		pmde = pmd_mksoft_dirty(pmde);
> -	if (softleaf_is_migration_write(entry))
> -		pmde = pmd_mkwrite(pmde, vma);
>  	if (pmd_swp_uffd_wp(*pvmw->pmd))
>  		pmde = pmd_mkuffd_wp(pmde);
>  	if (!softleaf_is_migration_young(entry))
> --
> 2.51.1
>

