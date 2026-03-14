Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1499610854B4
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 23:44:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3C356B0088; Sat, 14 Mar 2026 19:44:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF3596B0089; Sat, 14 Mar 2026 19:44:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF61D6B008A; Sat, 14 Mar 2026 19:44:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CCCA36B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 19:44:50 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 413F01B88D2
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 23:44:50 +0000 (UTC)
X-FDA: 84546301140.07.C8EA9EC
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013009.outbound.protection.outlook.com [40.107.201.9])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7312E40007
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 23:44:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="BlYpAwt/";
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773531887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H6BuB3w+ovf+vDROs4t8eST7HXshAVOuWGfMrKpXapo=;
	b=ykMfT+i7MlL2HkI6TAypgYfj5NLYQT5aurnVVtDSqeXwpxHU1onPvtynkOu5MsZZpvCzRp
	mTWAlFw1v9VWGn6GrrwJcBttqg19BsyYmRwpHevvHcTCTGeLyYLSxCe+V6sSZfJwpJC7HZ
	xkUvQwonw8yTMrz8WyuWWAOg/c5J9TY=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="BlYpAwt/";
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773531887; a=rsa-sha256;
	cv=pass;
	b=1rpboqHh1JA/bf9tYVJISY0xW0+avlOi4Zelj8zNQ61ConyrVEV4af/XfmEgpYpGF2NEnK
	tp+C2z2aVyyPlPb+qFLWBDxL8OFI7YW6WSyFvA4mG1564RVrdC6i5ZmSPYPp1hloBb4SU7
	wsTvPPGuuUzovBW2QwLPCiA7BiEKwWY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fHHrHh3rMEYG81BDjTuAYficdNA5Jt0te1eUm6OgoTR+lUrm+Gng5OH4VVyosOj/xhlgJBfl2CrADbPTYZA/5GoGVAfDh2uNVh6wnpXrbbwYis9cQ3DN7TJxvSarvPwNtlC0u1rJXnLfljfLANznG7mHP5E6eicSJ1CInFtTs6krV+pOpqWymp2WxcTvRtN1eNEW96NpDvxJAW6UpbIgnimZ5+zNHTQQ3Or4gW8Iv9uZsLKmBH5Nl23vK8gar6GyBSM3m7MjAv9egz3NJNXDIdhr36tJzDHGyiIKG5k4ekJufe3ybJ/G2y3pw5Ua0bFFJ4nM+TM/ZTTT6efW+12DDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H6BuB3w+ovf+vDROs4t8eST7HXshAVOuWGfMrKpXapo=;
 b=V1Z+DA1BU5Q4VV2gkqM1fGVT1jsqLLbq6YvFyMQXIQc2W2+MFRI9R8s2v3wb7qMnCSFzP103B6cQE9gtWBiSxwzDJxIZzT/h1a5qa/b/WDsFfkjMCzqPxKZY1o/sFZXzvD1yMWmKuCBwFtU+eftESq+tx0NNvw96ZrMOPBTdfp+UtZ6fooSl+qF8ENpFq4w6aaF3ziHfYYO8b6DFR2479Q+hKNogFB2LV2HirRKkpprytg9hrA8UphuQzb4skDEqCJmBj4o05Fs9pHMw0po9hrdHqih5+tXlkCnkI2gl2GqFRU/ZGIELRX5Z3Pc5hkm7gkEi/GTdlk853MAt2SrW7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H6BuB3w+ovf+vDROs4t8eST7HXshAVOuWGfMrKpXapo=;
 b=BlYpAwt/I7+Tm5T5XhuOyg1MN1nmCKvzjI8q0bk6TWERM+ke4tjR3fgvAY2J5tIQx9OMytv6jWpzg9JI8Djz50OuNhaMcYdMEf6mSKywlDQ55B686qWGB5Iih5Ot7zjJSP8m592CMET5srf3/wUOFlfeGhI0/X3fRw5BTRl4JgNi8MbT0wVY4NU5bGGCNcq07/YcuEaDBCiX/G1n3W+8CyUgoopOtsqvbjCMRmcr+oKxpub+/CgrQc9sYChokEbg/QSNg8b4N9aXdbhaGQ9bs6NN4G4qP/4+BHp9hqv6X2ySx0mGqEJ2EWichTqUcDepZNvR+CxQnLKOXw9U9+Gxig==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV8PR12MB9230.namprd12.prod.outlook.com (2603:10b6:408:186::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.13; Sat, 14 Mar 2026 23:44:43 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9723.013; Sat, 14 Mar 2026
 23:44:42 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Matthew Wilcox <willy@infradead.org>, Bas van Dijk <bas@dfinity.org>,
 Eero Kelly <eero.kelly@dfinity.org>,
 Andrew Battat <andrew.battat@dfinity.org>,
 Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: add folio_split() and filemap_get_entry()
 race test
Date: Sat, 14 Mar 2026 19:44:40 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <533AA5F8-1EF0-41E5-9BFF-ED7A2C423642@nvidia.com>
In-Reply-To: <20260314152751.101b5d04d3753f75027b9cd6@linux-foundation.org>
References: <20260313114037.3593642-1-ziy@nvidia.com>
 <20260314152751.101b5d04d3753f75027b9cd6@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR14CA0022.namprd14.prod.outlook.com
 (2603:10b6:208:23e::27) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV8PR12MB9230:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d9be77e-8a42-43ad-b043-08de8223aa57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|83080400003|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Cubjyw1laNiiGQ9UMYrk2DGqlHcZ4+344FDcSrjtsWgk1xy+QkvwIU/ZyaePtu0Lcd6kSrsIDH2zpTQ+FlAmLJuwsElrawwpNYVC4z07ffVWis6A11HmMj0PogZrREUnHfjEnb06EUVUbtitrwJYQjtzqmi/SH1msAFYmfnbFaNkZkxya1AH4fbYojNi7DkDPTPNUHSbFYvF3vO6Rl9Iy8haEOVTPHUsQTew/cR6Y3D74xQa+woBeTX9homr8TGg7ou2Ey1LQUB2wLK4kqMO4/b1qAWuB3vtnTzOD4ojaQow+3WgX06/daiFqMzHQuAEmAiTQeCBq1h07dG0o/7T+Hui/aPy8mVm5HHaUtj8xhQvbj/swKaLPubOYdlcpEEkXOBTcUS8yCcuSVOIIj5DRmseUNxaUmX5TGWX0nq+0X9sjBdn0MasG5lWwdG1vUwTc6q5vjlfzl/E2d6bahEXoddSPYjPRDxlQE5ZZu5RZ2ULysjN/lIsrLpoRy49bgEN9BOW6bTQuVcGd6GjbdGPOoWYMvV1C/DLj2m5vWFNJqSeWWKq+pr4jlMGNzWYmdWUa34KOQqirA8oWAkt2tiKHv0AV2uOb4QloB2m9D/RYRQLfojwu9NgW6zPMQrgEOPloFaKM+7yAcNbFiDfqN4PcjKPWTzjI409KP4NlZYvtgTJzDwh474ELt7U0C5Vq4vPB6dNX2JvwpCmRqkZkXEewtC4YAoOZWqy6dOFKipbfpjIX46SRph8w4nqTeFmjysmU9FuuMcOxeQrHHZriWItX5Xbv9g544NPjnGNBJ/iBxo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(83080400003)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VqGyAO8iByjL5hgUoB7f+WZ5sqFyWSVeA+F/y6IfjbQuVx75ddHt645u/T2/?=
 =?us-ascii?Q?F10s3ilzsDiJk1lnGX+n9dibtiXcnRYCtyW8KIoLlo7wwWW2tBrwKK5t54kl?=
 =?us-ascii?Q?U/cjux/m01j53WUGCLTWjfjTA7x3gfrc7afz/yutHZRIX3Deh+IxW7nF14aD?=
 =?us-ascii?Q?zfV0ZujozZiWyrSPGyHQooKrh1scgxEIoTVbidOWlfcRNo9LvDgtyfTOFo7+?=
 =?us-ascii?Q?OVgGiRdXfb2ekqbasVkgs0/26aTUAvFXL+HmWsftL/ZUR6EGmY8/lnCLEO3I?=
 =?us-ascii?Q?R2GxwORKqxAP7M3h0/5/vv3sSoSIIOUUpiV26OFA+oyK1Yes/VDGIVWlIui/?=
 =?us-ascii?Q?6nMjZpWR8ONcViAyspobjyl37is4n3cU42pwEoiOSkXrf2IZwspbomV16uJu?=
 =?us-ascii?Q?tqj5cTZpjBpoh4p2edl+aIVPOXTBxKx2l+ahtVBtV+pMd1WuGxovgB0yKvzQ?=
 =?us-ascii?Q?zWciwt+l9lbvMU3pu6H2Zex+7WThGGxsnn44Js8m611XkSARnZrWsxIrMTkZ?=
 =?us-ascii?Q?tg3rQwsk6jgTWfIEuVf+5g3UXkpdJO8g6dKmXPNTqfaG4JMw8Di5m/enEyT5?=
 =?us-ascii?Q?IVWCyMDwldtVStyeql7dQOfDXC07Ea1G0P+TyY4bLUgsuqLAWJfk4KXb4OG1?=
 =?us-ascii?Q?2nw3rCUDkVLPPqa8ZP0GD9BCtjDLsZH6ZZUbJBNKQ40SqPoVb5dbTAJ+9NsF?=
 =?us-ascii?Q?TiobsmIgiCI+0GqrWFErmotBYrFhsN3ko5dVKgKvOWJ6iUt2DBbORhTHyhBy?=
 =?us-ascii?Q?cvEUgoBsLJtjq5ScnEbnYONuUniIfCnkPqeA8T+SUSTSx+mVZ3AaNOTx2UbP?=
 =?us-ascii?Q?eK/t/KMMQSj0qprnTaH1ldLXKF6VNVo34D8CT/Nir9k6d9/urSSO6NdP4Ktu?=
 =?us-ascii?Q?xLvRmYpWl2JMJrJdi1/Ltw5lRpPAheTzYy0CMD6ZThdtIrJCmiePbiovZ0AL?=
 =?us-ascii?Q?AMXdyZajNuL9yB/WfZGbvJWrOP1edWNmqosfcVRB7vHnh3VdDxeSPtoYPjte?=
 =?us-ascii?Q?JWLmXVnLq+xn33K0FFzo3Ny8PZPcDbyk+xMEbUjijbZLSGqgoSyDaT4Jhcdq?=
 =?us-ascii?Q?C+DU+yzohR5NcBvczBjJaI4tskz5bdgDfftx4jauPdgzcp0Hz1rNGPrbZQ+M?=
 =?us-ascii?Q?u3niuAz1DFgU2sCZBSIwxmTSEJUSSITQIkPNnX10jsZvciTJaSXTzyLaIXoE?=
 =?us-ascii?Q?VcozYJGQEVT4UsDMbHEl28ILMWECb59yWsJ2hbay8ijfj2k+yu1l1Ou4mvyP?=
 =?us-ascii?Q?i563KBeF+3BaA6dLW1PIPCMjIIYzPhJWrAi78IOZj9M2/UalTR3gB1Tah99t?=
 =?us-ascii?Q?UkLzV+bEcV1byiBa2Ia4duP9YEG7j21fGQDMmsbVmGeBwUgKFDWMKxydAEmN?=
 =?us-ascii?Q?ZQtVjHir4AtntmWejzhYm73uTWy/JUSKW1WBvIA+bsxe5x9fP6a5T8bE5nqX?=
 =?us-ascii?Q?a4uvZPIk1CHRdMqwlh9dUizUiIDRaXrpWf5wHdN5AuVpiS+bWVoP2uB0t0i4?=
 =?us-ascii?Q?Q8qnhUDMFipB5ZgY28Pmm9j2aRdJ9NrjR2pCyw2pVNfuJLRxNPHN23eNmwqW?=
 =?us-ascii?Q?he1UDBYO8nrb8HmXUlIuCmLlgd6YC1LoLMLuru+jWtMvHE6+DelGzcuDti/X?=
 =?us-ascii?Q?ZTt0/IbfQoXrjM4RMKNzpjG8imVZW26wgKCKsNTCaFGY/qi8sFB1Twb+fIem?=
 =?us-ascii?Q?kTzRtX0ad2gs+ZTVaiuW83m1tKdoF+eNhWdLS6GrCe4zBuoK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d9be77e-8a42-43ad-b043-08de8223aa57
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2026 23:44:42.7835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VfOB+TR7llM8D+jQ4m41lusw5RJMN+2Q9hi2+o2yZh6Phuv2OC34wmNrhgtMDqfT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9230
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7312E40007
X-Stat-Signature: r4ibrdjrjo4gmt4y9mpz4xbq1qxe4ndt
X-Rspam-User: 
X-HE-Tag: 1773531887-381177
X-HE-Meta: U2FsdGVkX1/5Iq7vvZiL9GSh45bTziKiSfKP28+COX7Ze2a+kioRT9oZjAPUnCMG3/9rs6siN+iq4OLwPRwkSJNTVLWAjcISqexDr6yFtv3TiHAzRyFxsg2ABPQOUmuDLfAAp12CNrTPv2QIKKo+OcV5QWVP6Q1lKZDrRnQmHHtoPzpJ2h65NT4n1KeeReIga7UVgUSVGLzYMsFwTlqKPujrLIf3O4Kayo6vXs31NDT/1lBv8G7EchOuawkRW6+E/d+5JNCnGYAJYDQC19J6SSchzDPHpiDlIX2clpJB3jpIwut046jGLstTi6tElEY6/hFrFzzWD6rcO7AYrvLpF4WhjOArXaVPGTmQyEcXxxtc22BZczaLYR1UzeGfwaAMSHfaTRzmEYRy0ypgz/C9yabLWcjSgvO7bwqGDMhnGcpwKMc1UFmsg4DwzF3cUvm70fOAJHCrO80xzV6ADzFkBaOj4nUDf71Ojx59nexLkCLE3DI3kwhG0NeTxr3tfjqUSRfpfwAWqA7MC7MIvJSe2woRolayFgdaWv4MpM7XUifP+PxsC/1sDG7ARZthzSaHAjTD9gVI/UHxLu87CcnJg9VtzOt+/J021ahf3O259V2UaWF/W3dKMpx9/tB3Z+Vk29Wkcf+G5mpuk8uW9CkmF7exhpck/dmzJp4oS8FEIkZjgDnP39EDPnhBbAsBp9kgga/iFY0uMjkgqbvpbHWsW9blsfNgoWFRfy0zZZWXQW826d1bVCgxtkGpELrCqJwEYCGwFtfwNlJ9GP2pQZtzx/ELFNK+n7AThePhxAJNdz7MzWyqinDMIQm79xb7Kd6pxd9jbl2ohJJYe3+7GPtU8h9r3f7lG4Ct93rmtf3OGQhLYhK9+YRVt+G+neSwkaPGDrC/iVYQgdz8nNg00VzkVvzWLBS+Dt1flAKJmS8aQkFjJgNG3cCMEiMwtgAgduuAt8cPyfNBZf0Tmv9IaZe
 Zjb9MAM/
 QJ8gsQZ5TmWcDYjpYLs4S5DhFxPp8EJV1X8h+9lFbGWYbVqgQ634RAFJUnVQQd1ro/cs6CT9ArdZwHemFO0eo3j7/paAoy94yEZtU8CB2VE86B7sS6yA+Or/btdU8CdZ7943gGDYPxW4fjUIieY5+LAySNmfEnULlCie8DJdwlGqWW/VWEMVBGvgO8KPDZQ4BDgpqEnt4+SpIZTDA7UFIKFykZYjQuK4DP6r2qjgcFRU2OzPwimh8vIcUW4Qp/2qmDMITnzFiP+Z1G5IxGPfpUONPICiCqCi1RZ+1fJKGQ+zv+WaKQaSr2V/BFUhg/+qAZPMJMG+I4SkcNL+PZ86L1CxN/cRi3qIAb7LQ1r5NHS3Xt0rsShryaRIkd0gUWZ/gyNIFIZblwcpCDGE/BnyVlucu54ZTmdDPfJLoKj+LOYGzqPoVmpI6bjFzjLJ8W/QemmZKDtkO/Mwd84tfVnzWeauxctLCu989CYCKXbJCugd6RR95EtpoF9kFg4HmEc3Is5Gs32M5FvCiLgk86W948ukX7pozFIaWgap/x0sTL8Va4DKKBAOBV9Uc6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14 Mar 2026, at 18:27, Andrew Morton wrote:

> On Fri, 13 Mar 2026 07:40:37 -0400 Zi Yan <ziy@nvidia.com> wrote:
>
>> The added folio_split_race_test is a modified C port of the race condi=
tion
>> test from [1]. The test creates shmem huge pages shared by both a pare=
nt
>> and a child processes, where the parent process punches holes in the s=
hmem
>> to cause folio_split() in the kernel and the child process reads the s=
hmem
>> in 16 threads to cause filemap_get_entry() in the kernel.
>> filemap_get_entry() reads the folio and xarray split by folio_split()
>> locklessly. The original test[2] is written in rust and uses memfd (sh=
mem
>> backed). This C port uses shmem directly.
>
> Cool.
>
>> Note: the initial rust to C conversion is done by Cursor.
>
> Hence the CaMeLcAsE "struct SharedCtl".  Fair enough.

Will change it to struct shared_ctl.

I also got some AI feedback[1] on this test program and will fix them
in a new version. I will send the new one late next week, so that I can
get feedback from human. :)

I will post the AI feedback inline in a separate email.


[1] https://sashiko.dev/#/patchset/20260313114037.3593642-1-ziy%40nvidia.=
com

>
>> Link: https://lore.kernel.org/all/CAKNNEtw5_kZomhkugedKMPOG-sxs5Q5OLum=
WJdiWXv+C9Yct0w@mail.gmail.com/ [1]
>> Link: https://github.com/dfinity/thp-madv-remove-test [2]
>
> I couldn't immediately find any licensing info there.  Bas and Adam,
> please advise?  And sending your Signed-off-by's would be appropriate.
>
> Thanks.


--
Best Regards,
Yan, Zi

