Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9E29CDC165
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 11:51:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ECA26B00A0; Tue,  6 Jan 2026 06:51:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CA086B00A1; Tue,  6 Jan 2026 06:51:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 180F86B00A2; Tue,  6 Jan 2026 06:51:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 06CCC6B00A0
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 06:51:57 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B029E1AA3ED
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:51:56 +0000 (UTC)
X-FDA: 84301375032.02.B661EBC
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 50C8DA0013
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:51:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=THqQGBdx;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Nzodar+B;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767700313; a=rsa-sha256;
	cv=pass;
	b=mNngv+xgdr1fyjLQS8RN8m+P5qMbJ0OXiaCCB3tJJknkqNOfeUlEJ44am3aKyK6n+bAhIg
	5MlC0ZrC6Z4Y3CGQvnodeVyZ5rGHsduQ9+myweeA/hQv5ZCcAwerxwqUrzhbqy3Dn5e0hO
	T9b843vOCbZgyNC5nwF7Hhv4cmg2pYE=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=THqQGBdx;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Nzodar+B;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767700313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PtDWeXm1FjM+mIXwXHbDXA1wmHVKpN/fW7ncu58sbbI=;
	b=3pGP2jkOxbcg7c1yFN4exif6M5TEpVPDsama1dNFw9FgxO7NeGs6R2UgPrlE2T7rtw/SCS
	1gWQqypeBB7inwV2TBOGy4TkUmesaqQYKbw7CmD0ureyTTEF0rqro8qsVeoEFEd5JEQ9Uw
	L8pS2PkncH+Eb9UhPVJ8SCy1OM0xEps=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606BaBwW3661265;
	Tue, 6 Jan 2026 11:51:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=PtDWeXm1FjM+mIXwXH
	bDXA1wmHVKpN/fW7ncu58sbbI=; b=THqQGBdxM3rgkd11zF77Siw+3PXTI3YKAd
	sODNwn4oxSnia5L/WwxskmsQ53jsITns5NNz73kByOCjWW9w3eypc1RQEmn6ov5n
	1J2BP7SqxWNnG19BXhB3ecW9+aFDLOozM9yr3iKLmBQKKF9UC2pylqMJ9gXvj0pL
	iB5Syrnqq/kkojtwh37MM2CdcMaDV6g9AQmvk3SMWp8BfWXD8yhKfkxx/iRHy1zm
	ttZaboS1oaRBPGZ9wc6VP1Kvm/O8YCHsHqpUMAP0l2RYP99ntylZqYqRXFNWUUbi
	jyc9T7n47YhWu6NxxzmMS/gzgdErqId0tLxWpyapstffCcBdYpwA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bh1n880fb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 11:51:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6069g9YZ030640;
	Tue, 6 Jan 2026 11:51:50 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013007.outbound.protection.outlook.com [40.107.201.7])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjcgky5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 11:51:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gqBLNQGioYwr+Pu8+PFbm7o+cxRt5PkqYwv4+vLbULvHTWsRvJf9jhAFi0VunnRjD8Xthst7KN1WdXKz3THPgeTajuMckmnRh6QedUwWs/MxKB8yKm4yYg3FNT5ZEczfRPlQIq+UpsXl/8Rtpm4GEvwGTrM+mReIR1rovPpdS358bpJ1Q0EYnHMrBNEmcR2x5MMLb+pNf6Z0yBh2DILdbtpp4nhH9b1Mcrct+FyMKNyMrU3kQsHMqTjl4OzZNY7smKK4ExrmrCOz4uyRbmz0KnYrRoZ/zsm52b/BAWum/EgyGKlL5coRYlfFuni0Qheu3N4oW724kBsNbCOKeNV86Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PtDWeXm1FjM+mIXwXHbDXA1wmHVKpN/fW7ncu58sbbI=;
 b=tV2vEceSSXpiYnIq4cQ9DTQZhaCl5anLQC7dwGTWz6W109b/rBQUr/xjBQD7dkx6rLQx4ObtyL32/G/GqgqD2niae0VVKGtJeT4VqK2V9y9czI/u8KUv6P9vrNPsCgMBGwop2KYDu9iXMvUGSU/fZXOloCzoIFPQTNxwhUtVb/Cdet+XgXaj4qiblZfzgW7Pl89oysW2Z5nJ+fRxTsMkPYqxK9j73npbyoxNdUOW9ojbUKyoyQNOv9Fd24FxCuT0xrhZG7p9oXZKRXSwx8KBLI7AUNu36Mo3a3MwQbc2WE3v44hVycv9KIuF0YPQjWlYhl4rp+7wo8W1XLX7jiVeEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PtDWeXm1FjM+mIXwXHbDXA1wmHVKpN/fW7ncu58sbbI=;
 b=Nzodar+BIl1PVmv7RIqnX6NlVaGnhWydqWxWmq5LV09mxwHSj2bUw63+54CACBDd1V1WEgO09EW2uVp+coNkwuwXwU0TY9rgGrIyQ9baVzJH/et7SyiyNVTm/hl4j0YqBGXuQYFwIERa0LUQCZI+WLXlHV+ZBn+hoCYtSOOyDiE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB6135.namprd10.prod.outlook.com (2603:10b6:8:b6::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.2; Tue, 6 Jan 2026 11:51:48 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 11:51:48 +0000
Date: Tue, 6 Jan 2026 11:51:49 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        David Hildenbrand <david@redhat.com>, amd-gfx@lists.freedesktop.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v2] fix AMDGPU failure with periodic signal
Message-ID: <61c3d41d-602d-4dfc-872a-873acf653b6d@lucifer.local>
References: <6f16b618-26fc-3031-abe8-65c2090262e7@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f16b618-26fc-3031-abe8-65c2090262e7@redhat.com>
X-ClientProxiedBy: LO4P123CA0668.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:316::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB6135:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a898524-d4a4-4708-7005-08de4d19f8d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vzhwx4tAF2eNDdbqfPfrQKUSCFWtLB0zt1m9Gp1A/nUjp1ccxeR5iIl+wlkD?=
 =?us-ascii?Q?NQ/k8aNKSaJYyVsYnzuIKTdfOMVj0EK0uiS0P4SpIcShmheRA1jk/ZHQLIZa?=
 =?us-ascii?Q?krnS8lLq4Q4Em7hrS7BmigCuWBzsHLTq6y2dsFy69Au5vD477jcPtvuGE2hf?=
 =?us-ascii?Q?UCad4xEUsKt6LXDYktTz6+ZfrEgQ7NCs8FxTa4+mzcnZ8F2FJtdRalEHj9/5?=
 =?us-ascii?Q?JOai/LmMl4wYEfcKC/EOm002XhSv9X9goYNBe2loFL67ItM5ia9uoIXgmY/5?=
 =?us-ascii?Q?sL8/+cOMe7lcg07J75PyJdWthJiR3pg+zSMWPPuvJcf9b6veMZN1ckbvlmBc?=
 =?us-ascii?Q?RaCALRkpNQh5yIvCV2AoMHqMnZKmsxjBphbbasQH4ML9RDclub58JIh3kr4c?=
 =?us-ascii?Q?AjZZR/vDFMU5q1KZE2jXIk/8KzwkxI5R6kowrfNmKzwjTMgygb8OqeOlBSA6?=
 =?us-ascii?Q?zLvJ8IydJ7BRbc75ulsR9023FpA61qj4p6NO0IUgL/qgwj6hee/PFtsh/MKL?=
 =?us-ascii?Q?toQIPHVeh6CotViIIuXCqV3xHG8RWAq43Nu6H5lDC/DMvw+tt/xCQY7U45fP?=
 =?us-ascii?Q?DderJ3AMrg/TBr6qbSZqPQZ2xZptadgc4Ky5ngyF0wvH0Ocep3ofoPm1lKD7?=
 =?us-ascii?Q?HFplR3RH3JPnUA5tUN6f7ej5w4M71dU5XPNg6O6PYdjpYXNhWnumji5O8/Sd?=
 =?us-ascii?Q?ZFb+S8ZJFLDmYwuLuBjZsqeKhM44ut3L9cM5KvnnZEgEWAk1EYPBlYXPmNy+?=
 =?us-ascii?Q?r3zUdPBkzIBa+DzNQuVnCTOWmx+3K4mxc198ONJrNlBHuM6o27Dw5IDBwCkp?=
 =?us-ascii?Q?qiGehwLi/61UV4vnWHe6obPLyvJNDcAUFlXxA2eSe9DXsW336Sl7kkr+opuk?=
 =?us-ascii?Q?2DQoVp3y4AtUm3rbMu3haPS6SgrImuraI7B5XQBgThIqRvfSBVA4FP5YgnMx?=
 =?us-ascii?Q?ICXX5Dz5yQrfhrfTJcnwcyABKb+Oir4O/d4mZCcDuExhCbu5OzjP42tIb4eC?=
 =?us-ascii?Q?wfERkwRZBtlQhO6aYaB4ZzLmuUI/7c7MCqrPK0YPSqEY7D8ye/ZmNRqX7eQV?=
 =?us-ascii?Q?sU5aIp3u+Lub+BneOeqHMSzsmmWk8nLIU6L2BeM4Z9x7dLus0d8b4G4XrEE2?=
 =?us-ascii?Q?mg+NUpShztZVXuJs0JHVepBHyJATkXI2Rlb2mYlK0dIY1Pg1GVQXZasFiHZc?=
 =?us-ascii?Q?uR6JY+ZdKjvpVjJWHu/OdlUFwiIeFyDDn7qFXO9JR/Tq6PI/H+4+h94namoP?=
 =?us-ascii?Q?7WJq65XbdVyBuEbq/IJ6F2k0TRzrt3aZG4MwPhISEuhJ3Z8p7NzJ2Ted9bEP?=
 =?us-ascii?Q?VZAuLkNuS9r5cAbMHoO4XhBckEKUPiA5Ctml4gj9kDQKO8IEIT/GtrPSbwoZ?=
 =?us-ascii?Q?gW5T9aM2vjKf4LCSIWlBxzWOWN3Tu1IYILXCVEI0JubOcTTqhQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wzCQfYOALF3I98F22yLnToqT0Hh9Pw7Lgz/9fwd7MytIDVIhDXYKwJQw3Xnt?=
 =?us-ascii?Q?wOiAs8vSmB10iaWmdSatJK2Sv3F57Ar3rOCQQ3LEcAahzxv36XXodDzqq2Pr?=
 =?us-ascii?Q?MGLOjWD13RUXYq05ZrNekkwDOVhwdhnvO6ARC9wEKl8naBoeHRMroYYAR0WH?=
 =?us-ascii?Q?+dOMP08uUCqLmcmnTsV8jwbaZ1TKaPajzUkSk8nx8uPAXMaOvBuLxP5e41Na?=
 =?us-ascii?Q?6Vyta1+dbmksv/Jpzpm+Ypr67JPJZdaBgUYg1+Zy0J4Rh1bWeSA9Wmbmb8ys?=
 =?us-ascii?Q?TpAlCDXaodXVMjN6kiJ5LZRjleWc8VsE4A1J9Nac29lSxsLFwX4jgd/bzhZ2?=
 =?us-ascii?Q?K7Jhu2J3JJ+hOXkw2hFdRX6DeUxEoMrEKNlA1lI35XevlyvI619utV3wzNNB?=
 =?us-ascii?Q?biZ6JFYfdUwTspDEA6sklOxqeeyuPSG5P1FBNLNnt6bAd/p7oysLX4ijgDvx?=
 =?us-ascii?Q?j7sFZAhz5jBh+gQpB3pjzORatkZ2U0j5W2Zz/4sMCP3Oop7VVFl8/EoBbccj?=
 =?us-ascii?Q?K+ikzIWd5PGFXSGvyT2vE07vqD5HqGVkMiTc7RQo1NXpnzEr57sCeAr1lQcL?=
 =?us-ascii?Q?v2KMN/bvifvyJEFWGSENbP/W6+RrwBMKSYDi26iwgMHC/YAzwjGVkl/yjTO8?=
 =?us-ascii?Q?izLVjkhr9WvUArPu748Dj8AcCaEU70jQ87JEcU+iIDk7f8vH0czVzNPOj/Mt?=
 =?us-ascii?Q?i039SsUhu/8ZXoQxF1O5yLmdfnVLHOvxTi5lqXRdSDbxd+pOTU5Cz24XEG25?=
 =?us-ascii?Q?PXaq5CTiNVmSAuv30OWsY70gSpjUY4izl8+0pBSJVWdleH6dieL9JQwSjLb+?=
 =?us-ascii?Q?18dlMtJvFUYVLYAY/TG6ai3TKv2jSSjv8DnlK8SJO68Oz+/Je30aqqdDJcKY?=
 =?us-ascii?Q?/Vyf6g/F+GBX8NtHp0zClA4OIRldLZaYPGrME9gT0u2m6z3+53N1Djdjzy2Y?=
 =?us-ascii?Q?IEyYoLoZ9+pBGj0tn/vCYSg6QvndhYm2CswWGT1SHm+1vTnXLYar+W3HhKA2?=
 =?us-ascii?Q?1T9CTBje71b43fjhwYXfekjU/PnzRpG+Mcoy8tAx9ouhbZbqs1W7WFGlAfVj?=
 =?us-ascii?Q?SEW6ZrI0hgaBeMyPrj+Yl7YQeMStZjTpI32EdKgjyPsR5DJMzkxr/5ogrSq2?=
 =?us-ascii?Q?MOsoRVIoyAFw5CqInShqG+Ea5tNlp5quMfLwgZlxwJM31JbORABQHXq2gnbp?=
 =?us-ascii?Q?aIV+Si/gJu+XKcuQI0sbGSfhJPbU/WJUpwUQoMMG/itcS6Ds8BXlOHQz17bM?=
 =?us-ascii?Q?F8RPolr8YN5aE2vn/Qr2T393sOxAnQv5/syxfbxGaAdnhE8yZ5+VIHKn2exJ?=
 =?us-ascii?Q?tY9ALaEy8JXNgMR3e7QwvIHjzvA+T/KJUKhb18DQfDz6143z1dxlNYQSND9t?=
 =?us-ascii?Q?5FAeYRARwB7SH+Zi+jAW2xkarX8RcRLHS8STMNd79lQY1oJZDhMoPzb19jeg?=
 =?us-ascii?Q?Lq/zqlhKMK+2P6R6DD3FNI+yztm8Oa3CSSQ8RYD5R64BulItvb9znyAD7NMK?=
 =?us-ascii?Q?hcIDBMvzB6ejZCewicKvwMY0ytsQ92vgyBbzfA+vr7rnzooDeFilRIVNAwEu?=
 =?us-ascii?Q?F3/ryD0XRTFeVd3HXtf7Jusy+rRJM6vWYI6tJVM4MmGkfLkwwc3eP5GRE2QC?=
 =?us-ascii?Q?9SN7yNC79+Ar5rSYig5JY/ENwAoYiYlOVdsHbPyW1GqiWub25Uryl8imtytM?=
 =?us-ascii?Q?kRf+BXsXnRrUOm0K3sskHbnqXBAuYFkzEahT/+aoZg4DclpYBy023WYWvTug?=
 =?us-ascii?Q?QXJdyHnWbuAykFrUdLklf22wr8QbUi0=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1G6eJjrwkp9dj2QYbp07bUF2HvhQmV60+TZbN/ZSLLDiEZ00G+F59UVkrZI3//vXgkFACUHVFJGsiJ5982bNT3tBmMD/VLXloD5RUcdO6VuZP8TLn5h63GlYEBZ29cOB2My4Hqq9dnGmgOSijO58kGD0t4i1kL7H5tYCwKymenDaXj6F+A88fgSikG3cFMgc0KMAxCLO0aYkeeMRd0smKfdr6erXDpeNYCLHiSwpzBxn47LiRsIzRaZC44kTwOPD7Y0eyjzajeqwzAAHiEDCqu7WzptfpH99giRuoJa0zrpJbT8dKKyx2/7zwxSuDPkY3415msoXDFuvuln9pf0OxwVdFh1jGsM8jSMOaMpiUp4Md/L97YKtKJDkJstxyS+q/dNf7J9FGAAhBHgq2XX+GkZENzyn4/XxxC2NtUZZkkBxWpQ2yusIOP5uS5fV6kIUd1zpqaE2nK55iY4qyF/yC7SjfsE8SNKrg73iwy+u75F5xpyQNoWtuFFYRQs7agj8OiVMyj+zxKepSWca2U2hdUlZ0ja7kpnOCZoU29txJRVRKLMNWXwmlzzRlMYjmRNPS8043tvLNp6DqM6JhZ9v8RfIP8HXrumD4uYpvlDqY2E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a898524-d4a4-4708-7005-08de4d19f8d7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 11:51:48.1275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nh9Emu0bc5wDkOqAZYMo1YCsgegb20P1/TJAa/wFyk9E9mRQRS9VG2w3Dg5c9RoSjqVozqPdKYpq3Bh+Q6xT2r+IA1fAv4NxmzFkk5u6Y0w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6135
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=939
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601060102
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDEwMyBTYWx0ZWRfX/Q7vhcHT85zL
 MQMKom7XkeJ/gTeCv1SH8nk9AP5A/fmPupyex+e1rexoMd4JhGreYvj98lnOW3xxTZFX5aw2Czf
 YU8NWzAOoG77fKLThlDw3+GzRcEOpT0Y0HaCnZh4BwZlsg1iampIvJ9FYrG+21zHBAUwDOcWKRr
 ES/AaDCvnZjMfZ1zYTXvtoCqKuC2cakaCsq2CkV0HUp3Rwf+dzF4AyTkLgfAThmlMPmBFrivxeA
 cqvGJNAMpJsn5LMV+h5WkPEsGPmDeEj3uCE5llM7jjlXFlWpYMFnZRAmzoEdi0h/6zwAG/Fd5rl
 nT5ImfN1IgoxfWzyBN9bo2VxandLGirpdUiFgmxlLbdVgeXt7WfSrGkYDsayqhWARCzSvB/XeMS
 iDUDNzVU8B+c4KBWpPpT9iQPesXWcopBOELlpo0eW2DDvGr87Y+nmy4NcSrlkX5w026v1TPuOWg
 6kkS98zLEFwvJ4Han9W2gp6NQPcMJ0Y25hLh0fpA=
X-Proofpoint-ORIG-GUID: bXuOwW3Tp8yogF858y4zCsjoOdOXIgFF
X-Authority-Analysis: v=2.4 cv=aetsXBot c=1 sm=1 tr=0 ts=695cf757 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=cojg3PkHAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=u1ATobRcjniv1b9x-kwA:9
 a=CjuIK1q_8ugA:10 a=DJ8J2fOkDkLJcQ4mR7rI:22 cc=ntf awl=host:13654
X-Proofpoint-GUID: bXuOwW3Tp8yogF858y4zCsjoOdOXIgFF
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 50C8DA0013
X-Stat-Signature: t614y1j65mzfr37sbunoo3im6ej1auyk
X-HE-Tag: 1767700313-861703
X-HE-Meta: U2FsdGVkX1+vozbw2Rcsbzr8keNdTk4c5TM8hMLsQEL+q2CWS5AvOq9xTAwLKncU1mS6wNamJafwgzY413RTwW7fwZEp855oqknvXCm4bn6Ks8198QVJ2A8DsEmEsAGK9koCoRrDEmKD9UTLi16VUviakpGPyVr2g0isbJ8pPXx5ja1YadzkfZ1Tap9dhL8Npjfl5YL1GUyMnSD+YGKhTY4H6EKeZMKYXTFcknPC8L9e/+9ntwBEJT7jzrB4+yyGUqYrVxUTQ9G2k0D8Vl3jY0yx14dBwH2YMqfdCegH0hjsKWVfgiivrtRFbLUwUwIySqGTClW8AtLCNYPltz/3Z4jMzhBjQhQeqAljG9Y9VPFOH1375ta3cuNHi6htUz7n28LJPDh5S3xyIa7ZFOQUgrvT6bi4IzY3jn4b4B92aX7t6bRqCxQZnHmnKO/JIgY/aH8Hz+qeQGXe0YsV/+wAPlDTDCMB6uDu0y1mJ2hbcOt7I+QsyODDYDR1qxryYf5Y+5yik6WXoH281eWAulcLU7exhm1E+UHwok4zPLvNpO0VtSXVBRpUNLzaJNWRLHQKtbx26czhXr5hS9K1hJkxBRnLPNNWiMwSzzcxsP3zTJcxSCBrR1uBYmnANuwruCJDlCdV4xVhvnmbwg5VKVztT7CeoU8fZXc8E70848aKmjEoj7mEFNwWXnf071hJ4/PkmzWX9agumgi33fyu4GjtkUIHj6EAXTA9TM4vKma19mHiMsHiAq/7NGwt0FSl+X8yQIxuwzHgRc40/uvT4f/qVU7jHh60s33+OMWJHDN3zd3eK8dlaN4C/zRbM9kpoePB+LrMkDfjzX+WSbeWgtAZo+jEsmsbqEYeSqsHPFHN7DEjFLNMavtGLz7CcObc9Rtja5Pshm9PRWjM3y3Dalpmh1OZiPgJRCvWk8LIeS6+Pc+1+ZAQkNkhHGSfCgRwiWk+ZvNu2oas+OoiO7hOguf
 YFxw/UAd
 lhjlWLwSjPoBH2290HqXxYGK2jRUiHMCj0HdmXvkeydLkX7dskIZz3m0AA0T1BI5JLSfPZ4/S3rxFx5CsLtHMAUJ0lUvqG6CVtFlv+ZraZ348R/eL0xn4cCh/Sq3EnYpUTvjhMyI9zMNfMYbWr7Fqxmt27Zr145sJyZ6AigLyWHmWovFfpjo3WTr79iSIB+r/qWHWXeZAp/6EuNzAFQKgucDMb9Lu+Xdiip8OwQVOuE5h+sygOKZCEpabOLTfovWjkSDDeNeAdXVyQgLFTDrJXgT9srt3UABnPv/eHL8s6aZ9e3Zug1Dnh+6vCedMpUQEDIMLmFpBfh24DYsex52m9HGg5YXGTPdrIspcW+BysML5PcRv12BFrUdLdDwOyiIk3dWm+79BhFkRpiP/e3rYVbEyE7iFAl1tkfM4MVvNi3ZFmtFfl/7VQ6D8t6+6k1ed+WpQaOm0pMO6XJ9Ta+eL0OIDRoIiRNYbRYVEsLOCkfibweZgha0qjRhxyFFP2Fu3sKKSvHk18fHm6QbDUUkQoo9+GSFfOU/GI//j6tKkH98u1YlJW039LHOz03M+smF9CskVVToEkHKmFAjyLsOpeTkzqnYDPyYwsIVdypCON0L9qQKBJ3nfhfNg1zIMTMsk3GiuaHB9KqRoskJmIoaypV4SFtPqVnnW/BvPFbQ5W5FdkOjRkEv0KFibbWoIUzM6Xan+7N8scqwMjpzCd5icZtBiuIQAgU1zmGpW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew,

I'm not sure if the git repos are lagging vs. quilt, but as reported this
patch breaks the VMA tests, and the tests are _still_ broken.

Yet it's still in mm-new, mm-unstable, and even mm-hotfixes-unstable.

This is interfering with my work, can we please drop this.

Also the v3 is currently being debated, so surely should have been dropped
until we have this resolved?

Thanks, Lorenzo

On Fri, Nov 07, 2025 at 06:48:01PM +0100, Mikulas Patocka wrote:
> If a process sets up a timer that periodically sends a signal in short
> intervals and if it uses OpenCL on AMDGPU at the same time, we get random
> errors. Sometimes, probing the OpenCL device fails (strace shows that
> open("/dev/kfd") failed with -EINTR). Sometimes we get the message
> "amdgpu: init_user_pages: Failed to register MMU notifier: -4" in the
> syslog.
>
> The bug can be reproduced with this program:
> http://www.jikos.cz/~mikulas/testcases/opencl/opencl-bug-small.c
>
> The root cause for these failures is in the function mm_take_all_locks.
> This function fails with -EINTR if there is pending signal. The -EINTR is
> propagated up the call stack to userspace and userspace fails if it gets
> this error.
>
> There is the following call chain: kfd_open -> kfd_create_process ->
> create_process -> mmu_notifier_get -> mmu_notifier_get_locked ->
> __mmu_notifier_register -> mm_take_all_locks -> "return -EINTR"
>
> If the failure happens in init_user_pages, there is the following call
> chain: init_user_pages -> amdgpu_hmm_register ->
> mmu_interval_notifier_insert -> mmu_notifier_register ->
> __mmu_notifier_register -> mm_take_all_locks -> "return -EINTR"
>
> In order to fix these failures, this commit changes
> signal_pending(current) to fatal_signal_pending(current) in
> mm_take_all_locks, so that it is interrupted only if the signal is
> actually killing the process.
>
> Also, this commit skips pr_err in init_user_pages if the process is being
> killed - in this situation, there was no error and so we don't want to
> report it in the syslog.
>
> I'm submitting this patch for the stable kernels, because this bug may
> cause random failures in any OpenCL code.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org
>
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c |    9 +++++++--
>  mm/vma.c                                         |    8 ++++----
>  2 files changed, 11 insertions(+), 6 deletions(-)
>
> Index: linux-6.17.7/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
> ===================================================================
> --- linux-6.17.7.orig/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
> +++ linux-6.17.7/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
> @@ -1069,8 +1069,13 @@ static int init_user_pages(struct kgd_me
>
>  	ret = amdgpu_hmm_register(bo, user_addr);
>  	if (ret) {
> -		pr_err("%s: Failed to register MMU notifier: %d\n",
> -		       __func__, ret);
> +		/*
> +		 * If we got EINTR because the process was killed, don't report
> +		 * it, because no error happened.
> +		 */
> +		if (!(fatal_signal_pending(current) && ret == -EINTR))
> +			pr_err("%s: Failed to register MMU notifier: %d\n",
> +			       __func__, ret);
>  		goto out;
>  	}
>
> Index: linux-6.17.7/mm/vma.c
> ===================================================================
> --- linux-6.17.7.orig/mm/vma.c
> +++ linux-6.17.7/mm/vma.c
> @@ -2175,14 +2175,14 @@ int mm_take_all_locks(struct mm_struct *
>  	 * is reached.
>  	 */
>  	for_each_vma(vmi, vma) {
> -		if (signal_pending(current))
> +		if (fatal_signal_pending(current))
>  			goto out_unlock;
>  		vma_start_write(vma);
>  	}
>
>  	vma_iter_init(&vmi, mm, 0);
>  	for_each_vma(vmi, vma) {
> -		if (signal_pending(current))
> +		if (fatal_signal_pending(current))
>  			goto out_unlock;
>  		if (vma->vm_file && vma->vm_file->f_mapping &&
>  				is_vm_hugetlb_page(vma))
> @@ -2191,7 +2191,7 @@ int mm_take_all_locks(struct mm_struct *
>
>  	vma_iter_init(&vmi, mm, 0);
>  	for_each_vma(vmi, vma) {
> -		if (signal_pending(current))
> +		if (fatal_signal_pending(current))
>  			goto out_unlock;
>  		if (vma->vm_file && vma->vm_file->f_mapping &&
>  				!is_vm_hugetlb_page(vma))
> @@ -2200,7 +2200,7 @@ int mm_take_all_locks(struct mm_struct *
>
>  	vma_iter_init(&vmi, mm, 0);
>  	for_each_vma(vmi, vma) {
> -		if (signal_pending(current))
> +		if (fatal_signal_pending(current))
>  			goto out_unlock;
>  		if (vma->anon_vma)
>  			list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
>
>

