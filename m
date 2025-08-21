Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8DA7CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 15:34:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC0E16B00BA; Thu, 21 Aug 2025 11:34:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E987B6B00BB; Thu, 21 Aug 2025 11:34:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D60866B00BC; Thu, 21 Aug 2025 11:34:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BF3016B00BA
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:34:03 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6829613883B
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 15:34:03 +0000 (UTC)
X-FDA: 83801160366.02.CA0410B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id CD283100011
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 15:33:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bEbCmtnR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=NYb1a1SO;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755790440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YPO/bAeK3sKh9KgQHf/vsLfTQli6c5jkhfpfyyEb2fE=;
	b=Sni+q3TMw1BL9zVZuXmiT5fKJqZlEKu5b1FnWiGhLXC4hb5LAdCbuZyGO82pt4bzwZiKKk
	y0MvA7fddHmegMxYIlhtKTVToTrVUq6xLAqzcUteQMngiCv9l0W0mnqoViTRpI42wwwrq9
	XRAkwH1+ddxH720B/CbrEOwwadZfQR8=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bEbCmtnR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=NYb1a1SO;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755790440; a=rsa-sha256;
	cv=pass;
	b=LgH+yvxW1XrZoY+Qf4zHeH7KFK5RfSNzvYDA4IUz//7uR9LYAB/f3ygRanSIHOGw7F0gPK
	BE5WIYVrGjEJVpyHG/lDRIlAAq0n85BYn4UdSSMioQZOGMK3kkAmoHhwrMr60WZuVgCh88
	xhaw4j0AJQ2LtojoI+aqs1b6ZrECLJs=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57LDx1XD032367;
	Thu, 21 Aug 2025 15:33:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=YPO/bAeK3sKh9KgQHf
	/vsLfTQli6c5jkhfpfyyEb2fE=; b=bEbCmtnR4CFa0KEmQWFvbwLeHuEcthij9I
	zYvqsXd4ePRTjFSNIA/2ox39k5UYA9XdE7aG0/QZk6ZjZnm70uejSut27n/9MIcq
	72MPecUsoprt7ahk1fpXjmoCktYF1Am3eZTu6Oy0psRoZ5W3Uj3tX7TyGiuRB+yj
	xFCMDeWkp2WMS5NsbG4l8RZApVCgmj/+r+l/bU+cVgzHH10KsMuiXIb9023hZifq
	tl/HbtGh3HyJdRkYlNB1slEEWH4wHuQiViTpwMhxi/81zIMpcRmhXlpt86kP2RNZ
	z+p+BDNZI74M64I8HstYhKXR0FNk4756ptfAa8oARR7AfkrOzf5w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0ttkneb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Aug 2025 15:33:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57LE1ksf030119;
	Thu, 21 Aug 2025 15:33:51 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04on2041.outbound.protection.outlook.com [40.107.101.41])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48my3vhhjq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Aug 2025 15:33:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gob/Z0PmpQ4dFm3qTgDGVYuUpvtd9sdf0jp+nAwqzaORlOcIxGCeDlBwfopPJ7hxWITpNKHoPbUGqB/DI7I4rMROownOD4wEZeyxGF9O1liLujQLmMGxeF+sT3VKnP1BXKV0iihSUi7IddZVEzVFEAK6np/5sKJSjbiGZYOe8+/KbRYkZLZBEpwTBRSEsdjGacsyFST2Rr5eVHZiFCN203s8hao+aSGJhRZB0o4yBWqcCqz5mWJe7CmEHCEGRgYSeo55NYhNjdQDLjW+4kScnHGhsDM9oCnb6zDKl25PC+ID1/zKYb46xArTzZe6kYfNUhHMGR88f6mMM/k8Q9FhOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YPO/bAeK3sKh9KgQHf/vsLfTQli6c5jkhfpfyyEb2fE=;
 b=ZBg5dFgGAwCfYd+un2ckwZqHZ4r4P8k/3cGibmAzA9QJSU/iLsZHFlSm+Lg+AVrlIPjFHfvfjpPuC4heUTrIPP/37nxTEL1yxXNLbRcBtj2ckcSnehdU0ZD1wu3KRs8sX3uMfWWZcZ3ZNiZowudvUr9c5kw1/I5pejXskZYbZvutroHCNvkUUD93RMa6sihvW0CHh+Nw/2QDHxAYKeVz8SDgSb6A5XVe4DzFCsunm/Gs5lIq1RNm0QgWf2HfB6gLUhW8R57iHbkgO6q/+K3IhA24EbVs4oWFY8NPzHnJVc+B6y8uLvR7sz1/509Qi2smdQvHMclLIekqNdiXPBKgHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YPO/bAeK3sKh9KgQHf/vsLfTQli6c5jkhfpfyyEb2fE=;
 b=NYb1a1SOkE4jhgRF7X+4e2Tv6/zHxJTsjo1r7XRPFYVX1GWupM8E/5xySGRdd3uphSNSTXxfQ3r9zIwyHx6sPBIcJniTeXVKlGZhNI/yA/fag2wZy06qwYtc77FNWZrW/Oad1FI7c4d9+j4/MuMu+9P652kDlDdf3PBgRqsqH9U=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB6895.namprd10.prod.outlook.com (2603:10b6:8:131::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Thu, 21 Aug
 2025 15:33:47 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.024; Thu, 21 Aug 2025
 15:33:46 +0000
Date: Thu, 21 Aug 2025 16:33:42 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Usama Arif <usamaarif642@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@redhat.com,
        linux-mm@kvack.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
        dev.jain@arm.com, baohua@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/huge_memory: remove enforce_sysfs from
 __thp_vma_allowable_orders
Message-ID: <f40f4918-77b9-4be7-b09f-429040bfcc4e@lucifer.local>
References: <20250821150038.2025521-1-usamaarif642@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250821150038.2025521-1-usamaarif642@gmail.com>
X-ClientProxiedBy: MM0P280CA0026.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:a::25) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB6895:EE_
X-MS-Office365-Filtering-Correlation-Id: 367a9547-dd82-49f6-6b75-08dde0c81e40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HkvDSNYQx4hIs/mKQ5+T1XE+VIRerlQe0y57zP/Ap03CSX7z2QXXe7eWbf3a?=
 =?us-ascii?Q?XiBJloe58XO90b7ycbAmG+P7n/dPLn0xRmNzZAysjp2Wo1mVJnXJIBDALgQk?=
 =?us-ascii?Q?k6xqFMvNt6/LG+MO+B4vblBG9RcpTv5X76vZ1SopclpcoUeVW33qJWEBRRc+?=
 =?us-ascii?Q?Dq1XpjeqVc6t2J5eRa1Km2HgIrmc6hbLOoq131E8I3kDrZ9fK1nSdFLeWDXT?=
 =?us-ascii?Q?Ug65vpfdI8zFCuNPn9xAdiJsLwGEJQL2dPRVHwyDoRCrCvxXEWSLOU1c/h+s?=
 =?us-ascii?Q?I/Bwvk4EcYYqXj3VdoWmUbQGoE0ZrvJIQh9F3NkmERp9w04x25ZDA//hnTGg?=
 =?us-ascii?Q?o709WBZI29I4kyAOzJlxPg5U+q7tvjtQF/NlP8alwZlfQA4aQvTydGFcDs8m?=
 =?us-ascii?Q?NEGdkXeMmt1p9tfAOH8F5FO3l39kOCCIGbAcQrJPPDuPPTMFzSYSXe26iJzB?=
 =?us-ascii?Q?BSEjvMxfGr/p6PEl8vecLARdMRDKySJrZfSwcaJ57ZNTDaexvA/4j+jB5wUk?=
 =?us-ascii?Q?IUKJQD4aXG0L1Rvq5wVHtuz2bDGgAFrWYEpTtCbNtPbgxzG5zQ7bKeFJs00e?=
 =?us-ascii?Q?jtFApR87XXXOAIqwigWt9WrAROoDfS0C1bCtOHks7vXSlge2XeB/8S3PZIWk?=
 =?us-ascii?Q?LWGNcAOEfKSWcnfxa04N2B9y+fxunbDm101O16WP7hN43xzX5DCIhcOoZzmR?=
 =?us-ascii?Q?q9SRtwE5+jKqVxKKvNyFwe1a0Z8VKD7zl66CPZK2K0oRqS/TlPb6AjxSRM+4?=
 =?us-ascii?Q?sFs8RA9caAi77DZ8pG+H/4QRNWdiI807YsVYTg4U/Nlr0EwRLcUe1fobtB3v?=
 =?us-ascii?Q?e+HNjAfvqt+C3O7xweHK+b4CTF5eSA+pg+6UB8Z8pySvUfcYd+9GeI2etu+m?=
 =?us-ascii?Q?hAz/xxE3N6ODJCY7FH0Rd1jljaBhDJ/oY9LlAqWI6kifHRN2+0HNGQZrwvv3?=
 =?us-ascii?Q?rCyYTXZK7DU+ssfbumcOJeFdxkFY/r/jfzyaKj3QLV1s/6529CEo8N7eVtGG?=
 =?us-ascii?Q?k64TKDmqSYFD7Hbaak5ECgLNCg8P3jiKewvLF1V2UPcgnnpetLxfaCoMYpAU?=
 =?us-ascii?Q?L/pCkln6/w6rMBgt9Kuy0NqJ+oJ6GAHQPHhWMaRPRf7nycmA2UeFOHmNZcQ8?=
 =?us-ascii?Q?Et21cCCCVIPROQ5s2QDMUpVfCRUQC2A+pz70iUPfYC/f4+ayQ/nzFcEkWvSy?=
 =?us-ascii?Q?OXuWwCBzuh7SvGRa0SBRF8rHdOYuV7Gd4HH4QF83O1uWWwRauNRLlE/UpE4e?=
 =?us-ascii?Q?8XP76dZgah3oyPX/AV5QJThmq8P9IR0sh1wo0aPvX0GTiUpE8cmnleDePXeB?=
 =?us-ascii?Q?La6RWvLm5Jj7nCrUdOKj1v9uftaM944YcrnbAUNMC6R3mAEFzPS8NKkpELyK?=
 =?us-ascii?Q?Av6A+XZrKnTQ7wm4H6dr/Ko0hDWZRo4B52q4K60yRRy3f1g7JrcR4RVvtZLp?=
 =?us-ascii?Q?QDs95zilHcM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pgZWZeBewfVlyslnvbDfoU683yX4nbqGbKX5XrmAIdngkQhehQ6kzQwRMirR?=
 =?us-ascii?Q?uhZAfeY+gFhrhZttafMKURZc2BUXWYsnQ+TPbUm1Nf60xi3sYab4xD4CiafV?=
 =?us-ascii?Q?xbMtiTNZvfl9z8WG21E3xKZsPI+VolAC3LrgqyNTo0CUn12kmFuy7l86WavV?=
 =?us-ascii?Q?YeuLpDW6gmdVhO4zb+xUeNXfCplI6fDPlMQTh0De9A2CNfF33bc1g+NV7+QP?=
 =?us-ascii?Q?YIElgfi347jR6HrkMM+fA+18gFLhW2aROfUdH0kpSE/W5Et0eCgiOZF/ibs8?=
 =?us-ascii?Q?gKd08ywPd9ILbH8XOupwwRt3+pAb4N7RoqV28RAKCT1INKUMEXweqOdYLPhz?=
 =?us-ascii?Q?DUuQY5S8Pg7EMNETvLlQnA9ujPbGqie6yZzGzdpkQjnqAxAeElyQdZLLx2Wa?=
 =?us-ascii?Q?LE+MigH2tqIczn1884DIEFBrq4F0TvL24DIIVTYNpfk6yMRAvmzj10WlAIJR?=
 =?us-ascii?Q?utMR5CHfDbYNJ3IWaMccqoapG9zS953HnCH4l1AVdiINgUrJ03FpfKs+lWwT?=
 =?us-ascii?Q?GaWBKaHPFFtGGu8voELqYbDyt+4J8KKOXiEoeZa66F6wJ4JX6qbSR/lh4g0h?=
 =?us-ascii?Q?MzQtOxP+g2cN7bnEnLGyCFHRyD+QpD7BoitJxk9+RkH7Mp5GxDVKbHlYWZGc?=
 =?us-ascii?Q?Bdpb39F6o3UWr3/uxfcQ9I8PhvMs7Xd0RnAaD33n7XZXu7Kq+YGcllsUx1Y5?=
 =?us-ascii?Q?JbrMT4LOWq0neTbIS3a4CxpefVoAu9mtJC8+8pRGUE8h926EPeJWJjthxZ4s?=
 =?us-ascii?Q?fT5RLndpN3TmNG6BpWb+BVSoL9ZXyMU+Syu5leVR6DNy0ybwecMSATx5xzfd?=
 =?us-ascii?Q?ZQ71T7h56Yp6jhRFS6mVIDkIfNhyoK5WXl/2Wouxbp0vnS7sluuT1ewawzxp?=
 =?us-ascii?Q?yEjR5QwOW0Eji5w/DduBSeOPcEQQlNyoSQAq6iMbmQWWCnn3K00L/AP54Hmg?=
 =?us-ascii?Q?V84Np2PFbV8n4sPXTr6NsqER4Qgg8vji94vZ1NUhNdtWiSgVcdMhb2ssHApd?=
 =?us-ascii?Q?tSHHSBRRNI3OgduJqrAt1XMsQQtJ+qsuRftNqpKfkFHrDsJDUvWBKasveJUh?=
 =?us-ascii?Q?8ySKszrgB9xnBE7hq2kWNmwe46trpCnCWd5mK8Gm0YdIRHf/BcB+UkEIkDT8?=
 =?us-ascii?Q?2fSve/+rnRdWI328GkUGSGmxKnNxSrZSIyesFOPmSSxUp/V82pWGE4SBQ/bp?=
 =?us-ascii?Q?xlv8BipliwBHSwOJSolL8YqS3RRP4L3J2qt1g67QzUuv+VXvjFpeNJMOOW+h?=
 =?us-ascii?Q?PZn71WijB/oVcm+Ml/bczlwvr09bSfct/8NTTKzMjkwEMy7nA697FOwC23Nw?=
 =?us-ascii?Q?mjeoiYFGBZRXBnyZqRYXCDz3hqXlq7sQStwKtTv5NG/N20hsD7zcLSh9zfYi?=
 =?us-ascii?Q?z+yPoNG02u7pYk92wVsCucLsCvH5mmgo/IoDU+N7CU2RdemNdSsOvdTnS0zm?=
 =?us-ascii?Q?qAb03fFeFOnzzbRODJJP8ziYD/e2b3GaEFEteLkng+B1ZDp2tKQ0HUaS9rNh?=
 =?us-ascii?Q?wAVlvA2VjeHaUgLLlCdMbTUJfSxWRN5DBTAwxZLrjttt6jPl/IDxXN2siD++?=
 =?us-ascii?Q?WfFgphv2WgC3krWzHR8Kfj3kJ7ffUzyMIwAciQu50E3dgPTlQAkvvEkHOMZa?=
 =?us-ascii?Q?Og=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OncK1gsIy5BXDzALg/K9Tt2tHi2x/RGlc4Zkd5w9EWGRrbiN3GTVuCXyd4nT354L7bv20GZ1Ele/92Yz5UHxFINo5fhNODNfSoH3tAahukVntMyGT6kv1lvtI5IPHjg+vSeXiSDyuKrNFRePvvS697rA3cPx0IIgttOX3QKO7jRyHEYUxVKBcWa7enu/qn3GlrSkDweV1aHsmpCfpCpwLTyN2haPvYjr105UhoqAYi09DPcrLQ98LGe71O8S7wa3mMkFiMnvfl15mj9yqIUt9nm34c/MQaHf5EkvaEJi8VdKX2/SkaGlabrT74r8eCgOta2HpcFs60fLjkcEPXbKi4ml7VkOi/FwTZx6yOLiNt1hGRWfkX8BOh52iultd0ahW34nD1ALzxVhVwscgi7eg0+OaDiwAbZ7zP/2vz1UQHKQNDsFD/b0HPmiDwTDg7MGLuS8HN4na0xbiFu9YEIcNQvww3WQFj+SqYplzCVFGf87cAoJvy3vXfE/0h1mjiI+sfVTdfVyeY75I28O31EUWeQ4QP3QnGBHV4aYI6xKzVhhP8dPJnAr+xmhX5kLzC7Qsj8vQ2LoScC2jt454zMc8JGtES46dS07qaZyylIE3sI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 367a9547-dd82-49f6-6b75-08dde0c81e40
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 15:33:46.2698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ncLSNuKgh9nlfYZQWIQSEPaBd1pjwLW3Qqfdhlech7VucBWTEQ4oqnWoC4glD1QgtNl64uRkY/s0ISz+EVEXhYnP71F2mpjAD4AQCkte9pE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6895
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-21_03,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508210127
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfXyjluivS5xjt7
 riFQwQWeMM09wKORMtASPJGSfv8fn+F/phwRBLvZkAeVOzle0X9EPveY1jqQ2nLiU8pdotvKwlX
 2CM9RVEdxETUoZMq79firXZJNqyivGKZnaa6bffnd1kIodzBQBDuSyicxhXUpRTfY289z7VLtdG
 uheMFqn/6093dX3WNmk/pdEdI2HxdvTnfYj69skZeIjlesrps17rdZkb41NTy1t3vvfurg4i2q5
 cGBOkki/xw6WdLYX1qDz4bJecqriuHxyg2E3K71FOO0oYfmeC3yuAN7wKgkvJsaAvXwFWddHdR5
 d2yvdM1RpXW1i4sOLFLmCJX5S+uFvqMoW24PRQguCzw5OpQCBNC2+SviXgOCsLRkJmBdeyX4HZG
 2uhGbZ91qVSNWWRGYzPtdd68Xj64wpPABNA/Jd9nhr9hVdPsvDg=
X-Proofpoint-GUID: FJx1nlEH2cxWUKlfIZjlNmKyGFF3G6Il
X-Proofpoint-ORIG-GUID: FJx1nlEH2cxWUKlfIZjlNmKyGFF3G6Il
X-Authority-Analysis: v=2.4 cv=V94kEeni c=1 sm=1 tr=0 ts=68a73c61 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=yPCof4ZbAAAA:8 a=3Bx5ZlvmnHS0VstKNO8A:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:13600
X-Rspamd-Queue-Id: CD283100011
X-Rspam-User: 
X-Stat-Signature: imw7toe3w8oax5byheme6bdjrupf15sa
X-Rspamd-Server: rspam09
X-HE-Tag: 1755790439-90529
X-HE-Meta: U2FsdGVkX1+KfnXRf2ZXkN5UbuGc8BVkegvAOsf1Hetlt7On7L0eZbb0xoGnQnRp8saz64/lrQxgO5DlDXJKN2Xa0hvHdZDXAYNu70aft0YEmZ7NW1va1YF3Q19CQIfosqzjpHcZ3PzY6zRzAsvfPA913scsuJHoQHwq459b9AqzraGADWjSgOAX9bvJCMwXIsHBNaCZXTqmBR+rtXCA0ELl0LJ+h/cjtIQ8vW2dhDaUHUlge1Tkd+ZvSvLPu7cWwnUnZKZ5yrzL129OFPKQpfKsxKC35KhNAia9+Ro9rPLpgKvTMO5qLlnTQT5K3NNpINftxsgVF/4H0ohXHLJJHhVchn9X2YEHY9QjWl7uCWBGYYd4GNKG7/DV6EeMV9WUdYCzUZcgG3kmYgmK/ihIkNQ5h+sFhIcxIec6cGCP+UtOEh3H0AOd0IQk4oiNATqwEUafWKfL5WmcL+STzBya5J9N9v73If4BKyvaoTNwy/NSY4T4G4kI4Wj9OGE8BUpNJHEKqbF+9RBwaLBHQKjU38iETyD3JAqD0QdboO8c/nF4qQGTdbXLi/4KzyaQEfi7qN/BJYOcLqqqC9Dcu2IrwQyVrix6dl+rWfffpo042AqF0fseeazQRPjYeAQ72zBo91EuKbfpkJ7AleH8sY++qY5O/5jcqbz0W0cA3VWL7t5E+CppFkgzHim8MN259Q4UImvpVaCML8Z0J6oYBKGzD8n7XRs86sg7DDV2iAEvkYVLoiGOsl+QCkRlW6Pc76L3Jhl3aF0RwznHHfCHiPNERwvmRJNAFGIdJgyacZHnWl6FXXFPgraW+j5uUv+oWxyAAu3MBC3Ums4SV7xZmIAYM2UCeHG3mFzPCRHF3tUFoD2eOccr4EzasrelCsvUelpmUwH/7Hfbg+eeG9i7LlZ6XXSRg0PBBYCXpIIerZKE6AAkVkUQEdRkt8eETo0r4yWA/a/NvHwi/oiMkxd4w4k
 Z6UFyLAp
 UJwZO66k08bO73Oom5wXev3Vt/OSH24A9fjRgTMWhZUefEBGkpy49d4upOMssjcZG+oBjQwS+Qg4ctvbNoUXzTdADAs69o/+OYMpW5fzsSJnTImJxVy2RwsMuanerCi8VKfe4hQDxgAfTS/kCRs/Gyl6qYEAw1daGlWdOyXMZGPeKnC/RvviPvMcMwaXQ1PGfeLNL3ThLDKfeZbk4rxvBgX9yBNdeVGCvKjMrcNWDyqKe5N198KCxxL2kpljYtnkj7cQBq61oU9LdB++erCVdqYOvYlbWKpsdFU/1FGvH8kF3jHFedUxg4lJ3OBRBVsMctRSixIiJlsBx9nSGLQg6Fcz8T4+rdQ+TQG9Jbh0wQlZvQorvAz8aRlNmoxRjfdjZxIC5lkMZGegmbDL8qXDeFS2XnKrsDME/+IREYeQDcJ1YdDIbeh+WGCp+Lnsajf5erO/NFAuegiNrVogXtNQjAwcNrjIn6DvwIqB1Ck3b0f43BSQKzlAC8t7J2QPMQ7JP6w0lMw5hHCLzbvwExHPPyCkQYhzeqvh15F1NpHsR+jQFqyMqJgiHOZHBFKEq/M6HE1dEHcsfz/PdtG7uzy7x8WgeHTWi8VVPVvupKvYlfsAPO8NGQi8ZImxg9YAgRVCXu/D6a2oCjFmXesHGT3Hz97KXOHuS5GrWM4UexkqrwFDM0RTZ1qmhu/Je+ahNZgLXeg5gtc8eYklI54a3Drtrfl8m7vseXbMudQCWxG7ip0GlbjC51e6RZ4L7BWs662vA8C7dl4aK88nM0OkIQc3i+9ZqmEw4f8FPFi570X3UApFmhoNXf5xPRPsf6O3ZtcU5A7Y0Z+NzHtx8t0A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 04:00:38PM +0100, Usama Arif wrote:
> Using forced_collapse directly is clearer and enforce_sysfs is not
> really needed.

NIT, but would prefer a little more detail here e.g.:

	mm/huge_memory: rename variable for clarity

	There's no need to define a new local variable in
	__thp_vma_allowable_orders(), it's simply clearer to use the
	existing forced_collapse value to determine whether to force a
	collapse.

>
> Signed-off-by: Usama Arif <usamaarif642@gmail.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
> This was agreed upon in [1]
> [1] https://lore.kernel.org/all/cd99f0f2-260d-4494-bbf6-99daec3e0683@gmail.com/
> ---
>  mm/huge_memory.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 6fd714bd04844..5220dbc9fcb31 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -105,7 +105,6 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>  	const bool smaps = type == TVA_SMAPS;
>  	const bool in_pf = type == TVA_PAGEFAULT;
>  	const bool forced_collapse = type == TVA_FORCED_COLLAPSE;
> -	const bool enforce_sysfs = !forced_collapse;
>  	unsigned long supported_orders;
>
>  	/* Check the intersection of requested and supported orders. */
> @@ -168,14 +167,14 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>  	if (!in_pf && shmem_file(vma->vm_file))
>  		return orders & shmem_allowable_huge_orders(file_inode(vma->vm_file),
>  						   vma, vma->vm_pgoff, 0,
> -						   !enforce_sysfs);
> +						   forced_collapse);
>
>  	if (!vma_is_anonymous(vma)) {
>  		/*
> -		 * Enforce sysfs THP requirements as necessary. Anonymous vmas
> +		 * Enforce THP collapse requirements as necessary. Anonymous vmas
>  		 * were already handled in thp_vma_allowable_orders().
>  		 */
> -		if (enforce_sysfs &&
> +		if (!forced_collapse &&
>  		    (!hugepage_global_enabled() || (!(vm_flags & VM_HUGEPAGE) &&
>  						    !hugepage_global_always())))
>  			return 0;
> --
> 2.47.3
>
>

