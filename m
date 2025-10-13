Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62020CCD18D
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 17:07:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEA4E8E0066; Mon, 13 Oct 2025 13:07:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC25C8E0009; Mon, 13 Oct 2025 13:07:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB1248E0066; Mon, 13 Oct 2025 13:07:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 98E798E0009
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 13:07:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 66F3746FED
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:07:26 +0000 (UTC)
X-FDA: 83993722092.06.16E3E93
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012028.outbound.protection.outlook.com [40.107.209.28])
	by imf05.hostedemail.com (Postfix) with ESMTP id 93EFC100014
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:07:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SRamRhnc;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760375243; a=rsa-sha256;
	cv=pass;
	b=IgWp6z2XA0YRX1cwspd8hjpDH3UMi/pXdGk5sm95++NjNClyNReHypRR6djEIx/X/oybiW
	5sFj3gfdVdNBSN41zuNt/D8XgiNOXwVESg+Ev2A8xjEGzT9m54Xi0V8nA046M9K2rJrcWO
	5C3s9Ev7s21KEBaHe03NahOejxUl5+k=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SRamRhnc;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760375243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x2BgZ3J+ufVa2wH5HrOcRQGz9xxDVvs/7jvqA6GuJ14=;
	b=koa2BiyKD66U1RFdi6ghtiMLDtjgJzYDyeiaLhv2XSlBbujGUOZq4xQDOaKFnFyWnM/Rg5
	2zkXEsR85upaGoqNBUFeQU4MZuD2e0Lvf7GTI1FnwwQ+nznLDZsPRANVtthvn2CvWPCmMg
	1GSkpkYckb9bTHN+x16CFlFVAIhh5ts=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xD5LbfErF0v1VCVVIqo1I1xsXoIi4si86LCVKf7gBHTVmAEKqMj2TS5nYZrO9WY5LcVg0876d57mQ9OtupmB+MBa8xKbcZjz5OxAtNAc1lbKfjiIFsDhbOtp/+lnIbS/WMXH9l9GTCLpUQUTW96YsNffWr5RS8UglkTiGhWnVzCKlKQmsuC6kjJD/ijqHVhrgi/KNMw8PSKkt9197MkMDrDtIPUYrsLI7N4aI+dZk71V/BRIwZXS7vEDPGDLdQ6o0FWx0BanV98QoR2N/CqzI09hroIOI6Rm1O9+GIb8BP4y2pfRMJkN/Hli7mMGyEpXsQdvQsChchKANn41pWXSpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x2BgZ3J+ufVa2wH5HrOcRQGz9xxDVvs/7jvqA6GuJ14=;
 b=Ew3iBdUW0ZuCiZ/ImdLYJ87Zyuj0q8CE8lAiG2FY12w7kBfEkXN+poUURIeWSWEk1ZKtJ29mei9s/3Cp+nLhuzDU/vP8buSQiQAvNu9kFC0Ep8gKp1rw4aFf0RTCb+shFw9OUq4MvCsxitbRuLY1efdwE/d5kkrBFCzN7OQPNZ9i1BOe0HAc75xrfWppWF/NIbSM/JKQrO/biVi3Ink6rKw3cYZOVd02oP2R55kuqdGms5pbrq2Emc+v/TfAyTsAb5TcDYsqcZmz3QDl4bUPrBaAyrhZu65Btt5FXJe87vrkNTWgvdPIcN4VQh9dTK1D+yk7KG6yqEb6tSUfN6+e2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x2BgZ3J+ufVa2wH5HrOcRQGz9xxDVvs/7jvqA6GuJ14=;
 b=SRamRhncwX1ePWPz3rMNEygQBBDpRwovnNrt6y4oPA+wB5TExktrHKiTb7CABhXf2wO5CmXGhkgza0+REAKLKTFeL7+C8K1GayH6FGnH7nGs3640hZWQsoWq4Lm7sawd4LSACtu3gpPndlpAtdDEMXxHXQqhLZKvNE5MljnULvyC3r3s+GZK12YYiUUwEpakxBKcC7xLDu+ssV9BWGge2hDxvASB7luyF9pLau+p2NCEXXSpoYPEVfU/FjVodz1ZuqJgAIAxHxCiw9PPUuWadbH66dUt1t33+Jsa9KRTWeWMcyTOl0479wtLBX5cAp06B+nMTyxknVa8KyosiUxuHw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB9728.namprd12.prod.outlook.com (2603:10b6:8:226::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9203.12; Mon, 13 Oct 2025 17:07:20 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9203.009; Mon, 13 Oct 2025
 17:07:20 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: linmiaohe@huawei.com, david@redhat.com, jane.chu@oracle.com,
 kernel@pankajraghav.com,
 syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com, akpm@linux-foundation.org,
 mcgrof@kernel.org, nao.horiguchi@gmail.com,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH 1/2] mm/huge_memory: do not change split_huge_page*()
 target order silently.
Date: Mon, 13 Oct 2025 13:07:18 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <C852B1E3-483A-46A6-ABFD-0B1CEA9BBB15@nvidia.com>
In-Reply-To: <20251012004150.sujjmfkleibhvlxl@master>
References: <20251010173906.3128789-1-ziy@nvidia.com>
 <20251010173906.3128789-2-ziy@nvidia.com>
 <20251012004150.sujjmfkleibhvlxl@master>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN9PR03CA0282.namprd03.prod.outlook.com
 (2603:10b6:408:f5::17) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB9728:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c260046-a048-493d-4c0c-08de0a7af821
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cyAHKOpfmMVg7qk84S8phKj+HEQXlJHRR5Ef7fWmQdtDvJt63lTwU9tuxTAp?=
 =?us-ascii?Q?wWTY90PUiFgBGMSEzUx9Du3oUNx3Jbz7wfod1NlLpFqcDOW4dqWyc3olTFIi?=
 =?us-ascii?Q?0RSmPz4JRmM2wHy7WUMLqUO9gBRhhW6cm1LlbKCH+fJW3ARjL0WNaJD68maZ?=
 =?us-ascii?Q?zMnI4wM4D7/2LO4+PuJsIlAbOaS5ONTizE38P9M8evazOI0rZG3I88Exjxu+?=
 =?us-ascii?Q?uzPg609q7rqVm3iSYEPK7JMrDcLNIHA5+PTZvllUeYp9tlcACgczeJwr0I74?=
 =?us-ascii?Q?rZIAmSZStxwQZ/IqmOil89Qo1lxggOH4TnpmGpCNkfp2ZkrN2Vc9RiTLwbjV?=
 =?us-ascii?Q?FQAJSx3KDYwNOFas2Epg5rrWPqTEQnmTFCzaKKHGdNJGzHygFHSFEeHcWO7m?=
 =?us-ascii?Q?jycy7B4laKNv0/3kbAoHAWsbRzVMn7aHFWgq3GcuMULhep4suSJ3bmlQsn+S?=
 =?us-ascii?Q?ZJjsSFqXO840jSNj1KvBHosfhqUhf0wqH6tQB9SoiMgTpHiSs55eW4LfyEWj?=
 =?us-ascii?Q?moWKyc0zzYxKbRElpwxrWpOrHp+mwSXxufd6nV+qDjzzM/zXkBKuY/F85bdE?=
 =?us-ascii?Q?5T7qCLoFFh13k4cPDBn7BKVB9FPbfDu4hV8+z2yTp3MT2ZICYmjC13tsdRom?=
 =?us-ascii?Q?17wQ21UxtG457AMJrKcSrJiyLAoEnvtiMhglpFvlQiWNX5zGluagEhTtrU29?=
 =?us-ascii?Q?LjvYkPKktsKmwVfzHvaCy4jx/7HP3mGM8J1YyYFMI0GQ80vNja8sqmsHLIyB?=
 =?us-ascii?Q?frCde1N7aJdoONJjGTnFg0X3pDbuJb2Xxt/3i70pMqQhHwF+RhSBVPpLlop8?=
 =?us-ascii?Q?ImWy7RRMygIUMywO06M92K4ZsnYl4kfUj/Qvn+lxtE7wWVZvN9p8652frvlV?=
 =?us-ascii?Q?/YXmOnoJp4N55UBC3/mC3DCv9i21h1Zp7ABkHdfuoE/z4R2pXzt2xnmg7jd0?=
 =?us-ascii?Q?LRg87a3Pis3ChDGqKEvGwKzje71UIlwnH0nSJyYcAiMkxCe+F+V7cEJE0QwE?=
 =?us-ascii?Q?CH1v+Lq1Jf3b2noL1x4hTeSPcNZDnN5nEawBumMmnfhmPh1p42PKyT54B6uZ?=
 =?us-ascii?Q?w3eZM2CwFFOTAKi7KAOdN4WclCAn4PBkZ/AtVwtVjT7kwkbAIqAB+KF6/O0/?=
 =?us-ascii?Q?ktEQUNXePy/VuCAmh7eA5wfkB8ECC8qzDkCNFFa3G9EOSXF2x/UoFAL2k+AO?=
 =?us-ascii?Q?72DvVJG3PqnU23KAQp1H7rERRPi7Yj/gOXWC1giX9rpdiitCG4N5Bywu/4qN?=
 =?us-ascii?Q?+PgZ0u1uUxh4nbS44uzuXGq0IQ47uQFcFRngtCDcHDcmvsdTx7Ri7k2Pgvbh?=
 =?us-ascii?Q?NGdPUk0TdFw7ByYcmgKXu6N2FBqJ/CsM679Otmjj+prUaB8aJtUHxq2qa2Qu?=
 =?us-ascii?Q?S1qV1M5l5TQhdFL1FisL7kzpmY1zPQOlPI6ki09l3C6iVovyiFTsORwdIJAt?=
 =?us-ascii?Q?PzGYrKWS2v9tbKA2J/cCLoyMh1rbt5j3+hU2MzvKZq+7o6EnCkeQRg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?f9LoabQyicONF5ljfcBPDPxjxNipSr4gK1uoCDTlhdHTeuKk27/Qr2zIHAl1?=
 =?us-ascii?Q?gBPkl8zyJIBLedkNvJD5FGqYdOxxxsC+DDNaQEB6y2+hX99dSdCnh7+DCAOM?=
 =?us-ascii?Q?VBOER0sNwsMmOK5q2RhWBoqtWK+jIcMfFTFJkh7Cl3LYr+sjwfNYjXJAa6Da?=
 =?us-ascii?Q?n2y4P1pclmhv6u0UDCjtPtndBANM48k/MxjhNLQ7BRRc+EDmfeSmXvxUAf8p?=
 =?us-ascii?Q?tbtx95W3S2I6DypJ+XCa3A4HXQoNO35hgbgP5OV1pGao84TO/Ev7zOIgOjce?=
 =?us-ascii?Q?PpRRzW+x0QRZoi8Fb44ltdj21jQU9SJvZFmbGSUiWcyHlsTOA4Ya2bazm2ed?=
 =?us-ascii?Q?+WPam9fW/a+y7BbXstMCZiLkjRPNbir3esmPSbgxgvYKuXJv5pb1RI9IZvpH?=
 =?us-ascii?Q?8JzXzHpc/plgLUcJ7nmBqepEIONV/WmhzT+eTwbi9FtKVPG5UMFjdrHn0xeA?=
 =?us-ascii?Q?kkIB7LbSh6uNwHJGluKOZP9C6xIhqU3CdkRZiaXSnWoS+0/gCpwF/LHWrB/Z?=
 =?us-ascii?Q?sMtV1vGX9itOsMeSljQASmJHvOCi8tgviH1NB+3+HvOVoB+/zTJiBc9UPmlx?=
 =?us-ascii?Q?OWVQhYSYUklJPubQfTl0CVQSWZnDj19ARNkWA2Bb8bMZifjmU9tfaLFMbgZE?=
 =?us-ascii?Q?qRg2X1fRkwZ8Kf4l7R+L9+rbL+lYGh6UvShADUbVJ84z3Q0x1jmy0Q4bcW7B?=
 =?us-ascii?Q?iNc0byCjL2GHjPXF9nulHEg9jZvOWSy+pLNX1p3aqAol0LtdxHaXsAhUDF3J?=
 =?us-ascii?Q?V/99gxaSenNjWrpEzbAZyTnTD1G5kKa8togNjdZabu7ha0MfYPZCF326ngKi?=
 =?us-ascii?Q?X3s2r12KrId6zDwWDa1BmkBXS11/WzRDtW1Opgw+Nwc4oAPOm+5Jk66AKdAK?=
 =?us-ascii?Q?oItc0iV+fpLSTVQSbr6XZ7GpBZN2yjHOB2gcyhwaf0SYRDVPkSo8MJlKc2ST?=
 =?us-ascii?Q?jjZiFj3FbQWRSlZ/7wGvy8LXelQmGPkh14ep2va/jA1BqKrGR7cCXwUlizJ9?=
 =?us-ascii?Q?wKoPal0WAwio/yKWpbgtOBUQieU/Dj96ltjOQdKWEVV81mL23RkZnzGGXhdW?=
 =?us-ascii?Q?ag5vYLIqKqnsQOJfCExylAThUlR4ezmFVk88/NGjHR+9k52We7Arx8uPNf1G?=
 =?us-ascii?Q?skxhLpZoDWz0xFwj9CNhuOCubSkS4XHOtU9nFQ0mnUicCfINVb0/Zqwog23X?=
 =?us-ascii?Q?gA6g8RGOxrUzbmrRrSX1+cYAcnOqA0QSXMo0HCHNrbj+LUPwjFfgla/9Wty2?=
 =?us-ascii?Q?DAHpizUMdfpHGScOCsAU14myCNkNqYmwMWBKi3BxVfubXDSgpKBkxi5Ehjtw?=
 =?us-ascii?Q?No4k0iles4gvT2b0bxihJbJT4ALDwHNHc1x1vH6w+KQSvtb1UK2yPsb+1Qn7?=
 =?us-ascii?Q?QitfTfxIxdpAVLOSHCUti5PoudGt9GT642R9CHPyIhDug08k4orG0iwblZq8?=
 =?us-ascii?Q?mIQ/cF/wN+7roxpF6yeGh2LVsHf9URxU24bQbI6gttKvJagNBjNAcGtp1PKF?=
 =?us-ascii?Q?jslekeociOreSHOMeTSdIeGxfzU1OOsEtaFO3oL91QATtayLTQC4ZVEqklL8?=
 =?us-ascii?Q?CqY4x4QZ6YHxYucaapzJe28i+RnCbsC6YIujpUhZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c260046-a048-493d-4c0c-08de0a7af821
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2025 17:07:19.9346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YQqJhlsaFCaA3DbnThiJdAjYAf4QEgrmzkJ0WJjDkWR29x7zSzWZ4ZW4mjJGLnhP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9728
X-Stat-Signature: kcr3e93sbfahw9dnfay9uy8zqnjbbp33
X-Rspamd-Queue-Id: 93EFC100014
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760375243-438525
X-HE-Meta: U2FsdGVkX1/KrHMIvQuGOuF7HxKEtty3v4HOiSp5rwNzDKxKw0FzaCVIZDzaTtqmU4bhR+o8Oj+/wA4mjna/lD7rCK9Uy1fVRiC+zRwHmKmhNIOjnw8T3N8nXJOrwPygYSX8RQq267I/YyfyOHhq2WZruHvmh9mjThn/EbdRX4BV1Y8JMse7EiUukKLqiZ28vvieRmOsXfLIEd5OeWrA+NMp66PTZ05Z1Y325dJkTz4dSHw/3OMxgKsEFwXqvFuoa8NyzvhygilQtDY9ZRLzH1i7JgPl4pifkUX3TChVXjhn03N1pQ7uC+xNWheJbfImaICT+0Dj5/G2PsK/COQKy2o1y1KGwx2ihtcpuLuFA9nIPZl+MjLUtr69dntY8K6TJX+s2QNbQgj5DLVoPhMq9wiaAUbRgJ1Gy/VoykYcLIv9wo9+hltSmelJ0RaVQGLxn6CxhU4d6WjZKxN+N+feUY0YzCKwnmBcKKNuCdMITLZ0bGQk7FT9VN7xl3/RDjFXwdoq1R46Ur06BX+H9Qr66zQemuw/bapuQh3zNHipDe/vkeYqJWPPL/LgP6BcsxHItr6p6k5RXUiq+iR1q3EikEA1QBxMDQgoAChe5KCsNarPKwai5sB/bWMGbFrcsAyowyMDOK+BB39zh24D3trAijCvmDyKstPqC4RaqsdpqRo1y2aWkiUS/NAMhKMz+DOqUtZ3Lgh5Ico124TErNSABHMEkiHFPNYdEpnwtjFysr/AWypE2q4DfOfj56m0rORxlHE6ujHvqNfRBXoYtmpw0o0IiLF5YuND8rNhHSKN0FSQ10FGIDRIFAG11v72H50BiL7tPVZkCLHBRMiCChAbpcDfgl5Ok3K8FmDkyWgpyHojfKutAcKCR5G3suBOwBZSkOe4SkIN1UkM5aiXkfc7ZNa3vIeAuarTSC//v0dKNnAtf0XJIw+08RVwWpmMV8vPIfKv5SdIk280T+3moLR
 t8ib08lq
 NdnXc1DKXBMZ2aJs8RLKvBmctEdH/nKdxMMu0CLj0yHDg7VVCh//zHVK4cK2Umm2BgQvD74O+Y0xlq3JdydF6LtrYkl4vO0imX1pP6DPgGF9FDEFKApDeRw6J2SSpmyz60wnF5+k+2vcfUv6Cd8KghtCC0wQCRJoQLiwb6LWHuQvAOt/IBohmYoxsS5YtLOmLWhpr8SoOGPKVe9iWEfttpHwBxw6laQwJLi6O0DQ18nBoU2Xms3TIQbxvrJReSKpyu8d6RAygkDB7LkkHmNlPfELsINJTLtKSUQbyUInXFubtdwSai1jPkApJnknANSEY6waLq2gFN8KkMNlExUxtTbxs6m/S8MXONBkY4I3cRGgrTk5dxPhBwajPH4px46LmI4mAcklndL0jc7/k0HTSIU0ifwLPAPX/tLL/2OmV8XJXdi7+0ENIMlYHaPIKA+AV8xJMhPpmP21GqZYnRV5+p4NfdmExAb8ry84pbDGqCvA9DViSrgrbCD81PMFdkBiBx64KOLQxDvNgLebNHQJCsudpaA1iWI0G6Y+v1UYGM0VHGsYxh5yX880+k6ZCEVpEPA5idY2n30T0px3SMZq+gVFcix4sQDdfkGfczP0qmssv4mlPawsaZ0tSsEVbyyqNqN99
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11 Oct 2025, at 20:41, Wei Yang wrote:

> On Fri, Oct 10, 2025 at 01:39:05PM -0400, Zi Yan wrote:
>> Page cache folios from a file system that support large block size (LB=
S)
>> can have minimal folio order greater than 0, thus a high order folio m=
ight
>> not be able to be split down to order-0. Commit e220917fa507 ("mm: spl=
it a
>> folio in minimum folio order chunks") bumps the target order of
>> split_huge_page*() to the minimum allowed order when splitting a LBS f=
olio.
>> This causes confusion for some split_huge_page*() callers like memory
>> failure handling code, since they expect after-split folios all have
>> order-0 when split succeeds but in really get min_order_for_split() or=
der
>> folios.
>>
>> Fix it by failing a split if the folio cannot be split to the target o=
rder.
>>
>> Fixes: e220917fa507 ("mm: split a folio in minimum folio order chunks"=
)
>> [The test poisons LBS folios, which cannot be split to order-0 folios,=
 and
>> also tries to poison all memory. The non split LBS folios take more me=
mory
>> than the test anticipated, leading to OOM. The patch fixed the kernel
>> warning and the test needs some change to avoid OOM.]
>> Reported-by: syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com
>> Closes: https://lore.kernel.org/all/68d2c943.a70a0220.1b52b.02b3.GAE@g=
oogle.com/
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>> include/linux/huge_mm.h | 28 +++++-----------------------
>> mm/huge_memory.c        |  9 +--------
>> mm/truncate.c           |  6 ++++--
>> 3 files changed, 10 insertions(+), 33 deletions(-)
>>
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index 8eec7a2a977b..9950cda1526a 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -394,34 +394,16 @@ static inline int split_huge_page_to_list_to_ord=
er(struct page *page, struct lis
>>  * Return: 0: split is successful, otherwise split failed.
>>  */
>
> It is better to update the document of try_folio_split()
Sure. Will do.
--
Best Regards,
Yan, Zi

