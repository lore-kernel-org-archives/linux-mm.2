Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39C17C44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:51:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A16756B00BA; Wed, 21 Jan 2026 11:51:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C1366B00BC; Wed, 21 Jan 2026 11:51:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 881BD6B00BD; Wed, 21 Jan 2026 11:51:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 711E26B00BA
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:51:38 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F1FBA13BB0D
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:51:37 +0000 (UTC)
X-FDA: 84356562234.30.96987C5
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7EE3CC0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:51:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="E/27uy5A";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=la1auiyh;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LJr4um1tnkQkc+xTre/hZgLmYo+p+SGwk9IuPkNt70M=;
	b=z+gQGoYbITegDK7dwyCxVYMdXt+ZbwgMaNa4D3phUm86OzYxWrQGqu3eTgYjjfpJXZAloM
	6Bdeck7wJjHEnZupw771Qf/ONEDAzCdg1UlagH/3MDviUWbkXtPWWvDUlVmbr4WANoLoRh
	x69UFQTgYo4bwaznd3ip8tnshRI97h4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014294; a=rsa-sha256;
	cv=pass;
	b=CjUfvmPsXuxu8FhSu3UU4ni9WwH6xMMW7vRG9H2HuwIaPt3P0apiWuG0+WXqULNIGPQwot
	KXiTVJfZNAXT1/E2OOwonRDT4NlAUIPSv/Krjf+NXOovZ+r7UbCnHCtkQjxduCLmfBWERY
	4RhtJmYPsI/krRI9W1L0gN45YBBUHlg=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="E/27uy5A";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=la1auiyh;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LDLNe63029082;
	Wed, 21 Jan 2026 16:51:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=LJr4um1tnkQkc+xTre/hZgLmYo+p+SGwk9IuPkNt70M=; b=
	E/27uy5AZC9C6dgadu35jWB4NoGCDHtPaMkFLUMHwnRuJ+Hr3ynsjEeWd5OJBcwN
	ghrFH5CqSWrJDSdULN51rTUcgJ3FF5phfFQMAm5Tjwa6Zp81LBNVv1uwwjO/uEW8
	RQ/DdpFs7OZ+s6eVE9YwjCKm+qNVfUCSTa55bvLCk+svLguUgvGHRJc+cqF7A72M
	zzIWlJmZBnuJIa0yRpgHnC2G47LO3sRf3Ty/RIPnDwvPhlBSWoJozJmpgoFccI4I
	mJalseI9H7eqLdnQfeXNMK4S3EgaDVHXURkEG7/034rhDZU7sr3z5uCMeggvjDLA
	rIFOc11r+s4pHn1n1wQ47Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br10vx87q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:51:14 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LGWL9i019002;
	Wed, 21 Jan 2026 16:51:13 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012047.outbound.protection.outlook.com [40.107.209.47])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bsyrsbnp4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:51:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oJIeAHH+Ah1ed0z91Vc5ae+0NCubpUUL09+pINvQWjlMVW4BKw3fRVWbzBURcdMQb/JQ5kXH3TbhLL70kWv3UDzZifrD3r4gr704jhKQJ89ZKmG/s/irrj7diIxax9QUl2SXU6WaOAs2XzC7m4aN9tUfWTfULNJqi3itA7qvWuFn96K/zStBPsKxrEZJwlbnRajvqPX8pMnt14ZuELzE8VCNp1VRD5tw1bA4oA0NMdH4vo3Bc/Lhs0RPsjxZKwetAno7nYxxPERcAWE9PLS6zpf0mETSMkYZ/yFfRUzeUJYNP3iISgWocdfTzDiWdf+Lh1EWR6Iijcydq6hvoc745A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LJr4um1tnkQkc+xTre/hZgLmYo+p+SGwk9IuPkNt70M=;
 b=jI/MMD6TcA4x0w9XEmuRVixQhdp7jfi0m2+zxqLAAp0QetH6w5WHXbtqvcQcGl6mc0v/ryoxcvrTwyWbxVgCef74wKslGcmWSMBnEjgHMIzZmVvCmLWF1BmMzmZCEjiuAtaTsNfKSVLJK2u+E8o5DLmy7yiPkf+3AsO91LqAB+F6XtNTpyDusB7ILjQair6B84D61/YJt3MVuSkmuVqeL0nBZ+q5Vg0PVDaFC0Ftj2OAOLDfXK4NfeRBvcod+QRchV1CSxdt9kyVeIiL66NIi3dVeM3eaaaZLrfV7PRpQWpGNozT54z3Sbbfu5EmdM9EKkleHKxQbvtK2847T9gPJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LJr4um1tnkQkc+xTre/hZgLmYo+p+SGwk9IuPkNt70M=;
 b=la1auiyhwyobuUEBj1gd9Lym8LvRirkHxLukI6+7eYxxOkFoi9X5k/3PfQ+tWT18ozX29mEBF0HhvpJomUstskUPEESeB/iqJT0QELEzSTQNciAlTvamtoEgQYytJnE4ggG9QM3RE6pbOlEIheDQfiTaTgAGLreEAR5WFpHUcWc=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SJ0PR10MB4414.namprd10.prod.outlook.com (2603:10b6:a03:2d0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Wed, 21 Jan
 2026 16:51:09 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:51:09 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Suren Baghdasaryan <surenb@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, shikemeng@huaweicloud.com,
        kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
        baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v3 11/11] mm: Use unmap_desc struct for freeing page tables.
Date: Wed, 21 Jan 2026 11:49:46 -0500
Message-ID: <20260121164946.2093480-12-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164946.2093480-1-Liam.Howlett@oracle.com>
References: <20260121164946.2093480-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0310.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10e::28) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SJ0PR10MB4414:EE_
X-MS-Office365-Filtering-Correlation-Id: edb6f0d3-76c6-4b9c-a27d-08de590d46b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QW6fIAswpiW5GTyCL9nzsbNiGs3mQFZBdJCs2nDDqxK/Z/ilp9qiNlMsdPwd?=
 =?us-ascii?Q?hUy5VlpVC8PMgBRvMxr/FZeaUzMN9VS4IxSt0ovABAWm6gFSxdi/c6MfUzxk?=
 =?us-ascii?Q?VEkGMymsLWPTNwmZURsw1JI7Glu4og0ytA9o9GOPYMzpfpa06CCu0Z7bAGzX?=
 =?us-ascii?Q?HEU9dqTpT4en3tX+plsHvWMQxIzKJlTku2gLw1lpjGr1SVXj+nykmHLq6j8G?=
 =?us-ascii?Q?iCj3TCk0WuTUjFSljr+xoMrAdsb6/VG1ZijlfnHPoEWdjjRNzZI4Kiokjk+B?=
 =?us-ascii?Q?n8Fv0B2EX/ZYvirO8cHTOXHvPrXkQj8GhRImebVgRwzRT/Ok2ERcIlYmd9+K?=
 =?us-ascii?Q?8OdI/VAaq+7SF6Rim3oDX2wi52WpSvBjehCwH0Y+/6zvpdeebok3578r6iLD?=
 =?us-ascii?Q?BkbPyBtp2sndfzY4kfuP0XYMrW+TYy4kOrBRt4tH/rSBkN2j0JJaU8AA4wj7?=
 =?us-ascii?Q?AjfTYCTNEAYIooUCo/uVTe17dkiRSX544wu56tpaVELRJ2BBd3tLqm5URN56?=
 =?us-ascii?Q?++62+Yi6/pk1/Z4MUUN02JsW+3qiNW5ViQeLW2KwdhFntyWSEx7dWczABA0O?=
 =?us-ascii?Q?3xVAcaPaiGkKJhxpqS/AqggqpaxfIacfBGHspto5y3TQp0A54PhwSwEI8gg1?=
 =?us-ascii?Q?VmlQGwPXMCK2nCwWWUKZzQLcz3RwDV87bkOmvopMC8dy4dz6ozI2+LQGGA9Z?=
 =?us-ascii?Q?sRAbkdv8IPU5E2yEic1dcmDPy5AmwZpOtwfGi7Ia0Vif3LlLznwp/DgFqGkH?=
 =?us-ascii?Q?jMyw7xohlZ33yabkfy7fEEUwRMavrnfazCDLnPJ0yuJ8f48aUNq1GjiVDeB9?=
 =?us-ascii?Q?ll+lNTNTquMfXXn80Q5wqVL9FG+vLbC10UYtpiEMTSEiXVIg1VnKx+ztGRS9?=
 =?us-ascii?Q?GnIg6N/34npYWFzqjJylGaNL6RSktSfmoNb8bzNFx2VEWGPPLG/FvpWx2bs+?=
 =?us-ascii?Q?6PZ37tDaoQ2jOfDwcASpYO9IsrsWTw/4N25asFcJfAseMz7J0EVN2cEwqhSR?=
 =?us-ascii?Q?/Abh1/iPjIovHFfgz3U5BHRAaXupkVG1EIN+/QrKBhGLpM2y3rqbtj2nPZCk?=
 =?us-ascii?Q?oSp7klQFto1RcTaDNZBNCmKDvIf71VWTktyGLmGNnykmOOjT5kPxQi+oCEuF?=
 =?us-ascii?Q?qdSVwdRMfSOTWP04Wp0ovWU1M2EHDdpwjVQN/EBU/wptGQqd38m9YwtdtQW1?=
 =?us-ascii?Q?cuFbGN1naxDrZDTTj9zqQQFBz0YbGAh1t+NBf6RSe6NvUJA37f3cDB9Vpnwu?=
 =?us-ascii?Q?gnpzqdYWyfCVh/qxZBDxWW43iuVkMqujqfgnZvBSPGqqJ/8ri+W+uqNDyn+T?=
 =?us-ascii?Q?s0w6Vm5VUI/nNaEDjfmc4O+jPgSjXlmedw2EgS83TlSDYxll9x26aCUJVk91?=
 =?us-ascii?Q?TyQC0k+G0WlzpXaJAcMNaEsO3DXWsWdnRjUxfQip13u5kXneLa4BxaL07oyC?=
 =?us-ascii?Q?7Z1NBTwLpWFf8YdfQb7aoOpPmBdBSaH/kV1kFlyx9wZetW4/IN13L5+qBKZt?=
 =?us-ascii?Q?8ADESuNgp4V9kWa+aB2G9YA5qTA6sQPk9AlDan+4itf0xYsFng1qTiGXwCBI?=
 =?us-ascii?Q?RXGaY7bNN2ZhdhFt5Yo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sHa56/uaSMEhTSCGF7JKq+bkhW9nb9qMJqzEizk6pfN/sqxrhu8EWDpk5VHU?=
 =?us-ascii?Q?tJySM783/OxAufihxBNhu8YaqSVlX2VypVK9bFiaZlhDUydB6iz4+Xpsq0qJ?=
 =?us-ascii?Q?HZk3J45AiUlZZs5rwoHmA0X3MnMzISLO+op76cLI4SmCrQvjDhnjwn1cQeKv?=
 =?us-ascii?Q?OrLSECD1F1nH/EgVZJstHna6xQ5NOSehxdHfw26viCd0lpv0rBDWF0NylKfl?=
 =?us-ascii?Q?pj4yuBhRcNHwLFluyjq8/yO5kc0MrwACJ6Ag2c8WEekfFgKFVEkK/1n7pcJ9?=
 =?us-ascii?Q?hNFtwhB0bJU39D/9jZX/h6JP0QxeWEAcxG72YHA2D6ojzT5gwNJ2lAJ4tYQe?=
 =?us-ascii?Q?Miw0pOKPu6cE4/Zm9iG3wmFe3dxm/EICCV1TUAVIrvrhR/c9yvbuBitKD3Jn?=
 =?us-ascii?Q?c0ISU34RpQgC1nuhCKvZAUyXP4eHtx8LM2c6WDQW1/mKGgx2QOQ4mBKVgJ67?=
 =?us-ascii?Q?1XVC9D/gYbsbh6ot0CW5QR2A3IKF9gqrK0Xha+ajaxfKupX/bgFgNXAmMkZP?=
 =?us-ascii?Q?WAkZ2bGPjRmf5oly5KazCYAjFBeBDmhJty4B9ooIBso4RH1YgF67vYrLvC5T?=
 =?us-ascii?Q?tvHMmY+uHNaQbresjM3Cl1zy5gm7ZSKn9RosQgsqt8vjjYHy5LseIcanrQM7?=
 =?us-ascii?Q?M/qtVMy0b3dq9+2BVQdG1nSC1Tm5WhXcD8UWzEBNv/T1wyqX5C19sqAl78Vf?=
 =?us-ascii?Q?9K4YjIUCRQbF97e7jO8rGaBmr+NU72SJamche4SB+m6xTaTgYJYMaLvtq72G?=
 =?us-ascii?Q?k4GWIqvZOgml+/PWV9kNchIy8QqG3f4DGzB6DLVifYvW2X5o8tsbOYW5nb3Z?=
 =?us-ascii?Q?w75bcdWJv5Y/YYeV+C5+AmYccEVDMbTM5311eNcb7/+Ludw4gjaLA2NvrUKl?=
 =?us-ascii?Q?BvmhstJ3tV/Ae6ED036uyTE8ajo/fX1rNIr2LH+RuJxg7hObt0MVa/0SRSWY?=
 =?us-ascii?Q?3h/q1x1kKS1m7hV24vDI34V9J3YGaUVD3AoEB/rxHqhZAy5XIDh7CLcmkE1y?=
 =?us-ascii?Q?LkzMvb/qp6JqCF6UwtggLm2DMvXqWBJaVb0/4EqJdWAsD+u4S0hAr7iyXpIt?=
 =?us-ascii?Q?bxzsl43Qq+bA3Qh+C+GtbAPhesY43vU48ESI9R5VTNFiSa0zfTLZ0zVFZ+rE?=
 =?us-ascii?Q?1X4j5N+G9Sy+Q72eL3/sbGo1rJkTAR81lvMsrxGLMNFKGFOijq0KvBz2m6bH?=
 =?us-ascii?Q?7rUTK03xeOjpFDSbUJd3jF8kbIzAR/5EDDlrHVDnmj7s/Hfb2SwCrk25d7rM?=
 =?us-ascii?Q?fN4fs8iB5WaVB+vjKASGAEq62765YesyCJnqeXkHZriYsUT4JVD/TUGGuAME?=
 =?us-ascii?Q?8i71w8BLoBGQjynGWeuNyijvJl5R57pqCISGsgIh2fqiHQSnwJ6HV+H1y7Mx?=
 =?us-ascii?Q?vTDrRLETeL/J/HaZjw+Ampj9qjs4E6Asj94+xyFGHgQYtFiQoRDwFVf1Gmvt?=
 =?us-ascii?Q?h/tXbBStILIJRPlmiHgXmSnvESGRIhJKNDlu6rRIHCpNFyWbLAKPfvzkdvo8?=
 =?us-ascii?Q?OwJw9Y3WEgrXdB8YmMbUi6gisLQ4+u0K3989VA1HjeO2D5Koj3Xy1AadYJyO?=
 =?us-ascii?Q?3lkkFTuQghQva+xMFQb/r3bHxnY3EcsoDC6JMP5NpPAvPRde/eBV91pZ5Fda?=
 =?us-ascii?Q?b0bi8Zk0ZurRF7POTdxHBW4KhfFB5K0hvK2pyNcej+7ZUnQcx/rtRlmmwDd6?=
 =?us-ascii?Q?cbGLILMcGzSc+1SW71gm6VcY796de+Ns4QaCHB81IDtCFGacckcNcc2wkKYU?=
 =?us-ascii?Q?waYyoPnHcQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AjEQ7zBUmoePFK+FVgcUlys0zl/Osq3meoADILepYEWlWEYaQ9ABJjNU3AXLNqbnlw6wSJ00b0MBzae2ot99IEUOyDw0XG47vzsMBJ9ZD2q8LwUUXvcTVg7RG/iKPoV593cWKmPzj161XGwd04NWu+kMa5XmKWpR6B3wp7mNyDN0FTRAIUQgoGW+EGTBbMu/To2BGlrsCXzM/HPblxyQ2oaIxXD6mgN9abw/RlozfhKZGlBwC2YemPHpDjCakC5aMpbrHlRDAksFI6j3pUKL5b9v5v+mo4lnOmt+rptuvnfsvsDXcCiLHc3e9P5n+POlsUiFeSZ3NHBjmMkrnIZIapTErKv1bYjTTTyMuugFrUbCp58smIOV28zO7jl//JmFQ9+IFa/8IkJrSH+/vdFAttllvlx5DBlYre5zvy/GqyloxIJh5zn+b5PQiGQPp6THovrvoAbE+CMHVV0svOFeIxNZGs9lHoTpYatu9kgV+f4PAR87isXm4b8BtqJO9EKq4Zv5bGfJaPK9yeulKTd4dmTrarM9d6s5sBFnZaL1VnPlIoFvTXu25sbjNPWosiQvw66o6/vIiT9nAwk9zoyenYzu3In18SJ+yoYkgxNtEoM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edb6f0d3-76c6-4b9c-a27d-08de590d46b2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:51:08.9838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zpUDm4bUWU9uB+i4JE9pC9+1B9ssT9iUUM+g7OkQQX9RA0msZuUQOlZb1OJPmEScBBCLWOm++iKU5dsi8ehUTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4414
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601210142
X-Authority-Analysis: v=2.4 cv=H4nWAuYi c=1 sm=1 tr=0 ts=69710403 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8
 a=vROGCtjlC6yg46rs05EA:9 cc=ntf awl=host:12104
X-Proofpoint-GUID: v05dsqwQXjrJlLeqm9bBh1_1v3_kobYV
X-Proofpoint-ORIG-GUID: v05dsqwQXjrJlLeqm9bBh1_1v3_kobYV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MiBTYWx0ZWRfX3HgZjmHUSGEa
 GKX2iqfTsvH8UJDKljarFpikBSNHjqM10o3JOry8jkSqTzN+2f4g/C7e1VDw5ydlrVmdyWbA7mJ
 jD7IH0LNC2UlPwDXDy1NZsYlF03NC63lZMIZbH6ImDY2t4XCKMyXeek7ibhghaEXEFmBMEoWIP2
 jPjDOo/m0PPHcV4L9VwTaCRZiG2ZdTyhho+nfuyNYati4cnJFYlXhO1sgDjVQNWoqaReQfQbOFc
 ccsBAMTxC7+lMWsGcgjrNt/ENSlj5uuuFrFzrGNNotBSu8Ub9dhgrTgbg3VvEupzibi0FHLnGn9
 rriB2RF/ZVnxMp6nY7elBJFtO9LfBrjiyzqlqp/RoTnuAKlSDkt2zZe0i54W2iu1BoK/vIX2RWE
 /fgw568G3ny0LvlbjIhj3OktJ1Y0hnCFBgz/p6MA9I9EAC09LfTtxrqRedBozgzBdAUGu7CjILC
 Z4ucfcxSyyJUarvXIIyBABM4ViyUpt7yIgerFCvQ=
X-Rspamd-Queue-Id: 7EE3CC0005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: fu7nroqy9myjkjtiwptuwjdwy76b4psj
X-HE-Tag: 1769014294-484984
X-HE-Meta: U2FsdGVkX1+gOfIR/R5tdtO9kDBGEi/Wb1csitjmZEPpkET9W1sUQm7aUz0qM0MNMZMJQiDguYIfTQPqnr8z30BdnLrz71t0THpVYp+siUe2ZV63QftktQmrXZLGxfnXKXS9lrKhrDYe1MRxZHExLGOOFUUlGkibiRQIqADfnM6Eyq1UPddNnnRQ708y1WKfiYDbRwb9k3t+yr+NE6HVty+JtMUn/vBi11UY19+2pkqnzSgvCqSjLXRPMoPUMXRc/OdgpSvPLUUKLo1t+is4iRuUM2WvxGZkJDfko3UipZRuMbzGc80B51IDyDDJSoPTrE9mtM+gqWrgjgswHMxGG2H+e1r3gC8kCChSqgdfdcM5vWEC/HEsnhxNAtm6sZQp1D55WCYHXw+F67x6wqv5uBaWZlsNYPuaKqh8nW5W2ZN4tDRcpzdBeiKA13m8R7sMYLpgoJ8eqAksEn9Ogx4kcbEM+9keGM73o6rLtFurX8gZtj7+j8POjGxQme30qL2i5mFLLh9L8LUSFurKegXrVBDmwxCdE49Evq8YkxRz/oNm/POHVzZseiqaWCMLv8IutZXv4MJvPwQ/fCnzgPjnzTtBXvQSmA6n2FF6J24vN1pcxUgVLA2h1GlhrxHmD4rRok+fsKfMQaElDxgKtj8u4vJ7UV9vjYgUMNUxIg+CwdSHNFtigyBcsrGL/3vGx/mc4qSJ7brMrf0r/5KgC4MYo0TWV5pAWwx4JSJm91bM2wR3KQPZ+6YzN3lRtwnfVfV6z3xmmUCZmyflLIcB92InnhNBxbI8tpL0GKKapu/8PKcs2LaAFKj7mDNGHvt/+vLitZLS147OyM9XnqcIRjtjyDsM3k8JKIGbsAQ2UcpGRbHyjwKzvQhhbzwcdv97oVkHpBuwlVqv028/8ZooskAKUIicB1wsX4VEbhIIq9cK92t5o6bUFrKc6HHwA5mxgeOjRyNY9yzyId2luo7FXHx
 40Jfc7OC
 Hz/9eJGFYO91WT+AnQHivT4AC6uMZ579dOdkdjIOzsGdVUVQNIR7YO3o+K85lMIJKyl6v6xhSsnnyjvi8VfQrZCHwURmRyDW54K6jetLkmMp4yJdsVy22DeEAy1A757fNZaVstI/rl5eof1wqCJqQNVnzidh1v/yL8I/UIh2OpPz8kDM5nr6COrLnoCDNZO8CsEdfdNrdeN6WVoERqjbOjwGaKa83RRflXjdSdwb+POB2u48Bt0JT1W2z0nXNy/MnHMayWKFdvd6FaUOCNe5c1TTwVA6Zar0ysnpJhbJ144V5R5wpsV8JqUOp/2KeU9108kYEPEtoXN3dONHrbvK6CPSQs8WQdqeTeX8zk4wRT8zGUB650pTd4cEUoDgx6b4x07WPtlZxsnXSdkD/P4WZ5pz1jouvquyi0G7kjgeJsUCpCCZH+iTPCdNMfjaFKUSOcqOqELDPMwJedix/UOraPVih2+1Qq1XHc2eAvgHncecSljZ4JUpz9ANkNl1YUUSMtwre0Drg3VCVrBrSiqma9AmNbNOdd9Hydt9tRq/a/SCgEeynsJeN34Lyvvkh+xL52vqE1nPnxPFR01Aca0yNFU2CklSygv+ns9oPV0tcUJPuUPwlNnEfHWKPkrmSWgeBtKHQfiKe3qrpu4xHvSGgeek4kb6Y1SrIYR4cLSQPzt4qhFvAHzMJzaJ6G2Z44FV7hUJkzbXGfIM+eCn3Kvg6RPnDEFK5YX2dAFCE+m3kakSKOpnPrAe0pKYyRg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pass through the unmap_desc to free_pgtables() because it almost has
everything necessary and is already on the stack.

Updates testing code as necessary.

No functional changes intended.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/internal.h                    |  5 +----
 mm/memory.c                      | 37 ++++++++++++++------------------
 mm/mmap.c                        |  6 +++---
 mm/vma.c                         |  6 ++----
 tools/testing/vma/vma_internal.h |  7 +++---
 5 files changed, 25 insertions(+), 36 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 25a17eea550b8..1cad630f0dcef 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -512,10 +512,7 @@ bool __folio_end_writeback(struct folio *folio);
 void deactivate_file_folio(struct folio *folio);
 void folio_activate(struct folio *folio);
 
-void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
-		   struct vm_area_struct *vma, unsigned long pg_start,
-		   unsigned long pg_end, unsigned long vma_end,
-		   bool mm_wr_locked);
+void free_pgtables(struct mmu_gather *tlb, struct unmap_desc *desc);
 
 void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
 
diff --git a/mm/memory.c b/mm/memory.c
index 6fd6decc139e9..16b25eff19251 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -373,12 +373,7 @@ void free_pgd_range(struct mmu_gather *tlb,
 /**
  * free_pgtables() - Free a range of page tables
  * @tlb: The mmu gather
- * @mas: The maple state
- * @vma: The first vma
- * @pg_start: The lowest page table address (floor)
- * @pg_end: The highest page table address (ceiling)
- * @vma_end: The highest vma tree search address
- * @mm_wr_locked: boolean indicating if the mm is write locked
+ * @unmap: The unmap_desc
  *
  * Note: pg_start and pg_end are provided to indicate the absolute range of the
  * page tables that should be removed.  This can differ from the vma mappings on
@@ -388,21 +383,21 @@ void free_pgd_range(struct mmu_gather *tlb,
  * The vma_end differs from the pg_end when a dup_mmap() failed and the tree has
  * unrelated data to the mm_struct being torn down.
  */
-void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
-		   struct vm_area_struct *vma, unsigned long pg_start,
-		   unsigned long pg_end, unsigned long vma_end,
-		   bool mm_wr_locked)
+void free_pgtables(struct mmu_gather *tlb, struct unmap_desc *unmap)
 {
 	struct unlink_vma_file_batch vb;
+	struct ma_state *mas = unmap->mas;
+	struct vm_area_struct *vma = unmap->first;
 
 	/*
 	 * Note: USER_PGTABLES_CEILING may be passed as the value of pg_end and
-	 * may be 0.  Underflow is expected in this case.  Otherwise the
-	 * pagetable end is exclusive.
-	 * vma_end is exclusive.
-	 * The last vma address should never be larger than the pagetable end.
+	 * may be 0.  The underflow here is fine and expected.
+	 * The vma_end is exclusive, which is fine until we use the mas_ instead
+	 * of the vma iterators.
+	 * For freeing the page tables to make sense, the vma_end must be larger
+	 * than the pg_end, so check that after the potential underflow.
 	 */
-	WARN_ON_ONCE(vma_end - 1 > pg_end - 1);
+	WARN_ON_ONCE(unmap->vma_end - 1 > unmap->pg_end - 1);
 
 	tlb_free_vmas(tlb);
 
@@ -410,13 +405,13 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
 		unsigned long addr = vma->vm_start;
 		struct vm_area_struct *next;
 
-		next = mas_find(mas, vma_end - 1);
+		next = mas_find(mas, unmap->tree_end - 1);
 
 		/*
 		 * Hide vma from rmap and truncate_pagecache before freeing
 		 * pgtables
 		 */
-		if (mm_wr_locked)
+		if (unmap->mm_wr_locked)
 			vma_start_write(vma);
 		unlink_anon_vmas(vma);
 
@@ -428,16 +423,16 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
 		 */
 		while (next && next->vm_start <= vma->vm_end + PMD_SIZE) {
 			vma = next;
-			next = mas_find(mas, vma_end - 1);
-			if (mm_wr_locked)
+			next = mas_find(mas, unmap->tree_end - 1);
+			if (unmap->mm_wr_locked)
 				vma_start_write(vma);
 			unlink_anon_vmas(vma);
 			unlink_file_vma_batch_add(&vb, vma);
 		}
 		unlink_file_vma_batch_final(&vb);
 
-		free_pgd_range(tlb, addr, vma->vm_end,
-			pg_start, next ? next->vm_start : pg_end);
+		free_pgd_range(tlb, addr, vma->vm_end, unmap->pg_start,
+			       next ? next->vm_start : unmap->pg_end);
 		vma = next;
 	} while (vma);
 }
diff --git a/mm/mmap.c b/mm/mmap.c
index 042b6b4b6ab86..8771b276d63db 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1307,10 +1307,10 @@ void exit_mmap(struct mm_struct *mm)
 	 */
 	mm_flags_set(MMF_OOM_SKIP, mm);
 	mmap_write_lock(mm);
+	unmap.mm_wr_locked = true;
 	mt_clear_in_rcu(&mm->mm_mt);
-	vma_iter_set(&vmi, vma->vm_end);
-	free_pgtables(&tlb, &vmi.mas, vma, FIRST_USER_ADDRESS,
-		      USER_PGTABLES_CEILING, USER_PGTABLES_CEILING, true);
+	vma_iter_set(&vmi, unmap.tree_reset);
+	free_pgtables(&tlb, &unmap);
 	tlb_finish_mmu(&tlb);
 
 	/*
diff --git a/mm/vma.c b/mm/vma.c
index 876d2db5329dd..f352d5c722126 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -475,15 +475,13 @@ void remove_vma(struct vm_area_struct *vma)
 void unmap_region(struct unmap_desc *unmap)
 {
 	struct mm_struct *mm = unmap->first->vm_mm;
-	struct ma_state *mas = unmap->mas;
 	struct mmu_gather tlb;
 
 	tlb_gather_mmu(&tlb, mm);
 	update_hiwater_rss(mm);
 	unmap_vmas(&tlb, unmap);
-	mas_set(mas, unmap->tree_reset);
-	free_pgtables(&tlb, mas, unmap->first, unmap->pg_start, unmap->pg_end,
-		      unmap->tree_end, unmap->mm_wr_locked);
+	mas_set(unmap->mas, unmap->tree_reset);
+	free_pgtables(&tlb, unmap);
 	tlb_finish_mmu(&tlb);
 }
 
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index 0b4918aac8d6d..ca4eb563b29ba 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -1137,11 +1137,10 @@ static inline void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap)
 {
 }
 
-static inline void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
-		   struct vm_area_struct *vma, unsigned long floor,
-		   unsigned long ceiling, unsigned long tree_max,
-		   bool mm_wr_locked)
+static inline void free_pgtables(struct mmu_gather *tlb, struct unmap_desc *desc)
 {
+	(void)tlb;
+	(void)desc;
 }
 
 static inline void mapping_unmap_writable(struct address_space *mapping)
-- 
2.47.3


