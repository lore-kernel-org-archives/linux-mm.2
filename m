Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BCD1CCA471
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 13:21:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4DD88E000F; Mon,  6 Oct 2025 09:21:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD72E8E0002; Mon,  6 Oct 2025 09:21:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A78328E000F; Mon,  6 Oct 2025 09:21:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 90C2E8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 09:21:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 26B6411A734
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 13:21:57 +0000 (UTC)
X-FDA: 83967752274.11.21973A1
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013068.outbound.protection.outlook.com [40.93.201.68])
	by imf13.hostedemail.com (Postfix) with ESMTP id 577E120009
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 13:21:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="H4wDAwL/";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf13.hostedemail.com: domain of jgg@nvidia.com designates 40.93.201.68 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759756914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LeqMHn98dB7lO34BtE2AXD0vSNV/fvj+VFLaAFSAZKc=;
	b=oznTNewwFvqMmKGRp3g2utPgXn+BPYpHkqMsxn+x83ew7SfAInq3zcqxDOsgVEmIVFAWst
	3k43Cv3uoUGqdRFUGUOoMXZeHlNLhO7EGBvxd9gDab7z/qHoLBx8xQ+WCrXrLTpB2/LnhM
	ENcMpaNxdazfG4bRrlVvHgs3ZPgSb0Y=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759756914; a=rsa-sha256;
	cv=pass;
	b=EkOoYtkk3dk4ppPnWINf9kKldlVot4dI88fWf/wr/KXHpgLn3JnfMN3M46wrPXYYCSKsKJ
	lnjDT2VUxYWoO7x8ABeTda8UE7E2n/Wfp743HRaUjvrjzVChI4G02g5g8iSTfztQi05jt1
	4OJYfRJ3dLxAe1JKnxpbkqeuulUEzpc=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="H4wDAwL/";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf13.hostedemail.com: domain of jgg@nvidia.com designates 40.93.201.68 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VVR47cK0mUrNlAvVp5B90NoAEEMnQVnvAEpZYSgmCOpqfiozMDmnkrI7SnOhVxS1ODwOHhuxrISBv/Yxce3nl6JEsDNwiJidLK1iaFosEjRtx8VM7hGmv1iOV1FAPsF90giNym8Bxg2k5Kpz01CQGiRHJFluScJWx1zH1LEpo4S5Q6Ub+jM3XRnfRAWzaufxquLxInO5QPDvSMdwPe+K3kUjPYsAbl/j1dRdRsiU/je52WOi1ckE/MHLIYeLRUqb9oCwj0TnwiF/NxaNS+fatBfs9rkEgVb8chfN6hAUx9oNPUzZm6MYjHmzMJB6LJ17vcBkjJ90NsehCXTVVMLhRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LeqMHn98dB7lO34BtE2AXD0vSNV/fvj+VFLaAFSAZKc=;
 b=KKW4kFYCT2dgdtlXuZ/NivtN9+/R8Z4/8wTFp5d6gtD2kkfM88VynFxLZIHx8H7IqnHhFQg2O/Eq/hnn+M85zpK4+e+5tGts+zCSQGC0eQU41mCAgM7xWtrAzXaZbpP7rSIuiIRyVSxIXdasPm7FmZ3hLW/yoFFSe4QZ7K7ymQ8awVxxL2SMexrYmOvikYlApZ2xysyIRrTVSA3eknW5r90PJCe5likfvj+F5l9aB79z4ifI+VIg09ASlWQzCID3BfgjCIK1ZHFPwqqffJ3rc7cdVaVhMszBjdaedLSI73Qo8sr52O85K5U7PID6GzH+yVaYmNhegBSiQUHbyxmb7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LeqMHn98dB7lO34BtE2AXD0vSNV/fvj+VFLaAFSAZKc=;
 b=H4wDAwL/saArONOlRtt5tsGMkt07XKge1VUbUBdcePYnlOpMBX1YDd6U74wyCkw/Rl9Hub4nfKL9w3McXerV6B7LHcuLpq5nQv2D/GIjCad9ihsV74zQBn0aYQfVc8YI3hzihtI3Q3YJJ4MsAzgTIhFnrbF6rfNFcpTl8JNOU6fPbnNLYWenQPd145vErq6Itw8cIpdyj1O0b0PaGsjWjLuLutajMHKHgdjRNdckmsWx2e0vJUNX5Wql1AgPc16kltk/6R7+MA7C3Na9/UeuJeqvYHyGFniPQxI0zAHYvUz5EDdbgXhVRjvdPvClD92XiB6ULMAB/FkcuHNZz48K7g==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by LV3PR12MB9213.namprd12.prod.outlook.com (2603:10b6:408:1a6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Mon, 6 Oct
 2025 13:21:46 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9182.017; Mon, 6 Oct 2025
 13:21:46 +0000
Date: Mon, 6 Oct 2025 10:21:44 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Felix Kuehling <felix.kuehling@amd.com>,
	Alistair Popple <apopple@nvidia.com>
Cc: Philip Yang <yangp@amd.com>, Philip Yang <Philip.Yang@amd.com>,
	amd-gfx@lists.freedesktop.org, Linux MM <linux-mm@kvack.org>,
	Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH] drm/amdkfd: Fix svm_bo and vram page refcount
Message-ID: <20251006132144.GM3360665@nvidia.com>
References: <20250926210331.17401-1-Philip.Yang@amd.com>
 <87ae1017-5990-4d6e-b42c-7a15f5663281@amd.com>
 <f3349a43-446f-f712-ac61-fa867cd74242@amd.com>
 <674f455e-434d-43d2-8f4f-18f577479ac9@amd.com>
 <aa910171-bc96-d8b1-1bee-65f3ef5d1f46@amd.com>
 <17ee1a4d-69cd-4be9-bd6a-2924e8731db8@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17ee1a4d-69cd-4be9-bd6a-2924e8731db8@amd.com>
X-ClientProxiedBy: MN2PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:208:23a::16) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|LV3PR12MB9213:EE_
X-MS-Office365-Filtering-Correlation-Id: eda57ca4-7a81-4251-338b-08de04db4c3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ALq8cJavaAZyVgzQkBWplHtgpXcP/+kJotlxy8EE24ZQrsz/H6TmpodJB/Yf?=
 =?us-ascii?Q?Z65fZB9NkmSDVq7AJdz+RCh6//TcpvcsSHg99AxLKF6dgNzo8s64ASk/Pd+k?=
 =?us-ascii?Q?PtnzAMQNsSFRslvhmJM2al0tdJzW678OqDb4ZgkmLzO+Py+4Q3Ac6rNhAVQr?=
 =?us-ascii?Q?+nxN3XYLTUDaALERT198PA39HYFsNS1nkKMMpXgN5vHV7gFqfqZ3rHi1cuia?=
 =?us-ascii?Q?g8S4WCPgT3bVntTi/bKofvQurCVvTwVCHQCSNS21cmRxh30s6BajAgLeNUNi?=
 =?us-ascii?Q?cGVw8IMRyE52sNchJ6XH2t32b+vtxOWcLt/AXGvrhF05g+KaeLALGztlfVYJ?=
 =?us-ascii?Q?Ryzf/juUxtqoWekB7UiZWL+e85Z4im2beQVrSz7v15mTW6ZEaumi7hSnIxmX?=
 =?us-ascii?Q?sgHYL4Bt4gAz7hZ+j5keIcGd+5qaKmwjQJ6MldR9wcNGMMBh78olqMyYVq1f?=
 =?us-ascii?Q?d9c4gM1XQFMqf7/Kf2rjLio0i32kIabyEy8c70kgIw9IqL1brj/Yb2iVmi6i?=
 =?us-ascii?Q?yIr2RoEoeeCIL6886ZDKUvzEZD/JuWoToH74yPoOu8Ce/q9XOjJdqomk0bEc?=
 =?us-ascii?Q?axBY0tIDKR3tSNfBhDqOF2XKBjvvO6fw0y840N4eekbE3zX3CoUxZuS2fJTh?=
 =?us-ascii?Q?Rryrz/TK4H6Zv5qzIBo0BXm2GSWxKAuRBEfDtcLNQIicrN4lzpHvXEqapj2+?=
 =?us-ascii?Q?AMjqgezqR93wZ2YNvAihiOGsPYdjuQTlpWFThapBUSLjU1KP7a5/wKQ/eVgj?=
 =?us-ascii?Q?XkbTlyHJvbS0RUVK9IZpxfSTTDyqNuin9Im/OCu4Lq+tTJKT+9SzJhc9Vi+p?=
 =?us-ascii?Q?LvjcJtRt5OdjNps42d0vRPl0olqJJGsUiVymwT+XtY+OMWZJ+jmx5vSXxX9t?=
 =?us-ascii?Q?pM1EjpNZ46gP/s4AZpo7OMEA/pWeWPcoEfVkDwOvXEoa/XgD3mQYv6qouW4E?=
 =?us-ascii?Q?VnPgBHt1F9JY7Ns5MhQN+0xBGJr8WeBopzpnk1ivOdluKSMdI6JYvKkDfZBW?=
 =?us-ascii?Q?QFA7tcTxrYnYVAjLtUdkKMtWlVa68eY5edSnmH2m5xIduQckH4OiEM3RNT0i?=
 =?us-ascii?Q?owaQuDtmtNVJuFZluKwrASyf+go/Ng2NDtF7CkniKqswbFrJoiyjiXrNei0k?=
 =?us-ascii?Q?XCEK+FhubgFPfkEU1WC4R0lJW5e5sAj1hV6ajNBqZD63hmif4oJd3esc/A4E?=
 =?us-ascii?Q?KuhBvQirYgWfPIMFbtKFv8m7i/VeqnlN2/UMZmjBmjapeQLixxDj9Styjmu/?=
 =?us-ascii?Q?AJ4e08zP4CFhZyAc9Trz4kPZtOn1dnytmQSnqZ2lWcTJmh+ZOLasLX2omXLD?=
 =?us-ascii?Q?zD+o/Jn4OzhlMuSXyIDFfi2zBTcgs8qGHP+ol3s0d4iQARzIeuO5lMqdMXnA?=
 =?us-ascii?Q?UT9xOo+Nn8BFlUmJBr/dnotbaLF2llnjmkAjrj/Clg2fKB/wsAYEVEVUKTq5?=
 =?us-ascii?Q?7EluorjBcEpB2UDw0eJ8gKiL/OBDAIJz?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MS17vJ1M01vu3tZIjmxqaIhZxlIP0Llll4HnBbFHqUmAKnXdKqOfwnXxyVEG?=
 =?us-ascii?Q?p5bNQcbG3HXcEtHDtQjM4ZsgcprkjQAXiXl+NEz7+aU508rvSXcegUJsWdyk?=
 =?us-ascii?Q?mHRpaVqymKmp+Vkbm/n9Lj/5wBWBr174pDSd9dUSqcGIswsjNbY7Jrwq0xDK?=
 =?us-ascii?Q?2Y/RiT1sJzioeOVCWV09LnZI/r6IwWn51oLqgB/Jid4R8U1bcApyCmMntf1g?=
 =?us-ascii?Q?NQMqqssKY9DYo/UXsMQWhogPvXC74gYFFk3+Sp/bcLgtv2HpqRpN7KfJpkD3?=
 =?us-ascii?Q?5s7WvoDip/3kxypC/vA56EbNqbKqCzwir5Kx0SJEvZb8oENSOxyej1GdOYW6?=
 =?us-ascii?Q?+f53IJ04PwVLtDk0zmC3E8BIRr/+m52DlBW6FK9xdtjKrozi5uO6EGCN28Mc?=
 =?us-ascii?Q?r01Dkfq51EoxLvclWOCRoxsxWErleHV9mToJqnfOs7F9FlSKkd+CxvNqIKkS?=
 =?us-ascii?Q?d+4CXq9XO/VWm3FUAtexk74pgZvRNJdImqIrrBPIbxw+Eg0kmCnYH8ba0jWq?=
 =?us-ascii?Q?16RZuVGmySYUMwcm2Itkl57ZJgaigx085oFG5K2xBNzdYDepwPjSSWoexyzR?=
 =?us-ascii?Q?hDm71PyNoqAIpLNHGjAhDefJ0UER4VOZiri+aK32KWYn+kG7f/5MDTBi2O9L?=
 =?us-ascii?Q?pmfgKcoXe8u4yXHnoNHeqi3AUjZpkdekZXJ0CMCWnr9rc9bw+BjdQyooeQSS?=
 =?us-ascii?Q?9BKpSBjSqkqwwHnLCP5kEdipd2hBXX4W99t/xw5/nUsRF01Rgvf4Ku7gQise?=
 =?us-ascii?Q?ud7y1QXzFLBMGQcM8qrutAjMZOimT0frEZVUIUgbvDqCEa62RUcpfiTt/Yb0?=
 =?us-ascii?Q?/VaNp3FWY2zWFfoETvzp8N0jfGiLW8m6edP1miOZ/bYtpNTGpUG0uQROJVIA?=
 =?us-ascii?Q?xJXrn6iV8rzY97omNr5ais4LBsvVH1btor1npapMBzca9URZGZGwIfkOIZXD?=
 =?us-ascii?Q?0L5Qu8gP5t1YLtlrJn0GPnroQTuvoA0x3hHfPFkmB3/8G2DATH/Bv6AJriaq?=
 =?us-ascii?Q?mnoX0zyJjl6TVLp7D6EXzswlav2dabqLVViyksowg2+Mlz1x4bxKASQA22np?=
 =?us-ascii?Q?Jue2JlewGAmp7tCES1hHrav1KTjV+WeZZMvU96eVKnyEdqQDRnfIuLP13xLY?=
 =?us-ascii?Q?VEeQ86A4qhXBpcmDxAsySfEtbMvvjKuA5UuoeJHESPlLbmX4oOPl7NT4uvwz?=
 =?us-ascii?Q?fElAujx//VBVAhqSNoxMYO+xBPBGyqW5LtCCDe7oCoCPs4HZh/dbfisoemYy?=
 =?us-ascii?Q?tVVnDq4Sneu6wOJ2SOVvfTRnaaMBA54Cnlr9Nb1xD4KhyxdADX/CNVgPfDCI?=
 =?us-ascii?Q?UbST3m3K4HVGprADalITghQ6y56b8FDCZ1XVwwdxGR0ZowE+wxQxTbGcM6IL?=
 =?us-ascii?Q?EQg5ruf5GdfWOA9SBT3Lqs+sMPdDO0KzQLScyHqdSNMpVQ6BSdd/eHU9b23z?=
 =?us-ascii?Q?2nzqwNb6I/YngrazTp1e8a+K7Es/xecSfby5nKwgJ6ref8IkWambl6tItHLd?=
 =?us-ascii?Q?0QrS6dmukZ7aDl3gr37jodZkufAFD8BWMB+b7SEw5ALUqnn8VSstWmNYmvXT?=
 =?us-ascii?Q?ESKVMKXGxkAf0sfDGVM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eda57ca4-7a81-4251-338b-08de04db4c3b
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2025 13:21:45.9632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fziZKkBX2wp9HMEwAi9MvWbIF4Gqb6S3D5Kj59Dm4CFfdd310TmsARlC3XlC/g/b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9213
X-Rspamd-Server: rspam01
X-Stat-Signature: kqhqeotrz93gsos3i6yxjos5sjhnihzc
X-Rspam-User: 
X-Rspamd-Queue-Id: 577E120009
X-HE-Tag: 1759756914-44153
X-HE-Meta: U2FsdGVkX1/c2ztvH+ecWY98RLDgDJURKozHUSNyp8ohCivo0onveCHs372Ro6RxI46odmWCwFaywx/69pDrfsP/YKAYbM+FIdk1Gdr2IFwZlyuXVztXCmtdHJ44kyF1SFpgBDiwvU4ikLtvAtBiHmZw+7gO5bDarrJRtm8QavFlfwyXSLXzSNRYtxRnO/oHN+sEuHsNs8eOM/DBJh9vk3xGl6yBw5IvnphP1BMtnRWifseoe5xj8QfYF54oyLbsXPzhUZZj+RrNJRpzib29x1ZS0uag7aA8j8fGEYw0QmJM/eGVE0ZiX7jJpL4MbKmn/RKBF6Jt6cIu38O4dmFAGG+ZOARGYp+SCPXPdYR5e3LvXmOSFvMEya/HBKr9q6KyYgBlY3D9x4YgnLDByHdkm4NYhObIChtBNeaJ7exBAKR8Q4LEBlQsCb8QGgp69IgXdo5uLokI7PGccrkkYxNCVrdYzPLwtj6s3+c6GFm3ZhBb/ZPF8pvKvSct9iexBNYtYhNjPy+VAwNhXc+uLAXcX5YhVUzQHRv00h7Zy1S6aRwGqyRdAUxrTmJylht21T1p5A6GkbwzIYCJSGmq3FRMglQs8sq1ysBts8Gi1isamd25BrqGGI9UtjsONn0fX3sz1qCumSr0E9iFLrTuu/QsQEKQN1QlmRMtKEUW9dm8yOVIUK6ithurfrLZrlIEoM3PX6DdeRFzWRXpBy6DOyOHVeXAVX+d9XGWBr+JVviS/8MWMaWk62RfaM+GoRVg//QN+Txh7hLLqIaFS8wpODxlgIBQ1ap3idt+dAgO7NI1oZyoHkaeuFhXw5DMugh41sjwnWImbguu9qMQQQDK9DMRNYvCchJ70kEbKDx3zyAMuDgl+bEgXCRthRZB1U6q1FISBXsQmznbCwFkAbsiyHIqGqjOFyvLWq54XmdfIR8jvkvHK8hrAaSlvbYpsCLonhrL8754ZCnXswIzYts5sQC
 YB/uWu7O
 PEE92d9OJqnOSqQJe8Tl/45BElvsPdqUBruqqHf8wstR8pqhpoNse1TTCj0bZwaQ8Vtrv7LXr3S0n5F1KhAMikpsoq2+pg4kiBxEGMzWTUU8fRb9wGJP3HPYrWdRLw1L5VxbPLtk9jhwVpHtLwPBwSFdq11OZDwwn/nTZ0z042AvfhRZvVrhNhN/aPmlpo+tHQC1zDYY0ka97pH7semBXYc42fzKPAzYsvLKL7NU3N1ycZp9zRRYb33UIMrvfQKEH+e+Frzno8/7zfBG+Yw+K6MfZbJfWhsQXJ68ZOasRSPYpiYefe7tq5bMJz/oQn9G2Qumjb4fNOJhng72G2o6ELcz6r5j8O1agJekHuKH8bnH6/PhajKXajHWYlDDFabv+WnfJw1crqgnr7j0mJimTTrt86Y+1591bJH7/bCD+zvgtZYOu0KpBa9VqJ+Tltdzdn3xlB0luCArFt+k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 03, 2025 at 06:16:14PM -0400, Felix Kuehling wrote:

> It sounds like zone_device_page_init is just unsafe to use in
> general. 

It can only be used if you know the page is freed.

> It assumes that pages have a 0 refcount. 

Yes

> But I don't see a good way for drivers to guarantee that, because
> they are not in control of when the page refcounts for their
> zone-device pages get decremented.

?? Drivers are supposed to hoook pgmap->ops->page_free() and keep
track.

There is no way to write a driver without calling
zone_device_page_init() as there is no other defined way to re-use a
page that has been returned through page_free().

It is completely wrong to call get_page() on a 0 refcount folio, we
don't have a debugging crash for this, but we really should. If you
think the refcount could be 0 you have to use a try_get().

So this patch looks wrong to me, I see a page_free() implementation
and this is the only call to zone_device_page_init(). If you remove it
the driver is absolutely broken.

I would expect migration should be writing to freed memory and
zone_device_page_init() is the correct and only way to make freed
memory usable again.

Therefore, I expect the refcount to be 0 when
svm_migrate_ram_to_vram() picks a dst.

If it is not true, and you are tring to migrate to already allocated
VRAM, then WTF?

And if you really want to do that then yes you need to use get_page
but you need a different path to handle already allocated vs
page_free() called. get_page() MUST NOT be used to unfree page_free'd
memory.

The explanation in the commit doesn't really have enough detail:

> 1. CPU page fault handler get vram page, migrate the vram page to
>    system page
> 2. GPU page fault migrate to the vram page, set page refcount to 1

So why is the same vram page being used for both? For #1 the VRAM page
is installed in a swap entry so it is has an elevated refcount.

The implication is that #2 is targeting already allocated VRAM memory
that is NOT FREE.

Jason

