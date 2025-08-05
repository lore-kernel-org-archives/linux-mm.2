Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9673AC87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 19:21:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DBE28E0002; Tue,  5 Aug 2025 15:21:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B3838E0001; Tue,  5 Aug 2025 15:21:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE4558E0002; Tue,  5 Aug 2025 15:21:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E0DF78E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 15:21:47 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 29617C0205
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 19:21:47 +0000 (UTC)
X-FDA: 83743673454.21.39C5CCC
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3D50FC000B
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 19:21:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Af7FUed/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gs6g+V8f;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754421703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Kz0o/F6f+eU+ZwGfyaTGP1gvwljzLO0XUD/PnGpW7c=;
	b=5PNeHeFoLGI+Ra6Euc1wjm1pHK6cVdukARaE0cegySo1pzPfwNTTyMd6SMCXmciysh7Bg+
	Kfijg8Cq9fI9qw8UJWRaJkT9rUuRo9nPBpnPDxgl7PgvwOOvqZYFGAYemIKJN6xkJzGBFW
	CDA0tobLlyCzf0q4YSZ/ToQtsb6cjDI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754421703; a=rsa-sha256;
	cv=pass;
	b=b1wI5b3SPrNVx2L+XOSj9wXFzZU6ujX0yd1446rhcEe5vKOvYg0kiEdLLtSRFqEIFJquK/
	3GrF7JKsz7LeNRw7qlt95qbLxRdVFmdFOfVXm5esGAt7YnQTvYxvBNnsx3840BEgANjANk
	QahtnX6Cv4p4IbhJ/bL1IPj7Acmhrgs=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Af7FUed/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gs6g+V8f;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 575IuRK0021587;
	Tue, 5 Aug 2025 19:21:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=+Kz0o/F6f+eU+ZwGfy
	aTGP1gvwljzLO0XUD/PnGpW7c=; b=Af7FUed/+AU/wpTHLoQqCx5qucjLCpCzuU
	cjtOrtmL7R3i+kPjWIBeS/lDU8RJBcI3Llr4buHZ04TEDo+Tyl/DKRPq1d5ovYty
	iS+vRxews/o0h5AiJI/enukv2WfP/2mlhwf5MXAeG/JwL+sLEA6pnL/V9HvOYEn6
	9SBscm63YSwq2Z0dqv+epYTPgJ4gQemAuLgCovB/m3awC/ZqVDesLvzL6+khZQFj
	33jK4w9Ik17lu4oMZIiikxKp+qUoFf1XDzGzFIMO6R8zhNckvdBAlOrfaXXyWjV+
	d5jrNVnkTnQwM2k0D/YwoCzxddi2R9Ek+YmigzOl4MNjaKFA0umw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvh053p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Aug 2025 19:21:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 575JKfT7015447;
	Tue, 5 Aug 2025 19:21:36 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2082.outbound.protection.outlook.com [40.107.94.82])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48bpww2vwy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Aug 2025 19:21:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RprJBg8OanCi7wx1D34WTRU5gSW2ujwc2F3eLRwxTh1H4HuZ5itx+z2OpcCIfvAT2zc6uGMy0IX8ZfLkqVhCAxVAlQFOvSm9sTSQtMVD3baQ47hUiHeQIAIy+DuDxCmj7W39nINxZgueLbHFhE7Gt9AHVt60QTczeAJzvl45Ywx+ApYNkPMe4cDjFPKFpKe3DBU0LIODdF2Zu4Ge4xBCw5feSwZHOXYIIabcWpoh7PdOjo4Wv9i55bnFcTw5xBIH6Uuf9/ttaXhZiew0o4oivYD68nq46YITxuH0leUeTweV6a7aT9c001dwNKZySZ8Jd2s3NRzCnnQF42Zr+j+9Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Kz0o/F6f+eU+ZwGfyaTGP1gvwljzLO0XUD/PnGpW7c=;
 b=kHqJWgLG4tN7y21ntOAbirT9ir5W8mQ0t0IOmeGs7FKuU5xV9Zqff0ZmU9fVdZAtt9qDQk39w6OI8kmum5Y60C3Hoc2R+l19SWmCbKkJGyBj0mJ2otMUxS1UgBfLO9WgBmpAmt/oDrHBOx1WngvJEDZuKVzRdXTBtCl9gEw1gehwgL3M3BIzzIIgr2NdqZ4y/ZTDRlIxPz2jFy36V8+fUP8sM8lztvTYrB30OWufSh6okNzr9GtMxRpGIbzSeBNaHimEy52BWmdoMrB1TupWRwl6ZkDbeSuuFm2yXJrjTAqJ0J0wa2AQx+LgZrgupExPSO8tr9l1oMvjtL9bxA6b4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Kz0o/F6f+eU+ZwGfyaTGP1gvwljzLO0XUD/PnGpW7c=;
 b=gs6g+V8f0b+W/rbnpw5OOK3/L8mM+lONLYwmPR9JmLUKeJ0gHnZgdi5Rh7IEHE2+2uj4WQ1wUfJGKp8Aoqd0nHUMw4GbwUcVhyaFD11HPC+CcToeauhvFR6cgJwNeNfCG9uaBtk5zvaH3qHi2co+ldmenAY00KAnGHXwQbOBJfw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH3PPFDB252061E.namprd10.prod.outlook.com (2603:10b6:518:1::7cb) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Tue, 5 Aug
 2025 19:21:25 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.013; Tue, 5 Aug 2025
 19:21:25 +0000
Date: Tue, 5 Aug 2025 20:21:23 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Zi Yan <ziy@nvidia.com>
Cc: wang lian <lianux.mm@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, David Hildenbrand <david@redhat.com>,
        Wei Yang <richard.weiyang@gmail.com>,
        Christian Brauner <brauner@kernel.org>, Jann Horn <jannh@google.com>,
        Kairui Song <ryncsn@gmail.com>, Liam Howlett <liam.howlett@oracle.com>,
        Mark Brown <broonie@kernel.org>, SeongJae Park <sj@kernel.org>,
        Shuah Khan <shuah@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Pedro Falcato <pfalcato@suse.de>
Subject: Re: [PATCH] selftests/mm: fix FORCE_READ to read input value
 correctly.
Message-ID: <dc139b0b-e461-4edb-ba1d-fc824f875142@lucifer.local>
References: <20250805175140.241656-1-ziy@nvidia.com>
 <7eaa1660-06d3-49b9-ba5e-28df1c35dcd1@lucifer.local>
 <6E5CCF4D-CB63-4E4C-BEDA-6FE533E0DFCD@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E5CCF4D-CB63-4E4C-BEDA-6FE533E0DFCD@nvidia.com>
X-ClientProxiedBy: AM0PR10CA0073.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::26) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH3PPFDB252061E:EE_
X-MS-Office365-Filtering-Correlation-Id: b594dce9-6454-46b8-a66a-08ddd4554559
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/73oRWAmxt/LrbA1UfNHeB86biljvVtY4xYyykBRRTP22JKcNCPvgDC/wbB8?=
 =?us-ascii?Q?x7q5y2yxptk4i7jKHbYjc+btzvWn97d2HOU+SaDNKywpRo12mBKoVlGQPrWP?=
 =?us-ascii?Q?8jjnUxScLlYLrV2iqN204CAYXwoxxTHttf0jPZZATrZ+hSTaQm3nQ7IntRcd?=
 =?us-ascii?Q?+zgQUM8/T84D4+/yXB4mlFRmTMRSf/q4Z5ZzNDfiDac7jJVvZ/y3HG5oz9Rk?=
 =?us-ascii?Q?QirEqPGw8rsNFVjOPE/FdqWJ45Fy7XT36qJMM/oZ65fQn03C4aQyytm/ITF0?=
 =?us-ascii?Q?j3XstDSyd07+sF0CmIlqzEQTH7aYJXwqQBMpCepiFk+EOkAEKrJJLCy+uarT?=
 =?us-ascii?Q?2vSiuAz6TTnLleT25hpQr6xaoulPHZ7tbFAivilAYpcTkpfW9qGDW6V7K2Vg?=
 =?us-ascii?Q?cPaYaOdt+6YGxSt33tfOcBW2yvqHQF0bTIEyoWfdY3ng2ky5Hs/s0aq6LdAu?=
 =?us-ascii?Q?RqQvFsDqGrLcPMB0Rhx0ZtW+WBkdlQZzyuQ17hHg5cjoWPqinmLwYiWGmtgF?=
 =?us-ascii?Q?sGqypUzApvQa85PHEvXBLlxdtxpOUTBD9ILsVsOehSFRSLzYOxGMY4sYASdI?=
 =?us-ascii?Q?CUturG8HCbTxee29t5akm4CvenMtmLhIde8Ae5uTcVzyu98CpRh33Fb06EgP?=
 =?us-ascii?Q?h+ConKl5dsCUq2Pdo0jFVsSwFcoXjc0HfAeRkWPn9+B2FZqB9XYe3+bSU7Ek?=
 =?us-ascii?Q?s230AlsqS1lWyXCbty/CWpgeexdfWaO40r2ZwEBLiT7e2OQpxyolt/5ynqSs?=
 =?us-ascii?Q?j5CaQeT401gmARioXZVFK3h7qzTnAovny8Dy6PB0Hg9gGmlKTgn7hSi3HNN8?=
 =?us-ascii?Q?XUhJ38jGrDhcG8IRp6XkKSpWZDZBTi2EtuimZjMBva+dyvksfS3K1pr1gJJf?=
 =?us-ascii?Q?wYIWtu7+/nsPJ28HEZKHf6xiKrhQzaC9oCH6/065IHolFL7QJCGFz9aj7U7l?=
 =?us-ascii?Q?LfX1SodEdoCFx0uKo1TxH3ciJoBXxtIocqgDcMAbUi+gPNBbtpIczkU3PEgW?=
 =?us-ascii?Q?FN5tbJUzFcygeCYmWIKu5/e2Oe97fSueVU2nx53t+FatoZIowYtrQ6YVxee+?=
 =?us-ascii?Q?wdiwsKyuPE+tmqjvhona57kcO/obDtz4dw7b6vrint3/SSbc7cIn5LHDVgmF?=
 =?us-ascii?Q?7sPeabOoyvd3mQuA174lCTq7cf2I7zFhPRlGtCBgwhEYd4LsYYw1++egP7F7?=
 =?us-ascii?Q?LV/SZ/HQN+T8UWlefxQqhdJwwLU62SCzxJ0gI+JeFh1jk8KSPNYlgvQ/sPiV?=
 =?us-ascii?Q?Lneckdi/SJzr0+OAlvUXjGUWTdMbUZHXQ+45ULhdfKP3/8cVTcC4UFzCgwcn?=
 =?us-ascii?Q?HQci0JBXbN26r8chSuVKZpssFr0X7WjWfITJBSATYXX+PTGPkIr0p/Ly74Rd?=
 =?us-ascii?Q?iXeOFRrBbxJA2G4WogjXLGEmu4bk2r86Brod+P4A/tOFpWu2Plg/Qy1opke8?=
 =?us-ascii?Q?CVdykNcnJx8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fE+BxSu3cUPXFRFHvhqXCOu5D6jRXjrmuRtWIV2VOR4grkotg4dfP7mpTtN6?=
 =?us-ascii?Q?KT8tlCnNy564+Ru+M4PDejA5MViuv/ZyHIj8O+PLFpW1Iv/LLUPmNxIx8jHF?=
 =?us-ascii?Q?UabaefwT07PUkCJcegZ6WNOewOHYrwfAikpjWSFxmCBLdD8s7LdGP9icXiOj?=
 =?us-ascii?Q?c4yQnPkhO3PXErLyoep6vSNfo2xCMF6duSc+RKVAlFCzi+slAc2NlYHwIGLr?=
 =?us-ascii?Q?R/lrSR9IX12/tB5hB00Ca61zdDlG1pfNfNC0ESu/5OaLdBKMgTRcWQ7l9OKM?=
 =?us-ascii?Q?Fgp2AGaPF8DmFW7nJe9fA34MBnZ+uxdHVEI8tz5QY/A+6G/pzQ+zY7PuRZ8g?=
 =?us-ascii?Q?x+gSnGf39Nt7+aCz1KG/80Uwbe/DPRhv5Gj+0c6iS/+tDY483UfxIHdfb5NY?=
 =?us-ascii?Q?julAc4o0ieG/gXD+FGkL9qUij3/QkCW0Fj8C37tK2eFaL5g+t9d/YWX8gtqz?=
 =?us-ascii?Q?lMui2Q1Y67SsIZCr2o/COddvDP8FBdfXP9WXSZtiPliIE7exP7DHFg2Ows1b?=
 =?us-ascii?Q?l+p3Kd/xxM8l3pQ/0fZyB3STvw/LGB3YHaNwL2PWzAwS2y5G0Y86raVZLthO?=
 =?us-ascii?Q?Ba8O2EEhFMNRo0qEt8Ae2D9I1bJuNiXpAQaK96KlNGW+7DA8beaMwrI6iPF1?=
 =?us-ascii?Q?bzRDo2mygljLCXZkS3/CckDuaYQLhojRv23CB9ERzS5V8d1BpBc8Jci3MG0q?=
 =?us-ascii?Q?r/IcnT+KU50t4qYsapNKNN2Kparzi7er9Rvllb167OWebY2ZLy4zQUfHVOma?=
 =?us-ascii?Q?sm2s9A3YeZKJBVJZltHPY3q1pgWD2RMwzAPFGNxdVgc/iZd1bh2X2PuPUU4x?=
 =?us-ascii?Q?mPVsA6ozUzxWOXdLq6gMCyixlEGDWIQRTsTOIbjRvdAkFwrODOUoUHDJnZEk?=
 =?us-ascii?Q?HnZAhamX/vXvuuk+KU+d9DcCmK6xWg2KmDZYS0OqdDBqrnsF0zSnGBIoatHm?=
 =?us-ascii?Q?pVLZGTLoNoDWsO7vl36MNayEXMsDJBXaGKv/qY7A6P/AqsaPWZt5DOPQh9J9?=
 =?us-ascii?Q?zAiPSjWp1u2yAI21qG5iw91LYDkgcWB1Nt4fbLh0NSd45eab0PAIctL0Wi/k?=
 =?us-ascii?Q?IJHjT5JOlMq0pZckHNWL7x4Bake9HGkMVd393fOCnTFk7VdP9f2RKTLQSXaB?=
 =?us-ascii?Q?/Sryj9QEuQhbcj0LLjTVMG+VVtXuAThDu6LFBUOQ6jL3rL9mNwi52bBY10ZR?=
 =?us-ascii?Q?cyNlugwBXZNqeA4/cR9DhcPnWnBveqjUKSgr2XpIVtyFHxUx5Yggh1kqrUzl?=
 =?us-ascii?Q?2RH/Updx7/ZxNn9MDQpxgD3l3tBK+BKVOKxOwT+oaM6b7qErL6nAPjiqzjP/?=
 =?us-ascii?Q?G5i5A1NXzpfSeZ14R+zfO+wQjOtW2sGGogBYPbOB41NBH08eAGx7EUro+2Z/?=
 =?us-ascii?Q?EkncxUCxBjoA58eWFx2yfLmotOVpoMkw2lMof8Lrf0y2rpMm5ZXRZqbTJ1he?=
 =?us-ascii?Q?4t6Pr3G7smEkvtqgWnk+w+PEm8VT9HfvHwQcBrMiOWM9P6dyPZ6CD9xcZUFL?=
 =?us-ascii?Q?DETvZ9BaKaP8dfxI8rQwtYWrgn10nSSp3znQdugm1zCQJ4MtVxSnOlb/wQql?=
 =?us-ascii?Q?xkkJ53y+dsQjcl4+IM1qaovcQ1BxE0ufhHCqF9RNsC/R9rwRnSgQYPqW/cBf?=
 =?us-ascii?Q?Pw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZEBEaqB/9DUi0aH3mfM2wW9HfIdJDt30cllgYPavC3ncK+JDLbMzIIQzffgttNexHb8nbaQNAmLEu50QLQOvTy4fYOsoupHo8GtQtzBx5NVdjEEqzhFFZwBXViKeosYYJHHoNGZXCa1gyHQABOi+MsJG6qyaLKI3djcv9MSJ/XIlLBa+fuck1QWTlqT0zm/Qe5HNUn3b5rm3tkiGenVB8XY1OarIuA3ptSV5ljZoL0Jxir3Ph2ZC+6VX2eK8iNLAUU9HyUE77GNq/gH7wcQd0A0OqBtDOgWYVi5oFTcwCnMwW/M2H7cqx5oaXuptslOjqg1L4Rtgeb679WeZHfq/+bfM2TbrlxG6U1GPdV1DMSEcNs2ED/RhOrgTIZdpI9R+j+51mchrxlVs9CPoMaNl379u9drAQ3o+f4wg7F/TWGPXjmDMzuH2tBIQjIblwVR7KHfKzCsoZRaD2btl8RyoSSsMeK/X8IP/Gl47urCvRyDb2pVBeYjEUnUlvUzqB/zevAXoOs4JSmuybXKjGCuRfLybPfIBMpmsG2iOEQ2dj+Nz3oThxZn91D2b3LsD2f8xcbEnJncwUNINHt1pr/3HkFIHKp+vEnX0VlYiNmDl7Z8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b594dce9-6454-46b8-a66a-08ddd4554559
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2025 19:21:25.7894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o5SyePjQZihlt4jiT+m3bFjhCwjAaXFeRQeUMczN28xDmQoNecuEg1YfVPrzZxYvAAymHH8Nowdupdy3Gn476nWKjXjMcqfEsV2YjhjalQ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFDB252061E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-05_04,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 adultscore=0 phishscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=943 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508050136
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA1MDEzNiBTYWx0ZWRfXyOpbyMLOoXCR
 IoWwQhq3u2kLk6rJwF62FhpB1KqEfGANysoFjthB9/lKDVWNZGtkWMcPKOaRFsseNuDH0VGrCku
 3/6XjathkIk4IUQ/uIiXqU9qoPJWnf8COAt3cal4iWOVEoPAo7aoGRf5aBrlVuOFcJWp4v0m1N1
 bxIbu3RLHJtN/DlRVmPu/2YeIL0fnj5zqZVdqfAFSuckxTE7WjXBBDGBx0+Y3yh0/pEyihGuf/e
 2LK29ePSlbypIPYh7EvjhWVh9oShoXGYcRye8aSgi0gQs+euu2H9W7e3Ns9221sF+FScr4KAj0q
 C+B/SbfzgtTCdimTtIJ3b8xPnG2jWAaavi2edLuHmX09jhyg5EC3P/0Ur0L8FPryBxljkQh8ywI
 dGyeIj/vwJ8KBC9SkH56SR6G10BulcgNIo/vKE3bYANCSCgh8UmlmeobYlTa+JUiXHeJ4fwb
X-Proofpoint-ORIG-GUID: fDY2fdja-qEZSrVLU9wgp4Xxi81jwoqp
X-Proofpoint-GUID: fDY2fdja-qEZSrVLU9wgp4Xxi81jwoqp
X-Authority-Analysis: v=2.4 cv=Hpl2G1TS c=1 sm=1 tr=0 ts=689259c2 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=rj-OefaJZZvV5pXfS4oA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12065
X-Rspamd-Queue-Id: 3D50FC000B
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: kczf13uie3kcem7bpxd5653tbk58986b
X-HE-Tag: 1754421703-104808
X-HE-Meta: U2FsdGVkX19vCRh0rZwjNJ7KYWONmTOYvjJbSitvmxgNJ5uHkm1RFbMDzY533aD4rqBAARRMW8VRoEDipwIOSKv3jBumxdpjnJ8Xm/z4L/gBub9tNJZ6DKmWIvHnZ9hMOkv5IgvIl0CQxx6YMFX1B1ZrQ3a8aJ7/sO16j3ixKau6C+5YmQO6uuaZXRG9Pn+ib8T4Lqx7oO9d9NhAdcR0/0itis7SG/qBGJNEwlTPA4aisSO0oDBY6Nh08CL7qoZcgEubTGOphMz4DsQF8oiz5DcRXxqJlkYwZ8Oy9ft9qt66Iu/nnPZ2SSrD7aiKfVAYjS1a+xGdiZL0RmCVJ6US88e2alqDBvi3OkQVsXGHaUm2aq7zhOG9IEA8CIoK0yUW+zAFT7E3mmd6FPlnChKvXZGuekmEhoPIUt4/71J3AVzckCBBrGO67Ik7ZIMMtkSHh3jc3cQLNKPxHhGbYJWxK2nhlns+fPtlZ+HtfZan/ko5EDQZfepmwkN0Ozuj9bkXm9GhkvpeGsoKi7tYZb/Ra1PcFBEV3d9ZL6PPhM0adobZm53cblo/xOuHrOpvA0Dsl+yaOeGrXSr/xJdP8QVBxlVJ2ot8Z5+m2Y2CEDA1AImWMf7WHpqyVQWk5qWRfMPNijECNzbXiTXRDcaNSWS74j8xbWV46tocqjlTuL8eAHqDZcketAL2GB+Je1Pm8+rONH/lc7M/pK1uf/B2ULcjaW6Y2wdPlUqLKw2bzE7l0PSBjIL/Z3d7cOLcXTUT2wP/mrIexfVLMs4P9IWTgsHeU8rD/GWzqNHolloxuRB8bN3H/lzwG3S36dWM3vUJZnH8hRUr/AK6lPFf62VJzdjN+/9NHnD0Qy7YRDdoXZbhxSNtGY5H3zmrPcy+54vENvCBljErGOurRImQzaiB3d/KGYusMhyGZ64EwqbylWZqbwkxXUkjH+YQeEmAJtqH1QXkBVLJLCbQtmWiZY/q6c3
 UJpY+83s
 sZRxXrMPJyyLttYFzG9r9eKsckdzHXN/U0BxgLI01Wr60TO1Z5Bo1yFiLpqJqBqmFGuDre4c+q2IUg0gxS3Bru6LRWI9Nwt+nYiaYbb5retSIrLxmNjP7FjglEZTRwPn7JWf7V/JiSV5fo1LR89FxUUhnhsBFg0wNKad0ExuOYczKigaAnXvhnEafw21B7kwEf75p6UsymnJb54RI6gPaDhwAL/ccCqKYZUyo0VLYk/LwKRH5oefPG+bkGEBtejE+svlxtuvwF4hNCRgjvnTjQ8bhd/dXKqB9TU1HKbBBfjMnGcC1kqVUjC+0fIUEPzvAPy7dkwBjaVGmFg2sb4JBvrRiVEzW678rPlUsmmlVOjF4iic8jgtoheHP59MLIgGVsywcvBdb+SfWb7rZinEUzjvR3d1lKDVD9f3aCW9hCu00vJ5IJc7uq+u3Qe8fv8uz9H4xRNS5wjaTnTo/hxIOkMyY4MIKUuubZ9o1IprTMleED6KrqI+XwzCaKK+aL39volnTWT5bAzgD46TKaQrG3gWLNbPBPJ3pXR6enaVvnO1dpNtKa6ovTT7upAhmMb1LWY3pYZT1BY6xunhqKpe8hK1Jw5Uzv2JfxY/IsE29s2hv4RWDGYrpx8X3lXxtAhUxeQI9CO5iA3AfxZd4oeBgifdpkumIK0d0dLMU1C+nFsQ3HprvwLMQpETwM3x0Ss4joiSx35ZZ1eDdxB4dNWNe2XNBA6drm3oMM/Ke+eowFBP0A0xNz5XdzLJtYJp9npNWerFH+WjOpeYXNi/DLVq4HYj+yQOoo4MEqORzawt/cZsYgPsvZoIQhAZ7Hd2aehiTTNNiuUIWBT1MU+4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc Pedro

On Tue, Aug 05, 2025 at 03:09:54PM -0400, Zi Yan wrote:
> On 5 Aug 2025, at 15:00, Lorenzo Stoakes wrote:
>
> > On Tue, Aug 05, 2025 at 01:51:40PM -0400, Zi Yan wrote:
> >> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
> >> index c20298ae98ea..b55d1809debc 100644
> >> --- a/tools/testing/selftests/mm/vm_util.h
> >> +++ b/tools/testing/selftests/mm/vm_util.h
> >> @@ -23,7 +23,7 @@
> >>   * anything with it in order to trigger a read page fault. We therefore must use
> >>   * volatile to stop the compiler from optimising this away.
> >>   */
> >> -#define FORCE_READ(x) (*(volatile typeof(x) *)x)
> >> +#define FORCE_READ(x) (*(const volatile typeof(x) *)&(x))
> >
> > NIT: but wonder if const is necessary, and also (as discussed off-list
>
> I just used READ_ONCE() code, but it is not necessary.

It's not end of the world though.

>
> > again :) will this work with a (void) prefixed, just to a. make it clear
> > we're reading but discarding and b. to avoid any possible compiler warning
> > on this?
>
> Adding (void) makes no difference, at least from godbolt.

Yeah I won't pretend to understand _exactly_ what the compiler is doing here, if
this is working in practice across multiple compilers and read-faulting the page
that's good enough for me :)

>
> >
> > I know for some reason this form doesn't generate one currently (not sure
> > why), but we may hit that in future.
>
> Neither gcc nor clang complains without (void). My guess is that volatile
> is doing something there.

Indeed possibly, be interesting if you or Pedro who's also playing with this
could nail down exactly what's going on here.

>
> Best Regards,
> Yan, Zi

But from my point of view this patch is fine - ship it! :)

Cheers, Lorenzo

