Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 329F2CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 03:37:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FEDA8E000B; Tue, 21 Oct 2025 23:37:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AFAC8E0002; Tue, 21 Oct 2025 23:37:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79E878E000B; Tue, 21 Oct 2025 23:37:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 68ECE8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 23:37:07 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 119611406FD
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 03:37:07 +0000 (UTC)
X-FDA: 84024339294.19.BC3CB1B
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010014.outbound.protection.outlook.com [52.101.56.14])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4564B180003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 03:37:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JZs6cdev;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.14 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761104224; a=rsa-sha256;
	cv=pass;
	b=d1yHF7VUCSWuQyZ7soPBR0Jj2o8yDmDIEeUjWXfAgcn9GHGU1q8yjd9fkeFUMS+8o71Jpw
	bgjuO9b9AMzCMFB5N7SVDbuyeN+sFu3kcme5aKyfq3tSCY8GEYgKK5ZO4HUVPgwItEpy0r
	wcbyVhKOlIIAJ2tOu5ZTnkLCXUFK+HU=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JZs6cdev;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.14 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761104224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YNWpJDD8I94LJ2Ocy7mlNJTkesGvDb/m3LvR8DBD1WU=;
	b=OG5LLa56Q1DphsoswYAngwxVflF+UCrIY/XSnCEFOGBdyoeyulamAmCJQtCJwzdFItTM9v
	e/QmYQ6iozPysG5Dpnp1WYUzKx/Y6UsgBgj54VQKU3ZlrJGygHCviCmqcIWdbPF0n2ulhI
	cC7k5yphn8lgwK/R83SuGjlkv5xeXrE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UU0oWbRBcM6Ye9rgCAs0zwQ38QfIe1hp8EjQMpKG4lc/1BK+f53A2tyzUFv+bPKAOs85XaIvcvq/kEM3TdMJAEQhEg5dD/FSHCAPkqyr4Cw1dRtTak3rtpm0qm4/AIXE8vrTXUTjUutM/KPpjVimscUqS6llxv/r+npAMa3uF03T2Hpg5L6RdCGa6hl+BDiXq2nebe/7s9Viqyc6ujiM3/cufeDiDH0KwJWxjkU+dwyp/UIfovLSff5pkM9ecUO2gomfSJsfkvuRFxZaRmvHlD6pL07imw/xlcQ/83xWRBafI+X+UbZ5A2DDEHgtWlNEpHoVMFrrT72Q5QJs7g8ZXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YNWpJDD8I94LJ2Ocy7mlNJTkesGvDb/m3LvR8DBD1WU=;
 b=Pjgxj3RTKLl3B4yp7bk+6Pj0dO/PHBhRmSDKVOxdRMusMDCs+sXCTT/T3SNgqmBbGQ9YLbnXcsf+705GXvvUgXNiBnYANQ5M+IZlgFilTVYX6+5NfBbnM8Z+/BTnFoKUTx8aEXw3FFZHcD2q2LLZYzVIT2pTGT4WsX8UY7E25ThpwbRWP0HBI7BS5W0BIznV5TxLaSvDmkOVLwN6M3pKEbiQp+lw/TbsrHtegSUWDHRwa4zBb73kJXASxdfe6xSeNqspdzWE+O8vE1W5dTXdKslSbuGBl34012wJ8JsTu1yJOQODqqIXXaqxvZOKJBDt8LrUFnqt/1g34YeDEQ3s6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YNWpJDD8I94LJ2Ocy7mlNJTkesGvDb/m3LvR8DBD1WU=;
 b=JZs6cdevuWWk/qmZjxZ8ap4W6eDYwEH7csIPdNakO/WmRMLjD/CmmSqUiyo4vPQguY74Qm7ibNnUZxs5vi5rKFCTnnFTWYeRWu69i51q4H0Zd8+6YoaXJNQO30C5CH9EhvTrtmu1O2vmKtfQ7yr29X47GGyBJMPgFZg7UTrfc7A+Kbd0NC1/SvcYa6aKFIXUiQZUltc6eKz9X3LI8i49RqZpTfGZkQv1RtJ4RwTqNH/Z7OPCiWkOHijrIuI3Q1FDkJWxePncUhnYH2fjwA2YCm7xx2D/NjUdgyDKKbw6Q7wRirWi96lFmboKYXS/4omLCrGVLwrYa9CRpgCHlpKKYQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ1PR12MB6268.namprd12.prod.outlook.com (2603:10b6:a03:455::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Wed, 22 Oct
 2025 03:36:47 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 03:36:47 +0000
From: Zi Yan <ziy@nvidia.com>
To: linmiaohe@huawei.com,
	david@redhat.com,
	jane.chu@oracle.com
Cc: kernel@pankajraghav.com,
	ziy@nvidia.com,
	akpm@linux-foundation.org,
	mcgrof@kernel.org,
	nao.horiguchi@gmail.com,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Yang Shi <shy828301@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 1/4] mm/huge_memory: preserve PG_has_hwpoisoned if a folio is split to >0 order
Date: Tue, 21 Oct 2025 23:35:27 -0400
Message-ID: <20251022033531.389351-2-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251022033531.389351-1-ziy@nvidia.com>
References: <20251022033531.389351-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:208:c0::32) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ1PR12MB6268:EE_
X-MS-Office365-Filtering-Correlation-Id: 779f291d-08a1-413b-286d-08de111c3a95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?t/RsHpjAAdfaQuIIcHNV96jmFRMELSZz0QA2D+v0I75gJAF4R/O+/fSZgcR8?=
 =?us-ascii?Q?EyE3eNqZbe32PAge47elPH4UA+UpQHsFZyOjOLD0HmIdy/ZHixR33NryPYZN?=
 =?us-ascii?Q?LSdwINH3UrYH/PbZXANojprHZZlU51OQmMlfCFJPVBdMyZ4XhDEFGdkDB2PY?=
 =?us-ascii?Q?/EnbcEi1+iOlFp4S7tnuPLqoOBWIWyJClkY76bPjUZ8eipt10db0/aWta+67?=
 =?us-ascii?Q?zhsbDA6cn97CpK5KoPx0O/KtehOXRb7wuwF2KDiHOk/Z0Q937tmwN52M+FHF?=
 =?us-ascii?Q?WeHIOK1kYqbT0lLfRcYKfM+q9hCAv2TApZr86m+YQ4dJCdKBvb8vcbwIjGbH?=
 =?us-ascii?Q?VXep5WmrD7R93V4Zmi5r4YIiAHBZgs7kqlyxYlsEF0t3F8mhDllEDkxlFpV2?=
 =?us-ascii?Q?JOx13JLqozszGWKr25szJ+knP8PD1IpSfUCf0+lPmFh6msgeXGVym4ptmCAa?=
 =?us-ascii?Q?IDsjtip3cwJFBYq5r11UImjF3QWRxyXSdbQ3dR/2xFWVcTQ1HbWRAZk68TMN?=
 =?us-ascii?Q?McFphk31GtpIjhtAHzbm4aELNm0d/i1r8c3eckmnFkcZZfW/jINfgETINx0X?=
 =?us-ascii?Q?dly3FRHtn3N+TuLRiXZlLEagc9Bs8AbZKzoYk5kSSJgcWvbG2B66RRmRpWxO?=
 =?us-ascii?Q?ly3sS+ngWmQrIHMTAffDZ0zNrRpFCe98R4KCDD1HFx4t0iql/AUyIMnWhMFp?=
 =?us-ascii?Q?GOyBtf2bySAyTfFZBJMOFLZOnUGaWcfpYDRgakZOmlwv67e4uuFgPVuGawB3?=
 =?us-ascii?Q?tLUhlLFifdoXQRQiXR5Etd9ZCY6FEhVAnfom8HBsScOyhjWRLCw28h6n32xB?=
 =?us-ascii?Q?SErrljbvncZmQ8e/UfqxTCahgY9mGMM492RAvHk+IoA856RnlA8NSNGCD08u?=
 =?us-ascii?Q?39gQ43n40Sg+zhEHqxebxX0R9aRVUdicf+6PBZ6EQWI+8jHnvk2HOCY9ixZq?=
 =?us-ascii?Q?6Z1kX0sensWH77A76DSliCtNhv/+L3Lt9fslmwSaKZTeM0wN8sbuHHY5eGtL?=
 =?us-ascii?Q?A7qNz8yKZ8h+V9JIEwjCVXiQXYdg+7G8eYtJeb26PjGxE29fjrbk2P61G07Q?=
 =?us-ascii?Q?2IyEIOyHJvzEAoiYNdvBuKhGZxSe+2J/bTtMo6wcJPUugAi/3+e81NiXVWm+?=
 =?us-ascii?Q?FCgrjd/Xt45Pc5HSF8UbpdeICdHy7AXgckaYQ2NjxM4Zsj5TXsnT++L9i+1h?=
 =?us-ascii?Q?FnnCImgBgiMByL8LHPWnQJ7wrYAjfuV0bgVZLRRJK9DvtGG34LbkUCX3Se0h?=
 =?us-ascii?Q?sb/1VaZ3bBMBjH3XybHv+QQhi10R/vC63hASdPW09hPk21GTmI7P5xDA+hqr?=
 =?us-ascii?Q?5ZrGishr2b5Xobz6woD4NDM8ieXTmHl+rLMq7GPju8wV6BmszCKKa30GT9/i?=
 =?us-ascii?Q?MIqTNPEsB/XWQYBH4y+NCv4AxodhSpdd6TzhdwETsVQaeQqT+JSzFWTpffzb?=
 =?us-ascii?Q?12uj5TXlavqsgh+ivFr4ZAWWouU6uvy64xQJ4O4xxJBypueIgDJ5sA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZC5e3qP57iKK0ufLS3LlyD6J1Xw2BV5sHDt500XQRW9qPFCfqdv3+DShCAzL?=
 =?us-ascii?Q?QGydNwu+1QAP0DI145I27iAvcqzdToXYlol3JNtR7sEOpPwBh17XxSzcfGTo?=
 =?us-ascii?Q?+xugLUAnZqrPQsIGvjvXy/8GnYd/jHpDHATaf4KkUTkB3hvI/q9SdVZqFMCx?=
 =?us-ascii?Q?mckTCTXX5gxo5I8o7hCjgZSc1SMeEuabK5DpRk/nhHCbOAdUEGld7nrlhh36?=
 =?us-ascii?Q?Vz4gK/CYDWeNukEbCG3LEtfiad819qO3vBQxSU+2/VS7v+7rsivxZoYGvf7k?=
 =?us-ascii?Q?5Opt8pMbrUQZ5mp8T9yo8eDFtS9Y0WPVMkaXANkFSdeYoLpaM3QBHamziAau?=
 =?us-ascii?Q?dWXvB/eZVRNO9kPCuuAwuTOdeBCZkvmwRJlZaYKMsBYRNmY78R0uDoT7s679?=
 =?us-ascii?Q?A4fMX1hOqqlu7wT4/dNrQmwxYfKoJiUeN9KIHs5//Zt0JnIacML9d39OzNjo?=
 =?us-ascii?Q?RtkZa8BDW9paFriRZcT8G7g95rANyQbQEBonL56uuxcXE0UgygfLvGiRtMHw?=
 =?us-ascii?Q?gK6y+ZdyZ+h3wj+au4by9mNIbuyZvPFS52Dt/WFclly59IrjKJo8NPGiBBFD?=
 =?us-ascii?Q?Dv70H3IlC2cvbrx27fz+FFOHhQckn0zliMV+Hd17MuOxZgZ0Hz1M5CAsGFqP?=
 =?us-ascii?Q?PbshRRHDVnpNic6fqK11/22CfmdlRIAcoRcsr6ZgLuGv+7OG3sRLug8/LvjU?=
 =?us-ascii?Q?NW5k8Qf80lMGu1O2Y+JPrZTY69NL1MyXDsT6FYkkPfCMck3wEeciK/yTo8ie?=
 =?us-ascii?Q?tPqiVxlLjgCvJeI7NqgUfhiEOBPBZY9sy6IRl2mJdnpVjmt/5DtlNSanRA7h?=
 =?us-ascii?Q?Fp9bKamIibqAja7SSyn5rpr2sEqMEB+BD/lrNEQRXahM9u5zq+anzl1q08PP?=
 =?us-ascii?Q?QcpPxGHsxcfLYLhGTY2xwioIoesBVZabiQ3c3H5Xh5hZonUM5akHiK/bqJIv?=
 =?us-ascii?Q?+t9Iu01s3VPjE5/KPPvZvm5YEJjM/vd4lgn9lsdfGGYGhIl1b0hcwOyMOjWl?=
 =?us-ascii?Q?SfhLUtfISgBXtjzqMGSYK6r5FSOo7n2XlPSWaIXcoP348HQB0vsvb9n3Vdki?=
 =?us-ascii?Q?JOEctzQB3H1x42OE7S/J6ZWqrsqEhvYiWKwUmE3xd8C882LDKMikjKgHVFDr?=
 =?us-ascii?Q?+AjOcvTHF3ku8W4qxCuuz1OTSh/1kzoQFRIOM7STR/G0mQiTTyDye0ghOKVJ?=
 =?us-ascii?Q?tg6HSvYSy5X9s5UqkIFpJG7R9iHE8CI1hsECmNeZ7aQ0TVyg5n/BZ1TutnfM?=
 =?us-ascii?Q?Qb4GoG75OeNULVauMopwyM0HvnFESttUXo6JTG+CbXYUUNKXHOv1b9c2JYNW?=
 =?us-ascii?Q?ZWwHOsZAjTOHfwe7A0sTPXOSxHHzRY9NGWWD4dn3H3RcO3Hex3T9ht3kEboN?=
 =?us-ascii?Q?MmYvTOw0eswB71ca9mOblpcgeECsvUhj8U0X9gzxNplp9KzAcX0eLPLtf3Lq?=
 =?us-ascii?Q?X0Wdem86c+EwqARmj+wx90+Z7oRwhntcaiFZ4j7oYpfXEoSH7add6i2zfhlW?=
 =?us-ascii?Q?b0iqpJkuwqa7iZosCn3buA52Lj4zAveZctmsOcYOB6HSpVvvX0pcr8qaMyww?=
 =?us-ascii?Q?Nom826HkwEM6DPDa+M7V+DaA3tWWmFWlSMV5WV/r?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 779f291d-08a1-413b-286d-08de111c3a95
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 03:36:47.4114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +eEseUVzi6AIhABGX8V4FQekYcO/IyQKLzOuAQFk+L6X6FA9NV0nH3Db45TSuyeg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6268
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4564B180003
X-Stat-Signature: 5cmcb6kpya4an993ue3sang3w1gghpa9
X-HE-Tag: 1761104224-607724
X-HE-Meta: U2FsdGVkX19MFmuvJs4h/A9YE19Jf1mQuHwU8SnK7UDUP9hS0cHmvdzowf6HLr3DRGD7bDSHLhQNol07DvSpmBIwAMD+hMBRqhNLht2czFUCBEyF+RMOIKUlz8p8hXgfAhJlDuSq1dlUrJ3QP/CrzeTVtg2COpvOV+1UF6xiZyTi7nhRQOhVduh4KNCyvyd2duUiDOeRSxTPOZvA+Q3aFBYANXMracXcFUXMwdWMFjOqftluoNzCe4xTchqB8Gjc4xDTA/FeU9FAmpQ4qEVy4b9PP1qG+rt2h4f9qMLs5mK/ZeaZtQyjurpU89EBT1vTLeXKdtN6lq84PN2H08yi0Y0tXcwrJ6t6DG2md/W8oF40HjmCJ7TFC8Z2d5sHJVkyLKpMtOHbKshalngCF4P4tseQO0/J4dolJ4TwP0G8mc/PPCw+899apgXWjTihFUn0Zf3b0Pe7PolqFDx/bUWfAVZWhAE0CxcbCJbJmieitbZ0zBgy6PLyD0KB0R7MBF3yWoKVeQfFbNjJGZVpG2OvcCiXbv90eZYYsE2d7R+Ws09nfxu9uRAAFY+n2TK/JEiwwhin82lWXflMv0XPAJMhFCMxEsVf5QplyQ67+M0pBuqAkihulBFk1duei8c905jo+aI53d+qn5XEOg/HfvkQW2Pp/taM7JtavM/h699ZEo+uK4//Y1KUDWPPKwVNZ72vTYs8+7ghOQk+trp1OoVT7JKZAzMW8moS71DtRXdpNiUHojhc76b+mY1j72wZcXevNhPWHf2DJiTvwqSpdw6evBvQ28otnd07yX/jqQFm9ShrNN2YtvdxK/Blx5O6WCUCVoEVTcmxbNjINIXkUHT+pARw8Dk+Zfvc8XjCUElvMMMlVzbqXVmowm9x8v7f6LazP9n6iFjhSeqGzX2TwjIfXkpISdpLk3BLXX+m5wAaQpzMF8zZwXxZOizPzqsvIZOyZ5meuWpBp2I7rv/iW3j
 Iqdy5Z4z
 ntp9kiynDxYmcypQ7fUOb7Tze/Z2Vennugr+DuwD48HixrlVmTKt5nrw1fni2+F/NFbGWrjqHE4xgKVsH4Cy2wi9s/uIJ1fNrf5NxA6tQZF2YD9qY9e1EleRGz3/FEcJYz2Tjpg8oTG71S7+d07pgxLn3kvj8iSS1PkJCDQ4s/4xbm56gny4FTPSXIM5QU75jepQktdhSqKCpd/RuaUzFXq32n6NjU/Y66pFDHOokSjMh0Kn7+o1aLvvvd0anjm+uMy8EpUB2kVrCYfaz3xYsPkY/kfRidksC9IkxGm6A45aPYGNgKA5vGnGEFWpovBRniw60OajnjHrQnFhdTGO2OwrosB7/HNH40DPVAbfZA4GzZTktBweFXkj+eRyGyUv3reKa0pVZZSSImcR9gYSReem1LjaAOh4DC+Uzu2CrbAR5Ipjr6WQqxPu8/ThC+TX7opOa84Y1LAb4KOBGoBOMKe5Ppcw5/Uor8z00Xe9xcisoFi+fdtIQF0h0g+OKAcjkohn3/KPH03tCX94pME7qlUkrzQsZra0zWE/ejnkNRlVg6Wc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio split clears PG_has_hwpoisoned, but the flag should be preserved in
after-split folios containing pages with PG_hwpoisoned flag if the folio is
split to >0 order folios. Scan all pages in a to-be-split folio to
determine which after-split folios need the flag.

An alternatives is to change PG_has_hwpoisoned to PG_maybe_hwpoisoned to
avoid the scan and set it on all after-split folios, but resulting false
positive has undesirable negative impact. To remove false positive, caller
of folio_test_has_hwpoisoned() and folio_contain_hwpoisoned_page() needs to
do the scan. That might be causing a hassle for current and future callers
and more costly than doing the scan in the split code. More details are
discussed in [1].

It is OK that current implementation does not do this, because memory
failure code always tries to split to order-0 folios and if a folio cannot
be split to order-0, memory failure code either gives warnings or the split
is not performed.

Link: https://lore.kernel.org/all/CAHbLzkoOZm0PXxE9qwtF4gKR=cpRXrSrJ9V9Pm2DJexs985q4g@mail.gmail.com/ [1]
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index fc65ec3393d2..f3896c1f130f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3455,6 +3455,17 @@ bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
 					caller_pins;
 }
 
+static bool page_range_has_hwpoisoned(struct page *first_page, long nr_pages)
+{
+	long i;
+
+	for (i = 0; i < nr_pages; i++)
+		if (PageHWPoison(first_page + i))
+			return true;
+
+	return false;
+}
+
 /*
  * It splits @folio into @new_order folios and copies the @folio metadata to
  * all the resulting folios.
@@ -3462,22 +3473,32 @@ bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
 static void __split_folio_to_order(struct folio *folio, int old_order,
 		int new_order)
 {
+	/* Scan poisoned pages when split a poisoned folio to large folios */
+	bool check_poisoned_pages = folio_test_has_hwpoisoned(folio) &&
+				    new_order != 0;
 	long new_nr_pages = 1 << new_order;
 	long nr_pages = 1 << old_order;
 	long i;
 
+	folio_clear_has_hwpoisoned(folio);
+
+	/* Check first new_nr_pages since the loop below skips them */
+	if (check_poisoned_pages &&
+	    page_range_has_hwpoisoned(folio_page(folio, 0), new_nr_pages))
+		folio_set_has_hwpoisoned(folio);
 	/*
 	 * Skip the first new_nr_pages, since the new folio from them have all
 	 * the flags from the original folio.
 	 */
 	for (i = new_nr_pages; i < nr_pages; i += new_nr_pages) {
 		struct page *new_head = &folio->page + i;
-
 		/*
 		 * Careful: new_folio is not a "real" folio before we cleared PageTail.
 		 * Don't pass it around before clear_compound_head().
 		 */
 		struct folio *new_folio = (struct folio *)new_head;
+		bool poisoned_new_folio = check_poisoned_pages &&
+			page_range_has_hwpoisoned(new_head, new_nr_pages);
 
 		VM_BUG_ON_PAGE(atomic_read(&new_folio->_mapcount) != -1, new_head);
 
@@ -3514,6 +3535,9 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 				 (1L << PG_dirty) |
 				 LRU_GEN_MASK | LRU_REFS_MASK));
 
+		if (poisoned_new_folio)
+			folio_set_has_hwpoisoned(new_folio);
+
 		new_folio->mapping = folio->mapping;
 		new_folio->index = folio->index + i;
 
@@ -3600,8 +3624,6 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 	int start_order = uniform_split ? new_order : old_order - 1;
 	int split_order;
 
-	folio_clear_has_hwpoisoned(folio);
-
 	/*
 	 * split to new_order one order at a time. For uniform split,
 	 * folio is split to new_order directly.
-- 
2.51.0


