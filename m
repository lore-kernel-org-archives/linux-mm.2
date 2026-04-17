Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFEB3F99C63
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 23:51:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBCEE6B015D; Fri, 17 Apr 2026 19:51:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D469C6B015E; Fri, 17 Apr 2026 19:51:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC19A6B015F; Fri, 17 Apr 2026 19:51:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A39926B015D
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 19:51:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3A3AF1602E5
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 23:51:25 +0000 (UTC)
X-FDA: 84669696930.30.1B273F4
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6EAD61C0002
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 23:51:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZP1S1RU7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KbRdXamY;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776469881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8aE/CqKS6a2fMo/Qp2aE7G/6g8s8kzBzZNfkNmSQQRE=;
	b=lE7d1x6nikvMLb0Tge8D7iTKezAd80bacdKjiDF3buPM1AExJrQvYOkiXaWKtCdYmcCLCo
	kHSj3MYaGLiYZ/Ja3joFDl0IsKfv5Gqf/MBcRwacX7adZIRjxQ6hGU3AUxgf2JIw0U4G4f
	N3LXg9JgCMf2bNDTjh5Df1Y9EH4DYT8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776469881; a=rsa-sha256;
	cv=pass;
	b=c5J4bwELQwh4OCkLM1ygu/Wb2N4GY3ticfF73Od4GgsQQjWHC6VhOuG8SAnD3aa7uhfDMR
	gFs4G6sSLurcJKIps9jLtI6YHnI5J5jeFGURijaXBW7efti/1/KIoEL8VrKDxjxxIIMGhD
	H5035wRCDBR780IlhAYjoNCMs7NUyYE=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZP1S1RU7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KbRdXamY;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63HKfmt6705050;
	Fri, 17 Apr 2026 23:51:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=8aE/CqKS6a2fMo/Qp2
	aE7G/6g8s8kzBzZNfkNmSQQRE=; b=ZP1S1RU7dST72vMFiC5gb1ajDweF9IQR1h
	sskqVgJYUPPYeQ5EkIar+sfK+fW0GNYnPLAhqeTAdSNiZNPQiEHAMx4H01o5v3ye
	PM2Ys/Kcsu/rTSteIMy2YA+9tT5MasW++oUHeM7va/zrxZ1bEgIelhDlDoMc571D
	E0nB4jjnXbSo0NAhzYGAegWlaSthqfDlA9jsVUVhzcPSiY0QMCfaCBOLGA8hfm5F
	1P2YjzyI2whIoxTM4KqMxtikTf2damLNDqj90ov3ugdXRwaE42wS88UViGk4lHkQ
	ZLBmu6jPFIcebmOGK/9VIEsmz8mC4XD7y8r2CQjycvBO5OwaF6Xw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh867k27j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Apr 2026 23:51:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63HNnMlq035567;
	Fri, 17 Apr 2026 23:51:13 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012026.outbound.protection.outlook.com [52.101.43.26])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dhyk3esaa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Apr 2026 23:51:13 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GT7/xcfyip7V47/n8fsYgrjiLdqX5QXFyK96YoZ7bMaKb2qctmq10Jem1S8bJOWTYKSH3GZvNBcWbq7DmzSdlSNLxzs8nFzeDUI4hMYhMp/8uPhfCWqKFQWFkSld/uGEAvVUXs9ylcgbEpyJifotWnSE5Sa26woSPdfhAbnVGAV5r1k2uT4KsyZqx6B/i+HF+N3yx5QOVKiq8ki67o78Hpsl+6a8JNPBYOQdaBJ8uarnjEZttha/GAMedXZ2LG0J5qIEEYov70MCbFJgnmGEPW0bTIF5BHCJg/Cw6VfEDju2OX887K6M9UL3VyrmuHLuhSR038ofcaymvIvTcuY4Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8aE/CqKS6a2fMo/Qp2aE7G/6g8s8kzBzZNfkNmSQQRE=;
 b=D5ZqWMRtE+3rnI8PtBWvdAzBud6FtLycdDXXb7aIOHjEwe6BH5gkSp+7doyLxB9BXdTKnQ2WYg4m0jGeE3S9H3oReYrVAC95i8UmmyFyMotY3aMMYIx6HltqYYhf9qJJc9SceUTM2dbmE98DjfE7ITfcVSulFOZOf7t4lrkf2h3IZ4OzBeY3Ahp4AEVkOm+pGcugGD1FcRzKb7E0mhWB4SHBmP8gIwQoY8dqBXXBVe/+3S8RV2TAJ92TiO2JSrHp7nKwXfB3OlFgWJXW7pkRWC7amvvPiFx4OZujptowDL12TQICDfHV5iCrTsC21R/AHQDSMJHe4f8EKbQqVOWgsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8aE/CqKS6a2fMo/Qp2aE7G/6g8s8kzBzZNfkNmSQQRE=;
 b=KbRdXamYz3vEwRq6yEI4jVomfvOVmGkHYEk5Q6MoIMiOvJbkJER3VE81TNR787FimO9RUzDfNDoHEUvIG9UCvO/ig8XmEZydLPx1zZkRSWIvmHBAFUfmpmiytdfk40hG5qtoRVST+J6Cqidy5cddMJS9RDHIOJbdxG410i3Dmnc=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH0PR10MB4792.namprd10.prod.outlook.com (2603:10b6:510:3d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Fri, 17 Apr
 2026 23:51:09 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9818.017; Fri, 17 Apr 2026
 23:51:09 +0000
Date: Fri, 17 Apr 2026 19:50:52 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: syzbot <syzbot+38a879f4a73497f2dfef@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, jannh@google.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ljs@kernel.org, pfalcato@suse.de,
        syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Subject: Re: [syzbot] [mm?] KCSAN: data-race in mas_wr_store_entry /
 mtree_range_walk (2)
Message-ID: <twv35g3umuktagxixl7q4upjz6hxf2rkep2ophcwz2qzbschrf@dy7lcxu5wrly>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	syzbot <syzbot+38a879f4a73497f2dfef@syzkaller.appspotmail.com>, akpm@linux-foundation.org, jannh@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, pfalcato@suse.de, 
	syzkaller-bugs@googlegroups.com, vbabka@kernel.org
References: <69e1f975.050a0220.1de265.0009.GAE@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69e1f975.050a0220.1de265.0009.GAE@google.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0330.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10a::17) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH0PR10MB4792:EE_
X-MS-Office365-Filtering-Correlation-Id: ac28db5d-6660-4183-5b3f-08de9cdc32b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	foorYxIETIpfMPevFnrK/98FAUrP3OqUGFq6Wnoe5yvzG5qJofQjZYzcRH1XkTX1Rpw2k3Xi1m2epOnDzYbD+VAN9d9wjDwje3lVuU7rvic13sSyBX/yW/BD/XIOaLdCuwpnSMQuhiFw54Kah2RB9SQTJ6oyW1PwuSrIZdp54nzic53YxnuDPOskqwaOAevL5CyqvLBzfK+XoveGtGfF6AQ8qydSz1rByAfaQ9E1ZX4wa14m+6Z4pAfNg39/jObk3OATAcIAwrgm7SVYq1f02tfYBwILhywQ7lnvAuvSgZyOM7vNAjh37jDmIGuMHjWXW0oSW3XDDoWDwkL0ojzZCA7xwZK0k+NOCfklSo+ttadCC0WcZGD8FQGXldj41RhJK+d5AJBjPPIlwh2nLSA1JgeREIFhQmna0fDAduGX12DMmKYcWGwXfEWrQkk3OXDkCt5IXcOijEsYcYAqkJG4bVkZf8ESXLTno8pRKduPWFB5Sb2MXBV4GUgTtYO29EECWc5KX4V4umQ1xNnVDHCwBHn2sJpMLdAenhKD/b3GXucIluSrG2QgKXw/l+8iYGEFr1cbpF6PQrdlFlAH/fKk7YqD4HjVeCgVBHdSIgSToVSvzwUpftf8kplT/bTWrHs9aVAVr/EF2tWLFWWwQ5pnoiU141oKxRvNYrCsu2osAqtrce5vcyDaYv5mI7smVsfp
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?M84b+Cvqx+OWUUOZWyYnFS8jdj8EcbIcFdf9IRYRFPVXb3C16ujytL0Y1rkV?=
 =?us-ascii?Q?A/r1o0hdfhIhS3wPfkCZs5LkYSm/Ra+OAxd07bmTHHm3Vm1wOflCzFL0mCFa?=
 =?us-ascii?Q?DlbxXem4YpDslTq1E+ZVly9FphITe1Jwu5D2liuSNmXyK2niFHUXUAiD0LfS?=
 =?us-ascii?Q?Jk7BxUEhWVcblhRZH2Een9/aHYmKnAGziFKEFJeCuZbFFjJrJMybk6PSWrn1?=
 =?us-ascii?Q?NiMV3hfqFUTXwnkugPAUmX8wnpKrwGC8z/DXeVNTJKb9liyEGQHVAK4ykHlh?=
 =?us-ascii?Q?CypCJy6mZbPVLK5bLctzSUP52GCR+wxdZqw8glM8QjYrAMPSE6f3r7IIpQkL?=
 =?us-ascii?Q?BlMJj4RwWl8jk1eTD75S1PED9IHVJase+1EZz4fAZj/bpg9aFRYlMcPsBgA9?=
 =?us-ascii?Q?bANerXwUICNZkzOpzo1Siqx2538XjuJvJKQ7gXiQ4TF/f/l8gaP7pLel5sdp?=
 =?us-ascii?Q?+ScpgagZV1efHoe+D8GANAu6OhFwnFW7vv/4AUQsjorJtjaGfDr0OLjpjfH7?=
 =?us-ascii?Q?q7hAJ6/dInyYbkyW+qXQQEleRKY9HtBzWZw+H0KusSX1yMMzTDeMHliIIS6l?=
 =?us-ascii?Q?r557yc/iJT+S2m/NVHhrKGjJcemfO2UmXkg72BR0EvAeSBJ22Q8Ilm5Hr5ed?=
 =?us-ascii?Q?87VQIKw/2z58ptH5HBys38r4FyFASfdO+ZJHg3xgADkfCy5oYkJAcDIddhQ0?=
 =?us-ascii?Q?hN3b/ZSObvMpqLDsSrbIQm+1LrFS3LvNPU6CETmjrzuWYq5I93+zzL8uBPcd?=
 =?us-ascii?Q?DczYDGES94Ewkn8kzza1zhU8KtDRCnDsvtWznJr9d77ZsWTwEakWp1q5ZMUC?=
 =?us-ascii?Q?Gtz+U8TfEAzlaIEELgNTUf8oOQKPWzSQxlXgdPUUaE59+RuryFwb3L2sgC3o?=
 =?us-ascii?Q?ZxVPVu0OF7iDgK3lI4/AWl8umlLIRg8l0MCAc/slwCMnEopQFI/zcvzks3FK?=
 =?us-ascii?Q?wPwY5olQMDvckADxHyGqTGmforOM8z301fkxjujzg+ohYqSX1xlqG70qWEYT?=
 =?us-ascii?Q?Jm0J99+znq9yzC8c2CB/kF3tUDzsCDkevA4mFpecFl+6mkKmQRH15b5LitUA?=
 =?us-ascii?Q?k2oC39eFbWkITOY4jGkU+pF3sMZLSfsgBbNEkquAMsB79d1yRb+rD0aJL2VM?=
 =?us-ascii?Q?Wavgr3ADJwaVe8zPAJCO2xkxjQGwwSPKNDpe9bD4WZ8QQ0qxVm5q1Iyk/v42?=
 =?us-ascii?Q?Tagjr35wqmXzQGejSB/3wXa6KYJLYdm7tlanhO1WRt67o9lXyqrDGrl0EVrF?=
 =?us-ascii?Q?razRoApSwjSSZL01zKoVjVSpVzjWOIil0HtwleFA+FwT/qlnyP9yoGsGnClo?=
 =?us-ascii?Q?bHA5+YKOy3r6inakv1TrE/tCTm0IwURiT0aKm7Y9gtfm2BclevWYgaMzzGat?=
 =?us-ascii?Q?VEXjfK05Sop5iumGCxudef4gVqFevGfvE8HEyPygCIHEjiQrwgQvwgDND+r1?=
 =?us-ascii?Q?3oan/E2g5cMVCvR8oY4CRQMSM4ymjjQKuo0lFEgWN4cuJUSLCWTW904nJZxo?=
 =?us-ascii?Q?44sDN1HH5rUSdFGG+ZFnelOW3TDRGXmbWudd0SpWPx8rQODBscy5/yEAFujT?=
 =?us-ascii?Q?sznag8rXE2UtoM3XyHj2SdE5ry2GBJW62FEeRw6UN5FwHteJH5SilwLllImw?=
 =?us-ascii?Q?68aUoD4ZXdNde362a35x11tmV+2yLT20r5vva2//zpYyxkOjDgsl1499uMNp?=
 =?us-ascii?Q?un0phR586KTDv4CatqUjO1gUXiYXsrvRHxN/eY2KcqRH+csxdv5r1ssZseHO?=
 =?us-ascii?Q?X7NSW3p1oA=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	D+eIcjb7ksh7boEAKbI8GAENHD+em3ve8j9l9KNuApBtYplsirh213XERHnOLwCpdgWMu80u0cjZmUffUbWBF7Mz4F5FDzXI5lk7tHvH0/VOjv+SVYUAAv3JrdO5A64ylPiuy/zvwQElKsyqE0OuiNRwPfFU5hWDQspbzPKSz/UwptPCe67W8qxYhhrmvpHhnNbAv70sZjSZc5/1glOzSkjz3kNCNB2NIJT3bc4+0+FH2t282Lix+AuF6Hn6vi7o98EPVMM5uX/obVmrttbvNyvcO+KjTe2kSVDUc4DRkYxQsyG5nJLvOTDLbolbyR/LnZ/cKtu8t8H8ivwAzFif1A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nlBCREjn1OYOOLH7aV5uOegLBuL+ASZGNPPBKPbZVKGpa2R/z4H171x9Fpi0HIw2KTXdC6mQRwt44/axjzTsbW55IGeX5D+NepvP6xf2MTAJEu9EZEhRsNc3LnaWKHVlFPawWl20Uh6FUf4qg/ZxZ18wRZapuPdoyYW99yuy8W3VQ3JpCwQxP4Z+BM1zwCbLZkTZoJSaGmmurGzt4/hJQxjGdD9ajr6dauveM+xU4bbEsWqymgflihhxi4QrKxbzDNqtyqepeDxLvcyIJSPokgtxiyoaq5uPdAGe+QG97kqXXnXbJUB8uOmd6GlEbA5fqk/SItzn3+hDSe6+Ca+FdlRolxIAFqrJpT149W+vakShnJ5rDHt6Js7No9MxEvF8VqD8ZCwdr2xOMGi0qIE88tKeomqtOHSRxG0hUjzebCAEtC8Z9eqnUvAWPrMs57CBVtSsV8FFeagicrBCBo7UjWDRaoMm2Qn8RBzcomONk78o+OUkh2i0Cvs63BALBvdYQFIlTTRq5J3z3CKbZGs5Yk2cMgEjtDvA9s4ZQX9MTtTfCfrdjHp6+rvibhGzjoflD2mI6Fx+sL/VEptjsI5/Y9/W6gO1FfJOAcGi1Vkou/c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac28db5d-6660-4183-5b3f-08de9cdc32b6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2026 23:51:09.3240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s5MfdatMfbQ24+jj+N4sMmUqMDlxYl4v+ePHrMVe7VZGivgi0HaSTM+od5jgpnh4/0IRoHULyVYz5l9E39+C0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4792
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-17_03,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604070000 definitions=main-2604170239
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE3MDIzOSBTYWx0ZWRfX1Wqupr8/cWFK
 0hYIf5NxmFvlB6a1FlP3kV5Le2/7aZJRBGY5sCcSmeTiCIAVT6Qpdj2LZ4zVUsYr8tmOgik0CjQ
 n159TPSnKmhnCru1QUYJeN5P8vnsF7WGAR39tG7IPnt0yjpKySJuCnk8+wvzU8SfByerP8oSb3I
 NBYSi/RIkFpgmaSSKjQAtAChYqdR9nCTh5zfRrL1otdoecSUXR5QUO0/CB6RO8AFxzaLWA+27gZ
 Q4Sifq1zSgd+YMkWhaqIDJcWWMZ6IcUpdxpmUC7t9SdDvjGAz529dsIbRZy9kfN8XRU65R4MqNp
 n8YAIxzXsv2K1Pvgc6hV647bX0DAAthJlh1A9O4+89PYBlgxcYN3/3jTk+rZ80mPQL1Neg+KOxa
 kYmYXI8gL0PZ20jVdtJcVZOE0Cy5JMwYfRZI7mdNpG8JDGqwi2WJ8XxUqGJfWD8Zn6t3VWz+jgm
 19JXGVSO4BN8/YWlnTQ==
X-Authority-Analysis: v=2.4 cv=cbjiaHDM c=1 sm=1 tr=0 ts=69e2c772 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=edf1wS77AAAA:8
 a=3g80flMcAAAA:8 a=oHvirCaBAAAA:8 a=hSkVLCK3AAAA:8 a=NEAV23lmAAAA:8
 a=4RBUngkUAAAA:8 a=H-nFrXJ8gHkiH6FMqh8A:9 a=BhMdqm2Wqc4Q2JL7t0yJfBCtM/Y=:19
 a=CjuIK1q_8ugA:10 a=slFVYn995OdndYK6izCD:22 a=DcSpbTIhAlouE1Uv7lRv:22
 a=3urWGuTZa-U-TZ_dHwj2:22 a=cQPPKAXgyycSBL8etih5:22 a=_sbA2Q-Kp09kWB8D3iXc:22
X-Proofpoint-GUID: HvztX1XLnyj_XSU3XL1Qj-C4Ury34a8o
X-Proofpoint-ORIG-GUID: HvztX1XLnyj_XSU3XL1Qj-C4Ury34a8o
X-Stat-Signature: udp58b1upcqiuqpnmmodbj3zn9enyz7p
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6EAD61C0002
X-Rspam-User: 
X-HE-Tag: 1776469881-252384
X-HE-Meta: U2FsdGVkX1+VlzVT8shVq7vgxjWu8oisBpHHYLQjyIieoetcInh/IJd7oucEIG/q0dibMxpKN45ZQ+dqIZ17CL9uzBgSuKiiVhc0P72I8om0ImvK5iaFxuNyI0iaxHkK0FQmyrv2S0WCjHsAPanWIUFakr2zTLJsdDdHHlOPOStLxH0/NUWKH2SbOTjrDcAhl5h4wbmXlkfYIiKCNwd2MRQ5gPFkgXPlQOHX5/y4njxaEXjupMDo8aiU+97/qDR0/ATGxLFzVIRPFSjfqUtYxmzf8hwIDc8z0LPYbCSaqP857AbP4xRCYxxszm7wOxf6SGjKggbenDft1W1zkM9YIHFOxU2PK89lz3NKFSMPsQrpy/GQ3opY9a4+c4Le8WZtSdc7yN/pl4SMfUz4h+qQNAtuA/9azfeTVvwweMYtqIJfCgcFdbmvJuO0Eb7RZ1VQpbcdKnQKc4Myj7iotLQMpKduLwAFNxqo959prYjHwYqMcMUvPIQ1JrHvH6xSYB+ZFOHyoh3OrriK44YjVxTfzlAdFNrpDOEf2nDeq4Z1suvUJ/Ys0jK3HKhYq2yQFyuRmT6B9b72JJo9yvvUhkIxgRuVNWj8/oVof2B8bjwdGamumxhk/mpPUXCotxiMOPeTKZYV5VL4EJ1saRXKMSFt5JsdBZY6ARKyAik046jA4zMM4I4eUWOt45zG6YgrCM0RITnC2q7SDeSouwK+ggHbFEjFc2ytF8VCjE3oCsStT+1ZErur91FJilT+J1QBuw56YLQT3Pfh5Sm93M7QGw8c3c/ppdriTluXeYKu1ZSI4rxEdf6hQlSBqhiEjbVNe81NgCegp0/RtCEDVoNG2/62TZwkYQamTtwbrxrGpjUxdB4JsrifpE6+xTmXq6T8XUkuQWOpGMOsUMRUSM5Ds4xVd9QORyZHMBmSLGJJ3Hhtd2wOkAvq+yi9rjQmm4aENgB7syzY+yqDt9eORFWWEa9
 3aKl3DFp
 b1TkgcNZENOrnKr1OY7oB5lHALDaC/3jniJpZX+fEnr4SjLIxljF9y9/P3dcRHa9+/oEoSd0Y/t+JS9/XFudZrMCdP7fF80edrViFoS+XHwN7kf6kPBT/Ckc9ZQOo9LA+dNl9+PLPsyh19odJrlDZtwcf25KDt85vTpqDBA0Vd2M73jnlX8fWsmBxr0Rg9bB8p+u562+c9qrddsMSYzdRA6X7L3+W3rT1h8xHIJ48BcEK69t/QeXbWivnCowNu0Y8xdHWMn+V1dHa0+3NTe6hJiNOQporKBmdKWrnOvw86cbXrZfZzYBc3ViRmNJ5HpTzaFrE77AEvCfjytKhA19nlZm+U2jFY+yDMND5xubxRp7pQEyRFkuF1qoCm6347Xnugv99/q/hXFBIgziGunsiU67fn7+ArLHGtCTETuQWptEqL/KfF4bNlpQM30VbELqrzUTlqMhPzo2sbtHrAIEZpZnMzakvh++owddEDM3uAwzCxnD97BGT/TUNLrRr/vKTKcDyHsUD69wHpigf0a72KJOyXlSV3p5xw7sMZgbTzfjVXRa8rPjjiL825f4g/J56pAs4sgoXiSr0p4Vvs3EZ22ENUe7XVbHJUjuFyxVZW9W573E43wo9WhFrpIjP4hdSuGygh6EoEktcGCrXCBn3tgEYjZ3J+9mr2RGOnmqtqzZQYpM9VZkGIZd2i/oLy1sCB7pb4uG0WpKw0c6egfYrKj9dsDQSuBGKv4zvt05mkZnm7KOXmGVQUBcOSwBkphU60hyoJlp7BvNWBW9/A96Fu2aAsyrFDU99fyxOMBFz/elWGkFkCAXusn4SO4/0RsC7XYQ+dgwhP4Kzj5E23TfTDHm0PLSI3oG+tcCFtotf9Hjee40UrcACio9AgQucMZoquE4Z+cB8euvG29uvkqXWMZGN6Tm8hnuiSwOmojC+GzCanXfUdrvUf3oiTQz6eOvYKyWVp3nbYSUDUrbJa2CBnSr36uUa
 hA38Kopv
 PtfQSvD4OVfeDmtaThnzYrEr1fezYRtONBY9ln8knP5pX5RH3RovW2Kveb20QFtB4t0oHyeA94+h6Jv8m5EsRs+7qQ+UwUvm16POo1FicczizTzAmbaP9hSpmEw+nbVq5NYjlnjKMhfLwkQ2tvHFYoc5cHTjt4W6EschWVY8zq4xD7Qfx7G8n1MnoI0Xm8GdC30qt+r45gOGFJpxqub5O3J3xslzzr8oCzkioEsVd8rVQIes20xdLEG7+SNJEIpmuXUHX/oSd6rXlzh7YQYIT8wjxZ5qGNMuesnPIMC8qI7IPM88Ko5duTnn7EzAVlCAqRskdGyZgE8UhdNM8lmzFWWxnErx3+oXYodK1Ey5eHxAMhLGgb5e14iIMTOyIYJ0bVL8IsigjP5DzsXmYu2RtbpKfiKlrn9frK4A7TY9t3sD+XDw57tuV5h6bHAskoEuqx/w1fRk37GBca54tP3/kXjwisWcn9NXazQaY5a8UaeoRtrnmkeWLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* syzbot <syzbot+38a879f4a73497f2dfef@syzkaller.appspotmail.com> [260417 05:12]:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    1d51b370a0f8 Merge tag 'jfs-7.1' of github.com:kleikamp/li..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=117dc4ce580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7f207c4b1fbf85a3
> dashboard link: https://syzkaller.appspot.com/bug?extid=38a879f4a73497f2dfef
> compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> 
> Unfortunately, I don't have any reproducer for this issue yet.

... and you won't.  This will work unless we tear aligned unsigned long
writes/reads.

I'm debating marking these as data_race().  Marking them all as
READ_ONCE and this one write as WRITE_ONCE.  It seems overkill for
something that won't happen.

Alternatively, I can move the slot store fast path to need an
allocation, but that's worse.

> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/e08ff8d2b0e5/disk-1d51b370.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/c11d4b098bbf/vmlinux-1d51b370.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/6a4691f32e3d/bzImage-1d51b370.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+38a879f4a73497f2dfef@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KCSAN: data-race in mas_wr_store_entry / mtree_range_walk
> 
> write to 0xffff888104f71d08 of 8 bytes by task 4757 on cpu 0:
>  mas_wr_slot_store lib/maple_tree.c:3232 [inline]
>  mas_wr_store_entry+0x3405/0x5ad0 lib/maple_tree.c:3528
>  mas_store_prealloc+0x43e/0x690 lib/maple_tree.c:4936
>  vma_iter_store_overwrite mm/vma.h:616 [inline]
>  commit_merge+0x6a1/0x720 mm/vma.c:766
>  vma_expand+0x301/0x460 mm/vma.c:1219
>  vma_merge_new_range+0x29c/0x320 mm/vma.c:1112
>  __mmap_region mm/vma.c:2766 [inline]
>  mmap_region+0x1073/0x2110 mm/vma.c:2856
>  do_mmap+0x9b2/0xbd0 mm/mmap.c:560
>  vm_mmap_pgoff+0x183/0x2d0 mm/util.c:581
>  ksys_mmap_pgoff+0xc1/0x310 mm/mmap.c:606
>  x64_sys_call+0x14df/0x3020 arch/x86/include/generated/asm/syscalls_64.h:10
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x12c/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> read to 0xffff888104f71d08 of 8 bytes by task 4759 on cpu 1:
>  mtree_range_walk+0x1a6/0x490 lib/maple_tree.c:2032
>  mas_state_walk lib/maple_tree.c:2952 [inline]
>  mas_walk+0x1cc/0x370 lib/maple_tree.c:4366
>  lock_vma_under_rcu+0xc9/0x210 mm/mmap_lock.c:304
>  do_user_addr_fault+0x232/0x1050 arch/x86/mm/fault.c:1325
>  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
>  exc_page_fault+0x62/0xa0 arch/x86/mm/fault.c:1527
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> 
> value changed: 0x00007f68dc2a5fff -> 0x00007f68dc284fff
> 
> Reported by Kernel Concurrency Sanitizer on:
> CPU: 1 UID: 0 PID: 4759 Comm: syz.5.348 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/18/2026
> ==================================================================
> netlink: 64 bytes leftover after parsing attributes in process `syz.5.348'.
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup

