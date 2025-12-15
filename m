Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 043FCD5B86B
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 20:50:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 106296B0093; Mon, 15 Dec 2025 15:49:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AF1F6B008C; Mon, 15 Dec 2025 15:49:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA5886B0093; Mon, 15 Dec 2025 15:49:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9CDEE6B0092
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:49:56 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 61B0A130B7
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 20:49:56 +0000 (UTC)
X-FDA: 84222897192.04.C246F20
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 139CA20014
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 20:49:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ICkOFUKi;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=v7oFwlBH;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765831793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c7D5FNsNvBq2BMKa+9GCtw5TF2pAnNd0XPDVpBCnHsA=;
	b=D9ugLokReS7UiTbzft0vC1WcQM5DKnekIjaA5QLoWT2eJcSNH17IzNQ3H2IZMRc/ETLvGU
	Wc7zzgsIYASIxj/uLCx6l4vVroqn4h9rMnrJhILEjqu5/0SkLBt9vn6LiVMF5rz7pOvES3
	aCnzMuBJ2/lnHDMSFnPe7T5P5EZ7nYo=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ICkOFUKi;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=v7oFwlBH;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765831793; a=rsa-sha256;
	cv=pass;
	b=2fPb8rxfD/pLGM1uC1ArqYjUlnb1XJF2XbfuM4wdsQDdFqRXLv+21q6Y+A2fGTRE+2Mq9B
	WGUcP84GgqX0wGu1WT7HoSWY0MXW+e/4IUV2T7eU6lQ2A0LK6fJvC4gsSsTRh1UcBrKDLp
	88GNdNaPLYZPCBS8Jc/2NmzMMY/KTzw=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BFJC5L63058801;
	Mon, 15 Dec 2025 20:49:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=c7D5FNsNvBq2BMKa+9GCtw5TF2pAnNd0XPDVpBCnHsA=; b=
	ICkOFUKitN7eUpLLKGvC2laVq26iatvH+7LH7WUKrwifojDEjWR5X5DY7G+bKcga
	e3yNghPxUqA+iyRhwJkUybhK5yIgRLZc17v9aYnGb8ikLzRwj0IA7zwhzJs8D6Nz
	tvQc7GuVUVu7pavRYCGARAw/pWcH1cdl26YDHO6x3zbiDiz+TREjtz+rcZ4Dk2hi
	R7Ve+tIM61OCj8BNHUzpKT6I1xQGtK+UF8gBq9BHjwIX3l6oomxrw+t1dV7eIr2p
	Fs7K58fGfgFkt0nzjS5oS76pOPYOOXlTU8J6Vvx/i2oc4XGw+6GW+ukt7/0DpkWa
	DAk4J4Px1ukTkTjSPd1QSA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b106casbu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Dec 2025 20:49:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BFJJR1j022444;
	Mon, 15 Dec 2025 20:49:32 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011056.outbound.protection.outlook.com [52.101.52.56])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkjej2n-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Dec 2025 20:49:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FRJmYcI+VTHPMlnoaKZFFEggjHvfs9XW2DdjzqF6J5PP45JTtkD2gA8/i19o3itxfmVutJyn1LBa4Lt1JxhePqG01z5GpJigCGcoVjMuqJ+5c6sNreKMNioGrG6zE7cQNm5gsyAtOfznFm4uQVjnha2gDQYiNsYYC1g8YEkOiHnzcpkBIRZPHZsd1XHUkDjXDQlsuQeBvOKbLdVcy5YcomY3oL8CXNZdcKxBjBHvepiz9Aki8HbVtZo7Tbta5zoZWD2GxbUp2D6Fv/xMtERUNmg7BoTlW92+wxcQWk/B7v6RjWtJy6IOML24kQ6I5TUv4ZL1TuwrJkbK/uy7uHPmeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c7D5FNsNvBq2BMKa+9GCtw5TF2pAnNd0XPDVpBCnHsA=;
 b=tSufcssnywZojyytcJz7cALWiWifXCQtjZzBoP9oSXPRkU7vxTFna+ZHHCt69Y6WF5otvzrsmcaK+syjb8r8oYxpcw3gD8Eu0CuImzE2SWmII/Dd/HeHCFOgJtwEI0sye7FqVANr4aM7jNheB08W21svONXUOlwSeiphaY4urhLMIGBA3LkRMalAFh+b3cCDkzZHppMOtPcoO+Tm9hhG1vDob8+0587a5mZ6cJHwWsvFjx0cpSTn+1m+E5obMVZE4EGebTVFXRoAIjKqhyp6+5v641SXtlMlkL0Ho9zJIKD++4UDBy1geHVIuU2yYbw1chzMe5kSqvi0+pVKFrutSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c7D5FNsNvBq2BMKa+9GCtw5TF2pAnNd0XPDVpBCnHsA=;
 b=v7oFwlBHDjBPOmBopSFoFm0RbuHBKGBdHIPoyUh+YRTZ0O0Zb8PIqJrV5QuzsBZZPIIv3EhwZ9mIaUdpOp1+FglmfdoujQr/wPl1szyloH1Xydhhi6hdONuI9DMwenLd+jBFjrtEqvgaoF0x7GKe8UFVg86JMeXY64ETMgWzSuw=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by LV8PR10MB7992.namprd10.prod.outlook.com (2603:10b6:408:1fd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 20:49:26 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9412.011; Mon, 15 Dec 2025
 20:49:26 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        chleroy@kernel.org, ioworker0@gmail.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com, ankur.a.arora@oracle.com
Subject: [PATCH v10 2/8] highmem: introduce clear_user_highpages()
Date: Mon, 15 Dec 2025 12:49:16 -0800
Message-Id: <20251215204922.475324-3-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20251215204922.475324-1-ankur.a.arora@oracle.com>
References: <20251215204922.475324-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0242.namprd04.prod.outlook.com
 (2603:10b6:303:88::7) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|LV8PR10MB7992:EE_
X-MS-Office365-Filtering-Correlation-Id: 38a72f1f-0d3c-4798-b5a1-08de3c1b6f96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3cwwITLFST2W9FItF6eQ27zIZeMq/MDOIgpFHGdDJLgy2RDtagZvfq3m5KcU?=
 =?us-ascii?Q?kl6xoLn3hX2M63T8FVmVhMY4DsJWJ9NUpGLL/PR5DOryxIoKY+L11VyGl8o+?=
 =?us-ascii?Q?qiDFHbcgLvrmTg8d3+t0+Z0CH/vG9IGoZop8jT/JYlLegtSKBrpp6ySWtTe2?=
 =?us-ascii?Q?pm6SHe0F8lkhVYqFQeMFK3W6a6Z5OrIfsVahqKkovuCWUlSG/1ZpAA1suDWZ?=
 =?us-ascii?Q?1AFHwrrNKWpaBok25+T9pAO8rRioSBMaDpF83H1ywliEV5aKlyxjLI8Uxi8L?=
 =?us-ascii?Q?B2uFw6NKffPmRVqk6TgGvEUhzjoNYJRw8vnXHJ22dT4Vlf+7esXILNq3nXFf?=
 =?us-ascii?Q?C3Jwih5qBV9xk7uNU1PIfPChhRqOtJ71Lev8rD1uuo8mERfFnJ00u+CcutJp?=
 =?us-ascii?Q?Lfwp3H6bYLbSEgjsvu1lRHqL9cdXjrFHlmhjTGNXGSAUvkq7xCWY05KxQ02F?=
 =?us-ascii?Q?ij8m7j1+StXSiSSe4svxp/Xlmy4WrJuhRfaLf/i8SDQ9K3iJRcOf1JYgwCHB?=
 =?us-ascii?Q?0oEEgNQQZ+23ys94CmxxCx52OI5YeH1s+El6NUFW5LFSOolBar8iVA4u26zc?=
 =?us-ascii?Q?FqSOFSDHZHLHrful5rlujKbCSgr0aWG+zCXhXS4xjk1EVy8TNs1VesdzbZ5g?=
 =?us-ascii?Q?gwBybbliS9NM1Migqvq5STCRN7azcdDCvAeakPCVwGe5XoNOXGS/C28BTE98?=
 =?us-ascii?Q?DSa60flWu6r7aQFIab5RhoymDxsBcr4LK4DtbFk1DGHZ2tItiXMskRufc+3K?=
 =?us-ascii?Q?WA+2NJQ6qHcHQRbbrPDJ5dou3JIkq0hPSRS0JVv+3hJjmqeUMZMIflgAyPUh?=
 =?us-ascii?Q?Rlli8+129tSu+TWgzgwgE5KnFT4gqdki58ssPEwUPCDSDRxjJhBXtQrGHH4I?=
 =?us-ascii?Q?b6kmaNEPRpnjlaZaLVGk841ZVdE+cmMm5gWh3buKEsIvtNW158Snfuyg+0c0?=
 =?us-ascii?Q?WplGqtk/dJ6kSo0G3kh0IpcwTSIDmcnwuxCECxTgAgjFhdfva7NIgQSxjrOi?=
 =?us-ascii?Q?Xh7Xrd2FKzUd1M/YtrG2XQenDRPmfrNoDMzMWjnmjr0wgCnwMSTfDM97fehj?=
 =?us-ascii?Q?iOeqgzVZaSW2pxoD6+706danl4KJulbaxbJoAy64V2KKcBgmGEKwr82UuR5B?=
 =?us-ascii?Q?hUthp4GtyxuMgQBAPgSzELkkkVeXfXfl+JhbnxOmiImTG2+Y80LBcm2csMBS?=
 =?us-ascii?Q?bFPhvcu9mvm0ynD/2W3lYgOhEeKBLAz+qJ6zhDo9HcyS7lOCxxNJ0cnzQI8p?=
 =?us-ascii?Q?jZVzQ8XwD0zMGOtNp7ruyqFBLrgtxPssLTFTal3a6RPxznNSz8N/zBmCTzDa?=
 =?us-ascii?Q?csJ5+bgXj2OI2C4nf7rAgXkccisvFjijfVA/DMwLjQs7oT3FF2+ofwItMTJZ?=
 =?us-ascii?Q?HSPNYzkLECyv1IYp9FJGCdFHgbamYk+zFj3sx8sTnLMsL6X4iff26dxkD4XM?=
 =?us-ascii?Q?8lC/K5ZLdNK+78kjK2Jbd4TUqqxtSSS2?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ImjfeXKyyFpy0G5rlVN0/gYLBv4AC++S4oJ+nhwrY688Sfjc3cCF7p8+ky8z?=
 =?us-ascii?Q?zQkT/5lBRdsgfUUJTKBcv2jVZ1DHgnoEz19Nz4tE82YJJCGL6yv8ynl4o+9n?=
 =?us-ascii?Q?2VpFBT0dZNpduNDzwKnf7yW2wtrqNZOkilvgdlxMTCZZzKBWMAkwDxC+F/D9?=
 =?us-ascii?Q?qRL43LoSlvZsONhkXjW6TsSpBPdMrpzGfQl07ZNf2CuyzMk+0FpMHe94h5vC?=
 =?us-ascii?Q?qiTRoAeMGvlDEHaFN5siaj8nYCfl67vF8e5k0Epa4W1jYO0G2YtqK2y3nxtO?=
 =?us-ascii?Q?upyHWYkR5aKAcZ41JraeZS83r/7ImYV1//geu79UMf3jWmkKtld2g7O54uxZ?=
 =?us-ascii?Q?Dnjtr/BJJfUyBWauxYEsCmhnW7m6pSZJhJvEqpzRFvi5c4GettHP0z5jhAZN?=
 =?us-ascii?Q?4fJNus3MJGmtKxF4BJdZ+ixwWLPaLPkSfULIyg7XKSVNeAXgawgiCz5qfPiq?=
 =?us-ascii?Q?ecI+aQaNjsGjYj2C5wsUXeMpb8aLQb0WSbHUdT9MLSJuc5cpEekWaTRsTrSE?=
 =?us-ascii?Q?0rwYzmhKUi6Bn2CqtRLd2pDWj2w4Q5MQ4sjmloL1pWLmQIggGwFOn51pxYs6?=
 =?us-ascii?Q?tj1QgZAc7i/Da3Zrtfwg/cyXqdNo5/JEtTNRKOwZ7sYVUFfq3iMcbwT3Y+2D?=
 =?us-ascii?Q?oNSAYP96fkgqNLp4/lvwyJ1Vy+VWFpH6BV+B99UQS4bxyWI09osWm1964p6E?=
 =?us-ascii?Q?Aywd+8AK8WLTk5yIosLOMVU2jXlIQmdzw3sCfMHB4QuWRFjHioV8qveFSAAW?=
 =?us-ascii?Q?l8KWXYcch3TmwAGTFZn0NNcDUP4YJI2zdjoeqjjEbcxZG263+Z3LqYg984PK?=
 =?us-ascii?Q?IkiJyDeWF9hlbJMH4TCBnA9xOqfYca99WKgoYg5nMbslZjw2lwFfSXzev+eM?=
 =?us-ascii?Q?mu/64g9E7mdhgOfzUaJ2vjhGItlc3vPJ9nVMjZC+dMvI2U0APhvUt1tYZmce?=
 =?us-ascii?Q?9lkj7XWwJNPzaEVQ/joIZpLdg2dSxiVHxd43u+/dQebsj2l83rW8iTV398Du?=
 =?us-ascii?Q?G9msb8S0/BNRnme2eXXOvJOmdjj2KZPclFB8VRC0mc42Kh8jR3NMQh1tGqKg?=
 =?us-ascii?Q?WgYZlbPZg6POotUX67W4+xh7NlwSX8C7dkk9pfB2P39EzCGeU1RARRofmCit?=
 =?us-ascii?Q?bKyBH5WIcnLcHTUNOm9WDhc6XCDL+J4Cf3NRTBJfQ7P25j8/to4zfM4km7CM?=
 =?us-ascii?Q?Wex4kzfwI+8/tO9g0rbySHAvLG4iQ3i5AIe4EBVQI0iOtW4Hul/PCuiaVLXX?=
 =?us-ascii?Q?qb/29lXlpg7zMvff5M4esqOp0xLgzLFRGqEoatA2LlubWkXPzeK7LlQeo+Aq?=
 =?us-ascii?Q?l5LEgKHN3LbUZ8nk4/UgTHZrS8PrfKfKvxV30ZfO05sviPskgiiHSnLHsxX+?=
 =?us-ascii?Q?pjljwWYdHWFdfFVkj0wTfvBhHIkcDU76ttnlB7TCFh3zBlAG5zftm3YX+Gen?=
 =?us-ascii?Q?m2d21YnQ+I4CgfqpJthnVSlx1KCY2vNRvvrT8acFz5icgCUfhdb/rJlUYt7Y?=
 =?us-ascii?Q?5vXVHBxve0q4cRowIZ1z5FZNj/mJvcD3iWN/oeWatDbVY+vwCHvrQOR+fDlL?=
 =?us-ascii?Q?ITp1MLvM7Koh3q+yue32l62ZZY/OtN/9YX29UNEXx9XErFhSIsuzI9v7igt1?=
 =?us-ascii?Q?WQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vIx3JQ6nFWRHmPZiwyPlV89eHGtpay5RSbfRT2DO1FOR6tSdc+u5deDiY0xm/LBHowQ13um/BuqmvRO/Qcr9+KDOZGfsQNqakPn4KQdx77dXF6/hl9PdzUzTAeVjycxVuK6/qaacWjPu+LUffoiviETHGG6sN9saO+JgLksuGgcMz5pZ+CsDDvL3/lyFArzNbeL9m6h8qkGnfYw1A2bvFVJNMh1erIdOBXxGbIjTk9lE5mn4vz+KK0aRvzRvMVTGvuJRmO64GH/ZyhH1gaf9f8TShPa66UJI4JmUGjQ13F5FwjWA98KomjV7b3wW9aJBsne4xMD25RIijCxvIK5Xwh9GhcOHwCBF4t6dHC9RzzRMZVyKeMtKeNchMFintqYkyv1EXLK6+8tkD9D4SCF0ivhLGzEd+MBKO5EKGAnuCCch4/vEcADN0MmGCWrlK4vNw4mFgGR92o/7Izassk3KgKztuBk2yLEjkpkDt8+Pw/jyuU9j/gSYDcIzu1+J79F2OLBwerycvi+06GB6dLPK5XWfzTSdJP3poDssGgvR29JPreEWzO6TrLm4SvUgeOug3y3OXvT4Qiu7pBJU/tR8tDzhkSZqohnQ4B7d2s2tyI8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38a72f1f-0d3c-4798-b5a1-08de3c1b6f96
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 20:49:26.8107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PY812Atszdr5qSy6odosXNCsxmCFiMBNA7tUgU8IUkBJj8Xxs5Wwc6uk1WGooW+IZncdUYfAlZnvekibjt+2Xgq9eRse0cscsNuYaicDCGc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7992
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-15_05,2025-12-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=996 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512150179
X-Proofpoint-ORIG-GUID: qPkMW6u8czv8Mv_4F0YKgw80GJlaOT_-
X-Proofpoint-GUID: qPkMW6u8czv8Mv_4F0YKgw80GJlaOT_-
X-Authority-Analysis: v=2.4 cv=et/SD4pX c=1 sm=1 tr=0 ts=6940745c b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=BSFK5l32PGEs6HIvsOsA:9 cc=ntf awl=host:13654
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE1MDE3OSBTYWx0ZWRfX6FrPK5GOX6H6
 qBz55WmGg+m6rFkjUXFbDo9UAMDtid7N2Jn7pCuQVDUOex4sOF+GxiljP8C+vGmdxFM3uNp5tab
 qwzP4xMEGdXF0uYJDsJ92nJLqJTH24wxyqdW1TVHLXm6oCmT2T2tmAXGAjHL4D3erTTWS4lB+ml
 5A9OyMgulqmOG7+1Iab4T3IPWbCWrFTJkrlxxwQSA5BOzcaQWGq3pA83BBcnjOPZDSyEuTnIVrH
 LY/YzSEOi1vpRZ2o7b8vhb1XVHP/saTJWJBc6kH00bQbtQCWjdBZGxPO9qnaIGw38Z3M4RtA/5J
 R+cPYlTgzt8Dux3DH032eFOWWU/SAai2IG9aW3BwbNjYPCKvX0+52DncHTjRq1Wl+SoV5Mldjuc
 IjhooqMGUDSUI9BCWK1Y1RFSVYGeu1OvCh9qmk57PVpGuIj0VgI=
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 139CA20014
X-Stat-Signature: k77p6an8d39bo4tdwqdd6mgecxpnp59y
X-Rspam-User: 
X-HE-Tag: 1765831792-36681
X-HE-Meta: U2FsdGVkX19jAXtr4GztlqUdJQ0jAvuUGs4n2Slr+8uxpx2Dufcb64ydHkuKksOQLEE9acabQXqfvrQZ7LUeVpPw6kGvtYlTV+JxRUHAxZXO2RqtTcsq1M+yL3Wx2EqdluDYAoD1Pb0kPSgktzjca9ZNmRuFUsdrjXB2L0ACAs0T7eV/Wc6mGiGfSC0XulScYx1u+9ewjE6Q7cMF788K8ehG900NA9OY0JmF2pLa5wEOuo0xWRAuwkUOkm0Il908/CleaIe6P8dfECrEffYdmQ/92tUibhUz3/LgOy5KyvR7IwEChA4RAfKf0GbfhX+9lt15U4BbGqVq3Z8vXgPSqi1eyBzZSjztc5knJBR4g9Fy4GBvpsX2NNCbcudjsRoFDIHFkMSkqyEwE015MVD5oT33+7Oel3YTLeYGcY3hm1yIxieBBONHqCbMADEEmpEa8rgf6s9uHPzV4O9CjMItdjuK/UsB3aXb1LQk3SFOjtrATtEKbONtVmJxfabgdGtse8MKEbscINB0Y4+Pers67wa9gNlbuMKhtf0W5BzYT3TfHXSGTilvtdAi2jehtFoom96ewsQkzG0D/I8gR2qThHQEkwbLax6LBuxvxz/cz6KZ/X/YsVlhNzn0F5Dn/4NQT6ZmmUVSSJUpvQZeWuCfcB0etwO59/RQR9LQMu2Yvtpq+279wJvUeVNSNjaGFIe+tceDJGjBuT/YcYWUxGSf3xRgfmyTYpdlgEt9m5ohFFk9jyNc5Nqsm0YHoPEDfl3EcbWj9dOvpCVi1UZOp883IAaXWD5BrFtR/VKF3Wb5RrrNpUz5NXgWkiTVXagFtEJM6LjJIfo730cZmM5IsgGOL8cfy2ALUtZ3Z9nS90CqLb5uUELhQKThEvFcO2qx3fVuwc0/H2LDDgkGspX2/h1VIF4On1KHs2rZmt/y7oQh++Y5+NNJ2nnS8/fXMlJoe/2JFFbY/CXW4oo64pE/1HV
 1wndvczg
 kIwWsw83dMC22u4b2DOcJPBVRKyvlOYypWN+MAFRT/sevAZwgFTtfpsr/Mt2ucDiqTA1IvbVKbPhl8iWigkwijLroMhePUmMyyCO3oX7vD22EAUlgjCfOpWUIRm+ATuG26jWygngX3wcgyGDpJ/uS5/K47FYtl16hTMsKwM/p+QJrDQwwqo5h5g0c0bo7MYq+HYf0XgtlRTd6nELRSbbjZdoRyjpkqMrf9mBB+emSgY3CwdbIwB5IcTYub4Zjx7xHj4dgyQwfvUjc2xIEPUkVIuXXmHVds6sTckqot/Q7Xu5rkkJ3CKiWQAl6xMSW22V1SBd9SEVSaLyJ5agSJpYPVsAPuu+1DWyImW+hWSqY3Mzr8Cu7cThxkOP88XoifFJMjp1nH5qaczwsnLMKigiAvihDoPjfOixRXdXyu7y49setd29OMkY9WD2nfUo8kmw9Un6BzdVAVuzdRgj4adIDn3EhlksVMi9nOJFJBBvDKP5y4rqtGxVpxVEinQdg7XoPytIcXt58Fy4eTJuoUudJiUBcbOClfrve0Hf2C5Tv5Clo+2/F4FOwr2hPdAHeI07IXIFAYboih4eoCXilFF20b6d8fhQQu978xRAejF5fCg6aI3uqYvdllP0Kg/NEUTc/sUHKESbYCsLB3t+dfMYt2kQ84EfSe9tA23Gd7u1qaEOM83sNmCd11oi6XSrsIGpoZKn2BbfYHUUWeh8Z4AFmI0fFu7jFg0mQTuDU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Define clear_user_highpages() which clears pages sequentially using
clear_user_highpage().

Also add a comment describing clear_user_highpage().

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 include/linux/highmem.h | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 9a38512b8000..9187bfaa709d 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -217,7 +217,14 @@ static inline void clear_user_page(void *addr, unsigned long vaddr, struct page
 }
 #endif
 
-/* when CONFIG_HIGHMEM is not set these will be plain clear/copy_page */
+/**
+ * clear_user_highpage() - clear a page to be mapped to user space
+ * @page: start page
+ * @vaddr: start address of the user mapping
+ *
+ * With !CONFIG_HIGHMEM this (and the copy_user_highpage() below) will
+ * be plain clear_user_page() (and copy_user_page()).
+ */
 static inline void clear_user_highpage(struct page *page, unsigned long vaddr)
 {
 	void *addr = kmap_local_page(page);
@@ -226,6 +233,25 @@ static inline void clear_user_highpage(struct page *page, unsigned long vaddr)
 }
 #endif /* clear_user_highpage */
 
+/**
+ * clear_user_highpages() - clear a page range to be mapped to user space
+ * @page: start page
+ * @vaddr: start address of the user mapping
+ * @npages: number of pages
+ *
+ * Assumes that all the pages in the region (@page, +@npages) are valid
+ * so this does no exception handling.
+ */
+static inline void clear_user_highpages(struct page *page, unsigned long vaddr,
+					unsigned int npages)
+{
+	do {
+		clear_user_highpage(page, vaddr);
+		vaddr += PAGE_SIZE;
+		page++;
+	} while (--npages);
+}
+
 #ifndef vma_alloc_zeroed_movable_folio
 /**
  * vma_alloc_zeroed_movable_folio - Allocate a zeroed page for a VMA.
-- 
2.31.1


