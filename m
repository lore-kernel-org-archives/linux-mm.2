Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DC9ACD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 00:32:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 086716B0005; Sun, 17 May 2026 20:32:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05D366B0088; Sun, 17 May 2026 20:32:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB5FC6B008C; Sun, 17 May 2026 20:32:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA3C76B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 20:32:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7B83CC2558
	for <linux-mm@kvack.org>; Mon, 18 May 2026 00:32:17 +0000 (UTC)
X-FDA: 84778663914.15.C46184E
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011004.outbound.protection.outlook.com [40.107.208.4])
	by imf08.hostedemail.com (Postfix) with ESMTP id 77B2816000D
	for <linux-mm@kvack.org>; Mon, 18 May 2026 00:32:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GmzzmXn3;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf08.hostedemail.com: domain of apopple@nvidia.com designates 40.107.208.4 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779064334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Ie2F+qnm3Bj5xbGSmcXpVP6WaiPIYzLB8TXbS8X9ss=;
	b=EyaDUBR8pbr0gFSPxp0KTBHuvc7sqw+KHhOtbq15QD+Wi1cl5nGLQ2u67wy7mJAfxxF8Vc
	91OtnxNKx2/oeGozlX9lwWGuM5KYx6xz+HCxZhaZ9PbzQPJEvGH4eeITJv/RiBm+1KOAoQ
	okuLQ5gNrfzhyvMm+DoyIifgUfqNBqU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779064334; a=rsa-sha256;
	cv=fail;
	b=KlHmNVm78QJtnBOeWNAi6hvjjw6UTrRidaBd6WDnybvL9MsBHDCCTLsqToX7wyVu08edWz
	JGz44o/zbQvtPZqMzr1i2+oZaJpNU69PbCCAQ0JLsKjF1J4OfyS2vs9ZQePe7fgKOSLQVu
	wRaZQDGrqrDzneScxTs89dDRYcmHQXs=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GmzzmXn3;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf08.hostedemail.com: domain of apopple@nvidia.com designates 40.107.208.4 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g+roCVL+uIHS53Dnj5zpEytCnnPC7PpqD3/47zVd1uEPE0E5p3JSeC+aqQXDfeatC1ujUyOYrAfGAiAhQJ8RymsW0NijmYFyRYO51dR/tiVIZd8PW+FVxro2jHp7Z0pX4wZ/cHmNhDSsP/cq08Y6bYEABjrKNOfac/fLK5jMUSoXaRG+l0QGAUEXHuUnFYq7dMuIstzMnfMlgmNaUNySO1CUAVu3IL7B8W8N3mygkQy6IbJS0tPmZuu9jZTPuip5Ht2htRJF2bvlOFCwqZK/xHSF9SfK/GBxGY+oTSYpESI2eSYvFI5iBbRLoHsB+h5HtVz6CtxNioETJC52HgyscA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Ie2F+qnm3Bj5xbGSmcXpVP6WaiPIYzLB8TXbS8X9ss=;
 b=L9Z93WiugH8iqTQxVCD7Wr+3po9pNamMG1nZzgQjDkh9AgNMmNCxy35vJs5X638e96hnVh0FC4GtXRl2usu5cpFOiSU77ipsBmzFCOpCB6RRHf+kpRzzd1oM7S3rVoyIjnUscxkKABEcUm8ec9xi/e5R2lUaYd94PHDTz1e57hsdFMS7Jq3GxeHO5uwR/S6PwxreP72nXkXOhcwoLbgMjKBjTg20S7D6pcedQ4fXhd7etaDxNmoLHL4KIs1WL66hZuA2NgMpCsL7qinUQayV9mhe4+vmhUb9j/XwUkohip7//jvich1sZzYdYFkQJ1Vr69AdedLRcJyrWJuJX96+5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Ie2F+qnm3Bj5xbGSmcXpVP6WaiPIYzLB8TXbS8X9ss=;
 b=GmzzmXn36S9rVNxp5jrC1DqIxZiX/XeWlN5XyuEeU009YQTo8wAozOjMph+/5Jqu3ahLjhxLSsR4coehfQATNPx+E5sch+t1nnsoRct01nUB9pnbXrkgBDpym8ZnUo80FYlN+CHAoHyyXNTCyVL8Hz27GEzGoSyjtaBUCeuhxi4XgXN4wLJd8glMBkyB8iLD5pjGcSk0EoM6ITzWLIpeMvEv+w6Nvs4ZRD8JdiwOA222N3Fatxee0XCdM1vlkobqOTUpT6rZ2zG1qtCIhBNRAqj/pU3YseTNTIo1pAvcpuzeSF0lQtkN46NgxAoS+ZiZRA1No1NbnJ64t9uWRgtJcw==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 PH7PR12MB6666.namprd12.prod.outlook.com (2603:10b6:510:1a8::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.23; Mon, 18 May 2026 00:32:08 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.21.0025.020; Mon, 18 May 2026
 00:32:08 +0000
Date: Mon, 18 May 2026 10:32:03 +1000
From: Alistair Popple <apopple@nvidia.com>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: tglx@kernel.org, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, arnd@arndb.de, rppt@kernel.org, akpm@linux-foundation.org, 
	david@kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/4] mm: use arch store helpers in zone-device template
 copies
Message-ID: <agpaXHqh1gJE_xcQ@nvdebian.thelocal>
References: <20260515082045.63029-1-lizhe.67@bytedance.com>
 <20260515082045.63029-5-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260515082045.63029-5-lizhe.67@bytedance.com>
X-ClientProxiedBy: SY5P300CA0026.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:1ff::15) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|PH7PR12MB6666:EE_
X-MS-Office365-Filtering-Correlation-Id: d1a2780c-694c-4398-e0ca-08deb474e4ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|56012099003|22082099003|18002099003|3023799003|4143699003|11063799003;
X-Microsoft-Antispam-Message-Info:
	W4i8TmzdiSO0fZFKDyqxOQtZN0owIinBZ9ATjfexd7obmD77gIEYGFHY3NTIWHAkYrlASM+c++1UCSQT8Sw4Tl0hzVTbvUGt8OS8jH+flF49/lfO0EWimDsPAAv6gba2ncTNjRBR5WkKjSfTLdqCgeWfyqIlL2C9nLRdMmca8v/MMzlKgFCTf0yZI8x+Q17Xdq9Tw8XIc4l3DkJNtiXg794at5mpNDhT2GlQ9LR0WU/ijeFoBWBu0RrOs/sWxAJXFvdmboxY889G9Zdor+2/12MVQi/8UegOZj0YtIg6+y0OiS+eGUyW+WMqea5qobXtf4gQG2jLsxgOSNVwQ9rrlY7WxdILsQpOqRqV+ZvVPGFFImqwGWJ2NFshGStYCtFlwtCDMHmSX3C+zCx5w7dwm4ySHWis8lJ+RAayQLBTzooCi+ahvGPf8dvpDSwGSzVw7VW6+3s+AvFtCfshMG4NHRnjcmK+mF5bwquluQviFYCXLbGOlF0ioNUiaL+zHgqkAXMV8WKsm8foBC5KmvyHyT+8Llbwpv+UWKJfG2XEoEVfvhCLqoU5wBPu77OFmH7vPMFuEeuGvOkee6wboQaHQ6x4k1priWxkrD5DSolxrwljAuoNPN4wq3/drW8gZ8NaoRT0BGMAO4XY1ZVTfsgwgoenw9dMfN3seB/xMGb07+o98tJBQe1NeqLkYt2ShE1m
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(56012099003)(22082099003)(18002099003)(3023799003)(4143699003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8nugIDPKl1DjIsrmvMupyMtPZGW2eYCtGF9Vbk25NIIaAictkeqpSLY+nMhO?=
 =?us-ascii?Q?8q4be6zrZdSWtSAC79t6O82QCLERkifl64fU+CzK6QDtScehiE3critO32Dg?=
 =?us-ascii?Q?riKYRzesbktQY60gN6XQgD50uA+OM7dZso5NqzgaO2FqSYXiWl/J0sT5uZC+?=
 =?us-ascii?Q?UKUVTCvxYOYEOTeOvDjHyqDJfB/2auyLlet2Ufp327N7nUV/qRqZiaVR2v8+?=
 =?us-ascii?Q?X8t9sKtiur2WF++GekambYMEA1UfRKhvY3WeZd9O7/b5HrNTJjBRf4yTTLiC?=
 =?us-ascii?Q?0OHqrHKMlc4mdFi8aKxw5zts5rEtqvaGAI3loQuWOvD9AvjFMADzsMFAC7SC?=
 =?us-ascii?Q?qR3Ixdey7t78LsaK3V6vBRHGHQKfwn/Tii3SZJ0nbczAJ0ls4Zw+gjo0ka3L?=
 =?us-ascii?Q?+BCyPiy9J9Dq0zw1go40/GezUsdmxebPpFJ1Ldsv5Eho9zY6uxxacr07jxyf?=
 =?us-ascii?Q?OD00ppVWHE/mf1u5T621FpUe5iwZ9X6mmkmMPg4IMAco2izWjSUWEAjF+7LM?=
 =?us-ascii?Q?S9buIrwrsNG5RBavNOKYgVFNXGQaJCYn4SjuiWkCY0rLl/nWQMiwFOfiw0fV?=
 =?us-ascii?Q?HSp6xWU4u3L1PBRbqd5+Rb7qqUPazrMDGrmGvsirCTicKb9TzqQVfrH/dIiV?=
 =?us-ascii?Q?TeK7ShNQznDhl3LgAL1fg0eXvDlxYWKr28Tjbl0g0XB0LsczFZjlxFxIpWsp?=
 =?us-ascii?Q?8EQrWH1jqagqgsu6owacvoi7HMw+FxKZXTo/TfLaADqHmU9Bfx9qv0L4TkyO?=
 =?us-ascii?Q?xV3uH9bS4HmE6IpNoN76CkWqV7Ko9+Gn3+rp48WsWMhNEFKXPRQf01Koqog/?=
 =?us-ascii?Q?5z54nQBT+0YOz/eDNF5QWH9X9yZuq50crxk23LhQTV4ZJBgVvF9qgMQbmzYB?=
 =?us-ascii?Q?pvD93ILHBV8hO55OjHaXCduhMg4KCAEIPJUcM+PmcZKls+GzcHVaybRpJAEy?=
 =?us-ascii?Q?uF9p83Q26I0Ty72c3xFz5i6WOxeIBTnNF3w2mIB+QVSQdBUwAbY783xuR408?=
 =?us-ascii?Q?ZS5P9Vt8cvkkSyTBZd3aLbkMpTPuCI3v61qqnzrVVDOXivkujz7HAC8jDvBp?=
 =?us-ascii?Q?GELNojcDFzDokcR8vQuR607m8CtfWRgPuQxX37CXlL5IPhuU58bqPbafkY4h?=
 =?us-ascii?Q?8RO0ABVvOvd/KFN1T2Rk6fd3UmDol868GKVonWHrfrGBvmpnGb/2m39EqAx4?=
 =?us-ascii?Q?cf6P4emM6Sqn7/1ST9qatfDa1BXdQ/4AnTDvxar0icJFvO6o0KtOhFtPyK+j?=
 =?us-ascii?Q?oUVCNZtKPOPgX1edCaSFbkBlYIpo0e+Fzp3dK+I+jhAKxr7eP3ecENiSOyVM?=
 =?us-ascii?Q?mdgcSui/aNQQJCBrTwHhTDAhd138IkidVlFT4RhIxX2Cwd3JDNRMrJhXj5Xl?=
 =?us-ascii?Q?KkNp9JlaqrK3oonU55nL+aB0xAvfhTaunaYyVUfb8SCi63JmiIl6rI1kR7AG?=
 =?us-ascii?Q?XYpSw7oBOGjnfvnC0Bxbd/h6ax5em1DpxRI/kei71ODZ+OmnKMWfJrkz2WvV?=
 =?us-ascii?Q?l+Q1HoPe1UKhT/tJl50Kj+HbfFM92dFJfC+72TSigtVA7JvF+2EBKq2vrEA1?=
 =?us-ascii?Q?IWI7qv3PIkUQJn9f88Xt7hnRU7tdzjSZROnPXRm80n1LprmcrkCEF1xKv3Gf?=
 =?us-ascii?Q?75T7EptHr6NZ3RDDbeFudU6Zm4SpncWJ5J8e8K1X8d3+2SJcQAmI9uDlcwmt?=
 =?us-ascii?Q?jidZU13tRj95ZPwbx5HCtrLTFTlaq/6OtqqbCJXKRwVEvgdbqE0JMm9OeB5+?=
 =?us-ascii?Q?whTWVmsgGQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1a2780c-694c-4398-e0ca-08deb474e4ee
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 00:32:08.5327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aUxaJ7e9J23tkaDihDExyNG62qOWNKCGqKEQphlSaJtdKMw4ZYa+8aeHjhI7Du7hGmLqLPNkUPnxJyTCmUyYmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6666
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 77B2816000D
X-Stat-Signature: 76e8n3z1fj3rurcng1j6io7fjppumwxg
X-Rspam-User: 
X-HE-Tag: 1779064334-620142
X-HE-Meta: U2FsdGVkX18h1A8805FpVBdjQb5MFQj4M0RJMb0mOjBVDGm5ciYqDxNXKRCY5VJamT8RZWAjO68f1TZ/B7T9tdI/T6HsAiantSnxl+eGBNbvMNnElE8ZQ76pfIsvNGNiCfEimDIaKVHxOy4oL49W7x7Xc19gB2qP4e/3gXGR2/QsdPQQtdqWR8pkraRcZxQkZwZX9jyzHSn807NfVVyqv0jIjx+gMJuQwrTPWPnbYXQtGMhMWo90FlqbM6LgC628muNwSYYJ+WixzsHZkvC93S8Jby2GpIJC32bxaFyejZ5j2B6QQTJTUfqSFpNcChRGLD0jFSsti8tTAHuuNFBWtx6Ms08ynp61dLYq+s1/t67w4HaXhh2E2y13RRPGJ5RVpu9u2g6+lfcUYj7KSg7ZTkx8r/mRk4UG9dWXRyWhtIbkfXbgrcf3Epm1aZ/PqHMJDFESqzC6LXRiL05JKgRVhZxfMCKYmqn/c+wH/doaZ8Xhafvz33WjNfFg/HLO81YVtGL8jzBEiXrSVDIpAXqc7CkvmctMukeXuM9N5agDT1ZTfyodx//YirV2jdsNg9ZVtVWCuSk3hzYk0XqAFC/cZooX2eHzfcCLN2/8i6WZcMygKCryuWueWdvV8YRZ9n865+9RwgCC121wYkwFo1nGChbP3MqmyxcPTkBInze4YeARmxgsaxYKd3t2RYbhIHrBUE5Raj6jTVrX2AqcfChN8oWikeMTk/lbY4dMA6KDeNqd0WAzjHa4tIMGIf+KXd6cv3/NxSPacDJ4RNVfFb19dQhs1P8xN31Umz86I5zpSs6KepEBUrfqH4uD19ASMsCPEXbkCt5JEfX/4uhNF/1o9eG8hSCx4D2GmfrvLGhyDRG9CiXMKyrk0Q3KueMvO8+YGDY1TPq2MP7o8i2+SiqmvJFoScks9gHCWOZSt1x6mP/Ygv875sbTphwBNFBThUfu6T6kW/ieeINSfqCPxtA
 H/C7LRjs
 glc+zGM1kEoudfMlZvCLYUHur/Qr2pE/st/x0CQ7X7bEZNsTvHFLKbuGBUI1RWyWZtF2NLJwcYfi1ESXPySwE3LGG0pWc1P1scdeuCUNSyt6+0rZ8nENw1b7zgDHWCiO0h4+++og5S+SO7jGmQD1QONEOSu1FrT9KQ8P6djctPzzYNsiEB399raXnPYvpukZFMcFzE+wbCje/hM82cxhp6f6yPsYKbSa1O6NuxosY1TkkWHcMqDusPBolXkRiXJdnoB2WuzB94d7wwDCcZCi9+d1PuS/SYDHkZmiemGdrFpOu049CbUSRcwMZfnH2o8gyrl4C7urL7NdgWPPIGe/R0/1tzeHPpBXeJu6U8TbALk0K2QMFZftX03YuiEkbiAIxTEOHhxPaHHSRhPPeOLHp8793sDu/gQDNDKGMRRhDkHqldyk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-15 at 18:20 +1000, Li Zhe <lizhe.67@bytedance.com> wrote...
> The template-based fast path still leaves the actual copy sequence up to
> the compiler. On x86-64 that can easily degrade back into a runtime copy
> loop in the hot path, which leaves performance on the table.
>
> Introduce arch_optimize_store_u64() and arch_optimize_store_drain(),
> with a generic fallback and an x86-64 MOVNTI/SFENCE implementation, and
> use them in the template copy path. Also open-code the word-at-a-time
> copy so the compiler emits fixed-offset stores for the hot path instead
> of a runtime loop.
>
> On x86-64, MOVNTI is a better fit for this write-once, streaming
> initialization pattern than normal cached stores. It reduces the
> write-allocate traffic and cache pollution that a regular store sequence
> would otherwise generate while filling large ranges of struct page.

The perf improvement looks good so thanks for looking at this, however open
coding this and introducing arch-specific code layout into a generic layer is
not the right approach. The correct solution would be to implement a memcpy
implementation/variant that is optimised for write-once streaming operations
that can transparently degrade to memcpy on unoptimised architectures.

A grep of the kernel sources for movnti shows there is a memcpy_flushcache()
variant. Maybe that could work here?

> Refresh the PFN-dependent section bits and page->virtual state in the
> reusable template before each copy, instead of patching the destination
> page afterwards. This keeps the hot path as a fixed-offset store
> sequence and avoids post-copy normal stores to cachelines that were
> just written with non-temporal stores.
> 
> Because non-temporal stores are not ordered against later normal stores,
> drain outstanding stores before memmap_init_compound() updates compound
> heads and before memmap_init_zone_device() returns.
> 
> Disable the x86-64 override under KASAN or KMSAN so those builds keep
> their instrumented stores through the generic fallback.
> 
> Tested in a VM with a 100 GB fsdax namespace device configured with
> map=dev and a 100 GB devdax namespace (align=2097152) on Intel Ice Lake
> server.
> 
> Test procedure:
> Rebind the nd_pmem and dax_pmem driver 30 times and collect the memmap
> initialization time from the pr_debug() output of
> memmap_init_zone_device().
> 
> Base(v7.1-rc3):
>   First binding for nd_pmem driver: 1486 ms
>   Average of subsequent rebinds: 273.52 ms
> 
>   First binding for dax_pmem driver: 1515 ms
>   Average of subsequent rebinds: 313.45 ms
> 
> With this patch:
>   First binding for nd_pmem driver: 1272 ms
>   Average of subsequent rebinds: 104.59 ms
> 
>   First binding for dax_pmem driver: 1286 ms
>   Average of subsequent rebinds: 116.93 ms
> 

> This reduces the average rebind time by about 61.8% for nd_pmem and
> 62.7% for dax_pmem.

Nice - is this the improvment from applying the whole patch series or just this
change?

> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
>  arch/x86/include/asm/struct_page_init.h | 28 ++++++++
>  include/asm-generic/Kbuild              |  1 +
>  include/asm-generic/struct_page_init.h  | 17 +++++
>  mm/mm_init.c                            | 89 +++++++++++++++++++++----
>  4 files changed, 122 insertions(+), 13 deletions(-)
>  create mode 100644 arch/x86/include/asm/struct_page_init.h
>  create mode 100644 include/asm-generic/struct_page_init.h
> 
> diff --git a/arch/x86/include/asm/struct_page_init.h b/arch/x86/include/asm/struct_page_init.h
> new file mode 100644
> index 000000000000..de8b4eab44de
> --- /dev/null
> +++ b/arch/x86/include/asm/struct_page_init.h
> @@ -0,0 +1,28 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_X86_STRUCT_PAGE_INIT_H
> +#define _ASM_X86_STRUCT_PAGE_INIT_H
> +
> +#include <linux/compiler.h>
> +#include <linux/types.h>
> +
> +/*
> + * x86-64 guarantees SSE2, so MOVNTI and SFENCE are always available there.
> + *
> + * KASAN/KMSAN rely on compiler-instrumented stores. Keep the x86 override
> + * disabled for those configs and fall back to plain stores instead.
> + */
> +#if defined(CONFIG_X86_64) && !defined(CONFIG_KASAN) && !defined(CONFIG_KMSAN)
> +static __always_inline void arch_optimize_store_u64(u64 *dst, u64 val)
> +{
> +	asm volatile("movnti %1, %0" : "=m"(*dst) : "r"(val));
> +}
> +
> +static __always_inline void arch_optimize_store_drain(void)
> +{
> +	asm volatile("sfence" : : : "memory");
> +}
> +#else
> +#include <asm-generic/struct_page_init.h>
> +#endif
> +
> +#endif /* _ASM_X86_STRUCT_PAGE_INIT_H */
> diff --git a/include/asm-generic/Kbuild b/include/asm-generic/Kbuild
> index 2c53a1e0b760..3a493fed6803 100644
> --- a/include/asm-generic/Kbuild
> +++ b/include/asm-generic/Kbuild
> @@ -65,3 +65,4 @@ mandatory-y += vermagic.h
>  mandatory-y += vga.h
>  mandatory-y += video.h
>  mandatory-y += word-at-a-time.h
> +mandatory-y += struct_page_init.h
> diff --git a/include/asm-generic/struct_page_init.h b/include/asm-generic/struct_page_init.h
> new file mode 100644
> index 000000000000..45a722103a51
> --- /dev/null
> +++ b/include/asm-generic/struct_page_init.h
> @@ -0,0 +1,17 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_GENERIC_STRUCT_PAGE_INIT_H
> +#define _ASM_GENERIC_STRUCT_PAGE_INIT_H
> +
> +#include <linux/compiler.h>
> +#include <linux/types.h>
> +
> +static __always_inline void arch_optimize_store_u64(u64 *dst, u64 val)
> +{
> +	*dst = val;
> +}
> +
> +static __always_inline void arch_optimize_store_drain(void)
> +{
> +}
> +
> +#endif /* _ASM_GENERIC_STRUCT_PAGE_INIT_H */
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 5a9e6ecfa894..a3211666ccd4 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -37,6 +37,7 @@
>  #include "shuffle.h"
>  
>  #include <asm/setup.h>
> +#include <asm/struct_page_init.h>
>  
>  #ifndef CONFIG_NUMA
>  unsigned long max_mapnr;
> @@ -1078,9 +1079,21 @@ static inline bool zone_device_page_init_optimization_enabled(void)
>  	return !page_ref_tracepoint_active(page_ref_set);
>  }
>  
> +/*
> + * The fast path copies struct page with fixed-offset u64 stores instead of
> + * a runtime loop. Keep that copy sequence in sync with the struct page
> + * layouts supported by this build.
> + *
> + * The sequence below requires struct page to be u64-aligned and currently
> + * handles layouts from 7 to 12 u64 words (56 to 96 bytes). If a future
> + * layout falls outside that range, fail the build so the store sequence is
> + * updated together with the layout change.
> + */
>  static inline void struct_page_layout_check(void)
>  {
>  	BUILD_BUG_ON(sizeof(struct page) & (sizeof(u64) - 1));
> +	BUILD_BUG_ON(sizeof(struct page) < 56);
> +	BUILD_BUG_ON(sizeof(struct page) > 96);

This would be uneccessary without the open-coded memcpy and is another reason to
prefer a more generic approach.

>  }
>  
>  static inline void init_template_head_page(struct page *template,
> @@ -1108,30 +1121,67 @@ static inline void init_template_tail_page(struct page *template,
>  }
>  
>  /*
> - * Initialize parts that differ from the template
> + * 'template' is a reusable page prototype rather than a strictly immutable
> + * object. Most ZONE_DEVICE fields stay constant across the pages covered by
> + * the current template, but section bits and page->virtual may still depend
> + * on the PFN. Refresh those PFN-dependent fields in the template before
> + * copying it into @page.
>   */
> -static inline void generic_init_zone_device_page_finish(struct page *page,
> -							unsigned long pfn)
> +static inline void zone_device_page_update_template(struct page *template,
> +						    unsigned long pfn)
>  {
>  #ifdef SECTION_IN_PAGE_FLAGS
> -	set_page_section(page, pfn_to_section_nr(pfn));
> +	set_page_section(template, pfn_to_section_nr(pfn));
>  #endif
>  #ifdef WANT_PAGE_VIRTUAL
>  	if (!is_highmem_idx(ZONE_DEVICE))
> -		set_page_address(page, __va(pfn << PAGE_SHIFT));
> +		set_page_address(template, __va(pfn << PAGE_SHIFT));
>  #endif
>  }
>  
>  static void init_zone_device_page_from_template(struct page *page,
> -		unsigned long pfn, const struct page *template)
> +		unsigned long pfn, struct page *template)
>  {
>  	const u64 *src = (const u64 *)template;
>  	u64 *dst = (u64 *)page;
> -	unsigned int i;
>  
> -	for (i = 0; i < sizeof(struct page) / sizeof(u64); i++)
> -		dst[i] = src[i];
> -	generic_init_zone_device_page_finish(page, pfn);
> +	/*
> +	 * 'template' carries the invariant portion of a ZONE_DEVICE struct
> +	 * page. Update the PFN-dependent fields in place before copying it
> +	 * to the destination page.
> +	 */
> +	zone_device_page_update_template(template, pfn);
> +
> +	/*
> +	 * Keep the copy open-coded so the compiler emits fixed-offset stores
> +	 * for the hot path instead of a runtime copy loop.
> +	 */
> +	switch (sizeof(struct page)) {
> +	case 96:
> +		arch_optimize_store_u64(&dst[11], src[11]);
> +		fallthrough;
> +	case 88:
> +		arch_optimize_store_u64(&dst[10], src[10]);
> +		fallthrough;
> +	case 80:
> +		arch_optimize_store_u64(&dst[9], src[9]);
> +		fallthrough;
> +	case 72:
> +		arch_optimize_store_u64(&dst[8], src[8]);
> +		fallthrough;
> +	case 64:
> +		arch_optimize_store_u64(&dst[7], src[7]);
> +		fallthrough;
> +	case 56:
> +		arch_optimize_store_u64(&dst[6], src[6]);
> +		arch_optimize_store_u64(&dst[5], src[5]);
> +		arch_optimize_store_u64(&dst[4], src[4]);
> +		arch_optimize_store_u64(&dst[3], src[3]);
> +		arch_optimize_store_u64(&dst[2], src[2]);
> +		arch_optimize_store_u64(&dst[1], src[1]);
> +		arch_optimize_store_u64(&dst[0], src[0]);
> +	}
> +

I don't think unrolling the copy here is the right approach. This belongs in
some kind of generic streaming memcpy routine.

 - Alistair

>  	zone_device_page_init_pageblock(page, pfn);
>  }
>  #else
> @@ -1201,9 +1251,10 @@ static void __ref memmap_init_compound(struct page *head,
>  	__SetPageHead(head);
>  
>  	/*
> -	 * A tail template can be reused for all tail pages in the same compound page
> -	 * because shared state for compound tails is pre-set by prep_compound_tail().
> -	 * The per-page page->virtual and section in flags are fixed up after copying.
> +	 * All tails of the same compound page share the state established by
> +	 * prep_compound_tail(). Reuse one tail template for the whole range
> +	 * and refresh only the PFN-dependent fields in that template before
> +	 * each copy.
>  	 */
>  	if (use_template)
>  		init_template_tail_page(&template, head_pfn + 1, zone_idx, nid,
> @@ -1269,10 +1320,22 @@ void __ref memmap_init_zone_device(struct zone *zone,
>  		if (pfns_per_compound == 1)
>  			continue;
>  
> +		/*
> +		 * Compound-head setup immediately updates head->flags, so make
> +		 * the template copy visible before entering memmap_init_compound().
> +		 */
> +		if (use_template)
> +			arch_optimize_store_drain();
> +
>  		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
>  				     compound_nr_pages(altmap, pgmap),
>  				     use_template);
>  	}
> +	/*
> +	 * Drain any remaining non-temporal stores before returning.
> +	 */
> +	if (use_template)
> +		arch_optimize_store_drain();
>  
>  	pr_debug("%s initialised %lu pages in %ums\n", __func__,
>  		nr_pages, jiffies_to_msecs(jiffies - start));
> -- 
> 2.20.1
> 

