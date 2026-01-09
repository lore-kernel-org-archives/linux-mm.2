Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C006BD26D6F
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 17:20:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 307206B0005; Fri,  9 Jan 2026 12:20:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B5006B0096; Fri,  9 Jan 2026 12:20:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18CC76B0098; Fri,  9 Jan 2026 12:20:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 09FE36B0005
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 12:20:54 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D71DD1ACBB7
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 17:20:53 +0000 (UTC)
X-FDA: 84313090386.07.B55D78B
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010056.outbound.protection.outlook.com [52.101.85.56])
	by imf29.hostedemail.com (Postfix) with ESMTP id B6497120005
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 17:20:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=H1rYVR1H;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767979251; a=rsa-sha256;
	cv=pass;
	b=GDy4wj/LHAeLPCO60AuDclZjdtdAaYn/OZ/49hKXMyPo7HfAZUMu5LjLZ/BqtghV4R5Dor
	o64UjaS12mNYRJvKFJvlkdFJ+/hE1MxUsvPofTNqJuW4fM93EW9hpWp51fmPiWNOyvK1Vj
	tDwGI9obQuPoJ7t4EvjZ+QAzFDWrqG8=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=H1rYVR1H;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767979251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MTJshbH6BdsEHJXyNlvIzuXbKudsGTXVmqC1/FoMU+o=;
	b=Qw4oTZoLu+p/X6OdopL8a2j3Zklrm0Zyc9HEoCerrFYe04M3NLX9K//95YxJAe0DDtomZd
	jWCsDOLIqRaFDik6BqLB+aLKIa9jeXq2sLJxPCnDbJheYx/lgCylrrGyyD4Qm7SUo6M1ou
	MkgxWM2OHnwVd00EKbn69vHV22RSNW4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a4911QBMurpGS5zPM7rl/RMTnOuNKCzfST8SpJbnF5UprvdZ459Yb4/aaP/eXt/UT2b9ASW0rvWbEG5UicyAr2tG821yeYhKx/5JBhdM5Lm3XyWfNEplALBQQ0QupvW8C2idCCRq2MsAVaUP9M82qMbuumXuAbgGyKRtj1nyxvGTYfiY0RjuSp8x5mXVgAWPdtJwJIlZALquDykPPYiEROZUCG9dhaRFhagI2LcwyRDrv+uYffi4MTtNutsFdi+/e6eCnrSdp9mO1kZGkpVa4/NtCD8ftgDGA88NpMbx2Kd0iz70t8I4sUwzyXlDIj8gk09HWUVGqLKmpBBVS1+JUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MTJshbH6BdsEHJXyNlvIzuXbKudsGTXVmqC1/FoMU+o=;
 b=Tu41EpuJcLJjSDhVKBxcZa2l5MyYUEC6E7okHmblNugn3ZEbW8l22hcA5nKe8uthkPDLF4bKJKbHzGu19k3e/CQHf9hvxY2tS8A3LN+DOwhXs+5qlJb8/2yqgUwsmyxVi9rgIMOi82+DK/clWCNTMYs2RDQVYz2gpWQnrgZ6z111omcC/ka1g52gxrFLbwvLWlzOyQ0DcO8N05SKlndqfhcTw0haoiyT88W0jXhmaI72nSQwM42he7wyg5uiKivSft2SnTlA2Pv6LJHjyy4xSFbmf5duS/A0gPkaMAJ2VbIHoybxbntx1sh+iFvzmo+ILe7BvgsF2a3eQZruD3UlMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MTJshbH6BdsEHJXyNlvIzuXbKudsGTXVmqC1/FoMU+o=;
 b=H1rYVR1HmyTl9pO0aY0EGVxtiRRx7DolE/W/Rjp5sDZOJzv1m6xnIWHLQsgycv93nu/iZWFTi60G0oPOA/kfMQIXnrlPUj02VXVJal6OSAdQCQK3Y6v7XZ84qguM2FqVaEGq4y5vXML5VKUwNAeVbCodQSKuW34HESKzryyG23B06osdAoPmH/Z3BZA1CArJ8x3h+fXZAB2PgW+xeIhyp/HPIjl1HsPR9myKqAG/Dk3EC9mTTyd3mFAC+LTAzrGZSIexNsaLO/zDirndR//+PrbYrVmTlExEIFSNArOafzSgB/asNEWmceqH50p9FJY7UZ9u4HIUJfHckXfFKTvi2A==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA0PPF0A63E7557.namprd12.prod.outlook.com (2603:10b6:20f:fc04::bc6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 17:20:45 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9499.002; Fri, 9 Jan 2026
 17:20:45 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Rik van Riel <riel@surriel.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
 Jann Horn <jannh@google.com>, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] migrate: Replace RMP_ flags with TTU_ flags
Date: Fri, 09 Jan 2026 12:20:40 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <B386EF89-C4C4-4056-99A8-A6B75648C152@nvidia.com>
In-Reply-To: <20260109041345.3863089-3-willy@infradead.org>
References: <20260109041345.3863089-1-willy@infradead.org>
 <20260109041345.3863089-3-willy@infradead.org>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0135.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::20) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA0PPF0A63E7557:EE_
X-MS-Office365-Filtering-Correlation-Id: df67bd7a-e2ed-4dea-5755-08de4fa36c5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PUCynY4vOnOQ7BsljOCq+IqC1Xur/6gXjfRYhVej3MksEVJLtSL2rsB+XL2p?=
 =?us-ascii?Q?NO+/fZuSK3zuFhYD7lesep1EM80r+8Mu6eCEDqQukDoQbU1oGrTf3Z8GNk3U?=
 =?us-ascii?Q?wk/rGOVACOWM4rg/5PDb91HaxdS5eKda5GLU8lnI2uWPrt/RWYpN8llElOBu?=
 =?us-ascii?Q?7CbpAXV0gDF8FLIVSxcQSjLfcU3amCe72h4mQseGchOQDQqEg1/nQ4jUKFqi?=
 =?us-ascii?Q?eUCEJoiZVqt2kupYxGXYHUOjZu0MsS0aGFmoQlVO+cUCtWibjeZly8T5TkFU?=
 =?us-ascii?Q?PRDTkRhriFvjs6KIhBneFPq1lbFb6tmj0+K39B4Cm4dAWsDv5QgT2q/mfXax?=
 =?us-ascii?Q?j0RKb/Vc1iMHG+do4CloyV55s/TVxeNMpqeR0DzI6MCka+9sAb+1oFANQ7N5?=
 =?us-ascii?Q?XpIoCo9dZNAIlHsIJepNdXEI4oSZa34l1L8MlfRszRvokKMe1yxNTA2ANVtp?=
 =?us-ascii?Q?tMcrg/0GndVFGnIuUJXTxAuJagkYXzLBCazy6MDyYcCBAmBnSrZtJHrbYVTR?=
 =?us-ascii?Q?E+K20XnfRI16iNE67697jjeedpJ9pbyUmoQXKFiZqcCq7Hpv1GD563BO3kIC?=
 =?us-ascii?Q?4bNSkbwEazxf8BStEDKewUXssAk6vQbIlLEx0+hI632uWlJxXgDQ3DrBZGXt?=
 =?us-ascii?Q?Eg9GtuAswWBd6803KM3jMNuQcrv0WzT0n7zRsiu2K3FyHZ6hAvmMvNZo1VPl?=
 =?us-ascii?Q?zcMU0uBzyRFNKSjjJlsazwG+XEgl7f5Km/7WSBZPJ48TtafHvyiXqOki2Xiq?=
 =?us-ascii?Q?EKdBm0ZgUwa056ecmeC0ss9egbabjIDgyK+nC6i6d92ly7r4Bq4W1kOrOfkB?=
 =?us-ascii?Q?TQOnxzknd25ocSs97bgMRsHS3fpSdNITPhbbX4SFYWK5mLvMXY3ZMMhNskS8?=
 =?us-ascii?Q?kcDpkTdcFiY+P6UCbrDvu2zaGZ6KDDtOhZRO1sRN0eQIS1B9vnvkhRYnB4u6?=
 =?us-ascii?Q?NQ9oTPQt4GuFmdqt7LRnTxvPo9sV+oMKUD25ASD2A+GT30zv54fUL3zcALAv?=
 =?us-ascii?Q?K38YWN3pSKvem/8w//IhkhM/VIqOIhcES1l8FmFxzsz0q8qWYPdoqC/Eiyox?=
 =?us-ascii?Q?jEQH1KXLWwpzpF+XrLDIY7CpCcguOn5mQ6h+85zbvxiGksXKPi8y9f+XJkFv?=
 =?us-ascii?Q?iXv3AGPQ75ExLb86GYeuZ7F6uGPTygJ0ujfzlHcbNiNPvwtFfwlKwJpKXcHn?=
 =?us-ascii?Q?xcBAE+51uAVEnwZSKrw/cZ8u+o9qpRv0mPXzc0IUyJYwKilUCPb6wrerYkOA?=
 =?us-ascii?Q?66qScJW0uic5QQbbbxDtgDYnc66e2go2O3AfiNteceQRaS1GySmdqF/zRgRE?=
 =?us-ascii?Q?n0QzVxJ7q87kBNsdgt2BdMqG4s3JxOj+tIni/A9+LQCXiLjCdhVZb7sIaFcr?=
 =?us-ascii?Q?6RL8kNffT/kFtyoOJTVD39GPoP55oAsY+eYKORXgY/dvq7ifSB2xQGfeJa7O?=
 =?us-ascii?Q?FGZLRqw7IV6tlwg8HGRYT8NLsWO2bpan?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YkOBdoQO0uRbf3QTbDFfChFTVvmG7loFy/CHDzrq9zAlPz3kL6d5+SGdU0/S?=
 =?us-ascii?Q?5z91ftC9fNUTMYh7erz97gAlJHjJTyKPIKCDd2WGx/kykrWxOd41duflqVp4?=
 =?us-ascii?Q?KPzJC4X3FYM5YPPY13RjqECP+t2rSVDzxCM9HraHKH9lJ3rNxLsx4kbu+D8Q?=
 =?us-ascii?Q?ARCz5oqg5hw2D7mQ49tcfIQRGf2DflyUefTKdRKIUSk7irKtph7bc6O4R0tm?=
 =?us-ascii?Q?IA7S7wrZBKJbZCPsQKWQbaQfe25JQOkQp9YlVfdzun97v4DqRB2uB8hmPlgj?=
 =?us-ascii?Q?91QD/RpybtLsSZ1kNrklBim9KH+XhwJs4W2y7IiQblwUKatOKm9OzcrilmoS?=
 =?us-ascii?Q?hYK81WFA746oKe3mUckX2+xyNMLRalTlsMWJgllzKtjA0ITPTX6WI3p3DEIA?=
 =?us-ascii?Q?brVEhM+yJOroxNom4vdt9b9nTQWBF49jXdEh9zhu6jRB23kP2a81rKEjBN08?=
 =?us-ascii?Q?fhGQG2hpFURAxS//pMhIawcZSNJxS4eApyOaZxKWSOPRrndjIx7u4ylvWJr4?=
 =?us-ascii?Q?iht8E3cSBzPFpTi/cWkU+04zpKu6FAyvfBCw6LCecb6j/dZg2tbcOCpFrKqT?=
 =?us-ascii?Q?wOEBZkRisv2qL0ukYm3O3haSN7JaShN+ASfFeLN/E4kitMo5tJNIRFsnDivJ?=
 =?us-ascii?Q?ihX2KIOqgYT/yly3x690i5hV2FOjGgrC+6BMezbQE//7Kr7zMkioA2NsGy4M?=
 =?us-ascii?Q?JDBveTVEhAhj9Ez+y8gEt/G24uVbvV4TrLG9qZVNWnnm8smhf9uJ4ulX5Ssw?=
 =?us-ascii?Q?3NcrZoHHxGTnFMUzDRd1oXFvD8RYP2ir0T23dLjVw/S2ESwIrjWWcZ2AJesD?=
 =?us-ascii?Q?hlfaATAKaccdG9awkUb0CwDJKje6peflPlxuss5KNBfqzz2/hPpYCFhF0BHo?=
 =?us-ascii?Q?7nVU3sk8va12ZiHIajrrN8pgX79rk6bufmjrYk40WJasOGo1BAzN0rEnBJex?=
 =?us-ascii?Q?33BVLPfB2HPWoH/c17cAbuJzgZ5relEqv6lzWtqTsVtnnTNr0kxo0DZghfg8?=
 =?us-ascii?Q?zgRH2KeJnBe0Zrl8tIL8hqdC72cA/h87nv9AKJ1mKJs51OzKb5PvJAeONjTr?=
 =?us-ascii?Q?aQHyEeg58JMSP5169lD28wP6kQvqY8fEg8hVe0PVaJG7+twc4VAgAYJyu0iM?=
 =?us-ascii?Q?lbseoJ7/+Gdj5n2X5pw8hsYhCVJNJMNsoTpcMspEpN14UNC7fQ0tiBFKdKEC?=
 =?us-ascii?Q?xxDT9OuM9MH8fCEraNO0NqbMsTw8kt6x9QE8Fp3a6pgAHizqRe5SgAEOPP6m?=
 =?us-ascii?Q?/8lW71sUDq1+mwevjOr9sTOqT7lSop8Y33HrXPbpaNZ5B1gPi0aeINribo28?=
 =?us-ascii?Q?EyBlSDch5PVkiG7eeZ5/guSn4VcUVpCGsCNfeXLNfSMTQijvCpXGPXlNiINk?=
 =?us-ascii?Q?ngpHSaK3gRixrkEeGrU4XuLcbpf8VoJq+1b4ccxNkjxqPdvhxjflaeEMllFQ?=
 =?us-ascii?Q?hpdL0oEqSvEH/gYMJcVLNGTQwzePLVCZypIKdkLoxTY0Dm77lEUizR9eiY4o?=
 =?us-ascii?Q?tpxT70AhN1byVJ4TC6BIHV2nJKvTzaof93Iea8YLHBA6KJdlYy+Ax9QSBBhy?=
 =?us-ascii?Q?SovmV+7Asl+hpuWeo3SjY0CyGAzicij358YJ0Y0+quk+4GDqVo1H+DTqgLXW?=
 =?us-ascii?Q?Pst119LqFAf13uV6F5Q3YMYYt7cQDFPOjZ4JQziH03jYU7qfmSWw+yK4TPJo?=
 =?us-ascii?Q?xkytlo/HUoRtxqHWX54bQCXd8TIPRG5mqmnK63nR7rPB5n6Kp+idhejmAkpM?=
 =?us-ascii?Q?kSWuP3BQCQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df67bd7a-e2ed-4dea-5755-08de4fa36c5e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:20:45.0920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KW/BaZdPLwkwWJGVjd8QehLS8MPqpExh2YmoVIt/k2g1Vq7LqjiBlhFb1ok7uSEF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF0A63E7557
X-Rspam-User: 
X-Stat-Signature: u9xibo56ke3g8iougo6gq3zzmym55pjd
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B6497120005
X-HE-Tag: 1767979250-714907
X-HE-Meta: U2FsdGVkX1/cAYJaWIbqHaZDJJV4nPcUb+4ia1FAT9AeMHbdURbK9PsgoP983RZuxM7dxQqRKUs4ooVNjtGftqVSPVwrRxZDH5oDvJKF/CC5fQTr8efJTlQunYR2ihrz2eVzZvefTIbfznwKxxIKbmL5h0zTuyt9Y4wXrb/baMvR1jM/lz2TxT8TLXI1mqhuzvuG1VDRH7id7fhZdk/i67QautoyetE1n603t0FhnUhB7KvsxWy+9Y+0XVJ/XynqCnEiZi5uMH8OX4JFFzuPySZ/d8VeHCAZx1gAf+Cw5LEdQKisMRWU3Ts8zM2c5vP3m1EdTHNuBD4CyR6ytBNPho8WJKmvoXm/3B4jxmWVK903RJx06QqIJG3BuvFL0npks/EeTJu94XyY4/w2tD+LB+HA/NX+kmtDn0FxyHPAdFPoDfV52y3RaOgoaScE1oZIPPvLp5X+wGAz+YHGAqDEKUFB/Z9luB3OfN4dY01XORbaFqm0811Sdvi6V2ctN0FzFfTWvcv4gndrmBAgxIInQYVxHlUpF7oB6G/RjDhSWAs7psU66S8EXDQlcAyoCnh2d2VgSKL02d8aHG04pdXswt41TktsqsqXS0ttlhDELq3Cs+i1jvu7PwaU/+g5+VS16zW+6eL/J6YtsU11SAmXI7ZG40LlCCZjlmoRY7fCTfxeflqC65tsRaXymnSXTDeIQ3clJ541HPXsmyr6JUVFH4I+ZWJ0JTXWT7u5+eXVeEiBpJSCIWdhSEHKtGF4WXS/WvVuI/9PiGoiLWmeYfSwQHMXxUIXbZqTiAMC2P6nOUzd2+zJ6IFZCayfLMpyp5YXCDJOi2RPnBkYsl+nh+PABvyfff4eemrXCtaego+gW9Mjp9e5msNiM0iJtaEdJsEQo7UlYfWNlQp11er/RzfqSWeMEzJpJzCxKte2YtvMF9QTuyForbr1b9SMNtn4EgvWJ5LTYZ4tlMWbEyRMUzj
 FuHM3tim
 l17wj5fyS/8ax8wmC2BXbq9XyFTBPY92m4eDRmIdvvuIuKpgwYfExEmFpgfdJO/DAP7nbu4+uf5Ie3LbVu/AqdYV/2TiCm7yzb0tTtdBQSK+XrqatsjgLqLQ4lKHKeWDzyN4QRybetEntZqTD+FoGp/JgDil7mH3mSSU6RaaIyb2rNZ5CKlSNNzaSFuZa1sMOSrG+L0qf0CkcqdggWu7JakpmrcKtB46w8xOP+OoQMdCmoPQpoxaXVPo8gSRrf3ar1gnM6aBKe44WCqou7vEC2WkyVlxSISXZP2CJ7GKEjYpRhCz6SUhKg2rvVyrsbYO5Sb0daz5XTjSQyk8nLwSDzJNCVi2Q6VjLGGCtMjHwYSaxQVAoF19fpf+aDnKtKq9/VpYQ9uqRzNJf+x6r0EI9A1F1cu6cdIeaa54b4BzMiCF3pqxyd7z3MUthg405eRTo6yMxdRyQqpnz4lw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8 Jan 2026, at 23:13, Matthew Wilcox (Oracle) wrote:

> Instead of translating between RMP_ and TTU_ flags, remove the RMP_
> flags and just use the TTU_ flag space; there's plenty available.
>
> Possibly we should rename these to RMAP_ flags, and maybe even pass them
> in through rmap_walk_arg, but that can be done later.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/linux/rmap.h |  9 +++------
>  mm/huge_memory.c     |  8 ++++----
>  mm/migrate.c         | 12 ++++++------
>  3 files changed, 13 insertions(+), 16 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

