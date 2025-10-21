Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C6DECCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 09:15:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E85BC8E0018; Tue, 21 Oct 2025 05:15:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E360F8E0002; Tue, 21 Oct 2025 05:15:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD7A88E0018; Tue, 21 Oct 2025 05:15:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B724B8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:15:03 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 78BDCC0454
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:15:03 +0000 (UTC)
X-FDA: 84021562086.17.57092FF
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 178AF180006
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:14:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=sYh7F+zU;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iIiBjFn8;
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761038100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+rMmH3JkBeGbQEy+FH13CvfESIb5WJ99OFTnzNPiFtA=;
	b=vg1p50AtdmUG977aNeBAl1yoxlb1I4RopVqKqYZTzI4AcyALeUzT7hsNtULhhbm3si/Gg9
	14uZQO7ZC1t3EoeZXJIATQijuIXI02YQZHkUjnNEMYvLDvSGTiGD56BAVYrW51jwgFDtql
	Jb2l2z15CDhIdT1DgWUemoGsLkDfh3Q=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=sYh7F+zU;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iIiBjFn8;
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761038100; a=rsa-sha256;
	cv=pass;
	b=XA68/AYjx+D5HnGsiYhXhIvDHiPZUSKKuSY28MAmOoeIYwB6ofvx7RWH02GUXXfPEnx4I2
	xFlv4I9WJqGmtblimtUDp850nW9XkTrH3wyh+FRYVX+2A86qQacXWqu5QVvMtI4tad+eRO
	kyZhphjkr1q3QXQ2E0+F1kdgibAauDs=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59L7uNVo005216;
	Tue, 21 Oct 2025 09:14:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=+rMmH3JkBeGbQEy+FH
	13CvfESIb5WJ99OFTnzNPiFtA=; b=sYh7F+zU/F+wJf/n0PFhwXz1iYQ6y9kfvn
	YN9Bli1bxQY13RgrtQY+H4Ht7wlWMMGmrfYpQaWabdunnn5HhL0YMt6yQLN3t6y1
	8P/CSiV4Zdh3+TCaWmCMlf5IPyxjJe+cpm9EQJcQIX/9WdfLblCvUcD8UBuN4ctM
	NgVqr52/IGdziSSDFHXBNiLcCckJVOy70sMeFIuTbhR3apK3YtZLZuFbCcGO7zxK
	acjN1xVVse4B6pdKy+NQ8+wrxaFOhi1hDMa9c+/djymW6AZnW3PjKGDWGE0dFiiH
	njOey0TRHW9dLD8cv5sN7VAs/DRiSgSU9wdirga2Mxz3quJlOJ3A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v2ypvff9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 09:14:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59L91IOs013679;
	Tue, 21 Oct 2025 09:14:50 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010025.outbound.protection.outlook.com [52.101.193.25])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bbmwkb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 09:14:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jTsL3t+ZldZ0tWYlpiOPfPJnJ+Py82BeRLT24bdV4ma6AGVBDeP/nwmyNylOGs/g8yDQlJGoDETl/diKWI8HpE3SgJeV9mL9LGPjwnYShiWICNWISDKO5dpiCMTvOQ+qpdZ8SG8CYPXBdwVKK2EfLy7/ciekr5AgKo8n00L8unBR36O46AqHmOFkNQHk48ZXc2iEyTyExVH/ndaE1/ycX2E+YYMmUmfNXuJoEDNWGl3PjqKKUGt4ERhNj6yu9adWtxVTfHdvWDAqc1zJKv/bNIMpMehhfPF92BP2E5uikPVbSGmG/Ex8hdfp1glToQOFs1I1XDIThzidAv4FH2pisQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+rMmH3JkBeGbQEy+FH13CvfESIb5WJ99OFTnzNPiFtA=;
 b=Xr5UpDmNyzMNzVzIdJcmEntKuhmNwsvYqKPY/WklAC4Fuu13QSxvK5cU+LqKApQ63pvo5ziwyVF4q6zgUv6aXaiPtxAOxrgsiXYI+1DK46PvpNuEteYs480zvmcrJCHtbO/AHqn7p4bE5f/aaduHvWEHBiBG4E/nWAmlQcdi210ILqbM9c1Nnd3+A2Ll3Qt2B4A+G4Ck8YZUW0WkYHtDqXu8D703uKNhxFEn4BPIitpdaoYdrq+o7x0FTDlVsB+wi2BL0A0ztoouA9rbTg8K1qpeJI9pRkCH+iC6BMWW9ssmouTG2CcE7nLvaH9Cl+4jNac6PkFLRl4geGKy/82HAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+rMmH3JkBeGbQEy+FH13CvfESIb5WJ99OFTnzNPiFtA=;
 b=iIiBjFn8WASJ8NT2w3YW1F0By+c73jqcVq8gi3laRWkUZLi2TBSn2xPaw/qNyjX4QYzBFhFCNdGkBOBpF6ueDXKhF2WWmfDcPGdJ6F0NrR4wpbpLiY7IodYN54oAFj8+EUZB8MRteZmLqVvHMNhhPI6K7qcGa0F+syPqxwdjPbc=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB8079.namprd10.prod.outlook.com (2603:10b6:8:1f5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Tue, 21 Oct
 2025 09:14:48 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.016; Tue, 21 Oct 2025
 09:14:48 +0000
Date: Tue, 21 Oct 2025 10:14:46 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Zhen Ni <zhen.ni@easystack.cn>
Cc: akpm@linux-foundation.org, david@redhat.com, Liam.Howlett@oracle.com,
        vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: Refactor vm_mixed_ok() for more maintainable
Message-ID: <abd79c61-8782-442e-b2e5-d3019a633ad3@lucifer.local>
References: <20251021085328.1900589-1-zhen.ni@easystack.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021085328.1900589-1-zhen.ni@easystack.cn>
X-ClientProxiedBy: LO6P265CA0005.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:339::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB8079:EE_
X-MS-Office365-Filtering-Correlation-Id: eaf9fed9-f6de-4d0e-ee0d-08de1082487b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?v0tR1PfrhnYcPiM/vE+iucx8jWjuFUjX+rCIHTtglc+L4QtMaCgribxAJ6nW?=
 =?us-ascii?Q?CV6DoSr1JBH3GVACmcAnWrC+r62MnqqcgoO0QmFOQAF4XAOxI8V/mEzmXwjU?=
 =?us-ascii?Q?BII5p57YgKdOyY81drJXx30x9LW79cWXkAnMQ4eCCwwzCcWZmC4xFP6TpoZk?=
 =?us-ascii?Q?ek2pswoXdc080jjIHQVuk5FE0esQGPT7KvZ9yEpDpBAJYGjd8a2mlpL3C1VM?=
 =?us-ascii?Q?4x+cc4RWYir3WlwDCYEvgBnbwPXsNjDjjOzcSvDaiXpTbbVM5yp0AkbHVu79?=
 =?us-ascii?Q?fp0ctrcPXCeKF3DialSFTtcyyLi3dnR0XvT08sEmlpSYjSjBPLSLuASosbS+?=
 =?us-ascii?Q?1ZrGt84EfEOTlngq0lqUN3WHWFMFG2/MtTBPSW3RGE2OV9JMM3Yz8PFdwQVV?=
 =?us-ascii?Q?7YoCCi27piCw707eJCTURyklSZXYm4we6oVfd0MSFAclyt8vHItZ0oyhE/qg?=
 =?us-ascii?Q?ErLVZLyFQfr/t3iuVIKEhz94lEii4R2mQyi+DaIxppz3FW0tYPyQL6zAGAPf?=
 =?us-ascii?Q?0F7Q66gmoZcSTsdWcP9wfzSlxhBa5Zb//2GVugHh5Xc2zxSIhgBHvJSh2/U6?=
 =?us-ascii?Q?oya6Ie61wqvJsVEXulhUhvXqLmT+/5hcZtfmxOph3/D0HADqB9DDBmpj2rpu?=
 =?us-ascii?Q?jNx9pJgk68XrHnuZfJsdjXO2UzgoCDv2WPYoBduRMLiYGsoY7uSvonwPNZIG?=
 =?us-ascii?Q?ENuJEzAJb+uC+PmDFFwuGYAeDCIzVZC2xTSYSdQInO7wYQXryGilLYuawiO1?=
 =?us-ascii?Q?CGBz+NOcwE3VnXvmk0RgIraXLrILutApIxwOh0/4e83STNFPmMuSpLOLmV4T?=
 =?us-ascii?Q?qxAYXAVaerYUTNXlt8s8rH02fbmTeF5T2EF6XrBreYvI+r3A9B84BSrgNeMr?=
 =?us-ascii?Q?Fc6pJ4Ajf3aszd6iSql/PU1XwZdF9tYBw/cMtxt8tN5WBLHTOoiZeaYK9Qvm?=
 =?us-ascii?Q?1j9LUtSBfXjRY9cWknNW8YZmKF66ECndJ0vryD81XzGI9oelzyIGq0CbsxMH?=
 =?us-ascii?Q?AdTuXpI261kJvM67mdIfXJUnRzYNqt2mUS0YAZ6yuIVCauyHWu6t7U2ByYtq?=
 =?us-ascii?Q?tsS0XeuI93FR/UsPJ/jUBJEJe2X8q0iGAKTLsocnU7JV04sciJ2as/bifC1z?=
 =?us-ascii?Q?uwtO65r7HiY0AUK/FHJwccyi5vK7h2X0+KpUmgZOK29teK7XMT29d8/vbCr9?=
 =?us-ascii?Q?pkw/mIAAMGS48/V7hOKK5Lc96ICs3GvEtYNZuBOLsR9ao6LYHbBKQntgdNKX?=
 =?us-ascii?Q?93LiiaIkyVvPqUnQz6ayH0GfCRQuwWaMdTtseK1l2y9yNmBuimCfyfsoAxU9?=
 =?us-ascii?Q?NwfFSnsantUl0JTpUxPw5p+ZmOQ3j2s1iSCYsNH2PW3ZqOkHVE1nmTHpf0z8?=
 =?us-ascii?Q?p51PHZPTwhCoh1Urdkh1/mDiss37EpKbPpjCIww1kYUZh1zzpUYDtKP/jE8s?=
 =?us-ascii?Q?vhMXj5o1P82v31w+h3SwnRxK/SLhvFYw?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XF8Z4bfvOoORtwLMccczbOUwpyZulwhVLS0YPu1tWevqriM1d0iY1wi2p2D8?=
 =?us-ascii?Q?Vqwq55BinVwIYJfTkszJ+OO6+7lRm4+OFVTCivx8sHYW9qiIOWTDAM5XQ5dF?=
 =?us-ascii?Q?e/ZUW4YNRp0E+PnbM0PqacEtx8fWTcV3VTuXp780f3DCp/sS/HzWjV0qSVhd?=
 =?us-ascii?Q?Hlbudmu7wQfZOF1Dj5R8/3h4h/OZ40HzL3wRR+1jYoywgUEXmxYddNaAAHAc?=
 =?us-ascii?Q?ErhX6lyuCoUHDNTGjMFh8yysCsQDXgOz4qIeMfYv2l+s8LKyzHWHgx1uMgf/?=
 =?us-ascii?Q?suE8yMb3SzJTliOTJMyefZbm+waUTeIyXCtzhWYuJ3FpffwVqkhh3QxBDyOH?=
 =?us-ascii?Q?SRr5KhU3KYsA9BH0Lsmyk7kRLgH+/loyqQ0FghStlLcs/AnovGXTuT+9LPAv?=
 =?us-ascii?Q?8WxzSlfMvUCDLujNIf8synSSslx6uZth60KXq77jJvVaDbfk+ev1rtGX95mP?=
 =?us-ascii?Q?IYU+vqqM/MEbBSp8n+DjzfIZu52dVvjqGzVCvbYkVlp7nnGm6MuQ1dpxtZwq?=
 =?us-ascii?Q?t0a1PJtj7WJWBs3N6tSuctXQQJc9j3XoZMeGkwqT1/GQEO7NuvfHXq/sqoHX?=
 =?us-ascii?Q?A/hNz3+A507wKgxSrDam1S2LlRQI/3i+yh0HL7e0Q9My8CYyRuXa8S+BUY88?=
 =?us-ascii?Q?ayH1KWijlaT8s+CI7EmGLtqd+jWtfw8S3QaHW9bo59ohNDymjYHTosuMVlR8?=
 =?us-ascii?Q?JxY124tTiKAF6NDje7f9T0gyvJ/Qa0mlj2zUqPVFmlfkfeiAov+LVcFBq30S?=
 =?us-ascii?Q?3JGsytepBDWIy6OKsjbBxRoquSMYVdWgOHPYhVt2e8BnAp6bHPBKt3xYHzHr?=
 =?us-ascii?Q?vgi/xw3u8SW50v4uMZr0WBKONSM2NlBbcaPzBJjNzCzQVwvuaTePV7HZFwrp?=
 =?us-ascii?Q?nP2KOANukEgufQkuoU/c1SeFZxQYi42U5F3+iCx9vYLuA9gbQltWyuTo3CFq?=
 =?us-ascii?Q?S2SMxqUP4J5XXCKUhqSd3lLzmPaN0trGaoC0vFnHrqiOL2jIvg8OHMaGJinv?=
 =?us-ascii?Q?q8NXPzOteXc+oVvQUSa2Y2C39scMivUuTAfySDay5QIxEnpkzqcRZqCQQ7hZ?=
 =?us-ascii?Q?Vuw3CXlw9FHOExn4g3iFu/jtMlXGUIc6a3u9EOCRjuv+WymP+sNvU/KwPV+a?=
 =?us-ascii?Q?pNNQNSiWxe1Kx0pPZ392KYjYOp+TvShj6v+wafamaU1Y+zfW7bToR7t2pfRJ?=
 =?us-ascii?Q?wlgbonngX7Nt6SfVbvo+MsVnaWRnif9+ixparP7DTlip1A4g2/UKucUJSGqV?=
 =?us-ascii?Q?b/mGy+5cpPGU31Da4gPjCBejbqLYImOugMOe/Amj5LVTbiOMH28q8SXepD+r?=
 =?us-ascii?Q?1zslqSwWquFy8dnqB/svjoqfTDDBiTdfbJ2r1uZ6BSl1e1yEJF7KRFnLFf56?=
 =?us-ascii?Q?b1i8gMl7oxIvQ4qPN6L//2fSMn+oS3UEqu4oA5SwjziiOeQ47Ntdm61eTI8a?=
 =?us-ascii?Q?5UIUD18fYct3vHtNNYmZrDHIn7slhR9ndQdK7q9lMO4mAGltTaGj3zlQAN0W?=
 =?us-ascii?Q?wk0Sn56ZPP/9UM/4+IsjGBWObYuO5i3vW3qtnVeZYu84WOdNTIGA6h5VPlMv?=
 =?us-ascii?Q?BWJgKwctbMKUP89NtvgO2k8+6qBPCa84p0aqLLyCJgoQEFiAb1xDasqO/g8D?=
 =?us-ascii?Q?+Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MnArFkspUpTomFIhx63LI6QKHzEWSEr+aNlNkY84h2vtgB/WDDxuZhorRA0Gp0iZZgpPfWVUJT6XAQC0n+erlF3li5qgM76H65eQpQ7qAghsK5JoJHGjaJQ3QX3RKWwPggFxJkjUS1YZsdh2XV+2r/+dUBMdKCJOSicnQb5oX6dfZeI97T1IqpHvMSG/H4VSkjiLT7gJE3oqUV81I6yiEwBPxRgAVmaCSjr2PMDw7Js6E8IMgQKvxfzqGg5qrCqL3knSvtCjZiDwHvPt6i+2ptQCpslkSl2apsM8Vyd2bFKqXi1Wmve1CbmFeew51lioyMgzZhmbWGvLdL0HkVMry6ULmxxqmNbwYK1+4voBiYBq5qsxDQj9sAALyAEhosigjJybTiBjtavpKrG/O2hOMf9x8dr6htwftCBKJtPZxY3jsgPQg4hBvoFNaBKom/KUpyhLiW4rFVMmH0gbZnVL+AwE2RUI4HPIgUoxos7wpNsV22F7VxmunA1OvX8LFiDDkOTgu8Ex1EbzT1kCdva6L2Z9amtGS9LV6mMUrWvNXLH90PLH2fvhkcONVQQPNzWg/8DGtJQbsscbRBi6XC/QXhtQ0KdOjmLWHYVrYpgFYxs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eaf9fed9-f6de-4d0e-ee0d-08de1082487b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 09:14:48.1739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sdLAXhhDs1Ej+yKb0jbexjlUACDXZHlYU72OT8sQ5D7+InHXAzQsB/+2IT3+FFCkWkjrA4qnWiyqIXovCFe52JhU9uMX1FnmqXDga94MRoE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8079
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_07,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=628 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510210072
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMyBTYWx0ZWRfX3LY0jJyoxnsi
 vw7QyMAFHiQ5hGBYU7RtIYY3L56pyxLfDybjM9FoMXEgGupDC9lTGPnc1A2Nfn7yjI5QOUzCjIf
 N3Mg73bTjAy0hjpBAi2gevFjBsFxKzThlZkP/F+88/JRpebXBaLJcQMPsGp3jBQtBYLHEtxE/Yj
 d4oswxcKBXDIFZel7mhW5MKILHGm1YXKcduisriC07Y2H1EkA6BUe7Elln3opq9Wce9Xplhd4tU
 sUnm6XFcRK/XJrdY7HWVNXQs5h72VL/0UjC6JpHzMkdyewRmLIFJKPWCEsPoaS2g0EIp45fMTEX
 HpS5GcttUFfW+6O6v2rZcOgC5krBekTlWdzlRfO7jPLQbQIu2L3dxrJ4jPDh9lZedOmfCK0Xpd4
 lYY4KLuT86cXNQCOt2hLRQ4vvMrNdA==
X-Proofpoint-GUID: 2IOgyMv6PCQ235JRJDeohuuwj0CVyF-B
X-Authority-Analysis: v=2.4 cv=Db8aa/tW c=1 sm=1 tr=0 ts=68f74f0b b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=WTXcmQi-IvHeRJ-uMDAA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: 2IOgyMv6PCQ235JRJDeohuuwj0CVyF-B
X-Rspamd-Queue-Id: 178AF180006
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: atmik6u8obtza6zpt7hkzbahkngnn6yz
X-HE-Tag: 1761038099-166771
X-HE-Meta: U2FsdGVkX1+h7x+X6+E7dH2zpPYkND6D98ePmj1U+uWRTnAZ5NU4viz2UK87PMgH0yDKP+1DSl35QD9FLRJJnnloMaXMVO8xaXzctk/G2C+Wv+CLlXkbPaRCBoZRM0+z8Y3p2gfN0yQzmw4t4Gz6O21ntZ3CV2wnApnkh/BsNUkG9cGrKNSeKjHj9Ds1isN8Z60PHqYeap673TfraAWdCYgaAdwqbcjIjGIKikha8PKRERrD6cHNhJkKWVgnhIzNpZSLhsqgdKz4MJaIpjAvCFUAL6nk9VSZbEEZYctAc1WqgAB4dhl4xAUxbn5Q8HW9jISrzk7tqpwOxKUmS3fcVMFhBRTEi1VXBx+ocjE9y1Dso1h+daTYfNlJi/UA1MGVittUF02q8bF5MShdTrEVuyihy+PezcMkS8onrmSkaAFEWzwz731w/Fcty2GyZvqQfjCr+lPD/C1Yshf1rT3VrA7r2kX4ZyyUkl9jlBmYG2T/l+2nImzcDJjVfcIkeqE77kk1pg9PyVHK3+Kv7Kz8Zw0bCDh+LtrxL1eHS4wlOhWmf6n4tEEdD61tIfMk+oCBmgJ8+UbdG0/F6+q4gyPdyBsKut79mEDrv8vRBeuddEq9Oab6JT3r73sjfEMhiTor1eYmXX8Pup6IUeHv1zpYWH8SMeyJI8c+9YeavljWRJ1TdeGk9Z/sj2Li7vPDkWAbHzbrYb5sjzewhau7QVn/je6C1O/GNzS/G/p3bB7+Hb8CmLvcJ3EYYPJkOyiLI4gwA7EkOXnxuZUeS5GvQLcQ70Pzvd0T3YwFx85nW4EkNwwnVenvd6GLrw51WRVScAqf+NlHpuhQjhRzL1nds5hmp/wHO1jdN4d2AKPJhdwzliS/gLDzf1wphtyeOBxFWzjxxHYylhT/Hs4Mw0VjQ0+0ISa7X4KfAexyE+7kI/ptrPs02PKstnev8Ux9Cs/ES7K0zMPTX70s19ANb3MapVd
 Pfa467cz
 uTMdiTq5f4WSdo9UP0d8grYRcMYxa11qKbpFwhiR5goBM7ouHKS+ZnweC/kik87tyO2Iy1pKHAheZDmfE6Tye72CvxtvBU0S4gyzng8+kXRX9Bz3TgSCQSTZprWEol7nkTqJV2PxxtvQ/k+hRbNJCfOTT5KS028z2YtcIsJYnNgcMT7ShG7mU0NzYE26pGdyCwhfi1wuQAV3c3A0f4qv+Dqk9739CkwPbqB3tCIMutk4QVAbk2BO7GyGhbl8S68VBhACbiqnGjwQGL/VOK/kZQ7C5QzAOnzL4w5ZtFZymXuFFppYE+8a7/VFIqof5DEjbfLPyORHMOhn3bEz1nDHGVX/BFuAcIL0VKjbCjCvqfY6urCdIGuWbk0fPIbFIUfEhRgBj+FTTLyFFnXuvCi4GSkHgtIxaAsz3E3hYFePHB59TJWYDg6QJq/DgMc94qfliRbZqmk4OCweo8CmWAHrePY9bQkduFOm6jbiju9jfyb2qJjQcOVS8LsxKL72REH0wJGjUti+W6YwQrh8ZF6DACg8GTu87BuTZ1jVUrSpCldeHWhWWH7iehitYj4+9MwGf3xlnZ4p3aRpiZQue8arBiCAGIIq5P7u4pbPPQzSPVuJa0rT66dKonCtJjpFTLsewF9DzbKCvGJCn+JMM/D4sJj+JtXNxCv2Aal+T
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 04:53:28PM +0800, Zhen Ni wrote:
> Restructure the function without altering its logic:
> - Check the VM_MIXEDMAP flag first as a fast path.
> - Consolidate the zero page handling logic into a single, dedicated
> block.
>
> These changes improve code organization and maintainability.
>
> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>

The below is just incorrect and you're making the function _harder_ to read
not easier.

> ---
>  mm/memory.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 74b45e258323..4f882c58dbc2 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2706,14 +2706,17 @@ EXPORT_SYMBOL(vmf_insert_pfn);
>  static bool vm_mixed_ok(struct vm_area_struct *vma, unsigned long pfn,
>  			bool mkwrite)
>  {
> -	if (unlikely(is_zero_pfn(pfn)) &&
> -	    (mkwrite || !vm_mixed_zeropage_allowed(vma)))
> -		return false;
>  	/* these checks mirror the abort conditions in vm_normal_page */
>  	if (vma->vm_flags & VM_MIXEDMAP)
>  		return true;

You're changing the logic now? This is incorrect? If the conditions you removed
are true but also vma->vm_flags & VM_MIXEDMAP is true you now return true rather
than false?

> -	if (is_zero_pfn(pfn))
> +	if (unlikely(is_zero_pfn(pfn))) {
> +		/* Zero pages can only be mapped read-only and if VMA
> +		 * allows them.
> +		 */

We don't start comments with /* xxxx, we do:

/*
 * Zero pages ...
 */

> +		if (mkwrite || !vm_mixed_zeropage_allowed(vma))
> +			return false;

Yeah this is just wrong. Plus you're now inserting an additional level of
indentation?

>  		return true;
> +	}
>  	return false;
>  }
>
> --
> 2.20.1
>
>

