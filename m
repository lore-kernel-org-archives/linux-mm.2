Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB0A1D3B7D0
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 16:42:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F4086B0007; Sat,  6 Dec 2025 11:42:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CB2E6B0008; Sat,  6 Dec 2025 11:42:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3935B6B000A; Sat,  6 Dec 2025 11:42:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 290AE6B0007
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 11:42:56 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C393ABA24A
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 16:42:55 +0000 (UTC)
X-FDA: 84189615510.27.07497EC
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4F5BA10000A
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 16:42:52 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SLSHX3Xy;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="s/uSM7UK";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765039372; a=rsa-sha256;
	cv=pass;
	b=tCLQrkzAFXx/mN+++ZrX3+g/p4PfbHe/z45fHxEve4xkHhvHrP5J9/2HAi/7hXidEXbQzw
	NtT71ZtY+NwnUGJJYDKUdFC58FFLyQ3AusWYKRwjImhkEaJlQ0I5Sqf/1gdJFJ1I2FRYn/
	H/nn/xtZJ6hDDxhb85eXIpz+hEf6Jrs=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SLSHX3Xy;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="s/uSM7UK";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765039372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ftAvfPYWrLMpfwn71IRRWmVXQYbJbGynhCgsmF2ils=;
	b=AljLdliZ7CoONXE3GKjw8Kdogo6mDR31CQTTPUSZsN+JNO0afMOX0TEBtidYqS2VmaUALJ
	G+Li7y5OwaK4UwYRbQLhgDyIm7svPN4JNOujA+NO67QA0zCS1NyeTBmuUmlV0DbIPzk4/d
	OgUqwPOPgiA5DVKWorX3TmU9pPEA+6Y=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B6Gb1Jd2431688;
	Sat, 6 Dec 2025 16:42:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=2ftAvfPYWrLMpfwn71
	IRRWmVXQYbJbGynhCgsmF2ils=; b=SLSHX3XyLeeqlJZzPza/OIMhmmRn3c0AKy
	TgRH5xGsWW115g9ekiFm1yRUIUbO/qOICwZDuD9BC4kBD/xj550BzVAaXUC0bus/
	OenFEUR6BYo9JB0oJLWamXJUTdMeRF6AxMRRDDWnu0LLmOZhnEbvw9UD+O/jQX09
	PUXdxnHk2NvRyVVulrReaQM0P+0hE298GrRk1XU1wE8wmwRt5Be4ZRkCVhmMLUD4
	EhLTrsnzPw50nkwEW6S8nErWCk500MqV4cdbdvPuxMjkBYkkHOKpYoXxUXJUehPY
	H4oL5pWNoHiqp80jzB6oFbYlr1WTqSPmFTGwdElQ45K87bVWAPiA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4avr5e002h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 06 Dec 2025 16:42:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B6CiBTH039895;
	Sat, 6 Dec 2025 16:42:45 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012002.outbound.protection.outlook.com [52.101.48.2])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4avaxg50b0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 06 Dec 2025 16:42:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nSS1O/4E7FOtSXwgUtzj/pyRSwGWV6epE0RAVzKyL0DO0YX8fk1v7eDCSvyHtpitT2Ly7CmOgo2qMuoHKaYv0nvg0JSHE8jhGBVv4EJTGH2VpkqHwBz8plENIM7BSkjGVvwLXgb8ii9w5k2zSHybVXWzbjmBgABUX3N60Ic90RCo9iT8IUYGQPpM8YNKbPDYNZ0mw/Y8crUlvzt3boIshRw5LNjNMYpNW98rlDdkE+BbFuSN8MQyjIBLOjTkyIoJmhZqPySGhL07fhVqdSPNczTvVphhQoLw4OJNTAEFgQy/ej+O6PnDDV2COTDSV1fCJot/W+i7Dd631RtRIgq8Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ftAvfPYWrLMpfwn71IRRWmVXQYbJbGynhCgsmF2ils=;
 b=S+iaMGFUtdVurjETZeGVwEVsJutFwAsiYcXpAcu+IWvYq8hSRArDTyqPwH1o3Cn4NCzPP5fFbtoGVKS3wy0VGaKk0paZ28iBQsUAOxK3tQZUj4LhfkUnSCkIZYUBXpv3ktMUMFpqZqI3/B56BMGnqsVARlS+g+O932HkHliAOIIqGZY7Jsz5SNwcnJN4hNCFyJqkBr9b0Z3jZAiN5OlxY60J7cy3bujbhcOXVtSzoSdiBPLt/xzvFc9DMzvKO0xeDkugsGyR1r+6VyVjzYT9WtLrky3sQV0Oq2fdYiaqG39Z1oVhUUJrf5F3n5izV5UoCPjkaGai1awuZKt+O6Zx1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ftAvfPYWrLMpfwn71IRRWmVXQYbJbGynhCgsmF2ils=;
 b=s/uSM7UK1+mEIgKaeglbln5tEkod09uTi1Mj8DT1Z7LPPu/RWPyYZvma6L784EoopntWa2iHLF62FOa373OUXZpa9r481/GedAI5I9eGeziO8PIQhfaQ1+ViK9KZbFLXiBvtALmAQdyC43t88t1d/Xdjowtc/RVAI4WKpSMQvOI=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH4PR10MB8075.namprd10.prod.outlook.com (2603:10b6:610:236::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.13; Sat, 6 Dec
 2025 16:42:37 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9388.003; Sat, 6 Dec 2025
 16:42:37 +0000
Date: Sat, 6 Dec 2025 16:42:35 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: John Hubbard <jhubbard@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        oliver.sang@intel.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: avoid use of BIT() macro for initialising VMA flags
Message-ID: <90d5f255-fb6e-4af8-832f-c0fbf72f7a25@lucifer.local>
References: <20251205175037.1287366-1-lorenzo.stoakes@oracle.com>
 <b2b2ce39-200c-4dd0-a46a-8d3f184b7d51@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2b2ce39-200c-4dd0-a46a-8d3f184b7d51@nvidia.com>
X-ClientProxiedBy: LO4P123CA0048.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:152::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH4PR10MB8075:EE_
X-MS-Office365-Filtering-Correlation-Id: 55b2609f-0554-4ad4-769a-08de34e67704
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HJSOUOKMD3VeTvnL1dNYqFsqVTmZESVSMqL47MpJBCTpuw8IzqFi9Ju1eLOQ?=
 =?us-ascii?Q?ZBY0gE/W6awVXPT1BWeL366Nsmc/h3TVMoOGLfYowotxX3/d3mWlJoxKw+rh?=
 =?us-ascii?Q?zV96DLmFxjE7b0iLbtfZFUy2VllS0saKzA93yq48GY4A/nrQFNjEcvC3jjm0?=
 =?us-ascii?Q?bpjJsdzENelQppATVMgjICowi34iST84RRdTWBLdZt2mdFUp72lRK7cMdvuo?=
 =?us-ascii?Q?rfCFCkwUc1KvrfGOI3fqLpidULYR2ePqwcMFTJR+Ix9qSuJC56Jv9D7w8O9u?=
 =?us-ascii?Q?bkthPENFamPu/o5nsKo2ccQHX+ytmaodcI7LgXsKbB4MXrsbrtSjhwZ7ithD?=
 =?us-ascii?Q?hQC/dONXW5868Ek2PW9WShKXUF7h9HkyFwSAMne8639s5xvWf4u/hnq5ct5u?=
 =?us-ascii?Q?7lfYq5IbujiuYIoicp7dzPNm6gF9X2wjSRPbEtUMxV4NDaa6voLL4I0m9aJu?=
 =?us-ascii?Q?weCVgzs9PDbrCbnEqOYDBtPEJ/QUdda5wMPHg23buvko6Duqw5FMeNSSglyq?=
 =?us-ascii?Q?CDDoD+UMd+GCWd3pJNiLZZDfPROUsulS0HuUla2me2wabS4/qjBjuKw33c8y?=
 =?us-ascii?Q?fPnSrp+hAWdLgObH+e3johD45cuakFk8nIce/CJN8UwRy7nfXXkLzBlIyQHC?=
 =?us-ascii?Q?M9LDtRnRN+yIa+Ud+BkYVjdlbOqTdsZdqaQ8tRIhXALD8Uw4f5D7PNyTKVH4?=
 =?us-ascii?Q?S86AFj1oHiAciscQVUAuTQ4eWlddZAd87T/2FoWEN04lHdc+WH/prmPrFE8n?=
 =?us-ascii?Q?YPMo0jIICBZaWkNiDV/L5LHGjGfpypZ/4L226nl9ChIWp15h1HLMwhAQTJTz?=
 =?us-ascii?Q?EKIVWOLPiqRsYteNIsYWiDRCJ3qtvdNjeO4UfZsSB9dx+lVYZrG8fI8RsG1G?=
 =?us-ascii?Q?dKudUYPf2unnzOiW6BGkaVnnD9fTzaA/MdR9ySfZCppsMajZeQKHK0qaM8up?=
 =?us-ascii?Q?ltPZAcJSjS6pRkdXA03v+EXdSltH9uO+jE7zwnOkeL1EymxjaYe4m2coEbxN?=
 =?us-ascii?Q?IoOOX0Tl/ax19OiR3Ii04H8tceGpms/8dfacfcdVbMzFMZrDFOMMwmN0y42m?=
 =?us-ascii?Q?L7dxGnPd9jEnXjBHFCu+5bi9w1pswryv35faypq4gH13DSpvhJkMOGL3Gsn6?=
 =?us-ascii?Q?8fRsImEwbSVdI1jGufmn0AEFPEIhrp3xV48LMtXs6XoZRy4iKZd3e8qm5vM7?=
 =?us-ascii?Q?c8c/mihYdOkt7bQF81q7Wpv9r7idRlHP0b3uDh0tptgBq0lDE/wLFOmGAGm5?=
 =?us-ascii?Q?GxBzAEAk+Lb5rMA9NhWHam/Wr8ksp1NaK9i6/n3oYgAWiutDUn3c0ZPSFnBM?=
 =?us-ascii?Q?HZAUI5i0UbwPc1byvgSv7BVNNWnmSy0ZJWsQEZpZgY/3eU89YzISeHncECRY?=
 =?us-ascii?Q?VkkOfaN+RwbKkJVbK6Mi94mNkIkLpEn5PXXsP7F2bEEIoS16+Jrv7KouQJ/I?=
 =?us-ascii?Q?61DLVjo1YFWUBvaJOlxwhsfEVVBLxqvaDazsgE9Dyj69FakgmRd1lg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hbcJ70A4fpLSEKm0Zlljaqcg0w0X44tpWEpsUYg+SdU2F0vveeMnV+th+aHd?=
 =?us-ascii?Q?8hZxg0n5FSIzKAFEwzmBX68PW9ZpZoFuReuUsla8/n+QXrkryCi5aTto7PZg?=
 =?us-ascii?Q?lzmQhurgUmw5MrLRLedliRnyZ3GyhxrEClIYCtliRAkxd30uA65NjYKdrN4s?=
 =?us-ascii?Q?571uddzoLJLlA3xv/tHt82M2Vn3Y8Uwsk7tD1i00lkrkfXEA5eaMi7XzRU+O?=
 =?us-ascii?Q?vCe0oob+krjK6m/vAEUhAQqsn9tz4/mjCTGJAsA1p9VZZblL/PTGBEDUKqS8?=
 =?us-ascii?Q?Lze7aJtqTKp4aphiMp93lVk40DqqsAUHscl2G5cdtxCntl2R8id8IWevAYZD?=
 =?us-ascii?Q?1vpzgrbBKJjSrLa93WlzZ1ROub1f1+wLlDsaXA7kFDlxRMIXi0SR36+tluRC?=
 =?us-ascii?Q?b0use4pGZL6a/HAe5d0ty7ccevuXubCArB2ovMUCLRiPpMGKJprQ5zChZNok?=
 =?us-ascii?Q?hGWCHU3GM0gDxYH9vmScrjryuYrIAZor2cu9NMUIEVNigxGABU9nSCnt6GHB?=
 =?us-ascii?Q?wltkNF0bn1S9NLAlDSJxJPLQQ0i0hvNwtxrYblJkvSY4xypUlqWXH3mRnR4C?=
 =?us-ascii?Q?9mfr+t7H5kkivQPnMjw1RvB0ZKO3wy5Vaw6fPuYgSoVghQtEeveMrrL5v8MD?=
 =?us-ascii?Q?rUXbQaPk8MASGf1fAVoWeJU9ek72EKymYxEsvAEhQZIRCMI7YPgc95JtLlKf?=
 =?us-ascii?Q?1MqH9DVDGwK7YzoJeKHwpKAc7b0wVr+Fz5aoLM+xkzknJaohUoNfaqsMG3E3?=
 =?us-ascii?Q?sG0r63xPOiR9of9jZx1qZkk5uGDHRnGKAol2Fas0aMjHLfCac19ptstroUIw?=
 =?us-ascii?Q?UUUByVidzhv0CCeQfr/T0IxJwSPiyXUMrfwUC8izji91pw+F1woS9rMUqlhl?=
 =?us-ascii?Q?I5ZIQ5omhR4umwRGgdZ7WOCXyQsKgSw1+JAD4Fg3cc3FcyuIu9NFG3jbSzyc?=
 =?us-ascii?Q?tWss3o7AaosBSscmnnoBP06epT0huDGEo/73jWe0tl4TCI7DGJ1+K0dwVKpk?=
 =?us-ascii?Q?KXVpp14Cei/n9lSI+q+1QO8T2887zVxLm/oqe5GbjB4AdB8NF9HRwHw/Snfx?=
 =?us-ascii?Q?MTmqIkgYyMjAYUUNWoegJN7sieYfoxWBuKvOYAY0/Cv2MWpZJbC+Ezy9lseb?=
 =?us-ascii?Q?UrNx1Vstb9eDht9rNgeZbLolPrzUO3cOYYSSpmoE6+dw0eX9nGHWB5S4TQB6?=
 =?us-ascii?Q?ycwm9lFuq4mnBhJV0bnbCE5hlIRqGhB/6ANW0oasJuhHzagX7B4EYlseEXAg?=
 =?us-ascii?Q?WTs9L8HDK/q0HRVBm37JiseBamlVx2AGwPwW9dSF0+ZqbknQvNuEFzKm1uA5?=
 =?us-ascii?Q?kUZh6HzKUlrIGtqnSxUbvQO7KWB0T/JsPCiN1Asnmg1nvNVksn412kjBKyI8?=
 =?us-ascii?Q?dJDKBGn5EEfLfitB3Gjon1bevRvzep/9yUWo9hpfMvPiXJ5UIZZqI3bk5+YL?=
 =?us-ascii?Q?4gyzK87GFqt2pt0S+Y8/bMcl6GppjN5H/Po2ujTq8P7a3I4cvDwbTE6bKaEM?=
 =?us-ascii?Q?9KlheezZGU4QYVcUas8kEPq7WIy9PJQJhZpYuwH0Qyferk1yAWO0Tfjykxrl?=
 =?us-ascii?Q?p3CqzmkonptX/XGv/3fbmrhhhjrF0pCR1syidsGyXlUMF+uO95vBEJHWuTWY?=
 =?us-ascii?Q?ZLuZ18QSZW6MRJ6dOw8E2Hs+xKs2LR/oWh2EtGZT03NtW0Q+ogQubr9Ak2Q/?=
 =?us-ascii?Q?4H3MJg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	M/tDjvbK4Ia8XYgKqsHoYihh+EGvPcAFTotMHezMRnaiEC54Sl9ljSTtRyH3+tJgZYu8oThUZeq/UKA7h+0LzFK/t67kx2iYcx4iwXeDDYY7OffzgeqAtUGC8vNvjqaYHkhdyi61jpf6kiWkiSEWHKP8YzEH6qGnP3+2r8f59QkXHCx7NHjsfHYb7UVI8KavNpe8OHY6Kb5LgVClncT6mrkW0T1Sv9zn/YvFJTZLnV3Rfd/z6InnmXTmDm1e90jWHyUzU/RrKmGE7UWVZcXlnLc8gTZHDWjsYuvJjajMFGLGtk+ukGG48YIsCvlFDO7BTd4WBv/N6zX9A+jGivgoYg1gLbUn2srrPRglcNnYmXoKcHTtSofZmuENZwIQg9UslhGd6ZSIBkJrtHzot0QblqHgl7MYBJbayGql10nNPWyXaJ3hTajwdtewjF0gP+3R4x8XP8sNPudRfYXGXhS5KlvCrVQqZIndRNN7qkwcGzyQwo33SZcb/qdKpejd4PsnxTb9X+/KqvzhVEtbINgo8txTz3NJXZpSegLH81UUwbyREaE/allsNGxwMW0q/B9Evn3TYlwov5malKLkEj5t5XKSDWscq1H6bUghJeTPe9Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55b2609f-0554-4ad4-769a-08de34e67704
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2025 16:42:37.7740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +VYWfKoTh37XvDME3x1YwfuR9OSKuM5U9inXw2jfk6M2x+IibJsV3JQJlDIrJcXfKK1mNtYfW/gCzfMRzMLwoY+tbaFGxIw9Sg4FiPmpA2k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8075
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-06_02,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 phishscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512060136
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA2MDEzNiBTYWx0ZWRfX6c4cRS8AQ3ep
 GiEFYf5DDT7K9TD37vhYw3G0V/GtpJcaC8Gt3fp0yHSAqweFSC6yXgf5pdIlwG5zsmWkIWFlK6Q
 je36eOZmOQiHVcySWlSEt4aGSSY+X+2iRB+RLL8tYzgBSlX+O6tw2rrB44QoqF/1JxE8pxs8ivd
 cEkJztQPY1aEdClHroWkSFeaqkiCCE5O1H9jrgaTC7VXB5ZaoQUa0Ko3CqszjHn+056eLvj1EAk
 LOactePNzy/BTjfD4S5DavdyTalHGDa/1+MqesCLJkQCEKx7DbXPoDiwjaDVhvE6XHo8NA8Op9X
 VzKTXVLKhMv22Nmldvd6NvD300ipvEpc27yYzmm22pq9h3VXq+xfxz8vTUmmO4l1Du9+OF3xUIC
 mkP8J+by5fVPnA8x36dYR18FyZ1+DYj3gWEJftuEGm1zrN0mjyA=
X-Proofpoint-ORIG-GUID: rs7sA84ruAybZHMJuNSWI0ZqZQjaGxkF
X-Proofpoint-GUID: rs7sA84ruAybZHMJuNSWI0ZqZQjaGxkF
X-Authority-Analysis: v=2.4 cv=MfVhep/f c=1 sm=1 tr=0 ts=69345d07 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=yPCof4ZbAAAA:8 a=ZjCSb0mWAa6jfW16Vi8A:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12099
X-Rspamd-Queue-Id: 4F5BA10000A
X-Stat-Signature: ejjqjwpd3wzepmonr5i783w7wxcxb5g5
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1765039372-697332
X-HE-Meta: U2FsdGVkX1/4wz1MEDgf43+tEOfXvMDuexcxnlICMdTsHez5fei9shTfX3woinEvCU/MC6yTLsMhOmN3zWhCZrZAkyEDjQBATA+qGkMYCuAPZRQE1LXxTuNXiL81RZtWUFVvQR+lclR+VfEAAleZFGXsLEHnpyM4VU2vGXf1PigiPlG8DkYOQOkS/p4+26PkxoDyW1hR0QEfWwa7TfJhWFemeD2RQZK38ENOhwOGRIZLgcVUQYgRCbF/N9mKjxVtBhBakowSk/fBDYVz2lBtLPBOXDshRDBjJi6lLpLbSoj+VUGjToXwS7v7ZYxQaKul+keY3grOjJnmZu1/pKyyrq2rmOCVjAPnvUpjtFquYFOp65dSnjBCuJnSJPfTsReT5JchPLArSFFr48dr2xfz/U35oh1FIGFXZGWRNfErlyzepBoThJD83FNPCYUjWZn2MU992y5Xv4dyKB2RiY2oEXT3ssolpB0Zl2HfYs0NkIa4N56M16eCLyxMT2uNg+bEvZlmq9iZPrdiLOfk6SEJXWeEd+kTdZCDaIvygipoizLnytZmGnodESE9UbQk77qiGpQNJuRNkHrDDFOY0myoSVYUBGGlwTYKGjZlLsxqZIpxXh9XgRtHu5s4Dv14bLI/ZNROdwST47YwYWaR5A0nSfHqTjZt/dH/yWw8dOi+uN8+sIVu0wCyfIZ8/xtdmOQ+JYk/rTMOOGZVPRXeVpD3YA6qWZ2wa0eMFPIMRRJl8T7du7Dsw2Bs6pP15pC5QiuNPgNmjsyweZTh8prmxvG90RGE1TqXxfxUdJAeAX2tvBu0I/Jh1/RGYCyKUBhp/xNzJ/6KGVTzAby5FDsQHSDQ1WwnlDMqTVvFL0LleECpg2D8a87TrCjmvBKee1F0Fkf9JAvCYb32mjFw+kPWkMDlkTtY5LUnjMzfM1NB5sFOWj4qtPLH6JY7zqa44o0gNqE0ZwFETGMUUAeiDDMvrfY
 xQWyr8Pb
 OvLW4MfaIHrMN9Rlfb076NBHlCgdNpi8ELGspWIv+V4wnd7HH/8580lfAQy3sGvd8WqvmzF4hralHilK3EbGur3DtgjZLweyiqCU643C6cHts/fG52cKqIAh/FUsVcCF7Ec/O6VpD4n3KX6Fuviem+CEueBVLSu6CjnObD2Alp0uxgp5SOe5AlCN02A6SlTWucJckz6jWNgAgqCRRA9oJcycI097TE8JUNfE1r1kravrdfzy6G3qN2nlITNkUh8sFLGlXBF/XFLxZgpQxWe5qL3biLWD4hNQ7nud6u5ZoeSX6GWH06QpEX20yKaRdGVEIZoswz9gOKGbIchx9lwBCIQNPcud6Oh3qkXLO9vLl4PId5DawlpOWvKFLYxaph+DlpyyarrM+GI4KlIDBbsmWi9GFK1bAx652VqQhcIFFkmr0xwZN7rlyyudVbQSgfyZ38vEFxo98XpWfUSjx8yOHRPcfxnZpg/i/Zik7tkAJWBXK92LVEsEEPazcetKjCMbaIws/rtWhVd9X0/OkwV2UYmieIV/olqgxotzrVP1xGIXa4yeqRoHvXQekbHhVjA9YbiRRoP3wQ1E84Rq3x+lhbKWdO4CzvTs/7nOs4AashMaBaMDMmJq0HZ/4nl7xp3faYK7uGWpbAItvX8M+VdurLOBBPg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 05, 2025 at 11:56:32AM -0800, John Hubbard wrote:
> On 12/5/25 9:50 AM, Lorenzo Stoakes wrote:
> > Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") significantly changed
> > how VMA flags are declared, utilising an enum of VMA bit values and
> > ifdef-fery VM_xxx flag declarations via macro.
> >
> > As part of this change, it uses INIT_VM_FLAG() to define VM_xxx flags from
> > the newly introduced VMA bit numbers.
> >
> > However, use of this macro results in apparently unfortunate macro
> > expansion and resulted in a performance degradation.This appears to be due
> > to the (__force int), which is required for the sparse typechecking to
> > work.
> >
> > Avoid macro expansion issues by simply using 1UL << bitnum.
> >
> > Reported-by: kernel test robot <oliver.sang@intel.com>
> > Closes: https://lore.kernel.org/oe-lkp/202512041634.150c7e4f-lkp@intel.com
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > ---
> >
> > Andrew - note I've referenced the linux-next commit number above, could you
> > replace with the upstream commit hash once your PR is taken? Thanks!
> >
> >   include/linux/mm.h | 3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index a2f38fb68840..c4438b30c140 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -395,7 +395,8 @@ enum {
> >   #undef DECLARE_VMA_BIT
> >   #undef DECLARE_VMA_BIT_ALIAS
> >
> > -#define INIT_VM_FLAG(name) BIT((__force int) VMA_ ## name ## _BIT)
> > +#define INIT_VM_FLAG(name) (1UL << (__force int)(VMA_ ## name ## _BIT))
>
> OK, so now maybe we don't need all of the rust/bindings/bindings_helper.h
> changes? Those were because Rust's bindgen doesn't properly handle
> nested macros, as I recall.

Ah seems you're right, I just tried a clang/rust build with those dropped and it
worked fine.

Have added to TODO to send a patch to remove those after this one lands, thanks!

Cheers, Lorenzo

>
> > +
> >   #define VM_READ		INIT_VM_FLAG(READ)
> >   #define VM_WRITE	INIT_VM_FLAG(WRITE)
> >   #define VM_EXEC		INIT_VM_FLAG(EXEC)
> > --
> > 2.52.0
> >
>
> thanks,
> --
> John Hubbard
>

