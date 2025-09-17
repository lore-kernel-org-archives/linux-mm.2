Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 147BBCAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 11:36:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 625C68E0010; Wed, 17 Sep 2025 07:36:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FDC78E0001; Wed, 17 Sep 2025 07:36:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5137A8E0010; Wed, 17 Sep 2025 07:36:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3FCE68E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 07:36:19 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0BE421DF04F
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:36:19 +0000 (UTC)
X-FDA: 83898538878.17.7359C8C
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012024.outbound.protection.outlook.com [40.107.200.24])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5B24312000C
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:36:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YnQT5vbD;
	spf=pass (imf29.hostedemail.com: domain of jgg@nvidia.com designates 40.107.200.24 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758108976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kmMq3uaGeTFcjhNe9C9WadZnSER/SE9hoTQ7LeMy2Q0=;
	b=cJgzwUaILOEidHOcPkQKcsnvPbXol1vVzolJppOq3RnshShOKOP2V8pzUBZ3JExC8wOqJc
	dr3aFtTMKTzst0C7zQGe+U0oqnauryFSfzo9nFR4I/LnIRZC6YlefhtLPDZC66+TtKgVQY
	uRWNWyYoFP1KWv2TqIcTEtxRHtVu4ek=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758108976; a=rsa-sha256;
	cv=pass;
	b=jwp+ExRKHMQql88cl9HO2e3ydjrYIHTX7hpvbRkndvhGLf7yQE15TQv7w2LDEQyEL3beXg
	FNN/77bSC9JomRlNazbVesXPc81h+VI728dJboqm93N0VsCPlTMdGHbN8ybivsj8/5yhg6
	nOGKvw/kQmQOV3mscNK3DGkVH1y20bc=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YnQT5vbD;
	spf=pass (imf29.hostedemail.com: domain of jgg@nvidia.com designates 40.107.200.24 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dM8A5nZAVTNRKohnhstBwCclnsrMi45fEdhstmZMA51D/PLjM2+QsZMVZ8gdjXLYe0DbNnSo5S7serwishzXbty9ZhBur2DxVoGRpp3S31Uurt+Cn2eN7zzQ2JWs1b/IXYLWM7/meaN61dHMhVArJm+N6o6xws8BEcbEhOjC5vqHXlZYmLzQFzvYGgcCIViBiFnKtyGrF8zTYATGIKZESVnX68qA215ttjMbqtxLuaKvkbPMoVOw64TaHU8aWq7f0JvpgErsMrGM+WttLqR8Auj2IXbNjKcotT9uoeVsnj5Vyvh9DInpw430QHhr73EmQmqxfrDNa5jw0+4u0d21aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kmMq3uaGeTFcjhNe9C9WadZnSER/SE9hoTQ7LeMy2Q0=;
 b=NrSC37to+WOt32oDSFfPvTCNPtluVgk/dCZTFHQ/ATCMyyzWan8OllipsDwFRhHgLBTkfslrRQ9mP+b+uLZzZNoCZV7szx9zRbM9u1BCxhmBkrvp3FORCMDXaQUbr4d5+BfZPISr9IO2xGnQuB8+I/8YQaFatp6XD/Woe8TUTDNAF3qfjhmA5d1j/NU51y4xvtC5VulnlVwaVGBv289y6XCHThy0At/wAPriIv2utne1FHyEnLKWW4lXiwWuFejleLAKVOpja/LGkLouPKBTLR8sjORzg+iDHuXTRDhkcT0X8iqCj/iEJCwjIkQNTaVlDASqKBpq4KwiWlNdsMYV/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kmMq3uaGeTFcjhNe9C9WadZnSER/SE9hoTQ7LeMy2Q0=;
 b=YnQT5vbD3sH1DR/3X3Ez2UCymbFWJhI86B5DAn+aGCko107WCFsPMlyuhUEAScnE3FfwbWVAwgm61XR2mQY9eGtdQ/m9Ms3YRMZd6dA/fcWm9vlUkG/HfIJnOxdEnbn50M7VkWa34P/yNQedale6cdHd2B3HHOiUNBSnsrdvMPAiuFrmh96Ai+wzf22bh6An/dQkBTI5Lp+pdV8tuBSP0fHTQuE1IDT7a88sLCgJhx68QMJ5K+EO487T2kuF4BtXYmAM5E111TFAJNIxmE9NnkX6amA26JVy8+CsnfgY3xFqdeD93h//7AYEkxxCwrP8Jg8I/vECaFyCD4xy/atdbA==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by LV9PR12MB9830.namprd12.prod.outlook.com (2603:10b6:408:2ec::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Wed, 17 Sep
 2025 11:36:11 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9115.022; Wed, 17 Sep 2025
 11:36:11 +0000
Date: Wed, 17 Sep 2025 08:36:09 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jason Miu <jasonmiu@google.com>
Cc: Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	Joel Granados <joel.granados@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Petr Mladek <pmladek@suse.com>,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
	Steven Chen <chenste@linux.microsoft.com>,
	Yan Zhao <yan.y.zhao@intel.com>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC v1 0/4] Make KHO Stateless
Message-ID: <20250917113609.GB1086830@nvidia.com>
References: <20250917025019.1585041-1-jasonmiu@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917025019.1585041-1-jasonmiu@google.com>
X-ClientProxiedBy: MN2PR05CA0035.namprd05.prod.outlook.com
 (2603:10b6:208:c0::48) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|LV9PR12MB9830:EE_
X-MS-Office365-Filtering-Correlation-Id: 71731e70-f007-4559-8484-08ddf5de66a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1Ewm66VGSIZXTG1Gj7Bq1dFqL4yGqxNUSXdWZKNvcNdqUY6Ep4tfFZa4eFGG?=
 =?us-ascii?Q?aWkytNRKaIwSVabCxokgAYcq4MogjwtjcO88rnFJ91S9rNQrCVid0cJUXHrJ?=
 =?us-ascii?Q?AcL2PhEZAoutT+LaEpvUrHIEKGU+NzzWnP56T7l3gceJGvYXrk5fps3cJeL0?=
 =?us-ascii?Q?IZYi/dVrQoryXpL/uffA9dC1549XoOf3gZUBr+it9OwDMXiXJr1pHHaMWNis?=
 =?us-ascii?Q?GalNanVJioHrxEAOe8mLAq+RoPARBmidM+Vs6M5MYRpGbF99BJTES2saYDAA?=
 =?us-ascii?Q?2jk2XFj3/LKDnBgrCFn7CIiviuk+N0bAMYSVP5seO/go2V6vA5nFMuLa8nPE?=
 =?us-ascii?Q?Ov0sX+KLOJdbblJw6nvLl5bi74ekOQNd6HqBstDKlVHUnJSiijIV/9FIIlV5?=
 =?us-ascii?Q?n20nkPEpRtnU78cc/LJFiky46Bix10NGt6RshbMX+09UXV7B78krKJWHjOhQ?=
 =?us-ascii?Q?fr3aLsuZM5ySuBrR/ILZSJ3RlcNjhj0DarwLgxPOJu3CUfsMoUTqpu/Dz/7s?=
 =?us-ascii?Q?jgN2znJEB3ihhHNOmId0pt/ekirCcN1Zp6nxGIAO5+GT6ilhn2aJ91lMO//S?=
 =?us-ascii?Q?RXqGGH9RGV0sj7tP4duU0NgEWEEparhcZWOqN1WH/R50emd7OmBnKpdGvhNC?=
 =?us-ascii?Q?OOXHUTfs07vQOTHUP94NCRD6Zzj9OVEZP6sqG42Qg7kHZz4PxbTSyRBbCIHu?=
 =?us-ascii?Q?dtVFgjWAG+K4KeUevd5ZSAWLGOxCUgZEliz0VPGkPXim7cweEgro/2MbGrg9?=
 =?us-ascii?Q?HAqHYKKm8JCweALzEJQ+Wle8sfkXMG76KnoOQD518Ownsb/orkyPsmD3rJ2y?=
 =?us-ascii?Q?Eu83iTcx4szHnsU/LfKBUAjrz8x3k5HbaekTTSIz92PFVVFhBcMgmEzBkaIO?=
 =?us-ascii?Q?spHQMvqm9Sp3bEBkR/KB2WtK/Ti/R/+2hNZtPUjRJuwViM/4pa0j9hJ2TIiI?=
 =?us-ascii?Q?TFjf1BDoDnK5PhjYVwPUNo/orbdZ2OuOW7vCP71hCKE/UIZXD8694cGyB7f+?=
 =?us-ascii?Q?lPvR6RFspdaHLBjddXTrc93ATAebtt5Xh2553qvpdkWv48AUoioXx2vyBjSS?=
 =?us-ascii?Q?D+79ntgSslbcc4UU1+1YZl6r8NxYlNhqsNbShgSLEeOUp4wk8Ht14HodrcVy?=
 =?us-ascii?Q?GA9GK5ZUS+gX3rN0bSGaFYkglF6EUJUgrYlHeDf3WjF0oaIlIBe/TniamuBm?=
 =?us-ascii?Q?wuPu68EioQWzQOEazbRfaBeRd00VMKWfoRbtAKsG18IcguBW48LfyTlOVwlv?=
 =?us-ascii?Q?rLifea2kboJnG4Rti2HJPSTz8duG/cSj46eNSMzM+o8J9S78bXc8tXq8FCS7?=
 =?us-ascii?Q?9/Gu9d7+qz9lrMMzsYXmPrU1ntAcIn6d8y+cl793wClnTgae81rU3APGLe/e?=
 =?us-ascii?Q?hBEwuOvWjYfO21+q4envAjFQPr2LJ3dSpKtBlbBRiFfC0ORtT0z5YKeuk7FP?=
 =?us-ascii?Q?Y4OLOvHcdp0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cspLpFxZb+k++cOlh0ruLSV3PqUusTmQteQ2QUcNTyOK4gxE5PYWCrwCbxTL?=
 =?us-ascii?Q?brvD5+UzTtgelv+dmSarnnRZH1PKrC8N2Pp+xt2jojXVO6NthqxgI8P9lhDr?=
 =?us-ascii?Q?5mB4jQaHsBpwPetGA7ga/N7EGirqy1bwHjbbU3NWw9a7qysbnwVMcByDdajR?=
 =?us-ascii?Q?iWwOqrBY2ts8TJxUpSHqfa21/P7USe16iRWF1MpK8sBbZUlwsrpvmXeo9a3o?=
 =?us-ascii?Q?rQMn4TP1vDxUxqKPn2IpgtKITgoboECRkJJrWd674Z1qzUfOuzyoicn+6MRR?=
 =?us-ascii?Q?ktpX9/nlo6/V4zqbK/JUVbPatgS615W1MznrZeUTUaEawtW03T/u67qOSpRv?=
 =?us-ascii?Q?4090/adgOXqU48pKvAuYSPDqGrpWsXBBrCgVvBrrWr57BJC+taUdD+zjAMu8?=
 =?us-ascii?Q?nvZtxuBhRZVTYcA8IjvkxkBzwhqz5mN8VXSlhOG0yKn5q7HTYvOc62sMY0cB?=
 =?us-ascii?Q?JmMmKnNbuBT97xJVOR2mDyuez89+modsWbumq1vA05RYDUUPlG8uqarWB1rP?=
 =?us-ascii?Q?tnGXtSua66xw5tDqP7Wi2uizTNGULM0BX+1ce0ru5N87zJqD9Y/SzGgpF/AO?=
 =?us-ascii?Q?1DO3t5OWTxgCoFww5QTKT7MiFxg7Bg1esTjvt8S3nwXpiAOmG7Pwjls5We8/?=
 =?us-ascii?Q?CpzjuVpDsoLttPSTSha0MjVtmuwUZUjAo5u3LPP7vTuZCOQzz/Fpfoi/anSV?=
 =?us-ascii?Q?DA1BW0k+TjT/xk9L5ZWygQbvPtFwMhJ1AEpwHqOppHCwRGQNio6+iC2PeEaI?=
 =?us-ascii?Q?udERoQD2GG9S2GjDSNTExo/gtgSYz7QP2DBv7PmKQrYblDG5Kw9wRJID0oKe?=
 =?us-ascii?Q?KSIUkYBi00SoMNDYrAlLOz2qycmLJfAlOozoJwbhcEgbVvuaT1TKcSm1Fwxj?=
 =?us-ascii?Q?XxqAFtyV3quX4lghO3YS2U+d8mnuG4s6GPFg7txBqX+eeLICVPMnJLSZP5R/?=
 =?us-ascii?Q?3xUOl1GBhbkzS7oNCowcC4v0qC2yHrtklWuGnqevbOYXYREgNGMFVqYvEPpT?=
 =?us-ascii?Q?uRssqq06k8wfiD0c73VnTmSW8RnZJ9F7qQDxqoLhEo3/50Ffw0svgUd9CE97?=
 =?us-ascii?Q?hR/UP0sUhp3eQfvyHaI7mNNcYWXWoCFeeB4evPJCyMAgla8sbDa61SyS5m2c?=
 =?us-ascii?Q?A+CujjLQXDfg6xMbsDI72/v3jSrdu8S20t86e6NyCyxCOIgHLXIsiWc0487k?=
 =?us-ascii?Q?3pN+x1D6Op/F2EkQ/EvaL8V+NuUfQPbTYUmcXIcJGlR3N2SMqoPvwTbJP7Zx?=
 =?us-ascii?Q?+H33Z8mK/fUMu81kmSYVvSxnjp0mSdw5LT+btqo9TPMB2IXA3CfCDpe2CbWe?=
 =?us-ascii?Q?iiwLgcxtVUqjGizqRkrjcEh5un2oVHP5bpoVK8TGYwu7iENJVHInWMivq5qG?=
 =?us-ascii?Q?JQSBb4056eKQECvowbMNBtU/WGSEeJXZhOqzycozdzf4aU2+G6rjsy4eeiD2?=
 =?us-ascii?Q?/tBgkTZWG52la5NFOiFuZxadDqpxcsqWDiaD1wAwu3DYaZBTWo8t3Lj2S9J1?=
 =?us-ascii?Q?H2rnUEpxG/AKQxUEqxl+yAEr6VUkJYLf4UL+Ff0yilYk25pK1Z7q5jze9G6V?=
 =?us-ascii?Q?Ghys8yYfKPMgt0rMo0sJFDkQjKfqRMXKc1QRGzmB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71731e70-f007-4559-8484-08ddf5de66a6
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 11:36:11.1534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PUF0av98E+vMW771nQhCJWaJ/PEwiFfM66j+1OfG6x7PtX/aJHBiYM6b7d+ed51R
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9830
X-Stat-Signature: fcrra5woxdd41bryib5zonr8sny3d5y8
X-Rspam-User: 
X-Rspamd-Queue-Id: 5B24312000C
X-Rspamd-Server: rspam10
X-HE-Tag: 1758108975-242430
X-HE-Meta: U2FsdGVkX1/gv2UAPWx25/s4a3CD9clSQ/bUmKi9iALDObosexqePOKT7feY/KRGks5RahLKS4N/9HdqbpU1haOBe4qmN5ul45v286wuAF9niBm05zTqySfi1nBBBoAhfA7JFQe9LP6GJs86bLzcFbGTtgB/LHTDRHZqnxQAd34HFzTiIg7jVXlVvuIrCfztAbfRIhuTJRuXfq+1owXO66gaY7VvtQz4cERW4FwV2zgQL9rv6EiEMe4P8k8I58JMmXb9liNG1wexBiveDvVmPNTvbm/WlQQiWuIEC9MHLPlGcrrwijfBnKXPaSfrXeFsFpgvq2xTHrczp4b13YGmp8Wgz1hO3fzW1ZVx9aPoSkFBjAF+UHqqV8oJ8D9L0GN4aV8xwTHQ+vsao94Wt1q/6So70OhxrGmhZCTpzbaDFzRN1ke2G7XAliRh1wi/BSqqgYTElgX/UT97sK5mvT89NlhTvCtVta7t1Pjq6b2Wr7WbLAa9pvlg32iEsvyOOsqVabKIMG4r3cZCJ2ZOLiOesLO28MlNUd8bjjR8FEbe57oluefLSvfdbgA+eG5ao5PVIGV7DzwxAwqZN0XLSZV+7ryGvQ9RPkc9Nm6BVtKDkKmaUJ6cFH7sK9mz4u0D/zr1yVgT3jep3oqOH3TCQxoInfW03GJtGM7idoHbVXOqmYx4SRTlNhs2jxw//P69ZEbONUdBuCAfFde60M0745YCkmogaUmiHL7yRAZvBFtsQzv3i0mP3Ii33bn7xLPzcdwhvnoSAljCRxwYwqH2l3Cdv4D0T34A4PnG8l3iQCCX8KwhF1w9eMAqsqu+xDJki58fuTplWnlTcZ+8ViXB7aA9+aBrRZEP7t0Uoxeh7ckzhdR0mWtZfRivDp/bZWpyTI3eQx9SBhbTsRCjACdzLntzVWvnDHCKvnKVtbjzS/1JpVgEVPJ1Ugvdhdes71Tg+w1TAJGRW05kjjwx8kBWwQB
 8eQ3A4jW
 nnDSxOtkVAdh1wsRSgsUmb4WHTysVq4YKXKERR0mwBIzZEB/WDfFAAtQVTtqQQKugAXeR1qV33sYdcyNsu8cQfskHJsJoclLftZef9moHwT5ZPG5wecFRRZPQfmQGgC2ZaVd1WnlWqVL37Iu2jmHTkylLKRZ3eEZOQYXzZIM4Ir1vNG7iioNylt5z8xEWGmLEVkChRZfUcV+Zr5bOykgCCfUgfbcvY30gE4rfz44rXlNO1SpiXVR+Usc3FgvsN2WEfGct1WvCaqka1/h/Jx7j4avLWy0DDl1yNz6aVe3txmyOeMaMbUhcUVRQHYS+HEtWoVyMfyreEFW/a+E4+kNT+jwfc8Kpzke/K6wFMa2q1Iaf1TkU+d1+axYLMJW5Uw3nmuGphRm0jMLV0p44cucs9MjxgqpQ6n0/9xcJrfxoduJeajma1BTRZ3T1KPdyjbOuGT01qhpubQI8/PggZ1BdE+ckZkC7dfTcX1Vzma90n05RGkJ/qOEfhLAauQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 07:50:15PM -0700, Jason Miu wrote:
> This series transitions KHO from an xarray-based metadata tracking
> system with serialization to using page table like data structures
> that can be passed directly to the next kernel.
> 
> The key motivations for this change are to:
> - Eliminate the need for data serialization before kexec.
> - Remove the former KHO state machine by deprecating the finalize
>   and abort states.
> - Pass preservation metadata more directly to the next kernel via the FDT.
> 
> The new approach uses a per-order page table structure (kho_order_table,
> kho_page_table, kho_bitmap_table) to mark preserved pages. The physical
> address of the root `kho_order_table` is passed in the FDT, allowing the
> next kernel to reconstruct the preserved memory map.

It is not a "page table" structure, it is just a radix tree with bits
as the leaf.

Jason

