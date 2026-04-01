Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E885E10F9318
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 03:24:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 587A26B0089; Tue, 31 Mar 2026 23:24:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55F5A6B008A; Tue, 31 Mar 2026 23:24:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44D9B6B0092; Tue, 31 Mar 2026 23:24:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 335726B0089
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 23:24:16 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D12D31405A8
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 03:24:15 +0000 (UTC)
X-FDA: 84608543670.09.30BB5BD
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3EECB14000B
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 03:24:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=N1ga8hFo;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="JtaCuM6/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775013852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+BDuvNXr2/1+ofAF6c3uvwqm6DMfCV71CTexJFmfxv0=;
	b=Cbh+rGwrbVQJ05r9U7TWzsymQ9KmGJfD2GGZPKstvbncwxwY7FmqQzjMYkCDo6CqpUbhuG
	SE/+myG/MKlca5AW3Hr/UdJRHx/MkDBftIehjK0k0Otar8PhL/sGAlo4u63R7EGBNc/IWK
	0AdgV2JnmupgB4heEO/UxTXVaItNFwA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775013852; a=rsa-sha256;
	cv=pass;
	b=LpPdbiIwoBk+Am8GaQmDdnBn4hlmjUyKnAacBeVgss0Fkb6nZeX6Q1xLAg91nNWqyAVBLc
	9rzGUdR6vjfDAYt+VYMToAi0t91GQl8Q69qc7m0d19AacoYCS43ADO/4xmbQ0baJHaWdun
	zDjw/BKtu5jUJNmEpfOSnIhUlty3mFo=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=N1ga8hFo;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="JtaCuM6/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6311E2Eq1294686;
	Wed, 1 Apr 2026 03:24:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=+BDuvNXr2/1+ofAF6c
	3uvwqm6DMfCV71CTexJFmfxv0=; b=N1ga8hFohr8xJQttM8L0krDvD53NxYfNOI
	0wNvIZIpxzmUhiGZtgazcs86nBvPhBS871b7JFyPATfZK+Fd8sHJjHCHwVgSxf7h
	q5yiIWZB6XMHHTRz5wAkHPit2zSuBZJEXzNjHEq4NZNFbAA6Buqj+9bpw21B4F3O
	4FXW9lIbSCrRYeE0MCVKaJY/nAFht+mHfWa4X0/5T0nANtZaOxZoJOZIgbr9a7gE
	sJin2iUXBawaKPIVv8t+qTxFS8eU10rsfQIpg4hni0ECaSdcRMDAuBj3kgnw/++v
	Od2g4DBLlbN+dPJuzYGZmS6ai2tUsllZTRS+sLmy5Mp+Uefs3bCw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d67hqdnk4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 01 Apr 2026 03:24:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6310f35R008170;
	Wed, 1 Apr 2026 03:24:07 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011027.outbound.protection.outlook.com [52.101.62.27])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d65eb0k8x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 01 Apr 2026 03:24:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aWM4UF1EcJ8q07CM9DLzXXXS6snycSzzW4EVXiLhJBvQvZro7rOuemy+UG4wHpoH2cLMn1s+y8i6MVMLoDJ7/Hh4u0uGXn14gvWKWKw2MAEy/mjNioC91PerJDIR7cmgGqccrrx/s5rOKET4FPW5yQGkSLEaSgCpol4LwRnXadwqbEghUAy8cObCdJLIifwGsZFpTD4NGp0JZ5IjYyo3shJG16mIM0vIjlTQ7lYxT1hPxIZXGsqQ9RhvgcWVEIElCs2FMyk+Qqkjd+KF/tuSIj3NuDw+yBgg4waAONPJsccukyiqX/MUrR4xaignQXV6tlYnpNoL+AOrlj3lmYNOiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+BDuvNXr2/1+ofAF6c3uvwqm6DMfCV71CTexJFmfxv0=;
 b=ECzgUdrhtQXDcgfZCwdTJN5XgkDhrovODRt8C9j/B2nUrHHGlglLjX1eAGr48pMvSheFojscr+qndmY3hc3UxHAiJektSpm7/3gv+9u6UMDOet+UrAbh1rL9y+UNn1YdoEC/vBYTfvq4AQZlBsWyXDCLjdpsSYb8GDtT73moE5Br+UACz2Wa3LRA+PcHzoZVc5Ki1ODkAVxWP4qT7bsXNI8q+9Id0JFl/nxKhdVgSe2u8xfSTQQNOVe3PLLYKd1dIN+TX/UCm2zjaQ81xFPI7Emh6rZn0yjp0eC/sMxtaGbCehmPCxnrxjA7WPKyEEyFaqbxzf6TOTdssOddtdbREQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+BDuvNXr2/1+ofAF6c3uvwqm6DMfCV71CTexJFmfxv0=;
 b=JtaCuM6/BaZ6jbipI9u3I/e1y4753UUUDUFhoykOlew6MXx5hKxd3Tx2BzNiD0aU96eeSqtzZbScfuZlOUXxrjJHi7rjkyKvDXL5z0982UqJBPjOnSu75SNm4Lv73s9VWlePVfN89xquNXk3G1GaQYwv9rGP3WuhDHkbUtIaQnw=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by LVUPR10MB997809.namprd10.prod.outlook.com (2603:10b6:408:39e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Wed, 1 Apr
 2026 03:24:03 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9745.027; Wed, 1 Apr 2026
 03:24:03 +0000
Date: Tue, 31 Mar 2026 23:24:00 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Josh Law <hlcj1234567@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alice Ryhl <aliceryhl@google.com>,
        Andrew Ballance <andrewjballance@gmail.com>,
        Josh Law <objecting@objecting.org>, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] lib/maple_tree: fix always-true condition in
 mas_erase()
Message-ID: <lma6r3ah4e6v4sreszmbkrcfrxzu7dvhuuzemtkw63v2e6yyj7@a5sys3xfpzpv>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Josh Law <hlcj1234567@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Alice Ryhl <aliceryhl@google.com>, Andrew Ballance <andrewjballance@gmail.com>, 
	Josh Law <objecting@objecting.org>, maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
References: <20260312184054.23481-1-objecting@objecting.org>
 <20260312184054.23481-2-objecting@objecting.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312184054.23481-2-objecting@objecting.org>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0370.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fd::27) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|LVUPR10MB997809:EE_
X-MS-Office365-Filtering-Correlation-Id: b41bab85-a0fd-4abd-27b9-08de8f9e1fa3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	yIAFhN55ZeSkXH6ZNTlWCTZgPfibPYSLFCoLaN2icqV4/8/z+tvqYIAYkXw8/haN4okmUwZa2MI8kvJWICVojvMQpb8J5CREjNPuijoV8bpDe5poJ0iGwCAecwbKJ8lZnfuSzRr5Qy0Mx3cnd+1Payjl52xTimPFsIFGbaJE7xQi1v/mxCYk8MAf6HanwI8Fw0d9SkD6EDRhXVWDa07ZAabRiAMs9eH3RZT9jK5MCa5q9cGFEDAlgEM8zKSVZGdUpsd2Mx2U76eJxFB/buCcBYP378/0An9JG9IhfzjcJmXMnGl/GFdjuOw57569VxP9YRLEcrNxZnuWpXYe2NNsMk78Tf0D5+esgTqMBpIWPQZUcGzoW17nWPeuGJ2f8L+NtLk8DCc5U+Yssfez36uE5okZIkhcxGQDopCj8rezF2s4+TH0OdXqaZOnunygqQrjWs+JjPtX6+mztJ39FSmY2yApfPyT1TTWCRFBmPKFxV7FzRDr+ikPrIG/UrPOMn/b+EpXR6FYTLZgbf9XhsLMW49tZO04qJq/ezlh/D6pp7zY0PWhbIe9UrzyF/+d+v+U6d4Cusw5b5W0b9dckJnw9aUjgeuaQ7pI3mswc4ykOOFBpyvTMEM5UC92I0QkpRc+/M+LYPMW03tWckicBatcxXshOpEHAQ6R07TNrMKKA6gJGlr6b6/F8fSNLlqsOdUiAZcbT2vaWZRRL/LwwNMicRLOa78yIf0DUOhfh1qsL0Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2P22xQ5JbhBvzQQGcl1XajF/QwViSrO+RmF3JKW/5A8TDfNxC/ba6hwLBgXM?=
 =?us-ascii?Q?1KrVwg9vwxGwXJ/Ffu0ITzfUeQeYDU4cB3A3/DNQuecoLzbAX2kns88zCm4A?=
 =?us-ascii?Q?9brUUXV5Uirrmr6XwaqMtdiPMVt6dgl6KKHPCJf5+kgCWDc9SMum10bhkU+C?=
 =?us-ascii?Q?SBZXnwz6BbYOJStIbAg6f4T05SceSvmaWo6KHmSt7VCrVf3CE5zzPcrUbaQ1?=
 =?us-ascii?Q?JKgW7IubCrKrJ1C7LTcXsAhjIwI971oGnps+lpjHeXfZOe28hvri8PzlZ+3J?=
 =?us-ascii?Q?/nZj/jiX1N/GNOSHnJMoXDnJQDlG0Jp1zqOJmK0gQyrpag8mNtfXU12weBM2?=
 =?us-ascii?Q?ra3AVbtn7AIPKdk4dRz2mbjg7+hao7iNSiTjnh9o6LSMByTu+8aKc2gNEkuH?=
 =?us-ascii?Q?pfyosoRxGDM7YlrodiBqAbwqjDP0bABfFJoDP8ey12Xufm9sJGmZ6cR+8brW?=
 =?us-ascii?Q?qdqXs6XgWwNfD4atPdxDEUKHQtbQXBQ9c7t8VORS7sWqeYK2/Ocl9I8Vr2h7?=
 =?us-ascii?Q?rhjslMeiaEegpgH3ADbQrRTkEZh3zmZFtuuXR6DxPfhxLWg9wmP+ZydGONhY?=
 =?us-ascii?Q?/fjrM0muIPOHXa/nX2p/owJY4XneS4M3iklllSWzj3N0hW/yp3ZXZbf59FF0?=
 =?us-ascii?Q?isa54TBHuzP4xXdPfdPiKe2EIrjciA1LMu/1fpfEu7tnnMi/9Vt/QaUksGip?=
 =?us-ascii?Q?R5iqncPpTF8njTt9UlwMRcGkheFn2K1wRGKIZdq3bg8uJaJEf7Efj75JA+jG?=
 =?us-ascii?Q?Z14hsQQBERX0LDbLlUPzD++nTVF4rbFmH4qOjPqFCUe8/vqpesGT96pb7gTn?=
 =?us-ascii?Q?g2ShRpx0IpH8LsXhjIkQFzgIoG7VzFQW19rV5eSD7sxQyZdGFFSb0bKGM3qk?=
 =?us-ascii?Q?ntH0uVwxJtk27P1gvnjYiq0fVRdM+76Q4lKtwU8CKUz3FnI0ZQhXnOUV2NE4?=
 =?us-ascii?Q?j7IbZUpyglekCy+kTJZ5/yMnDJPXiCWBNED2EB7LqsPq7FL+82SC2yeUhso0?=
 =?us-ascii?Q?mN0WvsO8jpU4IiJJH2uxSbNW0N0Oudnx6TR8XeB+MobToU+6P8bq890Yx6yq?=
 =?us-ascii?Q?z2s1mXrPlIkCl1YMhKPhJvSRIBkEshylzGItzh/U+TGPcgnn9SUC9IX5qgKw?=
 =?us-ascii?Q?ecNpMHIGApTI1aUoOh73wCdpRmpzK3v7QAwYTPAOuCAMtn9nxPnrmYso+jcy?=
 =?us-ascii?Q?HG+LVntv8dw2mPJimu+8BOnADVb0D58Lr4i07eerwNZ+dtd1QPcTcjZ84YNv?=
 =?us-ascii?Q?nmgkjMJQQ+YZPcw0zQERq3g6j6Or5wMj2Ghz9TVbKkhA9RMOszU4GwwsLGMA?=
 =?us-ascii?Q?LLVeEoIH/L6V3MVovhjZ5XBF+j2M4daKVwAnLLz9Rm2c0XVC4ykqHhVmczPg?=
 =?us-ascii?Q?htj/to6u8KTYlsJsIsEBTCY0aMVfqwhMYgs0wGT1TRMyaIpAYGjFaTvgYr+6?=
 =?us-ascii?Q?MbBs52yk8MIKqZTDkSfnv2euCpWIDJLTEy9DBsFWmvk4lAIx0vx+7RlWZicA?=
 =?us-ascii?Q?sw8FgsXC9kVie+rkx94E1sEvwXaBZ/OVU+fv9NNmL1IfT+LfVj6msysaX92a?=
 =?us-ascii?Q?50HA6Iulj9Y5OhXMDNvieiPQYmVcyb4eRpanp0KdUsRTNiedudOnVHiBveqs?=
 =?us-ascii?Q?9bY/EB8XwOTD+9wwgIZ5YInq4Ru1khRuA59Bx1kP5NaYbb/YpP80VjP9qrDG?=
 =?us-ascii?Q?VTrcLtY9Hc+hlmDm6nGd3UjdOn8omiPcrKHSmXEV+0+OtkSjciAjx3ECSZpL?=
 =?us-ascii?Q?kDsa56ItGg=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	qKxyEbQG/3fQAI3ecPia9L9+hWU69RmsSC+ozsvmQTP1h0LHP22OiwcKCZlMkOY7o3ADXSLQE4GhHJWIjkANQS44dUtUN72X52xpTuvjuQIG3lv/onsOctZIbizb0lq3e5G+DnFX7QA2avM/O3SqXFZl3qd0OUMquszYCLB1tiftK6PVXlfvMV+cQOZOWPPXBq9byNKvn8eWRrI+9JFp9oZXnfIVUi1TUwYU82g0BesJYguENDwdgwb2cxxoHlW/+FefhujducxS7coszrL+Jmpxyuz45xPJAxVSkH3suckIIQn9RPn21IpN+UxBFT49Pi1TdPStKXhv21rYAEPfIA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rr6TZeIRnDbbr8F379Q1ns+YWBh07SOuZ48TbFJMfLaeAj05nDHbSlbr1uM025/K0RkAWdLYdTX+jA3NYE9FTAevipAGymaOqRofMmlmfZ9qUR6q2ox0QY/g9uv8uZyJRGYEzrn5g4sEZEJggmqfkwshlGnC4GoGzlaSoeR7/0OslFO4L9NAnsWoa2ssFDBHdwhT8K57QCWk8HgM8sjs8RMW75NnIRoPrn3A92dvjd/zRxjs0h3nwrmiGDYzDD/nDn4DgOs++zKK+t7XHRNEUJYISc5oKuWII+N8mHwWwRlpBsA4mUN6tQkZ0+6N4rZWYo0OsoFLeQKb3eIkby6te/+Ml4iTLLQYfUwh3TYVEk+JiY71tNjM/esalKAQCuuSVA5Nz3YvmIjfwQo+22/l4WW0EDgm4siwGTQYcE6Q3cEXZT0CmcPn16MkBNt06e503GOMiV/o1+Q82UIs2jxwxd/hU/xqjj8hOksZK+AvHJXAGJPLQryhQmOFafp87MctEQJUwiCehl5QBjCKrAv5W9syzuETPd9WAuYVbZSksPEP/HOKK8eG2vsaYIOGVUWCr3Jfnk2Z4aOelZ5b/pUhbGS6HqeTbD4b9XIv80iETng=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b41bab85-a0fd-4abd-27b9-08de8f9e1fa3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 03:24:03.3134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B9Sk95VRdY6j/HNO2xHxSdIZPM8M48RsyM4zCmr4mOoOcRVZwDAyf2qimNm2JCOXuvsXBZbwO0wPVaiTjKH20A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVUPR10MB997809
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-01_01,2026-03-31_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=883 adultscore=0 suspectscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2604010024
X-Authority-Analysis: v=2.4 cv=T7WBjvKQ c=1 sm=1 tr=0 ts=69cc8fd8 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=pGLkceISAAAA:8
 a=yD-zjvGMAAAA:8 a=qkW-ITIOV28HyxOR4JAA:9 a=CjuIK1q_8ugA:10
 a=kLuJvYmyrWYxQwIM_9hz:22
X-Proofpoint-ORIG-GUID: 2ZlgFqXem7HgosnanHv0TzQ2ijNkoVyr
X-Proofpoint-GUID: 2ZlgFqXem7HgosnanHv0TzQ2ijNkoVyr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAxMDAyNCBTYWx0ZWRfXzmcBXgWRNgcY
 xXhwvV5SJ0PR0XIojDTjUlqz7Qt9stgK93ypdOb9JZNQKz/i8ZEfQNHsOxt905LQAjEHJNGUJR1
 rD8WosrVEPO+ue/rmuPmce0SbouLsFy+/tx1vP4m62Vm19mSENyEJ93ObIBsfhF5LFGB4+wilJQ
 LhPf9fPK9G9iCzzPNn9DWNWKUJzPurcPZIOeR8FjjQ6NH2jAoA6gLuQzelRvpsM7NRE8BWwWru1
 W4SuSqOVzjW6wR1bpNuMJol7luZ1bZ6PrltoNgijtObiqdUsud1rrwsJtMTL5Ur+xhZwHFyDFEg
 tTCTMgzlPGoDAeyz5LjPr+/PlQmYebcZV5FfRNjp3FoS8xLDloV6DMGjQB0OxOmphZu34gaUAWP
 RHcajtlpr0QPlutAXkrQ30uyJvtslHNpfU5Tm1IzqUlbsAsdX3ZUqpgg+fyQq/CRtJmRrUxQAUm
 0VKmDONTN5PkQdjjPaQ==
X-Rspamd-Server: rspam12
X-Stat-Signature: y1q7bk86gsgnzqh5yb547jw4iaqky38g
X-Rspamd-Queue-Id: 3EECB14000B
X-Rspam-User: 
X-HE-Tag: 1775013851-858539
X-HE-Meta: U2FsdGVkX1+mXRw5eY9qopiu3akWEI8SQ91zBlCUPwPHZ3E+5d12+ijdsttwSozrfua8HXuynvLet+HnSuoMi480XjQm6zjxPDgu6QQBgEflDjnqYGoPI2tmpseR1nJu+jlD5Y35wiVzh81z1HXwyNl7ORQja5Utj9tAydav0/2SwU8UX+shOq1H2R36RenuMf4E5EnvImPSEuP9YlSy5+hQhLbsh4lCO+m79iHO3WAX1HIaxsLYp//C61cCQoS+uG4RMfCAqku0ZQsqEdKgtWXj1Du7GmEXh4kPQtf6AQjv3WBDJqb8ACk/xoLgVRFBs3iLxth3NOddI5RHB8wom4F0B65Hfo7oexqcJBo324d4Q0aXJ7THJwldnsrFM68ATyAA7pBwlsck31mHLwguxK/Hk6ol7aFAu8KAcbIGrdWUIbSzfae7ywmlbfjLBnlxlQ/t/kSpZBcO6v8N1EAimtqfrcpRrFJCD4z2W2d8XUGuHNz9Y3NqCPXqIuTeL2Q+EZEJ2DZslLpV01WkL9CA6iCw0oRpEuu8a4tQsaetZsrzEgyYAbiUPGVIly09EV9Nqa+MjI7i/dv0PI+QWctI9mjKMe/CjG4to3EjXpF3fr80U6WdydHvOEUeDXRUibe+Wi5nW5OU/ftami1a7fE6/Br0ZkyR51KfBQssuVE5f66ot8dDfvCG1ro6RsQNw5Mrbh7lPRBolMdH0nsWRKzL1awBpfqhZCc63fOiCDNV8k5iEbkNLq4hUZrxELdcbWYH74Mt/rNsiVTs9YbISLBmb/zTlwFH/2WueiJJsnQU79O4GSXyf5lICicy54blTfuy5xUVOcPSD6zUWNzX4IYt8xW6PooEZ+fw9/FoPu0dNCVrHhx1ZA5rqZ36KdeyQDFRo7tPiEbFGjHDDQDLMf7Q/LlVQ5By8kNH8VhzOTWAiDGZXdDoq/7Ho4D2qdSvhk/whKLQhDzH689JlTg09zu
 fcw4GB/d
 2O8CJZ8l6xRKsbnZqbCqpoQ5vGAG7MuDguG3No2vJwU/KvrMpEHDJPL+X4jTWNhorQM78jbdjvJY8055PYV+SnVSbu5d/S4t2MsIFRIxxw3ikHKbGnkR1JmqH/tYwB7TKzffrqGiVSc8JzuGoXglnnh9gZIIGdtzrjjkwbw3bgTEFCLM7/r42aEf/DvGM0FjFa5JmAhbfBBIR72zDtRP61VUMXw6YxkaAyHR3SCwlirO0Pg+gvqIbxbQWzK52m2jh6sZYh7u1iP3g4MuTwF4lYMp1g0faeo/qn9e4aQpDYAV5pq5Ed5kwvfEAPpJLPbpsB7NofP7y03n1G56euTRyYjE2TprH7RJo0GC16n0y/1J26Am0VpeQeClbjHHQmDFLSYnhsOtcvnNVAFt7d8dQb0QNZU1OR7zeIawlOSFRQHq9j9pel0L5Gyzdo3Vv1upP/OlHzhmessDcm+kHZ5HYMjKTaX9n9kihIuOwC5/cl+PSFj2V4sx4GqU1y3SVmmrlt+//tf3PwqLNlFqZYIGwsMMPFvr6Da4zMdLhM+LpXJLOLZHKrVW/sdam+KN5sPRh3HcypfRmf8l11Ra4HTGFAwEDRhAhvIFG7bNVER197GokGf3WMLilj4zPNl3zojwHU7VKp63X8MuXPDE3NdbQ8ZUKPuF4NEVWy8au6gLnVspND+qScdw+QnML/JkUWPVMOsbln9ZQNbVunlvF7WCNGxRJBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Josh Law <hlcj1234567@gmail.com> [260312 14:41]:
> The condition (!mas_is_active(mas) || !mas_is_start(mas)) is always
> true because ma_active and ma_start are distinct enum values -- a
> state can never be both simultaneously. This causes mas_erase() to
> unconditionally reset the status to ma_start, discarding a valid
> active walk position.
> 
> Change || to && so the reset only fires when the state is neither
> active nor start, matching the equivalent guard in mas_walk().

This should be a function, then.

With a test case, if possible.

> 
> Signed-off-by: Josh Law <objecting@objecting.org>


> ---
>  lib/maple_tree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index 87a2ba6468ca..9727dcefbf65 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -5574,7 +5574,7 @@ void *mas_erase(struct ma_state *mas)
>  	unsigned long index = mas->index;
>  	MA_WR_STATE(wr_mas, mas, NULL);
>  
> -	if (!mas_is_active(mas) || !mas_is_start(mas))
> +	if (!mas_is_active(mas) && !mas_is_start(mas))
>  		mas->status = ma_start;
>  
>  write_retry:
> -- 
> 2.34.1
> 

