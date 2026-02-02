Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A1D3E7DEFC
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 16:01:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E3326B00BD; Mon,  2 Feb 2026 11:01:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BADD6B00BE; Mon,  2 Feb 2026 11:01:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFBB96B00BF; Mon,  2 Feb 2026 11:01:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DD40E6B00BD
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 11:01:13 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A8C78C09B3
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 16:01:13 +0000 (UTC)
X-FDA: 84399980826.18.53B57CA
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012064.outbound.protection.outlook.com [40.107.200.64])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9D7101A0014
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 16:01:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rudUqAts;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.64 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770048070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HdxF+dCFkuQ2gpwAPt7ovdEaMvNDVuhwV4LlXYtE4Wo=;
	b=1T3P8hmTNz7tpgEa/0ubKhfXluzwcUk+2Z5km5rT+9ytPTAAbQnXPRYMTP8YKaAmeFcr1B
	k9jbBmZCXq178v3xP9Om5r2JXJs50jnSJ6FxaoK6gTU9nEbod6YtgGwBOmp/QFrrHUbG9f
	7x9YjbnIzYyxgp4iPiNnGEPH06Ayo6g=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770048070; a=rsa-sha256;
	cv=pass;
	b=VsV5CA6mxHFYYNPgrZkhSe1Vg0jrSmZlr1AHnS3U5750vphsAh+yWC+S3YEuS7cGD+cFAg
	bDZLwci71W4aGD9gj7hndsW4j/E0K5xzY2mxx+yGNP+jfcfDSQpEHz9sH/ON5RJ270bmIv
	xIm6nhbWG7bJh5r8YDIXh9q6HzQNM7Q=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rudUqAts;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.64 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MuTJdyHnN/1sW+sey+4Y8NaVSpPrZCtU7xhuddQhvZga9mahz2wWJoqJ8cMdBSTkoq4dXbWgYmPWqVJ+TD/81NQFrPrC/43CkusqA6RCfoYJ7Gk8vEhA3Pp3zSz1ruMebVojkpygCewWhoIqqaADD41NFIw2KO0/yMoz/aAq28DFJokc9cc+eVRg65ltmQXKUNmbmYDft3zP7DVbsx6MFhtq+iyvn2TqGfbGhJ4KFc/nIdQgf8zXevXmTLVBPkOUQMZpUmWHzduavklC+HzNozbk4rYI8IIjzEgPaOtfGQVHOH5i6X0tLDP5F/kZpis3ZAxgNph45JOHPn8CYBhvqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HdxF+dCFkuQ2gpwAPt7ovdEaMvNDVuhwV4LlXYtE4Wo=;
 b=qDe3SrtBASdh0oNAJEximYA9LrAwK3/CILsOxZe1DH4H+BKSyMUC/PjWsPKkWPXfiFqizUEfre847966I2QBq8fyt0Sys4CIKoar9VvrlJVimDJdK1Z6Z4f5U8ZpL3qrfzHWDjWDOCLSWP2lDwHqcfekqrb/Ku6orly3Z9/8OwtpIFjF/eIs1YUG/zi9dojixjhs1egyLAWb1BfPz2hxHLQOtVwloT1Z/l0j6ckhLyL4E0CBf1eAMUdPUPvySKnGHRKVPccwg47kBIkJHZXY+i/4s8RrzdDmhYPuvBJPgouEL2EGWaD83LNRtJLmu3qcF+NC3IjZRAuchEvhWpaE0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HdxF+dCFkuQ2gpwAPt7ovdEaMvNDVuhwV4LlXYtE4Wo=;
 b=rudUqAtsdYG8ZZcvHRBeHwMFcfYYNUXH5MbjQHpWPej3SN99JuWlNr36DkZvFJXgGiuV7NbQx2v3mu1sTufPLsV9MZGwGo4FHi/n1clfGp7k2myYn9Y5z0L3/Mjy0UhoxwjrpzF7pK8se+mHNNo6KcwOf49gveR+20onp8Gjrun+XtWzNlkgafnMVYJazws1rfin3MNglNPrxK59gdxwIzjBSEMt6PLUcXN5NJ34MsfjdUxQeZPjGyAii0Zs5p0+c7bXmkFBPH8VxomKFGgZv92HVCJiaFwO9EEcfTqKgN07uzMufjSMw7W+GupiDftgu8jIpdG7Wu1h90Fxob03uQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV3PR12MB9331.namprd12.prod.outlook.com (2603:10b6:408:219::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.12; Mon, 2 Feb
 2026 16:01:06 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9564.016; Mon, 2 Feb 2026
 16:01:06 +0000
From: Zi Yan <ziy@nvidia.com>
To: Usama Arif <usamaarif642@gmail.com>, Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, lorenzo.stoakes@oracle.com,
 linux-mm@kvack.org, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [RFC 01/12] mm: add PUD THP ptdesc and rmap support
Date: Mon, 02 Feb 2026 11:01:00 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <63D23D5F-AF35-4199-B52E-DFFC16DFDF91@nvidia.com>
In-Reply-To: <aYB75cWO2nnTx2ch@thinkstation>
References: <20260202005451.774496-1-usamaarif642@gmail.com>
 <20260202005451.774496-2-usamaarif642@gmail.com>
 <aYB75cWO2nnTx2ch@thinkstation>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR13CA0183.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::8) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV3PR12MB9331:EE_
X-MS-Office365-Filtering-Correlation-Id: bb1b97ad-9d38-4655-059f-08de627445fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tr0D6ycbOMlZdPq1IPakKC21TTIjVHY1Bz/OFR/ejlbBfGT084bKl7v+vL8l?=
 =?us-ascii?Q?FzlDUOSJnOfivhrOR4GPu0xYRpE6yzgD102m37ercNb8xzJkp2JSjLcySQqq?=
 =?us-ascii?Q?kc9RH31bVmNaV3jC6VT7zO2aaRMO0Nmw9mkjUH5d4Kby1gRZKLOsHcFsi5Ug?=
 =?us-ascii?Q?tfszoJKIV4MPINXTZu26ajNKm1v95e+Wj0IRFaC1L4aOOnzkyD1e8fN2eqvl?=
 =?us-ascii?Q?VroyZ4LdJSAqlpF8jV8Htk/OrDe64CD7ZLpMjGj7Tj+R9GHerSBCHEGfwg8F?=
 =?us-ascii?Q?8hg8URcIZyx74NFp/tMw6JM/TKNphva9ojmCFu6JK+p8rMqzcQCOfdSOd+IE?=
 =?us-ascii?Q?Z64Vy0WeH6XRU06LcfCrqZbbNOui5fVDjCxitXIiFKrTpIZH9RdJ2r3XXvaG?=
 =?us-ascii?Q?6nhnaYthTIu4EK3WNZhZNCUKvkXcYpNiVa7cEsuudcr5ND+be5OhZppfx485?=
 =?us-ascii?Q?lHEdCmPhMYtIf771h8XMdoE7KQ+94SzM70143rEySWpeRpfIvKe/xus4iQD0?=
 =?us-ascii?Q?89Rb5kWEM6Q5oFLq6bOiFZ8htinzwaisu7y4laXhSE0Q0oVcotGCzU8CeiTt?=
 =?us-ascii?Q?+3V/zrGd4KzXyG2OTyCcrE8+iEnMp5X4ZV00LAdXL9VM64JgfaZkvku6JR9x?=
 =?us-ascii?Q?RB3uKjmY29wJYgYK335fhty8HYUH/OZVyRFAbQrem+/UhqWeLFCUoYjCFI0D?=
 =?us-ascii?Q?H8HW3zIS7fI0it9VZTxGeQtcCgixCuP/QkoBMMVfSX5q4YCjYjtbqwo5Z1Lw?=
 =?us-ascii?Q?E/+gM7xJ2JTRtVO9dfXx5ZcfWSc2xpKN0c0iiCY3AtCEZ1SA8tsJFxouXGZw?=
 =?us-ascii?Q?xgOutUTnNvyouJxJ+/PmAkcMJPXly4+Vu3LTchLyPtild+b9Ri40O91wkNmp?=
 =?us-ascii?Q?cirJ/AFlXC8KVOnyH3VR9rcsveZ8ZX3SfdwGbohipsCKPJ3pBUV+CX1gNKzq?=
 =?us-ascii?Q?hTqc1QyOZDrLZg+iMhFDQR13iQvcFXMmAFoBaFjqULtK5rFWdUiwWKqB7kv0?=
 =?us-ascii?Q?ITvKsO2dJtXYR9R8fuHabw1II8+pLfrr/1Dt1yDBWFCBdd4/TrWBhdbN7Jdi?=
 =?us-ascii?Q?3gCdjUVz5e9VsYj8Cp6+un76HLuVY2DLSijoj4+GkztVXifyooXvG43l6sMt?=
 =?us-ascii?Q?swTkVNmjdrHoxDCdgK6coo+0jGwD0okqZvaOsrrlMFpjt9gvYZ2c4tz83ThN?=
 =?us-ascii?Q?gBCwseP+NViJV96NP69KfU46JMPbAKRKm4YZTR2qq8UWhGTRHjOUY5mv6hdq?=
 =?us-ascii?Q?9GHCR+45C2Q3nSblHhiwtIsSYqpI0Uvx0A0gHKs2ES4gHqPer5z36PedbMKD?=
 =?us-ascii?Q?xiz5EA6yKu/025Psczqa2Gbq/d2RvE19bo9fRVRcPHRF3nRHlWfFNAnCwwRx?=
 =?us-ascii?Q?LqUiDoKyhuUfFgqJV4lLckRJSSrbNOgZNT+XwqcDolQiA0kE5XpRRHETN6iy?=
 =?us-ascii?Q?s4LDV51FvIVXTljp1lqO3qXA9T4YpjQ6Z1zRp+n2oLI7b9UHC9EgQw/0ylmH?=
 =?us-ascii?Q?6Gy8zZpWaBJwIwMp17cN2PHOW1b2Z4xSf+o2e9IeZt7RqFLpjzZ+sVpd83Q/?=
 =?us-ascii?Q?MTk7C/AKwB/s6ZqCRKc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WavEkHQsqjJvisoivkTJRmn2bsEKTmRtNfa/FAJYzAPcLCO8fF4A/oWsS3OL?=
 =?us-ascii?Q?ceC9QPayZuUhKR3LUqV38ymUmN+V6KOdwoHPAoV2MAuq38xjFigS3mqCKvbI?=
 =?us-ascii?Q?TA+HhHeL5+3oIYhcrqIhIPHNtrQA3xXfbYqctqHpeo+PO0y/zDX6tzBWgqdz?=
 =?us-ascii?Q?fSgwcaPutRt2xu/fnqv0ReXoTYu0oTRtqMnQHD+n9tbd3eE6hNRNmOKhi1KX?=
 =?us-ascii?Q?waGxCtjwfsNJH/Ykm1PDEdj0qG9Ngs2QSolVnP0Tul+Hm7URPPCnzQlnJvpF?=
 =?us-ascii?Q?8wpDpFAake298hc7TpiglKXoukNT1lmyOHWTxKlDLuLDfDJrzFdsfNmtEJXc?=
 =?us-ascii?Q?84xxEV+yGt/d8DL3ulZJ4tX4ceipdpaTTPNL3QgS1pAjojRacJrKVjZi2hSV?=
 =?us-ascii?Q?rRLGzxhKO+T54mdd0pKAYUOKbhSrZ2dYREv4kmuNe1T9AiVNYkwPQmxpreYm?=
 =?us-ascii?Q?Jxw2OsRg5+1OD6ciPVwhuMLaaDX8fMOPLkVXCRCtJUmzI9M4syK64CYApcDY?=
 =?us-ascii?Q?4cuQuVvzweJHQdrvqpXmG85dxWmc6422LGy8Cv+hioIb2Pf46wBAHyKMDKZ9?=
 =?us-ascii?Q?7cJa9Kof7HdX4qjPQt6Iok+Vg38u+AuU0Z0ns5xzqRqTBjS0LuJ68mQM7VIq?=
 =?us-ascii?Q?WSn5qpysppchYRQDfEBR9SG8DyHd3k7isunqp/FphRgZDkjoiWtJLlokeGlH?=
 =?us-ascii?Q?pnCG7H9kcbsBt5VGojXByBzGXU7ZdV6pMdPvQL5u8NDp7wKrt1B5gIOycJpw?=
 =?us-ascii?Q?kIkuSmCYBUHW8/uoZ/ktP4WOuXy+fawaLMfh3NC6XQIw3wRPnk6kpoxT7E+D?=
 =?us-ascii?Q?S8JYQ6Xu4opJRIe901iSZ+AGfxzBj/AAlfmTI2cb+2Nucmc+JqTs2nwfcO7M?=
 =?us-ascii?Q?gJI8uzs+PO8KM4eK2Inr99CALyT4bR3VGGZ8PyNVt3fMRGbHBrwbcMqoBNJU?=
 =?us-ascii?Q?rwj7vgR5DkTbmam1nhCu9a1pJGgcd/bfW3c0/7xIrQG+aFZw+ZcW+14OVNbc?=
 =?us-ascii?Q?5f4S8+87QAMcBtVni1DWEkQRKlGF0mnYFkRdZCofzce/rhp17dRiGj51haK6?=
 =?us-ascii?Q?cLPgjibVUhRFgXTb+uhwD89qcuYSUCfSIuxJRqAL8B991TTzDa9yEg7YT4+S?=
 =?us-ascii?Q?3iLPRkD+03TrBkNHHLFUUleo/9pcrtf6AIQVuO3T2qBc4dyzh7w9DIwrK7fC?=
 =?us-ascii?Q?hriQ8cOuogLQZtmb/AorYRLyyhhU0Gxs6Ryz13DysHOWmPFTtoQfDTNBa4rx?=
 =?us-ascii?Q?2nDPcVNfdDk7iykpFarhiQeadA7FePcdSMNSEDA4IyrCxQ86xzo/g/wAgUmi?=
 =?us-ascii?Q?Zl3LRWgJh6L1R8EeA/sho/ivXdpH6KMo1TGh1XtomnCM1tb67LFUDrh7rcJU?=
 =?us-ascii?Q?7U0M401cLU/jF+a+fyVq4PVkLqMLXyrG46qk3ekQGkGwkaJWjbP7qG7lJszQ?=
 =?us-ascii?Q?6pJYumsMQc+ZdC4FhdqJGItTRjvh9oynugg7cgkPR5GIBWSPauyUkPaADnVc?=
 =?us-ascii?Q?2fwVu2K0/dPd1weDDdzzssQD2P3P8ynF227etHb0mZm/JqLr1yp4dXdHtST3?=
 =?us-ascii?Q?9Hc/Fk/7T6Sc17LBtxpQmpEaCf7L+wl0S83p8ESMw7tCMqZEyLE5Qm5OtwzN?=
 =?us-ascii?Q?3QmT/uhbE+JTcCUjpcnX8jsIK3iVHg8ExNLkyeGcmOMc2gbtgVoOO5ElhsSF?=
 =?us-ascii?Q?ab2T0c+BmU10uoWfgFeal/ZiYeVQBS7Bv0L2lvtwc5hQRM7q?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb1b97ad-9d38-4655-059f-08de627445fa
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2026 16:01:06.4984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8CxL2c2x5BB5X7Tq9sQyUgobmg/Hx0U2NffmizDpCCvNWLk66TCRDWeaMfSQBcCV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9331
X-Rspamd-Queue-Id: 9D7101A0014
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: bpbjfz1q4o9hihmt8n16t1tseeq6dujr
X-HE-Tag: 1770048070-254127
X-HE-Meta: U2FsdGVkX1/UerdTx5pPS0A9AJOw6iaLUFceXc/6Q6GP45JAy2wHmpiLB5LCSX6x4enZZShrr7FQZBdfYs5l0JG3kwokQSwsWrH4oAGEYbgSrgsDwSRJKnYGr+usGYbu+fKq1YID3zQxa7fKh5Uh/v8arzhwmoWoNYDBJYyGWmI09kUehr/HVNB2Vliqo8LM3dxPb7y4vTywmvgzyaDDi0C9luIguZ4u3VtEKW5QBENzMND7yfI++uGsUFi6Htes9WNV7A6ICqOHbehDnoBB9Okv6CCx5pFBK7k4PN6s9Kh42hySppeZgcZ4UntBtcmwS9Zgtug9EXuKCAGQPZ9KG9q9yzMNOriIg5/3IJIJErabzBZ2XJc+o7gdYP9ZrVjAdF5SKi4mAp7VlPiF93FZdQTz1Rj8hIqxO4kJaN9aRWbXQbJbGE5OkkD/XH2X1lF2JShX3UicS7FnERdB2IqPAMUnqH3O1Rh4IX3nAGQR6cdsEdhDBKlNAvmXvIN3SV8YAh/+UKvXMOPTSk9OwgiyM64Y+xhyuw5Tq7c9jAhnvq6xqO3BPn+vF8X7RaIsXTio5EHMpF6M9TpnH4OGY6Lhh534/xmevipGmzH/6rKnf2RzmJ7kqc46FfZQDReip6yxcjlE/ogg1p1cLw4bpfAL0z/UtIGqmJWclMkFbMRNLs1y4r9mRIqUFxP9JY35rRy14el9i8/FIUDlXavfCQxgOHNsuqeoP4T2H7aigJ/RWdqIn9Et1ead0jjeJzdYDfGhGNjaMN4Vq2PN+s6PyyOSgmsnPcOuRvwtvaLk+bXAZ6XNTminKi849t+dTYY31NkNFhYnRFFd80mm3/ilva9Y/47TDkg47D8eXH5s+wRg+iZ1mSilGDLyZ4HDy/0i7l9gXtcdSL4Wte4WHXLy7q4ZiMiPtkQmJyFkgaFLw4gAS8TqVQJmBHO0wG1ErOGv6I26EsyPVfDqbEkQJnSNUSD
 MQt1DRTF
 9Z2xUMc+jbKAz7Mse8sYhKcVr+c+qgJGSQIm5mXbKl6gtXriAG9F3ARx1SPSV4go5RR0Q8lE0JR4Yg5h0T90/MTNoNu6HROquomr8ulaE9niDwqVNkw/4OOeorIX3JNQXm1mEpD5+GSnM3usfhs8ot1VIhmxZueONqYV2OayNgii898Wyd13DECoSMXU6YchJhp+b1c5gz9qpE6wVEMUTwc8S4UbL9Bo4KQv8l3y7IDCFS5w4EqVv6LnInXV1vlIqrWntTAiPxqleXiHRn8VPeto3DqbE9qoT2uVyllkKwKeb5RlODCPb9YuqxnZketkor8vh9mqlg/3hwcMTX7i5bMU/PoZ+Od4dihh9Pe7wvz91DANJGzfgTNNJhRphosyFJ4TVP/s0e0IfXORIZ7Rxw75eNBvIHzrjr1puc+vq4brYwalQaQtYqGq7ef/I+bXr1e+e5ygPL8Y/aWeUjI9eaQOMYuIxWyAHVSsEcFut2i4dWD6yclvNHhpmMLBka6uDYnGa0ZKmqPxClxKnYyRpwOG52Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2 Feb 2026, at 5:44, Kiryl Shutsemau wrote:

> On Sun, Feb 01, 2026 at 04:50:18PM -0800, Usama Arif wrote:
>> For page table management, PUD THPs need to pre-deposit page tables
>> that will be used when the huge page is later split. When a PUD THP
>> is allocated, we cannot know in advance when or why it might need to
>> be split (COW, partial unmap, reclaim), but we need page tables ready
>> for that eventuality. Similar to how PMD THPs deposit a single PTE
>> table, PUD THPs deposit a PMD table which itself contains deposited
>> PTE tables - a two-level deposit. This commit adds the deposit/withdra=
w
>> infrastructure and a new pud_huge_pmd field in ptdesc to store the
>> deposited PMD.
>>
>> The deposited PMD tables are stored as a singly-linked stack using onl=
y
>> page->lru.next as the link pointer. A doubly-linked list using the
>> standard list_head mechanism would cause memory corruption: list_del()=

>> poisons both lru.next (offset 8) and lru.prev (offset 16), but lru.pre=
v
>> overlaps with ptdesc->pmd_huge_pte at offset 16. Since deposited PMD
>> tables have their own deposited PTE tables stored in pmd_huge_pte,
>> poisoning lru.prev would corrupt the PTE table list and cause crashes
>> when withdrawing PTE tables during split. PMD THPs don't have this
>> problem because their deposited PTE tables don't have sub-deposits.
>> Using only lru.next avoids the overlap entirely.
>>
>> For reverse mapping, PUD THPs need the same rmap support that PMD THPs=

>> have. The page_vma_mapped_walk() function is extended to recognize and=

>> handle PUD-mapped folios during rmap traversal. A new TTU_SPLIT_HUGE_P=
UD
>> flag tells the unmap path to split PUD THPs before proceeding, since
>> there is no PUD-level migration entry format - the split converts the
>> single PUD mapping into individual PTE mappings that can be migrated
>> or swapped normally.
>>
>> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
>> ---
>>  include/linux/huge_mm.h  |  5 +++
>>  include/linux/mm.h       | 19 ++++++++
>>  include/linux/mm_types.h |  5 ++-
>>  include/linux/pgtable.h  |  8 ++++
>>  include/linux/rmap.h     |  7 ++-
>>  mm/huge_memory.c         |  8 ++++
>>  mm/internal.h            |  3 ++
>>  mm/page_vma_mapped.c     | 35 +++++++++++++++
>>  mm/pgtable-generic.c     | 83 ++++++++++++++++++++++++++++++++++
>>  mm/rmap.c                | 96 +++++++++++++++++++++++++++++++++++++--=
-
>>  10 files changed, 260 insertions(+), 9 deletions(-)
>>

<snip>

>> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
>> index d3aec7a9926ad..2047558ddcd79 100644
>> --- a/mm/pgtable-generic.c
>> +++ b/mm/pgtable-generic.c
>> @@ -195,6 +195,89 @@ pgtable_t pgtable_trans_huge_withdraw(struct mm_s=
truct *mm, pmd_t *pmdp)
>>  }
>>  #endif
>>
>> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
>> +/*
>> + * Deposit page tables for PUD THP.
>> + * Called with PUD lock held. Stores PMD tables in a singly-linked st=
ack
>> + * via pud_huge_pmd, using only pmd_page->lru.next as the link pointe=
r.
>> + *
>> + * IMPORTANT: We use only lru.next (offset 8) for linking, NOT the fu=
ll
>> + * list_head. This is because lru.prev (offset 16) overlaps with
>> + * ptdesc->pmd_huge_pte, which stores the PMD table's deposited PTE t=
ables.
>> + * Using list_del() would corrupt pmd_huge_pte with LIST_POISON2.
>
> This is ugly.
>
> Sounds like you want to use llist_node/head instead of list_head for th=
is.
>
> You might able to avoid taking the lock in some cases. Note that
> pud_lockptr() is mm->page_table_lock as of now.

I agree. I used llist_node/head in my implementation[1] and it works.
I have an illustration at[2] to show the concept. Feel free to reuse the =
code.


[1] https://lore.kernel.org/all/20200928193428.GB30994@casper.infradead.o=
rg/
[2] https://normal.zone/blog/2021-01-04-linux-1gb-thp-2/#new-mechanism

Best Regards,
Yan, Zi

