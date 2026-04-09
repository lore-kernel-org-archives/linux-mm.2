Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24117F31E31
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 15:41:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 416ED6B0005; Thu,  9 Apr 2026 11:41:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C76D6B0089; Thu,  9 Apr 2026 11:41:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B61D6B008A; Thu,  9 Apr 2026 11:41:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 184CC6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:41:19 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A655EC291E
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:41:18 +0000 (UTC)
X-FDA: 84639431436.12.BF1C79C
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010037.outbound.protection.outlook.com [52.101.193.37])
	by imf12.hostedemail.com (Postfix) with ESMTP id A3A844000D
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:41:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="o5q/pN46";
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="o5q/pN46";
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775749275; a=rsa-sha256;
	cv=pass;
	b=VF3kOLX99YOby61q4woH6U3GTXbRm5IqHalbau2JluP5a7iE+EAJoa2wGiO94KGi0G3j7r
	BN/nABF4SJ14vtG+iufaEMzRy1gZf8iCawuzl14Mi49cPxzh7eF71yjlMy0R8asgV7c3sb
	O9hyaEJRxslsqEzjFG9CA7qeRBrXvxM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775749275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F6lM/89EqIC9u9MyeUgsTk+X7drXHqb2suXqf88eC2g=;
	b=5BKYMjtvbrmj1QMo8ei01/58zS0B6wOuyhMEhZaJbRKYuOeeQTxQFzbj/nRzdY617+z1oy
	G71i2EukVUPupce4jKS5n1DkfOl1BR4l0OX1xqTQ/ad6ikeZXVgfGOEsHetiyzt5IPgjAd
	QypZnGSTuBCciOPXDnuY56s0aPTJ5GE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BeX6BdXoLJUDrbps4y7mlxygsZzWGYyQeHTtbtaMg+A30NyoPvzcFGS23Kwpj5ZgFfUTIIiJaErCkLj2X83JzK95mxgNbhGi0eooDiGeVWH89eLrOVPUir0oVwKgKDYgWDMD28KfGCVbeM6/p8qTPcLpsV2JW45Gwi6qHpKErbGqiJMMuMfPL4Nx0I4zF88kKyLM9CtkWtSE8cv5HoGV/RSxxrJS2aSJ0vZZRLuAQDZrIdSnsQIYi2tIzRhH2NF9xebB6jSkkpgnfcJ+NM6y9R4LZPVAvQS43BNHZ49VuzG8MDV6zMbnZBTeQC983mh5uJa7GgoW2I36GAn9Vrhlug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F6lM/89EqIC9u9MyeUgsTk+X7drXHqb2suXqf88eC2g=;
 b=BpsNRMp7m5BcveloVE/5LW9b3VtFYcySJhsfCu3IvA3zHoaAPEvOEXy82TZJ5Rj6OF/cisSWsd1bDr7rSz5xWVx620729BttGCV7SjX1fZKwvMfzsM/C/QEZJCjoLY15835XCDj4KInA0FSW2pRlwEnGWyb2cdx5dHp4Ev2dr0nnxRbRpGQb+CFKY0J3obpq0f5HpPNrzSzaC1tSqIDeTpE6WZJAOywcg3wPZZ6nbqvEq1BEhU7RNytiPlFLU8qs7YhVvgo6AFMjEmv0f0wuPV/5LqCP9CGEAyu7TzvhfPNDtotCHI/JyHj9OgAs6nQlvrRvRdW6/zO81340PR88aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F6lM/89EqIC9u9MyeUgsTk+X7drXHqb2suXqf88eC2g=;
 b=o5q/pN46+fLD928G07Jhq9lmWoGifsFI+GHSF2ZhKzF99WwBmclQ5MgF7RWC58SmixUcSHbASyuXcDHrn4eX7aeq0YHHYg+ffxgRfim8gR9UOd3n7okzGW2kYx25MKenaXrHrMpvs0whAh1PoVMM37xEalQ/k9Y7oJaDmQPUn/DmYaeJb1rXkoIWsA/3u7bwb6NIeMJAF0wkUmJ5JFfRPhThSPO1nmwfSyTK6gKXHuJZYBNRZzfI44Iy2U6IppcPtt5BRSssk/4JI2PRotJFA61qD64L4UwLGIkVOgkWGsCVaxQtzPB6+sD6Kuf8/H088im2WCb8l7EBBoX5ZoH0pQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ1PR12MB6194.namprd12.prod.outlook.com (2603:10b6:a03:458::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Thu, 9 Apr
 2026 15:41:09 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.014; Thu, 9 Apr 2026
 15:41:09 +0000
From: Zi Yan <ziy@nvidia.com>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ryan.roberts@arm.com,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com
Subject: Re: [PATCH v3 07/10] treewide: rename has_transparent_hugepage() to
 arch_has_pmd_leaves()
Date: Thu, 09 Apr 2026 11:41:07 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <A1A0BC2F-A9AF-4929-8774-C5841A3F6020@nvidia.com>
In-Reply-To: <4f640655f26b4cc2056a62bebfd570686dd6dc3c.1775679721.git.luizcap@redhat.com>
References: <cover.1775679721.git.luizcap@redhat.com>
 <4f640655f26b4cc2056a62bebfd570686dd6dc3c.1775679721.git.luizcap@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0315.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::20) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ1PR12MB6194:EE_
X-MS-Office365-Filtering-Correlation-Id: 04ad1d77-23a6-41e3-0d84-08de964e6bb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	LmhFAvSFZjM98UyvBuirdCVIBL8BYWN3O4gOgli+dNtaYrp7HsWwASsjMupLCPh33oxBFH4cz1lw0K9iEZWrvPYUSawXXEXyLyAQGNujfHPIGwvYrRlg09xywdhLbfNVuS/ojeubMj5m9+Xdqy95J58hiYADB/vezNBOFvTVhTlqu16Ugz2/OicRfBa6cBTTDpvCfIe23HpU6b7zR3H/yC9wMI2EXEl4ZdIzTvS2QbweUeEwWOXNu2zKc1eqWwyXqQ74+q/x/E3xBgLM6H/oiHgNP29i8xRx/mdldnT48NsLSKTUEcCZHNmhLz0le1TcHvbwPYoIjYJZfulF5nFQehh2u3tnaa/fjWWpj9VkZhaxrJn8n1FZR0k87kTkKmx1q3We19upyav4B72kQdwBJr8P6877DTGpOnExJ6rch75aCvqU06DrXOd1j42GlFEREN8Wbw1ap1BpWJsbwbuufBV9EEpj7/6uu+UtX/yWcakiHpkW/ksh5BdfZs6XXfBD/GVOHFwkRL3/o505i4zeCwrSADX8shKKyQ7z+a5eQcckIgUkbbqyE50YmUyfh/1WItA4FIEAFH1bzzWNvSPjHoK3zF8cWzaVI/NbAnLQBa7i5a9duh/qzogt1i4bGR0KdQTbaIpx0Sq3yEBIlJ6W+oxVfmCay3jrlN/QQd75KEG9m+lOinXXPTmNqi3AtqZmy4arUJqIyrLj5NBqZMPTAFjyRWirfKOZ6THfv6M9/so=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?b2pj7BCq8IE1bx6LtH9ViiDXFLES1YsxYS9OF07fP41eu6XjoU3D/4BDUcqN?=
 =?us-ascii?Q?te4O3HZIyiC6ox2QWkUKt5W6D+GYAhWaatQ5xWKTCylSD1stOaUJQCZeAxZd?=
 =?us-ascii?Q?XH67/w4Qzhqyul8L94XkcpMD8EoVdjE4WhBHLVn0eZWDTguqealqJ+ghrdM5?=
 =?us-ascii?Q?fXGoTWpsg9yujl7A8nZ8kFZr7q7dRLpODdmBVcjRLIcx7NSSTm6aM/+CfGq0?=
 =?us-ascii?Q?tNHCLsjHwo19o9XRIhYNs5PmxrIXoE/oB4maTIMuHftPS7AY0ivAJ7pDa8mY?=
 =?us-ascii?Q?R3VVsCv2LDVVgszX7a47PCdvJ5S0zBEgSygMf0emgEPVLFJL//m+IrEVAaoN?=
 =?us-ascii?Q?B2FNm543t5F5Q0z+5hoxwGRaP7bHVQRDRDbWZrjmXSIRBjKv6XmkJR3SPAID?=
 =?us-ascii?Q?MMQEqZxk8J4b6Mcr9pNujFuLDb7cE49yvWAEDCHgz+MVCO1ZXeEuU70Jb6Yn?=
 =?us-ascii?Q?fR1mSxDoKV2oCkd1blGAd6RKAAmfL74woXHY/RHkFTLyQ+RBnCkIofWtbLGT?=
 =?us-ascii?Q?3VZT97uFjXAjn7EPXzWAmgSx86DqrqTg6ENT1b7lnaxI11mJwb6LKu7z2jvj?=
 =?us-ascii?Q?FxRzHuqPOQlAQ9BXaaH2q8RDOemiX1PN29PcvgAiKN9en+964TmslCJHORrm?=
 =?us-ascii?Q?uKBkAV1wEs4WtOhVTnZvytVNOzQ9Io6LV56VV07sAq63rYr0IjjqLo2i1ZSu?=
 =?us-ascii?Q?P500ocVV4Xm4qQaf3flfEtiVidVTCnupr8pEyK7DUeA3ELaHd6Q9UXaHr4Nc?=
 =?us-ascii?Q?42hjuL4fD1q8/YIBz9HqZgkxmUZGvWg44I7poHNwpfKMEjzNE0XhLQP9e36M?=
 =?us-ascii?Q?CTnZpLn2Cm/Pxv+4bvZYhHdABfMCu249av3OFzGRqXv8UhyPtab/K9B1C2fN?=
 =?us-ascii?Q?D0kRocAKW5XVhsR95i9F0L/vM/e7CcGtMWMSpOCsJOG9kafWXvr1VZrL1tyu?=
 =?us-ascii?Q?7TzZihuszfzVrQ7YAICJUvuNrOWD6tL7Yk475r77Lyx7a8T/8gaYBvh8t50E?=
 =?us-ascii?Q?l3b5qpxpyiVn+n3FG1bjgv+Xc7Awa/xIOE9QLlLh+Wd0pBVKg7xVFG95Re7o?=
 =?us-ascii?Q?z9mk09FkHAzoWlKg2ZrYs9EYExPzoLhk8Kqn38XwrSOTMVFLc21QysAABe3Q?=
 =?us-ascii?Q?4q5yUfJI/kV9sRs1hYivY9zBOIEnoHH5naIYsM6CyIrxZvtR7h6DAoK88o1f?=
 =?us-ascii?Q?YFTXUAMY3DF34AeZCIM9ZhAQ216KlxGYBjgNermF7Hpms3MPAbvHvYhc26MX?=
 =?us-ascii?Q?04Hh+UOALzCMWp0XsVh4gGXmDrWwRTPasaXL+voGceDU7BzcouFhnQv7Yfka?=
 =?us-ascii?Q?BqSFKR4yE8l95VlOVmrd+qdn/wBzl8/1GCdsU0Kmu5w9q4suP/odr1Pbcvm5?=
 =?us-ascii?Q?fSeemPhlMdb/qamDghq8tysCFHSi+F52WrzOXfbug0tc7Xxa5AKCJozW7uj8?=
 =?us-ascii?Q?yeCB6rNGMMk7tM/KQalWVN76vavXKPqMX90YeoiE6kA6G4I5/fUV4eTHUHeE?=
 =?us-ascii?Q?57YB443wRNP4k2YAFDJr9S5FiDbxYHh4ZnpnwYV+getgHJ34Fh97RMM/0Zm3?=
 =?us-ascii?Q?DQmft8QgXxv/G51uHTrQLWqf+H5mIqSoYUVJrgBcZSM+AnCIR/Yr8HcSDWpl?=
 =?us-ascii?Q?b9NhEPS5UlmhGS7HKbL4ejwfwgQ9ut7zo0OPDGWhlae8HScvcS9+URVJZR3C?=
 =?us-ascii?Q?dMr4h5eMugZNmCSsNQ/NRNgYEUqgkpG37B/z3/1LklMbbBx/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04ad1d77-23a6-41e3-0d84-08de964e6bb6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2026 15:41:09.3759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CuWGSyIYE49x5qf/LFBNlBbuWp/LfxjCc3V2+8M37gzLmJucyE2vI8qbu4pajAiF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6194
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A3A844000D
X-Stat-Signature: p84a6jqfpfmkp1yin3jwcubgc7jafp44
X-Rspam-User: 
X-HE-Tag: 1775749275-357332
X-HE-Meta: U2FsdGVkX18Q4FOnot+t0OACYFGbzxHhC7NRU5fKC3r7+cKpaoWfH1xQyI6d2hxHmoFc3TgjeJlpeD/j7bPvbvzb4RHihQBpYzGxxhg+4PjQ5mu4BixTHP3MR5pDrPCVHwKLD1YRXIh5kaMN3DXJxhivUPN8ZK2oSmU4az/PrjfM7tx9W2weRVSGUOKRyuCgOHrQOJobSLrZ5PJpl8LzJTtHlIl0KCANUHgrK1SJwC1VeS0191EQOIsfVvDhMAv7ufdqOnqzSrxMHuVtGyv6BAI/Q2+8HoGGQcoQnp4I5t3uf3WIom8dcVPKrYgigp9A+u3YsHSC1IZkN6v8YsMh/U60nLicX6+E1pe7L5AYNRPGdBDR6Lis+/TT83j5LSMpkoYD8G3QBUJLDsbdCGkJCRZHiEqQVeRA1/wsx/TxVgxeWGDfBsiAqDJr9lX6HvGaeSy6FGHYwi/40jzaAX6gFgWEU9+qXoxadx+xNhauvctNPrEIB807amzi4rLhEaCzNA3bViLIs/4JoaOUKybrMR9AwDpENxuAlQ5Lu7LhXdwHdbL2BXEH22+GqoogWfkVjt8taBKW0rncCmZcWZI4rB2W8t8l5u1RRRdufwIyrsRju3o4WtGyMd+7CHP9/yrSLTApr4eWVc0YYtKvMG4R7hR47nYtvss9Aqh1FXqHLsc1/H/LnmJMEn9F3TYRqM99by1LxKvQ3x4imsNu4V9q0kMISgeXqVv2BywVQwgkIoJfRUxkZ/oLx8XM8eXMxsmpTOwy7VEMnrydOuw9RfCV5FT4sviq0luBxsPH3kE9GDLtZmPV8vANSFu18jz4exNvCqkhn1GdCI5ffdADdJu8hP3iMZkGqRKU4V1Ngr+CtkDuUOPAf9MbBAJGDPt5LbG1Xj7O8ABSwzEz7dDtITxuSj3gFy9TN/xdICZKsY3flgtsfdwNwQ0tTpsa4443RLpIdoKxZ0oQUAEb8UxLH1c
 Jsu5IghI
 SKDkLa3UFOFjBAJegV2lKe62ygH9TnkCKPEqAm3XJH0tjuZQzDPlfpDvwwiqgFQstNmbPUfVlLJY27nlrrqhPbLnJk3QGkXUZqJLBQpx8aHqlygnjz4vQt9r3ie+n2Y9TEq++Dkue9ToBpW//aOrGK1rTl4MOGs3dKshf8TcDQKRwruNB9HrU1ykJ7mE/HEPANV2PDKKtbgpoz/9R2VKaGddGDFshhrc+GaWNuYHK7Ua8gN6FiUDkyX4tF3u2z6K+iL7ALLegUO7WC+avlePdc5vCLmyV0u1/tJANIEOVOfKxjPPeIONLflrdFhf0dZ0pply4LdSSUFOUTz1rqUxub4UwQXfQnNkK2cvbRvt3D1gBWXQz5tOAn+SQQ7im67qKwFEWlpoPoUX05G5+foAv5ulFn5TwPKj3P/78gbiejfmOYt3WNvN00qYK9xZ55mUyy858lqtp3RG09pvzKdeMVf/A9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8 Apr 2026, at 16:23, Luiz Capitulino wrote:

> Now that all the has_transparent_hugepage() callers have been converted=

> to pgtable_has_pmd_leaves(), rename has_transparent_hugepage() to
> arch_has_pmd_leaves() since that's what the helper checks for.
>
> arch_has_pmd_leaves() is supposed to be called only by
> init_arch_has_pmd_leaves(). The remaining exception is hugepage_init()
> which will be converted in a future commit.
>
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>  arch/mips/include/asm/pgtable.h               |  4 ++--
>  arch/mips/mm/tlb-r4k.c                        |  4 ++--
>  arch/powerpc/include/asm/book3s/64/hash-4k.h  |  2 +-
>  arch/powerpc/include/asm/book3s/64/hash-64k.h |  2 +-
>  arch/powerpc/include/asm/book3s/64/pgtable.h  | 10 +++++-----
>  arch/powerpc/include/asm/book3s/64/radix.h    |  2 +-
>  arch/powerpc/mm/book3s64/hash_pgtable.c       |  4 ++--
>  arch/s390/include/asm/pgtable.h               |  4 ++--
>  arch/x86/include/asm/pgtable.h                |  4 ++--
>  include/linux/pgtable.h                       |  4 ++--
>  mm/huge_memory.c                              |  2 +-
>  mm/memory.c                                   |  2 +-
>  12 files changed, 22 insertions(+), 22 deletions(-)
>
> diff --git a/arch/mips/include/asm/pgtable.h b/arch/mips/include/asm/pg=
table.h
> index fa7b935f947c..a97b788315e2 100644
> --- a/arch/mips/include/asm/pgtable.h
> +++ b/arch/mips/include/asm/pgtable.h
> @@ -615,8 +615,8 @@ unsigned long io_remap_pfn_range_pfn(unsigned long =
pfn, unsigned long size);
>  /* We don't have hardware dirty/accessed bits, generic_pmdp_establish =
is fine.*/
>  #define pmdp_establish generic_pmdp_establish
>
> -#define has_transparent_hugepage has_transparent_hugepage
> -extern int has_transparent_hugepage(void);
> +#define arch_has_pmd_leaves arch_has_pmd_leaves
> +extern int arch_has_pmd_leaves(void);
>
>  static inline int pmd_trans_huge(pmd_t pmd)
>  {
> diff --git a/arch/mips/mm/tlb-r4k.c b/arch/mips/mm/tlb-r4k.c
> index 24fe85fa169d..c423b5784337 100644
> --- a/arch/mips/mm/tlb-r4k.c
> +++ b/arch/mips/mm/tlb-r4k.c
> @@ -434,7 +434,7 @@ void add_wired_entry(unsigned long entrylo0, unsign=
ed long entrylo1,
>
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>
> -int has_transparent_hugepage(void)
> +int arch_has_pmd_leaves(void)
>  {
>  	static unsigned int mask =3D -1;
>
> @@ -450,7 +450,7 @@ int has_transparent_hugepage(void)
>  	}
>  	return mask =3D=3D PM_HUGE_MASK;
>  }
> -EXPORT_SYMBOL(has_transparent_hugepage);
> +EXPORT_SYMBOL(arch_has_pmd_leaves);
>
>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE  */
>
> diff --git a/arch/powerpc/include/asm/book3s/64/hash-4k.h b/arch/powerp=
c/include/asm/book3s/64/hash-4k.h
> index 8e5bd9902bed..6744c2287199 100644
> --- a/arch/powerpc/include/asm/book3s/64/hash-4k.h
> +++ b/arch/powerpc/include/asm/book3s/64/hash-4k.h
> @@ -165,7 +165,7 @@ extern void hash__pgtable_trans_huge_deposit(struct=
 mm_struct *mm, pmd_t *pmdp,
>  extern pgtable_t hash__pgtable_trans_huge_withdraw(struct mm_struct *m=
m, pmd_t *pmdp);
>  extern pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
>  				       unsigned long addr, pmd_t *pmdp);
> -extern int hash__has_transparent_hugepage(void);
> +extern int hash__arch_has_pmd_leaves(void);
>  #endif
>
>  #endif /* !__ASSEMBLER__ */
> diff --git a/arch/powerpc/include/asm/book3s/64/hash-64k.h b/arch/power=
pc/include/asm/book3s/64/hash-64k.h
> index 7deb3a66890b..9392aba5e5dc 100644
> --- a/arch/powerpc/include/asm/book3s/64/hash-64k.h
> +++ b/arch/powerpc/include/asm/book3s/64/hash-64k.h
> @@ -278,7 +278,7 @@ extern void hash__pgtable_trans_huge_deposit(struct=
 mm_struct *mm, pmd_t *pmdp,
>  extern pgtable_t hash__pgtable_trans_huge_withdraw(struct mm_struct *m=
m, pmd_t *pmdp);
>  extern pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
>  				       unsigned long addr, pmd_t *pmdp);
> -extern int hash__has_transparent_hugepage(void);
> +extern int hash__arch_has_pmd_leaves(void);
>  #endif /*  CONFIG_TRANSPARENT_HUGEPAGE */
>
>  #endif	/* __ASSEMBLER__ */
> diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerp=
c/include/asm/book3s/64/pgtable.h
> index 1a91762b455d..e4d9b884af5c 100644
> --- a/arch/powerpc/include/asm/book3s/64/pgtable.h
> +++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
> @@ -1121,14 +1121,14 @@ static inline void update_mmu_cache_pud(struct =
vm_area_struct *vma,
>  {
>  }
>
> -extern int hash__has_transparent_hugepage(void);
> -static inline int has_transparent_hugepage(void)
> +extern int hash__arch_has_pmd_leaves(void);
> +static inline int arch_has_pmd_leaves(void)
>  {
>  	if (radix_enabled())
> -		return radix__has_transparent_hugepage();
> -	return hash__has_transparent_hugepage();
> +		return radix__arch_has_pmd_leaves();
> +	return hash__arch_has_pmd_leaves();
>  }
> -#define has_transparent_hugepage has_transparent_hugepage
> +#define arch_has_pmd_leaves arch_has_pmd_leaves
>
>  static inline int has_transparent_pud_hugepage(void)
>  {
> diff --git a/arch/powerpc/include/asm/book3s/64/radix.h b/arch/powerpc/=
include/asm/book3s/64/radix.h
> index da954e779744..c884a119cbd9 100644
> --- a/arch/powerpc/include/asm/book3s/64/radix.h
> +++ b/arch/powerpc/include/asm/book3s/64/radix.h
> @@ -298,7 +298,7 @@ extern pmd_t radix__pmdp_huge_get_and_clear(struct =
mm_struct *mm,
>  pud_t radix__pudp_huge_get_and_clear(struct mm_struct *mm,
>  				     unsigned long addr, pud_t *pudp);
>
> -static inline int radix__has_transparent_hugepage(void)
> +static inline int radix__arch_has_pmd_leaves(void)
>  {
>  	/* For radix 2M at PMD level means thp */
>  	if (mmu_psize_defs[MMU_PAGE_2M].shift =3D=3D PMD_SHIFT)
> diff --git a/arch/powerpc/mm/book3s64/hash_pgtable.c b/arch/powerpc/mm/=
book3s64/hash_pgtable.c
> index ac2a24d15d2e..f7933c52cca9 100644
> --- a/arch/powerpc/mm/book3s64/hash_pgtable.c
> +++ b/arch/powerpc/mm/book3s64/hash_pgtable.c
> @@ -370,7 +370,7 @@ pmd_t hash__pmdp_huge_get_and_clear(struct mm_struc=
t *mm,
>  	return old_pmd;
>  }
>
> -int hash__has_transparent_hugepage(void)
> +int hash__arch_has_pmd_leaves(void)
>  {
>
>  	if (!mmu_has_feature(MMU_FTR_16M_PAGE))
> @@ -399,7 +399,7 @@ int hash__has_transparent_hugepage(void)
>
>  	return 1;
>  }
> -EXPORT_SYMBOL_GPL(hash__has_transparent_hugepage);
> +EXPORT_SYMBOL_GPL(hash__arch_has_pmd_leaves);
>
>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>
> diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pg=
table.h
> index 1c3c3be93be9..e638d914fbad 100644
> --- a/arch/s390/include/asm/pgtable.h
> +++ b/arch/s390/include/asm/pgtable.h
> @@ -1776,8 +1776,8 @@ static inline int pmd_trans_huge(pmd_t pmd)
>  	return pmd_leaf(pmd);
>  }
>
> -#define has_transparent_hugepage has_transparent_hugepage
> -static inline int has_transparent_hugepage(void)
> +#define arch_has_pmd_leaves arch_has_pmd_leaves
> +static inline int arch_has_pmd_leaves(void)
>  {
>  	return cpu_has_edat1() ? 1 : 0;
>  }
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgta=
ble.h
> index 1662c5a8f445..8fe95270b713 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -314,8 +314,8 @@ static inline int pud_trans_huge(pud_t pud)
>  }
>  #endif
>
> -#define has_transparent_hugepage has_transparent_hugepage
> -static inline int has_transparent_hugepage(void)
> +#define arch_has_pmd_leaves arch_has_pmd_leaves
> +static inline int arch_has_pmd_leaves(void)
>  {
>  	return boot_cpu_has(X86_FEATURE_PSE);
>  }
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index c4c5282f795c..4b52a3abeab5 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -2222,8 +2222,8 @@ static inline void __init init_arch_has_pmd_leave=
s(void) { }
>  #endif
>  #endif
>
> -#ifndef has_transparent_hugepage
> -#define has_transparent_hugepage() IS_BUILTIN(CONFIG_TRANSPARENT_HUGEP=
AGE)
> +#ifndef arch_has_pmd_leaves
> +#define arch_has_pmd_leaves() IS_BUILTIN(CONFIG_TRANSPARENT_HUGEPAGE)

Should this be
#define arch_has_pmd_leaves() 1
?

Since all has_transparent_hugepage() is converted
to IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && pgtable_has_pmd_leaves()
and pgtable_has_pmd_leaves() is basically arch_has_pmd_leaves().
The IS_ENABLED() is the same as IS_BUILTIN() here.

Before this patch, if an arch does not define has_transparent_hugepage,
has_transparent_hugepage() basically means the arch supports PMD leaves
and software controls the availability of THP. Now you rename it to
arch_has_pmd_leaves() and setting it to 1 reflects its actual semantics.


Best Regards,
Yan, Zi

