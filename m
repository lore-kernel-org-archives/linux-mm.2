Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 178E2CCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 15:19:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 712DE8E0009; Thu, 23 Oct 2025 11:19:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EA8B8E0002; Thu, 23 Oct 2025 11:19:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D9C28E0009; Thu, 23 Oct 2025 11:19:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4BEB58E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:19:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D4BBABB10F
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 15:19:19 +0000 (UTC)
X-FDA: 84029737638.16.D8B7685
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7A61318000A
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 15:19:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hcyC2PgE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IYpha8HK;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761232756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=89+XgsTFpOq1pRGIArynkgXUGW54jQ+sLlTYfopzO3w=;
	b=6K6hXCtvYDF3biR2mZGosiYIyi+FerxEtuoMfoJxUoJC+K+PAkwcf0OqDik09gTwKo9SHU
	jRNyNWq9YmqznttXJ25ujRduZWJ1fXGHsDu5YraFwRR/k6EXZzvOV2U1HNqWtpRm3GXaNc
	FZIZ+8nn5Euo5qFVbFjxgTYiNDmZcmM=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hcyC2PgE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IYpha8HK;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761232756; a=rsa-sha256;
	cv=pass;
	b=akueFFgnN+FJbKNM6JuDO0Mv8DqZzscy/4oGQtuXc7Hl1UHa7RpX9dNEWrOup6ylc6l74g
	wTIGyAimwUA+rEwbdgqyxHJiwOVYzAKECLnzmkdIXTbIaxaMcPsFkH8DGCBWR4B0lQOKV4
	sKdd5VPe69W6tvePb1qTGlCMLx4jT50=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59NBRGcs019578;
	Thu, 23 Oct 2025 15:19:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=89+XgsTFpOq1pRGIAr
	ynkgXUGW54jQ+sLlTYfopzO3w=; b=hcyC2PgEmPG1QZDnQz4dszuF7r39MTaVQx
	HPYqki5rAL2nkqiCHy0gz9zVbVLrCuAImrkH12XL3oSdiWTW6ZWzhi5XmnhVl0sJ
	N2BJol6dQhu8wqQBN3PLqiuW3k7bLt4WpuyD6GKSGKpiNZBSrIWXovAMmYpJa/YJ
	cz8sPUQYsz3z6kmXYReKyfJ+4mhHIk+kDN9WZSCzIFAJowlqaUVDrcjmMTVlyxX7
	LbypWyqnJnwBLw6h1FfkskbxRVwcYJPwoxW5CmshblgeyOEzBhRIjNVu/5Rg7tmD
	k3leK2Nx/tlyPPC//CF1/H/pTZMlXy0IFrK4YMJtKaJ9niGSUq/g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49xv3k2ru0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Oct 2025 15:19:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59NEODQT000849;
	Thu, 23 Oct 2025 15:19:09 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012019.outbound.protection.outlook.com [40.107.209.19])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bep3mr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Oct 2025 15:19:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d54Mn58VaHlN3AHsZtJzcPyWRlrzVtJh4yxDabRgS0U4t5qmDkCLgYy6q0++CgMaHBgc1z2oWpenh2T0rdGx9IdCj6HyvduCTB6/BVe8rhGZ6WHjJi/C7IsLHb6z7iT5zWRBiNhYlcD6hnu+d8mdVLJzE/UuDeW4HKskHqluV0ZnJCzeI0GAHyzkicbi/QK8q0ugbLXwjZYwtyl5Mq9tgLNqa/NOhhgeT65G+ghbJxX4BgIqx5xeauOSkYtFi6CzSY72FUhA3qDoweVL8JYhjv2v/PiSAPRcQL3GaP36R5WG1V2KV5eHWbKadVayzYxpNHiVXZfqU8xylMoWshBALg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=89+XgsTFpOq1pRGIArynkgXUGW54jQ+sLlTYfopzO3w=;
 b=PxrD4OouxHgM8kon0DvpJyrtyFsNY3X9sQGG97EbYo9O0xb1WmSX/DzMnrvgAzeOH5HFk8fva4pNU1Q425r+G0K/j5adBLN/PYvKVUvHWvAjs+7OZlHu2MsFweawviRyGW4LNYiZZCjFZs3aQ4CMffXVmgQsOjY4fTqOM9DK8mMSwos2h7poc873rOQlHOw8o1AZYj000Sj//Qj8Kt9KN23SIZRhF0wvYnCltEpj/zcEL4azrnLlcSGpHo/vdOQ8FWqTklob+4DU9Fh5QQBRwicLhSjzs+m26L5TEXllfH6eXeN7gpFqidFBiH0/ogECqhU514ixWHblCexrWBYlPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=89+XgsTFpOq1pRGIArynkgXUGW54jQ+sLlTYfopzO3w=;
 b=IYpha8HKwdAyZH9h45nBXilrBs1la7iXlOHAroK3xVV6NCyJ34z8Mxj4pedXHbLHGQuyHMqwqIpCbEJ1odpl/fLoyRHAHzRAhim4fIYkfecDHX4eABX/DrWkY9A3WZtmhxHmLx3K7aiZRF/IcTUA6MCdMEY4ucTid2GQOTJMaFI=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV3PR10MB8132.namprd10.prod.outlook.com (2603:10b6:408:291::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Thu, 23 Oct
 2025 15:19:07 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.011; Thu, 23 Oct 2025
 15:19:07 +0000
Date: Thu, 23 Oct 2025 16:19:04 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Julia Lawall <julia.lawall@inria.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: fs/proc/base.c:3279:4-39: opportunity for
 str_yes_no(mm_flags_test ( MMF_VM_MERGE_ANY , mm )) (fwd)
Message-ID: <2c8494de-2e5f-443e-94aa-14b166941199@lucifer.local>
References: <a6e8f771-3934-61fa-ee3c-585dc6531da@inria.fr>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6e8f771-3934-61fa-ee3c-585dc6531da@inria.fr>
X-ClientProxiedBy: LO0P123CA0011.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:354::15) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV3PR10MB8132:EE_
X-MS-Office365-Filtering-Correlation-Id: 677724e6-2c3d-4abe-007a-08de12478233
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NjHH54hxJPKBvCcopbTeGb80Yx1TeouYKnda/PsfQNBkLclGTYXTtQSrQQaJ?=
 =?us-ascii?Q?o7yRjLgOdFLfWtlIRLhKUi+q2qhDwNqq2O3VGe4v4urEJ1ak6CGSgqxFeljz?=
 =?us-ascii?Q?l/GR8xUJWx61IKxaobmK1SDKhQpeTMZdTmNX7qE4SHW0zAxdUKY6BAksZtcP?=
 =?us-ascii?Q?Q2CDqfHfROTcyUmWotCNK0eEQBhyaadgi4ZO4kwfXaPODmj9d7iS3zo9yUPW?=
 =?us-ascii?Q?X8K7Lh3fzjLLx/DlHhUuA23hBhwcxof9b63tVsdRf7zLCsJ3Fu78UYMZw8Yi?=
 =?us-ascii?Q?92bYxlyX6vmgyAM/rpD5JShsajNY+paCha3bSHBhbNiyPEwuT0dnrwFGIzJc?=
 =?us-ascii?Q?iVfoUQg81WnbJbkGzHYDVLXJ5gumUmmo17HCuNO3Apj1iYIHJ99o0wExtsKq?=
 =?us-ascii?Q?Q0nip15zW8aDSFJxdU7+Hfsis+yQe6DQRMagN1nSrcmRzvEQF9jm0hDhCyJt?=
 =?us-ascii?Q?wG9H+BUBJMWpJwQtsek/pFThHE95VGx9xrX6EGTRDX798ADQzDOVYGEC5RI5?=
 =?us-ascii?Q?UzxAthWzEGjHA3nK3XsqXspTt05VxOLHuN2gtgW3E0U6iCNC+ZbsyQtmvxPn?=
 =?us-ascii?Q?cwb8rDMXdi+bwkahOHUCew3zcpDnyBw953FTlDXtZJFYeMxuoGSF7CUremLE?=
 =?us-ascii?Q?0LygNZJLw45CbKxZbgw2Se1iz0iXYFEKVmMRD0qU0/B5d4CzHeWHOOcDXmjw?=
 =?us-ascii?Q?lQG94HWEjB92jNYt+jCokj7CXK9+X7HmUlAelc/FEaUpMuiwcgsZ2d+4vBZt?=
 =?us-ascii?Q?Nc0ViXBtbJSJZmrDgjZ6+XHv+pjbzk2sb14cBmyW1UuMmzv0Cl7cy0MXJLHR?=
 =?us-ascii?Q?YrbWPDxMV5S77CaKLvYxeTmWaz7EAoE67QR1eDk+4gJvXjGVQj3mp2BSfjlw?=
 =?us-ascii?Q?fCsKDSo7xdVi0CRDyfbBWlDkQSxrNvkS1dcQ6Gn7MI750fqInrxNCsGZjHiz?=
 =?us-ascii?Q?d81P4NTUsT7R9T02yC5XqR6VwrSIYdGZTMtTCz3hPCf24kpH4S+4j6F4Zx1M?=
 =?us-ascii?Q?Nw2M2VlYmR4KTYNNtgaGXRPNBNcHxppmjuk5CM3PnSVV74SceDiB8qo1y18V?=
 =?us-ascii?Q?oUyUlBWI/0EhtyQOIYXMVdEyIYsrnW2xPND022E5+A27KitXP48Ui4A0VggT?=
 =?us-ascii?Q?lYrl/4l1R8Zf+mwT0Er2UJhQ21alc3ra9LA/Qx1DmrPmRfqWncFmwnfzssbe?=
 =?us-ascii?Q?oUN/9UhkDsAwFgLZtnSmb+OEOy+flbccR3yEaMaMmct0vxipnGs1mi7ekcqk?=
 =?us-ascii?Q?RQQ0/QMqvTpWU1B8J1B5d1JqugcRCdEMHUSSKjBsLgnzYon1NzH1sQ/5E6Tr?=
 =?us-ascii?Q?tOatm1F++kTrE9SDAVn38xK10ZbKYIr9cfgS1JRmzX+PmqQcASaorSTdqxpb?=
 =?us-ascii?Q?iV8Ns6XwfHr8R+/qnX4sAstEWJLxyzr9ty+IWNBwluNicwT8IDVW6/Y9sE0x?=
 =?us-ascii?Q?fYIM7EJlYhoomm6wju6DcAoMaPsdM+54/S51fBbDptTk3H0RcTExZA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XakAXwfFuuLd9vN+BBRnMluvhsTQ0VNtdUyiXt5tr2ikIaTnyrB3oDCtyBQj?=
 =?us-ascii?Q?WVLZgzf6p3Jy/TMe4dssArdCrDE5xXHbapz1OT9IRnKUclPbjId182fdmV+4?=
 =?us-ascii?Q?QyinpwjaNszZwfMRNs+qzfhCuUAPLaY6bCnxrNG16cmkoxSe0sAFtGV/R5aQ?=
 =?us-ascii?Q?hrzeaocwJkiE9BjIKDIyseC2NPn3w7oW4p3Zvx/nY7cZSM56OIV75ZhHhRNs?=
 =?us-ascii?Q?u0n0GUPFirAZ9caMyoX/cTdxhKFxz34xF3uwWKHuKVra9ijA3lKQBgZUy6Kp?=
 =?us-ascii?Q?K7j7r6/liowHKiAvXge72lb8bHa5PM04ATWG4IF1kFU8J1IOk4pkrBepibKy?=
 =?us-ascii?Q?Vpxg6ACms0T0NcRIYPmE9aLrgpR4S6m4o1Z8zm/1d60emwGukalH69W2qJ5t?=
 =?us-ascii?Q?gUtYD+hUR5RKpdPblNeu6LJXlJuZHjT0ew8UAry8Zc8HXyBNrV1H3FPG4679?=
 =?us-ascii?Q?1mmIw7XQfLei7UTn3tSJifbGYg04Ri7yZfrO9TwDZItzVQGIca0tkkQix5Jo?=
 =?us-ascii?Q?V6wyNVs680ynAVzAUOa5kHtm/SgzA6GQMR64q2jLiy9n08oCL16c2yPuZeGh?=
 =?us-ascii?Q?jSBtrcUdqZwh+5Muqtj4/YphS4WZGdAuxQ4UVzDRCmuMgfRvRta98hbw0xj0?=
 =?us-ascii?Q?4vUWGAThWlZYtdmopz8oZ0ZEia3nDJkjeZnfrCbLEhFAPBCQPfMe209OYYCY?=
 =?us-ascii?Q?xDW7dy1QPVVR+3Q+JvSubykwFi8tvUN8gA0WAKY3Hag+z/OEkA7v7xwJ5gJh?=
 =?us-ascii?Q?JQxXiAda8C7i5jnkSOHw4VoNmsJX3WLMUqHqO2hk1pp+ieo6UB618f5jk79c?=
 =?us-ascii?Q?0Of3iBRhr7cGxvHu1Yoj3wg+Fif68PinfmpsazJsxdhMYJHCOStVkvkqjDR0?=
 =?us-ascii?Q?dqq/5Dlv7ERL/wO/+TCjFMzOJ6QcQwVEqyXSxAYhanrfq0TWItWWH2BV9Bz/?=
 =?us-ascii?Q?mk7g27ccGkGrez9TZ3cqMdI4oILysrNCJNkExnMXBwuVVHfQ2oFO/Temdoiw?=
 =?us-ascii?Q?ggKucOWJJqdxxTQUiE10T7G+7JEGulnvzhcCDMNNe/zCJ5grFqjzF9SSd5w9?=
 =?us-ascii?Q?fEl1k9tF7eHM8Y0pupkz4fBZG94tNXzj6iOTi8KC1yscU89Hql55q+41F+24?=
 =?us-ascii?Q?44z5fHrEa7zYdIuFJ/aK+gZp+4BQzmTO4IkBaYc5vkKJTut1DzzB6nH67TOa?=
 =?us-ascii?Q?0JtHutE01dTzJHFZGiFPqg1mEqRcIsFz6/6Nm4BL+MHSQ5pTJ2V3Bt6yBhyT?=
 =?us-ascii?Q?Kfj65/Yv27BNr7bRze71toL4jwI8J3qOsjh166cH0DnnB6dQ/u0xkivM4bXt?=
 =?us-ascii?Q?uR7NdlTeNC97Wyn3ZrFxcOXZbUhWYBoyOQ7FxMBsu62huP/l/Mz2CXmimysX?=
 =?us-ascii?Q?fsz9I6ysEvlmi8nbj2nSOBz+D3ZZfAV8Uc+G4x9JPyw33yor1+YSgmmkS3tv?=
 =?us-ascii?Q?xezZ8R7o/JglKh7sLm/+ydd2gkjQuWDFH2NacIw7kdM1QiZvt5NWMR69kXnT?=
 =?us-ascii?Q?cEfnryRxbuHvoZBfTtCfcB3i2BpavAUIC7OAzF5ECq9odQATIDJ6WAJT3uUM?=
 =?us-ascii?Q?omnvSUmQfot4s3+jYL+v/RlFRadRhcdSva44c+LZP3vSA0+UwTKMB4x9NNU2?=
 =?us-ascii?Q?7Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NkTUFxobU2lDm4n9aCUw7Amq4qaGszLNBTCbWqu+aY5YiInpbPM90hAcfP7hUBzz0CK3i4TbVdpLp6AOve9Cbkg6NHggIQqRaLl7xLNmeYrvZAHS/bgNc8fC8ViLwAFzRPeTdoJFx/0MZKckwf2rLB1zRYwaR9v4Y6cO9PPLtq0GC9NooXjwsb9XeOblxAIE79bbErU1uifJCS37QTOnvKZA5ElbagL92zbRdYojKP1S+NtbY1UPiJFyTSXCYpU6WOnrUfaNj3ZOPpEOjgE3nWCvu/4RqZ5DVBzO3bRUWbpC/ny7trtFrR7QkukvzilBcZ5UnVbDijxiC8ibsmEvMkbixoq3vMw4geAwfw35NPzd6qFDIz7+8ZiU7lMqM7pmgfiNYm14a3FBcnoStUF+FXyxEzxvqplu0fxOzXUusHQ0QTZ5Xq5Q/mxOKtZLBQuM6UQCDc8DdIcPpL7wFjB47QZCWVUfr0L3NgbGQAXt76YQN4yriTq1O+MtZW2TE5Kq3AqFjGRz1kEukxVVmIcIrdpYnbd5GFCY/Uyg9sBbjD2WNNTkNsH9PKCTz7SVIJbeV4NgGOKh+lR3eIpfP4I9YY8ypv3j04nTKVFsFCX2gU0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 677724e6-2c3d-4abe-007a-08de12478233
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 15:19:07.1263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DnyfkOrdNdc5Fa92xwKex69qKnLKQ8QLfuhq/+G4NITufzj1QJmbX2iDxq7CWfZ2ZAs+ojvSrwyZracVLstCMirR61t23JrbcTUS6ddYJVk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8132
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-23_01,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510230140
X-Proofpoint-GUID: YKjfdaG-gQllpMfs7VzgujO_D-SXlyNW
X-Authority-Analysis: v=2.4 cv=bLgb4f+Z c=1 sm=1 tr=0 ts=68fa476e b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=i3X5FwGiAAAA:8 a=QyXUC8HyAAAA:8 a=NEAV23lmAAAA:8
 a=yPCof4ZbAAAA:8 a=Z4Rwk6OoAAAA:8 a=37rDS-QxAAAA:8 a=u8nmidXnuLdj62qIATEA:9
 a=CjuIK1q_8ugA:10 a=mmqRlSCDY2ywfjPLJ4af:22 a=HkZW87K1Qel5hWWM3VKY:22
 a=k1Nq6YrhK2t884LQW06G:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDA3MSBTYWx0ZWRfXxpcNyX0W+mxC
 hAsIHYWLhlqtcfG4UJJNlYR81HqjXXUeRU8Xaj+QX5YktqGZ5nZ2sPZW9OYPO5peRY9MQAkHahd
 vpLP+QhEGZda0Uvxdo+rJc7+r58RCpFJjvcvsd3FK10Eug+fczdlFZ7IyiDQtOuqFgPjILOZcnk
 2mZSyOcKt92vfVNQbZZEYeEoEJeV3qa1yXAsf3iKhhBowJazXAOvEsFwTyHg/dTK3/GJ9SMcW3S
 2Dlbfc3RjC1Hv2D9h+m6hTV8uP5zxFGd1lVc6pHTIpN4RvPV/HDOtu6feYrCDSmlE4O7tHFPUSE
 p+Ujbc8jBRDKnjAYEcNNgidQNuvykEKqSnZ50D6N2iXMDdvGcT1rvWxXOfSzo+yicBg4aFS2k2E
 DFL+MYDlYFzoKkZsZCz9LxLSFPOpAQ==
X-Proofpoint-ORIG-GUID: YKjfdaG-gQllpMfs7VzgujO_D-SXlyNW
X-Rspam-User: 
X-Rspamd-Queue-Id: 7A61318000A
X-Rspamd-Server: rspam03
X-Stat-Signature: xx675nsg8yh4ixnrojp41cdnsgx7nkd4
X-HE-Tag: 1761232756-628298
X-HE-Meta: U2FsdGVkX19acHfLn36kgaj5xNKiFc1ckQRGiWID8ocgFPrjV+/HwGSVmJHmCQ9XlolcXVMBe1F7YUXZxyMybfWF83sXsDiTMGvm79smq2JryWI1Etu3FDMjFqOWR32I07Udo7d+l23irM5qA8NdGbIun7AmyRS0fv0DIX95H1BKGw6FZBDNfmqklZW162HZYzD+ChsjasggAw1YzYZLRCJUVAdzkDoWI6XMdrOSGg4Ldfk6/rmhY8GCenQEesAMGyBX6JbNY+L+7M8v1QVBKQdAzhpD5h/6EQlDz8mpEWBn2RJmUj6ST6q/x0EtQdpI9Hq2W1BFCTc0Wp+tifWistCfl+IXEtLrqFyGa+6sLmVbX1r57zh3RJP1jiW9Ugq8nk+VWx1JsxA1/70gRNuxzbfyrCVNPRSIUmX8/JGSnmPdgpUUZNCHGmsCc3e8uZqgnrw4VoM72zTnu5flTs6wjXzBQDF+NwLkTJ8mw7aX3GZQzdFYIEBvImX+ftLWiwE8ulkpXWkED6ocUtPTRT4+HiFxDTt36KKke65yOU4sZ4YKAZ31rVMEkexjDrWfv/zUbJHkFJSHdppDMBtXsmPuw1fXqbj+rYW2Uj7Jpijkdqvrtbdcl+HBE5NNa3n5QLZdr5Jp8S7vGBe+/l2rHfTY7REPqqXMgtzkgLxEZhaC7/wmebXMwm12BZmwl3p+U+U+OMbEWx2TKVL7bYKkMLYWQSnEPcwfuAnaHgp8fzwigZxHjpLHWjSjnHXAj22SpaAgiCEdKKlqEx+W2U+NUebdCQCoOrlTg6lYpJFM0SxtyuP/JXwPbtJz1pTcyAkaV7v+J9kT7agRvDgNLnRIDpxmqJt/4xq5XO3esXs9qUoDZdm5VS5QKL4QZMeSsyrik0J/ujloRsqqOMj9SdslDBVM40X6SnJs2tSt62DY2v0nr0nhr91dZkYzktBRqlfYQLc+zG78Bze3OKU5AciD6TS
 Ot/ednvk
 p9limP/LhZD/jMDO28PM9Rr0oPxRm0BKFJBT/aVvAum0m60geQ4EarjC1JcaCyxL/qkzXiQ1qOBCweDCjxhL3LAWetvXdVs16m3MnZmKwezVamCWwb6l5PdvwQz5zEhH25QcGJAXq4nx4qn+wDvXRu3B4GifiwxWj5TUzqUMUstneapxu2vyDgLKSqmlEw0Usl9zuA1Hwd5+C1ijeYXZz+rHixBT65I5pCbhVeQ1Q8OLDYnJcWrvwfwsktiJnkA61GBc6RmHI9SKZz7Bpi1Docf4yfwdbbFyBsF3aH1vNig1tqrDSq7dIgt4ig51IIxFNwIGSbjC15AAwtr83qnDtQM3zu1shoQHHapFbr1bxd3VZeDqKm4fwtbsjDzLhTEwHcNleWgg6rNmP5abteZRZyHvvZEPLcRW2mJXTujOGvoyC7oTaYVW3bu7h+c121OJDMpCkx2yngFeHKUg3Zu1mADMQlOykxSbDBJI+QwPge/OSBddBoGMNMsw59R800UHGJT+CL0asPs8+czso0hv49PjRMUIt5Y9cfO+08xhwjpcUilJMLWDmFzwSpp+kwxjeP+T3NK0Ns5ZJYCGa8JuttfIKPn5YbRV4vSHgETmEfO12918KzCdhA++ggEOOcF073Za8CECnQx5R0Nbx0Jqzur5ekqO18aR3mVRYJqVEkPgaEcfMna4CZ9qHb4dX3uajyy7WVbkw/0YpZyplVpy2bkRRoD4jD52VP1awU8NxOur0lLDc41YL9CO9N90tr3Rvk1bPgYp868ta2w3/LttyaSpWYrTklYuJUqetzmlu2rO/cHKLpVzEPDUxC+VgbpoWpvitQQ3oEUZe2zj+AACF2sm5JCIJa2PTU5Rphy1O9Cuh/ERc1WsOsyc6H9WKAKwnYydk377quvaviSXNZKjJzu12IOW2EcVqzrmI3SJJu6trxJ1r9fu8kYsNv4InNFkyOfTqBGiipd7ZJ/GmezWSwL683Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 04:58:56PM +0800, Julia Lawall wrote:
>
>
> ---------- Forwarded message ----------
> Date: Thu, 23 Oct 2025 15:29:09 +0800
> From: kernel test robot <lkp@intel.com>
> To: oe-kbuild@lists.linux.dev
> Cc: lkp@intel.com, Julia Lawall <julia.lawall@inria.fr>
> Subject: fs/proc/base.c:3279:4-39: opportunity for str_yes_no(mm_flags_test (
>     MMF_VM_MERGE_ANY , mm ))
>
> BCC: lkp@intel.com
> CC: oe-kbuild-all@lists.linux.dev
> CC: linux-kernel@vger.kernel.org
> TO: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Linux Memory Management List <linux-mm@kvack.org>
> CC: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> CC: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> Hi Lorenzo,
>
> FYI, the error/warning was bisected to this commit, please ignore it if it's irrelevant.
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   43e9ad0c55a369ecc84a4788d06a8a6bfa634f1c
> commit: d14d3f535e13ff0661b9a74133a8d6b9f9950712 mm: convert remaining users to mm_flags_*() accessors
> date:   6 weeks ago
> :::::: branch date: 6 hours ago
> :::::: commit date: 6 weeks ago
> config: m68k-randconfig-r063-20251023 (https://download.01.org/0day-ci/archive/20251023/202510231541.uVpbrSce-lkp@intel.com/config)
> compiler: m68k-linux-gcc (GCC) 8.5.0
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Reported-by: Julia Lawall <julia.lawall@inria.fr>
> | Closes: https://lore.kernel.org/r/202510231541.uVpbrSce-lkp@intel.com/
>
> cocci warnings: (new ones prefixed by >>)
>    fs/proc/base.c:3286:4-29: opportunity for str_yes_no(ksm_process_mergeable ( mm ))
> >> fs/proc/base.c:3279:4-39: opportunity for str_yes_no(mm_flags_test ( MMF_VM_MERGE_ANY , mm ))

Thanks, I just happened to update this code to use the new mm flag
interface, so this was existing code :)

Cheers, Lorenzo

>
> vim +3279 fs/proc/base.c
>
> 7c23b3300116907 Josh Poimboeuf  2017-02-13  3251
> 7609385337a4feb xu xin          2022-04-28  3252  #ifdef CONFIG_KSM
> 7609385337a4feb xu xin          2022-04-28  3253  static int proc_pid_ksm_merging_pages(struct seq_file *m, struct pid_namespace *ns,
> 7609385337a4feb xu xin          2022-04-28  3254  				struct pid *pid, struct task_struct *task)
> 7609385337a4feb xu xin          2022-04-28  3255  {
> 7609385337a4feb xu xin          2022-04-28  3256  	struct mm_struct *mm;
> 7609385337a4feb xu xin          2022-04-28  3257
> 7609385337a4feb xu xin          2022-04-28  3258  	mm = get_task_mm(task);
> 7609385337a4feb xu xin          2022-04-28  3259  	if (mm) {
> 7609385337a4feb xu xin          2022-04-28  3260  		seq_printf(m, "%lu\n", mm->ksm_merging_pages);
> 7609385337a4feb xu xin          2022-04-28  3261  		mmput(mm);
> 7609385337a4feb xu xin          2022-04-28  3262  	}
> 7609385337a4feb xu xin          2022-04-28  3263
> 7609385337a4feb xu xin          2022-04-28  3264  	return 0;
> 7609385337a4feb xu xin          2022-04-28  3265  }
> cb4df4cae4f2bd8 xu xin          2022-08-30  3266  static int proc_pid_ksm_stat(struct seq_file *m, struct pid_namespace *ns,
> cb4df4cae4f2bd8 xu xin          2022-08-30  3267  				struct pid *pid, struct task_struct *task)
> cb4df4cae4f2bd8 xu xin          2022-08-30  3268  {
> cb4df4cae4f2bd8 xu xin          2022-08-30  3269  	struct mm_struct *mm;
> 3ab76c767bc783c xu xin          2025-01-10  3270  	int ret = 0;
> cb4df4cae4f2bd8 xu xin          2022-08-30  3271
> cb4df4cae4f2bd8 xu xin          2022-08-30  3272  	mm = get_task_mm(task);
> cb4df4cae4f2bd8 xu xin          2022-08-30  3273  	if (mm) {
> cb4df4cae4f2bd8 xu xin          2022-08-30  3274  		seq_printf(m, "ksm_rmap_items %lu\n", mm->ksm_rmap_items);
> c2dc78b86e0821e Chengming Zhou  2024-05-28  3275  		seq_printf(m, "ksm_zero_pages %ld\n", mm_ksm_zero_pages(mm));
> d21077fbc2fc987 Stefan Roesch   2023-04-17  3276  		seq_printf(m, "ksm_merging_pages %lu\n", mm->ksm_merging_pages);
> d21077fbc2fc987 Stefan Roesch   2023-04-17  3277  		seq_printf(m, "ksm_process_profit %ld\n", ksm_process_profit(mm));
> 3ab76c767bc783c xu xin          2025-01-10  3278  		seq_printf(m, "ksm_merge_any: %s\n",
> d14d3f535e13ff0 Lorenzo Stoakes 2025-08-12 @3279  				mm_flags_test(MMF_VM_MERGE_ANY, mm) ? "yes" : "no");
> 3ab76c767bc783c xu xin          2025-01-10  3280  		ret = mmap_read_lock_killable(mm);
> 3ab76c767bc783c xu xin          2025-01-10  3281  		if (ret) {
> 3ab76c767bc783c xu xin          2025-01-10  3282  			mmput(mm);
> 3ab76c767bc783c xu xin          2025-01-10  3283  			return ret;
> 3ab76c767bc783c xu xin          2025-01-10  3284  		}
> 3ab76c767bc783c xu xin          2025-01-10  3285  		seq_printf(m, "ksm_mergeable: %s\n",
> 3ab76c767bc783c xu xin          2025-01-10  3286  				ksm_process_mergeable(mm) ? "yes" : "no");
> 3ab76c767bc783c xu xin          2025-01-10  3287  		mmap_read_unlock(mm);
> cb4df4cae4f2bd8 xu xin          2022-08-30  3288  		mmput(mm);
> cb4df4cae4f2bd8 xu xin          2022-08-30  3289  	}
> cb4df4cae4f2bd8 xu xin          2022-08-30  3290
> cb4df4cae4f2bd8 xu xin          2022-08-30  3291  	return 0;
> cb4df4cae4f2bd8 xu xin          2022-08-30  3292  }
> 7609385337a4feb xu xin          2022-04-28  3293  #endif /* CONFIG_KSM */
> 7609385337a4feb xu xin          2022-04-28  3294
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

