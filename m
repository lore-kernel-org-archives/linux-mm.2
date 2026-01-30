Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5849EE6BF10
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 21:00:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80E546B0095; Fri, 30 Jan 2026 16:00:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 781706B0096; Fri, 30 Jan 2026 16:00:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53A3A6B0098; Fri, 30 Jan 2026 16:00:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 33F1C6B0095
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:00:31 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B77D613B9A8
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:00:30 +0000 (UTC)
X-FDA: 84389848620.14.B038C3B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 05E1AC0018
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:00:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZIpqfYj4;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Et9ihOp7;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769806827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ft62lqWNUCLCETJbkBSmh0V88SUea+5+KSo70XSkRwg=;
	b=pOkmhEJviUn4kbkbH4fq91/kpjOdBKxlsR41Uyj3P8PQuvkHRxpHbt2r/UXwgkH9FIq12u
	NC6yNjOVL4+uFwdZOxkkW5iQwhhptI2F4Q+Mnhywoeynp4kRI0pLe7AA6C6vC9cBlQZ7zp
	L/1h4ngyTQ6eQ6ZPzSTtkcNmzea6zqg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769806827; a=rsa-sha256;
	cv=pass;
	b=WhyZJxvW8fYGFq6xG63FDIIirKtS9CleqdfWDjq/cNhKPU53Q+jiVk/ViHZQYDUoTpGCyb
	YaH3j76rk/6kCZ9z1xPe8k+NnCjRizLkCY9o2zQImSYJI/FTJlJzCRsSVKO/lUE0C06Go2
	u+g5d5VUxj+SrWikvn2WTeLG09dEPNo=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZIpqfYj4;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Et9ihOp7;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60UKDnfT4028937;
	Fri, 30 Jan 2026 21:00:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ft62lqWNUCLCETJbkBSmh0V88SUea+5+KSo70XSkRwg=; b=
	ZIpqfYj4BISa3Yb8tujNCwsbA+ylFu3RzRDSdYN3ZJqo9H1N9y18uy7fJ0PTZLuu
	G+JQs9pGj/GpGRTPEDj7VyISiUOMl9GxF/E+HyRy0+PgEI8nlQAhfMcF3dhHvWwA
	PMUKsvP0PwLHvXTR8IqQJh/m3RmadnoyYIXF7xaK5dJ0Elznr6a278oMac3at6/o
	W8tk40EEUo3BmGo45lgU/d7hAg1VhbNZWLp3qOqmdEFXh89K/6k5mgVnOfHxQQuB
	bGOhpaUoyxizuUC4qxxdMrLw/op1/2HsZuwe9VsOeljHBvCylvTS73kr0QULs+TH
	HeDTEHVXIobp0rDL4H7NDw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c10668cfb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60UJhLP9010549;
	Fri, 30 Jan 2026 21:00:16 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011022.outbound.protection.outlook.com [40.107.208.22])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhe5g6a-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ooyrCg71EixF3f9it2BEHaR1vpwQWFvkKaxzUWbsflG1ZMn2unG+GbtqGKQSDL7SFtBGcxHVoFyxi52cUPfm6M1Uv5GKf1hSfAXUvRW9qg9AooYlk0mFhKy95yM78xT74qc7yN95VgZqmBHWmi5vdRGVbqYreIBocmjiLoGMaiZPKx5BCJyHEs93BVxHt9VDvv/qmZr9fVMK6CL0ABkydHDmDxuwK895fAeRTwunK75fP4QiWZXUcFVCA05JignAtfzoF0RbniGZik/FzJ7RR3WBn9CxYTpueOnG/JiimOP6H5i5sm3p3aI/vHdV/8y312NEtbAobm8tOZCHlRYhcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ft62lqWNUCLCETJbkBSmh0V88SUea+5+KSo70XSkRwg=;
 b=HoOGuXFNVSkYWa2NwxC/NgIJkrep4hiZIQ3kgzBPqmYOwfyyIy8UAmz9985+5rhBpaHAyPu086Ouf0V2LTAUqdqSPnA93G5hvMKFkwR6IQmM5J5K9a7WcwDRo09N2WPshKuluBw5NYqwbzUhpdGJVVOFVD9dWT7tf6c4Ya+iTilIfpXfdo3TwZQ1ebz72We8EZbdMeMHeaz6X00g+dm5TqASTGif+WUaf5ieasg1S39TCX/MzgZdy2gRZXFkJMEFtQUpF5iL/m4Dk0t7RCpVBzm9OTUuWA6Q0jQWWCbuq53gjA02ckGTJD5wbMvkNUbY7CFEZRGW3PgW0xi58l2XTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ft62lqWNUCLCETJbkBSmh0V88SUea+5+KSo70XSkRwg=;
 b=Et9ihOp7PkORsaYgeaXk1OIT3pwoZQoC5liCkEWzkMIIbfOj/Lla5rpDxR+VyZ2UVZbBG+4tmWeRAPd64ECJ4h30/YLm7E4fFydkGTNcyL21kJv43uhdLgfH/Upo4oGqDNN6xAzRBWi+k5yZo/vW3cTtJycG44Y4EOhzEh57vf0=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CY5PR10MB5961.namprd10.prod.outlook.com (2603:10b6:930:2e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 21:00:12 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.007; Fri, 30 Jan 2026
 21:00:12 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        SeongJae Park <sj@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v3 08/30] maple_tree: Don't pass through height in mas_wr_spanning_store
Date: Fri, 30 Jan 2026 15:59:13 -0500
Message-ID: <20260130205935.2559335-9-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
References: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT1PR01CA0127.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::6) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CY5PR10MB5961:EE_
X-MS-Office365-Filtering-Correlation-Id: 00285ea9-9bd8-4664-b2c7-08de60428f9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wG3+0avr0U13lnzbUBpb29JLHiRF14/X9Q2qOcp4sMub7Y+hXhwI8g+cX/HL?=
 =?us-ascii?Q?Fsg/njBJw7dpCwQsqBrEwlXokuf1Lmo3MslXhW5a6dQopz97cPGpP5aq+1H/?=
 =?us-ascii?Q?jtLp7bL51Zak2R9K5cnNPtercNps1eVv2B2aQkdtk9sV63wXpm+0+ELUxhiU?=
 =?us-ascii?Q?SMmz31HxaSQgCGP2m0RTUHaGTBepXi4BIm5HN2OifFmKNZmo7/CjZSuUCqME?=
 =?us-ascii?Q?xp+ov8eJYq7qb5s3I2q+JPxjrK6XEGda7HalKF2iuVKnJvWfkVv0R0LKmMW0?=
 =?us-ascii?Q?4HMAQ1ZWOeYCIrnJzj7Mq7LPwDC2DqZMk3dp3rCjwHgNz1qc8rS1Gm+GhAPK?=
 =?us-ascii?Q?3UQUzo8idANmbMy0NXSg3yxZ0IoOJj9clFMA/RN1sdD3ciMw3IpvW9koGKrE?=
 =?us-ascii?Q?38D7h9dKhYh6iLCxxjE4clFfZPyap83PQhHMIcHCeMTdyXebeOxdaXl+u4gi?=
 =?us-ascii?Q?Iuj2C/3lWzMF/fRskcYzr1wDeRPQtTMOq7X/QGVqzCBtEsqab2JBRrs2n08P?=
 =?us-ascii?Q?XCD2DOIZ8TC0mjshqy0XTeAzkTU6tWYcGMiPO/Q1TjXpLEwuTlqhEojm1UQx?=
 =?us-ascii?Q?bg3t5Rgmmyy+hTDY7SoWwwCnDRdP7IHgavRHk6NzmU5HLIF3lv9u386XLi+9?=
 =?us-ascii?Q?7VN4Irneo1LyfUPLRl13FWx9fWshPtCBzfVQs+LvZqlkaDejLNT7uMUY+ZD6?=
 =?us-ascii?Q?iDBCFuuCg6GsPnjF1Wlpfd8Ii/M+XXRi4nK1bv0lrQOubBE0xGQe1zhLVY6p?=
 =?us-ascii?Q?Vh0SLsWcRhhSpWh8bRcctFt8znRetaPooaeqdSRpXTQ2+rvkjmY2g6XcsKox?=
 =?us-ascii?Q?sOM+ljy3ZuGXumDzYiNfmcjt0t1AXnVmFGoh2LgrRaQerEXdGj/jfGIdGmy5?=
 =?us-ascii?Q?QzS/fttp834kdogIx/Sj4gWl4k5obytV+tMMiU789/qwyzZLLcMilnmjW+Y2?=
 =?us-ascii?Q?1r6Uf+LeeD0Sczix5zSPUJkmgSa4YiwK9PHARX1tEeOC6VaR19JAveqtGtwz?=
 =?us-ascii?Q?mngMig28IFQipgiOt6VQxIoU42owR2Y+OOBoSm/VGf4Mqr1uVu+xWKEb3koK?=
 =?us-ascii?Q?xXXk5FtL3GcNrllIUZdbp5g1q56x8gMjITgXa7T8bwS5O1k1MR1bxnhx4QLK?=
 =?us-ascii?Q?66D/j84um+Oi6RniKs/VQ0iQ8ykrQG00XqugWcIWUTtySfMdfLTs4Wg3L7mU?=
 =?us-ascii?Q?2SVk37ND1k0BBTs/AQkJTq+9Tb9Iy3IIeZwBH1KeRzBOHRX2QygH2N4SytkW?=
 =?us-ascii?Q?AlxWSowcMQs7Ak/L9E+KLE+laDcODcU+aOpPYgYM5Lv4W3RQgwYq7wvsFxVr?=
 =?us-ascii?Q?kJo3gVEEkPOWkfIwhHn53CrzysFJ7ikz9sSp+E5QR+Cju2R3lzT1UzpOFK3U?=
 =?us-ascii?Q?TIoBUSNgOOw/xt9RvqBmeh9GaD3aGLcu4rw1G+7OuvNjl/4qidN0PgVfsCyU?=
 =?us-ascii?Q?RD0vlZ0jqtgoZw33DMkr4s0714kubIY+1bGja5QfxdkHpJfz2B7mxNyQ+Thb?=
 =?us-ascii?Q?D8+cWhSJVvmCGHYh5EGwWvXgSVFSHqfqKVR/+pCY3Rso3fmJNTRLrLCKffMI?=
 =?us-ascii?Q?mvkO06CeYYfvZjNa/+o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?au+DsvbDk6QuY3SDDehPYJOcLV0RvIsac2LNOLuCM9OEQ0d36UIUTTEXAT6A?=
 =?us-ascii?Q?Ee3exTDnpwS+Agl7Cen6uXxLDRRCJ/gry85cgbfkJt4IyUhQ7cO1nPRIGVgT?=
 =?us-ascii?Q?2IuXKwF3Glzb2yY5WB9vM8M6IFk+5q5CcKCFDGjIxoWFnzK602IMoisbUjjk?=
 =?us-ascii?Q?3dkes1wARmdcMavADf6nb9kw0EXf8EzK7PeiKQcqiVw0vezKtMzXbDTf/g5x?=
 =?us-ascii?Q?2llmIXMOzesk4QQ37FV8OSeKYGQN+Wx+hVgweyGNxV7hIUisOPXT2EeWgV+o?=
 =?us-ascii?Q?dvc+PWJffVk2FE+XoQNJwU7A9OljVypTnr3asx3jkGYmiqR2fUsJIQRKG0F0?=
 =?us-ascii?Q?hywnAY3j5sTeocSV2QAwfmtgqXMpYyPTtThZtIhGZhIa+NE8SH063giDeKUS?=
 =?us-ascii?Q?RNhXbp8OL5si7irJu6W1h1WNsayUA5fFWjlsQT9Du9p9xUQrYX5Qb4kuzWIU?=
 =?us-ascii?Q?qyvENwsoxuHxNkyNhND1T1pJZshb0s8kM+6yMLu7KrjcmYnShmRxDNJeZsq/?=
 =?us-ascii?Q?h5fOL9LffdYdtbmZxDz7UvkcjY1vac6uS4PTNiV5QuqobHxRtg03WbXQaW1Z?=
 =?us-ascii?Q?+k2ub6zQ4dosTK0Say+r4kKs3BAw43LJvaeHYpMxyC5XAgGZgY9Ddl/5AUN4?=
 =?us-ascii?Q?UX+ZeHT9oIbxM4dXUT0ycouZjtKfL9PBqHZwklHGpb1Ch+Z46Sgg/uqg4Jta?=
 =?us-ascii?Q?RpXanD7vuSvwpZZz6gigWFVDhxMW574Dbt5D3vuFZPXmr0jYtbNuAL0UukEh?=
 =?us-ascii?Q?n1b8Smi752iFdJsXOeVzSmSpwjqj9hrwny55oiCRMhe22DTYymL8Sbb9hpGX?=
 =?us-ascii?Q?zOHabUcOA3a7aMW1karQYewN2pu3wHJ6nzjcywg+mPXdS2yvbrf5b6qY4Miu?=
 =?us-ascii?Q?N5jXl6DNnzCJxneaFFfce5kers5SY/2cpveUWT6JaVHMNqdpMPdkdFkv+JBj?=
 =?us-ascii?Q?okKUpA/f0E4GmEynrj00S/L5LgonmDXtVr/8+TPu6gHlXjAp5kwHmjDuDRGx?=
 =?us-ascii?Q?wtPgvbayoLjY/BoeAXqD0GcVrIoOUbBDDmH1+jAgns7k+waAgfBsVO/Xt7B1?=
 =?us-ascii?Q?94IwuG9lwZUXvJ6EIwT0lPWwxJhSyukgR1N8mWlMiriQpTAqK1KGBbxO2XtD?=
 =?us-ascii?Q?IIsSXrHr157XCi/IL+W0GXMlYgwFZquuIberrKPF4hGeP1PxJ6KQ0O1kTyfX?=
 =?us-ascii?Q?Zlc6z/mNxsXyUF3HxHws7THhGJ/tiFmhjaajFUdFvz3qKEavna4GGihd97Vs?=
 =?us-ascii?Q?OuZCLr9WG4kaCxAsvKO1eF41aOoEIdsZwePB5hD3SWDpeIu8Nb2Zh5UxfH5f?=
 =?us-ascii?Q?L4J3lE5CrbF8/1CxDQ44AdhwZyyknUP+17UD6frfygYFNWkaIrm/IbuHXTkM?=
 =?us-ascii?Q?TQd/M/GV6idhkUa5c1RUkRktBz7AQIb9KoZANBgRMDt7RSwhz7zcAPTnrAf6?=
 =?us-ascii?Q?0+rsauYXzwfkFS6MnnnSKaomEtMifMCQ0DNsnT+5+JZ399PknkXUK58lOtjl?=
 =?us-ascii?Q?ppGUyUjg6mEPkNlBqUF/aNxacxtBLxEIyPTQ5mimQZTfuuYs/kVpHVZXsUmc?=
 =?us-ascii?Q?Sx5buVPRl9z2HfzK5Q6d03QVOLlJYAVysgTPY2jN076E7n/j+LTw0gfz2bey?=
 =?us-ascii?Q?zKdXl/wmzSKdqn3gRGO5s+qSWvLXqXtfbLTTSUUFN75mx3d3URTpMWf6Rsxb?=
 =?us-ascii?Q?gc7ZcU5ZOmcBQkec1U7oRY0G60BvtRFgk1bTFJ8Z11UQVHN/o0OXazfHGDb0?=
 =?us-ascii?Q?dca75Ud6yQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cmTOSxvqL06RxeBAXvgBhD0YhPrV94S8Uew0ekLbZrdQ/MeLmEj52D6NWHmWgK4coxOVLAUhhG66pwtV1V8Mrjqh7S4T0QcEkWAkmumyT9vMVDhQbdpguQLJbCNGTRP8SbKEnZziarh5/hsg/DsVHiXwtIbM1FPsgb820ttSWRmzQzN3Qoa4Mfy5lASA/56roAs/ykMN4AulMETQRQCD8iCpgWC1nFvCNSKV2CN1YLIIMWIuqRpTgDPzsxTrmc00l3BRMZbGvr1Raq77TiVFV2ZSm/t7Td4jaTjufCtaatKNR2jdUMN6jNnIF0bqapadltPakD6mfcC6607wGIX6nELmhDn1IBXKLkFC6OnrxH0x+ndALsTDKd5h3EgBpTjjpFZbNAGQDUsuuZqHHuie/zDDGVXcZ0P8wGLZHLNeTB4vNsu7PjaR6M1Yt0R0J1JPOkr7GfGHC3dv5mkC5mdwxNguiTYPoODh6DAUb0YkQMFoYW3joVR/YHC8aSgB4imDA0w6VEKbUBbG2z60sYf/OPSeRN/XOMdu10modU0OD4XKK2l4WR9YpNlZqi2IA0Tme7Hx7QtOr9uBk3p3FU8X1W326piwAPE720LxzYO+71c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00285ea9-9bd8-4664-b2c7-08de60428f9d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 21:00:12.7997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gAa2IPbFzOmZk0eGVgXlCia8mpS1jRlf998KiUFyCwiVRpRG/u4q+PqUzVK/7MZlpHJCllJkx15Did9beSA9Mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5961
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 spamscore=0 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601300172
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDE3MiBTYWx0ZWRfXy1QJpLu+ZmKZ
 8JtOitwyywbmC/Ch+33LfC1nquk0lKeHUswYd1TbQIeDx7EN6Z4krONfncsbZc6DjA60W0xlvpg
 53UXgrNSYC/N4R97rewbLceOT27rDKFaInlDWhyac8AN3NV7sYWc0fBaspQSjfod1abtt8wO3el
 8wujjlyUEy98XNjs9JMjWagpCos4IwYsL7Jrb18FWfCsKg+uTElGE4h1Aotvogsf4tDgVO97SFF
 LsemdNpf5jCzEWQvg2ZmSk2QO7KjDB9FgJtBlMQAXPuLT+GH+qY5FsDOHehbO+jS7yThkC1fMU4
 17EAZJWXsQTxLvZFEGjUOA6KuewEeHcL/CEB2uym/DV4Enmxr42aUzd7p4wf9OaE8/SCj9noMAe
 D8O59nW3vXSTi2VTEwbdFxICANMfiufDLnAU21TcuMKAgqZDdZj4h8TOOTkbtY85Qop1UJ0btRt
 gJAS9n/7DhKMzNwF4qg==
X-Proofpoint-ORIG-GUID: 2QfzLcC1egybDnNZoGsgViJrjKxaP3Xv
X-Authority-Analysis: v=2.4 cv=EebFgfmC c=1 sm=1 tr=0 ts=697d1be2 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=OdRVoOdji5KT7ucrDR4A:9
X-Proofpoint-GUID: 2QfzLcC1egybDnNZoGsgViJrjKxaP3Xv
X-Rspamd-Queue-Id: 05E1AC0018
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: suc77syn6buxou1mb54kfgyu3zty5zrk
X-HE-Tag: 1769806826-381118
X-HE-Meta: U2FsdGVkX18+qmnVxS+owR+B2Wjr6zl4TTUDynqIiBfbv5rTW+xx+hxm7W8BdSZi6CeC/W2W4cShqObjvwefHSf31uJZH5Pzy+clycjOgAktrHBYlT0VGj4rx/46oKYAyneYAihAyUN2c+LNJa/uT38+supKux4P6e6v18vQI9NbD6DdLeb+QBSZiDNUQ9J2v2wmFYUzbJyvLUg8N/gRa3M7yE6Kqf3bsKnxN0hpjet3jpQZmsxYSS7+f0Bq6mlAi2QCRsvzcacyhzFEQLvHjQ531x5yywY1q1yVTTEzp/J/HhrVxdZZvMLM4IC4j+uiP52Sw6AJYnrCMpYNCKitSK08QiKoZx21pxi0MkJumTGPjFp7eTsyJ8ob6EbVBLzsl1YPNdGJTNUi0BZBaIM4oXT84zy9UlezvFR9GXAW3oLG1E6IrIN3RsXPYUqJ9InY5E4t3ir2vj/E1Fxl0nAbVk5Ym2aHtGZ9WzMupqNi21V8FAMWx6HW7FDIW/AsCn8jXc6HtjAmvpnzjMNhbtkKfCmFMRgcGmDuW+7NodgFDuE6/n//Z8r1RIPnNhW3yzbQF/yA4ffSa0bP9nOHDcPsOurCW+2NLlaM71Lmn1BkGOBEgv3cBXBVpKBWa7xSgSQERByPn0AWCsf29fVU7HH+EgVFpp9P8kLobPfBhtMSB7aI2sIlecShryKZAm/FS8zLB6dVw+VSXhlV22v01dFTsY0APqkNAcF8GGdmdAiTG5BfxavUm/WTMkJ2HsaEFwdeUBavq+Q2pHOrZQyoaqLRZkQsJZEWPbjDOBXCTSWdrRcxz4lCDMoGIHDdFHGuv+0IZllL3tDd0a/6+cO5+omiewr01HhH+4Xhz9x5Vem/wwq+Lf6EVkwzxZtEsdOWf/J0EkjImI0jOC9FroUQpGJJ6m8qGLgslkv84jcKScMYlF35F5UOaumQoMDv8Fi8EJpkEmMMd9uBWsp/UQ30hzS
 ujD0DvNG
 CJ9npt0QPuR1S5SMEbb8v2f7SjApQqFw+3lH1dQn08qFXqa8G0RmC5/4ucDkO7gFBByEWgN0Q66eSPXRv07ov4vngIOcMm9TbSri+tMVXBGKlCymq3VB2BafwJz2tbQzGQIpQrGUF3W6Xc86Ic002pkjlTUt+x0GSlSRCTYIdPW3HcWWz6R0SRhn/xJ5pVDQfFK2cDYTq+4hSq8WtRA5wOaOVi7RTmc88KFuPGpFuXG3PVEfmBFo7RhOYtcmPt+PoqKQNDs5cW+lL10Z8oWQCPr2MPwy2P2HwPUbFPH380VP+dZyVjvfvLWGikUt8hSl/MoiOkQ8vHoNJ71PVuUpe2JJ3+oeAocX6RoIKYEtRGncE69yLj0BHP/Zpe3TPOGVoY04LboBeBmTa428BP9aEXxtsVTup6IGoZtWUZ8Qu/zJlnTVzO9MwMyEMuqbG9ageFP4t28zVp8r8n7r5rfDlSzuQA60nlDE0IR2zXSq5GxQLljih1qThL9BbmxnyCRs0ihr/zdy4fqP2dB9J4sUi2BuAD+xFtw6k9j87+jn7Ul34PesVeDbubv3jWmpFn3twZZ4ZoxrZEL0J6T0OAB7IhKC49Rbj2Xgcj7iGrHpSi7Qf6anNmnlN+9e+Mr31xzWGSVw0tYwCE+X5rr89hP4XqPg8Og==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Height is not used locally in the function, so call the height argument
closer to where it is passed in the next level.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index afa39bbd687c0..91d3fb7ac39c5 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -2750,10 +2750,10 @@ static void mas_spanning_rebalance(struct ma_state *mas,
 
 
 static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
-		struct maple_subtree_state *mast, unsigned char height,
-		struct ma_wr_state *wr_mas)
+		struct maple_subtree_state *mast, struct ma_wr_state *wr_mas)
 {
 	struct maple_big_node b_node;
+	unsigned char height;
 	MA_STATE(l_mas, mas->tree, mas->index, mas->index);
 	MA_STATE(r_mas, mas->tree, mas->index, mas->last);
 	MA_STATE(m_mas, mas->tree, mas->index, mas->index);
@@ -2788,6 +2788,7 @@ static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
 	    unlikely(mast->bn->b_end <= mt_min_slots[mast->bn->type]))
 		mast_spanning_rebalance(mast);
 
+	height = mas_mt_height(mas) + 1;
 	mas_spanning_rebalance_loop(mas, mast, height);
 }
 /*
@@ -3448,7 +3449,6 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 {
 	struct maple_subtree_state mast;
 	struct ma_state *mas;
-	unsigned char height;
 
 	/* Left and Right side of spanning store */
 	MA_STATE(l_mas, NULL, 0, 0);
@@ -3476,7 +3476,6 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 	 * Node rebalancing may occur due to this store, so there may be three new
 	 * entries per level plus a new root.
 	 */
-	height = mas_mt_height(mas);
 
 	/*
 	 * Set up right side.  Need to get to the next offset after the spanning
@@ -3509,7 +3508,7 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 	l_mas = *mas;
 	mast.orig_l = &l_mas;
 	mast.orig_r = &r_mas;
-	mas_wr_spanning_rebalance(mas, &mast, height + 1, wr_mas);
+	mas_wr_spanning_rebalance(mas, &mast, wr_mas);
 }
 
 /*
-- 
2.47.3


