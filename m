Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CADECCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 10:58:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3BBF8E000F; Mon, 13 Oct 2025 06:58:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F13148E0007; Mon, 13 Oct 2025 06:58:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E01CD8E000F; Mon, 13 Oct 2025 06:58:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CD6878E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 06:58:55 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 823B6119B89
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 10:58:55 +0000 (UTC)
X-FDA: 83992793430.12.7EAE82F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id 309A54000D
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 10:58:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RweENBz1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=cCMYnzCH;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760353132; a=rsa-sha256;
	cv=pass;
	b=IGvPNs+DPRneFRrEuP2rI6O5H/gEK/WKKH0O9Fk+IK2aEJTqbMJrSkmVv9Ii6wE29ozRCX
	PKr2J4djDsHSBOa9OQ+Xq1tG+jXiY2h0O9EYSbh8zmbelMF+0PHlfa0Gatu/qU/C584Ubj
	vTg4v18kZ8W778UhFMtsfsQZuO42WP8=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RweENBz1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=cCMYnzCH;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760353132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7iN7cU8vXXeM+AjQs/2Kb+0WcMmD+bGmEbRLOuFKtJI=;
	b=NR/WTnXXw2rFX11GRHvToZp7ZyEjEwb2bQwasJ83D7Cq+8aKufKTRSVmg77PabyPP6YVYY
	F9HIqQfaGIdnzQF2IsB6E5C9+w29y6oV0CEf/2yw9uAcb8tMXY6G24LdRnb6QCt1cbonzl
	En1WxtkvRWdZjqaDae8/3TTG1FsP57M=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59D7u7Fn013203;
	Mon, 13 Oct 2025 10:58:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=7iN7cU8vXXeM+AjQs/
	2Kb+0WcMmD+bGmEbRLOuFKtJI=; b=RweENBz16JZcsQbhlTw4hUJQDG5NfQw82W
	eTXXuj19Ma1dpxXezMl1yf/vo/3Jrd7EG5rBiZTEYiFIpXYh49jhtoUVBBKMfNJ0
	7Ex2wdR2CXjE6zBkXBO/cv0h+OtLZX3g7saB3ZJkgec8hrbLHla9w5s9RF/QJx5z
	7iEMHlRfIziQNSw/D7UM5vE1jfEFUxIc8XV94T+UnkMn9KnvG7udIG1CLq59geEd
	DC0HrPjnDaHtL34HqQJyQCxtEW0BQO8FTP7Y6uuKlW4Pk91S3Oz8VxXaxCJb37Bg
	GaWPhmm+7Q01o10UdarD0eTJYKu+4eCmA/yNt6CWINfXiLikipHA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qeussybg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Oct 2025 10:58:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59DA1mgg017433;
	Mon, 13 Oct 2025 10:58:47 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013065.outbound.protection.outlook.com [40.93.196.65])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49qdp755kt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Oct 2025 10:58:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n/+xT8aFrFGuNiBFyAISmFdps1+kI2Z0P1dznqIE5umZuK9hDkqCErmn4Ob3qbvqfjJ4VoMLC9EwBzJDR0L+pEPzHuKWC/+iJZRckE8QXjbuGc9RoZVIsCHN1JFWfEsMaZ/2reZKwXp9QrtQkgktZXWHEcq4wajoKoZMZ8XNGlMATjpcbitNdchRUJUKCe7e8f4a6hVufRWPuhq08ymFwWxnw6w8uW403S+jyBT6e23Tqj0xla77AR2xgmcHzcnMqtg07b2hpcvHx0hnRq4uszQnjLqcsbVJL9qOJiNJbe4jkPyxw7fCE1PN4Hd4iRl+i0KSBxfj+6XUYhH5vKy5Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7iN7cU8vXXeM+AjQs/2Kb+0WcMmD+bGmEbRLOuFKtJI=;
 b=Nq2rnT6SS6lXf5c4cUrxIf+GwOrIJQ6S1ERk3LROfpJybXgII85Nn5bV910IVd9yd60zDYEsvnnq5N3zwE/sF3J1mJHzL1PR/oSQjRp/hNakV1A3fJV10QVWwYyb4pIBSfN73kRV0LepSRxoYNZVFC0O1CqDMgT9if9xt7XwsHdk1mB5ps8wr40liu4q/NiSn2KlLOLPVZCzqD0RV2vB9y1XmxGM+7bC9BUtArP/voXEf2omJxL45qm4/mFXG4QOX8Hpf24zPuX1KA1aOjyTsCx0bC6FUxVEmZUi1ROk5ZuHbr6CDkSGWYTyTL+khQdazTR5lcmnEX7SyFj7ekxXtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7iN7cU8vXXeM+AjQs/2Kb+0WcMmD+bGmEbRLOuFKtJI=;
 b=cCMYnzCH0VkAkfs3RTJztEKV4fx9IA6+MpKAZsjfJQl0O2z7hv/PQkvvSN6ZaCRpWc1gDUduuJCA205agc6iJQ6RK2hAR7h8ZtWtQvOGFOooAz0CnzHwr47akK1UBKwiw54XYQaSLUyhiBucpvv8UpStjsmMV0k6/MHg0vqnZbE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ5PPF6998A7572.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7a3) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Mon, 13 Oct
 2025 10:58:13 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9203.009; Mon, 13 Oct 2025
 10:58:13 +0000
Date: Mon, 13 Oct 2025 11:58:11 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: syzbot <syzbot+63859a31071a369082b1@syzkaller.appspotmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@redhat.com,
        dev.jain@arm.com, harry.yoo@oracle.com, hdanton@sina.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, riel@surriel.com,
        syzkaller-bugs@googlegroups.com, vbabka@suse.cz, ziy@nvidia.com
Subject: Re: [syzbot] [mm?] WARNING in try_to_migrate_one (3)
Message-ID: <10f44f4b-f561-4682-b46d-a61174da1347@lucifer.local>
References: <6897b156.050a0220.51d73.0082.GAE@google.com>
 <68e73bee.050a0220.256323.0174.GAE@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68e73bee.050a0220.256323.0174.GAE@google.com>
X-ClientProxiedBy: LNXP265CA0047.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::35) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ5PPF6998A7572:EE_
X-MS-Office365-Filtering-Correlation-Id: 0316071e-3a6e-4fd2-25b3-08de0a4767d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Lfjsot8yqQPgwE2vGcIuzI9xiHGtyg6NJfpSqoE+FFRGl/Y6xt1RRZgzL2bQ?=
 =?us-ascii?Q?M6YoStxCZjx1pbOQhwbQ8EZoKIcZParChR3Z+2S+dC4vw8OQB7/zgk9zrGVs?=
 =?us-ascii?Q?1sOiPzx6UYy3HqwRfNhnlYGpnZ9hIwrSryGTUMVLXgRIDAfWi9oCCKI84wSK?=
 =?us-ascii?Q?P6vmX1jIb82IJ2MOk7XH+NI8Cv2VC8I3sxSOkOG8pRHY7G3RH447XzS8lGhF?=
 =?us-ascii?Q?OodrG8eVhRnXQphvWO4o3Fh3BJsSaJ1XEe64OO5oK2Oc508iv32RFj7IAtQe?=
 =?us-ascii?Q?nCWte0LvOeERfosUWBEMwFhMw0U8gCfwJmmfIN4QYFx4HrsE3BU5J79vPvF9?=
 =?us-ascii?Q?nCWnjUgtQ9ky2j1R18DKT7cfj1qesbOWB+yTgjgjYkvs8yJfsS+mTFn80Cwt?=
 =?us-ascii?Q?lggF2etRbxOFI+XPOrA5y/Yaw/KBqVwsGrBW0B71pQvvqB0YbbMKMehhQQnU?=
 =?us-ascii?Q?DGEzjkGt/lsEliqsBy4kdM6UclnZvMV3P9vQg1aa8fJTH58PfFimbzlQE2gR?=
 =?us-ascii?Q?k3qpoiuTas8i/ZoGkpoO8MyYd2XwLngEgvBtqGa4jHvE5GJhnKCZa/mIffBq?=
 =?us-ascii?Q?Mdpfw4HMUKQ3iqdJNhycm2ukbQuX+5DJ4fLifnOpHEQq5AGKZf8f6hKbf+90?=
 =?us-ascii?Q?P3GVQ3vt6SyiBrvosIVd4eEFZlLOsQ+NgJloiTPt0vBkNe1CTSlKhGYkk6pk?=
 =?us-ascii?Q?8iHP/+GJIF80QEQEaV2PuVMiYMKBAQr+SqLs78FUuRX1bz3dg/V9WmOyZjOT?=
 =?us-ascii?Q?fVa5QwVU/JBA4tRf/KUaccSpW5zqNuzx40Q4glBWs4VFMg7i/T9fQ5rZaPyf?=
 =?us-ascii?Q?/DHGdPE6O4KW08I+7zk95fSIvf6hZ2BpClfai6U45SXNMQ2cdLT9xyELYkG+?=
 =?us-ascii?Q?/tBqgWCC05uxP8QvQqI2B01huzCrHk+0UJMyEnXI2PQXcGlPq0YfodoFyANb?=
 =?us-ascii?Q?vwx2cQ5H/UzStJShOH9SAxOIfLKvdgdLWzUf6LNibhGW1pV/wnrWNjRuzAgz?=
 =?us-ascii?Q?EhT4CRDqJ59GykQjRperH/lFCFpoKk+u5CrW2gzvGjy27+rqqBbTeBf68Ivz?=
 =?us-ascii?Q?DBw34aemoW4PNyda9lqtTmhtX7OF8kApkWQkb6lfZppJqDg0QLgtfIFpjpPa?=
 =?us-ascii?Q?YbhyO5/y6l5AiqD/F2WKFm7CIBeb/zSi9DuPVUDP+uhSSC8Qy8k6BtfqAhku?=
 =?us-ascii?Q?aT7cpRVlGwqV8AHhmyUEBXUGHCCH/hA8DnoahdWDGkazotQcC8e8CPGKsnbp?=
 =?us-ascii?Q?8adr2VaDM+3Chm4kfVzI7u9ekyvV46B+rXBt3givVMIiHWS6no5k7iMJgszN?=
 =?us-ascii?Q?qoFR4vWDRQit1ierqRFRLQLZksrtmFE7+zXYOdrxfv38HqmwQp8srg8/SkEK?=
 =?us-ascii?Q?TcUn6EUhlYGKzGrlH9RridHjAwJBh/OvRkhWgW/XPb4RAzF7vg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XS5Q1sXmtmmYgCkA83NS0wgzMruOMectawq68snvLxJ0prBiachufHY81GWx?=
 =?us-ascii?Q?JrnKNztSjHXdTuQgtL/Z4qNxN0WihyYGc0OABGo4FNKpE/K0RkR263AomSlm?=
 =?us-ascii?Q?idnfGcTfW+BdPyTGB9cki7g1PLdATFrb6vMnaV9t+Lwv1E5n95gQj6kmeLBM?=
 =?us-ascii?Q?4wyoAipKSaM9dbZZNx+1UDWo6hOrEQb4Vyo6mu01TzUCUlgD5gbOlrEfZNG3?=
 =?us-ascii?Q?i/fvde8z8LSyjqcmLwADz3jpxHbPCMHoEYk8j56UksoHCphpai/ye5Yt3Sei?=
 =?us-ascii?Q?ZQqWQEH9NtYuroE3NFcN5/KI5i8OEgJG9QGSKtjjnlFHQqJboGQK6oye4g18?=
 =?us-ascii?Q?cptYz1i+EyUKcHsdkjq9rwUsEbZGkxyV/uePB7ekCR8vX3/Esy6FMYunH9Jo?=
 =?us-ascii?Q?aGLMZ2oGklSd41/xIv6225/FaVFGCv7grR/kPsIjq0wRrl2qqR7emADeztSk?=
 =?us-ascii?Q?bk0JmoeT4BmzIFUPd0YSFu3T9N0XaU6m8oOEWbQlCm2PxF0s7pxWGEAXL/2S?=
 =?us-ascii?Q?wuTvfu0G7Kja1Og2w6fPljSRY8sMOScCYLNQMr6tekrwydv2muF7T90Sb+AG?=
 =?us-ascii?Q?F56e20stBjo5ivyTmP8qYRjci1pBr27sbz78ZiQqNicqIM7Tb7uQaPcPJpiX?=
 =?us-ascii?Q?B+d9fLcK3/hviWZpitxeLwAe4mtNM0Srabz+kusfXwFB9C2y0SrlyWsEc7Vk?=
 =?us-ascii?Q?T/xFhb8gBEBerEjZhXYtOwspnhxi4O55o8TR/mYF34SWOSzJ34uFTa/6SuW+?=
 =?us-ascii?Q?cHMhUR4kkcwSODhYmRf688bWKqn1/5IRavN8MgPjF+oZi/qfIyYGq9dRkWhR?=
 =?us-ascii?Q?7ifA1GiXls2S0u5AYHzZJBAo+RCjNq2CGOTJ7UQtgbpPcCH9Ay4HOXgDbPil?=
 =?us-ascii?Q?PiHbBg8RUM6RJ07jxJHB9Bh+Sqs+7+FDy+CJfehLsNHrfDlZPriEYg2rPsxc?=
 =?us-ascii?Q?UibOUg/4ArOlLVjuKmIS2PE53ScIuWAVn0+xlSdnejCUQDA3xRybYYCNWP0n?=
 =?us-ascii?Q?5JpAy7/WFXTM9+43Ur42v70spYXFhmP7f6ciMOM8wXLrAOoho8X8ZbliwWuz?=
 =?us-ascii?Q?D7PT4bc3y9Z/yC7XpHp84/6LtNTJi43yIjNBmeiwhhErEyW0Ncpf2gL0dX0a?=
 =?us-ascii?Q?x3wxuTkDBB9EpcL6rsdwyeI00l9jC7gsEpb/Zs9m0LR+suGYOWjHJt2rpsYn?=
 =?us-ascii?Q?rEjeDRW9uDp7lkSBBvTzAQEJ83bbybID90OpxUIzHrTh7/ZH9gfHZuQRc3YL?=
 =?us-ascii?Q?QejNf07QA0+DxAuaYdfRgxPJtf3XFNciBKfzS9vKr5W+YTxoXkR+a63TQxs4?=
 =?us-ascii?Q?mkBipb+dKS5CuD8/vo5N2LPH5PTMZ9vINPkY1NEVt+sLgFpirexFxBpeApJd?=
 =?us-ascii?Q?knFfl3wU0omWObwIK102tbKlsFb5Ok4jOy/htcyYqhqakUohSZUktzZUWmQG?=
 =?us-ascii?Q?rFLWA8rzKYIiDe4boeiVxTB6R0qJnFXTUR7/5BzUShnk+T55BPX+fQU/YQ8+?=
 =?us-ascii?Q?7hXkp3GCNqcFVgwNh+Bvi0IOPz6wsqxHmB9HCiepJycBTUheckPqI3aUuKsX?=
 =?us-ascii?Q?naNgNwRVQbMh0zXKfsr8B4svak7Zl/KjJXzkAAtTpHJZUfyhXEt3kXmp/Hun?=
 =?us-ascii?Q?DA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rGcTNaPHj84DduiJl4d2oulc01VlpYM01+AIagJt5TEsiScUcrpyzYBnd/hJmZb3wXj9I3S2qlr5wTfgf/MMzSvWm8/2OW/QrtDMGJ1Bn0UBMLJBpcC5Pm9kj8vkVOB/xZRAbTwOxfMsjI3OiK4i/EDKPoJZUTTrRVbCZdNhSghLtEupFyjKDXhktMhtCZhDSc1i+Rx3mZ4qBs7t6rP2XHv4Qh3mgflmhXJl+Dhq5nShYXwhL6lgiFStcFKLTARIacgb+UIh9/mi8LSHPxgmio1YbSRDz3m49OaCvF2Xb9TuMBd03tFzj4MhGOcOHHmk6kXiId/0qMbYbaIXcHP68ifqZ9S1Nt52PzqKs8hPBDx6mUM/+/b6F+o1sUP58LbPcwyUJ5dS4tDquIeRYHtQ/tOFkZzMvfGKu/pUCIsFME0UbT/4J30Hc5b5sw3juFsU4L2Rrp+DjwLzq3DzPM/snA6SpSgcrTNSgQnhmdo3KZPZcEY2EkGNn5+vVnXuIX4ItUZca2pYdv+gILMtCAksqHfYoBKTprkJTwgPsSEvogPX00N/ZDtkt1DNGmCOSqnU5Haav5k7eQ6rHUIeMIu8U2CEYKVS3V3ZmIWcPaE+Z6Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0316071e-3a6e-4fd2-25b3-08de0a4767d7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2025 10:58:13.4934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B3BNTbVl1RI/s3jVZa8xYyBIPvMe70uINDzu7GMusr5SAgaFyCHGNqu3tM2JrEM2FeBqOBvy2lXFVzaRWFowjthjvSfF881q/CRxg3bzWng=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF6998A7572
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-13_04,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 mlxlogscore=791 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510130050
X-Proofpoint-ORIG-GUID: ML3HjL5gVF4OvUCKIWlCBSHajZGjuNuZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAxNCBTYWx0ZWRfX+51q6coT0CHH
 Q5MKMgU5e7LcdzPUGHK14+XxvlxquGfcproGWBtFhEsWPIUHGtJnnmPKJke7nIs3fsbTXii+UAn
 H38s+qJgve6iLm9ugWbs2t/LGrCBJfnTeT4aQNB+Re/JLS7lEomRWmO9c+fsyBodFRUsHqho6z4
 2g/dWnuEYwL8nUMBlEb6UzAVS/0tb60BKdXgygT78/eeXZeyEC+bvLUQap0T4odcKxdozFPTpne
 whg/wm8nwRd4DKC8OMeVpzeV9i0sPwDHTMycXiWnk3e6K358hYeWV9dtEuJ7f7ODXDrBnMdq86w
 FYHO8mQuWFYuY9WPCoNcJliBzvnNARoxh3EeFFfZRbudkknAvzK7o2hdjuXguhHWroODasPV82s
 d5+774rq+AD8pkyGP7LlXkaKUL/kuw==
X-Authority-Analysis: v=2.4 cv=E7TAZKdl c=1 sm=1 tr=0 ts=68ecdb68 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=edf1wS77AAAA:8 a=oHvirCaBAAAA:8
 a=7CQSdrXTAAAA:8 a=3JAJ2KBZg8Jsz_PuLRcA:9 a=CjuIK1q_8ugA:10
 a=DcSpbTIhAlouE1Uv7lRv:22 a=a-qgeE7W1pNrGK8U0ZQC:22 a=cPQSjfK2_nFv0Q5t_7PE:22
 a=poXaRoVlC6wW9_mwW8W4:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=SsAZrZ5W_gNWK9tOzrEV:22
X-Proofpoint-GUID: ML3HjL5gVF4OvUCKIWlCBSHajZGjuNuZ
X-Stat-Signature: 8r7et9itc59cjexazudceox4mk99xauc
X-Rspamd-Queue-Id: 309A54000D
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760353132-77387
X-HE-Meta: U2FsdGVkX184/rgkK9kf64BkIj2HuN/KTMnHJd3XcRgsnQnR1wbMHKWpZjhae5n1x0KygdoVUyvGmiBKd9qQZMPhwoXqVwm1M9tvgPlWRRvHxf+MBS6KsJbrYbDDzu2syZa39e5w9nUPcXxtlTaf16qVtA7s6sFSCbg3xe9Rq3nZtv/UvMhj1uy9XPoo2PqXIlAzbn6OoC/h/zY0zCc1K5PzCjHWMB7tg+CkZWaELB6bbMBmmc0XzcWP0lCwsbDwxqaSbeOqXG86cKTecbdXiIXWf7N0xA/NhKDJN2sQpVBDUbC1V9klyQQRSv4RoaTgbN4Fp7DphyZtyU3WMD0X3wgBCBd09niV9tYNeW8jjdI/K0vtVbB/vkA//ZNe61TBK+8XaNcd1MTEIcj2uunNnzN2DZjt3lU+rRiQFcECA6GoTUA6vfxpv3uFj7NMRhFQWFeeN5pFzEh1lnG0pWDi6KP7PswHGiENoGvtuRhOET6Q/yvHfpg3rw8Drx47tEqmNawBne+a/7oBYJ6ZDMs09B0eihuTE8DC6i02ud1Ul5IA85nVn/abjtO/wMSNzOKjMf1znUhpeluyM4qBrAJ9YTDBn0eMk0KXF0p8fh2bGtrR14tjOOCh9ayHOoT+Lnlp1H0qwazpYBqfrm0PXoxGQilYCorpTGILPbZlt717af6rr9Ot2YbPZjtOuk20mH4bPQBhher3FTPod1bWEce7uFGLRP519Lk85dRpBq7nFA0ZM6a8+DdSPPqqgs9ISeBwulAmlccxibMfKUxyC0zS+wymdAPuRHclv4TX0JjKYvTMgTbRsdaTFHoYEerJJUyL9EDpfgN0ekCE0PoJFo8AM1dZW23QpvIIjcP6hmBeObM5E8HzC7fUNc+RREtyEIdCjDv/KUmHStHo1e86HBvaz8hRT9Ydd3zT1MBZhBcXk/lTmG9FnW2+dLHWiUsDhCuN8c4YbaenqhdGfCqfcfm
 XyBGV+ZM
 IeQs78PgdYwYLyMnFl8lf0j4fqBV3vxaD78cBzZMncHjU1HGxBmQK8AohL/m+nKx+x43Z2WuFNdkc7M0WBWqsHPBtLh2sSAyBFDqOIqs/GOD2Mzhj2M1Y+V/nH5awREBpMJ6l+HjyE1/LoemUrJDyaGOeqMnXJGq2mV8NevbZYQ7yK/HR8kS8kMgM3WITtpUFDyXwZKzMjPvHJyJkJbrjdaroJzuTG60dB/UVLiZ5zxacdw3IsN2sKSOy3zdUpGYOHBEWridHHZLjW+6REV29DtGZbuAXnRZXJDCD1SrbgOWA5StGHn65ENDzlByjdF4CAxoVZ/OsySYAN0h1GnipTQDUsz9xgN+Q/LDG9x6XWIX+SwsFyPkl49u8/uCGJmqRMdbmzX8TMz+CfdmVEVRFvvlGBdFUMmXV8oHF/gvzvD5njwwzLN6hE7L0vJKfPlMzufhNqPO4PiACRj4fpMPaSPnbANXrp7dHIEq1pVYyzzDU7mNjZlyOviq8HCKEaOTZ425gBF7NSNk2QrzGeBYq66WqqDU2zFQ4OTGH/LIUnU9PD9pmJ2YgIsGeeVIYWUT1tPOnwcurBd/AYeEeTHFYm0nJ01IF2CLWitxQ3MxL8tOcEsa3MEWjJ9S/8w420DAZ0jELheibA2DdNcMPgNsZlSEfGwhq3XLoJWyVd/5F+WkXD3n8HV9/sIcuQ5CkLmYHA4EC7TNk8EqNxwPxXPXfM8tzfOtNZUo3GMxpwjIGXVV2bOQwWW9bvr95cIOJp1SrlXt5sanhoZ8W3u3xWTQR/R5vrg/lN/Ixlk2EzHCWmLPTlJhuhoWst+6L1ycsEoRqNzVia/6FxkugFGU/PwysWqQD1GTKhGqbMJu6zhrZVxcEx7Ym35ZTWLBzOr5tmmUhllbp6ggRuSE/4kfCBRPAqmowI7Ykz9m4qouwEzSZGDibfR1azSNHy1+g9UFP3Uvk42R+q7FOgCs+6ta83NGlA43jK13Y
 FnesGqFV
 6iLFdG8kEVwdAOKqnPxB+YNSE8mX9fnhZrSwF4+E2sPXzxO+st7RRpLzXYCXy7V0pY+ZmrfB9lajKOZKDUcm59orSv3RD19ep5hrDH1iEXoOkesRVZr5/0rss9yq47xd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 08, 2025 at 09:37:02PM -0700, syzbot wrote:
> syzbot suspects this issue was fixed by commit:
>
> commit cf1b80dc31a1137b8b4568c138b453bf7453204a
> Author: Dev Jain <dev.jain@arm.com>
> Date:   Wed Aug 6 14:56:11 2025 +0000
>
>     mm: pass page directly instead of using folio_page
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11f121e2580000
> start commit:   0227b49b5027 Merge tag 'gpio-updates-for-v6.17-rc1-part2' ..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=2ae1da3a7f4a6ba4
> dashboard link: https://syzkaller.appspot.com/bug?extid=63859a31071a369082b1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=117c72f0580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17ab7ea2580000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: mm: pass page directly instead of using folio_page

Indeed, as discussed in my initial reply + confirmed by syzbot test this does
seem to be it :)

Therefore:

#syz fix: mm: pass page directly instead of using folio_page

>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

