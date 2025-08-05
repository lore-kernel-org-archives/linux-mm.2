Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E23EC87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 14:26:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D17568E0009; Tue,  5 Aug 2025 10:26:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEEC08E0001; Tue,  5 Aug 2025 10:26:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB65F8E0009; Tue,  5 Aug 2025 10:26:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A6E7E8E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:26:29 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5AE8C1DC1F6
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:26:29 +0000 (UTC)
X-FDA: 83742929298.13.FCE6813
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2077.outbound.protection.outlook.com [40.107.220.77])
	by imf03.hostedemail.com (Postfix) with ESMTP id 70FE82000C
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:26:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GAsWoSRe;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 40.107.220.77 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754403986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RS9x5DfNQXfysLETdt/r5aW0l6AkJ2wmyu3j8iP5zzA=;
	b=Im7GyL98cKHKnmNO4YgcqmvcP7UPg9q6Hc7HmpkutTbN0/VWz2XT7/5z8S76yNUr1Qk6au
	ELDg7JVhrXPAMsmWts5Yv3E1S1rv9BqkHhwtmZNlxh6KLm6nW06ePXlpi5X9VvXR7RG52e
	kS/bkY5/Ns3A2WNfR4xTvbVlNnM5ViA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754403986; a=rsa-sha256;
	cv=pass;
	b=LqWj/fZ423I+iNmh0d/S4A5a0fq/Bo8ZjdKV77WvtrhgBZBr6npAgjNTNlTp9FZwICnA2N
	2VqR1WGTwVBZPbhxyarrjuhnuZNGrmE8dXmnZsfNnJd4AQ0wkBcNIFLF1Ve1dPLYAMJjml
	yhxd431SvJBoCu75+glfYFpt8VoiD1k=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GAsWoSRe;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 40.107.220.77 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pwi4hHi+dWlAwOZDayd3suwbutRlOaQ/7P2wGbhDs+Yz2nj8/jtPVfzn02lZLnXGfkWnB4ZSQgnk1WremsrA2Ij8rOnOL5vuz4X2l3Bq6ZomJvOqI5Av6Ho0d12IQ1/Ci/ECYRjZHJQjlMVO5dqGb2l1wCHV9zBsuPR1j8oFYWJ3C0Sxd+Dgb4jbV8czN4fG5XE1LRHF0PTzR8u2HqiBxta7lKYyhV1A8TlXXO1Gmpsh4/zSVfufuiZiNZxBu/NjiNRrL3iOdloYG7k32m85lh4mz4sgudK10nVBULcmOI87DaPJdnWOrmP3xp96fs9zqjU4igf6KfoZhkSAr8IyqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RS9x5DfNQXfysLETdt/r5aW0l6AkJ2wmyu3j8iP5zzA=;
 b=j4T7oDrH3bv8R79q4qjXVpHPN2aT5GyYX9ZijOd491Uj4xOwhFeJRaZ/vlEU4rUtreQ+iWWiEyF5T4Riug4Gkl9Paa4ucA35/US/6XnXoDajH5JTpBFu3Gp2Dlls585lBoCPvmRw4zlnydT5pKDmr+xCIxfZ3q23Twn3FBqRUIc2dZXxML8UrOeGcpeUJbcgL3Nca0XjrytKxgfLJSO7sX0PJ2jIXWUSNfhv66u3Oaax17qRvZBQJWX/0IPoIDhr/oLQaZQMhAPeNakV6XLvaYztWgRhQayacAmwdh8SSQSgm1Lw8Q6eJxRy2o/Y0Zw8TUtI8oxSTSYRw22W8D+2ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RS9x5DfNQXfysLETdt/r5aW0l6AkJ2wmyu3j8iP5zzA=;
 b=GAsWoSReaaOFzZsbuGRPlk6qa8luZK/SXT9as9tj6pISNVqDJCTJ7tIWBOXY562SDk9TnZvs23BEjPjpdMAfIPKnkrtK3kOFgNpUCBL6cdJmKdpwjTOj9z7XCbt/ZZtzgKwDJR/OLOdZprOb2AVHWBCB3DPU9oc6K0qAluYFWid1FGoxtZePGGZSUIv7H4LLNorxWxztkxODm2vnMqpuPpTSrqfnDGVL8ZZiXc+27FpbkiiB6EY99zqHiq3J1S/WcfsF3ysoWgSf3cY7O9HZzUPL791PwvUijSnzIh547+C/Wutj68xUPLHHDTyjbaHMyCnzHBF8D2J53gugXmgECA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA0PR12MB8907.namprd12.prod.outlook.com (2603:10b6:208:492::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.14; Tue, 5 Aug
 2025 14:26:20 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9009.013; Tue, 5 Aug 2025
 14:26:20 +0000
From: Zi Yan <ziy@nvidia.com>
To: wang lian <lianux.mm@gmail.com>
Cc: akpm@linux-foundation.org, broonie@kernel.org, david@redhat.com,
 lorenzo.stoakes@oracle.com, sj@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, brauner@kernel.org, gkwang@linx-info.com,
 jannh@google.com, Liam.Howlett@oracle.com, ludovico.zy.wu@gmail.com,
 p1ucky0923@gmail.com, richard.weiyang@gmail.com, ryncsn@gmail.com,
 shuah@kernel.org, vbabka@suse.cz, zijing.zhang@proton.me
Subject: Re: [PATCH 1/2] selftests/mm: reuse FORCE_READ to replace "asm
 volatile("" : "+r" (XXX));"
Date: Tue, 05 Aug 2025 10:26:17 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <22169C82-5701-4ABB-811F-075D22CE6FCD@nvidia.com>
In-Reply-To: <20250717131857.59909-2-lianux.mm@gmail.com>
References: <20250717131857.59909-1-lianux.mm@gmail.com>
 <20250717131857.59909-2-lianux.mm@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN0PR04CA0190.namprd04.prod.outlook.com
 (2603:10b6:408:e9::15) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA0PR12MB8907:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d505207-99e6-4c1b-3563-08ddd42c0c07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zAyrm2ma5v6gWzfDdrYfaX2Wvt61vLug8bRW/auFodFF/Oxwc4lC+hvfnSnq?=
 =?us-ascii?Q?0pl3BQuxX1dAvqUbyjC4gNcJ6El55cVUOGe/rj/D70VsJNDiy73HvvCti877?=
 =?us-ascii?Q?FVu44MOgxRI/Zbwxd5uLaxZp4kdfTHasiauTw2bqA/kQZ354obB5Q92l1wXy?=
 =?us-ascii?Q?3HBYZL0UMH0BBWgEjTYQrGNyZanfoMforusBdvrGdXfoCK2lXmcn3QYXaI+Q?=
 =?us-ascii?Q?CC0KcIDCe37MZswRk2ydB8l9Mps80DKgDcUeryvqz6SZvqa2+DTDfPRZ8njM?=
 =?us-ascii?Q?U94e8ofGF70jDfr2jkhh2c2qfWr7TLHUTewH95sNngTiVbfZB6+ONYnVUKjH?=
 =?us-ascii?Q?CYyOZSW0EOfklKsKl6lB21yGF/KK8zeRIP/8KIlDdqhxtWZxrOMiacrrAFql?=
 =?us-ascii?Q?Qlyu/TyJIrn1prREjPxRsSWp4qkMNjvhb4n3ttPfUh5OQEGlv1No5ulg2For?=
 =?us-ascii?Q?434RQHU+G0g9HKqTO+xT7b1PD5e6ND2JqqoYuCgjr7oUwYzVxZoW0+UZwbOX?=
 =?us-ascii?Q?c4khVKJkqtqqwoL8iZVNQr1nxSK4cYNWTClzmBZo5scbiQpn0o3TGwF20nWL?=
 =?us-ascii?Q?Rz4Bheav4/+89ktL/pPp3zAlob8TQHKk4NPl7LYUalZL0fd7CLEQOB70vkMV?=
 =?us-ascii?Q?nA/u1jmYgmh36/BBdqUzwBQ+sbA+BdNEC9ysk8aRrB2E75mfGvt9uduhxW2L?=
 =?us-ascii?Q?jwzFhymxmftAd2VdA3lh6/ZmQVnpyW8C4s8Qfutkr2GEq4hB4g4Ay6cnSyG7?=
 =?us-ascii?Q?VuheyOuUwR90RdGI6rqWnrqXUZQTvTiJHgoyyQ2HWHitnXUyeZ0t0iNHcD91?=
 =?us-ascii?Q?lUa1IGHQdXecgBFp6m9bHP0rDPj1nWJI0OW5E3NTzLxuVhfX6tkuxvKssERf?=
 =?us-ascii?Q?eNvftZ7hQC5pkyKBJyFXxcy+jhUVH35uQME5k4MKyhrJUDTdQROlFhPa65fx?=
 =?us-ascii?Q?4HrIHElAMAhmOVTiGCyVuZBizld044F74iFMFp7JNI2GRI5f84pps1p3+PIa?=
 =?us-ascii?Q?S3YnRmJ+Vif2MX2luUn0dldiEHiU8z2hQg5YKLjIWx3j1ad2UmJnCvLJGg3c?=
 =?us-ascii?Q?43oX4gjKX5DAI2+DT3LhboDWOFUjC/CgxG2KogAkV/CxOPGNUPa90E/5A6Vt?=
 =?us-ascii?Q?CiVyq01I9wgAgGEe9xAEx0G5UNwEWvnTYVU70ds5MiIvS5a0DM8mDdWnvbRH?=
 =?us-ascii?Q?aTesc0gxMkg7sJjmQlX7gKKnNnsI/kqJ2efdDRDaBqr6W7GDtxAU0EMKXXjS?=
 =?us-ascii?Q?SaHnXovu+wSqmhTKx6sC3D8SzWnNEGwhUaiR2D0uET7Pilv1F7YF2fQkWA7T?=
 =?us-ascii?Q?JSUdDT40+4CRmbOVfazOKR9lf+8Ly3LMFSxvL8QmAg2Ca1fZsRM3UWkp745q?=
 =?us-ascii?Q?bX+HiIkSM8+xA3S7aCgnzYJZ3K1VaYTuAzhzXpNmk52v9QPcYUfWnGl1dcfX?=
 =?us-ascii?Q?3DptW5oXIks=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2gNc+SvKtuJU+7e7kQBrlq8it0puAG9KY/2in6Dio8dR5kOCKREGeV5yKaZi?=
 =?us-ascii?Q?8xCuJSSRMi4NMn8OzHvbtBLIxuEezWflESaJOfdiLjnR/M+zGNknxNJNn5gj?=
 =?us-ascii?Q?eGDKPw9krgBOLLkLlbQ8d82OkKS89PbVtZHloYKJJ9NApyvIPMtiF/I66AMP?=
 =?us-ascii?Q?/UllYIru4qWIKg5yBDyT1x+e/cQTPc5svVTdGF+8Bazag0ffVZLEFliUw+Fd?=
 =?us-ascii?Q?njKFkwnXIs9hQjTOJ6tZdL/ZNLfMID1x9I81MnCHXglF/wUxCZV8w7Qx3YAr?=
 =?us-ascii?Q?EdV+/RbbncmI+Zx5yHofBjzLjK5uSy8IA4oxPBXeHAv7tFpv72mFrNBPDc7p?=
 =?us-ascii?Q?zX+Og07rTLgBFcIPFvvHOe7GcTumows0h4x0gT0pApQu49h8hIFbAcxN7JjR?=
 =?us-ascii?Q?dkkwn8WtLtcEt4IM9uegyWVc8ZA/b1RGP51aXZrvNrCMLsmz0eRQbrO+0vKN?=
 =?us-ascii?Q?CjNR3Z+JIh//1QiHHSRPUk+7COWZFe290uB0WPUmKf/9amD0WQKJEkW4KQ8c?=
 =?us-ascii?Q?kffuCx5hVTKvBXFYuCZTfGqwsfuDMeAi5e39pKfzbbcaYR1LADYwdoRUQZQO?=
 =?us-ascii?Q?SzzZNZfkPhNu23KP748qEZKOGbiYJuTxLsIIk1XEOhsPHEbCcNRn+M8iw8BI?=
 =?us-ascii?Q?T8HRlo/C4Y6uM5ozZh0mOhILYGEYVh5lBrwIISFTriWhs3BfNZcuQcReZod4?=
 =?us-ascii?Q?/aoYeRXwe61e62sHibyyY0V2uXlvV5b2GQA1+lcZp2ERnuwrDeD1J+Gum3PW?=
 =?us-ascii?Q?052HNzyGh6KOq3kqrv+Yfyg8aYlrDKUorzJjayvnw0ofcvhmeWaTqOGjOW8J?=
 =?us-ascii?Q?rv0FoUPEgORh5U8vCBdo6YbO1McXiAAwvDC+MKGQcwFEYi3TPVan2QibRLIV?=
 =?us-ascii?Q?PZ7czujnwU0EM5WT509uVzx6p0016zmHzy8t/onsvtt/iymwyQbIYAJhNWhi?=
 =?us-ascii?Q?6BQ3EdGPIHWk4gLLoyC7Ab5GP6lyKZgoS/KTj3fEtdyn4o9/0m91fKgeC7Lc?=
 =?us-ascii?Q?n9NbSPbeGqQIpmz0n9XrC3lEuNNIxMiT/pnUqeh77PC2f08zCOiKl/iGQeCu?=
 =?us-ascii?Q?nXVJEb6tGMADd0W7jOIJR/L2PqG7GSNNg5kbLq4GzWhdD5Hwmt9HvgrYM5ne?=
 =?us-ascii?Q?cVBeQZzbSm/Do5m1B2zTQSNI9HTnWjOgQPRFhQGB+2atbJUY/jUTbCL1BQ1/?=
 =?us-ascii?Q?+TJ3enOH5qECExsCWe1wIJj4lMVvWeD/Q1eevAPRHp5Zqdlp79pry7a/gHeO?=
 =?us-ascii?Q?V1XBVYT+I0TSc7V+1hHr4/vLyJj7nMk9RWhcJ6SuZtuDnTG7cdHDTUThB7qJ?=
 =?us-ascii?Q?pBMbeZpI2u54slG/TebFwYGLcvQrDmUEJyhbmF+PiQyOxXgV8hz5FceUJfBD?=
 =?us-ascii?Q?eW01JvJl+bAhQCh/1nE4aKis09JdCldUJB1gJMayYvIj/+AFWWtpn+KSDLKP?=
 =?us-ascii?Q?hdJjXIf4UL98SjLvibTFzOriEnG2UgGL/RRI9Ghot33bIfXokRPAVuIcXPZc?=
 =?us-ascii?Q?HotKBz3Q0dsPMaV6E6Ep4ZC0Ol6M9fUVTQ9YzaOiHrWCJefHWr2VT7svISbb?=
 =?us-ascii?Q?zVh6oZENKYjcKL3xB07iI4CgZNSpRsII9HjI52hd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d505207-99e6-4c1b-3563-08ddd42c0c07
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2025 14:26:20.3458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hhfuQdn0fR2p5NSX887J8VKI644gYfeuZPZpWWLFkipjPmlChgQCBGqWvdiX7SZZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8907
X-Stat-Signature: oskydyaqtxnminthuyuasftjsrpebcpo
X-Rspamd-Queue-Id: 70FE82000C
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754403986-234752
X-HE-Meta: U2FsdGVkX19uocUCXGe5Uvg400KKRTPMIcv3qIfe+jsGdJlj6rNn1o2heAgOkYnKXSxRk2VySsybO/7OldeO1Yyz6L7VfUhFmhdhDQ1Q8kbjV6A8BGjUqTsGr0WdE2K5phsNw2s8NUSSncrv+iG+39nqH9GZNsMpBgQpeSmkGabIDR+2pfAlN4i+YX4vHSCh5eIWfOVNY9pY27qFluTzJdCjYPhq1mxiceCokMt8XSJOelqjhdmuHvsdQKUYFwr1jl20E9VEyoGgaYYl301fXsQJEcXe0f8TexrahHL7SSbT/IJmHQR+IsT4uaOEAosZTBc/OqKpbznGvWsxb4etEv5a1UlYaePfZ74KJhbADrhnWKwjyLzfJzbs4SBZsrMeOGU0QBZ3QQLOrAMe/dPtzX9XH4oS/xM31zCe3/kCsbbgUhhdhbuLX/hoX9sjIdnDK64eHIbb8qdTos8EkNzQIT2NIoMgbK+/FyuSg6Ci3Sf3A32ZWdKi3b1RQSt41pWE0/RSbjVzlGwLm+wZawN76IbkiiDfXuv13hreka23v6n1dgKcE94xpKtqR3GB/mBFrIZi4vPP5XRmW8U/33w5rqYZvKVlVV07W144g6SwdQFIxTxJn9fX2CJiyg1MiLqXQW0TxIFDc5FpstsFXOmSTQQA86HSN12GlOZOLgSmJnphL2T4qI6lJUwb1J4k0i149XbGl9VlDgAXSlh/RwRE0ERc7T3I3GmBXDShp2b47oCOY6FCdk907/HuBEOvnC8wgMcWTdn+NAzqA0psAD+NaRmKCQ0XufgqM2wBtaRwtN7X5Wo0pulU35EgxNJtvZtbI25f7n69tb3eZW0sdx3Rn8BmaDy3AOzkXfE+8r+NlfJ7vNZ1YzA0O/fJdz6YTrJ/motyazslNAYBxbXKDQt589YaJlHjPIo3iuK6LfnJwkCGloroo3reI6q8BvW13kN3kVQIrGWFQVpSzDTEILe
 pmux0DBn
 zSAe4pYSYRgSzvmESn902ZxBnv6h0nC1cziOSST8LA/grX8Ek5kNJJGUk66ty+N9RGz+DQpeIms1UfuqpKFN73GC+LMyDCSCm7HFAMNmaN7AIOUbASg+bNYWIo1m26cA9jIaMI23utDR9iWF3Vsd34k00c/XYvS+1JHb+c2co0G6CWPTnFMXFQ3BJzGd8TSJCtztZlJEyzfl9Vp91Ed8GBGJH27qc0O7BI0C8RJkx/0tH1er+KV3Z1ybbJN+/0fzTmAit0vWcoJQcUFGXgGcCQ496GC7naHnn4nuuTbLnYD6CkWjq69N1KxgcQ/83chjfT4lyHZ9QGiJe6qCCG/8hD8bzFBGrKEoRZUmBHvpPZOjaVK+x5hrUeSaR6JXqAdxPBZkblC7bXahs5VY+HoGJsWVoY0wwAiYOX5BrOAfvWDkWU2IGTqSSvQvA0jrD+EsvJFurLhS+KW5O14v0O6pXx3Ttdm7IRh6ex5jCeY2b2guTyPywL61/aCimpIDq4anZORh0o+9Oij6crNhc3h9QzYol3akETS9O7Y2aGXanjYWVepFa6mRJuK0TN8vcP5WTDwbhPLcRo5XZD69NW0JchIvl5uEUQEF6FILY98X/082Din27APdFSmfyZGDhMYNcQWIqVteNelqwJZ++Si7IdFeBseFSGZ3tg1Ca
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17 Jul 2025, at 9:18, wang lian wrote:

> Several mm selftests use the `asm volatile("" : "+r" (variable));`
> construct to force a read of a variable, preventing the compiler from
> optimizing away the memory access. This idiom is cryptic and duplicated=

> across multiple test files.
>
> Following a suggestion from David[1], this patch refactors this
> common pattern into a FORCE_READ() macro
>
> [1] https://lore.kernel.org/lkml/4a3e0759-caa1-4cfa-bc3f-402593f1eee3@r=
edhat.com/
>
> Signed-off-by: wang lian <lianux.mm@gmail.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  tools/testing/selftests/mm/cow.c              | 30 +++++++++----------=

>  tools/testing/selftests/mm/guard-regions.c    |  7 -----
>  tools/testing/selftests/mm/hugetlb-madvise.c  |  5 +---
>  tools/testing/selftests/mm/migration.c        | 13 ++++----
>  tools/testing/selftests/mm/pagemap_ioctl.c    |  4 +--
>  .../selftests/mm/split_huge_page_test.c       |  4 +--
>  tools/testing/selftests/mm/vm_util.h          |  7 +++++
>  7 files changed, 31 insertions(+), 39 deletions(-)
>

<snip>

> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/=
testing/selftests/mm/split_huge_page_test.c
> index f0d9c035641d..05de1fc0005b 100644
> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -399,7 +399,6 @@ int create_pagecache_thp_and_fd(const char *testfil=
e, size_t fd_size, int *fd,
>  		char **addr)
>  {
>  	size_t i;
> -	int dummy =3D 0;
>  	unsigned char buf[1024];
>
>  	srand(time(NULL));
> @@ -441,8 +440,7 @@ int create_pagecache_thp_and_fd(const char *testfil=
e, size_t fd_size, int *fd,
>  	madvise(*addr, fd_size, MADV_HUGEPAGE);
>
>  	for (size_t i =3D 0; i < fd_size; i++)
> -		dummy +=3D *(*addr + i);
> -	asm volatile("" : "+r" (dummy));
> +		FORCE_READ((*addr + i));

I encountered a segfault when running the test on x86_64.
i is 4194297 and fd_size is 4194304.
It seems that FORCE_READ() is reading (*addr + i) in 8 byte size
and i is only 7 bytes away from the end of the memory address.
This led to segfault.

(*(volatile char*)(*addr + i)); works fine.

Both gcc-12 and gcc-14 have the issue.

>
>  	if (!check_huge_file(*addr, fd_size / pmd_pagesize, pmd_pagesize)) {
>  		ksft_print_msg("No large pagecache folio generated, please provide a=
 filesystem supporting large folio\n");
> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selft=
ests/mm/vm_util.h
> index 2b154c287591..c20298ae98ea  100644
> --- a/tools/testing/selftests/mm/vm_util.h
> +++ b/tools/testing/selftests/mm/vm_util.h
> @@ -18,6 +18,13 @@
>  #define PM_SWAP                       BIT_ULL(62)
>  #define PM_PRESENT                    BIT_ULL(63)
>
> +/*
> + * Ignore the checkpatch warning, we must read from x but don't want t=
o do
> + * anything with it in order to trigger a read page fault. We therefor=
e must use
> + * volatile to stop the compiler from optimising this away.
> + */
> +#define FORCE_READ(x) (*(volatile typeof(x) *)x)
> +

Also, look at FORCE_READ again, it converts x to a pointer to x and
deferences x as a point. It does not seem right to me.

Best Regards,
Yan, Zi

