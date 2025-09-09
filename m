Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35311CAC582
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 19:11:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E3828E0017; Tue,  9 Sep 2025 15:11:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 894468E0001; Tue,  9 Sep 2025 15:11:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70D958E0017; Tue,  9 Sep 2025 15:11:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 567268E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:11:27 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 03F7013B690
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 19:11:26 +0000 (UTC)
X-FDA: 83870655414.29.8A26EA3
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id 63AC94000A
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 19:11:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YjJ5sh50;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dPw4ocBs;
	spf=pass (imf12.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757445083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AtGBVs46lMshXtmj7R0O38tuhE6HWKvTTQPsMxKSDiE=;
	b=Z54JceiP1RN7fwjkifZq0jH7yB49lH1qwfA5kZdAS50czX2Kxddq/rs8ChM2kMmaJKimGQ
	2OYG7meCRSuWXugG1f0fxG9BmC58PN9zP45DSvF95caJ4igci9bjsyZ+O+BSO6isXk6kW5
	SKMQFLyTGOHI0EMJ2tY03Iulce2pNsY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757445083; a=rsa-sha256;
	cv=pass;
	b=pY87alX5EQsWEFEjd6xz1xla+gP1wegloMbVb18ly0uHkdJsK41Y4pP5t6O/VHyytXz7rS
	Bx8seJYDyGDscx3lEoDKUOioZyIhUyqi+XnWD86MlY4gbQ2CLsmarqVeJmLbXeZ37s/0Hm
	R082AMVjS2j3vjBYzf+CccMHhur4GHs=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YjJ5sh50;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dPw4ocBs;
	spf=pass (imf12.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 589FtksV011917;
	Tue, 9 Sep 2025 19:11:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=AtGBVs46lMshXtmj7R0O38tuhE6HWKvTTQPsMxKSDiE=; b=
	YjJ5sh50z0Dl4v+64oCJ7xfB1kvdwlTtwMMgg66Eo6egG2gG3qfFPh0mS7lFMsnp
	MaYVdXDCzRYuN+LpawrOGuEhc1QoNDR7dAUIsMFDpvNCRhl6MFFADOgxjNlWSNS2
	2AJ0Ps74mWqf/2WbyeAMalG3KzXaHVmJ9IDPBel17gG/RLzT7G9kvm+I2i3RymUK
	lEVWi5nWgoCi/eVDuanRlDCKCs3H7HtLoZX/e622cb1isKrfU18dE/Ge81sCv8lc
	AMbp74rG0TYIlRRqr5AooPmTtyPzK9m1ZhApWgwpb5PepBTSXqiJ/KXj7p9o90zi
	ylJqTG6J9D9a2TqHfEIXpA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921peartt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 19:11:11 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 589I9ell002808;
	Tue, 9 Sep 2025 19:11:10 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010049.outbound.protection.outlook.com [52.101.46.49])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bdgj32x-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 19:11:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zhxl02vn9n9HEMK+d6cplUOZe+fXbd5FsyPSsbkMMMBuQ99UlRlScCHzq0TIpS5HmHE776TzCWToMO7c2mer81yBaXM9P0cYp592PDVRQYwAnioT1XbCoYEA4xMbQoRIPelPlXMRTWW/8ZVZsSqSFXOwD+ynADi9ID2soQ3ILIg52GJwBrFOMsKLrtKTn216dGHsSxAVrqHW5GRZqBuWoDF9jj+cZ0cWetR6aeNw66a5S7NZ5FJzqUBAtBRnq+yE2ZtwPuLZBt5/gnwIbVkvrOeAZHPUtjSHDWRGOI4UjCu8gFyjvDPP0iWVh7nMxZKDch7BaIhSrUJRTW+/Ksm+Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AtGBVs46lMshXtmj7R0O38tuhE6HWKvTTQPsMxKSDiE=;
 b=oTKQBvFS4Anio7ybHg/8LHflxqJO3nMk8ZNMEUGTDp6nDGy8pi/Way0cxD8ihmd7z+9jZLt1f2XottGO7GBLmYwW1uCadBiOn13uze9xhywsLuBUbpglCUdx46rAyV6e8Mdd02ZDaAuCi0MilwRbZBcKeqU71UkrIxn84qaUe0OXfaDwcGSu9Ky6cbLb2kyaKb8QznOwt+CM9Ly7gFgJvXeOXxeHDaeDX/sKihwhRgwmhG3vx792BUKxCybt0MOVUUZ2k2tNjHqJ81FUsEScwe9o5i1ShjYiLFIU60KKOVJYQG19S4CwULWg4UXEq0EXw5qS6QNp0+Xn+49pEDnHBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AtGBVs46lMshXtmj7R0O38tuhE6HWKvTTQPsMxKSDiE=;
 b=dPw4ocBsS0Zivd2T9WlbP9TDSFjzKusDhehK+jLyujDDmIMrKZb7ArYB5tGYYsdSAwCYbmcG9a1qCCqG5ax3QQ/iWwfenYKsuvNG+PJQsYRttbVBbpE0SrDSFFjTIE94H6i47DNkCHQXQUzttlj8w+ZG06m+yXHqMPHKkyoqiNM=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CH3PR10MB6740.namprd10.prod.outlook.com (2603:10b6:610:144::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 19:10:07 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 19:10:07 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v1 7/9] mm: Introduce unmap_desc struct to reduce function arguments
Date: Tue,  9 Sep 2025 15:09:43 -0400
Message-ID: <20250909190945.1030905-8-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0156.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8c::28) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CH3PR10MB6740:EE_
X-MS-Office365-Filtering-Correlation-Id: 80eb0975-5077-4e77-5bfb-08ddefd47d1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7h67FmZ4WQjXXhso0fBwOciS9KDHdYm1KZn5FC79JDtUmQapUbhvR1CUhNsM?=
 =?us-ascii?Q?JqPU/eYKgbi7Z5yum2fQRMezZnbL55FBM2A3k7Y60mUyqKOUlhnAs6rtOXeH?=
 =?us-ascii?Q?hER5dpOnDwWAEt9v5nbZ0mrYzCYa7NPcYbAaPRVqu474yvSzYdGQjWpkX/1M?=
 =?us-ascii?Q?rL/6Fsf+gTj3066Obwf6+lTb85WezTxFsw0T4pFZvI+ikxi6JQrx3su5xnBj?=
 =?us-ascii?Q?zDupZonNhICECIy3tVJpY4uARphqm6Jv3n4GIg0n0zflH8G6lt3P9ORBSFX+?=
 =?us-ascii?Q?AZyyhKYVsCdlb6q0ZhFINmLROgvPsS8JUSdiOCNmUUFhnpbIGmHHU+v5ZMKR?=
 =?us-ascii?Q?ps9rooQXsfq4eEgYCNFNh/pTvNnxC/ZdBrClb2X9Hbknbuj7dsqs5OY0eydx?=
 =?us-ascii?Q?pOIXbDTwN1TSD/r8AcWv1LGojybdhpRag+svXMB7tIWY1+V5syfXoJQuP8s3?=
 =?us-ascii?Q?v3Eont52ZeP7/ENXs7AdZiBb7gEpBDVLYKGTcTeKXyYwj5AlVNbax0Ju3xZD?=
 =?us-ascii?Q?b2xUpkXzP+EETlwyLtWUj120kJ5xu90tydggWJfOALWy83LSSOf2I05r2+xf?=
 =?us-ascii?Q?REKWgXmIh7u7ZEJY4KwGL+U6jfe7VqRqF07dTgxnrgafyoLQcPPepFVNTlJp?=
 =?us-ascii?Q?j9JjNFtlbl/aQ3BtDIRROOoDwOA7KnkQ8MZ+/9hqgdC1nNjrjXnAPAdavldq?=
 =?us-ascii?Q?ONt+jbQKipUje7WgSkGK0AQrobPzqm60AZus+Z40XwUwjRFZ2anLJfaFDx8c?=
 =?us-ascii?Q?nu/mdzSI/8BMeJHcu5oZYS+S8eaQVKRpVGY+ByyUgE0PRYQ/DGSwQXbRLv+h?=
 =?us-ascii?Q?Jwm+g5ZdAkZblamOBxlMm/rky92pYdDd5TZZup1rGiKKcqpy1ZaktXHoWQVA?=
 =?us-ascii?Q?bC33eNVan+s8JZd/7aFGdJP2wfSMv6t1S+68dkqNvnahm4jzuiCU33ACona/?=
 =?us-ascii?Q?MqOlE7cp27KpBsyZKVX40JBDgiCUljlWkqaDvUrFKQVZGVklYXB7W4PIMdEO?=
 =?us-ascii?Q?CZGo7QWFGF4T2EeoAmooyUykvtx4NUF7xL0KmCbPt7V9hlMWdF9ZINs64CiH?=
 =?us-ascii?Q?1IYrV1fjTnP59AYwBHQjqR+uUbiXPl2j5JtHpSkSP4B9/3yr9VjsF6wEq+zp?=
 =?us-ascii?Q?6nHm0q246OKumy3rJPjXJDAE74vTq/szsBT8PSPWyFj1R16cOvzTrzUBVN4i?=
 =?us-ascii?Q?q0MgCh8eIGW7uKOU1EVc/PKYojaxCb0olf3KZhFtSm7vnpxqACUvdHpaMODf?=
 =?us-ascii?Q?jQQbVK4zSg1II4Vk3B5eivGtkylxRORWkX2KDT/uIZOTqvczFKPsHuRjHOgp?=
 =?us-ascii?Q?39HwvdH1ZXLPdDqABO7YL0GzdgqpOEH82mrSR4Lw5CGRTRk6q9KT49SpVOP5?=
 =?us-ascii?Q?EI2Ca/drTj9frfFXCPBV8BOWUxvSwPtYlbjAhCGzJoxYZFV6Rso9Zf21sDVb?=
 =?us-ascii?Q?5CTzH0kVE18=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?V/jj+xLAaCCfkkY5am36xQLJuWt9z/s+5bAVBHu3F6RPYVxRGWU2SkReMSWW?=
 =?us-ascii?Q?1T8bU7Z0iFbgvta+zl54llYsH9TOPmgJgBE7z1xTqJpp64cGx9frCWLpfa0R?=
 =?us-ascii?Q?LWwE/U06m+AvGVpFmKOkvo53Galfb5iKi76Bry0DJIj3A7G7Vae6kOq7VsYY?=
 =?us-ascii?Q?MFDSMRl5MEan4vo6AmAruB7dMfCA2INI8GIT4DrIfIeU0wBzO2kWFYZOBoTV?=
 =?us-ascii?Q?SlAS/c6yk7egXXMh+ACKbaekatnZ0XoG7hbRibgEgWCNVYYQKY7CzwuUorAT?=
 =?us-ascii?Q?6Cr6OqKWNYT3+e388azWk2c7M1yVMLtEcxoiRyDfzADoz+39PmgzD8HbUatq?=
 =?us-ascii?Q?N7KTtjRmq8oU8Mi189pObeX6RBy4LY0W6EYyhVW0ZGTiQXLlkJ0VYJCx1tFK?=
 =?us-ascii?Q?Ihm+oJUcvDew6fpZMGE+P2Imwi/HdnamBM5Lw7iptyi/SrG116L/ukc5X0QX?=
 =?us-ascii?Q?gZ5d7eDRoXNPnaVYxz4fyXCcdDlDeMVN6I5T/pJjsCHQw2lAghLRFCZ44lbu?=
 =?us-ascii?Q?VmKVsmpOs2qr8Za5aHD5oiUtxBuk16sjlnPYqh1BUCdRSHxQW6Z0rmuRjpNC?=
 =?us-ascii?Q?PJ1CfKBFDcbe9l/cFv4KTvLMZh39E4DqKcl8NzYjRn3FGxUhqV3xFFf+O4el?=
 =?us-ascii?Q?o9wQ/LDSiOvcAuz5F05Gwj6YT5fmp74Ogh3oUkUCivqvMLRt5hZNtwzXoPNO?=
 =?us-ascii?Q?kmawwcvtZ0NKdLZsLvzOWINUgPNecrF/zhnKaJiQrpWkH9FN/govnNc3YwTd?=
 =?us-ascii?Q?t2VwY5Yys7bJGiHa6kLriHcIcRz2t3FLAYHfTVUVSclOZVcJQgPir3JiMWQp?=
 =?us-ascii?Q?ftcsjIJmWzCoHifcVIIB1Hj+2y46r571FCrRSjAZ3AkOiDOlmxnlhsFzBNAj?=
 =?us-ascii?Q?F//ywcDI1vUCNZDjKSBXyhJtNhNtNwmuLZ7hYjQj7P4gAw5tBxZrjsqLMwWI?=
 =?us-ascii?Q?gJ3DPHdFKqwhB53HmLxuH067SqV9bpCsONF/2wLs4XNTxA9jyfyA8A2B7Lcp?=
 =?us-ascii?Q?YiM0chC2es+ZnoYSin8iBZs9jqN3Ggag/fLeV8aYlvcILh+qSOLocZYigVzN?=
 =?us-ascii?Q?C4ms/P+Ugh87DNQNHjCsWe/cgAPDRw0VD7kwKUSi+X8woWBVmFn0cY4OR5DX?=
 =?us-ascii?Q?qIPXfJFgDDJISaG7M+Z+S/m3UkfW+pYRV6FkPvpvY4Vt//Lux5FeNe9IuDOz?=
 =?us-ascii?Q?Imgs9e+Ic47fiU6wHcF2WiVDRJTm1X4uWYpJwJfMkLQdTMhfG+N8nMOPhU2n?=
 =?us-ascii?Q?tu/aVo11/gDWgfQ5S3iMthNqPqvWZnCRkvKBuCz6Cn8yQwtewYjo0xfLpKEz?=
 =?us-ascii?Q?waB2+qUQA3MkhAxTBUQ3uRWjQ/8BteJ4xqbMhuYrTDEdvnEQXOyCcRf2PY+s?=
 =?us-ascii?Q?GnKHl8P9PQnSymZN/QbUwowVEqlClAh4XonVn0I5Uta58D9JOT/8MRoZMU+D?=
 =?us-ascii?Q?zIHgr6sZt7lfl6ldhZ8NQ8pNnZb0wqk5sxePRLZ68cIufKTCkCGG9drbHYwL?=
 =?us-ascii?Q?DC0iyXE2/QrojT+uWbx4FK58JnTXwtw/99qCCYfEC1Eo5Qw/Heip9VttKw1n?=
 =?us-ascii?Q?NegOEvRplb5/rdPUqMKHuQON9i/udlzp+iPDinQWpriEx3JdPr2KB6H8gIQ4?=
 =?us-ascii?Q?qw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RseqJjoZQcx2D6UBJsBg73Txi0xtp0odobLLW9Yc/WjR5CM/tbhB1n6iZVPvr/MxYiCE03oC84wE6hzCLfelPhvhquGW4k2Wyd+Ewry0kuCv4vChthIBTYnlY456lw5Dd7SAJ48+gJFPd/FHt6orHY/pTVkhVNmBD3MAOre9yWU+/ONGxQ6ijkTNhOFpafLf6JhSu1AqTnGx5T1kjUe55vvQV3U4r5is5yNOVkhjKsfvR4nd687o720PrgCzrcaw/hODpR3r5KSjF1yUivYyhcOdTUh3r+udYwtXV1jeGUU9O730H9WZxIl74JQW8OZTsRyV5YyKH3pwbK+j3mQLXL43fAz3hmtJa34FNa6qXNGZUoT2aEK+E2ro7LGnnIszHOqyREhb7C+RiPt7aXHQFcIWI+8DVUuQhDYSelRvJXWWdz/AYGmbHGvDEY/CBghApDe5L3iFqbExThh0BjoDVRKdoziEk47Gu/mtOzhTNpB3CHHTQmQKgiCTI6HGz2tzDzUgzIJtvhNk7YHWo7fzFfZ9OoLgVi/fKJPH5qZ7K5V9286mSv4QUrBN6IV466kkVqpDZ2XRP7f+iTG97uNd4P0AtJMlNDW5fIB/yWmezcw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80eb0975-5077-4e77-5bfb-08ddefd47d1c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 19:10:06.9038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iPV5nRz1WNBC7XQa0JU+FsamVjwa2U79WAfC4NDA5B3Qqi4aFv5YpSys8ecjJal82XGYlHxyWt2XGtWpsLKeLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6740
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_03,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509090188
X-Proofpoint-GUID: 7Kza1zoXkRn-n7QMiZuE4YJxoyto7ipX
X-Proofpoint-ORIG-GUID: 7Kza1zoXkRn-n7QMiZuE4YJxoyto7ipX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MiBTYWx0ZWRfX0Q/aOLL0pjXJ
 Stfjb3/umFHBKDuQ7bLLSW5gKIwEYCFanzcvegQ08HKxr66ZF6EUFE97p82RdM9tZk1MgzH4R6z
 39sW2ZeGUp04Y0+0KvLgqpsk3UBMSZNcQm2qbXKKCbLPtKXJq8dmfKfgIp70ubTkM8fZfXguoN7
 4uxbG96brjdtId5HoqkBIXk5oZMasidQBCyNak6xtLsIgyfnP8sru3RtZsF4wHfNGYR0SPLU/nO
 /I6WiLPmm+aUXO5fg1VROlVs0b6GLJuGae/NEOl/ZTuKcXY2lAL5WhmhEm7dDXZtH2u7lISrqXX
 qEbgQmardaNaCALeoMvS8HR0mJRqOlukGg7tvxx9JWhpLXdzQ4+PiRxbbFYkdCQIMZoKK56ozPL
 Z5+wWgAFRZ7HGGa1oFKQ7EsjL9XyyA==
X-Authority-Analysis: v=2.4 cv=b9Oy4sGx c=1 sm=1 tr=0 ts=68c07bcf b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=Aa1wpkB7co8p-06An_UA:9 cc=ntf
 awl=host:12084
X-Stat-Signature: h7on7c19ax7amty4b3f6n4yco8jac3x7
X-Rspam-User: 
X-Rspamd-Queue-Id: 63AC94000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1757445083-144042
X-HE-Meta: U2FsdGVkX19cHuphn9hpwDOzUMQoMY39Gf4h9kLy2EGEQanPYIgM1RRENq0gIc/oSfx+NT9LpAy47y8WR5LAHNkePycQaRRraMWRL7dcqKZmz4+IXOMACVOEYfWA7s/tESOl1B4EZICukgMb9BYflPbAROR+gJow15rGIj6YYx3NHk0JNQooJyRdvCyT6VGIq9vtSy6qw7vR5iGkLLbhebexDlv/rdGVi+5IC4hD4jEPEOM3zzmvYd2eOd2GeKHiGxvNeRX+rOGM+qSK4QkqcYbiGUGGYEdThFwlC2s13suYUTWX8ntmc4NwzBKSWmyUyl1BdPeE9SkNKKKdMtow+EsuOVhyd/DoaBjGiViV7zO1Hnm6brNXVfWmMUt1zFXtF0NxdxmGCdDIw6/ANeTk3r0tbYWehD7QyUflr4icSEfpBM793IveXf51eN3WDxEZ4XH5T7kUjS4/wuK6cxup6Sj8amnclowuuudmAOabc/dAPMJU8oBr+guEGbGutfK8KL5JaRdgG3+ssjz568swZkf00AOTxQ+tDVB7zXVAHJrn9tIqU/DF/YGzwPTaMHyrXEGYGHLkFj13o7pgzCNqGxR8p4CkT7XC1G/FiPJFuU1ushw0LDjnT71u7wu0g4IlpvItAJbzllYCxmdpYFplyZzxjAlMooEulXxxXk8Qog0RF0BRRGElTg6q+hDd6ztSs8mfrja267HlWsTQuK/PiiFgENtEDsvgA1TTLLyZaz6818X1+bu99QNFdUGUSkD73kf0dHjCw4PXZjpEKze1rHR3iBgHtrRPthTnHR03mxULNtUHKjiL0uhzQsjBNNL00CliRX0Q/FRMdPFhdBUF/f8JpTneWk/aBy0+QWCOEoVd4ZICgSXS3X4wth+7upQSpfDNoBr+FcZxdy0aas4JR3+OlLBtROt3SLx00yH/egAH2fxqplTOC60fPO/KGNEZCaKRLSZmqs8fe92hbxx
 I9WWrdLO
 7upmPfZD4hOLPpFifrIgw8UzrxCQZ5/87BgLXasNQgHtfCB82WzX3pibX/YLkYY+F/GnZvnmiHa0s8rLfEK+FgSAbMvJ3pKJK5vQTHEgzWAI+F0rP7RmDt9lSgBjyWGt6tr2u2mHA4zbEgSu+m62qS1x4IzH+r8rqJvdPmt0Z0DVn+QUzxhESGRbPnpQWcaVnkXwYhq69qNyk6oXUqvUEzgQeLGfJ121e8HiNAXkJFraKzTxNEx4YM8TnWqRcJ39d7cwGTgb1zJ5u1agBXblaVSNjHKv5dFtW1VfgbW4e9GX5oWA7kiQEo2G7Eh9oCk05JaUsR9afrO2YvucTS6TCux9MnVUb/5VgKcQFBHBd8oj68z5+UyXjqQ0OX1IrU1lcLVl7WjLqkBBHD8BT7b0scExNUlFKUQs9zaFsB1i6OHx/eDzxC7Vedif78iD2M/uaGSpbESopoC2I+qMaPC+58KKGlx17bqgk99NFpmrmBHv3Kf8r+1zLnmA6u8OLMbBRuhb5yu6yVL95hz49Z6IOr0tStOMJCZEDVHHTTlI8Uzxup0Hmpt+J4KiyAl4I/mjwoHJcWg/SOWLrwuzkw2fvbIstJ+qXRmoDyUhHbvSzzOSaxbLKRK5y8PI11qHMqmlaY0EHLrdWpVQcvQ3T8yYcX4doTSBwIhQVir7E7e2NUBhCLaFeHEgwoZkoFboxwSkQJyvf7At75BWY9Wu1EaBucsZEW3TATLKiNox2QkohBUo3zur0Dpdc6KMipQEwXiPfKFN7bEq6m0+KusP8Xo406ArpvU7nykuhHbbFlDY0mjUhiLTddmOVIl46rsauEdjheNZ9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The unmap_region code uses a number of arguments that could use better
documentation.  With the addition of a descriptor for unmap (called
unmap_desc), the arguments can be more self-documenting and increase the
descriptions within the declaration.

No functional change intended

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/mmap.c | 12 ++++++++----
 mm/vma.c  | 27 ++++++++++++---------------
 mm/vma.h  | 35 ++++++++++++++++++++++++++++++++---
 3 files changed, 52 insertions(+), 22 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index aa4770b8d7f1e..5c9bd3f20e53f 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1883,11 +1883,15 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 		if (max) {
 			vma_iter_set(&vmi, 0);
 			tmp = vma_next(&vmi);
+			UNMAP_REGION(unmap, &vmi, /* first vma = */ tmp,
+				     /* min vma addr = */ 0,
+				     /* max vma addr = */ max,
+				     /* prev = */ NULL, /* next = */ NULL);
+
+			/* Don't free the pgtables higher than the failure */
+			unmap.tree_max = max;
 			flush_cache_mm(mm);
-			unmap_region(&vmi.mas, /* vma = */ tmp,
-				     /*vma_min = */ 0, /* vma_max = */ max,
-				     /* pg_max = */ max, /* prev = */ NULL,
-				     /* next = */ NULL);
+			unmap_region(&unmap);
 			charge = tear_down_vmas(mm, &vmi, tmp, max);
 			vm_unacct_memory(charge);
 		}
diff --git a/mm/vma.c b/mm/vma.c
index 4c850ffd83a4b..c92384975cbb2 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -473,22 +473,20 @@ void remove_vma(struct vm_area_struct *vma)
  *
  * Called with the mm semaphore held.
  */
-void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
-		unsigned long vma_min, unsigned long vma_max, unsigned long pg_max,
-		struct vm_area_struct *prev, struct vm_area_struct *next)
+void unmap_region(struct unmap_desc *desc)
 {
-	struct mm_struct *mm = vma->vm_mm;
+	struct mm_struct *mm = desc->first->vm_mm;
+	struct ma_state *mas = desc->mas;
 	struct mmu_gather tlb;
 
 	tlb_gather_mmu(&tlb, mm);
 	update_hiwater_rss(mm);
-	unmap_vmas(&tlb, mas, vma, vma_min, vma_max, vma_max,
-		   /* mm_wr_locked = */ true);
-	mas_set(mas, vma->vm_end);
-	free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
-		      next ? next->vm_start : USER_PGTABLES_CEILING,
-		      pg_max,
-		      /* mm_wr_locked = */ true);
+	unmap_vmas(&tlb, mas, desc->first, desc->vma_min, desc->vma_max,
+		   desc->vma_max, desc->mm_wr_locked);
+	mas_set(mas, desc->tree_reset);
+	free_pgtables(&tlb, mas, desc->first, desc->first_pgaddr,
+		      desc->last_pgaddr, desc->tree_max,
+		      desc->mm_wr_locked);
 	tlb_finish_mmu(&tlb);
 }
 
@@ -2414,15 +2412,14 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 
 	error = mmap_file(vma->vm_file, vma);
 	if (error) {
+		UNMAP_REGION(unmap, vmi, vma, vma->vm_start, vma->vm_end,
+			     map->prev, map->next);
 		fput(vma->vm_file);
 		vma->vm_file = NULL;
 
 		vma_iter_set(vmi, vma->vm_end);
 		/* Undo any partial mapping done by a device driver. */
-		unmap_region(&vmi->mas, vma, vma->vm_start, vma->vm_end,
-			     map->next ? map->next->vm_start : USER_PGTABLES_CEILING,
-			     map->prev, map->next);
-
+		unmap_region(&unmap);
 		return error;
 	}
 
diff --git a/mm/vma.h b/mm/vma.h
index b0ebc81d5862e..4edd5d26ffcfc 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -152,6 +152,37 @@ struct vma_merge_struct {
 
 };
 
+struct unmap_desc {
+	struct  ma_state *mas;        /* the maple state point to the first vma */
+	struct vm_area_struct *first; /* The first vma */
+	unsigned long first_pgaddr;   /* The first pagetable address to free */
+	unsigned long last_pgaddr;    /* The last pagetable address to free */
+	unsigned long vma_min;        /* The min vma address */
+	unsigned long vma_max;        /* The max vma address */
+	unsigned long tree_max;       /* Maximum for the vma tree search */
+	unsigned long tree_reset;     /* Where to reset the vma tree walk */
+	bool mm_wr_locked;            /* If the mmap write lock is held */
+};
+
+#define UNMAP_REGION(name, _vmi, _vma, _vma_min, _vma_max, _prev, _next)      \
+	struct unmap_desc name = {                                          \
+		.mas = &(_vmi)->mas,                                          \
+		.first = _vma,                                                \
+		.first_pgaddr = _prev ?                                       \
+			((struct vm_area_struct *)_prev)->vm_end :            \
+			FIRST_USER_ADDRESS,                                   \
+		.last_pgaddr = _next ?                                        \
+			((struct vm_area_struct *)_next)->vm_start :          \
+			USER_PGTABLES_CEILING,                                \
+		.vma_min = _vma_min,                                          \
+		.vma_max = _vma_max,                                          \
+		.tree_max = _next ?                                           \
+			((struct vm_area_struct *)_next)->vm_start :          \
+			USER_PGTABLES_CEILING,                                \
+		.tree_reset = _vma->vm_end,                                   \
+		.mm_wr_locked = true,                                         \
+	}
+
 static inline bool vmg_nomem(struct vma_merge_struct *vmg)
 {
 	return vmg->state == VMA_MERGE_ERROR_NOMEM;
@@ -260,9 +291,7 @@ int do_vmi_munmap(struct vma_iterator *vmi, struct mm_struct *mm,
 
 void remove_vma(struct vm_area_struct *vma);
 
-void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
-		unsigned long min, unsigned long max, unsigned long pg_max,
-		struct vm_area_struct *prev, struct vm_area_struct *next);
+void unmap_region(struct unmap_desc *desc);
 
 /* We are about to modify the VMA's flags. */
 __must_check struct vm_area_struct
-- 
2.47.2


