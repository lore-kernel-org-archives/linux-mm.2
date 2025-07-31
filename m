Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBA98C83F17
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 11:49:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43CFD6B007B; Thu, 31 Jul 2025 07:49:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 415106B0088; Thu, 31 Jul 2025 07:49:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B7216B008A; Thu, 31 Jul 2025 07:49:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 17D9F6B007B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 07:49:17 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 905A0C06F1
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 11:49:16 +0000 (UTC)
X-FDA: 83724389112.16.2EDAF4D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id B96BCA0003
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 11:49:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="gAPyTs/3";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=WtwoNH+S;
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753962553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cfVizznZhPXEvAuDuMa4XxolEe0Rk8JLe44JEjktQzI=;
	b=ukD0Ek0Yfm3BQqMWDNPTNR0x+vso4tA4b4Ez/EAqMyzLMvgPR8jrsaPKU+QxUJ0X8OvOZr
	ifE4pFYPtXGgihz/H4vffpb3JEa0w425kQMWvtZQZBHdb4w4AV3TzmEPzeplzvqZF/YErQ
	ERerZDnIBUFeN5k6FKdBdvamnYTojNc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753962553; a=rsa-sha256;
	cv=pass;
	b=5rZtWwNnL2WqHAAN9V0FuGoMZ5ry/rkAvyWgDEx606wL6IgIBEUhMQR3TC3/9lrY2L5ny2
	6udKH0I44UrGflegEG1aHZIAAeBKmnjJMw5DTVw3FLyyKA1wFfl6k8E8NJrulTdsKnN9lS
	alw6HjvP/ynUDfZsiMR9OZBql+6ctWI=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="gAPyTs/3";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=WtwoNH+S;
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56VAsUZ0011128;
	Thu, 31 Jul 2025 11:49:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=cfVizznZhPXEvAuDuM
	a4XxolEe0Rk8JLe44JEjktQzI=; b=gAPyTs/3tj0G2QJqv5LJUw5pWeeqHSRSRH
	r4iDqkoil9p/q1NrdJewZhcvRj6sr2y/40HZ7U4/wllO7kGLFaZhD1XVbLL+yj8L
	wCBRWyixpzJIu0lV5WAwdnuODHqbvsEbvq+5LRSgP/Gnt+MBHgAfjk4yHQgjCqn5
	GRm4CFTSnn3dRzth+nyUWaUgeswISKHXMAC+fKnnA3ykAWEE8HjK9yIzMrrg5TTU
	6/e3yNkzIOKyW0UFUnlaOncLsrYUUmTW7xBHu0uSeccdw+6NQHCYTJtJ5x9XiM0p
	8s4hgNj3uSHJnEjlmjgcqSCOje95m48u8y0vBJ9l7Q3mTuEo/SAw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484qjwuyru-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 11:49:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56VBOtVj016800;
	Thu, 31 Jul 2025 11:49:07 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2070.outbound.protection.outlook.com [40.107.244.70])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 484nfjq92q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 11:49:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OGVWXF84KDTGXJfY1I3RwU0kKGrCwMTK+ACKn5m+dU73LKT1goLuBFiGNb39SlWl7Y1KJrj8eNS8HFTJH65wLxj9ug8guFP6D50T01GJayKDYTnWl4ncaIArh9QTVlI26LE4F22eSZgCbTP23dh+RTxr43Zm5oQ3ezXY6EP559icdx5LexvJsSQpjJzegFSBXThNW7TfxCCi/VrNFau92Uvq3R033KNCLqkEjNMbUv+VKz1ujjRZ3kKEzxcWIoT7Akdo7fe94CozjtP0tinzz4B8wvs0l0lVciLHKDKCuuc2GzohohK4uPCWsu1o6fPXzQfeq9rTPpyvBE9ZjyoDXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cfVizznZhPXEvAuDuMa4XxolEe0Rk8JLe44JEjktQzI=;
 b=rSQJQdl+AEWcgPbu8MzVLKQ/cHAnnybYhQoPqQeDs1SvoJE7jKYY96BZ2VDERPnFFeBC7OrDpTneEvVNzGeAo85Ah5hplJK0Q1vjkmwsj54KJHs+RaV7uWYsmosAY7Y45FnoqGIdl9+yY3FyzfT4AZcZofaYyFyFF6QpI1FPQcaHMaUxePJCMAEhDRgm2Oz/O09lOwKGd15HMcDQzE+VaGpBRlb6SFHlShTciLS3M10aj4IYs3adAqZrCKw0qlWrM2ZZlOK7jpglkOJ5dBwfY/wqMvPCc4OILPtaQYzXg1iNwCpDGklzBL/IutqoFvYMfe5TfDaTFkpg+XvdbhT3kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cfVizznZhPXEvAuDuMa4XxolEe0Rk8JLe44JEjktQzI=;
 b=WtwoNH+Sizfndnvg++6q9wsJDvMWeMDJRsgsXTf9zw8U5toktrg8ENTBKNxJzTfIUyGEIpSRv94JIcjN22r1F1TcluK/VdfN0ggb9gioX3aPpThY8ErmAM51Rc/csLMpr4qUuaRYlUxho88jdn4Pfw+FjeoYj2IgZAMXM4HOiXk=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ5PPFC322FD87E.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7c9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Thu, 31 Jul
 2025 11:49:04 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8989.013; Thu, 31 Jul 2025
 11:49:04 +0000
Date: Thu, 31 Jul 2025 12:49:01 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, jannh@google.com, Liam.Howlett@oracle.com,
        vbabka@suse.cz, pfalcato@suse.de, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: change vma_start_read() to drop RCU lock on
 failure
Message-ID: <6b0425c6-799e-4ff5-9238-66d8c5d49e0c@lucifer.local>
References: <20250731013405.4066346-1-surenb@google.com>
 <20250731013405.4066346-2-surenb@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250731013405.4066346-2-surenb@google.com>
X-ClientProxiedBy: GV3P280CA0084.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:a::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ5PPFC322FD87E:EE_
X-MS-Office365-Filtering-Correlation-Id: cb6dceaf-363b-422f-22dc-08ddd0283fe3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?K5xbv/ZXefzK07hqWd/moZ4I1O9cAqtL5dsGIhQGoXf+TVqtnczV+GrmXZvr?=
 =?us-ascii?Q?eY9AMromVyTONOdgV355zykiCIa8UrR9t5YyvJ43dReYezaJKer0adcp3W8V?=
 =?us-ascii?Q?JIDSv5eqR5wJWkcYDjgQP+kBwzSZhGz2ujLDZG2iRdoJKQpICbLUO314U30P?=
 =?us-ascii?Q?kk8er8kKNUXay9yCbvfw2Tf920FUR93KaikpubrGYM7SG4/fgIhnGJGTUhKZ?=
 =?us-ascii?Q?vzrkKY4FX+CuYUCvZxTLxV7OcYhoRUwGPeur8ZFMJxEWrSw/zFuEyqezFWPM?=
 =?us-ascii?Q?0/bANV2/cGfk0a5zYCKcIx4EiBiv3Y6j/h8RNQ81pmUkSRw61d0WVkHwecPB?=
 =?us-ascii?Q?5ben+sCHVfF8SFs5+9yxFJsKeEFWSwL1AAmmAanjV1Q0VGhN8rXV8VoLm8Qw?=
 =?us-ascii?Q?C747rdV/5gmFGFgo52//TbCYbsdx9XeXQWHKymYn8XZ27YFNkBNhCB1LnASV?=
 =?us-ascii?Q?Gp80WH+zKCDrBCFRaRZVpK+bymQedAzzoD8zypB3dAuBhSZyLE1m/61hQvgb?=
 =?us-ascii?Q?Z9GGtDbE++n6hTKk3KaASCpoY3ZT8d9zVcmuIpt4I+uWNGF+pYeW3Y6kQqen?=
 =?us-ascii?Q?YOb0KcU/c0IDetyKA4DitJ8KV0lQzcNR6nyzpjc03JLlKdxk7i28RuI/cigs?=
 =?us-ascii?Q?m0K5csYEMuexmUnNqv3tQMDHcOEAxAmkkZddkx7Zl0L82aHia/jizDO8pQX1?=
 =?us-ascii?Q?zTNFPUeKrsEuCL3agX7r/6izR0dUvIt78LNmgfrVZMmlD4eNaMKQ7C32K0l9?=
 =?us-ascii?Q?iVf6NOlF+09LPXWFc821zhwI7jKKxyzuL8h39P2SrRbkfcNz2GhmCH0/0vBs?=
 =?us-ascii?Q?Z70L+hhh8rZZN3KkTL/CrH4cWS4sIrKfMwjRc33XYPZRFv9mlP33vkywCxhQ?=
 =?us-ascii?Q?SQBBo5LmgcNvnvCSZPgJG/TShe4gXJ60D72B+tpD31Nk6JvN0zTiRo+zC4ii?=
 =?us-ascii?Q?5qgaITvGAeDb35nT01S+lK6pDKifTkFUfOayU/iNLB4pv3nkE+Vllf35VtD8?=
 =?us-ascii?Q?xCvM6XV13AQlrZXZS8GQjc+iEVGjjUSeTDjGplrtgQ//5U1bspjaFNDHxgbu?=
 =?us-ascii?Q?qXpWSq8bcOJ4iUkYrCqwypPwGLx+cOxma0ZsLU7N9vTKfvsjROpXoZHXWnt0?=
 =?us-ascii?Q?g1yriUezxHTjeBDL0qnKY0+Je1WK80Qj44TmnAi69vmZWzVHw/IGG6rZIClL?=
 =?us-ascii?Q?NozGWZDl5av2iNR60P8S7Xr1jVyPEpFTqWbNesIlOwGnuK0RhdmZr8bovbIu?=
 =?us-ascii?Q?WA5al5ALmCPnYn3l1+oEwnnAOajyPW6P/2o3CCA72pUeokKR115wCkyI636W?=
 =?us-ascii?Q?o6tEMEAvdmd0lDHhYCs3JAaZhNoWjM7mULr97MPyiG9Tv4FD9u7Tv8kBRvOv?=
 =?us-ascii?Q?f6EibXHmR4RxYVCn3R30XVh3UaW3zfBTcn5eatBebanYkDQPJASp+/Fgynsd?=
 =?us-ascii?Q?tCfKhBVIOjM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?G/EEdr4/hA0UWDZ/QmJeFax1I41eZwHKMquTBUkxUFGTzlk7w5vPwwkK4BPC?=
 =?us-ascii?Q?GcOtdhdXws9tuVCw+70ZFdLIqyAV8IzWHwqvqO3rb7b8x6WETltVscViRnVs?=
 =?us-ascii?Q?e4C1P5HDUfg2qCJCfb+9u6N3xAkMgEtP8/IZQyk1M3mwuQ3oXnADytVacIgh?=
 =?us-ascii?Q?XUqXmxrFTVwG7eFxswXHKuoGmqJh+cKP2mEW2l5kmUJywD6942XcU2wfWutI?=
 =?us-ascii?Q?JEd0vYL6lrgMP/oWenOiu0EPrPZBlqJLsLy+xYj8d48W/S7EcwbfxgLu2AlB?=
 =?us-ascii?Q?TyfIsOQoT2i2gY/M4XGSCDz8Fhj2Qox8qLiGrWmmPMiNQtt09dS62kW+TxAn?=
 =?us-ascii?Q?pJOpd91nmUB/Dq7qrZPBXjAtwibFbD/zlQbeQ17j8TlvkC8VhXql7uvrxlf2?=
 =?us-ascii?Q?utlRW6fmSeZV6KFpg05l7maJX15+40WiQc+jMQRbi1U87yVqlEF+v/rIGQm5?=
 =?us-ascii?Q?mPXES38qTasFEwH3nJ32sQv+P1AXgLBESxeiO/k+/ucsyREMxqpaG1jOcUfi?=
 =?us-ascii?Q?PVZrBzlqFhpP0BzFs3O5PZbwI61yQhOqSFguR8Ifeyn9WYxjiNqhZsihHRcm?=
 =?us-ascii?Q?UwI5Dm7CcB4QGZKW6JwS1duE51PIlJwmakj+eodqFLpwbrQLLKYC9ipxz3K+?=
 =?us-ascii?Q?eeY5ZUqvs+emfxDi2aQEQzw1DnAswrLTNKbO3b83S6bedZ0qvn8IjKjfML64?=
 =?us-ascii?Q?vkqDXxfRFVo0XmaJRWjEcsQu/DElFhDGDKLkd8A4QK3HuBpmmt4DB7MK4fBa?=
 =?us-ascii?Q?vgNjOz3kDTF2X8srIzIs39qC6iwu7XZdDvMBvCgnlZqIyVebT++K+behdy5M?=
 =?us-ascii?Q?Fjqezg822b5cdYWfSBOl0EJ4qAmmV5mCNxBi/4dJrmwErCvU9VFeJekjc//0?=
 =?us-ascii?Q?XHm9pfp+CpEuEEPd86IfFgUYkfxCUtAjwvuwKQ9Xz3ib6fwJCQLcsDUahALZ?=
 =?us-ascii?Q?RSLzqWr0xa4B8Y3UPH3MBEZUAQYf6uQHEWWs12a4qrwBp3f588lOnZkqprVo?=
 =?us-ascii?Q?QQSDoEPOq+vU39hKrgMGdJFonspj7sznwmPbTBrBAH6rlcgtYhaPMqqcx8O0?=
 =?us-ascii?Q?+L8z80ocJDWEq68pW75pUdk2AeXin4hFRTkKjQ7hs7vpVwt+OrgpvaWve9PB?=
 =?us-ascii?Q?PR7m/IZqhV522RadB+GOzlsdmBzOXN1bEeZtAnAmLYF5ec9VV7nbw8f5Lelt?=
 =?us-ascii?Q?hYlXWUWwNqFRxUI0dTrMXhKkeet5vTL1l9576vMldDMISMbJD+ZCiTQf8Qmw?=
 =?us-ascii?Q?kvKw+Sbz8xV2Qv+hDBKQDK6vD/JqFtrJ401Td0au08eWGzxQF+J+c3hZ3dHr?=
 =?us-ascii?Q?nI/TufqJMXErGPLIACZ6qSHcpClZewmLP1JbGpdFmmKtADMISPxZAhTz4G5c?=
 =?us-ascii?Q?qVTGlVaZRTvbore8n3uMD6yNXUCq8LWOtH/KkUvNkQ3ircalMUyUOyhTEOfb?=
 =?us-ascii?Q?B7C8U6wTMTJZyX1UECy1qONrkhs97d1USN5ggSwz7Jnp/xYVT5dTcRjW0Mja?=
 =?us-ascii?Q?enzMXFyAhxPu6IjLCJs+IuW7w9ZCk94aOHrBghhZ4eJ9n4YvBWRROIoOMapg?=
 =?us-ascii?Q?SMCb8IX4oDGTgowwfTs+oh7M6gI9pyzLtLDX0n9gPdyD2CYi4YQ+XldC1M8w?=
 =?us-ascii?Q?ZA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Bkddl35Un//NG5GU0E5hiIgBlYAGcagce1ODLTO2mVKEWKaXy+73g/zHxsBRvzLguZRhGP/UuyhXOGtCVOYsBVfzBX2vXSqDGU/58ei7zW/XyZ6CPWrP2lVCD9T1y1KFbHz7d6EhhXrzS+vwt2Xi/cbsNo6DFQfois6iegaL71yyxPV3SngKR6nIMe/B0+zaIPPRBayXPnnWFVRjMTcgPey7BuJwe6Li5QvH2qhsZHlp198fN3WOazddAPwK/auV3I53kfiItX15tPj59hFJQ3Y/o6DP33o3xcy4azSVO6Jd1/gn0OXFT9La53cXJfApGIg3KgRWb/VKl9pbGYwvjLSXHu40sH+E8W63o4d5vpE4WgZZu7UOfZfj5jPzW3WRMnnx2GgBSUFh3QO6UNigQ4ZT3JI4o+lD13Plgvfb67yDvUnj2leSuGEojckk+FhOUt6Z8CzGig0iyEmFZOCVoBIQHvr8VTSeWhWRi7VD3J9pVFTmo4cT1LTWWCaaJX147w/WvIyO+MPWSB9rUMXGuReEhSP2ZKcd76G1B1Zvf/Cz1c7pWEM3T+D/EErcHf9gotwkjyycH2o1nQXmO40Z8ITMpocMQQEGvN3E9zFRXA8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb6dceaf-363b-422f-22dc-08ddd0283fe3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2025 11:49:04.6939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GXGOetrU0P+rlfR98kcZMVXNDQ5vxsBTKkNuOD6yJmVoQ78rsCi1GHELsPXMDqlDSwFkygSboa8N09yIz6+ylvcOiqixHA0tAzsXVTCLG9w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFC322FD87E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-31_02,2025-07-31_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507310081
X-Authority-Analysis: v=2.4 cv=OvdPyz/t c=1 sm=1 tr=0 ts=688b5835 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=1XWaLZrsAAAA:8 a=od-9nrgw4u5V18DUkE0A:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12070
X-Proofpoint-GUID: fWvdaEU3hanW6jE3-4ht5W9wc0y42O0o
X-Proofpoint-ORIG-GUID: fWvdaEU3hanW6jE3-4ht5W9wc0y42O0o
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMxMDA4MSBTYWx0ZWRfXw4L83LlHVMrT
 uxFO7gaZGXzYe6MZfK7FrBC8OaTJ+eiZuDFBtg08P90kIIim8rrAJdpYx2r3i4RuYfE/dhD9yiH
 FJQ76i2GbbjQV5S3gviYDKmHdtdLgx4rJAIcynZyDFZT5AxpUAvXdMGv5WZ8G0qa1W34r2gOpHt
 ZMQzYdHqo10t3K1/pudbEADQXIB0y0MPrETRRKAu9Ed2r0TsRVGroxgt4DJwzJvkv1+HC0RYhaI
 JumZCw2O7ZqUT484sqOL0d4zzlKEN/hxQwQchapnAEYIwajkQeO4XZpTtaP0N3u1Or+2KtsXJar
 CmgxXTYJ5iyPleVEERnds8YMRi18KeV6rqF7soWTKRGGZWumOtE+gKj3TCwxXe/96R6Rq/e7Isy
 oHPBXJr1PVCuDcUpf4sOmnoPwg0714s3540uWc3M5N1Hq2A8msocHKJQJCSp3U/mcwmMqVSA
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B96BCA0003
X-Stat-Signature: d6e14xfpzpioqqcjj8s1thc1335kezeg
X-Rspam-User: 
X-HE-Tag: 1753962552-240069
X-HE-Meta: U2FsdGVkX1/1xWvxPOV6NGB6iOoqBQGzKZq4BRCNj0QSra9TTuzEoGfk2A8pWQVbbkJ68EQWwz+5NPrI6IY4ssI2tgjEquSUR4M1ef8AhAbVstbW0dgT0sqpOJ3lILYnG2hZYi6T7BKhXKy7MrRgzYyqJC0kJL1Aq2hl0nwTTjuu4M2SaGqZMTK8EqJRbOfRL0FkjaJLNkhh45Z8VetmIHICsWcIauR49HDeMMfe58p7mvSl0z8QhA10i+e3v4IZiHybt3gz/V5aI/vP5hYi6Q1b2OwbtAKJW/JYSfnYaXvyGGt4zE8IXniYJnFi4t4QxicH9tBRxhZ05LHYzqZpeK2BqewIvn3QaP6vIE8vxbwfpRB2SiEArEOdWDXgy8MpUZB/Gu3JwINHQFOkiqIPc8gBfHHrFkEmu2he1pVb8Ea/4dZ2ZPk18MOtat14whRbdVXofgiVrd5fzX6TWsE/+0FRXI9E1isgxoJMDJ5WcsHclJ2AEFDDCgSXucR3uKOuoR+rf+LcY7QguFSfM3YJTzYB+cXulu2G4izOEB5XsWqE7eiixDFPpFyQS4NS/eCFHWto1IiV6G201syPRPf8AU1t3ogfQDdrktuZbpqT/EKHLTMUqwEYXAZDfqAySgHOL7uLI4cZZmPqjou9NMXy4YVShg5N5CWW3lRyNzNvmZo9nmuP8Ly/HiqUAjPlaOn1jykEn+9323gaX9v95lHa2wsb/r0diTzIUDgiRz6tvKgND9gxo9wpymCoYyLo132pt25LFXlpvFcObr+fpZB8AEIpB5KQYQ2W4UQBHtKy0U3Pe48maS3nOwNsdSJJk8GwOFAVWeCLL8A8Ne4mJbSCWn7CtyeTHigOIO6ZNEoa56uz4N2fWHUk6UB4J6dme/5ErummQBIPEqIdrJNxY3ia7UU9bxRhSCtf1wnG4nFoF7paxAcY6f1+jPnn6NMeQvGFpL9uQxhCL/wtmuZAzrd
 s2viEKQI
 UyyCfGDiP2M4INAAry0Qc/IU4ZUw0d48jQ6kn821NSSenf+1+pQzgUT+D0RMIhLcNvOWuJAm35RZkJ415ofZigdoa56T3RhVlMUh2QUpCJPaO8Bvyfep19n50/kTrqlswCgiI3xX+1PWGKhavf+1wlQ1hM0ZcNva9TRADyRaZYjeDCsEzMx31orMiMa4VFoOc5KptrLGsaKxNANvUzYzrXm3X5bBU5ehDTXsnAtmZwWkOCMV4IQ4tdjnoFC2bM1VHhsh44r+OvmfzZ575wOro6UzbgJw081HBB9HoPnfEa0S1uOuMisyAStGzALVeEEi8iHRsfs/R06/+l13zflfJA132AntrGM9f4VQ7ewfivyq9pC/6RSPVfXSfTRDvLa1aXKP2tu6Wcxu0QJ9DAnO4fetVGuTlwfXkDr7IhWuvUrY4nIESoZXfqeKkVJiOYijzjKxPXAQZwFGvGzrFH8nSYRIs3YqJIlz6saOHbKscKssXukMRzmX2H6n5jLrax2LqK/kv27GDik5+rGWmWV5Isizuso1htd/d56ze/NHFy2mu46wlxovcik4nBue7JRiW+StEIcHoS4qbXdwEGYf59b0DlG8KCDQ36vFZgd7gfm+sNIhkmjCT3xpxieaap4GFkE5GbnUIq+6LXX5e4ZnkbBjPXtNWE7xYY/TDCJd2Oj6qlX5+FSHDwTmI7T46XHc7i0nAvuZCyp9Lbnw7WQzVEMyTbdzfrBDXLWRvcjoVU+7xcoH88+RU0rVge4HWQ772WJ/zi/umF6JPifKP9VhJnjV81w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

So this patch is broken :P

Am getting:

[    2.002807] ------------[ cut here ]------------
[    2.003014] Voluntary context switch within RCU read-side critical section!
[    2.003022] WARNING: CPU: 1 PID: 202 at kernel/rcu/tree_plugin.h:332 rcu_note_context_switch+0x506/0x580
[    2.003643] Modules linked in:
[    2.003765] CPU: 1 UID: 0 PID: 202 Comm: dhcpcd Not tainted 6.16.0-rc5+ #41 PREEMPT(voluntary)
[    2.004103] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.17.0-1-1 04/01/2014
[    2.004460] RIP: 0010:rcu_note_context_switch+0x506/0x580
[    2.004669] Code: 00 00 00 0f 85 f5 fd ff ff 49 89 90 a8 00 00 00 e9 e9 fd ff ff c6 05 86 69 90 01 01 90 48 c7 c7 98 c3 90 b8 e8 cb b4 f5 ff 90 <0f> 0b 90 90 e9 38 fb ff ff 48 8b 7d 20 48 89 3c 24 e8 64 26 d5 00
[    2.005382] RSP: 0018:ffffb36b40607aa8 EFLAGS: 00010082
[    2.005585] RAX: 000000000000003f RBX: ffff9c044128ad00 RCX: 0000000000000027
[    2.005866] RDX: ffff9c0577c97f48 RSI: 0000000000000001 RDI: ffff9c0577c97f40
[    2.006136] RBP: ffff9c0577ca9f80 R08: 40000000ffffe1f7 R09: 0000000000000000
[    2.006411] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[    2.006692] R13: ffff9c04fb0423d0 R14: ffffffffb82e2600 R15: ffff9c044128ad00
[    2.006968] FS:  00007fd12e7d9740(0000) GS:ffff9c05be614000(0000) knlGS:0000000000000000
[    2.007281] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    2.007498] CR2: 00007ffe2f0d2798 CR3: 00000001bb8b1000 CR4: 0000000000750ef0
[    2.007770] PKRU: 55555554
[    2.007880] Call Trace:
[    2.007985]  <TASK>
[    2.008076]  __schedule+0x94/0xee0
[    2.008212]  ? __pfx_bit_wait_io+0x10/0x10
[    2.008370]  schedule+0x22/0xd0
[    2.008517]  io_schedule+0x41/0x60
[    2.008653]  bit_wait_io+0xc/0x60
[    2.008783]  __wait_on_bit+0x25/0x90
[    2.008925]  out_of_line_wait_on_bit+0x85/0x90
[    2.009104]  ? __pfx_wake_bit_function+0x10/0x10
[    2.009288]  __ext4_find_entry+0x2b2/0x470
[    2.009449]  ? __d_alloc+0x117/0x1d0
[    2.009591]  ext4_lookup+0x6b/0x1f0
[    2.009733]  path_openat+0x895/0x1030
[    2.009880]  do_filp_open+0xc3/0x150
[    2.010021]  ? do_anonymous_page+0x5b1/0xae0
[    2.010195]  do_sys_openat2+0x76/0xc0
[    2.010339]  __x64_sys_openat+0x4f/0x70
[    2.010490]  do_syscall_64+0xa4/0x260
[    2.010638]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[    2.010840] RIP: 0033:0x7fd12e0a2006
[    2.010984] Code: 5d e8 41 8b 93 08 03 00 00 59 5e 48 83 f8 fc 75 19 83 e2 39 83 fa 08 75 11 e8 26 ff ff ff 66 0f 1f 44 00 00 48 8b 45 10 0f 05 <48> 8b 5d f8 c9 c3 0f 1f 40 00 f3 0f 1e fa 55 48 89 e5 48 83 ec 08

and

[   23.004231] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
[   23.004464] rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-3): P202/6:b..l
[   23.004736] rcu: 	(detected by 2, t=21002 jiffies, g=-663, q=940 ncpus=4)
[   23.004992] task:dhcpcd          state:S stack:0     pid:202   tgid:202   ppid:196    task_flags:0x400140 flags:0x00004002
[   23.005416] Call Trace:
[   23.005515]  <TASK>
[   23.005603]  __schedule+0x3ca/0xee0
[   23.005754]  schedule+0x22/0xd0
[   23.005878]  schedule_hrtimeout_range_clock+0xf2/0x100
[   23.006075]  poll_schedule_timeout.constprop.0+0x32/0x80
[   23.006281]  do_sys_poll+0x3bb/0x550
[   23.006424]  ? __pfx_pollwake+0x10/0x10
[   23.006573]  ? __pfx_pollwake+0x10/0x10
[   23.006712]  ? __pfx_pollwake+0x10/0x10
[   23.006848]  __x64_sys_ppoll+0xc9/0x160
[   23.006993]  do_syscall_64+0xa4/0x260
[   23.007140]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   23.007339] RIP: 0033:0x7fd12e0a2006
[   23.007483] RSP: 002b:00007ffe2f0f28e0 EFLAGS: 00000202 ORIG_RAX: 000000000000010f
[   23.007770] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fd12e0a2006
[   23.008035] RDX: 0000000000000000 RSI: 0000000000000003 RDI: 000055abb0c5ae20
[   23.008309] RBP: 00007ffe2f0f2900 R08: 0000000000000008 R09: 0000000000000000
[   23.008588] R10: 00007ffe2f0f2c80 R11: 0000000000000202 R12: 000055abb0c3cd80
[   23.008869] R13: 00007ffe2f0f2c80 R14: 000055ab9297b5c0 R15: 0000000000000000
[   23.009141]  </TASK>

Here.

I identify the bug below.

On Wed, Jul 30, 2025 at 06:34:04PM -0700, Suren Baghdasaryan wrote:
> vma_start_read() can drop and reacquire RCU lock in certain failure
> cases. It's not apparent that the RCU session started by the caller of
> this function might be interrupted when vma_start_read() fails to lock
> the vma. This might become a source of subtle bugs and to prevent that
> we change the locking rules for vma_start_read() to drop RCU read lock
> upon failure. This way it's more obvious that RCU-protected objects are
> unsafe after vma locking fails.
>
> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
>  mm/mmap_lock.c | 76 +++++++++++++++++++++++++++++---------------------
>  1 file changed, 44 insertions(+), 32 deletions(-)
>
> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> index 10826f347a9f..0129db8f652f 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -136,15 +136,21 @@ void vma_mark_detached(struct vm_area_struct *vma)
>   * Returns the vma on success, NULL on failure to lock and EAGAIN if vma got
>   * detached.
>   *
> - * WARNING! The vma passed to this function cannot be used if the function
> - * fails to lock it because in certain cases RCU lock is dropped and then
> - * reacquired. Once RCU lock is dropped the vma can be concurently freed.
> + * WARNING! On entrance to this function RCU read lock should be held and it
> + * is released if function fails to lock the vma, therefore vma passed to this
> + * function cannot be used if the function fails to lock it.
> + * When vma is successfully locked, RCU read lock is kept intact and RCU read
> + * session is not interrupted. This is important when locking is done while
> + * walking the vma tree under RCU using vma_iterator because if the RCU lock
> + * is dropped, the iterator becomes invalid.
>   */

I feel like this is a bit of a wall of noise, can we add a clearly separated line like:

	...
	*

	* IMPORTANT: RCU lock must be held upon entering the function, but
        *            upon error IT IS RELEASED. The caller must handle this
	*            correctly.
	*/

>  static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
>  						    struct vm_area_struct *vma)
>  {

I was thinking we could split this out into a wrapper __vma_start_read()
function but then the stability check won't really fit properly so never
mind :)

> +	struct mm_struct *other_mm;
>  	int oldcnt;
>
> +	RCU_LOCKDEP_WARN(!rcu_read_lock_held(), "no rcu lock held");

Good to add this.

>  	/*
>  	 * Check before locking. A race might cause false locked result.
>  	 * We can use READ_ONCE() for the mm_lock_seq here, and don't need
> @@ -152,8 +158,10 @@ static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
>  	 * we don't rely on for anything - the mm_lock_seq read against which we
>  	 * need ordering is below.
>  	 */
> -	if (READ_ONCE(vma->vm_lock_seq) == READ_ONCE(mm->mm_lock_seq.sequence))
> -		return NULL;
> +	if (READ_ONCE(vma->vm_lock_seq) == READ_ONCE(mm->mm_lock_seq.sequence)) {
> +		vma = NULL;
> +		goto err;
> +	}
>
>  	/*
>  	 * If VMA_LOCK_OFFSET is set, __refcount_inc_not_zero_limited_acquire()
> @@ -164,7 +172,8 @@ static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
>  	if (unlikely(!__refcount_inc_not_zero_limited_acquire(&vma->vm_refcnt, &oldcnt,
>  							      VMA_REF_LIMIT))) {
>  		/* return EAGAIN if vma got detached from under us */
> -		return oldcnt ? NULL : ERR_PTR(-EAGAIN);
> +		vma = oldcnt ? NULL : ERR_PTR(-EAGAIN);
> +		goto err;
>  	}
>
>  	rwsem_acquire_read(&vma->vmlock_dep_map, 0, 1, _RET_IP_);
> @@ -175,23 +184,8 @@ static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
>  	 * is dropped and before rcuwait_wake_up(mm) is called. Grab it before
>  	 * releasing vma->vm_refcnt.
>  	 */

I feel like this comment above should be moved below to where the 'action' is.

> -	if (unlikely(vma->vm_mm != mm)) {
> -		/* Use a copy of vm_mm in case vma is freed after we drop vm_refcnt */
> -		struct mm_struct *other_mm = vma->vm_mm;
> -
> -		/*
> -		 * __mmdrop() is a heavy operation and we don't need RCU
> -		 * protection here. Release RCU lock during these operations.
> -		 * We reinstate the RCU read lock as the caller expects it to
> -		 * be held when this function returns even on error.
> -		 */
> -		rcu_read_unlock();
> -		mmgrab(other_mm);
> -		vma_refcount_put(vma);
> -		mmdrop(other_mm);
> -		rcu_read_lock();
> -		return NULL;
> -	}
> +	if (unlikely(vma->vm_mm != mm))
> +		goto err_unstable;
>
>  	/*
>  	 * Overflow of vm_lock_seq/mm_lock_seq might produce false locked result.
> @@ -206,10 +200,26 @@ static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
>  	 */
>  	if (unlikely(vma->vm_lock_seq == raw_read_seqcount(&mm->mm_lock_seq))) {
>  		vma_refcount_put(vma);
> -		return NULL;
> +		vma = NULL;
> +		goto err;
>  	}
>
>  	return vma;
> +err:
> +	rcu_read_unlock();
> +
> +	return vma;
> +err_unstable:

Move comment above here I think.

> +	/* Use a copy of vm_mm in case vma is freed after we drop vm_refcnt */
> +	other_mm = vma->vm_mm;
> +
> +	/* __mmdrop() is a heavy operation, do it after dropping RCU lock. */
> +	rcu_read_unlock();
> +	mmgrab(other_mm);
> +	vma_refcount_put(vma);
> +	mmdrop(other_mm);
> +
> +	return NULL;
>  }
>
>  /*
> @@ -223,8 +233,8 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
>  	MA_STATE(mas, &mm->mm_mt, address, address);
>  	struct vm_area_struct *vma;
>
> -	rcu_read_lock();
>  retry:
> +	rcu_read_lock();
>  	vma = mas_walk(&mas);
>  	if (!vma)
>  		goto inval;
                ^
                |---- this is incorrect, you took the RCU read lock above, but you don't unlock... :)

You can fix easily with:

	if (!vma) {
		rcu_read_unlock();
		goto inval;
	}

Which fixes the issue locally for me.

> @@ -241,6 +251,9 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
>  		/* Failed to lock the VMA */
>  		goto inval;
>  	}
> +
> +	rcu_read_unlock();
> +
>  	/*
>  	 * At this point, we have a stable reference to a VMA: The VMA is
>  	 * locked and we know it hasn't already been isolated.
> @@ -249,16 +262,14 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
>  	 */
>
>  	/* Check if the vma we locked is the right one. */
> -	if (unlikely(address < vma->vm_start || address >= vma->vm_end))
> -		goto inval_end_read;
> +	if (unlikely(address < vma->vm_start || address >= vma->vm_end)) {
> +		vma_end_read(vma);
> +		goto inval;
> +	}
>
> -	rcu_read_unlock();
>  	return vma;
>
> -inval_end_read:
> -	vma_end_read(vma);
>  inval:
> -	rcu_read_unlock();
>  	count_vm_vma_lock_event(VMA_LOCK_ABORT);
>  	return NULL;
>  }
> @@ -313,6 +324,7 @@ struct vm_area_struct *lock_next_vma(struct mm_struct *mm,
>  		 */
>  		if (PTR_ERR(vma) == -EAGAIN) {
>  			/* reset to search from the last address */
> +			rcu_read_lock();
>  			vma_iter_set(vmi, from_addr);
>  			goto retry;
>  		}
> @@ -342,9 +354,9 @@ struct vm_area_struct *lock_next_vma(struct mm_struct *mm,
>  	return vma;
>
>  fallback_unlock:
> +	rcu_read_unlock();
>  	vma_end_read(vma);
>  fallback:
> -	rcu_read_unlock();
>  	vma = lock_next_vma_under_mmap_lock(mm, vmi, from_addr);
>  	rcu_read_lock();
>  	/* Reinitialize the iterator after re-entering rcu read section */
> --
> 2.50.1.552.g942d659e1b-goog
>

