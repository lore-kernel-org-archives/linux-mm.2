Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18590E83EF6
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 17:34:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 791196B0089; Wed,  4 Feb 2026 12:34:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73E106B0099; Wed,  4 Feb 2026 12:34:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F56D6B009D; Wed,  4 Feb 2026 12:34:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 488686B0089
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 12:34:46 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 01DB2C13EF
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 17:34:45 +0000 (UTC)
X-FDA: 84407474172.16.C915D7D
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013056.outbound.protection.outlook.com [40.93.196.56])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1F63D140003
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 17:34:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=iNdR39yv;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770226483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8WdDCOH3ZM4e3S+7RHEiQuTbM0WeXx3fvtDdWwVZ5kw=;
	b=Mij7H2rLkLNL++X8a1BGH9H872nNJ1giC2MMrwziPl6hrvBHjwhXO7PHXOYpnmayHUyi5I
	qVJYVlLkUT9cgBYiX1OhYvBgXNJ3piLJv4czvtRR/YmBDBDMbfONjPsr6nr/6yuHsfNyHC
	k3lZDcOINIl/S2xW45RbeW6299U8Y54=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=iNdR39yv;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770226483; a=rsa-sha256;
	cv=pass;
	b=3K2FnmT+X7jtS5SSoEK5pmRi8ZR0SRamuWq73zBofpf3xTn//Rab4pKxLaBcnCWasnZI/R
	pHzVAok3g8wtXrm4cqEhqzgArXaELVfE1mHqclcNGvCw/uz0UDDqJwF2l9YVF05E65XvW5
	mKOaCcnaS9TYWkaD3Hm6gdC62eYckDY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=inWYelevfFMmkzGiHqYKyuwT27rwaFqJGyDoU1zl/WQoIuGoXtnLKDcuwUN9RYmRKHzIUQR6uXjYVf0O+E/aiU316mxVM3AmbTqJljlanq16MMMNTCjWtA5L188sRuJmsF7UScJaEhm0SRP8Uxqm9hCyPz0L1n42kZrra4DsUdbkJhRUrGZtUaglNs6FUkjKBbtU4g8uKpgstTu679aMmbtDGN9KNuHCgE+eUTkOIZ+8M2HmpFC/nOBscI4WnJDOVvfo3XyqDNB+4T/JWNjfOXVbDfQB7HPpejKQc/ocFGoBILYwDTS9nnj6CydJVYwU56o4nv5oBkUhgMyY6qNxow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8WdDCOH3ZM4e3S+7RHEiQuTbM0WeXx3fvtDdWwVZ5kw=;
 b=IcviB4LEsKnCgZMWN2KssdRgKY1S6/Sg5OW/S8DC1hf0c5d6qmbrakeDupfBcFsAslZxgtorMh/S4daBuWjV6o3cy6vP5pNOWLu3m2SeYNUIHKb+RVIlcJeXMOLszrs+8CQ3C5awM03KMjvV6DAM3ytQOaaK5rAGT5o6kwon4Yz/ETnPbA9znbe8i9n5Gqyd7y6fSpQmIEanh+5RrrnKT1wEZKVky/fUgE7eJoSgxt5ATZXBCFu6jasQpdk6F9Or4Jn3kID6luS9hLVIavt2BeUJBE8kamFmeQfveuKxhlOCAD6iJODtB3zyVcStODCOFK+brkV7B38kQNt6L/YZjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8WdDCOH3ZM4e3S+7RHEiQuTbM0WeXx3fvtDdWwVZ5kw=;
 b=iNdR39yvzsaHK04ncmhVRbxH4049XmmbOXUN+Mw9ReEm0Bxgqhp3Od2rqkuIdplqKnm1NVkk/oB3QR5ZbQhGt1oUjqzexqJyKDikno4kaJM5eMpScmTJRX7v0Ay5ru22mpqnkQRkozdB8uNVHdmuA/7Co60LqNSR7kyE7hwvdb6nQ383rLfI5nPcx7YVggJaa5fkniSjUMbAKgKO210FYuId1SvRavzGuTzvsTK1S08USu1dXan7ojUGLdpqa7ptvlCIt3rBqKjJaHCE8fAMIdajhB0i5t1M9b8DU9gxtECv+eBmZp+1FeFsf29JAY5AX5N8Zb9AoUW0OLk2c6iHQA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA1PR12MB9002.namprd12.prod.outlook.com (2603:10b6:806:38b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Wed, 4 Feb
 2026 17:34:37 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9587.013; Wed, 4 Feb 2026
 17:34:37 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (arm)" <david@kernel.org>
Cc: =?utf-8?b?5piv5Y+C5beu?= <shicenci@gmail.com>, <linux-mm@kvack.org>,
 <linmiaohe@huawei.com>, <akpm@linux-foundation.org>,
 <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>
Subject: Re: WARNING in memory_failure() at include/linux/huge_mm.h:635
 triggered
Date: Wed, 04 Feb 2026 12:34:35 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <25CA4D90-A24E-49C6-92D2-08080EC81466@nvidia.com>
In-Reply-To: <48978612-6933-4897-85DD-6740B6C8570B@nvidia.com>
References: <PS1PPF7E1D7501F1E4F4441E7ECD056DEADAB98A@PS1PPF7E1D7501F.apcprd02.prod.outlook.com>
 <b9e89c85-807c-4a8b-aa5c-8c1325e75445@kernel.org>
 <1db245a8-f9ab-42e4-8cc6-cc7562961921@kernel.org>
 <48978612-6933-4897-85DD-6740B6C8570B@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:208:23a::13) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA1PR12MB9002:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e4b5080-e77b-415e-83d9-08de6413ab3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZFlXL0N2TWpBeHVwTEo4cW9ScWF5NER4ckRMZ2RKaWtad215RU9LTDI3aGcr?=
 =?utf-8?B?YWg0MDU4N1NmT29ZUUFCLzZoRjVxbnFhd2pRZGRBRTF5M1hsbTJldXE2TExT?=
 =?utf-8?B?enhQaC9kKzNCbnZVdVkwOFRzZUlvWWowQXYwSkhOS2IzTUd6UlFyS1EycFdG?=
 =?utf-8?B?QUJONi9OQ2IrRWIzMTVVTWdYWFdCRDRIVkJOMC9rays1allhaVZ5Y3g5WTA3?=
 =?utf-8?B?MXdMbmRVUHZJcEZIdkJXSkdzaUhjMDBhRm14SEQzMGY5LzcxR1pKY3B1OVlE?=
 =?utf-8?B?aER0VGpQS3ZwQXdJOEpoNmJQYUpqSWNwOGd4Q0tnbVg5VUVRWVlhSXkzTXJN?=
 =?utf-8?B?YXFxVVJjeW5FNjdKR0lVY1gyWjM4V2VIWnpOcWxBRUY3R0J3Z2lJU0hJREJa?=
 =?utf-8?B?aHVaWTVNanhOUFZXaHlNa2JKU25VaEoyTUxiTjlZUlZsVnlwT1drbkhpWXdx?=
 =?utf-8?B?ckFIMUlTTXlLcDQ3Z29jL2YyTkw3dCtQU1VZSUVEWHZkc21VU3VTYUJTaFdG?=
 =?utf-8?B?RVBUY1RIN0prK2NzaE1JUnJ5VXhYQTIrSHBGNGNQM0lScHB3VVRQQlZlUTRY?=
 =?utf-8?B?NHQ4Yy8zTjcwTVkvOTgyTkN2Z2M2cERMUG5WYUdWdUFubjlJZ21YVlFKOFVv?=
 =?utf-8?B?QXdJWHp3dDR6SnhBL2dSL0plb3pzMjV2dS9pY2Q1TDc2cXVvZEtoaDN4WGwv?=
 =?utf-8?B?SlNUNzNBSUcydzNaY2wxM1pEclllYmxiVGtscXpVRDV2TFRGdFRmam1JSlBP?=
 =?utf-8?B?M24zb1ZPZ2pCa0FaOXgzWUU1eHBPbU9icTVESzFCY1Y2R0pNZWt0cGpvdncz?=
 =?utf-8?B?OW5SWVM2WjhLRnJ2bG9BWEh0OUxodzdwZkh3TGZBK20vUFQ1eW1ENmwzUm5V?=
 =?utf-8?B?bS9kMzdjWWt5T3Q1b0tJTmQ3ZXp4UDFHVnNKbENuYmZFbTB1eHBPcUFKRmh6?=
 =?utf-8?B?YlRzb0tOM0kxNzFwRGlvQmgvSUhjNzhJR25jWngxVjBkamFxSVpWQWJWamd5?=
 =?utf-8?B?SmNtQXRZN1E1aEwrSUcyVVp4UnZPbUd5VlltWVpFc0dIMWdjNEsyQzhYWXpl?=
 =?utf-8?B?amo5aEp4S00xMUkzY0ZhRTVqOEVoaWpZN2UzOTQzM1JJbktwSEFxNTVvem4r?=
 =?utf-8?B?KzJVL0IwM21jTlEydFR2Tms2ZUhSQ0NhWU1TU0Z2K0JqamcwUytTU0x4L2VM?=
 =?utf-8?B?UlU4eFhZTFUxd1JhNnVMWUZJTHVCV3hBdjVPVi9FVTk5Ykczc01iUy80RVRN?=
 =?utf-8?B?dDVzSzJZZEd1QWJVdVJwLzgzQkNpSWd4Z0lGQ1lYZDd0YW9wODZDbng3QlIv?=
 =?utf-8?B?eG85dHlzd2w0K3NTRnprazh2OG9jaC81VVVkNUFFNVR1T2l3OVUyYUJCZE1E?=
 =?utf-8?B?MytvVk5WL3lPR0lnMEdvcmI4Qk9FTXJMeThobTI3aWR2UDMzcm1NeUduNUh0?=
 =?utf-8?B?ZkZha0hCd2RCQnpTNEtIMHd3RHpnak5NRXpNeHdqQTRMSWltUWhSSDZMNTRP?=
 =?utf-8?B?b0ZrM3ovNE9TMXVHMFowa3RWb3ZZOUlDRmYwSFFDMFk0a0pKbDBZOVVLK09w?=
 =?utf-8?B?SnNMNk0rSFhpZ2hKdkwwcEFCUXNzdVpZSE51Ky8rYVhYTFFobWp3K0swRGxo?=
 =?utf-8?B?UkRvTEhRSHA5TU9wR1VnNzlHS0ZGYWxVUjRmNWJBSG5WSmp3TUZMQnBzZjlz?=
 =?utf-8?B?WjM1QVgrcWE3a2JHaWQ0TFNiVmZ2RGxyazBUV2JaOCtxejFMaFJxb3hBczcr?=
 =?utf-8?B?ZlZ1cWVyR09wQ013WllhN1FSZVIxSlVPdEZOaTgxOFdRc0hYNU1Vd0xVZ29Y?=
 =?utf-8?B?MThzN0t5OUNMTjVid3lYVnFhQVRiM2V5N0Zzcm1zRHpZT2xmQWo2ZUFYSFhI?=
 =?utf-8?B?Uk9zUGxmTnhRaGtRUncwaFpFMTRLZ3NrOXFpU0xCdUNFaGVDSEU0NUkzNXZR?=
 =?utf-8?B?Nk1XYTc4Q3ZXcWxSV1RIMURWeG5sSTlDQ2ZpakJpak0zZm9QMmRIenQ0aXE5?=
 =?utf-8?B?RE1obSsrQ0hhME1LM3dsS1lYS3RwMFVDTHgreE9iMmZZTDBPZDUrem0yZ3ZJ?=
 =?utf-8?B?NUN4SFlQbXRCSm0vTWhmQzhkZnU3VUhyVWlBUGpJdmZuNThTVnRjaVdJaVBq?=
 =?utf-8?Q?UCAg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S1ZkcFNiWHp6Q1ZYNzZxN2lwaTBIT0xNeDF2eVBxOEVRQUt1bEFSME9yY2dR?=
 =?utf-8?B?eWNRdSsyTVVVQ0hWSWJUSGtNK25RZ2duN0tPdkxwZWQxMTVFYzRBNE9zQ1BS?=
 =?utf-8?B?SjZiMUdSRFRjdGJ4SkJVbi9uRk95NE1Ya3BMT0V4Z3I2bW1zVDFOODdWMHU2?=
 =?utf-8?B?ektiN1F6aHQzTVgvNGNQRnNSTFJDb09XdHNtejBCZTNrRWYxZWhaVHF0aWps?=
 =?utf-8?B?QzhiVVp6N1VLL0RKWDYzM2dxQ3ZWdW5mVC9ZNGtURWtSQ2pzbDZmdmIxNlZr?=
 =?utf-8?B?SU9zMkIvWWIzSUlmeDArcVh0TG56bmdOQS9RaGlsSUhtQmt3TVpoS1BRcVpu?=
 =?utf-8?B?eVpISGhWZ2plTlVCZmM2anZldUZjSXo0cHExVnNVWmUydnNnUld4aERzdkwv?=
 =?utf-8?B?bWk5WFNDcnZJaDJBc0hIVFp5eTFsQWZmZW8vRkdwWjF6YmtwRUQwNXJqWkpE?=
 =?utf-8?B?VDVzRTVjZ2hQWUEwemVZL2ZWVEhSM1FtT2FmOW9oenE5UkhtWFh0MXI1T0tq?=
 =?utf-8?B?WmFDd1dxOFhqbnJaZ2lnUy92d2pjNTMreWwvcjdITHM1dTNrOTV1SEdINzJB?=
 =?utf-8?B?dmg4TCtUa2J1bGdGS3RCdy9IUThJbHBNUGNzdHBFaEpUdWcxUDJ4UGhIYWRx?=
 =?utf-8?B?UmZBUE1rVnZLMEdkUzN1aXhBZ0Qyb1JIQjRpYmVuY2hGaGEwem1Candrak1p?=
 =?utf-8?B?MVo0aDhiSHVqMy93TExqcmJzN2VubVRPellmQTFMWUQ5VkxidlZSUHc1bHkr?=
 =?utf-8?B?b2FqVHBCODlVZmVoZzY3MkNhSDhmRDdhaUVuWmRtRC9VVkJoZmtySUJjQ0Nn?=
 =?utf-8?B?aTdqc1JacmZjZWJCWFNQVE1ETU5vU0I5dG9SREo4OTRyREZiNHVHSkp6cENk?=
 =?utf-8?B?MmExd29VMzdmZFMvT1o1NWt2NVVBeDNENmhacjlFVlR5TmZPM3liK21MblBY?=
 =?utf-8?B?eXRXdFl5RUdwUW9LRHZIbENQWDVCQmxIdFBBbVR0SnU3UEg5Nk05NDllcnU1?=
 =?utf-8?B?elRxTm91UzJyZG9KQVJYZnVoUnFhREYra0F4enAxY0cyZ0NxK0FiMVgvaytM?=
 =?utf-8?B?dVV4amE5b0FtSkR1U09wVTVWblpXa0IwcC92blljd2xzVFBpakFFeHNtaTRi?=
 =?utf-8?B?aldSVzFNWE14TVFQVVBoT3FqWHdsdzMxeXFqdEVHZXE0TkZ5NWgzTmhBNXVG?=
 =?utf-8?B?RkRXR1FxbVo2U0lhT3F6YW9Zd1pMMFp2TzRucHVndDRQeGFEWHBvelJBR3dq?=
 =?utf-8?B?R05CcDZnSEs3Nm5jdGlvUjQ1U2JkS1F0Witjd3BIdWptUFpuT3Q4djRLV0ZV?=
 =?utf-8?B?M0Y0V0ZIRkRja0IxT2QrOU9YY2FpdlFidWxzTm9wN1MzRDRzM1NHemU3WUVo?=
 =?utf-8?B?dHV0emkvTXNUMHBCdkY0dzVpRjJOYnY1czJwNlIyQ2huRENYMkR1M3BCcHhk?=
 =?utf-8?B?bGhKd0Nsdjh1b1l2RXVzRWY5cDRLTm5VV2tiTGV4OVBLZ1FJN0tCcGxodTd5?=
 =?utf-8?B?dXJZRFNYRW12emZienpYcGFwWGJ5VUJpMGljQ1NiaDM1eE5ydmo0bkFPMDJR?=
 =?utf-8?B?NXo2VmZPSlB2VmZ3MDk1ZmV6b0FjNGZOQlE2L01RWURFdm11d3V6djg4SzBx?=
 =?utf-8?B?V1hzNi9UOGJ0NituV21xUjQ0QVcxZ2RFSUtKem5qQ3AvWEI2d05GNnZrbUJ6?=
 =?utf-8?B?R0xFSndjczR3djFuRFR0SlB5K2pxeU03eU1QQ3NXOE1JMGxTMWJLNGNmU3E1?=
 =?utf-8?B?Ui9ZYS9WTGRRR2tSak5JdWhwZTJFZVhzMGVzVVdFWFU1WGlQdER0YTFZN09H?=
 =?utf-8?B?cGd2ZWMxa3ZtWXFwT1BPTzdxb1l2MDl3bVY0L2VIaUJPdWJYZlo1cGxRRFBY?=
 =?utf-8?B?QVlpdzFLQ29iSi9zSEZvUWJja3crcGg3dUh2Si9rOEF1Tkxxc1NCR2hQL2lQ?=
 =?utf-8?B?L2gwV2dud05RSC8xVXlkdEJkSmx4R0gwb0dwb0NnTmxUTTdzNGd3UmVmUDBx?=
 =?utf-8?B?Rk1IeGpCZXVKU3RWRTM4OHNDUStCU1JwTVlHcGg1K0VwWktWQUgwazRzdXk1?=
 =?utf-8?B?REUwOGVSVUMyUitIUFlGSUhTZmo0VXY2TWxpaVZVbWovWVNnUitpV2hrbFBM?=
 =?utf-8?B?UWpFZXFCU3I1a0pTNldBZ3JsYXkwRmNRQ3lBdVY3QklkMkVoaU9MN1BsMG9s?=
 =?utf-8?B?Y1JjS1BRWmhCZmNHaVFkaW9WWTcyWkI3d2phRmVnL1AzM0djZGN3VHdudUQw?=
 =?utf-8?B?M0UyQWJzNEN0bGZoZ1h3SWRrNFV3TkcwQXljdmprK1htbGVhRlRtbll5bzhR?=
 =?utf-8?Q?5YmocmvO2rwhEJubEj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e4b5080-e77b-415e-83d9-08de6413ab3e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 17:34:37.4857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dQaq8Yjbf2sQhKrlkSJE5faUCuAxFHidhOtoEdfU/ExR2E95fslQbfgJScUPmqSi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9002
X-Rspamd-Server: rspam12
X-Stat-Signature: e15xhkm7chht41qdb7k687f3fy3ydq4o
X-Rspamd-Queue-Id: 1F63D140003
X-Rspam-User: 
X-HE-Tag: 1770226482-320483
X-HE-Meta: U2FsdGVkX1/j0+VTbF9xZ568VG4yLydKTMmG39dc5bsttmjFyk0xLCILYkpOxoowDT2zEu5itvSjlnpMABZP5yPh9CiJWvJawN7rQ1M3b6lO+tEJjwegLt7D7uN1lH6hwPDwVPhhoehF6nYx9HVQgyM/ZSRdqqCevPLIeGeSq8Ca6gQQvMnWjWcOwH1Wl1z1V9j3L5j6TaN/ZsIcrFT2SNGtK5BLdXNsBkluqKvyJH7ueNSicnT9P7EfRjwe4vqfAEw1qB6RTAiwzCDwMo6ucIZHK0MSPE4IUooWvejB9LZ/Oh1rPVCqQ3wC/rOn6hLis5/FmbGyqJXkXnfzKVhhzIdyxkHkD+0uPQrhOjm3hT6b8s4Ov6ocQ/943hpry9qAKwSmRxN8Aq37eTeMfszFVqtgBP3CAGGr0iOrepx6mibdlG2QKfbQYJ2997M2SC1MdjBMJ5fAdMAmx9ev+QG/HllI0UC0zkLJgWX4LdpkDxsZxV7Sk7kY/65qmPHQXav6tkZNzsNUps4NvL+NoRJiBUH2IWygpvEQQ+5raJCwc09PP+9eFsNAt431tdvS3IBmB9dLnaUtH+4iFnLqmG071jHF2zw+tyQVOt22/Z7ajT/IRwRxaAbIm+9XcnqZZCnLqzAG8a7OyqNafdJtE5VRP8sw519Hnv8RCURq5x3F9Ottju58BmRgNfzrlyUtf0brBjP700Gg0wvs2gW2Zjyd+6PYuugHTcoTErvE8IzpxVHUAaaKv9mAWLfW66UWdIu3f9+YXt2O0lypCQVE9cD56xjFV3A1J3dtkANCfbgY5oOPmSY9Xa0umLudVZAORk1RZfx2w6xel2tBlF13Sh9mXWGWysLoB2VcNqehAstRz4Jkr9SGti89jtrqOWrnl08E72xWJoEIRx7pDM2MHFa1XNN++Ww0c6sd7hoYKUn/suhl6t4vImIhWYsRnvi2LCkSNuNSfPmQcfnMUF7n+Id
 XTwmPVKn
 rPVF2HpR7QRpHhDZM76h1uKelsNYTEdT49gOY9CTyozPCeY1XIJOZZzUl8iyK+pHBKM0JjvbsEsGYNf00/Lao6iO4hXjm6tW5Z7kO+f8hz0dwqA0E6taGIs5FRaED8FTEf4QJ7XGb0sr4rCwICFKdJTifJAX/gZsxYIa5bPX+zR8KDfRS+j4rNG54uYJ0rXnYbk2UHQHvq757mt9wBBq/fxFDQTU7df63aZiMu6WzKuJNazmcqRcBgwykxMLNBOM04wEbbyW5iHDNM2W+QkZYt7ncbBSHsBELoCQ0+nwKt7hcrO/QK+iM5yD9sM4ov0MEfzBiMg2vYCNF/TW4mOii4ZHFWyIF57yujKVbB00cFFr79UXu2igBVdInF/2mV5TRDat/fP2m4Ff3+wzxBVlNT5dfqhCTgUVnvIqthap5jMgyTvZzcHtfFs1t3i1sGNHWE8B9D3gsWLzV51FLT4zumdAiIOFylqjh/0eNEX8lCOr/mqNmdP4nw9lojqhjFxb81leImGhlAPz769LbMtuhvGLHD7tVO8GLXqHkP6Cfzo1F3hc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4 Feb 2026, at 12:23, Zi Yan wrote:

> On 4 Feb 2026, at 12:15, David Hildenbrand (arm) wrote:
>
>> On 2/4/26 18:12, David Hildenbrand (arm) wrote:
>>> On 2/4/26 13:49, =E6=98=AF=E5=8F=82=E5=B7=AE wrote:
>>>> Hi,
>>>> I=E2=80=99m reporting a reproducible WARNING triggered in the hwpoison=
 / memory_failure path when injecting a hardware-poison event via madvise(M=
ADV_HWPOISON).
>>>>
>>>> The warning is triggered by a syzkaller C reproducer that:
>>>> maps a file-backed region with MAP_FIXED, touches related VMAs, and th=
en
>>>> calls madvise()=C2=A0with MADV_HWPOISON=C2=A0over a large range.
>>>> The kernel reports a VM_WARN_ON_ONCE_FOLIO(1)=C2=A0from memory_failure=
()=C2=A0and points to include/linux/huge_mm.h:635, suggesting an unexpected=
 folio/page state encountered while handling a poisoned compound/huge folio=
.
>>>>
>>>> The target page appears to be a compound head page (order:3) already m=
arked hwpoison. memory_failure() seems to reach a branch that unconditional=
ly warns (VM_WARN_ON_ONCE_FOLIO(1) at include/linux/ huge_mm.h:635), which =
usually indicates an =E2=80=9Cunreachable=E2=80=9D/unexpected folio type or=
 state transition in the huge/compound folio handling logic during hwpoison=
 processing.
>>>>
>>>> This looks like a kernel-side invariant violation rather than a pure u=
serspace misuse, since the warning is emitted from an unconditional VM_WARN=
_ON_ONCE_FOLIO(1) site.
>>>>
>>>> Reproducer:
>>>> C reproducer: https://pastebin.com/raw/UxennX2B
>>>> console output: https://pastebin.com/raw/wrhKRwZY
>>>> kernel config: https://pastebin.com/raw/dP93yBLn
>>>>
>>>> Kernel:
>>>>
>>>> HEAD commit: 63804fed149a6750ffd28610c5c1c98cce6bd377
>>>>
>>>> =C2=A0=C2=A0git tree: torvalds/linux
>>>>
>>>> kernel version: 6.19.0-rc7 =C2=A0(QEMU Ubuntu 24.10)
>>>
>>> @Zi Yan, this is weird.
>>>
>>> We run into the VM_WARN_ON_ONCE_FOLIO(1, folio); in min_order_for_split=
(),
>>> which is only active with !CONFIG_TRANSPARENT_HUGEPAGE.
>>>
>>> But how do we get a large folio in that case? folio_test_large(folio) s=
ucceeded.
>>>
>>> I think we rules out hugetlb before in that function.
>>>
>>>
>>> Looking into the full console output, this is an order-3 folio (fully m=
apped).
>>>
>>> How do we end up with a large folio here? I am only aware of that happe=
ning when something would
>>> allocate an order-3 compound page (not a folio) and map it into the pag=
e tables. Yes, that
>>> is nasty and can still happen, not sure yet though whether that is real=
ly what the reproducer
>>> triggers.
>>
>> Looking again,
>>
>> mapping:0000000000000000 index:0xffff88800fe2e600
>>
>> At least mapping=3D=3D0 could indicate a non-folio thing.
>
> From the C repro above, syzbot opened a dev "/dev/sg#" and did mmap on it=
.
> Is it a device driver issue?

OK, it is CONFIG_CHR_DEV_SG. And the driver allocates a compound page at[1]=
.
Since we initialize folio fields in prep_compound_page(), it becomes a foli=
o
when it is inserted into a VMA.

It seems that my compound page and folio code separation patchset comes rig=
ht
on time[2]. Basically, compound page should not be a folio.
With !CONFIG_TRANSPARENT_HUGEPAGE, __GFP_COMP for allocating a compound pag=
e
that is used as a folio should be rejected.

[1] https://elixir.bootlin.com/linux/v6.18.6/source/drivers/scsi/sg.c#L1868
[2] https://lore.kernel.org/all/20260130034818.472804-1-ziy@nvidia.com/

--
Best Regards,
Yan, Zi

