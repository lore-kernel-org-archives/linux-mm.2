Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A893C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 09:46:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D218B900053; Wed, 13 Aug 2025 05:46:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD267900044; Wed, 13 Aug 2025 05:46:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE80F900053; Wed, 13 Aug 2025 05:46:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ABDEB900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 05:46:03 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2EA791402B6
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:46:03 +0000 (UTC)
X-FDA: 83771253006.04.DC2453D
Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012063.outbound.protection.outlook.com [52.101.126.63])
	by imf17.hostedemail.com (Postfix) with ESMTP id A5E054000C
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:45:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=KmzrqHUX;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of liaoyuanhong@vivo.com designates 52.101.126.63 as permitted sender) smtp.mailfrom=liaoyuanhong@vivo.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755078360; a=rsa-sha256;
	cv=pass;
	b=zmwWN+ImtxDpFABrJwkEpi2YzJrihehjIUlGL3cHNj/pjv7SSK/TbmI9fdw1y/zGk0TTtn
	rg0k2BYjSeYy34085BdXlIRaSAIwV9P3JgE/eLwvCxlvfqd3LklnbKOKwTyF2Gl7qmxrWe
	qlp4qjuwBD5WKW1dQLqJPokRl0Q+Cg4=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=KmzrqHUX;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of liaoyuanhong@vivo.com designates 52.101.126.63 as permitted sender) smtp.mailfrom=liaoyuanhong@vivo.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755078360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TvwnVaExqycOqc0kwVLgGS03xUb3Edd0NEyIX+2ay0I=;
	b=7cfrahpKdY78TwWJCe9AKf5/V1ISf3Moq9PI8u3aNTUQzGTHNjLUtJQFhnWmYYAzcWCcc1
	AfJ5i+UcGSZlZMZ44qFqV6jfnV8bPB7XObjPeW+XItUJAC4SinjHwRs+jKrP1pmhXCNapC
	ihY8sDseHifg3wx4A4BhDrC7wnZm5Oc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GAIiHz5iFUcPZ5Obi99Dx0+FCAYroaOIT8yaSIJlUugXeYo0Sg4BAjEK1takEMjoUUPp9LduPUlZdnEDm981TgOfcMNX1YT7hqKPc/CILUti80wyHbeI/5oXahj6GkD5EK2gdfMqSiEWxgB2OH+7xwov0Vf2Na7jlZpe1cBWLWxoFsG1FJDK/cz46Se5HukE1nU4U+uZzP5A5prYt/mlsW4NSnuviViv6D9XtGWic+4FpxTTnozE4Q8Wa43YjH0dgQC+0p+0OTYSImSxGOUmLErCj2SX+wRw/JGyuM75vTZCGCHTVJI8qqc4TWf/CyQURzoQMB9lFGDpg4xbu6zuJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TvwnVaExqycOqc0kwVLgGS03xUb3Edd0NEyIX+2ay0I=;
 b=kv8DCZrBmrV/VdN4ml9o2gqH0yiQvrYMI9NaoNOTAvlHAWU7qleY5NE5G2g/DeWFmRhGBTNK98bfKCePbjRsSWmchSQ+OfsPF5OtR1DqjpUXsEbTnNrOHByjPqhOob0UKSPERsC2cXDuJxLio9UCTw5o8LKlQRqEhlhyNY/AEN8seI/m43Q5dSmCGh13Z6aOm9Sna/RpSsLITNyT2SxjPstsDhI1kBgyZ5iAQ2nDuxcw9id2e+y46M4H3NEtZilTd808Y160scds+TjxQ6aUxgUHs/DdXQwRbWU11QMDoBwQp6rd28U1P7dqTtJJ6jv6PH7GyVcxNNBud9at65rqHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TvwnVaExqycOqc0kwVLgGS03xUb3Edd0NEyIX+2ay0I=;
 b=KmzrqHUXNFEveGun/n4jpX9sSOp4tVosVYNf63F/9zzVpTWuc3Ke1Yu55Ekw0KJt3Eq+FSZR09hQ8QGw45uQ8wltqHa0DUbrY9imDV2euZ3ajATNUuqWyKjxBNCmfp1tnUdvUt5tVuiz3E5zclu22ZH33zTz4raDuHMal/vVuglXn+TylzyO1lMLYn+BcBx6/s/gwesM6/IdwCQuJRfHpK2XiaN9W4J/EFAAKqZL16GfweVQ97AQsteXEtYo2Tth+ELPUqCKLFsZSLdO28T4SlC9TwtGYBYz6bYxbCFUVB31i8KxBvTcqF1gbCAIEsetcq76Vud0qb2H4paM8T4zFw==
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
 by KU2PPF4166F2409.apcprd06.prod.outlook.com (2603:1096:d18::491) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Wed, 13 Aug
 2025 09:45:54 +0000
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6]) by SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6%5]) with mapi id 15.20.9031.014; Wed, 13 Aug 2025
 09:45:54 +0000
From: Liao Yuanhong <liaoyuanhong@vivo.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	linux-kernel@vger.kernel.org (open list:LIBRARY CODE),
	maple-tree@lists.infradead.org (open list:MAPLE TREE),
	linux-mm@kvack.org (open list:MAPLE TREE)
Cc: Liao Yuanhong <liaoyuanhong@vivo.com>
Subject: [PATCH] maple_tree: Remove redundant semicolons
Date: Wed, 13 Aug 2025 17:45:43 +0800
Message-Id: <20250813094543.555906-1-liaoyuanhong@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0072.jpnprd01.prod.outlook.com
 (2603:1096:405:2::36) To SEZPR06MB5576.apcprd06.prod.outlook.com
 (2603:1096:101:c9::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5576:EE_|KU2PPF4166F2409:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e2cfb78-7065-42fd-a23c-08ddda4e31f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|52116014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8I+MKYrrJ73fk3Ok2jSlpBFskCeQF++q2YxKJ0gUO9hlagMvK7mPZGUq99M+?=
 =?us-ascii?Q?nhontKAV+PD2m4EVNzd4BcFNN9Lqf8uivOdA23FC1jx4TR9C/+J+dRt0Uu6i?=
 =?us-ascii?Q?CERlBM7IuWIFBzp7wyV+5n3vij4pLebrxlAWuePKeP0P0vEPCRDRwGsg9+7P?=
 =?us-ascii?Q?1rRhn8nZW3RoRrmGzhzvy+gQE5g/rpUycpEolUAxATqViwPg3gr3nogJ1i5Y?=
 =?us-ascii?Q?7Zu7q3z1GF+PO65rniRrcdFSigN2JyhW4tZpIEs/ESkoSQ+XIWkmKI486+1A?=
 =?us-ascii?Q?F3OWG+FmtbsJMWhoXwDXxHrdZ3BBLPnSmggi9q3cmiVQNZOUDISvjeA/gXU7?=
 =?us-ascii?Q?Wg6G4LAwHiAXxClZ98BYsAP2DVbgJVt/mhYWbm1tdnaVekVO/hDeDHYwgKH6?=
 =?us-ascii?Q?ljtpqLdyE/ynttN1PimZYH1gn+sqvYI/iazSnpDh9XKtu89nGyoRuHX4mHy3?=
 =?us-ascii?Q?/+e67zOjZ+1plqVmoMoT7Fi2HDwiO2fqZjjGznpsqamUPj6yeD2k0cNIB2+G?=
 =?us-ascii?Q?G5ADQkLppg1Lp2YeWDsz4KPuodYzjrcHtzeeVbcO7ig1MDRQyAPdSDmfaYF8?=
 =?us-ascii?Q?CTTOu4zvt5rZ9hwgCAoE4SG/vRP353j44pLdeugmz+o4nAE7ZLYg5SSYbhlP?=
 =?us-ascii?Q?2E7S1M1sQ1J+zjHtr6XCcDpBX5o6sULYUaRMyme1F+Gt7G5BavQ8auh9zCmk?=
 =?us-ascii?Q?Y6r3Z9/VVJMl4upO0ibyZQB4aEmRPFa1VpD5flaSzy3hYz8xivCjoRJxNOSA?=
 =?us-ascii?Q?EsE4sg79UYZqz4OME3K7FnbDADJjiYzc7k/dWdHbELpD/r0vlZmFcRnHymvp?=
 =?us-ascii?Q?2tpnBprFCLjUzVTmgLVcJyMivhvKbKkRhRMlDXFohPnv8U7TCiQwSwZTam3k?=
 =?us-ascii?Q?5EL8GTh2fCbroYqiyqHDDlvdUTPq+fqYVSXSPp7oQUZxefkZhSbAhau9KsI/?=
 =?us-ascii?Q?NYzOk+cS+B5U2220eeVN2al53adbrFCvX1OTfk3gI940oo3llPOS+FLd71kK?=
 =?us-ascii?Q?TIJKgauAbucQvr4w1dwEIS2M5vbFrLzylFaOq5l3yN8GgUCMBZMvKV6RveKO?=
 =?us-ascii?Q?HJngSlAiSbDMBCok1fSvYWfwvoqudwwmfl6EmwlaS4//0xju/MhQL+SZg1K9?=
 =?us-ascii?Q?AqOnRjb0C/P7+Bna4eA+wcXqkU9uzuTywOBsEouV79NQnK08gSMV6DHJwHlq?=
 =?us-ascii?Q?3S6b8m77hRn6qcL/z2ghmf+5HE4aAVvA4A+dIkB5OSyzg4+V9awgLnjBkqZS?=
 =?us-ascii?Q?Kw6RmwZm4iCjx75xhOjnPwFdbet9yBT9jXBIIjfXwGfwP6oRldFjxOnTxnU+?=
 =?us-ascii?Q?Q1WLgdM+8MRtAPL/PpJUpwTV5ouoUafHFiPzZV+nNY568yejX2gLN3OIsGbF?=
 =?us-ascii?Q?BCToc2qnyx3S581hPwTsAilW3uvo8p7PsCM19nlEz7axrW5JF45ZDBgY2eO0?=
 =?us-ascii?Q?wtz+DnMrtwbRtrI+9hKEq2oaWhQTM7F9dUXC4XPA1dD6IlVjV/vIVA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5576.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(52116014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FkA+N4Omtu3etpytK/SDVyk6t4ufjoU5Bi0/6w7e1G4O76AucX07lLcDRcm2?=
 =?us-ascii?Q?UeAzlhIqXDP7h4YDOcHJVe1lOLkffyLBxDY/X5EYDxMVZMbIgWqTxmBwjJNY?=
 =?us-ascii?Q?9M7PDL2SC4X/8tAAFMIQD7zUvNI9yKh5gKbTN3/X1SdGJz23WHpD6mtVyC8M?=
 =?us-ascii?Q?W3Xc2OqKhSHz5f5Z6sE9WM8JpdSF3rjeZfPiK5HAcONBGSUzX+Oj3hOUVMhw?=
 =?us-ascii?Q?YJxpJtTCSloQoIHRgRSutL39cl/6XvnxIlzuM0+VofqQYfJcylna8pQ82OEM?=
 =?us-ascii?Q?a6Ko1SEoQcQFm4ZHTpcc6mZGeVzFZnL4BFHoaAfQYWRLhD45xM4V6bYpayzx?=
 =?us-ascii?Q?tW53o4CtH7Sv/08eEXDPLogb30Eh8TUkO5CKE0Ky/ZYoMdLW99v/OzB/Os87?=
 =?us-ascii?Q?vJsrdORU5ICrC5jMYbEowle/TkaUftAP3FRI3aEHUHsuqQJDk9H8fvKy2Plh?=
 =?us-ascii?Q?sHrTyWJTEMEElZ4FUqDBrWa4eFVoikwZGZQS7S8q+G6enBVQQlJefJ9dASZ7?=
 =?us-ascii?Q?S96rxAGBvVM15nUN2MiRZTZ6D3vxApFx1jpxH5zJxzcadKZnpN6k5fPvV93d?=
 =?us-ascii?Q?+3EFUuq0rg5foXmnPHOAxD70mqLga546qDfQ70UGGNWEn8mRtiz+YrmjzmiK?=
 =?us-ascii?Q?6IHop8J6FOsPnBlbrZYgTgHTnJijdQHXrlNuiL1JCd1mYJa+HuqlN2SuFJd7?=
 =?us-ascii?Q?X70pbs6cq9Nik+wkCMnzSjijhF1Ck9Emp3YWB9IuqU9Z5kXiFYPCZKWGh3dJ?=
 =?us-ascii?Q?eeSroagBHP01hSEzwhWzDCDx5DL8ymgf6u9zxeNDlyLfd5aN47G9kQP+laFv?=
 =?us-ascii?Q?4H66iX/wQz9lcr4wd5hN+qOgIS8sKQKqRbwTvGwALVBvrf8xy/DGoHGMW9KR?=
 =?us-ascii?Q?uQeNKFz3f9cD4fUuZPVqSnZD53X8H9b8Ofy08/4O25H8nd2ozrFkWO5g4aP9?=
 =?us-ascii?Q?7OzszvYescr0F/jCmhngbiOZmEiIAXtqh4KeXkII9H8F45KkzlRFpiT68rjd?=
 =?us-ascii?Q?5QxS3Blm2mAxq2PeCKJWLxcFjt6MbC7DgCKLFcLIoGahQupYPA/JbBrh/C41?=
 =?us-ascii?Q?AbKoL1Y+iLXmHaiHnmRM5An6Dsi6ZoIcBE1i5uUHeQFFv2Z+XyjPEv6kQZ1w?=
 =?us-ascii?Q?IMafB1R63gPQAuNlxlvPrtVU7NsSP8IrdCa5EikfE+X2v3d7shcDNK4TIAyV?=
 =?us-ascii?Q?wqsGY7hMVovBgI1c4cUB8luB9r10HaTnZQZrJ4PNshZ1NNtbGsS6iPubTGIS?=
 =?us-ascii?Q?z+ODkGKkndEko13wdP/fr31r4eaZYfBdbPNtbPppsp51+y6RiTyh04u7h9qe?=
 =?us-ascii?Q?lS4WKl5oQTY0j1R2PY1NDp5nhokSxa8bToVLByV86X/TvL3yqweUjr3mzcqk?=
 =?us-ascii?Q?tA2suiZOXUfmysDCyGFrO+1yZMuRo0dcZgPUa9UXoJqCpVkU6TSJDxfVUvQz?=
 =?us-ascii?Q?nuuyreOg9qmFHlR+lnFGJwYnKai2jD4lYdfUCx7wfsXlWBnjogiOfjTIKuHV?=
 =?us-ascii?Q?QvzOuafHJ0CYWxp/Cih7IZ7pdG0VuV/V01PTQao8WyD5RBVM3nGhd6iqMf+k?=
 =?us-ascii?Q?ffOHha6kGQV44uSNam9I+O3snXwT1hYkq5SYUGia?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e2cfb78-7065-42fd-a23c-08ddda4e31f8
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5576.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2025 09:45:54.6075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i8eQTQNpsXUkrEopkf9jgGJnRRCVyUxE+3sq08prcRBeLc0D7QCMFWrh8IP0D5RJVEuf3SpwyplLV30AS05nXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KU2PPF4166F2409
X-Stat-Signature: 3q1yo9dfwiybm5p1oouqbcw7jor8rxa4
X-Rspam-User: 
X-Rspamd-Queue-Id: A5E054000C
X-Rspamd-Server: rspam02
X-HE-Tag: 1755078359-824444
X-HE-Meta: U2FsdGVkX1+KXGeB9OX1sHcv8Win+AaXDGcoDS7DA55I+4XUDW0ACqS0f17Gt2G8zCky21F29etiS8QyWrJa/uE+QIbVJNI2urYYwRen6ZcAxteJ2UP1Wgu53UzgTRROeZ48BP8DCUmw1hWnGzBg39s/0mC6rngxnLdOphtICLOPpJDMZrweM42qP6cmpyIi3b32taV7iaUQpsP8KM9iSG3OYKtN9T8Z7L1AvMBCF0MUp94u2aIN5GwdXi/H0JVBOQoPixzEIKpgHgsWOyqUm/jLDwJlnDeRu3l/90U5U74BS3ORDYGX9mTKfLAPRY3gez/qPQ+aSHjNOrrnLfMPgMGOpdPIbDuaIyXYaQ3KMBYlGYi8riL+qksga+KSWqHTAyMiEr6ShSFoY0+BPaYNP5GxVKdbqzU++R9VbNCBh1Q+RlTYFE9zvnXghX+qCk/igvSP3nwS+dgTF5AYv7OIzUsMZFc5p4LnBuyIsjgLsu6OTmxzKCqxo0Qafc7tt3lfaAmPGwVX2+KuAQs/0/A0OyJvcq8Eup98qsSQG4RHgd2OZsAm+Y3QeUnEk4ovPAqnjfpHudc/XwmIGwgZqcfJgUKjgIXzynma1sM6CheBJLOZu7jZ0GG9FJf0LI57pJtYy22+hEkEeZnLwuWmaVa9B+/cTheYCvHVwrcVzJWmMQ6pYsZsH69CUWBCDUUY7zRrgCUXK2R9NV2YfjnJGBE99Wzp4QezFQAVXX9qwPF7LWKlYF+8TK1uozElXg3l3jR35vElYv2MjPXYecIqaO+fXZ/BNhheqxdPiAgEHDxq0ocCEYjEmjZE2c9Qwh0JChDofdHaJDf1BG8mey63jSuGskhFtYqzF1IvC3wr6wn7amuQElfHZXrUaCUOylFvvjrcx1/o38+gxJpylweekz8wGbL6WMy9FpYBF4p7e4lJ+TTnyQcL6YCqP7s++UheyyA+w9S5kWQi/Sc6TCfNp0E
 CgKxkbbQ
 Sqa4qugC5dwhDPcWQGd48ABzBd9/IS6ja8OGXyQgYXaxtoobhgQHgnqXArpTmfPpKfB8et3GjVb3sP6koMtMxz3knQ5XCN+InYO2RNeVb49VbpcPXyZsGaeb0MECBWqbXAZljV79BmBTnbBpavpkHWVGhmwZKbKx23+m4QhbtW+U7Aptq2BcJbYBs6VyjwYhSBNUMBGtqomfUnJ7xxAojgLOob9CYZWVWRBj77zgRCkvnPcIurrX+XIf+mtIgZ/a7hRX1GzPRY/ykGU+842WwCdltZ/zUevL+qLFariKtuKL1e3QquU18Vv7Jbw3iMeY+lbKaWmmCodJYRfc9LOvUQKk+qLk6jX0YZyBfUrhsF1JrAxRzKyBvgjJTQU6EgTvCbHmsWS//pwTWNLZOQqUm5GKvkUnbEboARJbc8U0FEF0Ue3OM9yMs89hj4cbOYIKqE165nIwLfYMRfYZeQq2Hc3TTu2j/SK6ED2mpj1tKjBfOGSEb/VVUH1QqK35jTKZE35kbqur/cbrMNjd1b6S1oXwMuwbuvrJAAIOigAzeVTfGwQkTXxZnIuwDp2UnZdZSNjwGWtXhmFKio/+s3gkULFzzQvbZoQ9e1q2l
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove unnecessary semicolons.

Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
---
 lib/test_maple_tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/test_maple_tree.c b/lib/test_maple_tree.c
index cb3936595b0d..1433ecc854cb 100644
--- a/lib/test_maple_tree.c
+++ b/lib/test_maple_tree.c
@@ -3562,7 +3562,7 @@ static noinline void __init check_state_handling(struct maple_tree *mt)
 	MT_BUG_ON(mt, mas.last != 0x1500);
 	MT_BUG_ON(mt, !mas_is_active(&mas));
 
-	/* find: start ->active on value */;
+	/* find: start ->active on value */
 	mas_set(&mas, 1200);
 	entry = mas_find(&mas, ULONG_MAX);
 	MT_BUG_ON(mt, entry != ptr);
-- 
2.34.1


