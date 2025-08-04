Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5E60C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 13:00:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B8D46B0088; Mon,  4 Aug 2025 09:00:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 469CF6B0093; Mon,  4 Aug 2025 09:00:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 331BE6B0099; Mon,  4 Aug 2025 09:00:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1DFE66B0088
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:00:35 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B953F1A034E
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:00:34 +0000 (UTC)
X-FDA: 83739083988.18.CA4111E
Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012061.outbound.protection.outlook.com [40.107.75.61])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5363118001D
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:00:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=p7xxzhgp;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	spf=pass (imf16.hostedemail.com: domain of rongqianfeng@vivo.com designates 40.107.75.61 as permitted sender) smtp.mailfrom=rongqianfeng@vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754312431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/isIDQXqth2L3lN4ebor7qSOeCpQ7n6aPlOnnGVHjO8=;
	b=lotZG5DJ3nK3cejd86ux++3c+mWfhqpb/AV1I6b4cqUGiiFq1hq9tkimnoQPF92eg3X90E
	BN2mJ+6P31LPLdkguufs+zZyWjp/J2Iyf77RA0bJ00b8XFzKyIVJCpTV5cYBU89WXtg1vA
	OSKkPBXGXV7A3bv6DKUZd15PGrX3z9w=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754312431; a=rsa-sha256;
	cv=pass;
	b=Mzna9UwGBA0Crckhlah/FndssQOaZeMsff3PszHfsgy5JdeITxfM4hhZb6N4lSLyfO6CqP
	RCZwqZgFI+BGPomafXgK8HNwqm85yJjU3O9GtQ3VDYjHqpUp90g91qSRaGBG4VONqyc9be
	dsE1gMmjUbbSwxTixnboRZVLiCV2aaE=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=p7xxzhgp;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	spf=pass (imf16.hostedemail.com: domain of rongqianfeng@vivo.com designates 40.107.75.61 as permitted sender) smtp.mailfrom=rongqianfeng@vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pabRLVUW8PN4WX1fB1O2ie3ClVhudFd+E25VGBr0RB+X/fWpzfrps8wvjixDib2L4uisX3fc7moq/c69X3apjMhzO51g2PagPUk0Di6eTpdsdM73/yiyFoDke8jKey1KNyJFS0I0bwxfkQD3StFq2kyCSLPwfVu4zb8F+OAUbsBDL1PVcNfX9cS7WD3A0LZ2qXIo7/o5yNMQpDK8gvX1FZ2hU65aMKM0IMRFCDlTSbHDj/atgkEmBeVANCNsuaswcI3dqGyA0S/dOG3u18BYa76ZkWVWfoPcKmzV+U6oMKXJdachD+K8EU5iLNJEowPGzS8ftSjC0SqVxwezyvJAag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/isIDQXqth2L3lN4ebor7qSOeCpQ7n6aPlOnnGVHjO8=;
 b=i5IBrAIRRYWGQEdF/sdrYUI23SeKpcCyk3WRDwlQ0aIcYwKhPXfyI6NLkFyeEXfdEhB3tpf0X1pGv07GtZWcZlVHX9i4MTvqWmNvt3FN480BIjYwCui2Y5rtHY7yXKWqTV9l0BNxTOwPHoadgmIxRN5/t311+LS5eFIcsXLCcPy+0+mImnY7dMzyg8nYGkvgV01CNK3Z/pjlEFxREdjcBoLojIFQg7u3P23pVpH+cxsfOfavjF2i2l5/ms34VO/TbT7/S3NNnQAWv0fLYEme+6+ARexag8+yQbczSkG6eq07yEzABEDBnVo3ixDvJaMg/HbyGPJ7WrHmDolOGeYjFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/isIDQXqth2L3lN4ebor7qSOeCpQ7n6aPlOnnGVHjO8=;
 b=p7xxzhgpGdv6z2ohwwneLeGpW0vabUEqbE8NTJnyvhGVUZGzJXbN4o3hjM86h4le+EHEEkqze7s6BIYDbSs4+535+evqFOuqylQ9wfAQzEdM+tABplTxN0ojmnoCjTNiKcATOIWm3YKjehvhbKrv3eUNO9SD12uEaWFnLXQiShVT18Sfxyol039BuqSc2JibV4OJeZNuu+aAnZ4DtjiXOnmD36czp75zh5Hkpreo1sMR7OEWlbp4rzh42Ag8vhEzae9+I2nWZGGVAH20/vptz7plLbXdKq30Oh8LlRY5jk+WE8mZj3vemEOj0VE3EMzIaXrQ9zCGOiUmAoHjOlpqNg==
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 KL1PR0601MB5566.apcprd06.prod.outlook.com (2603:1096:820:c4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.21; Mon, 4 Aug
 2025 13:00:28 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%4]) with mapi id 15.20.8989.018; Mon, 4 Aug 2025
 13:00:27 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH] xarray: Remove redundant __GFP_NOWARN
Date: Mon,  4 Aug 2025 21:00:17 +0800
Message-Id: <20250804130018.484321-1-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0004.jpnprd01.prod.outlook.com (2603:1096:404::16)
 To SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|KL1PR0601MB5566:EE_
X-MS-Office365-Filtering-Correlation-Id: 550c65f8-9c59-41d7-1c52-08ddd356e268
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gQmUL3/j6tp860/UgiZtFRiJjPamRlzyt4aSZNMjT8MjnOBs3+JqPVSTn3aI?=
 =?us-ascii?Q?mhYrSNY0A0BYdD2Ig/ep1HdeiUhHlwJF/to3pGIGwJoVi/voQtJrKE2v0iEA?=
 =?us-ascii?Q?V+wrXVRpNlvzOmNkfOzosTcQ7amILu0Y2Mx4P64RGtGxPc60eNYi6alJi6kA?=
 =?us-ascii?Q?K1kURBcQGYIphK4zQNBVBWbLYOteRkyKWT3FiKlhNFfAJ+oPG9BhO2QtPJ+K?=
 =?us-ascii?Q?8tagvtdqliDHyLyMj08DXXxoI0EQJHJUljnE8tWKRaEhHL8QYvOWlOYFLNG+?=
 =?us-ascii?Q?gNtfd2jJQUB6pFf2YeNYuet3PzEtECmFbmvTBw3P4jD5TrXumo48qvboySaw?=
 =?us-ascii?Q?tnMQaPpm/aXQQVyNkkASNiFkMnGBYwyDl7T/nSDf88Wgf9HbeUU6yhHMb0ta?=
 =?us-ascii?Q?+thWu31MNufS0u9sKmEvoOEhbOHk662iTj6sNwpou0akp/SVD8oIufZWq3pv?=
 =?us-ascii?Q?CRegd+Uec+sJSRk4JwpbxNzHs3pbrjmdrCFkosVcJu/RP8PxaQyD2KbMiDNn?=
 =?us-ascii?Q?wdGv8ipygSiDJDqQkNK/WMYXPa6MBQCQC70r2TNydB4ZbxiqFD3vKHDjBYHH?=
 =?us-ascii?Q?4UlksUjda9JKSGR1dOLjVMkl32u6PebTkHjZMClzQnkigLUe9mQhoOAEvxlZ?=
 =?us-ascii?Q?sIrweoxwlh8tnbgDuA0Lt7bB7m9xw7gri+JjmQxg+i24blxCTYG3gvodYFV0?=
 =?us-ascii?Q?/13PlLyW2lMN7Z+hCSzrPRJ/oJmNNEy3xffB5h1RImwlQvvPzwcWoJAS+vkN?=
 =?us-ascii?Q?GZVACWJwgvl51AfTrE8jPO2NAocdHjwSwklQC17l5zLKsPTvkxa/BVYbqGLI?=
 =?us-ascii?Q?IfGZ5ECGLpVhgr8SRg4sGjfyEj+VkTi8BicEaP2Sk5vT0hCILN/DAeBoy9On?=
 =?us-ascii?Q?qtnv0bCDCiM/gF/69w9TCocvI05q+u0hNsxmTsUnAxY70wIcOJORc/T2FGwg?=
 =?us-ascii?Q?vbSYUiJaaLt7am/CNgGGCbnMOmk/9OrSp6bEf7evyxqG+4w3pMEKPW+1BWs9?=
 =?us-ascii?Q?fO8Uo37+WOQE64WOlQKQrh3ZGbCDx6JrSHpVuuooBWx+lt74Kp36/66RfoXr?=
 =?us-ascii?Q?u/PmoGwc4GaHtKKw4QdbkyDyFCBYJpbmk1vRv6eq+1wz+G9QWxLgH2inolEe?=
 =?us-ascii?Q?k5wNwyZ6+KlvCXx9fkEZeVhyqX/6JdUkvr0R0fHqDDcXQ2NusYH9aGPWUb/M?=
 =?us-ascii?Q?kBCfibOOP3wmRc7r5+av7T7nmo1XiQ34KuOjp7zoJa6zmTFxcEOs20OKZXqx?=
 =?us-ascii?Q?tDyss6D27t2KSequjU7a+kdSnX8yqqhbZ8flgOQZPsPO7kSVHIp1qnV+6zMK?=
 =?us-ascii?Q?sfj9sMX63T4pHwdl9OcbzF3jyziSSX+8GB8Cf+DdeUYcWxZWSS5oLeuj3X8y?=
 =?us-ascii?Q?CjviPkJItNp5UWJm0cQmiRymOzHKGGvkCVJafIcXPjtBIzcKJTs5iWJ89jJX?=
 =?us-ascii?Q?4/WkYrFPQlJgOz5dAVZBKSt39x6Yg7GgfxaTIVLzwLDte5QIJFy7OQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(52116014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7me5xU/DSx3xYmf+aVb4mZFgkDKrWtdoRddA+TNAAJcYlZp4oDKZGqwYA/WA?=
 =?us-ascii?Q?89yQcWOGFhLU4mGZJVxQ5as64senPQkiQ8qmWLx+jAXp5yMFTz+c+DpfnzA9?=
 =?us-ascii?Q?x5Vv0yaKTyvl7AParJe7dnMCYMwm0YXFtotf8lUSK4pH71hMeKskV6t/Vazq?=
 =?us-ascii?Q?Y5NaxmGl7sZj3PTsHzzP16l/uU0yupPCdbLIA3MPYmzyiPe5tEkMJzzgYOgb?=
 =?us-ascii?Q?wFNZOTPHyelxGMPUl96ENlU/0ntVxle9HAUtu+pEAcy4u8QZ48RHQvsl7UP7?=
 =?us-ascii?Q?qpO1w3/ig3xU9m0NcT+mmlgN3nne2BzEDSaEy1dmjenwKg6nhvB651GsvUYW?=
 =?us-ascii?Q?1U8oF7t7ES3ZioucuXEKolk0fJAT/CX6iOUm5EdTXhdCDUlGzrPJEHwwePO8?=
 =?us-ascii?Q?E0LyV9RlDtUhIepmZ21m1mmk1Hpf3rDCAdDDydciybhvWZ7nVSbfmdm8GnGm?=
 =?us-ascii?Q?77/aX6su6hjY6V6coUjaRvvJasMe0JUlPMKC4qRm9gwVPLHitMVDYDfPC1fS?=
 =?us-ascii?Q?I7nuWu6AXVFQqfHxSczDoUgH8B4TiEOoqk25APeZQNtiTwDifgNUgp+Gbz3O?=
 =?us-ascii?Q?23kKvI3Wd8eWagFsFsoL4TbLj90iSOGRIcDWxYjFfv18A/oN55pfd3VcMcNG?=
 =?us-ascii?Q?q00jPg3NO44h1baY1hj6mSTWbUOyu2Ru/f8tQKSaP7M7SNIQd8cWdWS6yjGc?=
 =?us-ascii?Q?OHV97AuwTiBQXqQD6aL7bntSeevBpO2/ENmFkbkTZMstNCQP7R0VXi0ppHq9?=
 =?us-ascii?Q?7hJ1xwmQkjwYbl0PEzPOdtfX4uwqHBma8tDby1txpWNUDLOsuBXYrn4geroC?=
 =?us-ascii?Q?5OP12bosOW8+JDL7mDJOPHMJLO5QO/MCgquAfbjiajRDTz6IQ7FVzHK3EgZg?=
 =?us-ascii?Q?Zd/PmRbY/FRRo7hlW4/l/kUwAFBiDp5nZHuRyU+bIMZ9+3K6kon05Z3u+g7e?=
 =?us-ascii?Q?IEZpxS19oTQr3citr80CSjFVQnqoBlmXJ0e9RCyrp/RD/r8B4YqGI/thltIX?=
 =?us-ascii?Q?38LPSmBKvV2bbqFsdZ4UhDxJCMFf/XvJd/dpr+j/FGGgxmiIgUWSi0kbwE/3?=
 =?us-ascii?Q?Qn933A2u1mW1iX/Ksj0JV2JQfQ20foEP2M+uRE5LN1cLVPNiN/aV0k20UArB?=
 =?us-ascii?Q?mhPoiKGlEkF0Cx90v0CEDn4hQm5ZZ5yZqEvQdZk8jHlDpeBpB9eOsVCkd8Ex?=
 =?us-ascii?Q?fjMLKqnQYXz4ZbczG9d0ChqnRsSGlFzrl2wM40w2z+74lnccOljm/h4Qmosm?=
 =?us-ascii?Q?YkOk2TfcEF+17SnFhxb3XljYBih3MnnjOb1P2KlfjHeRIjmkpAOce0S+39nh?=
 =?us-ascii?Q?sU5Ak5yB6CRyB9de+k2H7Y7P2psZmDQazJBfEoQp26ucfreT6CZnEfuSIwxF?=
 =?us-ascii?Q?axSNzQILjUGleCTuUwooBJBP3T0PnV8bKfUxF8lNTW3nNbno1ojhiojoRKDM?=
 =?us-ascii?Q?u9K2mollqSPVzq9TSt7Cxyu6n4fC+BUT3BCMFxISHeGjop6AUDVng/uvB+Df?=
 =?us-ascii?Q?nMZ0rMgxkgV/+yIdGEojMVFP2vTYhzXSiRHHXxTultOacVYdOyTFHPbnMC8o?=
 =?us-ascii?Q?eWhuwfO3rBcU1KVuAB/4IXaJ+SRT1OiEiebkW8H2?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 550c65f8-9c59-41d7-1c52-08ddd356e268
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2025 13:00:27.8731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xyg7Sq4zQK5Dowih5Zn2aKiSA/56n/KTMF9jrYcQjI2sDh/lw01fPSfSLlVK3b8ZqL9cjn67uSQEtbGP0OeLKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR0601MB5566
X-Rspamd-Queue-Id: 5363118001D
X-Stat-Signature: krd5yq5rgim3nycg1d54rs39xorwtenb
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754312430-434500
X-HE-Meta: U2FsdGVkX1/CAMznohfcLjoOFcAHqQqqH4Y4Rrwxr1pIr/3FXALlSkA1UNqF9Muh4mwuT3j6JA5V8Ru7kVbBNlMiwr/A4cRMfRMBYvJHy0+sElfKy/eWsOE14fU4Cpu5EhAsalHGPODqwT6pnYQWyfXTgFby6m5d8+dLIqe1Cc80A0WnnkgtNP+waYoh39khZpI/WOpk1jxMG6GT6sbUGC4kshaBorSDtx2FJCLNYaFaDai62UGzDzA0LWKSHYzGXdJXUTWJByADEBTUQSNV7YJgTmcKVsmhlwnj1QZsUl3LExoFmll0IghC3rcT3T2rRfCyGYtf1tNNWmYQK5g5/TGalodnbtnwatUE86gW01JRLmmuB+S6qPyuWxamWWhRA522IYfjZa1xf/Qv/B2VNtzx6DRQZCC1DSogBoJWi1ZiM9RrQyE2VZfv57S1TothLfqOim0mAc+HRDNkAtV73ZZ4cI8yvPaAMXwFM1pA9nto177xh+oFFLN58H2K8XzfHedsZ7hpvUtSk0BdZqt/7V0WaiiyeY1V09kkXAKyZ5c30GKeCvu1ZVuHRbiXL2za63FMZDTROj23JMYfjDwFLmcGbbkbLXBf0oRWyu1+T6WdVlwHd5CC6IhzKnj64sdQnKq2PvW+nlgPS3/2IgkaAKZoNSYdH0W19AxRDKut86s+6aGPxlcSGZuaB4GpjrGzCJKflcaCepE1mRvXC+pDHgAQAvTYjr6w+HqPVjqXKNVOLEihThgQF3J2S2WidRxAvtIRgwCc9XDneIBsCccaL9/T0TTgvD16H/JbpFMY/ky4kFhOee+eNXtvBhkiqPWvWZp8HfP6xq8i2YirjIeu312UOG1D4mvIVBVokl5amTS6b61d3mi7t2tKH7ZQ/wasMOduJqTUxm2ved9vLDhNyVtidYd9i9GO97W+umeKiJQFJLfCogazQipSKHU+jlwTkaAck3aGKN1nWfMXAbw
 1D9v2Wr2
 DlQ6AFOAyG1xj5zs88uu0f1wg3h0sqKQ9G5zZ5AJRtZYPEd7MGqmvmboRFbgczF2aC0JuRFB22y4K3RHMqNIa3/UaC6BTQBGZFG6PqBVh0YTPLe0L70KcBPbww8Pds9DxgnLE/vA3mgo7PRI69X0+MyF90mWgbOhEj+7bSpymUM3GnxvjMeqMt9QY5AV0kWBtO5cQBJ3DpHBxJpLityjAWihdFmBM8S+PYJvPCNSosDCXis6eQD+aC5wUR86U3qj9D3elRWgPLqVwK1LM6T3xP/nVOpv6C8Ue0ZIeodVlzePtTgpASD8gACtgCKns+UmQmziunDAv0TFh7P5AS9FcUIoZP4rWQCa+rkI5uvq4Fq1atLoZ3IYBfMUNYgQYkQx+0gZk0hhBfYhlY7I3+HIG6ypKJNUaEUV8QMuyCPJl41wV1A56CDRvUxL6+R4VrcwuIADs2kSnejho7VQDKIuIxz0oszit4Py+7WWLKfMLTXnUGTVFjLXRGeqQVi7wgHYB63UOq94UyRUbAJt/IIulNbz1LwXIWhc/YW2s35n72C515i4zzoSrVQFYCGrYUamumkBuhvNzH598zxey7Jz472L4K/tehJQ8Vcw+mNSeBn8MKCmMWoF68QAm4a3cl3oSTyaH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 16f5dfbc851b ("gfp: include __GFP_NOWARN in GFP_NOWAIT")
made GFP_NOWAIT implicitly include __GFP_NOWARN.

Therefore, explicit __GFP_NOWARN combined with GFP_NOWAIT
(e.g., `GFP_NOWAIT | __GFP_NOWARN`) is now redundant. Let's clean
up these redundant flags across subsystems.

No functional changes.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
 lib/xarray.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/xarray.c b/lib/xarray.c
index 191a02d94524..a2e543d1396c 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -370,7 +370,7 @@ static void *xas_alloc(struct xa_state *xas, unsigned int shift)
 	if (node) {
 		xas->xa_alloc = rcu_dereference_raw(node->parent);
 	} else {
-		gfp_t gfp = GFP_NOWAIT | __GFP_NOWARN;
+		gfp_t gfp = GFP_NOWAIT;
 
 		if (xas->xa->xa_flags & XA_FLAGS_ACCOUNT)
 			gfp |= __GFP_ACCOUNT;
-- 
2.34.1


