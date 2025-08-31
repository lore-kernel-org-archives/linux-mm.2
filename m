Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9457FCA0EFF
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 01:06:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D53C96B000D; Sat, 30 Aug 2025 21:06:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFDDC6B000E; Sat, 30 Aug 2025 21:06:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC4CF6B0010; Sat, 30 Aug 2025 21:06:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AC3486B000D
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 21:06:39 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 57A82139E60
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 01:06:39 +0000 (UTC)
X-FDA: 83835262518.18.1949947
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2064.outbound.protection.outlook.com [40.107.101.64])
	by imf23.hostedemail.com (Postfix) with ESMTP id 80CAA140002
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 01:06:36 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HpFK+YRk;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.107.101.64 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756602396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RdORkvZ+NevRWRrslkuux1YeNV0Wud7s2muxSR5wcCU=;
	b=xmjeHwyitYz0W5fOOi3Ak+6jA8Oliv2Yqm70MTtQdPb56v2XVdG6isRy9Sxe7y4B5OSso2
	mP8/RSlCo4gQtNuOmUSmc2f2ZC/XUlMJg78N/1eX9s4L4oIKgZ3p7DJvJC/He1AMHIv4ac
	WOFoxvhHoQT3Cp/piYAsPX805AJqbIA=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HpFK+YRk;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.107.101.64 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756602396; a=rsa-sha256;
	cv=pass;
	b=yxCxFjbf82fPC9mu8OQi3JVkLsfg1vLw2Szo7eqxJ6lcMYJWWB1oi1Ex3HzKiHvRSe2HPJ
	fTB2zj3dC7aNSl7VaBgypgk+vZWAB+hkA3EEVCqo2Xy/v/1/yJ22zxNYIlzm/EBEx4Z0k2
	rpv9mt5mu7IEZx/SK12+AACOxJffeus=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q3IRKrVinXBfgK2/4RfYsNexzPpEpZ+r0G/pCPevRG+DxK7m4a4Ad4QtJT36E1dlSHITdDuqgpduYMYNxuuQpq6GjeVAYTS13oXPgg+4VA40QBqJpmhwXdocPpgFz63yJpuo8KioaGoZPcLeeNznrh7z4G47q7o2wkCycQZouLY4WEWLmrWlhVqjYhON2fzFXBs8oH11vtnBkBOtnRK+vqEN5kGhEwVltGtnW6AziRtxb8i9AS5tcyw26UKDBCFTuusZA0x/vzY/JzCVTF9gBLeptLRVWavM/030z1TBEQLGxDX4x/7iwZjbbjhn5D7EdrvKrpGTppkhJPShAmTzyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RdORkvZ+NevRWRrslkuux1YeNV0Wud7s2muxSR5wcCU=;
 b=LI/vcVgG3WADbq6Y8sUt497fbnpvDVgVbxqWMmOCmlSFgJTFzIDYul041sR/GjiVJ4f9fb931wRfLlbmWGGJ9K2lGoQuL05C/7iYuq8LEy8/IWPGxeNe6v9PnoRPNi21TclwSkXAJ00kYDM1e5Of9DyyU/i0OnQNj0TGevaeIgRlVTmAva+iXQyZEwfU/qcHGF326DltCe4C9E4ij4exfytKw8f5CazaiwdRHJPokmfALG5Dh05OiWVAQCjZxwiBDCjzWvAozVPWIAiJ/aqW3NoH09f6bH0Ot84ENSDvDSrpifgK4DORE+nAHJoRQFbIhbFXenLzhqEa3hn6QTWJEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RdORkvZ+NevRWRrslkuux1YeNV0Wud7s2muxSR5wcCU=;
 b=HpFK+YRkmlyuWFTgpXLtlOFkwDryAgCdmAa/X9ZQRDI7ap/JSn23VB0Z/Cpw2nPaz8dAXsCPjm27HU3BK4fYFbcC4GaTQV4M8lyH9+oUJlR6kbqPp4zMLp1s5F9DUEwg54lkILtjkjAB0dQwjj44l6YMNqIEcBGbDFA1FSMDe7CRnh/ZW0e+Sc7gmw/R24ijWqUMrtKr8dSQMSXMLC/BCZ9MB5jIR03USkFCvAXLAhbtADZO7ETMIY9cZDUHB/XzhvSKPkrEoGCIRIidomFZgP8r0iUm/lDeB5fjeznDo5YQI8kR1Mcdn14WIBNdGYOI2cJepz//Rogbb1lW7cvCvg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN2PR12MB4438.namprd12.prod.outlook.com (2603:10b6:208:267::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.21; Sun, 31 Aug
 2025 01:06:32 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9052.019; Sun, 31 Aug 2025
 01:06:32 +0000
From: Zi Yan <ziy@nvidia.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org
Subject: Re: [PATCH 05/22] mm: Constify compound_order() and page_size()
Date: Sat, 30 Aug 2025 21:06:30 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <1AF80C9A-7CA2-47D6-99ED-31529E6E5215@nvidia.com>
In-Reply-To: <aLIvT4HcHUSnwP2U@casper.infradead.org>
References: <20250829154728.3397606-1-willy@infradead.org>
 <20250829154728.3397606-6-willy@infradead.org>
 <8A306C85-D97C-4665-A683-0AA69122AEF3@nvidia.com>
 <aLIvT4HcHUSnwP2U@casper.infradead.org>
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0050.namprd03.prod.outlook.com
 (2603:10b6:610:b3::25) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN2PR12MB4438:EE_
X-MS-Office365-Filtering-Correlation-Id: 6fdada30-389d-4ccc-8048-08dde82a9fb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|10070799003|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tm8//d1mYThYusV+QxAJvTBwvj/kloGHEtgDJXmYslloWn4znkEOxW97poXZ?=
 =?us-ascii?Q?H4cnHIgCKYcYu42C64tqhe/bxYx/QEZIYI/4hq/gIb4niNrUnhod1d75HdiY?=
 =?us-ascii?Q?tf815KnCiMRn1LgYNQg7FXGguNSRhs1VhYHKp0TPR94SPgHdWKYiVJHWR3ew?=
 =?us-ascii?Q?IjCqF0uoJ+J15kt8dm9LIGv0sQ0eA83lUzWSSKbF/G8uaFhR/UcTSNfzVPoJ?=
 =?us-ascii?Q?O3tk+zb15qKGwsYh8IyvNFmvwpzMoJTQkc4+9hEWFgqW02ffwQvmxyENrFZ/?=
 =?us-ascii?Q?QX9ELlI+9rFtED6m5fGac+91ykjPDa0cMlK1+xsP/0k5hJoV0qz3JPObyg1X?=
 =?us-ascii?Q?xbjYkHzHj9iNqL+rpeSgVMJRO1rXmEbaR5EOirPBf/LghQmrDcyrK2o6wcd0?=
 =?us-ascii?Q?nXoqpUHAXGSKKDi2fb1BncKRpfNNx89cp3ibPzpdC5Wim3fqWODE3kDdHYGE?=
 =?us-ascii?Q?oDCSwodemhSswDNHW6Ggjy9eiFL2PJXV/5jvSuKPDFqux0my9sNDnDAZ3f/f?=
 =?us-ascii?Q?iKy/cgWQaGY0VJzFS7jjJWTWXCTUUWB6AK6l2GUr7wmcCjrHYFmjpOdUUCc1?=
 =?us-ascii?Q?H9++tvB71vbqleJBjbqQqlODMD2GoH0r73adI+RpqLXMOnrf4nFvbTDaho9h?=
 =?us-ascii?Q?cFFaq+F+GWz0p+aDQo1NbuxLY753lCt1aQj8g+cTn4VgWq3GRXC4fYhWaHfb?=
 =?us-ascii?Q?6uIZ1/WHnxk99gPQZu1/yemrO1UPG9f7Vj7V6YF4uojRkPEvflBEoipJFnim?=
 =?us-ascii?Q?Prnvp8kRGfcjnT9Zzr42QKZ+1zL50rvazifxpSTqs9Nm4KmvAdIPuKAazclB?=
 =?us-ascii?Q?NBtXg5cRw7ANRXdB25YMomoz+qu1qBsxWaxZ1DHrFU/sjdcmf+gTiYS0Vt0n?=
 =?us-ascii?Q?xj3f523Dx5CSxDfRfbqO9SGc9iSR8dufah35SjJQve6RByph5jmiphbR6ghk?=
 =?us-ascii?Q?wJ3wevDCP4psw7KwcbYUsfurmVGPTyoPmiL8KLL0CrYz65/nDkUmxOSDl9rF?=
 =?us-ascii?Q?8E3/Kml2guQzKJ/A3mht+DHZP6p7hiFLh5X8BRttUuQpbeV5zcKEMUFOM2st?=
 =?us-ascii?Q?0YTeqSNuOemnBZz0QX8y47npGp+OJovZ+dGJFPsWqI7pRX33FmqacKqMmcnf?=
 =?us-ascii?Q?Knjfln3jOJITTObVnl3xLrQU/OrpC0hUpJIHRzfnBDt7/ySC5bPbQ5BfRdiZ?=
 =?us-ascii?Q?++zjWwTfulJeV7JvV6YgvRUVVCZI0nw3A4ametd11ndnMrMGu5wcu1YhmGTi?=
 =?us-ascii?Q?rC6qgd+Ou+cSa6m3Dg3PVcNBl+Tyuuf4MTRCrNT2iBZcWRCAetHiLksWBj7G?=
 =?us-ascii?Q?yFAPOgqWm8k0tVV4huOZtGFGqJvpSJZwEQBADbjQVzYX1pccRVXKlqOt8fWn?=
 =?us-ascii?Q?UjUKFRCiwb5kibMcG2g2LSdAyZFZcjbSiNf8xS++KyR+7334LQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(10070799003)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aeQSEwA+ycIHyyP5xt1I1R11jjNfxCMp64N/XZD7B7XAu4fZo9Auiny6ufbz?=
 =?us-ascii?Q?cbNJOs+mPDFpdlzhYH3WXu1aA3rYOmsgPaEhaPjs6Z+y5nVnNJa7iCE3DUJ1?=
 =?us-ascii?Q?U90iKn83QvaLV5/meU/iucAZtaYkiFR2GeebL0dnvS0eTzSPKz0o3Ilu0ITv?=
 =?us-ascii?Q?fYKgOQ5jK5IEUVa/Uy2LF1hDl9V0qWzqLxRCXtUb58JKBSK88YmU+adaOM+a?=
 =?us-ascii?Q?LovrAvvAKqJRYP4lzaWIAmpL0Fx4OLKILJ+QjlyK2sppZNNXpM+CZ9s1EnK/?=
 =?us-ascii?Q?LjL0NbM92zrzbrm5ItNH7DhHIJRu6KS53oKPf9H3FZkZfNZ4lKa1Bt6FvjsJ?=
 =?us-ascii?Q?4Gow3qRcdAfrJAkIRJalzNdIwPTPcak/VKV2/GAh/PelLIlvWPbfSuepNpY1?=
 =?us-ascii?Q?PO4VrqhtpikzdYuRWUesZYXrhfr8CH8SDaHEDe/aprhCVs81qsuD2yrNFR/a?=
 =?us-ascii?Q?CMxQBXCE96Zv1+Hy7RVzcdfvrufKyTTwARx28IIMKB4XQd6TxTI2SZqLvANi?=
 =?us-ascii?Q?dkzJB32dok4lF7fUZpznjTlwGgZmoJyh8iwsOs8ahcF5X1Xve0QYWnySlxKj?=
 =?us-ascii?Q?al6E7HmD3NBjsL7uRimBmCEgor6dxqIrsBIu2EMtk3WCZ80bS63saZDfFTri?=
 =?us-ascii?Q?oV1CtTobc5bnffZouGAPIpoO9HrTi5dL1c+yUldhp7YJcfQ2tKCl/DN5uZfV?=
 =?us-ascii?Q?PKnd4zY2FL8BsjNaOCKtipMkyKxpHuxqZoZBTKu9WPNE39TwZ4XcEw1KWWSa?=
 =?us-ascii?Q?DkljLc0g2bXtPGi6Fp4E8GW3YDF2Xl3eReKUDHM2rbMsDV6gz9M14QjJ3Gwg?=
 =?us-ascii?Q?jE9wAb/+nER+BoDmW22pnfhWEz4I2sp3AtIsJQ1IlW/JBmLHRyxGbXEKYTou?=
 =?us-ascii?Q?wZ0Ss4/cvRYyIm8lNkBSlpcmjahVZPMdgD88CTDsjAP/eJ27V+aD9lBGoWiQ?=
 =?us-ascii?Q?Pr11V+ONiK8GG5W0DWkK/qwbVQd2f1GW2p1ReUZYLhP7R79lGrdMrHGpNyX6?=
 =?us-ascii?Q?wBJn0V3TGAt6irBQIAROs6JDMiTYKimAsaC7mI29vtQLOnS89YTqxHDq2+L1?=
 =?us-ascii?Q?dBiubirhVBUykr8qMm9i5Ivh/6dQsuH/s00X3gphe1cYjaiwOiwLKTp33aZq?=
 =?us-ascii?Q?tYyurrZdIlXCFEX8QNbPB6AUPKJUG32mvFpOWftED1wmWi7AwMyLQbwqsVPH?=
 =?us-ascii?Q?FAOxozvbZO3d/rPwMkHM9qRhtrxKG6hIwYqJp34WEUVXV3Mkobyr+9Jk8ZMo?=
 =?us-ascii?Q?dwNYKJRy4nuCsxjSYPhLuxO+zPRsR45y+LLFxYNz2kIJT4rk5wvrAXZdNzH8?=
 =?us-ascii?Q?+2Ja/JBCEabIa6E3jGfDaqepo9NXnG0LsDN2rbk2ZtzQSaCj2PxziKMP/b0L?=
 =?us-ascii?Q?DFY178Bv/Yi4tD35+Eel1Voc94JdMydwt7WWiA+OY2fqnm9UHvT72ZAtPMS+?=
 =?us-ascii?Q?g+3wSMkXRJOUhHLLQ5S3nqcuhQd4I+vZ1wwtQOZc/syaUbezCwS8SJToXyll?=
 =?us-ascii?Q?Ms84/04WONTPySOpBGc069atnpg6NydVUxVSeQMs7NpKsdLMqLJzpEKvSPdB?=
 =?us-ascii?Q?PUN+fKHk+r5yf/rprYbWdhTWwhPUf1eS55uY2jR9CBSRhVdWy0LNL7bc5osg?=
 =?us-ascii?Q?f53+2YFmlOPcbcj2esUp0C4MJ1/6mdahe+yqgKo29g1m?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fdada30-389d-4ccc-8048-08dde82a9fb6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2025 01:06:32.3501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FKPxZVEa804+X/F49a9hwze64tdGwyUWHU652K36pawDQCi+TlhhPcrPK9djj3aV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4438
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 80CAA140002
X-Stat-Signature: b9jf69yy676zmrw1fs5iabh5dqec69zn
X-Rspam-User: 
X-HE-Tag: 1756602396-613512
X-HE-Meta: U2FsdGVkX1/H22btnaCQkMhQ2Uh5ZGntbnBBTpSf4wgDzoEB2gKmO9mBq0BGao6hq6mG7iLoFm5DaozuCPUfQz42j3BcE4q7adRgbekXfPM3WWXJwzV+QEdULB2wP/EgeNrCwVJBf+wWpC+taIilPvPxBHwbEuhN3ElYzv/KU320uvfKxYZMAX1ajZdjuL/cBdksSA4gQ/jwDgZUTQeg6bQAHnuSF8Q92KAuiof8FPYIHxR1HQHNQBLkqKQS4emft4Rja/GNltZbbeMl1QIIJKd6B2FHbRKUPzodnh1J2RhkJCsOD+y5GsAptqg1l5r8tqhRzCspFnqOonbHVOn03/ZZJ1b+3/nkh0PLWgw2KnDPBNDRdd3qld0vsyhJiUidSBOZcsUdY6wgDSDK9eEEDMq2r1xFT+B4ZqB4/k7C98egOKSiVoRgB+cRPxuHEbVOlCsx6PgOa6dcSAFeMUAlJXv31uavyO9iij2iAhDXn0DkvDVSPlxw2h6SPznj7tQxY68Lu9Ujr95QZqnmkbq57H0quM27nYGVsem0gNxA2I7OEKeFtQQNaX8f5g2lUwMSlrCoxL0XcDnZc7qR6Tr1hryfuJvJgZBr4jluXSzFiIkYO7faW/NLOmaj5FnVXJudkRXvzgGKOYi0gjZXCvGgSJD8qk7nWShz8NROuBlBrIHDM20D1JwFUq5aUZQ6frpwVO2aLuat5pPqj9FW9bmjvM/O1dhqgsCc0zpgaJlGDclUt0An2X57/w+vBDNJRqEoLHoCW/sAfW9TquA1xXjcevU1Mpq5i1cum7I8X3sUyA3TgUsNYLgbSY5xVaIiF40/NK8qSFeHnO3jj6aY0Q/4iaZR1Bca4V3OHJ6pOKSDzfkftiww0MxY7X0QO+xxd9y4XowJkeWkrAugTc5RFTxQi4VMmMteOKMpeT7VedgcLw6jAgkEqYtBrQ7eN85Hn6EMh5W81cv5rZt9TiXH5/f
 tcSkMcGl
 tqDdbmRFrJLLlqO8OfvuvfycloeqLsjYiDh2QqcNjuqxRjo4dsn5+RRHXrfW3mzumdZHk96soqczlmE7D8ajfHn0k7y7MqIGzDRIPYnC6Pw8e3pswFHjpf7+xbzowXmlCg83S2bQSqcmw3gGYOyigJrdImlsZk+i9Lzqj0TffWvPZTXFFMClcES+Mk7aH+VriE2q0Ex1LH/c7ZsdyS27wD9TlX9q/AKw5OQdSl265im8rm8ksl03jtAYqiP4LinascC82CyHcNJuttt67MSyvzfgrWczAPqZCe2HtEi8IgL6toNXT/C9EvWE+AkRWpGM2DPzjEhDQ9uMB2BAasMKh7GR1AjQ4EyrQpj1eXtwOL/l0oMAYIQC9/QvsHMmELgXlMqVp7hO1VjiRfyBErqZKH6ZN589MGM5tAU7GssVfOV7XZWoRkkG63h637vBYZCT8O6ly+dQVXYsohugsZnHnx+uGjw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29 Aug 2025, at 18:53, Matthew Wilcox wrote:

> On Fri, Aug 29, 2025 at 04:42:43PM -0400, Zi Yan wrote:
>> On 29 Aug 2025, at 11:47, Matthew Wilcox (Oracle) wrote:
>>> -static inline unsigned int compound_order(struct page *page)
>>> +static inline unsigned int compound_order(const struct page *page)
>>>  {
>>> -	struct folio *folio = (struct folio *)page;
>>> +	const struct folio *folio = (struct folio *)page;
>>
>> Why not
>> const struct folio *folio = (const struct folio *)page;
>> ?
>>
>> page is already a const pointer.
>
> It really doesn't matter; it's not going to affect code generation at
> all.  We could cast it to void * or const void * instead.

Yes, there is no impact on code generation. Just a comment, no need to
change the code.

--
Best Regards,
Yan, Zi

